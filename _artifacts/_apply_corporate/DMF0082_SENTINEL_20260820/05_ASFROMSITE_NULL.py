"""AS FROM SITE(ATTRIBUTE10) '-' -> NULL 일괄 정리 (2026-08-20 사용자 지시).
대상 = DMF0082 GET 이 AS_FROM_SITE 로 읽는 수요/실적 원장 8본의 ATTRIBUTE10.
사용: python 05_ASFROMSITE_NULL.py count   (건수 확인만)
      python 05_ASFROMSITE_NULL.py apply   (UPDATE + COMMIT + 재검증)
"""
import os
import sys

import oracledb

ENV_PATH = r"C:\Projects\NSCM\.env.asis"
TABLES = [
    "DM_PLN_MKT_FCST",
    "DM_PLN_MKT_FCST_C",
    "DM_PLN_CFM_MKT_DEMAND_PLAN",
    "DM_PLN_CFM_MKT_DEMAND_PLAN_C",
    "DM_PLN_CFM_MKT_DEMAND_PLAN_H",
    "DM_PLN_MKT_FCST_RESULT_C",
    "DM_PLN_SALES_PLAN_RESULT",
    "DM_PLN_SALES_PLAN_RESULT_C",
]

vals = {}
with open(ENV_PATH, encoding="utf-8") as f:
    for ln in f:
        ln = ln.strip()
        if "=" in ln and not ln.startswith("#"):
            k, v = ln.split("=", 1)
            vals[k] = v

conn = oracledb.connect(
    user="SCM_MGR",
    password=vals["TOBE_DB_PASS"],
    dsn=f"{vals['TOBE_DB_HOST']}:{vals['TOBE_DB_PORT']}/{vals['TOBE_DB_PDB']}",
)
cur = conn.cursor()
mode = sys.argv[1]

for t in TABLES:
    try:
        cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{t} WHERE ATTRIBUTE10 = '-'")
        n = cur.fetchone()[0]
    except oracledb.DatabaseError as e:
        print(f"{t}: SKIP ({e.args[0].code})")
        continue
    if mode == "apply" and n > 0:
        cur.execute(f"UPDATE SCM_MGR.{t} SET ATTRIBUTE10 = NULL WHERE ATTRIBUTE10 = '-'")
        print(f"{t}: '-'={n} -> updated {cur.rowcount}")
    else:
        print(f"{t}: '-'={n}")

if mode == "apply":
    conn.commit()
    for t in TABLES:
        try:
            cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{t} WHERE ATTRIBUTE10 = '-'")
            print(f"VERIFY {t}: remain={cur.fetchone()[0]}")
        except oracledb.DatabaseError:
            pass
    print("apply DONE")
