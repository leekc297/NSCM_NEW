# 기존(뷰 경유) ↔ 대체(I·C 갈래 인라인 + 조건 안쪽) 결과 대조 — 조합마다 행 다중집합(중복 개수 포함) 일치 · 소요 시간
#   python -I cmp_select.py            → cmp_result.txt
import os, sys, time
from collections import Counter
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
D = os.path.dirname(os.path.abspath(__file__))
OLD = open(os.path.join(D, 'old_select.sql'), encoding='utf-8').read()
NEW = open(os.path.join(D, sys.argv[1] if len(sys.argv) > 1 else 'new_select.sql'), encoding='utf-8').read()
out = open(os.path.join(D, sys.argv[2] if len(sys.argv) > 2 else 'cmp_result.txt'), 'w', encoding='utf-8')
def log(s):
    print(s, flush=True); out.write(s + '\n'); out.flush()
with connect('tobe') as cx:
    c = cx.cursor()
    c.execute("SELECT DIVISION_ID, RESULT_DATE FROM SCM_MGR.SCM_DNM_INTRANSIT_C WHERE RESULT_TYPE IN ('I','C') AND VALID_YN='Y' AND RESULT_DATE >= '20260701' GROUP BY DIVISION_ID, RESULT_DATE ORDER BY RESULT_DATE DESC, DIVISION_ID")
    cases = [tuple(r) for r in c.fetchall()]
    extra = [(d, y) for d in ('81', '82', '40', '81_UC', 'EE') for y in ('20260907', '20260914', '20261009', '20261102')]
    cases += [x for x in extra if x not in cases]
    log(f'조합 {len(cases)} (데이터 있는 조합 + 데이터 없는 기준일 {len(extra)})')
    same = diff = 0; t_old = t_new = 0.0
    for i, (d, y) in enumerate(cases, 1):
        b = {'P_DIVISION_ID': d, 'V_CUTOFF_DAY': y}
        t = time.time(); c.execute(OLD, b); ro = c.fetchall(); to = time.time() - t
        t = time.time(); c.execute(NEW, b); rn = c.fetchall(); tn = time.time() - t
        t_old += to; t_new += tn
        ok = Counter(map(tuple, ro)) == Counter(map(tuple, rn))
        same += ok; diff += (not ok)
        if not ok or i % 25 == 0 or i <= 5:
            log(f'{i:3} {d:6} {y} 행 {len(ro):4}/{len(rn):4} {"같음" if ok else "다름"} 기존 {to:5.2f}s 대체 {tn:5.2f}s')
        if not ok:
            co, cn = Counter(map(tuple, ro)), Counter(map(tuple, rn))
            log('   기존에만: ' + repr(list((co - cn).items())[:3])[:600])
            log('   대체에만: ' + repr(list((cn - co).items())[:3])[:600])
    log(f'결과: 같음 {same} · 다름 {diff} / {len(cases)} · 합계 기존 {t_old:.1f}s 대체 {t_new:.1f}s · 평균 기존 {t_old/len(cases):.2f}s 대체 {t_new/len(cases):.3f}s')
out.close()
