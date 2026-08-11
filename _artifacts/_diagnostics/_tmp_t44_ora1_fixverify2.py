#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""수정안 총합 불변 재검증 — Oracle NUMBER 정밀도로 SQL 안에서 차감한다.

1차 판정 'FAIL' 은 **측정 오류**였다: Python float 로 4e12 규모를 합산해 1e-3 차이가 났고
(상대오차 ~1e-16 = 배정도 한계) 내가 절대허용오차 1e-6 을 걸었다.
여기서는 합계를 Oracle 이 NUMBER 로 계산하고 **차이를 SQL 에서 직접 0 과 비교**한다.
"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

DIV, VER = '40', 'R_S_20260810_V009_C'
u, p, dsn = conn_info()
con = oracledb.connect(user=u, password=p, dsn=dsn)
con.call_timeout = 900000
cur = con.cursor()

cur.execute("DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C")
cur.execute("""
INSERT INTO SCM_MGR.GT_DMF0044_DEPT_RPT_C
 ( DIVISION_ID, PRODUCT_GROUP, MEASURE, YYYYMMDD, ATTRIBUTE1, ATTRIBUTE2,
   DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, QTY )
WITH ISV AS (
  SELECT /*+ MATERIALIZE */ DIVISION_ID, ITEM_ID,
         MAX(MAX(FORECAST_INFO_BIZ_TYPE))        OVER (PARTITION BY DIVISION_ID, SUBSTR(ITEM_ID,1,12)) AS FORECAST_INFO_BIZ_TYPE,
         MAX(MAX(FORECAST_INFO_CELL_PACK_COUNT)) OVER (PARTITION BY DIVISION_ID, SUBSTR(ITEM_ID,1,12)) AS FORECAST_INFO_CELL_PACK_COUNT
    FROM SCM_MST_ITEM_SN WHERE DIVISION_ID=:d GROUP BY DIVISION_ID, ITEM_ID )
SELECT A.DIVISION_ID, A.PRODUCT_GROUP,
       CASE WHEN A.MEASURE='Business_Plan' THEN 'RTF' ELSE A.MEASURE END,
       A.YYYYMMDD, A.ATTRIBUTE1, A.ATTRIBUTE2, A.DEPARTMENT_ID, A.DEPT_ID,
       A.END_CUST_REPORT, A.CUST_REPORT,
       CASE WHEN A.MEASURE IN ('RTF','Business_Plan','RTF_SYS_RP') AND B.FORECAST_INFO_BIZ_TYPE='PACK'
                 AND B.FORECAST_INFO_CELL_PACK_COUNT<>0
            THEN A.QTY*NVL(B.FORECAST_INFO_CELL_PACK_COUNT,1) ELSE A.QTY END
  FROM DM_PLN_SALES_PLAN_REPORT_C A LEFT OUTER JOIN ISV B
    ON A.DIVISION_ID=B.DIVISION_ID AND A.ITEM_ID=B.ITEM_ID
 WHERE A.DIVISION_ID=:d AND A.VERSION_NO=:v
   AND A.MEASURE IN ('Business_Plan','RTF','RTF_SYS_RP','SalesAmt_KRW') AND A.DATA_TYPE='1'
UNION ALL
SELECT A.DIVISION_ID, A.PRODUCT_GROUP,
       CASE WHEN A.MEASURE='Business_Plan' THEN 'RTF' ELSE A.MEASURE END,
       A.YYYYMMDD, A.PRODUCT_DETAILS, A.ATTRIBUTE2, A.DEPARTMENT_ID, A.DEPT_ID,
       A.END_CUST_REPORT, A.CUST_REPORT,
       CASE WHEN A.MEASURE IN ('RTF','Business_Plan') AND B.FORECAST_INFO_BIZ_TYPE='PACK'
                 AND B.FORECAST_INFO_CELL_PACK_COUNT<>0
            THEN A.QTY*NVL(B.FORECAST_INFO_CELL_PACK_COUNT,1) ELSE A.QTY END
  FROM DM_PLN_SALES_ETC_REPORT_C A LEFT OUTER JOIN ISV B
    ON A.DIVISION_ID=B.DIVISION_ID AND A.ITEM_ID=B.ITEM_ID
 WHERE A.DIVISION_ID=:d AND A.VERSION_NO=:v
   AND A.MEASURE IN ('Business_Plan','RTF','RTF_SYS_RP','SalesAmt_KRW')
""", {"d": DIV, "v": VER})
print(f"[준비] GTT {cur.rowcount:,} 행\n")

