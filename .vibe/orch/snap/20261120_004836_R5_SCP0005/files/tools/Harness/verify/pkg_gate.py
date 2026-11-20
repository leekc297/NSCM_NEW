# -*- coding: utf-8 -*-
"""pkg_gate.py — EN-05 PKG 컴파일·실행 대조 게이트 (2026-11-11 · 플랜 '추측 대신 실행' M1)

PKG 를 만들거나 고친 뒤 "됐다"를 서술로 끝내지 않고, 사내 DB 와 AS-IS DB 를 실제로 조회·실행한 결과로 통과 여부를 낸다.
  G1 원문 반영   Doc/gen/<ID>/<ID>_PKG.sql ↔ 사내 ALL_SOURCE (meta_apply.py --check · 읽기 전용)
  G2 컴파일      화면에 배선된 PKG 의 PACKAGE/BODY VALID · ALL_ERRORS 0          (meta_live_check M3)
  G3 시그니처    SCM_ADM_PROC_M 인자 ↔ ALL_ARGUMENTS                              (meta_live_check M4)
  G4 실행 대조   화면 실전송 인자로 AS-IS SP ↔ TO-BE PROC 실행 결과 대조           (gen_param_map → diff_verify)
판정: G1 다름 = WARN(파일이 사내와 다름 — 적용 전이거나 사내가 더 새것) · G2/G3 FAIL = FAIL · G4 DIFF = FAIL
      G4 SKIP 은 '미측정'으로 수를 그대로 보고한다(통과로 세지 않는다). 대조할 호출 기록이 없으면 G4 = ERROR(미측정).

  python tools/Harness/verify/pkg_gate.py <MENU_ID>            전체
  python tools/Harness/verify/pkg_gate.py <MENU_ID> --no-diff  G4 생략(G1~G3 만)
  python tools/Harness/verify/pkg_gate.py --selftest
출력: Doc/verify/<ID>/pkg_gate.json · 종료코드 0 통과 / 2 FAIL 있음 / 3 측정 실패(ERROR)만 있음
"""
import csv, json, os, subprocess, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
try:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception:
    pass


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def decide(g1_rc, live_rows, diff_rows, diff_ran, has_pkg_file=True):
    """측정값 → 게이트별 결과. 반환 = (gates(list of dict), rc)"""
    gates = []
    if not has_pkg_file:
        gates.append({'gate': 'G1 원문 반영', 'result': 'NA', 'detail': 'Doc/gen/<ID>/<ID>_PKG.sql 없음 — 비교 대상 파일 없음'})
    elif g1_rc == 0:
        gates.append({'gate': 'G1 원문 반영', 'result': 'PASS', 'detail': '파일 = 사내 ALL_SOURCE'})
    elif g1_rc == 2:
        gates.append({'gate': 'G1 원문 반영', 'result': 'WARN', 'detail': '파일 ≠ 사내 ALL_SOURCE (적용 전이거나 사내가 더 새것 — meta_apply.py <ID> --check 출력 확인)'})
    else:
        gates.append({'gate': 'G1 원문 반영', 'result': 'ERROR', 'detail': f'meta_apply --check 종료코드 {g1_rc} — 비교 못 함'})
    for gid, key in (('G2 컴파일', 'M3'), ('G3 시그니처', 'M4')):
        rows = [r for r in live_rows if (r.get('check') or '').startswith(key)]
        fail = [r for r in rows if r.get('result') == 'FAIL']
        err = [r for r in rows if r.get('result') == 'ERROR']
        if not rows:
            gates.append({'gate': gid, 'result': 'ERROR', 'detail': f'meta_live_check 에 {key} 행 없음 — 배선된 PROC 을 찾지 못함(미측정)'})
        elif fail:
            gates.append({'gate': gid, 'result': 'FAIL', 'detail': f"{len(fail)}/{len(rows)} FAIL — " + ' / '.join(f"{r.get('target')}: {r.get('detail')}" for r in fail[:5])})
        elif err:
            gates.append({'gate': gid, 'result': 'ERROR', 'detail': f"{len(err)}/{len(rows)} 미측정 — " + ' / '.join(f"{r.get('target')}: {r.get('detail')}" for r in err[:3])})
        else:
            gates.append({'gate': gid, 'result': 'PASS', 'detail': f'{len(rows)}건 전부 PASS'})
    if not diff_ran:
        gates.append({'gate': 'G4 실행 대조', 'result': 'SKIPPED', 'detail': '--no-diff — 실행 대조 생략(미측정)'})
    elif not diff_rows:
        gates.append({'gate': 'G4 실행 대조', 'result': 'ERROR', 'detail': '대조 결과 0행 — 화면 호출 기록(E2E calls)이 없거나 diff_verify 실패(미측정)'})
    else:
        c = {}
        for r in diff_rows:
            v = r.get('verdict') or '?'
            c[v] = c.get(v, 0) + 1
        n = len(diff_rows)
        d = c.get('DIFF', 0)
        sk = c.get('SKIP', 0)
        det = ' · '.join(f'{k} {v}' for k, v in sorted(c.items())) + f' (전체 {n})'
        if d:
            det += ' — DIFF: ' + ' / '.join(f"{r.get('tobe_proc')}(불일치 셀 {r.get('diff_cells')})" for r in diff_rows if r.get('verdict') == 'DIFF')[:400]
        if sk:
            det += f' — SKIP {sk}건은 미측정(통과 아님)'
        gates.append({'gate': 'G4 실행 대조', 'result': 'FAIL' if d else ('ERROR' if sk == n else 'PASS'), 'detail': det,
                      'counts': c, 'measured': n - sk, 'total': n})
    res = [g['result'] for g in gates]
    rc = 2 if 'FAIL' in res else (3 if 'ERROR' in res else 0)
    return gates, rc


