

/*==============================================================================================================================
 * Program ID   : PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE
 * Description  : 매주 목,금요일에 Sales Plan Weekly cutoff 수행(81 : 목 00시, 40,82 : 금 00시)
 * Program History
 *==============================================================================================================================
 *   Date       In Charge   Description
 *==============================================================================================================================
 * 2020-07-01	P.C.I		[PJ20200138] Sales Plan Waterfall cut-off 주기 변경 - MKT_FCST_C/SALES_PLAN_C 분리(Weekly Cutoff Sales Price Version No 조회 (40,81 : 화요일 /82 : SP Version과 동일))
 * 2020-07-22	P.C.I		[PJ20200138] Sales Plan Weekly Cutoff 생성시 Sales Price, Exchange Rate Cutoff 동시 생성
 * 2020-07-27	P.C.I		[PJ20200138] Sales Plan Weekly Cutoff 생성시 실적은 MKT Fcst가 Cutoff 되는 시점의 화요일 Cutoff 실적을 사용하도록 로직 수정
 * 2020-07-31	HWI1993		과제 - ESS 실적매핑시 내부거래등 제거로직 적용에 따른 RESULT.ATTRIBUTE2 추가(확인) - 변경사항 없음.
 * 2020-09-09   P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2020-12-08   P.C.I		[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
 * 2021-02-05	KUNI		[C20210204-000387] (82)ESS사업부_SALES PLAN WATERFALL에 ETC매출 포함(LOOKUP)
 * 2021-07-02	HWI1993		[C20210629-000239] [SCM PI팀] MKT FCST Amt. 추가의 건
 * 2022-04-07   hwi1993     GM JV 작업
 * 2023-01-17   chano0612   [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건 - 선박BIZ건
 * 2023-03-11   chano0612   [E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건
 * 2024-04-03   KCW3408     Sales Plan 관련 자동사업부 기타 매출 추가(LOOKUP_TYPE:DM_SALES_PLAN_WATERFALL_SP_W_ADD)
 * 2024-05-28	HMIN		[E20240508-000695] Corvus/Siemens사 자동차사업부 RTF 산출 시 동기화 반영 요청  
							룩업(DM_NET_DEMAND_EXCEPTION)에 등록된 SITE대상으로 82번 사업부에 RTF정보를 81번 RTF 정보로 반영 처리 
 * 2024-10-30	JSSAE		[E20241024-001084]_MKT FCST ↔ Sales Plan 실적 차이 발생 개선 요청 件 
 * 2024-11-15	KJJ			[PJ2024-50611] 소형사업부 Sales Plan 기타매출 입력 추가 
 * 2024-11-15	KANG.H.J	[PJ2024-50611] 소형 매출 프로세스 개선		
 * 2024-11-29	KANG.H.J	[PJ2024-50611] FROM_SITE_ID가 추가된 'DM_PLN_RTF_ALLOCATION_C' 테이블 Sales Plan Cutoff(전 사업부대상)
 * 2024-12-03	KJJ			[PJ2024-50611] 소형사업부 Sales Plan Catch Up 컷오프 추가
 * 2024-12-17	KJJ			[PJ2024-50611] 기타매출, Catch Up 테이블 분리
 * 2025-03-18	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선
 * 2025-04-08	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제처리
 * 2025-04-23	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - MF_W / SF_W 를 LOOKUP 기준에서 조치함. / SCM_FCST 추가
 * 2025-04-28	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - BPS 전송용 FROM_SITE_ID(ATTRIBUTE2 연계) (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
 * 2025-05-02	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - #T_PRICE의 CELL_PROD_SITE_ID 기준을 MKT_DEMAND_PLAN_C로 기준 변경
 * 2025-05-07	KANG.H.J	[PJ2025-50188] 기준수요처레에 따른 CUTOFF_TYPE 버젼 생성 구분처리
 * 2025-05-29	KANG.H.J	[PJ2025-50188] 임시테이블 #T3_MKT_FCST / #T3_PRICE DROP 추가, 임시테이블 #T3_MKT_FCST ==> #T_SP_C_BALANCE_MKT_FCST / #T3_PRICE ==> #T_SP_C_BALANCE_PRICE 변경 
 * 2025-06-05	KANG.H.J	[PJ2025-50188] EXCEPTION_DEMAND의 CELL_PROD_SITE_ID 수정 
 * 2025-06-05	JSSBAE		[E20250529-001289]_DM 장애 대응 개선을 위한 시스템 개선
 * 2025-06-13	KANG.H.J	[PJ2025-50188] SALES_AMT (3종) ATTRIBUTE2 (FROM_SITE_ID) 누락 개선  
 * 2025-06-18	KANG.H.J	[PJ2025-50188] ON절에서 WHERE 절로 이동 
 * 2025-06-18	KANG.H.J	[PJ2025-50188] 40사업부는 CELL_PROD_SITE_ID까지 PRICE 비교 / 81,82사업부는 CELL_PROD_SITE_ID를 '-'로 치환하여 PRICE 비교  
 * 2025.06.23	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.07.23	JSSBAE		[PJ2025-50188]_소형 매출계획 동기화 개선 고도화 [Sales Price Cutoff 개선]
 * 2026.07.08	JSSBAE		[E20260630-000725]_[요청] SCM Sales Plan Waterfall 내 판가 반영 및 매출금액 산출 로직 오류 점검 요청

 EXEC PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE  @p_division_id='81', @p_cutoff_yyyymmdd = '20240401'
 --PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE '81', '20230314'
 ==============================================================================================================================*/

CREATE PROCEDURE [dbo].[PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE]
	 @p_division_id				NVARCHAR(30)  -- DIVISION_ID
   , @p_cutoff_yyyymmdd			NVARCHAR(08)  -- Sales Plan Cutoff 날짜
   , @p_creation_type			NVARCHAR(100)  = 'REGULAR' --[E20250529-001289]_생성에 따라 메일링 문구가 다르기 때문에, 배치일정을 기본으로 셋팅한다.
AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;
	--===========================================================================================================
	-- LOG 용 변수 설정
	--===========================================================================================================
    DECLARE @v_program_name				NVARCHAR(150) = 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE';
    DECLARE @v_log_type					NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count				INTEGER = 0;
    DECLARE @v_log_message				NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);
    DECLARE @d_event_date				DATETIME;	
    DECLARE @c_MF_version				NVARCHAR(100);
    --DECLARE @c_FP_version				NVARCHAR(100);
    DECLARE @plan_start_yyyymmdd		NVARCHAR(08);
    --DECLARE @c_SP_version				NVARCHAR(18);	
    DECLARE @v_cutoff_version_type		NVARCHAR(10);		-- [PJ2025-50188] CUTOFF_VERSION_TYPE DEFAULT 정의
	
	--===========================================================================================================
	--[E20241024-001084]_MKT FCST ↔ Sales Plan 실적 차이 발생 개선 요청 件
	--===========================================================================================================
	--MKT FCST CUTOFF 버전의 날짜를 사용하여, 해당 부분을 더이상 사용하지 않으므로 주석처리
    --DECLARE @c_plan_tue_yyyymmdd		NVARCHAR(08);  --[PJ20200138] Sales Plan Result Daily Cutoff YYYYMMDD	
	DECLARE @c_MF_result_version		NVARCHAR(100); --[PJ20200138] Sales Plan Result Daily Cutoff Version
	DECLARE @c_SP_result_version		NVARCHAR(100); --[PJ20200138] Sales Plan Result Daily Cutoff Version
    DECLARE @c_ver_type					NVARCHAR(10)   = 'SP_W'
    DECLARE @v_created_by				NVARCHAR(1000) = 'system'
	DECLARE @v_count					INT = 0; --[E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건
	DECLARE @s_count					INT = 0; --[E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건
	DECLARE @CNT						INT = 0; --[E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건
	DECLARE @i							INT = 0; --[E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건
	DECLARE @v_SITE_ID					NVARCHAR(100); --[E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건
	DECLARE	@v_ver_return_no			NVARCHAR(100);	-- cut off Generated Number	
	DECLARE	@v_OK_description			NVARCHAR(1200);	-- cut off Generated Number	

PRINT ( @v_program_name + ' A001: ' + 'DIVISION_ID: '+ @p_division_id + ' / CUTOFF_YYYYMMDD: '+ @p_cutoff_yyyymmdd )	 

	--===========================================================================================================
	-- [PJ2025-50188] 임시테이블 #T3_MKT_FCST / #T3_PRICE DROP 추가, 임시테이블 #T3_MKT_FCST ==> #T_SP_C_BALANCE_MKT_FCST / #T3_PRICE ==> #T_SP_C_BALANCE_PRICE 변경 
	--===========================================================================================================
	IF OBJECT_ID (N'tempdb..#T_SP_C_BALANCE_MKT_FCST', N'U') IS NOT NULL 
		DROP TABLE #T_SP_C_BALANCE_MKT_FCST
	IF OBJECT_ID (N'tempdb..#T_SP_C_BALANCE_PRICE', N'U') IS NOT NULL 
		DROP TABLE #T_SP_C_BALANCE_PRICE
	IF OBJECT_ID('tempdb..#SALES_PLAN_TEMP') IS NOT NULL
		DROP TABLE  #SALES_PLAN_TEMP       
	--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : TMP 테이블 생성 
	IF OBJECT_ID('tempdb..#SALES_ETC_PLAN_TEMP') IS NOT NULL
		DROP TABLE  #SALES_ETC_PLAN_TEMP     

	--===========================================================================================================
	-- [PJ2025-50188] 임시테이블 #T3_MKT_FCST ==> #T_SP_C_BALANCE_MKT_FCST 변경
	--===========================================================================================================
	CREATE TABLE #T_SP_C_BALANCE_MKT_FCST 
	(	  DIVISION_ID		NVARCHAR(30)
		, VERSION_NO		NVARCHAR(50)
		, CUTOFF_TYPE		NVARCHAR(10)
		, CUTOFF_YYYYMMDD	NVARCHAR(8)
		, PROJECT_CODE		NVARCHAR(50)
		, SCM_SITE_ID		NVARCHAR(30)
		, ITEM_ID			NVARCHAR(50)
		, DOM_EXP			NVARCHAR(3)
		, FCST_TYPE			NVARCHAR(20)
		, INCOTERMS			NVARCHAR(10)
		, MEASURE			NVARCHAR(50)
		, YYYYMMDD			NVARCHAR(8)
		, PLANT_SITE_ID		NVARCHAR(30)
		, CELL_PROD_SITE_ID	NVARCHAR(30)				-- [PJ2025-50017] 추가
		, QTY				NUMERIC(30,10)
		, CREATED_BY		NVARCHAR(150)
		, CREATION_DATE		DATETIME
		, LAST_UPDATED_BY	NVARCHAR(150)
		, LAST_UPDATE_DATE	DATETIME
		, ATTRIBUTE1		NVARCHAR(150)
		, ATTRIBUTE2		NVARCHAR(150)
		, ATTRIBUTE3		NVARCHAR(150)
		, ATTRIBUTE4		NVARCHAR(150)
		, ATTRIBUTE5		NVARCHAR(150)
		, ATTRIBUTE6		NVARCHAR(150)
		, ATTRIBUTE7		NVARCHAR(150)
		, ATTRIBUTE8		NVARCHAR(150)
		, ATTRIBUTE9		NVARCHAR(150)
		, ATTRIBUTE10		NVARCHAR(150))
		
	--===========================================================================================================
	-- [PJ2025-50188] 임시테이블 #T3_PRICE ==> #T_SP_C_BALANCE_PRICE 변경 
	--===========================================================================================================
	CREATE TABLE #T_SP_C_BALANCE_PRICE 
	(	  DIVISION_ID		NVARCHAR(30)
		, VERSION_NO		NVARCHAR(50)
		, CUTOFF_TYPE		NVARCHAR(10)
		, CUTOFF_YYYYMMDD	NVARCHAR(8)
		, PROJECT_CODE		NVARCHAR(50)
		, SCM_SITE_ID		NVARCHAR(30)
		, PLANT_SITE_ID		NVARCHAR(30)
		, CELL_PROD_SITE_ID	NVARCHAR(30)				-- [PJ2025-50017] 추가
		, ITEM_ID			NVARCHAR(50)
		, YYYYMMDD			NVARCHAR(8)
		, CURRENCY			NVARCHAR(10)
		, MEASURE			NVARCHAR(50)
		, DOM_EXP			NVARCHAR(3)
		, FCST_TYPE			NVARCHAR(20)
		, INCOTERMS			NVARCHAR(10)
		, PRICE				NUMERIC(30,10)
		, CREATED_BY		NVARCHAR(150)
		, CREATION_DATE		DATETIME
		, LAST_UPDATED_BY	NVARCHAR(150)
		, LAST_UPDATE_DATE	DATETIME
		, ATTRIBUTE1		NVARCHAR(150)
		, ATTRIBUTE2		NVARCHAR(150)
		, ATTRIBUTE3		NVARCHAR(150)
		, ATTRIBUTE4		NVARCHAR(150)
		, ATTRIBUTE5		NVARCHAR(150)
		, ATTRIBUTE6		NVARCHAR(150)
		, ATTRIBUTE7		NVARCHAR(150)
		, ATTRIBUTE8		NVARCHAR(150)
		, ATTRIBUTE9		NVARCHAR(150)
		, ATTRIBUTE10		NVARCHAR(150))	
		
	--===========================================================================================================
	-- 변수값 셋팅
	--===========================================================================================================
	IF @p_cutoff_yyyymmdd = '' 
	BEGIN 
		SET @p_cutoff_yyyymmdd = CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
	END

	SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(@p_cutoff_yyyymmdd, 'MON')), 112)   -- 월요일
	
	--===========================================================================================================
	--[E20241024-001084]_MKT FCST ↔ Sales Plan 실적 차이 발생 개선 요청 件
	--===========================================================================================================
	--MKT FCST CUTOFF 버전의 날짜를 사용하여, 해당 부분을 더이상 사용하지 않으므로 주석처리
	--SET @c_plan_tue_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(@p_cutoff_yyyymmdd, 'TUE')), 112)   -- 화요일 [PJ20200138] Sales Plan Result Daily Cutoff YYYYMMDD
	
	--===========================================================================================================
	-- 시작 LOG  (START)
	--===========================================================================================================
	SET @v_log_type		= 'START';
	SET @v_log_message	= '########## Start of procedure ##########';
    SET @v_description	= N'@p_division_id : ' + RTRIM(LTRIM(@p_division_id)) ;
	SET @d_event_date	= SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message	= NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	--===========================================================================================================
	-- 시작 LOG  (END)
	--===========================================================================================================
	--===========================================================================================================
	-- 트랜잭션 (START)
	--===========================================================================================================
	--BEGIN TRANSACTION MKT_FCST_C_QTY_BALANCE_CREATE;
	
	-- [C20210204-000387] 
	/* 2024-04-03   KCW3408     Sales Plan 관련 자동사업부 기타 매출 추가(LOOKUP_TYPE:DM_SALES_PLAN_WATERFALL_SP_W_ADD) */
	IF( @P_DIVISION_ID = '82' OR @P_DIVISION_ID LIKE '81%'  )
	BEGIN
		DECLARE @S_BLOCK_MODEL  NVARCHAR(MAX);  
		SET @S_BLOCK_MODEL = '';  
		SET @S_BLOCK_MODEL = ISNULL((  SELECT TOP 1 ISNULL(LOOKUP_TYPE,'') AS TYPE
									   FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)  
									   WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
									   AND SEGMENT1 = @P_DIVISION_ID
									   AND VALID_YN = 'Y'  
									   AND SEGMENT1 IS NOT NULL
									   AND SEGMENT2 IS NOT NULL
									   AND SEGMENT3 IS NOT NULL	),'')
		IF @S_BLOCK_MODEL = ''  
		BEGIN  
			SET @V_LOG_TYPE = 'INVALID';  
			SELECT 'MODEL : ' + @S_BLOCK_MODEL +CHAR(10) + N'DM_SALES_PLAN_WATERFALL_SP_W_ADD IS NOT'  
			SET @V_DESCRIPTION = 'MODEL : ' + @S_BLOCK_MODEL +CHAR(10) + N'DM_SALES_PLAN_WATERFALL_SP_W_ADD IS NOT'  

			GOTO ERR_RTN  
		END  
	END
	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------		
PRINT ( @v_program_name + ' A002: ' + 'DIVISION_ID: '+ @p_division_id + N' / CUTOFF_YYYYMMDD: '+ @p_cutoff_yyyymmdd )
 
		--===========================================================================================================
		-- MKT FCST -> SALES PLAN 동기화 진행
		--===========================================================================================================
		EXEC [dbo].[PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW] @p_division_id, 'SYSTEM'

