# -*- coding: utf-8 -*-
"""PRODUCT_CREATE 문장 위치 특정 — 사용자가 직접 소스를 볼 수 있도록 라인 범위 제시"""
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

print("== 1) PRODUCT_CREATE 라벨/프로시저 위치 ==")
cur.execute("""SELECT LINE, RTRIM(TEXT) FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND (UPPER(TEXT) LIKE '%PRODUCT_CREATE%' OR UPPER(TEXT) LIKE '%DEPT_CREATE%')
                ORDER BY LINE""")
for ln, t in cur.fetchall():
    print("  L%-6d %s" % (ln, t.strip()[:150]))

print("\n== 2) DM_MOBILE_REPORT_PRODUCT INSERT 위치 ==")
cur.execute("""SELECT LINE, RTRIM(TEXT) FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND INSTR(UPPER(TEXT),'DM_MOBILE_REPORT_PRODUCT')>0
                ORDER BY LINE""")
for ln, t in cur.fetchall():
    print("  L%-6d %s" % (ln, t.strip()[:150]))

print("\n== 3) DM_MOBILE_REPORT_DEPT INSERT 위치 ==")
cur.execute("""SELECT LINE, RTRIM(TEXT) FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND INSTR(UPPER(TEXT),'DM_MOBILE_REPORT_DEPT')>0
                ORDER BY LINE""")
for ln, t in cur.fetchall():
    print("  L%-6d %s" % (ln, t.strip()[:150]))

print("\n== 4) 프로시저 선언 위치 (경계 파악용) ==")
cur.execute("""SELECT LINE, RTRIM(TEXT) FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND REGEXP_LIKE(TEXT, '^\\s*PROCEDURE\\s+P_DMF0044', 'i')
                ORDER BY LINE""")
for ln, t in cur.fetchall():
    print("  L%-6d %s" % (ln, t.strip()[:110]))

print("\n== 5) ISV CTE (TUNE-M) 위치 ==")
cur.execute("""SELECT LINE, RTRIM(TEXT) FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
                  AND (INSTR(TEXT,'TUNE-M')>0 OR INSTR(UPPER(TEXT),'WITH ISV')>0
                       OR INSTR(UPPER(TEXT),'MATERIALIZE')>0)
                ORDER BY LINE""")
for ln, t in cur.fetchall():
    print("  L%-6d %s" % (ln, t.strip()[:150]))
con.close()
