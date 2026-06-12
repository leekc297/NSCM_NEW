#!/usr/bin/env python3
"""
V5 body → V1 (원본 이름) 으로 덮어쓰기 + V2/V3/V4/V5 DROP + 메타 V1 으로 원복.

전제:
  - 현재 SCM_ADM_API_M.API_URL = V5
  - V1 은 fix 안 된 옛 body (lock 으로 인해 fix 누락 가능)
  - V5 가 최종 fix 본 (ORDER BY fix + inline first-token + HASH 힌트 + PG join 제거)
"""
import re
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))
V1 = "DMF0043_GET_CONTRIBUTION_SALES_LIST"
VERSIONS = [
    "DMF0043_GET_CONTRIBUTION_SALES_LIST_V2",
    "DMF0043_GET_CONTRIBUTION_SALES_LIST_V3",
    "DMF0043_GET_CONTRIBUTION_SALES_LIST_V4",
    "DMF0043_GET_CONTRIBUTION_SALES_LIST_V5",
]
FINAL_SRC = "DMF0043_GET_CONTRIBUTION_SALES_LIST_V5"


def main():
    conn = oracledb.connect(**CONN)
    cur0 = conn.cursor()
    cur0.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 1800")
    cur0.close()
    try:
        # STEP 1: V5 body fetch + V1 이름으로 변환
        cur = conn.cursor()
        cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=FINAL_SRC)
        src = "".join(r[0] or "" for r in cur.fetchall())
        cur.close()
        if not src:
            print(f"[FAIL] {FINAL_SRC} not found")
            return 2

        v1_src = re.sub(
            rf'\bPROCEDURE\s+(\s*"?){re.escape(FINAL_SRC)}("?)',
            rf'PROCEDURE \1{V1}\2',
            src, count=1, flags=re.IGNORECASE,
        )
        print(f"[STEP 1] V5 body → V1 이름으로 변환 ({len(v1_src)} chars)")

        # STEP 2: V1 덮어쓰기 (락 충돌 시 자동 30분 대기)
        cur = conn.cursor()
        try:
            cur.execute("CREATE OR REPLACE " + v1_src)
            conn.commit()
            cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n", n=V1)
            st = cur.fetchone()[0]
            print(f"[STEP 2] V1 CREATE OR REPLACE — STATUS={st}")
        except oracledb.DatabaseError as e:
            print(f"[STEP 2 ERR] {e}")
            return 3
        cur.close()
        if st != "VALID":
            return 4

        # STEP 3: 메타 V5 → V1 원복
        cur = conn.cursor()
        cur.execute("UPDATE SCM_ADM_API_M SET API_URL=:v1 WHERE API_ID='P_DMF0043_SALES_LIST_GET'", v1=V1)
        ar = cur.rowcount
        cur.execute("UPDATE SCM_ADM_PROC_M SET PROC_NM=:v1 WHERE PROC_NM IN ('DMF0043_GET_CONTRIBUTION_SALES_LIST_V2','DMF0043_GET_CONTRIBUTION_SALES_LIST_V3','DMF0043_GET_CONTRIBUTION_SALES_LIST_V4','DMF0043_GET_CONTRIBUTION_SALES_LIST_V5')", v1=V1)
        pr = cur.rowcount
        conn.commit()
        cur.close()
        print(f"[STEP 3] 메타 V1 원복: API_M={ar} / PROC_M={pr}")

        # STEP 4: V2~V5 DROP
        cur = conn.cursor()
        for sp in VERSIONS:
            try:
                cur.execute(f'DROP PROCEDURE "{sp}"')
                print(f"[STEP 4] DROP {sp} [OK]")
            except oracledb.DatabaseError as e:
                if "ORA-04043" in str(e):  # not found
                    print(f"[STEP 4] {sp} 이미 없음")
                else:
                    print(f"[STEP 4 WARN] {sp}: {str(e)[:100]}")
        conn.commit()
        cur.close()

        # STEP 5: 최종 검증
        cur = conn.cursor()
        cur.execute("""
            SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS
             WHERE OBJECT_NAME LIKE 'DMF0043_GET_CONTRIBUTION_SALES_LIST%'
               AND OBJECT_TYPE='PROCEDURE'
             ORDER BY OBJECT_NAME
        """)
        print(f"[STEP 5] 최종 SP 인벤토리:")
        for r in cur.fetchall():
            print(f"    {r[0]}: {r[1]}")
        cur.execute("SELECT API_URL FROM SCM_ADM_API_M WHERE API_ID='P_DMF0043_SALES_LIST_GET'")
        print(f"    API_URL = {cur.fetchone()[0]}")
        cur.execute("SELECT DISTINCT PROC_NM FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE 'DMF0043_GET_CONTRIBUTION_SALES_LIST%'")
        for r in cur.fetchall():
            print(f"    PROC_NM = {r[0]}")
        cur.close()
        return 0
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
