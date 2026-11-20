# -*- coding: utf-8 -*-
"""레시피 자동 적용기(보완실행 단계 · 2026-11-08 사용자 결정 '남은 것 진행' ③) — fixlist.csv × fix_recipes.csv 중 auto_apply=Y 이고 sql_template 이 있는 DB 레시피만

  python tools/Harness/verify/repair_apply.py <MENU_ID>              dry-run(기본): 대상 행·치환된 SQL·현재 원문 행 수만 출력(쓰기 0)
  python tools/Harness/verify/repair_apply.py <MENU_ID> --apply      적용: hook #152 절차 — ① 원문 재조회(새로고침) ② before 백업(JSON) ③ 가드 UPDATE(WHERE 에 현재 값 조건 포함 · 0행/2행+ 는 중단)
                                                                       ④ 재조회 검증 ⑤ _artifacts/_apply_corporate/<ID>_REPAIR_<ts>/APPLIED_OPERATIONS.md 기록 ⑥ 다음 명령(부분 재판정 --only <규칙>) 안내 — 자동 재판정은 하지 않는다
  python tools/Harness/verify/repair_apply.py --selftest             템플릿 치환·대상 파싱·가드 판정 변이(DB 없음)

범위: DB_META·DB_OBJECT 레시피만(FE·COMMON·HUMAN 은 적용 대상 아님 — 가이드) · repairScope 와 무관하게 DB 는 적용 가능(사용자 상시 승인 · 사내 ZIOUI1) · 한 행이라도 가드가 맞지 않으면 그 행은 SKIP(추정 금지)
대상 파싱: fixlist target '<시트>.<컬럼> (<라벨>)' → {sheet},{column},{label} · 그 밖 {mid},{row_id}
"""
import csv, io, json, os, re, sys, time

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
RX_TARGET = re.compile(r'^(?P<sheet>[^.]+)\.(?P<column>[A-Z0-9_]+)(?:\s*\((?P<label>[^)]*)\))?\s*$')


def rd(p):
    return list(csv.DictReader(io.open(p, encoding='utf-8-sig'))) if os.path.exists(p) else []


def render(tpl, mid, f):
    m = RX_TARGET.match(f.get('target') or '')
    vals = {'mid': mid, 'row_id': f.get('row_id', ''), 'sheet': (m.group('sheet') if m else '').replace("'", "''"), 'column': m.group('column') if m else '', 'label': (m.group('label') if m and m.group('label') else '').replace("'", "''")}
    out = tpl
    for k, v in vals.items():
        out = out.replace('{' + k + '}', v)
    missing = re.findall(r'\{[a-z_]+\}', out)
    return out, vals, missing


def plan(mid):
    fx = rd(os.path.join(ROOT, 'Doc', 'verify', mid, 'fixlist.csv'))
    rc = rd(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'fix_recipes.csv'))
    items = []
    for f in fx:
        if (f.get('action_needed') or 'N') != 'Y' or f.get('layer') not in ('DB_META', 'DB_OBJECT'):
            continue
        r = next((x for x in rc if x.get('rule_id') == f['rule_id'] and (x.get('layer') or '*') in (f['layer'], '*') and (x.get('auto_apply') or 'N').upper() == 'Y' and (x.get('sql_template') or '').strip()), None)
        if not r:
            continue
        sql, vals, missing = render(r['sql_template'], mid, f)
        items.append({'fix': f, 'recipe': r, 'sql': sql, 'vals': vals, 'missing': missing})
    return items


def guard_select(sql):
    """UPDATE … WHERE … → 같은 WHERE 로 SELECT COUNT(*) · 원문 조회용 SELECT *"""
    m = re.match(r'^\s*UPDATE\s+(\S+)\s+SET\s+.*?\s+WHERE\s+(.+)$', sql, re.I | re.S)
    if not m:
        return None, None
    t, where = m.group(1), m.group(2)
    return f'SELECT COUNT(*) FROM {t} WHERE {where}', f'SELECT * FROM {t} WHERE {where}'


def selftest():
    f = {'row_id': 'V-00000000', 'target': "Sales Site Priority.VALID_YN (Valid*)", 'rule_id': 'LB1', 'layer': 'DB_META', 'action_needed': 'Y'}
    tpl = "UPDATE SCM_MGR.T SET X = 1 WHERE PROGRAM_ID = '{mid}' AND SHEET_NAME = '{sheet}' AND COLUMN_NAME = '{column}' AND L = '{label}'"
    sql, vals, missing = render(tpl, 'SCP0131', f)
    cases = [('치환 — 시트', "SHEET_NAME = 'Sales Site Priority'" in sql, True), ('치환 — 컬럼', "COLUMN_NAME = 'VALID_YN'" in sql, True), ('치환 — 라벨', "L = 'Valid*'" in sql, True), ('미치환 자리 0', not missing, True),
             ('가드 SELECT 생성', guard_select(sql)[0].startswith('SELECT COUNT(*) FROM SCM_MGR.T WHERE'), True), ('WHERE 없는 SQL 거부', guard_select('UPDATE T SET X=1')[0] is None, True),
             ("대상 형식 밖 → 빈 시트", render(tpl, 'X', {'target': '화면 전체'})[1]['sheet'] == '', True), ("따옴표 이스케이프", "''" in render("'{sheet}'", 'X', {'target': "A'B.C (d)"})[0], True)]
    bad = 0
    for n, got, want in cases:
        ok = got == want; bad += 0 if ok else 1; print(f"{'OK ' if ok else 'NG '} {n}")
    print(f'{len(cases) - bad}/{len(cases)}'); return 1 if bad else 0


