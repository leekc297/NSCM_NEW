# 쿼리 실행(시간 제한 측정) 후 그 커서의 실제 계획 출력
import oracledb,sys,re,time
env=dict(l.strip().split('=',1) for l in open(r'c:\Projects\NSCM\.env.asis',encoding='utf-8') if '=' in l and not l.startswith('#'))
c=oracledb.connect(user=env['TOBE_DB_USER'],password=env['TOBE_DB_PASS'],dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
c.call_timeout=int(sys.argv[3])*1000 if len(sys.argv)>3 else 60000
cur=c.cursor(); cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
sql=open(sys.argv[1],encoding='utf-8').read().strip().rstrip(';')
val=sys.argv[2] if len(sys.argv)>2 else '81'
t=time.time(); cur.execute(sql,{k:val for k in set(re.findall(r':([A-Za-z]\w*)',sql))}); n=len(cur.fetchall())
print('ROWS',n,'SEC',round(time.time()-t,2))
cur.execute("SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL,NULL,'BASIC +ROWS'))")
for r in cur:
    if r[0] and r[0].strip(): print(r[0])
