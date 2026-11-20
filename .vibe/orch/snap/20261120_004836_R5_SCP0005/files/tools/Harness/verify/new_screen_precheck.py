# -*- coding: utf-8 -*-
"""new_screen_precheck.py — EN-25 신규 화면 사전 점검 (2026-11-11 · 플랜 '추측 대신 실행')

화면 생성을 시작하기 전에, 생성기·AI 가 "있을 것"으로 가정하는 입력이 실제로 있는지 파일과 사내 DB 로 잰다.
  R1 AS-IS 사실 묶음   Doc/asisfacts/screens/<ID>/ 의 필수 파일 실재·행 수(endpoints·controls·events·actions·grid_columns_asis)
  R2 AS-IS SP 원문     화면이 부르는 SP(endpoints MATCH) 마다 Doc/asisfacts/db/modules/dbo.<SP>.sql 실재
  R3 AS-IS 호출 해석   endpoints 중 SP 로 풀리지 않은 호출 수(풀리지 않으면 생성기가 배선을 모른다)
  R4 AS-IS 컬럼 메타   dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv 행 수(0 이면 그리드 컬럼의 근거 없음)
  R5 분석 문서         Doc/asisfacts/agent/<ID>/ 의 analysis·screen_design·unit_test 실재(없으면 생성 프롬프트의 근거가 빈다)
  R6 TO-BE 사내 DB     meta_live_check.py 를 실행해 메뉴·배선·PROC·인자·컬럼·콤보를 실측(이번 실행이 쓴 결과만 인정)
판정: READY(전부 PASS) / NOT_READY(FAIL 있음 — 생성 전에 채울 것) / UNKNOWN(측정 실패 ERROR 만 있음)
      FAIL·ERROR 마다 "무엇을 먼저 해야 하는지"를 적는다. 이 도구는 아무것도 만들거나 고치지 않는다.

  python tools/Harness/verify/new_screen_precheck.py <MENU_ID> [--no-db]
  python tools/Harness/verify/new_screen_precheck.py --selftest
출력: Doc/verify/<ID>/precheck.json · precheck.csv · 종료코드 0 READY / 2 NOT_READY / 3 UNKNOWN
"""
import csv, json, os, re, subprocess, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
try:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception:
    pass
csv.field_size_limit(10 ** 8)
NEED = ['endpoints.csv', 'controls.csv', 'events.csv', 'actions.csv', 'grid_columns_asis.csv']
DOCS = ['analysis.md', 'screen_design.md', 'unit_test.md']


def rd(p):
    if not os.path.exists(p):
        return None
    with open(p, encoding='utf-8-sig', newline='', errors='replace') as f:
        return list(csv.DictReader(f))


def asis_checks(sdir, mods, adir, is_main=None):
    """파일 기반 점검 → rows [{check,target,result,detail,todo}]"""
    out = []

    def add(c, t, r, d, todo=''):
        out.append({'check': c, 'target': t, 'result': r, 'detail': d, 'todo': todo})
    if not os.path.isdir(sdir):
        add('R1 AS-IS 사실 묶음', os.path.basename(sdir), 'FAIL', '화면 사실 폴더 없음', 'tools/AsisFacts pack 으로 이 화면 사실 묶음 생성')
        return out
    for f in NEED:
        rows = rd(os.path.join(sdir, f))
        if rows is None:
            add('R1 AS-IS 사실 묶음', f, 'FAIL', '파일 없음', 'AsisFacts pack·facts 보강 단계 재실행')
        elif not rows and f in ('endpoints.csv', 'controls.csv'):
            add('R1 AS-IS 사실 묶음', f, 'FAIL', '0행', 'AS-IS 소스 경로·variant 확인 후 AsisFacts 재실행')
        else:
            add('R1 AS-IS 사실 묶음', f, 'PASS', f'{len(rows)}행')
    eps = rd(os.path.join(sdir, 'endpoints.csv')) or []
    if is_main:
        eps = [r for r in eps if is_main(r, sdir)]
    sps, unresolved = [], []
    for r in eps:
        m = re.match(r'^SP\s+(\S+)', r.get('sp_or_sql') or '')
        if m and r.get('status') in ('MATCH', 'MATCH_PATTERN'):
            sp = m.group(1).split('.')[-1]
            if sp not in sps:
                sps.append(sp)
        elif (r.get('status') or '') in ('UNRESOLVED', 'NOT_IN_FOXQUERY', 'BIZ_NOT_FOUND'):
            # 2026-11-11 전 화면 상태값 실측 12종 중 미해석 3종만(BIZ_MATCH 4,640행 = 업무 계층 경유로 풀린 호출 — 미해석 아님)
            unresolved.append(f"{os.path.basename((r.get('file') or '').replace(chr(92), '/'))}:{r.get('line')} {r.get('member')}({r.get('status')})")
    miss = [sp for sp in sps if not os.path.exists(os.path.join(mods, f'dbo.{sp}.sql'))]
    if not sps:
        add('R2 AS-IS SP 원문', '(화면 호출 SP)', 'ERROR', '화면이 부르는 SP 를 하나도 찾지 못함(미측정)', 'endpoints.csv 의 호출 해석 확인(R3)')
    elif miss:
        add('R2 AS-IS SP 원문', f'{len(miss)}/{len(sps)}', 'FAIL', '원문 없음: ' + ', '.join(miss[:8]), 'AS-IS DB 에서 SP 원문 재추출(asisfacts db)')
    else:
        add('R2 AS-IS SP 원문', f'{len(sps)}개', 'PASS', '화면 호출 SP 전부 원문 있음')
    if unresolved:
        add('R3 AS-IS 호출 해석', f'{len(unresolved)}곳', 'FAIL', '풀리지 않은 호출: ' + ' / '.join(unresolved[:6]), '해당 호출의 SP 를 원문에서 확인해 endpoints 보강(추측으로 배선 금지)')
    else:
        add('R3 AS-IS 호출 해석', f'{len(eps)}행', 'PASS', '풀리지 않은 호출 0')
    cm = rd(os.path.join(sdir, 'dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv'))
    if cm is None:
        add('R4 AS-IS 컬럼 메타', 'SCM_MST_SHEET_COLUMNS', 'ERROR', '추출 파일 없음(미측정) — 메타 구동 화면이 아니면 해당 없음일 수 있음', 'grid_columns_asis.csv 행 수로 그리드 정의 원천 확인')
    elif not cm:
        add('R4 AS-IS 컬럼 메타', 'SCM_MST_SHEET_COLUMNS', 'FAIL', '0행', 'AS-IS DB 에서 화면 메타 재추출')
    else:
        add('R4 AS-IS 컬럼 메타', 'SCM_MST_SHEET_COLUMNS', 'PASS', f'{len(cm)}행')
    md = [d for d in DOCS if not os.path.exists(os.path.join(adir, d))]
    if md:
        add('R5 분석 문서', ', '.join(md), 'FAIL', '없음', 'tools/AsisFacts/agent.ps1 <ID> 로 분석 문서 생성')
    else:
        add('R5 분석 문서', f'{len(DOCS)}종', 'PASS', '있음')
    return out


