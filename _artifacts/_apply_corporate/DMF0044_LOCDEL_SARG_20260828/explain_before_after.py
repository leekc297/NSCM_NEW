#!/usr/bin/env python3
"""LOCDELSARG 정정 전/후 실행계획 대조 (EXPLAIN PLAN — 실행 없음, 데이터 무변경)."""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "_diagnostics"))
import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

BEFORE = """
DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
WHERE A.MEASURE = 'LOC'
AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
    WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
    AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
    AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
    AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
    AND B.SEQ_RANK = 1)
"""

AFTER = """
DELETE FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
WHERE A.MEASURE = 'LOC'
AND A.DIVISION_ID = '40' AND A.VERSION_NO = 'R_S_20260715_V002_C'
AND EXISTS (SELECT 1 FROM SCM_MGR.GT_0044_RESULTS_MST_C B
    WHERE B.VERSION_NO = A.VERSION_NO AND B.DIVISION_ID = A.DIVISION_ID AND B.DEPARTMENT_ID = A.DEPARTMENT_ID AND B.DEPT_ID = A.DEPT_ID
    AND B.END_CUST_REPORT = A.END_CUST_REPORT AND B.CUST_REPORT = A.CUST_REPORT AND B.PRODUCT_GROUP = A.PRODUCT_GROUP
    AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID
    AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,6)||'%' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID
    AND B.SEQ_RANK = 1)
"""


def explain(cur, tag: str, sql: str) -> None:
    cur.execute(f"EXPLAIN PLAN SET STATEMENT_ID='{tag}' FOR " + sql)
    cur.execute(
        "SELECT plan_table_output FROM TABLE(DBMS_XPLAN.DISPLAY(NULL, :t, 'BASIC ROWS COST'))",
        t=tag,
    )
    print(f"===== {tag} =====")
    for (line,) in cur.fetchall():
        print(line)
    print()


def main() -> None:
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        explain(cur, "LOCDEL_BEFORE", BEFORE)
        explain(cur, "LOCDEL_AFTER", AFTER)


if __name__ == "__main__":
    main()
