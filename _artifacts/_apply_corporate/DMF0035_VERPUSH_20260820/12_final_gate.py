# -*- coding: utf-8 -*-
"""최종 게이트 — 라이브 본문 == 패치 아티팩트 == 이관 파일 본문 3자 일치 + 3축 재확인."""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_VERPUSH_20260820"
DEPLOY = r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0035_CLOUD_20260820\A_DB\13_PKG_DMF0035_BODY.sql"


def norm(s):
    return "\n".join(l.rstrip() for l in s.strip().splitlines())


u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
live = norm("\n".join(r[0].rstrip("\n") for r in cur.fetchall()))
patched = norm(open(BASE + r"\01_PATCHED_PKG_DMF0035_BODY.sql", encoding="utf-8").read())

# 이관 파일에서 본문만 추출
raw = open(DEPLOY, encoding="utf-8").read().splitlines()
lines, started = [], False
for l in raw:
    s = l.strip()
    if not started:
        if s.upper().startswith("SET ") or s.startswith("--") or not s:
            continue
        started = True
    if s == "/" or s.upper() == "SHOW ERRORS":
        break
    lines.append(l)
deploy_body = norm("\n".join(lines))
assert deploy_body.upper().startswith("CREATE OR REPLACE PACKAGE BODY")
deploy_body = norm(deploy_body[len("CREATE OR REPLACE "):])

print(f"  라이브    {len(live.splitlines())} lines")
print(f"  패치본    {len(patched.splitlines())} lines   일치={live == patched}")
print(f"  이관파일  {len(deploy_body.splitlines())} lines   일치={live == deploy_body}")
assert live == patched, "라이브 != 패치 아티팩트"
assert live == deploy_body, "라이브 != 이관 파일 본문"

cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
               AND OBJECT_NAME='PKG_DMF0035' AND OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY') ORDER BY 1""")
sts = cur.fetchall()
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'")
errs = cur.fetchone()[0]
cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
               AND TYPE='PACKAGE BODY' AND INSTR(TEXT,'E20260820-VERPUSH')>0""")
mk = cur.fetchone()[0]
print(f"  3축: {sts} / ALL_ERRORS {errs} / VERPUSH {mk}")
assert errs == 0 and all(s == "VALID" for _, s in sts) and mk == 6
print("[OK] 3자 일치 + 3축 PASS")
con.close()
