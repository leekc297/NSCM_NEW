-- SOURCE-FRESH: SCM_MGR.PKG_SDM5010 PACKAGE BODY LAST_DDL=2026-10-09 13:39:29 FETCHED=2026-11-13 19:08:52 DB=ZIOUI1
CREATE OR REPLACE PACKAGE BODY           "PKG_SDM5010"
AS
/*
 * Program ID   : PKG_SDM5010
 * Description  : Project Master
 * Parameter    : NONE
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.14   KTJ            최초 작성
 *                             프로젝트 Master 관리
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

PROCEDURE P_SDM5010_GET_TAB1_PJT_REG_REQ (
    P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , P_SES_MENU_ID               IN VARCHAR2
  , P_SES_USER_GR_ID            IN VARCHAR2     -- 권한 그룹

  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM5010
 * Description  : Project Registration Request
 * Parameter    : PKG_SDM5010.P_SDM5010_GET_TAB1_PJT_REG_REQ(P_SES_DIVISION_ID, P_SES_USER_ID, P_SES_MENU_ID, P_SES_USER_GR_ID)
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.14   KTJ            최초 작성
 *                             프로젝트 등록 요청
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
        SELECT PJM.DPJT_KEY
             -- 최초 프로젝트 등록 대기 상태는 프로젝트 코드를 보여주지 않음
             , CASE WHEN PJM.DPJT_REG_STATUS = 'REQ_MOD' THEN PJM.DPJT_CODE ELSE '' END AS DPJT_CODE
             -- 최초 프로젝트 등록 대기 상태만 프로젝트 코드 편집 가능 : 한번 생성한 프로젝트 코드는 계속 유지
             , CASE WHEN PJM.DPJT_REG_CAT = 'MOD' THEN 'N' ELSE 'Y' END AS DPJT_CODE_MOD_YN
             , PJM.DPJT_SEQ
             , PJM.DPJT_REG_CAT, PRC.DPJT_REG_CAT_NAME
             , PJM.DIVISION_ID, DIV.DIVISION_ID DIVISION_NAME
             , PJM.DPJT_CLASS, PCL.DPJT_CLASS_NAME
             , PJM.END_CUSTOMER, NVL(EDC.END_CUSTOMER_NAME, PJM.END_CUSTOMER) END_CUSTOMER_NAME
             , PJM.DPJT_NAME
             , PJM.CELL_TYPE, CLT.CELL_TYPE_NAME
             , PJM.STACK_METHOD, SMD.STACK_METHOD_NAME
             , PJM.BIZ_TYPE, BIZ.BIZ_TYPE_NAME
             , PJM.SOP_DATE
             , PJM.SOP_PLANT_ID, PLT.SOP_PLANT_NAME
             , USR.DEPT_ID, DPT.DEPT_NAME_KO DEPT_NAME, DPT.DEPT_NAME_KO, DPT.DEPT_NAME_EN, DPT.DEPT_NAME_CN
             , PJM.MGMT_USER_ID, USR.USER_NAME, USR.USER_NAME_EN
             , '권한관리' AS DPJT_ATUH_REG_STR
             --, CASE WHEN NVL(USM.AUTH_CNT, 0) = 0 THEN 'WRITING' ELSE 'COMPLETE' END DPJT_ATUH_REG_STATUS
             , ARS.DPJT_ATUH_REG_STATUS
             , ARS.DPJT_ATUH_REG_STATUS_NAME
             , ARS.DPJT_ATUH_REG_STATUS_COLOR_TYPE
             -- DPJT_CODE 는 최상단에 있음
             , PJM.NOTE
             , '' REG_COL   -- 등록 컬럼 : 승인/반려 기능 버튼 위치
             , PJM.DPJT_KEY_PARENT
          FROM SCM_MGR.SPMS_PROJECT_MST PJM
         INNER JOIN
               SCM_MGR.SCM_MST_DIVISION DIV
            ON 0 = 0
           AND PJM.DIVISION_ID = DIV.DIVISION_ID
         INNER JOIN
               (
                    SELECT LKD.SEGMENT1 AS DPJT_REG_CAT
                         , LKD.SEGMENT2 AS DPJT_REG_CAT_NAME
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_DPJT_REG_CAT'
                       AND LKM.VALID_YN = 'Y'
               ) PRC
            ON 0 = 0
           AND PJM.DPJT_REG_CAT = PRC.DPJT_REG_CAT
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
           AND PJM.DIVISION_ID  = P_SES_DIVISION_ID
           -- 등록요청/변경요청 만 조회
           AND PJM.DPJT_REG_STATUS IN ('WAITING', 'REQ_MOD')
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

END P_SDM5010_GET_TAB1_PJT_REG_REQ;

-- 프로젝트 등록요청 반려
PROCEDURE P_SDM5010_BTN_TAB1_CANCEL
(
    P_DIVISION_ID               IN VARCHAR2
  , P_DPJT_KEY                  IN VARCHAR2
  , P_DPJT_KEY_PARENT           IN VARCHAR2
  , P_NOTE                      IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM5010.P_SDM5010_BTN_TAB1_CANCEL
 * Description  : 프로젝트 권한 요청 반려
 * Parameter    : PKG_SDM5010.P_SDM5010_BTN_TAB1_CANCEL(P_DIVISION_ID, P_DPJT_KEY, P_DPJT_KEY_PARENT, P_SES_USER_ID, O_RESULT_CURSOR)
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.14   KTJ            최초 작성
 *                             프로젝트 등록요청 반려
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    V_DPJT_KEY                  VARCHAR2(50)    := P_DPJT_KEY;
    V_NOTE                      VARCHAR2(4000)  := P_NOTE;
    
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
    UPDATE SCM_MGR.SPMS_PROJECT_MST
       SET LAST_UPDATED_BY      = P_SES_USER_ID
         , LAST_UPDATE_DATE     = SYSDATE
         --
         , DPJT_REG_STATUS      = 'REJECT'          -- 반려
         , DPJT_MGMT_STATUS     = 'DIABLED'         -- 비활성
         , NOTE                 = P_NOTE
         , CNFM_USER_ID         = P_SES_USER_ID     -- 반려인 경우도 승인자 저장
         , REG_COMP_DATE        = TRUNC(SYSDATE)
     WHERE 0 = 0
       AND DPJT_KEY             = P_DPJT_KEY
    ;
    N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;

    -- 원 Project Code 상태 복구 : MODIFYING => COMPLETE
    IF ( P_DPJT_KEY_PARENT IS NOT NULL ) THEN   -- [E20261113-EMPTYCMP-B] 결과에 영향 없는 빈 문자열 비교 항 삭제
        
        UPDATE SCM_MGR.SPMS_PROJECT_MST
           SET LAST_UPDATED_BY      = P_SES_USER_ID
             , LAST_UPDATE_DATE     = SYSDATE
             --
             , DPJT_REG_STATUS      = 'COMPLETE'    -- 등록완료
             , DPJT_MGMT_STATUS     = 'NORMAL'      -- 정상
         WHERE 0 = 0
           AND DPJT_KEY = P_DPJT_KEY
        ;
        
        -- 동일 Project Code 건에 대해 NOTE 값을 동일하게 Updaet
        --  . 기존 Note 값에 신규 추가되는 Note 값을 붙여서 저장
         MERGE INTO SCM_MGR.SPMS_PROJECT_MST SRC
         USING (
                    SELECT PJM.DPJT_CODE, PJM.NOTE
                      FROM SCM_MGR.SPMS_PROJECT_MST PJM
                     WHERE 0 = 0
                       AND PJM.DPJT_KEY = P_DPJT_KEY
               ) DAT
            ON (
                    0 = 0
                AND SRC.DPJT_CODE = DAT.DPJT_CODE
               )
          WHEN MATCHED THEN
        UPDATE
           SET SRC.NOTE = DAT.NOTE || ', ' || P_NOTE
        ;
        N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;
        
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
              'P_DIVISION_ID'       VALUE P_DIVISION_ID
            , 'P_DPJT_KEY'          VALUE P_DPJT_KEY
            , 'P_DPJT_KEY_PARENT'   VALUE P_DPJT_KEY_PARENT
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

END P_SDM5010_BTN_TAB1_CANCEL;

-- 프로젝트 등록요청 승인
PROCEDURE P_SDM5010_BTN_TAB1_CONFIRM
(
    P_DPJT_KEY                  IN VARCHAR2
  , P_DPJT_CODE                 IN VARCHAR2
  , P_DPJT_SEQ                  IN VARCHAR2
  , P_DPJT_KEY_PARENT           IN VARCHAR2
  , P_DIVISION_ID               IN VARCHAR2
  , P_DPJT_CLASS                IN VARCHAR2
  , P_END_CUSTOMER              IN VARCHAR2
  , P_DPJT_NAME                 IN VARCHAR2
  , P_CELL_TYPE                 IN VARCHAR2
  , P_STACK_METHOD              IN VARCHAR2
  , P_BIZ_TYPE                  IN VARCHAR2
  , P_SOP_DATE                  IN VARCHAR2
  , P_SOP_PLANT_ID              IN VARCHAR2
  , P_NOTE                      IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM5010.P_SDM5010_BTN_TAB1_CONFIRM
 * Description  : 프로젝트 권한 요청 승인
 * Parameter    : PKG_SDM5010.P_SDM5010_BTN_TAB1_CONFIRM(P_DIVISION_ID, P_DPJT_KEY, P_DPJT_KEY_PARENT, P_SES_USER_ID, O_RESULT_CURSOR)
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.14   KTJ            최초 작성
 *                             프로젝트 등록요청 승인
 * ---------------------------------------------------------------------------------------------------
 * 
 * ---------------------------------------------------------------------------------------------------
 */

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    V_DPJT_KEY                  VARCHAR2(50) := P_DPJT_KEY;
    V_DPJT_CODE                 VARCHAR2(50) := P_DPJT_CODE;
    N_DPJT_SEQ                  NUMBER(20, 0);
    
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

    -- 신규 DPJT_KEY 설정
    SELECT PJM.DPJT_KEY, PJM.DPJT_CODE, PJM.DPJT_SEQ
      INTO V_DPJT_KEY, V_DPJT_CODE, N_DPJT_SEQ
      FROM SCM_MGR.SPMS_PROJECT_MST PJM
     WHERE PJM.DPJT_KEY = P_DPJT_KEY
    ;
    -- 수정 Case 인 경우 Project Code 유지
    IF ( P_DPJT_KEY_PARENT IS NOT NULL ) THEN   -- [E20261113-EMPTYCMP-B] 결과에 영향 없는 빈 문자열 비교 항 삭제
        V_DPJT_KEY  := P_DPJT_KEY;
    -- 신규 케이스
    ELSE
        V_DPJT_CODE := P_DPJT_CODE;
        V_DPJT_KEY  := V_DPJT_CODE || '_' || TO_CHAR(N_DPJT_SEQ, 'FM000000');
    
        -- Project Code 중복 체크
        BEGIN
            SELECT 1 INTO N_CNT FROM DUAL
            WHERE EXISTS (
                SELECT 1 FROM SCM_MGR.SPMS_PROJECT_MST
                WHERE DPJT_CODE = P_DPJT_CODE
            );
            v_log_type    := 'INVALID';
            V_S_CODE      := 'MSG00060';
            V_S_VALIDATION := ' ';
            GOTO VALIDATION_FAIL;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;
        
    END IF;
    
    -- 승인 Process 처리
    UPDATE SCM_MGR.SPMS_PROJECT_MST
       SET LAST_UPDATED_BY      = P_SES_USER_ID
         , LAST_UPDATE_DATE     = SYSDATE
         --
         , DPJT_KEY             = V_DPJT_KEY
         , DPJT_CODE            = V_DPJT_CODE
         , DPJT_SEQ             = N_DPJT_SEQ
         , DPJT_NAME            = P_DPJT_NAME
         , DIVISION_ID          = P_DIVISION_ID
         , DPJT_CLASS           = P_DPJT_CLASS
         , END_CUSTOMER         = P_END_CUSTOMER
         , CELL_TYPE            = P_CELL_TYPE
         , BIZ_TYPE             = P_BIZ_TYPE
         , STACK_METHOD         = P_STACK_METHOD
         , SOP_DATE             = TO_DATE(SUBSTR(P_SOP_DATE, 1, 10), 'YYYY-MM-DD')
         , SOP_PLANT_ID         = P_SOP_PLANT_ID
         , NOTE                 = P_NOTE
         , DPJT_REG_STATUS      = 'COMPLETE'    -- 등록완료
         , DPJT_MGMT_STATUS     = 'NORMAL'      -- Normal
         , CNFM_USER_ID         = P_SES_USER_ID
         , REG_COMP_DATE        = TRUNC(SYSDATE)
     WHERE 0 = 0
       AND DPJT_KEY             = P_DPJT_KEY
       -- 6자리 프로젝트 코드 반드시 존재 ==> 9자리로 수정
       AND ( V_DPJT_CODE IS NOT NULL )   -- [E20261113-EMPTYCMP-B] 결과에 영향 없는 빈 문자열 비교 항 삭제
       --AND LENGTH(V_DPJT_CODE ) = 9
       AND LENGTH(V_DPJT_CODE ) IN (6, 9)
    ;
    N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;
    
    -- 권한 관리 테이블의 Project 정보 Update
    UPDATE SCM_MGR.SPMS_PROJECT_USER_MAP
       SET LAST_UPDATED_BY      = P_SES_USER_ID
         , LAST_UPDATE_DATE     = SYSDATE
         --
         , DPJT_KEY             = V_DPJT_KEY
         , DPJT_CODE            = V_DPJT_CODE
         , DPJT_SEQ             = N_DPJT_SEQ
         , DPJT_NAME            = P_DPJT_NAME
     WHERE 0 = 0
       AND DPJT_KEY             = P_DPJT_KEY
    ;

    -- 원 Project Code 상태 변경 : MODIFYING => MODIFIED
    IF ( P_DPJT_KEY_PARENT IS NOT NULL ) THEN   -- [E20261113-EMPTYCMP-B] 결과에 영향 없는 빈 문자열 비교 항 삭제
        
        UPDATE SCM_MGR.SPMS_PROJECT_MST
           SET LAST_UPDATED_BY      = P_SES_USER_ID
             , LAST_UPDATE_DATE     = SYSDATE
             --
             , DPJT_REG_STATUS      = 'MODIFIED'    -- 변경완료
             , DPJT_MGMT_STATUS     = 'DISABLED'    -- 비활성
         WHERE 0 = 0
           AND DPJT_KEY = P_DPJT_KEY_PARENT
        ;
        
        -- 동일 Project Code 건에 대해 NOTE 값을 동일하게 Updaet
        --  . 기존 Note 값에 신규 추가되는 Note 값을 붙여서 저장
         MERGE INTO SCM_MGR.SPMS_PROJECT_MST SRC
         USING (
                    SELECT PJM.DPJT_CODE, PJM.NOTE
                      FROM SCM_MGR.SPMS_PROJECT_MST PJM
                     WHERE 0 = 0
                       AND PJM.DPJT_KEY = P_DPJT_KEY
               ) DAT
            ON (
                    0 = 0
                AND SRC.DPJT_CODE = DAT.DPJT_CODE
               )
          WHEN MATCHED THEN
        UPDATE
           SET SRC.NOTE = SRC.NOTE || ', ' || DAT.NOTE
        ;
        N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;
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
              'P_DIVISION_ID'       VALUE P_DIVISION_ID
            , 'P_DPJT_KEY'          VALUE P_DPJT_KEY
            , 'P_DPJT_KEY_PARENT'   VALUE P_DPJT_KEY_PARENT
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

