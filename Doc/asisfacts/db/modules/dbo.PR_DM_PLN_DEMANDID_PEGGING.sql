

/*=====================================================================================================================================================
 * Program ID   : PR_DM_PLN_DEMANDID_PEGGING
 * Description  : Demand ID 생성으로 FCST 변경이력추적 및 원인을 파악하기 위해서
 * Program History
 *=====================================================================================================================================================
 *   Date 		In Charge		Description
 *=====================================================================================================================================================
 * 2018.05.04                   Demand Pegging 정보를 생성하기 위한 프로시져
 * 2018.10.04	KHSONG			PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM 호출 추가
 * 2019.01.10	KHSONG			SEQ 2자리 -> 3자리로 변경
 * 2022.04.05   hwi1993			GM JV 작업
 * 2025.02.05	KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선
 * 2025.05.07	KANG.H.J		[PJ2025-50188] 기준수요 (SCM_FCST 기반 NET_DEMAND 생성)
 * 2025.05.14	KANG.H.J		[PJ2025-50188] DM_PLN_NET_DEMAND 생성 기준을 가장 최근의 버젼을 기반으로 생성하도록 정의
 * 2025.05.29	KANG.H.J		[PJ2025-50188] #T_MKT_FCST$ 임시테이블 시작/끝 부분에 DROP 기능 추가
 *===================================================================================================================================================*/


CREATE PROCEDURE [dbo].[PR_DM_PLN_DEMANDID_PEGGING]
	@p_division_id				NVARCHAR(30)

AS  

BEGIN

	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	/*  000 **********************************************************************************
		DECLARATION
		****************************************************************************************
	*/
	-- CURSOR RETURN VALUE
	DECLARE	@v_division_id				    NVARCHAR(60)
	DECLARE @v_mkt_fcst_version_no			NVARCHAR(100);			
	DECLARE @v_last_demandid_version_no		NVARCHAR(100)
	DECLARE	@v_project_code					NVARCHAR(100)
	DECLARE	@v_scm_site_id					NVARCHAR(60)
	DECLARE	@v_item_id						NVARCHAR(100)
	DECLARE	@v_dom_exp						NVARCHAR(6)
	DECLARE	@v_fcst_type					NVARCHAR(40)
	DECLARE	@v_incoterms					NVARCHAR(20)
	DECLARE	@v_measure						NVARCHAR(100)
	DECLARE	@v_plant_site_id				NVARCHAR(60)
	DECLARE	@v_cell_prod_site_id				NVARCHAR(60)
	DECLARE @v_basis_yyyymmdd				NVARCHAR(08)
	DECLARE @v_demand_id    				NVARCHAR(100)
	DECLARE @v_yyyymmdd     				NVARCHAR(8)
	DECLARE @v_qty          				INTEGER = 0;
	DECLARE @v_mkt_fcst_yyyymmdd			NVARCHAR(8) 
	DECLARE @v_mkt_fcst_qty          		INTEGER = 0;
	DECLARE @v_work_week					NVARCHAR(8) 
	DECLARE @v_split_demand_id    			NVARCHAR(100)

	---- 신규변수
    DECLARE @v_target_date					DATETIME;  -- 날짜변수 대체

	-- [PJ2025-50188] 기준수요 (SCM_FCST 기반 NET_DEMAND 생성) Start
    DECLARE @v_cutoff_version_type		NVARCHAR(10);			-- [PJ2025-50188] MF_W / SF_W
    DECLARE @v_measure_fcst_type		NVARCHAR(10);			-- [PJ2025-50188] MKT_FCST / SCM_FCST
	-- [PJ2025-50188] 기준수요 (SCM_FCST 기반 NET_DEMAND 생성) End


	---- LOG 용 변수 설정
    DECLARE @v_program_name					NVARCHAR(150) = 'PR_DM_PLN_DEMANDID_PEGGING';
    DECLARE @v_log_type						NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count					INTEGER = 0;
    DECLARE @v_log_message					NVARCHAR(1000);
    DECLARE @v_description					NVARCHAR(500);
    DECLARE @d_event_date					DATETIME;


	/*
		-----------------------------------------------------------------------------------------
			: START LOG
		-----------------------------------------------------------------------------------------
	*/
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRAN
	-----------------------------------------------------------------------------------------
	BEGIN TRY
	-----------------------------------------------------------------------------------------

