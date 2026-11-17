# DB 원문 새로 조회 (hook #152 §3.1) — 기준본 = 이 조회 결과만
import sys, pathlib, datetime, oracledb
sys.path.insert(0, r'C:\Projects\NSCM\_artifacts\_diagnostics')
import ora
out = pathlib.Path(sys.argv[1]); out.mkdir(parents=True, exist_ok=True)
u,p,d = ora.conn_info()
con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
cur.execute("SELECT SYS_CONTEXT('USERENV','CON_NAME'), SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
print("DB", cur.fetchone())
for name in sys.argv[2:]:
    for typ in ("PACKAGE","PACKAGE BODY"):
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
        meta = cur.fetchone()
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ)
        src = "".join(r[0] for r in cur.fetchall())
        f = out / f"{name}.{typ.replace(' ','_')}.ASIS.sql"
        f.write_text(src, encoding="utf-8", newline="")
        print(name, typ, meta, "lines", src.count("\n"), "->", f.name)
