# DB 원문 새로 조회 (ALL_SOURCE) -> ASIS 백업
import sys, pathlib, oracledb
sys.path.insert(0, r'_artifacts/_diagnostics'); import ora
u,p,d = ora.conn_info(); c = oracledb.connect(user=u,password=p,dsn=d); cur=c.cursor()
out = pathlib.Path(sys.argv[1])
for typ, fn in (("PACKAGE BODY","PKG_DMF0082_BODY.ASIS.sql"),("PACKAGE","PKG_DMF0082_SPEC.ASIS.sql")):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE=:t",t=typ)
    ld = cur.fetchone()[0]
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE=:t ORDER BY LINE",t=typ)
    src = "".join(r[0] for r in cur.fetchall())
    (out/fn).write_text(src, encoding="utf-8", newline="")
    print(typ, ld, len(src.splitlines()))
