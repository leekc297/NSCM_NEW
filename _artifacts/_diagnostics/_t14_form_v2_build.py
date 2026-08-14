#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel Form SP **V2 재설계** 배포 (사용자 확정 B안, 2026-08-14).

⛔ V1 오류: 양식을 `DM_PLN_CUSTOMER_PSI`(이미 업로드된 원장)에서만 만들어, PSI 의 MEASURE 를 그대로 썼다
   → 화면 메인 그리드와 사실상 동일해졌다. 사용자 지적 "MAIN GRID 의 데이터와 항상 일치하지 않습니다".
⭐ V2(B안): **키 축은 PSI 유지 + measure 축은 DMF0007 기준(`DM_MST_CUSTOMER_FCST`)** 으로 교체·결합.
   ⇒ 실적이 아직 없는 measure 도 양식에 나온다(= 업로드해야 할 대상). 이것이 메인 그리드와의 차이.
   + 컬러링 원천 `UPLOAD_VALID_WEEKS`(DMF0007 VALID_YN='Y' 주차 일자 목록) 동봉.
"""
import io, pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0014_EXCELFORM_20260814")

NEW_SQL_BLOCK = """        V_SQL_TEXT := '
        SELECT K.DIVISION_ID
             , K.SCM_SITE_ID
             , K.PLANT_SITE_ID
             , K.CUSTOMER_PROJECT_CODE
             , K.CUSTOMER_MODEL
             , K.INCOTERMS
             , K.FCST_TYPE
             , K.DOM_EXP
             , M.MEASURE_GROUP
             , M.MEASURE
             , M.UPLOAD_UOM
             , K.PROJECT_CODE
             , K.ITEM_ID
             , W.UPLOAD_VALID_WEEKS
        FROM (
              /* [B안] 키 축 = 기존 업로드 키 조합 (Plant/CustProject/CustModel/Incoterms/FcstType/
                 DomExp/Project/Model 8종이 채워진 조합) */
              SELECT DISTINCT CP.DIVISION_ID, CP.SCM_SITE_ID, CP.PLANT_SITE_ID
                   , CP.CUSTOMER_PROJECT_CODE, CP.CUSTOMER_MODEL, CP.INCOTERMS
                   , CP.FCST_TYPE, CP.DOM_EXP, CP.PROJECT_CODE, CP.ITEM_ID
              FROM   DM_PLN_CUSTOMER_PSI CP
              INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(''' || P_USER_ID || ''', ''' || P_MENU_ID || ''')) TEI
              ON     TEI.UNIT_ID = CP.DIVISION_ID
              INNER  JOIN SCM_MST_SITE S
                  ON  CP.DIVISION_ID = S.DIVISION_ID
                  AND CP.SCM_SITE_ID = S.SCM_SITE_ID
              LEFT OUTER JOIN SCM_MST_SITE_ITEM ITM
                  ON  S.DIVISION_ID   = ITM.DIVISION_ID
                  AND S.SCM_SITE_ID   = ITM.SCM_SITE_ID
                  AND CP.PROJECT_CODE = ITM.PROJECT_CODE
                  AND CP.ITEM_ID      = ITM.ITEM_ID
              WHERE  1 = 1
              AND    CP.MEASURE_GROUP = ''CUST_FCST''
              p_division_id
              p_dept_id
              p_scm_site_id
              p_plant_site_id
              p_project_code
              p_item_id
              p_dom_exp
              p_end_customer
              AND    CP.YYYYMMDD BETWEEN ''p_start_yyyymmdd'' AND ''p_end_yyyymmdd''
             ) K
        /* ⭐ measure 축 = **DMF0007 기준데이터**(DM_MST_CUSTOMER_FCST) — 실적 유무와 무관하게
           업로드 대상 measure 를 전부 준다. 이 결합이 "메인 그리드와 항상 일치하지 않는" 이유다. */
        INNER JOIN (
              SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, MEASURE_GROUP, MEASURE, UPLOAD_UOM
              FROM   DM_MST_CUSTOMER_FCST
              WHERE  VALID_YN = ''Y''
              AND    UPLOAD_BUCKET_TYPE = ''p_bucket_type''
             ) M
            ON  K.DIVISION_ID = M.DIVISION_ID
            AND K.SCM_SITE_ID = M.SCM_SITE_ID
        /* ⭐ 컬러링 원천 — DMF0007 이 VALID_YN=''Y'' 로 표기한 **업로드 가능 주차 일자** 목록.
           FE 가 이 목록에 해당하는 값 칸만 색칠한다(사용자 요구 2026-08-14). */
        LEFT OUTER JOIN (
              SELECT DIVISION_ID, SCM_SITE_ID, MEASURE
                   , LISTAGG(SUMMARY_BUCKET_VALUE, '','')
                       WITHIN GROUP (ORDER BY SUMMARY_BUCKET_VALUE) AS UPLOAD_VALID_WEEKS
              FROM (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, MEASURE, SUMMARY_BUCKET_VALUE
                    FROM   DM_MST_CUSTOMER_FCST
                    WHERE  VALID_YN = ''Y''
                    AND    UPLOAD_BUCKET_TYPE = ''p_bucket_type''
                    AND    SUMMARY_BUCKET_VALUE BETWEEN ''p_start_yyyymmdd'' AND ''p_end_yyyymmdd'')
              GROUP BY DIVISION_ID, SCM_SITE_ID, MEASURE
             ) W
            ON  K.DIVISION_ID = W.DIVISION_ID
            AND K.SCM_SITE_ID = W.SCM_SITE_ID
            AND M.MEASURE     = W.MEASURE
        ORDER BY K.DIVISION_ID, K.SCM_SITE_ID, K.PLANT_SITE_ID
               , K.CUSTOMER_PROJECT_CODE, K.CUSTOMER_MODEL, M.MEASURE
       ';
"""

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
body = "".join(r[0] for r in cur.fetchall())

start = body.find("        V_SQL_TEXT := '\n        SELECT CP.DIVISION_ID")
if start < 0:
    sys.exit("⛔ V1 SQL 블록을 찾지 못함 — 이미 교체됐거나 본문이 변경됨")
end = body.find("       ';", start)
if end < 0:
    sys.exit("⛔ V1 SQL 블록 종료 위치를 찾지 못함")
end += len("       ';\n")

body_v2 = body[:start] + NEW_SQL_BLOCK + body[end:]
# p_bucket_type REPLACE 가 W 서브쿼리에도 적용되도록 기존 REPLACE 라인은 그대로 재사용된다.
assert "DM_MST_CUSTOMER_FCST" in body_v2

(OUT / "04_PKG_DMF0014_BODY_FORM_V2.sql").write_text(
    "SET DEFINE OFF\nCREATE OR REPLACE " + body_v2.rstrip() + "\n/\n", encoding="utf-8")

cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
cur.execute("CREATE OR REPLACE " + body_v2.rstrip())
print("[deploy] BODY V2 OK")
cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
               AND OBJECT_NAME='PKG_DMF0014' ORDER BY 1""")
for r in cur.fetchall():
    print(f"   {r[0]:<14} {r[1]}")
cur.execute("SELECT LINE, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' ORDER BY SEQUENCE")
errs = cur.fetchall()
print(f"[errors] {len(errs)}")
for e in errs[:8]:
    print("   ", e[0], str(e[1])[:120])
con.close()
