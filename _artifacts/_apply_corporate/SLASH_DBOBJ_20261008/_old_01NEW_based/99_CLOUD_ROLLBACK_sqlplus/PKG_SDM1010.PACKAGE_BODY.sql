-- [E20261008-SLASHOBJ] PACKAGE BODY PKG_SDM1010 — 원복(사내 적용 전 원문)
CREATE OR REPLACE PACKAGE BODY           "PKG_SDM1010" AS
/*
 * Program ID   : PKG_SDM1010
 * Description  : Project Registration
 * Parameter    : NONE
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ            최초 작성
 *                             프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

PROCEDURE P_SDM1010_GET_TAB1_PJT_REG (
    P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , P_SES_MENU_ID               IN VARCHAR2
  , P_SES_USER_GR_ID            IN VARCHAR2     -- 권한 그룹

  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010
 * Description  : Project Registration
 * Parameter    : NONE
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ         최초 작성
 *                          프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100  CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
    n_log_count         PLS_INTEGER := 0;
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;


BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    OPEN O_CURSOR FOR
        SELECT PJM.DPJT_KEY, PJM.DPJT_CODE, PJM.DPJT_SEQ
             , PJM.DIVISION_ID, DIV.DIVISION_ID DIVISION_NAME
             , PJM.DPJT_CLASS, PCL.DPJT_CLASS_NAME
             , PJM.END_CUSTOMER, NVL(EDC.END_CUSTOMER_NAME, PJM.END_CUSTOMER) END_CUSTOMER_NAME
             , PJM.DPJT_NAME
             , PJM.CELL_TYPE, CLT.CELL_TYPE_NAME
             , PJM.STACK_METHOD, SMD.STACK_METHOD_NAME
             , PJM.BIZ_TYPE, BIZ.BIZ_TYPE_NAME
             , PJM.SOP_DATE
             , PJM.SOP_PLANT_ID, PLT.SOP_PLANT_NAME
             , '권한등록' AS DPJT_ATUH_REG_STR
             --, CASE WHEN NVL(USM.AUTH_CNT, 0) = 0 THEN 'WRITING' ELSE 'COMPLETE' END DPJT_ATUH_REG_STATUS
             , ARS.DPJT_ATUH_REG_STATUS
             , ARS.DPJT_ATUH_REG_STATUS_NAME
             , ARS.DPJT_ATUH_REG_STATUS_COLOR_TYPE
             , USR.DEPT_ID, DPT.DEPT_NAME_KO DEPT_NAME, DPT.DEPT_NAME_KO, DPT.DEPT_NAME_EN, DPT.DEPT_NAME_CN
             , PJM.MGMT_USER_ID, USR.USER_NAME, USR.USER_NAME_EN
             , PJM.DPJT_REG_STATUS, RGS.DPJT_REG_STATUS_NAME, RGS.DPJT_REG_STATUS_COLOR_TYPE
             , PJM.REG_REQ_DATE
          FROM SCM_MGR.SPMS_PROJECT_MST PJM
          LEFT JOIN
         --INNER JOIN
               SCM_MGR.SCM_MST_DIVISION DIV
            ON 0 = 0
           AND PJM.DIVISION_ID = DIV.DIVISION_ID
         INNER JOIN
               (
                    SELECT LKD.SEGMENT1 AS DPJT_CLASS_ID
                         , LKD.SEGMENT2 AS DPJT_CLASS_NAME
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_DPJT_CLASS'
                       AND LKM.VALID_YN = 'Y'
               ) PCL
            ON 0 = 0
           AND PJM.DPJT_CLASS = PCL.DPJT_CLASS_ID
          LEFT OUTER JOIN
               (
                    SELECT DISTINCT
                           SIT.DIVISION_ID, SIT.END_CUSTOMER, SIT.END_CUSTOMER END_CUSTOMER_NAME
                      FROM SCM_MGR.SCM_MST_SITE SIT
                     WHERE 0 = 0
               ) EDC
            ON 0 = 0
           AND PJM.DIVISION_ID  = EDC.DIVISION_ID
           AND PJM.END_CUSTOMER = EDC.END_CUSTOMER
          LEFT JOIN
         --INNER JOIN
               (
                    SELECT LKD.SEGMENT1 AS DIVISION_ID
                         , LKD.SEGMENT2 AS CELL_TYPE
                         , LKD.SEGMENT3 AS CELL_TYPE_NAME
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_CELL_TYPE'
                       AND LKM.VALID_YN = 'Y'
               ) CLT
            ON 0 = 0
           AND PJM.DIVISION_ID  = CLT.DIVISION_ID
           AND PJM.CELL_TYPE    = CLT.CELL_TYPE
          LEFT JOIN
         --INNER JOIN
               (
                    SELECT LKD.SEGMENT1 AS DIVISION_ID
                         , LKD.SEGMENT2 AS CELL_TYPE
                         , LKD.SEGMENT4 AS STACK_METHOD
                         , LKD.SEGMENT5 AS STACK_METHOD_NAME
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_CELL_STACK_METHOD'
                       AND LKM.VALID_YN = 'Y'
               ) SMD
            ON 0 = 0
           AND PJM.DIVISION_ID  = SMD.DIVISION_ID
           AND PJM.STACK_METHOD = SMD.STACK_METHOD
          LEFT JOIN
         --INNER JOIN
               (
                    SELECT LKD.SEGMENT1 AS BIZ_TYPE
                         , LKD.SEGMENT2 AS BIZ_TYPE_NAME
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'DM_BIZ_TYPE'
                       AND LKM.VALID_YN = 'Y'
               ) BIZ
            ON 0 = 0
           AND PJM.BIZ_TYPE     = BIZ.BIZ_TYPE
          LEFT OUTER JOIN
               (
                    SELECT DISTINCT
                           SIT.DIVISION_ID, SIT.SCM_SITE_ID SOP_PLANT_ID, SIT.SCM_SITE_ID SOP_PLANT_NAME
                      FROM SCM_MGR.SCM_MST_SITE SIT
                     WHERE 0 = 0
                       AND SIT.SITE_TYPE = 'PLANT'
               ) PLT
            ON 0 = 0
           AND PJM.DIVISION_ID  = PLT.DIVISION_ID
           AND PJM.SOP_PLANT_ID = PLT.SOP_PLANT_ID
          LEFT OUTER JOIN
               (
                    SELECT USM.DPJT_KEY, COUNT(USM.USER_ID) AUTH_CNT
                      FROM SCM_MGR.SPMS_PROJECT_USER_MAP USM
                     WHERE 0 = 0
                       -- 권한 등록 상태만 조회
                       -- Admin 제외
                       AND USM.DPJT_AUTH_STATUS = 'CONFIRM'
                       AND USM.DPJT_AUTH_TYPE   IN ('WRITE', 'READ')
                     GROUP BY USM.DPJT_KEY
               ) USM
            ON 0 = 0
           AND PJM.DPJT_KEY  = USM.DPJT_KEY
          LEFT OUTER JOIN
               (
                    SELECT LKD.SEGMENT1 AS DPJT_ATUH_REG_STATUS
                         , LKD.SEGMENT2 AS DPJT_ATUH_REG_STATUS_NAME
                         , LKD.SEGMENT3 AS DPJT_ATUH_REG_STATUS_COLOR_TYPE
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_DPJT_AUTH_REG_STATUS'
                       AND LKM.VALID_YN = 'Y'
               ) ARS
            ON 0 = 0
           AND CASE WHEN NVL(USM.AUTH_CNT, 0) = 0 THEN 'WRITING' ELSE 'COMPLETE' END = ARS.DPJT_ATUH_REG_STATUS
         INNER JOIN
               SCM_MGR.SCM_MST_SSO_USER_INFO USR
            ON 0 = 0
           AND PJM.MGMT_USER_ID = USR.USER_ID
         INNER JOIN
               SCM_MGR.SCM_MST_SSO_DEPT_INFO DPT
            ON 0 = 0
           AND USR.DEPT_ID = DPT.DEPT_ID
         INNER JOIN
               (
                    SELECT LKD.SEGMENT1 AS DPJT_REG_STATUS
                         , LKD.SEGMENT2 AS DPJT_REG_STATUS_NAME
                         , LKD.SEGMENT3 AS DPJT_REG_STATUS_COLOR_TYPE
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_DPJT_REG_STATUS'
                       AND LKM.VALID_YN = 'Y'
               ) RGS
            ON 0 = 0
           AND PJM.DPJT_REG_STATUS = RGS.DPJT_REG_STATUS
         WHERE 0 = 0
           --
           --AND PJM.DIVISION_ID  = P_SES_DIVISION_ID
           AND PJM.MGMT_USER_ID = P_SES_USER_ID
           -- 작성중/등록요청 만 조회
           --AND PJM.DPJT_REG_STATUS IN ('WRITING', 'WAITING')
           -- 2026.08.24 KTJ : 변경요청 상태 추가
           AND PJM.DPJT_REG_STATUS IN ('WRITING', 'WAITING', 'REQ_MOD')
    ;
    
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_SES_DIVISION_ID'             VALUE P_SES_DIVISION_ID
          , 'P_SES_USER_ID'                 VALUE P_SES_USER_ID
          , 'P_SES_MENU_ID'                 VALUE P_SES_MENU_ID
          , 'P_SES_USER_GR_ID'              VALUE P_SES_USER_GR_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION', '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_GET_TAB1_PJT_REG;

PROCEDURE P_SDM1010_SAVE_TAB1_PJT_REG
(
    P_ACTIVE_FLAG               IN VARCHAR2             -- I(Insert) / D(Delete) / M(Modify)
  , P_DPJT_KEY                  IN VARCHAR2
  , P_DPJT_CODE                 IN VARCHAR2
  , P_DPJT_SEQ                  IN VARCHAR2
  , P_DIVISION_ID               IN VARCHAR2
  , P_DPJT_CLASS                IN VARCHAR2
  , P_END_CUSTOMER              IN VARCHAR2
  , P_DPJT_NAME                 IN VARCHAR2
  , P_CELL_TYPE                 IN VARCHAR2
  , P_STACK_METHOD              IN VARCHAR2
  , P_BIZ_TYPE                  IN VARCHAR2
  , P_SOP_DATE                  IN VARCHAR2
  , P_SOP_PLANT_ID              IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010.P_SDM1010_SAVE_TAB1_PJT_REG
 * Description  : Project Registration
 * Parameter    : PKG_SDM1010.P_SDM1010_SAVE_TAB1_PJT_REG(
                            P_ACTIVE_FLAG, P_DPJT_KEY, P_DPJT_CODE, P_DPJT_SEQ
                          , P_DIVISION_ID, P_DPJT_CLASS, P_END_CUSTOMER, P_DPJT_NAME, P_CELL_TYPE, P_STACK_METHOD, P_BIZ_TYPE, P_SOP_DATE, P_SOP_PLANT_ID
                          , P_USER_ID, O_RESULT_CURSOR)
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ         최초 작성
 *                          프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    V_ACTIVE_FLAG               VARCHAR2(10);
    V_DPJT_KEY                  VARCHAR2(50);
    V_DPJT_CODE                 VARCHAR2(50);
    N_DPJT_SEQ                  NUMBER(20, 0);
    V_DIVISION_ID               VARCHAR2(30);
    V_DPJT_CLASS                VARCHAR2(50);
    V_END_CUSTOMER              VARCHAR2(50);
    V_DPJT_NAME                 VARCHAR2(200);
    V_CELL_TYPE                 VARCHAR2(50);
    V_STACK_METHOD              VARCHAR2(50);
    V_BIZ_TYPE                  VARCHAR2(50);
    D_SOP_DATE                  DATE;
    V_SOP_PLANT_ID              VARCHAR2(50);
    
    N_MAX_CNT                   PLS_INTEGER := 0;
    
    --V_USER_ID                   VARCHAR2(50);
    V_USER_ID                   VARCHAR2(50) := P_SES_USER_ID;
    V_DPJT_REG_STATUS           VARCHAR2(50);
    V_SPMS_DPJT_REG_CAT         VARCHAR2(50);

    --=============================================================================================================
    -- LOG 용 변수 설정
    --=============================================================================================================
    V_LOG_TYPE                  VARCHAR2(30 CHAR);
    N_LOG_COUNT                 PLS_INTEGER := 0;
    V_LOG_MESSAGE               VARCHAR2(1000 CHAR);
    V_DESCRIPTION               VARCHAR2(4000 CHAR);
    D_EVENT_DATE                DATE;
    N_DEL_COUNT                 PLS_INTEGER := 0;
    N_INSERT_COUNT              PLS_INTEGER := 0;
    N_EVENT_COUNT               PLS_INTEGER := 0;
    -- 프로그램명 (로그용)
    V_PROGRAM_NAME          VARCHAR2(150);

    --=============================================================================================================
    -- VALIDATION 변수
    --=============================================================================================================
    V_S_VALIDATION              VARCHAR2(4000 CHAR) := NULL;
    V_S_CODE                    VARCHAR2(50 CHAR)   := NULL;

    --=============================================================================================================
    -- VERSION 변수
    --=============================================================================================================
    v_max_mf_w_version          VARCHAR2(100 CHAR);
    v_max_mf_w_yyyymmdd         VARCHAR2(8 CHAR);
    v_max_sf_w_version          VARCHAR2(100 CHAR);
    v_max_sf_w_yyyymmdd         VARCHAR2(8 CHAR);
    v_cutoff_start              VARCHAR2(8 CHAR);
    v_cutoff_end                VARCHAR2(8 CHAR);

    --=============================================================================================================
    -- EXCEPTION 변수
    --=============================================================================================================
    V_PROC_INPUT                VARCHAR2(4000 CHAR);
    V_BACKTRACE                 VARCHAR2(4000 CHAR);
    V_SQL_CODE                  VARCHAR2(100 CHAR);
    V_SQL_ERRMSG                VARCHAR2(1000 CHAR);

    N_CNT                       NUMBER;

BEGIN
    --[E20260806-DS2] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어 (2026-08-06 사용자 지시)
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    /*
    --=============================================================================================================
    -- GTT TRUNCATE
    --=============================================================================================================
    DELETE FROM SCM_MGR.GT_F021_SALES_PLAN;
    DELETE FROM SCM_MGR.GT_F021_SALES_PLAN_LOC;
    DELETE FROM SCM_MGR.GT_F021_SALES_PLAN_RTF;
    DELETE FROM SCM_MGR.GT_F021_DATA_DUP;
    DELETE FROM SCM_MGR.GT_F021_PRICE_RTF_SYS_RP;
    DELETE FROM SCM_MGR.GT_F021_SALES_PLAN_INSERT;

    -- 당주 월요일 관련 날짜 미리 계산
    v_cutoff_start := TO_CHAR(TRUNC(SYSDATE, 'IW') - 7, 'YYYYMMDD');
    v_cutoff_end   := TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD');
    */

    --=============================================================================================================
    -- 시작 LOG
    --=============================================================================================================
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    
    -- ^ 구분자 row 정보를 테이블 형태로 생성 참고 
    --SELECT * FROM SCM_MGR.UF_FX_STRING_SPLIT('01MDP2949A9B11^02MDP2949A9B11^03MDP2949A9B11^04MDP2949A9B11^05MDP2949A9B11', '^')
    
    -- ^ 구분자로 전달받은 Grid 데이터의 Row 수 추출
    N_MAX_CNT := REGEXP_COUNT(P_ACTIVE_FLAG, '\^') + 1;
    
    DBMS_OUTPUT.PUT_LINE('N_MAX_CNT : ' || TO_CHAR(N_MAX_CNT));
    
    -- Grid Row count Loop
    FOR i IN 1..N_MAX_CNT LOOP
        V_ACTIVE_FLAG       := TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG,        '[^\^]+', 1, i));                   -- I(Insert) / D(Delete) / M(Modify)
        V_DPJT_KEY          := TRIM(REGEXP_SUBSTR(P_DPJT_KEY,           '[^\^]+', 1, i));
        V_DPJT_CODE         := TRIM(REGEXP_SUBSTR(P_DPJT_CODE,          '[^\^]+', 1, i));
        N_DPJT_SEQ          := TO_NUMBER(TRIM(REGEXP_SUBSTR(P_DPJT_SEQ,   '[^\^]+', 1, i)));
        V_DIVISION_ID       := TRIM(REGEXP_SUBSTR(P_DIVISION_ID,        '[^\^]+', 1, i));
        V_DPJT_CLASS        := TRIM(REGEXP_SUBSTR(P_DPJT_CLASS,         '[^\^]+', 1, i));
        V_END_CUSTOMER      := TRIM(REGEXP_SUBSTR(P_END_CUSTOMER,       '[^\^]+', 1, i));
        V_DPJT_NAME         := TRIM(REGEXP_SUBSTR(P_DPJT_NAME,          '[^\^]+', 1, i));
        V_CELL_TYPE         := TRIM(REGEXP_SUBSTR(P_CELL_TYPE,          '[^\^]+', 1, i));
        V_STACK_METHOD      := TRIM(REGEXP_SUBSTR(P_STACK_METHOD,       '[^\^]+', 1, i));
        V_BIZ_TYPE          := TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,           '[^\^]+', 1, i));
        --D_SOP_DATE          := TO_DATE(TRIM(REGEXP_SUBSTR(P_SOP_DATE,   '[^\^]+', 1, i)), 'YYYY-MM-DD HH24:MI:SS');
        D_SOP_DATE          := TO_DATE(SUBSTR(TRIM(REGEXP_SUBSTR(P_SOP_DATE,   '[^\^]+', 1, i)), 1, 10), 'YYYY-MM-DD');
        V_SOP_PLANT_ID      := TRIM(REGEXP_SUBSTR(P_SOP_PLANT_ID,       '[^\^]+', 1, i));
    
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_ACTIVE_FLAG : ' || V_ACTIVE_FLAG);
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_DPJT_NAME : ' || V_DPJT_NAME);
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_DIVISION_ID : ' || V_DIVISION_ID);
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_DPJT_CLASS : ' || V_DPJT_CLASS);
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_END_CUSTOMER : ' || V_END_CUSTOMER);
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_CELL_TYPE : ' || V_CELL_TYPE);
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_STACK_METHOD : ' || V_STACK_METHOD);
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_BIZ_TYPE : ' || V_BIZ_TYPE);
    
        -- 1. 신규 등록
        IF V_ACTIVE_FLAG = 'I' -- I(Insert) / D(Delete) / M(Modify)
            -- 필수항목 조건
        /* 2026.09.01 KTJ : 저장 시 필수값 체크 제외 (등록요청 시 필수값 확인)
            AND ( NVL(V_DPJT_NAME,      '') != '' OR V_DPJT_NAME        IS NOT NULL )
            AND ( NVL(V_DIVISION_ID,    '') != '' OR V_DIVISION_ID      IS NOT NULL )
            AND ( NVL(V_DPJT_CLASS,     '') != '' OR V_DPJT_CLASS       IS NOT NULL )
            AND ( NVL(V_END_CUSTOMER,   '') != '' OR V_END_CUSTOMER     IS NOT NULL )
            AND ( NVL(V_CELL_TYPE,      '') != '' OR V_CELL_TYPE        IS NOT NULL )
            AND ( NVL(V_STACK_METHOD,   '') != '' OR V_STACK_METHOD     IS NOT NULL )
            AND ( NVL(V_BIZ_TYPE,       '') != '' OR V_BIZ_TYPE         IS NOT NULL )
            */
        THEN
            
            DBMS_OUTPUT.PUT_LINE('1. INSERT : ' || TO_CHAR(i));
        
            -- 임시 DPJT_CODE 생성
            -- UI 에서 유니크한 DPJT_CODE 를 생성해서 넘김
            --V_DPJT_CODE := 'TEMP_' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF6');
            N_DPJT_SEQ  := 1;
            V_DPJT_KEY  := V_DPJT_CODE || '_' || TO_CHAR(N_DPJT_SEQ, 'FM000000');
            
            -- 프로젝트 등록 상태 : WRITING
            SELECT LMT.SEGMENT1 INTO V_DPJT_REG_STATUS
              FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LMT
             WHERE LMT.LOOKUP_TYPE = 'SPMS_DPJT_REG_STATUS'
               AND LMT.SEGMENT1 = 'WRITING'
               AND LMT.SEGMENT2 = '작성중'
            ;
            -- 프로젝트 등록 구분 : NEW
            SELECT LMT.SEGMENT1 INTO V_SPMS_DPJT_REG_CAT
              FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LMT
             WHERE LMT.LOOKUP_TYPE = 'SPMS_DPJT_REG_CAT'
               AND LMT.SEGMENT1 = 'NEW'
               AND LMT.SEGMENT2 = '신규'
            ;
        
            INSERT INTO SCM_MGR.SPMS_PROJECT_MST (
                DPJT_KEY, DPJT_CODE, DPJT_SEQ, DPJT_NAME, DIVISION_ID, DPJT_CLASS, END_CUSTOMER, CELL_TYPE, BIZ_TYPE, STACK_METHOD, SOP_DATE, SOP_PLANT_ID
              , MGMT_USER_ID, DPJT_REG_STATUS, REG_REQ_DATE, REG_MOD_DATE, REG_COMP_DATE, DPJT_DEVELOP_STATUS, DPJT_REG_CAT, NOTE
              , DPJT_MGMT_STATUS, DPJT_KEY_PARENT
              , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
            )
            SELECT V_DPJT_KEY DPJT_KEY, V_DPJT_CODE DPJT_CODE, N_DPJT_SEQ DPJT_SEQ
                 , V_DPJT_NAME DPJT_NAME, V_DIVISION_ID DIVISION_ID, V_DPJT_CLASS DPJT_CLASS
                 , V_END_CUSTOMER END_CUSTOMER, V_CELL_TYPE CELL_TYPE, V_BIZ_TYPE BIZ_TYPE, V_STACK_METHOD STACK_METHOD
                 , D_SOP_DATE SOP_DATE, V_SOP_PLANT_ID SOP_PLANT_ID
                 , V_USER_ID MGMT_USER_ID, V_DPJT_REG_STATUS DPJT_REG_STATUS, NULL REG_REQ_DATE, NULL REG_MOD_DATE, NULL REG_COMP_DATE, NULL DPJT_DEVELOP_STATUS
                 , V_SPMS_DPJT_REG_CAT DPJT_REG_CAT, NULL NOTE
                 -- 최초 등록 시 TEMP
                 , 'TEMP' DPJT_MGMT_STATUS, NULL DPJT_KEY_PARENT
                 , V_USER_ID CREATED_BY, SYSDATE CREATION_DATE, V_USER_ID LAST_UPDATED_BY, SYSDATE LAST_UPDATE_DATE
              FROM DUAL
            ;
            
            -- 화면 등록 시 저장한 권한 정보가 있다면 
            -- Project Code 정보 Update
            UPDATE SCM_MGR.SPMS_PROJECT_USER_MAP
               SET DPJT_CODE    = V_DPJT_CODE
                 , DPJT_SEQ     = N_DPJT_SEQ
                 , DPJT_NAME    = V_DPJT_NAME
             WHERE 0 = 0
               AND DPJT_KEY = V_DPJT_KEY
            ;
            
            -- 관리자 권한 저장
             MERGE INTO SCM_MGR.SPMS_PROJECT_USER_MAP SRC
             USING (
                        SELECT PJM.DPJT_KEY
                             , V_USER_ID    AS USER_ID
                             , 'ADMIN'      AS DPJT_AUTH_TYPE   -- 관리자
                             , 'CONFIRM'    AS DPJT_AUTH_STATUS -- 관리자는 자동 승인
                             , PJM.DPJT_CODE
                             , PJM.DPJT_SEQ
                             , PJM.DPJT_NAME
                             , NULL         AS DPJT_AUTH_TYPE_REQ
                          FROM SCM_MGR.SPMS_PROJECT_MST PJM
                         WHERE 0 = 0
                           AND PJM.DPJT_KEY = V_DPJT_KEY
                   ) DAT
                ON (
                        0 = 0
                    AND SRC.DPJT_KEY = DAT.DPJT_KEY
                    AND SRC.USER_ID  = DAT.USER_ID
                   )
              WHEN MATCHED THEN
            UPDATE
               SET SRC.LAST_UPDATED_BY      = DAT.USER_ID
                 , SRC.LAST_UPDATE_DATE     = SYSDATE
                 , SRC.DPJT_AUTH_TYPE       = DAT.DPJT_AUTH_TYPE
                 , SRC.DPJT_AUTH_STATUS     = DAT.DPJT_AUTH_STATUS
                 , SRC.DPJT_CODE            = DAT.DPJT_CODE
                 , SRC.DPJT_SEQ             = DAT.DPJT_SEQ
                 , SRC.DPJT_NAME            = DAT.DPJT_NAME
                 , SRC.DPJT_AUTH_TYPE_REQ   = DAT.DPJT_AUTH_TYPE_REQ
              WHEN NOT MATCHED THEN
            INSERT (
                        DPJT_KEY, USER_ID, DPJT_AUTH_TYPE, DPJT_AUTH_STATUS, DPJT_CODE, DPJT_SEQ, DPJT_NAME, DPJT_AUTH_TYPE_REQ
                      , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                   )
            VALUES (
                        DAT.DPJT_KEY, DAT.USER_ID, DAT.DPJT_AUTH_TYPE, DAT.DPJT_AUTH_STATUS
                      , DAT.DPJT_CODE, DAT.DPJT_SEQ, DAT.DPJT_NAME, DAT.DPJT_AUTH_TYPE_REQ
                      , V_USER_ID, SYSDATE, V_USER_ID, SYSDATE -- CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                   )
            ;
            
            N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;
        END IF;
            
        -- 2. 수정
        IF V_ACTIVE_FLAG = 'M' -- I(Insert) / D(Delete) / M(Modify)
            -- 필수항목 조건
            AND ( NVL(V_DPJT_KEY,       '') != '' OR V_DPJT_KEY         IS NOT NULL )
            AND ( NVL(V_DPJT_CODE,      '') != '' OR V_DPJT_CODE        IS NOT NULL )
            AND N_DPJT_SEQ        IS NOT NULL
        THEN
            DBMS_OUTPUT.PUT_LINE('2. MERGE : ' || TO_CHAR(i));
             MERGE INTO SCM_MGR.SPMS_PROJECT_MST SRC
             USING (
                        SELECT V_DPJT_KEY DPJT_KEY, V_DPJT_CODE DPJT_CODE, N_DPJT_SEQ DPJT_SEQ
                             , V_DPJT_NAME DPJT_NAME, V_DIVISION_ID DIVISION_ID, V_DPJT_CLASS DPJT_CLASS
                             , V_END_CUSTOMER END_CUSTOMER, V_CELL_TYPE CELL_TYPE, V_BIZ_TYPE BIZ_TYPE, V_STACK_METHOD STACK_METHOD
                             , D_SOP_DATE SOP_DATE, V_SOP_PLANT_ID SOP_PLANT_ID
                          FROM DUAL
                   ) DAT
                ON (
                       0 = 0
                   AND SRC.DPJT_KEY = DAT.DPJT_KEY
                   -- 해당 프로젝트의 관리자인 경우만 수정 가능
                   AND SRC.MGMT_USER_ID = V_USER_ID
                   )
              WHEN MATCHED THEN
            UPDATE
               SET SRC.LAST_UPDATED_BY      = V_USER_ID
                 , SRC.LAST_UPDATE_DATE     = SYSDATE
                 --
                 , SRC.DPJT_NAME            = CASE WHEN NVL(SRC.DPJT_NAME, 'X') = NVL(DAT.DPJT_NAME, 'X')           THEN SRC.DPJT_NAME      ELSE DAT.DPJT_NAME      END
                 , SRC.DIVISION_ID          = CASE WHEN NVL(SRC.DIVISION_ID, 'X') = NVL(DAT.DIVISION_ID, 'X')       THEN SRC.DIVISION_ID    ELSE DAT.DIVISION_ID    END
                 , SRC.DPJT_CLASS           = CASE WHEN NVL(SRC.DPJT_CLASS, 'X') = NVL(DAT.DPJT_CLASS, 'X')         THEN SRC.DPJT_CLASS     ELSE DAT.DPJT_CLASS     END
                 , SRC.END_CUSTOMER         = CASE WHEN NVL(SRC.END_CUSTOMER, 'X') = NVL(DAT.END_CUSTOMER, 'X')     THEN SRC.END_CUSTOMER   ELSE DAT.END_CUSTOMER   END
                 , SRC.CELL_TYPE            = CASE WHEN NVL(SRC.CELL_TYPE, 'X') = NVL(DAT.CELL_TYPE, 'X')           THEN SRC.CELL_TYPE      ELSE DAT.CELL_TYPE      END
                 , SRC.BIZ_TYPE             = CASE WHEN NVL(SRC.BIZ_TYPE, 'X') = NVL(DAT.BIZ_TYPE, 'X')             THEN SRC.BIZ_TYPE       ELSE DAT.BIZ_TYPE       END
                 , SRC.STACK_METHOD         = CASE WHEN NVL(SRC.STACK_METHOD, 'X') = NVL(DAT.STACK_METHOD, 'X')     THEN SRC.STACK_METHOD   ELSE DAT.STACK_METHOD   END
                 , SRC.SOP_DATE             = CASE WHEN NVL(SRC.SOP_DATE, SYSDATE) = NVL(DAT.SOP_DATE, SYSDATE)     THEN SRC.SOP_DATE       ELSE DAT.SOP_DATE       END
                 --, SRC.SOP_DATE             = DAT.SOP_DATE
                 , SRC.SOP_PLANT_ID         = CASE WHEN NVL(SRC.SOP_PLANT_ID, 'X') = NVL(DAT.SOP_PLANT_ID, 'X')     THEN SRC.SOP_PLANT_ID   ELSE DAT.SOP_PLANT_ID   END
             WHERE 0 = 0
               -- 수정 내역이 존재해야 저장
               AND NOT (
                        0 = 0
                    AND NVL(SRC.DPJT_NAME, 'X')       = NVL(DAT.DPJT_NAME, 'X')
                    AND NVL(SRC.DIVISION_ID, 'X')     = NVL(DAT.DIVISION_ID, 'X')
                    AND NVL(SRC.DPJT_CLASS, 'X')      = NVL(DAT.DPJT_CLASS, 'X')
                    AND NVL(SRC.END_CUSTOMER, 'X')    = NVL(DAT.END_CUSTOMER, 'X')
                    AND NVL(SRC.CELL_TYPE, 'X')       = NVL(DAT.CELL_TYPE, 'X')
                    AND NVL(SRC.BIZ_TYPE, 'X')        = NVL(DAT.BIZ_TYPE, 'X')
                    AND NVL(SRC.STACK_METHOD, 'X')    = NVL(DAT.STACK_METHOD, 'X')
                    AND NVL(SRC.SOP_DATE, SYSDATE)        = NVL(DAT.SOP_DATE, SYSDATE)
                    AND NVL(SRC.SOP_PLANT_ID, 'X')    = NVL(DAT.SOP_PLANT_ID, 'X')
                   )
            ;
            N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;
        END IF;
            
        -- 3. 삭제
        IF V_ACTIVE_FLAG = 'D' -- I(Insert) / D(Delete) / M(Modify)
            -- 필수항목 조건
            AND ( NVL(V_DPJT_KEY,       '') != '' OR V_DPJT_KEY         IS NOT NULL )
            AND ( NVL(V_DPJT_CODE,      '') != '' OR V_DPJT_CODE        IS NOT NULL )
            AND N_DPJT_SEQ         IS NOT NULL
        THEN
            DBMS_OUTPUT.PUT_LINE('3. DELETE : ' || TO_CHAR(i));
            DELETE
            --SELECT PJT.*
              FROM SCM_MGR.SPMS_PROJECT_MST PJT
             WHERE 0 = 0
               AND PJT.DPJT_KEY = V_DPJT_KEY
               -- 등록 상태가 작성중 인 경우만 삭제 가능
               AND EXISTS (
                        SELECT 1
                          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LMT
                         WHERE 0 = 0
                           AND LMT.LOOKUP_TYPE      = 'SPMS_DPJT_REG_STATUS'
                           AND LMT.SEGMENT1         = 'WRITING' -- 잓성중
                           --AND LMT.SEGMENT2       = '작성중'
                           --
                           AND LMT.SEGMENT1         = PJT.DPJT_REG_STATUS
                   )
            ;
            N_DEL_COUNT := N_DEL_COUNT + SQL%ROWCOUNT;
        END IF;
        
        -- Insert 후 바로 등록 요청하는 경우 V_ACTIVE_FLAG 가 빈 값이 될 수 있음 이때 강제로 수행 건수 올려줌
        IF V_ACTIVE_FLAG IS NULL THEN
            N_EVENT_COUNT := N_EVENT_COUNT + 1;
        END IF;
        
    END LOOP;

    COMMIT;


    N_EVENT_COUNT := N_EVENT_COUNT + N_DEL_COUNT + N_INSERT_COUNT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_EVENT_COUNT) AS EVENT FROM DUAL;

    DBMS_OUTPUT.PUT_LINE('FINISH ');

    RETURN;

    --=============================================================================================================
    -- VALIDATION FAIL 처리
    --=============================================================================================================
    <<VALIDATION_FAIL>>
    ROLLBACK;
    v_log_message := V_S_CODE;
    v_description := V_S_CODE || '^' || V_S_VALIDATION;
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


    OPEN O_RESULT_CURSOR FOR
    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_S_CODE || '^' || V_S_VALIDATION AS EVENT FROM DUAL;
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_ACTIVE_FLAG'     VALUE SUBSTR(P_ACTIVE_FLAG, 1, 200)
          , 'P_DPJT_KEY'        VALUE SUBSTR(P_DPJT_KEY, 1, 200)
          , 'P_DPJT_CODE'       VALUE SUBSTR(P_DPJT_CODE, 1, 200)
          , 'P_DPJT_SEQ'        VALUE SUBSTR(P_DPJT_SEQ, 1, 200)
          , 'P_DIVISION_ID'     VALUE SUBSTR(P_DIVISION_ID, 1, 200)
          , 'P_DPJT_CLASS'      VALUE SUBSTR(P_DPJT_CLASS, 1, 200)
          , 'P_END_CUSTOMER'    VALUE SUBSTR(P_END_CUSTOMER, 1, 200)
          , 'P_DPJT_NAME'       VALUE SUBSTR(P_DPJT_NAME, 1, 200)
          , 'P_CELL_TYPE'       VALUE SUBSTR(P_CELL_TYPE, 1, 200)
          , 'P_STACK_METHOD'    VALUE SUBSTR(P_STACK_METHOD, 1, 200)
          , 'P_BIZ_TYPE'        VALUE SUBSTR(P_BIZ_TYPE, 1, 200)
          , 'P_SOP_DATE'        VALUE SUBSTR(P_SOP_DATE, 1, 200)
          , 'P_SOP_PLANT_ID'    VALUE SUBSTR(P_SOP_PLANT_ID, 1, 200)
          , 'P_SES_USER_ID'     VALUE P_SES_USER_ID
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_SAVE_TAB1_PJT_REG;