INNER = """
    SELECT A.YYYY, A.DEPARTMENT_NAME, A.DEPT_NAME, A.CUST_REPORT AS CUST_INFO,
           A.PRODUCT_NAME, A.PRODUCT_DETAIL, A.MEASURE, B.DISPLAY_SEQ,
           {SUMS}
      FROM ( SELECT Y.YYYY AS YYYY, LD.SEGMENT2 AS DEPARTMENT_NAME, LT.SEGMENT2 AS DEPT_NAME,
                    C.CUST_REPORT, C.PRODUCT_GROUP AS PRODUCT_NAME,
                    {DETAIL_EXPR} AS PRODUCT_DETAIL,
                    C.MEASURE, SUBSTR(C.YYYYMMDD,1,6) AS YYYYMM, C.QTY
               FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C C
               CROSS JOIN ( SELECT DISTINCT SUBSTR(YYYYMMDD,1,4) AS YYYY
                              FROM DM_PLN_SALES_PLAN_REPORT_C
                             WHERE DIVISION_ID=:d AND VERSION_NO=:v ) Y
               LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LD
                 ON LD.LOOKUP_TYPE='MDF_DEPARTMENT'           AND LD.SEGMENT1=C.DEPARTMENT_ID
               LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LT
                 ON LT.LOOKUP_TYPE='DMF0044_DEPARTMENT_TEAM2' AND LT.SEGMENT1=C.DEPT_ID
              WHERE C.MEASURE IN ('Business_Plan','RTF','RTF_SYS_RP','SalesAmt_KRW')
                AND C.YYYYMMDD LIKE Y.YYYY||'%' ) A
      LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
        ON A.CUST_REPORT=B.SEGMENT1 AND B.LOOKUP_TYPE='REPORT_GROUP2'
     GROUP BY A.YYYY, A.DEPARTMENT_NAME, A.DEPT_NAME, A.CUST_REPORT, A.PRODUCT_NAME,
              A.PRODUCT_DETAIL, B.DISPLAY_SEQ, A.MEASURE
"""
SUMS = ", ".join(
    f"SUM(CASE WHEN A.YYYYMM=A.YYYY||'{i:02d}' THEN A.QTY ELSE 0 END) MM{i:02d}" for i in range(1, 13))
TOT = ", ".join(f"SUM(MM{i:02d}) T{i:02d}" for i in range(1, 13))

def block(detail):
    return INNER.replace("{SUMS}", SUMS).replace("{DETAIL_EXPR}", detail)

sql = f"""
SELECT {", ".join(f"N.T{i:02d} - F.T{i:02d} AS DIFF_MM{i:02d}" for i in range(1,13))},
       N.CNT AS CNT_NOW, F.CNT AS CNT_FIX
  FROM (SELECT {TOT}, COUNT(*) CNT FROM ({block("C.ATTRIBUTE1")})) N
 CROSS JOIN (SELECT {TOT}, COUNT(*) CNT FROM ({block("NVL(C.ATTRIBUTE1,'-')")})) F
"""
cur.execute(sql, {"d": DIV, "v": VER})
cols = [c[0] for c in cur.description]
row = cur.fetchone()
print("[Oracle NUMBER 정밀 차감 — 0 이어야 통과]")
allzero = True
for c, v in zip(cols, row):
    if c.startswith("DIFF_"):
        z = (v == 0)
        allzero &= z
        print(f"    {c:<12} = {v}   {'OK' if z else '⛔'}")
    else:
        print(f"    {c:<12} = {v:,}")
print("\n" + "#" * 92)
print(f"  금액 총합 불변 : {'✅ PASS (12개월 전부 차이 0)' if allzero else '⛔ FAIL'}")
print("#" * 92)

con.rollback()
cur.execute("DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C")
con.rollback()
print("\n[정리] ROLLBACK 완료")
con.close()
