CREATE OR REPLACE PACKAGE BODY           "PKG_SDM2020" AS
/*
 * Program ID   : PKG_SDM2020
 * Description  : Production Request
 * Parameter    : NONE
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ            최초 작성
 *                             생산요청
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

PROCEDURE P_SDM2020_GET_PJT_SAMPLE_TREE (
    P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : P_SDM2020_GET_PJT_SAMPLE_TREE
 * Description  : 샘플현황 Tree List
 * Parameter    : NONE
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ            최초 작성
 *                             샘플현황 Tree List
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
        
        WITH WT_BASIC AS (
            SELECT DISTINCT
                   BLD.END_CUSTOMER, BLD.DPJT_CODE
                 , REPLACE(BLD.DPJT_BUILD_NO, BLD.DPJT_CODE||'-', '') AS BUILD_NO
                 , BLD.DPJT_BUILD_NO
                 , MAX(CASE WHEN BLD.DPJT_BUILD_STATUS = 'PROGRESS' THEN BLD.DPJT_BUILD_STATUS END) AS IN_PROGRESS
              FROM SCM_MGR.SPMS_PROJECT_SAMPLE_BUILD BLD
             WHERE 0 = 0
               --AND BLD.MGMT_USER_ID = P_SES_USER_ID
             GROUP BY BLD.END_CUSTOMER, BLD.DPJT_CODE, BLD.DPJT_BUILD_NO
        )
        -- Level 1 : Customer
        SELECT 1 LEVEL_NO
             , BLD.END_CUSTOMER ITEM_ID
             , NULL UPPER_ITEM_ID
             , BLD.IN_PROGRESS
             , NULL DPJT_BUILD_NO
          FROM (
                    SELECT BLD.END_CUSTOMER
                         , MAX(CASE WHEN BLD.IN_PROGRESS = 'PROGRESS' THEN BLD.IN_PROGRESS END) AS IN_PROGRESS
                      FROM WT_BASIC BLD
                     WHERE 0 = 0
                     GROUP BY BLD.END_CUSTOMER
               ) BLD
         WHERE 0 = 0
        UNION ALL
        -- Level 2 : Project Code
        SELECT 2 LEVEL_NO
             , BLD.DPJT_CODE        ITEM_ID
             , BLD.END_CUSTOMER     UPPER_ITEM_ID
             , BLD.IN_PROGRESS
             , NULL DPJT_BUILD_NO
          FROM (
                    SELECT BLD.END_CUSTOMER, BLD.DPJT_CODE
                         , MAX(CASE WHEN BLD.IN_PROGRESS = 'PROGRESS' THEN BLD.IN_PROGRESS END) AS IN_PROGRESS
                      FROM WT_BASIC BLD
                     WHERE 0 = 0
                     GROUP BY BLD.END_CUSTOMER, BLD.DPJT_CODE
               ) BLD
         WHERE 0 = 0
        UNION ALL
        -- Level 3 : Build No.
        SELECT 3 LEVEL_NO
             , BLD.BUILD_NO         ITEM_ID
             , BLD.DPJT_CODE        UPPER_ITEM_ID
             , BLD.IN_PROGRESS
             , BLD.DPJT_BUILD_NO
          FROM (
                    SELECT BLD.END_CUSTOMER, BLD.DPJT_CODE, BLD.DPJT_BUILD_NO, BLD.BUILD_NO
                         , MAX(CASE WHEN BLD.IN_PROGRESS = 'PROGRESS' THEN BLD.IN_PROGRESS END) AS IN_PROGRESS
                      FROM WT_BASIC BLD
                     WHERE 0 = 0
                     GROUP BY BLD.END_CUSTOMER, BLD.DPJT_CODE, BLD.DPJT_BUILD_NO, BLD.BUILD_NO
               ) BLD
         WHERE 0 = 0
        ;
        /*
        SELECT LEVEL LEVEL_NO, DPT.DEPT_ID, DPT.DEPT_NAME, DPT.UPPER_DEPT_ID, DPT.USER_COUNT
             , LPAD(' ', (LEVEL-1)*4) || DPT.DEPT_ID AS ORGN
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
           -- 작성중/등록요청 만 조회
           AND PJM.DPJT_REG_STATUS IN ('WRITING', 'WAITING')
        ;*/
    
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

END P_SDM2020_GET_PJT_SAMPLE_TREE;