def selftest():
    st = {'ok': 0, 'n': 0}

    def t(name, cond):
        st['n'] += 1
        st['ok'] += bool(cond)
        print(('PASS ' if cond else 'FAIL ') + name)

    def dr(*v):
        return [{'verdict': x, 'tobe_proc': 'PKG_X.P', 'diff_cells': '3'} for x in v]

    live_ok = [{'check': 'M3 PROC 실재', 'target': 'PKG_X', 'result': 'PASS', 'detail': ''},
               {'check': 'M4 인자 메타', 'target': 'PKG_X.P', 'result': 'PASS', 'detail': ''}]
    g, rc = decide(0, live_ok, dr('PASS', 'ROWS_ONLY'), True)
    t('전부 통과 → rc 0', rc == 0 and all(x['result'] == 'PASS' for x in g))
    g, rc = decide(0, live_ok, dr('PASS', 'DIFF'), True)
    t('실행 결과 불일치(DIFF) → FAIL rc 2', rc == 2 and g[3]['result'] == 'FAIL')
    bad = [dict(live_ok[0], result='FAIL', detail='BODY INVALID'), live_ok[1]]
    g, rc = decide(0, bad, dr('PASS'), True)
    t('컴파일 무효(변이) → G2 FAIL rc 2', rc == 2 and g[1]['result'] == 'FAIL')
    bad = [live_ok[0], dict(live_ok[1], result='FAIL', detail='인자 수 다름')]
    g, rc = decide(0, bad, dr('PASS'), True)
    t('시그니처 불일치(변이) → G3 FAIL rc 2', rc == 2 and g[2]['result'] == 'FAIL')
    g, rc = decide(0, live_ok, dr('SKIP', 'SKIP'), True)
    t('전부 SKIP = 미측정(ERROR) — 통과 아님 rc 3', rc == 3 and g[3]['result'] == 'ERROR')
    g, rc = decide(0, live_ok, dr('PASS', 'SKIP'), True)
    t('일부 SKIP = PASS 이되 측정 분자·분모 기록', rc == 0 and g[3]['measured'] == 1 and g[3]['total'] == 2 and '미측정' in g[3]['detail'])
    g, rc = decide(0, live_ok, [], True)
    t('대조 결과 0행 = ERROR(미측정)', rc == 3 and g[3]['result'] == 'ERROR')
    g, rc = decide(0, [], dr('PASS'), True)
    t('배선 PROC 미발견 = ERROR(통과 아님)', rc == 3 and g[1]['result'] == 'ERROR')
    g, rc = decide(2, live_ok, dr('PASS'), True)
    t('파일≠사내 = WARN(막지 않음 · 표시)', rc == 0 and g[0]['result'] == 'WARN')
    g, rc = decide(0, live_ok, [], False)
    t('--no-diff = SKIPPED 표기(PASS 로 적지 않음)', g[3]['result'] == 'SKIPPED' and rc == 0)
    print(f"{st['ok']}/{st['n']}")
    return 0 if st['ok'] == st['n'] else 1


