# -*- coding: utf-8 -*-
"""배치 금액 재계산을 세션 안에서 실행 → 결과 저장 → ROLLBACK (원장 무변경 시험).
사용: python run_batch_rollback.py <라벨> <사업부> [<사업부> ...]
LOCAL_KRW 는 내부 COMMIT 없음(원문 L752 주석·전체 확인) · 로그 프로시저는 자율 트랜잭션."""
import sys, os, json, time, hashlib
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
sys.stdout.reconfigure(encoding='utf-8')
import dbconn

HERE = os.path.dirname(os.path.abspath(__file__))
label, divs = sys.argv[1], sys.argv[2:]
cx = dbconn.connect('tobe', dbconn.load_cfg()); cx.autocommit = False; c = cx.cursor()
c.execute("select to_char(fn_next_day(sysdate,'MON')-7,'YYYYMMDD') from dual"); mon = c.fetchone()[0]
SEL = """select project_code, scm_site_id, item_id, dom_exp, fcst_type, incoterms, measure, plant_site_id, cell_prod_site_id, yyyymmdd, currency, to_char(qty,'TM9')
  from dm_pln_sales_plan where division_id=:d and yyyymmdd>=:m"""


def snap(d):
    c.execute(SEL, d=d, m=mon)
    return {'|'.join(str(x) for x in r[:10]): [r[10], r[11]] for r in c.fetchall()}


out = {}
for d in divs:
    before = snap(d)
    t = time.time()
    c.callproc('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', [d, 'SYSTEM'])
    sec = round(time.time() - t, 2)
    after = snap(d)
    cx.rollback()
    back = snap(d)
    assert back == before, f'ROLLBACK 후 원장 다름 {d}'
    out[d] = {'sec': sec, 'before': before, 'after': after}
    print(label, d, 'sec', sec, 'rows before', len(before), 'after', len(after), 'rollback same True',
          time.strftime('%H:%M:%S'), flush=True)
with open(os.path.join(HERE, f'_batch_{label}.json'), 'w', encoding='utf-8') as f:
    json.dump({'mon': mon, 'at': time.strftime('%Y-%m-%d %H:%M:%S'), 'divs': out}, f, ensure_ascii=False)
print('saved', label)
