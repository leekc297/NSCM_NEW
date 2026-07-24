
  CREATE OR REPLACE EDITIONABLE PACKAGE "SCM_MGR"."PKG_DMF0049" IS
    /*
    * Program ID   : PKG_DMF0049
    * Description  : PKG_DMF0049
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.15   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DMF0049_GET_MEASURE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0049_GET_SPREAD_TITLE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_START_DT      VARCHAR2
       ,P_END_DT        VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    -- [PKG CONSOLIDATION 20260723] 신규 멤버 2
    PROCEDURE P_DMF0049_GET_SALES_ETC_REPORTS_DATA
    (
        P_DIVISION_ID IN VARCHAR2
      , P_MDF_TYPE IN VARCHAR2
      , P_YYYY IN VARCHAR2
      , P_SP_VERSION_NO IN VARCHAR2
      , P_USER_GROUP IN VARCHAR2
      , P_CREATED_BY IN VARCHAR2
      , P_USER_ID IN VARCHAR2
      , P_MENU_ID IN VARCHAR2
      , O_RC1 OUT SYS_REFCURSOR
      , O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0049_SAVE_SALES_ETC_REPORT_C
    (
        P_ACTIVE_FLAG IN VARCHAR2
      , P_RESULT_MONTH IN VARCHAR2
      , P_DIVISION_ID IN VARCHAR2
      , P_VERSION_NO IN VARCHAR2
      , P_DATA_SEQ IN VARCHAR2
      , P_DEPARTMENT_ID IN VARCHAR2
      , P_DEPARTMENT_EDIT_FLAG IN VARCHAR2
      , P_DEPARTMENT_NAME IN VARCHAR2
      , P_DEPT_ID IN VARCHAR2
      , P_CUST_REPORT IN VARCHAR2
      , P_END_CUST_REPORT IN VARCHAR2
      , P_SOLDTO_CODE IN VARCHAR2
      , P_SOLDTO_CUST_REPORT IN VARCHAR2
      , P_PRODUCT_GROUP IN VARCHAR2
      , P_ITEM_ID IN VARCHAR2
      , P_PRODUCT_DETAILS IN VARCHAR2
      , P_CURRENCY IN VARCHAR2
      , P_COMPANY_ID IN VARCHAR2
      , P_BIZ_TYPE IN VARCHAR2
      , P_APPLICATION_GR IN VARCHAR2
      , P_APPLICATION IN VARCHAR2
      , P_COUNTRY_CODE IN VARCHAR2
      , P_PROJECT_CODE IN VARCHAR2
      , P_SCM_SITE_ID IN VARCHAR2
      , P_FCST_TYPE IN VARCHAR2
      , P_ITEM_USE IN VARCHAR2
      , P_SOLDTO_COUNTRY IN VARCHAR2
      , P_SHIPTO_COUNTRY IN VARCHAR2
      , P_END_CUSTOMER IN VARCHAR2
      , P_ETC_DESCR IN VARCHAR2
      , P_CELL_MODEL_INFO IN VARCHAR2
      , P_CELL_MODEL IN VARCHAR2
      , P_MEASURE IN VARCHAR2
      , P_YYYYMMDD IN VARCHAR2
      , P_QTY IN VARCHAR2
      , P_CREATED_BY IN VARCHAR2
      , O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

END PKG_DMF0049;
/

CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SCM_MGR"."PKG_DMF0049" IS

    PROCEDURE P_DMF0049_GET_MEASURE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
         * Program ID   : DMF0049_GET_MEASURE
         * Description  :  Sales ETC Report 메저 가져오기
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2020/03/30 HWI1993   Initial Release -- dmf0044 에서 복사해서 생성
         * 2020/05/04 HWI1993   DIVISION_ID 를 WHERE 절에 추가
         * 2020/06/10 HWI1993   40이 아닌 경우 USD 추가
         * 2021/01/28 P.C.I   [C20210125-000207] 소형사업부 RTF_SYS_RP Measure 추가
           2022.04.25 HWI1993   GM JV 작업
           2026.03.14 김준규   [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS

        V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE     VARCHAR2(30 CHAR);
        N_LOG_COUNT    INTEGER := 0;
        V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
        V_DESCRIPTION  VARCHAR2(500 CHAR);
        D_EVENT_DATE   DATE;
        V_IN_PARA_DATA VARCHAR2(4000);
    BEGIN

        V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID);

        IF P_DIVISION_ID = '40' THEN
            OPEN O_RC1 FOR
                SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME NAME, TEI.EDIT_YN
                FROM   SCM_MST_SHEET_MEASURE A
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = A.DIVISION_ID
                WHERE  1 = 1
                AND    PROGRAM_ID = 'DMF0049'
                AND    SHEET_NAME IN ( 'MDF Reports','mdfReports' )
                AND    COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'RTF_SYS_RP') --[C20210125-000207] 소형사업부 RTF_SYS_RP Measure 추가
                AND    INSTR(A.DIVISION_ID, P_DIVISION_ID) > 0
                ORDER  BY SORT_ORDER_NO;
        ELSE
            OPEN O_RC1 FOR
                SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME NAME, TEI.EDIT_YN
                FROM   SCM_MST_SHEET_MEASURE A
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = A.DIVISION_ID
                WHERE  1 = 1
                AND    PROGRAM_ID = 'DMF0049'
                AND    SHEET_NAME IN ( 'MDF Reports','mdfReports' )
                AND    COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD')
                AND    INSTR(A.DIVISION_ID, P_DIVISION_ID) > 0
                ORDER  BY SORT_ORDER_NO;
        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_DESCRIPTION
                                ,D_EVENT_DATE
                                ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE  => SQLCODE
                                ,P_SQL_ERR_MSG   => SQLERRM
                                ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0049_GET_MEASURE;

    PROCEDURE P_DMF0049_GET_SPREAD_TITLE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_START_DT      VARCHAR2
       ,P_END_DT        VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0049_GET_SPREAD_TITLE
        * Description  :
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 2020/04/02 hwi1993   DMF0049_GET_SPREAD_TITLE
        * 2022/05/12 hwi1993   GM JV
        * 2026/03/15 김준규      [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS

        P_PROGRAM_ID   VARCHAR2(50 CHAR);
        P_SHEET_NAME   VARCHAR2(50 CHAR);
        V_IN_PARA_DATA VARCHAR2(4000);
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

        V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID
                                     ,'p_created_by' VALUE P_CREATED_BY
                                     ,'p_start_dt' VALUE P_START_DT
                                     ,'p_end_dt' VALUE P_END_DT);

        P_PROGRAM_ID := 'DMF0049';
        P_SHEET_NAME := 'MDF Reports';

        OPEN O_RC1 FOR
            SELECT C.PROGRAM_ID
                  ,C.SHEET_NAME
                  ,C.COLUMN_NAME
                  ,C.COLUMN_LABEL_NAME
                   --, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) SORT_ORDER_NO
                  ,CASE
                       WHEN P_DIVISION_ID = '40' THEN
                        TO_CHAR(C.SORT_ORDER_NO)
                       WHEN P_DIVISION_ID LIKE '81%' THEN
                        C.ATTRIBUTE2
                       WHEN P_DIVISION_ID = '82' THEN
                        C.ATTRIBUTE3
                   END AS SORT_ORDER_NO
                  ,C.DATA_SORT_METHOD_CODE
                  ,C.SMALL_CLASS_LABEL_NAME
                  ,C.LARGE_CLASS_LABEL_NAME
                  ,'' AS DAY_CODE
                  ,C.FIXED_FLAG
                  ,CASE
                       WHEN CASE
                                WHEN P_DIVISION_ID = '40' THEN
                                 C.VISIBLE_FLAG
                                WHEN P_DIVISION_ID LIKE '81%' THEN
                                 C.ATTRIBUTE4
                                WHEN P_DIVISION_ID = '82' THEN
                                 C.ATTRIBUTE5
                            END = 'Y' THEN
                        C.COLUMN_WIDTH
                       ELSE
                        0
                   END AS COLUMN_WIDTH
                  ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                  ,C.CELL_COMBO_DATA_TYPE
                  ,TO_CHAR(C.DATA_SCALE_NUMBER) DATA_SCALE_NUMBER
                  ,TO_CHAR(C.DATA_MAX_LENGTH) DATA_MAX_LENGTH
                  ,C.HORIZONTAL_ALIGN_CODE
                  ,C.UPPERCASE_APPLY_FLAG
                  ,CASE
                       WHEN P_DIVISION_ID = '40' THEN
                        C.VISIBLE_FLAG
                       WHEN P_DIVISION_ID LIKE '81%' THEN
                        C.ATTRIBUTE4
                       WHEN P_DIVISION_ID = '82' THEN
                        C.ATTRIBUTE5
                   END AS VISIBLE_FLAG
                  ,C.DEFAULT_FLAG
                  ,C.USER_SELECTABLE_FLAG
                  ,C.VALID_YN
                  ,C.DIVISION_ID
                  ,P_DIVISION_ID ATTRIBUTE1 -- COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다.
                  ,CASE
                       WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN
                        C.ATTRIBUTE1
                       ELSE
                        C.ATTRIBUTE1
                   END AS ATTRIBUTE2
                  ,'' AS ATTRIBUTE3
                  ,'' AS ATTRIBUTE4
                  ,'' AS ATTRIBUTE5
                  ,TEI.EDIT_YN
            FROM   SCM_MST_SHEET_COLUMNS C
            INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
            ON     TEI.UNIT_ID = C.DIVISION_ID
            WHERE  1 = 1
            AND    C.PROGRAM_ID = P_PROGRAM_ID
            AND    C.SHEET_NAME = P_SHEET_NAME
            AND    C.VALID_YN = 'Y'
            AND    C.DIVISION_ID LIKE '%' || P_DIVISION_ID || '%'
            UNION ALL

            SELECT P_PROGRAM_ID PROGRAM_ID
                  ,P_SHEET_NAME SHEET_NAME
                  ,MA.COLUMN_NAME
                  ,MA.COLUMN_LABEL_NAME
                  ,MA.SORT_ORDER_NO
                  ,'' AS DATA_SORT_METHOD_CODE
                  ,MA.SMALL_CLASS_LABEL_NAME
                  ,MA.LARGE_CLASS_LABEL_NAME
                  ,MA.DAY_CODE
                  ,'' AS FIXED_FLAG
                  ,120 COLUMN_WIDTH
                  ,MA.CELL_CONTROL_OBJECT_TYPE_CODE --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                  ,'' AS CELL_COMBO_DATA_TYPE
                   --, '2'         AS DATA_SCALE_NUMBER
                  ,'3' AS DATA_SCALE_NUMBER -- 20181029
                  ,'2' AS DATA_MAX_LENGTH
                  ,'R' AS HORIZONTAL_ALIGN_CODE
                  ,'' AS UPPERCASE_APPLY_FLAG
                  ,'Y' AS VISIBLE_FLAG
                  ,'' AS DEFAULT_FLAG
                  ,'' AS USER_SELECTABLE_FLAG
                  ,'' AS VALID_YN
                  ,'' AS DIVISION_ID
                  ,'' AS ATTRIBUTE1
                  ,'' AS ATTRIBUTE2
                  ,'' AS ATTRIBUTE3
                  ,'' AS ATTRIBUTE4
                  ,'' AS ATTRIBUTE5
                  ,'N' AS EDIT_YN
            FROM   (SELECT DISTINCT 'M_' || BASIS_YYYYMM AS COLUMN_NAME
                                   ,MONTH_NAME COLUMN_LABEL_NAME
                                   ,MONTH_NAME SMALL_CLASS_LABEL_NAME
                                   ,MONTH_NAME LARGE_CLASS_LABEL_NAME
                                   ,'' AS DAY_CODE
                                   ,TO_CHAR(BASIS_YYYYMM) SORT_ORDER_NO
                                   ,'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                    FROM   SCM_SYS_CALENDAR_M
                    WHERE  BASIS_YYYYMMDD >= P_START_DT
                    AND    BASIS_YYYYMMDD <= P_END_DT

                    ) MA

            ORDER  BY SORT_ORDER_NO;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_LOG_TYPE   := 'ERROR';
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_DESCRIPTION
                                ,D_EVENT_DATE
                                ,V_PROC_INPUT
                                ,V_SQL_CODE
                                ,V_SQL_ERRMSG
                                ,V_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0049_GET_SPREAD_TITLE;

  PROCEDURE P_DMF0049_GET_SALES_ETC_REPORTS_DATA 
(
    p_division_id     IN  VARCHAR2,
    p_mdf_type        IN  VARCHAR2,
    p_yyyy            IN  VARCHAR2,
    p_sp_version_no   IN  VARCHAR2,
    p_user_group      IN  VARCHAR2,
    p_created_by      IN  VARCHAR2,
    p_user_id         IN  VARCHAR2,   -- For EditYn
    p_menu_id         IN  VARCHAR2,   -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0049_GET_SALES_ETC_REPORTS_DATA
 * Description  : ETC Sales Reports 메인 데이터 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/04/02  HWI1993	Initial Release
 * 2020/05/19	HWI1993	SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER, ITEM_USE ISNULL 처리 ( NULL 과 공백이 GROUPING 분리됨 )
 * 2021/01/26     P.C.I		[C20210125-000207] 40사업부 RTF Measure, CELL_MODEL_INFO 컬럼 추가
 * 2022/01/12	rosia27		[C20220105-000064]ETC Report 구버전 조회시 조직 명칭 오류의 건
 * 2022/01/21	rosia27		[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
 * 2026/06/05	NextSCM Migration	[PJ202650304] 기존 배포본(미완성 자동변환, INVALID) 전면 재변환. #SELECT_MEASURE/#PJT/#temp→GTT(GT_DMF0049_*), @PROD 누적→FOR LOOP, 동적 SQL/PIVOT 정정(EXECUTE 대신 OPEN O_RC1 FOR), Pilot 표준 적용(로깅/EXCEPTION/O_RESULT_CURSOR/EDIT_YN 권한 INNER JOIN). 템플릿=DMF0044_GET_SALES_REPORTS_DATA(VALID)
 */
