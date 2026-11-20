# -*- coding: utf-8 -*-
"""보완 영향 범위 산출(EN-23 · 2026-11-11) — 직전 정합검증 뒤에 '실제로 바뀐 것'을 측정하고, 그 변경이 걸리는 원장 행·검사 규칙을 사실로 계산한다.

  python tools/Harness/verify/repair_scope.py <MENU_ID>                         직전 정합검증 시작 시각 이후 변경
  python tools/Harness/verify/repair_scope.py <MENU_ID> --since "2026-11-10 21:37:58"
  python tools/Harness/verify/repair_scope.py --selftest
  → Doc/verify/<ID>/repair_scope.json  {since, changes[], rows[], rules[], full_recommended, why}

왜: 보완 증명 루프(repair_close.py)가 재판정할 규칙을 사람·AI 가 고르고 있었다(추측 지점 원장 REPAIR). 무엇을 고쳤는지는 자기 보고가 아니라 측정한다.
변경 측정(모두 읽기 전용):
  DB 객체  ALL_OBJECTS.LAST_DDL_TIME > since — 이 화면 PROC_M 배선에 나오는 PKG(Doc/tobefacts/db/proc_meta.csv)만
  메타     SCM_MST_SHEET_COLUMNS · SCM_MST_SHEET_MEASURE(PROGRAM_ID) · SCM_ADM_MNU_BTN_MPG_M(MNU_ID) · SCM_ADM_CMBO_SQL_M(이 화면이 부른 콤보) 의 LAST_UPDATE_DATE > since
  FE      화면 페이지 폴더(Doc/e2e/specs/<ID>.plan.json routePath) 파일의 수정 시각 > since
영향 계산(원장 verify_ledger.csv 의 사실 열만 사용):
  PKG 변경   → 그 PKG 의 PROC 이름이 target 인 행 + condition 에 그 PROC 의 sheet/btn 이 있는 행 + target 이 그 시트 컬럼(시트명.)인 행
  컬럼 메타  → target 이 '시트명.컬럼명' 인 행        버튼 메타 → condition·target 에 그 시트/버튼이 있는 행      콤보 SQL → evidence·target 에 그 SQL_ID 가 있는 행
  FE 변경   → 파일에서 화면 범위를 좁힐 사실이 없다 → 열린 조치 필요 행 전체 + full_recommended=true (전체 CheckList 권고 · 추측으로 좁히지 않는다)
한계: PKG 는 객체 단위 시각만 있다(어느 PROC 이 바뀌었는지는 모름 → 그 PKG 의 이 화면 PROC 전부). 공용 컴포넌트·공용 PKG 변경이 다른 화면에 주는 영향은 계산하지 않는다.
"""
import csv
import json
import os
import re
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
csv.field_size_limit(10 ** 8)


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def impact(changes, ledger, open_rows):
    """순수 함수 — changes[{type, ...}] → (row_id→사유, full_recommended, why)"""
    hit, full, why = {}, False, []

    def add(r, reason):
        hit.setdefault(r['row_id'], reason)
    for ch in changes:
        t = ch['type']
        if t == 'PKG':
            procs = [p.upper() for p in ch.get('procs', [])]; sb = [(x['sheet'], x['btn']) for x in ch.get('calls', [])]; sheets = {s for s, _ in sb}
            for r in ledger:
                tg = (r.get('target') or ''); cd = (r.get('condition') or ''); tu = tg.upper()
                if any(p in tu for p in procs):
                    add(r, f"PKG {ch['name']} 변경 — 대상이 그 PROC")
                elif any(f'"sheet": "{s}", "btn": "{b}"' in cd or cd.strip() == f'{s}/{b}' for s, b in sb):
                    add(r, f"PKG {ch['name']} 변경 — 그 PROC 을 부르는 {'/'.join(sb[0])} 등")
                elif r.get('source') == 'COLUMN' and any(tg.startswith(s + '.') for s in ch.get('sheet_names', [])):
                    add(r, f"PKG {ch['name']} 변경 — 그 시트의 컬럼 행")
            _ = sheets
        elif t == 'SHEET_COLUMN':
            key = f"{ch['sheet']}.{ch['column']}"
            for r in ledger:
                tg = r.get('target') or ''
                if tg == key or tg.startswith(key + ' ') or tg.startswith(key + '('):
                    add(r, f'컬럼 메타 {key} 변경')
        elif t == 'SHEET_MEASURE':
            for r in ledger:
                if ch['sheet'] in (r.get('target') or '') and re.search(r'(?i)measure', (r.get('target') or '') + (r.get('expected') or '')):
                    add(r, f"Measure 메타 {ch['sheet']} 변경")
        elif t == 'BUTTON':
            for r in ledger:
                s = (r.get('condition') or '') + ' ' + (r.get('target') or '')
                if f'"sheet": "{ch["sheet"]}"' in s or f'{ch["sheet"]}/' in s:
                    add(r, f"버튼 배선 {ch['sheet']} 변경")
        elif t == 'COMBO':
            for r in ledger:
                if ch['sql_id'] in ((r.get('evidence') or '') + ' ' + (r.get('target') or '') + ' ' + (r.get('condition') or '')):
                    add(r, f"콤보 SQL {ch['sql_id']} 변경")
        elif t == 'FE':
            full = True
    if full:
        why.append('FE 파일 변경 — 파일에서 영향 규칙을 좁힐 사실이 없어 열린 조치 필요 행 전체를 대상에 넣고 전체 CheckList 를 권고')
        by = {r['row_id']: r for r in ledger}
        for rid in open_rows:
            if rid in by:
                hit.setdefault(rid, 'FE 변경 — 열린 조치 필요 행')
    return hit, full, why


