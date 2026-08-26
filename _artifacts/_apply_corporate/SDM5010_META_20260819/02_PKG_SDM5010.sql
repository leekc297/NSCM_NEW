-- =====================================================================================
-- SDM5010 Project Master — [02] PKG_SDM5010 정정본 (SPEC + BODY 전체 배포)
-- 2026-08-19 · 원문 = Doc/화면설계서_SDM/SDM5010/SQL_PACKAGE/PKG_SDM5010.txt (2026.08.14 KTJ)
-- 주석/라이브 판별 = strip_code_comments.py (hook #138) — 라이브 코드만 대상으로 정정.
-- 치명 결함 정정 (경미 결함 D7~D9·D15~D24 는 무수정 — 정오표 담당 별도):
--   [D1]       P_SDM5010_SAVE_TAB2_PJT_MASTER 신규 작성 (설계서 TAB2 저장 명세 5-IN — SP 부재)
--   [D3]       CANCEL 부모행 복구 UPDATE WHERE DPJT_KEY = P_DPJT_KEY → P_DPJT_KEY_PARENT
--   [D4]       CONFIRM 원본행 전이 UPDATE WHERE DPJT_KEY = P_DPJT_KEY → P_DPJT_KEY_PARENT
--   [D5]       CONFIRM 승인 시 DPJT_KEY 변경 직후 SPMS_PROJECT_USER_MAP.DPJT_KEY 동기 UPDATE 추가
--   [D6]       ( x IS NOT NULL OR x != '' ) 4곳 → x IS NOT NULL (Oracle ''=NULL — OR 절 항진)
--   [D10]      CONFIRM 엄격 SELECT INTO — NO_DATA_FOUND/TOO_MANY_ROWS 핸들러 (결과커서 CODE '1')
--   [D11]      CONFIRM 신규 승인 SEQ 채번 = (SELECT NVL(MAX(DPJT_SEQ),0)+1 ... WHERE DPJT_CODE=...)
--   [DISABLED] 'DIABLED' 오타 리터럴 2곳 → 'DISABLED' (CANCEL 반려행 / CONFIRM 원본행)
--   [REGSTS]   'MODIFIED' → 'CHG_COMPLETE' — lookup SPMS_DPJT_REG_STATUS(VALID Y 10행) 에 'MODIFIED'
--              미등재 + '등록완료(변경 후)'=CHG_COMPLETE 기등재 → lookup 권위 원칙으로 PKG 정합
--              ('MODIFIED' 유지 시 TAB2 GET 의 RGS INNER JOIN 에서 원본행 영구 소실)
-- 마커: [E20260819-SDM5010-D{n}] / -DISABLED / -REGSTS — grep 실측 검증 대상
-- =====================================================================================
CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SDM5010
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

-- 프로젝트 등록 요청
PROCEDURE P_SDM5010_GET_TAB1_PJT_REG_REQ (
    P_SES_DIVISION_ID           IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , P_SES_MENU_ID               IN VARCHAR2
  , P_SES_USER_GR_ID            IN VARCHAR2         -- 권한 그룹
  , O_CURSOR                    OUT SYS_REFCURSOR
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
);

-- 프로젝트 등록요청 반려
PROCEDURE P_SDM5010_BTN_TAB1_CANCEL
(
    P_DIVISION_ID               IN VARCHAR2
  , P_DPJT_KEY                  IN VARCHAR2
  , P_DPJT_KEY_PARENT           IN VARCHAR2
  , P_NOTE                      IN VARCHAR2
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
);

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
);

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
);

-- 프로젝트 Master 관리 저장
-- [E20260819-SDM5010-D1] 설계서 TAB2 저장 명세(P_SDM5010_SAVE_TAB2_PJT_MASTER) SP 부재 — 신규 작성
PROCEDURE P_SDM5010_SAVE_TAB2_PJT_MASTER (
    P_ACTIVE_FLAG               IN VARCHAR2         -- I(Insert) / D(Delete) / M(Modify) — 본 화면은 'M' 단건만 유효
  , P_DPJT_KEY                  IN VARCHAR2
  , P_DPJT_DEVELOP_STATUS       IN VARCHAR2         -- 개발 현황
  , P_DISABLED                  IN VARCHAR2         -- 비활성 체크 (CHECKED / UNCHECKED)
  , P_SES_USER_ID               IN VARCHAR2
  , O_RESULT_CURSOR             OUT SYS_REFCURSOR
);

