
/*========================================================================================================================
 * Program ID   : DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL
 * Description  : SALES PLAN SAVE 버튼 클릭시 실행 프로시져 ('DM_PLN_SALES_PLAN' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *========================================================================================================================
 *   Date       In Charge      Description
 *========================================================================================================================
 * 2018.03.12   KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.14	KHSOMG		40 DIVISION 조건 추가
 * 2021.05.13	P.C.I		[PJ20209642R] DM_MST_EXCHANGE_RATE_C에 CURRENCY = 'KRW' 조건 추가
 * 2021.08.31	hwi1993		[C20210830-000508] [ESS영업관리팀] GSCM Sales Plan창 입력 가능 최대값 수정 요청의 건
 * 2021.11.03	ROSIA27		[PJ20209643] SALES PLAN속도 개선
 * 2021.11.03	ROSIA27		[PJ20209643] SALES PLAN속도 개선. 323라인 DELETE 구문 변경
 * 2021.12.22	rosia27		[C20211220-000276]Sales Plan, Sales Monitoring - 색상 수정 필요
 * 2024.04.04   KCW3408     Sales Plan 관련 자동사업부 기타 매출 추가(속도개선)
 * 2024.04.16   KCW3408     이동계획 기타매출 추가 요건(TEXT추가)
 * 2024.11.05	KJJ			[PJ2024-50611] 소형사업부 Sales Plan 기타매출 입력 추가
 * 2024.11.27	KJJ			[PJ2024-50611] 소형사업부 Sales Plan Catch Up 입력 추가
 * 2024.12.12	KJJ			[PJ2024-50611] 기타매출, Catch Up 테이블 분리
 * 2025.02.13	JSSBAE		[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청
 * 2025.03.12   dsiol		[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
 * 2025.04.04   JSSBAE		[E20250401-000548] SMS 선감지 대상 정리
 * 2025.05.07   dsiol	    [PJ2025-50017] 프로젝트와 관련한 각종 주석 추가 작성 및 #TEMP_SALES_PLAN_A , #TEMP_SALES_PLAN_B 임시테이블 명칭을 각각 #TEMP_SALES_PLAN_SalesAmt_LOC, #TEMP_SALES_PLAN_RTF_SYS_RP로 변경
 * 2025.05.20   JSSBAE	    [E20250520-000572]_Sales Plan 데이터 Validation 로직 변경
 * 2025.06.02   KANG.H.J	[PJ2025-50188] SALES_PLAN 추가 및 수정시 ATTRIBUTE2(FROM_SITE_ID) 데이터 생성 - BPS 전송시 누락케이스 방지
 * 2025.06.12   KANG.H.J	[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리 (#TEMP_SALES_PLAN / #TEMP_SALES_PLAN_SalesAmt_LOC / #TEMP_SALES_PLAN_RTF_SYS_RP)
 * 2025.06.20   JSSBAE	    [E20250520-000605]_[영업.마케팅PI] Sales Plan - ETC Data 'Monthly' 입력 Bucket 기능 수정 요청
 * 2025.10.03	JSSBAE		[E20250919-001699]_N-ERP 3차 Roll-in 관련 DM Incoterms 전환 대응 건
 * 2025.11.17	JSSBAE		[E20251027-000091]_Sales Plan UI RTF 간편조정 시 RTF_SYS_RP, RTF_SCP 데이터 동기화
 * 2026.04.02	JSSBAE		[E20260331-000648]_[자동차 SCM] 자동차사업부 '기준수요'기능 중 'RTF수정기능'만 우선 적용 요청 건
 ========================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL_20260507]
	  @p_active_flag              NVARCHAR(MAX)   
	, @p_DIVISION_ID              NVARCHAR(MAX)    
    , @p_PROJECT_CODE             NVARCHAR(MAX)    
    , @p_SCM_SITE_ID              NVARCHAR(MAX)   
	, @p_PLANT_SITE_ID            NVARCHAR(MAX) 
    , @p_ITEM_ID                  NVARCHAR(MAX)    
    , @p_DOM_EXP                  NVARCHAR(MAX)    
    , @p_FCST_TYPE                NVARCHAR(MAX) 
    , @p_INCOTERMS                NVARCHAR(MAX) 
    , @p_MEASURE                  NVARCHAR(MAX)
    , @p_YYYYMMDD                 NVARCHAR(MAX)    
    , @p_QTY                      NVARCHAR(MAX)    
    , @p_CURRENCY                 NVARCHAR(MAX)    
    , @p_CREATED_BY               NVARCHAR(MAX)    
	, @p_LAST_UPDATED_BY          NVARCHAR(MAX)  
	, @p_TEXT                     NVARCHAR(MAX)
	, @p_dept_id                  NVARCHAR(MAX) --[PJ2024-50611] 부서ID추가
	, @p_CELL_PROD_SITE_ID        NVARCHAR(MAX) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;

	--=============================================================================================================
	-- 스플릿관련 변수 (START)
	--=============================================================================================================
	DECLARE @n_active_flag       NVARCHAR(MAX);
	DECLARE @v_active_flag       NVARCHAR(MAX);
	DECLARE @v_DIVISION_ID       NVARCHAR(MAX);
	DECLARE @v_PROJECT_CODE      NVARCHAR(MAX);
	DECLARE @v_SCM_SITE_ID       NVARCHAR(MAX);
	DECLARE @v_PLANT_SITE_ID     NVARCHAR(MAX);
	DECLARE @v_ITEM_ID           NVARCHAR(MAX);
	DECLARE @v_DOM_EXP           NVARCHAR(MAX);
	DECLARE @v_FCST_TYPE         NVARCHAR(MAX);
	DECLARE @v_INCOTERMS         NVARCHAR(MAX);
	DECLARE @v_MEASURE           NVARCHAR(MAX);
	DECLARE @v_YYYYMMDD          NVARCHAR(MAX);
	DECLARE @v_CURRENCY          NVARCHAR(MAX);
	DECLARE @v_QTY               NVARCHAR(MAX);
	DECLARE @v_CREATED_BY        NVARCHAR(MAX);
	DECLARE @v_LAST_UPDATED_BY   NVARCHAR(MAX);
	DECLARE @v_WYYYYMMDD		 NVARCHAR(MAX);
	DECLARE @v_WEEKNUMBER		 NVARCHAR(MAX);
	DECLARE @v_YYYY				 NVARCHAR(MAX);
	DECLARE @v_YYYYMM			 NVARCHAR(MAX);
	DECLARE @v_TEXT              NVARCHAR(MAX);
	DECLARE @v_dept_id           NVARCHAR(MAX); --[PJ2024-50611] 부서ID추가
	DECLARE @v_bucket            NVARCHAR(MAX); --[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청	
	DECLARE @v_CELL_PROD_SITE_ID NVARCHAR(MAX); --[PJ2025-50017]CELL_PROD_SITE_ID 추가
	DECLARE @v_max_mf_w_version  NVARCHAR(MAX); --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 
	DECLARE @v_max_mf_w_yyyymmdd NVARCHAR(MAX); --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 
	DECLARE @v_max_sf_w_version  NVARCHAR(MAX); --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 
	DECLARE @v_max_sf_w_yyyymmdd NVARCHAR(MAX); --[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 
	--=============================================================================================================
	-- 스플릿관련 변수 (END)
	--=============================================================================================================	

	--=============================================================================================================
	-- LOG 용 변수 설정 (START)
	--=============================================================================================================
	DECLARE @v_program_name		NVARCHAR(150) = 'DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL';
	DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
	DECLARE @n_log_count		INTEGER = 0;
	DECLARE @v_log_message		NVARCHAR(1000);
	DECLARE @v_description		NVARCHAR(500);
	DECLARE @d_event_date		DATETIME;
	DECLARE @n_del_count		INTEGER = 0;
	DECLARE @n_insert_count     INTEGER = 0;
	--=============================================================================================================
	-- LOG 용 변수 설정 (END)
	--=============================================================================================================	

	--=============================================================================================================
	-- SEQUENCE
	--=============================================================================================================
	DECLARE @n_history_seq		INTEGER;
	
	--=============================================================================================================
	-- 마지막 데이터 처리를 위한 구분자 추가 (START)
	--=============================================================================================================
	SET @p_active_flag        = RTRIM(@p_active_flag     ) + '^';
	SET @p_DIVISION_ID        = RTRIM(@p_DIVISION_ID     ) + '^';
	SET @p_PROJECT_CODE       = RTRIM(@p_PROJECT_CODE    ) + '^';
	SET @p_SCM_SITE_ID        = RTRIM(@p_SCM_SITE_ID     ) + '^';
	SET @p_PLANT_SITE_ID      = RTRIM(@p_PLANT_SITE_ID   ) + '^';
	SET @p_ITEM_ID            = RTRIM(@p_ITEM_ID         ) + '^';
	SET @p_DOM_EXP            = RTRIM(@p_DOM_EXP         ) + '^';
	SET @p_FCST_TYPE          = RTRIM(@p_FCST_TYPE       ) + '^';
	SET @p_INCOTERMS          = RTRIM(@p_INCOTERMS       ) + '^';
	SET @p_MEASURE            = RTRIM(@p_MEASURE         ) + '^';
	SET @p_YYYYMMDD           = RTRIM(@p_YYYYMMDD		 ) + '^';
	SET @p_CURRENCY           = RTRIM(@p_CURRENCY        ) + '^';
	SET @p_QTY                = RTRIM(@p_QTY             ) + '^';
	SET @p_CREATED_BY         = RTRIM(@p_CREATED_BY      ) + '^';
	SET @p_LAST_UPDATED_BY    = RTRIM(@p_LAST_UPDATED_BY ) + '^';
	SET @p_TEXT               = RTRIM(@p_TEXT			 ) + '^';
	SET @p_dept_id            = RTRIM(@p_dept_id		 ) + '^';--[PJ2024-50611] 부서ID추가
	SET @p_CELL_PROD_SITE_ID  = RTRIM(@p_CELL_PROD_SITE_ID ) + '^';--[PJ2025-50017] CELL_PROD_SITE_ID 추가
	--=============================================================================================================
	-- 마지막 데이터 처리를 위한 구분자 추가 (END)
	--=============================================================================================================	

	--=============================================================================================================
	-- TEMP TABLE DROP (START)
	--=============================================================================================================
	IF  OBJECT_ID(N'tempdb..#TEMP_SALES_PLAN', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SALES_PLAN;	
	IF  OBJECT_ID(N'tempdb..#TEMP_SALES_PLAN_SalesAmt_LOC', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SALES_PLAN_SalesAmt_LOC;			
	IF  OBJECT_ID(N'tempdb..#TEMP_SALES_PLAN_RTF_SYS_RP', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SALES_PLAN_RTF_SYS_RP;  
	IF  OBJECT_ID(N'tempdb..#TMP_DATA_DUP', N'U') IS NOT NULL 
		DROP TABLE #TMP_DATA_DUP;
	--룩업에 등록된 FCST_TYPE은  필수 입력 제외
	--DMF0003_SAVE_MKT_FCST로직 참고(#mshychu2)
	IF OBJECT_ID (N'tempdb..#TMP_FCST_TYPE', N'U') IS NOT NULL 
		DROP TABLE #TMP_FCST_TYPE
	--=============================================================================================================
	-- TEMP TABLE DROP (END)
	--=============================================================================================================

	--=============================================================================================================
	-- TEMP TABLE CREATE (START)
	--=============================================================================================================		
	---------------------------------------------------------------------------------------------------------------
	-- UI에서 저장 할 때 입력한 모든 데이터
	---------------------------------------------------------------------------------------------------------------
	CREATE TABLE #TEMP_SALES_PLAN 
	( v_active_flag        NVARCHAR(MAX)
	, v_DIVISION_ID        NVARCHAR(MAX)
	, v_PROJECT_CODE       NVARCHAR(MAX)
	, v_SCM_SITE_ID        NVARCHAR(MAX)
	, v_PLANT_SITE_ID      NVARCHAR(MAX)
	, v_ITEM_ID            NVARCHAR(MAX)
	, v_DOM_EXP            NVARCHAR(MAX)
	, v_FCST_TYPE          NVARCHAR(MAX)
	, v_INCOTERMS          NVARCHAR(MAX)
	, v_MEASURE            NVARCHAR(MAX)
	, v_YYYYMMDD           NVARCHAR(MAX)
	, v_CURRENCY           NVARCHAR(MAX)
	--, v_QTY                NVARCHAR(MAX)
	, v_QTY                NUMERIC(30, 10)--[E20250520-000572]_QTY 숫자형식으로 변경
	, v_CREATED_BY         NVARCHAR(MAX)
	, v_LAST_UPDATED_BY    NVARCHAR(MAX)
	, v_TEXT               NVARCHAR(MAX)
	, v_dept_id            NVARCHAR(MAX)--[PJ2024-50611] 부서ID추가
	, v_bucket             NVARCHAR(MAX)--[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청
	, v_CELL_PROD_SITE_ID  NVARCHAR(MAX)--[PJ2025-50017] CELL_PROD_SITE_ID 추가
	, v_FROM_SITE_ID	   NVARCHAR(MAX)--[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
	)	
	---------------------------------------------------------------------------------------------------------------
	-- TEMP TABLE CREATE UI에서 저장 할 때 Measure가 SalesAmt_LOC 였던 데이터
	---------------------------------------------------------------------------------------------------------------
	CREATE TABLE #TEMP_SALES_PLAN_SalesAmt_LOC 
	( v_active_flag        NVARCHAR(MAX)
	, v_DIVISION_ID        NVARCHAR(MAX)
	, v_PROJECT_CODE       NVARCHAR(MAX)
	, v_SCM_SITE_ID        NVARCHAR(MAX)
	, v_PLANT_SITE_ID      NVARCHAR(MAX)
	, v_ITEM_ID            NVARCHAR(MAX)
	, v_DOM_EXP            NVARCHAR(MAX)
	, v_FCST_TYPE          NVARCHAR(MAX)
	, v_INCOTERMS          NVARCHAR(MAX)
	, v_MEASURE            NVARCHAR(MAX)
	, v_YYYYMMDD           NVARCHAR(MAX)
	, v_CURRENCY           NVARCHAR(MAX)
	--, v_QTY                NVARCHAR(MAX)
	, v_QTY                NUMERIC(30, 10)--[E20250520-000572]_QTY 숫자형식으로 변경
	, v_CREATED_BY         NVARCHAR(MAX)
	, v_LAST_UPDATED_BY    NVARCHAR(MAX)
	, v_TEXT               NVARCHAR(MAX)
	, v_dept_id            NVARCHAR(MAX)--[PJ2024-50611] 부서ID추가
	, v_bucket             NVARCHAR(MAX)--[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청
	, v_CELL_PROD_SITE_ID  NVARCHAR(MAX)--[PJ2025-50017] CELL_PROD_SITE_ID 추가
	, v_FROM_SITE_ID	   NVARCHAR(MAX)--[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
	)		
	---------------------------------------------------------------------------------------------------------------
	-- TEMP TABLE CREATE UI에서 저장 할 때 Measure가 RTF_SYS_RP 였던 데이터
	---------------------------------------------------------------------------------------------------------------
	CREATE TABLE #TEMP_SALES_PLAN_RTF_SYS_RP 
	( v_active_flag        NVARCHAR(MAX)
	, v_DIVISION_ID        NVARCHAR(MAX)
	, v_PROJECT_CODE       NVARCHAR(MAX)
	, v_SCM_SITE_ID        NVARCHAR(MAX)
	, v_PLANT_SITE_ID      NVARCHAR(MAX)
	, v_ITEM_ID            NVARCHAR(MAX)
	, v_DOM_EXP            NVARCHAR(MAX)
	, v_FCST_TYPE          NVARCHAR(MAX)
	, v_INCOTERMS          NVARCHAR(MAX)
	, v_MEASURE            NVARCHAR(MAX)
	, v_YYYYMMDD           NVARCHAR(MAX)
	, v_CURRENCY           NVARCHAR(MAX)
	--, v_QTY                NVARCHAR(MAX)
	, v_QTY                NUMERIC(30, 10)--[E20250520-000572]_QTY 숫자형식으로 변경
	, v_CREATED_BY         NVARCHAR(MAX)
	, v_LAST_UPDATED_BY    NVARCHAR(MAX)
	, v_TEXT               NVARCHAR(MAX)
	, v_dept_id            NVARCHAR(MAX)--[PJ2024-50611] 부서ID추가
	, v_bucket             NVARCHAR(MAX)--[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청
	, v_CELL_PROD_SITE_ID  NVARCHAR(MAX)--[PJ2025-50017] CELL_PROD_SITE_ID 추가
	, v_FROM_SITE_ID	   NVARCHAR(MAX)--[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
	)

	---------------------------------------------------------------------------------------------------------------
	--[PJ2024-50611] 중복체크용 TMP TABLE
	---------------------------------------------------------------------------------------------------------------
	CREATE TABLE #TMP_DATA_DUP 
	( v_active_flag        NVARCHAR(MAX)
	, v_DIVISION_ID        NVARCHAR(MAX)
	, v_PROJECT_CODE       NVARCHAR(MAX)
	, v_SCM_SITE_ID        NVARCHAR(MAX)
	, v_PLANT_SITE_ID      NVARCHAR(MAX)
	, v_ITEM_ID            NVARCHAR(MAX)
	, v_DOM_EXP            NVARCHAR(MAX)
	, v_FCST_TYPE          NVARCHAR(MAX)
	, v_INCOTERMS          NVARCHAR(MAX)
	, v_MEASURE            NVARCHAR(MAX)
	, v_YYYYMMDD           NVARCHAR(MAX)
	, v_CURRENCY           NVARCHAR(MAX)
	--, v_QTY                NVARCHAR(MAX)
	, v_QTY                NUMERIC(30, 10)--[E20250520-000572]_QTY 숫자형식으로 변경
	, v_CREATED_BY         NVARCHAR(MAX)
	, v_LAST_UPDATED_BY    NVARCHAR(MAX)
	, v_TEXT               NVARCHAR(MAX)
	, v_dept_id            NVARCHAR(MAX)
	, v_bucket             NVARCHAR(MAX)--[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청
	, v_CELL_PROD_SITE_ID  NVARCHAR(MAX)--[PJ2025-50017] CELL_PROD_SITE_ID 추가
	) 	
	---------------------------------------------------------------------------------------------------------------
	--[E20250520-000572]_사용하지 않는 TEMP 테이블로 확인되어 주석처리한다. #TMP_DATA_RTF START
	---------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------
	--[E20260331-000648]_동일한 테이블에 분기쳐 작업하는 부분이 생겨 테이블을 먼저 생성한다. (START)
	---------------------------------------------------------------------------------------------------------------
	CREATE TABLE #TEMP_PRICE_RTF_SYS_RP 
	( v_PROJECT_CODE       NVARCHAR(MAX)
	, v_SCM_SITE_ID        NVARCHAR(MAX)
	, v_ITEM_ID            NVARCHAR(MAX)
	, v_DOM_EXP            NVARCHAR(MAX)
	, v_FCST_TYPE          NVARCHAR(MAX)
	, v_INCOTERMS          NVARCHAR(MAX)
	, v_PLANT_SITE_ID      NVARCHAR(MAX)
	, v_CELL_PROD_SITE_ID  NVARCHAR(MAX)
	, WEEK_NAME			   NVARCHAR(MAX)
	)
	---------------------------------------------------------------------------------------------------------------
	--[E20260331-000648]_동일한 테이블에 분기쳐 작업하는 부분이 생겨 테이블을 먼저 생성한다. (END)
	---------------------------------------------------------------------------------------------------------------
	/*
	---------------------------------------------------------------------------------------------------------------
	--[PJ2024-50611] RTF_SYS_RP 체크용 TMP TABLE
	---------------------------------------------------------------------------------------------------------------
	IF  OBJECT_ID(N'tempdb..#TMP_DATA_RTF', N'U') IS NOT NULL 
		DROP TABLE #TMP_DATA_RTF;

	CREATE TABLE #TMP_DATA_RTF 
	( v_active_flag        NVARCHAR(MAX)
	, v_DIVISION_ID        NVARCHAR(MAX)
	, v_PROJECT_CODE       NVARCHAR(MAX)
	, v_SCM_SITE_ID        NVARCHAR(MAX)
	, v_PLANT_SITE_ID      NVARCHAR(MAX)
	, v_ITEM_ID            NVARCHAR(MAX)
	, v_DOM_EXP            NVARCHAR(MAX)
	, v_FCST_TYPE          NVARCHAR(MAX)
	, v_INCOTERMS          NVARCHAR(MAX)
	, v_MEASURE            NVARCHAR(MAX)
	, v_YYYYMMDD           NVARCHAR(MAX)
	, v_CURRENCY           NVARCHAR(MAX)
	--, v_QTY                NVARCHAR(MAX)
	, v_QTY                NUMERIC(30, 10)--[E20250520-000572]_QTY 숫자형식으로 변경
	, v_CREATED_BY         NVARCHAR(MAX)
	, v_LAST_UPDATED_BY    NVARCHAR(MAX)
	, v_TEXT               NVARCHAR(MAX)
	, v_dept_id            NVARCHAR(MAX)
	, v_bucket             NVARCHAR(MAX)--[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청
	, v_CELL_PROD_SITE_ID  NVARCHAR(MAX)--[PJ2025-50017] CELL_PROD_SITE_ID 추가
	)*/
	---------------------------------------------------------------------------------------------------------------
	--[E20250520-000572]_사용하지 않는 TEMP 테이블로 확인되어 주석처리한다. #TMP_DATA_RTF END
	---------------------------------------------------------------------------------------------------------------	
	--=============================================================================================================
	-- TEMP TABLE CREATE (END)
	--=============================================================================================================	
	
	--=============================================================================================================
	-- 시작 LOG  (START)
	--=============================================================================================================
	SET	@v_log_type		= 'START';
	SET @v_log_message	= '########## Start of procedure ##########';
	SET @v_description	= '';
	SET @d_event_date	= SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message	= NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	--=============================================================================================================
	-- 시작 LOG  (END)
	--=============================================================================================================
