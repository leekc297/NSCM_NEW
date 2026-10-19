"""GAP078 전/후 조회 결과 스냅샷 — PKG_DMF0005 조회 SP 40/81/82 (minyonglee1, 전체 조건) → pickle"""
import sys,time,pickle;sys.path.insert(0,r'C:\Projects\NSCM\_artifacts\_diagnostics')
import ora,oracledb
u,p,d=ora.conn_info();con=oracledb.connect(user=u,password=p,dsn=d);cur=con.cursor()
out={}
for div in ('40','81','82'):
    rc=cur.var(oracledb.CURSOR);rs=cur.var(oracledb.CURSOR);t=time.time()
    cur.callproc('PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION',[div,'ALL','ALL','ALL','','','ALL','','minyonglee1',rc,rs])
    c=rc.getvalue();cols=[x[0] for x in c.description];rows=c.fetchall();el=time.time()-t
    out[div]=(cols,rows,el);print(div,'rows',len(rows),'%.1fs'%el,rs.getvalue().fetchall())
con.rollback();pickle.dump(out,open(sys.argv[1],'wb'))