-- Process List (LEFT TOP)
PROCEDURE P_SDM2020_GET_PJT_SAMPLE_PROCESS (
    P_DPJT_CODE                 IN VARCHAR2
  , P_DPJT_BUILD_NO             IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : P_SDM2020_GET_PJT_SAMPLE_PROCESS
 * Description  : 샘플현황 Process List (LEFT TOP)
 * Parameter    : NONE
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.24   KTJ            최초 작성
 *                             샘플현황 Process List
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
    
    V_DPJT_KEY          VARCHAR2(50);
    V_DPJT_SEQ          VARCHAR2(50);

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    -- 대상 DPJT_KEY 참조
    --  . Project Code 참조
    --  . 권한 있는 project 참조
    --  . 대상 Build No. 참조
    SELECT PJM.DPJT_KEY, PJM.DPJT_SEQ
      INTO V_DPJT_KEY, V_DPJT_SEQ
      FROM SCM_MGR.SPMS_PROJECT_MST PJM
     -- 권한 확인
     INNER JOIN
           SCM_MGR.SPMS_PROJECT_USER_MAP PUM
        ON 0 = 0
       AND PJM.DPJT_KEY = PUM.DPJT_KEY
       AND PUM.USER_ID  = P_SES_USER_ID
       AND PUM.DPJT_AUTH_STATUS = 'CONFIRM'
     -- Build No. 확인
     INNER JOIN
           SCM_MGR.SPMS_PROJECT_SAMPLE_BUILD BLD
        ON 0 = 0
       AND PJM.DPJT_KEY = BLD.DPJT_KEY
       AND BLD.DPJT_BUILD_NO = P_DPJT_BUILD_NO
     WHERE 0 = 0
       AND PJM.DPJT_CODE= P_DPJT_CODE
       --
       AND PJM.DPJT_REG_STATUS  = 'COMPLETE'
     ORDER BY PJM.DPJT_SEQ DESC
     FETCH FIRST 1 ROWS ONLY
    ;
    
    OPEN O_CURSOR FOR
        SELECT LKD.SEGMENT1 AS DPJT_BUILD_PROCESS
             , LKD.SEGMENT2 AS DPJT_BUILD_PROCESS_NAME
             , NVL(PCS.PROCESS_STATUS, 'DISABLED')      AS PROCESS_STATUS               -- DONE/INPROGRESS/STANDBY/DISABLED
             , NVL(PCS.PROGRESS_CNT, 0)                 AS PROGRESS_CNT
             , TO_NUMBER(LKD.SEGMENT3 DEFAULT 1 ON CONVERSION ERROR) AS TARGET_CNT
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
          LEFT OUTER JOIN
               SCM_MGR.SPMS_PROJECT_PROCESS PCS
            ON 0 = 0
           AND LKD.SEGMENT1         = PCS.DPJT_BUILD_PROCESS
           AND PCS.DPJT_KEY         = V_DPJT_KEY
           AND PCS.DPJT_BUILD_NO    = P_DPJT_BUILD_NO
         WHERE 0 = 0
           AND LKD.LOOKUP_TYPE      = 'SPMS_DPJT_BUILD_PROCESS'
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

END P_SDM2020_GET_PJT_SAMPLE_PROCESS;

-- Build List (LEFT)
PROCEDURE P_SDM2020_GET_PJT_SAMPLE_BUILD (
    P_DPJT_CODE                 IN VARCHAR2
  , P_DPJT_BUILD_NO             IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : P_SDM2020_GET_PJT_SAMPLE_BUILD
 * Description  : 샘플현황 Build List (LEFT)
 * Parameter    : NONE
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.24   KTJ            최초 작성
 *                             샘플현황 Build List
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
    
    V_DPJT_KEY          VARCHAR2(50);
    V_DPJT_SEQ          VARCHAR2(50);

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    -- 대상 DPJT_KEY 참조
    --  . Project Code 참조
    --  . 권한 있는 project 참조
    --  . 대상 Build No. 참조
    SELECT PJM.DPJT_KEY, PJM.DPJT_SEQ
      INTO V_DPJT_KEY, V_DPJT_SEQ
      FROM SCM_MGR.SPMS_PROJECT_MST PJM
     -- 권한 확인
     INNER JOIN
           SCM_MGR.SPMS_PROJECT_USER_MAP PUM
        ON 0 = 0
       AND PJM.DPJT_KEY = PUM.DPJT_KEY
       AND PUM.USER_ID  = P_SES_USER_ID
       AND PUM.DPJT_AUTH_STATUS = 'CONFIRM'
     -- Build No. 확인
     INNER JOIN
           SCM_MGR.SPMS_PROJECT_SAMPLE_BUILD BLD
        ON 0 = 0
       AND PJM.DPJT_KEY = BLD.DPJT_KEY
       AND BLD.DPJT_BUILD_NO = P_DPJT_BUILD_NO
     WHERE 0 = 0
       AND PJM.DPJT_CODE= P_DPJT_CODE
       --
       AND PJM.DPJT_REG_STATUS  = 'COMPLETE'
     ORDER BY PJM.DPJT_SEQ DESC
     FETCH FIRST 1 ROWS ONLY
    ;
    
    -- DPJT_KEY 를 찾지 못한 경우 : Project Code 단 클릭 시
    IF V_DPJT_KEY IS NULL THEN
        SELECT PJM.DPJT_KEY, PJM.DPJT_SEQ
          INTO V_DPJT_KEY, V_DPJT_SEQ
          FROM SCM_MGR.SPMS_PROJECT_MST PJM
         -- 권한 확인
         INNER JOIN
               SCM_MGR.SPMS_PROJECT_USER_MAP PUM
            ON 0 = 0
           AND PJM.DPJT_KEY = PUM.DPJT_KEY
           AND PUM.USER_ID  = P_SES_USER_ID
           AND PUM.DPJT_AUTH_STATUS = 'CONFIRM'
         WHERE 0 = 0
           AND PJM.DPJT_CODE= P_DPJT_CODE
           --
           AND PJM.DPJT_REG_STATUS  = 'COMPLETE'
         ORDER BY PJM.DPJT_SEQ DESC
         FETCH FIRST 1 ROWS ONLY
        ;
    END IF;
    
    OPEN O_CURSOR FOR
        SELECT PJM.DPJT_KEY
             , PJM.DPJT_CLASS, PJM.MGMT_USER_ID
             , PJM.DPJT_CODE, PJM.DPJT_SEQ, PJM.DPJT_NAME, PJM.END_CUSTOMER
             , PJM.STACK_METHOD, SMD.STACK_METHOD_NAME
             , BLD.DPJT_BUILD_NO, BLD.DPJT_BUILD_STATUS
             , BLD.DPJT_BUILD_TYPE, BLD.DPJT_BUILD_SEQ, BLD.DPJT_BIND_TYPE, BLD.DPJT_BIND_SEQ
             , BLD.NOTE
             , BLD.DIVISION_ID, BLD.CELL_TYPE, BLD.BIZ_TYPE
          FROM SCM_MGR.SPMS_PROJECT_MST PJM
          LEFT OUTER JOIN
               SCM_MGR.SPMS_PROJECT_SAMPLE_BUILD BLD
            ON 0 = 0
           AND PJM.DPJT_KEY         = BLD.DPJT_KEY
           AND BLD.DPJT_BUILD_NO    = P_DPJT_BUILD_NO
          LEFT OUTER JOIN
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
         WHERE 0 = 0
           AND PJM.DPJT_KEY         = V_DPJT_KEY
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

END P_SDM2020_GET_PJT_SAMPLE_BUILD;

-- Save Sample Build (LEFT)
PROCEDURE P_SDM2020_SAVE_PJT_SAMPLE_BUILD (
    P_DPJT_CODE                 IN VARCHAR2
  , P_DPJT_BUILD_NO             IN VARCHAR2
  , P_DPJT_BUILD_TYPE           IN VARCHAR2
  , P_DPJT_BUILD_SEQ            IN VARCHAR2
  , P_DPJT_BIND_TYPE            IN VARCHAR2
  , P_DPJT_BIND_SEQ             IN VARCHAR2
  , P_NOTE                      IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM2020.P_SDM2020_SAVE_PJT_SAMPLE_BUILD
 * Description  : Save Sample Build (LEFT)
 * Parameter    : PKG_SDM2020.P_SDM2020_SAVE_PJT_SAMPLE_BUILD(P_DPJT_CODE, P_DPJT_BUILD_NO, P_DPJT_BUILD_TYPE, P_DPJT_BUILD_SEQ, P_DPJT_BIND_TYPE, P_DPJT_BIND_SEQ, P_NOTE, P_SES_DIVISION_ID, P_SES_USER_ID, O_RESULT_CURSOR)
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.25   KTJ            최초 작성
 *                             Save Sample Build (LEFT) 
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    V_DPJT_KEY                  VARCHAR2(50);
    V_DPJT_SEQ                  VARCHAR2(50);
    V_DPJT_CLASS                VARCHAR2(50);
    N_EXISS_CNT                 NUMBER(20, 0);  -- PK 존재 여부
    V_DPJT_BUILD_NO             VARCHAR2(50);

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
    
    -- 대상 DPJT_KEY 참조
    --  . Project Code 참조
    --  . 권한 있는 project 참조
    --  . 대상 Build No. 참조
    SELECT PJM.DPJT_KEY, PJM.DPJT_SEQ, PJM.DPJT_CLASS
      INTO V_DPJT_KEY, V_DPJT_SEQ, V_DPJT_CLASS
      FROM SCM_MGR.SPMS_PROJECT_MST PJM
     -- 권한 확인
     INNER JOIN
           SCM_MGR.SPMS_PROJECT_USER_MAP PUM
        ON 0 = 0
       AND PJM.DPJT_KEY = PUM.DPJT_KEY
       AND PUM.USER_ID  = P_SES_USER_ID
       AND PUM.DPJT_AUTH_STATUS = 'CONFIRM'
     -- Build No. 확인
     INNER JOIN
           SCM_MGR.SPMS_PROJECT_SAMPLE_BUILD BLD
        ON 0 = 0
       AND PJM.DPJT_KEY = BLD.DPJT_KEY
       AND BLD.DPJT_BUILD_NO = P_DPJT_BUILD_NO
     WHERE 0 = 0
       AND PJM.DPJT_CODE= P_DPJT_CODE
       --
       AND PJM.DPJT_REG_STATUS  = 'COMPLETE'
     ORDER BY PJM.DPJT_SEQ DESC
     FETCH FIRST 1 ROWS ONLY
    ;
    
    -- DPJT_KEY 를 찾지 못한 경우 : Project Code 단 클릭 시
    IF V_DPJT_KEY IS NULL THEN
        SELECT PJM.DPJT_KEY, PJM.DPJT_SEQ, PJM.DPJT_CLASS
          INTO V_DPJT_KEY, V_DPJT_SEQ, V_DPJT_CLASS
          FROM SCM_MGR.SPMS_PROJECT_MST PJM
         -- 권한 확인
         INNER JOIN
               SCM_MGR.SPMS_PROJECT_USER_MAP PUM
            ON 0 = 0
           AND PJM.DPJT_KEY = PUM.DPJT_KEY
           AND PUM.USER_ID  = P_SES_USER_ID
           AND PUM.DPJT_AUTH_STATUS = 'CONFIRM'
         WHERE 0 = 0
           AND PJM.DPJT_CODE= P_DPJT_CODE
           --
           AND PJM.DPJT_REG_STATUS  = 'COMPLETE'
         ORDER BY PJM.DPJT_SEQ DESC
         FETCH FIRST 1 ROWS ONLY
        ;
    END IF;
    
    -- BUILD_NO 생성
    --  . DPJT_CODE || '-' || DPJT_BUILD_TYPE || DPJT_BUILD_SEQ || '-' || DPJT_BIND_TYPE || DPJT_BUILD_SEQ
    IF V_DPJT_CLASS = 'DV' THEN
        V_DPJT_BUILD_NO := P_DPJT_CODE || '-' || P_DPJT_BUILD_TYPE || P_DPJT_BUILD_SEQ || '-' || P_DPJT_BIND_TYPE || P_DPJT_BUILD_SEQ;
    ELSE
        V_DPJT_BUILD_NO := P_DPJT_CODE || '-' || SUBSTR(V_DPJT_CLASS, 1, 2) || P_DPJT_BUILD_SEQ || '-' || P_DPJT_BIND_TYPE || P_DPJT_BUILD_SEQ;
    END IF;
    
    -- 동일 PK 존재 여부 체크
    -- V_DPJT_BUILD_NO 중복 체크
    BEGIN
        SELECT 1 INTO N_EXISS_CNT FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM SCM_MGR.SPMS_PROJECT_SAMPLE_BUILD BLD
             WHERE 0 = 0
               AND BLD.DPJT_KEY         = V_DPJT_KEY
               AND BLD.DPJT_BUILD_NO    = V_DPJT_BUILD_NO
        );
        v_log_type    := 'INVALID';
        V_S_CODE      := 'MSG00060';
        V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;
    
    -- 동일 PK 가 존재하지 않으면 진행
    IF N_EXISS_CNT = 0 THEN
        INSERT INTO SCM_MGR.SPMS_PROJECT_SAMPLE_BUILD (
                        DPJT_BUILD_NO, DPJT_KEY, MGMT_USER_ID, DPJT_BUILD_STATUS, DPJT_CLASS
                      , DPJT_BUILD_TYPE, DPJT_BUILD_SEQ, DPJT_BIND_TYPE, DPJT_BIND_SEQ
                      , DIVISION_ID, DPJT_CODE, DPJT_SEQ, DPJT_NAME, END_CUSTOMER
                      , CELL_TYPE, BIZ_TYPE, STACK_METHOD, NOTE
                      , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                    )
        SELECT V_DPJT_BUILD_NO      AS DPJT_BUILD_NO
             , PJM.DPJT_KEY, PJM.MGMT_USER_ID
             , 'STANDBY'            AS DPJT_BUILD_STATUS       -- DONE/INPROGRESS/STANDBY/DISABLED
             , PJM.DPJT_CLASS
             , P_DPJT_BUILD_TYPE    AS DPJT_BUILD_TYPE
             , P_DPJT_BUILD_SEQ     AS DPJT_BUILD_SEQ
             , P_DPJT_BIND_TYPE     AS DPJT_BIND_TYPE
             , P_DPJT_BUILD_SEQ     AS DPJT_BIND_SEQ
             , PJM.DIVISION_ID, PJM.DPJT_CODE, PJM.DPJT_SEQ, PJM.DPJT_NAME, PJM.END_CUSTOMER, PJM.CELL_TYPE, PJM.BIZ_TYPE, PJM.STACK_METHOD
             , P_NOTE               AS NOTE
             , P_SES_USER_ID AS CREATED_BY, SYSDATE AS CREATION_DATE, P_SES_USER_ID AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
          FROM SCM_MGR.SPMS_PROJECT_MST PJM
         WHERE 0 = 0
           AND PJM.DPJT_KEY = V_DPJT_KEY
        ;
        N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;
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
            'P_DPJT_CODE'           VALUE SUBSTR(P_DPJT_CODE, 1, 500)
          , 'P_DPJT_BUILD_NO'       VALUE SUBSTR(P_DPJT_BUILD_NO, 1, 500)
          , 'P_DPJT_BUILD_TYPE'     VALUE SUBSTR(P_DPJT_BUILD_TYPE, 1, 500)
          , 'P_DPJT_BUILD_SEQ '     VALUE SUBSTR(P_DPJT_BUILD_SEQ, 1, 500)
          , 'P_DPJT_BIND_TYPE'      VALUE SUBSTR(P_DPJT_BIND_TYPE, 1, 500)
          , 'P_DPJT_BIND_SEQ '      VALUE SUBSTR(P_DPJT_BIND_SEQ, 1, 500)
          , 'P_NOTE'                VALUE SUBSTR(P_NOTE, 1, 500)
          , 'P_SES_DIVISION_ID '    VALUE SUBSTR(P_SES_DIVISION_ID, 1, 500)
          , 'P_SES_USER_ID'         VALUE SUBSTR(P_SES_USER_ID, 1, 500)
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

END P_SDM2020_SAVE_PJT_SAMPLE_BUILD;

-- Sample Demand List (RIGHT)
PROCEDURE P_SDM2020_GET_PJT_SAMPLE_DEMAND (
    P_DPJT_CODE                 IN VARCHAR2
  , P_DPJT_BUILD_NO             IN VARCHAR2
  , P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : P_SDM2020_GET_PJT_SAMPLE_DEMAND
 * Description  : Sample Demand List (RIGHT)
 * Parameter    : NONE
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.24   KTJ            최초 작성
 *                             Sample Demand List
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
    
    V_DPJT_KEY          VARCHAR2(50);
    V_DPJT_SEQ          VARCHAR2(50);

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    -- 대상 DPJT_KEY 참조
    --  . Project Code 참조
    --  . 권한 있는 project 참조
    --  . 대상 Build No. 참조
    SELECT PJM.DPJT_KEY, PJM.DPJT_SEQ
      INTO V_DPJT_KEY, V_DPJT_SEQ
      FROM SCM_MGR.SPMS_PROJECT_MST PJM
     -- 권한 확인
     INNER JOIN
           SCM_MGR.SPMS_PROJECT_USER_MAP PUM
        ON 0 = 0
       AND PJM.DPJT_KEY = PUM.DPJT_KEY
       AND PUM.USER_ID  = P_SES_USER_ID
       AND PUM.DPJT_AUTH_STATUS = 'CONFIRM'
     -- Build No. 확인
     INNER JOIN
           SCM_MGR.SPMS_PROJECT_SAMPLE_BUILD BLD
        ON 0 = 0
       AND PJM.DPJT_KEY = BLD.DPJT_KEY
       AND BLD.DPJT_BUILD_NO = P_DPJT_BUILD_NO
     WHERE 0 = 0
       AND PJM.DPJT_CODE= P_DPJT_CODE
       --
       AND PJM.DPJT_REG_STATUS  = 'COMPLETE'
     ORDER BY PJM.DPJT_SEQ DESC
     FETCH FIRST 1 ROWS ONLY
    ;
    
    OPEN O_CURSOR FOR
        SELECT SDM.DPJT_BUILD_NO, SDM.DPJT_KEY
             , SDM.DPJT_USE_TYPE            -- 용도구분
             , SDM.REQ_ROUTE                -- 요청공정
             , SDM.DPJT_USE_TYPE_DETAIL     -- 용도상세
             , SDM.REQ_QTY                  -- 요청수량
             , OPR.UOM                      -- 단위
             , SDM.ITEM_ID                  -- 생산코드
             , SDM.CELL_ID                  -- 셀코드
             , SDM.SHIP_REQ_DATE            -- 출하필요일
             , SDM.SAMPLE_PROCESS_TYPE      -- 처리 유형
             , SDM.PROCESS_PLAN_DATE        -- 처리 예정일
             , SDM.PIC_USER_ID              -- PIC
             , SDM.DPJT_MGMT_NO             -- 관리 No.
             , SDM.NOTE                     -- 변경사유
             , SDM.DIVISION_ID, SDM.CELL_TYPE, SDM.STACK_METHOD, SDM.BIZ_TYPE, SDM.DPJT_CLASS
          FROM SCM_MGR.SPMS_PROJECT_SAMPLE_DEMAND SDM
          LEFT OUTER JOIN
               (
                    SELECT LKD.SEGMENT1     AS DIVISION_ID
                         , LKD.SEGMENT2     AS CELL_TYPE
                         , LKD.SEGMENT3     AS STACK_METHOD
                         , LKD.SEGMENT4     AS OPERATION_GROUP
                         , LKD.SEGMENT5     AS OPERATION
                         , LKD.ATTRIBUTE4   AS OPERATION_NAME
                         , LKD.ATTRIBUTE5   AS MATERIAL_CLASS
                         , LKD.ATTRIBUTE6   AS UOM
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_REQ_OPERATION'
                       AND LKM.VALID_YN = 'Y'
               ) OPR
            ON 0 = 0
           AND SDM.DIVISION_ID  = OPR.DIVISION_ID
           AND SDM.CELL_TYPE    = OPR.CELL_TYPE
           AND SDM.STACK_METHOD = OPR.STACK_METHOD
          LEFT OUTER JOIN
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
           AND SDM.DIVISION_ID  = SMD.DIVISION_ID
           AND SDM.STACK_METHOD = SMD.STACK_METHOD
         WHERE 0 = 0
           AND SDM.DPJT_BUILD_NO    = P_DPJT_BUILD_NO
           AND SDM.DPJT_KEY         = V_DPJT_KEY
           -- 관리 No 최신만 조회
           AND SDM.FINAL_YN         = 'Y'
         ORDER BY SDM.DPJT_MGMT_NO
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

END P_SDM2020_GET_PJT_SAMPLE_DEMAND;

-- Save Sample Demand List (RIGHT)
PROCEDURE P_SDM2020_SAVE_PJT_SAMPLE_DEMAND
(
    P_ACTIVE_FLAG               IN VARCHAR2             -- I(Insert) / D(Delete) / M(Modify)
  , P_DPJT_MGMT_NO              IN VARCHAR2
  , P_DPJT_BUILD_NO             IN VARCHAR2
  , P_DPJT_KEY                  IN VARCHAR2
  , P_DPJT_USE_TYPE             IN VARCHAR2
  , P_REQ_ROUTE                 IN VARCHAR2
  , P_DIVISION_ID               IN VARCHAR2
  , P_CELL_TYPE                 IN VARCHAR2
  , P_STACK_METHOD              IN VARCHAR2
  , P_BIZ_TYPE                  IN VARCHAR2
  , P_DPJT_USE_TYPE_DETAIL      IN VARCHAR2
  , P_REQ_QTY                   IN VARCHAR2
  , P_UOM                       IN VARCHAR2
  , P_ITEM_ID                   IN VARCHAR2
  , P_CELL_ID                   IN VARCHAR2
  , P_SHIP_REQ_DATE             IN VARCHAR2
  , P_SAMPLE_PROCESS_TYPE       IN VARCHAR2
  , P_PROCESS_PLAN_DATE         IN VARCHAR2
  , P_PIC_USER_ID               IN VARCHAR2
  , P_NOTE                      IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM2020.P_SDM2020_SAVE_PJT_SAMPLE_DEMAND
 * Description  : Save Sample Demand List (RIGHT)
 * Parameter    : PKG_SDM2020.P_SDM2020_SAVE_PJT_SAMPLE_DEMAND(
                            P_ACTIVE_FLAG, P_DPJT_KEY, P_DPJT_CODE, P_DPJT_SEQ
                          , P_DIVISION_ID, P_DPJT_CLASS, P_END_CUSTOMER, P_DPJT_NAME, P_CELL_TYPE, P_STACK_METHOD, P_BIZ_TYPE, P_SOP_DATE, P_SOP_PLANT_ID
                          , P_USER_ID, O_RESULT_CURSOR)
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.26   KTJ            최초 작성
 *                             Save Sample Demand List (RIGHT)
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    V_ACTIVE_FLAG               VARCHAR2(10);
    V_DPJT_MGMT_NO              VARCHAR2(50);
    V_DPJT_BUILD_NO             VARCHAR2(50);
    V_DPJT_KEY                  VARCHAR2(50);
    V_DPJT_USE_TYPE             VARCHAR2(50);
    V_REQ_ROUTE                 VARCHAR2(50);
    V_DIVISION_ID               VARCHAR2(30);
    V_CELL_TYPE                 VARCHAR2(50);
    V_STACK_METHOD              VARCHAR2(50);
    V_BIZ_TYPE                  VARCHAR2(50);
    V_DPJT_USE_TYPE_DETAIL      VARCHAR2(400);
    N_REQ_QTY                   NUMBER(20, 5);
    V_UOM                       VARCHAR2(200);
    V_ITEM_ID                   VARCHAR2(50);
    V_CELL_ID                   VARCHAR2(50);
    D_SHIP_REQ_DATE             DATE;
    V_SAMPLE_PROCESS_TYPE       VARCHAR2(50);
    D_PROCESS_PLAN_DATE         DATE;
    V_PIC_USER_ID               VARCHAR2(50);
    V_NOTE                      VARCHAR2(4000);
    
    N_MAX_CNT                   PLS_INTEGER := 0;
    
    V_USER_ID                   VARCHAR2(50) := P_SES_USER_ID;
    V_DPJT_SAMPLE_SEQ           VARCHAR2(50);
    V_DPJT_MGMT_VER             VARCHAR2(50);

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
    
    DBMS_OUTPUT.PUT_LINE('N_MAX_CNT : ' || TO_CHAR(N_MAX_CNT));
    
    -- Grid Row count Loop
    FOR i IN 1..N_MAX_CNT LOOP
        V_ACTIVE_FLAG               := TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG,                    '[^\^]+', 1, i));                   -- I(Insert) / D(Delete) / M(Modify)
        V_DPJT_MGMT_NO              := TRIM(REGEXP_SUBSTR(P_DPJT_MGMT_NO,                   '[^\^]+', 1, i));
        V_DPJT_BUILD_NO             := TRIM(REGEXP_SUBSTR(P_DPJT_BUILD_NO,                  '[^\^]+', 1, i));
        V_DPJT_KEY                  := TRIM(REGEXP_SUBSTR(P_DPJT_KEY,                       '[^\^]+', 1, i));
        V_DPJT_USE_TYPE             := TRIM(REGEXP_SUBSTR(P_DPJT_USE_TYPE,                  '[^\^]+', 1, i));
        V_REQ_ROUTE                 := TRIM(REGEXP_SUBSTR(V_REQ_ROUTE,                      '[^\^]+', 1, i));
        V_DIVISION_ID               := TRIM(REGEXP_SUBSTR(P_DIVISION_ID,                    '[^\^]+', 1, i));
        V_CELL_TYPE                 := TRIM(REGEXP_SUBSTR(P_CELL_TYPE,                      '[^\^]+', 1, i));
        V_STACK_METHOD              := TRIM(REGEXP_SUBSTR(P_STACK_METHOD,                   '[^\^]+', 1, i));
        V_BIZ_TYPE                  := TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,                       '[^\^]+', 1, i));
        V_DPJT_USE_TYPE_DETAIL      := TRIM(REGEXP_SUBSTR(V_DPJT_USE_TYPE_DETAIL,           '[^\^]+', 1, i));
        N_REQ_QTY                   := TO_NUMBER(REPLACE(TRIM(REGEXP_SUBSTR(P_REQ_QTY,      '[^\^]+', 1, i)), ',', ''));
        V_UOM                       := TRIM(REGEXP_SUBSTR(V_UOM,                            '[^\^]+', 1, i));
        V_ITEM_ID                   := TRIM(REGEXP_SUBSTR(V_ITEM_ID,                        '[^\^]+', 1, i));
        V_CELL_ID                   := TRIM(REGEXP_SUBSTR(V_CELL_ID,                        '[^\^]+', 1, i));
        D_SHIP_REQ_DATE             := TO_DATE(TRIM(REGEXP_SUBSTR(D_SHIP_REQ_DATE,          '[^\^]+', 1, i)), 'YYYY-MM-DD HH24:MI:SS');
        V_SAMPLE_PROCESS_TYPE       := TRIM(REGEXP_SUBSTR(V_SAMPLE_PROCESS_TYPE,            '[^\^]+', 1, i));
        D_PROCESS_PLAN_DATE         := TO_DATE(TRIM(REGEXP_SUBSTR(D_PROCESS_PLAN_DATE,      '[^\^]+', 1, i)), 'YYYY-MM-DD HH24:MI:SS');
        V_PIC_USER_ID               := TRIM(REGEXP_SUBSTR(V_PIC_USER_ID,                    '[^\^]+', 1, i));
        V_NOTE                      := TRIM(REGEXP_SUBSTR(V_NOTE,                           '[^\^]+', 1, i));
        
        /*
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_ACTIVE_FLAG : ' || V_ACTIVE_FLAG);
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_DPJT_NAME : ' || V_DPJT_NAME);
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_DIVISION_ID : ' || V_DIVISION_ID);
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_DPJT_CLASS : ' || V_DPJT_CLASS);
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_END_CUSTOMER : ' || V_END_CUSTOMER);
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_CELL_TYPE : ' || V_CELL_TYPE);
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_STACK_METHOD : ' || V_STACK_METHOD);
        DBMS_OUTPUT.PUT_LINE('LOOP : ' || TO_CHAR(i) || ', V_BIZ_TYPE : ' || V_BIZ_TYPE);
        */
    
        -- 1. 신규 등록
        IF V_ACTIVE_FLAG = 'I' -- I(Insert) / D(Delete) / M(Modify)
            -- 필수항목 조건
            AND ( NVL(V_DIVISION_ID,    '') != '' OR V_DIVISION_ID      IS NOT NULL )
            AND ( NVL(V_CELL_TYPE,      '') != '' OR V_CELL_TYPE        IS NOT NULL )
            AND ( NVL(V_STACK_METHOD,   '') != '' OR V_STACK_METHOD     IS NOT NULL )
            AND ( NVL(V_BIZ_TYPE,       '') != '' OR V_BIZ_TYPE         IS NOT NULL )
        THEN
            
            DBMS_OUTPUT.PUT_LINE('1. INSERT : ' || TO_CHAR(i));
            
            -- 여기서 신규 관리No. 생성 필요 : DPJT_MGMT_NO, DPJT_SAMPLE_SEQ, DPJT_MGMT_VER
            
            INSERT INTO SCM_MGR.SPMS_PROJECT_SAMPLE_DEMAND (
                DPJT_MGMT_NO, DPJT_BUILD_NO, DPJT_KEY
              , DPJT_USE_TYPE, DPJT_SAMPLE_SEQ, DPJT_MGMT_VER, FINAL_YN, DPJT_CODE, DPJT_SEQ, DPJT_NAME
              , DIVISION_ID, DPJT_CLASS, END_CUSTOMER, CELL_TYPE, BIZ_TYPE, STACK_METHOD
              , REQ_ROUTE, DPJT_USE_TYPE_DETAIL, ITEM_ID, CELL_ID, REQ_QTY, SHIP_REQ_DATE
              , SAMPLE_PROCESS_TYPE, PROCESS_PLAN_DATE, PIC_USER_ID, NOTE
              , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
            )
            SELECT V_DPJT_MGMT_NO           AS DPJT_MGMT_NO
                 , BLD.DPJT_BUILD_NO, PJM.DPJT_KEY
                 --
                 , V_DPJT_USE_TYPE          AS DPJT_USE_TYPE
                 , V_DPJT_SAMPLE_SEQ        AS DPJT_SAMPLE_SEQ
                 , V_DPJT_MGMT_VER          AS DPJT_MGMT_VER
                 , 'Y'                      AS FINAL_YN
                 , PJM.DPJT_CODE, PJM.DPJT_SEQ, PJM.DPJT_NAME
                 , PJM.DIVISION_ID, PJM.DPJT_CLASS, PJM.END_CUSTOMER, PJM.CELL_TYPE, PJM.BIZ_TYPE, PJM.STACK_METHOD
                 , V_REQ_ROUTE              AS REQ_ROUTE
                 , V_DPJT_USE_TYPE_DETAIL   AS DPJT_USE_TYPE_DETAIL
                 , V_ITEM_ID                AS ITEM_ID
                 , V_CELL_ID                AS CELL_ID
                 , N_REQ_QTY                AS REQ_QTY
                 , D_SHIP_REQ_DATE          AS SHIP_REQ_DATE
                 , V_SAMPLE_PROCESS_TYPE    AS SAMPLE_PROCESS_TYPE
                 , D_PROCESS_PLAN_DATE      AS PROCESS_PLAN_DATE
                 , V_PIC_USER_ID            AS PIC_USER_ID
                 , V_NOTE                   AS NOTE
                 , V_USER_ID CREATED_BY, SYSDATE CREATION_DATE, V_USER_ID LAST_UPDATED_BY, SYSDATE LAST_UPDATE_DATE
              FROM SCM_MGR.SPMS_PROJECT_MST PJM
             INNER JOIN
                   SCM_MGR.SPMS_PROJECT_SAMPLE_BUILD BLD
                ON 0 = 0
               AND PJM.DPJT_KEY         = BLD.DPJT_KEY
               AND BLD.DPJT_BUILD_NO    = V_DPJT_BUILD_NO
             WHERE 0 = 0
               AND PJM.DPJT_KEY         = V_DPJT_KEY
            ;
            
            N_INSERT_COUNT := N_INSERT_COUNT + SQL%ROWCOUNT;
        END IF;
            
        -- 2. 수정
        IF V_ACTIVE_FLAG = 'M' -- I(Insert) / D(Delete) / M(Modify)
            -- 필수항목 조건
            AND ( NVL(V_DPJT_KEY,       '') != '' OR V_DPJT_KEY         IS NOT NULL )
        THEN
            DBMS_OUTPUT.PUT_LINE('2. MERGE : ' || TO_CHAR(i));
        
            -- 용도 구분을 변경하는 경우 고려
             MERGE INTO SCM_MGR.SPMS_PROJECT_SAMPLE_DEMAND SRC
             USING (
                        SELECT V_DPJT_MGMT_NO           AS DPJT_MGMT_NO
                             , V_DPJT_BUILD_NO          AS DPJT_BUILD_NO
                             , V_DPJT_KEY               AS DPJT_KEY
                             --
                             , V_DPJT_USE_TYPE          AS DPJT_USE_TYPE
                             , V_DPJT_SAMPLE_SEQ        AS DPJT_SAMPLE_SEQ
                             , V_DPJT_MGMT_VER          AS DPJT_MGMT_VER
                             --
                             , V_CELL_TYPE              AS CELL_TYPE
                             , V_BIZ_TYPE               AS BIZ_TYPE
                             , V_STACK_METHOD           AS STACK_METHOD
                             , V_REQ_ROUTE              AS REQ_ROUTE
                             , V_DPJT_USE_TYPE_DETAIL   AS DPJT_USE_TYPE_DETAIL
                             , V_ITEM_ID                AS ITEM_ID
                             , V_CELL_ID                AS CELL_ID
                             , N_REQ_QTY                AS REQ_QTY
                             , D_SHIP_REQ_DATE          AS SHIP_REQ_DATE
                             , V_SAMPLE_PROCESS_TYPE    AS SAMPLE_PROCESS_TYPE
                             , D_PROCESS_PLAN_DATE      AS PROCESS_PLAN_DATE
                             , V_PIC_USER_ID            AS PIC_USER_ID
                             , V_NOTE                   AS NOTE
                          FROM DUAL
                   ) DAT
                ON (
                       0 = 0
                   AND SRC.DPJT_MGMT_NO     = DAT.DPJT_MGMT_NO
                   AND SRC.DPJT_BUILD_NO    = DAT.DPJT_BUILD_NO
                   AND SRC.DPJT_KEY         = DAT.DPJT_KEY
                   )
              WHEN MATCHED THEN
            UPDATE
               SET SRC.LAST_UPDATED_BY      = V_USER_ID
                 , SRC.LAST_UPDATE_DATE     = SYSDATE
                 --
                 , SRC.DPJT_USE_TYPE        = CASE WHEN SRC.DPJT_USE_TYPE = DAT.DPJT_USE_TYPE   THEN SRC.DPJT_USE_TYPE  ELSE DAT.DPJT_USE_TYPE  END
                 , SRC.DPJT_SAMPLE_SEQ      = DAT.DPJT_SAMPLE_SEQ
                 , SRC.DPJT_MGMT_VER        = DAT.DPJT_MGMT_VER
                 , SRC.CELL_TYPE            = DAT.CELL_TYPE
                 , SRC.BIZ_TYPE             = DAT.BIZ_TYPE
                 , SRC.STACK_METHOD         = DAT.STACK_METHOD
                 , SRC.REQ_ROUTE            = DAT.REQ_ROUTE
                 , SRC.DPJT_USE_TYPE_DETAIL = DAT.DPJT_USE_TYPE_DETAIL
                 , SRC.ITEM_ID              = DAT.ITEM_ID
                 , SRC.CELL_ID              = DAT.CELL_ID
                 , SRC.REQ_QTY              = DAT.REQ_QTY
                 , SRC.SHIP_REQ_DATE        = DAT.SHIP_REQ_DATE
                 , SRC.SAMPLE_PROCESS_TYPE  = DAT.SAMPLE_PROCESS_TYPE
                 , SRC.PROCESS_PLAN_DATE    = DAT.PROCESS_PLAN_DATE
                 , SRC.PIC_USER_ID          = DAT.PIC_USER_ID
                 , SRC.NOTE                 = DAT.NOTE
             WHERE 0 = 0
               -- 수정 내역이 존재해야 저장
               AND NOT (
                        0 = 0
                    AND SRC.DPJT_USE_TYPE           = DAT.DPJT_USE_TYPE
                    AND SRC.DPJT_SAMPLE_SEQ         = DAT.DPJT_SAMPLE_SEQ
                    AND SRC.DPJT_MGMT_VER           = DAT.DPJT_MGMT_VER
                    AND SRC.CELL_TYPE               = DAT.CELL_TYPE
                    AND SRC.BIZ_TYPE                = DAT.BIZ_TYPE
                    AND SRC.STACK_METHOD            = DAT.STACK_METHOD
                    AND SRC.REQ_ROUTE               = DAT.REQ_ROUTE
                    AND SRC.DPJT_USE_TYPE_DETAIL    = DAT.DPJT_USE_TYPE_DETAIL
                    AND SRC.ITEM_ID                 = DAT.ITEM_ID
                    AND SRC.CELL_ID                 = DAT.CELL_ID
                    AND SRC.REQ_QTY                 = DAT.REQ_QTY
                    AND SRC.SHIP_REQ_DATE           = DAT.SHIP_REQ_DATE
                    AND SRC.SAMPLE_PROCESS_TYPE     = DAT.SAMPLE_PROCESS_TYPE
                    AND SRC.PROCESS_PLAN_DATE       = DAT.PROCESS_PLAN_DATE
                    AND SRC.PIC_USER_ID             = DAT.PIC_USER_ID
                    AND SRC.NOTE                    = DAT.NOTE
                   )
            ;
            N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;
        END IF;
            
        -- 3. 삭제
        IF V_ACTIVE_FLAG = 'D' -- I(Insert) / D(Delete) / M(Modify)
            -- 필수항목 조건
            AND ( NVL(V_DPJT_KEY,       '') != '' OR V_DPJT_KEY         IS NOT NULL )
        THEN
            DBMS_OUTPUT.PUT_LINE('3. DELETE : ' || TO_CHAR(i));
            DELETE
            --SELECT PJT.*
              FROM SCM_MGR.SPMS_PROJECT_SAMPLE_DEMAND SDM
             WHERE 0 = 0
               AND SDM.DPJT_MGMT_NO     = V_DPJT_MGMT_NO
               AND SDM.DPJT_BUILD_NO    = V_DPJT_BUILD_NO
               AND SDM.DPJT_KEY         = V_DPJT_KEY
            ;
            N_DEL_COUNT := N_DEL_COUNT + SQL%ROWCOUNT;
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
            'P_ACTIVE_FLAG'             VALUE SUBSTR(P_ACTIVE_FLAG, 1, 200)
          , 'P_DPJT_MGMT_NO'            VALUE SUBSTR(P_DPJT_MGMT_NO, 1, 200)
          , 'P_DPJT_BUILD_NO'           VALUE SUBSTR(P_DPJT_BUILD_NO, 1, 200)
          , 'P_DPJT_KEY'                VALUE SUBSTR(P_DPJT_KEY, 1, 200)
          , 'P_DPJT_USE_TYPE'           VALUE SUBSTR(P_DPJT_USE_TYPE, 1, 200)
          , 'P_REQ_ROUTE'               VALUE SUBSTR(P_REQ_ROUTE, 1, 200)
          , 'P_DIVISION_ID'             VALUE SUBSTR(P_DIVISION_ID, 1, 200)
          , 'P_CELL_TYPE'               VALUE SUBSTR(P_CELL_TYPE, 1, 200)
          , 'P_STACK_METHOD'            VALUE SUBSTR(P_STACK_METHOD, 1, 200)
          , 'P_BIZ_TYPE'                VALUE SUBSTR(P_BIZ_TYPE, 1, 200)
          , 'P_DPJT_USE_TYPE_DETAIL'    VALUE SUBSTR(P_DPJT_USE_TYPE_DETAIL, 1, 200)
          , 'P_REQ_QTY'                 VALUE SUBSTR(P_REQ_QTY, 1, 200)
          , 'P_UOM'                     VALUE SUBSTR(P_UOM, 1, 200)
          , 'P_ITEM_ID'                 VALUE SUBSTR(P_ITEM_ID, 1, 200)
          , 'P_CELL_ID'                 VALUE SUBSTR(P_CELL_ID, 1, 200)
          , 'P_SHIP_REQ_DATE'           VALUE SUBSTR(P_SHIP_REQ_DATE, 1, 200)
          , 'P_SAMPLE_PROCESS_TYPE'     VALUE SUBSTR(P_SAMPLE_PROCESS_TYPE, 1, 200)
          , 'P_PROCESS_PLAN_DATE'       VALUE SUBSTR(P_PROCESS_PLAN_DATE, 1, 200)
          , 'P_PIC_USER_ID'             VALUE SUBSTR(P_PIC_USER_ID, 1, 200)
          , 'P_NOTE'                    VALUE SUBSTR(P_NOTE, 1, 200)
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

