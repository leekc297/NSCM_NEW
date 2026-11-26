import sys,time
sys.path.insert(0,'tools/DbConn')
from dbconn import connect
with connect('tobe') as cx:
    cx.call_timeout=60000
    cur=cx.cursor()
    t=time.time()
    cur.execute("select version_no,version_type,yyyymmdd,division_id from SCM_MGR.DM_MST_VERSION where division_id='40' and version_no like 'SF_W_202611%' order by 1")
    for r in cur: print(r)
    print(round(time.time()-t,1),'s')
    cur.execute("""select A.measure, count(*) from user_tab_columns where 1=0""") if False else None
    t=time.time()
    cur.execute("""select version_no, measure, count(*) from SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C where division_id='40' and version_no like 'SF_W_202611%' and measure like 'RTF%' group by version_no, measure order by 1,2""")
    for r in cur: print(r)
    print(round(time.time()-t,1),'s')