END PKG_SDM5010;
/

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SDM5010
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
        SELECT PJM.DPJT_KEY, PJM.DPJT_CODE, PJM.DPJT_SEQ
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
           AND PJM.MGMT_USER_ID = P_SES_USER_ID
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
         , DPJT_REG_STATUS      = 'REJECT'      -- 반려
         , DPJT_MGMT_STATUS     = 'DISABLED'    -- 비활성 [E20260819-SDM5010-DISABLED]
         , NOTE                 = P_NOTE
     WHERE 0 = 0
       AND DPJT_KEY             = P_DPJT_KEY
    ;
    N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;

    -- 원 Project Code 상태 복구 : MODIFYING => COMPLETE
    IF ( P_DPJT_KEY_PARENT IS NOT NULL ) THEN  -- [E20260819-SDM5010-D6] Oracle ''=NULL — OR !='' 항진 제거
        
        UPDATE SCM_MGR.SPMS_PROJECT_MST
           SET LAST_UPDATED_BY      = P_SES_USER_ID
             , LAST_UPDATE_DATE     = SYSDATE
             --
             , DPJT_REG_STATUS      = 'COMPLETE'    -- 등록완료
             , DPJT_MGMT_STATUS     = 'NORMAL'      -- 정상
         WHERE 0 = 0
           AND DPJT_KEY = P_DPJT_KEY_PARENT  -- [E20260819-SDM5010-D3] 부모행 복구 — P_DPJT_KEY 오지정 정정
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
    -- [E20260819-SDM5010-D10] 엄격 SELECT INTO — 대상행 부재/중복 시 결과커서 CODE '1' 로 정상 반환
    --   (본 PKG 에 e_validation 관례 부재 — VALIDATION_FAIL 라벨은 도달 불가 사문(死文))
    BEGIN
        SELECT PJM.DPJT_KEY, PJM.DPJT_CODE, PJM.DPJT_SEQ
          INTO V_DPJT_KEY, V_DPJT_CODE, N_DPJT_SEQ
          FROM SCM_MGR.SPMS_PROJECT_MST PJM
         WHERE PJM.DPJT_KEY = P_DPJT_KEY
        ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            OPEN O_RESULT_CURSOR FOR
            SELECT '1' AS CODE, 'ERR_RTN: - 승인 대상 프로젝트가 존재하지 않습니다 (DPJT_KEY=' || P_DPJT_KEY || ')' AS MSG, NULL AS EVENT FROM DUAL;
            RETURN;
        WHEN TOO_MANY_ROWS THEN
            OPEN O_RESULT_CURSOR FOR
            SELECT '1' AS CODE, 'ERR_RTN: - 승인 대상 프로젝트 키가 중복되었습니다 (DPJT_KEY=' || P_DPJT_KEY || ')' AS MSG, NULL AS EVENT FROM DUAL;
            RETURN;
    END;
    -- 수정 Case 인 경우 Project Code 유지
    IF ( P_DPJT_KEY_PARENT IS NOT NULL ) THEN  -- [E20260819-SDM5010-D6] Oracle ''=NULL — OR !='' 항진 제거
        V_DPJT_KEY  := P_DPJT_KEY;
    -- 신규 케이스
    ELSE
        V_DPJT_CODE := P_DPJT_CODE;
        -- [E20260819-SDM5010-D11] 신규 승인 SEQ 채번 = 동일 DPJT_CODE 내 MAX+1 (요청행 자체 SEQ 승계 결함 정정)
        SELECT NVL(MAX(PJM.DPJT_SEQ), 0) + 1
          INTO N_DPJT_SEQ
          FROM SCM_MGR.SPMS_PROJECT_MST PJM
         WHERE PJM.DPJT_CODE = V_DPJT_CODE
        ;
        V_DPJT_KEY  := V_DPJT_CODE || '_' || TO_CHAR(N_DPJT_SEQ, '000000');
    END IF;
    
    -- 반려 Process 처리
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
         , DPJT_MGMT_STATUS     = 'NORMAL'      -- 비활성
         , CNFM_USER_ID         = P_SES_USER_ID
         , REG_COMP_DATE        = TRUNC(SYSDATE)
     WHERE 0 = 0
       AND DPJT_KEY             = P_DPJT_KEY
       -- 6자리 프로젝트 코드 반드시 존재
       AND V_DPJT_CODE IS NOT NULL  -- [E20260819-SDM5010-D6] Oracle ''=NULL — OR !='' 항진 제거
       AND LENGTH(V_DPJT_CODE ) = 6
    ;
    N_CNT := SQL%ROWCOUNT;
    N_EVENT_COUNT := N_EVENT_COUNT + N_CNT;

    -- [E20260819-SDM5010-D5] 승인 시 DPJT_KEY 변경 반영 — 권한 매핑 원장(SPMS_PROJECT_USER_MAP) 동기 UPDATE
    --   (본 UPDATE 미수행 시 기존 권한 매핑이 구 키에 고아로 잔존 → 권한 전멸)
    IF N_CNT > 0 AND V_DPJT_KEY <> P_DPJT_KEY THEN
        UPDATE SCM_MGR.SPMS_PROJECT_USER_MAP
           SET DPJT_KEY         = V_DPJT_KEY
             , LAST_UPDATED_BY  = P_SES_USER_ID
             , LAST_UPDATE_DATE = SYSDATE
         WHERE 0 = 0
           AND DPJT_KEY = P_DPJT_KEY
        ;
        N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;
    END IF;

    -- 원 Project Code 상태 변경 : MODIFYING => MODIFIED
    IF ( P_DPJT_KEY_PARENT IS NOT NULL ) THEN  -- [E20260819-SDM5010-D6] Oracle ''=NULL — OR !='' 항진 제거
        
        UPDATE SCM_MGR.SPMS_PROJECT_MST
           SET LAST_UPDATED_BY      = P_SES_USER_ID
             , LAST_UPDATE_DATE     = SYSDATE
             --
             , DPJT_REG_STATUS      = 'CHG_COMPLETE' -- 등록완료(변경 후) [E20260819-SDM5010-REGSTS] lookup 권위 정합('MODIFIED' 미등재)
             , DPJT_MGMT_STATUS     = 'DISABLED'    -- 비활성 [E20260819-SDM5010-DISABLED]
         WHERE 0 = 0
           AND DPJT_KEY = P_DPJT_KEY_PARENT  -- [E20260819-SDM5010-D4] 원본(부모)행 전이 — P_DPJT_KEY 오지정 정정
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
        SELECT PJM.DPJT_KEY, PJM.DPJT_CODE, PJM.DPJT_SEQ
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
             , PJM.CNFM_USER_ID, CUS.USER_NAME AS CNFM_USER_NAME
             , CUS.DEPT_ID, CUS.DEPT_NAME
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
                       --AND USM.SPMS_DPJT_AUTH_STATUS != 'REQUEST'
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
         WHERE 0 = 0
           -- 작성중/승인대기/변경요청 제외
           AND PJM.DPJT_REG_STATUS NOT IN ('WRITING', 'WAITING', 'REQ_MOD')
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

    N_EVENT_COUNT               PLS_INTEGER := 0;
    n_log_count                 PLS_INTEGER := 0;

    V_PROC_INPUT                VARCHAR2(4000 CHAR);
    V_BACKTRACE                 VARCHAR2(4000 CHAR);
    V_SQL_CODE                  VARCHAR2(100  CHAR);
    V_SQL_ERRMSG                VARCHAR2(1000 CHAR);
    V_PROGRAM_NAME              VARCHAR2(150 CHAR) := $$PLSQL_UNIT;

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    -- 본 화면 저장은 'M'(Modify) 단건만 유효 (설계서 TAB2 저장 명세)
    IF NVL(P_ACTIVE_FLAG, '-') <> 'M' THEN
        OPEN O_RESULT_CURSOR FOR
        SELECT '1' AS CODE, 'ERR_RTN: - 지원하지 않는 P_ACTIVE_FLAG 입니다 (M 만 유효): ' || NVL(P_ACTIVE_FLAG, 'NULL') AS MSG, NULL AS EVENT FROM DUAL;
        RETURN;
    END IF;

    UPDATE SCM_MGR.SPMS_PROJECT_MST
       SET LAST_UPDATED_BY      = P_SES_USER_ID
         , LAST_UPDATE_DATE     = SYSDATE
         --
         , DPJT_DEVELOP_STATUS  = P_DPJT_DEVELOP_STATUS
         , DPJT_MGMT_STATUS     = CASE WHEN P_DISABLED = 'CHECKED' THEN 'DISABLED' ELSE 'NORMAL' END
     WHERE 0 = 0
       AND DPJT_KEY             = P_DPJT_KEY
    ;
    N_EVENT_COUNT := N_EVENT_COUNT + SQL%ROWCOUNT;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_EVENT_COUNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
              'P_ACTIVE_FLAG'           VALUE P_ACTIVE_FLAG
            , 'P_DPJT_KEY'              VALUE P_DPJT_KEY
            , 'P_DPJT_DEVELOP_STATUS'   VALUE P_DPJT_DEVELOP_STATUS
            , 'P_DISABLED'              VALUE P_DISABLED
            , 'P_SES_USER_ID'           VALUE P_SES_USER_ID
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
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_SDM5010_SAVE_TAB2_PJT_MASTER;

END PKG_SDM5010;
/
