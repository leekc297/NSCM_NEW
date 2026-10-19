

/*
 * Program ID   : PR_DM_TEST1
 * Description  : 매주 목,금요일에 Sales Plan Weekly cutoff 수행(81 : 목 00시, 40,82 : 금 00시)
 * Program History
 *============================================================================================================
 *   Date       In Charge              Description
 *============================================================================================================
*  20200701 P.C.I   [PJ20200138] Sales Plan Waterfall cut-off 주기 변경 - MKT_FCST_C/SALES_PLAN_C 분리(Weekly Cutoff Sales Price Version No 조회 (40,81 : 화요일 /82 : SP Version과 동일))
*  20200722 P.C.I   [PJ20200138] Sales Plan Weekly Cutoff 생성시 Sales Price, Exchange Rate Cutoff 동시 생성
*  20200727 P.C.I   [PJ20200138] Sales Plan Weekly Cutoff 생성시 실적은 MKT Fcst가 Cutoff 되는 시점의 화요일 Cutoff 실적을 사용하도록 로직 수정
*  20200731	HWI1993	과제 - ESS 실적매핑시 내부거래등 제거로직 적용에 따른 RESULT.ATTRIBUTE2 추가(확인) - 변경사항 없음.
 * 2020/09/09   P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2020/12/08   P.C.I		[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
 * 2021/02/05	KUNI		[C20210204-000387] (82)ESS사업부_SALES PLAN WATERFALL에 ETC매출 포함(LOOKUP)
 * 2021.07.02	HWI1993		[C20210629-000239] [SCM PI팀] MKT FCST Amt. 추가의 건
 * 2022.04.07   hwi1993     GM JV 작업
 * 2023-01-17   chano0612   [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건 - 선박BIZ건
 * 2023-03-11   chano0612   [E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건
 * 2024-04-03   KCW3408     Sales Plan 관련 자동사업부 기타 매출 추가(LOOKUP_TYPE:DM_SALES_PLAN_WATERFALL_SP_W_ADD)
 * 20240528		HMIN		[E20240508-000695] Corvus/Siemens사 자동차사업부 RTF 산출 시 동기화 반영 요청  
							룩업(DM_NET_DEMAND_EXCEPTION)에 등록된 SITE대상으로 82번 사업부에 RTF정보를 81번 RTF 정보로 반영 처리
 EXEC PR_DM_TEST1  @p_division_id='81', @p_cutoff_yyyymmdd = '20240401'
** -----------------------------------------------------------------------------------------------------------
*/
--PR_DM_TEST1 '81', '20230314'
CREATE PROCEDURE [dbo].[PR_DM_TEST1]

	-- Add the parameters for the stored procedure here
	@p_division_id				NVARCHAR(30)  -- DIVISION_ID
   ,@p_cutoff_yyyymmdd			NVARCHAR(08)  -- Sales Plan Cutoff 날짜

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_TEST1';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	
    DECLARE @c_MF_version				  NVARCHAR(100);
    --DECLARE @c_FP_version				  NVARCHAR(100);
    DECLARE @plan_start_yyyymmdd          NVARCHAR(08);
    --DECLARE @c_SP_version				  NVARCHAR(18);
    DECLARE @c_plan_tue_yyyymmdd          NVARCHAR(08);  --[PJ20200138] Sales Plan Result Daily Cutoff YYYYMMDD
	DECLARE @c_SP_result_version		  NVARCHAR(100); --[PJ20200138] Sales Plan Result Daily Cutoff Version
    DECLARE @c_ver_type					  NVARCHAR(10)   = 'SP_W'
    DECLARE @v_created_by				  NVARCHAR(1000) = 'system'
	DECLARE @v_count  				      INT = 0; --[E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건
	DECLARE @s_count  				      INT = 0; --[E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건
	DECLARE @CNT  				          INT = 0; --[E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건
	DECLARE @i    				          INT = 0; --[E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건
	DECLARE @v_SITE_ID			          NVARCHAR(100); --[E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건

	DECLARE	@v_ver_return_no		NVARCHAR(100);	-- cut off Generated Number	
	DECLARE	@v_OK_description		NVARCHAR(1200);	-- cut off Generated Number	

	-------------------------------------------------------------------------------------------------------------------------------------------	
	-- 변수값 셋팅
	-------------------------------------------------------------------------------------------------------------------------------------------	
	
	IF @p_cutoff_yyyymmdd = '' 
	BEGIN 
		SET @p_cutoff_yyyymmdd = CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
	END

	SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(@p_cutoff_yyyymmdd, 'MON')), 112)   -- 월요일
	SET @c_plan_tue_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(@p_cutoff_yyyymmdd, 'TUE')), 112)   -- 화요일 [PJ20200138] Sales Plan Result Daily Cutoff YYYYMMDD
		
	-------------------------------------------------------------------------------------------------------------------------------------------	

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = N'@p_division_id : ' + RTRIM(LTRIM(@p_division_id)) ;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	--BEGIN TRANSACTION MKT_FCST_C_QTY_BALANCE_CREATE;


	-- [C20210204-000387] 
	/* 2024-04-03   KCW3408     Sales Plan 관련 자동사업부 기타 매출 추가(LOOKUP_TYPE:DM_SALES_PLAN_WATERFALL_SP_W_ADD) */
	IF( @P_DIVISION_ID = '82' OR @P_DIVISION_ID LIKE '81%'  )
	BEGIN
		DECLARE @S_BLOCK_MODEL  NVARCHAR(MAX);  
		SET @S_BLOCK_MODEL = '';  
		SET @S_BLOCK_MODEL =   
				ISNULL(	(SELECT TOP 1 ISNULL(LOOKUP_TYPE,'') AS TYPE
						   FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)  
						  WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
							AND SEGMENT1 = @P_DIVISION_ID
							AND VALID_YN = 'Y'  
							AND SEGMENT1 IS NOT NULL
							AND SEGMENT2 IS NOT NULL
							AND SEGMENT3 IS NOT NULL
							)
				,'')
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

		-- mkt fcst -> sales plan 
		EXEC	[dbo].[PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW]	
		@p_division_id
		, 'SYSTEM'

	    -- Cutoff Version 생성
		EXEC	[dbo].[PR_DM_PLN_VERSION_CREATE]	--@return_value = [dbo].[PR_DM_PLN_VERSION_CREATE]
		 @p_division_id
		,'SALES_PLAN WEEKLY CUTOFF'
		,@c_ver_type
		,@v_created_by
		,@v_ver_return_no  OUTPUT
		,@v_OK_description OUTPUT					
		;					
		
		--SET @c_SP_version = @v_ver_return_no   -- SALES PLAN 용
				
		SELECT @c_MF_version = MAX(VERSION_NO)
		FROM   DM_MST_VERSION WITH(NOLOCK)
		WHERE  DIVISION_ID  = @p_division_id
		and    yyyymmdd    >= @plan_start_yyyymmdd
		and    version_type = 'MF_W'

