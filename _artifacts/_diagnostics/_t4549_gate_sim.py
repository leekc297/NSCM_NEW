#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""No.45/49 — SAVE SP §10 "Sales Price 52주 구간 확인" 판정식 그대로 재현(읽기 전용).

GT_PRDM1_T_MAIN 을 인라인 1행으로 세우고, SP 본문(L11602~11688)의 조건을 1:1 복제해
 "이 신규행이 52주 판가 게이트에 걸리는가" 를 실측한다. 원장 변경 없음.
"""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

GATE = """
WITH T_MAIN AS (
  SELECT :div DIVISION_ID, :proj PROJECT_CODE, :cust END_CUSTOMER, :site SCM_SITE_ID,
         :item ITEM_ID, :dom DOM_EXP, :fcst FCST_TYPE, :inco INCOTERMS,
         :meas MEASURE, :plant PLANT_SITE_ID, :cell CELL_PROD_SITE_ID, 777 QTY_PRICE
  FROM DUAL
),
WK AS (
  SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M M
  WHERE M.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')
  AND   M.BASIS_YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7+52*7,'YYYYMMDD')
  GROUP BY BASIS_START_DATE
),
PRICE AS (   /* SP 1.2 = 원장 판가(LOC, PRICE<>0) 52주 수집. UI 입력분은 이 시뮬에서 제외 */
  SELECT B.YYYYMMDD, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.DIVISION_ID, B.PROJECT_CODE,
         B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS
  FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE B
  WHERE B.MEASURE='LOC' AND B.PRICE<>0
  AND   B.YYYYMMDD BETWEEN (SELECT MIN(BASIS_START_DATE) FROM WK) AND (SELECT MAX(BASIS_START_DATE) FROM WK)
)
SELECT COUNT(*) AS VIOLATION_WEEKS
FROM   T_MAIN A
INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM Z
        ON A.DIVISION_ID=Z.DIVISION_ID AND A.PROJECT_CODE=Z.PROJECT_CODE
       AND A.SCM_SITE_ID=Z.SCM_SITE_ID AND A.ITEM_ID=Z.ITEM_ID AND Z.VALID_YN='Y'
       AND (Z.SALES_PLAN_ADJUST_YN='Y' OR Z.SALES_PLAN_ADJUST_YN IS NULL)
LEFT JOIN WK M ON 1=1
LEFT JOIN PRICE P
       ON A.DIVISION_ID=P.DIVISION_ID AND A.PROJECT_CODE=P.PROJECT_CODE
      AND A.END_CUSTOMER=P.END_CUSTOMER AND A.SCM_SITE_ID=P.SCM_SITE_ID
      AND CASE WHEN TRIM(A.PLANT_SITE_ID) IS NULL OR A.PLANT_SITE_ID IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END
        = CASE WHEN TRIM(P.PLANT_SITE_ID) IS NULL OR P.PLANT_SITE_ID IN ('-','--') THEN '-' ELSE P.PLANT_SITE_ID END
      AND CASE WHEN TRIM(A.CELL_PROD_SITE_ID) IS NULL OR A.CELL_PROD_SITE_ID IN ('-','--') THEN '-' ELSE A.CELL_PROD_SITE_ID END
        = CASE WHEN TRIM(P.CELL_PROD_SITE_ID) IS NULL OR P.CELL_PROD_SITE_ID IN ('-','--') THEN '-' ELSE P.CELL_PROD_SITE_ID END
      AND A.ITEM_ID=P.ITEM_ID AND A.DOM_EXP=P.DOM_EXP AND A.FCST_TYPE=P.FCST_TYPE
      AND A.INCOTERMS=P.INCOTERMS AND P.YYYYMMDD=M.BASIS_START_DATE
WHERE  P.YYYYMMDD IS NULL
AND    A.MEASURE IN (SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                     WHERE LOOKUP_TYPE='MKT_FCST_VALIDATION_PRICE' AND SEGMENT1='MEASURE' AND VALID_YN='Y')
AND    A.QTY_PRICE <> 0
AND    A.FCST_TYPE NOT IN (SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                     WHERE LOOKUP_TYPE='MKT_FCST_VALIDATION_PRICE' AND SEGMENT1='FCST_TYPE' AND VALID_YN='Y')
"""

CASES = [
    ("No.45 원문 데이터셋 (MPS/Mass, 판가 미입력)",
     dict(div="40", proj="LX INTL SINGAPORE", cust="LX INTL SINGAPORE",
          site="LX INTL SINGAPORE_SG_SIN", item="MPCKRMVLTA16", dom="E",
          fcst="MPS", inco="CIF", meas="MKT_FCST", plant="-", cell="Common")),
    ("No.45 변형 — FCST_TYPE 을 명칭('Mass')으로 보낸 경우",
     dict(div="40", proj="LX INTL SINGAPORE", cust="LX INTL SINGAPORE",
          site="LX INTL SINGAPORE_SG_SIN", item="MPCKRMVLTA16", dom="E",
          fcst="Mass", inco="CIF", meas="MKT_FCST", plant="-", cell="Common")),
    ("No.49 원문 데이터셋 (SPF/Spare Parts(FREE) — 제외 대상)",
     dict(div="40", proj="NT", cust="NT", site="BYD Electronics_CN_SZX",
          item="MCSS22561-C1", dom="E", fcst="SPF", inco="DAP",
          meas="MKT_FCST", plant="-", cell="Common")),
    ("No.49 변형 — FCST_TYPE 을 명칭('Spare Parts(FREE)')으로 보낸 경우",
     dict(div="40", proj="NT", cust="NT", site="BYD Electronics_CN_SZX",
          item="MCSS22561-C1", dom="E", fcst="Spare Parts(FREE)", inco="DAP",
          meas="MKT_FCST", plant="-", cell="Common")),
]

for label, binds in CASES:
    cur.execute(GATE, binds)
    n = cur.fetchone()[0]
    verdict = "차단(판가 미입력 위반)" if n > 0 else "통과(게이트 미발동)"
    print(f"{label}\n   → 위반 주차 {n} 건 = {verdict}\n")

print("## SITE_ITEM INNER JOIN 성립 여부 (게이트 발동 전제)")
for label, b in CASES:
    cur.execute(
        """SELECT COUNT(*) FROM SCM_MGR.SCM_MST_SITE_ITEM
           WHERE DIVISION_ID=:div AND PROJECT_CODE=:proj AND SCM_SITE_ID=:site AND ITEM_ID=:item
           AND VALID_YN='Y' AND (SALES_PLAN_ADJUST_YN='Y' OR SALES_PLAN_ADJUST_YN IS NULL)""",
        {k: b[k] for k in ("div", "proj", "site", "item")},
    )
    print(f"   {label[:40]:<42} SITE_ITEM={cur.fetchone()[0]}행")

con.close()
