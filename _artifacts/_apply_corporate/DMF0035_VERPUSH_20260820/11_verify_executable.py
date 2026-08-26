# -*- coding: utf-8 -*-
"""생성한 13_PKG_DMF0035_BODY.sql 이 **실제로 실행 가능한지** 사내에서 실증.

직전 사고(파일이 주석에 먹혀 실행 불가)를 재발시키지 않기 위해, 파일을 SQL*Plus 규칙대로 파싱해
  ①SET/주석 라인 제거 ②말미 '/' · SHOW ERRORS 제거 → CREATE 문 하나로 만들고 **사내에 실제 적용**한다.
사내는 이미 같은 본문이 올라가 있으므로 결과는 무변화(동일본 재컴파일)여야 한다.
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

DIR = r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0035_CLOUD_20260820\A_DB"
FNAME, PKG = "13_PKG_DMF0035_BODY.sql", "PKG_DMF0035"

raw = open(f"{DIR}\\{FNAME}", encoding="utf-8").read().splitlines()
stmt_lines, started = [], False
for l in raw:
    s = l.strip()
    if not started:
        if s.upper().startswith("SET ") or s.startswith("--") or not s:
            continue
        started = True
    if s == "/" or s.upper() == "SHOW ERRORS":
        break
    stmt_lines.append(l)
stmt = "\n".join(stmt_lines).strip()
assert re.match(r"CREATE OR REPLACE\s+PACKAGE BODY", stmt, re.I), stmt[:80]

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
cur.execute(stmt)

cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
               AND OBJECT_NAME=:n AND OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY') ORDER BY 1""", {"n": PKG})
sts = cur.fetchall()
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n", {"n": PKG})
errs = cur.fetchone()[0]
cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
               AND TYPE='PACKAGE BODY' AND INSTR(TEXT,'E20260820-VERPUSH') > 0""", {"n": PKG})
vp = cur.fetchone()[0]
cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
               AND TYPE='PACKAGE BODY' AND INSTR(TEXT,'E20260820-DS2') > 0""", {"n": PKG})
ds2 = cur.fetchone()[0]
print(f"[{FNAME}] 파일 그대로 실행 OK — {sts} / ALL_ERRORS {errs} / VERPUSH {vp} / DS2 {ds2}")
assert errs == 0 and len(sts) == 2 and all(s == "VALID" for _, s in sts) and vp == 6 and ds2 == 1
print("[OK] 실행 가능 + VALID + 마커 실측 일치")
con.close()