def selftest():
    L = [{'row_id': 'a', 'source': 'SP', 'rule_id': 'F10', 'target': 'PKG_X.P_X_SAVE', 'condition': 'main/SAVE', 'evidence': ''},
         {'row_id': 'b', 'source': 'TRACE', 'rule_id': 'A6', 'target': 'PKG_X.P_X_GET', 'condition': '{"callProc": [{"menu": "X", "sheet": "main", "btn": "SEARCH"}]}', 'evidence': ''},
         {'row_id': 'c', 'source': 'COLUMN', 'rule_id': 'H1', 'target': 'Main Sheet.QTY (Qty)', 'condition': '', 'evidence': ''},
         {'row_id': 'd', 'source': 'COLUMN', 'rule_id': 'D1', 'target': 'Other.QTY (Qty)', 'condition': '', 'evidence': ''},
         {'row_id': 'e', 'source': 'SEARCH', 'rule_id': 'B7', 'target': '조회조건 Company', 'condition': '', 'evidence': '콤보 CompanyByDivision 응답 5건'},
         {'row_id': 'f', 'source': 'RULE_SCREEN', 'rule_id': 'K3', 'target': 'X 화면', 'condition': '', 'evidence': ''}]
    h1, f1, _ = impact([{'type': 'PKG', 'name': 'PKG_X', 'procs': ['P_X_SAVE', 'P_X_GET'], 'calls': [{'sheet': 'main', 'btn': 'SEARCH'}, {'sheet': 'main', 'btn': 'SAVE'}], 'sheet_names': ['Main Sheet']}], L, [])
    h2, f2, _ = impact([{'type': 'SHEET_COLUMN', 'sheet': 'Main Sheet', 'column': 'QTY'}], L, [])
    h3, f3, _ = impact([{'type': 'COMBO', 'sql_id': 'CompanyByDivision'}], L, [])
    h4, f4, _ = impact([{'type': 'FE', 'file': 'x.tsx'}], L, ['f'])
    cases = [('PKG 변경 → PROC 대상 행·호출 행·시트 컬럼 행', set(h1) == {'a', 'b', 'c'} and not f1), ('컬럼 메타 → 그 컬럼 행만', set(h2) == {'c'} and not f2),
             ('콤보 SQL → 근거에 그 SQL_ID 가 있는 행', set(h3) == {'e'} and not f3), ('FE 변경 → 열린 행 + 전체 권고', set(h4) == {'f'} and f4), ('변경 없음 → 대상 없음', impact([], L, ['f'])[0] == {})]
    bad = 0
    for n, ok in cases:
        bad += 0 if ok else 1
        print(f"{'OK ' if ok else 'NG '} {n}")
    print(f"{len(cases) - bad}/{len(cases)}")
    return 1 if bad else 0


