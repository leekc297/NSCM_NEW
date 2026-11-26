import sys,time
sys.path.insert(0, r'C:/Projects/NSCM/tools/DbConn')
import dbconn
cx=dbconn.connect('tobe'); cx.call_timeout=60000; cur=cx.cursor()
def q(s,**k):
    t=time.time(); cur.execute(s,**k); cols=[d[0] for d in cur.description]; r=cur.fetchall(); print('--',round(time.time()-t,1),'s', len(r),'rows'); print(cols)
    for x in r: print(x)
q("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_MST_SHEET_MEASURE' ORDER BY COLUMN_ID")
q("SELECT * FROM SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID='DMF0082' ORDER BY SHEET_NAME, SORT_ORDER_NO")
q("""SELECT A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.MEASURE, A.YYYYMMDD, A.QTY FROM SCM_MGR.DM_PLN_MKT_FCST A
 WHERE A.DIVISION_ID='81' AND A.PROJECT_CODE='A17VA4001' AND A.YYYYMMDD BETWEEN '20261101' AND '20261210' AND A.QTY<>0
 ORDER BY A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.MEASURE, A.YYYYMMDD FETCH FIRST 400 ROWS ONLY""")
