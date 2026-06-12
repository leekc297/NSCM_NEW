#!/usr/bin/env python3
"""
V2 SP에서 hint 제거 — 0 rows 사고 진단/복구.

가설:
  hint `NO_NL(I SC B C TEAM)` 가 LEFT JOIN 의 join 순서를 깨뜨려
  결과가 0 row 가 되는 사고 가능성. APPEND 도 GTT 와 충돌 위험.

복구:
  - INSERT 의 /*+ APPEND */ 제거
  - SELECT 의 /*+ LEADING(A) USE_HASH(...) NO_NL(...) */ 제거
  결과: V1 동일 패턴 (UF_FX_STRING_SPLIT inline 변환은 유지)
"""
import re, datetime
from pathlib import Path
import oracledb

CONN_PARAMS = dict(user="SCM_MGR", password="!SCMroqkf2026",
                    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))
SP = "DMF0043_GET_CONTRIBUTION_SALES_LIST_V2"


def main():
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    conn = oracledb.connect(**CONN_PARAMS)
    cur0 = conn.cursor()
    cur0.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 180")
    cur0.close()
    try:
        cur = conn.cursor()
        cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=SP)
        src = "".join(r[0] or "" for r in cur.fetchall())
        cur.close()

        # Remove APPEND hint
        patched = re.sub(
            r"INSERT\s*/\*\+\s*APPEND\s*\*/\s*INTO\s+GT_DMF0043_SALES_LIST_C",
            "INSERT INTO GT_DMF0043_SALES_LIST_C",
            src,
            flags=re.IGNORECASE,
        )
        # Remove SELECT hint comment
        patched = re.sub(
            r"\(SELECT\s*/\*\+[^*]*\*/\s*SUBSTR\(A\.YYYYMMDD,1,6\)\s+AS\s+YYYYMM",
            "(SELECT SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM",
            patched,
            flags=re.IGNORECASE,
        )

        if patched == src:
            print("[NO CHANGE] hints 이미 제거됨")
            return 0

        cur = conn.cursor()
        cur.execute("CREATE OR REPLACE " + patched)
        conn.commit()
        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n", n=SP)
        st = cur.fetchone()[0]
        cur.close()
        print(f"[OK] hints 제거, STATUS={st}")
        return 0 if st == "VALID" else 5
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