def run(cmd, label):
    t0 = time.time()
    p = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True, encoding='utf-8', errors='replace')
    tail = [l for l in (p.stdout or '').splitlines() if l.strip()][-3:]
    print(f"[pkg_gate] {label}: 종료코드 {p.returncode} · {round(time.time() - t0)}초" + ''.join('\n    ' + l[:300] for l in tail))
    if p.returncode not in (0, 2) and p.stderr:
        print('    ' + (p.stderr.strip().splitlines() or [''])[-1][:300])
    return p.returncode


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
    py = sys.executable
    t0 = time.time()
    at = time.strftime('%Y-%m-%d %H:%M:%S')
    pkgf = os.path.join(ROOT, 'Doc', 'gen', mid, f'{mid}_PKG.sql')
    has = os.path.exists(pkgf)
    g1 = run([py, os.path.join(ROOT, 'tools', 'DbConn', 'meta_apply.py'), mid, '--check'], 'G1 원문 반영') if has else None
    live_p = os.path.join(vd, 'meta_live_check.csv')
    before = os.path.getmtime(live_p) if os.path.exists(live_p) else 0
    run([py, os.path.join(HERE, 'meta_live_check.py'), mid], 'G2·G3 사내 DB 실측')
    # 이번 실행이 쓴 파일만 인정(옛 결과 재사용 금지)
    live = rd(live_p) if (os.path.exists(live_p) and os.path.getmtime(live_p) > before) else []
    diff_ran = '--no-diff' not in a
    drows = []
    if diff_ran:
        run([py, os.path.join(HERE, 'gen_param_map.py'), mid], 'G4 짝·인자 대응 생성')
        dp = os.path.join(vd, 'diff', 'diff_summary.csv')
        b2 = os.path.getmtime(dp) if os.path.exists(dp) else 0
        run([py, os.path.join(HERE, 'diff_verify.py'), mid], 'G4 AS-IS↔TO-BE 실행 대조')
        drows = rd(dp) if (os.path.exists(dp) and os.path.getmtime(dp) > b2) else []
    gates, rc = decide(g1 if g1 is not None else 0, live, drows, diff_ran, has)
    res = {'menu_id': mid, 'at': at, 'seconds': round(time.time() - t0), 'rc': rc, 'gates': gates}
    with open(os.path.join(vd, 'pkg_gate.json'), 'w', encoding='utf-8') as f:
        json.dump(res, f, ensure_ascii=False, indent=1)
    for g in gates:
        print(f"[pkg_gate] {g['gate']}: {g['result']} — {g['detail'][:500]}")
    unm = [g['gate'] for g in gates if g['result'] in ('SKIPPED', 'NA', 'WARN')]
    verdict = ('통과' + (f" — 단, 측정하지 않았거나 경고인 게이트: {', '.join(unm)}" if unm else '')) if rc == 0 else ('FAIL 있음' if rc == 2 else '미측정 있음(ERROR)')
    print(f"[pkg_gate] {mid} {at} · {res['seconds']}초 · {verdict} → Doc/verify/{mid}/pkg_gate.json")
    return rc


if __name__ == '__main__':
    sys.exit(main())