def main(mid, apply=False):
    mid = mid.upper(); items = plan(mid)
    print(f"[repair_apply] {mid}: 자동 적용 후보 {len(items)}건(auto_apply=Y · sql_template 있음 · DB 계층 · 조치 필요)")
    if not items:
        return 0
    from dbconn import connect
    ts = time.strftime('%Y%m%d_%H%M'); outdir = os.path.join(ROOT, '_artifacts', '_apply_corporate', f'{mid}_REPAIR_{ts}')
    log = []; applied = 0; skipped = 0
    with connect('tobe', write=apply) as cx:
        cur = cx.cursor()
        for it in items:
            f, r, sql = it['fix'], it['recipe'], it['sql']
            head = f"{f['fix_id']} {f['rule_id']} {f['target'][:60]} — 레시피 {r['rule_id']}/{r['layer']}({r.get('source') or ''})"
            if it['missing']:
                print(f'  SKIP {head}: 치환 안 된 자리 {it["missing"]}'); skipped += 1; continue
            cnt_sql, sel_sql = guard_select(sql)
            if not cnt_sql:
                print(f'  SKIP {head}: UPDATE … WHERE 형식이 아님'); skipped += 1; continue
            cur.execute(cnt_sql); n = cur.fetchone()[0]
            print(f"  {'APPLY' if apply else 'DRY '} {head}\n       대상 행(원문 재조회) {n} · SQL: {sql[:200]}")
            if n != 1:
                print(f'       → SKIP: 가드 대상 {n}행(정확히 1행이어야 함 · 추정 적용 금지)'); skipped += 1; continue
            if not apply:
                continue
            cur.execute(sel_sql); names = [d[0] for d in cur.description]; before = dict(zip(names, cur.fetchone()))
            cur.execute(sql); rows_upd = cur.rowcount
            cur.execute(sel_sql); after = dict(zip(names, cur.fetchone()))
            changed = {k: (str(before[k]), str(after[k])) for k in names if str(before[k]) != str(after[k])}
            log.append({'fix_id': f['fix_id'], 'row_id': f['row_id'], 'rule_id': f['rule_id'], 'recipe': f"{r['rule_id']}/{r['layer']}", 'sql': sql, 'rows_updated': rows_upd, 'before': {k: str(v) for k, v in before.items()}, 'after': {k: str(v) for k, v in after.items()}, 'changed': changed, 'at': time.strftime('%Y-%m-%d %H:%M:%S')})
            applied += 1; print(f'       → 적용 {rows_upd}행 · 변경 {changed}')
        if apply:
            cx.commit()
    if apply and log:
        os.makedirs(outdir, exist_ok=True)
        json.dump(log, io.open(os.path.join(outdir, 'applied.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        md = [f'# 레시피 자동 적용 {mid} — {time.strftime("%Y-%m-%d %H:%M")} (사내 ZIOUI1 · repair_apply.py)', '', '| 보완 ID | 규칙 | 레시피 | SQL | 변경(전→후) | 시각 |', '|---|---|---|---|---|---|']
        md += [f"| {x['fix_id']} | {x['rule_id']} | {x['recipe']} | `{x['sql'][:160]}` | {x['changed']} | {x['at']} |" for x in log]
        md += ['', f'다음: `python tools/Harness/verify/run_verify.py {mid} --only {",".join(sorted({x["rule_id"] for x in log}))}` 로 부분 재판정(자동 실행하지 않음 · 사용자 결정) · 복원 = before 값으로 UPDATE(applied.json)']
        io.open(os.path.join(outdir, 'APPLIED_OPERATIONS.md'), 'w', encoding='utf-8', newline='\n').write('\n'.join(md) + '\n')
        print(f'[repair_apply] 적용 {applied} · SKIP {skipped} → {os.path.relpath(outdir, ROOT)}/APPLIED_OPERATIONS.md')
    else:
        print(f"[repair_apply] {'적용' if apply else 'dry-run'} 끝 — 적용 {applied} · SKIP {skipped}" + ('' if apply else ' · 실제 적용은 --apply'))
    return 0


if __name__ == '__main__':
    if '--selftest' in sys.argv:
        sys.exit(selftest())
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(1)
    sys.exit(main(sys.argv[1], '--apply' in sys.argv))