PROCEDURE P_SDM1010_BTN_REQ_PJT_REG
(
    P_DIVISION_ID               IN VARCHAR2
  , P_DPJT_KEY                  IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010.P_SDM1010_BTN_REQ_PJT_REG
 * Description  : Project Registration
 * Parameter    : PKG_SDM1010.P_SDM1010_BTN_REQ_PJT_REG(P_DIVISION_ID, P_DPJT_KEY, P_USER_ID, O_RESULT_CURSOR)
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ            최초 작성
 *                             프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    V_DPJT_KEY                  VARCHAR2(50);
    V_DIVISION_ID               VARCHAR2(30);
    
    N_MAX_CNT                   PLS_INTEGER := 0;
    V_USER_ID                   VARCHAR2(50) := P_SES_USER_ID;

    --=============================================================================================================
    -- LOG 용 변수 설정
    --=============================================================================================================
    v_log_type            VARCHAR2(30 CHAR);
    n_log_count           PLS_INTEGER := 0;
    v_log_message         VARCHAR2(1000 CHAR);
    v_description         VARCHAR2(4000 CHAR);
    d_event_date          DATE;
    n_del_count           PLS_INTEGER := 0;
    n_insert_count        PLS_INTEGER := 0;
    n_event_count         PLS_INTEGER := 0;
    -- 프로그램명 (로그용)
    V_PROGRAM_NAME          VARCHAR2(150);

    --=============================================================================================================
    -- VALIDATION 변수
    --=============================================================================================================
    V_S_VALIDATION        VARCHAR2(4000 CHAR) := NULL;
    V_S_CODE              VARCHAR2(50 CHAR)   := NULL;

    --=============================================================================================================
    -- VERSION 변수
    --=============================================================================================================
    v_max_mf_w_version    VARCHAR2(100 CHAR);
    v_max_mf_w_yyyymmdd   VARCHAR2(8 CHAR);
    v_max_sf_w_version    VARCHAR2(100 CHAR);
    v_max_sf_w_yyyymmdd   VARCHAR2(8 CHAR);
    v_cutoff_start        VARCHAR2(8 CHAR);
    v_cutoff_end          VARCHAR2(8 CHAR);

    --=============================================================================================================
    -- EXCEPTION 변수
    --=============================================================================================================
    V_PROC_INPUT          VARCHAR2(4000 CHAR);
    V_BACKTRACE           VARCHAR2(4000 CHAR);
    V_SQL_CODE            VARCHAR2(100 CHAR);
    V_SQL_ERRMSG          VARCHAR2(1000 CHAR);

    N_CNT                 NUMBER;

BEGIN
    --[E20260806-DS2] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어 (2026-08-06 사용자 지시)
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    --=============================================================================================================
    -- 시작 LOG
    --=============================================================================================================
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    
    -- ^ 구분자로 전달받은 Grid 데이터의 Row 수 추출
    N_MAX_CNT := REGEXP_COUNT(P_DIVISION_ID, '\^') + 1;
    
    -- Grid Row count Loop
    FOR i IN 1..N_MAX_CNT LOOP
        V_DPJT_KEY          := TRIM(REGEXP_SUBSTR(P_DPJT_KEY,           '[^\^]+', 1, i));
        V_DIVISION_ID       := TRIM(REGEXP_SUBSTR(P_DIVISION_ID,        '[^\^]+', 1, i));
        
        ----------------------------------------------------------------------------------------------
        BEGIN
        
            -- 필수입력 값 확인
            SELECT 1 INTO N_CNT FROM DUAL
            WHERE EXISTS (
                SELECT 1
                  FROM SCM_MGR.SPMS_PROJECT_MST SRC -- 요청
                 WHERE 0 = 0
                   AND SRC.DPJT_KEY = V_DPJT_KEY
                   --
                   AND (
                            0 = 1
                         OR SRC.DIVISION_ID IS NULL
                         OR SRC.DPJT_NAME IS NULL
                         OR SRC.CELL_TYPE IS NULL
                         OR SRC.STACK_METHOD IS NULL
                         OR SRC.BIZ_TYPE IS NULL
                         OR SRC.SOP_DATE IS NULL
                         OR SRC.SOP_PLANT_ID IS NULL
                       )
            );
            v_log_type    := 'INVALID';
            V_S_CODE      := 'MSG00025';
            V_S_VALIDATION := ' ';
            GOTO VALIDATION_FAIL;
            
            -- Project 중복 체크
            SELECT 1 INTO N_CNT FROM DUAL
            WHERE EXISTS (
                SELECT 1
                  FROM SCM_MGR.SPMS_PROJECT_MST SRC -- 요청 
                 INNER JOIN
                       (
                            SELECT TAR.DPJT_KEY, TAR.DPJT_CODE, TAR.DPJT_SEQ
                                 , TAR.DPJT_NAME, TAR.DIVISION_ID, TAR.END_CUSTOMER, TAR.CELL_TYPE, TAR.BIZ_TYPE, TAR.STACK_METHOD
                              FROM SCM_MGR.SPMS_PROJECT_MST TAR -- 비교
                             WHERE 0 = 0
                               -- 작성중, 반려 제외
                               AND TAR.DPJT_REG_STATUS NOT IN ('WRITING', 'REJECT')
                       ) TAR -- 비교
                    ON 0 = 0
                   AND SRC.DPJT_NAME        = TAR.DPJT_NAME
                   AND SRC.DIVISION_ID      = TAR.DIVISION_ID
                   AND SRC.END_CUSTOMER     = TAR.END_CUSTOMER
                   AND SRC.CELL_TYPE        = TAR.CELL_TYPE
                   AND SRC.BIZ_TYPE         = TAR.BIZ_TYPE
                   AND SRC.STACK_METHOD     = TAR.STACK_METHOD
                   -- 동일 Project Key 는 대상에서 제외
                   AND SRC.DPJT_KEY        != TAR.DPJT_KEY
                 WHERE 0 = 0
                   AND SRC.DPJT_KEY = V_DPJT_KEY
            );
            v_log_type    := 'INVALID';
            V_S_CODE      := 'MSG00060';
            V_S_VALIDATION := ' ';
            GOTO VALIDATION_FAIL;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;
        ----------------------------------------------------------------------------------------------
    
         MERGE INTO SCM_MGR.SPMS_PROJECT_MST SRC
         USING (
                    SELECT V_DPJT_KEY DPJT_KEY, V_DIVISION_ID
                      FROM DUAL
               ) DAT
            ON (
                   0 = 0
               AND SRC.DPJT_KEY = DAT.DPJT_KEY
               )
          WHEN MATCHED THEN
        UPDATE
           SET SRC.LAST_UPDATED_BY      = V_USER_ID
             , SRC.LAST_UPDATE_DATE     = SYSDATE
             --
             , SRC.DPJT_REG_STATUS      = 'WAITING'         -- 승인대기
             , SRC.REG_REQ_DATE         = TRUNC(SYSDATE)    -- 등록 요청일
         WHERE 0 = 0
           -- 작성중(WRITING) 상태만 등록요청 가능
           AND SRC.DPJT_REG_STATUS = 'WRITING'
        ;
        N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;
             
    END LOOP;

    COMMIT;

    N_EVENT_COUNT := N_EVENT_COUNT + N_DEL_COUNT + N_INSERT_COUNT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_EVENT_COUNT) AS EVENT FROM DUAL;

    RETURN;

    --=============================================================================================================
    -- VALIDATION FAIL 처리
    --=============================================================================================================
    <<VALIDATION_FAIL>>
    ROLLBACK;
    v_log_message := V_S_CODE;
    v_description := V_S_CODE || '^' || V_S_VALIDATION;
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


    OPEN O_RESULT_CURSOR FOR
    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_S_CODE || '^' || V_S_VALIDATION AS EVENT FROM DUAL;
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_DIVISION_ID'         VALUE SUBSTR(P_DIVISION_ID, 1, 500)
          , 'P_DPJT_KEY'            VALUE SUBSTR(P_DPJT_KEY, 1, 500)
          , 'P_SES_USER_ID'         VALUE P_SES_USER_ID
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_BTN_REQ_PJT_REG;

