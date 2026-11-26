import sys,time
sys.path.insert(0, r'C:/Projects/NSCM/tools/DbConn')
import dbconn
cx=dbconn.connect('tobe'); cx.call_timeout=300000; cur=cx.cursor()
for div in ('81','40'):
    rcs=[cx.cursor() for _ in range(6)]
    t=time.time()
    cur.callproc('SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA',[div,'ALL','ALL','ALL','20261101','20270430','ALL',None,'Current','N','minyonglee1','ADMIN','ALL','ALL','ALL','ALL']+rcs)
    n=len(rcs[0].fetchall()); print(div,'rows',n, round(time.time()-t,1),'s', rcs[5].fetchall())