END P_SDM2020_SAVE_PJT_SAMPLE_DEMAND;

-- 1 ~ 9, A ~ Z 차례로 조회
PROCEDURE P_SDM2020_GET_SEQ_LIST (
    P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : P_SDM2020_GET_SEQ_LIST
 * Description  : 1 ~ 9, A ~ Z 차례로 조회
 * Parameter    : CALL SCM_MGR.PKG_SDM2020.P_SDM2020_GET_SEQ_LIST(:P_SES_USER_ID, ?, ?);
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.26   KTJ            최초 작성
 *                             1 ~ 9, A ~ Z 차례로 조회
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
    
    V_DPJT_KEY          VARCHAR2(50);
    V_DPJT_SEQ          VARCHAR2(50);

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    OPEN O_CURSOR FOR
        SELECT SEQ_VAL
          FROM (
                    SELECT TO_CHAR(LEVEL) AS SEQ_VAL
                      FROM DUAL
                    CONNECT BY LEVEL <= 9
                    UNION ALL
                    SELECT CHR(ASCII('A') + LEVEL - 1) AS SEQ_VAL
                      FROM DUAL
                    CONNECT BY LEVEL <= 26
               ) A
         ORDER BY SEQ_VAL
        ;
    
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_SES_USER_ID'                 VALUE P_SES_USER_ID
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

END P_SDM2020_GET_SEQ_LIST;

END PKG_SDM2020;
