import sys, pathlib, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
u,p,d = ora.conn_info()
out = pathlib.Path(sys.argv[1])
with oracledb.connect(user=u,password=p,dsn=d) as c:
    cur=c.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print(cur.fetchone())
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'),STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0022' AND OBJECT_TYPE='PACKAGE BODY'"); print(cur.fetchone())
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0022' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    out.write_text("".join(r[0] for r in cur.fetchall()), encoding="utf-8", newline="")