IS

    V_PROD          VARCHAR2(4000 CHAR) := '';   -- PIVOT IN 절 (값 AS 별칭)
    V_COLS          VARCHAR2(4000 CHAR) := '';   -- 외부 SELECT 의 PIVOT 컬럼 참조
    V_SQL           VARCHAR2(32767 CHAR) := '';
    V_GROUP_ID      VARCHAR2(100 CHAR) := '';
    V_TEAM_ID       VARCHAR2(100 CHAR) := '';
    V_USER_MEA_CNT  PLS_INTEGER := 0;

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── GTT 초기화 (세션 보존 GTT 이므로 DELETE) ── */
    DELETE FROM SCM_MGR.GT_DMF0049_SELECT_MEASURE;
    DELETE FROM SCM_MGR.GT_DMF0049_PJT;
    DELETE FROM SCM_MGR.GT_DMF0049_T;

    ---------------------------------------------------------------------------------
    --            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    BEGIN
        SELECT 1
        INTO   V_USER_MEA_CNT
        FROM   DUAL
        WHERE  EXISTS (
            SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
            AND    VALID_YN = 'Y'
            AND    SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
            AND    SEGMENT1 = p_user_group
        );
        V_GROUP_ID := 'ADMIN';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_GROUP_ID := '';
    END;
    ---------------------------------------------------------------------------------
    --            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------

    -- 팀 권한
    BEGIN
        SELECT DEPT_ID
        INTO   V_TEAM_ID
        FROM   TB_FX_USER
        WHERE  USERID = p_created_by;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_TEAM_ID := '';
        WHEN TOO_MANY_ROWS THEN
            V_TEAM_ID := '';
    END;

    V_USER_MEA_CNT := 0;

    -- MEASURE JOIN 처리용
    -- 사용자메저 처리
    BEGIN
        SELECT 1
        INTO   V_USER_MEA_CNT
        FROM   DUAL
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MST_TITLESET_USER U
            WHERE  U.PROGRAM_ID = 'DMF0049'
            AND    U.SHEET_NAME = 'MDF Reports'
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
            AND    U.USER_ID    = p_created_by
        );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_USER_MEA_CNT := 0;
    END;

    IF V_USER_MEA_CNT = 0 THEN
        INSERT INTO SCM_MST_TITLESET_USER
        ( USER_ID
        , PROGRAM_ID
        , SHEET_NAME
        , USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME
        , SORT_ORDER_NO
        , SUB_TOTAL_FLAG
        , DATA_SORT_METHOD_CODE
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
        )
        SELECT p_created_by
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'M'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , 'N'
             , ''
             , p_created_by
             , SYSDATE                 -- [PJ202650304] DATE 컬럼: 문자열 변환 제거(ORA-01861 예방)
             , p_created_by
             , SYSDATE
        FROM   SCM_MST_SHEET_MEASURE C
        WHERE  1 = 1
        AND    C.PROGRAM_ID  = 'DMF0049'
        AND    C.SHEET_NAME  = 'MDF Reports'
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;

    /* ── GT_DMF0049_SELECT_MEASURE 적재 (#SELECT_MEASURE) ── */
    INSERT INTO SCM_MGR.GT_DMF0049_SELECT_MEASURE
        (PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE, SORT_ORDER_NO)
    SELECT U.PROGRAM_ID
         , U.SHEET_NAME
         , U.USER_ID
         , U.COLUMN_NAME AS MEASURE
         , U.SORT_ORDER_NO
    FROM SCM_MST_TITLESET_USER U
    WHERE 1 = 1
    AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND U.PROGRAM_ID   = 'DMF0049'
    AND U.USER_ID      = p_created_by;

    /* ── GT_DMF0049_PJT 적재 (#PJT) ── */
    INSERT INTO SCM_MGR.GT_DMF0049_PJT
        (DIVISION_ID, PROJECT_CODE, PROJECT_NAME, PRODUCT_GROUP_NAME)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_NAME, A.PRODUCT_GROUP_NAME
    FROM SCM_MST_PROJECT A
    JOIN (
        SELECT PROJECT_CODE, MAX(PROJECT_VER_SEQ) AS SEQ
        FROM SCM_MST_PROJECT
        WHERE DIVISION_ID = p_division_id
        GROUP BY PROJECT_CODE
    ) B ON A.PROJECT_CODE = B.PROJECT_CODE AND A.PROJECT_VER_SEQ = B.SEQ
    WHERE A.DIVISION_ID = p_division_id;

    -- 단계1. 데이터 쿼리 ########################################################
    /* ── GT_DMF0049_T 적재 (#temp) ── */
    INSERT INTO SCM_MGR.GT_DMF0049_T
         ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID
         , T_DEPARTMENT_ID, T_DEPARTMENT_NAME, DEPT_ID, T_DEPT_ID, T_DEPT_NAME
         , END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID
         , ITEM_ID, NICK_NAME, MEASURE, PLANT_SITE_ID, COMPANY_ID
         , YYYYMM, CURRENCY, QTY, EDIT_FLAG, APP
         , SOLDTO_CUST_REPORT, DMS_CUSTOMER, BIZ_TYPE, APPLICATION_GR, PRODUCT_DETAILS
         , DISPLAY_SEQ1, DISPLAY_SEQ2, COUNTRY_CODE, SOLDTO_CODE, CELL_PER_CAR
         , CELL_NAME, FCST_TYPE, DATA_SEQ, INCOTERMS, ITEM_USE
         , MODEL_TYPE, MODULE_PER_CAR, PROJECT_NAME, SOLDTO_COUNTRY, SHIPTO_COUNTRY
         , END_CUSTOMER, CELL_MODEL, CELL_MODEL_INFO )
    SELECT
        R.DIVISION_ID
        , R.VERSION_NO
        , R.CUTOFF_TYPE
        , R.CUTOFF_YYYYMMDD
        , R.DEPARTMENT_ID
        , R.DEPARTMENT_ID AS T_DEPARTMENT_ID
        , CASE WHEN NVL(R.DEPARTMENT_NAME,'') <> '' THEN R.DEPARTMENT_NAME ELSE LK1.SEGMENT2 END AS T_DEPARTMENT_NAME
        , R.DEPT_ID
        , R.DEPT_ID AS T_DEPT_ID
        , CASE WHEN NVL(R.DEPT_NAME,'') <> '' THEN R.DEPT_NAME ELSE LK2.SEGMENT2 END AS T_DEPT_NAME
        , R.END_CUST_REPORT
        , R.CUST_REPORT
        , R.PRODUCT_GROUP
        , R.PROJECT_CODE
        , R.SCM_SITE_ID
        , R.ITEM_ID
        , SINGLE.NICK_NAME
        , R.MEASURE
        , R.PLANT_SITE_ID
        , R.COMPANY_ID
        , 'M_' || SUBSTR(R.YYYYMMDD, 1, 6) AS YYYYMM
        , R.CURRENCY
        , SUM(R.QTY) AS QTY
        , CASE WHEN (V_GROUP_ID = 'ADMIN') THEN 'Y' ELSE 'N' END AS EDIT_FLAG
        , R.APPLICATION AS APP
        , R.SOLDTO_CUST_REPORT
        , NVL(SI.ATTRIBUTE2,'') AS DMS_CUSTOMER
        , R.BIZ_TYPE AS BIZ_TYPE
        , R.APPLICATION_GR AS APPLICATION_GR
        , R.PRODUCT_DETAILS AS PRODUCT_DETAILS
        , LK1.DISPLAY_SEQ AS DISPLAY_SEQ1
        , LK2.DISPLAY_SEQ AS DISPLAY_SEQ2
        , R.COUNTRY_CODE
        , R.SOLDTO_CODE
        , SI.CELL_PER_CAR
        , '' AS CELL_NAME
        , R.FCST_TYPE
        , R.DATA_SEQ
        , R.INCOTERMS
        , NVL(R.ITEM_USE,'') AS ITEM_USE
        , ITEM_V.ITEM_CLASS_NAME AS MODEL_TYPE
        , CASE WHEN SI.CELL_PER_MODULE <> 0 THEN SI.CELL_PER_CAR / SI.CELL_PER_MODULE END AS MODULE_PER_CAR
        , LK3.SEGMENT3 AS PROJECT_NAME
        , NVL(R.SOLDTO_COUNTRY,'') AS SOLDTO_COUNTRY
        , NVL(R.SHIPTO_COUNTRY,'') AS SHIPTO_COUNTRY
        , NVL(R.END_CUSTOMER,'') AS END_CUSTOMER
        , NVL(R.ATTRIBUTE3,'') AS CELL_MODEL          --[C20211112-000213]
        , NVL(R.CELL_MODEL_INFO, '') AS CELL_MODEL_INFO --[C20211112-000213]
    FROM DM_PLN_SALES_ETC_REPORT_C R
    LEFT JOIN SCM_MST_SITE_ITEM SI
        ON R.DIVISION_ID = SI.DIVISION_ID
            AND R.PROJECT_CODE = SI.PROJECT_CODE
            AND R.SCM_SITE_ID = SI.SCM_SITE_ID
            AND R.ITEM_ID = SI.ITEM_ID
    LEFT JOIN DM_MST_ITEM_SINGLE_V SINGLE
        ON SI.DIVISION_ID = SINGLE.DIVISION_ID
            AND SI.ITEM_ID = SINGLE.ITEM_ID
    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON R.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT' || CASE WHEN R.DIVISION_ID = '40' THEN '' ELSE '_' || R.DIVISION_ID END
    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 ON R.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0049_DEPARTMENT_TEAM2' || CASE WHEN R.DIVISION_ID = '40' THEN '' ELSE '_' || R.DIVISION_ID END
    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK3 ON R.PROJECT_CODE = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_ETC_PROJECT' AND LK3.SEGMENT1 = R.DIVISION_ID
    LEFT OUTER JOIN SCM_MST_SITE ST ON R.SCM_SITE_ID = ST.SCM_SITE_ID AND R.DIVISION_ID = ST.DIVISION_ID
    LEFT OUTER JOIN SCM_MST_COUNTRY CO ON ST.COUNTRY = CO.COUNTRY
    LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER CS ON R.DIVISION_ID = CS.DIVISION_ID AND R.SCM_SITE_ID = CS.SCM_SITE_ID AND CS.REP_YN = 'Y' AND CS.VALID_YN = 'Y'
    LEFT OUTER JOIN SCM_MGR.GT_DMF0049_PJT PJT ON R.DIVISION_ID = PJT.DIVISION_ID AND R.PROJECT_CODE = PJT.PROJECT_CODE
    LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V ITEM_V ON R.DIVISION_ID = ITEM_V.DIVISION_ID AND R.ITEM_ID = ITEM_V.ITEM_ID
    WHERE R.DIVISION_ID = p_division_id
        AND R.CUTOFF_TYPE = p_mdf_type
        AND SUBSTR(R.YYYYMMDD, 1, 4) = p_yyyy
        AND R.VERSION_NO = p_sp_version_no
    GROUP BY
        R.DIVISION_ID
        , R.VERSION_NO
        , R.CUTOFF_TYPE
        , R.CUTOFF_YYYYMMDD
        , R.DEPARTMENT_ID
        , R.DEPT_ID
        , R.END_CUST_REPORT
        , R.CUST_REPORT
        , R.PRODUCT_GROUP
        , R.PROJECT_CODE
        , R.SCM_SITE_ID
        , R.ITEM_ID
        , SINGLE.NICK_NAME
        , R.MEASURE
        , R.PLANT_SITE_ID
        , R.COMPANY_ID
        , SUBSTR(R.YYYYMMDD, 1, 6)
        , R.CURRENCY
        , R.APPLICATION
        , R.SOLDTO_CUST_REPORT
        , NVL(SI.ATTRIBUTE2,'')
        , R.BIZ_TYPE
        , R.APPLICATION_GR
        , R.PRODUCT_DETAILS
        , LK1.DISPLAY_SEQ
        , LK2.DISPLAY_SEQ
        , R.COUNTRY_CODE
        , R.SOLDTO_CODE
        , SI.CELL_PER_CAR
        , R.FCST_TYPE
        , R.DATA_SEQ
        , R.INCOTERMS
        , SUBSTR(R.PROJECT_CODE, 1, 1)
        , ITEM_V.ITEM_CLASS_NAME
        , CASE WHEN SI.CELL_PER_MODULE <> 0 THEN SI.CELL_PER_CAR / SI.CELL_PER_MODULE END
        , LK3.SEGMENT3
        , NVL(R.SOLDTO_COUNTRY, '')
        , NVL(R.SHIPTO_COUNTRY, '')
        , NVL(R.END_CUSTOMER, '')
        , NVL(R.ITEM_USE, '')
        , NVL(R.ATTRIBUTE3,'')          --[C20211112-000213]
        , NVL(R.CELL_MODEL_INFO, '')    --[C20211112-000213]
        , CASE WHEN NVL(R.DEPT_NAME,'') <> '' THEN R.DEPT_NAME ELSE LK2.SEGMENT2 END
        , CASE WHEN NVL(R.DEPARTMENT_NAME,'') <> '' THEN R.DEPARTMENT_NAME ELSE LK1.SEGMENT2 END;

    -- 단계3. PIVOT 기간 쿼리 ########################################################
    V_PROD := '';
    V_COLS := '';
    FOR rec IN (
        SELECT DISTINCT BASIS_YYYYMM
        FROM SCM_SYS_CALENDAR_M
        WHERE CALENDAR_YYYY = p_yyyy
        ORDER BY BASIS_YYYYMM
    )
    LOOP
        V_PROD := V_PROD || '''M_' || rec.BASIS_YYYYMM || ''' AS "M_' || rec.BASIS_YYYYMM || '",';
        V_COLS := V_COLS || '"M_' || rec.BASIS_YYYYMM || '",';
    END LOOP;

    IF V_PROD IS NOT NULL AND LENGTH(V_PROD) > 0 THEN
        V_PROD := RTRIM(V_PROD, ',');
        V_COLS := RTRIM(V_COLS, ',');
    END IF;

    -- 단계4. 실행 쿼리 ########################################################
    V_SQL :=
       'SELECT DIVISION_ID, VERSION_NO, DEPARTMENT_ID, T_DEPARTMENT_ID, T_DEPARTMENT_NAME, DEPT_ID, T_DEPT_ID, T_DEPT_NAME'
    || ', NVL(END_CUST_REPORT, '''') AS END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID'
    || ', NVL(NICK_NAME, '''') AS NICK_NAME, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, COMPANY_ID, CURRENCY'
    || ', NVL(APP, '''') AS APPLICATION, EDIT_FLAG, SOLDTO_CUST_REPORT, BIZ_TYPE, APPLICATION_GR, PRODUCT_DETAILS'
    || ', CELL_MODEL_INFO, CELL_MODEL, COUNTRY_CODE, SOLDTO_CODE, CELL_PER_CAR, CELL_NAME, DATA_SEQ, FCST_TYPE, INCOTERMS'
    || ', ITEM_USE, MODEL_TYPE, MODULE_PER_CAR, PROJECT_NAME, SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER'
    || CASE WHEN V_COLS IS NOT NULL AND LENGTH(V_COLS) > 0 THEN ', ' || V_COLS ELSE '' END
    || ' FROM ( SELECT A.* FROM SCM_MGR.GT_DMF0049_T A'
    || ' JOIN SCM_MGR.GT_DMF0049_SELECT_MEASURE B ON A.MEASURE = B.MEASURE'
    || ' INNER JOIN ( SELECT * FROM SCM_ADM_USER_MNU_EDIT_AUTH_V WHERE USER_ID = ''' || p_user_id || ''' AND MNU_ID = ''' || p_menu_id || ''' AND UNIT_TP_CD = ''D'' ) T2 ON A.DIVISION_ID = T2.UNIT_ID'
    || ' ) T'
    || ' PIVOT ( SUM(QTY) FOR YYYYMM IN ( ' || V_PROD || ' ) ) PVT'
    || ' ORDER BY DIVISION_ID, VERSION_NO, DISPLAY_SEQ1, DISPLAY_SEQ2, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT'
    || ', PRODUCT_GROUP, ITEM_ID, NICK_NAME, PRODUCT_DETAILS, CELL_MODEL_INFO, CELL_MODEL, CURRENCY, COMPANY_ID, BIZ_TYPE, APPLICATION_GR, NVL(APP, ''''), COUNTRY_CODE, DATA_SEQ'
    || ', CASE WHEN MEASURE IN (''LOC'') THEN 1 WHEN MEASURE IN (''RTF'',''Business_Plan'') THEN 2 WHEN MEASURE IN (''SalesAmt_LOC'') THEN 3 WHEN MEASURE IN (''SalesAmt_KRW'') THEN 4 ELSE 5 END'
    || ', END_CUSTOMER';

    OPEN O_RC1 FOR V_SQL;

    /* ── COMMIT (종료 직전 1회) ── */
    COMMIT;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회+DML 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'p_division_id'   VALUE p_division_id,
            'p_mdf_type'      VALUE p_mdf_type,
            'p_yyyy'          VALUE p_yyyy,
            'p_sp_version_no' VALUE p_sp_version_no,
            'p_user_group'    VALUE p_user_group,
            'p_created_by'    VALUE p_created_by,
            'p_user_id'       VALUE p_user_id,
            'p_menu_id'       VALUE p_menu_id
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0049_GET_SALES_ETC_REPORTS_DATA;


  PROCEDURE P_DMF0049_SAVE_SALES_ETC_REPORT_C 
