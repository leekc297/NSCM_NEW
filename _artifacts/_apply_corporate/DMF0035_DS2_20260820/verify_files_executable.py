# -*- coding: utf-8 -*-
"""생성한 패키지 BODY 파일이 **실제로 실행 가능한지** 사내에서 검증.

직전 사고(파일이 주석에 먹혀 실행 불가)를 재발시키지 않기 위해, 파일을 SQL*Plus 규칙대로 파싱해
  ①SET 라인 제거 ②말미 '/' · SHOW ERRORS 제거 → CREATE 문 하나로 만들고 **사내에 실제 적용**한다.
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
FILES = {"13_PKG_DMF0035_BODY.sql": "PKG_DMF0035",
         "15_PKG_DMF0022_BODY.sql": "PKG_DMF0022",
         "17_PKG_DMF0051_BODY.sql": "PKG_DMF0051"}

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 30")

for fname, pkg in FILES.items():
    raw = open(f"{DIR}\\{fname}", encoding="utf-8").read().splitlines()
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
    cur.execute(stmt)
    cur.execute("SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n",
                {"n": pkg})
    sts = cur.fetchall()
    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n", {"n": pkg})
    errs = cur.fetchone()[0]
    cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                   AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260820-DS2%'""", {"n": pkg})
    ds2 = cur.fetchone()[0]
    print(f"[{fname}] 실행 OK — {sts} / ERRORS {errs} / DS2 {ds2}")
    assert errs == 0 and all(s == "VALID" for _, s in sts) and ds2 >= 1
con.close()
print("[OK] 3본 전부 파일 그대로 실행 가능·VALID 확인")
