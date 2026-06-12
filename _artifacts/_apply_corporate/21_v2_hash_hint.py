#!/usr/bin/env python3
"""
V2 SP 의 INSERT INTO GT_DMF0043_SALES_LIST_C 의 SELECT 에 강한 힌트:
  - LEADING(A) — GT_DMF0043_PLAN_REPORT_C 가 driver
  - USE_HASH(I SC B C TEAM) — NESTED LOOPS → HASH JOIN
  - DYNAMIC_SAMPLING(A 10) — GTT 통계 부재 보완

진단:
  V$SQL_PLAN: CARDINALITY=1, NESTED LOOPS 5단계 — GTT 통계 0 이라 CBO 잘못 추정
  실제 36K row × 5 levels NESTED LOOPS = 분 단위 hang
"""
import re
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))


def patch_sp(name, conn):
    cur = conn.cursor()
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=name)
    src = "".join(r[0] or "" for r in cur.fetchall())
    cur.close()

    # 패턴: (SELECT SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
    # 변환: (SELECT /*+ LEADING(A) USE_HASH(I SC B C TEAM) DYNAMIC_SAMPLING(A 10) */ SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
    p = re.compile(r"(\(\s*SELECT\s+)(SUBSTR\(A\.YYYYMMDD,1,6\)\s+AS\s+YYYYMM)", re.IGNORECASE)
    matches = p.findall(src)
    if not matches:
        return f"[{name}] no match"
    hint = "/*+ LEADING(A) USE_HASH(I) USE_HASH(SC) USE_HASH(B) USE_HASH(C) USE_HASH(TEAM) DYNAMIC_SAMPLING(A 10) */ "
    patched = p.sub(rf"\1{hint}\2", src)

    cur = conn.cursor()
    try:
        cur.execute("CREATE OR REPLACE " + patched)
        conn.commit()
        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'", n=name)
        st = cur.fetchone()[0]
        return f"[{name}] STATUS={st}"
    except oracledb.DatabaseError as e:
        return f"[{name}] ERR: {str(e)[:120]}"
    finally:
        cur.close()


def main():
    conn = oracledb.connect(**CONN)
    cur0 = conn.cursor()
    cur0.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
    cur0.close()
    try:
        for sp in ["DMF0043_GET_CONTRIBUTION_SALES_LIST_V2", "DMF0043_GET_CONTRIBUTION_SALES_LIST_V3"]:
            print(patch_sp(sp, conn))
    finally:
        conn.close()
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
