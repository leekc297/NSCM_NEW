#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ORA-00001 분열 컬럼 특정 (2차) — 진단 SQL 도 튜닝 품질로 (상관 스칼라 → LEFT JOIN).

1차는 내가 진단 쿼리를 AS-IS 형태(상관 스칼라 서브쿼리 2개 × 77,326행 × 연도)로 짜서
900초 타임아웃. 룰(#129 / feedback_diagnostic_sql_also_needs_tuning) 위반이었다.
여기서는 배포본과 동일한 LEFT JOIN 형태를 쓴다(등가 이미 증명됨).
"""
import sys, pathlib
from collections import defaultdict
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info
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
    FROM SCM_MST_ITEM_SN WHERE DIVISION_ID = :d GROUP BY DIVISION_ID, ITEM_ID )
SELECT A.DIVISION_ID, A.PRODUCT_GROUP,
       CASE WHEN A.MEASURE='Business_Plan' THEN 'RTF' ELSE A.MEASURE END,
       A.YYYYMMDD, A.ATTRIBUTE1, A.ATTRIBUTE2, A.DEPARTMENT_ID, A.DEPT_ID,
       A.END_CUST_REPORT, A.CUST_REPORT,
       CASE WHEN A.MEASURE IN ('RTF','Business_Plan','RTF_SYS_RP') AND B.FORECAST_INFO_BIZ_TYPE='PACK'
                 AND B.FORECAST_INFO_CELL_PACK_COUNT<>0
            THEN A.QTY * NVL(B.FORECAST_INFO_CELL_PACK_COUNT,1) ELSE A.QTY END
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
            THEN A.QTY * NVL(B.FORECAST_INFO_CELL_PACK_COUNT,1) ELSE A.QTY END
  FROM DM_PLN_SALES_ETC_REPORT_C A LEFT OUTER JOIN ISV B
    ON A.DIVISION_ID=B.DIVISION_ID AND A.ITEM_ID=B.ITEM_ID
 WHERE A.DIVISION_ID=:d AND A.VERSION_NO=:v
   AND A.MEASURE IN ('Business_Plan','RTF','RTF_SYS_RP','SalesAmt_KRW')
""", {"d": DIV, "v": VER})
print(f"[준비] GTT {cur.rowcount:,} 행 (세션 전용)\n")

MID = """
SELECT A.YYYY, A.DEPARTMENT_NAME, A.DEPT_NAME, A.CUST_REPORT, A.PRODUCT_NAME,
       A.PRODUCT_DETAIL, B.DISPLAY_SEQ, A.MEASURE, SUM(A.QTY) qty
  FROM ( SELECT Y.YYYY AS YYYY, LD.SEGMENT2 AS DEPARTMENT_NAME, LT.SEGMENT2 AS DEPT_NAME
              , C.CUST_REPORT, C.PRODUCT_GROUP AS PRODUCT_NAME, C.ATTRIBUTE1 AS PRODUCT_DETAIL
              , C.MEASURE, C.QTY
           FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C C
           CROSS JOIN ( SELECT DISTINCT SUBSTR(YYYYMMDD,1,4) AS YYYY FROM DM_PLN_SALES_PLAN_REPORT_C
                         WHERE DIVISION_ID=:d AND VERSION_NO=:v ) Y
           LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LD
             ON LD.LOOKUP_TYPE='MDF_DEPARTMENT'           AND LD.SEGMENT1=C.DEPARTMENT_ID
           LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LT
             ON LT.LOOKUP_TYPE='DMF0044_DEPARTMENT_TEAM2' AND LT.SEGMENT1=C.DEPT_ID
          WHERE C.MEASURE IN ('Business_Plan','RTF','RTF_SYS_RP','SalesAmt_KRW')
            AND C.YYYYMMDD LIKE Y.YYYY || '%' ) A
  LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
    ON A.CUST_REPORT=B.SEGMENT1 AND B.LOOKUP_TYPE='REPORT_GROUP2'
 GROUP BY A.YYYY, A.DEPARTMENT_NAME, A.DEPT_NAME, A.CUST_REPORT, A.PRODUCT_NAME,
          A.PRODUCT_DETAIL, B.DISPLAY_SEQ, A.MEASURE
"""
import time
t0 = time.time()
cur.execute(MID, {"d": DIV, "v": VER})
rows = cur.fetchall()
print(f"[중간뷰] {len(rows):,} 그룹 ({time.time()-t0:.1f}초)\n")

nv = lambda x: '-' if x is None else x
pk = lambda r: (r[0], nv(r[1]), nv(r[2]), nv(r[3]), nv(r[4]), nv(r[5]), r[7])
groups = defaultdict(list)
for r in rows:
    groups[pk(r)].append(r)
dups = {k: v for k, v in groups.items() if len(v) > 1}
print(f"[결과] PK 중복키 {len(dups)} / 초과행 {sum(len(v)-1 for v in dups.values())}\n")

IDX = {1: "DEPARTMENT_NAME", 2: "DEPT_NAME", 3: "CUST_REPORT", 4: "PRODUCT_NAME", 5: "PRODUCT_DETAIL"}
CAUSE = {f"{n} NULL↔'-'": 0 for n in IDX.values()}
CAUSE["DISPLAY_SEQ 상이(NULL↔값 포함)"] = 0
CAUSE["원인 미분류"] = 0
for k, v in dups.items():
    hit = False
    if len({r[6] for r in v}) > 1:
        CAUSE["DISPLAY_SEQ 상이(NULL↔값 포함)"] += 1; hit = True
    for i, nm in IDX.items():
        raw = {r[i] for r in v}
        if len(raw) > 1:
            CAUSE[f"{nm} NULL↔'-'"] += 1; hit = True
    if not hit:
        CAUSE["원인 미분류"] += 1
print("[분열 원인 분류]  ※ 한 키가 복수 사유를 동시에 가질 수 있어 합계 > 119 가능")
for k, v in sorted(CAUSE.items(), key=lambda x: -x[1]):
    print(f"    {k:<34} {v:>5}")

print("\n[표본 5건 — 원시값]")
for i, (k, v) in enumerate(dups.items()):
    if i >= 5: break
    print(f"\n  PK(YYYY,DEPT_NM_UP,DEPT_NM,CUST,PROD,DETAIL,MEASURE)={k}")
    for r in v:
        print(f"     raw DEPARTMENT_NAME={r[1]!r} DEPT_NAME={r[2]!r} CUST={r[3]!r} "
              f"PROD={r[4]!r} DETAIL={r[5]!r} DISPLAY_SEQ={r[6]!r} QTY={r[8]}")

con.rollback()
cur.execute("DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C")
con.rollback()
print("\n[정리] ROLLBACK 완료")
con.close()
