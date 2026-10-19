
/*
 * Program ID   : PR_DM_MOBILE_BALANCE_CREATE_BATCH
 * Description  : 소형오픈후 1시간단위 배치작업이 수행되기전 이전 데이터를 전체 BALANCE 생성하기위하여 만듬
 *                
 *                ** 실행파라메터 **
 *                @p_division_id = '40'   <= 하나의 DIVISION_ID 만 수행됨
 *                @p_division_id = 'ALL'  <= 3개의 DIVISION_ID가 CURSOR로 순차적으로 수행됨
 *
 * Program History
 *============================================================================================================
 *   Date       In Charge              Description
 *============================================================================================================
 * 2018.07.30   KHSONG   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * -----------------------------------------------------------------------------------------------------------
 * 20180805  KHSONG 작업대상을 현재시간기준 2시간내 수정된 데이터를 기준으로함 -> 이부분을 주석처리하여 전체수행되도록함
 * 20180806  KHSONG 2018년 10월 scp오픈전까지 vmi값이 존재하지않아 주석처리함 (ui에서 vmi RTF를 수동으로 입력가능하도록함)
 * 20180807  KHSONG PROJECT_CODE단위로 LOOP수행되도록 로직 수정
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 */

CREATE PROCEDURE [dbo].[PR_DM_MOBILE_BALANCE_CREATE_BATCH]

	--Add the parameters for the stored procedure here
	@p_division_id				NVARCHAR(MAX)
    --,@p_plan_id                  NVARCHAR(MAX)	

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MOBILE_BALANCE_CREATE_BATCH';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

    DECLARE @max_plan_id                  NVARCHAR(MAX);
    DECLARE @c_division_id                NVARCHAR(MAX);
    DECLARE @c_plan_id                    NVARCHAR(MAX);
    DECLARE @plan_start_yyyymmdd          NVARCHAR(MAX);
    DECLARE @c_VERSION_NO				  NVARCHAR(MAX);
    DECLARE @c_target_date				  DATETIME;

	set @c_target_date = DATEADD(hour,-2,GETDATE())  -- 20180805 KHSONG 작업대상을 현재시간기준 2시간내 수정된 데이터를 기준으로함

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- input division save table
	DECLARE @division TABLE (division_id			NVARCHAR(MAX))  

	-- 대상 DIVISION
	IF  UPPER(@p_division_id) = 'ALL'
		BEGIN
			INSERT INTO @division (division_id) 
						select '40'
					union
						select '81'
					union
						select '82'
		END
	ELSE
		BEGIN
			INSERT INTO @division (division_id) 
						select @p_division_id
		END

	-- 트랜잭션 (START)

	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------	

	--
	IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR1_PLAN')
		BEGIN
			CLOSE CURSOR1_PLAN
			DEALLOCATE CURSOR1_PLAN
		END;

	DECLARE CURSOR1_PLAN CURSOR FAST_FORWARD FOR
	SELECT 	  division_id    
		FROM  @division	ORDER BY division_id

	BEGIN
		OPEN CURSOR1_PLAN;
		FETCH NEXT FROM CURSOR1_PLAN INTO 
									@c_division_id    
	END

	----------------------------------------------------------------------------------------
	--①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①① CURSOR1_PLAN DIVISION별 LOOP START
	WHILE @@FETCH_STATUS = 0
	----------------------------------------------------------------------------------------
	BEGIN
	----------------------------------------------------------------------------------------
	--BEGIN TRANSACTION MKT_FCST_QTY_BALANCE_CREATE;
	PRINT '@c_division_id  =>  ' + @c_division_id + ' : ' + CONVERT(VARCHAR(8), GETDATE(), 108)

	------------------------------------------------------------- TEMP 추가 20180730 (s)
	BEGIN
	-- TEMP TABLE 확인후 삭제
	IF OBJECT_ID (N'tempdb..#MST', N'U') IS NOT NULL 
		DROP TABLE #MST
	IF OBJECT_ID (N'tempdb..#40_MST', N'U') IS NOT NULL 
		DROP TABLE #40_MST
	IF OBJECT_ID (N'tempdb..#40_MST_MAIN', N'U') IS NOT NULL 
		DROP TABLE #40_MST_MAIN
	IF OBJECT_ID (N'tempdb..#TEMP1', N'U') IS NOT NULL 
		DROP TABLE #TEMP1
	IF OBJECT_ID (N'tempdb..#TEMP2', N'U') IS NOT NULL 
		DROP TABLE #TEMP2
	IF OBJECT_ID (N'tempdb..#TEMPX', N'U') IS NOT NULL 
		DROP TABLE #TEMPX
	IF OBJECT_ID (N'tempdb..#results', N'U') IS NOT NULL 
		DROP TABLE #results
	IF OBJECT_ID (N'tempdb..#40_TEMP1', N'U') IS NOT NULL 
		DROP TABLE #40_TEMP1
	IF OBJECT_ID (N'tempdb..#40_TEMP2', N'U') IS NOT NULL 
		DROP TABLE #40_TEMP2
	IF OBJECT_ID (N'tempdb..#40_TEMP_all', N'U') IS NOT NULL 
		DROP TABLE #40_TEMP_all
	IF OBJECT_ID (N'tempdb..#results_VMI', N'U') IS NOT NULL 
		DROP TABLE #results_VMI

	-- TEMP TABLE 확인후 삭제
	IF OBJECT_ID (N'dbo.#MST', N'U') IS NOT NULL 
		DROP TABLE #MST
	IF OBJECT_ID (N'dbo.#40_MST_MAIN', N'U') IS NOT NULL 
		DROP TABLE #40_MST_MAIN
	IF OBJECT_ID (N'dbo.#40_MST', N'U') IS NOT NULL 
		DROP TABLE #40_MST
	IF OBJECT_ID (N'dbo.#TEMP1', N'U') IS NOT NULL 
		DROP TABLE #TEMP1
	IF OBJECT_ID (N'dbo.#TEMP2', N'U') IS NOT NULL 
		DROP TABLE #TEMP2
	IF OBJECT_ID (N'dbo.#TEMPX', N'U') IS NOT NULL 
		DROP TABLE #TEMPX
	IF OBJECT_ID (N'dbo.#results', N'U') IS NOT NULL 
		DROP TABLE #results
	IF OBJECT_ID (N'dbo.#40_TEMP1', N'U') IS NOT NULL 
		DROP TABLE #40_TEMP1
	IF OBJECT_ID (N'dbo.#40_TEMP2', N'U') IS NOT NULL 
		DROP TABLE #40_TEMP2
	IF OBJECT_ID (N'dbo.#40_TEMP_all', N'U') IS NOT NULL 
		DROP TABLE #40_TEMP_all
	IF OBJECT_ID (N'dbo.#results_VMI', N'U') IS NOT NULL 
		DROP TABLE #results_VMI


	CREATE TABLE #results  (
			 v_division_id      NVARCHAR(30) NOT NULL
			,v_project_code     NVARCHAR(50) NOT NULL
			,v_scm_site_id      NVARCHAR(30) NOT NULL
			,v_item_id          NVARCHAR(50) NOT NULL
			,v_dom_exp          NVARCHAR(03) NOT NULL
			,v_fcst_type        NVARCHAR(20) NOT NULL
			,v_incoterms        NVARCHAR(10) NOT NULL
			--,v_measure          NVARCHAR(50) NOT NULL
			,v_plant_site_id    NVARCHAR(30) NOT NULL
                           )

	CREATE CLUSTERED INDEX [IDX_RESULTS_N1] ON [#results]
	(
		 V_DIVISION_ID ASC
		,V_PROJECT_CODE ASC
		,V_SCM_SITE_ID ASC
		,V_ITEM_ID ASC
		,V_DOM_EXP ASC
		,V_FCST_TYPE ASC
		,V_INCOTERMS ASC
		--,v_MEASURE ASC
		,V_PLANT_SITE_ID ASC
--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
;
	CREATE TABLE  #MST
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
	 ,QTY			NUMERIC(25,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_MST_N1] ON [#MST]
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
	CREATE TABLE  #40_MST
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
	 ,QTY			NUMERIC(25,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_MST_N1] ON [#40_MST]
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
	CREATE TABLE  #40_MST_MAIN
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
	 ,QTY			NUMERIC(25,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_MST_MAIN_N1] ON [#40_MST_MAIN]
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
	CREATE TABLE  #TEMP1
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
	 ,QTY			NUMERIC(25,10) NOT NULL
	 ,ACCUM_SUM		NUMERIC(25,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_TEMP1_N1] ON [#TEMP1]
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

	CREATE TABLE  #40_TEMP1
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
	 ,QTY				NUMERIC(25,10) NOT NULL
	 ,ACCUM_SUM			NUMERIC(25,10) NOT NULL
	 ,last_accum_sum	NUMERIC(25,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_40_TEMP1_N1] ON [#40_TEMP1]
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
	CREATE TABLE  #40_TEMP2
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
	 ,QTY				NUMERIC(25,10) NOT NULL
	 ,ACCUM_SUM			NUMERIC(25,10) NOT NULL
	 ,last_accum_sum	NUMERIC(25,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_40_TEMP2_N1] ON [#40_TEMP2]
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
	CREATE TABLE  #40_TEMP_all
	 (DIVISION_ID		NVARCHAR(30) NOT NULL
	 ,PROJECT_CODE		NVARCHAR(50) NOT NULL
	 ,SCM_SITE_ID		NVARCHAR(30) NOT NULL
	 ,ITEM_ID			NVARCHAR(50) NOT NULL
	 ,DOM_EXP			NVARCHAR(03) NOT NULL
	 ,FCST_TYPE			NVARCHAR(20) NOT NULL
	 ,INCOTERMS			NVARCHAR(10) NOT NULL
	 ,PLANT_SITE_ID		NVARCHAR(30) NOT NULL
	 ,YYYYMMDD			NVARCHAR(08) NOT NULL
	 ,RTF_QTY			NUMERIC(25,10) NOT NULL
	 ,INV				NUMERIC(25,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_40_TEMP_all_N1] ON [#40_TEMP_all]
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

	CREATE TABLE  #TEMP2
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
	 ,QTY			NUMERIC(25,10) NOT NULL
	 ,ACCUM_SUM		NUMERIC(25,10) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_TEMP2_N1] ON [#TEMP2]
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
	CREATE TABLE  #TEMPX
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
	 ,ACCUM_X		NVARCHAR(50) NOT NULL
	 )

	CREATE CLUSTERED INDEX [IDX_TEMPX_N1] ON [#TEMPX]
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
	-- #results VMI대상만저장하는 TEMP TABLE
	CREATE TABLE #results_VMI  (    
		 DIVISION_ID		NVARCHAR(30) NOT NULL
		,PROJECT_CODE		NVARCHAR(50) NOT NULL
		,SCM_SITE_ID		NVARCHAR(30) NOT NULL
		,ITEM_ID			NVARCHAR(50) NOT NULL
		,DOM_EXP			NVARCHAR(03) NOT NULL
		,FCST_TYPE	    NVARCHAR(20) NOT NULL
		,INCOTERMS	    NVARCHAR(10) NOT NULL
		,PLANT_SITE_ID	NVARCHAR(30) NOT NULL
		--,MEASURE			NVARCHAR(50) NOT NULL
		) 

	CREATE CLUSTERED INDEX [IDX_results_VMI_N1] ON [#results_VMI]
	(
		 DIVISION_ID ASC
		,PROJECT_CODE ASC
		,SCM_SITE_ID ASC
		,ITEM_ID ASC
		,DOM_EXP ASC
		,FCST_TYPE ASC
		,INCOTERMS ASC
		--,MEASURE ASC
		,PLANT_SITE_ID ASC
--	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
;
	END

	------------------------------------------------------------- TEMP 추가 20180730 (e)


	BEGIN
		SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  -- 월요일 변수설정

		PRINT '#results INSERT START                          =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		----------------------------------------------------------------- (1) 전체 대상추출
		INSERT  INTO  #results
			(v_division_id   
			,v_project_code  
			,v_scm_site_id   
			,v_item_id       
			,v_dom_exp       
			,v_fcst_type     
			,v_incoterms   
			--,v_measure  
			,v_plant_site_id )
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
			FROM DM_PLN_MKT_FCST  WITH(NOLOCK)
				WHERE	1=1
				--and	DIVISION_ID		in ('81','82','40')
				and	YYYYMMDD BETWEEN @plan_start_yyyymmdd AND CONVERT(CHAR(8), DATEADD(WW, 52, @plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주
				AND	MEASURE			IN ('MKT_FCST','RTF')
				AND DIVISION_ID		= @c_division_id
				--AND LAST_UPDATE_DATE > @c_target_date -- 20180805 KHSONG 작업대상을 현재시간기준 2시간내 수정된 데이터를 기준으로함
				--AND DIVISION_ID ='40' AND SCM_SITE_ID	  = 'DBK_CN_JFZ' AND ITEM_ID		  = 'MCCE132502A1'  -- 20180801
			group by division_id ,project_code ,scm_site_id   ,item_id			,dom_exp 
					,fcst_type   ,incoterms    ,plant_site_id

		PRINT N'Division => ' + @c_division_id + N'              '+ CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
	END

	/*  20180806  KHSONG 2018년 10월 scp오픈전까지 vmi값이 존재하지않아 주석처리함 (ui에서 vmi RTF를 수동으로 입력가능하도록함) (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                             20180627 KHSONG MKT_FCST 소형 SAVE시 VMI재고 확인후 RTF 생성 로직 개발 (START)
	--                                                                                             20180717 KHSONG 속도개선 커서제거 로직으로 수정
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	BEGIN

		PRINT '#results_VMI INSERT START                      =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		----------------------------------------------------------------- 20180703 KHSONG SCM_MST_SITE테이블의 VMI대상으로 대상테이블 생성
		INSERT  INTO  #results_VMI  -- SCM_MST_SITE테이블의 VMI대상
				( division_id ,project_code ,scm_site_id   ,item_id  ,dom_exp 
				 ,fcst_type   ,incoterms   ,plant_site_id)
		SELECT    v_division_id ,v_project_code ,v_scm_site_id   ,v_item_id  ,v_dom_exp 
				 ,v_fcst_type   ,v_incoterms   ,v_plant_site_id 
			FROM #results A
				 ,SCM_MST_SITE C WITH(NOLOCK) 
			WHERE 1=1
				AND		A.V_SCM_SITE_ID	= C.SCM_SITE_ID
				AND		A.V_DIVISION_ID	= C.DIVISION_ID
				AND		C.VMI_YN   = 'Y'
				AND		C.VALID_YN = 'Y'
			group by v_division_id ,v_project_code ,v_scm_site_id   ,v_item_id  ,v_dom_exp 
				 ,v_fcst_type   ,v_incoterms   ,v_plant_site_id

		----------------------------------------------------------------- VMI_In_Plan : SCP PLAN 결과로 받는 VMI In 계획값

		------------------------------------------------------------------------------------------------
		PRINT '#40_MST_MAIN INSERT START                        =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
				insert into #40_MST_MAIN
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
											CASE WHEN b.BASIS_YYYYMMDD = @plan_start_yyyymmdd AND  a.measure in ( 'Vmi_In_Plan')  THEN ISNULL(c.qty,0) + ( SELECT SUM(s.qty)  
																														  FROM scm_dnm_stock_sn s with(nolock)
																															  ,scm_mst_location l with(nolock)
																														 where l.division_id = s.division_id
																														   and l.SCM_SITE_ID = a.SCM_SITE_ID
																														   and l.storage_id = s.storage_id
																														   and s.item_id like  (case when substring(a.ITEM_ID, 1,2) = 'MP' THEN substring( a.ITEM_ID, 1,11) ELSE a.ITEM_ID END ) +'%' 
																														   and convert( varchar, s.cutoff_date,112)  = @plan_start_yyyymmdd ) 
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
								  FROM dm_pln_mkt_fcst W with(nolock) 
								 -- INNER JOIN SCM_MST_SITE ST WITH(NOLOCK)
								  INNER JOIN #results_VMI ST WITH(NOLOCK)
									ON 		W.SCM_SITE_ID	= ST.SCM_SITE_ID
									AND		W.DIVISION_ID	= ST.DIVISION_ID
									--AND		ST.VMI_YN   = 'Y'
									--AND		ST.VALID_YN = 'Y'						   
							 WHERE W.YYYYMMDD between @plan_start_yyyymmdd
							AND CONVERT(CHAR(8), DATEADD(WW, 52, @plan_start_yyyymmdd  ),112)  -- SCP PLANNING 구간이 52주
						  ) A
					inner join SCM_SYS_CALENDAR_M  b with(nolock)
						on b.BASIS_YYYYMMDD between @plan_start_yyyymmdd
							AND CONVERT(CHAR(8), DATEADD(WW, 52, @plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주
					left join dm_pln_mkt_fcst c with(nolock)
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
					and a.measure in ('MKT_FCST', 'Vmi_In_Plan') -- MKT_FCST랑 VMI_IN_PLAN


		PRINT '#40_temp1 INSERT START                         =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|

		-- 속도이슈로 cursor 구조로 변경
		-- 신규변수
		DECLARE @m2_DIVISION_ID         NVARCHAR(MAX);
		DECLARE @m2_SCM_SITE_ID         NVARCHAR(MAX);

		DELETE FROM #40_temp1
		DELETE FROM #40_temp2

		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR2_MST')
			BEGIN
				CLOSE CURSOR2_MST
				DEALLOCATE CURSOR2_MST
			END;
		DECLARE CURSOR2_MST CURSOR FAST_FORWARD FOR
		SELECT 
			      DIVISION_ID,SCM_SITE_ID
			FROM  #results_VMI WHERE 1=1
		GROUP BY DIVISION_ID,  SCM_SITE_ID

		BEGIN
			OPEN CURSOR2_MST;
			FETCH NEXT FROM CURSOR2_MST INTO          -- SCM_SITE_ID별 LOOP수행
									  @m2_DIVISION_ID    
									 ,@m2_SCM_SITE_ID    
		END

		---------------------------------------------------------------------------------------- WHILE_1 LOOP START
		WHILE @@FETCH_STATUS = 0   
		----------------------------------------------------------------------------------------
        BEGIN
		
				DELETE FROM #40_MST  -- SCM_SITE_ID별 LOOP수행전 초기화


				INSERT INTO #40_MST
				(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty)
				SELECT division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty
				  FROM #40_MST_MAIN A
					  WHERE 1=1
						AND	A.DIVISION_ID   = @m2_DIVISION_ID
						AND	A.SCM_SITE_ID   = @m2_SCM_SITE_ID
				--
				insert into #40_temp1
				(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty,accum_sum,last_accum_sum)
				select a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd
					 , min(a.qty) 'qty', sum(b.qty) 'accum_sum', sum(b.qty) - min(a.qty) 'last_accum_sum'
				  from #40_MST a
					  ,#40_MST b
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
					AND	A.DIVISION_ID   = @m2_DIVISION_ID
					AND	A.SCM_SITE_ID   = @m2_SCM_SITE_ID
				group by a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd


				--PRINT '#40_temp2 INSERT START                         =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
				----------------------------------------------------------|

				insert into #40_temp2
				(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty,accum_sum,last_accum_sum)
				select a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd
					 , min(a.qty) 'qty', sum(b.qty) 'accum_sum', sum(b.qty) - min(a.qty) 'last_accum_sum'
				  from #40_MST a
					  ,#40_MST b
				 where a.division_id	= b.DIVISION_ID
				   and a.project_code	= b.project_code
				   and a.scm_site_id	= b.scm_site_id
				   and a.item_id		= b.ITEM_ID
				   and a.fcst_type		= b.FCST_TYPE
				   and a.incoterms		= b.incoterms
				   and a.plant_site_id	= b.PLANT_SITE_ID
				   and a.dom_exp		= b.dom_exp
				   and a.measure		= b.measure
				   and a.measure		= 'Vmi_In_Plan'
				   and a.yyyymmdd		>= @plan_start_yyyymmdd
				   and b.yyyymmdd		>= @plan_start_yyyymmdd
				   and b.yyyymmdd		<= a.yyyymmdd
					AND	A.DIVISION_ID   = @m2_DIVISION_ID
					AND	A.SCM_SITE_ID   = @m2_SCM_SITE_ID
				group by a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd
				;

			FETCH NEXT FROM CURSOR2_MST INTO 
									  @m2_DIVISION_ID    
									 ,@m2_SCM_SITE_ID    

		---------------------------------------------------------------------------------------- 
        END;
		---------------------------------------------------------------------------------------- WHILE_1 LOOP END

		CLOSE CURSOR2_MST;  
        DEALLOCATE CURSOR2_MST;

		PRINT '#40_temp_all INSERT START                      =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|

		insert into #40_temp_all
		(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id,yyyymmdd,RTF_QTY,INV)
		select a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.plant_site_id,a.yyyymmdd
			 ,SUM( case when isnull(a.accum_sum,0) > isnull(b.accum_sum,0) then isnull(b.accum_sum,0) else isnull(a.accum_sum,0) end ) - SUM( case when isnull(a.last_accum_sum,0) > isnull(b.last_accum_sum,0) then isnull(b.last_accum_sum,0) else isnull(a.last_accum_sum,0) end ) RTF_QTY
			 , SUM(isnull(b.accum_sum,0) - isnull(a.accum_sum,0)) INV
		  from #40_temp1 a  --  'MKT_FCST'
			  ,#40_temp2 b  --  'Vmi_In_Plan'
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
			where MEASURE IN ('VMI_Inv','RTF')
			and (
					SELECT count(1) 
						FROM #results_VMI  A  --SCM_MST_SITE테이블의 VMI대상
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
					) > 0;
		PRINT 'DM_PLN_MKT_FCST VMI_Inv INSERT START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		---------------------------------- 계산된 VMI_Inv값 INSERT (START)
		insert into dm_pln_mkt_fcst
					( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
		select division_id , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'RTF' as measure ,plant_site_id, yyyymmdd
			--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
			,rtf_qty as QTY 
			,'Vmi_Make',getdate(),'Vmi_Make',getdate(), null,null,null,null,null,null,null,null,null,null
		from  #40_temp_all
		  WHERE yyyymmdd		>= @plan_start_yyyymmdd
		    AND rtf_qty > 0 

		union

		select division_id , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'VMI_Inv' as measure ,plant_site_id, yyyymmdd
			--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
			,INV as QTY 
			,'Vmi_Make',getdate(),'Vmi_Make',getdate(), null,null,null,null,null,null,null,null,null,null
		from  #40_temp_all
		  WHERE yyyymmdd		>= @plan_start_yyyymmdd
		    AND inv > 0 

		---------------------------------- 계산된 VMI_Inv값 INSERT (END)

	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                             20180627 KHSONG MKT_FCST 소형 SAVE시 VMI재고 확인후 RTF 생성 로직 개발 (END)
	--                                                                                             20180717 KHSONG 속도개선 커서제거 로직으로 수정
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                             20180704 KHSONG VMI DIO 계산로직 추가 (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		BEGIN
		PRINT 'DM_PLN_MKT_FCST VMI_DIO DELETE START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
			BEGIN TRANSACTION DM0003_SAVE_MKT_FCST7
			-- 수행전 삭제
			DELETE 
			FROM dbo.DM_PLN_MKT_FCST
				where MEASURE = 'VMI_DIO'
				and (
						SELECT count(1) 
							FROM #results_VMI  A  --SCM_MST_SITE테이블의 VMI대상
							where 1=1
							and DM_PLN_MKT_FCST.division_id        =   division_id      
							AND DM_PLN_MKT_FCST.project_code       =   project_code   
							AND DM_PLN_MKT_FCST.scm_site_id        =   scm_site_id  
							AND DM_PLN_MKT_FCST.item_id            =   item_id      
							AND DM_PLN_MKT_FCST.dom_exp            =   dom_exp      
							AND DM_PLN_MKT_FCST.fcst_type          =   fcst_type    
							AND DM_PLN_MKT_FCST.incoterms          =   incoterms    
							AND DM_PLN_MKT_FCST.plant_site_id      =   plant_site_id
							AND DM_PLN_MKT_FCST.yyyymmdd           >=   @plan_start_yyyymmdd  -- 당주월요일
						) > 0;

			DECLARE @vmi_dio_yyyymmdd nvarchar(8);  -- 변수설정

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

		PRINT 'DM_PLN_MKT_FCST VMI_DIO CURSOR START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|

			-----------------------------------------------------------------------------------------
			WHILE @@FETCH_STATUS = 0 
			-----------------------------------------------------------------------------------------
				BEGIN

					insert into dbo.DM_PLN_MKT_FCST
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
					  ,'VMI_DIO'         AS MEASURE
					  ,plant_site_id
					  ,@vmi_dio_yyyymmdd AS YYYYMMDD
					  ,CASE WHEN (
									select SUM(QTY)
									from dbo.DM_PLN_MKT_FCST WITH(NOLOCK)
											INNER JOIN #results_VMI
												ON   DM_PLN_MKT_FCST.division_id        =   #results_VMI.division_id
												AND  DM_PLN_MKT_FCST.project_code       =   #results_VMI.project_code
												AND  DM_PLN_MKT_FCST.scm_site_id		=   #results_VMI.scm_site_id
												AND  DM_PLN_MKT_FCST.item_id            =   #results_VMI.item_id   
												AND  DM_PLN_MKT_FCST.dom_exp            =   #results_VMI.dom_exp    
												AND  DM_PLN_MKT_FCST.fcst_type          =   #results_VMI.fcst_type
												AND  DM_PLN_MKT_FCST.incoterms          =   #results_VMI.incoterms  
												AND  DM_PLN_MKT_FCST.plant_site_id      =   #results_VMI.plant_site_id
									where 1=1
										and DM_PLN_MKT_FCST.measure       = 'VMI_Inv'
										and DM_PLN_MKT_FCST.yyyymmdd      = @vmi_dio_yyyymmdd
								) = 0 THEN 0
							ELSE
								   ISNULL( (
										select min(GAP_DAY) - 0
											from (
											select  CAST( ( cast(yyyymmdd as datetime) - cast ( @vmi_dio_yyyymmdd as datetime) ) AS INT ) GAP_DAY,  qty, SUM(QTY) over ( order by yyyymmdd) accum_sum
												from dbo.DM_PLN_MKT_FCST WITH(NOLOCK)
														INNER JOIN #results_VMI
															ON   DM_PLN_MKT_FCST.division_id        =   #results_VMI.division_id
															AND  DM_PLN_MKT_FCST.project_code       =   #results_VMI.project_code
															AND  DM_PLN_MKT_FCST.scm_site_id		=   #results_VMI.scm_site_id
															AND  DM_PLN_MKT_FCST.item_id            =   #results_VMI.item_id   
															AND  DM_PLN_MKT_FCST.dom_exp            =   #results_VMI.dom_exp    
															AND  DM_PLN_MKT_FCST.fcst_type          =   #results_VMI.fcst_type
															AND  DM_PLN_MKT_FCST.incoterms          =   #results_VMI.incoterms  
															AND  DM_PLN_MKT_FCST.plant_site_id      =   #results_VMI.plant_site_id
											where 1=1
												and DM_PLN_MKT_FCST.measure       = 'RTF'           --?????
												and DM_PLN_MKT_FCST.yyyymmdd      > @vmi_dio_yyyymmdd
												) a
										where accum_sum >=  (
															select SUM(QTY)
															from dbo.DM_PLN_MKT_FCST WITH(NOLOCK)
																INNER JOIN #results_VMI
																	ON   DM_PLN_MKT_FCST.division_id        =   #results_VMI.division_id
																	AND  DM_PLN_MKT_FCST.project_code       =   #results_VMI.project_code
																	AND  DM_PLN_MKT_FCST.scm_site_id		=   #results_VMI.scm_site_id
																	AND  DM_PLN_MKT_FCST.item_id            =   #results_VMI.item_id   
																	AND  DM_PLN_MKT_FCST.dom_exp            =   #results_VMI.dom_exp    
																	AND  DM_PLN_MKT_FCST.fcst_type          =   #results_VMI.fcst_type
																	AND  DM_PLN_MKT_FCST.incoterms          =   #results_VMI.incoterms  
																	AND  DM_PLN_MKT_FCST.plant_site_id      =   #results_VMI.plant_site_id
															where 1=1
																and DM_PLN_MKT_FCST.measure       = 'VMI_Inv'  -- Inventory
																and DM_PLN_MKT_FCST.yyyymmdd      = @vmi_dio_yyyymmdd
															)
										), 9999)
						   END
						   AS QTY
					  ,'Vmi_Make',getdate(),'Vmi_Make',getdate(), null,null,null,null,null,null,null,null,null,null
					from #results_VMI
						where 1=1
	

					FETCH NEXT FROM VMI_DIO_CUR INTO @VMI_DIO_YYYYMMDD
				END 
			-----------------------------------------------------------------------------------------
			CLOSE VMI_DIO_CUR
			DEALLOCATE  VMI_DIO_CUR
			COMMIT TRANSACTION DM0003_SAVE_MKT_FCST7

		END
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                             20180704 KHSONG VMI DIO 계산로직 추가 (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                    20180627 KHSONG 소형인 경우에 VMI_In_Req 를 MKT_FCST와 동일하게 생성 로직 추가 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	BEGIN

		PRINT 'DM_PLN_MKT_FCST VMI_In_Req DELETE START        =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		DELETE 
		FROM dbo.DM_PLN_MKT_FCST
			where MEASURE = 'VMI_In_Req'
			AND yyyymmdd >= @plan_start_yyyymmdd -- 당주 월요일이후
			AND division_id			=   '40'
			AND (
				SELECT count(1) 
					FROM #results_VMI rslt
				where 1=1
				AND DM_PLN_MKT_FCST.division_id			=   rslt.division_id      
				AND DM_PLN_MKT_FCST.project_code		=   rslt.project_code   
				AND DM_PLN_MKT_FCST.scm_site_id			=   rslt.scm_site_id  
				AND DM_PLN_MKT_FCST.item_id				=   rslt.item_id      
				AND DM_PLN_MKT_FCST.dom_exp				=   rslt.dom_exp      
				AND DM_PLN_MKT_FCST.fcst_type			=   rslt.fcst_type    
				AND DM_PLN_MKT_FCST.incoterms			=   rslt.incoterms    
				AND DM_PLN_MKT_FCST.plant_site_id		=   rslt.plant_site_id
				AND DM_PLN_MKT_FCST.yyyymmdd			>=  @plan_start_yyyymmdd
				) > 0;


		insert into dm_pln_mkt_fcst
					( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
		select a.[DIVISION_ID]
			  ,a.[PROJECT_CODE]
			  ,a.[SCM_SITE_ID]
			  ,a.[ITEM_ID]
			  ,a.[DOM_EXP]
			  ,a.[FCST_TYPE]
			  ,a.[INCOTERMS]
			  ,'VMI_In_Req' 
			  ,a.[PLANT_SITE_ID]
			  ,a.[YYYYMMDD]
			  ,a.[QTY]
			  ,'SYSTEM'
			  ,GETDATE()
			  ,'SYSTEM'
			  ,GETDATE()
			  ,a.[ATTRIBUTE1]
			  ,a.[ATTRIBUTE2]
			  ,a.[ATTRIBUTE3]
			  ,a.[ATTRIBUTE4]
			  ,a.[ATTRIBUTE5]
			  ,a.[ATTRIBUTE6]
			  ,a.[ATTRIBUTE7]
			  ,a.[ATTRIBUTE8]
			  ,a.[ATTRIBUTE9]
			  ,a.[ATTRIBUTE10]
		  from dm_pln_mkt_fcst a WITH(NOLOCK)
		       INNER JOIN #results_VMI rslt
				 ON a.division_id			=   rslt.division_id      
				AND a.project_code			=   rslt.project_code   
				AND a.scm_site_id			=   rslt.scm_site_id  
				AND a.item_id				=   rslt.item_id      
				AND a.dom_exp				=   rslt.dom_exp      
				AND a.fcst_type				=   rslt.fcst_type    
				AND a.incoterms				=   rslt.incoterms    
				AND a.plant_site_id			=   rslt.plant_site_id
			where a.MEASURE = 'MKT_FCST'
			AND a.division_id			=   '40'
			AND a.yyyymmdd >= @plan_start_yyyymmdd -- 당주 월요일이후
			--AND (
			--	SELECT count(1) 
			--		FROM #results_VMI rslt
			--	where 1=1
			--	AND a.division_id			=   rslt.division_id      
			--	AND a.project_code			=   rslt.project_code   
			--	AND a.scm_site_id			=   rslt.scm_site_id  
			--	AND a.item_id				=   rslt.item_id      
			--	AND a.dom_exp				=   rslt.dom_exp      
			--	AND a.fcst_type				=   rslt.fcst_type    
			--	AND a.incoterms				=   rslt.incoterms    
			--	AND a.plant_site_id			=   rslt.plant_site_id
			--	) > 0
	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                    20180627 KHSONG 소형인 경우에 VMI_In_Req 를 MKT_FCST와 동일하게 생성 로직 추가 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	*/--  20180806  KHSONG 2018년 10월 scp오픈전까지 vmi값이 존재하지않아 주석처리함 (ui에서 vmi RTF를 수동으로 입력가능하도록함) (END)

	--◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆
	--===================================================================================== 20180611 KHSONG MKT_FCST_QTY_BALANCE_CREATE 로직 추가 (START)
	--◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆
	BEGIN

	--print 'Execute 04 ' + CONVERT(VARCHAR(8), GETDATE(), 108)

		-- added by ytchoi 180611 한주가 지나면 화면에서 과거 RTF P 를 보기 어렵기 때문에 당주 월요일 이후로만 계산 함.
		SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  -- 월요일 변수설정

		PRINT 'BALANCE_CREATE #MST INSERT START               =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)

		--SELECT '#results'
		--SELECT *  FROM #results
		--SELECT * into temp_skh_0801_imsi FROM #results
		--ROLLBACK;  -- 수정중
		----------------------------------------------------------|
		----------------------------------------------------------------- (1)

		-- 속도이슈로 cursor 구조로 변경
		-- 신규변수
		DECLARE @m_DIVISION_ID         NVARCHAR(MAX);
		DECLARE @m_SCM_SITE_ID         NVARCHAR(MAX);
		DECLARE @m_PROJECT_CODE        NVARCHAR(MAX);


		DELETE FROM #TEMP1
		DELETE FROM #TEMP2
			
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR1_MST')
			BEGIN
				CLOSE CURSOR1_MST
				DEALLOCATE CURSOR1_MST
			END;
		DECLARE CURSOR1_MST CURSOR FAST_FORWARD FOR
		SELECT 
			      V_DIVISION_ID,V_SCM_SITE_ID,V_PROJECT_CODE
			FROM  #results WHERE 1=1
		GROUP BY V_DIVISION_ID,  V_SCM_SITE_ID,V_PROJECT_CODE

		BEGIN
			OPEN CURSOR1_MST;
			FETCH NEXT FROM CURSOR1_MST INTO          -- SCM_SITE_ID별 LOOP수행
									  @m_DIVISION_ID    
									 ,@m_SCM_SITE_ID  
									 ,@m_PROJECT_CODE  
		END

		---------------------------------------------------------------------------------------- WHILE_1 LOOP START
		WHILE @@FETCH_STATUS = 0   
		----------------------------------------------------------------------------------------
        BEGIN
		
		BEGIN TRANSACTION MKT_FCST_QTY_BALANCE_CREATE_01

		DELETE FROM #MST  -- SCM_SITE_ID별 LOOP수행전 초기화

		INSERT INTO #MST
		select A.DIVISION_ID,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,A.DOM_EXP,A.FCST_TYPE,A.INCOTERMS,A.PLANT_SITE_ID, b.BASIS_YYYYMMDD AS YYYYMMDD, A.MEASURE, ISNULL(c.QTY,0) QTY
		
		  from (
				select distinct  rslt.V_DIVISION_ID    DIVISION_ID
								,rslt.V_PROJECT_CODE   PROJECT_CODE
								,rslt.V_SCM_SITE_ID    SCM_SITE_ID
								,rslt.V_ITEM_ID        ITEM_ID
								,rslt.V_DOM_EXP        DOM_EXP
								,rslt.V_FCST_TYPE      FCST_TYPE
								,rslt.V_INCOTERMS      INCOTERMS
								,rslt.V_PLANT_SITE_ID  PLANT_SITE_ID
								,'MKT_FCST' MEASURE 
				 from #results rslt
				 WHERE 1=1
					AND V_DIVISION_ID         = @m_DIVISION_ID
					AND V_SCM_SITE_ID         = @m_SCM_SITE_ID
				 UNION ALL
				select distinct  A.V_DIVISION_ID
								,A.V_PROJECT_CODE
								,A.V_SCM_SITE_ID
								,A.V_ITEM_ID
								,A.V_DOM_EXP
								,A.V_FCST_TYPE
								,A.V_INCOTERMS
								,A.V_PLANT_SITE_ID
								,'RTF' MEASURE 
				 from #results A
				 WHERE 1=1
					AND V_DIVISION_ID         = @m_DIVISION_ID
					AND V_SCM_SITE_ID         = @m_SCM_SITE_ID
					AND V_PROJECT_CODE		  = @m_PROJECT_CODE
			   ) A
		  inner join SCM_SYS_CALENDAR_M   B WITH(NOLOCK)
			ON B.BASIS_YYYYMMDD BETWEEN @plan_start_yyyymmdd
			AND CONVERT(CHAR(8), DATEADD(WW, 52, @plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주
					LEFT JOIN DM_PLN_MKT_FCST C WITH(NOLOCK)
						ON		A.DIVISION_ID		= C.DIVISION_ID
						AND		A.PROJECT_CODE		= C.PROJECT_CODE
						AND		A.SCM_SITE_ID		= C.SCM_SITE_ID
						AND		A.ITEM_ID			= C.ITEM_ID
						AND		A.DOM_EXP			= C.DOM_EXP
						AND		A.FCST_TYPE			= C.FCST_TYPE
						AND		A.INCOTERMS			= C.INCOTERMS
						AND		A.PLANT_SITE_ID		= C.PLANT_SITE_ID
						AND     A.MEASURE			= C.MEASURE
						AND     B.BASIS_YYYYMMDD    = C.YYYYMMDD
					------------------------------------------------------------ 20180801 추가사항 (s)
					WHERE 1=1
					AND C.DIVISION_ID         = @m_DIVISION_ID
					AND C.SCM_SITE_ID         = @m_SCM_SITE_ID
					AND C.PROJECT_CODE		  = @m_PROJECT_CODE
		UNION 

		select A.DIVISION_ID,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,A.DOM_EXP,A.FCST_TYPE,A.INCOTERMS,A.PLANT_SITE_ID, b.BASIS_YYYYMMDD AS YYYYMMDD, A.MEASURE, ISNULL(c.QTY,0) QTY
		
		  from (
				select distinct  rslt.V_DIVISION_ID    DIVISION_ID
								,rslt.V_PROJECT_CODE   PROJECT_CODE
								,rslt.V_SCM_SITE_ID    SCM_SITE_ID
								,rslt.V_ITEM_ID        ITEM_ID
								,rslt.V_DOM_EXP        DOM_EXP
								,rslt.V_FCST_TYPE      FCST_TYPE
								,rslt.V_INCOTERMS      INCOTERMS
								,rslt.V_PLANT_SITE_ID  PLANT_SITE_ID
								,'MKT_FCST' MEASURE 
				 from #results rslt
				 WHERE 1=1
					AND V_DIVISION_ID         = @m_DIVISION_ID
					AND V_SCM_SITE_ID         = @m_SCM_SITE_ID
				 UNION ALL
				select distinct  A.V_DIVISION_ID
								,A.V_PROJECT_CODE
								,A.V_SCM_SITE_ID
								,A.V_ITEM_ID
								,A.V_DOM_EXP
								,A.V_FCST_TYPE
								,A.V_INCOTERMS
								,A.V_PLANT_SITE_ID
								,'RTF' MEASURE 
				 from #results A
				 WHERE 1=1
					AND V_DIVISION_ID         = @m_DIVISION_ID
					AND V_SCM_SITE_ID         = @m_SCM_SITE_ID
					AND V_PROJECT_CODE		  = @m_PROJECT_CODE
			   ) A
		  inner join SCM_SYS_CALENDAR_M   B WITH(NOLOCK)
			ON B.BASIS_YYYYMMDD BETWEEN @plan_start_yyyymmdd
			AND CONVERT(CHAR(8), DATEADD(WW, 52, @plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주
			AND		B.DAYOFWEEK IN ('MON','SUN')
					LEFT JOIN DM_PLN_MKT_FCST C WITH(NOLOCK)
						ON		A.DIVISION_ID		= C.DIVISION_ID
						AND		A.PROJECT_CODE		= C.PROJECT_CODE
						AND		A.SCM_SITE_ID		= C.SCM_SITE_ID
						AND		A.ITEM_ID			= C.ITEM_ID
						AND		A.DOM_EXP			= C.DOM_EXP
						AND		A.FCST_TYPE			= C.FCST_TYPE
						AND		A.INCOTERMS			= C.INCOTERMS
						AND		A.PLANT_SITE_ID		= C.PLANT_SITE_ID
						AND     A.MEASURE			= C.MEASURE
						AND     B.BASIS_YYYYMMDD    = C.YYYYMMDD

		UNION 

		select A.DIVISION_ID,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,A.DOM_EXP,A.FCST_TYPE,A.INCOTERMS,A.PLANT_SITE_ID, b.BASIS_YYYYMMDD AS YYYYMMDD, A.MEASURE, ISNULL(c.QTY,0) QTY
		
		  from (
				select distinct  rslt.V_DIVISION_ID    DIVISION_ID
								,rslt.V_PROJECT_CODE   PROJECT_CODE
								,rslt.V_SCM_SITE_ID    SCM_SITE_ID
								,rslt.V_ITEM_ID        ITEM_ID
								,rslt.V_DOM_EXP        DOM_EXP
								,rslt.V_FCST_TYPE      FCST_TYPE
								,rslt.V_INCOTERMS      INCOTERMS
								,rslt.V_PLANT_SITE_ID  PLANT_SITE_ID
								,'MKT_FCST' MEASURE 
				 from #results rslt
				 WHERE 1=1
					AND V_DIVISION_ID         = @m_DIVISION_ID
					AND V_SCM_SITE_ID         = @m_SCM_SITE_ID
				 UNION ALL
				select distinct  A.V_DIVISION_ID
								,A.V_PROJECT_CODE
								,A.V_SCM_SITE_ID
								,A.V_ITEM_ID
								,A.V_DOM_EXP
								,A.V_FCST_TYPE
								,A.V_INCOTERMS
								,A.V_PLANT_SITE_ID
								,'RTF' MEASURE 
				 from #results A
				 WHERE 1=1
					AND V_DIVISION_ID         = @m_DIVISION_ID
					AND V_SCM_SITE_ID         = @m_SCM_SITE_ID
					AND V_PROJECT_CODE		  = @m_PROJECT_CODE
			   ) A
		  inner join SCM_SYS_CALENDAR_M   B WITH(NOLOCK)
			ON B.BASIS_YYYYMMDD BETWEEN @plan_start_yyyymmdd
			AND CONVERT(CHAR(8), DATEADD(WW, 52, @plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주
			AND		B.PARTIAL_YN   = 'Y'
					LEFT JOIN DM_PLN_MKT_FCST C WITH(NOLOCK)
						ON		A.DIVISION_ID		= C.DIVISION_ID
						AND		A.PROJECT_CODE		= C.PROJECT_CODE
						AND		A.SCM_SITE_ID		= C.SCM_SITE_ID
						AND		A.ITEM_ID			= C.ITEM_ID
						AND		A.DOM_EXP			= C.DOM_EXP
						AND		A.FCST_TYPE			= C.FCST_TYPE
						AND		A.INCOTERMS			= C.INCOTERMS
						AND		A.PLANT_SITE_ID		= C.PLANT_SITE_ID
						AND     A.MEASURE			= C.MEASURE
						AND     B.BASIS_YYYYMMDD    = C.YYYYMMDD
					------------------------------------------------------------ 20180801 추가사항 (e)

		-- 확인용
		--SELECT * FROM #MST

		--MKT_FCST INSERT
		INSERT INTO #TEMP1
		( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID ,YYYYMMDD,MEASURE,QTY,ACCUM_SUM)
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID,A.YYYYMMDD, A.MEASURE, MIN(A.QTY) AS QTY, SUM(B.QTY) AS ACCUM_SUM
			FROM #MST A
				,#MST B
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
			AND A.YYYYMMDD			 >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
			AND B.YYYYMMDD			 >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
			AND B.YYYYMMDD			 <= A.YYYYMMDD
			AND A.DIVISION_ID         = @m_DIVISION_ID
			AND A.SCM_SITE_ID         = @m_SCM_SITE_ID
			AND A.PROJECT_CODE		  = @m_PROJECT_CODE
		GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.MEASURE ,A.YYYYMMDD
		order by yyyymmdd

		--RTF INSERT
		INSERT INTO #TEMP2
		( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID ,YYYYMMDD,MEASURE,QTY,ACCUM_SUM)
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID,A.YYYYMMDD, A.MEASURE, MIN(A.QTY) AS QTY, SUM(B.QTY) AS ACCUM_SUM
		  FROM #MST A WITH(NOLOCK)
			  ,#MST B WITH(NOLOCK)
		 WHERE A.DIVISION_ID		  = B.DIVISION_ID
			AND A.PROJECT_CODE		  = B.PROJECT_CODE
			AND A.SCM_SITE_ID		  = B.SCM_SITE_ID
			AND A.ITEM_ID			  = B.ITEM_ID
			AND A.FCST_TYPE			  = B.FCST_TYPE
			AND A.INCOTERMS			  = B.INCOTERMS
			AND A.PLANT_SITE_ID		  = B.PLANT_SITE_ID
			AND A.DOM_EXP			  = B.DOM_EXP
			AND A.MEASURE			  = B.MEASURE
			AND A.MEASURE			  = 'RTF'
			AND A.YYYYMMDD			 >= @plan_start_yyyymmdd
			AND B.YYYYMMDD			 >= @plan_start_yyyymmdd
			AND B.YYYYMMDD			 <= A.YYYYMMDD
			AND A.DIVISION_ID         = @m_DIVISION_ID
			AND A.SCM_SITE_ID         = @m_SCM_SITE_ID
			AND A.PROJECT_CODE		  = @m_PROJECT_CODE
		GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID,A.YYYYMMDD


		--PRINT 'BALANCE_CREATE #TEMP2 INSERT START =>              ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|

		PRINT 'BALANCE_CREATE #TEMPX INSERT START             =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|

/*  기존 로직
		INSERT INTO #TEMPX
		( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID ,YYYYMMDD,MEASURE,ACCUM_X)
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID,A.YYYYMMDD, A.MEASURE, SUM(B.ACCUM_SUM - A.ACCUM_SUM) AS ACCUM_X
		
		FROM #TEMP1 A
			,#TEMP2 B
		WHERE A.DIVISION_ID			  = B.DIVISION_ID
			AND A.PROJECT_CODE		  = B.PROJECT_CODE
			AND A.SCM_SITE_ID		  = B.SCM_SITE_ID
			AND A.ITEM_ID			  = B.ITEM_ID
			AND A.FCST_TYPE			  = B.FCST_TYPE
			AND A.INCOTERMS			  = B.INCOTERMS
			AND A.PLANT_SITE_ID		  = B.PLANT_SITE_ID
			AND A.DOM_EXP			  = B.DOM_EXP
			AND A.YYYYMMDD			  = B.YYYYMMDD
		GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID,A.YYYYMMDD
*/

		INSERT INTO #TEMPX
		( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID ,YYYYMMDD,MEASURE,ACCUM_X)
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID,A.YYYYMMDD,'', SUM(A.RTF_QTY - A.MKT_FCST_QTY) AS ACCUM_X 
		FROM 
			(SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID ,YYYYMMDD,ACCUM_SUM MKT_FCST_QTY,0 RTF_QTY FROM #TEMP1
				WHERE 1=1
				AND DIVISION_ID         = @m_DIVISION_ID
				AND SCM_SITE_ID         = @m_SCM_SITE_ID
				AND PROJECT_CODE		= @m_PROJECT_CODE
			 UNION 
			 SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID ,YYYYMMDD,0 MKT_FCST_QTY,ACCUM_SUM RTF_QTY FROM #TEMP2
				WHERE 1=1
				AND DIVISION_ID         = @m_DIVISION_ID
				AND SCM_SITE_ID         = @m_SCM_SITE_ID
				AND PROJECT_CODE		= @m_PROJECT_CODE
			 ) A
		GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID,A.YYYYMMDD


		PRINT 'DM_PLN_MKT_FCST BALANCE DELETE START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		---------------------------------- 초기화 (START)
		DELETE 
		FROM dbo.DM_PLN_MKT_FCST
			where MEASURE = 'BALANCE'
			and EXISTS(
					SELECT division_id
						FROM #TEMPX 
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
						AND PROJECT_CODE		= @m_PROJECT_CODE
					) 
				AND DIVISION_ID         = @m_DIVISION_ID
				AND SCM_SITE_ID         = @m_SCM_SITE_ID
				AND PROJECT_CODE		= @m_PROJECT_CODE
					;

		---------------------------------- 초기화 (END)
					
	--print 'Execute 06 ' + CONVERT(VARCHAR(8), GETDATE(), 108)

		PRINT 'DM_PLN_MKT_FCST BALANCE INSERT START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		---------------------------------- 계산된 BALANCE값 INSERT (START)
		insert into dm_pln_mkt_fcst
					( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
		select division_id , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms,'BALANCE' measure ,plant_site_id, yyyymmdd, ACCUM_X
			,'BALANCE_MAKE',getdate(),'BALANCE_MAKE',getdate(), null,null,null,null,null,null,null,null,null,null
		from  #TEMPX
		  WHERE yyyymmdd		>= @plan_start_yyyymmdd
				AND DIVISION_ID         = @m_DIVISION_ID
				AND SCM_SITE_ID         = @m_SCM_SITE_ID
				AND PROJECT_CODE		= @m_PROJECT_CODE
		---------------------------------- 계산된 BALANCE값 INSERT (END)

		COMMIT TRANSACTION MKT_FCST_QTY_BALANCE_CREATE_01

		FETCH NEXT FROM CURSOR1_MST INTO 
									@m_DIVISION_ID    
									,@m_SCM_SITE_ID   
									,@m_PROJECT_CODE 

		---------------------------------------------------------------------------------------- 
        END;
		---------------------------------------------------------------------------------------- WHILE_1 LOOP END

		CLOSE CURSOR1_MST;  
        DEALLOCATE CURSOR1_MST;

	END
	--◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆
	--===================================================================================== 20180611 KHSONG MKT_FCST_QTY_BALANCE_CREATE 로직 추가 (END)
	--◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆
 

  	-- 트랜잭션 (COMMIT)
        --COMMIT WORK;

	FETCH NEXT FROM CURSOR1_PLAN INTO 
								@c_division_id    

	END
	---------------------------------------------------------------------------------------- 
	--①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①①① CURSOR1_PLAN DIVISION별 LOOP END
	
	CLOSE CURSOR1_PLAN;  
    DEALLOCATE CURSOR1_PLAN;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	--ROLLBACK TRANSACTION MKT_FCST_QTY_BALANCE_CREATE;
	ROLLBACK TRANSACTION MKT_FCST_QTY_BALANCE_CREATE_01

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
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
