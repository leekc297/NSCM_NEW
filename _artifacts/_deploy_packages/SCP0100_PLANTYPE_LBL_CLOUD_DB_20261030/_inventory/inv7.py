import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb
u,p,d = conn_info()
con = oracledb.connect(user=u,password=p,dsn=d); cur=con.cursor()
cur.execute("SELECT GRANTEE,PRIVILEGE FROM DBA_TAB_PRIVS WHERE OWNER='SCM_MGR' AND TABLE_NAME='PKG_SCP0100'"); print("DBA_TAB_PRIVS PKG_SCP0100:", cur.fetchall())
cur.execute("SELECT TABLE_NAME FROM DBA_TAB_PRIVS WHERE OWNER='SCM_MGR' AND GRANTEE='SCMP_APP' AND PRIVILEGE='EXECUTE' AND TABLE_NAME LIKE 'PKG_SCP01%' ORDER BY 1"); print("SCMP_APP EXECUTE PKG_SCP01xx:", [r[0] for r in cur.fetchall()])
cur.execute("SELECT OBJECT_NAME FROM DBA_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_TYPE='PACKAGE' AND OBJECT_NAME LIKE 'PKG_SCP%' MINUS SELECT TABLE_NAME FROM DBA_TAB_PRIVS WHERE OWNER='SCM_MGR' AND PRIVILEGE='EXECUTE'"); print("PKG_SCP without any EXECUTE grant:", [r[0] for r in cur.fetchall()])
cur.execute("SELECT GRANTEE, PRIVILEGE FROM DBA_TAB_PRIVS WHERE OWNER='SCM_MGR' AND TABLE_NAME IN ('FN_GET_REPORT_USER_COLUMNS','FN_SPLITSTRING','FN_CHAR_TO_DATE','SCP_PLAN_VERSION_V') ORDER BY 1"); print("deps grants:", cur.fetchall())
try:
    c2 = oracledb.connect(user="SCMP_APP", password=p, dsn=d).cursor()
    c2.execute("SELECT OWNER,OBJECT_NAME,OBJECT_TYPE,STATUS FROM ALL_OBJECTS WHERE OBJECT_NAME='PKG_SCP0100'"); print("SCMP_APP sees:", c2.fetchall())
    c2.execute("SELECT SYS_CONTEXT('USERENV','SESSION_USER') FROM DUAL"); print(c2.fetchone())
    try:
        c2.execute("BEGIN NULL; END;")
        c2.execute("DECLARE x NUMBER; BEGIN SELECT 1 INTO x FROM DUAL WHERE EXISTS (SELECT 1 FROM ALL_PROCEDURES WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SCP0100'); DBMS_OUTPUT.PUT_LINE(x); END;")
        c2.execute("SELECT COUNT(*) FROM ALL_PROCEDURES WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SCP0100'"); print("ALL_PROCEDURES visible count:", c2.fetchone())
    except Exception as e: print("exec test err", e)
except Exception as e: print("SCMP_APP connect err", e)
