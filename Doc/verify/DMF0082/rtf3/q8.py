import sys,time
sys.path.insert(0,'tools/DbConn')
from dbconn import connect
with connect('tobe') as cx:
    cx.call_timeout=60000
    cur=cx.cursor()
    t=time.time()
    cur.execute("""select division_id, version_no, count(*) from SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C
       where version_no in (select version_no from SCM_MGR.DM_MST_VERSION where version_type like 'SP%' and yyyymmdd>='20261001')
       and measure='RTF_SYS_RP' and qty<>0 group by division_id, version_no order by 1,2""")
    for r in cur: print(r)
    print(round(time.time()-t,2),'s')
    t=time.time()
    cur.execute("""select division_id, count(*) from SCM_MGR.SCM_MST_SHEET_MEASURE where 1=0 group by division_id""") if False else None
