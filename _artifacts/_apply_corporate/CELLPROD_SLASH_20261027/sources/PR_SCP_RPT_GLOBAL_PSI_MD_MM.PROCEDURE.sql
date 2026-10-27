PROCEDURE PR_SCP_RPT_GLOBAL_PSI_MD_MM
(
      P_DIVISION_ID          IN VARCHAR2 DEFAULT '81'
    , P_PLAN_START_YYYYMMDD  IN VARCHAR2 DEFAULT NULL
    , P_PLAN_TYPE            IN VARCHAR2 DEFAULT 'FN'  /* E20260708-000926 추가. */
)
/*
 * Program ID   : PR_SCP_RPT_GLOBAL_PSI_MD_MM
 * Description  : 자동차 Monthly Global PSI 집계 프로시저
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
 * 2024.06.09   vadabi3     NERP - 특정 Company 별도 처리 개선-- 운영은 적용하지 않음
 * 2024.08.21   cys     	고도화 (개선 및 재고 통제 프로세스 적용)	- Global PSI New 개선_재고통제프로세스관련.xlsx 개발 목록 참조(PI 김도형 선임)
 * 2024.09.30   cys     	AS 실적 적용, Semi Ship Plan 로직 개선, 팩환산 오류건 개선
 * 2025.05.28   kimcd       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *                          E20250522-001206 GLOBAL PSI NEW - AS FCST/RTF 누락
 * 2025.08.01   hrkim	    PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경
 * 2025.09.01   hrkim		PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
 *							  - 기말재고(SCP_ANL_MONTH_END_STOCK_R) SCP Exclude Class 품목을 Cell Assy로 변환 참조	   (수율 적용하지 않음)
 *							  - FP Aging Stock(SCM_DNM_STOCK_AGING_SN) SCP Exclude Class 품목을 Cell Assy로 변환 참조  (수율 적용하지 않음)
 ----------------------------------------------------------------------------------------------------
 * 2025.11.17	YMH			E20251028-000389 기초재고정보 누락구조 수정 (LOCATION정보 미MAPPING 재고위한 특별 MEASURE 구성)
 * 2025.11.17	YMH			E20251029-001009 오류로 보이는 기초재고 누락케이스 (NB01 / Z799) 관련 수정
 * 2025.12.04   hrkim		[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV FP 활성화 재고를 ESS MI 법인 가상사이트 재고로 치환하여 정보 형성
 *								- SCM_DNM_STOCK_AGING_SN를 SCM_DNM_STOCK_AGING_SN_V뷰로 대체 참조
 * 2025.12.16	YMH			E20251023-001360 G-PSI AS 창고실적로직 개선
 * 2026.04.07	YMH			E20260407-000405 GLOBAL PSI NEW - P5200공정 모델 추가
 * 2026.05.11	YMH			E20260422-001155 GLOBAL PSI NEW - PLAN (MKT FCST & RTF) 기준 TABLE 변경 / 프로시져 특정시간에 작동 문의
 * 2026.08.12	YMH			E20260708-000926 Global PSI New 수행 Plan type 추가 요청의 건
 * 2026.10.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.27    ZIONEX      [PJ202650304] 티라엔진 제거 - SCP_PLN_SALES_ONHAND -> 통합 Dataset 기반 뷰(SCP_PLN_SALES_ONHAND_V) 교체
 */
IS

    /* procedure body -- start */
    /* SET TRANSACTION ISOLATION LEVEL READ COMMITTED; SET NOCOUNT ON; (Oracle 기본 동작) */

    /* SCP 계힉 참조를 위한 변수 */
    V_DIVISION_ID              VARCHAR2(30 CHAR)   := NVL(SUBSTR(P_DIVISION_ID, 1, 30), '81');
    V_IN_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR)    := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8);  /* @P_PLAN_START_YYYYMMDD NVARCHAR(8) */
    V_PLAN_START_YYYYMMDD      VARCHAR2(8 CHAR)    := NULL;
    V_PLAN_START_DATE          DATE                := NULL;
    /* E20260708-000926 기존로직 주석처리 */
    /* DECLARE @V_PLAN_TYPE				NVARCHAR(100)	= 'FN'; */
    /* E20260708-000926 기존로직 신규로직 */
    V_PLAN_TYPE                VARCHAR2(100 CHAR)  := NVL(SUBSTR(P_PLAN_TYPE, 1, 50), 'FN');
    V_PLAN_SEQ                 NUMBER(19)          := 1;
    V_HORIZON_END_YYYYMMDD     VARCHAR2(8 CHAR)    := NULL;
    V_PLAN_START_YYYYMM        VARCHAR2(6 CHAR)    := NULL;  /* 계획 구간 시작월 */
    V_MASTER_ID                VARCHAR2(100 CHAR)  := NULL;
    V_ENG_PLAN_ID              VARCHAR2(100 CHAR)  := NULL;

    /* DM 참조를 위한 변수 */
    V_DM_CUTOFF_YYYYMMDD       VARCHAR2(8 CHAR)    := NULL;
    V_DM_VERSION_NO            VARCHAR2(50 CHAR)   := NULL;

    /* 실적 구간 참조를 위한 변수 */
    V_RESULT_FROM_YYYYMM       VARCHAR2(6 CHAR)    := NULL;  /* 과거 실적구간 참조 시작월 (plan date - 52주, 해당월) */
    V_RESULT_FROM_YYYYMMDD     VARCHAR2(8 CHAR)    := NULL;  /* 과거 실적구간 참조 시작일 (plan date - 52주, 해당월 1일) */
    V_RESULT_FROM_DATE         DATE                := NULL;  /* 과거 실적구간 참조 시작일 (plan date - 52주, 해당월 1일) */
    V_RESULT_LAST_YYYYMM       VARCHAR2(6 CHAR)    := NULL;  /* 계획 시작일 기준 전월 */

    /* Ending Inventory 참조를 위한 변수 */
    V_INV_FROM_YYYYMM          VARCHAR2(6 CHAR)    := NULL;  /* 실적 참조 시작월 */
    V_INV_TO_YYYYMM            VARCHAR2(6 CHAR)    := NULL;  /* plan date 기준 전월 */

    /* 실행시간 확인용 */
    V_START_TIME               DATE                := SYSDATE;
    V_EXEC_TIME                VARCHAR2(10 CHAR)   := NULL;  /* '[00:00]' */
    N_EXEC_SEC                 NUMBER;

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME             VARCHAR2(150 CHAR)  := 'PR_SCP_RPT_GLOBAL_PSI_MD_MM';  /* Proc별 이름 설정 */
    V_LOG_TYPE                 VARCHAR2(30 CHAR);    /* START/END/ERROR/... */
    N_LOG_COUNT                NUMBER(10)          := 0;
    V_LOG_MESSAGE              VARCHAR2(1000 CHAR);
    V_DESCRIPTION              VARCHAR2(500 CHAR);
    D_EVENT_DATE               DATE;
    V_BATCH_USER               VARCHAR2(150 CHAR)  := 'scm_batch';

    /* NERP 매핑코드	--NERP 적용여부에 따라 변경 */
    V_COMPANY_SALES            VARCHAR2(8 CHAR);
    V_ESOC                     VARCHAR2(8 CHAR);
    V_PLANT_G8                 VARCHAR2(8 CHAR)    := 'G82';  /* 1차 Conv 대상 아님 */

    /* 오류 로그용 */
    V_IN_PARA_DATA             VARCHAR2(4000 CHAR);
    V_SQL_ERR_CODE             VARCHAR2(30 CHAR);
    V_SQL_ERR_MSG              VARCHAR2(2000 CHAR);
    V_SQL_BACKTRACE            VARCHAR2(4000 CHAR);

BEGIN

    V_COMPANY_SALES := SUBSTR(FN_GET_LOOKUP_VALUE('PR_SCP_RPT_GLOBAL_PSI_MD_MM', 'COMPANY_SALES'), 1, 8);
    V_ESOC          := SUBSTR(FN_GET_LOOKUP_VALUE('PR_SCP_RPT_GLOBAL_PSI_MD_MM', 'ESOC'), 1, 8);

    /* ------------------------------------------------------------------------------------------------------------------ */
    /* [PJ20257329] Cell 완성 공정 하드 코딩 변경 (임시테이블 변수) */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' SCP Cell 완성 공정 정보 - Cell Packaging/Assembly');
    /* ------------------------------------------------------------------------------------------------------------------ */
    DELETE FROM GT_GPMM_SCP_CELL_FINAL_OPERATION;

    INSERT
      INTO GT_GPMM_SCP_CELL_FINAL_OPERATION
         ( OPERATION_ID
         )
    SELECT DISTINCT
           LK.SEGMENT1 AS OPERATION_ID
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK
     WHERE LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
       AND LK.SEGMENT3    = 'A'  /* 공정그룹(Cell) */
       AND LK.ATTRIBUTE1  = 'Y'  /* Final Operation */
    ;
    /* ------------------------------------------------------------------------------------------------------------------ */

    BEGIN  /* BEGIN TRY */

        /* --------------------------------------------------------------------------------------------------- */
        /* SCP PLAN 버전 정보 (PRODUCTION) */
        /* --------------------------------------------------------------------------------------------------- */
        BEGIN
            SELECT D.PLAN_SEQ
                 , P.PLAN_NAME
                 , TO_DATE(P.PLAN_NAME, 'YYYYMMDD')
                 , SUBSTR(P.PLAN_NAME, 1, 6)
                 , SUBSTR(P.HORIZON_END_DATE, 1, 8)
                 , P.DIVISION_ID || '::' || P.PLAN_CYCLE
                 , P.PLAN_ID || '::' || D.PLAN_TYPE || '::' || TO_CHAR(D.PLAN_SEQ)
              INTO V_PLAN_SEQ
                 , V_PLAN_START_YYYYMMDD
                 , V_PLAN_START_DATE
                 , V_PLAN_START_YYYYMM
                 , V_HORIZON_END_YYYYMMDD
                 , V_MASTER_ID
                 , V_ENG_PLAN_ID
              FROM SCM_MST_PLAN        P
                 , SCM_MST_PLAN_DETAIL D
             WHERE D.DIVISION_ID  = P.DIVISION_ID
               AND D.PLAN_ID      = P.PLAN_ID
               AND D.PLAN_STATUS  = '1'  /* 정상 완료 */
               /* AND D.CONFIRM_FLAG = 'Y'  -- 최종 Confirm -- E20260708-000926 컨펌 제거 주석처리. */
               AND P.PLAN_CYCLE   = 'WEEKLY'
               AND D.PLAN_TYPE    = V_PLAN_TYPE  /* FN */
               AND P.DIVISION_ID  = V_DIVISION_ID
               AND P.PLAN_NAME    = NVL(V_IN_PLAN_START_YYYYMMDD, P.PLAN_NAME)  /* CASE WHEN ISNULL(@P_PLAN_START_YYYYMMDD,'') = '' THEN P.PLAN_NAME ELSE @P_PLAN_START_YYYYMMDD END */
             ORDER BY P.PLAN_NAME DESC
                    , D.PLAN_SEQ
             FETCH FIRST 1 ROW ONLY
            ;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;  /* TOP 1 결과가 없으면 변수 기존값 유지 */
        END;

        /* 시작 LOG  (START) */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '##### Start of procedure #####';
        V_DESCRIPTION := '[' || V_DIVISION_ID || '::' || V_PLAN_START_YYYYMMDD || ']';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);
        V_LOG_MESSAGE := NULL;

        /* 실적 구간 참조를 위한 변수값 */
        V_RESULT_FROM_YYYYMM    := TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(V_PLAN_START_YYYYMMDD, 1, 4) || '0101', 'YYYYMMDD'), -12), 'YYYYMM');  /* 과거 실적구간 참조 시작월 (plan date - 전년도 1월 해당월) */
        V_RESULT_FROM_YYYYMMDD  := V_RESULT_FROM_YYYYMM || '01';                                                                          /* 과거 실적구간 참조 시작일 (plan date - 52주, 해당월 1일) */
        V_RESULT_FROM_DATE      := TO_DATE(V_RESULT_FROM_YYYYMMDD, 'YYYYMMDD');                                                           /* 과거 실적구 scm_mst_site간 참조 시작일 (plan date - 52주, 해당월 1일) */
        V_RESULT_LAST_YYYYMM    := TO_CHAR(ADD_MONTHS(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -1), 'YYYYMM');                          /* 계획 시작일 기준 전월 */

        /* Ending Inventory 참조를 위한 변수 */
        V_INV_FROM_YYYYMM       := V_RESULT_FROM_YYYYMM;                                   /* 실적 참조 시작월 */
        V_INV_TO_YYYYMM         := TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, -1), 'YYYYMM');   /* plan date 기준 전월 */

        /* --------------------------------- */
        /* DM Cutoff YYYYMMDD */
        /* --------------------------------- */
        V_DM_CUTOFF_YYYYMMDD := TO_CHAR(FN_NEXT_DAY(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD'), 'TUE'), 'YYYYMMDD');

        /* --------------------------------------------------------------------------------------------------- */
        /* 참조대상 DM 버전 정보 (FCST 및 RTF 실적) */
        /* --------------------------------------------------------------------------------------------------- */
        BEGIN
            SELECT DV.VERSION_NO
              INTO V_DM_VERSION_NO
              FROM DM_MST_VERSION DV
             WHERE DV.VERSION_TYPE = 'MF_W'
               AND DV.DIVISION_ID  = V_DIVISION_ID
               AND DV.YYYYMMDD     = V_DM_CUTOFF_YYYYMMDD
             ORDER BY DV.VERSION_NO DESC
             FETCH FIRST 1 ROW ONLY
            ;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;  /* TOP 1 결과가 없으면 변수 기존값 유지 */
        END;

        DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('@P_DIVISION_ID			= ' || P_DIVISION_ID);
        DBMS_OUTPUT.PUT_LINE('@V_DIVISION_ID			= ' || V_DIVISION_ID);
        DBMS_OUTPUT.PUT_LINE('@P_PLAN_START_YYYYMMDD	= ' || P_PLAN_START_YYYYMMDD);
        DBMS_OUTPUT.PUT_LINE('@V_PLAN_START_DATE		= ' || TO_CHAR(V_PLAN_START_DATE, 'YYYYMMDD'));
        DBMS_OUTPUT.PUT_LINE('@V_PLAN_START_YYYYMMDD	= ' || V_PLAN_START_YYYYMMDD);
        DBMS_OUTPUT.PUT_LINE('@V_PLAN_START_YYYYMM     = ' || V_PLAN_START_YYYYMM);
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
        DBMS_OUTPUT.PUT_LINE('@V_RESULT_FROM_YYYYMM	= ' || V_RESULT_FROM_YYYYMM);
        DBMS_OUTPUT.PUT_LINE('@V_RESULT_LAST_YYYYMM	= ' || V_RESULT_LAST_YYYYMM);
        /* Ending Inventory 참조를 위한 변수 */
        DBMS_OUTPUT.PUT_LINE('@V_INV_FROM_YYYYMM		= ' || V_INV_FROM_YYYYMM);
        DBMS_OUTPUT.PUT_LINE('@V_INV_TO_YYYYMM			= ' || V_INV_TO_YYYYMM);
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------');

        /* --------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 기간 정보 : 데이터생성 범위 날짜 목록');
        /* --------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_DATE_INFO;

        INSERT
          INTO GT_GPMM_TMP_DATE_INFO
             ( YYYYMMDD
             , YYYYMM
             , MONTHLY_FROM_YMD
             , MONTHLY_TO_YMD
             , MM_DAYS
             , YYYYWW
             , WEEKLY_FROM_YMD
             , WEEKLY_TO_YMD
             , WK_DAYS
             , YYYYPW
             , P_WEEKLY_FROM_YMD
             , P_WEEKLY_TO_YMD
             , PWK_DAYS
             )
        SELECT BC.YYYYMMDD
             , BC.YYYYMM
             , MIN(BC.YYYYMMDD)   OVER (PARTITION BY BC.YYYYMM) AS MONTHLY_FROM_YMD
             , MAX(BC.YYYYMMDD)   OVER (PARTITION BY BC.YYYYMM) AS MONTHLY_TO_YMD
             , COUNT(BC.YYYYMMDD) OVER (PARTITION BY BC.YYYYMM) AS MM_DAYS
             , BC.YYYYWW
             , MIN(BC.YYYYMMDD)   OVER (PARTITION BY BC.YYYYWW) AS WEEKLY_FROM_YMD
             , MAX(BC.YYYYMMDD)   OVER (PARTITION BY BC.YYYYWW) AS WEEKLY_TO_YMD
             , COUNT(BC.YYYYMMDD) OVER (PARTITION BY BC.YYYYWW) AS WK_DAYS
             , BC.YYYYPW
             , MIN(BC.YYYYMMDD)   OVER (PARTITION BY BC.YYYYPW) AS P_WEEKLY_FROM_YMD
             , MAX(BC.YYYYMMDD)   OVER (PARTITION BY BC.YYYYPW) AS P_WEEKLY_TO_YMD
             , COUNT(BC.YYYYMMDD) OVER (PARTITION BY BC.YYYYPW) AS PWK_DAYS
          FROM SCM_MST_BUCKET BC
         WHERE BC.YYYYMMDD BETWEEN V_RESULT_FROM_YYYYMMDD /* 실적 참조 시작일 */
                               AND V_HORIZON_END_YYYYMMDD /* 계획 참조 종료일 */
        ;

        /* --------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 기간 정보 : 월별 일수 정보');
        /* --------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_MM_LIST;

        INSERT
          INTO GT_GPMM_TMP_MM_LIST
             ( YYYYMM
             , MONTHLY_FROM_YMD
             , MONTHLY_TO_YMD
             , MONTHLY_TO_YMD_NEXT_DAY
             , MM_DAYS
             )
        SELECT DISTINCT
               DI.YYYYMM
             , DI.MONTHLY_FROM_YMD
             , DI.MONTHLY_TO_YMD
             , TO_DATE(DI.MONTHLY_TO_YMD, 'YYYYMMDD') + 1 AS MONTHLY_TO_YMD_NEXT_DAY /* FP Aging Stock cutoff date (월말일 기준 재고 참조를 하기 위함) */
             , DI.MM_DAYS
          FROM GT_GPMM_TMP_DATE_INFO DI
        ;

        /* --------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### Cell Produc/Cell Assy 매핑 정보 추출');
        /* --------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_CELL_PROD_ASSY_MAP;

        INSERT
          INTO GT_GPMM_CELL_PROD_ASSY_MAP
             ( PLANT_ID
             , ITEM_ID_PROD
             , ITEM_ID_ASSY
             , ASSY_PRIORITY_1ST
             , ASSY_PRIORITY_2ND
             , CP_PRIORITY_1ST
             , CP_PRIORITY_2ND
             )
        SELECT M.PLANT_ID
             , M.ITEM_ID_PROD
             , M.ITEM_ID_ASSY
             , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
                                             , M.ITEM_ID_PROD
                                             , M.PLANT_ID
                                      ORDER BY M.VALID_YN DESC
                                             , M.ITEM_ID_ASSY) AS ASSY_PRIORITY_1ST /* cp 기준 assy 참조 */
             , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
                                             , M.ITEM_ID_PROD
                                      ORDER BY M.VALID_YN DESC
                                             , M.ITEM_ID_ASSY) AS ASSY_PRIORITY_2ND /* cp 기준 assy 참조 */
             , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
                                             , M.ITEM_ID_ASSY
                                             , M.PLANT_ID
                                      ORDER BY M.VALID_YN DESC
                                             , M.ITEM_ID_PROD) AS CP_PRIORITY_1ST   /* assy 기준 cp 참조 */
             , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
                                             , M.ITEM_ID_ASSY
                                      ORDER BY M.VALID_YN DESC
                                             , M.ITEM_ID_PROD) AS CP_PRIORITY_2ND   /* assy 기준 cp 참조 */
          FROM SCP_MST_CELL_PROD_ASSY_MAP M
         WHERE M.VALID_YN    = 'Y'
           AND M.DIVISION_ID = V_DIVISION_ID
        ;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### Formation 수율 및 LT 정보');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_SCP_MST_FORMATION;
        /*
		SELECT    FR.PLANT_SITE_ID
				, FR.ITEM_ID
				, FR.LT_FORMATION
				, FR.ATTRIBUTE1
				, CEILING(ISNULL(FR.LT_FORMATION + CONVERT(INT, ISNULL(FR.ATTRIBUTE1, '0')),0) /7.0) * 7 	AS LT_DAY	-- LT_week으로 환산후 다시 일수로 변환 적용
				, CEILING(ISNULL(FR.LT_FORMATION + CONVERT(INT, ISNULL(FR.ATTRIBUTE1, '0')),0) /7.0)		AS LT_WEEK
				, ISNULL(FR.FORMATION_TOTAL_YIELD, 0)	AS FORMATION_TOTAL_YIELD
				, ISNULL(FR.SSP_MODIFY_YIELD, 0)		AS SSP_MODIFY_YIELD
				, ISNULL(FR.CHAR_YIELD, 0)				AS CHAR_YIELD
		  INTO #SCP_MST_FORMATION
		  FROM SCP_MST_FORMATION FR WITH(NOLOCK)
		 WHERE 1=1
		   AND DIVISION_ID	= @V_DIVISION_ID
         */
        /* 고도화 수율 기준 변경 */
        INSERT
          INTO GT_GPMM_SCP_MST_FORMATION
             ( PLANT_SITE_ID
             , ITEM_ID
             , YYYYMM
             , LT_FORMATION
             , ATTRIBUTE1
             , LT_DAY
             , LT_WEEK
             , FORMATION_TOTAL_YIELD
             , SSP_MODIFY_YIELD
             , CHAR_YIELD
             )
        SELECT A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.YYYYMM
             , FR.LT_FORMATION
             , FR.ATTRIBUTE1
             , CEIL(NVL(FR.LT_FORMATION + TRUNC(TO_NUMBER(NVL(FR.ATTRIBUTE1, '0'))), 0) / 7.0) * 7 AS LT_DAY /* LT_WEEK으로 환산후 다시 일수로 변환 적용 */
             , CEIL(NVL(FR.LT_FORMATION + TRUNC(TO_NUMBER(NVL(FR.ATTRIBUTE1, '0'))), 0) / 7.0)     AS LT_WEEK
             , NVL(A.YIELD, 0) AS FORMATION_TOTAL_YIELD /* ISNULL(FR.FORMATION_TOTAL_YIELD, 0)	AS FORMATION_TOTAL_YIELD */
             , NVL(A.YIELD, 0) AS SSP_MODIFY_YIELD      /* ISNULL(FR.SSP_MODIFY_YIELD, 0)		AS SSP_MODIFY_YIELD */
             , NVL(A.YIELD, 0) AS CHAR_YIELD            /* ISNULL(FR.CHAR_YIELD, 0)				AS CHAR_YIELD */
          FROM (SELECT A.PLANT_ID || '-A'     AS PLANT_SITE_ID
                     , A.ITEM_ID
                     , WL.YYYYMM
                     , AVG(NVL(A.YIELD, 1))  AS YIELD
                  FROM SCM_MST_YIELD_SN    A
                     , GT_GPMM_TMP_MM_LIST WL
                 WHERE WL.YYYYMM      >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
                   AND A.DIVISION_ID   = V_DIVISION_ID
                   AND A.MONTH        >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
                   /* AND A.OPERATION_ID 	IN ( 'F6000' , 'P9500', 'P5200', 'P5500') */
                   AND A.OPERATION_ID IN ('P9500', 'P5200', 'P5500')
                 GROUP BY A.PLANT_ID
                        , A.ITEM_ID
                        , WL.YYYYMM
                 UNION ALL
                SELECT A.PLANT_SITE_ID
                     , A.ITEM_ID
                     , WL.YYYYMM
                     , MAX(NVL(A.SSP_MODIFY_YIELD, A.FORMATION_TOTAL_YIELD)) AS YIELD
                  FROM SCP_MST_FORMATION   A
                     , GT_GPMM_TMP_MM_LIST WL
                 WHERE WL.YYYYMM    >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
                   AND A.DIVISION_ID = V_DIVISION_ID
                 GROUP BY A.PLANT_SITE_ID
                        , A.ITEM_ID
                        , WL.YYYYMM
               ) A
             , SCP_MST_FORMATION FR
         WHERE FR.PLANT_SITE_ID(+) = A.PLANT_SITE_ID
           AND FR.ITEM_ID(+)       = A.ITEM_ID
        ;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 해당 사업부 #SCM_MST_SITE 추출 ');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_SCM_MST_SITE;

        INSERT
          INTO GT_GPMM_SCM_MST_SITE
             ( SCM_SITE_ID
             , PLANT_ID
             , OPERATION_GROUP
             , SITE_TYPE
             , OSP_YN
             , VALID_YN
             )
        SELECT SCM_SITE_ID
             , PLANT_ID
             , OPERATION_GROUP
             , SITE_TYPE
             , OSP_YN
             , VALID_YN
          FROM SCM_MST_SITE
         WHERE DIVISION_ID = V_DIVISION_ID
        ;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 해당 사업부 #SCP_MST_FINAL_ITEM 추출 ');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_SCP_MST_FINAL_ITEM;

        INSERT
          INTO GT_GPMM_SCP_MST_FINAL_ITEM
             ( ITEM_ID
             , NICK_NAME
             , OPERATION_GROUP
             , GROUP_CODE1
             , GROUP_CODE6
             , GROUP_CODE7
             , FINISHED_PRODUCT
             , CELL_TYPE
             , FLOW_ID
             , CELL_MODEL_ID
             )
        SELECT ITEM_ID
             , NICK_NAME
             , OPERATION_GROUP
             , NVL(GROUP_CODE1, 'ETC') AS GROUP_CODE1 /* cell group --	--- 고도화 */
             , NVL(GROUP_CODE6, '-')   AS GROUP_CODE6 /* Product Level1 -- 고도화 */
             , NVL(GROUP_CODE7, '-')   AS GROUP_CODE7 /* - Product Level2 -- 고도화 */
             , FINISHED_PRODUCT
             , ATTRIBUTE8              AS CELL_TYPE     /* CP/CA Cell_type */
             , FLOW_ID                                  /* 고도화 */
             , ATTRIBUTE1              AS CELL_MODEL_ID /* CP/CA Cell_type					-- 고도화 */
          FROM SCP_MST_FINAL_ITEM
         WHERE OPERATION_GROUP IN ('A', 'P') /* Cell/Pack 만 */
           AND DIVISION_ID      = V_DIVISION_ID
        ;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 해당 사업부 팩(모듈) 모델 셀 환산수량 정보 추출 ');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_SCP_MST_ITEM_CELL_CF;

        INSERT
          INTO GT_GPMM_SCP_MST_ITEM_CELL_CF
             ( ITEM_ID
             , TARGET_CELL
             , CELL_CF
             )
        SELECT CF.ITEM_ID
             , CF.TARGET_CELL
             , CF.CELL_CF
          FROM SCP_MST_ITEM_CELL_CF CF
         WHERE EXISTS (SELECT 1
                         FROM SCM_MST_ITEM_SN II
                        WHERE II.ITEM_ID             = CF.ITEM_ID
                          AND II.SCP_OPERATION_GROUP = 'P'
                          AND II.DIVISION_ID         = V_DIVISION_ID)
        ;

        /* (2024.09.02 변경건) */
        /* --- begin 대표 cell item 정보 추가 =============================================================================================================================== */
        /*  Pack_cell_EOH 의 amdau 수량을 넣어주기 위해 위치 변경	-- 고도화 */
        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 대표Cell 품목 매핑 : CP Cell 정보 for Pack');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_CP_CELL_ITEM_INFO;

        INSERT
          INTO GT_GPMM_CP_CELL_ITEM_INFO
             ( MODEL_ID
             , CELL_ITEM_ID
             )
        SELECT Y.MODEL_ID
             , MIN(Y.CHILD_ITEM_ID) AS CELL_ITEM_ID
          FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Y
         WHERE Y.CELL_TYPE          = 'CP'
           AND Y.OPERATION_GROUP_ID = 'A'
           AND Y.DIVISION_ID        = V_DIVISION_ID
         GROUP BY Y.MODEL_ID
        ;

/*
		-- model - cell 간 누락되는 현상이 있어 view 를 사용하지 않고 해당 쿼리 직접 사용 20241113
		-- ex> AMRSAEV20-A1 - ACEN4060I-A1-110 만 표시되어 수정
		SELECT DISTINCT B.MODEL_ID, B.CHILD_ITEM_ID AS CELL_ITEM_ID
		INTO #CP_CELL_ITEM_INFO
		FROM	(
					SELECT X.*
					FROM DBO.SCM_MST_BOM_SN_V X WITH(NOLOCK)
						INNER JOIN DBO.SCM_MST_ITEM_SN I WITH(NOLOCK)
						ON  X.CHILD_DIVISION_ID = I.DIVISION_ID
						AND X.CHILD_ITEM_ID     = I.ITEM_ID
						AND X.CHILD_COMPANY_ID  = I.COMPANY_ID -- A002 빈강 추가 따른 조건 추가
						AND X.CHILD_SITE_ID     = I.SITE_ID
						AND I.ACTIVE_FLAG       = 'Y'
					WHERE 1=1
					AND X.DIVISION_ID		 = @V_DIVISION_ID
					--AND MODEL_ID = 'AMRSAEV20-A1'
					--AND CHILD_ITEM_ID LIKE 'ACEN4060I-A1-%'
				) B
				, SCM_MST_FINAL_ITEM_V V WITH(NOLOCK)
				, SCM_MST_ITEM_SN MI WITH(NOLOCK)
		WHERE 1=1
		AND B.DIVISION_ID   = V.DIVISION_ID
		AND B.CHILD_ITEM_ID = V.ITEM_ID
		--AND B.ALT_PRIORITY  = 'Y'  -- => FP에서 MODEL별로 전개한 테이블에 적용.
		AND B.DIVISION_ID   = MI.DIVISION_ID
		AND B.MODEL_ID      = MI.ITEM_ID
		AND B.COMPANY_ID    = MI.COMPANY_ID  -- A002 빈강 추가 따른 조건 추가
		AND B.SITE_ID       = MI.SITE_ID
		AND MI.ACTIVE_FLAG  = 'Y'
		AND V.CELL_TYPE		= 'CP'
		AND V.OPERATION_GROUP_ID	 = 'A'
*/
        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 대표Cell 품목 매핑 : AMDAU 모듈의 상위 모델 및 셀(CP) INFO');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_MODULE_MODEL_INFO;
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
				 FROM SCM_MST_BOM_ENG_SN  B WITH(NOLOCK)  -- SCM_MST_BOM_ENG_SN
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
          INTO GT_GPMM_MODULE_MODEL_INFO
             ( DIVISION_ID
             , MODULE_ID
             , MODEL_ID
             , CELL_ITEM_ID
             , KEY_DATE
             , RN
             , RN2
             , GROUP_CODE1
             , PACK_MODULE_ITEM
             )
        SELECT AMDAU_MODEL.DIVISION_ID
             , AMDAU_MODEL.MODULE_ID
             , AMDAU_MODEL.MODEL_ID
             , AMDAU_MODEL.CELL_ITEM_ID
             , AMDAU_MODEL.KEY_DATE
             , AMDAU_MODEL.RN
             , AMDAU_MODEL.RN2
             , AMDAU_MODEL.GROUP_CODE1
             , AMDAU_MODEL.PACK_MODULE_ITEM
          FROM (SELECT B.DIVISION_ID
                     , B.CHILD_ITEM_ID  AS MODULE_ID
                     , B.PARENT_ITEM_ID AS MODEL_ID
                     , F.CELL_MODEL_ID  AS CELL_ITEM_ID /* ,C.CHILD_ITEM_ID AS CELL_ITEM_ID */
                     , B.KEY_DATE
                     , ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
                                                     , B.CHILD_ITEM_ID
                                              ORDER BY B.KEY_DATE DESC) AS RN
                     , ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
                                                     , B.CHILD_ITEM_ID
                                                     , B.PARENT_ITEM_ID
                                              ORDER BY B.KEY_DATE DESC) AS RN2
                     , F.GROUP_CODE1
                       /* E20260407-000405 GLOBAL PSI NEW - P5200공정 모델 추가 기존로직 제거 */
                       /* , CASE WHEN F.GROUP_CODE1 IN ('E60A', 'E78', 'E79A', 'E129A', 'E128A') THEN 'Y' ELSE 'N' END PACK_MODULE_ITEM	--@@@ 5200 기준 모델 구분진행 */
                       /* E20260407-000405 GLOBAL PSI NEW - P5200공정 모델 추가 변경로직 시작 */
                     , CASE WHEN F.GROUP_CODE1 IN (SELECT DISTINCT
                                                          LK.SEGMENT1 AS GROUP_CODE1
                                                     FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK
                                                    WHERE LK.LOOKUP_TYPE = 'P5200_GROUP_EXCEPTION'
                                                      AND LK.VALID_YN    = 'Y'
                                                  ) THEN 'Y' ELSE 'N' END AS PACK_MODULE_ITEM /* @@@ 5200 기준 모델 구분진행 */
                       /* E20260407-000405 GLOBAL PSI NEW - P5200공정 모델 추가 변경로직 끝 */
                  FROM SCM_MST_BOM_ENG_SN         B  /* SCM_MST_BOM_ENG_SN */
                     , SCM_MODEL_COMP_TEMP_SN     C
                     , GT_GPMM_SCP_MST_FINAL_ITEM F
                 WHERE B.COMPANY_ID   = C.COMPANY_ID  /* CP (Cell Product */
                   AND B.DIVISION_ID  = C.DIVISION_ID /* CP (Cell Product */
                   AND B.SITE_ID      = C.SITE_ID     /* CP (Cell Product */
                   AND B.PLANT_ID     = C.PLANT_ID    /* CP (Cell Product */
                   AND C.MODEL_ID     = B.PARENT_ITEM_ID
                   AND F.ITEM_ID(+)   = B.PARENT_ITEM_ID
                   AND EXISTS (SELECT 1 /* -- 2024.01.26 추가 (Pack>module>cell 관계 성립 데이터만 참조) */
                                 FROM SCM_MST_BOM_SN SB
                                WHERE SB.COMPANY_ID     = C.COMPANY_ID    /* CP (Cell Product */
                                  AND SB.DIVISION_ID    = C.DIVISION_ID   /* CP (Cell Product */
                                  AND SB.SITE_ID        = C.SITE_ID       /* CP (Cell Product */
                                  AND SB.PLANT_ID       = C.PLANT_ID      /* CP (Cell Product */
                                  AND SB.CHILD_ITEM_ID  = C.CHILD_ITEM_ID /* CP (Cell Product */
                                  AND SB.CONCATENATE_ITEM LIKE B.PARENT_ITEM_ID || '%' || B.CHILD_ITEM_ID || '%' /* pack model_id%module_id% */
                                  AND SB.CHILD_ITEM_ID LIKE 'AMDAU%'
                                  AND SB.DIVISION_ID    = V_DIVISION_ID)
                   AND B.CHILD_ITEM_ID LIKE 'AMDAU%'
                   AND B.DIVISION_ID  = V_DIVISION_ID
               ) AMDAU_MODEL
         WHERE AMDAU_MODEL.RN = 1
        ;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 대표Cell 품목 매핑 : 기타 모델 CP 셀 정보');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_ETC_CP_CELL_INFO;

        INSERT
          INTO GT_GPMM_ETC_CP_CELL_INFO
             ( PARENT_ITEM_ID
             , CELL_ITEM_ID
             )
        SELECT B.PARENT_ITEM_ID
             , MIN(B.CHILD_ITEM_ID) AS CELL_ITEM_ID
          FROM SCM_MST_BOM_SN             B /* SCM_MST_BOM_SN */
             , GT_GPMM_SCP_MST_FINAL_ITEM F
         WHERE F.ITEM_ID     = B.CHILD_ITEM_ID
           AND F.CELL_TYPE   = 'CP'
           AND B.DIVISION_ID = V_DIVISION_ID
         GROUP BY B.PARENT_ITEM_ID
        ;

        /* --- Start : Ending Inventory (과거 실적 구간 재고)	---  위치 변경 -- 고도화 */

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : 참조 대상 품목 정보');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_TARGET_ITEM_FOR_ENDING_INV;

        INSERT
          INTO GT_GPMM_TMP_TARGET_ITEM_FOR_ENDING_INV
             ( ITEM_ID
             , FINISHED_PRODUCT
             , OPERATION_ID
             , OPERATION_GROUP
             , ITEM_TYPE
             , PROCESS_GROUP
             )
        SELECT II.ITEM_ID
             , NVL(MAX(FI.FINISHED_PRODUCT), 'N') AS FINISHED_PRODUCT
             , MAX(II.SCP_FLOW_ID)                AS OPERATION_ID
             , MAX(II.SCP_OPERATION_GROUP)        AS OPERATION_GROUP
             , MAX(B.ITEM_TYPE)                   AS ITEM_TYPE     /* -- E20251029-001009 : CLASS정보에서 반제/제품 구분을 위해 추가. */
             , MAX(B.PROCESS_GROUP)               AS PROCESS_GROUP /* -- E20251029-001009 : CLASS정보에서 반제/제품 구분을 위해 추가. */
          FROM SCM_MST_ITEM_SN            II
             , GT_GPMM_SCP_MST_FINAL_ITEM FI
             , SCM_MST_ITEM_CLASS_M       B  /* -- E20251029-001009 : CLASS정보에서 반제/제품 구분을 위해 추가. */
         WHERE FI.ITEM_ID(+)  = II.ITEM_ID
           AND B.CLASS_ID(+)  = II.ITEM_CLASS
           AND (   II.ITEM_ID LIKE 'AMDAU%'
                OR EXISTS (SELECT 1
                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE L.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                              AND L.SEGMENT1    = II.SCP_FLOW_ID
                              AND L.SEGMENT1   != 'F6000'
                              AND L.VALID_YN    = 'Y'
                              AND L.SEGMENT4 LIKE '%' || V_DIVISION_ID || '%')
               )
           AND II.SCP_OPERATION_GROUP IN ('A', 'P')
           AND II.DIVISION_ID          = V_DIVISION_ID
         GROUP BY II.ITEM_ID
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : 시뮬레이터 measure sloc 매핑 정보');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_SLOC_ADD_INFO;

        /* ★ AS-IS(대소문자 무시)와 같게 : 실데이터에 'Cell_BOH'·'CELL_BOH' 가 섞여 있어 대문자로 맞춰 적재(비교 상수는 모두 대문자) */
        /* ★ AS-IS ATTRIBUTE12 <> '' 는 공백(' ')도 제외(MSSQL 후행공백 무시) → RTRIM 후 NULL 여부로 판단 */
        INSERT
          INTO GT_GPMM_TMP_SLOC_ADD_INFO
             ( PLANT
             , SLOC
             , SIMU_MEASURE
             )
        SELECT DISTINCT
               SEGMENT1           AS PLANT
             , SEGMENT2           AS SLOC
             , UPPER(ATTRIBUTE12) AS SIMU_MEASURE
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SLOC_ADD_INFO'
           AND RTRIM(ATTRIBUTE12) IS NOT NULL
        ;

        /* 2025.05.28   kimcd GLOBAL PSI NEW - AS 대상 SALES_TYPE_CODE 임시 정보 형성 시작 */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### AS 대상 SALES_TYPE_CODE');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_AS_SALES_TYPE_CODE;

        INSERT
          INTO GT_GPMM_TMP_AS_SALES_TYPE_CODE
             ( FCST_TYPE
             )
        SELECT SEGMENT1 AS FCST_TYPE
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SALES_TYPE_CODE'
           AND ATTRIBUTE3  = 'Y'
        ;
        /* 2025.05.28   kimcd GLOBAL PSI NEW - AS 대상 SALES_TYPE_CODE 임시 정보 형성 끝 */

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        /* Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : SCP Exclude Class 품목을 Cell Assy 매핑정보');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_SCP_EXC_ITEM_ASSY_MAP;

        INSERT
          INTO GT_GPMM_SCP_EXC_ITEM_ASSY_MAP
             ( COMPANY_ID
             , DIVISION_ID
             , PLANT_ID
             , SCP_EXC_ITEM_ID
             , CELL_ASSY_ITEM_ID
             )
        SELECT COMPANY_ID
             , DIVISION_ID
             , PLANT_ID
             , SCP_EXC_ITEM_ID
             , MAX(CELL_ASSY_ITEM_ID) AS CELL_ASSY_ITEM_ID
          FROM TABLE(FN_GET_SCP_EXC_ITEM_ASSY_MAP(V_DIVISION_ID))
         GROUP BY COMPANY_ID
                , DIVISION_ID
                , PLANT_ID
                , SCP_EXC_ITEM_ID
        ;
        /* End : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : 월별 재고 - Raw 데이터');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_ENDING_INV_MM_RAW;

        INSERT
          INTO GT_GPMM_TMP_ENDING_INV_MM_RAW
             ( ITEM_ID
             , YYYYMM
             , STORAGE_LOCATION
             , PLANT_ID
             , SUPPLIER_CODE
             , QUANTITY
             )
        SELECT NVL(AM.CELL_ASSY_ITEM_ID, IV.ITEM_ID) AS ITEM_ID /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , IV.YYYYMM
             , IV.STORAGE_LOCATION
             , IV.PLANT_ID
             , IV.SUPPLIER_CODE
             , IV.QUANTITY
          FROM SCP_ANL_MONTH_END_STOCK_R     IV
               /* Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , GT_GPMM_SCP_EXC_ITEM_ASSY_MAP AM
               /* End : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
         WHERE AM.COMPANY_ID(+)      = IV.COMPANY_ID
           AND AM.DIVISION_ID(+)     = IV.DIVISION_ID
           AND AM.PLANT_ID(+)        = IV.PLANT_ID
           AND AM.SCP_EXC_ITEM_ID(+) = IV.ITEM_ID
           AND IV.DIVISION_ID        = V_DIVISION_ID
           AND IV.YYYYMM            >= V_INV_FROM_YYYYMM
           AND IV.YYYYMM            <= V_INV_TO_YYYYMM
           AND NVL(IV.SPECIAL_INVENTORY, '-') != 'W' /* Cosignment_stock[고객위탁재고]의 경우, S.loc이 공란이라 Key값으로 집계를 하지 못하여 제외하고 #TMP_ENDING_INV_MM 에 직접 입력함. -- 고도화 */
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : 월별 재고');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_ENDING_INV_MM;

        INSERT
          INTO GT_GPMM_TMP_ENDING_INV_MM
             ( ITEM_ID
             , YYYYMM
             , OPERATION_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , MEASURE
             , QTY
             )
        SELECT IV.ITEM_ID
             , IV.YYYYMM
             , II.OPERATION_ID
             , II.OPERATION_GROUP
             , NVL(FS.SCM_SITE_ID, '-') AS FROM_SITE
             , NVL(TS.SCM_SITE_ID, '-') AS TO_SITE
             , CASE WHEN SM.SIMU_MEASURE = 'BOH'           AND II.OPERATION_GROUP = 'P' THEN 'PACK_EOH'
                    WHEN SM.SIMU_MEASURE = 'BOH'           AND II.OPERATION_GROUP = 'A' THEN 'CELL_EOH'
                    WHEN SM.SIMU_MEASURE = 'CELL_BOH'                                   THEN 'CELL_EOH'
                    WHEN SM.SIMU_MEASURE = 'PACK_CELL_BOH' AND II.OPERATION_GROUP = 'A' THEN 'PACK_CELL_EOH'
                    WHEN SM.SIMU_MEASURE = 'CELL_FOR_FORM_END'                          THEN 'CELL_CHAR_AVAILABLE'
                    /* WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'미착'	THEN 'SEMI_INTRANSIT' */
                    WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA' AND IV.STORAGE_LOCATION = '미착' THEN /* 고도화 */
                         ( CASE WHEN II.OPERATION_ID IN ('P9500', 'P5500')                       THEN 'INTRANSIT'
                                WHEN II.OPERATION_ID = 'P5000'                                   THEN 'SEMI_INTRANSIT'
                                WHEN II.OPERATION_ID = 'A9000' AND II.FINISHED_PRODUCT  = 'Y'    THEN 'INTRANSIT'
                                WHEN II.OPERATION_ID = 'A9000' AND II.FINISHED_PRODUCT != 'Y'    THEN 'SEMI_INTRANSIT'
                                ELSE 'SEMI_INTRANSIT'
                           END )
                    /* E20251029-001009 : 7990 주석처리 / 7000이 아닌것은 제품/반제품 구분하여 분류 */
                    /* WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7990'	THEN 'INTRANSIT' */
                    WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA' AND IV.STORAGE_LOCATION = '7000' THEN
                         CASE WHEN II.OPERATION_ID IN ('P9500', 'P5500')                         THEN 'INTRANSIT'
                              WHEN II.OPERATION_ID = 'P5000'                                     THEN 'SEMI_INTRANSIT'
                              WHEN II.OPERATION_ID = 'A9000' AND II.FINISHED_PRODUCT  = 'Y'      THEN 'INTRANSIT'
                              WHEN II.OPERATION_ID = 'A9000' AND II.FINISHED_PRODUCT != 'Y'      THEN 'SEMI_INTRANSIT'
                              ELSE 'MISMATCH_INV'
                         END
                    /* E20251029-001009 : 7990 주석처리 / 7000이 아닌것은 제품/반제품 구분하여 분류 */
                    WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA' AND IV.STORAGE_LOCATION != '7000' THEN
                         CASE WHEN II.ITEM_TYPE = '제품'                                          THEN 'INTRANSIT'
                              WHEN II.ITEM_TYPE = '반제품'                                        THEN 'SEMI_INTRANSIT'
                              ELSE 'MISMATCH_INV'
                         END
                    WHEN SM.SIMU_MEASURE = 'VMI'                                        THEN 'TO_SITE_EOH'
                    WHEN SM.SIMU_MEASURE = 'AS'                                         THEN 'AS_INV'
                    WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA' AND IV.STORAGE_LOCATION = 'In-T' THEN 'INTRANSIT' /* 20250210 DJLEE 'IN-T' MAPPING */
                    ELSE 'MISMATCH_INV'
               END AS MEASURE
             , SUM(IV.QUANTITY) AS QTY
          FROM GT_GPMM_TMP_ENDING_INV_MM_RAW          IV
             , GT_GPMM_TMP_TARGET_ITEM_FOR_ENDING_INV II
             , GT_GPMM_TMP_SLOC_ADD_INFO              SM
             , GT_GPMM_SCM_MST_SITE                   FS /* from site */
             , GT_GPMM_SCM_MST_SITE                   TS /* to site */
         WHERE II.ITEM_ID             = IV.ITEM_ID
           AND SM.PLANT               = IV.PLANT_ID
           AND SM.SLOC                = IV.STORAGE_LOCATION
           AND FS.PLANT_ID(+)         = CASE WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA' AND IV.STORAGE_LOCATION = '미착'
                                             THEN IV.SUPPLIER_CODE
                                             ELSE IV.PLANT_ID
                                        END
           AND FS.OPERATION_GROUP(+)  = CASE WHEN SM.SIMU_MEASURE = 'PACK_CELL_BOH' /* pack plant cell */
                                             THEN 'P'
                                             ELSE II.OPERATION_GROUP
                                        END
           AND TS.PLANT_ID(+)         = CASE WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA' AND IV.STORAGE_LOCATION = '미착'
                                             THEN IV.PLANT_ID
                                             ELSE 'Z'
                                        END
           AND TS.OPERATION_GROUP(+)  = II.OPERATION_GROUP
           AND FS.SITE_TYPE(+)        = 'PLANT'
           AND TS.SITE_TYPE(+)        = 'PLANT'
         GROUP BY IV.ITEM_ID
                , IV.YYYYMM
                , II.OPERATION_ID
                , II.OPERATION_GROUP
                , NVL(FS.SCM_SITE_ID, '-')
                , NVL(TS.SCM_SITE_ID, '-')
                , CASE WHEN SM.SIMU_MEASURE = 'BOH'           AND II.OPERATION_GROUP = 'P' THEN 'PACK_EOH'
                       WHEN SM.SIMU_MEASURE = 'BOH'           AND II.OPERATION_GROUP = 'A' THEN 'CELL_EOH'
                       WHEN SM.SIMU_MEASURE = 'CELL_BOH'                                   THEN 'CELL_EOH'
                       WHEN SM.SIMU_MEASURE = 'PACK_CELL_BOH' AND II.OPERATION_GROUP = 'A' THEN 'PACK_CELL_EOH'
                       WHEN SM.SIMU_MEASURE = 'CELL_FOR_FORM_END'                          THEN 'CELL_CHAR_AVAILABLE'
                       /* WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'미착'	THEN 'SEMI_INTRANSIT' */
                       WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA' AND IV.STORAGE_LOCATION = '미착' THEN /* 고도화 */
                            ( CASE WHEN II.OPERATION_ID IN ('P9500', 'P5500')                       THEN 'INTRANSIT'
                                   WHEN II.OPERATION_ID = 'P5000'                                   THEN 'SEMI_INTRANSIT'
                                   WHEN II.OPERATION_ID = 'A9000' AND II.FINISHED_PRODUCT  = 'Y'    THEN 'INTRANSIT'
                                   WHEN II.OPERATION_ID = 'A9000' AND II.FINISHED_PRODUCT != 'Y'    THEN 'SEMI_INTRANSIT'
                                   ELSE 'SEMI_INTRANSIT'
                              END )
                       /* E20251029-001009 : 7990 주석처리 / 7000이 아닌것은 제품/반제품 구분하여 분류 */
                       /* WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA'		AND IV.STORAGE_LOCATION = N'7990'	THEN 'INTRANSIT' */
                       WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA' AND IV.STORAGE_LOCATION = '7000' THEN
                            CASE WHEN II.OPERATION_ID IN ('P9500', 'P5500')                         THEN 'INTRANSIT'
                                 WHEN II.OPERATION_ID = 'P5000'                                     THEN 'SEMI_INTRANSIT'
                                 WHEN II.OPERATION_ID = 'A9000' AND II.FINISHED_PRODUCT  = 'Y'      THEN 'INTRANSIT'
                                 WHEN II.OPERATION_ID = 'A9000' AND II.FINISHED_PRODUCT != 'Y'      THEN 'SEMI_INTRANSIT'
                                 ELSE 'MISMATCH_INV'
                            END
                       /* E20251029-001009 : 7990 주석처리 / 7000이 아닌것은 제품/반제품 구분하여 분류 */
                       WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA' AND IV.STORAGE_LOCATION != '7000' THEN
                            CASE WHEN II.ITEM_TYPE = '제품'                                          THEN 'INTRANSIT'
                                 WHEN II.ITEM_TYPE = '반제품'                                        THEN 'SEMI_INTRANSIT'
                                 ELSE 'MISMATCH_INV'
                            END
                       WHEN SM.SIMU_MEASURE = 'VMI'                                        THEN 'TO_SITE_EOH'
                       WHEN SM.SIMU_MEASURE = 'AS'                                         THEN 'AS_INV'
                       WHEN SM.SIMU_MEASURE = 'INTRANSIT_ETA' AND IV.STORAGE_LOCATION = 'In-T' THEN 'INTRANSIT' /* 20250210 DJLEE 'IN-T' MAPPING */
                       ELSE 'MISMATCH_INV'
                  END
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : 월별 재고 미매칭 매저 별도관리');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */

        /* E20251028-000389 #TMP_SLOC_ADD_INFO 룩업에 매칭되지 않는것은 별도 매저로 관리 시작 */
        /* ★ PROCESS_GROUP 실데이터 표기는 'Cell'(AS-IS N'CELL' 은 대소문자 무시 비교) → UPPER 로 비교 */
        INSERT
          INTO GT_GPMM_TMP_ENDING_INV_MM
             ( ITEM_ID
             , YYYYMM
             , OPERATION_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , MEASURE
             , QTY
             )
        SELECT IV.ITEM_ID
             , IV.YYYYMM
             , '-'              AS OPERATION_ID
             , '-'              AS OPERATION_GROUP
             , '-'              AS FROM_SITE
             , '-'              AS TO_SITE
             , 'MISMATCH_INV'   AS MEASURE
             , SUM(IV.QUANTITY) AS QTY
          FROM GT_GPMM_TMP_ENDING_INV_MM_RAW          IV
             , GT_GPMM_TMP_TARGET_ITEM_FOR_ENDING_INV II
         WHERE II.ITEM_ID = IV.ITEM_ID
           AND NOT EXISTS (SELECT 1
                             FROM GT_GPMM_TMP_SLOC_ADD_INFO SM
                            WHERE SM.PLANT = IV.PLANT_ID
                              AND SM.SLOC  = IV.STORAGE_LOCATION)
           AND II.ITEM_TYPE IN ('반제품', '제품')            /* E20251028-000389 -- 반제품 / 제품 에서만 */
           AND UPPER(II.PROCESS_GROUP) IN ('모듈/팩', 'CELL') /* E20251028-000389 -- 모듈/CELL 만. */
           AND IV.STORAGE_LOCATION IS NOT NULL               /* 공백은것은 아래에서 로직처리 */
         GROUP BY IV.ITEM_ID
                , IV.YYYYMM
        ;
        /* E20251028-000389 #TMP_SLOC_ADD_INFO 룩업에 매칭되지 않는것은 별도 매저로 관리 끝 */

        /* Cosignment_stock[고객위탁재고]의 경우, S.loc이 공란이라 Key값으로 집계를 하지 못하여 제외하고 #TMP_ENDING_INV_MM 에 직접 입력함.	-- 고도화 */
        INSERT
          INTO GT_GPMM_TMP_ENDING_INV_MM
             ( ITEM_ID
             , YYYYMM
             , OPERATION_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , MEASURE
             , QTY
             )
        SELECT NVL(AM.CELL_ASSY_ITEM_ID, IV.ITEM_ID) AS ITEM_ID /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , IV.YYYYMM
             , II.OPERATION_ID
             , II.OPERATION_GROUP
             , NVL(FS.SCM_SITE_ID, '-') AS FROM_SITE
             , NVL(TS.SCM_SITE_ID, '-') AS TO_SITE
             , 'TO_SITE_EOH'            AS MEASURE
             , SUM(IV.QUANTITY)         AS QTY
          FROM SCP_ANL_MONTH_END_STOCK_R              IV
             , GT_GPMM_TMP_TARGET_ITEM_FOR_ENDING_INV II
             , GT_GPMM_SCM_MST_SITE                   FS /* from site */
             , GT_GPMM_SCM_MST_SITE                   TS /* to site */
               /* Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , GT_GPMM_SCP_EXC_ITEM_ASSY_MAP          AM
               /* End : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
         WHERE II.ITEM_ID              = IV.ITEM_ID
           AND FS.PLANT_ID(+)          = IV.PLANT_ID
           AND FS.OPERATION_GROUP(+)   = II.OPERATION_GROUP
           AND TS.OPERATION_GROUP(+)   = II.OPERATION_GROUP
           AND AM.COMPANY_ID(+)        = IV.COMPANY_ID
           AND AM.DIVISION_ID(+)       = IV.DIVISION_ID
           AND AM.PLANT_ID(+)          = IV.PLANT_ID
           AND AM.SCP_EXC_ITEM_ID(+)   = IV.ITEM_ID
           AND FS.SITE_TYPE(+)         = 'PLANT'
           AND TS.SITE_TYPE(+)         = 'PLANT'
           AND TS.PLANT_ID(+)          = 'Z'
           AND IV.SPECIAL_INVENTORY    = 'W'
           AND IV.STORAGE_LOCATION IS NOT NULL /* E20251029-001009 아래에서 STORAGE_LOCATION 가 공백인 로직처리함 */
           AND IV.DIVISION_ID          = V_DIVISION_ID
           AND IV.YYYYMM              >= V_INV_FROM_YYYYMM
           AND IV.YYYYMM              <= V_INV_TO_YYYYMM
         GROUP BY NVL(AM.CELL_ASSY_ITEM_ID, IV.ITEM_ID) /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
                , IV.YYYYMM
                , II.OPERATION_ID
                , II.OPERATION_GROUP
                , NVL(FS.SCM_SITE_ID, '-')
                , NVL(TS.SCM_SITE_ID, '-')
        ;

        /* 20250210 DJLEE SLOC & DESC 정보가 ''  건이 있음. (NERP 전환후) */
        /* 20251126 SLOC 공백 DESC 공백인건 / 공백이 아닌건으로 구분하여 로직 수행 */
        INSERT
          INTO GT_GPMM_TMP_ENDING_INV_MM
             ( ITEM_ID
             , YYYYMM
             , OPERATION_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , MEASURE
             , QTY
             )
        SELECT NVL(AM.CELL_ASSY_ITEM_ID, IV.ITEM_ID) AS ITEM_ID /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , IV.YYYYMM
             , II.OPERATION_ID
             , II.OPERATION_GROUP
             , NVL(FS.SCM_SITE_ID, '-') AS FROM_SITE
             , NVL(TS.SCM_SITE_ID, '-') AS TO_SITE
             , 'TO_SITE_EOH'            AS MEASURE
             , SUM(IV.QUANTITY)         AS QTY
          FROM SCP_ANL_MONTH_END_STOCK_R              IV
             , GT_GPMM_TMP_TARGET_ITEM_FOR_ENDING_INV II
             , GT_GPMM_SCM_MST_SITE                   FS /* from site */
             , GT_GPMM_SCM_MST_SITE                   TS /* to site */
               /* Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , GT_GPMM_SCP_EXC_ITEM_ASSY_MAP          AM
               /* End : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
         WHERE II.ITEM_ID              = IV.ITEM_ID
           AND FS.PLANT_ID(+)          = IV.PLANT_ID
           AND FS.OPERATION_GROUP(+)   = II.OPERATION_GROUP
           AND TS.OPERATION_GROUP(+)   = II.OPERATION_GROUP
           AND AM.COMPANY_ID(+)        = IV.COMPANY_ID
           AND AM.DIVISION_ID(+)       = IV.DIVISION_ID
           AND AM.PLANT_ID(+)          = IV.PLANT_ID
           AND AM.SCP_EXC_ITEM_ID(+)   = IV.ITEM_ID
           AND FS.SITE_TYPE(+)         = 'PLANT'
           AND TS.SITE_TYPE(+)         = 'PLANT'
           AND TS.PLANT_ID(+)          = 'Z'
           AND IV.STORAGE_LOCATION IS NULL
           AND IV.STORAGE_DESC IS NOT NULL /* E20251029-001009 STORAGE_LOCATION : 공백 , STORAGE_DESC 공백이 아닌경우는 VMI 로 표시. */
           /* AND ISNULL(IV.STORAGE_DESC, '') = '' -- E20251029-001009 기존로직 주석처리 */
           AND IV.DIVISION_ID          = V_DIVISION_ID
           AND IV.YYYYMM              >= V_INV_FROM_YYYYMM
           AND IV.YYYYMM              <= V_INV_TO_YYYYMM
         GROUP BY NVL(AM.CELL_ASSY_ITEM_ID, IV.ITEM_ID) /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
                , IV.YYYYMM
                , II.OPERATION_ID
                , II.OPERATION_GROUP
                , NVL(FS.SCM_SITE_ID, '-')
                , NVL(TS.SCM_SITE_ID, '-')
        ;

        /* E20251029-001009 STORAGE_LOCATION 공백 STORAGE_DESC 공백은 제품/반제품 구분으로 INTRANSIT / SEME_INTRANSIT 시작 */
        INSERT
          INTO GT_GPMM_TMP_ENDING_INV_MM
             ( ITEM_ID
             , YYYYMM
             , OPERATION_ID
             , OPERATION_GROUP
             , FROM_SITE
             , TO_SITE
             , MEASURE
             , QTY
             )
        SELECT NVL(AM.CELL_ASSY_ITEM_ID, IV.ITEM_ID) AS ITEM_ID /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , IV.YYYYMM
             , II.OPERATION_ID
             , II.OPERATION_GROUP
             , NVL(FS.SCM_SITE_ID, '-') AS FROM_SITE
             , NVL(TS.SCM_SITE_ID, '-') AS TO_SITE
             , CASE WHEN II.ITEM_TYPE = '제품'   THEN 'INTRANSIT'
                    WHEN II.ITEM_TYPE = '반제품' THEN 'SEMI_INTRANSIT'
                    ELSE 'MISMATCH_INV'
               END                      AS MEASURE
             , SUM(IV.QUANTITY)         AS QTY
          FROM SCP_ANL_MONTH_END_STOCK_R              IV
             , GT_GPMM_TMP_TARGET_ITEM_FOR_ENDING_INV II
             , GT_GPMM_SCM_MST_SITE                   FS /* from site */
             , GT_GPMM_SCM_MST_SITE                   TS /* to site */
               /* Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , GT_GPMM_SCP_EXC_ITEM_ASSY_MAP          AM
               /* End : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
         WHERE II.ITEM_ID              = IV.ITEM_ID
           AND FS.PLANT_ID(+)          = IV.PLANT_ID
           AND FS.OPERATION_GROUP(+)   = II.OPERATION_GROUP
           AND TS.OPERATION_GROUP(+)   = II.OPERATION_GROUP
           AND AM.COMPANY_ID(+)        = IV.COMPANY_ID
           AND AM.DIVISION_ID(+)       = IV.DIVISION_ID
           AND AM.PLANT_ID(+)          = IV.PLANT_ID
           AND AM.SCP_EXC_ITEM_ID(+)   = IV.ITEM_ID
           AND FS.SITE_TYPE(+)         = 'PLANT'
           AND TS.SITE_TYPE(+)         = 'PLANT'
           AND TS.PLANT_ID(+)          = 'Z'
           AND IV.STORAGE_LOCATION IS NULL
           AND IV.STORAGE_DESC IS NULL
           AND IV.DIVISION_ID          = V_DIVISION_ID
           AND IV.YYYYMM              >= V_INV_FROM_YYYYMM
           AND IV.YYYYMM              <= V_INV_TO_YYYYMM
         GROUP BY NVL(AM.CELL_ASSY_ITEM_ID, IV.ITEM_ID) /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
                , IV.YYYYMM
                , II.OPERATION_ID
                , II.OPERATION_GROUP
                , NVL(FS.SCM_SITE_ID, '-')
                , NVL(TS.SCM_SITE_ID, '-')
                , CASE WHEN II.ITEM_TYPE = '제품'   THEN 'INTRANSIT'
                       WHEN II.ITEM_TYPE = '반제품' THEN 'SEMI_INTRANSIT'
                       ELSE 'MISMATCH_INV'
                  END
        ;

        /* E20251029-001009 STORAGE_LOCATION 공백 STORAGE_DESC 공백은 제품/반제품 구분으로 INTRANSIT / SEME_INTRANSIT 끝 */

        DELETE FROM GT_GPMM_TMP_ENDING_INV_MM_RAW;


/* START : 과거구간 */
/* START : 과거구간 */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : Char. Available / Formation Progress 분리');
        /* 2023.11.22 요구사항 */
        /* 과거 실적의 활성화와 특성 분리 */
        /* 현재 로직 : 과거 실적 재고 중에 활성화 재고는 모두 Char. Available에 반영되어 있음 */
        /* 이것을 Remain Lead Time이 0이 아닌 것을 Ending Inventory에서 Formation Progress로 차감하여 반영 */
        /* 만약 해당 cutoff 일의 Formation Progress > Ending Inventory 이면 Ending Inventory이 Max 값으로 설정 */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : FP Aging Stock');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_FP_AGING_STOCK;

        INSERT
          INTO GT_GPMM_FP_AGING_STOCK
             ( YYYYMM
             , CUTOFF_DATE
             , FROM_SITE
             , ITEM_ID
             , FP_CHAR_AVAILABLE
             , FP_FORM_PROGRESS
             , FP_AGING_TOTAL
             , DIV
             )
        SELECT ML.YYYYMM
             , SA.CUTOFF_DATE
             , PS.SCM_SITE_ID                                               AS FROM_SITE
             , NVL(AM.CELL_ASSY_ITEM_ID, SA.ITEM_ID)                        AS ITEM_ID /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , SUM(CASE WHEN SA.REMAIN_LEAD_TIME = 0 THEN SA.QTY ELSE 0 END) AS FP_CHAR_AVAILABLE
             , SUM(CASE WHEN SA.REMAIN_LEAD_TIME > 0 THEN SA.QTY ELSE 0 END) AS FP_FORM_PROGRESS
             , SUM(SA.QTY)                                                  AS FP_AGING_TOTAL
             , 'A'                                                          AS DIV
          FROM GT_GPMM_TMP_MM_LIST           ML
             , SCM_DNM_STOCK_AGING_SN_V      SA /* [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV FP 활성화 재고를 ESS MI 법인 가상사이트 재고로 치환하여 정보 형성 (SCM_DNM_STOCK_AGING_SN를 SCM_DNM_STOCK_AGING_SN_V로 대체 참조) */
             , GT_GPMM_SCM_MST_SITE          PS
               /* Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
             , GT_GPMM_SCP_EXC_ITEM_ASSY_MAP AM
               /* End : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
         WHERE SA.CUTOFF_DATE        = ML.MONTHLY_TO_YMD_NEXT_DAY
           AND PS.PLANT_ID           = SA.PLANT_ID
           AND AM.COMPANY_ID(+)      = SA.COMPANY_ID
           AND AM.DIVISION_ID(+)     = SA.DIVISION_ID
           AND AM.PLANT_ID(+)        = SA.PLANT_ID
           AND AM.SCP_EXC_ITEM_ID(+) = SA.ITEM_ID
           AND PS.SITE_TYPE          = 'PLANT'
           AND PS.OPERATION_GROUP    = 'A' /* Cell */
           AND SA.DIVISION_ID        = V_DIVISION_ID
           AND ML.YYYYMM             < V_PLAN_START_YYYYMM /* 과거 실적 구간 */
         GROUP BY ML.YYYYMM
                , SA.CUTOFF_DATE
                , PS.SCM_SITE_ID
                , NVL(AM.CELL_ASSY_ITEM_ID, SA.ITEM_ID) /* PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : FP Aging Stock (현재 없는 기 적재된 데이터)');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPMM_FP_AGING_STOCK
             ( YYYYMM
             , CUTOFF_DATE
             , FROM_SITE
             , ITEM_ID
             , FP_CHAR_AVAILABLE
             , FP_FORM_PROGRESS
             , FP_AGING_TOTAL
             , DIV
             )
        SELECT GP.YYYYMM
             , TO_DATE(GP.VARIOUS_KEY, 'YYYYMMDD')     AS CUTOFF_DATE
             , GP.FROM_SITE
             , GP.ITEM_ID
             , CAST(GP.ATTRIBUTE1 AS NUMBER(20, 10))   AS FP_CHAR_AAILABLE
             , GP.QTY                                  AS FP_FORM_PROGRESS
             , CAST(GP.ATTRIBUTE2 AS NUMBER(20, 10))   AS FP_AGING_TOTAL
             , 'B'                                     AS DIV
          FROM SCP_RPT_GLOBAL_PSI_MD_MM GP
         WHERE NOT EXISTS (SELECT 1
                             FROM GT_GPMM_FP_AGING_STOCK SA
                            WHERE SA.YYYYMM    = GP.YYYYMM
                              AND SA.FROM_SITE = GP.FROM_SITE
                              AND SA.ITEM_ID   = GP.ITEM_ID)
           AND GP.PLAN_START_YYYYMMDD = '00000000'
           AND GP.PLAN_TYPE           = 'FN' /* E20260708-000926	FN 고정 */
           AND GP.MEASURE             = 'FORM_PROGRESS'
           AND GP.DIVISION_ID         = V_DIVISION_ID
           AND GP.YYYYMM              < V_PLAN_START_YYYYMM /* 과거 실적 구간 */
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : Char. Available / Formation Progress - FP Aging Stock 반영');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_PAST_FORM_PROGRESS_CHAR_AVAILABLE;

        INSERT
          INTO GT_GPMM_PAST_FORM_PROGRESS_CHAR_AVAILABLE
             ( YYYYMM
             , ITEM_ID
             , FROM_SITE
             , OPERATION_GROUP
             , CHAR_AVAILABLE
             , FORM_PROGRESS
             , ENDING_INVENTORY
             , FP_FORM_PROGRESS
             )
        SELECT MI.YYYYMM
             , MI.ITEM_ID
             , MI.FROM_SITE                   AS FROM_SITE
             , MI.OPERATION_GROUP             AS OPERATION_GROUP
             , CASE WHEN MI.QTY >= NVL(FA.FP_FORM_PROGRESS, 0)
                    THEN MI.QTY - NVL(FA.FP_FORM_PROGRESS, 0)
                    ELSE 0
               END                            AS CHAR_AVAILABLE
             , CASE WHEN MI.QTY >= NVL(FA.FP_FORM_PROGRESS, 0)
                    THEN NVL(FA.FP_FORM_PROGRESS, 0)
                    ELSE MI.QTY
               END                            AS FORM_PROGRESS
             , MI.QTY                         AS ENDING_INVENTORY
             , NVL(FA.FP_FORM_PROGRESS, 0)    AS FP_FORM_PROGRESS
          FROM GT_GPMM_TMP_ENDING_INV_MM MI
             , GT_GPMM_FP_AGING_STOCK    FA
         WHERE FA.YYYYMM(+)    = MI.YYYYMM
           AND FA.FROM_SITE(+) = MI.FROM_SITE
           AND FA.ITEM_ID(+)   = MI.ITEM_ID
           AND MI.MEASURE      = 'CELL_CHAR_AVAILABLE'
           AND MI.YYYYMM       < V_PLAN_START_YYYYMM /* 과거 실적 구간 */
        ;
        /* -------------- END Ending Inventory (과거 실적 구간 재고)	--- 위치 변경 */


        /* -------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : #SCP_PLN_TH_ENG_STOCK_PLAN ');
        /* -------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_SCP_PLN_TH_ENG_STOCK_PLAN;

        INSERT
          INTO GT_GPMM_SCP_PLN_TH_ENG_STOCK_PLAN
             ( ITEM_ID
             , SITE_ID
             , RECEIVING_DTTM
             , YYYYMMDD
             , QTY
             , LOT_ID
             , DESCR
             , INSP_TYPE
             )
        SELECT ES.ITEM_ID
             , ES.SITE_ID
             , ES.RECEIVING_DTTM
             , TO_CHAR(ES.RECEIVING_DTTM, 'YYYYMMDD') AS YYYYMMDD
             , ES.QTY
             , ES.LOT_ID
             , ES.DESCR
             , ES.INSP_TYPE
          FROM SCP_PLN_TH_ENG_STOCK_PLAN ES
         WHERE ES.MASTER_ID = V_MASTER_ID
           AND ES.PLAN_ID   = V_ENG_PLAN_ID
        ;

        /* --------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : 기존 Global PSI Raw 데이터 ');
        /* --------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_SCP_ANL_PSI_GLOBAL;

        INSERT
          INTO GT_GPMM_SCP_ANL_PSI_GLOBAL
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
             , TS_OPERATION_GROUP
             )
        SELECT PG.OPERATION_GROUP
             , PG.ITEM_ID
             , PG.TO_SITE
             , PG.INCOTERMS
             , PG.FROM_SITE
             , PG.TRANSPORT_MODE_LINE
             , PG.YYYYMMDD
             , PG.ATTRIBUTE1
             , PG.FROM_BOH_QTY
             , PG.TO_BOH_QTY
             , PG.MEASURE
             , PG.QTY
             , TS.SITE_TYPE       AS TS_SITE_TYPE
             , TS.OPERATION_GROUP AS TS_OPERATION_GROUP
          FROM SCP_ANL_PSI_GLOBAL   PG
             , GT_GPMM_SCM_MST_SITE TS
         WHERE TS.SCM_SITE_ID(+)       = PG.TO_SITE
           AND PG.MEASURE IN ( 'WH_IN'
                             , 'SHIP_PLAN'
                             , 'PRODUCTION'
                             /* 20231122 임시로 별도 산식에서 계산 적용 (* 향후 Simulator Char. Plan 저장값이 FN에 확정계획으로 반영될 시 현재 산식기준으로 원복) ,'ACTIVATE_COMPLETED'	-- 특성(F6000) 생산계획 -- CELL_CHAR_PLAN */
                             , 'MODEL_INVENTORY' /* 재고(EOH) */
                             )
           AND PG.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND PG.PLAN_TYPE            = V_PLAN_TYPE
           AND PG.SEQ                  = V_PLAN_SEQ
           AND PG.DIVISION_ID          = V_DIVISION_ID
        ;

        /* 81 Division 일 경우 Ship Plan 정보를 WH_IN 으로 넣어준다. */
        INSERT
          INTO GT_GPMM_SCP_ANL_PSI_GLOBAL
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
             , TS_OPERATION_GROUP
             )
        SELECT PG.OPERATION_GROUP
             , PG.ITEM_ID
             , PG.TO_SITE
             , PG.INCOTERMS
             , PG.FROM_SITE
             , PG.TRANSPORT_MODE_LINE
             , TO_CHAR(TO_DATE(PG.YYYYMMDD, 'YYYYMMDD') + 24, 'YYYYMMDD') AS YYYYMMDD /* LT 24 적용 */
             , PG.ATTRIBUTE1
             , PG.FROM_BOH_QTY
             , PG.TO_BOH_QTY
             , 'WH_IN'            AS MEASURE
             , PG.QTY
             , TS.SITE_TYPE       AS TS_SITE_TYPE
             , TS.OPERATION_GROUP AS TS_OPERATION_GROUP
          FROM SCP_ANL_PSI_GLOBAL   PG
             , GT_GPMM_SCM_MST_SITE TS
         WHERE TS.SCM_SITE_ID(+)       = PG.TO_SITE
           AND PG.MEASURE              = 'SHIP_PLAN'
           AND PG.ITEM_ID           LIKE 'ACEH1131I-B1%'
           AND PG.TO_SITE              = 'ESST_CA_WND'
           AND PG.QTY                 <> 0
           AND V_DIVISION_ID           = '81' /* 1=(CASE WHEN @V_DIVISION_ID = '81' THEN 1 ELSE 0 END) */
           AND PG.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND PG.PLAN_TYPE            = V_PLAN_TYPE
           AND PG.SEQ                  = V_PLAN_SEQ
           /* AND PG.DIVISION_ID			= '81_ST'--@V_DIVISION_ID */
        ;
        /* ------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : 기존 Global PSI Raw 데이터 - asis 기준 재고 삭제 (pack plant cell재고 제외) ');
        /* ------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM GT_GPMM_SCP_ANL_PSI_GLOBAL PG
         WHERE PG.MEASURE     = 'MODEL_INVENTORY'
           AND PG.ATTRIBUTE1 != 'CELL' /* - pack plant cell재고를 제외 하고 asis 재고 데이터 삭제 */
        ;

        /* ------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : 기존 Global PSI Raw 데이터 - asis 기준 재고 삭제 (to Sales Site WH In) ');
        /* ------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM GT_GPMM_SCP_ANL_PSI_GLOBAL PG
         WHERE PG.MEASURE IN ('WH_IN', 'SHIP_PLAN') /* intransit 계산시 AS 빠져서 ship_plan 도 제외 -- 고도화 */
           AND PG.TS_OPERATION_GROUP = 'W'
           AND PG.TS_SITE_TYPE       = 'SALES'
        ;

        /* ------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : 기존 Global PSI Raw 데이터 - AMDAU% PRODUCTION 삭제 ');
        /* ------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM GT_GPMM_SCP_ANL_PSI_GLOBAL PG
         WHERE PG.MEASURE    = 'PRODUCTION'
           AND PG.ITEM_ID LIKE 'AMDAU%'
        ;

        /* --------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : 기존 Global PSI 참조 Measure ');
        /* --------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_ASIS_GLOBAL_PSI;

        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT PG.OPERATION_GROUP
             , PG.ITEM_ID
             , PG.TO_SITE
             , PG.INCOTERMS
             , PG.FROM_SITE
             , PG.TRANSPORT_MODE_LINE
             , DI.YYYYMM
             , CASE WHEN PG.MEASURE = 'ACTIVATE_COMPLETED'
                    THEN 'CELL_CHAR_PLAN'
                    ELSE PG.MEASURE
               END AS MEASURE
             , CASE WHEN PG.MEASURE = 'MODEL_INVENTORY' AND PG.ATTRIBUTE1 = 'CELL'
                    THEN 'Y'
                    ELSE 'N'
               END AS IS_CELL_IN_PACK_PLANT
             , PG.FROM_BOH_QTY
             , PG.TO_BOH_QTY
             , SUM(CASE WHEN PG.MEASURE  = 'MODEL_INVENTORY' AND DI.MONTHLY_TO_YMD = PG.YYYYMMDD
                        THEN PG.QTY
                        WHEN PG.MEASURE != 'MODEL_INVENTORY'
                        THEN PG.QTY
                        ELSE 0.0 END) AS QTY /* 재고는 월말 기준 데이터로 적재 */
          FROM GT_GPMM_SCP_ANL_PSI_GLOBAL PG
             , GT_GPMM_TMP_DATE_INFO      DI
         WHERE DI.YYYYMMDD = PG.YYYYMMDD
         GROUP BY PG.OPERATION_GROUP
                , PG.ITEM_ID
                , PG.TO_SITE
                , PG.INCOTERMS
                , PG.FROM_SITE
                , PG.TRANSPORT_MODE_LINE
                , DI.YYYYMM
                , PG.MEASURE
                , CASE WHEN PG.MEASURE = 'MODEL_INVENTORY' AND PG.ATTRIBUTE1 = 'CELL'
                       THEN 'Y'
                       ELSE 'N'
                  END
                , PG.FROM_BOH_QTY
                , PG.TO_BOH_QTY
        ;


        /* -------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : MKT_FCST/RTF(DM 참조) Measure 추가');
        /* 계획 구간 WH_IN_BLANCE 계산 후 추가함. */
        /* plan 주차 해당월 WH_IN_BALANCE 계산시 적용 안함 - plan date 기준 BOH 및 계획 수량 정보로 계산함 */
        /* -------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_FCST_RTF_RESULT;

        INSERT
          INTO GT_GPMM_FCST_RTF_RESULT
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , YYYYMM
             , MEASURE
             , IS_CEL_INVENTORY
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
          WITH MEASURE_INFO AS (
               SELECT 'MKT_FCST' AS MEASURE
                    , 'RTF_SYS_RP' AS DM_MEASURE /* MKT FCST[R+P] */
                 FROM DUAL
                UNION ALL
               SELECT 'RTF'      AS MEASURE
                    , 'RTF_SYS_RP' AS DM_MEASURE /* RTF[R+P] */
                 FROM DUAL
               )
        SELECT MK.OPERATION_GROUP
             , MK.ITEM_ID
             , MK.TO_SITE
             , MK.INCOTERMS
             , '-'          AS FROM_SITE /* SCP global psi는 to 사이트 기준 데이터임 */
             , MK.TRANSPORT_MODE
             , MK.YYYYMM
             , MK.MEASURE
             , 'N'          AS IS_CEL_INVENTORY
             , 0.0          AS FROM_BOH_QTY
             , 0.0          AS TO_BOH_QTY
             , SUM(MK.QTY)  AS QTY
          FROM (SELECT FI.OPERATION_GROUP
                     , FI.ITEM_ID
                     , MK.SCM_SITE_ID  AS TO_SITE
                     , MK.INCOTERMS
                     , MK.PROJECT_CODE AS TRANSPORT_MODE
                     , DI.YYYYMM
                       /* ,CASE WHEN MK.FCST_TYPE = 'WS' THEN 'AS_' ELSE '' END + MI.MEASURE AS MEASURE  -- 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경 */
                     , CASE WHEN MK.FCST_TYPE IN (SELECT FCST_TYPE
                                                    FROM GT_GPMM_TMP_AS_SALES_TYPE_CODE) THEN 'AS_' ELSE '' END || MI.MEASURE AS MEASURE
                     , MK.QTY          AS QTY
                  FROM DM_PLN_MKT_FCST_RESULT_C   MK
                     , GT_GPMM_SCP_MST_FINAL_ITEM FI
                     , MEASURE_INFO               MI
                     , GT_GPMM_SCM_MST_SITE       MS
                     , GT_GPMM_TMP_DATE_INFO      DI
                 WHERE FI.ITEM_ID      = MK.ITEM_ID
                   AND MI.DM_MEASURE   = MK.MEASURE
                   AND MS.SCM_SITE_ID  = MK.SCM_SITE_ID
                   AND DI.YYYYMMDD     = MK.YYYYMMDD
                   AND MS.SITE_TYPE    = 'SALES'
                   AND MK.QTY         != 0
                   AND MK.DIVISION_ID  = V_DIVISION_ID
                   AND MK.VERSION_NO   = V_DM_VERSION_NO
               ) MK
         GROUP BY MK.OPERATION_GROUP
                , MK.ITEM_ID
                , MK.TO_SITE
                , MK.INCOTERMS
                , MK.TRANSPORT_MODE
                , MK.YYYYMM
                  /* ,CASE WHEN MK.FCST_TYPE = 'WS' THEN 'AS_' ELSE '' END + MI.MEASURE  -- 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경 */
                , MK.MEASURE
        ;

        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE
             , YYYYMM
             , MEASURE
             , IS_CEL_INVENTORY
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
          FROM GT_GPMM_FCST_RTF_RESULT
        ;


        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 생산 실적 Raw Data - 대상 Operation');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_PRODUCTION_OPERATION;

        INSERT
          INTO GT_GPMM_PRODUCTION_OPERATION
             ( OPERATION_ID
             )
        SELECT A.OPERATION_ID
          FROM (SELECT L.SEGMENT1 AS OPERATION_ID
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
                 WHERE L.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                   AND L.VALID_YN    = 'Y'
                   AND L.SEGMENT4 LIKE '%' || V_DIVISION_ID || '%'
                 UNION
                SELECT PS.PLANT_ID /* 외주 Packer 실적 Operation */
                  FROM GT_GPMM_SCM_MST_SITE PS
                 WHERE PS.SITE_TYPE = 'PLANT'
                   AND PS.OSP_YN    = 'Y'
                   AND PS.VALID_YN  = 'Y'
                 UNION
                SELECT 'F6000' /* 셀 특성 */
                  FROM DUAL
               ) A
        ;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 생산 실적 Raw Data');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_PRODUCTION_RESULT;

        INSERT
          INTO GT_GPMM_PRODUCTION_RESULT
             ( FROM_SITE
             , OPERATION_GROUP
             , PLANT_ID
             , ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , PLAN_YYYYMMDD
             , ACTUAL_GOOD_QTY
             )
        SELECT FS.SCM_SITE_ID                    AS FROM_SITE
             , B.SCP_OPERATION_GROUP             AS OPERATION_GROUP
             , A.PLANT_ID
             , A.ITEM_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , TO_CHAR(A.PLAN_DATE, 'YYYYMMDD') AS PLAN_YYYYMMDD
             , A.ACTUAL_GOOD_QTY
          FROM SCM_DNM_DAILY_PRODUCT_RESULT_SN A /* SCM_DNM_DAILY_PRODUCT_RESULT_SN */
             , SCM_MST_ITEM_SN                 B /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
             , GT_GPMM_SCM_MST_SITE            FS
         WHERE B.COMPANY_ID             = A.COMPANY_ID
           AND B.DIVISION_ID            = A.DIVISION_ID
           AND B.SITE_ID                = A.SITE_ID
           AND B.ITEM_ID                = A.ITEM_ID
           AND FS.PLANT_ID(+)           = A.PLANT_ID
           AND FS.OPERATION_GROUP(+)    = B.SCP_OPERATION_GROUP
           AND A.OPERATION_ID IN (SELECT OPERATION_ID
                                    FROM GT_GPMM_PRODUCTION_OPERATION)
           AND NOT EXISTS (/* (2024.09.02 변경건) */
                           SELECT 1
                             FROM GT_GPMM_MODULE_MODEL_INFO MI
                            WHERE MI.PACK_MODULE_ITEM = 'Y'
                              AND MI.MODEL_ID         = A.ITEM_ID
                          )
           AND B.SCP_OPERATION_GROUP IS NOT NULL      /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
           AND B.SCP_OPERATION_GROUP IN ('A', 'P')    /* cell/pack만 */
           AND FS.SITE_TYPE(+)          = 'PLANT'
           AND FS.VALID_YN(+)           = 'Y'
           AND A.PRODUCTION_TYPE NOT IN ('REWORK', 'PILOT') /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
           AND A.DIVISION_ID            = V_DIVISION_ID
           AND A.PLAN_DATE             >= V_RESULT_FROM_DATE
           AND A.PLAN_DATE              < V_PLAN_START_DATE
        ;

        /* P5200 공정 실적 P5500 으로 변경 	-- (2024.09.02 변경건) */
        INSERT
          INTO GT_GPMM_PRODUCTION_RESULT
             ( FROM_SITE
             , OPERATION_GROUP
             , PLANT_ID
             , ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , PLAN_YYYYMMDD
             , ACTUAL_GOOD_QTY
             )
        SELECT FS.SCM_SITE_ID                    AS FROM_SITE
             , B.SCP_OPERATION_GROUP             AS OPERATION_GROUP
             , A.PLANT_ID
             , MI.MODEL_ID                       AS ITEM_ID /* A.ITEM_ID */
             , 'P5500'                           AS OPERATION_ID
             , A.LINE_ID
             , TO_CHAR(A.PLAN_DATE, 'YYYYMMDD') AS PLAN_YYYYMMDD
             , A.ACTUAL_GOOD_QTY
          FROM SCM_DNM_DAILY_PRODUCT_RESULT_SN A /* SCM_DNM_DAILY_PRODUCT_RESULT_SN */
             , SCM_MST_ITEM_SN                 B /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
             , GT_GPMM_SCM_MST_SITE            FS
             , GT_GPMM_MODULE_MODEL_INFO       MI
         WHERE B.COMPANY_ID             = A.COMPANY_ID
           AND B.DIVISION_ID            = A.DIVISION_ID
           AND B.SITE_ID                = A.SITE_ID
           AND B.ITEM_ID                = A.ITEM_ID
           AND FS.PLANT_ID(+)           = A.PLANT_ID
           AND FS.OPERATION_GROUP(+)    = B.SCP_OPERATION_GROUP
           AND MI.MODULE_ID             = A.ITEM_ID
           AND B.SCP_OPERATION_GROUP IS NOT NULL      /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
           AND B.SCP_OPERATION_GROUP IN ('P')         /* cell/pack만 */
           AND FS.SITE_TYPE(+)          = 'PLANT'
           AND FS.VALID_YN(+)           = 'Y'
           AND MI.PACK_MODULE_ITEM      = 'Y'
           AND A.PRODUCTION_TYPE NOT IN ('REWORK', 'PILOT') /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
           AND A.OPERATION_ID           = 'P5200'
           AND A.DIVISION_ID            = V_DIVISION_ID
           AND A.PLAN_DATE             >= V_RESULT_FROM_DATE
           AND A.PLAN_DATE              < V_PLAN_START_DATE
        ;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 생산 실적 Measure 추가');
        /* --------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT P.OPERATION_GROUP
             , P.ITEM_ID
             , '-'                     AS TO_SITE
             , '-'                     AS INCOTERMS
             , P.FROM_SITE
             , P.LINE_ID               AS TRANSPORT_MODE_LINE
             , DI.YYYYMM
             , 'PRODUCTION'            AS MEASURE
             , 'N'                     AS IS_CELL_IN_PACK_PLANT
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , SUM(P.ACTUAL_GOOD_QTY)  AS QTY
          FROM GT_GPMM_PRODUCTION_RESULT P
             , GT_GPMM_TMP_DATE_INFO     DI
         WHERE DI.YYYYMMDD     = P.PLAN_YYYYMMDD
           AND P.OPERATION_ID != 'F6000' /* 셀 특성 제외 */
         GROUP BY P.OPERATION_GROUP
                , P.ITEM_ID
                , P.FROM_SITE
                , P.LINE_ID
                , DI.YYYYMM
        ;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 생산 실적 Measure 추가 (셀 특성 F6000) ');
        /* --------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT P.OPERATION_GROUP
             , P.ITEM_ID
             , '-'                     AS TO_SITE
             , '-'                     AS INCOTERMS
             , P.FROM_SITE
             , P.LINE_ID               AS TRANSPORT_MODE_LINE
             , DI.YYYYMM
             , 'CELL_CHAR_PLAN'        AS MEASURE
             , 'N'                     AS IS_CELL_IN_PACK_PLANT
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , SUM(P.ACTUAL_GOOD_QTY)  AS QTY
          FROM GT_GPMM_PRODUCTION_RESULT P
             , GT_GPMM_TMP_DATE_INFO     DI
         WHERE DI.YYYYMMDD    = P.PLAN_YYYYMMDD
           AND P.OPERATION_ID = 'F6000' /* 셀 특성만 */
         GROUP BY P.OPERATION_GROUP
                , P.ITEM_ID
                , P.FROM_SITE
                , P.LINE_ID
                , DI.YYYYMM
        ;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 출하 실적 Raw Data');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_SHIPMENT_RESULT;

        DELETE FROM GT_GPMM_SHIPTO_CODE;

        INSERT
          INTO GT_GPMM_SHIPTO_CODE
             ( SHIPTO_CODE
             )
        SELECT SC.SHIPTO_CODE
          FROM (SELECT DISTINCT
                       SC.SHIPTO_CODE
                  FROM XIF_ERP_SALES_RESULT_R_SN SC
                 WHERE SC.ATTRIBUTE1 IN (SELECT FCST_TYPE
                                           FROM GT_GPMM_TMP_AS_SALES_TYPE_CODE) /* 'WS' 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경 */
                   AND SC.IFSEQNO = (/* 가장 최신번호(높은숫자)로 설정필요. 근 2개월 치 들어옴 (G-PSI 재고/실적 업데이트 구간 및 주기 확인필요) */
                                     SELECT MAX(IFSEQNO)
                                       FROM XIF_ERP_SALES_RESULT_R_SN
                                      WHERE ATTRIBUTE1 IN (SELECT FCST_TYPE
                                                             FROM GT_GPMM_TMP_AS_SALES_TYPE_CODE) /* 'WS' 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경 */
                                        AND DIVISION_ID = V_DIVISION_ID /* 해당 DIVISION 정보 (JV 포함되어야) */
                                    )
                   AND SC.DIVISION_ID = V_DIVISION_ID /* 해당 DIVISION 정보 (JV 포함되어야) */
                 UNION ALL
                SELECT 'XXXX' AS SHIPTO_CODE
                  FROM DUAL
               ) SC
        ;

        INSERT
          INTO GT_GPMM_SHIPMENT_RESULT
             ( ITEM_ID
             , FROM_SITE
             , TO_SITE
             , TO_SITE_TYPE
             , INCOTERMS
             , TRANSPORT_MODE
             , EXFACTORY_YYYYMMDD
             , EXFACTORY_QTY
             , OPERATION_GROUP
             )
        SELECT SR.ITEM_ID
             , NVL(SR.FROM_SCM_SITE_ID, '-') AS FROM_SITE
             , SR.TO_SCM_SITE_ID             AS TO_SITE
             , TS.SITE_TYPE                  AS TO_SITE_TYPE
             , SR.INCOTERMS
             , SR.TRANSPORT_MODE
             , SR.EXFACTORY_DATE             AS EXFACTORY_YYYYMMDD
             , SR.EXFACTORY_QTY
             , FI.OPERATION_GROUP
          FROM SCM_DNM_EXFACTORY_RESULT   SR
             , GT_GPMM_SCP_MST_FINAL_ITEM FI
             , GT_GPMM_SCM_MST_SITE       TS
         WHERE FI.ITEM_ID              = SR.ITEM_ID
           AND TS.SCM_SITE_ID          = SR.TO_SCM_SITE_ID
            /* AND SR.SSP_TYPE IN  --N국간거래 따른 중복값 제거 (SHIP FG 값통일) */
           AND EXISTS (SELECT 1
                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL LD
                        WHERE LD.LOOKUP_TYPE = 'ERP_SSP_TYPE'
                          AND LD.VALID_YN    = 'Y'
                          /* AND LD.SEGMENT1 = SR.SSP_TYPE */
                          AND (LD.SEGMENT1 = SR.SSP_TYPE OR SR.SSP_TYPE IS NULL)
                      )
        /*  AND SR.SHIPTO_CODE NOT IN --WS 출하 정보 제외 (매출 실적기반으로 하는수 밖에없음) */
           AND NOT EXISTS (SELECT 1
                             FROM GT_GPMM_SHIPTO_CODE SC
                            WHERE SC.SHIPTO_CODE = SR.SHIPTO_CODE

                              /* JV 속도가 느려 temp 로 변경 */
                              /*
								SELECT SHIPTO_CODE
								FROM	(
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
											UNION ALL
											SELECT 'XXXX' SHIPTO_CODE
										) SC
								WHERE	1=1
								AND SC.SHIPTO_CODE = SR.SHIPTO_CODE
							*/
                          )
           AND FI.OPERATION_GROUP IN ('A', 'P') /* Cell/Pack만 */
           AND SR.EXFACTORY_STATUS IN ('D20', 'D30', 'D40')
           AND SR.EXFACTORY_DATE      >= V_RESULT_FROM_YYYYMMDD
           AND SR.EXFACTORY_DATE       < V_PLAN_START_YYYYMMDD
           AND SR.DIVISION_ID          = V_DIVISION_ID

		/*
		  AND SR.SSP_TYPE IN  --N국간거래 따른 중복값 제거 (SHIP FG 값통일)	-- (2024.09.02 변경건)
							(
								SELECT DISTINCT SEGMENT1
								FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL]
								WHERE 1=1
								AND LOOKUP_TYPE = 'ERP_SSP_TYPE'
								AND VALID_YN ='Y'
							)
		  AND SR.SHIPTO_CODE NOT IN --WS 출하 정보 제외 (매출 실적기반으로 하는수 밖에없음)	-- (2024.09.02 변경건)
									(
										SELECT DISTINCT SHIPTO_CODE
										FROM XIF_ERP_SALES_RESULT_R_SN WITH(NOLOCK)
										WHERE 1=1
										AND		DIVISION_ID = @V_DIVISION_ID --해당 DIVISION 정보 (JV 포함되어야)
										AND		ATTRIBUTE1 = 'WS'
										AND		IFSEQNO = (	--가장 최신번호(높은숫자)로 설정필요. 근 2개월 치 들어옴 (G-PSI 재고/실적 업데이트 구간 및 주기 확인필요)
															SELECT	MAX(IFSEQNO)
															FROM	XIF_ERP_SALES_RESULT_R_SN WITH(NOLOCK)
															WHERE	1=1
															AND		DIVISION_ID = @V_DIVISION_ID --해당 DIVISION 정보 (JV 포함되어야)
															AND		ATTRIBUTE1 = 'WS'
														  )
									)
		*/
        ;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 출하 실적 Measure 추가');
        /* --------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT SR.OPERATION_GROUP
             , SR.ITEM_ID
             , NVL(SR.TO_SITE, '-')        AS TO_SITE
             , NVL(SR.INCOTERMS, '-')      AS INCOTERMS
             , SR.FROM_SITE
             , NVL(SR.TRANSPORT_MODE, '-') AS TRANSPORT_MODE_LINE
             , DI.YYYYMM
             , 'SHIP_PLAN'                 AS MEASURE
             , 'N'                         AS IS_CELL_IN_PACK_PLANT
             , 0.0                         AS FROM_BOH_QTY
             , 0.0                         AS TO_BOH_QTY
             , SUM(SR.EXFACTORY_QTY)       AS QTY
          FROM GT_GPMM_SHIPMENT_RESULT SR
             , GT_GPMM_TMP_DATE_INFO   DI
         WHERE DI.YYYYMMDD = SR.EXFACTORY_YYYYMMDD
         GROUP BY SR.OPERATION_GROUP
                , SR.ITEM_ID
                , NVL(SR.TO_SITE, '-')
                , NVL(SR.INCOTERMS, '-')
                , SR.FROM_SITE
                , NVL(SR.TRANSPORT_MODE, '-')
                , DI.YYYYMM
        ;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 도착 실적 SEMI (to Plant Site WH In) - Raw데이터');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_WH_IN_SEMI_RESULT;

        INSERT
          INTO GT_GPMM_WH_IN_SEMI_RESULT
             ( DIVISION_ID
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , DOC_POSTING_DATE
             , QTY
             )
        SELECT D.DIVISION_ID
             , D.ITEM_ID
             , S.TO_SCM_SITE_ID   AS TO_SITE
             , D.INCOTERMS
             , S.FROM_SCM_SITE_ID AS FROM_SITE
             , D.DOC_POSTING_DATE
             , D.QTY
          FROM (/*
                --SELECT CASE WHEN company_id_sales = 'B100' THEN 'C100'	--NERP 적용여부에 따라 위 코드 살림
				--	       ELSE company_id_sales
				--	       END company_id_sales_conv
    --                , *
			 --    FROM SCM_DNM_INTRANSIT_CO_DETAIL D WITH(NOLOCK)
		  --      WHERE 1=1
		  --        AND D.DIVISION_ID			= @V_DIVISION_ID
		  --        AND D.DOC_TYPE			= 'GR'				-- Good Receipt (입고 정보)
		  --        AND D.DOC_POSTING_DATE   >= @V_RESULT_FROM_YYYYMMDD
		  --        AND D.DOC_POSTING_DATE   <  @V_PLAN_START_YYYYMMDD
                */
                SELECT D.DIVISION_ID
                     , D.COMPANY_ID_PURCH
                     , CASE WHEN D.COMPANY_ID_SALES = V_COMPANY_SALES THEN V_ESOC /* NERP 적용여부에 따라 위 코드 살림 */
                            ELSE D.COMPANY_ID_SALES
                       END              AS COMPANY_ID_SALES_CONV
                     , D.PLANT_ID
                     , D.ITEM_ID
                     , D.INCOTERMS
                     , D.DOC_POSTING_DATE
                     , D.VALID_YN
                     , D.MAT_DOC_ID
                     , D.PO_NO
                     , D.PO_ITEM_SEQ
                     , D.ORIGIN_ITEM_ID
                     , MAX(D.QTY)       AS QTY
                  FROM SCM_DNM_INTRANSIT_CO_DETAIL D
                 WHERE D.DOC_TYPE          = 'GR' /* Good Receipt (입고 정보) */
                   AND D.DIVISION_ID       = V_DIVISION_ID
                   AND D.DOC_POSTING_DATE >= V_RESULT_FROM_YYYYMMDD
                   AND D.DOC_POSTING_DATE  < V_PLAN_START_YYYYMMDD
                 GROUP BY D.DIVISION_ID
                        , D.COMPANY_ID_PURCH
                        , CASE WHEN D.COMPANY_ID_SALES = V_COMPANY_SALES THEN V_ESOC /* NERP 적용여부에 따라 위 코드 살림 */
                               ELSE D.COMPANY_ID_SALES
                          END
                        , D.PLANT_ID
                        , D.ITEM_ID
                        , D.INCOTERMS
                        , D.DOC_POSTING_DATE
                        , D.VALID_YN
                        , D.TRANSPORT_MODE
                        , D.MAT_DOC_ID
                        , D.PO_NO
                        , D.PO_ITEM_SEQ
                        , D.ORIGIN_ITEM_ID
               ) D
             , SCM_DNM_INTRANSIT_CO_SUMMARY S
             , GT_GPMM_SCM_MST_SITE         T
         WHERE S.DIVISION_ID      = D.DIVISION_ID
           AND S.COMPANY_ID_PURCH = D.COMPANY_ID_PURCH
           AND S.COMPANY_ID_SALES = D.COMPANY_ID_SALES_CONV /* D.COMPANY_ID_SALES */
           AND S.PO_NO            = D.PO_NO
           AND S.PO_ITEM_SEQ      = D.PO_ITEM_SEQ
           AND S.ITEM_ID          = D.ITEM_ID
           AND S.ORIGIN_ITEM_ID   = D.ORIGIN_ITEM_ID
           AND T.SCM_SITE_ID      = S.TO_SCM_SITE_ID
           AND T.SITE_TYPE        = 'PLANT'
        /* WHERE 1=1 */
        /*   AND D.DIVISION_ID			= @V_DIVISION_ID */
        /*   AND D.DOC_TYPE			= 'GR'				-- Good Receipt (입고 정보) */
        /*   AND D.DOC_POSTING_DATE   >= @V_RESULT_FROM_YYYYMMDD */
        /*   AND D.DOC_POSTING_DATE   <  @V_PLAN_START_YYYYMMDD */
        ;

        INSERT
          INTO GT_GPMM_WH_IN_SEMI_RESULT
             ( DIVISION_ID
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , DOC_POSTING_DATE
             , QTY
             )
        SELECT D.DIVISION_ID
             , D.ITEM_ID
             , 'ESST_CA_WND'      AS TO_SITE
             , D.INCOTERMS
             , S.FROM_SCM_SITE_ID AS FROM_SITE
             , D.DOC_POSTING_DATE
             , D.QTY
          FROM (/*
                --SELECT CASE WHEN COMPANY_ID_SALES = 'B100' THEN 'C100'	--NERP 적용여부에 따라 위 코드 살림
				--	       ELSE COMPANY_ID_SALES
				--	       END COMPANY_ID_SALES_CONV
    --                , *
			 --    FROM SCM_DNM_INTRANSIT_CO_DETAIL D WITH(NOLOCK)
		  --      WHERE 1=(CASE WHEN @V_DIVISION_ID = '81' THEN 1 ELSE 0 END)
		  --        AND D.DIVISION_ID			= @V_DIVISION_ID
		  --        AND D.DOC_TYPE			= 'GR'				-- Good Receipt (입고 정보)
		  --        AND D.DOC_POSTING_DATE   >= @V_RESULT_FROM_YYYYMMDD
		  --        AND D.DOC_POSTING_DATE   <  @V_PLAN_START_YYYYMMDD
				--  AND D.ITEM_ID				LIKE 'ACEH1131I-B1%'
                */
                SELECT D.DIVISION_ID
                     , D.COMPANY_ID_PURCH
                     , CASE WHEN D.COMPANY_ID_SALES = V_COMPANY_SALES THEN V_ESOC /* NERP 적용여부에 따라 위 코드 살림 */
                            ELSE D.COMPANY_ID_SALES
                       END              AS COMPANY_ID_SALES_CONV
                     , D.PLANT_ID
                     , D.ITEM_ID
                     , D.INCOTERMS
                     , D.DOC_POSTING_DATE
                     , D.VALID_YN
                     , D.MAT_DOC_ID
                     , D.PO_NO
                     , D.PO_ITEM_SEQ
                     , D.ORIGIN_ITEM_ID
                     , MAX(D.QTY)       AS QTY
                  FROM SCM_DNM_INTRANSIT_CO_DETAIL D
                 WHERE V_DIVISION_ID       = '81' /* 1=(CASE WHEN @V_DIVISION_ID = '81' THEN 1 ELSE 0 END) */
                   AND D.DOC_TYPE          = 'GR' /* Good Receipt (입고 정보) */
                   AND D.ITEM_ID        LIKE 'ACEH1131I-B1%'
                   AND D.DIVISION_ID       = V_DIVISION_ID
                   AND D.DOC_POSTING_DATE >= V_RESULT_FROM_YYYYMMDD
                   AND D.DOC_POSTING_DATE  < V_PLAN_START_YYYYMMDD
                 GROUP BY D.DIVISION_ID
                        , D.COMPANY_ID_PURCH
                        , CASE WHEN D.COMPANY_ID_SALES = V_COMPANY_SALES THEN V_ESOC /* NERP 적용여부에 따라 위 코드 살림 */
                               ELSE D.COMPANY_ID_SALES
                          END
                        , D.PLANT_ID
                        , D.ITEM_ID
                        , D.INCOTERMS
                        , D.DOC_POSTING_DATE
                        , D.VALID_YN
                        , D.TRANSPORT_MODE
                        , D.MAT_DOC_ID
                        , D.PO_NO
                        , D.PO_ITEM_SEQ
                        , D.ORIGIN_ITEM_ID
               ) D
             , SCM_DNM_INTRANSIT_CO_SUMMARY S
         WHERE S.DIVISION_ID         = D.DIVISION_ID
           AND S.COMPANY_ID_PURCH    = D.COMPANY_ID_PURCH
           AND S.COMPANY_ID_SALES    = D.COMPANY_ID_SALES_CONV /* D.COMPANY_ID_SALES */
           AND S.PO_NO               = D.PO_NO
           AND S.PO_ITEM_SEQ         = D.PO_ITEM_SEQ
           AND S.ITEM_ID             = D.ITEM_ID
           AND S.ORIGIN_ITEM_ID      = D.ORIGIN_ITEM_ID
           AND S.TO_SCM_SITE_ID   LIKE 'G82%'
        ;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 도착 실적 SEMI (to Plant Site WH In) measure추가');
        /* --------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT FI.OPERATION_GROUP
             , WR.ITEM_ID
             , WR.TO_SITE
             , WR.INCOTERMS
             , WR.FROM_SITE
             , '-'          AS TRANSPORT_MODE
             , DI.YYYYMM
             , 'WH_IN'      AS MEASURE
             , 'N'          AS IS_CELL_INVENTORY
             , 0.0          AS FROM_BOH_QTY
             , 0.0          AS TO_BOH_QTY
             , SUM(WR.QTY)  AS QTY
          FROM GT_GPMM_WH_IN_SEMI_RESULT  WR
             , GT_GPMM_TMP_DATE_INFO      DI
             , GT_GPMM_SCP_MST_FINAL_ITEM FI
         WHERE DI.YYYYMMDD = WR.DOC_POSTING_DATE
           AND FI.ITEM_ID  = WR.ITEM_ID
         GROUP BY FI.OPERATION_GROUP
                , WR.ITEM_ID
                , WR.TO_SITE
                , WR.INCOTERMS
                , WR.FROM_SITE
                , DI.YYYYMM
        ;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 : 도착 실적 FG (to Sales Site WH In) measure추가');
        /* --------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT RR.OPERATION_GROUP
             , RR.ITEM_ID
             , RR.TO_SITE
             , RR.INCOTERMS
             , RR.FROM_SITE
             , '-'          AS TRANSPORT_MODE
             , RR.YYYYMM
             , 'WH_IN'      AS MEASURE
             , 'N'          AS IS_CELL_INVENTORY
             , 0.0          AS FROM_BOH_QTY
             , 0.0          AS TO_BOH_QTY
             , SUM(RR.QTY)  AS QTY
          FROM GT_GPMM_FCST_RTF_RESULT RR
             , GT_GPMM_SCM_MST_SITE    TS
         WHERE TS.SCM_SITE_ID = RR.TO_SITE
           AND TS.SITE_TYPE   = 'SALES'
           AND RR.MEASURE     = 'RTF'
         GROUP BY RR.OPERATION_GROUP
                , RR.ITEM_ID
                , RR.TO_SITE
                , RR.INCOTERMS
                , RR.FROM_SITE
                , RR.YYYYMM
        ;
/* END : 과거구간 */
/* END : 과거구간 */


/* begin : 미래구간 Model Inventory (pack plant cell재고 제외) */
/* begin : 미래구간 Model Inventory (pack plant cell재고 제외) */

        /* ------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 재고 - Plant 기초 재고 (보류제외)');
        /* ASIS ANL PSI PRODUCTION 재고 계산시 적용된 BOH */
        /* ------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_BOH;

        INSERT
          INTO GT_GPMM_BOH
             ( SITE_ID
             , ITEM_ID
             , BOH_QTY
             )
        SELECT PO.SITE_ID
             , NVL(CA.ITEM_ID_ASSY, PO.ITEM_ID) AS ITEM_ID
             , NVL(SUM(PO.PSI_BOH_QTY), 0)      AS BOH_QTY
          FROM SCP_PLN_PLANT_ONHAND       PO
             , GT_GPMM_SCM_MST_SITE       FS
             , GT_GPMM_CELL_PROD_ASSY_MAP CA
         WHERE FS.SCM_SITE_ID             = PO.SITE_ID
           AND CA.PLANT_ID(+)             = FS.PLANT_ID
           AND CA.ITEM_ID_PROD(+)         = PO.ITEM_ID
           AND CA.ASSY_PRIORITY_1ST(+)    = 1
           AND PO.STOCK_TYPE NOT IN ('ASSM', 'FOR_STOCKPLAN', 'FORMING', 'FORMED', 'CHARING', 'A_MOVE_WH') /* 셀 특성완료이전 제외 */
           AND PO.DIVISION_ID             = V_DIVISION_ID
           AND PO.PLAN_START_YYYYMMDD     = V_PLAN_START_YYYYMMDD
           AND PO.PLAN_TYPE               = V_PLAN_TYPE
           AND PO.SEQ                     = V_PLAN_SEQ
           AND PO.YYYYMMDD                = V_PLAN_START_YYYYMMDD /* plan start date 기준 plant 기초 재고 */
         GROUP BY PO.SITE_ID
                , NVL(CA.ITEM_ID_ASSY, PO.ITEM_ID)
        ;

        /* ------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 재고 - 보류 재고 (WH_HOLD) ');
        /* 가용일(RECEIVING_DTTM)과 상관 없이 BOH에 모두 반영 */
        /* ------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_WH_HOLD;

        /* 보류재고 */
        INSERT
          INTO GT_GPMM_WH_HOLD
             ( ITEM_ID
             , FROM_SITE
             , WH_HOLD_QTY
             )
        SELECT NVL(CA.ITEM_ID_ASSY, ES.ITEM_ID)                   AS ITEM_ID
             , SUBSTR(ES.SITE_ID, 1, INSTR(ES.SITE_ID, '~') - 1) AS FROM_SITE
             , SUM(ES.QTY)                                        AS WH_HOLD_QTY
          FROM GT_GPMM_SCP_PLN_TH_ENG_STOCK_PLAN ES
             , GT_GPMM_SCM_MST_SITE              FS
             , GT_GPMM_CELL_PROD_ASSY_MAP        CA
         WHERE FS.SCM_SITE_ID          = SUBSTR(ES.SITE_ID, 1, INSTR(ES.SITE_ID, '~') - 1)
           AND CA.PLANT_ID(+)          = FS.PLANT_ID
           AND CA.ITEM_ID_PROD(+)      = ES.ITEM_ID
           AND CA.ASSY_PRIORITY_1ST(+) = 1
           AND ES.LOT_ID            LIKE 'WH_HOLD%' /* 가용일(RECEIVING_DTTM)과 상관 없이 BOH에 모두 반영 */
         GROUP BY NVL(CA.ITEM_ID_ASSY, ES.ITEM_ID)
                , SUBSTR(ES.SITE_ID, 1, INSTR(ES.SITE_ID, '~') - 1)
        ;

        /* ------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 재고 - 생산/출하 데이터 추출 ');
        /* ASIS Global PSI 재고 계산시 적용된 생산 출하 정보 자동차 기준 참조 */
        /* ------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_SCP_ANL_PSI_PRODUCTION;

        INSERT
          INTO GT_GPMM_SCP_ANL_PSI_PRODUCTION
             ( FROM_SITE
             , PLANT_ID
             , ITEM_ID
             , YYYYMM
             , OPERATION_GROUP
             , SHIP_QTY
             , PROD_QTY
             )
        SELECT PS.FROM_SITE
             , FS.PLANT_ID
             , NVL(CA.ITEM_ID_ASSY, PS.ITEM_ID) AS ITEM_ID
             , DI.YYYYMM
             , PS.OPERATION_GROUP
             , SUM(CASE WHEN PS.PSI_TYPE = 'S' THEN PS.QTY ELSE 0 END) AS SHIP_QTY
             , SUM(CASE WHEN PS.OPERATION_GROUP != 'A' AND PS.PSI_TYPE = 'P'                                       /* pack prod */
                        THEN PS.QTY
                        WHEN PS.OPERATION_GROUP  = 'A' AND PS.PSI_TYPE = 'I' AND PS.PSI_VALUE = 'ACTIVATE_COMPLETED' /* cell prod */
                        THEN PS.QTY
                        ELSE 0
                    END)                                               AS PROD_QTY
          FROM SCP_ANL_PSI_PRODUCTION     PS
             , GT_GPMM_TMP_DATE_INFO      DI
             , GT_GPMM_SCM_MST_SITE       FS
             , GT_GPMM_CELL_PROD_ASSY_MAP CA
         WHERE DI.YYYYMMDD             = PS.YYYYMMDD
           AND FS.SCM_SITE_ID          = PS.FROM_SITE
           AND CA.PLANT_ID(+)          = FS.PLANT_ID
           AND CA.ITEM_ID_PROD(+)      = PS.ITEM_ID
           AND CA.ASSY_PRIORITY_1ST(+) = 1
           AND PS.PSI_VALUE           != 'ISSUM'
           AND (   PS.PSI_TYPE = 'S'
                OR (PS.OPERATION_GROUP != 'A' AND PS.PSI_TYPE = 'P')                                        /* pack prod */
                OR (PS.OPERATION_GROUP  = 'A' AND PS.PSI_TYPE = 'I' AND PS.PSI_VALUE = 'ACTIVATE_COMPLETED') /* cell prod */
               )
           AND PS.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND PS.PLAN_TYPE            = V_PLAN_TYPE
           AND PS.SEQ                  = V_PLAN_SEQ
           AND PS.DIVISION_ID          = V_DIVISION_ID
         GROUP BY PS.FROM_SITE
                , FS.PLANT_ID
                , NVL(CA.ITEM_ID_ASSY, PS.ITEM_ID)
                , DI.YYYYMM
                , PS.OPERATION_GROUP
        ;

        /* CREATE NONCLUSTERED INDEX PSI_PRODUCTION_IDX1 ON #SCP_ANL_PSI_PRODUCTION(ITEM_ID, FROM_SITE, YYYYMM) ; */
        /* ↑ 임시 테이블 인덱스 : GTT 인덱스는 GTT DDL 파일에서 생성 (프로시저 안 DDL 불가) */

        /* ------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 재고 - 생산/출하 누적 수량 ');
        /* ------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_PSI_PROD_SHIP;

        INSERT
          INTO GT_GPMM_PSI_PROD_SHIP
             ( ITEM_ID
             , FROM_SITE
             , OPERATION_GROUP
             , YYYYMM
             , ACC_SHIP_QTY
             , ACC_PROD_QTY
             , SUB_TOT_SHIP_QTY
             , SUB_TOT_PROD_QTY
             )
        SELECT PS.ITEM_ID
             , PS.FROM_SITE
             , PS.OPERATION_GROUP
             , PS.YYYYMM
             , SUM(PS.SHIP_QTY) OVER (PARTITION BY PS.ITEM_ID
                                                 , PS.FROM_SITE
                                          ORDER BY PS.YYYYMM) AS ACC_SHIP_QTY
             , SUM(PS.PROD_QTY) OVER (PARTITION BY PS.ITEM_ID
                                                 , PS.FROM_SITE
                                          ORDER BY PS.YYYYMM) AS ACC_PROD_QTY
             , SUM(PS.SHIP_QTY) OVER (PARTITION BY PS.ITEM_ID
                                                 , PS.FROM_SITE) AS SUB_TOT_SHIP_QTY
             , SUM(PS.PROD_QTY) OVER (PARTITION BY PS.ITEM_ID
                                                 , PS.FROM_SITE) AS SUB_TOT_PROD_QTY
          FROM GT_GPMM_SCP_ANL_PSI_PRODUCTION PS
         ORDER BY PS.ITEM_ID
                , PS.FROM_SITE
                , PS.YYYYMM
        ;

        /* ------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 재고 - 재고계산 ');
        /* Pack plant 팩재고, Cell Plant 셀재고 */
        /* 재고 = 기초재고 + 보류재고 + 생산(누적) - 출하(누적) */
        /* ------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_MODEL_INVENTORY;

        INSERT
          INTO GT_GPMM_MODEL_INVENTORY
             ( ITEM_ID
             , FROM_SITE
             , YYYYMM
             , OPERATION_GROUP
             , ACC_SHIP_QTY
             , ACC_PROD_QTY
             , SUB_TOT_SHIP_QTY
             , SUB_TOT_PROD_QTY
             , WH_HOLD_QTY
             , ASIS_BOH_QTY
             , TOBE_BOH_QTY
             , ASIS_MODEL_INVENTORY
             , TOBE_MODEL_INVENTORY
             )
        SELECT PS.ITEM_ID
             , PS.FROM_SITE
             , PS.YYYYMM
             , PS.OPERATION_GROUP
             , PS.ACC_SHIP_QTY
             , PS.ACC_PROD_QTY
             , PS.SUB_TOT_SHIP_QTY
             , PS.SUB_TOT_PROD_QTY
             , NVL(WH.WH_HOLD_QTY, 0)                        AS WH_HOLD_QTY
             , NVL(BH.BOH_QTY, 0)                            AS ASIS_BOH_QTY
             , NVL(BH.BOH_QTY, 0) + NVL(WH.WH_HOLD_QTY, 0)   AS TOBE_BOH_QTY
             , NVL(BH.BOH_QTY, 0)
                   + PS.ACC_PROD_QTY - PS.ACC_SHIP_QTY        AS ASIS_MODEL_INVENTORY
             , NVL(BH.BOH_QTY, 0) + NVL(WH.WH_HOLD_QTY, 0)
                   + PS.ACC_PROD_QTY - PS.ACC_SHIP_QTY        AS TOBE_MODEL_INVENTORY
          FROM GT_GPMM_PSI_PROD_SHIP PS
             , GT_GPMM_BOH           BH
             , GT_GPMM_WH_HOLD       WH
         WHERE BH.SITE_ID(+)   = PS.FROM_SITE
           AND BH.ITEM_ID(+)   = PS.ITEM_ID
           AND WH.FROM_SITE(+) = PS.FROM_SITE
           AND WH.ITEM_ID(+)   = PS.ITEM_ID
         ORDER BY PS.ITEM_ID
                , PS.FROM_SITE
                , PS.YYYYMM
        ;

        /* ------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 재고 - 재고 measure 추가 ');
        /* ------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT MI.OPERATION_GROUP
             , MI.ITEM_ID
             , '-'                      AS TO_SITE
             , '-'                      AS INCOTERMS
             , MI.FROM_SITE
             , '-'                      AS VARIOUS_KEY
             , MI.YYYYMM
             , 'MODEL_INVENTORY'        AS MEASURE
             , 'N'                      AS IS_CELL_IN_PACK_PLANT
             , MI.TOBE_BOH_QTY          AS FROM_BOH_QTY
             , 0.0                      AS TO_BOH_QTY
             , MI.TOBE_MODEL_INVENTORY  AS QTY
          FROM GT_GPMM_MODEL_INVENTORY MI
        ;

/* end : 미래구간 Model Inventory (pack plant cell재고 제외) */
/* end : 미래구간 Model Inventory (pack plant cell재고 제외) */

        /* -------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : (SIMUL) Form. End Eta (Prod) Raw 데이터 ');
        /* CELL_PROD_FORM_END : Form. End Eta (Prod) : 생산LT를 적용한 생산 수량 */
        /* -------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_CELL_PROD_FORM_END_RAW;

        INSERT
          INTO GT_GPMM_CELL_PROD_FORM_END_RAW
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYMMDD_ORG
             , TRANSPORT_MODE_LINE
             , QTY
             , LT_DAY
             , YYYYMMDD
             )
        SELECT PG.OPERATION_GROUP
             , PG.ITEM_ID
             , PG.FROM_SITE
             , PG.YYYYMMDD     AS YYYYMMDD_ORG
             , PG.TRANSPORT_MODE_LINE
             , PG.QTY
             , FR.LT_DAY
               /* ,CONVERT(NVARCHAR(8), DATEADD(DAY, ISNULL(FR.LT_DAY,0), CONVERT(DATE, PG.YYYYMMDD, 112)),112) AS YYYYMMDD */
             , TO_CHAR(TO_DATE(PG.YYYYMMDD, 'YYYYMMDD') + NVL(FR.LT_DAY, 0), 'YYYYMMDD') AS YYYYMMDD /* 고도화 */
          FROM GT_GPMM_SCP_ANL_PSI_GLOBAL PG
             , GT_GPMM_SCP_MST_FORMATION  FR
         WHERE FR.PLANT_SITE_ID(+) = PG.FROM_SITE
           AND FR.ITEM_ID(+)       = PG.ITEM_ID
           AND FR.YYYYMM(+)        = SUBSTR(PG.YYYYMMDD, 1, 6)
           AND PG.MEASURE          = 'PRODUCTION'
           AND PG.OPERATION_GROUP  = 'A'
        ;

        /* start 기준 이전의 실적수량 포함	-- 고도화 */
        INSERT
          INTO GT_GPMM_CELL_PROD_FORM_END_RAW
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYMMDD_ORG
             , TRANSPORT_MODE_LINE
             , QTY
             , LT_DAY
             , YYYYMMDD
             )
        SELECT B.SCP_OPERATION_GROUP             AS OPERATION_GROUP
             , A.ITEM_ID
             , FS.SCM_SITE_ID                    AS FROM_SITE
             , TO_CHAR(A.PLAN_DATE, 'YYYYMMDD') AS YYYYMMDD_ORG
             , A.LINE_ID                         AS TRANSPORT_MODE_LINE
             , A.QTY
             , FR.LT_DAY
             , TO_CHAR(TRUNC(A.PLAN_DATE) + NVL(FR.LT_DAY, 0), 'YYYYMMDD') AS YYYYMMDD
          FROM SCM_DNM_DAILY_PRODUCT_RESULT_SN A /* SCM_DNM_DAILY_PRODUCT_RESULT_SN */
             , SCM_MST_ITEM_SN                 B /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
             , GT_GPMM_SCM_MST_SITE            FS
             , GT_GPMM_SCP_MST_FORMATION       FR
         WHERE B.COMPANY_ID             = A.COMPANY_ID
           AND B.DIVISION_ID            = A.DIVISION_ID
           AND B.SITE_ID                = A.SITE_ID
           AND B.ITEM_ID                = A.ITEM_ID
           AND FS.PLANT_ID(+)           = A.PLANT_ID
           AND FS.OPERATION_GROUP(+)    = B.SCP_OPERATION_GROUP
           AND FR.PLANT_SITE_ID(+)      = FS.SCM_SITE_ID
           AND FR.ITEM_ID(+)            = A.ITEM_ID
           AND FR.YYYYMM(+)             = TO_CHAR(A.PLAN_DATE, 'YYYYMM')
           AND A.OPERATION_ID IN (SELECT OPERATION_ID
                                    FROM GT_GPMM_PRODUCTION_OPERATION)
           AND B.SCP_OPERATION_GROUP IS NOT NULL      /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
           AND B.SCP_OPERATION_GROUP IN ('A')         /* CELL/PACK만 */
           AND FS.SITE_TYPE(+)          = 'PLANT'
           AND FS.VALID_YN(+)           = 'Y'
           AND A.PRODUCTION_TYPE NOT IN ('REWORK', 'PILOT') /* SCM_DNM_PRODUCT_RESULT_V 뷰 동일 조인 조건 (2023/09/26) */
           AND A.OPERATION_ID          != 'F6000' /* 셀 특성 제외 */
           AND A.DIVISION_ID            = V_DIVISION_ID
           AND A.PLAN_DATE             >= TO_DATE(V_PLAN_START_YYYYMM || '01', 'YYYYMMDD')
           AND A.PLAN_DATE              < V_PLAN_START_DATE
        ;

        /* -------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : (SIMUL) Form. End Eta (Prod) Measure 추가 ');
        /* CELL_PROD_FORM_END : Form. End Eta (Prod) : 생산LT를 적용한 생산 수량 */
        /* asis global psi의 production 정보는 빈날짜 0으로 채워진 정보임 */
        /* -------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_CELL_PROD_FORM_END_LINE;

        DELETE FROM GT_GPMM_CELL_PROD_FORM_END;

        INSERT
          INTO GT_GPMM_CELL_PROD_FORM_END_LINE
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , QTY
             )
        SELECT PF.OPERATION_GROUP
             , PF.ITEM_ID
             , PF.FROM_SITE
             , PF.TRANSPORT_MODE_LINE
             , DI.YYYYMM
             , SUM(PF.QTY) AS QTY
          FROM GT_GPMM_CELL_PROD_FORM_END_RAW PF
             , GT_GPMM_TMP_DATE_INFO          DI
         WHERE DI.YYYYMMDD = PF.YYYYMMDD
         GROUP BY PF.OPERATION_GROUP
                , PF.ITEM_ID
                , PF.FROM_SITE
                , PF.TRANSPORT_MODE_LINE
                , DI.YYYYMM
        ;

        /* 데이터 검증시 확인을 위해 measure 추가 (UI 노출 대상아님) */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT PF.OPERATION_GROUP
             , PF.ITEM_ID
             , '-'                   AS TO_SITE
             , '-'                   AS INCOTERMS
             , PF.FROM_SITE
             , PF.TRANSPORT_MODE_LINE
             , PF.YYYYMM
             , 'CELL_PROD_FORM_END'  AS MEASURE
             , 'N'                   AS IS_CELL_IN_PACK_PLANT
             , 0.0                   AS FROM_BOH_QTY
             , 0.0                   AS TO_BOH_QTY
             , PF.QTY
          FROM GT_GPMM_CELL_PROD_FORM_END_LINE PF
        ;

        /* #CELL_PROD_FORM_END for Cell. Available/ Form. Progress */
        INSERT
          INTO GT_GPMM_CELL_PROD_FORM_END
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYMM
             , QTY
             )
        SELECT PF.OPERATION_GROUP
             , PF.ITEM_ID
             , PF.FROM_SITE
             , PF.YYYYMM
             , SUM(PF.QTY) AS QTY
          FROM GT_GPMM_CELL_PROD_FORM_END_LINE PF
         GROUP BY PF.OPERATION_GROUP
                , PF.ITEM_ID
                , PF.FROM_SITE
                , PF.YYYYMM
        ;

        /* -------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : (SIMUL) Form. End Eta (Past) Daily ');
        /* CELL_FOR_FORM_END : Form. End Eta (Past) : TH_ENG_STOCK_PLAN_SN에서 보류 수량을 포함한 해당일 수량 */
        /* ----------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_FOR_FORM_END_DAILY;

        INSERT
          INTO GT_GPMM_FOR_FORM_END_DAILY
             ( FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , QTY
             )
        SELECT SUBSTR(ES.SITE_ID, 1, INSTR(ES.SITE_ID, '~') - 1) AS FROM_SITE
             , ES.ITEM_ID
             , ES.YYYYMMDD
             , SUM(NVL(ES.QTY, 0))                                AS QTY
          FROM GT_GPMM_SCP_PLN_TH_ENG_STOCK_PLAN ES
         WHERE ES.DESCR LIKE 'FOR%'
         GROUP BY SUBSTR(ES.SITE_ID, 1, INSTR(ES.SITE_ID, '~') - 1)
                , ES.ITEM_ID
                , ES.YYYYMMDD
        ;

        /* -------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : (SIMUL) Form. End Eta (Past) Monthly ');
        /* CELL_FOR_FORM_END : Form. End Eta (Past) : TH_ENG_STOCK_PLAN_SN에서 보류 수량을 포함한 해당일 수량 */
        /* ----------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_FOR_FORM_END_MONTHLY;

        INSERT
          INTO GT_GPMM_FOR_FORM_END_MONTHLY
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYMM
             , QTY
             )
        SELECT FI.OPERATION_GROUP
             , FE.ITEM_ID
             , FE.FROM_SITE
             , DI.YYYYMM
             , SUM(FE.QTY) AS QTY
          FROM GT_GPMM_FOR_FORM_END_DAILY FE
             , GT_GPMM_SCP_MST_FINAL_ITEM FI
             , GT_GPMM_TMP_DATE_INFO      DI
         WHERE FI.ITEM_ID  = FE.ITEM_ID
           AND DI.YYYYMMDD = FE.YYYYMMDD
         GROUP BY FI.OPERATION_GROUP
                , FE.ITEM_ID
                , FE.FROM_SITE
                , DI.YYYYMM
        ;

        /* ------------------------------------------------------------------------------------------------------------------ */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : (SIMUL) Form. End Eta (Past) Monthly - 빈월 0채움');
        /* CELL_FOR_FORM_END : Form. End Eta (Past) : TH_ENG_STOCK_PLAN_SN에서 보류 수량을 포함한 해당일 수량 */
        /* --------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_CELL_FOR_FORM_END;

        INSERT
          INTO GT_GPMM_CELL_FOR_FORM_END
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYMM
             , QTY
             )
        SELECT FE.OPERATION_GROUP
             , FE.ITEM_ID
             , FE.FROM_SITE
             , WL.YYYYMM
             , SUM(CASE WHEN FE.YYYYMM = WL.YYYYMM THEN FE.QTY ELSE 0 END) AS QTY
          FROM GT_GPMM_FOR_FORM_END_MONTHLY FE
             , GT_GPMM_TMP_MM_LIST          WL
         WHERE WL.YYYYMM >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
         GROUP BY FE.OPERATION_GROUP
                , FE.ITEM_ID
                , FE.FROM_SITE
                , WL.YYYYMM
        ;

        /* 데이터 검증시 확인을 위해 measure 추가 (UI 노출 대상아님) */
        /* 빈날짜 채우기 전 (0인 데이터 제외) */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT PF.OPERATION_GROUP
             , PF.ITEM_ID
             , '-'                  AS TO_SITE
             , '-'                  AS INCOTERMS
             , PF.FROM_SITE
             , '-'                  AS VARIOUS_KEY
             , PF.YYYYMM
             , 'CELL_FOR_FORM_END'  AS MEASURE
             , 'N'                  AS IS_CELL_IN_PACK_PLANT
             , 0.0                  AS FROM_BOH_QTY
             , 0.0                  AS TO_BOH_QTY
             , PF.QTY
          FROM GT_GPMM_FOR_FORM_END_MONTHLY PF
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Char. Plan  measure 추가 (임시) ');
        /* 2023.11.22 추가 요구사항 */
        /*  (Form. End Eta (Past) + Form. End Eta (Prod))*Yield */
        /*  특성 가용한(Char.Available) 재고를 전부 특성 계획을 친다는 조건 */
        /*  Char. Available : Char. Plan에서 다 빼먹었으므로, ‘0’ 될 것으로 판단 */
        /* * 향후 Simulator Char. Plan 저장값이 FN에 확정계획으로 반영될 시 현재 산식기준 (asis global psi activate_completed) 으로 원복 */
        /* --------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_CELL_CHAR_PLAN_FUTURE;

        INSERT
          INTO GT_GPMM_CELL_CHAR_PLAN_FUTURE
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , VARIOUS_KEY
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
          WITH CELL_CHAR_PLAN_SRC AS (
               /* CELL_FOR_FORM_END : Form. End Eta (Past) */
               SELECT FF.OPERATION_GROUP
                    , FF.ITEM_ID
                    , FF.FROM_SITE
                    , FF.YYYYMM
                    , FF.QTY
                 FROM GT_GPMM_CELL_FOR_FORM_END FF
                UNION ALL
               /* CELL_PROD_FORM_END : From. End Eta (Prod) */
               SELECT FF.OPERATION_GROUP
                    , FF.ITEM_ID
                    , FF.FROM_SITE
                    , FF.YYYYMM
                    , FF.QTY
                 FROM GT_GPMM_CELL_PROD_FORM_END FF
               )
        SELECT CP.OPERATION_GROUP
             , CP.ITEM_ID
             , '-'                     AS TO_SITE
             , '-'                     AS INCOTERMS
             , CP.FROM_SITE
             , '-'                     AS VARIOUS_KEY
             , CP.YYYYMM
             , 'CELL_CHAR_PLAN'        AS MEASURE
             , 'N'                     AS IS_CELL_IN_PACK_PLANT
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , SUM(CP.QTY)
                 * CASE WHEN NVL(FY.SSP_MODIFY_YIELD, 0) > 0      THEN FY.SSP_MODIFY_YIELD
                        WHEN NVL(FY.FORMATION_TOTAL_YIELD, 0) > 0 THEN FY.FORMATION_TOTAL_YIELD
                        ELSE 1
                   END                 AS QTY
          FROM CELL_CHAR_PLAN_SRC        CP
             , GT_GPMM_SCP_MST_FORMATION FY
         WHERE FY.PLANT_SITE_ID(+) = CP.FROM_SITE
           AND FY.ITEM_ID(+)       = CP.ITEM_ID
           AND FY.YYYYMM(+)        = CP.YYYYMM
         GROUP BY CP.OPERATION_GROUP
                , CP.ITEM_ID
                , CP.FROM_SITE
                , CP.YYYYMM
                , CASE WHEN NVL(FY.SSP_MODIFY_YIELD, 0) > 0      THEN FY.SSP_MODIFY_YIELD
                       WHEN NVL(FY.FORMATION_TOTAL_YIELD, 0) > 0 THEN FY.FORMATION_TOTAL_YIELD
                       ELSE 1
                  END
        ;

        /* -------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Char. Plan  measure 추가 (임시) - insert ');
        /* -------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , VARIOUS_KEY
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
          FROM GT_GPMM_CELL_CHAR_PLAN_FUTURE
        ;


/* begin : 미래구간 cell inventory (CELL_EOH) */
/* begin : 미래구간 cell inventory (CELL_EOH) */
        /* --------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Cell Inventory 시뮬레이터 산식 적용 재계산 (임시) ');
        /* 아래와 같이 Char. Plan이 변경됨으로 인해 계획구간 Cell Inventory 산식(시뮬레이터)에 의해 재계산 */
        /* Cell Invnentory = CELL_BOH(Cell BOH) */
        /*						 - CELL_SHIP_PLAN_TOTAL(Cell Ship Plan(Sum)) */
        /*						 + CELL_CHAR_PLAN(Char. Plan) */
        /*						 + CELL_FORM_HOLD_AFTER(After Form. Hold Release) */
        /* 2023.11.22 Char. Plan 에 대한 추가 요구사항 */
        /*  (Form. End Eta (Past) + Form. End Eta (Prod))*Yield */
        /*  특성 가용한(Char.Available) 재고를 전부 특성 계획을 친다는 조건 */
        /*  Char. Available : Char. Plan에서 다 빼먹었으므로, ‘0’ 될 것으로 판단 */
        /* * 향후 Simulator Char. Plan 저장값이 FN에 확정계획으로 반영될 시 현재 산식기준 (asis global psi activate_completed) 으로 원복 */
        /* --------------------------------------------------------------------------------------------------------------------------------- */

        /* --------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Cell Inventory 시뮬레이터 산식 적용 재계산 - CELL_BOH ');
        /* --------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_CELL_BOH_FOR_FUTURE;
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

        /* BOH 기준 변경 	-- 고도화 */
        INSERT
          INTO GT_GPMM_CELL_BOH_FOR_FUTURE
             ( ITEM_ID
             , FROM_SITE
             , QTY
             )
        SELECT SO.ITEM_ID
             , SO.FROM_SITE AS FROM_SITE
             , SUM(SO.QTY)  AS QTY
          FROM GT_GPMM_TMP_ENDING_INV_MM SO
         WHERE SO.MEASURE         = 'CELL_EOH'
           AND SO.OPERATION_GROUP = 'A' /* cell 사이트 */
           AND SO.YYYYMM          = V_RESULT_LAST_YYYYMM
         GROUP BY SO.ITEM_ID
                , SO.FROM_SITE
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
				  ,DI.YYYYMM
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
					,DI.YYYYMM
		)
		SELECT FH.FROM_SITE
			  ,FH.ITEM_ID
			  ,ML.YYYYMM
			  ,SUM(CASE WHEN FH.YYYYMM = ML.YYYYMM THEN FH.QTY ELSE 0 END) AS QTY
		 INTO #CELL_FORM_HOLD_AFTER
		 FROM CELL_FORM_HOLD_AFTER FH WITH(NOLOCK)
			  INNER JOIN #TMP_MM_LIST ML WITH(NOLOCK)
					  ON ML.YYYYMM >= @V_PLAN_START_YYYYMM --  미래 구간
		WHERE 1=1
		GROUP BY FH.FROM_SITE
				,FH.ITEM_ID
				,ML.YYYYMM
		*/

        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Cell Inventory 시뮬레이터 산식 적용 재계산 - CELL_SHIP_PLAN_TOTAL ');
        /* --------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_CELL_SHIP_PLAN_TOTAL;

        INSERT
          INTO GT_GPMM_CELL_SHIP_PLAN_TOTAL
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYMM
             , QTY
             )
        SELECT PG.OPERATION_GROUP
             , PG.ITEM_ID
             , PG.FROM_SITE
             , ML.YYYYMM
             , SUM(CASE WHEN ML.YYYYMM = PG.YYYYMM THEN PG.QTY ELSE 0 END) AS QTY
          FROM GT_GPMM_TMP_ASIS_GLOBAL_PSI PG
             , GT_GPMM_TMP_MM_LIST         ML
         WHERE ML.YYYYMM          >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
           AND PG.MEASURE IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN') /* */
           AND PG.OPERATION_GROUP  = 'A'
           AND PG.YYYYMM          >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
         GROUP BY PG.OPERATION_GROUP
                , PG.ITEM_ID
                , PG.FROM_SITE
                , ML.YYYYMM
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Cell Inventory 시뮬레이터 산식 적용 재계산');
        /* 아래와 같이 Char. Plan이 변경됨으로 인해 계획구간 Cell Inventory 산식(시뮬레이터)에 의해 재계산 */
        /* Cell Invnentory = CELL_BOH(Cell BOH) */
        /*						 - CELL_SHIP_PLAN_TOTAL(Cell Ship Plan(Sum)) */
        /*						 + CELL_CHAR_PLAN(Char. Plan) */
        /*						 + CELL_FORM_HOLD_AFTER(After Form. Hold Release) */
        /* --------------------------------------------------------------------------------------------------------------------------------- */

        DELETE /* ASIS global psi 셀공장 삭제 */
          FROM GT_GPMM_TMP_ASIS_GLOBAL_PSI
         WHERE MEASURE               = 'MODEL_INVENTORY'
           AND OPERATION_GROUP       = 'A'
           AND IS_CELL_IN_PACK_PLANT = 'N'
        ;

        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
          WITH CELL_INVENTORY_SRC AS (
               /* CELL_BOH (전구간 기초재고로 사용) */
               SELECT BH.FROM_SITE
                    , BH.ITEM_ID
                    , ML.YYYYMM
                    , SUM(BH.QTY) AS BOH_QTY
                    , SUM(BH.QTY) AS QTY
                 FROM GT_GPMM_CELL_BOH_FOR_FUTURE BH
                    , GT_GPMM_TMP_MM_LIST         ML
                WHERE ML.YYYYMM >= V_PLAN_START_YYYYMM /*  미래 구간 */
                GROUP BY BH.FROM_SITE
                       , BH.ITEM_ID
                       , ML.YYYYMM
                UNION ALL
               /* 2024.01.18 HOLD 재고 가용일과 상관 없이 기초 재고로 모두 반영 */
               SELECT BH.FROM_SITE
                    , BH.ITEM_ID
                    , ML.YYYYMM
                    , SUM(BH.WH_HOLD_QTY) AS BOH_QTY
                    , SUM(BH.WH_HOLD_QTY) AS QTY
                 FROM GT_GPMM_WH_HOLD     BH
                    , GT_GPMM_TMP_MM_LIST ML
                WHERE ML.YYYYMM     >= V_PLAN_START_YYYYMM /*  미래 구간 */
                  AND BH.FROM_SITE LIKE '%A' /* Cell 사이트 / 셀재고 ? */
                GROUP BY BH.FROM_SITE
                       , BH.ITEM_ID
                       , ML.YYYYMM
			/* 2024.01.18 변경전
			-- CELL_FORM_HOLD_AFTER
			SELECT FH.FROM_SITE
				  ,FH.ITEM_ID
				  ,FH.YYYYMM
				  ,0	 AS BOH_QTY
				  ,SUM(FH.QTY) OVER (PARTITION BY FH.FROM_SITE
												, FH.ITEM_ID
										 ORDER BY FH.YYYYMM) AS QTY
			 FROM #CELL_FORM_HOLD_AFTER FH WITH(NOLOCK)
			*/
                UNION ALL
               /* CELL_SHIP_PLAN_TOTAL */
               SELECT SP.FROM_SITE
                    , SP.ITEM_ID
                    , SP.YYYYMM
                    , 0 AS BOH_QTY
                    , (-1) * SUM(SP.QTY) OVER (PARTITION BY SP.FROM_SITE
                                                          , SP.ITEM_ID
                                                   ORDER BY SP.YYYYMM) AS QTY
                 FROM GT_GPMM_CELL_SHIP_PLAN_TOTAL SP
                UNION ALL
               /* CELL_CHAR_PLAN_FUTURE */
               SELECT CP.FROM_SITE
                    , CP.ITEM_ID
                    , CP.YYYYMM
                    , 0 AS BOH_QTY
                    , SUM(CP.QTY) OVER (PARTITION BY CP.FROM_SITE
                                                   , CP.ITEM_ID
                                            ORDER BY CP.YYYYMM) AS QTY
                 FROM GT_GPMM_CELL_CHAR_PLAN_FUTURE CP
               )
        SELECT 'A'                              AS OPERATION_GROUP
             , NVL(CA.ITEM_ID_ASSY, CI.ITEM_ID) AS ITEM_ID
             , '-'                              AS TO_SITE
             , '-'                              AS INCOTERMS
             , CI.FROM_SITE
             , '-'                              AS VARIOUS_KEY
             , CI.YYYYMM
             , 'CELL_EOH'                       AS MEASURE
             , 'N'                              AS IS_CELL_IN_PACK_PLANT
             , SUM(CI.BOH_QTY)                  AS FROM_BOH_QTY
             , 0.0                              AS TO_BOH_QTY
             , SUM(CI.QTY)                      AS QTY
          FROM CELL_INVENTORY_SRC         CI
             , GT_GPMM_SCM_MST_SITE       FS
             , GT_GPMM_CELL_PROD_ASSY_MAP CA /* CP를 CA로 치환 적용 -- 20240118 */
         WHERE FS.SCM_SITE_ID(+)       = CI.FROM_SITE
           AND CA.PLANT_ID(+)          = FS.PLANT_ID
           AND CA.ITEM_ID_PROD(+)      = CI.ITEM_ID
           AND CA.ASSY_PRIORITY_1ST(+) = 1
         GROUP BY CI.FROM_SITE
                , NVL(CA.ITEM_ID_ASSY, CI.ITEM_ID)
                , CI.YYYYMM
        ;


/* end : 미래구간 cell inventory (CELL_EOH) */
/* end : 미래구간 cell inventory (CELL_EOH) */

/* Begin : 미래구간 Char. Available (CELL_CHAR_AVAILABLE) */
/* Begin : 미래구간 Char. Available (CELL_CHAR_AVAILABLE) */
        /* ------------------------------------------------------------------------------------------------------------------ */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Char. Available - Char. Plan  수율 적용 ');
        /* ------------------------------------------------------------------------------------------------------------------ */
        DELETE FROM GT_GPMM_CELL_CHAR_PLAN_YIELD;

        INSERT
          INTO GT_GPMM_CELL_CHAR_PLAN_YIELD
             ( OPERATION_GROUP
             , ITEM_ID
             , FROM_SITE
             , YYYYMM
             , QTY
             , YIELD
             , QTY_YIELD
             )
          WITH CHAR_PLAN AS (
               SELECT PG.OPERATION_GROUP
                    , PG.ITEM_ID
                    , PG.FROM_SITE
                    , PG.YYYYMM
                    , SUM(PG.QTY) AS QTY
               /* FROM #TMP_ASIS_GLOBAL_PSI PG WITH(NOLOCK) */
                 FROM GT_GPMM_CELL_CHAR_PLAN_FUTURE PG
                WHERE PG.MEASURE = 'CELL_CHAR_PLAN'          /* 특성(F6000) 생산계획 -- CELL_CHAR_PLAN */
                  AND PG.YYYYMM >= V_PLAN_START_YYYYMM       /* 미래 계획 구간 */
                GROUP BY PG.OPERATION_GROUP
                       , PG.ITEM_ID
                       , PG.FROM_SITE
                       , PG.YYYYMM
               )
        SELECT CP.OPERATION_GROUP
             , CP.ITEM_ID
             , CP.FROM_SITE
             , CP.YYYYMM
             , CP.QTY
             , CASE WHEN NVL(FY.SSP_MODIFY_YIELD, 0) > 0      THEN FY.SSP_MODIFY_YIELD
                    WHEN NVL(FY.FORMATION_TOTAL_YIELD, 0) > 0 THEN FY.FORMATION_TOTAL_YIELD
                    ELSE 1
               END AS YIELD
             , CP.QTY / CASE WHEN NVL(FY.SSP_MODIFY_YIELD, 0) > 0      THEN FY.SSP_MODIFY_YIELD
                             WHEN NVL(FY.FORMATION_TOTAL_YIELD, 0) > 0 THEN FY.FORMATION_TOTAL_YIELD
                             ELSE 1
                        END AS QTY_YIELD
          FROM CHAR_PLAN                 CP
             , GT_GPMM_SCP_MST_FORMATION FY
         WHERE FY.PLANT_SITE_ID(+) = CP.FROM_SITE
           AND FY.ITEM_ID(+)       = CP.ITEM_ID
           AND FY.YYYYMM(+)        = CP.YYYYMM
        ;

        /* ------------------------------------------------------------------------------------------------------------------ */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Char. Available measure 추가 ');
        /* Cell. Available = CELL_FOR_FORM_END + CELL_PROD_FORM_END - CELL_CHAR_PLAN / 수율 */
        /* CELL_FOR_FORM_END : Form. End Eta (Past) */
        /* CELL_PROD_FORM_END : From. End Eta (Prod) */
        /* CELL_CHAR_PLAN : Char. Plan */
        /* ------------------------------------------------------------------------------------------------------------------ */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
          WITH CHAR_AVAILABE_SRC AS (
               /* CELL_FOR_FORM_END : Form. End Eta (Past) */
			/*
			SELECT FF.OPERATION_GROUP
				  ,FF.ITEM_ID
				  ,FF.FROM_SITE
				  ,FF.YYYYMM
				  ,SUM(FF.QTY) OVER (PARTITION BY FF.ITEM_ID
												 ,FF.FROM_SITE
										 ORDER BY FF.YYYYMM)	AS QTY
			 FROM #CELL_FOR_FORM_END FF
			WHERE 1=1
			*/
               /* ENDING INVENTORY BOH 사용 -- 고도화 */
               SELECT BH.OPERATION_GROUP
                    , BH.ITEM_ID
                    , BH.FROM_SITE
                    , WL.YYYYMM
                    , BH.CHAR_AVAILABLE AS QTY
                 FROM GT_GPMM_PAST_FORM_PROGRESS_CHAR_AVAILABLE BH
                    , GT_GPMM_TMP_MM_LIST                       WL
                WHERE WL.YYYYMM >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
                  AND BH.YYYYMM  = V_RESULT_LAST_YYYYMM
                UNION ALL
               /* CELL_PROD_FORM_END : From. End Eta (Prod) */
               SELECT FF.OPERATION_GROUP
                    , FF.ITEM_ID
                    , FF.FROM_SITE
                    , FF.YYYYMM
                    , SUM(FF.QTY) OVER (PARTITION BY FF.ITEM_ID
                                                   , FF.FROM_SITE
                                            ORDER BY FF.YYYYMM) AS QTY
                 FROM GT_GPMM_CELL_PROD_FORM_END FF
                UNION ALL
               /* CELL_CHAR_PLAN : Char. Plan */
               SELECT CP.OPERATION_GROUP
                    , CP.ITEM_ID
                    , CP.FROM_SITE
                    , CP.YYYYMM
                    , (-1) * SUM(CP.QTY_YIELD) OVER (PARTITION BY CP.ITEM_ID
                                                                , CP.FROM_SITE
                                                         ORDER BY CP.YYYYMM) AS QTY
                 FROM GT_GPMM_CELL_CHAR_PLAN_YIELD CP
               )
        SELECT CA.OPERATION_GROUP
             , CA.ITEM_ID
             , '-'                      AS TO_SITE
             , '-'                      AS INCOTERMS
             , CA.FROM_SITE
             , '-'                      AS VARIOUS_KEY
             , CA.YYYYMM
             , 'CELL_CHAR_AVAILABLE'    AS MEASURE
             , 'N'                      AS IS_CELL_IN_PACK_PLANT
             , 0.0                      AS FROM_BOH_QTY
             , 0.0                      AS TO_BOH_QTY
             , SUM(CA.QTY)              AS QTY
          FROM CHAR_AVAILABE_SRC CA
         GROUP BY CA.OPERATION_GROUP
                , CA.ITEM_ID
                , CA.FROM_SITE
                , CA.YYYYMM
        ;

/* End : 미래구간 Char. Available (CELL_CHAR_AVAILABLE) */
/* End : 미래구간 Char. Available (CELL_CHAR_AVAILABLE) */


/* Begin : 미래구간 Form. Progress (CELL_FORM_PROGRESS) */
/* Begin : 미래구간 Form. Progress (CELL_FORM_PROGRESS) */
        /* ------------------------------------------------------------------------------------------------------------------ */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Form. Progress (CELL_FORM_PROGRESS) - 기초 재고');
        /* ------------------------------------------------------------------------------------------------------------------ */
        DELETE FROM GT_GPMM_FORM_PROGRESS_FROM_BOH;

        INSERT
          INTO GT_GPMM_FORM_PROGRESS_FROM_BOH
             ( ITEM_ID
             , FROM_SITE
             , QTY
             )
        SELECT Y.ITEM_ID
             , Y.FROM_SITE
             , SUM(Y.QTY) AS QTY
          FROM GT_GPMM_FOR_FORM_END_DAILY Y
         GROUP BY Y.ITEM_ID
                , Y.FROM_SITE
        ;

        /* ------------------------------------------------------------------------------------------------------------------ */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Form. Progress (CELL_FORM_PROGRESS) - CELL_PROD');
        /* ------------------------------------------------------------------------------------------------------------------ */
        DELETE FROM GT_GPMM_CELL_PROD;

        INSERT
          INTO GT_GPMM_CELL_PROD
             ( ITEM_ID
             , FROM_SITE
             , YYYYMM
             , QTY
             )
        SELECT PG.ITEM_ID
             , PG.FROM_SITE
             , PG.YYYYMM
             , SUM(PG.QTY) AS QTY
          FROM GT_GPMM_TMP_ASIS_GLOBAL_PSI PG
         WHERE PG.MEASURE         = 'PRODUCTION'
           AND PG.OPERATION_GROUP = 'A'
           AND PG.YYYYMM         >= V_PLAN_START_YYYYMM /* 미래 계획 구간 --   '202346' -- */
         GROUP BY PG.ITEM_ID
                , PG.FROM_SITE
                , PG.YYYYMM
         ORDER BY PG.ITEM_ID
                , PG.FROM_SITE
                , PG.YYYYMM
                , QTY
        ;

        /* ------------------------------------------------------------------------------------------------------------------ */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Form. Progress (CELL_FORM_PROGRESS) - measure 추가');
        /* CELL_FORM_PROGRESS = FROM_BOH_QTY - CELL_FOR_FORM_END - CELL_PROD_FORM_END + CELL_PROD */
        /* FROM_BOH_QTY - eng stock 'FOR' 재고 -- plant start yyyymmdd 기준 기초 재고 */
        /* ------------------------------------------------------------------------------------------------------------------ */

        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
          WITH CELL_FORM_PROGRESS_SRC AS (
               /* FROM_BOH_QTY */
			/*
			SELECT BH.ITEM_ID
				  ,BH.FROM_SITE
				  ,WL.YYYYMM
				  ,BH.QTY
			 FROM #FORM_PROGRESS_FROM_BOH BH WITH(NOLOCK)
				  INNER JOIN #TMP_MM_LIST WL WITH(NOLOCK)
						  ON WL.YYYYMM >=  @V_PLAN_START_YYYYMM  -- 미래 계획 구간
			WHERE 1=1
			*/
               /* BOH, 보류수량은 제외한다. */
			/*
			--@@@ ENDING INVENTORY BOH 사용
			SELECT BH.ITEM_ID
				  ,BH.FROM_SITE
				  ,WL.YYYYMM
				  ,BH.FORM_PROGRESS AS QTY
			 FROM #PAST_FORM_PROGRESS_CHAR_AVAILABLE BH WITH(NOLOCK)
				  INNER JOIN #TMP_MM_LIST WL WITH(NOLOCK)
						  ON WL.YYYYMM >=  @V_PLAN_START_YYYYMM  -- 미래 계획 구간
			WHERE 1=1
			  AND BH.YYYYMM = @V_RESULT_LAST_YYYYMM
			UNION ALL

					-- CELL_FOR_FORM_END : Form. End Eta (Past)
					SELECT FF.ITEM_ID
						  ,FF.FROM_SITE
						  ,FF.YYYYMM
						  ,(-1) * SUM(FF.QTY) OVER (PARTITION BY FF.ITEM_ID
															    ,FF.FROM_SITE
												      ORDER BY FF.YYYYMM)	AS QTY
					 FROM #CELL_FOR_FORM_END FF
					WHERE 1=1
					UNION ALL
			*/
                       /* CELL_PROD_FORM_END : From. End Eta (Prod) */
                       SELECT FF.ITEM_ID
                            , FF.FROM_SITE
                            , FF.YYYYMM
                            , (-1) * SUM(FF.QTY) OVER (PARTITION BY FF.ITEM_ID
                                                                  , FF.FROM_SITE
                                                           ORDER BY FF.YYYYMM) AS QTY
                         FROM GT_GPMM_CELL_PROD_FORM_END FF

                        UNION ALL
               /* */
               SELECT FF.ITEM_ID
                    , FF.FROM_SITE
                    , FF.YYYYMM
                    , SUM(FF.QTY) OVER (PARTITION BY FF.ITEM_ID
                                                   , FF.FROM_SITE
                                            ORDER BY FF.YYYYMM) AS QTY
                 FROM GT_GPMM_CELL_PROD FF
               )
        SELECT 'A'                      AS OPERATION_GROUP
             , SR.ITEM_ID
             , '-'                      AS TO_SITE
             , '-'                      AS INCOTERMS
             , SR.FROM_SITE
             , '-'                      AS VARIOUS_KEY
             , SR.YYYYMM
             , 'CELL_FORM_PROGRESS'     AS MEASURE
             , 'N'                      AS IS_CELL_IN_PACK_PLANT
             , 0.0                      AS FROM_BOH_QTY
             , 0.0                      AS TO_BOH_QTY
             , SUM(SR.QTY)              AS QTY
          FROM CELL_FORM_PROGRESS_SRC SR
         GROUP BY SR.ITEM_ID
                , SR.FROM_SITE
                , SR.YYYYMM
        ;

/* END : 미래구간 Form. Progress (CELL_FORM_PROGRESS) */
/* End : 미래구간 Form. Progress (CELL_FORM_PROGRESS) */

/* START : 미래구간 Form. Progress (CELL_CHAR_AVAILABLE, CELL_CHAR_PLAN) 재계산 위 로직은 살려둔다. 	-- 고도화 */
/* START : 미래구간 Form. Progress (CELL_CHAR_AVAILABLE, CELL_CHAR_PLAN) 재계산 위 로직은 살려둔다. */

        /* 기존 정보 삭제 */
        DELETE
          FROM GT_GPMM_CELL_CHAR_PLAN_FUTURE;

        DELETE
          FROM GT_GPMM_CELL_CHAR_PLAN_YIELD;

        DELETE
          FROM GT_GPMM_TMP_ASIS_GLOBAL_PSI
         WHERE MEASURE IN ( 'CELL_CHAR_AVAILABLE','CELL_CHAR_PLAN')
           AND YYYYMM >= V_PLAN_START_YYYYMM  /* 미래 계획 구간 */
        ;

        DECLARE
            V_CUR_FORM$CUR_YYYYMM   VARCHAR2(6 CHAR);
            V_CUR_FORM$PREV_YYYYMM  VARCHAR2(6 CHAR);
        BEGIN
            /* CUR_FORM CURSOR LOCAL FOR */
            FOR CUR_FORM IN ( SELECT YYYYMM                                                                   AS CUR_YYYYMM
                                   , TO_CHAR(TO_DATE(MONTHLY_FROM_YMD, 'YYYYMMDD') - 7, 'YYYYMM')             AS PREV_YYYYMM
                                FROM GT_GPMM_TMP_MM_LIST WL
                               WHERE WL.YYYYMM >= V_PLAN_START_YYYYMM  /* 미래 계획 구간 */
                               ORDER BY YYYYMM
                            )
            LOOP
                V_CUR_FORM$CUR_YYYYMM  := CUR_FORM.CUR_YYYYMM;
                V_CUR_FORM$PREV_YYYYMM := CUR_FORM.PREV_YYYYMM;

                INSERT
                  INTO GT_GPMM_CELL_CHAR_PLAN_FUTURE
                     ( OPERATION_GROUP
                     , ITEM_ID
                     , TO_SITE
                     , INCOTERMS
                     , FROM_SITE
                     , VARIOUS_KEY
                     , YYYYMM
                     , MEASURE
                     , IS_CELL_IN_PACK_PLANT
                     , FROM_BOH_QTY
                     , TO_BOH_QTY
                     , QTY
                     )
                  WITH CELL_CHAR_PLAN_SRC AS (
                       /* 과거 BOH 참조 */
                       SELECT BH.OPERATION_GROUP
                            , BH.ITEM_ID
                            , BH.FROM_SITE
                            , V_PLAN_START_YYYYMM                 AS YYYYMM
                            , BH.CHAR_AVAILABLE + BH.FORM_PROGRESS AS QTY
                         FROM GT_GPMM_PAST_FORM_PROGRESS_CHAR_AVAILABLE BH
                              /* INNER JOIN #TMP_MM_LIST WL WITH(NOLOCK) */
                                      /*  ON WL.YYYYMM >=  @V_PLAN_START_YYYYMM  -- 미래 계획 구간 */
                        WHERE BH.YYYYMM            = V_RESULT_LAST_YYYYMM
                          AND V_PLAN_START_YYYYMM = V_CUR_FORM$CUR_YYYYMM
/*								UNION ALL */
/*								SELECT BH.OPERATION_GROUP */
/*									  ,BH.ITEM_ID */
/*									  ,BH.FROM_SITE */
/*									  ,@CUR_FORM$CUR_YYYYMM AS YYYYMM */
/*									  ,SUM(BH.QTY) AS QTY */
/*								 FROM #TMP_ASIS_GLOBAL_PSI BH WITH(NOLOCK) */
/*								WHERE 1=1 */
/*								  AND BH.YYYYMM >= @V_PLAN_START_YYYYMM */
/*								  AND BH.YYYYMM = @CUR_FORM$PREV_YYYYMM */
/*								  AND BH.MEASURE IN ('CELL_CHAR_AVAILABLE', 'CELL_FORM_PROGRESS') */
/*								GROUP BY BH.OPERATION_GROUP */
/*										  ,BH.ITEM_ID */
/*										  ,BH.FROM_SITE */
/*										--  ,@CUR_FORM$CUR_YYYYMM */
                       UNION ALL
                       /* CELL_PROD_FORM_END : From. End Eta (Prod) */
                       SELECT FF.OPERATION_GROUP
                            , FF.ITEM_ID
                            , FF.FROM_SITE
                            , FF.YYYYMM
                            , FF.QTY
                         FROM GT_GPMM_CELL_PROD_FORM_END FF
                        WHERE FF.YYYYMM = V_CUR_FORM$CUR_YYYYMM
                       )
                SELECT CP.OPERATION_GROUP
                     , CP.ITEM_ID
                     , '-'                    AS TO_SITE
                     , '-'                    AS INCOTERMS
                     , CP.FROM_SITE
                     , '-'                    AS VARIOUS_KEY
                     , CP.YYYYMM
                     , 'CELL_CHAR_PLAN'       AS MEASURE
                     , 'N'                    AS IS_CELL_IN_PACK_PLANT
                     , 0.0                    AS FROM_BOH_QTY
                     , 0.0                    AS TO_BOH_QTY
                     , SUM(QTY)
                       * CASE WHEN NVL(FY.SSP_MODIFY_YIELD, 0) > 0      THEN FY.SSP_MODIFY_YIELD
                              WHEN NVL(FY.FORMATION_TOTAL_YIELD, 0) > 0 THEN FY.FORMATION_TOTAL_YIELD
                              ELSE 1
                         END                  AS QTY
                  FROM CELL_CHAR_PLAN_SRC        CP
                     , GT_GPMM_SCP_MST_FORMATION FY
                 WHERE FY.PLANT_SITE_ID(+) = CP.FROM_SITE
                   AND FY.ITEM_ID(+)       = CP.ITEM_ID
                   AND FY.YYYYMM(+)        = CP.YYYYMM
                   AND CP.YYYYMM           = V_CUR_FORM$CUR_YYYYMM
                 GROUP BY CP.OPERATION_GROUP
                        , CP.ITEM_ID
                        , CP.FROM_SITE
                        , CP.YYYYMM
                        , CASE WHEN NVL(FY.SSP_MODIFY_YIELD, 0) > 0      THEN FY.SSP_MODIFY_YIELD
                               WHEN NVL(FY.FORMATION_TOTAL_YIELD, 0) > 0 THEN FY.FORMATION_TOTAL_YIELD
                               ELSE 1
                          END
                ;

                INSERT
                  INTO GT_GPMM_CELL_CHAR_PLAN_YIELD
                     ( OPERATION_GROUP
                     , ITEM_ID
                     , FROM_SITE
                     , YYYYMM
                     , QTY
                     , YIELD
                     , QTY_YIELD
                     )
                  WITH CHAR_PLAN AS (
                       SELECT PG.OPERATION_GROUP
                            , PG.ITEM_ID
                            , PG.FROM_SITE
                            , PG.YYYYMM
                            , SUM(QTY) AS QTY
                            /* FROM #TMP_ASIS_GLOBAL_PSI PG WITH(NOLOCK) */
                         FROM GT_GPMM_CELL_CHAR_PLAN_FUTURE PG
                        WHERE PG.MEASURE = 'CELL_CHAR_PLAN'         /* 특성(F6000) 생산계획 -- CELL_CHAR_PLAN */
                          AND PG.YYYYMM  = V_CUR_FORM$CUR_YYYYMM   /* 미래 계획 구간 */
                        GROUP BY PG.OPERATION_GROUP
                               , PG.ITEM_ID
                               , PG.FROM_SITE
                               , PG.YYYYMM
                       )
                SELECT CP.*
                     , CASE WHEN NVL(FY.SSP_MODIFY_YIELD, 0) > 0      THEN FY.SSP_MODIFY_YIELD
                            WHEN NVL(FY.FORMATION_TOTAL_YIELD, 0) > 0 THEN FY.FORMATION_TOTAL_YIELD
                            ELSE 1
                       END AS YIELD
                     , CP.QTY / CASE WHEN NVL(FY.SSP_MODIFY_YIELD, 0) > 0      THEN FY.SSP_MODIFY_YIELD
                                     WHEN NVL(FY.FORMATION_TOTAL_YIELD, 0) > 0 THEN FY.FORMATION_TOTAL_YIELD
                                     ELSE 1
                                END AS QTY_YIELD
                  FROM CHAR_PLAN                 CP
                     , GT_GPMM_SCP_MST_FORMATION FY
                 WHERE FY.PLANT_SITE_ID(+) = CP.FROM_SITE
                   AND FY.ITEM_ID(+)       = CP.ITEM_ID
                   AND FY.YYYYMM(+)        = CP.YYYYMM
                ;

                INSERT
                  INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
                     ( OPERATION_GROUP
                     , ITEM_ID
                     , TO_SITE
                     , INCOTERMS
                     , FROM_SITE
                     , TRANSPORT_MODE_LINE
                     , YYYYMM
                     , MEASURE
                     , IS_CELL_IN_PACK_PLANT
                     , FROM_BOH_QTY
                     , TO_BOH_QTY
                     , QTY
                     )
                  WITH CHAR_AVAILABE_SRC AS (
                       /* ENDING INVENTORY BOH 사용	-- 고도화 */
                       SELECT BH.OPERATION_GROUP
                            , BH.ITEM_ID
                            , BH.FROM_SITE
                            , V_PLAN_START_YYYYMM                 AS YYYYMM
                            , BH.CHAR_AVAILABLE + BH.FORM_PROGRESS AS QTY
                         FROM GT_GPMM_PAST_FORM_PROGRESS_CHAR_AVAILABLE BH
                        WHERE BH.YYYYMM            = V_RESULT_LAST_YYYYMM
                          AND V_PLAN_START_YYYYMM = V_CUR_FORM$CUR_YYYYMM
/*								UNION ALL */
/*								SELECT BH.OPERATION_GROUP */
/*									  ,BH.ITEM_ID */
/*									  ,BH.FROM_SITE */
/*									  ,@CUR_FORM$CUR_YYYYMM AS YYYYMM */
/*									  ,SUM(BH.QTY) AS QTY */
/*								 FROM #TMP_ASIS_GLOBAL_PSI BH WITH(NOLOCK) */
/*								WHERE 1=1 */
/*								  AND BH.YYYYMM >= @V_PLAN_START_YYYYMM */
/*								  AND BH.YYYYMM = @CUR_FORM$PREV_YYYYMM */
/*								  AND BH.MEASURE IN ('CELL_CHAR_AVAILABLE', 'CELL_FORM_PROGRESS') */
/*								GROUP BY BH.OPERATION_GROUP */
/*										  ,BH.ITEM_ID */
/*										  ,BH.FROM_SITE */

                       UNION ALL
                       /* CELL_PROD_FORM_END : From. End Eta (Prod) */
                       SELECT FF.OPERATION_GROUP
                            , FF.ITEM_ID
                            , FF.FROM_SITE
                            , FF.YYYYMM
                            , SUM(FF.QTY)
                                    /* OVER (PARTITION BY FF.ITEM_ID */
                                    /*						 ,FF.FROM_SITE */
                                    /*				 ORDER BY FF.YYYYMM)	AS QTY */
                         FROM GT_GPMM_CELL_PROD_FORM_END FF
                        WHERE FF.YYYYMM >= V_CUR_FORM$CUR_YYYYMM
                          AND FF.YYYYMM BETWEEN V_CUR_FORM$PREV_YYYYMM AND V_CUR_FORM$CUR_YYYYMM
                        GROUP BY FF.OPERATION_GROUP
                               , FF.ITEM_ID
                               , FF.FROM_SITE
                               , FF.YYYYMM
                       UNION ALL
                       /* CELL_CHAR_PLAN : Char. Plan */
                       SELECT CP.OPERATION_GROUP
                            , CP.ITEM_ID
                            , CP.FROM_SITE
                            , CP.YYYYMM
                            , (-1) * SUM(CP.QTY_YIELD)
                                                /* OVER (PARTITION BY CP.ITEM_ID */
                                                        /*	  ,CP.FROM_SITE */
                                                  /* ORDER BY CP.YYYYMM) AS QTY */
                         FROM GT_GPMM_CELL_CHAR_PLAN_YIELD CP
                        WHERE CP.YYYYMM >= V_CUR_FORM$CUR_YYYYMM
                          AND CP.YYYYMM BETWEEN V_CUR_FORM$PREV_YYYYMM AND V_CUR_FORM$CUR_YYYYMM
                        GROUP BY CP.OPERATION_GROUP
                               , CP.ITEM_ID
                               , CP.FROM_SITE
                               , CP.YYYYMM
                       )
                SELECT CA.OPERATION_GROUP
                     , CA.ITEM_ID
                     , '-'                     AS TO_SITE
                     , '-'                     AS INCOTERMS
                     , CA.FROM_SITE
                     , '-'                     AS VARIOUS_KEY
                     , CA.YYYYMM
                     , 'CELL_CHAR_AVAILABLE'   AS MEASURE
                     , 'N'                     AS IS_CELL_IN_PACK_PLANT
                     , 0.0                     AS FROM_BOH_QTY
                     , 0.0                     AS TO_BOH_QTY
                     , SUM(QTY)                AS QTY
                  FROM CHAR_AVAILABE_SRC CA
                 GROUP BY CA.OPERATION_GROUP
                        , CA.ITEM_ID
                        , CA.FROM_SITE
                        , CA.YYYYMM
                ;

                /* print  convert(varchar(30), getdate(), 121) + '::' + @CUR_FORM$CUR_YYYYMM */

                IF V_CUR_FORM$CUR_YYYYMM = SUBSTR(V_HORIZON_END_YYYYMMDD, 1, 6) THEN
                    EXIT;  /* BREAK */
                END IF;

            END LOOP;  /* CLOSE CUR_FORM / DEALLOCATE CUR_FORM */
        END;

        /* ---------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Char. Plan  measure 추가 (임시) - insert ');
        /* ---------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , VARIOUS_KEY
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
          FROM GT_GPMM_CELL_CHAR_PLAN_FUTURE
        ;

/* END : 미래구간 Form. Progress (CELL_CHAR_AVAILABLE, CELL_CHAR_PLAN) 재계산 위 로직은 살려둔다. */
/* END : 미래구간 Form. Progress (CELL_CHAR_AVAILABLE, CELL_CHAR_PLAN) 재계산 위 로직은 살려둔다. */


        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : (AS) AS in Plan, AS Inv measure 추가');
        /* ---------------------------------------------------------------------------------------------------------------------------- */
        /* ★ DM_PLN_MKT_FCST_C 의 MEASURE 실데이터 표기는 'AS_In_Req'·'AS_In_Plan'·'AS_Inv' (AS-IS 는 대소문자 무시 비교) → 두 표기 모두 조건에 포함 */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT FI.OPERATION_GROUP
             , FI.ITEM_ID
             , MK.SCM_SITE_ID   AS TO_SITE
             , MK.INCOTERMS
             , '-'              AS FROM_SITE  /* SCP global psi는 to 사이트 기준 데이터임 */
             , MK.PROJECT_CODE
             , DI.YYYYMM
             , MK.MEASURE
             , 'N'              AS IS_CEL_INVENTORY
             , 0.0              AS FROM_BOH_QTY
             , 0.0              AS TO_BOH_QTY
             , SUM(CASE WHEN UPPER(MK.MEASURE) = 'AS_INV' AND DI.MONTHLY_TO_YMD = MK.YYYYMMDD
                        THEN MK.QTY
                        WHEN UPPER(MK.MEASURE) IN ('AS_IN_REQ', 'AS_IN_PLAN')
                        THEN MK.QTY
                        ELSE 0.0
                    END)        AS QTY
          FROM DM_PLN_MKT_FCST_C          MK
             , GT_GPMM_SCP_MST_FINAL_ITEM FI
             , GT_GPMM_SCM_MST_SITE       MS
             , GT_GPMM_TMP_DATE_INFO      DI
         WHERE FI.ITEM_ID         = MK.ITEM_ID
           AND MS.SCM_SITE_ID     = MK.SCM_SITE_ID
           AND DI.YYYYMMDD        = MK.YYYYMMDD
           AND MK.FCST_TYPE      IN ( SELECT FCST_TYPE
                                        FROM GT_GPMM_TMP_AS_SALES_TYPE_CODE )  /* 'WS' 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경 */
           AND MS.SITE_TYPE       = 'SALES'
           AND MS.OPERATION_GROUP = 'W'  /* to AS Sales Site */
           AND MK.MEASURE        IN ('AS_IN_REQ', 'AS_IN_PLAN', 'AS_INV', 'AS_In_Req', 'AS_In_Plan', 'AS_Inv')
           AND MK.DIVISION_ID     = V_DIVISION_ID
           AND MK.VERSION_NO      = V_DM_VERSION_NO
         GROUP BY FI.OPERATION_GROUP
                , FI.ITEM_ID
                , MK.SCM_SITE_ID
                , MK.INCOTERMS
                , MK.PROJECT_CODE
                , DI.YYYYMM
                , MK.MEASURE
        ;

        /* AS_IN_PLAN, AS_IN_REQ 계획 구간 이전 일자 추가	-- ADD 2024.09.30 */
        /* 2026.10.22 AS 출하 뷰 시노님·NPP 시퀀스 생성 후 정적 SQL 로 환원 */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT II.OPERATION_GROUP
             , IV.ITEM_ID
             , NVL(TS.SCM_SITE_ID, '-') AS TO_SITE
             , '-'                      AS INCOTERMS
             , NVL(FS.SCM_SITE_ID, '-') AS FROM_SITE
             , '-'                      AS PROJECT_CODE
             , DI.YYYYMM
             , ML.MEASURE               AS MEASURE
             , 'N'                      AS IS_CEL_INVENTORY
             , 0.0                      AS FROM_BOH_QTY
             , 0.0                      AS TO_BOH_QTY
             , SUM(IV.QTY)              AS QTY
          FROM SCM_AS_SHIP_V_SN                      IV
             , GT_GPMM_TMP_DATE_INFO                 DI
             , ( SELECT 'AS_IN_REQ' AS MEASURE FROM DUAL UNION ALL SELECT 'AS_IN_PLAN' AS MEASURE FROM DUAL
               )                                     ML
             , GT_GPMM_TMP_TARGET_ITEM_FOR_ENDING_INV II
             , GT_GPMM_SCM_MST_SITE                  FS
             , GT_GPMM_SCM_MST_SITE                  TS
         WHERE IV.SHIP_YYYYMMDD         = DI.YYYYMMDD
           AND II.ITEM_ID               = IV.ITEM_ID
           AND FS.PLANT_ID(+)           = IV.PLANT_ID
           AND FS.OPERATION_GROUP(+)    = II.OPERATION_GROUP
           AND TS.OPERATION_GROUP(+)    = II.OPERATION_GROUP
           AND FS.SITE_TYPE(+)          = 'PLANT'
           AND TS.SITE_TYPE(+)          = 'PLANT'
           AND TS.PLANT_ID(+)           = 'Z'
           AND IV.QTY                  <> 0
           AND DI.YYYYMM               <= V_PLAN_START_YYYYMM
           AND IV.DIVISION_ID           = V_DIVISION_ID
           AND IV.SHIP_YYYYMMDD         < V_PLAN_START_YYYYMMDD
         GROUP BY II.OPERATION_GROUP
                , IV.ITEM_ID
                , NVL(TS.SCM_SITE_ID, '-')
                , NVL(FS.SCM_SITE_ID, '-')
                , DI.YYYYMM
                , ML.MEASURE;
        /* FROM SCM_AS_SHIP_V_SN IV WITH(NOLOCK) / LEFT JOIN #SCM_MST_SITE FS -- from site / LEFT JOIN #SCM_MST_SITE TS -- to site */
        /* AND IV.QTY <> 0 -- E20251023-001360 '> 0' 에서 '<> 0' 으로 변경 */

        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : (AS) MKT_FCST/RTF measure 추가');
        /* ---------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT FI.OPERATION_GROUP
             , FI.ITEM_ID
             , MK.SCM_SITE_ID          AS TO_SITE
             , MK.INCOTERMS
             , '-'                     AS FROM_SITE  /* SCP global psi는 to 사이트 기준 데이터임 */
             , MK.PROJECT_CODE
             , DI.YYYYMM
             , 'AS_' || MK.MEASURE     AS MEASURE
             , 'N'                     AS IS_CEL_INVENTORY
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , SUM(MK.QTY)             AS QTY
          FROM DM_PLN_MKT_FCST_C          MK
             , GT_GPMM_SCP_MST_FINAL_ITEM FI
             , GT_GPMM_SCM_MST_SITE       MS
             , GT_GPMM_TMP_DATE_INFO      DI
         WHERE FI.ITEM_ID                 = MK.ITEM_ID
           AND MS.SCM_SITE_ID             = MK.SCM_SITE_ID
           AND DI.YYYYMMDD                = MK.YYYYMMDD
           AND MK.FCST_TYPE              IN ( SELECT FCST_TYPE
                                                FROM GT_GPMM_TMP_AS_SALES_TYPE_CODE )  /* 'WS' 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경 */
           AND MS.SITE_TYPE               = 'SALES'
           AND NVL(MS.OPERATION_GROUP, '-') <> 'W'  /* AS Sales Site 제외 */
           AND MK.MEASURE                IN ('MKT_FCST', 'RTF')
           AND MK.DIVISION_ID             = V_DIVISION_ID
           AND MK.VERSION_NO              = V_DM_VERSION_NO
           AND MK.YYYYMMDD               >= V_PLAN_START_YYYYMMDD  /* E20260422-001155 */
         GROUP BY FI.OPERATION_GROUP
                , FI.ITEM_ID
                , MK.SCM_SITE_ID
                , MK.INCOTERMS
                , MK.PROJECT_CODE
                , DI.YYYYMM
                , 'AS_' || MK.MEASURE
        ;

        /* ---------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : AS_INVENTORY 추가');
        /* AS inventory = 전주 + AS in plan - AS RTF */
        /* 고도화  -- (2024.09.02 변경건) */
        /* ---------------------------------------------------------------------------------------------------------- */

        /* ★ 'AS_Inv'(DM 실데이터 표기) 행도 AS-IS 대소문자 무시 비교로 지워졌음 → UPPER 비교 */
        DELETE
          FROM GT_GPMM_TMP_ASIS_GLOBAL_PSI
         WHERE UPPER(MEASURE) = 'AS_INV'
           AND YYYYMM        >= V_PLAN_START_YYYYMM
        ;

        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
          WITH BASE_DATA AS (
               SELECT WI.YYYYMM
                    , WI.ITEM_ID
                    , WI.OPERATION_GROUP
/*					,WI.FROM_SITE */
/*					,WI.TO_SITE */
/*					,WI.INCOTERMS */
/*					,WI.TRANSPORT_MODE_LINE */
/*					,WI.IS_CELL_IN_PACK_PLANT */
                    , SUM(WI.PLAN_QTY) AS PLAN_QTY
                    , SUM(WI.PROD_QTY) AS PROD_QTY
                 FROM ( SELECT WL.YYYYMM
                             , WI.ITEM_ID
                             , WI.OPERATION_GROUP
/*								,WI.FROM_SITE */
/*								,WI.TO_SITE */
/*								,WI.INCOTERMS */
/*								,WI.TRANSPORT_MODE_LINE */
/*								,WI.IS_CELL_IN_PACK_PLANT */
                             , CASE WHEN WL.YYYYMM = WI.YYYYMM THEN WI.QTY ELSE 0 END AS PLAN_QTY
                             , 0                                                      AS PROD_QTY
                          FROM GT_GPMM_TMP_ASIS_GLOBAL_PSI WI
                             , GT_GPMM_TMP_MM_LIST         WL
                         WHERE WL.YYYYMM     >= V_PLAN_START_YYYYMM  /* 미래 계획 구간 */
                           AND WI.MEASURE     = 'AS_RTF'
                           /* AND WI.OPERATION_GROUP	= 'P'			 -- 팩출하 */
                           AND WI.YYYYMM     >= V_PLAN_START_YYYYMM  /* 미래 계획 구간 */
                        UNION ALL
                        /* 실적구간 - 팩출하 */
                        SELECT WL.YYYYMM
                             , WI.ITEM_ID
                             , WI.OPERATION_GROUP
/*								,WI.FROM_SITE */
/*								,WI.TO_SITE */
/*								,WI.INCOTERMS */
/*								,WI.TRANSPORT_MODE_LINE */
/*								,WI.IS_CELL_IN_PACK_PLANT */
                             , 0                                                      AS PLAN_QTY
                             , CASE WHEN WL.YYYYMM = WI.YYYYMM THEN WI.QTY ELSE 0 END AS QTY
                          FROM GT_GPMM_TMP_ASIS_GLOBAL_PSI WI
                             , GT_GPMM_TMP_MM_LIST         WL
                         WHERE WL.YYYYMM         >= V_PLAN_START_YYYYMM  /* 미래 계획 구간 */
                           AND UPPER(WI.MEASURE)  = 'AS_IN_PLAN'         /* ★ DM 'AS_In_Plan' 포함(AS-IS 대소문자 무시) */
                           AND WI.YYYYMM         >= V_PLAN_START_YYYYMM  /* 미래 계획 구간 */
                      ) WI
                GROUP BY WI.YYYYMM
                       , WI.ITEM_ID
                       , WI.OPERATION_GROUP
/*					,WI.FROM_SITE */
/*					,WI.TO_SITE */
/*					,WI.INCOTERMS */
/*					,WI.TRANSPORT_MODE_LINE */
/*					,WI.IS_CELL_IN_PACK_PLANT */
               )
        SELECT DISTINCT
               PG.OPERATION_GROUP
             , PG.ITEM_ID
             , PG.TO_SITE                AS TO_SITE
             , PG.INCOTERMS              AS INCOTERMS
             , PG.FROM_SITE              AS FROM_SITE
             , PG.TRANSPORT_MODE_LINE    AS TRANSPORT_MODE_LINE
             , PG.YYYYMM
             , 'AS_INV'                  AS MEASURE
             , 'N'                       AS IS_CELL_IN_PACK_PLANT
             , 0.0                       AS FROM_BOH_QTY
             , 0.0                       AS TO_BOH_QTY
             , SUM(PG.ACC_QTY) OVER (PARTITION BY PG.ITEM_ID
                                                , PG.OPERATION_GROUP
                                                , PG.FROM_SITE
                                         ORDER BY PG.YYYYMM ) AS QTY
          FROM ( SELECT BD.YYYYMM
                      , BD.OPERATION_GROUP
                      , BD.ITEM_ID
                      , '-' AS TO_SITE
                      , '-' AS INCOTERMS
                      , '-' AS FROM_SITE
                      , '-' AS TRANSPORT_MODE_LINE
                      , 'N' AS IS_CELL_IN_PACK_PLANT
                      , NVL(CASE WHEN BD.YYYYMM = V_PLAN_START_YYYYMM THEN NVL(SO.BOH, 0) + BD.PROD_QTY - BD.PLAN_QTY ELSE 0 + BD.PROD_QTY - BD.PLAN_QTY END, 0) AS ACC_QTY
/*						,CASE WHEN BD.YYYYMM = WL.YYYYMM THEN */
/*									ISNULL(CASE WHEN BD.YYYYMM = @V_PLAN_START_YYYYMM THEN ISNULL(SO.BOH,0) + BD.PROD_QTY - BD.PLAN_QTY ELSE 0 + BD.PROD_QTY - BD.PLAN_QTY END,0) */
/*							  ELSE 0 END ACC_QTY */
                   FROM BASE_DATA BD
                        /* INNER JOIN #TMP_MM_LIST WL WITH(NOLOCK) */
                        /*		ON WL.YYYYMM >=  @V_PLAN_START_YYYYMM  -- 미래 계획 구간 */
                      , ( SELECT WI.ITEM_ID
                               , WI.OPERATION_GROUP
                               , WI.FROM_SITE
                               , '-'         AS TO_SITE
                               , SUM(WI.QTY) AS BOH
                            FROM GT_GPMM_TMP_ENDING_INV_MM WI
                           WHERE WI.YYYYMM  = V_RESULT_LAST_YYYYMM
                             AND WI.MEASURE = 'AS_INV'
                           GROUP BY WI.ITEM_ID
                                  , WI.OPERATION_GROUP
                                  , WI.FROM_SITE
                        ) SO
                  WHERE SO.ITEM_ID(+)         = BD.ITEM_ID
                    AND SO.OPERATION_GROUP(+) = BD.OPERATION_GROUP
                    /* AND BD.FROM_SITE = SO.FROM_SITE */
               ) PG
        ;

        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT WI.OPERATION_GROUP
             , WI.ITEM_ID
             , '-'               AS TO_SITE
             , '-'               AS INCOTERMS
             , '-'               AS FROM_SITE
             , '-'               AS TRANSPORT_MODE_LINE
             , WL.YYYYMM
             , 'AS_INV'          AS MEASURE
             , 'N'               AS IS_CELL_IN_PACK_PLANT
             , 0.0               AS FROM_BOH_QTY
             , 0.0               AS TO_BOH_QTY
             , SUM(WI.QTY)       AS QTY
          FROM GT_GPMM_TMP_ENDING_INV_MM WI
             , GT_GPMM_TMP_MM_LIST       WL
         WHERE WL.YYYYMM  >= V_PLAN_START_YYYYMM  /* 미래 계획 구간 */
           AND NOT EXISTS ( SELECT 1
                              FROM GT_GPMM_TMP_ASIS_GLOBAL_PSI X
                             WHERE UPPER(X.MEASURE)  = 'AS_INV'
                               AND X.ITEM_ID         = WI.ITEM_ID
                               /* AND		X.FROM_SITE = WI.FROM_SITE */
                               AND X.OPERATION_GROUP = WI.OPERATION_GROUP
                               AND X.YYYYMM         >= V_PLAN_START_YYYYMM
                          )
           AND WI.YYYYMM   = V_RESULT_LAST_YYYYMM
           AND WI.MEASURE  = 'AS_INV'
         GROUP BY WL.YYYYMM
                , WI.ITEM_ID
                /* ,WI.FROM_SITE */
                , WI.OPERATION_GROUP
        ;


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
			  ,DI.YYYYMM
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
				,DI.YYYYMM
			    ,CASE WHEN SP.MEASURE = 'ALLOCATION' THEN 'RTF' ELSE SP.MEASURE END
		*/
        /* E20260422-001155 GLOBAL PSI NEW - PLAN (MKT FCST & RTF) 기준 TABLE 변경 / 프로시져 특정시간에 작동 문의 관련 주석처리 끝 */
        /* E20260422-001155 GLOBAL PSI NEW - PLAN (MKT FCST & RTF) 기준 TABLE 변경 / 프로시져 특정시간에 작동 문의 관련 신규로직 시작 */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT FI.OPERATION_GROUP
             , FI.ITEM_ID
             , MK.SCM_SITE_ID          AS TO_SITE
             , MK.INCOTERMS
             , '-'                     AS FROM_SITE  /* SCP global psi는 to 사이트 기준 데이터임 */
             , MK.PROJECT_CODE
             , DI.YYYYMM
             , CASE WHEN MK.MEASURE = 'RTF_SYS_RP' THEN 'RTF' ELSE MK.MEASURE END AS MEASURE
             , 'N'                     AS IS_CEL_INVENTORY
             , 0.0                     AS FROM_BOH_QTY
             , 0.0                     AS TO_BOH_QTY
             , SUM(MK.QTY)             AS QTY
          FROM DM_PLN_MKT_FCST_C          MK
             , GT_GPMM_SCP_MST_FINAL_ITEM FI
             , GT_GPMM_SCM_MST_SITE       MS
             , GT_GPMM_TMP_DATE_INFO      DI
         WHERE FI.ITEM_ID                 = MK.ITEM_ID
           AND MS.SCM_SITE_ID             = MK.SCM_SITE_ID
           AND DI.YYYYMMDD                = MK.YYYYMMDD
           AND MK.FCST_TYPE          NOT IN ( SELECT FCST_TYPE
                                                FROM GT_GPMM_TMP_AS_SALES_TYPE_CODE )  /* 'WS' 2025.05.28 kimcd AS 대상 FCST_TYPE 검증 로직 변경 */
           AND MS.SITE_TYPE               = 'SALES'
           AND NVL(MS.OPERATION_GROUP, '-') <> 'W'  /* AS Sales Site 제외 */
           AND MK.MEASURE                IN ('MKT_FCST', 'RTF_SYS_RP')
           AND MK.DIVISION_ID             = V_DIVISION_ID
           AND MK.VERSION_NO              = V_DM_VERSION_NO
           AND MK.YYYYMMDD               >= V_PLAN_START_YYYYMMDD
         GROUP BY FI.OPERATION_GROUP
                , FI.ITEM_ID
                , MK.SCM_SITE_ID
                , MK.INCOTERMS
                , MK.PROJECT_CODE
                , DI.YYYYMM
                , MK.MEASURE
        ;
        /* E20260422-001155 GLOBAL PSI NEW - PLAN (MKT FCST & RTF) 기준 TABLE 변경 / 프로시져 특정시간에 작동 문의 관련 신규로직 끝 */

        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : TO_SITE_EOH(WH_IN_BALANCE) 계산 위한 Sales Site 기초 재고');
        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_SALES_SITE_BOH;

        INSERT
          INTO GT_GPMM_SALES_SITE_BOH
             ( SITE_ID
             , ITEM_ID
             , BOH_QTY
             )
        SELECT SO.SITE_ID
             , SO.ITEM_ID
             , SO.PSI_BOH_QTY AS BOH_QTY
          FROM SCP_PLN_SALES_ONHAND_V SO
             , GT_GPMM_SCM_MST_SITE TS
         WHERE TS.SCM_SITE_ID                 = SO.SITE_ID
           AND TS.SITE_TYPE                   = 'SALES'
           AND NVL(TS.OPERATION_GROUP, '-')  <> 'W'  /* AS 사이트 제외 */
           AND SO.DIVISION_ID                 = V_DIVISION_ID
           AND SO.PLAN_START_YYYYMMDD         = V_PLAN_START_YYYYMMDD
           AND SO.PLAN_TYPE                   = V_PLAN_TYPE
           AND SO.SEQ                         = V_PLAN_SEQ
           AND SO.YYYYMMDD                    = V_PLAN_START_YYYYMMDD
        ;

        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : TO_SITE_EOH(WH_IN_BALANCE) 계산 위한 Sales Site 입고 및 RTF');
        /* TO_SITE_EOH = plant date 기준 기초재고 + (누적)WH In - (누적)RTF */
        /* plan date 기준 기초재고를 참조하기 때문에 당월의 경우 실적이 반영안된 계획 구간의 RTF만 참조되도록 함 */
        /* RTF 실적구간은 계획 구간 TO_SITE_EOH 산정 후 추가함. */
        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_WH_IN_RTF;

        INSERT
          INTO GT_GPMM_WH_IN_RTF
             ( ITEM_ID
             , OPERATION_GROUP
             , TO_SITE
             , INCOTERMS
             , YYYYMM
             , WH_IN
             , WH_IN_ACC
             , RTF
             , RTF_ACC
             )
        SELECT PG.ITEM_ID
             , PG.OPERATION_GROUP
             , PG.TO_SITE
             , PG.INCOTERMS
             , PG.YYYYMM
             , SUM(CASE WHEN MEASURE = 'WH_IN' THEN PG.QTY ELSE 0.0 END)                     AS WH_IN
             , SUM(SUM(CASE WHEN MEASURE = 'WH_IN' THEN PG.QTY ELSE 0.0 END))
                   OVER (PARTITION BY PG.ITEM_ID
                                    , PG.OPERATION_GROUP
                                    , PG.TO_SITE
                                    , PG.INCOTERMS
                             ORDER BY PG.YYYYMM )                                             AS WH_IN_ACC
             , SUM(CASE WHEN MEASURE = 'RTF' THEN PG.QTY ELSE 0.0 END)                       AS RTF
             , SUM(SUM(CASE WHEN MEASURE = 'RTF' THEN PG.QTY ELSE 0.0 END))
                   OVER (PARTITION BY PG.ITEM_ID
                                    , PG.OPERATION_GROUP
                                    , PG.TO_SITE
                                    , PG.INCOTERMS
                             ORDER BY PG.YYYYMM )                                             AS RTF_ACC
          FROM GT_GPMM_TMP_ASIS_GLOBAL_PSI PG
             , GT_GPMM_SCM_MST_SITE        TS
         WHERE TS.SCM_SITE_ID                = PG.TO_SITE
           AND TS.SITE_TYPE                  = 'SALES'
           AND NVL(TS.OPERATION_GROUP, '-') <> 'W'  /* AS 사이트 제외 */
           AND PG.MEASURE                   IN ('RTF', 'WH_IN')
         GROUP BY PG.OPERATION_GROUP
                , PG.ITEM_ID
                , PG.TO_SITE
                , PG.INCOTERMS
                , PG.YYYYMM
        ;

        /* 'ESST_CA_WND' 은 VMI Inventory 에 포함하지 않는다. */
        DELETE
          FROM GT_GPMM_WH_IN_RTF
         WHERE TO_SITE        = 'ESST_CA_WND'
           AND ITEM_ID     LIKE 'ACEH1131I-B1%'
           AND V_DIVISION_ID  = '81'  /* 1= (CASE WHEN @V_DIVISION_ID = '81' THEN 1 ELSE 0 END) */
        ;


        /* E20251028-000389 YMH Unmatched Inv 구간복사 / MISMATCH_INV 데이터 를 쌓아놓고 TOTAL UnMatched Inv 를 만든다.' */
        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : MISMATCH_INV (Unmatched Inv) Measure 추가 - MISMATCH_INV 미래구간 생성');
        /* ---------------------------------------------------------------------------------------------------------------------------- */

        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT '-'                AS OPERATION_GROUP
             , SO.ITEM_ID
             , SO.TO_SITE         AS TO_SITE
             , '-'                AS INCOTERMS
             , SO.FROM_SITE       AS FROM_SITE
             , '-'                AS TRANSPORT_MODE_LINE
             , ML.YYYYMM          AS YYYYMM
             , 'MISMATCH_INV'     AS MEASURE
             , 'N'                AS IS_CELL_IN_PACK_PLANT
             , 0.0                AS FROM_BOH_QTY
             , 0.0                AS TO_BOH_QTY
             , SUM(SO.QTY)        AS QTY
          FROM GT_GPMM_TMP_ENDING_INV_MM SO
             , GT_GPMM_TMP_MM_LIST       ML
         WHERE ML.YYYYMM  >= V_PLAN_START_YYYYMM  /* 계획 구간 */
           AND NOT EXISTS ( SELECT 1
                              FROM GT_GPMM_TMP_ASIS_GLOBAL_PSI X
                             WHERE X.MEASURE         = 'MISMATCH_INV'
                               AND X.ITEM_ID         = SO.ITEM_ID
                               AND X.OPERATION_GROUP = SO.OPERATION_GROUP
                               AND X.FROM_SITE       = SO.FROM_SITE
                               AND X.TO_SITE         = SO.TO_SITE
                               AND X.MEASURE         = SO.MEASURE
                               AND X.YYYYMM          = SO.YYYYMM
                          )
           AND SO.YYYYMM   = V_RESULT_LAST_YYYYMM
           AND SO.MEASURE  = 'MISMATCH_INV'
         GROUP BY SO.ITEM_ID
                , SO.OPERATION_GROUP
                , SO.FROM_SITE
                , SO.TO_SITE
                , SO.MEASURE
                , ML.YYYYMM
        ;



        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : TO_SITE_EOH (WH_IN_BALANCE) VMI Inventory Measure 추가');
        /* ---------------------------------------------------------------------------------------------------------------------------- */
        /* -- 고도화 */
		/*
		INSERT INTO #TMP_ASIS_GLOBAL_PSI
		SELECT WR.OPERATION_GROUP
			  ,WR.ITEM_ID
			  ,WR.TO_SITE
			  ,WR.INCOTERMS
			  ,'-'				AS FROM_SITE
			  ,'-'				AS TRANSPORT_MODE_LINE
			  ,WR.YYYYMM
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

        /* ★ANSI 유지 : SO 바깥조인 ON 절에 왼쪽 인라인 뷰(PG)만 거는 조건 PG.IDX = 1 이 있어 (+) 로 표현 불가 */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT DISTINCT
               PG.OPERATION_GROUP
             , PG.ITEM_ID
             , PG.TO_SITE
             , PG.INCOTERMS
             , '-'               AS FROM_SITE
             , '-'               AS TRANSPORT_MODE_LINE
             , PG.YYYYMM
             , 'TO_SITE_EOH'     AS MEASURE
             , 'N'               AS IS_CELL_IN_PACK_PLANT
             , 0.0               AS FROM_BOH_QTY
             , 0.0               AS TO_BOH_QTY
             , SUM(PG.ACC_QTY) OVER (PARTITION BY PG.ITEM_ID
                                                , PG.OPERATION_GROUP
                                                , PG.TO_SITE
                                                , PG.INCOTERMS
                                         ORDER BY PG.YYYYMM ) AS QTY
          FROM ( SELECT PG.ITEM_ID
                      , PG.OPERATION_GROUP
                      , PG.TO_SITE
                      , PG.INCOTERMS
                      , WL.YYYYMM
                      , SO.QTY
                      , PG.WH_IN
                      , PG.RTF
                      , CASE WHEN PG.YYYYMM = WL.YYYYMM THEN
                                  NVL(CASE WHEN PG.YYYYMM = V_PLAN_START_YYYYMM THEN NVL(SO.QTY, 0) + PG.WH_IN - PG.RTF ELSE 0 + PG.WH_IN - PG.RTF END, 0)
                             ELSE 0
                        END AS ACC_QTY
                   FROM ( SELECT PG.*
                               , RANK() OVER (PARTITION BY PG.ITEM_ID
                                                  ORDER BY PG.YYYYMM, PG.TO_SITE DESC, INCOTERMS ) AS IDX  /* '-' 정보를 뒤로 주기 위해서 */
                            FROM GT_GPMM_WH_IN_RTF PG
                           WHERE PG.YYYYMM >= V_PLAN_START_YYYYMM
                        ) PG
                        INNER JOIN GT_GPMM_TMP_MM_LIST WL
                                ON WL.YYYYMM >= V_PLAN_START_YYYYMM
                        LEFT OUTER JOIN
                        ( SELECT SO.ITEM_ID
                               , SO.OPERATION_GROUP
                               , SUM(SO.QTY) AS QTY
                            FROM GT_GPMM_TMP_ENDING_INV_MM SO
                           WHERE SO.YYYYMM  = V_RESULT_LAST_YYYYMM
                             AND SO.MEASURE = 'TO_SITE_EOH'
                           GROUP BY SO.ITEM_ID
                                  , SO.OPERATION_GROUP
                        ) SO
                                ON PG.ITEM_ID         = SO.ITEM_ID
                               AND PG.OPERATION_GROUP = SO.OPERATION_GROUP
                               AND PG.IDX             = 1
               ) PG
        ;




        /* @@@ 미래계획 기준이 없을 경우 넣어준다. */
        INSERT
          INTO GT_GPMM_TMP_ASIS_GLOBAL_PSI
             ( OPERATION_GROUP
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , YYYYMM
             , MEASURE
             , IS_CELL_IN_PACK_PLANT
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , QTY
             )
        SELECT SO.OPERATION_GROUP
             , SO.ITEM_ID
             , SO.FROM_SITE      AS TO_SITE
             , '-'               AS INCOTERMS
             , '-'               AS FROM_SITE
             , '-'               AS TRANSPORT_MODE_LINE
             , ML.YYYYMM         AS YYYYMM
             , 'TO_SITE_EOH'     AS MEASURE
             , 'N'               AS IS_CELL_IN_PACK_PLANT
             , 0.0               AS FROM_BOH_QTY
             , 0.0               AS TO_BOH_QTY
             , SUM(SO.QTY)       AS QTY
          FROM GT_GPMM_TMP_ENDING_INV_MM SO
             , GT_GPMM_TMP_MM_LIST       ML
         WHERE ML.YYYYMM  >= V_PLAN_START_YYYYMM
           AND NOT EXISTS ( SELECT 1
                              FROM GT_GPMM_TMP_ASIS_GLOBAL_PSI X
                             WHERE X.MEASURE         = 'TO_SITE_EOH'
                               AND X.ITEM_ID         = SO.ITEM_ID
                               AND X.OPERATION_GROUP = SO.OPERATION_GROUP
                               AND X.YYYYMM         >= V_PLAN_START_YYYYMM
                          )
           AND SO.YYYYMM   = V_RESULT_LAST_YYYYMM
           AND SO.MEASURE  = 'TO_SITE_EOH'
         GROUP BY SO.ITEM_ID
                , SO.OPERATION_GROUP
                , SO.FROM_SITE
                , ML.YYYYMM
        ;

        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Intransit 재고(EOH) 계산 참조를 위한 intransit 기초 재고');
        /* ---------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_INTRANSIT_BOH;

        INSERT
          INTO GT_GPMM_INTRANSIT_BOH
             ( FROM_SITE
             , TO_SITE
             , INCOTERMS
             , ITEM_ID
             , INT_BOH_QTY
             )
        SELECT SUBSTR(ES.LOT_ID, FN_CHARINDEX_REV(ES.LOT_ID, '::', 0) + 2, 100)                                    AS FROM_SITE
             , SUBSTR(ES.SITE_ID, 1, FN_CHARINDEX_REV(ES.SITE_ID, '~', 0) - 1)                                     AS TO_SITE
             , SUBSTR(ES.SITE_ID, FN_CHARINDEX_REV(ES.SITE_ID, '~', 0) + 1, LENGTH(RTRIM(ES.SITE_ID)))             AS INCOTERMS
             , ES.ITEM_ID
             , SUM(ES.QTY)                                                                                         AS INT_BOH_QTY
          FROM GT_GPMM_SCP_PLN_TH_ENG_STOCK_PLAN ES
         WHERE ES.DESCR = 'INT'  /* intransit 해상재고 */
         GROUP BY SUBSTR(ES.LOT_ID, FN_CHARINDEX_REV(ES.LOT_ID, '::', 0) + 2, 100)
                , SUBSTR(ES.SITE_ID, 1, FN_CHARINDEX_REV(ES.SITE_ID, '~', 0) - 1)
                , SUBSTR(ES.SITE_ID, FN_CHARINDEX_REV(ES.SITE_ID, '~', 0) + 1, LENGTH(RTRIM(ES.SITE_ID)))
                , ES.ITEM_ID
        ;

        /* ----------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Intransit 재고(EOH) 계산');
        /* Intransit(EOH) = 해당월 Intransit BOH(전월 Intransit EOH) + 출하(ship plan) - 입고(wh in) */
        /* ----------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_INTRANSIT;

		/**
		SELECT PG.FROM_SITE
			  ,PG.TO_SITE
			  ,PG.ITEM_ID
			  ,PG.INCOTERMS
			  ,DI.YYYYMM
			  ,ISNULL(BO.INT_BOH_QTY, CONVERT(NUMERIC(20,10), 0))					AS INT_BOH_QTY	-- plan date 기준 int boh
			  ,ISNULL(BO.INT_BOH_QTY, CONVERT(NUMERIC(20,10), 0))
			   -SUM(SUM(CASE WHEN PG.MEASURE = 'WH_IN'	THEN QTY	ELSE 0	END))	OVER (PARTITION BY PG.FROM_SITE
																										  ,PG.TO_SITE
																										  ,PG.ITEM_ID
																										  ,PG.INCOTERMS
																								  ORDER BY DI.YYYYMM)
			   +SUM(SUM(CASE WHEN PG.MEASURE = 'SHIP_PLAN' THEN QTY		ELSE 0	END))	OVER (PARTITION BY PG.FROM_SITE
																										  ,PG.TO_SITE
																										  ,PG.ITEM_ID
																										  ,PG.INCOTERMS
																								  ORDER BY DI.YYYYMM)	AS INT_EOH_QTY -- 해당월 기준 int eoh  (기초재고 - 당월까지 WH In(누적) + 당월까지 Ship Plan(누적))
			  ,SUM(CASE WHEN PG.MEASURE = 'WH_IN'		THEN QTY	ELSE 0	END)	AS WH_IN
			  ,SUM(SUM(CASE WHEN PG.MEASURE = 'WH_IN'	THEN QTY	ELSE 0	END))	OVER (PARTITION BY PG.FROM_SITE
																										  ,PG.TO_SITE
																										  ,PG.ITEM_ID
																										  ,PG.INCOTERMS
																								  ORDER BY DI.YYYYMM) AS WH_IN_ACC
			  ,SUM(CASE WHEN PG.MEASURE = 'SHIP_PLAN'	  THEN PG.QTY	ELSE 0	END)	AS SHIP_PLAN
			  ,SUM(SUM(CASE WHEN PG.MEASURE = 'SHIP_PLAN' THEN QTY		ELSE 0	END))	OVER (PARTITION BY PG.FROM_SITE
																										  ,PG.TO_SITE
																										  ,PG.ITEM_ID
																										  ,PG.INCOTERMS
																								  ORDER BY DI.YYYYMM) AS SHIP_PLAN_ACC
		 INTO #INTRANSIT
		 FROM #TMP_ASIS_GLOBAL_PSI PG WITH(NOLOCK)
			  INNER JOIN #TMP_MM_LIST DI WITH(NOLOCK)
					  ON PG.YYYYMM  = DI.YYYYMM
					 AND PG.YYYYMM >= @V_PLAN_START_YYYYMM  -- 계획 구간
			  LEFT JOIN #INTRANSIT_BOH BO WITH(NOLOCK)
					  ON BO.FROM_SITE = PG.FROM_SITE
					 AND BO.TO_SITE   = PG.TO_SITE
					 AND BO.ITEM_ID   = PG.ITEM_ID
					 AND CASE WHEN BO.INCOTERMS = '***'
							  THEN '-'
							  ELSE BO.INCOTERMS
						  END		  = PG.INCOTERMS
		WHERE 1=1
		  AND PG.MEASURE IN ('WH_IN', 'SHIP_PLAN')
		GROUP BY PG.FROM_SITE
				,PG.TO_SITE
				,PG.ITEM_ID
			 ,PG.INCOTERMS
				,DI.YYYYMM
				,ISNULL(BO.INT_BOH_QTY, CONVERT(NUMERIC(20,10), 0))
		*/

        /* BOH 정보를 Ending Inventory 로 변경	-- 고도화 */
        /* ★ANSI 유지 : SO 바깥조인 ON 절에 왼쪽 인라인 뷰(PG)만 거는 조건 PG.IDX = 1 이 있어 (+) 로 표현 불가 */
        INSERT
          INTO GT_GPMM_INTRANSIT
             ( FROM_SITE
             , TO_SITE
             , ITEM_ID
             , INCOTERMS
             , YYYYMM
             , MEASURE
             , QTY
             )
        SELECT DISTINCT
               PG.FROM_SITE
             , PG.TO_SITE
             , PG.ITEM_ID
             , PG.INCOTERMS
             , PG.YYYYMM
             , PG.MEASURE
             , SUM(PG.ACC_QTY) OVER (PARTITION BY PG.ITEM_ID
                                                , PG.FROM_SITE
                                                , PG.TO_SITE
                                                , PG.INCOTERMS
                                                , PG.MEASURE
                                         ORDER BY PG.YYYYMM ) AS QTY
          FROM ( SELECT PG.FROM_SITE
                      , PG.TO_SITE
                      , PG.ITEM_ID
                      , PG.INCOTERMS
                      , DI.YYYYMM
                      , PG.MEASURE
                      , (CASE WHEN DI.YYYYMM = PG.YYYYMM THEN
                                   NVL(CASE WHEN PG.YYYYMM = V_PLAN_START_YYYYMM THEN NVL(SO.QTY, 0) - PG.WH_IN + PG.SHIP_PLAN ELSE 0 - PG.WH_IN + PG.SHIP_PLAN END, 0)
                              ELSE 0
                         END) AS ACC_QTY
                   FROM ( SELECT MAX(PG.FROM_SITE) AS FROM_SITE  /* intransit 계산시에는 감안하지 않는다. */
                               , PG.TO_SITE
                               , PG.ITEM_ID
                               , '-'               AS INCOTERMS  /* ,PG.INCOTERMS	-- intransit 계산시에는 incoterms 감안하지 않는다. */
                               , DI.YYYYMM
                               , CASE WHEN TS.SITE_TYPE = 'SALES'
                                      THEN 'INTRANSIT'
                                      ELSE 'SEMI_INTRANSIT'
                                 END               AS MEASURE
                               , SUM(CASE WHEN PG.MEASURE = 'WH_IN'     THEN PG.QTY ELSE 0 END) AS WH_IN
                               , SUM(CASE WHEN PG.MEASURE = 'SHIP_PLAN' THEN PG.QTY ELSE 0 END) AS SHIP_PLAN
                               , RANK() OVER (PARTITION BY PG.ITEM_ID, DI.YYYYMM, (CASE WHEN TS.SITE_TYPE = 'SALES'
                                                                                         THEN 'INTRANSIT'
                                                                                         ELSE 'SEMI_INTRANSIT' END )
                                                  /* ORDER BY PG.FROM_SITE DESC, PG.TO_SITE DESC, PG.INCOTERMS ) AS IDX -- '-' 정보를 뒤로 주기 위해서 */
                                                  ORDER BY PG.TO_SITE DESC ) AS IDX  /* '-' 정보를 뒤로 주기 위해서 */
                            FROM GT_GPMM_TMP_ASIS_GLOBAL_PSI PG
                               , GT_GPMM_TMP_MM_LIST         DI
                               , GT_GPMM_SCM_MST_SITE        TS
                           WHERE PG.YYYYMM          = DI.YYYYMM
                             AND TS.SCM_SITE_ID(+)  = PG.TO_SITE
                             AND PG.YYYYMM         >= V_PLAN_START_YYYYMM  /* 계획 구간 */
                             AND PG.MEASURE        IN ('WH_IN', 'SHIP_PLAN')
                             AND NVL(TS.SITE_TYPE || TS.OPERATION_GROUP, '-') <> 'SALESW'  /* ISNULL(TS.SITE_TYPE,'') + ISNULL(TS.OPERATION_GROUP,'') != 'SALESW' */
                           GROUP BY /* PG.FROM_SITE,-- intransit 계산시에는 감안하지 않는다. */
                                    PG.TO_SITE
                                  , PG.ITEM_ID
                                  /* ,PG.INCOTERMS	-- intransit 계산시에는 incoterms 감안하지 않는다. */
                                  , DI.YYYYMM
                                  , CASE WHEN TS.SITE_TYPE = 'SALES'
                                         THEN 'INTRANSIT'
                                         ELSE 'SEMI_INTRANSIT'
                                    END
                        ) PG
                        INNER JOIN GT_GPMM_TMP_MM_LIST DI
                                ON DI.YYYYMM >= V_PLAN_START_YYYYMM  /* 계획 구간 */
                        LEFT OUTER JOIN
                        ( SELECT SO.ITEM_ID
                               , SO.MEASURE
                               , SUM(SO.QTY) AS QTY
                            FROM GT_GPMM_TMP_ENDING_INV_MM SO
                           WHERE SO.YYYYMM   = V_RESULT_LAST_YYYYMM
                             AND SO.MEASURE IN ('SEMI_INTRANSIT', 'INTRANSIT')
                           GROUP BY SO.ITEM_ID
                                  , SO.MEASURE
                        ) SO
                                ON PG.ITEM_ID = SO.ITEM_ID
                               AND PG.MEASURE = SO.MEASURE
                               AND PG.IDX     = 1  /* 같은 주차에 동일 아이템이 존재할 경우 1순위에만 BOH 부여 */
               ) PG
        ;

        /* ------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Intransit 재고(EOH) - Intransit BOH만 존재하는 건 반영');
        /* intransit boh만 존재하고 WH_IN/SHIP PLAN이 없는 경우 */
        /* Intransit 기초 재고만 존재하고 도착/출하 정보가 없는 전구간 BOH/EOH 동일한 값으로 추가 */
        /* ------------------------------------------------------------------------------------------------------------------------- */
		/*
		INSERT INTO #INTRANSIT
		SELECT BO.FROM_SITE
			  ,BO.TO_SITE
			  ,BO.ITEM_ID
			  ,CASE WHEN BO.INCOTERMS = '***'
					THEN '-'
					ELSE BO.INCOTERMS
			   END	AS INCOTERMS
			  ,ML.YYYYMM
			  ,BO.INT_BOH_QTY
			  ,BO.INT_BOH_QTY AS INT_EOH_QTY
			  ,0.0	AS WH_IN
			  ,0.0	AS WH_IN_ACC
			  ,0.0	AS SHIP_PLAN
			  ,0.0	AS SHIP_PLAN_ACC
		  FROM #INTRANSIT_BOH BO WITH(NOLOCK)
			   INNER JOIN #TMP_MM_LIST ML WITH(NOLOCK)
					   ON 1=1
					  AND ML.YYYYMM >= @V_PLAN_START_YYYYMM  -- 계획 구간
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
        /*  BOH 정보를 Ending Inventory 로 변경	-- 고도화 */
        /*  미래계획 기준이 없을 경우 넣어준다. */
        INSERT
          INTO GT_GPMM_INTRANSIT
             ( FROM_SITE
             , TO_SITE
             , ITEM_ID
             , INCOTERMS
             , YYYYMM
             , MEASURE
             , QTY
             )
        SELECT SO.FROM_SITE
             , SO.TO_SITE
             , SO.ITEM_ID
             , '-'          AS INCOTERMS
             , ML.YYYYMM
             , SO.MEASURE
             , SUM(SO.QTY)  AS QTY
          FROM GT_GPMM_TMP_ENDING_INV_MM SO
             , GT_GPMM_TMP_MM_LIST       ML
         WHERE ML.YYYYMM   >= V_PLAN_START_YYYYMM  /* 계획 구간 */
           AND NOT EXISTS ( SELECT 1
                              FROM GT_GPMM_INTRANSIT X
                             WHERE X.MEASURE IN ('SEMI_INTRANSIT', 'INTRANSIT')
                               AND X.ITEM_ID  = SO.ITEM_ID
                               AND X.MEASURE  = SO.MEASURE
                          )
           AND SO.YYYYMM    = V_RESULT_LAST_YYYYMM
           AND SO.MEASURE  IN ('SEMI_INTRANSIT', 'INTRANSIT')
         GROUP BY SO.ITEM_ID
                , SO.OPERATION_GROUP
                , SO.FROM_SITE
                , SO.TO_SITE
                , SO.MEASURE
                , ML.YYYYMM
        ;



        /* --------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### Cell/Pack 및 FG/SEMI Measure 분리');
        /* --------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI;

        /* ★ CASE WHEN x = '' THEN '-' : Oracle 은 '' 가 NULL 이므로 NVL(x, '-') 로 옮김(빈값·NULL 모두 '-') */
        INSERT
          INTO GT_GPMM_TMP_TOBE_GLOBAL_PSI
             ( YYYYMM
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
        SELECT PG.YYYYMM
             , PG.ITEM_ID
             , CASE WHEN PG.MEASURE = 'MODEL_INVENTORY' AND PG.IS_CELL_IN_PACK_PLANT = 'Y' THEN 'PACK_CELL_EOH'
                    WHEN PG.MEASURE = 'MODEL_INVENTORY' AND PG.OPERATION_GROUP = 'A'       THEN 'CELL_EOH'
                    WHEN PG.MEASURE = 'MODEL_INVENTORY' AND PG.OPERATION_GROUP = 'P'       THEN 'PACK_EOH'
                    WHEN PG.MEASURE = 'PRODUCTION'      AND PG.OPERATION_GROUP = 'A'       THEN 'CELL_PROD'
                    WHEN PG.MEASURE = 'PRODUCTION'      AND PG.OPERATION_GROUP = 'P'       THEN 'PACK_PROD'
                    WHEN PG.MEASURE = 'SHIP_PLAN'       AND TS.SITE_TYPE = 'SALES'         THEN 'SHIP_PLAN'
                    WHEN PG.MEASURE = 'SHIP_PLAN'       AND TS.SITE_TYPE = 'PLANT'         THEN 'SEMI_SHIP_PLAN'
                    WHEN PG.MEASURE = 'WH_IN'           AND TS.SITE_TYPE = 'SALES'         THEN 'WHIN'
                    WHEN PG.MEASURE = 'WH_IN'           AND TS.SITE_TYPE = 'PLANT'         THEN 'SEMI_WHIN'
                    ELSE PG.MEASURE
               END                          AS MEASURE
             , PG.FROM_SITE
             , NVL(PG.TO_SITE, '-')         AS TO_SITE              /* CASE WHEN PG.TO_SITE = '' THEN '-' ELSE PG.TO_SITE END */
             , NVL(PG.INCOTERMS, '-')       AS INCOTERMS            /* CASE WHEN PG.INCOTERMS = '' THEN '-' ELSE PG.INCOTERMS END */
             , NVL(PG.TRANSPORT_MODE_LINE, '-') AS VARIOUS_KEY      /* CASE WHEN PG.TRANSPORT_MODE_LINE = '' THEN '-' ELSE PG.TRANSPORT_MODE_LINE END */
             , PG.OPERATION_GROUP
             , NVL(TS.SITE_TYPE, '-')       AS TO_SITE_TYPE
             , SUM(PG.FROM_BOH_QTY)         AS FROM_BOH_QTY
             , SUM(PG.TO_BOH_QTY)           AS TO_BOH_QTY
             , SUM(PG.QTY)                  AS QTY
          FROM GT_GPMM_TMP_ASIS_GLOBAL_PSI PG
             , GT_GPMM_SCM_MST_SITE        TS
         WHERE TS.SCM_SITE_ID(+) = PG.TO_SITE
         GROUP BY PG.YYYYMM
                , PG.ITEM_ID
                , CASE WHEN PG.MEASURE = 'MODEL_INVENTORY' AND PG.IS_CELL_IN_PACK_PLANT = 'Y' THEN 'PACK_CELL_EOH'
                       WHEN PG.MEASURE = 'MODEL_INVENTORY' AND PG.OPERATION_GROUP = 'A'       THEN 'CELL_EOH'
                       WHEN PG.MEASURE = 'MODEL_INVENTORY' AND PG.OPERATION_GROUP = 'P'       THEN 'PACK_EOH'
                       WHEN PG.MEASURE = 'PRODUCTION'      AND PG.OPERATION_GROUP = 'A'       THEN 'CELL_PROD'
                       WHEN PG.MEASURE = 'PRODUCTION'      AND PG.OPERATION_GROUP = 'P'       THEN 'PACK_PROD'
                       WHEN PG.MEASURE = 'SHIP_PLAN'       AND TS.SITE_TYPE = 'SALES'         THEN 'SHIP_PLAN'
                       WHEN PG.MEASURE = 'SHIP_PLAN'       AND TS.SITE_TYPE = 'PLANT'         THEN 'SEMI_SHIP_PLAN'
                       WHEN PG.MEASURE = 'WH_IN'           AND TS.SITE_TYPE = 'SALES'         THEN 'WHIN'
                       WHEN PG.MEASURE = 'WH_IN'           AND TS.SITE_TYPE = 'PLANT'         THEN 'SEMI_WHIN'
                       ELSE PG.MEASURE
                  END
                , PG.FROM_SITE
                , NVL(PG.TO_SITE, '-')              /* AS TO_SITE */
                , NVL(PG.INCOTERMS, '-')            /* AS INCOTERMS */
                , NVL(PG.TRANSPORT_MODE_LINE, '-')  /* AS ETC */
                , PG.OPERATION_GROUP
                , NVL(TS.SITE_TYPE, '-')
        ;

        /* ESST_CA_WND 향 SEMI 강제 등록(semi_whin, semi_intransit 만 조정) 저장 위치 중요 */
        /* 품번, to_site 제외하고 81물량 다 넣어준다 */
        INSERT
          INTO GT_GPMM_TMP_TOBE_GLOBAL_PSI
             ( YYYYMM
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
        SELECT PG.YYYYMM
             , PG.ITEM_ID
             , 'SEMI_WHIN'     AS MEASURE
             , PG.FROM_SITE
             , PG.TO_SITE
             , PG.INCOTERMS
             , PG.VARIOUS_KEY
             , PG.OPERATION_GROUP
             , 'PLANT'         AS TO_SITE_TYPE
             , PG.FROM_BOH_QTY
             , PG.TO_BOH_QTY
             , PG.QTY
          FROM SCP_RPT_GLOBAL_PSI_MD_MM PG  /* 81부터 계산되어 있어서 가져다 쓴다. */
         WHERE PG.DIVISION_ID          = '81'
           AND PG.MEASURE              = 'WHIN'
           AND PG.CELL_GROUP           = 'E131B'
           /* AND PG.ITEM_ID				LIKE 'ACEH1131I-B1%' */
           /* AND PG.TO_SITE				= 'ESST_CA_WND' */
           AND PG.QTY                 <> 0
           AND V_DIVISION_ID           = '81_ST'  /* 1= (CASE WHEN @V_DIVISION_ID = '81_ST' THEN 1 ELSE 0 END) */
           AND PG.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND PG.PLAN_TYPE            = V_PLAN_TYPE  /* E20260708-000926 */
        ;

        /* ---------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : intransit(FG/SEMI) 재고 Measure 추가');
        /* ---------------------------------------------------------------------------------------------------------- */
		/*
		INSERT INTO #TMP_TOBE_GLOBAL_PSI
		SELECT I.YYYYMM
			  ,I.ITEM_ID
			  ,CASE WHEN TS.SITE_TYPE = 'SALES'
					THEN 'INTRANSIT'
					ELSE 'SEMI_INTRANSIT'
				END					AS MEASURE
			  ,I.FROM_SITE
			  ,I.TO_SITE
			  ,I.INCOTERMS
			  ,'-'					AS VARIOUS_KEY
			  ,FI.OPERATION_GROUP
			  ,TS.SITE_TYPE			AS TO_SITE_TYPE
			  ,SUM(I.INT_BOH_QTY)	AS FROM_BOH_QTY  -- from site boh가 아닌 intransit boh임...
			  ,0.0					AS TO_BOH_QTY
			  ,SUM(I.INT_EOH_QTY)	AS QTY
		 FROM #INTRANSIT I WITH(NOLOCK)
			  INNER JOIN #SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.ITEM_ID		= I.ITEM_ID
			  LEFT  JOIN #SCM_MST_SITE TS WITH(NOLOCK)
					  ON TS.SCM_SITE_ID	= I.TO_SITE
		WHERE 1=1
		  AND ISNULL(TS.SITE_TYPE,'') + ISNULL(TS.OPERATION_GROUP,'') != 'SALESW' -- to AS Sales Site 제외
		GROUP BY  I.YYYYMM
				 ,I.ITEM_ID
				 ,I.FROM_SITE
				 ,I.TO_SITE
				 ,I.INCOTERMS
				 ,FI.OPERATION_GROUP
				 ,TS.SITE_TYPE
		*/

        /* BOH 정보를 Ending Inventory 로 변경하여 measure 가 분리됨	-- 고도화 */
        INSERT
          INTO GT_GPMM_TMP_TOBE_GLOBAL_PSI
             ( YYYYMM
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
        SELECT I.YYYYMM
             , I.ITEM_ID
             , I.MEASURE
             , I.FROM_SITE
             , I.TO_SITE
             , I.INCOTERMS
             , '-'                          AS VARIOUS_KEY
             , FI.OPERATION_GROUP
             , NVL(TS.SITE_TYPE, 'PLANT')   AS TO_SITE_TYPE
             , 0                            AS FROM_BOH_QTY  /* from site boh가 아닌 intransit boh임... */
             , 0.0                          AS TO_BOH_QTY
             , SUM(I.QTY)                   AS QTY
          FROM GT_GPMM_INTRANSIT          I
             , GT_GPMM_SCP_MST_FINAL_ITEM FI
             , GT_GPMM_SCM_MST_SITE       TS
         WHERE FI.ITEM_ID        = I.ITEM_ID
           AND TS.SCM_SITE_ID(+) = I.TO_SITE
           AND NVL(TS.SITE_TYPE || TS.OPERATION_GROUP, '-') <> 'SALESW'  /* ISNULL(TS.SITE_TYPE,'') + ISNULL(TS.OPERATION_GROUP,'') != 'SALESW' -- to AS Sales Site 제외 */
         GROUP BY I.YYYYMM
                , I.ITEM_ID
                , I.MEASURE
                , I.FROM_SITE
                , I.TO_SITE
                , I.INCOTERMS
                , FI.OPERATION_GROUP
                , TS.SITE_TYPE
        ;



        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory Weekly 재고 : Cell Inventory (셀공장)  - semi ship plan site');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_ITEM_SEMI_SHIP_SITE;

        INSERT
          INTO GT_GPMM_ITEM_SEMI_SHIP_SITE
             ( ITEM_ID
             , PACK_SITE
             , CELL_SITE_PAST
             , CELL_SITE_FUTURE
             )
        SELECT SS.ITEM_ID
             , SS.TO_SITE                                                                     AS PACK_SITE
             , MAX(CASE WHEN SS.YYYYMM <  V_PLAN_START_YYYYMM THEN SS.FROM_SITE ELSE NULL END) AS CELL_SITE_PAST
             , MAX(CASE WHEN SS.YYYYMM >= V_PLAN_START_YYYYMM THEN SS.FROM_SITE ELSE NULL END) AS CELL_SITE_FUTURE
          FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI SS
             , GT_GPMM_SCM_MST_SITE        PS  /* pack site */
             , GT_GPMM_SCM_MST_SITE        CS  /* cell site */
         WHERE PS.SCM_SITE_ID     = SS.TO_SITE
           AND CS.SCM_SITE_ID     = SS.FROM_SITE
           AND PS.OPERATION_GROUP = 'P'
           AND CS.OPERATION_GROUP = 'A'
           AND SS.MEASURE         = 'SEMI_SHIP_PLAN'
           AND SS.QTY            <> 0
         GROUP BY SS.ITEM_ID
                , SS.TO_SITE
        ;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 ENDING INVENTORY WEEKLY 재고 : CELL INVENTORY (PACK공장) - PACK 생산 실적 1 (수율)');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_PACK_PRODUCTION_RESULT_1;

        INSERT
          INTO GT_GPMM_PACK_PRODUCTION_RESULT_1
             ( YYYYMM
             , ITEM_ID
             , FROM_SITE
             , OPERATION_GROUP
             , PACK_PROD_QTY
             , PACK_PROD_YIELD_QTY
             )
        SELECT WL.YYYYMM
             , PR.ITEM_ID
             , PR.FROM_SITE
             , PR.OPERATION_GROUP
             , SUM(PR.ACTUAL_GOOD_QTY)                     AS PACK_PROD_QTY
             , SUM(PR.ACTUAL_GOOD_QTY
                   / CASE WHEN NVL(PY.YIELD, 0) > 0
                          THEN PY.YIELD
                          ELSE 1.0
                     END )                                 AS PACK_PROD_YIELD_QTY
          FROM GT_GPMM_PRODUCTION_RESULT  PR
             , GT_GPMM_TMP_MM_LIST        WL
             , SCP_MST_TACT_TIME_EXCEPT   PY
         WHERE WL.MONTHLY_FROM_YMD          <= PR.PLAN_YYYYMMDD
           AND WL.MONTHLY_TO_YMD            >= PR.PLAN_YYYYMMDD
           AND PY.PLANT_SITE_ID(+)           = PR.FROM_SITE
           AND PY.ITEM_ID(+)                 = PR.ITEM_ID
           AND PY.OPERATION_ID(+)            = PR.OPERATION_ID
           AND PY.LINE_ID(+)                 = PR.LINE_ID
           AND PY.TACT_TIME_START_DATE(+)   <= PR.PLAN_YYYYMMDD
           AND PY.TACT_TIME_END_DATE(+)     >= PR.PLAN_YYYYMMDD
           AND PR.OPERATION_GROUP            = 'P'  /* 팩 생산 실적 (실적구간) */
           AND PY.DIVISION_ID(+)             = V_DIVISION_ID
         GROUP BY WL.YYYYMM
                , PR.ITEM_ID
                , PR.FROM_SITE
                , PR.OPERATION_GROUP
        ;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 ENDING INVENTORY WEEKLY 재고 : CELL INVENTORY (PACK공장) - PACK 생산 실적 2 (0채움)');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_PACK_PRODUCTION_RESULT_2;

        /* 실적구간 - CELL 도착 (TO PLANT) - TO 사이트 기준 */
        INSERT
          INTO GT_GPMM_PACK_PRODUCTION_RESULT_2
             ( YYYYMM
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , PACK_PROD_QTY
             , PACK_PROD_YIELD_QTY
             )
        SELECT WL.YYYYMM
             , PR.ITEM_ID
             , PR.OPERATION_GROUP
             , PR.FROM_SITE
             , SUM(CASE WHEN PR.YYYYMM = WL.YYYYMM
                        THEN PR.PACK_PROD_QTY
                        ELSE 0.0
                   END) AS PACK_PROD_QTY
             , SUM(CASE WHEN PR.YYYYMM = WL.YYYYMM
                        THEN PR.PACK_PROD_YIELD_QTY
                        ELSE 0.0
                   END) AS PACK_PROD_YIELD_QTY
          FROM GT_GPMM_PACK_PRODUCTION_RESULT_1 PR
             , GT_GPMM_TMP_MM_LIST              WL
         WHERE WL.YYYYMM <= V_PLAN_START_YYYYMM  /* 과거 실적 구간 + Plan 월	-- MODIFY 2024.09.30 */
         GROUP BY WL.YYYYMM
                , PR.ITEM_ID
                , PR.OPERATION_GROUP
                , PR.FROM_SITE
        ;


        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 ENDING INVENTORY WEEKLY 재고 : CELL INVENTORY (PACK공장) - PACK 생산 실적 3 (대표CELL * 셀환산계수)');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_PACK_PRODUCTION_RESULT_3;

        /* ★ANSI 유지 : CF2·CF3 바깥조인 ON 절에 왼쪽 테이블만 거는 조건(PR.ITEM_ID LIKE·PR.OPERATION_GROUP)과
                        다른 바깥 테이블(CF·CF2) 조건이 있어 (+) 로 표현 불가 */
        /* CI.MODEL_ID = CASE … ELSE '' END : Oracle 의 '' 는 NULL 이라 ELSE 는 어떤 행과도 맞지 않음(AS-IS 도 MODEL_ID 빈값 행 없음 → 결과 동일) */
        INSERT
          INTO GT_GPMM_PACK_PRODUCTION_RESULT_3
             ( REP_CELL_ITEM_ID
             , CELL_CF
             , CELL_CF_TYPE
             , MODULE_ID
             , YYYYMM
             , ITEM_ID
             , OPERATION_GROUP
             , FROM_SITE
             , PACK_PROD_QTY
             , PACK_PROD_YIELD_QTY
             )
        SELECT CASE WHEN MI.MODEL_ID IS NOT NULL                                    /* AMDAU% 모듈 */
                    THEN MI.CELL_ITEM_ID
                    WHEN PR.OPERATION_GROUP = 'P' AND CI.CELL_ITEM_ID IS NOT NULL   /* PACK */
                    THEN CI.CELL_ITEM_ID
                    WHEN PR.OPERATION_GROUP = 'P' AND EC.CELL_ITEM_ID IS NOT NULL   /* PACK */
                    THEN EC.CELL_ITEM_ID
                    ELSE NULL
               END  AS REP_CELL_ITEM_ID  /* 대표셀 (CP:CELL PRODUCT) 모델 */
             , CASE WHEN CF.CELL_CF  IS NOT NULL THEN CAST(CF.CELL_CF  AS NUMBER(20,10))
                    WHEN CF2.CELL_CF IS NOT NULL THEN CAST(CF2.CELL_CF AS NUMBER(20,10))
                    WHEN CF3.CELL_CF IS NOT NULL THEN CAST(CF3.CELL_CF AS NUMBER(20,10))
                    ELSE CAST(1.0 AS NUMBER(20,10))
               END  AS CELL_CF
             , CASE WHEN CF.CELL_CF  IS NOT NULL THEN 'CF'
                    WHEN CF2.CELL_CF IS NOT NULL THEN 'CF2'
                    WHEN CF3.CELL_CF IS NOT NULL THEN 'CF3'
                    ELSE 'NULL'
               END  AS CELL_CF_TYPE
             , MI.MODULE_ID
             , PR.YYYYMM
             , PR.ITEM_ID
             , PR.OPERATION_GROUP
             , PR.FROM_SITE
             , PR.PACK_PROD_QTY
             , PR.PACK_PROD_YIELD_QTY
          FROM GT_GPMM_PACK_PRODUCTION_RESULT_2 PR
               LEFT OUTER JOIN GT_GPMM_MODULE_MODEL_INFO MI
                       ON MI.MODULE_ID = PR.ITEM_ID
               LEFT OUTER JOIN GT_GPMM_CP_CELL_ITEM_INFO CI
                       ON CI.MODEL_ID = CASE WHEN MI.MODEL_ID IS NOT NULL      /* AMDAU% 모듈 */
                                             THEN MI.MODEL_ID
                                             WHEN PR.OPERATION_GROUP = 'P'     /* 팩 */
                                             THEN PR.ITEM_ID
                                             ELSE ''
                                        END
               LEFT OUTER JOIN GT_GPMM_ETC_CP_CELL_INFO EC
                       ON EC.PARENT_ITEM_ID = PR.ITEM_ID
               LEFT OUTER JOIN GT_GPMM_SCP_MST_ITEM_CELL_CF CF
                       ON CF.ITEM_ID = PR.ITEM_ID
                      AND CF.CELL_CF IS NOT NULL
                      AND CAST(CF.CELL_CF AS NUMBER(20,10)) != 0.0
               LEFT OUTER JOIN GT_GPMM_SCP_MST_ITEM_CELL_CF CF2
                       ON CF2.ITEM_ID = SUBSTR(PR.ITEM_ID, 1, LENGTH(RTRIM(PR.ITEM_ID)) - 2)
                      AND PR.ITEM_ID LIKE '%-_'
                      AND PR.OPERATION_GROUP = 'P'
                      AND CF.CELL_CF IS NULL
                      AND CF2.CELL_CF IS NOT NULL
                      AND CAST(CF2.CELL_CF AS NUMBER(20,10)) != 0.0
               LEFT OUTER JOIN GT_GPMM_SCP_MST_ITEM_CELL_CF CF3
                       ON CF3.ITEM_ID = SUBSTR(PR.ITEM_ID, 1, LENGTH(RTRIM(PR.ITEM_ID)) - 3)
                      AND PR.ITEM_ID LIKE '%-__'
                      AND PR.OPERATION_GROUP = 'P'
                      AND CF.CELL_CF  IS NULL
                      AND CF2.CELL_CF IS NULL
                      AND CF3.CELL_CF IS NOT NULL
                      AND CAST(CF3.CELL_CF AS NUMBER(20,10)) != 0.0
        ;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 ENDING INVENTORY WEEKLY 재고 : CELL INVENTORY (PACK공장) - PACK 생산 실적 3 (대표CELL * 셀환산계수) STEP001');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */


        INSERT
          INTO GT_GPMM_TMP_TOBE_GLOBAL_PSI
             ( YYYYMM
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
        SELECT PR.YYYYMM
             , PR.ITEM_ID
             , MM.MEASURE
             , PR.FROM_SITE
             , PR.TO_SITE
             , PR.INCOTERMS
             , PR.VARIOUS_KEY
             , PR.OPERATION_GROUP
             , PR.TO_SITE_TYPE
             , SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
             , SUM(TO_BOH_QTY)   AS TO_BOH_QTY
             , SUM(QTY)          AS QTY
          FROM ( SELECT PR.YYYYMM
                      , PR.REP_CELL_ITEM_ID                                                AS ITEM_ID
                      , NVL(CP.SCM_SITE_ID, NVL(SS.CELL_SITE_PAST, SS.CELL_SITE_FUTURE))    AS FROM_SITE  /* CELL PLANT */
                      , PP.PLANT_ID || '-P'                                                AS TO_SITE
                      , '-'                                                                AS INCOTERMS
                      , '-'                                                                AS VARIOUS_KEY
                      , 'A'                                                                AS OPERATION_GROUP
                      , 'PLANT'                                                            AS TO_SITE_TYPE
                      , 0.0                                                                AS FROM_BOH_QTY
                      , 0.0                                                                AS TO_BOH_QTY
                      , PR.PACK_PROD_YIELD_QTY * NVL(PR.CELL_CF, 1)                        AS QTY
                   FROM GT_GPMM_PACK_PRODUCTION_RESULT_3 PR
                      , GT_GPMM_SCM_MST_SITE             PP  /* PACK PLANT SITE */
                      , GT_GPMM_SCM_MST_SITE             CP  /* CELL PLANT SITE */
                      , GT_GPMM_ITEM_SEMI_SHIP_SITE      SS
                  WHERE PP.SCM_SITE_ID          = PR.FROM_SITE
                    AND CP.PLANT_ID(+)          = PP.PLANT_ID
                    AND SS.ITEM_ID(+)           = PR.ITEM_ID
                    AND SS.PACK_SITE(+)         = PP.SCM_SITE_ID  /* PACK SITE */
                    AND CP.OPERATION_GROUP(+)   = 'A'
                    AND CP.SITE_TYPE(+)         = 'PLANT'
                    /* -- 20240327 불필요 조건 삭제 */
                    AND NVL(CP.SCM_SITE_ID, NVL(SS.CELL_SITE_PAST, SS.CELL_SITE_FUTURE)) IS NOT NULL
                    AND PR.PACK_PROD_YIELD_QTY  > 0
                    AND PR.YYYYMM               < V_PLAN_START_YYYYMM  /* 과거 실적 구간	-- ADD 2024.09.30 */
                    AND PR.REP_CELL_ITEM_ID IS NOT NULL
               ) PR
             , ( SELECT 'SEMI_SHIP_PLAN' AS MEASURE FROM DUAL UNION SELECT 'SEMI_WHIN' AS MEASURE FROM DUAL
               ) MM
         WHERE PR.ITEM_ID IS NOT NULL  /* E20251029-001009 오류대응. */
           AND NOT EXISTS ( SELECT 1
                              FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI X
                             WHERE X.YYYYMM          = PR.YYYYMM
                               AND X.ITEM_ID         = PR.ITEM_ID
                               /* AND X.MEASURE = MM.MEASURE */
                               /* AND X.FROM_SITE = PR.FROM_SITE */
                               AND X.OPERATION_GROUP = PR.OPERATION_GROUP
                               /* AND X.MEASURE IN ('SEMI_WHIN', 'SEMI_SHIP_PLAN') */
                               AND X.MEASURE        IN ('SEMI_WHIN')       /* 해당기준으로만 데이타 생성 */
                               AND X.YYYYMM          < V_PLAN_START_YYYYMM  /* 과거 실적 구간 */
                          )
         GROUP BY PR.YYYYMM
                , PR.ITEM_ID
                , MM.MEASURE
                , PR.FROM_SITE
                , PR.TO_SITE
                , PR.INCOTERMS
                , PR.VARIOUS_KEY
                , PR.OPERATION_GROUP
                , PR.TO_SITE_TYPE
        ;

        /* ADD 24.09.30 */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 ENDING INVENTORY WEEKLY 재고 : CELL INVENTORY (PACK공장) - PACK 생산 실적 3 (대표CELL * 셀환산계수) STEP002');
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------- */

        MERGE INTO GT_GPMM_TMP_TOBE_GLOBAL_PSI PR
        USING ( SELECT PR.YYYYMM
                     , PR.ITEM_ID
                     , MM.MEASURE
                     , PR.FROM_SITE
                     , PR.TO_SITE
                     , PR.INCOTERMS
                     , PR.VARIOUS_KEY
                     , PR.OPERATION_GROUP
                     , PR.TO_SITE_TYPE
                     , SUM(FROM_BOH_QTY) AS FROM_BOH_QTY
                     , SUM(TO_BOH_QTY)   AS TO_BOH_QTY
                     , SUM(QTY)          AS QTY
                  FROM ( SELECT PR.YYYYMM
                              , PR.REP_CELL_ITEM_ID                                                AS ITEM_ID
                              , NVL(CP.SCM_SITE_ID, NVL(SS.CELL_SITE_PAST, SS.CELL_SITE_FUTURE))    AS FROM_SITE  /* CELL PLANT */
                              , PP.PLANT_ID || '-P'                                                AS TO_SITE
                              , '-'                                                                AS INCOTERMS
                              , '-'                                                                AS VARIOUS_KEY
                              , 'A'                                                                AS OPERATION_GROUP
                              , 'PLANT'                                                            AS TO_SITE_TYPE
                              , 0.0                                                                AS FROM_BOH_QTY
                              , 0.0                                                                AS TO_BOH_QTY
                              , PR.PACK_PROD_YIELD_QTY * NVL(PR.CELL_CF, 1)                        AS QTY
                           FROM GT_GPMM_PACK_PRODUCTION_RESULT_3 PR
                              , GT_GPMM_SCM_MST_SITE             PP  /* PACK PLANT SITE */
                              , GT_GPMM_SCM_MST_SITE             CP  /* CELL PLANT SITE */
                              , GT_GPMM_ITEM_SEMI_SHIP_SITE      SS
                          WHERE PP.SCM_SITE_ID          = PR.FROM_SITE
                            AND CP.PLANT_ID(+)          = PP.PLANT_ID
                            AND SS.ITEM_ID(+)           = PR.ITEM_ID
                            AND SS.PACK_SITE(+)         = PP.SCM_SITE_ID  /* PACK SITE */
                            AND CP.OPERATION_GROUP(+)   = 'A'
                            AND CP.SITE_TYPE(+)         = 'PLANT'
                            AND NVL(CP.SCM_SITE_ID, NVL(SS.CELL_SITE_PAST, SS.CELL_SITE_FUTURE)) IS NOT NULL
                            AND PR.PACK_PROD_YIELD_QTY  > 0
                            AND PR.YYYYMM               = V_PLAN_START_YYYYMM
                            AND PR.REP_CELL_ITEM_ID IS NOT NULL  /* 오류대응. */
                       ) PR
                     , ( SELECT 'SEMI_SHIP_PLAN' AS MEASURE FROM DUAL UNION SELECT 'SEMI_WHIN' AS MEASURE FROM DUAL
                       ) MM
                 GROUP BY PR.YYYYMM
                        , PR.ITEM_ID
                        , MM.MEASURE
                        , PR.FROM_SITE
                        , PR.TO_SITE
                        , PR.INCOTERMS
                        , PR.VARIOUS_KEY
                        , PR.OPERATION_GROUP
                        , PR.TO_SITE_TYPE
              ) X
           ON (    X.YYYYMM          = PR.YYYYMM
               AND X.ITEM_ID         = PR.ITEM_ID
               AND X.MEASURE         = PR.MEASURE
               AND X.OPERATION_GROUP = PR.OPERATION_GROUP
               AND X.FROM_SITE       = PR.FROM_SITE
               AND X.TO_SITE         = PR.TO_SITE
               AND X.INCOTERMS       = PR.INCOTERMS
               AND X.VARIOUS_KEY     = PR.VARIOUS_KEY
              )
         WHEN MATCHED THEN
              UPDATE
                 SET PR.QTY = NVL(PR.QTY, 0) + NVL(X.QTY, 0)
         WHEN NOT MATCHED THEN
              INSERT
                   ( YYYYMM
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
                   ( X.YYYYMM
                   , X.ITEM_ID
                   , X.MEASURE
                   , X.FROM_SITE
                   , X.TO_SITE
                   , X.INCOTERMS
                   , X.VARIOUS_KEY
                   , X.OPERATION_GROUP
                   , X.TO_SITE_TYPE
                   , X.FROM_BOH_QTY
                   , X.TO_BOH_QTY
                   , X.QTY
                   )
        ;

        /* -------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Cell Inventory (Pack공장) measure 계산 ');
        /* 전주 재고(Cell Inventory)  + 금주도착(Semi WH In) -  금주생산(Production)/팩수율 */
        /* PACK_CELL_EOH	-- 고도화 */
        /* 팩 수율 */
        /* -------------------------------------------------------------------------------------------------------- */

        DELETE
          FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI
         WHERE MEASURE = 'PACK_CELL_EOH'
           AND YYYYMM >= V_PLAN_START_YYYYMM
        ;

        INSERT
          INTO GT_GPMM_TMP_TOBE_GLOBAL_PSI
             ( YYYYMM
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
          WITH BASE_DATA AS (
               /* 실적구간 - 팩출하 */
               SELECT WI.YYYYMM
                    , WI.ITEM_ID
                    , WI.OPERATION_GROUP
                    , WI.FROM_SITE
                    , WI.TO_SITE
                    , SUM(WI.PLAN_QTY) AS PLAN_QTY
                    , SUM(WI.PROD_QTY) AS PROD_QTY
                 FROM (SELECT WL.YYYYMM
                            , WI.ITEM_ID
                            , WI.OPERATION_GROUP
                            , '-'    AS FROM_SITE /* WI.FROM_SITE */
                            , '-'    AS TO_SITE
                            , WI.QTY AS PLAN_QTY
                            , 0      AS PROD_QTY
                         FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI WI
                            , GT_GPMM_TMP_MM_LIST         WL
                        WHERE WI.YYYYMM          = WL.YYYYMM
                          AND WI.MEASURE         = 'SEMI_WHIN'
                          AND WI.OPERATION_GROUP = 'A'                 /* Cell */
                          AND WL.YYYYMM         >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
                        UNION ALL
						/*
						-- 실적구간 - 팩생산
						SELECT	 WL.YYYYMM
								,ISNULL(MM.TARGET_CELL,WI.ITEM_ID) AS ITEM_ID --WI.ITEM_ID	--cell code 로 변경
								,'A' AS OPERATION_GROUP	--WI.OPERATION_GROUP
								,'-' AS FROM_SITE	--WI.FROM_SITE
								,'-'			AS TO_SITE
								,0 AS PLAN_QTY
								,WI.QTY * ISNULL(MM.CELL_CF,1) AS PROD_QTY
						FROM #TMP_TOBE_GLOBAL_PSI WI WITH(NOLOCK)
							INNER JOIN #TMP_MM_LIST WL WITH(NOLOCK)
									ON WL.YYYYMM >=  @V_PLAN_START_YYYYMM  -- 미래 계획 구간
								   AND WI.YYYYMM = WL.YYYYMM
							LEFT JOIN #SCP_MST_ITEM_CELL_CF MM WITH(NOLOCK)
								   ON MM.ITEM_ID = WI.ITEM_ID
						WHERE 1=1
						  AND WI.MEASURE			= 'PACK_PROD'
						*/
                       /* 실적구간 - 팩생산/팩수율 */
                       SELECT WL.YYYYMM
                            , NVL(MM.TARGET_CELL, WI.ITEM_ID) AS ITEM_ID /* WI.ITEM_ID	--cell code 로 변경 */
                            , 'A'                             AS OPERATION_GROUP /* WI.OPERATION_GROUP */
                            , '-'                             AS FROM_SITE /* WI.FROM_SITE */
                            , '-'                             AS TO_SITE
                            , 0                               AS PLAN_QTY
                            , (CASE WHEN WI.YYYYMM = WL.YYYYMM THEN WI.QTY / NVL(YD.CHAR_YIELD, NVL(YD2.STD_YIELD, 1)) ELSE 0 END) * NVL(TO_NUMBER(MM.CELL_CF), 1) AS PROD_QTY /* ,WI.QTY AS QTY */
                         FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI  WI
                            , GT_GPMM_TMP_MM_LIST          WL
                            , GT_GPMM_SCP_MST_ITEM_CELL_CF MM
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
                            , GT_GPMM_SCP_MST_FORMATION    YD
                            , (SELECT DISTINCT
                                      ITEM_ID
                                    , MONTH
                                    , MAX(YIELD) OVER (PARTITION BY DIVISION_ID, ITEM_ID, MONTH) AS STD_YIELD
                                 FROM SCM_MST_YIELD_SN
                                WHERE OPERATION_ID LIKE 'P%'
                                  AND DIVISION_ID = V_DIVISION_ID
                              ) YD2
                        WHERE MM.ITEM_ID(+)                            = WI.ITEM_ID
                          AND YD.ITEM_ID(+)                            = WI.ITEM_ID
                          AND REPLACE(YD.PLANT_SITE_ID(+), '-A', '-P') = WI.FROM_SITE
                          AND YD.YYYYMM(+)                             = WL.YYYYMM
                          AND YD2.ITEM_ID(+)                           = WI.ITEM_ID
                          AND YD2.MONTH(+)                             = WL.YYYYMM
                          AND WI.MEASURE                               = 'PACK_PROD'
                          AND WL.YYYYMM                               >= V_PLAN_START_YYYYMM /* 계획 구간 */
                      ) WI
                GROUP BY WI.YYYYMM
                       , WI.ITEM_ID
                       , WI.OPERATION_GROUP
                       , WI.FROM_SITE
                       , WI.TO_SITE
               )
        SELECT DISTINCT
               PG.YYYYMM
             , PG.ITEM_ID
             , 'PACK_CELL_EOH' AS MEASURE
             , PG.FROM_SITE
             , PG.TO_SITE
             , '-'             AS INCOTERMS
             , '-'             AS VARIOUS_KEY
             , PG.OPERATION_GROUP
             , '-'             AS TO_SITE_TYPE
             , 0.0             AS FROM_BOH_QTY
             , 0.0             AS TO_BOH_QTY
             , SUM(PG.ACC_QTY) OVER (PARTITION BY PG.ITEM_ID
                                                , PG.OPERATION_GROUP
                                                , PG.FROM_SITE
                                         ORDER BY PG.YYYYMM) AS QTY
          FROM (SELECT BD.YYYYMM
                     , BD.ITEM_ID
                     , BD.FROM_SITE
                     , '-' AS TO_SITE
                     , BD.OPERATION_GROUP
						/* , CASE WHEN WL.YYYYMM = WL.YYYYMM THEN */
						/* ISNULL(CASE WHEN BD.YYYYMM = @V_PLAN_START_YYYYMM THEN ISNULL(SO.BOH,0) - BD.PROD_QTY + BD.PLAN_QTY ELSE 0 - BD.PROD_QTY + BD.PLAN_QTY END,0) */
						/* ELSE 0 END ACC_QTY */
                     , NVL(CASE WHEN BD.YYYYMM = V_PLAN_START_YYYYMM THEN NVL(SO.BOH, 0) - BD.PROD_QTY + BD.PLAN_QTY ELSE 0 - BD.PROD_QTY + BD.PLAN_QTY END, 0) AS ACC_QTY
                  FROM BASE_DATA BD
						 /* INNER JOIN #TMP_MM_LIST WL WITH(NOLOCK) */
						/* ON WL.YYYYMM >=  @V_PLAN_START_YYYYMM  -- 미래 계획 구간 */
                     , (SELECT WI.ITEM_ID
                             , WI.OPERATION_GROUP
                             , SUM(WI.BOH) AS BOH
                          FROM (SELECT WI.ITEM_ID
                                     , WI.OPERATION_GROUP
                                       /* ,WI.FROM_SITE */
                                     , '-'    AS TO_SITE
                                     , WI.QTY AS BOH
                                  FROM GT_GPMM_TMP_ENDING_INV_MM WI
                                 WHERE WI.MEASURE = 'PACK_CELL_EOH'
                                   AND WI.YYYYMM  = V_RESULT_LAST_YYYYMM
                                 UNION ALL
                                /* PACK_CELL_EOH 로 변환 될 수량 추가 */
                                SELECT MM.CELL_ITEM_ID              AS ITEM_ID
                                     , 'A'                          AS OPERATION_GROUP
                                       /* ,WI.FROM_SITE */
                                     , '-'                          AS TO_SITE
                                     , WI.QTY * NVL(TO_NUMBER(SM.CELL_CF), 1)  AS BOH
                                  FROM GT_GPMM_TMP_ENDING_INV_MM    WI
                                     , GT_GPMM_MODULE_MODEL_INFO    MM /* AMDAU 상위 모델 정보 */
                                     , GT_GPMM_SCP_MST_ITEM_CELL_CF SM
                                 WHERE MM.MODULE_ID(+)        = WI.ITEM_ID
                                   AND MM.PACK_MODULE_ITEM(+) = 'N'
                                   AND SM.ITEM_ID(+)          = WI.ITEM_ID
                                   AND NOT EXISTS (SELECT 1
                                                     FROM GT_GPMM_MODULE_MODEL_INFO MM
                                                    WHERE MM.PACK_MODULE_ITEM = 'Y' /* PACK_EOH 로 빠지는 그룹은 제외 */
                                                      AND MM.MODULE_ID        = WI.ITEM_ID)
                                   AND WI.MEASURE             = 'PACK_EOH'
                                   AND WI.ITEM_ID          LIKE 'AMDAU%'
                                   AND WI.YYYYMM              = V_RESULT_LAST_YYYYMM
                               ) WI
                         GROUP BY WI.ITEM_ID
                                , WI.OPERATION_GROUP
                       ) SO
                 WHERE SO.ITEM_ID(+)         = BD.ITEM_ID
                   AND SO.OPERATION_GROUP(+) = BD.OPERATION_GROUP
                       /* AND BD.FROM_SITE = SO.FROM_SITE */
               ) PG
        ;

        INSERT
          INTO GT_GPMM_TMP_TOBE_GLOBAL_PSI
             ( YYYYMM
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
        SELECT A.YYYYMM
             , A.ITEM_ID
             , A.MEASURE
             , A.FROM_SITE
             , A.TO_SITE
             , A.INCOTERMS
             , A.VARIOUS_KEY
             , A.OPERATION_GROUP
             , A.TO_SITE_TYPE
             , SUM(A.FROM_BOH_QTY) AS FROM_BOH_QTY
             , SUM(A.TO_BOH_QTY)   AS TO_BOH_QTY
             , SUM(A.QTY)          AS QTY
          FROM (SELECT WL.YYYYMM
                     , WI.ITEM_ID
                     , 'PACK_CELL_EOH' AS MEASURE
                     , '-'             AS FROM_SITE
                     , '-'             AS TO_SITE
                     , '-'             AS INCOTERMS
                     , '-'             AS VARIOUS_KEY
                     , WI.OPERATION_GROUP
                     , '-'             AS TO_SITE_TYPE
                     , 0.0             AS FROM_BOH_QTY
                     , 0.0             AS TO_BOH_QTY
                     , WI.QTY          AS QTY
                  FROM GT_GPMM_TMP_ENDING_INV_MM WI
                     , GT_GPMM_TMP_MM_LIST       WL
                 WHERE WI.MEASURE  = 'PACK_CELL_EOH'
                   AND WL.YYYYMM  >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
                   AND WI.YYYYMM   = V_RESULT_LAST_YYYYMM
                 UNION ALL
                SELECT WL.YYYYMM
                     , MM.CELL_ITEM_ID             AS ITEM_ID
                     , 'PACK_CELL_EOH'             AS MEASURE
                     , '-'                         AS FROM_SITE
                     , '-'                         AS TO_SITE
                     , '-'                         AS INCOTERMS
                     , '-'                         AS VARIOUS_KEY
                     , 'A'                         AS OPERATION_GROUP
                     , '-'                         AS TO_SITE_TYPE
                     , 0.0                         AS FROM_BOH_QTY
                     , 0.0                         AS TO_BOH_QTY
                     , WI.QTY * NVL(TO_NUMBER(SM.CELL_CF), 1) AS QTY
                  FROM GT_GPMM_TMP_ENDING_INV_MM    WI
                     , GT_GPMM_TMP_MM_LIST          WL
                     , GT_GPMM_MODULE_MODEL_INFO    MM /* AMDAU 상위 모델 정보 */
                     , GT_GPMM_SCP_MST_ITEM_CELL_CF SM
                 WHERE MM.MODULE_ID(+)        = WI.ITEM_ID
                   AND MM.PACK_MODULE_ITEM(+) = 'N'
                   AND SM.ITEM_ID(+)          = WI.ITEM_ID
                   AND NOT EXISTS (SELECT 1
                                     FROM GT_GPMM_MODULE_MODEL_INFO MM
                                    WHERE MM.PACK_MODULE_ITEM = 'Y' /* PACK_EOH 로 빠지는 그룹은 제외 */
                                      AND MM.MODULE_ID        = WI.ITEM_ID)
                   AND WI.MEASURE             = 'PACK_EOH'
                   AND WI.ITEM_ID          LIKE 'AMDAU%'
                   AND WL.YYYYMM             >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
                   AND WI.YYYYMM              = V_RESULT_LAST_YYYYMM
               ) A
         WHERE NOT EXISTS (SELECT 1
                             FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI X
                            WHERE X.MEASURE = 'PACK_CELL_EOH'
                              AND X.ITEM_ID = A.ITEM_ID
                                  /* AND		X.FROM_SITE = WI.FROM_SITE */
                                  /* AND		X.OPERATION_GROUP = A.OPERATION_GROUP */
                          )
           AND A.ITEM_ID IS NOT NULL
         GROUP BY A.YYYYMM
                , A.ITEM_ID
                , A.MEASURE
                , A.FROM_SITE
                , A.TO_SITE
                , A.INCOTERMS
                , A.VARIOUS_KEY
                , A.OPERATION_GROUP
                , A.TO_SITE_TYPE
        ;


        /* -------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Pack Inventory measure 추가');
        /* Pack Inventory 기초재고(전월말) + 팩 생산 for Pack Inventory - 출하(FG) for  Pack Inventory */
        /* PACK_EOH	-- 고도화 */
        /* -------------------------------------------------------------------------------------------------------- */

        DELETE
          FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI
         WHERE MEASURE = 'PACK_EOH'
           AND YYYYMM >= V_PLAN_START_YYYYMM
        ;

        INSERT
          INTO GT_GPMM_TMP_TOBE_GLOBAL_PSI
             ( YYYYMM
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
          WITH BASE_DATA AS (
               /* 실적구간 - 팩출하 */
               SELECT WI.YYYYMM
                    , WI.ITEM_ID
                    , WI.OPERATION_GROUP
                    , WI.FROM_SITE
                    , WI.TO_SITE
                    , SUM(WI.PLAN_QTY) AS PLAN_QTY
                    , SUM(WI.PROD_QTY) AS PROD_QTY
                 FROM (SELECT WI.YYYYMM
                            , WI.ITEM_ID
                            , WI.OPERATION_GROUP
                            , WI.FROM_SITE
                            , '-'    AS TO_SITE
                            , WI.QTY AS PLAN_QTY
                            , 0      AS PROD_QTY
                         FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI WI
                        WHERE WI.MEASURE         IN ('SHIP_PLAN')
                          AND WI.OPERATION_GROUP  = 'P'                 /* 팩출하 */
                          AND WI.YYYYMM          >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
                        UNION ALL
                       /* 실적구간 - 팩출하 */
                       SELECT WI.YYYYMM
                            , WI.ITEM_ID
                            , WI.OPERATION_GROUP
                            , WI.FROM_SITE
                            , '-'    AS TO_SITE
                            , 0      AS PLAN_QTY
                            , WI.QTY AS PROD_QTY
                         FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI WI
                        WHERE WI.MEASURE  = 'PACK_PROD'
                          AND WI.YYYYMM  >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
                        UNION ALL /* (2024.09.02 변경건) */
                       SELECT WL.YYYYMM
                            , WI.ITEM_ID
                            , WI.OPERATION_GROUP
                            , '-'           AS FROM_SITE /* WI.FROM_SITE */
                            , '-'           AS TO_SITE
                            , 0             AS PLAN_QTY
                            , (-1) * WI.QTY AS PROD_QTY
                         FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI WI
                            , GT_GPMM_TMP_MM_LIST         WL
                        WHERE WI.YYYYMM          = WL.YYYYMM
                          AND WI.MEASURE         = 'AS_IN_PLAN'
                          AND WI.OPERATION_GROUP = 'P'                 /* Cell */
                          AND WL.YYYYMM         >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
                      ) WI
                GROUP BY WI.YYYYMM
                       , WI.ITEM_ID
                       , WI.OPERATION_GROUP
                       , WI.FROM_SITE
                       , WI.TO_SITE
               )
        SELECT DISTINCT
               PG.YYYYMM
             , PG.ITEM_ID
             , 'PACK_EOH'      AS MEASURE
             , PG.FROM_SITE
             , PG.TO_SITE
             , '-'             AS INCOTERMS
             , '-'             AS VARIOUS_KEY
             , PG.OPERATION_GROUP
             , '-'             AS TO_SITE_TYPE
             , 0.0             AS FROM_BOH_QTY
             , 0.0             AS TO_BOH_QTY
             , SUM(PG.ACC_QTY) OVER (PARTITION BY PG.ITEM_ID
                                                , PG.OPERATION_GROUP
                                                , PG.FROM_SITE
                                         ORDER BY PG.YYYYMM) AS QTY
          FROM (SELECT WL.YYYYMM
                     , BD.ITEM_ID
                     , BD.FROM_SITE
                     , '-' AS TO_SITE
                     , BD.OPERATION_GROUP
                     , CASE WHEN BD.YYYYMM = WL.YYYYMM THEN
                                 NVL(CASE WHEN BD.YYYYMM = V_PLAN_START_YYYYMM THEN NVL(SO.BOH, 0) + BD.PROD_QTY - BD.PLAN_QTY ELSE 0 + BD.PROD_QTY - BD.PLAN_QTY END, 0)
                            ELSE 0
                       END AS ACC_QTY
                  FROM BASE_DATA           BD
                     , GT_GPMM_TMP_MM_LIST WL
                     , (SELECT WI.ITEM_ID
                             , WI.OPERATION_GROUP
                             , WI.FROM_SITE
                             , '-'         AS TO_SITE
                             , SUM(WI.QTY) AS BOH
                          FROM GT_GPMM_TMP_ENDING_INV_MM WI
                         WHERE NOT EXISTS (SELECT 1
                                             FROM GT_GPMM_MODULE_MODEL_INFO MM /* AMDAU 상위 모델 정보 */
                                            WHERE MM.MODULE_ID        = WI.ITEM_ID
                                              AND MM.PACK_MODULE_ITEM = 'N')
                           AND WI.MEASURE = 'PACK_EOH'
                           AND WI.YYYYMM  = V_RESULT_LAST_YYYYMM
                         GROUP BY WI.ITEM_ID
                                , WI.OPERATION_GROUP
                                , WI.FROM_SITE
								/*UNION ALL
								-- PACK_CELL_EOH 로 변환 될 수량 차감

								SELECT	 WI.ITEM_ID
										,WI.OPERATION_GROUP
										,WI.FROM_SITE
										,'-'			AS TO_SITE
										, (-1) * WI.QTY AS BOH
								FROM #TMP_ENDING_INV_MM WI WITH(NOLOCK)
									LEFT JOIN #MODULE_MODEL_INFO MM WITH(NOLOCK)  -- AMDAU 상위 모델 정보
					 					   ON MM.MODULE_ID = WI.ITEM_ID
					 					  AND MM.PACK_MODULE_ITEM = 'N'
					 			WHERE 1=1
								AND WI.YYYYMM	= @V_RESULT_LAST_YYYYMM
								AND WI.MEASURE	= 'PACK_EOH'
								AND WI.ITEM_ID  LIKE 'AMDAU%'
								*/
                       ) SO
                 WHERE SO.ITEM_ID(+)         = BD.ITEM_ID
                   AND SO.OPERATION_GROUP(+) = BD.OPERATION_GROUP
                   AND SO.FROM_SITE(+)       = BD.FROM_SITE
                   AND WL.YYYYMM            >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
               ) PG
        ;

        INSERT
          INTO GT_GPMM_TMP_TOBE_GLOBAL_PSI
             ( YYYYMM
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
        SELECT WL.YYYYMM
             , WI.ITEM_ID
             , 'PACK_EOH'  AS MEASURE
             , WI.FROM_SITE
             , '-'         AS TO_SITE
             , '-'         AS INCOTERMS
             , '-'         AS VARIOUS_KEY
             , WI.OPERATION_GROUP
             , '-'         AS TO_SITE_TYPE
             , 0.0         AS FROM_BOH_QTY
             , 0.0         AS TO_BOH_QTY
             , SUM(WI.QTY) AS QTY
          FROM GT_GPMM_TMP_ENDING_INV_MM WI
             , GT_GPMM_TMP_MM_LIST       WL
         WHERE NOT EXISTS (SELECT 1
                             FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI X
                            WHERE X.MEASURE         = 'PACK_EOH'
                              AND X.ITEM_ID         = WI.ITEM_ID
                              AND X.FROM_SITE       = WI.FROM_SITE
                              AND X.OPERATION_GROUP = WI.OPERATION_GROUP
                              AND X.YYYYMM         >= V_PLAN_START_YYYYMM)
           AND NOT EXISTS (SELECT 1
                             FROM GT_GPMM_MODULE_MODEL_INFO MM /* AMDAU 상위 모델 정보 */
                            WHERE MM.MODULE_ID        = WI.ITEM_ID
                              AND MM.PACK_MODULE_ITEM = 'N')
           AND WI.MEASURE  = 'PACK_EOH'
           AND WL.YYYYMM  >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
           AND WI.YYYYMM   = V_RESULT_LAST_YYYYMM
         GROUP BY WL.YYYYMM
                , WI.ITEM_ID
                , WI.FROM_SITE
                , WI.OPERATION_GROUP
        ;

        /* -------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 계획 구간 : Cell Inventory (셀공장)  measure 추가');
        /* 전주 재고(Cell Inventory) + 금주생산(Char. Plan) - 금주출하(Semi Ship Plan & Ship Plan) */
        /* CELL_EOH	-- 고도화 */
        /* -------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI
         WHERE MEASURE = 'CELL_EOH'
           AND YYYYMM >= V_PLAN_START_YYYYMM
        ;

        INSERT
          INTO GT_GPMM_TMP_TOBE_GLOBAL_PSI
             ( YYYYMM
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
          WITH BASE_DATA AS (
               /* 실적구간 - 팩출하 */
               SELECT WL.YYYYMM
                    , WI.ITEM_ID
                    , WI.OPERATION_GROUP
                    , WI.FROM_SITE
                    , WI.TO_SITE
                    , SUM(CASE WHEN WL.YYYYMM = WI.YYYYMM THEN WI.PLAN_QTY ELSE 0 END) AS PLAN_QTY
                    , SUM(CASE WHEN WL.YYYYMM = WI.YYYYMM THEN WI.PROD_QTY ELSE 0 END) AS PROD_QTY
                 FROM (SELECT WI.YYYYMM
                            , WI.ITEM_ID
                            , WI.OPERATION_GROUP
                            , WI.FROM_SITE
                            , WI.TO_SITE
                            , SUM(WI.PLAN_QTY) AS PLAN_QTY
                            , SUM(WI.PROD_QTY) AS PROD_QTY
                         FROM (SELECT WL.YYYYMM
                                    , WI.ITEM_ID
                                    , WI.OPERATION_GROUP
                                    , WI.FROM_SITE AS FROM_SITE /* WI.FROM_SITE */
                                    , '-'          AS TO_SITE
                                    , CASE WHEN WI.MEASURE = 'SHIP_PLAN' THEN WI.QTY * NVL(TO_NUMBER(SM.CELL_CF), 1) ELSE WI.QTY END AS PLAN_QTY
                                    , 0            AS PROD_QTY
                                 FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI  WI
                                    , GT_GPMM_TMP_MM_LIST          WL
                                    , GT_GPMM_SCP_MST_ITEM_CELL_CF SM
                                WHERE WI.YYYYMM          = WL.YYYYMM
                                  AND SM.ITEM_ID(+)      = WI.ITEM_ID
                                  AND WI.MEASURE        IN ('SEMI_SHIP_PLAN', 'SHIP_PLAN')
                                  AND WI.OPERATION_GROUP = 'A'                 /* Cell */
                                  AND WL.YYYYMM         >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
                              ) WI
                        GROUP BY WI.YYYYMM
                               , WI.ITEM_ID
                               , WI.OPERATION_GROUP
                               , WI.FROM_SITE
                               , WI.TO_SITE
                        UNION ALL
                       SELECT WL.YYYYMM
                            , WI.ITEM_ID
                            , WI.OPERATION_GROUP
                            , WI.FROM_SITE AS FROM_SITE /* WI.FROM_SITE */
                            , '-'          AS TO_SITE
                            , 0            AS PLAN_QTY
                            , WI.QTY       AS PROD_QTY
                         FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI WI
                            , GT_GPMM_TMP_MM_LIST         WL
                        WHERE WI.YYYYMM          = WL.YYYYMM
                          AND WI.MEASURE         = 'CELL_CHAR_PLAN'
                          AND WI.OPERATION_GROUP = 'A'                 /* Cell */
                          AND WL.YYYYMM         >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
                        UNION ALL /* (2024.09.02 변경건) */
                       SELECT WL.YYYYMM
                            , WI.ITEM_ID
                            , WI.OPERATION_GROUP
                            , '-'           AS FROM_SITE /* WI.FROM_SITE */
                            , '-'           AS TO_SITE
                            , 0             AS PLAN_QTY
                            , (-1) * WI.QTY AS PROD_QTY
                         FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI WI
                            , GT_GPMM_TMP_MM_LIST         WL
                        WHERE WI.YYYYMM          = WL.YYYYMM
                          AND WI.MEASURE         = 'AS_IN_PLAN'
                          AND WI.OPERATION_GROUP = 'A'                 /* Cell */
                          AND WL.YYYYMM         >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
                        UNION ALL
                       SELECT V_PLAN_START_YYYYMM AS YYYYMM
                            , WI.ITEM_ID
                            , WI.OPERATION_GROUP
                            , WI.FROM_SITE        AS FROM_SITE
                            , '-'                 AS TO_SITE
                            , 0                   AS PLAN_QTY
                            , 0                   AS PROD_QTY
                         FROM GT_GPMM_TMP_ENDING_INV_MM WI
                        WHERE WI.MEASURE = 'CELL_EOH'
                          AND WI.YYYYMM  = V_RESULT_LAST_YYYYMM
                      ) WI
                    , GT_GPMM_TMP_MM_LIST WL
                WHERE WL.YYYYMM >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
                GROUP BY WL.YYYYMM
                       , WI.ITEM_ID
                       , WI.OPERATION_GROUP
                       , WI.FROM_SITE
                       , WI.TO_SITE
               )
        SELECT DISTINCT
               PG.YYYYMM
             , PG.ITEM_ID
             , 'CELL_EOH'      AS MEASURE
             , PG.FROM_SITE
             , PG.TO_SITE
             , '-'             AS INCOTERMS
             , '-'             AS VARIOUS_KEY
             , PG.OPERATION_GROUP
             , '-'             AS TO_SITE_TYPE
             , 0.0             AS FROM_BOH_QTY
             , 0.0             AS TO_BOH_QTY
             , SUM(PG.ACC_QTY) OVER (PARTITION BY PG.ITEM_ID
                                                , PG.OPERATION_GROUP
                                                , PG.FROM_SITE
                                         ORDER BY PG.YYYYMM) AS QTY
          FROM (SELECT WL.YYYYMM
                     , BD.ITEM_ID
                     , BD.FROM_SITE
                     , '-' AS TO_SITE
                     , BD.OPERATION_GROUP
                     , CASE WHEN BD.YYYYMM = WL.YYYYMM THEN
                                 NVL(CASE WHEN BD.YYYYMM = V_PLAN_START_YYYYMM THEN NVL(SO.BOH, 0) + BD.PROD_QTY - BD.PLAN_QTY ELSE 0 + BD.PROD_QTY - BD.PLAN_QTY END, 0)
                            ELSE 0
                       END AS ACC_QTY
                  FROM BASE_DATA           BD
                     , GT_GPMM_TMP_MM_LIST WL
                     , (SELECT WI.ITEM_ID
                             , WI.OPERATION_GROUP
                             , WI.FROM_SITE
                             , SUM(WI.BOH) AS BOH
                          FROM (SELECT WI.ITEM_ID
                                     , WI.OPERATION_GROUP
                                     , WI.FROM_SITE AS FROM_SITE
                                     , '-'          AS TO_SITE
                                     , WI.QTY       AS BOH
                                  FROM GT_GPMM_TMP_ENDING_INV_MM WI
                                 WHERE WI.MEASURE = 'CELL_EOH'
                                   AND WI.YYYYMM  = V_RESULT_LAST_YYYYMM
                               ) WI
                         GROUP BY WI.ITEM_ID
                                , WI.OPERATION_GROUP
                                , WI.FROM_SITE
                       ) SO
                 WHERE SO.ITEM_ID(+)         = BD.ITEM_ID
                   AND SO.OPERATION_GROUP(+) = BD.OPERATION_GROUP
                   AND SO.FROM_SITE(+)       = BD.FROM_SITE
                   AND WL.YYYYMM            >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
               ) PG
        ;

        INSERT
          INTO GT_GPMM_TMP_TOBE_GLOBAL_PSI
             ( YYYYMM
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
        SELECT A.YYYYMM
             , A.ITEM_ID
             , A.MEASURE
             , A.FROM_SITE
             , A.TO_SITE
             , A.INCOTERMS
             , A.VARIOUS_KEY
             , A.OPERATION_GROUP
             , A.TO_SITE_TYPE
             , SUM(A.FROM_BOH_QTY) AS FROM_BOH_QTY
             , SUM(A.TO_BOH_QTY)   AS TO_BOH_QTY
             , SUM(A.QTY)          AS QTY
          FROM (SELECT WL.YYYYMM
                     , WI.ITEM_ID
                     , 'CELL_EOH'   AS MEASURE
                     , WI.FROM_SITE AS FROM_SITE
                     , '-'          AS TO_SITE
                     , '-'          AS INCOTERMS
                     , '-'          AS VARIOUS_KEY
                     , WI.OPERATION_GROUP
                     , '-'          AS TO_SITE_TYPE
                     , 0.0          AS FROM_BOH_QTY
                     , 0.0          AS TO_BOH_QTY
                     , WI.QTY       AS QTY
                  FROM GT_GPMM_TMP_ENDING_INV_MM WI
                     , GT_GPMM_TMP_MM_LIST       WL
                 WHERE WI.MEASURE  = 'CELL_EOH'
                   AND WL.YYYYMM  >= V_PLAN_START_YYYYMM /* 미래 계획 구간 */
                   AND WI.YYYYMM   = V_RESULT_LAST_YYYYMM
               ) A
         WHERE NOT EXISTS (SELECT 1
                             FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI X
                            WHERE X.MEASURE    = 'CELL_EOH'
                              AND X.ITEM_ID    = A.ITEM_ID
                              AND X.YYYYMM    >= V_PLAN_START_YYYYMM
                              AND X.FROM_SITE  = A.FROM_SITE
                                  /* AND		X.OPERATION_GROUP = A.OPERATION_GROUP */
                          )
           AND A.ITEM_ID IS NOT NULL
         GROUP BY A.YYYYMM
                , A.ITEM_ID
                , A.MEASURE
                , A.FROM_SITE
                , A.TO_SITE
                , A.INCOTERMS
                , A.VARIOUS_KEY
                , A.OPERATION_GROUP
                , A.TO_SITE_TYPE
        ;

        /* UPDATE A SET QTY = A.NEW_QTY FROM (파생 테이블 A) 를 ROWID 기준 MERGE 로 전환 (SCP_MST_ITEM_CELL_CF.ITEM_ID 는 PK 라 원천 중복 없음) */
        MERGE
         INTO GT_GPMM_TMP_TOBE_GLOBAL_PSI T
        USING (SELECT A.ROWID                               AS RID
                    , A.QTY / NVL(TO_NUMBER(SM.CELL_CF), 1) AS NEW_QTY
                 FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI  A
                    , GT_GPMM_SCP_MST_ITEM_CELL_CF SM
                WHERE SM.ITEM_ID(+)     = A.ITEM_ID
                  AND A.MEASURE         = 'CELL_EOH'
                  AND A.OPERATION_GROUP = 'P'
                  AND A.YYYYMM         >= V_PLAN_START_YYYYMM
              ) A
           ON (T.ROWID = A.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET T.QTY = A.NEW_QTY
        ;

        /* --- Start : Ending Inventory (과거 실적 구간 재고) */

        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : 월별 재고 Measure 추가');
        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPMM_TMP_TOBE_GLOBAL_PSI
             ( YYYYMM
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
        SELECT EI.YYYYMM
             , CASE WHEN EI.MEASURE = 'CELL_EOH'
                    THEN NVL(NVL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), EI.ITEM_ID)
                    ELSE EI.ITEM_ID
               END                AS ITEM_ID
             , EI.MEASURE         AS MEASURE
             , EI.FROM_SITE       AS FROM_SITE
             , EI.TO_SITE         AS TO_SITE
             , '-'                AS INCOTERMS
             , '-'                AS VARIOUS_KEY /* 생산라인 or 운송모드 or 프로젝트 */
             , EI.OPERATION_GROUP AS OPERATION_GROUP
             , '-'                AS TO_SITE_TYPE
             , 0.0                AS FROM_BOH_QTY
             , 0.0                AS TO_BOH_QTY
             , SUM(EI.QTY)        AS QTY
          FROM GT_GPMM_TMP_ENDING_INV_MM  EI
             , GT_GPMM_SCM_MST_SITE       FS
             , GT_GPMM_CELL_PROD_ASSY_MAP CA1
             , GT_GPMM_CELL_PROD_ASSY_MAP CA2
         WHERE FS.SCM_SITE_ID(+)        = EI.FROM_SITE
           AND CA1.PLANT_ID(+)          = FS.PLANT_ID
           AND CA1.ITEM_ID_PROD(+)      = EI.ITEM_ID
           AND CA1.ASSY_PRIORITY_1ST(+) = 1
           AND CA2.ITEM_ID_PROD(+)      = EI.ITEM_ID
           AND CA2.ASSY_PRIORITY_2ND(+) = 1
           AND EI.MEASURE              != 'CELL_CHAR_AVAILABLE' /* 활성화와 특성 분리하여 아래의 로직에서 별도 반영함 */
         GROUP BY EI.YYYYMM
                , CASE WHEN EI.MEASURE = 'CELL_EOH'
                       THEN NVL(NVL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), EI.ITEM_ID)
                       ELSE EI.ITEM_ID
                  END
                , EI.MEASURE
                , EI.FROM_SITE
                , EI.TO_SITE
                , EI.OPERATION_GROUP
        ;

        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 실적 구간 Ending Inventory : Char. Available / Formation Progress measure 추가');
        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPMM_TMP_TOBE_GLOBAL_PSI
             ( YYYYMM
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
          WITH TARGET_MEASURE AS (
               SELECT 'CELL_FORM_PROGRESS' AS MEASURE
                 FROM DUAL
                UNION ALL
               SELECT 'CELL_CHAR_AVAILABLE' AS MEASURE
                 FROM DUAL
               )
        SELECT EI.YYYYMM
             , EI.ITEM_ID
             , TM.MEASURE
             , EI.FROM_SITE       AS FROM_SITE
             , '-'                AS TO_SITE
             , '-'                AS INCOTERMS
             , '-'                AS VARIOUS_KEY /* 생산라인 or 운송모드 or 프로젝트 */
             , EI.OPERATION_GROUP AS OPERATION_GROUP
             , '-'                AS TO_SITE_TYPE
             , 0.0                AS FROM_BOH_QTY
             , 0.0                AS TO_BOH_QTY
             , CASE WHEN TM.MEASURE = 'CELL_FORM_PROGRESS'
                    THEN EI.FORM_PROGRESS
                    ELSE EI.CHAR_AVAILABLE
               END                AS QTY
          FROM GT_GPMM_PAST_FORM_PROGRESS_CHAR_AVAILABLE EI
             , TARGET_MEASURE                            TM
        ;

        /* --- End : Ending Inventory (과거 실적 구간 재고) */

        /* --- begin 대표 cell item 정보 추가 =============================================================================================================================== */

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 대표Cell 품목 매핑 : 대표 Cell 품목 정보 추가');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO;

        /* ★ANSI 유지 : FS·C1·C2 바깥조인의 ON 에 왼쪽 테이블만 거는 조건(GP.OPERATION_GROUP = 'A')이 있고, CI 는 MI·GP 두 테이블에 걸친 CASE 식으로 조인 */
        INSERT
          INTO GT_GPMM_TMP_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO
             ( REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYMM
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
        SELECT CASE WHEN MI.MODEL_ID IS NOT NULL                                   /* AMDAU% 모듈 */
                    THEN MI.CELL_ITEM_ID
                    WHEN GP.OPERATION_GROUP = 'P'  AND CI.CELL_ITEM_ID IS NOT NULL /* Pack */
                    THEN CI.CELL_ITEM_ID
                    WHEN GP.OPERATION_GROUP = 'P'  AND EC.CELL_ITEM_ID IS NOT NULL /* Pack */
                    THEN EC.CELL_ITEM_ID
                    WHEN GP.OPERATION_GROUP = 'A'  AND FI.CELL_TYPE LIKE 'CA%'
                    THEN NVL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD)
                    WHEN GP.OPERATION_GROUP = 'A'  AND FI.CELL_TYPE LIKE 'CP%'
                    THEN GP.ITEM_ID
                    ELSE NULL
               END AS REP_CELL_ITEM_ID /* 대표셀 (CP:Cell Product) 모델 */
             , MI.MODULE_ID
             , GP.YYYYMM
             , GP.ITEM_ID
             , GP.MEASURE
             , GP.FROM_SITE
             , GP.TO_SITE
             , GP.INCOTERMS
             , GP.VARIOUS_KEY
             , GP.OPERATION_GROUP
             , GP.TO_SITE_TYPE
             , GP.FROM_BOH_QTY
             , GP.TO_BOH_QTY
             , GP.QTY
          FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI GP
               LEFT OUTER JOIN GT_GPMM_SCP_MST_FINAL_ITEM FI
                 ON FI.ITEM_ID   = GP.ITEM_ID
               LEFT OUTER JOIN GT_GPMM_MODULE_MODEL_INFO MI
                 ON MI.MODULE_ID = GP.ITEM_ID
               LEFT OUTER JOIN GT_GPMM_CP_CELL_ITEM_INFO CI
                 ON CI.MODEL_ID  = CASE WHEN MI.MODEL_ID IS NOT NULL  /* AMDAU% 모듈 */
                                        THEN MI.MODEL_ID
                                        WHEN GP.OPERATION_GROUP = 'P' /* 팩 */
                                        THEN GP.ITEM_ID
                                        ELSE NULL                     /* 원문 ELSE '' : 조인 열쇠로만 쓰이며 어느 MODEL_ID 와도 일치하지 않는 의미 그대로 */
                                   END
               LEFT OUTER JOIN GT_GPMM_ETC_CP_CELL_INFO EC
                 ON EC.PARENT_ITEM_ID = GP.ITEM_ID
               LEFT OUTER JOIN GT_GPMM_SCM_MST_SITE FS
                 ON GP.OPERATION_GROUP = 'A'
                AND FS.SCM_SITE_ID     = GP.FROM_SITE
                AND FS.SITE_TYPE       = 'PLANT'
               LEFT OUTER JOIN GT_GPMM_CELL_PROD_ASSY_MAP C1
                 ON GP.OPERATION_GROUP  = 'A'
                AND C1.PLANT_ID         = FS.PLANT_ID
                AND C1.ITEM_ID_ASSY     = GP.ITEM_ID
                AND C1.CP_PRIORITY_1ST  = 1
               LEFT OUTER JOIN GT_GPMM_CELL_PROD_ASSY_MAP C2
                 ON GP.OPERATION_GROUP  = 'A'
                AND C2.ITEM_ID_ASSY     = GP.ITEM_ID
                AND C2.CP_PRIORITY_2ND  = 1
        ;

        /* --- End 대표 cell item 정보 추가 =============================================================================================================================== */

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 셀그룹 및 환산수량 정보 추가 ');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_SCP_RPT_GLOBAL_PSI_MD_MM;

        /* ★ANSI 유지 : CF2·CF3 바깥조인의 ON 에 왼쪽 테이블(GP)·다른 바깥조인 테이블(CF·CF2)만 거는 조건이 있음 */
        INSERT
          INTO GT_GPMM_SCP_RPT_GLOBAL_PSI_MD_MM
             ( CELL_GROUP
             , CELL_GROUP_YN
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYMM
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
        SELECT CASE WHEN FI.GROUP_CODE1 IS NULL
                    THEN GP.REP_CELL_ITEM_ID
                    ELSE FI.GROUP_CODE1
               END AS CELL_GROUP
             , CASE WHEN FI.GROUP_CODE1 IS NULL
                    THEN 'N'
                    ELSE 'Y'
               END AS CELL_GROUP_YN /* 20240311 */
             , CASE WHEN GP.OPERATION_GROUP = 'A'  THEN CAST(1.0 AS NUMBER(20,10))
                    WHEN CF.CELL_CF  IS NOT NULL   THEN CAST(CF.CELL_CF AS NUMBER(20,10))
                    WHEN CF2.CELL_CF IS NOT NULL   THEN CAST(CF2.CELL_CF AS NUMBER(20,10))
                    WHEN CF3.CELL_CF IS NOT NULL   THEN CAST(CF3.CELL_CF AS NUMBER(20,10))
                    ELSE CAST(1.0 AS NUMBER(20,10))
               END AS CELL_CF
             , CASE WHEN GP.OPERATION_GROUP = 'A'  THEN 'CELL'
                    WHEN CF.CELL_CF  IS NOT NULL   THEN 'CF'
                    WHEN CF2.CELL_CF IS NOT NULL   THEN 'CF2'
                    WHEN CF3.CELL_CF IS NOT NULL   THEN 'CF3'
                    ELSE 'NULL'
               END AS CELL_CF_TYPE
             , GP.REP_CELL_ITEM_ID
             , GP.MODULE_ID
             , GP.YYYYMM
             , GP.ITEM_ID
             , GP.MEASURE
             , GP.FROM_SITE
             , GP.TO_SITE
             , GP.INCOTERMS
             , GP.VARIOUS_KEY
             , GP.OPERATION_GROUP
             , GP.TO_SITE_TYPE
             , GP.FROM_BOH_QTY
             , GP.TO_BOH_QTY
             , GP.QTY
          FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO GP
               LEFT OUTER JOIN GT_GPMM_SCP_MST_FINAL_ITEM FI /* --- cell group 정보 참조 */
                 ON FI.ITEM_ID = GP.REP_CELL_ITEM_ID
               LEFT OUTER JOIN GT_GPMM_SCP_MST_ITEM_CELL_CF CF
                 ON CF.ITEM_ID = GP.ITEM_ID
                AND CF.CELL_CF IS NOT NULL
                AND CAST(CF.CELL_CF AS NUMBER(20,10)) != 0.0
               LEFT OUTER JOIN GT_GPMM_SCP_MST_ITEM_CELL_CF CF2
                 ON CF2.ITEM_ID         = SUBSTR(GP.ITEM_ID, 1, LENGTH(RTRIM(GP.ITEM_ID)) - 2)
                AND GP.ITEM_ID       LIKE '%-_'
                AND GP.OPERATION_GROUP  = 'P'
                AND CF.CELL_CF  IS NULL
                AND CF2.CELL_CF IS NOT NULL
                AND CAST(CF2.CELL_CF AS NUMBER(20,10)) != 0.0
               LEFT OUTER JOIN GT_GPMM_SCP_MST_ITEM_CELL_CF CF3
                 ON CF3.ITEM_ID         = SUBSTR(GP.ITEM_ID, 1, LENGTH(RTRIM(GP.ITEM_ID)) - 3)
                AND GP.ITEM_ID       LIKE '%-__'
                AND GP.OPERATION_GROUP  = 'P'
                AND CF.CELL_CF  IS NULL
                AND CF2.CELL_CF IS NULL
                AND CF3.CELL_CF IS NOT NULL
                AND CAST(CF3.CELL_CF AS NUMBER(20,10)) != 0.0
         WHERE GP.REP_CELL_ITEM_ID IS NOT NULL /* 대표 Cell 정보가 없는 건 제외 */
        ;

        /* BOM 정보에 문제가 있는 경우 (=하위셀을 못찾을경우) 해당 모듈팩에 대한 Group code 를 찾아 Global PSI New 재고로 반영	-- 고도화 */
        /* ★ANSI 유지 : CF2·CF3 바깥조인의 ON 에 왼쪽 테이블(GP)·다른 바깥조인 테이블(CF·CF2)만 거는 조건이 있음 */
        INSERT
          INTO GT_GPMM_SCP_RPT_GLOBAL_PSI_MD_MM
             ( CELL_GROUP
             , CELL_GROUP_YN
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYMM
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
        SELECT CASE WHEN FI.GROUP_CODE1 IS NULL
                    THEN GP.REP_CELL_ITEM_ID
                    ELSE FI.GROUP_CODE1
               END AS CELL_GROUP
             , CASE WHEN FI.GROUP_CODE1 IS NULL
                    THEN 'N'
                    ELSE 'Y'
               END AS CELL_GROUP_YN /* 20240311 */
             , CASE WHEN GP.OPERATION_GROUP = 'A'  THEN CAST(1.0 AS NUMBER(20,10))
                    WHEN CF.CELL_CF  IS NOT NULL   THEN CAST(CF.CELL_CF AS NUMBER(20,10))
                    WHEN CF2.CELL_CF IS NOT NULL   THEN CAST(CF2.CELL_CF AS NUMBER(20,10))
                    WHEN CF3.CELL_CF IS NOT NULL   THEN CAST(CF3.CELL_CF AS NUMBER(20,10))
                    ELSE CAST(1.0 AS NUMBER(20,10))
               END AS CELL_CF
             , CASE WHEN GP.OPERATION_GROUP = 'A'  THEN 'CELL'
                    WHEN CF.CELL_CF  IS NOT NULL   THEN 'CF'
                    WHEN CF2.CELL_CF IS NOT NULL   THEN 'CF2'
                    WHEN CF3.CELL_CF IS NOT NULL   THEN 'CF3'
                    ELSE 'NULL'
               END AS CELL_CF_TYPE
             , GP.REP_CELL_ITEM_ID
             , GP.MODULE_ID
             , GP.YYYYMM
             , GP.ITEM_ID
             , GP.MEASURE
             , GP.FROM_SITE
             , GP.TO_SITE
             , GP.INCOTERMS
             , GP.VARIOUS_KEY
             , GP.OPERATION_GROUP
             , GP.TO_SITE_TYPE
             , GP.FROM_BOH_QTY
             , GP.TO_BOH_QTY
             , GP.QTY
          FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO GP
               INNER JOIN GT_GPMM_SCP_MST_FINAL_ITEM FI /* --- cell group 정보 참조 */
                  ON FI.ITEM_ID = GP.ITEM_ID            /* REP_CELL_ITEM_ID 대신 ITEM 기준으로 */
                 AND FI.GROUP_CODE1 IS NOT NULL
               LEFT OUTER JOIN GT_GPMM_SCP_MST_ITEM_CELL_CF CF
                 ON CF.ITEM_ID = GP.ITEM_ID
                AND CF.CELL_CF IS NOT NULL
                AND CAST(CF.CELL_CF AS NUMBER(20,10)) != 0.0
               LEFT OUTER JOIN GT_GPMM_SCP_MST_ITEM_CELL_CF CF2
                 ON CF2.ITEM_ID         = SUBSTR(GP.ITEM_ID, 1, LENGTH(RTRIM(GP.ITEM_ID)) - 2)
                AND GP.ITEM_ID       LIKE '%-_'
                AND GP.OPERATION_GROUP  = 'P'
                AND CF.CELL_CF  IS NULL
                AND CF2.CELL_CF IS NOT NULL
                AND CAST(CF2.CELL_CF AS NUMBER(20,10)) != 0.0
               LEFT OUTER JOIN GT_GPMM_SCP_MST_ITEM_CELL_CF CF3
                 ON CF3.ITEM_ID         = SUBSTR(GP.ITEM_ID, 1, LENGTH(RTRIM(GP.ITEM_ID)) - 3)
                AND GP.ITEM_ID       LIKE '%-__'
                AND GP.OPERATION_GROUP  = 'P'
                AND CF.CELL_CF  IS NULL
                AND CF2.CELL_CF IS NULL
                AND CF3.CELL_CF IS NOT NULL
                AND CAST(CF3.CELL_CF AS NUMBER(20,10)) != 0.0
         WHERE GP.REP_CELL_ITEM_ID IS NULL /* 대표 Cell 정보가 없는 건 제외 */
        ;

        UPDATE GT_GPMM_SCP_RPT_GLOBAL_PSI_MD_MM
           SET REP_CELL_ITEM_ID = ITEM_ID
         WHERE REP_CELL_ITEM_ID IS NULL
        ;

        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### GAP(RTF - MKT_FCST) measure');
        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_GAP_RTF_MKT_FCST;

        INSERT
          INTO GT_GPMM_GAP_RTF_MKT_FCST
             ( CELL_GROUP
             , CELL_GROUP_YN
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYMM
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
        SELECT GP.CELL_GROUP
             , GP.CELL_GROUP_YN /* 20240311 */
             , GP.CELL_CF
             , GP.CELL_CF_TYPE
             , GP.REP_CELL_ITEM_ID
             , GP.MODULE_ID
             , GP.YYYYMM
             , GP.ITEM_ID
             , CAST('GAP' AS VARCHAR2(10 CHAR)) AS MEASURE
             , GP.FROM_SITE
             , GP.TO_SITE
             , GP.INCOTERMS
             , GP.VARIOUS_KEY
             , GP.OPERATION_GROUP
             , GP.TO_SITE_TYPE
             , GP.FROM_BOH_QTY
             , GP.TO_BOH_QTY
             , SUM(CASE WHEN GP.MEASURE = 'MKT_FCST' THEN GP.QTY * (-1) ELSE GP.QTY END) AS QTY
          FROM GT_GPMM_SCP_RPT_GLOBAL_PSI_MD_MM GP
         WHERE GP.MEASURE IN ('MKT_FCST', 'RTF')
           AND GP.YYYYMM  >= V_PLAN_START_YYYYMM
         GROUP BY GP.CELL_GROUP
                , GP.CELL_GROUP_YN /* 20240311 */
                , GP.CELL_CF
                , GP.CELL_CF_TYPE
                , GP.REP_CELL_ITEM_ID
                , GP.MODULE_ID
                , GP.YYYYMM
                , GP.ITEM_ID
                , GP.FROM_SITE
                , GP.TO_SITE
                , GP.INCOTERMS
                , GP.VARIOUS_KEY
                , GP.OPERATION_GROUP
                , GP.TO_SITE_TYPE
                , GP.FROM_BOH_QTY
                , GP.TO_BOH_QTY
        ;

        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### AS GAP(AS RTF - AS MKT_FCST) measure');
        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPMM_GAP_RTF_MKT_FCST
             ( CELL_GROUP
             , CELL_GROUP_YN
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYMM
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
        SELECT GP.CELL_GROUP
             , GP.CELL_GROUP_YN /* 20240311 */
             , GP.CELL_CF
             , GP.CELL_CF_TYPE
             , GP.REP_CELL_ITEM_ID
             , GP.MODULE_ID
             , GP.YYYYMM
             , GP.ITEM_ID
             , 'AS_GAP' AS MEASURE
             , GP.FROM_SITE
             , GP.TO_SITE
             , GP.INCOTERMS
             , GP.VARIOUS_KEY
             , GP.OPERATION_GROUP
             , GP.TO_SITE_TYPE
             , GP.FROM_BOH_QTY
             , GP.TO_BOH_QTY
             , SUM(CASE WHEN GP.MEASURE = 'AS_MKT_FCST' THEN GP.QTY * (-1) ELSE GP.QTY END) AS QTY
          FROM GT_GPMM_SCP_RPT_GLOBAL_PSI_MD_MM GP
         WHERE GP.MEASURE IN ('AS_MKT_FCST', 'AS_RTF')
           AND GP.YYYYMM  >= V_PLAN_START_YYYYMM
         GROUP BY GP.CELL_GROUP
                , GP.CELL_GROUP_YN /* 20240311 */
                , GP.CELL_CF
                , GP.CELL_CF_TYPE
                , GP.REP_CELL_ITEM_ID
                , GP.MODULE_ID
                , GP.YYYYMM
                , GP.ITEM_ID
                , GP.FROM_SITE
                , GP.TO_SITE
                , GP.INCOTERMS
                , GP.VARIOUS_KEY
                , GP.OPERATION_GROUP
                , GP.TO_SITE_TYPE
                , GP.FROM_BOH_QTY
                , GP.TO_BOH_QTY
        ;

        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### (AS포함) GAP(AS RTF - AS MKT_FCST) measure 추가');
        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPMM_SCP_RPT_GLOBAL_PSI_MD_MM
             ( CELL_GROUP
             , CELL_GROUP_YN
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYMM
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
        SELECT CELL_GROUP
             , CELL_GROUP_YN
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYMM
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
          FROM GT_GPMM_GAP_RTF_MKT_FCST
        ;

        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### ACC GAP(RTF - MKT_FCST) measure 추가');
        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_GPMM_SCP_RPT_GLOBAL_PSI_MD_MM
             ( CELL_GROUP
             , CELL_GROUP_YN
             , CELL_CF
             , CELL_CF_TYPE
             , REP_CELL_ITEM_ID
             , MODULE_ID
             , YYYYMM
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
          WITH GAP_MEASURE AS (
               SELECT GP.CELL_GROUP
                    , GP.CELL_GROUP_YN /* 20240311 */
                    , GP.CELL_CF
                    , GP.REP_CELL_ITEM_ID
                    , ML.YYYYMM
                    , GP.ITEM_ID
                    , GP.MEASURE
                    , GP.TO_SITE
                    , GP.INCOTERMS
                    , GP.VARIOUS_KEY
                    , GP.OPERATION_GROUP
                    , SUM(CASE WHEN ML.YYYYMM = GP.YYYYMM THEN GP.QTY ELSE 0.0 END) AS QTY
                 FROM GT_GPMM_GAP_RTF_MKT_FCST GP
                    , GT_GPMM_TMP_MM_LIST      ML
                WHERE ML.YYYYMM >= V_PLAN_START_YYYYMM /* 미래 계획 구간만 */
                GROUP BY GP.CELL_GROUP
                       , GP.CELL_GROUP_YN /* 20240311 */
                       , GP.CELL_CF
                       , GP.REP_CELL_ITEM_ID
                       , ML.YYYYMM
                       , GP.ITEM_ID
                       , GP.MEASURE
                       , GP.TO_SITE
                       , GP.INCOTERMS
                       , GP.VARIOUS_KEY
                       , GP.OPERATION_GROUP
               )
        SELECT GP.CELL_GROUP
             , GP.CELL_GROUP_YN /* 20240311 */
             , GP.CELL_CF
             , '-' AS CELL_CF_TYPE
             , GP.REP_CELL_ITEM_ID
             , '-' AS MODULE_ID
             , GP.YYYYMM
             , GP.ITEM_ID
             , CASE WHEN GP.MEASURE = 'GAP' THEN 'GAP_ACC' ELSE 'AS_GAP_ACC' END AS MEASURE
             , '-' AS FROM_SITE
             , GP.TO_SITE
             , GP.INCOTERMS
             , GP.VARIOUS_KEY
             , GP.OPERATION_GROUP
             , '-' AS TO_SITE_TYPE
             , 0.0 AS FROM_BOH_QTY
             , 0.0 AS TO_BOH_QTY
             , SUM(GP.QTY) OVER (PARTITION BY GP.ITEM_ID
                                            , GP.TO_SITE
                                            , GP.INCOTERMS
                                            , GP.VARIOUS_KEY
                                            , CASE WHEN GP.MEASURE = 'GAP' THEN 'GAP_ACC' ELSE 'AS_GAP_ACC' END
                                     ORDER BY GP.YYYYMM) AS ACC_QTY
          FROM GAP_MEASURE GP
        ;

        /* --- begin DIO 계산 =============================================================================================================================== */
        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 월별 일수 정보');
        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_MM_DAYS_INFO;

        INSERT
          INTO GT_GPMM_TMP_MM_DAYS_INFO
             ( YYYYMM
             , MM_DAYS
             , FROM_MONTH
             , TO_MONTH
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
             )
          WITH MM_DAYS_INFO AS (
               SELECT BC.YYYYMM
                    , COUNT(BC.YYYYMMDD) AS MM_DAYS
                 FROM SCM_MST_BUCKET BC
                WHERE BC.YYYYMM BETWEEN V_RESULT_FROM_YYYYMM
                                    AND TO_CHAR(ADD_MONTHS(TO_DATE(V_HORIZON_END_YYYYMMDD, 'YYYYMMDD'), 12), 'YYYYMM') /* 계획 참조 종료일 + 12month */
                GROUP BY BC.YYYYMM
               )
        SELECT ML.YYYYMM
             , ML.MM_DAYS
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 1), 'YYYYMM') AS FROM_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 5), 'YYYYMM') AS TO_MONTH
             , MAX(CASE WHEN TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 1 ), 'YYYYMM') = AM.YYYYMM THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_1
             , MAX(CASE WHEN TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 2 ), 'YYYYMM') = AM.YYYYMM THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_2
             , MAX(CASE WHEN TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 3 ), 'YYYYMM') = AM.YYYYMM THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_3
             , MAX(CASE WHEN TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 4 ), 'YYYYMM') = AM.YYYYMM THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_4
             , MAX(CASE WHEN TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 5 ), 'YYYYMM') = AM.YYYYMM THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_5
             , MAX(CASE WHEN TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 6 ), 'YYYYMM') = AM.YYYYMM THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_6
             , MAX(CASE WHEN TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 7 ), 'YYYYMM') = AM.YYYYMM THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_7
             , MAX(CASE WHEN TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 8 ), 'YYYYMM') = AM.YYYYMM THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_8
             , MAX(CASE WHEN TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 9 ), 'YYYYMM') = AM.YYYYMM THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_9
             , MAX(CASE WHEN TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 10), 'YYYYMM') = AM.YYYYMM THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_10
             , MAX(CASE WHEN TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 11), 'YYYYMM') = AM.YYYYMM THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_11
             , MAX(CASE WHEN TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 12), 'YYYYMM') = AM.YYYYMM THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_12
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.YYYYMM || '01', 'YYYYMMDD'), TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD')) <= 1  THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_1
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.YYYYMM || '01', 'YYYYMMDD'), TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD')) <= 2  THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_2
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.YYYYMM || '01', 'YYYYMMDD'), TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD')) <= 3  THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_3
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.YYYYMM || '01', 'YYYYMMDD'), TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD')) <= 4  THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_4
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.YYYYMM || '01', 'YYYYMMDD'), TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD')) <= 5  THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_5
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.YYYYMM || '01', 'YYYYMMDD'), TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD')) <= 6  THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_6
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.YYYYMM || '01', 'YYYYMMDD'), TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD')) <= 7  THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_7
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.YYYYMM || '01', 'YYYYMMDD'), TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD')) <= 8  THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_8
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.YYYYMM || '01', 'YYYYMMDD'), TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD')) <= 9  THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_9
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.YYYYMM || '01', 'YYYYMMDD'), TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD')) <= 10 THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_10
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.YYYYMM || '01', 'YYYYMMDD'), TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD')) <= 11 THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_11
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.YYYYMM || '01', 'YYYYMMDD'), TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD')) <= 12 THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_12
          FROM GT_GPMM_TMP_MM_LIST ML
             , MM_DAYS_INFO        AM
         WHERE AM.YYYYMM(+) >= TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 1 ), 'YYYYMM')
           AND AM.YYYYMM(+) <= TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 12), 'YYYYMM')
         GROUP BY ML.YYYYMM
                , ML.MM_DAYS
         ORDER BY ML.YYYYMM
        ;

        /* --------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 셀그룹별 재고 및 RTF 정보');
        /* --------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_BASE_DATA_FOR_DIO;

        INSERT
          INTO GT_GPMM_BASE_DATA_FOR_DIO
             ( CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , MEASURE
             , YYYYMM
             , REF_NEXT_1_MONTH
             , REF_NEXT_2_MONTH
             , REF_NEXT_3_MONTH
             , REF_NEXT_4_MONTH
             , REF_NEXT_5_MONTH
             , REF_NEXT_6_MONTH
             , REF_NEXT_7_MONTH
             , REF_NEXT_8_MONTH
             , REF_NEXT_9_MONTH
             , REF_NEXT_10_MONTH
             , REF_NEXT_11_MONTH
             , REF_NEXT_12_MONTH
             , QTY
             )
          WITH RTF_N_INV AS (
               SELECT GP.CELL_GROUP
                    , GP.CELL_GROUP_YN /* 20240311 */
                    , 'C' AS OPERATION_GROUP
                    , GP.YYYYMM
                    , CASE WHEN GP.MEASURE IN ('RTF', 'AS_RTF')
                           THEN 'RTF'
                           ELSE 'INV'
                      END                      AS MEASURE
                    , SUM(GP.CELL_CF * GP.QTY) AS QTY
                 FROM GT_GPMM_SCP_RPT_GLOBAL_PSI_MD_MM GP
                WHERE GP.MEASURE IN (
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
                GROUP BY GP.CELL_GROUP
                       , GP.CELL_GROUP_YN /* 20240311 */
                       , GP.YYYYMM
                       , CASE WHEN GP.MEASURE IN ('RTF', 'AS_RTF')
                              THEN 'RTF'
                              ELSE 'INV'
                         END
               )
        SELECT RI.CELL_GROUP
             , RI.CELL_GROUP_YN /* 20240311 */
             , RI.OPERATION_GROUP
             , RI.MEASURE
             , ML.YYYYMM
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 1 ), 'YYYYMM') AS REF_NEXT_1_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 2 ), 'YYYYMM') AS REF_NEXT_2_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 3 ), 'YYYYMM') AS REF_NEXT_3_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 4 ), 'YYYYMM') AS REF_NEXT_4_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 5 ), 'YYYYMM') AS REF_NEXT_5_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 6 ), 'YYYYMM') AS REF_NEXT_6_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 7 ), 'YYYYMM') AS REF_NEXT_7_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 8 ), 'YYYYMM') AS REF_NEXT_8_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 9 ), 'YYYYMM') AS REF_NEXT_9_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 10), 'YYYYMM') AS REF_NEXT_10_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 11), 'YYYYMM') AS REF_NEXT_11_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 12), 'YYYYMM') AS REF_NEXT_12_MONTH
             , SUM(CASE WHEN ML.YYYYMM = RI.YYYYMM
                        THEN RI.QTY
                        ELSE CAST(0 AS NUMBER(20,10))
                   END) AS QTY
          FROM RTF_N_INV           RI
             , GT_GPMM_TMP_MM_LIST ML /* 데이터가 없는 월 0으로 생성을 위해. */
         GROUP BY RI.CELL_GROUP
                , RI.CELL_GROUP_YN /* 20240311 */
                , RI.OPERATION_GROUP
                , RI.MEASURE
                , ML.YYYYMM
        ;

        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 셀그룹별 재고 및 RTF 정보(표준레포트)'); /* --@@@ */
        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_BASE_DATA_FOR_DIO_CELLGROUP;

        INSERT
          INTO GT_GPMM_BASE_DATA_FOR_DIO_CELLGROUP
             ( CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , MEASURE
             , YYYYMM
             , REF_NEXT_1_MONTH
             , REF_NEXT_2_MONTH
             , REF_NEXT_3_MONTH
             , REF_NEXT_4_MONTH
             , REF_NEXT_5_MONTH
             , REF_NEXT_6_MONTH
             , REF_NEXT_7_MONTH
             , REF_NEXT_8_MONTH
             , REF_NEXT_9_MONTH
             , REF_NEXT_10_MONTH
             , REF_NEXT_11_MONTH
             , REF_NEXT_12_MONTH
             , QTY
             )
          WITH RTF_N_INV AS (
               SELECT GP.CELL_GROUP
                    , GP.CELL_GROUP_YN /* 20240311 */
                    , 'C' AS OPERATION_GROUP
                      /* ,GP.OPERATION_GROUP		AS  OPERATION_GROUP */
                    , GP.YYYYMM
                    , SUM(GP.RTF_SALES) AS RTF_SALES
                    , SUM(GP.RTF_PACK)  AS RTF_PACK
                    , SUM(GP.RTF_CELL)  AS RTF_CELL
                    , SUM(GP.INV_SALES) AS INV_SALES
                    , SUM(GP.INV_PACK)  AS INV_PACK
                    , SUM(GP.INV_CELL)  AS INV_CELL
                 FROM (SELECT GP.CELL_GROUP
                            , GP.CELL_GROUP_YN /* 20240311 */
                            , GP.OPERATION_GROUP
                            , GP.YYYYMM
                            , CASE WHEN GP.MEASURE IN ('RTF') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS RTF_SALES
                            , CASE WHEN GP.MEASURE IN ('RTF', 'AS_IN_PLAN') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS RTF_PACK
                            , CASE WHEN GP.MEASURE IN ('RTF', 'AS_IN_PLAN') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS RTF_CELL
                            , CASE WHEN GP.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS INV_SALES
                            , CASE WHEN GP.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS INV_PACK
                            , CASE WHEN GP.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH','PACK_CELL_EOH','SEMI_INTRANSIT','CELL_EOH','CELL_CHAR_AVAILABLE','CELL_FORM_PROGRESS') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS INV_CELL
                         FROM GT_GPMM_SCP_RPT_GLOBAL_PSI_MD_MM GP
                        WHERE GP.MEASURE IN (
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
                      ) GP
                GROUP BY GP.CELL_GROUP
                       , GP.CELL_GROUP_YN /* 20240311 */
                       , GP.OPERATION_GROUP
                       , GP.YYYYMM
               )
        SELECT RI.CELL_GROUP
             , RI.CELL_GROUP_YN /* 20240311 */
             , RI.OPERATION_GROUP
             , CL.MEASURE
             , ML.YYYYMM
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 1 ), 'YYYYMM') AS REF_NEXT_1_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 2 ), 'YYYYMM') AS REF_NEXT_2_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 3 ), 'YYYYMM') AS REF_NEXT_3_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 4 ), 'YYYYMM') AS REF_NEXT_4_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 5 ), 'YYYYMM') AS REF_NEXT_5_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 6 ), 'YYYYMM') AS REF_NEXT_6_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 7 ), 'YYYYMM') AS REF_NEXT_7_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 8 ), 'YYYYMM') AS REF_NEXT_8_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 9 ), 'YYYYMM') AS REF_NEXT_9_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 10), 'YYYYMM') AS REF_NEXT_10_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 11), 'YYYYMM') AS REF_NEXT_11_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 12), 'YYYYMM') AS REF_NEXT_12_MONTH
             , SUM(CASE WHEN ML.YYYYMM = RI.YYYYMM
                        THEN (
                                CASE WHEN CL.MEASURE = 'RTF_SALES' THEN RI.RTF_SALES
                                     WHEN CL.MEASURE = 'RTF_PACK'  THEN RI.RTF_PACK
                                     WHEN CL.MEASURE = 'RTF_CELL'  THEN RI.RTF_CELL
                                     WHEN CL.MEASURE = 'INV_SALES' THEN RI.INV_SALES
                                     WHEN CL.MEASURE = 'INV_PACK'  THEN RI.INV_PACK
                                     WHEN CL.MEASURE = 'INV_CELL'  THEN RI.INV_CELL
                                END
                             )
                        ELSE CAST(0 AS NUMBER(20,10))
                   END) AS QTY
          FROM RTF_N_INV RI
             , (SELECT 'RTF_SALES' AS MEASURE FROM DUAL UNION
                SELECT 'RTF_PACK'  AS MEASURE FROM DUAL UNION
                SELECT 'RTF_CELL'  AS MEASURE FROM DUAL UNION
                SELECT 'INV_SALES' AS MEASURE FROM DUAL UNION
                SELECT 'INV_PACK'  AS MEASURE FROM DUAL UNION
                SELECT 'INV_CELL'  AS MEASURE FROM DUAL
               ) CL
             , GT_GPMM_TMP_MM_LIST ML /* 데이터가 없는 월 0으로 생성을 위해. */
         GROUP BY RI.CELL_GROUP
                , RI.CELL_GROUP_YN /* 20240311 */
                , RI.OPERATION_GROUP
                , CL.MEASURE
                , ML.YYYYMM
        ;

        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 셀그룹별 재고 및 RTF 정보(Detail 표준레포트)'); /* 고도화 */
        /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */

        DELETE FROM GT_GPMM_BASE_DATA_FOR_DIO_DETAILREPORT;

        INSERT
          INTO GT_GPMM_BASE_DATA_FOR_DIO_DETAILREPORT
             ( CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , PRODUCT_LEVEL1
             , PRODUCT_LEVEL2
             , MEASURE
             , YYYYMM
             , REF_NEXT_1_MONTH
             , REF_NEXT_2_MONTH
             , REF_NEXT_3_MONTH
             , REF_NEXT_4_MONTH
             , REF_NEXT_5_MONTH
             , REF_NEXT_6_MONTH
             , REF_NEXT_7_MONTH
             , REF_NEXT_8_MONTH
             , REF_NEXT_9_MONTH
             , REF_NEXT_10_MONTH
             , REF_NEXT_11_MONTH
             , REF_NEXT_12_MONTH
             , QTY
             )
          WITH RTF_N_INV AS (
               SELECT GP.CELL_GROUP
                    , GP.CELL_GROUP_YN /* 20240311 */
                    , GP.OPERATION_GROUP AS OPERATION_GROUP /* 'C'		AS  OPERATION_GROUP */
                    , GP.PRODUCT_LEVEL1
                    , GP.PRODUCT_LEVEL2
                    , GP.YYYYMM
                    , SUM(GP.RTF_SALES)  AS RTF_SALES
                    , SUM(GP.RTF_PACK)   AS RTF_PACK
                    , SUM(GP.RTF_CELL)   AS RTF_CELL
                    , SUM(GP.INV_SALES)  AS INV_SALES
                    , SUM(GP.INV_PACK)   AS INV_PACK
                    , SUM(GP.INV_CELL)   AS INV_CELL
                 FROM (SELECT GP.CELL_GROUP
                            , GP.CELL_GROUP_YN /* 20240311 */
                            , GP.OPERATION_GROUP
                            , FI.GROUP_CODE6 AS PRODUCT_LEVEL1
                            , FI.GROUP_CODE7 AS PRODUCT_LEVEL2
                            , GP.YYYYMM
                            , CASE WHEN GP.MEASURE IN ('RTF') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS RTF_SALES
                            , CASE WHEN GP.MEASURE IN ('RTF', 'AS_IN_PLAN') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS RTF_PACK
                            , CASE WHEN GP.MEASURE IN ('RTF', 'AS_IN_PLAN') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS RTF_CELL
                            , CASE WHEN GP.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS INV_SALES
                            , CASE WHEN GP.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS INV_PACK
                            , CASE WHEN GP.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH','PACK_CELL_EOH','SEMI_INTRANSIT','CELL_EOH','CELL_CHAR_AVAILABLE','CELL_FORM_PROGRESS') THEN GP.CELL_CF * GP.QTY ELSE 0 END AS INV_CELL
                         FROM GT_GPMM_SCP_RPT_GLOBAL_PSI_MD_MM GP
                            , GT_GPMM_SCP_MST_FINAL_ITEM       FI
                        WHERE FI.ITEM_ID(+)         = GP.ITEM_ID
                          AND FI.OPERATION_GROUP(+) = GP.OPERATION_GROUP
                          AND GP.MEASURE IN (
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
                      ) GP
                GROUP BY GP.CELL_GROUP
                       , GP.CELL_GROUP_YN /* 20240311 */
                       , GP.OPERATION_GROUP
                       , GP.PRODUCT_LEVEL1
                       , GP.PRODUCT_LEVEL2
                       , GP.YYYYMM
               )
        SELECT RI.CELL_GROUP
             , RI.CELL_GROUP_YN /* 20240311 */
             , RI.OPERATION_GROUP
             , NVL(RI.PRODUCT_LEVEL1, '-') AS PRODUCT_LEVEL1
             , NVL(RI.PRODUCT_LEVEL2, '-') AS PRODUCT_LEVEL2
             , CL.MEASURE
             , ML.YYYYMM
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 1 ), 'YYYYMM') AS REF_NEXT_1_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 2 ), 'YYYYMM') AS REF_NEXT_2_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 3 ), 'YYYYMM') AS REF_NEXT_3_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 4 ), 'YYYYMM') AS REF_NEXT_4_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 5 ), 'YYYYMM') AS REF_NEXT_5_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 6 ), 'YYYYMM') AS REF_NEXT_6_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 7 ), 'YYYYMM') AS REF_NEXT_7_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 8 ), 'YYYYMM') AS REF_NEXT_8_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 9 ), 'YYYYMM') AS REF_NEXT_9_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 10), 'YYYYMM') AS REF_NEXT_10_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 11), 'YYYYMM') AS REF_NEXT_11_MONTH
             , TO_CHAR(ADD_MONTHS(TO_DATE(ML.YYYYMM || '01', 'YYYYMMDD'), 12), 'YYYYMM') AS REF_NEXT_12_MONTH
             , SUM(CASE WHEN ML.YYYYMM = RI.YYYYMM
                        THEN (
                                CASE WHEN CL.MEASURE = 'RTF_SALES' THEN RI.RTF_SALES
                                     WHEN CL.MEASURE = 'RTF_PACK'  THEN RI.RTF_PACK
                                     WHEN CL.MEASURE = 'RTF_CELL'  THEN RI.RTF_CELL
                                     WHEN CL.MEASURE = 'INV_SALES' THEN RI.INV_SALES
                                     WHEN CL.MEASURE = 'INV_PACK'  THEN RI.INV_PACK
                                     WHEN CL.MEASURE = 'INV_CELL'  THEN RI.INV_CELL
                                END
                             )
                        ELSE CAST(0 AS NUMBER(20,10))
                   END) AS QTY
          FROM RTF_N_INV RI
             , (SELECT 'RTF_SALES' AS MEASURE FROM DUAL UNION
                SELECT 'RTF_PACK'  AS MEASURE FROM DUAL UNION
                SELECT 'RTF_CELL'  AS MEASURE FROM DUAL UNION
                SELECT 'INV_SALES' AS MEASURE FROM DUAL UNION
                SELECT 'INV_PACK'  AS MEASURE FROM DUAL UNION
                SELECT 'INV_CELL'  AS MEASURE FROM DUAL
               ) CL
             , GT_GPMM_TMP_MM_LIST ML /* 데이터가 없는 월 0으로 생성을 위해. */
         GROUP BY RI.CELL_GROUP
                , RI.CELL_GROUP_YN /* 20240311 */
                , RI.OPERATION_GROUP
                , NVL(RI.PRODUCT_LEVEL1, '-')
                , NVL(RI.PRODUCT_LEVEL2, '-')
                , CL.MEASURE
                , ML.YYYYMM
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 월별 RTF 누적 정보');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_RTF_FOR_DIO;

        INSERT
          INTO GT_GPMM_TMP_RTF_FOR_DIO
             ( YYYYMM
             , CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , RTF_QTY
             , FROM_MONTH
             , TO_MONTH
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
             )
        SELECT RI.YYYYMM
             , RI.CELL_GROUP
             , RI.CELL_GROUP_YN /* 20240311 */
             , RI.OPERATION_GROUP
             , RI.QTY               AS RTF_QTY
             , RI.REF_NEXT_1_MONTH  AS FROM_MONTH
             , RI.REF_NEXT_12_MONTH AS TO_MONTH
               /* -- RTF 음수가 존재함.. MAX에서 0이 아닌 음수값을 가져오기 위해 ELSE NULL 처리 후 최종 결과 ISNULL처리함. */
             , NVL(MAX(CASE WHEN RI.REF_NEXT_1_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_1
             , NVL(MAX(CASE WHEN RI.REF_NEXT_2_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_2
             , NVL(MAX(CASE WHEN RI.REF_NEXT_3_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_3
             , NVL(MAX(CASE WHEN RI.REF_NEXT_4_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_4
             , NVL(MAX(CASE WHEN RI.REF_NEXT_5_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_5
             , NVL(MAX(CASE WHEN RI.REF_NEXT_6_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_6
             , NVL(MAX(CASE WHEN RI.REF_NEXT_7_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_7
             , NVL(MAX(CASE WHEN RI.REF_NEXT_8_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_8
             , NVL(MAX(CASE WHEN RI.REF_NEXT_9_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_9
             , NVL(MAX(CASE WHEN RI.REF_NEXT_10_MONTH = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_10
             , NVL(MAX(CASE WHEN RI.REF_NEXT_11_MONTH = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_11
             , NVL(MAX(CASE WHEN RI.REF_NEXT_12_MONTH = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_12
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 1  THEN AR.QTY ELSE 0 END) AS ACC_RTF_1
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 2  THEN AR.QTY ELSE 0 END) AS ACC_RTF_2
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 3  THEN AR.QTY ELSE 0 END) AS ACC_RTF_3
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 4  THEN AR.QTY ELSE 0 END) AS ACC_RTF_4
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 5  THEN AR.QTY ELSE 0 END) AS ACC_RTF_5
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 6  THEN AR.QTY ELSE 0 END) AS ACC_RTF_6
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 7  THEN AR.QTY ELSE 0 END) AS ACC_RTF_7
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 8  THEN AR.QTY ELSE 0 END) AS ACC_RTF_8
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 9  THEN AR.QTY ELSE 0 END) AS ACC_RTF_9
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 10 THEN AR.QTY ELSE 0 END) AS ACC_RTF_10
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 11 THEN AR.QTY ELSE 0 END) AS ACC_RTF_11
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 12 THEN AR.QTY ELSE 0 END) AS ACC_RTF_12
          FROM GT_GPMM_BASE_DATA_FOR_DIO RI
             , GT_GPMM_BASE_DATA_FOR_DIO AR
         WHERE AR.MEASURE(+)         = 'RTF'
           AND AR.CELL_GROUP(+)      = RI.CELL_GROUP
           AND AR.OPERATION_GROUP(+) = RI.OPERATION_GROUP
           AND AR.YYYYMM(+)         >= RI.REF_NEXT_1_MONTH  /* AR.YYYYMM BETWEEN RI.REF_NEXT_1_MONTH */
           AND AR.YYYYMM(+)         <= RI.REF_NEXT_12_MONTH /*               AND RI.REF_NEXT_12_MONTH */
           AND RI.MEASURE            = 'RTF'
         GROUP BY RI.YYYYMM
                , RI.CELL_GROUP
                , RI.CELL_GROUP_YN /* 20240311 */
                , RI.OPERATION_GROUP
                , RI.QTY
                , RI.REF_NEXT_1_MONTH
                , RI.REF_NEXT_12_MONTH
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 월별 RTF 누적 정보(표준레포트)'); /* 고도화 */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_RTF_FOR_DIO_CELLGROUP;

        INSERT
          INTO GT_GPMM_TMP_RTF_FOR_DIO_CELLGROUP
             ( YYYYMM
             , CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , MEASURE
             , RTF_QTY
             , FROM_MONTH
             , TO_MONTH
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
             )
        SELECT RI.YYYYMM
             , RI.CELL_GROUP
             , RI.CELL_GROUP_YN /* 20240311 */
             , RI.OPERATION_GROUP
             , RI.MEASURE
             , RI.QTY               AS RTF_QTY
             , RI.REF_NEXT_1_MONTH  AS FROM_MONTH
             , RI.REF_NEXT_12_MONTH AS TO_MONTH
               /* -- RTF 음수가 존재함.. MAX에서 0이 아닌 음수값을 가져오기 위해 ELSE NULL 처리 후 최종 결과 ISNULL처리함. */
             , NVL(MAX(CASE WHEN RI.REF_NEXT_1_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_1
             , NVL(MAX(CASE WHEN RI.REF_NEXT_2_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_2
             , NVL(MAX(CASE WHEN RI.REF_NEXT_3_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_3
             , NVL(MAX(CASE WHEN RI.REF_NEXT_4_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_4
             , NVL(MAX(CASE WHEN RI.REF_NEXT_5_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_5
             , NVL(MAX(CASE WHEN RI.REF_NEXT_6_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_6
             , NVL(MAX(CASE WHEN RI.REF_NEXT_7_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_7
             , NVL(MAX(CASE WHEN RI.REF_NEXT_8_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_8
             , NVL(MAX(CASE WHEN RI.REF_NEXT_9_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_9
             , NVL(MAX(CASE WHEN RI.REF_NEXT_10_MONTH = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_10
             , NVL(MAX(CASE WHEN RI.REF_NEXT_11_MONTH = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_11
             , NVL(MAX(CASE WHEN RI.REF_NEXT_12_MONTH = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_12
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 1  THEN AR.QTY ELSE 0 END) AS ACC_RTF_1
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 2  THEN AR.QTY ELSE 0 END) AS ACC_RTF_2
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 3  THEN AR.QTY ELSE 0 END) AS ACC_RTF_3
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 4  THEN AR.QTY ELSE 0 END) AS ACC_RTF_4
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 5  THEN AR.QTY ELSE 0 END) AS ACC_RTF_5
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 6  THEN AR.QTY ELSE 0 END) AS ACC_RTF_6
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 7  THEN AR.QTY ELSE 0 END) AS ACC_RTF_7
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 8  THEN AR.QTY ELSE 0 END) AS ACC_RTF_8
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 9  THEN AR.QTY ELSE 0 END) AS ACC_RTF_9
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 10 THEN AR.QTY ELSE 0 END) AS ACC_RTF_10
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 11 THEN AR.QTY ELSE 0 END) AS ACC_RTF_11
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 12 THEN AR.QTY ELSE 0 END) AS ACC_RTF_12
          FROM GT_GPMM_BASE_DATA_FOR_DIO_CELLGROUP RI
             , GT_GPMM_BASE_DATA_FOR_DIO_CELLGROUP AR
         WHERE AR.MEASURE(+)      LIKE 'RTF%'
           AND AR.CELL_GROUP(+)      = RI.CELL_GROUP
           AND AR.OPERATION_GROUP(+) = RI.OPERATION_GROUP
           AND AR.MEASURE(+)         = RI.MEASURE
           AND AR.YYYYMM(+)         >= RI.REF_NEXT_1_MONTH  /* AR.YYYYMM BETWEEN RI.REF_NEXT_1_MONTH */
           AND AR.YYYYMM(+)         <= RI.REF_NEXT_12_MONTH /*               AND RI.REF_NEXT_12_MONTH */
           AND RI.MEASURE         LIKE 'RTF%'
         GROUP BY RI.YYYYMM
                , RI.CELL_GROUP
                , RI.CELL_GROUP_YN /* 20240311 */
                , RI.OPERATION_GROUP
                , RI.MEASURE
                , RI.QTY
                , RI.REF_NEXT_1_MONTH
                , RI.REF_NEXT_12_MONTH
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 월별 RTF 누적 정보(Detail 표준레포트)'); /* 고도화 */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_RTF_FOR_DIO_DETAILREPORT;

        INSERT
          INTO GT_GPMM_TMP_RTF_FOR_DIO_DETAILREPORT
             ( YYYYMM
             , CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , PRODUCT_LEVEL1
             , PRODUCT_LEVEL2
             , MEASURE
             , RTF_QTY
             , FROM_MONTH
             , TO_MONTH
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
             )
        SELECT RI.YYYYMM
             , RI.CELL_GROUP
             , RI.CELL_GROUP_YN /* 20240311 */
             , RI.OPERATION_GROUP
             , NVL(RI.PRODUCT_LEVEL1, '-') AS PRODUCT_LEVEL1
             , NVL(RI.PRODUCT_LEVEL2, '-') AS PRODUCT_LEVEL2
             , RI.MEASURE
             , RI.QTY               AS RTF_QTY
             , RI.REF_NEXT_1_MONTH  AS FROM_MONTH
             , RI.REF_NEXT_12_MONTH AS TO_MONTH
               /* -- RTF 음수가 존재함.. MAX에서 0이 아닌 음수값을 가져오기 위해 ELSE NULL 처리 후 최종 결과 ISNULL처리함. */
             , NVL(MAX(CASE WHEN RI.REF_NEXT_1_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_1
             , NVL(MAX(CASE WHEN RI.REF_NEXT_2_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_2
             , NVL(MAX(CASE WHEN RI.REF_NEXT_3_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_3
             , NVL(MAX(CASE WHEN RI.REF_NEXT_4_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_4
             , NVL(MAX(CASE WHEN RI.REF_NEXT_5_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_5
             , NVL(MAX(CASE WHEN RI.REF_NEXT_6_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_6
             , NVL(MAX(CASE WHEN RI.REF_NEXT_7_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_7
             , NVL(MAX(CASE WHEN RI.REF_NEXT_8_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_8
             , NVL(MAX(CASE WHEN RI.REF_NEXT_9_MONTH  = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_9
             , NVL(MAX(CASE WHEN RI.REF_NEXT_10_MONTH = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_10
             , NVL(MAX(CASE WHEN RI.REF_NEXT_11_MONTH = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_11
             , NVL(MAX(CASE WHEN RI.REF_NEXT_12_MONTH = AR.YYYYMM THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_12
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 1  THEN AR.QTY ELSE 0 END) AS ACC_RTF_1
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 2  THEN AR.QTY ELSE 0 END) AS ACC_RTF_2
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 3  THEN AR.QTY ELSE 0 END) AS ACC_RTF_3
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 4  THEN AR.QTY ELSE 0 END) AS ACC_RTF_4
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 5  THEN AR.QTY ELSE 0 END) AS ACC_RTF_5
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 6  THEN AR.QTY ELSE 0 END) AS ACC_RTF_6
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 7  THEN AR.QTY ELSE 0 END) AS ACC_RTF_7
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 8  THEN AR.QTY ELSE 0 END) AS ACC_RTF_8
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 9  THEN AR.QTY ELSE 0 END) AS ACC_RTF_9
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 10 THEN AR.QTY ELSE 0 END) AS ACC_RTF_10
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 11 THEN AR.QTY ELSE 0 END) AS ACC_RTF_11
             , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.YYYYMM, 'YYYYMM'), TO_DATE(RI.YYYYMM, 'YYYYMM')) <= 12 THEN AR.QTY ELSE 0 END) AS ACC_RTF_12
          FROM GT_GPMM_BASE_DATA_FOR_DIO_DETAILREPORT RI
             , GT_GPMM_BASE_DATA_FOR_DIO_DETAILREPORT AR
         WHERE AR.MEASURE(+)      LIKE 'RTF%'
           AND AR.CELL_GROUP(+)      = RI.CELL_GROUP
           AND AR.PRODUCT_LEVEL1(+)  = RI.PRODUCT_LEVEL1
           AND AR.PRODUCT_LEVEL2(+)  = RI.PRODUCT_LEVEL2
           AND AR.OPERATION_GROUP(+) = RI.OPERATION_GROUP
           AND AR.MEASURE(+)         = RI.MEASURE
           AND AR.YYYYMM(+)         >= RI.REF_NEXT_1_MONTH  /* AR.YYYYMM BETWEEN RI.REF_NEXT_1_MONTH */
           AND AR.YYYYMM(+)         <= RI.REF_NEXT_12_MONTH /*               AND RI.REF_NEXT_12_MONTH */
           AND RI.MEASURE         LIKE 'RTF%'
         GROUP BY RI.YYYYMM
                , RI.CELL_GROUP
                , RI.CELL_GROUP_YN /* 20240311 */
                , RI.OPERATION_GROUP
                , NVL(RI.PRODUCT_LEVEL1, '-')
                , NVL(RI.PRODUCT_LEVEL2, '-')
                , RI.MEASURE
                , RI.QTY
                , RI.REF_NEXT_1_MONTH
                , RI.REF_NEXT_12_MONTH
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 셀그룹별 DIO 산출');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_INVENTORY_DIO;

        INSERT
          INTO GT_GPMM_TMP_INVENTORY_DIO
             ( YYYYMM
             , MM_DAYS
             , CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , INV_QTY
             , RTF_QTY
             , DIO
             )
        SELECT I.YYYYMM
             , D.MM_DAYS
             , I.CELL_GROUP
             , I.CELL_GROUP_YN /* 20240311 */
             , I.OPERATION_GROUP
             , I.QTY     AS INV_QTY
             , R.RTF_QTY AS RTF_QTY
             , CASE WHEN I.QTY <= 0 THEN
                         0
                    WHEN R.CELL_GROUP IS NULL THEN
                         365
                    WHEN I.QTY - R.RTF_NEXT_1 < 0 THEN
                         NVL(CAST(I.QTY AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_1 = 0 THEN NULL ELSE R.RTF_NEXT_1 END, 0) * D.DAYS_NEXT_1
                    WHEN I.QTY - R.RTF_NEXT_1 = 0 THEN
                         D.ACC_DAYS_1
                    WHEN I.QTY - R.ACC_RTF_2 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_1) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_2 = 0 THEN NULL ELSE R.RTF_NEXT_2 END, 0) * D.DAYS_NEXT_2 + D.ACC_DAYS_1
                    WHEN I.QTY - R.ACC_RTF_2 = 0 THEN
                         D.ACC_DAYS_2
                    WHEN I.QTY - R.ACC_RTF_3 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_2) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_3 = 0 THEN NULL ELSE R.RTF_NEXT_3 END, 0) * D.DAYS_NEXT_3 + D.ACC_DAYS_2
                    WHEN I.QTY - R.ACC_RTF_3 = 0 THEN
                         D.ACC_DAYS_3
                    WHEN I.QTY - R.ACC_RTF_4 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_3) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_4 = 0 THEN NULL ELSE R.RTF_NEXT_4 END, 0) * D.DAYS_NEXT_4 + D.ACC_DAYS_3
                    WHEN I.QTY - R.ACC_RTF_4 = 0 THEN
                         D.ACC_DAYS_4
                    WHEN I.QTY - R.ACC_RTF_5 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_4) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_5 = 0 THEN NULL ELSE R.RTF_NEXT_5 END, 0) * D.DAYS_NEXT_5 + D.ACC_DAYS_4
                    WHEN I.QTY - R.ACC_RTF_5 = 0 THEN
                         D.ACC_DAYS_5
                    WHEN I.QTY - R.ACC_RTF_6 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_5) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_6 = 0 THEN NULL ELSE R.RTF_NEXT_6 END, 0) * D.DAYS_NEXT_6 + D.ACC_DAYS_5
                    WHEN I.QTY - R.ACC_RTF_6 = 0 THEN
                         D.ACC_DAYS_6
                    WHEN I.QTY - R.ACC_RTF_7 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_6) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_7 = 0 THEN NULL ELSE R.RTF_NEXT_7 END, 0) * D.DAYS_NEXT_7 + D.ACC_DAYS_6
                    WHEN I.QTY - R.ACC_RTF_7 = 0 THEN
                         D.ACC_DAYS_7
                    WHEN I.QTY - R.ACC_RTF_8 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_7) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_8 = 0 THEN NULL ELSE R.RTF_NEXT_8 END, 0) * D.DAYS_NEXT_8 + D.ACC_DAYS_7
                    WHEN I.QTY - R.ACC_RTF_8 = 0 THEN
                         D.ACC_DAYS_8
                    WHEN I.QTY - R.ACC_RTF_9 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_8) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_9 = 0 THEN NULL ELSE R.RTF_NEXT_9 END, 0) * D.DAYS_NEXT_9 + D.ACC_DAYS_8
                    WHEN I.QTY - R.ACC_RTF_9 = 0 THEN
                         D.ACC_DAYS_9
                    WHEN I.QTY - R.ACC_RTF_10 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_9) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_10 = 0 THEN NULL ELSE R.RTF_NEXT_10 END, 0) * D.DAYS_NEXT_10 + D.ACC_DAYS_9
                    WHEN I.QTY - R.ACC_RTF_10 = 0 THEN
                         D.ACC_DAYS_10
                    WHEN I.QTY - R.ACC_RTF_11 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_10) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_11 = 0 THEN NULL ELSE R.RTF_NEXT_11 END, 0) * D.DAYS_NEXT_11 + D.ACC_DAYS_10
                    WHEN I.QTY - R.ACC_RTF_11 = 0 THEN
                         D.ACC_DAYS_11
                    WHEN I.QTY - R.ACC_RTF_12 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_11) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_12 = 0 THEN NULL ELSE R.RTF_NEXT_12 END, 0) * D.DAYS_NEXT_12 + D.ACC_DAYS_11
                    WHEN I.QTY - R.ACC_RTF_12 = 0 THEN
                         D.ACC_DAYS_12
                    ELSE 365
               END AS DIO
          FROM GT_GPMM_BASE_DATA_FOR_DIO I /* 재고 */
             , GT_GPMM_TMP_MM_DAYS_INFO  D
             , GT_GPMM_TMP_RTF_FOR_DIO   R
         WHERE D.YYYYMM             = I.YYYYMM
           AND R.YYYYMM(+)          = I.YYYYMM
           AND R.CELL_GROUP(+)      = I.CELL_GROUP
           AND R.OPERATION_GROUP(+) = I.OPERATION_GROUP
           AND I.MEASURE            = 'INV' /* 재고 */
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 셀그룹별 DIO 산출(표준레포트)'); /* 고도화 */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_INVENTORY_DIO_CELLGROUP;

        INSERT
          INTO GT_GPMM_TMP_INVENTORY_DIO_CELLGROUP
             ( YYYYMM
             , MM_DAYS
             , CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , MEASURE
             , INV_QTY
             , RTF_QTY
             , DIO
             )
        SELECT I.YYYYMM
             , D.MM_DAYS
             , I.CELL_GROUP
             , I.CELL_GROUP_YN /* 20240311 */
             , I.OPERATION_GROUP
             , CL.MEASURE
             , I.QTY     AS INV_QTY
             , R.RTF_QTY AS RTF_QTY
             , CASE WHEN I.QTY <= 0 THEN
                         0
                    WHEN R.CELL_GROUP IS NULL THEN
                         365
                    WHEN I.QTY - R.RTF_NEXT_1 < 0 THEN
                         NVL(CAST(I.QTY AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_1 = 0 THEN NULL ELSE R.RTF_NEXT_1 END, 0) * D.DAYS_NEXT_1
                    WHEN I.QTY - R.RTF_NEXT_1 = 0 THEN
                         D.ACC_DAYS_1
                    WHEN I.QTY - R.ACC_RTF_2 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_1) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_2 = 0 THEN NULL ELSE R.RTF_NEXT_2 END, 0) * D.DAYS_NEXT_2 + D.ACC_DAYS_1
                    WHEN I.QTY - R.ACC_RTF_2 = 0 THEN
                         D.ACC_DAYS_2
                    WHEN I.QTY - R.ACC_RTF_3 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_2) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_3 = 0 THEN NULL ELSE R.RTF_NEXT_3 END, 0) * D.DAYS_NEXT_3 + D.ACC_DAYS_2
                    WHEN I.QTY - R.ACC_RTF_3 = 0 THEN
                         D.ACC_DAYS_3
                    WHEN I.QTY - R.ACC_RTF_4 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_3) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_4 = 0 THEN NULL ELSE R.RTF_NEXT_4 END, 0) * D.DAYS_NEXT_4 + D.ACC_DAYS_3
                    WHEN I.QTY - R.ACC_RTF_4 = 0 THEN
                         D.ACC_DAYS_4
                    WHEN I.QTY - R.ACC_RTF_5 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_4) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_5 = 0 THEN NULL ELSE R.RTF_NEXT_5 END, 0) * D.DAYS_NEXT_5 + D.ACC_DAYS_4
                    WHEN I.QTY - R.ACC_RTF_5 = 0 THEN
                         D.ACC_DAYS_5
                    WHEN I.QTY - R.ACC_RTF_6 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_5) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_6 = 0 THEN NULL ELSE R.RTF_NEXT_6 END, 0) * D.DAYS_NEXT_6 + D.ACC_DAYS_5
                    WHEN I.QTY - R.ACC_RTF_6 = 0 THEN
                         D.ACC_DAYS_6
                    WHEN I.QTY - R.ACC_RTF_7 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_6) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_7 = 0 THEN NULL ELSE R.RTF_NEXT_7 END, 0) * D.DAYS_NEXT_7 + D.ACC_DAYS_6
                    WHEN I.QTY - R.ACC_RTF_7 = 0 THEN
                         D.ACC_DAYS_7
                    WHEN I.QTY - R.ACC_RTF_8 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_7) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_8 = 0 THEN NULL ELSE R.RTF_NEXT_8 END, 0) * D.DAYS_NEXT_8 + D.ACC_DAYS_7
                    WHEN I.QTY - R.ACC_RTF_8 = 0 THEN
                         D.ACC_DAYS_8
                    WHEN I.QTY - R.ACC_RTF_9 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_8) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_9 = 0 THEN NULL ELSE R.RTF_NEXT_9 END, 0) * D.DAYS_NEXT_9 + D.ACC_DAYS_8
                    WHEN I.QTY - R.ACC_RTF_9 = 0 THEN
                         D.ACC_DAYS_9
                    WHEN I.QTY - R.ACC_RTF_10 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_9) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_10 = 0 THEN NULL ELSE R.RTF_NEXT_10 END, 0) * D.DAYS_NEXT_10 + D.ACC_DAYS_9
                    WHEN I.QTY - R.ACC_RTF_10 = 0 THEN
                         D.ACC_DAYS_10
                    WHEN I.QTY - R.ACC_RTF_11 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_10) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_11 = 0 THEN NULL ELSE R.RTF_NEXT_11 END, 0) * D.DAYS_NEXT_11 + D.ACC_DAYS_10
                    WHEN I.QTY - R.ACC_RTF_11 = 0 THEN
                         D.ACC_DAYS_11
                    WHEN I.QTY - R.ACC_RTF_12 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_11) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_12 = 0 THEN NULL ELSE R.RTF_NEXT_12 END, 0) * D.DAYS_NEXT_12 + D.ACC_DAYS_11
                    WHEN I.QTY - R.ACC_RTF_12 = 0 THEN
                         D.ACC_DAYS_12
                    ELSE 365
               END AS DIO
          FROM GT_GPMM_BASE_DATA_FOR_DIO_CELLGROUP I /* 재고 */
             , ( SELECT 'DIO_SALES' AS MEASURE, 'SALES' AS MEASURE_GROUP FROM DUAL UNION
                 SELECT 'DIO_PACK'  AS MEASURE, 'PACK'  AS MEASURE_GROUP FROM DUAL UNION
                 SELECT 'DIO_CELL'  AS MEASURE, 'CELL'  AS MEASURE_GROUP FROM DUAL
               ) CL
             , GT_GPMM_TMP_MM_DAYS_INFO D
             , GT_GPMM_TMP_RTF_FOR_DIO_CELLGROUP R
         WHERE CL.MEASURE_GROUP     = SUBSTR(I.MEASURE, INSTR(I.MEASURE, '_') + 1, LENGTH(RTRIM(I.MEASURE)))
           AND D.YYYYMM             = I.YYYYMM
           AND R.YYYYMM(+)          = I.YYYYMM
           AND R.CELL_GROUP(+)      = I.CELL_GROUP
           AND R.OPERATION_GROUP(+) = I.OPERATION_GROUP
           AND SUBSTR(R.MEASURE(+), INSTR(R.MEASURE(+), '_') + 1, LENGTH(RTRIM(R.MEASURE(+)))) = SUBSTR(I.MEASURE, INSTR(I.MEASURE, '_') + 1, LENGTH(RTRIM(I.MEASURE)))
           AND I.MEASURE         LIKE 'INV%' /* 재고 */
        ;

        /* -- PACK_DIO = PACK_DIO - SALES_DIO */
        /* ★UPDATE … FROM → MERGE : 원천 B 가 대상 한 행에 여러 행 붙을 때 자기 행 우선 1행 */
        MERGE INTO GT_GPMM_TMP_INVENTORY_DIO_CELLGROUP A
        USING ( SELECT XA.RID
                     , XA.DIO_RESULT
                  FROM ( SELECT T.ROWID AS RID
                              , B.DIO_RESULT
                              , ROW_NUMBER() OVER (PARTITION BY T.ROWID
                                                       ORDER BY CASE WHEN B.SRC_RID = T.ROWID THEN 0 ELSE 1 END) AS RN
                           FROM GT_GPMM_TMP_INVENTORY_DIO_CELLGROUP T
                              , ( SELECT A.YYYYMM
                                     , A.CELL_GROUP
                                     , A.MEASURE
                                     , CASE WHEN A.MEASURE = 'DIO_PACK' THEN A.DIO - B.DIO
                                            ELSE A.DIO
                                       END AS DIO_RESULT
                                     , A.ROWID AS SRC_RID
                                  FROM GT_GPMM_TMP_INVENTORY_DIO_CELLGROUP A
                                     , GT_GPMM_TMP_INVENTORY_DIO_CELLGROUP B
                                 WHERE A.YYYYMM        = B.YYYYMM(+)
                                   AND A.CELL_GROUP    = B.CELL_GROUP(+)
                                   AND B.MEASURE(+)    = 'DIO_SALES'
                                   AND A.MEASURE       = 'DIO_PACK'
                                ) B
                          WHERE T.YYYYMM     = B.YYYYMM
                            AND T.CELL_GROUP = B.CELL_GROUP
                            AND T.MEASURE    = B.MEASURE
                            AND T.MEASURE    = 'DIO_PACK'
                       ) XA
                 WHERE XA.RN = 1
              ) B
           ON ( A.ROWID = B.RID )
         WHEN MATCHED THEN
              UPDATE
                 SET A.DIO = CASE WHEN B.DIO_RESULT < 0 THEN 0 ELSE B.DIO_RESULT END
        ;

        /* -- CELL_DIO = CELL_DIO - PACK_DIO - SALES_DIO */
        /* ★UPDATE … FROM → MERGE : 원천 B 가 대상 한 행에 여러 행 붙을 때 자기 행 우선 1행 */
        MERGE INTO GT_GPMM_TMP_INVENTORY_DIO_CELLGROUP A
        USING ( SELECT XA.RID
                     , XA.DIO_RESULT
                  FROM ( SELECT T.ROWID AS RID
                              , B.DIO_RESULT
                              , ROW_NUMBER() OVER (PARTITION BY T.ROWID
                                                       ORDER BY CASE WHEN B.SRC_RID = T.ROWID THEN 0 ELSE 1 END) AS RN
                           FROM GT_GPMM_TMP_INVENTORY_DIO_CELLGROUP T
                              , ( SELECT A.YYYYMM
                                     , A.CELL_GROUP
                                     , A.MEASURE
                                     , CASE WHEN A.MEASURE = 'DIO_CELL' THEN A.DIO - C.DIO - B.DIO
                                            ELSE A.DIO
                                       END AS DIO_RESULT
                                     , A.ROWID AS SRC_RID
                                  FROM GT_GPMM_TMP_INVENTORY_DIO_CELLGROUP A
                                     , GT_GPMM_TMP_INVENTORY_DIO_CELLGROUP B
                                     , GT_GPMM_TMP_INVENTORY_DIO_CELLGROUP C
                                 WHERE A.YYYYMM        = B.YYYYMM(+)
                                   AND A.CELL_GROUP    = B.CELL_GROUP(+)
                                   AND B.MEASURE(+)    = 'DIO_PACK'
                                   AND A.YYYYMM        = C.YYYYMM(+)
                                   AND A.CELL_GROUP    = C.CELL_GROUP(+)
                                   AND C.MEASURE(+)    = 'DIO_SALES'
                                   AND A.MEASURE       = 'DIO_CELL'
                                ) B
                          WHERE T.YYYYMM     = B.YYYYMM
                            AND T.CELL_GROUP = B.CELL_GROUP
                            AND T.MEASURE    = B.MEASURE
                            AND T.MEASURE    = 'DIO_CELL'
                       ) XA
                 WHERE XA.RN = 1
              ) B
           ON ( A.ROWID = B.RID )
         WHEN MATCHED THEN
              UPDATE
                 SET A.DIO = CASE WHEN B.DIO_RESULT < 0 THEN 0 ELSE B.DIO_RESULT END
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DIO 계산 : 셀그룹별 DIO 산출(Detail 표준레포트)'); /* 고도화 */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT;

        INSERT
          INTO GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT
             ( YYYYMM
             , MM_DAYS
             , CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , PRODUCT_LEVEL1
             , PRODUCT_LEVEL2
             , MEASURE
             , INV_QTY
             , RTF_QTY
             , DIO
             , ATTRIBUTE9
             )
        SELECT I.YYYYMM
             , D.MM_DAYS
             , I.CELL_GROUP
             , I.CELL_GROUP_YN /* 20240311 */
             , I.OPERATION_GROUP
             , NVL(I.PRODUCT_LEVEL1, '-') AS PRODUCT_LEVEL1
             , NVL(I.PRODUCT_LEVEL2, '-') AS PRODUCT_LEVEL2
             , CL.MEASURE
             , I.QTY     AS INV_QTY
             , R.RTF_QTY AS RTF_QTY
             , CASE WHEN I.QTY <= 0 THEN
                         0
                    WHEN R.CELL_GROUP IS NULL THEN
                         365
                    WHEN I.QTY - R.RTF_NEXT_1 < 0 THEN
                         NVL(CAST(I.QTY AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_1 = 0 THEN NULL ELSE R.RTF_NEXT_1 END, 0) * D.DAYS_NEXT_1
                    WHEN I.QTY - R.RTF_NEXT_1 = 0 THEN
                         D.ACC_DAYS_1
                    WHEN I.QTY - R.ACC_RTF_2 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_1) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_2 = 0 THEN NULL ELSE R.RTF_NEXT_2 END, 0) * D.DAYS_NEXT_2 + D.ACC_DAYS_1
                    WHEN I.QTY - R.ACC_RTF_2 = 0 THEN
                         D.ACC_DAYS_2
                    WHEN I.QTY - R.ACC_RTF_3 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_2) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_3 = 0 THEN NULL ELSE R.RTF_NEXT_3 END, 0) * D.DAYS_NEXT_3 + D.ACC_DAYS_2
                    WHEN I.QTY - R.ACC_RTF_3 = 0 THEN
                         D.ACC_DAYS_3
                    WHEN I.QTY - R.ACC_RTF_4 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_3) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_4 = 0 THEN NULL ELSE R.RTF_NEXT_4 END, 0) * D.DAYS_NEXT_4 + D.ACC_DAYS_3
                    WHEN I.QTY - R.ACC_RTF_4 = 0 THEN
                         D.ACC_DAYS_4
                    WHEN I.QTY - R.ACC_RTF_5 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_4) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_5 = 0 THEN NULL ELSE R.RTF_NEXT_5 END, 0) * D.DAYS_NEXT_5 + D.ACC_DAYS_4
                    WHEN I.QTY - R.ACC_RTF_5 = 0 THEN
                         D.ACC_DAYS_5
                    WHEN I.QTY - R.ACC_RTF_6 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_5) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_6 = 0 THEN NULL ELSE R.RTF_NEXT_6 END, 0) * D.DAYS_NEXT_6 + D.ACC_DAYS_5
                    WHEN I.QTY - R.ACC_RTF_6 = 0 THEN
                         D.ACC_DAYS_6
                    WHEN I.QTY - R.ACC_RTF_7 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_6) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_7 = 0 THEN NULL ELSE R.RTF_NEXT_7 END, 0) * D.DAYS_NEXT_7 + D.ACC_DAYS_6
                    WHEN I.QTY - R.ACC_RTF_7 = 0 THEN
                         D.ACC_DAYS_7
                    WHEN I.QTY - R.ACC_RTF_8 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_7) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_8 = 0 THEN NULL ELSE R.RTF_NEXT_8 END, 0) * D.DAYS_NEXT_8 + D.ACC_DAYS_7
                    WHEN I.QTY - R.ACC_RTF_8 = 0 THEN
                         D.ACC_DAYS_8
                    WHEN I.QTY - R.ACC_RTF_9 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_8) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_9 = 0 THEN NULL ELSE R.RTF_NEXT_9 END, 0) * D.DAYS_NEXT_9 + D.ACC_DAYS_8
                    WHEN I.QTY - R.ACC_RTF_9 = 0 THEN
                         D.ACC_DAYS_9
                    WHEN I.QTY - R.ACC_RTF_10 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_9) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_10 = 0 THEN NULL ELSE R.RTF_NEXT_10 END, 0) * D.DAYS_NEXT_10 + D.ACC_DAYS_9
                    WHEN I.QTY - R.ACC_RTF_10 = 0 THEN
                         D.ACC_DAYS_10
                    WHEN I.QTY - R.ACC_RTF_11 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_10) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_11 = 0 THEN NULL ELSE R.RTF_NEXT_11 END, 0) * D.DAYS_NEXT_11 + D.ACC_DAYS_10
                    WHEN I.QTY - R.ACC_RTF_11 = 0 THEN
                         D.ACC_DAYS_11
                    WHEN I.QTY - R.ACC_RTF_12 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_11) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_12 = 0 THEN NULL ELSE R.RTF_NEXT_12 END, 0) * D.DAYS_NEXT_12 + D.ACC_DAYS_11
                    WHEN I.QTY - R.ACC_RTF_12 = 0 THEN
                         D.ACC_DAYS_12
                    ELSE 365
               END AS DIO
             , 'LV2'     AS ATTRIBUTE9
          FROM GT_GPMM_BASE_DATA_FOR_DIO_DETAILREPORT I /* 재고 */
             , ( SELECT 'DIO_SALES' AS MEASURE, 'SALES' AS MEASURE_GROUP FROM DUAL UNION
                 SELECT 'DIO_PACK'  AS MEASURE, 'PACK'  AS MEASURE_GROUP FROM DUAL UNION
                 SELECT 'DIO_CELL'  AS MEASURE, 'CELL'  AS MEASURE_GROUP FROM DUAL
               ) CL
             , GT_GPMM_TMP_MM_DAYS_INFO D
             , GT_GPMM_TMP_RTF_FOR_DIO_DETAILREPORT R
         WHERE CL.MEASURE_GROUP     = SUBSTR(I.MEASURE, INSTR(I.MEASURE, '_') + 1, LENGTH(RTRIM(I.MEASURE)))
           AND D.YYYYMM             = I.YYYYMM
           AND R.YYYYMM(+)          = I.YYYYMM
           AND R.CELL_GROUP(+)      = I.CELL_GROUP
           AND R.PRODUCT_LEVEL1(+)  = I.PRODUCT_LEVEL1
           AND R.PRODUCT_LEVEL2(+)  = I.PRODUCT_LEVEL2
           AND R.OPERATION_GROUP(+) = I.OPERATION_GROUP
           AND SUBSTR(R.MEASURE(+), INSTR(R.MEASURE(+), '_') + 1, LENGTH(RTRIM(R.MEASURE(+)))) = SUBSTR(I.MEASURE, INSTR(I.MEASURE, '_') + 1, LENGTH(RTRIM(I.MEASURE)))
           AND I.MEASURE         LIKE 'INV%' /* 재고 */
           AND NVL(I.QTY, 0)        > 0
        ;

        /* -- PACK_DIO = PACK_DIO - SALES_DIO */
        /* ★UPDATE … FROM → MERGE : 원문 ON 에 OPERATION_GROUP 이 없어 한 행에 여러 행이 붙음 — 자기 행·같은 OPERATION_GROUP 우선 1행 */
        MERGE INTO GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT A
        USING ( SELECT XA.RID
                     , XA.DIO_RESULT
                  FROM ( SELECT T.ROWID AS RID
                              , B.DIO_RESULT
                              , ROW_NUMBER() OVER (PARTITION BY T.ROWID
                                                       ORDER BY CASE WHEN B.SRC_RID = T.ROWID THEN 0 ELSE 1 END
                                                              , CASE WHEN B.B_OG = T.OPERATION_GROUP THEN 0 ELSE 1 END) AS RN
                           FROM GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT T
                              , ( SELECT A.YYYYMM
                                     , A.CELL_GROUP
                                     , A.MEASURE
                                     , A.PRODUCT_LEVEL1
                                     , A.PRODUCT_LEVEL2
                                     , CASE WHEN A.MEASURE = 'DIO_PACK' THEN A.DIO - B.DIO
                                            ELSE A.DIO
                                       END AS DIO_RESULT
                                     , A.ROWID           AS SRC_RID
                                     , B.OPERATION_GROUP AS B_OG
                                  FROM GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT A
                                     , GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT B
                                 WHERE A.YYYYMM            = B.YYYYMM(+)
                                   AND A.CELL_GROUP        = B.CELL_GROUP(+)
                                   AND A.PRODUCT_LEVEL1    = B.PRODUCT_LEVEL1(+)
                                   AND A.PRODUCT_LEVEL2    = B.PRODUCT_LEVEL2(+)
                                   AND B.MEASURE(+)        = 'DIO_SALES'
                                   AND A.MEASURE           = 'DIO_PACK'
                                ) B
                          WHERE T.YYYYMM         = B.YYYYMM
                            AND T.CELL_GROUP     = B.CELL_GROUP
                            AND T.PRODUCT_LEVEL1 = B.PRODUCT_LEVEL1
                            AND T.PRODUCT_LEVEL2 = B.PRODUCT_LEVEL2
                            AND T.MEASURE        = B.MEASURE
                            AND T.MEASURE        = 'DIO_PACK'
                       ) XA
                 WHERE XA.RN = 1
              ) B
           ON ( A.ROWID = B.RID )
         WHEN MATCHED THEN
              UPDATE
                 SET A.DIO = CASE WHEN B.DIO_RESULT < 0 THEN 0 ELSE B.DIO_RESULT END
        ;

        /* -- PRODUCT_LEVEL1 기준 DIO 산출 */
        INSERT
          INTO GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT
             ( YYYYMM
             , MM_DAYS
             , CELL_GROUP
             , CELL_GROUP_YN
             , OPERATION_GROUP
             , PRODUCT_LEVEL1
             , PRODUCT_LEVEL2
             , MEASURE
             , INV_QTY
             , RTF_QTY
             , DIO
             , ATTRIBUTE9
             )
        SELECT I.YYYYMM
             , D.MM_DAYS
             , I.CELL_GROUP
             , I.CELL_GROUP_YN /* 20240311 */
             , 'C'       AS OPERATION_GROUP /* --I.OPERATION_GROUP operatoin 구분없이 */
             , NVL(I.PRODUCT_LEVEL1, '-') AS PRODUCT_LEVEL1
             , 'DIO'     AS PRODUCT_LEVEL2
             , CL.MEASURE
             , I.QTY     AS INV_QTY
             , R.RTF_QTY AS RTF_QTY
             , CASE WHEN I.QTY <= 0 THEN
                         0
                    WHEN R.CELL_GROUP IS NULL THEN
                         365
                    WHEN I.QTY - R.RTF_NEXT_1 < 0 THEN
                         NVL(CAST(I.QTY AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_1 = 0 THEN NULL ELSE R.RTF_NEXT_1 END, 0) * D.DAYS_NEXT_1
                    WHEN I.QTY - R.RTF_NEXT_1 = 0 THEN
                         D.ACC_DAYS_1
                    WHEN I.QTY - R.ACC_RTF_2 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_1) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_2 = 0 THEN NULL ELSE R.RTF_NEXT_2 END, 0) * D.DAYS_NEXT_2 + D.ACC_DAYS_1
                    WHEN I.QTY - R.ACC_RTF_2 = 0 THEN
                         D.ACC_DAYS_2
                    WHEN I.QTY - R.ACC_RTF_3 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_2) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_3 = 0 THEN NULL ELSE R.RTF_NEXT_3 END, 0) * D.DAYS_NEXT_3 + D.ACC_DAYS_2
                    WHEN I.QTY - R.ACC_RTF_3 = 0 THEN
                         D.ACC_DAYS_3
                    WHEN I.QTY - R.ACC_RTF_4 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_3) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_4 = 0 THEN NULL ELSE R.RTF_NEXT_4 END, 0) * D.DAYS_NEXT_4 + D.ACC_DAYS_3
                    WHEN I.QTY - R.ACC_RTF_4 = 0 THEN
                         D.ACC_DAYS_4
                    WHEN I.QTY - R.ACC_RTF_5 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_4) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_5 = 0 THEN NULL ELSE R.RTF_NEXT_5 END, 0) * D.DAYS_NEXT_5 + D.ACC_DAYS_4
                    WHEN I.QTY - R.ACC_RTF_5 = 0 THEN
                         D.ACC_DAYS_5
                    WHEN I.QTY - R.ACC_RTF_6 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_5) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_6 = 0 THEN NULL ELSE R.RTF_NEXT_6 END, 0) * D.DAYS_NEXT_6 + D.ACC_DAYS_5
                    WHEN I.QTY - R.ACC_RTF_6 = 0 THEN
                         D.ACC_DAYS_6
                    WHEN I.QTY - R.ACC_RTF_7 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_6) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_7 = 0 THEN NULL ELSE R.RTF_NEXT_7 END, 0) * D.DAYS_NEXT_7 + D.ACC_DAYS_6
                    WHEN I.QTY - R.ACC_RTF_7 = 0 THEN
                         D.ACC_DAYS_7
                    WHEN I.QTY - R.ACC_RTF_8 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_7) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_8 = 0 THEN NULL ELSE R.RTF_NEXT_8 END, 0) * D.DAYS_NEXT_8 + D.ACC_DAYS_7
                    WHEN I.QTY - R.ACC_RTF_8 = 0 THEN
                         D.ACC_DAYS_8
                    WHEN I.QTY - R.ACC_RTF_9 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_8) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_9 = 0 THEN NULL ELSE R.RTF_NEXT_9 END, 0) * D.DAYS_NEXT_9 + D.ACC_DAYS_8
                    WHEN I.QTY - R.ACC_RTF_9 = 0 THEN
                         D.ACC_DAYS_9
                    WHEN I.QTY - R.ACC_RTF_10 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_9) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_10 = 0 THEN NULL ELSE R.RTF_NEXT_10 END, 0) * D.DAYS_NEXT_10 + D.ACC_DAYS_9
                    WHEN I.QTY - R.ACC_RTF_10 = 0 THEN
                         D.ACC_DAYS_10
                    WHEN I.QTY - R.ACC_RTF_11 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_10) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_11 = 0 THEN NULL ELSE R.RTF_NEXT_11 END, 0) * D.DAYS_NEXT_11 + D.ACC_DAYS_10
                    WHEN I.QTY - R.ACC_RTF_11 = 0 THEN
                         D.ACC_DAYS_11
                    WHEN I.QTY - R.ACC_RTF_12 < 0 THEN
                         NVL(CAST((I.QTY - R.ACC_RTF_11) AS NUMBER(20,10)) / CASE WHEN R.RTF_NEXT_12 = 0 THEN NULL ELSE R.RTF_NEXT_12 END, 0) * D.DAYS_NEXT_12 + D.ACC_DAYS_11
                    WHEN I.QTY - R.ACC_RTF_12 = 0 THEN
                         D.ACC_DAYS_12
                    ELSE 365
               END AS DIO
             , 'LV1'     AS ATTRIBUTE9
          FROM ( SELECT CELL_GROUP
                      , CELL_GROUP_YN /* --, OPERATION_GROUP */
                      , PRODUCT_LEVEL1
                      , MEASURE
                      , YYYYMM
                      , REF_NEXT_1_MONTH
                      , REF_NEXT_2_MONTH
                      , REF_NEXT_3_MONTH
                      , REF_NEXT_4_MONTH
                      , REF_NEXT_5_MONTH
                      , REF_NEXT_6_MONTH
                      , REF_NEXT_7_MONTH
                      , REF_NEXT_8_MONTH
                      , REF_NEXT_9_MONTH
                      , REF_NEXT_10_MONTH
                      , REF_NEXT_11_MONTH
                      , REF_NEXT_12_MONTH
                      , SUM(QTY) AS QTY
                   FROM GT_GPMM_BASE_DATA_FOR_DIO_DETAILREPORT
                  GROUP BY CELL_GROUP
                         , CELL_GROUP_YN /* --, OPERATION_GROUP */
                         , PRODUCT_LEVEL1
                         , MEASURE
                         , YYYYMM
                         , REF_NEXT_1_MONTH
                         , REF_NEXT_2_MONTH
                         , REF_NEXT_3_MONTH
                         , REF_NEXT_4_MONTH
                         , REF_NEXT_5_MONTH
                         , REF_NEXT_6_MONTH
                         , REF_NEXT_7_MONTH
                         , REF_NEXT_8_MONTH
                         , REF_NEXT_9_MONTH
                         , REF_NEXT_10_MONTH
                         , REF_NEXT_11_MONTH
                         , REF_NEXT_12_MONTH
               ) I /* 재고 */
             , ( SELECT 'DIO_SALES' AS MEASURE, 'SALES' AS MEASURE_GROUP FROM DUAL UNION
                 SELECT 'DIO_PACK'  AS MEASURE, 'PACK'  AS MEASURE_GROUP FROM DUAL UNION
                 SELECT 'DIO_CELL'  AS MEASURE, 'CELL'  AS MEASURE_GROUP FROM DUAL
               ) CL
             , GT_GPMM_TMP_MM_DAYS_INFO D
             , ( SELECT YYYYMM
                      , CELL_GROUP
                      , CELL_GROUP_YN /* --, OPERATION_GROUP */
                      , PRODUCT_LEVEL1
                      , MEASURE
                      , FROM_MONTH
                      , TO_MONTH
                      , SUM(RTF_QTY) AS RTF_QTY
                      , SUM(RTF_NEXT_1) AS RTF_NEXT_1
                      , SUM(RTF_NEXT_2) AS RTF_NEXT_2
                      , SUM(RTF_NEXT_3) AS RTF_NEXT_3
                      , SUM(RTF_NEXT_4) AS RTF_NEXT_4
                      , SUM(RTF_NEXT_5) AS RTF_NEXT_5
                      , SUM(RTF_NEXT_6) AS RTF_NEXT_6
                      , SUM(RTF_NEXT_7) AS RTF_NEXT_7
                      , SUM(RTF_NEXT_8) AS RTF_NEXT_8
                      , SUM(RTF_NEXT_9) AS RTF_NEXT_9
                      , SUM(RTF_NEXT_10) AS RTF_NEXT_10
                      , SUM(RTF_NEXT_11) AS RTF_NEXT_11
                      , SUM(RTF_NEXT_12) AS RTF_NEXT_12
                      , SUM(ACC_RTF_1) AS ACC_RTF_1
                      , SUM(ACC_RTF_2) AS ACC_RTF_2
                      , SUM(ACC_RTF_3) AS ACC_RTF_3
                      , SUM(ACC_RTF_4) AS ACC_RTF_4
                      , SUM(ACC_RTF_5) AS ACC_RTF_5
                      , SUM(ACC_RTF_6) AS ACC_RTF_6
                      , SUM(ACC_RTF_7) AS ACC_RTF_7
                      , SUM(ACC_RTF_8) AS ACC_RTF_8
                      , SUM(ACC_RTF_9) AS ACC_RTF_9
                      , SUM(ACC_RTF_10) AS ACC_RTF_10
                      , SUM(ACC_RTF_11) AS ACC_RTF_11
                      , SUM(ACC_RTF_12) AS ACC_RTF_12
                   FROM GT_GPMM_TMP_RTF_FOR_DIO_DETAILREPORT
                  GROUP BY YYYYMM
                         , CELL_GROUP
                         , CELL_GROUP_YN /* --, OPERATION_GROUP */
                         , PRODUCT_LEVEL1
                         , MEASURE
                         , FROM_MONTH
                         , TO_MONTH
               ) R
         WHERE CL.MEASURE_GROUP     = SUBSTR(I.MEASURE, INSTR(I.MEASURE, '_') + 1, LENGTH(RTRIM(I.MEASURE)))
           AND D.YYYYMM             = I.YYYYMM
           AND R.YYYYMM(+)          = I.YYYYMM
           AND R.CELL_GROUP(+)      = I.CELL_GROUP
           AND R.PRODUCT_LEVEL1(+)  = I.PRODUCT_LEVEL1
               /* --AND R.OPERATION_GROUP	= I.OPERATION_GROUP */
           AND SUBSTR(R.MEASURE(+), INSTR(R.MEASURE(+), '_') + 1, LENGTH(RTRIM(R.MEASURE(+)))) = SUBSTR(I.MEASURE, INSTR(I.MEASURE, '_') + 1, LENGTH(RTRIM(I.MEASURE)))
           AND I.MEASURE         LIKE 'INV%' /* 재고 */
           AND NVL(I.QTY, 0)        > 0
        ;

        /* -- PACK_DIO = PACK_DIO - SALES_DIO */
        /* ★UPDATE … FROM → MERGE : LV1 행 — 자기 행 우선 1행 */
        MERGE INTO GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT A
        USING ( SELECT XA.RID
                     , XA.DIO_RESULT
                  FROM ( SELECT T.ROWID AS RID
                              , B.DIO_RESULT
                              , ROW_NUMBER() OVER (PARTITION BY T.ROWID
                                                       ORDER BY CASE WHEN B.SRC_RID = T.ROWID THEN 0 ELSE 1 END) AS RN
                           FROM GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT T
                              , ( SELECT A.YYYYMM
                                     , A.CELL_GROUP
                                     , A.MEASURE
                                     , A.PRODUCT_LEVEL1
                                     , CASE WHEN A.MEASURE = 'DIO_PACK' THEN A.DIO - B.DIO
                                            ELSE A.DIO
                                       END AS DIO_RESULT
                                     , A.ROWID AS SRC_RID
                                  FROM GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT A
                                     , GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT B
                                 WHERE A.YYYYMM            = B.YYYYMM(+)
                                   AND A.CELL_GROUP        = B.CELL_GROUP(+)
                                   AND A.PRODUCT_LEVEL1    = B.PRODUCT_LEVEL1(+)
                                   AND B.MEASURE(+)        = 'DIO_SALES'
                                   AND B.PRODUCT_LEVEL2(+) = 'DIO'
                                   AND A.MEASURE           = 'DIO_PACK'
                                   AND A.PRODUCT_LEVEL2    = 'DIO'
                                ) B
                          WHERE T.YYYYMM         = B.YYYYMM
                            AND T.CELL_GROUP     = B.CELL_GROUP
                            AND T.PRODUCT_LEVEL1 = B.PRODUCT_LEVEL1
                            AND T.MEASURE        = B.MEASURE
                            AND T.MEASURE        = 'DIO_PACK'
                            AND T.PRODUCT_LEVEL2 = 'DIO'
                       ) XA
                 WHERE XA.RN = 1
              ) B
           ON ( A.ROWID = B.RID )
         WHEN MATCHED THEN
              UPDATE
                 SET A.DIO = CASE WHEN B.DIO_RESULT < 0 THEN 0 ELSE B.DIO_RESULT END
        ;


        /* -- CELL_DIO = CELL_DIO - PACK_DIO - SALES_DIO (LV2) */
        /* ★UPDATE … FROM → MERGE : 원문 ON 에 PRODUCT_LEVEL2·OPERATION_GROUP 이 없어 한 행에 같은 PRODUCT_LEVEL1 의 LV2 행이 모두 붙음 — 자기 행 우선 1행 */
        MERGE INTO GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT A
        USING ( SELECT XA.RID
                     , XA.DIO_RESULT
                  FROM ( SELECT T.ROWID AS RID
                              , B.DIO_RESULT
                              , ROW_NUMBER() OVER (PARTITION BY T.ROWID
                                                       ORDER BY CASE WHEN B.SRC_RID = T.ROWID THEN 0 ELSE 1 END) AS RN
                           FROM GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT T
                              , ( SELECT A.YYYYMM
                                     , A.CELL_GROUP
                                     , A.MEASURE
                                     , A.PRODUCT_LEVEL1
                                     , CASE WHEN A.MEASURE = 'DIO_CELL' THEN A.DIO - C.DIO - B.DIO
                                            ELSE A.DIO
                                       END AS DIO_RESULT
                                     , A.ROWID AS SRC_RID
                                  FROM GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT A
                                     , GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT B
                                     , GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT C
                                 WHERE A.YYYYMM            = B.YYYYMM(+)
                                   AND A.CELL_GROUP        = B.CELL_GROUP(+)
                                   AND A.PRODUCT_LEVEL1    = B.PRODUCT_LEVEL1(+)
                                   AND B.MEASURE(+)        = 'DIO_PACK'
                                   AND B.PRODUCT_LEVEL2(+) = 'DIO'
                                   AND A.YYYYMM            = C.YYYYMM(+)
                                   AND A.CELL_GROUP        = C.CELL_GROUP(+)
                                   AND A.PRODUCT_LEVEL1    = C.PRODUCT_LEVEL1(+)
                                   AND C.MEASURE(+)        = 'DIO_SALES'
                                   AND C.PRODUCT_LEVEL2(+) = 'DIO'
                                   AND A.MEASURE           = 'DIO_CELL'
                                   AND A.PRODUCT_LEVEL2   != 'DIO'
                                ) B
                          WHERE T.YYYYMM          = B.YYYYMM
                            AND T.CELL_GROUP      = B.CELL_GROUP
                            AND T.MEASURE         = B.MEASURE
                            AND T.PRODUCT_LEVEL1  = B.PRODUCT_LEVEL1
                            AND T.MEASURE         = 'DIO_CELL'
                            AND T.PRODUCT_LEVEL2 != 'DIO'
                       ) XA
                 WHERE XA.RN = 1
              ) B
           ON ( A.ROWID = B.RID )
         WHEN MATCHED THEN
              UPDATE
                 SET A.DIO = CASE WHEN B.DIO_RESULT < 0 THEN 0 ELSE B.DIO_RESULT END
        ;

        /* -- CELL_DIO = CELL_DIO - PACK_DIO - SALES_DIO (LV1) */
        /* ★UPDATE … FROM → MERGE : LV1 행 — 자기 행 우선 1행 */
        MERGE INTO GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT A
        USING ( SELECT XA.RID
                     , XA.DIO_RESULT
                  FROM ( SELECT T.ROWID AS RID
                              , B.DIO_RESULT
                              , ROW_NUMBER() OVER (PARTITION BY T.ROWID
                                                       ORDER BY CASE WHEN B.SRC_RID = T.ROWID THEN 0 ELSE 1 END) AS RN
                           FROM GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT T
                              , ( SELECT A.YYYYMM
                                     , A.CELL_GROUP
                                     , A.MEASURE
                                     , A.PRODUCT_LEVEL1
                                     , CASE WHEN A.MEASURE = 'DIO_CELL' THEN A.DIO - C.DIO - B.DIO
                                            ELSE A.DIO
                                       END AS DIO_RESULT
                                     , A.ROWID AS SRC_RID
                                  FROM GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT A
                                     , GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT B
                                     , GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT C
                                 WHERE A.YYYYMM            = B.YYYYMM(+)
                                   AND A.CELL_GROUP        = B.CELL_GROUP(+)
                                   AND A.PRODUCT_LEVEL1    = B.PRODUCT_LEVEL1(+)
                                   AND B.MEASURE(+)        = 'DIO_PACK'
                                   AND B.PRODUCT_LEVEL2(+) = 'DIO'
                                   AND A.YYYYMM            = C.YYYYMM(+)
                                   AND A.CELL_GROUP        = C.CELL_GROUP(+)
                                   AND A.PRODUCT_LEVEL1    = C.PRODUCT_LEVEL1(+)
                                   AND C.MEASURE(+)        = 'DIO_SALES'
                                   AND C.PRODUCT_LEVEL2(+) = 'DIO'
                                   AND A.MEASURE           = 'DIO_CELL'
                                   AND A.PRODUCT_LEVEL2    = 'DIO'
                                ) B
                          WHERE T.YYYYMM         = B.YYYYMM
                            AND T.CELL_GROUP     = B.CELL_GROUP
                            AND T.MEASURE        = B.MEASURE
                            AND T.PRODUCT_LEVEL1 = B.PRODUCT_LEVEL1
                            AND T.MEASURE        = 'DIO_CELL'
                            AND T.PRODUCT_LEVEL2 = 'DIO'
                       ) XA
                 WHERE XA.RN = 1
              ) B
           ON ( A.ROWID = B.RID )
         WHEN MATCHED THEN
              UPDATE
                 SET A.DIO = CASE WHEN B.DIO_RESULT < 0 THEN 0 ELSE B.DIO_RESULT END
        ;

        /* ----- End DIO 계산 =============================================================================================================================== */


        /* ----- Begin Tran : 월별 Global PSI 본테이블에 Delete/Insert======================================================================================= */
        /* BEGIN TRAN   --- transaction 시작 (Oracle 은 첫 DML 에서 트랜잭션이 암묵 시작) */

        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### DELETE FROM SCP_RPT_GLOBAL_PSI_MD_MM  ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DELETE
          FROM SCP_RPT_GLOBAL_PSI_MD_MM TGT
         WHERE TGT.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND TGT.DIVISION_ID         = V_DIVISION_ID
           AND TGT.PLAN_TYPE           = V_PLAN_TYPE /* E20260708-000926 */
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### INSERT INTO SCP_RPT_GLOBAL_PSI_MD_MM  ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_MM
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE /* E20260708-000926 */
             , YYYYMM
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
             , ATTRIBUTE10 /* Cell_Group 컬럼 값의 Cell_Group여부 20240311 */
             )
        SELECT V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID         AS DIVISION_ID
             , V_PLAN_TYPE           AS PLANT_TYPE /* E20260708-000926 */
             , GP.YYYYMM
             , CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'Y' THEN MM.MODEL_ID /* --@@@ P5200 */
                    WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'N' THEN GP.REP_CELL_ITEM_ID
                    ELSE GP.ITEM_ID
               END                   AS ITEM_ID /* 2024.01.26 AMDAU% 모듈 코드 셀로 치환 적재 */
             , CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND GP.MEASURE = 'PACK_EOH' AND MM.PACK_MODULE_ITEM = 'Y' THEN 'PACK_EOH' /* --@@@ P5200 */
                    WHEN GP.ITEM_ID LIKE 'AMDAU%' AND GP.MEASURE = 'PACK_EOH' AND MM.PACK_MODULE_ITEM = 'N' THEN 'PACK_CELL_EOH'
                    ELSE GP.MEASURE
               END                   AS MEASURE
             , GP.FROM_SITE
             , GP.TO_SITE
             , GP.INCOTERMS
             , GP.VARIOUS_KEY
             , CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND GP.MEASURE = 'PACK_EOH' AND MM.PACK_MODULE_ITEM = 'N'
                    THEN 'A'
                    ELSE GP.OPERATION_GROUP
               END                   AS OPERATION_GROUP
             , MAX(GP.REP_CELL_ITEM_ID) AS REP_CELL_ITEM_ID /* 2025.05.28 kimcd primary key 오류 처리 */
             , MAX(GP.CELL_GROUP)       AS CELL_GROUP       /* 2025.05.28 kimcd primary key 오류 처리 */
               /* --Pack Item 으로 변경되더라도 Cell 환산해 준다. */
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
             , SUM(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'Y' AND GP.MEASURE = 'PACK_EOH' THEN GP.QTY /* --@@@ P5200 */
                        WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN GP.CELL_CF * GP.QTY
                        ELSE GP.QTY
                   END)              AS QTY
             , SUM(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'Y' AND GP.MEASURE = 'PACK_EOH' THEN GP.FROM_BOH_QTY /* --@@@ P5200 */
                        WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN GP.CELL_CF * GP.FROM_BOH_QTY
                        ELSE GP.FROM_BOH_QTY
                   END)              AS FROM_BOH_QTY
             , SUM(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'Y' AND GP.MEASURE = 'PACK_EOH' THEN GP.TO_BOH_QTY /* --@@@ P5200 */
                        WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN GP.CELL_CF * GP.TO_BOH_QTY
                        ELSE GP.TO_BOH_QTY
                   END)              AS TO_BOH_QTY
             , MAX(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'Y' AND GP.MEASURE = 'PACK_EOH' THEN GP.CELL_CF
                        WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN 1
                        ELSE GP.CELL_CF
                   END)              AS CELL_CF /* 2025.05.28 kimcd primary key 오류 처리 */
             , V_BATCH_USER          AS CREATED_BY
             , SYSDATE               AS CREATION_DATE
             , V_BATCH_USER          AS LAST_UPDATED_BY
             , SYSDATE               AS LAST_UPDATE_DATE
             , MAX(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN TO_CHAR(GP.QTY, 'FM99999999999999999999999999990.0000000000')     ELSE NULL END) AS ATTRIBUTE1 /* AS-IS CONVERT(NVARCHAR(150), numeric) 소수 10자리 문자 */
             , MAX(CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN TO_CHAR(GP.CELL_CF, 'FM99999999999999999999999999990.0000000000') ELSE NULL END) AS ATTRIBUTE2
               /* --,MAX(ISNULL(MM.MODEL_ID, GP.ITEM_ID))															AS ATTRIBUTE3 */
               /* -- [PJ20257329] 변경전 ,MAX( CASE WHEN FI.FLOW_ID IN ('A9000','A3000') THEN ISNULL(FI.CELL_MODEL_ID, GP.ITEM_ID) ELSE ISNULL(MM.MODEL_ID, GP.ITEM_ID) END )	AS ATTRIBUTE3 */
             , MAX(CASE WHEN CO.OPERATION_ID IS NOT NULL THEN NVL(FI.CELL_MODEL_ID, GP.ITEM_ID) ELSE NVL(MM.MODEL_ID, GP.ITEM_ID) END) AS ATTRIBUTE3 /* [PJ20257329] Cell 완성 공정 하드 코딩 변경 */
             , MAX(GP.CELL_GROUP_YN) AS ATTRIBUTE10 /* 20240311 */
          FROM GT_GPMM_SCP_RPT_GLOBAL_PSI_MD_MM  GP
             , GT_GPMM_MODULE_MODEL_INFO         MM /* AMDAU 상위 모델 정보 */
             , GT_GPMM_SCP_MST_FINAL_ITEM        FI /* AA~ Assy item 의 Group Code Mapping 이 안되어 추가 */
               /* -- [PJ20257329] Cell 완성 공정 하드 코딩 변경 - Start */
             , GT_GPMM_SCP_CELL_FINAL_OPERATION  CO
               /* -- [PJ20257329] Cell 완성 공정 하드 코딩 변경 - End */
         WHERE MM.MODULE_ID(+)    = GP.ITEM_ID
           AND FI.ITEM_ID(+)      = GP.ITEM_ID
           AND CO.OPERATION_ID(+) = FI.FLOW_ID
               /* --AND GP.MEASURE != 'ENDING_INV_FOR_DIO' -- E20251028-000389 TOT_INV 에 미매핑 데이터 추가반영 으로 주석처리. */
         GROUP BY GP.YYYYMM
                , CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'Y' THEN MM.MODEL_ID /* --@@@ P5200 */
                       WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'N' THEN GP.REP_CELL_ITEM_ID
                       ELSE GP.ITEM_ID
                  END
                , CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND GP.MEASURE = 'PACK_EOH' AND MM.PACK_MODULE_ITEM = 'Y' THEN 'PACK_EOH' /* --@@@ P5200 */
                       WHEN GP.ITEM_ID LIKE 'AMDAU%' AND GP.MEASURE = 'PACK_EOH' AND MM.PACK_MODULE_ITEM = 'N' THEN 'PACK_CELL_EOH'
                       ELSE GP.MEASURE
                  END
                , GP.FROM_SITE
                , GP.TO_SITE
                , GP.INCOTERMS
                , GP.VARIOUS_KEY
                , CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND GP.MEASURE = 'PACK_EOH' AND MM.PACK_MODULE_ITEM = 'N'
                       THEN 'A'
                       ELSE GP.OPERATION_GROUP
                  END
                  /* --,GP.REP_CELL_ITEM_ID -- 2025.05.28 kimcd primary key 오류 처리 */
                  /* --,GP.CELL_GROUP       -- 2025.05.28 kimcd primary key 오류 처리 */
                  /* --,CASE WHEN GP.ITEM_ID LIKE 'AMDAU%' AND MM.PACK_MODULE_ITEM = 'Y' AND GP.MEASURE = 'PACK_EOH' THEN GP.CELL_CF */
                  /*	--	 WHEN GP.ITEM_ID LIKE 'AMDAU%' THEN 1 */
                  /*	--	 ELSE GP.CELL_CF */
                  /*	--END   -- 2025.05.28 kimcd primary key 오류 처리 */
        ;

        /* -- (2024.09.02 변경건) */
        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_MM
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE /* E20260708-000926 */
             , YYYYMM
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
             , ATTRIBUTE10
             )
        SELECT MM.PLAN_START_YYYYMMDD
             , MM.DIVISION_ID
             , MM.PLAN_TYPE   AS PLANT_TYPE /* E20260708-000926 */
             , MM.YYYYMM
             , MM.CELL_GROUP  AS ITEM_ID
             , 'TOT_INV'      AS MEASURE
             , '-'            AS FROM_SITE
             , '-'            AS TO_SITE
             , '-'            AS INCOTERMS
             , '-'            AS VARIOUS_KEY
             , '-'            AS OPERATION_GROUP
             , '-'            AS REP_CELL_ITEM_ID
             , MM.CELL_GROUP
             , SUM(CASE WHEN MM.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH', 'AS_INV', 'MISMATCH_INV') THEN MM.QTY * MM.CELL_CF ELSE MM.QTY END) AS QTY /* E20251028-000389 TOT_INV 형성시 MISMATCH_INV 추가 */
             , 0              AS FROM_BOH_QTY
             , 0              AS TO_BOH_QTY
             , 1.0            AS CELL_CF
             , V_BATCH_USER   AS CREATED_BY
             , SYSDATE        AS CREATION_DATE
             , V_BATCH_USER   AS LAST_UPDATED_BY
             , SYSDATE        AS LAST_UPDATE_DATE
             , 'Y'            AS ATTRIBUTE10
          FROM SCP_RPT_GLOBAL_PSI_MD_MM MM
         WHERE MM.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND MM.DIVISION_ID         = V_DIVISION_ID
           AND MM.PLAN_TYPE           = V_PLAN_TYPE /* E20260708-000926 */
               /* -- E20251028-000389 TOT_INV 에 미매핑 데이터 추가반영.(MISMATCH_INV) */
           AND MM.MEASURE IN ('TO_SITE_EOH', 'INTRANSIT', 'PACK_EOH', 'PACK_CELL_EOH', 'SEMI_INTRANSIT', 'CELL_EOH', 'CELL_CHAR_AVAILABLE', 'CELL_FORM_PROGRESS', 'AS_INV', 'MISMATCH_INV')
         GROUP BY MM.PLAN_START_YYYYMMDD
                , MM.DIVISION_ID
                , MM.PLAN_TYPE /* E20260708-000926 */
                , MM.YYYYMM
                , MM.CELL_GROUP
        ;


        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### INSERT INTO SCP_RPT_GLOBAL_PSI_MD_MM (DIO) ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_MM
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE /* E20260708-000926 */
             , YYYYMM
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
             , ATTRIBUTE10
             )
        SELECT V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID         AS DIVISION_ID
             , V_PLAN_TYPE           AS PLAN_TYPE /* E20260708-000926 */
             , DO.YYYYMM
             , DO.CELL_GROUP         AS ITEM_ID
             , 'DIO'                 AS MEASURE
             , '-'                   AS FROM_SITE
             , '-'                   AS TO_SITE
             , '-'                   AS INCOTERMS
             , '-'                   AS VARIOUS_KEY
             , DO.OPERATION_GROUP
             , '-'                   AS REP_CELL_ITEM_ID
             , DO.CELL_GROUP
             , CASE WHEN DO.DIO > 365
                    THEN 365
                    ELSE DO.DIO
               END                   AS QTY
             , 0.0                   AS FROM_BOH_QTY
             , 0.0                   AS TO_BOH_QTY
             , 1.0                   AS CELL_CF
             , V_BATCH_USER          AS CREATED_BY
             , SYSDATE               AS CREATION_DATE
             , V_BATCH_USER          AS LAST_UPDATED_BY
             , SYSDATE               AS LAST_UPDATE_DATE
             , TO_CHAR(NVL(DO.INV_QTY, 0.0), 'FM99999999999999999999999999990.000000') AS ATTRIBUTE1 /* AS-IS CONVERT(NVARCHAR(300), numeric(38,6)) 소수 6자리 문자 */
             , TO_CHAR(NVL(DO.RTF_QTY, 0.0), 'FM99999999999999999999999999990.000000') AS ATTRIBUTE2
             , TO_CHAR(NVL(DO.MM_DAYS, 0.0))         AS ATTRIBUTE3
             , DO.CELL_GROUP_YN      AS ATTRIBUTE10
          FROM GT_GPMM_TMP_INVENTORY_DIO DO
        ;

        /* -- Standard DIO 추가(임시) */
        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_MM
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE /* E20260708-000926 */
             , YYYYMM
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
             , ATTRIBUTE10
             )
        SELECT V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID         AS DIVISION_ID
             , V_PLAN_TYPE           AS PLAN_TYPE /* E20260708-000926 */
             , DO.YYYYMM
             , DO.CELL_GROUP         AS ITEM_ID
             , 'STD_DIO'             AS MEASURE
             , '-'                   AS FROM_SITE
             , '-'                   AS TO_SITE
             , '-'                   AS INCOTERMS
             , '-'                   AS VARIOUS_KEY
             , DO.OPERATION_GROUP
             , '-'                   AS REP_CELL_ITEM_ID
             , DO.CELL_GROUP
             , CASE WHEN DO.DIO > 365
                    THEN 365
                    ELSE DO.DIO
               END                   AS QTY
             , 0.0                   AS FROM_BOH_QTY
             , 0.0                   AS TO_BOH_QTY
             , 1.0                   AS CELL_CF
             , V_BATCH_USER          AS CREATED_BY
             , SYSDATE               AS CREATION_DATE
             , V_BATCH_USER          AS LAST_UPDATED_BY
             , SYSDATE               AS LAST_UPDATE_DATE
             , TO_CHAR(NVL(DO.INV_QTY, 0.0), 'FM99999999999999999999999999990.000000') AS ATTRIBUTE1 /* AS-IS CONVERT(NVARCHAR(300), numeric(38,6)) 소수 6자리 문자 */
             , TO_CHAR(NVL(DO.RTF_QTY, 0.0), 'FM99999999999999999999999999990.000000') AS ATTRIBUTE2
             , TO_CHAR(NVL(DO.MM_DAYS, 0.0))         AS ATTRIBUTE3
             , DO.CELL_GROUP_YN      AS ATTRIBUTE10
          FROM GT_GPMM_TMP_INVENTORY_DIO DO
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### INSERT INTO SCP_RPT_GLOBAL_PSI_MD_MM (DIO) (표준레포트) '); /* 고도화 */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_MM
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE /* E20260708-000926 */
             , YYYYMM
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
             , ATTRIBUTE10
             )
        SELECT V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID         AS DIVISION_ID
             , V_PLAN_TYPE           AS PLAN_TYPE /* E20260708-000926 */
             , DO.YYYYMM
             , DO.CELL_GROUP         AS ITEM_ID
             , DO.MEASURE            AS MEASURE
             , '-'                   AS FROM_SITE
             , '-'                   AS TO_SITE
             , '-'                   AS INCOTERMS
             , '-'                   AS VARIOUS_KEY
             , DO.OPERATION_GROUP
             , '-'                   AS REP_CELL_ITEM_ID
             , DO.CELL_GROUP
             , CASE WHEN DO.DIO > 365
                    THEN 365
                    ELSE DO.DIO
               END                   AS QTY
             , 0.0                   AS FROM_BOH_QTY
             , 0.0                   AS TO_BOH_QTY
             , 1.0                   AS CELL_CF
             , V_BATCH_USER          AS CREATED_BY
             , SYSDATE               AS CREATION_DATE
             , V_BATCH_USER          AS LAST_UPDATED_BY
             , SYSDATE               AS LAST_UPDATE_DATE
             , TO_CHAR(NVL(DO.INV_QTY, 0.0), 'FM99999999999999999999999999990.000000') AS ATTRIBUTE1 /* AS-IS CONVERT(NVARCHAR(300), numeric(38,6)) 소수 6자리 문자 */
             , TO_CHAR(NVL(DO.RTF_QTY, 0.0), 'FM99999999999999999999999999990.000000') AS ATTRIBUTE2
             , TO_CHAR(NVL(DO.MM_DAYS, 0.0))         AS ATTRIBUTE3
             , DO.CELL_GROUP_YN      AS ATTRIBUTE10
          FROM GT_GPMM_TMP_INVENTORY_DIO_CELLGROUP DO
        ;

        /* -- Standard DIO 추가(임시) */
        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_MM
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE /* E20260708-000926 */
             , YYYYMM
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
             , ATTRIBUTE10
             )
        SELECT V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID         AS DIVISION_ID
             , V_PLAN_TYPE           AS PLAN_TYPE /* E20260708-000926 */
             , DO.YYYYMM
             , DO.CELL_GROUP         AS ITEM_ID
             , 'STD_' || DO.MEASURE  AS MEASURE
             , '-'                   AS FROM_SITE
             , '-'                   AS TO_SITE
             , '-'                   AS INCOTERMS
             , '-'                   AS VARIOUS_KEY
             , DO.OPERATION_GROUP
             , '-'                   AS REP_CELL_ITEM_ID
             , DO.CELL_GROUP
             , CASE WHEN DO.DIO > 365
                    THEN 365
                    ELSE DO.DIO
               END                   AS QTY
             , 0.0                   AS FROM_BOH_QTY
             , 0.0                   AS TO_BOH_QTY
             , 1.0                   AS CELL_CF
             , V_BATCH_USER          AS CREATED_BY
             , SYSDATE               AS CREATION_DATE
             , V_BATCH_USER          AS LAST_UPDATED_BY
             , SYSDATE               AS LAST_UPDATE_DATE
             , TO_CHAR(NVL(DO.INV_QTY, 0.0), 'FM99999999999999999999999999990.000000') AS ATTRIBUTE1 /* AS-IS CONVERT(NVARCHAR(300), numeric(38,6)) 소수 6자리 문자 */
             , TO_CHAR(NVL(DO.RTF_QTY, 0.0), 'FM99999999999999999999999999990.000000') AS ATTRIBUTE2
             , TO_CHAR(NVL(DO.MM_DAYS, 0.0))         AS ATTRIBUTE3
             , DO.CELL_GROUP_YN      AS ATTRIBUTE10
          FROM GT_GPMM_TMP_INVENTORY_DIO_CELLGROUP DO
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### INSERT INTO SCP_RPT_GLOBAL_PSI_MD_DETAIL_MM (DIO) (Detail 표준레포트) '); /* 고도화 */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */

        DELETE
          FROM SCP_RPT_GLOBAL_PSI_MD_DETAIL_MM TGT
         WHERE TGT.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND TGT.DIVISION_ID         = V_DIVISION_ID
           AND TGT.PLAN_TYPE           = V_PLAN_TYPE /* E20260708-000926 */
        ;

        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_DETAIL_MM
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE /* E20260708-000926 */
             , YYYYMM
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
             , ATTRIBUTE9
             )
        SELECT V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID         AS DIVISION_ID
             , V_PLAN_TYPE           AS PLAN_TYPE /* E20260708-000926 */
             , DO.YYYYMM
             , DO.CELL_GROUP         AS ITEM_ID
             , DO.MEASURE            AS MEASURE
             , '-'                   AS FROM_SITE
             , '-'                   AS TO_SITE
             , '-'                   AS INCOTERMS
             , '-'                   AS VARIOUS_KEY
             , CASE WHEN ATTRIBUTE9 = 'LV1' THEN ( CASE WHEN REPLACE(DO.MEASURE, 'DIO_', '') = 'SALES' THEN 'Sales' || ' DIO'
                                                        WHEN REPLACE(DO.MEASURE, 'DIO_', '') = 'PACK'  THEN 'Pack' || ' DIO'
                                                        WHEN REPLACE(DO.MEASURE, 'DIO_', '') = 'CELL'  THEN 'Cell' || ' DIO' END )
                    ELSE DO.OPERATION_GROUP
               END                   AS OPERATION_GROUP
             , '-'                   AS REP_CELL_ITEM_ID
             , DO.CELL_GROUP
             , DO.PRODUCT_LEVEL1
             , DO.PRODUCT_LEVEL2
             , '-'                   AS PRODUCT_LEVEL3
             , CASE WHEN NVL(DO.DIO, 0) > 365
                    THEN 365
                    ELSE NVL(DO.DIO, 0)
               END                   AS QTY
             , 0.0                   AS FROM_BOH_QTY
             , 0.0                   AS TO_BOH_QTY
             , 1.0                   AS CELL_CF
             , V_BATCH_USER          AS CREATED_BY
             , SYSDATE               AS CREATION_DATE
             , V_BATCH_USER          AS LAST_UPDATED_BY
             , SYSDATE               AS LAST_UPDATE_DATE
             , TO_CHAR(NVL(DO.INV_QTY, 0.0), 'FM99999999999999999999999999990.000000') AS ATTRIBUTE1 /* AS-IS CONVERT(NVARCHAR(300), numeric(38,6)) 소수 6자리 문자 */
             , TO_CHAR(NVL(DO.RTF_QTY, 0.0), 'FM99999999999999999999999999990.000000') AS ATTRIBUTE2
             , TO_CHAR(NVL(DO.MM_DAYS, 0.0))         AS ATTRIBUTE3
             , DO.CELL_GROUP_YN      AS ATTRIBUTE10
             , ATTRIBUTE9
          FROM GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT DO
         WHERE DO.PRODUCT_LEVEL1 <> '-'
               /* -- AND DO.PRODUCT_LEVEL2 != 'DIO' */
        ;

        /* -- Standard DIO 추가(임시) */
        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_DETAIL_MM
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE /* E20260708-000926 */
             , YYYYMM
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
             , ATTRIBUTE9
             )
        SELECT V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID         AS DIVISION_ID
             , V_PLAN_TYPE           AS PLAN_TYPE /* E20260708-000926 */
             , DO.YYYYMM
             , DO.CELL_GROUP         AS ITEM_ID
             , 'STD_' || DO.MEASURE  AS MEASURE
             , '-'                   AS FROM_SITE
             , '-'                   AS TO_SITE
             , '-'                   AS INCOTERMS
             , '-'                   AS VARIOUS_KEY
             , CASE WHEN ATTRIBUTE9 = 'LV1' THEN ( CASE WHEN REPLACE(DO.MEASURE, 'DIO_', '') = 'SALES' THEN 'Saels' || ' DIO'
                                                        WHEN REPLACE(DO.MEASURE, 'DIO_', '') = 'PACK'  THEN 'Pack' || ' DIO'
                                                        WHEN REPLACE(DO.MEASURE, 'DIO_', '') = 'CELL'  THEN 'Cell' || ' DIO' END )
                    ELSE DO.OPERATION_GROUP
               END                   AS OPERATION_GROUP
             , '-'                   AS REP_CELL_ITEM_ID
             , DO.CELL_GROUP
             , DO.PRODUCT_LEVEL1
             , DO.PRODUCT_LEVEL2
             , '-'                   AS PRODUCT_LEVEL3
             , CASE WHEN NVL(DO.DIO, 0) > 365
                    THEN 365
                    ELSE NVL(DO.DIO, 0)
               END                   AS QTY
             , 0.0                   AS FROM_BOH_QTY
             , 0.0                   AS TO_BOH_QTY
             , 1.0                   AS CELL_CF
             , V_BATCH_USER          AS CREATED_BY
             , SYSDATE               AS CREATION_DATE
             , V_BATCH_USER          AS LAST_UPDATED_BY
             , SYSDATE               AS LAST_UPDATE_DATE
             , TO_CHAR(NVL(DO.INV_QTY, 0.0), 'FM99999999999999999999999999990.000000') AS ATTRIBUTE1 /* AS-IS CONVERT(NVARCHAR(300), numeric(38,6)) 소수 6자리 문자 */
             , TO_CHAR(NVL(DO.RTF_QTY, 0.0), 'FM99999999999999999999999999990.000000') AS ATTRIBUTE2
             , TO_CHAR(NVL(DO.MM_DAYS, 0.0))         AS ATTRIBUTE3
             , DO.CELL_GROUP_YN      AS ATTRIBUTE10
             , ATTRIBUTE9
          FROM GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT DO
         WHERE DO.PRODUCT_LEVEL1 <> '-'
        ;

        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### INSERT INTO SCP_RPT_GLOBAL_PSI_MD_MM (FP Aging Stock : Form Progress ) ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO SCP_RPT_GLOBAL_PSI_MD_MM
             ( PLAN_START_YYYYMMDD
             , DIVISION_ID
             , PLAN_TYPE /* E20260708-000926 */
             , YYYYMM
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
             )
        SELECT '00000000'                                AS PLAN_START_YYYYMMDD
             , V_DIVISION_ID                             AS DIVISION_ID
             , 'FN'                                      AS PLAN_TYPE /* E20260708-000926 FN 고정 */
             , SA.YYYYMM
             , SA.ITEM_ID
             , 'FORM_PROGRESS'                           AS MEASURE
             , SA.FROM_SITE
             , '-'                                       AS TO_SITE
             , '-'                                       AS INCOTERMS
             , TO_CHAR(SA.CUTOFF_DATE, 'YYYYMMDD')       AS VARIOUS_KEY
             , '-'                                       AS OPERATION_GROUP
             , '-'                                       AS REP_CELL_ITEM_ID
             , '-'                                       AS CELL_GROUP
             , SA.FP_FORM_PROGRESS                       AS QTY
             , 0                                         AS FROM_BOH_QTY
             , 0                                         AS TO_BOH_QTY
             , 0                                         AS CELL_CF
             , 'scm_batch'                               AS CREATED_BY
             , SYSDATE                                   AS CREATION_DATE
             , 'scm_batch'                               AS LAST_UPDATED_BY
             , SYSDATE                                   AS LAST_UPDATE_DATE
             , TO_CHAR(SA.FP_CHAR_AVAILABLE, 'FM99999999999999999999999999990.0000000000') AS ATTRIBUTE1 /* AS-IS CONVERT(NVARCHAR(50), numeric) 소수 10자리 문자 */
             , TO_CHAR(SA.FP_AGING_TOTAL, 'FM99999999999999999999999999990.0000000000')    AS ATTRIBUTE2
          FROM GT_GPMM_FP_AGING_STOCK SA
         WHERE SA.DIV = 'A'
           AND NOT EXISTS ( SELECT 1 /* SELECT TOP 10 * */
                              FROM SCP_RPT_GLOBAL_PSI_MD_MM GP
                             WHERE GP.YYYYMM              = SA.YYYYMM
                               AND GP.FROM_SITE           = SA.FROM_SITE
                               AND GP.ITEM_ID             = SA.ITEM_ID
                               AND GP.PLAN_START_YYYYMMDD = '00000000'
                               AND GP.PLAN_TYPE           = 'FN' /* E20260708-000926 실적이여서 FN 으로 고정 */
                               AND GP.MEASURE             = 'FORM_PROGRESS'
                               AND GP.DIVISION_ID         = V_DIVISION_ID
                          )
        ;

        /* -- (2024.09.02 변경건) */
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ### 재고 별 우선순위 설정 ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------- */

        UPDATE SCP_RPT_GLOBAL_PSI_MD_MM
           SET ATTRIBUTE8 = NULL
         WHERE PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND DIVISION_ID         = V_DIVISION_ID
           AND PLAN_TYPE           = V_PLAN_TYPE /* E20260708-000926 */
        ;

        UPDATE SCP_RPT_GLOBAL_PSI_MD_DETAIL_MM
           SET ATTRIBUTE8 = NULL
         WHERE PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND DIVISION_ID         = V_DIVISION_ID
           AND PLAN_TYPE           = V_PLAN_TYPE /* E20260708-000926 */
        ;

        /* -- ORDER BY 추가 */
        /* ★UPDATE … FROM → MERGE (원천은 CELL_GROUP 당 1행) */
        MERGE INTO SCP_RPT_GLOBAL_PSI_MD_MM A
        USING ( SELECT DENSE_RANK() OVER (PARTITION BY PLAN_START_YYYYMMDD
                                                  , DIVISION_ID
                                                  , PLAN_TYPE /* E20260708-000926 */
                                           ORDER BY SUM_QTY DESC
                                                  , CELL_GROUP) AS RNK
                     , PLAN_START_YYYYMMDD
                     , DIVISION_ID
                     , PLAN_TYPE /* E20260708-000926 */
                     , CELL_GROUP
                  FROM ( SELECT MM.PLAN_START_YYYYMMDD
                              , MM.DIVISION_ID
                              , MM.PLAN_TYPE /* E20260708-000926 */
                              , MM.CELL_GROUP
                              , SUM(MM.QTY) AS SUM_QTY
                           FROM SCP_RPT_GLOBAL_PSI_MD_MM MM
                          WHERE MM.MEASURE             = 'TOT_INV'
                            AND MM.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                            AND MM.DIVISION_ID         = V_DIVISION_ID
                            AND MM.PLAN_TYPE           = V_PLAN_TYPE /* E20260708-000926 */
                            AND MM.YYYYMM              = V_RESULT_LAST_YYYYMM
                          GROUP BY MM.PLAN_START_YYYYMMDD
                                 , MM.DIVISION_ID
                                 , MM.PLAN_TYPE /* E20260708-000926 */
                                 , MM.CELL_GROUP
                          UNION ALL
                         SELECT DISTINCT
                                MM.PLAN_START_YYYYMMDD
                              , MM.DIVISION_ID
                              , MM.PLAN_TYPE /* E20260708-000926 */
                              , MM.CELL_GROUP
                              , 0 AS SUM_QTY
                           FROM SCP_RPT_GLOBAL_PSI_MD_MM MM
                          WHERE NOT EXISTS ( SELECT 1 /* SELECT DISTINCT DIVISION_ID, CELL_GROUP */
                                               FROM SCP_RPT_GLOBAL_PSI_MD_MM XX
                                              WHERE XX.DIVISION_ID         = MM.DIVISION_ID
                                                AND XX.CELL_GROUP          = MM.CELL_GROUP
                                                AND XX.MEASURE             = 'TOT_INV'
                                                AND XX.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                AND XX.DIVISION_ID         = V_DIVISION_ID
                                                AND XX.PLAN_TYPE           = V_PLAN_TYPE /* E20260708-000926 */
                                                AND XX.YYYYMM              = V_RESULT_LAST_YYYYMM
                                           )
                            AND MM.MEASURE             = 'TOT_INV'
                            AND MM.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                            AND MM.DIVISION_ID         = V_DIVISION_ID
                            AND MM.PLAN_TYPE           = V_PLAN_TYPE /* E20260708-000926 */
                       ) B
              ) B
           ON (     A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                AND A.DIVISION_ID         = B.DIVISION_ID
                AND A.PLAN_TYPE           = B.PLAN_TYPE /* E20260708-000926 */
                AND A.CELL_GROUP          = B.CELL_GROUP
              )
         WHEN MATCHED THEN
              UPDATE
                 SET A.ATTRIBUTE8 = TO_CHAR(B.RNK)
        ;

        /* -- ORDER BY 추가 */
        /* ★UPDATE … FROM → MERGE (원천은 CELL_GROUP 당 1행) */
        MERGE INTO SCP_RPT_GLOBAL_PSI_MD_DETAIL_MM A
        USING ( SELECT DENSE_RANK() OVER (PARTITION BY PLAN_START_YYYYMMDD
                                                  , DIVISION_ID
                                                  , PLAN_TYPE /* E20260708-000926 */
                                           ORDER BY SUM_QTY DESC
                                                  , CELL_GROUP) AS RNK
                     , PLAN_START_YYYYMMDD
                     , DIVISION_ID
                     , PLAN_TYPE /* E20260708-000926 */
                     , CELL_GROUP
                  FROM ( SELECT MM.PLAN_START_YYYYMMDD
                              , MM.DIVISION_ID
                              , MM.PLAN_TYPE /* E20260708-000926 */
                              , MM.CELL_GROUP
                              , SUM(MM.QTY) AS SUM_QTY
                           FROM SCP_RPT_GLOBAL_PSI_MD_MM MM
                          WHERE MM.MEASURE             = 'TOT_INV'
                            AND MM.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                            AND MM.DIVISION_ID         = V_DIVISION_ID
                            AND MM.PLAN_TYPE           = V_PLAN_TYPE /* E20260708-000926 */
                            AND MM.YYYYMM              = V_RESULT_LAST_YYYYMM
                          GROUP BY MM.PLAN_START_YYYYMMDD
                                 , MM.DIVISION_ID
                                 , MM.PLAN_TYPE /* E20260708-000926 */
                                 , MM.CELL_GROUP
                          UNION ALL
                         SELECT DISTINCT
                                MM.PLAN_START_YYYYMMDD
                              , MM.DIVISION_ID
                              , MM.PLAN_TYPE /* E20260708-000926 */
                              , MM.CELL_GROUP
                              , 0 AS SUM_QTY
                           FROM SCP_RPT_GLOBAL_PSI_MD_MM MM
                          WHERE NOT EXISTS ( SELECT 1 /* SELECT DISTINCT DIVISION_ID, CELL_GROUP */
                                               FROM SCP_RPT_GLOBAL_PSI_MD_MM XX
                                              WHERE XX.DIVISION_ID         = MM.DIVISION_ID
                                                AND XX.CELL_GROUP          = MM.CELL_GROUP
                                                AND XX.MEASURE             = 'TOT_INV'
                                                AND XX.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                AND XX.DIVISION_ID         = V_DIVISION_ID
                                                AND XX.PLAN_TYPE           = V_PLAN_TYPE /* E20260708-000926 */
                                                AND XX.YYYYMM              = V_RESULT_LAST_YYYYMM
                                           )
                            AND MM.MEASURE             = 'TOT_INV'
                            AND MM.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                            AND MM.DIVISION_ID         = V_DIVISION_ID
                            AND MM.PLAN_TYPE           = V_PLAN_TYPE /* E20260708-000926 */
                       ) B
              ) B
           ON (     A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                AND A.DIVISION_ID         = B.DIVISION_ID
                AND A.PLAN_TYPE           = B.PLAN_TYPE /* E20260708-000926 */
                AND A.CELL_GROUP          = B.CELL_GROUP
              )
         WHEN MATCHED THEN
              UPDATE
                 SET A.ATTRIBUTE8 = TO_CHAR(B.RNK)
        ;


        DECLARE
            V_INV_SEQ  PLS_INTEGER := 0;
        BEGIN

            SELECT MAX(TO_NUMBER(MM.ATTRIBUTE8))
              INTO V_INV_SEQ
              FROM SCP_RPT_GLOBAL_PSI_MD_MM MM
             WHERE MM.MEASURE             = 'TOT_INV'
               AND MM.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND MM.DIVISION_ID         = V_DIVISION_ID
               AND MM.PLAN_TYPE           = V_PLAN_TYPE /* E20260708-000926 */
            ;

            /* -- ORDER BY 추가 */
            /* ★UPDATE … FROM → MERGE (원천은 CELL_GROUP 당 1행) */
            MERGE INTO SCP_RPT_GLOBAL_PSI_MD_MM A
            USING ( SELECT DENSE_RANK() OVER (PARTITION BY PLAN_START_YYYYMMDD
                                                      , DIVISION_ID
                                                      , PLAN_TYPE /* E20260708-000926 */
                                               ORDER BY SUM_QTY DESC
                                                      , CELL_GROUP) AS RNK
                         , PLAN_START_YYYYMMDD
                         , DIVISION_ID
                         , PLAN_TYPE /* E20260708-000926 */
                         , CELL_GROUP
                      FROM ( SELECT MM.PLAN_START_YYYYMMDD
                                  , MM.DIVISION_ID
                                  , MM.PLAN_TYPE /* E20260708-000926 */
                                  , MM.CELL_GROUP
                                  , SUM(MM.QTY) AS SUM_QTY
                               FROM SCP_RPT_GLOBAL_PSI_MD_MM MM
                              WHERE MM.MEASURE             = 'TOT_INV'
                                AND MM.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                AND MM.DIVISION_ID         = V_DIVISION_ID
                                AND MM.PLAN_TYPE           = V_PLAN_TYPE /* E20260708-000926 */
                                    /* --AND	MM.YYYYMM 				= @V_RESULT_LAST_YYYYMM */
                                AND MM.ATTRIBUTE8 IS NULL
                              GROUP BY MM.PLAN_START_YYYYMMDD
                                     , MM.DIVISION_ID
                                     , MM.PLAN_TYPE /* E20260708-000926 */
                                     , MM.CELL_GROUP
                           ) B
                  ) B
               ON (     A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                    AND A.DIVISION_ID         = B.DIVISION_ID
                    AND A.PLAN_TYPE           = B.PLAN_TYPE /* E20260708-000926 */
                    AND A.CELL_GROUP          = B.CELL_GROUP
                  )
             WHEN MATCHED THEN
                  UPDATE
                     SET A.ATTRIBUTE8 = TO_CHAR(NVL(B.RNK + NVL(V_INV_SEQ, 0), 99))
                   WHERE A.ATTRIBUTE8 IS NULL /* 원문 ON 의 A.ATTRIBUTE8 IS NULL — MERGE ON 에는 갱신 칸을 쓸 수 없어 UPDATE WHERE 로 */
            ;

            /* -- ORDER BY 추가 */
            /* ★UPDATE … FROM → MERGE (원천은 CELL_GROUP 당 1행) */
            MERGE INTO SCP_RPT_GLOBAL_PSI_MD_DETAIL_MM A
            USING ( SELECT DENSE_RANK() OVER (PARTITION BY PLAN_START_YYYYMMDD
                                                      , DIVISION_ID
                                                      , PLAN_TYPE /* E20260708-000926 */
                                               ORDER BY SUM_QTY DESC
                                                      , CELL_GROUP) AS RNK
                         , PLAN_START_YYYYMMDD
                         , DIVISION_ID
                         , PLAN_TYPE /* E20260708-000926 */
                         , CELL_GROUP
                      FROM ( SELECT MM.PLAN_START_YYYYMMDD
                                  , MM.DIVISION_ID
                                  , MM.PLAN_TYPE /* E20260708-000926 */
                                  , MM.CELL_GROUP
                                  , SUM(MM.QTY) AS SUM_QTY
                               FROM SCP_RPT_GLOBAL_PSI_MD_MM MM
                              WHERE MM.MEASURE             = 'TOT_INV'
                                AND MM.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                AND MM.DIVISION_ID         = V_DIVISION_ID
                                AND MM.PLAN_TYPE           = V_PLAN_TYPE /* E20260708-000926 */
                                    /* --AND	MM.YYYYMM 				= @V_RESULT_LAST_YYYYMM */
                                AND MM.ATTRIBUTE8 IS NULL
                              GROUP BY MM.PLAN_START_YYYYMMDD
                                     , MM.DIVISION_ID
                                     , MM.PLAN_TYPE /* E20260708-000926 */
                                     , MM.CELL_GROUP
                           ) B
                  ) B
               ON (     A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                    AND A.DIVISION_ID         = B.DIVISION_ID
                    AND A.PLAN_TYPE           = B.PLAN_TYPE /* E20260708-000926 */
                    AND A.CELL_GROUP          = B.CELL_GROUP
                  )
             WHEN MATCHED THEN
                  UPDATE
                     SET A.ATTRIBUTE8 = TO_CHAR(NVL(B.RNK + NVL(V_INV_SEQ, 0), 99))
                   WHERE A.ATTRIBUTE8 IS NULL /* 원문 ON 의 A.ATTRIBUTE8 IS NULL — MERGE ON 에는 갱신 칸을 쓸 수 없어 UPDATE WHERE 로 */
            ;

        END;


        COMMIT; /* COMMIT TRAN ;  --- transaction 종료 */
        /* ----- End Tran : 월별 Global PSI 본테이블에 Delete/Insert========================================================================================================== */

        /* --------------------------------------- */
        /* -- 임시테이블 정리 */
        /* --------------------------------------- */
        DELETE FROM GT_GPMM_TMP_RTF_FOR_DIO;
        DELETE FROM GT_GPMM_BASE_DATA_FOR_DIO;
        DELETE FROM GT_GPMM_TMP_MM_DAYS_INFO;
        DELETE FROM GT_GPMM_GAP_RTF_MKT_FCST;
        DELETE FROM GT_GPMM_SCP_RPT_GLOBAL_PSI_MD_MM;
        DELETE FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI_WITH_REP_CELL_INFO;
        DELETE FROM GT_GPMM_ETC_CP_CELL_INFO;
        DELETE FROM GT_GPMM_MODULE_MODEL_INFO;
        DELETE FROM GT_GPMM_CP_CELL_ITEM_INFO;
        DELETE FROM GT_GPMM_PAST_FORM_PROGRESS_CHAR_AVAILABLE;
        DELETE FROM GT_GPMM_FP_AGING_STOCK;
        DELETE FROM GT_GPMM_TMP_ENDING_INV_MM;
        DELETE FROM GT_GPMM_TMP_ENDING_INV_MM_RAW;
        DELETE FROM GT_GPMM_TMP_SLOC_ADD_INFO;
        DELETE FROM GT_GPMM_TMP_TARGET_ITEM_FOR_ENDING_INV;
        DELETE FROM GT_GPMM_TMP_TOBE_GLOBAL_PSI;
        DELETE FROM GT_GPMM_WH_IN_SEMI_RESULT;
        DELETE FROM GT_GPMM_SHIPMENT_RESULT;
        DELETE FROM GT_GPMM_PRODUCTION_RESULT;
        DELETE FROM GT_GPMM_PRODUCTION_OPERATION;
        DELETE FROM GT_GPMM_INTRANSIT;
        DELETE FROM GT_GPMM_INTRANSIT_BOH;
        DELETE FROM GT_GPMM_FCST_RTF_RESULT;
        DELETE FROM GT_GPMM_WH_IN_RTF;
        DELETE FROM GT_GPMM_SALES_SITE_BOH;
        DELETE FROM GT_GPMM_CELL_PROD;
        DELETE FROM GT_GPMM_FORM_PROGRESS_FROM_BOH;
        DELETE FROM GT_GPMM_CELL_CHAR_PLAN_YIELD;
        DELETE FROM GT_GPMM_CELL_SHIP_PLAN_TOTAL;
        /* DELETE FROM GT_GPMM_CELL_FORM_HOLD_AFTER; : 원문에서 #CELL_FORM_HOLD_AFTER 생성 구문이 주석 처리되어 GTT 미생성 */
        DELETE FROM GT_GPMM_CELL_BOH_FOR_FUTURE;
        DELETE FROM GT_GPMM_CELL_CHAR_PLAN_FUTURE;
        DELETE FROM GT_GPMM_CELL_FOR_FORM_END;
        DELETE FROM GT_GPMM_FOR_FORM_END_MONTHLY;
        DELETE FROM GT_GPMM_FOR_FORM_END_DAILY;
        DELETE FROM GT_GPMM_CELL_PROD_FORM_END_LINE;
        DELETE FROM GT_GPMM_CELL_PROD_FORM_END;
        DELETE FROM GT_GPMM_CELL_PROD_FORM_END_RAW;
        DELETE FROM GT_GPMM_TMP_ASIS_GLOBAL_PSI;
        DELETE FROM GT_GPMM_SCP_ANL_PSI_GLOBAL;
        DELETE FROM GT_GPMM_CELL_PROD_ASSY_MAP;
        DELETE FROM GT_GPMM_SCP_PLN_TH_ENG_STOCK_PLAN;
        DELETE FROM GT_GPMM_SCP_MST_ITEM_CELL_CF;
        DELETE FROM GT_GPMM_SCP_MST_FINAL_ITEM;
        DELETE FROM GT_GPMM_SCM_MST_SITE;
        DELETE FROM GT_GPMM_SCP_MST_FORMATION;
        DELETE FROM GT_GPMM_TMP_MM_LIST;
        DELETE FROM GT_GPMM_TMP_DATE_INFO;
        DELETE FROM GT_GPMM_BASE_DATA_FOR_DIO_CELLGROUP;
        DELETE FROM GT_GPMM_TMP_RTF_FOR_DIO_CELLGROUP;
        DELETE FROM GT_GPMM_TMP_INVENTORY_DIO_CELLGROUP;
        DELETE FROM GT_GPMM_BASE_DATA_FOR_DIO_DETAILREPORT;
        DELETE FROM GT_GPMM_TMP_RTF_FOR_DIO_DETAILREPORT;
        DELETE FROM GT_GPMM_TMP_INVENTORY_DIO_DETAILREPORT;
        DELETE FROM GT_GPMM_SHIPTO_CODE;
        /* -- 2025.05.28   kimcd GLOBAL PSI NEW - AS 대상 SALES_TYPE_CODE 임시 정보 삭제 */
        DELETE FROM GT_GPMM_TMP_AS_SALES_TYPE_CODE;
        /* -- Start : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
        DELETE FROM GT_GPMM_SCP_EXC_ITEM_ASSY_MAP;
        /* -- End : PJ20257329 2025.09.01 SCP Exclude Class 품목을 Cell Assy로 변환 참조 */
        /* 원문은 정리 후 끝나지만 Oracle 은 DELETE 도 트랜잭션이므로 GTT 정리분 확정 */
        COMMIT;


    /* END TRY */
    EXCEPTION
        WHEN OTHERS THEN
            /* BEGIN CATCH : if (xact_state() <> 0) ROLLBACK TRAN; */
            ROLLBACK;

            /* ERROR LOG */
            V_SQL_ERR_CODE  := TO_CHAR(SQLCODE);
            V_SQL_ERR_MSG   := SUBSTR(SQLERRM, 1, 2000);
            V_SQL_BACKTRACE := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
            V_IN_PARA_DATA  := JSON_OBJECT( 'P_DIVISION_ID'         VALUE P_DIVISION_ID
                                          , 'P_PLAN_START_YYYYMMDD' VALUE P_PLAN_START_YYYYMMDD
                                          , 'P_PLAN_TYPE'           VALUE P_PLAN_TYPE
                                            RETURNING VARCHAR2(4000));
            V_LOG_TYPE      := 'ERROR';
            V_LOG_MESSAGE   := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION   := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE    := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER
                                , V_IN_PARA_DATA, V_SQL_ERR_CODE, V_SQL_ERR_MSG, V_SQL_BACKTRACE);
            DBMS_OUTPUT.PUT_LINE(V_LOG_MESSAGE || ' : ' || V_DESCRIPTION);
            RETURN;  /* RETURN -1; */
    END;  /* END CATCH */

    N_EXEC_SEC   := TRUNC((SYSDATE - V_START_TIME) * 86400);
    V_EXEC_TIME  := LPAD(TO_CHAR(TRUNC(N_EXEC_SEC / 60)), GREATEST(2, LENGTH(TO_CHAR(TRUNC(N_EXEC_SEC / 60)))), '0') || ':'
                 || LPAD(TO_CHAR(MOD(N_EXEC_SEC, 60)), 2, '0');
    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '##### END of procedure #####';
    V_DESCRIPTION := '[' || V_DIVISION_ID || '::' || V_PLAN_START_YYYYMMDD || '::' || V_ENG_PLAN_ID || '][' || V_EXEC_TIME || ']';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);
    DBMS_OUTPUT.PUT_LINE(V_LOG_MESSAGE || ' : ' || V_DESCRIPTION);

END PR_SCP_RPT_GLOBAL_PSI_MD_MM;