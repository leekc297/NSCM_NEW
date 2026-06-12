#!/usr/bin/env python3
"""
v_sql_text 의 각 부분 (CTE / outer SELECT 1 / outer SELECT 2) isolate parse test.
정확한 ORA fail 위치 식별.
"""
from pathlib import Path
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)
SQL_FILE = Path(__file__).parent.parent / "_diagnostics" / "DMF0043_vsql_dumped.sql"


def test(label, sql, conn):
    cur = conn.cursor()
    try:
        cur.parse(sql)
        print(f"[OK   parse] {label}")
    except oracledb.DatabaseError as e:
        print(f"[ERR parse] {label}: {str(e).splitlines()[0]}")
    cur.close()


def main():
    full = SQL_FILE.read_text(encoding="utf-8", errors="replace")
    conn = oracledb.connect(**CONN_PARAMS)

    # 1. CTE 만 (SELECT * FROM SALES_LIST)
    cte_end = full.find(")\n\nSELECT")
    if cte_end < 0:
        cte_end = full.find(")\n\r\nSELECT")
    cte_only = full[:cte_end+1] + "\nSELECT * FROM SALES_LIST"
    test("CTE only", cte_only, conn)

    # 2. CTE + outer SELECT 1 (UNION ALL 직전까지)
    union_pos = full.find("UNION ALL")
    cte_plus_outer1 = full[:union_pos]
    test("CTE + outer SELECT 1", cte_plus_outer1, conn)

    # 3. CTE + outer SELECT 2 (UNION ALL 부터 끝)
    cte_part = full[:cte_end+1]
    outer2 = full[union_pos:].replace("UNION ALL", "", 1)
    cte_plus_outer2 = cte_part + "\n" + outer2
    test("CTE + outer SELECT 2", cte_plus_outer2, conn)

    # 4. 전체 (UNION ALL 포함)
    test("FULL (CTE + UNION ALL)", full, conn)

    # 5. outer SELECT 2 에서 ORDER BY 제거 → 검증
    full_no_order = full.split("ORDER BY")[0]
    test("FULL without ORDER BY", full_no_order, conn)

    # 6. outer SELECT 2 에서 GROUP BY 추가 → 검증
    # outer SELECT 2 의 SELECT 'Total', null, ... SUM(...), ... AS Total#  FROM SALES_LIST A
    # 끝에 GROUP BY A.YYYYMM, ... 추가
    outer2_with_groupby = full.replace(
        "FROM   SALES_LIST A\n ORDER BY",
        "FROM   SALES_LIST A\n GROUP BY A.YYYYMM, A.DEPARTMENT_NAME, A.DEPT_NAME, A.CUST_REPORT, A.END_CUST_REPORT, A.SHIPTO_CODE, A.SOLDTO_CUST_REPORT, A.PRODUCT_GROUP, A.DM_BIZ_TYPE\n ORDER BY",
        1,  # second occurrence (outer SELECT 2)
    )
    # 다만 첫 occurrence 변경됐을 수도 — separately
    # 일단 simple version
    test("FULL with GROUP BY on outer2 (실험)", outer2_with_groupby, conn)

    conn.close()


if __name__ == "__main__":
    main()
