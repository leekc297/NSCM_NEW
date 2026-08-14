#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel Form **V4** — 기준축을 PSI → DMF0007 마스터로 전환 (사용자 지시 2026-08-14).

사용자 원문: "PSI 데이터는 없어도 됩니다. DMF0007 에서 관리하는 MASTER 데이터가 있으면
              이 데이터를 기준으로 PSI 데이터를 생성하면 됩니다.
              그리고 기간에 대한 데이터가 없으면 입력 불가로 표시하면 됩니다."

⛔ V2/V3 한계: 행의 존재 자체를 `DM_PLN_CUSTOMER_PSI`(이미 업로드된 원장)가 결정했다.
   → PSI 가 비어 있는 division/site 는 **최초 업로드용 양식을 아예 받을 수 없다**(div 40 = 0행).

⭐ V4 설계
   · 행 축(존재 판정) = `DM_MST_CUSTOMER_FCST`(DMF0007 마스터) VALID_YN='Y' + 조회 bucket
     — 기간 필터 없음. 마스터에 등록돼 있으면 양식이 나온다.
   · 상세 키(Plant/CustProject/CustModel/Incoterms/FcstType/DomExp/Project/Model)는
     PSI 에 **있으면 채워주고 없으면 빈칸**(LEFT JOIN) — "PSI 없어도 됨" 을 문자 그대로 구현.
     PSI 는 이제 **편의 정보**이지 존재 조건이 아니다.
   · `UPLOAD_VALID_WEEKS` = 조회구간 안에서 VALID_YN='Y' 인 주차 일자 목록.
     기간 필터를 **행 축이 아니라 이 집계에만** 걸어, 데이터가 없는 주차는 목록에서 빠진다
     → FE 가 그 칸을 **입력 불가(회색)** 로 표시한다.

