#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel Form **V7** — 양식이 AS-IS 와 동일한 **실제 키 조합**을 만든다.

사용자 지시(2026-08-14): "실제 조합으로 전환해주세요. 실제 조합으로 만드는 것이 EXCEL FORM 의 역할입니다."

⛔ V6 한계: 보조축(PSI)에 없으면 키를 센티널 ''-'' 로 내렸다. AS-IS 실이력 190행에는 ''-'' 가
   **0건**이고, 업로드 검증이 키마다 마스터 실재를 요구하므로 ''-'' 양식은 업로드가 성립하지 않는다.

⭐ V7 = 업로드 검증 SP 가 지정한 **권위 마스터 그대로** 조합을 만든다 (실측 매핑):
     A2 Sales Site / A4 Customer Project / A5 Customer Model / A12 Project / A13 Model
        → `DM_MST_CUSTOMER_MODEL` (VALID_YN='Y') — 5키가 이 한 테이블에 있다
     A9 Measure Group / A10 Measure / A11 Upload UOM
        → `DM_MST_CUSTOMER_FCST` (VALID_YN='Y' + 조회 bucket)
     A3 Plant Site / A6 Incoterms / A7 FCST Type / A8 Customs Handbook
        → 고객모델과 **직교(free axis)** 라 마스터만으로는 조합이 정해지지 않는다.
          전량 교차하면 조합이 폭발하고 실제로 쓰이지도 않는 행이 된다.
          ⇒ **실제로 쓰인 조합**인 원장(`DM_PLN_CUSTOMER_PSI`)에서 가져온다:
             ① (div,site,고객프로젝트,고객모델) 정확 일치분
             ② 없으면 (div,site) 레벨 **최근 사용 조합** 1건 (KEEP DENSE_RANK LAST)
             ③ 그래도 없으면 ''-'' (사용자가 채움 — 임의 생성 금지)
          ②는 추정이 아니라 **그 site 에서 실제 사용된 값**이며, 셀은 편집 가능하다.
