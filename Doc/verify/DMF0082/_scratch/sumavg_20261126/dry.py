import sys,time
sys.path.insert(0, r'C:/Projects/NSCM/tools/DbConn')
import dbconn
pk=open(r'C:/Projects/NSCM/_artifacts/_deploy_packages/DMF0082_CLOUD_DB_MOD_20261126_1333/A_DB/20_PKG_PKG_DMF0082.sql',encoding='utf-8').read()
b=pk[pk.index('/* PACKAGE BODY PKG_DMF0082'):]
b=b[b.index('DECLARE'):]; b=b[:b.index('\n/\n')]
b=b.replace('c_dry   CONSTANT BOOLEAN := FALSE','c_dry   CONSTANT BOOLEAN := TRUE')
import re
b=re.sub(r"FOR r IN \(SELECT TEXT FROM USER_SOURCE.*?END LOOP;","v_raw := :src;",b,count=1,flags=re.S)
src=open(r'C:/Projects/NSCM/_artifacts/_apply_corporate/DMF0082_PRICE_AVG_QTY_20261126/00_BACKUP_PKG_DMF0082_BODY.ASIS.sql',encoding='utf-8').read()
cx=dbconn.connect('tobe'); cx.call_timeout=120000; cur=cx.cursor()
cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
cur.callproc('DBMS_OUTPUT.ENABLE',[None])
t=time.time(); cv=cur.var(dbconn.oracledb.DB_TYPE_CLOB) if hasattr(dbconn,'oracledb') else None
import oracledb
cv=cur.var(oracledb.DB_TYPE_CLOB); cv.setvalue(0,src)
cur.execute(b,src=cv); print('run',round(time.time()-t,1),'s')
l=cur.var(str); s=cur.var(int)
while True:
    cur.callproc('DBMS_OUTPUT.GET_LINE',(l,s))
    if s.getvalue()!=0: break
    print(l.getvalue())
