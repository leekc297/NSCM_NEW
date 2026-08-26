#!/usr/bin/env python3
"""정정① MERGE 의 적용 전/후 실행계획 대조 (EXPLAIN PLAN — 실행 없음)."""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1].parent / "_diagnostics"))
from ora import conn_info  # noqa
import oracledb

USING = """(
        SELECT MODEL, BIZ_TYPE, CELL_PACK_COUNT, DIVISION_ID
        FROM (SELECT SEGMENT2 AS MODEL, SEGMENT3 AS BIZ_TYPE, SEGMENT4 AS CELL_PACK_COUNT, SEGMENT1 AS DIVISION_ID,
                     RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
              FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40')
        WHERE MODEL_RANK = 1
    ) LOOKA"""

BEFORE = f"""MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
    USING {USING} ON (LOOKA.MODEL = A.ITEM_ID AND LOOKA.DIVISION_ID = A.DIVISION_ID)
    WHEN MATCHED THEN UPDATE
    SET A.FORECAST_INFO_CELL_PACK_COUNT = LOOKA.CELL_PACK_COUNT,
        A.FORECAST_INFO_BIZ_TYPE        = LOOKA.BIZ_TYPE,
        A.LAST_UPDATED_BY               = :b2,
        A.LAST_UPDATE_DATE              = SYSDATE
    WHERE A.DIVISION_ID = '40' AND A.VERSION_NO = :b1"""

AFTER = f"""MERGE INTO SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C A
    USING {USING} ON (LOOKA.MODEL = A.ITEM_ID AND LOOKA.DIVISION_ID = A.DIVISION_ID
                      AND A.DIVISION_ID = '40' AND A.VERSION_NO = :b1)
    WHEN MATCHED THEN UPDATE
    SET A.FORECAST_INFO_CELL_PACK_COUNT = LOOKA.CELL_PACK_COUNT,
        A.FORECAST_INFO_BIZ_TYPE        = LOOKA.BIZ_TYPE,
        A.LAST_UPDATED_BY               = :b2,
        A.LAST_UPDATE_DATE              = SYSDATE"""

u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    for tag, sql in (("BEFORE", BEFORE), ("AFTER", AFTER)):
        cur.execute(f"EXPLAIN PLAN SET STATEMENT_ID='DMF0044_{tag}' FOR {sql}", {"b1": "X", "b2": "Y"})
        cur.execute("""SELECT PLAN_TABLE_OUTPUT FROM TABLE(
                         DBMS_XPLAN.DISPLAY('PLAN_TABLE', :s, 'BASIC +COST +ROWS'))""",
                    {"s": f"DMF0044_{tag}"})
        print(f"########## {tag} ##########")
        for (line,) in cur.fetchall():
            print(line)
        print()
    con.rollback()