def measure(mid, since):
    """실측 변경 목록 — DB 는 읽기 전용 조회"""
    from dbconn import connect
    ch, notes = [], []
    pm = [r for r in rd(os.path.join(ROOT, 'Doc', 'tobefacts', 'db', 'proc_meta.csv')) if (r.get('menu_id') or '').upper() == mid and r.get('pkg')]
    pkgs = sorted({r['pkg'].upper() for r in pm})
    sheet_names = sorted({r['sheet_name'] for r in rd(os.path.join(ROOT, 'Doc', 'tobefacts', 'db', 'sheet_columns.csv')) if (r.get('program_id') or '').upper() == mid})
    combos = sorted({r['combo_id'] for r in rd(os.path.join(ROOT, 'Doc', 'verify', mid, 'combo_live.csv')) if r.get('combo_id')})
    with connect('tobe') as cx:
        c = cx.cursor()
        if pkgs:
            # 바인드는 번호가 아니라 SQL 에 나오는 순서로 묶인다 → 날짜 조건을 IN 목록 앞에 둔다(2026-11-11 첫 실측 ORA-01841)
            c.execute("SELECT OBJECT_NAME, OBJECT_TYPE, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE LAST_DDL_TIME > TO_DATE(:1,'YYYY-MM-DD HH24:MI:SS') "
                      f"AND OWNER='SCM_MGR' AND OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION') AND OBJECT_NAME IN ({','.join(':' + str(i + 2) for i in range(len(pkgs)))})", [since] + pkgs)
            seen = {}
            for n, t, d in c.fetchall():
                seen.setdefault(n, []).append(f'{t} {d}')
            for n, v in seen.items():
                rows = [r for r in pm if r['pkg'].upper() == n]
                ch.append({'type': 'PKG', 'name': n, 'at': '; '.join(v), 'procs': sorted({r['proc_nm'] for r in rows}), 'calls': [{'sheet': r['sheet'], 'btn': r['btn']} for r in rows], 'sheet_names': sheet_names})
        c.execute("SELECT SHEET_NAME, COLUMN_NAME, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:1 AND LAST_UPDATE_DATE > TO_DATE(:2,'YYYY-MM-DD HH24:MI:SS')", [mid, since])
        ch += [{'type': 'SHEET_COLUMN', 'sheet': s, 'column': col, 'at': d} for s, col, d in c.fetchall()]
        c.execute("SELECT DISTINCT SHEET_NAME, TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI:SS') FROM SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID=:1 AND LAST_UPDATE_DATE > TO_DATE(:2,'YYYY-MM-DD HH24:MI:SS') GROUP BY SHEET_NAME", [mid, since])
        ch += [{'type': 'SHEET_MEASURE', 'sheet': s, 'at': d} for s, d in c.fetchall()]
        c.execute("SELECT DISTINCT SHT_NM, TO_CHAR(MAX(LAST_UPDATE_DATE),'YYYY-MM-DD HH24:MI:SS') FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID=:1 AND LAST_UPDATE_DATE > TO_DATE(:2,'YYYY-MM-DD HH24:MI:SS') GROUP BY SHT_NM", [mid, since])
        ch += [{'type': 'BUTTON', 'sheet': s, 'at': d} for s, d in c.fetchall()]
        if combos:
            for i in range(0, len(combos), 200):
                part = combos[i:i + 200]
                c.execute("SELECT SQL_ID, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE LAST_UPDATE_DATE > TO_DATE(:1,'YYYY-MM-DD HH24:MI:SS') "
                          f"AND SQL_ID IN ({','.join(':' + str(k + 2) for k in range(len(part)))})", [since] + part)
                ch += [{'type': 'COMBO', 'sql_id': s, 'at': d} for s, d in c.fetchall()]
    # FE — 화면 페이지 폴더
    try:
        plan = json.load(open(os.path.join(ROOT, 'Doc', 'e2e', 'specs', f'{mid}.plan.json'), encoding='utf-8'))
        rp = plan.get('routePath') or ''
        feat, page = (rp.split('/') + [''])[:2]
        pdir = os.path.join(ROOT, 'nscm-fe', 'features', feat, 'src', 'pages', page)
        t0 = time.mktime(time.strptime(since, '%Y-%m-%d %H:%M:%S'))
        if os.path.isdir(pdir):
            for dp, _, fs in os.walk(pdir):
                for f in fs:
                    p = os.path.join(dp, f)
                    if os.path.getmtime(p) > t0 and not re.search(r'\.bak|\.md$', f):
                        ch.append({'type': 'FE', 'file': os.path.relpath(p, ROOT).replace(os.sep, '/'), 'at': time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(os.path.getmtime(p)))})
        else:
            notes.append(f'FE 페이지 폴더 없음({rp}) — FE 변경 미측정')
    except (OSError, ValueError):
        notes.append('plan.json 없음 — FE 변경 미측정')
    notes.append(f"측정 범위: PKG {len(pkgs)}개({', '.join(pkgs)[:120]}) · 시트 {len(sheet_names)}개 · 콤보 {len(combos)}개")
    return ch, notes


