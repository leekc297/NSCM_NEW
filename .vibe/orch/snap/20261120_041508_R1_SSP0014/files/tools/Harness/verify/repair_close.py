# -*- coding: utf-8 -*-
"""보완 증명 루프(EN-01 · 2026-11-11) — 보완한 항목이 실제로 고쳐졌는지를 '고친 규칙만 다시 측정'해서 증명하고, 다른 항목이 나빠지지 않았는지 확인한다.

  python tools/Harness/verify/repair_close.py <MENU_ID>                    직전 정합검증 뒤 실제 변경을 측정(repair_scope)해 그 영향 행·규칙만 재판정
  python tools/Harness/verify/repair_close.py <MENU_ID> --all-open         조치 필요(action_needed=Y) 전부의 규칙을 재판정
  python tools/Harness/verify/repair_close.py <MENU_ID> --rules A5,F4      지정 규칙만
  python tools/Harness/verify/repair_close.py <MENU_ID> --rows V-1234,T-ab 지정 행의 규칙만(그 행만 종결 대상)
  python tools/Harness/verify/repair_close.py <MENU_ID> --snapshot         보완 직전 판정 저장(VM 자동보완 체인 — 재판정은 체인의 CheckList 가 한다)
  python tools/Harness/verify/repair_close.py <MENU_ID> --compare          저장한 스냅샷 ↔ 지금 원장 비교(재실행 없음 · 회귀는 화면 전체)
  python tools/Harness/verify/repair_close.py <MENU_ID> --dry              대상·명령만 보여 주고 실행하지 않음
  python tools/Harness/verify/repair_close.py --selftest

왜: 보완(🛠️·🧯)은 프롬프트로 고친 뒤 '고쳤다'는 자기 보고로 끝났다(추측 지점 원장 REPAIR). fixlist 의 close_evidence 는 종결 '조건' 문구일 뿐 결과가 아니다.
동작: ① 실행 전 원장(verify_ledger.csv) 판정을 스냅샷 ② run_verify <ID> --only <규칙들>(그 규칙을 판정하는 테스트만 재실행 · 나머지는 이전 결과 보존)
      ③ 실행 뒤 원장과 행 단위 비교 — 종결 대상: FAIL/판정필요/ERROR → PASS = 종결 · 그대로 = 미종결 · 그 밖 = 상태 변화(사유 표기)
      ④ 회귀: 종결 대상이 아닌 행 중 실행 전 PASS/NA 였는데 실행 뒤 FAIL/ERROR/판정필요 가 된 행
출력: Doc/verify/<ID>/repair_close.json(이번 결과) · Doc/verify/<ID>/_repair_close_history.csv(누적 이력 — 종결 근거 = 측정값)
종료코드: 0 = 대상 전부 종결 + 회귀 0 · 2 = 미종결 또는 회귀 있음(오류 아님 — 결과 보고) · 3 = 실행 불가(원장 없음·run_verify 실패)
한계: --only 는 그 규칙을 판정하는 테스트만 다시 돈다 → 회귀 확인 범위도 그 테스트들이 판정하는 행까지다(화면 전체 회귀는 전체 CheckList 로만 확인).
"""
import csv
import json
import os
import subprocess
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
csv.field_size_limit(10 ** 8)
BAD = ('FAIL', '판정필요', 'ERROR', 'NOT_RUN')
GOOD = ('PASS', 'NA')
HIST_COLS = ['at', 'menu_id', 'row_id', 'rule_id', 'target', 'before', 'after', 'outcome', 'evidence', 'rules_rerun']


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def snapshot(mid):
    return {r['row_id']: {'result': r.get('result', ''), 'rule_id': r.get('rule_id', ''), 'target': (r.get('target') or '')[:80], 'evidence': (r.get('evidence') or '')[:300]}
            for r in rd(os.path.join(ROOT, 'Doc', 'verify', mid, 'verify_ledger.csv')) if r.get('row_id')}


