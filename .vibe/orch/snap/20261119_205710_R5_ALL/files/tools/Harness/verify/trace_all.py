# -*- coding: utf-8 -*-
"""전 화면 대조표 검증 커버리지 집계 (사용자 지시 2026-10-26 — '전체에 대해서 검증을 제대로 하도록')

  python tools/Harness/verify/trace_all.py [--no-syn]

  ① syn_check.py --all (시노님·권한 정적 검사, DB 1회 접속) — --no-syn 이면 기존 syn_check.csv 사용
  ② FE 페이지(MENU_ID 상수)가 있는 전 화면 + AS-IS 액션 대조표가 있는 To-Be 화면마다 mapping_trace.py
  ③ Doc/verify/_trace_all.md · _trace_all.csv — 화면별 대조표 행·검증완료·FAIL·미검증(사유)·미구현·FE 대조표 없음·시노님 문제
  검증 결과는 기존 증거(정합검증 원장·E2E 요약·게이트·시노님 검사)만으로 만든다 — 이 스크립트는 E2E 를 돌리지 않는다.
"""
import csv, json, os, re, subprocess, sys, datetime, collections
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
HERE = os.path.dirname(os.path.abspath(__file__))
DOC = os.path.join(ROOT, 'Doc')
py = sys.executable


def pages():
    out = {}
    base = os.path.join(ROOT, 'nscm-fe', 'features')
    for feat in os.listdir(base):
        pd = os.path.join(base, feat, 'src', 'pages')
        if not os.path.isdir(pd): continue
        for page in os.listdir(pd):
            d = os.path.join(pd, page)
            if not os.path.isdir(d): continue
            for f in os.listdir(d):
                if f.endswith('.constants.ts'):
                    m = re.search(r"MENU_ID\s*=\s*'([A-Z0-9_]+)'", open(os.path.join(d, f), encoding='utf-8', errors='ignore').read())
                    if m: out.setdefault(m.group(1), d)
    return out


