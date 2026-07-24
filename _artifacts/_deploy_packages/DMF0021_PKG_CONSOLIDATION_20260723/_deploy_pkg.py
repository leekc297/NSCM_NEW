# -*- coding: utf-8 -*-
import os, io, oracledb
BASE = os.path.dirname(os.path.abspath(__file__))
conn = oracledb.connect(user=os.environ["NSCM_ORA_USER"], password=os.environ["NSCM_ORA_PASS"], dsn=os.environ["NSCM_ORA_DSN"])
cur = conn.cursor(); cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT=280")
def run(fn):
    with io.open(os.path.join(BASE,"sp",fn),"r",encoding="utf-8") as f: sql=f.read()
    sql = sql.strip()
    if sql.endswith("/"): sql = sql[:-1].rstrip()
    cur.execute(sql); print("deployed:", fn)
run("PKG_DMF0021_SPEC.sql")
run("PKG_DMF0021_BODY.sql")
cur.execute("SELECT object_type,status FROM user_objects WHERE object_name='PKG_DMF0021'")
for r in cur.fetchall(): print("status:", r)
cur.execute("SELECT line,position,text FROM user_errors WHERE name='PKG_DMF0021' ORDER BY sequence")
errs=cur.fetchall(); print("errors:", len(errs))
for e in errs[:15]: print("  ", e)
cur.execute("SELECT DISTINCT procedure_name FROM user_procedures WHERE object_name='PKG_DMF0021' AND procedure_name IS NOT NULL ORDER BY 1")
print("members:", [r[0] for r in cur.fetchall()])
