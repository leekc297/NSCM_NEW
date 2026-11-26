import sys, time
sys.path.insert(0, r'C:\Projects\NSCM\_artifacts\_diagnostics')
import ora, oracledb
u,p,d = ora.conn_info()
c = oracledb.connect(user=u,password=p,dsn=d); c.call_timeout=60000
cur=c.cursor(); cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
for t,f in (('PACKAGE BODY','body'),('PACKAGE','spec')):
    t0=time.time()
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0082' AND type=:t ORDER BY line",t=t)
    rows=[r[0] for r in cur]
    open(sys.argv[1]+'/'+f+'.sql','w',encoding='utf-8').write(''.join(rows))
    print(t,len(rows),'lines',round(time.time()-t0,1),'s')
