PROCEDURE PR_SCP_RPT_GLOBAL_PSI_MD_WW
( P_DIVISION_ID          IN VARCHAR2 DEFAULT '81'
, P_PLAN_START_YYYYMMDD  IN VARCHAR2 DEFAULT NULL
, P_PLAN_TYPE            IN VARCHAR2 DEFAULT 'FN'   /* E20260708-000926 추가. */
)
/*
 * Program ID   : PR_SCP_RPT_GLOBAL_PSI_MD_WW
 * Description  : 자동차 Weekly(partial) Global PSI 집계 프로시저
 *
 * Program History
 *===================================================================================================
 *   Date      In Charge	Description
 *===================================================================================================
 * 2023.10.13	hrkim		Initial Release PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2
 * 2023.12.12	hrkim		FP Aging Stock Form. Progress 데이터 저장 활용
 * 2023.12.14	hrkim		P5200 AMDAU% 모델 생산 실적 제외
 * 2023.12.18	hrkim		P5200 AMDAU% 모델 Cell로 환산 적재 (operation_group = 'A'로 적용, Cell로 간주함)
 * 2024.01.16	hrkim		AS measure 분리 적용 및 RTF measure 코드 변경 (ALLOCATION -> RTF)
 * 2024.01.17	hrkim		Cell/Pack 재고 로직 변경 (Pack plant Cell재고 제외)
 *							-- 보류 재고 가용일과 상관 없이 BOH에 모두 포함
 *							-- Cell Product(CP) 재고 -> Cell Assy(CA) 재고에 변환 합산
 * 2024.03.11	hrkim		attribute10 -> cell_group여부 정보 추가
 *								- Y : cell_group 컬럼의 값이 cell_group
 *								- N : cell_group 컬럼의 값이 cell_group이 아닌 rep_cell_item_id (Model Code Master정보에 Cell Group정보가 없는 경우)
 * 2024.03.27	hrkim		E20240329-001832 GLOBAL PSI NEW 수식 수정 : 셀공장 Cell Inventory 마이너스 P(팩공장 Cell inventory) 반영 로직 변경
 * 2024.06.09   vadabi3     NERP - 특정 Company 별도 처리 개선
 * 2024.09.30   cys     	고도화 (개선 및 재고 통제 프로세스 적용)	- Global PSI New 개선_재고통제프로세스관련.xlsx 개발 목록 참조(PI 김도형 선임)
 * 2025.05.28   kimcd       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *                          E20250522-001206 GLOBAL PSI NEW - AS FCST/RTF 누락
 * 2025.08.01   hrkim	    PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경
 * 2025.09.01   hrkim		PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
 *							  - 기말재고(SCP_ANL_MONTH_END_STOCK_R) SCP Exclude Class 품목을 Cell Assy로 변환 참조	   (수율 적용하지 않음)
 *							  - FP Aging Stock(SCM_DNM_STOCK_AGING_SN) SCP Exclude Class 품목을 Cell Assy로 변환 참조  (수율 적용하지 않음)
 * 2025.11.17	YMH			E20251028-000389 기초재고정보 누락구조 수정 (LOCATION정보 미MAPPING 재고위한 특별 MEASURE 구성)
 * 2025.11.17	YMH			E20251029-001009 오류로 보이는 기초재고 누락케이스 (NB01 / Z799) 관련 수정
 * 2025.12.04   hrkim		[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV FP 활성화 재고를 ESS MI 법인 가상사이트 재고로 치환하여 정보 형성
 *								- SCM_DNM_STOCK_AGING_SN를 SCM_DNM_STOCK_AGING_SN_V뷰로 대체 참조
 * 2025.12.16	YMH			E20251023-001360 G-PSI AS 창고실적로직 개선
 * 2026.04.08	YMH			E20260407-000405 GLOBAL PSI NEW - P5200공정 모델 추가 (하드코딩->룩업관리)
 * 2026.05.11	YMH			E20260422-001155 GLOBAL PSI NEW - PLAN (MKT FCST & RTF) 기준 TABLE 변경 / 프로시져 특정시간에 작동 문의
 * 2026.08.12	YMH			E20260708-000926 Global PSI New 수행 Plan type 추가 요청의 건
 * 2026.10.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.27    ZIONEX      [PJ202650304] 티라엔진 제거 - SCP_PLN_SALES_ONHAND -> 통합 Dataset 기반 뷰(SCP_PLN_SALES_ONHAND_V) 교체
 ----------------------------------------------------------------------------------------------------
 */
IS

    /* SCP 계힉 참조를 위한 변수 */
    V_DIVISION_ID              VARCHAR2(30 CHAR)   := SUBSTR(NVL(P_DIVISION_ID, '81'), 1, 30);
    V_PLAN_START_YYYYMMDD      VARCHAR2(8 CHAR)    := NULL;
    V_PLAN_START_DATE          DATE                := NULL;
    V_PLAN_START_YYYYPW        VARCHAR2(8 CHAR)    := NULL;
    /* E20260708-000926 기존로직 주석처리 */
    /* DECLARE @V_PLAN_TYPE				NVARCHAR(100)	= 'FN'; */
    /* E20260708-000926 신규로직 */
    V_PLAN_TYPE                VARCHAR2(100 CHAR)  := SUBSTR(NVL(P_PLAN_TYPE, 'FN'), 1, 50);
    V_PLAN_SEQ                 NUMBER(19)          := 1;
    V_HORIZON_END_YYYYMMDD     VARCHAR2(8 CHAR)    := NULL;
    V_MASTER_ID                VARCHAR2(100 CHAR)  := NULL;
    V_ENG_PLAN_ID              VARCHAR2(100 CHAR)  := NULL;
    V_HORIZON_END_YYYYPW       VARCHAR2(8 CHAR)    := NULL;

    /* DM 참조를 위한 변수 */
    V_DM_CUTOFF_YYYYMMDD       VARCHAR2(8 CHAR)    := NULL;
    V_DM_VERSION_NO            VARCHAR2(50 CHAR)   := NULL;

    /* 실적 구간 참조를 위한 변수 */
    V_RESULT_FROM_YYYYMMDD     VARCHAR2(8 CHAR)    := NULL;   /* 과거 실적구간 참조 시작일 (plan date - 전년도 첫주 시작일) */
    V_RESULT_FROM_DATE         DATE                := NULL;   /* 과거 실적구간 참조 시작일 (plan date - 전년도 첫주 시작일) */
    V_RESULT_LAST_YYYYMM       VARCHAR2(6 CHAR)    := NULL;   /* 계획 시작일 기준 전월 */
    V_RESULT_LAST_YYYYPW       VARCHAR2(8 CHAR)    := NULL;   /* 계획 시작일 기준 전주 */

    /* Ending Inventory 참조를 위한 변수 */
    V_INV_FROM_YYYYMM          VARCHAR2(6 CHAR)    := NULL;   /* 실적 참조 시작일 기준 전월 */
    V_INV_TO_YYYYMM            VARCHAR2(6 CHAR)    := NULL;   /* plan date 기준 전월 */

    /* 실행시간 확인용 */
    V_START_TIME               DATE                := SYSDATE;
    V_EXEC_TIME                VARCHAR2(10 CHAR)   := NULL;   /* '[00:00]'; */
    N_EXEC_SECS                NUMBER;

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME             VARCHAR2(150 CHAR)  := 'PR_SCP_RPT_GLOBAL_PSI_MD_WW';  /* Proc별 이름 설정 */
    V_LOG_TYPE                 VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT                NUMBER              := 0;
    V_LOG_MESSAGE              VARCHAR2(1000 CHAR);
    V_DESCRIPTION              VARCHAR2(500 CHAR);
    D_EVENT_DATE               DATE;
    V_BATCH_USER               VARCHAR2(150 CHAR)  := 'scm_batch';

    /* NERP 매핑코드	--NERP 적용여부에 따라 변경 */
    V_COMPANY_SALES            VARCHAR2(8 CHAR);
    V_ESOC                     VARCHAR2(8 CHAR);
    V_PLANT_G8                 VARCHAR2(8 CHAR)    := 'G82';  /* 1차 Conv 대상 아님 */

    /* 커서 CUR_FORM 변수 (원문 4088행 DECLARE @CUR_FORM$CUR_YYYYPW, @CUR_FORM$PREV_YYYYPW) */
    V_CUR_YYYYPW               VARCHAR2(8 CHAR);
    V_PREV_YYYYPW              VARCHAR2(8 CHAR);

    /* 원문 12155행 DECLARE @V_INV_SEQ INT = 0; */
    V_INV_SEQ                  PLS_INTEGER         := 0;

BEGIN

    /* procedure body -- start */
    /* SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  SET NOCOUNT ON; (Oracle 기본 READ COMMITTED) */

    V_COMPANY_SALES := SUBSTR(FN_GET_LOOKUP_VALUE('PR_SCP_RPT_GLOBAL_PSI_MD_MM', 'COMPANY_SALES'), 1, 8);
    V_ESOC          := SUBSTR(FN_GET_LOOKUP_VALUE('PR_SCP_RPT_GLOBAL_PSI_MD_MM', 'ESOC'), 1, 8);

    /* ------------------------------------------------------------------------------------------------------------------ */
    /* [PJ20257329] Cell 완성 공정 하드 코딩 변경 (임시테이블 변수) */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' SCP Cell 완성 공정 정보 - Cell Packaging/Assembly');
    /* ------------------------------------------------------------------------------------------------------------------ */
    DELETE FROM GT_GPWW_SCP_CELL_FINAL_OPERATION;

    INSERT
      INTO GT_GPWW_SCP_CELL_FINAL_OPERATION
         ( OPERATION_ID )
    SELECT DISTINCT
           SEGMENT1 AS OPERATION_ID
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE 1=1
       AND LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
       AND SEGMENT3    = 'A'   /* 공정그룹(Cell) */
       AND ATTRIBUTE1  = 'Y';  /* Final Operation */
    /* ------------------------------------------------------------------------------------------------------------------ */

    /* BEGIN TRY */
    BEGIN

        /* --------------------------------------------------------------------------------------------------- */
        /* SCP PLAN 버전 정보 (PRODUCTION) */
        /* --------------------------------------------------------------------------------------------------- */
        BEGIN
            SELECT IA.PLAN_SEQ
                 , IA.PLAN_NAME
                 , IA.YYYYPW
                 , IA.PLAN_START_DATE
                 , IA.HORIZON_END_YYYYMMDD
                 , IA.MASTER_ID
                 , IA.ENG_PLAN_ID
              INTO V_PLAN_SEQ
                 , V_PLAN_START_YYYYMMDD
                 , V_PLAN_START_YYYYPW
                 , V_PLAN_START_DATE
                 , V_HORIZON_END_YYYYMMDD
                 , V_MASTER_ID
                 , V_ENG_PLAN_ID
              FROM (SELECT B.PLAN_SEQ
                         , SUBSTR(A.PLAN_NAME, 1, 8)                                         AS PLAN_NAME
                         , C.YYYYPW
                         , TO_DATE(A.PLAN_NAME, 'YYYYMMDD')                                   AS PLAN_START_DATE
                         , SUBSTR(A.HORIZON_END_DATE, 1, 8)                                  AS HORIZON_END_YYYYMMDD
                         , A.DIVISION_ID || '::' || A.PLAN_CYCLE                             AS MASTER_ID
                         , A.PLAN_ID || '::' || B.PLAN_TYPE || '::' || TO_CHAR(B.PLAN_SEQ)   AS ENG_PLAN_ID
                      FROM SCM_MST_PLAN        A
                         , SCM_MST_PLAN_DETAIL B
                         , SCM_MST_BUCKET      C
                     WHERE B.DIVISION_ID  = A.DIVISION_ID
                       AND B.PLAN_ID      = A.PLAN_ID
                       AND C.YYYYMMDD     = A.PLAN_NAME
                       AND B.PLAN_STATUS  = '1'   /* 정상 완료 */
                       /* AND D.CONFIRM_FLAG = 'Y'  -- 최종 Confirm -- E20260708-000926 컨펌 제거 주석처리. */
                       AND A.PLAN_CYCLE   = 'WEEKLY'
                       AND B.PLAN_TYPE    = V_PLAN_TYPE   /* FN */
                       AND A.DIVISION_ID  = V_DIVISION_ID
                       AND A.PLAN_NAME    = NVL(SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8), A.PLAN_NAME)   /* 원문 CASE WHEN ISNULL(@P_PLAN_START_YYYYMMDD,'') = '' THEN P.PLAN_NAME ELSE @P_PLAN_START_YYYYMMDD END */
                     ORDER BY A.PLAN_NAME DESC
                            , B.PLAN_SEQ) IA
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;   /* MSSQL SELECT TOP 1 @v = … : 결과가 없으면 변수 기존 값 유지 */
        END;

        /* 시작 LOG  (START) */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '##### Start of procedure #####';
        V_DESCRIPTION := '[' || V_DIVISION_ID || '::' || V_PLAN_START_YYYYMMDD || ']';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);
        V_LOG_MESSAGE := NULL;

        /* 실적 구간 참조를 위한 변수값 */
        V_RESULT_FROM_YYYYMMDD := TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, -12), 'YYYY') || '0101';                 /* 과거 실적구간 참조 시작일 (전년도 1/1일)																			-- 과거 실적구간 참조 시작일 (plan date - 52주, 해당월 1일) */
        V_RESULT_FROM_DATE     := TO_DATE(V_RESULT_FROM_YYYYMMDD, 'YYYYMMDD');                                    /* 과거 실적구간 참조 시작일 (전년도 1/1일) */
        V_RESULT_LAST_YYYYMM   := TO_CHAR(ADD_MONTHS(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -1), 'YYYYMM');  /* 계획 시작일 기준 전월 */

        /* Ending Inventory 참조를 위한 변수 */
        V_INV_FROM_YYYYMM      := TO_CHAR(ADD_MONTHS(V_RESULT_FROM_DATE, -1), 'YYYYMM');   /* 실적 참조 시작일 기준 전월 */
        V_INV_TO_YYYYMM        := TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, -1), 'YYYYMM');    /* plan date 기준 전월 */

        /* --------------------------------- */
        /* DM Cutoff YYYYMMDD */
        /* --------------------------------- */
        V_DM_CUTOFF_YYYYMMDD := TO_CHAR(FN_NEXT_DAY(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD'), 'TUE'), 'YYYYMMDD');

        /* --------------------------------------------------------------------------------------------------- */
        /* 참조대상 DM 버전 정보 (FCST 및 RTF 실적) */
        /* --------------------------------------------------------------------------------------------------- */
        BEGIN
            SELECT IA.VERSION_NO
              INTO V_DM_VERSION_NO
              FROM (SELECT VERSION_NO
                      FROM DM_MST_VERSION
                     WHERE 1=1
                       AND VERSION_TYPE = 'MF_W'
                       AND DIVISION_ID  = V_DIVISION_ID
                       AND YYYYMMDD     = V_DM_CUTOFF_YYYYMMDD
                     ORDER BY VERSION_NO DESC) IA
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;   /* 결과가 없으면 변수 기존 값 유지 */
        END;

        DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
        /* PRINT '@P_DIVISION_ID			= ' + '81'; */
        DBMS_OUTPUT.PUT_LINE('@V_DIVISION_ID			= ' || V_DIVISION_ID);
        /* PRINT '@P_PLAN_START_YYYYMMDD	= ' + ISNULL('20240624',''); */
        DBMS_OUTPUT.PUT_LINE('@V_PLAN_START_DATE		= ' || TO_CHAR(V_PLAN_START_DATE, 'YYYYMMDD'));
        DBMS_OUTPUT.PUT_LINE('@V_PLAN_START_YYYYMMDD	= ' || V_PLAN_START_YYYYMMDD);
        DBMS_OUTPUT.PUT_LINE('@V_PLAN_START_YYYYPW		= ' || V_PLAN_START_YYYYPW);
        DBMS_OUTPUT.PUT_LINE('@V_HORIZON_END_YYYYMMDD	= ' || V_HORIZON_END_YYYYMMDD);
        DBMS_OUTPUT.PUT_LINE('@V_PLAN_SEQ				= ' || TO_CHAR(V_PLAN_SEQ));
        DBMS_OUTPUT.PUT_LINE('@V_MASTER_ID			    = ' || V_MASTER_ID);
        DBMS_OUTPUT.PUT_LINE('@V_ENG_PLAN_ID			= ' || V_ENG_PLAN_ID);
        /* for DM */
        DBMS_OUTPUT.PUT_LINE('@V_DM_CUTOFF_YYYYMMDD	= ' || V_DM_CUTOFF_YYYYMMDD);
        DBMS_OUTPUT.PUT_LINE('@V_DM_VERSION_NO			= ' || V_DM_VERSION_NO);
        /* for Result */
        DBMS_OUTPUT.PUT_LINE('@V_RESULT_FROM_YYYYMMDD	= ' || V_RESULT_FROM_YYYYMMDD);
        DBMS_OUTPUT.PUT_LINE('@V_RESULT_FROM_DATE		= ' || TO_CHAR(V_RESULT_FROM_DATE, 'YYYYMMDD'));
        /* Ending Inventory 참조를 위한 변수 */
        DBMS_OUTPUT.PUT_LINE('@V_INV_FROM_YYYYMM		= ' || V_INV_FROM_YYYYMM);
        DBMS_OUTPUT.PUT_LINE('@V_INV_TO_YYYYMM			= ' || V_INV_TO_YYYYMM);
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------');

        /* --------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 기간 정보 : 데이터생성 범위 날짜 목록');
        /* --------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_DATE_INFO;

        INSERT
          INTO GT_GPWW_DATE_INFO
             ( YYYYMMDD
             , YYYYWW
             , WK_FROM_YMD
             , WK_TO_YMD
             , WK_DAYS
             , YYYYPW
             , PW_FROM_YMD
             , PW_TO_YMD
             , PW_DAYS
             , YYYYMM
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , YYYYMM_PRVS )
        SELECT YYYYMMDD
             , YYYYWW
             , MIN(YYYYMMDD)   OVER (PARTITION BY YYYYWW)                         AS WK_FROM_YMD
             , MAX(YYYYMMDD)   OVER (PARTITION BY YYYYWW)                         AS WK_TO_YMD
             , COUNT(YYYYMMDD) OVER (PARTITION BY YYYYWW)                         AS WK_DAYS
             , YYYYPW
             , MIN(YYYYMMDD)   OVER (PARTITION BY YYYYPW)                         AS PW_FROM_YMD
             , MAX(YYYYMMDD)   OVER (PARTITION BY YYYYPW)                         AS PW_TO_YMD
             , COUNT(YYYYMMDD) OVER (PARTITION BY YYYYPW)                         AS PW_DAYS
             , YYYYMM                                                                                    /* partial week의 해당월 */
             , YYYYMM || '01'                                                     AS YYYYMM_FIRST_YMD    /* 해당월 01일 */
             , MAX(YYYYMMDD)   OVER (PARTITION BY YYYYMM)                         AS YYYYMM_LAST_YMD     /* 해당월 말일 */
             , TO_CHAR(ADD_MONTHS(TO_DATE(YYYYMMDD, 'YYYYMMDD'), -1), 'YYYYMM')   AS YYYYMM_PRVS         /* 전월 */
          FROM SCM_MST_BUCKET
         WHERE 1=1
           AND YYYYMMDD BETWEEN V_RESULT_FROM_YYYYMMDD   /* 실적 참조 시작일 */
                            AND V_HORIZON_END_YYYYMMDD;  /* 계획 참조 종료일 */

        BEGIN
            SELECT A.YYYYPW   /* 계획 주차 전주 */
              INTO V_RESULT_LAST_YYYYPW
              FROM GT_GPWW_DATE_INFO A
                 , (SELECT TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD') AS PREV_PLAN_DATE
                      FROM DUAL) IA
             WHERE 1=1
               AND A.PW_FROM_YMD <= IA.PREV_PLAN_DATE
               AND A.PW_TO_YMD   >= IA.PREV_PLAN_DATE
               AND ROWNUM = 1;   /* 원문은 해당 주의 일자 행마다 같은 YYYYPW 를 대입 */
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;

        DBMS_OUTPUT.PUT_LINE('@V_RESULT_LAST_YYYYPW		= ' || V_RESULT_LAST_YYYYPW);
        /* --------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 기간 정보 : 주별(partial) 일수 정보');
        /* --------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_PW_LIST;

        INSERT
          INTO GT_GPWW_PW_LIST
             ( YYYYPW
             , PW_FROM_YMD
             , PW_TO_YMD
             , PW_TO_YMD_NEXT_DAY
             , PW_DAYS
             , YYYYMM
             , YYYYMM_PRVS
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , YYYYPW_SEQ )
          WITH PW_LIST AS (
                SELECT DISTINCT
                       YYYYPW
                     , PW_FROM_YMD
                     , PW_TO_YMD
                     , TO_DATE(PW_TO_YMD, 'YYYYMMDD') + 1   AS PW_TO_YMD_NEXT_DAY  /* FP Aging Stock cutoff date (월말일 기준 재고 참조를 하기 위함) */
                     , PW_DAYS
                       /* for weekly 재고 */
                     , YYYYMM
                     , YYYYMM_PRVS
                     , YYYYMM_FIRST_YMD
                     , YYYYMM_LAST_YMD
                  FROM GT_GPWW_DATE_INFO
          )
        SELECT A.YYYYPW
             , A.PW_FROM_YMD
             , A.PW_TO_YMD
             , A.PW_TO_YMD_NEXT_DAY
             , A.PW_DAYS
             , A.YYYYMM
             , A.YYYYMM_PRVS
             , A.YYYYMM_FIRST_YMD
             , A.YYYYMM_LAST_YMD
             , ROW_NUMBER() OVER (ORDER BY A.YYYYPW NULLS FIRST) AS YYYYPW_SEQ
          FROM PW_LIST A;

        /* --------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### Cell Produc/Cell Assy 매핑 정보 추출');
        /* --------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_CELL_PROD_ASSY_MAP;

        INSERT
          INTO GT_GPWW_CELL_PROD_ASSY_MAP
             ( PLANT_ID
             , ITEM_ID_PROD
             , ITEM_ID_ASSY
             , ASSY_PRIORITY_1ST
             , ASSY_PRIORITY_2ND
             , CP_PRIORITY_1ST
             , CP_PRIORITY_2ND )
        SELECT PLANT_ID
             , ITEM_ID_PROD
             , ITEM_ID_ASSY
             , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID
                                             , ITEM_ID_PROD
                                             , PLANT_ID
                                      ORDER BY VALID_YN DESC
                                             , UPPER(TRANSLATE(ITEM_ID_ASSY, '_-', '/'))   /* MSSQL Latin1_General_CI_AS 비교 재현(대소문자·하이픈 무시, 밑줄은 글자·숫자 앞) */
                                             , ITEM_ID_ASSY)   AS ASSY_PRIORITY_1ST  /* cp 기준 assy 참조 */
             , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID
                                             , ITEM_ID_PROD
                                      ORDER BY VALID_YN DESC
                                             , UPPER(TRANSLATE(ITEM_ID_ASSY, '_-', '/'))   /* MSSQL Latin1_General_CI_AS 비교 재현(대소문자·하이픈 무시, 밑줄은 글자·숫자 앞) */
                                             , ITEM_ID_ASSY)   AS ASSY_PRIORITY_2ND  /* cp 기준 assy 참조 */
             , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID
                                             , ITEM_ID_ASSY
                                             , PLANT_ID
                                      ORDER BY VALID_YN DESC
                                             , UPPER(TRANSLATE(ITEM_ID_PROD, '_-', '/'))
                                             , ITEM_ID_PROD)   AS CP_PRIORITY_1ST    /* assy 기준 cp 참조 */
             , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID
                                             , ITEM_ID_ASSY
                                      ORDER BY VALID_YN DESC
                                             , UPPER(TRANSLATE(ITEM_ID_PROD, '_-', '/'))
                                             , ITEM_ID_PROD)   AS CP_PRIORITY_2ND    /* assy 기준 cp 참조 */
          FROM SCP_MST_CELL_PROD_ASSY_MAP
         WHERE 1=1
           AND VALID_YN    = 'Y'
           AND DIVISION_ID = V_DIVISION_ID;

        /* ----------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 해당 사업부 #SCM_MST_SITE 추출 ');
        /* ----------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SCM_MST_SITE;

        INSERT
          INTO GT_GPWW_SCM_MST_SITE
             ( SCM_SITE_ID
             , PLANT_ID
             , OPERATION_GROUP
             , SITE_TYPE
             , OSP_YN
             , VALID_YN )
        SELECT SCM_SITE_ID
             , PLANT_ID
             , OPERATION_GROUP
             , SITE_TYPE
             , OSP_YN
             , VALID_YN
          FROM SCM_MST_SITE
         WHERE 1=1
           AND DIVISION_ID = V_DIVISION_ID
         UNION ALL
        SELECT 'ESST_CA_WND'  AS SCM_SITE_ID
             , NULL           AS PLANT_ID
             , 'P'            AS OPERATION_GROUP
             , 'PLANT'        AS SITE_TYPE
             , 'N'            AS OSP_YN
             , 'Y'            AS VALID_YN
          FROM DUAL
         WHERE 1 = (CASE WHEN V_DIVISION_ID = '81_ST' THEN 1 ELSE 0 END);

        /* ----------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 해당 사업부 #SCP_MST_FINAL_ITEM 추출 ');
        /* ----------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SCP_MST_FINAL_ITEM;

        INSERT
          INTO GT_GPWW_SCP_MST_FINAL_ITEM
             ( ITEM_ID
             , NICK_NAME
             , OPERATION_GROUP
             , GROUP_CODE1
             , GROUP_CODE6
             , GROUP_CODE7
             , FINISHED_PRODUCT
             , CELL_TYPE
             , FLOW_ID
             , CELL_MODEL_ID )
        SELECT ITEM_ID
             , NICK_NAME
             , OPERATION_GROUP
             , NVL(GROUP_CODE1, 'ETC')   AS GROUP_CODE1   /* cell group	---@@@ */
             , NVL(GROUP_CODE6, '-')     AS GROUP_CODE6   /* Product Level1 ---@@@ */
             , NVL(GROUP_CODE7, '-')     AS GROUP_CODE7   /* - Product Level2 ---@@@ */
             , FINISHED_PRODUCT
             , ATTRIBUTE8                AS CELL_TYPE     /* CP/CA Cell_type */
             , FLOW_ID
             , ATTRIBUTE1                AS CELL_MODEL_ID
          FROM SCP_MST_FINAL_ITEM
         WHERE 1=1
           AND OPERATION_GROUP IN ('A', 'P')   /* Cell/Pack 만 */
           AND DIVISION_ID     = V_DIVISION_ID;


        /* ----------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### Formation 수율 및 LT 정보');
        /* ----------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SCP_MST_FORMATION;
/*
		SELECT    FR.PLANT_SITE_ID
				, FR.ITEM_ID
				, FR.LT_FORMATION
				, FR.ATTRIBUTE1
				, CEILING(ISNULL(FR.LT_FORMATION + CONVERT(INT, ISNULL(FR.ATTRIBUTE1, '0')),0) /7.0) * 7 	AS LT_DAY	-- LT_week으로 환산후 다시 일수로 변환 적용  (시뮬레이터와 동일 일수(주) 반영)
				, CEILING(ISNULL(FR.LT_FORMATION + CONVERT(INT, ISNULL(FR.ATTRIBUTE1, '0')),0) /7.0)		AS LT_WEEK
				, ISNULL(FR.FORMATION_TOTAL_YIELD, 0)	AS FORMATION_TOTAL_YIELD
				, ISNULL(FR.SSP_MODIFY_YIELD, 0)		AS SSP_MODIFY_YIELD
				, ISNULL(FR.CHAR_YIELD, 0)				AS CHAR_YIELD
		  INTO #SCP_MST_FORMATION
		  FROM SCP_MST_FORMATION FR WITH(NOLOCK)
		 WHERE 1=1
		   AND DIVISION_ID	= @V_DIVISION_ID
		;
*/
        INSERT
          INTO GT_GPWW_SCP_MST_FORMATION
             ( PLANT_SITE_ID
             , ITEM_ID
             , YYYYMM
             , YYYYPW
             , LT_FORMATION
             , ATTRIBUTE1
             , LT_DAY
             , LT_WEEK
             , FORMATION_TOTAL_YIELD
             , SSP_MODIFY_YIELD
             , CHAR_YIELD )
        SELECT IA.PLANT_SITE_ID
             , IA.ITEM_ID
             , IA.YYYYMM
             , IA.YYYYPW
             , E.LT_FORMATION
             , E.ATTRIBUTE1
             , CEIL(NVL(E.LT_FORMATION + TO_NUMBER(NVL(E.ATTRIBUTE1, '0')), 0) / 7.0) * 7   AS LT_DAY                  /* LT_WEEK으로 환산후 다시 일수로 변환 적용 */
             , CEIL(NVL(E.LT_FORMATION + TO_NUMBER(NVL(E.ATTRIBUTE1, '0')), 0) / 7.0)       AS LT_WEEK
             , NVL(IA.YIELD, 0)                                                             AS FORMATION_TOTAL_YIELD   /* ISNULL(FR.FORMATION_TOTAL_YIELD, 0)	AS FORMATION_TOTAL_YIELD */
             , NVL(IA.YIELD, 0)                                                             AS SSP_MODIFY_YIELD        /* ISNULL(FR.SSP_MODIFY_YIELD, 0)		AS SSP_MODIFY_YIELD */
             , NVL(IA.YIELD, 0)                                                             AS CHAR_YIELD              /* ISNULL(FR.CHAR_YIELD, 0)				AS CHAR_YIELD */
          FROM (SELECT A.PLANT_ID || '-A'                AS PLANT_SITE_ID
                     , A.ITEM_ID
                     , B.YYYYMM
                     , B.YYYYPW
                     , TRUNC(AVG(NVL(A.YIELD, 1)), 6)    AS YIELD   /* MSSQL AVG(decimal(18,6)) 는 소수 6자리 버림 */
                  FROM SCM_MST_YIELD_SN A
                     , GT_GPWW_PW_LIST  B
                 WHERE B.YYYYMM        = A.MONTH
                   AND B.YYYYPW       >= V_PLAN_START_YYYYPW   /* 미래 계획 구간 */
                   AND A.DIVISION_ID   = V_DIVISION_ID
                   /* AND		A.MONTH 		>= @V_PLAN_START_YYYYMM  -- 미래 계획 구간 */
                   /* AND     A.OPERATION_ID 	IN ( 'F6000' , 'P9500', 'P5200', 'P5500') */
                   AND A.OPERATION_ID IN ('P9500', 'P5200', 'P5500')
                 GROUP BY A.PLANT_ID
                        , A.ITEM_ID
                        , B.YYYYMM
                        , B.YYYYPW
                 UNION ALL
                SELECT C.PLANT_SITE_ID
                     , C.ITEM_ID
                     , D.YYYYMM
                     , D.YYYYPW
                     , ROUND(MAX(NVL(C.SSP_MODIFY_YIELD, C.FORMATION_TOTAL_YIELD)), 6)   AS YIELD   /* MSSQL UNION ALL 결과형 decimal(38,6) 로 소수 6자리 반올림 */
                  FROM SCP_MST_FORMATION C
                     , GT_GPWW_PW_LIST   D
                 WHERE D.YYYYPW     >= V_PLAN_START_YYYYPW   /* 미래 계획 구간 */
                   AND C.DIVISION_ID = V_DIVISION_ID
                 GROUP BY C.PLANT_SITE_ID
                        , C.ITEM_ID
                        , D.YYYYMM
                        , D.YYYYPW) IA
             , SCP_MST_FORMATION E
         WHERE 1=1
           AND E.PLANT_SITE_ID(+) = IA.PLANT_SITE_ID
           AND E.ITEM_ID(+)       = IA.ITEM_ID;

        /* -------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : #SCP_PLN_TH_ENG_STOCK_PLAN ');
        /* -------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SCP_PLN_TH_ENG_STOCK_PLAN;

        INSERT
          INTO GT_GPWW_SCP_PLN_TH_ENG_STOCK_PLAN
             ( ITEM_ID
             , SITE_ID
             , RECEIVING_DTTM
             , YYYYMMDD
             , QTY
             , LOT_ID
             , DESCR
             , INSP_TYPE )
        SELECT ITEM_ID
             , SITE_ID
               /* ,ES.ROUTE_ID */
               /* ,ES.OPERATION_ID */
             , RECEIVING_DTTM
             , TO_CHAR(RECEIVING_DTTM, 'YYYYMMDD')   AS YYYYMMDD
             , QTY
             , LOT_ID
             , DESCR
             , INSP_TYPE
          FROM SCP_PLN_TH_ENG_STOCK_PLAN
         WHERE 1=1
           AND MASTER_ID = V_MASTER_ID
           AND PLAN_ID   = V_ENG_PLAN_ID;

        /* ----------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 해당 사업부 팩(모듈) 모델 셀 환산수량 정보 추출 ');
        /* ----------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SCP_MST_ITEM_CELL_CF;

        INSERT
          INTO GT_GPWW_SCP_MST_ITEM_CELL_CF
             ( ITEM_ID
             , TARGET_CELL
             , CELL_CF )
        SELECT A.ITEM_ID
             , A.TARGET_CELL
             , A.CELL_CF
          FROM SCP_MST_ITEM_CELL_CF A
         WHERE 1=1
           AND EXISTS (SELECT 1
                         FROM SCM_MST_ITEM_SN SA
                        WHERE 1=1
                          AND SA.ITEM_ID             = A.ITEM_ID
                          AND SA.SCP_OPERATION_GROUP = 'P'
                          AND SA.DIVISION_ID         = V_DIVISION_ID);

        /* ----------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 대표Cell 품목 매핑 : CP Cell 정보 for Pack');
        /* ----------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_CP_CELL_ITEM_INFO;

        INSERT
          INTO GT_GPWW_CP_CELL_ITEM_INFO
             ( MODEL_ID
             , CELL_ITEM_ID )
        SELECT MODEL_ID
             , MIN(CHILD_ITEM_ID) KEEP (DENSE_RANK FIRST ORDER BY UPPER(TRANSLATE(CHILD_ITEM_ID, '_-', '/')) NULLS LAST, CHILD_ITEM_ID NULLS LAST)   AS CELL_ITEM_ID   /* MSSQL Latin1_General_CI_AS 비교 재현(대소문자·하이픈 무시, 밑줄은 글자·숫자 앞) */
          FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V
         WHERE CELL_TYPE          = 'CP'
           AND OPERATION_GROUP_ID = 'A'
           AND DIVISION_ID        = V_DIVISION_ID
         GROUP BY MODEL_ID;


        /* ----------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 대표Cell 품목 매핑 : AMDAU 모듈의 상위 모델 및 셀(CP) INFO');
        /* ----------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_MODULE_MODEL_INFO;
/*
		SELECT *
		 INTO #MODULE_MODEL_INFO
		 FROM (
  				SELECT B.DIVISION_ID
					  ,B.CHILD_ITEM_ID		AS MODULE_ID
					  ,B.PARENT_ITEM_ID		AS MODEL_ID
					  ,C.CELL_ITEM_ID
					  ,B.KEY_DATE
					  ,ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
													  ,B.CHILD_ITEM_ID
											  ORDER BY B.KEY_DATE DESC ) AS RN
					  ,ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
													  ,B.CHILD_ITEM_ID
													  ,B.PARENT_ITEM_ID
											  ORDER BY B.KEY_DATE DESC ) AS RN2
					  , F.GROUP_CODE1
					  , CASE WHEN F.GROUP_CODE1 IN ('E60A', 'E78', 'E79A', 'E129A') THEN 'Y' ELSE 'N' END PACK_MODULE_ITEM	--@@@ 5200 기준 모델 구분진행
				 FROM SCM_MST_BOM_ENG_SN  B WITH(NOLOCK)	-- SCM_MST_BOM_ENG_SN
					  INNER JOIN #CP_CELL_ITEM_INFO C
							  ON C.MODEL_ID = B.PARENT_ITEM_ID
					  LEFT  JOIN #SCP_MST_FINAL_ITEM F WITH(NOLOCK)
							  ON F.ITEM_ID	  = B.PARENT_ITEM_ID
				WHERE B.DIVISION_ID = @V_DIVISION_ID
				  AND B.CHILD_ITEM_ID LIKE 'AMDAU%'
				  AND EXISTS (SELECT TOP 1 *   ---- 2024.01.26 추가 (Pack>module>cell 관계 성립 데이터만 참조)
							   FROM SCM_MST_BOM_SN SB WITH(NOLOCK)
							   WHERE 1=1
							     AND SB.DIVISION_ID		= @V_DIVISION_ID
								 AND SB.CHILD_ITEM_ID	= C.CELL_ITEM_ID	-- CP (Cell Product
								 AND SB.CONCATENATE_ITEM LIKE CONCAT(B.PARENT_ITEM_ID ,'%', B.CHILD_ITEM_ID, '%') -- pack model_id%module_id%
								 )
			) AS AMDAU_MODEL
		WHERE 1=1
		  AND RN = 1
*/

        /* 누락되는 module 이 있어 SCM_MODEL_COMP_TEMP_SN 를 직접보도록 수정 */
        INSERT
          INTO GT_GPWW_MODULE_MODEL_INFO
             ( DIVISION_ID
             , MODULE_ID
             , MODEL_ID
             , CELL_ITEM_ID
             , KEY_DATE
             , RN
             , RN2
             , GROUP_CODE1
             , PACK_MODULE_ITEM )
        SELECT IA.DIVISION_ID
             , IA.MODULE_ID
             , IA.MODEL_ID
             , IA.CELL_ITEM_ID
             , IA.KEY_DATE
             , IA.RN
             , IA.RN2
             , IA.GROUP_CODE1
             , IA.PACK_MODULE_ITEM
          FROM (SELECT A.DIVISION_ID
                     , A.CHILD_ITEM_ID     AS MODULE_ID
                     , A.PARENT_ITEM_ID    AS MODEL_ID
                     , C.CELL_MODEL_ID     AS CELL_ITEM_ID   /* ,C.CHILD_ITEM_ID AS CELL_ITEM_ID */
                     , A.KEY_DATE
                     , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                                     , A.CHILD_ITEM_ID
                                              ORDER BY A.KEY_DATE DESC)   AS RN
                     , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                                     , A.CHILD_ITEM_ID
                                                     , A.PARENT_ITEM_ID
                                              ORDER BY A.KEY_DATE DESC)   AS RN2
                     , C.GROUP_CODE1
                       /* E20260407-000405 GLOBAL PSI NEW - P5200공정 모델 추가 기존로직 제거 */
                       /* , CASE WHEN F.GROUP_CODE1 IN ('E60A', 'E78', 'E79A', 'E129A', 'E128A') THEN 'Y' ELSE 'N' END PACK_MODULE_ITEM	--@@@ 5200 기준 모델 구분진행 */
                       /* E20260407-000405 GLOBAL PSI NEW - P5200공정 모델 추가 변경로직 시작 */
                     , CASE WHEN C.GROUP_CODE1 IN (SELECT DISTINCT
                                                          XA.SEGMENT1   AS GROUP_CODE1
                                                     FROM SCM_ADM_LOOKUP_MASTER_DETAIL XA
                                                    WHERE 1=1
                                                      AND XA.LOOKUP_TYPE = 'P5200_GROUP_EXCEPTION'
                                                      AND XA.VALID_YN    = 'Y')
                            THEN 'Y'
                            ELSE 'N'
                       END                                                AS PACK_MODULE_ITEM   /* --@@@ 5200 기준 모델 구분진행 */
                       /* E20260407-000405 GLOBAL PSI NEW - P5200공정 모델 추가 변경로직 끝 */
                  FROM SCM_MST_BOM_ENG_SN         A   /* SCM_MST_BOM_ENG_SN */
                     , SCM_MODEL_COMP_TEMP_SN     B
                     , GT_GPWW_SCP_MST_FINAL_ITEM C
                 WHERE 1=1
                   AND A.COMPANY_ID       = B.COMPANY_ID    /* CP (Cell Product */
                   AND A.DIVISION_ID      = B.DIVISION_ID   /* CP (Cell Product */
                   AND A.SITE_ID          = B.SITE_ID       /* CP (Cell Product */
                   AND A.PLANT_ID         = B.PLANT_ID      /* CP (Cell Product */
                   AND B.MODEL_ID         = A.PARENT_ITEM_ID
                   AND C.ITEM_ID(+)       = A.PARENT_ITEM_ID
                   AND EXISTS (SELECT 1   /* -- 2024.01.26 추가 (Pack>module>cell 관계 성립 데이터만 참조) */
                                 FROM SCM_MST_BOM_SN SA
                                WHERE 1=1
                                  AND SA.COMPANY_ID       = B.COMPANY_ID      /* CP (Cell Product */
                                  AND SA.DIVISION_ID      = B.DIVISION_ID     /* CP (Cell Product */
                                  AND SA.SITE_ID          = B.SITE_ID         /* CP (Cell Product */
                                  AND SA.PLANT_ID         = B.PLANT_ID        /* CP (Cell Product */
                                  AND SA.CHILD_ITEM_ID    = B.CHILD_ITEM_ID   /* CP (Cell Product */
                                  AND SA.CONCATENATE_ITEM LIKE A.PARENT_ITEM_ID || '%' || A.CHILD_ITEM_ID || '%'   /* pack model_id%module_id% */
                                  AND SA.CHILD_ITEM_ID    LIKE 'AMDAU%'
                                  AND SA.DIVISION_ID      = V_DIVISION_ID)
                   AND A.CHILD_ITEM_ID LIKE 'AMDAU%'
                   AND A.DIVISION_ID      = V_DIVISION_ID) IA
         WHERE 1=1
           AND IA.RN = 1;

        /* ----------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 대표Cell 품목 매핑 : 기타 모델 CP 셀 정보');
        /* ----------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_ETC_CP_CELL_INFO;

        INSERT
          INTO GT_GPWW_ETC_CP_CELL_INFO
             ( PARENT_ITEM_ID
             , CELL_ITEM_ID )
        SELECT A.PARENT_ITEM_ID
             , MIN(A.CHILD_ITEM_ID) KEEP (DENSE_RANK FIRST ORDER BY UPPER(TRANSLATE(A.CHILD_ITEM_ID, '_-', '/')) NULLS LAST, A.CHILD_ITEM_ID NULLS LAST)   AS CELL_ITEM_ID   /* MSSQL Latin1_General_CI_AS 비교 재현(대소문자·하이픈 무시, 밑줄은 글자·숫자 앞) */
          FROM SCM_MST_BOM_SN             A   /* SCM_MST_BOM_SN */
             , GT_GPWW_SCP_MST_FINAL_ITEM B
         WHERE 1=1
           AND B.ITEM_ID     = A.CHILD_ITEM_ID
           AND B.CELL_TYPE   = 'CP'
           AND A.DIVISION_ID = V_DIVISION_ID
         GROUP BY A.PARENT_ITEM_ID;



/* begin : 미래구간 Model Inventory (pack plant cell재고 제외) */
/* begin : 미래구간 Model Inventory (pack plant cell재고 제외) */

        /* ----------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : 기존 Global PSI Raw 데이터 ');
        /* ----------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SCP_ANL_PSI_GLOBAL;

        INSERT
          INTO GT_GPWW_SCP_ANL_PSI_GLOBAL
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMMDD
             , ATTRIBUTE1
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , MEASURE
             , QTY
             , TS_SITE_TYPE
             , TS_OPERATION_GROUP )
        SELECT A.OPERATION_GROUP
             , A.ITEM_ID
             , A.TO_SITE
             , A.INCOTERMS
             , A.FROM_SITE
             , A.TRANSPORT_MODE_LINE
             , A.YYYYMMDD
             , A.ATTRIBUTE1
             , A.FROM_BOH_QTY
             , A.TO_BOH_QTY
             , A.MEASURE
             , A.QTY
             , B.SITE_TYPE          AS TS_SITE_TYPE
             , B.OPERATION_GROUP    AS TS_OPERATION_GROUP
          FROM SCP_ANL_PSI_GLOBAL   A
             , GT_GPWW_SCM_MST_SITE B
         WHERE B.SCM_SITE_ID(+)     = A.TO_SITE
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = V_PLAN_TYPE
           AND A.SEQ                 = V_PLAN_SEQ
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.MEASURE IN (
                             'WH_IN'
                            ,'SHIP_PLAN'
                            ,'PRODUCTION'
                            /* 20231122 임시로 별도 산식에서 계산 적용 (* 향후 Simulator Char. Plan 저장값이 FN에 확정계획으로 반영될 시 현재 산식기준으로 원복) ,'ACTIVATE_COMPLETED'	-- 특성(F6000) 생산계획 -- CELL_CHAR_PLAN */
                            ,'MODEL_INVENTORY'        /* 재고(EOH) */
                            );

        /* 81 Division 일 경우 Ship Plan 정보를 WH_IN 으로 넣어준다. */
        INSERT
          INTO GT_GPWW_SCP_ANL_PSI_GLOBAL
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMMDD
             , ATTRIBUTE1
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , MEASURE
             , QTY
             , TS_SITE_TYPE
             , TS_OPERATION_GROUP )
        SELECT A.OPERATION_GROUP
             , A.ITEM_ID
             , A.TO_SITE
             , A.INCOTERMS
             , A.FROM_SITE
             , A.TRANSPORT_MODE_LINE
             , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD') + 24, 'YYYYMMDD') AS YYYYMMDD    /* LT 24 적용 */
             , A.ATTRIBUTE1
             , A.FROM_BOH_QTY
             , A.TO_BOH_QTY
             , 'WH_IN'              AS MEASURE
             , A.QTY
             , B.SITE_TYPE          AS TS_SITE_TYPE
             , B.OPERATION_GROUP    AS TS_OPERATION_GROUP
          FROM SCP_ANL_PSI_GLOBAL   A
             , GT_GPWW_SCM_MST_SITE B
         WHERE B.SCM_SITE_ID(+)     = A.TO_SITE
           AND 1 = (CASE WHEN V_DIVISION_ID = '81' THEN 1 ELSE 0 END)
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = V_PLAN_TYPE
           AND A.SEQ                 = V_PLAN_SEQ
           /* AND PG.DIVISION_ID			= '81_ST'--@V_DIVISION_ID */
           AND A.MEASURE             = 'SHIP_PLAN'
           AND A.ITEM_ID          LIKE 'ACEH1131I-B1%'
           AND A.TO_SITE             = 'ESST_CA_WND'
           AND A.QTY                <> 0;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : 기존 Global PSI Raw 데이터 - asis 기준 재고 삭제 (pack plant cell재고 제외) ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM GT_GPWW_SCP_ANL_PSI_GLOBAL
         WHERE MEASURE     = 'MODEL_INVENTORY'
           AND ATTRIBUTE1 != 'CELL';  /* - pack plant cell재고를 제외 하고 asis 재고 데이터 삭제 */

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : 기존 Global PSI Raw 데이터 - asis 기준 재고 삭제 (to Sales Site WH In) ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM GT_GPWW_SCP_ANL_PSI_GLOBAL
         WHERE MEASURE            IN ('WH_IN', 'SHIP_PLAN')  /* @@@ intransit 계산시 AS 빠져서  ship_plan 도 제외 */
           AND TS_OPERATION_GROUP = 'W'
           AND TS_SITE_TYPE       = 'SALES';

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : 기존 Global PSI Raw 데이터 - AMDAU% PRODUCTION 삭제 ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM GT_GPWW_SCP_ANL_PSI_GLOBAL
         WHERE MEASURE  = 'PRODUCTION'
           AND ITEM_ID LIKE 'AMDAU%';

        /* ----------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : 기존 Global PSI 참조 Measure ');
        /* ----------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_ASIS_GLOBAL_PSI;

        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT A.OPERATION_GROUP
             , A.ITEM_ID
             , A.TO_SITE
             , A.INCOTERMS
             , A.FROM_SITE
             , A.TRANSPORT_MODE_LINE
             , B.YYYYPW
             , CASE WHEN A.MEASURE = 'ACTIVATE_COMPLETED'
                    THEN 'CELL_CHAR_PLAN'
                    ELSE A.MEASURE
               END  AS MEASURE
             , CASE WHEN A.MEASURE = 'MODEL_INVENTORY' AND A.ATTRIBUTE1 = 'CELL'
                    THEN 'Y'
                    ELSE 'N'
               END AS IS_CELL_IN_PACK_PLANT
             , A.FROM_BOH_QTY
             , A.TO_BOH_QTY
             , SUM(CASE WHEN A.MEASURE = 'MODEL_INVENTORY' AND B.PW_TO_YMD = A.YYYYMMDD
                        THEN A.QTY
                        WHEN A.MEASURE != 'MODEL_INVENTORY'
                        THEN A.QTY
                        ELSE 0.0 END)       AS QTY            /* 재고는 월말 기준 데이터로 적재 */
          FROM GT_GPWW_SCP_ANL_PSI_GLOBAL A
             , GT_GPWW_DATE_INFO          B
         WHERE B.YYYYMMDD = A.YYYYMMDD
         GROUP BY A.OPERATION_GROUP
             , A.ITEM_ID
             , A.TO_SITE
             , A.INCOTERMS
             , A.FROM_SITE
             , A.TRANSPORT_MODE_LINE
             , B.YYYYPW
             , A.MEASURE
             , CASE WHEN A.MEASURE = 'MODEL_INVENTORY' AND A.ATTRIBUTE1 = 'CELL'
                    THEN 'Y'
                    ELSE 'N'
               END
             , A.FROM_BOH_QTY
             , A.TO_BOH_QTY;

        /* --------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 재고 - Plant 기초 재고 (보류제외)');
        /* ASIS ANL PSI PRODUCTION 재고 계산시 적용된 BOH */
        /* --------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_BOH;

        INSERT
          INTO GT_GPWW_BOH
             ( SITE_ID
             , ITEM_ID
             , BOH_QTY )
        SELECT A.SITE_ID
             , NVL(C.ITEM_ID_ASSY, A.ITEM_ID)  AS ITEM_ID
             , NVL(SUM(A.PSI_BOH_QTY), 0)      AS BOH_QTY
          FROM SCP_PLN_PLANT_ONHAND       A
             , GT_GPWW_SCM_MST_SITE       B
             , GT_GPWW_CELL_PROD_ASSY_MAP C
         WHERE B.SCM_SITE_ID          = A.SITE_ID
           AND C.PLANT_ID(+)          = B.PLANT_ID
           AND C.ITEM_ID_PROD(+)      = A.ITEM_ID
           AND C.ASSY_PRIORITY_1ST(+) = 1
           AND A.DIVISION_ID          = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE            = V_PLAN_TYPE
           AND A.SEQ                  = V_PLAN_SEQ
           AND A.YYYYMMDD             = V_PLAN_START_YYYYMMDD  /* plan start date 기준 plant 기초 재고 */
           AND A.STOCK_TYPE    NOT IN ( 'ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING','A_MOVE_WH')  /* 셀 특성완료이전 제외 */
         GROUP BY A.SITE_ID
             , NVL(C.ITEM_ID_ASSY, A.ITEM_ID);

        /* --------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 재고 - 보류 재고 (WH_HOLD) ');
        /* 가용일(RECEIVING_DTTM)과 상관 없이 BOH에 모두 반영 */
        /* --------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_WH_HOLD;

        /* 보류재고 */
        INSERT
          INTO GT_GPWW_WH_HOLD
             ( ITEM_ID
             , FROM_SITE
             , WH_HOLD_QTY )
        SELECT NVL(C.ITEM_ID_ASSY, A.ITEM_ID)                       AS ITEM_ID
             , SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)      AS FROM_SITE
             , SUM(A.QTY)                                           AS WH_HOLD_QTY
          FROM GT_GPWW_SCP_PLN_TH_ENG_STOCK_PLAN A
             , GT_GPWW_SCM_MST_SITE              B
             , GT_GPWW_CELL_PROD_ASSY_MAP        C
         WHERE B.SCM_SITE_ID          = SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1)
           AND C.PLANT_ID(+)          = B.PLANT_ID
           AND C.ITEM_ID_PROD(+)      = A.ITEM_ID
           AND C.ASSY_PRIORITY_1ST(+) = 1
           AND A.LOT_ID            LIKE 'WH_HOLD%'  /* 가용일(RECEIVING_DTTM)과 상관 없이 BOH에 모두 반영 */
         GROUP BY NVL(C.ITEM_ID_ASSY, A.ITEM_ID)
             , SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID, '~') - 1);

        /* --------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 재고 - 생산/출하 데이터 추출 ');
        /* ASIS Global PSI 재고 계산시 적용된 생산 출하 정보 자동차 기준 참조 */
        /* --------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SCP_ANL_PSI_PRODUCTION;

        INSERT
          INTO GT_GPWW_SCP_ANL_PSI_PRODUCTION
             ( FROM_SITE
             , PLANT_ID
             , ITEM_ID
             , YYYYPW
             , OPERATION_GROUP
             , SHIP_QTY
             , PROD_QTY )
        SELECT A.FROM_SITE
             , C.PLANT_ID
             , NVL(D.ITEM_ID_ASSY, A.ITEM_ID) AS ITEM_ID
             , B.YYYYPW
             , A.OPERATION_GROUP
             , SUM(CASE WHEN A.PSI_TYPE = 'S' THEN A.QTY ELSE 0 END) AS SHIP_QTY
             , SUM(CASE WHEN A.OPERATION_GROUP != 'A' AND A.PSI_TYPE ='P'                                          /* pack prod */
                        THEN A.QTY
                        WHEN A.OPERATION_GROUP  = 'A' AND A.PSI_TYPE ='I' AND A.PSI_VALUE ='ACTIVATE_COMPLETED'    /* cell prod */
                        THEN A.QTY
                        ELSE 0
                   END)                                                AS PROD_QTY
          FROM SCP_ANL_PSI_PRODUCTION     A
             , GT_GPWW_DATE_INFO          B
             , GT_GPWW_SCM_MST_SITE       C
             , GT_GPWW_CELL_PROD_ASSY_MAP D
         WHERE B.YYYYMMDD             = A.YYYYMMDD
           AND C.SCM_SITE_ID          = A.FROM_SITE
           AND D.PLANT_ID(+)          = C.PLANT_ID
           AND D.ITEM_ID_PROD(+)      = A.ITEM_ID
           AND D.ASSY_PRIORITY_1ST(+) = 1
           AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE            = V_PLAN_TYPE
           AND A.SEQ                  = V_PLAN_SEQ
           AND A.DIVISION_ID          = V_DIVISION_ID
           AND A.PSI_VALUE           != 'ISSUM'
           AND (A.PSI_TYPE = 'S'
                 OR (A.OPERATION_GROUP != 'A' AND A.PSI_TYPE ='P')                                          /* pack prod */
                 OR (A.OPERATION_GROUP  = 'A' AND A.PSI_TYPE ='I' AND A.PSI_VALUE ='ACTIVATE_COMPLETED')    /* cell prod */
                 )
         GROUP BY A.FROM_SITE
             , C.PLANT_ID
             , NVL(D.ITEM_ID_ASSY, A.ITEM_ID)
             , B.YYYYPW
             , A.OPERATION_GROUP;


        /* CREATE NONCLUSTERED INDEX PSI_PRODUCTION_IDX1 ON #SCP_ANL_PSI_PRODUCTION(ITEM_ID, FROM_SITE, YYYYPW) ; → GTT 인덱스 GT_GPWW_SCP_ANL_PSI_PROD_IX1 로 DDL 에 생성 */

        /* --------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 재고 - 생산/출하 누적 수량 ');
        /* --------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_PSI_PROD_SHIP;

        INSERT
          INTO GT_GPWW_PSI_PROD_SHIP
             ( ITEM_ID
             , FROM_SITE
             , OPERATION_GROUP
             , YYYYPW
             , ACC_SHIP_QTY
             , ACC_PROD_QTY
             , SUB_TOT_SHIP_QTY
             , SUB_TOT_PROD_QTY )
        SELECT ITEM_ID
             , FROM_SITE
             , OPERATION_GROUP
             , YYYYPW
             , SUM(SHIP_QTY) OVER (PARTITION BY ITEM_ID
                                              , FROM_SITE
                                       ORDER BY YYYYPW)  AS ACC_SHIP_QTY
             , SUM(PROD_QTY) OVER (PARTITION BY ITEM_ID
                                              , FROM_SITE
                                       ORDER BY YYYYPW)  AS ACC_PROD_QTY
             , SUM(SHIP_QTY) OVER (PARTITION BY ITEM_ID
                                              , FROM_SITE) AS SUB_TOT_SHIP_QTY
             , SUM(PROD_QTY) OVER (PARTITION BY ITEM_ID
                                              , FROM_SITE) AS SUB_TOT_PROD_QTY
          FROM GT_GPWW_SCP_ANL_PSI_PRODUCTION
         WHERE 1=1
         ORDER BY ITEM_ID
             , FROM_SITE
             , YYYYPW;

        /* --------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 재고 - 재고계산 ');
        /* Pack plant 팩재고, Cell Plant 셀재고 */
        /* 재고 = 기초재고 + 보류재고 + 생산(누적) - 출하(누적) */
        /* --------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_MODEL_INVENTORY;

        INSERT
          INTO GT_GPWW_MODEL_INVENTORY
             ( ITEM_ID
             , FROM_SITE
             , YYYYPW
             , OPERATION_GROUP
             , ACC_SHIP_QTY
             , ACC_PROD_QTY
             , SUB_TOT_SHIP_QTY
             , SUB_TOT_PROD_QTY
             , WH_HOLD_QTY
             , ASIS_BOH_QTY
             , TOBE_BOH_QTY
             , ASIS_MODEL_INVENTORY
             , TOBE_MODEL_INVENTORY )
        SELECT A.ITEM_ID
             , A.FROM_SITE
             , A.YYYYPW
             , A.OPERATION_GROUP
             , A.ACC_SHIP_QTY
             , A.ACC_PROD_QTY
             , A.SUB_TOT_SHIP_QTY
             , A.SUB_TOT_PROD_QTY
             , NVL(C.WH_HOLD_QTY, 0)                          AS WH_HOLD_QTY
             , NVL(B.BOH_QTY, 0)                              AS ASIS_BOH_QTY
             , NVL(B.BOH_QTY, 0) + NVL(C.WH_HOLD_QTY, 0)      AS TOBE_BOH_QTY
             , NVL(B.BOH_QTY, 0)
                   + A.ACC_PROD_QTY - A.ACC_SHIP_QTY          AS ASIS_MODEL_INVENTORY
             , NVL(B.BOH_QTY, 0) + NVL(C.WH_HOLD_QTY, 0)
                   + A.ACC_PROD_QTY - A.ACC_SHIP_QTY          AS TOBE_MODEL_INVENTORY
          FROM GT_GPWW_PSI_PROD_SHIP A
             , GT_GPWW_BOH           B
             , GT_GPWW_WH_HOLD       C
         WHERE B.SITE_ID(+)   = A.FROM_SITE
           AND B.ITEM_ID(+)   = A.ITEM_ID
           AND C.FROM_SITE(+) = A.FROM_SITE
           AND C.ITEM_ID(+)   = A.ITEM_ID
         ORDER BY A.ITEM_ID
             , A.FROM_SITE
             , A.YYYYPW;

        /* --------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 재고 - 재고 measure 추가 ');
        /* --------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT OPERATION_GROUP
             , ITEM_ID
             , '-'                      AS TO_SITE
             , '-'                      AS INCOTERMS
             , FROM_SITE
             , '-'                      AS VARIOUS_KEY
             , YYYYPW
             , 'MODEL_INVENTORY'        AS MEASURE
             , 'N'                      AS IS_CELL_IN_PACK_PLANT
             , TOBE_BOH_QTY             AS FROM_BOH_QTY
             , 0.0                      AS TO_BOH_QTY
             , TOBE_MODEL_INVENTORY     AS QTY
          FROM GT_GPWW_MODEL_INVENTORY
         WHERE 1=1;

/* end : 미래구간 Model Inventory (pack plant cell재고 제외) */
/* end : 미래구간 Model Inventory (pack plant cell재고 제외) */


/*  @@@ 위치 옮김 */
/* --- Begin :### 실적 구간 Ending Inventory Weekly 재고 */
/* --- Begin :### 실적 구간 Ending Inventory Weekly 재고 */

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : 참조 대상 품목 정보');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_TARGET_ITEM_FOR_ENDING_INV;

        INSERT
          INTO GT_GPWW_TARGET_ITEM_FOR_ENDING_INV
             ( ITEM_ID
             , FINISHED_PRODUCT
             , OPERATION_ID
             , OPERATION_GROUP
             , ITEM_TYPE
             , PROCESS_GROUP )
        SELECT A.ITEM_ID
             , NVL(MAX(B.FINISHED_PRODUCT), 'N')  AS FINISHED_PRODUCT
             , MAX(A.SCP_FLOW_ID)                 AS OPERATION_ID
             , MAX(A.SCP_OPERATION_GROUP)         AS OPERATION_GROUP
             , MAX(C.ITEM_TYPE)                   AS ITEM_TYPE      /* -- E20251029-001009 : CLASS정보에서 반제/제품 구분을 위해 추가. */
             , MAX(C.PROCESS_GROUP)               AS PROCESS_GROUP  /* -- E20251029-001009 : CLASS정보에서 반제/제품 구분을 위해 추가. */
          FROM SCM_MST_ITEM_SN            A  /* SCM_MST_ITEM_SN */
             , GT_GPWW_SCP_MST_FINAL_ITEM B
             , SCM_MST_ITEM_CLASS_M       C  /* -- E20251029-001009 : CLASS정보에서 반제/제품 구분을 위해 추가. */
         WHERE B.ITEM_ID(+)   = A.ITEM_ID
           AND C.CLASS_ID(+)  = A.ITEM_CLASS
           AND (
               A.ITEM_ID LIKE 'AMDAU%'
               OR
               EXISTS (SELECT 1
                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                        WHERE SA.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                          AND SA.SEGMENT1    = A.SCP_FLOW_ID
                          AND SA.SEGMENT1   != 'F6000'
                          AND SA.VALID_YN    = 'Y'
                          AND SA.SEGMENT4 LIKE '%' || V_DIVISION_ID || '%'
                       )
               )
           AND A.SCP_OPERATION_GROUP IN ('A', 'P')
           AND A.DIVISION_ID = V_DIVISION_ID
         GROUP BY A.ITEM_ID;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : 시뮬레이터 measure sloc 매핑 정보');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SLOC_ADD_INFO;

        INSERT
          INTO GT_GPWW_SLOC_ADD_INFO
             ( PLANT
             , SLOC
             , SIMU_MEASURE )
        SELECT DISTINCT
               SEGMENT1     AS PLANT
             , SEGMENT2     AS SLOC
             , ATTRIBUTE12  AS SIMU_MEASURE
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SLOC_ADD_INFO'
           AND TRIM(ATTRIBUTE12) IS NOT NULL;  /* 원문 ATTRIBUTE12 <> '' : 이관 데이터에 공백 1자(' ') 행이 있어 MSSQL 후행공백 무시 비교와 같게 TRIM */

        /* 2025.05.28   kimcd GLOBAL PSI NEW - AS 대상 SALES_TYPE_CODE 임시 정보 형성 시작 */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### AS 대상 SALES_TYPE_CODE');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_AS_SALES_TYPE_CODE;

        INSERT
          INTO GT_GPWW_AS_SALES_TYPE_CODE
             ( FCST_TYPE )
        SELECT SEGMENT1     AS FCST_TYPE
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SALES_TYPE_CODE'
           AND ATTRIBUTE3  = 'Y';
        /* 2025.05.28   kimcd GLOBAL PSI NEW - AS 대상 SALES_TYPE_CODE 임시 정보 형성 끝 */

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        /* Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : SCP Exclude Class 품목을 Cell Assy 매핑정보');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SCP_EXC_ITEM_ASSY_MAP;

        INSERT
          INTO GT_GPWW_SCP_EXC_ITEM_ASSY_MAP
             ( COMPANY_ID
             , DIVISION_ID
             , PLANT_ID
             , SCP_EXC_ITEM_ID
             , CELL_ASSY_ITEM_ID )
        SELECT COMPANY_ID
             , DIVISION_ID
             , PLANT_ID
             , SCP_EXC_ITEM_ID
             , MAX(CELL_ASSY_ITEM_ID) KEEP (DENSE_RANK LAST ORDER BY UPPER(TRANSLATE(CELL_ASSY_ITEM_ID, '_-', '/')) NULLS FIRST, CELL_ASSY_ITEM_ID NULLS FIRST)   AS CELL_ASSY_ITEM_ID   /* MSSQL Latin1_General_CI_AS 비교 재현(대소문자·하이픈 무시, 밑줄은 글자·숫자 앞) */
          FROM TABLE(FN_GET_SCP_EXC_ITEM_ASSY_MAP(V_DIVISION_ID))
         WHERE 1=1
         GROUP BY COMPANY_ID
             , DIVISION_ID
             , PLANT_ID
             , SCP_EXC_ITEM_ID;
        /* End : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : 월별 재고 - Raw 데이터');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_ENDING_INV_MM_RAW;

        INSERT
          INTO GT_GPWW_ENDING_INV_MM_RAW
             ( ITEM_ID
             , YYYYMM
             , STORAGE_LOCATION
             , PLANT_ID
             , SUPPLIER_CODE
             , QUANTITY )
        SELECT NVL(B.CELL_ASSY_ITEM_ID, A.ITEM_ID)  AS ITEM_ID  /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , A.YYYYMM
             , A.STORAGE_LOCATION
             , A.PLANT_ID
             , A.SUPPLIER_CODE
             , A.QUANTITY
          FROM SCP_ANL_MONTH_END_STOCK_R     A
               /* Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , GT_GPWW_SCP_EXC_ITEM_ASSY_MAP B
               /* End : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
         WHERE B.COMPANY_ID(+)      = A.COMPANY_ID
           AND B.DIVISION_ID(+)     = A.DIVISION_ID
           AND B.PLANT_ID(+)        = A.PLANT_ID
           AND B.SCP_EXC_ITEM_ID(+) = A.ITEM_ID
           AND A.DIVISION_ID        = V_DIVISION_ID
           AND A.YYYYMM            >= V_INV_FROM_YYYYMM
           AND A.YYYYMM            <= V_INV_TO_YYYYMM
           AND NVL(TRIM(A.SPECIAL_INVENTORY), ' ') != 'W'; /* @@@ Cosignment_stock[고객위탁재고]의 경우, S.loc이 공란이라 Key값으로 집계를 하지 못하여 제외하고 #TMP_ENDING_INV_MM_0 에 직접 입력함. */

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : 월별 재고 - 1');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_ENDING_INV_MM_0;

        INSERT
          INTO GT_GPWW_ENDING_INV_MM_0
             ( ITEM_ID
             , YYYYMM
             , OPERATION_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , MEASURE
             , QTY )
        SELECT A.ITEM_ID
             , A.YYYYMM
             , B.OPERATION_ID
             , B.OPERATION_GROUP
             , NVL(D.SCM_SITE_ID, '-')  AS FROM_SITE
             , NVL(E.SCM_SITE_ID, '-')  AS TO_SITE
             , CASE WHEN UPPER(C.SIMU_MEASURE) = 'BOH'                AND B.OPERATION_GROUP = 'P'       THEN 'PACK_EOH'
                    WHEN UPPER(C.SIMU_MEASURE) = 'BOH'                AND B.OPERATION_GROUP = 'A'       THEN 'CELL_EOH'
                    WHEN UPPER(C.SIMU_MEASURE) = 'CELL_BOH'                                             THEN 'CELL_EOH'
                    WHEN UPPER(C.SIMU_MEASURE) = 'PACK_CELL_BOH'      AND B.OPERATION_GROUP = 'A'       THEN 'PACK_CELL_EOH'
                    WHEN UPPER(C.SIMU_MEASURE) = 'CELL_FOR_FORM_END'                                    THEN 'CELL_CHAR_AVAILABLE'
                    /* WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'미착'	THEN 'SEMI_INTRANSIT' */
                    WHEN UPPER(C.SIMU_MEASURE) = 'INTRANSIT_ETA'      AND A.STORAGE_LOCATION = '미착'    THEN
                        (CASE WHEN B.OPERATION_ID IN ('P9500', 'P5500')                       THEN 'INTRANSIT'
                              WHEN B.OPERATION_ID = 'P5000'                                   THEN 'SEMI_INTRANSIT'
                              WHEN B.OPERATION_ID = 'A9000'   AND B.FINISHED_PRODUCT  = 'Y'   THEN 'INTRANSIT'
                              WHEN B.OPERATION_ID = 'A9000'   AND B.FINISHED_PRODUCT != 'Y'   THEN 'SEMI_INTRANSIT'
                              ELSE 'SEMI_INTRANSIT'
                          END )
                    /* E20251029-001009 : 7990 주석처리 / 7000이 아닌것은 제품/반제품 구분하여 분류 */
                    /* WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7990'	THEN 'INTRANSIT' */
                    WHEN UPPER(C.SIMU_MEASURE) = 'INTRANSIT_ETA'      AND A.STORAGE_LOCATION = '7000'    THEN
                         CASE WHEN B.OPERATION_ID IN ('P9500', 'P5500')                       THEN 'INTRANSIT'
                              WHEN B.OPERATION_ID = 'P5000'                                   THEN 'SEMI_INTRANSIT'
                              WHEN B.OPERATION_ID = 'A9000'   AND B.FINISHED_PRODUCT  = 'Y'   THEN 'INTRANSIT'
                              WHEN B.OPERATION_ID = 'A9000'   AND B.FINISHED_PRODUCT != 'Y'   THEN 'SEMI_INTRANSIT'
                              ELSE 'MISMATCH_INV'
                          END
                    /* E20251029-001009 : 7990 주석처리 / 7000이 아닌것은 제품/반제품 구분하여 분류 */
                    WHEN UPPER(C.SIMU_MEASURE) = 'INTRANSIT_ETA'      AND A.STORAGE_LOCATION != '7000'   THEN
                        CASE WHEN B.ITEM_TYPE = '제품'                                        THEN 'INTRANSIT'
                             WHEN B.ITEM_TYPE = '반제품'                                      THEN 'SEMI_INTRANSIT'
                             ELSE 'MISMATCH_INV'
                        END
                    WHEN UPPER(C.SIMU_MEASURE) = 'VMI'                                                  THEN 'TO_SITE_EOH'
                    WHEN UPPER(C.SIMU_MEASURE) = 'AS'                                                   THEN 'AS_INV'
                    WHEN UPPER(C.SIMU_MEASURE) = 'INTRANSIT_ETA'      AND UPPER(A.STORAGE_LOCATION) = 'IN-T' THEN 'INTRANSIT'  /* 20250210 DJLEE 'IN-T' MAPPING */
                    ELSE 'MISMATCH_INV'
               END AS MEASURE
             , SUM(A.QUANTITY)  AS QTY
          FROM GT_GPWW_ENDING_INV_MM_RAW          A
             , GT_GPWW_TARGET_ITEM_FOR_ENDING_INV B
             , GT_GPWW_SLOC_ADD_INFO              C
             , GT_GPWW_SCM_MST_SITE               D  /* from site */
             , GT_GPWW_SCM_MST_SITE               E  /* to site */
         WHERE B.ITEM_ID            = A.ITEM_ID
           AND C.PLANT              = A.PLANT_ID
           AND C.SLOC               = A.STORAGE_LOCATION
           AND D.SITE_TYPE(+)       = 'PLANT'
           AND D.PLANT_ID(+)        = CASE WHEN UPPER(C.SIMU_MEASURE) = 'INTRANSIT_ETA' AND A.STORAGE_LOCATION = '미착'
                                           THEN A.SUPPLIER_CODE
                                           ELSE A.PLANT_ID
                                      END
           AND D.OPERATION_GROUP(+) = CASE WHEN UPPER(C.SIMU_MEASURE) = 'PACK_CELL_BOH'  /* pack plant cell */
                                           THEN 'P'
                                           ELSE B.OPERATION_GROUP
                                      END
           AND E.SITE_TYPE(+)       = 'PLANT'
           AND E.PLANT_ID(+)        = CASE WHEN UPPER(C.SIMU_MEASURE) = 'INTRANSIT_ETA' AND A.STORAGE_LOCATION = '미착'
                                           THEN A.PLANT_ID
                                           ELSE 'Z'
                                      END
           AND E.OPERATION_GROUP(+) = B.OPERATION_GROUP
         GROUP BY A.ITEM_ID
             , A.YYYYMM
             , B.OPERATION_ID
             , B.OPERATION_GROUP
             , NVL(D.SCM_SITE_ID, '-')
             , NVL(E.SCM_SITE_ID, '-')
             , CASE WHEN UPPER(C.SIMU_MEASURE) = 'BOH'                AND B.OPERATION_GROUP = 'P'       THEN 'PACK_EOH'
                    WHEN UPPER(C.SIMU_MEASURE) = 'BOH'                AND B.OPERATION_GROUP = 'A'       THEN 'CELL_EOH'
                    WHEN UPPER(C.SIMU_MEASURE) = 'CELL_BOH'                                             THEN 'CELL_EOH'
                    WHEN UPPER(C.SIMU_MEASURE) = 'PACK_CELL_BOH'      AND B.OPERATION_GROUP = 'A'       THEN 'PACK_CELL_EOH'
                    WHEN UPPER(C.SIMU_MEASURE) = 'CELL_FOR_FORM_END'                                    THEN 'CELL_CHAR_AVAILABLE'
                    /* WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'미착'	THEN 'SEMI_INTRANSIT' */
                    WHEN UPPER(C.SIMU_MEASURE) = 'INTRANSIT_ETA'      AND A.STORAGE_LOCATION = '미착'    THEN
                        (CASE WHEN B.OPERATION_ID IN ('P9500', 'P5500')                       THEN 'INTRANSIT'
                              WHEN B.OPERATION_ID = 'P5000'                                   THEN 'SEMI_INTRANSIT'
                              WHEN B.OPERATION_ID = 'A9000'   AND B.FINISHED_PRODUCT  = 'Y'   THEN 'INTRANSIT'
                              WHEN B.OPERATION_ID = 'A9000'   AND B.FINISHED_PRODUCT != 'Y'   THEN 'SEMI_INTRANSIT'
                              ELSE 'SEMI_INTRANSIT'
                          END )
                    /* E20251029-001009 : 7990 주석처리 / 7000이 아닌것은 제품/반제품 구분하여 분류 */
                    /* WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7990'	THEN 'INTRANSIT' */
                    WHEN UPPER(C.SIMU_MEASURE) = 'INTRANSIT_ETA'      AND A.STORAGE_LOCATION = '7000'    THEN
                         CASE WHEN B.OPERATION_ID IN ('P9500', 'P5500')                       THEN 'INTRANSIT'
                              WHEN B.OPERATION_ID = 'P5000'                                   THEN 'SEMI_INTRANSIT'
                              WHEN B.OPERATION_ID = 'A9000'   AND B.FINISHED_PRODUCT  = 'Y'   THEN 'INTRANSIT'
                              WHEN B.OPERATION_ID = 'A9000'   AND B.FINISHED_PRODUCT != 'Y'   THEN 'SEMI_INTRANSIT'
                              ELSE 'MISMATCH_INV'
                          END
                    /* E20251029-001009 : 7990 주석처리 / 7000이 아닌것은 제품/반제품 구분하여 분류 */
                    WHEN UPPER(C.SIMU_MEASURE) = 'INTRANSIT_ETA'      AND A.STORAGE_LOCATION != '7000'   THEN
                        CASE WHEN B.ITEM_TYPE = '제품'                                        THEN 'INTRANSIT'
                             WHEN B.ITEM_TYPE = '반제품'                                      THEN 'SEMI_INTRANSIT'
                             ELSE 'MISMATCH_INV'
                        END
                    WHEN UPPER(C.SIMU_MEASURE) = 'VMI'                                                  THEN 'TO_SITE_EOH'
                    WHEN UPPER(C.SIMU_MEASURE) = 'AS'                                                   THEN 'AS_INV'
                    WHEN UPPER(C.SIMU_MEASURE) = 'INTRANSIT_ETA'      AND UPPER(A.STORAGE_LOCATION) = 'IN-T' THEN 'INTRANSIT'  /* 20250210 DJLEE 'IN-T' MAPPING */
                    ELSE 'MISMATCH_INV'
               END;

/* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : 월별 재고 미매칭 매저 별도관리');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */

        /* E20251028-000389 #TMP_SLOC_ADD_INFO 룩업에 매칭되지 않는것은 별도 매저로 관리 */
        INSERT
          INTO GT_GPWW_ENDING_INV_MM_0
             ( ITEM_ID
             , YYYYMM
             , OPERATION_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , MEASURE
             , QTY )
        SELECT A.ITEM_ID
             , A.YYYYMM
             , '-'              AS OPERATION_ID
             , '-'              AS OPERATION_GROUP
             , '-'              AS FROM_SITE
             , '-'              AS TO_SITE
             , 'MISMATCH_INV'   AS MEASURE
             , SUM(A.QUANTITY)  AS QTY
          FROM GT_GPWW_ENDING_INV_MM_RAW          A
             , GT_GPWW_TARGET_ITEM_FOR_ENDING_INV B
         WHERE B.ITEM_ID = A.ITEM_ID
           AND NOT EXISTS
               (SELECT 1
                  FROM GT_GPWW_SLOC_ADD_INFO SA
                 WHERE SA.PLANT = A.PLANT_ID
                   AND SA.SLOC  = A.STORAGE_LOCATION
               )
           AND B.ITEM_TYPE IN ('반제품', '제품')                  /* E20251028-000389 -- 반제품 / 제품 에서만 */
           AND UPPER(B.PROCESS_GROUP) IN ('모듈/팩', 'CELL')      /* E20251028-000389 -- 모듈/CELL 만. */
           AND TRIM(A.STORAGE_LOCATION) IS NOT NULL               /* 공백은것은 아래에서 로직처리 */
         GROUP BY A.ITEM_ID
             , A.YYYYMM;


        /* @@@ Cosignment_stock[고객위탁재고]의 경우, S.loc이 공란이라 Key값으로 집계를 하지 못하여 제외하고 #TMP_ENDING_INV_MM_0 에 직접 입력함. */
        INSERT
          INTO GT_GPWW_ENDING_INV_MM_0
             ( ITEM_ID
             , YYYYMM
             , OPERATION_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , MEASURE
             , QTY )
        SELECT NVL(E.CELL_ASSY_ITEM_ID, A.ITEM_ID)  AS ITEM_ID  /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , A.YYYYMM
             , B.OPERATION_ID
             , B.OPERATION_GROUP
             , NVL(C.SCM_SITE_ID, '-')  AS FROM_SITE
             , NVL(D.SCM_SITE_ID, '-')  AS TO_SITE
             , 'TO_SITE_EOH'            AS MEASURE
             , SUM(A.QUANTITY)          AS QTY
          FROM SCP_ANL_MONTH_END_STOCK_R          A
             , GT_GPWW_TARGET_ITEM_FOR_ENDING_INV B
             , GT_GPWW_SCM_MST_SITE               C  /* from site */
             , GT_GPWW_SCM_MST_SITE               D  /* to site */
               /* Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , GT_GPWW_SCP_EXC_ITEM_ASSY_MAP      E
               /* End : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
         WHERE B.ITEM_ID            = A.ITEM_ID
           AND C.SITE_TYPE(+)       = 'PLANT'
           AND C.PLANT_ID(+)        = A.PLANT_ID
           AND C.OPERATION_GROUP(+) = B.OPERATION_GROUP
           AND D.SITE_TYPE(+)       = 'PLANT'
           AND D.PLANT_ID(+)        = 'Z'
           AND D.OPERATION_GROUP(+) = B.OPERATION_GROUP
           AND E.COMPANY_ID(+)      = A.COMPANY_ID
           AND E.DIVISION_ID(+)     = A.DIVISION_ID
           AND E.PLANT_ID(+)        = A.PLANT_ID
           AND E.SCP_EXC_ITEM_ID(+) = A.ITEM_ID
           AND A.DIVISION_ID        = V_DIVISION_ID
           AND A.YYYYMM            >= V_INV_FROM_YYYYMM
           AND A.YYYYMM            <= V_INV_TO_YYYYMM
           AND A.SPECIAL_INVENTORY  = 'W'
           AND TRIM(A.STORAGE_LOCATION) IS NOT NULL  /* E20251029-001009 아래에서 STORAGE_LOCATION 가 공백인 로직처리함 */
         GROUP BY NVL(E.CELL_ASSY_ITEM_ID, A.ITEM_ID)  /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , A.YYYYMM
             , B.OPERATION_ID
             , B.OPERATION_GROUP
             , NVL(C.SCM_SITE_ID, '-')
             , NVL(D.SCM_SITE_ID, '-');

        /* 20250210 DJLEE SLOC & DESC 정보가 ''  건이 있음. (NERP 전환후) */
        INSERT
          INTO GT_GPWW_ENDING_INV_MM_0
             ( ITEM_ID
             , YYYYMM
             , OPERATION_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , MEASURE
             , QTY )
        SELECT NVL(E.CELL_ASSY_ITEM_ID, A.ITEM_ID)  /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , A.YYYYMM
             , B.OPERATION_ID
             , B.OPERATION_GROUP
             , NVL(C.SCM_SITE_ID, '-')  AS FROM_SITE
             , NVL(D.SCM_SITE_ID, '-')  AS TO_SITE
             , 'TO_SITE_EOH'            AS MEASURE
             , SUM(A.QUANTITY)          AS QTY
          FROM SCP_ANL_MONTH_END_STOCK_R          A
             , GT_GPWW_TARGET_ITEM_FOR_ENDING_INV B
             , GT_GPWW_SCM_MST_SITE               C  /* from site */
             , GT_GPWW_SCM_MST_SITE               D  /* to site */
               /* Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , GT_GPWW_SCP_EXC_ITEM_ASSY_MAP      E
               /* End : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
         WHERE B.ITEM_ID            = A.ITEM_ID
           AND C.SITE_TYPE(+)       = 'PLANT'
           AND C.PLANT_ID(+)        = A.PLANT_ID
           AND C.OPERATION_GROUP(+) = B.OPERATION_GROUP
           AND D.SITE_TYPE(+)       = 'PLANT'
           AND D.PLANT_ID(+)        = 'Z'
           AND D.OPERATION_GROUP(+) = B.OPERATION_GROUP
           AND E.COMPANY_ID(+)      = A.COMPANY_ID
           AND E.DIVISION_ID(+)     = A.DIVISION_ID
           AND E.PLANT_ID(+)        = A.PLANT_ID
           AND E.SCP_EXC_ITEM_ID(+) = A.ITEM_ID
           AND A.DIVISION_ID        = V_DIVISION_ID
           AND A.YYYYMM            >= V_INV_FROM_YYYYMM
           AND A.YYYYMM            <= V_INV_TO_YYYYMM
           AND TRIM(A.STORAGE_LOCATION) IS NULL
           AND TRIM(A.STORAGE_DESC) IS NOT NULL  /* E20251029-001009 STORAGE_LOCATION : 공백 , STORAGE_DESC 공백이 아닌경우는 VMI 로 표시. */
           /* AND ISNULL(IV.STORAGE_DESC, '') = '' -- E20251029-001009 기존로직 주석처리 */
         GROUP BY NVL(E.CELL_ASSY_ITEM_ID, A.ITEM_ID)  /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , A.YYYYMM
             , B.OPERATION_ID
             , B.OPERATION_GROUP
             , NVL(C.SCM_SITE_ID, '-')
             , NVL(D.SCM_SITE_ID, '-');


        /* E20251029-001009 STORAGE_LOCATION 공백 STORAGE_DESC 공백은 제품/반제품 구분으로 INTRANSIT / SEME_INTRANSIT 시작 */
        INSERT
          INTO GT_GPWW_ENDING_INV_MM_0
             ( ITEM_ID
             , YYYYMM
             , OPERATION_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , MEASURE
             , QTY )
        SELECT NVL(E.CELL_ASSY_ITEM_ID, A.ITEM_ID)  AS ITEM_ID  /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , A.YYYYMM
             , B.OPERATION_ID
             , B.OPERATION_GROUP
             , NVL(C.SCM_SITE_ID, '-')  AS FROM_SITE
             , NVL(D.SCM_SITE_ID, '-')  AS TO_SITE
             , CASE WHEN B.ITEM_TYPE = '제품'                                         THEN 'INTRANSIT'
                    WHEN B.ITEM_TYPE = '반제품'                                       THEN 'SEMI_INTRANSIT'
                    ELSE 'MISMATCH_INV'
               END AS MEASURE
             , SUM(A.QUANTITY)          AS QTY
          FROM SCP_ANL_MONTH_END_STOCK_R          A
             , GT_GPWW_TARGET_ITEM_FOR_ENDING_INV B
             , GT_GPWW_SCM_MST_SITE               C  /* from site */
             , GT_GPWW_SCM_MST_SITE               D  /* to site */
               /* Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , GT_GPWW_SCP_EXC_ITEM_ASSY_MAP      E
               /* End : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
         WHERE B.ITEM_ID            = A.ITEM_ID
           AND C.SITE_TYPE(+)       = 'PLANT'
           AND C.PLANT_ID(+)        = A.PLANT_ID
           AND C.OPERATION_GROUP(+) = B.OPERATION_GROUP
           AND D.SITE_TYPE(+)       = 'PLANT'
           AND D.PLANT_ID(+)        = 'Z'
           AND D.OPERATION_GROUP(+) = B.OPERATION_GROUP
           AND E.COMPANY_ID(+)      = A.COMPANY_ID
           AND E.DIVISION_ID(+)     = A.DIVISION_ID
           AND E.PLANT_ID(+)        = A.PLANT_ID
           AND E.SCP_EXC_ITEM_ID(+) = A.ITEM_ID
           AND A.DIVISION_ID        = V_DIVISION_ID
           AND A.YYYYMM            >= V_INV_FROM_YYYYMM
           AND A.YYYYMM            <= V_INV_TO_YYYYMM
           AND TRIM(A.STORAGE_LOCATION) IS NULL
           AND TRIM(A.STORAGE_DESC) IS NULL
         GROUP BY NVL(E.CELL_ASSY_ITEM_ID, A.ITEM_ID)  /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , A.YYYYMM
             , B.OPERATION_ID
             , B.OPERATION_GROUP
             , NVL(C.SCM_SITE_ID, '-')
             , NVL(D.SCM_SITE_ID, '-')
             , CASE WHEN B.ITEM_TYPE = '제품'                                         THEN 'INTRANSIT'
                    WHEN B.ITEM_TYPE = '반제품'                                       THEN 'SEMI_INTRANSIT'
                    ELSE 'MISMATCH_INV'
               END;

        /* E20251029-001009 STORAGE_LOCATION 공백 STORAGE_DESC 공백은 제품/반제품 구분으로 INTRANSIT / SEME_INTRANSIT 끝 */

        DELETE FROM GT_GPWW_ENDING_INV_MM_RAW;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : 월별 재고 - 2 - 0채움');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_ENDING_INV_MM;

        INSERT
          INTO GT_GPWW_ENDING_INV_MM
             ( ITEM_ID
             , YYYYMM
             , OPERATION_ID
             , OPERATION_GROUP
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , QTY )
          WITH MM_LIST AS (
               SELECT DISTINCT YYYYMM
                 FROM GT_GPWW_PW_LIST
                WHERE 1=1
                  AND YYYYPW <= V_PLAN_START_YYYYPW   /* 당월 포함 과거 구간만 */
          )
        SELECT A.ITEM_ID
             , B.YYYYMM
             , A.OPERATION_ID
             , A.OPERATION_GROUP
             , A.MEASURE
             , A.FROM_SITE
             , A.TO_SITE
             , SUM(CASE WHEN A.YYYYMM = B.YYYYMM THEN A.QTY ELSE 0.0 END) AS QTY
          FROM GT_GPWW_ENDING_INV_MM_0 A
             , MM_LIST                 B
         WHERE 1=1
         GROUP BY A.ITEM_ID
             , B.YYYYMM
             , A.OPERATION_ID
             , A.OPERATION_GROUP
             , A.MEASURE
             , A.FROM_SITE
             , A.TO_SITE;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : 주별 기초 재고 (전월재고)  ');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_ENDING_INV_MM_WW;

        INSERT
          INTO GT_GPWW_ENDING_INV_MM_WW
             ( YYYYPW
             , PW_TO_YMD
             , YYYYMM
             , YYYYMM_PRVS
             , YYYYPW_SEQ
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , MEASURE
             , YYYYMM_PRVS_QTY )
        SELECT A.YYYYPW
             , A.PW_TO_YMD
             , A.YYYYMM
             , A.YYYYMM_PRVS
             , A.YYYYPW_SEQ
             , A.YYYYMM_FIRST_YMD
             , A.YYYYMM_LAST_YMD
             , B.ITEM_ID
             , B.OPERATION_GROUP
             , B.FROM_SITE
             , B.TO_SITE
             , B.MEASURE
             , SUM(CASE WHEN A.YYYYMM_PRVS = B.YYYYMM THEN B.QTY ELSE 0.0 END)  AS YYYYMM_PRVS_QTY
          FROM GT_GPWW_PW_LIST       A
             , GT_GPWW_ENDING_INV_MM B
         WHERE 1=1
           AND A.YYYYPW < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
         GROUP BY A.YYYYPW
             , A.PW_TO_YMD
             , A.YYYYMM
             , A.YYYYMM_PRVS
             , A.YYYYPW_SEQ
             , A.YYYYMM_FIRST_YMD
             , A.YYYYMM_LAST_YMD
             , B.ITEM_ID
             , B.OPERATION_GROUP
             , B.FROM_SITE
             , B.TO_SITE
             , B.MEASURE;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 AS_IN_PLAN, AS_IN_REQ  ');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        /* 2026.10.22 AS 출하 뷰 시노님·NPP 시퀀스 생성 후 정적 SQL 로 환원 */
        INSERT
          INTO GT_GPWW_ENDING_INV_MM_WW
             ( YYYYPW
             , PW_TO_YMD
             , YYYYMM
             , YYYYMM_PRVS
             , YYYYPW_SEQ
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , MEASURE
             , YYYYMM_PRVS_QTY )
        SELECT B.YYYYPW
             , B.PW_TO_YMD
             , B.YYYYMM
             , B.YYYYMM_PRVS
             , B.YYYYPW_SEQ
             , B.YYYYMM_FIRST_YMD
             , B.YYYYMM_LAST_YMD
             , IA.ITEM_ID
             , D.OPERATION_GROUP
             , NVL(E.SCM_SITE_ID, '-')  AS FROM_SITE
             , NVL(F.SCM_SITE_ID, '-')  AS TO_SITE
             , IB.MEASURE               AS MEASURE
             , SUM(IA.QTY)              AS QTY
          FROM (SELECT G.COMPANY_ID
                     , G.DIVISION_ID
                     , G.SITE_ID
                     , G.PLANT_ID
                     , G.SHIP_YYYYMMDD
                     , G.STORAGE_ID
                     , G.ITEM_ID
                     , G.QTY
                     , H.YYYYPW
                  FROM SCM_AS_SHIP_V_SN  G
                     , GT_GPWW_DATE_INFO H
                 WHERE G.SHIP_YYYYMMDD  = H.YYYYMMDD
                       /* AND DI.YYYYMM     >=  @V_RESULT_FROM_YYYYMMDD */
                       /* AND DI.YYYYMM     <=  @V_HORIZON_END_YYYYMMDD */
                   AND G.DIVISION_ID    = V_DIVISION_ID
                   AND G.SHIP_YYYYMMDD  < V_PLAN_START_YYYYMMDD
                   AND G.QTY           <> 0  /* E20251023-001360 '> 0' 에서 '<> 0' 으로 변경 */
               )                                  IA
             , GT_GPWW_PW_LIST                    B
             , (SELECT 'AS_IN_REQ' AS MEASURE FROM DUAL UNION ALL SELECT 'AS_IN_PLAN' AS MEASURE FROM DUAL
               )                                  IB
             , GT_GPWW_TARGET_ITEM_FOR_ENDING_INV D
             , GT_GPWW_SCM_MST_SITE               E  /* from site */
             , GT_GPWW_SCM_MST_SITE               F  /* to site */
         WHERE IA.YYYYPW            = B.YYYYPW
           AND D.ITEM_ID            = IA.ITEM_ID
           AND E.SITE_TYPE(+)       = 'PLANT'
           AND E.PLANT_ID(+)        = IA.PLANT_ID
           AND E.OPERATION_GROUP(+) = D.OPERATION_GROUP
           AND F.SITE_TYPE(+)       = 'PLANT'
           AND F.PLANT_ID(+)        = 'Z'
           AND F.OPERATION_GROUP(+) = D.OPERATION_GROUP
         GROUP BY B.YYYYPW
             , B.PW_TO_YMD
             , B.YYYYMM
             , B.YYYYMM_PRVS
             , B.YYYYPW_SEQ
             , B.YYYYMM_FIRST_YMD
             , B.YYYYMM_LAST_YMD
             , IA.ITEM_ID
             , D.OPERATION_GROUP
             , NVL(E.SCM_SITE_ID, '-')
             , NVL(F.SCM_SITE_ID, '-')
             , IB.MEASURE;

        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT A.OPERATION_GROUP
             , A.ITEM_ID
             , A.FROM_SITE              AS TO_SITE
             , '-'                      AS INCOTERMS
             , '-'                      AS FROM_SITE
             , '-'                      AS TRANSPORT_MODE_LINE
             , B.YYYYPW                 AS YYYYPW
             , A.MEASURE                AS MEASURE
             , 'N'                      AS IS_CELL_IN_PACK_PLANT
             , 0.0                      AS FROM_BOH_QTY
             , 0.0                      AS TO_BOH_QTY
             , SUM(A.YYYYMM_PRVS_QTY)   AS QTY
          FROM GT_GPWW_ENDING_INV_MM_WW A
             , GT_GPWW_PW_LIST          B
         WHERE B.YYYYPW  = A.YYYYPW
           AND A.MEASURE IN ('AS_IN_REQ', 'AS_IN_PLAN')
           AND B.YYYYPW <= V_PLAN_START_YYYYPW
           AND A.YYYYPW <= V_PLAN_START_YYYYPW
         GROUP BY A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , B.YYYYPW
             , A.MEASURE;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : FP Aging Stock');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_FP_AGING_STOCK;

        INSERT
          INTO GT_GPWW_FP_AGING_STOCK
             ( YYYYPW
             , CUTOFF_DATE
             , FROM_SITE
             , ITEM_ID
             , FP_CHAR_AVAILABLE
             , FP_FORM_PROGRESS
             , FP_AGING_TOTAL
             , DIV )
        SELECT A.YYYYPW
             , B.CUTOFF_DATE
             , C.SCM_SITE_ID                                                    AS FROM_SITE
             , NVL(D.CELL_ASSY_ITEM_ID, B.ITEM_ID)                              AS ITEM_ID      /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , SUM(CASE WHEN B.REMAIN_LEAD_TIME = 0 THEN B.QTY ELSE 0 END)      AS FP_CHAR_AVAILABLE
             , SUM(CASE WHEN B.REMAIN_LEAD_TIME > 0 THEN B.QTY ELSE 0 END)      AS FP_FORM_PROGRESS
             , SUM(B.QTY)                                                       AS FP_AGING_TOTAL
             , 'A'                                                              AS DIV
          FROM GT_GPWW_PW_LIST               A
             , SCM_DNM_STOCK_AGING_SN_V      B  /* [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV FP 활성화 재고를 ESS MI 법인 가상사이트 재고로 치환하여 정보 형성 (SCM_DNM_STOCK_AGING_SN를 SCM_DNM_STOCK_AGING_SN_V로 대체 참조) */
             , GT_GPWW_SCM_MST_SITE          C
               /* Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , GT_GPWW_SCP_EXC_ITEM_ASSY_MAP D
               /* End : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
         WHERE B.CUTOFF_DATE        = A.PW_TO_YMD_NEXT_DAY
           AND C.PLANT_ID           = B.PLANT_ID
           AND D.COMPANY_ID(+)      = B.COMPANY_ID
           AND D.DIVISION_ID(+)     = B.DIVISION_ID
           AND D.PLANT_ID(+)        = B.PLANT_ID
           AND D.SCP_EXC_ITEM_ID(+) = B.ITEM_ID
           AND C.SITE_TYPE          = 'PLANT'
           AND C.OPERATION_GROUP    = 'A'   /* Cell */
           AND B.DIVISION_ID        = V_DIVISION_ID
           AND A.YYYYPW             < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
         GROUP BY A.YYYYPW
             , B.CUTOFF_DATE
             , C.SCM_SITE_ID
             , NVL(D.CELL_ASSY_ITEM_ID, B.ITEM_ID);   /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : FP Aging Stock (현재 없는 기 적재된 데이터)');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_FP_AGING_STOCK
             ( YYYYPW
             , CUTOFF_DATE
             , FROM_SITE
             , ITEM_ID
             , FP_CHAR_AVAILABLE
             , FP_FORM_PROGRESS
             , FP_AGING_TOTAL
             , DIV )
        SELECT A.YYYYPW
             , TO_DATE(A.VARIOUS_KEY, 'YYYYMMDD')            AS CUTOFF_DATE
             , A.FROM_SITE
             , A.ITEM_ID
             , CAST(TO_NUMBER(A.ATTRIBUTE1) AS NUMBER(20,10)) AS FP_CHAR_AAILABLE
             , A.QTY                                          AS FP_FORM_PROGRESS
             , CAST(TO_NUMBER(A.ATTRIBUTE2) AS NUMBER(20,10)) AS FP_AGING_TOTAL
             , 'B'                                            AS DIV
          FROM SCP_RPT_GLOBAL_PSI_MD_WW A
         WHERE 1=1
           AND NOT EXISTS (SELECT 1
                             FROM GT_GPWW_FP_AGING_STOCK SA
                            WHERE 1=1
                              AND SA.YYYYPW     = A.YYYYPW
                              AND SA.FROM_SITE  = A.FROM_SITE
                              AND SA.ITEM_ID    = A.ITEM_ID)
           AND A.PLAN_START_YYYYMMDD = '00000000'
           AND A.MEASURE             = 'FORM_PROGRESS'
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_TYPE           = V_PLAN_TYPE           /* E20260708-000926 */
           AND A.YYYYPW              < V_PLAN_START_YYYYPW;  /* 과거 실적 구간 */

        /* -------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : MKT_FCST/RTF(DM 참조) Measure 추가');
        /* 계획 구간 WH_IN_BLANCE 계산 후 추가함. */
        /* plan 주차 해당월 WH_IN_BALANCE 계산시 적용 안함 - plan date 기준 BOH 및 계획 수량 정보로 계산함 */
        /* -------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_FCST_RTF_RESULT;

        INSERT
          INTO GT_GPWW_FCST_RTF_RESULT
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , YYYYPW
             , MEASURE
             , IS_CEL_INVENTORY
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
          WITH MEASURE_INFO AS (
               SELECT 'MKT_FCST'   AS MEASURE , 'RTF_SYS_RP' AS DM_MEASURE FROM DUAL  /* MKT FCST[R+P] */
               UNION ALL
               SELECT 'RTF'        AS MEASURE , 'RTF_SYS_RP' AS DM_MEASURE FROM DUAL  /* RTF[R+P] */
          )
        SELECT IA.OPERATION_GROUP
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.INCOTERMS
             , '-'              AS FROM_SITE  /* SCP global psi는 to 사이트 기준 데이터임 */
             , IA.TRANSPORT_MODE
             , IA.YYYYPW
             , IA.MEASURE
             , 'N'              AS IS_CEL_INVENTORY
             , 0.0              AS FROM_BOH_QTY
             , 0.0              AS TO_BOH_QTY
             , SUM(IA.QTY)      AS QTY
          FROM (SELECT B.OPERATION_GROUP
                     , B.ITEM_ID
                     , A.SCM_SITE_ID    AS TO_SITE
                     , A.INCOTERMS
                     , A.PROJECT_CODE   AS TRANSPORT_MODE
                     , E.YYYYPW
                       /* ,CASE WHEN MK.FCST_TYPE = 'WS' THEN 'AS_' ELSE '' END + MI.MEASURE AS MEASURE  -- 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경 */
                     , CASE WHEN A.FCST_TYPE IN ( SELECT SA.FCST_TYPE
                                                    FROM GT_GPWW_AS_SALES_TYPE_CODE SA ) THEN 'AS_' ELSE NULL END || C.MEASURE AS MEASURE
                     , A.QTY            AS QTY
                  FROM DM_PLN_MKT_FCST_RESULT_C   A
                     , GT_GPWW_SCP_MST_FINAL_ITEM B
                     , MEASURE_INFO               C
                     , GT_GPWW_SCM_MST_SITE       D
                     , GT_GPWW_DATE_INFO          E
                 WHERE B.ITEM_ID     = A.ITEM_ID
                   AND C.DM_MEASURE  = A.MEASURE
                   AND D.SCM_SITE_ID = A.SCM_SITE_ID
                   AND E.YYYYMMDD    = A.YYYYMMDD
                   AND D.SITE_TYPE   = 'SALES'
                   AND A.QTY        != 0
                   AND A.DIVISION_ID = V_DIVISION_ID
                   AND A.VERSION_NO  = V_DM_VERSION_NO
               ) IA
         GROUP BY IA.OPERATION_GROUP
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.INCOTERMS
             , IA.TRANSPORT_MODE
             , IA.YYYYPW
               /* ,CASE WHEN MK.FCST_TYPE = 'WS' THEN 'AS_' ELSE '' END + MI.MEASURE  -- 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경 */
             , IA.MEASURE;

        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , YYYYPW
             , MEASURE
             , IS_CEL_INVENTORY
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
          FROM GT_GPWW_FCST_RTF_RESULT
         WHERE 1=1;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 생산 실적 Raw Data - 대상 Operation');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_PRODUCTION_OPERATION;

        INSERT
          INTO GT_GPWW_PRODUCTION_OPERATION
             ( OPERATION_ID )
        SELECT IA.OPERATION_ID
          FROM (
                SELECT A.SEGMENT1 AS OPERATION_ID
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
                 WHERE A.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                   AND A.VALID_YN    = 'Y'
                   AND A.SEGMENT4 LIKE '%' || V_DIVISION_ID || '%'
                UNION
                SELECT B.PLANT_ID  /* 외주 Packer 실적 Operation */
                  FROM GT_GPWW_SCM_MST_SITE B
                 WHERE B.SITE_TYPE    = 'PLANT'
                   AND B.OSP_YN       = 'Y'
                   AND B.VALID_YN     = 'Y'
                UNION
                SELECT 'F6000' FROM DUAL  /* 셀 특성 */
               ) IA;


        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 생산 실적 Raw Data');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_PRODUCTION_RESULT;

        INSERT
          INTO GT_GPWW_PRODUCTION_RESULT
             ( FROM_SITE
             , OPERATION_GROUP
             , PLANT_ID
             , ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , PLAN_YYYYMMDD
             , ACTUAL_GOOD_QTY )
        SELECT C.SCM_SITE_ID            AS FROM_SITE
             , B.SCP_OPERATION_GROUP    AS OPERATION_GROUP
             , A.PLANT_ID
             , A.ITEM_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , TO_CHAR(A.PLAN_DATE, 'YYYYMMDD')  AS PLAN_YYYYMMDD
             , A.ACTUAL_GOOD_QTY
          FROM SCM_DNM_DAILY_PRODUCT_RESULT_SN A  /* SCM_DNM_DAILY_PRODUCT_RESULT_SN */
             , SCM_MST_ITEM_SN                 B  /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
             , GT_GPWW_SCM_MST_SITE            C
         WHERE B.COMPANY_ID            = A.COMPANY_ID
           AND B.DIVISION_ID           = A.DIVISION_ID
           AND B.SITE_ID               = A.SITE_ID
           AND B.ITEM_ID               = A.ITEM_ID
           AND C.PLANT_ID(+)           = A.PLANT_ID
           AND C.OPERATION_GROUP(+)    = B.SCP_OPERATION_GROUP
           AND A.OPERATION_ID IN (SELECT SA.OPERATION_ID FROM GT_GPWW_PRODUCTION_OPERATION SA)
           AND NOT EXISTS (
                            SELECT 1
                              FROM GT_GPWW_MODULE_MODEL_INFO SB
                             WHERE 1=1
                               AND SB.PACK_MODULE_ITEM = 'Y'
                               AND SB.MODEL_ID = A.ITEM_ID
                          )
           AND B.SCP_OPERATION_GROUP IS NOT NULL       /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
           AND B.SCP_OPERATION_GROUP IN ('A', 'P')     /* cell/pack만 */
           AND C.SITE_TYPE(+)          = 'PLANT'
           AND C.VALID_YN(+)           = 'Y'
           AND A.PRODUCTION_TYPE  NOT IN ('REWORK', 'PILOT')  /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
           AND A.DIVISION_ID           = V_DIVISION_ID
           AND A.PLAN_DATE            >= V_RESULT_FROM_DATE
           AND A.PLAN_DATE            <  V_PLAN_START_DATE;

        /* P5200 공정 실적 P5500 으로 변경 */
        INSERT
          INTO GT_GPWW_PRODUCTION_RESULT
             ( FROM_SITE
             , OPERATION_GROUP
             , PLANT_ID
             , ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , PLAN_YYYYMMDD
             , ACTUAL_GOOD_QTY )
        SELECT C.SCM_SITE_ID            AS FROM_SITE
             , B.SCP_OPERATION_GROUP    AS OPERATION_GROUP
             , A.PLANT_ID
             , D.MODEL_ID               AS ITEM_ID  /* A.ITEM_ID */
             , 'P5500'                  AS OPERATION_ID
             , A.LINE_ID
             , TO_CHAR(A.PLAN_DATE, 'YYYYMMDD')  AS PLAN_YYYYMMDD
             , A.ACTUAL_GOOD_QTY

          FROM SCM_DNM_DAILY_PRODUCT_RESULT_SN A  /* SCM_DNM_DAILY_PRODUCT_RESULT_SN */
             , SCM_MST_ITEM_SN                 B  /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
             , GT_GPWW_SCM_MST_SITE            C
             , GT_GPWW_MODULE_MODEL_INFO       D
         WHERE B.COMPANY_ID            = A.COMPANY_ID
           AND B.DIVISION_ID           = A.DIVISION_ID
           AND B.SITE_ID               = A.SITE_ID
           AND B.ITEM_ID               = A.ITEM_ID
           AND C.PLANT_ID(+)           = A.PLANT_ID
           AND C.OPERATION_GROUP(+)    = B.SCP_OPERATION_GROUP
           AND D.MODULE_ID             = A.ITEM_ID
           AND B.SCP_OPERATION_GROUP IS NOT NULL       /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
           AND B.SCP_OPERATION_GROUP IN ('P')          /* cell/pack만 */
           AND C.SITE_TYPE(+)          = 'PLANT'
           AND C.VALID_YN(+)           = 'Y'
           AND D.PACK_MODULE_ITEM      = 'Y'
           AND A.PRODUCTION_TYPE  NOT IN ('REWORK', 'PILOT')  /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
           AND A.OPERATION_ID          = 'P5200'
           AND A.DIVISION_ID           = V_DIVISION_ID
           AND A.PLAN_DATE            >= V_RESULT_FROM_DATE
           AND A.PLAN_DATE            <  V_PLAN_START_DATE;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 생산 실적 Measure 추가');
        /* --------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT A.OPERATION_GROUP
             , A.ITEM_ID
             , '-'                      AS TO_SITE
             , '-'                      AS INCOTERMS
             , A.FROM_SITE
             , A.LINE_ID                AS TRANSPORT_MODE_LINE
             , B.YYYYPW
             , 'PRODUCTION'             AS MEASURE
             , 'N'                      AS IS_CELL_IN_PACK_PLANT
             , 0.0                      AS FROM_BOH_QTY
             , 0.0                      AS TO_BOH_QTY
             , SUM(A.ACTUAL_GOOD_QTY)   AS QTY
          FROM GT_GPWW_PRODUCTION_RESULT A
             , GT_GPWW_DATE_INFO         B
         WHERE B.YYYYMMDD      = A.PLAN_YYYYMMDD
           AND A.OPERATION_ID != 'F6000'  /* 셀 특성 제외 */
         GROUP BY A.OPERATION_GROUP
             , A.ITEM_ID
             , A.FROM_SITE
             , A.LINE_ID
             , B.YYYYPW;


        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 생산 실적 Measure 추가 (셀 특성 F6000) ');
        /* --------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT A.OPERATION_GROUP
             , A.ITEM_ID
             , '-'                      AS TO_SITE
             , '-'                      AS INCOTERMS
             , A.FROM_SITE
             , A.LINE_ID                AS TRANSPORT_MODE_LINE
             , B.YYYYPW
             , 'CELL_CHAR_PLAN'         AS MEASURE
             , 'N'                      AS IS_CELL_IN_PACK_PLANT
             , 0.0                      AS FROM_BOH_QTY
             , 0.0                      AS TO_BOH_QTY
             , SUM(A.ACTUAL_GOOD_QTY)   AS QTY
          FROM GT_GPWW_PRODUCTION_RESULT A
             , GT_GPWW_DATE_INFO         B
         WHERE B.YYYYMMDD     = A.PLAN_YYYYMMDD
           AND A.OPERATION_ID = 'F6000'  /* 셀 특성 */
         GROUP BY A.OPERATION_GROUP
             , A.ITEM_ID
             , A.FROM_SITE
             , A.LINE_ID
             , B.YYYYPW;


        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 출하 실적 Raw Data');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SHIPMENT_RESULT;

        DELETE FROM GT_GPWW_SHIPTO_CODE;

        INSERT
          INTO GT_GPWW_SHIPTO_CODE
             ( SHIPTO_CODE )
        SELECT IA.SHIPTO_CODE
          FROM (
                SELECT DISTINCT A.SHIPTO_CODE
                  FROM XIF_ERP_SALES_RESULT_R_SN A
                 WHERE 1=1
                   AND A.ATTRIBUTE1 IN ( SELECT SA.FCST_TYPE
                                           FROM GT_GPWW_AS_SALES_TYPE_CODE SA )  /* 'WS' 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경 */
                   AND A.IFSEQNO = (  /* 가장 최신번호(높은숫자)로 설정필요. 근 2개월 치 들어옴 (G-PSI 재고/실적 업데이트 구간 및 주기 확인필요) */
                                    SELECT MAX(SB.IFSEQNO)
                                      FROM XIF_ERP_SALES_RESULT_R_SN SB
                                     WHERE 1=1
                                       AND SB.ATTRIBUTE1 IN ( SELECT SC.FCST_TYPE
                                                                FROM GT_GPWW_AS_SALES_TYPE_CODE SC )  /* 'WS' 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경 */
                                       AND SB.DIVISION_ID = V_DIVISION_ID  /* 해당 DIVISION 정보 (JV 포함되어야) */
                                   )
                   AND A.DIVISION_ID = V_DIVISION_ID  /* 해당 DIVISION 정보 (JV 포함되어야) */
                UNION ALL
                SELECT 'XXXX' SHIPTO_CODE FROM DUAL
               ) IA
         WHERE 1=1;

        INSERT
          INTO GT_GPWW_SHIPMENT_RESULT
             ( ITEM_ID
             , FROM_SITE
             , TO_SITE
             , TO_SITE_TYPE
             , TO_SITE_OPERATION_GROUP
             , INCOTERMS
             , TRANSPORT_MODE
             , EXFACTORY_YYYYMMDD
             , EXFACTORY_QTY
             , OPERATION_GROUP )
        SELECT A.ITEM_ID
             , NVL(A.FROM_SCM_SITE_ID, '-')  AS FROM_SITE
             , A.TO_SCM_SITE_ID     AS TO_SITE
             , C.SITE_TYPE          AS TO_SITE_TYPE
             , C.OPERATION_GROUP    AS TO_SITE_OPERATION_GROUP
             , A.INCOTERMS
             , A.TRANSPORT_MODE
             , A.EXFACTORY_DATE     AS EXFACTORY_YYYYMMDD
             , A.EXFACTORY_QTY
             , B.OPERATION_GROUP
          FROM SCM_DNM_EXFACTORY_RESULT   A
             , GT_GPWW_SCP_MST_FINAL_ITEM B
             , GT_GPWW_SCM_MST_SITE       C
         WHERE B.ITEM_ID     = A.ITEM_ID
           AND C.SCM_SITE_ID = A.TO_SCM_SITE_ID
             /* AND SR.SSP_TYPE IN  --N국간거래 따른 중복값 제거 (SHIP FG 값통일) */
           AND EXISTS
                            (
                                SELECT 1
                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                 WHERE 1=1
                                   AND SA.LOOKUP_TYPE = 'ERP_SSP_TYPE'
                                   AND SA.VALID_YN ='Y'
                                   /* AND LD.SEGMENT1 = SR.SSP_TYPE */
                                   AND ( SA.SEGMENT1 = A.SSP_TYPE OR A.SSP_TYPE IS NULL )
                            )


        /*  AND SR.SHIPTO_CODE NOT IN --WS 출하 정보 제외 (매출 실적기반으로 하는수 밖에없음) */
           AND NOT EXISTS
                            (
                                SELECT 1
                                  FROM GT_GPWW_SHIPTO_CODE SB
                                 WHERE 1=1
                                   AND SB.SHIPTO_CODE = A.SHIPTO_CODE
                                /*
                                SELECT DISTINCT SHIPTO_CODE
                                FROM XIF_ERP_SALES_RESULT_R_SN SC WITH(NOLOCK)
                                WHERE 1=1
                                AND		SC.DIVISION_ID = @V_DIVISION_ID --해당 DIVISION 정보 (JV 포함되어야)
                                AND		SC.ATTRIBUTE1 = 'WS'
                                AND		SC.IFSEQNO = (	--가장 최신번호(높은숫자)로 설정필요. 근 2개월 치 들어옴 (G-PSI 재고/실적 업데이트 구간 및 주기 확인필요)
                                                    SELECT	MAX(IFSEQNO)
                                                    FROM	XIF_ERP_SALES_RESULT_R_SN WITH(NOLOCK)
                                                    WHERE	1=1
                                                    AND		DIVISION_ID = @V_DIVISION_ID --해당 DIVISION 정보 (JV 포함되어야)
                                                    AND		ATTRIBUTE1 = 'WS'
                                                    )
                                AND SC.SHIPTO_CODE = SR.SHIPTO_CODE
                                */
                            )
           AND A.EXFACTORY_STATUS IN ('D20','D30','D40')
           AND A.EXFACTORY_DATE  >= V_RESULT_FROM_YYYYMMDD
           AND A.EXFACTORY_DATE  <  V_PLAN_START_YYYYMMDD
           AND A.DIVISION_ID      = V_DIVISION_ID;



        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 출하 실적 Measure 추가');
        /* --------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT A.OPERATION_GROUP
             , A.ITEM_ID
             , NVL(A.TO_SITE, '-')          AS TO_SITE
             , NVL(A.INCOTERMS, '-')        AS INCOTERMS
             , A.FROM_SITE
             , NVL(A.TRANSPORT_MODE, '-')   AS TRANSPORT_MODE_LINE
             , B.YYYYPW
             , 'SHIP_PLAN'                  AS MEASURE
             , 'N'                          AS IS_CELL_IN_PACK_PLANT
             , 0.0                          AS FROM_BOH_QTY
             , 0.0                          AS TO_BOH_QTY
             , SUM(A.EXFACTORY_QTY)         AS QTY
          FROM GT_GPWW_SHIPMENT_RESULT A
             , GT_GPWW_DATE_INFO       B
         WHERE B.YYYYMMDD = A.EXFACTORY_YYYYMMDD
         GROUP BY A.OPERATION_GROUP
             , A.ITEM_ID
             , NVL(A.TO_SITE, '-')
             , NVL(A.INCOTERMS, '-')
             , A.FROM_SITE
             , NVL(A.TRANSPORT_MODE, '-')
             , B.YYYYPW;


        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 도착 실적 SEMI (to Plant Site WH In) - Raw데이터');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_WH_IN_SEMI_RESULT;

        INSERT
          INTO GT_GPWW_WH_IN_SEMI_RESULT
             ( DIVISION_ID
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , DOC_POSTING_DATE
             , QTY )
        SELECT IA.DIVISION_ID
             , IA.ITEM_ID
             , B.TO_SCM_SITE_ID     AS TO_SITE
             , IA.INCOTERMS
             , B.FROM_SCM_SITE_ID   AS FROM_SITE
             , IA.DOC_POSTING_DATE
             , IA.QTY
          FROM (
                SELECT A.DIVISION_ID
                     , A.COMPANY_ID_PURCH
                     , CASE WHEN A.COMPANY_ID_SALES = V_COMPANY_SALES THEN V_ESOC  /* NERP 적용여부에 따라 위 코드 살림 */
                            ELSE A.COMPANY_ID_SALES
                       END COMPANY_ID_SALES_CONV
                     , A.PLANT_ID
                     , A.ITEM_ID
                     , A.INCOTERMS
                     , A.DOC_POSTING_DATE
                     , A.VALID_YN
                     , A.MAT_DOC_ID
                     , A.PO_NO
                     , A.PO_ITEM_SEQ
                     , A.ORIGIN_ITEM_ID
                     , MAX(A.QTY) QTY
                  FROM SCM_DNM_INTRANSIT_CO_DETAIL A
                 WHERE 1=1
                   AND A.DOC_TYPE           = 'GR'  /* Good Receipt (입고 정보) */
                   AND A.DIVISION_ID        = V_DIVISION_ID
                   AND A.DOC_POSTING_DATE  >= V_RESULT_FROM_YYYYMMDD
                   AND A.DOC_POSTING_DATE  <  V_PLAN_START_YYYYMMDD
                 GROUP BY A.DIVISION_ID
                     , A.COMPANY_ID_PURCH
                     , CASE WHEN A.COMPANY_ID_SALES = V_COMPANY_SALES THEN V_ESOC  /* NERP 적용여부에 따라 위 코드 살림 */
                            ELSE A.COMPANY_ID_SALES
                       END
                     , A.PLANT_ID
                     , A.ITEM_ID
                     , A.INCOTERMS
                     , A.DOC_POSTING_DATE
                     , A.VALID_YN
                     , A.TRANSPORT_MODE
                     , A.MAT_DOC_ID
                     , A.PO_NO
                     , A.PO_ITEM_SEQ
                     , A.ORIGIN_ITEM_ID
               ) IA
             , SCM_DNM_INTRANSIT_CO_SUMMARY B
             , GT_GPWW_SCM_MST_SITE         C
         WHERE B.DIVISION_ID      = IA.DIVISION_ID
           AND B.COMPANY_ID_PURCH = IA.COMPANY_ID_PURCH
           AND B.COMPANY_ID_SALES = IA.COMPANY_ID_SALES_CONV  /* D.COMPANY_ID_SALES */
           AND B.PO_NO            = IA.PO_NO
           AND B.PO_ITEM_SEQ      = IA.PO_ITEM_SEQ
           AND B.ITEM_ID          = IA.ITEM_ID
           AND B.ORIGIN_ITEM_ID   = IA.ORIGIN_ITEM_ID
           AND C.SCM_SITE_ID      = B.TO_SCM_SITE_ID
           AND C.SITE_TYPE        = 'PLANT';
        /* WHERE 1=1 */
        /*  AND D.DIVISION_ID			= @V_DIVISION_ID */
        /*  AND D.DOC_TYPE			= 'GR'		-- Good Receipt (입고 정보) */
        /*  AND D.DOC_POSTING_DATE   >= @V_RESULT_FROM_YYYYMMDD */
        /*  AND D.DOC_POSTING_DATE   <  @V_PLAN_START_YYYYMMDD */

        INSERT
          INTO GT_GPWW_WH_IN_SEMI_RESULT
             ( DIVISION_ID
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , DOC_POSTING_DATE
             , QTY )
        SELECT IA.DIVISION_ID
             , IA.ITEM_ID
             , 'ESST_CA_WND'        AS TO_SITE
             , IA.INCOTERMS
             , B.FROM_SCM_SITE_ID   AS FROM_SITE
             , IA.DOC_POSTING_DATE
             , IA.QTY
          FROM (
                SELECT A.DIVISION_ID
                     , A.COMPANY_ID_PURCH
                     , CASE WHEN A.COMPANY_ID_SALES = V_COMPANY_SALES THEN V_ESOC  /* NERP 적용여부에 따라 위 코드 살림 */
                            ELSE A.COMPANY_ID_SALES
                       END COMPANY_ID_SALES_CONV
                     , A.PLANT_ID
                     , A.ITEM_ID
                     , A.INCOTERMS
                     , A.DOC_POSTING_DATE
                     , A.VALID_YN
                     , A.MAT_DOC_ID
                     , A.PO_NO
                     , A.PO_ITEM_SEQ
                     , A.ORIGIN_ITEM_ID
                     , MAX(A.QTY) QTY
                  FROM SCM_DNM_INTRANSIT_CO_DETAIL A
                 WHERE 1 = (CASE WHEN V_DIVISION_ID = '81' THEN 1 ELSE 0 END)
                   AND A.DOC_TYPE           = 'GR'  /* Good Receipt (입고 정보) */
                   AND A.ITEM_ID         LIKE 'ACEH1131I-B1%'
                   AND A.DIVISION_ID        = V_DIVISION_ID
                   AND A.DOC_POSTING_DATE  >= V_RESULT_FROM_YYYYMMDD
                   AND A.DOC_POSTING_DATE  <  V_PLAN_START_YYYYMMDD
                 GROUP BY A.DIVISION_ID
                     , A.COMPANY_ID_PURCH
                     , CASE WHEN A.COMPANY_ID_SALES = V_COMPANY_SALES THEN V_ESOC  /* NERP 적용여부에 따라 위 코드 살림 */
                            ELSE A.COMPANY_ID_SALES
                       END
                     , A.PLANT_ID
                     , A.ITEM_ID
                     , A.INCOTERMS
                     , A.DOC_POSTING_DATE
                     , A.VALID_YN
                     , A.TRANSPORT_MODE
                     , A.MAT_DOC_ID
                     , A.PO_NO
                     , A.PO_ITEM_SEQ
                     , A.ORIGIN_ITEM_ID
               ) IA
             , SCM_DNM_INTRANSIT_CO_SUMMARY B
         WHERE B.DIVISION_ID      = IA.DIVISION_ID
           AND B.COMPANY_ID_PURCH = IA.COMPANY_ID_PURCH
           AND B.COMPANY_ID_SALES = IA.COMPANY_ID_SALES_CONV  /* D.COMPANY_ID_SALES */
           AND B.PO_NO            = IA.PO_NO
           AND B.PO_ITEM_SEQ      = IA.PO_ITEM_SEQ
           AND B.ITEM_ID          = IA.ITEM_ID
           AND B.ORIGIN_ITEM_ID   = IA.ORIGIN_ITEM_ID
           AND B.TO_SCM_SITE_ID LIKE 'G82%';

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 도착 실적 SEMI (to Plant Site WH In) measure추가');
        /* --------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT C.OPERATION_GROUP
             , A.ITEM_ID
             , A.TO_SITE
             , A.INCOTERMS
             , A.FROM_SITE
             , '-'          AS TRANSPORT_MODE
             , B.YYYYPW
             , 'WH_IN'      AS MEASURE
             , 'N'          AS IS_CELL_INVENTORY
             , 0.0          AS FROM_BOH_QTY
             , 0.0          AS TO_BOH_QTY
             , SUM(A.QTY)   AS QTY
          FROM GT_GPWW_WH_IN_SEMI_RESULT  A
             , GT_GPWW_DATE_INFO          B
             , GT_GPWW_SCP_MST_FINAL_ITEM C
         WHERE B.YYYYMMDD = A.DOC_POSTING_DATE
           AND C.ITEM_ID  = A.ITEM_ID
         GROUP BY C.OPERATION_GROUP
             , A.ITEM_ID
             , A.TO_SITE
             , A.INCOTERMS
             , A.FROM_SITE
             , B.YYYYPW;


        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 도착 실적 FG (to Sales Site WH In) measure추가');
        /* --------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT A.OPERATION_GROUP
             , A.ITEM_ID
             , A.TO_SITE
             , A.INCOTERMS
             , A.FROM_SITE
             , '-'          AS TRANSPORT_MODE
             , A.YYYYPW
             , 'WH_IN'      AS MEASURE
             , 'N'          AS IS_CELL_INVENTORY
             , 0.0          AS FROM_BOH_QTY
             , 0.0          AS TO_BOH_QTY
             , SUM(A.QTY)   AS QTY
          FROM GT_GPWW_FCST_RTF_RESULT A
             , GT_GPWW_SCM_MST_SITE    B
         WHERE B.SCM_SITE_ID = A.TO_SITE
           AND B.SITE_TYPE   = 'SALES'
           AND A.MEASURE     = 'RTF'
         GROUP BY A.OPERATION_GROUP
             , A.ITEM_ID
             , A.TO_SITE
             , A.INCOTERMS
             , A.FROM_SITE
             , A.YYYYPW;
/* --- End : Ending Inventory (과거 실적 구간 재고) @@@위치 옮김 */
/* --- End : Ending Inventory (과거 실적 구간 재고) @@@위치 옮김 */

        /* ---------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : (SIMUL) Form. End Eta (Prod) Raw 데이터 ');
        /* CELL_PROD_FORM_END : Form. End Eta (Prod) : 생산LT를 적용한 생산 수량 */
        /* ---------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_CELL_PROD_FORM_END_RAW;

        INSERT
          INTO GT_GPWW_CELL_PROD_FORM_END_RAW
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYMMDD_ORG
             , TRANSPORT_MODE_LINE
             , QTY
             , LT_DAY
             , YYYYMMDD )
        SELECT A.OPERATION_GROUP
             , A.ITEM_ID
             , A.FROM_SITE
             , A.YYYYMMDD                                                                   AS YYYYMMDD_ORG
             , A.TRANSPORT_MODE_LINE
             , A.QTY
             , C.LT_DAY
             , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD') + NVL(C.LT_DAY, 0), 'YYYYMMDD')  AS YYYYMMDD
          FROM GT_GPWW_SCP_ANL_PSI_GLOBAL A
             , GT_GPWW_DATE_INFO          B
             , GT_GPWW_SCP_MST_FORMATION  C
         WHERE 1=1
           AND A.YYYYMMDD         = B.YYYYMMDD
           AND C.PLANT_SITE_ID(+) = A.FROM_SITE
           AND C.ITEM_ID(+)       = A.ITEM_ID
           AND C.YYYYPW(+)        = B.YYYYPW
           AND A.MEASURE          = 'PRODUCTION'
           AND A.OPERATION_GROUP  = 'A';


        /* start 기준 이전의 실적수량 포함    -- 고도화 */
        INSERT
          INTO GT_GPWW_CELL_PROD_FORM_END_RAW
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYMMDD_ORG
             , TRANSPORT_MODE_LINE
             , QTY
             , LT_DAY
             , YYYYMMDD )
        SELECT C.SCP_OPERATION_GROUP                                                        AS OPERATION_GROUP
             , A.ITEM_ID
             , D.SCM_SITE_ID                                                                AS FROM_SITE
             , TO_CHAR(A.PLAN_DATE, 'YYYYMMDD')                                             AS YYYYMMDD_ORG
             , A.LINE_ID                                                                    AS TRANSPORT_MODE_LINE
             , A.QTY
             , E.LT_DAY
             , TO_CHAR(TRUNC(A.PLAN_DATE) + NVL(E.LT_DAY, 0), 'YYYYMMDD')                   AS YYYYMMDD
          FROM SCM_DNM_DAILY_PRODUCT_RESULT_SN A /* SCM_DNM_DAILY_PRODUCT_RESULT_SN */
             , GT_GPWW_DATE_INFO               B
             , SCM_MST_ITEM_SN                 C /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
             , GT_GPWW_SCM_MST_SITE            D
             , GT_GPWW_SCP_MST_FORMATION       E
         WHERE 1=1
           AND TO_CHAR(A.PLAN_DATE, 'YYYYMMDD') = B.YYYYMMDD
           AND C.COMPANY_ID                     = A.COMPANY_ID
           AND C.DIVISION_ID                    = A.DIVISION_ID
           AND C.SITE_ID                        = A.SITE_ID
           AND C.ITEM_ID                        = A.ITEM_ID
           AND D.PLANT_ID(+)                    = A.PLANT_ID
           AND D.OPERATION_GROUP(+)             = C.SCP_OPERATION_GROUP
           AND E.PLANT_SITE_ID(+)               = D.SCM_SITE_ID
           AND E.ITEM_ID(+)                     = A.ITEM_ID
           AND E.YYYYPW(+)                      = B.YYYYPW
           AND A.OPERATION_ID IN (SELECT SA.OPERATION_ID
                                    FROM GT_GPWW_PRODUCTION_OPERATION SA)
           AND C.SCP_OPERATION_GROUP IS NOT NULL                                      /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
           AND C.SCP_OPERATION_GROUP IN ('A')                                         /* CELL/PACK만 */
           AND D.SITE_TYPE(+)                   = 'PLANT'
           AND D.VALID_YN(+)                    = 'Y'
           AND A.PRODUCTION_TYPE NOT IN ('REWORK', 'PILOT')                           /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
           AND A.OPERATION_ID                  != 'F6000'                             /* 셀 특성 제외 */
           AND A.DIVISION_ID                    = V_DIVISION_ID
           AND A.PLAN_DATE                     >= TO_DATE(SUBSTR(V_PLAN_START_YYYYMMDD, 1, 6) || '01', 'YYYYMMDD')
           AND A.PLAN_DATE                      < V_PLAN_START_DATE;


        /* ---------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : (SIMUL) Form. End Eta (Prod) Measure 추가 ');
        /* CELL_PROD_FORM_END : Form. End Eta (Prod) : 생산LT를 적용한 생산 수량 */
        /* asis global psi의 production 정보는 빈날짜 0으로 채워진 정보임 */
        /* ---------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_CELL_PROD_FORM_END_LINE;
        DELETE FROM GT_GPWW_CELL_PROD_FORM_END;

        INSERT
          INTO GT_GPWW_CELL_PROD_FORM_END_LINE
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , QTY )
        SELECT A.OPERATION_GROUP
             , A.ITEM_ID
             , A.FROM_SITE
             , A.TRANSPORT_MODE_LINE
             , B.YYYYPW
             , SUM(A.QTY)          AS QTY
          FROM GT_GPWW_CELL_PROD_FORM_END_RAW A
             , GT_GPWW_DATE_INFO              B
         WHERE 1=1
           AND B.YYYYMMDD = A.YYYYMMDD
         GROUP BY
               A.OPERATION_GROUP
             , A.ITEM_ID
             , A.FROM_SITE
             , A.TRANSPORT_MODE_LINE
             , B.YYYYPW;

        /* 데이터 검증시 확인을 위해 measure 추가 (UI 노출 대상아님) */
        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT OPERATION_GROUP
             , ITEM_ID
             , '-'                     AS TO_SITE
             , '-'                     AS INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , 'CELL_PROD_FORM_END'    AS MEASURE
             , 'N'                     AS IS_CELL_IN_PACK_PLANT
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , QTY
          FROM GT_GPWW_CELL_PROD_FORM_END_LINE
         WHERE 1=1;

        /* ----------------------------------------------------------- */
        /* #CELL_PROD_FORM_END for Cell. Available/ Form. Progress */
        /* ----------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_CELL_PROD_FORM_END
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYPW
             , QTY )
        SELECT OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYPW
             , SUM(QTY)            AS QTY
          FROM GT_GPWW_CELL_PROD_FORM_END_LINE
         WHERE 1=1
         GROUP BY
               OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYPW;


        /* ---------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : (SIMUL) Form. End Eta (Past) Daily ');
        /* CELL_FOR_FORM_END : Form. End Eta (Past) : TH_ENG_STOCK_PLAN_SN에서 보류 수량을 포함한 해당일 수량 */
        /* ------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_FOR_FORM_END_DAILY;

        INSERT
          INTO GT_GPWW_FOR_FORM_END_DAILY
             ( FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , QTY )
        SELECT SUBSTR(SITE_ID, 1, INSTR(SITE_ID, '~') - 1)         AS FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , SUM(NVL(QTY, 0))                                     AS QTY
          FROM GT_GPWW_SCP_PLN_TH_ENG_STOCK_PLAN
         WHERE 1 = 1
           AND DESCR LIKE 'FOR%'
         GROUP BY
               SUBSTR(SITE_ID, 1, INSTR(SITE_ID, '~') - 1)
             , ITEM_ID
             , YYYYMMDD;


        /* ---------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : (SIMUL) Form. End Eta (Past) Weekly ');
        /* CELL_FOR_FORM_END : Form. End Eta (Past) : TH_ENG_STOCK_PLAN_SN에서 보류 수량을 포함한 해당일 수량 */
        /* ------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_FOR_FORM_END_WEEKLY;

        INSERT
          INTO GT_GPWW_FOR_FORM_END_WEEKLY
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYPW
             , QTY )
        SELECT B.OPERATION_GROUP
             , A.ITEM_ID
             , A.FROM_SITE
             , C.YYYYPW
             , SUM(A.QTY)          AS QTY
          FROM GT_GPWW_FOR_FORM_END_DAILY  A
             , GT_GPWW_SCP_MST_FINAL_ITEM  B
             , GT_GPWW_DATE_INFO           C
         WHERE 1=1
           AND B.ITEM_ID  = A.ITEM_ID
           AND C.YYYYMMDD = A.YYYYMMDD
         GROUP BY
               B.OPERATION_GROUP
             , A.ITEM_ID
             , A.FROM_SITE
             , C.YYYYPW;


        /* -------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : (SIMUL) Form. End Eta (Past) Weekly - 빈주차 0채움');
        /* CELL_FOR_FORM_END : Form. End Eta (Past) : TH_ENG_STOCK_PLAN_SN에서 보류 수량을 포함한 해당일 수량 */
        /* ----------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_CELL_FOR_FORM_END;

        INSERT
          INTO GT_GPWW_CELL_FOR_FORM_END
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYPW
             , QTY )
        SELECT A.OPERATION_GROUP
             , A.ITEM_ID
             , A.FROM_SITE
             , B.YYYYPW
             , SUM(CASE WHEN A.YYYYPW = B.YYYYPW THEN A.QTY ELSE 0 END) AS QTY
          FROM GT_GPWW_FOR_FORM_END_WEEKLY A
             , GT_GPWW_PW_LIST             B
         WHERE 1=1
           AND B.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
         GROUP BY
               A.OPERATION_GROUP
             , A.ITEM_ID
             , A.FROM_SITE
             , B.YYYYPW;

        /* 데이터 검증시 확인을 위해 measure 추가 (UI 노출 대상아님) */
        /* 빈날짜 채우기 전 (0인 데이터 제외) */
        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT OPERATION_GROUP
             , ITEM_ID
             , '-'                     AS TO_SITE
             , '-'                     AS INCOTERMS
             , FROM_SITE
             , '-'                     AS VARIOUS_KEY
             , YYYYPW
             , 'CELL_FOR_FORM_END'     AS MEASURE
             , 'N'                     AS IS_CELL_IN_PACK_PLANT
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , QTY
          FROM GT_GPWW_FOR_FORM_END_WEEKLY
         WHERE 1=1;


        /* ----------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Char. Plan  measure 추가 (임시) ');
        /* 2023.11.22 추가 요구사항 */
        /*  (Form. End Eta (Past) + Form. End Eta (Prod))*Yield */
        /*  특성 가용한(Char.Available) 재고를 전부 특성 계획을 친다는 조건 */
        /*  Char. Available : Char. Plan에서 다 빼먹었으므로, ‘0’ 될 것으로 판단 */
        /* * 향후 Simulator Char. Plan 저장값이 FN에 확정계획으로 반영될 시 현재 산식기준 (asis global psi activate_completed) 으로 원복 */
        /* ----------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_CELL_CHAR_PLAN_FUTURE;

        INSERT
          INTO GT_GPWW_CELL_CHAR_PLAN_FUTURE
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , VARIOUS_KEY
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
          WITH CELL_CHAR_PLAN_SRC AS (
               /* CELL_FOR_FORM_END : Form. End Eta (Past) */
               SELECT A.OPERATION_GROUP
                    , A.ITEM_ID
                    , A.FROM_SITE
                    , A.YYYYPW
                    , A.QTY
                 FROM GT_GPWW_CELL_FOR_FORM_END A
                WHERE 1=1
                UNION ALL
               /* CELL_PROD_FORM_END : From. End Eta (Prod) */
               SELECT B.OPERATION_GROUP
                    , B.ITEM_ID
                    , B.FROM_SITE
                    , B.YYYYPW
                    , B.QTY
                 FROM GT_GPWW_CELL_PROD_FORM_END B
                WHERE 1=1
               )
        SELECT C.OPERATION_GROUP
             , C.ITEM_ID
             , '-'                     AS TO_SITE
             , '-'                     AS INCOTERMS
             , C.FROM_SITE
             , '-'                     AS VARIOUS_KEY
             , C.YYYYPW
             , 'CELL_CHAR_PLAN'        AS MEASURE
             , 'N'                     AS IS_CELL_IN_PACK_PLANT
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , SUM(C.QTY)
               * CASE WHEN NVL(D.SSP_MODIFY_YIELD, 0) > 0      THEN D.SSP_MODIFY_YIELD
                      WHEN NVL(D.FORMATION_TOTAL_YIELD, 0) > 0 THEN D.FORMATION_TOTAL_YIELD
                      ELSE 1
                 END                   AS QTY
          FROM CELL_CHAR_PLAN_SRC        C
             , GT_GPWW_SCP_MST_FORMATION D
         WHERE 1=1
           AND D.PLANT_SITE_ID(+) = C.FROM_SITE
           AND D.ITEM_ID(+)       = C.ITEM_ID
           AND D.YYYYPW(+)        = C.YYYYPW
         GROUP BY
               C.OPERATION_GROUP
             , C.ITEM_ID
             , C.FROM_SITE
             , C.YYYYPW
             , CASE WHEN NVL(D.SSP_MODIFY_YIELD, 0) > 0      THEN D.SSP_MODIFY_YIELD
                    WHEN NVL(D.FORMATION_TOTAL_YIELD, 0) > 0 THEN D.FORMATION_TOTAL_YIELD
                    ELSE 1
               END;


        /* ---------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Char. Plan  measure 추가 (임시) - insert ');
        /* ---------------------------------------------------------------------------------------------------------- */
        /* INSERT INTO #TMP_ASIS_GLOBAL_PSI */
        /* SELECT * */
        /*  FROM #CELL_CHAR_PLAN_FUTURE */



/* begin : 미래구간 cell inventory (CELL_EOH) */
/* begin : 미래구간 cell inventory (CELL_EOH) */
        /* ----------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Cell Inventory 시뮬레이터 산식 적용 재계산 (임시) ');
        /* 아래와 같이 Char. Plan이 변경됨으로 인해 계획구간 Cell Inventory 산식(시뮬레이터)에 의해 재계산 */
        /* Cell Invnentory = CELL_BOH(Cell BOH) */
        /*                       - CELL_SHIP_PLAN_TOTAL(Cell Ship Plan(Sum)) */
        /*                       + CELL_CHAR_PLAN(Char. Plan) */
        /*                       + CELL_FORM_HOLD_AFTER(After Form. Hold Release) */
        /* 2023.11.22 Char. Plan 에 대한 추가 요구사항 */
        /*  (Form. End Eta (Past) + Form. End Eta (Prod))*Yield */
        /*  특성 가용한(Char.Available) 재고를 전부 특성 계획을 친다는 조건 */
        /*  Char. Available : Char. Plan에서 다 빼먹었으므로, ‘0’ 될 것으로 판단 */
        /* * 향후 Simulator Char. Plan 저장값이 FN에 확정계획으로 반영될 시 현재 산식기준 (asis global psi activate_completed) 으로 원복 */
        /* ----------------------------------------------------------------------------------------------------------------------------------- */

        /* ----------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Cell Inventory 시뮬레이터 산식 적용 재계산 - CELL_BOH ');
        /* ----------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_CELL_BOH_FOR_FUTURE;
		/*
		SELECT ES.ITEM_ID
			  ,SUBSTRING(ES.SITE_ID, 1, CHARINDEX('~',ES.SITE_ID)-1)  AS FROM_SITE
			  ,SUM(ES.QTY) AS QTY 
		 INTO #CELL_BOH_FOR_FUTURE
		 FROM #SCP_PLN_TH_ENG_STOCK_PLAN  ES WITH(NOLOCK)  
			  INNER JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.ITEM_ID = ES.ITEM_ID
					 AND FI.OPERATION_GROUP = 'A'
		WHERE 1=1
		  AND ES.LOT_ID		LIKE 'WH:%'
		  AND ES.SITE_ID	LIKE '%A~%' -- cell 사이트 
		GROUP BY ES.ITEM_ID
				,SUBSTRING(ES.SITE_ID, 1, CHARINDEX('~',ES.SITE_ID)-1)
		*/

        /* @@@ BOH 기준 변경 */
        INSERT
          INTO GT_GPWW_CELL_BOH_FOR_FUTURE
             ( ITEM_ID
             , FROM_SITE
             , QTY )
        SELECT ITEM_ID
             , FROM_SITE               AS FROM_SITE
             , SUM(YYYYMM_PRVS_QTY)    AS QTY
          FROM GT_GPWW_ENDING_INV_MM_WW
         WHERE 1=1
           AND MEASURE         = 'CELL_EOH'
           AND OPERATION_GROUP = 'A'    /* cell 사이트 */
           AND YYYYPW          < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
         GROUP BY ITEM_ID, FROM_SITE
        ;


		/*
		-- 2024.01.18 변경전  
		-----------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 계획 구간 : Cell Inventory 시뮬레이터 산식 적용 재계산 - CELL_FORM_HOLD_AFTER '
		-----------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#CELL_FORM_HOLD_AFTER') IS NOT NULL
			DROP TABLE #CELL_FORM_HOLD_AFTER;

		;WITH CELL_FORM_HOLD_AFTER AS (
			SELECT ES.ITEM_ID
				  ,SUBSTRING(ES.SITE_ID, 1, CHARINDEX('~',ES.SITE_ID)-1)  AS FROM_SITE
				  ,DI.YYYYPW
				  ,SUM(ES.QTY) AS QTY   
			 FROM #SCP_PLN_TH_ENG_STOCK_PLAN  ES WITH(NOLOCK) 
				  INNER JOIN #TMP_DATE_INFO DI WITH(NOLOCK)
						  ON DI.YYYYMMDD = ES.YYYYMMDD
				  INNER JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
						  ON FI.ITEM_ID			= ES.ITEM_ID
						 AND FI.OPERATION_GROUP = 'A'
			WHERE 1=1
			  AND ES.LOT_ID		LIKE 'WH_HOLD%'
			  AND ES.SITE_ID	LIKE '%A~%' -- cell 사이트 
			GROUP BY ES.ITEM_ID
					,SUBSTRING(ES.SITE_ID, 1, CHARINDEX('~',ES.SITE_ID)-1)
					,DI.YYYYPW
		)
		SELECT FH.FROM_SITE
			  ,FH.ITEM_ID
			  ,WL.YYYYPW
			  ,SUM(CASE WHEN FH.YYYYPW = WL.YYYYPW THEN FH.QTY ELSE 0 END) AS QTY 
		 INTO #CELL_FORM_HOLD_AFTER
		 FROM CELL_FORM_HOLD_AFTER FH WITH(NOLOCK)
			  INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					  ON WL.YYYYPW >= @V_PLAN_START_YYYYPW --  미래 구간
		WHERE 1=1
		GROUP BY FH.FROM_SITE
				,FH.ITEM_ID
				,WL.YYYYPW
		*/

        /* ----------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Cell Inventory 시뮬레이터 산식 적용 재계산 - CELL_SHIP_PLAN_TOTAL ');
        /* ----------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_CELL_SHIP_PLAN_TOTAL;

        INSERT
          INTO GT_GPWW_CELL_SHIP_PLAN_TOTAL
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYPW
             , QTY )
        SELECT OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYPW
             , SUM(QTY)            AS QTY
          FROM GT_GPWW_ASIS_GLOBAL_PSI
         WHERE 1=1
           AND MEASURE IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN') /* */
           AND OPERATION_GROUP = 'A'
           AND YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
         GROUP BY
               OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYPW;


        /* ----------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Cell Inventory 시뮬레이터 산식 적용 재계산');
        /* 아래와 같이 Char. Plan이 변경됨으로 인해 계획구간 Cell Inventory 산식(시뮬레이터)에 의해 재계산 */
        /* Cell Invnentory = CELL_BOH(Cell BOH) */
        /*                       - CELL_SHIP_PLAN_TOTAL(Cell Ship Plan(Sum)) */
        /*                       + CELL_CHAR_PLAN(Char. Plan) */
        /*                       + CELL_FORM_HOLD_AFTER(After Form. Hold Release) */
        /* ----------------------------------------------------------------------------------------------------------------------------------- */

        DELETE /* ASIS global psi 셀공장 삭제 */
          FROM GT_GPWW_ASIS_GLOBAL_PSI
         WHERE MEASURE               = 'MODEL_INVENTORY'
           AND OPERATION_GROUP       = 'A'
           AND IS_CELL_IN_PACK_PLANT = 'N';

        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
          WITH CELL_INVENTORY_SRC AS (
               /* CELL_BOH (전구간 기초재고로 사용) */
               SELECT A.FROM_SITE
                    , A.ITEM_ID
                    , B.YYYYPW
                    , SUM(A.QTY) AS BOH_QTY
                    , SUM(A.QTY) AS QTY
                 FROM GT_GPWW_CELL_BOH_FOR_FUTURE A
                    , GT_GPWW_PW_LIST             B
                WHERE 1=1
                  AND B.YYYYPW >= V_PLAN_START_YYYYPW /*  미래 구간 */
                GROUP BY A.FROM_SITE
                       , A.ITEM_ID
                       , B.YYYYPW
                UNION ALL
               /* 2024.01.18 HOLD 재고 가용일과 상관 없이 기초재고로 모두 반영 */
               SELECT C.FROM_SITE
                    , C.ITEM_ID
                    , D.YYYYPW
                    , SUM(C.WH_HOLD_QTY) AS BOH_QTY
                    , SUM(C.WH_HOLD_QTY) AS QTY
                 FROM GT_GPWW_WH_HOLD C
                    , GT_GPWW_PW_LIST D
                WHERE 1=1
                  AND D.YYYYPW >= V_PLAN_START_YYYYPW /*  미래 구간 */
                  AND C.FROM_SITE LIKE '%A'           /* Cell 사이트 / 셀재고 ? */
                GROUP BY C.FROM_SITE
                       , C.ITEM_ID
                       , D.YYYYPW
			/* 2024.01.18 변경전  
			-- CELL_FORM_HOLD_AFTER 
			SELECT FH.FROM_SITE
				  ,FH.ITEM_ID
				  ,FH.YYYYPW
				  ,0	 AS BOH_QTY 
				  ,SUM(FH.QTY) OVER (PARTITION BY FH.FROM_SITE
												, FH.ITEM_ID
										 ORDER BY FH.YYYYPW) AS QTY 
			 FROM #CELL_FORM_HOLD_AFTER FH WITH(NOLOCK) 
			*/
                UNION ALL
               /* CELL_SHIP_PLAN_TOTAL */
               SELECT E.FROM_SITE
                    , E.ITEM_ID
                    , E.YYYYPW
                    , 0                  AS BOH_QTY
                    , (-1) * SUM(E.QTY) OVER (PARTITION BY E.FROM_SITE
                                                         , E.ITEM_ID
                                                  ORDER BY E.YYYYPW) AS QTY
                 FROM GT_GPWW_CELL_SHIP_PLAN_TOTAL E
                UNION ALL
               /* CELL_CHAR_PLAN_FUTURE */
               SELECT F.FROM_SITE
                    , F.ITEM_ID
                    , F.YYYYPW
                    , 0                  AS BOH_QTY
                    , SUM(F.QTY) OVER (PARTITION BY F.FROM_SITE
                                                  , F.ITEM_ID
                                           ORDER BY F.YYYYPW) AS QTY
                 FROM GT_GPWW_CELL_CHAR_PLAN_FUTURE F
               )
        SELECT 'A'                                AS OPERATION_GROUP
             , NVL(I.ITEM_ID_ASSY, G.ITEM_ID)     AS ITEM_ID
             , '-'                                AS TO_SITE
             , '-'                                AS INCOTERMS
             , G.FROM_SITE
             , '-'                                AS VARIOUS_KEY
             , G.YYYYPW
             , 'CELL_EOH'                         AS MEASURE
             , 'N'                                AS IS_CELL_IN_PACK_PLANT
             , SUM(G.BOH_QTY)                     AS FROM_BOH_QTY
             , 0.0                                AS TO_BOH_QTY
             , SUM(G.QTY)                         AS QTY
          FROM CELL_INVENTORY_SRC         G
             , GT_GPWW_SCM_MST_SITE       H
             , GT_GPWW_CELL_PROD_ASSY_MAP I  /* CP를 CA로 치환 적용 20240118 */
         WHERE 1=1
           AND H.SCM_SITE_ID(+)       = G.FROM_SITE
           AND I.PLANT_ID(+)          = H.PLANT_ID
           AND I.ITEM_ID_PROD(+)      = G.ITEM_ID
           AND I.ASSY_PRIORITY_1ST(+) = 1
         GROUP BY G.FROM_SITE
                , NVL(I.ITEM_ID_ASSY, G.ITEM_ID)
                , G.YYYYPW;

/* end : 미래구간 cell inventory (CELL_EOH) */
/* end : 미래구간 cell inventory (CELL_EOH) */


/* Begin : 미래구간 Char. Available (CELL_CHAR_AVAILABLE) */
/* Begin : 미래구간 Char. Available (CELL_CHAR_AVAILABLE) */
        /* -------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Char. Available - Char. Plan  수율 적용 ');
        /* -------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_CELL_CHAR_PLAN_YIELD;

        INSERT
          INTO GT_GPWW_CELL_CHAR_PLAN_YIELD
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYPW
             , QTY
             , YIELD
             , QTY_YIELD )
          WITH CHAR_PLAN AS (
               SELECT OPERATION_GROUP
                    , ITEM_ID
                    , FROM_SITE
                    , YYYYPW
                    , SUM(QTY)    AS QTY
                 /* FROM #TMP_ASIS_GLOBAL_PSI PG WITH(NOLOCK) */
                 FROM GT_GPWW_CELL_CHAR_PLAN_FUTURE
                WHERE 1=1
                  AND MEASURE = 'CELL_CHAR_PLAN'           /* 특성(F6000) 생산계획 -- CELL_CHAR_PLAN */
                  AND YYYYPW >= V_PLAN_START_YYYYPW        /* 미래 계획 구간 */
                GROUP BY
                      OPERATION_GROUP
                    , ITEM_ID
                    , FROM_SITE
                    , YYYYPW
               )
        SELECT A.OPERATION_GROUP
             , A.ITEM_ID
             , A.FROM_SITE
             , A.YYYYPW
             , A.QTY
             , CASE WHEN NVL(B.SSP_MODIFY_YIELD, 0) > 0      THEN B.SSP_MODIFY_YIELD
                    WHEN NVL(B.FORMATION_TOTAL_YIELD, 0) > 0 THEN B.FORMATION_TOTAL_YIELD
                    ELSE 1
               END                     AS YIELD
             , A.QTY / CASE WHEN NVL(B.SSP_MODIFY_YIELD, 0) > 0      THEN B.SSP_MODIFY_YIELD
                            WHEN NVL(B.FORMATION_TOTAL_YIELD, 0) > 0 THEN B.FORMATION_TOTAL_YIELD
                            ELSE 1
                       END             AS QTY_YIELD
          FROM CHAR_PLAN                 A
             , GT_GPWW_SCP_MST_FORMATION B
         WHERE 1=1
           AND B.PLANT_SITE_ID(+) = A.FROM_SITE
           AND B.ITEM_ID(+)       = A.ITEM_ID
           AND B.YYYYPW(+)        = A.YYYYPW;


        /* -------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Char. Available measure 추가 ');
        /* Char. Available = CELL_FOR_FORM_END + CELL_PROD_FORM_END - CELL_CHAR_PLAN / 수율 */
        /* CELL_FOR_FORM_END : Form. End Eta (Past) */
        /* CELL_PROD_FORM_END : From. End Eta (Prod) */
        /* CELL_CHAR_PLAN : Char. Plan */
        /* -------------------------------------------------------------------------------------------------------------------- */

        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
          WITH CHAR_AVAILABE_SRC AS (
               /* CELL_FOR_FORM_END : Form. End Eta (Past) */
			/*
			SELECT FF.OPERATION_GROUP
				  ,FF.ITEM_ID
				  ,FF.FROM_SITE
				  ,FF.YYYYPW
				  ,SUM(FF.QTY) OVER (PARTITION BY FF.ITEM_ID
												 ,FF.FROM_SITE
										 ORDER BY FF.YYYYPW)	AS QTY
			 FROM #CELL_FOR_FORM_END FF
			WHERE 1=1
			*/
               /* @@@ ENDING INVENTORY BOH 사용 아래에서 계산하는게 겹쳐 직접 넣어줌 */
               SELECT A.OPERATION_GROUP                AS OPERATION_GROUP
                    , A.ITEM_ID
                    , A.FROM_SITE                      AS FROM_SITE
                    , C.YYYYPW
                    , CASE WHEN A.YYYYMM_PRVS_QTY >= NVL(B.FP_FORM_PROGRESS, 0)
                           THEN A.YYYYMM_PRVS_QTY -  NVL(B.FP_FORM_PROGRESS, 0)
                           ELSE 0
                      END                              AS QTY
                 FROM GT_GPWW_ENDING_INV_MM_WW A
                    , GT_GPWW_FP_AGING_STOCK   B
                    , GT_GPWW_PW_LIST          C
                WHERE 1=1
                  AND B.YYYYPW(+)    = A.YYYYPW
                  AND B.FROM_SITE(+) = A.FROM_SITE
                  AND B.ITEM_ID(+)   = A.ITEM_ID
                  AND A.MEASURE      = 'CELL_CHAR_AVAILABLE'
                  AND C.YYYYPW      >= V_PLAN_START_YYYYPW   /* 미래 계획 구간 */
                  AND A.YYYYPW       = V_RESULT_LAST_YYYYPW  /* 과거 실적 구간 */
                UNION ALL
               /* CELL_PROD_FORM_END : From. End Eta (Prod) */
               SELECT D.OPERATION_GROUP
                    , D.ITEM_ID
                    , D.FROM_SITE
                    , D.YYYYPW
                    , SUM(D.QTY) OVER (PARTITION BY D.ITEM_ID
                                                  , D.FROM_SITE
                                           ORDER BY D.YYYYPW)  AS QTY
                                           /* select * */
                 FROM GT_GPWW_CELL_PROD_FORM_END D
                WHERE 1=1
                UNION ALL
               /* CELL_CHAR_PLAN : Char. Plan */
               SELECT E.OPERATION_GROUP
                    , E.ITEM_ID
                    , E.FROM_SITE
                    , E.YYYYPW
                    , (-1) * SUM(E.QTY_YIELD) OVER (PARTITION BY E.ITEM_ID
                                                               , E.FROM_SITE
                                                        ORDER BY E.YYYYPW) AS QTY
                 FROM GT_GPWW_CELL_CHAR_PLAN_YIELD E
                WHERE 1=1
               )
        SELECT F.OPERATION_GROUP
             , F.ITEM_ID
             , '-'                     AS TO_SITE
             , '-'                     AS INCOTERMS
             , F.FROM_SITE
             , '-'                     AS VARIOUS_KEY
             , F.YYYYPW
             , 'CELL_CHAR_AVAILABLE'   AS MEASURE
             , 'N'                     AS IS_CELL_IN_PACK_PLANT
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , SUM(F.QTY)              AS QTY
          FROM CHAR_AVAILABE_SRC F
         WHERE 1=1
         GROUP BY
               F.OPERATION_GROUP
             , F.ITEM_ID
             , F.FROM_SITE
             , F.YYYYPW;

/* End : 미래구간 Char. Available (CELL_CHAR_AVAILABLE) */
/* End : 미래구간 Char. Available (CELL_CHAR_AVAILABLE) */



/* Begin : 미래구간 Form. Progress (CELL_FORM_PROGRESS) */
/* Begin : 미래구간 Form. Progress (CELL_FORM_PROGRESS) */
        /* -------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Form. Progress (CELL_FORM_PROGRESS) - 기초 재고');
        /* -------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_FORM_PROGRESS_FROM_BOH;

        INSERT
          INTO GT_GPWW_FORM_PROGRESS_FROM_BOH
             ( ITEM_ID
             , FROM_SITE
             , QTY )
        SELECT ITEM_ID
             , FROM_SITE
             , SUM(QTY) AS QTY
          FROM GT_GPWW_FOR_FORM_END_DAILY
         WHERE 1=1
         GROUP BY ITEM_ID
                , FROM_SITE;


        /* -------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Form. Progress (CELL_FORM_PROGRESS) - CELL_PROD');
        /* -------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_CELL_PROD;

        INSERT
          INTO GT_GPWW_CELL_PROD
             ( ITEM_ID
             , FROM_SITE
             , YYYYPW
             , QTY )
        SELECT ITEM_ID
             , FROM_SITE
             , YYYYPW
             , SUM(QTY)    AS QTY
          FROM GT_GPWW_ASIS_GLOBAL_PSI
         WHERE 1=1
           AND MEASURE         = 'PRODUCTION'
           AND OPERATION_GROUP = 'A'
           AND YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 --   '202346' -- */
         GROUP BY
               ITEM_ID
             , FROM_SITE
             , YYYYPW;  /* 원문 order by 1,2,3,4 : 적재 순서 지정일 뿐 결과 무관하여 제외 */


        /* -------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Form. Progress (CELL_FORM_PROGRESS) - measure 추가');
        /* CELL_FORM_PROGRESS = FROM_BOH_QTY - CELL_FOR_FORM_END - CELL_PROD_FORM_END + CELL_PROD */
        /* FROM_BOH_QTY - eng stock 'FOR' 재고 -- plant start yyyymmdd 기준 기초 재고 */
        /* -------------------------------------------------------------------------------------------------------------------- */

        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
          WITH CELL_FORM_PROGRESS_SRC AS (
               /* FROM_BOH_QTY */
			/* 
			SELECT BH.ITEM_ID
				  ,BH.FROM_SITE
				  ,WL.YYYYPW
				  ,BH.QTY 
			 FROM #FORM_PROGRESS_FROM_BOH BH WITH(NOLOCK)
				  INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
						  ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
			WHERE 1=1
			*/
		/*
			--@@@ ENDING INVENTORY BOH 사용 아래에서 계산하는게 겹쳐 직접 넣어줌
			SELECT  MI.ITEM_ID
				   ,MI.FROM_SITE					AS FROM_SITE
				   ,WL.YYYYPW
				   ,CASE WHEN MI.YYYYMM_PRVS_QTY >= ISNULL(FA.FP_FORM_PROGRESS, 0)
					  	 THEN ISNULL(FA.FP_FORM_PROGRESS, 0)
						 ELSE MI.YYYYMM_PRVS_QTY
					END								AS QTY 
			FROM #TMP_ENDING_INV_MM_WW MI WITH(NOLOCK)
				   LEFT JOIN #FP_AGING_STOCK FA WITH(NOLOCK)
						  ON FA.YYYYPW		= MI.YYYYPW 
						 AND FA.FROM_SITE	= MI.FROM_SITE
						 AND FA.ITEM_ID		= MI.ITEM_ID
					INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
						  ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
			 WHERE 1=1
			   AND MI.MEASURE = 'CELL_CHAR_AVAILABLE'
			   AND MI.YYYYPW  = @V_RESULT_LAST_YYYYPW -- 과거 실적 구간
			UNION ALL 
			-- CELL_FOR_FORM_END : Form. End Eta (Past) 
			SELECT FF.ITEM_ID
				  ,FF.FROM_SITE
				  ,FF.YYYYPW
				  ,(-1) * SUM(FF.QTY) OVER (PARTITION BY FF.ITEM_ID
													    ,FF.FROM_SITE
										      ORDER BY FF.YYYYPW)	AS QTY
			 FROM #CELL_FOR_FORM_END FF
			WHERE 1=1
			UNION ALL
		*/
               /* CELL_PROD_FORM_END : From. End Eta (Prod) */
               SELECT A.ITEM_ID
                    , A.FROM_SITE
                    , A.YYYYPW
                    , (-1) * SUM(A.QTY) OVER (PARTITION BY A.ITEM_ID
                                                         , A.FROM_SITE
                                                  ORDER BY A.YYYYPW)  AS QTY
                 FROM GT_GPWW_CELL_PROD_FORM_END A
                WHERE 1=1
                  AND A.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                UNION ALL
               /* */
               SELECT B.ITEM_ID
                    , B.FROM_SITE
                    , B.YYYYPW
                    , SUM(B.QTY) OVER (PARTITION BY B.ITEM_ID
                                                  , B.FROM_SITE
                                           ORDER BY B.YYYYPW)  AS QTY
                 FROM GT_GPWW_CELL_PROD B
                WHERE 1=1
                  AND B.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
               )
        SELECT 'A'                     AS OPERATION_GROUP
             , C.ITEM_ID
             , '-'                     AS TO_SITE
             , '-'                     AS INCOTERMS
             , C.FROM_SITE
             , '-'                     AS VARIOUS_KEY
             , C.YYYYPW
             , 'CELL_FORM_PROGRESS'    AS MEASURE
             , 'N'                     AS IS_CELL_IN_PACK_PLANT
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , SUM(C.QTY)              AS QTY
          FROM CELL_FORM_PROGRESS_SRC C
         GROUP BY
               C.ITEM_ID
             , C.FROM_SITE
             , C.YYYYPW;

/* END : 미래구간 Form. Progress (CELL_FORM_PROGRESS) */
/* End : 미래구간 Form. Progress (CELL_FORM_PROGRESS) */





        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : (AS) AS in Plan, AS Inv measure 추가');
        /* ---------------------------------------------------------------------------------------------------------------------------- */
        /* ★ DM_PLN_MKT_FCST_C 의 AS measure 실데이터 표기는 AS_In_Req·AS_In_Plan·AS_Inv(혼합 대소문자). */
        /*   원문(MSSQL 대소문자 무시 비교) 의미대로 두 표기를 모두 받고, 적재 값은 대문자로 맞춤(후속 'AS_INV' 등 비교·리포트 표기). */
        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT B.OPERATION_GROUP
             , B.ITEM_ID
             , A.SCM_SITE_ID           AS TO_SITE
             , A.INCOTERMS
             , '-'                     AS FROM_SITE    /* SCP global psi는 to 사이트 기준 데이터임 */
             , A.PROJECT_CODE
             , D.YYYYPW
             , UPPER(A.MEASURE)        AS MEASURE
             , 'N'                     AS IS_CEL_INVENTORY
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , SUM(CASE WHEN UPPER(A.MEASURE) = 'AS_INV' AND D.PW_TO_YMD = A.YYYYMMDD
                        THEN A.QTY
                        WHEN UPPER(A.MEASURE) IN ('AS_IN_REQ', 'AS_IN_PLAN')
                        THEN A.QTY
                        ELSE 0.0
                   END)                AS QTY
          FROM DM_PLN_MKT_FCST_C    A
             , GT_GPWW_SCP_MST_FINAL_ITEM B
             , GT_GPWW_SCM_MST_SITE C
             , GT_GPWW_DATE_INFO    D
         WHERE 1=1
           AND B.ITEM_ID         = A.ITEM_ID
           AND C.SCM_SITE_ID     = A.SCM_SITE_ID
           AND D.YYYYMMDD        = A.YYYYMMDD
           AND A.FCST_TYPE IN (SELECT SA.FCST_TYPE
                                 FROM GT_GPWW_AS_SALES_TYPE_CODE SA)  /* 'WS' 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경 */
           AND C.SITE_TYPE       = 'SALES'
           AND C.OPERATION_GROUP = 'W'    /* to as plant */
           AND A.MEASURE IN ('AS_IN_REQ', 'AS_IN_PLAN', 'AS_INV', 'AS_In_Req', 'AS_In_Plan', 'AS_Inv')
           AND A.DIVISION_ID     = V_DIVISION_ID
           AND A.VERSION_NO      = V_DM_VERSION_NO
         GROUP BY
               B.OPERATION_GROUP
             , B.ITEM_ID
             , A.SCM_SITE_ID
             , A.INCOTERMS
             , A.PROJECT_CODE
             , D.YYYYPW
             , UPPER(A.MEASURE);

		/*
		-- AS_IN_PLAN, AS_IN_REQ 계획 구간 이전 일자 추가
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT II.OPERATION_GROUP
			  ,IV.ITEM_ID
			  ,ISNULL(TS.SCM_SITE_ID, '-')	AS TO_SITE
			  ,'-' AS INCOTERMS
			  ,ISNULL(FS.SCM_SITE_ID, '-')	AS FROM_SITE
			  ,'-' AS PROJECT_CODE
			  ,DI.YYYYPW
			  ,ML.MEASURE AS MEASURE
			  ,'N'	AS IS_CEL_INVENTORY
			  ,0.0	AS FROM_BOH_QTY
			  ,0.0	AS TO_BOH_QTY
			  ,SUM(IV.QTY)	AS QTY
		 FROM SCM_AS_SHIP_V_SN IV WITH(NOLOCK)   
			  INNER JOIN #TMP_DATE_INFO DI
			  		  ON 1=1
			  		 AND IV.SHIP_YYYYMMDD 	= DI.YYYYMMDD
			  INNER JOIN (
			  				SELECT 'AS_IN_REQ' AS MEASURE UNION ALL SELECT 'AS_IN_PLAN' AS MEASURE 
			  			 ) ML
			  		  ON 1=1
		 	  INNER JOIN #TMP_TARGET_ITEM_FOR_ENDING_INV II WITH(NOLOCK)
					  ON II.ITEM_ID = IV.ITEM_ID
			  LEFT  JOIN #SCM_MST_SITE FS WITH(NOLOCK)	-- from site 
					  ON FS.SITE_TYPE		= 'PLANT'
					 AND FS.PLANT_ID		= IV.PLANT_ID
					 AND FS.OPERATION_GROUP	= II.OPERATION_GROUP
			  LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK)	-- to site 
					  ON TS.SITE_TYPE		= 'PLANT'
					 AND TS.PLANT_ID		= 'Z' 
					 AND TS.OPERATION_GROUP = II.OPERATION_GROUP
		WHERE IV.DIVISION_ID =  @V_DIVISION_ID
		  AND IV.SHIP_YYYYMMDD <  @V_PLAN_START_YYYYMMDD
		  AND IV.QTY > 0
		GROUP BY II.OPERATION_GROUP
				,IV.ITEM_ID
				,ISNULL(TS.SCM_SITE_ID, '-')
				,ISNULL(FS.SCM_SITE_ID, '-')
				,DI.YYYYPW
				,ML.MEASURE		
		*/
    /* ---------------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : AS_INVENTORY ');
    /* AS inventory = 전주 + AS in plan - AS RTF */
    /* 고도화 */
    /* ---------------------------------------------------------------------------------------------------------- */

        DELETE
          FROM GT_GPWW_ASIS_GLOBAL_PSI
         WHERE 1=1
           AND MEASURE = 'AS_INV'
           AND YYYYPW  < V_PLAN_START_YYYYPW
        ;

        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
          WITH BASE_DATA AS (
               /* 실적구간 -Char. Available 기초재고(전월말) */
               SELECT A.YYYYPW
                    , A.PW_TO_YMD
                    , A.YYYYMM_LAST_YMD
                    , A.ITEM_ID
                    , A.FROM_SITE
                    , A.OPERATION_GROUP
                    , A.YYYYMM_PRVS_QTY      AS MM_BOH_QTY
                    , B.QTY                  AS MM_EOH_QTY
                    , 0.0                    AS MM_ACC_RTF_QTY
                    , 0.0                    AS MM_ACC_PLAN_QTY
                 FROM GT_GPWW_ENDING_INV_MM_WW A          /* 과거 실적구간 */
                    , GT_GPWW_ENDING_INV_MM    B          /* 당월말 재고 참조 */
                WHERE 1=1
                  AND B.YYYYMM(+)    = A.YYYYMM
                  AND B.ITEM_ID(+)   = A.ITEM_ID
                  AND B.FROM_SITE(+) = A.FROM_SITE
                  AND B.TO_SITE(+)   = A.TO_SITE
                  AND B.MEASURE(+)   = A.MEASURE
                  AND A.MEASURE      = 'AS_INV'
                UNION ALL
               SELECT IA.YYYYPW
                    , IA.PW_TO_YMD
                    , IA.YYYYMM_LAST_YMD
                    , IA.ITEM_ID
                    , IA.FROM_SITE
                    , IA.OPERATION_GROUP
                    , 0.0                    AS MM_BOH_QTY
                    , 0.0                    AS MM_EOH_QTY
                    , IA.MM_ACC_RTF_QTY
                    , IA.MM_ACC_PLAN_QTY
                 FROM (SELECT E.YYYYPW
                            , E.PW_TO_YMD
                            , E.YYYYMM
                            , E.YYYYMM_PRVS
                            , E.YYYYMM_FIRST_YMD
                            , E.YYYYMM_LAST_YMD
                            , C.ITEM_ID
                            , C.OPERATION_GROUP
                            , C.FROM_SITE
                            , 0 AS MM_BOH_QTY
                            , 0 AS MM_EOH_QTY
                            , SUM(CASE WHEN D.YYYYMM = E.YYYYMM AND D.YYYYPW <= E.YYYYPW
                                       THEN C.QTY
                                       ELSE 0.0
                                  END) AS MM_ACC_RTF_QTY
                            , 0 AS MM_ACC_PLAN_QTY
                         FROM GT_GPWW_ASIS_GLOBAL_PSI C
                            , GT_GPWW_PW_LIST         D
                            , GT_GPWW_PW_LIST         E
                        WHERE 1=1
                          AND D.YYYYPW  = C.YYYYPW
                          AND E.YYYYPW  < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
                          AND C.MEASURE = 'AS_RTF'
                          AND C.YYYYPW  < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
                        GROUP BY
                              E.YYYYPW
                            , E.PW_TO_YMD
                            , E.YYYYMM
                            , E.YYYYMM_PRVS
                            , E.YYYYMM_FIRST_YMD
                            , E.YYYYMM_LAST_YMD
                            , C.ITEM_ID
                            , C.OPERATION_GROUP
                            , C.FROM_SITE
                        UNION ALL
                       SELECT H.YYYYPW
                            , H.PW_TO_YMD
                            , H.YYYYMM
                            , H.YYYYMM_PRVS
                            , H.YYYYMM_FIRST_YMD
                            , H.YYYYMM_LAST_YMD
                            , F.ITEM_ID
                            , F.OPERATION_GROUP
                            , F.FROM_SITE
                            , 0 AS MM_BOH_QTY
                            , 0 AS MM_EOH_QTY
                            , 0 AS MM_ACC_RTF_QTY
                            , SUM(CASE WHEN G.YYYYMM = H.YYYYMM AND G.YYYYPW <= H.YYYYPW
                                       THEN F.QTY
                                       ELSE 0.0
                                  END) AS MM_ACC_PLAN_QTY
                         FROM GT_GPWW_ASIS_GLOBAL_PSI F
                            , GT_GPWW_PW_LIST         G
                            , GT_GPWW_PW_LIST         H
                        WHERE 1=1
                          AND G.YYYYPW  = F.YYYYPW
                          AND H.YYYYPW  < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
                          AND F.MEASURE = 'AS_IN_PLAN'
                          AND F.YYYYPW  < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
                        GROUP BY
                              H.YYYYPW
                            , H.PW_TO_YMD
                            , H.YYYYMM
                            , H.YYYYMM_PRVS
                            , H.YYYYMM_FIRST_YMD
                            , H.YYYYMM_LAST_YMD
                            , F.ITEM_ID
                            , F.OPERATION_GROUP
                            , F.FROM_SITE
                      ) IA
                WHERE 1=1

               )
        SELECT IB.OPERATION_GROUP
             , IB.ITEM_ID
             , '-'                     AS TO_SITE
             , '-'                     AS INCOTERMS
             , IB.FROM_SITE
             , '-'                     AS TRANSPORT_MODE_LINE
             , IB.YYYYPW
             , IB.MEASURE
             , 'N'                     AS IS_CELL_IN_PACK_PLANT
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , IB.QTY
          FROM (SELECT I.YYYYPW
                     , I.ITEM_ID
                     , 'AS_INV'    AS MEASURE
                     , I.FROM_SITE
                     , I.OPERATION_GROUP
                     , CASE WHEN I.PW_TO_YMD = I.YYYYMM_LAST_YMD
                            THEN SUM(I.MM_EOH_QTY)
                            ELSE SUM(I.MM_BOH_QTY) + SUM(I.MM_ACC_PLAN_QTY) - SUM(I.MM_ACC_RTF_QTY)
                       END         AS QTY
                  FROM BASE_DATA I
                 WHERE 1=1
                 GROUP BY
                       I.YYYYPW
                     , I.PW_TO_YMD
                     , I.YYYYMM_LAST_YMD
                     , I.ITEM_ID
                     , I.FROM_SITE
                     , I.OPERATION_GROUP
               ) IB
         WHERE 1=1;

	/*
	;WITH BASE_DATA AS (
			SELECT   WI.YYYYPW
					,WI.ITEM_ID
					,WI.OPERATION_GROUP
--					,WI.FROM_SITE 
--					,WI.TO_SITE
--					,WI.INCOTERMS
--					,WI.TRANSPORT_MODE_LINE
--					,WI.IS_CELL_IN_PACK_PLANT
					,SUM(WI.PLAN_QTY) AS PLAN_QTY
					,SUM(WI.PROD_QTY) AS PROD_QTY
			FROM	(
						SELECT	 WL.YYYYPW
								,WI.ITEM_ID
								,WI.OPERATION_GROUP
--								,WI.FROM_SITE 
--								,WI.TO_SITE 
--								,WI.INCOTERMS
--								,WI.TRANSPORT_MODE_LINE
--								,WI.IS_CELL_IN_PACK_PLANT
								,CASE WHEN WL.YYYYPW = WI.YYYYPW THEN WI.QTY ELSE 0 END AS PLAN_QTY 
								, 0 AS PROD_QTY
						FROM #TMP_ASIS_GLOBAL_PSI WI WITH(NOLOCK) 
								INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
										ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
						WHERE 1=1
						  AND WI.MEASURE			= 'AS_RTF'
						  --AND WI.OPERATION_GROUP	= 'P'			 -- 팩출하
						  AND WI.YYYYPW < @V_PLAN_START_YYYYPW  -- 미래 계획 구간
						UNION ALL
						-- 실적구간 - 팩출하
						SELECT	 WL.YYYYPW
								,WI.ITEM_ID
								,WI.OPERATION_GROUP
--								,WI.FROM_SITE 
--								,WI.TO_SITE 
--								,WI.INCOTERMS
--								,WI.TRANSPORT_MODE_LINE
--								,WI.IS_CELL_IN_PACK_PLANT
								,0 AS PLAN_QTY
								,CASE WHEN WL.YYYYPW = WI.YYYYPW THEN WI.QTY ELSE 0 END AS QTY 
						FROM #TMP_ASIS_GLOBAL_PSI WI WITH(NOLOCK) 
								INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
										ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 미래 계획 구간
						WHERE 1=1
						  AND WI.MEASURE = 'AS_IN_PLAN'
						  AND WI.YYYYPW < @V_PLAN_START_YYYYPW  -- 미래 계획 구간
					) WI
			WHERE	1=1
			GROUP BY WI.YYYYPW
					,WI.ITEM_ID
					,WI.OPERATION_GROUP
--					,WI.FROM_SITE 
--					,WI.TO_SITE
--					,WI.INCOTERMS
--					,WI.TRANSPORT_MODE_LINE
--					,WI.IS_CELL_IN_PACK_PLANT
	)
	INSERT INTO #TMP_ASIS_GLOBAL_PSI
	SELECT	 DISTINCT 
			 PG.OPERATION_GROUP
			,PG.ITEM_ID
			,PG.TO_SITE 				AS TO_SITE 
			,PG.INCOTERMS				AS INCOTERMS
			,PG.FROM_SITE				AS FROM_SITE 
			,PG.TRANSPORT_MODE_LINE		AS TRANSPORT_MODE_LINE
			,PG.YYYYPW
			,'AS_INV'			AS MEASURE
			,'N'				AS IS_CELL_IN_PACK_PLANT
			,0.0				AS FROM_BOH_QTY
			,0.0				AS TO_BOH_QTY
			,SUM(PG.ACC_QTY)	OVER (PARTITION BY PG.ITEM_ID
													,PG.OPERATION_GROUP
													,PG.FROM_SITE
										ORDER BY  PG.YYYYPW )		AS QTY		
		FROM (
				SELECT   BD.YYYYPW
						,BD.OPERATION_GROUP
						,BD.ITEM_ID
						,'-' AS TO_SITE 				
						,'-' AS INCOTERMS				
						,'-' AS FROM_SITE				
						,'-' AS TRANSPORT_MODE_LINE	
						,'N' AS IS_CELL_IN_PACK_PLANT
						,ISNULL(CASE WHEN BD.YYYYPW = @V_PLAN_START_YYYYPW THEN ISNULL(SO.BOH,0) + BD.PROD_QTY - BD.PLAN_QTY ELSE 0 + BD.PROD_QTY - BD.PLAN_QTY END,0) AS  ACC_QTY
--						,CASE WHEN BD.YYYYMM = WL.YYYYMM THEN 
--									ISNULL(CASE WHEN BD.YYYYMM = @V_PLAN_START_YYYYMM THEN ISNULL(SO.BOH,0) + BD.PROD_QTY - BD.PLAN_QTY ELSE 0 + BD.PROD_QTY - BD.PLAN_QTY END,0) 
--							  ELSE 0 END ACC_QTY
					FROM BASE_DATA BD
						-- INNER JOIN #TMP_MM_LIST WL WITH(NOLOCK)
						--		ON WL.YYYYMM >=  @V_PLAN_START_YYYYMM  -- 미래 계획 구간
						 LEFT JOIN
						(
								SELECT	 WI.ITEM_ID
										,WI.OPERATION_GROUP
										,WI.FROM_SITE 
										,'-'			AS TO_SITE 
										,SUM(WI.YYYYMM_PRVS_QTY) AS BOH 
								FROM #TMP_ENDING_INV_MM_WW WI WITH(NOLOCK) 
								WHERE 1=1
								AND WI.YYYYPW	= '0000'--@V_RESULT_LAST_YYYYPW
								AND WI.MEASURE	= 'AS_INV'
								GROUP BY WI.ITEM_ID
										,WI.OPERATION_GROUP
										,WI.FROM_SITE 
							) SO
							ON 1=1
							AND BD.ITEM_ID = SO.ITEM_ID
							AND BD.OPERATION_GROUP = SO.OPERATION_GROUP
							--AND BD.FROM_SITE = SO.FROM_SITE
				WHERE 1=1
			) PG
			;

			INSERT INTO #TMP_ASIS_GLOBAL_PSI
			SELECT	 WI.OPERATION_GROUP
					,WI.ITEM_ID
					,'-'				AS TO_SITE 
					,'-'				AS INCOTERMS
					,'-'				AS FROM_SITE 
					,'-'				AS TRANSPORT_MODE_LINE
					,WL.YYYYPW
					,'AS_INV'			AS MEASURE
					,'N'				AS IS_CELL_IN_PACK_PLANT
					,0.0				AS FROM_BOH_QTY
					,0.0				AS TO_BOH_QTY
					,SUM(WI.YYYYMM_PRVS_QTY)		AS QTY 
			FROM #TMP_ENDING_INV_MM_WW WI WITH(NOLOCK) 
				INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
						ON WL.YYYYPW <   @V_PLAN_START_YYYYPW  -- 미래 계획 구간
			WHERE 1=1
			AND WI.YYYYPW	=  '0000'--@V_RESULT_LAST_YYYYPW
			AND WI.MEASURE	= 'AS_INV'
			AND NOT EXISTS (
								SELECT	1
								FROM	#TMP_ASIS_GLOBAL_PSI X 
								WHERE	1=1
								AND		X.MEASURE = 'AS_INV'
								AND		X.ITEM_ID = WI.ITEM_ID
								--AND		X.FROM_SITE = WI.FROM_SITE
								AND		X.OPERATION_GROUP = WI.OPERATION_GROUP
								AND     X.YYYYPW <  @V_PLAN_START_YYYYPW 
						   )
		   GROUP BY WL.YYYYPW
					,WI.ITEM_ID
					--,WI.FROM_SITE 
					,WI.OPERATION_GROUP
			;
	
	-- 월말값은 기말재고로 반영
	UPDATE	A
	SET		A.QTY = B.NEW_MM_QTY
	FROM	#TMP_ASIS_GLOBAL_PSI A
			INNER JOIN (
							SELECT  GP.*, MI.YYYYMM_PRVS_QTY AS NEW_MM_QTY
							FROM	#TMP_ASIS_GLOBAL_PSI GP
									INNER JOIN (
													SELECT	WL.YYYYPW, WL.YYYYMM
													FROM	#TMP_PW_LIST WL
													WHERE	1=1
													AND		WL.PW_TO_YMD = WL.YYYYMM_LAST_YMD
												) WL
											ON	1=1
										   AND	GP.YYYYPW = WL.YYYYPW
									LEFT JOIN #TMP_ENDING_INV_MM_WW MI WITH(NOLOCK)			-- 당월말 재고 참조   
										   ON WL.YYYYMM		= MI.YYYYMM		
										  AND GP.ITEM_ID	= MI.ITEM_ID	
										  AND GP.FROM_SITE	= MI.FROM_SITE
										  AND GP.TO_SITE	= MI.TO_SITE 
										  AND GP.MEASURE	= MI.MEASURE 
							WHERE 1=1
							AND GP.MEASURE = 'AS_INV'
							AND MI.YYYYMM_PRVS_QTY IS NOT NULL
						) B
					ON	1=1
				   AND	A.YYYYPW	=	B.YYYYPW
				   AND	A.ITEM_ID	=	B.ITEM_ID
				   AND	A.MEASURE	=	B.MEASURE
				   AND	A.FROM_SITE	=	B.FROM_SITE
				   AND	A.TO_SITE	=	B.TO_SITE
				   AND	A.OPERATION_GROUP	=	B.OPERATION_GROUP
		WHERE	1=1
		  AND	A.MEASURE = 'AS_INV'
		  AND	A.YYYYPW  <  @V_PLAN_START_YYYYPW 
	
	*/

    /* ---------------------------------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : (AS) MKT_FCST measure 추가');
    /* ---------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT B.OPERATION_GROUP
             , B.ITEM_ID
             , A.SCM_SITE_ID           AS TO_SITE
             , A.INCOTERMS
             , '-'                     AS FROM_SITE    /* SCP global psi는 to 사이트 기준 데이터임 */
             , A.PROJECT_CODE
             , D.YYYYPW
             , 'AS_' || A.MEASURE      AS MEASURE
             , 'N'                     AS IS_CEL_INVENTORY
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , SUM(A.QTY)              AS QTY
          FROM DM_PLN_MKT_FCST_C          A
             , GT_GPWW_SCP_MST_FINAL_ITEM B
             , GT_GPWW_SCM_MST_SITE       C
             , GT_GPWW_DATE_INFO          D
         WHERE 1=1
           AND B.ITEM_ID     = A.ITEM_ID
           AND C.SCM_SITE_ID = A.SCM_SITE_ID
           AND D.YYYYMMDD    = A.YYYYMMDD
           AND A.FCST_TYPE IN (SELECT SA.FCST_TYPE
                                 FROM GT_GPWW_AS_SALES_TYPE_CODE SA)  /* 'WS' 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경 */
           AND C.SITE_TYPE   = 'SALES'
           AND (C.OPERATION_GROUP IS NULL OR C.OPERATION_GROUP <> 'W')   /* 원문 ISNULL(MS.OPERATION_GROUP,'') != 'W' */
           AND A.MEASURE IN ('MKT_FCST', 'RTF')
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VERSION_NO  = V_DM_VERSION_NO
           AND A.YYYYMMDD   >= V_PLAN_START_YYYYMMDD
         GROUP BY
               B.OPERATION_GROUP
             , B.ITEM_ID
             , A.SCM_SITE_ID
             , A.INCOTERMS
             , A.PROJECT_CODE
             , D.YYYYPW
             , 'AS_' || A.MEASURE;

    /* ---------------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : AS_INVENTORY 재계산');
    /* AS inventory = 전주 + AS in plan - AS RTF */
    /* 고도화 */
    /* ---------------------------------------------------------------------------------------------------------- */

        DELETE
          FROM GT_GPWW_ASIS_GLOBAL_PSI
         WHERE 1=1
           AND MEASURE = 'AS_INV'
           AND YYYYPW >= V_PLAN_START_YYYYPW;

        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
          WITH BASE_DATA AS (
               SELECT IA.YYYYPW
                    , IA.ITEM_ID
                    , IA.OPERATION_GROUP
/*                  ,WI.FROM_SITE */
/*                  ,WI.TO_SITE */
/*                  ,WI.INCOTERMS */
/*                  ,WI.TRANSPORT_MODE_LINE */
/*                  ,WI.IS_CELL_IN_PACK_PLANT */
                    , SUM(IA.PLAN_QTY) AS PLAN_QTY
                    , SUM(IA.PROD_QTY) AS PROD_QTY
                 FROM (SELECT B.YYYYPW
                            , A.ITEM_ID
                            , A.OPERATION_GROUP
/*                          ,WI.FROM_SITE */
/*                          ,WI.TO_SITE */
/*                          ,WI.INCOTERMS */
/*                          ,WI.TRANSPORT_MODE_LINE */
/*                          ,WI.IS_CELL_IN_PACK_PLANT */
                            , CASE WHEN B.YYYYPW = A.YYYYPW THEN A.QTY ELSE 0 END AS PLAN_QTY
                            , 0 AS PROD_QTY
                         FROM GT_GPWW_ASIS_GLOBAL_PSI A
                            , GT_GPWW_PW_LIST         B
                        WHERE 1=1
                          AND B.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                          AND A.MEASURE = 'AS_RTF'
                          /* AND WI.OPERATION_GROUP = 'P'            -- 팩출하 */
                          AND A.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                        UNION ALL
                       /* 실적구간 - 팩출하 */
                       SELECT D.YYYYPW
                            , C.ITEM_ID
                            , C.OPERATION_GROUP
/*                          ,WI.FROM_SITE */
/*                          ,WI.TO_SITE */
/*                          ,WI.INCOTERMS */
/*                          ,WI.TRANSPORT_MODE_LINE */
/*                          ,WI.IS_CELL_IN_PACK_PLANT */
                            , 0 AS PLAN_QTY
                            , CASE WHEN D.YYYYPW = C.YYYYPW THEN C.QTY ELSE 0 END AS QTY
                         FROM GT_GPWW_ASIS_GLOBAL_PSI C
                            , GT_GPWW_PW_LIST         D
                        WHERE 1=1
                          AND D.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                          AND C.MEASURE = 'AS_IN_PLAN'
                          AND C.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                      ) IA
                WHERE 1=1
                GROUP BY IA.YYYYPW
                       , IA.ITEM_ID
                       , IA.OPERATION_GROUP
/*                     ,WI.FROM_SITE */
/*                     ,WI.TO_SITE */
/*                     ,WI.INCOTERMS */
/*                     ,WI.TRANSPORT_MODE_LINE */
/*                     ,WI.IS_CELL_IN_PACK_PLANT */
               )
        SELECT DISTINCT
               IB.OPERATION_GROUP
             , IB.ITEM_ID
             , IB.TO_SITE              AS TO_SITE
             , IB.INCOTERMS            AS INCOTERMS
             , IB.FROM_SITE            AS FROM_SITE
             , IB.TRANSPORT_MODE_LINE  AS TRANSPORT_MODE_LINE
             , IB.YYYYPW
             , 'AS_INV'                AS MEASURE
             , 'N'                     AS IS_CELL_IN_PACK_PLANT
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , SUM(IB.ACC_QTY) OVER (PARTITION BY IB.ITEM_ID
                                                , IB.OPERATION_GROUP
                                                , IB.FROM_SITE
                                         ORDER BY IB.YYYYPW)     AS QTY
          FROM (SELECT E.YYYYPW
                     , E.OPERATION_GROUP
                     , E.ITEM_ID
                     , '-' AS TO_SITE
                     , '-' AS INCOTERMS
                     , '-' AS FROM_SITE
                     , '-' AS TRANSPORT_MODE_LINE
                     , 'N' AS IS_CELL_IN_PACK_PLANT
                     , NVL(CASE WHEN E.YYYYPW = V_PLAN_START_YYYYPW THEN NVL(IC.BOH, 0) + E.PROD_QTY - E.PLAN_QTY ELSE 0 + E.PROD_QTY - E.PLAN_QTY END, 0) AS ACC_QTY
/*                   ,CASE WHEN BD.YYYYMM = WL.YYYYMM THEN */
/*                               ISNULL(CASE WHEN BD.YYYYMM = @V_PLAN_START_YYYYMM THEN ISNULL(SO.BOH,0) + BD.PROD_QTY - BD.PLAN_QTY ELSE 0 + BD.PROD_QTY - BD.PLAN_QTY END,0) */
/*                         ELSE 0 END ACC_QTY */
                  FROM BASE_DATA E
                    /* INNER JOIN #TMP_MM_LIST WL WITH(NOLOCK) */
                    /*        ON WL.YYYYMM >=  @V_PLAN_START_YYYYMM  -- 미래 계획 구간 */
                     , (SELECT F.ITEM_ID
                             , F.OPERATION_GROUP
                             , F.FROM_SITE
                             , '-'        AS TO_SITE
                             , SUM(F.QTY) AS BOH
                          FROM GT_GPWW_ASIS_GLOBAL_PSI F
                         WHERE 1=1
                           AND F.MEASURE = 'AS_INV'
                           AND F.YYYYPW  = V_RESULT_LAST_YYYYPW
                         GROUP BY F.ITEM_ID
                                , F.OPERATION_GROUP
                                , F.FROM_SITE
                       ) IC
                 WHERE 1=1
                   AND IC.ITEM_ID(+)         = E.ITEM_ID
                   AND IC.OPERATION_GROUP(+) = E.OPERATION_GROUP
                   /* AND BD.FROM_SITE = SO.FROM_SITE */
               ) IB
        ;

        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT A.OPERATION_GROUP
             , A.ITEM_ID
             , '-'                     AS TO_SITE
             , '-'                     AS INCOTERMS
             , '-'                     AS FROM_SITE
             , '-'                     AS TRANSPORT_MODE_LINE
             , B.YYYYPW
             , 'AS_INV'                AS MEASURE
             , 'N'                     AS IS_CELL_IN_PACK_PLANT
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , SUM(A.QTY)              AS QTY
          FROM GT_GPWW_ASIS_GLOBAL_PSI A
             , GT_GPWW_PW_LIST         B
         WHERE 1=1
           AND NOT EXISTS (SELECT 1
                             FROM GT_GPWW_ASIS_GLOBAL_PSI SA
                            WHERE 1=1
                              AND SA.ITEM_ID         = A.ITEM_ID
                              /* AND        X.FROM_SITE = WI.FROM_SITE */
                              AND SA.OPERATION_GROUP = A.OPERATION_GROUP
                              AND SA.MEASURE         = 'AS_INV'
                              AND SA.YYYYPW         >= V_PLAN_START_YYYYPW
                          )
           AND A.MEASURE = 'AS_INV'
           AND B.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
           AND A.YYYYPW  = V_RESULT_LAST_YYYYPW
         GROUP BY B.YYYYPW
                , A.ITEM_ID
                /* ,WI.FROM_SITE */
                , A.OPERATION_GROUP;



        /* ----------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : SCP 출하 계획 참조 Measure (MKT_FCST/RTF) ');
        /* SCP_ANL_SHIPMENT_PLAN_FG 최근 한달 데이터?까지만 참조 가능 (주기적으로 삭제됨), */
        /* ----------------------------------------------------------------------------------------------------------------- */
        /* E20260422-001155 GLOBAL PSI NEW - PLAN (MKT FCST & RTF) 기준 TABLE 변경 / 프로시져 특정시간에 작동 문의 관련 주석처리 시작 */
		/*
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT SP.BIZ_TYPE		AS OPERATION_GROUP
			  ,SP.ITEM_ID
			  ,SP.TO_SITE
			  ,SP.INCOTERMS
			  ,'-'				AS FROM_SITE
			  ,SP.PROJECT_CODE	AS TRANSPORT_MODE_LINE
			  ,DI.YYYYPW
			  ,CASE WHEN SP.MEASURE = 'ALLOCATION' THEN 'RTF' ELSE SP.MEASURE END AS MEASURE
			  ,'N'				AS IS_CELL_IN_PACK_PLANT
			  ,0.0				AS FROM_BOH_QTY
			  ,0.0				AS TO_BOH_QTY
			  ,SUM(SP.QTY)		AS QTY
		 FROM SCP_ANL_SHIPMENT_PLAN_FG SP with(nolock)
			  INNER JOIN #TMP_DATE_INFO DI WITH(NOLOCK)
					  ON DI.YYYYMMDD = SP.YYYYMMDD 
			  LEFT  JOIN #SCM_MST_SITE TS
					  ON TS.SCM_SITE_ID		= SP.TO_SITE
		WHERE 1=1
		  AND SP.DIVISION_ID			= @V_DIVISION_ID
		  AND SP.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
		  AND SP.PLAN_TYPE				= @V_PLAN_TYPE
		  AND SP.SEQ					= @V_PLAN_SEQ
		  AND SP.MEASURE IN ('MKT_FCST', 'ALLOCATION')	-- MKT_FCST / RTF 
		  AND ISNULL(SP.PROJECT_CODE, '-')  != '-'
		 AND ISNULL(TS.OPERATION_GROUP,'')	!= 'W'	-- AS Sales Site 제외 (AS in Req / As in Plan 제외) 
		GROUP BY SP.BIZ_TYPE	
				,SP.ITEM_ID
				,SP.TO_SITE
				,SP.INCOTERMS
				,SP.PROJECT_CODE
				,DI.YYYYPW
			    ,CASE WHEN SP.MEASURE = 'ALLOCATION' THEN 'RTF' ELSE SP.MEASURE END
		*/

        /* E20260422-001155 GLOBAL PSI NEW - PLAN (MKT FCST & RTF) 기준 TABLE 변경 / 프로시져 특정시간에 작동 문의 관련 신규로직 시작 */
        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT B.OPERATION_GROUP
             , B.ITEM_ID
             , A.SCM_SITE_ID           AS TO_SITE
             , A.INCOTERMS
             , '-'                     AS FROM_SITE    /* SCP global psi는 to 사이트 기준 데이터임 */
             , A.PROJECT_CODE
             , D.YYYYPW
             , CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN 'RTF' ELSE A.MEASURE END AS MEASURE
             , 'N'                     AS IS_CEL_INVENTORY
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , SUM(A.QTY)              AS QTY
          FROM DM_PLN_MKT_FCST_C          A
             , GT_GPWW_SCP_MST_FINAL_ITEM B
             , GT_GPWW_SCM_MST_SITE       C
             , GT_GPWW_DATE_INFO          D
         WHERE 1=1
           AND B.ITEM_ID     = A.ITEM_ID
           AND C.SCM_SITE_ID = A.SCM_SITE_ID
           AND D.YYYYMMDD    = A.YYYYMMDD
           AND A.FCST_TYPE NOT IN (SELECT SA.FCST_TYPE
                                     FROM GT_GPWW_AS_SALES_TYPE_CODE SA)  /* 'WS' 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경 */
           AND C.SITE_TYPE   = 'SALES'
           AND (C.OPERATION_GROUP IS NULL OR C.OPERATION_GROUP <> 'W')   /* 원문 ISNULL(MS.OPERATION_GROUP,'') != 'W' */
           AND A.MEASURE IN ('MKT_FCST', 'RTF_SYS_RP')
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VERSION_NO  = V_DM_VERSION_NO
           AND A.YYYYMMDD   >= V_PLAN_START_YYYYMMDD
         GROUP BY
               B.OPERATION_GROUP
             , B.ITEM_ID
             , A.SCM_SITE_ID
             , A.INCOTERMS
             , A.PROJECT_CODE
             , D.YYYYPW
             , A.MEASURE;
        /* E20260422-001155 GLOBAL PSI NEW - PLAN (MKT FCST & RTF) 기준 TABLE 변경 / 프로시져 특정시간에 작동 문의 관련 신규로직 끝 */

        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : TO_SITE_EOH(WH_IN_BALANCE) 계산 위한 Sales Site 입고 및 RTF');
        /* TO_SITE_EOH = plant date 기준 기초재고 + (누적)WH In - (누적)RTF */
        /* plan date 기준 기초재고를 참조하기 때문에 당월의 경우 실적이 반영안된 계획 구간의 RTF만 참조되도록 함 */
        /* RTF 실적구간은 계획 구간 TO_SITE_EOH 산정 후 추가함. */
        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SALES_SITE_BOH;

        INSERT
          INTO GT_GPWW_SALES_SITE_BOH
             ( SITE_ID
             , ITEM_ID
             , BOH_QTY )
        SELECT A.SITE_ID
             , A.ITEM_ID
             , A.PSI_BOH_QTY        AS BOH_QTY
          FROM SCP_PLN_SALES_ONHAND_V A
             , GT_GPWW_SCM_MST_SITE B
         WHERE B.SCM_SITE_ID          = A.SITE_ID
           AND 1 = 1
           AND B.SITE_TYPE            = 'SALES'
           AND (B.OPERATION_GROUP IS NULL OR B.OPERATION_GROUP <> 'W')  /* AS 사이트 제외 */
           AND A.DIVISION_ID          = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE            = V_PLAN_TYPE
           AND A.SEQ                  = V_PLAN_SEQ
           AND A.YYYYMMDD             = V_PLAN_START_YYYYMMDD;


        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : TO_SITE_EOH(WH_IN_BALANCE) 계산 위한 Sales Site 입고 및 RTF');
        /* TO_SITE_EOH = plant date 기준 기초재고 + (누적)WH In - (누적)RTF */
        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_WH_IN_RTF;

        INSERT
          INTO GT_GPWW_WH_IN_RTF
             ( ITEM_ID
             , OPERATION_GROUP
             , TO_SITE
             , INCOTERMS
             , YYYYPW
             , WH_IN
             , WH_IN_ACC
             , RTF
             , RTF_ACC )
        SELECT A.ITEM_ID
             , A.OPERATION_GROUP
             , A.TO_SITE
             , A.INCOTERMS
             , A.YYYYPW
             , SUM(CASE WHEN A.MEASURE = 'WH_IN' THEN A.QTY ELSE 0.0 END)                AS WH_IN
             , SUM(SUM(CASE WHEN A.MEASURE = 'WH_IN' THEN A.QTY ELSE 0.0 END))
                   OVER (PARTITION BY A.ITEM_ID
                                    , A.OPERATION_GROUP
                                    , A.TO_SITE
                                    , A.INCOTERMS
                             ORDER BY A.YYYYPW)                                           AS WH_IN_ACC
             , SUM(CASE WHEN A.MEASURE = 'RTF' THEN A.QTY ELSE 0.0 END)                  AS RTF
             , SUM(SUM(CASE WHEN A.MEASURE = 'RTF' THEN A.QTY ELSE 0.0 END))
                   OVER (PARTITION BY A.ITEM_ID
                                    , A.OPERATION_GROUP
                                    , A.TO_SITE
                                    , A.INCOTERMS
                             ORDER BY A.YYYYPW)                                           AS RTF_ACC
          FROM GT_GPWW_ASIS_GLOBAL_PSI A
             , GT_GPWW_SCM_MST_SITE    B
         WHERE B.SCM_SITE_ID = A.TO_SITE
           AND 1 = 1
           AND B.SITE_TYPE   = 'SALES'
           AND (B.OPERATION_GROUP IS NULL OR B.OPERATION_GROUP <> 'W')  /* AS 사이트 제외 */
           AND A.MEASURE IN ('RTF', 'WH_IN')
         GROUP BY A.OPERATION_GROUP
                , A.ITEM_ID
                , A.TO_SITE
                , A.INCOTERMS
                , A.YYYYPW;

        /* 'ESST_CA_WND' 은 VMI Inventory 에 포함하지 않는다. */
        DELETE
          FROM GT_GPWW_WH_IN_RTF
         WHERE 1 = (CASE WHEN V_DIVISION_ID = '81' THEN 1 ELSE 0 END)
           AND TO_SITE = 'ESST_CA_WND'
           AND ITEM_ID LIKE 'ACEH1131I-B1%';

        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : TO_SITE_EOH (WH_IN_BALANCE) VMI Inventory Measure 추가');
        /* ---------------------------------------------------------------------------------------------------------------------------- */
		/*
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT WR.OPERATION_GROUP
			  ,WR.ITEM_ID
			  ,WR.TO_SITE
			  ,WR.INCOTERMS
			  ,'-'				AS FROM_SITE
			  ,'-'				AS TRANSPORT_MODE_LINE
			  ,WR.YYYYPW
			  ,'TO_SITE_EOH'	AS MEASURE
			  ,'N'				AS IS_CELL_IN_PACK_PLANT
			  ,0.0													AS FROM_BOH_QTY
			  ,ISNULL(SB.BOH_QTY,0.0)								AS TO_BOH_QTY
			  ,ISNULL(SB.BOH_QTY,0.0) + WR.WH_IN_ACC - WR.RTF_ACC	AS QTY
		  FROM #WH_IN_RTF WR WITH(NOLOCK)
			   LEFT JOIN #SALES_SITE_BOH SB WITH(NOLOCK)
					  ON SB.ITEM_ID = WR.ITEM_ID
					 AND SB.SITE_ID = WR.TO_SITE
		WHERE 1=1
		*/
        /* @@@ BOH 기준 변경 */
        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT IA.OPERATION_GROUP
             , IA.ITEM_ID
             , IA.TO_SITE
             , IA.INCOTERMS
             , '-'                AS FROM_SITE
             , '-'                AS TRANSPORT_MODE_LINE
             , IA.YYYYPW
             , 'TO_SITE_EOH'      AS MEASURE
             , 'N'                AS IS_CELL_IN_PACK_PLANT
             , 0.0                AS FROM_BOH_QTY
             , 0.0                AS TO_BOH_QTY
             , SUM(IA.ACC_QTY)
                   OVER (PARTITION BY IA.ITEM_ID
                                    , IA.OPERATION_GROUP
                                    , IA.TO_SITE
                                    , IA.INCOTERMS
                             ORDER BY IA.YYYYPW)  AS QTY
          FROM (SELECT IB.ITEM_ID
                     , IB.OPERATION_GROUP
                     , IB.TO_SITE
                     , IB.INCOTERMS
                     , B.YYYYPW
                     , SUM(CASE WHEN IB.YYYYPW = B.YYYYPW THEN
                                     NVL(CASE WHEN IB.YYYYPW = V_PLAN_START_YYYYPW THEN NVL(IC.QTY, 0) + IB.WH_IN - IB.RTF ELSE 0 + IB.WH_IN - IB.RTF END, 0)
                                ELSE 0 END) AS ACC_QTY
                  FROM (SELECT A.ITEM_ID
                             , A.OPERATION_GROUP
                             , A.TO_SITE
                             , A.INCOTERMS
                             , A.YYYYPW
                             , A.WH_IN
                             , A.WH_IN_ACC
                             , A.RTF
                             , A.RTF_ACC
                             , RANK() OVER (PARTITION BY A.ITEM_ID
                                                ORDER BY A.YYYYPW NULLS FIRST, UPPER(TRANSLATE(A.TO_SITE, '_-', '/')) DESC NULLS LAST, A.TO_SITE DESC NULLS LAST, UPPER(TRANSLATE(A.INCOTERMS, '_-', '/')) NULLS FIRST, A.INCOTERMS NULLS FIRST) AS IDX  /* '-' 정보를 뒤로 주기 위해서 */ /* MSSQL Latin1_General_CI_AS 비교 재현(대소문자·하이픈 무시, 밑줄은 글자·숫자 앞) */
                          FROM GT_GPWW_WH_IN_RTF A
                         WHERE 1 = 1
                           AND A.YYYYPW >= V_PLAN_START_YYYYPW
                       ) IB
                     , GT_GPWW_PW_LIST B
                     , (SELECT C.ITEM_ID
                             , C.OPERATION_GROUP
                             , SUM(C.YYYYMM_PRVS_QTY) AS QTY
                          FROM GT_GPWW_ENDING_INV_MM_WW C
                         WHERE 1 = 1
                           AND C.YYYYPW  = V_RESULT_LAST_YYYYPW
                           AND C.MEASURE = 'TO_SITE_EOH'
                         GROUP BY C.ITEM_ID
                                , C.OPERATION_GROUP
                       ) IC
                 WHERE IC.ITEM_ID(+)         = CASE WHEN IB.IDX = 1 THEN IB.ITEM_ID END  /* 원문 ON 절 PG.IDX = 1 (좌측 조건) */
                   AND IC.OPERATION_GROUP(+) = IB.OPERATION_GROUP
                   AND 1 = 1
                   AND B.YYYYPW >= V_PLAN_START_YYYYPW
                 GROUP BY IB.ITEM_ID
                        , IB.OPERATION_GROUP
                        , IB.TO_SITE
                        , IB.INCOTERMS
                        , B.YYYYPW
               ) IA;

            /* @@@ 미래계획 기준이 없을 경우 넣어준다. */
        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT A.OPERATION_GROUP
             , A.ITEM_ID
             , A.FROM_SITE              AS TO_SITE
             , '-'                      AS INCOTERMS
             , '-'                      AS FROM_SITE
             , '-'                      AS TRANSPORT_MODE_LINE
             , B.YYYYPW                 AS YYYYPW
             , 'TO_SITE_EOH'            AS MEASURE
             , 'N'                      AS IS_CELL_IN_PACK_PLANT
             , 0.0                      AS FROM_BOH_QTY
             , 0.0                      AS TO_BOH_QTY
             , SUM(A.YYYYMM_PRVS_QTY)   AS QTY
          FROM GT_GPWW_ENDING_INV_MM_WW A
             , GT_GPWW_PW_LIST          B
         WHERE NOT EXISTS (SELECT 1
                             FROM GT_GPWW_ASIS_GLOBAL_PSI SA
                            WHERE 1 = 1
                              AND SA.MEASURE         = A.MEASURE
                              AND SA.ITEM_ID         = A.ITEM_ID
                              AND SA.OPERATION_GROUP = A.OPERATION_GROUP
                              AND SA.YYYYPW >= V_PLAN_START_YYYYPW)
           AND 1 = 1
           AND A.MEASURE  = 'TO_SITE_EOH'
           AND B.YYYYPW  >= V_PLAN_START_YYYYPW
           AND A.YYYYPW   = V_RESULT_LAST_YYYYPW
         GROUP BY A.ITEM_ID
                , A.OPERATION_GROUP
                , A.FROM_SITE
                , B.YYYYPW;





        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available');
        /* 전주 재고(Char. Available)  + 금주생산(Production(PKG)) -  금주 특성 생산 실적 (Char.Plan) / 활성화특성수율 */
        /* 전월말 재고를 기초로 하여 해당월 도착/생산 월누적 정보를 적용하여 계산 */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available - 셀 생산실적');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_CELL_PROD_FOR_CHAR_AVAILABLE;
		/*
		-- 실적구간 - 셀 생산실적 (from site) 
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_CELL_PROD_QTY 
		 INTO #CELL_PROD_FOR_CHAR_AVAILABLE
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE	= 'CELL_PROD'
		  AND WI.YYYYPW		<   @V_PLAN_START_YYYYPW	-- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
		*/
        /* 계산식을 위로 올려서 #TMP_ASIS_GLOBAL_PSI 로 변경함 */
        INSERT
          INTO GT_GPWW_CELL_PROD_FOR_CHAR_AVAILABLE
             ( YYYYPW
             , PW_TO_YMD
             , YYYYMM
             , YYYYMM_PRVS
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , MM_ACC_CELL_PROD_QTY )
        SELECT C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM
             , C.YYYYMM_PRVS
             , C.YYYYMM_FIRST_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , SUM(CASE WHEN B.YYYYMM = C.YYYYMM AND B.YYYYPW <= C.YYYYPW
                        THEN A.QTY
                        ELSE 0.0
                   END)  AS MM_ACC_CELL_PROD_QTY
          FROM GT_GPWW_ASIS_GLOBAL_PSI A
             , GT_GPWW_PW_LIST         B
             , GT_GPWW_PW_LIST         C
         WHERE B.YYYYPW          = A.YYYYPW
           AND 1 = 1
           AND A.MEASURE         = 'PRODUCTION'
           AND A.OPERATION_GROUP = 'A'
           AND C.YYYYPW          < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
           AND A.YYYYPW          < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
         GROUP BY C.YYYYPW
                , C.PW_TO_YMD
                , C.YYYYMM
                , C.YYYYMM_PRVS
                , C.YYYYMM_FIRST_YMD
                , C.YYYYMM_LAST_YMD
                , A.ITEM_ID
                , A.OPERATION_GROUP
                , A.FROM_SITE;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available - 셀 특성 실적(투입기준)');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_CELL_CHAR_FOR_CHAR_AVAILABLE;

		/*
		-- 실적구간 - 셀 특성 실적 / 활성화특성수율  
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	/ CASE WHEN CY.CHAR_YIELD > 0 
							   THEN CY.CHAR_YIELD
							   ELSE 1
						  END   AS MM_ACC_CELL_CHAR_QTY 
		 INTO #CELL_CHAR_FOR_CHAR_AVAILABLE  
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 LEFT  JOIN #SCP_MST_FORMATION CY WITH(NOLOCK)
					 ON CY.PLANT_SITE_ID	= WI.FROM_SITE
					AND CY.ITEM_ID			= WI.ITEM_ID
					AND CY.YYYYPW			= WI.YYYYPW
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE	= 'CELL_CHAR_PLAN'			-- 셀 특성 실적 (활성화특성수율 역적용) 
		  AND WI.YYYYPW		<   @V_PLAN_START_YYYYPW	-- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,CASE WHEN CY.CHAR_YIELD > 0 
					THEN CY.CHAR_YIELD
					ELSE 1
				END
		*/
        /* 계산식을 위로 올려서 #TMP_ASIS_GLOBAL_PSI 로 변경함 */
        /* 실적구간 - 셀 특성 실적 / 활성화특성수율 */
        INSERT
          INTO GT_GPWW_CELL_CHAR_FOR_CHAR_AVAILABLE
             ( YYYYPW
             , PW_TO_YMD
             , YYYYMM
             , YYYYMM_PRVS
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , MM_ACC_CELL_CHAR_QTY )
        SELECT D.YYYYPW
             , D.PW_TO_YMD
             , D.YYYYMM
             , D.YYYYMM_PRVS
             , D.YYYYMM_FIRST_YMD
             , D.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , SUM(CASE WHEN B.YYYYMM = D.YYYYMM AND B.YYYYPW <= D.YYYYPW
                        THEN A.QTY
                        ELSE 0.0
                   END) / CASE WHEN C.CHAR_YIELD > 0
                               THEN C.CHAR_YIELD
                               ELSE 1
                          END  AS MM_ACC_CELL_CHAR_QTY
          FROM GT_GPWW_ASIS_GLOBAL_PSI   A
             , GT_GPWW_PW_LIST           B
             , GT_GPWW_SCP_MST_FORMATION C
             , GT_GPWW_PW_LIST           D
         WHERE B.YYYYPW           = A.YYYYPW
           AND C.PLANT_SITE_ID(+) = A.FROM_SITE
           AND C.ITEM_ID(+)       = A.ITEM_ID
           AND C.YYYYPW(+)        = A.YYYYPW
           AND 1 = 1
           AND A.MEASURE          = 'CELL_CHAR_PLAN'      /* 셀 특성 실적 (활성화특성수율 역적용) */
           AND D.YYYYPW           < V_PLAN_START_YYYYPW   /* 과거 실적 구간 */
           AND A.YYYYPW           < V_PLAN_START_YYYYPW   /* 과거 실적 구간 */
         GROUP BY D.YYYYPW
                , D.PW_TO_YMD
                , D.YYYYMM
                , D.YYYYMM_PRVS
                , D.YYYYMM_FIRST_YMD
                , D.YYYYMM_LAST_YMD
                , A.ITEM_ID
                , A.OPERATION_GROUP
                , A.FROM_SITE
                , CASE WHEN C.CHAR_YIELD > 0
                       THEN C.CHAR_YIELD
                       ELSE 1
                  END;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available (Formation Progress 포함?) 추가');
        /* 전주 재고(Char. Available)  + 금주생산(Production(PKG)) -  금주 특성 생산 실적 (Char.Plan) / 활성화특성수율 */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_PAST_CELL_CHAR_AVAILABLE;

        INSERT
          INTO GT_GPWW_PAST_CELL_CHAR_AVAILABLE
             ( YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
          WITH BASE_DATA AS (
               /* 실적구간 -Char. Available 기초재고(전월말) */
               SELECT A.YYYYPW
                    , A.PW_TO_YMD
                    , A.YYYYMM_LAST_YMD
                    , A.ITEM_ID
                    , A.FROM_SITE
                    , A.OPERATION_GROUP
                    , A.YYYYMM_PRVS_QTY  AS MM_BOH_QTY
                    , B.QTY              AS MM_EOH_QTY
                    , 0.0                AS MM_ACC_CELL_PROD_QTY
                    , 0.0                AS MM_ACC_CELL_CHAR_QTY
                 FROM GT_GPWW_ENDING_INV_MM_WW A  /* 과거 실적구간 */
                    , GT_GPWW_ENDING_INV_MM    B  /* 당월말 재고 참조 */
                WHERE B.YYYYMM(+)    = A.YYYYMM
                  AND B.ITEM_ID(+)   = A.ITEM_ID
                  AND B.FROM_SITE(+) = A.FROM_SITE
                  AND B.TO_SITE(+)   = A.TO_SITE
                  AND B.MEASURE(+)   = A.MEASURE
                  AND 1 = 1
                  AND A.MEASURE      = 'CELL_CHAR_AVAILABLE'
               UNION ALL
               /* 실적구간 - Production(PKG) */
               SELECT C.YYYYPW
                    , C.PW_TO_YMD
                    , C.YYYYMM_LAST_YMD
                    , C.ITEM_ID
                    , C.FROM_SITE
                    , C.OPERATION_GROUP
                    , 0.0                AS MM_BOH_QTY
                    , 0.0                AS MM_EOH_QTY
                    , C.MM_ACC_CELL_PROD_QTY
                    , 0.0                AS MM_ACC_CELL_CHAR_QTY
                 FROM GT_GPWW_CELL_PROD_FOR_CHAR_AVAILABLE C  /* 과거 실적구간 */
                WHERE 1 = 1
               UNION ALL
               /* 실적구간 - Cell Char */
               SELECT D.YYYYPW
                    , D.PW_TO_YMD
                    , D.YYYYMM_LAST_YMD
                    , D.ITEM_ID
                    , D.FROM_SITE
                    , D.OPERATION_GROUP
                    , 0.0                AS MM_BOH_QTY
                    , 0.0                AS MM_EOH_QTY
                    , 0.0                AS MM_ACC_CELL_PROD_QTY
                    , D.MM_ACC_CELL_CHAR_QTY
                 FROM GT_GPWW_CELL_CHAR_FOR_CHAR_AVAILABLE D  /* 과거 실적구간 */
                WHERE 1 = 1
          )
        SELECT E.YYYYPW
             , E.ITEM_ID
             , 'CELL_CHAR_AVAILABLE'    AS MEASURE
             , E.FROM_SITE
             , '-'                      AS TO_SITE
             , '-'                      AS INCOTERMS
             , '-'                      AS VARIOUS_KEY
             , E.OPERATION_GROUP
             , '-'                      AS TO_SITE_TYPE
             , 0.0                      AS FROM_BOH_QTY
             , 0.0                      AS TO_BOH_QTY
             , CASE WHEN E.PW_TO_YMD = E.YYYYMM_LAST_YMD
                    THEN SUM(E.MM_EOH_QTY)
                    ELSE SUM(E.MM_BOH_QTY) + SUM(E.MM_ACC_CELL_PROD_QTY) - SUM(E.MM_ACC_CELL_CHAR_QTY)
               END                      AS QTY
          FROM BASE_DATA E
         WHERE 1 = 1
         GROUP BY E.YYYYPW
                , E.PW_TO_YMD
                , E.YYYYMM_LAST_YMD
                , E.ITEM_ID
                , E.FROM_SITE
                , E.OPERATION_GROUP;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : Char. Available / Formation Progress 분리');
        /* 2023.11.22 요구사항 */
        /* 과거 실적의 활성화와 특성 분리 */
        /* 현재 로직 : 과거 실적 재고 중에 활성화 재고는 모두 Char. Available에 반영되어 있음 */
        /* 이것을 Remain Lead Time이 0이 아닌 것을 Ending Inventory에서 Formation Progress로 차감하여 반영 */
        /* 만약 해당 cutoff 일의 Formation Progress > Ending Inventory 이면 Ending Inventory이 Max 값으로 설정 */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : Char. Available / Formation Progress - FP Aging Stock 반영');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_PAST_FORM_PROGRESS_CHAR_AVAILABLE;

        INSERT
          INTO GT_GPWW_PAST_FORM_PROGRESS_CHAR_AVAILABLE
             ( YYYYPW
             , ITEM_ID
             , FROM_SITE
             , OPERATION_GROUP
             , CHAR_AVAILABLE
             , FORM_PROGRESS
             , ENDING_INVENTORY
             , FP_FORM_PROGRESS )
        SELECT A.YYYYPW
             , A.ITEM_ID
             , A.FROM_SITE                      AS FROM_SITE
             , A.OPERATION_GROUP                AS OPERATION_GROUP
             , CASE WHEN A.QTY <  0  /* qty가 마이너스인 경우 고려 */
                    THEN A.QTY
                    WHEN A.QTY >= NVL(B.FP_FORM_PROGRESS, 0)
                    THEN A.QTY - NVL(B.FP_FORM_PROGRESS, 0)
                    ELSE 0
               END                              AS CHAR_AVAILABLE
             , CASE WHEN A.QTY <  0  /* qty가 마이너스인 경우 고려 */
                    THEN 0
                    WHEN A.QTY >= NVL(B.FP_FORM_PROGRESS, 0)
                    THEN NVL(B.FP_FORM_PROGRESS, 0)
                    ELSE A.QTY
               END                              AS FORM_PROGRESS
             , A.QTY                            AS ENDING_INVENTORY
             , NVL(B.FP_FORM_PROGRESS, 0)       AS FP_FORM_PROGRESS
          FROM GT_GPWW_PAST_CELL_CHAR_AVAILABLE A
             , GT_GPWW_FP_AGING_STOCK           B
         WHERE B.YYYYPW(+)    = A.YYYYPW
           AND B.FROM_SITE(+) = A.FROM_SITE
           AND B.ITEM_ID(+)   = A.ITEM_ID
           AND 1 = 1
           AND A.YYYYPW  < V_PLAN_START_YYYYPW;  /* 과거 실적 구간 */

		/*
		SELECT MI.YYYYPW
			  ,MI.ITEM_ID
			  ,MI.FROM_SITE					AS FROM_SITE
			  ,MI.OPERATION_GROUP			AS OPERATION_GROUP
			  ,CASE WHEN MI.YYYYMM_PRVS_QTY >= ISNULL(FA.FP_FORM_PROGRESS, 0)
					THEN MI.YYYYMM_PRVS_QTY -  ISNULL(FA.FP_FORM_PROGRESS, 0)
					ELSE 0
				END								AS CHAR_AVAILABLE
			  ,CASE WHEN MI.YYYYMM_PRVS_QTY >= ISNULL(FA.FP_FORM_PROGRESS, 0)
					THEN ISNULL(FA.FP_FORM_PROGRESS, 0)
					ELSE MI.YYYYMM_PRVS_QTY
			   END								AS FORM_PROGRESS 
			  ,MI.YYYYMM_PRVS_QTY							AS ENDING_INVENTORY
			  ,ISNULL(FA.FP_FORM_PROGRESS, 0)	AS FP_FORM_PROGRESS
		  INTO #PAST_FORM_PROGRESS_CHAR_AVAILABLE
		  FROM #TMP_ENDING_INV_MM_WW MI WITH(NOLOCK)
			   LEFT JOIN #FP_AGING_STOCK FA WITH(NOLOCK)
					  ON FA.YYYYPW		= MI.YYYYPW 
					 AND FA.FROM_SITE	= MI.FROM_SITE
					 AND FA.ITEM_ID		= MI.ITEM_ID
		 WHERE 1=1
		   AND MI.MEASURE = 'CELL_CHAR_AVAILABLE'
		   AND MI.YYYYPW  < @V_PLAN_START_YYYYPW -- 과거 실적 구간
		*/


/* START : 미래구간 Form. Progress (CELL_CHAR_AVAILABLE, CELL_CHAR_PLAN) 재계산 위 로직은 살려둔다.     -- 고도화 */
/* START : 미래구간 Form. Progress (CELL_CHAR_AVAILABLE, CELL_CHAR_PLAN) 재계산 위 로직은 살려둔다. */

        /* 기존 정보 삭제 */
        DELETE FROM GT_GPWW_CELL_CHAR_PLAN_FUTURE;
        DELETE FROM GT_GPWW_CELL_CHAR_PLAN_YIELD;
        DELETE
          FROM GT_GPWW_ASIS_GLOBAL_PSI
         WHERE 1 = 1
           AND MEASURE IN ('CELL_CHAR_AVAILABLE', 'CELL_CHAR_PLAN')
           AND YYYYPW >= V_PLAN_START_YYYYPW;  /* 미래 계획 구간 */

        BEGIN
            SELECT YYYYPW
              INTO V_HORIZON_END_YYYYPW
              FROM GT_GPWW_PW_LIST
             WHERE 1 = 1
               AND PW_FROM_YMD <= V_HORIZON_END_YYYYMMDD
               AND PW_TO_YMD   >= V_HORIZON_END_YYYYMMDD
               AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;  /* MSSQL SELECT @v = : 무결과 시 기존 값 유지 */
        END;

        /* 원문 CURSOR CUR_FORM (LOCAL) : OPEN / FETCH NEXT / WHILE @@FETCH_STATUS = 0 / BREAK / CLOSE / DEALLOCATE → FOR 루프 */
        FOR R_CUR_FORM IN (SELECT A.YYYYPW AS CUR_YYYYPW
                                , B.YYYYPW AS PREV_YYYYPW
                             FROM GT_GPWW_PW_LIST A
                                , GT_GPWW_PW_LIST B
                            WHERE B.PW_FROM_YMD <= TO_CHAR(TO_DATE(A.PW_FROM_YMD, 'YYYYMMDD') - 1, 'YYYYMMDD')
                              AND B.PW_TO_YMD   >= TO_CHAR(TO_DATE(A.PW_FROM_YMD, 'YYYYMMDD') - 1, 'YYYYMMDD')
                              AND 1 = 1
                              AND A.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                            ORDER BY A.YYYYPW)
        LOOP
            V_CUR_YYYYPW  := R_CUR_FORM.CUR_YYYYPW;
            V_PREV_YYYYPW := R_CUR_FORM.PREV_YYYYPW;

            BEGIN

                INSERT
                  INTO GT_GPWW_CELL_CHAR_PLAN_FUTURE
                       ( OPERATION_GROUP
                       , ITEM_ID
                       , TO_SITE
                       , INCOTERMS
                       , FROM_SITE
                       , VARIOUS_KEY
                       , YYYYPW
                       , MEASURE
                       , IS_CELL_IN_PACK_PLANT
                       , FROM_BOH_QTY
                       , TO_BOH_QTY
                       , QTY )
                  WITH CELL_CHAR_PLAN_SRC AS (
                       /* 과거 BOH 참조 */
                       SELECT A.OPERATION_GROUP
                            , A.ITEM_ID
                            , A.FROM_SITE
                            , V_PLAN_START_YYYYPW                AS YYYYPW
                            , A.CHAR_AVAILABLE + A.FORM_PROGRESS AS QTY
                         FROM GT_GPWW_PAST_FORM_PROGRESS_CHAR_AVAILABLE A
                              /* INNER JOIN #TMP_MM_LIST WL WITH(NOLOCK) */
                              /*  ON WL.YYYYMM >=  @V_PLAN_START_YYYYMM  -- 미래 계획 구간 */
                        WHERE 1 = 1
                          AND A.YYYYPW = V_RESULT_LAST_YYYYPW
                          AND V_PLAN_START_YYYYPW = V_CUR_YYYYPW
                       UNION ALL
                       /* CELL_PROD_FORM_END : From. End Eta (Prod) */
                       SELECT B.OPERATION_GROUP
                            , B.ITEM_ID
                            , B.FROM_SITE
                            , B.YYYYPW
                            , B.QTY
                         FROM GT_GPWW_CELL_PROD_FORM_END B
                        WHERE 1 = 1
                          AND B.YYYYPW = V_CUR_YYYYPW
                  )
                SELECT C.OPERATION_GROUP
                     , C.ITEM_ID
                     , '-'                      AS TO_SITE
                     , '-'                      AS INCOTERMS
                     , C.FROM_SITE
                     , '-'                      AS VARIOUS_KEY
                     , C.YYYYPW
                     , 'CELL_CHAR_PLAN'         AS MEASURE
                     , 'N'                      AS IS_CELL_IN_PACK_PLANT
                     , 0.0                      AS FROM_BOH_QTY
                     , 0.0                      AS TO_BOH_QTY
                     , SUM(C.QTY)
                       * CASE WHEN NVL(D.SSP_MODIFY_YIELD, 0) > 0      THEN D.SSP_MODIFY_YIELD
                              WHEN NVL(D.FORMATION_TOTAL_YIELD, 0) > 0 THEN D.FORMATION_TOTAL_YIELD
                              ELSE 1
                         END                    AS QTY

                  FROM CELL_CHAR_PLAN_SRC        C
                     , GT_GPWW_SCP_MST_FORMATION D
                 WHERE D.PLANT_SITE_ID(+) = C.FROM_SITE
                   AND D.ITEM_ID(+)       = C.ITEM_ID
                   AND D.YYYYPW(+)        = C.YYYYPW
                   AND 1 = 1
                   AND C.YYYYPW = V_CUR_YYYYPW
                 GROUP BY C.OPERATION_GROUP
                        , C.ITEM_ID
                        , C.FROM_SITE
                        , C.YYYYPW
                        , CASE WHEN NVL(D.SSP_MODIFY_YIELD, 0) > 0      THEN D.SSP_MODIFY_YIELD
                               WHEN NVL(D.FORMATION_TOTAL_YIELD, 0) > 0 THEN D.FORMATION_TOTAL_YIELD
                               ELSE 1
                          END;



                INSERT
                  INTO GT_GPWW_CELL_CHAR_PLAN_YIELD
                       ( OPERATION_GROUP
                       , ITEM_ID
                       , FROM_SITE
                       , YYYYPW
                       , QTY
                       , YIELD
                       , QTY_YIELD )
                  WITH CHAR_PLAN AS (
                       SELECT A.OPERATION_GROUP
                            , A.ITEM_ID
                            , A.FROM_SITE
                            , A.YYYYPW
                            , SUM(A.QTY) AS QTY
                         /* FROM #TMP_ASIS_GLOBAL_PSI PG WITH(NOLOCK) */
                         FROM GT_GPWW_CELL_CHAR_PLAN_FUTURE A
                        WHERE 1 = 1
                          AND A.MEASURE = 'CELL_CHAR_PLAN'  /* 특성(F6000) 생산계획 -- CELL_CHAR_PLAN */
                          AND A.YYYYPW  = V_CUR_YYYYPW      /* 미래 계획 구간 */
                        GROUP BY A.OPERATION_GROUP
                               , A.ITEM_ID
                               , A.FROM_SITE
                               , A.YYYYPW
                  )
                SELECT B.OPERATION_GROUP
                     , B.ITEM_ID
                     , B.FROM_SITE
                     , B.YYYYPW
                     , B.QTY
                     , CASE WHEN NVL(C.SSP_MODIFY_YIELD, 0) > 0      THEN C.SSP_MODIFY_YIELD
                            WHEN NVL(C.FORMATION_TOTAL_YIELD, 0) > 0 THEN C.FORMATION_TOTAL_YIELD
                            ELSE 1
                       END                      AS YIELD
                     , B.QTY / CASE WHEN NVL(C.SSP_MODIFY_YIELD, 0) > 0      THEN C.SSP_MODIFY_YIELD
                                    WHEN NVL(C.FORMATION_TOTAL_YIELD, 0) > 0 THEN C.FORMATION_TOTAL_YIELD
                                    ELSE 1
                               END              AS QTY_YIELD

                  FROM CHAR_PLAN                 B
                     , GT_GPWW_SCP_MST_FORMATION C
                 WHERE C.PLANT_SITE_ID(+) = B.FROM_SITE
                   AND C.ITEM_ID(+)       = B.ITEM_ID
                   AND C.YYYYPW(+)        = B.YYYYPW
                   AND 1 = 1;


                INSERT
                  INTO GT_GPWW_ASIS_GLOBAL_PSI
                       ( OPERATION_GROUP
                       , ITEM_ID
                       , TO_SITE
                       , INCOTERMS
                       , FROM_SITE
                       , TRANSPORT_MODE_LINE
                       , YYYYPW
                       , MEASURE
                       , IS_CELL_IN_PACK_PLANT
                       , FROM_BOH_QTY
                       , TO_BOH_QTY
                       , QTY )
                  WITH CHAR_AVAILABE_SRC AS (
                       /* ENDING INVENTORY BOH 사용    -- 고도화 */
                       SELECT A.OPERATION_GROUP
                            , A.ITEM_ID
                            , A.FROM_SITE
                            , V_PLAN_START_YYYYPW                AS YYYYPW
                            , A.CHAR_AVAILABLE + A.FORM_PROGRESS AS QTY
                         FROM GT_GPWW_PAST_FORM_PROGRESS_CHAR_AVAILABLE A
                        WHERE 1 = 1
                          AND A.YYYYPW = V_RESULT_LAST_YYYYPW
                          AND V_PLAN_START_YYYYPW = V_CUR_YYYYPW
                       UNION ALL
                       /* CELL_PROD_FORM_END : From. End Eta (Prod) */
                       SELECT B.OPERATION_GROUP
                            , B.ITEM_ID
                            , B.FROM_SITE
                            , B.YYYYPW
                            , SUM(B.QTY)
                                    /* OVER (PARTITION BY FF.ITEM_ID */
                                    /*                          ,FF.FROM_SITE */
                                    /*                  ORDER BY FF.YYYYMM)    AS QTY */
                         FROM GT_GPWW_CELL_PROD_FORM_END B
                        WHERE 1 = 1
                          AND B.YYYYPW >= V_CUR_YYYYPW
                          AND B.YYYYPW BETWEEN V_PREV_YYYYPW AND V_CUR_YYYYPW
                        GROUP BY B.OPERATION_GROUP
                               , B.ITEM_ID
                               , B.FROM_SITE
                               , B.YYYYPW
                       UNION ALL
                       /* CELL_CHAR_PLAN : Char. Plan */
                       SELECT C.OPERATION_GROUP
                            , C.ITEM_ID
                            , C.FROM_SITE
                            , C.YYYYPW
                            , (-1) * SUM(C.QTY_YIELD)
                                                        /* OVER (PARTITION BY CP.ITEM_ID */
                                                        /*        ,CP.FROM_SITE */
                                                        /* ORDER BY CP.YYYYMM) AS QTY */
                         FROM GT_GPWW_CELL_CHAR_PLAN_YIELD C
                        WHERE 1 = 1
                          AND C.YYYYPW >= V_CUR_YYYYPW
                          AND C.YYYYPW BETWEEN V_PREV_YYYYPW AND V_CUR_YYYYPW
                        GROUP BY C.OPERATION_GROUP
                               , C.ITEM_ID
                               , C.FROM_SITE
                               , C.YYYYPW
                  )
                SELECT D.OPERATION_GROUP
                     , D.ITEM_ID
                     , '-'                      AS TO_SITE
                     , '-'                      AS INCOTERMS
                     , D.FROM_SITE
                     , '-'                      AS VARIOUS_KEY
                     , D.YYYYPW
                     , 'CELL_CHAR_AVAILABLE'    AS MEASURE
                     , 'N'                      AS IS_CELL_IN_PACK_PLANT
                     , 0.0                      AS FROM_BOH_QTY
                     , 0.0                      AS TO_BOH_QTY
                     , SUM(D.QTY)               AS QTY
                  FROM CHAR_AVAILABE_SRC D
                 WHERE 1 = 1
                 GROUP BY D.OPERATION_GROUP
                        , D.ITEM_ID
                        , D.FROM_SITE
                        , D.YYYYPW;

                /* print  convert(varchar(30), getdate(), 121) + '::' + @CUR_FORM$CUR_YYYYPW */
        /* -SSSS */
                EXIT WHEN V_CUR_YYYYPW = V_HORIZON_END_YYYYPW;  /* 원문 IF @CUR_FORM$CUR_YYYYPW = CONVERT(NVARCHAR(8), @V_HORIZON_END_YYYYPW) BREAK */
            END;

        END LOOP;

        /* ---------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Char. Plan  measure 추가 (임시) - insert ');
        /* ---------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYPW
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT *
          FROM GT_GPWW_CELL_CHAR_PLAN_FUTURE;

/* END : 미래구간 Form. Progress (CELL_CHAR_AVAILABLE, CELL_CHAR_PLAN) 재계산 위 로직은 살려둔다. */
/* END : 미래구간 Form. Progress (CELL_CHAR_AVAILABLE, CELL_CHAR_PLAN) 재계산 위 로직은 살려둔다. */
        /* ----------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### Cell/Pack 및 FG/SEMI Measure 분리');
        /* ----------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_TOBE_GLOBAL_PSI;

        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
             ( YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT A.YYYYPW
             , A.ITEM_ID
             , CASE WHEN A.MEASURE = 'MODEL_INVENTORY' AND A.IS_CELL_IN_PACK_PLANT = 'Y' THEN 'PACK_CELL_EOH'
                    WHEN A.MEASURE = 'MODEL_INVENTORY' AND A.OPERATION_GROUP = 'A'       THEN 'CELL_EOH'
                    WHEN A.MEASURE = 'MODEL_INVENTORY' AND A.OPERATION_GROUP = 'P'       THEN 'PACK_EOH'
                    WHEN A.MEASURE = 'PRODUCTION'      AND A.OPERATION_GROUP = 'A'       THEN 'CELL_PROD'
                    WHEN A.MEASURE = 'PRODUCTION'      AND A.OPERATION_GROUP = 'P'       THEN 'PACK_PROD'
                    WHEN A.MEASURE = 'SHIP_PLAN'       AND B.SITE_TYPE = 'SALES'         THEN 'SHIP_PLAN'
                    WHEN A.MEASURE = 'SHIP_PLAN'       AND B.SITE_TYPE = 'PLANT'         THEN 'SEMI_SHIP_PLAN'
                    WHEN A.MEASURE = 'WH_IN'           AND B.SITE_TYPE = 'SALES'         THEN 'WHIN'
                    WHEN A.MEASURE = 'WH_IN'           AND B.SITE_TYPE = 'PLANT'         THEN 'SEMI_WHIN'
                    ELSE A.MEASURE
               END                              AS MEASURE
             , A.FROM_SITE
             , CASE WHEN A.TO_SITE IS NULL  /* 원문 PG.TO_SITE = '' */
                    THEN '-'
                    ELSE A.TO_SITE
               END                              AS TO_SITE
             , CASE WHEN A.INCOTERMS IS NULL  /* 원문 PG.INCOTERMS = '' */
                    THEN '-'
                    ELSE A.INCOTERMS
               END                              AS INCOTERMS
             , CASE WHEN A.TRANSPORT_MODE_LINE IS NULL  /* 원문 PG.TRANSPORT_MODE_LINE = '' */
                    THEN '-'
                    ELSE A.TRANSPORT_MODE_LINE
               END                              AS VARIOUS_KEY
             , A.OPERATION_GROUP
             , NVL(B.SITE_TYPE, '-')            AS TO_SITE_TYPE
             , SUM(A.FROM_BOH_QTY)              AS FROM_BOH_QTY
             , SUM(A.TO_BOH_QTY)                AS TO_BOH_QTY
             , SUM(A.QTY)                       AS QTY
          FROM GT_GPWW_ASIS_GLOBAL_PSI A
             , GT_GPWW_SCM_MST_SITE    B
         WHERE B.SCM_SITE_ID(+) = A.TO_SITE
           AND 1 = 1
         GROUP BY A.YYYYPW
                , A.ITEM_ID
                , CASE WHEN A.MEASURE = 'MODEL_INVENTORY' AND A.IS_CELL_IN_PACK_PLANT = 'Y' THEN 'PACK_CELL_EOH'
                       WHEN A.MEASURE = 'MODEL_INVENTORY' AND A.OPERATION_GROUP = 'A'       THEN 'CELL_EOH'
                       WHEN A.MEASURE = 'MODEL_INVENTORY' AND A.OPERATION_GROUP = 'P'       THEN 'PACK_EOH'
                       WHEN A.MEASURE = 'PRODUCTION'      AND A.OPERATION_GROUP = 'A'       THEN 'CELL_PROD'
                       WHEN A.MEASURE = 'PRODUCTION'      AND A.OPERATION_GROUP = 'P'       THEN 'PACK_PROD'
                       WHEN A.MEASURE = 'SHIP_PLAN'       AND B.SITE_TYPE = 'SALES'         THEN 'SHIP_PLAN'
                       WHEN A.MEASURE = 'SHIP_PLAN'       AND B.SITE_TYPE = 'PLANT'         THEN 'SEMI_SHIP_PLAN'
                       WHEN A.MEASURE = 'WH_IN'           AND B.SITE_TYPE = 'SALES'         THEN 'WHIN'
                       WHEN A.MEASURE = 'WH_IN'           AND B.SITE_TYPE = 'PLANT'         THEN 'SEMI_WHIN'
                       ELSE A.MEASURE
                  END
                , A.FROM_SITE
                , CASE WHEN A.TO_SITE IS NULL
                       THEN '-'
                       ELSE A.TO_SITE
                  END  /* AS TO_SITE */
                , CASE WHEN A.INCOTERMS IS NULL
                       THEN '-'
                       ELSE A.INCOTERMS
                  END  /* AS INCOTERMS */
                , CASE WHEN A.TRANSPORT_MODE_LINE IS NULL
                       THEN '-'
                       ELSE A.TRANSPORT_MODE_LINE
                  END  /* AS ETC */
                , A.OPERATION_GROUP
                , NVL(B.SITE_TYPE, '-');


        /* ESST_CA_WND 향 SEMI 강제 등록(semi_whin, semi_intransit 만 조정) 저장 위치 중요 */
        /* 품번, to_site 제외하고 81물량 다 넣어준다 */
        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
             ( YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT YYYYPW
             , ITEM_ID
             , 'SEMI_WHIN'      AS MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , 'PLANT_'         AS TO_SITE_TYPE  /* SEMI INTRANSIT 에서 제외하기 위해서( #WHIN_FOR_SEMI_INTRANSIT 에서 to_site_type 으로 거른다.) */
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
          FROM SCP_RPT_GLOBAL_PSI_MD_WW  /* 81부터 계산되어 있어서 가져다 쓴다. */
         WHERE 1 = (CASE WHEN V_DIVISION_ID = '81_ST' THEN 1 ELSE 0 END)
           AND DIVISION_ID          = '81'
           AND MEASURE              = 'WHIN'
           AND CELL_GROUP           = 'E131B'
           /* AND PG.ITEM_ID                LIKE 'ACEH1131I-B1%' */
           /* AND PG.TO_SITE                = 'ESST_CA_WND' */
           AND QTY                 <> 0
           AND PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND PLAN_TYPE            = V_PLAN_TYPE;  /* E20260708-000926 */


/* START : 실적 Measure #TMP_TOBE_GLOBAL_PSI Measure 입력 */
/* START : 실적 Measure #TMP_TOBE_GLOBAL_PSI Measure 입력 */
/* 실적 메져 입력 시 #TMP_TOBE_GLOBAL_PSI 을 사용하는 메져가 있어 위치 변경 */
        /* ----------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' 실적 구간 #TMP_TOBE_GLOBAL_PSI 입력 메져 위치 이동 ');  /* @@@ */
        /* ----------------------------------------------------------------------------------------------------- */

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)  - semi ship plan site');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_ITEM_SEMI_SHIP_SITE;

        INSERT
          INTO GT_GPWW_ITEM_SEMI_SHIP_SITE
             ( ITEM_ID
             , PACK_SITE
             , CELL_SITE_PAST
             , CELL_SITE_FUTURE )
        SELECT A.ITEM_ID
             , A.TO_SITE                                                                       AS PACK_SITE
             , MAX(CASE WHEN A.YYYYPW <  V_PLAN_START_YYYYPW THEN A.FROM_SITE ELSE NULL END) KEEP (DENSE_RANK LAST ORDER BY UPPER(TRANSLATE(CASE WHEN A.YYYYPW <  V_PLAN_START_YYYYPW THEN A.FROM_SITE ELSE NULL END, '_-', '/')) NULLS FIRST, CASE WHEN A.YYYYPW <  V_PLAN_START_YYYYPW THEN A.FROM_SITE ELSE NULL END NULLS FIRST)  AS CELL_SITE_PAST   /* MSSQL Latin1_General_CI_AS 비교 재현(대소문자·하이픈 무시, 밑줄은 글자·숫자 앞) */
             , MAX(CASE WHEN A.YYYYPW >= V_PLAN_START_YYYYPW THEN A.FROM_SITE ELSE NULL END) KEEP (DENSE_RANK LAST ORDER BY UPPER(TRANSLATE(CASE WHEN A.YYYYPW >= V_PLAN_START_YYYYPW THEN A.FROM_SITE ELSE NULL END, '_-', '/')) NULLS FIRST, CASE WHEN A.YYYYPW >= V_PLAN_START_YYYYPW THEN A.FROM_SITE ELSE NULL END NULLS FIRST)  AS CELL_SITE_FUTURE
          FROM GT_GPWW_TOBE_GLOBAL_PSI A
             , GT_GPWW_SCM_MST_SITE    B  /* pack site */
             , GT_GPWW_SCM_MST_SITE    C  /* cell site */
         WHERE B.SCM_SITE_ID     = A.TO_SITE
           AND C.SCM_SITE_ID     = A.FROM_SITE
           AND 1 = 1
           AND B.OPERATION_GROUP = 'P'
           AND C.OPERATION_GROUP = 'A'
           AND A.MEASURE         = 'SEMI_SHIP_PLAN'
           AND A.QTY            <> 0
         GROUP BY A.ITEM_ID
                , A.TO_SITE;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Pack 생산 실적 1 (수율)');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_PACK_PRODUCTION_RESULT_1;

        INSERT
          INTO GT_GPWW_PACK_PRODUCTION_RESULT_1
             ( YYYYPW
             , PW_TO_YMD
             , YYYYMM
             , YYYYMM_PRVS
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , FROM_SITE
             , OPERATION_GROUP
             , PACK_PROD_QTY
             , PACK_PROD_YIELD_QTY )
        SELECT B.YYYYPW
             , B.PW_TO_YMD
             , B.YYYYMM
             , B.YYYYMM_PRVS
             , B.YYYYMM_FIRST_YMD
             , B.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.FROM_SITE
             , A.OPERATION_GROUP
             , SUM(A.ACTUAL_GOOD_QTY)           AS PACK_PROD_QTY
             , SUM(A.ACTUAL_GOOD_QTY
                   / CASE WHEN NVL(C.YIELD, 0) > 0
                          THEN C.YIELD
                          ELSE 1.0
                     END)                       AS PACK_PROD_YIELD_QTY
          FROM GT_GPWW_PRODUCTION_RESULT A
             , GT_GPWW_PW_LIST           B
             , SCP_MST_TACT_TIME_EXCEPT  C
         WHERE B.PW_FROM_YMD               <= A.PLAN_YYYYMMDD
           AND B.PW_TO_YMD                 >= A.PLAN_YYYYMMDD
           AND C.PLANT_SITE_ID(+)           = A.FROM_SITE
           AND C.ITEM_ID(+)                 = A.ITEM_ID
           AND C.OPERATION_ID(+)            = A.OPERATION_ID
           AND C.LINE_ID(+)                 = A.LINE_ID
           AND C.TACT_TIME_START_DATE(+)   <= A.PLAN_YYYYMMDD
           AND C.TACT_TIME_END_DATE(+)     >= A.PLAN_YYYYMMDD
           AND 1 = 1
           AND A.OPERATION_GROUP            = 'P'  /* 팩 생산 실적 (실적구간) */
           AND C.DIVISION_ID(+)             = V_DIVISION_ID
         GROUP BY B.YYYYPW
                , B.PW_TO_YMD
                , B.YYYYMM
                , B.YYYYMM_PRVS
                , B.YYYYMM_FIRST_YMD
                , B.YYYYMM_LAST_YMD
                , A.ITEM_ID
                , A.FROM_SITE
                , A.OPERATION_GROUP;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Pack 생산 실적 2 (0채움)');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_PACK_PRODUCTION_RESULT_2;

        /* 실적구간 - Cell 도착 (to Plant) - to 사이트 기준 */
        INSERT
          INTO GT_GPWW_PACK_PRODUCTION_RESULT_2
             ( YYYYPW
             , PW_TO_YMD
             , YYYYMM
             , YYYYMM_PRVS
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , PACK_PROD_QTY
             , PACK_PROD_YIELD_QTY )
        SELECT B.YYYYPW
             , B.PW_TO_YMD
             , B.YYYYMM
             , B.YYYYMM_PRVS
             , B.YYYYMM_FIRST_YMD
             , B.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , SUM(CASE WHEN A.YYYYMM = B.YYYYMM AND A.YYYYPW = B.YYYYPW  /* 20240327 누적아닌 해당 주차 */
                        THEN A.PACK_PROD_QTY
                        ELSE 0.0
                   END)  AS PACK_PROD_QTY
             , SUM(CASE WHEN A.YYYYMM = B.YYYYMM AND A.YYYYPW = B.YYYYPW  /* 20240327 누적아닌 해당 주차 */
                        THEN A.PACK_PROD_YIELD_QTY
                        ELSE 0.0
                   END)  AS PACK_PROD_YIELD_QTY
          FROM GT_GPWW_PACK_PRODUCTION_RESULT_1 A
             , GT_GPWW_PW_LIST                  B
         WHERE 1 = 1
           AND B.YYYYPW < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
         GROUP BY B.YYYYPW
                , B.PW_TO_YMD
                , B.YYYYMM
                , B.YYYYMM_PRVS
                , B.YYYYMM_FIRST_YMD
                , B.YYYYMM_LAST_YMD
                , A.ITEM_ID
                , A.OPERATION_GROUP
                , A.FROM_SITE;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Pack 생산 실적 3 (대표cell * 셀환산계수)');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_PACK_PRODUCTION_RESULT_3;

        /* ★ANSI 유지 : 외부조인 테이블끼리 조건(CI ← MI, CF2·CF3 ← CF/CF2)과 좌측 전용 ON 조건이 섞여 (+) 로 같은 의미를 낼 수 없음 */
        INSERT
          INTO GT_GPWW_PACK_PRODUCTION_RESULT_3
             ( REP_CELL_ITEM_ID
             , CELL_CF
             , CELL_CF_TYPE
             , MODULE_ID
             , YYYYPW
             , PW_TO_YMD
             , YYYYMM
             , YYYYMM_PRVS
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , PACK_PROD_QTY
             , PACK_PROD_YIELD_QTY )
        SELECT CASE WHEN B.MODEL_ID IS NOT NULL                                 /* AMDAU% 모듈 */
                    THEN B.CELL_ITEM_ID
                    WHEN A.OPERATION_GROUP = 'P' AND C.CELL_ITEM_ID IS NOT NULL  /* Pack */
                    THEN C.CELL_ITEM_ID
                    WHEN A.OPERATION_GROUP = 'P' AND D.CELL_ITEM_ID IS NOT NULL  /* Pack */
                    THEN D.CELL_ITEM_ID
                    ELSE NULL
               END                                  AS REP_CELL_ITEM_ID  /* 대표셀 (CP:Cell Product) 모델 */
             , CASE WHEN E.CELL_CF IS NOT NULL      THEN CAST(TO_NUMBER(E.CELL_CF) AS NUMBER(20,10))
                    WHEN F.CELL_CF IS NOT NULL      THEN CAST(TO_NUMBER(F.CELL_CF) AS NUMBER(20,10))
                    WHEN G.CELL_CF IS NOT NULL      THEN CAST(TO_NUMBER(G.CELL_CF) AS NUMBER(20,10))
                    ELSE CAST(1.0 AS NUMBER(20,10))
               END                                  AS CELL_CF
             , CASE WHEN E.CELL_CF IS NOT NULL      THEN 'CF'
                    WHEN F.CELL_CF IS NOT NULL      THEN 'CF2'
                    WHEN G.CELL_CF IS NOT NULL      THEN 'CF3'
                    ELSE 'NULL'
               END                                  AS CELL_CF_TYPE
             , B.MODULE_ID
             , A.YYYYPW
             , A.PW_TO_YMD
             , A.YYYYMM
             , A.YYYYMM_PRVS
             , A.YYYYMM_FIRST_YMD
             , A.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , A.PACK_PROD_QTY
             , A.PACK_PROD_YIELD_QTY
          FROM GT_GPWW_PACK_PRODUCTION_RESULT_2 A
               LEFT OUTER JOIN GT_GPWW_MODULE_MODEL_INFO B
                 ON B.MODULE_ID = A.ITEM_ID
               LEFT OUTER JOIN GT_GPWW_CP_CELL_ITEM_INFO C
                 ON C.MODEL_ID = CASE WHEN B.MODEL_ID IS NOT NULL      /* AMDAU% 모듈 */
                                      THEN B.MODEL_ID
                                      WHEN A.OPERATION_GROUP = 'P'     /* 팩 */
                                      THEN A.ITEM_ID
                                      ELSE NULL                        /* 원문 '' */
                                 END
               LEFT OUTER JOIN GT_GPWW_ETC_CP_CELL_INFO D
                 ON D.PARENT_ITEM_ID = A.ITEM_ID
               LEFT OUTER JOIN GT_GPWW_SCP_MST_ITEM_CELL_CF E
                 ON E.ITEM_ID = A.ITEM_ID
                AND E.CELL_CF IS NOT NULL
                AND TO_NUMBER(E.CELL_CF) <> 0.0
               LEFT OUTER JOIN GT_GPWW_SCP_MST_ITEM_CELL_CF F
                 ON F.ITEM_ID = SUBSTR(A.ITEM_ID, 1, LENGTH(RTRIM(A.ITEM_ID)) - 2)
                AND A.ITEM_ID LIKE '%-_'
                AND A.OPERATION_GROUP = 'P'
                AND E.CELL_CF IS NULL
                AND F.CELL_CF IS NOT NULL
                AND TO_NUMBER(F.CELL_CF) <> 0.0
               LEFT OUTER JOIN GT_GPWW_SCP_MST_ITEM_CELL_CF G
                 ON G.ITEM_ID = SUBSTR(A.ITEM_ID, 1, LENGTH(RTRIM(A.ITEM_ID)) - 3)
                AND A.ITEM_ID LIKE '%-__'
                AND A.OPERATION_GROUP = 'P'
                AND E.CELL_CF IS NULL
                AND F.CELL_CF IS NULL
                AND G.CELL_CF IS NOT NULL
                AND TO_NUMBER(G.CELL_CF) <> 0.0
         WHERE 1 = 1;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 공장내 이동 물량 : SEMI SHIP_PLAN, SEMI WH_IN measure 계산 ');
        /* 전주 재고(Cell Inventory)  + 금주도착(Semi WH In) -  금주생산(Production)/팩수율 */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
             ( YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT IA.YYYYPW
             , IA.ITEM_ID
             , IB.MEASURE
             , IA.FROM_SITE
             , IA.TO_SITE
             , IA.INCOTERMS
             , IA.VARIOUS_KEY
             , IA.OPERATION_GROUP
             , IA.TO_SITE_TYPE
             , SUM(IA.FROM_BOH_QTY) AS FROM_BOH_QTY
             , SUM(IA.TO_BOH_QTY)   AS TO_BOH_QTY
             , SUM(IA.QTY)          AS QTY
          FROM (SELECT A.YYYYPW
                     , A.REP_CELL_ITEM_ID                                           AS ITEM_ID
                     , NVL(C.SCM_SITE_ID, NVL(D.CELL_SITE_PAST, D.CELL_SITE_FUTURE)) AS FROM_SITE /* CELL PLANT */
                     , CASE WHEN B.PLANT_ID IS NULL THEN NULL ELSE B.PLANT_ID || '-P' END AS TO_SITE
                     , '-'                                                          AS INCOTERMS
                     , '-'                                                          AS VARIOUS_KEY
                     , 'A'                                                          AS OPERATION_GROUP
                     , 'PLANT'                                                      AS TO_SITE_TYPE
                     , 0.0                                                          AS FROM_BOH_QTY
                     , 0.0                                                          AS TO_BOH_QTY
                     , A.PACK_PROD_YIELD_QTY * NVL(A.CELL_CF, 1)                    AS QTY
                  FROM GT_GPWW_PACK_PRODUCTION_RESULT_3 A
                     , GT_GPWW_SCM_MST_SITE             B   /* PACK PLANT SITE */
                     , GT_GPWW_SCM_MST_SITE             C   /* CELL PLANT SITE */
                     , GT_GPWW_ITEM_SEMI_SHIP_SITE      D
                 WHERE B.SCM_SITE_ID        = A.FROM_SITE
                   AND C.PLANT_ID(+)        = B.PLANT_ID
                   AND D.ITEM_ID(+)         = A.ITEM_ID
                   AND D.PACK_SITE(+)       = B.SCM_SITE_ID  /* PACK SITE */
                   AND C.OPERATION_GROUP(+) = 'A'
                   AND C.SITE_TYPE(+)       = 'PLANT'
                   /* - 20240327 불필요 조건 삭제 */
                   AND NVL(C.SCM_SITE_ID, NVL(D.CELL_SITE_PAST, D.CELL_SITE_FUTURE)) IS NOT NULL
                   AND A.PACK_PROD_YIELD_QTY > 0
                   AND A.REP_CELL_ITEM_ID IS NOT NULL
                   AND A.YYYYPW < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
               ) IA
             , (SELECT 'SEMI_SHIP_PLAN' AS MEASURE FROM DUAL UNION SELECT 'SEMI_WHIN' AS MEASURE FROM DUAL
               ) IB
         WHERE 1=1
           AND NOT EXISTS (SELECT 1
                             FROM GT_GPWW_TOBE_GLOBAL_PSI SA
                            WHERE 1=1
                              /* AND X.MEASURE IN ('SEMI_WHIN', 'SEMI_SHIP_PLAN') */
                              AND SA.YYYYPW          = IA.YYYYPW
                              AND SA.ITEM_ID         = IA.ITEM_ID
                              /* AND X.MEASURE = MM.MEASURE */
                              /* AND X.FROM_SITE = PR.FROM_SITE */
                              AND SA.OPERATION_GROUP = IA.OPERATION_GROUP
                              AND SA.MEASURE IN ('SEMI_WHIN') /* 해당기준으로만 데이타 생성 */
                              AND SA.YYYYPW < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
                          )
           AND IA.ITEM_ID IS NOT NULL /* E20251029-001009 오류대응. */
         GROUP BY IA.YYYYPW, IA.ITEM_ID, IB.MEASURE, IA.FROM_SITE, IA.TO_SITE, IA.INCOTERMS, IA.VARIOUS_KEY, IA.OPERATION_GROUP, IA.TO_SITE_TYPE;

        MERGE INTO GT_GPWW_TOBE_GLOBAL_PSI A
        USING (SELECT IB.YYYYPW
                    , IB.ITEM_ID
                    , IC.MEASURE
                    , IB.FROM_SITE
                    , IB.TO_SITE
                    , IB.INCOTERMS
                    , IB.VARIOUS_KEY
                    , IB.OPERATION_GROUP
                    , IB.TO_SITE_TYPE
                    , SUM(IB.FROM_BOH_QTY) AS FROM_BOH_QTY
                    , SUM(IB.TO_BOH_QTY)   AS TO_BOH_QTY
                    , SUM(IB.QTY)          AS QTY
                 FROM (SELECT B.YYYYPW
                            , B.REP_CELL_ITEM_ID                                           AS ITEM_ID
                            , NVL(D.SCM_SITE_ID, NVL(E.CELL_SITE_PAST, E.CELL_SITE_FUTURE)) AS FROM_SITE /* CELL PLANT */
                            , CASE WHEN C.PLANT_ID IS NULL THEN NULL ELSE C.PLANT_ID || '-P' END AS TO_SITE
                            , '-'                                                          AS INCOTERMS
                            , '-'                                                          AS VARIOUS_KEY
                            , 'A'                                                          AS OPERATION_GROUP
                            , 'PLANT'                                                      AS TO_SITE_TYPE
                            , 0.0                                                          AS FROM_BOH_QTY
                            , 0.0                                                          AS TO_BOH_QTY
                            , B.PACK_PROD_YIELD_QTY * NVL(B.CELL_CF, 1)                    AS QTY
                         FROM GT_GPWW_PACK_PRODUCTION_RESULT_3 B
                            , GT_GPWW_SCM_MST_SITE             C   /* PACK PLANT SITE */
                            , GT_GPWW_SCM_MST_SITE             D   /* CELL PLANT SITE */
                            , GT_GPWW_ITEM_SEMI_SHIP_SITE      E
                        WHERE C.SCM_SITE_ID        = B.FROM_SITE
                          AND D.PLANT_ID(+)        = C.PLANT_ID
                          AND E.ITEM_ID(+)         = B.ITEM_ID
                          AND E.PACK_SITE(+)       = C.SCM_SITE_ID  /* PACK SITE */
                          AND D.OPERATION_GROUP(+) = 'A'
                          AND D.SITE_TYPE(+)       = 'PLANT'
                          AND NVL(D.SCM_SITE_ID, NVL(E.CELL_SITE_PAST, E.CELL_SITE_FUTURE)) IS NOT NULL
                          AND B.PACK_PROD_YIELD_QTY > 0
                          AND B.REP_CELL_ITEM_ID IS NOT NULL
                          AND B.YYYYPW = V_PLAN_START_YYYYPW
                      ) IB
                    , (SELECT 'SEMI_SHIP_PLAN' AS MEASURE FROM DUAL UNION SELECT 'SEMI_WHIN' AS MEASURE FROM DUAL
                      ) IC
                WHERE 1=1
                GROUP BY IB.YYYYPW, IB.ITEM_ID, IC.MEASURE, IB.FROM_SITE, IB.TO_SITE, IB.INCOTERMS, IB.VARIOUS_KEY, IB.OPERATION_GROUP, IB.TO_SITE_TYPE
              ) IA
           ON (    IA.YYYYPW          = A.YYYYPW
               AND IA.ITEM_ID         = A.ITEM_ID
               AND IA.MEASURE         = A.MEASURE
               AND IA.OPERATION_GROUP = A.OPERATION_GROUP
               AND IA.FROM_SITE       = A.FROM_SITE
               AND IA.TO_SITE         = A.TO_SITE
               AND IA.INCOTERMS       = A.INCOTERMS
               AND IA.VARIOUS_KEY     = A.VARIOUS_KEY
              )
         WHEN MATCHED THEN
              UPDATE
                 SET A.QTY = NVL(A.QTY, 0) + NVL(IA.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( YYYYPW
                   , ITEM_ID
                   , MEASURE
                   , FROM_SITE
                   , TO_SITE
                   , INCOTERMS
                   , VARIOUS_KEY
                   , OPERATION_GROUP
                   , TO_SITE_TYPE
                   , FROM_BOH_QTY
                   , TO_BOH_QTY
                   , QTY
                   )
              VALUES
                   ( IA.YYYYPW
                   , IA.ITEM_ID
                   , IA.MEASURE
                   , IA.FROM_SITE
                   , IA.TO_SITE
                   , IA.INCOTERMS
                   , IA.VARIOUS_KEY
                   , IA.OPERATION_GROUP
                   , IA.TO_SITE_TYPE
                   , IA.FROM_BOH_QTY
                   , IA.TO_BOH_QTY
                   , IA.QTY
                   );


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : TO_SITE_EOH(VMI) measure 추가');
        /* 전주 재고(EOH)+ 금주도착(WH In) - 매출(RTF) */
        /* 실적구간 고객향 도착 실적은 매출(RTF)과 동일함 */
        /* 당월 마지막 주를 제외하고 모두 전월 EOH와 동일함. */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */

        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
             ( YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT A.YYYYPW
             , A.ITEM_ID
             , A.MEASURE
             , A.FROM_SITE
             , A.TO_SITE
             , '-'          AS INCOTERMS
             , '-'          AS VARIOUS_KEY
             , A.OPERATION_GROUP
             , '-'          AS TO_SITE_TYPE
             , 0.0          AS FROM_BOH_QTY
             , 0.0          AS TO_BOH_QTY
             , CASE WHEN A.PW_TO_YMD = A.YYYYMM_LAST_YMD      /* 주 마지막일이 당월 마지막 일과 같을 경우 */
                    THEN B.QTY                                /* 당월말 재고 */
                    ELSE A.YYYYMM_PRVS_QTY                    /* 전월말 재고 (기초재고) */
               END          AS QTY
          FROM GT_GPWW_ENDING_INV_MM_WW A
             , GT_GPWW_ENDING_INV_MM    B                     /* 당월말 재고 참조 */
         WHERE B.YYYYMM(+)    = A.YYYYMM
           AND B.ITEM_ID(+)   = A.ITEM_ID
           AND B.FROM_SITE(+) = A.FROM_SITE
           AND B.TO_SITE(+)   = A.TO_SITE
           AND B.MEASURE(+)   = A.MEASURE
           AND A.MEASURE      = 'TO_SITE_EOH';





        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant)');
        /* 전주 재고(Intransit)  + 금주출하(Ship Plan) - 금주도착(WH In) */
        /* 전월말 재고를 기초로 하여 당월 출하(Ship Plan)와 도착(Wh In) 누적 정보를 적용하여 계산 */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant) - 출하');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SHIP_FOR_SEMI_INTRANSIT;

        /* 실적구간 - 출하 (to Plant) */
        INSERT
          INTO GT_GPWW_SHIP_FOR_SEMI_INTRANSIT
             ( YYYYPW
             , PW_TO_YMD
             , YYYYMM
             , YYYYMM_PRVS
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , TO_SITE_TYPE
             , MM_ACC_EXFACTORY_QTY )
        SELECT C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM
             , C.YYYYMM_PRVS
             , C.YYYYMM_FIRST_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , A.TO_SITE
             , A.TO_SITE_TYPE
             , SUM(CASE WHEN B.YYYYMM = C.YYYYMM AND B.YYYYPW <= C.YYYYPW
                        THEN A.QTY
                        ELSE 0.0
                   END) AS MM_ACC_EXFACTORY_QTY
          FROM GT_GPWW_TOBE_GLOBAL_PSI A
             , GT_GPWW_PW_LIST         B
             , GT_GPWW_PW_LIST         C
         WHERE B.YYYYPW       = A.YYYYPW
           AND A.MEASURE      = 'SEMI_SHIP_PLAN'
           AND A.TO_SITE_TYPE = 'PLANT'
           AND C.YYYYPW       < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
           AND A.YYYYPW       < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
         GROUP BY
               C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM
             , C.YYYYMM_PRVS
             , C.YYYYMM_FIRST_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , A.TO_SITE
             , A.TO_SITE_TYPE;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant) - 도착');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_WHIN_FOR_SEMI_INTRANSIT;

        /* 실적구간 -  도착 (to Plant) */
        INSERT
          INTO GT_GPWW_WHIN_FOR_SEMI_INTRANSIT
             ( YYYYPW
             , PW_TO_YMD
             , YYYYMM
             , YYYYMM_PRVS
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , TO_SITE_TYPE
             , MM_ACC_WHIN_QTY )
        SELECT C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM
             , C.YYYYMM_PRVS
             , C.YYYYMM_FIRST_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , A.TO_SITE
             , A.TO_SITE_TYPE
             , SUM(CASE WHEN B.YYYYMM = C.YYYYMM AND B.YYYYPW <= C.YYYYPW
                        THEN A.QTY
                        ELSE 0.0
                   END) AS MM_ACC_WHIN_QTY
          FROM GT_GPWW_TOBE_GLOBAL_PSI A
             , GT_GPWW_PW_LIST         B
             , GT_GPWW_PW_LIST         C
         WHERE B.YYYYPW       = A.YYYYPW
           AND A.MEASURE      = 'SEMI_WHIN'
           AND A.TO_SITE_TYPE = 'PLANT'
           AND C.YYYYPW       < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
           AND A.YYYYPW       < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
         GROUP BY
               C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM
             , C.YYYYMM_PRVS
             , C.YYYYMM_FIRST_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , A.TO_SITE
             , A.TO_SITE_TYPE;

        /* E20251028-000389 unmatchedInv 실적구간 세팅. */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Mismatch_Inv(UnMachedInv) measure 추가');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
               ( YYYYPW
               , ITEM_ID
               , MEASURE
               , FROM_SITE
               , TO_SITE
               , INCOTERMS
               , VARIOUS_KEY
               , OPERATION_GROUP
               , TO_SITE_TYPE
               , FROM_BOH_QTY
               , TO_BOH_QTY
               , QTY )
          WITH BASE_DATA AS (
               /* 실적구간 - Mismatch_Inv 기초재고(전월말) */
               SELECT A.YYYYPW
                    , A.PW_TO_YMD
                    , A.YYYYMM_LAST_YMD
                    , A.ITEM_ID
                    , A.FROM_SITE
                    , A.TO_SITE
                    , A.OPERATION_GROUP
                    , A.YYYYMM_PRVS_QTY AS MM_BOH_QTY
                    , B.QTY             AS MM_EOH_QTY
                    , 0.0               AS MM_ACC_EXFACTORY_QTY
                    , 0.0               AS MM_ACC_WHIN_QTY
                 FROM GT_GPWW_ENDING_INV_MM_WW A       /* 과거 실적구간 */
                    , GT_GPWW_ENDING_INV_MM    B       /* 당월말 재고 참조 */
                WHERE B.YYYYMM(+)    = A.YYYYMM
                  AND B.ITEM_ID(+)   = A.ITEM_ID
                  AND B.FROM_SITE(+) = A.FROM_SITE
                  AND B.TO_SITE(+)   = A.TO_SITE
                  AND B.MEASURE(+)   = A.MEASURE
                  AND A.MEASURE      = 'MISMATCH_INV'
          )
        SELECT C.YYYYPW
             , C.ITEM_ID
             , 'MISMATCH_INV'   AS MEASURE
             , C.FROM_SITE
             , C.TO_SITE
             , '-'              AS INCOTERMS
             , '-'              AS VARIOUS_KEY
             , C.OPERATION_GROUP
             , '-'              AS TO_SITE_TYPE
             , 0.0              AS FROM_BOH_QTY
             , 0.0              AS TO_BOH_QTY
             , CASE WHEN C.PW_TO_YMD = C.YYYYMM_LAST_YMD
                    THEN SUM(C.MM_EOH_QTY)
                    ELSE SUM(C.MM_BOH_QTY)
               END              AS QTY
          FROM BASE_DATA C
         WHERE 1=1
         GROUP BY
               C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM_LAST_YMD
             , C.ITEM_ID
             , C.FROM_SITE
             , C.TO_SITE
             , C.OPERATION_GROUP;


        /* E20251028-000389 unmatchedInv 계획구간 세팅. */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Mismatch_Inv(UnMachedInv) measure 추가');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */

        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
             ( YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT IA.YYYYPW
             , IA.ITEM_ID
             , IA.MEASURE
             , IA.FROM_SITE
             , IA.TO_SITE
             , IA.INCOTERMS
             , IA.VARIOUS_KEY
             , IA.OPERATION_GROUP
             , IA.TO_SITE_TYPE
             , SUM(IA.FROM_BOH_QTY) AS FROM_BOH_QTY
             , SUM(IA.TO_BOH_QTY)   AS TO_BOH_QTY
             , SUM(IA.QTY)          AS QTY
          FROM (SELECT B.YYYYPW
                     , A.ITEM_ID
                     , 'MISMATCH_INV'   AS MEASURE
                     , A.FROM_SITE      AS FROM_SITE
                     , A.TO_SITE        AS TO_SITE
                     , '-'              AS INCOTERMS
                     , '-'              AS VARIOUS_KEY
                     , A.OPERATION_GROUP
                     , '-'              AS TO_SITE_TYPE
                     , 0.0              AS FROM_BOH_QTY
                     , 0.0              AS TO_BOH_QTY
                     , A.QTY            AS QTY
                  FROM GT_GPWW_TOBE_GLOBAL_PSI A
                     , GT_GPWW_PW_LIST         B
                 WHERE 1=1
                   AND A.MEASURE = 'MISMATCH_INV'
                   AND B.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                   AND A.YYYYPW  = V_RESULT_LAST_YYYYPW
               ) IA
         WHERE 1=1
           AND NOT EXISTS (SELECT 1
                             FROM GT_GPWW_TOBE_GLOBAL_PSI SA
                            WHERE 1=1
                              AND SA.MEASURE = IA.MEASURE
                              AND SA.ITEM_ID = IA.ITEM_ID
                              AND SA.MEASURE = 'MISMATCH_INV'
                              AND SA.YYYYPW >= V_PLAN_START_YYYYPW
                          )
           AND IA.ITEM_ID IS NOT NULL
         GROUP BY IA.YYYYPW, IA.ITEM_ID, IA.MEASURE, IA.FROM_SITE, IA.TO_SITE, IA.INCOTERMS, IA.VARIOUS_KEY, IA.OPERATION_GROUP, IA.TO_SITE_TYPE
        ;



        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant) measure 추가');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
               ( YYYYPW
               , ITEM_ID
               , MEASURE
               , FROM_SITE
               , TO_SITE
               , INCOTERMS
               , VARIOUS_KEY
               , OPERATION_GROUP
               , TO_SITE_TYPE
               , FROM_BOH_QTY
               , TO_BOH_QTY
               , QTY )
          WITH BASE_DATA AS (
               /* 실적구간 - semi Intransit 기초재고(전월말) */
               SELECT A.YYYYPW
                    , A.PW_TO_YMD
                    , A.YYYYMM_LAST_YMD
                    , A.ITEM_ID
                    , A.FROM_SITE
                    , A.TO_SITE
                    , A.OPERATION_GROUP
                    , A.YYYYMM_PRVS_QTY AS MM_BOH_QTY
                    , B.QTY             AS MM_EOH_QTY
                    , 0.0               AS MM_ACC_EXFACTORY_QTY
                    , 0.0               AS MM_ACC_WHIN_QTY
                 FROM GT_GPWW_ENDING_INV_MM_WW A       /* 과거 실적구간 */
                    , GT_GPWW_ENDING_INV_MM    B       /* 당월말 재고 참조 */
                WHERE B.YYYYMM(+)    = A.YYYYMM
                  AND B.ITEM_ID(+)   = A.ITEM_ID
                  AND B.FROM_SITE(+) = A.FROM_SITE
                  AND B.TO_SITE(+)   = A.TO_SITE
                  AND B.MEASURE(+)   = A.MEASURE
                  AND A.MEASURE      = 'SEMI_INTRANSIT'
                UNION ALL
               /* 실적구간 - 출하(SEMI) for Intransit */
               SELECT C.YYYYPW
                    , C.PW_TO_YMD
                    , C.YYYYMM_LAST_YMD
                    , C.ITEM_ID
                    , C.FROM_SITE
                    , C.TO_SITE
                    , C.OPERATION_GROUP
                    , 0.0               AS MM_BOH_QTY
                    , 0.0               AS MM_EOH_QTY
                    , C.MM_ACC_EXFACTORY_QTY
                    , 0.0               AS MM_ACC_WHIN_QTY
                 FROM GT_GPWW_SHIP_FOR_SEMI_INTRANSIT C  /* 과거 실적구간 */
                WHERE 1=1
                UNION ALL
               /* 실적구간 - 도착(SEMI) for Intransit */
               SELECT D.YYYYPW
                    , D.PW_TO_YMD
                    , D.YYYYMM_LAST_YMD
                    , D.ITEM_ID
                    , D.FROM_SITE
                    , D.TO_SITE
                    , D.OPERATION_GROUP
                    , 0.0               AS MM_BOH_QTY
                    , 0.0               AS MM_EOH_QTY
                    , 0.0               AS MM_ACC_EXFACTORY_QTY
                    , D.MM_ACC_WHIN_QTY AS MM_ACC_WHIN_QTY
                 FROM GT_GPWW_WHIN_FOR_SEMI_INTRANSIT D  /* 과거 실적구간 */
                WHERE 1=1
          )
        SELECT E.YYYYPW
             , E.ITEM_ID
             , 'SEMI_INTRANSIT' AS MEASURE
             , E.FROM_SITE
             , E.TO_SITE
             , '-'              AS INCOTERMS
             , '-'              AS VARIOUS_KEY
             , E.OPERATION_GROUP
             , 'PLANT'          AS TO_SITE_TYPE
             , 0.0              AS FROM_BOH_QTY
             , 0.0              AS TO_BOH_QTY
             , CASE WHEN E.PW_TO_YMD = E.YYYYMM_LAST_YMD
                    THEN SUM(E.MM_EOH_QTY)
                    ELSE SUM(E.MM_BOH_QTY) + SUM(E.MM_ACC_EXFACTORY_QTY) - SUM(E.MM_ACC_WHIN_QTY)
               END              AS QTY
          FROM BASE_DATA E
         WHERE 1=1
         GROUP BY
               E.YYYYPW
             , E.PW_TO_YMD
             , E.YYYYMM_LAST_YMD
             , E.ITEM_ID
             , E.FROM_SITE
             , E.TO_SITE
             , E.OPERATION_GROUP;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales)');
        /* 전주 재고(Intransit)  + 금주출하(Ship Plan) - 금주도착(WH In) */
        /* 전월말 재고를 기초로 하여 당월 출하(Ship Plan)와 도착(Wh In) 누적 정보를 적용하여 계산 */
        /* 고객향(to Sales)  도착(WH In) 실적은 매출(RTF)로 적용함. */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales) - 도착');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_WHIN_FOR_INTRANSIT;

        /* 실적구간 -  도착 (to sales) */
        INSERT
          INTO GT_GPWW_WHIN_FOR_INTRANSIT
             ( YYYYPW
             , PW_TO_YMD
             , YYYYMM
             , YYYYMM_PRVS
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , TO_SITE_TYPE
             , MM_ACC_WHIN_QTY )
        SELECT C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM
             , C.YYYYMM_PRVS
             , C.YYYYMM_FIRST_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , A.TO_SITE
             , A.TO_SITE_TYPE
             , SUM(CASE WHEN B.YYYYMM = C.YYYYMM AND B.YYYYPW <= C.YYYYPW
                        THEN A.QTY
                        ELSE 0.0
                   END) AS MM_ACC_WHIN_QTY
          FROM GT_GPWW_TOBE_GLOBAL_PSI A
             , GT_GPWW_PW_LIST         B
             , GT_GPWW_PW_LIST         C
         WHERE B.YYYYPW       = A.YYYYPW
           AND A.MEASURE      = 'WHIN'
           AND A.TO_SITE_TYPE = 'SALES'
           AND C.YYYYPW       < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
           AND A.YYYYPW       < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
         GROUP BY
               C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM
             , C.YYYYMM_PRVS
             , C.YYYYMM_FIRST_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , A.TO_SITE
             , A.TO_SITE_TYPE;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales) - 출하');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SHIP_FOR_INTRANSIT;

        /* 실적구간 - 출하 (to sales) */
        INSERT
          INTO GT_GPWW_SHIP_FOR_INTRANSIT
             ( YYYYPW
             , PW_TO_YMD
             , YYYYMM
             , YYYYMM_PRVS
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , TO_SITE_TYPE
             , MM_ACC_EXFACTORY_QTY )
        SELECT C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM
             , C.YYYYMM_PRVS
             , C.YYYYMM_FIRST_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , A.TO_SITE
             , A.TO_SITE_TYPE
             , SUM(CASE WHEN B.YYYYMM = C.YYYYMM AND B.YYYYPW <= C.YYYYPW
                        THEN A.QTY
                        ELSE 0.0
                   END) AS MM_ACC_EXFACTORY_QTY
          FROM GT_GPWW_TOBE_GLOBAL_PSI A
             , GT_GPWW_PW_LIST         B
             , GT_GPWW_PW_LIST         C
         WHERE B.YYYYPW       = A.YYYYPW
           AND A.MEASURE      = 'SHIP_PLAN'
           AND A.TO_SITE_TYPE = 'SALES'
           AND C.YYYYPW       < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
           AND A.YYYYPW       < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
         GROUP BY
               C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM
             , C.YYYYMM_PRVS
             , C.YYYYMM_FIRST_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , A.TO_SITE
             , A.TO_SITE_TYPE;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales) measure 추가');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
               ( YYYYPW
               , ITEM_ID
               , MEASURE
               , FROM_SITE
               , TO_SITE
               , INCOTERMS
               , VARIOUS_KEY
               , OPERATION_GROUP
               , TO_SITE_TYPE
               , FROM_BOH_QTY
               , TO_BOH_QTY
               , QTY )
          WITH BASE_DATA AS (
               /* 실적구간 - Intransit 기초재고(전월말) */
               SELECT A.YYYYPW
                    , A.PW_TO_YMD
                    , A.YYYYMM_LAST_YMD
                    , A.ITEM_ID
                    , A.FROM_SITE
                    , A.TO_SITE
                    , A.OPERATION_GROUP
                    , A.YYYYMM_PRVS_QTY AS MM_BOH_QTY
                    , B.QTY             AS MM_EOH_QTY
                    , 0.0               AS MM_ACC_EXFACTORY_QTY
                    , 0.0               AS MM_ACC_WHIN_QTY
                 FROM GT_GPWW_ENDING_INV_MM_WW A       /* 과거 실적구간 */
                    , GT_GPWW_ENDING_INV_MM    B       /* 당월말 재고 참조 */
                WHERE B.YYYYMM(+)    = A.YYYYMM
                  AND B.ITEM_ID(+)   = A.ITEM_ID
                  AND B.FROM_SITE(+) = A.FROM_SITE
                  AND B.TO_SITE(+)   = A.TO_SITE
                  AND B.MEASURE(+)   = A.MEASURE
                  AND A.MEASURE      = 'INTRANSIT'
                UNION ALL
               /* 실적구간 - 출하(FG) for Intransit */
               SELECT C.YYYYPW
                    , C.PW_TO_YMD
                    , C.YYYYMM_LAST_YMD
                    , C.ITEM_ID
                    , C.FROM_SITE
                    , C.TO_SITE
                    , C.OPERATION_GROUP
                    , 0.0               AS MM_BOH_QTY
                    , 0.0               AS MM_EOH_QTY
                    , C.MM_ACC_EXFACTORY_QTY
                    , 0.0               AS MM_ACC_WHIN_QTY
                 FROM GT_GPWW_SHIP_FOR_INTRANSIT C  /* 과거 실적구간 */
                WHERE 1=1
                UNION ALL
               /* 실적구간 - 도착(FG) for Intransit */
               SELECT D.YYYYPW
                    , D.PW_TO_YMD
                    , D.YYYYMM_LAST_YMD
                    , D.ITEM_ID
                    , D.FROM_SITE
                    , D.TO_SITE
                    , D.OPERATION_GROUP
                    , 0.0               AS MM_BOH_QTY
                    , 0.0               AS MM_EOH_QTY
                    , 0.0               AS MM_ACC_EXFACTORY_QTY
                    , D.MM_ACC_WHIN_QTY AS MM_ACC_WHIN_QTY
                 FROM GT_GPWW_WHIN_FOR_INTRANSIT D  /* 과거 실적구간 */
                WHERE 1=1
          )
        SELECT E.YYYYPW
             , E.ITEM_ID
             , 'INTRANSIT'      AS MEASURE
             , E.FROM_SITE
             , E.TO_SITE
             , '-'              AS INCOTERMS
             , '-'              AS VARIOUS_KEY
             , E.OPERATION_GROUP
             , 'SALES'          AS TO_SITE_TYPE
             , 0.0              AS FROM_BOH_QTY
             , 0.0              AS TO_BOH_QTY
             , CASE WHEN E.PW_TO_YMD = E.YYYYMM_LAST_YMD
                    THEN SUM(E.MM_EOH_QTY)
                    ELSE SUM(E.MM_BOH_QTY) + SUM(E.MM_ACC_EXFACTORY_QTY) - SUM(E.MM_ACC_WHIN_QTY)
               END              AS QTY
          FROM BASE_DATA            E
             , GT_GPWW_SCM_MST_SITE F
         WHERE F.SCM_SITE_ID(+) = E.TO_SITE
           AND (F.OPERATION_GROUP IS NULL OR F.OPERATION_GROUP <> 'W') /* to AS Sales Site 제외 */
         GROUP BY
               E.YYYYPW
             , E.PW_TO_YMD
             , E.YYYYMM_LAST_YMD
             , E.ITEM_ID
             , E.FROM_SITE
             , E.TO_SITE
             , E.OPERATION_GROUP;


        /* -------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Intransit 재고(EOH) 계산 참조를 위한 intransit 기초 재고');
        /* -------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_INTRANSIT_BOH;

        INSERT
          INTO GT_GPWW_INTRANSIT_BOH
             ( FROM_SITE
             , TO_SITE
             , INCOTERMS
             , ITEM_ID
             , INT_BOH_QTY )
        SELECT SUBSTR(LOT_ID, FN_CHARINDEX_REV(LOT_ID, '::', 0) + 2, 100)                            AS FROM_SITE
             , SUBSTR(SITE_ID, 1, FN_CHARINDEX_REV(SITE_ID, '~', 0) - 1)                             AS TO_SITE
             , SUBSTR(SITE_ID, FN_CHARINDEX_REV(SITE_ID, '~', 0) + 1, LENGTH(RTRIM(SITE_ID)))        AS INCOTERMS
             , ITEM_ID
             , SUM(QTY)                                                                              AS INT_BOH_QTY
          FROM GT_GPWW_SCP_PLN_TH_ENG_STOCK_PLAN
         WHERE 1=1
           AND DESCR = 'INT'               /* intransit 해상재고 */
         GROUP BY SUBSTR(LOT_ID, FN_CHARINDEX_REV(LOT_ID, '::', 0) + 2, 100)
                , SUBSTR(SITE_ID, 1, FN_CHARINDEX_REV(SITE_ID, '~', 0) - 1)
                , SUBSTR(SITE_ID, FN_CHARINDEX_REV(SITE_ID, '~', 0) + 1, LENGTH(RTRIM(SITE_ID)))
                , ITEM_ID;


        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Intransit 재고(EOH) 계산');
        /* Intransit(EOH) = 해당월 Intransit BOH(전월 Intransit EOH) + 출하(ship plan) - 입고(wh in) */
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_INTRANSIT;

        /*
        SELECT PG.FROM_SITE
              ,PG.TO_SITE
              ,PG.ITEM_ID
              ,PG.INCOTERMS
              ,DI.YYYYPW
              ,ISNULL(BO.INT_BOH_QTY, CONVERT(NUMERIC(20,10), 0))                   AS INT_BOH_QTY  -- plan date 기준 int boh
              ,ISNULL(BO.INT_BOH_QTY, CONVERT(NUMERIC(20,10), 0))
               -SUM(SUM(CASE WHEN PG.MEASURE = 'WH_IN'  THEN QTY    ELSE 0  END))   OVER (PARTITION BY PG.FROM_SITE
                                                                                                          ,PG.TO_SITE
                                                                                                          ,PG.ITEM_ID
                                                                                                          ,PG.INCOTERMS
                                                                                                  ORDER BY DI.YYYYPW)
               +SUM(SUM(CASE WHEN PG.MEASURE = 'SHIP_PLAN' THEN QTY     ELSE 0  END))   OVER (PARTITION BY PG.FROM_SITE
                                                                                                          ,PG.TO_SITE
                                                                                                          ,PG.ITEM_ID
                                                                                                          ,PG.INCOTERMS
                                                                                                  ORDER BY DI.YYYYPW)   AS INT_EOH_QTY -- 해당월 기준 int eoh  (기초재고 - 당월까지 WH In(누적) + 당월까지 Ship Plan(누적))
              ,SUM(CASE WHEN PG.MEASURE = 'WH_IN'       THEN QTY    ELSE 0  END)    AS WH_IN
              ,SUM(SUM(CASE WHEN PG.MEASURE = 'WH_IN'   THEN QTY    ELSE 0  END))   OVER (PARTITION BY PG.FROM_SITE
                                                                                                          ,PG.TO_SITE
                                                                                                          ,PG.ITEM_ID
                                                                                                          ,PG.INCOTERMS
                                                                                                  ORDER BY DI.YYYYPW) AS WH_IN_ACC
              ,SUM(CASE WHEN PG.MEASURE = 'SHIP_PLAN'     THEN PG.QTY   ELSE 0  END)    AS SHIP_PLAN
              ,SUM(SUM(CASE WHEN PG.MEASURE = 'SHIP_PLAN' THEN QTY      ELSE 0  END))   OVER (PARTITION BY PG.FROM_SITE
                                                                                                          ,PG.TO_SITE
                                                                                                          ,PG.ITEM_ID
                                                                                                          ,PG.INCOTERMS
                                                                                                  ORDER BY DI.YYYYPW) AS SHIP_PLAN_ACC
         INTO #INTRANSIT
         FROM #TMP_ASIS_GLOBAL_PSI PG WITH(NOLOCK)
              INNER JOIN #TMP_PW_LIST DI WITH(NOLOCK)
                      ON PG.YYYYPW  = DI.YYYYPW
                     AND DI.YYYYPW >= @V_PLAN_START_YYYYPW  -- 계획 구간
              LEFT JOIN #INTRANSIT_BOH BO WITH(NOLOCK)
                      ON BO.FROM_SITE = PG.FROM_SITE
                     AND BO.TO_SITE   = PG.TO_SITE
                     AND BO.ITEM_ID   = PG.ITEM_ID
                     AND CASE WHEN BO.INCOTERMS = '***'
                              THEN '-'
                              ELSE BO.INCOTERMS
                          END         = PG.INCOTERMS
        WHERE 1=1
          AND PG.MEASURE IN ('WH_IN', 'SHIP_PLAN')
        GROUP BY PG.FROM_SITE
                ,PG.TO_SITE
                ,PG.ITEM_ID
                ,PG.INCOTERMS
                ,DI.YYYYPW
                ,ISNULL(BO.INT_BOH_QTY, CONVERT(NUMERIC(20,10), 0))
        */

        /* @@@ BOH 정보를 Ending Inventory 로 변경 */
        INSERT
          INTO GT_GPWW_INTRANSIT
             ( FROM_SITE
             , TO_SITE
             , ITEM_ID
             , INCOTERMS
             , YYYYPW
             , MEASURE
             , QTY )
        SELECT IA.FROM_SITE
             , IA.TO_SITE
             , IA.ITEM_ID
             , IA.INCOTERMS
             , IA.YYYYPW
             , IA.MEASURE
             , SUM(IA.ACC_QTY)
                   OVER (PARTITION BY IA.ITEM_ID
                                    , IA.FROM_SITE
                                    , IA.TO_SITE
                                    , IA.INCOTERMS
                                    , IA.MEASURE
                             ORDER BY IA.YYYYPW )    AS QTY
          FROM (SELECT IB.FROM_SITE
                     , IB.TO_SITE
                     , IB.ITEM_ID
                     , IB.INCOTERMS
                     , D.YYYYPW
                     , IB.MEASURE
                     , SUM(CASE WHEN D.YYYYPW = IB.YYYYPW THEN
                                     NVL(CASE WHEN IB.YYYYPW = V_PLAN_START_YYYYPW THEN NVL(IC.QTY, 0) - IB.WH_IN + IB.SHIP_PLAN ELSE 0 - IB.WH_IN + IB.SHIP_PLAN END, 0)
                                ELSE 0 END ) AS ACC_QTY
                  FROM (SELECT MAX(A.FROM_SITE) KEEP (DENSE_RANK LAST ORDER BY UPPER(TRANSLATE(A.FROM_SITE, '_-', '/')) NULLS FIRST, A.FROM_SITE NULLS FIRST) AS FROM_SITE  /* @@@ intransit 계산시에는 감안하지 않는다. */ /* MSSQL Latin1_General_CI_AS 비교 재현(대소문자·하이픈 무시, 밑줄은 글자·숫자 앞) */
                             , A.TO_SITE
                             , A.ITEM_ID
                             , '-' AS INCOTERMS    /* ,PG.INCOTERMS  --@@@ intransit 계산시에는 incoterms 감안하지 않는다. */
                             , B.YYYYPW
                             , CASE WHEN C.SITE_TYPE = 'SALES'
                                    THEN 'INTRANSIT'
                                    ELSE 'SEMI_INTRANSIT' END AS MEASURE
                             , SUM(CASE WHEN A.MEASURE = 'WH_IN' THEN A.QTY ELSE 0 END) AS WH_IN
                             , SUM(CASE WHEN A.MEASURE = 'SHIP_PLAN' THEN A.QTY ELSE 0 END) AS SHIP_PLAN
                             , RANK() OVER (PARTITION BY A.ITEM_ID, B.YYYYPW , (CASE WHEN C.SITE_TYPE = 'SALES'
                                                                                     THEN 'INTRANSIT'
                                                                                     ELSE 'SEMI_INTRANSIT' END )
                                            /* ORDER BY PG.FROM_SITE DESC, PG.TO_SITE DESC, PG.INCOTERMS ) AS IDX -- '-' 정보를 뒤로 주기 위해서 */
                                            ORDER BY UPPER(TRANSLATE(A.TO_SITE, '_-', '/')) DESC NULLS LAST, A.TO_SITE DESC NULLS LAST ) AS IDX /* '-' 정보를 뒤로 주기 위해서 */ /* MSSQL Latin1_General_CI_AS 비교 재현(대소문자·하이픈 무시, 밑줄은 글자·숫자 앞) */
                          FROM GT_GPWW_ASIS_GLOBAL_PSI A
                             , GT_GPWW_PW_LIST         B
                             , GT_GPWW_SCM_MST_SITE    C
                         WHERE A.YYYYPW         = B.YYYYPW
                           AND C.SCM_SITE_ID(+) = A.TO_SITE
                           AND A.MEASURE IN ('WH_IN', 'SHIP_PLAN')
                           AND NVL(C.SITE_TYPE || C.OPERATION_GROUP, ' ') <> 'SALESW'
                           AND A.YYYYPW        >= V_PLAN_START_YYYYPW  /* 계획 구간 */
                         GROUP BY /* PG.FROM_SITE,--@@@ intransit 계산시에는 감안하지 않는다. */
                               A.TO_SITE
                             , A.ITEM_ID
                               /* ,PG.INCOTERMS   --@@@ intransit 계산시에는 incoterms 감안하지 않는다. */
                             , B.YYYYPW
                             , CASE WHEN C.SITE_TYPE = 'SALES'
                                    THEN 'INTRANSIT'
                                    ELSE 'SEMI_INTRANSIT' END
                       ) IB
                     , GT_GPWW_PW_LIST D
                     , (SELECT E.ITEM_ID
                             , E.MEASURE
                             , SUM(E.QTY) AS QTY
                          FROM GT_GPWW_TOBE_GLOBAL_PSI E
                         WHERE 1=1
                           AND E.MEASURE IN ('SEMI_INTRANSIT', 'INTRANSIT')
                           AND E.YYYYPW  = V_RESULT_LAST_YYYYPW
                         GROUP BY E.ITEM_ID, E.MEASURE
                       ) IC
                 WHERE IC.ITEM_ID(+) = CASE WHEN IB.IDX = 1 THEN IB.ITEM_ID END  /* 같은 주차에 동일 아이템이 존재할 경우 1순위에만 BOH 부여 (원문 LEFT JOIN ON 절의 PG.IDX = 1) */
                   AND IC.MEASURE(+) = IB.MEASURE
                   AND D.YYYYPW     >= V_PLAN_START_YYYYPW  /* 계획 구간 */
                 GROUP BY IB.FROM_SITE
                        , IB.TO_SITE
                        , IB.ITEM_ID
                        , IB.INCOTERMS
                        , D.YYYYPW
                        , IB.MEASURE
               ) IA
         WHERE 1=1;

        /* ----------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Intransit 재고(EOH) - Intransit BOH만 존재하는 건 반영');
        /* intransit boh만 존재하고 WH_IN/SHIP PLAN이 없는 경우 */
        /* Intransit 기초 재고만 존재하고 도착/출하 정보가 없는 전구간 BOH/EOH 동일한 값으로 추가 */
        /* ----------------------------------------------------------------------------------------------------------------------- */
        /*
        INSERT INTO #INTRANSIT
        SELECT BO.FROM_SITE
              ,BO.TO_SITE
              ,BO.ITEM_ID
              ,CASE WHEN BO.INCOTERMS = '***'
                    THEN '-'
                    ELSE BO.INCOTERMS
               END  AS INCOTERMS
              ,ML.YYYYPW
              ,BO.INT_BOH_QTY
              ,BO.INT_BOH_QTY AS INT_EOH_QTY
              ,0.0  AS WH_IN
              ,0.0  AS WH_IN_ACC
              ,0.0  AS SHIP_PLAN
              ,0.0  AS SHIP_PLAN_ACC
          FROM #INTRANSIT_BOH BO WITH(NOLOCK)
               INNER JOIN #TMP_PW_LIST ML WITH(NOLOCK)
                       ON 1=1
                      AND ML.YYYYPW >= @V_PLAN_START_YYYYPW -- 계획 구간
               LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK)
                       ON TS.SCM_SITE_ID = BO.TO_SITE
         WHERE 1=1
           AND ISNULL(TS.OPERATION_GROUP, '') != 'W' -- to AS Sales Site 제외
           AND NOT EXISTS (SELECT *
                             FROM #INTRANSIT I WITH(NOLOCK)
                            WHERE I.FROM_SITE = BO.FROM_SITE
                              AND I.TO_SITE   = BO.TO_SITE
                              AND I.ITEM_ID   = BO.ITEM_ID
                              AND I.INCOTERMS = CASE WHEN BO.INCOTERMS = '***'
                                                     THEN '-'
                                                     ELSE BO.INCOTERMS
                                                END
                                                )
        */
        /* @@@ BOH 정보를 Ending Inventory 로 변경 */
        /* @@@ 미래계획 기준이 없을 경우 넣어준다. */
        INSERT
          INTO GT_GPWW_INTRANSIT
             ( FROM_SITE
             , TO_SITE
             , ITEM_ID
             , INCOTERMS
             , YYYYPW
             , MEASURE
             , QTY )
        SELECT A.FROM_SITE
             , A.TO_SITE
             , A.ITEM_ID
             , '-' AS INCOTERMS
             , B.YYYYPW
             , A.MEASURE
             , SUM(A.QTY) AS QTY
          FROM GT_GPWW_TOBE_GLOBAL_PSI A
             , GT_GPWW_PW_LIST         B
         WHERE 1=1
           AND NOT EXISTS (SELECT 1
                             FROM GT_GPWW_INTRANSIT SA
                            WHERE 1=1
                              AND SA.ITEM_ID = A.ITEM_ID
                              AND SA.MEASURE = A.MEASURE
                              AND A.MEASURE IN ('SEMI_INTRANSIT', 'INTRANSIT')
                          )
           AND A.MEASURE IN ('SEMI_INTRANSIT', 'INTRANSIT')
           AND B.YYYYPW >= V_PLAN_START_YYYYPW  /* 계획 구간 */
           AND A.YYYYPW  = V_RESULT_LAST_YYYYPW
         GROUP BY A.ITEM_ID, A.OPERATION_GROUP, A.FROM_SITE, A.TO_SITE, A.MEASURE, B.YYYYPW;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory ');
        /* 전주 재고(Pack Inventory)  + 금주생산(Production-pack 해당월 누적) - 금주출하(Pack Ship 해당월 누적) */
        /* 전월말 재고를 기초로 하여 당월 생산과 당월 출하 월누적 정보를 적용하여 계산 */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory - 생산');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_PRODUCTION_FOR_PACK_INV;

        /* 실적구간 - 팩 생산 */
        INSERT
          INTO GT_GPWW_PRODUCTION_FOR_PACK_INV
             ( YYYYPW
             , PW_TO_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , MM_ACC_PROD_QTY )
        SELECT C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , '-'                AS TO_SITE
             , SUM(CASE WHEN B.YYYYMM = C.YYYYMM AND B.YYYYPW <= C.YYYYPW
                        THEN A.QTY
                        ELSE 0.0
                   END)           AS MM_ACC_PROD_QTY
          FROM GT_GPWW_TOBE_GLOBAL_PSI A
             , GT_GPWW_PW_LIST         B
             , GT_GPWW_PW_LIST         C
         WHERE 1=1
           AND B.YYYYPW    = A.YYYYPW
           AND A.MEASURE   = 'PACK_PROD'
           AND C.YYYYPW    < V_PLAN_START_YYYYPW   /* 과거 실적 구간 */
           AND A.YYYYPW    < V_PLAN_START_YYYYPW   /* 과거 실적 구간 */
         GROUP BY
               C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory - 출하');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SHIP_FOR_PACK_INV;

        /* 실적구간 - 팩출하 */
        INSERT
          INTO GT_GPWW_SHIP_FOR_PACK_INV
             ( YYYYPW
             , PW_TO_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , MM_ACC_EXFACTORY_QTY )
        SELECT C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , '-'                AS TO_SITE
             , SUM(CASE WHEN B.YYYYMM = C.YYYYMM AND B.YYYYPW <= C.YYYYPW
                        THEN A.QTY
                        ELSE 0.0
                   END)           AS MM_ACC_EXFACTORY_QTY
          FROM GT_GPWW_TOBE_GLOBAL_PSI A
             , GT_GPWW_PW_LIST         B
             , GT_GPWW_PW_LIST         C
         WHERE 1=1
           AND B.YYYYPW          = A.YYYYPW
           AND A.MEASURE         IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')
           AND A.OPERATION_GROUP = 'P'                     /* 팩출하 */
           AND C.YYYYPW          < V_PLAN_START_YYYYPW     /* 과거 실적 구간 */
           AND A.YYYYPW          < V_PLAN_START_YYYYPW     /* 과거 실적 구간 */
         GROUP BY
               C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory measure 추가');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
               ( YYYYPW
               , ITEM_ID
               , MEASURE
               , FROM_SITE
               , TO_SITE
               , INCOTERMS
               , VARIOUS_KEY
               , OPERATION_GROUP
               , TO_SITE_TYPE
               , FROM_BOH_QTY
               , TO_BOH_QTY
               , QTY )
          WITH BASE_DATA AS (
               /* 실적구간 - Pack Inventory 기초재고(전월말) */
               SELECT A.YYYYPW
                    , A.PW_TO_YMD
                    , A.YYYYMM_LAST_YMD
                    , A.ITEM_ID
                    , A.FROM_SITE
                    , A.TO_SITE
                    , A.OPERATION_GROUP
                    , A.YYYYMM_PRVS_QTY   AS MM_BOH_QTY
                    , B.QTY               AS MM_EOH_QTY
                    , 0.0                 AS MM_ACC_EXFACTORY_QTY
                    , 0.0                 AS MM_ACC_PROD_QTY
                 FROM GT_GPWW_ENDING_INV_MM_WW A           /* 과거 실적구간 */
                    , GT_GPWW_ENDING_INV_MM    B           /* 당월말 재고 참조 */
                WHERE 1=1
                  AND B.YYYYMM(+)    = A.YYYYMM
                  AND B.ITEM_ID(+)   = A.ITEM_ID
                  AND B.FROM_SITE(+) = A.FROM_SITE
                  AND B.TO_SITE(+)   = A.TO_SITE
                  AND B.MEASURE(+)   = A.MEASURE
                  AND A.MEASURE      = 'PACK_EOH'
                UNION ALL
               /* 실적구간 - 출하(FG) for  Pack Inventory */
               SELECT C.YYYYPW
                    , C.PW_TO_YMD
                    , C.YYYYMM_LAST_YMD
                    , C.ITEM_ID
                    , C.FROM_SITE
                    , C.TO_SITE
                    , C.OPERATION_GROUP
                    , 0.0                 AS MM_BOH_QTY
                    , 0.0                 AS MM_EOH_QTY
                    , C.MM_ACC_EXFACTORY_QTY
                    , 0.0                 AS MM_ACC_PROD_QTY
                 FROM GT_GPWW_SHIP_FOR_PACK_INV C          /* 과거 실적구간 */
                WHERE 1=1
                UNION ALL
               /* 실적구간 - 팩 생산 for Pack Inventory */
               SELECT D.YYYYPW
                    , D.PW_TO_YMD
                    , D.YYYYMM_LAST_YMD
                    , D.ITEM_ID
                    , D.FROM_SITE
                    , D.TO_SITE
                    , D.OPERATION_GROUP
                    , 0.0                 AS MM_BOH_QTY
                    , 0.0                 AS MM_EOH_QTY
                    , 0.0                 AS MM_ACC_EXFACTORY_QTY
                    , D.MM_ACC_PROD_QTY
                 FROM GT_GPWW_PRODUCTION_FOR_PACK_INV D    /* 과거 실적구간 */
                WHERE 1=1
                UNION ALL
               SELECT E.YYYYPW
                    , F.PW_TO_YMD
                    , F.YYYYMM_LAST_YMD
                    , E.ITEM_ID
                    , E.FROM_SITE
                    , E.TO_SITE
                    , E.OPERATION_GROUP
                    , 0.0                 AS MM_BOH_QTY
                    , 0.0                 AS MM_EOH_QTY
                    , E.QTY               AS MM_ACC_EXFACTORY_QTY
                    , 0.0                 AS MM_ACC_PROD_QTY
                 FROM GT_GPWW_ASIS_GLOBAL_PSI E
                    , GT_GPWW_PW_LIST         F
                WHERE 1=1
                  AND E.YYYYPW          = F.YYYYPW
                  AND E.MEASURE         = 'AS_IN_PLAN'
                  AND E.OPERATION_GROUP = 'P'                  /* Cell */
                  AND E.YYYYPW          < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
        )
        SELECT G.YYYYPW
             , G.ITEM_ID
             , 'PACK_EOH'         AS MEASURE
             , G.FROM_SITE
             , '-'                AS TO_SITE
             , '-'                AS INCOTERMS
             , '-'                AS VARIOUS_KEY
             , G.OPERATION_GROUP
             , '-'                AS TO_SITE_TYPE
             , 0.0                AS FROM_BOH_QTY
             , 0.0                AS TO_BOH_QTY
             , CASE WHEN G.PW_TO_YMD = G.YYYYMM_LAST_YMD
                    THEN SUM(G.MM_EOH_QTY)
                    ELSE SUM(G.MM_BOH_QTY) + SUM(G.MM_ACC_PROD_QTY) - SUM(G.MM_ACC_EXFACTORY_QTY)
               END                AS QTY
          FROM BASE_DATA G
         WHERE 1=1
         GROUP BY
               G.YYYYPW
             , G.PW_TO_YMD
             , G.YYYYMM_LAST_YMD
             , G.ITEM_ID
             , G.FROM_SITE
             , G.OPERATION_GROUP;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장)');
        /* 전주 재고(Cell Inventory)  + 금주도착(Semi WH In) -  금주생산(Production)/팩수율 */
        /* 전월말 재고를 기초로 하여 해당월 도착/생산 월누적 정보를 적용하여 계산 */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        /*
        모듈 공장의 Cell Inventory는
        P = 전주 재고(Cell Inventory) + 금주도착(Semi WH In) - 금주생산(Production)/팩수율
        자작 공장 무시하고, 위의 P가 마이너스이면, P=0으로 표시하고, 그 마이너스(P) 수량 만큼 동일 Plant의 셀 공장 measure에서 빼기

        셀 공장의 Cell Inventory는
        A = 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) + P (If P가 마이너스 경우만, 동일 공장에서 빼기)
        */


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Cell도착 ');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SEMI_WHIN_FOR_CELL_INV;

        /* 실적구간 - Cell 도착 (to Plant) - to 사이트 기준 */
        INSERT
          INTO GT_GPWW_SEMI_WHIN_FOR_CELL_INV
             ( YYYYPW
             , PW_TO_YMD
             , YYYYMM
             , YYYYMM_PRVS
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , OPERATION_GROUP
             , TO_SITE
             , WHIN_QTY )
        SELECT D.YYYYPW
             , D.PW_TO_YMD
             , D.YYYYMM
             , D.YYYYMM_PRVS
             , D.YYYYMM_FIRST_YMD
             , D.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.TO_SITE
             , SUM(CASE WHEN C.YYYYMM = D.YYYYMM AND C.YYYYPW = D.YYYYPW   /* 20240327 해당월 주 누적이 아닌 해당 주차 */
                        THEN A.QTY
                        ELSE 0.0
                   END)           AS WHIN_QTY                                /* 20240327 해당월 주 누적이 아닌 해당 주차 */
          FROM GT_GPWW_TOBE_GLOBAL_PSI A
             , GT_GPWW_SCM_MST_SITE    B
             , GT_GPWW_PW_LIST         C
             , GT_GPWW_PW_LIST         D
         WHERE 1=1
           AND B.SCM_SITE_ID     = A.TO_SITE
           AND C.YYYYPW          = A.YYYYPW
           AND B.OPERATION_GROUP = 'P'                     /* Pack plant */
           AND A.MEASURE         = 'SEMI_WHIN'
           AND A.OPERATION_GROUP = 'A'                     /* Cell */
           AND D.YYYYPW          < V_PLAN_START_YYYYPW     /* 과거 실적 구간 */
           AND A.YYYYPW          < V_PLAN_START_YYYYPW     /* 과거 실적 구간 */
         GROUP BY
               D.YYYYPW
             , D.PW_TO_YMD
             , D.YYYYMM
             , D.YYYYMM_PRVS
             , D.YYYYMM_FIRST_YMD
             , D.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.TO_SITE;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) measure 계산 ');
        /* 전주 재고(Cell Inventory)  + 금주도착(Semi WH In) -  금주생산(Production)/팩수율 */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_PACK_CELL_EOH_RESULT;

        INSERT
          INTO GT_GPWW_PACK_CELL_EOH_RESULT
             ( MM_WW_SEQ_MAX
             , MM_WW_SEQ
             , YYYYPW
             , YYYYMM
             , PW_TO_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , MM_EOH_QTY
             , MM_BOH_QTY
             , WHIN_QTY
             , PACK_PROD_QTY )
          WITH BASE_DATA AS (
               /* 실적구간 - Pack공장 Cell 기초재고(전월말) */
               SELECT A.YYYYPW
                    , A.YYYYMM
                    , A.PW_TO_YMD
                    , A.YYYYMM_LAST_YMD
                    , A.ITEM_ID
                    , A.FROM_SITE
                    , A.OPERATION_GROUP
                    , A.YYYYMM_PRVS_QTY   AS MM_BOH_QTY            /* 전월말 기말재고 */
                    , B.QTY               AS MM_EOH_QTY            /* 당월말 기말재고 */
                    , 0.0                 AS WHIN_QTY              /* 20240327 변경 */
                    , 0.0                 AS PACK_PROD_QTY         /* 20240327 변경 */
                 FROM GT_GPWW_ENDING_INV_MM_WW A           /* 과거 실적구간 */
                    , GT_GPWW_ENDING_INV_MM    B           /* 당월말 재고 참조 */
                WHERE 1=1
                  AND B.YYYYMM(+)    = A.YYYYMM
                  AND B.ITEM_ID(+)   = A.ITEM_ID
                  AND B.FROM_SITE(+) = A.FROM_SITE
                  AND B.TO_SITE(+)   = A.TO_SITE
                  AND B.MEASURE(+)   = A.MEASURE
                  AND A.MEASURE      = 'PACK_CELL_EOH'
                UNION ALL
               /* 실적구간 - Pack Plant Cell 도착 실적 */
               SELECT C.YYYYPW
                    , C.YYYYMM
                    , C.PW_TO_YMD
                    , C.YYYYMM_LAST_YMD
                    , C.ITEM_ID
                    , C.TO_SITE           AS FROM_SITE
                    , C.OPERATION_GROUP
                    , 0.0                 AS MM_BOH_QTY
                    , 0.0                 AS MM_EOH_QTY
                    , C.WHIN_QTY                                   /* 20240327 변경 */
                    , 0.0                 AS PACK_PROD_QTY         /* 20240327 변경 */
                 FROM GT_GPWW_SEMI_WHIN_FOR_CELL_INV C     /* 과거 실적구간 */
                WHERE 1=1
                UNION ALL
               /* 실적구간 - Pack 생산계획(수율역적용 -투입 기준) -> Cell 환산 */
               SELECT D.YYYYPW
                    , D.YYYYMM
                    , D.PW_TO_YMD
                    , D.YYYYMM_LAST_YMD
                    , D.REP_CELL_ITEM_ID  AS ITEM_ID
                    , D.FROM_SITE
                    , 'A'                 AS OPERATION_GROUP
                    , 0.0                 AS MM_BOH_QTY
                    , 0.0                 AS MM_EOH_QTY
                    , 0.0                 AS WHIN_QTY                                         /* 20240327 변경 */
                    , SUM(D.PACK_PROD_YIELD_QTY * NVL(D.CELL_CF, 1.1))  AS PACK_PROD_QTY    /* 20240327 변경 */
                 FROM GT_GPWW_PACK_PRODUCTION_RESULT_3 D   /* 과거 실적구간 */
                WHERE 1=1
                  AND D.REP_CELL_ITEM_ID IS NOT NULL
                GROUP BY
                      D.YYYYPW
                    , D.YYYYMM
                    , D.PW_TO_YMD
                    , D.YYYYMM_LAST_YMD
                    , D.REP_CELL_ITEM_ID
                    , D.FROM_SITE
        )
        , PACK_CELL_EOH_RESULT AS (
               SELECT E.YYYYPW
                    , E.YYYYMM
                    , E.PW_TO_YMD
                    , E.YYYYMM_LAST_YMD
                    , E.ITEM_ID
                    , E.FROM_SITE
                    , '-'                 AS TO_SITE
                    , '-'                 AS INCOTERMS
                    , '-'                 AS VARIOUS_KEY
                    , E.OPERATION_GROUP
                    , '-'                 AS TO_SITE_TYPE
                    , 0.0                 AS FROM_BOH_QTY
                    , 0.0                 AS TO_BOH_QTY
                    , SUM(E.MM_EOH_QTY)   AS MM_EOH_QTY
                    , SUM(E.MM_BOH_QTY)   AS MM_BOH_QTY
                    , SUM(E.WHIN_QTY)     AS WHIN_QTY              /* 20240327 변경 */
                    , SUM(E.PACK_PROD_QTY) AS PACK_PROD_QTY        /* 20240327 변경 */
                    /* 20240327 주석처리   ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD */
                    /* 20240327 주석처리 		THEN SUM(MM_EOH_QTY) */
                    /* 20240327 주석처리 		ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_WHIN_QTY) - SUM(MM_ACC_PACK_PROD_QTY) */
                    /* 20240327 주석처리 	END			AS QTY */
                 FROM BASE_DATA E
                WHERE 1=1
                GROUP BY
                      E.YYYYPW
                    , E.YYYYMM
                    , E.PW_TO_YMD
                    , E.YYYYMM_LAST_YMD
                    , E.ITEM_ID
                    , E.FROM_SITE
                    , E.OPERATION_GROUP
        )
        SELECT MAX(IA.MM_WW_SEQ) OVER (PARTITION BY IA.ITEM_ID
                                                  , IA.FROM_SITE
                                                  , IA.YYYYMM)   AS MM_WW_SEQ_MAX
             , IA.MM_WW_SEQ
             , IA.YYYYPW
             , IA.YYYYMM
             , IA.PW_TO_YMD
             , IA.YYYYMM_LAST_YMD
             , IA.ITEM_ID
             , IA.FROM_SITE
             , IA.TO_SITE
             , IA.INCOTERMS
             , IA.VARIOUS_KEY
             , IA.OPERATION_GROUP
             , IA.TO_SITE_TYPE
             , IA.FROM_BOH_QTY
             , IA.TO_BOH_QTY
             , IA.MM_EOH_QTY
             , IA.MM_BOH_QTY
             , IA.WHIN_QTY
             , IA.PACK_PROD_QTY
          FROM (SELECT ROW_NUMBER() OVER (PARTITION BY F.ITEM_ID
                                                     , F.FROM_SITE
                                                     , F.YYYYMM
                                              ORDER BY F.YYYYPW NULLS FIRST) AS MM_WW_SEQ
                     , F.YYYYPW
                     , F.YYYYMM
                     , F.PW_TO_YMD
                     , F.YYYYMM_LAST_YMD
                     , F.ITEM_ID
                     , F.FROM_SITE
                     , F.TO_SITE
                     , F.INCOTERMS
                     , F.VARIOUS_KEY
                     , F.OPERATION_GROUP
                     , F.TO_SITE_TYPE
                     , F.FROM_BOH_QTY
                     , F.TO_BOH_QTY
                     , F.MM_EOH_QTY
                     , F.MM_BOH_QTY
                     , F.WHIN_QTY
                     , F.PACK_PROD_QTY
                  FROM PACK_CELL_EOH_RESULT F
                 WHERE 1=1) IA
         WHERE 1=1;


        /* ---------------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) measure 계산 결과 조정 (마이너스 수량)');
        /* 월별 마지막주는 조정 대상에서 제외 (월 기말재고와 동일) */
        /* 월별 둘째주부터 전주 마이너스 수량을 0으로 보정된 기준으로 당주 재고 수량 보정 */
        /* ---------------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_PACK_CELL_EOH_RESULT_ADJ;

        /* 20240327 변경전
        ;WITH RECURSIVE_DATA AS (
            SELECT A.MM_WW_SEQ
                  ,A.YYYYPW
                  ,A.YYYYMM
                  ,A.PW_TO_YMD
                  ,A.YYYYMM_LAST_YMD
                  ,A.ITEM_ID
                  ,A.FROM_SITE
                  ,A.QTY	AS ORG_QTY
                  ,A.QTY
                  ,A.MM_EOH_QTY
                  ,A.MM_BOH_QTY
                  ,A.MM_ACC_WHIN_QTY
                  ,A.MM_ACC_PACK_PROD_QTY
                  ,A.MM_WW_SEQ_MAX
                  ,CASE WHEN A.QTY < 0
                        THEN A.QTY
                        ELSE 0.0
                    END AS ACC_ADJ_QTY
             FROM #PACK_CELL_EOH_RESULT  A WITH(NOLOCK)
            WHERE 1=1
              AND A.MM_WW_SEQ = 1
            UNION ALL
            SELECT A.MM_WW_SEQ
                  ,A.YYYYPW
                  ,A.YYYYMM
                  ,A.PW_TO_YMD
                  ,A.YYYYMM_LAST_YMD
                  ,A.ITEM_ID
                  ,A.FROM_SITE
                  ,A.QTY	AS ORG_QTY
                  ,CASE WHEN A.MM_WW_SEQ = A.MM_WW_SEQ_MAX
                        THEN A.QTY
                        ELSE A.QTY - P.ACC_ADJ_QTY
                    END AS QTY
                  ,A.MM_EOH_QTY
                  ,A.MM_BOH_QTY
                  ,A.MM_ACC_WHIN_QTY
                  ,A.MM_ACC_PACK_PROD_QTY
                  ,A.MM_WW_SEQ_MAX
                  ,CASE WHEN A.QTY - P.ACC_ADJ_QTY  < 0 and A.MM_WW_SEQ != A.MM_WW_SEQ_MAX -- 마지막 주차 제외
                        THEN A.QTY
                        ELSE P.ACC_ADJ_QTY
                    END ACC_ADJ_QTY
              FROM RECURSIVE_DATA p
                   INNER JOIN #PACK_CELL_EOH_RESULT  A WITH(NOLOCK)
                           ON A.MM_WW_SEQ = P.MM_WW_SEQ + 1
                          AND A.ITEM_ID	  = P.ITEM_ID
                          AND A.FROM_SITE = P.FROM_SITE
                          AND A.YYYYMM    = P.YYYYMM
            WHERE 1=1
        )
        SELECT *
         INTO #PACK_CELL_EOH_RESULT_ADJ
         FROM RECURSIVE_DATA  A
        WHERE 1=1
*/

        INSERT
          INTO GT_GPWW_PACK_CELL_EOH_RESULT_ADJ
             ( MM_WW_SEQ
             , YYYYPW
             , YYYYMM
             , PW_TO_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , FROM_SITE
             , BOH_QTY
             , WHIN_QTY
             , PACK_PROD_QTY
             , EOH_QTY
             , MM_WW_SEQ_MAX
             , ADJ_QTY_P )
          WITH RECURSIVE_DATA
             ( MM_WW_SEQ
             , YYYYPW
             , YYYYMM
             , PW_TO_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , FROM_SITE
             , BOH_QTY
             , WHIN_QTY
             , PACK_PROD_QTY
             , EOH_QTY
             , MM_WW_SEQ_MAX
             , ADJ_QTY_P ) AS (
               SELECT A.MM_WW_SEQ
                    , A.YYYYPW
                    , A.YYYYMM
                    , A.PW_TO_YMD
                    , A.YYYYMM_LAST_YMD
                    , A.ITEM_ID
                    , A.FROM_SITE
                    , A.MM_BOH_QTY        AS BOH_QTY
                    , A.WHIN_QTY
                    , A.PACK_PROD_QTY
                    , CASE WHEN A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0
                           THEN 0
                           ELSE A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
                      END                 AS EOH_QTY
                    , A.MM_WW_SEQ_MAX
                    , CASE WHEN A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0
                           THEN A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
                           ELSE 0
                      END                 AS ADJ_QTY_P
                 FROM GT_GPWW_PACK_CELL_EOH_RESULT A
                WHERE 1=1
                  AND A.MM_WW_SEQ = 1
                UNION ALL
               SELECT C.MM_WW_SEQ
                    , C.YYYYPW
                    , C.YYYYMM
                    , C.PW_TO_YMD
                    , C.YYYYMM_LAST_YMD
                    , C.ITEM_ID
                    , C.FROM_SITE
                    , B.EOH_QTY           AS BOH_QTY   /* 전주 EOH -> 당주 BOH */
                    , C.WHIN_QTY
                    , C.PACK_PROD_QTY
                    , CASE WHEN C.MM_WW_SEQ = C.MM_WW_SEQ_MAX AND C.PW_TO_YMD = C.YYYYMM_LAST_YMD   /* 해당월 마지막 주차( 말일기준 추가) */
                           THEN C.MM_EOH_QTY
                           WHEN B.EOH_QTY + C.WHIN_QTY - C.PACK_PROD_QTY < 0
                           THEN 0
                           ELSE B.EOH_QTY + C.WHIN_QTY - C.PACK_PROD_QTY
                      END                 AS EOH_QTY
                    , C.MM_WW_SEQ_MAX
                    , CASE WHEN C.MM_WW_SEQ = C.MM_WW_SEQ_MAX AND C.PW_TO_YMD = C.YYYYMM_LAST_YMD AND C.MM_EOH_QTY = 0 AND B.EOH_QTY + C.WHIN_QTY - C.PACK_PROD_QTY < 0   /* 해당월 마지막 주차 */
                           THEN B.EOH_QTY + C.WHIN_QTY - C.PACK_PROD_QTY
                           WHEN C.MM_WW_SEQ = C.MM_WW_SEQ_MAX   /* 해당월 마지막 주차 */
                           THEN 0
                           WHEN B.EOH_QTY + C.WHIN_QTY - C.PACK_PROD_QTY < 0
                           THEN B.EOH_QTY + C.WHIN_QTY - C.PACK_PROD_QTY
                           ELSE 0
                      END                 AS ADJ_QTY_P
                 FROM RECURSIVE_DATA               B
                    , GT_GPWW_PACK_CELL_EOH_RESULT C
                WHERE 1=1
                  AND C.MM_WW_SEQ = B.MM_WW_SEQ + 1
                  AND C.ITEM_ID   = B.ITEM_ID
                  AND C.FROM_SITE = B.FROM_SITE
                  AND C.YYYYMM    = B.YYYYMM
        )
        SELECT D.MM_WW_SEQ
             , D.YYYYPW
             , D.YYYYMM
             , D.PW_TO_YMD
             , D.YYYYMM_LAST_YMD
             , D.ITEM_ID
             , D.FROM_SITE
             , D.BOH_QTY
             , D.WHIN_QTY
             , D.PACK_PROD_QTY
             , D.EOH_QTY
             , D.MM_WW_SEQ_MAX
             , D.ADJ_QTY_P
          FROM RECURSIVE_DATA D
         WHERE 1=1;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) measure 추가 ');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
             ( YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT YYYYPW
             , ITEM_ID
             , 'PACK_CELL_EOH'    AS MEASURE
             , FROM_SITE
             , '-'                AS TO_SITE
             , '-'                AS INCOTERMS
             , '-'                AS VARIOUS_KEY
             , 'A'                AS OPERATION_GROUP
             , '-'                AS TO_SITE_TYPE
             , 0.0                AS FROM_BOH_QTY
             , 0.0                AS TO_BOH_QTY
             , EOH_QTY            /* 20240327 */
            /* 20240327 변경   ,CASE WHEN PR.QTY < 0 */
            /* 20240327 변경 		THEN 0.0 */
            /* 20240327 변경 		ELSE PR.QTY */
            /* 20240327 변경 	END	AS QTY */
          FROM GT_GPWW_PACK_CELL_EOH_RESULT_ADJ
         WHERE 1=1;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)');
        /* 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) + P (If P가 마이너스 경우만, 동일 공장에서 빼기) */
        /* 전월말 재고를 기초로 하여 해당월 생산/출하 월누적 정보를 적용하여 계산 */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        /*
        모듈 공장의 Cell Inventory는
        P = 전주 재고(Cell Inventory) + 금주도착(Semi WH In) - 금주생산(Production)/팩수율
        자작 공장 무시하고, 위의 P가 마이너스이면, P=0으로 표시하고, 그 마이너스(P) 수량 만큼 동일 Plant의 셀 공장 measure에서 빼기

        셀 공장의 Cell Inventory는
        A = 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) + P (If P가 마이너스 경우만, 동일 공장에서 빼기)
        */


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장) - Char Plan');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_CELL_CHAR_FOR_CELL_INV;

        /* 실적구간 - 셀 특성 생산 실적 */
        INSERT
          INTO GT_GPWW_CELL_CHAR_FOR_CELL_INV
             ( YYYYPW
             , PW_TO_YMD
             , YYYYMM
             , YYYYMM_PRVS
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , MM_ACC_CELL_CHAR_QTY )
        SELECT C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM
             , C.YYYYMM_PRVS
             , C.YYYYMM_FIRST_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , SUM(CASE WHEN B.YYYYMM = C.YYYYMM AND B.YYYYPW <= C.YYYYPW
                        THEN A.QTY
                        ELSE 0.0
                   END)           AS MM_ACC_CELL_CHAR_QTY
          FROM GT_GPWW_TOBE_GLOBAL_PSI A
             , GT_GPWW_PW_LIST         B
             , GT_GPWW_PW_LIST         C
         WHERE 1=1
           AND B.YYYYPW  = A.YYYYPW
           AND A.MEASURE = 'CELL_CHAR_PLAN'
           AND C.YYYYPW  < V_PLAN_START_YYYYPW     /* 과거 실적 구간 */
           AND A.YYYYPW  < V_PLAN_START_YYYYPW     /* 과거 실적 구간 */
         GROUP BY
               C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM
             , C.YYYYMM_PRVS
             , C.YYYYMM_FIRST_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장) - 출하');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SHIP_FOR_CELL_INV;

        /* 실적구간 - Cell 출하 */
        INSERT
          INTO GT_GPWW_SHIP_FOR_CELL_INV
             ( YYYYPW
             , PW_TO_YMD
             , YYYYMM
             , YYYYMM_PRVS
             , YYYYMM_FIRST_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , MM_ACC_EXFACTORY_QTY )
        SELECT C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM
             , C.YYYYMM_PRVS
             , C.YYYYMM_FIRST_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , '-'                AS TO_SITE
             , SUM(CASE WHEN B.YYYYMM = C.YYYYMM AND B.YYYYPW <= C.YYYYPW
                        THEN A.QTY
                        ELSE 0.0
                   END)           AS MM_ACC_EXFACTORY_QTY
          FROM GT_GPWW_TOBE_GLOBAL_PSI A
             , GT_GPWW_PW_LIST         B
             , GT_GPWW_PW_LIST         C
         WHERE 1=1
           AND B.YYYYPW          = A.YYYYPW
           AND A.MEASURE         IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')
           AND A.OPERATION_GROUP = 'A'                     /* Cell 출하 */
           AND C.YYYYPW          < V_PLAN_START_YYYYPW     /* 과거 실적 구간 */
           AND A.YYYYPW          < V_PLAN_START_YYYYPW     /* 과거 실적 구간 */
         GROUP BY
               C.YYYYPW
             , C.PW_TO_YMD
             , C.YYYYMM
             , C.YYYYMM_PRVS
             , C.YYYYMM_FIRST_YMD
             , C.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE;




        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)  - P (팩공장 셀재고 마이너스 수량)');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_PACK_PROD_FOR_CELL_PLANT_INV;

        INSERT
          INTO GT_GPWW_PACK_PROD_FOR_CELL_PLANT_INV
             ( YYYYPW
             , YYYYMM
             , PW_TO_YMD
             , YYYYMM_LAST_YMD
             , ITEM_ID
             , FROM_SITE
             , ADJ_QTY_P )
        SELECT A.YYYYPW
             , A.YYYYMM
             , A.PW_TO_YMD
             , A.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.FROM_SITE
             , SUM(B.ADJ_QTY_P)   AS ADJ_QTY_P   /* - 20240327 */
             /* - 20240327 ,SUM(CASE WHEN AP.QTY < 0 THEN AP.QTY ELSE 0.0 END) AS QTY */
          FROM GT_GPWW_PACK_CELL_EOH_RESULT_ADJ A
             , GT_GPWW_PACK_CELL_EOH_RESULT_ADJ B
         WHERE 1=1
           AND B.YYYYMM(+)    = A.YYYYMM
           AND B.ITEM_ID(+)   = A.ITEM_ID
           AND B.FROM_SITE(+) = A.FROM_SITE
           AND B.YYYYPW(+)   <= A.YYYYPW
         GROUP BY
               A.YYYYPW
             , A.YYYYMM
             , A.PW_TO_YMD
             , A.YYYYMM_LAST_YMD
             , A.ITEM_ID
             , A.FROM_SITE
        HAVING SUM(B.ADJ_QTY_P) <> 0;
        /* 20240327 HAVING SUM(CASE WHEN AP.QTY < 0 THEN AP.QTY ELSE 0.0 END) != 0 */


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)  measure 추가');
        /* 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) */
        /*           + P (If P가 마이너스 경우만, 동일 공장에서 빼기) */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM GT_GPWW_TOBE_GLOBAL_PSI
         WHERE 1=1
           AND MEASURE = 'CELL_EOH';

        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
               ( YYYYPW
               , ITEM_ID
               , MEASURE
               , FROM_SITE
               , TO_SITE
               , INCOTERMS
               , VARIOUS_KEY
               , OPERATION_GROUP
               , TO_SITE_TYPE
               , FROM_BOH_QTY
               , TO_BOH_QTY
               , QTY )
          WITH BASE_DATA AS (
               /* 실적구간 - 셀공장 Cell 기초 재고(전월말) */
               SELECT A.YYYYPW
                    , A.PW_TO_YMD
                    , A.YYYYMM_LAST_YMD
                    , A.ITEM_ID
                    , A.FROM_SITE
                    , A.OPERATION_GROUP
                    , A.YYYYMM_PRVS_QTY   AS MM_BOH_QTY            /* 전월말 기말재고 */
                    , B.QTY               AS MM_EOH_QTY            /* 당월말 기말재고 */
                    , 0.0                 AS MM_ACC_PROD_QTY
                    , 0.0                 AS MM_ACC_SHIP_QTY
                 FROM GT_GPWW_ENDING_INV_MM_WW A           /* 과거 실적구간 */
                    , GT_GPWW_ENDING_INV_MM    B           /* 당월말 재고 참조 */
                WHERE 1=1
                  AND B.YYYYMM(+)    = A.YYYYMM
                  AND B.ITEM_ID(+)   = A.ITEM_ID
                  AND B.FROM_SITE(+) = A.FROM_SITE
                  AND B.TO_SITE(+)   = A.TO_SITE
                  AND B.MEASURE(+)   = A.MEASURE
                  AND A.MEASURE      = 'CELL_EOH'
                UNION ALL
               /* 실적구간 - Production(PKG) */
               SELECT C.YYYYPW
                    , C.PW_TO_YMD
                    , C.YYYYMM_LAST_YMD
                    , C.ITEM_ID
                    , C.FROM_SITE
                    , C.OPERATION_GROUP
                    , 0.0                    AS MM_BOH_QTY
                    , 0.0                    AS MM_EOH_QTY
                    , C.MM_ACC_CELL_CHAR_QTY AS MM_ACC_PROD_QTY
                    , 0.0                    AS MM_ACC_SHIP_QTY
                 FROM GT_GPWW_CELL_CHAR_FOR_CELL_INV C     /* 과거 실적구간 */
                WHERE 1=1
                UNION ALL
               /* 실적구간 - Cell Char */
               SELECT D.YYYYPW
                    , D.PW_TO_YMD
                    , D.YYYYMM_LAST_YMD
                    , D.ITEM_ID
                    , D.FROM_SITE
                    , D.OPERATION_GROUP
                    , 0.0                    AS MM_BOH_QTY
                    , 0.0                    AS MM_EOH_QTY
                    , 0.0                    AS MM_ACC_PROD_QTY
                    , D.MM_ACC_EXFACTORY_QTY AS MM_ACC_SHIP_QTY
                 FROM GT_GPWW_SHIP_FOR_CELL_INV D          /* 과거 실적구간 */
                WHERE 1=1
                UNION ALL
               /* + P (If P가 마이너스 경우만, 동일 공장에서 빼기) */
               SELECT E.YYYYPW
                    , E.PW_TO_YMD
                    , E.YYYYMM_LAST_YMD
                    , E.ITEM_ID
                    , NVL(G.SCM_SITE_ID, NVL(H.CELL_SITE_PAST, H.CELL_SITE_FUTURE))   AS FROM_SITE   /* cell plant */
                    , 'A'                    AS OPERATION_GROUP
                    , 0.0                    AS MM_BOH_QTY
                    , 0.0                    AS MM_EOH_QTY
                    , E.ADJ_QTY_P            AS MM_ACC_PROD_QTY   /* P: 음수값  20240327 변경 */
                    , 0.0                    AS MM_ACC_SHIP_QTY
                 FROM GT_GPWW_PACK_PROD_FOR_CELL_PLANT_INV E
                    , GT_GPWW_SCM_MST_SITE                 F   /* pack plant site */
                    , GT_GPWW_SCM_MST_SITE                 G   /* cell plant site */
                    , GT_GPWW_ITEM_SEMI_SHIP_SITE          H
                WHERE 1=1
                  AND F.SCM_SITE_ID        = E.FROM_SITE
                  AND G.PLANT_ID(+)        = F.PLANT_ID
                  AND H.ITEM_ID(+)         = E.ITEM_ID
                  AND H.PACK_SITE(+)       = F.SCM_SITE_ID   /* pack site */
                  AND G.OPERATION_GROUP(+) = 'A'
                  AND G.SITE_TYPE(+)       = 'PLANT'
                  /* - 20240327 불필요 조건 삭제 */
                  AND NVL(G.SCM_SITE_ID, NVL(H.CELL_SITE_PAST, H.CELL_SITE_FUTURE)) IS NOT NULL
                UNION ALL
               SELECT I.YYYYPW
                    , J.PW_TO_YMD
                    , J.YYYYMM_LAST_YMD
                    , I.ITEM_ID
                    , I.FROM_SITE
                    , I.OPERATION_GROUP
                    , 0.0                    AS MM_BOH_QTY
                    , 0.0                    AS MM_EOH_QTY
                    , 0.0                    AS MM_ACC_PROD_QTY
                    , I.QTY                  AS MM_ACC_SHIP_QTY
                 FROM GT_GPWW_ASIS_GLOBAL_PSI I
                    , GT_GPWW_PW_LIST         J
                WHERE 1=1
                  AND I.YYYYPW          = J.YYYYPW
                  AND I.MEASURE         = 'AS_IN_PLAN'
                  AND I.OPERATION_GROUP = 'A'                  /* Cell */
                  AND I.YYYYPW          < V_PLAN_START_YYYYPW  /* 과거 실적 구간 */
        )
        SELECT K.YYYYPW
             , NVL(NVL(M.ITEM_ID_ASSY, N.ITEM_ID_ASSY), K.ITEM_ID)   AS ITEM_ID   /* 20240118 CP->CA 치환 적용 */
             , 'CELL_EOH'         AS MEASURE
             , K.FROM_SITE
             , '-'                AS TO_SITE
             , '-'                AS INCOTERMS
             , '-'                AS VARIOUS_KEY
             , K.OPERATION_GROUP
             , '-'                AS TO_SITE_TYPE
             , 0.0                AS FROM_BOH_QTY
             , 0.0                AS TO_BOH_QTY
             , CASE WHEN K.PW_TO_YMD = K.YYYYMM_LAST_YMD
                    THEN SUM(K.MM_EOH_QTY)
                    ELSE SUM(K.MM_BOH_QTY) + SUM(K.MM_ACC_PROD_QTY) - SUM(K.MM_ACC_SHIP_QTY)
               END                AS QTY
          FROM BASE_DATA                  K
             , GT_GPWW_SCM_MST_SITE       L
             , GT_GPWW_CELL_PROD_ASSY_MAP M
             , GT_GPWW_CELL_PROD_ASSY_MAP N
         WHERE 1=1
           AND L.SCM_SITE_ID(+)       = K.FROM_SITE
           AND M.PLANT_ID(+)          = L.PLANT_ID
           AND M.ITEM_ID_PROD(+)      = K.ITEM_ID
           AND N.ITEM_ID_PROD(+)      = K.ITEM_ID
           AND M.ASSY_PRIORITY_1ST(+) = 1
           AND N.ASSY_PRIORITY_2ND(+) = 1
         GROUP BY
               K.YYYYPW
             , K.PW_TO_YMD
             , K.YYYYMM_LAST_YMD
             , NVL(NVL(M.ITEM_ID_ASSY, N.ITEM_ID_ASSY), K.ITEM_ID)
             , K.FROM_SITE
             , K.OPERATION_GROUP;










        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : Char. Available / Formation Progress measure 추가');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM GT_GPWW_TOBE_GLOBAL_PSI
         WHERE 1=1
           AND MEASURE IN ( 'CELL_CHAR_AVAILABLE','CELL_FORM_PROGRESS')
           AND YYYYPW  <  V_PLAN_START_YYYYPW   /* 실적 구간 */
        ;


        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
               ( YYYYPW
               , ITEM_ID
               , MEASURE
               , FROM_SITE
               , TO_SITE
               , INCOTERMS
               , VARIOUS_KEY
               , OPERATION_GROUP
               , TO_SITE_TYPE
               , FROM_BOH_QTY
               , TO_BOH_QTY
               , QTY )
          WITH TARGET_MEASURE AS (
               SELECT 'CELL_FORM_PROGRESS'  AS MEASURE
                 FROM DUAL
                UNION ALL
               SELECT 'CELL_CHAR_AVAILABLE' AS MEASURE
                 FROM DUAL
        )
        SELECT A.YYYYPW
             , A.ITEM_ID
             , B.MEASURE
             , A.FROM_SITE        AS FROM_SITE
             , '-'                AS TO_SITE
             , '-'                AS INCOTERMS
             , '-'                AS VARIOUS_KEY   /* 생산라인 or 운송모드 or 프로젝트 */
             , A.OPERATION_GROUP  AS OPERATION_GROUP
             , '-'                AS TO_SITE_TYPE
             , 0.0                AS FROM_BOH_QTY
             , 0.0                AS TO_BOH_QTY
             , CASE WHEN B.MEASURE = 'CELL_FORM_PROGRESS'
                    THEN A.FORM_PROGRESS
                    ELSE A.CHAR_AVAILABLE
               END                AS QTY
          FROM GT_GPWW_PAST_FORM_PROGRESS_CHAR_AVAILABLE A
             , TARGET_MEASURE                            B
         WHERE 1=1;

/* END : 실적 Measure #TMP_TOBE_GLOBAL_PSI Measure 입력 */
/* END : 실적 Measure #TMP_TOBE_GLOBAL_PSI Measure 입력 */

        /* ---------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : intransit(FG/SEMI) 재고 Measure 추가');
        /* ---------------------------------------------------------------------------------------------------------- */
        /*
        INSERT INTO #TMP_TOBE_GLOBAL_PSI
        SELECT I.YYYYPW
              ,I.ITEM_ID
              ,CASE WHEN TS.SITE_TYPE = 'SALES'
                    THEN 'INTRANSIT'
                    ELSE 'SEMI_INTRANSIT'
                END                 AS MEASURE
              ,I.FROM_SITE
              ,I.TO_SITE
              ,I.INCOTERMS
              ,'-'                  AS VARIOUS_KEY
              ,FI.OPERATION_GROUP
              ,TS.SITE_TYPE         AS TO_SITE_TYPE
              ,SUM(I.INT_BOH_QTY)   AS FROM_BOH_QTY  -- from site boh가 아닌 intransit boh임...
              ,0.0                  AS TO_BOH_QTY
              ,SUM(I.INT_EOH_QTY)   AS QTY
         FROM #INTRANSIT I WITH(NOLOCK)  -- 7925
              INNER JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
                      ON FI.ITEM_ID     = I.ITEM_ID
              LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK)
                      ON TS.SCM_SITE_ID = I.TO_SITE
        WHERE 1=1
          AND ISNULL(TS.SITE_TYPE,'') + ISNULL(TS.OPERATION_GROUP,'') != 'SALESW' -- to AS Sales Site 제외
        GROUP BY  I.YYYYPW
                 ,I.ITEM_ID
                 ,I.FROM_SITE
                 ,I.TO_SITE
                 ,I.INCOTERMS
                 ,FI.OPERATION_GROUP
                 ,TS.SITE_TYPE
        */

        /* @@@ BOH 정보를 Ending Inventory 로 변경하여 measure 가 분리됨 */
        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
             ( YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT A.YYYYPW
             , A.ITEM_ID
             , A.MEASURE
             , A.FROM_SITE
             , A.TO_SITE
             , A.INCOTERMS
             , '-'                         AS VARIOUS_KEY
             , B.OPERATION_GROUP
             , NVL(C.SITE_TYPE, 'PLANT')   AS TO_SITE_TYPE
             , 0                           AS FROM_BOH_QTY  /* from site boh가 아닌 intransit boh임... */
             , 0.0                         AS TO_BOH_QTY
             , SUM(A.QTY)                  AS QTY
          FROM GT_GPWW_INTRANSIT          A
             , GT_GPWW_SCP_MST_FINAL_ITEM B
             , GT_GPWW_SCM_MST_SITE       C
         WHERE B.ITEM_ID        = A.ITEM_ID
           AND C.SCM_SITE_ID(+) = A.TO_SITE
           AND NVL(C.SITE_TYPE || C.OPERATION_GROUP, ' ') != 'SALESW'  /* to AS Sales Site 제외 */
         GROUP BY A.YYYYPW
                , A.ITEM_ID
                , A.MEASURE
                , A.FROM_SITE
                , A.TO_SITE
                , A.INCOTERMS
                , B.OPERATION_GROUP
                , C.SITE_TYPE;

        /* ---------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Cell Inventory (Pack공장) measure 계산 ');
        /* 전주 재고(Cell Inventory)  + 금주도착(Semi WH In) -  금주생산(Production)/팩수율 */
        /* @@@ PACK_CELL_EOH */
        /* ---------------------------------------------------------------------------------------------------------- */

        DELETE
          FROM GT_GPWW_TOBE_GLOBAL_PSI
         WHERE 1=1
           AND MEASURE = 'PACK_CELL_EOH'
           AND YYYYPW >= V_PLAN_START_YYYYPW;  /* 계획 구간 */


        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
             ( YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
          WITH BASE_DATA AS (
                /* 실적구간 - 팩출하 */
                SELECT IA.YYYYPW
                     , IA.ITEM_ID
                     , IA.OPERATION_GROUP
                     , IA.FROM_SITE
                     , IA.TO_SITE
                     , SUM(IA.PLAN_QTY) AS PLAN_QTY
                     , SUM(IA.PROD_QTY) AS PROD_QTY
                  FROM (SELECT B.YYYYPW
                             , A.ITEM_ID
                             , A.OPERATION_GROUP
                             , '-'              AS FROM_SITE  /* WI.FROM_SITE */
                             , '-'              AS TO_SITE
                             , (CASE WHEN A.YYYYPW = B.YYYYPW THEN A.QTY ELSE 0 END) AS PLAN_QTY
                             , 0                AS PROD_QTY
                          FROM GT_GPWW_TOBE_GLOBAL_PSI A
                             , GT_GPWW_PW_LIST         B
                         WHERE B.YYYYPW >= V_PLAN_START_YYYYPW  /* 계획 구간 */
                           AND 1=1
                           AND A.MEASURE         = 'SEMI_WHIN'
                           AND A.OPERATION_GROUP = 'A'          /* Cell */
                         UNION ALL
                        /*
                        -- 실적구간 - 팩생산
                        SELECT   WL.YYYYPW
                                ,ISNULL(MM.TARGET_CELL,WI.ITEM_ID) AS ITEM_ID --WI.ITEM_ID  --cell code 로 변경
                                ,'A' AS OPERATION_GROUP --WI.OPERATION_GROUP
                                ,'-' AS FROM_SITE   --WI.FROM_SITE
                                ,'-'            AS TO_SITE
                                ,0 AS PLAN_QTY
                                ,(CASE WHEN WI.YYYYPW = WL.YYYYPW THEN WI.QTY ELSE 0 END) * ISNULL(MM.CELL_CF,1) AS PROD_QTY    --,WI.QTY AS QTY
                        FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK)
                            INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
                                    ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 계획 구간
                            LEFT JOIN #SCP_MST_ITEM_CELL_CF MM WITH(NOLOCK)
                                   ON MM.ITEM_ID = WI.ITEM_ID
                        WHERE 1=1
                          AND WI.MEASURE            = 'PACK_PROD'
                         */
                        /* 실적구간 - 팩생산/팩수율 */
                        SELECT D.YYYYPW
                             , NVL(E.TARGET_CELL, C.ITEM_ID) AS ITEM_ID  /* WI.ITEM_ID  --cell code 로 변경 */
                             , 'A'              AS OPERATION_GROUP       /* WI.OPERATION_GROUP */
                             , '-'              AS FROM_SITE             /* WI.FROM_SITE */
                             , '-'              AS TO_SITE
                             , 0                AS PLAN_QTY
                             , (CASE WHEN C.YYYYPW = D.YYYYPW THEN C.QTY / NVL(F.CHAR_YIELD, NVL(IB.STD_YIELD, 1)) ELSE 0 END) * NVL(TO_NUMBER(E.CELL_CF), 1) AS PROD_QTY  /* ,WI.QTY AS QTY */
                          FROM GT_GPWW_TOBE_GLOBAL_PSI      C
                             , GT_GPWW_PW_LIST              D
                             , GT_GPWW_SCP_MST_ITEM_CELL_CF E
                            /*
                            LEFT JOIN (
                                        SELECT DISTINCT ITEM_ID, MONTH, LINE_ID, YIELD
                                        FROM SCM_MST_YIELD_SN WITH(NOLOCK)
                                        WHERE 1=1
                                        AND DIVISION_ID = @V_DIVISION_ID
                                        AND OPERATION_ID LIKE 'P%'
                                    ) YD
                                  ON 1=1
                                 and WI.ITEM_ID = YD.ITEM_ID
                                 AND WI.VARIOUS_KEY = YD.LINE_ID
                                 AND WL.YYYYMM = YD.MONTH
                            */
                            /* Plant 평균으로 변경 */
                             , GT_GPWW_SCP_MST_FORMATION    F
                             , (SELECT DISTINCT
                                       G.ITEM_ID
                                     , G.MONTH
                                     , MAX(G.YIELD) OVER (PARTITION BY G.DIVISION_ID, G.ITEM_ID, G.MONTH) AS STD_YIELD
                                  FROM SCM_MST_YIELD_SN G
                                 WHERE 1=1
                                   AND G.OPERATION_ID LIKE 'P%'
                                   AND G.DIVISION_ID = V_DIVISION_ID
                               ) IB
                         WHERE D.YYYYPW >= V_PLAN_START_YYYYPW  /* 계획 구간 */
                           AND E.ITEM_ID(+) = C.ITEM_ID
                           AND 1=1
                           AND F.ITEM_ID(+) = C.ITEM_ID
                           AND REPLACE(F.PLANT_SITE_ID(+), '-A', '-P') = C.FROM_SITE
                           AND F.YYYYPW(+) = D.YYYYPW
                           AND 1=1
                           AND IB.ITEM_ID(+) = C.ITEM_ID
                           AND IB.MONTH(+) = D.YYYYMM
                           AND 1=1
                           AND C.MEASURE         = 'PACK_PROD'
                       ) IA
                 WHERE 1=1
                 GROUP BY IA.YYYYPW
                        , IA.ITEM_ID
                        , IA.OPERATION_GROUP
                        , IA.FROM_SITE
                        , IA.TO_SITE
               )
        SELECT IC.YYYYPW
             , IC.ITEM_ID
             , 'PACK_CELL_EOH'      AS MEASURE
             , IC.FROM_SITE         AS FROM_SITE
             , IC.TO_SITE
             , '-'                  AS INCOTERMS
             , '-'                  AS VARIOUS_KEY
             , IC.OPERATION_GROUP
             , '-'                  AS TO_SITE_TYPE
             , 0.0                  AS FROM_BOH_QTY
             , 0.0                  AS TO_BOH_QTY
             , SUM(IC.ACC_QTY) OVER (PARTITION BY IC.ITEM_ID
                                                , IC.OPERATION_GROUP
                                                , IC.FROM_SITE
                                         ORDER BY IC.YYYYPW) AS QTY
          FROM (SELECT H.YYYYPW
                     , H.ITEM_ID
                     , H.FROM_SITE
                     , '-'              AS TO_SITE
                     , H.OPERATION_GROUP
                     , NVL(CASE WHEN H.YYYYPW = V_PLAN_START_YYYYPW THEN NVL(ID.BOH, 0) - H.PROD_QTY + H.PLAN_QTY ELSE 0 - H.PROD_QTY + H.PLAN_QTY END, 0) AS ACC_QTY
                  FROM BASE_DATA H
                     , (SELECT IE.ITEM_ID
                             , IE.OPERATION_GROUP
                             , SUM(IE.BOH) AS BOH
                          FROM (SELECT I.ITEM_ID
                                     , I.OPERATION_GROUP
                                     /* ,WI.FROM_SITE */
                                     , '-'              AS TO_SITE
                                     , I.QTY            AS BOH
                                  FROM GT_GPWW_TOBE_GLOBAL_PSI I  /* #TMP_ENDING_INV_MM_WW -> #TMP_TOBE_GLOBAL_PSI 변경 */
                                 WHERE 1=1
                                   AND I.MEASURE = 'PACK_CELL_EOH'
                                   AND I.YYYYPW  = V_RESULT_LAST_YYYYPW
                                 UNION ALL
                                /* PACK_CELL_EOH 로 변환 될 수량 추가 */
                                SELECT K.CELL_ITEM_ID   AS ITEM_ID
                                     , 'A'              AS OPERATION_GROUP
                                     /* ,WI.FROM_SITE */
                                     , '-'              AS TO_SITE
                                     , J.QTY * NVL(TO_NUMBER(L.CELL_CF), 1) AS BOH
                                  FROM GT_GPWW_TOBE_GLOBAL_PSI      J
                                     , GT_GPWW_MODULE_MODEL_INFO    K  /* AMDAU 상위 모델 정보 */
                                     , GT_GPWW_SCP_MST_ITEM_CELL_CF L
                                 WHERE K.MODULE_ID(+)        = J.ITEM_ID
                                   AND K.PACK_MODULE_ITEM(+) = 'N'
                                   AND L.ITEM_ID(+)          = J.ITEM_ID
                                   AND NOT EXISTS (SELECT 1
                                                     FROM GT_GPWW_MODULE_MODEL_INFO SA
                                                    WHERE 1=1
                                                      AND SA.PACK_MODULE_ITEM = 'Y'  /* PACK_EOH 로 빠지는 그룹은 제외 */
                                                      AND SA.MODULE_ID = J.ITEM_ID)
                                   AND 1=1
                                   AND J.MEASURE = 'PACK_EOH'
                                   AND J.ITEM_ID LIKE 'AMDAU%'
                                   AND J.YYYYPW  = V_RESULT_LAST_YYYYPW
                               ) IE
                         GROUP BY IE.ITEM_ID
                                , IE.OPERATION_GROUP
                       ) ID
                 WHERE 1=1
                   AND ID.ITEM_ID(+)         = H.ITEM_ID
                   AND ID.OPERATION_GROUP(+) = H.OPERATION_GROUP
                   /* AND BD.FROM_SITE = SO.FROM_SITE */
               ) IC;

        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
             ( YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT IA.YYYYPW
             , IA.ITEM_ID
             , IA.MEASURE
             , IA.FROM_SITE
             , IA.TO_SITE
             , IA.INCOTERMS
             , IA.VARIOUS_KEY
             , IA.OPERATION_GROUP
             , IA.TO_SITE_TYPE
             , SUM(IA.FROM_BOH_QTY) AS FROM_BOH_QTY
             , SUM(IA.TO_BOH_QTY)   AS TO_BOH_QTY
             , SUM(IA.QTY)          AS QTY
          FROM (SELECT C.YYYYPW
                     , B.ITEM_ID
                     , 'PACK_CELL_EOH'  AS MEASURE
                     , '-'              AS FROM_SITE
                     , '-'              AS TO_SITE
                     , '-'              AS INCOTERMS
                     , '-'              AS VARIOUS_KEY
                     , B.OPERATION_GROUP
                     , '-'              AS TO_SITE_TYPE
                     , 0.0              AS FROM_BOH_QTY
                     , 0.0              AS TO_BOH_QTY
                     , B.QTY            AS QTY
                  FROM GT_GPWW_TOBE_GLOBAL_PSI B
                     , GT_GPWW_PW_LIST         C
                 WHERE C.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                   AND 1=1
                   AND B.MEASURE = 'PACK_CELL_EOH'
                   AND B.YYYYPW  = V_RESULT_LAST_YYYYPW
                 UNION ALL
                SELECT E.YYYYPW
                     , F.CELL_ITEM_ID   AS ITEM_ID
                     , 'PACK_CELL_EOH'  AS MEASURE
                     , '-'              AS FROM_SITE
                     , '-'              AS TO_SITE
                     , '-'              AS INCOTERMS
                     , '-'              AS VARIOUS_KEY
                     , 'A'              AS OPERATION_GROUP
                     , '-'              AS TO_SITE_TYPE
                     , 0.0              AS FROM_BOH_QTY
                     , 0.0              AS TO_BOH_QTY
                     , D.QTY * NVL(TO_NUMBER(G.CELL_CF), 1) AS QTY
                  FROM GT_GPWW_TOBE_GLOBAL_PSI      D
                     , GT_GPWW_PW_LIST              E
                     , GT_GPWW_MODULE_MODEL_INFO    F  /* AMDAU 상위 모델 정보 */
                     , GT_GPWW_SCP_MST_ITEM_CELL_CF G
                 WHERE E.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                   AND F.MODULE_ID(+)        = D.ITEM_ID
                   AND F.PACK_MODULE_ITEM(+) = 'N'
                   AND G.ITEM_ID(+)          = D.ITEM_ID
                   AND NOT EXISTS (SELECT 1
                                     FROM GT_GPWW_MODULE_MODEL_INFO SA
                                    WHERE 1=1
                                      AND SA.PACK_MODULE_ITEM = 'Y'  /* PACK_EOH 로 빠지는 그룹은 제외 */
                                      AND SA.MODULE_ID = D.ITEM_ID)
                   AND 1=1
                   AND D.MEASURE = 'PACK_EOH'
                   AND D.ITEM_ID LIKE 'AMDAU%'
                   AND D.YYYYPW  = V_RESULT_LAST_YYYYPW
               ) IA
         WHERE 1=1
           AND NOT EXISTS (SELECT 1
                             FROM GT_GPWW_TOBE_GLOBAL_PSI SB
                            WHERE 1=1
                              AND SB.MEASURE = IA.MEASURE
                              AND SB.ITEM_ID = IA.ITEM_ID
                              AND SB.MEASURE = 'PACK_CELL_EOH'
                              AND SB.YYYYPW >= V_PLAN_START_YYYYPW
                              /* AND      X.FROM_SITE = WI.FROM_SITE */
                              /* AND      X.OPERATION_GROUP = A.OPERATION_GROUP */
                          )
           AND IA.ITEM_ID IS NOT NULL
         GROUP BY IA.YYYYPW
                , IA.ITEM_ID
                , IA.MEASURE
                , IA.FROM_SITE
                , IA.TO_SITE
                , IA.INCOTERMS
                , IA.VARIOUS_KEY
                , IA.OPERATION_GROUP
                , IA.TO_SITE_TYPE;



        /* ---------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Pack Inventory measure 추가');
        /* Pack Inventory 기초재고(전월말) + 팩 생산 for Pack Inventory - 출하(FG) for  Pack Inventory */
        /* @@@ PACK_EOH */
        /* ---------------------------------------------------------------------------------------------------------- */

        DELETE
          FROM GT_GPWW_TOBE_GLOBAL_PSI
         WHERE 1=1
           AND MEASURE = 'PACK_EOH'
           AND YYYYPW >= V_PLAN_START_YYYYPW;  /* 계획 구간 */

        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
             ( YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
          WITH BASE_DATA AS (
                /* 실적구간 - 팩출하 */
                SELECT IA.YYYYPW
                     , IA.ITEM_ID
                     , IA.OPERATION_GROUP
                     , IA.FROM_SITE
                     , IA.TO_SITE
                     , SUM(IA.PLAN_QTY) AS PLAN_QTY
                     , SUM(IA.PROD_QTY) AS PROD_QTY
                  FROM (SELECT A.YYYYPW
                             , A.ITEM_ID
                             , A.OPERATION_GROUP
                             , A.FROM_SITE
                             , '-'              AS TO_SITE
                             , A.QTY            AS PLAN_QTY
                             , 0                AS PROD_QTY
                          FROM GT_GPWW_TOBE_GLOBAL_PSI A
                            /* INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK) */
                            /*      ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 계획 구간 */
                         WHERE 1=1
                           /* AND WI.MEASURE            IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN') */
                           AND A.MEASURE         IN ('SHIP_PLAN')
                           AND A.OPERATION_GROUP = 'P'          /* 팩출하 */
                           AND A.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                         UNION ALL
                        /* 실적구간 - 팩출하 */
                        SELECT B.YYYYPW
                             , B.ITEM_ID
                             , B.OPERATION_GROUP
                             , B.FROM_SITE
                             , '-'              AS TO_SITE
                             , 0                AS PLAN_QTY
                             , B.QTY            AS QTY
                          FROM GT_GPWW_TOBE_GLOBAL_PSI B
                        /*  INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK) */
                        /*          ON WL.YYYYPW >=  @V_PLAN_START_YYYYPW  -- 계획 구간 */
                         WHERE 1=1
                           AND B.MEASURE = 'PACK_PROD'
                           AND B.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                         UNION ALL
                        SELECT C.YYYYPW
                             , C.ITEM_ID
                             , C.OPERATION_GROUP
                             , '-'              AS FROM_SITE  /* WI.FROM_SITE */
                             , '-'              AS TO_SITE
                             , 0                AS PLAN_QTY
                             , (-1) * C.QTY     AS PROD_QTY
                          FROM GT_GPWW_TOBE_GLOBAL_PSI C
/*                          INNER JOIN #TMP_MM_LIST WL WITH(NOLOCK) */
/*                                  ON WL.YYYYMM >=  @V_PLAN_START_YYYYMM  -- 미래 계획 구간 */
/*                                 AND WI.YYYYMM = WL.YYYYMM */
                         WHERE 1=1
                           AND C.MEASURE         = 'AS_IN_PLAN'
                           AND C.OPERATION_GROUP = 'P'          /* Cell */
                           AND C.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                       ) IA
                 WHERE 1=1
                 GROUP BY IA.YYYYPW
                        , IA.ITEM_ID
                        , IA.OPERATION_GROUP
                        , IA.FROM_SITE
                        , IA.TO_SITE
               )
        SELECT IB.YYYYPW
             , IB.ITEM_ID
             , 'PACK_EOH'           AS MEASURE
             , IB.FROM_SITE         AS FROM_SITE
             , IB.TO_SITE
             , '-'                  AS INCOTERMS
             , '-'                  AS VARIOUS_KEY
             , IB.OPERATION_GROUP
             , '-'                  AS TO_SITE_TYPE
             , 0.0                  AS FROM_BOH_QTY
             , 0.0                  AS TO_BOH_QTY
             , SUM(IB.ACC_QTY) OVER (PARTITION BY IB.ITEM_ID
                                                , IB.OPERATION_GROUP
                                                , IB.FROM_SITE
                                         ORDER BY IB.YYYYPW) AS QTY
          FROM (SELECT IC.YYYYPW
                     , IC.ITEM_ID
                     , IC.FROM_SITE
                     , IC.TO_SITE
                     , IC.OPERATION_GROUP
                     , SUM(IC.ACC_QTY) AS ACC_QTY
                  FROM (
                                /*
                                SELECT WL.YYYYPW
                                        ,BD.ITEM_ID
                                        ,BD.FROM_SITE
                                        ,'-'            AS TO_SITE
                                        ,BD.OPERATION_GROUP
                                        ,CASE WHEN BD.YYYYPW = WL.YYYYPW THEN
                                                    ISNULL(CASE WHEN BD.YYYYPW = @V_PLAN_START_YYYYPW THEN ISNULL(SO.BOH,0) + BD.PROD_QTY - BD.PLAN_QTY ELSE 0 + BD.PROD_QTY - BD.PLAN_QTY END,0)
                                              ELSE 0 END ACC_QTY
                                FROM BASE_DATA BD
                                     INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
                                             ON WL.YYYYPW >=   @V_PLAN_START_YYYYPW  -- 미래 계획 구간
                                     LEFT JOIN
                                        (
                                            SELECT   WI.ITEM_ID
                                                    ,WI.OPERATION_GROUP
                                                    ,WI.FROM_SITE
                                                    ,'-'            AS TO_SITE
                                                    ,SUM(WI.QTY) AS BOH --,SUM(WI.YYYYMM_PRVS_QTY) AS BOH
                                            --FROM #TMP_ENDING_INV_MM_WW WI WITH(NOLOCK) -- TMP_TOBE_GLOBAL_PSI 가 나중에 생성되어 값이 차이 나 변경
                                            FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK)
                                            WHERE 1=1
                                            AND WI.YYYYPW   = @V_RESULT_LAST_YYYYPW
                                            AND WI.MEASURE  = 'PACK_EOH'
                                            AND NOT EXISTS (
                                                            SELECT 1
                                                            FROM #MODULE_MODEL_INFO MM WITH(NOLOCK)  -- AMDAU 상위 모델 정보
                                                            WHERE  MM.MODULE_ID = WI.ITEM_ID
                                                            AND MM.PACK_MODULE_ITEM = 'N'
                                                            )
                                            GROUP BY WI.ITEM_ID
                                                    ,WI.OPERATION_GROUP
                                                    ,WI.FROM_SITE
                                            / *UNION ALL
                                            -- PACK_CELL_EOH 로 변환 될 수량 차감

                                            SELECT   WI.ITEM_ID
                                                    ,WI.OPERATION_GROUP
                                                    ,WI.FROM_SITE
                                                    ,'-'            AS TO_SITE
                                                    , (-1) * WI.YYYYMM_PRVS_QTY AS BOH
                                            FROM #TMP_ENDING_INV_MM_WW WI WITH(NOLOCK)
                                                LEFT JOIN #MODULE_MODEL_INFO MM WITH(NOLOCK)  -- AMDAU 상위 모델 정보
                                                       ON MM.MODULE_ID = WI.ITEM_ID
                                                      AND MM.PACK_MODULE_ITEM = 'N'
                                            WHERE 1=1
                                            AND WI.YYYYPW   = @V_RESULT_LAST_YYYYPW
                                            AND WI.MEASURE  = 'PACK_EOH'
                                            AND WI.ITEM_ID  LIKE 'AMDAU%'
                                            * /

                                        ) SO
                                        ON 1=1
                                        AND BD.ITEM_ID = SO.ITEM_ID
                                        AND BD.OPERATION_GROUP = SO.OPERATION_GROUP
                                        AND BD.FROM_SITE = SO.FROM_SITE
                                        */
                        SELECT D.YYYYPW
                             , ID.ITEM_ID
                             , ID.FROM_SITE
                             , '-'              AS TO_SITE
                             , ID.OPERATION_GROUP
                             , CASE WHEN ID.YYYYPW = D.YYYYPW
                                    THEN NVL(CASE WHEN ID.YYYYPW = V_PLAN_START_YYYYPW THEN NVL(ID.BOH, 0) + ID.PROD_QTY - ID.PLAN_QTY ELSE 0 + ID.PROD_QTY - ID.PLAN_QTY END, 0)
                                    ELSE 0
                               END AS ACC_QTY
                          FROM (SELECT IE.YYYYPW
                                     , IE.ITEM_ID
                                     , IE.OPERATION_GROUP
                                     , IE.FROM_SITE
                                     , IE.TO_SITE
                                     , SUM(IE.BOH)      AS BOH
                                     , SUM(IE.PLAN_QTY) AS PLAN_QTY
                                     , SUM(IE.PROD_QTY) AS PROD_QTY
                                  FROM (SELECT E.YYYYPW
                                             , E.ITEM_ID
                                             , E.OPERATION_GROUP
                                             , E.FROM_SITE
                                             , E.TO_SITE
                                             , 0                AS BOH
                                             , E.PLAN_QTY       AS PLAN_QTY
                                             , E.PROD_QTY       AS PROD_QTY
                                          FROM BASE_DATA E
                                         UNION ALL
                                        SELECT V_PLAN_START_YYYYPW AS YYYYPW
                                             , F.ITEM_ID
                                             , F.OPERATION_GROUP
                                             , F.FROM_SITE
                                             , '-'              AS TO_SITE
                                             , F.QTY            AS BOH  /* ,SUM(WI.YYYYMM_PRVS_QTY) AS BOH */
                                             , 0                AS PLAN_QTY
                                             , 0                AS PROD_QTY
                                          /* FROM #TMP_ENDING_INV_MM_WW WI WITH(NOLOCK) -- TMP_TOBE_GLOBAL_PSI 가 나중에 생성되어 값이 차이 나 변경 */
                                          FROM GT_GPWW_TOBE_GLOBAL_PSI F
                                         WHERE 1=1
                                           AND NOT EXISTS (SELECT 1
                                                             FROM GT_GPWW_MODULE_MODEL_INFO SA  /* AMDAU 상위 모델 정보 */
                                                            WHERE SA.MODULE_ID = F.ITEM_ID
                                                              AND SA.PACK_MODULE_ITEM = 'N')
                                           AND F.MEASURE = 'PACK_EOH'
                                           AND F.QTY <> 0
                                           AND F.YYYYPW  = V_RESULT_LAST_YYYYPW
                                       ) IE
                                 GROUP BY IE.YYYYPW
                                        , IE.ITEM_ID
                                        , IE.OPERATION_GROUP
                                        , IE.FROM_SITE
                                        , IE.TO_SITE
                               ) ID
                             , GT_GPWW_PW_LIST D
                         WHERE D.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                       ) IC
                 WHERE 1=1
                 GROUP BY IC.YYYYPW
                        , IC.ITEM_ID
                        , IC.FROM_SITE
                        , IC.TO_SITE
                        , IC.OPERATION_GROUP
               ) IB;


        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
             ( YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT B.YYYYPW
             , A.ITEM_ID
             , 'PACK_EOH'           AS MEASURE
             , A.FROM_SITE
             , '-'                  AS TO_SITE
             , '-'                  AS INCOTERMS
             , '-'                  AS VARIOUS_KEY
             , A.OPERATION_GROUP
             , '-'                  AS TO_SITE_TYPE
             , 0.0                  AS FROM_BOH_QTY
             , 0.0                  AS TO_BOH_QTY
             , SUM(A.QTY)           AS QTY
          FROM GT_GPWW_TOBE_GLOBAL_PSI A
             , GT_GPWW_PW_LIST         B
         WHERE B.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
           AND NOT EXISTS (SELECT 1
                             FROM GT_GPWW_TOBE_GLOBAL_PSI SA
                            WHERE 1=1
                              AND SA.ITEM_ID         = A.ITEM_ID
                              AND SA.FROM_SITE       = A.FROM_SITE
                              AND SA.OPERATION_GROUP = A.OPERATION_GROUP
                              AND SA.MEASURE         = 'PACK_EOH'
                              /* AND     X.YYYYPW >=  @V_PLAN_START_YYYYPW */
                              AND SA.YYYYPW          = V_PLAN_START_YYYYPW
                          )
           AND NOT EXISTS (SELECT 1
                             FROM GT_GPWW_MODULE_MODEL_INFO SB  /* AMDAU 상위 모델 정보 */
                            WHERE SB.MODULE_ID = A.ITEM_ID
                              AND SB.PACK_MODULE_ITEM = 'N'
                          )
           AND 1=1
           AND A.MEASURE = 'PACK_EOH'
           AND A.YYYYPW  = V_RESULT_LAST_YYYYPW
         GROUP BY B.YYYYPW
                , A.ITEM_ID
                , A.FROM_SITE
                , A.OPERATION_GROUP;



        /* ---------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Cell Inventory (셀공장)  measure 추가');
        /* 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) */
        /* CELL_EOH  -- 고도화 */
        /* ---------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM GT_GPWW_TOBE_GLOBAL_PSI
         WHERE 1=1
           AND MEASURE = 'CELL_EOH'
           AND YYYYPW >= V_PLAN_START_YYYYPW;

        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
             ( YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
          WITH BASE_DATA AS (
                /* 실적구간 - 팩출하 */
                SELECT A.YYYYPW
                     , IA.ITEM_ID
                     , IA.OPERATION_GROUP
                     , IA.FROM_SITE
                     , IA.TO_SITE
                     , SUM(CASE WHEN A.YYYYPW = IA.YYYYPW THEN IA.PLAN_QTY ELSE 0 END) AS PLAN_QTY
                     , SUM(CASE WHEN A.YYYYPW = IA.YYYYPW THEN IA.PROD_QTY ELSE 0 END) AS PROD_QTY
                  FROM (SELECT IB.YYYYPW
                             , IB.ITEM_ID
                             , IB.OPERATION_GROUP
                             , IB.FROM_SITE
                             , IB.TO_SITE
                             , SUM(IB.PLAN_QTY) AS PLAN_QTY
                             , SUM(IB.PROD_QTY) AS PROD_QTY
                          FROM (SELECT C.YYYYPW
                                     , B.ITEM_ID
                                     , B.OPERATION_GROUP
                                     , B.FROM_SITE      AS FROM_SITE  /* WI.FROM_SITE */
                                     , '-'              AS TO_SITE
                                     , CASE WHEN B.MEASURE = 'SHIP_PLAN'
                                            THEN (CASE WHEN B.YYYYPW = C.YYYYPW THEN B.QTY ELSE 0 END) * NVL(TO_NUMBER(D.CELL_CF), 1)
                                            ELSE (CASE WHEN B.YYYYPW = C.YYYYPW THEN B.QTY ELSE 0 END)
                                       END              AS PLAN_QTY
                                     , 0                AS PROD_QTY
                                  FROM GT_GPWW_TOBE_GLOBAL_PSI      B
                                     , GT_GPWW_PW_LIST              C
                                     , GT_GPWW_SCP_MST_ITEM_CELL_CF D
                                 WHERE C.YYYYPW  = B.YYYYPW
                                   AND D.ITEM_ID(+) = B.ITEM_ID
                                   AND C.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                                   AND 1=1
                                   AND B.MEASURE         IN ('SEMI_SHIP_PLAN', 'SHIP_PLAN')
                                   AND B.OPERATION_GROUP = 'A'          /* Cell */
                               ) IB
                         GROUP BY IB.YYYYPW
                                , IB.ITEM_ID
                                , IB.OPERATION_GROUP
                                , IB.FROM_SITE
                                , IB.TO_SITE

                         UNION ALL
                        SELECT F.YYYYPW
                             , E.ITEM_ID
                             , E.OPERATION_GROUP
                             , E.FROM_SITE      AS FROM_SITE  /* WI.FROM_SITE */
                             , '-'              AS TO_SITE
                             , 0                AS PLAN_QTY
                             , (CASE WHEN E.YYYYPW = F.YYYYPW THEN E.QTY ELSE 0 END) AS PROD_QTY
                          FROM GT_GPWW_TOBE_GLOBAL_PSI E
                             , GT_GPWW_PW_LIST         F
                         WHERE F.YYYYPW  = E.YYYYPW
                           AND F.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                           AND 1=1
                           AND E.MEASURE         = 'CELL_CHAR_PLAN'
                           AND E.OPERATION_GROUP = 'A'          /* Cell */
                         UNION ALL
                        SELECT H.YYYYPW
                             , G.ITEM_ID
                             , G.OPERATION_GROUP
                             , '-'              AS FROM_SITE  /* WI.FROM_SITE */
                             , '-'              AS TO_SITE
                             , 0                AS PLAN_QTY
                             , (-1) * G.QTY     AS PROD_QTY
                          FROM GT_GPWW_TOBE_GLOBAL_PSI G
                             , GT_GPWW_PW_LIST         H
                         WHERE H.YYYYPW  = G.YYYYPW
                           AND H.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                           AND 1=1
                           AND G.MEASURE         = 'AS_IN_PLAN'
                           AND G.OPERATION_GROUP = 'A'          /* Cell */
                         UNION ALL
                        SELECT V_PLAN_START_YYYYPW AS YYYYPW
                             , I.ITEM_ID
                             , I.OPERATION_GROUP
                             , I.FROM_SITE      AS FROM_SITE
                             , '-'              AS TO_SITE
                             , 0                AS PLAN_QTY
                             , 0                AS PROD_QTY
                          FROM GT_GPWW_TOBE_GLOBAL_PSI I
                         WHERE 1=1
                           AND I.MEASURE = 'CELL_EOH'
                           AND I.YYYYPW  = V_RESULT_LAST_YYYYPW
                       ) IA
                     , GT_GPWW_PW_LIST A
                 WHERE A.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                 GROUP BY A.YYYYPW
                        , IA.ITEM_ID
                        , IA.OPERATION_GROUP
                        , IA.FROM_SITE
                        , IA.TO_SITE
               )
        SELECT DISTINCT
               IC.YYYYPW
             , IC.ITEM_ID
             , 'CELL_EOH'           AS MEASURE
             , IC.FROM_SITE         AS FROM_SITE
             , IC.TO_SITE
             , '-'                  AS INCOTERMS
             , '-'                  AS VARIOUS_KEY
             , IC.OPERATION_GROUP
             , '-'                  AS TO_SITE_TYPE
             , 0.0                  AS FROM_BOH_QTY
             , 0.0                  AS TO_BOH_QTY
             , SUM(IC.ACC_QTY) OVER (PARTITION BY IC.ITEM_ID
                                                , IC.OPERATION_GROUP
                                                , IC.FROM_SITE
                                         ORDER BY IC.YYYYPW) AS QTY
          FROM (SELECT ID.YYYYPW
                     , ID.ITEM_ID
                     , ID.FROM_SITE
                     , ID.TO_SITE
                     , ID.OPERATION_GROUP
                     , SUM(ID.ACC_QTY) AS ACC_QTY
                  FROM (SELECT K.YYYYPW
                             , J.ITEM_ID
                             , J.FROM_SITE
                             , '-'              AS TO_SITE
                             , J.OPERATION_GROUP
                             , CASE WHEN J.YYYYPW = K.YYYYPW
                                    THEN NVL(CASE WHEN J.YYYYPW = V_PLAN_START_YYYYPW THEN NVL(IE.BOH, 0) + J.PROD_QTY - J.PLAN_QTY ELSE 0 + J.PROD_QTY - J.PLAN_QTY END, 0)
                                    ELSE 0
                               END AS ACC_QTY
                          FROM BASE_DATA       J
                             , GT_GPWW_PW_LIST K
                             , (SELECT IG.ITEM_ID
                                     , IG.OPERATION_GROUP
                                     , IG.FROM_SITE
                                     , SUM(IG.BOH) AS BOH
                                  FROM (SELECT L.ITEM_ID
                                             , L.OPERATION_GROUP
                                             , L.FROM_SITE      AS FROM_SITE
                                             , '-'              AS TO_SITE
                                             , L.QTY            AS BOH
                                          FROM GT_GPWW_TOBE_GLOBAL_PSI L
                                         WHERE 1=1
                                           AND L.MEASURE = 'CELL_EOH'
                                           AND L.YYYYPW  = V_RESULT_LAST_YYYYPW
                                       ) IG
                                 GROUP BY IG.ITEM_ID
                                        , IG.OPERATION_GROUP
                                        , IG.FROM_SITE
                               ) IE
                         WHERE K.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                           AND 1=1
                           AND IE.ITEM_ID(+)         = J.ITEM_ID
                           AND IE.OPERATION_GROUP(+) = J.OPERATION_GROUP
                           AND IE.FROM_SITE(+)       = J.FROM_SITE
                       ) ID
                 WHERE 1=1
                 GROUP BY ID.YYYYPW
                        , ID.ITEM_ID
                        , ID.FROM_SITE
                        , ID.TO_SITE
                        , ID.OPERATION_GROUP
               ) IC;


        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI
             ( YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT IA.YYYYPW
             , IA.ITEM_ID
             , IA.MEASURE
             , IA.FROM_SITE
             , IA.TO_SITE
             , IA.INCOTERMS
             , IA.VARIOUS_KEY
             , IA.OPERATION_GROUP
             , IA.TO_SITE_TYPE
             , SUM(IA.FROM_BOH_QTY) AS FROM_BOH_QTY
             , SUM(IA.TO_BOH_QTY)   AS TO_BOH_QTY
             , SUM(IA.QTY)          AS QTY
          FROM (SELECT C.YYYYPW
                     , B.ITEM_ID
                     , 'CELL_EOH'       AS MEASURE
                     , B.FROM_SITE      AS FROM_SITE
                     , '-'              AS TO_SITE
                     , '-'              AS INCOTERMS
                     , '-'              AS VARIOUS_KEY
                     , B.OPERATION_GROUP
                     , '-'              AS TO_SITE_TYPE
                     , 0.0              AS FROM_BOH_QTY
                     , 0.0              AS TO_BOH_QTY
                     , (CASE WHEN B.YYYYPW = C.YYYYPW THEN B.QTY ELSE 0 END) AS QTY
                  FROM GT_GPWW_TOBE_GLOBAL_PSI B
                     , GT_GPWW_PW_LIST         C
                 WHERE C.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간 */
                   AND 1=1
                   AND B.MEASURE = 'CELL_EOH'
                   AND B.YYYYPW  = V_RESULT_LAST_YYYYPW
               ) IA
         WHERE 1=1
           AND NOT EXISTS (SELECT 1
                             FROM GT_GPWW_TOBE_GLOBAL_PSI SA
                            WHERE 1=1
                              AND SA.MEASURE   = IA.MEASURE
                              AND SA.ITEM_ID   = IA.ITEM_ID
                              AND SA.FROM_SITE = IA.FROM_SITE
                              AND SA.MEASURE   = 'CELL_EOH'
                              AND SA.YYYYPW   >= V_PLAN_START_YYYYPW
                              /* AND      X.OPERATION_GROUP = A.OPERATION_GROUP */
                          )
           AND IA.ITEM_ID IS NOT NULL
         GROUP BY IA.YYYYPW
                , IA.ITEM_ID
                , IA.MEASURE
                , IA.FROM_SITE
                , IA.TO_SITE
                , IA.INCOTERMS
                , IA.VARIOUS_KEY
                , IA.OPERATION_GROUP
                , IA.TO_SITE_TYPE;

        /* 원문 UPDATE A SET QTY = A.NEW_QTY FROM (파생 테이블) A → MERGE (CELL_CF 는 ITEM_ID 단위 1행) */
        MERGE INTO GT_GPWW_TOBE_GLOBAL_PSI A
        USING (SELECT B.ROWID AS RID
                    , B.QTY
                    , B.QTY / NVL(TO_NUMBER(C.CELL_CF), 1) AS NEW_QTY
                 FROM GT_GPWW_TOBE_GLOBAL_PSI      B
                    , GT_GPWW_SCP_MST_ITEM_CELL_CF C
                WHERE C.ITEM_ID(+) = B.ITEM_ID
                  AND 1=1
                  AND B.MEASURE         = 'CELL_EOH'
                  AND B.OPERATION_GROUP = 'P'
                  AND B.YYYYPW         >= V_PLAN_START_YYYYPW
              ) IA
           ON (A.ROWID = IA.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET A.QTY = IA.NEW_QTY;


/*
	----- Begin :### 실적 구간 Ending Inventory Weekly 재고
	----- Begin :### 실적 구간 Ending Inventory Weekly 재고

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 참조 대상 품목 정보' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_TARGET_ITEM_FOR_ENDING_INV') IS NOT NULL	
			DROP TABLE #TMP_TARGET_ITEM_FOR_ENDING_INV;

		SELECT II.ITEM_ID
			  ,ISNULL(MAX(FI.FINISHED_PRODUCT),'N')	AS FINISHED_PRODUCT 
			  ,MAX(II.SCP_FLOW_ID)					AS OPERATION_ID
			  ,MAX(II.SCP_OPERATION_GROUP)			AS OPERATION_GROUP
		 INTO #TMP_TARGET_ITEM_FOR_ENDING_INV
		 FROM SCM_MST_ITEM_SN  II WITH(NOLOCK)   -- SCM_MST_ITEM_SN
			  LEFT  JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.ITEM_ID		= II.ITEM_ID
		WHERE 1=1
		  AND II.DIVISION_ID = @V_DIVISION_ID
		  AND II.SCP_OPERATION_GROUP IN ('A', 'P')
		  AND (
			  II.ITEM_ID LIKE 'AMDAU%'
			  OR 
			  EXISTS (SELECT TOP 1 L.SEGMENT1
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
						WHERE L.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
						  AND L.SEGMENT1	= II.SCP_FLOW_ID
						  AND L.SEGMENT1   != 'F6000'
						  AND L.VALID_YN	= 'Y'
						  AND L.SEGMENT4 LIKE '%'+@V_DIVISION_ID+'%'
						)
			  )
		GROUP BY II.ITEM_ID


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 시뮬레이터 measure sloc 매핑 정보' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_SLOC_ADD_INFO') IS NOT NULL	
			DROP TABLE #TMP_SLOC_ADD_INFO;

		SELECT DISTINCT 	
			  SEGMENT1		AS PLANT	
			 ,SEGMENT2		AS SLOC	
			 ,ATTRIBUTE12	AS SIMU_MEASURE	
		 INTO #TMP_SLOC_ADD_INFO
		 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)	
		WHERE LOOKUP_TYPE = 'SLOC_ADD_INFO'	
		  AND ATTRIBUTE12 <> ''	
	

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 월별 재고 - Raw 데이터' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM_RAW') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM_RAW;

		SELECT IV.ITEM_ID
			  ,IV.YYYYMM
			  ,IV.STORAGE_LOCATION
			  ,IV.PLANT_ID
			  ,IV.SUPPLIER_CODE
			  ,IV.QUANTITY
		 INTO #TMP_ENDING_INV_MM_RAW
		 FROM SCP_ANL_MONTH_END_STOCK_R IV WITH(NOLOCK)   
		WHERE IV.DIVISION_ID =  @V_DIVISION_ID
		  AND IV.YYYYMM     >=  @V_INV_FROM_YYYYMM 
		  AND IV.YYYYMM     <=  @V_INV_TO_YYYYMM
		  AND IV.SPECIAL_INVENTORY != 'W' --@@@ Cosignment_stock[고객위탁재고]의 경우, S.loc이 공란이라 Key값으로 집계를 하지 못하여 제외하고 #TMP_ENDING_INV_MM_0 에 직접 입력함.

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 월별 재고 - 1' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM_0') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM_0;

		SELECT IV.ITEM_ID
			  ,IV.YYYYMM
			  ,II.OPERATION_ID
			  ,II.OPERATION_GROUP
			  ,ISNULL(FS.SCM_SITE_ID, '-')	AS FROM_SITE
			  ,ISNULL(TS.SCM_SITE_ID, '-')	AS TO_SITE
			  ,CASE WHEN SM.SIMU_MEASURE = 'BOH'				AND II.OPERATION_GROUP = 'P'		THEN 'PACK_EOH'
					WHEN SM.SIMU_MEASURE = 'BOH'				AND II.OPERATION_GROUP = 'A'		THEN 'CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'CELL_BOH'												THEN 'CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'PACK_CELL_BOH'		AND II.OPERATION_GROUP = 'A'		THEN 'PACK_CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'CELL_FOR_FORM_END'										THEN 'CELL_CHAR_AVAILABLE'
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'미착'	THEN 'SEMI_INTRANSIT'									
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7990'	THEN 'INTRANSIT'									
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7000'	THEN
						 CASE WHEN II.OPERATION_ID IN ('P9500', 'P5500')						THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'P5000'									THEN 'SEMI_INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT  = 'Y'	THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT != 'Y'	THEN 'SEMI_INTRANSIT'
							  ELSE 'ENDING_INV_FOR_DIO'
						  END 
					WHEN SM.SIMU_MEASURE = 'VMI'													THEN 'TO_SITE_EOH'		
					WHEN SM.SIMU_MEASURE = 'AS'														THEN 'AS_INV'		
					ELSE 'ENDING_INV_FOR_DIO'
				END AS MEASURE 
			  ,SUM(IV.QUANTITY)	AS QTY
		 INTO #TMP_ENDING_INV_MM_0
		 FROM #TMP_ENDING_INV_MM_RAW IV WITH(NOLOCK)   
			  INNER JOIN #TMP_TARGET_ITEM_FOR_ENDING_INV II WITH(NOLOCK)
					  ON II.ITEM_ID = IV.ITEM_ID
			  INNER JOIN #TMP_SLOC_ADD_INFO SM WITH(NOLOCK)
					  ON SM.PLANT		= IV.PLANT_ID
					 AND SM.SLOC		= IV.STORAGE_LOCATION
			  LEFT JOIN #SCM_MST_SITE FS WITH(NOLOCK)	-- from site 
					  ON FS.SITE_TYPE		= 'PLANT'
					 AND FS.PLANT_ID		= CASE WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'	AND IV.STORAGE_LOCATION = N'미착'
												   THEN IV.SUPPLIER_CODE
												   ELSE IV.PLANT_ID
											  END 
					 AND FS.OPERATION_GROUP	= CASE WHEN SM.SIMU_MEASURE = 'PACK_CELL_BOH'  -- pack plant cell
												   THEN 'P' 
												   ELSE II.OPERATION_GROUP
											   END 
			  LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK)	-- to site 
					  ON TS.SITE_TYPE		= 'PLANT'
					 AND TS.PLANT_ID		= CASE WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'	AND IV.STORAGE_LOCATION = N'미착'
												   THEN IV.PLANT_ID
												   ELSE 'Z'
											  END 
					 AND TS.OPERATION_GROUP = II.OPERATION_GROUP
		WHERE 1=1
		GROUP BY IV.ITEM_ID
				,IV.YYYYMM
				,II.OPERATION_ID
				,II.OPERATION_GROUP
			    ,ISNULL(FS.SCM_SITE_ID, '-')
			    ,ISNULL(TS.SCM_SITE_ID, '-')
			  ,CASE WHEN SM.SIMU_MEASURE = 'BOH'				AND II.OPERATION_GROUP = 'P'		THEN 'PACK_EOH'
					WHEN SM.SIMU_MEASURE = 'BOH'				AND II.OPERATION_GROUP = 'A'		THEN 'CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'CELL_BOH'												THEN 'CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'PACK_CELL_BOH'		AND II.OPERATION_GROUP = 'A'		THEN 'PACK_CELL_EOH'
					WHEN SM.SIMU_MEASURE = 'CELL_FOR_FORM_END'										THEN 'CELL_CHAR_AVAILABLE'
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'미착'	THEN 'SEMI_INTRANSIT'									
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7990'	THEN 'INTRANSIT'									
					WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7000'	THEN
						 CASE WHEN II.OPERATION_ID IN ('P9500', 'P5500')						THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'P5000'									THEN 'SEMI_INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT  = 'Y'	THEN 'INTRANSIT'
							  WHEN II.OPERATION_ID = 'A9000'	AND II.FINISHED_PRODUCT != 'Y'	THEN 'SEMI_INTRANSIT'
							  ELSE 'ENDING_INV_FOR_DIO'
						  END 
					WHEN SM.SIMU_MEASURE = 'VMI'													THEN 'TO_SITE_EOH'		
					WHEN SM.SIMU_MEASURE = 'AS'														THEN 'AS_INV'		
					ELSE 'ENDING_INV_FOR_DIO'
				END  
			;
		
		
		--@@@ Cosignment_stock[고객위탁재고]의 경우, S.loc이 공란이라 Key값으로 집계를 하지 못하여 제외하고 #TMP_ENDING_INV_MM_0 에 직접 입력함.
		INSERT INTO #TMP_ENDING_INV_MM_0 
		SELECT IV.ITEM_ID
			  ,IV.YYYYMM
			  ,II.OPERATION_ID
			  ,II.OPERATION_GROUP
			  ,ISNULL(FS.SCM_SITE_ID, '-')	AS FROM_SITE
			  ,ISNULL(TS.SCM_SITE_ID, '-')	AS TO_SITE
			  ,'TO_SITE_EOH' AS MEASURE 
			  ,SUM(IV.QUANTITY)	AS QTY
		 FROM SCP_ANL_MONTH_END_STOCK_R IV WITH(NOLOCK)   
			  INNER JOIN #TMP_TARGET_ITEM_FOR_ENDING_INV II WITH(NOLOCK)
					  ON II.ITEM_ID = IV.ITEM_ID
			  LEFT  JOIN #SCM_MST_SITE FS WITH(NOLOCK)	-- from site 
					  ON FS.SITE_TYPE		= 'PLANT'
					 AND FS.PLANT_ID		= IV.PLANT_ID
					 AND FS.OPERATION_GROUP	= II.OPERATION_GROUP
			  LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK)	-- to site 
					  ON TS.SITE_TYPE		= 'PLANT'
					 AND TS.PLANT_ID		= 'Z' 
					 AND TS.OPERATION_GROUP = II.OPERATION_GROUP
		WHERE IV.DIVISION_ID =  @V_DIVISION_ID
		  AND IV.YYYYMM     >=  @V_INV_FROM_YYYYMM 
		  AND IV.YYYYMM     <=  @V_INV_TO_YYYYMM
		  AND SPECIAL_INVENTORY = 'W' 
		GROUP BY IV.ITEM_ID
				,IV.YYYYMM
				,II.OPERATION_ID
				,II.OPERATION_GROUP
			    ,ISNULL(FS.SCM_SITE_ID, '-')
			    ,ISNULL(TS.SCM_SITE_ID, '-')
			;
		
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM_RAW') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM_RAW;


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 월별 재고 - 2 - 0채움' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM;

		;WITH MM_LIST AS (
			SELECT DISTINCT YYYYMM
			   FROM #TMP_PW_LIST WITH(NOLOCK)
			 WHERE 1=1
			   AND YYYYPW <= @V_PLAN_START_YYYYPW   -- 당월 포함 과거 구간만 
		)
		SELECT IM.ITEM_ID
			  ,ML.YYYYMM
			  ,IM.OPERATION_ID
			  ,IM.OPERATION_GROUP
			  ,IM.MEASURE
			  ,IM.FROM_SITE
			  ,IM.TO_SITE
			  ,SUM(CASE WHEN IM.YYYYMM = ML.YYYYMM THEN IM.QTY ELSE 0.0 END) AS QTY
		  INTO #TMP_ENDING_INV_MM  
		  FROM #TMP_ENDING_INV_MM_0 IM WITH(NOLOCK)
			   INNER JOIN MM_LIST ML
					   ON 1=1
		WHERE 1=1
		GROUP BY
			   IM.ITEM_ID
			  ,ML.YYYYMM
			  ,IM.OPERATION_ID
			  ,IM.OPERATION_GROUP
			  ,IM.MEASURE
			  ,IM.FROM_SITE
			  ,IM.TO_SITE


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : 주별 기초 재고 (전월재고)  ' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TMP_ENDING_INV_MM_WW') IS NOT NULL	
			DROP TABLE #TMP_ENDING_INV_MM_WW;

		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYPW_SEQ
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,EI.ITEM_ID
			  ,EI.OPERATION_GROUP
			  ,EI.FROM_SITE
			  ,EI.TO_SITE
			  ,EI.MEASURE
			  ,SUM(CASE WHEN WL.YYYYMM_PRVS = EI.YYYYMM THEN EI.QTY ELSE 0.0 END)	AS YYYYMM_PRVS_QTY 
		  INTO #TMP_ENDING_INV_MM_WW
		  FROM #TMP_PW_LIST WL WITH(NOLOCK)
				INNER JOIN #TMP_ENDING_INV_MM EI WITH(NOLOCK)
						ON 1=1
		WHERE 1=1
		  AND WL.YYYYPW < @V_PLAN_START_YYYYPW  -- 과거 실적 구간  
		GROUP BY 
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYPW_SEQ
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,EI.ITEM_ID
			  ,EI.OPERATION_GROUP
			  ,EI.FROM_SITE
			  ,EI.TO_SITE
			  ,EI.MEASURE


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : TO_SITE_EOH(VMI) measure 추가' 
		-- 전주 재고(EOH)+ 금주도착(WH In) - 매출(RTF)
		-- 실적구간 고객향 도착 실적은 매출(RTF)과 동일함
		-- 당월 마지막 주를 제외하고 모두 전월 EOH와 동일함. 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT WI.YYYYPW
			  ,WI.ITEM_ID
			  ,WI.MEASURE
			  ,WI.FROM_SITE
			  ,WI.TO_SITE
			  ,'-'		AS INCOTERMS
			  ,'-'		AS VARIOUS_KEY
			  ,WI.OPERATION_GROUP
			  ,'-'		AS TO_SITE_TYPE
			  ,0.0		AS FROM_BOH_QTY
			  ,0.0		AS TO_BOH_QTY
			  ,CASE WHEN WI.PW_TO_YMD = WI.YYYYMM_LAST_YMD		-- 주 마지막일이 당월 마지막 일과 같을 경우 
					THEN MI.QTY									-- 당월말 재고
					ELSE WI.YYYYMM_PRVS_QTY						-- 전월말 재고 (기초재고)
			   END		AS QTY 
		FROM #TMP_ENDING_INV_MM_WW WI WITH(NOLOCK)  
			  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)			-- 당월말 재고 참조   
					 ON WI.YYYYMM		= MI.YYYYMM		
					AND WI.ITEM_ID		= MI.ITEM_ID	
					AND WI.FROM_SITE	= MI.FROM_SITE
					AND WI.TO_SITE		= MI.TO_SITE 
					AND WI.MEASURE		= MI.MEASURE 
		WHERE 1=1
		  AND WI.MEASURE = 'TO_SITE_EOH'


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales)' 
		-- 전주 재고(Intransit)  + 금주출하(Ship Plan) - 금주도착(WH In)
		-- 전월말 재고를 기초로 하여 당월 출하(Ship Plan)와 도착(Wh In) 누적 정보를 적용하여 계산 
		-- 고객향(to Sales)  도착(WH In) 실적은 매출(RTF)로 적용함.
		-----------------------------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales) - 출하'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#SHIP_FOR_INTRANSIT') IS NOT NULL	
			DROP TABLE #SHIP_FOR_INTRANSIT;

		-- 실적구간 - 출하 (to sales)
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_EXFACTORY_QTY 
		 INTO #SHIP_FOR_INTRANSIT
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW -- 과거 실적 구간 
		WHERE 1=1
		  AND WI.MEASURE		= 'SHIP_PLAN'
		  AND WI.TO_SITE_TYPE	= 'SALES'
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			 ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales) - 도착'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#WHIN_FOR_INTRANSIT') IS NOT NULL	
			DROP TABLE #WHIN_FOR_INTRANSIT;

		-- 실적구간 -  도착 (to sales)
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_WHIN_QTY 
		 INTO #WHIN_FOR_INTRANSIT
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE		= 'WHIN'
		  AND WI.TO_SITE_TYPE	= 'SALES'
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE
	

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : INTRANSIT (to Sales) measure 추가' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		;WITH BASE_DATA AS (
			-- 실적구간 - Intransit 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.TO_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY	
				  ,MI.QTY				AS MM_EOH_QTY 
				  ,0.0					AS MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_WHIN_QTY
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'INTRANSIT'
			UNION ALL 
			-- 실적구간 - 출하(FG) for Intransit
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_WHIN_QTY
			 FROM #SHIP_FOR_INTRANSIT SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - 도착(FG) for Intransit
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0				AS MM_BOH_QTY
				  ,0.0				AS MM_EOH_QTY
				  ,0.0				AS MM_ACC_EXFACTORY_QTY
				  ,MM_ACC_WHIN_QTY	AS MM_ACC_WHIN_QTY
			 FROM #WHIN_FOR_INTRANSIT SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
		)
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT BD.YYYYPW
			  ,BD.ITEM_ID
			  ,'INTRANSIT'	AS MEASURE 
			  ,BD.FROM_SITE
			  ,BD.TO_SITE
			  ,'-'			AS INCOTERMS
			  ,'-'			AS VARIOUS_KEY
			  ,BD.OPERATION_GROUP
			  ,'SALES'		AS TO_SITE_TYPE
			  ,0.0			AS FROM_BOH_QTY
			  ,0.0			AS TO_BOH_QTY
			  ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
					THEN SUM(MM_EOH_QTY)
					ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_EXFACTORY_QTY) - SUM(MM_ACC_WHIN_QTY)
				END			AS QTY
		 FROM BASE_DATA BD
			  LEFT JOIN #SCM_MST_SITE TS 
					 ON TS.SCM_SITE_ID = BD.TO_SITE
		WHERE 1=1
		  AND ISNULL(TS.OPERATION_GROUP, '') != 'W' -- to AS Sales Site 제외
		GROUP BY
			   BD.YYYYPW
			  ,BD.PW_TO_YMD
			  ,BD.YYYYMM_LAST_YMD
			  ,BD.ITEM_ID
			  ,BD.FROM_SITE
			  ,BD.TO_SITE
			  ,BD.OPERATION_GROUP


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant)' 
		-- 전주 재고(Intransit)  + 금주출하(Ship Plan) - 금주도착(WH In)
		-- 전월말 재고를 기초로 하여 당월 출하(Ship Plan)와 도착(Wh In) 누적 정보를 적용하여 계산 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant) - 출하'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#SHIP_FOR_SEMI_INTRANSIT') IS NOT NULL	
			DROP TABLE #SHIP_FOR_SEMI_INTRANSIT;

		-- 실적구간 - 출하 (to Plant)
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_EXFACTORY_QTY 
		 INTO #SHIP_FOR_SEMI_INTRANSIT
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE		= 'SEMI_SHIP_PLAN'
		  AND WI.TO_SITE_TYPE	= 'PLANT'
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE

	
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant) - 도착'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#WHIN_FOR_SEMI_INTRANSIT') IS NOT NULL	
			DROP TABLE #WHIN_FOR_SEMI_INTRANSIT;

		-- 실적구간 -  도착 (to Plant)
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_WHIN_QTY 
		 INTO #WHIN_FOR_SEMI_INTRANSIT
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		WHERE 1=1
		  AND WI.MEASURE		= 'SEMI_WHIN'
		  AND WI.TO_SITE_TYPE	= 'PLANT'
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,WI.TO_SITE 	
			  ,WI.TO_SITE_TYPE


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : SEMI INTRANSIT (to Plant) measure 추가' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		;WITH BASE_DATA AS (
			-- 실적구간 - semi Intransit 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.TO_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY	
				  ,MI.QTY				AS MM_EOH_QTY 
				  ,0.0					AS MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_WHIN_QTY
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'SEMI_INTRANSIT'
			UNION ALL 
			-- 실적구간 - 출하(SEMI) for Intransit
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_WHIN_QTY
			 FROM #SHIP_FOR_SEMI_INTRANSIT SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - 도착(SEMI) for Intransit
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0				AS MM_BOH_QTY
				  ,0.0				AS MM_EOH_QTY
				  ,0.0				AS MM_ACC_EXFACTORY_QTY
				  ,MM_ACC_WHIN_QTY	AS MM_ACC_WHIN_QTY
			 FROM #WHIN_FOR_SEMI_INTRANSIT SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
		)
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT BD.YYYYPW
			  ,BD.ITEM_ID
			  ,'SEMI_INTRANSIT'	AS MEASURE 
			  ,BD.FROM_SITE
			  ,BD.TO_SITE
			  ,'-'			AS INCOTERMS
			  ,'-'			AS VARIOUS_KEY
			  ,BD.OPERATION_GROUP
			  ,'PLANT'		AS TO_SITE_TYPE
			  ,0.0			AS FROM_BOH_QTY
			  ,0.0			AS TO_BOH_QTY
			  ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
					THEN SUM(MM_EOH_QTY)
					ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_EXFACTORY_QTY) - SUM(MM_ACC_WHIN_QTY)
				END			AS QTY
		 FROM BASE_DATA BD
		WHERE 1=1
		GROUP BY
			   BD.YYYYPW
			  ,BD.PW_TO_YMD
			  ,BD.YYYYMM_LAST_YMD
			  ,BD.ITEM_ID
			  ,BD.FROM_SITE
			  ,BD.TO_SITE
			  ,BD.OPERATION_GROUP


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory ' 
		-- 전주 재고(Pack Inventory)  + 금주생산(Production-pack 해당월 누적) - 금주출하(Pack Ship 해당월 누적) 
		-- 전월말 재고를 기초로 하여 당월 생산과 당월 출하 월누적 정보를 적용하여 계산 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory - 생산'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PRODUCTION_FOR_PACK_INV') IS NOT NULL	
			DROP TABLE #PRODUCTION_FOR_PACK_INV;

		-- 실적구간 - 팩 생산
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,'-'			AS TO_SITE 
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_PROD_QTY 
		 INTO #PRODUCTION_FOR_PACK_INV
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE   = 'PACK_PROD'
		  AND WI.YYYYPW	   <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory - 출하'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#SHIP_FOR_PACK_INV') IS NOT NULL	
			DROP TABLE #SHIP_FOR_PACK_INV;

		-- 실적구간 - 팩출하
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,'-'			AS TO_SITE 
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_EXFACTORY_QTY 
		 INTO #SHIP_FOR_PACK_INV
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW < @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		WHERE 1=1
		  AND WI.MEASURE			IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')
		  AND WI.OPERATION_GROUP	= 'P'			 -- 팩출하
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Pack Inventory measure 추가' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		;WITH BASE_DATA AS (
			-- 실적구간 - Pack Inventory 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.TO_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY	
				  ,MI.QTY				AS MM_EOH_QTY 
				  ,0.0					AS MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_PROD_QTY
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'PACK_EOH'
			UNION ALL 
			-- 실적구간 - 출하(FG) for  Pack Inventory
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,MM_ACC_EXFACTORY_QTY
				  ,0.0					AS MM_ACC_PROD_QTY
			 FROM #SHIP_FOR_PACK_INV SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - 팩 생산 for Pack Inventory
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.TO_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0				AS MM_BOH_QTY
				  ,0.0				AS MM_EOH_QTY
				  ,0.0				AS MM_ACC_EXFACTORY_QTY
				  ,MM_ACC_PROD_QTY
			 FROM #PRODUCTION_FOR_PACK_INV SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
		)
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT BD.YYYYPW
			  ,BD.ITEM_ID
			  ,'PACK_EOH'	AS MEASURE 
			  ,BD.FROM_SITE
			  ,'-'			AS TO_SITE
			  ,'-'			AS INCOTERMS
			  ,'-'			AS VARIOUS_KEY
			  ,BD.OPERATION_GROUP
			  ,'-'			AS TO_SITE_TYPE
			  ,0.0			AS FROM_BOH_QTY
			  ,0.0			AS TO_BOH_QTY
			  ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
					THEN SUM(MM_EOH_QTY)
					ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_PROD_QTY) - SUM(MM_ACC_EXFACTORY_QTY)
				END			AS QTY
		 FROM BASE_DATA BD
		WHERE 1=1
		GROUP BY
			   BD.YYYYPW
			  ,BD.PW_TO_YMD
			  ,BD.YYYYMM_LAST_YMD
			  ,BD.ITEM_ID
			  ,BD.FROM_SITE
			  ,BD.OPERATION_GROUP


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장)' 
		-- 전주 재고(Cell Inventory)  + 금주도착(Semi WH In) -  금주생산(Production)/팩수율 
		-- 전월말 재고를 기초로 하여 해당월 도착/생산 월누적 정보를 적용하여 계산 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		/ *
		모듈 공장의 Cell Inventory는
		P = 전주 재고(Cell Inventory) + 금주도착(Semi WH In) - 금주생산(Production)/팩수율
		자작 공장 무시하고, 위의 P가 마이너스이면, P=0으로 표시하고, 그 마이너스(P) 수량 만큼 동일 Plant의 셀 공장 measure에서 빼기
 
		셀 공장의 Cell Inventory는
		A = 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) + P (If P가 마이너스 경우만, 동일 공장에서 빼기)
		* /


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Cell도착 '  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#SEMI_WHIN_FOR_CELL_INV') IS NOT NULL	
			DROP TABLE #SEMI_WHIN_FOR_CELL_INV;

		-- 실적구간 - Cell 도착 (to Plant) - to 사이트 기준 
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			 ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.TO_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW = WL.YYYYPW	-- 20240327 해당월 주 누적이 아닌 해당 주차 
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS WHIN_QTY												-- 20240327 해당월 주 누적이 아닌 해당 주차
		 INTO #SEMI_WHIN_FOR_CELL_INV
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #SCM_MST_SITE TS WITH(NOLOCK)
					 ON TS.SCM_SITE_ID		= WI.TO_SITE
					AND TS.OPERATION_GROUP	= 'P'	-- Pack plant 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE			= 'SEMI_WHIN'
		  AND WI.OPERATION_GROUP	= 'A'	-- Cell 
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.TO_SITE 	
			  

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Pack 생산 실적 1 (수율)'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_PRODUCTION_RESULT_1') IS NOT NULL	
			DROP TABLE #PACK_PRODUCTION_RESULT_1;

		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.FROM_SITE
			  ,PR.OPERATION_GROUP
			  ,SUM(PR.ACTUAL_GOOD_QTY) 	AS PACK_PROD_QTY 
			  ,SUM(PR.ACTUAL_GOOD_QTY 
					/ CASE WHEN ISNULL(PY.YIELD,0) > 0 
						   THEN PY.YIELD
						   ELSE 1.0
					  END )	AS PACK_PROD_YIELD_QTY 
		  INTO #PACK_PRODUCTION_RESULT_1
		  FROM #PRODUCTION_RESULT PR WITH(NOLOCK)
			   INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					   ON WL.PW_FROM_YMD <= PR.PLAN_YYYYMMDD
					  AND WL.PW_TO_YMD   >= PR.PLAN_YYYYMMDD
			   LEFT JOIN SCP_MST_TACT_TIME_EXCEPT PY WITH(NOLOCK) 
					  ON PY.DIVISION_ID		= @V_DIVISION_ID
					 AND PY.PLANT_SITE_ID	= PR.FROM_SITE
					 AND PY.ITEM_ID			= PR.ITEM_ID
					 AND PY.OPERATION_ID	= PR.OPERATION_ID
					 AND PY.LINE_ID			= PR.LINE_ID 
					 AND PY.TACT_TIME_START_DATE <= PR.PLAN_YYYYMMDD
					 AND PY.TACT_TIME_END_DATE   >= PR.PLAN_YYYYMMDD
		WHERE 1=1
		  AND PR.OPERATION_GROUP = 'P' -- 팩 생산 실적 (실적구간) 
		GROUP BY 
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.FROM_SITE
			  ,PR.OPERATION_GROUP


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Pack 생산 실적 2 (0채움)'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_PRODUCTION_RESULT_2') IS NOT NULL	
			DROP TABLE #PACK_PRODUCTION_RESULT_2;

		-- 실적구간 - Cell 도착 (to Plant) - to 사이트 기준 
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.OPERATION_GROUP
			  ,PR.FROM_SITE 	
			  ,SUM(CASE WHEN PR.YYYYMM = WL.YYYYMM AND PR.YYYYPW = WL.YYYYPW	-- 20240327 누적아닌 해당 주차
						THEN PR.PACK_PROD_QTY
						ELSE 0.0 
				   END)	AS PACK_PROD_QTY
			  ,SUM(CASE WHEN PR.YYYYMM = WL.YYYYMM AND PR.YYYYPW = WL.YYYYPW	-- 20240327 누적아닌 해당 주차
						THEN PR.PACK_PROD_YIELD_QTY
						ELSE 0.0 
				   END)	AS PACK_PROD_YIELD_QTY
		 INTO #PACK_PRODUCTION_RESULT_2
		 FROM #PACK_PRODUCTION_RESULT_1 PR WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.OPERATION_GROUP
			  ,PR.FROM_SITE 	


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) - Pack 생산 실적 3 (대표cell * 셀환산계수)'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_PRODUCTION_RESULT_3') IS NOT NULL	
			DROP TABLE #PACK_PRODUCTION_RESULT_3;

		SELECT CASE WHEN MI.MODEL_ID IS NOT NULL									-- AMDAU% 모듈 
					THEN MI.CELL_ITEM_ID
					WHEN PR.OPERATION_GROUP = 'P'	AND CI.CELL_ITEM_ID IS NOT NULL	-- Pack
					THEN CI.CELL_ITEM_ID
					WHEN PR.OPERATION_GROUP = 'P'	AND EC.CELL_ITEM_ID IS NOT NULL	-- Pack
					THEN EC.CELL_ITEM_ID
					ELSE NULL
			   END  AS REP_CELL_ITEM_ID		-- 대표셀 (CP:Cell Product) 모델 
			  ,CASE WHEN CF.CELL_CF		IS NOT NULL		THEN CONVERT(NUMERIC(20,10), CF.CELL_CF)
			   		WHEN CF2.CELL_CF	IS NOT NULL		THEN CONVERT(NUMERIC(20,10), CF2.CELL_CF)
			   		WHEN CF3.CELL_CF	IS NOT NULL		THEN CONVERT(NUMERIC(20,10), CF3.CELL_CF)
					ELSE CONVERT(NUMERIC(20,10), '1.0')
			   END  AS CELL_CF 
			  ,CASE WHEN CF.CELL_CF		IS NOT NULL		THEN 'CF'
			   		WHEN CF2.CELL_CF	IS NOT NULL		THEN 'CF2'
			   		WHEN CF3.CELL_CF	IS NOT NULL		THEN 'CF3'
					ELSE 'NULL'
			   END  AS CELL_CF_TYPE 
			   ,MI.MODULE_ID
			   ,PR.*
		 INTO #PACK_PRODUCTION_RESULT_3
		 FROM #PACK_PRODUCTION_RESULT_2 PR  WITH(NOLOCK)
			  LEFT JOIN #MODULE_MODEL_INFO MI WITH(NOLOCK)
					 ON MI.MODULE_ID		= PR.ITEM_ID
			  LEFT JOIN #CP_CELL_ITEM_INFO CI WITH(NOLOCK)
					 ON CI.MODEL_ID = CASE WHEN MI.MODEL_ID IS NOT NULL		-- AMDAU% 모듈
										   THEN MI.MODEL_ID
										   WHEN PR.OPERATION_GROUP = 'P'	-- 팩
										   THEN PR.ITEM_ID
										   ELSE ''
									  END 
			  LEFT  JOIN #ETC_CP_CELL_INFO EC WITH(NOLOCK)
					  ON EC.PARENT_ITEM_ID = PR.ITEM_ID
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CF WITH(NOLOCK)
					  ON CF.ITEM_ID		= PR.ITEM_ID
					 AND CF.CELL_CF IS NOT NULL
					 AND CONVERT(NUMERIC(20,10), CF.CELL_CF) != 0.0
			 LEFT  JOIN #SCP_MST_ITEM_CELL_CF CF2 WITH(NOLOCK)
					  ON CF2.ITEM_ID	   = LEFT(PR.ITEM_ID, LEN(PR.ITEM_ID) - 2) 
					 AND PR.ITEM_ID LIKE '%-_'
					 AND PR.OPERATION_GROUP = 'P'
					 AND CF.CELL_CF IS NULL 
					 AND CF2.CELL_CF IS NOT NULL
					 AND CONVERT(NUMERIC(20,10), CF2.CELL_CF) != 0.0
			  LEFT  JOIN #SCP_MST_ITEM_CELL_CF CF3 WITH(NOLOCK)
					  ON CF3.ITEM_ID	   = LEFT(PR.ITEM_ID, LEN(PR.ITEM_ID) - 3) 
					 AND PR.ITEM_ID LIKE '%-__'
					 AND PR.OPERATION_GROUP = 'P'
					 AND CF.CELL_CF  IS NULL 
					 AND CF2.CELL_CF IS NULL 
					 AND CF3.CELL_CF IS NOT NULL
					 AND CONVERT(NUMERIC(20,10), CF3.CELL_CF) != 0.0
		WHERE 1=1


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) measure 계산 ' 
		-- 전주 재고(Cell Inventory)  + 금주도착(Semi WH In) -  금주생산(Production)/팩수율 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_CELL_EOH_RESULT') IS NOT NULL	
			DROP TABLE #PACK_CELL_EOH_RESULT;

		;WITH BASE_DATA AS (
			-- 실적구간 - Pack공장 Cell 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.YYYYMM
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY			-- 전월말 기말재고
				  ,MI.QTY				AS MM_EOH_QTY			-- 당월말 기말재고
				  ,0.0					AS WHIN_QTY				-- 20240327 변경
				  ,0.0					AS PACK_PROD_QTY 		-- 20240327 변경
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)  -- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)			-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'PACK_CELL_EOH'
			UNION ALL 
			-- 실적구간 - Pack Plant Cell 도착 실적 
			SELECT SR.YYYYPW
				  ,SR.YYYYMM
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.TO_SITE			AS FROM_SITE			
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,WHIN_QTY									  -- 20240327 변경
				  ,0.0					AS PACK_PROD_QTY	   -- 20240327 변경
			 FROM #SEMI_WHIN_FOR_CELL_INV SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - Pack 생산계획(수율역적용 -투입 기준) -> Cell 환산
			SELECT SR.YYYYPW
				  ,SR.YYYYMM
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.REP_CELL_ITEM_ID	AS ITEM_ID
				  ,SR.FROM_SITE
				  ,'A'					AS OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,0.0					AS WHIN_QTY										-- 20240327 변경
				  ,SUM(PACK_PROD_YIELD_QTY * ISNULL(CELL_CF,1.1))  AS PACK_PROD_QTY		-- 20240327 변경
			 FROM #PACK_PRODUCTION_RESULT_3 SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			  AND SR.REP_CELL_ITEM_ID IS NOT NULL
			GROUP BY 
				   SR.YYYYPW
				  ,SR.YYYYMM
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.REP_CELL_ITEM_ID
				  ,SR.FROM_SITE
		)
		, PACK_CELL_EOH_RESULT  AS (
			SELECT BD.YYYYPW
				  ,BD.YYYYMM
				  ,BD.PW_TO_YMD
				  ,BD.YYYYMM_LAST_YMD
				  ,BD.ITEM_ID
				  ,BD.FROM_SITE
				  ,'-'							AS TO_SITE
				  ,'-'							AS INCOTERMS
				  ,'-'							AS VARIOUS_KEY
				  ,BD.OPERATION_GROUP
				  ,'-'							AS TO_SITE_TYPE
				  ,0.0							AS FROM_BOH_QTY
				  ,0.0							AS TO_BOH_QTY
				  ,SUM(MM_EOH_QTY)				AS MM_EOH_QTY
				  ,SUM(MM_BOH_QTY)				AS MM_BOH_QTY
				  ,SUM(WHIN_QTY)				AS WHIN_QTY			-- 20240327 변경
				  ,SUM(PACK_PROD_QTY)			AS PACK_PROD_QTY	-- 20240327 변경
				-- 20240327 주석처리   ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
				-- 20240327 주석처리 		THEN SUM(MM_EOH_QTY)
				-- 20240327 주석처리 		ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_WHIN_QTY) - SUM(MM_ACC_PACK_PROD_QTY)
				-- 20240327 주석처리 	END			AS QTY
			 FROM BASE_DATA BD
			WHERE 1=1
			GROUP BY
				   BD.YYYYPW
				  ,BD.YYYYMM
				  ,BD.PW_TO_YMD
				  ,BD.YYYYMM_LAST_YMD
				  ,BD.ITEM_ID
				  ,BD.FROM_SITE
				  ,BD.OPERATION_GROUP
		)
		SELECT MAX(A.MM_WW_SEQ) OVER (PARTITION BY A.ITEM_ID
												  ,A.FROM_SITE
												  ,A.YYYYMM )		AS MM_WW_SEQ_MAX
			  ,A.*
		 INTO #PACK_CELL_EOH_RESULT 
		 FROM (
				SELECT  ROW_NUMBER() OVER (PARTITION BY  A.ITEM_ID  
														,A.FROM_SITE	 
														,A.YYYYMM 
												ORDER BY A.YYYYPW) AS MM_WW_SEQ 
					   ,A.*
				FROM PACK_CELL_EOH_RESULT  A 
				WHERE 1=1 
			  ) A 
		WHERE 1=1 


		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) measure 계산 결과 조정 (마이너스 수량)'
		-- 월별 마지막주는 조정 대상에서 제외 (월 기말재고와 동일)
		-- 월별 둘째주부터 전주 마이너스 수량을 0으로 보정된 기준으로 당주 재고 수량 보정
		----------------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_CELL_EOH_RESULT_ADJ') IS NOT NULL	
			DROP TABLE #PACK_CELL_EOH_RESULT_ADJ;

		/ * 20240327 변경전 
		;WITH RECURSIVE_DATA AS (
			SELECT A.MM_WW_SEQ 
				  ,A.YYYYPW
				  ,A.YYYYMM
				  ,A.PW_TO_YMD
				  ,A.YYYYMM_LAST_YMD
				  ,A.ITEM_ID
				  ,A.FROM_SITE
				  ,A.QTY	AS ORG_QTY 
				  ,A.QTY	
				  ,A.MM_EOH_QTY
				  ,A.MM_BOH_QTY
				  ,A.MM_ACC_WHIN_QTY
				  ,A.MM_ACC_PACK_PROD_QTY
				  ,A.MM_WW_SEQ_MAX
				  ,CASE WHEN A.QTY < 0 
						THEN A.QTY
						ELSE 0.0	
					END AS ACC_ADJ_QTY
			 FROM #PACK_CELL_EOH_RESULT  A WITH(NOLOCK)
			WHERE 1=1
			  AND A.MM_WW_SEQ = 1
			UNION ALL
			SELECT A.MM_WW_SEQ 
				  ,A.YYYYPW
				  ,A.YYYYMM
				  ,A.PW_TO_YMD
				  ,A.YYYYMM_LAST_YMD
				  ,A.ITEM_ID
				  ,A.FROM_SITE
				  ,A.QTY	AS ORG_QTY 
				  ,CASE WHEN A.MM_WW_SEQ = A.MM_WW_SEQ_MAX
						THEN A.QTY
						ELSE A.QTY - P.ACC_ADJ_QTY 
					END AS QTY 
				  ,A.MM_EOH_QTY
				  ,A.MM_BOH_QTY
				  ,A.MM_ACC_WHIN_QTY
				  ,A.MM_ACC_PACK_PROD_QTY
				  ,A.MM_WW_SEQ_MAX
				  ,CASE WHEN A.QTY - P.ACC_ADJ_QTY  < 0 and A.MM_WW_SEQ != A.MM_WW_SEQ_MAX -- 마지막 주차 제외 
						THEN A.QTY
						ELSE P.ACC_ADJ_QTY 
					END ACC_ADJ_QTY
			  FROM RECURSIVE_DATA p 
				   INNER JOIN #PACK_CELL_EOH_RESULT  A WITH(NOLOCK)
						   ON A.MM_WW_SEQ = P.MM_WW_SEQ + 1 
						  AND A.ITEM_ID	  = P.ITEM_ID
						  AND A.FROM_SITE = P.FROM_SITE
						  AND A.YYYYMM    = P.YYYYMM 
			WHERE 1=1
		)
		SELECT *
		 INTO #PACK_CELL_EOH_RESULT_ADJ
		 FROM RECURSIVE_DATA  A
		WHERE 1=1
* /

		;WITH RECURSIVE_DATA AS (
			SELECT A.MM_WW_SEQ 
				  ,A.YYYYPW
				  ,A.YYYYMM
				 ,A.PW_TO_YMD
				  ,A.YYYYMM_LAST_YMD
				  ,A.ITEM_ID
				  ,A.FROM_SITE
				  ,A.MM_BOH_QTY		AS BOH_QTY
				  ,A.WHIN_QTY
				  ,A.PACK_PROD_QTY
				  ,CASE WHEN A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0 
						THEN 0
						ELSE A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
				   END	AS EOH_QTY
				  ,A.MM_WW_SEQ_MAX
				  ,CASE WHEN A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0 
						THEN A.MM_BOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
						ELSE 0
				  END	AS ADJ_QTY_P
			 FROM #PACK_CELL_EOH_RESULT  A WITH(NOLOCK)
			WHERE 1=1
			  AND A.MM_WW_SEQ = 1
			UNION ALL
			SELECT A.MM_WW_SEQ 
				  ,A.YYYYPW
				  ,A.YYYYMM
				  ,A.PW_TO_YMD
				  ,A.YYYYMM_LAST_YMD
				  ,A.ITEM_ID
				  ,A.FROM_SITE
				  ,P.EOH_QTY		AS BOH_QTY-- 전주 EOH -> 당주 BOH
				  ,A.WHIN_QTY
				  ,A.PACK_PROD_QTY
				  ,CASE WHEN A.MM_WW_SEQ = A.MM_WW_SEQ_MAX	 -- 해당월 마지막 주차
						THEN A.MM_EOH_QTY
						WHEN P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0 
						THEN 0
						ELSE P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
				   END	AS EOH_QTY
				  ,A.MM_WW_SEQ_MAX
				  ,CASE WHEN A.MM_WW_SEQ = A.MM_WW_SEQ_MAX	AND A.MM_EOH_QTY= 0 AND  P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0 -- 해당월 마지막 주차
						THEN P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
						WHEN A.MM_WW_SEQ = A.MM_WW_SEQ_MAX	 -- 해당월 마지막 주차
						THEN 0
						WHEN P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY < 0 
						THEN P.EOH_QTY + A.WHIN_QTY - A.PACK_PROD_QTY
						ELSE 0
				   END	AS ADJ_QTY_P
			  FROM RECURSIVE_DATA p 
				   INNER JOIN #PACK_CELL_EOH_RESULT  A WITH(NOLOCK)
						   ON A.MM_WW_SEQ = P.MM_WW_SEQ + 1 
						  AND A.ITEM_ID	 = P.ITEM_ID
						  AND A.FROM_SITE = P.FROM_SITE
						  AND A.YYYYMM    = P.YYYYMM 
			WHERE 1=1
		)
		SELECT *
		 INTO #PACK_CELL_EOH_RESULT_ADJ
		 FROM RECURSIVE_DATA  A
		WHERE 1=1

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (Pack공장) measure 추가 ' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT PR.YYYYPW
			  ,PR.ITEM_ID
			  ,'PACK_CELL_EOH'	AS MEASURE
			  ,PR.FROM_SITE
			  ,'-'	AS TO_SITE
			  ,'-'	AS INCOTERMS
			  ,'-'	AS VARIOUS_KEY
			  ,'A'	AS OPERATION_GROUP 
			  ,'-'	AS TO_SITE_TYPE
			  ,0.0	AS FROM_BOH_QTY
			  ,0.0	AS TO_BOH_QTY
			  ,PR.EOH_QTY    -- 20240327    
			-- 20240327 변경   ,CASE WHEN PR.QTY < 0 
			-- 20240327 변경 		THEN 0.0 
			-- 20240327 변경 		ELSE PR.QTY 
			-- 20240327 변경 	END	AS QTY
		 FROM #PACK_CELL_EOH_RESULT_ADJ PR WITH(NOLOCK)
		WHERE 1=1


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)' 
		-- 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) + P (If P가 마이너스 경우만, 동일 공장에서 빼기)
		-- 전월말 재고를 기초로 하여 해당월 생산/출하 월누적 정보를 적용하여 계산 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		/ *
		모듈 공장의 Cell Inventory는
		P = 전주 재고(Cell Inventory) + 금주도착(Semi WH In) - 금주생산(Production)/팩수율
		자작 공장 무시하고, 위의 P가 마이너스이면, P=0으로 표시하고, 그 마이너스(P) 수량 만큼 동일 Plant의 셀 공장 measure에서 빼기
 
		셀 공장의 Cell Inventory는
		A = 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) + P (If P가 마이너스 경우만, 동일 공장에서 빼기)
		* /


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장) - Char Plan' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CELL_CHAR_FOR_CELL_INV') IS NOT NULL	
			DROP TABLE #CELL_CHAR_FOR_CELL_INV;

		-- 실적구간 - 셀 특성 생산 실적 
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END) AS MM_ACC_CELL_CHAR_QTY 
		 INTO #CELL_CHAR_FOR_CELL_INV  
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE	= 'CELL_CHAR_PLAN'
		  AND WI.YYYYPW		<   @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장) - 출하'  
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#SHIP_FOR_CELL_INV') IS NOT NULL	
			DROP TABLE #SHIP_FOR_CELL_INV;

		-- 실적구간 - Cell 출하
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,'-'			AS TO_SITE 
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_EXFACTORY_QTY 
		 INTO #SHIP_FOR_CELL_INV
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간 
		WHERE 1=1
		  AND WI.MEASURE			IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')
		  AND WI.OPERATION_GROUP	= 'A'			 -- Cell 출하
		  AND WI.YYYYPW	   <   @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)  - semi ship plan site' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#ITEM_SEMI_SHIP_SITE') IS NOT NULL	
			DROP TABLE #ITEM_SEMI_SHIP_SITE;

		SELECT SS.ITEM_ID
			  ,SS.TO_SITE			AS PACK_SITE
			  ,MAX(CASE WHEN SS.YYYYPW <   @V_PLAN_START_YYYYPW THEN SS.FROM_SITE ELSE NULL END)	AS CELL_SITE_PAST
			  ,MAX(CASE WHEN SS.YYYYPW >=  @V_PLAN_START_YYYYPW THEN SS.FROM_SITE ELSE NULL END)	AS CELL_SITE_FUTURE
		INTO #ITEM_SEMI_SHIP_SITE
		FROM #TMP_TOBE_GLOBAL_PSI SS with(nolock)
			 INNER JOIN #SCM_MST_SITE PS WITH(NOLOCK) -- pack site 
					 ON PS.SCM_SITE_ID		= SS.TO_SITE 
					AND PS.OPERATION_GROUP	= 'P'
			 INNER JOIN #SCM_MST_SITE CS WITH(NOLOCK)	-- cell site 
					 ON CS.SCM_SITE_ID		= SS.FROM_SITE 
					AND CS.OPERATION_GROUP	= 'A'
		WHERE 1=1
		  AND SS.MEASURE = 'SEMI_SHIP_PLAN'
		  AND SS.QTY != 0 
		GROUP BY SS.ITEM_ID
				,SS.TO_SITE


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)  - P (팩공장 셀재고 마이너스 수량)' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PACK_PROD_FOR_CELL_PLANT_INV') IS NOT NULL	
			DROP TABLE #PACK_PROD_FOR_CELL_PLANT_INV;
				
		SELECT PR.YYYYPW
			  ,PR.YYYYMM
			  ,PR.PW_TO_YMD
			  ,PR.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.FROM_SITE 
			  ,SUM(AP.ADJ_QTY_P) AS ADJ_QTY_P  --- 20240327 
			  --- 20240327 ,SUM(CASE WHEN AP.QTY < 0 THEN AP.QTY ELSE 0.0 END) AS QTY
		INTO #PACK_PROD_FOR_CELL_PLANT_INV
		FROM #PACK_CELL_EOH_RESULT_ADJ PR WITH(NOLOCK)
			 LEFT JOIN #PACK_CELL_EOH_RESULT_ADJ AP WITH(NOLOCK)
				    ON AP.YYYYMM	= PR.YYYYMM
				   AND AP.ITEM_ID	= PR.ITEM_ID
				   AND AP.FROM_SITE = PR.FROM_SITE 
				   AND AP.YYYYPW   <= PR.YYYYPW
		GROUP BY 
			   PR.YYYYPW
			  ,PR.YYYYMM
			  ,PR.PW_TO_YMD
			  ,PR.YYYYMM_LAST_YMD
			  ,PR.ITEM_ID
			  ,PR.FROM_SITE
		HAVING SUM(AP.ADJ_QTY_P) != 0 
		-- 20240327 HAVING SUM(CASE WHEN AP.QTY < 0 THEN AP.QTY ELSE 0.0 END) != 0 


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)  measure 추가' 
		-- 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) 
		--                           + P (If P가 마이너스 경우만, 동일 공장에서 빼기)
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		;WITH BASE_DATA AS (
			-- 실적구간 - 셀공장 Cell 기초 재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY			-- 전월말 기말재고
				  ,MI.QTY				AS MM_EOH_QTY			-- 당월말 기말재고
				  ,0.0					AS MM_ACC_PROD_QTY
				  ,0.0					AS MM_ACC_SHIP_QTY
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'CELL_EOH'
			UNION ALL 
			-- 실적구간 - Production(PKG)
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,MM_ACC_CELL_CHAR_QTY	AS MM_ACC_PROD_QTY
				  ,0.0					AS MM_ACC_SHIP_QTY
			 FROM #CELL_CHAR_FOR_CELL_INV SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - Cell Char
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0						AS MM_BOH_QTY
				  ,0.0						AS MM_EOH_QTY
				  ,0.0						AS MM_ACC_PROD_QTY
				  ,SR.MM_ACC_EXFACTORY_QTY	AS MM_ACC_SHIP_QTY
			 FROM #SHIP_FOR_CELL_INV SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- + P (If P가 마이너스 경우만, 동일 공장에서 빼기) 
			SELECT PR.YYYYPW
				  ,PR.PW_TO_YMD
				  ,PR.YYYYMM_LAST_YMD
				  ,PR.ITEM_ID
				  ,ISNULL(CP.SCM_SITE_ID, ISNULL(SS.CELL_SITE_PAST, SS.CELL_SITE_FUTURE))	AS FROM_SITE -- cell plant 
				  ,'A'						AS OPERATION_GROUP 
				  ,0.0						AS MM_BOH_QTY
				  ,0.0						AS MM_EOH_QTY
				  ,PR.ADJ_QTY_P				AS MM_ACC_PROD_QTY  -- P: 음수값  20240327 변경 
				  ,0.0						AS MM_ACC_SHIP_QTY
			 FROM #PACK_PROD_FOR_CELL_PLANT_INV PR WITH(NOLOCK)
				  INNER JOIN #SCM_MST_SITE PP WITH(NOLOCK)	-- pack plant site 
						  ON PP.SCM_SITE_ID		= PR.FROM_SITE
				  LEFT JOIN #SCM_MST_SITE CP WITH(NOLOCK)	-- cell plant site 
						  ON CP.PLANT_ID		= PP.PLANT_ID
						 AND CP.OPERATION_GROUP = 'A'
						 AND CP.SITE_TYPE		= 'PLANT'
				  LEFT  JOIN #ITEM_SEMI_SHIP_SITE SS WITH(NOLOCK)
						  ON SS.ITEM_ID			= PR.ITEM_ID 
						 AND SS.PACK_SITE		= PP.SCM_SITE_ID -- pack site 
			WHERE 1=1
			   --- 20240327 불필요 조건 삭제 
			  AND ISNULL(CP.SCM_SITE_ID, ISNULL(SS.CELL_SITE_PAST, SS.CELL_SITE_FUTURE)) IS NOT NULL
		)
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT BD.YYYYPW
			  ,ISNULL(ISNULL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), BD.ITEM_ID)  AS ITEM_ID -- 20240118 CP->CA 치환 적용 
			  ,'CELL_EOH'	AS MEASURE 
			  ,BD.FROM_SITE
			  ,'-'						AS TO_SITE
			  ,'-'						AS INCOTERMS
			  ,'-'						AS VARIOUS_KEY
			  ,BD.OPERATION_GROUP
			  ,'-'						AS TO_SITE_TYPE
			  ,0.0						AS FROM_BOH_QTY
			  ,0.0						AS TO_BOH_QTY
			  ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
					THEN SUM(MM_EOH_QTY)
					ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_PROD_QTY) - SUM(MM_ACC_SHIP_QTY)
				END			AS QTY
		 FROM BASE_DATA BD
			   LEFT JOIN #SCM_MST_SITE FS WITH(NOLOCK)
					  ON FS.SCM_SITE_ID			= BD.FROM_SITE
			   LEFT JOIN #CELL_PROD_ASSY_MAP CA1 WITH(NOLOCK)
					  ON CA1.PLANT_ID			= FS.PLANT_ID 
					 AND CA1.ITEM_ID_PROD		= BD.ITEM_ID
					 AND CA1.ASSY_PRIORITY_1ST	= 1 
			   LEFT JOIN #CELL_PROD_ASSY_MAP CA2 WITH(NOLOCK)
					  ON CA2.ITEM_ID_PROD		= BD.ITEM_ID
					 AND CA2.ASSY_PRIORITY_2ND	= 1
		WHERE 1=1
		GROUP BY
			   BD.YYYYPW
			  ,BD.PW_TO_YMD
			  ,BD.YYYYMM_LAST_YMD
			  ,ISNULL(ISNULL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), BD.ITEM_ID)
			  ,BD.FROM_SITE
			  ,BD.OPERATION_GROUP


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available' 
		-- 전주 재고(Char. Available)  + 금주생산(Production(PKG)) -  금주 특성 생산 실적 (Char.Plan) / 활성화특성수율
		-- 전월말 재고를 기초로 하여 해당월 도착/생산 월누적 정보를 적용하여 계산 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available - 셀 생산실적'   
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CELL_PROD_FOR_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #CELL_PROD_FOR_CHAR_AVAILABLE;

		-- 실적구간 - 셀 생산실적 (from site) 
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	AS MM_ACC_CELL_PROD_QTY 
		 INTO #CELL_PROD_FOR_CHAR_AVAILABLE
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE	= 'CELL_PROD'
		  AND WI.YYYYPW		<   @V_PLAN_START_YYYYPW	-- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available - 셀 특성 실적(투입기준)'   
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#CELL_CHAR_FOR_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #CELL_CHAR_FOR_CHAR_AVAILABLE;

		-- 실적구간 - 셀 특성 실적 / 활성화특성수율  
		SELECT WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 	
			  ,SUM(CASE WHEN MI.YYYYMM = WL.YYYYMM AND MI.YYYYPW <= WL.YYYYPW
						THEN WI.QTY
						ELSE 0.0 
				   END)	/ CASE WHEN CY.CHAR_YIELD > 0 
							   THEN CY.CHAR_YIELD
							   ELSE 1
						  END   AS MM_ACC_CELL_CHAR_QTY 
		 INTO #CELL_CHAR_FOR_CHAR_AVAILABLE  
		 FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK) 
			 INNER JOIN #TMP_PW_LIST MI WITH(NOLOCK)
					 ON MI.YYYYPW = WI.YYYYPW 
			 LEFT  JOIN #SCP_MST_FORMATION CY WITH(NOLOCK)
					 ON CY.PLANT_SITE_ID	= WI.FROM_SITE
					AND CY.ITEM_ID			= WI.ITEM_ID
					AND CY.YYYYPW			= WI.YYYYPW 
			 INNER JOIN #TMP_PW_LIST WL WITH(NOLOCK)
					ON WL.YYYYPW <  @V_PLAN_START_YYYYPW  -- 과거 실적 구간
		WHERE 1=1
		  AND WI.MEASURE	= 'CELL_CHAR_PLAN'			-- 셀 특성 실적 (활성화특성수율 역적용) 
		  AND WI.YYYYPW		<   @V_PLAN_START_YYYYPW	-- 과거 실적 구간 
		GROUP BY
			   WL.YYYYPW
			  ,WL.PW_TO_YMD
			  ,WL.YYYYMM
			  ,WL.YYYYMM_PRVS
			  ,WL.YYYYMM_FIRST_YMD
			  ,WL.YYYYMM_LAST_YMD
			  ,WI.ITEM_ID
			  ,WI.OPERATION_GROUP
			  ,WI.FROM_SITE 
			  ,CASE WHEN CY.CHAR_YIELD > 0 
					THEN CY.CHAR_YIELD
					ELSE 1
				END


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory Weekly 재고 : Char. Available (Formation Progress 포함?) 추가' 
		-- 전주 재고(Char. Available)  + 금주생산(Production(PKG)) -  금주 특성 생산 실적 (Char.Plan) / 활성화특성수율
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PAST_CELL_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #PAST_CELL_CHAR_AVAILABLE;

		;WITH BASE_DATA AS (
			-- 실적구간 -Char. Available 기초재고(전월말) 
			SELECT IT.YYYYPW
				  ,IT.PW_TO_YMD
				  ,IT.YYYYMM_LAST_YMD
				  ,IT.ITEM_ID
				  ,IT.FROM_SITE
				  ,IT.OPERATION_GROUP
				  ,IT.YYYYMM_PRVS_QTY	AS MM_BOH_QTY	
				  ,MI.QTY				AS MM_EOH_QTY 
				  ,0.0					AS MM_ACC_CELL_PROD_QTY
				  ,0.0					AS MM_ACC_CELL_CHAR_QTY 
			 FROM #TMP_ENDING_INV_MM_WW IT WITH(NOLOCK)			-- 과거 실적구간 
			  	  LEFT JOIN #TMP_ENDING_INV_MM MI WITH(NOLOCK)	-- 당월말 재고 참조   
					 ON IT.YYYYMM		= MI.YYYYMM		
					AND IT.ITEM_ID		= MI.ITEM_ID	
					AND IT.FROM_SITE	= MI.FROM_SITE
					AND IT.TO_SITE		= MI.TO_SITE 
					AND IT.MEASURE		= MI.MEASURE 
			WHERE 1=1
			  AND IT.MEASURE = 'CELL_CHAR_AVAILABLE'
			UNION ALL 
			-- 실적구간 - Production(PKG)
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.OPERATION_GROUP
				  ,0.0					AS MM_BOH_QTY
				  ,0.0					AS MM_EOH_QTY
				  ,MM_ACC_CELL_PROD_QTY
				  ,0.0					AS MM_ACC_CELL_CHAR_QTY
			 FROM #CELL_PROD_FOR_CHAR_AVAILABLE SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
			UNION ALL
			-- 실적구간 - Cell Char
			SELECT SR.YYYYPW
				  ,SR.PW_TO_YMD
				  ,SR.YYYYMM_LAST_YMD
				  ,SR.ITEM_ID
				  ,SR.FROM_SITE
				  ,SR.OPERATION_GROUP
				 ,0.0				AS MM_BOH_QTY
				  ,0.0				AS MM_EOH_QTY
				  ,0.0				AS MM_ACC_CELL_PROD_QTY
				  ,SR.MM_ACC_CELL_CHAR_QTY
			 FROM #CELL_CHAR_FOR_CHAR_AVAILABLE SR WITH(NOLOCK)  -- 과거 실적구간 
			WHERE 1=1
		)
		SELECT BD.YYYYPW
			  ,BD.ITEM_ID
			  ,'CELL_CHAR_AVAILABLE'	AS MEASURE 
			  ,BD.FROM_SITE
			  ,'-'						AS TO_SITE
			  ,'-'						AS INCOTERMS
			  ,'-'						AS VARIOUS_KEY
			  ,BD.OPERATION_GROUP
			  ,'-'						AS TO_SITE_TYPE
			  ,0.0						AS FROM_BOH_QTY
			  ,0.0						AS TO_BOH_QTY
			  ,CASE WHEN BD.PW_TO_YMD = BD.YYYYMM_LAST_YMD 
					THEN SUM(MM_EOH_QTY)
					ELSE SUM(MM_BOH_QTY) + SUM(MM_ACC_CELL_PROD_QTY) - SUM(MM_ACC_CELL_CHAR_QTY)
				END			AS QTY
		 INTO #PAST_CELL_CHAR_AVAILABLE
		 FROM BASE_DATA BD
		WHERE 1=1
		GROUP BY
			   BD.YYYYPW
			  ,BD.PW_TO_YMD
			  ,BD.YYYYMM_LAST_YMD
			  ,BD.ITEM_ID
			  ,BD.FROM_SITE
			  ,BD.OPERATION_GROUP


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory : Char. Available / Formation Progress 분리' 
		-- 2023.11.22 요구사항 
		-- 과거 실적의 활성화와 특성 분리
		-- 현재 로직 : 과거 실적 재고 중에 활성화 재고는 모두 Char. Available에 반영되어 있음
		-- 이것을 Remain Lead Time이 0이 아닌 것을 Ending Inventory에서 Formation Progress로 차감하여 반영
		-- 만약 해당 cutoff 일의 Formation Progress > Ending Inventory 이면 Ending Inventory이 Max 값으로 설정
		-----------------------------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory : FP Aging Stock' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#FP_AGING_STOCK') IS NOT NULL	
		DROP TABLE #FP_AGING_STOCK;

		SELECT WL.YYYYPW
			  ,SA.CUTOFF_DATE
			  ,PS.SCM_SITE_ID	AS FROM_SITE
			  ,SA.ITEM_ID
			  ,SUM(CASE WHEN SA.REMAIN_LEAD_TIME = 0 THEN SA.QTY ELSE 0 END)	AS FP_CHAR_AVAILABLE
			  ,SUM(CASE WHEN SA.REMAIN_LEAD_TIME > 0 THEN SA.QTY ELSE 0 END)	AS FP_FORM_PROGRESS
			  ,SUM(SA.QTY)														AS FP_AGING_TOTAL
			  ,'A'																AS DIV
		 INTO #FP_AGING_STOCK
		 FROM #TMP_PW_LIST WL WITH(NOLOCK)
			  INNER JOIN SCM_DNM_STOCK_AGING_SN SA WITH(NOLOCK) 
			  	  ON 1=1 
					 AND SA.CUTOFF_DATE = WL.PW_TO_YMD_NEXT_DAY
					 AND SA.DIVISION_ID = @V_DIVISION_ID
			  INNER JOIN #SCM_MST_SITE PS WITH(NOLOCK) 
					  ON PS.PLANT_ID		= SA.PLANT_ID
					 AND PS.SITE_TYPE		= 'PLANT'
					 AND PS.OPERATION_GROUP = 'A'	-- Cell  
		WHERE 1=1
		  AND WL.YYYYPW	<  @V_PLAN_START_YYYYPW -- 과거 실적 구간
		GROUP BY WL.YYYYPW
			  ,SA.CUTOFF_DATE
			  ,PS.SCM_SITE_ID
			  ,SA.ITEM_ID
	
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory : FP Aging Stock (현재 없는 기 적재된 데이터)' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO #FP_AGING_STOCK
		SELECT GP.YYYYPW
			  ,CONVERT(DATE, GP.VARIOUS_KEY, 112)	AS CUTOFF_DATE
			  ,GP.FROM_SITE
			 ,GP.ITEM_ID
			  ,CONVERT(NUMERIC(20,10), ATTRIBUTE1)	AS FP_CHAR_AAILABLE
			  ,GP.QTY								AS FP_FORM_PROGRESS
			  ,CONVERT(NUMERIC(20,10), ATTRIBUTE2)	AS FP_AGING_TOTAL
			  ,'B'									AS DIV
		 FROM SCP_RPT_GLOBAL_PSI_MD_WW GP WITH(NOLOCK)
		WHERE 1=1
	      AND GP.PLAN_START_YYYYMMDD = '00000000'
		  AND GP.DIVISION_ID		 = @V_DIVISION_ID
		  AND GP.YYYYPW				 < @V_PLAN_START_YYYYPW -- 과거 실적 구간
		  AND GP.MEASURE			 = 'FORM_PROGRESS'
		  AND NOT EXISTS (SELECT *
							FROM #FP_AGING_STOCK SA
						   WHERE 1=1
						     AND SA.YYYYPW		= GP.YYYYPW
							 AND SA.FROM_SITE	= GP.FROM_SITE
							 AND SA.ITEM_ID		= GP.ITEM_ID)


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory : Char. Available / Formation Progress - FP Aging Stock 반영' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#PAST_FORM_PROGRESS_CHAR_AVAILABLE') IS NOT NULL	
			DROP TABLE #PAST_FORM_PROGRESS_CHAR_AVAILABLE;

		SELECT MI.YYYYPW
			  ,MI.ITEM_ID
			  ,MI.FROM_SITE					AS FROM_SITE
			  ,MI.OPERATION_GROUP			AS OPERATION_GROUP
			  ,CASE WHEN MI.QTY <  0  -- qty가 마이너스인 경우 고려 
					THEN MI.QTY
					WHEN MI.QTY >= ISNULL(FA.FP_FORM_PROGRESS, 0)
					THEN MI.QTY -  ISNULL(FA.FP_FORM_PROGRESS, 0)
					ELSE 0
				END								AS CHAR_AVAILABLE
			  ,CASE WHEN MI.QTY <  0  -- qty가 마이너스인 경우 고려 
					THEN 0
					WHEN MI.QTY >= ISNULL(FA.FP_FORM_PROGRESS, 0)
					THEN ISNULL(FA.FP_FORM_PROGRESS, 0)
					ELSE MI.QTY
			   END								AS FORM_PROGRESS 
			  ,MI.QTY							AS ENDING_INVENTORY
			  ,ISNULL(FA.FP_FORM_PROGRESS, 0)	AS FP_FORM_PROGRESS
		  INTO #PAST_FORM_PROGRESS_CHAR_AVAILABLE
		  FROM #PAST_CELL_CHAR_AVAILABLE MI WITH(NOLOCK)
			   LEFT JOIN #FP_AGING_STOCK FA WITH(NOLOCK)
					  ON FA.YYYYPW		= MI.YYYYPW
					 AND FA.FROM_SITE	= MI.FROM_SITE
					 AND FA.ITEM_ID		= MI.ITEM_ID
		 WHERE 1=1
		   AND MI.YYYYPW  < @V_PLAN_START_YYYYPW -- 과거 실적 구간


		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 실적 구간 Ending Inventory : Char. Available / Formation Progress measure 추가' 
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		;WITH TARGET_MEASURE AS (
			SELECT 'CELL_FORM_PROGRESS' AS MEASURE 
			UNION ALL
			SELECT 'CELL_CHAR_AVAILABLE' AS MEASURE 
		)
		INSERT INTO #TMP_TOBE_GLOBAL_PSI 
		SELECT EI.YYYYPW
			  ,EI.ITEM_ID
			  ,TM.MEASURE
			  ,EI.FROM_SITE			AS FROM_SITE
			  ,'-'			AS TO_SITE
			  ,'-'					AS INCOTERMS
			  ,'-'					AS VARIOUS_KEY -- 생산라인 or 운송모드 or 프로젝트
			  ,EI.OPERATION_GROUP	AS OPERATION_GROUP
			  ,'-'					AS TO_SITE_TYPE 
			  ,0.0					AS FROM_BOH_QTY
			  ,0.0					AS TO_BOH_QTY
			  ,CASE WHEN TM.MEASURE = 'CELL_FORM_PROGRESS'
					THEN FORM_PROGRESS
					ELSE CHAR_AVAILABLE
				END					AS QTY
		  FROM #PAST_FORM_PROGRESS_CHAR_AVAILABLE EI WITH(NOLOCK)
				INNER JOIN TARGET_MEASURE TM 
						ON 1=1 
		 WHERE 1=1

	----- End : Ending Inventory (과거 실적 구간 재고)
*/

        /* ----------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 대표Cell 품목 매핑 : 대표 Cell 품목 정보 추가');
        /* ----------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO;

        INSERT
          INTO GT_GPWW_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO
             ( REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT CASE WHEN C.MODEL_ID IS NOT NULL                                  /* AMDAU% 모듈 */
                    THEN C.CELL_ITEM_ID
                    WHEN A.OPERATION_GROUP = 'P' AND D.CELL_ITEM_ID IS NOT NULL  /* Pack */
                    THEN D.CELL_ITEM_ID
                    WHEN A.OPERATION_GROUP = 'P' AND E.CELL_ITEM_ID IS NOT NULL  /* Pack */
                    THEN E.CELL_ITEM_ID
                    WHEN A.OPERATION_GROUP = 'A' AND B.CELL_TYPE LIKE 'CA%'
                    THEN NVL(G.ITEM_ID_PROD, H.ITEM_ID_PROD)
                    WHEN A.OPERATION_GROUP = 'A' AND B.CELL_TYPE LIKE 'CP%'
                    THEN A.ITEM_ID
                    ELSE NULL
               END  AS REP_CELL_ITEM_ID      /* 대표셀 (CP:Cell Product) 모델 */
             , C.MODULE_ID
             , A.YYYYPW
             , A.ITEM_ID
             , A.MEASURE
             , A.FROM_SITE
             , A.TO_SITE
             , A.INCOTERMS
             , A.VARIOUS_KEY
             , A.OPERATION_GROUP
             , A.TO_SITE_TYPE
             , A.FROM_BOH_QTY
             , A.TO_BOH_QTY
             , A.QTY
          FROM GT_GPWW_TOBE_GLOBAL_PSI    A
             , GT_GPWW_SCP_MST_FINAL_ITEM B
             , GT_GPWW_MODULE_MODEL_INFO  C
             , GT_GPWW_CP_CELL_ITEM_INFO  D
             , GT_GPWW_ETC_CP_CELL_INFO   E
             , GT_GPWW_SCM_MST_SITE       F
             , GT_GPWW_CELL_PROD_ASSY_MAP G
             , GT_GPWW_CELL_PROD_ASSY_MAP H
         WHERE B.ITEM_ID(+)          = A.ITEM_ID
           AND C.MODULE_ID(+)        = A.ITEM_ID
           AND D.MODEL_ID(+)         = CASE WHEN C.MODEL_ID IS NOT NULL      /* AMDAU% 모듈 */
                                            THEN C.MODEL_ID
                                            WHEN A.OPERATION_GROUP = 'P'     /* 팩 */
                                            THEN A.ITEM_ID
                                            ELSE NULL
                                       END
           AND E.PARENT_ITEM_ID(+)   = A.ITEM_ID
           AND F.SCM_SITE_ID(+)      = CASE WHEN A.OPERATION_GROUP = 'A' THEN A.FROM_SITE END
           AND G.PLANT_ID(+)         = F.PLANT_ID
           AND G.ITEM_ID_ASSY(+)     = CASE WHEN A.OPERATION_GROUP = 'A' THEN A.ITEM_ID END
           AND H.ITEM_ID_ASSY(+)     = CASE WHEN A.OPERATION_GROUP = 'A' THEN A.ITEM_ID END
           AND F.SITE_TYPE(+)        = 'PLANT'
           AND G.CP_PRIORITY_1ST(+)  = 1
           AND H.CP_PRIORITY_2ND(+)  = 1;


        /* ----------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 셀그룹 및 환산수량 정보 추가 ');
        /* ----------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_SCP_RPT_GLOBAL_PSI_MD_WW;

        INSERT
          INTO GT_GPWW_SCP_RPT_GLOBAL_PSI_MD_WW
             ( CELL_GROUP
             , CELL_GROUP_YN
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT CASE WHEN B.GROUP_CODE1 IS NULL
                    THEN A.REP_CELL_ITEM_ID
                    ELSE B.GROUP_CODE1
               END AS CELL_GROUP
             , CASE WHEN B.GROUP_CODE1 IS NULL
                    THEN 'N'
                    ELSE 'Y'
               END AS CELL_GROUP_YN    /* 20240311 */
             , CASE WHEN A.OPERATION_GROUP = 'A'  THEN CAST(1.0 AS NUMBER(20,10))
                    WHEN C.CELL_CF IS NOT NULL    THEN CAST(TO_NUMBER(C.CELL_CF) AS NUMBER(20,10))
                    WHEN D.CELL_CF IS NOT NULL    THEN CAST(TO_NUMBER(D.CELL_CF) AS NUMBER(20,10))
                    WHEN E.CELL_CF IS NOT NULL    THEN CAST(TO_NUMBER(E.CELL_CF) AS NUMBER(20,10))
                    ELSE CAST(1.0 AS NUMBER(20,10))
               END  AS CELL_CF
             , CASE WHEN A.OPERATION_GROUP = 'A'  THEN 'CELL'
                    WHEN C.CELL_CF IS NOT NULL    THEN 'CF'
                    WHEN D.CELL_CF IS NOT NULL    THEN 'CF2'
                    WHEN E.CELL_CF IS NOT NULL    THEN 'CF3'
                    ELSE 'NULL'
               END  AS CELL_CF_TYPE
             , A.REP_CELL_ITEM_ID
             , A.MODULE_ID
             , A.YYYYPW
             , A.ITEM_ID
             , A.MEASURE
             , A.FROM_SITE
             , A.TO_SITE
             , A.INCOTERMS
             , A.VARIOUS_KEY
             , A.OPERATION_GROUP
             , A.TO_SITE_TYPE
             , A.FROM_BOH_QTY
             , A.TO_BOH_QTY
             , A.QTY
          FROM GT_GPWW_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO A
             , GT_GPWW_SCP_MST_FINAL_ITEM                 B   /* cell group 정보 참조 */
             , GT_GPWW_SCP_MST_ITEM_CELL_CF               C
             , GT_GPWW_SCP_MST_ITEM_CELL_CF               D
             , GT_GPWW_SCP_MST_ITEM_CELL_CF               E
         WHERE B.ITEM_ID(+)           = A.REP_CELL_ITEM_ID
           AND C.ITEM_ID(+)           = A.ITEM_ID
           AND D.ITEM_ID(+)           = CASE WHEN A.ITEM_ID LIKE '%-_'
                                              AND A.OPERATION_GROUP = 'P'
                                              AND C.CELL_CF IS NULL
                                             THEN SUBSTR(A.ITEM_ID, 1, LENGTH(RTRIM(A.ITEM_ID)) - 2)
                                        END
           AND E.ITEM_ID(+)           = CASE WHEN A.ITEM_ID LIKE '%-__'
                                              AND A.OPERATION_GROUP = 'P'
                                              AND C.CELL_CF IS NULL
                                              AND D.CELL_CF IS NULL
                                             THEN SUBSTR(A.ITEM_ID, 1, LENGTH(RTRIM(A.ITEM_ID)) - 3)
                                        END
           AND C.CELL_CF(+)           IS NOT NULL
           AND TO_NUMBER(C.CELL_CF(+)) != 0.0
           AND D.CELL_CF(+)           IS NOT NULL
           AND TO_NUMBER(D.CELL_CF(+)) != 0.0
           AND E.CELL_CF(+)           IS NOT NULL
           AND TO_NUMBER(E.CELL_CF(+)) != 0.0
           AND A.REP_CELL_ITEM_ID IS NOT NULL;  /* 대표 Cell 정보가 없는 건 제외 */

        /* @@@ BOM 정보에 문제가 있는 경우 (=하위셀을 못찾을경우) 해당 모듈팩에 대한 Group code 를 찾아 Global PSI New 재고로 반영 */
        INSERT
          INTO GT_GPWW_SCP_RPT_GLOBAL_PSI_MD_WW
             ( CELL_GROUP
             , CELL_GROUP_YN
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT CASE WHEN B.GROUP_CODE1 IS NULL
                    THEN A.REP_CELL_ITEM_ID
                    ELSE B.GROUP_CODE1
               END AS CELL_GROUP
             , CASE WHEN B.GROUP_CODE1 IS NULL
                    THEN 'N'
                    ELSE 'Y'
               END AS CELL_GROUP_YN    /* 20240311 */
             , CASE WHEN A.OPERATION_GROUP = 'A'  THEN CAST(1.0 AS NUMBER(20,10))
                    WHEN C.CELL_CF IS NOT NULL    THEN CAST(TO_NUMBER(C.CELL_CF) AS NUMBER(20,10))
                    WHEN D.CELL_CF IS NOT NULL    THEN CAST(TO_NUMBER(D.CELL_CF) AS NUMBER(20,10))
                    WHEN E.CELL_CF IS NOT NULL    THEN CAST(TO_NUMBER(E.CELL_CF) AS NUMBER(20,10))
                    ELSE CAST(1.0 AS NUMBER(20,10))
               END  AS CELL_CF
             , CASE WHEN A.OPERATION_GROUP = 'A'  THEN 'CELL'
                    WHEN C.CELL_CF IS NOT NULL    THEN 'CF'
                    WHEN D.CELL_CF IS NOT NULL    THEN 'CF2'
                    WHEN E.CELL_CF IS NOT NULL    THEN 'CF3'
                    ELSE 'NULL'
               END  AS CELL_CF_TYPE
             , A.REP_CELL_ITEM_ID
             , A.MODULE_ID
             , A.YYYYPW
             , A.ITEM_ID
             , A.MEASURE
             , A.FROM_SITE
             , A.TO_SITE
             , A.INCOTERMS
             , A.VARIOUS_KEY
             , A.OPERATION_GROUP
             , A.TO_SITE_TYPE
             , A.FROM_BOH_QTY
             , A.TO_BOH_QTY
             , A.QTY
          FROM GT_GPWW_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO A
             , GT_GPWW_SCP_MST_FINAL_ITEM                 B   /* cell group 정보 참조 */
             , GT_GPWW_SCP_MST_ITEM_CELL_CF               C
             , GT_GPWW_SCP_MST_ITEM_CELL_CF               D
             , GT_GPWW_SCP_MST_ITEM_CELL_CF               E
         WHERE B.ITEM_ID              = A.ITEM_ID       /* REP_CELL_ITEM_ID 대신 ITEM 기준으로 */
           AND C.ITEM_ID(+)           = A.ITEM_ID
           AND D.ITEM_ID(+)           = CASE WHEN A.ITEM_ID LIKE '%-_'
                                              AND A.OPERATION_GROUP = 'P'
                                              AND C.CELL_CF IS NULL
                                             THEN SUBSTR(A.ITEM_ID, 1, LENGTH(RTRIM(A.ITEM_ID)) - 2)
                                        END
           AND E.ITEM_ID(+)           = CASE WHEN A.ITEM_ID LIKE '%-__'
                                              AND A.OPERATION_GROUP = 'P'
                                              AND C.CELL_CF IS NULL
                                              AND D.CELL_CF IS NULL
                                             THEN SUBSTR(A.ITEM_ID, 1, LENGTH(RTRIM(A.ITEM_ID)) - 3)
                                        END
           AND B.GROUP_CODE1 IS NOT NULL
           AND C.CELL_CF(+)           IS NOT NULL
           AND TO_NUMBER(C.CELL_CF(+)) != 0.0
           AND D.CELL_CF(+)           IS NOT NULL
           AND TO_NUMBER(D.CELL_CF(+)) != 0.0
           AND E.CELL_CF(+)           IS NOT NULL
           AND TO_NUMBER(E.CELL_CF(+)) != 0.0
           AND A.REP_CELL_ITEM_ID IS NULL;  /* 대표 Cell 정보가 없는 건 */

        UPDATE GT_GPWW_SCP_RPT_GLOBAL_PSI_MD_WW
           SET REP_CELL_ITEM_ID = ITEM_ID
         WHERE 1=1
           AND REP_CELL_ITEM_ID IS NULL;
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### GAP(RTF - MKT_FCST) measure');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_GAP_RTF_MKT_FCST;

        INSERT
          INTO GT_GPWW_GAP_RTF_MKT_FCST
             ( CELL_GROUP
             , CELL_GROUP_YN
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT CELL_GROUP
             , CELL_GROUP_YN    /* 20240311 */
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYPW
             , ITEM_ID
             , 'GAP'            AS MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , SUM(CASE WHEN MEASURE = 'MKT_FCST' THEN QTY * (-1) ELSE QTY END) AS QTY
          FROM GT_GPWW_SCP_RPT_GLOBAL_PSI_MD_WW
         WHERE 1=1
           AND MEASURE IN ('MKT_FCST', 'RTF')
           AND YYYYPW >= V_PLAN_START_YYYYPW
         GROUP BY CELL_GROUP
                , CELL_GROUP_YN    /* 20240311 */
                , CELL_CF
                , CELL_CF_TYPE
                , REP_CELL_ITEM_ID
                , MODULE_ID
                , YYYYPW
                , ITEM_ID
                , FROM_SITE
                , TO_SITE
                , INCOTERMS
                , VARIOUS_KEY
                , OPERATION_GROUP
                , TO_SITE_TYPE
                , FROM_BOH_QTY
                , TO_BOH_QTY;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### AS GAP(AS RTF - AS MKT_FCST) measure');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_GAP_RTF_MKT_FCST
             ( CELL_GROUP
             , CELL_GROUP_YN
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT CELL_GROUP
             , CELL_GROUP_YN    /* 20240311 */
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYPW
             , ITEM_ID
             , 'AS_GAP'         AS MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , SUM(CASE WHEN MEASURE = 'AS_MKT_FCST' THEN QTY * (-1) ELSE QTY END) AS QTY
          FROM GT_GPWW_SCP_RPT_GLOBAL_PSI_MD_WW
         WHERE 1=1
           AND MEASURE IN ('AS_MKT_FCST', 'AS_RTF')
           AND YYYYPW >= V_PLAN_START_YYYYPW
         GROUP BY CELL_GROUP
                , CELL_GROUP_YN    /* 20240311 */
                , CELL_CF
                , CELL_CF_TYPE
                , REP_CELL_ITEM_ID
                , MODULE_ID
                , YYYYPW
                , ITEM_ID
                , FROM_SITE
                , TO_SITE
                , INCOTERMS
                , VARIOUS_KEY
                , OPERATION_GROUP
                , TO_SITE_TYPE
                , FROM_BOH_QTY
                , TO_BOH_QTY;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### (AS포함) GAP(AS RTF - AS MKT_FCST) measure 추가');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_SCP_RPT_GLOBAL_PSI_MD_WW
             ( CELL_GROUP
             , CELL_GROUP_YN
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
        SELECT CELL_GROUP
             , CELL_GROUP_YN
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
          FROM GT_GPWW_GAP_RTF_MKT_FCST;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### ACC GAP(RTF - MKT_FCST) measure 추가');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPWW_SCP_RPT_GLOBAL_PSI_MD_WW
             ( CELL_GROUP
             , CELL_GROUP_YN
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , TO_SITE_TYPE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY )
          WITH GAP_MEASURE AS (
                SELECT A.CELL_GROUP
                     , A.CELL_GROUP_YN    /* 20240311 */
                     , A.CELL_CF
                     , A.REP_CELL_ITEM_ID
                     , B.YYYYPW
                     , A.ITEM_ID
                     , A.MEASURE
                     , A.TO_SITE
                     , A.INCOTERMS
                     , A.VARIOUS_KEY
                     , A.OPERATION_GROUP
                     , SUM(CASE WHEN B.YYYYPW = A.YYYYPW THEN A.QTY ELSE 0.0 END) AS QTY
                  FROM GT_GPWW_GAP_RTF_MKT_FCST A
                     , GT_GPWW_PW_LIST          B
                 WHERE 1=1
                   AND B.YYYYPW >= V_PLAN_START_YYYYPW  /* 미래 계획 구간만 */
                 GROUP BY A.CELL_GROUP
                        , A.CELL_GROUP_YN    /* 20240311 */
                        , A.CELL_CF
                        , A.REP_CELL_ITEM_ID
                        , B.YYYYPW
                        , A.ITEM_ID
                        , A.MEASURE
                        , A.TO_SITE
                        , A.INCOTERMS
                        , A.VARIOUS_KEY
                        , A.OPERATION_GROUP
               )
        SELECT C.CELL_GROUP
             , C.CELL_GROUP_YN    /* 20240311 */
             , C.CELL_CF
             , '-'              AS CELL_CF_TYPE
             , C.REP_CELL_ITEM_ID
             , '-'              AS MODULE_ID
             , C.YYYYPW
             , C.ITEM_ID
             , CASE WHEN C.MEASURE = 'GAP' THEN 'GAP_ACC' ELSE 'AS_GAP_ACC' END AS MEASURE
             , '-'              AS FROM_SITE
             , C.TO_SITE
             , C.INCOTERMS
             , C.VARIOUS_KEY
             , C.OPERATION_GROUP
             , '-'              AS TO_SITE_TYPE
             , 0.0              AS FROM_BOH_QTY
             , 0.0              AS TO_BOH_QTY
             , SUM(C.QTY) OVER (PARTITION BY C.ITEM_ID
                                           , C.TO_SITE
                                           , C.INCOTERMS
                                           , C.VARIOUS_KEY
                                           , CASE WHEN C.MEASURE = 'GAP' THEN 'GAP_ACC' ELSE 'AS_GAP_ACC' END
                                    ORDER BY C.YYYYPW) AS ACC_QTY
          FROM GAP_MEASURE C
         WHERE 1=1;

        /* ----- Begin DIO 계산 ======================================================================================================================================================= */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 주별 일수 정보 (partial week)');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_WW_DAYS_INFO;

        INSERT
          INTO GT_GPWW_WW_DAYS_INFO
             ( YYYYPW
             , PW_FROM_YMD
             , PW_TO_YMD
             , PW_DAYS
             , YYYYPW_SEQ
             , NEXT_PW_1
             , NEXT_PW_2
             , NEXT_PW_3
             , NEXT_PW_4
             , NEXT_PW_5
             , NEXT_PW_6
             , NEXT_PW_7
             , NEXT_PW_8
             , NEXT_PW_9
             , NEXT_PW_10
             , NEXT_PW_11
             , NEXT_PW_12
             , NEXT_PW_13
             , NEXT_PW_14
             , NEXT_PW_15
             , NEXT_PW_16
             , NEXT_PW_17
             , NEXT_PW_18
             , NEXT_PW_19
             , NEXT_PW_20
             , NEXT_PW_21
             , NEXT_PW_22
             , NEXT_PW_23
             , NEXT_PW_24
             , NEXT_PW_25
             , NEXT_PW_26
             , NEXT_PW_27
             , NEXT_PW_28
             , NEXT_PW_29
             , NEXT_PW_30
             , NEXT_PW_31
             , NEXT_PW_32
             , NEXT_PW_33
             , NEXT_PW_34
             , NEXT_PW_35
             , NEXT_PW_36
             , NEXT_PW_37
             , NEXT_PW_38
             , NEXT_PW_39
             , NEXT_PW_40
             , NEXT_PW_41
             , NEXT_PW_42
             , NEXT_PW_43
             , NEXT_PW_44
             , NEXT_PW_45
             , NEXT_PW_46
             , NEXT_PW_47
             , NEXT_PW_48
             , NEXT_PW_49
             , NEXT_PW_50
             , NEXT_PW_51
             , NEXT_PW_52
             , NEXT_PW_53
             , NEXT_PW_54
             , NEXT_PW_55
             , NEXT_PW_56
             , NEXT_PW_57
             , NEXT_PW_58
             , NEXT_PW_59
             , NEXT_PW_60
             , NEXT_PW_61
             , NEXT_PW_62
             , NEXT_PW_63
             , DAYS_NEXT_1
             , DAYS_NEXT_2
             , DAYS_NEXT_3
             , DAYS_NEXT_4
             , DAYS_NEXT_5
             , DAYS_NEXT_6
             , DAYS_NEXT_7
             , DAYS_NEXT_8
             , DAYS_NEXT_9
             , DAYS_NEXT_10
             , DAYS_NEXT_11
             , DAYS_NEXT_12
             , DAYS_NEXT_13
             , DAYS_NEXT_14
             , DAYS_NEXT_15
             , DAYS_NEXT_16
             , DAYS_NEXT_17
             , DAYS_NEXT_18
             , DAYS_NEXT_19
             , DAYS_NEXT_20
             , DAYS_NEXT_21
             , DAYS_NEXT_22
             , DAYS_NEXT_23
             , DAYS_NEXT_24
             , DAYS_NEXT_25
             , DAYS_NEXT_26
             , DAYS_NEXT_27
             , DAYS_NEXT_28
             , DAYS_NEXT_29
             , DAYS_NEXT_30
             , DAYS_NEXT_31
             , DAYS_NEXT_32
             , DAYS_NEXT_33
             , DAYS_NEXT_34
             , DAYS_NEXT_35
             , DAYS_NEXT_36
             , DAYS_NEXT_37
             , DAYS_NEXT_38
             , DAYS_NEXT_39
             , DAYS_NEXT_40
             , DAYS_NEXT_41
             , DAYS_NEXT_42
             , DAYS_NEXT_43
             , DAYS_NEXT_44
             , DAYS_NEXT_45
             , DAYS_NEXT_46
             , DAYS_NEXT_47
             , DAYS_NEXT_48
             , DAYS_NEXT_49
             , DAYS_NEXT_50
             , DAYS_NEXT_51
             , DAYS_NEXT_52
             , DAYS_NEXT_53
             , DAYS_NEXT_54
             , DAYS_NEXT_55
             , DAYS_NEXT_56
             , DAYS_NEXT_57
             , DAYS_NEXT_58
             , DAYS_NEXT_59
             , DAYS_NEXT_60
             , DAYS_NEXT_61
             , DAYS_NEXT_62
             , DAYS_NEXT_63
             , ACC_DAYS_1
             , ACC_DAYS_2
             , ACC_DAYS_3
             , ACC_DAYS_4
             , ACC_DAYS_5
             , ACC_DAYS_6
             , ACC_DAYS_7
             , ACC_DAYS_8
             , ACC_DAYS_9
             , ACC_DAYS_10
             , ACC_DAYS_11
             , ACC_DAYS_12
             , ACC_DAYS_13
             , ACC_DAYS_14
             , ACC_DAYS_15
             , ACC_DAYS_16
             , ACC_DAYS_17
             , ACC_DAYS_18
             , ACC_DAYS_19
             , ACC_DAYS_20
             , ACC_DAYS_21
             , ACC_DAYS_22
             , ACC_DAYS_23
             , ACC_DAYS_24
             , ACC_DAYS_25
             , ACC_DAYS_26
             , ACC_DAYS_27
             , ACC_DAYS_28
             , ACC_DAYS_29
             , ACC_DAYS_30
             , ACC_DAYS_31
             , ACC_DAYS_32
             , ACC_DAYS_33
             , ACC_DAYS_34
             , ACC_DAYS_35
             , ACC_DAYS_36
             , ACC_DAYS_37
             , ACC_DAYS_38
             , ACC_DAYS_39
             , ACC_DAYS_40
             , ACC_DAYS_41
             , ACC_DAYS_42
             , ACC_DAYS_43
             , ACC_DAYS_44
             , ACC_DAYS_45
             , ACC_DAYS_46
             , ACC_DAYS_47
             , ACC_DAYS_48
             , ACC_DAYS_49
             , ACC_DAYS_50
             , ACC_DAYS_51
             , ACC_DAYS_52
             , ACC_DAYS_53
             , ACC_DAYS_54
             , ACC_DAYS_55
             , ACC_DAYS_56
             , ACC_DAYS_57
             , ACC_DAYS_58
             , ACC_DAYS_59
             , ACC_DAYS_60
             , ACC_DAYS_61
             , ACC_DAYS_62
             , ACC_DAYS_63 )
          WITH NEXT_PW_SEQ_INFO AS (
               SELECT C.YYYYPW
                    , COUNT(C.YYYYMMDD)                                       AS PW_DAYS
                    , DENSE_RANK() OVER (PARTITION BY 'A' ORDER BY C.YYYYPW)  AS YYYYPW_SEQ
                 FROM SCM_MST_BUCKET C
                WHERE 1=1
                  AND C.YYYYMM BETWEEN SUBSTR(V_RESULT_FROM_YYYYMMDD, 1, 6)
                                   AND TO_CHAR(TO_DATE(V_HORIZON_END_YYYYMMDD, 'YYYYMMDD') + (63 * 7), 'YYYYMM')   /* 계획 참조 종료일 + 12month */
                GROUP BY C.YYYYPW
          )
        SELECT A.YYYYPW
             , A.PW_FROM_YMD
             , A.PW_TO_YMD
             , A.PW_DAYS
             , A.YYYYPW_SEQ
               /* ----------------------------------------- */
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 1  THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_1
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 2  THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_2
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 3  THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_3
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 4  THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_4
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 5  THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_5
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 6  THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_6
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 7  THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_7
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 8  THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_8
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 9  THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_9
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 10 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_10
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 11 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_11
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 12 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_12
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 13 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_13
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 14 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_14
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 15 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_15
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 16 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_16
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 17 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_17
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 18 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_18
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 19 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_19
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 20 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_20
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 21 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_21
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 22 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_22
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 23 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_23
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 24 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_24
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 25 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_25
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 26 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_26
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 27 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_27
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 28 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_28
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 29 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_29
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 30 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_30
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 31 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_31
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 32 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_32
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 33 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_33
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 34 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_34
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 35 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_35
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 36 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_36
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 37 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_37
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 38 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_38
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 39 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_39
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 40 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_40
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 41 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_41
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 42 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_42
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 43 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_43
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 44 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_44
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 45 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_45
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 46 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_46
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 47 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_47
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 48 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_48
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 49 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_49
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 50 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_50
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 51 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_51
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 52 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_52
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 53 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_53
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 54 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_54
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 55 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_55
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 56 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_56
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 57 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_57
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 58 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_58
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 59 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_59
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 60 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_60
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 61 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_61
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 62 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_62
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 63 THEN B.YYYYPW ELSE NULL END)  AS NEXT_PW_63
               /* ----------------------------------------- */
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 1  THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_1
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 2  THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_2
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 3  THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_3
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 4  THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_4
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 5  THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_5
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 6  THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_6
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 7  THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_7
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 8  THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_8
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 9  THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_9
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 10 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_10
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 11 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_11
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 12 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_12
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 13 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_13
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 14 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_14
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 15 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_15
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 16 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_16
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 17 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_17
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 18 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_18
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 19 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_19
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 20 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_20
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 21 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_21
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 22 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_22
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 23 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_23
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 24 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_24
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 25 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_25
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 26 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_26
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 27 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_27
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 28 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_28
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 29 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_29
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 30 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_30
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 31 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_31
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 32 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_32
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 33 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_33
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 34 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_34
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 35 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_35
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 36 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_36
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 37 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_37
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 38 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_38
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 39 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_39
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 40 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_40
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 41 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_41
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 42 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_42
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 43 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_43
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 44 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_44
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 45 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_45
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 46 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_46
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 47 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_47
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 48 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_48
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 49 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_49
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 50 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_50
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 51 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_51
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 52 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_52
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 53 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_53
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 54 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_54
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 55 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_55
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 56 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_56
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 57 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_57
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 58 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_58
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 59 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_59
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 60 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_60
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 61 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_61
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 62 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_62
             , MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 63 THEN B.PW_DAYS ELSE 0 END)  AS DAYS_NEXT_63
               /* ----------------------------------------- */
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 1  THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_1
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 2  THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_2
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 3  THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_3
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 4  THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_4
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 5  THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_5
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 6  THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_6
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 7  THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_7
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 8  THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_8
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 9  THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_9
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 10 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_10
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 11 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_11
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 12 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_12
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 13 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_13
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 14 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_14
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 15 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_15
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 16 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_16
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 17 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_17
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 18 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_18
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 19 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_19
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 20 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_20
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 21 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_21
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 22 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_22
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 23 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_23
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 24 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_24
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 25 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_25
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 26 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_26
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 27 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_27
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 28 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_28
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 29 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_29
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 30 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_30
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 31 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_31
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 32 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_32
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 33 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_33
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 34 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_34
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 35 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_35
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 36 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_36
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 37 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_37
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 38 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_38
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 39 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_39
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 40 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_40
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 41 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_41
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 42 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_42
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 43 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_43
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 44 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_44
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 45 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_45
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 46 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_46
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 47 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_47
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 48 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_48
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 49 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_49
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 50 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_50
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 51 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_51
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 52 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_52
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 53 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_53
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 54 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_54
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 55 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_55
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 56 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_56
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 57 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_57
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 58 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_58
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 59 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_59
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 60 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_60
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 61 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_61
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 62 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_62
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 63 THEN B.PW_DAYS ELSE 0 END)  AS ACC_DAYS_63
               /* ----------------------------------------- */
          FROM GT_GPWW_PW_LIST   A
             , NEXT_PW_SEQ_INFO  B
         WHERE 1=1
           AND B.YYYYPW_SEQ(+) BETWEEN A.YYYYPW_SEQ + 1
                                   AND A.YYYYPW_SEQ + 64
         GROUP BY A.YYYYPW
                , A.PW_FROM_YMD
                , A.PW_TO_YMD
                , A.PW_DAYS
                , A.YYYYPW_SEQ;


        /* --------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 셀그룹별 재고 및 RTF 정보 ');
        /* --------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_BASE_DATA_FOR_DIO;

        INSERT
          INTO GT_GPWW_BASE_DATA_FOR_DIO
             ( CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , MEASURE
             , YYYYPW
             , YYYYPW_SEQ
             , PW_DAYS
             , QTY )
          WITH RTF_N_INV AS (
               SELECT C.CELL_GROUP
                    , C.CELL_GROUP_YN   /* 20240311 */
                    , C.YYYYPW
                    , 'C'               AS OPERATION_GROUP
                    , CASE WHEN C.MEASURE IN ('RTF', 'AS_RTF')
                           THEN 'RTF'
                           ELSE 'INV'
                      END                       AS MEASURE
                    , SUM(C.CELL_CF * C.QTY)    AS QTY
                 FROM GT_GPWW_SCP_RPT_GLOBAL_PSI_MD_WW C
                WHERE 1=1
                  AND C.MEASURE IN (
                                     /* 재고 Measure */
                                     'TO_SITE_EOH'
                                    ,'AS_INV'
                                    ,'INTRANSIT'
                                    ,'PACK_EOH'
                                    ,'PACK_CELL_EOH'
                                    ,'SEMI_INTRANSIT'
                                    ,'CELL_EOH'
                                    ,'CELL_CHAR_AVAILABLE'
                                    ,'CELL_FORM_PROGRESS'
                                     /* RTF */
                                    ,'RTF'
                                    ,'AS_RTF'
                                   )
                GROUP BY C.CELL_GROUP
                       , C.CELL_GROUP_YN   /* 20240311 */
                       , C.YYYYPW
                       , CASE WHEN C.MEASURE IN ('RTF', 'AS_RTF')
                              THEN 'RTF'
                              ELSE 'INV'
                         END
          )
        SELECT A.CELL_GROUP
             , A.CELL_GROUP_YN   /* 20240311 */
             , A.OPERATION_GROUP
             , A.MEASURE
             , B.YYYYPW
             , B.YYYYPW_SEQ
             , B.PW_DAYS
             , SUM(CASE WHEN B.YYYYPW = A.YYYYPW
                        THEN A.QTY
                        ELSE 0
                   END) AS QTY
          FROM RTF_N_INV            A
             , GT_GPWW_WW_DAYS_INFO B   /* 데이터가 없는 월 0으로 생성을 위해. */
         WHERE 1=1
         GROUP BY A.CELL_GROUP
                , A.CELL_GROUP_YN   /* 20240311 */
                , A.OPERATION_GROUP
                , A.MEASURE
                , B.YYYYPW
                , B.YYYYPW_SEQ
                , B.PW_DAYS;


        /* --------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 셀그룹별 재고 및 RTF 정보(표준레포트) ');  /* @@@ */
        /* --------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_BASE_DATA_FOR_DIO_CELLGROUP;

        INSERT
          INTO GT_GPWW_BASE_DATA_FOR_DIO_CELLGROUP
             ( CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , MEASURE
             , YYYYPW
             , YYYYPW_SEQ
             , PW_DAYS
             , QTY )
          WITH RTF_N_INV AS (
               SELECT IB.CELL_GROUP
                    , IB.CELL_GROUP_YN   /* 20240311 */
                    , 'C'                AS OPERATION_GROUP
                      /* ,GP.OPERATION_GROUP		AS  OPERATION_GROUP */
                    , IB.YYYYPW
                    , SUM(IB.RTF_SALES)  AS RTF_SALES
                    , SUM(IB.RTF_PACK)   AS RTF_PACK
                    , SUM(IB.RTF_CELL)   AS RTF_CELL
                    , SUM(IB.INV_SALES)  AS INV_SALES
                    , SUM(IB.INV_PACK)   AS INV_PACK
                    , SUM(IB.INV_CELL)   AS INV_CELL
                 FROM (SELECT C.CELL_GROUP
                            , C.CELL_GROUP_YN   /* 20240311 */
                            , C.OPERATION_GROUP
                            , C.YYYYPW
                            , CASE WHEN C.MEASURE IN ('RTF') THEN C.CELL_CF * C.QTY ELSE 0 END AS RTF_SALES
                            , CASE WHEN C.MEASURE IN ('RTF', 'AS_IN_PLAN') THEN C.CELL_CF * C.QTY ELSE 0 END AS RTF_PACK
                            , CASE WHEN C.MEASURE IN ('RTF', 'AS_IN_PLAN') THEN C.CELL_CF * C.QTY ELSE 0 END AS RTF_CELL
                            , CASE WHEN C.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT') THEN C.CELL_CF * C.QTY ELSE 0 END AS INV_SALES
                            , CASE WHEN C.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH') THEN C.CELL_CF * C.QTY ELSE 0 END AS INV_PACK
                            , CASE WHEN C.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH','PACK_CELL_EOH','SEMI_INTRANSIT','CELL_EOH','CELL_CHAR_AVAILABLE','CELL_FORM_PROGRESS') THEN C.CELL_CF * C.QTY ELSE 0 END AS INV_CELL
                         FROM GT_GPWW_SCP_RPT_GLOBAL_PSI_MD_WW C
                        WHERE 1=1
                          AND C.MEASURE IN (
                                             /* 재고 MEASURE */
                                             'TO_SITE_EOH'
                                            ,'AS_INV'
                                            ,'AS_IN_PLAN'
                                            ,'INTRANSIT'
                                            ,'PACK_EOH'
                                            ,'PACK_CELL_EOH'
                                            ,'SEMI_INTRANSIT'
                                            ,'CELL_EOH'
                                            ,'CELL_CHAR_AVAILABLE'
                                            ,'CELL_FORM_PROGRESS'
                                             /* RTF */
                                            ,'RTF'
                                            ,'AS_RTF'
                                           )
                      ) IB
                GROUP BY IB.CELL_GROUP
                       , IB.CELL_GROUP_YN   /* 20240311 */
                         /* ,GP.OPERATION_GROUP */
                       , IB.YYYYPW
          )
        SELECT A.CELL_GROUP
             , A.CELL_GROUP_YN   /* 20240311 */
             , A.OPERATION_GROUP
             , IA.MEASURE
             , B.YYYYPW
             , B.YYYYPW_SEQ
             , B.PW_DAYS
             , SUM(CASE WHEN B.YYYYPW = A.YYYYPW
                        THEN (
                              CASE WHEN IA.MEASURE = 'RTF_SALES' THEN A.RTF_SALES
                                   WHEN IA.MEASURE = 'RTF_PACK'  THEN A.RTF_PACK
                                   WHEN IA.MEASURE = 'RTF_CELL'  THEN A.RTF_CELL
                                   WHEN IA.MEASURE = 'INV_SALES' THEN A.INV_SALES
                                   WHEN IA.MEASURE = 'INV_PACK'  THEN A.INV_PACK
                                   WHEN IA.MEASURE = 'INV_CELL'  THEN A.INV_CELL
                              END
                             )
                        ELSE 0
                   END) AS QTY
          FROM RTF_N_INV            A
             , (SELECT 'RTF_SALES' AS MEASURE FROM DUAL UNION
                SELECT 'RTF_PACK'  AS MEASURE FROM DUAL UNION
                SELECT 'RTF_CELL'  AS MEASURE FROM DUAL UNION
                SELECT 'INV_SALES' AS MEASURE FROM DUAL UNION
                SELECT 'INV_PACK'  AS MEASURE FROM DUAL UNION
                SELECT 'INV_CELL'  AS MEASURE FROM DUAL
               ) IA
             , GT_GPWW_WW_DAYS_INFO B   /* 데이터가 없는 월 0으로 생성을 위해. */
         WHERE 1=1
         GROUP BY A.CELL_GROUP
                , A.CELL_GROUP_YN   /* 20240311 */
                , A.OPERATION_GROUP
                , IA.MEASURE
                , B.YYYYPW
                , B.YYYYPW_SEQ
                , B.PW_DAYS;


        /* --------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 셀그룹별 재고 및 RTF 정보(Detail 표준레포트)');  /* 고도화 */
        /* --------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_BASE_DATA_FOR_DIO_DETAILREPORT;

        INSERT
          INTO GT_GPWW_BASE_DATA_FOR_DIO_DETAILREPORT
             ( CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , PRODUCT_LEVEL1
             , PRODUCT_LEVEL2
             , MEASURE
             , YYYYPW
             , YYYYPW_SEQ
             , PW_DAYS
             , QTY )
          WITH RTF_N_INV AS (
               SELECT IB.CELL_GROUP
                    , IB.CELL_GROUP_YN   /* 20240311 */
                    , 'C'                AS OPERATION_GROUP
                      /* ,GP.OPERATION_GROUP		AS  OPERATION_GROUP */
                    , IB.PRODUCT_LEVEL1
                    , IB.PRODUCT_LEVEL2
                    , IB.YYYYPW
                    , SUM(IB.RTF_SALES)  AS RTF_SALES
                    , SUM(IB.RTF_PACK)   AS RTF_PACK
                    , SUM(IB.RTF_CELL)   AS RTF_CELL
                    , SUM(IB.INV_SALES)  AS INV_SALES
                    , SUM(IB.INV_PACK)   AS INV_PACK
                    , SUM(IB.INV_CELL)   AS INV_CELL
                 FROM (SELECT C.CELL_GROUP
                            , C.CELL_GROUP_YN   /* 20240311 */
                            , C.OPERATION_GROUP
                            , D.GROUP_CODE6 AS PRODUCT_LEVEL1
                            , D.GROUP_CODE7 AS PRODUCT_LEVEL2
                            , C.YYYYPW
                            , CASE WHEN C.MEASURE IN ('RTF') THEN C.CELL_CF * C.QTY ELSE 0 END AS RTF_SALES
                            , CASE WHEN C.MEASURE IN ('RTF', 'AS_IN_PLAN') THEN C.CELL_CF * C.QTY ELSE 0 END AS RTF_PACK
                            , CASE WHEN C.MEASURE IN ('RTF', 'AS_IN_PLAN') THEN C.CELL_CF * C.QTY ELSE 0 END AS RTF_CELL
                            , CASE WHEN C.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT') THEN C.CELL_CF * C.QTY ELSE 0 END AS INV_SALES
                            , CASE WHEN C.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH') THEN C.CELL_CF * C.QTY ELSE 0 END AS INV_PACK
                            , CASE WHEN C.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH','PACK_CELL_EOH','SEMI_INTRANSIT','CELL_EOH','CELL_CHAR_AVAILABLE','CELL_FORM_PROGRESS') THEN C.CELL_CF * C.QTY ELSE 0 END AS INV_CELL
                         FROM GT_GPWW_SCP_RPT_GLOBAL_PSI_MD_WW C
                            , GT_GPWW_SCP_MST_FINAL_ITEM      D
                        WHERE 1=1
                          AND C.ITEM_ID         = D.ITEM_ID(+)
                          AND C.OPERATION_GROUP = D.OPERATION_GROUP(+)
                          AND C.MEASURE IN (
                                             /* 재고 MEASURE */
                                             'TO_SITE_EOH'
                                            ,'AS_INV'
                                            ,'AS_IN_PLAN'
                                            ,'INTRANSIT'
                                            ,'PACK_EOH'
                                            ,'PACK_CELL_EOH'
                                            ,'SEMI_INTRANSIT'
                                            ,'CELL_EOH'
                                            ,'CELL_CHAR_AVAILABLE'
                                            ,'CELL_FORM_PROGRESS'
                                             /* RTF */
                                            ,'RTF'
                                            ,'AS_RTF'
                                           )
                      ) IB
                GROUP BY IB.CELL_GROUP
                       , IB.CELL_GROUP_YN   /* 20240311 */
                         /* ,GP.OPERATION_GROUP */
                       , IB.PRODUCT_LEVEL1
                       , IB.PRODUCT_LEVEL2
                       , IB.YYYYPW
          )
        SELECT A.CELL_GROUP
             , A.CELL_GROUP_YN   /* 20240311 */
             , A.OPERATION_GROUP
             , NVL(A.PRODUCT_LEVEL1, '-') AS PRODUCT_LEVEL1
             , NVL(A.PRODUCT_LEVEL2, '-') AS PRODUCT_LEVEL2
             , IA.MEASURE
             , B.YYYYPW
             , B.YYYYPW_SEQ
             , B.PW_DAYS
             , SUM(CASE WHEN B.YYYYPW = A.YYYYPW
                        THEN (
                              CASE WHEN IA.MEASURE = 'RTF_SALES' THEN A.RTF_SALES
                                   WHEN IA.MEASURE = 'RTF_PACK'  THEN A.RTF_PACK
                                   WHEN IA.MEASURE = 'RTF_CELL'  THEN A.RTF_CELL
                                   WHEN IA.MEASURE = 'INV_SALES' THEN A.INV_SALES
                                   WHEN IA.MEASURE = 'INV_PACK'  THEN A.INV_PACK
                                   WHEN IA.MEASURE = 'INV_CELL'  THEN A.INV_CELL
                              END
                             )
                        ELSE 0
                   END) AS QTY
          FROM RTF_N_INV            A
             , (SELECT 'RTF_SALES' AS MEASURE FROM DUAL UNION
                SELECT 'RTF_PACK'  AS MEASURE FROM DUAL UNION
                SELECT 'RTF_CELL'  AS MEASURE FROM DUAL UNION
                SELECT 'INV_SALES' AS MEASURE FROM DUAL UNION
                SELECT 'INV_PACK'  AS MEASURE FROM DUAL UNION
                SELECT 'INV_CELL'  AS MEASURE FROM DUAL
               ) IA
             , GT_GPWW_WW_DAYS_INFO B   /* 데이터가 없는 월 0으로 생성을 위해. */
         WHERE 1=1
         GROUP BY A.CELL_GROUP
                , A.CELL_GROUP_YN   /* 20240311 */
                , A.OPERATION_GROUP
                , NVL(A.PRODUCT_LEVEL1, '-')
                , NVL(A.PRODUCT_LEVEL2, '-')
                , IA.MEASURE
                , B.YYYYPW
                , B.YYYYPW_SEQ
                , B.PW_DAYS;


        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 주별 RTF 누적 정보');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_RTF_FOR_DIO;

        INSERT
          INTO GT_GPWW_RTF_FOR_DIO
             ( YYYYPW
             , YYYYPW_SEQ
             , PW_DAYS
             , CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , RTF_QTY
             , RTF_NEXT_1
             , RTF_NEXT_2
             , RTF_NEXT_3
             , RTF_NEXT_4
             , RTF_NEXT_5
             , RTF_NEXT_6
             , RTF_NEXT_7
             , RTF_NEXT_8
             , RTF_NEXT_9
             , RTF_NEXT_10
             , RTF_NEXT_11
             , RTF_NEXT_12
             , RTF_NEXT_13
             , RTF_NEXT_14
             , RTF_NEXT_15
             , RTF_NEXT_16
             , RTF_NEXT_17
             , RTF_NEXT_18
             , RTF_NEXT_19
             , RTF_NEXT_20
             , RTF_NEXT_21
             , RTF_NEXT_22
             , RTF_NEXT_23
             , RTF_NEXT_24
             , RTF_NEXT_25
             , RTF_NEXT_26
             , RTF_NEXT_27
             , RTF_NEXT_28
             , RTF_NEXT_29
             , RTF_NEXT_30
             , RTF_NEXT_31
             , RTF_NEXT_32
             , RTF_NEXT_33
             , RTF_NEXT_34
             , RTF_NEXT_35
             , RTF_NEXT_36
             , RTF_NEXT_37
             , RTF_NEXT_38
             , RTF_NEXT_39
             , RTF_NEXT_40
             , RTF_NEXT_41
             , RTF_NEXT_42
             , RTF_NEXT_43
             , RTF_NEXT_44
             , RTF_NEXT_45
             , RTF_NEXT_46
             , RTF_NEXT_47
             , RTF_NEXT_48
             , RTF_NEXT_49
             , RTF_NEXT_50
             , RTF_NEXT_51
             , RTF_NEXT_52
             , RTF_NEXT_53
             , RTF_NEXT_54
             , RTF_NEXT_55
             , RTF_NEXT_56
             , RTF_NEXT_57
             , RTF_NEXT_58
             , RTF_NEXT_59
             , RTF_NEXT_60
             , RTF_NEXT_61
             , RTF_NEXT_62
             , RTF_NEXT_63
             , ACC_RTF_1
             , ACC_RTF_2
             , ACC_RTF_3
             , ACC_RTF_4
             , ACC_RTF_5
             , ACC_RTF_6
             , ACC_RTF_7
             , ACC_RTF_8
             , ACC_RTF_9
             , ACC_RTF_10
             , ACC_RTF_11
             , ACC_RTF_12
             , ACC_RTF_13
             , ACC_RTF_14
             , ACC_RTF_15
             , ACC_RTF_16
             , ACC_RTF_17
             , ACC_RTF_18
             , ACC_RTF_19
             , ACC_RTF_20
             , ACC_RTF_21
             , ACC_RTF_22
             , ACC_RTF_23
             , ACC_RTF_24
             , ACC_RTF_25
             , ACC_RTF_26
             , ACC_RTF_27
             , ACC_RTF_28
             , ACC_RTF_29
             , ACC_RTF_30
             , ACC_RTF_31
             , ACC_RTF_32
             , ACC_RTF_33
             , ACC_RTF_34
             , ACC_RTF_35
             , ACC_RTF_36
             , ACC_RTF_37
             , ACC_RTF_38
             , ACC_RTF_39
             , ACC_RTF_40
             , ACC_RTF_41
             , ACC_RTF_42
             , ACC_RTF_43
             , ACC_RTF_44
             , ACC_RTF_45
             , ACC_RTF_46
             , ACC_RTF_47
             , ACC_RTF_48
             , ACC_RTF_49
             , ACC_RTF_50
             , ACC_RTF_51
             , ACC_RTF_52
             , ACC_RTF_53
             , ACC_RTF_54
             , ACC_RTF_55
             , ACC_RTF_56
             , ACC_RTF_57
             , ACC_RTF_58
             , ACC_RTF_59
             , ACC_RTF_60
             , ACC_RTF_61
             , ACC_RTF_62
             , ACC_RTF_63 )
        SELECT A.YYYYPW
             , A.YYYYPW_SEQ
             , A.PW_DAYS
             , A.CELL_GROUP
             , A.CELL_GROUP_YN   /* 20240311 */
             , A.OPERATION_GROUP
             , A.QTY             AS RTF_QTY
               /* -- RTF 음수가 존재함.. MAX에서 0이 아닌 음수값을 가져오기 위해 ELSE NULL 처리 후 최종 결과 ISNULL처리함.  */
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 1  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_1
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 2  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_2
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 3  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_3
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 4  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_4
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 5  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_5
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 6  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_6
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 7  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_7
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 8  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_8
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 9  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_9
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 10 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_10
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 11 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_11
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 12 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_12
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 13 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_13
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 14 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_14
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 15 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_15
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 16 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_16
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 17 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_17
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 18 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_18
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 19 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_19
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 20 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_20
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 21 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_21
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 22 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_22
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 23 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_23
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 24 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_24
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 25 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_25
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 26 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_26
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 27 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_27
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 28 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_28
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 29 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_29
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 30 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_30
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 31 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_31
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 32 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_32
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 33 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_33
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 34 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_34
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 35 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_35
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 36 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_36
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 37 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_37
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 38 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_38
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 39 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_39
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 40 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_40
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 41 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_41
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 42 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_42
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 43 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_43
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 44 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_44
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 45 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_45
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 46 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_46
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 47 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_47
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 48 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_48
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 49 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_49
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 50 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_50
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 51 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_51
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 52 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_52
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 53 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_53
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 54 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_54
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 55 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_55
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 56 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_56
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 57 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_57
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 58 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_58
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 59 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_59
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 60 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_60
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 61 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_61
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 62 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_62
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 63 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_63
               /* ----------------------------------------------------------------------------------------------------------- */
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 1  THEN B.QTY ELSE 0 END)  AS ACC_RTF_1
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 2  THEN B.QTY ELSE 0 END)  AS ACC_RTF_2
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 3  THEN B.QTY ELSE 0 END)  AS ACC_RTF_3
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 4  THEN B.QTY ELSE 0 END)  AS ACC_RTF_4
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 5  THEN B.QTY ELSE 0 END)  AS ACC_RTF_5
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 6  THEN B.QTY ELSE 0 END)  AS ACC_RTF_6
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 7  THEN B.QTY ELSE 0 END)  AS ACC_RTF_7
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 8  THEN B.QTY ELSE 0 END)  AS ACC_RTF_8
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 9  THEN B.QTY ELSE 0 END)  AS ACC_RTF_9
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 10 THEN B.QTY ELSE 0 END)  AS ACC_RTF_10
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 11 THEN B.QTY ELSE 0 END)  AS ACC_RTF_11
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 12 THEN B.QTY ELSE 0 END)  AS ACC_RTF_12
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 13 THEN B.QTY ELSE 0 END)  AS ACC_RTF_13
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 14 THEN B.QTY ELSE 0 END)  AS ACC_RTF_14
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 15 THEN B.QTY ELSE 0 END)  AS ACC_RTF_15
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 16 THEN B.QTY ELSE 0 END)  AS ACC_RTF_16
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 17 THEN B.QTY ELSE 0 END)  AS ACC_RTF_17
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 18 THEN B.QTY ELSE 0 END)  AS ACC_RTF_18
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 19 THEN B.QTY ELSE 0 END)  AS ACC_RTF_19
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 20 THEN B.QTY ELSE 0 END)  AS ACC_RTF_20
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 21 THEN B.QTY ELSE 0 END)  AS ACC_RTF_21
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 22 THEN B.QTY ELSE 0 END)  AS ACC_RTF_22
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 23 THEN B.QTY ELSE 0 END)  AS ACC_RTF_23
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 24 THEN B.QTY ELSE 0 END)  AS ACC_RTF_24
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 25 THEN B.QTY ELSE 0 END)  AS ACC_RTF_25
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 26 THEN B.QTY ELSE 0 END)  AS ACC_RTF_26
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 27 THEN B.QTY ELSE 0 END)  AS ACC_RTF_27
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 28 THEN B.QTY ELSE 0 END)  AS ACC_RTF_28
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 29 THEN B.QTY ELSE 0 END)  AS ACC_RTF_29
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 30 THEN B.QTY ELSE 0 END)  AS ACC_RTF_30
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 31 THEN B.QTY ELSE 0 END)  AS ACC_RTF_31
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 32 THEN B.QTY ELSE 0 END)  AS ACC_RTF_32
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 33 THEN B.QTY ELSE 0 END)  AS ACC_RTF_33
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 34 THEN B.QTY ELSE 0 END)  AS ACC_RTF_34
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 35 THEN B.QTY ELSE 0 END)  AS ACC_RTF_35
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 36 THEN B.QTY ELSE 0 END)  AS ACC_RTF_36
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 37 THEN B.QTY ELSE 0 END)  AS ACC_RTF_37
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 38 THEN B.QTY ELSE 0 END)  AS ACC_RTF_38
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 39 THEN B.QTY ELSE 0 END)  AS ACC_RTF_39
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 40 THEN B.QTY ELSE 0 END)  AS ACC_RTF_40
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 41 THEN B.QTY ELSE 0 END)  AS ACC_RTF_41
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 42 THEN B.QTY ELSE 0 END)  AS ACC_RTF_42
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 43 THEN B.QTY ELSE 0 END)  AS ACC_RTF_43
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 44 THEN B.QTY ELSE 0 END)  AS ACC_RTF_44
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 45 THEN B.QTY ELSE 0 END)  AS ACC_RTF_45
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 46 THEN B.QTY ELSE 0 END)  AS ACC_RTF_46
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 47 THEN B.QTY ELSE 0 END)  AS ACC_RTF_47
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 48 THEN B.QTY ELSE 0 END)  AS ACC_RTF_48
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 49 THEN B.QTY ELSE 0 END)  AS ACC_RTF_49
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 50 THEN B.QTY ELSE 0 END)  AS ACC_RTF_50
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 51 THEN B.QTY ELSE 0 END)  AS ACC_RTF_51
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 52 THEN B.QTY ELSE 0 END)  AS ACC_RTF_52
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 53 THEN B.QTY ELSE 0 END)  AS ACC_RTF_53
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 54 THEN B.QTY ELSE 0 END)  AS ACC_RTF_54
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 55 THEN B.QTY ELSE 0 END)  AS ACC_RTF_55
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 56 THEN B.QTY ELSE 0 END)  AS ACC_RTF_56
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 57 THEN B.QTY ELSE 0 END)  AS ACC_RTF_57
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 58 THEN B.QTY ELSE 0 END)  AS ACC_RTF_58
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 59 THEN B.QTY ELSE 0 END)  AS ACC_RTF_59
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 60 THEN B.QTY ELSE 0 END)  AS ACC_RTF_60
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 61 THEN B.QTY ELSE 0 END)  AS ACC_RTF_61
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 62 THEN B.QTY ELSE 0 END)  AS ACC_RTF_62
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 63 THEN B.QTY ELSE 0 END)  AS ACC_RTF_63
          FROM GT_GPWW_BASE_DATA_FOR_DIO A
             , GT_GPWW_BASE_DATA_FOR_DIO B
         WHERE 1=1
           AND B.MEASURE(+)         = 'RTF'
           AND B.CELL_GROUP(+)      = A.CELL_GROUP
           AND B.OPERATION_GROUP(+) = A.OPERATION_GROUP
           AND B.YYYYPW_SEQ(+) BETWEEN A.YYYYPW_SEQ + 1
                                   AND A.YYYYPW_SEQ + 64
           AND A.MEASURE            = 'RTF'
         GROUP BY A.YYYYPW
                , A.YYYYPW_SEQ
                , A.PW_DAYS
                , A.CELL_GROUP
                , A.CELL_GROUP_YN   /* 20240311 */
                , A.OPERATION_GROUP
                , A.QTY;


        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 주별 RTF 누적 정보(표준레포트)'); /* @@@ */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_RTF_FOR_DIO_CELLGROUP;

        INSERT
          INTO GT_GPWW_RTF_FOR_DIO_CELLGROUP
             ( YYYYPW
             , YYYYPW_SEQ
             , PW_DAYS
             , CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , MEASURE
             , RTF_QTY
             , RTF_NEXT_1
             , RTF_NEXT_2
             , RTF_NEXT_3
             , RTF_NEXT_4
             , RTF_NEXT_5
             , RTF_NEXT_6
             , RTF_NEXT_7
             , RTF_NEXT_8
             , RTF_NEXT_9
             , RTF_NEXT_10
             , RTF_NEXT_11
             , RTF_NEXT_12
             , RTF_NEXT_13
             , RTF_NEXT_14
             , RTF_NEXT_15
             , RTF_NEXT_16
             , RTF_NEXT_17
             , RTF_NEXT_18
             , RTF_NEXT_19
             , RTF_NEXT_20
             , RTF_NEXT_21
             , RTF_NEXT_22
             , RTF_NEXT_23
             , RTF_NEXT_24
             , RTF_NEXT_25
             , RTF_NEXT_26
             , RTF_NEXT_27
             , RTF_NEXT_28
             , RTF_NEXT_29
             , RTF_NEXT_30
             , RTF_NEXT_31
             , RTF_NEXT_32
             , RTF_NEXT_33
             , RTF_NEXT_34
             , RTF_NEXT_35
             , RTF_NEXT_36
             , RTF_NEXT_37
             , RTF_NEXT_38
             , RTF_NEXT_39
             , RTF_NEXT_40
             , RTF_NEXT_41
             , RTF_NEXT_42
             , RTF_NEXT_43
             , RTF_NEXT_44
             , RTF_NEXT_45
             , RTF_NEXT_46
             , RTF_NEXT_47
             , RTF_NEXT_48
             , RTF_NEXT_49
             , RTF_NEXT_50
             , RTF_NEXT_51
             , RTF_NEXT_52
             , RTF_NEXT_53
             , RTF_NEXT_54
             , RTF_NEXT_55
             , RTF_NEXT_56
             , RTF_NEXT_57
             , RTF_NEXT_58
             , RTF_NEXT_59
             , RTF_NEXT_60
             , RTF_NEXT_61
             , RTF_NEXT_62
             , RTF_NEXT_63
             , ACC_RTF_1
             , ACC_RTF_2
             , ACC_RTF_3
             , ACC_RTF_4
             , ACC_RTF_5
             , ACC_RTF_6
             , ACC_RTF_7
             , ACC_RTF_8
             , ACC_RTF_9
             , ACC_RTF_10
             , ACC_RTF_11
             , ACC_RTF_12
             , ACC_RTF_13
             , ACC_RTF_14
             , ACC_RTF_15
             , ACC_RTF_16
             , ACC_RTF_17
             , ACC_RTF_18
             , ACC_RTF_19
             , ACC_RTF_20
             , ACC_RTF_21
             , ACC_RTF_22
             , ACC_RTF_23
             , ACC_RTF_24
             , ACC_RTF_25
             , ACC_RTF_26
             , ACC_RTF_27
             , ACC_RTF_28
             , ACC_RTF_29
             , ACC_RTF_30
             , ACC_RTF_31
             , ACC_RTF_32
             , ACC_RTF_33
             , ACC_RTF_34
             , ACC_RTF_35
             , ACC_RTF_36
             , ACC_RTF_37
             , ACC_RTF_38
             , ACC_RTF_39
             , ACC_RTF_40
             , ACC_RTF_41
             , ACC_RTF_42
             , ACC_RTF_43
             , ACC_RTF_44
             , ACC_RTF_45
             , ACC_RTF_46
             , ACC_RTF_47
             , ACC_RTF_48
             , ACC_RTF_49
             , ACC_RTF_50
             , ACC_RTF_51
             , ACC_RTF_52
             , ACC_RTF_53
             , ACC_RTF_54
             , ACC_RTF_55
             , ACC_RTF_56
             , ACC_RTF_57
             , ACC_RTF_58
             , ACC_RTF_59
             , ACC_RTF_60
             , ACC_RTF_61
             , ACC_RTF_62
             , ACC_RTF_63 )
        SELECT A.YYYYPW
             , A.YYYYPW_SEQ
             , A.PW_DAYS
             , A.CELL_GROUP
             , A.CELL_GROUP_YN   /* 20240311 */
             , A.OPERATION_GROUP
             , A.MEASURE
             , A.QTY             AS RTF_QTY
               /* -- RTF 음수가 존재함.. MAX에서 0이 아닌 음수값을 가져오기 위해 ELSE NULL 처리 후 최종 결과 ISNULL처리함.  */
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 1  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_1
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 2  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_2
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 3  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_3
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 4  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_4
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 5  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_5
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 6  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_6
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 7  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_7
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 8  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_8
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 9  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_9
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 10 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_10
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 11 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_11
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 12 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_12
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 13 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_13
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 14 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_14
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 15 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_15
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 16 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_16
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 17 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_17
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 18 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_18
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 19 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_19
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 20 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_20
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 21 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_21
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 22 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_22
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 23 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_23
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 24 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_24
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 25 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_25
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 26 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_26
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 27 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_27
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 28 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_28
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 29 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_29
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 30 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_30
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 31 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_31
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 32 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_32
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 33 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_33
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 34 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_34
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 35 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_35
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 36 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_36
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 37 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_37
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 38 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_38
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 39 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_39
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 40 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_40
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 41 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_41
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 42 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_42
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 43 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_43
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 44 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_44
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 45 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_45
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 46 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_46
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 47 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_47
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 48 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_48
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 49 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_49
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 50 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_50
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 51 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_51
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 52 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_52
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 53 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_53
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 54 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_54
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 55 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_55
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 56 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_56
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 57 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_57
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 58 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_58
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 59 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_59
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 60 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_60
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 61 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_61
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 62 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_62
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 63 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_63
               /* ----------------------------------------------------------------------------------------------------------- */
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 1  THEN B.QTY ELSE 0 END)  AS ACC_RTF_1
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 2  THEN B.QTY ELSE 0 END)  AS ACC_RTF_2
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 3  THEN B.QTY ELSE 0 END)  AS ACC_RTF_3
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 4  THEN B.QTY ELSE 0 END)  AS ACC_RTF_4
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 5  THEN B.QTY ELSE 0 END)  AS ACC_RTF_5
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 6  THEN B.QTY ELSE 0 END)  AS ACC_RTF_6
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 7  THEN B.QTY ELSE 0 END)  AS ACC_RTF_7
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 8  THEN B.QTY ELSE 0 END)  AS ACC_RTF_8
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 9  THEN B.QTY ELSE 0 END)  AS ACC_RTF_9
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 10 THEN B.QTY ELSE 0 END)  AS ACC_RTF_10
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 11 THEN B.QTY ELSE 0 END)  AS ACC_RTF_11
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 12 THEN B.QTY ELSE 0 END)  AS ACC_RTF_12
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 13 THEN B.QTY ELSE 0 END)  AS ACC_RTF_13
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 14 THEN B.QTY ELSE 0 END)  AS ACC_RTF_14
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 15 THEN B.QTY ELSE 0 END)  AS ACC_RTF_15
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 16 THEN B.QTY ELSE 0 END)  AS ACC_RTF_16
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 17 THEN B.QTY ELSE 0 END)  AS ACC_RTF_17
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 18 THEN B.QTY ELSE 0 END)  AS ACC_RTF_18
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 19 THEN B.QTY ELSE 0 END)  AS ACC_RTF_19
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 20 THEN B.QTY ELSE 0 END)  AS ACC_RTF_20
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 21 THEN B.QTY ELSE 0 END)  AS ACC_RTF_21
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 22 THEN B.QTY ELSE 0 END)  AS ACC_RTF_22
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 23 THEN B.QTY ELSE 0 END)  AS ACC_RTF_23
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 24 THEN B.QTY ELSE 0 END)  AS ACC_RTF_24
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 25 THEN B.QTY ELSE 0 END)  AS ACC_RTF_25
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 26 THEN B.QTY ELSE 0 END)  AS ACC_RTF_26
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 27 THEN B.QTY ELSE 0 END)  AS ACC_RTF_27
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 28 THEN B.QTY ELSE 0 END)  AS ACC_RTF_28
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 29 THEN B.QTY ELSE 0 END)  AS ACC_RTF_29
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 30 THEN B.QTY ELSE 0 END)  AS ACC_RTF_30
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 31 THEN B.QTY ELSE 0 END)  AS ACC_RTF_31
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 32 THEN B.QTY ELSE 0 END)  AS ACC_RTF_32
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 33 THEN B.QTY ELSE 0 END)  AS ACC_RTF_33
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 34 THEN B.QTY ELSE 0 END)  AS ACC_RTF_34
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 35 THEN B.QTY ELSE 0 END)  AS ACC_RTF_35
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 36 THEN B.QTY ELSE 0 END)  AS ACC_RTF_36
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 37 THEN B.QTY ELSE 0 END)  AS ACC_RTF_37
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 38 THEN B.QTY ELSE 0 END)  AS ACC_RTF_38
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 39 THEN B.QTY ELSE 0 END)  AS ACC_RTF_39
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 40 THEN B.QTY ELSE 0 END)  AS ACC_RTF_40
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 41 THEN B.QTY ELSE 0 END)  AS ACC_RTF_41
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 42 THEN B.QTY ELSE 0 END)  AS ACC_RTF_42
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 43 THEN B.QTY ELSE 0 END)  AS ACC_RTF_43
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 44 THEN B.QTY ELSE 0 END)  AS ACC_RTF_44
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 45 THEN B.QTY ELSE 0 END)  AS ACC_RTF_45
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 46 THEN B.QTY ELSE 0 END)  AS ACC_RTF_46
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 47 THEN B.QTY ELSE 0 END)  AS ACC_RTF_47
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 48 THEN B.QTY ELSE 0 END)  AS ACC_RTF_48
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 49 THEN B.QTY ELSE 0 END)  AS ACC_RTF_49
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 50 THEN B.QTY ELSE 0 END)  AS ACC_RTF_50
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 51 THEN B.QTY ELSE 0 END)  AS ACC_RTF_51
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 52 THEN B.QTY ELSE 0 END)  AS ACC_RTF_52
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 53 THEN B.QTY ELSE 0 END)  AS ACC_RTF_53
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 54 THEN B.QTY ELSE 0 END)  AS ACC_RTF_54
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 55 THEN B.QTY ELSE 0 END)  AS ACC_RTF_55
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 56 THEN B.QTY ELSE 0 END)  AS ACC_RTF_56
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 57 THEN B.QTY ELSE 0 END)  AS ACC_RTF_57
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 58 THEN B.QTY ELSE 0 END)  AS ACC_RTF_58
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 59 THEN B.QTY ELSE 0 END)  AS ACC_RTF_59
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 60 THEN B.QTY ELSE 0 END)  AS ACC_RTF_60
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 61 THEN B.QTY ELSE 0 END)  AS ACC_RTF_61
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 62 THEN B.QTY ELSE 0 END)  AS ACC_RTF_62
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 63 THEN B.QTY ELSE 0 END)  AS ACC_RTF_63
          FROM GT_GPWW_BASE_DATA_FOR_DIO_CELLGROUP A
             , GT_GPWW_BASE_DATA_FOR_DIO_CELLGROUP B
         WHERE 1=1
           AND B.MEASURE(+)      LIKE 'RTF%'
           AND B.CELL_GROUP(+)      = A.CELL_GROUP
           AND B.OPERATION_GROUP(+) = A.OPERATION_GROUP
           AND B.MEASURE(+)         = A.MEASURE
           AND B.YYYYPW_SEQ(+) BETWEEN A.YYYYPW_SEQ + 1
                                   AND A.YYYYPW_SEQ + 64
           AND A.MEASURE         LIKE 'RTF%'
         GROUP BY A.YYYYPW
                , A.YYYYPW_SEQ
                , A.PW_DAYS
                , A.CELL_GROUP
                , A.CELL_GROUP_YN   /* 20240311 */
                , A.OPERATION_GROUP
                , A.MEASURE
                , A.QTY;


        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 주별 RTF 누적 정보(Detail 표준레포트)'); /* @@@ */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_RTF_FOR_DIO_DETAILREPORT;

        INSERT
          INTO GT_GPWW_RTF_FOR_DIO_DETAILREPORT
             ( YYYYPW
             , YYYYPW_SEQ
             , PW_DAYS
             , CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , PRODUCT_LEVEL1
             , PRODUCT_LEVEL2
             , MEASURE
             , RTF_QTY
             , RTF_NEXT_1
             , RTF_NEXT_2
             , RTF_NEXT_3
             , RTF_NEXT_4
             , RTF_NEXT_5
             , RTF_NEXT_6
             , RTF_NEXT_7
             , RTF_NEXT_8
             , RTF_NEXT_9
             , RTF_NEXT_10
             , RTF_NEXT_11
             , RTF_NEXT_12
             , RTF_NEXT_13
             , RTF_NEXT_14
             , RTF_NEXT_15
             , RTF_NEXT_16
             , RTF_NEXT_17
             , RTF_NEXT_18
             , RTF_NEXT_19
             , RTF_NEXT_20
             , RTF_NEXT_21
             , RTF_NEXT_22
             , RTF_NEXT_23
             , RTF_NEXT_24
             , RTF_NEXT_25
             , RTF_NEXT_26
             , RTF_NEXT_27
             , RTF_NEXT_28
             , RTF_NEXT_29
             , RTF_NEXT_30
             , RTF_NEXT_31
             , RTF_NEXT_32
             , RTF_NEXT_33
             , RTF_NEXT_34
             , RTF_NEXT_35
             , RTF_NEXT_36
             , RTF_NEXT_37
             , RTF_NEXT_38
             , RTF_NEXT_39
             , RTF_NEXT_40
             , RTF_NEXT_41
             , RTF_NEXT_42
             , RTF_NEXT_43
             , RTF_NEXT_44
             , RTF_NEXT_45
             , RTF_NEXT_46
             , RTF_NEXT_47
             , RTF_NEXT_48
             , RTF_NEXT_49
             , RTF_NEXT_50
             , RTF_NEXT_51
             , RTF_NEXT_52
             , RTF_NEXT_53
             , RTF_NEXT_54
             , RTF_NEXT_55
             , RTF_NEXT_56
             , RTF_NEXT_57
             , RTF_NEXT_58
             , RTF_NEXT_59
             , RTF_NEXT_60
             , RTF_NEXT_61
             , RTF_NEXT_62
             , RTF_NEXT_63
             , ACC_RTF_1
             , ACC_RTF_2
             , ACC_RTF_3
             , ACC_RTF_4
             , ACC_RTF_5
             , ACC_RTF_6
             , ACC_RTF_7
             , ACC_RTF_8
             , ACC_RTF_9
             , ACC_RTF_10
             , ACC_RTF_11
             , ACC_RTF_12
             , ACC_RTF_13
             , ACC_RTF_14
             , ACC_RTF_15
             , ACC_RTF_16
             , ACC_RTF_17
             , ACC_RTF_18
             , ACC_RTF_19
             , ACC_RTF_20
             , ACC_RTF_21
             , ACC_RTF_22
             , ACC_RTF_23
             , ACC_RTF_24
             , ACC_RTF_25
             , ACC_RTF_26
             , ACC_RTF_27
             , ACC_RTF_28
             , ACC_RTF_29
             , ACC_RTF_30
             , ACC_RTF_31
             , ACC_RTF_32
             , ACC_RTF_33
             , ACC_RTF_34
             , ACC_RTF_35
             , ACC_RTF_36
             , ACC_RTF_37
             , ACC_RTF_38
             , ACC_RTF_39
             , ACC_RTF_40
             , ACC_RTF_41
             , ACC_RTF_42
             , ACC_RTF_43
             , ACC_RTF_44
             , ACC_RTF_45
             , ACC_RTF_46
             , ACC_RTF_47
             , ACC_RTF_48
             , ACC_RTF_49
             , ACC_RTF_50
             , ACC_RTF_51
             , ACC_RTF_52
             , ACC_RTF_53
             , ACC_RTF_54
             , ACC_RTF_55
             , ACC_RTF_56
             , ACC_RTF_57
             , ACC_RTF_58
             , ACC_RTF_59
             , ACC_RTF_60
             , ACC_RTF_61
             , ACC_RTF_62
             , ACC_RTF_63 )
        SELECT A.YYYYPW
             , A.YYYYPW_SEQ
             , A.PW_DAYS
             , A.CELL_GROUP
             , A.CELL_GROUP_YN   /* 20240311 */
             , A.OPERATION_GROUP
             , NVL(A.PRODUCT_LEVEL1, '-') AS PRODUCT_LEVEL1
             , NVL(A.PRODUCT_LEVEL2, '-') AS PRODUCT_LEVEL2
             , A.MEASURE
             , A.QTY             AS RTF_QTY
               /* -- RTF 음수가 존재함.. MAX에서 0이 아닌 음수값을 가져오기 위해 ELSE NULL 처리 후 최종 결과 ISNULL처리함.  */
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 1  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_1
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 2  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_2
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 3  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_3
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 4  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_4
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 5  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_5
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 6  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_6
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 7  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_7
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 8  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_8
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 9  THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_9
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 10 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_10
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 11 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_11
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 12 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_12
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 13 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_13
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 14 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_14
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 15 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_15
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 16 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_16
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 17 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_17
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 18 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_18
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 19 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_19
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 20 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_20
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 21 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_21
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 22 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_22
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 23 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_23
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 24 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_24
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 25 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_25
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 26 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_26
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 27 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_27
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 28 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_28
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 29 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_29
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 30 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_30
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 31 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_31
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 32 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_32
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 33 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_33
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 34 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_34
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 35 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_35
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 36 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_36
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 37 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_37
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 38 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_38
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 39 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_39
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 40 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_40
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 41 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_41
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 42 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_42
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 43 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_43
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 44 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_44
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 45 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_45
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 46 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_46
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 47 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_47
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 48 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_48
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 49 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_49
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 50 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_50
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 51 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_51
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 52 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_52
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 53 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_53
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 54 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_54
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 55 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_55
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 56 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_56
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 57 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_57
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 58 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_58
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 59 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_59
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 60 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_60
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 61 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_61
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 62 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_62
             , NVL(MAX(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ = 63 THEN B.QTY ELSE NULL END), 0)  AS RTF_NEXT_63
               /* ----------------------------------------------------------------------------------------------------------- */
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 1  THEN B.QTY ELSE 0 END)  AS ACC_RTF_1
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 2  THEN B.QTY ELSE 0 END)  AS ACC_RTF_2
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 3  THEN B.QTY ELSE 0 END)  AS ACC_RTF_3
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 4  THEN B.QTY ELSE 0 END)  AS ACC_RTF_4
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 5  THEN B.QTY ELSE 0 END)  AS ACC_RTF_5
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 6  THEN B.QTY ELSE 0 END)  AS ACC_RTF_6
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 7  THEN B.QTY ELSE 0 END)  AS ACC_RTF_7
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 8  THEN B.QTY ELSE 0 END)  AS ACC_RTF_8
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 9  THEN B.QTY ELSE 0 END)  AS ACC_RTF_9
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 10 THEN B.QTY ELSE 0 END)  AS ACC_RTF_10
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 11 THEN B.QTY ELSE 0 END)  AS ACC_RTF_11
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 12 THEN B.QTY ELSE 0 END)  AS ACC_RTF_12
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 13 THEN B.QTY ELSE 0 END)  AS ACC_RTF_13
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 14 THEN B.QTY ELSE 0 END)  AS ACC_RTF_14
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 15 THEN B.QTY ELSE 0 END)  AS ACC_RTF_15
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 16 THEN B.QTY ELSE 0 END)  AS ACC_RTF_16
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 17 THEN B.QTY ELSE 0 END)  AS ACC_RTF_17
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 18 THEN B.QTY ELSE 0 END)  AS ACC_RTF_18
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 19 THEN B.QTY ELSE 0 END)  AS ACC_RTF_19
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 20 THEN B.QTY ELSE 0 END)  AS ACC_RTF_20
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 21 THEN B.QTY ELSE 0 END)  AS ACC_RTF_21
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 22 THEN B.QTY ELSE 0 END)  AS ACC_RTF_22
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 23 THEN B.QTY ELSE 0 END)  AS ACC_RTF_23
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 24 THEN B.QTY ELSE 0 END)  AS ACC_RTF_24
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 25 THEN B.QTY ELSE 0 END)  AS ACC_RTF_25
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 26 THEN B.QTY ELSE 0 END)  AS ACC_RTF_26
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 27 THEN B.QTY ELSE 0 END)  AS ACC_RTF_27
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 28 THEN B.QTY ELSE 0 END)  AS ACC_RTF_28
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 29 THEN B.QTY ELSE 0 END)  AS ACC_RTF_29
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 30 THEN B.QTY ELSE 0 END)  AS ACC_RTF_30
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 31 THEN B.QTY ELSE 0 END)  AS ACC_RTF_31
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 32 THEN B.QTY ELSE 0 END)  AS ACC_RTF_32
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 33 THEN B.QTY ELSE 0 END)  AS ACC_RTF_33
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 34 THEN B.QTY ELSE 0 END)  AS ACC_RTF_34
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 35 THEN B.QTY ELSE 0 END)  AS ACC_RTF_35
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 36 THEN B.QTY ELSE 0 END)  AS ACC_RTF_36
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 37 THEN B.QTY ELSE 0 END)  AS ACC_RTF_37
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 38 THEN B.QTY ELSE 0 END)  AS ACC_RTF_38
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 39 THEN B.QTY ELSE 0 END)  AS ACC_RTF_39
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 40 THEN B.QTY ELSE 0 END)  AS ACC_RTF_40
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 41 THEN B.QTY ELSE 0 END)  AS ACC_RTF_41
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 42 THEN B.QTY ELSE 0 END)  AS ACC_RTF_42
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 43 THEN B.QTY ELSE 0 END)  AS ACC_RTF_43
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 44 THEN B.QTY ELSE 0 END)  AS ACC_RTF_44
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 45 THEN B.QTY ELSE 0 END)  AS ACC_RTF_45
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 46 THEN B.QTY ELSE 0 END)  AS ACC_RTF_46
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 47 THEN B.QTY ELSE 0 END)  AS ACC_RTF_47
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 48 THEN B.QTY ELSE 0 END)  AS ACC_RTF_48
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 49 THEN B.QTY ELSE 0 END)  AS ACC_RTF_49
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 50 THEN B.QTY ELSE 0 END)  AS ACC_RTF_50
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 51 THEN B.QTY ELSE 0 END)  AS ACC_RTF_51
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 52 THEN B.QTY ELSE 0 END)  AS ACC_RTF_52
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 53 THEN B.QTY ELSE 0 END)  AS ACC_RTF_53
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 54 THEN B.QTY ELSE 0 END)  AS ACC_RTF_54
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 55 THEN B.QTY ELSE 0 END)  AS ACC_RTF_55
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 56 THEN B.QTY ELSE 0 END)  AS ACC_RTF_56
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 57 THEN B.QTY ELSE 0 END)  AS ACC_RTF_57
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 58 THEN B.QTY ELSE 0 END)  AS ACC_RTF_58
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 59 THEN B.QTY ELSE 0 END)  AS ACC_RTF_59
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 60 THEN B.QTY ELSE 0 END)  AS ACC_RTF_60
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 61 THEN B.QTY ELSE 0 END)  AS ACC_RTF_61
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 62 THEN B.QTY ELSE 0 END)  AS ACC_RTF_62
             , SUM(CASE WHEN B.YYYYPW_SEQ - A.YYYYPW_SEQ BETWEEN 1 AND 63 THEN B.QTY ELSE 0 END)  AS ACC_RTF_63
          FROM GT_GPWW_BASE_DATA_FOR_DIO_DETAILREPORT A
             , GT_GPWW_BASE_DATA_FOR_DIO_DETAILREPORT B
         WHERE 1=1
           AND B.MEASURE(+)      LIKE 'RTF%'
           AND B.CELL_GROUP(+)      = A.CELL_GROUP
           AND B.OPERATION_GROUP(+) = A.OPERATION_GROUP
           AND B.PRODUCT_LEVEL1(+)  = A.PRODUCT_LEVEL1
           AND B.PRODUCT_LEVEL2(+)  = A.PRODUCT_LEVEL2
           AND B.MEASURE(+)         = A.MEASURE
           AND B.YYYYPW_SEQ(+) BETWEEN A.YYYYPW_SEQ + 1
                                   AND A.YYYYPW_SEQ + 64
           AND A.MEASURE         LIKE 'RTF%'
         GROUP BY A.YYYYPW
                , A.YYYYPW_SEQ
                , A.PW_DAYS
                , A.CELL_GROUP
                , A.CELL_GROUP_YN   /* 20240311 */
                , A.OPERATION_GROUP
                , NVL(A.PRODUCT_LEVEL1, '-')
                , NVL(A.PRODUCT_LEVEL2, '-')
                , A.MEASURE
                , A.QTY;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 셀그룹별 DIO 산출');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_INVENTORY_DIO;

        INSERT
          INTO GT_GPWW_INVENTORY_DIO
             ( YYYYPW
             , YYYYPW_SEQ
             , PW_DAYS
             , CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , INV_QTY
             , RTF_QTY
             , DIO )
        SELECT A.YYYYPW
             , A.YYYYPW_SEQ
             , A.PW_DAYS
             , A.CELL_GROUP
             , A.CELL_GROUP_YN        /* 20240311 */
             , A.OPERATION_GROUP
             , A.QTY                  AS INV_QTY
             , C.RTF_QTY              AS RTF_QTY
             , CASE WHEN A.QTY <= 0 THEN
                    0
                    WHEN C.CELL_GROUP IS NULL THEN
                    365
                    WHEN A.QTY - C.RTF_NEXT_1 < 0 THEN
                    NVL(CAST(A.QTY AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_1 = 0 THEN NULL ELSE C.RTF_NEXT_1 END, 0) * B.DAYS_NEXT_1
                    WHEN A.QTY - C.RTF_NEXT_1 = 0 THEN
                    B.ACC_DAYS_1
                    WHEN A.QTY - C.ACC_RTF_2 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_1) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_2 = 0 THEN NULL ELSE C.RTF_NEXT_2 END, 0) * B.DAYS_NEXT_2 + B.ACC_DAYS_1
                    WHEN A.QTY - C.ACC_RTF_2 = 0 THEN
                    B.ACC_DAYS_2
                    WHEN A.QTY - C.ACC_RTF_3 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_2) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_3 = 0 THEN NULL ELSE C.RTF_NEXT_3 END, 0) * B.DAYS_NEXT_3 + B.ACC_DAYS_2
                    WHEN A.QTY - C.ACC_RTF_3 = 0 THEN
                    B.ACC_DAYS_3
                    WHEN A.QTY - C.ACC_RTF_4 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_3) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_4 = 0 THEN NULL ELSE C.RTF_NEXT_4 END, 0) * B.DAYS_NEXT_4 + B.ACC_DAYS_3
                    WHEN A.QTY - C.ACC_RTF_4 = 0 THEN
                    B.ACC_DAYS_4
                    WHEN A.QTY - C.ACC_RTF_5 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_4) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_5 = 0 THEN NULL ELSE C.RTF_NEXT_5 END, 0) * B.DAYS_NEXT_5 + B.ACC_DAYS_4
                    WHEN A.QTY - C.ACC_RTF_5 = 0 THEN
                    B.ACC_DAYS_5
                    WHEN A.QTY - C.ACC_RTF_6 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_5) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_6 = 0 THEN NULL ELSE C.RTF_NEXT_6 END, 0) * B.DAYS_NEXT_6 + B.ACC_DAYS_5
                    WHEN A.QTY - C.ACC_RTF_6 = 0 THEN
                    B.ACC_DAYS_6
                    WHEN A.QTY - C.ACC_RTF_7 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_6) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_7 = 0 THEN NULL ELSE C.RTF_NEXT_7 END, 0) * B.DAYS_NEXT_7 + B.ACC_DAYS_6
                    WHEN A.QTY - C.ACC_RTF_7 = 0 THEN
                    B.ACC_DAYS_7
                    WHEN A.QTY - C.ACC_RTF_8 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_7) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_8 = 0 THEN NULL ELSE C.RTF_NEXT_8 END, 0) * B.DAYS_NEXT_8 + B.ACC_DAYS_7
                    WHEN A.QTY - C.ACC_RTF_8 = 0 THEN
                    B.ACC_DAYS_8
                    WHEN A.QTY - C.ACC_RTF_9 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_8) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_9 = 0 THEN NULL ELSE C.RTF_NEXT_9 END, 0) * B.DAYS_NEXT_9 + B.ACC_DAYS_8
                    WHEN A.QTY - C.ACC_RTF_9 = 0 THEN
                    B.ACC_DAYS_9
                    WHEN A.QTY - C.ACC_RTF_10 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_9) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_10 = 0 THEN NULL ELSE C.RTF_NEXT_10 END, 0) * B.DAYS_NEXT_10 + B.ACC_DAYS_9
                    WHEN A.QTY - C.ACC_RTF_10 = 0 THEN
                    B.ACC_DAYS_10
                    WHEN A.QTY - C.ACC_RTF_11 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_10) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_11 = 0 THEN NULL ELSE C.RTF_NEXT_11 END, 0) * B.DAYS_NEXT_11 + B.ACC_DAYS_10
                    WHEN A.QTY - C.ACC_RTF_11 = 0 THEN
                    B.ACC_DAYS_11
                    WHEN A.QTY - C.ACC_RTF_12 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_11) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_12 = 0 THEN NULL ELSE C.RTF_NEXT_12 END, 0) * B.DAYS_NEXT_12 + B.ACC_DAYS_11
                    WHEN A.QTY - C.ACC_RTF_12 = 0 THEN
                    B.ACC_DAYS_12
                    WHEN A.QTY - C.ACC_RTF_13 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_12) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_13 = 0 THEN NULL ELSE C.RTF_NEXT_13 END, 0) * B.DAYS_NEXT_13 + B.ACC_DAYS_12
                    WHEN A.QTY - C.ACC_RTF_13 = 0 THEN
                    B.ACC_DAYS_13
                    WHEN A.QTY - C.ACC_RTF_14 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_13) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_14 = 0 THEN NULL ELSE C.RTF_NEXT_14 END, 0) * B.DAYS_NEXT_14 + B.ACC_DAYS_13
                    WHEN A.QTY - C.ACC_RTF_14 = 0 THEN
                    B.ACC_DAYS_14
                    WHEN A.QTY - C.ACC_RTF_15 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_14) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_15 = 0 THEN NULL ELSE C.RTF_NEXT_15 END, 0) * B.DAYS_NEXT_15 + B.ACC_DAYS_14
                    WHEN A.QTY - C.ACC_RTF_15 = 0 THEN
                    B.ACC_DAYS_15
                    WHEN A.QTY - C.ACC_RTF_16 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_15) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_16 = 0 THEN NULL ELSE C.RTF_NEXT_16 END, 0) * B.DAYS_NEXT_16 + B.ACC_DAYS_15
                    WHEN A.QTY - C.ACC_RTF_16 = 0 THEN
                    B.ACC_DAYS_16
                    WHEN A.QTY - C.ACC_RTF_17 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_16) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_17 = 0 THEN NULL ELSE C.RTF_NEXT_17 END, 0) * B.DAYS_NEXT_17 + B.ACC_DAYS_16
                    WHEN A.QTY - C.ACC_RTF_17 = 0 THEN
                    B.ACC_DAYS_17
                    WHEN A.QTY - C.ACC_RTF_18 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_17) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_18 = 0 THEN NULL ELSE C.RTF_NEXT_18 END, 0) * B.DAYS_NEXT_18 + B.ACC_DAYS_17
                    WHEN A.QTY - C.ACC_RTF_18 = 0 THEN
                    B.ACC_DAYS_18
                    WHEN A.QTY - C.ACC_RTF_19 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_18) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_19 = 0 THEN NULL ELSE C.RTF_NEXT_19 END, 0) * B.DAYS_NEXT_19 + B.ACC_DAYS_18
                    WHEN A.QTY - C.ACC_RTF_19 = 0 THEN
                    B.ACC_DAYS_19
                    WHEN A.QTY - C.ACC_RTF_20 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_19) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_20 = 0 THEN NULL ELSE C.RTF_NEXT_20 END, 0) * B.DAYS_NEXT_20 + B.ACC_DAYS_19
                    WHEN A.QTY - C.ACC_RTF_20 = 0 THEN
                    B.ACC_DAYS_20
                    WHEN A.QTY - C.ACC_RTF_21 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_20) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_21 = 0 THEN NULL ELSE C.RTF_NEXT_21 END, 0) * B.DAYS_NEXT_21 + B.ACC_DAYS_20
                    WHEN A.QTY - C.ACC_RTF_21 = 0 THEN
                    B.ACC_DAYS_21
                    WHEN A.QTY - C.ACC_RTF_22 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_21) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_22 = 0 THEN NULL ELSE C.RTF_NEXT_22 END, 0) * B.DAYS_NEXT_22 + B.ACC_DAYS_21
                    WHEN A.QTY - C.ACC_RTF_22 = 0 THEN
                    B.ACC_DAYS_22
                    WHEN A.QTY - C.ACC_RTF_23 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_22) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_23 = 0 THEN NULL ELSE C.RTF_NEXT_23 END, 0) * B.DAYS_NEXT_23 + B.ACC_DAYS_22
                    WHEN A.QTY - C.ACC_RTF_23 = 0 THEN
                    B.ACC_DAYS_23
                    WHEN A.QTY - C.ACC_RTF_24 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_23) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_24 = 0 THEN NULL ELSE C.RTF_NEXT_24 END, 0) * B.DAYS_NEXT_24 + B.ACC_DAYS_23
                    WHEN A.QTY - C.ACC_RTF_24 = 0 THEN
                    B.ACC_DAYS_24
                    WHEN A.QTY - C.ACC_RTF_25 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_24) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_25 = 0 THEN NULL ELSE C.RTF_NEXT_25 END, 0) * B.DAYS_NEXT_25 + B.ACC_DAYS_24
                    WHEN A.QTY - C.ACC_RTF_25 = 0 THEN
                    B.ACC_DAYS_25
                    WHEN A.QTY - C.ACC_RTF_26 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_25) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_26 = 0 THEN NULL ELSE C.RTF_NEXT_26 END, 0) * B.DAYS_NEXT_26 + B.ACC_DAYS_25
                    WHEN A.QTY - C.ACC_RTF_26 = 0 THEN
                    B.ACC_DAYS_26
                    WHEN A.QTY - C.ACC_RTF_27 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_26) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_27 = 0 THEN NULL ELSE C.RTF_NEXT_27 END, 0) * B.DAYS_NEXT_27 + B.ACC_DAYS_26
                    WHEN A.QTY - C.ACC_RTF_27 = 0 THEN
                    B.ACC_DAYS_27
                    WHEN A.QTY - C.ACC_RTF_28 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_27) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_28 = 0 THEN NULL ELSE C.RTF_NEXT_28 END, 0) * B.DAYS_NEXT_28 + B.ACC_DAYS_27
                    WHEN A.QTY - C.ACC_RTF_28 = 0 THEN
                    B.ACC_DAYS_28
                    WHEN A.QTY - C.ACC_RTF_29 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_28) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_29 = 0 THEN NULL ELSE C.RTF_NEXT_29 END, 0) * B.DAYS_NEXT_29 + B.ACC_DAYS_28
                    WHEN A.QTY - C.ACC_RTF_29 = 0 THEN
                    B.ACC_DAYS_29
                    WHEN A.QTY - C.ACC_RTF_30 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_29) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_30 = 0 THEN NULL ELSE C.RTF_NEXT_30 END, 0) * B.DAYS_NEXT_30 + B.ACC_DAYS_29
                    WHEN A.QTY - C.ACC_RTF_30 = 0 THEN
                    B.ACC_DAYS_30
                    WHEN A.QTY - C.ACC_RTF_31 < 0 THEN
                    NVL(CAST((A.QTY - C.ACC_RTF_30) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_31 = 0 THEN NULL ELSE C.RTF_NEXT_31 END, 0) * B.DAYS_NEXT_31 + B.ACC_DAYS_30
                    WHEN A.QTY - C.ACC_RTF_31 = 0 THEN
                    B.ACC_DAYS_31
                    ELSE /* 오라클 CASE 인자 255개 한도로 이어지는 조건을 ELSE 안에 중첩(조건 순서·결과 동일) */
                    CASE
                         WHEN A.QTY - C.ACC_RTF_32 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_31) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_32 = 0 THEN NULL ELSE C.RTF_NEXT_32 END, 0) * B.DAYS_NEXT_32 + B.ACC_DAYS_31
                         WHEN A.QTY - C.ACC_RTF_32 = 0 THEN
                         B.ACC_DAYS_32
                         WHEN A.QTY - C.ACC_RTF_33 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_32) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_33 = 0 THEN NULL ELSE C.RTF_NEXT_33 END, 0) * B.DAYS_NEXT_33 + B.ACC_DAYS_32
                         WHEN A.QTY - C.ACC_RTF_33 = 0 THEN
                         B.ACC_DAYS_33
                         WHEN A.QTY - C.ACC_RTF_34 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_33) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_34 = 0 THEN NULL ELSE C.RTF_NEXT_34 END, 0) * B.DAYS_NEXT_34 + B.ACC_DAYS_33
                         WHEN A.QTY - C.ACC_RTF_34 = 0 THEN
                         B.ACC_DAYS_34
                         WHEN A.QTY - C.ACC_RTF_35 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_34) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_35 = 0 THEN NULL ELSE C.RTF_NEXT_35 END, 0) * B.DAYS_NEXT_35 + B.ACC_DAYS_34
                         WHEN A.QTY - C.ACC_RTF_35 = 0 THEN
                         B.ACC_DAYS_35
                         WHEN A.QTY - C.ACC_RTF_36 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_35) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_36 = 0 THEN NULL ELSE C.RTF_NEXT_36 END, 0) * B.DAYS_NEXT_36 + B.ACC_DAYS_35
                         WHEN A.QTY - C.ACC_RTF_36 = 0 THEN
                         B.ACC_DAYS_36
                         WHEN A.QTY - C.ACC_RTF_37 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_36) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_37 = 0 THEN NULL ELSE C.RTF_NEXT_37 END, 0) * B.DAYS_NEXT_37 + B.ACC_DAYS_36
                         WHEN A.QTY - C.ACC_RTF_37 = 0 THEN
                         B.ACC_DAYS_37
                         WHEN A.QTY - C.ACC_RTF_38 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_37) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_38 = 0 THEN NULL ELSE C.RTF_NEXT_38 END, 0) * B.DAYS_NEXT_38 + B.ACC_DAYS_37
                         WHEN A.QTY - C.ACC_RTF_38 = 0 THEN
                         B.ACC_DAYS_38
                         WHEN A.QTY - C.ACC_RTF_39 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_38) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_39 = 0 THEN NULL ELSE C.RTF_NEXT_39 END, 0) * B.DAYS_NEXT_39 + B.ACC_DAYS_38
                         WHEN A.QTY - C.ACC_RTF_39 = 0 THEN
                         B.ACC_DAYS_39
                         WHEN A.QTY - C.ACC_RTF_40 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_39) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_40 = 0 THEN NULL ELSE C.RTF_NEXT_40 END, 0) * B.DAYS_NEXT_40 + B.ACC_DAYS_39
                         WHEN A.QTY - C.ACC_RTF_40 = 0 THEN
                         B.ACC_DAYS_40
                         WHEN A.QTY - C.ACC_RTF_41 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_40) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_41 = 0 THEN NULL ELSE C.RTF_NEXT_41 END, 0) * B.DAYS_NEXT_41 + B.ACC_DAYS_40
                         WHEN A.QTY - C.ACC_RTF_41 = 0 THEN
                         B.ACC_DAYS_41
                         WHEN A.QTY - C.ACC_RTF_42 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_41) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_42 = 0 THEN NULL ELSE C.RTF_NEXT_42 END, 0) * B.DAYS_NEXT_42 + B.ACC_DAYS_41
                         WHEN A.QTY - C.ACC_RTF_42 = 0 THEN
                         B.ACC_DAYS_42
                         WHEN A.QTY - C.ACC_RTF_43 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_42) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_43 = 0 THEN NULL ELSE C.RTF_NEXT_43 END, 0) * B.DAYS_NEXT_43 + B.ACC_DAYS_42
                         WHEN A.QTY - C.ACC_RTF_43 = 0 THEN
                         B.ACC_DAYS_43
                         WHEN A.QTY - C.ACC_RTF_44 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_43) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_44 = 0 THEN NULL ELSE C.RTF_NEXT_44 END, 0) * B.DAYS_NEXT_44 + B.ACC_DAYS_43
                         WHEN A.QTY - C.ACC_RTF_44 = 0 THEN
                         B.ACC_DAYS_44
                         WHEN A.QTY - C.ACC_RTF_45 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_44) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_45 = 0 THEN NULL ELSE C.RTF_NEXT_45 END, 0) * B.DAYS_NEXT_45 + B.ACC_DAYS_44
                         WHEN A.QTY - C.ACC_RTF_45 = 0 THEN
                         B.ACC_DAYS_45
                         WHEN A.QTY - C.ACC_RTF_46 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_45) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_46 = 0 THEN NULL ELSE C.RTF_NEXT_46 END, 0) * B.DAYS_NEXT_46 + B.ACC_DAYS_45
                         WHEN A.QTY - C.ACC_RTF_46 = 0 THEN
                         B.ACC_DAYS_46
                         WHEN A.QTY - C.ACC_RTF_47 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_46) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_47 = 0 THEN NULL ELSE C.RTF_NEXT_47 END, 0) * B.DAYS_NEXT_47 + B.ACC_DAYS_46
                         WHEN A.QTY - C.ACC_RTF_47 = 0 THEN
                         B.ACC_DAYS_47
                         WHEN A.QTY - C.ACC_RTF_48 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_47) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_48 = 0 THEN NULL ELSE C.RTF_NEXT_48 END, 0) * B.DAYS_NEXT_48 + B.ACC_DAYS_47
                         WHEN A.QTY - C.ACC_RTF_48 = 0 THEN
                         B.ACC_DAYS_48
                         WHEN A.QTY - C.ACC_RTF_49 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_48) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_49 = 0 THEN NULL ELSE C.RTF_NEXT_49 END, 0) * B.DAYS_NEXT_49 + B.ACC_DAYS_48
                         WHEN A.QTY - C.ACC_RTF_49 = 0 THEN
                         B.ACC_DAYS_49
                         WHEN A.QTY - C.ACC_RTF_50 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_49) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_50 = 0 THEN NULL ELSE C.RTF_NEXT_50 END, 0) * B.DAYS_NEXT_50 + B.ACC_DAYS_49
                         WHEN A.QTY - C.ACC_RTF_50 = 0 THEN
                         B.ACC_DAYS_50
                         WHEN A.QTY - C.ACC_RTF_51 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_50) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_51 = 0 THEN NULL ELSE C.RTF_NEXT_51 END, 0) * B.DAYS_NEXT_51 + B.ACC_DAYS_50
                         WHEN A.QTY - C.ACC_RTF_51 = 0 THEN
                         B.ACC_DAYS_51
                         WHEN A.QTY - C.ACC_RTF_52 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_51) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_52 = 0 THEN NULL ELSE C.RTF_NEXT_52 END, 0) * B.DAYS_NEXT_52 + B.ACC_DAYS_51
                         WHEN A.QTY - C.ACC_RTF_52 = 0 THEN
                         B.ACC_DAYS_52
                         WHEN A.QTY - C.ACC_RTF_53 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_52) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_53 = 0 THEN NULL ELSE C.RTF_NEXT_53 END, 0) * B.DAYS_NEXT_53 + B.ACC_DAYS_52
                         WHEN A.QTY - C.ACC_RTF_53 = 0 THEN
                         B.ACC_DAYS_53
                         WHEN A.QTY - C.ACC_RTF_54 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_53) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_54 = 0 THEN NULL ELSE C.RTF_NEXT_54 END, 0) * B.DAYS_NEXT_54 + B.ACC_DAYS_53
                         WHEN A.QTY - C.ACC_RTF_54 = 0 THEN
                         B.ACC_DAYS_54
                         WHEN A.QTY - C.ACC_RTF_55 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_54) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_55 = 0 THEN NULL ELSE C.RTF_NEXT_55 END, 0) * B.DAYS_NEXT_55 + B.ACC_DAYS_54
                         WHEN A.QTY - C.ACC_RTF_55 = 0 THEN
                         B.ACC_DAYS_55
                         WHEN A.QTY - C.ACC_RTF_56 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_55) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_56 = 0 THEN NULL ELSE C.RTF_NEXT_56 END, 0) * B.DAYS_NEXT_56 + B.ACC_DAYS_55
                         WHEN A.QTY - C.ACC_RTF_56 = 0 THEN
                         B.ACC_DAYS_56
                         WHEN A.QTY - C.ACC_RTF_57 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_56) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_57 = 0 THEN NULL ELSE C.RTF_NEXT_57 END, 0) * B.DAYS_NEXT_57 + B.ACC_DAYS_56
                         WHEN A.QTY - C.ACC_RTF_57 = 0 THEN
                         B.ACC_DAYS_57
                         WHEN A.QTY - C.ACC_RTF_58 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_57) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_58 = 0 THEN NULL ELSE C.RTF_NEXT_58 END, 0) * B.DAYS_NEXT_58 + B.ACC_DAYS_57
                         WHEN A.QTY - C.ACC_RTF_58 = 0 THEN
                         B.ACC_DAYS_58
                         WHEN A.QTY - C.ACC_RTF_59 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_58) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_59 = 0 THEN NULL ELSE C.RTF_NEXT_59 END, 0) * B.DAYS_NEXT_59 + B.ACC_DAYS_58
                         WHEN A.QTY - C.ACC_RTF_59 = 0 THEN
                         B.ACC_DAYS_59
                         WHEN A.QTY - C.ACC_RTF_60 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_59) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_60 = 0 THEN NULL ELSE C.RTF_NEXT_60 END, 0) * B.DAYS_NEXT_60 + B.ACC_DAYS_59
                         WHEN A.QTY - C.ACC_RTF_60 = 0 THEN
                         B.ACC_DAYS_60
                         WHEN A.QTY - C.ACC_RTF_61 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_60) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_61 = 0 THEN NULL ELSE C.RTF_NEXT_61 END, 0) * B.DAYS_NEXT_61 + B.ACC_DAYS_60
                         WHEN A.QTY - C.ACC_RTF_61 = 0 THEN
                         B.ACC_DAYS_61
                         WHEN A.QTY - C.ACC_RTF_62 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_61) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_62 = 0 THEN NULL ELSE C.RTF_NEXT_62 END, 0) * B.DAYS_NEXT_62 + B.ACC_DAYS_61
                         WHEN A.QTY - C.ACC_RTF_62 = 0 THEN
                         B.ACC_DAYS_62
                         WHEN A.QTY - C.ACC_RTF_63 < 0 THEN
                         NVL(CAST((A.QTY - C.ACC_RTF_62) AS NUMBER(20,10)) / CASE WHEN C.RTF_NEXT_63 = 0 THEN NULL ELSE C.RTF_NEXT_63 END, 0) * B.DAYS_NEXT_63 + B.ACC_DAYS_62
                         WHEN A.QTY - C.ACC_RTF_63 = 0 THEN
                         B.ACC_DAYS_63

                         ELSE 365
                    END
               END
                                      AS DIO
          FROM GT_GPWW_BASE_DATA_FOR_DIO A  /* 재고 */
             , GT_GPWW_WW_DAYS_INFO      B
             , GT_GPWW_RTF_FOR_DIO       C
         WHERE B.YYYYPW              = A.YYYYPW
           AND C.YYYYPW(+)           = A.YYYYPW
           AND C.CELL_GROUP(+)       = A.CELL_GROUP
           AND C.OPERATION_GROUP(+)  = A.OPERATION_GROUP
           AND 1 = 1
           AND A.MEASURE = 'INV'  /* 재고 */
             ;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 셀그룹별 DIO 산출(표준 레포트)');  /* @@@ */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_INVENTORY_DIO_CELLGROUP;

        INSERT
          INTO GT_GPWW_INVENTORY_DIO_CELLGROUP
             ( YYYYPW
             , YYYYPW_SEQ
             , PW_DAYS
             , CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , MEASURE
             , INV_QTY
             , RTF_QTY
             , DIO )
        SELECT IA.YYYYPW
             , IA.YYYYPW_SEQ
             , IA.PW_DAYS
             , IA.CELL_GROUP
             , IA.CELL_GROUP_YN       /* 20240311 */
             , IA.OPERATION_GROUP
             , IB.MEASURE
             , IA.QTY                 AS INV_QTY
             , IC.RTF_QTY             AS RTF_QTY
             , CASE WHEN IA.QTY <= 0 THEN
                    0
                    WHEN IC.CELL_GROUP IS NULL THEN
                    365
                    WHEN IA.QTY - IC.RTF_NEXT_1 < 0 THEN
                    NVL(CAST(IA.QTY AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_1 = 0 THEN NULL ELSE IC.RTF_NEXT_1 END, 0) * A.DAYS_NEXT_1
                    WHEN IA.QTY - IC.RTF_NEXT_1 = 0 THEN
                    A.ACC_DAYS_1
                    WHEN IA.QTY - IC.ACC_RTF_2 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_1) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_2 = 0 THEN NULL ELSE IC.RTF_NEXT_2 END, 0) * A.DAYS_NEXT_2 + A.ACC_DAYS_1
                    WHEN IA.QTY - IC.ACC_RTF_2 = 0 THEN
                    A.ACC_DAYS_2
                    WHEN IA.QTY - IC.ACC_RTF_3 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_2) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_3 = 0 THEN NULL ELSE IC.RTF_NEXT_3 END, 0) * A.DAYS_NEXT_3 + A.ACC_DAYS_2
                    WHEN IA.QTY - IC.ACC_RTF_3 = 0 THEN
                    A.ACC_DAYS_3
                    WHEN IA.QTY - IC.ACC_RTF_4 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_3) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_4 = 0 THEN NULL ELSE IC.RTF_NEXT_4 END, 0) * A.DAYS_NEXT_4 + A.ACC_DAYS_3
                    WHEN IA.QTY - IC.ACC_RTF_4 = 0 THEN
                    A.ACC_DAYS_4
                    WHEN IA.QTY - IC.ACC_RTF_5 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_4) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_5 = 0 THEN NULL ELSE IC.RTF_NEXT_5 END, 0) * A.DAYS_NEXT_5 + A.ACC_DAYS_4
                    WHEN IA.QTY - IC.ACC_RTF_5 = 0 THEN
                    A.ACC_DAYS_5
                    WHEN IA.QTY - IC.ACC_RTF_6 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_5) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_6 = 0 THEN NULL ELSE IC.RTF_NEXT_6 END, 0) * A.DAYS_NEXT_6 + A.ACC_DAYS_5
                    WHEN IA.QTY - IC.ACC_RTF_6 = 0 THEN
                    A.ACC_DAYS_6
                    WHEN IA.QTY - IC.ACC_RTF_7 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_6) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_7 = 0 THEN NULL ELSE IC.RTF_NEXT_7 END, 0) * A.DAYS_NEXT_7 + A.ACC_DAYS_6
                    WHEN IA.QTY - IC.ACC_RTF_7 = 0 THEN
                    A.ACC_DAYS_7
                    WHEN IA.QTY - IC.ACC_RTF_8 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_7) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_8 = 0 THEN NULL ELSE IC.RTF_NEXT_8 END, 0) * A.DAYS_NEXT_8 + A.ACC_DAYS_7
                    WHEN IA.QTY - IC.ACC_RTF_8 = 0 THEN
                    A.ACC_DAYS_8
                    WHEN IA.QTY - IC.ACC_RTF_9 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_8) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_9 = 0 THEN NULL ELSE IC.RTF_NEXT_9 END, 0) * A.DAYS_NEXT_9 + A.ACC_DAYS_8
                    WHEN IA.QTY - IC.ACC_RTF_9 = 0 THEN
                    A.ACC_DAYS_9
                    WHEN IA.QTY - IC.ACC_RTF_10 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_9) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_10 = 0 THEN NULL ELSE IC.RTF_NEXT_10 END, 0) * A.DAYS_NEXT_10 + A.ACC_DAYS_9
                    WHEN IA.QTY - IC.ACC_RTF_10 = 0 THEN
                    A.ACC_DAYS_10
                    WHEN IA.QTY - IC.ACC_RTF_11 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_10) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_11 = 0 THEN NULL ELSE IC.RTF_NEXT_11 END, 0) * A.DAYS_NEXT_11 + A.ACC_DAYS_10
                    WHEN IA.QTY - IC.ACC_RTF_11 = 0 THEN
                    A.ACC_DAYS_11
                    WHEN IA.QTY - IC.ACC_RTF_12 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_11) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_12 = 0 THEN NULL ELSE IC.RTF_NEXT_12 END, 0) * A.DAYS_NEXT_12 + A.ACC_DAYS_11
                    WHEN IA.QTY - IC.ACC_RTF_12 = 0 THEN
                    A.ACC_DAYS_12
                    WHEN IA.QTY - IC.ACC_RTF_13 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_12) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_13 = 0 THEN NULL ELSE IC.RTF_NEXT_13 END, 0) * A.DAYS_NEXT_13 + A.ACC_DAYS_12
                    WHEN IA.QTY - IC.ACC_RTF_13 = 0 THEN
                    A.ACC_DAYS_13
                    WHEN IA.QTY - IC.ACC_RTF_14 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_13) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_14 = 0 THEN NULL ELSE IC.RTF_NEXT_14 END, 0) * A.DAYS_NEXT_14 + A.ACC_DAYS_13
                    WHEN IA.QTY - IC.ACC_RTF_14 = 0 THEN
                    A.ACC_DAYS_14
                    WHEN IA.QTY - IC.ACC_RTF_15 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_14) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_15 = 0 THEN NULL ELSE IC.RTF_NEXT_15 END, 0) * A.DAYS_NEXT_15 + A.ACC_DAYS_14
                    WHEN IA.QTY - IC.ACC_RTF_15 = 0 THEN
                    A.ACC_DAYS_15
                    WHEN IA.QTY - IC.ACC_RTF_16 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_15) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_16 = 0 THEN NULL ELSE IC.RTF_NEXT_16 END, 0) * A.DAYS_NEXT_16 + A.ACC_DAYS_15
                    WHEN IA.QTY - IC.ACC_RTF_16 = 0 THEN
                    A.ACC_DAYS_16
                    WHEN IA.QTY - IC.ACC_RTF_17 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_16) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_17 = 0 THEN NULL ELSE IC.RTF_NEXT_17 END, 0) * A.DAYS_NEXT_17 + A.ACC_DAYS_16
                    WHEN IA.QTY - IC.ACC_RTF_17 = 0 THEN
                    A.ACC_DAYS_17
                    WHEN IA.QTY - IC.ACC_RTF_18 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_17) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_18 = 0 THEN NULL ELSE IC.RTF_NEXT_18 END, 0) * A.DAYS_NEXT_18 + A.ACC_DAYS_17
                    WHEN IA.QTY - IC.ACC_RTF_18 = 0 THEN
                    A.ACC_DAYS_18
                    WHEN IA.QTY - IC.ACC_RTF_19 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_18) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_19 = 0 THEN NULL ELSE IC.RTF_NEXT_19 END, 0) * A.DAYS_NEXT_19 + A.ACC_DAYS_18
                    WHEN IA.QTY - IC.ACC_RTF_19 = 0 THEN
                    A.ACC_DAYS_19
                    WHEN IA.QTY - IC.ACC_RTF_20 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_19) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_20 = 0 THEN NULL ELSE IC.RTF_NEXT_20 END, 0) * A.DAYS_NEXT_20 + A.ACC_DAYS_19
                    WHEN IA.QTY - IC.ACC_RTF_20 = 0 THEN
                    A.ACC_DAYS_20
                    WHEN IA.QTY - IC.ACC_RTF_21 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_20) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_21 = 0 THEN NULL ELSE IC.RTF_NEXT_21 END, 0) * A.DAYS_NEXT_21 + A.ACC_DAYS_20
                    WHEN IA.QTY - IC.ACC_RTF_21 = 0 THEN
                    A.ACC_DAYS_21
                    WHEN IA.QTY - IC.ACC_RTF_22 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_21) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_22 = 0 THEN NULL ELSE IC.RTF_NEXT_22 END, 0) * A.DAYS_NEXT_22 + A.ACC_DAYS_21
                    WHEN IA.QTY - IC.ACC_RTF_22 = 0 THEN
                    A.ACC_DAYS_22
                    WHEN IA.QTY - IC.ACC_RTF_23 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_22) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_23 = 0 THEN NULL ELSE IC.RTF_NEXT_23 END, 0) * A.DAYS_NEXT_23 + A.ACC_DAYS_22
                    WHEN IA.QTY - IC.ACC_RTF_23 = 0 THEN
                    A.ACC_DAYS_23
                    WHEN IA.QTY - IC.ACC_RTF_24 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_23) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_24 = 0 THEN NULL ELSE IC.RTF_NEXT_24 END, 0) * A.DAYS_NEXT_24 + A.ACC_DAYS_23
                    WHEN IA.QTY - IC.ACC_RTF_24 = 0 THEN
                    A.ACC_DAYS_24
                    WHEN IA.QTY - IC.ACC_RTF_25 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_24) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_25 = 0 THEN NULL ELSE IC.RTF_NEXT_25 END, 0) * A.DAYS_NEXT_25 + A.ACC_DAYS_24
                    WHEN IA.QTY - IC.ACC_RTF_25 = 0 THEN
                    A.ACC_DAYS_25
                    WHEN IA.QTY - IC.ACC_RTF_26 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_25) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_26 = 0 THEN NULL ELSE IC.RTF_NEXT_26 END, 0) * A.DAYS_NEXT_26 + A.ACC_DAYS_25
                    WHEN IA.QTY - IC.ACC_RTF_26 = 0 THEN
                    A.ACC_DAYS_26
                    WHEN IA.QTY - IC.ACC_RTF_27 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_26) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_27 = 0 THEN NULL ELSE IC.RTF_NEXT_27 END, 0) * A.DAYS_NEXT_27 + A.ACC_DAYS_26
                    WHEN IA.QTY - IC.ACC_RTF_27 = 0 THEN
                    A.ACC_DAYS_27
                    WHEN IA.QTY - IC.ACC_RTF_28 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_27) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_28 = 0 THEN NULL ELSE IC.RTF_NEXT_28 END, 0) * A.DAYS_NEXT_28 + A.ACC_DAYS_27
                    WHEN IA.QTY - IC.ACC_RTF_28 = 0 THEN
                    A.ACC_DAYS_28
                    WHEN IA.QTY - IC.ACC_RTF_29 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_28) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_29 = 0 THEN NULL ELSE IC.RTF_NEXT_29 END, 0) * A.DAYS_NEXT_29 + A.ACC_DAYS_28
                    WHEN IA.QTY - IC.ACC_RTF_29 = 0 THEN
                    A.ACC_DAYS_29
                    WHEN IA.QTY - IC.ACC_RTF_30 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_29) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_30 = 0 THEN NULL ELSE IC.RTF_NEXT_30 END, 0) * A.DAYS_NEXT_30 + A.ACC_DAYS_29
                    WHEN IA.QTY - IC.ACC_RTF_30 = 0 THEN
                    A.ACC_DAYS_30
                    WHEN IA.QTY - IC.ACC_RTF_31 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_30) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_31 = 0 THEN NULL ELSE IC.RTF_NEXT_31 END, 0) * A.DAYS_NEXT_31 + A.ACC_DAYS_30
                    WHEN IA.QTY - IC.ACC_RTF_31 = 0 THEN
                    A.ACC_DAYS_31
                    ELSE /* 오라클 CASE 인자 255개 한도로 이어지는 조건을 ELSE 안에 중첩(조건 순서·결과 동일) */
                    CASE
                         WHEN IA.QTY - IC.ACC_RTF_32 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_31) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_32 = 0 THEN NULL ELSE IC.RTF_NEXT_32 END, 0) * A.DAYS_NEXT_32 + A.ACC_DAYS_31
                         WHEN IA.QTY - IC.ACC_RTF_32 = 0 THEN
                         A.ACC_DAYS_32
                         WHEN IA.QTY - IC.ACC_RTF_33 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_32) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_33 = 0 THEN NULL ELSE IC.RTF_NEXT_33 END, 0) * A.DAYS_NEXT_33 + A.ACC_DAYS_32
                         WHEN IA.QTY - IC.ACC_RTF_33 = 0 THEN
                         A.ACC_DAYS_33
                         WHEN IA.QTY - IC.ACC_RTF_34 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_33) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_34 = 0 THEN NULL ELSE IC.RTF_NEXT_34 END, 0) * A.DAYS_NEXT_34 + A.ACC_DAYS_33
                         WHEN IA.QTY - IC.ACC_RTF_34 = 0 THEN
                         A.ACC_DAYS_34
                         WHEN IA.QTY - IC.ACC_RTF_35 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_34) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_35 = 0 THEN NULL ELSE IC.RTF_NEXT_35 END, 0) * A.DAYS_NEXT_35 + A.ACC_DAYS_34
                         WHEN IA.QTY - IC.ACC_RTF_35 = 0 THEN
                         A.ACC_DAYS_35
                         WHEN IA.QTY - IC.ACC_RTF_36 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_35) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_36 = 0 THEN NULL ELSE IC.RTF_NEXT_36 END, 0) * A.DAYS_NEXT_36 + A.ACC_DAYS_35
                         WHEN IA.QTY - IC.ACC_RTF_36 = 0 THEN
                         A.ACC_DAYS_36
                         WHEN IA.QTY - IC.ACC_RTF_37 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_36) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_37 = 0 THEN NULL ELSE IC.RTF_NEXT_37 END, 0) * A.DAYS_NEXT_37 + A.ACC_DAYS_36
                         WHEN IA.QTY - IC.ACC_RTF_37 = 0 THEN
                         A.ACC_DAYS_37
                         WHEN IA.QTY - IC.ACC_RTF_38 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_37) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_38 = 0 THEN NULL ELSE IC.RTF_NEXT_38 END, 0) * A.DAYS_NEXT_38 + A.ACC_DAYS_37
                         WHEN IA.QTY - IC.ACC_RTF_38 = 0 THEN
                         A.ACC_DAYS_38
                         WHEN IA.QTY - IC.ACC_RTF_39 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_38) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_39 = 0 THEN NULL ELSE IC.RTF_NEXT_39 END, 0) * A.DAYS_NEXT_39 + A.ACC_DAYS_38
                         WHEN IA.QTY - IC.ACC_RTF_39 = 0 THEN
                         A.ACC_DAYS_39
                         WHEN IA.QTY - IC.ACC_RTF_40 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_39) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_40 = 0 THEN NULL ELSE IC.RTF_NEXT_40 END, 0) * A.DAYS_NEXT_40 + A.ACC_DAYS_39
                         WHEN IA.QTY - IC.ACC_RTF_40 = 0 THEN
                         A.ACC_DAYS_40
                         WHEN IA.QTY - IC.ACC_RTF_41 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_40) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_41 = 0 THEN NULL ELSE IC.RTF_NEXT_41 END, 0) * A.DAYS_NEXT_41 + A.ACC_DAYS_40
                         WHEN IA.QTY - IC.ACC_RTF_41 = 0 THEN
                         A.ACC_DAYS_41
                         WHEN IA.QTY - IC.ACC_RTF_42 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_41) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_42 = 0 THEN NULL ELSE IC.RTF_NEXT_42 END, 0) * A.DAYS_NEXT_42 + A.ACC_DAYS_41
                         WHEN IA.QTY - IC.ACC_RTF_42 = 0 THEN
                         A.ACC_DAYS_42
                         WHEN IA.QTY - IC.ACC_RTF_43 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_42) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_43 = 0 THEN NULL ELSE IC.RTF_NEXT_43 END, 0) * A.DAYS_NEXT_43 + A.ACC_DAYS_42
                         WHEN IA.QTY - IC.ACC_RTF_43 = 0 THEN
                         A.ACC_DAYS_43
                         WHEN IA.QTY - IC.ACC_RTF_44 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_43) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_44 = 0 THEN NULL ELSE IC.RTF_NEXT_44 END, 0) * A.DAYS_NEXT_44 + A.ACC_DAYS_43
                         WHEN IA.QTY - IC.ACC_RTF_44 = 0 THEN
                         A.ACC_DAYS_44
                         WHEN IA.QTY - IC.ACC_RTF_45 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_44) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_45 = 0 THEN NULL ELSE IC.RTF_NEXT_45 END, 0) * A.DAYS_NEXT_45 + A.ACC_DAYS_44
                         WHEN IA.QTY - IC.ACC_RTF_45 = 0 THEN
                         A.ACC_DAYS_45
                         WHEN IA.QTY - IC.ACC_RTF_46 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_45) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_46 = 0 THEN NULL ELSE IC.RTF_NEXT_46 END, 0) * A.DAYS_NEXT_46 + A.ACC_DAYS_45
                         WHEN IA.QTY - IC.ACC_RTF_46 = 0 THEN
                         A.ACC_DAYS_46
                         WHEN IA.QTY - IC.ACC_RTF_47 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_46) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_47 = 0 THEN NULL ELSE IC.RTF_NEXT_47 END, 0) * A.DAYS_NEXT_47 + A.ACC_DAYS_46
                         WHEN IA.QTY - IC.ACC_RTF_47 = 0 THEN
                         A.ACC_DAYS_47
                         WHEN IA.QTY - IC.ACC_RTF_48 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_47) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_48 = 0 THEN NULL ELSE IC.RTF_NEXT_48 END, 0) * A.DAYS_NEXT_48 + A.ACC_DAYS_47
                         WHEN IA.QTY - IC.ACC_RTF_48 = 0 THEN
                         A.ACC_DAYS_48
                         WHEN IA.QTY - IC.ACC_RTF_49 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_48) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_49 = 0 THEN NULL ELSE IC.RTF_NEXT_49 END, 0) * A.DAYS_NEXT_49 + A.ACC_DAYS_48
                         WHEN IA.QTY - IC.ACC_RTF_49 = 0 THEN
                         A.ACC_DAYS_49
                         WHEN IA.QTY - IC.ACC_RTF_50 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_49) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_50 = 0 THEN NULL ELSE IC.RTF_NEXT_50 END, 0) * A.DAYS_NEXT_50 + A.ACC_DAYS_49
                         WHEN IA.QTY - IC.ACC_RTF_50 = 0 THEN
                         A.ACC_DAYS_50
                         WHEN IA.QTY - IC.ACC_RTF_51 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_50) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_51 = 0 THEN NULL ELSE IC.RTF_NEXT_51 END, 0) * A.DAYS_NEXT_51 + A.ACC_DAYS_50
                         WHEN IA.QTY - IC.ACC_RTF_51 = 0 THEN
                         A.ACC_DAYS_51
                         WHEN IA.QTY - IC.ACC_RTF_52 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_51) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_52 = 0 THEN NULL ELSE IC.RTF_NEXT_52 END, 0) * A.DAYS_NEXT_52 + A.ACC_DAYS_51
                         WHEN IA.QTY - IC.ACC_RTF_52 = 0 THEN
                         A.ACC_DAYS_52
                         WHEN IA.QTY - IC.ACC_RTF_53 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_52) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_53 = 0 THEN NULL ELSE IC.RTF_NEXT_53 END, 0) * A.DAYS_NEXT_53 + A.ACC_DAYS_52
                         WHEN IA.QTY - IC.ACC_RTF_53 = 0 THEN
                         A.ACC_DAYS_53
                         WHEN IA.QTY - IC.ACC_RTF_54 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_53) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_54 = 0 THEN NULL ELSE IC.RTF_NEXT_54 END, 0) * A.DAYS_NEXT_54 + A.ACC_DAYS_53
                         WHEN IA.QTY - IC.ACC_RTF_54 = 0 THEN
                         A.ACC_DAYS_54
                         WHEN IA.QTY - IC.ACC_RTF_55 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_54) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_55 = 0 THEN NULL ELSE IC.RTF_NEXT_55 END, 0) * A.DAYS_NEXT_55 + A.ACC_DAYS_54
                         WHEN IA.QTY - IC.ACC_RTF_55 = 0 THEN
                         A.ACC_DAYS_55
                         WHEN IA.QTY - IC.ACC_RTF_56 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_55) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_56 = 0 THEN NULL ELSE IC.RTF_NEXT_56 END, 0) * A.DAYS_NEXT_56 + A.ACC_DAYS_55
                         WHEN IA.QTY - IC.ACC_RTF_56 = 0 THEN
                         A.ACC_DAYS_56
                         WHEN IA.QTY - IC.ACC_RTF_57 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_56) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_57 = 0 THEN NULL ELSE IC.RTF_NEXT_57 END, 0) * A.DAYS_NEXT_57 + A.ACC_DAYS_56
                         WHEN IA.QTY - IC.ACC_RTF_57 = 0 THEN
                         A.ACC_DAYS_57
                         WHEN IA.QTY - IC.ACC_RTF_58 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_57) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_58 = 0 THEN NULL ELSE IC.RTF_NEXT_58 END, 0) * A.DAYS_NEXT_58 + A.ACC_DAYS_57
                         WHEN IA.QTY - IC.ACC_RTF_58 = 0 THEN
                         A.ACC_DAYS_58
                         WHEN IA.QTY - IC.ACC_RTF_59 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_58) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_59 = 0 THEN NULL ELSE IC.RTF_NEXT_59 END, 0) * A.DAYS_NEXT_59 + A.ACC_DAYS_58
                         WHEN IA.QTY - IC.ACC_RTF_59 = 0 THEN
                         A.ACC_DAYS_59
                         WHEN IA.QTY - IC.ACC_RTF_60 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_59) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_60 = 0 THEN NULL ELSE IC.RTF_NEXT_60 END, 0) * A.DAYS_NEXT_60 + A.ACC_DAYS_59
                         WHEN IA.QTY - IC.ACC_RTF_60 = 0 THEN
                         A.ACC_DAYS_60
                         WHEN IA.QTY - IC.ACC_RTF_61 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_60) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_61 = 0 THEN NULL ELSE IC.RTF_NEXT_61 END, 0) * A.DAYS_NEXT_61 + A.ACC_DAYS_60
                         WHEN IA.QTY - IC.ACC_RTF_61 = 0 THEN
                         A.ACC_DAYS_61
                         WHEN IA.QTY - IC.ACC_RTF_62 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_61) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_62 = 0 THEN NULL ELSE IC.RTF_NEXT_62 END, 0) * A.DAYS_NEXT_62 + A.ACC_DAYS_61
                         WHEN IA.QTY - IC.ACC_RTF_62 = 0 THEN
                         A.ACC_DAYS_62
                         WHEN IA.QTY - IC.ACC_RTF_63 < 0 THEN
                         NVL(CAST((IA.QTY - IC.ACC_RTF_62) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_63 = 0 THEN NULL ELSE IC.RTF_NEXT_63 END, 0) * A.DAYS_NEXT_63 + A.ACC_DAYS_62
                         WHEN IA.QTY - IC.ACC_RTF_63 = 0 THEN
                         A.ACC_DAYS_63

                         ELSE 365
                    END
               END
                                      AS DIO
          FROM (SELECT B.*
                     , REPLACE(B.MEASURE, 'INV_', '') AS MEASURE_GROUP
                  FROM GT_GPWW_BASE_DATA_FOR_DIO_CELLGROUP B  /* 재고 */
                 WHERE 1 = 1
                   AND B.MEASURE LIKE 'INV%'  /* 재고 */
                   /* AND ISNULL(I.QTY,0) > 0 */
               ) IA
             , (SELECT 'DIO_SALES' AS MEASURE, 'SALES' AS MEASURE_GROUP FROM DUAL UNION
                SELECT 'DIO_PACK' AS MEASURE, 'PACK' AS MEASURE_GROUP FROM DUAL UNION
                SELECT 'DIO_CELL' AS MEASURE, 'CELL' AS MEASURE_GROUP FROM DUAL
               ) IB
             , GT_GPWW_WW_DAYS_INFO A
             , (SELECT C.*  /* LEFT OUTER JOIN 에서 INNER JOIN 으로 변경 - 수량이 빠지는 부분이 없어 속도 개선위해 변경함 빠지는 부분이 있으면 추가 로직으로 보충해야 함. */
                     , REPLACE(C.MEASURE, 'RTF_', '') AS MEASURE_GROUP
                  FROM GT_GPWW_RTF_FOR_DIO_CELLGROUP C
               ) IC
         WHERE 1 = 1
           /* AND CL.MEASURE_GROUP = SUBSTRING(I.MEASURE, CHARINDEX('_', I.MEASURE) + 1, LEN(I.MEASURE)) */
           AND IB.MEASURE_GROUP    = IA.MEASURE_GROUP
           AND A.YYYYPW            = IA.YYYYPW
           AND IC.YYYYPW           = IA.YYYYPW
           AND IC.CELL_GROUP       = IA.CELL_GROUP
           AND IC.OPERATION_GROUP  = IA.OPERATION_GROUP
           /* AND SUBSTRING(R.MEASURE, CHARINDEX('_', R.MEASURE) + 1, LEN(R.MEASURE)) = SUBSTRING(I.MEASURE, CHARINDEX('_', I.MEASURE) + 1, LEN(I.MEASURE)) */
           AND IC.MEASURE_GROUP    = IA.MEASURE_GROUP
           AND 1 = 1
           AND IA.MEASURE LIKE 'INV%'  /* 재고 */
             ;



        /* PACK_DIO = PACK_DIO - SALES_DIO */
        MERGE INTO GT_GPWW_INVENTORY_DIO_CELLGROUP A
        USING (SELECT B.YYYYPW
                    , B.CELL_GROUP
                    , B.MEASURE
                    , CASE WHEN B.MEASURE = 'DIO_PACK' THEN B.DIO - C.DIO
                           ELSE B.DIO
                      END AS DIO_RESULT
                 FROM GT_GPWW_INVENTORY_DIO_CELLGROUP B
                    , GT_GPWW_INVENTORY_DIO_CELLGROUP C
                WHERE 1 = 1
                  AND C.YYYYPW(+)     = B.YYYYPW
                  AND C.CELL_GROUP(+) = B.CELL_GROUP
                  AND C.MEASURE(+)    = 'DIO_SALES'
                  AND B.MEASURE       = 'DIO_PACK'
              ) IA
           ON (    1 = 1
               AND A.YYYYPW     = IA.YYYYPW
               AND A.CELL_GROUP = IA.CELL_GROUP
               AND A.MEASURE    = IA.MEASURE
               AND A.MEASURE    = 'DIO_PACK'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET A.DIO = CASE WHEN IA.DIO_RESULT < 0 THEN 0 ELSE IA.DIO_RESULT END;

        /* CELL_DIO = CELL_DIO - PACK_DIO - SALES_DIO */
        MERGE INTO GT_GPWW_INVENTORY_DIO_CELLGROUP A
        USING (SELECT B.YYYYPW
                    , B.CELL_GROUP
                    , B.MEASURE
                    , CASE WHEN B.MEASURE = 'DIO_CELL' THEN B.DIO - D.DIO - C.DIO
                           ELSE B.DIO
                      END AS DIO_RESULT
                 FROM GT_GPWW_INVENTORY_DIO_CELLGROUP B
                    , GT_GPWW_INVENTORY_DIO_CELLGROUP C
                    , GT_GPWW_INVENTORY_DIO_CELLGROUP D
                WHERE 1 = 1
                  AND C.YYYYPW(+)     = B.YYYYPW
                  AND C.CELL_GROUP(+) = B.CELL_GROUP
                  AND C.MEASURE(+)    = 'DIO_PACK'
                  AND D.YYYYPW(+)     = B.YYYYPW
                  AND D.CELL_GROUP(+) = B.CELL_GROUP
                  AND D.MEASURE(+)    = 'DIO_SALES'
                  AND B.MEASURE       = 'DIO_CELL'
              ) IA
           ON (    1 = 1
               AND A.YYYYPW     = IA.YYYYPW
               AND A.CELL_GROUP = IA.CELL_GROUP
               AND A.MEASURE    = IA.MEASURE
               AND A.MEASURE    = 'DIO_CELL'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET A.DIO = CASE WHEN IA.DIO_RESULT < 0 THEN 0 ELSE IA.DIO_RESULT END;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 셀그룹별 DIO 산출(Detail 표준레포트)');  /* @@@ */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPWW_INVENTORY_DIO_DETAILREPORT;

        INSERT
          INTO GT_GPWW_INVENTORY_DIO_DETAILREPORT
             ( YYYYPW
             , YYYYPW_SEQ
             , PW_DAYS
             , CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , PRODUCT_LEVEL1
             , PRODUCT_LEVEL2
             , MEASURE
             , INV_QTY
             , RTF_QTY
             , DIO
             , ATTRIBUTE9 )
        SELECT IA.YYYYPW
             , A.YYYYPW_SEQ
             , A.PW_DAYS
             , IA.CELL_GROUP
             , IA.CELL_GROUP_YN       /* 20240311 */
             , IA.OPERATION_GROUP
             , NVL(IA.PRODUCT_LEVEL1, '-') AS PRODUCT_LEVEL1
             , NVL(IA.PRODUCT_LEVEL2, '-') AS PRODUCT_LEVEL2
             , IB.MEASURE
             , IA.QTY                 AS INV_QTY
             , IC.RTF_QTY             AS RTF_QTY
             , CASE WHEN IA.QTY <= 0 THEN
                    0
                    WHEN IC.CELL_GROUP IS NULL THEN
                    365
                    WHEN IA.QTY - IC.RTF_NEXT_1 < 0 THEN
                    NVL(CAST(IA.QTY AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_1 = 0 THEN NULL ELSE IC.RTF_NEXT_1 END, 0) * A.DAYS_NEXT_1
                    WHEN IA.QTY - IC.RTF_NEXT_1 = 0 THEN
                    A.ACC_DAYS_1
                    WHEN IA.QTY - IC.ACC_RTF_2 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_1) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_2 = 0 THEN NULL ELSE IC.RTF_NEXT_2 END, 0) * A.DAYS_NEXT_2 + A.ACC_DAYS_1
                    WHEN IA.QTY - IC.ACC_RTF_2 = 0 THEN
                    A.ACC_DAYS_2
                    WHEN IA.QTY - IC.ACC_RTF_3 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_2) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_3 = 0 THEN NULL ELSE IC.RTF_NEXT_3 END, 0) * A.DAYS_NEXT_3 + A.ACC_DAYS_2
                    WHEN IA.QTY - IC.ACC_RTF_3 = 0 THEN
                    A.ACC_DAYS_3
                    WHEN IA.QTY - IC.ACC_RTF_4 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_3) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_4 = 0 THEN NULL ELSE IC.RTF_NEXT_4 END, 0) * A.DAYS_NEXT_4 + A.ACC_DAYS_3
                    WHEN IA.QTY - IC.ACC_RTF_4 = 0 THEN
                    A.ACC_DAYS_4
                    WHEN IA.QTY - IC.ACC_RTF_5 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_4) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_5 = 0 THEN NULL ELSE IC.RTF_NEXT_5 END, 0) * A.DAYS_NEXT_5 + A.ACC_DAYS_4
                    WHEN IA.QTY - IC.ACC_RTF_5 = 0 THEN
                    A.ACC_DAYS_5
                    WHEN IA.QTY - IC.ACC_RTF_6 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_5) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_6 = 0 THEN NULL ELSE IC.RTF_NEXT_6 END, 0) * A.DAYS_NEXT_6 + A.ACC_DAYS_5
                    WHEN IA.QTY - IC.ACC_RTF_6 = 0 THEN
                    A.ACC_DAYS_6
                    WHEN IA.QTY - IC.ACC_RTF_7 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_6) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_7 = 0 THEN NULL ELSE IC.RTF_NEXT_7 END, 0) * A.DAYS_NEXT_7 + A.ACC_DAYS_6
                    WHEN IA.QTY - IC.ACC_RTF_7 = 0 THEN
                    A.ACC_DAYS_7
                    WHEN IA.QTY - IC.ACC_RTF_8 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_7) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_8 = 0 THEN NULL ELSE IC.RTF_NEXT_8 END, 0) * A.DAYS_NEXT_8 + A.ACC_DAYS_7
                    WHEN IA.QTY - IC.ACC_RTF_8 = 0 THEN
                    A.ACC_DAYS_8
                    WHEN IA.QTY - IC.ACC_RTF_9 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_8) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_9 = 0 THEN NULL ELSE IC.RTF_NEXT_9 END, 0) * A.DAYS_NEXT_9 + A.ACC_DAYS_8
                    WHEN IA.QTY - IC.ACC_RTF_9 = 0 THEN
                    A.ACC_DAYS_9
                    WHEN IA.QTY - IC.ACC_RTF_10 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_9) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_10 = 0 THEN NULL ELSE IC.RTF_NEXT_10 END, 0) * A.DAYS_NEXT_10 + A.ACC_DAYS_9
                    WHEN IA.QTY - IC.ACC_RTF_10 = 0 THEN
                    A.ACC_DAYS_10
                    WHEN IA.QTY - IC.ACC_RTF_11 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_10) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_11 = 0 THEN NULL ELSE IC.RTF_NEXT_11 END, 0) * A.DAYS_NEXT_11 + A.ACC_DAYS_10
                    WHEN IA.QTY - IC.ACC_RTF_11 = 0 THEN
                    A.ACC_DAYS_11
                    WHEN IA.QTY - IC.ACC_RTF_12 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_11) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_12 = 0 THEN NULL ELSE IC.RTF_NEXT_12 END, 0) * A.DAYS_NEXT_12 + A.ACC_DAYS_11
                    WHEN IA.QTY - IC.ACC_RTF_12 = 0 THEN
                    A.ACC_DAYS_12

                    ELSE 365
               END
                                      AS DIO
             , 'LV2'                  AS ATTRIBUTE9

          FROM (SELECT B.*
                     , REPLACE(B.MEASURE, 'INV_', '') AS MEASURE_GROUP
                  FROM GT_GPWW_BASE_DATA_FOR_DIO_DETAILREPORT B  /* 재고 */
                 WHERE 1 = 1
                   AND B.MEASURE LIKE 'INV%'  /* 재고 */
                   AND B.QTY > 0  /* 원문 ISNULL(I.QTY,0) > 0 : NULL 은 양쪽 모두 제외되어 동일 */
               ) IA
             , (SELECT 'DIO_SALES' AS MEASURE, 'SALES' AS MEASURE_GROUP FROM DUAL UNION
                SELECT 'DIO_PACK' AS MEASURE, 'PACK' AS MEASURE_GROUP FROM DUAL UNION
                SELECT 'DIO_CELL' AS MEASURE, 'CELL' AS MEASURE_GROUP FROM DUAL
               ) IB
             , GT_GPWW_WW_DAYS_INFO A
             , (SELECT C.*  /* LEFT OUTER JOIN 에서 INNER JOIN 으로 변경 - 수량이 빠지는 부분이 없어 속도 개선위해 변경함 빠지는 부분이 있으면 추가 로직으로 보충해야 함. */
                     , REPLACE(C.MEASURE, 'RTF_', '') AS MEASURE_GROUP
                  FROM GT_GPWW_RTF_FOR_DIO_DETAILREPORT C
               ) IC
         WHERE 1 = 1
           AND IB.MEASURE_GROUP    = IA.MEASURE_GROUP
           AND A.YYYYPW            = IA.YYYYPW
           AND IC.YYYYPW           = IA.YYYYPW
           AND IC.CELL_GROUP       = IA.CELL_GROUP
           AND IC.PRODUCT_LEVEL1   = IA.PRODUCT_LEVEL1
           AND IC.PRODUCT_LEVEL2   = IA.PRODUCT_LEVEL2
           AND IC.OPERATION_GROUP  = IA.OPERATION_GROUP
           AND IC.MEASURE_GROUP    = IA.MEASURE_GROUP
             ;
          /*
          FROM #BASE_DATA_FOR_DIO_DETAILREPORT  I -- 재고
               INNER JOIN (
                    select 'DIO_SALES' AS MEASURE, 'SALES' AS MEASURE_GROUP UNION
                    select 'DIO_PACK' AS MEASURE, 'PACK' AS MEASURE_GROUP UNION
                    select 'DIO_CELL' AS MEASURE, 'CELL' AS MEASURE_GROUP
                ) CL
              ON 1=1
              AND CL.MEASURE_GROUP = SUBSTRING(I.MEASURE, CHARINDEX('_', I.MEASURE) + 1, LEN(I.MEASURE))
               INNER JOIN #TMP_WW_DAYS_INFO D
                      ON D.YYYYPW            = I.YYYYPW
               LEFT JOIN #TMP_RTF_FOR_DIO_DETAILREPORT R
                      ON R.YYYYPW            = I.YYYYPW
                     AND R.CELL_GROUP        = I.CELL_GROUP
                     AND R.PRODUCT_LEVEL1    = I.PRODUCT_LEVEL1
                     AND R.PRODUCT_LEVEL2    = I.PRODUCT_LEVEL2
                     AND R.OPERATION_GROUP    = I.OPERATION_GROUP
                     AND SUBSTRING(R.MEASURE, CHARINDEX('_', R.MEASURE) + 1, LEN(R.MEASURE)) = SUBSTRING(I.MEASURE, CHARINDEX('_', I.MEASURE) + 1, LEN(I.MEASURE))
        WHERE 1=1
          AND I.MEASURE LIKE 'INV%' -- 재고
          AND ISNULL(I.QTY,0) > 0
          */


        /* PACK_DIO = PACK_DIO - SALES_DIO */
        MERGE INTO GT_GPWW_INVENTORY_DIO_DETAILREPORT A
        USING (SELECT B.YYYYPW
                    , B.CELL_GROUP
                    , B.MEASURE
                    , B.PRODUCT_LEVEL1
                    , B.PRODUCT_LEVEL2
                    , CASE WHEN B.MEASURE = 'DIO_PACK' THEN B.DIO - C.DIO
                           ELSE B.DIO
                      END AS DIO_RESULT
                 FROM GT_GPWW_INVENTORY_DIO_DETAILREPORT B
                    , GT_GPWW_INVENTORY_DIO_DETAILREPORT C
                WHERE 1 = 1
                  AND C.YYYYPW(+)         = B.YYYYPW
                  AND C.CELL_GROUP(+)     = B.CELL_GROUP
                  AND C.PRODUCT_LEVEL1(+) = B.PRODUCT_LEVEL1
                  AND C.PRODUCT_LEVEL2(+) = B.PRODUCT_LEVEL2
                  AND C.MEASURE(+)        = 'DIO_SALES'
                  AND B.MEASURE           = 'DIO_PACK'
              ) IA
           ON (    1 = 1
               AND A.YYYYPW         = IA.YYYYPW
               AND A.CELL_GROUP     = IA.CELL_GROUP
               AND A.PRODUCT_LEVEL1 = IA.PRODUCT_LEVEL1
               AND A.PRODUCT_LEVEL2 = IA.PRODUCT_LEVEL2
               AND A.MEASURE        = IA.MEASURE
               AND A.MEASURE        = 'DIO_PACK'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET A.DIO = CASE WHEN IA.DIO_RESULT < 0 THEN 0 ELSE IA.DIO_RESULT END;

        /* PRODUCT_LEVEL1 기준 DIO 산출 */
        INSERT
          INTO GT_GPWW_INVENTORY_DIO_DETAILREPORT
             ( YYYYPW
             , YYYYPW_SEQ
             , PW_DAYS
             , CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , PRODUCT_LEVEL1
             , PRODUCT_LEVEL2
             , MEASURE
             , INV_QTY
             , RTF_QTY
             , DIO
             , ATTRIBUTE9 )
        SELECT A.YYYYPW
             , A.YYYYPW_SEQ
             , A.PW_DAYS
             , IA.CELL_GROUP
             , IA.CELL_GROUP_YN       /* 20240311 */
             , 'C'                    AS OPERATION_GROUP  /* I.OPERATION_GROUP operatoin 구분없이 */
             , NVL(IA.PRODUCT_LEVEL1, '-') AS PRODUCT_LEVEL1
             , 'DIO'                  AS PRODUCT_LEVEL2
             , IB.MEASURE
             , IA.QTY                 AS INV_QTY
             , IC.RTF_QTY             AS RTF_QTY
             , CASE WHEN IA.QTY <= 0 THEN
                    0
                    WHEN IC.CELL_GROUP IS NULL THEN
                    365
                    WHEN IA.QTY - IC.RTF_NEXT_1 < 0 THEN
                    NVL(CAST(IA.QTY AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_1 = 0 THEN NULL ELSE IC.RTF_NEXT_1 END, 0) * A.DAYS_NEXT_1
                    WHEN IA.QTY - IC.RTF_NEXT_1 = 0 THEN
                    A.ACC_DAYS_1
                    WHEN IA.QTY - IC.ACC_RTF_2 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_1) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_2 = 0 THEN NULL ELSE IC.RTF_NEXT_2 END, 0) * A.DAYS_NEXT_2 + A.ACC_DAYS_1
                    WHEN IA.QTY - IC.ACC_RTF_2 = 0 THEN
                    A.ACC_DAYS_2
                    WHEN IA.QTY - IC.ACC_RTF_3 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_2) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_3 = 0 THEN NULL ELSE IC.RTF_NEXT_3 END, 0) * A.DAYS_NEXT_3 + A.ACC_DAYS_2
                    WHEN IA.QTY - IC.ACC_RTF_3 = 0 THEN
                    A.ACC_DAYS_3
                    WHEN IA.QTY - IC.ACC_RTF_4 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_3) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_4 = 0 THEN NULL ELSE IC.RTF_NEXT_4 END, 0) * A.DAYS_NEXT_4 + A.ACC_DAYS_3
                    WHEN IA.QTY - IC.ACC_RTF_4 = 0 THEN
                    A.ACC_DAYS_4
                    WHEN IA.QTY - IC.ACC_RTF_5 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_4) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_5 = 0 THEN NULL ELSE IC.RTF_NEXT_5 END, 0) * A.DAYS_NEXT_5 + A.ACC_DAYS_4
                    WHEN IA.QTY - IC.ACC_RTF_5 = 0 THEN
                    A.ACC_DAYS_5
                    WHEN IA.QTY - IC.ACC_RTF_6 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_5) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_6 = 0 THEN NULL ELSE IC.RTF_NEXT_6 END, 0) * A.DAYS_NEXT_6 + A.ACC_DAYS_5
                    WHEN IA.QTY - IC.ACC_RTF_6 = 0 THEN
                    A.ACC_DAYS_6
                    WHEN IA.QTY - IC.ACC_RTF_7 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_6) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_7 = 0 THEN NULL ELSE IC.RTF_NEXT_7 END, 0) * A.DAYS_NEXT_7 + A.ACC_DAYS_6
                    WHEN IA.QTY - IC.ACC_RTF_7 = 0 THEN
                    A.ACC_DAYS_7
                    WHEN IA.QTY - IC.ACC_RTF_8 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_7) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_8 = 0 THEN NULL ELSE IC.RTF_NEXT_8 END, 0) * A.DAYS_NEXT_8 + A.ACC_DAYS_7
                    WHEN IA.QTY - IC.ACC_RTF_8 = 0 THEN
                    A.ACC_DAYS_8
                    WHEN IA.QTY - IC.ACC_RTF_9 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_8) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_9 = 0 THEN NULL ELSE IC.RTF_NEXT_9 END, 0) * A.DAYS_NEXT_9 + A.ACC_DAYS_8
                    WHEN IA.QTY - IC.ACC_RTF_9 = 0 THEN
                    A.ACC_DAYS_9
                    WHEN IA.QTY - IC.ACC_RTF_10 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_9) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_10 = 0 THEN NULL ELSE IC.RTF_NEXT_10 END, 0) * A.DAYS_NEXT_10 + A.ACC_DAYS_9
                    WHEN IA.QTY - IC.ACC_RTF_10 = 0 THEN
                    A.ACC_DAYS_10
                    WHEN IA.QTY - IC.ACC_RTF_11 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_10) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_11 = 0 THEN NULL ELSE IC.RTF_NEXT_11 END, 0) * A.DAYS_NEXT_11 + A.ACC_DAYS_10
                    WHEN IA.QTY - IC.ACC_RTF_11 = 0 THEN
                    A.ACC_DAYS_11
                    WHEN IA.QTY - IC.ACC_RTF_12 < 0 THEN
                    NVL(CAST((IA.QTY - IC.ACC_RTF_11) AS NUMBER(20,10)) / CASE WHEN IC.RTF_NEXT_12 = 0 THEN NULL ELSE IC.RTF_NEXT_12 END, 0) * A.DAYS_NEXT_12 + A.ACC_DAYS_11
                    WHEN IA.QTY - IC.ACC_RTF_12 = 0 THEN
                    A.ACC_DAYS_12

                    ELSE 365
               END
                                      AS DIO
             , 'LV1'                  AS ATTRIBUTE9

          FROM (SELECT B.YYYYPW
                     , B.YYYYPW_SEQ
                     , B.PW_DAYS
                     , B.CELL_GROUP
                     , B.CELL_GROUP_YN  /* , OPERATION_GROUP */
                     , B.PRODUCT_LEVEL1
                     , B.MEASURE
                     , REPLACE(B.MEASURE, 'INV_', '') AS MEASURE_GROUP
                     , SUM(B.QTY) AS QTY
                  FROM GT_GPWW_BASE_DATA_FOR_DIO_DETAILREPORT B
                 WHERE 1 = 1
                   AND B.MEASURE LIKE 'INV%'  /* 재고 */
                   AND B.QTY > 0  /* 원문 ISNULL(QTY,0) > 0 : NULL 은 양쪽 모두 제외되어 동일 */
                 GROUP BY B.YYYYPW
                     , B.YYYYPW_SEQ
                     , B.PW_DAYS
                     , B.CELL_GROUP
                     , B.CELL_GROUP_YN  /* , OPERATION_GROUP */
                     , B.PRODUCT_LEVEL1
                     , B.MEASURE
                     , REPLACE(B.MEASURE, 'INV_', '')
               ) IA  /* 재고 */
             , (SELECT 'DIO_SALES' AS MEASURE, 'SALES' AS MEASURE_GROUP FROM DUAL UNION
                SELECT 'DIO_PACK' AS MEASURE, 'PACK' AS MEASURE_GROUP FROM DUAL UNION
                SELECT 'DIO_CELL' AS MEASURE, 'CELL' AS MEASURE_GROUP FROM DUAL
               ) IB
             , GT_GPWW_WW_DAYS_INFO A
             /* LEFT JOIN ( */
             , (SELECT C.YYYYPW  /* LEFT OUTER JOIN 에서 INNER JOIN 으로 변경 - 수량이 빠지는 부분이 없어 속도 개선위해 변경함 빠지는 부분이 있으면 추가 로직으로 보충해야 함. */
                     , C.YYYYPW_SEQ
                     , C.PW_DAYS
                     , C.CELL_GROUP
                     , C.CELL_GROUP_YN  /* , OPERATION_GROUP */
                     , C.PRODUCT_LEVEL1
                     , C.MEASURE
                     , REPLACE(C.MEASURE, 'RTF_', '') AS MEASURE_GROUP
                     , SUM(C.RTF_QTY) AS RTF_QTY
                     , SUM(C.RTF_NEXT_1) AS RTF_NEXT_1
                     , SUM(C.RTF_NEXT_2) AS RTF_NEXT_2
                     , SUM(C.RTF_NEXT_3) AS RTF_NEXT_3
                     , SUM(C.RTF_NEXT_4) AS RTF_NEXT_4
                     , SUM(C.RTF_NEXT_5) AS RTF_NEXT_5
                     , SUM(C.RTF_NEXT_6) AS RTF_NEXT_6
                     , SUM(C.RTF_NEXT_7) AS RTF_NEXT_7
                     , SUM(C.RTF_NEXT_8) AS RTF_NEXT_8
                     , SUM(C.RTF_NEXT_9) AS RTF_NEXT_9
                     , SUM(C.RTF_NEXT_10) AS RTF_NEXT_10
                     , SUM(C.RTF_NEXT_11) AS RTF_NEXT_11
                     , SUM(C.RTF_NEXT_12) AS RTF_NEXT_12
                     , SUM(C.RTF_NEXT_13) AS RTF_NEXT_13
                     , SUM(C.RTF_NEXT_14) AS RTF_NEXT_14
                     , SUM(C.RTF_NEXT_15) AS RTF_NEXT_15
                     , SUM(C.RTF_NEXT_16) AS RTF_NEXT_16
                     , SUM(C.RTF_NEXT_17) AS RTF_NEXT_17
                     , SUM(C.RTF_NEXT_18) AS RTF_NEXT_18
                     , SUM(C.RTF_NEXT_19) AS RTF_NEXT_19
                     , SUM(C.RTF_NEXT_20) AS RTF_NEXT_20
                     , SUM(C.RTF_NEXT_21) AS RTF_NEXT_21
                     , SUM(C.RTF_NEXT_22) AS RTF_NEXT_22
                     , SUM(C.RTF_NEXT_23) AS RTF_NEXT_23
                     , SUM(C.RTF_NEXT_24) AS RTF_NEXT_24
                     , SUM(C.RTF_NEXT_25) AS RTF_NEXT_25
                     , SUM(C.RTF_NEXT_26) AS RTF_NEXT_26
                     , SUM(C.RTF_NEXT_27) AS RTF_NEXT_27
                     , SUM(C.RTF_NEXT_28) AS RTF_NEXT_28
                     , SUM(C.RTF_NEXT_29) AS RTF_NEXT_29
                     , SUM(C.RTF_NEXT_30) AS RTF_NEXT_30
                     , SUM(C.RTF_NEXT_31) AS RTF_NEXT_31
                     , SUM(C.RTF_NEXT_32) AS RTF_NEXT_32
                     , SUM(C.RTF_NEXT_33) AS RTF_NEXT_33
                     , SUM(C.RTF_NEXT_34) AS RTF_NEXT_34
                     , SUM(C.RTF_NEXT_35) AS RTF_NEXT_35
                     , SUM(C.RTF_NEXT_36) AS RTF_NEXT_36
                     , SUM(C.RTF_NEXT_37) AS RTF_NEXT_37
                     , SUM(C.RTF_NEXT_38) AS RTF_NEXT_38
                     , SUM(C.RTF_NEXT_39) AS RTF_NEXT_39
                     , SUM(C.RTF_NEXT_40) AS RTF_NEXT_40
                     , SUM(C.RTF_NEXT_41) AS RTF_NEXT_41
                     , SUM(C.RTF_NEXT_42) AS RTF_NEXT_42
                     , SUM(C.RTF_NEXT_43) AS RTF_NEXT_43
                     , SUM(C.RTF_NEXT_44) AS RTF_NEXT_44
                     , SUM(C.RTF_NEXT_45) AS RTF_NEXT_45
                     , SUM(C.RTF_NEXT_46) AS RTF_NEXT_46
                     , SUM(C.RTF_NEXT_47) AS RTF_NEXT_47
                     , SUM(C.RTF_NEXT_48) AS RTF_NEXT_48
                     , SUM(C.RTF_NEXT_49) AS RTF_NEXT_49
                     , SUM(C.RTF_NEXT_50) AS RTF_NEXT_50
                     , SUM(C.RTF_NEXT_51) AS RTF_NEXT_51
                     , SUM(C.RTF_NEXT_52) AS RTF_NEXT_52
                     , SUM(C.RTF_NEXT_53) AS RTF_NEXT_53
                     , SUM(C.RTF_NEXT_54) AS RTF_NEXT_54
                     , SUM(C.RTF_NEXT_55) AS RTF_NEXT_55
                     , SUM(C.RTF_NEXT_56) AS RTF_NEXT_56
                     , SUM(C.RTF_NEXT_57) AS RTF_NEXT_57
                     , SUM(C.RTF_NEXT_58) AS RTF_NEXT_58
                     , SUM(C.RTF_NEXT_59) AS RTF_NEXT_59
                     , SUM(C.RTF_NEXT_60) AS RTF_NEXT_60
                     , SUM(C.RTF_NEXT_61) AS RTF_NEXT_61
                     , SUM(C.RTF_NEXT_62) AS RTF_NEXT_62
                     , SUM(C.RTF_NEXT_63) AS RTF_NEXT_63
                     , SUM(C.ACC_RTF_1) AS ACC_RTF_1
                     , SUM(C.ACC_RTF_2) AS ACC_RTF_2
                     , SUM(C.ACC_RTF_3) AS ACC_RTF_3
                     , SUM(C.ACC_RTF_4) AS ACC_RTF_4
                     , SUM(C.ACC_RTF_5) AS ACC_RTF_5
                     , SUM(C.ACC_RTF_6) AS ACC_RTF_6
                     , SUM(C.ACC_RTF_7) AS ACC_RTF_7
                     , SUM(C.ACC_RTF_8) AS ACC_RTF_8
                     , SUM(C.ACC_RTF_9) AS ACC_RTF_9
                     , SUM(C.ACC_RTF_10) AS ACC_RTF_10
                     , SUM(C.ACC_RTF_11) AS ACC_RTF_11
                     , SUM(C.ACC_RTF_12) AS ACC_RTF_12
                     , SUM(C.ACC_RTF_13) AS ACC_RTF_13
                     , SUM(C.ACC_RTF_14) AS ACC_RTF_14
                     , SUM(C.ACC_RTF_15) AS ACC_RTF_15
                     , SUM(C.ACC_RTF_16) AS ACC_RTF_16
                     , SUM(C.ACC_RTF_17) AS ACC_RTF_17
                     , SUM(C.ACC_RTF_18) AS ACC_RTF_18
                     , SUM(C.ACC_RTF_19) AS ACC_RTF_19
                     , SUM(C.ACC_RTF_20) AS ACC_RTF_20
                     , SUM(C.ACC_RTF_21) AS ACC_RTF_21
                     , SUM(C.ACC_RTF_22) AS ACC_RTF_22
                     , SUM(C.ACC_RTF_23) AS ACC_RTF_23
                     , SUM(C.ACC_RTF_24) AS ACC_RTF_24
                     , SUM(C.ACC_RTF_25) AS ACC_RTF_25
                     , SUM(C.ACC_RTF_26) AS ACC_RTF_26
                     , SUM(C.ACC_RTF_27) AS ACC_RTF_27
                     , SUM(C.ACC_RTF_28) AS ACC_RTF_28
                     , SUM(C.ACC_RTF_29) AS ACC_RTF_29
                     , SUM(C.ACC_RTF_30) AS ACC_RTF_30
                     , SUM(C.ACC_RTF_31) AS ACC_RTF_31
                     , SUM(C.ACC_RTF_32) AS ACC_RTF_32
                     , SUM(C.ACC_RTF_33) AS ACC_RTF_33
                     , SUM(C.ACC_RTF_34) AS ACC_RTF_34
                     , SUM(C.ACC_RTF_35) AS ACC_RTF_35
                     , SUM(C.ACC_RTF_36) AS ACC_RTF_36
                     , SUM(C.ACC_RTF_37) AS ACC_RTF_37
                     , SUM(C.ACC_RTF_38) AS ACC_RTF_38
                     , SUM(C.ACC_RTF_39) AS ACC_RTF_39
                     , SUM(C.ACC_RTF_40) AS ACC_RTF_40
                     , SUM(C.ACC_RTF_41) AS ACC_RTF_41
                     , SUM(C.ACC_RTF_42) AS ACC_RTF_42
                     , SUM(C.ACC_RTF_43) AS ACC_RTF_43
                     , SUM(C.ACC_RTF_44) AS ACC_RTF_44
                     , SUM(C.ACC_RTF_45) AS ACC_RTF_45
                     , SUM(C.ACC_RTF_46) AS ACC_RTF_46
                     , SUM(C.ACC_RTF_47) AS ACC_RTF_47
                     , SUM(C.ACC_RTF_48) AS ACC_RTF_48
                     , SUM(C.ACC_RTF_49) AS ACC_RTF_49
                     , SUM(C.ACC_RTF_50) AS ACC_RTF_50
                     , SUM(C.ACC_RTF_51) AS ACC_RTF_51
                     , SUM(C.ACC_RTF_52) AS ACC_RTF_52
                     , SUM(C.ACC_RTF_53) AS ACC_RTF_53
                     , SUM(C.ACC_RTF_54) AS ACC_RTF_54
                     , SUM(C.ACC_RTF_55) AS ACC_RTF_55
                     , SUM(C.ACC_RTF_56) AS ACC_RTF_56
                     , SUM(C.ACC_RTF_57) AS ACC_RTF_57
                     , SUM(C.ACC_RTF_58) AS ACC_RTF_58
                     , SUM(C.ACC_RTF_59) AS ACC_RTF_59
                     , SUM(C.ACC_RTF_60) AS ACC_RTF_60
                     , SUM(C.ACC_RTF_61) AS ACC_RTF_61
                     , SUM(C.ACC_RTF_62) AS ACC_RTF_62
                     , SUM(C.ACC_RTF_63) AS ACC_RTF_63
                  FROM GT_GPWW_RTF_FOR_DIO_DETAILREPORT C
                 GROUP BY C.YYYYPW
                     , C.YYYYPW_SEQ
                     , C.PW_DAYS
                     , C.CELL_GROUP
                     , C.CELL_GROUP_YN  /* , OPERATION_GROUP */
                     , C.PRODUCT_LEVEL1
                     , C.MEASURE
                     , REPLACE(C.MEASURE, 'RTF_', '')
               ) IC
         WHERE 1 = 1
           /* AND CL.MEASURE_GROUP = SUBSTRING(I.MEASURE, CHARINDEX('_', I.MEASURE) + 1, LEN(I.MEASURE)) */
           AND IB.MEASURE_GROUP    = IA.MEASURE_GROUP
           AND A.YYYYPW            = IA.YYYYPW
           AND IC.YYYYPW           = IA.YYYYPW
           AND IC.CELL_GROUP       = IA.CELL_GROUP
           AND IC.PRODUCT_LEVEL1   = IA.PRODUCT_LEVEL1
           /* AND R.OPERATION_GROUP    = I.OPERATION_GROUP */
           AND IC.MEASURE_GROUP    = IA.MEASURE_GROUP
           /* AND SUBSTRING(R.MEASURE, CHARINDEX('_', R.MEASURE) + 1, LEN(R.MEASURE)) = SUBSTRING(I.MEASURE, CHARINDEX('_', I.MEASURE) + 1, LEN(I.MEASURE)) */
           AND 1 = 1
           AND IA.MEASURE LIKE 'INV%'  /* 재고 */
           AND IA.QTY > 0
             ;


        /* PACK_DIO = PACK_DIO - SALES_DIO */
        MERGE INTO GT_GPWW_INVENTORY_DIO_DETAILREPORT A
        USING (SELECT B.YYYYPW
                    , B.CELL_GROUP
                    , B.MEASURE
                    , B.PRODUCT_LEVEL1
                    , CASE WHEN B.MEASURE = 'DIO_PACK' THEN B.DIO - C.DIO
                           ELSE B.DIO
                      END AS DIO_RESULT
                 FROM GT_GPWW_INVENTORY_DIO_DETAILREPORT B
                    , GT_GPWW_INVENTORY_DIO_DETAILREPORT C
                WHERE 1 = 1
                  AND C.YYYYPW(+)         = B.YYYYPW
                  AND C.CELL_GROUP(+)     = B.CELL_GROUP
                  AND C.PRODUCT_LEVEL1(+) = B.PRODUCT_LEVEL1
                  AND C.MEASURE(+)        = 'DIO_SALES'
                  AND C.PRODUCT_LEVEL2(+) = 'DIO'
                  AND B.MEASURE           = 'DIO_PACK'
                  AND B.PRODUCT_LEVEL2    = 'DIO'
              ) IA
           ON (    1 = 1
               AND A.YYYYPW         = IA.YYYYPW
               AND A.CELL_GROUP     = IA.CELL_GROUP
               AND A.PRODUCT_LEVEL1 = IA.PRODUCT_LEVEL1
               AND A.MEASURE        = IA.MEASURE
               AND A.MEASURE        = 'DIO_PACK'
               AND A.PRODUCT_LEVEL2 = 'DIO'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET A.DIO = CASE WHEN IA.DIO_RESULT < 0 THEN 0 ELSE IA.DIO_RESULT END;


        /* CELL_DIO = CELL_DIO - PACK_DIO - SALES_DIO (LV2) */
        /* ★원문 UPDATE 는 대상 행과 원천 행을 PRODUCT_LEVEL2 없이 연결 : 한 PRODUCT_LEVEL1 에 PRODUCT_LEVEL2 가 여럿이면
             MSSQL 은 임의의 원천 행 값으로 갱신(결과 미정), Oracle MERGE 는 ORA-30926 → 연결 조건에 PRODUCT_LEVEL2 를 더해 각 행 자기 값으로 갱신 */
        MERGE INTO GT_GPWW_INVENTORY_DIO_DETAILREPORT A
        USING (SELECT B.YYYYPW
                    , B.CELL_GROUP
                    , B.MEASURE
                    , B.PRODUCT_LEVEL1
                    , B.PRODUCT_LEVEL2
                    , CASE WHEN B.MEASURE = 'DIO_CELL' THEN B.DIO - D.DIO - C.DIO
                           ELSE B.DIO
                      END AS DIO_RESULT
                 FROM GT_GPWW_INVENTORY_DIO_DETAILREPORT B
                    , GT_GPWW_INVENTORY_DIO_DETAILREPORT C
                    , GT_GPWW_INVENTORY_DIO_DETAILREPORT D
                WHERE 1 = 1
                  AND C.YYYYPW(+)         = B.YYYYPW
                  AND C.CELL_GROUP(+)     = B.CELL_GROUP
                  AND C.PRODUCT_LEVEL1(+) = B.PRODUCT_LEVEL1
                  AND C.MEASURE(+)        = 'DIO_PACK'
                  AND C.PRODUCT_LEVEL2(+) = 'DIO'
                  AND D.YYYYPW(+)         = B.YYYYPW
                  AND D.CELL_GROUP(+)     = B.CELL_GROUP
                  AND D.PRODUCT_LEVEL1(+) = B.PRODUCT_LEVEL1
                  AND D.MEASURE(+)        = 'DIO_SALES'
                  AND D.PRODUCT_LEVEL2(+) = 'DIO'
                  AND B.MEASURE           = 'DIO_CELL'
                  AND B.PRODUCT_LEVEL2   != 'DIO'
              ) IA
           ON (    1 = 1
               AND A.YYYYPW         = IA.YYYYPW
               AND A.CELL_GROUP     = IA.CELL_GROUP
               AND A.MEASURE        = IA.MEASURE
               AND A.PRODUCT_LEVEL1 = IA.PRODUCT_LEVEL1
               AND A.PRODUCT_LEVEL2 = IA.PRODUCT_LEVEL2
               AND A.MEASURE        = 'DIO_CELL'
               AND A.PRODUCT_LEVEL2 != 'DIO'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET A.DIO = CASE WHEN IA.DIO_RESULT < 0 THEN 0 ELSE IA.DIO_RESULT END;

        /* CELL_DIO = CELL_DIO - PACK_DIO - SALES_DIO (LV1) */
        MERGE INTO GT_GPWW_INVENTORY_DIO_DETAILREPORT A
        USING (SELECT B.YYYYPW
                    , B.CELL_GROUP
                    , B.MEASURE
                    , B.PRODUCT_LEVEL1
                    , CASE WHEN B.MEASURE = 'DIO_CELL' THEN B.DIO - D.DIO - C.DIO
                           ELSE B.DIO
                      END AS DIO_RESULT
                 FROM GT_GPWW_INVENTORY_DIO_DETAILREPORT B
                    , GT_GPWW_INVENTORY_DIO_DETAILREPORT C
                    , GT_GPWW_INVENTORY_DIO_DETAILREPORT D
                WHERE 1 = 1
                  AND C.YYYYPW(+)         = B.YYYYPW
                  AND C.CELL_GROUP(+)     = B.CELL_GROUP
                  AND C.PRODUCT_LEVEL1(+) = B.PRODUCT_LEVEL1
                  AND C.MEASURE(+)        = 'DIO_PACK'
                  AND C.PRODUCT_LEVEL2(+) = 'DIO'
                  AND D.YYYYPW(+)         = B.YYYYPW
                  AND D.CELL_GROUP(+)     = B.CELL_GROUP
                  AND D.PRODUCT_LEVEL1(+) = B.PRODUCT_LEVEL1
                  AND D.MEASURE(+)        = 'DIO_SALES'
                  AND D.PRODUCT_LEVEL2(+) = 'DIO'
                  AND B.MEASURE           = 'DIO_CELL'
                  AND B.PRODUCT_LEVEL2    = 'DIO'
              ) IA
           ON (    1 = 1
               AND A.YYYYPW         = IA.YYYYPW
               AND A.CELL_GROUP     = IA.CELL_GROUP
               AND A.MEASURE        = IA.MEASURE
               AND A.PRODUCT_LEVEL1 = IA.PRODUCT_LEVEL1
               AND A.MEASURE        = 'DIO_CELL'
               AND A.PRODUCT_LEVEL2 = 'DIO'
              )
         WHEN MATCHED THEN
              UPDATE
                 SET A.DIO = CASE WHEN IA.DIO_RESULT < 0 THEN 0 ELSE IA.DIO_RESULT END;

    /* ----- End DIO 계산 =============================================================================================================================== */

    /* --- Begin Tran : 월별 Global PSI 본테이블에 Delete/Insert=============================================================================================================================== */
        /* BEGIN TRAN   --- transaction 시작 (Oracle : 문장 개시로 트랜잭션 시작, 아래 COMMIT 으로 종료) */

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DELETE FROM SCP_RPT_GLOBAL_PSI_MD_WW  ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM SCP_RPT_GLOBAL_PSI_MD_WW
         WHERE PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND DIVISION_ID         = V_DIVISION_ID
           AND PLAN_TYPE           = V_PLAN_TYPE;   /* E20260708-000926 */

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### INSERT INTO SCP_RPT_GLOBAL_PSI_MD_WW  ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        /* 결과 테이블 NOT NULL 문자 칸 : AS-IS 빈 문자열('')은 Oracle 에서 NULL 이 되므로 이관 채움값 '-' 로 적재 (NVL(…, '-')) */
        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_WW
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , REP_CELL_ITEM_ID
             , CELL_GROUP
             , QTY
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , CELL_CF
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE10 )
        SELECT V_PLAN_START_YYYYMMDD                AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID                        AS DIVISION_ID
             , V_PLAN_TYPE                          AS PLAN_TYPE   /* E20260708-000926 */
             , IA.YYYYPW
             , NVL(IA.ITEM_ID, '-')                 AS ITEM_ID
             , NVL(IA.MEASURE, '-')                 AS MEASURE
             , NVL(IA.FROM_SITE, '-')               AS FROM_SITE
             , NVL(IA.TO_SITE, '-')                 AS TO_SITE
             , NVL(IA.INCOTERMS, '-')               AS INCOTERMS
             , NVL(IA.VARIOUS_KEY, '-')             AS VARIOUS_KEY
             , NVL(IA.OPERATION_GROUP, '-')         AS OPERATION_GROUP
             , NVL(IA.REP_CELL_ITEM_ID, '-')        AS REP_CELL_ITEM_ID
             , NVL(IA.CELL_GROUP, '-')              AS CELL_GROUP
             , IA.QTY
             , IA.FROM_BOH_QTY
             , IA.TO_BOH_QTY
             , IA.CELL_CF
             , V_BATCH_USER                         AS CREATED_BY
             , SYSDATE                              AS CREATION_DATE
             , V_BATCH_USER                         AS LAST_UPDATED_BY
             , SYSDATE                              AS LAST_UPDATE_DATE
             , IA.ATTRIBUTE1
             , IA.ATTRIBUTE2
             , IA.ATTRIBUTE3
             , IA.ATTRIBUTE10
          FROM (SELECT A.YYYYPW
                     , CASE WHEN A.ITEM_ID LIKE 'AMDAU%' AND B.PACK_MODULE_ITEM = 'Y' THEN B.MODEL_ID   /* --@@@ P5200 */
                            WHEN A.ITEM_ID LIKE 'AMDAU%' AND B.PACK_MODULE_ITEM = 'N' THEN A.REP_CELL_ITEM_ID
                            ELSE A.ITEM_ID
                       END                              AS ITEM_ID   /* 2024.01.26 AMDAU% 모듈 코드 셀로 치환 적재 */
                     , CASE WHEN A.ITEM_ID LIKE 'AMDAU%' AND A.MEASURE = 'PACK_EOH' AND B.PACK_MODULE_ITEM = 'Y' THEN 'PACK_EOH'   /* --@@@ P5200 */
                            WHEN A.ITEM_ID LIKE 'AMDAU%' AND A.MEASURE = 'PACK_EOH' AND B.PACK_MODULE_ITEM = 'N' THEN 'PACK_CELL_EOH'
                            ELSE A.MEASURE
                       END                              AS MEASURE
                     , A.FROM_SITE
                     , A.TO_SITE
                     , A.INCOTERMS
                     , A.VARIOUS_KEY
                     , CASE WHEN A.ITEM_ID LIKE 'AMDAU%' AND A.MEASURE = 'PACK_EOH' AND B.PACK_MODULE_ITEM = 'N'
                            THEN 'A'
                            ELSE A.OPERATION_GROUP
                       END                              AS OPERATION_GROUP
                     , MAX(A.REP_CELL_ITEM_ID) KEEP (DENSE_RANK LAST ORDER BY UPPER(TRANSLATE(A.REP_CELL_ITEM_ID, '_-', '/')) NULLS FIRST, A.REP_CELL_ITEM_ID NULLS FIRST)   AS REP_CELL_ITEM_ID   /* MSSQL Latin1_General_CI_AS 비교 재현(대소문자·하이픈 무시, 밑줄은 글자·숫자 앞) */
                                                          /* 2025.05.28 kimcd primary key 오류 처리 */
                     , MAX(A.CELL_GROUP) KEEP (DENSE_RANK LAST ORDER BY UPPER(TRANSLATE(A.CELL_GROUP, '_-', '/')) NULLS FIRST, A.CELL_GROUP NULLS FIRST)   AS CELL_GROUP
                                                                /* 2025.05.28 kimcd primary key 오류 처리 */
                       /* Pack Item 으로 변경되더라도 Cell 환산해 준다. */
                       /*
			   ,SUM(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN GP.CELL_CF * GP.QTY
						 ELSE GP.QTY
					END)  AS QTY
			   ,SUM(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN GP.CELL_CF * GP.FROM_BOH_QTY
						 ELSE GP.FROM_BOH_QTY
					END)  AS FROM_BOH_QTY
			   ,SUM(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN GP.CELL_CF * GP.TO_BOH_QTY
						 ELSE GP.TO_BOH_QTY
					END)  AS TO_BOH_QTY
			*/
                     , SUM(CASE WHEN A.ITEM_ID LIKE 'AMDAU%' AND B.PACK_MODULE_ITEM = 'Y' AND A.MEASURE = 'PACK_EOH' THEN A.QTY   /* --@@@ P5200 */
                                WHEN A.ITEM_ID LIKE 'AMDAU%' THEN A.CELL_CF * A.QTY
                                ELSE A.QTY
                           END)                         AS QTY
                     , SUM(CASE WHEN A.ITEM_ID LIKE 'AMDAU%' AND B.PACK_MODULE_ITEM = 'Y' AND A.MEASURE = 'PACK_EOH' THEN A.FROM_BOH_QTY   /* --@@@ P5200 */
                                WHEN A.ITEM_ID LIKE 'AMDAU%' THEN A.CELL_CF * A.FROM_BOH_QTY
                                ELSE A.FROM_BOH_QTY
                           END)                         AS FROM_BOH_QTY
                     , SUM(CASE WHEN A.ITEM_ID LIKE 'AMDAU%' AND B.PACK_MODULE_ITEM = 'Y' AND A.MEASURE = 'PACK_EOH' THEN A.TO_BOH_QTY   /* --@@@ P5200 */
                                WHEN A.ITEM_ID LIKE 'AMDAU%' THEN A.CELL_CF * A.TO_BOH_QTY
                                ELSE A.TO_BOH_QTY
                           END)                         AS TO_BOH_QTY

                     , MAX(CASE WHEN A.ITEM_ID LIKE 'AMDAU%' AND B.PACK_MODULE_ITEM = 'Y' AND A.MEASURE = 'PACK_EOH' THEN A.CELL_CF
                                WHEN A.ITEM_ID LIKE 'AMDAU%' THEN 1
                                ELSE A.CELL_CF
                           END)                         AS CELL_CF   /* 2025.05.28 kimcd primary key 오류 처리 */
                       /* 원문 CONVERT(NVARCHAR(150), decimal(20,10)) : 소수 10자리 고정 문자 (예 0.0000000000) */
                     , MAX(CASE WHEN A.ITEM_ID LIKE 'AMDAU%' THEN TO_CHAR(A.QTY, 'FM99999999999999999990.0000000000')     ELSE NULL END)   AS ATTRIBUTE1
                     , MAX(CASE WHEN A.ITEM_ID LIKE 'AMDAU%' THEN TO_CHAR(A.CELL_CF, 'FM99999999999999999990.0000000000') ELSE NULL END)   AS ATTRIBUTE2
                     , MAX(CASE WHEN D.OPERATION_ID IS NOT NULL THEN NVL(C.CELL_MODEL_ID, A.ITEM_ID) ELSE NVL(B.MODEL_ID, A.ITEM_ID) END)   AS ATTRIBUTE3   /* [PJ20257329] Cell 완성 공정 하드 코딩 변경 */
                       /* [PJ20257329] 변경전 ,MAX( CASE WHEN FI.FLOW_ID IN ('A9000','A3000') THEN ISNULL(FI.CELL_MODEL_ID, GP.ITEM_ID) ELSE ISNULL(MM.MODEL_ID, GP.ITEM_ID) END )	AS ATTRIBUTE3 */
                     , MAX(A.CELL_GROUP_YN)             AS ATTRIBUTE10   /* 20240311 */
                  FROM GT_GPWW_SCP_RPT_GLOBAL_PSI_MD_WW  A
                     , GT_GPWW_MODULE_MODEL_INFO         B   /* AMDAU 상위 모델 정보 */
                     , GT_GPWW_SCP_MST_FINAL_ITEM        C   /* AA~ Assy item 의 Group Code Mapping 이 안되어 추가 */
                       /* [PJ20257329] Cell 완성 공정 하드 코딩 변경 - Start */
                     , GT_GPWW_SCP_CELL_FINAL_OPERATION  D
                       /* [PJ20257329] Cell 완성 공정 하드 코딩 변경 - End */
                 WHERE 1=1
                   AND B.MODULE_ID(+)    = A.ITEM_ID
                   AND C.ITEM_ID(+)      = A.ITEM_ID
                   AND D.OPERATION_ID(+) = C.FLOW_ID   /* [PJ20257329] Cell 완성 공정 하드 코딩 변경 */
                   AND A.MEASURE        != 'ENDING_INV_FOR_DIO'
                 GROUP BY A.YYYYPW
                        , CASE WHEN A.ITEM_ID LIKE 'AMDAU%' AND B.PACK_MODULE_ITEM = 'Y' THEN B.MODEL_ID   /* --@@@ P5200 */
                               WHEN A.ITEM_ID LIKE 'AMDAU%' AND B.PACK_MODULE_ITEM = 'N' THEN A.REP_CELL_ITEM_ID
                               ELSE A.ITEM_ID
                          END
                        , CASE WHEN A.ITEM_ID LIKE 'AMDAU%' AND A.MEASURE = 'PACK_EOH' AND B.PACK_MODULE_ITEM = 'Y' THEN 'PACK_EOH'   /* --@@@ P5200 */
                               WHEN A.ITEM_ID LIKE 'AMDAU%' AND A.MEASURE = 'PACK_EOH' AND B.PACK_MODULE_ITEM = 'N' THEN 'PACK_CELL_EOH'
                               ELSE A.MEASURE
                          END
                        , A.FROM_SITE
                        , A.TO_SITE
                        , A.INCOTERMS
                        , A.VARIOUS_KEY
                        , CASE WHEN A.ITEM_ID LIKE 'AMDAU%' AND A.MEASURE = 'PACK_EOH' AND B.PACK_MODULE_ITEM = 'N'
                               THEN 'A'
                               ELSE A.OPERATION_GROUP
                          END
                          /* ,GP.REP_CELL_ITEM_ID -- 2025.05.28 kimcd primary key 오류 처리 */
                          /* ,GP.CELL_GROUP       -- 2025.05.28 kimcd primary key 오류 처리 */
                          /* ,CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'Y' AND GP.MEASURE = 'PACK_EOH' THEN GP.CELL_CF */
                          /* 	 WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN 1 */
                          /* 	 ELSE GP.CELL_CF */
                          /* END   -- 2025.05.28 kimcd primary key 오류 처리 */
               ) IA;



        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_WW
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , REP_CELL_ITEM_ID
             , CELL_GROUP
             , QTY
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , CELL_CF
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE10 )
        SELECT PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE              AS PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , CELL_GROUP             AS ITEM_ID
             , 'TOT_INV'              AS MEASURE
             , '-'                    AS FROM_SITE
             , '-'                    AS TO_SITE
             , '-'                    AS INCOTERMS
             , '-'                    AS VARIOUS_KEY
             , '-'                    AS OPERATION_GROUP
             , '-'                    AS REP_CELL_ITEM_ID
             , CELL_GROUP
             , SUM(CASE WHEN MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH', 'AS_INV', 'MISMATCH_INV') THEN QTY * CELL_CF ELSE QTY END)   AS QTY
             , 0                      AS FROM_BOH_QTY
             , 0                      AS TO_BOH_QTY
             , 1.0                    AS CELL_CF
             , V_BATCH_USER           AS CREATED_BY
             , SYSDATE                AS CREATION_DATE
             , V_BATCH_USER           AS LAST_UPDATED_BY
             , SYSDATE                AS LAST_UPDATE_DATE
             , 'Y'                    AS ATTRIBUTE10
          FROM SCP_RPT_GLOBAL_PSI_MD_WW
         WHERE 1=1
           /* E20251028-000389 TOT_INV 에 미매핑 데이터 추가반영.(MISMATCH_INV) */
           AND MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH', 'PACK_CELL_EOH', 'SEMI_INTRANSIT', 'CELL_EOH', 'CELL_CHAR_AVAILABLE', 'CELL_FORM_PROGRESS', 'AS_INV', 'MISMATCH_INV')
           AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND DIVISION_ID         = V_DIVISION_ID
           AND PLAN_TYPE           = V_PLAN_TYPE   /* E20260708-000926 */
         GROUP BY PLAN_START_YYYYMMDD
                , DIVISION_ID
                , PLAN_TYPE
                , YYYYPW
                , CELL_GROUP;
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### INSERT INTO SCP_RPT_GLOBAL_PSI_MD_WW (DIO) ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        /* 원문 CONVERT(NVARCHAR(300), decimal) : INV_QTY·RTF_QTY 는 소수 6자리 고정 문자(예 0.000000), PW_DAYS 는 정수 문자 */
        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_WW
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , REP_CELL_ITEM_ID
             , CELL_GROUP
             , QTY
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , CELL_CF
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE10 )
        SELECT V_PLAN_START_YYYYMMDD                                               AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID                                                       AS DIVISION_ID
             , V_PLAN_TYPE                                                         AS PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , NVL(CELL_GROUP, '-')                                                AS ITEM_ID
             , 'DIO'                                                               AS MEASURE
             , '-'                                                                 AS FROM_SITE
             , '-'                                                                 AS TO_SITE
             , '-'                                                                 AS INCOTERMS
             , '-'                                                                 AS VARIOUS_KEY
             , NVL(OPERATION_GROUP, '-')                                           AS OPERATION_GROUP
             , '-'                                                                 AS REP_CELL_ITEM_ID
             , NVL(CELL_GROUP, '-')                                                AS CELL_GROUP
             , CASE WHEN DIO > 365
                    THEN 365
                    ELSE DIO
               END                                                                 AS QTY
             , 0.0                                                                 AS FROM_BOH_QTY
             , 0.0                                                                 AS TO_BOH_QTY
             , 1.0                                                                 AS CELL_CF
             , V_BATCH_USER                                                        AS CREATED_BY
             , SYSDATE                                                             AS CREATION_DATE
             , V_BATCH_USER                                                        AS LAST_UPDATED_BY
             , SYSDATE                                                             AS LAST_UPDATE_DATE
             , TO_CHAR(NVL(INV_QTY, 0.0), 'FM99999999999999999990.000000')         AS ATTRIBUTE1
             , TO_CHAR(NVL(RTF_QTY, 0.0), 'FM99999999999999999990.000000')         AS ATTRIBUTE2
             , TO_CHAR(NVL(PW_DAYS, 0.0))                                          AS ATTRIBUTE3
             , CELL_GROUP_YN                                                       AS ATTRIBUTE10
          FROM GT_GPWW_INVENTORY_DIO
         WHERE 1=1;

        /* Standard DIO 추가(임시) */
        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_WW
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , REP_CELL_ITEM_ID
             , CELL_GROUP
             , QTY
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , CELL_CF
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE10 )
        SELECT V_PLAN_START_YYYYMMDD                                               AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID                                                       AS DIVISION_ID
             , V_PLAN_TYPE                                                         AS PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , NVL(CELL_GROUP, '-')                                                AS ITEM_ID
             , 'STD_DIO'                                                           AS MEASURE
             , '-'                                                                 AS FROM_SITE
             , '-'                                                                 AS TO_SITE
             , '-'                                                                 AS INCOTERMS
             , '-'                                                                 AS VARIOUS_KEY
             , NVL(OPERATION_GROUP, '-')                                           AS OPERATION_GROUP
             , '-'                                                                 AS REP_CELL_ITEM_ID
             , NVL(CELL_GROUP, '-')                                                AS CELL_GROUP
             , CASE WHEN DIO > 365
                    THEN 365
                    ELSE DIO
               END                                                                 AS QTY
             , 0.0                                                                 AS FROM_BOH_QTY
             , 0.0                                                                 AS TO_BOH_QTY
             , 1.0                                                                 AS CELL_CF
             , V_BATCH_USER                                                        AS CREATED_BY
             , SYSDATE                                                             AS CREATION_DATE
             , V_BATCH_USER                                                        AS LAST_UPDATED_BY
             , SYSDATE                                                             AS LAST_UPDATE_DATE
             , TO_CHAR(NVL(INV_QTY, 0.0), 'FM99999999999999999990.000000')         AS ATTRIBUTE1
             , TO_CHAR(NVL(RTF_QTY, 0.0), 'FM99999999999999999990.000000')         AS ATTRIBUTE2
             , TO_CHAR(NVL(PW_DAYS, 0.0))                                          AS ATTRIBUTE3
             , CELL_GROUP_YN                                                       AS ATTRIBUTE10
          FROM GT_GPWW_INVENTORY_DIO
         WHERE 1=1;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### INSERT INTO SCP_RPT_GLOBAL_PSI_MD_WW (DIO)(표준레포트) ');   /* --@@@ */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_WW
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , REP_CELL_ITEM_ID
             , CELL_GROUP
             , QTY
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , CELL_CF
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE10 )
        SELECT V_PLAN_START_YYYYMMDD                                               AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID                                                       AS DIVISION_ID
             , V_PLAN_TYPE                                                         AS PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , NVL(CELL_GROUP, '-')                                                AS ITEM_ID
             , NVL(MEASURE, '-')                                                   AS MEASURE
             , '-'                                                                 AS FROM_SITE
             , '-'                                                                 AS TO_SITE
             , '-'                                                                 AS INCOTERMS
             , '-'                                                                 AS VARIOUS_KEY
             , NVL(OPERATION_GROUP, '-')                                           AS OPERATION_GROUP
             , '-'                                                                 AS REP_CELL_ITEM_ID
             , NVL(CELL_GROUP, '-')                                                AS CELL_GROUP
             , CASE WHEN NVL(DIO, 0) > 365
                    THEN 365
                    ELSE NVL(DIO, 0)
               END                                                                 AS QTY
             , 0.0                                                                 AS FROM_BOH_QTY
             , 0.0                                                                 AS TO_BOH_QTY
             , 1.0                                                                 AS CELL_CF
             , V_BATCH_USER                                                        AS CREATED_BY
             , SYSDATE                                                             AS CREATION_DATE
             , V_BATCH_USER                                                        AS LAST_UPDATED_BY
             , SYSDATE                                                             AS LAST_UPDATE_DATE
             , TO_CHAR(NVL(INV_QTY, 0.0), 'FM99999999999999999990.000000')         AS ATTRIBUTE1
             , TO_CHAR(NVL(RTF_QTY, 0.0), 'FM99999999999999999990.000000')         AS ATTRIBUTE2
             , TO_CHAR(NVL(PW_DAYS, 0.0))                                          AS ATTRIBUTE3
             , CELL_GROUP_YN                                                       AS ATTRIBUTE10
          FROM GT_GPWW_INVENTORY_DIO_CELLGROUP
         WHERE 1=1;

        /* Standard DIO 추가(임시) */
        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_WW
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , REP_CELL_ITEM_ID
             , CELL_GROUP
             , QTY
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , CELL_CF
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE10 )
        SELECT V_PLAN_START_YYYYMMDD                                               AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID                                                       AS DIVISION_ID
             , V_PLAN_TYPE                                                         AS PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , NVL(CELL_GROUP, '-')                                                AS ITEM_ID
             , 'STD_' || MEASURE                                                   AS MEASURE
             , '-'                                                                 AS FROM_SITE
             , '-'                                                                 AS TO_SITE
             , '-'                                                                 AS INCOTERMS
             , '-'                                                                 AS VARIOUS_KEY
             , NVL(OPERATION_GROUP, '-')                                           AS OPERATION_GROUP
             , '-'                                                                 AS REP_CELL_ITEM_ID
             , NVL(CELL_GROUP, '-')                                                AS CELL_GROUP
             , CASE WHEN NVL(DIO, 0) > 365
                    THEN 365
                    ELSE NVL(DIO, 0)
               END                                                                 AS QTY
             , 0.0                                                                 AS FROM_BOH_QTY
             , 0.0                                                                 AS TO_BOH_QTY
             , 1.0                                                                 AS CELL_CF
             , V_BATCH_USER                                                        AS CREATED_BY
             , SYSDATE                                                             AS CREATION_DATE
             , V_BATCH_USER                                                        AS LAST_UPDATED_BY
             , SYSDATE                                                             AS LAST_UPDATE_DATE
             , TO_CHAR(NVL(INV_QTY, 0.0), 'FM99999999999999999990.000000')         AS ATTRIBUTE1
             , TO_CHAR(NVL(RTF_QTY, 0.0), 'FM99999999999999999990.000000')         AS ATTRIBUTE2
             , TO_CHAR(NVL(PW_DAYS, 0.0))                                          AS ATTRIBUTE3
             , CELL_GROUP_YN                                                       AS ATTRIBUTE10
          FROM GT_GPWW_INVENTORY_DIO_CELLGROUP
         WHERE 1=1;


        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### INSERT INTO SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW (DIO) (Detail 표준레포트) ');   /* --@@@ */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */

        DELETE
          FROM SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW
         WHERE PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND DIVISION_ID         = V_DIVISION_ID
           AND PLAN_TYPE           = V_PLAN_TYPE;   /* E20260708-000926 */

        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , REP_CELL_ITEM_ID
             , CELL_GROUP
             , PRODUCT_LEVEL1
             , PRODUCT_LEVEL2
             , PRODUCT_LEVEL3
             , QTY
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , CELL_CF
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE10
             , ATTRIBUTE9 )
        SELECT V_PLAN_START_YYYYMMDD                                               AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID                                                       AS DIVISION_ID
             , V_PLAN_TYPE                                                         AS PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , NVL(CELL_GROUP, '-')                                                AS ITEM_ID
             , NVL(MEASURE, '-')                                                   AS MEASURE
             , '-'                                                                 AS FROM_SITE
             , '-'                                                                 AS TO_SITE
             , '-'                                                                 AS INCOTERMS
             , '-'                                                                 AS VARIOUS_KEY
             , NVL(CASE WHEN ATTRIBUTE9 = 'LV1' THEN (CASE WHEN REPLACE(MEASURE, 'DIO_', '') = 'SALES' THEN 'Sales' || ' DIO'
                                                          WHEN REPLACE(MEASURE, 'DIO_', '') = 'PACK'  THEN 'Pack' || ' DIO'
                                                          WHEN REPLACE(MEASURE, 'DIO_', '') = 'CELL'  THEN 'Cell' || ' DIO'
                                                     END)
                        ELSE OPERATION_GROUP
                   END, '-')                                                       AS OPERATION_GROUP
             , '-'                                                                 AS REP_CELL_ITEM_ID
             , NVL(CELL_GROUP, '-')                                                AS CELL_GROUP
             , NVL(PRODUCT_LEVEL1, '-')                                            AS PRODUCT_LEVEL1
             , NVL(PRODUCT_LEVEL2, '-')                                            AS PRODUCT_LEVEL2
             , '-'                                                                 AS PRODUCT_LEVEL3
             , CASE WHEN NVL(DIO, 0) > 365
                    THEN 365
                    ELSE NVL(DIO, 0)
               END                                                                 AS QTY
             , 0.0                                                                 AS FROM_BOH_QTY
             , 0.0                                                                 AS TO_BOH_QTY
             , 1.0                                                                 AS CELL_CF
             , V_BATCH_USER                                                        AS CREATED_BY
             , SYSDATE                                                             AS CREATION_DATE
             , V_BATCH_USER                                                        AS LAST_UPDATED_BY
             , SYSDATE                                                             AS LAST_UPDATE_DATE
             , TO_CHAR(NVL(INV_QTY, 0.0), 'FM99999999999999999990.000000')         AS ATTRIBUTE1
             , TO_CHAR(NVL(RTF_QTY, 0.0), 'FM99999999999999999990.000000')         AS ATTRIBUTE2
             , TO_CHAR(NVL(PW_DAYS, 0.0))                                          AS ATTRIBUTE3
             , CELL_GROUP_YN                                                       AS ATTRIBUTE10
             , ATTRIBUTE9
          FROM GT_GPWW_INVENTORY_DIO_DETAILREPORT
         WHERE 1=1
           AND (PRODUCT_LEVEL1 <> '-' OR PRODUCT_LEVEL1 IS NULL);   /* 원문 DO.PRODUCT_LEVEL1 <> '-' : AS-IS 빈 문자열('') 행도 포함되므로 NULL 포함 */
           /* -- AND DO.PRODUCT_LEVEL2 != 'DIO' */

        /* Standard DIO 추가(임시) */
        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , REP_CELL_ITEM_ID
             , CELL_GROUP
             , PRODUCT_LEVEL1
             , PRODUCT_LEVEL2
             , PRODUCT_LEVEL3
             , QTY
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , CELL_CF
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE10
             , ATTRIBUTE9 )
        SELECT V_PLAN_START_YYYYMMDD                                               AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID                                                       AS DIVISION_ID
             , V_PLAN_TYPE                                                         AS PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , NVL(CELL_GROUP, '-')                                                AS ITEM_ID
             , 'STD_' || MEASURE                                                   AS MEASURE
             , '-'                                                                 AS FROM_SITE
             , '-'                                                                 AS TO_SITE
             , '-'                                                                 AS INCOTERMS
             , '-'                                                                 AS VARIOUS_KEY
             , NVL(CASE WHEN ATTRIBUTE9 = 'LV1' THEN (CASE WHEN REPLACE(MEASURE, 'DIO_', '') = 'SALES' THEN 'Sales' || ' DIO'
                                                          WHEN REPLACE(MEASURE, 'DIO_', '') = 'PACK'  THEN 'Pack' || ' DIO'
                                                          WHEN REPLACE(MEASURE, 'DIO_', '') = 'CELL'  THEN 'Cell' || ' DIO'
                                                     END)
                        ELSE OPERATION_GROUP
                   END, '-')                                                       AS OPERATION_GROUP
             , '-'                                                                 AS REP_CELL_ITEM_ID
             , NVL(CELL_GROUP, '-')                                                AS CELL_GROUP
             , NVL(PRODUCT_LEVEL1, '-')                                            AS PRODUCT_LEVEL1
             , NVL(PRODUCT_LEVEL2, '-')                                            AS PRODUCT_LEVEL2
             , '-'                                                                 AS PRODUCT_LEVEL3
             , CASE WHEN NVL(DIO, 0) > 365
                    THEN 365
                    ELSE NVL(DIO, 0)
               END                                                                 AS QTY
             , 0.0                                                                 AS FROM_BOH_QTY
             , 0.0                                                                 AS TO_BOH_QTY
             , 1.0                                                                 AS CELL_CF
             , V_BATCH_USER                                                        AS CREATED_BY
             , SYSDATE                                                             AS CREATION_DATE
             , V_BATCH_USER                                                        AS LAST_UPDATED_BY
             , SYSDATE                                                             AS LAST_UPDATE_DATE
             , TO_CHAR(NVL(INV_QTY, 0.0), 'FM99999999999999999990.000000')         AS ATTRIBUTE1
             , TO_CHAR(NVL(RTF_QTY, 0.0), 'FM99999999999999999990.000000')         AS ATTRIBUTE2
             , TO_CHAR(NVL(PW_DAYS, 0.0))                                          AS ATTRIBUTE3
             , CELL_GROUP_YN                                                       AS ATTRIBUTE10
             , ATTRIBUTE9
          FROM GT_GPWW_INVENTORY_DIO_DETAILREPORT
         WHERE 1=1
           AND (PRODUCT_LEVEL1 <> '-' OR PRODUCT_LEVEL1 IS NULL);   /* 원문 DO.PRODUCT_LEVEL1 <> '-' : AS-IS 빈 문자열('') 행도 포함되므로 NULL 포함 */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### INSERT INTO SCP_RPT_GLOBAL_PSI_MD_MM (FP Aging Stock : Form Progress ) ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_WW
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE   /* E20260708-000926 */
             , YYYYPW
             , ITEM_ID
             , MEASURE
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , VARIOUS_KEY
             , OPERATION_GROUP
             , REP_CELL_ITEM_ID
             , CELL_GROUP
             , QTY
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , CELL_CF
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2 )
        SELECT '00000000'                                                               AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID                                                            AS DIVISION_ID
             , 'FN'                                                                     AS PLAN_TYPE   /* E20260708-000926 'FN' 고정' */
             , A.YYYYPW
             , NVL(A.ITEM_ID, '-')                                                      AS ITEM_ID
             , 'FORM_PROGRESS'                                                          AS MEASURE
             , NVL(A.FROM_SITE, '-')                                                    AS FROM_SITE
             , '-'                                                                      AS TO_SITE
             , '-'                                                                      AS INCOTERMS
             , NVL(TO_CHAR(A.CUTOFF_DATE, 'YYYYMMDD'), '-')                             AS VARIOUS_KEY
             , '-'                                                                      AS OPERATION_GROUP
             , '-'                                                                      AS REP_CELL_ITEM_ID
             , '-'                                                                      AS CELL_GROUP
             , A.FP_FORM_PROGRESS                                                       AS QTY
             , 0                                                                        AS FROM_BOH_QTY
             , 0                                                                        AS TO_BOH_QTY
             , 0                                                                        AS CELL_CF
             , 'scm_batch'                                                              AS CREATED_BY
             , SYSDATE                                                                  AS CREATION_DATE
             , 'scm_batch'                                                              AS LAST_UPDATED_BY
             , SYSDATE                                                                  AS LAST_UPDATE_DATE
             , TO_CHAR(A.FP_CHAR_AVAILABLE, 'FM99999999999999999990.0000000000')        AS ATTRIBUTE1   /* 원문 CONVERT(NVARCHAR(50), decimal(20,10)) */
             , TO_CHAR(A.FP_AGING_TOTAL, 'FM99999999999999999990.0000000000')           AS ATTRIBUTE2
          FROM GT_GPWW_FP_AGING_STOCK A
         WHERE 1=1
           AND NOT EXISTS (SELECT 1
                             FROM SCP_RPT_GLOBAL_PSI_MD_WW SA
                            WHERE 1=1
                              AND SA.YYYYPW              = A.YYYYPW
                              AND SA.FROM_SITE           = A.FROM_SITE
                              AND SA.ITEM_ID             = A.ITEM_ID
                              AND SA.PLAN_START_YYYYMMDD = '00000000'
                              AND SA.PLAN_TYPE           = 'FN'   /* E20260708-000926 FN 고정. */
                              AND SA.MEASURE             = 'FORM_PROGRESS'
                              AND SA.DIVISION_ID         = V_DIVISION_ID)
           AND A.DIV = 'A';

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### SORT ORDER 조정 ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */

        UPDATE SCP_RPT_GLOBAL_PSI_MD_WW
           SET ATTRIBUTE8 = NULL
         WHERE 1=1
           AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND DIVISION_ID         = V_DIVISION_ID;


        UPDATE SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW
           SET ATTRIBUTE8 = NULL
         WHERE 1=1
           AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND DIVISION_ID         = V_DIVISION_ID;


        /* ORDER BY 추가 */
        MERGE
         INTO SCP_RPT_GLOBAL_PSI_MD_WW A
        USING (SELECT DENSE_RANK() OVER (PARTITION BY IB.PLAN_START_YYYYMMDD
                                                    , IB.DIVISION_ID
                                                    , IB.PLAN_TYPE   /* E20260708-000926 */
                                             ORDER BY IB.SUM_QTY DESC NULLS LAST
                                                    , UPPER(TRANSLATE(IB.CELL_GROUP, '_-', '/')) NULLS FIRST   /* MSSQL Latin1_General_CI_AS 정렬 재현(대소문자·하이픈 무시, 밑줄은 글자·숫자 앞) */
                                                    , IB.CELL_GROUP NULLS FIRST)   AS RNK
                    , IB.PLAN_START_YYYYMMDD
                    , IB.DIVISION_ID
                    , IB.PLAN_TYPE   /* E20260708-000926 */
                    , IB.CELL_GROUP
                 FROM (SELECT B.PLAN_START_YYYYMMDD
                            , B.DIVISION_ID
                            , B.CELL_GROUP
                            , B.PLAN_TYPE   /* E20260708-000926 */
                            , SUM(B.QTY)   AS SUM_QTY
                         FROM SCP_RPT_GLOBAL_PSI_MD_WW B
                        WHERE 1=1
                          AND B.MEASURE             = 'TOT_INV'
                          AND B.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                          AND B.DIVISION_ID         = V_DIVISION_ID
                          AND B.PLAN_TYPE           = V_PLAN_TYPE   /* E20260708-000926 */
                          AND B.YYYYPW              = V_RESULT_LAST_YYYYPW
                        GROUP BY B.PLAN_START_YYYYMMDD
                               , B.DIVISION_ID
                               , B.PLAN_TYPE   /* E20260708-000926 */
                               , B.CELL_GROUP
                        UNION ALL
                       /* 원문 그대로 : 위 SELECT 는 (…, CELL_GROUP, PLAN_TYPE, …) 순서, 이 SELECT 는 (…, PLAN_TYPE, CELL_GROUP, …) 순서 — UNION ALL 은 위치로 합치므로 원문과 같게 둔다 */
                       SELECT DISTINCT
                              C.PLAN_START_YYYYMMDD
                            , C.DIVISION_ID
                            , C.PLAN_TYPE   /* E20260708-000926 */
                            , C.CELL_GROUP
                            , 0   AS SUM_QTY
                         FROM SCP_RPT_GLOBAL_PSI_MD_WW C
                        WHERE 1=1
                          AND NOT EXISTS (SELECT 1
                                            FROM SCP_RPT_GLOBAL_PSI_MD_WW SA
                                           WHERE 1=1
                                             AND SA.DIVISION_ID         = C.DIVISION_ID
                                             AND SA.CELL_GROUP          = C.CELL_GROUP
                                             AND SA.MEASURE             = 'TOT_INV'
                                             AND SA.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                             AND SA.DIVISION_ID         = V_DIVISION_ID
                                             AND SA.PLAN_TYPE           = V_PLAN_TYPE   /* E20260708-000926 */
                                             AND SA.YYYYPW              = V_RESULT_LAST_YYYYPW)
                          AND C.MEASURE             = 'TOT_INV'
                          AND C.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                          AND C.DIVISION_ID         = V_DIVISION_ID
                          AND C.PLAN_TYPE           = V_PLAN_TYPE   /* E20260708-000926 */
                      ) IB
              ) IA
           ON (    A.PLAN_START_YYYYMMDD = IA.PLAN_START_YYYYMMDD
               AND A.DIVISION_ID         = IA.DIVISION_ID
               AND A.PLAN_TYPE           = IA.PLAN_TYPE   /* E20260708-000926 */
               AND A.CELL_GROUP          = IA.CELL_GROUP)
         WHEN MATCHED THEN
       UPDATE
          SET A.ATTRIBUTE8 = TO_CHAR(IA.RNK);

        /* ORDER BY 추가 */
        MERGE
         INTO SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW A
        USING (SELECT DENSE_RANK() OVER (PARTITION BY IB.PLAN_START_YYYYMMDD
                                                    , IB.DIVISION_ID
                                                    , IB.PLAN_TYPE   /* E20260708-000926 */
                                             ORDER BY IB.SUM_QTY DESC NULLS LAST
                                                    , UPPER(TRANSLATE(IB.CELL_GROUP, '_-', '/')) NULLS FIRST   /* MSSQL Latin1_General_CI_AS 정렬 재현(대소문자·하이픈 무시, 밑줄은 글자·숫자 앞) */
                                                    , IB.CELL_GROUP NULLS FIRST)   AS RNK
                    , IB.PLAN_START_YYYYMMDD
                    , IB.DIVISION_ID
                    , IB.PLAN_TYPE   /* E20260708-000926 */
                    , IB.CELL_GROUP
                 FROM (SELECT B.PLAN_START_YYYYMMDD
                            , B.DIVISION_ID
                            , B.PLAN_TYPE   /* E20260708-000926 */
                            , B.CELL_GROUP
                            , SUM(B.QTY)   AS SUM_QTY
                         FROM SCP_RPT_GLOBAL_PSI_MD_WW B
                        WHERE 1=1
                          AND B.MEASURE             = 'TOT_INV'
                          AND B.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                          AND B.DIVISION_ID         = V_DIVISION_ID
                          AND B.PLAN_TYPE           = V_PLAN_TYPE   /* E20260708-000926 */
                          AND B.YYYYPW              = V_RESULT_LAST_YYYYPW
                        GROUP BY B.PLAN_START_YYYYMMDD
                               , B.DIVISION_ID
                               , B.PLAN_TYPE   /* E20260708-000926 */
                               , B.CELL_GROUP
                        UNION ALL
                       SELECT DISTINCT
                              C.PLAN_START_YYYYMMDD
                            , C.DIVISION_ID
                            , C.PLAN_TYPE   /* E20260708-000926 */
                            , C.CELL_GROUP
                            , 0   AS SUM_QTY
                         FROM SCP_RPT_GLOBAL_PSI_MD_WW C
                        WHERE 1=1
                          AND NOT EXISTS (SELECT 1
                                            FROM SCP_RPT_GLOBAL_PSI_MD_WW SA
                                           WHERE 1=1
                                             AND SA.DIVISION_ID         = C.DIVISION_ID
                                             AND SA.CELL_GROUP          = C.CELL_GROUP
                                             AND SA.MEASURE             = 'TOT_INV'
                                             AND SA.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                             AND SA.DIVISION_ID         = V_DIVISION_ID
                                             AND SA.PLAN_TYPE           = V_PLAN_TYPE   /* E20260708-000926 */
                                             AND SA.YYYYPW              = V_RESULT_LAST_YYYYPW)
                          AND C.MEASURE             = 'TOT_INV'
                          AND C.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                          AND C.DIVISION_ID         = V_DIVISION_ID
                          AND C.PLAN_TYPE           = V_PLAN_TYPE   /* E20260708-000926 */
                      ) IB
              ) IA
           ON (    A.PLAN_START_YYYYMMDD = IA.PLAN_START_YYYYMMDD
               AND A.DIVISION_ID         = IA.DIVISION_ID
               AND A.PLAN_TYPE           = IA.PLAN_TYPE   /* E20260708-000926 */
               AND A.CELL_GROUP          = IA.CELL_GROUP)
         WHEN MATCHED THEN
       UPDATE
          SET A.ATTRIBUTE8 = TO_CHAR(IA.RNK);


        /* DECLARE @V_INV_SEQ		INT			= 0;  (선언부로 이동) */
        V_INV_SEQ := 0;

        SELECT MAX(TO_NUMBER(ATTRIBUTE8))
          INTO V_INV_SEQ
          FROM SCP_RPT_GLOBAL_PSI_MD_WW
         WHERE 1=1
           AND MEASURE             = 'TOT_INV'
           AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND DIVISION_ID         = V_DIVISION_ID
           AND PLAN_TYPE           = V_PLAN_TYPE;   /* E20260708-000926 */


        /* ORDER BY 추가 */
        /* 원문 ON 절의 A.ATTRIBUTE8 IS NULL 은 갱신 대상 칸이라 MERGE ON 절에 둘 수 없어(ORA-38104) UPDATE … WHERE 로 옮김(결과 동일) */
        MERGE
         INTO SCP_RPT_GLOBAL_PSI_MD_WW A
        USING (SELECT DENSE_RANK() OVER (PARTITION BY IB.PLAN_START_YYYYMMDD
                                                    , IB.DIVISION_ID
                                                    , IB.PLAN_TYPE   /* E20260708-000926 */
                                             ORDER BY IB.SUM_QTY DESC NULLS LAST
                                                    , UPPER(TRANSLATE(IB.CELL_GROUP, '_-', '/')) NULLS FIRST   /* MSSQL Latin1_General_CI_AS 정렬 재현(대소문자·하이픈 무시, 밑줄은 글자·숫자 앞) */
                                                    , IB.CELL_GROUP NULLS FIRST)   AS RNK
                    , IB.PLAN_START_YYYYMMDD
                    , IB.DIVISION_ID
                    , IB.PLAN_TYPE   /* E20260708-000926 */
                    , IB.CELL_GROUP
                 FROM (SELECT B.PLAN_START_YYYYMMDD
                            , B.DIVISION_ID
                            , B.PLAN_TYPE   /* E20260708-000926 */
                            , B.CELL_GROUP
                            , SUM(B.QTY)   AS SUM_QTY
                         FROM SCP_RPT_GLOBAL_PSI_MD_WW B
                        WHERE 1=1
                          AND B.MEASURE             = 'TOT_INV'
                          /* --AND	MM.YYYYPW 				= @V_RESULT_LAST_YYYYPW */
                          AND B.ATTRIBUTE8 IS NULL
                          AND B.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                          AND B.DIVISION_ID         = V_DIVISION_ID
                          AND B.PLAN_TYPE           = V_PLAN_TYPE   /* E20260708-000926 */
                        GROUP BY B.PLAN_START_YYYYMMDD
                               , B.DIVISION_ID
                               , B.PLAN_TYPE   /* E20260708-000926 */
                               , B.CELL_GROUP
                      ) IB
              ) IA
           ON (    A.PLAN_START_YYYYMMDD = IA.PLAN_START_YYYYMMDD
               AND A.DIVISION_ID         = IA.DIVISION_ID
               AND A.PLAN_TYPE           = IA.PLAN_TYPE   /* E20260708-000926 */
               AND A.CELL_GROUP          = IA.CELL_GROUP)
         WHEN MATCHED THEN
       UPDATE
          SET A.ATTRIBUTE8 = TO_CHAR(NVL(IA.RNK + NVL(V_INV_SEQ, 0), 99))
        WHERE A.ATTRIBUTE8 IS NULL;

        /* ORDER BY 추가 */
        MERGE
         INTO SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW A
        USING (SELECT DENSE_RANK() OVER (PARTITION BY IB.PLAN_START_YYYYMMDD
                                                    , IB.DIVISION_ID
                                                    , IB.PLAN_TYPE   /* E20260708-000926 */
                                             ORDER BY IB.SUM_QTY DESC NULLS LAST
                                                    , UPPER(TRANSLATE(IB.CELL_GROUP, '_-', '/')) NULLS FIRST   /* MSSQL Latin1_General_CI_AS 정렬 재현(대소문자·하이픈 무시, 밑줄은 글자·숫자 앞) */
                                                    , IB.CELL_GROUP NULLS FIRST)   AS RNK
                    , IB.PLAN_START_YYYYMMDD
                    , IB.DIVISION_ID
                    , IB.PLAN_TYPE   /* E20260708-000926 */
                    , IB.CELL_GROUP
                 FROM (SELECT B.PLAN_START_YYYYMMDD
                            , B.DIVISION_ID
                            , B.PLAN_TYPE   /* E20260708-000926 */
                            , B.CELL_GROUP
                            , SUM(B.QTY)   AS SUM_QTY
                         FROM SCP_RPT_GLOBAL_PSI_MD_WW B
                        WHERE 1=1
                          AND B.MEASURE             = 'TOT_INV'
                          /* --AND	MM.YYYYPW 				= @V_RESULT_LAST_YYYYPW */
                          AND B.ATTRIBUTE8 IS NULL
                          AND B.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                          AND B.DIVISION_ID         = V_DIVISION_ID
                          AND B.PLAN_TYPE           = V_PLAN_TYPE   /* E20260708-000926 */
                        GROUP BY B.PLAN_START_YYYYMMDD
                               , B.DIVISION_ID
                               , B.PLAN_TYPE   /* E20260708-000926 */
                               , B.CELL_GROUP
                      ) IB
              ) IA
           ON (    A.PLAN_START_YYYYMMDD = IA.PLAN_START_YYYYMMDD
               AND A.DIVISION_ID         = IA.DIVISION_ID
               AND A.PLAN_TYPE           = IA.PLAN_TYPE   /* E20260708-000926 */
               AND A.CELL_GROUP          = IA.CELL_GROUP)
         WHEN MATCHED THEN
       UPDATE
          SET A.ATTRIBUTE8 = TO_CHAR(NVL(IA.RNK + NVL(V_INV_SEQ, 0), 99))
        WHERE A.ATTRIBUTE8 IS NULL;

        COMMIT;   /* COMMIT TRAN ;  --- transaction 종료 */
    /* --- End Tran : 월별 Global PSI 본테이블에 Delete/Insert=============================================================================================================================== */

        /* ------------------------------------------------------------------ */
        /* 임시 테이블 정리 */
        /* ------------------------------------------------------------------ */
        /* ------------------------------------------------------------------ */
        /* 임시 테이블 정리 */
        /* ------------------------------------------------------------------ */
        DELETE FROM GT_GPWW_INVENTORY_DIO;
        DELETE FROM GT_GPWW_RTF_FOR_DIO;
        DELETE FROM GT_GPWW_BASE_DATA_FOR_DIO;
        DELETE FROM GT_GPWW_GAP_RTF_MKT_FCST;
        DELETE FROM GT_GPWW_SCP_RPT_GLOBAL_PSI_MD_WW;
        DELETE FROM GT_GPWW_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO;
        DELETE FROM GT_GPWW_PAST_FORM_PROGRESS_CHAR_AVAILABLE;
        DELETE FROM GT_GPWW_FP_AGING_STOCK;
        DELETE FROM GT_GPWW_PAST_CELL_CHAR_AVAILABLE;
        DELETE FROM GT_GPWW_CELL_CHAR_FOR_CHAR_AVAILABLE;
        DELETE FROM GT_GPWW_CELL_PROD_FOR_CHAR_AVAILABLE;
        DELETE FROM GT_GPWW_PACK_PROD_FOR_CELL_PLANT_INV;
        DELETE FROM GT_GPWW_ITEM_SEMI_SHIP_SITE;
        DELETE FROM GT_GPWW_SHIP_FOR_CELL_INV;
        DELETE FROM GT_GPWW_CELL_CHAR_FOR_CELL_INV;
        DELETE FROM GT_GPWW_PACK_CELL_EOH_RESULT_ADJ;
        DELETE FROM GT_GPWW_PACK_CELL_EOH_RESULT;
        DELETE FROM GT_GPWW_PACK_PRODUCTION_RESULT_3;
        DELETE FROM GT_GPWW_PACK_PRODUCTION_RESULT_2;
        DELETE FROM GT_GPWW_PACK_PRODUCTION_RESULT_1;
        DELETE FROM GT_GPWW_SEMI_WHIN_FOR_CELL_INV;
        DELETE FROM GT_GPWW_SHIP_FOR_PACK_INV;
        DELETE FROM GT_GPWW_PRODUCTION_FOR_PACK_INV;
        DELETE FROM GT_GPWW_SHIP_FOR_SEMI_INTRANSIT;
        DELETE FROM GT_GPWW_WHIN_FOR_INTRANSIT;
        DELETE FROM GT_GPWW_SHIP_FOR_INTRANSIT;
        DELETE FROM GT_GPWW_ENDING_INV_MM_WW;
        DELETE FROM GT_GPWW_ENDING_INV_MM;
        DELETE FROM GT_GPWW_ENDING_INV_MM_0;
        DELETE FROM GT_GPWW_ENDING_INV_MM_RAW;
        DELETE FROM GT_GPWW_SLOC_ADD_INFO;
        DELETE FROM GT_GPWW_TARGET_ITEM_FOR_ENDING_INV;
        DELETE FROM GT_GPWW_TOBE_GLOBAL_PSI;
        DELETE FROM GT_GPWW_WH_IN_SEMI_RESULT;
        DELETE FROM GT_GPWW_SHIPMENT_RESULT;
        DELETE FROM GT_GPWW_PRODUCTION_RESULT;
        DELETE FROM GT_GPWW_PRODUCTION_OPERATION;
        DELETE FROM GT_GPWW_INTRANSIT;
        DELETE FROM GT_GPWW_INTRANSIT_BOH;
        DELETE FROM GT_GPWW_FCST_RTF_RESULT;
        DELETE FROM GT_GPWW_WH_IN_RTF;
        DELETE FROM GT_GPWW_SALES_SITE_BOH;
        DELETE FROM GT_GPWW_CELL_PROD;
        DELETE FROM GT_GPWW_FORM_PROGRESS_FROM_BOH;
        DELETE FROM GT_GPWW_CELL_CHAR_PLAN_YIELD;
        DELETE FROM GT_GPWW_CELL_SHIP_PLAN_TOTAL;
        /* #CELL_FORM_HOLD_AFTER : 활성 코드에서 만들지 않는 임시테이블(주석 처리된 옛 코드 전용) — 정리 대상 없음 */
        DELETE FROM GT_GPWW_CELL_BOH_FOR_FUTURE;
        DELETE FROM GT_GPWW_CELL_CHAR_PLAN_FUTURE;
        DELETE FROM GT_GPWW_CELL_FOR_FORM_END;
        DELETE FROM GT_GPWW_FOR_FORM_END_WEEKLY;
        DELETE FROM GT_GPWW_FOR_FORM_END_DAILY;
        DELETE FROM GT_GPWW_CELL_PROD_FORM_END_LINE;
        DELETE FROM GT_GPWW_CELL_PROD_FORM_END;
        DELETE FROM GT_GPWW_CELL_PROD_FORM_END_RAW;
        DELETE FROM GT_GPWW_ASIS_GLOBAL_PSI;
        DELETE FROM GT_GPWW_SCP_ANL_PSI_GLOBAL;
        DELETE FROM GT_GPWW_ETC_CP_CELL_INFO;
        DELETE FROM GT_GPWW_MODULE_MODEL_INFO;
        DELETE FROM GT_GPWW_CP_CELL_ITEM_INFO;
        DELETE FROM GT_GPWW_SCP_MST_ITEM_CELL_CF;
        DELETE FROM GT_GPWW_CELL_PROD_ASSY_MAP;
        DELETE FROM GT_GPWW_SCP_PLN_TH_ENG_STOCK_PLAN;
        DELETE FROM GT_GPWW_SCP_MST_FORMATION;
        DELETE FROM GT_GPWW_SCP_MST_FINAL_ITEM;
        DELETE FROM GT_GPWW_SCM_MST_SITE;
        DELETE FROM GT_GPWW_PW_LIST;
        DELETE FROM GT_GPWW_DATE_INFO;
        DELETE FROM GT_GPWW_BASE_DATA_FOR_DIO_CELLGROUP;
        DELETE FROM GT_GPWW_RTF_FOR_DIO_CELLGROUP;
        DELETE FROM GT_GPWW_INVENTORY_DIO_CELLGROUP;
        DELETE FROM GT_GPWW_BASE_DATA_FOR_DIO_DETAILREPORT;
        DELETE FROM GT_GPWW_RTF_FOR_DIO_DETAILREPORT;
        DELETE FROM GT_GPWW_INVENTORY_DIO_DETAILREPORT;
        DELETE FROM GT_GPWW_WW_DAYS_INFO;
        DELETE FROM GT_GPWW_SHIPTO_CODE;
        /* 2025.05.28   kimcd GLOBAL PSI NEW - AS 대상 SALES_TYPE_CODE 임시 정보 삭제 */
        DELETE FROM GT_GPWW_AS_SALES_TYPE_CODE;
        /* Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
        DELETE FROM GT_GPWW_SCP_EXC_ITEM_ASSY_MAP;
        /* End : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
        COMMIT;   /* 원문은 COMMIT TRAN 뒤 DROP TABLE(자동 커밋) — GTT 정리 DELETE 확정 */

    EXCEPTION
        WHEN OTHERS THEN
            /* BEGIN CATCH : if (xact_state() <> 0) ROLLBACK TRAN; */
            ROLLBACK;

            /* -- ERROR LOG */
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH(P_PROGRAM_NAME => V_PROGRAM_NAME
                               , P_LOG_TYPE     => V_LOG_TYPE
                               , P_LOG_COUNT    => N_LOG_COUNT
                               , P_LOG_MESSAGE  => V_LOG_MESSAGE
                               , P_DESCRIPTION  => V_DESCRIPTION
                               , P_EVENT_DATE   => D_EVENT_DATE
                               , P_USER_ID      => V_BATCH_USER);
            DBMS_OUTPUT.PUT_LINE(V_LOG_MESSAGE || ' : ' || V_DESCRIPTION);
            RETURN;   /* RETURN -1; */
    END;   /* END CATCH; */

    N_EXEC_SECS := ROUND((SYSDATE - V_START_TIME) * 86400);
    V_EXEC_TIME := LPAD(TO_CHAR(TRUNC(N_EXEC_SECS / 60)), 2, '0') || ':' || LPAD(TO_CHAR(MOD(N_EXEC_SECS, 60)), 2, '0');
    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '##### END of procedure #####';
    V_DESCRIPTION := '[' || V_DIVISION_ID || '::' || V_PLAN_START_YYYYMMDD || '::' || V_ENG_PLAN_ID || '][' || V_EXEC_TIME || ']';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH(P_PROGRAM_NAME => V_PROGRAM_NAME
                       , P_LOG_TYPE     => V_LOG_TYPE
                       , P_LOG_COUNT    => N_LOG_COUNT
                       , P_LOG_MESSAGE  => V_LOG_MESSAGE
                       , P_DESCRIPTION  => V_DESCRIPTION
                       , P_EVENT_DATE   => D_EVENT_DATE
                       , P_USER_ID      => V_BATCH_USER);
    DBMS_OUTPUT.PUT_LINE(V_LOG_MESSAGE || ' : ' || V_DESCRIPTION);

END;