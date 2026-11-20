# -*- coding: utf-8 -*-
"""시트별 데이터 조건 탐색(2026-11-17 SCP0104 SOP 탭 0행 미측정 대응).

기본 Division 으로 조회하면 0행인 탭·시트가 있다. 화면이 보낸 조회 호출(sqllog_calls.json)을 DB 에서 다시 실행해
시트별로 어느 조건(Division 등)에서 행이 나오는지 세고 Doc/verify/<ID>/sheet_data_cond.json·.md 로 남긴다.
E2E(tools/E2E/lib/smoke-extra.ts clickSheetTab·ensureRows)와 AS-IS 런처 시나리오(tools/AsisLive/asis_live_sheet_rows.py)가 이 파일의 div 를 먼저 쓴다.

  python tools/Harness/verify/sheet_data_cond.py <ID> [--no-asis] [--rec-only] [--max-sets 12]

후보 조건
  rec   SQL 로그에 남은 호출 인자 그대로(Division 마다 화면이 채운 Site·Plant·Line 포함)
  div   (--rec-only 가 아니면) 시트마다 첫 기록 호출에서 p_division_id 만 바꾸고 Division 에 딸린 인자(site·plant·factory·line·item)를 빈 값으로 둔 변형.
        Division 후보 = combo_runtime.json search.Div(.opts) 실측 후보
AS-IS 는 param_hint.csv 의 tobe_proc → asis_sp·@인자 짝으로 같은 값을 넣어 실행한다(.env.asis 접속 · GET 만 · 쓰기 없음).
TO-BE 는 GET 만 실행하고 호출마다 rollback 한다. 행 수 = 결과 커서 행(O_RESULT_CURSOR 상태 커서 제외).
"""
import csv, datetime, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
sys.path.insert(0, HERE); sys.path.insert(0, P('tools', 'DbConn'))
import dbconn, golden  # noqa: E402

SKIP_KEYS = {'debug_mode', 'userid'}
DIV_DEP = re.compile(r'^p_(site|plant|factory|line|item|sub_line|team)', re.I)


def rj(p, d=None):
    try:
        with open(p, encoding='utf-8-sig') as f: return json.load(f)
    except (OSError, ValueError): return d


def now(): return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def tobe_rows(cx, proc, body):
    import diff_verify
    try:
        body = {k: v for k, v in body.items() if v is not None}  # userId: null 이 P_USER_ID 자리를 None 으로 막던 결함
        sets, missing = golden.run_tobe(cx, proc, diff_verify.bind_like_be(cx, proc, body))
        n = sum(len(s[2]) for s in sets if not re.search(r'RESULT_CURSOR$', str(s[0])))
        return n, ('인자 없음 ' + ','.join(missing)) if missing else ''
    except Exception as e:  # noqa: BLE001
        return None, f'오류 {str(e)[:160]}'
    finally:
        try: cx.rollback()
        except Exception: pass  # noqa: E722


def asis_rows(ax, sp, params):
    try:
        sets = golden.run_asis(ax, sp, params)
        return max((len(r) for _, r in sets), default=0), ''
    except Exception as e:  # noqa: BLE001
        return None, f'오류 {str(e)[:160]}'


