"""ZT 테스트용 — 사내 ZIOUI1 에서 패키지/프로시저 원본을 파일로 내려받는다 (읽기 전용 SELECT).
사용: python zt_fetch.py PKG_SSP0045 PKG_SSP0015 ...
출력: zt/_src/<NAME>__PACKAGE.sql, <NAME>__PACKAGE_BODY.sql (ALL_SOURCE 원문 그대로, 줄 번호 보존)"""
import sys, os
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, "_src"); os.makedirs(OUT, exist_ok=True)
u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    for name in sys.argv[1:]:
        for ty in ("PACKAGE", "PACKAGE BODY", "PROCEDURE", "FUNCTION"):
            cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:1 AND type=:2 ORDER BY line", [name, ty])
            lines = [r[0] or "" for r in cur]
            if not lines:
                continue
            path = os.path.join(OUT, f"{name}__{ty.replace(' ', '_')}.sql")
            open(path, "w", encoding="utf-8", newline="").write("".join(lines))
            stamp = cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'), status FROM all_objects WHERE owner='SCM_MGR' AND object_name=:1 AND object_type=:2", [name, ty]).fetchone()
            print(name, ty, len(lines), "lines | last_ddl", stamp[0], stamp[1], "->", os.path.relpath(path, HERE))