def compare(before, after, targets):
    """(종결 대상 결과 목록, 회귀 목록) — 순수 함수"""
    out, reg = [], []
    for rid in targets:
        b = before.get(rid, {}).get('result', '(없음)'); a = after.get(rid, {}).get('result', '(없음)')
        if a == 'PASS':
            oc = '종결' if b != 'PASS' else '이미 PASS'
        elif a == b:
            oc = '미종결'
        elif a == 'NA':
            oc = '대상 아님으로 바뀜(사유 확인)'
        elif a == '(없음)':
            oc = '원장에서 사라짐(확인 필요)'
        elif a == 'ERROR':
            oc = '측정 실패(미검증)'
        else:
            oc = f'상태 변화 {b}→{a}'
        src = after.get(rid) or before.get(rid) or {}
        out.append({'row_id': rid, 'rule_id': src.get('rule_id', ''), 'target': src.get('target', ''), 'before': b, 'after': a, 'outcome': oc, 'evidence': (after.get(rid) or {}).get('evidence', '')})
    tset = set(targets)
    for rid, a in after.items():
        if rid in tset:
            continue
        b = before.get(rid)
        if b and b['result'] in GOOD and a['result'] in BAD and a['result'] != 'NOT_RUN':
            reg.append({'row_id': rid, 'rule_id': a['rule_id'], 'target': a['target'], 'before': b['result'], 'after': a['result'], 'evidence': a['evidence']})
    return out, reg


def selftest():
    B = {'a': {'result': 'FAIL', 'rule_id': 'A5', 'target': '', 'evidence': ''}, 'b': {'result': 'FAIL', 'rule_id': 'F4', 'target': '', 'evidence': ''},
         'c': {'result': 'PASS', 'rule_id': 'H1', 'target': '', 'evidence': ''}, 'd': {'result': 'NA', 'rule_id': 'K3', 'target': '', 'evidence': ''},
         'e': {'result': '판정필요', 'rule_id': 'A6', 'target': '', 'evidence': ''}, 'f': {'result': 'PASS', 'rule_id': 'G1', 'target': '', 'evidence': ''}}
    A = {'a': {**B['a'], 'result': 'PASS'}, 'b': dict(B['b']), 'c': {**B['c'], 'result': 'FAIL'}, 'd': {**B['d'], 'result': 'ERROR'}, 'e': {**B['e'], 'result': 'NA'}, 'f': dict(B['f'])}
    out, reg = compare(B, A, ['a', 'b', 'e'])
    oc = {x['row_id']: x['outcome'] for x in out}
    cases = [('고친 행 FAIL→PASS = 종결', oc['a'] == '종결'), ('그대로 FAIL = 미종결', oc['b'] == '미종결'), ('판정필요→NA = 대상 아님으로 바뀜', oc['e'].startswith('대상 아님')),
             ('대상 밖 PASS→FAIL = 회귀', any(r['row_id'] == 'c' for r in reg)), ('대상 밖 NA→ERROR = 회귀', any(r['row_id'] == 'd' for r in reg)),
             ('대상 밖 PASS 유지 = 회귀 아님', not any(r['row_id'] == 'f' for r in reg)), ('종결 대상은 회귀 목록에 없음', not any(r['row_id'] in ('a', 'b', 'e') for r in reg))]
    bad = 0
    for n, ok in cases:
        bad += 0 if ok else 1
        print(f"{'OK ' if ok else 'NG '} {n}")
    print(f"{len(cases) - bad}/{len(cases)}")
    return 1 if bad else 0


