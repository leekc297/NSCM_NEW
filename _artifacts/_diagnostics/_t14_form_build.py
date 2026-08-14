#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel Form SP 신설 — SPEC/BODY 에 P_DMF0014_GET_EXCEL_FORM_DATA 삽입본 생성.

정본 계약(hook #135 §1): Form SP IN = **메인 조회 SP 와 동일 축·동일 이름**(15) / OUT = O_RC1 + O_RESULT_CURSOR.
본 SP 는 메인 GET(P_DMF0014_GET_CUST_FCST_UPLOAD_DATA)의 FROM/WHERE 를 그대로 쓰고
**동적 기간 컬럼(v_iteration)만 뺀** 키 조합 목록을 돌려준다 — 값 컬럼(W27~W31)은 FE 가 빈칸으로 채운다.
"""
import io, pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0014_EXCELFORM_20260814")
OUT.mkdir(parents=True, exist_ok=True)

PROC_SPEC = """
    -- [E20260814-EXCELFORM] DMF0014 Excel Form 조회 SP (hook #135 표준 — DMF0082 정본 1:1)
    PROCEDURE P_DMF0014_GET_EXCEL_FORM_DATA
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
    );
"""

PROC_BODY = """
    ------------------------------------------------------------------------------------------------
    -- [E20260814-EXCELFORM] DMF0014 Excel Form 조회 (hook #135 — Excel Form/Upload 표준)
    --   요구: "EXCEL UPLOAD 기능이 있는 경우 DMF0082 의 EXCEL FORM/UPLOAD 양식을 기본 RULE 로"
    --   계약:
    --     · IN  = 메인 GET(P_DMF0014_GET_CUST_FCST_UPLOAD_DATA) 과 **동일 축·동일 이름 15개**
    --             → FE 가 store.filters 를 가공 없이 전달하면 그대로 성립한다.
    --     · OUT = 업로드 양식의 **정보 컬럼 13종**(SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT
    --             ATTRIBUTE1~13 과 1:1). 값 컬럼 W27~W31(ATTRIBUTE14~18)은 **입력 전용**이라
    --             SP 가 내리지 않는다 — FE 가 빈칸으로 채운다(hook #135 §3-4).
    --     · 본문은 메인 GET 의 FROM/WHERE 를 그대로 쓰고 **동적 기간 컬럼(v_iteration)만 제외**한다.
    --       (조회조건에 걸린 데이터 = 양식 대상 이라는 §3-1 정의를 구조적으로 보장)
    ------------------------------------------------------------------------------------------------
    PROCEDURE P_DMF0014_GET_EXCEL_FORM_DATA
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

        V_SQL_TEXT := '
        SELECT CP.DIVISION_ID
             , CP.SCM_SITE_ID
             , CP.PLANT_SITE_ID
             , CP.CUSTOMER_PROJECT_CODE
             , CP.CUSTOMER_MODEL
             , CP.INCOTERMS
             , CP.FCST_TYPE
             , CP.DOM_EXP
             , CP.MEASURE_GROUP
             , CP.MEASURE
             , CP.UPLOAD_UOM
             , CP.PROJECT_CODE
             , CP.ITEM_ID
        FROM   DM_PLN_CUSTOMER_PSI CP
        INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(''' || P_USER_ID || ''', ''' || P_MENU_ID || ''')) TEI
        ON     TEI.UNIT_ID = CP.DIVISION_ID
        INNER JOIN  SCM_MST_SITE S
            ON  CP.DIVISION_ID = S.DIVISION_ID
            AND CP.SCM_SITE_ID = S.SCM_SITE_ID
        LEFT OUTER JOIN SCM_MST_SITE_ITEM ITM
            ON  S.DIVISION_ID  = ITM.DIVISION_ID
            AND S.SCM_SITE_ID  = ITM.SCM_SITE_ID
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
        AND    CP.MEASURE IN (SELECT DISTINCT MEASURE
                              FROM   DM_MST_CUSTOMER_FCST X
                              WHERE  1 = 1
                              AND    X.DIVISION_ID = CP.DIVISION_ID
                              AND    X.SCM_SITE_ID = CP.SCM_SITE_ID
                              AND    X.UPLOAD_BUCKET_TYPE = ''p_bucket_type''
                              AND    X.VALID_YN = ''Y''
                            )
        GROUP BY CP.DIVISION_ID
               , CP.SCM_SITE_ID
               , CP.PLANT_SITE_ID
               , CP.CUSTOMER_PROJECT_CODE
               , CP.CUSTOMER_MODEL
               , CP.INCOTERMS
               , CP.FCST_TYPE
               , CP.DOM_EXP
               , CP.MEASURE_GROUP
               , CP.MEASURE
               , CP.UPLOAD_UOM
               , CP.PROJECT_CODE
               , CP.ITEM_ID
        ORDER BY CP.DIVISION_ID
               , CP.SCM_SITE_ID
               , CP.PLANT_SITE_ID
               , CP.CUSTOMER_PROJECT_CODE
               , CP.CUSTOMER_MODEL
               , CP.MEASURE
       ';

        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_division_id',    FN_SCM_GET_WHERE_SQL('CP.DIVISION_ID',   'IN', P_DIVISION_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_dept_id',        FN_SCM_GET_WHERE_SQL('ITM.DEPT_ID',      'IN', P_DEPT_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_end_customer',   FN_SCM_GET_WHERE_SQL('S.END_CUSTOMER',   'IN', P_END_CUSTOMER));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_scm_site_id',    FN_SCM_GET_WHERE_SQL('CP.SCM_SITE_ID',   'IN', P_SCM_SITE_ID));
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
    END P_DMF0014_GET_EXCEL_FORM_DATA;
"""

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def src(typ):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014'
                   AND TYPE=:t ORDER BY LINE""", {"t": typ})
    return "".join(r[0] for r in cur.fetchall())


spec, body = src("PACKAGE"), src("PACKAGE BODY")
con.close()

if "P_DMF0014_GET_EXCEL_FORM_DATA" in spec or "P_DMF0014_GET_EXCEL_FORM_DATA" in body:
    print("[skip] 이미 존재 — 재생성하지 않음"); sys.exit(0)

# SPEC: 마지막 END 앞에 삽입
i = spec.rstrip().rfind("END")
spec_new = "CREATE OR REPLACE " + spec[:i] + PROC_SPEC + "\n" + spec[i:]

# BODY: 마지막 END 앞에 삽입
j = body.rstrip().rfind("END")
body_new = "CREATE OR REPLACE " + body[:j] + PROC_BODY + "\n" + body[j:]

(OUT / "01_PKG_DMF0014_SPEC.sql").write_text("SET DEFINE OFF\n" + spec_new.rstrip() + "\n/\n", encoding="utf-8")
(OUT / "02_PKG_DMF0014_BODY.sql").write_text("SET DEFINE OFF\n" + body_new.rstrip() + "\n/\n", encoding="utf-8")
print(f"[built] {OUT}\n  SPEC {len(spec_new)} chars / BODY {len(body_new)} chars")
