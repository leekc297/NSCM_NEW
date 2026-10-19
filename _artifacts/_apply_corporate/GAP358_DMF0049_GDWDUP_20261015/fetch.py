import sys,pathlib,oracledb
sys.path.insert(0,'_artifacts/_diagnostics'); import ora
u,p,d=ora.conn_info(); cn=oracledb.connect(user=u,password=p,dsn=d); cur=cn.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'),TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print(cur.fetchone())
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'),STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0049' AND OBJECT_TYPE='PACKAGE BODY'"); print(cur.fetchone())
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0049' AND TYPE='PACKAGE BODY' ORDER BY LINE")
t="".join(r[0] for r in cur.fetchall())
pathlib.Path(sys.argv[1]).write_text(t,encoding='utf-8'); print(len(t.splitlines()))