def record(mid, vd, out, reg, rules, seconds, rc, note):
    """결과 파일·이력 기록 + 콘솔 요약. 반환 = 종료코드"""
    at = time.strftime('%Y-%m-%d %H:%M:%S')
    closed = [x for x in out if x['outcome'] == '종결']; still = [x for x in out if x['outcome'] == '미종결']; other = [x for x in out if x['outcome'] not in ('종결', '미종결')]
    res = {'at': at, 'menu_id': mid, 'rules_rerun': rules, 'seconds': seconds, 'run_verify_rc': rc, 'note': note,
           'targets': len(out), 'closed': len(closed), 'still_open': len(still), 'other': len(other), 'regressions': len(reg), 'rows': out, 'regression_rows': reg}
    json.dump(res, open(os.path.join(vd, 'repair_close.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    hp = os.path.join(vd, '_repair_close_history.csv'); new = not os.path.exists(hp)
    with open(hp, 'a', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=HIST_COLS)
        if new:
            w.writeheader()
        for x in out:
            w.writerow({'at': at, 'menu_id': mid, 'row_id': x['row_id'], 'rule_id': x['rule_id'], 'target': x['target'], 'before': x['before'], 'after': x['after'],
                        'outcome': x['outcome'], 'evidence': x['evidence'][:300], 'rules_rerun': ';'.join(rules)})
        for x in reg:
            w.writerow({'at': at, 'menu_id': mid, 'row_id': x['row_id'], 'rule_id': x['rule_id'], 'target': x['target'], 'before': x['before'], 'after': x['after'],
                        'outcome': '회귀', 'evidence': x['evidence'][:300], 'rules_rerun': ';'.join(rules)})
    print(f"[repair_close] {mid} {at} · 재판정 {res['seconds']}초{(' · ' + note) if note else ''} · 종결 {len(closed)}/{len(out)} · 미종결 {len(still)} · 그 밖 {len(other)} · 회귀 {len(reg)}")
    for x in still[:20]:
        print(f"  [미종결] {x['row_id']} [{x['rule_id']}] {x['after']} · {x['evidence'][:140]}")
    for x in other[:20]:
        print(f"  [{x['outcome']}] {x['row_id']} [{x['rule_id']}] {x['before']}→{x['after']} · {x['evidence'][:120]}")
    for x in reg[:20]:
        print(f"  [회귀] {x['row_id']} [{x['rule_id']}] {x['before']}→{x['after']} · {x['evidence'][:140]}")
    print(f"[repair_close] 결과 Doc/verify/{mid}/repair_close.json · 이력 Doc/verify/{mid}/_repair_close_history.csv")
    return 0 if (not still and not other and not reg) else 2


def main():
    a = sys.argv[1:]
    if '--selftest' in a:
        return selftest()
    if not a or a[0].startswith('--'):
        print(__doc__); return 3
    mid = a[0].upper(); vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    opt = lambda k: (a[a.index(k) + 1] if k in a and a.index(k) + 1 < len(a) else '')
    before = snapshot(mid)
    if not before:
        print(f'[repair_close] {mid}: verify_ledger.csv 없음 — CheckList(run_verify.py {mid}) 먼저'); return 3
    fx = rd(os.path.join(vd, 'fixlist.csv'))
    snap_p = os.path.join(vd, 'repair_before.json')
    if '--snapshot' in a:
        # 2026-11-11 VM 자동보완 체인용: 보완 직전 판정을 저장만 한다(재판정은 체인의 CheckList 단계가 한다)
        open_rows = [r['row_id'] for r in fx if (r.get('action_needed') or '').upper() == 'Y']
        json.dump({'at': time.strftime('%Y-%m-%d %H:%M:%S'), 'menu_id': mid, 'open_rows': open_rows, 'ledger': before}, open(snap_p, 'w', encoding='utf-8'), ensure_ascii=False)
        print(f"[repair_close] {mid}: 보완 전 스냅샷 저장 — 원장 {len(before)}행 · 조치 필요 {len(open_rows)}행 → Doc/verify/{mid}/repair_before.json"); return 0
    if '--compare' in a:
        # 스냅샷(보완 전) ↔ 지금 원장(보완·재판정 후) 비교 — 재실행 없음. 종결 대상 = 스냅샷 시점의 조치 필요 행 전부 · 회귀 = 화면 전체 행
        try:
            sn = json.load(open(snap_p, encoding='utf-8'))
        except (OSError, ValueError):
            print(f'[repair_close] {mid}: 보완 전 스냅샷 없음(repair_before.json) — 비교 생략'); return 0
        out, reg = compare(sn['ledger'], before, [r for r in sn.get('open_rows', [])])
        return record(mid, vd, out, reg, ['(전체 CheckList 재판정)'], 0, 0, f"보완 전 스냅샷 {sn.get('at')}")
    rows_opt = [x.strip() for x in opt('--rows').split(',') if x.strip()]
    rules_opt = [x.strip().upper() for x in opt('--rules').split(',') if x.strip()]
    if rows_opt:
        targets = [r for r in rows_opt if r in before]
        missing = [r for r in rows_opt if r not in before]
        if missing:
            print(f"[repair_close] 원장에 없는 행: {', '.join(missing)}")
    elif rules_opt:
        targets = [r['row_id'] for r in fx if (r.get('action_needed') or '').upper() == 'Y' and (r.get('rule_id') or '').upper() in rules_opt]
    elif '--all-open' in a:
        targets = [r['row_id'] for r in fx if (r.get('action_needed') or '').upper() == 'Y']
    else:
        # 2026-11-11 EN-23: 대상을 지정하지 않으면 '직전 정합검증 뒤 실제로 바뀐 것'을 측정해(repair_scope.py) 그 변경이 걸리는 행·규칙만 재판정한다
        sc = subprocess.run([sys.executable, os.path.join(HERE, 'repair_scope.py'), mid], capture_output=True, text=True, encoding='utf-8', errors='replace')
        print((sc.stdout or '').rstrip())
        try:
            scope = json.load(open(os.path.join(vd, 'repair_scope.json'), encoding='utf-8')) if sc.returncode == 0 else {}
        except (OSError, ValueError):
            scope = {}
        if not scope:
            print('[repair_close] 영향 범위 산출 실패 — --rules/--rows/--all-open 으로 대상을 지정'); return 3
        if not scope.get('changes'):
            print(f"[repair_close] {mid}: 직전 정합검증({scope.get('since')}) 뒤 변경이 측정되지 않음 — 재판정할 것이 없다(보완이 적용되지 않았거나 측정 범위 밖 · --all-open 으로 강제 가능)"); return 0
        targets = [r for r in scope.get('open_rows_hit', []) if r in before]
        scope_rules = [x.upper() for x in scope.get('rules', [])]
        if scope.get('full_recommended'):
            print('[repair_close] 주의: FE 변경이 측정됨 — 이번 재판정은 열린 조치 필요 행의 규칙만 다시 잰다. 화면 전체 회귀는 전체 CheckList 로 확인해야 한다')
    targets = list(dict.fromkeys(targets))
    rules = sorted(set(rules_opt) | {before[t]['rule_id'].upper() for t in targets if before[t]['rule_id']} | set(locals().get('scope_rules', [])))
    if not targets or not rules:
        print(f"[repair_close] {mid}: 종결 대상 없음(조치 필요 0 또는 지정 규칙·행이 원장에 없음)"); return 0
    cmd = [sys.executable, os.path.join(HERE, 'run_verify.py'), mid, '--only', ','.join(rules)]
    print(f"[repair_close] {mid}: 종결 대상 {len(targets)}행 · 재판정 규칙 {len(rules)}개({','.join(rules)})")
    print(f"[repair_close] 실행: python tools/Harness/verify/run_verify.py {mid} --only {','.join(rules)}")
    if '--dry' in a:
        for t in targets[:40]:
            print(f"  {t} [{before[t]['rule_id']}] {before[t]['result']} · {before[t]['target']}")
        return 0
    t0 = time.time()
    rc = subprocess.run(cmd, cwd=ROOT).returncode
    if rc not in (0, 2, 10):  # 0 정상 · 2/10 = 게이트 경고(문서는 생성됨). 그 밖 = 실행 실패
        print(f'[repair_close] run_verify 종료코드 {rc} — 재판정이 끝나지 않아 종결 판정을 하지 않는다'); return 3
    after = snapshot(mid)
    out, reg = compare(before, after, targets)
    return record(mid, vd, out, reg, rules, round(time.time() - t0), rc, '')


if __name__ == '__main__':
    sys.exit(main())
