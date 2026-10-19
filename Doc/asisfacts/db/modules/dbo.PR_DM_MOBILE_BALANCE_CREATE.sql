
/*
 * Program ID   : PR_DM_MOBILE_BALANCE_CREATE
 * Description  : 
 * Program History
 *============================================================================================================
 *   Date       In Charge              Description
 *============================================================================================================
 * 2018.05.14   JunHee Jeen / KHSONG   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * -----------------------------------------------------------------------------------------------------------
 * 20180607 KHSONG Sales Plan AMT Create Procedure 호출추가 
 * 20180611 added by ytchoi 180611 한주가 지나면 화면에서 과거 RTF P 를 보기 어렵기 때문에 당주 월요일 이후로만 계산 함
 * 20180614 KHSONG CUTOFF RTF MEASURE 정보변경 로직 추가
 * 20180618 KHSONG CUTOFF TABLE BALANCE 값 재계산 로직 추가
 * 20180820 KHSONG BALANCE 생성로직 CURSOR에서 테이블구조로 수정
 * 20180823 KHSONG VMI재고 확인후 RTF 생성 로직, VMI DIO 계산로직 보완
 *                 [dbo].[SCP_PLN_RTF_ALLOCATION_V_40_TEST] <= 개발기에 정보가 없어서 운영테이블을 임시로 연결함 => 운영배포시 수정필요
 *                 'SAMPLE DATA' 주석부분 검색하여 임시 적용된 데이터 INPUT을 확인해야함
 *
 *                 임시주석처리  1. Sales Plan AMT Create Procedure 호출
 *                               2. CUTOFF RTF MEASURE 정보변경 로직
 *                               3. CUTOFF TABLE BALANCE 값 재계산 로직
 *************************************************************************************************************************************
 *
 *
 *                                                2018.09월만 임시로 사용하기위한 Procedure                                          *
 *
 *
 *************************************************************************************************************************************
 * 20180907 KHSONG DIO insert 속도 이슈로 temp 테이블 사용
 */