/*		-- [PJ2025-50188] 삭제... 전주 또는 당주 버젼 체크하는 로직이 변경이 되어 삭제함. Start
			-- [PJ2025-50188] LOOKUP 기반 CUTOFF_TYPE, MEASURE(MKT_FCST/SCM_FCST) 선택 Start
			IF (@p_division_id = '40')
			BEGIN
				
				SELECT @v_cutoff_version_type	= SEGMENT2
					 , @v_measure_fcst_type		= ATTRIBUTE1 
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
				WHERE LOOKUP_TYPE	= 'DM_NET_DEMAND_CUTOFF_TYPE'
				AND   SEGMENT1		= @p_division_id

			END
			-- [PJ2025-50188] LOOKUP 기반 CUTOFF_TYPE, MEASURE(MKT_FCST/SCM_FCST) 선택 Start

			SELECT @v_mkt_fcst_version_no = MAX(A.VERSION_NO)
			  FROM DM_MST_VERSION A WITH(NOLOCK)					
			 WHERE A.DIVISION_ID	=	@p_division_id
--			   AND A.CUTOFF_TYPE	=	'MF_W'
			   AND A.VERSION_TYPE	=	@v_cutoff_version_type		-- [PJ2025-50188] MF_W / SF_W

			--   and a.CUTOFF_YYYYMMDD < '20181001'  -- 과거 주차를 돌릴때 사용.
*/		-- [PJ2025-50188] 삭제... 전주 또는 당주 버젼 체크하는 로직이 변경이 되어 삭제함. End


		-- [PJ2025-50188] DM_PLN_NET_DEMAND 생성 기준을 가장 최근의 버젼을 기반으로 생성하도록 정의 Start
		BEGIN
			-- [PJ2025-50188] 전주 기준의 VERSION_NO / CUTOFF_TYPE / MEASURE 정의
			SELECT TOP 1
				   @v_mkt_fcst_version_no	= A.VERSION_NO		
				 , @v_cutoff_version_type	= A.VERSION_TYPE		-- [PJ2025-50188] ㅡMF_W / SF_W
				 , @v_measure_fcst_type		= CASE WHEN A.VERSION_TYPE = 'MF_W' THEN 'MKT_FCST' 
												   WHEN A.VERSION_TYPE = 'SF_W' THEN 'SCM_FCST' 
											  ELSE '' END										
			FROM 
			(
--				SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, CREATION_DATE, RANK() OVER (ORDER BY CREATION_DATE DESC, YYYYMMDD DESC, VER_CRE_SEQ DESC) AS RN	-- [PJ2025-50188] 가장 최근의 버젼
				SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, CREATION_DATE, RANK() OVER (ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC, VERSION_TYPE DESC) AS RN	-- [PJ2025-50188] 가장 최근의 버젼이며, SF_W가 MF_W보다 우선함.
				FROM DM_MST_VERSION WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND   VERSION_TYPE IN ('MF_W', 'SF_W')
			) A
			WHERE RN = 1;

		END
		-- [PJ2025-50188] DM_PLN_NET_DEMAND 생성 기준을 가장 최근의 버젼을 기반으로 생성하도록 정의 End

		set @v_target_date =  cast( substring( @v_mkt_fcst_version_no,6,8) as datetime)  -- 기준일자를 설정
            
		SELECT @v_last_demandid_version_no =  MAX(VERSION_NO)
			FROM DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
		    WHERE DIVISION_ID		=	@p_division_id
			AND CHANGE_DATE		<	CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(@v_target_date, 'MON')), 112)     -- 당주 월요일
			AND CHANGE_DATE		>=	CONVERT(VARCHAR(08), DATEADD(WW, -2, DBO.FN_NEXT_DAY(@v_target_date, 'MON')), 112)	-- 전주 월요일       

		-- 이번주차 생성대상 있으면 삭제
		DELETE
			FROM DM_PLN_DEMANDID_PEGGING
		    WHERE DIVISION_ID		=	@p_division_id
			AND VERSION_NO		=	@v_mkt_fcst_version_no

		-- 생성일 주차
		SELECT @v_work_week = iso_yyyyww
			FROM [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
			where BASIS_YYYYMMDD = convert(varchar, @v_target_date, 112)           
	   
		IF  OBJECT_ID(N'tempdb..#T_CUTOFF_TODAY_TBL', N'U') IS NOT NULL 
  						DROP TABLE #T_CUTOFF_TODAY_TBL   ;

		IF  OBJECT_ID(N'tempdb..#T_BF_WEEK_TBL', N'U') IS NOT NULL 
  						DROP TABLE #T_BF_WEEK_TBL   ;

		IF  OBJECT_ID(N'tempdb..#T_RESULT_BASIS_YYYYMMDD_TBL', N'U') IS NOT NULL 
  						DROP TABLE #T_RESULT_BASIS_YYYYMMDD_TBL   ;

		IF  OBJECT_ID(N'tempdb..#CO_CHECK_TMP', N'U') IS NOT NULL 
  						DROP TABLE #CO_CHECK_TMP   ;
		-- [PJ2025-50188] #T_MKT_FCST$ 임시테이블 시작/끝 부분에 DROP 기능 추가
		IF  OBJECT_ID(N'tempdb..#T_MKT_FCST$', N'U') IS NOT NULL			
  						DROP TABLE #T_MKT_FCST$   ;
            
		-- 당주 Cutoff MKT FCST 정보
		CREATE TABLE #T_CUTOFF_TODAY_TBL(
				DIVISION_ID			NVARCHAR(60)				,						
				PROJECT_CODE		NVARCHAR(100)				,	
				SCM_SITE_ID			NVARCHAR(60)				,			
				ITEM_ID				NVARCHAR(100)				,			
				DOM_EXP				NVARCHAR(6)					,			
				FCST_TYPE			NVARCHAR(40)				,
				INCOTERMS			NVARCHAR(20)				,
				PLANT_SITE_ID		NVARCHAR(60)				,
				CELL_PROD_SITE_ID	NVARCHAR(60)				,		-- [PJ2025-50017] 추가
				YYYYMMDD			NVARCHAR(16)				,
				QTY					NUMERIC(20, 10)
		)

		-- 전주 CUTOFF의 전주 계획
		CREATE TABLE #T_BF_WEEK_TBL(
				DIVISION_ID			NVARCHAR(60)				,	
				DEMAND_ID			NVARCHAR(40)				,			
				PROJECT_CODE		NVARCHAR(100)				,	
				SCM_SITE_ID			NVARCHAR(60)				,			
				ITEM_ID				NVARCHAR(100)				,			
				DOM_EXP				NVARCHAR(6)					,			
				FCST_TYPE			NVARCHAR(40)				,
				INCOTERMS			NVARCHAR(20)				,
				PLANT_SITE_ID		NVARCHAR(60)				,
				CELL_PROD_SITE_ID	NVARCHAR(60)				,		-- [PJ2025-50017] 추가
				YYYYMMDD			NVARCHAR(16)				,
				QTY					NUMERIC(20, 10)
		)
			
		CREATE TABLE #CO_CHECK_TMP(
				DIVISION_ID						NVARCHAR(60)				,	
				PROJECT_CODE					NVARCHAR(100)				,	
				SCM_SITE_ID						NVARCHAR(60)				,			
				ITEM_ID							NVARCHAR(100)				,			
				DOM_EXP							NVARCHAR(6)					,			
				FCST_TYPE						NVARCHAR(40)				,
				INCOTERMS						NVARCHAR(20)				,
				PLANT_SITE_ID					NVARCHAR(60)				,
				CELL_PROD_SITE_ID				NVARCHAR(60)				,		-- [PJ2025-50017] 추가
				YYYYMMDD						NVARCHAR(16)				,
				DEMAND_ID						NVARCHAR(40)				,
				QTY								NUMERIC(20, 10)				,
				ACCUM_SUM						NUMERIC(20, 10)				,
				ACCUM_SUM2						NUMERIC(20, 10)				,
				LASTWEEK_RESULT					NUMERIC(20, 10)				,
				LASTWEEK_PEGGING_FROM_THIS_WEEK	NUMERIC(20, 10)				,
				CUTOFF_FCST_FROM_THIS_WEEK		NUMERIC(20, 10)				
		)
		-- [PJ2025-50017] 소형 매출계획 동기화 개선 - 전주/당주 DM_PLN_CFM_MKT_DEMAND_PLAN / DM_PLN_MKT_FCST  -- VERSION_NO 별로 구분가능
		CREATE TABLE #T_MKT_FCST$ (
					 DIVISION_ID        nvarchar(30)   
					,VERSION_NO         nvarchar(50)   
					,CUTOFF_TYPE    	nvarchar(10)    
					,CUTOFF_YYYYMMDD    nvarchar(8)    
					,PROJECT_CODE       nvarchar(50)   
					,SCM_SITE_ID        nvarchar(30)   
					,ITEM_ID            nvarchar(50)   
					,DOM_EXP            nvarchar(3)    
					,FCST_TYPE          nvarchar(20)   
					,INCOTERMS          nvarchar(10)   
					,PLANT_SITE_ID      nvarchar(30)   
					,CELL_PROD_SITE_ID  nvarchar(30)				
					,MEASURE        	nvarchar(50)				
					,YYYYMMDD           nvarchar(8)    
					,QTY                numeric(20, 10)
		)
		;
		------------------------------------------------------------------------------------------- CarryOver 수량 계산 (start)
		BEGIN 
		-------------------------------------------------------------------------------------------

		-- [PJ2025-50017] 소형 매출계획 동기화 개선 - 각 사업부별 공통정보 임시테블에 저장 Start
			IF (@p_division_id = '40')
			BEGIN

				INSERT INTO #T_MKT_FCST$
				(
					  DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD   
					, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS         
					, PLANT_SITE_ID     
					, CELL_PROD_SITE_ID 
					, MEASURE        	
					, YYYYMMDD          
					, QTY               
				)
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD   
					, END_CUSTOMER				AS PROJECT_CODE			-- [PJ2025-50017] 타 사업부 밑 다른 기준정보와 통일성을 갖추기 위해 END_CUSTOMER를 PROJECT 코드에 반영
					, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS         
					, PLANT_SITE_ID     
					, CELL_PROD_SITE_ID					
					, MEASURE        	
					, YYYYMMDD          
					, QTY  
				FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C WITH(NOLOCK)			-- [PJ2025-50017] 40 사업부 기준테이블
				WHERE DIVISION_ID	= @p_division_id   
				AND VERSION_NO		= @v_mkt_fcst_version_no
				AND MEASURE IN ('MKT_FCST','SCM_FCST','VMI_In_Req','AS_In_Req')		-- 해당 MEASURE로 국한하지 않으면, MKT_AMT_KRW로 인해 OVERFLOW 발생 가능함.
				;

			END
			ELSE
			BEGIN
				INSERT INTO #T_MKT_FCST$
				(
						DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD   
					, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS         
					, PLANT_SITE_ID     
					, CELL_PROD_SITE_ID							
					, MEASURE        	
					, YYYYMMDD          
					, QTY               
				)
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD   
					, PROJECT_CODE
					, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS         
					, PLANT_SITE_ID     
					, '-'						AS	CELL_PROD_SITE_ID					-- [PJ2025-50017] 81/82 사업부는 MKT_FCST에 CELL_PROD_SITE_ID가 없으므로 '-'로 정의
					, MEASURE        	
					, YYYYMMDD          
					, QTY  
				FROM DM_PLN_MKT_FCST_C WITH(NOLOCK)						-- [PJ2025-50017] 81/82 사업부 기준테이블
				WHERE DIVISION_ID	= @p_division_id   
				AND VERSION_NO		= @v_mkt_fcst_version_no
				AND MEASURE IN ('MKT_FCST','SCM_FCST','VMI_In_Req','AS_In_Req')		-- 해당 MEASURE로 국한하지 않으면, MKT_AMT_KRW로 인해 OVERFLOW 발생 가능함.
				;
			END
			-- [PJ2025-50017] 소형 매출계획 동기화 개선 - 각 사업부별 공통정보 임시테블에 저장 End


			INSERT INTO #CO_CHECK_TMP (
					DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,INCOTERMS, PLANT_SITE_ID
				,   CELL_PROD_SITE_ID							-- [PJ2025-50017] 추가
				,	YYYYMMDD, DEMAND_ID, QTY
				,	ACCUM_SUM, ACCUM_SUM2, LASTWEEK_RESULT, LASTWEEK_PEGGING_FROM_THIS_WEEK, CUTOFF_FCST_FROM_THIS_WEEK		
			)
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
				, A.CELL_PROD_SITE_ID							-- [PJ2025-50017] 추가
				, YYYYMMDD, DEMAND_ID,  QTY
				, SUM(QTY) OVER ( PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID ORDER BY YYYYMMDD DESC, A.DEMAND_ID DESC ROWS UNBOUNDED PRECEDING) ACCUM_SUM,	-- [PJ2025-50017] 소형 매출계획 동기화 개선(CELL_PROD_SITE_ID 추가)
				SUM(QTY) OVER ( PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID ) ACCUM_SUM2,				-- [PJ2025-50017] 소형 매출계획 동기화 개선(CELL_PROD_SITE_ID 추가)
					(
											SELECT	 ISNULL(SUM(ISNULL(QTY, 0)), 0)
												FROM	DM_PLN_MKT_FCST_RESULT B WITH(NOLOCK)
												WHERE	1 = 1
												AND B.DIVISION_ID   = A.DIVISION_ID   
												AND	B.PROJECT_CODE	= A.PROJECT_CODE	
												AND	B.SCM_SITE_ID   = A.SCM_SITE_ID   
												AND	B.ITEM_ID		= A.ITEM_ID		
												AND B.DOM_EXP		= A.DOM_EXP		
												AND	B.FCST_TYPE		= A.FCST_TYPE		
												AND B.INCOTERMS		= A.INCOTERMS		
												AND B.MEASURE		= 'RTF'
												AND	B.PLANT_SITE_ID	= A.PLANT_SITE_ID
												AND B.YYYYMMDD	    BETWEEN CONVERT(VARCHAR(08), DATEADD(WW, -2, DBO.FN_NEXT_DAY(@v_target_date, 'MON')), 112) AND				-- 전주구간
																			CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(@v_target_date, 'SUN')), 112)
					) LASTWEEK_RESULT,
					(
											SELECT	 ISNULL(SUM(ISNULL(QTY, 0)), 0)
												FROM	DM_PLN_DEMANDID_PEGGING B WITH(NOLOCK)
												WHERE	1 = 1
												AND B.DIVISION_ID   = A.DIVISION_ID   
												AND	B.PROJECT_CODE	= A.PROJECT_CODE	
												AND	B.SCM_SITE_ID   = A.SCM_SITE_ID   
												AND	B.ITEM_ID		= A.ITEM_ID		
												AND B.DOM_EXP		= A.DOM_EXP		
												AND	B.FCST_TYPE		= A.FCST_TYPE		
												AND B.INCOTERMS		= A.INCOTERMS		
												AND	B.PLANT_SITE_ID	= A.PLANT_SITE_ID
												AND	B.CELL_PROD_SITE_ID	= A.CELL_PROD_SITE_ID			-- [PJ2025-50017] 추가
												AND B.VERSION_NO    = A.VERSION_NO
												AND B.YYYYMMDD	    BETWEEN CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(@v_target_date, 'MON')), 112) AND				-- 당주~11주후 구간
																			CONVERT(VARCHAR(08), DATEADD(WW, 11, DBO.FN_NEXT_DAY(@v_target_date, 'SUN')), 112)
					) LASTWEEK_PEGGING_FROM_THIS_WEEK,
					(
											SELECT	 ISNULL(SUM(ISNULL(QTY, 0)), 0)
												FROM	#T_MKT_FCST$ B WITH(NOLOCK)		-- [PJ2025-50017] / [PJ2025-50188] DM_PLN_MKT_FCST_C / DM_PLN_CFM_MKT_DEMAND_PLAN_C
												WHERE	1 = 1
												AND B.DIVISION_ID   = A.DIVISION_ID   
												AND	B.PROJECT_CODE	= A.PROJECT_CODE	
												AND	B.SCM_SITE_ID   = A.SCM_SITE_ID   
												AND	B.ITEM_ID		= A.ITEM_ID		
												AND B.DOM_EXP		= A.DOM_EXP		
												AND	B.FCST_TYPE		= A.FCST_TYPE		
												AND B.INCOTERMS		= A.INCOTERMS		
												--AND B.MEASURE		= 'MKT_FCST'
												AND B.MEASURE		= @v_measure_fcst_type				-- [PJ2025-50188] 기준수요 (MKT_FCST / SCM_FCST)										
												AND	B.PLANT_SITE_ID	= A.PLANT_SITE_ID
												AND	B.CELL_PROD_SITE_ID	= A.CELL_PROD_SITE_ID			-- [PJ2025-50017] 추가
												AND B.VERSION_NO    = @v_mkt_fcst_version_no  -- max version_no
												AND B.YYYYMMDD	    BETWEEN CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(@v_target_date, 'MON')), 112) AND				-- 당주~11주후 구간
																			CONVERT(VARCHAR(08), DATEADD(WW,  1*11, DBO.FN_NEXT_DAY(@v_target_date, 'SUN')), 112)
					) CUTOFF_FCST_FROM_THIS_WEEK
				FROM DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
				WHERE DIVISION_ID	=	@p_division_id
				AND VERSION_NO	=	@v_last_demandid_version_no
				AND YYYYMMDD		<	CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(@v_target_date, 'MON')), 112)  -- 전주구간
				AND YYYYMMDD		>=	CONVERT(VARCHAR(08), DATEADD(WW, -2, DBO.FN_NEXT_DAY(@v_target_date, 'MON')), 112)
			;


			SELECT *,  CASE WHEN (CUTOFF_FCST_FROM_THIS_WEEK-LASTWEEK_PEGGING_FROM_THIS_WEEK) > (ACCUM_SUM2 - LASTWEEK_RESULT ) THEN (ACCUM_SUM2 - LASTWEEK_RESULT ) ELSE (CUTOFF_FCST_FROM_THIS_WEEK-LASTWEEK_PEGGING_FROM_THIS_WEEK) END CO_NEED_QTY
				  -- A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, YYYYMMDD, DEMAND_ID
			  INTO  #CO_CHECK_TMP2
			  FROM  #CO_CHECK_TMP A
			 WHERE LASTWEEK_PEGGING_FROM_THIS_WEEK < CUTOFF_FCST_FROM_THIS_WEEK
			   AND LASTWEEK_RESULT < ACCUM_SUM2
			;

			-- 최종 적용대상 전주 DEMAND ID 
			-- CARRYOVER 대상
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
				,  A.CELL_PROD_SITE_ID				-- [PJ2025-50017] 추가
				,  YYYYMMDD, DEMAND_ID
				, CASE  WHEN ( CO_NEED_QTY-(ACCUM_SUM-QTY) ) <= 0 THEN 0  
						WHEN QTY > ( CO_NEED_QTY-(ACCUM_SUM-QTY) ) THEN ( CO_NEED_QTY-(ACCUM_SUM-QTY) ) 
						ELSE QTY 
				   END						AS QTY
			 INTO #LAST_WEEK_DEMAND_PEGGING
			 FROM #CO_CHECK_TMP2 A
			 WHERE CASE WHEN ( CO_NEED_QTY-(ACCUM_SUM-QTY) ) <= 0 THEN 0  
						WHEN QTY > ( CO_NEED_QTY-(ACCUM_SUM-QTY) ) THEN ( CO_NEED_QTY-(ACCUM_SUM-QTY) ) 
						ELSE QTY 
					END > 0

			UNION ALL
			-- 당주 이후 구간 DEMAND ID 
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
				,  A.CELL_PROD_SITE_ID				-- [PJ2025-50017] 추가
				,  YYYYMMDD, DEMAND_ID, QTY
			  FROM DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
			 WHERE DIVISION_ID	=	@p_division_id
			   AND VERSION_NO	=	@v_last_demandid_version_no
			   AND YYYYMMDD		>=	CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(@v_target_date, 'MON')), 112)
			;
		-----------------------------------------------------------------------------------------
		END
		------------------------------------------------------------------------------------------- CarryOver 수량 계산 (end)

		-- 전주 DemandID 전체 ( CarryOver 반영된 값 )
		INSERT INTO #T_BF_WEEK_TBL
		  ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, DEMAND_ID, QTY )		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, DEMAND_ID, QTY		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		  FROM #LAST_WEEK_DEMAND_PEGGING
		;


		-- 당주 MKT FCST 전체 ( CarryOver 반영된 값 )
		INSERT INTO #T_CUTOFF_TODAY_TBL
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY)				-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, YYYYMMDD, QTY		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM #T_MKT_FCST$ A WITH(NOLOCK)
		WHERE A.VERSION_NO  = @v_mkt_fcst_version_no
			AND A.DIVISION_ID = @p_division_id
			AND A.YYYYMMDD    >= CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(@v_target_date, 'MON')), 112)
			and A.YYYYMMDD    < CONVERT(VARCHAR(08), DATEADD(WW, 10, DBO.FN_NEXT_DAY(@v_target_date, 'MON')), 112) -- Demand Pegging 정보를 만들기 위한 구간.
			--AND A.MEASURE     = 'MKT_FCST'
			AND A.MEASURE     = @v_measure_fcst_type				-- [PJ2025-50188] 기준수요 (MKT_FCST / SCM_FCST)
			AND A.QTY > 0
		;



		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'PEGGING_TARGET_CUR')
		BEGIN
			CLOSE PEGGING_TARGET_CUR
			DEALLOCATE PEGGING_TARGET_CUR
		END;

		DECLARE PEGGING_TARGET_CUR CURSOR FAST_FORWARD FOR
								SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
								  FROM #T_BF_WEEK_TBL A
									  ,#T_CUTOFF_TODAY_TBL B
								 WHERE A.DIVISION_ID     = B.DIVISION_ID    
								   AND A.PROJECT_CODE	 = B.PROJECT_CODE	
								   AND A.SCM_SITE_ID	 = B.SCM_SITE_ID	
								   AND A.ITEM_ID		 = B.ITEM_ID		
								   AND A.DOM_EXP		 = B.DOM_EXP		
								   AND A.FCST_TYPE		 = B.FCST_TYPE		
								   AND A.INCOTERMS		 = B.INCOTERMS		
								   AND A.PLANT_SITE_ID	 = B.PLANT_SITE_ID	
								   AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID			-- [PJ2025-50017] 추가

		OPEN PEGGING_TARGET_CUR
			FETCH NEXT FROM PEGGING_TARGET_CUR INTO @v_division_id		,
													@v_project_code		,
													@v_scm_site_id		,
													@v_item_id			,
													@v_dom_exp			,
													@v_fcst_type		,
													@v_incoterms		,
													@v_plant_site_id	,
													@v_cell_prod_site_id					-- [PJ2025-50017] 추가

        WHILE @@FETCH_STATUS = 0
			BEGIN

					IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'LAST_WEEK_DEMANDID_CUR')
					BEGIN
						CLOSE LAST_WEEK_DEMANDID_CUR
						DEALLOCATE LAST_WEEK_DEMANDID_CUR
					END;
					DECLARE LAST_WEEK_DEMANDID_CUR CURSOR FAST_FORWARD FOR
											SELECT A.DEMAND_ID, A.YYYYMMDD, A.QTY
											  FROM #T_BF_WEEK_TBL A
											 WHERE A.DIVISION_ID     = @v_division_id   
											   AND A.PROJECT_CODE	 = @v_project_code	
											   AND A.SCM_SITE_ID	 = @v_scm_site_id
											   AND A.ITEM_ID		 = @v_item_id	
											   AND A.DOM_EXP		 = @v_dom_exp	
											   AND A.FCST_TYPE		 = @v_fcst_type	
											   AND A.INCOTERMS		 = @v_incoterms		
											   AND A.PLANT_SITE_ID	 = @v_plant_site_id
											   AND A.CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
											 ORDER BY YYYYMMDD, DEMAND_ID

					OPEN LAST_WEEK_DEMANDID_CUR
					    -- key 정보는 상위 cursor에서 정의된 값을 같이 쓰면됨.
						FETCH NEXT FROM LAST_WEEK_DEMANDID_CUR INTO @v_demand_id		,
																    @v_yyyymmdd  		,
																    @v_qty       		
					WHILE @@FETCH_STATUS = 0
						BEGIN

							IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'THIS_WEEK_MKT_FCST_CUR')
							BEGIN
								CLOSE THIS_WEEK_MKT_FCST_CUR
								DEALLOCATE THIS_WEEK_MKT_FCST_CUR
							END;
							DECLARE THIS_WEEK_MKT_FCST_CUR CURSOR FAST_FORWARD FOR
												  	   SELECT  A.YYYYMMDD, A.QTY
														 FROM #T_CUTOFF_TODAY_TBL A
														WHERE A.DIVISION_ID     = @v_division_id   
														  AND A.PROJECT_CODE	 = @v_project_code	
														  AND A.SCM_SITE_ID	 = @v_scm_site_id
														  AND A.ITEM_ID		 = @v_item_id	
														  AND A.DOM_EXP		 = @v_dom_exp	
														  AND A.FCST_TYPE		 = @v_fcst_type	
														  AND A.INCOTERMS		 = @v_incoterms		
														  AND A.PLANT_SITE_ID	 = @v_plant_site_id
														  AND A.CELL_PROD_SITE_ID = @v_cell_prod_site_id		-- [PJ2025-50017] 추가
														  AND A.QTY > 0
														ORDER BY YYYYMMDD

							OPEN THIS_WEEK_MKT_FCST_CUR
								-- key 정보는 상위 cursor에서 정의된 값을 같이 쓰면됨.
								FETCH NEXT FROM THIS_WEEK_MKT_FCST_CUR INTO @v_mkt_fcst_yyyymmdd  		,
																			@v_mkt_fcst_qty       		
							WHILE @@FETCH_STATUS = 0
								BEGIN

									IF (@v_qty <=  @v_mkt_fcst_qty ) AND ( @v_qty > 0) -- Demand ID가 전체 다 Full Pegging 되는 case
										BEGIN
											-- UPDATE #T_CUTOFF_TODAY_TBL
											UPDATE #T_CUTOFF_TODAY_TBL
											   SET QTY = @v_mkt_fcst_qty - @v_qty
										 	 WHERE DIVISION_ID       = @v_division_id   
											   AND PROJECT_CODE	     = @v_project_code	
											   AND SCM_SITE_ID	     = @v_scm_site_id
											   AND ITEM_ID		     = @v_item_id	
											   AND DOM_EXP		     = @v_dom_exp	
											   AND FCST_TYPE		 = @v_fcst_type	
											   AND INCOTERMS		 = @v_incoterms		
											   AND PLANT_SITE_ID	 = @v_plant_site_id
											   AND CELL_PROD_SITE_ID = @v_cell_prod_site_id			-- [PJ2025-50017] 추가
											   AND YYYYMMDD          = @v_mkt_fcst_yyyymmdd

											INSERT INTO DM_PLN_DEMANDID_PEGGING
											        ( [DIVISION_ID] ,[DEMAND_ID] ,[VERSION_NO] ,[M_DEMAND_ID] ,[M_VERSION_NO] ,[CHANGE_DATE] ,[DEMAND_CHANGE_TYPE] 
													 ,[PROJECT_CODE] ,[SCM_SITE_ID] ,[ITEM_ID] ,[DOM_EXP] ,[FCST_TYPE] ,[INCOTERMS] 
													 ,[MEASURE] 
													 ,[PLANT_SITE_ID] 
													 ,[CELL_PROD_SITE_ID]				-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
													 ,[YYYYMMDD] ,[M_YYYYMMDD] 
													 ,[CHANGE_REASON] ,[CREATION_WEEK] ,[QTY] ,[CREATED_BY] ,[CREATION_DATE] ,[LAST_UPDATED_BY] ,[LAST_UPDATE_DATE]  )
											SELECT	  @v_division_id ,@v_demand_id ,@v_mkt_fcst_version_no ,@v_demand_id ,@v_last_demandid_version_no ,CONVERT(CHAR(8), @v_target_date, 112) ,CASE WHEN @v_yyyymmdd < CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(@v_target_date, 'MON')), 112) THEN 'CO' ELSE 'MOVE' END
													 ,@v_project_code ,@v_scm_site_id ,@v_item_id ,@v_dom_exp ,@v_fcst_type ,@v_incoterms
													 ,@v_measure_fcst_type				-- [PJ2025-50188] 기준수요 (MKT_FCST / SCM_FCST)
													 ,@v_plant_site_id 
													 ,@v_cell_prod_site_id				-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
													 ,@v_mkt_fcst_yyyymmdd ,@v_yyyymmdd
													 ,'' ,@v_work_week ,@v_qty ,'SYSTEM' ,GETDATE() ,'SYSTEM' ,GETDATE()

											SET @v_qty = 0
										END
									ELSE IF (@v_qty >  @v_mkt_fcst_qty ) AND ( @v_qty > 0) -- Demand ID가 Split이 필요한 Case
									    BEGIN
										    -- UPDATE #T_CUTOFF_TODAY_TBL
											UPDATE #T_CUTOFF_TODAY_TBL
											   SET QTY = 0
										 	 WHERE DIVISION_ID       = @v_division_id   
											   AND PROJECT_CODE	     = @v_project_code	
											   AND SCM_SITE_ID	     = @v_scm_site_id
											   AND ITEM_ID		     = @v_item_id	
											   AND DOM_EXP		     = @v_dom_exp	
											   AND FCST_TYPE		 = @v_fcst_type	
											   AND INCOTERMS		 = @v_incoterms		
											   AND PLANT_SITE_ID	 = @v_plant_site_id
											   AND CELL_PROD_SITE_ID = @v_cell_prod_site_id		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
											   AND YYYYMMDD          = @v_mkt_fcst_yyyymmdd

											SELECT	@v_split_demand_id = 
													LEFT(MAX(DEMAND_ID), 14) + '_' + RIGHT('000' + CONVERT(VARCHAR(03), (CONVERT(INT, MAX( CONVERT(INT, right(DEMAND_ID, charindex('_',reverse(DEMAND_ID))-1)))) + 1)), 3)  --20190110 KHSONG SEQ 2자리 -> 3자리로 변경
											FROM	DM_PLN_DEMANDID_PEGGING WITH(NOLOCK)
											WHERE	LEFT(DEMAND_ID, 14) = LEFT(@v_demand_id, 14)


											INSERT INTO DM_PLN_DEMANDID_PEGGING
											        ( [DIVISION_ID] ,[DEMAND_ID] ,[VERSION_NO] ,[M_DEMAND_ID] ,[M_VERSION_NO] ,[CHANGE_DATE] ,[DEMAND_CHANGE_TYPE] 
													 ,[PROJECT_CODE] ,[SCM_SITE_ID] ,[ITEM_ID] ,[DOM_EXP] ,[FCST_TYPE] ,[INCOTERMS] 
													 ,[MEASURE] 
													 ,[PLANT_SITE_ID] 
													 ,[CELL_PROD_SITE_ID]						-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
													 ,[YYYYMMDD] ,[M_YYYYMMDD] 
													 ,[CHANGE_REASON] ,[CREATION_WEEK] ,[QTY] ,[CREATED_BY] ,[CREATION_DATE] ,[LAST_UPDATED_BY] ,[LAST_UPDATE_DATE]  )
											SELECT	  @v_division_id ,@v_split_demand_id ,@v_mkt_fcst_version_no ,@v_demand_id ,@v_last_demandid_version_no ,CONVERT(CHAR(8), @v_target_date, 112) ,'SMOVE' 
													 ,@v_project_code ,@v_scm_site_id ,@v_item_id ,@v_dom_exp ,@v_fcst_type ,@v_incoterms 
													 ,@v_measure_fcst_type						-- [PJ2025-50188] 기준수요 (MKT_FCST / SCM_FCST)
													 ,@v_plant_site_id 
													 ,@v_cell_prod_site_id 						-- [PJ2025-50017] CELL_PROD_SITE_ID 추가									 
													 ,@v_mkt_fcst_yyyymmdd ,@v_yyyymmdd
													 ,'' ,@v_work_week ,@v_mkt_fcst_qty ,'SYSTEM' ,GETDATE() ,'SYSTEM' ,GETDATE()

											SET @v_qty = @v_qty - @v_mkt_fcst_qty
										END

								FETCH NEXT FROM THIS_WEEK_MKT_FCST_CUR INTO @v_mkt_fcst_yyyymmdd  		,
																			@v_mkt_fcst_qty   	
								END
							CLOSE THIS_WEEK_MKT_FCST_CUR
							DEALLOCATE THIS_WEEK_MKT_FCST_CUR

						FETCH NEXT FROM LAST_WEEK_DEMANDID_CUR INTO @v_demand_id		,
																    @v_yyyymmdd  		,
																    @v_qty       		
						END
					CLOSE LAST_WEEK_DEMANDID_CUR
					DEALLOCATE LAST_WEEK_DEMANDID_CUR


			FETCH NEXT FROM PEGGING_TARGET_CUR INTO @v_division_id		,
													@v_project_code		,
													@v_scm_site_id		,
													@v_item_id			,
													@v_dom_exp			,
													@v_fcst_type		,
													@v_incoterms		,
													@v_plant_site_id	,
													@v_cell_prod_site_id				-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			END
		CLOSE PEGGING_TARGET_CUR
		DEALLOCATE PEGGING_TARGET_CUR


		INSERT INTO DM_PLN_DEMANDID_PEGGING 
				( [DIVISION_ID] ,[DEMAND_ID] ,[VERSION_NO] ,[M_DEMAND_ID] ,[M_VERSION_NO] ,[CHANGE_DATE] ,[DEMAND_CHANGE_TYPE] 
					,[PROJECT_CODE] ,[SCM_SITE_ID] ,[ITEM_ID] ,[DOM_EXP] ,[FCST_TYPE] ,[INCOTERMS] 
					,[MEASURE] 
					,[PLANT_SITE_ID] 
					,[CELL_PROD_SITE_ID]				-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					,[YYYYMMDD] ,[M_YYYYMMDD] 
					,[CHANGE_REASON] ,[CREATION_WEEK] ,[QTY] ,[CREATED_BY] ,[CREATION_DATE] ,[LAST_UPDATED_BY] ,[LAST_UPDATE_DATE]  )
		SELECT  division_id 
				,CONVERT( VARCHAR(08), DATEADD ( DD, 0, CAST( CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(@v_target_date, 'MON')), 112) AS DATETIME) ), 112) + '_' + RIGHT('00000' + cast(row_number() over ( order by yyyymmdd) as varchar) , 5) + '_000'
				,@v_mkt_fcst_version_no 
				,CONVERT( VARCHAR(08), DATEADD ( DD, 0, CAST( CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(@v_target_date, 'MON')), 112) AS DATETIME) ), 112) + '_' + RIGHT('00000' + cast(row_number() over ( order by yyyymmdd) as varchar) , 5) + '_000'
				,@v_mkt_fcst_version_no ,CONVERT(CHAR(8), @v_target_date, 112) ,'NEW' 
				,project_code ,scm_site_id ,item_id ,dom_exp ,fcst_type ,incoterms 
				,@v_measure_fcst_type					-- [PJ2025-50188] 기준수요 (MKT_FCST / SCM_FCST)
				,plant_site_id 
				,cell_prod_site_id						-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				,yyyymmdd ,yyyymmdd
				,'' ,@v_work_week ,qty ,'SYSTEM' ,GETDATE() ,'SYSTEM' ,GETDATE() 
			FROM (
					SELECT division_id 
							,project_code ,scm_site_id ,item_id ,dom_exp ,fcst_type ,incoterms 
							,plant_site_id 
							,cell_prod_site_id			-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
							,yyyymmdd ,qty
						from #T_CUTOFF_TODAY_TBL
						where qty > 0 
						UNION ALL
	 				SELECT division_id 
							,project_code ,scm_site_id ,item_id ,dom_exp ,fcst_type ,incoterms 
							,plant_site_id 
							,cell_prod_site_id			-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
							,yyyymmdd ,qty
						FROM #T_MKT_FCST$	 A WITH(NOLOCK)
						WHERE A.DIVISION_ID = @p_division_id
						AND A.CUTOFF_TYPE = @v_cutoff_version_type					-- [PJ2025-50188] 기준수요 (MF_W / SF_W)
						AND A.MEASURE     = @v_measure_fcst_type						-- [PJ2025-50188] 기준수요 (MKT_FCST / SCM_FCST)
						AND A.VERSION_NO    = @v_mkt_fcst_version_no  -- max version_no
						and A.YYYYMMDD    >= CONVERT(VARCHAR(08), DATEADD(WW, 10, DBO.FN_NEXT_DAY(@v_target_date, 'MON')), 112) -- Demand Pegging 정보를 만들기 위한 구간.
						and A.YYYYMMDD    <  CONVERT(VARCHAR(08), DATEADD(WW, 11, DBO.FN_NEXT_DAY(@v_target_date, 'MON')), 112) -- Demand Pegging 정보를 만들기 위한 구간.
				) ZZ



		IF  OBJECT_ID(N'tempdb..#T_CUTOFF_TODAY_TBL', N'U') IS NOT NULL 
  				     DROP TABLE #T_CUTOFF_TODAY_TBL   ;

		IF  OBJECT_ID(N'tempdb..#T_BF_WEEK_TBL', N'U') IS NOT NULL 
  				     DROP TABLE #T_BF_WEEK_TBL   ;

		IF  OBJECT_ID(N'tempdb..#T_RESULT_BASIS_YYYYMMDD_TBL', N'U') IS NOT NULL 
  				     DROP TABLE #T_RESULT_BASIS_YYYYMMDD_TBL   ;

		-- [PJ2025-50188] #T_MKT_FCST$ 임시테이블 시작/끝 부분에 DROP 기능 추가
		IF  OBJECT_ID(N'tempdb..#T_MKT_FCST$', N'U') IS NOT NULL		
  				     DROP TABLE #T_MKT_FCST$   ;

        COMMIT TRAN ;	


		-- 20181004 KHSONG PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM 호출 추가
		EXEC [PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM] @p_division_id ; 

	-----------------------------------------------------------------------------------------
	END TRY
	-----------------------------------------------------------------------------------------
	
	-- ERROR
	BEGIN CATCH
		ROLLBACK TRAN ;

		--CLOSE PEGGING_IN_CUR
		--DEALLOCATE PEGGING_IN_CUR

		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'PEGGING_OUT_CUR')
		BEGIN
			CLOSE PEGGING_OUT_CUR
			DEALLOCATE PEGGING_OUT_CUR
		END;

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT ERROR_MESSAGE()

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END CATCH

	SET NOCOUNT OFF;

	/*
		-----------------------------------------------------------------------------------------
			: END LOG
		-----------------------------------------------------------------------------------------
	*/

    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END

