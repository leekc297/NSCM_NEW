# -*- coding: utf-8 -*-
"""최종 게이트 — ①이관 파일을 SQL*Plus 규칙대로 파싱해 **사내에 그대로 재실행**(실행 가능 실증)
   ②라이브 == 패치 아티팩트 == 이관 파일 본문 3자 일치 ③룰 #136 3축 + 마커 5종 보존."""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_RAWDATA_20260820"
DST = r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0035_CLOUD_20260820\A_DB\13_PKG_DMF0035_BODY.sql"
MARKS = {"E20260820-DS2": 1, "E20260820-WFITEMPERF": 2, "E20260820-VERPUSH]": 6,
         "E20260820-RAWSCALAR": 2, "E20260820-VERPUSH2": 5}


def norm(s):
    return "\n".join(l.rstrip() for l in s.strip().splitlines())


# ---------- ① 이관 파일을 SQL*Plus 규칙대로 파싱 ----------
raw = open(DST, encoding="utf-8").read().splitlines()
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
stmt = "\n".join(lines).strip()
assert re.match(r"CREATE OR REPLACE\s+PACKAGE BODY", stmt, re.I), stmt[:80]
print(f"[parse] 이관 파일 실행 문장 {len(lines)} lines — 첫 라인 OK")

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 30")
cur.execute(stmt)
print("[exec] 이관 파일 본문을 사내에 그대로 재실행 — 예외 없음")

cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
               AND OBJECT_NAME='PKG_DMF0035' AND OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY') ORDER BY 1""")
sts = cur.fetchall()
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'")
errs = cur.fetchone()[0]
print(f"[축1 STATUS] {sts}")
print(f"[축2 ERRORS] {errs}")
assert errs == 0 and all(s == "VALID" for _, s in sts), "3축 실패"

cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
live = norm("\n".join(r[0].rstrip("\n") for r in cur.fetchall()))
mk = {m: live.count(m) for m in MARKS}
print(f"[축3 마커  ] {mk}")
assert mk == MARKS, f"마커 불일치 — 기대 {MARKS}"

patched = norm(open(BASE + r"\03_PATCHED_STEPB_BODY.sql", encoding="utf-8").read())
deploy = norm(stmt[len("CREATE OR REPLACE "):])
print(f"  라이브    {len(live.splitlines())} lines")
print(f"  패치본    {len(patched.splitlines())} lines  일치={live == patched}")
print(f"  이관파일  {len(deploy.splitlines())} lines  일치={live == deploy}")
assert live == patched, "라이브 != 패치 아티팩트"
assert live == deploy, "라이브 != 이관 파일 본문"
print("[OK] 3자 일치 + 룰 #136 3축 + 마커 5종 보존 PASS")
con.close()