CREATE PROCEDURE [dbo].[PR_DM_MOBILE_BALANCE_CREATE]

	-- Add the parameters for the stored procedure here
	--@p_division_id				NVARCHAR(MAX)
 --  ,@p_plan_id                  NVARCHAR(MAX)	

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MOBILE_BALANCE_CREATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

    DECLARE @p_division_id                  NVARCHAR(MAX);
    DECLARE @p_plan_id						NVARCHAR(MAX);

    DECLARE @max_plan_id                  NVARCHAR(MAX);
    DECLARE @plan_start_yyyymmdd          NVARCHAR(MAX);
    DECLARE @c_division_id                NVARCHAR(MAX);
    DECLARE @c_plan_id                    NVARCHAR(MAX);
    DECLARE @c_plan_start_yyyymmdd        NVARCHAR(MAX);
    DECLARE @c_VERSION_NO				  NVARCHAR(MAX);

	SET @p_division_id = '40'
	SET @p_plan_id = NULL

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '@p_division_id : ' + ISNULL(@p_division_id,'NULL') + ' / ' + '@p_plan_id : ' + ISNULL(@p_plan_id,'NULL');
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- input division save table
	DECLARE @division TABLE (division_id			NVARCHAR(MAX)
	                       , plan_id				NVARCHAR(MAX)
						   , plan_start_yyyymmdd	NVARCHAR(MAX)
						   )  

	-- input cufoff table
	DECLARE @cutoff	 TABLE (VERSION_NO				NVARCHAR(MAX)  )  

		-- 트랜잭션 (START)
		--BEGIN TRANSACTION MKT_FCST_QTY_BALANCE_CREATE;

		--------------------------------------------------------------------------------------------	
		BEGIN TRY
		--------------------------------------------------------------------------------------------	
		-------
		BEGIN
		-------
			INSERT INTO @division (division_id,plan_id,plan_start_yyyymmdd) VALUES (@p_division_id,'','') 

			IF @p_plan_id IS NULL  -- @p_plan_id 값이 없는경우
				BEGIN

					SET @max_plan_id = (SELECT MAX(plan_id) FROM [dbo].[SCP_PLN_RTF_ALLOCATION_V_40_TEST] WITH(NOLOCK)  -- plan_id 추출
										WHERE division_id = @p_division_id)
				  
					SET @plan_start_yyyymmdd = (SELECT MAX(plan_start_yyyymmdd) FROM [dbo].[SCP_PLN_RTF_ALLOCATION_V_40_TEST] WITH(NOLOCK)  -- plan_start_yyyymmdd 추출
												WHERE division_id = @p_division_id AND plan_id = @max_plan_id)

					-- added by ytchoi 180611 한주가 지나면 화면에서 과거 RTF P 를 보기 어렵기 때문에 당주 월요일 이후로만 계산 함.
					SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  -- 당주월요일

					UPDATE @division SET plan_id = @max_plan_id,plan_start_yyyymmdd = @plan_start_yyyymmdd  WHERE division_id = @p_division_id  -- plan_id,plan_start_yyyymmdd 업데이트

				END
			ELSE     -- @p_plan_id 값이 있는경우
				BEGIN
					SET @plan_start_yyyymmdd = (SELECT MAX(plan_start_yyyymmdd) FROM [dbo].[SCP_PLN_RTF_ALLOCATION_V_40_TEST] WITH(NOLOCK)  -- plan_start_yyyymmdd 추출
												WHERE division_id = @p_division_id AND plan_id = @p_plan_id)
					-- added by ytchoi 180611 한주가 지나면 화면에서 과거 RTF P 를 보기 어렵기 때문에 당주 월요일 이후로만 계산 함.
					SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주월요일

					UPDATE @division SET plan_id = @p_plan_id,plan_start_yyyymmdd = @plan_start_yyyymmdd  WHERE division_id = @p_division_id  -- plan_id,plan_start_yyyymmdd 업데이트
				END

		-------
		END
		-------

		-------
		BEGIN
		-------
		IF OBJECT_ID (N'tempdb..temp_skh_results', N'U') IS NOT NULL 
			DROP TABLE temp_skh_results
		IF OBJECT_ID (N'tempdb..temp_skh_MST', N'U') IS NOT NULL 
			DROP TABLE temp_skh_MST
		IF OBJECT_ID (N'tempdb..temp_skh_TEMP1', N'U') IS NOT NULL 
			DROP TABLE temp_skh_TEMP1
		IF OBJECT_ID (N'tempdb..temp_skh_TEMP2', N'U') IS NOT NULL 
			DROP TABLE temp_skh_TEMP2
		IF OBJECT_ID (N'tempdb..temp_skh_TEMPX', N'U') IS NOT NULL 
			DROP TABLE temp_skh_TEMPX
		IF OBJECT_ID (N'tempdb..temp_skh_VMI_MST', N'U') IS NOT NULL 
			DROP TABLE temp_skh_VMI_MST
		IF OBJECT_ID (N'tempdb..temp_skh_VMI_MST_MAIN', N'U') IS NOT NULL 
			DROP TABLE temp_skh_VMI_MST_MAIN
		IF OBJECT_ID (N'tempdb..temp_skh_VMI_TEMP1', N'U') IS NOT NULL 
			DROP TABLE temp_skh_VMI_TEMP1
		IF OBJECT_ID (N'tempdb..temp_skh_VMI_TEMP2', N'U') IS NOT NULL 
			DROP TABLE temp_skh_VMI_TEMP2
		IF OBJECT_ID (N'tempdb..temp_skh_VMI_TEMP_all', N'U') IS NOT NULL 
			DROP TABLE temp_skh_VMI_TEMP_all
		IF OBJECT_ID (N'tempdb..temp_skh_DIO_TEMP', N'U') IS NOT NULL 
			DROP TABLE temp_skh_DIO_TEMP

			-- 임시 확인용
		IF OBJECT_ID (N'dbo.temp_skh_results', N'U') IS NOT NULL 
			DROP TABLE temp_skh_results
		IF OBJECT_ID (N'dbo.temp_skh_MST', N'U') IS NOT NULL 
			DROP TABLE temp_skh_MST
		IF OBJECT_ID (N'dbo.temp_skh_TEMP1', N'U') IS NOT NULL 
			DROP TABLE temp_skh_TEMP1
		IF OBJECT_ID (N'dbo.temp_skh_TEMP2', N'U') IS NOT NULL 
			DROP TABLE temp_skh_TEMP2
		IF OBJECT_ID (N'dbo.temp_skh_TEMPX', N'U') IS NOT NULL 
			DROP TABLE temp_skh_TEMPX
		IF OBJECT_ID (N'dbo.temp_skh_VMI_MST', N'U') IS NOT NULL 
			DROP TABLE temp_skh_VMI_MST
		IF OBJECT_ID (N'dbo.temp_skh_VMI_MST_MAIN', N'U') IS NOT NULL 
			DROP TABLE temp_skh_VMI_MST_MAIN
		IF OBJECT_ID (N'dbo.temp_skh_VMI_TEMP1', N'U') IS NOT NULL 
			DROP TABLE temp_skh_VMI_TEMP1
		IF OBJECT_ID (N'dbo.temp_skh_VMI_TEMP2', N'U') IS NOT NULL 
			DROP TABLE temp_skh_VMI_TEMP2
		IF OBJECT_ID (N'dbo.temp_skh_VMI_TEMP_all', N'U') IS NOT NULL 
			DROP TABLE temp_skh_VMI_TEMP_all
		IF OBJECT_ID (N'dbo.temp_skh_DIO_TEMP', N'U') IS NOT NULL 
			DROP TABLE temp_skh_DIO_TEMP
			-- 임시 확인용

		CREATE TABLE temp_skh_results  (
				 division_id      NVARCHAR(30) NOT NULL
				,project_code     NVARCHAR(50) NOT NULL
				,scm_site_id      NVARCHAR(30) NOT NULL
				,item_id          NVARCHAR(50) NOT NULL
				,dom_exp          NVARCHAR(03) NOT NULL
				,fcst_type        NVARCHAR(20) NOT NULL
				,incoterms        NVARCHAR(10) NOT NULL
				--,v_measure          NVARCHAR(50) NOT NULL
				,plant_site_id    NVARCHAR(30) NOT NULL
				,vmi_yn		      NVARCHAR(01)  NULL
							   )
							   
		CREATE CLUSTERED INDEX [IDX_RESULTS_N1] ON [temp_skh_results]
		(
			 division_id ASC
			,project_code ASC
			,scm_site_id ASC
			,item_id ASC
			,dom_exp ASC
			,fcst_type ASC
			,incoterms ASC
			--,v_MEASURE ASC
			,plant_site_id ASC
			--,vmi_yn			 ASC
		--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		;

		CREATE TABLE  temp_skh_MST
		 (DIVISION_ID	NVARCHAR(30) NOT NULL
		 ,PROJECT_CODE	NVARCHAR(50) NOT NULL
		 ,SCM_SITE_ID	NVARCHAR(30) NOT NULL
		 ,ITEM_ID		NVARCHAR(50) NOT NULL
		 ,DOM_EXP		NVARCHAR(03) NOT NULL
		 ,FCST_TYPE		NVARCHAR(20) NOT NULL
		 ,INCOTERMS		NVARCHAR(10) NOT NULL
		 ,PLANT_SITE_ID NVARCHAR(30) NOT NULL
		 ,YYYYMMDD		NVARCHAR(08) NOT NULL
		 ,MEASURE		NVARCHAR(50) NOT NULL
		 ,QTY			NUMERIC(30,10) NOT NULL
		 )

		CREATE CLUSTERED INDEX [IDX_MST_N1] ON [temp_skh_MST]
		(
			-- DIVISION_ID ASC
			--,PROJECT_CODE ASC
			--,SCM_SITE_ID ASC
			--,ITEM_ID ASC
			--,DOM_EXP ASC
			--,FCST_TYPE ASC
			--,INCOTERMS ASC
			--,PLANT_SITE_ID ASC
			--,YYYYMMDD ASC
			--,MEASURE ASC
		MEASURE ASC,YYYYMMDD ASC
		)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
		;
	CREATE TABLE  temp_skh_TEMP1
	 (DIVISION_ID	NVARCHAR(30) NOT NULL
	 ,PROJECT_CODE	NVARCHAR(50) NOT NULL
	 ,SCM_SITE_ID	NVARCHAR(30) NOT NULL
	 ,ITEM_ID		NVARCHAR(50) NOT NULL
	 ,DOM_EXP		NVARCHAR(03) NOT NULL
	 ,FCST_TYPE		NVARCHAR(20) NOT NULL
	 ,INCOTERMS		NVARCHAR(10) NOT NULL
	 ,PLANT_SITE_ID NVARCHAR(30) NOT NULL
	 ,YYYYMMDD		NVARCHAR(08) NOT NULL
	 ,MEASURE		NVARCHAR(50) NOT NULL
	 ,QTY			NUMERIC(30,10) NOT NULL
	 ,ACCUM_SUM		NUMERIC(30,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_TEMP1_N1] ON [temp_skh_TEMP1]
	(
		 DIVISION_ID ASC
		,PROJECT_CODE ASC
		,SCM_SITE_ID ASC
		,ITEM_ID ASC
		,DOM_EXP ASC
		,FCST_TYPE ASC
		,INCOTERMS ASC
		,PLANT_SITE_ID ASC
		,YYYYMMDD ASC
		,MEASURE ASC
--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
;
	CREATE TABLE  temp_skh_TEMP2
	 (DIVISION_ID	NVARCHAR(30) NOT NULL
	 ,PROJECT_CODE	NVARCHAR(50) NOT NULL
	 ,SCM_SITE_ID	NVARCHAR(30) NOT NULL
	 ,ITEM_ID		NVARCHAR(50) NOT NULL
	 ,DOM_EXP		NVARCHAR(03) NOT NULL
	 ,FCST_TYPE		NVARCHAR(20) NOT NULL
	 ,INCOTERMS		NVARCHAR(10) NOT NULL
	 ,PLANT_SITE_ID NVARCHAR(30) NOT NULL
	 ,YYYYMMDD		NVARCHAR(08) NOT NULL
	 ,MEASURE		NVARCHAR(50) NOT NULL
	 ,QTY			NUMERIC(30,10) NOT NULL
	 ,ACCUM_SUM		NUMERIC(30,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_TEMP2_N1] ON [temp_skh_TEMP2]
	(
		 DIVISION_ID ASC
		,PROJECT_CODE ASC
		,SCM_SITE_ID ASC
		,ITEM_ID ASC
		,DOM_EXP ASC
		,FCST_TYPE ASC
		,INCOTERMS ASC
		,PLANT_SITE_ID ASC
		,YYYYMMDD ASC
		,MEASURE ASC
--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

;
	CREATE TABLE  temp_skh_TEMPX
	 (DIVISION_ID	NVARCHAR(30) NOT NULL
	 ,PROJECT_CODE	NVARCHAR(50) NOT NULL
	 ,SCM_SITE_ID	NVARCHAR(30) NOT NULL
	 ,ITEM_ID		NVARCHAR(50) NOT NULL
	 ,DOM_EXP		NVARCHAR(03) NOT NULL
	 ,FCST_TYPE		NVARCHAR(20) NOT NULL
	 ,INCOTERMS		NVARCHAR(10) NOT NULL
	 ,PLANT_SITE_ID NVARCHAR(30) NOT NULL
	 ,YYYYMMDD		NVARCHAR(08) NOT NULL
	 ,MEASURE		NVARCHAR(50) NOT NULL
	 ,ACCUM_X		NUMERIC(30,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_TEMPX_N1] ON [temp_skh_TEMPX]
	(
		 DIVISION_ID ASC
		,PROJECT_CODE ASC
		,SCM_SITE_ID ASC
		,ITEM_ID ASC
		,DOM_EXP ASC
		,FCST_TYPE ASC
		,INCOTERMS ASC
		,PLANT_SITE_ID ASC
		,YYYYMMDD ASC
		,MEASURE ASC
--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
;

-- 20180907 DIO insert 속도 이슈로 temp 테이블 사용
CREATE TABLE temp_skh_DIO_TEMP(
	[DIVISION_ID] [nvarchar](30) NOT NULL,
	[PROJECT_CODE] [nvarchar](50) NOT NULL,
	[SCM_SITE_ID] [nvarchar](30) NOT NULL,
	[ITEM_ID] [nvarchar](50) NOT NULL,
	[DOM_EXP] [nvarchar](3) NOT NULL,
	[FCST_TYPE] [nvarchar](20) NOT NULL,
	[INCOTERMS] [nvarchar](10) NOT NULL,
	[MEASURE] [nvarchar](50) NOT NULL,
	[PLANT_SITE_ID] [nvarchar](30) NOT NULL,
	[YYYYMMDD] [nvarchar](8) NOT NULL,
	[QTY] [numeric](20, 10) NOT NULL,
	[CREATED_BY] [nvarchar](150) NULL,
	[CREATION_DATE] [datetime] NOT NULL,
	[LAST_UPDATED_BY] [nvarchar](150) NULL,
	[LAST_UPDATE_DATE] [datetime] NOT NULL,
	[ATTRIBUTE1] [nvarchar](150) NULL,
	[ATTRIBUTE2] [nvarchar](150) NULL,
	[ATTRIBUTE3] [nvarchar](150) NULL,
	[ATTRIBUTE4] [nvarchar](150) NULL,
	[ATTRIBUTE5] [nvarchar](150) NULL,
	[ATTRIBUTE6] [nvarchar](150) NULL,
	[ATTRIBUTE7] [nvarchar](150) NULL,
	[ATTRIBUTE8] [nvarchar](150) NULL,
	[ATTRIBUTE9] [nvarchar](150) NULL,
	[ATTRIBUTE10] [nvarchar](150) NULL,
 CONSTRAINT [PK_T_DIO_TEMP] PRIMARY KEY CLUSTERED 
(
	[DIVISION_ID] ASC,
	[PROJECT_CODE] ASC,
	[SCM_SITE_ID] ASC,
	[ITEM_ID] ASC,
	[DOM_EXP] ASC,
	[FCST_TYPE] ASC,
	[INCOTERMS] ASC,
	[MEASURE] ASC,
	[YYYYMMDD] ASC,
	[PLANT_SITE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY];
-- 20180907 DIO insert 속도 이슈로 temp 테이블 사용

	CREATE TABLE  temp_skh_VMI_MST
	 (
	  DIVISION_ID	NVARCHAR(30) NOT NULL
	 ,PROJECT_CODE	NVARCHAR(50) NOT NULL
	 ,SCM_SITE_ID	NVARCHAR(30) NOT NULL
	 ,ITEM_ID		NVARCHAR(50) NOT NULL
	 ,DOM_EXP		NVARCHAR(03) NOT NULL
	 ,FCST_TYPE		NVARCHAR(20) NOT NULL
	 ,INCOTERMS		NVARCHAR(10) NOT NULL
	 ,PLANT_SITE_ID NVARCHAR(30) NOT NULL
	 ,MEASURE		NVARCHAR(50) NOT NULL
	 ,YYYYMMDD		NVARCHAR(08) NOT NULL
	 ,QTY			NUMERIC(30,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_MST_N1] ON [temp_skh_VMI_MST]
	(
		 DIVISION_ID ASC
		,PROJECT_CODE ASC
		,SCM_SITE_ID ASC
		,ITEM_ID ASC
		,DOM_EXP ASC
		,FCST_TYPE ASC
		,INCOTERMS ASC
		,PLANT_SITE_ID ASC
		,MEASURE ASC
		,YYYYMMDD ASC
--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
;
	CREATE TABLE  temp_skh_VMI_MST_MAIN
	 (DIVISION_ID	NVARCHAR(30) NOT NULL
	 ,PROJECT_CODE	NVARCHAR(50) NOT NULL
	 ,SCM_SITE_ID	NVARCHAR(30) NOT NULL
	 ,ITEM_ID		NVARCHAR(50) NOT NULL
	 ,DOM_EXP		NVARCHAR(03) NOT NULL
	 ,FCST_TYPE		NVARCHAR(20) NOT NULL
	 ,INCOTERMS		NVARCHAR(10) NOT NULL
	 ,PLANT_SITE_ID NVARCHAR(30) NOT NULL
	 ,MEASURE		NVARCHAR(50) NOT NULL
	 ,YYYYMMDD		NVARCHAR(08) NOT NULL
	 ,QTY			NUMERIC(30,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_MST_MAIN_N1] ON [temp_skh_VMI_MST_MAIN]
	(
		 DIVISION_ID ASC
		,PROJECT_CODE ASC
		,SCM_SITE_ID ASC
		,ITEM_ID ASC
		,DOM_EXP ASC
		,FCST_TYPE ASC
		,INCOTERMS ASC
		,PLANT_SITE_ID ASC
		,MEASURE ASC
		,YYYYMMDD ASC
--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
;


	CREATE TABLE  temp_skh_VMI_TEMP1
	 (DIVISION_ID		NVARCHAR(30) NOT NULL
	 ,PROJECT_CODE		NVARCHAR(50) NOT NULL
	 ,SCM_SITE_ID		NVARCHAR(30) NOT NULL
	 ,ITEM_ID			NVARCHAR(50) NOT NULL
	 ,DOM_EXP			NVARCHAR(03) NOT NULL
	 ,FCST_TYPE			NVARCHAR(20) NOT NULL
	 ,INCOTERMS			NVARCHAR(10) NOT NULL
	 ,PLANT_SITE_ID		NVARCHAR(30) NOT NULL
	 ,YYYYMMDD			NVARCHAR(08) NOT NULL
	 ,MEASURE			NVARCHAR(50) NOT NULL
	 ,QTY				NUMERIC(30,10) NOT NULL
	 ,ACCUM_SUM			NUMERIC(30,10) NOT NULL
	 ,last_accum_sum	NUMERIC(30,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_40_TEMP1_N1] ON [temp_skh_VMI_TEMP1]
	(
		 DIVISION_ID ASC
		,PROJECT_CODE ASC
		,SCM_SITE_ID ASC
		,ITEM_ID ASC
		,DOM_EXP ASC
		,FCST_TYPE ASC
		,INCOTERMS ASC
		,PLANT_SITE_ID ASC
		,YYYYMMDD ASC
		,MEASURE ASC
--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
;
	CREATE TABLE  temp_skh_VMI_TEMP2
	 (DIVISION_ID		NVARCHAR(30) NOT NULL
	 ,PROJECT_CODE		NVARCHAR(50) NOT NULL
	 ,SCM_SITE_ID		NVARCHAR(30) NOT NULL
	 ,ITEM_ID			NVARCHAR(50) NOT NULL
	 ,DOM_EXP			NVARCHAR(03) NOT NULL
	 ,FCST_TYPE			NVARCHAR(20) NOT NULL
	 ,INCOTERMS			NVARCHAR(10) NOT NULL
	 ,PLANT_SITE_ID		NVARCHAR(30) NOT NULL
	 ,YYYYMMDD			NVARCHAR(08) NOT NULL
	 ,MEASURE			NVARCHAR(50) NOT NULL
	 ,QTY				NUMERIC(30,10) NOT NULL
	 ,ACCUM_SUM			NUMERIC(30,10) NOT NULL
	 ,last_accum_sum	NUMERIC(30,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_40_TEMP2_N1] ON [temp_skh_VMI_TEMP2]
	(
		 DIVISION_ID ASC
		,PROJECT_CODE ASC
		,SCM_SITE_ID ASC
		,ITEM_ID ASC
		,DOM_EXP ASC
		,FCST_TYPE ASC
		,INCOTERMS ASC
		,PLANT_SITE_ID ASC
		,YYYYMMDD ASC
		,MEASURE ASC
--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
;
	CREATE TABLE  temp_skh_VMI_TEMP_all
	 (DIVISION_ID		NVARCHAR(30) NOT NULL
	 ,PROJECT_CODE		NVARCHAR(50) NOT NULL
	 ,SCM_SITE_ID		NVARCHAR(30) NOT NULL
	 ,ITEM_ID			NVARCHAR(50) NOT NULL
	 ,DOM_EXP			NVARCHAR(03) NOT NULL
	 ,FCST_TYPE			NVARCHAR(20) NOT NULL
	 ,INCOTERMS			NVARCHAR(10) NOT NULL
	 ,PLANT_SITE_ID		NVARCHAR(30) NOT NULL
	 ,YYYYMMDD			NVARCHAR(08) NOT NULL
	 ,RTF_QTY			NUMERIC(30,10) NOT NULL
	 ,INV				NUMERIC(30,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_40_TEMP_all_N1] ON [temp_skh_VMI_TEMP_all]
	(
		 DIVISION_ID ASC
		,PROJECT_CODE ASC
		,SCM_SITE_ID ASC
		,ITEM_ID ASC
		,DOM_EXP ASC
		,FCST_TYPE ASC
		,INCOTERMS ASC
		,PLANT_SITE_ID ASC
		,YYYYMMDD ASC
--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
;
		-------
		END
		-------
			--
		--	IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR1_PLAN')
		--		BEGIN
		--			CLOSE CURSOR1_PLAN
		--			DEALLOCATE CURSOR1_PLAN
		--		END;

		--	DECLARE CURSOR1_PLAN CURSOR FAST_FORWARD FOR
		--	SELECT 	  division_id    
		--	         ,plan_id
		--			 ,plan_start_yyyymmdd 
		--		FROM  @division	ORDER BY division_id

		--BEGIN
		--	OPEN CURSOR1_PLAN;
		--	FETCH NEXT FROM CURSOR1_PLAN INTO 
		--							  @c_division_id    
		--							 ,@c_plan_id  
		--							 ,@c_plan_start_yyyymmdd  
		--END

		set @c_division_id = '40'
		set @c_plan_id				= (SELECT top 1 plan_id	FROM  @division)
		set @c_plan_start_yyyymmdd  = (SELECT top 1 plan_start_yyyymmdd	FROM  @division)

		-- TEMP TABLE에 데이터 이관 (TEST용)
/*		DELETE FROM TEMP_SKH_0907_DM_PLN_MKT_FCST

		INSERT INTO TEMP_SKH_0907_DM_PLN_MKT_FCST
		( DIVISION_ID
		,PROJECT_CODE
		,SCM_SITE_ID
		,ITEM_ID
		,DOM_EXP
		,FCST_TYPE
		,INCOTERMS
		,MEASURE
		,PLANT_SITE_ID
		,YYYYMMDD
		,QTY
		,vmi_yn
		,CREATED_BY
		,CREATION_DATE
		,LAST_UPDATED_BY
		,LAST_UPDATE_DATE
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
		)
		SELECT 
		 DIVISION_ID
		,PROJECT_CODE
		,SCM_SITE_ID
		,ITEM_ID
		,DOM_EXP
		,FCST_TYPE
		,INCOTERMS
		,MEASURE
		,PLANT_SITE_ID
		,YYYYMMDD
		,QTY
		,'' AS vmi_yn
		,CREATED_BY
		,CREATION_DATE
		,LAST_UPDATED_BY
		,LAST_UPDATE_DATE
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
 FROM DM_PLN_MKT_FCST WITH(NOLOCK)
		  WHERE DIVISION_ID = '40'
		    AND	MEASURE			= 'MKT_FCST'
*/


		----------------------------------------------------------------------------------------
		--①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①① CURSOR1_PLAN DIVISION별 LOOP START
		--WHILE @@FETCH_STATUS = 0  -- AND (SELECT COUNT(1) FROM [dbo].[SCP_PLN_RTF_ALLOCATION_V_40_TEST]  WITH(NOLOCK)  WHERE DIVISION_ID = @c_division_id AND plan_id = @c_plan_id) > 0
		----------------------------------------------------------------------------------------
		--BEGIN
		----------------------------------------------------------------------------------------
		
		IF OBJECT_ID (N'tempdb..temp_skh_RAW_TABLE', N'U') IS NOT NULL 
			DROP TABLE temp_skh_RAW_TABLE
		IF OBJECT_ID (N'tempdb..temp_skh_TEMP', N'U') IS NOT NULL 
			DROP TABLE temp_skh_TEMP

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                                     전체 대상추출 (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		PRINT 'temp_skh_results INSERT START                      =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		INSERT  INTO  temp_skh_results
					(division_id   
					,project_code  
					,scm_site_id   
					,item_id       
					,dom_exp       
					,fcst_type     
					,incoterms   
					--,v_measure  
					,plant_site_id 
					,vmi_yn)
		SELECT		 DISTINCT 
					 DIVISION_ID
					,PROJECT_CODE
					,SCM_SITE_ID
					,ITEM_ID
					,DOM_EXP
					,FCST_TYPE
					,INCOTERMS
					--,MEASURE
					,PLANT_SITE_ID
					,'N'  -- vmi_yn
			FROM DM_PLN_MKT_FCST  WITH(NOLOCK)
				WHERE	1=1
				and	YYYYMMDD BETWEEN @plan_start_yyyymmdd AND CONVERT(CHAR(8), DATEADD(WW, 52, @plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주
				AND	MEASURE			= 'MKT_FCST'
				AND DIVISION_ID		= @c_division_id
				--AND DIVISION_ID		<> '40'  -- 소형이 아닌경우만 적용함
				-- SAMPLE DATA (START)

				--AND SCM_SITE_ID IN (SELECT DISTINCT SCM_SITE_ID FROM SCM_MST_SITE C WITH(NOLOCK) WHERE DIVISION_ID = '81' AND VMI_YN   = 'Y' AND VALID_YN = 'Y')
				--AND DIVISION_ID = '81'  AND PROJECT_CODE = 'A15AI7001' AND SCM_SITE_ID = 'Audi_DE_NEM'  AND ITEM_ID = 'APAAGIHEV-A2' AND DOM_EXP = 'E' AND FCST_TYPE = 'MPS' AND INCOTERMS = 'FCA'
				--AND DIVISION_ID = '81'  AND ITEM_ID = 'APAAGIHEV-A2'
				--and SCM_SITE_ID in ('Audi_BE_BRU','Audi_DE_ING','Audi_DE_NEM','Audi_SK_BTS')

				-- SAMPLE DATA (END)
			group by division_id ,project_code ,scm_site_id   ,item_id			,dom_exp 
					,fcst_type   ,incoterms    ,plant_site_id
		-----
		UNION
		-----

		SELECT	 DIVISION_ID
				,PROJECT_CODE
				,SALES_SITE_ID
				,ITEM_ID
				,DOM_EXP
				,FCST_TYPE
				,INCOTERMS
				-- ,PLANT_SITE_ID
				,CASE WHEN DIVISION_ID = '82' OR DIVISION_ID = '40' THEN '' ELSE PLANT_SITE_ID END PLANT_SITE_ID
				,'N'  -- vmi_yn
				--,YYYYMMDD
		FROM [dbo].[SCP_PLN_RTF_ALLOCATION_V_40_TEST]  WITH(NOLOCK)
			WHERE DIVISION_ID		= @c_division_id
				--AND DIVISION_ID		<> '40'  -- 소형이 아닌경우만 적용함
				and plan_id				= @c_plan_id
				-- added by ytchoi 180611 한주가 지나면 화면에서 과거 RTF P 를 보기 어렵기 때문에 당주 월요일 이후로만 계산 함.
				and yyyymmdd			>= @c_plan_start_yyyymmdd
				-- SAMPLE DATA (START)

				--AND SALES_SITE_ID IN (SELECT DISTINCT SCM_SITE_ID FROM SCM_MST_SITE C WITH(NOLOCK) WHERE DIVISION_ID = '81' AND VMI_YN   = 'Y' AND VALID_YN = 'Y')
				--AND DIVISION_ID = '81'  AND PROJECT_CODE = 'A15AI7001' AND SALES_SITE_ID = 'Audi_DE_NEM'  AND ITEM_ID = 'APAAGIHEV-A2' AND DOM_EXP = 'E' AND FCST_TYPE = 'MPS' AND INCOTERMS = 'FCA'
				--AND DIVISION_ID = '81'  AND ITEM_ID = 'APAAGIHEV-A2'
				--and sales_SITE_ID in ('Audi_BE_BRU','Audi_DE_ING','Audi_DE_NEM','Audi_SK_BTS')

				-- SAMPLE DATA (END)
		GROUP BY DIVISION_ID , PROJECT_CODE, SALES_SITE_ID,ITEM_ID, DOM_EXP,FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD

		----------------------------------------------------------------- SCM_MST_SITE테이블의 VMI대상을 컬럼에 마킹
		update temp_skh_results set vmi_yn = 'Y'
		  where 1=1
		  and exists (select division_id from SCM_MST_SITE C WITH(NOLOCK) WHERE 1=1
						and temp_skh_results.division_id        =   C.division_id      
						AND temp_skh_results.scm_site_id        =   C.scm_site_id  
						and c.vmi_yn = 'Y'
						)

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                                     전체 대상추출 (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                 MKT_FCST, RTF 대상 날짜및 값 추출 (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		----------------------------------------------------------------- (1)
		

		---------------------------------- RTF MEASURE MKT_FCST TABLE INSERT (START)
		DELETE FROM DM_PLN_MKT_FCST
		  WHERE MEASURE IN ('RTF_TEST','VMI_In_Plan_TEST')
            and YYYYMMDD >= @c_plan_start_yyyymmdd
			and DIVISION_ID = @c_division_id
			--and exists (
			--		SELECT division_id 
			--			FROM temp_skh_results
			--			where 1=1
			--			and DM_PLN_MKT_FCST.division_id        =   division_id      
			--			AND DM_PLN_MKT_FCST.project_code       =   project_code   
			--			AND DM_PLN_MKT_FCST.scm_site_id        =   scm_site_id  
			--			AND DM_PLN_MKT_FCST.item_id            =   item_id      
			--			AND DM_PLN_MKT_FCST.dom_exp            =   dom_exp      
			--			AND DM_PLN_MKT_FCST.fcst_type          =   fcst_type    
			--			AND DM_PLN_MKT_FCST.incoterms          =   incoterms    
			--			AND DM_PLN_MKT_FCST.plant_site_id      =   plant_site_id
			--			)

		insert into DM_PLN_MKT_FCST
					( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
		SELECT		distinct
				     a.DIVISION_ID
					,a.PROJECT_CODE
					,a.SALES_SITE_ID AS SCM_SITE_ID
					,a.ITEM_ID
					,a.DOM_EXP
					,a.FCST_TYPE
					,a.INCOTERMS
					,CASE  WHEN  b.VMI_YN = 'Y' THEN 'VMI_In_Plan_TEST' ELSE 'RTF_TEST'  END MEASURE
					--,PLANT_SITE_ID 
					,CASE WHEN a.DIVISION_ID = '82' OR a.DIVISION_ID = '40' THEN '' ELSE a.PLANT_SITE_ID END PLANT_SITE_ID
					,a.YYYYMMDD 
					,SUM(a.ALLOCATION_QTY) QTY
					,'TEST_0914' CREATED_BY
					,GETDATE()
					,'TEST_0914' LAST_UPDATED_BY
					,GETDATE()
					,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
		FROM [dbo].[SCP_PLN_RTF_ALLOCATION_V_40_TEST] a WITH(NOLOCK)
			 INNER JOIN temp_skh_results b
 					    ON (a.division_id        =   b.division_id      
						AND a.project_code       =   b.project_code   
						AND a.sales_site_id      =   b.scm_site_id  
						AND a.item_id            =   b.item_id      
						AND a.dom_exp            =   b.dom_exp      
						AND a.fcst_type          =   b.fcst_type    
						AND a.incoterms          =   b.incoterms    
					--	AND a.plant_site_id      =   b.plant_site_id
						)
			WHERE a.DIVISION_ID          = @c_division_id
				and a.plan_id            = @c_plan_id
		GROUP BY a.DIVISION_ID , a.PROJECT_CODE, a.SALES_SITE_ID,a.ITEM_ID, a.DOM_EXP,a.FCST_TYPE, a.INCOTERMS, a.PLANT_SITE_ID, a.YYYYMMDD,b.VMI_YN
		-- 상품인 건에 대해서는 RTF를 MKT FCST와 동일하게 생성 함.
		UNION ALL
		select  
			   a.[DIVISION_ID]
			  ,a.[PROJECT_CODE]
			  ,a.[SCM_SITE_ID]
			  ,a.[ITEM_ID]
			  ,a.[DOM_EXP]
			  ,a.[FCST_TYPE]
			  ,a.[INCOTERMS]
			  ,CASE  WHEN  c.VMI_YN = 'Y' THEN 'VMI_In_Plan_TEST' ELSE 'RTF_TEST'  END
			  ,a.[PLANT_SITE_ID]
			  ,a.[YYYYMMDD]

			  ,SUM( CASE  WHEN  c.VMI_YN = 'Y' AND MEASURE = 'VMI_In_Req' THEN a.qty
			         WHEN  c.VMI_YN <> 'Y' AND MEASURE = 'MKT_FCST' THEN a.qty 
			          ELSE 0  END ) QTY
			 -- ,a.[QTY]
			  ,'SYSTEM'
			  ,GETDATE()
			  ,'SYSTEM'
			  ,GETDATE()
			  ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
		  from DM_PLN_MKT_FCST a WITH(NOLOCK)
			inner join [dbo].[DM_MST_ITEM_SINGLE_V] b WITH(NOLOCK)
				on (a.division_id		= b.division_id
				and a.item_id			= b.item_id)
			inner join temp_skh_results c WITH(NOLOCK)
				on (a.division_id        =   c.division_id      
				AND a.project_code       =   c.project_code   
				AND a.scm_site_id        =   c.scm_site_id  
				AND a.item_id            =   c.item_id      
				AND a.dom_exp            =   c.dom_exp      
				AND a.fcst_type          =   c.fcst_type    
				AND a.incoterms          =   c.incoterms    
				AND a.plant_site_id      =   c.plant_site_id)
		 where a.division_id		= @c_division_id
		   --and a.division_id		<> '40'
		   and a.yyyymmdd			>= @c_plan_start_yyyymmdd
		   and a.measure			IN ( 'VMI_In_Req', 'MKT_FCST' )
		    -- 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
		   and (b.item_type in ('Q' , 'R' ) OR ( a.item_id in ( select k.item_id from scm_mst_item_sn k  WITH (NOLOCK) where k.division_id = a.division_id and k.SCP_OPERATION_GROUP = 'E'  )  ))
          group by a.[DIVISION_ID]
			  ,a.[PROJECT_CODE]
			  ,a.[SCM_SITE_ID]
			  ,a.[ITEM_ID]
			  ,a.[DOM_EXP]
			  ,a.[FCST_TYPE]
			  ,a.[INCOTERMS]
			  ,CASE  WHEN  c.VMI_YN = 'Y' THEN 'VMI_In_Plan_TEST' ELSE 'RTF_TEST'  END
			  ,a.[PLANT_SITE_ID]
			  ,a.[YYYYMMDD]

			
		---------------------------------- RTF MEASURE MKT_FCST TABLE INSERT (END)
		
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                      VMI재고 확인후 RTF 생성 로직 (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		BEGIN
			------------------------------------------------------------------------------------------------
			PRINT 'temp_skh_VMI_MST_MAIN INSERT START                        =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|
					--DELETE FROM temp_skh_VMI_MST_MAIN

					insert into temp_skh_VMI_MST_MAIN
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty)
					select  distinct
												a.DIVISION_ID 				,
												a.PROJECT_CODE 				,
												a.SCM_SITE_ID 				,
												a.ITEM_ID 					,
												a.DOM_EXP 					,
												a.FCST_TYPE 				,
												a.INCOTERMS 				,
												a.measure					,
												a.PLANT_SITE_ID 			,
												b.BASIS_YYYYMMDD   YYYYMMDD ,
												-- ISNULL(c.qty,0) QTY
												-- 20180725 ytchoi vmi stock qty 를 초재고로 적용 (S)
												CASE WHEN b.BASIS_YYYYMMDD = @plan_start_yyyymmdd AND  a.measure in ('Vmi_In_Plan_TEST')  THEN ISNULL(c.qty,0) + ISNULL(( SELECT SUM(s.qty)  
																															  FROM scm_dnm_stock_sn s with(nolock)
																																  ,scm_mst_location l with(nolock)
																															 where l.division_id = s.division_id
																															   and l.SCM_SITE_ID = a.SCM_SITE_ID
																															   and l.storage_id = s.storage_id
																															   and s.item_id like  (case when substring(a.ITEM_ID, 1,2) = 'MP' THEN substring( a.ITEM_ID, 1,11) ELSE a.ITEM_ID END ) +'%' 
																															   and convert( varchar, s.cutoff_date,112)  = @plan_start_yyyymmdd ) ,0)
													 ELSE ISNULL(c.qty,0) END QTY
												-- 20180725 ytchoi vmi stock qty 를 초재고로 적용 (E)
						from ( SELECT DISTINCT W.DIVISION_ID 				,
												W.PROJECT_CODE 				,
												W.SCM_SITE_ID 				,
												W.ITEM_ID 					,
												W.DOM_EXP 					,
												W.FCST_TYPE 				,
												W.INCOTERMS 				,
												W.measure					,
												W.PLANT_SITE_ID 			
									  FROM DM_PLN_MKT_FCST W with(nolock) 
									 -- INNER JOIN SCM_MST_SITE ST WITH(NOLOCK)
									  INNER JOIN temp_skh_results ST WITH(NOLOCK)
										ON  w.division_id        =   st.division_id      
										AND w.project_code       =   st.project_code   
										AND w.scm_site_id        =   st.scm_site_id  
										AND w.item_id            =   st.item_id      
										AND w.dom_exp            =   st.dom_exp      
										AND w.fcst_type          =   st.fcst_type    
										AND w.incoterms          =   st.incoterms    
										AND w.plant_site_id      =   st.plant_site_id
										AND	ST.VMI_YN   = 'Y'  -- vmi대상만 입력

								 WHERE W.YYYYMMDD between @plan_start_yyyymmdd
								AND CONVERT(CHAR(8), DATEADD(WW, 52, @plan_start_yyyymmdd  ),112)  -- SCP PLANNING 구간이 52주
							  ) A
						inner join SCM_SYS_CALENDAR_M  b with(nolock)
							on b.BASIS_YYYYMMDD between @plan_start_yyyymmdd
								AND CONVERT(CHAR(8), DATEADD(WW, 52, @plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주
						left join DM_PLN_MKT_FCST c with(nolock)
							ON		a.division_id		= c.division_id
							AND		a.project_code		= c.project_code
							AND		a.scm_site_id		= c.scm_site_id
							AND		a.item_id			= c.item_id
							AND		a.dom_exp			= c.dom_exp
							AND		a.fcst_type			= c.fcst_type
							AND		a.incoterms			= c.incoterms
							AND		a.plant_site_id		= c.plant_site_id
							and     a.measure			= c.measure
							and     b.BASIS_YYYYMMDD    = c.yyyymmdd
						where 1=1
						and a.measure in ('MKT_FCST', 'Vmi_In_Plan_TEST') -- MKT_FCST랑 VMI_IN_PLAN

			PRINT 'temp_skh_VMI_temp1 INSERT START                         =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|

					INSERT INTO temp_skh_VMI_MST
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty)
					SELECT division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty
					  FROM temp_skh_VMI_MST_MAIN A
						  WHERE 1=1
							and exists (
									SELECT division_id 
										FROM temp_skh_results
										where 1=1
										and a.division_id        =   division_id      
										AND a.project_code       =   project_code   
										AND a.scm_site_id        =   scm_site_id  
										AND a.item_id            =   item_id      
										AND a.dom_exp            =   dom_exp      
										AND a.fcst_type          =   fcst_type    
										AND a.incoterms          =   incoterms    
										AND a.plant_site_id      =   plant_site_id
										and VMI_YN   = 'Y'
										)

					--
					insert into temp_skh_VMI_temp1
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty,accum_sum,last_accum_sum)
					select a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd
						 , min(a.qty) 'qty', sum(b.qty) 'accum_sum', sum(b.qty) - min(a.qty) 'last_accum_sum'
					  from temp_skh_VMI_MST a
						  ,temp_skh_VMI_MST b
					 where a.division_id	= b.DIVISION_ID
					   and a.project_code	= b.project_code
					   and a.scm_site_id	= b.scm_site_id
					   and a.item_id		= b.ITEM_ID
					   and a.fcst_type		= b.FCST_TYPE
					   and a.incoterms		= b.incoterms
					   and a.plant_site_id	= b.PLANT_SITE_ID
					   and a.dom_exp		= b.dom_exp
					   and a.measure		= b.measure
					   and a.measure		= 'MKT_FCST'
					   and a.yyyymmdd		>= @plan_start_yyyymmdd
					   and b.yyyymmdd		>= @plan_start_yyyymmdd
					   and b.yyyymmdd		<= a.yyyymmdd
					group by a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd


					PRINT 'temp_skh_VMI_temp2 INSERT START                         =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
					----------------------------------------------------------|

					insert into temp_skh_VMI_temp2
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty,accum_sum,last_accum_sum)
					select a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd
						 , min(a.qty) 'qty', sum(b.qty) 'accum_sum', sum(b.qty) - min(a.qty) 'last_accum_sum'
					  from temp_skh_VMI_MST a
						  ,temp_skh_VMI_MST b
					 where a.division_id	= b.DIVISION_ID
					   and a.project_code	= b.project_code
					   and a.scm_site_id	= b.scm_site_id
					   and a.item_id		= b.ITEM_ID
					   and a.fcst_type		= b.FCST_TYPE
					   and a.incoterms		= b.incoterms
					   and a.plant_site_id	= b.PLANT_SITE_ID
					   and a.dom_exp		= b.dom_exp
					   and a.measure		= b.measure
					   and a.measure		= 'Vmi_In_Plan_TEST'
					   and a.yyyymmdd		>= @plan_start_yyyymmdd
					   and b.yyyymmdd		>= @plan_start_yyyymmdd
					   and b.yyyymmdd		<= a.yyyymmdd
					group by a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd
					;
			---------------------------------------------------------------------------------------- 

			PRINT 'temp_skh_VMI_temp_all INSERT START                      =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|

			insert into temp_skh_VMI_temp_all
			(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id,yyyymmdd,RTF_QTY,INV)
			select a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.plant_site_id,a.yyyymmdd
				 ,SUM( case when isnull(a.accum_sum,0) > isnull(b.accum_sum,0) then isnull(b.accum_sum,0) else isnull(a.accum_sum,0) end ) - SUM( case when isnull(a.last_accum_sum,0) > isnull(b.last_accum_sum,0) then isnull(b.last_accum_sum,0) else isnull(a.last_accum_sum,0) end ) RTF_QTY
				 , SUM(isnull(b.accum_sum,0) - isnull(a.accum_sum,0)) INV
			  from temp_skh_VMI_temp1 a  --  'MKT_FCST'
				  ,temp_skh_VMI_temp2 b  --  'Vmi_In_Plan_TEST'
			 where a.division_id	= b.DIVISION_ID
			   and a.project_code	= b.project_code
			   and a.scm_site_id	= b.scm_site_id
			   and a.item_id		= b.ITEM_ID
			   and a.fcst_type		= b.FCST_TYPE
			   and a.incoterms		= b.incoterms
			   and a.plant_site_id	= b.PLANT_SITE_ID
			   and a.dom_exp		= b.dom_exp
			   and a.yyyymmdd		= b.YYYYMMDD
			group by a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd
			order by a.yyyymmdd
			;

			PRINT 'DM_PLN_MKT_FCST VMI_Inv DELETE START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|
			---------------------------------- 초기화 (START)
			DELETE 
			FROM dbo.DM_PLN_MKT_FCST
				where MEASURE IN ('VMI_Inv_TEST','RTF_TEST')
					and exists (
							SELECT division_id 
								FROM temp_skh_results
								where 1=1
								and DM_PLN_MKT_FCST.division_id        =   division_id      
								AND DM_PLN_MKT_FCST.project_code       =   project_code   
								AND DM_PLN_MKT_FCST.scm_site_id        =   scm_site_id  
								AND DM_PLN_MKT_FCST.item_id            =   item_id      
								AND DM_PLN_MKT_FCST.dom_exp            =   dom_exp      
								AND DM_PLN_MKT_FCST.fcst_type          =   fcst_type    
								AND DM_PLN_MKT_FCST.incoterms          =   incoterms    
								AND DM_PLN_MKT_FCST.plant_site_id      =   plant_site_id
								AND vmi_yn = 'Y'
								AND DM_PLN_MKT_FCST.yyyymmdd           >=   @plan_start_yyyymmdd  -- 당주월요일
								);
			PRINT 'DM_PLN_MKT_FCST VMI_Inv INSERT START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|
			---------------------------------- 계산된 VMI_Inv값 INSERT (START)
			insert into DM_PLN_MKT_FCST
						( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
						,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
						,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
						,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
						)
			select division_id , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'RTF_TEST' as measure ,plant_site_id, yyyymmdd
				--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
				,rtf_qty as QTY 
				,'TEST_0914',getdate(),'TEST_0914',getdate(), null,null,null,null,null,null,null,null,null,null
			from  temp_skh_VMI_temp_all
			  WHERE yyyymmdd		>= @plan_start_yyyymmdd
				AND rtf_qty > 0 

			union

			select division_id , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'VMI_Inv_TEST' as measure ,plant_site_id, yyyymmdd
				--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
				,INV as QTY 
				,'TEST_0914',getdate(),'TEST_0914',getdate(), null,null,null,null,null,null,null,null,null,null
			from  temp_skh_VMI_temp_all
			  WHERE yyyymmdd		>= @plan_start_yyyymmdd
				AND inv > 0 

			---------------------------------- 계산된 VMI_Inv값 INSERT (END)

		END
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                      VMI재고 확인후 RTF 생성 로직 (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		
		/* -- 임시 주석처리
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                       MKT_FCST_QTY_BALANCE_CREATE (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		BEGIN
		-- 속도이슈로 cursor 구조로 변경
		-- 신규변수
		DECLARE @m_DIVISION_ID         NVARCHAR(MAX);
		DECLARE @m_SCM_SITE_ID         NVARCHAR(MAX);
		DECLARE @m_PROJECT_CODE		   NVARCHAR(MAX);
		DECLARE @m_ITEM_ID			   NVARCHAR(MAX);
		DECLARE @m_DOM_EXP			   NVARCHAR(MAX);
		DECLARE @m_FCST_TYPE		   NVARCHAR(MAX);
		DECLARE @m_INCOTERMS	       NVARCHAR(MAX);
		DECLARE @m_PLANT_SITE_ID	   NVARCHAR(MAX);
		DECLARE @m_vmi_yn			   NVARCHAR(MAX);
		
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR1_MST')
			BEGIN
				CLOSE CURSOR1_MST
				DEALLOCATE CURSOR1_MST
			END;
		DECLARE CURSOR1_MST CURSOR FAST_FORWARD FOR
		SELECT 
			       division_id,scm_site_id,project_code,item_id,dom_exp,fcst_type,incoterms,plant_site_id,max(vmi_yn)
			FROM  temp_skh_results WHERE 1=1
		GROUP BY division_id,scm_site_id,project_code,item_id,dom_exp,fcst_type,incoterms,plant_site_id
		BEGIN
			OPEN CURSOR1_MST;
			FETCH NEXT FROM CURSOR1_MST INTO          -- LOOP수행
									  @m_DIVISION_ID    
									 ,@m_SCM_SITE_ID
									 ,@m_PROJECT_CODE
									 ,@m_ITEM_ID
									 ,@m_DOM_EXP
									 ,@m_FCST_TYPE
									 ,@m_INCOTERMS
									 ,@m_PLANT_SITE_ID
									 ,@m_vmi_yn
		END

		---------------------------------------------------------------------------------------- WHILE_1 LOOP START
		WHILE @@FETCH_STATUS = 0
		----------------------------------------------------------------------------------------
        BEGIN
		
		PRINT '-------------------------------------------------------------------------------------------------------'
		PRINT @m_DIVISION_ID +' '+ @m_SCM_SITE_ID+' '+ @m_PROJECT_CODE+' '+ @m_ITEM_ID+' '+ @m_DOM_EXP+' '+ @m_FCST_TYPE+' '+ @m_INCOTERMS+' '+ @m_PLANT_SITE_ID+' '+ @m_vmi_yn

				/* -- 임시 주석처리					 
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                                                                                                  VMI DIO 계산로직 (START)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				BEGIN

				DECLARE @VMI_DIO_YYYYMMDD			   NVARCHAR(MAX);
				
				PRINT 'DM_PLN_MKT_FCST VMI_DIO DELETE START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
				----------------------------------------------------------|
					-- 수행전 삭제
					DELETE 
					FROM dbo.DM_PLN_MKT_FCST
						where MEASURE = 'VMI_DIO_TEST'
							and exists (
									SELECT division_id 
										FROM temp_skh_results
										where 1=1
										and DM_PLN_MKT_FCST.division_id        =   division_id      
										AND DM_PLN_MKT_FCST.project_code       =   project_code   
										AND DM_PLN_MKT_FCST.scm_site_id        =   scm_site_id  
										AND DM_PLN_MKT_FCST.item_id            =   item_id      
										AND DM_PLN_MKT_FCST.dom_exp            =   dom_exp      
										AND DM_PLN_MKT_FCST.fcst_type          =   fcst_type    
										AND DM_PLN_MKT_FCST.incoterms          =   incoterms    
										AND DM_PLN_MKT_FCST.plant_site_id      =   plant_site_id
										AND vmi_yn = 'Y'
										AND DM_PLN_MKT_FCST.yyyymmdd           >=   @plan_start_yyyymmdd  -- 당주월요일

										AND division_id       = @m_DIVISION_ID
										AND scm_site_id       = @m_SCM_SITE_ID
										AND project_code      = @m_PROJECT_CODE
										AND	item_id		      = @m_ITEM_ID
										AND	dom_exp		      = @m_DOM_EXP
										AND	fcst_type		  = @m_FCST_TYPE
										AND	incoterms		  = @m_INCOTERMS
										AND	plant_site_id	  = @m_PLANT_SITE_ID
										) ;

					IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'vmi_dio_cur')
						BEGIN
							CLOSE vmi_dio_cur
							DEALLOCATE vmi_dio_cur
						END;

					DECLARE VMI_DIO_CUR CURSOR FAST_FORWARD FOR 
						SELECT C.BASIS_YYYYMMDD
							FROM [DBO].[SCM_SYS_CALENDAR_M] C WITH(NOLOCK)
								WHERE C.BASIS_YYYYMMDD  >= @PLAN_START_YYYYMMDD  -- 당주월요일
								AND C.BASIS_YYYYMMDD    <= CONVERT(CHAR(8), DATEADD(WW, 52, @PLAN_START_YYYYMMDD),112)  -- SCP PLANNING 구간이 52주
						ORDER BY C.BASIS_YYYYMMDD

					OPEN vmi_dio_cur

					FETCH NEXT FROM VMI_DIO_CUR INTO @VMI_DIO_YYYYMMDD

				-- 20180907 DIO insert 속도 이슈로 temp 테이블 사용 
				DELETE FROM temp_skh_DIO_TEMP
				
				PRINT 'DM_PLN_MKT_FCST VMI_DIO CURSOR START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
				----------------------------------------------------------|

					----------------------------------------------------------------------------------------- VMI_DIO CURSOR START
					WHILE @@FETCH_STATUS = 0
					-----------------------------------------------------------------------------------------
						BEGIN

							--insert into dbo.DM_PLN_MKT_FCST
							insert into temp_skh_DIO_TEMP  -- 20180907 DIO insert 속도 이슈로 temp 테이블 사용
							( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
								,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							)

							SELECT 
								TOP 1
							   division_id
							  ,project_code
							  ,scm_site_id
							  ,item_id
							  ,dom_exp
							  ,fcst_type
							  ,incoterms
							  ,'VMI_DIO_TEST'         AS MEASURE
							  ,plant_site_id
							  ,@vmi_dio_yyyymmdd AS YYYYMMDD
							  ,CASE WHEN (
											select SUM(QTY)
											from dbo.DM_PLN_MKT_FCST WITH(NOLOCK)
													INNER JOIN temp_skh_results
														ON   DM_PLN_MKT_FCST.division_id        =   temp_skh_results.division_id
														AND  DM_PLN_MKT_FCST.project_code       =   temp_skh_results.project_code
														AND  DM_PLN_MKT_FCST.scm_site_id		=   temp_skh_results.scm_site_id
														AND  DM_PLN_MKT_FCST.item_id            =   temp_skh_results.item_id   
														AND  DM_PLN_MKT_FCST.dom_exp            =   temp_skh_results.dom_exp    
														AND  DM_PLN_MKT_FCST.fcst_type          =   temp_skh_results.fcst_type
														AND  DM_PLN_MKT_FCST.incoterms          =   temp_skh_results.incoterms  
														AND  DM_PLN_MKT_FCST.plant_site_id      =   temp_skh_results.plant_site_id
														AND  temp_skh_results.VMI_YN			= 'Y'  -- VMI 대상만
														AND  temp_skh_results.division_id       =   @m_DIVISION_ID
														AND  temp_skh_results.scm_site_id       =   @m_SCM_SITE_ID
														AND  temp_skh_results.project_code      =   @m_PROJECT_CODE
														AND	 temp_skh_results.item_id		    =   @m_ITEM_ID
														AND	 temp_skh_results.dom_exp		    =   @m_DOM_EXP
														AND	 temp_skh_results.fcst_type		    =   @m_FCST_TYPE
														AND	 temp_skh_results.incoterms		    =   @m_INCOTERMS
														AND	 temp_skh_results.plant_site_id	    =   @m_PLANT_SITE_ID
											where 1=1
												and DM_PLN_MKT_FCST.measure       = 'VMI_Inv_TEST'
												and DM_PLN_MKT_FCST.yyyymmdd      = @vmi_dio_yyyymmdd
										) = 0 THEN 0
									ELSE
										   ISNULL( (
												select min(GAP_DAY) - 0
													from (
													select  CAST( ( cast(yyyymmdd as datetime) - cast ( @vmi_dio_yyyymmdd as datetime) ) AS INT ) GAP_DAY,  qty, SUM(QTY) over ( order by yyyymmdd) accum_sum
														from dbo.DM_PLN_MKT_FCST WITH(NOLOCK)
																INNER JOIN temp_skh_results
																	ON   DM_PLN_MKT_FCST.division_id        =   temp_skh_results.division_id
																	AND  DM_PLN_MKT_FCST.project_code       =   temp_skh_results.project_code
																	AND  DM_PLN_MKT_FCST.scm_site_id		=   temp_skh_results.scm_site_id
																	AND  DM_PLN_MKT_FCST.item_id            =   temp_skh_results.item_id   
																	AND  DM_PLN_MKT_FCST.dom_exp            =   temp_skh_results.dom_exp    
																	AND  DM_PLN_MKT_FCST.fcst_type          =   temp_skh_results.fcst_type
																	AND  DM_PLN_MKT_FCST.incoterms          =   temp_skh_results.incoterms  
																	AND  DM_PLN_MKT_FCST.plant_site_id      =   temp_skh_results.plant_site_id
																	AND  temp_skh_results.VMI_YN			= 'Y'  -- VMI 대상만
																	AND  temp_skh_results.division_id       =   @m_DIVISION_ID
																	AND  temp_skh_results.scm_site_id       =   @m_SCM_SITE_ID
																	AND  temp_skh_results.project_code      =   @m_PROJECT_CODE
																	AND	 temp_skh_results.item_id		    =   @m_ITEM_ID
																	AND	 temp_skh_results.dom_exp		    =   @m_DOM_EXP
																	AND	 temp_skh_results.fcst_type		    =   @m_FCST_TYPE
																	AND	 temp_skh_results.incoterms		    =   @m_INCOTERMS
																	AND	 temp_skh_results.plant_site_id	    =   @m_PLANT_SITE_ID
													where 1=1
														--and DM_PLN_MKT_FCST.measure       = 'RTF_TEST'           --?????
														and DM_PLN_MKT_FCST.measure       = 'Vmi_In_Plan_TEST'           --?????
														and DM_PLN_MKT_FCST.yyyymmdd      > @vmi_dio_yyyymmdd
														) a
												where accum_sum >=  (
																	select SUM(QTY)
																	from dbo.DM_PLN_MKT_FCST WITH(NOLOCK)
																			INNER JOIN temp_skh_results
																				ON   DM_PLN_MKT_FCST.division_id        =   temp_skh_results.division_id
																				AND  DM_PLN_MKT_FCST.project_code       =   temp_skh_results.project_code
																				AND  DM_PLN_MKT_FCST.scm_site_id		=   temp_skh_results.scm_site_id
																				AND  DM_PLN_MKT_FCST.item_id            =   temp_skh_results.item_id   
																				AND  DM_PLN_MKT_FCST.dom_exp            =   temp_skh_results.dom_exp    
																				AND  DM_PLN_MKT_FCST.fcst_type          =   temp_skh_results.fcst_type
																				AND  DM_PLN_MKT_FCST.incoterms          =   temp_skh_results.incoterms  
																				AND  DM_PLN_MKT_FCST.plant_site_id      =   temp_skh_results.plant_site_id
																				AND  temp_skh_results.VMI_YN			= 'Y'  -- VMI 대상만
																				AND  temp_skh_results.division_id       =   @m_DIVISION_ID
																				AND  temp_skh_results.scm_site_id       =   @m_SCM_SITE_ID
																				AND  temp_skh_results.project_code      =   @m_PROJECT_CODE
																				AND	 temp_skh_results.item_id		    =   @m_ITEM_ID
																				AND	 temp_skh_results.dom_exp		    =   @m_DOM_EXP
																				AND	 temp_skh_results.fcst_type		    =   @m_FCST_TYPE
																				AND	 temp_skh_results.incoterms		    =   @m_INCOTERMS
																				AND	 temp_skh_results.plant_site_id	    =   @m_PLANT_SITE_ID
																	where 1=1
																		and DM_PLN_MKT_FCST.measure       = 'VMI_Inv_TEST'  -- Inventory
																		and DM_PLN_MKT_FCST.yyyymmdd      = @vmi_dio_yyyymmdd
																	)
												), 9999)
								   END
								   AS QTY
							  ,'Vmi_Make_TEST',getdate(),'Vmi_Make_TEST',getdate(), null,null,null,null,null,null,null,null,null,null
							from temp_skh_results
								where 1=1
								AND VMI_YN = 'Y' 
								AND  division_id        =   @m_DIVISION_ID
								AND  scm_site_id        =   @m_SCM_SITE_ID
								AND  project_code       =   @m_PROJECT_CODE
								AND	 item_id		    =   @m_ITEM_ID
								AND	 dom_exp		    =   @m_DOM_EXP
								AND	 fcst_type		    =   @m_FCST_TYPE
								AND	 incoterms		    =   @m_INCOTERMS
								AND	 plant_site_id	    =   @m_PLANT_SITE_ID

							FETCH NEXT FROM VMI_DIO_CUR INTO @VMI_DIO_YYYYMMDD
						END 
					----------------------------------------------------------------------------------------- VMI_DIO CURSOR END
					CLOSE VMI_DIO_CUR
					DEALLOCATE  VMI_DIO_CUR

					-- 20180907 DIO insert 속도 이슈로 temp 테이블 사용
					insert into dbo.DM_PLN_MKT_FCST
					( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
						,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
						,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
						,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
					SELECT  
					  DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
						,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
						,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
						,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					  FROM temp_skh_DIO_TEMP

				END
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                                                                                                  VMI DIO 계산로직 (END)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				*/
		-- LOOP수행전 초기화
		DELETE FROM temp_skh_MST  
		DELETE FROM temp_skh_TEMP1
		DELETE FROM temp_skh_TEMP2
		DELETE FROM temp_skh_TEMPX

		INSERT INTO temp_skh_MST
		       (DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID,MEASURE,YYYYMMDD,QTY)
		SELECT ZZ.division_id, ZZ.project_code, ZZ.scm_site_id, ZZ.item_id, ZZ.dom_exp, ZZ.fcst_type, ZZ.incoterms, ZZ.plant_site_id, ZZ.MEASURE, ZZ.YYYYMMDD, max(ISNULL(C.QTY,0))
		  FROM 
			 (
			  SELECT * from 
			  (
				SELECT A.division_id, A.project_code, A.scm_site_id, A.item_id, A.dom_exp, A.fcst_type, A.incoterms, A.plant_site_id
				  FROM temp_skh_results A
			   ) TARGET_DATA
			   ,(
				SELECT 'MKT_FCST' MEASURE
				UNION ALL
				SELECT 'RTF_TEST' MEASURE
				UNION ALL
				SELECT 'Vmi_In_Plan_TEST' MEASURE
			   ) MEASURE
			   ,		(
						SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
						  FROM SCM_SYS_CALENDAR_M C
						 WHERE C.BASIS_YYYYMMDD between @plan_start_yyyymmdd AND CONVERT(CHAR(8), DATEADD(WW, 52, @plan_start_yyyymmdd  ),112)  -- SCP PLANNING 구간이 52주
						   AND ((  C.PARTIAL_YN   = 'Y' AND C.END_FLAG ='Y' ) OR  ( C.DAYOFWEEK IN ('SUN') ) )
						UNION all
						select	C.YYYYMMDD AS YYYYMMDD
							from temp_skh_results rslt
							inner JOIN DM_PLN_MKT_FCST C WITH(NOLOCK)
								ON		rslt.division_id		= C.DIVISION_ID
								AND		rslt.project_code		= C.PROJECT_CODE
								AND		rslt.scm_site_id		= C.SCM_SITE_ID
								AND		rslt.item_id			= C.ITEM_ID
								AND		rslt.dom_exp			= C.DOM_EXP
								AND		rslt.fcst_type		    = C.FCST_TYPE
								AND		rslt.incoterms		    = C.INCOTERMS
								AND		rslt.plant_site_id	    = C.PLANT_SITE_ID
								AND     C.MEASURE		       IN ('MKT_FCST','RTF_TEST','Vmi_In_Plan_TEST')
								AND     C.QTY > 0
								AND		C.YYYYMMDD between @plan_start_yyyymmdd AND CONVERT(CHAR(8), DATEADD(WW, 52, @plan_start_yyyymmdd  ),112)  -- SCP PLANNING 구간이 52주

								AND rslt.division_id       = @m_DIVISION_ID
								AND rslt.scm_site_id       = @m_SCM_SITE_ID
								AND rslt.project_code      = @m_PROJECT_CODE
								AND	rslt.item_id		   = @m_ITEM_ID
								AND	rslt.dom_exp		   = @m_DOM_EXP
								AND	rslt.fcst_type		   = @m_FCST_TYPE
								AND	rslt.incoterms		   = @m_INCOTERMS
								AND	rslt.plant_site_id	   = @m_PLANT_SITE_ID

								AND C.DIVISION_ID          = @m_DIVISION_ID
								AND C.SCM_SITE_ID          = @m_SCM_SITE_ID
								AND C.PROJECT_CODE         = @m_PROJECT_CODE
								AND	C.ITEM_ID		       = @m_ITEM_ID
								AND	C.DOM_EXP		       = @m_DOM_EXP
								AND	C.FCST_TYPE		       = @m_FCST_TYPE
								AND	C.INCOTERMS		       = @m_INCOTERMS
								AND	C.PLANT_SITE_ID		   = @m_PLANT_SITE_ID
						) DS
				) ZZ
				LEFT JOIN DM_PLN_MKT_FCST C
												ON		ZZ.division_id		= C.DIVISION_ID
												AND		ZZ.project_code		= C.PROJECT_CODE
												AND		ZZ.scm_site_id		= C.SCM_SITE_ID
												AND		ZZ.item_id			= C.ITEM_ID
												AND		ZZ.dom_exp			= C.DOM_EXP
												AND		ZZ.fcst_type		= C.FCST_TYPE
												AND		ZZ.incoterms		= C.INCOTERMS
												AND		ZZ.plant_site_id	= C.PLANT_SITE_ID
												AND     ZZ.MEASURE          = C.MEASURE
												AND     ZZ.YYYYMMDD         = C.YYYYMMDD
												AND     C.DIVISION_ID       = @m_DIVISION_ID
												AND     C.SCM_SITE_ID       = @m_SCM_SITE_ID
												AND     C.PROJECT_CODE      = @m_PROJECT_CODE
												AND	    C.ITEM_ID		    = @m_ITEM_ID
												AND	    C.DOM_EXP		    = @m_DOM_EXP
												AND	    C.FCST_TYPE		    = @m_FCST_TYPE
												AND	    C.INCOTERMS		    = @m_INCOTERMS
												AND	    C.PLANT_SITE_ID		= @m_PLANT_SITE_ID

		group by ZZ.division_id, ZZ.project_code, ZZ.scm_site_id, ZZ.item_id, ZZ.dom_exp, ZZ.fcst_type, ZZ.incoterms, ZZ.plant_site_id, ZZ.MEASURE,ZZ.YYYYMMDD
		ORDER BY ZZ.division_id, ZZ.project_code, ZZ.scm_site_id, ZZ.item_id, ZZ.dom_exp, ZZ.fcst_type, ZZ.incoterms, ZZ.plant_site_id, ZZ.MEASURE,ZZ.YYYYMMDD

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                 MKT_FCST, RTF 대상 날짜및 값 추출 (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		PRINT N'BALANCE temp_skh_TEMP1 INSERT                           =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		INSERT INTO temp_skh_TEMP1
		( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID ,YYYYMMDD,MEASURE,QTY,ACCUM_SUM)
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID,A.YYYYMMDD, A.MEASURE, MIN(A.QTY) AS QTY, SUM(B.QTY) AS ACCUM_SUM
		
		  FROM temp_skh_MST A
			  ,temp_skh_MST B
		 WHERE A.DIVISION_ID		  = B.DIVISION_ID
			AND A.PROJECT_CODE		  = B.PROJECT_CODE
			AND A.SCM_SITE_ID		  = B.SCM_SITE_ID
			AND A.ITEM_ID			  = B.ITEM_ID
			AND A.FCST_TYPE			  = B.FCST_TYPE
			AND A.INCOTERMS			  = B.INCOTERMS
			AND A.PLANT_SITE_ID		  = B.PLANT_SITE_ID
			AND A.DOM_EXP			  = B.DOM_EXP
			AND A.MEASURE			  = B.MEASURE
			AND A.MEASURE			  = 'MKT_FCST'
			AND A.YYYYMMDD			 >= @plan_start_yyyymmdd
			AND B.YYYYMMDD			 >= @plan_start_yyyymmdd
			AND B.YYYYMMDD			 <= A.YYYYMMDD

			AND A.DIVISION_ID         = @m_DIVISION_ID
			AND A.SCM_SITE_ID         = @m_SCM_SITE_ID
			AND A.PROJECT_CODE        = @m_PROJECT_CODE
			AND	A.ITEM_ID		      = @m_ITEM_ID
			AND	A.DOM_EXP		      = @m_DOM_EXP
			AND	A.FCST_TYPE		      = @m_FCST_TYPE
			AND	A.INCOTERMS		      = @m_INCOTERMS
			AND	A.PLANT_SITE_ID		  = @m_PLANT_SITE_ID

			AND B.DIVISION_ID         = @m_DIVISION_ID
			AND B.SCM_SITE_ID         = @m_SCM_SITE_ID
			AND B.PROJECT_CODE        = @m_PROJECT_CODE
			AND	B.ITEM_ID		      = @m_ITEM_ID
			AND	B.DOM_EXP		      = @m_DOM_EXP
			AND	B.FCST_TYPE		      = @m_FCST_TYPE
			AND	B.INCOTERMS		      = @m_INCOTERMS
			AND	B.PLANT_SITE_ID		  = @m_PLANT_SITE_ID
		GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID,A.YYYYMMDD


		PRINT N'BALANCE temp_skh_TEMP2 INSERT                           =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		INSERT INTO temp_skh_TEMP2
		( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID ,YYYYMMDD,MEASURE,QTY,ACCUM_SUM)
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID,A.YYYYMMDD, A.MEASURE, MIN(A.QTY) AS QTY, SUM(B.QTY) AS ACCUM_SUM
		
		  FROM temp_skh_MST A WITH(NOLOCK)
			  ,temp_skh_MST B WITH(NOLOCK)
		 WHERE A.DIVISION_ID		  = B.DIVISION_ID
			AND A.PROJECT_CODE		  = B.PROJECT_CODE
			AND A.SCM_SITE_ID		  = B.SCM_SITE_ID
			AND A.ITEM_ID			  = B.ITEM_ID
			AND A.FCST_TYPE			  = B.FCST_TYPE
			AND A.INCOTERMS			  = B.INCOTERMS
			AND A.PLANT_SITE_ID		  = B.PLANT_SITE_ID
			AND A.DOM_EXP			  = B.DOM_EXP
			AND A.MEASURE			  = B.MEASURE
			AND A.MEASURE			  = case when @m_vmi_yn = 'Y' then 'Vmi_In_Plan_TEST' else 'RTF_TEST' end
			AND A.YYYYMMDD			 >= @plan_start_yyyymmdd
			AND B.YYYYMMDD			 >= @plan_start_yyyymmdd
			AND B.YYYYMMDD			 <= A.YYYYMMDD

			AND A.DIVISION_ID         = @m_DIVISION_ID
			AND A.SCM_SITE_ID         = @m_SCM_SITE_ID
			AND A.PROJECT_CODE        = @m_PROJECT_CODE
			AND	A.ITEM_ID		      = @m_ITEM_ID
			AND	A.DOM_EXP		      = @m_DOM_EXP
			AND	A.FCST_TYPE		      = @m_FCST_TYPE
			AND	A.INCOTERMS		      = @m_INCOTERMS
			AND	A.PLANT_SITE_ID		  = @m_PLANT_SITE_ID

			AND B.DIVISION_ID         = @m_DIVISION_ID
			AND B.SCM_SITE_ID         = @m_SCM_SITE_ID
			AND B.PROJECT_CODE        = @m_PROJECT_CODE
			AND	B.ITEM_ID		      = @m_ITEM_ID
			AND	B.DOM_EXP		      = @m_DOM_EXP
			AND	B.FCST_TYPE		      = @m_FCST_TYPE
			AND	B.INCOTERMS		      = @m_INCOTERMS
			AND	B.PLANT_SITE_ID		  = @m_PLANT_SITE_ID

		GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID,A.YYYYMMDD


		PRINT N'BALANCE temp_skh_TEMPX INSERT                           =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
--  기존로직

		INSERT INTO temp_skh_TEMPX
		( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID ,YYYYMMDD,MEASURE,ACCUM_X)
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID,A.YYYYMMDD, A.MEASURE, SUM(B.ACCUM_SUM - A.ACCUM_SUM) AS ACCUM_X
		
		FROM temp_skh_TEMP1 A
			,temp_skh_TEMP2 B
		WHERE A.DIVISION_ID			  = B.DIVISION_ID
			AND A.PROJECT_CODE		  = B.PROJECT_CODE
			AND A.SCM_SITE_ID		  = B.SCM_SITE_ID
			AND A.ITEM_ID			  = B.ITEM_ID
			AND A.FCST_TYPE			  = B.FCST_TYPE
			AND A.INCOTERMS			  = B.INCOTERMS
			AND A.PLANT_SITE_ID		  = B.PLANT_SITE_ID
			AND A.DOM_EXP			  = B.DOM_EXP
			AND A.YYYYMMDD			  = B.YYYYMMDD

			AND A.DIVISION_ID         = @m_DIVISION_ID
			AND A.SCM_SITE_ID         = @m_SCM_SITE_ID
			AND A.PROJECT_CODE        = @m_PROJECT_CODE
			AND	A.ITEM_ID		      = @m_ITEM_ID
			AND	A.DOM_EXP		      = @m_DOM_EXP
			AND	A.FCST_TYPE		      = @m_FCST_TYPE
			AND	A.INCOTERMS		      = @m_INCOTERMS
			AND	A.PLANT_SITE_ID		  = @m_PLANT_SITE_ID

			AND B.DIVISION_ID         = @m_DIVISION_ID
			AND B.SCM_SITE_ID         = @m_SCM_SITE_ID
			AND B.PROJECT_CODE        = @m_PROJECT_CODE
			AND	B.ITEM_ID		      = @m_ITEM_ID
			AND	B.DOM_EXP		      = @m_DOM_EXP
			AND	B.FCST_TYPE		      = @m_FCST_TYPE
			AND	B.INCOTERMS		      = @m_INCOTERMS
			AND	B.PLANT_SITE_ID		  = @m_PLANT_SITE_ID

		GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID,A.YYYYMMDD


		PRINT N'BALANCE DM_PLN_MKT_FCST DELETE                  =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		---------------------------------- 초기화 (START)
		DELETE 
		FROM dbo.DM_PLN_MKT_FCST
			where MEASURE = 'BALANCE_TEST'
			and exists (
					SELECT division_id 
						FROM temp_skh_TEMPX 
						where 1=1
						and DM_PLN_MKT_FCST.division_id        =   division_id      
						AND DM_PLN_MKT_FCST.project_code       =   project_code   
						AND DM_PLN_MKT_FCST.scm_site_id        =   scm_site_id  
						AND DM_PLN_MKT_FCST.item_id            =   item_id      
						AND DM_PLN_MKT_FCST.dom_exp            =   dom_exp      
						AND DM_PLN_MKT_FCST.fcst_type          =   fcst_type    
						AND DM_PLN_MKT_FCST.incoterms          =   incoterms    
						AND DM_PLN_MKT_FCST.plant_site_id      =   plant_site_id
						AND DM_PLN_MKT_FCST.yyyymmdd           >=  @plan_start_yyyymmdd
						AND DIVISION_ID         = @m_DIVISION_ID
						AND SCM_SITE_ID         = @m_SCM_SITE_ID
						AND PROJECT_CODE        = @m_PROJECT_CODE
						AND	ITEM_ID				= @m_ITEM_ID
						AND	DOM_EXP				= @m_DOM_EXP
						AND	FCST_TYPE		    = @m_FCST_TYPE
						AND	INCOTERMS		    = @m_INCOTERMS
						AND	PLANT_SITE_ID		= @m_PLANT_SITE_ID
					) 
				AND DIVISION_ID         = @m_DIVISION_ID
				AND SCM_SITE_ID         = @m_SCM_SITE_ID
				AND PROJECT_CODE        = @m_PROJECT_CODE
				AND	ITEM_ID		        = @m_ITEM_ID
				AND	DOM_EXP		        = @m_DOM_EXP
				AND	FCST_TYPE		    = @m_FCST_TYPE
				AND	INCOTERMS		    = @m_INCOTERMS
				AND	PLANT_SITE_ID		= @m_PLANT_SITE_ID
				;
		---------------------------------- 초기화 (END)
					

		PRINT N'BALANCE DM_PLN_MKT_FCST insert                  =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		---------------------------------- 계산된 BALANCE값 INSERT (START)
		insert into DM_PLN_MKT_FCST
					( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
		select division_id , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms,'BALANCE_TEST' measure ,plant_site_id, yyyymmdd, ACCUM_X
			,'BALANCE_MAKE_TEST',getdate(),'BALANCE_MAKE_TEST',getdate(), null,null,null,null,null,null,null,null,null,null
		from  temp_skh_TEMPX
			WHERE yyyymmdd		>= @plan_start_yyyymmdd
				AND DIVISION_ID         = @m_DIVISION_ID
				AND SCM_SITE_ID         = @m_SCM_SITE_ID
				AND PROJECT_CODE        = @m_PROJECT_CODE
				AND	ITEM_ID		        = @m_ITEM_ID
				AND	DOM_EXP		        = @m_DOM_EXP
				AND	FCST_TYPE		    = @m_FCST_TYPE
				AND	INCOTERMS		    = @m_INCOTERMS
				AND	PLANT_SITE_ID		= @m_PLANT_SITE_ID
				AND ACCUM_X BETWEEN -9999999999 AND 9999999999  -- 오버플로우 예방
				AND ACCUM_X <> 0                                -- ZERO 값은 불필요
		---------------------------------- 계산된 BALANCE값 INSERT (END)

		FETCH NEXT FROM CURSOR1_MST INTO 
									  @m_DIVISION_ID    
									 ,@m_SCM_SITE_ID   
									 ,@m_PROJECT_CODE
									 ,@m_ITEM_ID
									 ,@m_DOM_EXP
									 ,@m_FCST_TYPE
									 ,@m_INCOTERMS
									 ,@m_PLANT_SITE_ID
									 ,@m_vmi_yn
		---------------------------------------------------------------------------------------- 
        END;
		---------------------------------------------------------------------------------------- WHILE_1 LOOP END

		CLOSE CURSOR1_MST;  
        DEALLOCATE CURSOR1_MST;

		END
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                       MKT_FCST_QTY_BALANCE_CREATE (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		*/

/*  -- 임시 주석처리
		PRINT N'EXECUTE SALES_PLAN_AMT_CREATE_LOCAL_KRW         =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		---------------------------------------------------------------------------------------- 20180607 KHSONG Sales Plan AMT Create Procedure 호출추가 
		EXEC	[dbo].[PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW]	
					@c_division_id
					, 'SYSTEM'

*/

/*  -- 임시 주석처리
		---------------------------------------------------------------------------------------- 20180614 KHSONG CUTOFF RTF MEASURE 정보변경 로직 추가 START

		BEGIN
		PRINT N'mkt_fcst  Cutoff delete START                   =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		-- mkt_fcst  Cutoff 정보 변경
		IF  ISNULL((SELECT COUNT(1) FROM DM_PLN_MKT_FCST_c 
									where 1=1
									and cutoff_yyyymmdd >= @plan_start_yyyymmdd  -- 당주월요일부터
									and cutoff_type = 'MF_W'
									and measure IN ('RTF_TEST','Vmi_In_Plan_TEST')
									and DIVISION_ID = @c_division_id
									and exists (
											SELECT division_id 
												FROM temp_skh_results
												where 1=1
												and DM_PLN_MKT_FCST_c.division_id        =   division_id      
												AND DM_PLN_MKT_FCST_c.project_code       =   project_code   
												AND DM_PLN_MKT_FCST_c.scm_site_id        =   scm_site_id  
												AND DM_PLN_MKT_FCST_c.item_id            =   item_id      
												AND DM_PLN_MKT_FCST_c.dom_exp            =   dom_exp      
												AND DM_PLN_MKT_FCST_c.fcst_type          =   fcst_type    
												AND DM_PLN_MKT_FCST_c.incoterms          =   incoterms    
												AND DM_PLN_MKT_FCST_c.plant_site_id      =   plant_site_id
												) ),0) > 0
			BEGIN
				delete DM_PLN_MKT_FCST_c 
					where 1=1
					and cutoff_yyyymmdd >= @plan_start_yyyymmdd  -- 당주월요일부터
					and cutoff_type = 'MF_W'
					and measure IN ('RTF_TEST','Vmi_In_Plan_TEST')
					and DIVISION_ID = @c_division_id
					and exists (
							SELECT division_id 
								FROM temp_skh_results
								where 1=1
								and DM_PLN_MKT_FCST_c.division_id        =   division_id      
								AND DM_PLN_MKT_FCST_c.project_code       =   project_code   
								AND DM_PLN_MKT_FCST_c.scm_site_id        =   scm_site_id  
								AND DM_PLN_MKT_FCST_c.item_id            =   item_id      
								AND DM_PLN_MKT_FCST_c.dom_exp            =   dom_exp      
								AND DM_PLN_MKT_FCST_c.fcst_type          =   fcst_type    
								AND DM_PLN_MKT_FCST_c.incoterms          =   incoterms    
								AND DM_PLN_MKT_FCST_c.plant_site_id      =   plant_site_id
								) 
			END

		PRINT N'mkt_fcst  Cutoff insert START                   =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		-- 삭제한 version 에 대해서 각각 만들어야 함.
		insert into DM_PLN_MKT_FCST_c
			(
			 DIVISION_ID
			,VERSION_NO
			,CUTOFF_TYPE
			,CUTOFF_YYYYMMDD
			,PROJECT_CODE
			,SCM_SITE_ID
			,ITEM_ID
			,DOM_EXP
			,FCST_TYPE
			,INCOTERMS
			,MEASURE
			,PLANT_SITE_ID
			,YYYYMMDD
			,QTY
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
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
			)
		select a.[DIVISION_ID]
				,b.[VERSION_NO]
				,b.[CUTOFF_TYPE]
				,b.[CUTOFF_YYYYMMDD]
				,[PROJECT_CODE]
				,[SCM_SITE_ID]
				,[ITEM_ID]
				,[DOM_EXP]
				,[FCST_TYPE]
				,[INCOTERMS]
				,[MEASURE]
				,[PLANT_SITE_ID]
				,[YYYYMMDD]
				,[QTY]
				,[CREATED_BY]
				,[CREATION_DATE]
				,'RTF_UPDATE'
				,getdate()
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
			from DM_PLN_MKT_FCST a with(nolock)
				,(
			select distinct division_id, a.version_no, cutoff_type, cutoff_yyyymmdd
				from DM_PLN_MKT_FCST_c a with(nolock)
			where 1=1
				and cutoff_yyyymmdd >= @plan_start_yyyymmdd  -- 당주월요일부터
				and cutoff_type = 'MF_W'
			) b
			where yyyymmdd >= @plan_start_yyyymmdd  -- 당주월요일부터
			and measure IN ('RTF_TEST','Vmi_In_Plan_TEST')
			and qty > 0
			and a.division_id = b.division_id
			and a.division_id = @c_division_id
			and exists (
					SELECT division_id 
						FROM temp_skh_results
						where 1=1
						and a.division_id        =   division_id      
						AND a.project_code       =   project_code   
						AND a.scm_site_id        =   scm_site_id  
						AND a.item_id            =   item_id      
						AND a.dom_exp            =   dom_exp      
						AND a.fcst_type          =   fcst_type    
						AND a.incoterms          =   incoterms    
						AND a.plant_site_id      =   plant_site_id
						) 
		;
		---------------------------------------------------------------------------------------- 20180618 KHSONG CUTOFF TABLE BALANCE 값 재계산 로직 추가 START
		PRINT N'mkt_fcst  Cutoff VERSION_NO SELECT              =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
			delete from @cutoff  -- insert 전 초기화

			INSERT INTO @cutoff  -- 작업대상 cutoff version insert
			SELECT 	  VERSION_NO
				FROM  DM_PLN_MKT_FCST_C WITH(NOLOCK)	
					WHERE 1=1
						and division_id = @c_division_id
						and cutoff_yyyymmdd >= @plan_start_yyyymmdd  -- 당주월요일부터
						and cutoff_type = 'MF_W'
						and exists (
								SELECT division_id 
									FROM temp_skh_results
									where 1=1
									and DM_PLN_MKT_FCST_c.division_id        =   division_id      
									AND DM_PLN_MKT_FCST_c.project_code       =   project_code   
									AND DM_PLN_MKT_FCST_c.scm_site_id        =   scm_site_id  
									AND DM_PLN_MKT_FCST_c.item_id            =   item_id      
									AND DM_PLN_MKT_FCST_c.dom_exp            =   dom_exp      
									AND DM_PLN_MKT_FCST_c.fcst_type          =   fcst_type    
									AND DM_PLN_MKT_FCST_c.incoterms          =   incoterms    
									AND DM_PLN_MKT_FCST_c.plant_site_id      =   plant_site_id
									) 
			GROUP BY VERSION_NO
			ORDER BY VERSION_NO

			-- 확인용
			--select '@cutoff'
			--select * from @cutoff

			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR2_CUTOFF')
				BEGIN
					CLOSE CURSOR2_CUTOFF
					DEALLOCATE CURSOR2_CUTOFF
				END;

			DECLARE CURSOR2_CUTOFF CURSOR FAST_FORWARD FOR
			SELECT 	  VERSION_NO	FROM  @cutoff	

		BEGIN
			OPEN CURSOR2_CUTOFF;
			FETCH NEXT FROM CURSOR2_CUTOFF  INTO  @c_VERSION_NO
		END

		----------------------------------------------------------------------------------------
		--③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③ CURSOR2_CUTOFF VERSION_NO별 LOOP START
		WHILE @@FETCH_STATUS = 0
		----------------------------------------------------------------------------------------
		BEGIN
		----------------------------------------------------------------------------------------
		
		IF OBJECT_ID (N'tempdb..temp_skh_CUTOFF_RAW_TABLE', N'U') IS NOT NULL 
			DROP TABLE temp_skh_CUTOFF_RAW_TABLE
		IF OBJECT_ID (N'tempdb..temp_skh_CUTOFF_TEMP', N'U') IS NOT NULL 
			DROP TABLE temp_skh_CUTOFF_TEMP
		IF OBJECT_ID (N'tempdb..temp_skh_CUTOFF_MST', N'U') IS NOT NULL 
			DROP TABLE temp_skh_CUTOFF_MST

		--임시확인용
		IF OBJECT_ID (N'dbo.temp_skh_CUTOFF_RAW_TABLE', N'U') IS NOT NULL 
			DROP TABLE temp_skh_CUTOFF_RAW_TABLE
		IF OBJECT_ID (N'dbo.temp_skh_CUTOFF_TEMP', N'U') IS NOT NULL 
			DROP TABLE temp_skh_CUTOFF_TEMP
		IF OBJECT_ID (N'dbo.temp_skh_CUTOFF_MST', N'U') IS NOT NULL 
			DROP TABLE temp_skh_CUTOFF_MST
		--임시확인용

		----------------------------------------------------------------- (1)
			SELECT				DISTINCT 
								DIVISION_ID 			,
								VERSION_NO,
								CUTOFF_TYPE,
								CUTOFF_YYYYMMDD,
								PROJECT_CODE 			,
								SCM_SITE_ID 			,
								ITEM_ID 				,
								DOM_EXP 				,
								FCST_TYPE 				,
								INCOTERMS 				,
								PLANT_SITE_ID 			,
								b.BASIS_YYYYMMDD   YYYYMMDD
			INTO  temp_skh_CUTOFF_MST
			FROM DM_PLN_MKT_FCST_C	 a WITH(NOLOCK)
				, SCM_SYS_CALENDAR_M  b WITH(NOLOCK)
				WHERE		a.DIVISION_ID	= @c_division_id
					AND		b.BASIS_YYYYMMDD BETWEEN @c_plan_start_yyyymmdd  AND CONVERT(CHAR(8), DATEADD(WW, 52, @c_plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주
					AND		a.MEASURE		IN ('MKT_FCST','RTF_TEST','Vmi_In_Plan_TEST')
					AND		a.VERSION_NO	= @c_VERSION_NO
					and exists (
							SELECT division_id 
								FROM temp_skh_results
								where 1=1
								and a.division_id        =   division_id      
								AND a.project_code       =   project_code   
								AND a.scm_site_id        =   scm_site_id  
								AND a.item_id            =   item_id      
								AND a.dom_exp            =   dom_exp      
								AND a.fcst_type          =   fcst_type    
								AND a.incoterms          =   incoterms    
								AND a.plant_site_id      =   plant_site_id
								) 

	
		SELECT		temp_skh_CUTOFF_MST.*, 
					ISNULL(T1.QTY,0) AS MKT_FCST,
					ISNULL(T2.QTY,0) AS RTF
		INTO temp_skh_CUTOFF_RAW_TABLE
		FROM		temp_skh_CUTOFF_MST
		LEFT JOIN 
					( 
					SELECT *
						FROM DM_PLN_MKT_FCST_C WITH(NOLOCK)
							WHERE MEASURE		= 'MKT_FCST'
							AND YYYYMMDD		>= @c_plan_start_yyyymmdd
							AND DIVISION_ID		=  @c_division_id
							AND	VERSION_NO		=  @c_VERSION_NO
					) T1
		ON			T1.DIVISION_ID 		 =  temp_skh_CUTOFF_MST.DIVISION_ID 		
		AND			T1.PROJECT_CODE 	 =  temp_skh_CUTOFF_MST.PROJECT_CODE 	
		AND			T1.SCM_SITE_ID 		 =  temp_skh_CUTOFF_MST.SCM_SITE_ID 		
		AND 		T1.ITEM_ID 			 =  temp_skh_CUTOFF_MST.ITEM_ID 			
		AND 		T1.DOM_EXP 			 =  temp_skh_CUTOFF_MST.DOM_EXP 			
		AND 		T1.FCST_TYPE 		 =  temp_skh_CUTOFF_MST.FCST_TYPE 		
		AND 		T1.INCOTERMS 		 =  temp_skh_CUTOFF_MST.INCOTERMS 		
		AND 		T1.PLANT_SITE_ID 	 =  temp_skh_CUTOFF_MST.PLANT_SITE_ID 	
		AND 		T1.YYYYMMDD 		 =  temp_skh_CUTOFF_MST.YYYYMMDD

		LEFT JOIN	(

					SELECT *
						FROM DM_PLN_MKT_FCST_C WITH(NOLOCK)
							WHERE MEASURE		IN ('RTF_TEST','Vmi_In_Plan_TEST')
							AND YYYYMMDD		>= @c_plan_start_yyyymmdd
							AND DIVISION_ID		=  @c_division_id
							AND	VERSION_NO		=  @c_VERSION_NO
					) T2
		ON			temp_skh_CUTOFF_MST.DIVISION_ID 		=   T2.DIVISION_ID 		
		AND			temp_skh_CUTOFF_MST.PROJECT_CODE 		=   T2.PROJECT_CODE 	
		AND			temp_skh_CUTOFF_MST.SCM_SITE_ID 		=   T2.SCM_SITE_ID 		
		AND 		temp_skh_CUTOFF_MST.ITEM_ID 			=   T2.ITEM_ID 			
		AND 		temp_skh_CUTOFF_MST.DOM_EXP 			=   T2.DOM_EXP 			
		AND 		temp_skh_CUTOFF_MST.FCST_TYPE 			=   T2.FCST_TYPE 		
		AND 		temp_skh_CUTOFF_MST.INCOTERMS 			=   T2.INCOTERMS 		
		AND 		temp_skh_CUTOFF_MST.PLANT_SITE_ID 		=   T2.PLANT_SITE_ID 	
		AND			temp_skh_CUTOFF_MST.YYYYMMDD			=   T2.YYYYMMDD			
	--	WHERE ISNULL(T1.QTY,0)				<> ISNULL(T2.QTY,0)  -- 20180524 modify
		;
		
		----------------------------------------------------------------- (1)
		SELECT		DISTINCT
					DIVISION_ID,
					VERSION_NO,
					CUTOFF_TYPE,
					CUTOFF_YYYYMMDD,
					PROJECT_CODE,
					SCM_SITE_ID,
					ITEM_ID,
					DOM_EXP,
					FCST_TYPE,
					INCOTERMS,
					PLANT_SITE_ID,
				-- modified by ytchoi 180611  
				--	@c_plan_start_yyyymmdd AS YYYYMMDD,
					CONVERT(CHAR(8), DATEADD(DD,-1,@c_plan_start_yyyymmdd), 112) AS YYYYMMDD,
					0 AS GAP
		INTO temp_skh_CUTOFF_TEMP
			FROM temp_skh_CUTOFF_RAW_TABLE

			DECLARE @CUTOFF_YYYYMMDD AS NVARCHAR(8)
			DECLARE CUTOFF_CUR_TEMP CURSOR FOR
		
			SELECT BASIS_YYYYMMDD
				FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
					WHERE BASIS_YYYYMMDD BETWEEN @c_plan_start_yyyymmdd  
					AND CONVERT(CHAR(8), DATEADD(WW, 52, @c_plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주

			OPEN CUTOFF_CUR_TEMP;

			FETCH NEXT FROM CUTOFF_CUR_TEMP
				INTO @CUTOFF_YYYYMMDD

		--------------------------------------------- 
		--④④④④④④④④④④④④④  CUTOFF_CUR_TEMP START
		--------------------------------------------- 

			---------------------------------- 
			WHILE (@@FETCH_STATUS = 0)
			---------------------------------- 

			BEGIN

				INSERT INTO  temp_skh_CUTOFF_TEMP
					SELECT
						T1.DIVISION_ID,
						T1.VERSION_NO,
						T1.CUTOFF_TYPE,
						T1.CUTOFF_YYYYMMDD,
						T1.PROJECT_CODE,
						T1.SCM_SITE_ID,
						T1.ITEM_ID,
						T1.DOM_EXP,
						T1.FCST_TYPE,
						T1.INCOTERMS,
						T1.PLANT_SITE_ID,
						@CUTOFF_YYYYMMDD		AS YYYYMMDD,
						ISNULL(GAP,0) + (ISNULL(RTF,0) - ISNULL(MKT_FCST,0)) AS GAP
			
						FROM temp_skh_CUTOFF_TEMP T1
							LEFT JOIN temp_skh_CUTOFF_RAW_TABLE T2
							ON			T1.DIVISION_ID 		 =   T2.DIVISION_ID 		
							AND			T1.PROJECT_CODE 	 =   T2.PROJECT_CODE 	
							AND			T1.SCM_SITE_ID 		 =   T2.SCM_SITE_ID 		
							AND 		T1.ITEM_ID 			 =   T2.ITEM_ID 			
							AND 		T1.DOM_EXP 			 =   T2.DOM_EXP 			
							AND 		T1.FCST_TYPE 		 =   T2.FCST_TYPE 		
							AND 		T1.INCOTERMS 		 =   T2.INCOTERMS 		
							AND 		T1.PLANT_SITE_ID 	 =   T2.PLANT_SITE_ID 	
							AND		T2.YYYYMMDD = @CUTOFF_YYYYMMDD
						WHERE	T1.YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD,-1,@CUTOFF_YYYYMMDD), 112)
							AND T1.DIVISION_ID = @c_division_id
							AND T2.DIVISION_ID = @c_division_id

			FETCH NEXT FROM CUTOFF_CUR_TEMP
					INTO @CUTOFF_YYYYMMDD
		
			END;

			CLOSE CUTOFF_CUR_TEMP;
			DEALLOCATE CUTOFF_CUR_TEMP;
		--------------------------------------------- 
		--④④④④④④④④④④④④④  CUR_TEMP CLOSE
		--------------------------------------------- 

		---------------------------------- 초기화 (START)
		DELETE FROM DM_PLN_MKT_FCST_C
			WHERE MEASURE IN  ('BALANCE_TEST') 
				AND DIVISION_ID		= @c_division_id
				AND	VERSION_NO		= @c_VERSION_NO
		---------------------------------- 초기화 (END)
					
		---------------------------------- 계산된 BALANCE값 INSERT (START)
		insert into DM_PLN_MKT_FCST_C
					( DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
					,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
		select division_id , VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD, project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms,'BALANCE_TEST' measure ,plant_site_id, yyyymmdd, GAP alloc_qty
			,'BALANCE_MAKE_TEST',getdate(),'BALANCE_MAKE_TEST',getdate(), null,null,null,null,null,null,null,null,null,null
		from  temp_skh_CUTOFF_TEMP
		WHERE DIVISION_ID = @c_division_id
				AND GAP BETWEEN -9999999999 AND 9999999999  -- 오버플로우 예방
				AND GAP <> 0                                -- ZERO 값은 불필요
		---------------------------------- 계산된 BALANCE값 INSERT (END)
;
			FETCH NEXT FROM CURSOR2_CUTOFF INTO  @c_VERSION_NO    

		END

		CLOSE CURSOR2_CUTOFF;  
		DEALLOCATE CURSOR2_CUTOFF;
		----------------------------------------------------------------------------------------
		--③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③③ CURSOR2_CUTOFF VERSION_NO별 LOOP END
		----------------------------------------------------------------------------------------

		---------------------------------------------------------------------------------------- 20180618 KHSONG CUTOFF TABLE BALANCE 값 재계산 로직 추가 END

		-- Sales Plan  Cutoff 정보 변경
		-- 삭제
		delete  dm_pln_sales_plan_c
		where 1=1
			and cutoff_yyyymmdd >= @plan_start_yyyymmdd  -- 당주월요일부터
			and cutoff_type = 'SP_W'
			and measure in (  'RTF_TEST' , 'SalesAmt_KRW', 'SalesAmt_LOC','SalesAmt_USD' )
			-- 비물동 물량은 기존 cutoff 값을 그대로 보전하기 위함.
			and item_id in (
							select b.item_id
				from [dbo].[DM_MST_ITEM_SINGLE_V] b with(nolock)
				where dm_pln_sales_plan_c.item_id = b.item_id
							)
			and division_id = @c_division_id

		-- 삭제한 version 에 대해서 각각 만들어야 함.
		insert into dm_pln_sales_plan_c
			(
			 DIVISION_ID
			,VERSION_NO
			,CUTOFF_TYPE
			,CUTOFF_YYYYMMDD
			,PROJECT_CODE
			,SCM_SITE_ID
			,ITEM_ID
			,DOM_EXP
			,FCST_TYPE
			,INCOTERMS
			,MEASURE
			,PLANT_SITE_ID
			,YYYYMMDD
			,CURRENCY
			,QTY
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
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
			)
		select a.[DIVISION_ID]
				,[VERSION_NO]
				,[CUTOFF_TYPE]
				,[CUTOFF_YYYYMMDD]
				,[PROJECT_CODE]
				,[SCM_SITE_ID]
				,[ITEM_ID]
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
				,'RTF_UPDATE'
				,getdate()
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
			from dm_pln_sales_plan a with(nolock)
				,(
			select distinct division_id, a.version_no, cutoff_type, cutoff_yyyymmdd
				from dm_pln_sales_plan_c a with(nolock)
			where 1=1
				and cutoff_yyyymmdd >= @plan_start_yyyymmdd  -- 당주월요일부터
				and cutoff_type = 'SP_W'
				) b
			where yyyymmdd >= @plan_start_yyyymmdd  -- 당주월요일부터
			and measure in (  'RTF_TEST' , 'SalesAmt_KRW', 'SalesAmt_LOC','SalesAmt_USD' )
			and qty > 0
			-- 비물동 물량은 기존 cutoff 값을 그대로 보전하기 위함.
			and item_id in (
							select c.item_id
				from [dbo].[DM_MST_ITEM_SINGLE_V] c with(nolock)
				where a.item_id = c.item_id
							)
			and a.division_id = b.division_id 
			and a.division_id = @c_division_id
		;
		END

		
		---------------------------------------------------------------------------------------- 20180614 KHSONG CUTOFF RTF MEASURE 정보변경 로직 추가 END
		CLOSE CURSOR1_PLAN;  
        DEALLOCATE CURSOR1_PLAN;


			FETCH NEXT FROM CURSOR1_PLAN INTO 
									  @c_division_id    
									 ,@c_plan_id  
									 ,@c_plan_start_yyyymmdd  
*/
		---------------------------------------------------------------------------------------- 
		--END
		--①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①① CURSOR1_PLAN DIVISION별 LOOP END
		-- CURSOR1_PLAN DIVISION별 LOOP

  	-- 트랜잭션 (COMMIT)
        --COMMIT WORK;

	-- vmi_yn 컬럼값 update (TEST용)
/*	update DM_PLN_MKT_FCST set vmi_yn = 'Y'
		where 1=1
		and division_id = '40'
		and exists (select division_id from SCM_MST_SITE C WITH(NOLOCK) WHERE 1=1
					and DM_PLN_MKT_FCST.division_id        =   C.division_id      
					AND DM_PLN_MKT_FCST.scm_site_id        =   C.scm_site_id  
					and c.vmi_yn = 'Y'
					)

	update DM_PLN_MKT_FCST set vmi_yn = 'N'
		where 1=1
		and division_id = '40'
		and isnull(vmi_yn,'') <> 'Y'
		and not exists (select division_id from SCM_MST_SITE C WITH(NOLOCK) WHERE 1=1
					and DM_PLN_MKT_FCST.division_id        =   C.division_id      
					AND DM_PLN_MKT_FCST.scm_site_id        =   C.scm_site_id  
					and c.vmi_yn = 'Y'
					)
*/
	-- vmi_yn 컬럼값 update (TEST용)
	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	--ROLLBACK TRANSACTION MKT_FCST_QTY_BALANCE_CREATE;

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '@p_division_id : ' + ISNULL(@p_division_id,'NULL') + ' / ' + '@p_plan_id : ' + ISNULL(@p_plan_id,'NULL');
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
