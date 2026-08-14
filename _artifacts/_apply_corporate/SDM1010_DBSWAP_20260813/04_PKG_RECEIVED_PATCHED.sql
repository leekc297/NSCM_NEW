CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SDM1010 AS
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

-- 프로젝트 등록 조회
PROCEDURE P_SDM1010_GET_TAB1_PJT_REG (
    P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , P_SES_MENU_ID               IN VARCHAR2
  , P_SES_USER_GR_ID            IN VARCHAR2         -- 권한 그룹

  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
);

-- 프로젝트 등록 저장
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
);

-- 프로젝트 등록요청
PROCEDURE P_SDM1010_BTN_REQ_PJT_REG
(
    P_DIVISION_ID               IN VARCHAR2
  , P_DPJT_KEY                  IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
);

-- 프로젝트 요청취소
PROCEDURE P_SDM1010_BTN_CANCEL_PJT_REG
(
    P_DIVISION_ID               IN VARCHAR2
  , P_DPJT_KEY                  IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
);

-- 나의 프로젝트 리스트
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
);

-- 조직도
PROCEDURE P_SDM1010_GET_POP_USER_ORG (
    P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
);

-- 사용자 목록
PROCEDURE P_SDM1010_GET_POP_USER_BY_DEPT (
    P_USER_INFO                 IN VARCHAR2
  , P_DEPT_ID                   IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
);

-- 입력 권한 사용자 목록
PROCEDURE P_SDM1010_GET_POP_PJT_AUTH_WRITE (
    P_DPJT_KEY                  IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
);

-- 조회 권한 사용자 목록
PROCEDURE P_SDM1010_GET_POP_PJT_AUTH_READ (
    P_DPJT_KEY                  IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
);

-- 권한 요청 사용자 목록
PROCEDURE P_SDM1010_GET_POP_PJT_AUTH_REQ (
    P_DPJT_KEY                  IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
);

-- 프로젝트 입력 권한 저장
PROCEDURE P_SDM1010_SAVE_POP_PJT_AUTH_WRITE
(
    P_ACTIVE_FLAG               IN VARCHAR2             -- I(Insert) / D(Delete) / M(Modify)
  , P_DPJT_KEY                  IN VARCHAR2
  , P_USER_ID                   IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
);

-- 프로젝트 보기 권한 저장
PROCEDURE P_SDM1010_SAVE_POP_PJT_AUTH_READ
(
    P_ACTIVE_FLAG               IN VARCHAR2             -- I(Insert) / D(Delete) / M(Modify)
  , P_DPJT_KEY                  IN VARCHAR2
  , P_USER_ID                   IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
);

-- 프로젝트 권한 요청 반려
PROCEDURE P_SDM1010_SAVE_POP_BTN_REJECT
(
    P_DPJT_KEY                  IN VARCHAR2
  , P_USER_ID                   IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
);

-- My Work
PROCEDURE P_SDM1010_GET_POP_MY_WORK (
    P_DIVISION_ID               IN VARCHAR2
  , P_DPJT_KEY                  IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
);

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
);

