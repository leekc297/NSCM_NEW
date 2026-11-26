# 2026-11-25 미검증 해소 게이트 시험(checklist_run.py settle_state, gate) · 사용: py tools/Harness/verify/test_unverified_gate.py
import sys, os, json, csv, shutil, io, contextlib
sys.path.insert(0, r'c:\Projects\NSCM\tools\Harness\verify')
import checklist_run as C
mid = 'ZZGATE0'; vd = os.path.join(C.ROOT, 'Doc', 'verify', mid); os.makedirs(vd, exist_ok=True)
def setup(act, stalled=False, cont=0):
    json.dump({'actionable': act, 'stalled': stalled, 'continue': cont, 'after': {'total': act}}, open(os.path.join(vd, 'unverified_triage.json'), 'w', encoding='utf-8'))
    with open(os.path.join(vd, 'unverified_triage.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['row_id', 'rule_id', 'class', 'actor', 'remedy']); w.writeheader()
        for i in range(act): w.writerow({'row_id': f'V-{i}', 'rule_id': 'A1', 'class': '검사기공백', 'actor': '엔진', 'remedy': 'x'})
def g():
    b = io.StringIO()
    with contextlib.redirect_stdout(b): rc = C.gate(mid)
    return rc, b.getvalue()
ok = True
def chk(n, c, x=''):
    global ok; print('PASS' if c else 'FAIL', n, x); ok &= bool(c)
setup(0); C.settle_state(mid, 'measured', 0); rc, o = g(); chk('처리 대상 0 → 통과', rc == 0, o.strip())
setup(3, stalled=True); C.settle_state(mid, 'measured', 0); rc, o = g(); chk('풀린 행 0 → 재검증 안 함(rc 1) + 남은 행 목록', rc == 1 and 'V-0' in o and '풀린 행 0' in o, o.splitlines()[0])
setup(2, cont=1); C.settle_state(mid, 'measured', 0); rc, o = g(); chk('5회차 상한 도달(continue 1) → rc 1 + 반복 상한', rc == 1 and '반복 상한 도달' in o)
setup(2); C.settle_state(mid, 'failed', 5); rc, o = g(); chk('해소 확인 재측정 실패 → rc 1', rc == 1 and 'rc 5' in o)
setup(4); C.settle_state(mid, 'fullonly', 0); rc, o = g(); chk('남은 행 = 전체 재측정으로만 잴 행 → 통과', rc == 0 and '전체 재검증으로만' in o)
os.remove(os.path.join(vd, 'unverified_settle.json')); rc, o = g(); chk('해소 확인 결과 없음 → rc 1', rc == 1)
# 2026-11-25 F1: 행 ID 이어 붙이기, 같은 대상 결정, 직전 보완 실패, 해소 확인 환경
import unverified_resolve as U
led = [{'row_id': 'T-aaaaaa01', 'source': 'TRACE', 'rule_id': 'F4', 'target': 'SP_XYZ_GET', 'result': '판정필요'},
       {'row_id': 'T-aaaaaa02', 'source': 'TRACE', 'rule_id': 'A6', 'target': 'SP_XYZ_GET', 'result': 'ERROR'},
       {'row_id': 'V-aaaaaa03', 'source': 'RULE', 'rule_id': 'E4', 'target': 'L/T 합계', 'result': 'ERROR'}]
for k in ('row_keys.json',):
    try: os.remove(os.path.join(vd, k))
    except OSError: pass
os.makedirs(vd, exist_ok=True)
f0 = U.id_bridge(mid, [{'row_id': 'V-old00001', 'source': 'RULE', 'rule_id': 'E4', 'target': 'L/T 합계'}])
f1 = U.id_bridge(mid, led)
chk('행 ID 이어 붙이기: 옛 ID → 같은 출처·규칙·대상의 지금 ID', f1('V-old00001') == 'V-aaaaaa03' and f1('V-zzz') == 'V-zzz')
tri = [{'row_id': 'T-aaaaaa02', 'rule_id': 'A6', 'target': 'SP_XYZ_GET', 'class': '검사기공백', 'actor': '엔진', 'remedy': ''},
       {'row_id': 'V-aaaaaa03', 'rule_id': 'E4', 'target': 'L/T 합계', 'class': '검사기공백', 'actor': '엔진', 'remedy': ''}]
dec = {'T-aaaaaa01': {'id': 'R4-D2', 'what': '진입 시나리오', 'rec': '판정필요', 'ref': 'cs:208'}}
n = U.same_target_decisions(mid, tri, led, dec)
chk('같은 대상(SP_XYZ_GET) 측정 불가 행 → 같은 결정, 다른 대상은 그대로', n == 1 and tri[0]['actor'] == '결정' and tri[1]['actor'] == '엔진')
open(os.path.join(vd, '_unverified_plan.md'), 'w', encoding='utf-8').write(chr(10).join(['| No | row_id | 결과 | 사유·고친 곳 |', '|---|---|---|---|', '| 1 | V-old00001* | 고침 | judge.py:10 |', '| 2 | T-x | 결정 | - |']) + chr(10))
pf = U.prev_fix_failed(mid, tri, f1)
chk('직전 조치표 고침인데 지금도 처리 대상(옛 ID 포함) → 직전 보완 실패 표시', pf == 1 and tri[1].get('prev_fail') == 'Y' and '직전 보완 실패' in tri[1]['remedy'])
env = C.settle_env([{'row_id': 'ES-1', 'target': 'SCP E2E authcrud 저장 왕복'}, {'row_id': 'FACT-1'}], ['suite'], [])
chk('해소 확인 환경: E2E 4종은 그 행 종류만, FACT 행 있으면 사실 검토', env['VERIFY_SETTLE'] == '1' and env['VERIFY_SUITE_KINDS'] == 'authcrud' and env['VERIFY_SETTLE_FACT'] == '1')
# 2026-11-25 행 단위 해소: 해소 원장 고정, row_run 결과 반영(닫힘, 시도 2회 뒤 결정), 회차 점검, 게이트
os.makedirs(vd, exist_ok=True)
for f in ('unverified_worklist.csv', 'unverified_worklist.json', 'row_keys.json'):
    try: os.remove(os.path.join(vd, f))
    except OSError: pass
L = [{'row_id': 'V-w1', 'source': 'RULE', 'rule_id': 'A4', 'target': 't1', 'result': 'ERROR'}, {'row_id': 'V-w2', 'source': 'RULE', 'rule_id': 'K3', 'target': 't2', 'result': 'ERROR'},
     {'row_id': 'V-w3', 'source': 'RULE', 'rule_id': 'B4', 'target': 't3', 'result': 'ERROR'}]
def wled(rows):
    with open(os.path.join(vd, 'verify_ledger.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['row_id', 'source', 'rule_id', 'target', 'result', 'evidence']); w.writeheader(); w.writerows(rows)
wled(L)
tri = [dict(r, **{'class': '검사기공백', 'actor': '엔진', 'remedy': ''}) for r in L]
m = U.worklist_sync(mid, tri, L, {'mode': 'full', 'at': 'T1'})
chk('해소 원장 고정: 3행 열림', m['open'] == 3 and m['total'] == 3)
m = U.worklist_sync(mid, tri + [{'row_id': 'V-new', 'rule_id': 'X', 'target': 'n', 'class': '검사기공백', 'actor': '엔진'}], L, {'mode': 'only', 'at': 'T2'})
chk('고정 뒤 새 미검증 행은 넣지 않음', m['total'] == 3)
U.worklist_update(mid, [{'row_id': 'V-w1', 'after': 'PASS', 'state': '닫힘', 'run': 'R1'}, {'row_id': 'V-w2', 'after': 'ERROR', 'state': '열림', 'run': 'R1'}])
m = U.worklist_update(mid, [{'row_id': 'V-w2', 'after': 'ERROR', 'state': '열림', 'run': 'R2'}])
rows_, _ = U.wl_read(mid); st = {w['row_id']: w['state'] for w in rows_}
chk('row_run 판정 = 닫힘 · 시도 2회 뒤 미검증 = 결정 · 시도 없는 행 = 열림', st == {'V-w1': 'closed', 'V-w2': 'decided', 'V-w3': 'open'}, str(st))
b = io.StringIO()
with contextlib.redirect_stdout(b): C.wl_round(mid)
j = json.load(open(os.path.join(vd, 'unverified_worklist.json'), encoding='utf-8'))
chk('회차 점검: 이번 회차 닫힘 2 · 열린 1 → 계속', j['round'] == 1 and j['last_progress'] == 2 and j['continue'] == 1, b.getvalue().strip())
with contextlib.redirect_stdout(io.StringIO()): C.wl_round(mid)
j = json.load(open(os.path.join(vd, 'unverified_worklist.json'), encoding='utf-8'))
chk('회차 점검: 닫힌 행 0 → 반복 끝', j['continue'] == 0)
rc, o = g(); chk('게이트: 열린 행 있음 → rc 1 + 행별 시도 횟수', rc == 1 and 'V-w3' in o and '시도 0회' in o)
wled([dict(L[0], result='PASS'), dict(L[1]), dict(L[2], result='FAIL')])
rc, o = g(); chk('게이트: 원장에서 판정 난 행 = 닫힘 → 열린 행 0 → 통과', rc == 0, o.strip()[:120])
shutil.rmtree(vd)
print('ALL PASS' if ok else 'SOME FAIL')