⚠ 마스터에 없는 컬럼 기준의 조회조건(Plant Site / Project / Model / Customs Handbook)은
  행 축에 적용할 수 없다. 해당 필터는 PSI 상세 키 축에만 적용한다(있는 행만 좁힘).
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

        -- 권한그룹 (메인 GET 과 동일 규약 — GET_ADMIN_GROUP 룩업, 그룹명 하드코딩 금지)
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
        -- [E20260814-EXCELFORM-V4] 행 축 = DMF0007 마스터. PSI 는 상세 키를 채워주는 보조 축.
        --------------------------------------------------------------------------------------
        V_SQL_TEXT := '
        WITH M AS (
              /* ⭐ 행 축 = DMF0007 기준데이터. **기간 필터 없음** — 마스터에 등록돼 있으면
                 아직 실적이 한 건도 없어도 업로드 양식이 나와야 한다(최초 업로드가 주 용도). */
              SELECT MF.DIVISION_ID
                   , MF.SCM_SITE_ID
                   , MF.CUSTOMER_CODE
                   , MF.MEASURE_GROUP
                   , MF.MEASURE
                   , MAX(MF.UPLOAD_UOM) AS UPLOAD_UOM
                   /* ⭐ 조회구간 안에서 VALID_YN=''Y'' 인 주차 일자만 모은다. 여기서 빠진 주차를
                      FE 가 **입력 불가**로 표시한다(사용자 지시 2026-08-14). 행 존재와 무관하도록
                      기간 조건을 WHERE 가 아니라 CASE 로 건다 — WHERE 로 걸면 V2/V3 처럼 전건 0. */
                   , LISTAGG(DISTINCT CASE WHEN MF.SUMMARY_BUCKET_VALUE
                                                BETWEEN ''p_start_yyyymmdd'' AND ''p_end_yyyymmdd''
                                           THEN MF.SUMMARY_BUCKET_VALUE END, '','')
                       WITHIN GROUP (ORDER BY CASE WHEN MF.SUMMARY_BUCKET_VALUE
                                                        BETWEEN ''p_start_yyyymmdd'' AND ''p_end_yyyymmdd''
                                                   THEN MF.SUMMARY_BUCKET_VALUE END) AS UPLOAD_VALID_WEEKS
              FROM   DM_MST_CUSTOMER_FCST MF
              INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(''' || P_USER_ID || ''', ''' || P_MENU_ID || ''')) TEI
              ON     TEI.UNIT_ID = MF.DIVISION_ID
              INNER  JOIN SCM_MST_SITE S
                  ON  MF.DIVISION_ID = S.DIVISION_ID
                  AND MF.SCM_SITE_ID = S.SCM_SITE_ID
              WHERE  MF.VALID_YN = ''Y''
              AND    MF.UPLOAD_BUCKET_TYPE = ''p_bucket_type''
              p_division_id
              p_scm_site_id
              p_end_customer
              p_dept_exists
              GROUP BY MF.DIVISION_ID, MF.SCM_SITE_ID, MF.CUSTOMER_CODE
                     , MF.MEASURE_GROUP, MF.MEASURE
        ), K AS (
              /* 보조 축 = 기존 업로드 상세 키. **없어도 무방**(LEFT JOIN) — 있으면 채워 주어
                 사용자가 다시 타이핑하지 않게 한다. 기간 필터를 걸지 않는다(키는 기간 무관). */
              SELECT DISTINCT CP.DIVISION_ID, CP.SCM_SITE_ID, CP.MEASURE_GROUP
                   , CP.PLANT_SITE_ID, CP.CUSTOMER_PROJECT_CODE, CP.CUSTOMER_MODEL
                   , CP.INCOTERMS, CP.FCST_TYPE, CP.DOM_EXP, CP.PROJECT_CODE, CP.ITEM_ID
              FROM   DM_PLN_CUSTOMER_PSI CP
              WHERE  1 = 1
              p_plant_site_id
              p_project_code
              p_item_id
              p_dom_exp
        )
        SELECT M.DIVISION_ID
             , M.SCM_SITE_ID
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
             , M.CUSTOMER_CODE
             , M.UPLOAD_VALID_WEEKS
        FROM   M
        LEFT   OUTER JOIN K
            ON  M.DIVISION_ID   = K.DIVISION_ID
            AND M.SCM_SITE_ID   = K.SCM_SITE_ID
            AND M.MEASURE_GROUP = K.MEASURE_GROUP
        ORDER  BY M.DIVISION_ID, M.SCM_SITE_ID, M.CUSTOMER_CODE
                , M.MEASURE_GROUP, M.MEASURE
                , K.PLANT_SITE_ID, K.CUSTOMER_PROJECT_CODE, K.CUSTOMER_MODEL
       ';

        -- 행 축(마스터)에 실재하는 컬럼만 필터를 건다.
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_division_id',    FN_SCM_GET_WHERE_SQL('MF.DIVISION_ID', 'IN', P_DIVISION_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_scm_site_id',    FN_SCM_GET_WHERE_SQL('MF.SCM_SITE_ID', 'IN', P_SCM_SITE_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_end_customer',   FN_SCM_GET_WHERE_SQL('S.END_CUSTOMER', 'IN', P_END_CUSTOMER));

        -- 부서는 마스터에 없다 → SCM_MST_SITE_ITEM EXISTS 로 좁힌다. 단 조건이 비면 절을 아예 넣지
        -- 않는다(빈 EXISTS 는 "아이템이 없는 site" 를 통째로 탈락시켜 조용한 유실이 된다).
        V_DEPT_SQL := FN_SCM_GET_WHERE_SQL('ITM.DEPT_ID', 'IN', P_DEPT_ID);
        IF V_DEPT_SQL IS NULL OR LENGTH(TRIM(V_DEPT_SQL)) = 0 THEN
            V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_dept_exists', '');
        ELSE
            V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_dept_exists',
                  'AND EXISTS (SELECT 1 FROM SCM_MST_SITE_ITEM ITM'
               || ' WHERE ITM.DIVISION_ID = MF.DIVISION_ID AND ITM.SCM_SITE_ID = MF.SCM_SITE_ID '
               || V_DEPT_SQL || ')');
        END IF;

        -- 마스터에 없는 축(Plant/Project/Model/Customs Handbook)은 보조 키 축에만 적용한다.
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_plant_site_id',  FN_SCM_GET_WHERE_SQL('CP.PLANT_SITE_ID', 'IN', P_PLANT_SITE_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_project_code',   FN_SCM_GET_WHERE_SQL('CP.PROJECT_CODE',  'IN', P_PROJECT_CODE));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_item_id',        FN_SCM_GET_WHERE_SQL('CP.ITEM_ID',       'IN', P_ITEM_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_dom_exp',        FN_SCM_GET_WHERE_SQL('CP.DOM_EXP',       'IN', P_DOM_EXP));

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

s = body.rfind(HEAD)
e = body.rfind(TAIL)
if s < 0 or e < 0 or e <= s:
    sys.exit("⛔ FORM 프로시저 경계를 찾지 못함")
e += len(TAIL)
body_v4 = body[:s] + NEW_PROC + body[e:]
assert "DM_MST_CUSTOMER_FCST MF" in body_v4 and body_v4.count("END PKG_DMF0014") == 1

(OUT / "06_PKG_DMF0014_BODY_FORM_V4.sql").write_text(
    "SET DEFINE OFF\nCREATE OR REPLACE " + body_v4.rstrip() + "\n/\n", encoding="utf-8")

cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
cur.execute("CREATE OR REPLACE " + body_v4.rstrip())
print("[deploy] BODY V4 OK")
cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
               AND OBJECT_NAME='PKG_DMF0014' ORDER BY 1""")
for r in cur.fetchall():
    print(f"   {r[0]:<14} {r[1]}")
cur.execute("""SELECT LINE, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR'
               AND NAME='PKG_DMF0014' ORDER BY SEQUENCE""")
errs = cur.fetchall()
print(f"[errors] {len(errs)}")
for x in errs[:8]:
    print("   ", x[0], str(x[1])[:140])
con.close()
