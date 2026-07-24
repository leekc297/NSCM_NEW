# -*- coding: utf-8 -*-
"""Deploy tuned PKG_DMF0005 body (live redeploy, DDL_LOCK_TIMEOUT guard) + compile verify."""
import io, os, oracledb

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
with io.open(os.path.join(BASE_DIR, "01_PKG_DMF0005_body_tuned.sql"), "r", encoding="utf-8") as f:
    ddl = f.read()

conn = oracledb.connect(user=os.environ["NSCM_ORA_USER"], password=os.environ["NSCM_ORA_PASS"], dsn=os.environ["NSCM_ORA_DSN"])
cur = conn.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 280")
cur.execute(ddl)
print("deployed.")

cur.execute("SELECT object_type, status FROM user_objects WHERE object_name='PKG_DMF0005'")
for r in cur.fetchall():
    print("status:", r)

cur.execute("SELECT line, position, text FROM user_errors WHERE name='PKG_DMF0005' ORDER BY sequence")
errs = cur.fetchall()
print("errors:", len(errs))
for r in errs[:20]:
    print(r)

cur.execute("SELECT COUNT(*) FROM user_source WHERE name='PKG_DMF0005' AND type='PACKAGE BODY' AND text LIKE '%[PERF-DMF0005 20260722]%'")
print("marker lines in deployed source:", cur.fetchone()[0])