END P_SDM5010_BTN_TAB1_CONFIRM;

-- 프로젝트 Master 관리
PROCEDURE P_SDM5010_GET_TAB2_PJT_MASTER (
    P_DIVISION_ID               IN VARCHAR2
  , P_END_CUSTOMER              IN VARCHAR2     -- 고객
  , P_CELL_TYPE                 IN VARCHAR2     -- Cell 유형
  , P_BIZ_TYPE                  IN VARCHAR2     -- Biz Type
  , P_DPJT_DEVELOP_STATUS       IN VARCHAR2     -- 개발 현황
  , P_REG_COMP_DATE_FR          IN VARCHAR2     -- 등록 완료일
  , P_REG_COMP_DATE_TO          IN VARCHAR2     -- 등록 완료일
  , P_SES_USER_ID               IN VARCHAR2
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM5010.P_SDM5010_GET_TAB2_PJT_MASTER
 * Description  : Project Master Management
 * Parameter    : 
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.06   KTJ            최초 작성
 *                             프로젝트 Master 관리
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
        , WT_FILTER_CELL_TYPE AS (
            SELECT NR, TOKEN FROM SCM_MGR.UF_FX_STRING_SPLIT(P_CELL_TYPE, ',')
        )
        , WT_FILTER_BIZ_TYPE AS (
            SELECT NR, TOKEN FROM SCM_MGR.UF_FX_STRING_SPLIT(P_BIZ_TYPE, ',')
        )
        , WT_FILTER_DEVELOP_STATUS AS (
            SELECT NR, TOKEN FROM SCM_MGR.UF_FX_STRING_SPLIT(P_DPJT_DEVELOP_STATUS, ',')
        )
        SELECT PJM.DPJT_KEY
             --, PJM.DPJT_CODE
             , CASE WHEN PJM.DPJT_REG_STATUS = 'REJECT' THEN '' ELSE PJM.DPJT_CODE END AS DPJT_CODE
             , PJM.DPJT_SEQ
             , PJM.DPJT_REG_CAT, PRC.DPJT_REG_CAT_NAME
             , PJM.DIVISION_ID, DIV.DIVISION_ID DIVISION_NAME
             , PJM.DPJT_CLASS, PCL.DPJT_CLASS_NAME
             , PJM.END_CUSTOMER, NVL(EDC.END_CUSTOMER_NAME, PJM.END_CUSTOMER) END_CUSTOMER_NAME
             , PJM.DPJT_NAME
             , PJM.CELL_TYPE, CLT.CELL_TYPE_NAME
             , PJM.STACK_METHOD, SMD.STACK_METHOD_NAME
             , PJM.BIZ_TYPE, BIZ.BIZ_TYPE_NAME
             , PJM.SOP_DATE
             , PJM.SOP_PLANT_ID, PLT.SOP_PLANT_NAME
             -- DPJT_CODE 는 상단에 있음
             , PJM.NOTE
             , PJM.REG_REQ_DATE, PJM.REG_COMP_DATE
             -- 승인자
             , PJM.CNFM_USER_ID, CUS.USER_NAME AS CNFM_USER_NAME
             , CUS.DEPT_ID, CUS.DEPT_NAME
             -- 관리자
             , PJM.MGMT_USER_ID, MUS.USER_NAME AS MGMT_USER_NAME
             , '권한관리' AS DPJT_ATUH_REG_STR
             --, CASE WHEN NVL(USM.AUTH_CNT, 0) = 0 THEN 'WRITING' ELSE 'COMPLETE' END DPJT_ATUH_REG_STATUS
             , ARS.DPJT_ATUH_REG_STATUS
             , ARS.DPJT_ATUH_REG_STATUS_NAME
             , ARS.DPJT_ATUH_REG_STATUS_COLOR_TYPE
             , PJM.DPJT_DEVELOP_STATUS, DVL.DPJT_DEVELOP_STATUS_NAME
             , CASE WHEN PJM.DPJT_MGMT_STATUS = 'DISABLED' THEN 'CHECKED' ELSE 'UNCHECKED' END AS DISABLE_YN
             , PJM.REG_COMP_DATE
          FROM SCM_MGR.SPMS_PROJECT_MST PJM
         INNER JOIN
               SCM_MGR.SCM_MST_DIVISION DIV
            ON 0 = 0
           AND PJM.DIVISION_ID = DIV.DIVISION_ID
         INNER JOIN
               (
                    SELECT LKD.SEGMENT1 AS DPJT_REG_CAT
                         , LKD.SEGMENT2 AS DPJT_REG_CAT_NAME
                      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER LKM
                     INNER JOIN
                           SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LKD
                        ON 0 = 0
                       AND LKM.LOOKUP_TYPE = LKD.LOOKUP_TYPE
                       AND LKD.VALID_YN = 'Y'
                     WHERE 0 = 0
                       AND LKM.LOOKUP_TYPE = 'SPMS_DPJT_REG_CAT'
                       AND LKM.VALID_YN = 'Y'
               ) PRC
            ON 0 = 0
           AND PJM.DPJT_REG_CAT = PRC.DPJT_REG_CAT
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
                       -- 권한 등록 상태만 조회
                       -- Admin 제외
                       AND USM.DPJT_AUTH_STATUS = 'CONFIRM'
                       AND USM.DPJT_AUTH_TYPE   IN ('WRITE', 'READ')
                     GROUP BY USM.DPJT_KEY
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
          -- 승인자
          LEFT OUTER JOIN
               (
                    SELECT USR.USER_ID, USR.USER_NAME, USR.USER_NAME_EN, USR.JOB_CODE, USR.JOB_NAME
                         , USR.DEPT_ID, DPT.DEPT_NAME_KO DEPT_NAME, DPT.DEPT_NAME_EN, DPT.DEPT_NAME_KO, DPT.DEPT_NAME_CN
                      FROM SCM_MGR.SCM_MST_SSO_USER_INFO USR
                     INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO DPT ON USR.DEPT_ID = DPT.DEPT_ID
                     WHERE 0 = 0
               ) CUS -- Confirm USer
            ON 0 = 0
           AND PJM.CNFM_USER_ID = CUS.USER_ID
          -- 관리자
          LEFT OUTER JOIN
               (
                    SELECT USR.USER_ID, USR.USER_NAME, USR.USER_NAME_EN, USR.JOB_CODE, USR.JOB_NAME
                         , USR.DEPT_ID, DPT.DEPT_NAME_KO DEPT_NAME, DPT.DEPT_NAME_EN, DPT.DEPT_NAME_KO, DPT.DEPT_NAME_CN
                      FROM SCM_MGR.SCM_MST_SSO_USER_INFO USR
                     INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO DPT ON USR.DEPT_ID = DPT.DEPT_ID
                     WHERE 0 = 0
               ) MUS -- Management USer
            ON 0 = 0
           AND PJM.MGMT_USER_ID = MUS.USER_ID
         WHERE 0 = 0
           -- 작성중/승인대기/변경요청 제외
           AND PJM.DPJT_REG_STATUS NOT IN ('WRITING', 'WAITING', 'REQ_MOD', 'MODIFYING')
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
                    P_CELL_TYPE    = 'ALL'
                 OR PJM.CELL_TYPE IN ( SELECT TOKEN FROM WT_FILTER_CELL_TYPE )
               )
           AND (
                    P_BIZ_TYPE    = 'ALL'
                 OR PJM.BIZ_TYPE IN ( SELECT TOKEN FROM WT_FILTER_BIZ_TYPE )
               )
           AND (
                    P_DPJT_DEVELOP_STATUS    = 'ALL'
                 OR PJM.DPJT_DEVELOP_STATUS IN ( SELECT TOKEN FROM WT_FILTER_DEVELOP_STATUS )
               )
           AND (
                    PJM.REG_COMP_DATE BETWEEN D_REG_COMP_DATE_FR AND D_REG_COMP_DATE_TO
                 OR ( D_REG_COMP_DATE_FR IS NULL AND D_REG_COMP_DATE_TO IS NULL )
               )
         ORDER BY PJM.DPJT_KEY
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
          , 'P_CELL_TYPE'               VALUE P_CELL_TYPE
          , 'P_BIZ_TYPE'                VALUE P_BIZ_TYPE
          , 'P_DPJT_DEVELOP_STATUS'     VALUE P_DPJT_DEVELOP_STATUS
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