PROCEDURE P_SDM1010_BTN_REQ_PJT_REG_MAIN
(
    P_ACTIVE_FLAG               IN VARCHAR2             -- I(Insert) / D(Delete) / M(Modify)
  , P_DPJT_KEY                  IN VARCHAR2
  , P_DPJT_CODE                 IN VARCHAR2
  , P_DPJT_SEQ                  IN VARCHAR2
  , P_DIVISION_ID               IN VARCHAR2
  , P_DPJT_CLASS                IN VARCHAR2
  , P_END_CUSTOMER              IN VARCHAR2
  , P_DPJT_NAME                 IN VARCHAR2
  , P_CELL_TYPE                 IN VARCHAR2
  , P_STACK_METHOD              IN VARCHAR2
  , P_BIZ_TYPE                  IN VARCHAR2
  , P_SOP_DATE                  IN VARCHAR2
  , P_SOP_PLANT_ID              IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010.P_SDM1010_BTN_REQ_PJT_REG_MAIN
 * Description  : Project Registration
 * Parameter    : PKG_SDM1010.P_SDM1010_BTN_REQ_PJT_REG_MAIN(P_DIVISION_ID, P_DPJT_KEY, P_USER_ID, O_RESULT_CURSOR)
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.09.02   KTJ            최초 작성
 *                             프로젝트 등록 - 저장/등록 동시에
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    V_DPJT_KEY                  VARCHAR2(50);
    V_DIVISION_ID               VARCHAR2(30);
    V_DPJT_CODE                 VARCHAR2(50);
    N_DPJT_SEQ                  NUMBER(20);
    
    N_MAX_CNT                   PLS_INTEGER := 0;
    V_USER_ID                   VARCHAR2(50) := P_SES_USER_ID;

    --=============================================================================================================
    -- LOG 용 변수 설정
    --=============================================================================================================
    v_log_type            VARCHAR2(30 CHAR);
    n_log_count           PLS_INTEGER := 0;
    v_log_message         VARCHAR2(1000 CHAR);
    v_description         VARCHAR2(4000 CHAR);
    d_event_date          DATE;
    n_del_count           PLS_INTEGER := 0;
    n_insert_count        PLS_INTEGER := 0;
    n_event_count         PLS_INTEGER := 0;
    -- 프로그램명 (로그용)
    V_PROGRAM_NAME          VARCHAR2(150);

    --=============================================================================================================
    -- VALIDATION 변수
    --=============================================================================================================
    V_S_VALIDATION        VARCHAR2(4000 CHAR) := NULL;
    V_S_CODE              VARCHAR2(50 CHAR)   := NULL;

    --=============================================================================================================
    -- VERSION 변수
    --=============================================================================================================
    v_max_mf_w_version    VARCHAR2(100 CHAR);
    v_max_mf_w_yyyymmdd   VARCHAR2(8 CHAR);
    v_max_sf_w_version    VARCHAR2(100 CHAR);
    v_max_sf_w_yyyymmdd   VARCHAR2(8 CHAR);
    v_cutoff_start        VARCHAR2(8 CHAR);
    v_cutoff_end          VARCHAR2(8 CHAR);

    --=============================================================================================================
    -- EXCEPTION 변수
    --=============================================================================================================
    V_PROC_INPUT          VARCHAR2(4000 CHAR);
    V_BACKTRACE           VARCHAR2(4000 CHAR);
    V_SQL_CODE            VARCHAR2(100 CHAR);
    V_SQL_ERRMSG          VARCHAR2(1000 CHAR);

    N_CNT                 NUMBER;
    
    --=============================================================================================================
    -- SP 호출 후 결과 확인을 위한 변수
    --=============================================================================================================
    -- 프로시저 리턴 커서
    V_SAVE_RESULT_CURSOR    SYS_REFCURSOR;
    
    -- 커서 값 확인을 위한 변수 선언 (CODE, MSG, EVENT)
    V_CODE                  VARCHAR2(10);
    V_MSG                   VARCHAR2(4000);
    V_EVENT                 VARCHAR2(100);
    

BEGIN
    --[E20260806-DS2] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어 (2026-08-06 사용자 지시)
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    --=============================================================================================================
    -- 시작 LOG
    --=============================================================================================================
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    
    -- 1. 프로젝트 등록 저장 호출
    P_SDM1010_SAVE_TAB1_PJT_REG(
          P_ACTIVE_FLAG      => P_ACTIVE_FLAG
        , P_DPJT_KEY         => P_DPJT_KEY
        , P_DPJT_CODE        => P_DPJT_CODE
        , P_DPJT_SEQ         => P_DPJT_SEQ
        , P_DIVISION_ID      => P_DIVISION_ID
        , P_DPJT_CLASS       => P_DPJT_CLASS
        , P_END_CUSTOMER     => P_END_CUSTOMER
        , P_DPJT_NAME        => P_DPJT_NAME
        , P_CELL_TYPE        => P_CELL_TYPE
        , P_STACK_METHOD     => P_STACK_METHOD
        , P_BIZ_TYPE         => P_BIZ_TYPE
        , P_SOP_DATE         => P_SOP_DATE
        , P_SOP_PLANT_ID     => P_SOP_PLANT_ID
        , P_SES_USER_ID      => P_SES_USER_ID
        , O_RESULT_CURSOR    => V_SAVE_RESULT_CURSOR
    );

    -- 리턴된 커서에서 데이터를 읽어옴
    FETCH V_SAVE_RESULT_CURSOR INTO V_CODE, V_MSG, V_EVENT;
    
    -- 저장 프로시저의 반환값이 정상이 아닌 경우 (CODE가 '0'이 아닐 경우)
    IF V_CODE != '0' OR V_CODE IS NULL THEN
        -- 읽어들인 에러 코드와 메시지 그대로 커서를 다시 생성하여 반환 후 종료
        OPEN O_RESULT_CURSOR FOR 
            SELECT V_CODE AS CODE, V_MSG AS MSG, V_EVENT AS EVENT FROM DUAL;
        RETURN;
    END IF;
    
    V_DPJT_CODE     := TRIM(REGEXP_SUBSTR(P_DPJT_CODE,            '[^\^]+', 1, 1));
    N_DPJT_SEQ      := TO_NUMBER(TRIM(REGEXP_SUBSTR(P_DPJT_SEQ,   '[^\^]+', 1, 1)));
    V_DPJT_KEY      := V_DPJT_CODE || '_' || TO_CHAR(N_DPJT_SEQ, 'FM000000');
    
    -- 2. 프로젝트 등록요청 호출 
    -- (저장이 성공했으므로 실행되며, 이 프로시저의 결과가 최종 출력이 되므로 O_RESULT_CURSOR에 바로 할당)
    P_SDM1010_BTN_REQ_PJT_REG(
          P_DIVISION_ID      => P_DIVISION_ID
        , P_DPJT_KEY         => V_DPJT_KEY--P_DPJT_KEY
        , P_SES_USER_ID      => P_SES_USER_ID
        --, O_RESULT_CURSOR    => V_SAVE_RESULT_CURSOR
        , O_RESULT_CURSOR    => O_RESULT_CURSOR
    );

    /*
    -- 리턴된 커서에서 데이터를 읽어옴
    FETCH V_SAVE_RESULT_CURSOR INTO V_CODE, V_MSG, V_EVENT;
    DBMS_OUTPUT.PUT_LINE('V_CODE : ' || V_CODE);
    DBMS_OUTPUT.PUT_LINE('V_MSG : ' || V_MSG);
    DBMS_OUTPUT.PUT_LINE('V_EVENT : ' || V_EVENT);
    -- 두 번째 프로시저가 정상이 아닌 경우 에러 처리 (필요시 롤백 등 추가 가능)
    IF V_CODE != '0' OR V_CODE IS NULL THEN
        -- 에러 결과 세팅 후 반환
        OPEN O_RESULT_CURSOR FOR 
            SELECT V_CODE AS CODE, V_MSG AS MSG, V_EVENT AS EVENT FROM DUAL;
        RETURN;
    END IF;
    */

    /*
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_EVENT_COUNT) AS EVENT FROM DUAL;
    */

    RETURN;

    --=============================================================================================================
    -- VALIDATION FAIL 처리
    --=============================================================================================================
    <<VALIDATION_FAIL>>
    ROLLBACK;
    v_log_message := V_S_CODE;
    v_description := V_S_CODE || '^' || V_S_VALIDATION;
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


    OPEN O_RESULT_CURSOR FOR
    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_S_CODE || '^' || V_S_VALIDATION AS EVENT FROM DUAL;
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_DIVISION_ID'         VALUE SUBSTR(P_DIVISION_ID, 1, 500)
          , 'P_DPJT_KEY'            VALUE SUBSTR(P_DPJT_KEY, 1, 500)
          , 'P_SES_USER_ID'         VALUE P_SES_USER_ID
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_BTN_REQ_PJT_REG_MAIN;

PROCEDURE P_SDM1010_BTN_CANCEL_PJT_REG
(
    P_DIVISION_ID               IN VARCHAR2
  , P_DPJT_KEY                  IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010.P_SDM1010_BTN_CANCEL_PJT_REG
 * Description  : Cancel Project Registration
 * Parameter    : PKG_SDM1010.P_SDM1010_BTN_CANCEL_PJT_REG(P_DIVISION_ID, P_DPJT_KEY, P_USER_ID, O_RESULT_CURSOR)
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ         최초 작성
 *                          프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    V_DPJT_KEY                  VARCHAR2(50);
    V_DIVISION_ID               VARCHAR2(30);
    
    N_MAX_CNT                   PLS_INTEGER := 0;
    V_USER_ID                   VARCHAR2(50) := P_SES_USER_ID;
    V_DPJT_REG_STATUS           VARCHAR2(50);
    V_DPJT_KEY_PARENT           VARCHAR2(50);

    --=============================================================================================================
    -- LOG 용 변수 설정
    --=============================================================================================================
    v_log_type            VARCHAR2(30 CHAR);
    n_log_count           PLS_INTEGER := 0;
    v_log_message         VARCHAR2(1000 CHAR);
    v_description         VARCHAR2(4000 CHAR);
    d_event_date          DATE;
    n_del_count           PLS_INTEGER := 0;
    n_insert_count        PLS_INTEGER := 0;
    n_event_count         PLS_INTEGER := 0;
    -- 프로그램명 (로그용)
    V_PROGRAM_NAME          VARCHAR2(150);

    --=============================================================================================================
    -- VALIDATION 변수
    --=============================================================================================================
    V_S_VALIDATION        VARCHAR2(4000 CHAR) := NULL;
    V_S_CODE              VARCHAR2(50 CHAR)   := NULL;

    --=============================================================================================================
    -- VERSION 변수
    --=============================================================================================================
    v_max_mf_w_version    VARCHAR2(100 CHAR);
    v_max_mf_w_yyyymmdd   VARCHAR2(8 CHAR);
    v_max_sf_w_version    VARCHAR2(100 CHAR);
    v_max_sf_w_yyyymmdd   VARCHAR2(8 CHAR);
    v_cutoff_start        VARCHAR2(8 CHAR);
    v_cutoff_end          VARCHAR2(8 CHAR);

    --=============================================================================================================
    -- EXCEPTION 변수
    --=============================================================================================================
    V_PROC_INPUT          VARCHAR2(4000 CHAR);
    V_BACKTRACE           VARCHAR2(4000 CHAR);
    V_SQL_CODE            VARCHAR2(100 CHAR);
    V_SQL_ERRMSG          VARCHAR2(1000 CHAR);

    V_CNT                 NUMBER;

BEGIN
    --[E20260806-DS2] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어 (2026-08-06 사용자 지시)
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    --=============================================================================================================
    -- 시작 LOG
    --=============================================================================================================
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    
    -- ^ 구분자로 전달받은 Grid 데이터의 Row 수 추출
    N_MAX_CNT := REGEXP_COUNT(P_DIVISION_ID, '\^') + 1;
    
    -- Grid Row count Loop
    FOR i IN 1..N_MAX_CNT LOOP
        V_DPJT_KEY          := TRIM(REGEXP_SUBSTR(P_DPJT_KEY,           '[^\^]+', 1, i));
        V_DIVISION_ID       := TRIM(REGEXP_SUBSTR(P_DIVISION_ID,        '[^\^]+', 1, i));
    
        SELECT PJM.DPJT_REG_STATUS, PJM.DPJT_KEY_PARENT
          INTO V_DPJT_REG_STATUS, V_DPJT_KEY_PARENT
          FROM SCM_MGR.SPMS_PROJECT_MST PJM
         WHERE 0 = 0
           AND PJM.DPJT_KEY = V_DPJT_KEY
        ;
        
        -- 1) (최초)등록요청 : REG_STATUS = 'WAITING' (not 'REQ_MOD')
        IF V_DPJT_REG_STATUS = 'WAITING' THEN
             MERGE INTO SCM_MGR.SPMS_PROJECT_MST SRC
             USING (
                        SELECT V_DPJT_KEY DPJT_KEY, V_DIVISION_ID
                          FROM DUAL
                   ) DAT
                ON (
                       0 = 0
                   AND SRC.DPJT_KEY = DAT.DPJT_KEY
                   )
              WHEN MATCHED THEN
            UPDATE
               SET SRC.LAST_UPDATED_BY      = V_USER_ID
                 , SRC.LAST_UPDATE_DATE     = SYSDATE
                 --
                 , SRC.DPJT_REG_STATUS      = 'WRITING'         -- 작성중
                 , SRC.REG_REQ_DATE         = NULL              -- 등록 요청일
             WHERE 0 = 0
               -- 승인대기(WAITING) 상태만 등록요청 가능
               AND SRC.DPJT_REG_STATUS = 'WAITING'
            ;
            N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;
        
        -- 2) 변경요청 : REG_STATUS = 'REQ_MOD' (not 'WAITING')
        ELSIF    V_DPJT_REG_STATUS = 'REQ_MOD'
             AND V_DPJT_KEY_PARENT IS NOT NULL
        THEN
        
            -- 변경 요청 건 삭제
            DELETE SCM_MGR.SPMS_PROJECT_MST
             WHERE DPJT_KEY = V_DPJT_KEY
            ;
            
            -- 변경 요청 건 권한 정보 삭제
            DELETE SCM_MGR.SPMS_PROJECT_USER_MAP
             WHERE DPJT_KEY = V_DPJT_KEY
            ;
            
            -- 원 프로젝트 변경상태 초기화 MODIFYING => COMPLETE
             MERGE INTO SCM_MGR.SPMS_PROJECT_MST SRC
             USING (
                        SELECT V_DPJT_KEY_PARENT DPJT_KEY, V_DIVISION_ID
                          FROM DUAL
                   ) DAT
                ON (
                       0 = 0
                   AND SRC.DPJT_KEY = DAT.DPJT_KEY
                   )
              WHEN MATCHED THEN
            UPDATE
               SET SRC.LAST_UPDATED_BY      = V_USER_ID
                 , SRC.LAST_UPDATE_DATE     = SYSDATE
                 --
                 , SRC.DPJT_REG_STATUS      = 'COMPLETE'        -- 등록완료
                 --, SRC.REG_MOD_DATE         = NULL              -- 변경 요청일
             WHERE 0 = 0
               -- 변경중(MODIFYING) 상태만 등록요청 가능
               AND SRC.DPJT_REG_STATUS = 'MODIFYING'
            ;
            N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;
             
        END IF;
    
    END LOOP;

    COMMIT;

    N_EVENT_COUNT := N_EVENT_COUNT + N_DEL_COUNT + N_INSERT_COUNT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_EVENT_COUNT) AS EVENT FROM DUAL;

    RETURN;

    --=============================================================================================================
    -- VALIDATION FAIL 처리
    --=============================================================================================================
    <<VALIDATION_FAIL>>
    ROLLBACK;
    v_log_message := V_S_CODE;
    v_description := V_S_CODE || '^' || V_S_VALIDATION;
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


    OPEN O_RESULT_CURSOR FOR
    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_S_CODE || '^' || V_S_VALIDATION AS EVENT FROM DUAL;
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_DIVISION_ID'         VALUE SUBSTR(P_DIVISION_ID, 1, 500)
          , 'P_DPJT_KEY'            VALUE SUBSTR(P_DPJT_KEY, 1, 500)
          , 'P_SES_USER_ID'         VALUE P_SES_USER_ID
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_BTN_CANCEL_PJT_REG;