def main():
    a = sys.argv[1:]
    if '--selftest' in a:
        return selftest()
    if not a or a[0].startswith('--'):
        print(__doc__); return 3
    mid = a[0].upper(); vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    since = a[a.index('--since') + 1] if '--since' in a else ''
    if not since:
        try:
            since = json.load(open(os.path.join(vd, 'run_verify.result.json'), encoding='utf-8')).get('started', '')
        except (OSError, ValueError):
            since = ''
    if not since:
        print(f'[repair_scope] {mid}: 기준 시각 없음(run_verify.result.json started) — --since 로 지정'); return 3
    ledger = rd(os.path.join(vd, 'verify_ledger.csv'))
    if not ledger:
        print(f'[repair_scope] {mid}: verify_ledger.csv 없음'); return 3
    open_rows = [r['row_id'] for r in rd(os.path.join(vd, 'fixlist.csv')) if (r.get('action_needed') or '').upper() == 'Y']
    changes, notes = measure(mid, since)
    hit, full, why = impact(changes, ledger, open_rows)
    by = {r['row_id']: r for r in ledger}
    rows = [{'row_id': k, 'rule_id': by[k].get('rule_id', ''), 'result': by[k].get('result', ''), 'target': (by[k].get('target') or '')[:80], 'reason': v, 'open': k in set(open_rows)} for k, v in hit.items()]
    rules = sorted({r['rule_id'].upper() for r in rows if r['rule_id'] and not r['rule_id'].startswith('X-')})
    kinds = {}
    for ch in changes:
        kinds[ch['type']] = kinds.get(ch['type'], 0) + 1
    out = {'at': time.strftime('%Y-%m-%d %H:%M:%S'), 'menu_id': mid, 'since': since, 'changes': changes, 'change_counts': kinds, 'rows': rows, 'rules': rules,
           'open_rows_hit': [r['row_id'] for r in rows if r['open']], 'full_recommended': full, 'why': why, 'notes': notes}
    json.dump(out, open(os.path.join(vd, 'repair_scope.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(f"[repair_scope] {mid} · 기준 {since} 이후 변경: " + (' · '.join(f'{k} {v}' for k, v in kinds.items()) or '없음'))
    for ch in changes[:20]:
        print('  ' + ' '.join(f'{k}={str(v)[:70]}' for k, v in ch.items() if k not in ('procs', 'calls', 'sheet_names')))
    print(f"[repair_scope] 영향 행 {len(rows)}(그중 열린 조치 필요 {len(out['open_rows_hit'])}) · 규칙 {len(rules)}개: {','.join(rules)[:200]}" + (' · 전체 CheckList 권고' if full else ''))
    for n in notes + why:
        print(f'  · {n}')
    print(f"[repair_scope] → Doc/verify/{mid}/repair_scope.json")
    return 0


if __name__ == '__main__':
    sys.exit(main())