END PKG_SDM1010;

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SDM1010 AS
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
             , PJM.END_CUSTOMER , EDC.END_CUSTOMER_NAME
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
         INNER JOIN
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
                       --AND USM.SPMS_DPJT_AUTH_STATUS != 'REQUEST'
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    
    -- ^ 구분자 row 정보를 테이블 형태로 생성 참고 
    --SELECT * FROM UF_FX_String_Split('01MDP2949A9B11^02MDP2949A9B11^03MDP2949A9B11^04MDP2949A9B11^05MDP2949A9B11', '^')
    
    -- ^ 구분자로 전달받은 Grid 데이터의 Row 수 추출
    N_MAX_CNT := REGEXP_COUNT(P_ACTIVE_FLAG, '\^') + 1;
    
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
        D_SOP_DATE          := TO_DATE(TRIM(REGEXP_SUBSTR(P_SOP_DATE,   '[^\^]+', 1, i)), 'YYYY-MM-DD HH24:MI:SS');
        V_SOP_PLANT_ID      := TRIM(REGEXP_SUBSTR(P_SOP_PLANT_ID,       '[^\^]+', 1, i));
    
        -- 1. 신규 등록
        IF V_ACTIVE_FLAG = 'I' -- I(Insert) / D(Delete) / M(Modify)
            -- 필수항목 조건
            AND V_DPJT_NAME IS NOT NULL /* [E20260813-EMPTYCHK] NVL(x,'')!='' 항상 UNKNOWN 정정 */
            AND V_DIVISION_ID IS NOT NULL /* [E20260813-EMPTYCHK] NVL(x,'')!='' 항상 UNKNOWN 정정 */
            AND V_DPJT_CLASS IS NOT NULL /* [E20260813-EMPTYCHK] NVL(x,'')!='' 항상 UNKNOWN 정정 */
            AND V_END_CUSTOMER IS NOT NULL /* [E20260813-EMPTYCHK] NVL(x,'')!='' 항상 UNKNOWN 정정 */
            AND V_CELL_TYPE IS NOT NULL /* [E20260813-EMPTYCHK] NVL(x,'')!='' 항상 UNKNOWN 정정 */
            AND V_STACK_METHOD IS NOT NULL /* [E20260813-EMPTYCHK] NVL(x,'')!='' 항상 UNKNOWN 정정 */
            AND V_BIZ_TYPE IS NOT NULL /* [E20260813-EMPTYCHK] NVL(x,'')!='' 항상 UNKNOWN 정정 */
        THEN
            
            -- 임시 DPJT_CODE 생성
            V_DPJT_CODE := 'TEMP_' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF6');
            N_DPJT_SEQ  := 1;
            V_DPJT_KEY  := V_DPJT_CODE || '_' || TO_CHAR(N_DPJT_SEQ, '000000');
            
            -- 프로젝트 등록 상태 : DRAFT
            SELECT LMT.SEGMENT1 INTO V_DPJT_REG_STATUS
              FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LMT
             WHERE LMT.LOOKUP_TYPE = 'SPMS_DPJT_REG_STATUS'
               AND LMT.SEGMENT1 = 'DRAFT'
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
              , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
            )
            SELECT V_DPJT_KEY DPJT_KEY, V_DPJT_CODE DPJT_CODE, N_DPJT_SEQ DPJT_SEQ
                 , V_DPJT_NAME DPJT_NAME, V_DIVISION_ID DIVISION_ID, V_DPJT_CLASS DPJT_CLASS
                 , V_END_CUSTOMER END_CUSTOMER, V_CELL_TYPE CELL_TYPE, V_BIZ_TYPE BIZ_TYPE, V_STACK_METHOD STACK_METHOD
                 , D_SOP_DATE SOP_DATE, V_SOP_PLANT_ID SOP_PLANT_ID
                 , V_user_id MGMT_USER_ID, V_DPJT_REG_STATUS DPJT_REG_STATUS, NULL REG_REQ_DATE, NULL REG_MOD_DATE, NULL REG_COMP_DATE, NULL DPJT_DEVELOP_STATUS
                 , V_SPMS_DPJT_REG_CAT DPJT_REG_CAT, NULL NOTE
                 , V_USER_ID CREATED_BY, SYSDATE CREATION_DATE, V_USER_ID LAST_UPDATED_BY, SYSDATE LAST_UPDATE_DATE
              FROM DUAL
            ;
            N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;
        END IF;
            
        -- 2. 수정
        IF V_ACTIVE_FLAG = 'M' -- I(Insert) / D(Delete) / M(Modify)
            -- 필수항목 조건
            AND V_DPJT_KEY IS NOT NULL /* [E20260813-EMPTYCHK] NVL(x,'')!='' 항상 UNKNOWN 정정 */
            AND V_DPJT_CODE IS NOT NULL /* [E20260813-EMPTYCHK] NVL(x,'')!='' 항상 UNKNOWN 정정 */
            AND N_DPJT_SEQ IS NOT NULL /* [E20260813-EMPTYCHK] NVL(x,'')!='' 항상 UNKNOWN 정정 */
        THEN
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
                 , SRC.DPJT_NAME            = CASE WHEN SRC.DPJT_NAME = DAT.DPJT_NAME           THEN SRC.DPJT_NAME      ELSE DAT.DPJT_NAME      END
                 , SRC.DIVISION_ID          = CASE WHEN SRC.DIVISION_ID = DAT.DIVISION_ID       THEN SRC.DIVISION_ID    ELSE DAT.DIVISION_ID    END
                 , SRC.DPJT_CLASS           = CASE WHEN SRC.DPJT_CLASS = DAT.DPJT_CLASS         THEN SRC.DPJT_CLASS     ELSE DAT.DPJT_CLASS     END
                 , SRC.END_CUSTOMER         = CASE WHEN SRC.END_CUSTOMER = DAT.END_CUSTOMER     THEN SRC.END_CUSTOMER   ELSE DAT.END_CUSTOMER   END
                 , SRC.CELL_TYPE            = CASE WHEN SRC.CELL_TYPE = DAT.CELL_TYPE           THEN SRC.CELL_TYPE      ELSE DAT.CELL_TYPE      END
                 , SRC.BIZ_TYPE             = CASE WHEN SRC.BIZ_TYPE = DAT.BIZ_TYPE             THEN SRC.BIZ_TYPE       ELSE DAT.BIZ_TYPE       END
                 , SRC.STACK_METHOD         = CASE WHEN SRC.STACK_METHOD = DAT.STACK_METHOD     THEN SRC.STACK_METHOD   ELSE DAT.STACK_METHOD   END
                 , SRC.SOP_DATE             = CASE WHEN SRC.SOP_DATE = DAT.SOP_DATE             THEN SRC.SOP_DATE       ELSE DAT.SOP_DATE       END
                 --, SRC.SOP_DATE             = DAT.SOP_DATE
                 , SRC.SOP_PLANT_ID         = CASE WHEN SRC.SOP_PLANT_ID = DAT.SOP_PLANT_ID     THEN SRC.SOP_PLANT_ID   ELSE DAT.SOP_PLANT_ID   END
             WHERE 0 = 0
               -- 수정 내역이 존재해야 저장
               AND NOT (
                        0 = 0
                    AND SRC.DPJT_NAME       = DAT.DPJT_NAME
                    AND SRC.DIVISION_ID     = DAT.DIVISION_ID
                    AND SRC.DPJT_CLASS      = DAT.DPJT_CLASS
                    AND SRC.END_CUSTOMER    = DAT.END_CUSTOMER
                    AND SRC.CELL_TYPE       = DAT.CELL_TYPE
                    AND SRC.BIZ_TYPE        = DAT.BIZ_TYPE
                    AND SRC.STACK_METHOD    = DAT.STACK_METHOD
                    AND SRC.SOP_DATE        = DAT.SOP_DATE
                    AND SRC.SOP_PLANT_ID    = DAT.SOP_PLANT_ID
                   )
            ;
            N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;
        END IF;
            
        -- 3. 삭제
        IF V_ACTIVE_FLAG = 'D' -- I(Insert) / D(Delete) / M(Modify)
            -- 필수항목 조건
            AND V_DPJT_KEY IS NOT NULL /* [E20260813-EMPTYCHK] NVL(x,'')!='' 항상 UNKNOWN 정정 */
            AND V_DPJT_CODE IS NOT NULL /* [E20260813-EMPTYCHK] NVL(x,'')!='' 항상 UNKNOWN 정정 */
            AND N_DPJT_SEQ IS NOT NULL /* [E20260813-EMPTYCHK] NVL(x,'')!='' 항상 UNKNOWN 정정 */
        THEN
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
                           AND LMT.SEGMENT1         IN ('WRITING','DRAFT') -- 작성중·신규(DRAFT)
                           -- [E20260813-DRAFTGUARD] INSERT 초기상태 'DRAFT' 가 가드에 없어 신규행 삭제 불가 — 발신처 확인 대기 임시 확장
                           --AND LMT.SEGMENT2       = '작성중'
                           --
                           AND LMT.SEGMENT1         = PJT.DPJT_REG_STATUS
                   )
            ;
            N_DEL_COUNT := N_DEL_COUNT + SQL%ROWCOUNT;
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


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
          , 'P_DPJT_CODE'       VALUE SUBSTR(P_DPJT_CODE, 1,200)
          , 'P_DPJT_SEQ'        VALUE SUBSTR(P_DPJT_SEQ, 1,200)
          , 'P_DIVISION_ID'     VALUE SUBSTR(P_DIVISION_ID, 1,200)
          , 'P_DPJT_CLASS'      VALUE SUBSTR(P_DPJT_CLASS, 1,200)
          , 'P_END_CUSTOMER'    VALUE SUBSTR(P_END_CUSTOMER, 1,200)
          , 'P_DPJT_NAME'       VALUE SUBSTR(P_DPJT_NAME, 1,200)
          , 'P_CELL_TYPE'       VALUE SUBSTR(P_CELL_TYPE, 1,200)
          , 'P_STACK_METHOD'    VALUE SUBSTR(P_STACK_METHOD, 1,200)
          , 'P_BIZ_TYPE'        VALUE SUBSTR(P_BIZ_TYPE, 1,200)
          , 'P_SOP_DATE'        VALUE SUBSTR(P_SOP_DATE, 1,200)
          , 'P_SOP_PLANT_ID'    VALUE SUBSTR(P_SOP_PLANT_ID, 1,200)
          , 'P_USER_ID'         VALUE P_SES_USER_ID
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', n_log_count, 'EXCEPTION',
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    
    -- ^ 구분자로 전달받은 Grid 데이터의 Row 수 추출
    N_MAX_CNT := REGEXP_COUNT(P_DIVISION_ID, '\^') + 1;
    
    -- Grid Row count Loop
    FOR i IN 1..N_MAX_CNT LOOP
        V_DPJT_KEY          := TRIM(REGEXP_SUBSTR(P_DPJT_KEY,           '[^\^]+', 1, i));
        V_DIVISION_ID       := TRIM(REGEXP_SUBSTR(P_DIVISION_ID,        '[^\^]+', 1, i));
    
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
             , SRC.DPJT_REG_STATUS      = 'WAITING'     -- 승인대기
         WHERE 0 = 0
           -- 작성중(WRITING) 상태만 등록요청 가능
           AND SRC.DPJT_REG_STATUS IN ('WRITING','DRAFT')
           -- [E20260813-DRAFTGUARD] 신규행(DRAFT) 등록요청 허용 — 발신처 확인 대기 임시 확장
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


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
                $$PLSQL_UNIT, 'ERROR', n_log_count, 'EXCEPTION',
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
    
    -- ^ 구분자로 전달받은 Grid 데이터의 Row 수 추출
    N_MAX_CNT := REGEXP_COUNT(P_DIVISION_ID, '\^') + 1;
    
    -- Grid Row count Loop
    FOR i IN 1..N_MAX_CNT LOOP
        V_DPJT_KEY          := TRIM(REGEXP_SUBSTR(P_DPJT_KEY,           '[^\^]+', 1, i));
        V_DIVISION_ID       := TRIM(REGEXP_SUBSTR(P_DIVISION_ID,        '[^\^]+', 1, i));
    
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
             , SRC.DPJT_REG_STATUS      = 'WRITING'     -- 작성중
         WHERE 0 = 0
           -- 승인대기(WAITING) 상태만 등록요청 가능
           AND SRC.DPJT_REG_STATUS = 'WAITING'
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


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
                $$PLSQL_UNIT, 'ERROR', n_log_count, 'EXCEPTION',
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
        SELECT PJM.DPJT_KEY, PJM.DPJT_CODE, PJM.DPJT_SEQ
             , 'My Work' MY_WORK
             , PJM.DIVISION_ID, DIV.DIVISION_ID DIVISION_NAME
             , PJM.DPJT_CLASS, PCL.DPJT_CLASS_NAME
             , PJM.END_CUSTOMER, EDC.END_CUSTOMER_NAME
             , PJM.DPJT_NAME
             , PJM.CELL_TYPE, CLT.CELL_TYPE_NAME
             , PJM.STACK_METHOD, SMD.STACK_METHOD_NAME
             , PJM.BIZ_TYPE, BIZ.BIZ_TYPE_NAME
             , PJM.SOP_DATE
             , PJM.SOP_PLANT_ID, PLT.SOP_PLANT_NAME
             , PJM.MGMT_USER_ID, USR.USER_NAME, USR.USER_NAME_EN
             , USR.DEPT_ID, DPT.DEPT_NAME_KO DEPT_NAME, DPT.DEPT_NAME_KO, DPT.DEPT_NAME_EN, DPT.DEPT_NAME_CN
             , CASE
                    WHEN USM.DPJT_AUTH_STATUS = 'REQUEST'
                    THEN 'NONE'
                    -- [E20260813-TAB2MGMT] 관리자(MGMT_USER_ID=본인) 는 USER_MAP 행 없이 ADMIN 표시
                    WHEN USM.DPJT_AUTH_TYPE IS NULL AND PJM.MGMT_USER_ID = P_SES_USER_ID
                    THEN 'ADMIN'
                    ELSE USM.DPJT_AUTH_TYPE
               END AS DPJT_AUTH_TYPE
             , CASE
                    WHEN USM.DPJT_AUTH_STATUS = 'REQUEST'
                    THEN '권한없음'
                    -- [E20260813-TAB2MGMT] ADMIN 명칭 = SPMS_DPJT_AUTH_TYPE lookup (비상관 스칼라 1회)
                    WHEN USM.DPJT_AUTH_TYPE IS NULL AND PJM.MGMT_USER_ID = P_SES_USER_ID
                    THEN NVL((SELECT MAX(LKD.SEGMENT2)
                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                               INNER JOIN
                                     SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                                  ON LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                                 AND LKD.VALID_YN = 'Y'
                               WHERE LKM.LOOKUP_TYPE = 'SPMS_DPJT_AUTH_TYPE'
                                 AND LKM.VALID_YN = 'Y'
                                 AND LKD.SEGMENT1 = 'ADMIN'), 'ADMIN')
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
         INNER JOIN
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
           -- [E20260813-TAB2MGMT] 수신본은 USER_MAP 권한행 보유자만 표시 — 관리자(MGMT_USER_ID=본인) 가
           --   등록한 프로젝트가 TAB2 0행 (실사고 2026-08-13). 관리자 본인 포함 + NULL-안전 술어.
           AND ( USM.DPJT_AUTH_TYPE IS NOT NULL OR PJM.MGMT_USER_ID = P_SES_USER_ID )
           AND ( USM.DPJT_AUTH_STATUS IS NULL OR USM.DPJT_AUTH_STATUS != 'REQUEST' )
           -- 조회 조건
           AND ( PJM.DIVISION_ID      = P_DIVISION_ID   OR P_DIVISION_ID    = 'ALL' )
           AND ( PJM.END_CUSTOMER     = P_END_CUSTOMER  OR P_END_CUSTOMER   = 'ALL' )
           AND (
                   CASE
                        WHEN USM.DPJT_AUTH_STATUS = 'REQUEST'
                        THEN 'NONE'
                        -- [E20260813-TAB2MGMT] SELECT 표시 CASE 와 동기 (관리자=ADMIN 필터 매칭)
                        WHEN USM.DPJT_AUTH_TYPE IS NULL AND PJM.MGMT_USER_ID = P_SES_USER_ID
                        THEN 'ADMIN'
                        ELSE USM.DPJT_AUTH_TYPE
                   END                  = P_DPJT_AUTH_TYPE
                   OR P_DPJT_AUTH_TYPE = 'ALL'
               )
           AND ( PJM.DPJT_REG_STATUS  = P_DPJT_REG_STATUS   OR P_DPJT_REG_STATUS = 'ALL' )
           AND (
                    PJM.REG_COMP_DATE BETWEEN D_REG_COMP_DATE_FR AND D_REG_COMP_DATE_TO
                 -- [E20260813-TAB2COMPNULL] 등록 미완료(REG_COMP_DATE NULL) 행은 완료일 기간 필터 대상 아님 —
                 --   수신본은 기간 지정 시 미완료 전 행 제외 → 기본 기간에서 진행 중 프로젝트 0행 (실사고)
                 OR PJM.REG_COMP_DATE IS NULL
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


BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

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
          FROM (
                    SELECT DISTINCT DPT.*
                      FROM WT_DEPT_MST DPT
                      INNER JOIN WT_DEPT_USER_EXISTS DIN ON DPT.DEPT_ID = DIN.DEPT_ID
                     WHERE 0 = 0
               ) DPT
         WHERE 0 = 0
           --AND DPT.DEPT_ID IN ( SELECT DIN.DEPT_ID FROM WT_DEPT_USER_EXISTS DIN )
         START WITH
               DPT.UPPER_DEPT_ID IS NULL OR DPT.UPPER_DEPT_ID = '' OR DPT.UPPER_DEPT_ID = '00000000'
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
              FROM SCM_MGR.SCM_MST_SSO_USER_INFO USR
             INNER JOIN
                   SCM_MGR.SCM_MST_SSO_DEPT_INFO DPT
                ON 0 = 0
               AND USR.DEPT_ID = DPT.DEPT_ID
               AND DPT.VALID_YN = 'Y'
             WHERE 0 = 0
               AND UPPER(USR.USER_ID || USR.USER_NAME) LIKE '%' || UPPER(P_USER_INFO) || '%'
               AND USR.ACTIVE_FLAG NOT IN ('D', '-')
               -- 사용자 정보(조회조건) 이 없으면 결과를 리턴하지 않음
               AND CASE WHEN P_USER_INFO IS NULL THEN 0 ELSE 1 END = 1
            ;
    -- 2. 부서 정보 검색인 경우
    ELSE
        OPEN O_CURSOR FOR
            SELECT USR.USER_ID, USR.USER_NAME
                 , USR.JOB_CODE, USR.JOB_NAME
                 , USR.DEPT_ID, DPT.DEPT_NAME_KO AS DEPT_NAME
              FROM SCM_MGR.SCM_MST_SSO_USER_INFO USR
             INNER JOIN
                   SCM_MGR.SCM_MST_SSO_DEPT_INFO DPT
                ON 0 = 0
               AND USR.DEPT_ID = DPT.DEPT_ID
               AND DPT.VALID_YN = 'Y'
             WHERE 0 = 0
               AND USR.ACTIVE_FLAG NOT IN ('D', '-')
               AND DPT.DEPT_ID = P_DEPT_ID
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

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
                      FROM UF_FX_String_Split(P_USER_ID, '^')
                )
                , WT_AUTH_INFO AS ( -- 대상 Project 사용자 별 권한 정보
                    SELECT USM.DPJT_KEY, USM.USER_ID
                         , USM.DPJT_AUTH_TYPE, USM.DPJT_AUTH_STATUS, USM.DPJT_AUTH_TYPE_REQ
                         , USM.DPJT_CODE, USM.DPJT_SEQ, USM.DPJT_NAME
                      FROM SCM_MGR.SPMS_PROJECT_USER_MAP USM
                     WHERE 0 = 0
                       AND USM.DPJT_KEY         = P_DPJT_KEY
                       AND USM.DPJT_AUTH_TYPE  != 'ADMIN'       -- 관리자 제외
                       -- [E20260813-XTYPE] 반대 유형 권한 소거 방지 — 본 저장 유형(WRITE) 또는 요청 보유자만 대상
                       AND (USM.DPJT_AUTH_TYPE = 'WRITE' OR USM.DPJT_AUTH_TYPE_REQ IS NOT NULL)
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
                 INNER JOIN
                       SCM_MGR.SPMS_PROJECT_MST PJM
                    ON 0 = 0
                   AND USL.DPJT_KEY     = PJM.DPJT_KEY
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
         , SRC.DPJT_AUTH_TYPE       = CASE WHEN DAT.NEW_AUTH_TYPE IS NULL THEN DAT.REQ_AUTH_TYPE ELSE DAT.NEW_AUTH_TYPE END
         , SRC.DPJT_AUTH_STATUS     = CASE
                                            -- WRITE 권한이 존재하면 Confirmed
                                            WHEN DAT.NEW_AUTH_TYPE IS NOT NULL
                                            THEN 'CONFIRM'
                                            -- 권한 요청이 있고 WRITE 권한이 있었는데 없어지면 Reject
                                            WHEN DAT.OLD_AUTH_TYPE = 'WRITE'    -- Exists WRITE Auth
                                             AND DAT.NEW_AUTH_TYPE IS NULL      -- none WRITE Auth
                                             AND DAT.REQ_AUTH_TYPE IS NOT NULL  -- Exists Request
                                            THEN 'REJECT'
                                            WHEN DAT.REQ_AUTH_TYPE IS NOT NULL  -- Exists Request
                                            THEN 'REQUEST'
                                            ELSE NULL
                                      END
    --DELETE WHERE SRC.DPJT_AUTH_TYPE IS NULL
      WHEN NOT MATCHED THEN
    INSERT (
                DPJT_KEY, USER_ID, DPJT_AUTH_TYPE, DPJT_AUTH_STATUS, DPJT_AUTH_TYPE_REQ
              , DPJT_CODE, DPJT_SEQ, DPJT_NAME
              , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
           )
    VALUES (
                DAT.DPJT_KEY, DAT.USER_ID
              , 'WRITE', 'CONFIRM', NULL                            -- DPJT_AUTH_TYPE, DPJT_AUTH_STATUS, DPJT_AUTH_TYPE_REQ
              , DAT.DPJT_CODE, DAT.DPJT_SEQ, DAT.DPJT_NAME
              , P_SES_USER_ID, SYSDATE, P_SES_USER_ID, SYSDATE
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


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
                $$PLSQL_UNIT, 'ERROR', n_log_count, 'EXCEPTION',
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    -- 
    
     MERGE INTO SCM_MGR.SPMS_PROJECT_USER_MAP SRC
     USING (
                WITH WT_NEW_WRITE AS (
                    SELECT NR AS ROW_KEY, TOKEN AS USER_ID
                         , 'READ' DPJT_AUTH_TYPE, P_DPJT_KEY AS DPJT_KEY
                      FROM UF_FX_String_Split(P_USER_ID, '^')
                )
                , WT_AUTH_INFO AS ( -- 대상 Project 사용자 별 권한 정보
                    SELECT USM.DPJT_KEY, USM.USER_ID
                         , USM.DPJT_AUTH_TYPE, USM.DPJT_AUTH_STATUS, USM.DPJT_AUTH_TYPE_REQ
                         , USM.DPJT_CODE, USM.DPJT_SEQ, USM.DPJT_NAME
                      FROM SCM_MGR.SPMS_PROJECT_USER_MAP USM
                     WHERE 0 = 0
                       AND USM.DPJT_KEY         = P_DPJT_KEY
                       AND USM.DPJT_AUTH_TYPE  != 'ADMIN'       -- 관리자 제외
                       -- [E20260813-XTYPE] 반대 유형 권한 소거 방지 — 본 저장 유형(READ) 또는 요청 보유자만 대상
                       AND (USM.DPJT_AUTH_TYPE = 'READ' OR USM.DPJT_AUTH_TYPE_REQ IS NOT NULL)
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
                 INNER JOIN
                       SCM_MGR.SPMS_PROJECT_MST PJM
                    ON 0 = 0
                   AND USL.DPJT_KEY     = PJM.DPJT_KEY
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
         , SRC.DPJT_AUTH_TYPE       = CASE WHEN DAT.NEW_AUTH_TYPE IS NULL THEN DAT.REQ_AUTH_TYPE ELSE DAT.NEW_AUTH_TYPE END
         , SRC.DPJT_AUTH_STATUS     = CASE
                                            -- WRITE 권한이 존재하면 Confirmed
                                            WHEN DAT.NEW_AUTH_TYPE IS NOT NULL
                                            THEN 'CONFIRM'
                                            -- 권한 요청이 있고 READ 권한이 있었는데 없어지면 Reject
                                            WHEN DAT.OLD_AUTH_TYPE = 'READ'     -- Exists READ Auth
                                             AND DAT.NEW_AUTH_TYPE IS NULL      -- none READ Auth
                                             AND DAT.REQ_AUTH_TYPE IS NOT NULL  -- Exists Request
                                            THEN 'REJECT'
                                            WHEN DAT.REQ_AUTH_TYPE IS NOT NULL  -- Exists Request
                                            THEN 'REQUEST'
                                            ELSE NULL
                                      END
    --DELETE WHERE SRC.DPJT_AUTH_TYPE IS NULL
      WHEN NOT MATCHED THEN
    INSERT (
                DPJT_KEY, USER_ID, DPJT_AUTH_TYPE, DPJT_AUTH_STATUS, DPJT_AUTH_TYPE_REQ
              , DPJT_CODE, DPJT_SEQ, DPJT_NAME
              , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
           )
    VALUES (
                DAT.DPJT_KEY, DAT.USER_ID
              , 'READ', 'CONFIRM', NULL                             -- DPJT_AUTH_TYPE, DPJT_AUTH_STATUS, DPJT_AUTH_TYPE_REQ
              , DAT.DPJT_CODE, DAT.DPJT_SEQ, DAT.DPJT_NAME
              , P_SES_USER_ID, SYSDATE, P_SES_USER_ID, SYSDATE
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


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
                $$PLSQL_UNIT, 'ERROR', n_log_count, 'EXCEPTION',
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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

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
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


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
                $$PLSQL_UNIT, 'ERROR', n_log_count, 'EXCEPTION',
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
             , PJM.END_CUSTOMER, EDC.END_CUSTOMER_NAME
             , PJM.DPJT_NAME
             --
             , TO_DATE('20260701', 'YYYYMMDD') AS SAMPLE_A_DATE
             , TO_DATE('20261001', 'YYYYMMDD') AS SAMPLE_B_DATE
             , TO_DATE('20260104', 'YYYYMMDD') AS SAMPLE_C_DATE
             , TO_DATE('20260402', 'YYYYMMDD') AS SAMPLE_D_DATE
             --
             , PJM.SOP_DATE
             , PJM.SOP_PLANT_ID, PLT.SOP_PLANT_NAME
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
         INNER JOIN
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
                           SIT.DIVISION_ID, SIT.SCM_SITE_ID SOP_PLANT_ID, SIT.SCM_SITE_ID SOP_PLANT_NAME
                      FROM SCM_MGR.SCM_MST_SITE SIT
                     WHERE 0 = 0
                       AND SIT.SITE_TYPE = 'PLANT'
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