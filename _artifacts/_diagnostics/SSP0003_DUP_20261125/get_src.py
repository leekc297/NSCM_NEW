import sys,time,oracledb,os
sys.path.insert(0,'_artifacts/_diagnostics')
env={}
for l in open('.env.asis',encoding='utf-8'):
    l=l.strip()
    if '=' in l and not l.startswith('#'):
        k,v=l.split('=',1); env[k]=v.strip().strip('"')
cx=oracledb.connect(user=env['TOBE_DB_USER'],password=env['TOBE_DB_PASS'],dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env.get('TOBE_DB_PDB','ZIOUI1')}")
cx.call_timeout=60000
c=cx.cursor()
c.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
c.execute("select sys_context('USERENV','SERVER_HOST'),sys_context('USERENV','SERVICE_NAME'),to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual"); print(c.fetchone())
t=time.time()
c.execute("select o.last_ddl_time from all_objects o where owner='SCM_MGR' and object_name='PKG_SSP0003' and object_type='PACKAGE BODY'"); print('last_ddl',c.fetchone())
c.execute("select text from all_source where owner='SCM_MGR' and name='PKG_SSP0003' and type='PACKAGE BODY' order by line")
open('_artifacts/_diagnostics/SSP0003_DUP_20261125/PKG_SSP0003_body.sql','w',encoding='utf-8').write(''.join(r[0] for r in c))
print('src sec',round(time.time()-t,2))