PRINT @v_program_name + ' : A001--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
	--=============================================================================================================
	-- 트랜잭션 (START)
	--=============================================================================================================
	BEGIN TRANSACTION SAVE_DM_PLN_SALES_PLAN_ALL;	
	---------------------------------------------------------------------------------------------------------------	
	BEGIN TRY
	---------------------------------------------------------------------------------------------------------------	
		WHILE LEN(@p_DIVISION_ID) > 0
		--=============================================================================================================
		-- #TEMP_SALES_PLAN 테이블에 split후 insert (START)
		--=============================================================================================================	
		BEGIN
			BEGIN
				DECLARE @index_active_flag       INT
				DECLARE @index_DIVISION_ID       INT
				DECLARE @index_PROJECT_CODE      INT
				DECLARE @index_SCM_SITE_ID       INT
				DECLARE @index_PLANT_SITE_ID     INT
				DECLARE @index_ITEM_ID           INT
				DECLARE @index_DOM_EXP           INT
				DECLARE @index_FCST_TYPE         INT
				DECLARE @index_INCOTERMS         INT
				DECLARE @index_MEASURE           INT
				DECLARE @index_YYYYMMDD          INT
				DECLARE @index_CURRENCY          INT
				DECLARE @index_QTY               INT
				DECLARE @index_CREATED_BY        INT
				DECLARE @index_LAST_UPDATED_BY   INT
				DECLARE @index_TEXT              INT
				DECLARE @index_dept_id           INT --[PJ2024-50611] 부서ID추가
				DECLARE @index_CELL_PROD_SITE_ID INT --[PJ2025-50017] CELL_PROD_SITE_ID 추가

				SET @index_active_flag       = PATINDEX('%' + '^' + '%', @p_active_flag      )
				SET @index_DIVISION_ID       = PATINDEX('%' + '^' + '%', @p_DIVISION_ID      )
				SET @index_PROJECT_CODE      = PATINDEX('%' + '^' + '%', @p_PROJECT_CODE     )
				SET @index_SCM_SITE_ID       = PATINDEX('%' + '^' + '%', @p_SCM_SITE_ID      )
				SET @index_PLANT_SITE_ID     = PATINDEX('%' + '^' + '%', @p_PLANT_SITE_ID    )
				SET @index_ITEM_ID           = PATINDEX('%' + '^' + '%', @p_ITEM_ID          )
				SET @index_DOM_EXP           = PATINDEX('%' + '^' + '%', @p_DOM_EXP          )
				SET @index_FCST_TYPE         = PATINDEX('%' + '^' + '%', @p_FCST_TYPE        )
				SET @index_INCOTERMS         = PATINDEX('%' + '^' + '%', @p_INCOTERMS        )
				SET @index_MEASURE           = PATINDEX('%' + '^' + '%', @p_MEASURE          )
				SET @index_YYYYMMDD          = PATINDEX('%' + '^' + '%', @p_YYYYMMDD         )
				SET @index_CURRENCY          = PATINDEX('%' + '^' + '%', @p_CURRENCY         )
				SET @index_QTY               = PATINDEX('%' + '^' + '%', @p_QTY              )
				SET @index_CREATED_BY        = PATINDEX('%' + '^' + '%', @p_CREATED_BY       )
				SET @index_LAST_UPDATED_BY   = PATINDEX('%' + '^' + '%', @p_LAST_UPDATED_BY  )
				SET @index_TEXT              = PATINDEX('%' + '^' + '%', @p_TEXT			 )
				SET @index_dept_id           = PATINDEX('%' + '^' + '%', @p_dept_id			 )--[PJ2024-50611] 부서ID추가
				SET @index_CELL_PROD_SITE_ID = PATINDEX('%' + '^' + '%', @p_CELL_PROD_SITE_ID)--[PJ2025-50017] CELL_PROD_SITE_ID 추가
			END

		IF @index_DIVISION_ID > 0
		BEGIN
			SET @v_active_flag	= SUBSTRING(@p_active_flag, 0, @index_active_flag)
			SET @p_active_flag	= SUBSTRING(@p_active_flag, LEN(@v_active_flag + '^') + 1, LEN(@p_active_flag))

			SET @v_DIVISION_ID	= SUBSTRING(@p_DIVISION_ID, 0, @index_DIVISION_ID)
			SET @p_DIVISION_ID	= SUBSTRING(@p_DIVISION_ID, LEN(@v_DIVISION_ID + '^') + 1, LEN(@p_DIVISION_ID))

			SET @v_PROJECT_CODE	= SUBSTRING(@p_PROJECT_CODE, 0, @index_PROJECT_CODE)
			SET @p_PROJECT_CODE = SUBSTRING(@p_PROJECT_CODE, LEN(@v_PROJECT_CODE + '^') + 1, LEN(@p_PROJECT_CODE))

			SET @v_SCM_SITE_ID	= SUBSTRING(@p_SCM_SITE_ID, 0, @index_SCM_SITE_ID)
			SET @p_SCM_SITE_ID	= SUBSTRING(@p_SCM_SITE_ID, LEN(@v_SCM_SITE_ID + '^') + 1, LEN(@p_SCM_SITE_ID))

			SET @v_PLANT_SITE_ID = SUBSTRING(@p_PLANT_SITE_ID, 0, @index_PLANT_SITE_ID)
			SET @p_PLANT_SITE_ID = SUBSTRING(@p_PLANT_SITE_ID, LEN(@v_PLANT_SITE_ID + '^') + 1, LEN(@p_PLANT_SITE_ID))

			SET @v_ITEM_ID		= SUBSTRING(@p_ITEM_ID, 0, @index_ITEM_ID)
			SET @p_ITEM_ID		= SUBSTRING(@p_ITEM_ID, LEN(@v_ITEM_ID + '^') + 1, LEN(@p_ITEM_ID))
				
			SET @v_TEXT			= SUBSTRING(@p_TEXT, 0, @index_TEXT)
			SET @p_TEXT			= SUBSTRING(@p_TEXT, LEN(@v_TEXT + '^') + 1, LEN(@p_TEXT))

			SET @v_DOM_EXP		= SUBSTRING(@p_DOM_EXP , 0, @index_DOM_EXP )
			SET @p_DOM_EXP		= SUBSTRING(@p_DOM_EXP , LEN(@v_DOM_EXP  + '^') + 1, LEN(@p_DOM_EXP ))

			SET @v_FCST_TYPE	= SUBSTRING(@p_FCST_TYPE , 0, @index_FCST_TYPE )
			SET @p_FCST_TYPE	= SUBSTRING(@p_FCST_TYPE , LEN(@v_FCST_TYPE  + '^') + 1, LEN(@p_FCST_TYPE ))

			SET @v_INCOTERMS	= SUBSTRING(@p_INCOTERMS , 0, @index_INCOTERMS )
			SET @p_INCOTERMS	= SUBSTRING(@p_INCOTERMS , LEN(@v_INCOTERMS  + '^') + 1, LEN(@p_INCOTERMS ))

			SET @v_MEASURE		= SUBSTRING(@p_MEASURE , 0, @index_MEASURE )
			SET @p_MEASURE		= SUBSTRING(@p_MEASURE , LEN(@v_MEASURE  + '^') + 1, LEN(@p_MEASURE ))

			SET @v_WYYYYMMDD	= SUBSTRING(@p_YYYYMMDD , 0, @index_YYYYMMDD )
			SET @v_WEEKNUMBER	= RIGHT(@v_WYYYYMMDD, 2)

			SET @v_YYYY			= SUBSTRING(@v_WYYYYMMDD, 3, 4)
			SET @v_YYYYMM		= SUBSTRING(@v_WYYYYMMDD, 3, 6)

			SET @v_bucket		= SUBSTRING(@v_WYYYYMMDD,1,1)	--[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청	

			IF ( SUBSTRING(@v_WYYYYMMDD,1,1) = 'M')				
				---------------------------------------------------------------------------------------------------------------
				--[E20250520-000605]_40사업부의 경우 Monthly Bucket이고, Fcst Type이 ETC인 MEASURE는 "SalesAmt_USD" 해당 메져만 있음
				--요청사항이 ETC MEASURE인 경우에만, 달의 마지막날에 Bucket 입력되도록 수정 요청한 건으로 해당 작업 진행 (START)
				---------------------------------------------------------------------------------------------------------------
				IF (@v_DIVISION_ID = '40' AND @v_FCST_TYPE = N'ETC')
				BEGIN 
					--달의 마지막 날을 구한다.
					SELECT	@v_YYYYMMDD = SUBSTRING(@v_WYYYYMMDD, 3, 6) + MAX(CALENDAR_DAY)
					FROM	SCM_SYS_CALENDAR_M WITH(NOLOCK)
					WHERE	BASIS_YYYYMM = @v_YYYYMM
PRINT '@v_FCST_TYPE: ' + @v_FCST_TYPE
PRINT '@v_YYYYMMDD: ' + @v_YYYYMMDD
				END
				--[E20250520-000605]_기존 소스는 ELSE 밑으로 유지한다.
				ELSE
				BEGIN
					SET @v_YYYYMMDD = SUBSTRING(@v_WYYYYMMDD, 3, 6) + '01'
				END				
				---------------------------------------------------------------------------------------------------------------  
				--[E20250520-000605]_40사업부의 경우 Monthly Bucket인 경우 달의 가장 마지막 날에 Bucket 입력되도록 수정 요청 (END)		
				---------------------------------------------------------------------------------------------------------------
			ELSE
			IF ( SUBSTRING(@v_YYYYMM,5,2) <> '12')
				BEGIN
					SELECT @v_YYYYMMDD = IIF(MIN(A.BASIS_YYYYMM) = MAX(A.BASIS_YYYYMM), MIN(A.BASIS_YYYYMMDD)
						 , IIF(@v_YYYYMM = MIN(A.BASIS_YYYYMM), MIN(A.BASIS_YYYYMMDD), MAX(A.BASIS_YYYYMM)+'01')) 
					FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)
					WHERE A.CALENDAR_YYYY = @v_YYYY AND A.ISO_WEEK = @v_WEEKNUMBER
				END
			ELSE
				BEGIN
					SELECT @v_YYYYMMDD = IIF(MIN(A.BASIS_YYYYMM) = MAX(A.BASIS_YYYYMM), MIN(A.BASIS_YYYYMMDD) 
						 , IIF(@v_YYYYMM = MIN(A.BASIS_YYYYMM), MIN(A.BASIS_YYYYMMDD), MAX(A.BASIS_YYYYMM)+'01')) 
					FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)
					WHERE A.CALENDAR_YYYY = @v_YYYY AND A.ISO_WEEK = @v_WEEKNUMBER AND A.BASIS_YYYYMM = @v_YYYYMM
				END	
			SET @p_YYYYMMDD  = SUBSTRING(@p_YYYYMMDD , LEN(@v_WYYYYMMDD  + '^') + 1, LEN(@p_YYYYMMDD ))

			SET @v_CURRENCY  = SUBSTRING(@p_CURRENCY , 0, @index_CURRENCY )
			SET @p_CURRENCY  = SUBSTRING(@p_CURRENCY , LEN(@v_CURRENCY  + '^') + 1, LEN(@p_CURRENCY ))			

			IF @p_CURRENCY IS NULL 
			BEGIN
				SET @p_CURRENCY = ''
			END

			SET @v_QTY  = SUBSTRING(@p_QTY , 0, @index_QTY )
			SET @p_QTY  = SUBSTRING(@p_QTY , LEN(@v_QTY  + '^') + 1, LEN(@p_QTY ))
			
			SET @v_CREATED_BY  = SUBSTRING(@p_CREATED_BY , 0, @index_CREATED_BY )
			SET @p_CREATED_BY  = SUBSTRING(@p_CREATED_BY , LEN(@v_CREATED_BY  + '^') + 1, LEN(@p_CREATED_BY ))

			SET @v_LAST_UPDATED_BY  = SUBSTRING(@p_LAST_UPDATED_BY , 0, @index_LAST_UPDATED_BY )
			SET @p_LAST_UPDATED_BY  = SUBSTRING(@p_LAST_UPDATED_BY , LEN(@v_LAST_UPDATED_BY  + '^') + 1, LEN(@p_LAST_UPDATED_BY ))

			---------------------------------------------------------------------------------------------------------------	
			--[PJ2024-50611] 부서ID추가 START
			---------------------------------------------------------------------------------------------------------------	
			SET @v_dept_id = SUBSTRING(@p_dept_id, 0, @index_dept_id)
			SET @p_dept_id = SUBSTRING(@p_dept_id, LEN(@v_dept_id + '^') + 1, LEN(@p_dept_id))
			---------------------------------------------------------------------------------------------------------------	
			--[PJ2024-50611] 부서ID추가 END
			---------------------------------------------------------------------------------------------------------------			
			---------------------------------------------------------------------------------------------------------------	
			--[PJ2025-50017] CELL_PROD_SITE_ID 추가 START
			---------------------------------------------------------------------------------------------------------------	
			SET @v_CELL_PROD_SITE_ID = SUBSTRING(@p_CELL_PROD_SITE_ID, 0, @index_CELL_PROD_SITE_ID)
			SET @p_CELL_PROD_SITE_ID = SUBSTRING(@p_CELL_PROD_SITE_ID, LEN(@v_CELL_PROD_SITE_ID + '^') + 1, LEN(@p_CELL_PROD_SITE_ID))
			---------------------------------------------------------------------------------------------------------------	
			--[PJ2025-50017] CELL_PROD_SITE_ID 추가 END
			---------------------------------------------------------------------------------------------------------------	

			INSERT INTO #TEMP_SALES_PLAN 
			( v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID ,v_PLANT_SITE_ID  
			, v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE        
			, v_YYYYMMDD, v_CURRENCY, v_QTY, v_CREATED_BY, v_LAST_UPDATED_BY  
			, v_TEXT, v_dept_id --[PJ2024-50611] 부서ID추가	
			, v_bucket --[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청	
			, v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			) 
			VALUES 
			( @v_active_flag, @v_DIVISION_ID, @v_PROJECT_CODE, @v_SCM_SITE_ID, @v_PLANT_SITE_ID  
			, @v_ITEM_ID, @v_DOM_EXP, @v_FCST_TYPE, @v_INCOTERMS, @v_MEASURE        
			, @v_YYYYMMDD, @v_CURRENCY, @v_QTY, @v_CREATED_BY, @v_LAST_UPDATED_BY    
			, @v_TEXT, @v_dept_id --[PJ2024-50611] 부서ID추가
			, @v_bucket --[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청	
			, @v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			)	
		END
		ELSE
		BEGIN
			SET @v_DIVISION_ID = @p_DIVISION_ID
			SET @p_DIVISION_ID = NULL
 
			INSERT INTO #TEMP_SALES_PLAN			
			( v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID ,v_PLANT_SITE_ID  
			, v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE        
			, v_YYYYMMDD, v_CURRENCY, v_QTY, v_CREATED_BY, v_LAST_UPDATED_BY  
			, v_TEXT, v_dept_id --[PJ2024-50611] 부서ID추가	
			, v_bucket --[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청	
			, v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			) 
			VALUES 
			( @v_active_flag, @v_DIVISION_ID, @v_PROJECT_CODE, @v_SCM_SITE_ID, @v_PLANT_SITE_ID  
			, @v_ITEM_ID, @v_DOM_EXP, @v_FCST_TYPE, @v_INCOTERMS, @v_MEASURE        
			, @v_YYYYMMDD, @v_CURRENCY, @v_QTY, @v_CREATED_BY, @v_LAST_UPDATED_BY   
			, @v_TEXT, @v_dept_id--[PJ2024-50611] 부서ID추가
			, @v_bucket --[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청	
			, @v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			)
		END

		---------------------------------------------------------------------------------------------------------------	
		-- [PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리 START (UI에서 FROM_SITE_ID 데이터를 주지 않기 때문에 #TEMP_SALES_PLAN에 SALES_PLAN을 통해서 업데이트 처리)				
		---------------------------------------------------------------------------------------------------------------	
		UPDATE A
		SET A.v_FROM_SITE_ID = B.FROM_SITE_ID
		FROM #TEMP_SALES_PLAN A
		INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
						  , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, MAX(ATTRIBUTE2) AS FROM_SITE_ID
					 FROM  DM_PLN_SALES_PLAN WITH(NOLOCK)
					 WHERE DIVISION_ID = @v_DIVISION_ID
					 AND   MEASURE = 'RTF_SYS_RP'
					 AND   YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
					 AND   ATTRIBUTE2 IS NOT NULL
					 GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
					) B
				ON	A.v_DIVISION_ID			= B.DIVISION_ID
				AND A.v_PROJECT_CODE		= B.PROJECT_CODE
				AND A.v_SCM_SITE_ID			= B.SCM_SITE_ID
				AND A.v_PLANT_SITE_ID		= B.PLANT_SITE_ID
				AND A.v_ITEM_ID				= B.ITEM_ID
				AND A.v_DOM_EXP				= B.DOM_EXP
				AND A.v_FCST_TYPE			= B.FCST_TYPE
				AND A.v_INCOTERMS			= B.INCOTERMS
				AND A.v_MEASURE				= B.MEASURE
				AND A.v_CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID;	

		---------------------------------------------------------------------------------------------------------------	
		-- [PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리 END
		---------------------------------------------------------------------------------------------------------------		
		---------------------------------------------------------------------------------------------------------------	
		--[E20260331-000648]_CELL_PROD_SITE_ID UPDATE 작업 진행 (START)
		---------------------------------------------------------------------------------------------------------------	
		IF ( SELECT COUNT(1) FROM #TEMP_SALES_PLAN WHERE v_DIVISION_ID != '40' ) > 0
		BEGIN 
			UPDATE A
			SET A.v_CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			FROM #TEMP_SALES_PLAN A
			INNER JOIN ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							  , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, MAX(A.CELL_PROD_SITE_ID) AS CELL_PROD_SITE_ID
						   FROM DM_PLN_SALES_PLAN A WITH(NOLOCK)
						  WHERE A.DIVISION_ID = @v_DIVISION_ID
							AND A.MEASURE = 'RTF_SYS_RP'
							AND A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
						  GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
						) B
					ON	A.v_DIVISION_ID			= B.DIVISION_ID
					AND A.v_PROJECT_CODE		= B.PROJECT_CODE
					AND A.v_SCM_SITE_ID			= B.SCM_SITE_ID
					AND A.v_ITEM_ID				= B.ITEM_ID
					AND A.v_DOM_EXP				= B.DOM_EXP
					AND A.v_FCST_TYPE			= B.FCST_TYPE
					AND A.v_INCOTERMS			= B.INCOTERMS
					AND A.v_MEASURE				= B.MEASURE
					AND A.v_PLANT_SITE_ID		= B.PLANT_SITE_ID				
		END
		---------------------------------------------------------------------------------------------------------------	
		--[E20260331-000648]_CELL_PROD_SITE_ID UPDATE 작업 진행 (END)
		---------------------------------------------------------------------------------------------------------------	
		END
		--=============================================================================================================
		--#TEMP_SALES_PLAN 테이블에 split후 insert (END)
		--=============================================================================================================
PRINT @v_program_name + ' : A003--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
	BEGIN	
PRINT @v_program_name + ' : A004--' ;
		--=============================================================================================================
		--저장 데이터 유형 별로 임시테이블을 나눈다.
		--#TEMP_SALES_PLAN_SalesAmt_LOC -- UI에서 저장 할 때 Measure가 SalesAmt_LOC 였던 데이터
		--#TEMP_SALES_PLAN_RTF_SYS_RP   -- UI에서 저장 할 때 Measure가 RTF_SYS_RP 였던 데이터
		--임시테이블을 2개로 나눈 이유는 SalesAmt_LOC 라는MEASURE가 UI에서 저장 할 때 처음부터 있으나
		--RTF_SYS_RP 를 저장 할 때도 SalesAmt_LOC를 생성 하기 때문에
		--만약에 UI에서 SalesAmt_LOC , RTF_SYS_RP 두개 MEASURE를 동시에 저장 할 경우에
		--UI에서 저장 할 때 부터 있던 SalesAmt_LOC MEASURE인지, RTF_SYS_RP 를 저장 할 때 생성한 SalesAmt_LOC MEASURE인지 
		--쉽게 구분하기 힘들기 때문에 만들었습니다.
		--=============================================================================================================
		INSERT INTO #TEMP_SALES_PLAN_SalesAmt_LOC
		SELECT * FROM #TEMP_SALES_PLAN WHERE v_MEASURE = 'SalesAmt_LOC'
PRINT @v_program_name + ' : A005--' ;

		INSERT INTO #TEMP_SALES_PLAN_RTF_SYS_RP
		SELECT * FROM #TEMP_SALES_PLAN WHERE v_MEASURE = 'RTF_SYS_RP'
PRINT @v_program_name + ' : A006--' ;

		--=============================================================================================================
		--[E20251027-000091]_RTF_SYS_RP 메져로 RTF_SCP, RTF 생성 (START)
		INSERT INTO #TEMP_SALES_PLAN_RTF_SYS_RP
		SELECT A.v_active_flag, A.v_DIVISION_ID, A.v_PROJECT_CODE, A.v_SCM_SITE_ID ,A.v_PLANT_SITE_ID  
			 , A.v_ITEM_ID, A.v_DOM_EXP, A.v_FCST_TYPE, A.v_INCOTERMS, B.MEASURE        
			 , A.v_YYYYMMDD, A.v_CURRENCY, A.v_QTY, A.v_CREATED_BY, A.v_LAST_UPDATED_BY  
			 , A.v_TEXT, A.v_dept_id, A.v_bucket, A.v_CELL_PROD_SITE_ID, A.v_FROM_SITE_ID
		 FROM #TEMP_SALES_PLAN_RTF_SYS_RP A
		,
		( SELECT 'RTF' MEASURE
		   UNION 
		  SELECT 'RTF_SCP' MEASURE) B
		--[E20251027-000091]_RTF_SYS_RP 메져로 RTF_SCP, RTF 생성 (END)
		--=============================================================================================================
PRINT @v_program_name + ' : A007--' ;

		---------------------------------------------------------------------------------------------------------------	
		--[PJ2024-50611]Catch Up 일 경우 저장되어야 하므로 주석처리;
		---------------------------------------------------------------------------------------------------------------
		--SM 수정 본 (START)
		---------------------------------------------------------------------------------------------------------------	
		/*print 'A--' + convert(varchar(30), getdate(), 121)
					IF (select count(1) from #TEMP_SALES_PLAN where v_FCST_TYPE <> 'ETC') > 0
					BEGIN
								SET @v_log_type = 'INVALID';
								SET @v_log_message = N'FCST TYPE이 ETC가 아닌 데이터는 저장할 수 없습니다.'
								SELECT @v_log_message
		PRINT @v_log_message;
		PRINT @v_log_type;
								goto err_rtn

		print 'B--' + convert(varchar(30), getdate(), 121)
					END		
		*/
		---------------------------------------------------------------------------------------------------------------
		--SM 수정 본 (END)
		---------------------------------------------------------------------------------------------------------------	
		--=============================================================================================================
		-- VALIDATION (START)
		--=============================================================================================================
		---------------------------------------------------------------------------------------------------------------
		--[E20250520-000572]_VALIDATION 사용 시 필요한 변수를 먼저 선언한다. (START)
		---------------------------------------------------------------------------------------------------------------
		DECLARE @s_validation			NVARCHAR(1000)	= null; --ERROR 메시지를 담기위해 변수선언
		DECLARE @s_code					NVARCHAR(50)	= null; --MSG00428: 신규 입력 데이터 중 중복된 데이터가 있습니다.\r\n{0}
		---------------------------------------------------------------------------------------------------------------
		--[E20250520-000572]_VALIDATION 사용 시 필요한 변수를 먼저 선언한다. (END)
		---------------------------------------------------------------------------------------------------------------			
		---------------------------------------------------------------------------------------------------------------
		--[E20260331-000648]_SALES PLAN CUTOFF가 한번도 진행되지 않은 경우에는 RTF를 수정하지 못하게한다. (START)
		---------------------------------------------------------------------------------------------------------------
		IF ( SELECT COUNT(*) FROM #TEMP_SALES_PLAN_RTF_SYS_RP ) > 0
		BEGIN
			--[E20260331-000648]_당주 월요일 이후 SALES PLAN CUTOFF 한 횟수가 없다면 MESSAGE를 뿌리고, 종료한다. (START)
			IF ( SELECT COUNT(*) FROM DM_MST_VERSION WITH(NOLOCK) 
				  WHERE DIVISION_ID = @v_DIVISION_ID 
				    AND VERSION_TYPE = 'SP_W' 
					AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)) = 0
			BEGIN
				SET @v_log_type = 'INVALID';     
				SET	@s_code		= 'MSG00473';  --[MSG00473]: 해당 주차 SCP Final Plan이 수행된 이후부터 RTF수정 가능합니다.
				SET @s_validation = ' ';
				GOTO ERR_RTN
			END
			--[E20260331-000648]_당주 월요일 이후 SALES PLAN CUTOFF 한 횟수가 없다면 MESSAGE를 뿌리고, 종료한다. (END)
		END
		---------------------------------------------------------------------------------------------------------------
		--[E20260331-000648]_SALES PLAN CUTOFF가 한번도 진행되지 않은 경우에는 RTF를 수정하지 못하게한다. (END)
		---------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------
		--[E20260331-000648]_룩업에 지정된 시간이 지나면 저장을 하지 못하도록 한다.(START)
		---------------------------------------------------------------------------------------------------------------
		SELECT DAYOFWEEK AS DAYOFWEEKS
		INTO #TEMP_DAYINFO
		FROM [dbo].[SCM_SYS_CALENDAR_M] WITH (NOLOCK)
		WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8), GETDATE(), 112)
			
		IF 	(	SELECT COUNT(*) AS CNT
				FROM #TEMP_SALES_PLAN_RTF_SYS_RP A
				INNER JOIN ( SELECT A.SEGMENT3 AS DIVISION_ID, A.ATTRIBUTE1 AS TARGET_DATE, A.ATTRIBUTE2 AS FROM_TIME, A.SEGMENT4 AS MEASURE
								FROM (  SELECT B.SEGMENT3, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.SEGMENT4
										FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
										WHERE B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
										AND B.VALID_YN = 'Y' 
										AND B.SEGMENT2 = 'DMF0021' 
										AND B.SEGMENT3 = @V_DIVISION_ID
										AND ISNULL(B.ATTRIBUTE1, '') != ''
										GROUP BY B.SEGMENT3, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.SEGMENT4 ) A ) C
						  ON A.v_DIVISION_ID	= C.DIVISION_ID
						 AND A.v_MEASURE		= C.MEASURE
				WHERE (C.TARGET_DATE = 'ALL' OR C.TARGET_DATE IN (SELECT DAYOFWEEKS FROM #TEMP_DAYINFO))
				AND CAST(REPLACE(LEFT(CONVERT(VARCHAR,GETDATE(), 108),5), ':', '')AS INT) > CAST(C.FROM_TIME AS INT)) > 0
		BEGIN
			SET @v_log_type	= 'INVALID';   
			SET	@s_code		= 'MSG00474'; 
			SET @s_validation = ' ';
			GOTO ERR_RTN
		END			
		---------------------------------------------------------------------------------------------------------------
		--[E20260331-000648]_SALES PLAN CUTOFF가 3번인 경우, SALES PLAN 수정을 못하게한다. 81, 81_JV(END)
		---------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------
		-- [E20250919-001699]_Incoterms 데이터 처리 VALID 처리 (START)
		---------------------------------------------------------------------------------------------------------------
		IF EXISTS ( SELECT * FROM #TEMP_SALES_PLAN R WHERE R.v_incoterms IN ( SELECT OLD_VALUE1 FROM [dbo].[NERP_CONV_MASTER] WITH(NOLOCK) WHERE CODETYPE = 'INCOTERMS_ID' GROUP BY OLD_VALUE1))
		BEGIN
			SET @v_log_type = 'INVALID';     
			SET	@s_code		= 'MSG00467';  --[MSG00467]: 구코드 INCOTERMS는 저장할 수 없습니다.	
			SET @s_validation = ' ';
			GOTO ERR_RTN
		END			
		---------------------------------------------------------------------------------------------------------------
		-- [E20250919-001699]_Incoterms 데이터 처리 VALID 처리 (END)
		---------------------------------------------------------------------------------------------------------------

	    IF ( SELECT COUNT(1) FROM #TEMP_SALES_PLAN WHERE v_DIVISION_ID <> '40' ) > 0  -- 20180614 KHSOMG 40 DIVISION 조건 추가
		BEGIN
			---------------------------------------------------------------------------------------------------------------
			-- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 (START) [MSG00457]: PROJECT_CODE: {0} 유효하지 않은 프로젝트 코드입니다! 	
			---------------------------------------------------------------------------------------------------------------
			---------------------------------------------------------------------------------------------------------------
			--[E20250520-000572]_변수를 선언하여, 해당 변수의 값을 가지고 가도록 수정함 (원소스 주석처리) (START) 
			---------------------------------------------------------------------------------------------------------------
			/*
			IF ( SELECT COUNT(1) FROM #TEMP_SALES_PLAN
				 WHERE ( SELECT COUNT(1) FROM SCM_MST_PROJECT WITH(NOLOCK)  
						 WHERE PROJECT_CODE  = v_PROJECT_CODE ) = 0 
				 AND v_PROJECT_CODE <> 'N'   --20180423 SKH validation 조건에서 제외시킴
				 AND v_DIVISION_ID  <> '40'  -- 20180614 KHSOMG 40 DIVISION 조건 추가
				) > 0 */
			SET @s_validation = ( SELECT TOP 1 v_PROJECT_CODE FROM #TEMP_SALES_PLAN A
								  LEFT OUTER JOIN SCM_MST_PROJECT B WITH(NOLOCK)
								  			   ON A.v_DIVISION_ID = B.DIVISION_ID
								  			  AND A.v_PROJECT_CODE = B.PROJECT_CODE
								  WHERE A.v_PROJECT_CODE <> 'N'   --20180423 SKH validation 조건에서 제외시킴
								  AND   A.v_DIVISION_ID  <> '40'  -- 20180614 KHSOMG 40 DIVISION 조건 추가
								  AND   ISNULL(B.PROJECT_CODE, '') = '');								  
			---------------------------------------------------------------------------------------------------------------
			--[E20250520-000572]_변수를 선언하여, 해당 변수의 값을 가지고 가도록 수정함 (원소스 주석처리) (END)
			---------------------------------------------------------------------------------------------------------------

			IF (@s_validation IS NOT NULL) --[E20250520-000572]_변수에 담은 값으로 비교
			BEGIN				   
				--SET @v_log_type = 'INVALID'; --[E20250520-000572]_MESSAGE 코드를 사용하여 수정하기로 하였으므로, 원소스 주석처리
				
				--[E20250520-000572]_MESSAGE 코드와 변수만 존재하면, VALIDATION 체크가 가능하므로 해당 메시지는 주석처리 함
				/*
				SET @v_log_message = '['+ ( SELECT TOP 1 v_PROJECT_CODE  -- 2024.06.26 여러개의 v_PROJECT_CODE 가 조회되면 에러가 발생하여 TOP 1 추가 함(하위 쿼리에서 값을 둘 이상 반환했습니다. 하위 쿼리 앞에 =, !=, <, <=, >, >= 등이 오거나 하위 쿼리가 하나의 식으로 사용된 경우에는 여러 값을 반환할 수 없습니다.)
											FROM #TEMP_SALES_PLAN 
											WHERE v_PROJECT_CODE NOT IN ( SELECT PROJECT_CODE FROM SCM_MST_PROJECT WITH(NOLOCK))
										   ) +']'+ N' Invalid Project Code !';
				SELECT @v_log_message */		 
				SET @v_log_type = 'INVALID';     
				SET	@s_code		= 'MSG00457';  --[E20250520-000572]_MESSAGE 코드로 사용 [MSG00457]: PROJECT_CODE: {0} 유효하지 않은 프로젝트 코드입니다! 	
PRINT @v_program_name + ' : A003-- VALIDATION :' + @s_code + ' PROJECT_CODE: ' + @s_validation + CONVERT(NVARCHAR(30), GETDATE(), 121);
				GOTO ERR_RTN
			END
			---------------------------------------------------------------------------------------------------------------
			-- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 (END) 
			---------------------------------------------------------------------------------------------------------------
		END
		---------------------------------------------------------------------------------------------------------------
		--[E20250520-000572]_VALIDATION 불필요한 변수 및 TEMP 테이블 데이터 생성건 주석처리 (START)
		---------------------------------------------------------------------------------------------------------------
		/*
		---------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611]_신규 입력 시 메져: SalesAmt_LOC 중복오류 체크 START
		---------------------------------------------------------------------------------------------------------------
			DECLARE @V_DUP_DIV NVARCHAR(30)
			DECLARE @V_DUP_PROJECT_CODE NVARCHAR(50)
			DECLARE @V_DUP_SCM_SITE_ID NVARCHAR(30)
			DECLARE @V_DUP_ITEM_ID NVARCHAR(100)
			DECLARE @V_DUP_DOM_EXP NVARCHAR(3)
			DECLARE @V_DUP_FCST_TYPE NVARCHAR(20)
			DECLARE @V_DUP_INCOTERMS NVARCHAR(10)
			DECLARE @V_DUP_MEASURE NVARCHAR(50)
			DECLARE @V_DUP_PLANT_SITE_ID NVARCHAR(30)
			DECLARE @V_DUP_YYYYMMDD NVARCHAR(30)
			DECLARE @V_DUP_REMARK_TEXT NVARCHAR(300) --[PJ2024-50611] 기타매출, Catch Up 테이블 분리
			DECLARE @V_DUP_CELL_PROD_SITE_ID NVARCHAR(60) --[PJ2025-50017] CELL_PROD_SITE_ID 추가

			INSERT INTO #TMP_DATA_DUP
			select T.*
			from #TEMP_SALES_PLAN T
			--INNER JOIN DM_PLN_SALES_PLAN P WITH(NOLOCK)
			INNER JOIN DM_PLN_SALES_ETC_PLAN P WITH(NOLOCK)--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
			ON T.v_DIVISION_ID = P.DIVISION_ID
			AND T.v_PROJECT_CODE = P.PROJECT_CODE
			AND T.v_SCM_SITE_ID = P.SCM_SITE_ID
			AND T.v_ITEM_ID = P.ITEM_ID
			AND T.v_DOM_EXP = P.DOM_EXP
			AND T.v_FCST_TYPE = P.FCST_TYPE
			AND T.v_INCOTERMS = P.INCOTERMS
			AND T.v_MEASURE = P.MEASURE
			AND T.v_PLANT_SITE_ID = P.PLANT_SITE_ID
			AND T.v_YYYYMMDD = P.YYYYMMDD
			AND T.v_TEXT = P.REMARK_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 조인 추가
			--AND T.v_QTY = P.QTY --PK가 같고 QTY도 같을 경우 튕겨낸다 --[E20250520-000572]_QTY 비교 로직은 지운다.
			WHERE T.v_MEASURE = 'SalesAmt_LOC'
			AND   T.v_active_flag = 'I' --[E20250520-000572]_신규로 들어온 데이터의 경우에만 해당 데이터를 비교한다. 

			IF (SELECT COUNT(*) FROM #TMP_DATA_DUP) > 0
			BEGIN
				SELECT TOP 1
				@V_DUP_DIV = v_DIVISION_ID
				,@V_DUP_PROJECT_CODE = v_PROJECT_CODE
				,@V_DUP_SCM_SITE_ID = v_SCM_SITE_ID
				,@V_DUP_ITEM_ID = v_ITEM_ID
				,@V_DUP_DOM_EXP = v_DOM_EXP
				,@V_DUP_FCST_TYPE = v_FCST_TYPE
				,@V_DUP_INCOTERMS = v_INCOTERMS
				,@V_DUP_MEASURE = v_MEASURE
				,@V_DUP_PLANT_SITE_ID = v_PLANT_SITE_ID
				,@V_DUP_YYYYMMDD = v_YYYYMMDD
				,@V_DUP_REMARK_TEXT = v_TEXT --[PJ2024-50611] 기타매출, Catch Up 테이블 분리
				,@V_DUP_CELL_PROD_SITE_ID = v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM #TMP_DATA_DUP
				ORDER BY v_YYYYMMDD

				SET @v_log_type = 'INVALID2';
				SET @v_log_message = ' *Div : ' + @V_DUP_DIV + CASE WHEN @V_DUP_DIV = '40' THEN '\r\n *End Customer : ' ELSE '\r\n *Project Code : ' END + @V_DUP_PROJECT_CODE 
				+ '\r\n *Sales Site : ' + @V_DUP_SCM_SITE_ID + '\r\n *Model : ' + @V_DUP_ITEM_ID + '\r\n *Customer Handbook : ' + @V_DUP_DOM_EXP + '\r\n *FCST Type : ' + @V_DUP_FCST_TYPE 
				+ '\r\n *INCOTERMS : ' + @V_DUP_INCOTERMS + '\r\n *Measure : ' + @V_DUP_MEASURE + '\r\n *Plant Site : ' + @V_DUP_PLANT_SITE_ID + '\r\n *YYYYMMDD : ' + @V_DUP_YYYYMMDD
			    + '\r\n *Cell Prod Site ID : ' + @V_DUP_CELL_PROD_SITE_ID; --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				GOTO ERR_RTN;
			END		
		--------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611]_신규 입력 시 메져: SalesAmt_LOC 중복오류 체크 END
		--------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------
		--[PJ2025-50017]_신규 입력 시 메져: RTF_SYS_RP 중복오류 체크 START
		--------------------------------------------------------------------------------------------------------------
		DECLARE @V_DUP_DIV_2				NVARCHAR(30)
		DECLARE @V_DUP_PROJECT_CODE_2		NVARCHAR(50)
		DECLARE @V_DUP_SCM_SITE_ID_2		NVARCHAR(30)
		DECLARE @V_DUP_ITEM_ID_2			NVARCHAR(100)
		DECLARE @V_DUP_DOM_EXP_2			NVARCHAR(3)
		DECLARE @V_DUP_FCST_TYPE_2			NVARCHAR(20)
		DECLARE @V_DUP_INCOTERMS_2			NVARCHAR(10)
		DECLARE @V_DUP_MEASURE_2			NVARCHAR(50)
		DECLARE @V_DUP_PLANT_SITE_ID_2		NVARCHAR(30)
		DECLARE @V_DUP_YYYYMMDD_2			NVARCHAR(30)
		DECLARE @V_DUP_CELL_PROD_SITE_ID_2	NVARCHAR(60) --[PJ2025-50017] CELL_PROD_SITE_ID 추가

		INSERT INTO #TMP_DATA_DUP
		SELECT T.*
		FROM #TEMP_SALES_PLAN T
		--INNER JOIN DM_PLN_SALES_PLAN P WITH(NOLOCK)
		INNER JOIN DM_PLN_SALES_PLAN P WITH(NOLOCK)--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
				ON T.v_DIVISION_ID			= P.DIVISION_ID
			   AND T.v_PROJECT_CODE			= P.PROJECT_CODE
			   AND T.v_SCM_SITE_ID			= P.SCM_SITE_ID
			   AND T.v_ITEM_ID				= P.ITEM_ID
			   AND T.v_DOM_EXP				= P.DOM_EXP
			   AND T.v_FCST_TYPE			= P.FCST_TYPE
			   AND T.v_INCOTERMS			= P.INCOTERMS
			   AND T.v_MEASURE				= P.MEASURE
			   AND T.v_PLANT_SITE_ID		= P.PLANT_SITE_ID
			   AND T.v_YYYYMMDD				= P.YYYYMMDD
			   --AND T.v_QTY					= P.QTY --PK가 같고 QTY도 같을 경우 튕겨낸다	--[E20250520-000572]_QTY 비교 로직은 지운다.
			   AND T.v_CELL_PROD_SITE_ID	= P.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		WHERE T.v_MEASURE = 'RTF_SYS_RP'
		AND   T.v_active_flag = 'I' --[E20250520-000572]_신규로 들어온 데이터의 경우에만 해당 데이터를 비교한다. 

		IF ( SELECT COUNT(*) FROM #TMP_DATA_DUP ) > 0
		BEGIN
			SELECT TOP 1 @V_DUP_DIV_2 = v_DIVISION_ID
					   , @V_DUP_PROJECT_CODE_2 = v_PROJECT_CODE
					   , @V_DUP_SCM_SITE_ID_2 = v_SCM_SITE_ID
					   , @V_DUP_ITEM_ID_2 = v_ITEM_ID
					   , @V_DUP_DOM_EXP_2 = v_DOM_EXP
					   , @V_DUP_FCST_TYPE_2 = v_FCST_TYPE
					   , @V_DUP_INCOTERMS_2 = v_INCOTERMS
					   , @V_DUP_MEASURE_2 = v_MEASURE
					   , @V_DUP_PLANT_SITE_ID_2 = v_PLANT_SITE_ID
					   , @V_DUP_YYYYMMDD_2 = v_YYYYMMDD
					   , @V_DUP_CELL_PROD_SITE_ID_2 = v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM #TMP_DATA_DUP
			ORDER BY v_YYYYMMDD

			SET @v_log_type = 'INVALID4';
			SET @v_log_message = ' *Div : ' + @V_DUP_DIV_2 + CASE WHEN @V_DUP_DIV_2 = '40' THEN '\r\n *End Customer : ' ELSE '\r\n *Project Code : ' END + @V_DUP_PROJECT_CODE_2
			+ '\r\n *Sales Site : ' + @V_DUP_SCM_SITE_ID_2 + '\r\n *Model : ' + @V_DUP_ITEM_ID_2 + '\r\n *Customer Handbook : ' + @V_DUP_DOM_EXP_2 + '\r\n *FCST Type : ' + @V_DUP_FCST_TYPE_2
			+ '\r\n *INCOTERMS : ' + @V_DUP_INCOTERMS_2 + '\r\n *Measure : ' + @V_DUP_MEASURE_2 + '\r\n *Plant Site : ' + @V_DUP_PLANT_SITE_ID_2 + '\r\n *YYYYMMDD : ' + @V_DUP_YYYYMMDD_2
			+ '\r\n *Cell Prod Site ID : ' + @V_DUP_CELL_PROD_SITE_ID_2; --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			GOTO ERR_RTN;
		END
		--------------------------------------------------------------------------------------------------------------
		--[PJ2025-50017]_신규 입력 시 메져: RTF_SYS_RP 중복오류 체크 END
		--------------------------------------------------------------------------------------------------------------
		*/
		---------------------------------------------------------------------------------------------------------------
		--[E20250520-000572]_VALIDATION 불필요한 변수 및 TEMP 테이블 데이터 생성건 주석처리 (END)
		---------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------
		--[E20250520-000572]_INVALID2, INVALID4 VALIDATION 통합해서 사용한다. (START)
		--[MSG00428]: 신규 입력 데이터 중 중복된 데이터가 있습니다.\r\n{0}
		---------------------------------------------------------------------------------------------------------------
		INSERT INTO #TMP_DATA_DUP
		(  v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_ITEM_ID, v_DOM_EXP
		 , v_FCST_TYPE, v_INCOTERMS, v_MEASURE, v_PLANT_SITE_ID, v_YYYYMMDD  
		 , v_CELL_PROD_SITE_ID	)
		SELECT LOC.v_DIVISION_ID, LOC.v_PROJECT_CODE, LOC.v_SCM_SITE_ID, LOC.v_ITEM_ID, LOC.v_DOM_EXP
			 , LOC.v_FCST_TYPE, LOC.v_INCOTERMS, LOC.v_MEASURE, LOC.v_PLANT_SITE_ID, LOC.v_YYYYMMDD
			 , LOC.v_CELL_PROD_SITE_ID
		FROM #TEMP_SALES_PLAN_SalesAmt_LOC LOC
		INNER JOIN DM_PLN_SALES_ETC_PLAN P WITH(NOLOCK)
				ON  LOC.v_DIVISION_ID	= P.DIVISION_ID
			   AND LOC.v_PROJECT_CODE	= P.PROJECT_CODE
			   AND LOC.v_SCM_SITE_ID	= P.SCM_SITE_ID
			   AND LOC.v_ITEM_ID		= P.ITEM_ID
			   AND LOC.v_DOM_EXP		= P.DOM_EXP
			   AND LOC.v_FCST_TYPE		= P.FCST_TYPE
			   AND LOC.v_INCOTERMS		= P.INCOTERMS
			   AND LOC.v_MEASURE		= P.MEASURE
			   AND LOC.v_PLANT_SITE_ID	= P.PLANT_SITE_ID
			   AND LOC.v_YYYYMMDD		= P.YYYYMMDD
			   AND LOC.v_TEXT			= P.REMARK_TEXT
		WHERE LOC.v_active_flag	= 'I'
		UNION ALL 
		SELECT RTF.v_DIVISION_ID, RTF.v_PROJECT_CODE, RTF.v_SCM_SITE_ID, RTF.v_ITEM_ID, RTF.v_DOM_EXP
			 , RTF.v_FCST_TYPE, RTF.v_INCOTERMS, RTF.v_MEASURE, RTF.v_PLANT_SITE_ID, RTF.v_YYYYMMDD
			 , RTF.v_CELL_PROD_SITE_ID
		FROM #TEMP_SALES_PLAN_RTF_SYS_RP RTF
		INNER JOIN DM_PLN_SALES_PLAN P WITH(NOLOCK)
				ON RTF.v_DIVISION_ID			= P.DIVISION_ID
			   AND RTF.v_PROJECT_CODE			= P.PROJECT_CODE
			   AND RTF.v_SCM_SITE_ID			= P.SCM_SITE_ID
			   AND RTF.v_ITEM_ID				= P.ITEM_ID
			   AND RTF.v_DOM_EXP				= P.DOM_EXP
			   AND RTF.v_FCST_TYPE				= P.FCST_TYPE
			   AND RTF.v_INCOTERMS				= P.INCOTERMS
			   AND RTF.v_MEASURE				= P.MEASURE
			   AND RTF.v_PLANT_SITE_ID			= P.PLANT_SITE_ID
			   AND RTF.v_YYYYMMDD				= P.YYYYMMDD
			   AND RTF.v_CELL_PROD_SITE_ID		= P.CELL_PROD_SITE_ID
		WHERE RTF.v_active_flag	= 'I' 

		IF ( SELECT COUNT(*) FROM #TMP_DATA_DUP ) > 0
		BEGIN
			SET @s_validation = ( SELECT TOP 1 + CHAR(10) + '*Div : ' + ISNULL(v_DIVISION_ID ,'') 
								+ CHAR(10) + CASE WHEN v_DIVISION_ID = '40' THEN  '*End Customer : ' ELSE '*Project Code : ' END + ISNULL(v_PROJECT_CODE ,'') 
								+ CHAR(10) + '*Sales Site : ' + ISNULL(v_SCM_SITE_ID ,'') 
								+ CHAR(10) + '*Model : ' + ISNULL(v_ITEM_ID ,'') 
								+ CHAR(10) + '*Customer Handbook : ' + ISNULL(v_DOM_EXP ,'') 
								+ CHAR(10) + '*FCST Type : ' + ISNULL(v_FCST_TYPE ,'') 
								+ CHAR(10) + '*INCOTERMS : ' + ISNULL(v_INCOTERMS ,'') 
								+ CHAR(10) + '*Measure : ' + ISNULL(v_MEASURE ,'') 
								+ CHAR(10) + '*Plant Site : ' + ISNULL(v_PLANT_SITE_ID ,'') 
								+ CHAR(10) + '*YYYYMMDD : ' + ISNULL(v_YYYYMMDD ,'') 
								+ CHAR(10) + '*Cell Prod Site ID : ' + ISNULL(v_CELL_PROD_SITE_ID ,'') 										
								+ CHAR(10) + CHAR(10)
								FROM #TMP_DATA_DUP T
								ORDER BY v_YYYYMMDD )

			IF (@s_validation IS NOT NULL)
			BEGIN
				SET @v_log_type = 'INVALID';					
				SET	@s_code		= 'MSG00428';  --[E20250520-000572]_MESSAGE 코드로 사용 [MSG00428]: 신규 입력 데이터 중 중복된 데이터가 있습니다.\r\n{0}	  
PRINT @v_program_name + ' : A004-- VALIDATION :' + @s_code + ' TEXT: ' + @s_validation + CONVERT(NVARCHAR(30), GETDATE(), 121);
				GOTO ERR_RTN
			END
		END
		---------------------------------------------------------------------------------------------------------------
		--[E20250520-000572]_INVALID2, INVALID4 VALIDATION 통합해서 사용한다. (END)
		---------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611]Catch Up 일 경우 SSPM에 있는 모델만 등록 가능 (START)
		--------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------
		--[E20250520-000572]_변수를 선언하여, 해당 변수의 값을 가지고 가도록 수정함 (원소스 주석처리) (START)
		--[MSG00458]: MODEL: {0} \r\n유효하지 않은 모델입니다!
		---------------------------------------------------------------------------------------------------------------
		/*
	    IF ( SELECT COUNT(1) FROM #TEMP_SALES_PLAN TMP
			 WHERE TMP.v_DIVISION_ID	= '40'
			 AND   TMP.v_MEASURE		= 'Catch_Up'
			 AND NOT EXISTS ( SELECT 1 FROM SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
							  WHERE ITM.DIVISION_ID = TMP.v_DIVISION_ID
							  AND ITM.PROJECT_CODE	= TMP.v_PROJECT_CODE
							  AND ITM.SCM_SITE_ID	= TMP.v_SCM_SITE_ID
							  AND ITM.ITEM_ID		= TMP.v_ITEM_ID	)) > 0*/			
		SET @s_validation = ( SELECT TOP 1 A.v_ITEM_ID FROM #TEMP_SALES_PLAN A
								LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK)
								  			 ON A.v_DIVISION_ID		= B.DIVISION_ID
								  			AND A.v_PROJECT_CODE	= B.PROJECT_CODE
								  			AND A.v_SCM_SITE_ID		= B.SCM_SITE_ID
								  			AND A.v_ITEM_ID			= B.ITEM_ID
								WHERE A.v_DIVISION_ID	= '40'   
								AND   A.v_MEASURE		= 'Catch_Up'
								AND   ISNULL(B.ITEM_ID, '') = '');
		---------------------------------------------------------------------------------------------------------------
		--[E20250520-000572]_변수를 선언하여, 해당 변수의 값을 가지고 가도록 수정함 (원소스 주석처리) (END)
		---------------------------------------------------------------------------------------------------------------		
		IF (@s_validation IS NOT NULL)	--[E20250520-000572]_생성된 데이터가 존재하는 경우에만 발생한다.		  
		BEGIN
			SET @v_log_type = 'INVALID';			
			SET	@s_code		= 'MSG00458';  --[E20250520-000572]_MESSAGE 코드로 사용 [MSG00458]: MODEL: {0} \r\n유효하지 않은 모델입니다!
PRINT @v_program_name + ' : A005-- VALIDATION :' + @s_code + ' MODEL: ' + @s_validation + CONVERT(NVARCHAR(30), GETDATE(), 121);
			---------------------------------------------------------------------------------------------------------------
			--[E20250520-000572]_MESSAGE 코드로 작성하는 것으로 진행함으로 해당 부분 주석처리 START
			--------------------------------------------------------------------------------------------------------------- 
			/*
			SET @v_log_message = '['+ ( SELECT TOP 1 v_ITEM_ID FROM #TEMP_SALES_PLAN TMP
										WHERE TMP.v_DIVISION_ID = '40'
										AND TMP.v_MEASURE		= 'Catch_Up'
										AND NOT EXISTS ( SELECT 1 FROM SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
														 WHERE ITM.DIVISION_ID = TMP.v_DIVISION_ID
														 AND ITM.PROJECT_CODE = TMP.v_PROJECT_CODE
														 AND ITM.SCM_SITE_ID = TMP.v_SCM_SITE_ID
														 AND ITM.ITEM_ID = TMP.v_ITEM_ID )) +']'+ N' Invalid Site Item ID !';
			SELECT @v_log_message	*/
			---------------------------------------------------------------------------------------------------------------
			--[E20250520-000572]_MESSAGE 코드로 작성하는 것으로 진행함으로 해당 부분 주석처리 END
			--------------------------------------------------------------------------------------------------------------- 
			GOTO ERR_RTN 
		END
		--------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611]Catch Up 일 경우 SSPM에 있는 모델만 등록 가능 (END)
		--------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611]Catch Up 일 경우 Sales Price에 일치하는 데이터가 있을 경우에만 처리 (START)
		--[MSG00328]: 판가 미입력 상태입니다. 판가 입력 후 진행해 주세요.
		--------------------------------------------------------------------------------------------------------------		
		SELECT SEGMENT2 
		INTO #TMP_FCST_TYPE 
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST WITH(NOLOCK)
		WHERE 1 = 1
		AND   MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
		AND   MST.SEGMENT1    = 'FCST_TYPE'
		AND   VALID_YN        = 'Y' 

	    IF ( SELECT COUNT(1)  
		     FROM #TEMP_SALES_PLAN TMP
			 WHERE TMP.v_DIVISION_ID	= '40'
			 AND   TMP.v_MEASURE		= 'Catch_Up'
			 AND   TMP.v_FCST_TYPE NOT IN ( SELECT SEGMENT2 from #TMP_FCST_TYPE )--룩업에 등록된 FCST_TYPE은  필수 입력 체크 제외
			 AND NOT EXISTS ( SELECT 1 FROM DM_PLN_CFM_SELLING_PRICE FP WITH(NOLOCK)
							  WHERE FP.DIVISION_ID				= TMP.v_DIVISION_ID
							  AND	FP.PROJECT_CODE				= TMP.v_PROJECT_CODE
							  AND	FP.SCM_SITE_ID				= TMP.v_SCM_SITE_ID
							  AND	FP.PLANT_SITE_ID			= TMP.v_PLANT_SITE_ID
							  AND	FP.ITEM_ID					= TMP.v_ITEM_ID
							  --AND FP.CURRENCY = TMP.v_CURRENCY --화면에서 필수입력값이긴 하지만, 다른 SP에서도 CURRENCY는 고려를 안하므로 여기서도 CURRENCY는 제외
							  AND	SUBSTRING(FP.YYYYMMDD,1,6)	= SUBSTRING(TMP.v_YYYYMMDD,1,6)  --월로 비교
							  AND	FP.MEASURE					= 'LOC'
							  AND	FP.DOM_EXP					= TMP.v_DOM_EXP
							  AND	FP.FCST_TYPE				= TMP.v_FCST_TYPE
							  AND	FP.INCOTERMS				= TMP.v_INCOTERMS
							  AND	FP.CELL_PROD_SITE_ID		= TMP.v_CELL_PROD_SITE_ID )) > 0
	    BEGIN
				--SET @v_log_type = 'INVALID_MSG'; --[E20250520-000572]_LOG_TYPE은 VALIDATION은 INVALID로 통일, 과거소스는 주석처리
				--SET @v_log_message = 'MSG00328'; --[E20250520-000572]_MESSAGE 코드는 하나의 변수로 통일적으로 받는다. 하여 주석처리
				SET @v_log_type		= 'INVALID';	--[E20250520-000572]_LOG_TYPE은 VALIDATION은 INVALID로 통일
				SET	@s_code			= 'MSG00328';	--[E20250520-000572]_MESSAGE 코드로 사용 [MSG00328]: 판가 미입력 상태입니다. 판가 입력 후 진행해 주세요.
				SET	@s_validation	= ' ';			--[E20250520-000572]_형식을 동일하게 맞춰준다.
PRINT @v_program_name + ' : A006-- VALIDATION :' + @s_code + CONVERT(NVARCHAR(30), GETDATE(), 121);
				GOTO ERR_RTN 
	    END
		--------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611]Catch Up 일 경우 Sales Price에 일치하는 데이터가 있을 경우에만 처리 (END)
		--------------------------------------------------------------------------------------------------------------		
		--------------------------------------------------------------------------------------------------------------
		--■■■■■■■■■■ 40 Validation 필요 대상 : RMA 음수값 확인
		--------------------------------------------------------------------------------------------------------------		
		--------------------------------------------------------------------------------------------------------------
		-- [PJ2025-50017] RTF_SYS_RP MEASURE 저장기능으로 인한 RMA 음수값 확인 VALIDATION CHECK (START)
		-- [MSG00459]: 반품수량(RMA)은 음수값만 입력가능합니다!
		--------------------------------------------------------------------------------------------------------------
		IF ( SELECT ISNULL(COUNT(*), 0) FROM #TEMP_SALES_PLAN 
			 WHERE v_FCST_TYPE = 'RMA'
			 AND   v_MEASURE   IN ('RTF_SYS_RP')
			 --AND   ISNULL(CAST(v_QTY AS NUMERIC(30,10)), 0) > 0) > 0 --[E20250520-000572]_위에서 NUMERIC처리를 함으로 주석처리한다.
			 AND   ISNULL(v_QTY, 0) > 0) > 0 --[E20250520-000572]_수정 
		BEGIN
			--SET @v_log_type		= 'INVALID5'; --[E20250520-000572]_LOG_TYPE은 VALIDATION은 INVALID로 통일, 과거소스는 주석처리
			--SET @v_description	= N'반품수량(RMA)은 음수값만 입력가능합니다!'--[E20250520-000572]_MESSAGE_CODE를 사용하기로 하였으므로 주석처리
			SET @v_log_type		= 'INVALID';	--[E20250520-000572]_LOG_TYPE은 VALIDATION은 INVALID로 통일, 과거소스는 주석처리
			SET	@s_code			= 'MSG00459';	--[E20250520-000572]_MESSAGE 코드로 사용 [MSG00459]: 반품수량(RMA)은 음수값만 입력가능합니다!
			SET	@s_validation	= ' ';			--[E20250520-000572]_형식을 동일하게 맞춰준다.
PRINT @v_program_name + ' : A007-- VALIDATION :' + @s_code  + '/ '+CONVERT(NVARCHAR(30), GETDATE(), 121);
			GOTO ERR_RTN
		END
		--------------------------------------------------------------------------------------------------------------
		--[PJ2025-50017] RTF_SYS_RP MEASURE 저장기능으로 인한 RMA 음수값 확인 VALIDATION CHECK (END)
		--------------------------------------------------------------------------------------------------------------	
		--------------------------------------------------------------------------------------------------------------
		--■■■■■■■■■■ 40 Validation 필요 대상 : RMA 이외 정수값 확인
		--------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------		
		-- [PJ2025-50017] RTF_SYS_RP MEASURE 저장기능으로 인한 RMA 음수값 확인 VALIDATION CHECK (START)
		-- [MSG00460]: 정수값만 입력가능합니다!
		--------------------------------------------------------------------------------------------------------------
		IF ( SELECT ISNULL(COUNT(*) ,0) FROM #TEMP_SALES_PLAN 
			 WHERE v_FCST_TYPE <> 'RMA'
             AND   v_MEASURE   IN ('RTF_SYS_RP')
			 --AND   ISNULL(CAST(v_QTY AS NUMERIC(30,10)), 0) < 0) > 0 --[E20250520-000572]_위에서 NUMERIC처리를 함으로 주석처리한다.
			 AND   ISNULL(v_QTY, 0) < 0) > 0 --[E20250520-000572]_수정 
		BEGIN
			--SET @v_log_type		= 'INVALID5'; --[E20250520-000572]_LOG_TYPE은 VALIDATION은 INVALID로 통일, 과거소스는 주석처리
			--SET @v_description	= N'정수값만 입력가능합니다!'--[E20250520-000572]_MESSAGE_CODE를 사용하기로 하였으므로 주석처리
			SET @v_log_type		= 'INVALID';	--[E20250520-000572]_LOG_TYPE은 VALIDATION은 INVALID로 통일, 과거소스는 주석처리
			SET	@s_code			= 'MSG00460';	--[E20250520-000572]_MESSAGE 코드로 사용 [MSG00460]: 정수값만 입력가능합니다!
			SET	@s_validation	= ' ';			--[E20250520-000572]_형식을 동일하게 맞춰준다.
PRINT @v_program_name + ' : A008-- VALIDATION :' + @s_code + '/ '+ CONVERT(NVARCHAR(30), GETDATE(), 121);
			GOTO ERR_RTN
		END
		--------------------------------------------------------------------------------------------------------------	
		-- [PJ2025-50017] RTF_SYS_RP MEASURE 저장기능으로 인한 RMA 음수값 확인 VALIDATION CHECK (END)
		--------------------------------------------------------------------------------------------------------------		
		--------------------------------------------------------------------------------------------------------------	
		--■■■■■■■■■■ 40 Validation 필요 대상 : RTF[R+P] 수정 할 때, Sales Price가 같은 주차에 있는지를 체크한다. (START)
		--[MSG00462]: 동일 주차에 Price 정보가 아직 등록되지 않았습니다.\r\n	
		--------------------------------------------------------------------------------------------------------------	
		--수정 할 RTF에 해당하는 Sales Price가 없는 데이터의 수
		DECLARE @V_CNT INT = 0 		
		--[E20260331-000648]_81, 81_JV 사업부와 40 사업부 바라보는 테이블 정보가 다르므로, 분기후 로직 추가한다. (START)
		IF ( SELECT COUNT(1) FROM #TEMP_SALES_PLAN WHERE v_DIVISION_ID = '40' ) > 0
		BEGIN 		
			--[E20260331-000648]_동일한 TB에 INSERT하는 구조로 INTO가 아닌 INSERT로 변경 원소스 주석 (START)
			--SELECT @V_CNT = COUNT(1) --[E20250520-000572]_하단에도 똑같은 데이터를 쓰므로, TEMP에 우선 담는다. 원소스는 주석처리
			INSERT INTO #TEMP_PRICE_RTF_SYS_RP
			( V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, v_FCST_TYPE
			, V_INCOTERMS, V_PLANT_SITE_ID, V_CELL_PROD_SITE_ID, WEEK_NAME	)
			SELECT A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.v_FCST_TYPE
				 , A.V_INCOTERMS, A.V_PLANT_SITE_ID, A.V_CELL_PROD_SITE_ID, A.WEEK_NAME
			--INTO #TEMP_PRICE_RTF_SYS_RP --[E20250520-000572]_TEMP테이블에 담는형태로 변경, 필요한 컬럼만 받는다. --[E20260331-000648]_원소스 주석처리
			--[E20260331-000648]_동일한 TB에 INSERT하는 구조로 INTO가 아닌 INSERT로 변경 원소스 주석 (END)
			FROM ( SELECT AA.V_YYYYMMDD, AA.V_DIVISION_ID, AA.V_PROJECT_CODE, AA.V_SCM_SITE_ID, AA.V_PLANT_SITE_ID
						, AA.V_CELL_PROD_SITE_ID, AA.V_ITEM_ID, AA.V_DOM_EXP, AA.V_FCST_TYPE, AA.V_INCOTERMS
						, AA.V_MEASURE, M.BASIS_START_DATE, AA.v_QTY, M.WEEK_NAME
				   --FROM #TEMP_SALES_PLAN AA
				   FROM #TEMP_SALES_PLAN_RTF_SYS_RP AA --RTF_SYS_RP 비교 테이블로 변경한다. SM_20250502
				   JOIN SCM_SYS_CALENDAR_M M WITH(NOLOCK)
					 ON AA.v_YYYYMMDD = M.BASIS_YYYYMMDD ) A
			LEFT JOIN ( SELECT BB.YYYYMMDD, BB.DIVISION_ID, BB.PROJECT_CODE, BB.SCM_SITE_ID, BB.PLANT_SITE_ID
			   				 , BB.CELL_PROD_SITE_ID, BB.ITEM_ID, BB.DOM_EXP, BB.FCST_TYPE, BB.INCOTERMS
							 , BB.MEASURE, M.BASIS_START_DATE, BB.END_CUSTOMER
						FROM DM_PLN_CFM_SELLING_PRICE BB WITH(NOLOCK)
						JOIN SCM_SYS_CALENDAR_M M WITH(NOLOCK)
						  ON BB.YYYYMMDD = M.BASIS_YYYYMMDD
						WHERE BB.MEASURE = 'LOC' --굳이 더 많은 모수를 가지고 올 필요가 없으므로, 애초에 LOC만 가져온다. SM_20250502
					  ) B
				   ON A.v_DIVISION_ID			= B.DIVISION_ID
				  AND A.v_PROJECT_CODE			= B.PROJECT_CODE
				  AND A.v_PROJECT_CODE			= B.END_CUSTOMER
				  AND A.v_SCM_SITE_ID			= B.SCM_SITE_ID
				  AND A.v_PLANT_SITE_ID			= B.PLANT_SITE_ID
				  AND A.v_CELL_PROD_SITE_ID		= B.CELL_PROD_SITE_ID
				  AND A.v_ITEM_ID				= B.ITEM_ID
				  AND A.v_DOM_EXP				= B.DOM_EXP
				  AND A.v_FCST_TYPE				= B.FCST_TYPE
				  AND A.v_INCOTERMS				= B.INCOTERMS
				  AND A.BASIS_START_DATE		= B.BASIS_START_DATE
				  --AND A.v_MEASURE = 'RTF_SYS_RP'  --[E20250520-000572]_RTF_SYS_RP 비교 테이블로 변경하면, 굳이 조건 쓸 필요가 없음 
				  --AND B.MEASURE = 'LOC'
				  --AND A.v_QTY <> 0   --[E20250520-000572]_조건이 잘못걸린것으로 확인되어 하단에 조건 으로 옮김 1
			WHERE B.BASIS_START_DATE IS NULL 
			AND   A.v_FCST_TYPE <> 'ETC'
			--AND ISNULL(CAST(A.v_QTY AS NUMERIC(30,10)), 0) <> 0  --테이블을 생성할때 당시 VARCHAR이기 떄문에 비교하려면 NUMERIC으로 변경해야한다.SM_20250502 --[E20250520-000572]_위에서 NUMERIC처리를 함으로 주석처리한다.
			AND   ISNULL(A.v_QTY, 0) <> 0 --[E20250520-000572]_수정 
		END
		ELSE --[E20260331-000648]_40 사업부 외 처리
		BEGIN
			--[E20260331-000648]_동일한 TB에 INSERT하는 구조로 INTO가 아닌 INSERT로 변경 원소스 주석 (START)
			INSERT INTO #TEMP_PRICE_RTF_SYS_RP
			( V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, v_FCST_TYPE
			, V_INCOTERMS, V_PLANT_SITE_ID, V_CELL_PROD_SITE_ID, WEEK_NAME	)
			SELECT A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.v_FCST_TYPE
				 , A.V_INCOTERMS, A.V_PLANT_SITE_ID, A.V_CELL_PROD_SITE_ID, A.WEEK_NAME
			--INTO #TEMP_PRICE_RTF_SYS_RP  --[E20260331-000648]_원소스 주석처리
			--[E20260331-000648]_동일한 TB에 INSERT하는 구조로 INTO가 아닌 INSERT로 변경 원소스 주석 (END)
			FROM ( SELECT AA.V_YYYYMMDD, AA.V_DIVISION_ID, AA.V_PROJECT_CODE, AA.V_SCM_SITE_ID, AA.V_PLANT_SITE_ID
						, AA.V_CELL_PROD_SITE_ID, AA.V_ITEM_ID, AA.V_DOM_EXP, AA.V_FCST_TYPE, AA.V_INCOTERMS
						, AA.V_MEASURE, M.BASIS_START_DATE, AA.v_QTY, M.WEEK_NAME
				   FROM #TEMP_SALES_PLAN_RTF_SYS_RP AA 
				   JOIN SCM_SYS_CALENDAR_M M WITH(NOLOCK)
					 ON AA.v_YYYYMMDD = M.BASIS_YYYYMMDD ) A
			LEFT JOIN ( SELECT BB.YYYYMMDD, BB.DIVISION_ID, BB.PROJECT_CODE, BB.SCM_SITE_ID, BB.PLANT_SITE_ID
			   				 , BB.ITEM_ID, BB.DOM_EXP, BB.FCST_TYPE, BB.INCOTERMS
							 , BB.MEASURE, M.BASIS_START_DATE
						FROM SCM_MST_FUTURE_PRICE BB WITH(NOLOCK)
						JOIN SCM_SYS_CALENDAR_M M WITH(NOLOCK)
						  ON BB.YYYYMMDD = M.BASIS_YYYYMMDD
						WHERE BB.MEASURE = 'LOC' --굳이 더 많은 모수를 가지고 올 필요가 없으므로, 애초에 LOC만 가져온다. SM_20250502
					  ) B
				   ON A.v_DIVISION_ID			= B.DIVISION_ID
				  AND A.v_PROJECT_CODE			= B.PROJECT_CODE
				  AND A.v_SCM_SITE_ID			= B.SCM_SITE_ID
				  AND A.v_PLANT_SITE_ID			= B.PLANT_SITE_ID
				  AND A.v_ITEM_ID				= B.ITEM_ID
				  AND A.v_DOM_EXP				= B.DOM_EXP
				  AND A.v_FCST_TYPE				= B.FCST_TYPE
				  AND A.v_INCOTERMS				= B.INCOTERMS
				  AND A.BASIS_START_DATE		= B.BASIS_START_DATE
			WHERE B.BASIS_START_DATE IS NULL 
			AND   A.v_FCST_TYPE <> 'ETC'
			AND   ISNULL(A.v_QTY, 0) <> 0 --[E20250520-000572]_수정 
		END
		--[E20260331-000648]_81, 81_JV 사업부와 40 사업부 바라보는 테이블 정보가 다르므로, 분기후 로직 추가한다. (END)	

		--------------------------------------------------------------------------------------------------------------	
		--[E20250520-000572]_TEMP테이블을 생성했으므로, 굳이 하단의 쿼리를 작성해서 사용하지 않아도 된다. 주석처리 (START)
		--------------------------------------------------------------------------------------------------------------	
		/*	SELECT TOP 1 
				   @v_description = CASE WHEN @V_CNT > 0 THEN                     'Project Code________ : '      + ISNULL(A.v_PROJECT_CODE,'') 
																	 + CHAR(10) + 'Sales site_____________ : '   + ISNULL(A.V_SCM_SITE_ID ,'')
																	 + CHAR(10) + 'Model________________ : '     + ISNULL(A.V_ITEM_ID ,'')  
																	 + CHAR(10) + 'Customs Handbook__ : '        + ISNULL(A.V_DOM_EXP ,'')    
																	 + CHAR(10) + 'Fcst Type_____________ : '    + 
															 					   ISNULL((SELECT TOP 1 SEGMENT2
															 						FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
															 						WHERE 1=1
															 						AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
															 						AND MST.SEGMENT1    = A.v_FCST_TYPE
															 						),'')
																	 + CHAR(10) + 'Incoterms____________ : '     + ISNULL(A.V_INCOTERMS ,'')    
																	 + CHAR(10) + 'Plant Site___________ : '     + ISNULL(A.V_PLANT_SITE_ID ,'') 
																	 + CHAR(10) + 'Cell Prod Site___________ : ' + ISNULL(A.V_CELL_PROD_SITE_ID ,'')
																	 + CHAR(10) + 'Week_________ : '         + ISNULL(A.WEEK_NAME,'')  
																	 + CHAR(10) + N'동일 주차에 Price 정보가 아직 등록되지 않았습니다.'
									ELSE '' END
			FROM ( SELECT AA.V_YYYYMMDD, AA.V_DIVISION_ID, AA.V_PROJECT_CODE, AA.V_SCM_SITE_ID, AA.V_PLANT_SITE_ID
						, AA.V_CELL_PROD_SITE_ID, AA.V_ITEM_ID, AA.V_DOM_EXP, AA.V_FCST_TYPE, AA.V_INCOTERMS
						, AA.V_MEASURE, M.BASIS_START_DATE, AA.v_QTY, M.WEEK_NAME
				  --FROM #TEMP_SALES_PLAN AA		  
				   FROM #TEMP_SALES_PLAN_RTF_SYS_RP AA --RTF_SYS_RP 비교 테이블로 변경한다. SM_20250502
				   JOIN SCM_SYS_CALENDAR_M M WITH(NOLOCK)
					 ON AA.v_YYYYMMDD = M.BASIS_YYYYMMDD )A
			LEFT JOIN ( SELECT BB.YYYYMMDD, BB.DIVISION_ID, BB.PROJECT_CODE, BB.SCM_SITE_ID, BB.PLANT_SITE_ID
							 , BB.CELL_PROD_SITE_ID, BB.ITEM_ID, BB.DOM_EXP, BB.FCST_TYPE, BB.INCOTERMS, BB.MEASURE
							 , M.BASIS_START_DATE, BB.END_CUSTOMER
						FROM DM_PLN_CFM_SELLING_PRICE BB WITH(NOLOCK)
						JOIN SCM_SYS_CALENDAR_M M WITH(NOLOCK)
						  ON BB.YYYYMMDD = M.BASIS_YYYYMMDD
						WHERE BB.MEASURE = 'LOC' --굳이 더 많은 모수를 가지고 올 필요가 없으므로, 애초에 LOC만 가져온다. SM_20250502
						) B
				   ON A.v_DIVISION_ID		= B.DIVISION_ID
				  AND A.v_PROJECT_CODE      = B.PROJECT_CODE
				  AND A.v_PROJECT_CODE      = B.END_CUSTOMER
				  AND A.v_SCM_SITE_ID       = B.SCM_SITE_ID
				  AND A.v_PLANT_SITE_ID     = B.PLANT_SITE_ID
				  AND A.v_CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
				  AND A.v_ITEM_ID           = B.ITEM_ID
				  AND A.v_DOM_EXP           = B.DOM_EXP
				  AND A.v_FCST_TYPE         = B.FCST_TYPE
				  AND A.v_INCOTERMS         = B.INCOTERMS
				  AND A.BASIS_START_DATE    = B.BASIS_START_DATE
				  --AND A.v_MEASURE = 'RTF_SYS_RP'  --RTF_SYS_RP 비교 테이블로 변경하면, 굳이 조건 쓸 필요가 없음 SM_20250502
				  --AND B.MEASURE = 'LOC'
				  --AND A.v_QTY <> 0  --조건이 잘못걸린것으로 확인되어 하단에 조건 으로 옮김 SM_20250501
			WHERE B.BASIS_START_DATE IS NULL 
			AND   A.v_FCST_TYPE <> 'ETC'
			--AND   ISNULL(CAST(A.v_QTY AS NUMERIC(30,10)), 0) <> 0  --테이블을 생성할때 당시 VARCHAR이기 떄문에 비교하려면 NUMERIC으로 변경해야한다.SM_20250502 --[E20250520-000572]_위에서 NUMERIC처리를 함으로 주석처리한다.
			AND   ISNULL(A.v_QTY, 0) <> 0 --[E20250520-000572]_수정 */
		--------------------------------------------------------------------------------------------------------------	
		--[E20250520-000572]_TEMP테이블을 생성했으므로, 굳이 하단의 쿼리를 작성해서 사용하지 않아도 된다. 주석처리 (END)
		--------------------------------------------------------------------------------------------------------------	
		--IF ( @V_CNT > 0) --[E20250520-000572]_TEMP테이블을 생성했으므로, 그 데이터로 쓰면됨, 하여 과거소스 주석처리
		IF ( SELECT  COUNT(*) FROM #TEMP_PRICE_RTF_SYS_RP ) > 0  --[E20250520-000572]_TEMP테이블을 생성했으므로, 그 데이터로 쓰면됨
		BEGIN			
			SET @s_validation = ( SELECT TOP 1 + CHAR(10) + 'Project Code________ : '  + ISNULL(v_PROJECT_CODE ,'') 
								  			   + CHAR(10) + 'Sales site_____________ : ' + ISNULL(V_SCM_SITE_ID ,'') 
											   + CHAR(10) + 'Model________________ : ' + ISNULL(V_ITEM_ID ,'') 
											   + CHAR(10) + 'Customs Handbook__ : ' + ISNULL(V_DOM_EXP ,'') 
											   + CHAR(10) + 'Fcst Type_____________ : ' + ISNULL((SELECT TOP 1 SEGMENT2
															 									  FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
															 									  WHERE 1=1
															 									  AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
															 									  AND MST.SEGMENT1    = v_FCST_TYPE), '')
											   + CHAR(10) + 'Incoterms____________ : ' + ISNULL(v_INCOTERMS ,'') 
											   + CHAR(10) + 'Plant Site___________ : ' + ISNULL(v_PLANT_SITE_ID ,'') 
											   + CHAR(10) + 'Cell Prod Site___________ : ' + ISNULL(v_CELL_PROD_SITE_ID ,'') 	
											   + CHAR(10) + 'Week_________ : ' + ISNULL(WEEK_NAME ,'') 									
											   + CHAR(10) + CHAR(10)
												FROM #TEMP_PRICE_RTF_SYS_RP )

			IF (@s_validation IS NOT NULL)
			BEGIN					 
				--SET @v_log_type		= 'INVALID5'; --[E20250520-000572]_LOG_TYPE은 VALIDATION은 INVALID로 통일, 과거소스는 주석처리
				SET @v_log_type = 'INVALID';
				SET	@s_code		= 'MSG00462';  --[E20250520-000572]_MESSAGE 코드로 사용 [MSG00462]: 동일 주차에 Price 정보가 아직 등록되지 않았습니다.\r\n	 
PRINT @v_program_name + ' : A009-- VALIDATION :' + @s_code + ' TEXT: ' + @s_validation + ' / ' +  CONVERT(NVARCHAR(30), GETDATE(), 121);
				GOTO ERR_RTN
			END
		END
		--------------------------------------------------------------------------------------------------------------	
		--■■■■■■■■■■ 40 Validation 필요 대상 : RTF[R+P] 수정 할 때, Sales Price가 같은 주차에 있는지를 체크한다.(END)
		--------------------------------------------------------------------------------------------------------------	
		--------------------------------------------------------------------------------------------------------------	
		--[E20250401-000548] SMS 선감지 대상 정리 (START)
		--DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, REMARK_TEXT, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID 키값 이외에도 
		--동일한 일자에 CURRENCY가 2개인 경우는 저장할 수 없다.
		--[MSG00461]: 동일한 일자에 DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, TEXT, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE가 동일한 CURRENCY는 등록할 수 없습니다.\r\n
		--------------------------------------------------------------------------------------------------------------	
		SET @s_validation = ( SELECT TOP 1 + CHAR(10) + 'Div: '  + ISNULL(v_DIVISION_ID ,'') 
								  		   + CHAR(10) + 'Project Code: ' + ISNULL(v_PROJECT_CODE ,'') 
										   + CHAR(10) + 'Scm Site Id: ' + ISNULL(v_SCM_SITE_ID ,'') 
										   + CHAR(10) + 'Model: ' + ISNULL(v_ITEM_ID ,'') 
										   + CHAR(10) + 'Cureency : ' + ISNULL(V_CURRENCY ,'') 								
										  + CHAR(10) + CHAR(10)
							  FROM ( SELECT v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_ITEM_ID, v_TEXT, v_YYYYMMDD
										  , v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE, V_CURRENCY, v_PLANT_SITE_ID 
									 FROM #TEMP_SALES_PLAN_SalesAmt_LOC
									 GROUP BY v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_ITEM_ID, v_TEXT, v_YYYYMMDD
										    , v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE, V_CURRENCY, v_PLANT_SITE_ID
									 HAVING COUNT(*) > 1 ) A) 

		IF (@s_validation IS NOT NULL)
		BEGIN				   
			--SET @v_log_message	= N'동일한 일자에 DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, TEXT, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE가 동일한 CURRENCY는 등록할 수 없습니다.' --[E20250520-000572]_MESSAGE_CODE를 사용하기로 하였으므로 주석처리
			SET @v_log_type		= 'INVALID';
			SET	@s_code			= 'MSG00461';  --[E20250520-000572]_MESSAGE 코드로 사용 [MSG00461]: 동일한 일자에 DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, TEXT, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE가 동일한 CURRENCY는 등록할 수 없습니다.\r\n
			GOTO ERR_RTN
		END
		--------------------------------------------------------------------------------------------------------------	
		--[E20250401-000548] SMS 선감지 대상 정리 (END)
		--------------------------------------------------------------------------------------------------------------	
		--=============================================================================================================
		-- VALIDATION (END)
		--=============================================================================================================
PRINT @v_program_name + ' : A011--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
		--------------------------------------------------------------------------------------------------------------	
		--[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청 START	
		--------------------------------------------------------------------------------------------------------------	
		IF ( SELECT COUNT(1) FROM #TEMP_SALES_PLAN WHERE V_BUCKET = 'M' ) > 0
		BEGIN 				
			DELETE A
			FROM DM_PLN_SALES_ETC_PLAN A
			JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD
			JOIN ( SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID
			   			, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_TEXT, B.BASIS_YYYYMM
						, B.ISO_YYYYWW
						--, v_CELL_PROD_SITE_ID
				   FROM #TEMP_SALES_PLAN A
				   JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.V_YYYYMMDD = B.BASIS_YYYYMMDD
				   WHERE A.v_MEASURE = 'SalesAmt_LOC' ) C 
			  ON A.DIVISION_ID		= C.V_DIVISION_ID
			 AND A.PROJECT_CODE		= C.V_PROJECT_CODE
			 AND A.SCM_SITE_ID		= C.V_SCM_SITE_ID
			 AND A.PLANT_SITE_ID	= C.V_PLANT_SITE_ID
			 AND A.ITEM_ID			= C.V_ITEM_ID
			 AND A.DOM_EXP			= C.V_DOM_EXP
			 AND A.FCST_TYPE		= C.V_FCST_TYPE
			 AND A.INCOTERMS		= C.V_INCOTERMS
			 AND A.REMARK_TEXT		= C.v_TEXT
			 AND B.BASIS_YYYYMM		= C.BASIS_YYYYMM
			 --AND A.CELL_PROD_SITE_ID = C.v_CELL_PROD_SITE_ID
			WHERE A.MEASURE NOT IN ( 'MKT_FCST', 'RTF' , 'CATCH_UP', 'LOC_Catch_Up', 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up', 'RTF_SYS_RP')
			--[PJ2024-50611]Catch_Up 관련 메저 삭제 금지
						
			DELETE A
			FROM DM_PLN_SALES_PLAN A
			JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD
			JOIN ( SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID
						, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, B.BASIS_YYYYMM, B.ISO_YYYYWW
						, v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				   FROM #TEMP_SALES_PLAN A
				   JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.V_YYYYMMDD = B.BASIS_YYYYMMDD
				   WHERE A.v_MEASURE = 'RTF_SYS_RP' ) C 
			  ON A.DIVISION_ID			= C.V_DIVISION_ID
			 AND A.PROJECT_CODE			= C.V_PROJECT_CODE
			 AND A.SCM_SITE_ID			= C.V_SCM_SITE_ID
			 AND A.PLANT_SITE_ID		= C.V_PLANT_SITE_ID
			 AND A.ITEM_ID				= C.V_ITEM_ID
			 AND A.DOM_EXP				= C.V_DOM_EXP
			 AND A.FCST_TYPE			= C.V_FCST_TYPE
			 AND A.INCOTERMS			= C.V_INCOTERMS
			 AND B.BASIS_YYYYMM			= C.BASIS_YYYYMM
			/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (START) */
			 --AND A.CELL_PROD_SITE_ID	= C.v_CELL_PROD_SITE_ID
			AND CASE WHEN C.V_DIVISION_ID = '40' THEN C.v_CELL_PROD_SITE_ID ELSE A.CELL_PROD_SITE_ID END = A.CELL_PROD_SITE_ID
			/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (END) */
			 --[E20260331-000648]_81, 81_JV 사업부도 추가한다. (START)
			--WHERE A.DIVISION_ID = '40'  --[E20260331-000648]_원소스 주석처리
			WHERE ( A.DIVISION_ID = '40' OR A.DIVISION_ID LIKE '81%')  --[E20260331-000648]_81, 81_JV 사업부도 추가
			 --[E20260331-000648]_81, 81_JV 사업부도 추가한다. (END)
			--[E20251027-000091]_SALES PLAN 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (START) 원소스 주석처리
			--AND   A.MEASURE IN ('RTF_SYS_RP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
			AND   A.MEASURE IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP', 'SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
			--[E20251027-000091]_SALES PLAN 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (END)
		END 
		ELSE 
		BEGIN 				
			DELETE A
			FROM DM_PLN_SALES_ETC_PLAN A
			JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD
			JOIN ( SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID
						, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_TEXT, B.BASIS_YYYYMM, B.ISO_YYYYWW
						--, v_CELL_PROD_SITE_ID
					FROM #TEMP_SALES_PLAN A
					JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.V_YYYYMMDD = B.BASIS_YYYYMMDD
					WHERE A.v_MEASURE = 'SalesAmt_LOC') C 
			  ON A.DIVISION_ID		= C.V_DIVISION_ID
			 AND A.PROJECT_CODE		= C.V_PROJECT_CODE
			 AND A.SCM_SITE_ID		= C.V_SCM_SITE_ID
			 AND A.PLANT_SITE_ID	= C.V_PLANT_SITE_ID
			 AND A.ITEM_ID			= C.V_ITEM_ID
			 AND A.DOM_EXP			= C.V_DOM_EXP
			 AND A.FCST_TYPE		= C.V_FCST_TYPE
			 AND A.INCOTERMS		= C.V_INCOTERMS
			 AND A.REMARK_TEXT		= C.v_TEXT
			 AND B.BASIS_YYYYMM		= C.BASIS_YYYYMM
			 AND B.ISO_YYYYWW		= C.ISO_YYYYWW
			 --AND A.CELL_PROD_SITE_ID = C.v_CELL_PROD_SITE_ID
			WHERE A.MEASURE NOT IN ( 'MKT_FCST', 'RTF' , 'CATCH_UP', 'LOC_Catch_Up', 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up', 'RTF_SYS_RP')
			--[PJ2024-50611]Catch_Up 관련 메저 삭제 금지
				
			DELETE A
			FROM DM_PLN_SALES_PLAN A
			JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD
			JOIN ( SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID
						, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, B.BASIS_YYYYMM, B.ISO_YYYYWW
						, v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				   FROM #TEMP_SALES_PLAN A
				   JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.V_YYYYMMDD = B.BASIS_YYYYMMDD
				   WHERE A.v_MEASURE = 'RTF_SYS_RP'	) C 
			  ON A.DIVISION_ID			= C.V_DIVISION_ID
			 AND A.PROJECT_CODE			= C.V_PROJECT_CODE
			 AND A.SCM_SITE_ID			= C.V_SCM_SITE_ID
			 AND A.PLANT_SITE_ID		= C.V_PLANT_SITE_ID
			 AND A.ITEM_ID				= C.V_ITEM_ID
			 AND A.DOM_EXP				= C.V_DOM_EXP
			 AND A.FCST_TYPE			= C.V_FCST_TYPE
			 AND A.INCOTERMS			= C.V_INCOTERMS
			 AND B.BASIS_YYYYMM			= C.BASIS_YYYYMM
			 AND B.ISO_YYYYWW			= C.ISO_YYYYWW
			/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (START) */
			 --AND A.CELL_PROD_SITE_ID	= C.v_CELL_PROD_SITE_ID
			 AND CASE WHEN C.V_DIVISION_ID = '40' THEN C.v_CELL_PROD_SITE_ID ELSE A.CELL_PROD_SITE_ID END = A.CELL_PROD_SITE_ID
			/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (END) */
			 --[E20260331-000648]_81, 81_JV 사업부도 추가한다. (START)
			--WHERE A.DIVISION_ID = '40'  --[E20260331-000648]_원소스 주석처리
			WHERE ( A.DIVISION_ID = '40' OR A.DIVISION_ID LIKE '81%')  --[E20260331-000648]_81, 81_JV 사업부도 추가
			 --[E20260331-000648]_81, 81_JV 사업부도 추가한다. (END)
			--[E20251027-000091]_SALES PLAN 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (START) 원소스 주석처리
			--AND A.MEASURE IN ('RTF_SYS_RP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
			AND A.MEASURE IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP', 'SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
			--[E20251027-000091]_SALES PLAN 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (END) 
		END 
		--------------------------------------------------------------------------------------------------------------	
		--[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청 END
		--------------------------------------------------------------------------------------------------------------	
PRINT @v_program_name + ' : A012--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
		--------------------------------------------------------------------------------------------------------------	
	    -- delete START
		--------------------------------------------------------------------------------------------------------------
		BEGIN
			( SELECT @n_del_count = COUNT(1) FROM #TEMP_SALES_PLAN WHERE v_active_flag  = 'D' );
		END
		BEGIN
			--------------------------------------------------------------------------------------------------------------	
			--[PJ2024-50611]SalesAmt_LOC 인것과 CATCH_UP인 것들을 구분하여 삭제해야 함 START
			-- 기존 값 삭제(SalesAmt_LOC)
			--------------------------------------------------------------------------------------------------------------	
			DELETE A
			--FROM [dbo].DM_PLN_SALES_PLAN A
			FROM DM_PLN_SALES_ETC_PLAN A--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
			JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD
			JOIN ( SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID
						, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리
						, B.BASIS_YYYYMM, B.ISO_YYYYWW
					FROM #TEMP_SALES_PLAN A
					JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.V_YYYYMMDD = B.BASIS_YYYYMMDD
					WHERE A.v_MEASURE = 'SalesAmt_LOC' --[PJ2024-50611]SalesAmt_LOC 인것만
					) C 
				ON   A.DIVISION_ID		= C.V_DIVISION_ID
				AND  A.PROJECT_CODE		= C.V_PROJECT_CODE
				AND  A.SCM_SITE_ID		= C.V_SCM_SITE_ID
				AND  A.PLANT_SITE_ID	= C.V_PLANT_SITE_ID
				AND  A.ITEM_ID			= C.V_ITEM_ID
				AND  A.DOM_EXP			= C.V_DOM_EXP
				AND  A.FCST_TYPE		= C.V_FCST_TYPE
				AND  A.INCOTERMS		= C.V_INCOTERMS
				AND  A.REMARK_TEXT		= C.v_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리
				AND  B.BASIS_YYYYMM		= C.BASIS_YYYYMM
				AND  B.ISO_YYYYWW		= C.ISO_YYYYWW
			WHERE A.MEASURE NOT IN ( 'MKT_FCST', 'RTF' , 'CATCH_UP', 'LOC_Catch_Up', 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up', 'RTF_SYS_RP')
			--[PJ2024-50611]Catch_Up 관련 메저 삭제 금지
			--WHERE A.MEASURE NOT IN ( 'MKT_FCST', 'RTF')
				
			--------------------------------------------------------------------------------------------------------------	
			-- 기존 값 삭제(CATCH_UP)
			--------------------------------------------------------------------------------------------------------------	
			DELETE A
			--FROM [dbo].DM_PLN_SALES_PLAN A
			FROM DM_PLN_SALES_ETC_PLAN A--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
			JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD
			JOIN ( SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID
						, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS
						, v_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리
						, B.BASIS_YYYYMM, B.ISO_YYYYWW
					FROM #TEMP_SALES_PLAN A
					JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.V_YYYYMMDD = B.BASIS_YYYYMMDD
					WHERE v_MEASURE = 'CATCH_UP' --CATCH_UP 인것만
					) C 
				ON  A.DIVISION_ID		= C.V_DIVISION_ID
				AND A.PROJECT_CODE		= C.V_PROJECT_CODE
				AND A.SCM_SITE_ID		= C.V_SCM_SITE_ID
				AND A.PLANT_SITE_ID		= C.V_PLANT_SITE_ID
				AND A.ITEM_ID			= C.V_ITEM_ID
				AND A.DOM_EXP			= C.V_DOM_EXP
				AND A.FCST_TYPE			= C.V_FCST_TYPE
				AND A.INCOTERMS			= C.V_INCOTERMS
				AND A.REMARK_TEXT		= C.v_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리
				AND B.BASIS_YYYYMM		= C.BASIS_YYYYMM
				AND B.ISO_YYYYWW		= C.ISO_YYYYWW
			WHERE A.MEASURE IN ('CATCH_UP', 'LOC_Catch_Up', 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up', 'RTF_SYS_RP') --Catch_Up 관련 메저만 삭제
			--[PJ2024-50611]SalesAmt_LOC 인것과 CATCH_UP인 것들을 구분하여 삭제해야 함 END
				
			--------------------------------------------------------------------------------------------------------------	
			-- 기존 값 삭제 'RTF_SYS_RP','SalesAmt_LOC','SalesAmt_KRW','SalesAmt_USD'
			--------------------------------------------------------------------------------------------------------------	
			DELETE A
			FROM DM_PLN_SALES_PLAN A
			JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD
			JOIN ( SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID
						, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, B.BASIS_YYYYMM, B.ISO_YYYYWW
						, v_CELL_PROD_SITE_ID  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
					FROM #TEMP_SALES_PLAN A
					JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.V_YYYYMMDD = B.BASIS_YYYYMMDD
					WHERE A.v_MEASURE = 'RTF_SYS_RP' ) C 
				ON  A.DIVISION_ID			= C.V_DIVISION_ID
				AND A.PROJECT_CODE			= C.V_PROJECT_CODE
				AND A.SCM_SITE_ID			= C.V_SCM_SITE_ID
				AND A.PLANT_SITE_ID			= C.V_PLANT_SITE_ID
				AND A.ITEM_ID				= C.V_ITEM_ID
				AND A.DOM_EXP				= C.V_DOM_EXP
				AND A.FCST_TYPE				= C.V_FCST_TYPE
				AND A.INCOTERMS				= C.V_INCOTERMS
				AND B.BASIS_YYYYMM			= C.BASIS_YYYYMM
				AND B.ISO_YYYYWW			= C.ISO_YYYYWW
				/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (START) */
				--AND A.CELL_PROD_SITE_ID	= C.v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가				
				AND CASE WHEN C.V_DIVISION_ID = '40' THEN C.v_CELL_PROD_SITE_ID ELSE A.CELL_PROD_SITE_ID END = A.CELL_PROD_SITE_ID
				/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (END) */
			 --[E20260331-000648]_81, 81_JV 사업부도 추가한다. (START)
			--WHERE A.DIVISION_ID = '40'  --[E20260331-000648]_원소스 주석처리
			WHERE ( A.DIVISION_ID = '40' OR A.DIVISION_ID LIKE '81%')  --[E20260331-000648]_81, 81_JV 사업부도 추가
			 --[E20260331-000648]_81, 81_JV 사업부도 추가한다. (END)
			--[E20251027-000091]_SALES PLAN 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (START) 원소스 주석처리
			--AND A.MEASURE IN ('RTF_SYS_RP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
			AND A.MEASURE IN  ('RTF_SYS_RP', 'RTF', 'RTF_SCP', 'SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
			--[E20251027-000091]_SALES PLAN 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (END) 

			--DELETE 
			--FROM [dbo].DM_PLN_SALES_PLAN
			--WHERE (
			--		SELECT count(1) 
			--			FROM #TEMP_SALES_PLAN 
			--			where 1=1
			--			--AND v_active_flag  = 'D' 
			--			and DM_PLN_SALES_PLAN.DIVISION_ID      =   v_DIVISION_ID        
			--			AND DM_PLN_SALES_PLAN.PROJECT_CODE     =   v_PROJECT_CODE     
			--			AND DM_PLN_SALES_PLAN.SCM_SITE_ID      =   v_SCM_SITE_ID  
			--			AND DM_PLN_SALES_PLAN.PLANT_SITE_ID    =   v_PLANT_SITE_ID
			--			AND DM_PLN_SALES_PLAN.ITEM_ID          =   v_ITEM_ID      
			--			AND DM_PLN_SALES_PLAN.DOM_EXP          =   v_DOM_EXP      
			--			AND DM_PLN_SALES_PLAN.FCST_TYPE        =   v_FCST_TYPE    
			--			AND DM_PLN_SALES_PLAN.INCOTERMS        =   v_INCOTERMS    
			--			--AND DM_PLN_SALES_PLAN.MEASURE          =   v_MEASURE      
			--			AND DM_PLN_SALES_PLAN.YYYYMMDD         =   v_YYYYMMDD      
			--			--AND v_MEASURE NOT IN ('SalesAmt_LOC')
			--			-- MKT FCST 와 RTF는 삭제하면 안됨.
			--			AND DM_PLN_SALES_PLAN.MEASURE NOT IN ( 'MKT_FCST', 'RTF' )
			--		) > 0;
		END

		--------------------------------------------------------------------------------------------------------------	
	    -- delete END
		--------------------------------------------------------------------------------------------------------------
PRINT @v_program_name + ' : A013--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
		--------------------------------------------------------------------------------------------------------------
		--KRW insert
		--------------------------------------------------------------------------------------------------------------
		BEGIN
			INSERT INTO #TEMP_SALES_PLAN_SalesAmt_LOC
			( v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID  
			, v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE        
			, v_YYYYMMDD, v_CURRENCY--,v_COMPANY_ID   
			, v_QTY
			, v_CREATED_BY, v_LAST_UPDATED_BY, v_TEXT, v_dept_id --[PJ2024-50611] 부서ID추가
			, v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			, v_FROM_SITE_ID							--[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
			)
			SELECT v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID
				 , v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, 'SalesAmt_KRW' AS v_MEASURE
				 , v_YYYYMMDD, v_CURRENCY
				 , ( SELECT CASE WHEN tmp.v_CURRENCY = 'KRW' THEN tmp.v_QTY
								 ELSE
									CASE WHEN tmp.v_CURRENCY = 'USD' 
										 --THEN ISNULL(CAST(tmp.v_QTY AS NUMERIC(30,10)) * ( SELECT CAST(EXCHANGE_PRICE AS NUMERIC(14,4))  --[E20250520-000572]_위에서 NUMERIC처리를 함으로 주석처리한다.
										 THEN ISNULL(tmp.v_QTY  * ( SELECT EXCHANGE_PRICE   --[E20250520-000572]_수정진행함
																	FROM DM_MST_EXCHANGE_RATE WITH(NOLOCK) 
																	WHERE DIVISION_ID = tmp.v_DIVISION_ID  
																	AND YYYYMMDD = SUBSTRING(tmp.v_YYYYMMDD, 1, 6) + '01'
																	AND UNIT_CURRENCY = 'USD' 
																	AND CURRENCY = 'KRW' 
																	--GROUP BY CAST(EXCHANGE_PRICE AS NUMERIC(14,4))),0)  --[PJ20209642R] CURRENCY = 'KRW' 조건 추가 --[E20250520-000572]_테이블에 해당 컬럼이 이미 NUMERIC처리가 되어 있으므로 주석처리한다.
																	GROUP BY EXCHANGE_PRICE), 0)  --[PJ20209642R] CURRENCY = 'KRW' 조건 추가 --[E20250520-000572]_NUMERIC 걷어내는 것으로 수정 진행함
										 ELSE
											CASE WHEN tmp.v_CURRENCY NOT IN ('KRW','USD')
												 --THEN ISNULL(CAST(tmp.v_QTY AS NUMERIC(30,10)) * ( SELECT CAST(EXCHANGE_PRICE AS NUMERIC(14,4)) --[E20250520-000572]_위에서 NUMERIC처리를 함으로 주석처리한다.
												 THEN ISNULL(tmp.v_QTY  * ( SELECT EXCHANGE_PRICE  --[E20250520-000572]_수정진행함
																			FROM DM_MST_EXCHANGE_RATE WITH(NOLOCK) 
																			WHERE DIVISION_ID = tmp.v_DIVISION_ID  
																			AND YYYYMMDD = SUBSTRING(tmp.v_YYYYMMDD, 1, 6) + '01'
																			AND UNIT_CURRENCY = tmp.v_CURRENCY 
																			AND CURRENCY = 'KRW' 
																			--GROUP BY CAST(EXCHANGE_PRICE AS NUMERIC(14,4))),0) --[PJ20209642R] CURRENCY = 'KRW' 조건 추가 --[E20250520-000572]_테이블에 해당 컬럼이 이미 NUMERIC처리가 되어 있으므로 주석처리한다.
																			GROUP BY EXCHANGE_PRICE), 0) --[PJ20209642R] CURRENCY = 'KRW' 조건 추가 --[E20250520-000572]_NUMERIC 걷어내는 것으로 수정 진행함
											END
									END
							END	) AS v_QTY, v_CREATED_BY, v_LAST_UPDATED_BY, v_TEXT, v_dept_id --[PJ2024-50611] 부서ID추가
				 , v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , v_FROM_SITE_ID							--[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
			FROM  #TEMP_SALES_PLAN_SalesAmt_LOC tmp   
			WHERE tmp.v_MEASURE = 'SalesAmt_LOC' 
			AND   v_active_flag  <> 'D'
			
			--------------------------------------------------------------------------------------------------------------
			-- USD insert
			--------------------------------------------------------------------------------------------------------------
			INSERT INTO #TEMP_SALES_PLAN_SalesAmt_LOC
			( v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID  
			, v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE        
			, v_YYYYMMDD, v_CURRENCY--,v_COMPANY_ID   
			, v_QTY
			, v_CREATED_BY, v_LAST_UPDATED_BY, v_TEXT, v_dept_id --[PJ2024-50611] 부서ID추가
			, v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			, v_FROM_SITE_ID							--[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
			)
			SELECT v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID
				 , v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, 'SalesAmt_USD' AS v_MEASURE
				 , v_YYYYMMDD, v_CURRENCY
				 , v_QTY = (SELECT CASE WHEN tmp.v_CURRENCY = 'KRW' 
								   		--THEN ISNULL(CAST(tmp.v_QTY AS NUMERIC(30,10)) / ( SELECT CAST(EXCHANGE_PRICE AS NUMERIC(14,4)) --[E20250520-000572]_위에서 NUMERIC처리를 함으로 주석처리한다. 
								   		THEN ISNULL(tmp.v_QTY  / ( SELECT EXCHANGE_PRICE --[E20250520-000572]_수정진행함 
																   FROM DM_MST_EXCHANGE_RATE WITH(NOLOCK) 
																   WHERE DIVISION_ID = tmp.v_DIVISION_ID  
																   AND YYYYMMDD = SUBSTRING(tmp.v_YYYYMMDD, 1, 6) + '01' 
																   AND UNIT_CURRENCY = 'USD' 
																   AND CURRENCY = 'KRW' 
																   --GROUP BY CAST(EXCHANGE_PRICE AS NUMERIC(14,4))),0) --[PJ20209642R] CURRENCY = 'KRW' 조건 추가 --[E20250520-000572]_테이블에 해당 컬럼이 이미 NUMERIC처리가 되어 있으므로 주석처리한다.
																   GROUP BY EXCHANGE_PRICE), 0) --[PJ20209642R] CURRENCY = 'KRW' 조건 추가 --[E20250520-000572]_NUMERIC 걷어내는 것으로 수정 진행함
										ELSE
											CASE WHEN tmp.v_CURRENCY = 'USD' 
												 THEN tmp.v_QTY 
												 ELSE CASE WHEN tmp.v_CURRENCY NOT IN ('KRW','USD')   -- KRW산출후 / USD
													  	   --THEN ISNULL(CAST(tmp.v_QTY AS NUMERIC(30,10)) * ( SELECT CAST(EXCHANGE_PRICE AS NUMERIC(14,4)) --[E20250520-000572]_위에서 NUMERIC처리를 함으로 주석처리한다. 
													  	   THEN ISNULL(tmp.v_QTY * ( SELECT EXCHANGE_PRICE --[E20250520-000572]_수정진행함 
																					 FROM DM_MST_EXCHANGE_RATE WITH(NOLOCK) 
																					 WHERE DIVISION_ID = tmp.v_DIVISION_ID  
																					 AND YYYYMMDD = SUBSTRING(tmp.v_YYYYMMDD, 1, 6) + '01' 
																					 AND UNIT_CURRENCY = tmp.v_CURRENCY 
																					 AND CURRENCY = 'KRW' 
																					 --GROUP BY CAST(EXCHANGE_PRICE AS NUMERIC(14,4))),0) --[E20250520-000572]_테이블에 해당 컬럼이 이미 NUMERIC처리가 되어 있으므로 주석처리한다.
																					 GROUP BY EXCHANGE_PRICE), 0)  --[E20250520-000572]_NUMERIC 걷어내는 것으로 수정 진행함
																				 --/ ( SELECT CAST(EXCHANGE_PRICE AS NUMERIC(14,4)) --[E20250520-000572]_테이블에 해당 컬럼이 이미 NUMERIC처리가 되어 있으므로 주석처리한다.
																				 / ( SELECT EXCHANGE_PRICE  --[E20250520-000572]_NUMERIC 걷어내는 것으로 수정 진행함
																					 FROM DM_MST_EXCHANGE_RATE WITH(NOLOCK) 
																					 WHERE DIVISION_ID = tmp.v_DIVISION_ID  
																					 AND YYYYMMDD = SUBSTRING(tmp.v_YYYYMMDD, 1, 6) + '01' 
																					 AND UNIT_CURRENCY = 'USD' 
																					 AND CURRENCY = 'KRW' 
																					 --GROUP BY CAST(EXCHANGE_PRICE AS NUMERIC(14,4))) --[PJ20209642R] CURRENCY = 'KRW' 조건 추가  --[E20250520-000572]_테이블에 해당 컬럼이 이미 NUMERIC처리가 되어 있으므로 주석처리한다.
																					GROUP BY EXCHANGE_PRICE)  --[PJ20209642R] CURRENCY = 'KRW' 조건 추가 --[E20250520-000572]_NUMERIC 걷어내는 것으로 수정 진행함
													  END
											END
								   END	)
				 , v_CREATED_BY, v_LAST_UPDATED_BY, v_TEXT, v_dept_id--[PJ2024-50611] 부서ID추가
				 , v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , v_FROM_SITE_ID							--[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
			FROM #TEMP_SALES_PLAN_SalesAmt_LOC tmp
			WHERE tmp.v_MEASURE = 'SalesAmt_LOC' and v_active_flag  <> 'D' 
			--위에서 SalesAmt_KRW 를 만들어서 insert 했기 때문에 tmp.v_MEASURE = 'SalesAmt_LOC' 를 where문을 빼면 안된다.
		END		
PRINT @v_program_name + ' : A014--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
		--------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611] Catch_Up 관련 메저 추가 START
		--------------------------------------------------------------------------------------------------------------
		BEGIN
			--------------------------------------------------------------------------------------------------------------
			--1)Sales Amt.(KRW)_Catch Up
			--------------------------------------------------------------------------------------------------------------
			INSERT  INTO  #TEMP_SALES_PLAN
			( v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID  
			, v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE        
			, v_YYYYMMDD, v_CURRENCY
			, v_QTY
			, v_CREATED_BY, v_LAST_UPDATED_BY, v_TEXT, v_dept_id, v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			)
			SELECT v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID
				 , v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, 'SalesAmt_KRW_Catch_Up' AS v_MEASURE
				 , v_YYYYMMDD, v_CURRENCY
				 --, ISNULL(CAST(tmp.v_QTY AS NUMERIC(30,10))	*  ( --판가(CALENDAR의 BASIS_START_DATE로 비교) --[E20250520-000572]_위에서 NUMERIC처리를 함으로 주석처리한다. 
				 , ISNULL(tmp.v_QTY *  ( --판가(CALENDAR의 BASIS_START_DATE로 비교) --[E20250520-000572]_NUMERIC 걷어내는 것으로 수정진행함 
											--SELECT TOP 1 CAST(FP.PRICE AS NUMERIC(30,10))  --[E20250520-000572]_테이블에 해당 컬럼이 이미 NUMERIC처리가 되어 있으므로 주석처리한다.
											SELECT TOP 1 FP.PRICE --[E20250520-000572]_NUMERIC 걷어내는 것으로 수정 진행함
											FROM DM_PLN_CFM_SELLING_PRICE FP WITH(NOLOCK)
											INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
													ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
											WHERE FP.DIVISION_ID		= tmp.v_DIVISION_ID
											AND   FP.PROJECT_CODE		= tmp.v_PROJECT_CODE
											AND   FP.SCM_SITE_ID		= tmp.v_SCM_SITE_ID
											AND   FP.PLANT_SITE_ID		= tmp.v_PLANT_SITE_ID
											AND   FP.ITEM_ID			= tmp.v_ITEM_ID
											AND   FP.DOM_EXP			= tmp.v_DOM_EXP
											AND   FP.FCST_TYPE			= tmp.v_FCST_TYPE
											AND   FP.INCOTERMS			= tmp.v_INCOTERMS
											AND   FP.MEASURE			= 'KRW'
											AND   CAL.BASIS_START_DATE = tmp.v_YYYYMMDD
											AND   FP.CELL_PROD_SITE_ID = tmp.v_CELL_PROD_SITE_ID ), 0) AS QTY--Catch-UP * 판가(Unit Price) * 환율(KRW/LOC)
				 , v_CREATED_BY, v_LAST_UPDATED_BY, v_TEXT, v_dept_id, v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM  #TEMP_SALES_PLAN tmp   
			WHERE tmp.v_MEASURE = 'Catch_Up' AND v_active_flag  <> 'D'
			
			--------------------------------------------------------------------------------------------------------------
			--2)Sales Amt.(LOC)_Catch Up
			--------------------------------------------------------------------------------------------------------------
			INSERT  INTO  #TEMP_SALES_PLAN
			( v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID  
			, v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE        
			, v_YYYYMMDD, v_CURRENCY
			, v_QTY
			, v_CREATED_BY, v_LAST_UPDATED_BY, v_TEXT, v_dept_id, v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			)
			SELECT v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID
				 , v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, 'SalesAmt_LOC_Catch_Up' AS v_MEASURE
				 , v_YYYYMMDD, v_CURRENCY
				 , ISNULL(tmp.v_QTY *  (--판가(CALENDAR의 BASIS_START_DATE로 비교)
										 SELECT TOP 1 FP.PRICE 
										 FROM DM_PLN_CFM_SELLING_PRICE FP WITH(NOLOCK)
										 INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
												 ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
										 WHERE FP.DIVISION_ID		= tmp.v_DIVISION_ID
										 AND   FP.PROJECT_CODE		= tmp.v_PROJECT_CODE
										 AND   FP.SCM_SITE_ID		= tmp.v_SCM_SITE_ID
										 AND   FP.PLANT_SITE_ID		= tmp.v_PLANT_SITE_ID
										 AND   FP.ITEM_ID			= tmp.v_ITEM_ID
										 AND   FP.DOM_EXP			= tmp.v_DOM_EXP
										 AND   FP.FCST_TYPE			= tmp.v_FCST_TYPE
										 AND   FP.INCOTERMS			= tmp.v_INCOTERMS
										 AND   FP.MEASURE			= 'LOC'
										 AND   CAL.BASIS_START_DATE = tmp.v_YYYYMMDD
										 AND   FP.CELL_PROD_SITE_ID = tmp.v_CELL_PROD_SITE_ID ), 0) AS QTY
				 , v_CREATED_BY, v_LAST_UPDATED_BY, v_TEXT, v_dept_id, v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM  #TEMP_SALES_PLAN tmp  
			WHERE tmp.v_MEASURE = 'Catch_Up' AND v_active_flag  <> 'D'
			
			--------------------------------------------------------------------------------------------------------------
			--3)Sales Amt.(USD)_Catch Up
			--------------------------------------------------------------------------------------------------------------
			INSERT  INTO  #TEMP_SALES_PLAN
			( v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID  
			, v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE        
			, v_YYYYMMDD, v_CURRENCY
			, v_QTY
			, v_CREATED_BY, v_LAST_UPDATED_BY, v_TEXT, v_dept_id, v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			)
			SELECT v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID
				 , v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, 'SalesAmt_USD_Catch_Up' AS v_MEASURE
				 , v_YYYYMMDD, v_CURRENCY
				 , ISNULL(tmp.v_QTY * (--판가(CALENDAR의 BASIS_START_DATE로 비교)
										SELECT TOP 1 FP.PRICE 
										FROM DM_PLN_CFM_SELLING_PRICE FP  WITH(NOLOCK)
										INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
												ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
										WHERE FP.DIVISION_ID		= tmp.v_DIVISION_ID
										AND   FP.PROJECT_CODE		= tmp.v_PROJECT_CODE
										AND   FP.SCM_SITE_ID		= tmp.v_SCM_SITE_ID
										AND   FP.PLANT_SITE_ID		= tmp.v_PLANT_SITE_ID
										AND   FP.ITEM_ID			= tmp.v_ITEM_ID
										AND   FP.DOM_EXP			= tmp.v_DOM_EXP
										AND   FP.FCST_TYPE			= tmp.v_FCST_TYPE
										AND   FP.INCOTERMS			= tmp.v_INCOTERMS
										AND   FP.MEASURE			= 'USD'
										AND   CAL.BASIS_START_DATE	= tmp.v_YYYYMMDD
										AND   FP.CELL_PROD_SITE_ID	= tmp.v_CELL_PROD_SITE_ID ), 0) AS QTY
				 , v_CREATED_BY, v_LAST_UPDATED_BY, v_TEXT, v_dept_id, v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM  #TEMP_SALES_PLAN tmp  
			WHERE tmp.v_MEASURE = 'Catch_Up' AND v_active_flag  <> 'D'

		END
		--------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611] Catch_Up 관련 메저 추가 END
		--------------------------------------------------------------------------------------------------------------		
PRINT @v_program_name + ' : A015--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

		BEGIN
			( SELECT @n_insert_count = COUNT(1) FROM #TEMP_SALES_PLAN WHERE v_MEASURE IN ('SalesAmt_LOC', 'Catch_Up'))--[PJ2024-50611] Catch_Up 추가
		END
		BEGIN
			--INSERT INTO DM_PLN_SALES_PLAN
			INSERT INTO DM_PLN_SALES_ETC_PLAN--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, REMARK_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 :필드추가
			, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD
			, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
			, LAST_UPDATE_DATE, ATTRIBUTE1
			, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
			, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			SELECT v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID, v_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 :필드추가						
				 , v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE, v_YYYYMMDD       
				 , v_CURRENCY, v_QTY, v_CREATED_BY, GETDATE() AS CREATION_DATE, v_LAST_UPDATED_BY
				 , GETDATE() AS LAST_UPDATE_DATE, v_dept_id AS ATTRIBUTE1--[PJ2024-50611] ATTRIBUTE1 에 부서ID 저장
				 , NULL, NULL, NULL, NULL, NULL
				 , NULL, NULL, NULL, NULL--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 :ATTRIBUTE9에 null로 저장
			FROM #TEMP_SALES_PLAN_SalesAmt_LOC  
			WHERE 1=1
			--AND v_MEASURE NOT IN ('RTF_SYS_RP')
			AND v_active_flag  <> 'D'						
		END
		-------------------------------------------------------------------
		/* [2018-03-19][CURSOR를 이용해 HISTORY TABLE ADD 
			방법1 : PROCEDURE CALL
			방법2 : 바로입력 	*/
		-------------------------------------------------------------------			
PRINT @v_program_name + ' : A016--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

		/* 2024-04-04   KCW3408     Sales Plan 관련 자동사업부 기타 매출 추가 */
		BEGIN
			-- HISTORY INSERT 
			--INSERT INTO DM_PLN_SALES_PLAN_H
			INSERT INTO DM_PLN_SALES_ETC_PLAN_H--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
			, REMARK_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 :필드추가
			, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD
			, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
			, LAST_UPDATE_DATE, ATTRIBUTE1
			, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
			, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 ) 
			SELECT v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID
				 , v_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 :필드추가						
				 , v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE, v_YYYYMMDD       
				 , v_CURRENCY, v_QTY, v_CREATED_BY, GETDATE() AS CREATION_DATE, v_LAST_UPDATED_BY
				 , GETDATE() AS LAST_UPDATE_DATE, v_dept_id AS ATTRIBUTE1--[PJ2024-50611] ATTRIBUTE1 에 부서ID 저장
				 , NULL, NULL, NULL, NULL, NULL
				 , NULL, NULL, NULL, V_ACTIVE_FLAG--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 :ATTRIBUTE9에 null로 저장
					--,v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM #TEMP_SALES_PLAN_SalesAmt_LOC 
			WHERE 1=1
			--AND v_MEASURE NOT IN ('RTF_SYS_RP')
			--and v_active_flag  <> 'D'
				
			/*
				-- 커서를 이용해 DIVISION_ID 만큼 LOOP
				DECLARE DM0021_SAVE_DM_PLN_SALES_PLAN_ALL_40_CUR CURSOR FAST_FORWARD FOR
																	SELECT 	 v_DIVISION_ID    
																			,v_PROJECT_CODE   
																			,v_SCM_SITE_ID    
																			,v_PLANT_SITE_ID  
																			,v_ITEM_ID        
																			,v_DOM_EXP        
																			,v_FCST_TYPE      
																			,v_INCOTERMS      
																			,v_MEASURE        
																			,v_YYYYMMDD       
																			,v_CURRENCY       
																			,v_QTY      
																			,v_CREATED_BY
																			,v_LAST_UPDATED_BY   
																	  FROM	#TEMP_SALES_PLAN  
																	 WHERE  1=1
															--		   AND	V_ACTIVE_FLAG  <> 'D'
												  
				OPEN DM0021_SAVE_DM_PLN_SALES_PLAN_ALL_40_CUR
				FETCH NEXT FROM DM0021_SAVE_DM_PLN_SALES_PLAN_ALL_40_CUR INTO	 @v_DIVISION_ID    
																			,@v_PROJECT_CODE   
																			,@v_SCM_SITE_ID    
																			,@v_PLANT_SITE_ID  
																			,@v_ITEM_ID        
																			,@v_DOM_EXP        
																			,@v_FCST_TYPE      
																			,@v_INCOTERMS      
																			,@v_MEASURE        
																			,@v_YYYYMMDD       
																			,@v_CURRENCY       
																			,@v_QTY     
																			,@v_CREATED_BY    
																			,@v_LAST_UPDATED_BY


				WHILE @@FETCH_STATUS = 0
				BEGIN

						SET @n_history_seq = NEXT VALUE FOR SEQ1_DM_PLN_SALES_PLAN_H

						-- HISTORY INSERT
						INSERT INTO DM_PLN_SALES_PLAN_H
									( 
										DIVISION_ID			,HISTORY_SEQ	,PROJECT_CODE		,SCM_SITE_ID	
										,PLANT_SITE_ID		,ITEM_ID		,DOM_EXP			,FCST_TYPE		
										,INCOTERMS			,MEASURE		,YYYYMMDD			,CURRENCY				,QTY
										,CREATED_BY			,CREATION_DATE	,LAST_UPDATED_BY	,LAST_UPDATE_DATE
									)
								VALUES
									(
										 @v_DIVISION_ID		,@n_history_seq	,@v_PROJECT_CODE	,@v_SCM_SITE_ID    
										,@v_PLANT_SITE_ID   ,@v_ITEM_ID     ,@v_DOM_EXP			,@v_FCST_TYPE      
										,@v_INCOTERMS		,@v_MEASURE		,@v_YYYYMMDD		,@v_CURRENCY			,@v_QTY            
										,@v_CREATED_BY		,GETDATE()		,@v_LAST_UPDATED_BY	,GETDATE()
									);

						FETCH NEXT FROM DM0021_SAVE_DM_PLN_SALES_PLAN_ALL_40_CUR INTO	 @v_DIVISION_ID    
																					,@v_PROJECT_CODE   
																					,@v_SCM_SITE_ID    
																					,@v_PLANT_SITE_ID  
																					,@v_ITEM_ID        
																					,@v_DOM_EXP        
																					,@v_FCST_TYPE      
																					,@v_INCOTERMS      
																					,@v_MEASURE        
																					,@v_YYYYMMDD       
																					,@v_CURRENCY       
																					,@v_QTY     
																					,@v_CREATED_BY    
																					,@v_LAST_UPDATED_BY
				END

				CLOSE DM0021_SAVE_DM_PLN_SALES_PLAN_ALL_40_CUR
				DEALLOCATE DM0021_SAVE_DM_PLN_SALES_PLAN_ALL_40_CUR
				*/
		END
		
		--------------------------------------------------------------------------------------------------------------
		-- insert (END)		
		--------------------------------------------------------------------------------------------------------------	
PRINT @v_program_name + ' : A016--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
		--------------------------------------------------------------------------------------------------------------
		-- [PJ2025-50017] DM_PLN_SALES_PLAN 에 'RTF_SYS_RP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD' Measuer 값 저장 START
		-- DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx 에서 RTF_SYS_RP는 40사업부만 수정 가능하게 조회하기 때문에 ( SALES_PLAN_ADJUST_YN ) 다른 사업부랑 겹칠 위험은 현재 없음.
		--------------------------------------------------------------------------------------------------------------
		BEGIN
			--------------------------------------------------------------------------------------------------------------
			--1) RTF_SYS_RP 기반의 SalesAmt_KRW
			--------------------------------------------------------------------------------------------------------------
			INSERT INTO #TEMP_SALES_PLAN_RTF_SYS_RP
			( v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID  
			, v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE        
			, v_YYYYMMDD, v_CURRENCY
			, v_QTY
			, v_CREATED_BY, v_LAST_UPDATED_BY    
			, v_TEXT, v_dept_id, v_CELL_PROD_SITE_ID	--[PJ2025-50017] CELL_PROD_SITE_ID 추가
			, v_FROM_SITE_ID							--[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
			)
			SELECT v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID
				 , v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, 'SalesAmt_KRW' AS v_MEASURE
				 , v_YYYYMMDD, v_CURRENCY
				 --, ISNULL(CAST(tmp.v_QTY AS NUMERIC(30,10))	*  ( --판가(CALENDAR의 BASIS_START_DATE로 비교) --[E20250520-000572]_위에서 NUMERIC처리를 함으로 주석처리한다. 
				 , ISNULL(tmp.v_QTY	*  ( --판가(CALENDAR의 BASIS_START_DATE로 비교) --[E20250520-000572]_수정진행함 
											SELECT PRICE 
											--FROM (	SELECT TOP 1 'SCM_MST_FUTURE_PRICE' AS TBL, CAST(FP.PRICE AS NUMERIC(30,10)) AS PRICE, FP.DIVISION_ID --[E20250520-000572]_테이블에 해당 컬럼이 이미 NUMERIC처리가 되어 있으므로 주석처리한다.
											FROM (	SELECT TOP 1 'SCM_MST_FUTURE_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID --[E20250520-000572]_NUMERIC을 걷어낸다.
													FROM SCM_MST_FUTURE_PRICE FP  WITH(NOLOCK)
													INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
															ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
													WHERE FP.DIVISION_ID		= tmp.v_DIVISION_ID
													AND   FP.PROJECT_CODE		= tmp.v_PROJECT_CODE
													AND   FP.SCM_SITE_ID		= tmp.v_SCM_SITE_ID
													AND   FP.PLANT_SITE_ID		= tmp.v_PLANT_SITE_ID
													AND   FP.ITEM_ID			= tmp.v_ITEM_ID
													AND   FP.DOM_EXP			= tmp.v_DOM_EXP
													AND   FP.FCST_TYPE			= tmp.v_FCST_TYPE
													AND   FP.INCOTERMS			= tmp.v_INCOTERMS
													AND   FP.MEASURE			= 'KRW'
													AND   CAL.BASIS_START_DATE	= tmp.v_YYYYMMDD
													UNION ALL
													--SELECT TOP 1 'DM_PLN_CFM_SELLING_PRICE' AS TBL, CAST(FP.PRICE AS NUMERIC(30,10)) AS PRICE, FP.DIVISION_ID --[E20250520-000572]_테이블에 해당 컬럼이 이미 NUMERIC처리가 되어 있으므로 주석처리한다.
													SELECT TOP 1 'DM_PLN_CFM_SELLING_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID --[E20250520-000572]_NUMERIC을 걷어낸다.
													FROM DM_PLN_CFM_SELLING_PRICE FP  WITH(NOLOCK)
													INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
															ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
													WHERE FP.DIVISION_ID		= tmp.v_DIVISION_ID
													AND	  FP.PROJECT_CODE		= tmp.v_PROJECT_CODE
													AND	  FP.SCM_SITE_ID		= tmp.v_SCM_SITE_ID
													AND	  FP.PLANT_SITE_ID		= tmp.v_PLANT_SITE_ID
													AND	  FP.ITEM_ID			= tmp.v_ITEM_ID
													AND	  FP.DOM_EXP			= tmp.v_DOM_EXP
													AND	  FP.FCST_TYPE			= tmp.v_FCST_TYPE
													AND	  FP.INCOTERMS			= tmp.v_INCOTERMS
													AND	  FP.MEASURE			= 'KRW'
													AND	  FP.CELL_PROD_SITE_ID	= tmp.v_CELL_PROD_SITE_ID
													AND	  CAL.BASIS_START_DATE	= tmp.v_YYYYMMDD
													) AA 
											WHERE AA.TBL = CASE WHEN AA.DIVISION_ID = '40' 
																THEN 'DM_PLN_CFM_SELLING_PRICE' 
																ELSE 'SCM_MST_FUTURE_PRICE' 
															END	), 0) --RTF_SYS_RP * 판가(Unit Price) * 환율(KRW/LOC)
				 , v_CREATED_BY, v_LAST_UPDATED_BY, v_TEXT, v_dept_id, v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , v_FROM_SITE_ID							--[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
			FROM  #TEMP_SALES_PLAN_RTF_SYS_RP tmp   
			WHERE tmp.v_MEASURE = 'RTF_SYS_RP' 
			AND v_active_flag  <> 'D'

PRINT @v_program_name + ' : A017--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

			--------------------------------------------------------------------------------------------------------------
			--2) RTF_SYS_RP 기반의 Sales Amt.(LOC)
			--------------------------------------------------------------------------------------------------------------
			INSERT  INTO  #TEMP_SALES_PLAN_RTF_SYS_RP
			( v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID  
			, v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE        
			, v_YYYYMMDD, v_CURRENCY
			, v_QTY
			, v_CREATED_BY, v_LAST_UPDATED_BY    
			, v_TEXT, v_dept_id, v_CELL_PROD_SITE_ID	--[PJ2025-50017] CELL_PROD_SITE_ID 추가
			, v_FROM_SITE_ID							--[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
			)
			SELECT v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID
				 , v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, 'SalesAmt_LOC' AS v_MEASURE
				 , v_YYYYMMDD, v_CURRENCY
				 , ISNULL(tmp.v_QTY * (	--판가(CALENDAR의 BASIS_START_DATE로 비교)
										SELECT PRICE 
										FROM (	SELECT TOP 1 'SCM_MST_FUTURE_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID 
												FROM SCM_MST_FUTURE_PRICE FP  WITH(NOLOCK)
												INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
														ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
												WHERE FP.DIVISION_ID		= tmp.v_DIVISION_ID
												AND   FP.PROJECT_CODE		= tmp.v_PROJECT_CODE
												AND   FP.SCM_SITE_ID		= tmp.v_SCM_SITE_ID
												AND   FP.PLANT_SITE_ID		= tmp.v_PLANT_SITE_ID
												AND   FP.ITEM_ID			= tmp.v_ITEM_ID
												AND   FP.DOM_EXP			= tmp.v_DOM_EXP
												AND   FP.FCST_TYPE			= tmp.v_FCST_TYPE
												AND   FP.INCOTERMS			= tmp.v_INCOTERMS
												AND   FP.MEASURE			= 'LOC'
												AND   CAL.BASIS_START_DATE	= tmp.v_YYYYMMDD
												UNION
												SELECT TOP 1 'DM_PLN_CFM_SELLING_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID 
												FROM DM_PLN_CFM_SELLING_PRICE FP  WITH(NOLOCK)
												INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
														ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
												WHERE FP.DIVISION_ID		= tmp.v_DIVISION_ID
												AND   FP.PROJECT_CODE		= tmp.v_PROJECT_CODE
												AND   FP.SCM_SITE_ID		= tmp.v_SCM_SITE_ID
												AND   FP.PLANT_SITE_ID		= tmp.v_PLANT_SITE_ID
												AND   FP.ITEM_ID			= tmp.v_ITEM_ID
												AND   FP.DOM_EXP			= tmp.v_DOM_EXP
												AND   FP.FCST_TYPE			= tmp.v_FCST_TYPE
												AND   FP.INCOTERMS			= tmp.v_INCOTERMS
												AND   FP.MEASURE			= 'LOC'
												AND   FP.CELL_PROD_SITE_ID = tmp.v_CELL_PROD_SITE_ID
												AND   CAL.BASIS_START_DATE = tmp.v_YYYYMMDD
											) AA 
										WHERE AA.TBL = CASE WHEN AA.DIVISION_ID = '40' 
															THEN 'DM_PLN_CFM_SELLING_PRICE' 
															ELSE 'SCM_MST_FUTURE_PRICE' 
													   END), 0)
				 , v_CREATED_BY, v_LAST_UPDATED_BY, v_TEXT, v_dept_id, v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , v_FROM_SITE_ID							--[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
			FROM  #TEMP_SALES_PLAN_RTF_SYS_RP tmp  
			WHERE tmp.v_MEASURE = 'RTF_SYS_RP' 
			AND v_active_flag  <> 'D'
			--위에서 SalesAmt_KRW 를 만들어서 insert 했기 때문에 tmp.v_MEASURE = 'RTF_SYS_RP' 를 where문을 빼면 안된다.
PRINT @v_program_name + ' : A018--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
	
			--------------------------------------------------------------------------------------------------------------
			--3) RTF_SYS_RP 기반의 Sales Amt.(USD)
			--------------------------------------------------------------------------------------------------------------
			INSERT  INTO  #TEMP_SALES_PLAN_RTF_SYS_RP
			( v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID  
			, v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE        
			, v_YYYYMMDD, v_CURRENCY
			, v_QTY
			, v_CREATED_BY, v_LAST_UPDATED_BY    
			, v_TEXT, v_dept_id, v_CELL_PROD_SITE_ID	--[PJ2025-50017] CELL_PROD_SITE_ID 추가
			, v_FROM_SITE_ID							--[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
			)
			SELECT v_active_flag, v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID
				 , v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, 'SalesAmt_USD' AS v_MEASURE
				 , v_YYYYMMDD, v_CURRENCY
				 , ISNULL(tmp.v_QTY * (	--판가(CALENDAR의 BASIS_START_DATE로 비교)
										SELECT PRICE 
										FROM (	SELECT TOP 1 'SCM_MST_FUTURE_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID 
												FROM SCM_MST_FUTURE_PRICE FP  WITH(NOLOCK)
												INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
														ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
												WHERE FP.DIVISION_ID		= tmp.v_DIVISION_ID
												AND	  FP.PROJECT_CODE		= tmp.v_PROJECT_CODE
												AND	  FP.SCM_SITE_ID		= tmp.v_SCM_SITE_ID
												AND	  FP.PLANT_SITE_ID		= tmp.v_PLANT_SITE_ID
												AND	  FP.ITEM_ID			= tmp.v_ITEM_ID
												AND	  FP.DOM_EXP			= tmp.v_DOM_EXP
												AND	  FP.FCST_TYPE			= tmp.v_FCST_TYPE
												AND	  FP.INCOTERMS			= tmp.v_INCOTERMS
												AND	  FP.MEASURE			= 'USD'
												AND	  CAL.BASIS_START_DATE	= tmp.v_YYYYMMDD
												UNION
												SELECT TOP 1 'DM_PLN_CFM_SELLING_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID 
												FROM DM_PLN_CFM_SELLING_PRICE FP  WITH(NOLOCK)
												INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
														ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
												WHERE FP.DIVISION_ID		= tmp.v_DIVISION_ID
												AND	  FP.PROJECT_CODE		= tmp.v_PROJECT_CODE
												AND	  FP.SCM_SITE_ID		= tmp.v_SCM_SITE_ID
												AND	  FP.PLANT_SITE_ID		= tmp.v_PLANT_SITE_ID
												AND	  FP.ITEM_ID			= tmp.v_ITEM_ID
												AND	  FP.DOM_EXP			= tmp.v_DOM_EXP
												AND	  FP.FCST_TYPE			= tmp.v_FCST_TYPE
												AND	  FP.INCOTERMS			= tmp.v_INCOTERMS
												AND	  FP.MEASURE			= 'USD'
												AND	  FP.CELL_PROD_SITE_ID	= tmp.v_CELL_PROD_SITE_ID
												AND	  CAL.BASIS_START_DATE	= tmp.v_YYYYMMDD
											) AA 
										WHERE AA.TBL = CASE WHEN AA.DIVISION_ID = '40' 
															THEN 'DM_PLN_CFM_SELLING_PRICE' 
															ELSE 'SCM_MST_FUTURE_PRICE' 
														END ), 0)
				 , v_CREATED_BY, v_LAST_UPDATED_BY, v_TEXT, v_dept_id, v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , v_FROM_SITE_ID							--[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
			FROM  #TEMP_SALES_PLAN tmp  
			WHERE tmp.v_MEASURE = 'RTF_SYS_RP' 
			AND   v_active_flag  <> 'D'
			--위에서 SalesAmt_KRW 를 만들어서 insert 했기 때문에 tmp.v_MEASURE = 'RTF_SYS_RP' 를 where문을 빼면 안된다.
PRINT @v_program_name + ' : A019--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

			INSERT INTO DM_PLN_SALES_PLAN
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
			, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD
			, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
			, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
			, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
			, ATTRIBUTE10, CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			)
			SELECT v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID
				 , v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE, v_YYYYMMDD       
				 , v_CURRENCY, v_QTY, v_CREATED_BY, GETDATE() AS CREATION_DATE, v_LAST_UPDATED_BY
				 , GETDATE()		AS LAST_UPDATE_DATE  
				 , v_dept_id		AS ATTRIBUTE1		--[PJ2024-50611] ATTRIBUTE1 에 부서ID 저장
				 , v_FROM_SITE_ID	AS ATTRIBUTE2		--[PJ2025-50188] FROM_SITE_ID 추가
				 , NULL, NULL, NULL, NULL
				 , NULL, NULL, NULL, NULL--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 :ATTRIBUTE9에 null로 저장
				 , v_CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM #TEMP_SALES_PLAN_RTF_SYS_RP A WITH(NOLOCK)
			WHERE 1=1
			--[E20251027-000091]_SALES PLAN 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (START) 원소스 주석처리
			--AND v_MEASURE IN ('RTF_SYS_RP', 'SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD') --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			AND v_MEASURE IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP', 'SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD') --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			--[E20251027-000091]_SALES PLAN 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (END) 
			AND v_active_flag  <> 'D'
		END
		--------------------------------------------------------------------------------------------------------------
		--[PJ2025-50017] DM_PLN_SALES_PLAN 에 'RTF_SYS_RP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD' Measuer 값 저장 END
		--------------------------------------------------------------------------------------------------------------		
PRINT @v_program_name + ' : A020--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
		--------------------------------------------------------------------------------------------------------------
		-- [PJ2025-50017] DM_PLN_SALES_PLAN_H 에 'RTF_SYS_RP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD' Measuer 값 저장 START
		--------------------------------------------------------------------------------------------------------------
		BEGIN
			INSERT INTO DM_PLN_SALES_PLAN_H
			( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID
			, ITEM_ID ,DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
			, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
			, LAST_UPDATED_BY, LAST_UPDATE_DATE
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			, CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			) 
			SELECT v_DIVISION_ID, NEXT VALUE FOR SEQ1_DM_PLN_SALES_PLAN_H, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID  
				 , v_ITEM_ID, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE        
				 , v_YYYYMMDD, v_CURRENCY, v_QTY, v_CREATED_BY, GETDATE() AS CREATION_DATE   
				 , v_LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE  
				 , v_dept_id		AS ATTRIBUTE1		--[PJ2024-50611] ATTRIBUTE1 에 부서ID 저장
				 , v_FROM_SITE_ID	AS ATTRIBUTE2		--[PJ2025-50188] FROM_SITE_ID 추가
				 , NULL, NULL, NULL, NULL
				 , NULL, NULL, NULL, V_ACTIVE_FLAG AS ATTRIBUTE10--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 :ATTRIBUTE9에 null로 저장
				 , v_CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM #TEMP_SALES_PLAN_RTF_SYS_RP A WITH(NOLOCK)
			WHERE 1 = 1
			--[E20251027-000091]_SALES PLAN 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (START) 원소스 주석처리
			--AND v_MEASURE IN ('RTF_SYS_RP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD') --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			AND v_MEASURE IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP', 'SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD') --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			--[E20251027-000091]_SALES PLAN 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (END) 
		END		
		--------------------------------------------------------------------------------------------------------------
		-- [PJ2025-50017] DM_PLN_SALES_PLAN_H 에 'RTF_SYS_RP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD' Measuer 값 저장 END
		--------------------------------------------------------------------------------------------------------------		
PRINT @v_program_name + ' : A021--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
		--------------------------------------------------------------------------------------------------------------
		-- [PJ2025-50017] CFM_MKT_DEMAND_PLAN 테이블에 ('RTF_SYS_RP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW') DELETE 후 INSERT - START
		--------------------------------------------------------------------------------------------------------------
		BEGIN
			SELECT DISTINCT v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID
						  , v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS, v_MEASURE, v_LAST_UPDATED_BY
						  , v_CELL_PROD_SITE_ID, SUBSTRING(v_YYYYMMDD,1,6)	AS	v_YYYYMM
						  , v_FROM_SITE_ID						-- [PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
			INTO #TEMP_SALES_PLAN_INSERT
			FROM #TEMP_SALES_PLAN_RTF_SYS_RP;
				
			DELETE DM_PLN_CFM_MKT_DEMAND_PLAN 
			WHERE DIVISION_ID = @v_DIVISION_ID
			--[E20251027-000091]_MKT FCST 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (START) 원소스 주석처리
			--AND   MEASURE IN ('RTF_SYS_RP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW')
			AND   MEASURE IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW')
			--[E20251027-000091]_MKT FCST 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (END)
			AND   EXISTS (	SELECT 1
							FROM #TEMP_SALES_PLAN_INSERT Z WITH(NOLOCK)
							WHERE Z.v_DIVISION_ID		= DM_PLN_CFM_MKT_DEMAND_PLAN.DIVISION_ID
							AND	  Z.v_PROJECT_CODE		= DM_PLN_CFM_MKT_DEMAND_PLAN.PROJECT_CODE
							AND	  Z.v_SCM_SITE_ID		= DM_PLN_CFM_MKT_DEMAND_PLAN.SCM_SITE_ID
							AND	  Z.v_ITEM_ID			= DM_PLN_CFM_MKT_DEMAND_PLAN.ITEM_ID
							AND	  Z.v_DOM_EXP			= DM_PLN_CFM_MKT_DEMAND_PLAN.DOM_EXP
							AND	  Z.v_FCST_TYPE			= DM_PLN_CFM_MKT_DEMAND_PLAN.FCST_TYPE
							AND	  Z.v_INCOTERMS			= DM_PLN_CFM_MKT_DEMAND_PLAN.INCOTERMS
							AND	  Z.v_MEASURE			= DM_PLN_CFM_MKT_DEMAND_PLAN.MEASURE
							AND	  Z.v_PLANT_SITE_ID		= DM_PLN_CFM_MKT_DEMAND_PLAN.PLANT_SITE_ID							
							/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (START) */							
							--AND	  Z.v_CELL_PROD_SITE_ID	= DM_PLN_CFM_MKT_DEMAND_PLAN.CELL_PROD_SITE_ID
							AND CASE WHEN Z.v_DIVISION_ID = '40' THEN Z.v_CELL_PROD_SITE_ID ELSE DM_PLN_CFM_MKT_DEMAND_PLAN.CELL_PROD_SITE_ID END = DM_PLN_CFM_MKT_DEMAND_PLAN.CELL_PROD_SITE_ID
							/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (END) */
							AND	  Z.v_YYYYMM			= SUBSTRING(DM_PLN_CFM_MKT_DEMAND_PLAN.YYYYMMDD, 1, 6));
PRINT @v_program_name + ' : A022--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

			INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN 
			( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID
			, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
			, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
			, LAST_UPDATED_BY, LAST_UPDATE_DATE	
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			)
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
				 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
				 , A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
				 , A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
				 , NULL						AS ATTRIBUTE1
				 , Z.v_FROM_SITE_ID			AS ATTRIBUTE2			-- [PJ2025-50188] SALES_PLAN 추가 및 수정시 ATTRIBUTE2(FROM_SITE_ID) 데이터 생성  
				 , NULL, NULL, NULL
				 , NULL, NULL, NULL, NULL, NULL
			FROM DM_PLN_SALES_PLAN A WITH(NOLOCK)
			INNER JOIN #TEMP_SALES_PLAN_INSERT Z WITH(NOLOCK)
					ON  A.DIVISION_ID				= Z.v_DIVISION_ID	
				   AND	A.PROJECT_CODE				= Z.v_PROJECT_CODE	
				   AND	A.SCM_SITE_ID				= Z.v_SCM_SITE_ID	
				   AND	A.ITEM_ID					= Z.v_ITEM_ID		
				   AND	A.DOM_EXP					= Z.v_DOM_EXP		
				   AND	A.FCST_TYPE					= Z.v_FCST_TYPE		
				   AND	A.INCOTERMS					= Z.v_INCOTERMS		
				   AND	A.MEASURE					= Z.v_MEASURE		
				   AND	A.PLANT_SITE_ID				= Z.v_PLANT_SITE_ID
					/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (START) */							
					--AND	A.CELL_PROD_SITE_ID			= Z.v_CELL_PROD_SITE_ID
					AND CASE WHEN Z.v_DIVISION_ID = '40' THEN Z.v_CELL_PROD_SITE_ID ELSE A.CELL_PROD_SITE_ID END = A.CELL_PROD_SITE_ID
					/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (END) */				   
				   AND	SUBSTRING(A.YYYYMMDD, 1, 6)	= Z.v_YYYYMM						
			WHERE A.DIVISION_ID	= @v_DIVISION_ID
			--AND   A.QTY			!= 0
			--[E20251027-000091]_MKT FCST 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (START) 원소스 주석처리
			--AND   A.MEASURE		IN ('RTF_SYS_RP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW');		
			AND   A.MEASURE		IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW');		
			--[E20251027-000091]_MKT FCST 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (END) 
PRINT @v_program_name + ' : A023--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

			DELETE DM_PLN_MKT_FCST 
			WHERE  DIVISION_ID = @v_DIVISION_ID
			--[E20251027-000091]_MKT FCST 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (START) 원소스 주석처리
			--AND    MEASURE IN ('RTF_SYS_RP')
			AND    MEASURE IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP')
			--[E20251027-000091]_MKT FCST 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (END) 
			AND    EXISTS (	SELECT 1
							FROM #TEMP_SALES_PLAN_INSERT Z WITH(NOLOCK)
							WHERE Z.v_DIVISION_ID	= DM_PLN_MKT_FCST.DIVISION_ID
							AND	  Z.v_PROJECT_CODE	= DM_PLN_MKT_FCST.PROJECT_CODE
							AND	  Z.v_SCM_SITE_ID	= DM_PLN_MKT_FCST.SCM_SITE_ID
							AND	  Z.v_ITEM_ID		= DM_PLN_MKT_FCST.ITEM_ID
							AND	  Z.v_DOM_EXP		= DM_PLN_MKT_FCST.DOM_EXP
							AND	  Z.v_FCST_TYPE		= DM_PLN_MKT_FCST.FCST_TYPE
							AND	  Z.v_INCOTERMS		= DM_PLN_MKT_FCST.INCOTERMS
							AND	  Z.v_MEASURE		= DM_PLN_MKT_FCST.MEASURE
							AND	  Z.v_PLANT_SITE_ID	= DM_PLN_MKT_FCST.PLANT_SITE_ID
							AND	  Z.v_YYYYMM		= SUBSTRING(DM_PLN_MKT_FCST.YYYYMMDD, 1, 6));				 
PRINT @v_program_name + ' : A024--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

			INSERT INTO DM_PLN_MKT_FCST 
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
			, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
			, QTY, CREATED_BY, CREATION_DATE
			, LAST_UPDATED_BY, LAST_UPDATE_DATE	)
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
				 , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
				 , SUM(A.QTY) AS QTY, MAX(A.LAST_UPDATED_BY) AS CREATED_BY, MAX(A.LAST_UPDATE_DATE) AS CREATION_DATE
				 , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY, MAX(A.LAST_UPDATE_DATE)
			FROM DM_PLN_SALES_PLAN A WITH(NOLOCK)
			INNER JOIN #TEMP_SALES_PLAN_INSERT Z WITH(NOLOCK)
					ON  A.DIVISION_ID				= Z.v_DIVISION_ID	
				   AND	A.PROJECT_CODE				= Z.v_PROJECT_CODE	
				   AND	A.SCM_SITE_ID				= Z.v_SCM_SITE_ID	
				   AND	A.ITEM_ID					= Z.v_ITEM_ID		
				   AND	A.DOM_EXP					= Z.v_DOM_EXP		
				   AND	A.FCST_TYPE					= Z.v_FCST_TYPE		
				   AND	A.INCOTERMS					= Z.v_INCOTERMS		
				   AND	A.MEASURE					= Z.v_MEASURE		
				   AND	A.PLANT_SITE_ID				= Z.v_PLANT_SITE_ID
					/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (START) */							
					--AND	A.CELL_PROD_SITE_ID			= Z.v_CELL_PROD_SITE_ID
					AND CASE WHEN Z.v_DIVISION_ID = '40' THEN Z.v_CELL_PROD_SITE_ID ELSE A.CELL_PROD_SITE_ID END = A.CELL_PROD_SITE_ID
					/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (END) */
				   AND	SUBSTRING(A.YYYYMMDD, 1, 6)	= Z.v_YYYYMM						
			WHERE A.DIVISION_ID = @v_DIVISION_ID
			--[E20251027-000091]_MKT FCST 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (START) 원소스 주석처리
			--AND   A.MEASURE		IN ('RTF_SYS_RP')
			AND   A.MEASURE		IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP')
			--[E20251027-000091]_MKT FCST 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (END) 
			--AND   A.QTY			!= 0
			GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
				   , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD;		 
PRINT @v_program_name + ' : A025--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
	
			SELECT @v_max_mf_w_version = MAX(VERSION_NO) 
			FROM DM_MST_VERSION WITH(NOLOCK)
			WHERE DIVISION_ID	= @v_DIVISION_ID 
			AND   VERSION_TYPE	= 'MF_W'
			AND   YYYYMMDD		>= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
			AND   YYYYMMDD		< CONVERT(CHAR(8), DATEADD(DD, 0, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112);				
				
			--SELECT @v_max_sf_w_version  = MAX(VERSION_NO) 
			--FROM DM_MST_VERSION 
			--WHERE DIVISION_ID = @v_DIVISION_ID 
			--AND   VERSION_TYPE = 'SF_W'
			--AND   YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
			--AND   YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, 0, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
			--;

			IF (@v_max_mf_w_version IS NOT NULL) 
			BEGIN
				SELECT @v_max_mf_w_yyyymmdd = YYYYMMDD 
				FROM DM_MST_VERSION  WITH(NOLOCK)
				WHERE DIVISION_ID	= @v_DIVISION_ID 
				AND   VERSION_NO	= @v_max_mf_w_version 
				AND   VERSION_TYPE	= 'MF_W' ;
				--SELECT @v_max_sf_w_yyyymmdd = YYYYMMDD FROM DM_MST_VERSION WHERE DIVISION_ID = @v_DIVISION_ID AND VERSION_NO = @v_max_sf_w_version AND VERSION_TYPE = 'SF_W' ;

				DELETE DM_PLN_CFM_MKT_DEMAND_PLAN_C 
				WHERE DIVISION_ID	= @v_DIVISION_ID
				AND   VERSION_NO	= @v_max_mf_w_version
				AND   CUTOFF_TYPE	= 'MF_W'
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (START) 원소스 주석처리
				--AND   MEASURE IN ('RTF_SYS_RP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW')
				AND   MEASURE IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW')
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (END) 
				AND   EXISTS (	SELECT 1
								FROM #TEMP_SALES_PLAN_INSERT Z WITH(NOLOCK)
								WHERE Z.v_DIVISION_ID		= DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID
								AND	  Z.v_PROJECT_CODE		= DM_PLN_CFM_MKT_DEMAND_PLAN_C.PROJECT_CODE
								AND	  Z.v_SCM_SITE_ID		= DM_PLN_CFM_MKT_DEMAND_PLAN_C.SCM_SITE_ID
								AND	  Z.v_ITEM_ID			= DM_PLN_CFM_MKT_DEMAND_PLAN_C.ITEM_ID
								AND	  Z.v_DOM_EXP			= DM_PLN_CFM_MKT_DEMAND_PLAN_C.DOM_EXP
								AND	  Z.v_FCST_TYPE			= DM_PLN_CFM_MKT_DEMAND_PLAN_C.FCST_TYPE
								AND	  Z.v_INCOTERMS			= DM_PLN_CFM_MKT_DEMAND_PLAN_C.INCOTERMS
								AND	  Z.v_MEASURE			= DM_PLN_CFM_MKT_DEMAND_PLAN_C.MEASURE
								AND	  Z.v_PLANT_SITE_ID		= DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID
								/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (START) */							
								--AND	AND	  Z.v_CELL_PROD_SITE_ID	= DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID
								AND CASE WHEN Z.v_DIVISION_ID = '40' THEN Z.v_CELL_PROD_SITE_ID ELSE DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID END = DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID
								/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (END) */								
								AND	  Z.v_YYYYMM			= SUBSTRING(DM_PLN_CFM_MKT_DEMAND_PLAN_C.YYYYMMDD, 1, 6));
PRINT @v_program_name + ' : A026--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

				INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
				( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
				, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
				, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD
				, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE	
				, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
				, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				)
				SELECT A.DIVISION_ID, @v_max_mf_w_version AS VERSION_NO, 'MF_W' AS CUTOFF_TYPE, @v_max_mf_w_yyyymmdd, A.PROJECT_CODE
					 , A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
					 , A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
					 , A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
					 , NULL						AS ATTRIBUTE1
					 , Z.v_FROM_SITE_ID			AS ATTRIBUTE2			-- [PJ2025-50188] SALES_PLAN 추가 및 수정시 ATTRIBUTE2(FROM_SITE_ID) 데이터 생성 
					 , NULL, NULL, NULL
					 , NULL, NULL, NULL, NULL, NULL
				FROM DM_PLN_SALES_PLAN A WITH(NOLOCK)
				INNER JOIN #TEMP_SALES_PLAN_INSERT Z WITH(NOLOCK)
				ON    A.DIVISION_ID					= Z.v_DIVISION_ID	
				AND	  A.PROJECT_CODE				= Z.v_PROJECT_CODE	
				AND	  A.SCM_SITE_ID					= Z.v_SCM_SITE_ID	
				AND	  A.ITEM_ID						= Z.v_ITEM_ID		
				AND	  A.DOM_EXP						= Z.v_DOM_EXP		
				AND	  A.FCST_TYPE					= Z.v_FCST_TYPE		
				AND	  A.INCOTERMS					= Z.v_INCOTERMS		
				AND	  A.MEASURE						= Z.v_MEASURE		
				AND	  A.PLANT_SITE_ID				= Z.v_PLANT_SITE_ID
				/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (START) */							
				--AND	AND	  A.CELL_PROD_SITE_ID			= Z.v_CELL_PROD_SITE_ID
				AND CASE WHEN Z.v_DIVISION_ID = '40' THEN Z.v_CELL_PROD_SITE_ID ELSE  A.CELL_PROD_SITE_ID END =  A.CELL_PROD_SITE_ID
				/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (END) */				
				AND	 SUBSTRING(A.YYYYMMDD, 1, 6)	= Z.v_YYYYMM						
				WHERE A.DIVISION_ID = @v_DIVISION_ID
				--AND   A.QTY			!= 0
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (START) 원소스 주석처리
				--AND   A.MEASURE		IN ('RTF_SYS_RP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW');
				AND   A.MEASURE		IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP',  'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW');
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (END) 
PRINT @v_program_name + ' : A027--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

				DELETE DM_PLN_MKT_FCST_C 
				WHERE DIVISION_ID	= @v_DIVISION_ID
				AND   VERSION_NO	= @v_max_mf_w_version
				AND   CUTOFF_TYPE	= 'MF_W'
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (START) 원소스 주석처리
				--AND   MEASURE IN ('RTF_SYS_RP')
				AND   MEASURE IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP')
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (END) 
				AND   EXISTS (	SELECT 1
								FROM #TEMP_SALES_PLAN_INSERT Z WITH(NOLOCK)
								WHERE Z.v_DIVISION_ID	= DM_PLN_MKT_FCST_C.DIVISION_ID
								AND	  Z.v_PROJECT_CODE	= DM_PLN_MKT_FCST_C.PROJECT_CODE
								AND	  Z.v_SCM_SITE_ID	= DM_PLN_MKT_FCST_C.SCM_SITE_ID
								AND	  Z.v_ITEM_ID		= DM_PLN_MKT_FCST_C.ITEM_ID
								AND	  Z.v_DOM_EXP		= DM_PLN_MKT_FCST_C.DOM_EXP
								AND	  Z.v_FCST_TYPE		= DM_PLN_MKT_FCST_C.FCST_TYPE
								AND	  Z.v_INCOTERMS		= DM_PLN_MKT_FCST_C.INCOTERMS
								AND	  Z.v_MEASURE		= DM_PLN_MKT_FCST_C.MEASURE
								AND	  Z.v_PLANT_SITE_ID	= DM_PLN_MKT_FCST_C.PLANT_SITE_ID
								AND	  Z.v_YYYYMM		= SUBSTRING(DM_PLN_MKT_FCST_C.YYYYMMDD, 1, 6));
PRINT @v_program_name + ' : A028--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

				INSERT INTO DM_PLN_MKT_FCST_C 
				( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
				, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
				, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY
				, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
				SELECT A.DIVISION_ID, @v_max_mf_w_version AS VERSION_NO, 'MF_W' AS CUTOFF_TYPE, @v_max_mf_w_yyyymmdd AS CUTOFF_YYYYMMDD, A.PROJECT_CODE
					 , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
					 , A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, MAX(A.LAST_UPDATED_BY) AS CREATED_BY
					 , MAX(A.LAST_UPDATE_DATE) AS CREATION_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY, MAX(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
				FROM DM_PLN_SALES_PLAN A WITH(NOLOCK)
				INNER JOIN #TEMP_SALES_PLAN_INSERT Z WITH(NOLOCK)
						ON  A.DIVISION_ID				= Z.v_DIVISION_ID	
					   AND	A.PROJECT_CODE				= Z.v_PROJECT_CODE	
					   AND	A.SCM_SITE_ID				= Z.v_SCM_SITE_ID	
					   AND	A.ITEM_ID					= Z.v_ITEM_ID		
					   AND	A.DOM_EXP					= Z.v_DOM_EXP		
					   AND	A.FCST_TYPE					= Z.v_FCST_TYPE		
					   AND	A.INCOTERMS					= Z.v_INCOTERMS		
					   AND	A.MEASURE					= Z.v_MEASURE		
					   AND	A.PLANT_SITE_ID				= Z.v_PLANT_SITE_ID
						/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (START) */							
						--AND	A.CELL_PROD_SITE_ID			= Z.v_CELL_PROD_SITE_ID
						AND CASE WHEN Z.v_DIVISION_ID = '40' THEN Z.v_CELL_PROD_SITE_ID ELSE  A.CELL_PROD_SITE_ID END =  A.CELL_PROD_SITE_ID
						/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (END) */					   
					   AND	SUBSTRING(A.YYYYMMDD, 1, 6)	= Z.v_YYYYMM						
				WHERE A.DIVISION_ID = @v_DIVISION_ID
				--AND   A.QTY			!= 0
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (START) 원소스 주석처리
				--AND A.MEASURE		IN ('RTF_SYS_RP')
				AND A.MEASURE IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP')
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (END) 
				GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					   , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD;
			END
			
			-- 2025.05.28 SF_W 버전에도 RTF 업데이트 추가 Start
PRINT @v_program_name + ' : A029--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
	
			SELECT @v_max_sf_w_version = MAX(VERSION_NO) 
			FROM DM_MST_VERSION WITH(NOLOCK)
			WHERE DIVISION_ID	= @v_DIVISION_ID 
			AND   VERSION_TYPE	= 'SF_W'
			AND   YYYYMMDD		>= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
			AND   YYYYMMDD		< CONVERT(CHAR(8), DATEADD(DD, 0, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112);				
				
			IF (@v_max_sf_w_version IS NOT NULL) 
			BEGIN
				SELECT @v_max_sf_w_yyyymmdd = YYYYMMDD 
				FROM DM_MST_VERSION  WITH(NOLOCK)
				WHERE DIVISION_ID	= @v_DIVISION_ID 
				AND   VERSION_NO	= @v_max_sf_w_version 
				AND   VERSION_TYPE	= 'SF_W' ;
				--SELECT @v_max_sf_w_yyyymmdd = YYYYMMDD FROM DM_MST_VERSION WHERE DIVISION_ID = @v_DIVISION_ID AND VERSION_NO = @v_max_sf_w_version AND VERSION_TYPE = 'SF_W' ;

				DELETE DM_PLN_CFM_MKT_DEMAND_PLAN_C 
				WHERE DIVISION_ID	= @v_DIVISION_ID
				AND   VERSION_NO	= @v_max_sf_w_version
				AND   CUTOFF_TYPE	= 'SF_W'
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (START) 원소스 주석처리
				--AND MEASURE IN ('RTF_SYS_RP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW')
				AND MEASURE IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW')
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (END) 
				AND   EXISTS (	SELECT 1
								FROM #TEMP_SALES_PLAN_INSERT Z WITH(NOLOCK)
								WHERE Z.v_DIVISION_ID		= DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID
								AND	  Z.v_PROJECT_CODE		= DM_PLN_CFM_MKT_DEMAND_PLAN_C.PROJECT_CODE
								AND	  Z.v_SCM_SITE_ID		= DM_PLN_CFM_MKT_DEMAND_PLAN_C.SCM_SITE_ID
								AND	  Z.v_ITEM_ID			= DM_PLN_CFM_MKT_DEMAND_PLAN_C.ITEM_ID
								AND	  Z.v_DOM_EXP			= DM_PLN_CFM_MKT_DEMAND_PLAN_C.DOM_EXP
								AND	  Z.v_FCST_TYPE			= DM_PLN_CFM_MKT_DEMAND_PLAN_C.FCST_TYPE
								AND	  Z.v_INCOTERMS			= DM_PLN_CFM_MKT_DEMAND_PLAN_C.INCOTERMS
								AND	  Z.v_MEASURE			= DM_PLN_CFM_MKT_DEMAND_PLAN_C.MEASURE
								AND	  Z.v_PLANT_SITE_ID		= DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID
								/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (START) */							
								--AND	  Z.v_CELL_PROD_SITE_ID	= DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID
								AND CASE WHEN Z.v_DIVISION_ID = '40' THEN Z.v_CELL_PROD_SITE_ID ELSE DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID END = DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID
								/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (END) */										
								AND	  Z.v_YYYYMM			= SUBSTRING(DM_PLN_CFM_MKT_DEMAND_PLAN_C.YYYYMMDD, 1, 6));
PRINT @v_program_name + ' : A030--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

				INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
				( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
				, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
				, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD
				, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE	
				, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
				, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				)
				SELECT A.DIVISION_ID, @v_max_sf_w_version AS VERSION_NO, 'SF_W' AS CUTOFF_TYPE, @v_max_sf_w_yyyymmdd, A.PROJECT_CODE
					 , A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
					 , A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
					 , A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
					 , NULL						AS ATTRIBUTE1
					 , Z.v_FROM_SITE_ID			AS ATTRIBUTE2			-- [PJ2025-50188] SALES_PLAN 추가 및 수정시 ATTRIBUTE2(FROM_SITE_ID) 데이터 생성 
					 , NULL, NULL, NULL
					 , NULL, NULL, NULL, NULL, NULL
				FROM DM_PLN_SALES_PLAN A WITH(NOLOCK)
				INNER JOIN #TEMP_SALES_PLAN_INSERT Z WITH(NOLOCK)
				ON    A.DIVISION_ID					= Z.v_DIVISION_ID	
				AND	  A.PROJECT_CODE				= Z.v_PROJECT_CODE	
				AND	  A.SCM_SITE_ID					= Z.v_SCM_SITE_ID	
				AND	  A.ITEM_ID						= Z.v_ITEM_ID		
				AND	  A.DOM_EXP						= Z.v_DOM_EXP		
				AND	  A.FCST_TYPE					= Z.v_FCST_TYPE		
				AND	  A.INCOTERMS					= Z.v_INCOTERMS		
				AND	  A.MEASURE						= Z.v_MEASURE		
				AND	  A.PLANT_SITE_ID				= Z.v_PLANT_SITE_ID								
				/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (START) */							
				--AND	  A.CELL_PROD_SITE_ID			= Z.v_CELL_PROD_SITE_ID
				AND CASE WHEN Z.v_DIVISION_ID = '40' THEN Z.v_CELL_PROD_SITE_ID ELSE A.CELL_PROD_SITE_ID END = A.CELL_PROD_SITE_ID
				/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (END) */					
				AND	 SUBSTRING(A.YYYYMMDD, 1, 6)	= Z.v_YYYYMM						
				WHERE A.DIVISION_ID = @v_DIVISION_ID
				--AND   A.QTY			!= 0
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (START) 원소스 주석처리
				--AND A.MEASURE		IN ('RTF_SYS_RP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW');
				AND A.MEASURE IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW')
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (END) 
PRINT @v_program_name + ' : A031--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

				DELETE DM_PLN_MKT_FCST_C 
				WHERE DIVISION_ID	= @v_DIVISION_ID
				AND   VERSION_NO	= @v_max_sf_w_version
				AND   CUTOFF_TYPE	= 'SF_W'
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (START) 원소스 주석처리
				--AND   MEASURE IN ('RTF_SYS_RP')
				AND   MEASURE IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP')
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 삭제하던 데이터 추가 메져 RTF_SCP, RTF 데이터 삭제 (END) 
				AND   EXISTS (	SELECT 1
								FROM #TEMP_SALES_PLAN_INSERT Z WITH(NOLOCK)
								WHERE Z.v_DIVISION_ID	= DM_PLN_MKT_FCST_C.DIVISION_ID
								AND	  Z.v_PROJECT_CODE	= DM_PLN_MKT_FCST_C.PROJECT_CODE
								AND	  Z.v_SCM_SITE_ID	= DM_PLN_MKT_FCST_C.SCM_SITE_ID
								AND	  Z.v_ITEM_ID		= DM_PLN_MKT_FCST_C.ITEM_ID
								AND	  Z.v_DOM_EXP		= DM_PLN_MKT_FCST_C.DOM_EXP
								AND	  Z.v_FCST_TYPE		= DM_PLN_MKT_FCST_C.FCST_TYPE
								AND	  Z.v_INCOTERMS		= DM_PLN_MKT_FCST_C.INCOTERMS
								AND	  Z.v_MEASURE		= DM_PLN_MKT_FCST_C.MEASURE
								AND	  Z.v_PLANT_SITE_ID	= DM_PLN_MKT_FCST_C.PLANT_SITE_ID
								AND	  Z.v_YYYYMM		= SUBSTRING(DM_PLN_MKT_FCST_C.YYYYMMDD, 1, 6));
PRINT @v_program_name + ' : A032--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

				INSERT INTO DM_PLN_MKT_FCST_C 
				( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
				, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
				, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY
				, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
				SELECT A.DIVISION_ID, @v_max_sf_w_version AS VERSION_NO, 'SF_W' AS CUTOFF_TYPE, @v_max_sf_w_yyyymmdd AS CUTOFF_YYYYMMDD, A.PROJECT_CODE
					 , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
					 , A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, MAX(A.LAST_UPDATED_BY) AS CREATED_BY
					 , MAX(A.LAST_UPDATE_DATE) AS CREATION_DATE, MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY, MAX(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
				FROM DM_PLN_SALES_PLAN A WITH(NOLOCK)
				INNER JOIN #TEMP_SALES_PLAN_INSERT Z WITH(NOLOCK)
						ON  A.DIVISION_ID				= Z.v_DIVISION_ID	
					   AND	A.PROJECT_CODE				= Z.v_PROJECT_CODE	
					   AND	A.SCM_SITE_ID				= Z.v_SCM_SITE_ID	
					   AND	A.ITEM_ID					= Z.v_ITEM_ID		
					   AND	A.DOM_EXP					= Z.v_DOM_EXP		
					   AND	A.FCST_TYPE					= Z.v_FCST_TYPE		
					   AND	A.INCOTERMS					= Z.v_INCOTERMS		
					   AND	A.MEASURE					= Z.v_MEASURE		
					   AND	A.PLANT_SITE_ID				= Z.v_PLANT_SITE_ID
						/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (START) */							
						--AND	A.CELL_PROD_SITE_ID			= Z.v_CELL_PROD_SITE_ID
						AND CASE WHEN Z.v_DIVISION_ID = '40' THEN Z.v_CELL_PROD_SITE_ID ELSE A.CELL_PROD_SITE_ID END = A.CELL_PROD_SITE_ID
						/* JSSBAE CELL_PROD_SITE_ID가 한주 내 다른 데이터가 존재하여 해당 데이터에 대해 구분하도록 작업필요 원소스 주석처리 (END) */	
					   AND	SUBSTRING(A.YYYYMMDD, 1, 6)	= Z.v_YYYYMM						
				WHERE A.DIVISION_ID = @v_DIVISION_ID
				--AND   A.QTY			!= 0
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (START) 원소스 주석처리
				--AND   A.MEASURE		IN ('RTF_SYS_RP')
				AND   A.MEASURE		IN ('RTF_SYS_RP', 'RTF', 'RTF_SCP')
				--[E20251027-000091]_MKT FCST_C 테이블 RTF_SYS_RP만 INSERT 데이터 추가 메져 RTF_SCP, RTF 데이터 생성 (END) 
				GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					   , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD;

			END
			-- 2025.05.28 SF_W 버전에도 RTF 업데이트 추가 End

		END
		--------------------------------------------------------------------------------------------------------------
		-- [PJ2025-50017] CFM_MKT_DEMAND_PLAN 테이블에 ('RTF_SYS_RP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW') DELETE 후 INSERT - END
		--------------------------------------------------------------------------------------------------------------
	END
PRINT @v_program_name + ' : A033--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

	--------------------------------------------------------------------------------------------------------------
	-- 트랜잭션 (COMMIT)
	--------------------------------------------------------------------------------------------------------------
    COMMIT WORK;
		
	--------------------------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------------------------		
	--------------------------------------------------------------------------------------------------------------
    BEGIN CATCH
	--------------------------------------------------------------------------------------------------------------
     -- ROLLBACK	
	--------------------------------------------------------------------------------------------------------------
	-- 트랜잭션 (END)	
	--------------------------------------------------------------------------------------------------------------
	  ROLLBACK TRANSACTION SAVE_DM_PLN_SALES_PLAN_ALL;
      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	--------------------------------------------------------------------------------------------------------------
    END CATCH;
	--------------------------------------------------------------------------------------------------------------

	-- 수행결과 성공여부 DISPLAY
	IF @v_log_message IS NULL
		SELECT 'success';
	--------------------------------------------------------------------------------------------------------------
    -- 종료 LOG
	--------------------------------------------------------------------------------------------------------------
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = 'delete_count= ' + Convert(NVARCHAR(10), @n_del_count) +  ' / insert_count= ' + Convert(NVARCHAR(10), @n_insert_count)  ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  END;
	--------------------------------------------------------------------------------------------------------------
	--[E20250520-000572]_INVALID를 하나로 통합하여 관리하므로, 원 로직 주석처리 START
	--------------------------------------------------------------------------------------------------------------
	/*
	--------------------------------------------------------------------------------------------------------------
	-- 트랜잭션 (END)
	--------------------------------------------------------------------------------------------------------------
	ERR_RTN:
	IF @v_log_type = 'INVALID'
		BEGIN
			ROLLBACK TRANSACTION;
			SET @v_description = 'delete_count= ' + Convert(NVARCHAR(10), @n_del_count) +  ' / insert_count= ' + Convert(NVARCHAR(10), @n_insert_count)  ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
			-- 종료 LOG
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'delete_count= ' + Convert(NVARCHAR(10), @n_del_count) +  ' / insert_count= ' + Convert(NVARCHAR(10), @n_insert_count)  ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END
	--------------------------------------------------------------------------------------------------------------
	--[PJ2024-50611] 입력중복 체크 처리 START
	--INVALID구분자를 다른곳에서 쓰므로 입력중복 구분위해 INVALID2 사용
	--------------------------------------------------------------------------------------------------------------
	ELSE IF @v_log_type = 'INVALID2' --[E20250520-000572]_명확한 메시지 코드로 변경한기위해 원소스 주석처리
		BEGIN
			SELECT 'INVALID2'
			--SELECT @v_log_message - 개행문자 처리 안되어서 화면에서 개행문자 처리
			IF OBJECT_ID (N'tempdb..#TMP_DATA_DUP', N'U') IS NOT NULL 
			BEGIN
				SELECT T.*, D.DEPT_NAME_KO AS v_DEPT_NM FROM #TMP_DATA_DUP T
				LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D
					ON T.v_dept_id = D.dept_id--중복된 전체정보가 필요할까봐 넘김
			END

			ROLLBACK TRANSACTION;
			SET @v_description = 'DUPLICATE'  ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			-- 종료 LOG
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END
	--------------------------------------------------------------------------------------------------------------
	--[PJ2024-50611] 입력중복 체크 처리 END
	--INVALID구분자를 다른곳에서 쓰므로 입력중복 구분위해 INVALID2 사용
	--------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------
	--[PJ2025-50017] CELL_PROD_SITE_ID 추가 - 중복오류 체크 - LOG 남기기 START
	--INVALID구분자를 다른곳에서 쓰므로 입력중복 구분위해 INVALID4 사용
	--------------------------------------------------------------------------------------------------------------
	ELSE IF @v_log_type = 'INVALID4'
		BEGIN
			SELECT 'INVALID4'
			--SELECT @v_log_message - 개행문자 처리 안되어서 화면에서 개행문자 처리
			IF OBJECT_ID (N'tempdb..#TMP_DATA_DUP', N'U') IS NOT NULL 
			BEGIN
				SELECT T.*, D.DEPT_NAME_KO AS v_DEPT_NM FROM #TMP_DATA_DUP T
				LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D
					ON T.v_dept_id = D.dept_id--중복된 전체정보가 필요할까봐 넘김
			END

			ROLLBACK TRANSACTION;
			SET @v_description = 'DUPLICATE'  ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;				
			--------------------------------------------------------------------------------------------------------------
			-- 종료 LOG
			--------------------------------------------------------------------------------------------------------------
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END
	--------------------------------------------------------------------------------------------------------------
	--[PJ2025-50017] CELL_PROD_SITE_ID 추가 - 중복오류 체크 - LOG 남기기 END
	--INVALID구분자를 다른곳에서 쓰므로 입력중복 구분위해 INVALID4 사용
	--------------------------------------------------------------------------------------------------------------	
	--------------------------------------------------------------------------------------------------------------
	--[PJ2024-50611] 기타 메세지 처리 START
	--메세지별로 다른 INVALID 분기 타기에 무리가 있으므로 사전에 정의된 메세지 코드를 리턴시킨다
	--------------------------------------------------------------------------------------------------------------
	ELSE IF @v_log_type = 'INVALID_MSG'
		BEGIN
			SELECT @v_log_type
			SELECT @v_log_message

			ROLLBACK TRANSACTION;
			SET @v_description = 'INVALID'  ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;			
			--------------------------------------------------------------------------------------------------------------
			-- 종료 LOG
			--------------------------------------------------------------------------------------------------------------
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END
	--------------------------------------------------------------------------------------------------------------
	--[PJ2024-50611] 기타 메세지 처리 END
	--메세지별로 다른 INVALID 분기 타기에 무리가 있으므로 사전에 정의된 메세지 코드를 리턴시킨다
	--------------------------------------------------------------------------------------------------------------	
	*/
	--------------------------------------------------------------------------------------------------------------
	--[E20250520-000572]_INVALID를 하나로 통합하여 관리하므로, 원 로직 주석처리 END
	--------------------------------------------------------------------------------------------------------------
PRINT @v_program_name + ' AAAA: VALIDATION :' + @s_code + ' TEXT: ' + @s_validation + CONVERT(NVARCHAR(30), GETDATE(), 121);
	--------------------------------------------------------------------------------------------------------------
	--[E20250520-000572]_VALIDATION 체크를 공통으로 사용한다. START
	--------------------------------------------------------------------------------------------------------------	
	ERR_RTN:
	IF @v_log_type = 'INVALID' 
		BEGIN
PRINT @v_program_name + ' : A030: VALIDATION --' + @s_code + ' TEXT: ' + @s_validation + ' / '+ CONVERT(NVARCHAR(30), GETDATE(), 121);
			SELECT @s_code + '^' + @s_validation

			ROLLBACK TRANSACTION;
			SET @v_log_message = @s_code; --메시지코드를 작성한다.
			SET @v_description = @s_code + '^' + @s_validation; --코드 + 메시지가 저장되도록 한다.
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;			
			--------------------------------------------------------------------------------------------------------------
			-- 종료 LOG
			--------------------------------------------------------------------------------------------------------------
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			SET @s_code = NULL;
			SET @s_validation = NULL;
		END
	--------------------------------------------------------------------------------------------------------------
	--[E20250520-000572]_VALIDATION 체크를 공통으로 사용한다.END
	--------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------
	--[E20250520-000572]_VALIDATION 체크를 공통으로 사용하는 곳이 없다 주석처리 한다 START
	--------------------------------------------------------------------------------------------------------------
	/*
	--------------------------------------------------------------------------------------------------------------
	--[PJ2024-50611] RTF_SYS_RP 존재여부 체크 START
	--INVALID구분자를 다른곳에서 쓰므로 입력중복 구분위해 INVALID3 사용
	--------------------------------------------------------------------------------------------------------------
	ELSE IF @v_log_type = 'INVALID3'
		BEGIN
			SELECT 'INVALID3'
			SELECT @v_log_message --존재하지 않는 월 화면으로 전달

			ROLLBACK TRANSACTION;
			SET @v_description = 'INVALID'  ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;					
			--------------------------------------------------------------------------------------------------------------
			-- 종료 LOG
			--------------------------------------------------------------------------------------------------------------
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END
	--------------------------------------------------------------------------------------------------------------
	--[PJ2024-50611] RTF_SYS_RP 존재여부 체크 END
	--INVALID구분자를 다른곳에서 쓰므로 입력중복 구분위해 INVALID3 사용
	--------------------------------------------------------------------------------------------------------------
	*/
	--------------------------------------------------------------------------------------------------------------
	--[E20250520-000572]_VALIDATION 체크를 공통으로 사용하는 곳이 없다 주석처리 한다 END
	--------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------
	--[PJ2025-50017] 각종 Validation Check - LOG 남기기 START
	--------------------------------------------------------------------------------------------------------------
	ELSE IF @v_log_type = 'INVALID5'
		BEGIN
			SELECT 'INVALID5'
			ROLLBACK
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########'; -- Validation Check 에 해당
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			-- DataTable[0]
			-- 결과코드, 결과 카운트 반환
			SELECT  'F' AS RESULT_CODE,  @v_description AS RESULT_MSG, 'ERR_RTN: - Validation Check' AS ERR_EVENT
		END
	--------------------------------------------------------------------------------------------------------------
	--[PJ2025-50017] 각종 Validation Check - LOG 남기기 END	
	--------------------------------------------------------------------------------------------------------------

