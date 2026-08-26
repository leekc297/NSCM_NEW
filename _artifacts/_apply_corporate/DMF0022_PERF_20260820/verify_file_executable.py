# -*- coding: utf-8 -*-
"""생성한 패키지 파일이 **실제로 실행 가능한지** 사내에 그대로 재실행해 실증.

정본 패턴: _artifacts/_apply_corporate/DMF0035_DS2_20260820/verify_files_executable.py
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
FILES = {"15_PKG_DMF0022_BODY.sql": "PKG_DMF0022"}
MK = {"E20260820-DS2": 1, "v_measure_sheet": 6,
      "E20260820-D22PREREDUCE": 2, "E20260820-D22VERPUSH": 2}

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")

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
    cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
                    WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n ORDER BY 1""", {"n": pkg})
    sts = cur.fetchall()
    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n", {"n": pkg})
    errs = cur.fetchone()[0]
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                    AND TYPE='PACKAGE BODY' ORDER BY LINE""", {"n": pkg})
    live = "".join(r[0] for r in cur.fetchall())
    mk = {k: live.count(k) for k in MK}
    print(f"[{fname}] 파일 그대로 실행 OK — {sts} / ALL_ERRORS {errs} / 마커 {mk}")
    assert errs == 0 and all(s == "VALID" for _, s in sts)
    assert all(mk[k] == v for k, v in MK.items())
con.close()
print("[OK] 파일 실행 가능·VALID·마커 보존 실증 완료")
