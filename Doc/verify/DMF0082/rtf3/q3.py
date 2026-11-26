import sys,time
sys.path.insert(0,'tools/DbConn')
from dbconn import connect
with connect('tobe') as cx:
    cx.call_timeout=60000
    cur=cx.cursor()
    t=time.time()
    cur.execute("""select user_id, count(*) from SCM_MGR.SCM_MST_TITLESET_USER where program_id='DMF0082' and sheet_name='FcstNPrice'
      and user_inquiry_column_type_code='M' and column_name in ('MKT_FCST','SCM_FCST','RTF_SYS_RP') group by user_id having count(*)=3 order by 1""")
    print([r for r in cur][:20], round(time.time()-t,2),'s')
    t=time.time()
    cur.execute("""select count(*), count(distinct project_code||scm_site_id||item_id) from SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C
      where division_id='40' and version_no='SP_W_20261112_V001' and measure='RTF_SYS_RP' and yyyymmdd between '20261101' and '20261115' and qty<>0""")
    print(cur.fetchall(), round(time.time()-t,2),'s')
