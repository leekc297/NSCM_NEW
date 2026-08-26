CREATE OR REPLACE PACKAGE BODY         PKG_SDM1020 AS
/*
 * Program ID   : PKG_SDM1020
 * Description  : Project List
 * Parameter    : NONE
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.13   KTJ            최초 작성
 *                             프로젝트 조회/수정
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

PROCEDURE P_SDM1020_GET_PJT_LIST (
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
 * Program ID   : PKG_SDM1020.P_SDM1020_GET_PJT_LIST
 * Description  : Project List
 * Parameter    : 
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.13   KTJ            최초 작성
 *                             프로젝트 조회/수정
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
             -- 프로젝트 Code 는 상단에 있음
             , USR.DEPT_ID, DPT.DEPT_NAME_KO DEPT_NAME, DPT.DEPT_NAME_KO, DPT.DEPT_NAME_EN, DPT.DEPT_NAME_CN
             , PJM.MGMT_USER_ID, USR.USER_NAME, USR.USER_NAME_EN
             , CASE
                    WHEN USM.DPJT_AUTH_STATUS = 'REQUEST'
                    THEN 'NONE'
                    ELSE NVL(USM.DPJT_AUTH_TYPE, 'NONE')
               END AS DPJT_AUTH_TYPE
             , CASE
                    WHEN USM.DPJT_AUTH_STATUS = 'REQUEST'
                    THEN '권한없음'
                    ELSE NVL(USM.DPJT_AUTH_TYPE_NAME, '권한없음')
               END AS DPJT_AUTH_TYPE_NAME
             , PJM.DPJT_REG_STATUS, RGS.DPJT_REG_STATUS_NAME, RGS.DPJT_REG_STATUS_COLOR_TYPE
             , PJM.REG_COMP_DATE, PJM.DPJT_DEVELOP_STATUS, DVL.DPJT_DEVELOP_STATUS_NAME
             -- 관리자 권한인 경우만 권한 관리 가능
             , CASE
                    WHEN USM.DPJT_AUTH_TYPE = 'ADMIN'
                    THEN ''
                    ELSE '-'
               END AS DPJT_AUTH_MGMT
             -- 관리자인 경우 권한 요창 상태가 있는지 표시
             , CASE
                    WHEN USM.DPJT_AUTH_TYPE = 'ADMIN'
                     AND NVL(PAT.REQ_COUNT, 0) > 0
                    THEN '권한요청'
                    ELSE NULL
               END AS DPJT_AUTH_REQ_STATUS
             , CASE
                    WHEN USM.DPJT_AUTH_TYPE = 'ADMIN'
                     AND NVL(PAT.REQ_COUNT, 0) > 0
                    THEN '권한요청'
                    ELSE NULL
               END AS DPJT_AUTH_REQ_WRITE_NAME
             , CASE
                    WHEN USM.DPJT_AUTH_TYPE = 'ADMIN'
                     AND NVL(PAT.REQ_COUNT, 0) > 0
                    THEN 'warning-major'
                    ELSE NULL
               END AS DPJT_AUTH_REQ_WRITE_COLOR_TYPE
               -- 권한요청
             , CASE
                    -- Admin, 쓰기 권한이 있으면 Disabled
                    WHEN USM.DPJT_AUTH_TYPE IN ('ADMIN', 'WRITE')
                     AND USM.DPJT_AUTH_STATUS = 'CONFIRM'
                    THEN 'DISABLED'
                    -- 쓰기 권한 요청 상태이면 Checked
                    WHEN USM.DPJT_AUTH_TYPE IN ('WRITE')
                     AND USM.DPJT_AUTH_STATUS = 'REQUEST'
                    THEN 'CHECKED'
                    ELSE 'UNCHECKED'
               END AS DPJT_AUTH_REQ_WRITE
             , CASE
                    -- Admin, 읽기 권한이 있으면 Disabled
                    WHEN USM.DPJT_AUTH_TYPE IN ('ADMIN', 'WRITE')
                     AND USM.DPJT_AUTH_STATUS = 'CONFIRM'
                    THEN 'DISABLED'
                    -- 읽기 권한 요청 상태이면 Checked
                    WHEN USM.DPJT_AUTH_TYPE IN ('READ')
                     AND USM.DPJT_AUTH_STATUS = 'REQUEST'
                    THEN 'CHECKED'
                    ELSE 'UNCHECKED'
               END AS DPJT_AUTH_REQ_READ
             , CASE
                    -- Admin, 쓰기 권한이 있으면 Disabled
                    WHEN USM.DPJT_AUTH_TYPE IN ('ADMIN', 'WRITE')
                     AND USM.DPJT_AUTH_STATUS = 'CONFIRM'
                    THEN 'DISABLED'
                    -- 쓰기 권한 요청 상태이면 Checked
                    WHEN USM.DPJT_AUTH_TYPE IN ('READ')
                     AND USM.DPJT_AUTH_STATUS = 'REQUEST'
                    THEN 'CHECKED'
                    ELSE 'UNCHECKED'
               END AS DPJT_AUTH_REQ_READ
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
                           SIT.DIVISION_ID, SIT.SCM_SITE_ID SOP_PLANT_ID, SIT.SCM_SITE_ID SOP_PLANT_NAME
                      FROM SCM_MGR.SCM_MST_SITE SIT
                     WHERE 0 = 0
                       AND SIT.SITE_TYPE = 'PLANT'
               ) PLT
            ON 0 = 0
           AND PJM.DIVISION_ID  = PLT.DIVISION_ID
           AND PJM.SOP_PLANT_ID = PLT.SOP_PLANT_ID
          -- 내 권한
          LEFT OUTER JOIN
               (
                    SELECT USM.DPJT_KEY
                         , USM.DPJT_AUTH_TYPE, AUT.DPJT_AUTH_TYPE_NAME      -- ADMIN/WRITE/READ
                         , USM.DPJT_AUTH_STATUS                             -- CONFIRM/REQUEST/REJECT
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
               ) USM
            ON 0 = 0
           AND PJM.DPJT_KEY  = USM.DPJT_KEY
          -- 권한요청 갯수
          LEFT OUTER JOIN
               (
                    SELECT USM.DPJT_KEY
                         , COUNT(USM.USER_ID) AS REQ_COUNT
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
                       -- 요청 상태만 조회
                       AND USM.DPJT_AUTH_STATUS = 'REQUEST'
                     GROUP BY USM.DPJT_KEY
               ) PAT
            ON 0 = 0
           AND PJM.DPJT_KEY  = PAT.DPJT_KEY
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

END P_SDM1020_GET_PJT_LIST;

PROCEDURE P_SDM1020_BTN_REQ_PJT_REG
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
 * Program ID   : PKG_SDM1020.P_SDM1020_BTN_REQ_PJT_REG
 * Description  : Project Modification Registration
 * Parameter    : PKG_SDM1020.P_SDM1020_BTN_REQ_PJT_REG(
                            P_ACTIVE_FLAG, P_DPJT_KEY, P_DPJT_CODE, P_DPJT_SEQ
                          , P_DIVISION_ID, P_DPJT_CLASS, P_END_CUSTOMER, P_DPJT_NAME, P_CELL_TYPE, P_STACK_METHOD, P_BIZ_TYPE, P_SOP_DATE, P_SOP_PLANT_ID
                          , P_USER_ID, O_RESULT_CURSOR)
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.13   KTJ         최초 작성
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
    V_DPJT_KEY_PARENT           VARCHAR2(50);

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
    --SELECT * FROM SCM_MGR.UF_FX_STRING_SPLIT('01MDP2949A9B11^02MDP2949A9B11^03MDP2949A9B11^04MDP2949A9B11^05MDP2949A9B11', '^')
    
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
    
        -- 1. 신규 등록 - 수정 후 등록 요청을 하면 신규 데이터 생성
            
            V_DPJT_KEY_PARENT := V_DPJT_KEY;
            SELECT NVL(MAX(DPJT_SEQ), 0) + 1 INTO N_DPJT_SEQ FROM SCM_MGR.SPMS_PROJECT_MST WHERE DPJT_CODE = V_DPJT_CODE;
            V_DPJT_KEY  := V_DPJT_CODE || '_' || TO_CHAR(N_DPJT_SEQ, '000000');
            
            -- 프로젝트 등록 상태 : REQ_MOD
            SELECT LMT.SEGMENT1 INTO V_DPJT_REG_STATUS
              FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LMT
             WHERE LMT.LOOKUP_TYPE = 'SPMS_DPJT_REG_STATUS'
               AND LMT.SEGMENT1 = 'REQ_MOD'
               AND LMT.SEGMENT2 = '변경요청'
            ;
            -- 프로젝트 등록 구분 : MOD
            SELECT LMT.SEGMENT1 INTO V_SPMS_DPJT_REG_CAT
              FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LMT
             WHERE LMT.LOOKUP_TYPE = 'SPMS_DPJT_REG_CAT'
               AND LMT.SEGMENT1 = 'MOD'
               AND LMT.SEGMENT2 = '수정'
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
                 , V_user_id MGMT_USER_ID, V_DPJT_REG_STATUS DPJT_REG_STATUS
                 , TRUNC(SYSDATE) REG_REQ_DATE, TRUNC(SYSDATE) REG_MOD_DATE, NULL REG_COMP_DATE, NULL DPJT_DEVELOP_STATUS
                 , V_SPMS_DPJT_REG_CAT DPJT_REG_CAT, NULL NOTE
                 -- 최초 등록 시 TEMP
                 , 'TEMP' DPJT_MGMT_STATUS, V_DPJT_KEY_PARENT AS DPJT_KEY_PARENT
                 , V_USER_ID CREATED_BY, SYSDATE CREATION_DATE, V_USER_ID LAST_UPDATED_BY, SYSDATE LAST_UPDATE_DATE
              FROM DUAL
            ;
            N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;
            
            -- 2. 수정 : 원 Project 에 대해 변경중(MODIFYING) 상태로 Update
            --    - 변경중(MODIFYING) 는 Lookup 에서 비활성 상태
            UPDATE SCM_MGR.SPMS_PROJECT_MST
               SET LAST_UPDATED_BY  = V_USER_ID
                 , LAST_UPDATE_DATE = SYSDATE
                 --
                 , DPJT_REG_STATUS  = 'MODIFYING'       -- 변경중
                 , REG_MOD_DATE     = TRUNC(SYSDATE)    -- 프로젝트 등록 변경일
             WHERE 0 = 0
               AND V_DPJT_KEY = V_DPJT_KEY_PARENT
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

END P_SDM1020_BTN_REQ_PJT_REG;

PROCEDURE P_SDM1020_REQ_PJT_AUTH
(
    P_DPJT_KEY                  IN VARCHAR2
  , P_DPJT_AUTH_REQ_WRITE       IN VARCHAR2
  , P_DPJT_AUTH_REQ_READ        IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM1020.P_SDM1020_REQ_PJT_AUTH
 * Description  : Request Project Auth.
 * Parameter    : PKG_SDM1020.P_SDM1020_REQ_PJT_AUTH(
                            P_ACTIVE_FLAG, P_DPJT_KEY, P_DPJT_CODE, P_DPJT_SEQ
                          , P_DIVISION_ID, P_DPJT_CLASS, P_END_CUSTOMER, P_DPJT_NAME, P_CELL_TYPE, P_STACK_METHOD, P_BIZ_TYPE, P_SOP_DATE, P_SOP_PLANT_ID
                          , P_USER_ID, O_RESULT_CURSOR)
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.13   KTJ         최초 작성
 *                          프로젝트 등록
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    -- 
    V_USER_ID                   VARCHAR2(50) := P_SES_USER_ID;
    V_DPJT_AUTH_TYPE_REQ        VARCHAR2(50);                       -- WRITE/READ

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

    
    -- 요청 권한 설정 
    IF      UPPER(P_DPJT_AUTH_REQ_WRITE) IN ('Y', 'TRUE', 'CHECKED', 'CHECK') THEN
        V_DPJT_AUTH_TYPE_REQ := 'WRITE';
    ELSIF   UPPER(P_DPJT_AUTH_REQ_READ)  IN ('Y', 'TRUE', 'CHECKED', 'CHECK') THEN
        V_DPJT_AUTH_TYPE_REQ := 'READ';
    ELSE
        V_DPJT_AUTH_TYPE_REQ := 'NONE';
    END IF;
    
    IF V_DPJT_AUTH_TYPE_REQ != 'NONE' THEN
        -- 권한 요청 정보 저장
        -- 기존 요청 권한이 존재할 수 있기 때문에 Merge 문 처리
         MERGE INTO SCM_MGR.SPMS_PROJECT_USER_MAP SRC
         USING (
                    SELECT PJM.DPJT_KEY, PJM.DPJT_CODE, PJM.DPJT_SEQ, PJM.DPJT_NAME
                         , P_SES_USER_ID            AS USER_ID
                         , V_DPJT_AUTH_TYPE_REQ     AS DPJT_AUTH_TYPE
                         , 'REQUEST'                AS DPJT_AUTH_STATUS
                         , V_DPJT_AUTH_TYPE_REQ     AS DPJT_AUTH_TYPE_REQ
                      FROM SPMS_PROJECT_MST PJM
                     WHERE 0 = 0
                       AND PJM.DPJT_KEY = P_DPJT_KEY
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
             , SRC.DPJT_AUTH_TYPE       = DAT.DPJT_AUTH_TYPE
             , SRC.DPJT_AUTH_STATUS     = DAT.DPJT_AUTH_STATUS
             , SRC.DPJT_AUTH_TYPE_REQ   = DAT.DPJT_AUTH_TYPE_REQ
        --DELETE WHERE SRC.DPJT_AUTH_TYPE IS NULL
         WHERE 0 = 0
           AND 1 = CASE
                        -- 관리자, 쓰기 권한이 존재하는 경우 권한 요청이 의미 없음
                        WHEN SRC.DPJT_AUTH_TYPE IN ('ADMIN', 'WRITE')
                         AND SRC.DPJT_AUTH_STATUS = 'CONFIRM'
                        THEN 0
                        -- 동일한 권한 요청 상태이면 의미 없음
                        WHEN SRC.DPJT_AUTH_TYPE = DAT.DPJT_AUTH_TYPE_REQ
                         AND SRC.DPJT_AUTH_STATUS = 'REQUEST'
                        THEN 0
                        ELSE 1
                   END
          WHEN NOT MATCHED THEN
        INSERT (
                    DPJT_KEY, USER_ID, DPJT_AUTH_TYPE, DPJT_AUTH_STATUS, DPJT_AUTH_TYPE_REQ
                  , DPJT_CODE, DPJT_SEQ, DPJT_NAME
                  , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
               )
        VALUES (
                    DAT.DPJT_KEY, DAT.USER_ID
                  , DAT.DPJT_AUTH_TYPE, DAT.DPJT_AUTH_STATUS, DAT.DPJT_AUTH_TYPE_REQ
                  , DAT.DPJT_CODE, DAT.DPJT_SEQ, DAT.DPJT_NAME
                  , P_SES_USER_ID, SYSDATE, P_SES_USER_ID, SYSDATE
               )
        ;
        N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;
    
        -- 추가로 메일링 관련 로직 필요
        
    END IF;

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
            'P_DPJT_KEY'                VALUE SUBSTR(P_DPJT_KEY, 1, 200)
          , 'P_DPJT_AUTH_REQ_WRITE'     VALUE SUBSTR(P_DPJT_AUTH_REQ_WRITE, 1, 200)
          , 'P_DPJT_AUTH_REQ_READ'      VALUE SUBSTR(P_DPJT_AUTH_REQ_WRITE, 1, 200)
          , 'P_SES_USER_ID'             VALUE P_SES_USER_ID
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

END P_SDM1020_REQ_PJT_AUTH;

END PKG_SDM1020;
/
