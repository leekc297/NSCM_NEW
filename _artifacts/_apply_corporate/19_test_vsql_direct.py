#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTION_SALES_LIST 의 GT 채움 + 동적 SQL 직접 실행.
방법:
  1. SP 호출 (silent fallback 활성 — GT 채움까지만)
  2. GT_DMF0043_SALES_LIST_C row count + sample
  3. dump 받은 동적 SQL 을 cursor.execute() 직접 실행 → 정확 ORA 위치
"""
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)

VSQL = r"""
WITH SALES_LIST AS (
    SELECT A.YYYYMM, A.DEPARTMENT_NAME, A.DEPT_NAME, A.DEPARTMENT_ID, A.DEPT_ID
         , A.CUST_REPORT, A.END_CUST_REPORT, A.SOLDTO_CUST_REPORT, A.SHIPTO_CODE
         , A.PRODUCT_GROUP, A.DM_BIZ_TYPE, A.EDIT_FLAG
         , SUM(CASE WHEN NVL(B.CONTRIBUTION_RATIO,0) > 0 AND B.CONTRIBUTION_TYPE = 'Commission' AND B.OS_CORP_CD = 'RBU_0001'
                  THEN B.CONTRIBUTION_RATIO/100*A.AMT ELSE 0 END) AS "RBU_0001#Commission"
      FROM GT_DMF0043_SALES_LIST_C A
INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL B
       ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
      AND A.DEPT_ID = B.DEPT_ID
      AND A.END_CUST_REPORT = B.END_CUST_REPORT
      AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
      AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
      AND A.DM_BIZ_TYPE = B.DM_BIZ_TYPE
      AND A.YYYYMM = B.YYYYMM
     WHERE B.VER_SEQ = 8
     GROUP BY A.YYYYMM, A.DEPARTMENT_NAME, A.DEPT_NAME, A.DEPARTMENT_ID, A.DEPT_ID
            , A.CUST_REPORT, A.END_CUST_REPORT, A.SOLDTO_CUST_REPORT, A.SHIPTO_CODE
            , A.PRODUCT_GROUP, A.DM_BIZ_TYPE, A.EDIT_FLAG
)
SELECT A.YYYYMM, A.DEPARTMENT_NAME, A.DEPT_NAME, A.CUST_REPORT, A.END_CUST_REPORT
     , A.SHIPTO_CODE, A.SOLDTO_CUST_REPORT, A.PRODUCT_GROUP, A.DM_BIZ_TYPE
     , SUM("RBU_0001#Commission") AS "RBU_0001#Commission"
  FROM SALES_LIST A
 GROUP BY A.YYYYMM, A.DEPARTMENT_NAME, A.DEPT_NAME, A.CUST_REPORT, A.END_CUST_REPORT
        , A.SHIPTO_CODE, A.SOLDTO_CUST_REPORT, A.PRODUCT_GROUP, A.DM_BIZ_TYPE
"""

# alternative — unquoted (SP body 가 사용하는 형식)
VSQL_UNQUOTED = VSQL.replace('"', '')


def main():
    conn = oracledb.connect(**CONN_PARAMS)
    try:
        # 1. parse only with quoted identifier (방어적)
        cur = conn.cursor()
        print("=== TEST 1: quoted identifier '\"RBU_0001#Commission\"' ===")
        try:
            cur.parse(VSQL)
            print("[OK] parse OK")
            cur.execute(VSQL)
            rows = cur.fetchall()
            print(f"  rows: {len(rows)} (GT 비어있으면 0)")
        except oracledb.DatabaseError as e:
            print(f"[ERR] {e}")
        cur.close()

        print()
        cur = conn.cursor()
        print("=== TEST 2: unquoted identifier 'RBU_0001#Commission' (SP body 형식) ===")
        try:
            cur.parse(VSQL_UNQUOTED)
            print("[OK] parse OK")
            cur.execute(VSQL_UNQUOTED)
            rows = cur.fetchall()
            print(f"  rows: {len(rows)} (GT 비어있으면 0)")
        except oracledb.DatabaseError as e:
            print(f"[ERR] {e}")
        cur.close()

        # 3. GT row count (다른 session 의 row 는 보이지 않을 수 있음)
        print()
        print("=== TEST 3: GT_DMF0043_SALES_LIST_C row count (현 session) ===")
        cur = conn.cursor()
        cur.execute("SELECT COUNT(*) FROM GT_DMF0043_SALES_LIST_C")
        print(f"  rows: {cur.fetchone()[0]}")
        cur.close()
    finally:
        conn.close()


if __name__ == "__main__":
    main()