PRINT @c_MF_version		;	
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
		
		--[PJ20200138] Sales Plan Result Daily Cutoff Version
		SELECT @c_SP_result_version = MIN(VERSION_NO)
		FROM   DM_MST_VERSION WITH(NOLOCK)
		WHERE  DIVISION_ID  = @p_division_id
		and    yyyymmdd     = @c_plan_tue_yyyymmdd
		and    version_type = 'SP_D'

PRINT @c_SP_result_version		;
		-- 진행 LOG  (START)
		SET @v_log_type = 'ING';
		SET @v_log_message = 'SALES_PLAN WEEKLY CUTOFF';
		SET @v_description = N'@p_division_id : ' + RTRIM(LTRIM(@p_division_id)) +' / ' + N'@v_ver_return_no : ' + RTRIM(LTRIM(@v_ver_return_no)) +' / ' + N'@c_MF_version : ' + RTRIM(LTRIM(@c_MF_version)) ;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 진행 LOG  (END)


		--[PJ20200138] Sales Price, Exchange Rate Cutoff 동시 생성
		--IF @p_division_id = '82' AND @c_ver_type = 'SP_W'
		BEGIN
			EXEC	[dbo].[PR_SCM_MST_FUTURE_PRICE_CUTOFF]	
					 @p_division_id
					,@c_ver_type
					,@v_created_by
					,@v_ver_return_no
					;