PROCEDURE P_SDM1010_GET_TAB2_PJT_LIST (
    P_DIVISION_ID               IN VARCHAR2
  , P_END_CUSTOMER              IN VARCHAR2     -- 고객
  , P_DPJT_AUTH_TYPE            IN VARCHAR2     -- 나의 권한
  , P_DPJT_REG_STATUS           IN VARCHAR2     -- 등록 상태
  , P_REG_COMP_DATE_FR          IN VARCHAR2     -- 등록 완료일
  , P_REG_COMP_DATE_TO          IN VARCHAR2     -- 등록 완료일
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010.P_SDM1010_GET_TAB2_PJT_LIST
 * Description  : My Project List
 * Parameter    : 
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ         최초 작성
 *                          프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    V_PROC_INPUT                VARCHAR2(4000 CHAR);
    V_BACKTRACE                 VARCHAR2(4000 CHAR);
    V_SQL_CODE                  VARCHAR2(100  CHAR);
    V_SQL_ERRMSG                VARCHAR2(1000 CHAR);
    n_log_count                 PLS_INTEGER := 0;
    V_PROGRAM_NAME              VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    
    D_REG_COMP_DATE_FR          DATE    := TO_DATE(SUBSTR(P_REG_COMP_DATE_FR, 1, 10), 'YYYY-MM-DD');
    D_REG_COMP_DATE_TO          DATE    := TO_DATE(SUBSTR(P_REG_COMP_DATE_TO, 1, 10), 'YYYY-MM-DD');

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    OPEN O_CURSOR FOR
        -- 조회조건이 멀티 선택인 경우 테이블 화 해서 처리
        WITH WT_FILTER_DIV AS (
            SELECT NR, TOKEN FROM SCM_MGR.UF_FX_STRING_SPLIT(P_DIVISION_ID, ',')
        )
        , WT_FILTER_EC AS (
            SELECT NR, TOKEN FROM SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER, ',')
        )
        , WT_FILTER_AUTH_TYPE AS (
            SELECT NR, TOKEN FROM SCM_MGR.UF_FX_STRING_SPLIT(P_DPJT_AUTH_TYPE, ',')
        )
        , WT_FILTER_REG_STATUS AS (
            SELECT NR, TOKEN FROM SCM_MGR.UF_FX_STRING_SPLIT(P_DPJT_REG_STATUS, ',')
        )
        SELECT PJM.DPJT_KEY
             -- 반려 상태인 경우 Project Code 를 보여주지 않음
             --, PJM.DPJT_CODE
             , CASE WHEN PJM.DPJT_REG_STATUS NOT IN ('REJECT') THEN PJM.DPJT_CODE END AS DPJT_CODE
             , PJM.DPJT_SEQ
             , 'My Work' MY_WORK
             , PJM.DIVISION_ID, DIV.DIVISION_ID DIVISION_NAME
             , PJM.DPJT_CLASS, PCL.DPJT_CLASS_NAME
             , PJM.END_CUSTOMER, NVL(EDC.END_CUSTOMER_NAME, PJM.END_CUSTOMER) END_CUSTOMER_NAME
             , PJM.DPJT_NAME
             , PJM.CELL_TYPE, CLT.CELL_TYPE_NAME
             , PJM.STACK_METHOD, SMD.STACK_METHOD_NAME
             , PJM.BIZ_TYPE, BIZ.BIZ_TYPE_NAME
             , PJM.SOP_DATE
             , PJM.SOP_PLANT_ID, NVL(PLT.SOP_PLANT_NAME, PJM.SOP_PLANT_ID) AS SOP_PLANT_NAME
             , PJM.MGMT_USER_ID, USR.USER_NAME, USR.USER_NAME_EN
             , USR.DEPT_ID, DPT.DEPT_NAME_KO DEPT_NAME, DPT.DEPT_NAME_KO, DPT.DEPT_NAME_EN, DPT.DEPT_NAME_CN
             , CASE
                    WHEN USM.DPJT_AUTH_STATUS = 'REQUEST'
                    THEN 'NONE'
                    ELSE USM.DPJT_AUTH_TYPE
               END AS DPJT_AUTH_TYPE
             , CASE
                    WHEN USM.DPJT_AUTH_STATUS = 'REQUEST'
                    THEN '권한없음'
                    ELSE USM.DPJT_AUTH_TYPE_NAME
               END AS DPJT_AUTH_TYPE_NAME
             , PJM.DPJT_REG_STATUS, RGS.DPJT_REG_STATUS_NAME, RGS.DPJT_REG_STATUS_COLOR_TYPE
             , PJM.REG_COMP_DATE, PJM.DPJT_DEVELOP_STATUS, DVL.DPJT_DEVELOP_STATUS_NAME
          FROM SCM_MGR.SPMS_PROJECT_MST PJM
         INNER JOIN
               SCM_MGR.SCM_MST_DIVISION DIV
            ON 0 = 0
           AND PJM.DIVISION_ID = DIV.DIVISION_ID
         INNER JOIN
               (
                    SELECT LKD.SEGMENT1 AS DPJT_CLASS_ID
                         , LKD.SEGMENT2 AS DPJT_CLASS_NAME
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_DPJT_CLASS'
                       AND LKM.VALID_YN = 'Y'
               ) PCL
            ON 0 = 0
           AND PJM.DPJT_CLASS = PCL.DPJT_CLASS_ID
          LEFT OUTER JOIN
               (
                    SELECT DISTINCT
                           SIT.DIVISION_ID, SIT.END_CUSTOMER, SIT.END_CUSTOMER END_CUSTOMER_NAME
                      FROM SCM_MGR.SCM_MST_SITE SIT
                     WHERE 0 = 0
               ) EDC
            ON 0 = 0
           AND PJM.DIVISION_ID  = EDC.DIVISION_ID
           AND PJM.END_CUSTOMER = EDC.END_CUSTOMER
         INNER JOIN
               (
                    SELECT LKD.SEGMENT1 AS DIVISION_ID
                         , LKD.SEGMENT2 AS CELL_TYPE
                         , LKD.SEGMENT3 AS CELL_TYPE_NAME
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_CELL_TYPE'
                       AND LKM.VALID_YN = 'Y'
               ) CLT
            ON 0 = 0
           AND PJM.DIVISION_ID  = CLT.DIVISION_ID
           AND PJM.CELL_TYPE    = CLT.CELL_TYPE
         INNER JOIN
               (
                    SELECT LKD.SEGMENT1 AS DIVISION_ID
                         , LKD.SEGMENT2 AS CELL_TYPE
                         , LKD.SEGMENT4 AS STACK_METHOD
                         , LKD.SEGMENT5 AS STACK_METHOD_NAME
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_CELL_STACK_METHOD'
                       AND LKM.VALID_YN = 'Y'
               ) SMD
            ON 0 = 0
           AND PJM.DIVISION_ID  = SMD.DIVISION_ID
           AND PJM.STACK_METHOD = SMD.STACK_METHOD
         INNER JOIN
               (
                    SELECT LKD.SEGMENT1 AS BIZ_TYPE
                         , LKD.SEGMENT2 AS BIZ_TYPE_NAME
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'DM_BIZ_TYPE'
                       AND LKM.VALID_YN = 'Y'
               ) BIZ
            ON 0 = 0
           AND PJM.BIZ_TYPE     = BIZ.BIZ_TYPE
          LEFT OUTER JOIN
               (
                    SELECT DISTINCT
                           SIT.DIVISION_ID, SIT.PLANT_ID SOP_PLANT_ID, SIT.PLANT_ID SOP_PLANT_NAME
                      FROM SCM_MGR.SCM_MST_PLANT_SN SIT
                     WHERE 0 = 0
                    /*
                    SELECT DISTINCT
                           SIT.DIVISION_ID, SIT.SCM_SITE_ID SOP_PLANT_ID, SIT.SCM_SITE_ID SOP_PLANT_NAME
                      FROM SCM_MGR.SCM_MST_SITE SIT
                     WHERE 0 = 0
                       AND SIT.SITE_TYPE = 'PLANT'
                       */
               ) PLT
            ON 0 = 0
           AND PJM.DIVISION_ID  = PLT.DIVISION_ID
           AND PJM.SOP_PLANT_ID = PLT.SOP_PLANT_ID
          LEFT OUTER JOIN
               (
                    SELECT USM.DPJT_KEY
                         , USM.DPJT_AUTH_TYPE, AUT.DPJT_AUTH_TYPE_NAME
                         , USM.DPJT_AUTH_STATUS
                      FROM SCM_MGR.SPMS_PROJECT_USER_MAP USM
                     INNER JOIN
                           (
                                SELECT LKD.SEGMENT1 AS DPJT_AUTH_TYPE
                                     , LKD.SEGMENT2 AS DPJT_AUTH_TYPE_NAME
                                  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                                 INNER JOIN
                                       SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                                    ON 0 = 0
                                   AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                                   AND LKD.VALID_YN = 'Y'
                                 WHERE 0 = 0
                                   AND LKM.LOOKUP_TYPE = 'SPMS_DPJT_AUTH_TYPE'
                                   AND LKM.VALID_YN = 'Y'
                           ) AUT
                        ON 0 = 0
                       AND USM.DPJT_AUTH_TYPE   = AUT.DPJT_AUTH_TYPE
                     WHERE 0 = 0
                       AND USM.USER_ID = P_SES_USER_ID
                     GROUP BY USM.DPJT_KEY
                         , USM.DPJT_AUTH_TYPE
                         , USM.DPJT_AUTH_STATUS
                         , AUT.DPJT_AUTH_TYPE_NAME -- Group By 추가 By.최일성(260810)
               ) USM
            ON 0 = 0
           AND PJM.DPJT_KEY  = USM.DPJT_KEY
         INNER JOIN
               SCM_MGR.SCM_MST_SSO_USER_INFO USR
            ON 0 = 0
           AND PJM.MGMT_USER_ID = USR.USER_ID
         INNER JOIN
               SCM_MGR.SCM_MST_SSO_DEPT_INFO DPT
            ON 0 = 0
           AND USR.DEPT_ID = DPT.DEPT_ID
         INNER JOIN
               (
                    SELECT LKD.SEGMENT1 AS DPJT_REG_STATUS
                         , LKD.SEGMENT2 AS DPJT_REG_STATUS_NAME
                         , LKD.SEGMENT3 AS DPJT_REG_STATUS_COLOR_TYPE
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_DPJT_REG_STATUS'
                       AND LKM.VALID_YN = 'Y'
               ) RGS
            ON 0 = 0
           AND PJM.DPJT_REG_STATUS = RGS.DPJT_REG_STATUS
          LEFT OUTER JOIN
               (
                    SELECT LKD.SEGMENT1 AS DPJT_DEVELOP_STATUS
                         , LKD.SEGMENT2 AS DPJT_DEVELOP_STATUS_NAME
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_DPJT_DEVELOP_STATUS'
                       AND LKM.VALID_YN = 'Y'
               ) DVL
            ON 0 = 0
           AND PJM.DPJT_DEVELOP_STATUS = DVL.DPJT_DEVELOP_STATUS
         WHERE 0 = 0
           -- 나의 권한 정보가 존해하는 것만 조회 (권한 요청 상태 제외)
           AND USM.DPJT_AUTH_TYPE IS NOT NULL
           AND USM.DPJT_AUTH_STATUS != 'REQUEST'
           -- 조회 조건
           AND (
                    P_DIVISION_ID    = 'ALL'
                 OR PJM.DIVISION_ID IN ( SELECT TOKEN FROM WT_FILTER_DIV )
               )
           AND (
                    P_END_CUSTOMER    = 'ALL'
                 OR PJM.END_CUSTOMER IN ( SELECT TOKEN FROM WT_FILTER_EC )
               )
           AND (
                    P_DPJT_AUTH_TYPE    = 'ALL'
                 OR CASE
                        WHEN USM.DPJT_AUTH_STATUS = 'REQUEST'
                        THEN 'NONE'
                        ELSE USM.DPJT_AUTH_TYPE
                   END IN ( SELECT TOKEN FROM WT_FILTER_AUTH_TYPE )
               )
           AND (
                    P_DPJT_REG_STATUS    = 'ALL'
                 OR PJM.DPJT_REG_STATUS IN ( SELECT TOKEN FROM WT_FILTER_REG_STATUS )
               )
           AND (
                    PJM.REG_COMP_DATE BETWEEN D_REG_COMP_DATE_FR AND D_REG_COMP_DATE_TO
                 OR ( D_REG_COMP_DATE_FR IS NULL AND D_REG_COMP_DATE_TO IS NULL )
               )
    ;
    
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_DIVISION_ID'             VALUE P_DIVISION_ID
          , 'P_END_CUSTOMER'            VALUE P_END_CUSTOMER
          , 'P_DPJT_AUTH_TYPE'          VALUE P_DPJT_AUTH_TYPE
          , 'P_DPJT_REG_STATUS'         VALUE P_DPJT_REG_STATUS
          , 'P_REG_COMP_DATE_FR'        VALUE P_REG_COMP_DATE_FR
          , 'P_REG_COMP_DATE_TO'        VALUE P_REG_COMP_DATE_TO
          , 'P_SES_USER_ID'             VALUE P_SES_USER_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION', '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_GET_TAB2_PJT_LIST;

