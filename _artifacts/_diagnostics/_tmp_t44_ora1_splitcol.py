#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ORA-00001 — PK 를 겹치게 만드는 **분열 컬럼**을 특정한다.

중간 인라인뷰의 GROUP BY 키 = (DIVISION_ID, VERSION_NO, YYYY, SP_BP_TYPE,
    DEPARTMENT_NAME, DEPT_NAME, CUST_REPORT, PRODUCT_NAME, PRODUCT_DETAIL,
    DISPLAY_SEQ, MEASURE)
PK 는 여기서 **DISPLAY_SEQ 가 빠지고**, 나머지 5개 문자열 컬럼은 바깥에서
`NVL(x,'-')` 로 감싸진다 ⇒ NULL 과 리터럴 '-' 가 **같은 PK 로 합쳐진다**.

어느 쪽이 원인인지 실측으로 가른다.
"""
import sys, pathlib
from collections import Counter, defaultdict
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

DIV, VER = '40', 'R_S_20260810_V009_C'

u, p, dsn = conn_info()
con = oracledb.connect(user=u, password=p, dsn=dsn)
con.call_timeout = 900000
cur = con.cursor()

# GTT 적재 (라이브 문장과 동일 결과 — 앞 단계에서 OLD=NEW 확인됨)
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
       CASE WHEN A.MEASURE='Business_Plan' THEN 'RTF'
            WHEN A.MEASURE='RTF_SYS_RP' THEN 'RTF_SYS_RP' ELSE A.MEASURE END,
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

# 중간 인라인뷰를 **원시값 그대로** 산출 (NVL 적용 전)
MID = """
SELECT A.YYYY, A.DEPARTMENT_NAME, A.DEPT_NAME, A.CUST_REPORT, A.PRODUCT_NAME,
       A.PRODUCT_DETAIL, B.DISPLAY_SEQ, A.MEASURE, SUM(A.QTY) qty
  FROM ( SELECT Y.YYYY AS YYYY
              , (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                  WHERE LOOKUP_TYPE='MDF_DEPARTMENT' AND C.DEPARTMENT_ID=SEGMENT1 AND ROWNUM=1) AS DEPARTMENT_NAME
              , (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                  WHERE LOOKUP_TYPE='DMF0044_DEPARTMENT_TEAM2' AND C.DEPT_ID=SEGMENT1 AND ROWNUM=1) AS DEPT_NAME
              , C.CUST_REPORT, C.PRODUCT_GROUP AS PRODUCT_NAME, C.ATTRIBUTE1 AS PRODUCT_DETAIL
              , C.MEASURE, C.QTY
           FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C C
           CROSS JOIN ( SELECT DISTINCT SUBSTR(YYYYMMDD,1,4) AS YYYY FROM DM_PLN_SALES_PLAN_REPORT_C
                         WHERE DIVISION_ID=:d AND VERSION_NO=:v ) Y
          WHERE C.MEASURE IN ('Business_Plan','RTF','RTF_SYS_RP','SalesAmt_KRW')
            AND C.YYYYMMDD LIKE Y.YYYY || '%' ) A
  LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
    ON A.CUST_REPORT=B.SEGMENT1 AND B.LOOKUP_TYPE='REPORT_GROUP2'
 GROUP BY A.YYYY, A.DEPARTMENT_NAME, A.DEPT_NAME, A.CUST_REPORT, A.PRODUCT_NAME,
          A.PRODUCT_DETAIL, B.DISPLAY_SEQ, A.MEASURE
"""
cur.execute(MID, {"d": DIV, "v": VER})
rows = cur.fetchall()
print(f"[중간뷰] {len(rows):,} 그룹\n")

# PK 키 = NVL 적용 후 (YYYY, DEPARTMENT_NAME, DEPT_NAME, CUST_REPORT, PRODUCT_NAME, PRODUCT_DETAIL, MEASURE)
nv = lambda x: '-' if x is None else x
pk = lambda r: (r[0], nv(r[1]), nv(r[2]), nv(r[3]), nv(r[4]), nv(r[5]), r[7])
groups = defaultdict(list)
for r in rows:
    groups[pk(r)].append(r)
dups = {k: v for k, v in groups.items() if len(v) > 1}
print(f"[결과] PK 중복키 {len(dups)} / 초과행 {sum(len(v)-1 for v in dups.values())}\n")

# 분열 원인 분류
CAUSE = {"DISPLAY_SEQ 상이": 0, "DEPARTMENT_NAME NULL↔'-'": 0, "DEPT_NAME NULL↔'-'": 0,
         "CUST_REPORT NULL↔'-'": 0, "PRODUCT_NAME NULL↔'-'": 0, "PRODUCT_DETAIL NULL↔'-'": 0,
         "기타": 0}
IDX = {1: "DEPARTMENT_NAME", 2: "DEPT_NAME", 3: "CUST_REPORT", 4: "PRODUCT_NAME", 5: "PRODUCT_DETAIL"}
for k, v in dups.items():
    hit = False
    if len({r[6] for r in v}) > 1:
        CAUSE["DISPLAY_SEQ 상이"] += 1; hit = True
    for i, nm in IDX.items():
        raw = {r[i] for r in v}
        if len(raw) > 1 and (None in raw) and ('-' in raw):
            CAUSE[f"{nm} NULL↔'-'"] += 1; hit = True
    if not hit:
        CAUSE["기타"] += 1
print("[분열 원인 분류] (중복 계상 가능 — 한 키가 여러 사유를 동시에 가질 수 있음)")
for k, v in CAUSE.items():
    print(f"    {k:<28} {v:>5}")

print("\n[표본 3건 — 원시값]")
for i, (k, v) in enumerate(dups.items()):
    if i >= 3: break
    print(f"\n  PK={k}")
    for r in v:
        print(f"     DEPT_NM={r[2]!r} CUST={r[3]!r} PROD={r[4]!r} DETAIL={r[5]!r} DISPLAY_SEQ={r[6]!r} QTY={r[8]}")

con.rollback()
cur.execute("DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C")
con.rollback()
print("\n[정리] ROLLBACK 완료")
con.close()