def main():
    if '--no-syn' not in sys.argv:
        subprocess.call([py, os.path.join(HERE, 'syn_check.py'), '--all'], cwd=ROOT, stdout=subprocess.DEVNULL)
    pg = pages()
    menus = sorted(pg)
    rows = []
    for i, m in enumerate(menus, 1):
        r = subprocess.run([py, os.path.join(HERE, 'mapping_trace.py'), m], cwd=ROOT, capture_output=True, text=True, encoding='utf-8', env=dict(os.environ, PYTHONIOENCODING='utf-8'))
        sf = os.path.join(DOC, 'verify', m, 'mapping_trace_summary.json')
        if r.returncode or not os.path.exists(sf):
            rows.append({'menu_id': m, 'error': (r.stderr or r.stdout).strip().splitlines()[-1:] or ['?']}); continue
        s = json.load(open(sf, encoding='utf-8'))
        subprocess.run([py, os.path.join(HERE, 'impl_engine.py'), m], cwd=ROOT, capture_output=True, text=True, encoding='utf-8', env=dict(os.environ, PYTHONIOENCODING='utf-8'))
        wf = os.path.join(DOC, 'verify', m, 'work_ledger_summary.json')
        wl = json.load(open(wf, encoding='utf-8')) if os.path.exists(wf) else {}
        syn = [x for x in csv.DictReader(open(os.path.join(DOC, 'verify', m, 'syn_check.csv'), encoding='utf-8-sig'))] if os.path.exists(os.path.join(DOC, 'verify', m, 'syn_check.csv')) else []
        v = s['verdict']
        rows.append({'menu_id': m, 'page': os.path.relpath(pg[m], ROOT), 'rows': s['rows'], 'fe_rows': s['fe_rows'], 'action_rows': s['action_rows'], 'fe_mapping_missing': s.get('fe_mapping_missing'),
                     'done': v.get('검증완료', 0), 'fail': v.get('FAIL', 0), 'unverified': v.get('미검증', 0), 'notimpl': v.get('미구현', 0), 'na': v.get('해당없음', 0),
                     'r6': s['unverified_reasons'].get('TODO', 0) + s['unverified_reasons'].get('NOPATH', 0) + s['unverified_reasons'].get('R6', 0) + s['unverified_reasons'].get('R6k', 0),
                     'instances': s.get('instances', 0), 'work_open': wl.get('open', 0), 'suspect': wl.get('suspect_not_implemented', 0), 'work_by_type': ' '.join(f'{k}:{v}' for k, v in sorted((wl.get('by_type') or {}).items())), 'todo': (s.get('instance_result') or {}).get('TODO', 0), 'nopath': (s.get('instance_result') or {}).get('NOPATH', 0), 'notrun': (s.get('instance_result') or {}).get('NOT_RUN', 0), 'syn_bad': sum(1 for x in syn if x['verdict'] not in ('OK', 'UNKNOWN')), 'syn_checked': len(syn)})
        if i % 20 == 0: print(f'  {i}/{len(menus)}')
    cols = ['menu_id', 'page', 'rows', 'fe_rows', 'action_rows', 'fe_mapping_missing', 'done', 'fail', 'unverified', 'notimpl', 'na', 'r6', 'instances', 'work_open', 'suspect', 'work_by_type', 'notrun', 'nopath', 'todo', 'syn_bad', 'syn_checked', 'error']
    with open(os.path.join(DOC, 'verify', '_trace_all.csv'), 'w', encoding='utf-8-sig', newline='') as fp:
        w = csv.DictWriter(fp, fieldnames=cols); w.writeheader(); [w.writerow({k: r.get(k, '') for k in cols}) for r in rows]
    ok = [r for r in rows if 'error' not in r]
    T = lambda k: sum(int(r.get(k) or 0) for r in ok)
    L = [f'# 전 화면 대조표 검증 커버리지 — {datetime.datetime.now():%Y-%m-%d %H:%M}', '',
         '> 대조표(FE `__asis-mapping__.md` + AS-IS 액션 `actions.csv`)의 행마다 검증 결과가 있는지. **미검증·FE 대조표 없음·시노님 문제는 완료가 아니다.** 상세 = `Doc/verify/<ID>/mapping_trace.md`', '',
         f'- 화면 {len(rows)} (추적 실패 {len(rows) - len(ok)}) · 대조표 행 {T("rows")} · **검증완료 {T("done")}** · **FAIL {T("fail")}** · **미검증 {T("unverified")}**(미검증 행의 검사 사유 중 검사기 없음·실행 경로 없음 {T("r6")}건 — 행당 여러 검사) · 미구현 {T("notimpl")} · 해당없음 {T("na")}',
         f'- FE 대조표 없는 화면 {sum(1 for r in ok if r["fe_mapping_missing"])} · 시노님/권한 문제 있는 화면 {sum(1 for r in ok if r["syn_bad"])} (문제 행 {T("syn_bad")})', '',
         '']
    # 검증 층·검사별 합계(인스턴스 v2) — TODO(검사기 없음)·NOPATH(실행 경로 없음)가 많은 검사부터 검증 엔진을 만든다
    by = collections.defaultdict(collections.Counter); bc = collections.defaultdict(collections.Counter)
    for r in ok:
        s2 = json.load(open(os.path.join(DOC, 'verify', r['menu_id'], 'mapping_trace_summary.json'), encoding='utf-8'))
        for lay, c in (s2.get('by_layer') or {}).items(): by[lay].update(c)
        for k, c in (s2.get('by_check') or {}).items(): bc[k].update(c)
    ST = ['PASS', 'FAIL', 'NOT_RUN', 'NOPATH', 'TODO', 'BLOCKED', 'REVIEW', 'WARN']
    wt = collections.Counter()
    for r in ok:
        for kv in (r.get('work_by_type') or '').split():
            k, v = kv.split(':'); wt[k] += int(v)
    L += [f'- 검사 인스턴스 {T("instances")} · 미실행 NOT_RUN {T("notrun")} · 실행 경로 없음 NOPATH {T("nopath")} · 검사기 없음 TODO {T("todo")}',
          f'- **작업 원장(할 일) {T("work_open")}건** — ' + ' · '.join(f'{k} {v}' for k, v in sorted(wt.items())) + f' · 구현 의심 {T("suspect")} (화면별 `Doc/verify/<ID>/work_ledger.md`)', '',
          '## 검증 층별 합계 (인스턴스)', '', '| 검증 층 | ' + ' | '.join(ST) + ' |', '|---' * (len(ST) + 1) + '|']
    for lay, c in sorted(by.items(), key=lambda kv: -(kv[1].get('TODO', 0) + kv[1].get('NOPATH', 0))):
        L.append(f'| {lay} | ' + ' | '.join(str(c.get(x, 0)) for x in ST) + ' |')
    L += ['', '## 검사별 합계 — 검증 엔진 구현 우선순위(TODO+NOPATH 많은 순)', '', '| 검사 | ' + ' | '.join(ST) + ' |', '|---' * (len(ST) + 1) + '|']
    for k, c in sorted(bc.items(), key=lambda kv: -(kv[1].get('TODO', 0) + kv[1].get('NOPATH', 0)))[:60]:
        L.append(f'| {k} | ' + ' | '.join(str(c.get(x, 0)) for x in ST) + ' |')
    L += ['', '## 화면별', '', '| 화면 | 대조표 행(FE/액션) | 검증완료 | FAIL | 미검증(TODO+NOPATH 사유) | 미구현 | FE 대조표 | 시노님 문제 |', '|---|---|---|---|---|---|---|---|']
    for r in sorted(ok, key=lambda r: (-(r['fail'] + r['unverified']), r['menu_id'])):
        L.append(f"| {r['menu_id']} | {r['rows']} ({r['fe_rows']}/{r['action_rows']}) | {r['done']} | {r['fail']} | {r['unverified']} ({r['r6']}) | {r['notimpl']} | {r.get('work_open', 0)} | {'**없음**' if r['fe_mapping_missing'] else '있음'} | {r['syn_bad']}/{r['syn_checked']} |")
    for r in rows:
        if 'error' in r: L.append(f"| {r['menu_id']} | 추적 실패: {r['error'][0][:80]} | | | | | | | |")
    open(os.path.join(DOC, 'verify', '_trace_all.md'), 'w', encoding='utf-8').write('\n'.join(L) + '\n')
    print('\n'.join(L[:7]))
    print('→ Doc/verify/_trace_all.md')


if __name__ == '__main__':
    main()
