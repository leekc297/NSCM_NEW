import sys,time
sys.path.insert(0,'tools/DbConn')
from dbconn import connect
with connect('tobe') as cx:
    cx.call_timeout=60000
    cur=cx.cursor()
    def q(s,b=None):
        t=time.time(); cur.execute(s,b or {}); r=cur.fetchall(); print('--',round(time.time()-t,2),'s'); [print(x) for x in r]; return r
    q("select sheet_name,column_name,attribute5,valid_yn from SCM_MGR.SCM_MST_SHEET_MEASURE where program_id='DMF0082' and attribute5 is not null order by 1,2")
    q("""select V.VERSION_NO,(SELECT MAX(V2.VERSION_NO) FROM SCM_MGR.DM_MST_VERSION V2 JOIN SCM_MGR.SCM_SYS_CALENDAR_M CM ON V2.YYYYMMDD=CM.BASIS_YYYYMMDD
        WHERE V2.VERSION_TYPE LIKE 'SP%' AND V2.DIVISION_ID=V.DIVISION_ID AND CM.ISO_YYYYWW=C.ISO_YYYYWW) SPV
        from SCM_MGR.DM_MST_VERSION V JOIN SCM_MGR.SCM_SYS_CALENDAR_M C ON C.BASIS_YYYYMMDD=V.YYYYMMDD
        where V.division_id='40' and V.version_type in ('SF_W','SP_W','MF_W') and V.yyyymmdd>='20261001' order by 1""")