"""
import io, pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0014_EXCELFORM_20260814")
HEAD = "PROCEDURE P_DMF0014_GET_EXCEL_FORM_DATA"
TAIL = "END P_DMF0014_GET_EXCEL_FORM_DATA;"

NEW_PROC = r"""PROCEDURE P_DMF0014_GET_EXCEL_FORM_DATA
    (
        P_DIVISION_ID    VARCHAR2
       ,P_DEPT_ID        VARCHAR2
       ,P_END_CUSTOMER   VARCHAR2
       ,P_SCM_SITE_ID    VARCHAR2
       ,P_PLANT_SITE_ID  VARCHAR2
       ,P_PROJECT_CODE   VARCHAR2
       ,P_ITEM_ID        VARCHAR2
       ,P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_BUCKET_TYPE    VARCHAR2
       ,P_DOM_EXP        VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       ,P_USERINFO       VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    )
    AS
        V_PROGRAM_NAME VARCHAR2(200) := $$PLSQL_UNIT;
        V_SQL_TEXT     CLOB;
        V_GROUP_ID     VARCHAR2(50 CHAR) := NULL;
        V_CNT_1        INTEGER := 0;
        V_DEPT_SQL     VARCHAR2(4000 CHAR) := NULL;
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN
        V_PROC_INPUT := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID
                                   ,'p_dept_id' VALUE P_DEPT_ID
                                   ,'p_end_customer' VALUE P_END_CUSTOMER
                                   ,'p_scm_site_id' VALUE P_SCM_SITE_ID
                                   ,'p_plant_site_id' VALUE P_PLANT_SITE_ID
                                   ,'p_project_code' VALUE P_PROJECT_CODE
                                   ,'p_item_id' VALUE P_ITEM_ID
                                   ,'p_start_yyyymmdd' VALUE P_START_YYYYMMDD
                                   ,'p_end_yyyymmdd' VALUE P_END_YYYYMMDD
                                   ,'p_bucket_type' VALUE P_BUCKET_TYPE
                                   ,'p_dom_exp' VALUE P_DOM_EXP
                                   ,'p_created_by' VALUE P_CREATED_BY);

        SELECT COUNT(1)
        INTO   V_CNT_1
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
        AND    VALID_YN = 'Y'
        AND    SEGMENT2 = 'ALL'
        AND    SEGMENT1 = P_USERINFO;

        IF NVL(V_CNT_1, 0) > 0 THEN
            V_GROUP_ID := 'ADMIN';
        ELSE
            V_GROUP_ID := P_USERINFO;
        END IF;

        --------------------------------------------------------------------------------------
        -- [E20260814-EXCELFORM-V7] 실제 키 조합 생성 — 업로드 검증 SP 의 권위 마스터와 동일 원천.
        --------------------------------------------------------------------------------------
        V_SQL_TEXT := '
        SELECT Q.* FROM (
        SELECT CM.DIVISION_ID
             , CM.SCM_SITE_ID
             /* Plant/Incoterms/FCST Type/Customs Handbook = 고객모델과 직교축.
                원장에서 **실제 쓰인 조합**을 끌어온다(정확일치 → site 대표 → 센티널). */
             , NVL(NVL(A.PLANT_SITE_ID, B.PLANT_SITE_ID), ''-'') AS PLANT_SITE_ID
             , CM.CUSTOMER_PROJECT_CODE
             , CM.CUSTOMER_MODEL
             , NVL(NVL(A.INCOTERMS,     B.INCOTERMS),     ''-'') AS INCOTERMS
             , NVL(NVL(A.FCST_TYPE,     B.FCST_TYPE),     ''-'') AS FCST_TYPE
             , NVL(NVL(A.DOM_EXP,       B.DOM_EXP),       ''-'') AS DOM_EXP
             , M.MEASURE_GROUP
             , M.MEASURE
             , M.UPLOAD_UOM
             , NVL(CM.PROJECT_CODE, ''-'') AS PROJECT_CODE
             , NVL(CM.ITEM_ID,      ''-'') AS ITEM_ID
             , M.CUSTOMER_CODE
             , M.UPLOAD_VALID_WEEKS
             , (SELECT LISTAGG(BK.SBV, '','') WITHIN GROUP (ORDER BY BK.SBV)
                FROM  (SELECT DISTINCT MB.SUMMARY_BUCKET_VALUE AS SBV
                       FROM   DM_MST_CUSTOMER_FCST MB
                       WHERE  MB.UPLOAD_BUCKET_TYPE = ''p_bucket_type''
                       AND    MB.SUMMARY_BUCKET_VALUE
                                BETWEEN ''p_start_yyyymmdd'' AND ''p_end_yyyymmdd'') BK
               ) AS PERIOD_BUCKETS
        /* ⭐ 키 축 5종(Sales Site/Customer Project/Customer Model/Project/Model) = DM_MST_CUSTOMER_MODEL.
           업로드 검증의 Invalid Customer Project / Customer Model / Project / Model 이 모두 이 표를 본다. */
        FROM   DM_MST_CUSTOMER_MODEL CM
        INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(''' || P_USER_ID || ''', ''' || P_MENU_ID || ''')) TEI
        ON     TEI.UNIT_ID = CM.DIVISION_ID
        INNER  JOIN SCM_MST_SITE S
            ON  CM.DIVISION_ID = S.DIVISION_ID
            AND CM.SCM_SITE_ID = S.SCM_SITE_ID
            AND S.VALID_YN = ''Y''
        /* ⭐ measure 축 = DM_MST_CUSTOMER_FCST. 기간 필터는 행 존재가 아니라 주차 집계에만 건다. */
        INNER  JOIN (
              SELECT MF.DIVISION_ID, MF.SCM_SITE_ID, MF.CUSTOMER_CODE
                   , MF.MEASURE_GROUP, MF.MEASURE, MAX(MF.UPLOAD_UOM) AS UPLOAD_UOM
                   , LISTAGG(DISTINCT CASE WHEN MF.SUMMARY_BUCKET_VALUE
                                                BETWEEN ''p_start_yyyymmdd'' AND ''p_end_yyyymmdd''
                                           THEN MF.SUMMARY_BUCKET_VALUE END, '','')
                       WITHIN GROUP (ORDER BY CASE WHEN MF.SUMMARY_BUCKET_VALUE
                                                        BETWEEN ''p_start_yyyymmdd'' AND ''p_end_yyyymmdd''
                                                   THEN MF.SUMMARY_BUCKET_VALUE END) AS UPLOAD_VALID_WEEKS
              FROM   DM_MST_CUSTOMER_FCST MF
              WHERE  MF.VALID_YN = ''Y''
              AND    MF.UPLOAD_BUCKET_TYPE = ''p_bucket_type''
              GROUP BY MF.DIVISION_ID, MF.SCM_SITE_ID, MF.CUSTOMER_CODE
                     , MF.MEASURE_GROUP, MF.MEASURE
             ) M
            ON  CM.DIVISION_ID = M.DIVISION_ID
            AND CM.SCM_SITE_ID = M.SCM_SITE_ID
        /* ① 정확 일치 — 이 고객모델로 실제 업로드된 직교축 조합 */
        LEFT   OUTER JOIN (
              SELECT DIVISION_ID, SCM_SITE_ID, CUSTOMER_PROJECT_CODE, CUSTOMER_MODEL
                   , MAX(PLANT_SITE_ID) KEEP (DENSE_RANK LAST ORDER BY YYYYMMDD) AS PLANT_SITE_ID
                   , MAX(INCOTERMS)     KEEP (DENSE_RANK LAST ORDER BY YYYYMMDD) AS INCOTERMS
                   , MAX(FCST_TYPE)     KEEP (DENSE_RANK LAST ORDER BY YYYYMMDD) AS FCST_TYPE
                   , MAX(DOM_EXP)       KEEP (DENSE_RANK LAST ORDER BY YYYYMMDD) AS DOM_EXP
              FROM   DM_PLN_CUSTOMER_PSI
              WHERE  MEASURE_GROUP = ''CUST_FCST''
              GROUP BY DIVISION_ID, SCM_SITE_ID, CUSTOMER_PROJECT_CODE, CUSTOMER_MODEL
             ) A
            ON  CM.DIVISION_ID           = A.DIVISION_ID
            AND CM.SCM_SITE_ID           = A.SCM_SITE_ID
            AND CM.CUSTOMER_PROJECT_CODE = A.CUSTOMER_PROJECT_CODE
            AND CM.CUSTOMER_MODEL        = A.CUSTOMER_MODEL
        /* ② site 대표 — 그 site 에서 가장 최근 실제 사용된 조합(임의 생성 아님) */
        LEFT   OUTER JOIN (
              SELECT DIVISION_ID, SCM_SITE_ID
                   , MAX(PLANT_SITE_ID) KEEP (DENSE_RANK LAST ORDER BY YYYYMMDD) AS PLANT_SITE_ID
                   , MAX(INCOTERMS)     KEEP (DENSE_RANK LAST ORDER BY YYYYMMDD) AS INCOTERMS
                   , MAX(FCST_TYPE)     KEEP (DENSE_RANK LAST ORDER BY YYYYMMDD) AS FCST_TYPE
                   , MAX(DOM_EXP)       KEEP (DENSE_RANK LAST ORDER BY YYYYMMDD) AS DOM_EXP
              FROM   DM_PLN_CUSTOMER_PSI
              WHERE  MEASURE_GROUP = ''CUST_FCST''
              GROUP BY DIVISION_ID, SCM_SITE_ID
             ) B
            ON  CM.DIVISION_ID = B.DIVISION_ID
            AND CM.SCM_SITE_ID = B.SCM_SITE_ID
        WHERE  CM.VALID_YN = ''Y''
        p_division_id
        p_scm_site_id
        p_end_customer
        p_project_code
        p_item_id
        p_dept_exists
        ) Q
        WHERE  1 = 1
        p_plant_site_id
        p_dom_exp
        ORDER  BY Q.DIVISION_ID, Q.SCM_SITE_ID, Q.CUSTOMER_PROJECT_CODE, Q.CUSTOMER_MODEL
                , Q.MEASURE_GROUP, Q.MEASURE
       ';

        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_division_id',   FN_SCM_GET_WHERE_SQL('CM.DIVISION_ID',  'IN', P_DIVISION_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_scm_site_id',   FN_SCM_GET_WHERE_SQL('CM.SCM_SITE_ID',  'IN', P_SCM_SITE_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_end_customer',  FN_SCM_GET_WHERE_SQL('S.END_CUSTOMER',  'IN', P_END_CUSTOMER));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_project_code',  FN_SCM_GET_WHERE_SQL('CM.PROJECT_CODE', 'IN', P_PROJECT_CODE));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_item_id',       FN_SCM_GET_WHERE_SQL('CM.ITEM_ID',      'IN', P_ITEM_ID));
        -- 직교축 필터는 조합이 확정된 뒤(외부 Q)에 건다.
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_plant_site_id', FN_SCM_GET_WHERE_SQL('Q.PLANT_SITE_ID', 'IN', P_PLANT_SITE_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_dom_exp',       FN_SCM_GET_WHERE_SQL('Q.DOM_EXP',       'IN', P_DOM_EXP));

        -- 부서는 고객모델 마스터에 없다 → SITE_ITEM EXISTS. 조건이 비면 절을 넣지 않는다
        -- (빈 EXISTS 는 아이템 없는 site 를 통째로 탈락시켜 조용한 유실이 된다).
        V_DEPT_SQL := FN_SCM_GET_WHERE_SQL('ITM.DEPT_ID', 'IN', P_DEPT_ID);
        IF V_DEPT_SQL IS NULL OR LENGTH(TRIM(V_DEPT_SQL)) = 0 THEN
            V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_dept_exists', '');
        ELSE
            V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_dept_exists',
                  'AND EXISTS (SELECT 1 FROM SCM_MST_SITE_ITEM ITM'
               || ' WHERE ITM.DIVISION_ID = CM.DIVISION_ID AND ITM.SCM_SITE_ID = CM.SCM_SITE_ID '
               || V_DEPT_SQL || ')');
        END IF;

        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_start_yyyymmdd', P_START_YYYYMMDD);
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_end_yyyymmdd',   P_END_YYYYMMDD);
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_bucket_type',    P_BUCKET_TYPE);

        OPEN O_RC1 FOR V_SQL_TEXT;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, '0' AS EVENT FROM DUAL;

        BEGIN DBMS_LOB.FREETEMPORARY(V_SQL_TEXT); EXCEPTION WHEN OTHERS THEN NULL; END;

    EXCEPTION
        WHEN OTHERS THEN
            BEGIN DBMS_LOB.FREETEMPORARY(V_SQL_TEXT); EXCEPTION WHEN OTHERS THEN NULL; END;
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SUBSTR(SQLERRM, 1, 4000);
            V_BACKTRACE  := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
            BEGIN
                SCM_MGR.PR_DM_SYS_LOG_BATCH(
                    V_PROGRAM_NAME, 'ERROR', N_LOG_COUNT
                  , '########## FAIL END of procedure ##########', V_DESCRIPTION
                  , SYSDATE, P_CREATED_BY, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE);
            EXCEPTION WHEN OTHERS THEN NULL; END;
            RAISE_APPLICATION_ERROR(-20001, '[' || V_PROGRAM_NAME || '] ' || V_SQL_ERRMSG || CHR(10) || V_BACKTRACE);
    END P_DMF0014_GET_EXCEL_FORM_DATA;"""

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
body = "".join(r[0] for r in cur.fetchall())
s = body.rfind(HEAD); e = body.rfind(TAIL)
if s < 0 or e <= s:
    sys.exit("⛔ FORM 프로시저 경계 실패")
e += len(TAIL)
body7 = body[:s] + NEW_PROC + body[e:]
assert body7.count("END PKG_DMF0014") == 1

(OUT / "10_PKG_DMF0014_BODY_FORM_V7_REALCOMBO.sql").write_text(
    "SET DEFINE OFF\nCREATE OR REPLACE " + body7.rstrip() + "\n/\n", encoding="utf-8")
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
cur.execute("CREATE OR REPLACE " + body7.rstrip())
cur.execute("""SELECT LINE, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR'
               AND NAME='PKG_DMF0014' ORDER BY SEQUENCE""")
errs = cur.fetchall()
print(f"[deploy] V7 errors={len(errs)}")
for x in errs[:6]:
    print("   ", x[0], str(x[1])[:140])
con.close()