def main(argv):
    if not argv or argv[0].startswith('-'):
        print(__doc__); return 2
    mid = argv[0].upper(); use_asis = '--no-asis' not in argv
    max_sets = int(argv[argv.index('--max-sets') + 1]) if '--max-sets' in argv else 12
    vd = P('Doc', 'verify', mid)
    calls = [c for c in (rj(os.path.join(vd, 'sqllog_calls.json'), {}) or {}).get('calls', []) if c.get('params_parsed') and c.get('kind') == 'GET']
    if not calls:
        print(f'[sheet_data_cond] {mid}: sqllog_calls.json GET 호출 없음 — tools/Harness/verify/sqllog_calls.py {mid} 먼저'); return 3
    hint = {}
    try:
        with open(os.path.join(vd, 'asis_live', 'param_hint.csv'), encoding='utf-8-sig') as f:
            for r in csv.DictReader(f): hint.setdefault(r['tobe_proc'].upper(), (r['asis_sp'], []))[1].append(r['asis_param'])
    except OSError: pass
    cr = rj(os.path.join(vd, 'combo_runtime.json'), {}) or {}
    div_opts = []
    for k, v in (cr.get('search') or {}).items():
        if re.fullmatch(r'(?i)div\.?|division', k.strip()):
            div_opts = [o.split()[0] for o in v.get('opts', []) if o.split() and not re.fullmatch(r'(?i)all|select', o.split()[0])]
    # (proc, sheet) → 중복 없는 인자 묶음
    groups = {}
    for c in calls:
        fe = {k: v for k, v in (c.get('fe') or {}).items() if k.lower() not in SKIP_KEYS}
        sheet = str(fe.get('p_sheet_name') or '')
        if not sheet: continue
        key = json.dumps(fe, sort_keys=True, ensure_ascii=False)
        g = groups.setdefault((c['proc'], sheet), {})
        if key not in g:
            b = dict(c.get('fe') or {}, **(c.get('ses') or {}))
            if not b.get('p_user_id'): b['p_user_id'] = b.get('sesUserId') or c.get('by') or ''  # BE 가 세션 사용자로 채우는 자리
            g[key] = b
    cx = dbconn.connect('tobe')
    ax = None
    if use_asis:
        try: ax = dbconn.connect('asis')
        except Exception as e: print(f'[sheet_data_cond] AS-IS 접속 실패 — AS-IS 열 미측정: {str(e)[:120]}')  # noqa: BLE001
    out = {'menu_id': mid, 'at': now(), 'source': 'sqllog_calls.json GET 호출 재실행(TO-BE 사내 Oracle · AS-IS MSSQL .env.asis)', 'div_opts': div_opts, 'sheets': {}}
    for (proc, sheet), sets in sorted(groups.items()):
        asis_sp, asis_params = hint.get(proc.upper(), ('', []))
        tried, seen = [], set()

        def run(kind, body):
            sig = json.dumps({k: body.get(k) for k in sorted(body) if k.lower().startswith('p_')}, sort_keys=True, ensure_ascii=False)
            if sig in seen: return None
            seen.add(sig)
            t, tn = tobe_rows(cx, proc, body)
            a, an = (None, '미측정(접속 없음)') if ax is None or not asis_sp else (None, '')
            if ax is not None and asis_sp:
                lp = {golden.nkey(k): v for k, v in body.items()}
                ps = {}
                for ap in asis_params:
                    nm = ap.lstrip('@'); v = lp.get(golden.nkey(nm))
                    if v is None and golden.nkey(nm) in ('puserid', 'userid'): v = body.get('sesUserId') or ''
                    ps[nm] = '' if v is None else v
                a, an = asis_rows(ax, asis_sp, ps)
            row = {'kind': kind, 'div': str(body.get('p_division_id') or ''), 'tobe_rows': t, 'asis_rows': a,
                   'cond': {k: body.get(k) for k in ('p_division_id', 'p_version', 'p_operation_id', 'p_from_yyyymm', 'p_to_yyyymm', 'p_plan_month') if body.get(k) not in (None, '')},
                   'note': '; '.join(x for x in (tn, an) if x), 'at': now()}
            tried.append(row); print(f'  {sheet:<22} {kind:<4} Div {row["div"]:<7} TO-BE {t} · AS-IS {a} {row["note"][:80]}'); return row
        print(f'[{proc}] 시트 {sheet} 기록 인자 {len(sets)}묶음 · AS-IS {asis_sp or "짝 없음"}')
        for body in list(sets.values())[:max_sets]: run('rec', body)
        if '--rec-only' not in argv:  # 기록에 없는 Division 도 센다(행 나오는 Division 전부를 표로 남김)
            base = next(iter(sets.values()))
            for d in div_opts:
                b = {k: ('' if DIV_DEP.match(k) else v) for k, v in base.items()}; b['p_division_id'] = d
                run('div', b)
        best_t = max((r for r in tried if (r['tobe_rows'] or 0) > 0), key=lambda r: (r['kind'] == 'rec', r['tobe_rows']), default=None)
        best_a = max((r for r in tried if (r['asis_rows'] or 0) > 0), key=lambda r: (r['kind'] == 'rec', r['asis_rows']), default=None)
        sh = out['sheets'].setdefault(sheet, {'procs': [], 'tried': []})
        sh['procs'].append(proc); sh['tried'] += [dict(r, proc=proc) for r in tried]
        for tag, b in (('tobe', best_t), ('asis', best_a)):
            if b and (not sh.get(tag) or b[f'{tag}_rows'] > sh[tag]['rows']):
                sh[tag] = {'div': b['div'], 'rows': b[f'{tag}_rows'], 'kind': b['kind'], 'cond': b['cond'], 'proc': proc}
    for sh in out['sheets'].values():
        # E2E·런처가 먼저 시도할 Division 순서 = TO-BE 행 > 0 인 Division(행 많은 순) → AS-IS 행 > 0 인 Division
        tdivs = sorted({r['div'] for r in sh['tried'] if (r['tobe_rows'] or 0) > 0}, key=lambda d: -max(r['tobe_rows'] or 0 for r in sh['tried'] if r['div'] == d))
        adivs = sorted({r['div'] for r in sh['tried'] if (r['asis_rows'] or 0) > 0}, key=lambda d: -max(r['asis_rows'] or 0 for r in sh['tried'] if r['div'] == d))
        sh['divs'] = tdivs + [d for d in adivs if d not in tdivs]
        sh['both'] = [d for d in tdivs if d in adivs]
    with open(os.path.join(vd, 'sheet_data_cond.json'), 'w', encoding='utf-8') as f: json.dump(out, f, ensure_ascii=False, indent=1)
    md = [f'# {mid} 시트별 데이터 조건', '', f'- 측정 {out["at"]} · {out["source"]}', f'- Division 후보(combo_runtime.json) {", ".join(div_opts) or "없음"}', '',
          '| 시트 | 양쪽 행 있는 Div | TO-BE 행 있는 Div | TO-BE 최대 | AS-IS 최대 |', '|---|---|---|---|---|']
    for s, sh in sorted(out['sheets'].items()):
        md.append(f"| {s} | {', '.join(sh['both']) or '없음'} | {', '.join(d for d in sh['divs'] if any(r['div'] == d and (r['tobe_rows'] or 0) > 0 for r in sh['tried'])) or '없음'} | "
                  f"{(sh.get('tobe') or {}).get('rows', 0)} (Div {(sh.get('tobe') or {}).get('div', '-')}) | {(sh.get('asis') or {}).get('rows', 0)} (Div {(sh.get('asis') or {}).get('div', '-')}) |")
    md += ['', '| 시트 | 종류 | Div | 조건 | TO-BE 행 | AS-IS 행 | 비고 | 측정 |', '|---|---|---|---|---|---|---|---|']
    for s, sh in sorted(out['sheets'].items()):
        for r in sh['tried']:
            md.append(f"| {s} | {r['kind']} | {r['div']} | {', '.join(f'{k}={v}' for k, v in r['cond'].items() if k != 'p_division_id')} | {r['tobe_rows']} | {r['asis_rows']} | {r['note'][:60]} | {r['at']} |")
    with open(os.path.join(vd, 'sheet_data_cond.md'), 'w', encoding='utf-8') as f: f.write('\n'.join(md) + '\n')
    print(f'[sheet_data_cond] {mid} → Doc/verify/{mid}/sheet_data_cond.json·.md · 시트 {len(out["sheets"])}')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
