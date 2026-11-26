import sys,time
sys.path.insert(0, r'C:/Projects/NSCM/tools/DbConn')
import dbconn
cx=dbconn.connect('tobe'); cx.call_timeout=60000; cur=cx.cursor()
def q(s,**k):
    t=time.time(); cur.execute(s,**k); r=cur.fetchall(); print('--',round(time.time()-t,1),'s'); 
    for x in r: print(x)
q("SELECT SHEET_NAME, COLUMN_NAME, MEASURE_GROUP, SORT_ORDER_NO FROM SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID='DMF0082' ORDER BY SHEET_NAME, SORT_ORDER_NO")
