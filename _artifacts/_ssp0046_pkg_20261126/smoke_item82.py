import oracledb, pyodbc, time
env=dict(l.strip().split('=',1) for l in open(r'c:\Projects\NSCM\.env.asis',encoding='utf-8') if '=' in l and not l.startswith('#'))
c=oracledb.connect(user=env['TOBE_DB_USER'],password=env['TOBE_DB_PASS'],dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}"); c.call_timeout=300000
cur=c.cursor(); cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
cur.execute("select min(t.item_id) from dm_mst_item_single_v t, scm_mst_item_sn u where t.division_id='82' and t.item_id like 'E%' and t.item_type not in ('H','R') and u.division_id='82' and u.item_id=t.item_id and u.scp_operation_group='P'")
it=cur.fetchone()[0]; print('item',it)
r1,r2=cur.var(oracledb.CURSOR),cur.var(oracledb.CURSOR); t=time.time()
cur.callproc('PKG_SSP0046_CHK.P_SSP0046_GET_ITEM_BY_DIVISION_POPUPEX',['82','ALL','ALL',None,'ALL',it,'P',r1,r2])
print('TOBE rows',len(r1.getvalue().fetchall()),'sec',round(time.time()-t,1))
a=pyodbc.connect(f"DRIVER={{{env.get('ASIS_DB_DRIVER','ODBC Driver 17 for SQL Server')}}};SERVER={env['ASIS_DB_HOST']},{env['ASIS_DB_PORT']};DATABASE={env['ASIS_DB_NAME']};UID={env['ASIS_DB_USER']};PWD={env['ASIS_DB_PASS']};TrustServerCertificate=yes",timeout=30); a.timeout=300
ac=a.cursor(); t=time.time()
ac.execute("SET NOCOUNT ON; EXEC dbo.SSP0046_GET_ITEM_BY_DIVISION_POPUPEx '82','ALL','ALL','','ALL',?,'P'",it)
while ac.description is None and ac.nextset(): pass
print('ASIS rows',len(ac.fetchall()),'sec',round(time.time()-t,1))
