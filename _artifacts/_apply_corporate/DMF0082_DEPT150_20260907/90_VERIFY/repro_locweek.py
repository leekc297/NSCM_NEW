# -*- coding: utf-8 -*-
"""DMF0082 LOC 52주 일괄 저장 오류 재현 (hook #149 §1 — 재현 먼저).

신고: div40 / Sales Site ABS_US_LRP / Model MCCM348018A3 로 52주 LOC 일괄 변경 시
      'MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 미래구간 52주이내에 존재하므로
       Sales Price 삭제가 불가합니다.'

재현 방법: PKG_DMF0082 L13169 MERGE(ACTION 판정) 를 원문 그대로 GTT 에 적용하고
          ACTION='D' 로 뒤집히는 행이 나오는지 본다. GTT 는 세션 스코프라 원장 영향 없음.
FE 입력 모사: 각 주 월요일 = 단가, 화~일 = 0 (L13158 주석의 실측 패턴).
"""
import pathlib

import oracledb

ROOT = pathlib.Path(r"C:\Projects\NSCM")
env = {}
for ln in open(ROOT / ".env.asis", encoding="utf-8"):
    ln = ln.strip()
    if "=" in ln and not ln.startswith("#"):
        k, v = ln.split("=", 1)
        env[k] = v
cn = oracledb.connect(user=env["TOBE_DB_USER"], password=env["TOBE_DB_PASS"],
                      dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cur = cn.cursor()

DIV, SITE, ITEM, PRICE = "40", "ABS_US_LRP", "MCCM348018A3", 5301

cur.execute("DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN")

# 52주 구간의 모든 '일' 을 달력에서 가져와 월요일만 단가, 나머지는 0 으로 적재
cur.execute("""
INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
  (ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,
   INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY)
SELECT 'M', :div, 'ABS', '-', :site, :item, 'E', 'MPS', 'FCA',
       'LOC', '-', 'HQ06-A', C.BASIS_YYYYMMDD, 'USD',
       CASE WHEN TO_CHAR(TO_DATE(C.BASIS_YYYYMMDD,'YYYYMMDD'),'D','NLS_DATE_LANGUAGE=AMERICAN') = '2'
            THEN :price ELSE 0 END,
       'repro'
  FROM SCM_MGR.SCM_SYS_CALENDAR_M C
 WHERE C.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')
   AND C.BASIS_YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7+52*7,'YYYYMMDD')
""", div=DIV, site=SITE, item=ITEM, price=PRICE)
print(f"적재 {cur.rowcount} 행 (52주 x 7일)")

cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_PRDM1_T_MAIN WHERE QTY_PRICE <> 0")
print(f"  단가 입력행(월요일) = {cur.fetchone()[0]}")

# --- PKG_DMF0082 L13169 MERGE 원문 (ACTION 판정) ---
cur.execute("""
MERGE INTO SCM_MGR.GT_PRDM1_T_MAIN A
USING (
    SELECT BASIS_YYYYMMDD, MAX(ACT) AS ACT
    FROM (
        SELECT D.BASIS_YYYYMMDD
             , CASE WHEN SUM(B.QTY_PRICE) OVER (PARTITION BY D.ISO_YYYYWW || D.PARTIAL_WEEK_NAME) = 0
                    THEN 'D' ELSE 'M' END AS ACT
        FROM SCM_MGR.GT_PRDM1_T_MAIN B
        JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON B.YYYYMMDD = D.BASIS_YYYYMMDD
        WHERE B.MEASURE = 'LOC' AND B.ACTION <> 'I'
    )
    GROUP BY BASIS_YYYYMMDD
) S
ON (A.YYYYMMDD = S.BASIS_YYYYMMDD AND A.MEASURE = 'LOC')
WHEN MATCHED THEN UPDATE SET A.ACTION = S.ACT WHERE A.ACTION <> 'I'
""")

cur.execute("SELECT ACTION, COUNT(*) FROM SCM_MGR.GT_PRDM1_T_MAIN GROUP BY ACTION ORDER BY 1")
print("\nMERGE 후 ACTION 분포:")
for a, c in cur:
    print(f"  {a} = {c}")

cur.execute("""
SELECT C.ISO_YYYYWW, C.PARTIAL_WEEK_NAME, MIN(T.YYYYMMDD) FROM_D, MAX(T.YYYYMMDD) TO_D, COUNT(*) DAYS
  FROM SCM_MGR.GT_PRDM1_T_MAIN T
  JOIN SCM_MGR.SCM_SYS_CALENDAR_M C ON T.YYYYMMDD = C.BASIS_YYYYMMDD
 WHERE T.ACTION = 'D'
 GROUP BY C.ISO_YYYYWW, C.PARTIAL_WEEK_NAME ORDER BY 1,2
""")
rows = cur.fetchall()
print(f"\nACTION='D' 로 뒤집힌 부분주 {len(rows)} 개:")
for r in rows:
    print(f"  {r[0]} {r[1]}  {r[2]}~{r[3]} ({r[4]}일)")

# --- 가드 발동 여부 (L13202 n_Dflag_chk) ---
cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_PRDM1_T_MAIN WHERE MEASURE='LOC' AND ACTION='D'")
n = cur.fetchone()[0]
print(f"\nL13202 n_Dflag_chk = {n}  ->  가드 {'발동(오류 재현)' if n else '미발동'}")

# --- L13261 52주이내 검사 재현 (실제 메시지 문자열) ---
cur.execute("""
SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID
  FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F
 WHERE EXISTS (
     SELECT A.DIVISION_ID FROM SCM_MGR.GT_PRDM1_T_MAIN A
      WHERE A.ACTION='D' AND F.DIVISION_ID=A.DIVISION_ID AND F.PROJECT_CODE=A.PROJECT_CODE
        AND F.SCM_SITE_ID=A.SCM_SITE_ID AND F.PLANT_SITE_ID=A.PLANT_SITE_ID AND F.ITEM_ID=A.ITEM_ID
        AND F.DOM_EXP=A.DOM_EXP AND F.FCST_TYPE=A.FCST_TYPE AND F.INCOTERMS=A.INCOTERMS
        AND F.MEASURE IN ('MKT_FCST','RTF_SCP','AS_In_Req','SCM_FCST')
        AND F.CELL_PROD_SITE_ID=A.CELL_PROD_SITE_ID
        AND F.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD')
        AND F.YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE,'MON')-7+52*7,'YYYYMMDD')
        AND F.QTY <> 0
        AND F.FCST_TYPE NOT IN (SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                                 WHERE MST.LOOKUP_TYPE='SALES_TYPE_CODE' AND MST.SEGMENT4='FREE'
                                 GROUP BY SEGMENT1))
 FETCH FIRST 1 ROWS ONLY
""")
hit = cur.fetchall()
print(f"L13261 검사 결과 = {hit if hit else '(키 불일치로 미검출 — 실제 키 조합 필요)'}")

cn.rollback()
cn.close()
