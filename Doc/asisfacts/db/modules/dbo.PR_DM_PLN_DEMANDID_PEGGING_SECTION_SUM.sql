






/*
 * Program ID   : PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM
 * Description  : Demand ID 생성으로 FCST 변경이력추적 및 원인을 파악하기 위해서
 * Program History
 *===================================================================================================
 *   Date           In Charge      Description
 *===================================================================================================
 * 2018. 04. 19     JHBAEK			불변구간(고객인도 ~ 출하 4주전), 확정구간(출하5주전 ~ 출하10주전) FCST 구하기
 * 2025. 02. 05		KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선
 * 2025. 05. 07		KANG.H.J		[PJ2025-50188] 기준수요 (SCM_FCST 기반 NET_DEMAND 생성)
 * 2025. 05. 14		KANG.H.J		[PJ2025-50188] DM_PLN_NET_DEMAND 생성 기준을 가장 최근의 버젼을 기반으로 생성하도록 정의

	EXEC [PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM] '81'
	EXEC [PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM] '82'

 */
 
CREATE PROCEDURE [dbo].[PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM]
   @p_division_id				NVARCHAR(60)

AS  

BEGIN

	SET NOCOUNT ON; 

	-- CURSOR RETURN VALUE
	DECLARE	@v_division_id				NVARCHAR(60)
	DECLARE	@v_VERSION_NO				NVARCHAR(50)
	DECLARE	@v_project_code				NVARCHAR(100)
	DECLARE	@v_scm_site_id				NVARCHAR(60)
	DECLARE	@v_item_id					NVARCHAR(100)
	DECLARE	@v_dom_exp					NVARCHAR(6)
	DECLARE	@v_fcst_type				NVARCHAR(40)
	DECLARE	@v_incoterms				NVARCHAR(20)
	DECLARE	@v_measure					NVARCHAR(100)
	DECLARE	@v_plant_site_id			NVARCHAR(60)
	DECLARE	@v_cell_prod_site_id		NVARCHAR(60)				-- [PJ2025-50017] 추가

	DECLARE @v_section1_01				NUMERIC(20, 10)		
	DECLARE @v_section1_02				NUMERIC(20, 10)		
	DECLARE @v_section1_03				NUMERIC(20, 10)		
	DECLARE @v_section1_04				NUMERIC(20, 10)		
	DECLARE @v_section1_05				NUMERIC(20, 10)		
	DECLARE @v_section1_06_01			NUMERIC(20, 10)		
	DECLARE @v_section1_06_02			NUMERIC(20, 10)	
	DECLARE @v_section1_07_01			NUMERIC(20, 10)		
	DECLARE @v_section1_07_02			NUMERIC(20, 10)		
															
	DECLARE @v_section2_01				NUMERIC(20, 10)		
	DECLARE @v_section2_02				NUMERIC(20, 10)		
	DECLARE @v_section2_03				NUMERIC(20, 10)		
	DECLARE @v_section2_04				NUMERIC(20, 10)		
	DECLARE @v_section2_05				NUMERIC(20, 10)		
	DECLARE @v_section2_06_01			NUMERIC(20, 10)		
	DECLARE @v_section2_06_02			NUMERIC(20, 10)		
	DECLARE @v_section2_07_01			NUMERIC(20, 10)	
	DECLARE @v_section2_07_02			NUMERIC(20, 10)	

	DECLARE @v_section3_01				NUMERIC(20, 10)		
	DECLARE @v_section3_02				NUMERIC(20, 10)		
	DECLARE @v_section3_03				NUMERIC(20, 10)		
	DECLARE @v_section3_04				NUMERIC(20, 10)		
	DECLARE @v_section3_05				NUMERIC(20, 10)		
	DECLARE @v_section3_06_01			NUMERIC(20, 10)		
	DECLARE @v_section3_06_02			NUMERIC(20, 10)		
	DECLARE @v_section3_07_01			NUMERIC(20, 10)	
	DECLARE @v_section3_07_02			NUMERIC(20, 10)	

	DECLARE @v_bf_week					NVARCHAR(08)				-- 전주차정보
	DECLARE @v_work_week				NVARCHAR(08)				-- 작업주차정보

	-- [PJ2025-50188] 기준수요 (SCM_FCST 기반 NET_DEMAND 생성) Start
    DECLARE @v_cutoff_version_type		NVARCHAR(10);			-- [PJ2025-50188] MF_W / SF_W
    DECLARE @v_measure_fcst_type		NVARCHAR(10);			-- [PJ2025-50188] MKT_FCST / SCM_FCST
	-- [PJ2025-50188] 기준수요 (SCM_FCST 기반 NET_DEMAND 생성) End

	-- 임시 테이블 생성
	
		--[C20200909-000203] LOG 표준화 적용
		-- LOG 용 변수 설정
		DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
		DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_DEMANDID_PEGGING_SECTION_SUM';
		DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
		DECLARE @n_log_count    INTEGER = 0;
		DECLARE @v_log_message  NVARCHAR(1000);
		DECLARE @v_description  NVARCHAR(500);
		DECLARE @d_event_date   DATETIME;
		DECLARE @v_ifseqno      NVARCHAR(30); 
		DECLARE @n_history_seq  BIGINT;

		-- 시작 LOG
		SET @v_log_type    = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date  = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        BEGIN TRY

	CREATE TABLE #T_PEGGING_TBL(
			DIVISION_ID			NVARCHAR(60)				,
			VERSION_NO			NVARCHAR(50)				,
			PROJECT_CODE		NVARCHAR(100)				,	
			SCM_SITE_ID			NVARCHAR(60)				,			
			ITEM_ID				NVARCHAR(100)				,			
			DOM_EXP				NVARCHAR(6)					,			
			FCST_TYPE			NVARCHAR(40)				,
			INCOTERMS			NVARCHAR(20)				,
			MEASURE				NVARCHAR(100)				,
			PLANT_SITE_ID		NVARCHAR(60)				,
			CELL_PROD_SITE_ID	NVARCHAR(60)							-- [PJ2025-50017] 추가
	)	

	CREATE TABLE #T_RESULT_TBL(
			DIVISION_ID			NVARCHAR(60)				,	
			VERSION_NO			NVARCHAR(50)				,	
			PROJECT_CODE		NVARCHAR(100)				,	
			SCM_SITE_ID			NVARCHAR(60)				,			
			ITEM_ID				NVARCHAR(100)				,			
			DOM_EXP				NVARCHAR(6)					,			
			FCST_TYPE			NVARCHAR(40)				,
			INCOTERMS			NVARCHAR(20)				,
			MEASURE				NVARCHAR(100)				,
			PLANT_SITE_ID		NVARCHAR(60)				,
			CELL_PROD_SITE_ID	NVARCHAR(60)				,			-- [PJ2025-50017] 추가
			S1_BF_WK_FCST		NUMERIC(20, 10)				,			-- 불변구간, 전주 FCST
			S1_NOW_WK_FCST		NUMERIC(20, 10)				,			-- 불변구간, 당주 FCST
			S1_CO_FCST			NUMERIC(20, 10)				,			-- 불변구간, 이월
			S1_NEW_FCST			NUMERIC(20, 10)				,			-- 불변구간, 신규/증량
			S1_DEL_FCST			NUMERIC(20, 10)				,			-- 불변구간, 삭제/감량
			S1_WK_MV_FCST_PRE	NUMERIC(20, 10)				,			-- 불변구간, 주차이동(선행)
			S1_WK_MV_FCST_POST	NUMERIC(20, 10)				,			-- 불변구간, 주차이동(후행)
			S1_DAY_MV_FCST_PRE	NUMERIC(20, 10)				,			-- 불변구간, 일자이동(선행)
			S1_DAY_MV_FCST_POST	NUMERIC(20, 10)				,			-- 불변구간, 일자이동(후행)
			S2_BF_WK_FCST		NUMERIC(20, 10)				,			-- 확정구간, 전주 FCST
			S2_NOW_WK_FCST		NUMERIC(20, 10)				,			-- 확정구간, 당주 FCST
			S2_CO_FCST			NUMERIC(20, 10)				,			-- 확정구간, 이월
			S2_NEW_FCST			NUMERIC(20, 10)				,			-- 확정구간, 신규/증량
			S2_DEL_FCST			NUMERIC(20, 10)				,			-- 확정구간, 삭제/감량
			S2_WK_MV_FCST_PRE	NUMERIC(20, 10)				,			-- 확정구간, 주차이동(선행)
			S2_WK_MV_FCST_POST	NUMERIC(20, 10)				,			-- 확정구간, 주차이동(선행)
			S2_DAY_MV_FCST_PRE	NUMERIC(20, 10)				,			-- 확정구간, 일자이동(후행)		
			S2_DAY_MV_FCST_POST	NUMERIC(20, 10)				,			-- 확정구간, 일자이동(후행)		
			S3_BF_WK_FCST		NUMERIC(20, 10)				,			-- 확정구간, 전주 FCST
			S3_NOW_WK_FCST		NUMERIC(20, 10)				,			-- 확정구간, 당주 FCST
			S3_CO_FCST			NUMERIC(20, 10)				,			-- 확정구간, 이월
			S3_NEW_FCST			NUMERIC(20, 10)				,			-- 확정구간, 신규/증량
			S3_DEL_FCST			NUMERIC(20, 10)				,			-- 확정구간, 삭제/감량
			S3_WK_MV_FCST_PRE	NUMERIC(20, 10)				,			-- 확정구간, 주차이동(선행)
			S3_WK_MV_FCST_POST	NUMERIC(20, 10)				,			-- 확정구간, 주차이동(선행)
			S3_DAY_MV_FCST_PRE	NUMERIC(20, 10)				,			-- 확정구간, 일자이동(후행)		
			S3_DAY_MV_FCST_POST	NUMERIC(20, 10)							-- 확정구간, 일자이동(후행)	
	)	

	-- 주차정보 설정
	SELECT	@v_bf_week = ISO_YYYYWW
		FROM  SCM_SYS_CALENDAR_M WITH(NOLOCK)
		WHERE	BASIS_YYYYMMDD = CONVERT(VARCHAR(08), DATEADD(WW, -2, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 

	SELECT	@v_work_week = ISO_YYYYWW
		FROM  SCM_SYS_CALENDAR_M WITH(NOLOCK)
		WHERE	BASIS_YYYYMMDD = CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)	

	-- DIVISION 설정
	SET	@v_division_id = @p_division_id

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
	-- [PJ2025-50188] LOOKUP 기반 CUTOFF_TYPE, MEASURE(MKT_FCST/SCM_FCST) 선택 End
*/		-- [PJ2025-50188] 삭제... 전주 또는 당주 버젼 체크하는 로직이 변경이 되어 삭제함. End

		-- [PJ2025-50188] DM_PLN_NET_DEMAND 생성 기준을 가장 최근의 버젼을 기반으로 생성하도록 정의 Start
		BEGIN
			-- [PJ2025-50188] 전주 기준의 VERSION_NO / CUTOFF_TYPE / MEASURE 정의
			SELECT TOP 1
				   @v_cutoff_version_type	= A.VERSION_TYPE		-- [PJ2025-50188] ㅡMF_W / SF_W
				 , @v_measure_fcst_type		= CASE WHEN A.VERSION_TYPE = 'MF_W' THEN 'MKT_FCST' 
												   WHEN A.VERSION_TYPE = 'SF_W' THEN 'SCM_FCST' 
											  ELSE '' END										
			FROM 
			(
--				SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, CREATION_DATE, RANK() OVER (ORDER BY CREATION_DATE DESC, YYYYMMDD DESC, VER_CRE_SEQ DESC) AS RN	-- [PJ2025-50188] 가장 최근의 버젼
				SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, CREATION_DATE, RANK() OVER (ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC, VERSION_TYPE DESC) AS RN	-- [PJ2025-50188] 가장 최근의 버젼. SF_W가 MF_W보다 우선함.
				FROM DM_MST_VERSION WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND   VERSION_TYPE IN ('MF_W', 'SF_W')
			) A
			WHERE RN = 1;

		END
		-- [PJ2025-50188] DM_PLN_NET_DEMAND 생성 기준을 가장 최근의 버젼을 기반으로 생성하도록 정의 End


		 
	-- 자료 INSERT
	INSERT INTO #T_PEGGING_TBL
	 	SELECT	DISTINCT 
				 A.[DIVISION_ID]
				,A.VERSION_NO
				,A.[PROJECT_CODE]
				,A.[SCM_SITE_ID]
				,A.[ITEM_ID]
				,A.[DOM_EXP]
				,A.[FCST_TYPE]
				,A.[INCOTERMS]
				,A.[MEASURE]
				,A.[PLANT_SITE_ID]
				,A.[CELL_PROD_SITE_ID]								-- [PJ2025-50017] 추가
		FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
		WHERE	1 = 1
		--AND		A.MEASURE		= 'MKT_FCST'
		AND		A.MEASURE		= @v_measure_fcst_type				-- [PJ2025-50188] (MKT_FCST / SCM_FCST)
		AND		A.CREATION_WEEK	= @v_work_week
		AND		A.DIVISION_ID     LIKE '%' + @p_division_id + '%'
			--AND  A.DIVISION_ID     LIKE '%' + '81' + '%'

		-- 커서 사용
		DECLARE PEGGING_OUT_CUR CURSOR FAST_FORWARD FOR
											SELECT   DISTINCT					-- 계산의 대상이 되는 주차. 전주테이블에서 기준이 되는 정보를 가지고 온다. MAX(VERSION_NO)
													 A.DIVISION_ID		
													,A.VERSION_NO
													,A.PROJECT_CODE		
													,A.SCM_SITE_ID		
													,A.ITEM_ID			
													,A.DOM_EXP			
													,A.FCST_TYPE		
													,A.INCOTERMS		
													,A.MEASURE			
													,A.PLANT_SITE_ID
													,A.CELL_PROD_SITE_ID			-- [PJ2025-50017] 추가
											FROM    #T_PEGGING_TBL A
											WHERE   1 = 1

				--AND  DIVISION_ID = '81'
				--AND  PROJECT_CODE = 'D17PS0001'
				--AND  SCM_SITE_ID = 'ESS_KR_OCH'
				--AND  ITEM_ID = 'ECP0640N5-04'
				--AND  DOM_EXP = 'E'
				--AND  FCST_TYPE = 'MPS'
				--AND  INCOTERMS = 'Z01'
				--AND MEASURE			= 'MKT_FCST'
				--AND	PLANT_SITE_ID	= 'A040-A'

				--AND  DIVISION_ID = '81'
				--AND  PROJECT_CODE = 'A15AI4002'
				--AND  SCM_SITE_ID = 'Audi_DE_ING'
				--AND  ITEM_ID = 'AMVAGBEVM-A4-C01'
				--AND  DOM_EXP = 'E'
				--AND  FCST_TYPE = 'SDC'
				--AND  INCOTERMS = 'Z01'
				--AND MEASURE			= 'MKT_FCST'
				--AND	PLANT_SITE_ID	= 'G481-P'

				--AND  DIVISION_ID = '81'
				--AND  PROJECT_CODE = 'A15AI4002'
				--AND  SCM_SITE_ID = 'Audi_DE_ING'
				--AND  ITEM_ID = 'AMVAGBEVN-A4-C01'
				--AND  DOM_EXP = 'E'
				--AND  FCST_TYPE = 'SDC'
				--AND  INCOTERMS = 'Z01'
				--AND MEASURE			= 'MKT_FCST'
				--AND	PLANT_SITE_ID	= 'G481-P'

				--AND  DIVISION_ID = '81'
				--AND  PROJECT_CODE = 'A15PE7001'
				--AND  SCM_SITE_ID = 'Porsche_SK_BTS'
				--AND  ITEM_ID = 'APPAG12V0-A3-C06'
				--AND  DOM_EXP = 'E'
				--AND  FCST_TYPE = 'MPS'
				--AND  INCOTERMS = 'DAP'
				--AND MEASURE			= 'MKT_FCST'
				--AND	PLANT_SITE_ID	= 'A040-P'

							 
		OPEN PEGGING_OUT_CUR
		FETCH NEXT FROM PEGGING_OUT_CUR INTO    @v_division_id		,
												@v_VERSION_NO		,
												@v_project_code		,
												@v_scm_site_id		,
												@v_item_id			,
												@v_dom_exp			,
												@v_fcst_type		,
												@v_incoterms		,
												@v_measure			,
												@v_plant_site_id	,
												@v_cell_prod_site_id				-- [PJ2025-50017] 추가
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- 초기값 설정
			SET @v_section1_01		= 0					
			SET @v_section1_02		= 0					
			SET @v_section1_03		= 0					
			SET @v_section1_04		= 0					
			SET @v_section1_05		= 0					
			SET @v_section1_06_01	= 0					
			SET @v_section1_06_02	= 0				
			SET @v_section1_07_01	= 0		
			SET @v_section1_07_02	= 0				

			SET @v_section2_01		= 0					
			SET @v_section2_02		= 0					
			SET @v_section2_03		= 0					
			SET @v_section2_04		= 0					
			SET @v_section2_05		= 0					
			SET @v_section2_06_01	= 0			
			SET @v_section2_06_02	= 0				
			SET @v_section2_07_01	= 0
			SET @v_section2_07_02	= 0

			/* 1. 불변구간(고객인도 ~ 출하6주전) FCST 구하기 */--------------------★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★BEGIN
			-- 1-1. 전주 FCST
			SELECT		@v_section1_01 = ISNULL(SUM(ISNULL(QTY, 0)), 0)
				FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
				WHERE	1 =1 
				AND     DIVISION_ID     = @v_division_id
				AND		PROJECT_CODE	= @v_project_code
				AND		SCM_SITE_ID		= @v_scm_site_id
				AND		ITEM_ID			= @v_item_id
				AND		DOM_EXP			= @v_dom_exp
				AND		FCST_TYPE		= @v_fcst_type
				AND		INCOTERMS		= @v_incoterms
				AND		MEASURE			= @v_measure
				AND		PLANT_SITE_ID	= @v_plant_site_id
				AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= @v_bf_week				-- 전주차 CUTOFF
				AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD,-7 * 1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)

			-- 1-2.  당주 FCST
			SELECT		@v_section1_02 = ISNULL(SUM(ISNULL(QTY, 0)), 0)
				FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
				WHERE	1 =1 
				AND     DIVISION_ID     = @v_division_id
				AND		PROJECT_CODE	= @v_project_code
				AND		SCM_SITE_ID		= @v_scm_site_id
				AND		ITEM_ID			= @v_item_id
				AND		DOM_EXP			= @v_dom_exp
				AND		FCST_TYPE		= @v_fcst_type
				AND		INCOTERMS		= @v_incoterms
				AND		MEASURE			= @v_measure
				AND		PLANT_SITE_ID	= @v_plant_site_id
				AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
				AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7 * 1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
				--ORDER BY M_DEMAND_ID

			-- 2. 이월
			SELECT		@v_section1_03 = ISNULL(SUM(ISNULL(QTY, 0)), 0)
				FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
				WHERE	1 =1 
				AND     DIVISION_ID     = @v_division_id
				AND		PROJECT_CODE	= @v_project_code
				AND		SCM_SITE_ID		= @v_scm_site_id
				AND		ITEM_ID			= @v_item_id
				AND		DOM_EXP			= @v_dom_exp
				AND		FCST_TYPE		= @v_fcst_type
				AND		INCOTERMS		= @v_incoterms
				AND		MEASURE			= @v_measure
				AND		PLANT_SITE_ID	= @v_plant_site_id
				AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
				AND		DEMAND_CHANGE_TYPE = 'CO'
				AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7 * 1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)


			-- 3. 신규/증량
			SELECT		@v_section1_04 = ISNULL(SUM(QTY), 0)
				FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
				WHERE	1 =1 
				AND     DIVISION_ID     = @v_division_id
				AND		PROJECT_CODE	= @v_project_code
				AND		SCM_SITE_ID		= @v_scm_site_id
				AND		ITEM_ID			= @v_item_id
				AND		DOM_EXP			= @v_dom_exp
				AND		FCST_TYPE		= @v_fcst_type
				AND		INCOTERMS		= @v_incoterms
				AND		MEASURE			= @v_measure
				AND		PLANT_SITE_ID	= @v_plant_site_id
				AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
				AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7 * 1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
				AND     A.DEMAND_CHANGE_TYPE = 'NEW'

			-- 4. 삭제/감량(기간을 전주 CUTOFF로 보아야 한다.)
			SELECT	@v_section1_05 = ISNULL(SUM(R1.QTY), 0) - ISNULL(SUM(R2.QTY), 0)
				FROM	(
							SELECT	DEMAND_ID, 
									QTY
							FROM	DM_PLN_DEMANDID_PEGGING WITH(NOLOCK)
							WHERE	1 =1 
							AND     DIVISION_ID     = @v_division_id
							AND		PROJECT_CODE	= @v_project_code
							AND		SCM_SITE_ID		= @v_scm_site_id
							AND		ITEM_ID			= @v_item_id
							AND		DOM_EXP			= @v_dom_exp
							AND		FCST_TYPE		= @v_fcst_type
							AND		INCOTERMS		= @v_incoterms
							AND		MEASURE			= @v_measure
							AND		PLANT_SITE_ID	= @v_plant_site_id
							AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= @v_bf_week				-- 전주차 CUTOFF
							AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7 * 1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
							AND     DEMAND_CHANGE_TYPE <> 'CO'	
							) R1 LEFT OUTER JOIN
												(
												SELECT	A.DEMAND_ID		,
														B.QTY			
													FROM
													(
														SELECT	DEMAND_ID, 
																QTY
														FROM	DM_PLN_DEMANDID_PEGGING WITH(NOLOCK)
														WHERE	1 =1 
														AND     DIVISION_ID     = @v_division_id
														AND		PROJECT_CODE	= @v_project_code
														AND		SCM_SITE_ID		= @v_scm_site_id
														AND		ITEM_ID			= @v_item_id
														AND		DOM_EXP			= @v_dom_exp
														AND		FCST_TYPE		= @v_fcst_type
														AND		INCOTERMS		= @v_incoterms
														AND		MEASURE			= @v_measure
														AND		PLANT_SITE_ID	= @v_plant_site_id
														AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
														AND		CREATION_WEEK	= @v_bf_week				-- 전주차 CUTOFF
														AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7 * 1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
														AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
														AND     DEMAND_CHANGE_TYPE <> 'CO'	
													) A INNER JOIN 
													(
														SELECT	M_DEMAND_ID, SUM(QTY) QTY
														FROM	DM_PLN_DEMANDID_PEGGING WITH(NOLOCK)
														WHERE	1 =1 
														AND     DIVISION_ID     = @v_division_id
														AND		PROJECT_CODE	= @v_project_code
														AND		SCM_SITE_ID		= @v_scm_site_id
														AND		ITEM_ID			= @v_item_id
														AND		DOM_EXP			= @v_dom_exp
														AND		FCST_TYPE		= @v_fcst_type
														AND		INCOTERMS		= @v_incoterms
														AND		MEASURE			= @v_measure
														AND		PLANT_SITE_ID	= @v_plant_site_id
														AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
														AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
														AND     DEMAND_CHANGE_TYPE <> 'CO'
														GROUP BY M_DEMAND_ID
													) B ON A.DEMAND_ID = B.M_DEMAND_ID
												) R2 ON R1.DEMAND_ID = R2.DEMAND_ID 

						
			-- 5-1. 주차이동(선행)
			SELECT	@v_section1_06_01 = ISNULL(SUM(R.QTY), 0)
			  FROM  (
					SELECT	A.DEMAND_ID 
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW	
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK) INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
																   INNER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1 
							AND     DIVISION_ID     = @v_division_id
							AND		PROJECT_CODE	= @v_project_code
							AND		SCM_SITE_ID		= @v_scm_site_id
							AND		ITEM_ID			= @v_item_id
							AND		DOM_EXP			= @v_dom_exp
							AND		FCST_TYPE		= @v_fcst_type
							AND		INCOTERMS		= @v_incoterms
							AND		MEASURE			= @v_measure
							AND		PLANT_SITE_ID	= @v_plant_site_id
							AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7 * 1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					) R
			WHERE	R.ISO_YYYYWW  <> R.ISO_M_YYYYWW
			  AND   R.ISO_YYYYWW   < R.ISO_M_YYYYWW 					-- 이전날자로 이동한 경우

			-- 5-2. 주차이동(후행)
			SELECT	@v_section1_06_02 = ISNULL(SUM(R.QTY), 0)
			  FROM  (
					SELECT	A.DEMAND_ID 
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW	
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK) INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1 
							AND     DIVISION_ID     = @v_division_id
							AND		PROJECT_CODE	= @v_project_code
							AND		SCM_SITE_ID		= @v_scm_site_id
							AND		ITEM_ID			= @v_item_id
							AND		DOM_EXP			= @v_dom_exp
							AND		FCST_TYPE		= @v_fcst_type
							AND		INCOTERMS		= @v_incoterms
							AND		MEASURE			= @v_measure
							AND		PLANT_SITE_ID	= @v_plant_site_id
							AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7 * 1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					) R
			WHERE	R.ISO_YYYYWW  <> R.ISO_M_YYYYWW
			  AND   R.ISO_YYYYWW   > R.ISO_M_YYYYWW 				-- 이후날자로 이동한 경우

			-- 6-1. 일자이동(선행)
			SELECT	@v_section1_07_01 = ISNULL(SUM(R.QTY), 0)
			  FROM  (
					SELECT	A.DEMAND_ID 
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW	
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK) INNER JOIN SCM_SYS_CALENDAR_M B  WITH(NOLOCK) ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C  WITH(NOLOCK) ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1 
							AND     DIVISION_ID     = @v_division_id
							AND		PROJECT_CODE	= @v_project_code
							AND		SCM_SITE_ID		= @v_scm_site_id
							AND		ITEM_ID			= @v_item_id
							AND		DOM_EXP			= @v_dom_exp
							AND		FCST_TYPE		= @v_fcst_type
							AND		INCOTERMS		= @v_incoterms
							AND		MEASURE			= @v_measure
							AND		PLANT_SITE_ID	= @v_plant_site_id
							AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7 * 1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					) R
			WHERE	R.ISO_YYYYWW = R.ISO_M_YYYYWW
			  AND   R.YYYYMMDD  <> R.M_YYYYMMDD
			  AND   R.YYYYMMDD   < R.M_YYYYMMDD

			-- 6-2. 일자이동(후행)
			SELECT	@v_section1_07_02 = ISNULL(SUM(R.QTY), 0)
			  FROM  (
					SELECT	A.DEMAND_ID 
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW	
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK) INNER JOIN SCM_SYS_CALENDAR_M B  WITH(NOLOCK) ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C  WITH(NOLOCK) ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1 
							AND     DIVISION_ID     = @v_division_id
							AND		PROJECT_CODE	= @v_project_code
							AND		SCM_SITE_ID		= @v_scm_site_id
							AND		ITEM_ID			= @v_item_id
							AND		DOM_EXP			= @v_dom_exp
							AND		FCST_TYPE		= @v_fcst_type
							AND		INCOTERMS		= @v_incoterms
							AND		MEASURE			= @v_measure
							AND		PLANT_SITE_ID	= @v_plant_site_id
							AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7 * 1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					) R
			WHERE	R.ISO_YYYYWW = R.ISO_M_YYYYWW
			  AND   R.YYYYMMDD  <> R.M_YYYYMMDD
			  AND   R.YYYYMMDD   > R.M_YYYYMMDD
			/* 1. 불변구간(고객인도 ~ 출하6주전) FCST 구하기 */--------------------★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★END

			/* 2. 확정구간(출하7주전 ~ 출하11주전) FCST 구하기 */------------------★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★BEGIN
			-- 1-1. 확정구간 전주 FCST
			SELECT		@v_section2_01 = ISNULL(SUM(ISNULL(QTY, 0)), 0)
				FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
				WHERE	1 =1 
				AND     DIVISION_ID     = @v_division_id
				AND		PROJECT_CODE	= @v_project_code
				AND		SCM_SITE_ID		= @v_scm_site_id
				AND		ITEM_ID			= @v_item_id
				AND		DOM_EXP			= @v_dom_exp
				AND		FCST_TYPE		= @v_fcst_type
				AND		INCOTERMS		= @v_incoterms
				AND		MEASURE			= @v_measure
				AND		PLANT_SITE_ID	= @v_plant_site_id
				AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= @v_bf_week				-- 전주차 CUTOFF
				AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)

			-- 1-2. 확정구간 당주 FCST
			SELECT		@v_section2_02 = ISNULL(SUM(ISNULL(QTY, 0)), 0)
				FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
				WHERE	1 =1 
				AND     DIVISION_ID     = @v_division_id
				AND		PROJECT_CODE	= @v_project_code
				AND		SCM_SITE_ID		= @v_scm_site_id
				AND		ITEM_ID			= @v_item_id
				AND		DOM_EXP			= @v_dom_exp
				AND		FCST_TYPE		= @v_fcst_type
				AND		INCOTERMS		= @v_incoterms
				AND		MEASURE			= @v_measure
				AND		PLANT_SITE_ID	= @v_plant_site_id
				AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
				AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 *10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
				--ORDER BY M_DEMAND_ID

			-- 2. 이월
			SELECT		@v_section2_03 = ISNULL(SUM(ISNULL(QTY, 0)), 0)
				FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
				WHERE	1 =1 
				AND     DIVISION_ID     = @v_division_id
				AND		PROJECT_CODE	= @v_project_code
				AND		SCM_SITE_ID		= @v_scm_site_id
				AND		ITEM_ID			= @v_item_id
				AND		DOM_EXP			= @v_dom_exp
				AND		FCST_TYPE		= @v_fcst_type
				AND		INCOTERMS		= @v_incoterms
				AND		MEASURE			= @v_measure
				AND		PLANT_SITE_ID	= @v_plant_site_id
				AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
				AND		DEMAND_CHANGE_TYPE = 'CO'
				AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)

			-- 3. 신규/증량
			SELECT		@v_section2_04 = ISNULL(SUM(QTY), 0)
				FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
				WHERE	1 =1 
				AND     DIVISION_ID     = @v_division_id
				AND		PROJECT_CODE	= @v_project_code
				AND		SCM_SITE_ID		= @v_scm_site_id
				AND		ITEM_ID			= @v_item_id
				AND		DOM_EXP			= @v_dom_exp
				AND		FCST_TYPE		= @v_fcst_type
				AND		INCOTERMS		= @v_incoterms
				AND		MEASURE			= @v_measure
				AND		PLANT_SITE_ID	= @v_plant_site_id
				AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
				AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
				AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
				AND		A.DEMAND_CHANGE_TYPE <> 'CO'				-- 이월을 제외하고
				AND     A.DEMAND_CHANGE_TYPE = 'NEW'
				--GROUP BY LEFT(DEMAND_ID, 14)


			-- 4. 삭제/감량(기간을 전주 CUTOFF로 보아야 한다.)
			SELECT	@v_section2_05 = ISNULL(SUM(R1.QTY), 0) - ISNULL(SUM(R2.QTY), 0)
				FROM	(
							SELECT	DEMAND_ID, 
									QTY
							FROM	DM_PLN_DEMANDID_PEGGING WITH(NOLOCK)
							WHERE	1 =1 
							AND     DIVISION_ID     = @v_division_id
							AND		PROJECT_CODE	= @v_project_code
							AND		SCM_SITE_ID		= @v_scm_site_id
							AND		ITEM_ID			= @v_item_id
							AND		DOM_EXP			= @v_dom_exp
							AND		FCST_TYPE		= @v_fcst_type
							AND		INCOTERMS		= @v_incoterms
							AND		MEASURE			= @v_measure
							AND		PLANT_SITE_ID	= @v_plant_site_id
							AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= @v_bf_week				-- 전주차 CUTOFF
							AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
							AND     DEMAND_CHANGE_TYPE <> 'CO'	
							) R1 LEFT OUTER JOIN
												(
												SELECT	A.DEMAND_ID		,
														B.QTY			
													FROM
													(
														SELECT	DEMAND_ID, 
																QTY
														FROM	DM_PLN_DEMANDID_PEGGING WITH(NOLOCK)
														WHERE	1 =1 
														AND     DIVISION_ID     = @v_division_id
														AND		PROJECT_CODE	= @v_project_code
														AND		SCM_SITE_ID		= @v_scm_site_id
														AND		ITEM_ID			= @v_item_id
														AND		DOM_EXP			= @v_dom_exp
														AND		FCST_TYPE		= @v_fcst_type
														AND		INCOTERMS		= @v_incoterms
														AND		MEASURE			= @v_measure
														AND		PLANT_SITE_ID	= @v_plant_site_id
														AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
														AND		CREATION_WEEK	= @v_bf_week				-- 전주차 CUTOFF
														AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
														AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
														AND     DEMAND_CHANGE_TYPE <> 'CO'	
													) A INNER JOIN 
													(
														SELECT	M_DEMAND_ID, SUM(QTY) QTY
														FROM	DM_PLN_DEMANDID_PEGGING WITH(NOLOCK)
														WHERE	1 =1 
														AND     DIVISION_ID     = @v_division_id
														AND		PROJECT_CODE	= @v_project_code
														AND		SCM_SITE_ID		= @v_scm_site_id
														AND		ITEM_ID			= @v_item_id
														AND		DOM_EXP			= @v_dom_exp
														AND		FCST_TYPE		= @v_fcst_type
														AND		INCOTERMS		= @v_incoterms
														AND		MEASURE			= @v_measure
														AND		PLANT_SITE_ID	= @v_plant_site_id
														AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
														AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
														AND     DEMAND_CHANGE_TYPE <> 'CO'
														GROUP BY M_DEMAND_ID
													) B ON A.DEMAND_ID = B.M_DEMAND_ID
												) R2 ON R1.DEMAND_ID = R2.DEMAND_ID 


						
			-- 5-1. 주차이동(선행)
			SELECT	@v_section2_06_01 = ISNULL(SUM(R.QTY), 0)
			  FROM  (
					SELECT	A.DEMAND_ID 
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW	
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A  WITH(NOLOCK)INNER JOIN SCM_SYS_CALENDAR_M B  WITH(NOLOCK) ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C  WITH(NOLOCK) ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1 
							AND     DIVISION_ID     = @v_division_id
							AND		PROJECT_CODE	= @v_project_code
							AND		SCM_SITE_ID		= @v_scm_site_id
							AND		ITEM_ID			= @v_item_id
							AND		DOM_EXP			= @v_dom_exp
							AND		FCST_TYPE		= @v_fcst_type
							AND		INCOTERMS		= @v_incoterms
							AND		MEASURE			= @v_measure
							AND		PLANT_SITE_ID	= @v_plant_site_id
							AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					) R
			WHERE	R.ISO_YYYYWW <> R.ISO_M_YYYYWW
			  AND   R.ISO_YYYYWW  < R.ISO_M_YYYYWW

			-- 5-2. 주차이동(후행)
			SELECT	@v_section2_06_02 = ISNULL(SUM(R.QTY), 0)
			  FROM  (
					SELECT	A.DEMAND_ID 
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW	
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A  WITH(NOLOCK) INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													                INNER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1 
							AND     DIVISION_ID     = @v_division_id
							AND		PROJECT_CODE	= @v_project_code
							AND		SCM_SITE_ID		= @v_scm_site_id
							AND		ITEM_ID			= @v_item_id
							AND		DOM_EXP			= @v_dom_exp
							AND		FCST_TYPE		= @v_fcst_type
							AND		INCOTERMS		= @v_incoterms
							AND		MEASURE			= @v_measure
							AND		PLANT_SITE_ID	= @v_plant_site_id
							AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					) R
			WHERE	R.ISO_YYYYWW <> R.ISO_M_YYYYWW
			  AND   R.ISO_YYYYWW  > R.ISO_M_YYYYWW

			-- 6-1. 일자이동(선행)
			SELECT	@v_section2_07_01 = ISNULL(SUM(R.QTY), 0)
			  FROM  (
					SELECT	A.DEMAND_ID 
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW	
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A  WITH(NOLOCK) INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													                INNER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1 
							AND     DIVISION_ID     = @v_division_id
							AND		PROJECT_CODE	= @v_project_code
							AND		SCM_SITE_ID		= @v_scm_site_id
							AND		ITEM_ID			= @v_item_id
							AND		DOM_EXP			= @v_dom_exp
							AND		FCST_TYPE		= @v_fcst_type
							AND		INCOTERMS		= @v_incoterms
							AND		MEASURE			= @v_measure
							AND		PLANT_SITE_ID	= @v_plant_site_id
							AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					) R
			WHERE	R.ISO_YYYYWW = R.ISO_M_YYYYWW
			  AND   R.YYYYMMDD  <> R.M_YYYYMMDD
			  AND   R.YYYYMMDD   < R.M_YYYYMMDD

			-- 6-2. 일자이동(후행)
			SELECT	@v_section2_07_02 = ISNULL(SUM(R.QTY), 0)
			  FROM  (
					SELECT	A.DEMAND_ID 
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW	
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A  WITH(NOLOCK) INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													                INNER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1 
							AND     DIVISION_ID     = @v_division_id
							AND		PROJECT_CODE	= @v_project_code
							AND		SCM_SITE_ID		= @v_scm_site_id
							AND		ITEM_ID			= @v_item_id
							AND		DOM_EXP			= @v_dom_exp
							AND		FCST_TYPE		= @v_fcst_type
							AND		INCOTERMS		= @v_incoterms
							AND		MEASURE			= @v_measure
							AND		PLANT_SITE_ID	= @v_plant_site_id
							AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 5, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				-- 불변구간(고객인도 ~ 출하 4주전)
							AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					) R
			WHERE	R.ISO_YYYYWW = R.ISO_M_YYYYWW
			  AND   R.YYYYMMDD  <> R.M_YYYYMMDD
			  AND   R.YYYYMMDD   > R.M_YYYYMMDD

			/* 2. 확정구간(출하7주전 ~ 출하11주전) FCST 구하기 */------------------★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★END

			/* 3. 확정구간(출하12주전) FCST 구하기 */------------------------------★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★BEGIN
			-- 1-1.  전주 FCST
			SELECT		@v_section3_01 = ISNULL(SUM(ISNULL(QTY, 0)), 0)
				FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
				WHERE	1 =1 
				AND     DIVISION_ID     = @v_division_id
				AND		PROJECT_CODE	= @v_project_code
				AND		SCM_SITE_ID		= @v_scm_site_id
				AND		ITEM_ID			= @v_item_id
				AND		DOM_EXP			= @v_dom_exp
				AND		FCST_TYPE		= @v_fcst_type
				AND		INCOTERMS		= @v_incoterms
				AND		MEASURE			= @v_measure
				AND		PLANT_SITE_ID	= @v_plant_site_id
				AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= @v_bf_week				-- 전주차 CUTOFF
				AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				
				AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 11, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	

			-- 1-2. 당주 FCST
			SELECT		@v_section3_02 = ISNULL(SUM(ISNULL(QTY, 0)), 0)
				FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
				WHERE	1 =1 
				AND     DIVISION_ID     = @v_division_id
				AND		PROJECT_CODE	= @v_project_code
				AND		SCM_SITE_ID		= @v_scm_site_id
				AND		ITEM_ID			= @v_item_id
				AND		DOM_EXP			= @v_dom_exp
				AND		FCST_TYPE		= @v_fcst_type
				AND		INCOTERMS		= @v_incoterms
				AND		MEASURE			= @v_measure
				AND		PLANT_SITE_ID	= @v_plant_site_id
				AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
				AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				
				AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 11, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	
				--ORDER BY M_DEMAND_ID

			-- 2. 이월
			SELECT		@v_section3_03 = ISNULL(SUM(ISNULL(QTY, 0)), 0)
				FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
				WHERE	1 =1 
				AND     DIVISION_ID     = @v_division_id
				AND		PROJECT_CODE	= @v_project_code
				AND		SCM_SITE_ID		= @v_scm_site_id
				AND		ITEM_ID			= @v_item_id
				AND		DOM_EXP			= @v_dom_exp
				AND		FCST_TYPE		= @v_fcst_type
				AND		INCOTERMS		= @v_incoterms
				AND		MEASURE			= @v_measure
				AND		PLANT_SITE_ID	= @v_plant_site_id
				AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
				AND		DEMAND_CHANGE_TYPE = 'CO'
				AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				
				AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 11, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	

			-- 3. 신규/증량
			SELECT		@v_section3_04 = ISNULL(SUM(QTY), 0)
				FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK)
				WHERE	1 =1 
				AND     DIVISION_ID     = @v_division_id
				AND		PROJECT_CODE	= @v_project_code
				AND		SCM_SITE_ID		= @v_scm_site_id
				AND		ITEM_ID			= @v_item_id
				AND		DOM_EXP			= @v_dom_exp
				AND		FCST_TYPE		= @v_fcst_type
				AND		INCOTERMS		= @v_incoterms
				AND		MEASURE			= @v_measure
				AND		PLANT_SITE_ID	= @v_plant_site_id
				AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
				AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
				AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				
				AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 11, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	
				AND		A.DEMAND_CHANGE_TYPE <> 'CO'				-- 이월을 제외하고
				AND     A.DEMAND_CHANGE_TYPE = 'NEW'
				--GROUP BY LEFT(DEMAND_ID, 14)


			-- 4. 삭제/감량(기간을 전주 CUTOFF로 보아야 한다.)
			SELECT	@v_section3_05 = ISNULL(SUM(R1.QTY), 0) - ISNULL(SUM(R2.QTY), 0)
				FROM	(
							SELECT	DEMAND_ID, 
									QTY
							FROM	DM_PLN_DEMANDID_PEGGING WITH(NOLOCK)
							WHERE	1 =1 
							AND     DIVISION_ID     = @v_division_id
							AND		PROJECT_CODE	= @v_project_code
							AND		SCM_SITE_ID		= @v_scm_site_id
							AND		ITEM_ID			= @v_item_id
							AND		DOM_EXP			= @v_dom_exp
							AND		FCST_TYPE		= @v_fcst_type
							AND		INCOTERMS		= @v_incoterms
							AND		MEASURE			= @v_measure
							AND		PLANT_SITE_ID	= @v_plant_site_id
							AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= @v_bf_week				-- 전주차 CUTOFF
							AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				
							AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 11, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	
							AND     DEMAND_CHANGE_TYPE <> 'CO'	
							) R1 LEFT OUTER JOIN
												(
												SELECT	A.DEMAND_ID		,
														B.QTY			
													FROM
													(
														SELECT	DEMAND_ID, 
																QTY
														FROM	DM_PLN_DEMANDID_PEGGING WITH(NOLOCK)
														WHERE	1 =1 
														AND     DIVISION_ID     = @v_division_id
														AND		PROJECT_CODE	= @v_project_code
														AND		SCM_SITE_ID		= @v_scm_site_id
														AND		ITEM_ID			= @v_item_id
														AND		DOM_EXP			= @v_dom_exp
														AND		FCST_TYPE		= @v_fcst_type
														AND		INCOTERMS		= @v_incoterms
														AND		MEASURE			= @v_measure
														AND		PLANT_SITE_ID	= @v_plant_site_id
														AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
														AND		CREATION_WEEK	= @v_bf_week				-- 전주차 CUTOFF
														AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				
														AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 11, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	
														AND     DEMAND_CHANGE_TYPE <> 'CO'	
													) A INNER JOIN 
													(
														SELECT	M_DEMAND_ID, SUM(QTY) QTY
														FROM	DM_PLN_DEMANDID_PEGGING WITH(NOLOCK)
														WHERE	1 =1 
														AND     DIVISION_ID     = @v_division_id
														AND		PROJECT_CODE	= @v_project_code
														AND		SCM_SITE_ID		= @v_scm_site_id
														AND		ITEM_ID			= @v_item_id
														AND		DOM_EXP			= @v_dom_exp
														AND		FCST_TYPE		= @v_fcst_type
														AND		INCOTERMS		= @v_incoterms
														AND		MEASURE			= @v_measure
														AND		PLANT_SITE_ID	= @v_plant_site_id
														AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
														AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
														AND     DEMAND_CHANGE_TYPE <> 'CO'
														GROUP BY M_DEMAND_ID
													) B ON A.DEMAND_ID = B.M_DEMAND_ID
												) R2 ON R1.DEMAND_ID = R2.DEMAND_ID 


						
			-- 5-1. 주차이동(선행)
			SELECT	@v_section3_06_01 = ISNULL(SUM(R.QTY), 0)
			  FROM  (
					SELECT	A.DEMAND_ID 
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW	
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK) INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1 
							AND     DIVISION_ID     = @v_division_id
							AND		PROJECT_CODE	= @v_project_code
							AND		SCM_SITE_ID		= @v_scm_site_id
							AND		ITEM_ID			= @v_item_id
							AND		DOM_EXP			= @v_dom_exp
							AND		FCST_TYPE		= @v_fcst_type
							AND		INCOTERMS		= @v_incoterms
							AND		MEASURE			= @v_measure
							AND		PLANT_SITE_ID	= @v_plant_site_id
							AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				
							AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 11, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	
					) R
			WHERE	R.ISO_YYYYWW <> R.ISO_M_YYYYWW
			  AND   R.ISO_YYYYWW  < R.ISO_M_YYYYWW

			-- 5-2. 주차이동(후행)
			SELECT	@v_section3_06_02 = ISNULL(SUM(R.QTY), 0)
			  FROM  (
					SELECT	A.DEMAND_ID 
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW	
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK) INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1 
							AND     DIVISION_ID     = @v_division_id
							AND		PROJECT_CODE	= @v_project_code
							AND		SCM_SITE_ID		= @v_scm_site_id
							AND		ITEM_ID			= @v_item_id
							AND		DOM_EXP			= @v_dom_exp
							AND		FCST_TYPE		= @v_fcst_type
							AND		INCOTERMS		= @v_incoterms
							AND		MEASURE			= @v_measure
							AND		PLANT_SITE_ID	= @v_plant_site_id
							AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				
							AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 11, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	
					) R
			WHERE	R.ISO_YYYYWW <> R.ISO_M_YYYYWW
			  AND   R.ISO_YYYYWW  > R.ISO_M_YYYYWW

			-- 6-1. 일자이동(선행)
			SELECT	@v_section3_07_01 = ISNULL(SUM(R.QTY), 0)
			  FROM  (
					SELECT	A.DEMAND_ID 
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW	
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK) INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1 
							AND     DIVISION_ID     = @v_division_id
							AND		PROJECT_CODE	= @v_project_code
							AND		SCM_SITE_ID		= @v_scm_site_id
							AND		ITEM_ID			= @v_item_id
							AND		DOM_EXP			= @v_dom_exp
							AND		FCST_TYPE		= @v_fcst_type
							AND		INCOTERMS		= @v_incoterms
							AND		MEASURE			= @v_measure
							AND		PLANT_SITE_ID	= @v_plant_site_id
							AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				
							AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 11, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	
					) R
			WHERE	R.ISO_YYYYWW = R.ISO_M_YYYYWW
			  AND   R.YYYYMMDD  <> R.M_YYYYMMDD
			  AND   R.YYYYMMDD   < R.M_YYYYMMDD

			-- 6-2. 일자이동(후행)
			SELECT	@v_section3_07_02 = ISNULL(SUM(R.QTY), 0)
			  FROM  (
					SELECT	A.DEMAND_ID 
							,A.M_DEMAND_ID
							,A.YYYYMMDD
							,A.M_YYYYMMDD
							,B.ISO_YYYYWW	ISO_YYYYWW	
							,C.ISO_YYYYWW	ISO_M_YYYYWW
							,A.QTY
					  FROM	DM_PLN_DEMANDID_PEGGING A WITH(NOLOCK) INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD   = B.BASIS_YYYYMMDD
													               INNER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) ON A.M_YYYYMMDD = C.BASIS_YYYYMMDD
					 WHERE	1 =1 
							AND     DIVISION_ID     = @v_division_id
							AND		PROJECT_CODE	= @v_project_code
							AND		SCM_SITE_ID		= @v_scm_site_id
							AND		ITEM_ID			= @v_item_id
							AND		DOM_EXP			= @v_dom_exp
							AND		FCST_TYPE		= @v_fcst_type
							AND		INCOTERMS		= @v_incoterms
							AND		MEASURE			= @v_measure
							AND		PLANT_SITE_ID	= @v_plant_site_id
							AND		CELL_PROD_SITE_ID = @v_cell_prod_site_id	-- [PJ2025-50017] 추가
							AND		CREATION_WEEK	= @v_work_week				-- 당주차 CUTOFF
							AND     A.DEMAND_CHANGE_TYPE <> 'CO'
							AND		YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, 7 * 10, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				
							AND		YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, 7 * 11, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)				
					) R
			WHERE	R.ISO_YYYYWW = R.ISO_M_YYYYWW
			  AND   R.YYYYMMDD  <> R.M_YYYYMMDD
			  AND   R.YYYYMMDD   > R.M_YYYYMMDD

			/* 3. 확정구간(출하12주전) FCST 구하기 */------------------------------★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★END

			INSERT INTO #T_RESULT_TBL(
										DIVISION_ID			,
										VERSION_NO          ,
										PROJECT_CODE		,
										SCM_SITE_ID			,
										ITEM_ID				,
										DOM_EXP				,
										FCST_TYPE			,
										INCOTERMS			,
										MEASURE				,
										PLANT_SITE_ID		,
										CELL_PROD_SITE_ID	,					-- [PJ2025-50017] 추가
										S1_BF_WK_FCST		,
										S1_NOW_WK_FCST		,
										S1_CO_FCST			,
										S1_NEW_FCST			,
										S1_DEL_FCST			,
										S1_WK_MV_FCST_PRE	,
										S1_WK_MV_FCST_POST	,
										S1_DAY_MV_FCST_PRE	,
										S1_DAY_MV_FCST_POST	,
										S2_BF_WK_FCST		,
										S2_NOW_WK_FCST		,
										S2_CO_FCST			,
										S2_NEW_FCST			,
										S2_DEL_FCST			,
										S2_WK_MV_FCST_PRE	,
										S2_WK_MV_FCST_POST	,
										S2_DAY_MV_FCST_PRE	,
										S2_DAY_MV_FCST_POST	,
										S3_BF_WK_FCST		,
										S3_NOW_WK_FCST		,
										S3_CO_FCST			,
										S3_NEW_FCST			,
										S3_DEL_FCST			,
										S3_WK_MV_FCST_PRE	,
										S3_WK_MV_FCST_POST	,
										S3_DAY_MV_FCST_PRE	,
										S3_DAY_MV_FCST_POST		
									)
								VALUES (
										@v_division_id				,
										@v_VERSION_NO               ,
										@v_project_code				,
										@v_scm_site_id				,
										@v_item_id					,
										@v_dom_exp					,
										@v_fcst_type				,
										@v_incoterms				,
										@v_measure					,
										@v_plant_site_id			,
										@v_cell_prod_site_id		,				-- [PJ2025-50017] 추가

										@v_section1_01				,		
										@v_section1_02				,		
										@v_section1_03				,		
										@v_section1_04				,		
										@v_section1_05				,		
										@v_section1_06_01			,		
										@v_section1_06_02			,
										@v_section1_07_01			,		
										@v_section1_07_02			,

										@v_section2_01				,		
										@v_section2_02				,		
										@v_section2_03				,		
										@v_section2_04				,		
										@v_section2_05				,		
										@v_section2_06_01			,		
										@v_section2_06_02			,
										@v_section2_07_01			,
										@v_section2_07_02			,

										@v_section3_01				,		
										@v_section3_02				,		
										@v_section3_03				,		
										@v_section3_04				,		
										@v_section3_05				,		
										@v_section3_06_01			,		
										@v_section3_06_02			,
										@v_section3_07_01			,
										@v_section3_07_02
										)


			-- OUTER CURSOR
			FETCH NEXT FROM PEGGING_OUT_CUR INTO @v_division_id		,
												@v_VERSION_NO		,
												@v_project_code		,
												@v_scm_site_id		,
												@v_item_id			,
												@v_dom_exp			,
												@v_fcst_type		,
												@v_incoterms		,
												@v_measure			,
												@v_plant_site_id	,
												@v_cell_prod_site_id				-- [PJ2025-50017] 추가

		END

		CLOSE PEGGING_OUT_CUR
		DEALLOCATE PEGGING_OUT_CUR

		-- INSERT 전 중복제거
		DELETE 
		FROM dbo.DM_PLN_DEMAND_CHANGE_STATUS
			where 1=1
				and exists (
					SELECT division_id 
						FROM #T_RESULT_TBL
							where 1=1
								and DM_PLN_DEMAND_CHANGE_STATUS.DIVISION_ID     =   DIVISION_ID     
								and DM_PLN_DEMAND_CHANGE_STATUS.VERSION_NO      =   VERSION_NO		     
							)

		-- INSERT 
		INSERT INTO DM_PLN_DEMAND_CHANGE_STATUS
			 (
			 DIVISION_ID,VERSION_NO,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
			,CELL_PROD_SITE_ID						-- [PJ2025-50017] 추가
			,S1_BF_WK_FCST,S1_NOW_WK_FCST,S1_CO_FCST,S1_NEW_FCST,S1_DEL_FCST,S1_WK_MV_FCST_PRE,S1_WK_MV_FCST_POST,S1_DAY_MV_FCST_PRE,S1_DAY_MV_FCST_POST
			,S2_BF_WK_FCST,S2_NOW_WK_FCST,S2_CO_FCST,S2_NEW_FCST,S2_DEL_FCST,S2_WK_MV_FCST_PRE,S2_WK_MV_FCST_POST,S2_DAY_MV_FCST_PRE,S2_DAY_MV_FCST_POST
			,S3_BF_WK_FCST,S3_NOW_WK_FCST,S3_CO_FCST,S3_NEW_FCST,S3_DEL_FCST,S3_WK_MV_FCST_PRE,S3_WK_MV_FCST_POST,S3_DAY_MV_FCST_PRE,S3_DAY_MV_FCST_POST
			,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
			 )
		SELECT
			 DIVISION_ID
			,VERSION_NO			
			,PROJECT_CODE		
			,SCM_SITE_ID			
			,ITEM_ID				
			,DOM_EXP				
			,FCST_TYPE			
			,INCOTERMS			
			,MEASURE				
			,PLANT_SITE_ID		
			,CELL_PROD_SITE_ID						-- [PJ2025-50017] 추가
			,S1_BF_WK_FCST		
			,S1_NOW_WK_FCST		
			,S1_CO_FCST			
			,S1_NEW_FCST			
			,S1_DEL_FCST			
			,S1_WK_MV_FCST_PRE	
			,S1_WK_MV_FCST_POST	
			,S1_DAY_MV_FCST_PRE	
			,S1_DAY_MV_FCST_POST	
			,S2_BF_WK_FCST		
			,S2_NOW_WK_FCST		
			,S2_CO_FCST			
			,S2_NEW_FCST			
			,S2_DEL_FCST			
			,S2_WK_MV_FCST_PRE	
			,S2_WK_MV_FCST_POST	
			,S2_DAY_MV_FCST_PRE	
			,S2_DAY_MV_FCST_POST	
			,S3_BF_WK_FCST		
			,S3_NOW_WK_FCST		
			,S3_CO_FCST			
			,S3_NEW_FCST			
			,S3_DEL_FCST			
			,S3_WK_MV_FCST_PRE	
			,S3_WK_MV_FCST_POST	
			,S3_DAY_MV_FCST_PRE	
			,S3_DAY_MV_FCST_POST	
			,'SYSTEM',GETDATE(),'SYSTEM',GETDATE()
		 FROM #T_RESULT_TBL
		 
        END TRY --[C20200909-000203] LOG 표준화 적용
		
	--------------------------------------------------------------	
    BEGIN CATCH --[C20200909-000203] LOG 표준화 적용
	--------------------------------------------------------------	

      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME(); 
	  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	
	
		--[C20200909-000203] LOG 표준화 적용
		-- 종료 LOG
		SET @v_log_type    = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



END

