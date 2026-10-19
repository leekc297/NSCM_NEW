"""DB 원문 새로 조회 (진단용) — PKG_DMF0022 BODY + GTT ON COMMIT 정의"""
import sys, pathlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
HERE = pathlib.Path(__file__).resolve().parent
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print(cur.fetchone())
    cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0022'"); print(cur.fetchall())
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0022' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    (HERE / "PKG_DMF0022_BODY.NOW.sql").write_text("".join(r[0] for r in cur), encoding="utf-8", newline="")
    cur.execute("SELECT TABLE_NAME, TEMPORARY, DURATION FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME LIKE 'GT_DM22%' ORDER BY 1")
    for r in cur: print(r)