END P_SDM5010_GET_TAB2_PJT_MASTER;

-- 프로젝트 Master 관리 저장
-- [E20260819-SDM5010-D1] 설계서 TAB2 저장 명세 실존 SP 부재 — 신규 작성 (2026-08-19)
PROCEDURE P_SDM5010_SAVE_TAB2_PJT_MASTER (
    P_ACTIVE_FLAG               IN VARCHAR2         -- I(Insert) / D(Delete) / M(Modify) — 본 화면은 'M' 단건만 유효
  , P_DPJT_KEY                  IN VARCHAR2
  , P_DPJT_DEVELOP_STATUS       IN VARCHAR2         -- 개발 현황
  , P_DISABLED                  IN VARCHAR2         -- 비활성 체크 (CHECKED / UNCHECKED)
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_SDM5010.P_SDM5010_SAVE_TAB2_PJT_MASTER
 * Description  : 프로젝트 Master 관리 저장 (개발 현황 / 비활성 'M' 단건 UPDATE)
 * Parameter    : PKG_SDM5010.P_SDM5010_SAVE_TAB2_PJT_MASTER(P_ACTIVE_FLAG, P_DPJT_KEY, P_DPJT_DEVELOP_STATUS, P_DISABLED, P_SES_USER_ID, O_RESULT_CURSOR)
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2026.08.19   Claude         [E20260819-SDM5010-D1] 설계서 TAB2 저장 명세 5-IN 신규 작성
 * ---------------------------------------------------------------------------------------------------
 */

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    V_ACTIVE_FLAG               VARCHAR2(10);
    V_DPJT_KEY                  VARCHAR2(50);
    V_DPJT_DEVELOP_STATUS       VARCHAR2(50);
    V_DISABLED                  VARCHAR2(50);
    
    N_MAX_CNT                   PLS_INTEGER := 0;
    
    --V_USER_ID                   VARCHAR2(50);
    V_USER_ID                   VARCHAR2(50) := P_SES_USER_ID;

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

    
    -- ^ 구분자 row 정보를 테이블 형태로 생성 참고 
    --SELECT * FROM SCM_MGR.UF_FX_STRING_SPLIT('01MDP2949A9B11^02MDP2949A9B11^03MDP2949A9B11^04MDP2949A9B11^05MDP2949A9B11', '^')
    
    -- ^ 구분자로 전달받은 Grid 데이터의 Row 수 추출
    N_MAX_CNT := REGEXP_COUNT(P_ACTIVE_FLAG, '\^') + 1;
    
    -- Grid Row count Loop
    FOR i IN 1..N_MAX_CNT LOOP
        V_ACTIVE_FLAG               := TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG,                '[^\^]+', 1, i));                   -- I(Insert) / D(Delete) / M(Modify)
        V_DPJT_KEY                  := TRIM(REGEXP_SUBSTR(P_DPJT_KEY,                   '[^\^]+', 1, i));
        V_DPJT_DEVELOP_STATUS       := TRIM(REGEXP_SUBSTR(P_DPJT_DEVELOP_STATUS,        '[^\^]+', 1, i));
        V_DISABLED                  := TRIM(REGEXP_SUBSTR(P_DISABLED,                   '[^\^]+', 1, i));
        
        -- 본 화면 저장은 'M'(Modify) 단건만 유효 (설계서 TAB2 저장 명세)
        IF NVL(V_ACTIVE_FLAG, '-') <> 'M' THEN
            OPEN O_RESULT_CURSOR FOR
            SELECT '1' AS CODE, 'ERR_RTN: - 지원하지 않는 P_ACTIVE_FLAG 입니다 (M 만 유효): ' || NVL(P_ACTIVE_FLAG, 'NULL') AS MSG, NULL AS EVENT FROM DUAL;
            RETURN;
        END IF;
        
        UPDATE SCM_MGR.SPMS_PROJECT_MST
           SET LAST_UPDATED_BY      = P_SES_USER_ID
             , LAST_UPDATE_DATE     = SYSDATE
             --
             , DPJT_DEVELOP_STATUS  = V_DPJT_DEVELOP_STATUS
             , DPJT_MGMT_STATUS     = CASE WHEN V_DISABLED = 'CHECKED' THEN 'DISABLED' ELSE 'NORMAL' END
         WHERE 0 = 0
           AND DPJT_KEY             = V_DPJT_KEY
        ;
        N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;
    
        END LOOP;

    COMMIT;

    N_EVENT_COUNT := N_EVENT_COUNT + N_DEL_COUNT + N_INSERT_COUNT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_EVENT_COUNT) AS EVENT FROM DUAL;

    --DBMS_OUTPUT.PUT_LINE('FINISH ');

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
            'P_ACTIVE_FLAG'             VALUE SUBSTR(P_ACTIVE_FLAG, 1, 200)
          , 'P_DPJT_KEY'                VALUE SUBSTR(P_DPJT_KEY, 1, 200)
          , 'P_DPJT_DEVELOP_STATUS'     VALUE SUBSTR(P_DPJT_DEVELOP_STATUS, 1, 200)
          , 'P_DISABLED'                VALUE SUBSTR(P_DISABLED, 1, 200)
          , 'P_SES_USER_ID'             VALUE P_SES_USER_ID
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

END P_SDM5010_SAVE_TAB2_PJT_MASTER;

END ;
/
