
/*
 * Program ID   : PR_SCP_ENG_EE_FN_PROC_SETUP_MATRIX_MCS
 * Description  : 엔진 SETUP MATRIX 데이터 생성 (관련 FP 기준정보) 
                            
 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.11.18   CJS         Initial Release
 */
create PROCEDURE  [dbo].[PR_SCP_ENG_EE_FN_PROC_SETUP_MATRIX_MCS]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)   
    
) AS

BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

     --20180228 프로시저 속도 개선을 위해서 입력변수를 일반변수로 변경함
    DECLARE @p_plan_cycle  NVARCHAR(150)    = @p_plan_cycle1;
    DECLARE @p_plan_name   NVARCHAR(4000)   = @p_plan_name1;
    DECLARE @p_plan_id     NVARCHAR(4000)   = @p_engine_plan_id1;
    DECLARE @p_modeling_id NVARCHAR(4000)   = @p_modeling_id1 ;
    DECLARE @p_seq         NVARCHAR(4000)   = @p_seq1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;
    DECLARE @p_master_id   NVARCHAR(4000)   = @p_master_id1 ;
    DECLARE @p_division_id NVARCHAR(30)     = @p_division_id1 ; 
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ;
    
    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_PROC_SETUP_MATRIX_MCS';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = '';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;

    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @v_cur_wednesday     NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'WED')), 112); -- 당주 수요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME = CONVERT(DATETIME,@p_plan_name);
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date
	DECLARE @v_add_pet_date      NVARCHAR(8) ; -- Add Plan End Date (2022.01.17 추가) 

    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY

		BEGIN
			
			SET @v_log_type = 'TXN';
			SET @v_log_message = '1.00.0 INIT';
			SET @v_description = N'tmp_XX~'  ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


				IF OBJECT_ID('tempdb..#tmp_MST_DEMAND_PLAN_BOM') IS NOT NULL                        
					DROP TABLE #tmp_MST_DEMAND_PLAN_BOM                        
                        
					CREATE TABLE #tmp_MST_DEMAND_PLAN_BOM(                        
						[MASTER_ID] [nvarchar](50) NOT NULL,
						[PLAN_ID] [nvarchar](50) NOT NULL,
						[TOP_ITEM_ID] [nvarchar](150) NULL,
						[PARENT_ITEM_ID] [nvarchar](150) NULL,
						[CHILD_ITEM_ID] [nvarchar](150) NULL,
						[BOM_LVL] [numeric](20, 10) NULL,
						[BOM_PATH] [nvarchar](150) NULL,
						[SITE_ID] [nvarchar](150) NULL,
						[ROUTE_ID] [nvarchar](150) NULL,
						[PLANT_ID] [nvarchar](150) NULL
					); 

				IF OBJECT_ID('tempdb..#tmp_MST_ITEM_OPERATION') IS NOT NULL                        
					DROP TABLE #tmp_MST_ITEM_OPERATION
                        
					CREATE TABLE #tmp_MST_ITEM_OPERATION(                        
						[MASTER_ID] [nvarchar](50) NOT NULL,
						[PLAN_ID] [nvarchar](50) NOT NULL,
						[COMPANY_ID] [nvarchar](20) NULL,
						[DIVISION_ID] [nvarchar](20) NULL,
						[SITE_ID] [nvarchar](30) NULL,
						[PLANT_ID] [nvarchar](30) NULL,
						[ITEM_ID] [nvarchar](50) NULL,
						[OPERATION_ID] [nvarchar](30) NULL,
						[SCP_FLOW_ID] [nvarchar](30) NULL,
						[USE_SETUP] [nvarchar](30) NULL,
						[USE_CAPA] [nvarchar](30) NULL
					); 

				IF OBJECT_ID('tempdb..#tmp_MST_ITEM_LINE') IS NOT NULL                        
					DROP TABLE #tmp_MST_ITEM_LINE         

					CREATE TABLE #tmp_MST_ITEM_LINE(                        
						[MASTER_ID] [nvarchar](50) NULL,
						[PLAN_ID] [nvarchar](50) NULL,
						[COMPANY_ID] [nvarchar](20) NULL,
						[DIVISION_ID] [nvarchar](20) NULL,
						[SITE_ID] [nvarchar](30) NULL,
						[PLANT_ID] [nvarchar](30) NULL,
						[ITEM_ID] [nvarchar](50) NULL,
						[OPERATION_ID] [nvarchar](30) NULL,
						[LINE_ID] [nvarchar](100) NULL,
						[LINE_SETUP_GROUP_ID] [nvarchar](100) NULL,
						[RESOURCE_ID] [nvarchar](100) NULL
					); 

				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_BOM') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_BOM         

					CREATE TABLE #tmp_MST_SCM_SETUP_BOM(                        
						[MASTER_ID] [nvarchar](50) NULL,
						[PLAN_ID] [nvarchar](50) NULL,
						[COMPANY_ID] [nvarchar](30) NULL,
						[DIVISION_ID] [nvarchar](30) NULL,
						[SITE_ID] [nvarchar](30) NULL,
						[PLANT_ID] [nvarchar](30) NULL,
						[PARENT_ITEM_ID] [nvarchar](150) NULL,
						[OPERATION_ID] [nvarchar](30) NULL,
						[CHILD_ITEM_ID] [nvarchar](150) NULL,
						[ITEM_TYPE] [nvarchar](50) NULL,
						[SETUP_KEY_ID] [nvarchar](50) NULL,
						[SETUP_ATTRIBUTE] [nvarchar](150) NULL,
						[ITEM_ATTRIBUTE] [nvarchar](150) NULL
					); 


				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_ITEM_LIST') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_ITEM_LIST         

					CREATE TABLE #tmp_MST_SCM_SETUP_ITEM_LIST(                        
						[MASTER_ID] [nvarchar](50) NULL,
						[PLAN_ID] [nvarchar](50) NULL,
						[COMPANY_ID] [nvarchar](30) NULL,
						[DIVISION_ID] [nvarchar](30) NULL,
						[SITE_ID] [nvarchar](30) NULL,
						[PLANT_ID] [nvarchar](30) NULL,
						[SETUP_CATEGORY_ID] [nvarchar](100) NULL,
						[SETUP_KEY_ID] [nvarchar](100) NULL,
						[LEVEL] [nvarchar](30) NULL,
						[ITEM_ID] [nvarchar](150) NULL,
						[OPERATION_ID] [nvarchar](150) NULL,
						[CALCULATION] [nvarchar](30) NULL,
						[SETUP_ATTRIBUTE] [nvarchar](150) NULL,
						[ITEM_ATTRIBUTE] [nvarchar](150) NULL,
						[ITEM_ATTB_CNT] [int] NULL,
						[ATTB_CNT_TOTAL] [int] NULL,
						[ITEM_ATTB_KIND] [int] NULL
					); 

				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_ITEM_COMBINE') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_ITEM_COMBINE 

					CREATE TABLE #tmp_MST_SCM_SETUP_ITEM_COMBINE(                        
						[MASTER_ID] [nvarchar](50) NULL,
						[PLAN_ID] [nvarchar](50) NULL,
						[COMPANY_ID] [nvarchar](30) NULL,
						[DIVISION_ID] [nvarchar](30) NULL,
						[SITE_ID] [nvarchar](30) NULL,
						[PLANT_ID] [nvarchar](30) NULL,
						[SETUP_CATEGORY_ID] [nvarchar](100) NULL,
						[SETUP_KEY_ID] [nvarchar](100) NULL,
						[LEVEL] [nvarchar](30) NULL,
						[ITEM_ID] [nvarchar](150) NULL,
						[OPERATION_ID] [nvarchar](150) NULL,
						[CALCULATION] [nvarchar](30) NULL,
						[ITEM_SETUP_GROUP_ID] [nvarchar](150) NULL
					); 

				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_ITEM') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_ITEM

					CREATE TABLE #tmp_MST_SCM_SETUP_ITEM(                        
						[MASTER_ID] [nvarchar](50) NULL,
						[PLAN_ID] [nvarchar](50) NULL,
						[COMPANY_ID] [varchar](30) NULL,
						[DIVISION_ID] [varchar](30) NULL,
						[SITE_ID] [varchar](30) NULL,
						[PLANT_ID] [varchar](30) NULL,
						[ITEM_ID] [nvarchar](150) NULL,
						[OPERATION_ID] [varchar](150) NULL,
						[LINE_SETUP_GROUP_ID] [nvarchar](150) NULL,
						[SETUP_GROUP_ID] [nvarchar](150) NULL,
						[S_GRP_01] [nvarchar](50) NULL,
						[S_CAT_01] [nvarchar](50) NULL,
						[S_KEY_01] [nvarchar](50) NULL,
						[S_CAL_01] [nvarchar](50) NULL,
						[S_GRP_02] [nvarchar](50) NULL,
						[S_CAT_02] [nvarchar](50) NULL,
						[S_KEY_02] [nvarchar](50) NULL,
						[S_CAL_02] [nvarchar](50) NULL,
						[S_GRP_03] [nvarchar](50) NULL,
						[S_CAT_03] [nvarchar](50) NULL,
						[S_KEY_03] [nvarchar](50) NULL,
						[S_CAL_03] [nvarchar](50) NULL,
						[S_GRP_04] [nvarchar](50) NULL,
						[S_CAT_04] [nvarchar](50) NULL,
						[S_KEY_04] [nvarchar](50) NULL,
						[S_CAL_04] [nvarchar](50) NULL,
						[S_GRP_05] [nvarchar](50) NULL,
						[S_CAT_05] [nvarchar](50) NULL,
						[S_KEY_05] [nvarchar](50) NULL,
						[S_CAL_05] [nvarchar](50) NULL,
						[S_GRP_06] [nvarchar](50) NULL,
						[S_CAT_06] [nvarchar](50) NULL,
						[S_KEY_06] [nvarchar](50) NULL,
						[S_CAL_06] [nvarchar](50) NULL,
						[S_GRP_07] [nvarchar](50) NULL,
						[S_CAT_07] [nvarchar](50) NULL,
						[S_KEY_07] [nvarchar](50) NULL,
						[S_CAL_07] [nvarchar](50) NULL,
						[S_GRP_08] [nvarchar](50) NULL,
						[S_CAT_08] [nvarchar](50) NULL,
						[S_KEY_08] [nvarchar](50) NULL,
						[S_CAL_08] [nvarchar](50) NULL,
						[S_GRP_09] [nvarchar](50) NULL,
						[S_CAT_09] [nvarchar](50) NULL,
						[S_KEY_09] [nvarchar](50) NULL,
						[S_CAL_09] [nvarchar](50) NULL,
						[S_GRP_10] [nvarchar](50) NULL,
						[S_CAT_10] [nvarchar](50) NULL,
						[S_KEY_10] [nvarchar](50) NULL,
						[S_CAL_10] [nvarchar](50) NULL
					); 

				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_MATRIX_01') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_MATRIX_01

					CREATE TABLE #tmp_MST_SCM_SETUP_MATRIX_01(
						[MASTER_ID] [nvarchar](50) NULL,
						[PLAN_ID] [nvarchar](50) NULL,
						[COMPANY_ID] [nvarchar](50) NULL,
						[DIVISION_ID] [nvarchar](50) NULL,
						[SITE_ID] [nvarchar](50) NULL,
						[PLANT_ID] [nvarchar](50) NULL,
						[OPERATION_ID] [nvarchar](50) NULL,
						[LINE_SETUP_GROUP_ID] [nvarchar](150) NULL,
						[FROM_SETUP_GROUP_ID] [nvarchar](150) NULL,
						[TO_SETUP_GROUP_ID] [nvarchar](150) NULL,
						[FROM_SG_01] [nvarchar](50) NULL,
						[TO_SG_01] [nvarchar](50) NULL,
						[CATE_01] [nvarchar](50) NULL,
						[KEY_01] [nvarchar](50) NULL,
						[TCAL_01] [nvarchar](50) NULL,
						[FROM_SG_02] [nvarchar](50) NULL,
						[TO_SG_02] [nvarchar](50) NULL,
						[CATE_02] [nvarchar](50) NULL,
						[KEY_02] [nvarchar](50) NULL,
						[TCAL_02] [nvarchar](50) NULL,
						[FROM_SG_03] [nvarchar](50) NULL,
						[TO_SG_03] [nvarchar](50) NULL,
						[CATE_03] [nvarchar](50) NULL,
						[KEY_03] [nvarchar](50) NULL,
						[TCAL_03] [nvarchar](50) NULL,
						[FROM_SG_04] [nvarchar](50) NULL,
						[TO_SG_04] [nvarchar](50) NULL,
						[CATE_04] [nvarchar](50) NULL,
						[KEY_04] [nvarchar](50) NULL,
						[TCAL_04] [nvarchar](50) NULL,
						[FROM_SG_05] [nvarchar](50) NULL,
						[TO_SG_05] [nvarchar](50) NULL,
						[CATE_05] [nvarchar](50) NULL,
						[KEY_05] [nvarchar](50) NULL,
						[TCAL_05] [nvarchar](50) NULL,
						[FROM_SG_06] [nvarchar](50) NULL,
						[TO_SG_06] [nvarchar](50) NULL,
						[CATE_06] [nvarchar](50) NULL,
						[KEY_06] [nvarchar](50) NULL,
						[TCAL_06] [nvarchar](50) NULL,
						[FROM_SG_07] [nvarchar](50) NULL,
						[TO_SG_07] [nvarchar](50) NULL,
						[CATE_07] [nvarchar](50) NULL,
						[KEY_07] [nvarchar](50) NULL,
						[TCAL_07] [nvarchar](50) NULL,
						[FROM_SG_08] [nvarchar](50) NULL,
						[TO_SG_08] [nvarchar](50) NULL,
						[CATE_08] [nvarchar](50) NULL,
						[KEY_08] [nvarchar](50) NULL,
						[TCAL_08] [nvarchar](50) NULL,
						[FROM_SG_09] [nvarchar](50) NULL,
						[TO_SG_09] [nvarchar](50) NULL,
						[CATE_09] [nvarchar](50) NULL,
						[KEY_09] [nvarchar](50) NULL,
						[TCAL_09] [nvarchar](50) NULL,
						[FROM_SG_10] [nvarchar](50) NULL,
						[TO_SG_10] [nvarchar](50) NULL,
						[CATE_10] [nvarchar](50) NULL,
						[KEY_10] [nvarchar](50) NULL,
						[TCAL_10] [nvarchar](50) NULL
					); 

				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_MATRIX_02') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_MATRIX_02

					CREATE TABLE #tmp_MST_SCM_SETUP_MATRIX_02(
						[MASTER_ID] [nvarchar](50) NULL,
						[PLAN_ID] [nvarchar](50) NULL,
						[COMPANY_ID] [nvarchar](150) NULL,
						[DIVISION_ID] [nvarchar](150) NULL,
						[SITE_ID] [nvarchar](150) NULL,
						[PLANT_ID] [nvarchar](150) NULL,
						[OPERATION_ID] [nvarchar](150) NULL,
						[LINE_SETUP_GROUP_ID] [nvarchar](150) NULL,
						[FROM_SETUP_GROUP_ID] [nvarchar](150) NULL,
						[TO_SETUP_GROUP_ID] [nvarchar](150) NULL,
						[S01_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S01_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S02_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S02_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S03_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S03_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S04_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S04_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S05_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S05_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S06_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S06_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S07_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S07_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S08_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S08_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S09_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S09_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S10_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S10_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[FULL_SETUP_FLAG] [nvarchar](1) NULL DEFAULT 'N',
						[DIE_CHANGE_FLAG] [nvarchar](1) NULL DEFAULT 'N'
					); 

				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_MATRIX_03') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_MATRIX_03

					CREATE TABLE #tmp_MST_SCM_SETUP_MATRIX_03(
						[MASTER_ID] [nvarchar](50) NULL,
						[PLAN_ID] [nvarchar](50) NULL,
						[COMPANY_ID] [nvarchar](150) NULL,
						[DIVISION_ID] [nvarchar](150) NULL,
						[SITE_ID] [nvarchar](150) NULL,
						[PLANT_ID] [nvarchar](150) NULL,
						[OPERATION_ID] [nvarchar](150) NULL,
						[LINE_SETUP_GROUP_ID] [nvarchar](150) NULL,
						[FROM_SETUP_GROUP_ID] [nvarchar](150) NULL,
						[TO_SETUP_GROUP_ID] [nvarchar](150) NULL,
						[S01_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S01_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S02_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S02_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S03_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S03_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S04_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S04_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S05_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S05_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S06_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S06_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S07_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S07_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S08_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S08_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S09_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S09_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[S10_SETUP_TIME] [numeric](20, 10) NULL DEFAULT 0,
						[S10_CALCULATION] [nvarchar](30) NULL DEFAULT 'MAX',
						[FULL_SETUP_FLAG] [nvarchar](1) NULL DEFAULT 'N',
						[DIE_CHANGE_FLAG] [nvarchar](1) NULL DEFAULT 'N',
						[GB] [nvarchar](30) NULL
					); 

				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_MATRIX') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_MATRIX

					CREATE TABLE #tmp_MST_SCM_SETUP_MATRIX(
						[MASTER_ID] [nvarchar](50) NULL,
						[PLAN_ID] [nvarchar](50) NULL,
						[COMPANY_ID] [nvarchar](150) NULL,
						[DIVISION_ID] [nvarchar](150) NULL,
						[SITE_ID] [nvarchar](150) NULL,
						[PLANT_ID] [nvarchar](150) NULL,
						[OPERATION_ID] [nvarchar](150) NULL,
						[LINE_SETUP_GROUP_ID] [nvarchar](150) NULL,
						[FROM_SETUP_GROUP_ID] [nvarchar](150) NULL,
						[TO_SETUP_GROUP_ID] [nvarchar](150) NULL,
						[SETUP_TIME] [numeric](20, 10) NULL,
						[SETUP_TIME_UOM] [nvarchar](30) NULL,
						[FULL_SETUP_FLAG] [nvarchar](1) NULL DEFAULT 'N',
						[DIE_CHANGE_FLAG] [nvarchar](1) NULL DEFAULT 'N'
					); 

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '1.00.1 END';
			SET @v_description = 'Process Complete...' + ' [CREATE] - INIT TMP TABLE' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			/*************************************************************************
			DEMAND 기준 PLAN BOM을 생성하고 SETUP 생성에 대한 기초정보를 구성한다
			--> 1. #tmp_MST_DEMAND_PLAN_BOM ( 플랜 대상을 선정하지 않을 경우 1~200만건의 SETUP DATA 가 생성됨 )
				- PLAN 대상 PLAN BOM 구성
				   - NET DEMAND
				   - FIXED PLAN
				2. #tmp_MST_ITEM_OPERATION
				- SETUP 대상 공정 구성
					- ITEM LINE ASSGIN 
					- SCM_ADM_LOOKUP_MASTER_DETAIL

				3. #tmp_MST_ITEM_LINE
				- SETUP 대상 LINE 구성
					- TACT TIME

			**************************************************************************/
			SET @v_log_type = 'TXN';
			SET @v_log_message = '2.01.0 START';
			SET @v_description = N'#tmp_MST_DEMAND_PLAN_BOM' ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			DELETE	A
			FROM	#tmp_MST_DEMAND_PLAN_BOM A
			WHERE	A.MASTER_ID = @p_master_id 
			AND		A.PLAN_ID   = @p_engine_plan_id 
			;		

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '2.01.1 END';
			SET @v_description = 'Process Complete...' + ' [DELETE]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			SET @v_log_type = 'TXN';
			SET @v_log_message = '2.02.0 START';
			SET @v_description = N'#tmp_MST_DEMAND_PLAN_BOM' ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			WITH CTE_TABLE(  CHILD_ITEM_ID, PARENT_ITEM_ID, TOP_ITEM_ID , LVL, SORT , MASTER_ID , PLAN_ID , SITE_ID , ROUTE_ID)
			AS
			(
				SELECT	CHILD_ITEM_ID
						, PARENT_ITEM_ID
						, PARENT_ITEM_ID TOP_ITEM_ID
						, 1 AS LVL
						, CONVERT (NVARCHAR(200), CHILD_ITEM_ID) AS SORT 
						, MASTER_ID 
						, PLAN_ID
						, SITE_ID
						, ROUTE_ID
				FROM	TH_ENG_PLAN_BOM_SN WITH ( NOLOCK )
				WHERE	master_id = @p_master_id
				AND		PLAN_ID = @p_engine_plan_id
				AND		PARENT_ITEM_ID 
										IN (
											SELECT  B.PRODUCT_ITEM_ID
											FROM    TH_ENG_NET_DEMAND_SN A ,
													TH_ENG_SALES_PRODUCT_MAP_SN B
											WHERE	A.master_id = @p_master_id
											AND		A.PLAN_ID = @p_engine_plan_id
											AND		A.MASTER_ID = B.MASTER_ID 
											AND		A.PLAN_ID = B.PLAN_ID
											AND		A.SALES_MODEL_ID = B.SALES_MODEL_ID
											GROUP BY B.PRODUCT_ITEM_ID
											)
				UNION ALL 
				SELECT	A.CHILD_ITEM_ID
						, A.PARENT_ITEM_ID
						, CTE.TOP_ITEM_ID TOP_ITEM_ID
						, cte.LVL + 1 AS LVL
						, CONVERT (NVARCHAR(200), CONVERT(NVARCHAR(200), cte.SORT) + '>' + CONVERT(NVARCHAR(200), A.CHILD_ITEM_ID)) AS SORT
						, A.MASTER_ID 
						, A.PLAN_ID
						, A.SITE_ID
						, A.ROUTE_ID
				FROM 
							( 
							SELECT	* 
							FROM	TH_ENG_PLAN_BOM_SN WITH ( NOLOCK )
							WHERE	master_id = @p_master_id
							AND		PLAN_ID = @p_engine_plan_id
							)  A  INNER JOIN CTE_TABLE cte ON substring ( A.site_id , 1, 4)  = substring ( cte.site_id , 1, 4)  AND A.PARENT_ITEM_ID = cte.CHILD_ITEM_ID 
			)
			INSERT INTO  #tmp_MST_DEMAND_PLAN_BOM
			(		MASTER_ID 
					, PLAN_ID 
					, TOP_ITEM_ID
					, PARENT_ITEM_ID
					, CHILD_ITEM_ID 
					, BOM_LVL 
					, BOM_PATH
					, SITE_ID 
					, ROUTE_ID
					, PLANT_ID
					) 
			SELECT DISTINCT 
						A.MASTER_ID 
					, A.PLAN_ID 
					, A.TOP_ITEM_ID
					, A.PARENT_ITEM_ID      as PARENT_ITEM_ID
					, A.CHILD_ITEM_ID   as CHILD_ITEM_ID
					, A.LVL          as lvl
					, A.SORT         as sort
					, A.SITE_ID 
					, A.ROUTE_ID
					, LEFT( A.SITE_ID  , 4) PLNT_ID
			FROM	 CTE_TABLE A WITH ( NOLOCK )
	--		ORDER BY A.MASTER_ID , A.PLAN_ID , A.TOP_ITEM_ID , A.LVL , A.SORT , A.SITE_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '2.02.1 RUN ' ;
			SET @v_description = 'Process Complete...' +  '[INSERT] - DEMAND' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			WITH CTE_TABLE(  CHILD_ITEM_ID, PARENT_ITEM_ID, TOP_ITEM_ID , LVL, SORT , MASTER_ID , PLAN_ID , SITE_ID , ROUTE_ID)
			AS
			(
				SELECT	CHILD_ITEM_ID
						, PARENT_ITEM_ID
						, PARENT_ITEM_ID TOP_ITEM_ID
						, 1 AS LVL
						, CONVERT (NVARCHAR(200), CHILD_ITEM_ID) AS SORT 
						, MASTER_ID 
						, PLAN_ID
						, SITE_ID
						, ROUTE_ID
				FROM	TH_ENG_PLAN_BOM_SN WITH ( NOLOCK )
				WHERE	master_id = @p_master_id
				AND		PLAN_ID = @p_engine_plan_id
				AND		PARENT_ITEM_ID 
										IN (
											SELECT	ITEM_ID
											FROM	TH_ENG_FIXED_PLAN_SN WITH ( NOLOCK )
											WHERE	MASTER_ID = @p_master_id
											AND		PLAN_ID = 	@p_engine_plan_id
											GROUP BY ITEM_ID
											)
				UNION ALL 
				SELECT	A.CHILD_ITEM_ID
						, A.PARENT_ITEM_ID
						, CTE.TOP_ITEM_ID TOP_ITEM_ID
						, cte.LVL + 1 AS LVL
						, CONVERT (NVARCHAR(200), CONVERT(NVARCHAR(200), cte.SORT) + '>' + CONVERT(NVARCHAR(200), A.CHILD_ITEM_ID)) AS SORT
						, A.MASTER_ID 
						, A.PLAN_ID
						, A.SITE_ID
						, A.ROUTE_ID
				FROM 
							( 
							SELECT	* 
							FROM	TH_ENG_PLAN_BOM_SN WITH ( NOLOCK )
							WHERE	master_id = @p_master_id
							AND		PLAN_ID = @p_engine_plan_id
							)  A  INNER JOIN CTE_TABLE cte ON	-- Substring ( A.site_id , 1, 4)  = substring ( cte.site_id , 1, 4)  AND 
																A.PARENT_ITEM_ID = cte.CHILD_ITEM_ID 
			)
			INSERT INTO  #tmp_MST_DEMAND_PLAN_BOM
			(		MASTER_ID 
					, PLAN_ID 
					, TOP_ITEM_ID
					, PARENT_ITEM_ID
					, CHILD_ITEM_ID 
					, BOM_LVL 
					, BOM_PATH
					, SITE_ID 
					, ROUTE_ID
					, PLANT_ID
					) 
			SELECT DISTINCT 
						A.MASTER_ID 
					, A.PLAN_ID 
					, A.TOP_ITEM_ID
					, A.PARENT_ITEM_ID      as PARENT_ITEM_ID
					, A.CHILD_ITEM_ID   as CHILD_ITEM_ID
					, A.LVL          as lvl
					, A.SORT         as sort
					, A.SITE_ID 
					, A.ROUTE_ID
					, LEFT( A.SITE_ID  , 4) PLNT_ID
			FROM	CTE_TABLE A WITH ( NOLOCK )
	--		ORDER BY A.MASTER_ID , A.PLAN_ID , A.TOP_ITEM_ID , A.LVL , A.SORT , A.SITE_ID
			;

			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '2.02.2 END ' ;
			SET @v_description = 'Process Complete...' +  '[INSERT] - FIXED' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			SET @v_log_type = 'TXN';
			SET @v_log_message = '2.03.0 START ';
			SET @v_description = N'#tmp_MST_ITEM_OPERATION';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			DELETE	#tmp_MST_ITEM_OPERATION
			WHERE	MASTER_ID = @p_master_id
			AND		PLAN_ID = @p_engine_plan_id ;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '2.03.1 END';
			SET @v_description = 'Process Complete...' + '[DELETE]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '2.04.0 START';
			SET @v_description = N'#tmp_MST_ITEM_OPERATION';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			WITH ITEM_OPERATION_INFO AS
										(
											SELECT	A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,
													A.ITEM_ID , A.OPERATION_ID , C.SCP_FLOW_ID -- , LEFT ( C.SCP_FLOW_ID , LEN( A.OPERATION_ID)) SCP_OPERATION
											FROM	SCM_ITEM_LINE_ASSIGN_M_SN A WITH ( NOLOCK ) ,
													(
													SELECT  PLANT_ID , ITEM_ID
													FROM
															(   
															SELECT	PLANT_ID , PARENT_ITEM_ID ITEM_ID
															FROM	#tmp_MST_DEMAND_PLAN_BOM WITH ( NOLOCK ) 
															WHERE	MASTER_ID = @p_master_id
															AND		PLAN_ID   = @p_engine_plan_id
															UNION ALL
															SELECT PLANT_ID , CHILD_ITEM_ID 
															FROM	#tmp_MST_DEMAND_PLAN_BOM WITH ( NOLOCK ) 
															WHERE	MASTER_ID = @p_master_id
															AND		PLAN_ID   = @p_engine_plan_id
															) DEMAND_ITEM
													GROUP BY PLANT_ID , ITEM_ID					
													) B ,
													SCM_ITEM_M_SN C WITH ( NOLOCK ) 
											WHERE	A.ITEM_ID = B.ITEM_ID
											AND		A.PLANT_ID = B.PLANT_ID
											AND	    A.ITEM_ID = C.ITEM_ID
											AND		A.SITE_ID = C.SITE_ID
											AND		A.DIVISION_ID = C.DIVISION_ID
											AND		A.COMPANY_ID = C.COMPANY_ID
											AND		A.OPERATION_ID = LEFT ( C.SCP_FLOW_ID , LEN( A.OPERATION_ID))
											AND	    C.ACTIVE_FLAG ='Y'
											AND	    A.ACTIVE_FLAG ='Y'
											AND		A.MONTH >= SUBSTRING(CONVERT ( CHAR(8) , GETDATE() , 112) , 1 , 6)
											GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,
													 A.ITEM_ID , A.OPERATION_ID , C.SCP_FLOW_ID , LEFT ( C.SCP_FLOW_ID , LEN( A.OPERATION_ID)) 
											) 
			INSERT INTO #tmp_MST_ITEM_OPERATION
			(
					MASTER_ID ,
					PLAN_ID , 
					COMPANY_ID , 
					DIVISION_ID , 
					SITE_ID , 
					PLANT_ID ,
					ITEM_ID , 
					OPERATION_ID , 
					SCP_FLOW_ID ,
					USE_SETUP ,
					USE_CAPA					
					)
			SELECT	@p_master_id AS MASTER_ID ,
					@p_engine_plan_id AS PLAN_ID , 
					A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,
					A.ITEM_ID , A.OPERATION_ID , A.SCP_FLOW_ID ,
					CASE 
						WHEN B.OPERATION_ID IS NULL THEN 
							CASE 
								WHEN LEFT( A.OPERATION_ID , 1 ) = 'E'  THEN 'Y'
								ELSE
										'N'
							END
						ELSE
							CASE 
								WHEN LEFT( A.OPERATION_ID , 1 ) = 'E'  THEN 'Y'
								ELSE
										'N'
							END
					END USE_SETUP ,
					CASE 
						WHEN B.OPERATION_ID IS NULL THEN 'N'
						ELSE
							'Y'
					END USE_CAPA						
			FROM   (
					SELECT  SEGMENT2	OPERATION_ID
					FROM	SCM_ADM_LOOKUP_MASTER_DETAIL
					WHERE	LOOKUP_TYPE ='SCP_SETUP_OPERATION'
					AND		SEGMENT1	= @p_division_id
					AND		VALID_YN    = 'Y'
					) B RIGHT OUTER JOIN ITEM_OPERATION_INFO A ON A.OPERATION_ID = B.OPERATION_ID 
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '2.04.1 END';
			SET @v_description = 'Process Complete...' + '[INSERT]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '2.05.0 START';
			SET @v_description = N'#tmp_MST_ITEM_LINE' ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			DELETE	#tmp_MST_ITEM_LINE
			WHERE	MASTER_ID = @p_master_id
			AND		PLAN_ID = @p_engine_plan_id ;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '2.05.1 END';
			SET @v_description = 'Process Complete...' + '[DELETE]';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '2.06.0 START';
			SET @v_description = N'#tmp_MST_ITEM_LINE';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			INSERT INTO #tmp_MST_ITEM_LINE
			(		
					MASTER_ID ,
					PLAN_ID , 
					COMPANY_ID , 
					DIVISION_ID , 
					SITE_ID , 
					PLANT_ID ,
					ITEM_ID , 
					OPERATION_ID , 
					LINE_ID , 
					LINE_SETUP_GROUP_ID , 
					RESOURCE_ID
					)
			SELECT	@p_master_id AS MASTER_ID ,
					@p_engine_plan_id AS PLAN_ID , 
					A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,
					A.ITEM_ID , A.OPERATION_ID , A.LINE_ID , 
					CASE 
						WHEN B.LINE_SETUP_GROUP_ID IS NULL THEN '-' 
						WHEN B.LINE_SETUP_GROUP_ID ='' THEN '-'
						ELSE
							CASE
								WHEN C.USE_SETUP ='Y' THEN B.LINE_SETUP_GROUP_ID
								ELSE
									'-'
							END		
					END LINE_SETUP_GROUP_ID , 
					CASE	
						WHEN C.USE_CAPA ='Y' THEN A.OPERATION_ID + '::' + A.PLANT_ID + '-'+  LEFT( A.OPERATION_ID , 1) +'~***' + '::' + A.LINE_ID 
						ELSE
							 A.OPERATION_ID + '::' + A.PLANT_ID + '-'+  LEFT( A.OPERATION_ID , 1) +'~***' + '::' + '-'
					END RESOURCE_ID
			FROM   SCM_MST_TACT_TIME_SN A WITH ( NOLOCK ) ,
				   SCM_LINE_M_SN B WITH ( NOLOCK ) ,
				   (
					SELECT	*
					FROM	#tmp_MST_ITEM_OPERATION WITH ( NOLOCK ) 
					WHERE	MASTER_ID = @p_master_id 
					AND		PLAN_ID = @p_engine_plan_id 
				   ) C
			WHERE  1 = 1
			AND    A.COMPANY_ID = C.COMPANY_ID
			AND    A.DIVISION_ID = C.DIVISION_ID 
			AND    A.SITE_ID = C.SITE_ID 
			AND    A.PLANT_ID = C.PLANT_ID
			AND    A.OPERATION_ID = C.OPERATION_ID
			AND    A.ITEM_ID = C.ITEM_ID
			AND    A.COMPANY_ID = B.COMPANY_ID
			AND    A.DIVISION_ID = B.DIVISION_ID 
			AND    A.SITE_ID = B.SITE_ID 
			AND    A.PLANT_ID = B.PLANT_ID
			AND    A.OPERATION_ID = B.OPERATION_ID
			AND    A.LINE_ID = B.LINE_ID
			AND	   A.MONTH >= SUBSTRING(CONVERT ( CHAR(8) , GETDATE() , 112) , 1 , 6)
			AND    B.ACTIVE_FLAG ='Y'
			GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,
				   A.ITEM_ID , A.OPERATION_ID , A.LINE_ID , 
				   CASE 
						WHEN B.LINE_SETUP_GROUP_ID IS NULL THEN '-' 
						WHEN B.LINE_SETUP_GROUP_ID ='' THEN '-'
						ELSE
							CASE
								WHEN C.USE_SETUP ='Y' THEN B.LINE_SETUP_GROUP_ID
								ELSE
									'-'
							END						
				   END ,
				   CASE	
						WHEN C.USE_CAPA ='Y' THEN A.OPERATION_ID + '::' + A.PLANT_ID + '-'+  LEFT( A.OPERATION_ID , 1) +'~***' + '::' + A.LINE_ID 
						ELSE
							 A.OPERATION_ID + '::' + A.PLANT_ID + '-'+  LEFT( A.OPERATION_ID , 1) +'~***' + '::' + '-'
				   END 
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '2.06.1 END';
			SET @v_description = 'Process Complete...' + '[INSERT]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			/*************************************************************************
			SETUP 기준정보 구성
			--> 1. TH_MST_SCM_SETUP_BOM 
				- SETUP 대상에 대한 BOM 구성

				2. TH_MST_SCM_ITEM_LIST_SN 
				- SETUP CATEGORY = 'MATERIAL 대상 ITEM LIST 생성
				   -> 투입 자재 속성 

				3. TH_MST_SCM_ITEM_COMBINE_SN
				- SETUP ITEM COMBINE ( 결합 ) 생성

			**************************************************************************/

			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.01.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_BOM' ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			DELETE	#tmp_MST_SCM_SETUP_BOM
			WHERE	MASTER_ID = @p_master_id 
			AND		PLAN_ID = @p_engine_plan_id;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.01.1 END';
			SET @v_description = 'Process Complete...' + '[DELETE]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.02.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_BOM';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			INSERT INTO #tmp_MST_SCM_SETUP_BOM
			(
					MASTER_ID ,
					PLAN_ID , 
					COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID , 
					PARENT_ITEM_ID, OPERATION_ID, CHILD_ITEM_ID, ITEM_TYPE, 
					SETUP_KEY_ID, SETUP_ATTRIBUTE, ITEM_ATTRIBUTE
					)
			SELECT DISTINCT
					@p_master_id AS MASTER_ID ,
					@p_engine_plan_id AS PLAN_ID , 
					A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , 
					A.PARENT_ITEM_ID, B.OPERATION_ID, A.CHILD_ITEM_ID, C.ITEM_TYPE, 
					D.LEVEL_2_CODE AS SETUP_KEY_ID, C.SETUP_ATTRIBUTE, C.ITEM_ATTRIBUTE
			FROM   (
					SELECT AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID , AA.PARENT_ITEM_ID, AA.CHILD_ITEM_ID
					FROM   SCM_BOM_M_SN AA WITH(NOLOCK),
							(
							SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID,
									MAX(KEY_DATE) AS KEY_DATE
							FROM    SCM_BOM_M_SN         A WITH(NOLOCK),
									SCM_ITEM_M_SN        B WITH(NOLOCK),
									SCM_ITEM_CLASS_M_SN  C WITH(NOLOCK)
							WHERE  1=1
							AND    A.ACTIVE_FLAG    = 'Y'
							AND    A.COMPANY_ID     = B.COMPANY_ID
							AND    A.DIVISION_ID    = B.DIVISION_ID
							AND    A.SITE_ID        = B.SITE_ID
							AND    A.CHILD_ITEM_ID  = B.ITEM_ID  
							AND    B.ACTIVE_FLAG    = 'Y'
							AND    B.ITEM_CLASS     = C.CLASS_ID  
							AND    C.USE_FLAG       = 'Y'      
							AND    A.BOM_VERSION_ID = '1'
							AND    A.EFF_END_DATE   >  GETDATE()
							GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
							) BB
					WHERE  AA.COMPANY_ID      = BB.COMPANY_ID
					AND    AA.DIVISION_ID     = BB.DIVISION_ID
					AND    AA.SITE_ID         = BB.SITE_ID
					AND    AA.PLANT_ID        = BB.PLANT_ID
					AND    AA.PARENT_ITEM_ID  = BB.PARENT_ITEM_ID
					AND    AA.CHILD_ITEM_ID   = BB.CHILD_ITEM_ID
					AND    AA.KEY_DATE        = BB.KEY_DATE
					AND    AA.ACTIVE_FLAG     = 'Y'
					AND    AA.BOM_VERSION_ID = '1'
					AND    AA.EFF_END_DATE   >  GETDATE()
					GROUP BY AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID , AA.PARENT_ITEM_ID, AA.CHILD_ITEM_ID
					) A,
					(
					SELECT	*
					FROM	#tmp_MST_ITEM_OPERATION WITH ( NOLOCK ) 
					WHERE	MASTER_ID = @p_master_id 
					AND		PLAN_ID	= @p_engine_plan_id 
					AND		USE_SETUP = 'Y'
					) B,
					SCM_ITEM_M_SN        C WITH(NOLOCK),
					SCM_ITEM_CLASS_M_SN  D WITH(NOLOCK)
			WHERE	1=1
			AND		A.COMPANY_ID  = B.COMPANY_ID
			AND		A.DIVISION_ID = B.DIVISION_ID
			AND		A.SITE_ID     = B.SITE_ID
			AND		A.PLANT_ID	  = B.PLANT_ID
			AND		A.PARENT_ITEM_ID = B.ITEM_ID 
			AND		A.COMPANY_ID     = C.COMPANY_ID
			AND		A.DIVISION_ID    = C.DIVISION_ID
			AND		A.SITE_ID        = C.SITE_ID
			AND		A.CHILD_ITEM_ID  = C.ITEM_ID
			AND		C.ACTIVE_FLAG    = 'Y'
			AND		C.ITEM_CLASS     = D.CLASS_ID
			AND		D.USE_FLAG       = 'Y'
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.02.1 END';
			SET @v_description = 'Process Complete...' + '[INSERT]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.03.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_ITEM_LIST' ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			DELETE	#tmp_MST_SCM_SETUP_ITEM_LIST
			WHERE	MASTER_ID = @p_master_id 
			AND		PLAN_ID	= @p_engine_plan_id;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.03.1 END';
			SET @v_description = 'Process Complete...' + '[DELETE]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.04.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_ITEM_LIST';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			INSERT INTO #tmp_MST_SCM_SETUP_ITEM_LIST
			(		
				MASTER_ID , PLAN_ID , COMPANY_ID ,DIVISION_ID ,SITE_ID , PLANT_ID , SETUP_CATEGORY_ID ,SETUP_KEY_ID ,LEVEL ,ITEM_ID ,OPERATION_ID ,CALCULATION ,SETUP_ATTRIBUTE ,ITEM_ATTRIBUTE ,
				ITEM_ATTB_CNT ,ATTB_CNT_TOTAL ,ITEM_ATTB_KIND
			)
			SELECT  A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, A.KEY_ITEM_ID, A.KEY_OPERATION_ID, A.CALCULATION, A.SETUP_ATTRIBUTE, A.ITEM_ATTRIBUTE 
					, ITEM_ATTB_CNT  ---+ 컬럼추가. 
					, SUM(ITEM_ATTB_CNT)    OVER(PARTITION BY A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, A.KEY_ITEM_ID, A.KEY_OPERATION_ID, A.CALCULATION ) AS ATTB_CNT_TOTAL  ---+ 컬럼추가. 
					, COUNT(ITEM_ATTRIBUTE) OVER(PARTITION BY A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, A.KEY_ITEM_ID, A.KEY_OPERATION_ID, A.CALCULATION ) AS ITEM_ATTB_KIND  ---+ 컬럼추가. 
			FROM	(
					SELECT  DISTINCT A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, A.KEY_ITEM_ID, A.KEY_OPERATION_ID, A.CALCULATION, A.SETUP_ATTRIBUTE, A.ITEM_ATTRIBUTE 
						,	COUNT(ITEM_ATTRIBUTE) OVER(PARTITION BY MASTER_ID , PLAN_ID , COMPANY_ID , DIVISION_ID, SITE_ID, PLANT_ID , SETUP_CATEGORY_ID , SETUP_KEY_ID, LEVEL, KEY_ITEM_ID , KEY_OPERATION_ID , CALCULATION, SETUP_ATTRIBUTE, ITEM_ATTRIBUTE ) AS ITEM_ATTB_CNT  
					FROM   ( 
						  SELECT DISTINCT 
								 A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ,  A.SETUP_CATEGORY_ID,
								 A.SETUP_KEY_ID, A.LEVEL, 
								 A.KEY_ITEM_ID, 
								 A.KEY_OPERATION_ID,
								 A.CALCULATION,
								 '' SETUP_ATTRIBUTE,
								 A.ITEM_ATTRIBUTE , 
								 A.ATTB_ITEM_ID   ---+ 요거추가하고. 
						  FROM   (
								  SELECT AA.MASTER_ID , AA.PLAN_ID , AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID , 
										 AA.SETUP_CATEGORY_ID, AA.SETUP_KEY_ID, AA.LEVEL, 
										 AA.REFERANCE_OPERATION_ID, AA.CALCULATION, AA.SORT_ORDER,
										 AA.KEY_ITEM_ID, AA.KEY_OPERATION_ID,
										 CASE WHEN OPERATION_ID_1 = AA.REFERANCE_OPERATION_ID THEN SETUP_ATTRIBUTE_2
											  WHEN OPERATION_ID_2 = AA.REFERANCE_OPERATION_ID THEN SETUP_ATTRIBUTE_3
											  ELSE ''
										 END  SETUP_ATTRIBUTE,
										 CASE WHEN OPERATION_ID_1 = AA.REFERANCE_OPERATION_ID THEN ITEM_ATTRIBUTE_2
											  WHEN OPERATION_ID_2 = AA.REFERANCE_OPERATION_ID THEN ITEM_ATTRIBUTE_3
											  ELSE ''
										 END  ITEM_ATTRIBUTE
										 ,CASE WHEN OPERATION_ID_1 = AA.REFERANCE_OPERATION_ID THEN ITEM_ID_2   ---+ 요거추가하고. 
											   WHEN OPERATION_ID_2 = AA.REFERANCE_OPERATION_ID THEN ITEM_ID_3
											   ELSE ''
										 END  ATTB_ITEM_ID
								  FROM   (
										  SELECT A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , 
												 A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
												 A.REFERANCE_OPERATION_ID, A.CALCULATION, A.SORT_ORDER,
												 A.KEY_ITEM_ID, A.KEY_OPERATION_ID, 
												 A.ITEM_ID_1, A.OPERATION_ID_1, A.ITEM_TYPE_1, A.SETUP_ATTRIBUTE_1, A.ITEM_ATTRIBUTE_1,
												 A.ITEM_ID_2, C.OPERATION_ID AS OPERATION_ID_2, A.ITEM_TYPE_2, A.SETUP_ATTRIBUTE_2, A.ITEM_ATTRIBUTE_2,    --->  CHILD_1
												 C.CHILD_ITEM_ID ITEM_ID_3, C.ITEM_TYPE ITEM_TYPE_3, C.SETUP_ATTRIBUTE SETUP_ATTRIBUTE_3, C.ITEM_ATTRIBUTE ITEM_ATTRIBUTE_3    --->  CHILD_2 
										  FROM   (  
												  SELECT A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ,
														 A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
														 A.REFERANCE_OPERATION_ID, A.CALCULATION, A.SORT_ORDER,
														 A.KEY_ITEM_ID, A.KEY_OPERATION_ID, A.ITEM_ID_1, B.OPERATION_ID OPERATION_ID_1, A.ITEM_TYPE_1, A.SETUP_ATTRIBUTE_1, A.ITEM_ATTRIBUTE_1,
														 B.CHILD_ITEM_ID ITEM_ID_2, B.ITEM_TYPE ITEM_TYPE_2, B.SETUP_ATTRIBUTE SETUP_ATTRIBUTE_2, B.ITEM_ATTRIBUTE ITEM_ATTRIBUTE_2
												  FROM   (
														SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , 
																B.SETUP_CATEGORY_ID, B.SETUP_KEY_ID, B.LEVEL, 
																B.REFERANCE_OPERATION_ID, B.CALCULATION, B.SORT_ORDER,                                
																A.PARENT_ITEM_ID AS KEY_ITEM_ID, 
																A.OPERATION_ID  AS KEY_OPERATION_ID, 
																-- OPERATION_ID 와 REFERANCE_OPERATION_ID 가 동일할 경우 발생
																CASE B.OPERATION_ID 
																WHEN B.REFERANCE_OPERATION_ID THEN A.PARENT_ITEM_ID
																								ELSE A.CHILD_ITEM_ID 
																END  ITEM_ID_1, 
																A.ITEM_TYPE ITEM_TYPE_1, A.SETUP_ATTRIBUTE SETUP_ATTRIBUTE_1, A.ITEM_ATTRIBUTE ITEM_ATTRIBUTE_1
														FROM	#tmp_MST_SCM_SETUP_BOM A WITH ( NOLOCK ) ,
																(
																SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
																		A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
																		A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
																FROM	SCM_MST_ITEM_SETUP_GROUP_SN  A WITH ( NOLOCK ) ,
																		SCM_SYS_LOOKUP_VALUE_SN    B WITH ( NOLOCK ) 
																WHERE  B.LOOKUP_TYPE_CODE = 'SETUP_CATEGORY'
																AND    UPPER(A.SETUP_CATEGORY_ID) = UPPER('MATERIAL')
																AND    A.SETUP_CATEGORY_ID = B.SEGMENT1
																--AND    A.OPERATION_ID != A.REFERANCE_OPERATION_ID
																GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
																		A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
																		A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
																) B
														WHERE	A.MASTER_ID = @p_master_id
														AND		A.PLAN_ID	= @p_engine_plan_id 
														AND		A.COMPANY_ID = B.COMPANY_ID
														AND		A.DIVISION_ID = B.DIVISION_ID
														AND		A.SITE_ID = B.SITE_ID
														AND		A.OPERATION_ID = B.OPERATION_ID   
														) A
														LEFT OUTER JOIN #tmp_MST_SCM_SETUP_BOM B
														ON     1=1
														AND    A.MASTER_ID = B.MASTER_ID
														AND    A.PLAN_ID = B.PLAN_ID
														AND    A.COMPANY_ID = B.COMPANY_ID
														AND    A.DIVISION_ID = B.DIVISION_ID
														AND    A.SITE_ID = B.SITE_ID
														AND    A.PLANT_ID = B.PLANT_ID
														AND    A.ITEM_ID_1 = B.PARENT_ITEM_ID
														AND    A.SETUP_KEY_ID = B.SETUP_KEY_ID    
												) A
												LEFT OUTER JOIN #tmp_MST_SCM_SETUP_BOM C
												ON     1=1
												AND    A.MASTER_ID = C.MASTER_ID
												AND    A.PLAN_ID = C.PLAN_ID
												AND    A.COMPANY_ID = C.COMPANY_ID
												AND    A.DIVISION_ID = C.DIVISION_ID
												AND    A.SITE_ID = C.SITE_ID
												AND    A.PLANT_ID = C.PLANT_ID
												AND    A.ITEM_ID_2 = C.PARENT_ITEM_ID
												AND    A.SETUP_KEY_ID = C.SETUP_KEY_ID
										 ) AA
								 ) A
							WHERE  EXISTS (
											SELECT 1
											FROM   SCM_SYS_LOOKUP_VALUE_SN B WITH ( NOLOCK ) 
											WHERE  B.LOOKUP_TYPE_CODE = 'ITEM_ATTRIBUTE'
											AND    A.SETUP_KEY_ID = B.SEGMENT3
											AND    A.DIVISION_ID = B.SEGMENT1
											AND    A.SITE_ID = B.SEGMENT2
											AND    A.ITEM_ATTRIBUTE = B.SEGMENT4
										  )      
	--						AND   A.KEY_ITEM_ID ='APCCA0345A'									  
							) A 
	--				WHERE  A.KEY_ITEM_ID ='APCCA0345A'
					) A 
			WHERE  1=1      
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.04.1 RUN';
			SET @v_description = 'Process Complete...' + '[INSERT]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			DELETE	#tmp_MST_SCM_SETUP_ITEM_LIST
			WHERE	MASTER_ID = @p_master_id
			AND		PLAN_ID = @p_engine_plan_id
			AND		OPERATION_ID NOT IN
										(
										SELECT  SEGMENT2
										FROM	SCM_ADM_LOOKUP_MASTER_DETAIL  WITH ( NOLOCK ) 
										WHERE	LOOKUP_TYPE ='SCP_SETUP_OPERATION'
										AND		SEGMENT1	= @p_division_id
										AND		VALID_YN    = 'Y'
										)
			;

					-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.04.2 END';
			SET @v_description = 'Process Complete...' + '[DELETE] - != SETUP OPERATION' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.05.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_ITEM_COMBINE' ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			DELETE	#tmp_MST_SCM_SETUP_ITEM_COMBINE
			WHERE	MASTER_ID = @p_master_id
			AND		PLAN_ID = @p_engine_plan_id;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.05.1 END';
			SET @v_description = 'Process Complete...' + '[DELETE]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.06.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_ITEM_COMBINE';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			/*
			SETUP CATEGORY = MATERIAL COMBINE ( 'ITEM_ATTRIBUTE_COMBINE' ) 
			*/

			INSERT INTO #tmp_MST_SCM_SETUP_ITEM_COMBINE
			(
				MASTER_ID , PLAN_ID , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID , SETUP_CATEGORY_ID, SETUP_KEY_ID, LEVEL, 
				ITEM_ID, OPERATION_ID, CALCULATION, ITEM_SETUP_GROUP_ID
			)
			SELECT	DISTINCT
					A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
					A.ITEM_ID, A.OPERATION_ID, A.CALCULATION, A.ITEM_SETUP_GROUP_ID
			FROM	(	
					SELECT 
							A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
							A.ITEM_ID , A.OPERATION_ID, A.CALCULATION,
							A.ITEM_ATTRIBUTE, 
							A.SEGMENT4   AS ITEM_SETUP_GROUP_ID
							, SUM(SCORE2+SCORE1) AS SUM_SCORE
							, DENSE_RANK() OVER( PARTITION BY A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, A.ITEM_ID , A.OPERATION_ID, A.CALCULATION 
													ORDER BY SUM(SCORE2+SCORE1) DESC ) AS RNK 
					FROM	(
							SELECT  A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, A.ITEM_ID, A.OPERATION_ID, A.CALCULATION, A.ITEM_ATTRIBUTE , A.ITEM_ATTB_KIND ,A.ITEM_ATTB_CNT
									, B.SEGMENT4  , B.ITEM_ATTB_KIND AS B_ITEM_ATTB_KIND, B.SEGMENT4_CNT , B.ITEM_ATTB_CNT AS B_ITEM_ATTB_CNT
									--, SUM(B.ITEM_ATTB_CNT) OVER(PARTITION BY A.ITEM_ID , A.OPERATION_ID , A.DIVISION_ID , A.SITE_ID, A.SETUP_KEY_ID , B.SEGMENT4 )  AS SS   --+ 데이터 검수용
									, CASE WHEN SUM(B.ITEM_ATTB_CNT) OVER(PARTITION BY A.MASTER_ID , A.PLAN_ID , A.ITEM_ID , A.OPERATION_ID , A.DIVISION_ID , A.SITE_ID, A.PLANT_ID , A.SETUP_KEY_ID , B.SEGMENT4 ) = B.SEGMENT4_CNT THEN 1  ELSE 0  END SCORE1 --+ 정의된 인자개수 동일하면 1점.
									, CASE WHEN B.ITEM_ATTB_KIND = 1 AND A.ITEM_ATTB_CNT = B.ITEM_ATTB_CNT  THEN 1 ELSE 0  END SCORE2  --+ NCM622 와 NCM622+NCM622 구분용. 
							FROM	(
									SELECT  A.* 
									FROM	#tmp_MST_SCM_SETUP_ITEM_LIST A  WITH ( NOLOCK ) 
									WHERE   A.MASTER_ID = @p_master_id
									AND		A.PLAN_ID = @p_engine_plan_id
									) A  ,	
									( 
									SELECT   
											A.SEGMENT1     -- DIVISION_ID
											, A.SEGMENT2   -- SITE_ID
											, A.SEGMENT3   -- SETUP_KETY_ID
											, A.SEGMENT4   -- SETUP_GROUP
											, A.ITEM_ATTRIBUTE 
											, A.SEGMENT4_CNT  -- ITEM_ATTRIBUTE의 TOTAL COUNT 
											, A.ITEM_ATTB_CNT -- ITEM_ATTBIBUTE별 개수 
											, COUNT(ITEM_ATTRIBUTE) OVER(PARTITION BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4 ) AS ITEM_ATTB_KIND  --- ITEM_ATTRIBUTE 종류개수.
									FROM    (
											SELECT  DISTINCT
													A.SEGMENT1, A.SEGMENT2, A.SEGMENT3, A.SEGMENT4, A.ITEM_ATTRIBUTE , A.SEGMENT4_CNT   
													, COUNT(1) OVER (PARTITION BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, ITEM_ATTRIBUTE) ITEM_ATTB_CNT 
											FROM	(
													SELECT A.*
														, ROW_NUMBER() OVER (PARTITION BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4 ORDER BY ITEM_ATTRIBUTE) SEGMENT4_SEQ
														, COUNT(1) OVER (PARTITION BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4) SEGMENT4_CNT            
													FROM   (
															SELECT	SEGMENT1
																	, SEGMENT2
																	, SEGMENT3
																	, SEGMENT4
																	, CASE  WHEN INT = 1 THEN CASE WHEN ISNULL(LTRIM(RTRIM(ATTRIBUTE1)),'') = '' THEN '' ELSE ATTRIBUTE1 END
																			WHEN INT = 2 THEN CASE WHEN ISNULL(LTRIM(RTRIM(ATTRIBUTE2)),'') = '' THEN '' ELSE ATTRIBUTE2 END
																			WHEN INT = 3 THEN CASE WHEN ISNULL(LTRIM(RTRIM(ATTRIBUTE3)),'') = '' THEN '' ELSE ATTRIBUTE3 END
																			WHEN INT = 4 THEN CASE WHEN ISNULL(LTRIM(RTRIM(ATTRIBUTE4)),'') = '' THEN '' ELSE ATTRIBUTE4 END
																			WHEN INT = 5 THEN CASE WHEN ISNULL(LTRIM(RTRIM(ATTRIBUTE5)),'') = '' THEN '' ELSE ATTRIBUTE5 END
																			ELSE ''
																	  END  ITEM_ATTRIBUTE
															FROM	SCM_SYS_LOOKUP_VALUE_SN  A WITH ( NOLOCK ) 
																	, COPYT_SN                    B
															WHERE	LOOKUP_TYPE_CODE = 'ITEM_ATTRIBUTE_COMBINE'
															AND		INT <= 5
															) A
													WHERE  ITEM_ATTRIBUTE != ''
	--												AND	   SEGMENT3 ='RCA'
													) A 
											) A 
									WHERE  1=1 
	--								AND	    A.ITEM_ATTRIBUTE  IN ( 'LMO','NCM523')
									) B
							WHERE	A.DIVISION_ID    = B.SEGMENT1
							AND		A.SITE_ID        = B.SEGMENT2
							AND		A.SETUP_KEY_ID   = B.SEGMENT3
							AND		A.ITEM_ATTRIBUTE = B.ITEM_ATTRIBUTE
							AND		A.ITEM_ATTB_KIND  = B.ITEM_ATTB_KIND
							) A
	--				WHERE   A.ITEM_ID ='APCCA0345A'
					GROUP BY 	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
								A.ITEM_ID , A.OPERATION_ID, A.CALCULATION, A.ITEM_ATTRIBUTE, A.SEGMENT4
					) A
			WHERE	1=1
			AND		A.RNK = 1 
			AND		A.ITEM_SETUP_GROUP_ID IN (      
												SELECT  ITEM_SETUP_GROUP_ID 
												FROM    (
														SELECT  DISTINCT A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.SETUP_CATEGORY_ID , A.SETUP_KEY_ID , FROM_ITEM_SETUP_GROUP_ID AS ITEM_SETUP_GROUP_ID 
														FROM  SCM_SETUP_MATRIX_M_SN  A WITH ( NOLOCK ) 
														UNION ALL 
														SELECT  DISTINCT A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.OPERATION_ID , A.SETUP_CATEGORY_ID , A.SETUP_KEY_ID , TO_ITEM_SETUP_GROUP_ID AS ITEM_SETUP_GROUP_ID 
														FROM  SCM_SETUP_MATRIX_M_SN  A WITH ( NOLOCK ) 
														) X 
												WHERE	1=1
												AND		A.COMPANY_ID   = X.COMPANY_ID 
												AND		A.DIVISION_ID  = X.DIVISION_ID
												AND		A.SITE_ID      = X.SITE_ID
												AND		A.PLANT_ID     = X.PLANT_ID
												AND		A.SETUP_KEY_ID = X.SETUP_KEY_ID
												)  
	--		AND		A.ITEM_ID ='APCCA0345A'
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.06.1 RUN';
			SET @v_description = 'Process Complete...' + '[INSERT] - Material = ITEM_ATTRIBUTE_COMBINE' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			/*
			SETUP CATEGORY = MATERIAL COMBINE ( != 'ITEM_ATTRIBUTE_COMBINE' ) 
			*/

			INSERT INTO #tmp_MST_SCM_SETUP_ITEM_COMBINE
			(
					MASTER_ID , PLAN_ID , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID  , SETUP_CATEGORY_ID, SETUP_KEY_ID, LEVEL, 
					ITEM_ID, OPERATION_ID, CALCULATION,	ITEM_SETUP_GROUP_ID      
					)
			SELECT DISTINCT
					A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  , A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
					A.ITEM_ID, A.OPERATION_ID, A.CALCULATION, A.ITEM_ATTRIBUTE AS ITEM_SETUP_GROUP_ID      
			FROM	#tmp_MST_SCM_SETUP_ITEM_LIST A WITH ( NOLOCK ) 
			WHERE   A.MASTER_ID = @p_master_id
			AND		A.PLAN_ID = @p_engine_plan_id
			AND		A.ITEM_ATTRIBUTE != ''
			AND		NOT EXISTS (
								SELECT	1
								FROM	#tmp_MST_SCM_SETUP_ITEM_COMBINE B WITH ( NOLOCK ) 
								WHERE	A.MASTER_ID = B.MASTER_ID
								AND		A.PLAN_ID = B.PLAN_ID
								AND		A.COMPANY_ID = B.COMPANY_ID
								AND		A.DIVISION_ID = B.DIVISION_ID
								AND		A.SITE_ID = B.SITE_ID
								AND		A.PLANT_ID = B.PLANT_ID
								AND		A.SETUP_CATEGORY_ID = B.SETUP_CATEGORY_ID
								AND		A.SETUP_KEY_ID = B.SETUP_KEY_ID
								AND		A.ITEM_ID = B.ITEM_ID
								AND		A.OPERATION_ID = B.OPERATION_ID
								)
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.06.2 RUN';
			SET @v_description = 'Process Complete...' + '[INSERT] - Material != ITEM_ATTRIBUTE_COMBINE' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			INSERT INTO #tmp_MST_SCM_SETUP_ITEM_COMBINE
			(
					MASTER_ID , PLAN_ID , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID  , SETUP_CATEGORY_ID, SETUP_KEY_ID, LEVEL, 
					ITEM_ID, OPERATION_ID, CALCULATION,	ITEM_SETUP_GROUP_ID      
					)
			SELECT	DISTINCT 
					A.MASTER_ID , A.PLAN_ID ,  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ,	A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
					A.ITEM_ID, A.OPERATION_ID, A.CALCULATION, A.ITEM_SETUP_GROUP_ID 
			FROM	(
					SELECT DISTINCT
							B.MASTER_ID , B.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, B.PLANT_ID ,
							A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
							B.ITEM_ID, B.OPERATION_ID, A.CALCULATION,
							C.SETUP_ATTRIBUTE AS ITEM_SETUP_GROUP_ID         
					FROM   (
							SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
									A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
									A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
							FROM    SCM_MST_ITEM_SETUP_GROUP_SN  A  WITH ( NOLOCK ) ,
									SCM_SYS_LOOKUP_VALUE_SN    B WITH ( NOLOCK ) 
							WHERE	B.LOOKUP_TYPE_CODE = 'SETUP_CATEGORY'
							AND		UPPER(A.SETUP_CATEGORY_ID) = UPPER('ATTRIBUTE')
							AND		A.SETUP_CATEGORY_ID = B.SEGMENT1
							AND		A.OPERATION_ID != A.REFERANCE_OPERATION_ID
							GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
									A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
									A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
							) A,
							(
							SELECT	*
							FROM	#tmp_MST_ITEM_OPERATION WITH ( NOLOCK ) 
							WHERE	MASTER_ID = @p_master_id
							AND		PLAN_ID = @p_engine_plan_id 
							)  B,
							SCM_ITEM_M_SN      C WITH(NOLOCK)
					WHERE  A.COMPANY_ID = B.COMPANY_ID
					AND    A.DIVISION_ID = B.DIVISION_ID
					AND    A.SITE_ID = B.SITE_ID
			--			  AND    A.PLANT_ID = B.PLANT_ID
					AND    A.OPERATION_ID = B.OPERATION_ID
					AND    A.COMPANY_ID = C.COMPANY_ID
					AND    A.DIVISION_ID = C.DIVISION_ID
					AND    A.SITE_ID = C.SITE_ID
					AND    B.ITEM_ID = C.ITEM_ID
					AND    ISNULL(C.SETUP_ATTRIBUTE, '') != ''
					AND    C.ACTIVE_FLAG = 'Y'
					) A
			WHERE  1=1
			AND    EXISTS ( 
							SELECT	1
							FROM	#tmp_MST_SCM_SETUP_BOM X WITH ( NOLOCK ) 
							WHERE	1=1
							AND		A.MASTER_ID = X.MASTER_ID 
							AND		A.PLAN_ID = X.PLAN_ID
							AND		A.COMPANY_ID = X.COMPANY_ID
							AND		A.DIVISION_ID = X.DIVISION_ID
							AND		A.SITE_ID = X.SITE_ID
							AND		A.PLANT_ID = X.PLANT_ID
							AND		A.ITEM_ID = X.PARENT_ITEM_ID
							AND		A.OPERATION_ID = X.OPERATION_ID
							)
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.06.3 RUN';
			SET @v_description = 'Process Complete...' + '[INSERT] - Attribute COMBINE' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			INSERT INTO #tmp_MST_SCM_SETUP_ITEM_COMBINE
			(
					MASTER_ID , PLAN_ID , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID  , SETUP_CATEGORY_ID, SETUP_KEY_ID, LEVEL, 
					ITEM_ID, OPERATION_ID, CALCULATION,	ITEM_SETUP_GROUP_ID      
					)
			SELECT	DISTINCT 
					A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , 	A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
					A.ITEM_ID, A.OPERATION_ID, A.CALCULATION, A.ITEM_SETUP_GROUP_ID
			FROM	(
					SELECT	DISTINCT
							B.MASTER_ID , B.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, B.PLANT_ID , 
							A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
							B.ITEM_ID, B.OPERATION_ID, A.CALCULATION,
							B.ITEM_ID AS ITEM_SETUP_GROUP_ID         
					FROM	(
							SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
									A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
									A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
							FROM	SCM_MST_ITEM_SETUP_GROUP_SN  A,
									SCM_SYS_LOOKUP_VALUE_SN    B
							WHERE	B.LOOKUP_TYPE_CODE = 'SETUP_CATEGORY'
							AND		UPPER(A.SETUP_CATEGORY_ID) = UPPER('ITEM')
							AND		A.SETUP_CATEGORY_ID = B.SEGMENT1
							AND		A.OPERATION_ID != A.REFERANCE_OPERATION_ID
							GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
									A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
									A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
							) A,
							(
							SELECT	*
							FROM	#tmp_MST_ITEM_OPERATION WITH ( NOLOCK ) 
							WHERE	MASTER_ID = @p_master_id
							AND		PLAN_ID = @p_engine_plan_id 
							)  B             
					WHERE	A.COMPANY_ID = B.COMPANY_ID
					AND		A.DIVISION_ID = B.DIVISION_ID
					AND		A.SITE_ID = B.SITE_ID
					AND		A.OPERATION_ID = B.OPERATION_ID
					) A
			WHERE	1=1
			AND		EXISTS ( 
							SELECT	1
							FROM	#tmp_MST_SCM_SETUP_BOM X
							WHERE	1=1
							AND		A.MASTER_ID = X.MASTER_ID 
							AND		A.PLAN_ID = X.PLAN_ID
							AND		A.COMPANY_ID = X.COMPANY_ID
							AND		A.DIVISION_ID = X.DIVISION_ID
							AND		A.SITE_ID = X.SITE_ID
							AND		A.PLANT_ID = X.PLANT_ID
							AND		A.ITEM_ID = X.PARENT_ITEM_ID
							AND		A.OPERATION_ID = X.OPERATION_ID
							)
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.06.4 RUN';
			SET @v_description = 'Process Complete...' + '[INSERT] - Item COMBINE' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



			DELETE	#tmp_MST_SCM_SETUP_ITEM_COMBINE
			WHERE	MASTER_ID = @p_master_id
			AND		PLAN_ID = @p_engine_plan_id
			AND		OPERATION_ID NOT IN
										(
										SELECT  SEGMENT2
										FROM	SCM_ADM_LOOKUP_MASTER_DETAIL  WITH ( NOLOCK ) 
										WHERE	LOOKUP_TYPE ='SCP_SETUP_OPERATION'
										AND		SEGMENT1	= @p_division_id
										AND		VALID_YN    = 'Y'
										)
			;

					-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.06.5 END';
			SET @v_description = 'Process Complete...' + '[DELETE] - != SETUP OPERATION' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		   /*************************************************************************
			SETUP ITEM 구성
			--> 1. #tmp_MST_SCM_SETUP_ITEM 
				- SETUP_LEVEL1 ~10
			**************************************************************************/

			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.07.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_ITEM' ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			DELETE	#tmp_MST_SCM_SETUP_ITEM
			WHERE	MASTER_ID = @p_master_id
			AND		PLAN_ID = @p_engine_plan_id;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.07.1 END';
			SET @v_description = 'Process Complete...' + '[DELETE]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.08.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_ITEM';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			INSERT INTO #tmp_MST_SCM_SETUP_ITEM
			(
				MASTER_ID , PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, LINE_SETUP_GROUP_ID, SETUP_GROUP_ID,
				S_GRP_01, S_GRP_02, S_GRP_03, S_GRP_04, S_GRP_05, S_GRP_06, S_GRP_07, S_GRP_08, S_GRP_09, S_GRP_10,
				S_CAT_01, S_CAT_02, S_CAT_03, S_CAT_04, S_CAT_05, S_CAT_06, S_CAT_07, S_CAT_08, S_CAT_09, S_CAT_10,
				S_KEY_01, S_KEY_02, S_KEY_03, S_KEY_04, S_KEY_05, S_KEY_06, S_KEY_07, S_KEY_08, S_KEY_09, S_KEY_10,
				S_CAL_01, S_CAL_02, S_CAL_03, S_CAL_04, S_CAL_05, S_CAL_06, S_CAL_07, S_CAL_08, S_CAL_09, S_CAL_10             
			)
			SELECT	DISTINCT
					A.MASTER_ID ,A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.ITEM_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
					(  CASE WHEN MAX_LEVEL >=  1 THEN S_GRP_01 ELSE '' END + CASE WHEN MAX_LEVEL >  1 THEN '##' ELSE '' END
					+ CASE WHEN MAX_LEVEL >=  2 THEN S_GRP_02 ELSE '' END + CASE WHEN MAX_LEVEL >  2 THEN '##' ELSE '' END
					+ CASE WHEN MAX_LEVEL >=  3 THEN S_GRP_03 ELSE '' END + CASE WHEN MAX_LEVEL >  3 THEN '##' ELSE '' END
					+ CASE WHEN MAX_LEVEL >=  4 THEN S_GRP_04 ELSE '' END + CASE WHEN MAX_LEVEL >  4 THEN '##' ELSE '' END
					+ CASE WHEN MAX_LEVEL >=  5 THEN S_GRP_05 ELSE '' END + CASE WHEN MAX_LEVEL >  5 THEN '##' ELSE '' END
					+ CASE WHEN MAX_LEVEL >=  6 THEN S_GRP_06 ELSE '' END + CASE WHEN MAX_LEVEL >  6 THEN '##' ELSE '' END
					+ CASE WHEN MAX_LEVEL >=  7 THEN S_GRP_07 ELSE '' END + CASE WHEN MAX_LEVEL >  7 THEN '##' ELSE '' END
					+ CASE WHEN MAX_LEVEL >=  8 THEN S_GRP_08 ELSE '' END + CASE WHEN MAX_LEVEL >  8 THEN '##' ELSE '' END
					+ CASE WHEN MAX_LEVEL >=  9 THEN S_GRP_09 ELSE '' END + CASE WHEN MAX_LEVEL >  9 THEN '##' ELSE '' END
					+ CASE WHEN MAX_LEVEL >= 10 THEN S_GRP_10 ELSE '' END + CASE WHEN MAX_LEVEL > 10 THEN '##' ELSE '' END
					) AS SETUP_GROUP_ID,
					S_GRP_01, S_GRP_02, S_GRP_03, S_GRP_04, S_GRP_05, S_GRP_06, S_GRP_07, S_GRP_08, S_GRP_09, S_GRP_10,
					S_CAT_01, S_CAT_02, S_CAT_03, S_CAT_04, S_CAT_05, S_CAT_06, S_CAT_07, S_CAT_08, S_CAT_09, S_CAT_10,
					S_KEY_01, S_KEY_02, S_KEY_03, S_KEY_04, S_KEY_05, S_KEY_06, S_KEY_07, S_KEY_08, S_KEY_09, S_KEY_10,
					S_CAL_01, S_CAL_02, S_CAL_03, S_CAL_04, S_CAL_05, S_CAL_06, S_CAL_07, S_CAL_08, S_CAL_09, S_CAL_10             
			FROM	(
					select	A.MASTER_ID ,A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.ITEM_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.MAX_LEVEL, 
							MAX(S_GRP_01) AS S_GRP_01,
							MAX(S_GRP_02) AS S_GRP_02,
							MAX(S_GRP_03) AS S_GRP_03,
							MAX(S_GRP_04) AS S_GRP_04,
							MAX(S_GRP_05) AS S_GRP_05,
							MAX(S_GRP_06) AS S_GRP_06,
							MAX(S_GRP_07) AS S_GRP_07,
							MAX(S_GRP_08) AS S_GRP_08,
							MAX(S_GRP_09) AS S_GRP_09,
							MAX(S_GRP_10) AS S_GRP_10,
							--
							MAX(S_CAT_01) AS S_CAT_01,
							MAX(S_CAT_02) AS S_CAT_02,
							MAX(S_CAT_03) AS S_CAT_03,
							MAX(S_CAT_04) AS S_CAT_04,
							MAX(S_CAT_05) AS S_CAT_05,
							MAX(S_CAT_06) AS S_CAT_06,
							MAX(S_CAT_07) AS S_CAT_07,
							MAX(S_CAT_08) AS S_CAT_08,
							MAX(S_CAT_09) AS S_CAT_09,
							MAX(S_CAT_10) AS S_CAT_10,
							--
							MAX(S_KEY_01) AS S_KEY_01,
							MAX(S_KEY_02) AS S_KEY_02,
							MAX(S_KEY_03) AS S_KEY_03,
							MAX(S_KEY_04) AS S_KEY_04,
							MAX(S_KEY_05) AS S_KEY_05,
							MAX(S_KEY_06) AS S_KEY_06,
							MAX(S_KEY_07) AS S_KEY_07,
							MAX(S_KEY_08) AS S_KEY_08,
							MAX(S_KEY_09) AS S_KEY_09,
							MAX(S_KEY_10) AS S_KEY_10,
							--
							MAX(S_CAL_01) AS S_CAL_01,
							MAX(S_CAL_02) AS S_CAL_02,
							MAX(S_CAL_03) AS S_CAL_03,
							MAX(S_CAL_04) AS S_CAL_04,
							MAX(S_CAL_05) AS S_CAL_05,
							MAX(S_CAL_06) AS S_CAL_06,
							MAX(S_CAL_07) AS S_CAL_07,
							MAX(S_CAL_08) AS S_CAL_08,
							MAX(S_CAL_09) AS S_CAL_09,
							MAX(S_CAL_10) AS S_CAL_10                     
					from	(
							SELECT	A.*, INT,
									CASE WHEN INT =  1 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_01,
									CASE WHEN INT =  2 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_02,
									CASE WHEN INT =  3 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_03,
									CASE WHEN INT =  4 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_04,
									CASE WHEN INT =  5 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_05,
									CASE WHEN INT =  6 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_06,
									CASE WHEN INT =  7 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_07,
									CASE WHEN INT =  8 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_08,
									CASE WHEN INT =  9 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_09,
									CASE WHEN INT = 10 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_10,
									--
									CASE WHEN INT =  1 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_01,
									CASE WHEN INT =  2 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_02,
									CASE WHEN INT =  3 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_03,
									CASE WHEN INT =  4 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_04,
									CASE WHEN INT =  5 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_05,
									CASE WHEN INT =  6 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_06,
									CASE WHEN INT =  7 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_07,
									CASE WHEN INT =  8 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_08,
									CASE WHEN INT =  9 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_09,
									CASE WHEN INT = 10 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_10,
									--
									CASE WHEN INT =  1 THEN SETUP_KEY_ID ELSE '' END S_KEY_01,
									CASE WHEN INT =  2 THEN SETUP_KEY_ID ELSE '' END S_KEY_02,
									CASE WHEN INT =  3 THEN SETUP_KEY_ID ELSE '' END S_KEY_03,
									CASE WHEN INT =  4 THEN SETUP_KEY_ID ELSE '' END S_KEY_04,
									CASE WHEN INT =  5 THEN SETUP_KEY_ID ELSE '' END S_KEY_05,
									CASE WHEN INT =  6 THEN SETUP_KEY_ID ELSE '' END S_KEY_06,
									CASE WHEN INT =  7 THEN SETUP_KEY_ID ELSE '' END S_KEY_07,
									CASE WHEN INT =  8 THEN SETUP_KEY_ID ELSE '' END S_KEY_08,
									CASE WHEN INT =  9 THEN SETUP_KEY_ID ELSE '' END S_KEY_09,
									CASE WHEN INT = 10 THEN SETUP_KEY_ID ELSE '' END S_KEY_10,
									--
									CASE WHEN INT =  1 THEN CALCULATION ELSE '' END S_CAL_01,
									CASE WHEN INT =  2 THEN CALCULATION ELSE '' END S_CAL_02,
									CASE WHEN INT =  3 THEN CALCULATION ELSE '' END S_CAL_03,
									CASE WHEN INT =  4 THEN CALCULATION ELSE '' END S_CAL_04,
									CASE WHEN INT =  5 THEN CALCULATION ELSE '' END S_CAL_05,
									CASE WHEN INT =  6 THEN CALCULATION ELSE '' END S_CAL_06,
									CASE WHEN INT =  7 THEN CALCULATION ELSE '' END S_CAL_07,
									CASE WHEN INT =  8 THEN CALCULATION ELSE '' END S_CAL_08,
									CASE WHEN INT =  9 THEN CALCULATION ELSE '' END S_CAL_09,
									CASE WHEN INT = 10 THEN CALCULATION ELSE '' END S_CAL_10                          
							FROM	(
									SELECT	A.*, B.LINE_SETUP_GROUP_ID,
											MAX(LEVEL) OVER (PARTITION BY A.MASTER_ID ,A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.ITEM_ID) MAX_LEVEL
									FROM	(
											SELECT  *
											FROM	#tmp_MST_SCM_SETUP_ITEM_COMBINE WITH ( NOLOCK ) 
											WHERE	MASTER_ID = @p_master_id
											AND		PLAN_ID = @p_engine_plan_id 
											) A,
											(
											SELECT	DISTINCT
													A.*, B.SETUP_CATEGORY_ID, SETUP_KEY_ID
											FROM	(
													SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , --A.LINE_ID LINE_SETUP_GROUP_ID , 
															A.OPERATION_ID  , B.LINE_SETUP_GROUP_ID
													FROM	SCM_LINE_M_SN           A WITH(NOLOCK) 
													JOIN	SCM_SETUP_MATRIX_M_SN   B WITH(NOLOCK)
													ON		A.DIVISION_ID  = B.DIVISION_ID
													AND		A.PLANT_ID     = B.PLANT_ID
													AND		A.OPERATION_ID = B.OPERATION_ID
													AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
													WHERE	B.SETUP_TIME > 0 	 
													GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , -- A.LINE_ID , 
															A.OPERATION_ID  , B.LINE_SETUP_GROUP_ID 
													) A,
													(
													SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , B.SETUP_CATEGORY_ID, B.SETUP_KEY_ID, A.OPERATION_ID 
													FROM	SCM_LINE_M_SN           A WITH(NOLOCK) 
													JOIN	SCM_SETUP_MATRIX_M_SN   B WITH(NOLOCK)
													ON		A.DIVISION_ID  = B.DIVISION_ID
													AND		A.PLANT_ID     = B.PLANT_ID
													AND		A.OPERATION_ID = B.OPERATION_ID
													AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
													WHERE	B.SETUP_TIME > 0 	 
													GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , B.SETUP_CATEGORY_ID, B.SETUP_KEY_ID, A.OPERATION_ID 
													) B
											WHERE	A.COMPANY_ID = B.COMPANY_ID
											AND		A.DIVISION_ID = B.DIVISION_ID
											AND		A.SITE_ID = B.SITE_ID
											AND		A.PLANT_ID = B.PLANT_ID 
											AND		A.OPERATION_ID = B.OPERATION_ID
											) B 
									WHERE	A.COMPANY_ID = B.COMPANY_ID
									AND		A.DIVISION_ID = B.DIVISION_ID
									AND		A.SITE_ID = B.SITE_ID
									AND		A.PLANT_ID = B.PLANT_ID 
									AND		A.SETUP_CATEGORY_ID = B.SETUP_CATEGORY_ID
									AND		A.SETUP_KEY_ID = B.SETUP_KEY_ID
									AND		A.OPERATION_ID = B.OPERATION_ID
									) A,
									COPYT_SN B
							WHERE	A.LEVEL = B.INT       
							) a
					GROUP  BY A.MASTER_ID ,A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.ITEM_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.MAX_LEVEL
					) A
			WHERE	EXISTS	( -- TACT 이 존재하는 ITEM, LINE 만..
							SELECT	1
							FROM    #tmp_MST_ITEM_LINE X
							WHERE   X.MASTER_ID = A.MASTER_ID
							AND     X.PLAN_ID = A.PLAN_ID
							AND		X.COMPANY_ID = A.COMPANY_ID
							AND     X.DIVISION_ID = A.DIVISION_ID
							AND		X.SITE_ID = A.SITE_ID
							AND		X.PLANT_ID = A.PLANT_ID
							AND		X.OPERATION_ID = A.OPERATION_ID
							AND		X.ITEM_ID = A.ITEM_ID
							AND     X.LINE_SETUP_GROUP_ID = A.LINE_SETUP_GROUP_ID      
							)
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '3.08.1 END';
			SET @v_description = 'Process Complete...' + '[INSERT]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		   /*************************************************************************
			SETUP MATRIX 구성
			--> 1. #tmp_MST_SCM_SETUP_MATRIX_01_SN 
				- SETUP MATRIX 기준
				2. #tmp_MST_SCM_SETUP_MATRIX_02_SN 
				- 1차 계산
				- FROM_SETUP_GROUP_ID ='ALL' AND TO_SETUP_GROUP_ID != 'ALL'
				  FROM_SETUP_GROUP_ID !='ALL' AND TO_SETUP_GROUP_ID = 'ALL'

				2. #tmp_MST_SCM_SETUP_MATRIX_03_SN 
				- 2차 계산
				- FROM_SETUP_GROUP_ID ='ALL' AND TO_SETUP_GROUP_ID = 'ALL'
				  FROM_SETUP_GROUP_ID !='ALL' AND TO_SETUP_GROUP_ID != 'ALL'

				3. TH_MST_SCM_SETUP_MATRIX
				- SETUP FINAL

			**************************************************************************/

			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.01.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_MATRIX_01_SN' ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			DELETE	#tmp_MST_SCM_SETUP_MATRIX_01_SN
			WHERE	MASTER_ID = @p_master_id
			AND		PLAN_ID = @p_engine_plan_id;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.01.1 END';
			SET @v_description = 'Process Complete...' + '[DELETE]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.02.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_MATRIX_01_SN';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			INSERT INTO #tmp_MST_SCM_SETUP_MATRIX_01_SN
			(
					MASTER_ID , PLAN_ID , COMPANY_ID, DIVISION_ID, SITE_ID, A.PLANT_ID , OPERATION_ID, LINE_SETUP_GROUP_ID,
					FROM_SETUP_GROUP_ID, TO_SETUP_GROUP_ID,
					FROM_SG_01, TO_SG_01, 
					FROM_SG_02, TO_SG_02,
					FROM_SG_03, TO_SG_03,
					FROM_SG_04, TO_SG_04,
					FROM_SG_05, TO_SG_05,
					FROM_SG_06, TO_SG_06,
					FROM_SG_07, TO_SG_07,
					FROM_SG_08, TO_SG_08,
					FROM_SG_09, TO_SG_09,
					FROM_SG_10, TO_SG_10,
					CATE_01, CATE_02, CATE_03, CATE_04, CATE_05, CATE_06, CATE_07, CATE_08, CATE_09, CATE_10,
					KEY_01,  KEY_02,  KEY_03,  KEY_04,  KEY_05,  KEY_06,  KEY_07,  KEY_08,  KEY_09,  KEY_10,
					TCAL_01, TCAL_02, TCAL_03, TCAL_04, TCAL_05, TCAL_06, TCAL_07, TCAL_08, TCAL_09, TCAL_10
			)
			SELECT	DISTINCT
					A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
					A.SETUP_GROUP_ID AS FROM_SETUP_GROUP_ID,
					B.SETUP_GROUP_ID AS TO_SETUP_GROUP_ID,
					A.S_GRP_01 AS FROM_SG_01, B.S_GRP_01 AS TO_SG_01, 
					A.S_GRP_02 AS FROM_SG_02, B.S_GRP_02 AS TO_SG_02,
					A.S_GRP_03 AS FROM_SG_03, B.S_GRP_03 AS TO_SG_03,
					A.S_GRP_04 AS FROM_SG_04, B.S_GRP_04 AS TO_SG_04,
					A.S_GRP_05 AS FROM_SG_05, B.S_GRP_05 AS TO_SG_05,
					A.S_GRP_06 AS FROM_SG_06, B.S_GRP_06 AS TO_SG_06,
					A.S_GRP_07 AS FROM_SG_07, B.S_GRP_07 AS TO_SG_07,
					A.S_GRP_08 AS FROM_SG_08, B.S_GRP_08 AS TO_SG_08,
					A.S_GRP_09 AS FROM_SG_09, B.S_GRP_09 AS TO_SG_09,
					A.S_GRP_10 AS FROM_SG_10, B.S_GRP_10 AS TO_SG_10,
					CASE WHEN B.S_CAT_01 = '' THEN A.S_CAT_01 ELSE B.S_CAT_01 END SETUP_CATEGORY_01,
					CASE WHEN B.S_CAT_02 = '' THEN A.S_CAT_02 ELSE B.S_CAT_02 END SETUP_CATEGORY_02,
					CASE WHEN B.S_CAT_03 = '' THEN A.S_CAT_03 ELSE B.S_CAT_03 END SETUP_CATEGORY_03,
					CASE WHEN B.S_CAT_04 = '' THEN A.S_CAT_04 ELSE B.S_CAT_04 END SETUP_CATEGORY_04,
					CASE WHEN B.S_CAT_05 = '' THEN A.S_CAT_05 ELSE B.S_CAT_05 END SETUP_CATEGORY_05,
					CASE WHEN B.S_CAT_06 = '' THEN A.S_CAT_06 ELSE B.S_CAT_06 END SETUP_CATEGORY_06,
					CASE WHEN B.S_CAT_07 = '' THEN A.S_CAT_07 ELSE B.S_CAT_07 END SETUP_CATEGORY_07,
					CASE WHEN B.S_CAT_08 = '' THEN A.S_CAT_08 ELSE B.S_CAT_08 END SETUP_CATEGORY_08,
					CASE WHEN B.S_CAT_09 = '' THEN A.S_CAT_09 ELSE B.S_CAT_09 END SETUP_CATEGORY_09,
					CASE WHEN B.S_CAT_10 = '' THEN A.S_CAT_10 ELSE B.S_CAT_10 END SETUP_CATEGORY_10,
					CASE WHEN B.S_KEY_01 = '' THEN A.S_KEY_01 ELSE B.S_KEY_01 END SETUP_KEY_01,
					CASE WHEN B.S_KEY_02 = '' THEN A.S_KEY_02 ELSE B.S_KEY_02 END SETUP_KEY_02,
					CASE WHEN B.S_KEY_03 = '' THEN A.S_KEY_03 ELSE B.S_KEY_03 END SETUP_KEY_03,
					CASE WHEN B.S_KEY_04 = '' THEN A.S_KEY_04 ELSE B.S_KEY_04 END SETUP_KEY_04,
					CASE WHEN B.S_KEY_05 = '' THEN A.S_KEY_05 ELSE B.S_KEY_05 END SETUP_KEY_05,
					CASE WHEN B.S_KEY_06 = '' THEN A.S_KEY_06 ELSE B.S_KEY_06 END SETUP_KEY_06,
					CASE WHEN B.S_KEY_07 = '' THEN A.S_KEY_07 ELSE B.S_KEY_07 END SETUP_KEY_07,
					CASE WHEN B.S_KEY_08 = '' THEN A.S_KEY_08 ELSE B.S_KEY_08 END SETUP_KEY_08,
					CASE WHEN B.S_KEY_09 = '' THEN A.S_KEY_09 ELSE B.S_KEY_09 END SETUP_KEY_09,
					CASE WHEN B.S_KEY_10 = '' THEN A.S_KEY_10 ELSE B.S_KEY_10 END SETUP_KEY_10,
					CASE WHEN B.S_CAL_01 = '' THEN A.S_CAL_01 ELSE B.S_CAL_01 END SETUP_CALCULATION_01,
					CASE WHEN B.S_CAL_02 = '' THEN A.S_CAL_02 ELSE B.S_CAL_02 END SETUP_CALCULATION_02,
					CASE WHEN B.S_CAL_03 = '' THEN A.S_CAL_03 ELSE B.S_CAL_03 END SETUP_CALCULATION_03,
					CASE WHEN B.S_CAL_04 = '' THEN A.S_CAL_04 ELSE B.S_CAL_04 END SETUP_CALCULATION_04,
					CASE WHEN B.S_CAL_05 = '' THEN A.S_CAL_05 ELSE B.S_CAL_05 END SETUP_CALCULATION_05,
					CASE WHEN B.S_CAL_06 = '' THEN A.S_CAL_06 ELSE B.S_CAL_06 END SETUP_CALCULATION_06,
					CASE WHEN B.S_CAL_07 = '' THEN A.S_CAL_07 ELSE B.S_CAL_07 END SETUP_CALCULATION_07,
					CASE WHEN B.S_CAL_08 = '' THEN A.S_CAL_08 ELSE B.S_CAL_08 END SETUP_CALCULATION_08,
					CASE WHEN B.S_CAL_09 = '' THEN A.S_CAL_09 ELSE B.S_CAL_09 END SETUP_CALCULATION_09,
					CASE WHEN B.S_CAL_10 = '' THEN A.S_CAL_10 ELSE B.S_CAL_10 END SETUP_CALCULATION_10                         
			FROM	#tmp_MST_SCM_SETUP_ITEM A WITH ( NOLOCK ) ,
					#tmp_MST_SCM_SETUP_ITEM B WITH ( NOLOCK ) 
			WHERE	A.MASTER_ID = @p_master_id
			AND		A.PLAN_ID = @p_engine_plan_id
			AND		A.MASTER_ID = B.MASTER_ID
			AND		A.PLAN_ID = B.PLAN_ID
			AND		A.COMPANY_ID = B.COMPANY_ID
			AND		A.DIVISION_ID = B.DIVISION_ID
			AND		A.SITE_ID = B.SITE_ID
			AND		A.OPERATION_ID = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.SETUP_GROUP_ID != B.SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.02.1 END';
			SET @v_description = 'Process Complete...' + '[INSERT]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.03.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_MATRIX_02_SN' ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			DELETE	#tmp_MST_SCM_SETUP_MATRIX_02_SN
			WHERE	MASTER_ID = @p_master_id
			AND		PLAN_ID = @p_engine_plan_id;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.03.1 END';
			SET @v_description = 'Process Complete...' + '[DELETE]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.04.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_MATRIX_02_SN';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			INSERT INTO #tmp_MST_SCM_SETUP_MATRIX_02_SN
			(
				MASTER_ID , PLAN_ID , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID , OPERATION_ID, LINE_SETUP_GROUP_ID,
				FROM_SETUP_GROUP_ID, TO_SETUP_GROUP_ID     
			)
			SELECT	MASTER_ID , PLAN_ID , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID , OPERATION_ID, LINE_SETUP_GROUP_ID,
					FROM_SETUP_GROUP_ID, TO_SETUP_GROUP_ID
			FROM    #tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
			WHERE	MASTER_ID = @p_master_id 
			AND		PLAN_ID = @p_engine_plan_id
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.04.1 END';
			SET @v_description = 'Process Complete...' + '[INSERT]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.05.00 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_MATRIX_02_SN';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			UPDATE A
			SET    A.S01_SETUP_TIME  = B.S01_SETUP_TIME
				, A.S01_CALCULATION = B.S01_CALCULATION
				, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
										END)
				, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
										END)
			FROM   #tmp_MST_SCM_SETUP_MATRIX_02_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S01_SETUP_TIME * (CASE S01_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S01_SETUP_TIME, 
							TCAL_01 AS S01_CALCULATION ,
							A.FULL_SETUP_FLAG , 
							A.DIE_CHANGE_FLAG 
					FROM	(
							SELECT	*
							FROM	(
									SELECT  Z.*
									FROM    (
											SELECT A.*, CONCAT(upper(CATE_01), setup_seq) GB , 
													DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																				, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
																	ORDER     BY SETUP_SEQ) AS SEQ
											FROM   (
													SELECT	A.*,
															ISNULL(S01.SETUP_TIME,0) AS S01_SETUP_TIME, ISNULL(S01.SETUP_TIME_UOM, 'MINUTE') AS S01_SETUP_TIME_UOM,
															CASE WHEN S01.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S01.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1 
																WHEN S01.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S01.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
																WHEN S01.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S01.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																					ELSE 4
															END  SETUP_SEQ ,
															CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
																 WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																												ELSE 'N'
															END  FULL_SETUP_FLAG , 
															CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																												ELSE 'N'
															END  DIE_CHANGE_FLAG
													FROM	(
															SELECT	*
															FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
															WHERE   MASTER_ID = @p_master_id 
															AND		PLAN_ID = @p_engine_plan_id
															) A
															LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S01 WITH ( NOLOCK )
																ON  A.FROM_SG_01    = CASE WHEN S01.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_01 ELSE S01.FROM_ITEM_SETUP_GROUP_ID END 
																AND A.TO_SG_01      = CASE WHEN S01.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_01   ELSE S01.TO_ITEM_SETUP_GROUP_ID   END 
																AND A.COMPANY_ID    = S01.COMPANY_ID
																AND A.DIVISION_ID   = S01.DIVISION_ID
																AND A.SITE_ID       = S01.SITE_ID
																AND	A.PLANT_ID      = S01.PLANT_ID
																AND A.OPERATION_ID  = S01.OPERATION_ID
																AND A.CATE_01       = S01.SETUP_CATEGORY_ID
																AND A.KEY_01        = S01.SETUP_KEY_ID
																AND A.LINE_SETUP_GROUP_ID = S01.LINE_SETUP_GROUP_ID
													WHERE  A.CATE_01 != ''
													--AND    A.FROM_SG_01 != A.TO_SG_01   -- 동일 SETUP 은 반영 금지
													) A
											WHERE  1=1
											AND    ( SETUP_SEQ = 1 )   -- FROM, TO 가 ALL 이 아니면 같은 SETUP 도 발생함.
											OR     ( SETUP_SEQ > 1 AND A.FROM_SG_01 != A.TO_SG_01 )
									) Z
									WHERE 1=1 
									AND   Z.GB NOT IN ( 'ITEM4', 'ITEM1' ) 	 ---+ ITEM4 : ITEM의 all to all 조건이 아닌 것, (20200214) ITEM1: ITEM의 ITEM to ITEM 조건
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			  = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.05.01 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 01' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		

			UPDATE A
			SET    A.S02_SETUP_TIME  = B.S02_SETUP_TIME
				, A.S02_CALCULATION = B.S02_CALCULATION
				, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
										END)
				, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
										END)
			FROM   #tmp_MST_SCM_SETUP_MATRIX_02_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S02_SETUP_TIME * (CASE S02_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S02_SETUP_TIME, 
							TCAL_02 AS S02_CALCULATION ,
							A.FULL_SETUP_FLAG , 
							A.DIE_CHANGE_FLAG 
					FROM	(
							SELECT	*
							FROM	(
									SELECT  Z.*
									FROM    (
											SELECT A.*, CONCAT(upper(CATE_02), setup_seq) GB , 
													DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																				, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
																	ORDER     BY SETUP_SEQ) AS SEQ
											FROM   (
													SELECT	A.*,
															ISNULL(S02.SETUP_TIME,0) AS S02_SETUP_TIME, ISNULL(S02.SETUP_TIME_UOM, 'MINUTE') AS S02_SETUP_TIME_UOM,
															CASE WHEN S02.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S02.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1 
																WHEN S02.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S02.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
																WHEN S02.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S02.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																					ELSE 4
															END  SETUP_SEQ ,
															CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
																 WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																												ELSE 'N'
															END  FULL_SETUP_FLAG , 
															CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																												ELSE 'N'
															END  DIE_CHANGE_FLAG
													FROM	(
															SELECT	*
															FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
															WHERE   MASTER_ID = @p_master_id 
															AND		PLAN_ID = @p_engine_plan_id
															) A
															LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S02
																ON  A.FROM_SG_02    = CASE WHEN S02.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_02 ELSE S02.FROM_ITEM_SETUP_GROUP_ID END 
																AND A.TO_SG_02      = CASE WHEN S02.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_02   ELSE S02.TO_ITEM_SETUP_GROUP_ID   END 
																AND A.COMPANY_ID    = S02.COMPANY_ID
																AND A.DIVISION_ID   = S02.DIVISION_ID
																AND A.SITE_ID       = S02.SITE_ID
																AND	A.PLANT_ID      = S02.PLANT_ID
																AND A.OPERATION_ID  = S02.OPERATION_ID
																AND A.CATE_02       = S02.SETUP_CATEGORY_ID
																AND A.KEY_02        = S02.SETUP_KEY_ID
																AND A.LINE_SETUP_GROUP_ID = S02.LINE_SETUP_GROUP_ID
													WHERE  A.CATE_02 != ''
													--AND    A.FROM_SG_02 != A.TO_SG_02   -- 동일 SETUP 은 반영 금지
													) A
											WHERE  1=1
											AND    ( SETUP_SEQ = 1 )   -- FROM, TO 가 ALL 이 아니면 같은 SETUP 도 발생함.
											OR     ( SETUP_SEQ > 1 AND A.FROM_SG_02 != A.TO_SG_02 )
									) Z
									WHERE 1=1 
									AND   Z.GB NOT IN ( 'ITEM4', 'ITEM1' ) 	 ---+ ITEM4 : ITEM의 all to all 조건이 아닌 것, (20200214) ITEM1: ITEM의 ITEM to ITEM 조건
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			  = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.05.02 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 02' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			UPDATE A
			SET    A.S03_SETUP_TIME  = B.S03_SETUP_TIME
				, A.S03_CALCULATION = B.S03_CALCULATION
				, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
										END)
				, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
										END)
			FROM   #tmp_MST_SCM_SETUP_MATRIX_02_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S03_SETUP_TIME * (CASE S03_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S03_SETUP_TIME, 
							TCAL_03 AS S03_CALCULATION ,
							A.FULL_SETUP_FLAG , 
							A.DIE_CHANGE_FLAG 
					FROM	(
							SELECT	*
							FROM	(
									SELECT  Z.*
									FROM    (
											SELECT A.*, CONCAT(upper(CATE_03), setup_seq) GB , 
													DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																				, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
																	ORDER     BY SETUP_SEQ) AS SEQ
											FROM   (
													SELECT	A.*,
															ISNULL(S03.SETUP_TIME,0) AS S03_SETUP_TIME, ISNULL(S03.SETUP_TIME_UOM, 'MINUTE') AS S03_SETUP_TIME_UOM,
															CASE WHEN S03.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S03.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1 
																WHEN S03.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S03.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
																WHEN S03.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S03.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																					ELSE 4
															END  SETUP_SEQ ,
															CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
																 WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																												ELSE 'N'
															END  FULL_SETUP_FLAG , 
															CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																												ELSE 'N'
															END  DIE_CHANGE_FLAG
													FROM	(
															SELECT	*
															FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
															WHERE   MASTER_ID = @p_master_id 
															AND		PLAN_ID = @p_engine_plan_id
															) A
															LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S03
																ON  A.FROM_SG_03    = CASE WHEN S03.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_03 ELSE S03.FROM_ITEM_SETUP_GROUP_ID END 
																AND A.TO_SG_03      = CASE WHEN S03.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_03   ELSE S03.TO_ITEM_SETUP_GROUP_ID   END 
																AND A.COMPANY_ID    = S03.COMPANY_ID
																AND A.DIVISION_ID   = S03.DIVISION_ID
																AND A.SITE_ID       = S03.SITE_ID
																AND	A.PLANT_ID      = S03.PLANT_ID
																AND A.OPERATION_ID  = S03.OPERATION_ID
																AND A.CATE_03       = S03.SETUP_CATEGORY_ID
																AND A.KEY_03        = S03.SETUP_KEY_ID
																AND A.LINE_SETUP_GROUP_ID = S03.LINE_SETUP_GROUP_ID
													WHERE  A.CATE_03 != ''
													--AND    A.FROM_SG_03 != A.TO_SG_03   -- 동일 SETUP 은 반영 금지
													) A
											WHERE  1=1
											AND    ( SETUP_SEQ = 1 )   -- FROM, TO 가 ALL 이 아니면 같은 SETUP 도 발생함.
											OR     ( SETUP_SEQ > 1 AND A.FROM_SG_03 != A.TO_SG_03 )
									) Z
									WHERE 1=1 
									AND   Z.GB NOT IN ( 'ITEM4', 'ITEM1' ) 	 ---+ ITEM4 : ITEM의 all to all 조건이 아닌 것, (20300314) ITEM1: ITEM의 ITEM to ITEM 조건
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			  = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.05.03 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 03' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			UPDATE A
			SET    A.S04_SETUP_TIME  = B.S04_SETUP_TIME
				, A.S04_CALCULATION = B.S04_CALCULATION
				, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
										END)
				, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
										END)
			FROM   #tmp_MST_SCM_SETUP_MATRIX_02_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S04_SETUP_TIME * (CASE S04_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S04_SETUP_TIME, 
							TCAL_04 AS S04_CALCULATION ,
							A.FULL_SETUP_FLAG , 
							A.DIE_CHANGE_FLAG 
					FROM	(
							SELECT	*
							FROM	(
									SELECT  Z.*
									FROM    (
											SELECT A.*, CONCAT(upper(CATE_04), setup_seq) GB , 
													DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																				, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
																	ORDER     BY SETUP_SEQ) AS SEQ
											FROM   (
													SELECT	A.*,
															ISNULL(S04.SETUP_TIME,0) AS S04_SETUP_TIME, ISNULL(S04.SETUP_TIME_UOM, 'MINUTE') AS S04_SETUP_TIME_UOM,
															CASE WHEN S04.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S04.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1 
																WHEN S04.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S04.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
																WHEN S04.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S04.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																					ELSE 4
															END  SETUP_SEQ ,
															CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
																 WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																												ELSE 'N'
															END  FULL_SETUP_FLAG , 
															CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																												ELSE 'N'
															END  DIE_CHANGE_FLAG
													FROM    (
															SELECT	*
															FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
															WHERE   MASTER_ID = @p_master_id 
															AND		PLAN_ID = @p_engine_plan_id
															) A
															LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S04
																ON  A.FROM_SG_04    = CASE WHEN S04.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_04 ELSE S04.FROM_ITEM_SETUP_GROUP_ID END 
																AND A.TO_SG_04      = CASE WHEN S04.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_04   ELSE S04.TO_ITEM_SETUP_GROUP_ID   END 
																AND A.COMPANY_ID    = S04.COMPANY_ID
																AND A.DIVISION_ID   = S04.DIVISION_ID
																AND A.SITE_ID       = S04.SITE_ID
																AND	A.PLANT_ID      = S04.PLANT_ID
																AND A.OPERATION_ID  = S04.OPERATION_ID
																AND A.CATE_04       = S04.SETUP_CATEGORY_ID
																AND A.KEY_04        = S04.SETUP_KEY_ID
																AND A.LINE_SETUP_GROUP_ID = S04.LINE_SETUP_GROUP_ID
													WHERE  A.CATE_04 != ''
													--AND    A.FROM_SG_04 != A.TO_SG_04   -- 동일 SETUP 은 반영 금지
													) A
											WHERE  1=1
											AND    ( SETUP_SEQ = 1 )   -- FROM, TO 가 ALL 이 아니면 같은 SETUP 도 발생함.
											OR     ( SETUP_SEQ > 1 AND A.FROM_SG_04 != A.TO_SG_04 )
									) Z
									WHERE 1=1 
									AND   Z.GB NOT IN ( 'ITEM4', 'ITEM1' ) 	 ---+ ITEM4 : ITEM의 all to all 조건이 아닌 것, (20400414) ITEM1: ITEM의 ITEM to ITEM 조건
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			  = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.04.04 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 04' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			UPDATE A
			SET    A.S05_SETUP_TIME  = B.S05_SETUP_TIME
				, A.S05_CALCULATION = B.S05_CALCULATION
				, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
										END)
				, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
										END)
			FROM   #tmp_MST_SCM_SETUP_MATRIX_02_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S05_SETUP_TIME * (CASE S05_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S05_SETUP_TIME, 
							TCAL_05 AS S05_CALCULATION ,
							A.FULL_SETUP_FLAG , 
							A.DIE_CHANGE_FLAG 
					FROM	(
							SELECT	*
							FROM	(
									SELECT  Z.*
									FROM    (
											SELECT A.*, CONCAT(upper(CATE_05), setup_seq) GB , 
													DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																				, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
																	ORDER     BY SETUP_SEQ) AS SEQ
											FROM   (
													SELECT	A.*,
															ISNULL(S05.SETUP_TIME,0) AS S05_SETUP_TIME, ISNULL(S05.SETUP_TIME_UOM, 'MINUTE') AS S05_SETUP_TIME_UOM,
															CASE WHEN S05.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S05.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1 
																WHEN S05.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S05.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
																WHEN S05.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S05.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																					ELSE 4
															END  SETUP_SEQ ,
															CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
																 WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																												ELSE 'N'
															END  FULL_SETUP_FLAG , 
															CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																												ELSE 'N'
															END  DIE_CHANGE_FLAG
													FROM    (
															SELECT	*
															FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
															WHERE   MASTER_ID = @p_master_id 
															AND		PLAN_ID = @p_engine_plan_id
															) A
															LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S05
																ON  A.FROM_SG_05    = CASE WHEN S05.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_05 ELSE S05.FROM_ITEM_SETUP_GROUP_ID END 
																AND A.TO_SG_05      = CASE WHEN S05.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_05   ELSE S05.TO_ITEM_SETUP_GROUP_ID   END 
																AND A.COMPANY_ID    = S05.COMPANY_ID
																AND A.DIVISION_ID   = S05.DIVISION_ID
																AND A.SITE_ID       = S05.SITE_ID
																AND	A.PLANT_ID      = S05.PLANT_ID
																AND A.OPERATION_ID  = S05.OPERATION_ID
																AND A.CATE_05       = S05.SETUP_CATEGORY_ID
																AND A.KEY_05        = S05.SETUP_KEY_ID
																AND A.LINE_SETUP_GROUP_ID = S05.LINE_SETUP_GROUP_ID
													WHERE  A.CATE_05 != ''
													--AND    A.FROM_SG_05 != A.TO_SG_05   -- 동일 SETUP 은 반영 금지
													) A
											WHERE  1=1
											AND    ( SETUP_SEQ = 1 )   -- FROM, TO 가 ALL 이 아니면 같은 SETUP 도 발생함.
											OR     ( SETUP_SEQ > 1 AND A.FROM_SG_05 != A.TO_SG_05 )
									) Z
									WHERE 1=1 
									AND   Z.GB NOT IN ( 'ITEM4', 'ITEM1' ) 	 ---+ ITEM4 : ITEM의 all to all 조건이 아닌 것, (20500514) ITEM1: ITEM의 ITEM to ITEM 조건
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			  = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.05.05 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 05' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			UPDATE A
			SET    A.S06_SETUP_TIME  = B.S06_SETUP_TIME
				, A.S06_CALCULATION = B.S06_CALCULATION
				, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
										END)
				, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
										END)
			FROM   #tmp_MST_SCM_SETUP_MATRIX_02_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S06_SETUP_TIME * (CASE S06_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S06_SETUP_TIME, 
							TCAL_06 AS S06_CALCULATION ,
							A.FULL_SETUP_FLAG , 
							A.DIE_CHANGE_FLAG 
					FROM	(
							SELECT	*
							FROM	(
									SELECT  Z.*
									FROM    (
											SELECT A.*, CONCAT(upper(CATE_06), setup_seq) GB , 
													DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																				, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
																	ORDER     BY SETUP_SEQ) AS SEQ
											FROM   (
													SELECT	A.*,
															ISNULL(S06.SETUP_TIME,0) AS S06_SETUP_TIME, ISNULL(S06.SETUP_TIME_UOM, 'MINUTE') AS S06_SETUP_TIME_UOM,
															CASE WHEN S06.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S06.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1 
																WHEN S06.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S06.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
																WHEN S06.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S06.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																					ELSE 4
															END  SETUP_SEQ ,
															CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
																 WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																												ELSE 'N'
															END  FULL_SETUP_FLAG , 
															CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																												ELSE 'N'
															END  DIE_CHANGE_FLAG
													FROM    (
															SELECT	*
															FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
															WHERE   MASTER_ID = @p_master_id 
															AND		PLAN_ID = @p_engine_plan_id
															) A
															LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S06
																ON  A.FROM_SG_06    = CASE WHEN S06.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_06 ELSE S06.FROM_ITEM_SETUP_GROUP_ID END 
																AND A.TO_SG_06      = CASE WHEN S06.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_06   ELSE S06.TO_ITEM_SETUP_GROUP_ID   END 
																AND A.COMPANY_ID    = S06.COMPANY_ID
																AND A.DIVISION_ID   = S06.DIVISION_ID
																AND A.SITE_ID       = S06.SITE_ID
																AND	A.PLANT_ID      = S06.PLANT_ID
																AND A.OPERATION_ID  = S06.OPERATION_ID
																AND A.CATE_06       = S06.SETUP_CATEGORY_ID
																AND A.KEY_06        = S06.SETUP_KEY_ID
																AND A.LINE_SETUP_GROUP_ID = S06.LINE_SETUP_GROUP_ID
													WHERE  A.CATE_06 != ''
													--AND    A.FROM_SG_06 != A.TO_SG_06   -- 동일 SETUP 은 반영 금지
													) A
											WHERE  1=1
											AND    ( SETUP_SEQ = 1 )   -- FROM, TO 가 ALL 이 아니면 같은 SETUP 도 발생함.
											OR     ( SETUP_SEQ > 1 AND A.FROM_SG_06 != A.TO_SG_06 )
									) Z
									WHERE 1=1 
									AND   Z.GB NOT IN ( 'ITEM4', 'ITEM1' ) 	 ---+ ITEM4 : ITEM의 all to all 조건이 아닌 것, (20600614) ITEM1: ITEM의 ITEM to ITEM 조건
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			  = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.05.06 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 06' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			UPDATE A
			SET    A.S07_SETUP_TIME  = B.S07_SETUP_TIME
				, A.S07_CALCULATION = B.S07_CALCULATION
				, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
										END)
				, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
										END)
			FROM   #tmp_MST_SCM_SETUP_MATRIX_02_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S07_SETUP_TIME * (CASE S07_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S07_SETUP_TIME, 
							TCAL_07 AS S07_CALCULATION ,
							A.FULL_SETUP_FLAG , 
							A.DIE_CHANGE_FLAG 
					FROM	(
							SELECT	*
							FROM	(
									SELECT  Z.*
									FROM    (
											SELECT A.*, CONCAT(upper(CATE_07), setup_seq) GB , 
													DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																				, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
																	ORDER     BY SETUP_SEQ) AS SEQ
											FROM   (
													SELECT	A.*,
															ISNULL(S07.SETUP_TIME,0) AS S07_SETUP_TIME, ISNULL(S07.SETUP_TIME_UOM, 'MINUTE') AS S07_SETUP_TIME_UOM,
															CASE WHEN S07.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S07.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1 
																WHEN S07.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S07.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
																WHEN S07.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S07.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																					ELSE 4
															END  SETUP_SEQ ,
															CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
																 WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																												ELSE 'N'
															END  FULL_SETUP_FLAG , 
															CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																												ELSE 'N'
															END  DIE_CHANGE_FLAG
													FROM    (
															SELECT	*
															FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
															WHERE   MASTER_ID = @p_master_id 
															AND		PLAN_ID = @p_engine_plan_id
															) A
															LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S07
																ON  A.FROM_SG_07    = CASE WHEN S07.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_07 ELSE S07.FROM_ITEM_SETUP_GROUP_ID END 
																AND A.TO_SG_07      = CASE WHEN S07.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_07   ELSE S07.TO_ITEM_SETUP_GROUP_ID   END 
																AND A.COMPANY_ID    = S07.COMPANY_ID
																AND A.DIVISION_ID   = S07.DIVISION_ID
																AND A.SITE_ID       = S07.SITE_ID
																AND	A.PLANT_ID      = S07.PLANT_ID
																AND A.OPERATION_ID  = S07.OPERATION_ID
																AND A.CATE_07       = S07.SETUP_CATEGORY_ID
																AND A.KEY_07        = S07.SETUP_KEY_ID
																AND A.LINE_SETUP_GROUP_ID = S07.LINE_SETUP_GROUP_ID
													WHERE  A.CATE_07 != ''
													--AND    A.FROM_SG_07 != A.TO_SG_07   -- 동일 SETUP 은 반영 금지
													) A
											WHERE  1=1
											AND    ( SETUP_SEQ = 1 )   -- FROM, TO 가 ALL 이 아니면 같은 SETUP 도 발생함.
											OR     ( SETUP_SEQ > 1 AND A.FROM_SG_07 != A.TO_SG_07 )
									) Z
									WHERE 1=1 
									AND   Z.GB NOT IN ( 'ITEM4', 'ITEM1' ) 	 ---+ ITEM4 : ITEM의 all to all 조건이 아닌 것, (20700714) ITEM1: ITEM의 ITEM to ITEM 조건
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			  = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.05.07 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 07' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			UPDATE A
			SET    A.S08_SETUP_TIME  = B.S08_SETUP_TIME
				, A.S08_CALCULATION = B.S08_CALCULATION
				, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
										END)
				, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
										END)
			FROM   #tmp_MST_SCM_SETUP_MATRIX_02_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S08_SETUP_TIME * (CASE S08_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S08_SETUP_TIME, 
							TCAL_08 AS S08_CALCULATION ,
							A.FULL_SETUP_FLAG , 
							A.DIE_CHANGE_FLAG 
					FROM	(
							SELECT	*
							FROM	(
									SELECT  Z.*
									FROM    (
											SELECT A.*, CONCAT(upper(CATE_08), setup_seq) GB , 
													DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																				, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
																	ORDER     BY SETUP_SEQ) AS SEQ
											FROM   (
													SELECT	A.*,
															ISNULL(S08.SETUP_TIME,0) AS S08_SETUP_TIME, ISNULL(S08.SETUP_TIME_UOM, 'MINUTE') AS S08_SETUP_TIME_UOM,
															CASE WHEN S08.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S08.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1 
																WHEN S08.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S08.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
																WHEN S08.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S08.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																					ELSE 4
															END  SETUP_SEQ ,
															CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
																 WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																												ELSE 'N'
															END  FULL_SETUP_FLAG , 
															CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																												ELSE 'N'
															END  DIE_CHANGE_FLAG
													FROM    (
															SELECT	*
															FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
															WHERE   MASTER_ID = @p_master_id 
															AND		PLAN_ID = @p_engine_plan_id
															) A
															LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S08
																ON  A.FROM_SG_08    = CASE WHEN S08.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_08 ELSE S08.FROM_ITEM_SETUP_GROUP_ID END 
																AND A.TO_SG_08      = CASE WHEN S08.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_08   ELSE S08.TO_ITEM_SETUP_GROUP_ID   END 
																AND A.COMPANY_ID    = S08.COMPANY_ID
																AND A.DIVISION_ID   = S08.DIVISION_ID
																AND A.SITE_ID       = S08.SITE_ID
																AND	A.PLANT_ID      = S08.PLANT_ID
																AND A.OPERATION_ID  = S08.OPERATION_ID
																AND A.CATE_08       = S08.SETUP_CATEGORY_ID
																AND A.KEY_08        = S08.SETUP_KEY_ID
																AND A.LINE_SETUP_GROUP_ID = S08.LINE_SETUP_GROUP_ID
													WHERE  A.CATE_08 != ''
													--AND    A.FROM_SG_08 != A.TO_SG_08   -- 동일 SETUP 은 반영 금지
													) A
											WHERE  1=1
											AND    ( SETUP_SEQ = 1 )   -- FROM, TO 가 ALL 이 아니면 같은 SETUP 도 발생함.
											OR     ( SETUP_SEQ > 1 AND A.FROM_SG_08 != A.TO_SG_08 )
									) Z
									WHERE 1=1 
									AND   Z.GB NOT IN ( 'ITEM4', 'ITEM1' ) 	 ---+ ITEM4 : ITEM의 all to all 조건이 아닌 것, (20800814) ITEM1: ITEM의 ITEM to ITEM 조건
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			  = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.05.08 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 08' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			UPDATE A
			SET    A.S09_SETUP_TIME  = B.S09_SETUP_TIME
				, A.S09_CALCULATION = B.S09_CALCULATION
				, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
										END)
				, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
										END)
			FROM   #tmp_MST_SCM_SETUP_MATRIX_02_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S09_SETUP_TIME * (CASE S09_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S09_SETUP_TIME, 
							TCAL_09 AS S09_CALCULATION ,
							A.FULL_SETUP_FLAG , 
							A.DIE_CHANGE_FLAG 
					FROM	(
							SELECT	*
							FROM	(
									SELECT  Z.*
									FROM    (
											SELECT A.*, CONCAT(upper(CATE_09), setup_seq) GB , 
													DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																				, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
																	ORDER     BY SETUP_SEQ) AS SEQ
											FROM   (
													SELECT	A.*,
															ISNULL(S09.SETUP_TIME,0) AS S09_SETUP_TIME, ISNULL(S09.SETUP_TIME_UOM, 'MINUTE') AS S09_SETUP_TIME_UOM,
															CASE WHEN S09.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S09.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1 
																WHEN S09.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S09.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
																WHEN S09.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S09.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																					ELSE 4
															END  SETUP_SEQ ,
															CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
																 WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																												ELSE 'N'
															END  FULL_SETUP_FLAG , 
															CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																												ELSE 'N'
															END  DIE_CHANGE_FLAG
													FROM    (
															SELECT	*
															FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
															WHERE   MASTER_ID = @p_master_id 
															AND		PLAN_ID = @p_engine_plan_id
															) A
															LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S09
																ON  A.FROM_SG_09    = CASE WHEN S09.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_09 ELSE S09.FROM_ITEM_SETUP_GROUP_ID END 
																AND A.TO_SG_09      = CASE WHEN S09.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_09   ELSE S09.TO_ITEM_SETUP_GROUP_ID   END 
																AND A.COMPANY_ID    = S09.COMPANY_ID
																AND A.DIVISION_ID   = S09.DIVISION_ID
																AND A.SITE_ID       = S09.SITE_ID
																AND	A.PLANT_ID      = S09.PLANT_ID
																AND A.OPERATION_ID  = S09.OPERATION_ID
																AND A.CATE_09       = S09.SETUP_CATEGORY_ID
																AND A.KEY_09        = S09.SETUP_KEY_ID
																AND A.LINE_SETUP_GROUP_ID = S09.LINE_SETUP_GROUP_ID
													WHERE  A.CATE_09 != ''
													--AND    A.FROM_SG_09 != A.TO_SG_09   -- 동일 SETUP 은 반영 금지
													) A
											WHERE  1=1
											AND    ( SETUP_SEQ = 1 )   -- FROM, TO 가 ALL 이 아니면 같은 SETUP 도 발생함.
											OR     ( SETUP_SEQ > 1 AND A.FROM_SG_09 != A.TO_SG_09 )
									) Z
									WHERE 1=1 
									AND   Z.GB NOT IN ( 'ITEM4', 'ITEM1' ) 	 ---+ ITEM4 : ITEM의 all to all 조건이 아닌 것, (20900914) ITEM1: ITEM의 ITEM to ITEM 조건
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			  = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.05.09 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 09' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			UPDATE A
			SET    A.S10_SETUP_TIME  = B.S10_SETUP_TIME
				, A.S10_CALCULATION = B.S10_CALCULATION
				, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
										END)
				, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
										END)
			FROM   #tmp_MST_SCM_SETUP_MATRIX_02_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S10_SETUP_TIME * (CASE S10_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S10_SETUP_TIME, 
							TCAL_10 AS S10_CALCULATION ,
							A.FULL_SETUP_FLAG , 
							A.DIE_CHANGE_FLAG 
					FROM	(
							SELECT	*
							FROM	(
									SELECT  Z.*
									FROM    (
											SELECT A.*, CONCAT(upper(CATE_10), setup_seq) GB , 
													DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																				, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
																	ORDER     BY SETUP_SEQ) AS SEQ
											FROM   (
													SELECT	A.*,
															ISNULL(S10.SETUP_TIME,0) AS S10_SETUP_TIME, ISNULL(S10.SETUP_TIME_UOM, 'MINUTE') AS S10_SETUP_TIME_UOM,
															CASE WHEN S10.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S10.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1 
																WHEN S10.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S10.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
																WHEN S10.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S10.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																					ELSE 4
															END  SETUP_SEQ ,
															CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
																 WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																												ELSE 'N'
															END  FULL_SETUP_FLAG , 
															CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																												ELSE 'N'
															END  DIE_CHANGE_FLAG
													FROM    (
															SELECT	*
															FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
															WHERE   MASTER_ID = @p_master_id 
															AND		PLAN_ID = @p_engine_plan_id
															) A
															LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S10
																ON  A.FROM_SG_10    = CASE WHEN S10.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_10 ELSE S10.FROM_ITEM_SETUP_GROUP_ID END 
																AND A.TO_SG_10      = CASE WHEN S10.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_10   ELSE S10.TO_ITEM_SETUP_GROUP_ID   END 
																AND A.COMPANY_ID    = S10.COMPANY_ID
																AND A.DIVISION_ID   = S10.DIVISION_ID
																AND A.SITE_ID       = S10.SITE_ID
																AND	A.PLANT_ID      = S10.PLANT_ID
																AND A.OPERATION_ID  = S10.OPERATION_ID
																AND A.CATE_10       = S10.SETUP_CATEGORY_ID
																AND A.KEY_10        = S10.SETUP_KEY_ID
																AND A.LINE_SETUP_GROUP_ID = S10.LINE_SETUP_GROUP_ID
													WHERE  A.CATE_10 != ''
													--AND    A.FROM_SG_10 != A.TO_SG_10   -- 동일 SETUP 은 반영 금지
													) A
											WHERE  1=1
											AND    ( SETUP_SEQ = 1 )   -- FROM, TO 가 ALL 이 아니면 같은 SETUP 도 발생함.
											OR     ( SETUP_SEQ > 1 AND A.FROM_SG_10 != A.TO_SG_10 )
									) Z
									WHERE 1=1 
									AND   Z.GB NOT IN ( 'ITEM4', 'ITEM1' ) 	 ---+ ITEM4 : ITEM의 all to all 조건이 아닌 것, (21001014) ITEM1: ITEM의 ITEM to ITEM 조건
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			  = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.05.10 END';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 10' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.06.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_MATRIX_03_SN';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			DELETE	#tmp_MST_SCM_SETUP_MATRIX_03_SN
			WHERE	MASTER_ID = @p_master_id 
			AND		PLAN_ID	= @p_engine_plan_id; 

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.06.1 END';
			SET @v_description = 'Process Complete...' + '[DELETE]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.07.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_MATRIX_03_SN';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			INSERT INTO #tmp_MST_SCM_SETUP_MATRIX_03_SN
			(
				MASTER_ID , PLAN_ID , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID , OPERATION_ID, LINE_SETUP_GROUP_ID,
				FROM_SETUP_GROUP_ID, TO_SETUP_GROUP_ID  
				
			)
			SELECT	MASTER_ID , PLAN_ID , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID , OPERATION_ID, LINE_SETUP_GROUP_ID,
					FROM_SETUP_GROUP_ID, TO_SETUP_GROUP_ID
			FROM    #tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
			WHERE	MASTER_ID = @p_master_id 
			AND		PLAN_ID	= @p_engine_plan_id
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.07.1 END';
			SET @v_description = 'Process Complete...' + '[INSERT]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.08.00 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_MATRIX_03_SN';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			UPDATE	A
			SET		A.S01_SETUP_TIME  = B.S01_SETUP_TIME
					, A.S01_CALCULATION = B.S01_CALCULATION
					, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
											END)
					, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
											END)
					, A.GB   =  B.GB -- (20200214) 추가 
			FROM	#tmp_MST_SCM_SETUP_MATRIX_03_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S01_SETUP_TIME * (CASE S01_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S01_SETUP_TIME, 
							TCAL_01 AS S01_CALCULATION , 
							A.FULL_SETUP_FLAG ,
							A.DIE_CHANGE_FLAG ,
							A.GB 
					FROM	(
							SELECT	*
							FROM	(
									SELECT	A.*, CONCAT(upper(CATE_01), setup_seq) AS GB , 
											DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																		, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
															ORDER     BY SETUP_SEQ) AS SEQ
									FROM	(
											SELECT	A.*,
													ISNULL(S01.SETUP_TIME,0) AS S01_SETUP_TIME, ISNULL(S01.SETUP_TIME_UOM, 'MINUTE') AS S01_SETUP_TIME_UOM,
													CASE WHEN S01.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S01.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
														WHEN S01.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S01.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
														WHEN S01.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S01.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																			ELSE 4
													END  SETUP_SEQ , 
													CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
														WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																										ELSE 'N'
													END  FULL_SETUP_FLAG ,
													CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																										ELSE 'N'
													END  DIE_CHANGE_FLAG
											FROM	(
													SELECT	*
													FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
													WHERE   MASTER_ID = @p_master_id 
													AND		PLAN_ID = @p_engine_plan_id
													) A
													LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S01
														ON		A.FROM_SG_01    = CASE WHEN S01.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_01 ELSE S01.FROM_ITEM_SETUP_GROUP_ID END 
														AND		A.TO_SG_01      = CASE WHEN S01.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_01   ELSE S01.TO_ITEM_SETUP_GROUP_ID   END 
														AND		A.COMPANY_ID    = S01.COMPANY_ID
														AND		A.DIVISION_ID   = S01.DIVISION_ID
														AND		A.SITE_ID       = S01.SITE_ID
														AND		A.PLANT_ID      = S01.PLANT_ID
														AND		A.OPERATION_ID  = S01.OPERATION_ID
														AND		A.CATE_01       = S01.SETUP_CATEGORY_ID
														AND		A.KEY_01        = S01.SETUP_KEY_ID
														AND		A.LINE_SETUP_GROUP_ID = S01.LINE_SETUP_GROUP_ID
											WHERE	A.CATE_01 != ''
											) A
									WHERE	CONCAT(upper(CATE_01), setup_seq) IN ('ITEM4', 'ITEM1')   ---+ ITEM의 all to all 조건만, ITEM의 item to item 조건추가.
									AND		A.FROM_SG_01 != A.TO_SG_01 
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			   = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.08.01 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 01' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			UPDATE	A
			SET		A.S02_SETUP_TIME  = B.S02_SETUP_TIME
					, A.S02_CALCULATION = B.S02_CALCULATION
					, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
											END)
					, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
											END)
					, A.GB   =  B.GB 
			FROM	#tmp_MST_SCM_SETUP_MATRIX_03_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S02_SETUP_TIME * (CASE S02_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S02_SETUP_TIME, 
							TCAL_02 AS S02_CALCULATION , 
							A.FULL_SETUP_FLAG ,
							A.DIE_CHANGE_FLAG ,
							A.GB 
					FROM	(
							SELECT	*
							FROM	(
									SELECT	A.*, CONCAT(upper(CATE_02), setup_seq) AS GB , 
											DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																		, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
															ORDER     BY SETUP_SEQ) AS SEQ
									FROM	(
											SELECT	A.*,
													ISNULL(S02.SETUP_TIME,0) AS S02_SETUP_TIME, ISNULL(S02.SETUP_TIME_UOM, 'MINUTE') AS S02_SETUP_TIME_UOM,
													CASE WHEN S02.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S02.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
														WHEN S02.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S02.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
														WHEN S02.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S02.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																			ELSE 4
													END  SETUP_SEQ , 
													CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
														WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																										ELSE 'N'
													END  FULL_SETUP_FLAG ,
													CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																										ELSE 'N'
													END  DIE_CHANGE_FLAG
											FROM	(
													SELECT	*
													FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
													WHERE   MASTER_ID = @p_master_id 
													AND		PLAN_ID = @p_engine_plan_id
													) A
													LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S02
														ON		A.FROM_SG_02    = CASE WHEN S02.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_02 ELSE S02.FROM_ITEM_SETUP_GROUP_ID END 
														AND		A.TO_SG_02      = CASE WHEN S02.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_02   ELSE S02.TO_ITEM_SETUP_GROUP_ID   END 
														AND		A.COMPANY_ID    = S02.COMPANY_ID
														AND		A.DIVISION_ID   = S02.DIVISION_ID
														AND		A.SITE_ID       = S02.SITE_ID
														AND		A.PLANT_ID      = S02.PLANT_ID
														AND		A.OPERATION_ID  = S02.OPERATION_ID
														AND		A.CATE_02       = S02.SETUP_CATEGORY_ID
														AND		A.KEY_02        = S02.SETUP_KEY_ID
														AND		A.LINE_SETUP_GROUP_ID = S02.LINE_SETUP_GROUP_ID
											WHERE	A.CATE_02 != ''
											) A
									WHERE	CONCAT(upper(CATE_02), setup_seq) IN ('ITEM4', 'ITEM1')   ---+ ITEM의 all to all 조건만, ITEM의 item to item 조건추가.
									AND		A.FROM_SG_02 != A.TO_SG_02 
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			  = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.08.02 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 02' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



			UPDATE	A
			SET		A.S03_SETUP_TIME  = B.S03_SETUP_TIME
					, A.S03_CALCULATION = B.S03_CALCULATION
					, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
											END)
					, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
											END)
					, A.GB   =  B.GB 
			FROM	#tmp_MST_SCM_SETUP_MATRIX_03_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S03_SETUP_TIME * (CASE S03_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S03_SETUP_TIME, 
							TCAL_03 AS S03_CALCULATION , 
							A.FULL_SETUP_FLAG ,
							A.DIE_CHANGE_FLAG ,
							A.GB 
					FROM	(
							SELECT	*
							FROM	(
									SELECT	A.*, CONCAT(upper(CATE_03), setup_seq) AS GB , 
											DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																		, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
															ORDER     BY SETUP_SEQ) AS SEQ
									FROM	(
											SELECT	A.*,
													ISNULL(S03.SETUP_TIME,0) AS S03_SETUP_TIME, ISNULL(S03.SETUP_TIME_UOM, 'MINUTE') AS S03_SETUP_TIME_UOM,
													CASE WHEN S03.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S03.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
														WHEN S03.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S03.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
														WHEN S03.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S03.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																			ELSE 4
													END  SETUP_SEQ , 
													CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
														WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																										ELSE 'N'
													END  FULL_SETUP_FLAG ,
													CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																										ELSE 'N'
													END  DIE_CHANGE_FLAG
											FROM	(
													SELECT	*
													FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
													WHERE   MASTER_ID = @p_master_id 
													AND		PLAN_ID = @p_engine_plan_id
													) A
													LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S03
														ON		A.FROM_SG_03    = CASE WHEN S03.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_03 ELSE S03.FROM_ITEM_SETUP_GROUP_ID END 
														AND		A.TO_SG_03      = CASE WHEN S03.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_03   ELSE S03.TO_ITEM_SETUP_GROUP_ID   END 
														AND		A.COMPANY_ID    = S03.COMPANY_ID
														AND		A.DIVISION_ID   = S03.DIVISION_ID
														AND		A.SITE_ID       = S03.SITE_ID
														AND		A.PLANT_ID      = S03.PLANT_ID
														AND		A.OPERATION_ID  = S03.OPERATION_ID
														AND		A.CATE_03       = S03.SETUP_CATEGORY_ID
														AND		A.KEY_03        = S03.SETUP_KEY_ID
														AND		A.LINE_SETUP_GROUP_ID = S03.LINE_SETUP_GROUP_ID
											WHERE	A.CATE_03 != ''
											) A
									WHERE	CONCAT(upper(CATE_03), setup_seq) IN ('ITEM4', 'ITEM1')   ---+ ITEM의 all to all 조건만, ITEM의 item to item 조건추가.
									AND		A.FROM_SG_03 != A.TO_SG_03 
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			   = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.08.03 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 03' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			UPDATE	A
			SET		A.S04_SETUP_TIME  = B.S04_SETUP_TIME
					, A.S04_CALCULATION = B.S04_CALCULATION
					, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
											END)
					, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
											END)
					, A.GB   =  B.GB 
			FROM	#tmp_MST_SCM_SETUP_MATRIX_03_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S04_SETUP_TIME * (CASE S04_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S04_SETUP_TIME, 
							TCAL_04 AS S04_CALCULATION , 
							A.FULL_SETUP_FLAG ,
							A.DIE_CHANGE_FLAG ,
							A.GB 
					FROM	(
							SELECT	*
							FROM	(
									SELECT	A.*, CONCAT(upper(CATE_04), setup_seq) AS GB , 
											DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																		, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
															ORDER     BY SETUP_SEQ) AS SEQ
									FROM	(
											SELECT	A.*,
													ISNULL(S04.SETUP_TIME,0) AS S04_SETUP_TIME, ISNULL(S04.SETUP_TIME_UOM, 'MINUTE') AS S04_SETUP_TIME_UOM,
													CASE WHEN S04.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S04.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
														WHEN S04.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S04.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
														WHEN S04.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S04.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																			ELSE 4
													END  SETUP_SEQ , 
													CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
														WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																										ELSE 'N'
													END  FULL_SETUP_FLAG ,
													CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																										ELSE 'N'
													END  DIE_CHANGE_FLAG
											FROM	(
													SELECT	*
													FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
													WHERE   MASTER_ID = @p_master_id 
													AND		PLAN_ID = @p_engine_plan_id
													) A
													LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S04
														ON		A.FROM_SG_04    = CASE WHEN S04.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_04 ELSE S04.FROM_ITEM_SETUP_GROUP_ID END 
														AND		A.TO_SG_04      = CASE WHEN S04.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_04   ELSE S04.TO_ITEM_SETUP_GROUP_ID   END 
														AND		A.COMPANY_ID    = S04.COMPANY_ID
														AND		A.DIVISION_ID   = S04.DIVISION_ID
														AND		A.SITE_ID       = S04.SITE_ID
														AND		A.PLANT_ID      = S04.PLANT_ID
														AND		A.OPERATION_ID  = S04.OPERATION_ID
														AND		A.CATE_04       = S04.SETUP_CATEGORY_ID
														AND		A.KEY_04        = S04.SETUP_KEY_ID
														AND		A.LINE_SETUP_GROUP_ID = S04.LINE_SETUP_GROUP_ID
											WHERE	A.CATE_04 != ''
											) A
									WHERE	CONCAT(upper(CATE_04), setup_seq) IN ('ITEM4', 'ITEM1')   ---+ ITEM의 all to all 조건만, ITEM의 item to item 조건추가.
									AND		A.FROM_SG_04 != A.TO_SG_04 
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			   = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.08.04 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 04' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			UPDATE	A
			SET		A.S05_SETUP_TIME  = B.S05_SETUP_TIME
					, A.S05_CALCULATION = B.S05_CALCULATION
					, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
											END)
					, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
											END)
					, A.GB   =  B.GB 
			FROM	#tmp_MST_SCM_SETUP_MATRIX_03_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S05_SETUP_TIME * (CASE S05_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S05_SETUP_TIME, 
							TCAL_05 AS S05_CALCULATION , 
							A.FULL_SETUP_FLAG ,
							A.DIE_CHANGE_FLAG ,
							A.GB 
					FROM	(
							SELECT	*
							FROM	(
									SELECT	A.*, CONCAT(upper(CATE_05), setup_seq) AS GB , 
											DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																		, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
															ORDER     BY SETUP_SEQ) AS SEQ
									FROM	(
											SELECT	A.*,
													ISNULL(S05.SETUP_TIME,0) AS S05_SETUP_TIME, ISNULL(S05.SETUP_TIME_UOM, 'MINUTE') AS S05_SETUP_TIME_UOM,
													CASE WHEN S05.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S05.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
														WHEN S05.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S05.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
														WHEN S05.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S05.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																			ELSE 4
													END  SETUP_SEQ , 
													CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
														WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																										ELSE 'N'
													END  FULL_SETUP_FLAG ,
													CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																										ELSE 'N'
													END  DIE_CHANGE_FLAG
											FROM	(
													SELECT	*
													FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
													WHERE   MASTER_ID = @p_master_id 
													AND		PLAN_ID = @p_engine_plan_id
													) A
													LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S05
														ON		A.FROM_SG_05    = CASE WHEN S05.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_05 ELSE S05.FROM_ITEM_SETUP_GROUP_ID END 
														AND		A.TO_SG_05      = CASE WHEN S05.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_05   ELSE S05.TO_ITEM_SETUP_GROUP_ID   END 
														AND		A.COMPANY_ID    = S05.COMPANY_ID
														AND		A.DIVISION_ID   = S05.DIVISION_ID
														AND		A.SITE_ID       = S05.SITE_ID
														AND		A.PLANT_ID      = S05.PLANT_ID
														AND		A.OPERATION_ID  = S05.OPERATION_ID
														AND		A.CATE_05       = S05.SETUP_CATEGORY_ID
														AND		A.KEY_05        = S05.SETUP_KEY_ID
														AND		A.LINE_SETUP_GROUP_ID = S05.LINE_SETUP_GROUP_ID
											WHERE	A.CATE_05 != ''
											) A
									WHERE	CONCAT(upper(CATE_05), setup_seq) IN ('ITEM4', 'ITEM1')   ---+ ITEM의 all to all 조건만, ITEM의 item to item 조건추가.
									AND		A.FROM_SG_05 != A.TO_SG_05 
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			   = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.08.05 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 05' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			UPDATE	A
			SET		A.S06_SETUP_TIME  = B.S06_SETUP_TIME
					, A.S06_CALCULATION = B.S06_CALCULATION
					, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
											END)
					, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
											END)
					, A.GB   =  B.GB 
			FROM	#tmp_MST_SCM_SETUP_MATRIX_03_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S06_SETUP_TIME * (CASE S06_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S06_SETUP_TIME, 
							TCAL_06 AS S06_CALCULATION , 
							A.FULL_SETUP_FLAG ,
							A.DIE_CHANGE_FLAG ,
							A.GB 
					FROM	(
							SELECT	*
							FROM	(
									SELECT	A.*, CONCAT(upper(CATE_06), setup_seq) AS GB , 
											DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																		, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
															ORDER     BY SETUP_SEQ) AS SEQ
									FROM	(
											SELECT	A.*,
													ISNULL(S06.SETUP_TIME,0) AS S06_SETUP_TIME, ISNULL(S06.SETUP_TIME_UOM, 'MINUTE') AS S06_SETUP_TIME_UOM,
													CASE WHEN S06.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S06.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
														WHEN S06.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S06.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
														WHEN S06.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S06.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																			ELSE 4
													END  SETUP_SEQ , 
													CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
														WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																										ELSE 'N'
													END  FULL_SETUP_FLAG ,
													CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																										ELSE 'N'
													END  DIE_CHANGE_FLAG
											FROM	(
													SELECT	*
													FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
													WHERE   MASTER_ID = @p_master_id 
													AND		PLAN_ID = @p_engine_plan_id
													) A
													LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S06
														ON		A.FROM_SG_06    = CASE WHEN S06.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_06 ELSE S06.FROM_ITEM_SETUP_GROUP_ID END 
														AND		A.TO_SG_06      = CASE WHEN S06.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_06   ELSE S06.TO_ITEM_SETUP_GROUP_ID   END 
														AND		A.COMPANY_ID    = S06.COMPANY_ID
														AND		A.DIVISION_ID   = S06.DIVISION_ID
														AND		A.SITE_ID       = S06.SITE_ID
														AND		A.PLANT_ID      = S06.PLANT_ID
														AND		A.OPERATION_ID  = S06.OPERATION_ID
														AND		A.CATE_06       = S06.SETUP_CATEGORY_ID
														AND		A.KEY_06        = S06.SETUP_KEY_ID
														AND		A.LINE_SETUP_GROUP_ID = S06.LINE_SETUP_GROUP_ID
											WHERE	A.CATE_06 != ''
											) A
									WHERE	CONCAT(upper(CATE_06), setup_seq) IN ('ITEM4', 'ITEM1')   ---+ ITEM의 all to all 조건만, ITEM의 item to item 조건추가.
									AND		A.FROM_SG_06 != A.TO_SG_06 
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			   = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.08.06 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 06' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



			UPDATE	A
			SET		A.S07_SETUP_TIME  = B.S07_SETUP_TIME
					, A.S07_CALCULATION = B.S07_CALCULATION
					, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
											END)
					, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
											END)
					, A.GB   =  B.GB 
			FROM	#tmp_MST_SCM_SETUP_MATRIX_03_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S07_SETUP_TIME * (CASE S07_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S07_SETUP_TIME, 
							TCAL_07 AS S07_CALCULATION , 
							A.FULL_SETUP_FLAG ,
							A.DIE_CHANGE_FLAG ,
							A.GB 
					FROM	(
							SELECT	*
							FROM	(
									SELECT	A.*, CONCAT(upper(CATE_07), setup_seq) AS GB , 
											DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																		, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
															ORDER     BY SETUP_SEQ) AS SEQ
									FROM	(
											SELECT	A.*,
													ISNULL(S07.SETUP_TIME,0) AS S07_SETUP_TIME, ISNULL(S07.SETUP_TIME_UOM, 'MINUTE') AS S07_SETUP_TIME_UOM,
													CASE WHEN S07.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S07.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
														WHEN S07.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S07.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
														WHEN S07.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S07.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																			ELSE 4
													END  SETUP_SEQ , 
													CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
														WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																										ELSE 'N'
													END  FULL_SETUP_FLAG ,
													CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																										ELSE 'N'
													END  DIE_CHANGE_FLAG
											FROM	(
													SELECT	*
													FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
													WHERE   MASTER_ID = @p_master_id 
													AND		PLAN_ID = @p_engine_plan_id
													) A
													LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S07
														ON		A.FROM_SG_07    = CASE WHEN S07.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_07 ELSE S07.FROM_ITEM_SETUP_GROUP_ID END 
														AND		A.TO_SG_07      = CASE WHEN S07.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_07   ELSE S07.TO_ITEM_SETUP_GROUP_ID   END 
														AND		A.COMPANY_ID    = S07.COMPANY_ID
														AND		A.DIVISION_ID   = S07.DIVISION_ID
														AND		A.SITE_ID       = S07.SITE_ID
														AND		A.PLANT_ID      = S07.PLANT_ID
														AND		A.OPERATION_ID  = S07.OPERATION_ID
														AND		A.CATE_07       = S07.SETUP_CATEGORY_ID
														AND		A.KEY_07        = S07.SETUP_KEY_ID
														AND		A.LINE_SETUP_GROUP_ID = S07.LINE_SETUP_GROUP_ID
											WHERE	A.CATE_07 != ''
											) A
									WHERE	CONCAT(upper(CATE_07), setup_seq) IN ('ITEM4', 'ITEM1')   ---+ ITEM의 all to all 조건만, ITEM의 item to item 조건추가.
									AND		A.FROM_SG_07 != A.TO_SG_07 
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			   = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.08.07 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 07' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			UPDATE	A
			SET		A.S08_SETUP_TIME  = B.S08_SETUP_TIME
					, A.S08_CALCULATION = B.S08_CALCULATION
					, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
											END)
					, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
											END)
					, A.GB   =  B.GB 
			FROM	#tmp_MST_SCM_SETUP_MATRIX_03_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S08_SETUP_TIME * (CASE S08_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S08_SETUP_TIME, 
							TCAL_08 AS S08_CALCULATION , 
							A.FULL_SETUP_FLAG ,
							A.DIE_CHANGE_FLAG ,
							A.GB 
					FROM	(
							SELECT	*
							FROM	(
									SELECT	A.*, CONCAT(upper(CATE_08), setup_seq) AS GB , 
											DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																		, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
															ORDER     BY SETUP_SEQ) AS SEQ
									FROM	(
											SELECT	A.*,
													ISNULL(S08.SETUP_TIME,0) AS S08_SETUP_TIME, ISNULL(S08.SETUP_TIME_UOM, 'MINUTE') AS S08_SETUP_TIME_UOM,
													CASE WHEN S08.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S08.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
														WHEN S08.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S08.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
														WHEN S08.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S08.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																			ELSE 4
													END  SETUP_SEQ , 
													CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
														WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																										ELSE 'N'
													END  FULL_SETUP_FLAG ,
													CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																										ELSE 'N'
													END  DIE_CHANGE_FLAG
											FROM	(
													SELECT	*
													FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
													WHERE   MASTER_ID = @p_master_id 
													AND		PLAN_ID = @p_engine_plan_id
													) A
													LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S08
														ON		A.FROM_SG_08    = CASE WHEN S08.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_08 ELSE S08.FROM_ITEM_SETUP_GROUP_ID END 
														AND		A.TO_SG_08      = CASE WHEN S08.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_08   ELSE S08.TO_ITEM_SETUP_GROUP_ID   END 
														AND		A.COMPANY_ID    = S08.COMPANY_ID
														AND		A.DIVISION_ID   = S08.DIVISION_ID
														AND		A.SITE_ID       = S08.SITE_ID
														AND		A.PLANT_ID      = S08.PLANT_ID
														AND		A.OPERATION_ID  = S08.OPERATION_ID
														AND		A.CATE_08       = S08.SETUP_CATEGORY_ID
														AND		A.KEY_08        = S08.SETUP_KEY_ID
														AND		A.LINE_SETUP_GROUP_ID = S08.LINE_SETUP_GROUP_ID
											WHERE	A.CATE_08 != ''
											) A
									WHERE	CONCAT(upper(CATE_08), setup_seq) IN ('ITEM4', 'ITEM1')   ---+ ITEM의 all to all 조건만, ITEM의 item to item 조건추가.
									AND		A.FROM_SG_08 != A.TO_SG_08 
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			   = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.08.08 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 08' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			UPDATE	A
			SET		A.S09_SETUP_TIME  = B.S09_SETUP_TIME
					, A.S09_CALCULATION = B.S09_CALCULATION
					, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
											END)
					, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
											END)
					, A.GB   =  B.GB 
			FROM	#tmp_MST_SCM_SETUP_MATRIX_03_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S09_SETUP_TIME * (CASE S09_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S09_SETUP_TIME, 
							TCAL_09 AS S09_CALCULATION , 
							A.FULL_SETUP_FLAG ,
							A.DIE_CHANGE_FLAG ,
							A.GB 
					FROM	(
							SELECT	*
							FROM	(
									SELECT	A.*, CONCAT(upper(CATE_09), setup_seq) AS GB , 
											DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																		, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
															ORDER     BY SETUP_SEQ) AS SEQ
									FROM	(
											SELECT	A.*,
													ISNULL(S09.SETUP_TIME,0) AS S09_SETUP_TIME, ISNULL(S09.SETUP_TIME_UOM, 'MINUTE') AS S09_SETUP_TIME_UOM,
													CASE WHEN S09.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S09.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
														WHEN S09.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S09.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
														WHEN S09.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S09.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																			ELSE 4
													END  SETUP_SEQ , 
													CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
														WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																										ELSE 'N'
													END  FULL_SETUP_FLAG ,
													CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																										ELSE 'N'
													END  DIE_CHANGE_FLAG
											FROM	(
													SELECT	*
													FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
													WHERE   MASTER_ID = @p_master_id 
													AND		PLAN_ID = @p_engine_plan_id
													) A
													LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S09
														ON		A.FROM_SG_09    = CASE WHEN S09.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_09 ELSE S09.FROM_ITEM_SETUP_GROUP_ID END 
														AND		A.TO_SG_09      = CASE WHEN S09.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_09   ELSE S09.TO_ITEM_SETUP_GROUP_ID   END 
														AND		A.COMPANY_ID    = S09.COMPANY_ID
														AND		A.DIVISION_ID   = S09.DIVISION_ID
														AND		A.SITE_ID       = S09.SITE_ID
														AND		A.PLANT_ID      = S09.PLANT_ID
														AND		A.OPERATION_ID  = S09.OPERATION_ID
														AND		A.CATE_09       = S09.SETUP_CATEGORY_ID
														AND		A.KEY_09        = S09.SETUP_KEY_ID
														AND		A.LINE_SETUP_GROUP_ID = S09.LINE_SETUP_GROUP_ID
											WHERE	A.CATE_09 != ''
											) A
									WHERE	CONCAT(upper(CATE_09), setup_seq) IN ('ITEM4', 'ITEM1')   ---+ ITEM의 all to all 조건만, ITEM의 item to item 조건추가.
									AND		A.FROM_SG_09 != A.TO_SG_09 
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			   = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.08.09 RUN';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 09' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			UPDATE	A
			SET		A.S10_SETUP_TIME  = B.S10_SETUP_TIME
					, A.S10_CALCULATION = B.S10_CALCULATION
					, A.FULL_SETUP_FLAG = (CASE WHEN A.FULL_SETUP_FLAG = 'Y' THEN 'Y'
																		ELSE B.FULL_SETUP_FLAG
											END)
					, A.DIE_CHANGE_FLAG = (CASE WHEN A.DIE_CHANGE_FLAG = 'Y' THEN 'Y'
																		ELSE B.DIE_CHANGE_FLAG
											END)
					, A.GB   =  B.GB 
			FROM	#tmp_MST_SCM_SETUP_MATRIX_03_SN A,
					(
					SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
							S10_SETUP_TIME * (CASE S10_SETUP_TIME_UOM    
												WHEN 'HOUR'   THEN 60
												WHEN 'SECOND' THEN 1/60
												WHEN 'DAY'    THEN 1440  
																ELSE 1 END ) S10_SETUP_TIME, 
							TCAL_10 AS S10_CALCULATION , 
							A.FULL_SETUP_FLAG ,
							A.DIE_CHANGE_FLAG ,
							A.GB 
					FROM	(
							SELECT	*
							FROM	(
									SELECT	A.*, CONCAT(upper(CATE_10), setup_seq) AS GB , 
											DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID
																		, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
															ORDER     BY SETUP_SEQ) AS SEQ
									FROM	(
											SELECT	A.*,
													ISNULL(S10.SETUP_TIME,0) AS S10_SETUP_TIME, ISNULL(S10.SETUP_TIME_UOM, 'MINUTE') AS S10_SETUP_TIME_UOM,
													CASE WHEN S10.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S10.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
														WHEN S10.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S10.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
														WHEN S10.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S10.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
																																			ELSE 4
													END  SETUP_SEQ , 
													CASE WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
														WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
																										ELSE 'N'
													END  FULL_SETUP_FLAG ,
													CASE WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
																										ELSE 'N'
													END  DIE_CHANGE_FLAG
											FROM	(
													SELECT	*
													FROM	#tmp_MST_SCM_SETUP_MATRIX_01_SN WITH ( NOLOCK ) 
													WHERE   MASTER_ID = @p_master_id 
													AND		PLAN_ID = @p_engine_plan_id
													) A
													LEFT OUTER JOIN SCM_SETUP_MATRIX_M_SN S10
														ON		A.FROM_SG_10    = CASE WHEN S10.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_10 ELSE S10.FROM_ITEM_SETUP_GROUP_ID END 
														AND		A.TO_SG_10      = CASE WHEN S10.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_10   ELSE S10.TO_ITEM_SETUP_GROUP_ID   END 
														AND		A.COMPANY_ID    = S10.COMPANY_ID
														AND		A.DIVISION_ID   = S10.DIVISION_ID
														AND		A.SITE_ID       = S10.SITE_ID
														AND		A.PLANT_ID      = S10.PLANT_ID
														AND		A.OPERATION_ID  = S10.OPERATION_ID
														AND		A.CATE_10       = S10.SETUP_CATEGORY_ID
														AND		A.KEY_10        = S10.SETUP_KEY_ID
														AND		A.LINE_SETUP_GROUP_ID = S10.LINE_SETUP_GROUP_ID
											WHERE	A.CATE_10 != ''
											) A
									WHERE	CONCAT(upper(CATE_10), setup_seq) IN ('ITEM4', 'ITEM1')   ---+ ITEM의 all to all 조건만, ITEM의 item to item 조건추가.
									AND		A.FROM_SG_10 != A.TO_SG_10 
									) A
							WHERE  SEQ = 1
							) A
					) B
			WHERE	A.MASTER_ID			  = @p_master_id
			AND		A.PLAN_ID			  = @p_engine_plan_id
			AND		A.MASTER_ID           = B.MASTER_ID
			AND		A.PLAN_ID	          = B.PLAN_ID
			AND		A.COMPANY_ID          = B.COMPANY_ID
			AND		A.DIVISION_ID         = B.DIVISION_ID
			AND		A.SITE_ID             = B.SITE_ID
			AND		A.PLANT_ID			   = B.PLANT_ID
			AND		A.OPERATION_ID        = B.OPERATION_ID
			AND		A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			AND		A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
			AND		A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.08.10 END';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP LEVEL 10' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.09.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_MATRIX';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			DELETE #tmp_MST_SCM_SETUP_MATRIX
			WHERE   MASTER_ID = @p_master_id 
			AND		PLAN_ID = @p_engine_plan_id
			; 

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.09.1 END';
			SET @v_description = 'Process Complete...' + '[DELETE]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.10.0 START';
			SET @v_description = N'#tmp_MST_SCM_SETUP_MATRIX';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			INSERT INTO #tmp_MST_SCM_SETUP_MATRIX
			(
					MASTER_ID, 
					PLAN_ID, 
					COMPANY_ID, 
					DIVISION_ID, 
					SITE_ID, 
					PLANT_ID , 
					OPERATION_ID, 
					LINE_SETUP_GROUP_ID, 
					FROM_SETUP_GROUP_ID, 
					TO_SETUP_GROUP_ID , 
					SETUP_TIME, 
					SETUP_TIME_UOM ,
					FULL_SETUP_FLAG , 
					DIE_CHANGE_FLAG
			)    
			/* SETUP CONDITION의 SETUP_TIME= 0 일 경우에 ALL TO ALL 조건의 SETUP_TIME을 사용한다. 
			   Item to Item 조건을 1순위로 반영하는 로직 추가. [ setup time 반영 우선순위: ITEM / item to item 시간 > item별 setup time > ITEM / all to all 시간  ] */ 
			SELECT	AA.MASTER_ID, 
					AA.PLAN_ID,
					AA.COMPANY_ID, 
					AA.DIVISION_ID, 
					AA.SITE_ID, 
					AA.PLANT_ID,
					AA.OPERATION_ID, 
					AA.LINE_SETUP_GROUP_ID, 
					AA.FROM_SETUP_GROUP_ID, 
					AA.TO_SETUP_GROUP_ID ,
					CASE 
						WHEN ISNULL(SUM(AA.SETUP_TIME_I),0) != 0                                         THEN  ISNULL(SUM(AA.SETUP_TIME_I),0)    ---+ item to item 값을 우선.
						WHEN ISNULL(SUM(AA.SETUP_TIME_I),0)  = 0 AND ISNULL(SUM(AA.SETUP_TIME_C),0) = 0  THEN  ISNULL(SUM(AA.SETUP_TIME_A),0)    ---+ item to itme도 없고, 조건별 값도 없으면 Item / all to all 값으로 적용
						ELSE ISNULL(SUM(AA.SETUP_TIME_C),0)   ---+ 그 외에는 item 조건값 사용.
					END   SETUP_TIME ,
					AA.SETUP_TIME_UOM ,
					CASE 
						WHEN ISNULL(SUM(AA.SETUP_TIME_I),0) != 0     THEN MAX(AA.FULL_SETUP_FLAG_I)
						WHEN ISNULL(SUM(AA.SETUP_TIME_I),0)  = 0 AND ISNULL(SUM(AA.SETUP_TIME_C),0) = 0  THEN  MAX(AA.FULL_SETUP_FLAG_A)
						ELSE MAX(AA.FULL_SETUP_FLAG_C)        
					END FULL_SETUP_FLAG ,
					CASE 
						WHEN ISNULL(SUM(AA.SETUP_TIME_I),0) != 0     THEN MAX(AA.DIE_CHANGE_FLAG_I)
						WHEN ISNULL(SUM(AA.SETUP_TIME_C),0)  = 0 AND ISNULL(SUM(AA.SETUP_TIME_C),0) = 0  THEN MAX(AA.DIE_CHANGE_FLAG_A)  
						ELSE MAX(AA.DIE_CHANGE_FLAG_C)        
					END DIE_CHANGE_FLAG
			FROM    ( 
						---===  #tmp_MST_SCM_SETUP_MATRIX_02_SN  ===---
					SELECT	DISTINCT
							A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID , 
							SUM(SETUP_TIME)  AS SETUP_TIME_C , 
							0               AS SETUP_TIME_A ,
							0               AS SETUP_TIME_I , 
							'MINUTE'         AS SETUP_TIME_UOM , 
							MAX(A.FULL_SETUP_FLAG) AS FULL_SETUP_FLAG_C , 
							'-'                    AS FULL_SETUP_FLAG_A , 
							'-'                    AS FULL_SETUP_FLAG_I , 
							MAX(A.DIE_CHANGE_FLAG) AS DIE_CHANGE_FLAG_C ,
							'-'                    AS DIE_CHANGE_FLAG_A ,
							'-'                    AS DIE_CHANGE_FLAG_I 
					FROM	(
							SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
									A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
									MAX(SETUP_TIME) AS SETUP_TIME ,
									MAX(FULL_SETUP_FLAG) AS FULL_SETUP_FLAG ,
									MAX(DIE_CHANGE_FLAG) AS DIE_CHANGE_FLAG
							FROM	(
									SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
											A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
											B.INT AS LEVEL,
											CASE INT 
													WHEN  1 THEN S01_SETUP_TIME
													WHEN  2 THEN S02_SETUP_TIME
													WHEN  3 THEN S03_SETUP_TIME
													WHEN  4 THEN S04_SETUP_TIME
													WHEN  5 THEN S05_SETUP_TIME
													WHEN  6 THEN S06_SETUP_TIME
													WHEN  7 THEN S07_SETUP_TIME
													WHEN  8 THEN S08_SETUP_TIME
													WHEN  9 THEN S09_SETUP_TIME
													WHEN 10 THEN S10_SETUP_TIME
															ELSE 0
											END  SETUP_TIME , 
											A.FULL_SETUP_FLAG , 
											A.DIE_CHANGE_FLAG
									FROM	(
											SELECT  *
											FROM	#tmp_MST_SCM_SETUP_MATRIX_02_SN WITH ( NOLOCK )
											WHERE	MASTER_ID = @p_master_id 
											AND		PLAN_ID = @p_plan_id
											) A ,
											(
											SELECT INT, 'MAX' AS CALCULATION 
											FROM   COPYT_SN
											WHERE  INT <= 10
											) B
									WHERE	B.CALCULATION =    ( 
																CASE INT 
																		WHEN  1 THEN S01_CALCULATION
																		WHEN  2 THEN S02_CALCULATION
																		WHEN  3 THEN S03_CALCULATION
																		WHEN  4 THEN S04_CALCULATION
																		WHEN  5 THEN S05_CALCULATION
																		WHEN  6 THEN S06_CALCULATION
																		WHEN  7 THEN S07_CALCULATION
																		WHEN  8 THEN S08_CALCULATION
																		WHEN  9 THEN S09_CALCULATION
																		WHEN 10 THEN S10_CALCULATION
																				ELSE 'MAX'
																END
																)
									) A
							GROUP  BY A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
									A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
							UNION  ALL
							SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
									A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
									CASE INT WHEN  1 THEN S01_SETUP_TIME
											WHEN  2 THEN S02_SETUP_TIME
											WHEN  3 THEN S03_SETUP_TIME
											WHEN  4 THEN S04_SETUP_TIME
											WHEN  5 THEN S05_SETUP_TIME
											WHEN  6 THEN S06_SETUP_TIME
											WHEN  7 THEN S07_SETUP_TIME
											WHEN  8 THEN S08_SETUP_TIME
											WHEN  9 THEN S09_SETUP_TIME
											WHEN 10 THEN S10_SETUP_TIME
													ELSE 0
									END  SETUP_TIME
									, A.FULL_SETUP_FLAG
									, A.DIE_CHANGE_FLAG
							FROM	(
									SELECT  * 
									FROM    #tmp_MST_SCM_SETUP_MATRIX_02_SN WITH ( NOLOCK ) 
									WHERE   MASTER_ID = @p_master_id
									AND		PLAN_ID	= @p_engine_plan_id
									) A,
									(
									SELECT INT, 'SUM' AS CALCULATION 
									FROM   COPYT_SN
									WHERE  INT <= 10
									) B
							WHERE	B.CALCULATION =    ( 
														CASE INT 
																WHEN  1 THEN S01_CALCULATION
																WHEN  2 THEN S02_CALCULATION
																WHEN  3 THEN S03_CALCULATION
																WHEN  4 THEN S04_CALCULATION
																WHEN  5 THEN S05_CALCULATION
																WHEN  6 THEN S06_CALCULATION
																WHEN  7 THEN S07_CALCULATION
																WHEN  8 THEN S08_CALCULATION
																WHEN  9 THEN S09_CALCULATION
																WHEN 10 THEN S10_CALCULATION
																		ELSE 'MAX'
														END
														)
							) A
					GROUP  BY A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
							A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID     
					UNION ALL 
					/*
						#tmp_MST_SCM_SETUP_MATRIX_03_SN : ITEM4 = ALL TO ALL
					*/
					SELECT	DISTINCT
							A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID , 
							0               AS SETUP_TIME_C  ,
							SUM(SETUP_TIME) AS SETUP_TIME_A  ,  ---+ Item / All to All 시간
							0	            AS SETUP_TIME_I , 
							'MINUTE'        AS SETUP_TIME_UOM , 
							'-'                    AS FULL_SETUP_FLAG_C , 
							MAX(A.FULL_SETUP_FLAG) AS FULL_SETUP_FLAG_A ,
							'-'                    AS FULL_SETUP_FLAG_I , 
							'-'                    AS DIE_CHANGE_FLAG_C , 
							MAX(A.DIE_CHANGE_FLAG) AS DIE_CHANGE_FLAG_A , 
							'-'                    AS DIE_CHANGE_FLAG_I
					FROM	(
							SELECT  A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
									MAX(SETUP_TIME) AS SETUP_TIME , 
									MAX(FULL_SETUP_FLAG) AS FULL_SETUP_FLAG , 
									MAX(DIE_CHANGE_FLAG) AS DIE_CHANGE_FLAG
							FROM	(
									SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
											B.INT AS LEVEL,
											CASE INT 
													WHEN  1 THEN S01_SETUP_TIME
													WHEN  2 THEN S02_SETUP_TIME
													WHEN  3 THEN S03_SETUP_TIME
													WHEN  4 THEN S04_SETUP_TIME
													WHEN  5 THEN S05_SETUP_TIME
													WHEN  6 THEN S06_SETUP_TIME
													WHEN  7 THEN S07_SETUP_TIME
													WHEN  8 THEN S08_SETUP_TIME
													WHEN  9 THEN S09_SETUP_TIME
													WHEN 10 THEN S10_SETUP_TIME
													ELSE 0
											END  SETUP_TIME , 
											A.FULL_SETUP_FLAG , 
											A.DIE_CHANGE_FLAG , 
											CASE INT 
													WHEN  1 THEN S01_CALCULATION
													WHEN  2 THEN S02_CALCULATION
													WHEN  3 THEN S03_CALCULATION
													WHEN  4 THEN S04_CALCULATION
													WHEN  5 THEN S05_CALCULATION
													WHEN  6 THEN S06_CALCULATION
													WHEN  7 THEN S07_CALCULATION
													WHEN  8 THEN S08_CALCULATION
													WHEN  9 THEN S09_CALCULATION
													WHEN 10 THEN S10_CALCULATION
													ELSE 'MAX'
											END CALCULATION
									FROM	(
											SELECT  * 
											FROM    #tmp_MST_SCM_SETUP_MATRIX_03_SN WITH ( NOLOCK ) 
											WHERE   MASTER_ID = @p_master_id
											AND		PLAN_ID	= @p_engine_plan_id
											AND	    GB = 'ITEM4' 
											) A,
											(
											SELECT INT, 'MAX' AS CALCULATION 
											FROM   COPYT_SN
											WHERE  INT <= 10
											) B
									WHERE	B.CALCULATION =    ( 
																CASE INT 
																		WHEN  1 THEN S01_CALCULATION
																		WHEN  2 THEN S02_CALCULATION
																		WHEN  3 THEN S03_CALCULATION
																		WHEN  4 THEN S04_CALCULATION
																		WHEN  5 THEN S05_CALCULATION
																		WHEN  6 THEN S06_CALCULATION
																		WHEN  7 THEN S07_CALCULATION
																		WHEN  8 THEN S08_CALCULATION
																		WHEN  9 THEN S09_CALCULATION
																		WHEN 10 THEN S10_CALCULATION
																				ELSE 'MAX'
																END
																)
									) A
							GROUP  BY A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID 
							UNION  ALL
							SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
									CASE INT 
											WHEN  1 THEN S01_SETUP_TIME
											WHEN  2 THEN S02_SETUP_TIME
											WHEN  3 THEN S03_SETUP_TIME
											WHEN  4 THEN S04_SETUP_TIME
											WHEN  5 THEN S05_SETUP_TIME
											WHEN  6 THEN S06_SETUP_TIME
											WHEN  7 THEN S07_SETUP_TIME
											WHEN  8 THEN S08_SETUP_TIME
											WHEN  9 THEN S09_SETUP_TIME
											WHEN 10 THEN S10_SETUP_TIME
											ELSE 0
									END  SETUP_TIME , 
									A.FULL_SETUP_FLAG , 
									A.DIE_CHANGE_FLAG
							FROM	(
									SELECT  * 
									FROM    #tmp_MST_SCM_SETUP_MATRIX_03_SN WITH ( NOLOCK ) 
									WHERE   MASTER_ID = @p_master_id
									AND		PLAN_ID	= @p_engine_plan_id
									AND	    GB = 'ITEM4' 
									) A,
									(
									SELECT INT, 'SUM' AS CALCULATION 
									FROM   COPYT_SN
									WHERE  INT <= 10
									) B
							WHERE	B.CALCULATION =    ( 
														CASE INT 
																WHEN  1 THEN S01_CALCULATION
																WHEN  2 THEN S02_CALCULATION
																WHEN  3 THEN S03_CALCULATION
																WHEN  4 THEN S04_CALCULATION
																WHEN  5 THEN S05_CALCULATION
																WHEN  6 THEN S06_CALCULATION
																WHEN  7 THEN S07_CALCULATION
																WHEN  8 THEN S08_CALCULATION
																WHEN  9 THEN S09_CALCULATION
																WHEN 10 THEN S10_CALCULATION
																		ELSE 'MAX'
														END
														)
							) A
					GROUP  BY  A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID 
					UNION ALL 
					/*
						#tmp_MST_SCM_SETUP_MATRIX_03_SN : ITEM1 = ITEM TO ITEM 
					*/
					SELECT DISTINCT
							A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID , 
							0               AS SETUP_TIME_C  ,
							0               AS SETUP_TIME_A  ,
							SUM(SETUP_TIME) AS SETUP_TIME_I  ,  ---+ Item / Item to Item 시간
							'MINUTE'        AS SETUP_TIME_UOM , 
							'-'                    AS FULL_SETUP_FLAG_C ,
							'-'                    AS FULL_SETUP_FLAG_A , 
							MAX(A.FULL_SETUP_FLAG) AS FULL_SETUP_FLAG_I , 
							'-'                    AS DIE_CHANGE_FLAG_C , 
							'-'                    AS DIE_CHANGE_FLAG_A , 
							MAX(A.DIE_CHANGE_FLAG) AS DIE_CHANGE_FLAG_I
					FROM	(
							SELECT  A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID , 
									MAX(SETUP_TIME)      AS SETUP_TIME , 
									MAX(FULL_SETUP_FLAG) AS FULL_SETUP_FLAG , 
									MAX(DIE_CHANGE_FLAG) AS DIE_CHANGE_FLAG
							FROM   (
									SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
											B.INT AS LEVEL,
											CASE INT 
													WHEN  1 THEN S01_SETUP_TIME
													WHEN  2 THEN S02_SETUP_TIME
													WHEN  3 THEN S03_SETUP_TIME
													WHEN  4 THEN S04_SETUP_TIME
													WHEN  5 THEN S05_SETUP_TIME
													WHEN  6 THEN S06_SETUP_TIME
													WHEN  7 THEN S07_SETUP_TIME
													WHEN  8 THEN S08_SETUP_TIME
													WHEN  9 THEN S09_SETUP_TIME
													WHEN 10 THEN S10_SETUP_TIME
													ELSE 0
											END  SETUP_TIME , 
											A.FULL_SETUP_FLAG , 
											A.DIE_CHANGE_FLAG , 
											CASE INT 
													WHEN  1 THEN S01_CALCULATION
													WHEN  2 THEN S02_CALCULATION
													WHEN  3 THEN S03_CALCULATION
													WHEN  4 THEN S04_CALCULATION
													WHEN  5 THEN S05_CALCULATION
													WHEN  6 THEN S06_CALCULATION
													WHEN  7 THEN S07_CALCULATION
													WHEN  8 THEN S08_CALCULATION
													WHEN  9 THEN S09_CALCULATION
													WHEN 10 THEN S10_CALCULATION
													ELSE 'MAX'
											END CALCULATION
									FROM	(
											SELECT  * 
											FROM    #tmp_MST_SCM_SETUP_MATRIX_03_SN WITH ( NOLOCK ) 
											WHERE   MASTER_ID = @p_master_id
											AND		PLAN_ID	= @p_engine_plan_id
											AND		GB = 'ITEM1' 
											) A,
											(
											SELECT INT, 'MAX' AS CALCULATION 
											FROM   COPYT_SN
											WHERE  INT <= 10
											) B
									WHERE  B.CALCULATION =    ( 
																CASE INT 
																		WHEN  1 THEN S01_CALCULATION
																		WHEN  2 THEN S02_CALCULATION
																		WHEN  3 THEN S03_CALCULATION
																		WHEN  4 THEN S04_CALCULATION
																		WHEN  5 THEN S05_CALCULATION
																		WHEN  6 THEN S06_CALCULATION
																		WHEN  7 THEN S07_CALCULATION
																		WHEN  8 THEN S08_CALCULATION
																		WHEN  9 THEN S09_CALCULATION
																		WHEN 10 THEN S10_CALCULATION
																		ELSE 'MAX'
																END
																)
									) A
							GROUP  BY A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID 
							UNION  ALL
							SELECT	A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.PLANT_ID , A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
									CASE INT 
											WHEN  1 THEN S01_SETUP_TIME
											WHEN  2 THEN S02_SETUP_TIME
											WHEN  3 THEN S03_SETUP_TIME
											WHEN  4 THEN S04_SETUP_TIME
											WHEN  5 THEN S05_SETUP_TIME
											WHEN  6 THEN S06_SETUP_TIME
											WHEN  7 THEN S07_SETUP_TIME
											WHEN  8 THEN S08_SETUP_TIME
											WHEN  9 THEN S09_SETUP_TIME
											WHEN 10 THEN S10_SETUP_TIME
											ELSE 0
									END  SETUP_TIME , 
									A.FULL_SETUP_FLAG , 
									A.DIE_CHANGE_FLAG
							FROM	(
									SELECT  * 
									FROM    #tmp_MST_SCM_SETUP_MATRIX_03_SN WITH ( NOLOCK ) 
									WHERE   MASTER_ID = @p_master_id
									AND		PLAN_ID	= @p_engine_plan_id
									AND		GB = 'ITEM1' 
									) A,
									(
									SELECT INT, 'SUM' AS CALCULATION 
									FROM   COPYT_SN
									WHERE  INT <= 10
									) B
							WHERE	B.CALCULATION =    ( 
														CASE INT 
																WHEN  1 THEN S01_CALCULATION
																WHEN  2 THEN S02_CALCULATION
																WHEN  3 THEN S03_CALCULATION
																WHEN  4 THEN S04_CALCULATION
																WHEN  5 THEN S05_CALCULATION
																WHEN  6 THEN S06_CALCULATION
																WHEN  7 THEN S07_CALCULATION
																WHEN  8 THEN S08_CALCULATION
																WHEN  9 THEN S09_CALCULATION
																WHEN 10 THEN S10_CALCULATION
																ELSE 'MAX'
														END
														)
							) A
					GROUP  BY  A.MASTER_ID , A.PLAN_ID , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID 
					) AA 
			WHERE	1=1 
			GROUP BY   AA.MASTER_ID , AA.PLAN_ID , AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID , AA.OPERATION_ID, AA.LINE_SETUP_GROUP_ID, AA.FROM_SETUP_GROUP_ID, AA.TO_SETUP_GROUP_ID, AA.SETUP_TIME_UOM 
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '4.10.1 END';
			SET @v_description = 'Process Complete...' + '[INSERT]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		   /*************************************************************************
			MST SETUP 구성
			--> 1. TH_MST_SETUP_TIME_SN 
				- 
				2. TH_MST_SETUP_CATEGORY_SN 
				- 
			**************************************************************************/

			SET @v_log_type = 'TXN';
			SET @v_log_message = '5.01.0 START';
			SET @v_description = N'TH_MST_SETUP_TIME_SN' ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			DELETE	TH_MST_SETUP_TIME_SN
			WHERE   MASTER_ID = @p_master_id
			AND		PLAN_ID	= @p_engine_plan_id
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '5.01.1 END';
			SET @v_description = 'Process Complete...' + '[DELETE]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '5.02.0 START';
			SET @v_description = N'TH_MST_SETUP_TIME_SN';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			INSERT INTO TH_MST_SETUP_TIME_SN
			(
					MASTER_ID ,
					PLAN_ID ,
					RESOURCE_SETUP_GROUP_ID ,
					SETUP_CATEGORY_ID ,
					FROM_SETUP_ID ,
					TO_SETUP_ID ,
					SETUP_TIME ,
					FIRST_SETUP_TIME ,
					SETUP_TIME_UOM ,
					DESCR ,
					KEY_DATE ,
					INSERT_ID ,
					INSERT_DTTM ,
					UPDATE_ID ,
					UPDATE_DTTM
			)
			SELECT	@p_master_id AS MASTER_ID ,
					@p_engine_plan_id AS PLAN_ID , 
					LINE_SETUP_GROUP_ID AS RESOURCE_SETUP_GROUP_ID ,
					LINE_SETUP_GROUP_ID AS SETUP_CATEGORY_ID ,
					FROM_SETUP_GROUP_ID AS FROM_SETUP_ID ,
					TO_SETUP_GROUP_ID   AS TO_SETUP_ID ,
					MAX(SETUP_TIME)     AS SETUP_TIME ,
					0                   AS FIRST_SETUP_TIME ,
					SETUP_TIME_UOM ,
					''  + CASE WHEN MAX(A.FULL_SETUP_FLAG) = 'Y' THEN '::FULL' ELSE '' END
						+ CASE WHEN MAX(A.DIE_CHANGE_FLAG) = 'Y' THEN '::DIE'  ELSE '' END    
					AS DESCR ,
					'20221107' AS KEY_DATE ,
					'SETUP_MATRIX' AS INSERT_ID ,
					GETDATE() AS INSERT_DTTM ,
					'SETUP_MATRIX' AS UPDATE_ID ,
					GETDATE() AS UPDATE_DTTM
			FROM	(
					SELECT  A.LINE_SETUP_GROUP_ID  AS LINE_SETUP_GROUP_ID, 
							A.FROM_SETUP_GROUP_ID , 
							A.TO_SETUP_GROUP_ID ,
							A.SETUP_TIME ,
							A.SETUP_TIME_UOM ,
							A.FULL_SETUP_FLAG ,
							A.DIE_CHANGE_FLAG
					FROM    #tmp_MST_SCM_SETUP_MATRIX A WITH ( NOLOCK ) 
					WHERE   MASTER_ID = @p_master_id
					AND		PLAN_ID	= @p_engine_plan_id
					AND	    SETUP_TIME > 0
					UNION   ALL
					SELECT  A.LINE_SETUP_GROUP_ID LINE_SETUP_GROUP_ID,
							A.FROM_ITEM_SETUP_GROUP_ID  AS FROM_SETUP_GROUP_ID ,
							A.TO_ITEM_SETUP_GROUP_ID    AS TO_SETUP_GROUP_ID ,
							A.SETUP_TIME ,
							A.SETUP_TIME_UOM ,
							CASE 
								WHEN CHARINDEX(N'풀',   SETUP_CONDITION_ID) > 0 THEN 'Y'
								WHEN CHARINDEX(N'FULL', SETUP_CONDITION_ID) > 0 THEN 'Y'
								ELSE 'N'
							END  FULL_SETUP_FLAG ,
							CASE 
								WHEN CHARINDEX(N'DIE', SETUP_CONDITION_ID) > 0  THEN 'Y'
								ELSE 'N'
							END  DIE_CHANGE_FLAG 
					FROM    SCM_SETUP_MATRIX_M_SN A  WITH ( NOLOCK ) 
					WHERE   A.SETUP_TIME > 0
					AND     A.FROM_ITEM_SETUP_GROUP_ID  = 'ALL'
					AND     A.TO_ITEM_SETUP_GROUP_ID    = 'ALL'
   					AND     EXISTS (
									SELECT	1
									FROM	#tmp_MST_ITEM_OPERATION X WITH ( NOLOCK ) 
									WHERE	A.COMPANY_ID = X.COMPANY_ID
									AND		A.DIVISION_ID = X.DIVISION_ID
									AND		A.SITE_ID = X.SITE_ID
									AND		A.PLANT_ID = X.PLANT_ID
									AND		A.OPERATION_ID = X.OPERATION_ID
									AND		X.MASTER_ID = @p_master_id
									AND		X.PLAN_ID = @p_engine_plan_id
									AND		X.USE_SETUP ='Y'
									)
					) A
			GROUP  BY A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID, A.SETUP_TIME_UOM
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '5.02.1 END';
			SET @v_description = 'Process Complete...' + '[INSERT]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '5.03.0 START';
			SET @v_description = N'TH_MST_SETUP_CATEGORY_SN' ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			DELETE	TH_MST_SETUP_CATEGORY_SN
			WHERE	MASTER_ID = @p_master_id
			AND		PLAN_ID	= @p_engine_plan_id
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '5.03.1 END';
			SET @v_description = 'Process Complete...' + '[DELETE]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '5.04.0 START';
			SET @v_description = N'TH_MST_SETUP_CATEGORY_SN';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			INSERT INTO TH_MST_SETUP_CATEGORY_SN
			(
					MASTER_ID ,
					PLAN_ID , 
					SETUP_CATEGORY_ID , 
					SETUP_LEVEL , 
					DESCR , 
					KEY_DATE , 
					INSERT_ID , 
					INSERT_DTTM , 
					UPDATE_ID , 
					UPDATE_DTTM              
			)      
			SELECT  @p_master_id AS MASTER_ID ,
					@p_engine_plan_id AS PLAN_ID , 
					LINE_SETUP_GROUP_ID AS SETUP_CATEGORY_ID ,
					1 AS SETUP_LEVEL ,
					NULL AS DESCR ,
					@p_plan_name AS KEY_DATE ,
					'SETUP_MATRIX' AS INSERT_ID ,
					GETDATE() AS INSERT_DTTM ,
					'SETUP_MATRIX' AS UPDATE_ID ,
					GETDATE() AS UPDATE_DTTM
			FROM	(
					SELECT  LINE_SETUP_GROUP_ID
					FROM    #tmp_MST_SCM_SETUP_MATRIX A WITH ( NOLOCK ) 
					WHERE   MASTER_ID = @p_master_id
					AND		PLAN_ID	= @p_engine_plan_id
					AND	    SETUP_TIME > 0
					GROUP   BY LINE_SETUP_GROUP_ID
					UNION   ALL
					SELECT  LINE_SETUP_GROUP_ID
					FROM    SCM_SETUP_MATRIX_M_SN A WITH ( NOLOCK ) 
					WHERE   A.SETUP_TIME > 0
					AND     A.FROM_ITEM_SETUP_GROUP_ID = 'ALL'
					AND     A.TO_ITEM_SETUP_GROUP_ID = 'ALL'
					AND     EXISTS (
									SELECT	1
									FROM	#tmp_MST_ITEM_OPERATION X WITH ( NOLOCK ) 
									WHERE	A.COMPANY_ID = X.COMPANY_ID
									AND		A.DIVISION_ID = X.DIVISION_ID
									AND		A.SITE_ID = X.SITE_ID
									AND		A.PLANT_ID = X.PLANT_ID
									AND		A.OPERATION_ID = X.OPERATION_ID
									AND		X.MASTER_ID = @p_master_id
									AND		X.PLAN_ID = @p_engine_plan_id
									AND		X.USE_SETUP ='Y')
					) A
			GROUP  BY  LINE_SETUP_GROUP_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '5.04.1 END';
			SET @v_description = 'Process Complete...' + '[INSERT]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		   /*************************************************************************
			ENGINE DATA  구성
			--> 1. TH_ENG_ITEM_SN
				-  SETUP_GROUP_ID = NULL
				2. TH_ENG_ITEM_ROUTE_SITE_SN 
				-  ATTR05 = SETUP_GROUP_ID
				3. TH_ENG_RESOURCE_SN 
				-  RESOURCE_SETUP_GROUP_ID = LINE_SETUP_GROUP_ID
				4. TH_ENG_BUCKET_RES_CAPA
				-  CAPA 설정
			**************************************************************************/	

			SET @v_log_type = 'TXN';
			SET @v_log_message = '6.01.0 START';
			SET @v_description = N'TH_ENG_ITEM_SN';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			UPDATE TH_ENG_ITEM_SN
			SET    SETUP_GROUP_ID = NULL
			WHERE  MASTER_ID = @p_master_id
			AND    PLAN_ID = @p_engine_plan_id 
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '6.01.1 END';
			SET @v_description = 'Process Complete...' + '[UPDATE] - SETUP_GROUP_ID' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '6.02.0 START';
			SET @v_description = N'TH_ENG_ITEM_ROUTE_SITE_SN';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			UPDATE  A
			SET		A.ATTR05 = B.SETUP_GROUP_ID
			FROM	TH_ENG_ITEM_ROUTE_SITE_SN A WITH ( NOLOCK ) ,
					(
					 SELECT MASTER_ID , PLAN_ID , PLANT_ID + '-'+  LEFT( OPERATION_ID , 1) +'~***' SITE_ID, ITEM_ID , SETUP_GROUP_ID
					 FROM	#tmp_MST_SCM_SETUP_ITEM WITH ( NOLOCK )  
					 WHERE	MASTER_ID = @p_master_id
					 AND	PLAN_ID = @p_engine_plan_id
					 GROUP BY MASTER_ID , PLAN_ID , PLANT_ID + '-'+  LEFT( OPERATION_ID , 1) +'~***' , ITEM_ID , SETUP_GROUP_ID
					) B
			WHERE	A.MASTER_ID = @p_master_id
			AND		A.PLAN_ID = @p_engine_plan_id 
			AND		A.MASTER_ID = B.MASTER_ID
			AND		A.PLAN_ID = B.PLAN_ID
			AND		A.ITEM_ID = B.ITEM_ID    
			AND		A.SITE_ID = B.SITE_ID
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '6.02.1 END';
			SET @v_description = 'Process Complete...' + '[UPDATE] - ATTR05' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '6.03.0 START';
			SET @v_description = N'TH_ENG_RESOURCE_SN';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			UPDATE	A
			SET		A.RESOURCE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
			FROM	TH_ENG_RESOURCE_SN A WITH ( NOLOCK ) ,
					( 
					SELECT	*
					FROM	#tmp_MST_ITEM_LINE WITH ( NOLOCK )
					WHERE	MASTER_ID = @p_master_id
					AND		PLAN_ID = @p_engine_plan_id
					AND		LINE_SETUP_GROUP_ID !='-'
					) B
			WHERE	A.MASTER_ID = @p_master_id
			AND		A.PLAN_ID = @p_engine_plan_id 
			AND		A.MASTER_ID = B.MASTER_ID
			AND		A.PLAN_ID = B.PLAN_ID
			AND		A.RESOURCE_ID = B.RESOURCE_ID    	
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '6.03.1 END';
			SET @v_description = 'Process Complete...' + '[UPDATE] - RESOURCE_SETUP_GROUP_ID' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			/*

			BUCKET CAPA 는 INBOUND 생성시에 조정.


			SET @v_log_type = 'TXN';
			SET @v_log_message = '6.04.0 START';
			SET @v_description = N'TH_ENG_BUCKET_RES_CAPA_SN';
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			UPDATE	A
			SET		A.WORK_TIME = B.WORK_TIME , A.WORK_TIME_UOM = B.WORK_TIME_UOM
			FROM	(
					SELECT	OPERATION_ID + '::' + PLANT_SITE_ID + '~***' + '::' + LINE_ID  RESOURCE_ID ,
							CONVERT (DATETIME, YYYYMMDD)  START_DTTM ,  
							DATEADD( DAY , 1 , CONVERT (DATETIME, YYYYMMDD) )  END_DTTM ,  
							WORKING_TIME  WORK_TIME, 
							'MINUTE' WORK_TIME_UOM , 
							WORKING_TIME / 1440.0 AS WORKING_TIME_RATE
					FROM	SCP_MST_WORKING_TIME WITH (NOLOCK)
					WHERE   OPERATION_ID ='E2000'
					AND		YYYYMMDD >=  @p_plan_name AND YYYYMMDD <= CONVERT(CHAR(8),  DATEADD( DAY , 364 , CONVERT (DATE, @p_plan_name) ) , 112)
					) B INNER JOIN TH_ENG_BUCKET_RES_CAPA_SN A WITH ( NOLOCK )   ON  A.RESOURCE_ID = B.RESOURCE_ID AND A.START_DTTM = B.START_DTTM
			WHERE	A.MASTER_ID = @p_master_id
			AND		A.PLAN_ID = @p_engine_plan_id
			AND		A.RESOURCE_ID IN 
									(
									SELECT  A.RESOURCE_ID
									FROM	TH_ENG_RESOURCE_SN A WITH (NOLOCK ) 
									WHERE	A.MASTER_ID = @p_master_id
									AND		A.PLAN_ID = @p_engine_plan_id
									AND		A.ROUTE_ID LIKE 'E%'
									AND		A.RESOURCE_SETUP_GROUP_ID IS NOT NULL
									)
			;

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '6.04.1 END';
			SET @v_description = 'Process Complete...' + '[UPDATE]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			*/

			------------------------------------------------------------
			--1. TH_ENG_SETUP_MATRIX_SN 데이터
			------------------------------------------------------------
			SET @v_log_type = 'TXN';
			SET @v_log_message = '7.01.0 START';
			SET @v_description = N'TH_ENG_SETUP_MATRIX_SN'  ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			DELETE	A
			FROM    TH_ENG_SETUP_MATRIX_SN A
			WHERE	A.MASTER_ID = @p_master_id 
			AND		A.PLAN_ID   = @p_engine_plan_id 
			;		

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '7.01.1 END';
			SET @v_description = 'Process Complete...' + '[DELETE]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			SET @v_log_type = 'TXN';
			SET @v_log_message = '7.02.0 START';
			SET @v_description = N'TH_ENG_SETUP_MATRIX_SN'  ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			INSERT INTO TH_ENG_SETUP_MATRIX_SN
			(
					MASTER_ID , 
					PLAN_ID , 
					RESOURCE_SETUP_GROUP_ID , 
					FROM_SETUP_GROUP_ID , 
					TO_SETUP_GROUP_ID , 
					SETUP_TIME , 
					SETUP_TIME_UOM , 
					FIRST_SETUP_TIME ,
					FIRST_SETUP_TIME_UOM  ,
					DESCR
					)
			SELECT  MASTER_ID , 
					PLAN_ID , 
					RESOURCE_SETUP_GROUP_ID , 
					FROM_SETUP_ID , 
					TO_SETUP_ID , 
					SETUP_TIME , 
					SETUP_TIME_UOM , 
					FIRST_SETUP_TIME ,
					SETUP_TIME_UOM  ,
					DESCR
			FROM	TH_MST_SETUP_TIME_SN
			WHERE	MASTER_ID = @p_master_id
			AND		PLAN_ID = @p_engine_plan_id
			;		

			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '7.02.1 END';
			SET @v_description = 'Process Complete...' + '[INSERT]' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = 'TXN';
			SET @v_log_message = '8.01.0 START';
			SET @v_description = N'tmp_XX~'  ;
			SET @d_event_date = SYSDATETIME();
			SET @n_log_count  = 0 ;
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;			

				IF OBJECT_ID('tempdb..#tmp_MST_DEMAND_PLAN_BOM') IS NOT NULL                        
					DROP TABLE #tmp_MST_DEMAND_PLAN_BOM         

				IF OBJECT_ID('tempdb..#tmp_MST_ITEM_OPERATION') IS NOT NULL                        
					DROP TABLE #tmp_MST_ITEM_OPERATION         

				IF OBJECT_ID('tempdb..#tmp_MST_ITEM_LINE') IS NOT NULL                        
					DROP TABLE #tmp_MST_ITEM_LINE

				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_BOM') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_BOM         

				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_ITEM_LIST') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_ITEM_LIST         

				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_ITEM_COMBINE') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_ITEM_COMBINE         

				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_ITEM') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_ITEM

				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_MATRIX_01') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_MATRIX_01

				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_MATRIX_02') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_MATRIX_02

				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_MATRIX_03') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_MATRIX_03

				IF OBJECT_ID('tempdb..#tmp_MST_SCM_SETUP_MATRIX') IS NOT NULL                        
					DROP TABLE #tmp_MST_SCM_SETUP_MATRIX

			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = '8.01.1 END';
			SET @v_description = 'Process Complete...' + '[DROP] - CLEAR TMP TABLE' ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		
			IF @@TRANCOUNT > 0
				BEGIN
				COMMIT WORK;
				END

		END

    END TRY

	BEGIN CATCH
		-- ROLLBACK
		-- ERROR LOG
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()) + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		return -1
	END CATCH

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;;
    SET @d_event_date = SYSDATETIME();
	SET @n_log_count  = 0 ;

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    return 1

END