PRINT '@v_ver_return_no1: ' + CONVERT(CHAR,@v_ver_return_no );
			EXEC	[dbo].[PR_DM_MST_EXCHANGE_RATE_CUTOFF]	
					 @p_division_id
					,@c_ver_type
					,@v_created_by
					,@v_ver_return_no
					;
		END

PRINT '@v_ver_return_no2: ' + CONVERT(CHAR,@v_ver_return_no );

		-- 1. DM_PLN_SALES_PLAN_C CUTOFF
		BEGIN


				
				IF OBJECT_ID('tempdb..#SALES_PLAN_TEMP') IS NOT NULL
					BEGIN 
						DROP TABLE  #SALES_PLAN_TEMP          
					END 
                 
			  	SELECT TOP 0 * INTO #SALES_PLAN_TEMP  FROM dbo.dm_pln_sales_plan WITH(NOLOCK);
				
				-- QTY measure 생성
                INSERT INTO #SALES_PLAN_TEMP
				SELECT 
						w.DIVISION_ID
					,w.PROJECT_CODE
					,w.SCM_SITE_ID
					,w.ITEM_ID
					,w.DOM_EXP
					,w.FCST_TYPE
					,w.INCOTERMS
					,w.MEASURE
					,w.PLANT_SITE_ID
					,w.YYYYMMDD
					,isnull(si.CURRENCY,'')  -- 20180319 skh modify
					,w.QTY
					,w.CREATED_BY
					,w.CREATION_DATE
					,@v_created_by AS LAST_UPDATED_BY
					,GETDATE()
					,w.ATTRIBUTE1
					,w.ATTRIBUTE2
					,w.ATTRIBUTE3
					,w.ATTRIBUTE4
					,w.ATTRIBUTE5
					,w.ATTRIBUTE6
					,w.ATTRIBUTE7
					,w.ATTRIBUTE8
					,w.ATTRIBUTE9
					,w.ATTRIBUTE10
				FROM [dbo].DM_PLN_MKT_FCST_C w WITH(NOLOCK)
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
				ON   basis_yyyymmdd = w.yyyymmdd
				left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si				
				--left outer join (SELECT * FROM  [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si
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
				WHERE w.DIVISION_ID = @p_division_id
				AND   w.VERSION_NO  = @c_MF_version
				AND   w.YYYYMMDD   >= @plan_start_yyyymmdd
				AND   w.MEASURE    IN ( 'MKT_FCST','CUST_FCST', 'TMM_FCST', 'RTF_SCP', 'RTF_SYS_RP', 'RTF' ) --[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
				and   w.ITEM_ID    IN ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id)

				--[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
				/*
				UNION ALL
					
				SELECT 
						w.DIVISION_ID
					,w.PROJECT_CODE
					,w.SCM_SITE_ID
					,w.ITEM_ID
					,w.DOM_EXP
					,w.FCST_TYPE
					,w.INCOTERMS
					,w.MEASURE
					,w.PLANT_SITE_ID
					,w.YYYYMMDD
					,isnull(si.CURRENCY,'')  -- 20180319 skh modify
					,w.QTY
					,w.CREATED_BY
					,w.CREATION_DATE
					,@v_created_by AS LAST_UPDATED_BY
					,GETDATE()
					,w.ATTRIBUTE1
					,w.ATTRIBUTE2
					,w.ATTRIBUTE3
					,w.ATTRIBUTE4
					,w.ATTRIBUTE5
					,w.ATTRIBUTE6
					,w.ATTRIBUTE7
					,w.ATTRIBUTE8
					,w.ATTRIBUTE9
					,w.ATTRIBUTE10
				FROM [dbo].DM_PLN_SALES_PLAN w WITH(NOLOCK)
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
				ON   basis_yyyymmdd = w.yyyymmdd
				left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si
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
				WHERE w.DIVISION_ID = @p_division_id
				AND   w.YYYYMMDD   >= @plan_start_yyyymmdd
				AND   w.MEASURE    IN ( 'RTF' )
				and   w.ITEM_ID    IN ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id)
					*/

				----------------------------------------------------------|
--PRINT '■■■■■■■■■ AMT measure 생성 ■■■■■■■■■ ';

				-- AMT measure 생성
                INSERT INTO #SALES_PLAN_TEMP
				-- KRW 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID 
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,'SalesAmt_KRW' MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,si.CURRENCY
						,cast( STR( w.QTY * isnull (si.PRICE , 0) , 20, 5 ) as numeric(30, 10))
						,w.CREATED_BY
						,w.CREATION_DATE
						,@v_created_by AS LAST_UPDATED_BY
						,GETDATE()
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10						
				FROM #SALES_PLAN_TEMP w WITH(NOLOCK)
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
				ON   basis_yyyymmdd = w.yyyymmdd
				--left outer join (SELECT * FROM  [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si
				left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si
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
				WHERE w.DIVISION_ID = @p_division_id
				--AND   w.measure     = CASE WHEN @p_division_id in ('81','40') THEN 'RTF_SCP' ELSE 'RTF' END
				AND   w.measure     = 'RTF_SCP' --[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용


				UNION ALL 
				-- LOC 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,'SalesAmt_LOC' MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,si.CURRENCY
						,cast( STR( w.QTY * isnull (si.PRICE , 0) , 20, 5 ) as numeric(30, 10))
						,w.CREATED_BY
						,w.CREATION_DATE
						,@v_created_by AS LAST_UPDATED_BY
						,GETDATE()
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
				FROM #SALES_PLAN_TEMP w WITH(NOLOCK)
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
				ON   basis_yyyymmdd = w.yyyymmdd
				--left outer join (SELECT * FROM  [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si
				left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si
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
				WHERE w.DIVISION_ID = @p_division_id
				--AND   w.measure     = CASE WHEN @p_division_id in ('81','40') THEN 'RTF_SCP' ELSE 'RTF' END
				AND   w.measure     = 'RTF_SCP' --[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
				UNION ALL 
				-- USD 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,'SalesAmt_USD' MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,si.CURRENCY
						,cast( STR( w.QTY * isnull (si.PRICE , 0) , 20, 5 ) as numeric(30, 10))
						,w.CREATED_BY
						,w.CREATION_DATE
						,@v_created_by AS LAST_UPDATED_BY
						,GETDATE()
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
				FROM #SALES_PLAN_TEMP w WITH(NOLOCK)
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
				ON   basis_yyyymmdd = w.yyyymmdd
				--left outer join (SELECT * FROM  [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si
				left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si
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
				WHERE w.DIVISION_ID = @p_division_id
				--AND   w.measure     = CASE WHEN @p_division_id in ('81','40') THEN 'RTF_SCP' ELSE 'RTF' END
				AND   w.measure     = 'RTF_SCP' --[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
			
			UNION ALL	--	C20200803-000105	소형에 대해서만 MKT FCST AMT	를 계산한다. [C20210629-000239] 사업부제한 없앰
			
				SELECT   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID 
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,'MKT_AMT_KRW' MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,si.CURRENCY
						,cast( STR( w.QTY * isnull (si.PRICE , 0) , 20, 5 ) as numeric(30, 10))
						,w.CREATED_BY
						,w.CREATION_DATE
						,@v_created_by AS LAST_UPDATED_BY
						,GETDATE()
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10						
				FROM #SALES_PLAN_TEMP w WITH(NOLOCK)
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
				ON   basis_yyyymmdd = w.yyyymmdd
				--left outer join (SELECT * FROM  [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si
				left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si
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
				WHERE w.measure     = 'MKT_FCST'
				--AND   w.DIVISION_ID = '40'	[C20210629-000239]


				UNION ALL 
				-- LOC 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,'MKT_AMT_LOC' MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,si.CURRENCY
						,cast( STR( w.QTY * isnull (si.PRICE , 0) , 20, 5 ) as numeric(30, 10))
						,w.CREATED_BY
						,w.CREATION_DATE
						,@v_created_by AS LAST_UPDATED_BY
						,GETDATE()
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
				FROM #SALES_PLAN_TEMP w WITH(NOLOCK)
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
				ON   basis_yyyymmdd = w.yyyymmdd
				--left outer join (SELECT * FROM  [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si
				left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si
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
				WHERE w.measure     = 'MKT_FCST'
				
--print 'A2--' + convert(varchar(30), getdate(), 121)+@PLAN_START_YYYYMMDD+@v_ver_return_no+ @c_ver_type+@p_cutoff_yyyymmdd
				--AND   w.DIVISION_ID = '40'	[C20210629-000239]
--SELECT 'TEST1' AS GUBUN, *
--FROM #SALES_PLAN_TEMP WITH (NOLOCK) 
--WHERE 1=1
--AND DIVISION_ID = '81'
--AND SCM_SITE_ID = 'Corvus Norway_NO_BGO';

				/* 2024-04-03   KCW3408     Sales Plan 관련 자동사업부 기타 매출 추가(LOOKUP_TYPE:DM_SALES_PLAN_WATERFALL_SP_W_ADD) */
				IF ( @P_DIVISION_ID = '82' OR @P_DIVISION_ID LIKE '81%'  )
				BEGIN
					-- [C20210204-000387]
					INSERT INTO #SALES_PLAN_TEMP
					SELECT 
							W.DIVISION_ID
						,W.PROJECT_CODE
						,W.SCM_SITE_ID
						,W.ITEM_ID
						,W.DOM_EXP
						,W.FCST_TYPE
						,W.INCOTERMS
						,W.MEASURE
						,W.PLANT_SITE_ID
						,W.YYYYMMDD
						,W.CURRENCY -- ,ISNULL(SI.CURRENCY,'')  -- 20180319 SKH MODIFY
						,W.QTY
						,W.CREATED_BY
						,W.CREATION_DATE
						,@V_CREATED_BY AS LAST_UPDATED_BY
						,GETDATE()
						,W.ATTRIBUTE1
						,W.ATTRIBUTE2
						,W.ATTRIBUTE3
						,W.ATTRIBUTE4
						,W.ATTRIBUTE5
						,W.ATTRIBUTE6
						,W.ATTRIBUTE7
						,W.ATTRIBUTE8
						,W.ATTRIBUTE9
						,'ADD.ETC' --,W.ATTRIBUTE10
					FROM [DBO].DM_PLN_SALES_PLAN W WITH(NOLOCK) 
						INNER JOIN [DBO].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK) ON   BASIS_YYYYMMDD = W.YYYYMMDD
						/* 
						INNER JOIN [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] LO WITH(NOLOCK) ON LO.LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
																						AND LO.VALID_YN = 'Y'  
																						AND LO.SEGMENT1 = W.DIVISION_ID
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
							AND SI.MEASURE = 'LOC' 
						)	
						*/
					WHERE W.DIVISION_ID = @P_DIVISION_ID
					AND   W.YYYYMMDD   >= @PLAN_START_YYYYMMDD
					AND   W.FCST_TYPE IN (SELECT DISTINCT SEGMENT2 
					                        FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
					                       WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
										     AND VALID_YN = 'Y'  
											 AND SEGMENT1 = W.DIVISION_ID)
					AND   W.ITEM_ID IN (SELECT DISTINCT SEGMENT3 
					                        FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
					                       WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
										     AND VALID_YN = 'Y'  
											 AND SEGMENT1 = W.DIVISION_ID)   
					AND NOT EXISTS (    
										SELECT *
										FROM SCM_ADM_LOOKUP_MASTER_DETAIL C
										WHERE 1=1
										AND LOOKUP_TYPE = 'DM_SALE_PLAN_ETC_EXCEPTION'
										AND VALID_YN = 'Y'
										AND W.PROJECT_CODE = C.ATTRIBUTE1
										AND W.ITEM_ID = C.SEGMENT2
										AND W.YYYYMMDD = C.SEGMENT4
										AND W.FCST_TYPE = C.ATTRIBUTE3
										AND W.MEASURE = C.SEGMENT3
									)
					-- [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건 END
					
				END

			--	SELECT *
			--	FROM #SALES_PLAN_TEMP
--SELECT 'TEST2' AS GUBUN , * FROM #SALES_PLAN_TEMP WHERE SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y' );--20240531


				--[E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건--------------------START

				SET @v_count = 0
				SET @s_count = 0
				SET @CNT = 0
				IF( @P_DIVISION_ID = '81' )
				BEGIN
					
					SELECT @CNT = COUNT(SEGMENT2) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y'
					
					SET @i = 1
					WHILE @i <= @CNT
					BEGIN
						SET @v_SITE_ID = ''
						SELECT @v_SITE_ID = SEGMENT2 FROM(
						SELECT ROW_NUMBER() OVER(ORDER BY SEGMENT2 ) AS SEQ, SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y'
						) A WHERE A.SEQ = @i

						SELECT @v_count = COUNT(*) FROM #SALES_PLAN_TEMP
						WHERE DIVISION_ID = '81' 
						AND MEASURE = 'RTF_SYS_RP'
						AND SCM_SITE_ID = @v_SITE_ID

						IF (@v_count = 0)
						BEGIN
							SELECT @s_count = COUNT(*) FROM #SALES_PLAN_TEMP
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
									SELECT 
										 w.DIVISION_ID
										,w.PROJECT_CODE
										,w.SCM_SITE_ID
										,w.ITEM_ID
										,w.DOM_EXP
										,w.FCST_TYPE
										,w.INCOTERMS
										,'RTF_SYS_RP' MEASURE
										,w.PLANT_SITE_ID
										,w.YYYYMMDD
										,isnull(si.CURRENCY,'')  -- 20180319 skh modify
										,w.QTY
										,w.CREATED_BY
										,w.CREATION_DATE
										,@v_created_by AS LAST_UPDATED_BY
										,GETDATE()
										,w.ATTRIBUTE1
										,w.ATTRIBUTE2
										,w.ATTRIBUTE3
										,w.ATTRIBUTE4
										,w.ATTRIBUTE5
										,w.ATTRIBUTE6
										,w.ATTRIBUTE7
										,w.ATTRIBUTE8
										,w.ATTRIBUTE9
										,w.ATTRIBUTE10
									FROM [dbo].DM_PLN_MKT_FCST_C w WITH(NOLOCK)
									INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
									ON   basis_yyyymmdd = w.yyyymmdd
									--left outer join (SELECT * FROM  [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si
									left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND version_no = @v_ver_return_no ) si
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

		--SELECT * FROM #SALES_PLAN_TEMP WHERE 1=1
		--AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
		--AND MEASURE = 'RTF_SYS_RP'
--SELECT 'TEST3' AS GUBUN, * FROM #SALES_PLAN_TEMP WHERE SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y' );--20240531

--SELECT PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD
--     , SUM(CASE WHEN MEASURE = 'RTF' THEN QTY ELSE 0 END) RTF_QTY
--	 , SUM(CASE WHEN MEASURE = 'RTF_SCP' THEN QTY ELSE 0 END) RTF_SCP_QTY
--	 , SUM(CASE WHEN MEASURE = 'RTF_SYS_RP' THEN QTY ELSE 0 END) RTF_SYS_RP_QTY
--FROM #SALES_PLAN_TEMP
--WHERE SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y' )
--GROUP BY PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD;


				--[E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건--------------------END
					

				-- dm_pln_sales_plan_c 에 cutoff data insert
				INSERT  INTO  dbo.dm_pln_sales_plan_c 
				SELECT distinct 
					   DIVISION_ID, @v_ver_return_no, @c_ver_type,@p_cutoff_yyyymmdd
					   ,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY
					  ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,SYSDATETIME() as LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					  ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				FROM #SALES_PLAN_TEMP WITH(NOLOCK)
				where division_id = @p_division_id

		;
		END
		

		
		-- 2. DM_PLN_SALES_PLAN_REULT_C CUTOFF
		BEGIN
			INSERT INTO [dbo].DM_PLN_SALES_PLAN_RESULT_C 
			(
				DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
			,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY,CREATED_BY
			,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
			,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10, COMPANY_ID
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
			/*FROM [dbo].DM_PLN_SALES_PLAN_RESULT WITH(NOLOCK)*/
			FROM  [dbo].DM_PLN_SALES_PLAN_RESULT_C WITH(NOLOCK) --[PJ20200138] Sales Plan Weekly Cutoff 생성시 실적은 MKT Fcst가 Cutoff 되는 시점의 화요일 Cutoff 실적을 사용하도록 로직 수정
			--FROM  [10.34.221.78,7433].[LGCE_SCMPROD].DBO.DM_PLN_SALES_PLAN_RESULT_C WITH(NOLOCK) --[PJ20200138] Sales Plan Weekly Cutoff 생성시 실적은 MKT Fcst가 Cutoff 되는 시점의 화요일 Cutoff 실적을 사용하도록 로직 수정			
			WHERE DIVISION_ID = @p_division_id
			AND   VERSION_NO  = @c_SP_result_version
			--AND [YYYYMMDD]	<   CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)			-- [2018-03-28][추가][금주 월요일 이전]
			--AND [YYYYMMDD]	>=  CONVERT(CHAR(8), DATEADD(DD, -7*54, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)		-- 최근 1년치
		END

		--3. 81번 선박사업부 82번 매출 매핑 START --------------------------------------
		DECLARE @c_MF_version_81 AS NVARCHAR(100);
		DECLARE @c_SP_version_81 AS NVARCHAR(100);
		DECLARE @p_cutoff_yyyymmdd_81 AS NVARCHAR(08);
		
		IF (@P_DIVISION_ID = '82')
		BEGIN 
			
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
				FROM [dbo].DM_PLN_MKT_FCST_C w WITH(NOLOCK)
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
				ON   basis_yyyymmdd = w.yyyymmdd
				left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) 
									WHERE DIVISION_ID = '81' AND version_no = @c_SP_version_81 /* 'SP_W_20240612_V001' */) si
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
				AND   w.VERSION_NO  = @c_MF_version_81 /* 'MF_W_20240611_V001' */
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
				FROM #SALES_PLAN_TEMP_81 w WITH(NOLOCK)
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
				ON   basis_yyyymmdd = w.yyyymmdd
				left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = '81' AND version_no = @c_SP_version_81 /* 'SP_W_20240612_V001' */) si
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
				AND   w.measure     = 'RTF_SCP'
				AND W.SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
				UNION ALL 
				-- LOC 값을 계산
				select   w.DIVISION_ID			,w.PROJECT_CODE			,w.SCM_SITE_ID			,w.ITEM_ID			,w.DOM_EXP			,w.FCST_TYPE
						,w.INCOTERMS			,'SalesAmt_LOC' MEASURE	,w.PLANT_SITE_ID		,w.YYYYMMDD			,si.CURRENCY
						,cast( STR( w.QTY * isnull (si.PRICE , 0) , 20, 5 ) as numeric(30, 10)) AS QTY
						,w.CREATED_BY
						,w.CREATION_DATE
						,'system' AS LAST_UPDATED_BY
						,GETDATE() AS LAST_UPDATE_DATE
						,NULL AS ATTRIBUTE1			,NULL AS ATTRIBUTE2			,NULL AS ATTRIBUTE3			,NULL AS ATTRIBUTE4			,NULL AS ATTRIBUTE5
						,NULL AS ATTRIBUTE6			,NULL AS ATTRIBUTE7			,NULL AS ATTRIBUTE8			,NULL AS ATTRIBUTE9			,NULL AS ATTRIBUTE10	
				FROM #SALES_PLAN_TEMP_81 w WITH(NOLOCK)
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
				ON   basis_yyyymmdd = w.yyyymmdd
				left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = '81' AND version_no = @c_SP_version_81 /* 'SP_W_20240612_V001' */) si
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
				AND   w.measure     = 'RTF_SCP'
				AND W.SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
				UNION ALL 
				-- USD 값을 계산
				select   w.DIVISION_ID			,w.PROJECT_CODE			,w.SCM_SITE_ID			,w.ITEM_ID			,w.DOM_EXP			,w.FCST_TYPE
						,w.INCOTERMS			,'SalesAmt_USD' MEASURE	,w.PLANT_SITE_ID		,w.YYYYMMDD			,si.CURRENCY
						,cast( STR( w.QTY * isnull (si.PRICE , 0) , 20, 5 ) as numeric(30, 10)) AS QTY
						,w.CREATED_BY			,w.CREATION_DATE		,'system' AS LAST_UPDATED_BY			,GETDATE() AS LAST_UPDATE_DATE
						,NULL AS ATTRIBUTE1			,NULL AS ATTRIBUTE2			,NULL AS ATTRIBUTE3			,NULL AS ATTRIBUTE4			,NULL AS ATTRIBUTE5
						,NULL AS ATTRIBUTE6			,NULL AS ATTRIBUTE7			,NULL AS ATTRIBUTE8			,NULL AS ATTRIBUTE9			,NULL AS ATTRIBUTE10
				FROM #SALES_PLAN_TEMP_81 w WITH(NOLOCK)
				INNER JOIN [dbo].[SCM_SYS_CALENDAR_M] CAL  WITH(NOLOCK)
				ON   basis_yyyymmdd = w.yyyymmdd
				left outer join (SELECT * FROM  [dbo].[SCM_MST_FUTURE_PRICE_C] WITH(NOLOCK) WHERE DIVISION_ID = '81' AND version_no = @c_SP_version_81 /* 'SP_W_20240612_V001' */) si
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
				AND   w.measure     = 'RTF_SCP' 
				AND W.SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
			)
			, #FINAL_DATA AS (
				SELECT *
				FROM #SALES_PLAN_TEMP_81   /* 수량 */
				UNION ALL
				SELECT *
				FROM #SALES_PLAN_TEMP_81_2  /* 금액*/
			) 			
			SELECT * INTO #TEMP_AFTER_RTF_81 
			FROM (
				SELECT DIVISION_ID, @c_SP_version_81 AS VERSION_NO, 'SP_W' AS CUTOFF_TYPE,@p_cutoff_yyyymmdd_81 AS CUTOFF_YYYYMMDD
					,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY
					,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,SYSDATETIME() as LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				FROM #FINAL_DATA
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
						SELECT ROW_NUMBER() OVER(ORDER BY SCM_SITE_ID) AS SEQ, SCM_SITE_ID FROM #TEMP_AFTER_RTF_81 GROUP BY SCM_SITE_ID
					) A WHERE A.SEQ = @i


					SELECT @v_count = COUNT(*) FROM #TEMP_AFTER_RTF_81
									WHERE DIVISION_ID = '81' 
									AND MEASURE = 'RTF_SYS_RP'
									AND SCM_SITE_ID = @v_SITE_ID
		
					IF (@v_count = 0)
					BEGIN
						SELECT @s_count = COUNT(*) FROM #TEMP_AFTER_RTF_81
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

			DELETE FROM DM_PLN_SALES_PLAN_C
			--SELECT * FROM DM_PLN_SALES_PLAN_C WITH (NOLOCK)
			WHERE 1=1
			AND DIVISION_ID = '81'
			AND VERSION_NO = @c_SP_version_81
			AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
			AND SCM_SITE_ID IN (SELECT SCM_SITE_ID FROM #TEMP_AFTER_RTF_81 GROUP BY SCM_SITE_ID)
			AND MEASURE IN ('RTF','RTF_SCP','RTF_SYS_RP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');
				
			INSERT INTO DM_PLN_SALES_PLAN_C (
				 DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10)
			SELECT DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10 
			FROM #TEMP_AFTER_RTF_81
		END 
		/* 3-END */

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