def db_rows(live_rows):
    out = []
    todo = {'M1': '메뉴 등록 SQL 적용(Doc/gen/<ID>/<ID>_registration.sql · meta_apply.py)', 'M2': 'FE 호출의 시트·버튼을 MNU_BTN_MPG_M 에 등록',
            'M3': 'PKG 작성·컴파일(🔗 PKG 변환)', 'M4': 'PROC_M 인자 메타를 PKG 시그니처와 맞춤', 'M5': '컬럼 메타를 AS-IS 와 맞춤(🧾 META)', 'M6': '콤보 SQL 등록(🧾 META)'}
    for r in live_rows:
        if r.get('result') in ('FAIL', 'ERROR'):
            k = (r.get('check') or '')[:2]
            out.append({'check': 'R6 TO-BE 사내 DB · ' + (r.get('check') or ''), 'target': r.get('target') or '', 'result': r['result'], 'detail': (r.get('detail') or '')[:300],
                        'todo': todo.get(k, '') if r['result'] == 'FAIL' else '측정하지 못한 항목 — 위 위치를 직접 열어 확인(등록 여부는 판정하지 않았다)'})
    n = len(live_rows)
    out.append({'check': 'R6 TO-BE 사내 DB', 'target': f'{n}항목', 'result': 'PASS' if n and not out else ('ERROR' if not n else 'INFO'),
                'detail': (f'meta_live_check {n}항목 중 FAIL·ERROR {len(out)}' if n else 'meta_live_check 결과 없음(미측정)'), 'todo': '' if n else '사내 DB 접속 확인 후 다시 실행'})
    return out


def verdict(rows):
    res = [r['result'] for r in rows]
    if 'FAIL' in res:
        return 'NOT_READY', 2
    if 'ERROR' in res:
        return 'UNKNOWN', 3
    return 'READY', 0