PROCEDURE P_SDM1010_GET_POP_USER_ORG (
    P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010.P_SDM1010_GET_POP_USER_ORG
 * Description  : Organization List
 * Parameter    : 
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ         최초 작성
 *                          프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100  CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
    n_log_count         PLS_INTEGER := 0;
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    
    --
    V_SES_DEPT_ID       VARCHAR2(50);

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    -- Session 사용자 부서 정보 참조
    --  : 조직도 내 Session 사용자 부서를 최초 자동 로딩하기 위함
    SELECT MAX(USR.DEPT_ID) AS DEPT_ID
      INTO V_SES_DEPT_ID
      FROM SCM_MGR.SCM_MST_SSO_USER_INFO USR
     WHERE 0 = 0
       AND USR.USER_ID = P_SES_USER_ID
    ;
    
    OPEN O_CURSOR FOR
        /*
        SELECT '58174290' DEPT_ID, 'LG 에너지솔루션' DEPT_NAME, '00000000' PARENT_DEPT_ID
          FROM dual
        UNION ALL
        SELECT '58093132' DEPT_ID, '자동차전지사업부' DEPT_NAME, '58174290' PARENT_DEPT_ID
          FROM dual
        */
        WITH WT_DEPT_MST AS (
            SELECT DPT.DEPT_ID, DPT.DEPT_NAME_KO DEPT_NAME, DPT.DEPT_NAME_EN, DPT.DEPT_NAME_CN, DPT.UPPER_DEPT_ID
                 , NVL(USR.USER_COUNT, 0) AS USER_COUNT
              FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO DPT
              LEFT OUTER JOIN
                   (
                        SELECT USR.DEPT_ID, COUNT(*) USER_COUNT
                          FROM SCM_MGR.SCM_MST_SSO_USER_INFO USR
                         WHERE 0 = 0
                           AND USR.ACTIVE_FLAG NOT IN ('D', '-')
                         GROUP BY USR.DEPT_ID
                   ) USR
                ON 0 = 0
               AND DPT.DEPT_ID = USR.DEPT_ID
             WHERE 0 = 0
               AND DPT.VALID_YN = 'Y'
        )
        , WT_DEPT_USER_EXISTS AS ( -- 사용자가 존재하는 부서 조직도만 포함
            SELECT DEPT_ID
              FROM WT_DEPT_MST DPT
             WHERE 0 = 0
             START WITH
                   DPT.USER_COUNT > 0
            CONNECT BY PRIOR DPT.UPPER_DEPT_ID = DEPT_ID
        )
        SELECT LEVEL LEVEL_NO, DPT.DEPT_ID, DPT.DEPT_NAME, DPT.UPPER_DEPT_ID, DPT.USER_COUNT
             , LPAD(' ', (LEVEL-1)*4) || DPT.DEPT_ID AS ORGN
             -- Session 사용자 부서 정보 참조 : 조직도 내 Session 사용자 부서를 최초 자동 로딩하기 위함
             , V_SES_DEPT_ID AS SES_DEPT_ID
          FROM (
                    SELECT DISTINCT DPT.*
                      FROM WT_DEPT_MST DPT
                      INNER JOIN WT_DEPT_USER_EXISTS DIN ON DPT.DEPT_ID = DIN.DEPT_ID
                     WHERE 0 = 0
               ) DPT
         WHERE 0 = 0
           --AND DPT.DEPT_ID IN ( SELECT DIN.DEPT_ID FROM WT_DEPT_USER_EXISTS DIN )
         START WITH
               -- 2026.08.19 KTJ : 최상위 LG에너지 솔류션 제외
               --DPT.UPPER_DEPT_ID IS NULL OR DPT.UPPER_DEPT_ID = '' OR DPT.UPPER_DEPT_ID = '00000000'
               DPT.DEPT_ID IN ('58174290') OR ( DPT.UPPER_DEPT_ID IN ('_000') AND DPT.DEPT_ID NOT IN ('II') )
        CONNECT BY PRIOR DPT.DEPT_ID = DPT.UPPER_DEPT_ID
        ;
    
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_SES_DIVISION_ID'         VALUE P_SES_DIVISION_ID
          , 'P_SES_USER_ID'             VALUE P_SES_USER_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION', '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_GET_POP_USER_ORG;

-- 사용자 목록
PROCEDURE P_SDM1010_GET_POP_USER_BY_DEPT (
    P_USER_INFO                 IN VARCHAR2
  , P_DEPT_ID                   IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010.P_SDM1010_GET_POP_USER_BY_DEPT
 * Description  : 사용자 List
 * Parameter    : 
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ         최초 작성
 *                          프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    V_PROC_INPUT                VARCHAR2(4000 CHAR);
    V_BACKTRACE                 VARCHAR2(4000 CHAR);
    V_SQL_CODE                  VARCHAR2(100  CHAR);
    V_SQL_ERRMSG                VARCHAR2(1000 CHAR);
    n_log_count                 PLS_INTEGER := 0;
    V_PROGRAM_NAME              VARCHAR2(150 CHAR) := $$PLSQL_UNIT;


BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    -- 사용자 목록 검색은 사용자 정보(P_USER_INFO) 조회 조건으로 조회하는 경우와
    -- 조직도의 부서 정보를(P_DEPT_ID) 클릭하여 조회하는 경우 두 가지 Case 존재
    -- 두 개 Case 의 구분은 부서 정보(P_DEPT_ID) 유무로 판단
    
    -- 1. 사용자 정보 검색인 경우
    IF P_DEPT_ID = '' OR P_DEPT_ID IS NULL THEN
    
        OPEN O_CURSOR FOR
            SELECT USR.USER_ID, USR.USER_NAME
                 , USR.JOB_CODE, USR.JOB_NAME
                 , USR.DEPT_ID, DPT.DEPT_NAME_KO AS DEPT_NAME
                 , NVL(JBP.PRIORITY, 999999) AS PRIORITY
              FROM SCM_MGR.SCM_MST_SSO_USER_INFO USR
             INNER JOIN
                   SCM_MGR.SCM_MST_SSO_DEPT_INFO DPT
                ON 0 = 0
               AND USR.DEPT_ID = DPT.DEPT_ID
               AND DPT.VALID_YN = 'Y'
              LEFT OUTER JOIN
                   (
                        SELECT LKD.SEGMENT1 AS JOB_CODE
                             , MAX(LKD.SEGMENT2) AS JOB_NAME
                             , MAX(LKD.SEGMENT3) AS NATION
                             , MAX(TO_NUMBER(LKD.SEGMENT4 DEFAULT 999999 ON CONVERSION ERROR)) AS PRIORITY
                          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                         INNER JOIN
                               SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                            ON 0 = 0
                           AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                           AND LKD.VALID_YN = 'Y'
                         WHERE 0 = 0
                           AND LKM.LOOKUP_TYPE = 'SPMS_JOB_SEQ'
                           AND LKM.VALID_YN = 'Y'
                         GROUP BY LKD.SEGMENT1
                   ) JBP
                ON 0 = 0
               AND USR.JOB_CODE     = JBP.JOB_CODE
             WHERE 0 = 0
               AND UPPER(USR.USER_ID || USR.USER_NAME) LIKE '%' || UPPER(P_USER_INFO) || '%'
               AND USR.ACTIVE_FLAG NOT IN ('D', '-')
               -- 사용자 정보(조회조건) 이 없으면 결과를 리턴하지 않음
               AND CASE WHEN P_USER_INFO IS NULL THEN 0 ELSE 1 END = 1
               -- LG 에너지 솔루션 만 조회
               -- 기타 협혁없체 조회를 위해 NULL 포함
               AND ( SUBSTR(DPT.ATTRIBUTE2, 1, 8) = '58174290' OR DPT.ATTRIBUTE2 IS NULL )
             ORDER BY NVL(JBP.PRIORITY, 999999), USR.USER_NAME
            ;
    -- 2. 부서 정보 검색인 경우
    ELSE
        OPEN O_CURSOR FOR
            SELECT USR.USER_ID, USR.USER_NAME
                 , USR.JOB_CODE, USR.JOB_NAME
                 , USR.DEPT_ID, DPT.DEPT_NAME_KO AS DEPT_NAME
                 , NVL(JBP.PRIORITY, 999999) AS PRIORITY
              FROM SCM_MGR.SCM_MST_SSO_USER_INFO USR
             INNER JOIN
                   SCM_MGR.SCM_MST_SSO_DEPT_INFO DPT
                ON 0 = 0
               AND USR.DEPT_ID = DPT.DEPT_ID
               AND DPT.VALID_YN = 'Y'
              LEFT OUTER JOIN
                   (
                        SELECT LKD.SEGMENT1 AS JOB_CODE
                             , MAX(LKD.SEGMENT2) AS JOB_NAME
                             , MAX(LKD.SEGMENT3) AS NATION
                             , MAX(TO_NUMBER(LKD.SEGMENT4 DEFAULT 999999 ON CONVERSION ERROR)) AS PRIORITY
                          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                         INNER JOIN
                               SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                            ON 0 = 0
                           AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                           AND LKD.VALID_YN = 'Y'
                         WHERE 0 = 0
                           AND LKM.LOOKUP_TYPE = 'SPMS_JOB_SEQ'
                           AND LKM.VALID_YN = 'Y'
                         GROUP BY LKD.SEGMENT1
                   ) JBP
                ON 0 = 0
               AND USR.JOB_CODE     = JBP.JOB_CODE
             WHERE 0 = 0
               AND USR.ACTIVE_FLAG NOT IN ('D', '-')
               AND DPT.DEPT_ID = P_DEPT_ID
             ORDER BY NVL(JBP.PRIORITY, 999999), USR.USER_NAME
            ;
    END IF;
        
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_USER_INFO'               VALUE P_USER_INFO
          , 'P_DEPT_ID'                 VALUE P_DEPT_ID
          , 'P_SES_DIVISION_ID'         VALUE P_SES_DIVISION_ID
          , 'P_SES_USER_ID'             VALUE P_SES_USER_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION', '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_GET_POP_USER_BY_DEPT;

-- 입력 권한 사용자 목록
PROCEDURE P_SDM1010_GET_POP_PJT_AUTH_WRITE (
    P_DPJT_KEY                  IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010.P_SDM1010_GET_POP_PJT_AUTH_WRITE
 * Description  : 입력 권한 사용자 목록
 * Parameter    : 
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ         최초 작성
 *                          프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    V_PROC_INPUT                VARCHAR2(4000 CHAR);
    V_BACKTRACE                 VARCHAR2(4000 CHAR);
    V_SQL_CODE                  VARCHAR2(100  CHAR);
    V_SQL_ERRMSG                VARCHAR2(1000 CHAR);
    n_log_count                 PLS_INTEGER := 0;
    V_PROGRAM_NAME              VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    OPEN O_CURSOR FOR
        SELECT AUT.DPJT_KEY
             , AUT.USER_ID, USR.USER_NAME
             , USR.JOB_CODE, USR.JOB_NAME
             , USR.DEPT_ID, DPT.DEPT_NAME_KO AS DEPT_NAME
          FROM SCM_MGR.SPMS_PROJECT_USER_MAP AUT
         INNER JOIN
               SCM_MGR.SCM_MST_SSO_USER_INFO USR
            ON 0 = 0
           AND AUT.USER_ID = USR.USER_ID
         INNER JOIN
               SCM_MGR.SCM_MST_SSO_DEPT_INFO DPT
            ON 0 = 0
           AND USR.DEPT_ID = DPT.DEPT_ID
         WHERE 0 = 0
           AND AUT.DPJT_AUTH_STATUS = 'CONFIRM'
           AND AUT.DPJT_AUTH_TYPE   = 'WRITE'
           --
           AND AUT.DPJT_KEY = P_DPJT_KEY
        ;
        
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_DPJT_KEY'                VALUE P_DPJT_KEY
          , 'P_SES_DIVISION_ID'         VALUE P_SES_DIVISION_ID
          , 'P_SES_USER_ID'             VALUE P_SES_USER_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION', '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_GET_POP_PJT_AUTH_WRITE;

-- 조회 권한 사용자 목록
PROCEDURE P_SDM1010_GET_POP_PJT_AUTH_READ (
    P_DPJT_KEY                  IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010.P_SDM1010_GET_POP_PJT_AUTH_READ
 * Description  : 조회 권한 사용자 목록
 * Parameter    : 
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ         최초 작성
 *                          프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    V_PROC_INPUT                VARCHAR2(4000 CHAR);
    V_BACKTRACE                 VARCHAR2(4000 CHAR);
    V_SQL_CODE                  VARCHAR2(100  CHAR);
    V_SQL_ERRMSG                VARCHAR2(1000 CHAR);
    n_log_count                 PLS_INTEGER := 0;
    V_PROGRAM_NAME              VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    OPEN O_CURSOR FOR
        SELECT AUT.DPJT_KEY
             , AUT.USER_ID, USR.USER_NAME
             , USR.JOB_CODE, USR.JOB_NAME
             , USR.DEPT_ID, DPT.DEPT_NAME_KO AS DEPT_NAME
          FROM SCM_MGR.SPMS_PROJECT_USER_MAP AUT
         INNER JOIN
               SCM_MGR.SCM_MST_SSO_USER_INFO USR
            ON 0 = 0
           AND AUT.USER_ID = USR.USER_ID
         INNER JOIN
               SCM_MGR.SCM_MST_SSO_DEPT_INFO DPT
            ON 0 = 0
           AND USR.DEPT_ID = DPT.DEPT_ID
         WHERE 0 = 0
           AND AUT.DPJT_AUTH_STATUS = 'CONFIRM'
           AND AUT.DPJT_AUTH_TYPE   = 'READ'
           --
           AND AUT.DPJT_KEY = P_DPJT_KEY
        ;
        
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_DPJT_KEY'                VALUE P_DPJT_KEY
          , 'P_SES_DIVISION_ID'         VALUE P_SES_DIVISION_ID
          , 'P_SES_USER_ID'             VALUE P_SES_USER_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION', '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_GET_POP_PJT_AUTH_READ;

-- 권한 요청 사용자 목록
PROCEDURE P_SDM1010_GET_POP_PJT_AUTH_REQ (
    P_DPJT_KEY                  IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010.P_SDM1010_GET_POP_PJT_AUTH_REQ
 * Description  : 권한 요청 사용자 목록
 * Parameter    : 
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ         최초 작성
 *                          프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    V_PROC_INPUT                VARCHAR2(4000 CHAR);
    V_BACKTRACE                 VARCHAR2(4000 CHAR);
    V_SQL_CODE                  VARCHAR2(100  CHAR);
    V_SQL_ERRMSG                VARCHAR2(1000 CHAR);
    n_log_count                 PLS_INTEGER := 0;
    V_PROGRAM_NAME              VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    OPEN O_CURSOR FOR
        SELECT AUT.DPJT_AUTH_STATUS, ATS.DPJT_AUTH_STATUS_NAME
             , AUT.DPJT_KEY
             , AUT.USER_ID, USR.USER_NAME
             , USR.JOB_CODE, USR.JOB_NAME
             , USR.DEPT_ID, DPT.DEPT_NAME_KO AS DEPT_NAME
             , AUT.DPJT_AUTH_TYPE
             , ATT.DPJT_AUTH_TYPE_NAME
             , '' PROCESS
          FROM SCM_MGR.SPMS_PROJECT_USER_MAP AUT
         INNER JOIN
               SCM_MGR.SCM_MST_SSO_USER_INFO USR
            ON 0 = 0
           AND AUT.USER_ID = USR.USER_ID
         INNER JOIN
               SCM_MGR.SCM_MST_SSO_DEPT_INFO DPT
            ON 0 = 0
           AND USR.DEPT_ID = DPT.DEPT_ID
         INNER JOIN
               (
                    SELECT LKD.SEGMENT1 AS DPJT_AUTH_TYPE
                         , LKD.SEGMENT2 AS DPJT_AUTH_TYPE_NAME
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_DPJT_AUTH_TYPE'
                       AND LKM.VALID_YN = 'Y'
               ) ATT
            ON 0 = 0
           AND AUT.DPJT_AUTH_TYPE = ATT.DPJT_AUTH_TYPE
          LEFT OUTER JOIN
               (
                    SELECT LKD.SEGMENT1 AS DPJT_AUTH_STATUS
                         , LKD.SEGMENT2 AS DPJT_AUTH_STATUS_NAME
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_DPJT_AUTH_STATUS'
                       AND LKM.VALID_YN = 'Y'
               ) ATS
            ON 0 = 0
           AND AUT.DPJT_AUTH_STATUS = ATS.DPJT_AUTH_STATUS
         WHERE 0 = 0
           AND ( AUT.DPJT_AUTH_STATUS != 'CONFIRM' OR AUT.DPJT_AUTH_STATUS IS NULL OR AUT.DPJT_AUTH_STATUS = '' )
           AND AUT.DPJT_AUTH_TYPE   IN ('WRITE', 'READ')
           --
           AND AUT.DPJT_KEY = P_DPJT_KEY
        ;
        
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_DPJT_KEY'                VALUE P_DPJT_KEY
          , 'P_SES_DIVISION_ID'         VALUE P_SES_DIVISION_ID
          , 'P_SES_USER_ID'             VALUE P_SES_USER_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION', '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_GET_POP_PJT_AUTH_REQ;

PROCEDURE P_SDM1010_SAVE_POP_PJT_AUTH_WRITE
(
    P_ACTIVE_FLAG               IN VARCHAR2             -- I(Insert) / D(Delete) / M(Modify)
  , P_DPJT_KEY                  IN VARCHAR2
  , P_USER_ID                   IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010.P_SDM1010_SAVE_POP_PJT_AUTH_WRITE
 * Description  : 프로젝트 입력 권한 저장
 * Parameter    : PKG_SDM1010.P_SDM1010_SAVE_POP_PJT_AUTH_WRITE(P_ACTIVE_FLAG, P_DPJT_KEY, P_USER_ID, P_SES_DIVISION_ID, P_SES_USER_ID, O_RESULT_CURSOR)
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ            최초 작성
 *                             프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    V_ACTIVE_FLAG               VARCHAR2(10);
    V_DPJT_KEY                  VARCHAR2(50);
    V_USER_ID                   VARCHAR2(50);
    
    N_MAX_CNT                   PLS_INTEGER := 0;
    V_SES_USER_ID               VARCHAR2(50) := P_SES_USER_ID;

    --=============================================================================================================
    -- LOG 용 변수 설정
    --=============================================================================================================
    V_LOG_TYPE                  VARCHAR2(30 CHAR);
    N_LOG_COUNT                 PLS_INTEGER := 0;
    V_LOG_MESSAGE               VARCHAR2(1000 CHAR);
    V_DESCRIPTION               VARCHAR2(4000 CHAR);
    D_EVENT_DATE                DATE;
    N_DEL_COUNT                 PLS_INTEGER := 0;
    N_INSERT_COUNT              PLS_INTEGER := 0;
    N_EVENT_COUNT               PLS_INTEGER := 0;
    -- 프로그램명 (로그용)
    V_PROGRAM_NAME          VARCHAR2(150);

    --=============================================================================================================
    -- VALIDATION 변수
    --=============================================================================================================
    V_S_VALIDATION              VARCHAR2(4000 CHAR) := NULL;
    V_S_CODE                    VARCHAR2(50 CHAR)   := NULL;

    --=============================================================================================================
    -- VERSION 변수
    --=============================================================================================================
    v_max_mf_w_version          VARCHAR2(100 CHAR);
    v_max_mf_w_yyyymmdd         VARCHAR2(8 CHAR);
    v_max_sf_w_version          VARCHAR2(100 CHAR);
    v_max_sf_w_yyyymmdd         VARCHAR2(8 CHAR);
    v_cutoff_start              VARCHAR2(8 CHAR);
    v_cutoff_end                VARCHAR2(8 CHAR);

    --=============================================================================================================
    -- EXCEPTION 변수
    --=============================================================================================================
    V_PROC_INPUT                VARCHAR2(4000 CHAR);
    V_BACKTRACE                 VARCHAR2(4000 CHAR);
    V_SQL_CODE                  VARCHAR2(100 CHAR);
    V_SQL_ERRMSG                VARCHAR2(1000 CHAR);

    N_CNT                       NUMBER;

BEGIN
    --[E20260806-DS2] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어 (2026-08-06 사용자 지시)
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    --=============================================================================================================
    -- 시작 LOG
    --=============================================================================================================
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    -- Old Write : 기존 쓰기 권한
    -- Old Read : 기존 일기 권한
    -- New Write : 신규 읽기 권한
    -- 1) Old Write 가 [New Write + Old Read] 에 없으면 반려 처리 (요청이 존재하는 사용자만 대상)
    -- 2) New Write 에 존재하는 사용자는 반려에서 제외
    
     MERGE INTO SCM_MGR.SPMS_PROJECT_USER_MAP SRC
     USING (
                WITH WT_NEW_WRITE AS (
                    SELECT NR AS ROW_KEY, TOKEN AS USER_ID
                         , 'WRITE' DPJT_AUTH_TYPE, P_DPJT_KEY AS DPJT_KEY
                      FROM SCM_MGR.UF_FX_STRING_SPLIT(P_USER_ID, '^')
                )
                , WT_AUTH_INFO AS ( -- 대상 Project 사용자 별 권한 정보
                    SELECT USM.DPJT_KEY, USM.USER_ID
                         , USM.DPJT_AUTH_TYPE, USM.DPJT_AUTH_STATUS, USM.DPJT_AUTH_TYPE_REQ
                         , USM.DPJT_CODE, USM.DPJT_SEQ, USM.DPJT_NAME
                      FROM SCM_MGR.SPMS_PROJECT_USER_MAP USM
                     WHERE 0 = 0
                       AND USM.DPJT_KEY         = P_DPJT_KEY
                       AND USM.DPJT_AUTH_TYPE  != 'ADMIN'       -- 관리자 제외
                )
                , WT_USER_LIST AS ( -- 대상 사용자 List : 원래 권한 있는 User + 신규 권한 User
                    SELECT USR.DPJT_KEY, USR.USER_ID
                      FROM WT_NEW_WRITE USR
                     WHERE 0 = 0
                    UNION
                    SELECT USM.DPJT_KEY, USM.USER_ID
                      FROM WT_AUTH_INFO USM
                     WHERE 0 = 0
                       AND USM.DPJT_KEY         = P_DPJT_KEY
                )
                -- 사용자 별 old Auth, New Auth, Req Aute 리스트
                SELECT USL.DPJT_KEY, USL.USER_ID
                     , USM.DPJT_AUTH_TYPE       AS OLD_AUTH_TYPE
                     , NWW.DPJT_AUTH_TYPE       AS NEW_AUTH_TYPE
                     , USM.DPJT_AUTH_TYPE_REQ   AS REQ_AUTH_TYPE
                     --
                     , PJM.DPJT_CODE, PJM.DPJT_SEQ, PJM.DPJT_NAME
                     , USR.USER_NAME
                  FROM WT_USER_LIST USL
                  LEFT OUTER JOIN
                       WT_AUTH_INFO USM
                    ON 0 = 0
                   AND USL.DPJT_KEY     = USM.DPJT_KEY
                   AND USL.USER_ID      = USM.USER_ID
                  LEFT OUTER JOIN
                       WT_NEW_WRITE NWW
                    ON 0 = 0
                   AND USL.DPJT_KEY     = NWW.DPJT_KEY
                   AND USL.USER_ID      = NWW.USER_ID
                  LEFT OUTER JOIN
                       SCM_MGR.SPMS_PROJECT_MST PJM
                    ON 0 = 0
                   AND USL.DPJT_KEY     = PJM.DPJT_KEY
                 INNER JOIN
                       SCM_MGR.SCM_MST_SSO_USER_INFO USR
                    ON 0 = 0
                   AND USL.USER_ID      = USR.USER_ID
                 WHERE 0 = 0
                   AND USL.DPJT_KEY     = P_DPJT_KEY
           ) DAT
        ON (
                0 = 0
            AND SRC.DPJT_KEY = DAT.DPJT_KEY
            AND SRC.USER_ID  = DAT.USER_ID
           )
      WHEN MATCHED THEN
    UPDATE
       SET SRC.LAST_UPDATED_BY      = P_SES_USER_ID
         , SRC.LAST_UPDATE_DATE     = SYSDATE
         , SRC.DPJT_AUTH_TYPE       = CASE
                                            -- READ 권한 대상이었고 신규 WRITE 권한이 없는 사용자는 수정 대상이 아님
                                            WHEN DAT.NEW_AUTH_TYPE IS NULL
                                             AND DAT.OLD_AUTH_TYPE = 'READ'
                                            THEN SRC.DPJT_AUTH_TYPE
                                            -- 신규 권한이 없는 경우 요청 권한 처리
                                            WHEN DAT.NEW_AUTH_TYPE IS NULL
                                            THEN DAT.REQ_AUTH_TYPE
                                            ELSE DAT.NEW_AUTH_TYPE
                                      END
         , SRC.DPJT_AUTH_STATUS     = CASE
                                            -- WRITE 권한이 존재하면 Confirmed
                                            WHEN DAT.NEW_AUTH_TYPE IS NOT NULL
                                            THEN 'CONFIRM'
                                            -- 권한 요청이 있고 WRITE 권한이 있었는데 없어지면 Reject
                                            WHEN DAT.OLD_AUTH_TYPE = 'WRITE'    -- Exists WRITE Auth
                                             AND DAT.NEW_AUTH_TYPE IS NULL      -- none WRITE Auth
                                             AND DAT.REQ_AUTH_TYPE IS NOT NULL  -- Exists Request
                                            THEN 'REJECT'
                                            --WHEN DAT.REQ_AUTH_TYPE IS NOT NULL  -- Exists Request
                                            --THEN 'REQUEST'
                                            -- 그 외 READ 권한 대상은 그대로 유지
                                            WHEN DAT.OLD_AUTH_TYPE = 'READ'
                                            THEN SRC.DPJT_AUTH_STATUS
                                            ELSE NULL
                                      END
    --DELETE WHERE SRC.DPJT_AUTH_TYPE IS NULL
      WHEN NOT MATCHED THEN
    INSERT (
                DPJT_KEY, USER_ID, DPJT_AUTH_TYPE, DPJT_AUTH_STATUS, DPJT_AUTH_TYPE_REQ
              , DPJT_CODE, DPJT_SEQ, DPJT_NAME
              , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
              , ATTRIBUTE1
           )
    VALUES (
                DAT.DPJT_KEY, DAT.USER_ID
              , 'WRITE', 'CONFIRM', NULL                            -- DPJT_AUTH_TYPE, DPJT_AUTH_STATUS, DPJT_AUTH_TYPE_REQ
              , DAT.DPJT_CODE, DAT.DPJT_SEQ, DAT.DPJT_NAME
              , P_SES_USER_ID, SYSDATE, P_SES_USER_ID, SYSDATE
              , DAT.USER_NAME
           )
    ;
    N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;

    COMMIT;

    N_EVENT_COUNT := N_EVENT_COUNT + N_DEL_COUNT + N_INSERT_COUNT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_EVENT_COUNT) AS EVENT FROM DUAL;


    RETURN;

    --=============================================================================================================
    -- VALIDATION FAIL 처리
    --=============================================================================================================
    <<VALIDATION_FAIL>>
    ROLLBACK;
    v_log_message := V_S_CODE;
    v_description := V_S_CODE || '^' || V_S_VALIDATION;
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


    OPEN O_RESULT_CURSOR FOR
    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_S_CODE || '^' || V_S_VALIDATION AS EVENT FROM DUAL;
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_ACTIVE_FLAG'         VALUE SUBSTR(P_ACTIVE_FLAG, 1, 200)
          , 'P_DPJT_KEY'            VALUE SUBSTR(P_DPJT_KEY, 1, 200)
          , 'P_USER_ID'             VALUE SUBSTR(P_USER_ID, 1, 200)
          , 'P_SES_DIVISION_ID'     VALUE P_SES_DIVISION_ID
          , 'P_SES_USER_ID'         VALUE P_SES_USER_ID
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_SAVE_POP_PJT_AUTH_WRITE;

PROCEDURE P_SDM1010_SAVE_POP_PJT_AUTH_READ
(
    P_ACTIVE_FLAG               IN VARCHAR2             -- I(Insert) / D(Delete) / M(Modify)
  , P_DPJT_KEY                  IN VARCHAR2
  , P_USER_ID                   IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010.P_SDM1010_SAVE_POP_PJT_AUTH_READ
 * Description  : 프로젝트 입력 권한 저장
 * Parameter    : PKG_SDM1010.P_SDM1010_SAVE_POP_PJT_AUTH_WRITE(P_ACTIVE_FLAG, P_DPJT_KEY, P_USER_ID, P_SES_DIVISION_ID, P_SES_USER_ID, O_RESULT_CURSOR)
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ         최초 작성
 *                          프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    V_ACTIVE_FLAG               VARCHAR2(10);
    V_DPJT_KEY                  VARCHAR2(50);
    V_USER_ID                   VARCHAR2(50);
    
    N_MAX_CNT                   PLS_INTEGER := 0;
    V_SES_USER_ID               VARCHAR2(50) := P_SES_USER_ID;

    --=============================================================================================================
    -- LOG 용 변수 설정
    --=============================================================================================================
    V_LOG_TYPE                  VARCHAR2(30 CHAR);
    N_LOG_COUNT                 PLS_INTEGER := 0;
    V_LOG_MESSAGE               VARCHAR2(1000 CHAR);
    V_DESCRIPTION               VARCHAR2(4000 CHAR);
    D_EVENT_DATE                DATE;
    N_DEL_COUNT                 PLS_INTEGER := 0;
    N_INSERT_COUNT              PLS_INTEGER := 0;
    N_EVENT_COUNT               PLS_INTEGER := 0;
    -- 프로그램명 (로그용)
    V_PROGRAM_NAME          VARCHAR2(150);

    --=============================================================================================================
    -- VALIDATION 변수
    --=============================================================================================================
    V_S_VALIDATION              VARCHAR2(4000 CHAR) := NULL;
    V_S_CODE                    VARCHAR2(50 CHAR)   := NULL;

    --=============================================================================================================
    -- VERSION 변수
    --=============================================================================================================
    v_max_mf_w_version          VARCHAR2(100 CHAR);
    v_max_mf_w_yyyymmdd         VARCHAR2(8 CHAR);
    v_max_sf_w_version          VARCHAR2(100 CHAR);
    v_max_sf_w_yyyymmdd         VARCHAR2(8 CHAR);
    v_cutoff_start              VARCHAR2(8 CHAR);
    v_cutoff_end                VARCHAR2(8 CHAR);

    --=============================================================================================================
    -- EXCEPTION 변수
    --=============================================================================================================
    V_PROC_INPUT                VARCHAR2(4000 CHAR);
    V_BACKTRACE                 VARCHAR2(4000 CHAR);
    V_SQL_CODE                  VARCHAR2(100 CHAR);
    V_SQL_ERRMSG                VARCHAR2(1000 CHAR);

    N_CNT                       NUMBER;

BEGIN
    --[E20260806-DS2] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어 (2026-08-06 사용자 지시)
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    --=============================================================================================================
    -- 시작 LOG
    --=============================================================================================================
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    -- 
    
     MERGE INTO SCM_MGR.SPMS_PROJECT_USER_MAP SRC
     USING (
                WITH WT_NEW_WRITE AS (
                    SELECT NR AS ROW_KEY, TOKEN AS USER_ID
                         , 'READ' DPJT_AUTH_TYPE, P_DPJT_KEY AS DPJT_KEY
                      FROM SCM_MGR.UF_FX_STRING_SPLIT(P_USER_ID, '^')
                )
                , WT_AUTH_INFO AS ( -- 대상 Project 사용자 별 권한 정보
                    SELECT USM.DPJT_KEY, USM.USER_ID
                         , USM.DPJT_AUTH_TYPE, USM.DPJT_AUTH_STATUS, USM.DPJT_AUTH_TYPE_REQ
                         , USM.DPJT_CODE, USM.DPJT_SEQ, USM.DPJT_NAME
                      FROM SCM_MGR.SPMS_PROJECT_USER_MAP USM
                     WHERE 0 = 0
                       AND USM.DPJT_KEY         = P_DPJT_KEY
                       AND USM.DPJT_AUTH_TYPE  != 'ADMIN'       -- 관리자 제외
                )
                , WT_USER_LIST AS ( -- 대상 사용자 List : 원래 권한 있는 User + 신규 권한 User
                    SELECT USR.DPJT_KEY, USR.USER_ID
                      FROM WT_NEW_WRITE USR
                     WHERE 0 = 0
                    UNION
                    SELECT USM.DPJT_KEY, USM.USER_ID
                      FROM WT_AUTH_INFO USM
                     WHERE 0 = 0
                       AND USM.DPJT_KEY         = P_DPJT_KEY
                )
                -- 사용자 별 old Auth, New Auth, Req Aute 리스트
                SELECT USL.DPJT_KEY, USL.USER_ID
                     , USM.DPJT_AUTH_TYPE       AS OLD_AUTH_TYPE
                     , NWW.DPJT_AUTH_TYPE       AS NEW_AUTH_TYPE
                     , USM.DPJT_AUTH_TYPE_REQ   AS REQ_AUTH_TYPE
                     --
                     , PJM.DPJT_CODE, PJM.DPJT_SEQ, PJM.DPJT_NAME
                     , USR.USER_NAME
                  FROM WT_USER_LIST USL
                  LEFT OUTER JOIN
                       WT_AUTH_INFO USM
                    ON 0 = 0
                   AND USL.DPJT_KEY     = USM.DPJT_KEY
                   AND USL.USER_ID      = USM.USER_ID
                  LEFT OUTER JOIN
                       WT_NEW_WRITE NWW
                    ON 0 = 0
                   AND USL.DPJT_KEY     = NWW.DPJT_KEY
                   AND USL.USER_ID      = NWW.USER_ID
                  LEFT OUTER JOIN
                       SCM_MGR.SPMS_PROJECT_MST PJM
                    ON 0 = 0
                   AND USL.DPJT_KEY     = PJM.DPJT_KEY
                 INNER JOIN
                       SCM_MGR.SCM_MST_SSO_USER_INFO USR
                    ON 0 = 0
                   AND USL.USER_ID      = USR.USER_ID
                 WHERE 0 = 0
                   AND USL.DPJT_KEY     = P_DPJT_KEY
           ) DAT
        ON (
                0 = 0
            AND SRC.DPJT_KEY = DAT.DPJT_KEY
            AND SRC.USER_ID  = DAT.USER_ID
           )
      WHEN MATCHED THEN
    UPDATE
       SET SRC.LAST_UPDATED_BY      = P_SES_USER_ID
         , SRC.LAST_UPDATE_DATE     = SYSDATE
         , SRC.DPJT_AUTH_TYPE       = CASE
                                            -- WRITE 권한 대상이었고 신규 READ 권한이 없는 사용자는 수정 대상이 아님
                                            WHEN DAT.NEW_AUTH_TYPE IS NULL
                                             AND DAT.OLD_AUTH_TYPE = 'WRITE'
                                            THEN SRC.DPJT_AUTH_TYPE
                                            -- 신규 권한이 없는 경우 요청 권한 처리
                                            WHEN DAT.NEW_AUTH_TYPE IS NULL
                                            THEN DAT.REQ_AUTH_TYPE
                                            ELSE DAT.NEW_AUTH_TYPE
                                      END
         , SRC.DPJT_AUTH_STATUS     = CASE
                                            -- WRITE 권한이 존재하면 Confirmed
                                            WHEN DAT.NEW_AUTH_TYPE IS NOT NULL
                                            THEN 'CONFIRM'
                                            -- 권한 요청이 있고 READ 권한이 있었는데 없어지면 Reject
                                            WHEN DAT.OLD_AUTH_TYPE = 'READ'     -- Exists READ Auth
                                             AND DAT.NEW_AUTH_TYPE IS NULL      -- none READ Auth
                                             AND DAT.REQ_AUTH_TYPE IS NOT NULL  -- Exists Request
                                            THEN 'REJECT'
                                            --WHEN DAT.REQ_AUTH_TYPE IS NOT NULL  -- Exists Request
                                            --THEN 'REQUEST'
                                            -- 그 외 WRITE 권한 대상은 그대로 유지
                                            WHEN DAT.OLD_AUTH_TYPE = 'WRITE'
                                            THEN SRC.DPJT_AUTH_STATUS
                                            ELSE NULL
                                      END
    --DELETE WHERE SRC.DPJT_AUTH_TYPE IS NULL
      WHEN NOT MATCHED THEN
    INSERT (
                DPJT_KEY, USER_ID, DPJT_AUTH_TYPE, DPJT_AUTH_STATUS, DPJT_AUTH_TYPE_REQ
              , DPJT_CODE, DPJT_SEQ, DPJT_NAME
              , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
              , ATTRIBUTE1
           )
    VALUES (
                DAT.DPJT_KEY, DAT.USER_ID
              , 'READ', 'CONFIRM', NULL                             -- DPJT_AUTH_TYPE, DPJT_AUTH_STATUS, DPJT_AUTH_TYPE_REQ
              , DAT.DPJT_CODE, DAT.DPJT_SEQ, DAT.DPJT_NAME
              , P_SES_USER_ID, SYSDATE, P_SES_USER_ID, SYSDATE
              , DAT.USER_NAME
           )
    ;
    N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;

    COMMIT;

    N_EVENT_COUNT := N_EVENT_COUNT + N_DEL_COUNT + N_INSERT_COUNT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_EVENT_COUNT) AS EVENT FROM DUAL;


    RETURN;

    --=============================================================================================================
    -- VALIDATION FAIL 처리
    --=============================================================================================================
    <<VALIDATION_FAIL>>
    ROLLBACK;
    v_log_message := V_S_CODE;
    v_description := V_S_CODE || '^' || V_S_VALIDATION;
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


    OPEN O_RESULT_CURSOR FOR
    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_S_CODE || '^' || V_S_VALIDATION AS EVENT FROM DUAL;
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_ACTIVE_FLAG'         VALUE SUBSTR(P_ACTIVE_FLAG, 1, 200)
          , 'P_DPJT_KEY'            VALUE SUBSTR(P_DPJT_KEY, 1, 200)
          , 'P_USER_ID'             VALUE SUBSTR(P_USER_ID, 1, 200)
          , 'P_SES_DIVISION_ID'     VALUE P_SES_DIVISION_ID
          , 'P_SES_USER_ID'         VALUE P_SES_USER_ID
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_SAVE_POP_PJT_AUTH_READ;

-- 프로젝트 권한 요청 반려
PROCEDURE P_SDM1010_SAVE_POP_BTN_REJECT
(
    P_DPJT_KEY                  IN VARCHAR2
  , P_USER_ID                   IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010.P_SDM1010_SAVE_POP_BTN_REJECT
 * Description  : 프로젝트 권한 요청 반려
 * Parameter    : PKG_SDM1010.P_SDM1010_SAVE_POP_BTN_REJECT(P_DPJT_KEY, P_USER_ID, P_SES_USER_ID, O_RESULT_CURSOR)
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ         최초 작성
 *                          프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    V_DPJT_KEY                  VARCHAR2(50) := P_DPJT_KEY;
    V_USER_ID                   VARCHAR2(50) := P_USER_ID;
    
    N_MAX_CNT                   PLS_INTEGER := 0;
    V_SES_USER_ID               VARCHAR2(50) := P_SES_USER_ID;

    --=============================================================================================================
    -- LOG 용 변수 설정
    --=============================================================================================================
    V_LOG_TYPE                  VARCHAR2(30 CHAR);
    N_LOG_COUNT                 PLS_INTEGER := 0;
    V_LOG_MESSAGE               VARCHAR2(1000 CHAR);
    V_DESCRIPTION               VARCHAR2(4000 CHAR);
    D_EVENT_DATE                DATE;
    N_DEL_COUNT                 PLS_INTEGER := 0;
    N_INSERT_COUNT              PLS_INTEGER := 0;
    N_EVENT_COUNT               PLS_INTEGER := 0;
    -- 프로그램명 (로그용)
    V_PROGRAM_NAME          VARCHAR2(150);

    --=============================================================================================================
    -- VALIDATION 변수
    --=============================================================================================================
    V_S_VALIDATION              VARCHAR2(4000 CHAR) := NULL;
    V_S_CODE                    VARCHAR2(50 CHAR)   := NULL;

    --=============================================================================================================
    -- VERSION 변수
    --=============================================================================================================
    v_max_mf_w_version          VARCHAR2(100 CHAR);
    v_max_mf_w_yyyymmdd         VARCHAR2(8 CHAR);
    v_max_sf_w_version          VARCHAR2(100 CHAR);
    v_max_sf_w_yyyymmdd         VARCHAR2(8 CHAR);
    v_cutoff_start              VARCHAR2(8 CHAR);
    v_cutoff_end                VARCHAR2(8 CHAR);

    --=============================================================================================================
    -- EXCEPTION 변수
    --=============================================================================================================
    V_PROC_INPUT                VARCHAR2(4000 CHAR);
    V_BACKTRACE                 VARCHAR2(4000 CHAR);
    V_SQL_CODE                  VARCHAR2(100 CHAR);
    V_SQL_ERRMSG                VARCHAR2(1000 CHAR);

    N_CNT                       NUMBER;

BEGIN
    --[E20260806-DS2] GT/GTT 사용 SP 표준 — 클라우드 optimizer_dynamic_sampling=0 방어 (2026-08-06 사용자 지시)
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    --=============================================================================================================
    -- 시작 LOG
    --=============================================================================================================
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    -- 반려 Process 처리
    UPDATE SCM_MGR.SPMS_PROJECT_USER_MAP
       SET LAST_UPDATED_BY      = V_SES_USER_ID
         , LAST_UPDATE_DATE     = SYSDATE
         --
         , DPJT_AUTH_STATUS     = 'REJECT'
         , DPJT_AUTH_TYPE       = DPJT_AUTH_TYPE_REQ    -- 반려하는 경우 권한 구분은 요청 권한으로 설정
     WHERE DPJT_KEY             = V_DPJT_KEY
       AND USER_ID              = V_USER_ID
       AND DPJT_AUTH_TYPE_REQ   IS NOT NULL
    ;
    N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;

    COMMIT;

    N_EVENT_COUNT := N_EVENT_COUNT + N_DEL_COUNT + N_INSERT_COUNT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_EVENT_COUNT) AS EVENT FROM DUAL;


    RETURN;

    --=============================================================================================================
    -- VALIDATION FAIL 처리
    --=============================================================================================================
    <<VALIDATION_FAIL>>
    ROLLBACK;
    v_log_message := V_S_CODE;
    v_description := V_S_CODE || '^' || V_S_VALIDATION;
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


    OPEN O_RESULT_CURSOR FOR
    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_S_CODE || '^' || V_S_VALIDATION AS EVENT FROM DUAL;
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
              'P_DPJT_KEY'          VALUE P_DPJT_KEY
            , 'P_USER_ID'           VALUE P_USER_ID
            , 'P_SES_USER_ID'       VALUE P_SES_USER_ID
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_SAVE_POP_BTN_REJECT;

-- My Work
PROCEDURE P_SDM1010_GET_POP_MY_WORK (
    P_DIVISION_ID               IN VARCHAR2
  , P_DPJT_KEY                  IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010.P_SDM1010_GET_POP_MY_WORK
 * Description  : Organization List
 * Parameter    : 
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ         최초 작성
 *                          프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100  CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
    n_log_count         PLS_INTEGER := 0;
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;


BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    OPEN O_CURSOR FOR
        SELECT PJM.DPJT_KEY, PJM.DPJT_CODE, PJM.DPJT_SEQ
             , PJM.DIVISION_ID, DIV.DIVISION_ID DIVISION_NAME
             , PJM.DPJT_CLASS, PCL.DPJT_CLASS_NAME
             , PJM.END_CUSTOMER, NVL(EDC.END_CUSTOMER_NAME, PJM.END_CUSTOMER) END_CUSTOMER_NAME
             , PJM.DPJT_NAME
             --
             , TO_DATE('20260701', 'YYYYMMDD') AS SAMPLE_A_DATE
             , TO_DATE('20261001', 'YYYYMMDD') AS SAMPLE_B_DATE
             , TO_DATE('20260104', 'YYYYMMDD') AS SAMPLE_C_DATE
             , TO_DATE('20260402', 'YYYYMMDD') AS SAMPLE_D_DATE
             --
             , PJM.SOP_DATE
             , PJM.SOP_PLANT_ID, NVL(PLT.SOP_PLANT_NAME, PJM.SOP_PLANT_ID) AS SOP_PLANT_NAME
          FROM SCM_MGR.SPMS_PROJECT_MST PJM
         INNER JOIN
               SCM_MGR.SCM_MST_DIVISION DIV
            ON 0 = 0
           AND PJM.DIVISION_ID = DIV.DIVISION_ID
         INNER JOIN
               (
                    SELECT LKD.SEGMENT1 AS DPJT_CLASS_ID
                         , LKD.SEGMENT2 AS DPJT_CLASS_NAME
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_DPJT_CLASS'
                       AND LKM.VALID_YN = 'Y'
               ) PCL
            ON 0 = 0
           AND PJM.DPJT_CLASS = PCL.DPJT_CLASS_ID
          LEFT OUTER JOIN
               (
                    SELECT DISTINCT
                           SIT.DIVISION_ID, SIT.END_CUSTOMER, SIT.END_CUSTOMER END_CUSTOMER_NAME
                      FROM SCM_MGR.SCM_MST_SITE SIT
                     WHERE 0 = 0
               ) EDC
            ON 0 = 0
           AND PJM.DIVISION_ID  = EDC.DIVISION_ID
           AND PJM.END_CUSTOMER = EDC.END_CUSTOMER
          LEFT OUTER JOIN
               (
                    SELECT DISTINCT
                           SIT.DIVISION_ID, SIT.PLANT_ID SOP_PLANT_ID, SIT.PLANT_ID SOP_PLANT_NAME
                      FROM SCM_MGR.SCM_MST_PLANT_SN SIT
                     WHERE 0 = 0
                     /*
                    SELECT DISTINCT
                           SIT.DIVISION_ID, SIT.SCM_SITE_ID SOP_PLANT_ID, SIT.SCM_SITE_ID SOP_PLANT_NAME
                      FROM SCM_MGR.SCM_MST_SITE SIT
                     WHERE 0 = 0
                       AND SIT.SITE_TYPE = 'PLANT'
                       */
               ) PLT
            ON 0 = 0
           AND PJM.DIVISION_ID  = PLT.DIVISION_ID
           AND PJM.SOP_PLANT_ID = PLT.SOP_PLANT_ID
         WHERE 0 = 0
           --
           --AND PJM.DIVISION_ID  = P_DIVISION_ID
           AND PJM.DPJT_KEY     = P_DPJT_KEY
        ;
    
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_DIVISION_ID'                 VALUE P_DIVISION_ID
          , 'P_DPJT_KEY'                    VALUE P_DPJT_KEY
          , 'P_SES_USER_ID'                 VALUE P_SES_USER_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION', '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_GET_POP_MY_WORK;

-- 조회구간 정보 (Default 값)
PROCEDURE P_SDM1010_GET_PERIOD (
    P_FR_BUCKET                 IN VARCHAR2         -- From 일자 계산 기준 Bucket 값 - D(Day) / W(Week) / PW(Partial Week) / M(Month) / Y(Year)
  , P_FR_DATE_VAL               IN VARCHAR2         -- From 일자 계산 값 - 음수 가능
  , P_FR_BUCKET_TYPE            IN VARCHAR2         -- From 일자 지정 기준 - S : Bucket 시작일 / E : Bucket 종료일 / C : 해당일
  , P_TO_BUCKET                 IN VARCHAR2         -- to   일자 계산 기준 Bucket 값
  , P_TO_DATE_VAL               IN VARCHAR2         -- to   일자 계산 값
  , P_TO_BUCKET_TYPE            IN VARCHAR2         -- to   일자 지정 기준 - S : Bucket 시작일 / E : Bucket 종료일 / C : 해당일 / X : From 일자만 반환
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1010.P_SDM1010_GET_PERIOD
 * Description  : 날짜 구간 값 반환 : 조회조건 Default 값
 * Parameter    : 
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.12   KTJ         최초 작성
 *                          프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100  CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
    n_log_count         PLS_INTEGER := 0;
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

    D_TODAY             DATE := TRUNC(SYSDATE);
    D_FR_BASE           DATE;
    D_TO_BASE           DATE;
    N_FR_DATE_VAL       INTEGER := TO_NUMBER(P_FR_DATE_VAL);
    N_TO_DATE_VAL       INTEGER := TO_NUMBER(P_TO_DATE_VAL);
    D_FR_DATE           DATE;
    D_TO_DATE           DATE;

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;
    
    -- Calendar 참고 : SCM_SYS_CALENDAR_M - Week 관련 해당 테이블 참조 필요
    
    -- 1. 구간 시작일자 산정
    IF    UPPER(P_FR_BUCKET) IN ('D', 'DAY') THEN
        D_FR_BASE := D_TODAY + N_FR_DATE_VAL;
        D_FR_DATE := D_FR_BASE;
    ELSIF UPPER(P_FR_BUCKET) IN ('W', 'WK', 'WEEK') THEN
        D_FR_BASE := D_TODAY + ( N_FR_DATE_VAL * 7 );
        -- 시작일 기준
        IF    UPPER(P_FR_BUCKET_TYPE) IN ('S', 'START') THEN
            D_FR_DATE := TRUNC(D_FR_BASE, 'IW');    -- 월요일 기준
            --D_FR_DATE := TRUNC(D_FR_BASE, 'D');     -- 일요일 기준
        -- 종료일 기준
        ELSIF UPPER(P_FR_BUCKET_TYPE) IN ('E', 'END') THEN
            D_FR_DATE := TRUNC(D_FR_BASE, 'IW') + 6;    -- 월요일 기준
            --D_FR_DATE := TRUNC(D_FR_BASE, 'D') + 6;     -- 일요일 기준
        ELSE
            D_FR_DATE := D_FR_BASE;
        END IF;
    ELSIF UPPER(P_FR_BUCKET) IN ('M', 'MON', 'MONTH') THEN
        D_FR_DATE := ADD_MONTHS(D_TODAY, N_FR_DATE_VAL);
        -- 시작일 기준
        IF    UPPER(P_FR_BUCKET_TYPE) IN ('S', 'START') THEN
            D_FR_DATE := TRUNC(D_FR_DATE, 'MONTH');
        -- 종료일 기준
        ELSIF UPPER(P_FR_BUCKET_TYPE) IN ('E', 'END') THEN
            D_FR_DATE := LAST_DAY(D_FR_DATE);
        ELSE
            D_FR_DATE := D_FR_BASE;
        END IF;
    END IF;
    
    -- 2. 구간 종료일자 산정
    IF    UPPER(P_FR_BUCKET) IN ('D', 'DAY') THEN
        D_TO_BASE := D_TODAY + N_TO_DATE_VAL;
        D_TO_DATE := D_TO_BASE;
    ELSIF UPPER(P_FR_BUCKET) IN ('W', 'WK', 'WEEK') THEN
        D_TO_BASE := D_TODAY + ( N_TO_DATE_VAL * 7 );
        -- 시작일 기준
        IF    UPPER(P_TO_BUCKET_TYPE) IN ('S', 'START') THEN
            D_TO_DATE := TRUNC(D_TO_BASE, 'IW');    -- 월요일 기준
            --D_TO_DATE := TRUNC(D_TO_BASE, 'D');     -- 일요일 기준
        -- 종료일 기준
        ELSIF UPPER(P_TO_BUCKET_TYPE) IN ('E', 'END') THEN
            D_TO_DATE := TRUNC(D_TO_BASE, 'IW') + 6;    -- 월요일 기준
            --D_TO_DATE := TRUNC(D_TO_BASE, 'D') + 6;     -- 일요일 기준
        ELSE
            D_TO_DATE := D_TO_BASE;
        END IF;
    ELSIF UPPER(P_TO_BUCKET) IN ('M', 'MON', 'MONTH') THEN
        D_TO_DATE := ADD_MONTHS(D_TODAY, N_TO_DATE_VAL);
        -- 시작일 기준
        IF    UPPER(P_TO_BUCKET_TYPE) IN ('S', 'START') THEN
            D_TO_DATE := TRUNC(D_TO_DATE, 'MONTH');
        -- 종료일 기준
        ELSIF UPPER(P_TO_BUCKET_TYPE) IN ('E', 'END') THEN
            D_TO_DATE := LAST_DAY(D_TO_DATE);
        ELSE
            D_TO_DATE := D_TO_BASE;
        END IF;
    END IF;
    
    IF P_TO_BUCKET_TYPE = 'X' THEN
        OPEN O_CURSOR FOR
            SELECT D_FR_DATE AS DATE_FR
                 , TO_CHAR(D_FR_DATE, 'YYYYMMDD') AS YMD_FR
              FROM DUAL
             WHERE 0 = 0
            ;
    ELSE
        OPEN O_CURSOR FOR
            SELECT D_FR_DATE AS DATE_FR
                 , TO_CHAR(D_FR_DATE, 'YYYYMMDD') AS YMD_FR
                 , D_TO_DATE DATE_TO
                 , TO_CHAR(D_TO_DATE, 'YYYYMMDD') AS YMD_TO
              FROM DUAL
             WHERE 0 = 0
            ;
    END IF;
    
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_FR_BUCKET'                   VALUE P_FR_BUCKET
          , 'P_FR_DATE_VAL'                 VALUE P_FR_DATE_VAL
          , 'P_FR_BUCKET_TYPE'              VALUE P_FR_BUCKET_TYPE
          , 'P_TO_BUCKET'                   VALUE P_TO_BUCKET
          , 'P_TO_DATE_VAL'                 VALUE P_TO_DATE_VAL
          , 'P_TO_BUCKET_TYPE'              VALUE P_TO_BUCKET_TYPE
          , 'P_SES_USER_ID'                 VALUE P_SES_USER_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', n_log_count, 'EXCEPTION', '', SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM1010_GET_PERIOD;

END PKG_SDM1010;
/
SHOW ERRORS PACKAGE BODY PKG_SDM1010
