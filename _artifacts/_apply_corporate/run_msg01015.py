"""MSG01015 신규 채번 적용 러너 — MSG01015_DMF0074_TEMPLATE_EMPTY_20260820.sql 실행."""
import os
import re

import oracledb

BASE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(BASE, "MSG01015_DMF0074_TEMPLATE_EMPTY_20260820.sql")

vals = {}
with open(r"C:\Projects\NSCM\.env.asis", encoding="utf-8") as f:
    for ln in f:
        ln = ln.strip()
        if "=" in ln and not ln.startswith("#"):
            k, v = ln.split("=", 1)
            vals[k] = v

with open(SRC, encoding="utf-8") as f:
    raw = f.read()
lines = [ln for ln in raw.splitlines() if not ln.lstrip().startswith("--")]
stmts = [s.strip() for s in "\n".join(lines).split(";") if s.strip()]
assert len(stmts) == 5, f"statement count {len(stmts)} != 5"

conn = oracledb.connect(
    user="SCM_MGR", password=vals["TOBE_DB_PASS"],
    dsn=f"{vals['TOBE_DB_HOST']}:{vals['TOBE_DB_PORT']}/{vals['TOBE_DB_PDB']}",
)
cur = conn.cursor()
for s in stmts:
    cur.execute(s)
    head = re.sub(r"\s+", " ", s)[:60]
    if s.upper().startswith("SELECT"):
        for r in cur.fetchall():
            print("VERIFY", r)
    else:
        print("OK", cur.rowcount if s.upper().startswith("INSERT") else "", head)
conn.commit()
print("DONE")