(
      p_active_flag           IN VARCHAR2
    , p_result_month          IN VARCHAR2
    , p_division_id           IN VARCHAR2
    , p_version_no            IN VARCHAR2
    , p_data_seq              IN VARCHAR2
    , p_department_id         IN VARCHAR2
    , p_department_edit_flag  IN VARCHAR2
    , p_department_name       IN VARCHAR2
    , p_dept_id               IN VARCHAR2
    , p_cust_report           IN VARCHAR2
    , p_end_cust_report       IN VARCHAR2
    , p_soldto_code           IN VARCHAR2
    , p_soldto_cust_report    IN VARCHAR2
    , p_product_group         IN VARCHAR2
    , p_item_id               IN VARCHAR2
    , p_product_details       IN VARCHAR2
    , p_currency              IN VARCHAR2
    , p_company_id            IN VARCHAR2
    , p_biz_type              IN VARCHAR2
    , p_application_gr        IN VARCHAR2
    , p_application           IN VARCHAR2
    , p_country_code          IN VARCHAR2
    , p_project_code          IN VARCHAR2
    , p_scm_site_id           IN VARCHAR2
    , p_fcst_type             IN VARCHAR2
    , p_item_use              IN VARCHAR2
    , p_soldto_country        IN VARCHAR2
    , p_shipto_country        IN VARCHAR2
    , p_end_customer          IN VARCHAR2
    , p_etc_descr             IN VARCHAR2
    , p_cell_model_info       IN VARCHAR2   --[C20210125-000207] 40사업부 CELL_MODEL_INFO 컬럼 추가
    , p_cell_model            IN VARCHAR2   --[C20211112-000213]
    , p_measure               IN VARCHAR2
    , p_yyyymmdd              IN VARCHAR2
    , p_qty                   IN VARCHAR2
    , p_created_by            IN VARCHAR2
    , O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0049_SAVE_SALES_ETC_REPORT_C
 * Description  : 'DM_PLN_SALES_ETC_REPORT_C' TABLE INSERT/UPDATE/DELETE
 * Program History
 *========================================================================================================================
 * 2020/04/08	HWI1993		Initial Release
 * 2020/05/22	hwi1993		Save 이후에 Transfer 처리
 * 2020/09/09   P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2021/01/26   P.C.I		[C20210125-000207] 40사업부 RTF Measure, CELL_MODEL_INFO 컬럼 추가
 * 2021/08/16	hwi1993		[C20210811-000341] ETC Report - GDW 전송시 누락 컬럼 점검
 * 2022/01/14	rosia27		[C20220105-000064]ETC Report 구버전 조회시 조직 명칭 오류의 건
 * 2022/01/21	rosia27		[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
 * 2025/05/09	JSSBAE		[E20250418-001567]_40사업부 Sales Report, ETC Report 개선
 * 2025/07/21	JSSBAE		[E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리
 * 2026/02/03	JSSBAE		[E20260107-001542]_DM_COMPANY 룩업코드 로직 개선
 * 2026/06/05	NextSCM Migration	[PJ202650304] 기존 배포본(미완성 자동변환, INVALID) 전면 재변환. ^구분 WHILE파싱→행생성기 분리 INSERT(빈필드 보존), #temp→GTT(GT_DMF0049_RESULTS_MST/_PRICE/_TEMP_ITEM_SINGLE), GOTO ERR_RTN→구조화 조기 RETURN, UPDATE..FROM/DELETE..JOIN→MERGE/상관서브쿼리/EXISTS, NEXT VALUE FOR SEQ1_DM_PLN_SALES_ETC_REPORT_H 시퀀스 신설, GETDATE→SYSDATE, QTY 문자열↔TO_NUMBER, 로깅(PR_DM_SYS_LOG_BATCH)/EXCEPTION/O_RESULT_CURSOR 표준
 */
IS
    V_PROGRAM_NAME      VARCHAR2(200 CHAR) := 'DMF0049_SAVE_SALES_ETC_REPORT_C';
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_LOG_DESCRIPTION   VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;
    n_delete_count      PLS_INTEGER := 0;
    n_insert_count      PLS_INTEGER := 0;
    n_input_count       PLS_INTEGER := 0;

    v_log_user          VARCHAR2(150 CHAR);
    v_division_id       VARCHAR2(4000 CHAR);
    v_version_no        VARCHAR2(4000 CHAR);
    v_result_month      VARCHAR2(4000 CHAR);
    v_cutoff_yyyymmdd   VARCHAR2(8 CHAR);
    v_cutoff_type       VARCHAR2(20 CHAR);
    v_max_seq           NUMBER := 0;
    v_etc_department_id   VARCHAR2(30 CHAR);
    v_etc_department_name VARCHAR2(100 CHAR);
    v_chk               PLS_INTEGER := 0;
    v_dup_msg           VARCHAR2(2000 CHAR);

    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

    PROCEDURE LOG_END IS
    BEGIN
        V_LOG_TYPE        := 'END';
        V_LOG_MESSAGE     := '########## END of procedure ##########';
        V_LOG_DESCRIPTION := 'input_count: ' || TO_CHAR(n_input_count);
        D_EVENT_DATE      := SYSDATE;
        SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESCRIPTION, D_EVENT_DATE, v_log_user);
    END LOG_END;

BEGIN
    -- 로그 사용자 (p_created_by 의 첫 '^' 토큰)
    IF INSTR(p_created_by, '^') > 1 THEN
        v_log_user := SUBSTR(p_created_by, 1, INSTR(p_created_by, '^') - 1);
    ELSE
        v_log_user := p_created_by;
    END IF;

    -- 시작 LOG  (START)
    V_LOG_TYPE        := 'START';
    V_LOG_MESSAGE     := '########## Start of procedure @@@##########';
    V_LOG_DESCRIPTION := '';
    D_EVENT_DATE      := SYSDATE;
    SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESCRIPTION, D_EVENT_DATE, v_log_user);
    V_LOG_MESSAGE := NULL;

    -- GTT 초기화
    DELETE FROM SCM_MGR.GT_DMF0049_RESULTS_MST;
    DELETE FROM SCM_MGR.GT_DMF0049_RESULTS_MST_PRICE;
    DELETE FROM SCM_MGR.GT_DMF0049_TEMP_ITEM_SINGLE;

    -----------------------------------------------------------------------------------------------------------------------
    -- ^ 구분 입력 파싱 → #results_MST (원본 WHILE 루프 대체: 행 생성기 + 위치 기반 분리, 빈 필드 보존)
    -----------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_DMF0049_RESULTS_MST
        ( ACTIVE_FLAG, RESULT_MONTH, DIVISION_ID, VERSION_NO, DATA_SEQ
        , DEPARTMENT_ID, DEPARTMENT_EDIT_FLAG, T_DEPARTMENT_NAME, DEPT_ID, CUST_REPORT
        , END_CUST_REPORT, SOLDTO_CODE, SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID
        , PRODUCT_DETAILS, CURRENCY, COMPANY_ID, BIZ_TYPE, APPLICATION_GR
        , APPLICATION, COUNTRY_CODE, PROJECT_CODE, SCM_SITE_ID, CELL_MODEL_INFO
        , CELL_MODEL, FCST_TYPE, MEASURE, YYYYMMDD, QTY
        , CREATED_BY, ITEM_USE, SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER )
    SELECT TRIM(REGEXP_SUBSTR(RTRIM(p_active_flag)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_result_month)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_division_id)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_version_no)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_data_seq)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_department_id)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_department_edit_flag)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_department_name)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_dept_id)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_cust_report)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_end_cust_report)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_soldto_code)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_soldto_cust_report)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_product_group)||'^','(.*?)\^',1,n,NULL,1))
         , REPLACE(REPLACE(REPLACE(REPLACE(TRIM(REGEXP_SUBSTR(RTRIM(p_item_id)||'^','(.*?)\^',1,n,NULL,1)),CHR(13),''),CHR(10),''),CHR(9),''),' ','')
         , TRIM(REGEXP_SUBSTR(RTRIM(p_product_details)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_currency)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_company_id)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_biz_type)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_application_gr)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_application)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_country_code)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_project_code)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_scm_site_id)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_cell_model_info)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_cell_model)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_fcst_type)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_measure)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_yyyymmdd)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_qty)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_created_by)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_item_use)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_soldto_country)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_shipto_country)||'^','(.*?)\^',1,n,NULL,1))
         , TRIM(REGEXP_SUBSTR(RTRIM(p_end_customer)||'^','(.*?)\^',1,n,NULL,1))
    FROM ( SELECT LEVEL AS n FROM DUAL
           CONNECT BY LEVEL <= REGEXP_COUNT(RTRIM(p_division_id)||'^','\^') );

    -----------------------------------------------------------------------------------------------------------------------
    -- [E20260107-001542]_DM_COMPANY 룩업코드 검증 (구코드 COMPANY_ID 저장 불가)
    -----------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_chk FROM SCM_MGR.GT_DMF0049_RESULTS_MST R
     WHERE R.COMPANY_ID IN ( SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = 'COMPANY_ID' GROUP BY OLD_VALUE1 )
       AND ROWNUM = 1;
    IF v_chk > 0 THEN
        ROLLBACK;
        V_LOG_TYPE := 'INVALID'; V_LOG_MESSAGE := '구코드 COMPANY_ID는 저장할 수 없습니다.'; V_LOG_DESCRIPTION := ''; D_EVENT_DATE := SYSDATE;
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESCRIPTION, D_EVENT_DATE);
        LOG_END;
        OPEN O_RESULT_CURSOR FOR SELECT '구코드 COMPANY_ID는 저장할 수 없습니다.' AS MSG FROM DUAL;
        RETURN;
    END IF;

    -----------------------------------------------------------------------------------------------------------------------
    -- 가공처리
    -----------------------------------------------------------------------------------------------------------------------
    -- 수량 공백 → 0
    UPDATE SCM_MGR.GT_DMF0049_RESULTS_MST SET QTY = '0' WHERE QTY IS NULL;

    --[C20210125-000207] 40사업부 RTF Measure 없으면 Row 삭제
    DELETE FROM SCM_MGR.GT_DMF0049_RESULTS_MST
    WHERE DIVISION_ID = '40' AND MEASURE = 'RTF_SYS_RP' AND ACTIVE_FLAG = 'I' AND QTY = '0';

    UPDATE SCM_MGR.GT_DMF0049_RESULTS_MST
    SET QTY = TO_CHAR(ROUND(TO_NUMBER(QTY), 3))
    WHERE DIVISION_ID = '40' AND MEASURE = 'RTF_SYS_RP';

    --Start [C20210125-000207] 40사업부 Unit Price Measure 추가
    INSERT INTO SCM_MGR.GT_DMF0049_RESULTS_MST_PRICE
        ( ACTIVE_FLAG, RESULT_MONTH, DIVISION_ID, VERSION_NO, DATA_SEQ
        , DEPARTMENT_ID, DEPT_ID, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE
        , SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID, PRODUCT_DETAILS, CURRENCY
        , COMPANY_ID, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE
        , PROJECT_CODE, SCM_SITE_ID, FCST_TYPE, CELL_MODEL_INFO, CELL_MODEL
        , MEASURE, YYYYMMDD, SALESAMT_LOC, RTF_SYS_RP, CREATED_BY
        , ITEM_USE, SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER, DEPARTMENT_EDIT_FLAG, T_DEPARTMENT_NAME )
    SELECT ACTIVE_FLAG, RESULT_MONTH, DIVISION_ID, VERSION_NO, DATA_SEQ
         , DEPARTMENT_ID, DEPT_ID, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE
         , SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID, PRODUCT_DETAILS, CURRENCY
         , COMPANY_ID, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE
         , PROJECT_CODE, SCM_SITE_ID, FCST_TYPE, CELL_MODEL_INFO, CELL_MODEL
         , 'LOC' AS MEASURE, YYYYMMDD
         , SUM(CASE WHEN MEASURE = 'SalesAmt_LOC' THEN ROUND(TO_NUMBER(QTY),3) ELSE 0.0 END) AS SALESAMT_LOC
         , SUM(CASE WHEN MEASURE = 'RTF_SYS_RP' THEN ROUND(TO_NUMBER(QTY),3) ELSE 0.0 END) AS RTF_SYS_RP
         , MAX(CREATED_BY) AS CREATED_BY, ITEM_USE, SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER
         , DEPARTMENT_EDIT_FLAG, T_DEPARTMENT_NAME
    FROM SCM_MGR.GT_DMF0049_RESULTS_MST
    WHERE MEASURE IN ('SalesAmt_LOC','RTF_SYS_RP')
      AND DIVISION_ID = '40'
    GROUP BY ACTIVE_FLAG, RESULT_MONTH, DIVISION_ID, VERSION_NO, DATA_SEQ
         , DEPARTMENT_ID, DEPT_ID, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE
         , SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID, PRODUCT_DETAILS, CURRENCY
         , COMPANY_ID, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE
         , PROJECT_CODE, SCM_SITE_ID, FCST_TYPE, CELL_MODEL_INFO, CELL_MODEL
         , YYYYMMDD, ITEM_USE, SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER
         , DEPARTMENT_EDIT_FLAG, T_DEPARTMENT_NAME;

    INSERT INTO SCM_MGR.GT_DMF0049_RESULTS_MST
        ( ACTIVE_FLAG, RESULT_MONTH, DIVISION_ID, VERSION_NO, DATA_SEQ
        , DEPARTMENT_ID, DEPT_ID, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE
        , SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID, PRODUCT_DETAILS, CURRENCY
        , COMPANY_ID, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE
        , PROJECT_CODE, SCM_SITE_ID, FCST_TYPE, CELL_MODEL_INFO, CELL_MODEL
        , MEASURE, YYYYMMDD, QTY, CREATED_BY, ITEM_USE
        , SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER, DEPARTMENT_EDIT_FLAG, T_DEPARTMENT_NAME )
    SELECT ACTIVE_FLAG, RESULT_MONTH, DIVISION_ID, VERSION_NO, DATA_SEQ
         , DEPARTMENT_ID, DEPT_ID, CUST_REPORT, END_CUST_REPORT, SOLDTO_CODE
         , SOLDTO_CUST_REPORT, PRODUCT_GROUP, ITEM_ID, PRODUCT_DETAILS, CURRENCY
         , COMPANY_ID, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE
         , PROJECT_CODE, SCM_SITE_ID, FCST_TYPE, CELL_MODEL_INFO, CELL_MODEL
         , MEASURE, YYYYMMDD
         , TO_CHAR(CASE WHEN NVL(RTF_SYS_RP, 0) = 0 THEN 0 ELSE SALESAMT_LOC / RTF_SYS_RP END) AS QTY
         , CREATED_BY, ITEM_USE
         , SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER, DEPARTMENT_EDIT_FLAG, T_DEPARTMENT_NAME
    FROM SCM_MGR.GT_DMF0049_RESULTS_MST_PRICE
    WHERE NVL(RTF_SYS_RP, 0) != 0;
    --End [C20210125-000207]

    -- yyyymm 값을 월별 첫 영업일(yyyymmdd)로 변환
    UPDATE SCM_MGR.GT_DMF0049_RESULTS_MST A
    SET A.YYYYMMDD = ( SELECT MIN(BASIS_START_DATE) FROM SCM_SYS_CALENDAR_M C
                       WHERE SUBSTR(C.BASIS_YYYYMMDD,1,6) = SUBSTR(A.YYYYMMDD,1,6)
                       AND C.DAYOFWEEK IN ('MON','TUE','WED','THU','FRI') );

    -- 폼에서 result_month 는 실적 편집 시에만 넘김. division/version/result_month 대표값
    BEGIN
        SELECT DIVISION_ID, VERSION_NO, RESULT_MONTH
          INTO v_division_id, v_version_no, v_result_month
        FROM SCM_MGR.GT_DMF0049_RESULTS_MST WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN v_division_id := NULL; v_version_no := NULL; v_result_month := NULL;
    END;

    -----------------------------------------------------------------------------------------------------------------------
    --[E20250418-001567]_저장 시 VALIDATION (Sales Report 테이블 기준 중복 검증)
    -----------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_chk FROM (
        SELECT A.VERSION_NO
          FROM DM_PLN_SALES_ETC_REPORT_C A
          INNER JOIN SCM_MGR.GT_DMF0049_RESULTS_MST B
                  ON A.VERSION_NO = B.VERSION_NO
                 AND A.DIVISION_ID = B.DIVISION_ID
                 AND A.DEPARTMENT_ID = B.DEPARTMENT_ID
                 AND A.DEPT_ID = B.DEPT_ID
                 AND A.ITEM_ID = B.ITEM_ID
                 AND A.MEASURE = B.MEASURE
                 AND A.YYYYMMDD = B.YYYYMMDD
                 AND A.CURRENCY = B.CURRENCY
                 AND A.COMPANY_ID = B.COMPANY_ID
                 AND A.END_CUST_REPORT = B.END_CUST_REPORT
                 AND A.CUST_REPORT = B.CUST_REPORT
                 AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                 AND A.COUNTRY_CODE = B.COUNTRY_CODE
         WHERE A.DIVISION_ID = v_division_id
           AND A.VERSION_NO = v_version_no
           AND ( (B.ACTIVE_FLAG != 'D') OR (NVL(TO_NUMBER(B.QTY),0) > 0) )
         GROUP BY A.VERSION_NO, A.DIVISION_ID, A.DEPARTMENT_ID, A.DEPT_ID, A.ITEM_ID
                , A.MEASURE, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.END_CUST_REPORT
                , A.CUST_REPORT, A.PRODUCT_GROUP, SCM_MGR.FN_GET_COUNTRY_KR_NAME(A.COUNTRY_CODE)
        HAVING COUNT(*) > 1
    );
    IF v_chk > 0 THEN
        ROLLBACK;
        v_dup_msg := 'GDW에 데이터를 전송할때는 Sales Report에 ETC Report가 포함되어 전송됩니다. Sales Report 테이블 기준으로 중복되는 값이 발생했습니다.' || CHR(10)
                  || '데이터 저장 시 중복되지 않아야하는 값은' || CHR(10)
                  || 'Division, Department, Team, Model, Measure, YYYYMM, Currency, Company Id, End Cust.(Report), Cust. (Report), Product Gr.(Report), Country Name' || CHR(10)
                  || '저장하시려는 데이터를 다시 한번 확인하시기 바랍니다.';
        V_LOG_TYPE := 'DUPICATION_INVALID'; V_LOG_MESSAGE := '데이터 저장 시 중복값이 발생했습니다. '; V_LOG_DESCRIPTION := ''; D_EVENT_DATE := SYSDATE;
        SCM_MGR.PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESCRIPTION, D_EVENT_DATE, p_created_by);
        LOG_END;
        OPEN O_RESULT_CURSOR FOR SELECT v_dup_msg AS MSG FROM DUAL;
        RETURN;
    END IF;

    -- cutoff 정보
    BEGIN
        SELECT B.YYYYMMDD, A.VERSION_TYPE
          INTO v_cutoff_yyyymmdd, v_cutoff_type
        FROM DM_MDF_VERSION A
        JOIN DM_MST_VERSION B ON A.DIVISION_ID = B.DIVISION_ID AND A.ORI_CUTOFF_VERSION_NO = B.VERSION_NO
        WHERE A.VERSION_NO = v_version_no AND A.DIVISION_ID = v_division_id AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN v_cutoff_yyyymmdd := NULL; v_cutoff_type := NULL;
    END;

    -- INPUT COUNT 확인
    SELECT COUNT(ACTIVE_FLAG) INTO n_input_count FROM SCM_MGR.GT_DMF0049_RESULTS_MST;

    -----------------------------------------------------------------------------------------------------------------------
    -- DM_PLN_SALES_ETC_REPORT_C 테이블 DELETE (ACTIVE_FLAG='D')
    -----------------------------------------------------------------------------------------------------------------------
    DELETE FROM DM_PLN_SALES_ETC_REPORT_C A
    WHERE EXISTS ( SELECT 1 FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
                   WHERE A.VERSION_NO = B.VERSION_NO
                     AND A.DIVISION_ID = B.DIVISION_ID
                     AND TO_CHAR(A.DATA_SEQ) = B.DATA_SEQ
                     AND A.MEASURE = B.MEASURE
                     AND A.YYYYMMDD = B.YYYYMMDD
                     AND B.ACTIVE_FLAG = 'D' );
    n_delete_count := SQL%ROWCOUNT;

    -- 아래서 다시 ACTIVE_FLAG 를 사용하지 않도록 지운다.
    DELETE FROM SCM_MGR.GT_DMF0049_RESULTS_MST WHERE ACTIVE_FLAG = 'D';

    -----------------------------------------------------------------------------------------------------------------------
    -- DM_PLN_SALES_ETC_REPORT_C 테이블 UPDATE (수량만)
    -----------------------------------------------------------------------------------------------------------------------
    UPDATE DM_PLN_SALES_ETC_REPORT_C A
    SET A.QTY = ( SELECT MAX(TO_NUMBER(B.QTY)) FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
                  WHERE A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID
                    AND TO_CHAR(A.DATA_SEQ) = B.DATA_SEQ AND A.MEASURE = B.MEASURE AND A.YYYYMMDD = B.YYYYMMDD )
    WHERE EXISTS ( SELECT 1 FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
                   WHERE A.VERSION_NO = B.VERSION_NO AND A.DIVISION_ID = B.DIVISION_ID
                     AND TO_CHAR(A.DATA_SEQ) = B.DATA_SEQ AND A.MEASURE = B.MEASURE AND A.YYYYMMDD = B.YYYYMMDD );

    -- 2021.08.28 추가된 컬럼 적용
    INSERT INTO SCM_MGR.GT_DMF0049_TEMP_ITEM_SINGLE
        ( ITEM_ID, ITEM_CLASS_NAME, ENERGY, CELL_QUANTITY, FORECAST_INFO_BIZ_TYPE
        , FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT )
    SELECT DISTINCT ITEM_ID, ITEM_CLASS_NAME
         , CASE WHEN REGEXP_LIKE(ENERGE, '^\d+\.?\d*$') THEN TO_NUMBER(ENERGE) ELSE 0 END AS ENERGY
         , CASE WHEN REGEXP_LIKE(CELL_QUANTITY, '^\d+\.?\d*$') THEN TO_NUMBER(CELL_QUANTITY) ELSE 0 END AS CELL_QUANTITY
         , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
    FROM DM_MST_ITEM_SINGLE_V
    WHERE DIVISION_ID = p_division_id;

    -- 1~3 담당 외 기타 부서코드
    BEGIN
        SELECT SEGMENT1, SEGMENT2 INTO v_etc_department_id, v_etc_department_name
        FROM SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE LOOKUP_TYPE = 'MDF_DEPARTMENT' AND SEGMENT3 = 'Y' AND ATTRIBUTE1 = 'Y' AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN v_etc_department_id := NULL; v_etc_department_name := NULL;
    END;

    -- #results_MST 부가정보 갱신 (원본 UPDATE..FROM → 상관 서브쿼리)
    UPDATE SCM_MGR.GT_DMF0049_RESULTS_MST A
    SET A.OWNER_NAME = ( SELECT SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(B.OWNER, ',', 'KO') FROM SCM_MST_SITE_ITEM B
                          WHERE A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND ROWNUM = 1 )
      , A.CUST_GROUP_DTL = ( SELECT B.CUST_GROUP_DTL FROM SCM_MST_SITE_ITEM B
                          WHERE A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND ROWNUM = 1 )
      , A.ROUTE = ( SELECT B.ROUTE FROM SCM_MST_SITE_ITEM B
                          WHERE A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND ROWNUM = 1 )
      , A.FORECAST_INFO_SPEC = ( SELECT C.FORECAST_INFO_SPEC FROM SCM_MGR.GT_DMF0049_TEMP_ITEM_SINGLE C WHERE A.ITEM_ID = C.ITEM_ID AND ROWNUM = 1 )
      , A.NICK_NAME = ( SELECT NVL((SELECT LK3.ATTRIBUTE1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK3
                                     WHERE A.DIVISION_ID = LK3.SEGMENT1 AND A.ITEM_ID = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_SR_ETC_MODEL' AND ROWNUM = 1),
                                    C.NICK_NAME) FROM SCM_MGR.GT_DMF0049_TEMP_ITEM_SINGLE C WHERE A.ITEM_ID = C.ITEM_ID AND ROWNUM = 1 )
      , A.FORECAST_INFO_CELL_PACK_COUNT = ( SELECT NVL((SELECT CASE WHEN REGEXP_LIKE(LK3.ATTRIBUTE2,'^\d+\.?\d*$') THEN LK3.ATTRIBUTE2 ELSE '0' END FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK3
                                     WHERE A.DIVISION_ID = LK3.SEGMENT1 AND A.ITEM_ID = LK3.SEGMENT2 AND LK3.LOOKUP_TYPE = 'DM_SR_ETC_MODEL' AND ROWNUM = 1),
                                    C.FORECAST_INFO_CELL_PACK_COUNT) FROM SCM_MGR.GT_DMF0049_TEMP_ITEM_SINGLE C WHERE A.ITEM_ID = C.ITEM_ID AND ROWNUM = 1 )
      , A.COMPANY_NAME = ( SELECT D.SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL D WHERE A.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'DM_COMPANY' AND ROWNUM = 1 )
      , A.COUNTRY_KR_NAME = ( SELECT F.COUNTRY_KR_NAME FROM SCM_MST_COUNTRY F WHERE A.COUNTRY_CODE = F.COUNTRY AND ROWNUM = 1 )
      , A.DEPARTMENT_NAME = CASE WHEN p_division_id = '40' AND NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK1 WHERE A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND LK1.SEGMENT3='Y') THEN v_etc_department_name
                                 WHEN A.DEPARTMENT_EDIT_FLAG = 'true'  THEN ( SELECT LK1.SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK1 WHERE A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND LK1.SEGMENT3='Y' AND ROWNUM=1 )
                                 WHEN A.DEPARTMENT_EDIT_FLAG = 'false' THEN A.T_DEPARTMENT_NAME
                                 WHEN A.DEPARTMENT_EDIT_FLAG IS NULL OR A.T_DEPARTMENT_NAME IS NULL THEN ''
                            END
      , A.DEPT_NAME = CASE WHEN p_division_id = '40' AND NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK1 WHERE A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND LK1.SEGMENT3='Y') THEN v_etc_department_name
                           ELSE ( SELECT LK2.SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK2 WHERE A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND ROWNUM=1 )
                      END;

    -----------------------------------------------------------------------------------------------------------------------
    -- UPDATE 대상(DATA_SEQ 존재): 동일 년월/메저 삭제 후 인서트
    -----------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_chk FROM SCM_MGR.GT_DMF0049_RESULTS_MST WHERE DATA_SEQ IS NOT NULL AND ROWNUM = 1;
    IF v_chk > 0 THEN
        DELETE FROM DM_PLN_SALES_ETC_REPORT_C A
        WHERE A.DIVISION_ID = v_division_id
          AND A.VERSION_NO = v_version_no
          AND EXISTS ( SELECT 1 FROM SCM_MGR.GT_DMF0049_RESULTS_MST B
                       WHERE TO_CHAR(A.DATA_SEQ) = B.DATA_SEQ
                         AND A.FCST_TYPE = B.FCST_TYPE
                         AND A.MEASURE = B.MEASURE
                         AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD, 1, 6) || '%' );

        INSERT INTO DM_PLN_SALES_ETC_REPORT_C
        ( VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE
        , SOLDTO_CUST_REPORT, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME
        , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, ITEM_USE, SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER, INCOTERMS, MEASURE
        , PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
        , ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, OWNER_NAME
        , CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE, DEPARTMENT_NAME, DEPT_NAME )
        SELECT A.VERSION_NO, A.DIVISION_ID, TO_NUMBER(A.DATA_SEQ), v_cutoff_type, v_cutoff_yyyymmdd, A.DEPARTMENT_ID, A.DEPT_ID, A.END_CUST_REPORT, A.CUST_REPORT, A.SOLDTO_CODE
        , A.SOLDTO_CUST_REPORT, A.PRODUCT_DETAILS, A.CELL_MODEL_INFO, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.PRODUCT_GROUP, A.PROJECT_CODE, '' AS PROJECT_NAME
        , A.SCM_SITE_ID, A.ITEM_ID, '' AS DOM_EXP, A.FCST_TYPE, A.ITEM_USE, A.SOLDTO_COUNTRY, A.SHIPTO_COUNTRY, A.END_CUSTOMER, '' AS INCOTERMS, A.MEASURE
        , '' AS PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, TO_NUMBER(A.QTY), v_log_user, SYSDATE, v_log_user, SYSDATE, '' AS ATTRIBUTE1
        , '' AS ATTRIBUTE2, NVL(A.CELL_MODEL,'') AS ATTRIBUTE3, '', '', '', '', '', '', '', A.OWNER_NAME
        , A.CUST_GROUP_DTL, A.FORECAST_INFO_SPEC, A.NICK_NAME, A.FORECAST_INFO_CELL_PACK_COUNT, A.COMPANY_NAME, A.COUNTRY_KR_NAME, A.ROUTE, A.DEPARTMENT_NAME, A.DEPT_NAME
        FROM SCM_MGR.GT_DMF0049_RESULTS_MST A
        WHERE A.DATA_SEQ IS NOT NULL
          AND A.ACTIVE_FLAG <> 'D';
    END IF;

    -----------------------------------------------------------------------------------------------------------------------
    -- INSERT 대상(DATA_SEQ 미존재): DATA_SEQ 채번 후 인서트
    -----------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO v_chk FROM SCM_MGR.GT_DMF0049_RESULTS_MST WHERE DATA_SEQ IS NULL AND ROWNUM = 1;
    IF v_chk > 0 THEN
        SELECT NVL(MAX(DATA_SEQ), 1) INTO v_max_seq FROM DM_PLN_SALES_ETC_REPORT_C
        WHERE DIVISION_ID = v_division_id AND VERSION_NO = v_version_no;

        INSERT INTO DM_PLN_SALES_ETC_REPORT_C
        ( VERSION_NO, DIVISION_ID, DATA_SEQ, CUTOFF_TYPE, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT, SOLDTO_CODE
        , SOLDTO_CUST_REPORT, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE, APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE, PROJECT_NAME
        , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, ITEM_USE, SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER, INCOTERMS, MEASURE
        , PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
        , ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, OWNER_NAME
        , CUST_GROUP_DTL, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_PACK_COUNT, COMPANY_NAME, COUNTRY_KR_NAME, ROUTE, DEPARTMENT_NAME, DEPT_NAME )
        SELECT A.VERSION_NO, A.DIVISION_ID
             , DENSE_RANK() OVER ( ORDER BY A.DEPARTMENT_ID, A.DEPT_ID, A.CUST_REPORT, A.END_CUST_REPORT
                                          , A.SOLDTO_CODE, A.SOLDTO_CUST_REPORT, A.PRODUCT_GROUP, A.ITEM_ID, A.PRODUCT_DETAILS, A.CURRENCY
                                          , A.COMPANY_ID, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.ITEM_USE, A.SOLDTO_COUNTRY, A.SHIPTO_COUNTRY, A.END_CUSTOMER ) + v_max_seq AS DATA_SEQ
             , v_cutoff_type, v_cutoff_yyyymmdd, A.DEPARTMENT_ID, A.DEPT_ID, A.END_CUST_REPORT, A.CUST_REPORT, A.SOLDTO_CODE
             , A.SOLDTO_CUST_REPORT, A.PRODUCT_DETAILS, A.CELL_MODEL_INFO, A.BIZ_TYPE, A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.PRODUCT_GROUP, A.PROJECT_CODE, '' AS PROJECT_NAME
             , A.SCM_SITE_ID, A.ITEM_ID, '' AS DOM_EXP, A.FCST_TYPE, A.ITEM_USE, A.SOLDTO_COUNTRY, A.SHIPTO_COUNTRY, A.END_CUSTOMER, '' AS INCOTERMS, A.MEASURE
             , '' AS PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, TO_NUMBER(A.QTY), v_log_user, SYSDATE, v_log_user, SYSDATE, '' AS ATTRIBUTE1
             , '' AS ATTRIBUTE2, NVL(A.CELL_MODEL,'') AS ATTRIBUTE3, '', '', '', '', '', '', '', A.OWNER_NAME
             , A.CUST_GROUP_DTL, A.FORECAST_INFO_SPEC, A.NICK_NAME, A.FORECAST_INFO_CELL_PACK_COUNT, A.COMPANY_NAME, A.COUNTRY_KR_NAME, A.ROUTE, A.DEPARTMENT_NAME, A.DEPT_NAME
        FROM SCM_MGR.GT_DMF0049_RESULTS_MST A
        WHERE A.DATA_SEQ IS NULL;
    END IF;

    -----------------------------------------------------------------------------------------------------------------------
    --[E20250418-001567]_HISTORY 데이터 적재
    -----------------------------------------------------------------------------------------------------------------------
    INSERT INTO DM_PLN_SALES_ETC_REPORT_H
    ( VERSION_NO, DIVISION_ID, HISTORY_SEQ, DATA_SEQ, CUTOFF_TYPE
    , CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, CUST_REPORT
    , SOLDTO_CODE, SOLDTO_CUST_REPORT, PRODUCT_DETAILS, CELL_MODEL_INFO, BIZ_TYPE
    , APPLICATION_GR, APPLICATION, COUNTRY_CODE, PRODUCT_GROUP, PROJECT_CODE
    , PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
    , SOLDTO_COUNTRY, SHIPTO_COUNTRY, END_CUSTOMER, INCOTERMS, MEASURE
    , PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID, ITEM_USE
    , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
    , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_NAME
    , COUNTRY_KR_NAME, CUST_GROUP_DTL, DEPARTMENT_NAME, DEPT_NAME, FORECAST_INFO_CELL_PACK_COUNT
    , FORECAST_INFO_SPEC, NICK_NAME, OWNER_NAME, ROUTE )
    SELECT A.VERSION_NO, A.DIVISION_ID, SCM_MGR.SEQ1_DM_PLN_SALES_ETC_REPORT_H.NEXTVAL, A.DATA_SEQ, A.CUTOFF_TYPE
         , A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPT_ID, A.END_CUST_REPORT, A.CUST_REPORT
         , A.SOLDTO_CODE, A.SOLDTO_CUST_REPORT, A.PRODUCT_DETAILS, A.CELL_MODEL_INFO, A.BIZ_TYPE
         , A.APPLICATION_GR, A.APPLICATION, A.COUNTRY_CODE, A.PRODUCT_GROUP, A.PROJECT_CODE
         , A.PROJECT_NAME, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
         , A.SOLDTO_COUNTRY, A.SHIPTO_COUNTRY, A.END_CUSTOMER, A.INCOTERMS, A.MEASURE
         , A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.COMPANY_ID, A.ITEM_USE
         , A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
         , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
         , A.COMPANY_NAME, A.COUNTRY_KR_NAME, A.CUST_GROUP_DTL, A.DEPARTMENT_NAME, A.DEPT_NAME
         , A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_SPEC, A.NICK_NAME, A.OWNER_NAME, A.ROUTE
    FROM DM_PLN_SALES_ETC_REPORT_C A
    INNER JOIN SCM_MGR.GT_DMF0049_RESULTS_MST B
            ON A.VERSION_NO = B.VERSION_NO
           AND A.DIVISION_ID = B.DIVISION_ID
           AND TO_CHAR(A.DATA_SEQ) = B.DATA_SEQ
           AND A.MEASURE = B.MEASURE
           AND A.YYYYMMDD = B.YYYYMMDD;

    -- UPDATE 후에 전송처리를 다시 한다.
    SELECT COUNT(*) INTO v_chk FROM DM_MDF_VERSION
     WHERE DIVISION_ID = v_division_id AND VERSION_NO = v_version_no AND SEND_YN = 'Y' AND ROWNUM = 1;
    IF v_chk > 0 THEN
        PKG_DMF0044.P_DMF0044_MOBILE_REPORT_CREATE(v_division_id, v_version_no, v_cutoff_type, 'T', v_log_user, O_RESULT_CURSOR);
    END IF;

    COMMIT;

    -- 수행결과 성공
    IF O_RESULT_CURSOR IS NULL OR NOT O_RESULT_CURSOR%ISOPEN THEN
        OPEN O_RESULT_CURSOR FOR SELECT 'success' AS MSG FROM DUAL;
    END IF;

    -- 종료 LOG
    LOG_END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE        := 'ERROR';
        V_LOG_MESSAGE     := 'EXCEPTION';
        V_LOG_DESCRIPTION := '';
        D_EVENT_DATE      := SYSDATE;
        V_SQL_CODE        := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG      := SQLERRM;
        V_PROC_INPUT      := JSON_OBJECT(
            'p_division_id' VALUE p_division_id,
            'p_version_no'  VALUE p_version_no,
            'p_created_by'  VALUE p_created_by
        );
        V_BACKTRACE       := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_LOG_DESCRIPTION, D_EVENT_DATE, v_log_user,
                V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0049_SAVE_SALES_ETC_REPORT_C;

END PKG_DMF0049;
/