def selftest():
    import tempfile
    st = {'ok': 0, 'n': 0}

    def t(name, cond):
        st['n'] += 1
        st['ok'] += bool(cond)
        print(('PASS ' if cond else 'FAIL ') + name)
    with tempfile.TemporaryDirectory() as td:
        sd = os.path.join(td, 'S'); md = os.path.join(td, 'M'); ad = os.path.join(td, 'A')
        for d in (sd, md, ad):
            os.makedirs(d)

        def w(p, head, rows):
            with open(p, 'w', encoding='utf-8-sig', newline='') as f:
                cw = csv.writer(f); cw.writerow(head); cw.writerows(rows)
        ep_head = ['file', 'member', 'line', 'status', 'sp_or_sql']
        w(os.path.join(sd, 'endpoints.csv'), ep_head, [['a.cs', 'Load', '1', 'MATCH', 'SP X_GET']])
        for f in NEED[1:]:
            w(os.path.join(sd, f), ['a'], [['1']])
        w(os.path.join(sd, 'dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv'), ['a'], [['1']])
        open(os.path.join(md, 'dbo.X_GET.sql'), 'w').write('x')
        for d in DOCS:
            open(os.path.join(ad, d), 'w').write('x')
        r = asis_checks(sd, md, ad)
        t('전부 구비 → READY', verdict(r)[0] == 'READY')
        os.remove(os.path.join(md, 'dbo.X_GET.sql'))
        r = asis_checks(sd, md, ad)
        t('SP 원문 없음(변이) → R2 FAIL · NOT_READY', verdict(r)[0] == 'NOT_READY' and any(x['check'].startswith('R2') and x['result'] == 'FAIL' for x in r))
        open(os.path.join(md, 'dbo.X_GET.sql'), 'w').write('x')
        w(os.path.join(sd, 'endpoints.csv'), ep_head, [['a.cs', 'Load', '1', 'MATCH', 'SP X_GET'], ['a.cs', 'Save', '9', 'UNRESOLVED', '']])
        r = asis_checks(sd, md, ad)
        t('풀리지 않은 호출(변이) → R3 FAIL', any(x['check'].startswith('R3') and x['result'] == 'FAIL' for x in r))
        w(os.path.join(sd, 'endpoints.csv'), ep_head, [['a.cs', 'Load', '1', 'MATCH', 'SP X_GET']])
        os.remove(os.path.join(sd, 'controls.csv'))
        r = asis_checks(sd, md, ad)
        t('필수 사실 파일 없음(변이) → R1 FAIL', any(x['check'].startswith('R1') and x['target'] == 'controls.csv' and x['result'] == 'FAIL' for x in r))
        w(os.path.join(sd, 'controls.csv'), ['a'], [['1']])
        os.remove(os.path.join(ad, 'unit_test.md'))
        r = asis_checks(sd, md, ad)
        t('분석 문서 없음(변이) → R5 FAIL', any(x['check'].startswith('R5') and x['result'] == 'FAIL' for x in r))
        r = asis_checks(os.path.join(td, 'NOPE'), md, ad)
        t('사실 폴더 없음 → NOT_READY', verdict(r)[0] == 'NOT_READY')
    d = db_rows([{'check': 'M1 메뉴', 'target': 'X', 'result': 'PASS', 'detail': ''}, {'check': 'M3 PROC 실재', 'target': 'PKG_X', 'result': 'FAIL', 'detail': '없음'}])
    t('사내 DB FAIL → 할 일 문구와 함께 NOT_READY', verdict(d)[0] == 'NOT_READY' and 'PKG' in d[0]['todo'])
    d = db_rows([])
    t('사내 DB 결과 없음 = UNKNOWN(READY 아님)', verdict(d)[0] == 'UNKNOWN')
    d = db_rows([{'check': 'M1 메뉴', 'target': 'X', 'result': 'PASS', 'detail': ''}])
    t('사내 DB 전부 PASS → READY', verdict(d)[0] == 'READY')
    print(f"{st['ok']}/{st['n']}")
    return 0 if st['ok'] == st['n'] else 1


def main():
    a = sys.argv[1:]
    if '--selftest' in a:
        return selftest()
    if not a or a[0].startswith('--'):
        print(__doc__)
        return 3
    mid = a[0].upper()
    vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    os.makedirs(vd, exist_ok=True)
    at = time.strftime('%Y-%m-%d %H:%M:%S')
    try:
        from asis_variant import is_main
    except Exception:
        is_main = None
    rows = asis_checks(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', mid), os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'modules'),
                       os.path.join(ROOT, 'Doc', 'asisfacts', 'agent', mid), is_main)
    if '--no-db' not in a:
        lp = os.path.join(vd, 'meta_live_check.csv')
        before = os.path.getmtime(lp) if os.path.exists(lp) else 0
        subprocess.run([sys.executable, os.path.join(HERE, 'meta_live_check.py'), mid], cwd=ROOT, capture_output=True, text=True, encoding='utf-8', errors='replace')
        live = (rd(lp) or []) if (os.path.exists(lp) and os.path.getmtime(lp) > before) else []
        rows += db_rows(live)
    else:
        rows.append({'check': 'R6 TO-BE 사내 DB', 'target': '', 'result': 'SKIPPED', 'detail': '--no-db — 사내 DB 미측정', 'todo': ''})
    v, rc = verdict(rows)
    with open(os.path.join(vd, 'precheck.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['check', 'target', 'result', 'detail', 'todo'])
        w.writeheader()
        w.writerows(rows)
    c = {}
    for r in rows:
        c[r['result']] = c.get(r['result'], 0) + 1
    with open(os.path.join(vd, 'precheck.json'), 'w', encoding='utf-8') as f:
        json.dump({'menu_id': mid, 'at': at, 'verdict': v, 'rc': rc, 'counts': c, 'rows': rows}, f, ensure_ascii=False, indent=1)
    for r in rows:
        if r['result'] in ('FAIL', 'ERROR'):
            print(f"[precheck] {r['result']} {r['check']} · {r['target']} — {r['detail'][:220]}" + (f"\n           → {r['todo']}" if r['todo'] else ''))
    print(f"[precheck] {mid} {at} · {v} · " + ' · '.join(f'{k} {n}' for k, n in sorted(c.items())) + f" → Doc/verify/{mid}/precheck.csv")
    return rc


if __name__ == '__main__':
    sys.exit(main())
