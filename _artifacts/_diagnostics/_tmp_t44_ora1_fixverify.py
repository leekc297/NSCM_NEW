#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ORA-00001 수정안 사전 검증 — 적용 전에 "중복 0 + 금액 총합 불변" 을 증명한다.

수정안: 안쪽 인라인뷰에서 `C.ATTRIBUTE1 AS PRODUCT_DETAIL`
        → `NVL(C.ATTRIBUTE1,'-') AS PRODUCT_DETAIL`
   ⇒ GROUP BY 가 NULL 그룹과 '-' 그룹을 **하나로 합치고 QTY 를 합산**한다.
     (지금은 두 그룹으로 갈라진 뒤 바깥 NVL 에서 같은 PK 가 되어 ORA-00001)

근거:
  · AS-IS(MSSQL) 원문 L150220 `C.ATTRIBUTE1 AS PRODUCT_DETAIL` — ISNULL 없음.
    MSSQL 에선 '' 가 NULL 이 아닌 실제 값이라 ''그룹 과 '-'그룹 이 **서로 다른 PK** 였다.
    Oracle 이관으로 '' → NULL 이 되면서 NOT NULL PK 를 만족시키려 '-' 로 감쌌고,
    그 순간 기존 '-' 데이터와 **한 값으로 합쳐져** 충돌하게 됐다.
  · 프로젝트 표준(hook #119 §1.5): 센티널 변형(' '/'-'/'--')은 '-' 로 통일, 초기값 NVL(x,'-').

검증 항목:
  (1) PK 중복 0
  (2) 행수 821 → 702 (=821-119)
  (3) **MM01~MM12 총합 불변** (그룹 병합이므로 합계는 보존돼야 한다)
"""
import sys, pathlib, time
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
print(f"[준비] GTT {cur.rowcount:,} 행\n")

TPL = """
SELECT A.YYYY, NVL(A.DEPARTMENT_NAME,'-'), NVL(A.DEPT_NAME,'-'), NVL(A.CUST_INFO,'-'),
       NVL(A.PRODUCT_NAME,'-'), NVL(A.PRODUCT_DETAIL,'-'), A.MEASURE,
       A.MM01,A.MM02,A.MM03,A.MM04,A.MM05,A.MM06,A.MM07,A.MM08,A.MM09,A.MM10,A.MM11,A.MM12
  FROM (
    SELECT A.YYYY, A.DEPARTMENT_NAME, A.DEPT_NAME, A.CUST_REPORT AS CUST_INFO,
           A.PRODUCT_NAME, A.PRODUCT_DETAIL, A.MEASURE, B.DISPLAY_SEQ,
           SUM(CASE WHEN A.YYYYMM=A.YYYY||'01' THEN A.QTY ELSE 0 END) MM01,
           SUM(CASE WHEN A.YYYYMM=A.YYYY||'02' THEN A.QTY ELSE 0 END) MM02,
           SUM(CASE WHEN A.YYYYMM=A.YYYY||'03' THEN A.QTY ELSE 0 END) MM03,
           SUM(CASE WHEN A.YYYYMM=A.YYYY||'04' THEN A.QTY ELSE 0 END) MM04,
           SUM(CASE WHEN A.YYYYMM=A.YYYY||'05' THEN A.QTY ELSE 0 END) MM05,
           SUM(CASE WHEN A.YYYYMM=A.YYYY||'06' THEN A.QTY ELSE 0 END) MM06,
           SUM(CASE WHEN A.YYYYMM=A.YYYY||'07' THEN A.QTY ELSE 0 END) MM07,
           SUM(CASE WHEN A.YYYYMM=A.YYYY||'08' THEN A.QTY ELSE 0 END) MM08,
           SUM(CASE WHEN A.YYYYMM=A.YYYY||'09' THEN A.QTY ELSE 0 END) MM09,
           SUM(CASE WHEN A.YYYYMM=A.YYYY||'10' THEN A.QTY ELSE 0 END) MM10,
           SUM(CASE WHEN A.YYYYMM=A.YYYY||'11' THEN A.QTY ELSE 0 END) MM11,
           SUM(CASE WHEN A.YYYYMM=A.YYYY||'12' THEN A.QTY ELSE 0 END) MM12
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
              A.PRODUCT_DETAIL, B.DISPLAY_SEQ, A.MEASURE ) A
"""

def run(label, detail_expr):
    sql = TPL.replace("{DETAIL_EXPR}", detail_expr)
    t0 = time.time()
    cur.execute(sql, {"d": DIV, "v": VER})
    rows = cur.fetchall()
    g = defaultdict(int)
    for r in rows:
        g[tuple(r[:7])] += 1
    dups = {k: v for k, v in g.items() if v > 1}
    tot = [sum(float(r[7 + i]) for r in rows) for i in range(12)]
    print(f"  {label:<34} {len(rows):>6,}행 / PK중복키 {len(dups):>4} / 초과행 {sum(v-1 for v in dups.values()):>4}"
          f"  ({time.time()-t0:.1f}초)")
    return rows, dups, tot

print("[검증] 현행 vs 수정안")
r_now, d_now, t_now = run("현행  C.ATTRIBUTE1", "C.ATTRIBUTE1")
r_fix, d_fix, t_fix = run("수정안 NVL(C.ATTRIBUTE1,'-')", "NVL(C.ATTRIBUTE1,'-')")

print("\n[불변식] MM01~MM12 총합 (그룹 병합이므로 반드시 같아야 함)")
ok = True
for i in range(12):
    same = abs(t_now[i] - t_fix[i]) < 1e-6
    ok &= same
    print(f"    MM{i+1:02d}  현행 {t_now[i]:>24,.3f}   수정안 {t_fix[i]:>24,.3f}   {'OK' if same else '⛔ 불일치'}")

print("\n" + "#" * 100)
print(f"  PK 중복      : {len(d_now)} → {len(d_fix)}   {'✅' if not d_fix else '⛔'}")
print(f"  행수         : {len(r_now):,} → {len(r_fix):,} (차 {len(r_now)-len(r_fix)})")
print(f"  금액 총합불변 : {'✅ PASS' if ok else '⛔ FAIL'}")
print("#" * 100)

con.rollback()
cur.execute("DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C")
con.rollback()
print("\n[정리] ROLLBACK 완료")
con.close()