PRINT ( @v_program_name + ' A003: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )
		--===========================================================================================================
	    -- Cutoff Version 생성
		--===========================================================================================================
		EXEC [dbo].[PR_DM_PLN_VERSION_CREATE]	--@return_value = [dbo].[PR_DM_PLN_VERSION_CREATE]
		  @p_division_id
		, 'SALES_PLAN WEEKLY CUTOFF'
		, @c_ver_type
		, @v_created_by
		, @v_ver_return_no  OUTPUT
		, @v_OK_description OUTPUT;				

PRINT ( @v_program_name + ' A004: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )

		--SET @c_SP_version = @v_ver_return_no   -- SALES PLAN 용
		--------------------------------------------------------------------------------------------------------------
		-- [PJ2025-50188] VERSION_TYPE 구분 (START)
		SELECT TOP 1 @v_cutoff_version_type	= A.VERSION_TYPE		-- [PJ2025-50188] MF_W / SF_W. 가장 최근의 버젼
		FROM (	SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, CREATION_DATE
					 , RANK() OVER (ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC, VERSION_TYPE DESC) AS RN	-- [PJ2025-50188] 가장 최근의 버젼이면서 SF_W가 MF_W보다 우선함.
				FROM  DM_MST_VERSION WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND   VERSION_TYPE IN ('MF_W', 'SF_W')
				AND   YYYYMMDD >= @plan_start_yyyymmdd	) A
		WHERE RN = 1 ;

		SELECT @c_MF_version = MAX(VERSION_NO)				-- [PJ2025-50188] 40 사업부는 SF_W / 그 외는 MF_W 기반으로 VERSION 생성
		FROM   DM_MST_VERSION WITH(NOLOCK)
		WHERE  DIVISION_ID  = @p_division_id
		and    yyyymmdd    >= @plan_start_yyyymmdd
		and    version_type = @v_cutoff_version_type
		
PRINT ( @v_program_name + ' A005: ' + 'DIVISION_ID: '+ @p_division_id + N' / MF_W버전: '+ @c_MF_version )

		SELECT @c_MF_result_version = MAX(VERSION_NO)		-- [PJ2025-50188] 실적과 연계된 VERSION은 MF_W만으로 한정함.
		FROM   DM_MST_VERSION WITH(NOLOCK)
		WHERE  DIVISION_ID  = @p_division_id
		and    yyyymmdd    >= @plan_start_yyyymmdd
		and    version_type = 'MF_W'
		--[PJ2025-50188] VERSION_TYPE 구분 (END)
		--------------------------------------------------------------------------------------------------------------
PRINT ( @v_program_name + ' A006: ' + 'DIVISION_ID: '+ @p_division_id + N' / 실적버전: '+ @c_MF_version )

		--[PJ20200138] Sales Price, Exchange Rate Cutoff 동시 생성
		-- Weekly Cutoff Sales Price Version No 조회 (40,81 : 화요일 /82 : SP Version과 동일)
		/*
		IF @p_division_id IN ('40', '81') AND @c_ver_type = 'SP_W'
			BEGIN
				SELECT @c_FP_version = ISNULL(MAX(VERSION_NO), @c_SP_version)
				FROM   DM_MST_VERSION WITH(NOLOCK)
				WHERE  DIVISION_ID  = @p_division_id
				and    yyyymmdd    >= @plan_start_yyyymmdd
				and    yyyymmdd    <= @p_cutoff_yyyymmdd
				and    version_type = 'SP_W'
				and    CREATED_BY   = 'WITHOUT_SP_W'
			END
	
		ELSE

			BEGIN 
				SET @c_FP_version = @c_SP_version
			END
			*/			

		--===========================================================================================================
		--[PJ20200138] Sales Plan Result Daily Cutoff Version
		--===========================================================================================================
		SELECT @c_SP_result_version = MIN(VERSION_NO)
		FROM   DM_MST_VERSION WITH(NOLOCK)
		WHERE  DIVISION_ID  = @p_division_id
		--------------------------------------------------------------------------------------------------------------
		--[E20241024-001084]_MKT FCST ↔ Sales Plan 실적 차이 발생 개선 요청 件 (START)
		--MKT FCST CUTOFF와 SALES PLAN CUTOFF의 DIFF가 발생함에 따라, SP_D를 MKT FCST CUTOFF 날짜의 가장 마지막 버전을 가져와서 CUTOFF 하는 부분으로 부분으로 수정함	
		--AND    YYYYMMDD     = @c_plan_tue_yyyymmdd
		AND   YYYYMMDD = SUBSTRING(@c_MF_result_version, 6, 8)			-- [PJ2025-50188] 실적과 연계된 VERSION은 MF_W만으로 한정하여 VERSION 생성
		--[E20241024-001084]_MKT FCST ↔ Sales Plan 실적 차이 발생 개선 요청 件 (END)
		--------------------------------------------------------------------------------------------------------------
		AND   VERSION_TYPE = 'SP_D'

PRINT ( @v_program_name + ' A007: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_D버전: '+ @c_SP_result_version )
		--===========================================================================================================
		-- 진행 LOG  (START)
		--===========================================================================================================
		SET @v_log_type		= 'ING';
		SET @v_log_message	= 'SALES_PLAN WEEKLY CUTOFF';
		SET @v_description	= N'@p_division_id : ' + RTRIM(LTRIM(@p_division_id)) +' / ' + N'@v_ver_return_no : ' + RTRIM(LTRIM(@v_ver_return_no)) +' / ' + N'@c_MF_version : ' + RTRIM(LTRIM(@c_MF_version)) 
							+' / ' + N'@c_MF_result_version : ' + RTRIM(LTRIM(@c_MF_result_version)) ; -- [PJ2025-50188] @c_MF_result_version 추가
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message	= NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		--===========================================================================================================
		-- 진행 LOG  (END)
		--===========================================================================================================
PRINT ( @v_program_name + ' A008: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_D버전: '+ @c_SP_result_version )

		---------------------------------------------------------------------------------------------------------------------------
		--[PJ2025-50188]_SALES PRICE를 모두 CUTOFF하여 데이터 양이 너무 방대해지므로, 실제 필요한 데이터만을 CUTOFF 하는것으로 로직 변경 (START)
		-- SALES PLAN CUTOFF된 데이터들만 SALES PRICE CUTOFF 하기위해 위치를 CUTOFF이후로 이동 해당 부분은 주석처리 하단에서 작업함
		--===========================================================================================================
		--[PJ20200138] Sales Price, Exchange Rate Cutoff 동시 생성 (START)
		--===========================================================================================================
		--IF @p_division_id = '82' AND @c_ver_type = 'SP_W'
		BEGIN
			--------------------------------------------------------------------------------------------------------
			-- SALES PRICE CUTOFF (금액)
			--------------------------------------------------------------------------------------------------------
			EXEC [dbo].[PR_SCM_MST_FUTURE_PRICE_CUTOFF]	@p_division_id, @c_ver_type, @v_created_by, @v_ver_return_no, @c_MF_result_version;
			
			--------------------------------------------------------------------------------------------------------
			-- EXCHANGE CUTOFF (환율)
			--------------------------------------------------------------------------------------------------------
			EXEC [dbo].[PR_DM_MST_EXCHANGE_RATE_CUTOFF]	@p_division_id, @c_ver_type, @v_created_by, @v_ver_return_no;
		END
		--===========================================================================================================
		--[PJ20200138] Sales Price, Exchange Rate Cutoff 동시 생성 (END)
		--===========================================================================================================	
		--[PJ2025-50188]_SALES PRICE를 모두 CUTOFF하여 데이터 양이 너무 방대해지므로, 실제 필요한 데이터만을 CUTOFF 하는것으로 로직 변경 (END)
		---------------------------------------------------------------------------------------------------------------------------
		
PRINT ( @v_program_name + ' A009: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )
		
		--===========================================================================================================
		-- 1. DM_PLN_SALES_PLAN_C CUTOFF
		--===========================================================================================================
		BEGIN            
			---------------------------------------------------------------------------------------------------------
			-- DM_PLN_SALES_PLAN 용 TEMP TABLE 생성
			---------------------------------------------------------------------------------------------------------
			SELECT TOP 0 DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
					   , PLANT_SITE_ID, CELL_PROD_SITE_ID -- [PJ2025-50017] 추가
					   , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					   , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					   , ATTRIBUTE9, ATTRIBUTE10
			INTO #SALES_PLAN_TEMP  
			FROM DM_PLN_SALES_PLAN WITH(NOLOCK);
			---------------------------------------------------------------------------------------------------------
			--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : TMP 테이블 생성 
			---------------------------------------------------------------------------------------------------------                 
			SELECT TOP 0 DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, REMARK_TEXT, DOM_EXP, FCST_TYPE, INCOTERMS
					   , MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
					   , LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
					   , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10				
			INTO #SALES_ETC_PLAN_TEMP  
			FROM DM_PLN_SALES_ETC_PLAN WITH(NOLOCK);			

PRINT ( @v_program_name + ' A010: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )

			---------------------------------------------------------------------------------------------------------
			-- [PJ2025-50017] 소형 매출계획 동기화 개선 Start
			-- [PJ2025-50017] 40 사업부 DM_PLN_CFM_MKT_DEMAND_PLAN_C 기반 데이터 생성
			-- [PJ2025-50017] 81/82 사업부 DM_PLN_MKT_FCST_C(MKT_FCST 기반 메져) / DM_PLN_CFM_MKT_DEMAND_PLAN_C(RTF 기반 메져) 기반 데이터 생성
			IF (@p_division_id = '40')
			BEGIN
				---------------------------------------------------------------------------------------------------------
				-- DM_PLN_CFM_MKT_DEMAND_PLAN_C -> #T_SP_C_BALANCE_MKT_FCST TEMP 테이블 생성
				---------------------------------------------------------------------------------------------------------
				INSERT INTO #T_SP_C_BALANCE_MKT_FCST	-- [PJ2025-50188] 임시테이블 #T3_MKT_FCST ==> #T_SP_C_BALANCE_MKT_FCST 변경 
				( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
				, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
				, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
				, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
					 , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
					 , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, @v_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
					 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND   VERSION_NO  = @c_MF_version
				AND   YYYYMMDD   >= @plan_start_yyyymmdd;
				
				---------------------------------------------------------------------------------------------------------
				-- [PJ2025-50188] DM_PLN_CFM_MKT_DEMAND_PLAN_C 에 RTF_SCP가 없기 때문에 RTF_SYS_RP 기반으로 COPY 필요함.
				-- [PJ2025-50188] 임시테이블 #T3_MKT_FCST ==> #T_SP_C_BALANCE_MKT_FCST 변경 
				---------------------------------------------------------------------------------------------------------
				DELETE #T_SP_C_BALANCE_MKT_FCST
				WHERE DIVISION_ID = @p_division_id
				AND   VERSION_NO  = @c_MF_version
				AND   YYYYMMDD   >= @plan_start_yyyymmdd
				AND	  MEASURE	  = 'RTF_SCP';
				
				---------------------------------------------------------------------------------------------------------
				-- [PJ2025-50188] DM_PLN_CFM_MKT_DEMAND_PLAN_C => 임시테이블 #T3_MKT_FCST ==> #T_SP_C_BALANCE_MKT_FCST 변경 
				---------------------------------------------------------------------------------------------------------
				INSERT INTO #T_SP_C_BALANCE_MKT_FCST 
				( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
				, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
				, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
				, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
					 , FCST_TYPE, INCOTERMS, 'RTF_SCP' AS MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
					 , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, @v_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
					 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND   VERSION_NO  = @c_MF_version
				AND   YYYYMMDD   >= @plan_start_yyyymmdd
				AND	  MEASURE	  = 'RTF_SYS_RP' ;
				
				---------------------------------------------------------------------------------------------------------
				-- [PJ2025-50188] DM_PLN_CFM_SELLING_PRICE_C => 임시테이블 #T3_PRICE ==> #T_SP_C_BALANCE_PRICE 변경 		
				---------------------------------------------------------------------------------------------------------			
				INSERT INTO #T_SP_C_BALANCE_PRICE 
				( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID -- [PJ2025-50017] 추가
				, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
				, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
				, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10	)
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID -- [PJ2025-50017] 추가
					 , ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE, @v_created_by	AS LAST_UPDATED_BY
					 , GETDATE() AS LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5		
					 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10		
				FROM DM_PLN_CFM_SELLING_PRICE_C WITH(NOLOCK) 
				WHERE DIVISION_ID	= @p_division_id 
				AND VERSION_NO		= @v_ver_return_no
				AND YYYYMMDD		>= @plan_start_yyyymmdd	;
PRINT ( @v_program_name + ' A011: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )

			END
			ELSE
			BEGIN
PRINT ( @v_program_name + ' A012: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )

				---------------------------------------------------------------------------------------------------------
				-- [PJ2025-50188] 임시테이블 #T3_MKT_FCST ==> #T_SP_C_BALANCE_MKT_FCST 변경 
				---------------------------------------------------------------------------------------------------------
				INSERT INTO #T_SP_C_BALANCE_MKT_FCST 
				( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
				, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	-- [PJ2025-50017] 추가
				, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
				, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
					 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] 추가
					 , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, @v_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
					 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM DM_PLN_MKT_FCST_C WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND   VERSION_NO  = @c_MF_version
				AND   YYYYMMDD   >= @plan_start_yyyymmdd
				AND   MEASURE NOT IN ('RTF','RTF_SYS_RP','RTF_SCP', 'RTF_PR', 'SalesAmt_LOC','SalesAmt_KRW','SalesAmt_USD','VMI_IN_PLAN','AS_IN_PLAN')
				UNION 
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
					 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID  -- [PJ2025-50017] 추가
					 , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, @v_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
					 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND   VERSION_NO  = @c_MF_version
				AND   YYYYMMDD   >= @plan_start_yyyymmdd
				AND   MEASURE IN ('RTF','RTF_SYS_RP','RTF_SCP', 'RTF_PR', 'SalesAmt_LOC','SalesAmt_KRW','SalesAmt_USD','VMI_IN_PLAN','AS_IN_PLAN') ;
				
				---------------------------------------------------------------------------------------------------------
				-- SCM_MST_FUTURE_PRICE_C => #T_SP_C_BALANCE_PRICE 임시테이블 생성
				---------------------------------------------------------------------------------------------------------
				INSERT INTO #T_SP_C_BALANCE_PRICE 
				( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID -- [PJ2025-50017] 추가
				, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY
				, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
				, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10	)
				SELECT DISTINCT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, '-'	AS CELL_PROD_SITE_ID -- [PJ2025-50017]_20250617 수정작업추가	
					 , A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE, A.CREATED_BY
					 , A.CREATION_DATE, @v_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
					 , A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10		
				FROM SCM_MST_FUTURE_PRICE_C A WITH(NOLOCK) 
				WHERE	A.DIVISION_ID	= @p_division_id 
				AND		A.VERSION_NO	= @v_ver_return_no											
				AND		A.YYYYMMDD		>= @plan_start_yyyymmdd
			END
			-- [PJ2025-50017] 소형 매출계획 동기화 개선 END
			-- [PJ2025-50188] 40사업부는 CELL_PROD_SITE_ID까지 PRICE 비교 / 81,82사업부는 CELL_PROD_SITE_ID를 '-'로 치환하여 PRICE 비교 END
			---------------------------------------------------------------------------------------------------------
PRINT ( @v_program_name + ' A013: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )

			--===========================================================================================================
			-- QTY measure 생성
			--===========================================================================================================
			INSERT INTO #SALES_PLAN_TEMP
			SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
				 , W.MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
				 , W.YYYYMMDD, ISNULL(SI.CURRENCY,'') AS CURRENCY		-- 20180319 skh modify
				 , W.QTY, W.CREATED_BY, W.CREATION_DATE, @v_created_by AS LAST_UPDATED_BY, GETDATE()
				 , W.ATTRIBUTE1, W.ATTRIBUTE2, W.ATTRIBUTE3, W.ATTRIBUTE4, W.ATTRIBUTE5
				 , W.ATTRIBUTE6	,W.ATTRIBUTE7, W.ATTRIBUTE8, W.ATTRIBUTE9, W.ATTRIBUTE10
			--FROM [dbo].DM_PLN_MKT_FCST_C w WITH(NOLOCK)
			FROM #T_SP_C_BALANCE_MKT_FCST W WITH(NOLOCK)		-- [PJ2025-50188] 임시테이블 #T3_MKT_FCST ==> #T_SP_C_BALANCE_MKT_FCST 변경 
			INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
					ON BASIS_YYYYMMDD = W.YYYYMMDD
			--LEFT OUTER JOIN ( SELECT * FROM SCM_MST_FUTURE_PRICE_C WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si
			LEFT OUTER JOIN ( SELECT * FROM #T_SP_C_BALANCE_PRICE WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) SI	-- [PJ2025-50188] 임시테이블 #T3_PRICE ==> #T_SP_C_BALANCE_PRICE 변경 
						 ON ( 1=1
						AND W.DIVISION_ID		 = SI.DIVISION_ID
						AND W.PROJECT_CODE		 = SI.PROJECT_CODE
						AND W.SCM_SITE_ID		 = SI.SCM_SITE_ID
						AND W.ITEM_ID			 = SI.ITEM_ID
						AND W.DOM_EXP			 = SI.DOM_EXP
						AND W.FCST_TYPE			 = SI.FCST_TYPE
						AND W.INCOTERMS			 = SI.INCOTERMS
						AND W.PLANT_SITE_ID		 = SI.PLANT_SITE_ID
						--AND W.CELL_PROD_SITE_ID  = SI.CELL_PROD_SITE_ID	-- [PJ2025-50188] 40사업부와 81,82사업부간 다른 로직으로 활용
						-- [PJ2025-50188] 40사업부는 CELL_PROD_SITE_ID까지 PRICE 비교 / 81,82사업부는 CELL_PROD_SITE_ID를 '-'로 치환하여 PRICE 비교
						AND CASE WHEN W.DIVISION_ID = '40' THEN W.CELL_PROD_SITE_ID ELSE '-' END  = SI.CELL_PROD_SITE_ID	-- [PJ2025-50017] 추가																							
						AND CAL.BASIS_START_DATE = SI.YYYYMMDD
						AND SI.MEASURE = 'LOC' )					
			WHERE W.DIVISION_ID = @p_division_id
			AND   W.VERSION_NO  = @c_MF_version
			AND   W.YYYYMMDD   >= @plan_start_yyyymmdd
			AND   W.MEASURE    IN ( 'MKT_FCST', 'SCM_FCST','CUST_FCST', 'TMM_FCST', 'RTF_SCP', 'RTF_SYS_RP', 'RTF' , 'RTF_PR') --[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용 --[PJ2025-50017]
			AND   W.ITEM_ID    IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )

			--[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
			/*
			UNION ALL
			SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
				 , W.MEASURE, W.PLANT_SITE_ID, W.YYYYMMDD, ISNULL(SI.CURRENCY,'') AS CURRENCY  -- 20180319 skh modify
				 , W.QTY, W.CREATED_BY, W.CREATION_DATE, @v_created_by AS LAST_UPDATED_BY, GETDATE()
				 , W.ATTRIBUTE1, W.ATTRIBUTE2, W.ATTRIBUTE3, W.ATTRIBUTE4, W.ATTRIBUTE5
				 , W.ATTRIBUTE6, W.ATTRIBUTE7, W.ATTRIBUTE8, W.ATTRIBUTE9, W.ATTRIBUTE10
			FROM DM_PLN_SALES_PLAN W WITH(NOLOCK)
			INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
					ON BASIS_YYYYMMDD = W.YYYYMMDD
			LEFT OUTER JOIN ( SELECT * FROM SCM_MST_FUTURE_PRICE_C WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @v_ver_return_no ) SI
						 ON ( 1=1
						AND W.DIVISION_ID		 = SI.DIVISION_ID
						AND W.PROJECT_CODE		 = SI.PROJECT_CODE
						AND W.SCM_SITE_ID		 = SI.SCM_SITE_ID
						AND W.ITEM_ID			 = SI.ITEM_ID
						AND W.DOM_EXP			 = SI.DOM_EXP
						AND W.FCST_TYPE			 = SI.FCST_TYPE
						AND W.INCOTERMS			 = SI.INCOTERMS
						AND W.PLANT_SITE_ID		 = SI.PLANT_SITE_ID
						AND CAL.BASIS_START_DATE = SI.YYYYMMDD
						AND SI.MEASURE = 'LOC' )					
			WHERE W.DIVISION_ID = @p_division_id
			AND   W.YYYYMMDD   >= @plan_start_yyyymmdd
			AND   W.MEASURE    IN ( 'RTF' )
			AND   W.ITEM_ID    IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )
			*/

			--===========================================================================================================
			-- AMT measure 생성
			--===========================================================================================================		
			INSERT INTO #SALES_PLAN_TEMP
			-- KRW 값을 계산
			SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
				 , 'SalesAmt_KRW' AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
				 , W.YYYYMMDD, SI.CURRENCY, CAST(STR(W.QTY * ISNULL(SI.PRICE, 0), 20, 5 ) AS NUMERIC(30, 10))
				 , W.CREATED_BY, W.CREATION_DATE, @v_created_by	AS LAST_UPDATED_BY, GETDATE(), NULL -- ATTRIBUTE1
				 , W.ATTRIBUTE2	--[PJ2025-50188] SALES_AMT (3종) ATTRIBUTE2 (FROM_SITE_ID) 누락 개선
				 , NULL /*ATTRIBUTE3*/, NULL /*ATTRIBUTE4*/, NULL /*ATTRIBUTE5*/, NULL /*ATTRIBUTE6*/, NULL /*ATTRIBUTE7*/
				 , NULL /*ATTRIBUTE8*/, NULL /*ATTRIBUTE9*/, NULL /*ATTRIBUTE10*/
			FROM #SALES_PLAN_TEMP W WITH(NOLOCK)
			INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
					ON CAL.BASIS_YYYYMMDD = W.YYYYMMDD
			--LEFT OUTER JOIN ( SELECT * FROM SCM_MST_FUTURE_PRICE_C WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @v_ver_return_no ) SI
			LEFT OUTER JOIN ( SELECT * FROM  #T_SP_C_BALANCE_PRICE WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @v_ver_return_no ) SI	-- [PJ2025-50188] 임시테이블 #T3_PRICE ==> #T_SP_C_BALANCE_PRICE 변경 
						 ON ( 1=1
						AND W.DIVISION_ID		 = SI.DIVISION_ID
						AND W.PROJECT_CODE		 = SI.PROJECT_CODE
						AND W.SCM_SITE_ID		 = SI.SCM_SITE_ID
						AND W.ITEM_ID			 = SI.ITEM_ID
						AND W.DOM_EXP			 = SI.DOM_EXP
						AND W.FCST_TYPE			 = SI.FCST_TYPE
						AND W.INCOTERMS			 = SI.INCOTERMS
						AND W.PLANT_SITE_ID		 = SI.PLANT_SITE_ID
						--AND W.CELL_PROD_SITE_ID	 = SI.CELL_PROD_SITE_ID										-- [PJ2025-50188] 40사업부와 81,82사업부간 다른 로직으로 활용
						-- [PJ2025-50188] 40사업부는 CELL_PROD_SITE_ID까지 PRICE 비교 / 81,82사업부는 CELL_PROD_SITE_ID를 '-'로 치환하여 PRICE 비교
						AND CASE WHEN W.DIVISION_ID = '40' THEN W.CELL_PROD_SITE_ID ELSE '-' END = SI.CELL_PROD_SITE_ID	-- [PJ2025-50017] 추가
						AND CAL.BASIS_START_DATE = SI.YYYYMMDD
						AND SI.MEASURE			 = 'KRW' )					
			WHERE W.DIVISION_ID = @p_division_id
			--AND   W.measure     = CASE WHEN @p_division_id IN ('81','40') THEN 'RTF_SCP' ELSE 'RTF' END
			-- [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (START) 
			--AND   W.MEASURE     = 'RTF_SCP' --[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
			AND   W.MEASURE     = 'RTF_SYS_RP' 
			-- [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (END)
			UNION ALL 
			-- LOC 값을 계산
			SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
				 , 'SalesAmt_LOC' AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
				 , W.YYYYMMDD, SI.CURRENCY, CAST(STR(W.QTY * ISNULL(SI.PRICE, 0), 20, 5) AS NUMERIC(30, 10))
				 , W.CREATED_BY, W.CREATION_DATE, @v_created_by	AS LAST_UPDATED_BY, GETDATE(), NULL -- ATTRIBUTE1
				 , W.ATTRIBUTE2	--[PJ2025-50188] SALES_AMT (3종) ATTRIBUTE2 (FROM_SITE_ID) 누락 개선
				 , NULL /*ATTRIBUTE3*/, NULL /*ATTRIBUTE4*/, NULL /*ATTRIBUTE5*/, NULL /*ATTRIBUTE6*/, NULL /*ATTRIBUTE7*/
				 , NULL /*ATTRIBUTE8*/, NULL /*ATTRIBUTE9*/, NULL /*ATTRIBUTE10*/
			FROM #SALES_PLAN_TEMP W WITH(NOLOCK)
			INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
					ON CAL.BASIS_YYYYMMDD = W.YYYYMMDD
			--LEFT OUTER JOIN ( SELECT * FROM SCM_MST_FUTURE_PRICE_C WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @v_ver_return_no ) SI
			LEFT OUTER JOIN ( SELECT * FROM #T_SP_C_BALANCE_PRICE WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @v_ver_return_no ) SI -- [PJ2025-50188] 임시테이블 #T3_PRICE ==> #T_SP_C_BALANCE_PRICE 변경 
						 ON ( 1=1
						AND W.DIVISION_ID		 = SI.DIVISION_ID
						AND W.PROJECT_CODE		 = SI.PROJECT_CODE
						AND W.SCM_SITE_ID		 = SI.SCM_SITE_ID
						AND W.ITEM_ID			 = SI.ITEM_ID
						AND W.DOM_EXP			 = SI.DOM_EXP
						AND W.FCST_TYPE			 = SI.FCST_TYPE
						AND W.INCOTERMS			 = SI.INCOTERMS
						AND W.PLANT_SITE_ID		 = SI.PLANT_SITE_ID
						--AND W.CELL_PROD_SITE_ID	 = SI.CELL_PROD_SITE_ID	-- [PJ2025-50188] 40사업부와 81,82사업부간 다른 로직으로 활용
						-- [PJ2025-50188] 40사업부는 CELL_PROD_SITE_ID까지 PRICE 비교 / 81,82사업부는 CELL_PROD_SITE_ID를 '-'로 치환하여 PRICE 비교
						AND CASE WHEN W.DIVISION_ID = '40' THEN W.CELL_PROD_SITE_ID	 ELSE '-' END = SI.CELL_PROD_SITE_ID -- [PJ2025-50017] 추가
						AND CAL.BASIS_START_DATE = SI.YYYYMMDD
						AND SI.MEASURE			 = 'LOC' )					
			WHERE W.DIVISION_ID = @p_division_id
			-- [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (START) 
			--AND   W.MEASURE     = CASE WHEN @p_division_id in ('81','40') THEN 'RTF_SCP' ELSE 'RTF' END
			--AND   W.MEASURE     = 'RTF_SCP' --[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
			AND   W.MEASURE     = 'RTF_SYS_RP' 
			-- [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (END) 
			UNION ALL 
			-- USD 값을 계산
			SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
				 , 'SalesAmt_USD' AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
				 , W.YYYYMMDD, SI.CURRENCY, CAST(STR(W.QTY * ISNULL(SI.PRICE, 0), 20, 5) AS NUMERIC(30, 10))
				 , W.CREATED_BY, W.CREATION_DATE, @v_created_by	AS LAST_UPDATED_BY, GETDATE(), NULL -- ATTRIBUTE1
				 , W.ATTRIBUTE2	--[PJ2025-50188] SALES_AMT (3종) ATTRIBUTE2 (FROM_SITE_ID) 누락 개선
				 , NULL /*ATTRIBUTE3*/, NULL /*ATTRIBUTE4*/, NULL /*ATTRIBUTE5*/, NULL /*ATTRIBUTE6*/
				 , NULL /*ATTRIBUTE7*/, NULL /*ATTRIBUTE8*/, NULL /*ATTRIBUTE9*/, NULL /*ATTRIBUTE10*/
			FROM #SALES_PLAN_TEMP W WITH(NOLOCK)
			INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
					ON CAL.BASIS_YYYYMMDD = W.YYYYMMDD
			LEFT OUTER JOIN ( SELECT * FROM #T_SP_C_BALANCE_PRICE WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @v_ver_return_no ) SI	-- [PJ2025-50188] 임시테이블 #T3_PRICE ==> #T_SP_C_BALANCE_PRICE 변경 
						 ON ( 1=1
						AND W.DIVISION_ID		 = SI.DIVISION_ID
						AND W.PROJECT_CODE		 = SI.PROJECT_CODE
						AND W.SCM_SITE_ID		 = SI.SCM_SITE_ID
						AND W.ITEM_ID			 = SI.ITEM_ID
						AND W.DOM_EXP			 = SI.DOM_EXP
						AND W.FCST_TYPE			 = SI.FCST_TYPE
						AND W.INCOTERMS			 = SI.INCOTERMS
						AND W.PLANT_SITE_ID		 = SI.PLANT_SITE_ID
						--AND W.CELL_PROD_SITE_ID	 = SI.CELL_PROD_SITE_ID										-- [PJ2025-50188] 40사업부와 81,82사업부간 다른 로직으로 활용
						-- [PJ2025-50188] 40사업부는 CELL_PROD_SITE_ID까지 PRICE 비교 / 81,82사업부는 CELL_PROD_SITE_ID를 '-'로 치환하여 PRICE 비교
						AND CASE WHEN W.DIVISION_ID = '40' THEN W.CELL_PROD_SITE_ID	 ELSE '-' END = SI.CELL_PROD_SITE_ID	-- [PJ2025-50017] 추가
						AND CAL.BASIS_START_DATE = SI.YYYYMMDD
						AND SI.MEASURE			 = 'USD' )					
			WHERE W.DIVISION_ID = @p_division_id
			-- [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (START) 
			--AND   W.MEASURE     = CASE WHEN @p_division_id in ('81','40') THEN 'RTF_SCP' ELSE 'RTF' END
			--AND   W.MEASURE     = 'RTF_SCP' --[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용	
			AND   W.MEASURE     = 'RTF_SYS_RP' 
			-- [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (END) 		
			UNION ALL	--	C20200803-000105	소형에 대해서만 MKT FCST AMT	를 계산한다. [C20210629-000239] 사업부제한 없앰			
			SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
				 , 'MKT_AMT_KRW' AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
				 , W.YYYYMMDD, SI.CURRENCY, CAST(STR(W.QTY * ISNULL(SI.PRICE, 0), 20, 5 ) AS NUMERIC(30, 10))
				 , W.CREATED_BY, W.CREATION_DATE, @v_created_by	AS LAST_UPDATED_BY, GETDATE(), NULL -- ATTRIBUTE1
				 , NULL /*ATTRIBUTE2*/, NULL /*ATTRIBUTE3*/, NULL /*ATTRIBUTE4*/, NULL /*ATTRIBUTE5*/, NULL /*ATTRIBUTE6*/
				 , NULL /*ATTRIBUTE7*/, NULL /*ATTRIBUTE8*/, NULL /*ATTRIBUTE9*/, NULL /*ATTRIBUTE10*/						
			FROM #SALES_PLAN_TEMP W WITH(NOLOCK)
			INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
					ON CAL.BASIS_YYYYMMDD = W.YYYYMMDD
			LEFT OUTER JOIN ( SELECT * FROM #T_SP_C_BALANCE_PRICE WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @v_ver_return_no ) SI	-- [PJ2025-50188] 임시테이블 #T3_PRICE ==> #T_SP_C_BALANCE_PRICE 변경 
						 ON ( 1=1
						AND W.DIVISION_ID		 = SI.DIVISION_ID
						AND W.PROJECT_CODE		 = SI.PROJECT_CODE
						AND W.SCM_SITE_ID		 = SI.SCM_SITE_ID
						AND W.ITEM_ID			 = SI.ITEM_ID
						AND W.DOM_EXP			 = SI.DOM_EXP
						AND W.FCST_TYPE			 = SI.FCST_TYPE
						AND W.INCOTERMS			 = SI.INCOTERMS
						AND W.PLANT_SITE_ID		 = SI.PLANT_SITE_ID
						--AND W.CELL_PROD_SITE_ID	 = SI.CELL_PROD_SITE_ID										-- [PJ2025-50188] 40사업부와 81,82사업부간 다른 로직으로 활용
						-- [PJ2025-50188] 40사업부는 CELL_PROD_SITE_ID까지 PRICE 비교 / 81,82사업부는 CELL_PROD_SITE_ID를 '-'로 치환하여 PRICE 비교
						AND CASE WHEN W.DIVISION_ID = '40' THEN W.CELL_PROD_SITE_ID	 ELSE '-' END = SI.CELL_PROD_SITE_ID	-- [PJ2025-50017] 추가
						AND CAL.BASIS_START_DATE = SI.YYYYMMDD
						AND SI.MEASURE			 = 'KRW' )					
			WHERE W.MEASURE     = 'MKT_FCST'
			--AND   W.DIVISION_ID = '40'	[C20210629-000239]
			UNION ALL 
			-- LOC 값을 계산
			SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
				 , 'MKT_AMT_LOC' AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
				 , W.YYYYMMDD, SI.CURRENCY, CAST(STR(W.QTY * ISNULL(SI.PRICE, 0), 20, 5) AS NUMERIC(30, 10))
				 , W.CREATED_BY, W.CREATION_DATE, @v_created_by	AS LAST_UPDATED_BY, GETDATE(), NULL -- ATTRIBUTE1
				 , NULL /*ATTRIBUTE2*/, NULL /*ATTRIBUTE3*/, NULL /*ATTRIBUTE4*/, NULL /*ATTRIBUTE5*/, NULL /*ATTRIBUTE6*/
				 , NULL /*ATTRIBUTE7*/, NULL /*ATTRIBUTE8*/, NULL /*ATTRIBUTE9*/, NULL /*ATTRIBUTE10*/	
			FROM #SALES_PLAN_TEMP W WITH(NOLOCK)
			INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
					ON CAL.BASIS_YYYYMMDD = w.yyyymmdd
			--LEFT OUTER JOIN ( SELECT * FROM SCM_MST_FUTURE_PRICE_C WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @v_ver_return_no ) SI
			LEFT OUTER JOIN ( SELECT * FROM #T_SP_C_BALANCE_PRICE WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @v_ver_return_no ) SI	-- [PJ2025-50188] 임시테이블 #T3_PRICE ==> #T_SP_C_BALANCE_PRICE 변경 
						 ON ( 1=1
						AND W.DIVISION_ID		 = SI.DIVISION_ID
						AND W.PROJECT_CODE		 = SI.PROJECT_CODE
						AND W.SCM_SITE_ID		 = SI.SCM_SITE_ID
						AND W.ITEM_ID			 = SI.ITEM_ID
						AND W.DOM_EXP			 = SI.DOM_EXP
						AND W.FCST_TYPE			 = SI.FCST_TYPE
						AND W.INCOTERMS			 = SI.INCOTERMS
						AND W.PLANT_SITE_ID		 = SI.PLANT_SITE_ID
						--AND w.CELL_PROD_SITE_ID	 = si.CELL_PROD_SITE_ID										-- [PJ2025-50188] 40사업부와 81,82사업부간 다른 로직으로 활용
						-- [PJ2025-50188] 40사업부는 CELL_PROD_SITE_ID까지 PRICE 비교 / 81,82사업부는 CELL_PROD_SITE_ID를 '-'로 치환하여 PRICE 비교
						AND CASE WHEN W.DIVISION_ID = '40' THEN W.CELL_PROD_SITE_ID	 ELSE '-' END = SI.CELL_PROD_SITE_ID	-- [PJ2025-50017] 추가
						AND CAL.BASIS_START_DATE = SI.YYYYMMDD
						AND SI.MEASURE			 = 'LOC' )					
			WHERE W.MEASURE     = 'MKT_FCST'

 PRINT ( @v_program_name + ' A014: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )
			--AND   w.DIVISION_ID = '40'	[C20210629-000239]
			/* 2024-04-03   KCW3408     Sales Plan 관련 자동사업부 기타 매출 추가(LOOKUP_TYPE:DM_SALES_PLAN_WATERFALL_SP_W_ADD) */
			-------------------------------------------------------------------------------------------------------------
			--[PJ2024-50611] 소형사업부도 기타매출 사용가능하게 div 제약조건 주석처리 (START)
			/*IF ( @P_DIVISION_ID = '82' OR @P_DIVISION_ID LIKE '81%'  )
			BEGIN*/
			-- [C20210204-000387]
			--INSERT INTO #SALES_PLAN_TEMP
			INSERT INTO #SALES_ETC_PLAN_TEMP --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, REMARK_TEXT
			, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY
			, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
			, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.REMARK_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 컬럼추가
				 , W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.MEASURE, W.PLANT_SITE_ID, W.YYYYMMDD, W.CURRENCY -- ,ISNULL(SI.CURRENCY,'')  -- 20180319 SKH MODIFY
				 , W.QTY, W.CREATED_BY, W.CREATION_DATE, @V_CREATED_BY AS LAST_UPDATED_BY, GETDATE(), W.ATTRIBUTE1, W.ATTRIBUTE2
				 , W.ATTRIBUTE3, W.ATTRIBUTE4, W.ATTRIBUTE5, W.ATTRIBUTE6, W.ATTRIBUTE7, W.ATTRIBUTE8, W.ATTRIBUTE9, 'ADD.ETC' --,W.ATTRIBUTE10
			--FROM DM_PLN_SALES_PLAN W WITH(NOLOCK) 
			FROM DM_PLN_SALES_ETC_PLAN W WITH(NOLOCK) --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
			INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK) ON CAL.BASIS_YYYYMMDD = W.YYYYMMDD
			/* 
			INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LO WITH(NOLOCK) ON LO.LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD' AND LO.VALID_YN = 'Y' AND LO.SEGMENT1 = W.DIVISION_ID
			*/
			/*  20240404 불필요 로직임
			LEFT OUTER JOIN (SELECT * FROM  [DBO].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @P_DIVISION_ID AND VERSION_NO = @V_VER_RETURN_NO ) SI
						 ON ( 1=1
						AND W.DIVISION_ID		 = SI.DIVISION_ID
						AND W.PROJECT_CODE		 = SI.PROJECT_CODE
						AND W.SCM_SITE_ID		 = SI.SCM_SITE_ID
						AND W.ITEM_ID			 = SI.ITEM_ID
						AND W.DOM_EXP			 = SI.DOM_EXP
						AND W.FCST_TYPE			 = SI.FCST_TYPE
						AND W.INCOTERMS			 = SI.INCOTERMS
						AND W.PLANT_SITE_ID		 = SI.PLANT_SITE_ID
						AND CAL.BASIS_START_DATE = SI.YYYYMMDD
						AND SI.MEASURE = 'LOC' )	
			*/
			WHERE W.DIVISION_ID = @P_DIVISION_ID
			AND   W.YYYYMMDD   >= @PLAN_START_YYYYMMDD
			AND   W.FCST_TYPE IN (  SELECT DISTINCT SEGMENT2 
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
					                WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
									AND VALID_YN = 'Y'  
									AND SEGMENT1 = W.DIVISION_ID )
			AND   W.ITEM_ID IN (	SELECT DISTINCT SEGMENT3 
					                FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
					                WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
									AND VALID_YN = 'Y'  
									AND SEGMENT1 = W.DIVISION_ID )    --AND ( W.FCST_TYPE = 'ETC' OR W.ITEM_ID = 'ETC' )
			-------------------------------------------------------------------------------------------------------------
			-- [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건 START
			--AND (W.PROJECT_CODE NOT IN (SELECT ATTRIBUTE1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_SALE_PLAN_ETC_EXCEPTION' AND VALID_YN = 'Y')
			--OR W.ITEM_ID NOT IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_SALE_PLAN_ETC_EXCEPTION' AND VALID_YN = 'Y')
			--OR W.YYYYMMDD NOT IN (SELECT SEGMENT4 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_SALE_PLAN_ETC_EXCEPTION' AND VALID_YN = 'Y')
			--OR W.FCST_TYPE NOT IN (SELECT ATTRIBUTE3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_SALE_PLAN_ETC_EXCEPTION' AND VALID_YN = 'Y')
			--OR W.MEASURE NOT IN (SELECT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_SALE_PLAN_ETC_EXCEPTION' AND VALID_YN = 'Y'))
			--[ETC 매출 조회 불가] GSCM MKT FCST 수정 요청
			AND NOT EXISTS (	SELECT * FROM SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
								WHERE 1=1
								AND LOOKUP_TYPE = 'DM_SALE_PLAN_ETC_EXCEPTION'
								AND VALID_YN = 'Y'
								AND W.PROJECT_CODE = C.ATTRIBUTE1
								AND W.ITEM_ID = C.SEGMENT2
								AND W.YYYYMMDD = C.SEGMENT4
								AND W.FCST_TYPE = C.ATTRIBUTE3
								AND W.MEASURE = C.SEGMENT3	)
			-- [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건 END
			-------------------------------------------------------------------------------------------------------------
			/*	
			END
			*/
			--[PJ2024-50611] 소형사업부도 기타매출 사용가능하게 div 제약조건 주석처리 (END)
			-------------------------------------------------------------------------------------------------------------
PRINT ( @v_program_name + ' A015: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )

			-------------------------------------------------------------------------------------------------------------			
			--[PJ2024-50611] 소형사업부 Sales Plan Catch Up 컷오프 추가 (START)
			--INSERT INTO #SALES_PLAN_TEMP
			INSERT INTO #SALES_ETC_PLAN_TEMP --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, REMARK_TEXT
			, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY
			, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
			, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.REMARK_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 컬럼추가
				 , W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.MEASURE, W.PLANT_SITE_ID, W.YYYYMMDD, W.CURRENCY, W.QTY
				 , W.CREATED_BY, W.CREATION_DATE, @V_CREATED_BY AS LAST_UPDATED_BY, GETDATE(), W.ATTRIBUTE1, W.ATTRIBUTE2, W.ATTRIBUTE3
				 , W.ATTRIBUTE4, W.ATTRIBUTE5, W.ATTRIBUTE6, W.ATTRIBUTE7, W.ATTRIBUTE8, W.ATTRIBUTE9, W.ATTRIBUTE10
			--FROM DM_PLN_SALES_PLAN W WITH(NOLOCK) 
			FROM DM_PLN_SALES_ETC_PLAN W WITH(NOLOCK) --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
			INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK) ON CAL.BASIS_YYYYMMDD = W.YYYYMMDD
			WHERE W.DIVISION_ID = @P_DIVISION_ID
			AND   W.YYYYMMDD   >= @PLAN_START_YYYYMMDD
			AND	  W.MEASURE IN ('Catch_Up', 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up')
			--[PJ2024-50611] 소형사업부 Sales Plan Catch Up 컷오프 추가 (END)
			-------------------------------------------------------------------------------------------------------------			
PRINT ( @v_program_name + ' A016: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )
		
			-------------------------------------------------------------------------------------------------------------	
			--[E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건--------------------START

			SET @v_count = 0
			SET @s_count = 0
			SET @CNT = 0
			IF( @P_DIVISION_ID = '81' )
			BEGIN
 PRINT ( @v_program_name + ' A017: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )
					
				SELECT @CNT = COUNT(SEGMENT2) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y'
					
				SET @i = 1
				WHILE @i <= @CNT
				BEGIN
					SET @v_SITE_ID = ''
					SELECT @v_SITE_ID = SEGMENT2 
					FROM ( SELECT ROW_NUMBER() OVER(ORDER BY SEGMENT2 ) AS SEQ, SEGMENT2 
						   FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y') A 
					WHERE A.SEQ = @i

					SELECT @v_count = COUNT(*) FROM #SALES_PLAN_TEMP WITH(NOLOCK)
					WHERE DIVISION_ID = '81' 
					AND MEASURE = 'RTF_SYS_RP'
					AND SCM_SITE_ID = @v_SITE_ID

					IF (@v_count = 0)
					BEGIN
						SELECT @s_count = COUNT(*) FROM #SALES_PLAN_TEMP WITH(NOLOCK)
						WHERE DIVISION_ID = '81' 
						AND SCM_SITE_ID = @v_SITE_ID
						AND MEASURE = 'RTF'

						IF (@s_count > 0)
						BEGIN
						PRINT '1==========================================================================================================================START'
							UPDATE #SALES_PLAN_TEMP SET MEASURE = 'RTF_SYS_RP' 
							WHERE DIVISION_ID = '81' 
							AND SCM_SITE_ID = @v_SITE_ID
							AND MEASURE = 'RTF'

							PRINT @v_SITE_ID
						PRINT '1==========================================================================================================================END'
						END
						ELSE
						BEGIN
						PRINT '2==========================================================================================================================START'
							INSERT INTO #SALES_PLAN_TEMP
							SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
								 , 'RTF_SYS_RP' AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID	-- [PJ2025-50017] 추가
								 , W.YYYYMMDD, ISNULL(SI.CURRENCY, '') AS CURRENCY  -- 20180319 skh modify
								 , W.QTY, W.CREATED_BY, W.CREATION_DATE, @v_created_by AS LAST_UPDATED_BY, GETDATE(), W.ATTRIBUTE1
								 , W.ATTRIBUTE2, W.ATTRIBUTE3, W.ATTRIBUTE4, W.ATTRIBUTE5, W.ATTRIBUTE6, W.ATTRIBUTE7
								 , W.ATTRIBUTE8, W.ATTRIBUTE9, W.ATTRIBUTE10
--									FROM [dbo].DM_PLN_MKT_FCST_C w WITH(NOLOCK)
							FROM #T_SP_C_BALANCE_MKT_FCST w WITH(NOLOCK)		-- [PJ2025-50188] 임시테이블 #T3_MKT_FCST ==> #T_SP_C_BALANCE_MKT_FCST 변경 
							INNER JOIN SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
									ON CAL.BASIS_YYYYMMDD = W.YYYYMMDD
							--LEFT OUTER JOIN ( SELECT * FROM SCM_MST_FUTURE_PRICE_C WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND VERSION_NO = @v_ver_return_no ) SI
							LEFT OUTER JOIN ( SELECT * FROM  #T_SP_C_BALANCE_PRICE WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si		-- [PJ2025-50188] 임시테이블 #T3_PRICE ==> #T_SP_C_BALANCE_PRICE 변경 
									on ( 1=1
										and w.DIVISION_ID		 = si.DIVISION_ID
										and w.PROJECT_CODE		 = si.PROJECT_CODE
										and w.SCM_SITE_ID		 = si.SCM_SITE_ID
										and w.ITEM_ID			 = si.ITEM_ID
										and w.DOM_EXP			 = si.dom_exp
										and w.fcst_type			 = si.fcst_type
										and w.INCOTERMS			 = si.INCOTERMS
										and w.plant_site_id		 = si.plant_site_id
										--and w.cell_prod_site_id	 = si.cell_prod_site_id										-- [PJ2025-50188] 40사업부와 81,82사업부간 다른 로직으로 활용
										and CASE WHEN w.DIVISION_ID = '40' THEN w.cell_prod_site_id	 ELSE '-' END				-- [PJ2025-50188] 40사업부는 CELL_PROD_SITE_ID까지 PRICE 비교 / 81,82사업부는 CELL_PROD_SITE_ID를 '-'로 치환하여 PRICE 비교
																 = si.cell_prod_site_id											-- [PJ2025-50017] 추가
										and CAL.basis_start_date = si.yyyymmdd
										AND SI.MEASURE = 'LOC' 
									)					
									WHERE w.DIVISION_ID = @p_division_id
									AND   w.VERSION_NO  = @c_MF_version
									AND   w.YYYYMMDD   >= @plan_start_yyyymmdd
									AND   w.MEASURE    IN ( 'MKT_FCST' ) --[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
									AND W.SCM_SITE_ID = @v_SITE_ID
									

									PRINT @v_SITE_ID
								PRINT '2==========================================================================================================================END'
							END
						END
					




						SET @i = @i + 1
					END
				END
 PRINT ( @v_program_name + ' A018: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )

		--SELECT * FROM #SALES_PLAN_TEMP WHERE 1=1
		--AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
		--AND MEASURE = 'RTF_SYS_RP'

				--[E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건--------------------END
					

				-- dm_pln_sales_plan_c 에 cutoff data insert
				INSERT  INTO  dbo.dm_pln_sales_plan_c
				(
						DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					   ,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID,YYYYMMDD,CURRENCY,QTY		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					  ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				)
				SELECT distinct 
					   DIVISION_ID, @v_ver_return_no, @c_ver_type,@p_cutoff_yyyymmdd
					   ,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID,YYYYMMDD,CURRENCY,QTY		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,SYSDATETIME() as LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					  ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				FROM #SALES_PLAN_TEMP WITH(NOLOCK)
				where division_id = @p_division_id;

 PRINT ( @v_program_name + ' A019: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )


				--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 별도 테이블에 컷오프 START
				INSERT  INTO  DBO.DM_PLN_SALES_ETC_PLAN_C
				(
					[DIVISION_ID]
					,[VERSION_NO]
					,[CUTOFF_TYPE]
					,[CUTOFF_YYYYMMDD]
					,[PROJECT_CODE]
					,[SCM_SITE_ID]
					,[ITEM_ID]
					,[REMARK_TEXT]
					,[DOM_EXP]
					,[FCST_TYPE]
					,[INCOTERMS]
					,[MEASURE]
					,[PLANT_SITE_ID]
					,[YYYYMMDD]
					,[CURRENCY]
					,[QTY]
					,[CREATED_BY]
					,[CREATION_DATE]
					,[LAST_UPDATED_BY]
					,[LAST_UPDATE_DATE]
					,[ATTRIBUTE1]
					,[ATTRIBUTE2]
					,[ATTRIBUTE3]
					,[ATTRIBUTE4]
					,[ATTRIBUTE5]
					,[ATTRIBUTE6]
					,[ATTRIBUTE7]
					,[ATTRIBUTE8]
					,[ATTRIBUTE9]
					,[ATTRIBUTE10]				
				)
				SELECT distinct 
					   DIVISION_ID, @v_ver_return_no, @c_ver_type,@p_cutoff_yyyymmdd
					   ,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,REMARK_TEXT,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
					   ,YYYYMMDD,CURRENCY,QTY
					  ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,SYSDATETIME() as LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					  ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				FROM #SALES_ETC_PLAN_TEMP WITH(NOLOCK)
				where division_id = @p_division_id;
				--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 별도 테이블에 컷오프 END

		END
		
 PRINT ( @v_program_name + ' A020: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )

		
		-- 2. DM_PLN_SALES_PLAN_REULT_C CUTOFF
		BEGIN
			INSERT INTO [dbo].DM_PLN_SALES_PLAN_RESULT_C 
			(
				DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
			,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY,CREATED_BY
			,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
			,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10, COMPANY_ID
			,CELL_PROD_SITE_ID				--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			)
			SELECT 
					DIVISION_ID
				,@v_ver_return_no AS VERSION_NO --VERSION_NO
				,@c_ver_type AS CUTOFF_TYPE      -- CUTOFF_TYPE
				,CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS CUTOFF_YYYYMMDD  -- CUTOFF_YYYYMMDD
				,PROJECT_CODE
				,SCM_SITE_ID
				,ITEM_ID
				,DOM_EXP
				,FCST_TYPE
				,INCOTERMS
				,MEASURE
				,PLANT_SITE_ID
				,YYYYMMDD
				,isnull(CURRENCY,'')  -- 20180319 skh modify
				,QTY
				,CREATED_BY
				,CREATION_DATE
				,@v_created_by AS LAST_UPDATED_BY
				,GETDATE()
				,ATTRIBUTE1
				,ATTRIBUTE2
				,ATTRIBUTE3
				,ATTRIBUTE4
				,ATTRIBUTE5
				,ATTRIBUTE6
				,ATTRIBUTE7
				,ATTRIBUTE8
				,ATTRIBUTE9
				,ATTRIBUTE10
				,COMPANY_ID
				,CELL_PROD_SITE_ID				--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			/*FROM [dbo].DM_PLN_SALES_PLAN_RESULT WITH(NOLOCK)*/
			FROM  [dbo].DM_PLN_SALES_PLAN_RESULT_C WITH(NOLOCK) --[PJ20200138] Sales Plan Weekly Cutoff 생성시 실적은 MKT Fcst가 Cutoff 되는 시점의 화요일 Cutoff 실적을 사용하도록 로직 수정
			WHERE DIVISION_ID = @p_division_id
			AND   VERSION_NO  = @c_SP_result_version
			--AND [YYYYMMDD]	<   CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)			-- [2018-03-28][추가][금주 월요일 이전]
			--AND [YYYYMMDD]	>=  CONVERT(CHAR(8), DATEADD(DD, -7*54, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)		-- 최근 1년치
		END
 PRINT ( @v_program_name + ' A021: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )


		--3. 81번 선박사업부 82번 매출 매핑 START --------------------------------------
		DECLARE @c_MF_version_81 AS NVARCHAR(100);
		DECLARE @c_SP_version_81 AS NVARCHAR(100);
		DECLARE @p_cutoff_yyyymmdd_81 AS NVARCHAR(08);
		
		IF (@P_DIVISION_ID = '82')
		BEGIN 
 PRINT ( @v_program_name + ' A022: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )
			
			IF OBJECT_ID (N'tempdb..#TEMP_AFTER_RTF_81', N'U') IS NOT NULL 
				DROP TABLE #TEMP_AFTER_RTF_81 ;
	
			/* MKT_FCST Cutoff 버전 */
			SELECT @c_MF_version_81 = MAX(VERSION_NO)
			FROM   DM_MST_VERSION WITH(NOLOCK)
			WHERE  DIVISION_ID  = '81'
			and    version_type = 'MF_W'
			and    yyyymmdd    >= @plan_start_yyyymmdd;

			/* Sales_Plan Cutoff 버전 */
			SELECT @c_SP_version_81 = MAX(VERSION_NO)				
				 , @p_cutoff_yyyymmdd_81 = MAX(YYYYMMDD)
			FROM   DM_MST_VERSION WITH(NOLOCK)
			WHERE  DIVISION_ID  = '81'
			and    version_type = 'SP_W'
			and    yyyymmdd    >= @plan_start_yyyymmdd;

			PRINT ISNULL(@c_MF_version_81,'Z') + '||' +  ISNULL(@c_SP_version_81,'X') + '||' +  ISNULL(@p_cutoff_yyyymmdd_81,'Y');

			WITH #SALES_PLAN_TEMP_81 AS  (
				/* QTY MEASURE 생성 */
				SELECT 
					 w.DIVISION_ID		,w.PROJECT_CODE		,w.SCM_SITE_ID	,w.ITEM_ID		,w.DOM_EXP
					,w.FCST_TYPE		,w.INCOTERMS		,w.MEASURE		,w.PLANT_SITE_ID,w.YYYYMMDD
					,isnull(si.CURRENCY,'')  AS  CURRENCY-- 20180319 skh modify
					,w.QTY				,w.CREATED_BY		,w.CREATION_DATE
					,'system' AS LAST_UPDATED_BY			,GETDATE() AS LAST_UPDATE_DATE
					,w.ATTRIBUTE1		,w.ATTRIBUTE2		,w.ATTRIBUTE3		,w.ATTRIBUTE4		,w.ATTRIBUTE5
					,w.ATTRIBUTE6		,w.ATTRIBUTE7		,w.ATTRIBUTE8		,w.ATTRIBUTE9		,w.ATTRIBUTE10
					,w.CELL_PROD_SITE_ID									-- [PJ2025-50188] EXCEPTION_DEMAND의 CELL_PROD_SITE_ID 수정 (칼럼 추가)
--				FROM [dbo].DM_PLN_MKT_FCST_C w WITH(NOLOCK)
				FROM [dbo].DM_PLN_CFM_MKT_DEMAND_PLAN_C w WITH(NOLOCK)		-- [PJ2025-50188] EXCEPTION_DEMAND의 CELL_PROD_SITE_ID 수정 (테이블변경)
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
				ON   basis_yyyymmdd = w.yyyymmdd
				left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) 
									WHERE DIVISION_ID = '81' AND version_no = @c_SP_version_81 ) si
				on ( 1=1
					and w.DIVISION_ID		 = si.DIVISION_ID
					and w.PROJECT_CODE		 = si.PROJECT_CODE
					and w.SCM_SITE_ID		 = si.SCM_SITE_ID
					and w.ITEM_ID			 = si.ITEM_ID
					and w.DOM_EXP			 = si.dom_exp
					and w.fcst_type			 = si.fcst_type
					and w.INCOTERMS			 = si.INCOTERMS
					and w.plant_site_id		 = si.plant_site_id
					and CAL.basis_start_date = si.yyyymmdd
					AND SI.MEASURE = 'LOC' 
				)					
				WHERE w.DIVISION_ID = '81'
				AND   w.VERSION_NO  = @c_MF_version_81 
				AND   w.YYYYMMDD   >= CONVERT(CHAR(8), DATEADD(DD, -7*1, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
				and   w.ITEM_ID    IN ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id)	
				/* 20240605 RTF MEASURE 에 한해 변경된 부분만 재처리 */
				AND W.MEASURE IN ( 'RTF_SCP', 'RTF_SYS_RP', 'RTF' ) 
				AND W.SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
			)
			, #SALES_PLAN_TEMP_81_2 AS (
				select   w.DIVISION_ID			,w.PROJECT_CODE			,w.SCM_SITE_ID			,w.ITEM_ID 			,w.DOM_EXP
						,w.FCST_TYPE			,w.INCOTERMS			,'SalesAmt_KRW' MEASURE	,w.PLANT_SITE_ID	,w.YYYYMMDD
						,si.CURRENCY
						,cast( STR( w.QTY * isnull (si.PRICE , 0) , 20, 5 ) as numeric(30, 10)) AS QTY
						,w.CREATED_BY						,w.CREATION_DATE
						,'system' AS LAST_UPDATED_BY		,GETDATE() AS LAST_UPDATE_DATE
						,NULL AS ATTRIBUTE1			,NULL AS ATTRIBUTE2			,NULL AS ATTRIBUTE3			,NULL AS ATTRIBUTE4			,NULL AS ATTRIBUTE5
						,NULL AS ATTRIBUTE6			,NULL AS ATTRIBUTE7			,NULL AS ATTRIBUTE8			,NULL AS ATTRIBUTE9			,NULL AS ATTRIBUTE10
						,w.CELL_PROD_SITE_ID			-- [PJ2025-50188] EXCEPTION_DEMAND의 CELL_PROD_SITE_ID 수정  (칼럼추가)
				FROM #SALES_PLAN_TEMP_81 w WITH(NOLOCK)
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
				ON   basis_yyyymmdd = w.yyyymmdd
				left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = '81' AND version_no = @c_SP_version_81) si
				on ( 1=1
					and w.DIVISION_ID		 = si.DIVISION_ID
					and w.PROJECT_CODE		 = si.PROJECT_CODE
					and w.SCM_SITE_ID		 = si.SCM_SITE_ID
					and w.ITEM_ID			 = si.ITEM_ID
					and w.DOM_EXP			 = si.dom_exp
					and w.fcst_type			 = si.fcst_type
					and w.INCOTERMS			 = si.INCOTERMS
					and w.plant_site_id		 = si.plant_site_id
					and CAL.basis_start_date = si.yyyymmdd
					AND SI.MEASURE			 = 'KRW' 
				)					
				WHERE w.DIVISION_ID = '81'
				-- [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (START) 
				--AND   w.measure     = 'RTF_SCP'
				AND   w.measure     = 'RTF_SYS_RP'
				-- [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (END) 
				AND W.SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
				UNION ALL 
				-- LOC 값을 계산
				select   w.DIVISION_ID			,w.PROJECT_CODE			,w.SCM_SITE_ID			,w.ITEM_ID			,w.DOM_EXP			,w.FCST_TYPE
						,w.INCOTERMS			,'SalesAmt_LOC' MEASURE	,w.PLANT_SITE_ID		,w.YYYYMMDD			,si.CURRENCY
						,cast( STR( w.QTY * isnull (si.PRICE , 0) , 20, 5 ) as numeric(30, 10)) AS QTY
						,w.CREATED_BY				,w.CREATION_DATE			,'system' AS LAST_UPDATED_BY		,GETDATE() AS LAST_UPDATE_DATE
						,NULL AS ATTRIBUTE1			,NULL AS ATTRIBUTE2			,NULL AS ATTRIBUTE3			,NULL AS ATTRIBUTE4			,NULL AS ATTRIBUTE5
						,NULL AS ATTRIBUTE6			,NULL AS ATTRIBUTE7			,NULL AS ATTRIBUTE8			,NULL AS ATTRIBUTE9			,NULL AS ATTRIBUTE10
						,w.CELL_PROD_SITE_ID			-- [PJ2025-50188] EXCEPTION_DEMAND의 CELL_PROD_SITE_ID 수정  (칼럼추가)
				FROM #SALES_PLAN_TEMP_81 w WITH(NOLOCK)
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
				ON   basis_yyyymmdd = w.yyyymmdd
				left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = '81' AND version_no = @c_SP_version_81) si
				on ( 1=1
					and w.DIVISION_ID		 = si.DIVISION_ID
					and w.PROJECT_CODE		 = si.PROJECT_CODE
					and w.SCM_SITE_ID		 = si.SCM_SITE_ID
					and w.ITEM_ID			 = si.ITEM_ID
					and w.DOM_EXP			 = si.dom_exp
					and w.fcst_type			 = si.fcst_type
					and w.INCOTERMS			 = si.INCOTERMS
					and w.plant_site_id		 = si.plant_site_id
					and CAL.basis_start_date = si.yyyymmdd
					AND SI.MEASURE			 = 'LOC' 
				)					
				WHERE w.DIVISION_ID = '81'
				-- [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (START) 
				--AND   w.measure     = 'RTF_SCP'
				AND   w.measure     = 'RTF_SYS_RP'
				-- [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (END) 
				AND W.SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
				UNION ALL 
				-- USD 값을 계산
				select   w.DIVISION_ID			,w.PROJECT_CODE			,w.SCM_SITE_ID			,w.ITEM_ID			,w.DOM_EXP			,w.FCST_TYPE
						,w.INCOTERMS			,'SalesAmt_USD' MEASURE	,w.PLANT_SITE_ID		,w.YYYYMMDD			,si.CURRENCY
						,cast( STR( w.QTY * isnull (si.PRICE , 0) , 20, 5 ) as numeric(30, 10)) AS QTY
						,w.CREATED_BY			,w.CREATION_DATE		,'system' AS LAST_UPDATED_BY			,GETDATE() AS LAST_UPDATE_DATE
						,NULL AS ATTRIBUTE1		,NULL AS ATTRIBUTE2		,NULL AS ATTRIBUTE3			,NULL AS ATTRIBUTE4			,NULL AS ATTRIBUTE5
						,NULL AS ATTRIBUTE6		,NULL AS ATTRIBUTE7		,NULL AS ATTRIBUTE8			,NULL AS ATTRIBUTE9			,NULL AS ATTRIBUTE10
						,w.CELL_PROD_SITE_ID			-- [PJ2025-50188] EXCEPTION_DEMAND의 CELL_PROD_SITE_ID 수정  (칼럼추가)
				FROM #SALES_PLAN_TEMP_81 w WITH(NOLOCK)
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
				ON   basis_yyyymmdd = w.yyyymmdd
				left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = '81' AND version_no = @c_SP_version_81) si
				on ( 1=1
					and w.DIVISION_ID		 = si.DIVISION_ID
					and w.PROJECT_CODE		 = si.PROJECT_CODE
					and w.SCM_SITE_ID		 = si.SCM_SITE_ID
					and w.ITEM_ID			 = si.ITEM_ID
					and w.DOM_EXP			 = si.dom_exp
					and w.fcst_type			 = si.fcst_type
					and w.INCOTERMS			 = si.INCOTERMS
					and w.plant_site_id		 = si.plant_site_id
					and CAL.basis_start_date = si.yyyymmdd
					AND SI.MEASURE			 = 'USD' 
				)					
				WHERE w.DIVISION_ID = '81'
				-- [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (START) 
				--AND   w.measure     = 'RTF_SCP' 
				AND   w.measure     = 'RTF_SYS_RP' 
				-- [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (END) 
				AND W.SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
			)
			, #FINAL_DATA AS (
				SELECT *
				FROM #SALES_PLAN_TEMP_81  WITH(NOLOCK) /* 수량 */
				UNION ALL
				SELECT *
				FROM #SALES_PLAN_TEMP_81_2 WITH(NOLOCK) /* 금액*/
			) 			
			SELECT * INTO #TEMP_AFTER_RTF_81 
			FROM (
				SELECT DIVISION_ID, @c_SP_version_81 AS VERSION_NO, 'SP_W' AS CUTOFF_TYPE,@p_cutoff_yyyymmdd_81 AS CUTOFF_YYYYMMDD
					,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY
					,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,SYSDATETIME() as LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					,CELL_PROD_SITE_ID			-- [PJ2025-50188] EXCEPTION_DEMAND의 CELL_PROD_SITE_ID 수정  (칼럼추가)
				FROM #FINAL_DATA WITH(NOLOCK)
			) T1;


			

			SET @v_count = 0
			SET @s_count = 0
			SET @CNT = 0
			BEGIN 
				SELECT @CNT = COUNT(DISTINCT SCM_SITE_ID) FROM #TEMP_AFTER_RTF_81;
				PRINT @CNT;

				SET @i = 1
				WHILE @i <= @CNT
				BEGIN 
					SET @v_SITE_ID = ''
					SELECT @v_SITE_ID = SCM_SITE_ID 
					FROM (
						SELECT ROW_NUMBER() OVER(ORDER BY SCM_SITE_ID) AS SEQ, SCM_SITE_ID FROM #TEMP_AFTER_RTF_81 WITH(NOLOCK) GROUP BY SCM_SITE_ID
					) A WHERE A.SEQ = @i


					SELECT @v_count = COUNT(*) FROM #TEMP_AFTER_RTF_81 WITH(NOLOCK)
									WHERE DIVISION_ID = '81' 
									AND MEASURE = 'RTF_SYS_RP'
									AND SCM_SITE_ID = @v_SITE_ID
		
					IF (@v_count = 0)
					BEGIN
						SELECT @s_count = COUNT(*) FROM #TEMP_AFTER_RTF_81 WITH(NOLOCK)
						WHERE DIVISION_ID = '81' 
						AND SCM_SITE_ID = @v_SITE_ID
						AND MEASURE = 'RTF'

						IF (@s_count > 0)
						BEGIN
							PRINT '1============START'
								UPDATE #TEMP_AFTER_RTF_81 
								SET MEASURE = 'RTF_SYS_RP' 
								WHERE DIVISION_ID = '81' 
								AND SCM_SITE_ID = @v_SITE_ID
								AND MEASURE = 'RTF'


							PRINT @v_SITE_ID
						END
					END

					SET @i = @i + 1
				END
			END 

			IF (@CNT > 0 )
			BEGIN 
 PRINT ( @v_program_name + ' A023: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )
				DELETE FROM DM_PLN_SALES_PLAN_C
				--SELECT * FROM DM_PLN_SALES_PLAN_C WITH (NOLOCK)
				WHERE 1=1
				AND DIVISION_ID = '81'
				AND VERSION_NO = @c_SP_version_81
				AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
				AND SCM_SITE_ID IN (SELECT SCM_SITE_ID FROM #TEMP_AFTER_RTF_81 WITH(NOLOCK) GROUP BY SCM_SITE_ID)
				AND MEASURE IN ('RTF','RTF_SCP','RTF_SYS_RP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');
				
				INSERT INTO DM_PLN_SALES_PLAN_C (
					 DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID, YYYYMMDD,CURRENCY,QTY
					,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10)
--				SELECT DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,'-',YYYYMMDD,CURRENCY,QTY					-- [PJ2025-50188] EXCEPTION_DEMAND의 CELL_PROD_SITE_ID 수정 ('-' ==> CELL_PROD_SITE_ID 수정)
				SELECT DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID,YYYYMMDD,CURRENCY,QTY	-- [PJ2025-50188] EXCEPTION_DEMAND의 CELL_PROD_SITE_ID 수정 
					,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10 
				FROM #TEMP_AFTER_RTF_81 WITH(NOLOCK)

			END
		END 
		/* 3-END */
 PRINT ( @v_program_name + ' A024: ' + 'DIVISION_ID: '+ @p_division_id + N' / SP_W버전: '+ @v_ver_return_no )

	------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 임시테이블 #T3_MKT_FCST / #T3_PRICE DROP 추가, 임시테이블 #T3_MKT_FCST ==> #T_SP_C_BALANCE_MKT_FCST / #T3_PRICE ==> #T_SP_C_BALANCE_PRICE 변경 START
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#T3_MKT_FCST', N'U') IS NOT NULL 
		DROP TABLE #T3_MKT_FCST
	IF OBJECT_ID (N'tempdb..#T3_PRICE', N'U') IS NOT NULL 
		DROP TABLE #T3_PRICE
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 임시테이블 #T3_MKT_FCST / #T3_PRICE DROP 추가, 임시테이블 #T3_MKT_FCST ==> #T_SP_C_BALANCE_MKT_FCST / #T3_PRICE ==> #T_SP_C_BALANCE_PRICE 변경 END
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------
	--[E20250529-001289]_SALES PLAN CUTOFF 완료 후 메일링 진행 
	---------------------------------------------------------------------------------------------------------
	EXEC [dbo].[PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND] @p_division_id, @p_creation_type
	-- 트랜잭션 (COMMIT)
    --COMMIT WORK;
	--------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	--ROLLBACK TRANSACTION MKT_FCST_C_QTY_BALANCE_CREATE;

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = N'@p_division_id : ' + RTRIM(LTRIM(@p_division_id)) ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	ERR_RTN:
	IF @v_log_type = 'INVALID'
		begin
			--ROLLBACK TRANSACTION MKT_FCST_C_QTY_BALANCE_CREATE
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		end
  END;

