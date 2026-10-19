
/*
 * Program ID   : PR_DM_PLN_BIZPLAN_TO_NET_DEMAND
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023-08-26 사업계획 프로젝트
*/

--EXEC PR_DM_PLN_BIZPLAN_TO_NET_DEMAND '81', 'BP_M_20230826_V001'

CREATE PROCEDURE [dbo].[PR_DM_PLN_BIZPLAN_TO_NET_DEMAND]

	-- Add the parameters for the stored procedure here
	 @p_division_id        NVARCHAR(30)   -- ex) 40 한개씩 입력받음
	 ,@p_version_no         NVARCHAR(30)   -- ex) 40 한개씩 입력받음

AS

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_BIZPLAN_TO_NET_DEMAND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 마지막 데이터 처리를 위한 구분자 추가
	--SET @p_DIVISION_ID      = RTRIM(@p_DIVISION_ID) + '^';

	-- 스플릿관련 변수
    DECLARE  @i_DIVISION_ID        NVARCHAR(30);
    DECLARE  @index_DIVISION_ID    INT;

	-- @input_division TEMP TABLE
	DECLARE @input_division TABLE (i_DIVISION_ID  NVARCHAR(30));

	-- 계산용 변수
    DECLARE @match_rows        INTEGER = 0;
    DECLARE @max_rows          INTEGER = 0;
    DECLARE @demand_sort_rows  INTEGER = 0;
    DECLARE @demand_sort_max   INTEGER = 0;
    DECLARE @demand_min_yyyymmdd   NVARCHAR(08); -- 20181112 KHSONG 최소날짜를 저장
    DECLARE @priority_count    INTEGER = 0;
    DECLARE @ESS_count         INTEGER = 1001;  -- 20190830 KHSONG ESS용 COUNT 변수 추가
    DECLARE @CF_count          INTEGER = 1001;
    DECLARE @UF_count          INTEGER = 2001;
    DECLARE @NF_count          INTEGER = 3001;
    DECLARE @INST_count        INTEGER = 0;
    DECLARE @DEMAND_TYPE       NVARCHAR(50);
    DECLARE @DEMAND_TYPE2      NVARCHAR(50);
    DECLARE @DEMAND_FLAG       NVARCHAR(50);
	SET     @DEMAND_FLAG = 'CF'  -- CF로 시작(변경금지)
    DECLARE @MONTH_FLAG        INTEGER = 0;
    DECLARE @FL_PLANT_SITE_ID   NVARCHAR(30);
    DECLARE @FL_DEMAND_TYPE     NVARCHAR(50);
    DECLARE @FL_YYYYMMDD    NVARCHAR(8);
    DECLARE @input_VERSION1     NVARCHAR(50);
    DECLARE @input_VERSION2     NVARCHAR(50);
    DECLARE @Previous_week_count        INTEGER = 0;

	DECLARE @calc_CF   		   NUMERIC(20,10);
	DECLARE @calc_UF   	   	   NUMERIC(20,10);
	DECLARE @calc_NF   		   NUMERIC(20,10);
	DECLARE @insert_calc	   NUMERIC(20,10);
	DECLARE @insert_calc2	   NUMERIC(20,10);

    DECLARE @MAX_PLAN_ID      NVARCHAR(30);
    DECLARE @yyyymmdd	      NVARCHAR(08);

	-------------------------------------------------------- 수정가능 변수값
	SET @yyyymmdd	 = CONVERT(CHAR(8), DATEADD(DD, -7*1, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
	SET @MONTH_FLAG  = '6'   -- 개월단위로 입력. 향후 6개월치로 일단 설정함
	-------------------------------------------------------- 

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '@p_division_id : ' + @p_division_id + ' / ' + N'전주CUTOFF VERSION : ' + ISNULL(@input_VERSION1,'NULL') + ' / ' + N'당주CUTOFF VERSION : ' + ISNULL(@input_VERSION2,'NULL') + ' / ' + '@MAX_PLAN_ID : ' + ISNULL(@MAX_PLAN_ID,'NULL');
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	BEGIN TRANSACTION PLN_MKT_FCST_TO_NET_DEMAND;

	--------------------------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇◇◇◇◇◇◇◇
	--                                                                                                      전주, 당주 CUTOFF VERSION, PLAN_ID 값 Validation (start)
	--------------------------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇◇◇◇◇◇◇◇
	BEGIN
		SELECT @MAX_PLAN_ID = MAX(PLAN_ID) FROM SCP_ANL_BUSINESS_PLAN_INFO WHERE DIVISION_ID = @p_division_id
	END
	--------------------------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇◇◇◇◇◇◇◇
	--                                                                                                      전주, 당주 CUTOFF VERSION, PLAN_ID 값 Validation (end)
	--------------------------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇◇◇◇◇◇◇◇

	-------------------------------------------------------------------------------------------- SESSION TEMP TABLE CREATE
		IF  OBJECT_ID(N'tempdb..#TEMP1_DM_PLN_NET_DEMAND_BP$', N'U') IS NOT NULL 
				DROP TABLE #TEMP1_DM_PLN_NET_DEMAND_BP$ ;
		IF  OBJECT_ID(N'tempdb..#TEMP2_DM_PLN_NET_DEMAND_BP$', N'U') IS NOT NULL 
				DROP TABLE #TEMP2_DM_PLN_NET_DEMAND_BP$ ;
		IF  OBJECT_ID(N'tempdb..#TEMP3_DM_PLN_NET_DEMAND_BP$', N'U') IS NOT NULL 
				DROP TABLE #TEMP3_DM_PLN_NET_DEMAND_BP$ ;

		IF  OBJECT_ID(N'dbo.#TEMP1_DM_PLN_NET_DEMAND_BP$', N'U') IS NOT NULL 
				DROP TABLE #TEMP1_DM_PLN_NET_DEMAND_BP$ ;
		IF  OBJECT_ID(N'dbo.#TEMP2_DM_PLN_NET_DEMAND_BP$', N'U') IS NOT NULL 
				DROP TABLE #TEMP2_DM_PLN_NET_DEMAND_BP$ ;
		IF  OBJECT_ID(N'dbo.#TEMP3_DM_PLN_NET_DEMAND_BP$', N'U') IS NOT NULL 
				DROP TABLE #TEMP3_DM_PLN_NET_DEMAND_BP$ ;

	-------------------------------------------------------------------------------------------- TEMP1 TABLE CREATE

		CREATE TABLE #ROW_TABLE  ( 
					 DIVISION_ID          NVARCHAR(30)
					,VERSION_NO           NVARCHAR(50)
					,CUTOFF_YYYYMMDD      NVARCHAR(8)
					,PROJECT_CODE         NVARCHAR(50)
					,SCM_SITE_ID          NVARCHAR(30)
					,ITEM_ID              NVARCHAR(50)
					,DOM_EXP              NVARCHAR(3)
					,FCST_TYPE            NVARCHAR(20)
					,INCOTERMS            NVARCHAR(10)
					,PLANT_SITE_ID        NVARCHAR(30)
					,YYYYMMDD             NVARCHAR(10)
					,QTY                  NUMERIC(20, 10)
					,ROW_COUNT            NUMERIC(20)
							)
		CREATE CLUSTERED INDEX [IDX_ROW_TABLE] ON [#ROW_TABLE]
		(
			 DIVISION_ID       ASC
			,VERSION_NO        ASC
			,CUTOFF_YYYYMMDD   ASC
			,PROJECT_CODE      ASC
			,SCM_SITE_ID       ASC
			,ITEM_ID           ASC
			,DOM_EXP           ASC
			,FCST_TYPE         ASC
			,INCOTERMS         ASC
			,PLANT_SITE_ID     ASC
			,YYYYMMDD          ASC
		)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		;

		CREATE TABLE #TEMP1_DM_PLN_NET_DEMAND_BP$ (
						         DIVISION_ID        NVARCHAR(30)
								,VERSION_NO         NVARCHAR(50)
								,CUTOFF_TYPE        NVARCHAR(50)
								,CUTOFF_YYYYMMDD    NVARCHAR(8)
								,PROJECT_CODE       NVARCHAR(50)
								,SCM_SITE_ID        NVARCHAR(30)
								,ITEM_ID            NVARCHAR(50)
								,DOM_EXP            NVARCHAR(3)
								,FCST_TYPE          NVARCHAR(20)
								,INCOTERMS          NVARCHAR(10)
								,PLANT_SITE_ID      NVARCHAR(30)
								--,MEASURE            NVARCHAR(50)
								,YYYYMM             NVARCHAR(10)
								,BATCH_RESULT       NVARCHAR(50)
								,QTY                NUMERIC(20,10)
								,RTF                NUMERIC(20,10)
								,MKT_FCST           NUMERIC(20,10)
								,CF                 NUMERIC(20,10)
								,UF                 NUMERIC(20,10)
								,NF                 NUMERIC(20,10)
						          )
		CREATE CLUSTERED INDEX [IDX_TEMP1_DM_PLN_NET_DEMAND_BP] ON [#TEMP1_DM_PLN_NET_DEMAND_BP$]
		(
			 DIVISION_ID       ASC
			,VERSION_NO        ASC
			,CUTOFF_TYPE       ASC
			,CUTOFF_YYYYMMDD   ASC
			,PROJECT_CODE      ASC
			,SCM_SITE_ID       ASC
			,ITEM_ID           ASC
			,DOM_EXP           ASC
			,FCST_TYPE         ASC
			,INCOTERMS         ASC
			,PLANT_SITE_ID     ASC
		--	,MEASURE           ASC
			,YYYYMM            ASC
			,BATCH_RESULT      ASC
		)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		;

			DECLARE @v_DIVISION_ID         NVARCHAR(MAX);
			DECLARE @v_VERSION_NO          NVARCHAR(MAX);
			DECLARE @v_CUTOFF_TYPE         NVARCHAR(MAX);
			DECLARE @v_CUTOFF_YYYYMMDD     NVARCHAR(MAX);
			DECLARE @v_PROJECT_CODE        NVARCHAR(MAX);
			DECLARE @v_SCM_SITE_ID         NVARCHAR(MAX);
			DECLARE @v_ITEM_ID             NVARCHAR(MAX);
			DECLARE @v_DOM_EXP             NVARCHAR(MAX);
			DECLARE @v_FCST_TYPE           NVARCHAR(MAX);
			DECLARE @v_INCOTERMS           NVARCHAR(MAX);
			DECLARE @v_PLANT_SITE_ID       NVARCHAR(MAX);
			DECLARE @v_MEASURE             NVARCHAR(MAX);
			DECLARE @v_YYYYMM              NVARCHAR(MAX);
			DECLARE @v_BATCH_RESULT        NVARCHAR(MAX);
			DECLARE @v_QTY                 NUMERIC(20,10);
			DECLARE @v_RTF                 NUMERIC(20,10);
			DECLARE @v_MKT_FCST            NUMERIC(20,10);
			DECLARE @v_CF                  NUMERIC(20,10);
			DECLARE @v_UF                  NUMERIC(20,10);
			DECLARE @v_NF                  NUMERIC(20,10);

	-------------------------------------------------------------------------------------------- TEMP2 TABLE CREATE
		CREATE TABLE #TEMP2_DM_PLN_NET_DEMAND_BP$ (
					 DIVISION_ID          NVARCHAR(30)
					,VERSION_NO           NVARCHAR(50)   
					,CUTOFF_TYPE          NVARCHAR(50)   
					,CUTOFF_YYYYMMDD      NVARCHAR(8)
					,PROJECT_CODE         NVARCHAR(50)
					,SCM_SITE_ID          NVARCHAR(30)
					,ITEM_ID              NVARCHAR(50)
					,DOM_EXP              NVARCHAR(3)
					,FCST_TYPE            NVARCHAR(20)
					,INCOTERMS            NVARCHAR(10)
					,PLANT_SITE_ID        NVARCHAR(30)
				--	,MEASURE              NVARCHAR(50)
					,YYYYMMDD             NVARCHAR(10)
					,QTY                  NUMERIC(20, 10)
					)
		CREATE CLUSTERED INDEX [IDX_TEMP2_DM_PLN_NET_DEMAND_BP] ON [#TEMP2_DM_PLN_NET_DEMAND_BP$]
		(
			 DIVISION_ID       ASC
			,VERSION_NO        ASC
			,CUTOFF_TYPE       ASC
			,CUTOFF_YYYYMMDD   ASC
			,PROJECT_CODE      ASC
			,SCM_SITE_ID       ASC
			,ITEM_ID           ASC
			,DOM_EXP           ASC
			,FCST_TYPE         ASC
			,INCOTERMS         ASC
			,PLANT_SITE_ID     ASC
		--	,MEASURE           ASC
			,YYYYMMDD          ASC
		)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		;
			DECLARE @n_DIVISION_ID         NVARCHAR(MAX);
			DECLARE @n_VERSION_NO          NVARCHAR(MAX);
			DECLARE @n_CUTOFF_TYPE         NVARCHAR(MAX);
			DECLARE @n_CUTOFF_YYYYMMDD     NVARCHAR(MAX);
			DECLARE @n_PROJECT_CODE        NVARCHAR(MAX);
			DECLARE @n_SCM_SITE_ID         NVARCHAR(MAX);
			DECLARE @n_ITEM_ID             NVARCHAR(MAX);
			DECLARE @n_DOM_EXP             NVARCHAR(MAX);
			DECLARE @n_FCST_TYPE           NVARCHAR(MAX);
			DECLARE @n_INCOTERMS           NVARCHAR(MAX);
			DECLARE @n_MEASURE             NVARCHAR(MAX);
			DECLARE @n_PLANT_SITE_ID       NVARCHAR(MAX);
			DECLARE @n_YYYYMMDD            NVARCHAR(MAX);
			DECLARE @n_QTY                 NUMERIC(20,10);

	-------------------------------------------------------------------------------------------- TEMP3 TABLE CREATE

		CREATE TABLE #TEMP3_DM_PLN_NET_DEMAND_BP$ (
					 DIVISION_ID        nvarchar(30)   
					,VERSION_NO         nvarchar(50)   
					,CUTOFF_YYYYMMDD    nvarchar(8)    
					,PROJECT_CODE       nvarchar(50)   
					,SCM_SITE_ID        nvarchar(30)   
					,ITEM_ID            nvarchar(50)   
					,DOM_EXP            nvarchar(3)    
					,FCST_TYPE          nvarchar(20)   
					,INCOTERMS          nvarchar(10)   
					,PLANT_SITE_ID    nvarchar(30)   
					,DEMAND_TYPE        nvarchar(50)   
					,YYYYMMDD           nvarchar(8)    
					,DEMAND_PRIORITY    nvarchar(20)   
					,QTY                numeric(20, 10)
					,CREATED_BY         nvarchar(150)  
					,CREATION_DATE      datetime       
					,LAST_UPDATED_BY    nvarchar(150)  
					,LAST_UPDATE_DATE   datetime       
					,ATTRIBUTE1         nvarchar(150)  
					,ATTRIBUTE2         nvarchar(150)  
					,ATTRIBUTE3         nvarchar(150)  
					,ATTRIBUTE4         nvarchar(150)  
					,ATTRIBUTE5         nvarchar(150)  
					,ATTRIBUTE6         nvarchar(150)  
					,ATTRIBUTE7         nvarchar(150)  
					,ATTRIBUTE8         nvarchar(150)  
					,ATTRIBUTE9         nvarchar(150)  
					,ATTRIBUTE10        nvarchar(150)  
					)
		CREATE CLUSTERED INDEX [IDX_TEMP3_DM_PLN_NET_DEMAND_BP] ON [#TEMP3_DM_PLN_NET_DEMAND_BP$]
		(
			 DIVISION_ID      ASC
			,VERSION_NO       ASC
			,CUTOFF_YYYYMMDD  ASC
			,PROJECT_CODE     ASC
			,SCM_SITE_ID      ASC
			,ITEM_ID          ASC
			,DOM_EXP          ASC
			,FCST_TYPE        ASC
			,INCOTERMS        ASC
			,PLANT_SITE_ID    ASC
			,DEMAND_TYPE      ASC
			,YYYYMMDD         ASC
			,DEMAND_PRIORITY  ASC
		)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		;

			DECLARE		@x_DIVISION_ID        nvarchar(30)   ; 
			DECLARE		@x_VERSION_NO         nvarchar(50)   ;
			DECLARE		@x_CUTOFF_YYYYMMDD    nvarchar(8)    ;
			DECLARE		@x_PROJECT_CODE       nvarchar(50)   ;
			DECLARE		@x_SCM_SITE_ID        nvarchar(30)   ;
			DECLARE		@x_ITEM_ID            nvarchar(50)   ;
			DECLARE		@x_DOM_EXP            nvarchar(3)    ;
			DECLARE		@x_FCST_TYPE          nvarchar(20)   ;
			DECLARE		@x_INCOTERMS          nvarchar(10)   ;
			DECLARE		@x_PLANT_SITE_ID      nvarchar(30)   ;
			DECLARE		@x_DEMAND_TYPE        nvarchar(50)   ;
			DECLARE		@x_YYYYMMDD           nvarchar(8)    ;
			DECLARE		@x_DEMAND_PRIORITY    nvarchar(20)   ;
			DECLARE		@x_QTY                numeric(20, 10);
			DECLARE		@x_CREATED_BY         nvarchar(150)  ;
			DECLARE		@x_CREATION_DATE      datetime       ;
			DECLARE		@x_LAST_UPDATED_BY    nvarchar(150)  ;
			DECLARE		@x_LAST_UPDATE_DATE   datetime       ;
			DECLARE		@x_ATTRIBUTE1         nvarchar(150)  ;
			DECLARE		@x_ATTRIBUTE2         nvarchar(150)  ;
			DECLARE		@x_ATTRIBUTE3         nvarchar(150)  ;
			DECLARE		@x_ATTRIBUTE4         nvarchar(150)  ;
			DECLARE		@x_ATTRIBUTE5         nvarchar(150)  ;
			DECLARE		@x_ATTRIBUTE6         nvarchar(150)  ;
			DECLARE		@x_ATTRIBUTE7         nvarchar(150)  ;
			DECLARE		@x_ATTRIBUTE8         nvarchar(150)  ;
			DECLARE		@x_ATTRIBUTE9         nvarchar(150)  ;
			DECLARE		@x_ATTRIBUTE10        nvarchar(150)  ;


	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

	-------------------------------------------------------------------------------------------- 전주 마지막 WEEKLY CUTOFF 데이터 INSERT START
PRINT 'EXEC_001                                       =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108);
	
	
	BEGIN

		   WITH ALL_DATA AS (
		   SELECT    A.DIVISION_ID
					,VERSION_NO
					,CUTOFF_TYPE
					,CUTOFF_YYYYMMDD
					,A.PROJECT_CODE
					,A.SCM_SITE_ID
					,A.ITEM_ID
					,DOM_EXP
					,FCST_TYPE
					,INCOTERMS
					,CASE WHEN A.DIVISION_ID in ('82','40') THEN '' ELSE PLANT_SITE_ID END PLANT_SITE_ID -- 20180721
					,MEASURE
					,YYYYMM
					,'ING' BATCH_RESULT--BATCH_RESULT
					,SUM(QTY) QTY
					, 0 RTF -- RTF
					, 0 MKT_FCST -- MKT_FCST
					, 0 CF -- CF
					, 0 UF -- UF
					, 0 NF -- NF
			 FROM dbo.DM_PLN_BIZPLAN_C		A		WITH(NOLOCK)
				 ,dbo.DM_MST_ITEM_SINGLE_V 	ITEM	WITH(NOLOCK)  -- 20180720
				 ,dbo.SCM_MST_SITE			ST		WITH(NOLOCK)  --20180724
				 ,dbo.SCM_MST_SITE_ITEM		STM		WITH(NOLOCK)  --20180928
			   WHERE 1=1
					AND A.DIVISION_ID		= ITEM.DIVISION_ID  -- 20180720
					AND A.DIVISION_ID		= STM.DIVISION_ID   
					AND A.PROJECT_CODE		= STM.PROJECT_CODE
					AND A.SCM_SITE_ID		= STM.SCM_SITE_ID
					AND A.ITEM_ID			= STM.ITEM_ID
					AND STM.VALID_YN		= 'Y'
					AND A.ITEM_ID			= ITEM.ITEM_ID  -- 20180720
					AND ITEM.ACTIVE_FLAG	= 'Y'  -- 20180720
					AND ST.VALID_YN         = 'Y'  --20180810
					AND A.DIVISION_ID		= ST.DIVISION_ID  --20180724
					AND A.SCM_SITE_ID		= ST.SCM_SITE_ID  --20180724
					AND MEASURE				= 'Business_Plan_Conf'
					AND A.DIVISION_ID		= @p_division_id    --input division_id
					--AND VERSION_NO			= @v_VERSION_NO  -- MAX VERSION
					and qty > 0
					AND VERSION_NO = @p_version_no
					AND ISNULL(A.ATTRIBUTE10, '') = ''
			 GROUP BY    A.DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,DOM_EXP
						,FCST_TYPE,INCOTERMS,
						CASE WHEN A.DIVISION_ID in ('82','40')  THEN '' ELSE PLANT_SITE_ID END 
						,MEASURE,YYYYMM

		  )

		  INSERT INTO #TEMP1_DM_PLN_NET_DEMAND_BP$
			SELECT 
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
					,PLANT_SITE_ID  
				--	,MEASURE        
					,YYYYMM         
					,BATCH_RESULT   
					,SUM( CASE WHEN MEASURE IN ('Business_Plan_Conf' ) THEN  QTY ELSE 0 END )
					--,SUM(RTF)     
					--,SUM(MKT_FCST)
					--,SUM(CF)
					--,SUM(UF)
					--,SUM(NF)
					,SUM( CASE WHEN MEASURE IN ('RTF') THEN  QTY ELSE 0 END ) RTF
					,SUM( CASE WHEN MEASURE IN ('Business_Plan_Conf') THEN  QTY ELSE 0 END ) BUSINESS_PLAN
					,SUM( CASE WHEN MEASURE NOT IN ('RTF') THEN  QTY ELSE 0 END ) CF
					,SUM( CASE WHEN MEASURE IN ('Business_Plan_Conf') THEN  QTY ELSE 0 END ) - SUM( CASE WHEN MEASURE NOT IN ('RTF') THEN  QTY ELSE 0 END ) UF
					,0 NF
			 FROM  ALL_DATA
			  WHERE 1=1
			  --  and MEASURE IN ('MKT_FCST','VMI_In_Req')  --20180724
				AND BATCH_RESULT = 'ING'
				and FCST_TYPE   <> 'RMA'  -- 20181107 KHSONG 소형 반품예정수량은 제외
			GROUP BY    DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP
							,FCST_TYPE,INCOTERMS
							-- ,MEASURE
							,PLANT_SITE_ID,YYYYMM,BATCH_RESULT

			

		   -- 20180629 KHSONG DUE_DATE를 FCST일자로 사용하는 로직 추가 (END)
		END
	-------------------------------------------------------------------------------------------- 전주 마지막 WEEKLY CUTOFF 데이터 INSERT END
--SELECT * FROM #TEMP1_DM_PLN_NET_DEMAND_BP$
	------------------------------------------------------------------------------------------ 당주 WEEKLY CUTOFF 데이터 INSERT START
		BEGIN

PRINT 'EXEC_002                                       =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		   INSERT INTO #TEMP2_DM_PLN_NET_DEMAND_BP$
		   SELECT    A.DIVISION_ID
					,VERSION_NO
					,CUTOFF_TYPE
					,CUTOFF_YYYYMMDD
					,A.PROJECT_CODE
					,A.SCM_SITE_ID
					,A.ITEM_ID
					,DOM_EXP
					,FCST_TYPE
					,INCOTERMS
					,CASE WHEN A.DIVISION_ID in ('82','40')  THEN '' ELSE PLANT_SITE_ID END  -- 20180721
				--	,MEASURE
					,YYYYMM
					,QTY
			 FROM dbo.DM_PLN_BIZPLAN_C		A		WITH(NOLOCK)
				 ,dbo.DM_MST_ITEM_SINGLE_V 	ITEM	WITH(NOLOCK)  -- 20180720
				 ,dbo.SCM_MST_SITE			ST		WITH(NOLOCK)  --20180724
				 ,dbo.SCM_MST_SITE_ITEM		STM		WITH(NOLOCK)  --20180928
			   WHERE 1=1
					AND A.DIVISION_ID		= STM.DIVISION_ID   
					AND A.PROJECT_CODE		= STM.PROJECT_CODE
					AND A.SCM_SITE_ID		= STM.SCM_SITE_ID
					AND A.ITEM_ID			= STM.ITEM_ID
					AND STM.VALID_YN		= 'Y'
					AND A.DIVISION_ID		= ITEM.DIVISION_ID  -- 20180720
					AND A.ITEM_ID			= ITEM.ITEM_ID  -- 20180720
					AND ITEM.ACTIVE_FLAG	= 'Y'  -- 20180720
					AND ST.VALID_YN         = 'Y'  --20180810
					AND A.DIVISION_ID		= ST.DIVISION_ID  --20180724
					AND A.SCM_SITE_ID		= ST.SCM_SITE_ID  --20180724
					AND MEASURE				= 'Business_Plan_Conf'
					AND A.DIVISION_ID		= @p_division_id   --input division_id
					AND VERSION_NO			= @p_version_no  -- MAX VERSION
					and qty > 0


		END
	
--SELECT * FROM #TEMP1_DM_PLN_NET_DEMAND_BP$
	------------------------------------------------------------------------------------------ 당주 WEEKLY CUTOFF 데이터 INSERT END

		---------------------------------------------------------------------------------------- CURSOR_1 OPEN
		BEGIN
PRINT 'EXEC_012                                       =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)

			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR1_DEMAND')
				BEGIN
					CLOSE CURSOR1_DEMAND
					DEALLOCATE CURSOR1_DEMAND
				END;
			DECLARE CURSOR1_DEMAND CURSOR FAST_FORWARD FOR
			SELECT 
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
					,PLANT_SITE_ID  
			
					,YYYYMM         
					,BATCH_RESULT   

			 FROM  #TEMP1_DM_PLN_NET_DEMAND_BP$ 
			  WHERE 1=1
				AND BATCH_RESULT = 'ING'
			ORDER BY DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP
							,FCST_TYPE,INCOTERMS
							--,MEASURE
							,PLANT_SITE_ID,YYYYMM,BATCH_RESULT
		END
		---------------------------------------------------------------------------------------- CURSOR_1 END

		BEGIN
PRINT 'EXEC_022                                       =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			OPEN CURSOR1_DEMAND;
			FETCH NEXT FROM CURSOR1_DEMAND INTO 
									  @v_DIVISION_ID    
									 ,@v_VERSION_NO     
									 ,@v_CUTOFF_TYPE    
									 ,@v_CUTOFF_YYYYMMDD
									 ,@v_PROJECT_CODE   
									 ,@v_SCM_SITE_ID    
									 ,@v_ITEM_ID        
									 ,@v_DOM_EXP        
									 ,@v_FCST_TYPE      
									 ,@v_INCOTERMS      
									 ,@v_PLANT_SITE_ID  
									 ,@v_YYYYMM         
									 ,@v_BATCH_RESULT   

		END

PRINT 'EXEC_003                                       =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		---------------------------------------------------------------------------------------- WHILE_1 LOOP START
		WHILE @@FETCH_STATUS = 0   
		----------------------------------------------------------------------------------------
        BEGIN

		DECLARE @RTF_VALUE  NUMERIC(30,10);

		----------------------------------------------------- 계산용 변수값 저장
		set @v_CF = 0
		set @v_UF = 0
		set @v_NF = 0

		SELECT @calc_CF = SUM(CF)
		     , @calc_UF = SUM(UF)
		     , @calc_NF = SUM(NF)
			 FROM #TEMP1_DM_PLN_NET_DEMAND_BP$ 
			WHERE 1=1
				 AND  DIVISION_ID      =  @v_DIVISION_ID    
				 AND  VERSION_NO       =  @v_VERSION_NO     
				 AND  CUTOFF_TYPE      =  @v_CUTOFF_TYPE    
				 AND  CUTOFF_YYYYMMDD  =  @v_CUTOFF_YYYYMMDD
				 AND  PROJECT_CODE     =  @v_PROJECT_CODE   
				 AND  SCM_SITE_ID      =  @v_SCM_SITE_ID    
				 AND  ITEM_ID          =  @v_ITEM_ID        
				 AND  DOM_EXP          =  @v_DOM_EXP        
				 AND  FCST_TYPE        =  @v_FCST_TYPE      
				 AND  INCOTERMS        =  @v_INCOTERMS      
				 AND  PLANT_SITE_ID    =  @v_PLANT_SITE_ID  
				 AND  YYYYMM           =  @v_YYYYMM
				 GROUP BY  DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID,YYYYMM

		----------------------------------------------------- 당주의 해당월 mkt_fcst 수량파악
		TRUNCATE TABLE #ROW_TABLE

--SELECT * FROM #TEMP2_DM_PLN_NET_DEMAND_BP$

		INSERT INTO #ROW_TABLE
		SELECT 
				a.DIVISION_ID,a.VERSION_NO,a.CUTOFF_YYYYMMDD,a.PROJECT_CODE,a.SCM_SITE_ID,a.ITEM_ID,a.DOM_EXP,a.FCST_TYPE,a.INCOTERMS,a.PLANT_SITE_ID
			   ,a.YYYYMMDD,a.QTY as qty,row_number() OVER (ORDER BY a.DIVISION_ID) as row_count
			FROM #TEMP2_DM_PLN_NET_DEMAND_BP$ a
			where 1=1
			and  a.DIVISION_ID     = @v_DIVISION_ID
			and  a.PROJECT_CODE    = @v_PROJECT_CODE
			and  a.SCM_SITE_ID     = @v_SCM_SITE_ID 
			and  a.ITEM_ID         = @v_ITEM_ID   
			and  a.DOM_EXP         = @v_DOM_EXP  
			and  a.FCST_TYPE       = @v_FCST_TYPE 
			and  a.INCOTERMS       = @v_INCOTERMS 
			and  a.PLANT_SITE_ID   = @v_PLANT_SITE_ID
			and  substring(a.YYYYMMDD,1,6) = @v_YYYYMM 
			--order by 
			--a.DIVISION_ID,a.PROJECT_CODE,a.SCM_SITE_ID,a.ITEM_ID,a.DOM_EXP,a.FCST_TYPE,a.INCOTERMS,a.PLANT_SITE_ID,a.YYYYMMDD

			--  20180403 전주와 당주가 일치하는 데이터 입력한후 대상만 삭제 (START)
			DELETE FROM #TEMP2_DM_PLN_NET_DEMAND_BP$ 
			where 1=1
			and  #TEMP2_DM_PLN_NET_DEMAND_BP$.DIVISION_ID     = @v_DIVISION_ID
			and  #TEMP2_DM_PLN_NET_DEMAND_BP$.PROJECT_CODE    = @v_PROJECT_CODE
			and  #TEMP2_DM_PLN_NET_DEMAND_BP$.SCM_SITE_ID     = @v_SCM_SITE_ID 
			and  #TEMP2_DM_PLN_NET_DEMAND_BP$.ITEM_ID         = @v_ITEM_ID   
			and  #TEMP2_DM_PLN_NET_DEMAND_BP$.DOM_EXP         = @v_DOM_EXP  
			and  #TEMP2_DM_PLN_NET_DEMAND_BP$.FCST_TYPE       = @v_FCST_TYPE 
			and  #TEMP2_DM_PLN_NET_DEMAND_BP$.INCOTERMS       = @v_INCOTERMS 
			and  #TEMP2_DM_PLN_NET_DEMAND_BP$.PLANT_SITE_ID   = @v_PLANT_SITE_ID
			and  substring(#TEMP2_DM_PLN_NET_DEMAND_BP$.YYYYMMDD,1,6) = @v_YYYYMM 
			--  20180403 전주와 당주가 일치하는 데이터 입력한후 대상만 삭제 (END)

					---------------------------------------------------------------------------------------- CURSOR_2 OPEN
					BEGIN
						set @match_rows = 1   -- row count 초기화

						IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR2_DEMAND')
							BEGIN
								CLOSE CURSOR2_DEMAND
								DEALLOCATE CURSOR2_DEMAND
							END;

						DECLARE CURSOR2_DEMAND CURSOR FAST_FORWARD FOR
						SELECT 
							a.DIVISION_ID,a.VERSION_NO,a.CUTOFF_YYYYMMDD,a.PROJECT_CODE,a.SCM_SITE_ID,a.ITEM_ID,a.DOM_EXP,a.FCST_TYPE,a.INCOTERMS,a.PLANT_SITE_ID,a.YYYYMMDD,a.QTY
						FROM #ROW_TABLE a

						SET @max_rows = ISNULL((SELECT MAX(ROW_COUNT) FROM #ROW_TABLE),0)
					END


					BEGIN
						OPEN CURSOR2_DEMAND;
						FETCH NEXT FROM CURSOR2_DEMAND INTO 
												  @n_DIVISION_ID    
												 ,@n_VERSION_NO
												 ,@n_CUTOFF_YYYYMMDD
												 ,@n_PROJECT_CODE   
												 ,@n_SCM_SITE_ID    
												 ,@n_ITEM_ID        
												 ,@n_DOM_EXP        
												 ,@n_FCST_TYPE      
												 ,@n_INCOTERMS      
												 ,@n_PLANT_SITE_ID  
												 ,@n_YYYYMMDD       
												 ,@n_QTY
					END

					---------------------------------------------------------------------------------------- WHILE_2 LOOP START
					WHILE      @match_rows <= @max_rows  
					      AND  SUBSTRING(@n_YYYYMMDD,1,6) = @v_YYYYMM
					----------------------------------------------------------------------------------------
					BEGIN

						BEGIN
							SET @DEMAND_TYPE  = ''
							SET @DEMAND_TYPE2 = null

							IF  @calc_CF > 0
							  BEGIN
							    SET @DEMAND_FLAG = 'CF'
							  END
							  ELSE
							    IF @calc_UF > 0
							      BEGIN
								    SET @DEMAND_FLAG = 'UF'
								  END
							    ELSE
								  IF @calc_NF > 0
								    BEGIN
								      SET @DEMAND_FLAG = 'NF'
									END
								  ELSE
									  IF @n_QTY > 0  -- 전주에 fsct가 없다가 당주에 발생건에 대하여 NF로 처리함
									    BEGIN
										  SET @DEMAND_FLAG = 'NF'
										  set @calc_NF = @n_QTY
									    END

						END

						--------------------------------------- CF ROWS INSERT START
						IF @DEMAND_FLAG = 'CF'  AND @calc_CF > 0
						  BEGIN

							  IF  @calc_CF < @n_QTY
							    BEGIN
									  SET @insert_calc = @calc_CF                    -- 하나의 QTY값이 CF로 나뉘어진값
									  SET @DEMAND_TYPE = 'CF'                        -- 나눠진 값을 CF로 INSERT 하기위한 FLAG
									  SET @insert_calc2 = @n_QTY - @calc_CF          -- 하나의 QTY값이 UF로 나뉘어진값
									  
									  -- CF값을 모두 사용하고 나머지값은 NF로 설정해야 하는 판단
									  IF  @calc_UF > 0 AND @calc_UF >= @insert_calc2
										  BEGIN
											  SET @DEMAND_TYPE2 = 'UF'
										  END
									  ELSE
										  BEGIN
											  SET @DEMAND_TYPE2 = 'NF'
										  END
								  SET @n_QTY = 0
								END
							  ELSE
							    BEGIN
								  SET @DEMAND_TYPE = 'CF'
								  SET @insert_calc = @n_QTY
								  SET @n_QTY = 0
								END

								IF @DEMAND_TYPE = 'CF'
									BEGIN
									  SET @priority_count = @priority_count + 1    -- DEMAND_PRIORITY COUNT 증가
										  INSERT INTO #TEMP3_DM_PLN_NET_DEMAND_BP$
											 (DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
											, PLANT_SITE_ID, DEMAND_TYPE, YYYYMMDD, DEMAND_PRIORITY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
											, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
										  VALUES ( @n_DIVISION_ID, @n_VERSION_NO, @n_CUTOFF_YYYYMMDD, @n_PROJECT_CODE, @n_SCM_SITE_ID, @n_ITEM_ID,@n_DOM_EXP, @n_FCST_TYPE, @n_INCOTERMS, @n_PLANT_SITE_ID 
												  ,@DEMAND_TYPE /*DEMAND_TYPE*/ ,@n_YYYYMMDD,@priority_count /*DEMAND_PRIORITY*/,@insert_calc,'dm_batch' /*CREATED_BY*/,getdate(),'dm_batch',getdate()
												  ,null,null,null,null,null,null,null,null,null,null)
									SET @DEMAND_TYPE  = ''
									SET @calc_CF = @calc_CF - @insert_calc  -- 20180629 SKH ADD
									END

								IF @DEMAND_TYPE2 = 'UF'
									BEGIN
										SET @priority_count = @priority_count + 1      -- DEMAND_PRIORITY COUNT 증가
	
										-- 하나의 QTY값이 UF로 나뉘어진 값 INSERT
										INSERT INTO #TEMP3_DM_PLN_NET_DEMAND_BP$
											(DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
										, PLANT_SITE_ID, DEMAND_TYPE, YYYYMMDD, DEMAND_PRIORITY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
										, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
										VALUES ( @n_DIVISION_ID, @n_VERSION_NO, @n_CUTOFF_YYYYMMDD, @n_PROJECT_CODE, @n_SCM_SITE_ID, @n_ITEM_ID,@n_DOM_EXP, @n_FCST_TYPE, @n_INCOTERMS, @n_PLANT_SITE_ID 
												,@DEMAND_TYPE2 /*DEMAND_TYPE*/ ,@n_YYYYMMDD,@priority_count /*DEMAND_PRIORITY*/,@insert_calc2,'dm_batch' /*CREATED_BY*/,getdate(),'dm_batch',getdate()
												,null,null,null,null,null,null,null,null,null,null)
									SET @calc_UF = @calc_UF - @insert_calc2  -- 20180629 SKH ADD
									END

								IF @DEMAND_TYPE2 = 'NF'
									BEGIN
										SET @priority_count = @priority_count + 1      -- DEMAND_PRIORITY COUNT 증가
	
										-- 하나의 QTY값이 NF로 나뉘어진 값 INSERT
										INSERT INTO #TEMP3_DM_PLN_NET_DEMAND_BP$
											(DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
										, PLANT_SITE_ID, DEMAND_TYPE, YYYYMMDD, DEMAND_PRIORITY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
										, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
										VALUES ( @n_DIVISION_ID, @n_VERSION_NO, @n_CUTOFF_YYYYMMDD, @n_PROJECT_CODE, @n_SCM_SITE_ID, @n_ITEM_ID,@n_DOM_EXP, @n_FCST_TYPE, @n_INCOTERMS, @n_PLANT_SITE_ID 
												,@DEMAND_TYPE2 /*DEMAND_TYPE*/ ,@n_YYYYMMDD,@priority_count /*DEMAND_PRIORITY*/,@insert_calc2,'dm_batch' /*CREATED_BY*/,getdate(),'dm_batch',getdate()
												,null,null,null,null,null,null,null,null,null,null)
									SET @calc_NF = @calc_NF - @insert_calc2  -- 20180629 SKH ADD
									END

							IF @calc_CF = 0 
							  BEGIN
							    SET @DEMAND_FLAG = ''
							  END

							IF @calc_CF < 0
							  BEGIN
							    SET @calc_CF = 0
							  END
						  END

						--------------------------------------- CF ROWS INSERT END
						
						--------------------------------------- UF ROWS INSERT START
						IF @DEMAND_FLAG = 'UF' AND @DEMAND_TYPE2 is null AND  @calc_UF > 0
						  BEGIN


							  IF  @calc_UF < @n_QTY
							    BEGIN
									  SET @DEMAND_TYPE2 = 'NF'                       -- 나머지값을 NF로 INSERT 하기위한 FLAG
									  SET @insert_calc = @calc_UF                    -- 하나의 QTY값이 CF로 나뉘어진값
									  SET @DEMAND_TYPE = 'UF'                        -- 나눠진 값을 UF로 INSERT 하기위한 FLAG
									  SET @insert_calc2 = @n_QTY - @calc_UF          -- 하나의 QTY값이 NF로 나뉘어진값
									  SET @calc_NF = @calc_NF - @insert_calc2  -- 하나의 QTY값이 UF,NF로 나뉘어지므로 나머지값을 NF값에서 차감 
									  SET @calc_UF = 0                               -- 초기화
									  SET @DEMAND_FLAG = 'NF'
								END
							  ELSE
							    BEGIN
								  SET @DEMAND_TYPE = 'UF'
								  SET @insert_calc = @n_QTY
								END

								IF @DEMAND_TYPE = 'UF'
									BEGIN
									  SET @priority_count = @priority_count + 1    -- DEMAND_PRIORITY COUNT 증가
										  INSERT INTO #TEMP3_DM_PLN_NET_DEMAND_BP$
											 (DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
											, PLANT_SITE_ID, DEMAND_TYPE, YYYYMMDD, DEMAND_PRIORITY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
											, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
										  VALUES ( @n_DIVISION_ID, @n_VERSION_NO, @n_CUTOFF_YYYYMMDD, @n_PROJECT_CODE, @n_SCM_SITE_ID, @n_ITEM_ID,@n_DOM_EXP, @n_FCST_TYPE, @n_INCOTERMS, @n_PLANT_SITE_ID 
												  ,@DEMAND_TYPE /*DEMAND_TYPE*/ ,@n_YYYYMMDD,@priority_count /*DEMAND_PRIORITY*/,@insert_calc,'dm_batch' /*CREATED_BY*/,getdate(),'dm_batch',getdate()
												  ,null,null,null,null,null,null,null,null,null,null)
									SET @DEMAND_TYPE  = ''
									END

								IF @DEMAND_TYPE2 = 'NF'
									BEGIN
										SET @priority_count = @priority_count + 1      -- DEMAND_PRIORITY COUNT 증가
	
										-- 하나의 QTY값이 NF로 나뉘어진 값 INSERT
										INSERT INTO #TEMP3_DM_PLN_NET_DEMAND_BP$
											(DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
										, PLANT_SITE_ID, DEMAND_TYPE, YYYYMMDD, DEMAND_PRIORITY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
										, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
										VALUES ( @n_DIVISION_ID, @n_VERSION_NO, @n_CUTOFF_YYYYMMDD, @n_PROJECT_CODE, @n_SCM_SITE_ID, @n_ITEM_ID,@n_DOM_EXP, @n_FCST_TYPE, @n_INCOTERMS, @n_PLANT_SITE_ID 
												,@DEMAND_TYPE2 /*DEMAND_TYPE*/ ,@n_YYYYMMDD,@priority_count /*DEMAND_PRIORITY*/,@insert_calc2,'dm_batch' /*CREATED_BY*/,getdate(),'dm_batch',getdate()
												,null,null,null,null,null,null,null,null,null,null)
									END
							IF @calc_UF = 0 
							  BEGIN
							    SET @DEMAND_FLAG = ''
							  END

							  SET @calc_UF = @calc_UF - @n_QTY

							IF @calc_UF < 0
							  BEGIN
							    SET @calc_UF = 0
							  END

						  END
						--------------------------------------- UF ROWS INSERT END
						 
						--------------------------------------- NF ROWS INSERT START
						IF @DEMAND_FLAG = 'NF' AND @DEMAND_TYPE2 is null AND  @calc_NF > 0
						  BEGIN
							  SET @DEMAND_TYPE = 'NF'
							  SET @insert_calc = @n_QTY

							  IF  @calc_NF < @n_QTY
							    BEGIN
									  SET @DEMAND_TYPE2 = 'NF'                       -- 나머지값을 NF로 INSERT 하기위한 FLAG
									  SET @insert_calc = @calc_UF                    -- 하나의 QTY값이 CF로 나뉘어진값
									  SET @DEMAND_TYPE = 'UF'                        -- 나눠진 값을 UF로 INSERT 하기위한 FLAG
									  SET @insert_calc2 = @n_QTY                     -- 하나의 QTY값이 NF로 나뉘어진값  --20180410 add
									  SET @calc_NF = @calc_NF - @insert_calc2        -- 하나의 QTY값이 UF,NF로 나뉘어지므로 나머지값을 NF값에서 차감 
									  SET @calc_NF = 0                               -- 초기화
								END

								IF @DEMAND_TYPE = 'NF'
									BEGIN
									  SET @priority_count = @priority_count + 1    -- DEMAND_PRIORITY COUNT 증가
										  INSERT INTO #TEMP3_DM_PLN_NET_DEMAND_BP$
											 (DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
											, PLANT_SITE_ID, DEMAND_TYPE, YYYYMMDD, DEMAND_PRIORITY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
											, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
										  VALUES ( @n_DIVISION_ID, @n_VERSION_NO, @n_CUTOFF_YYYYMMDD, @n_PROJECT_CODE, @n_SCM_SITE_ID, @n_ITEM_ID,@n_DOM_EXP, @n_FCST_TYPE, @n_INCOTERMS, @n_PLANT_SITE_ID 
												  ,@DEMAND_TYPE /*DEMAND_TYPE*/ ,@n_YYYYMMDD,@priority_count /*DEMAND_PRIORITY*/,@insert_calc,'dm_batch' /*CREATED_BY*/,getdate(),'dm_batch',getdate()
												  ,null,null,null,null,null,null,null,null,null,null)
									SET @DEMAND_TYPE  = ''
									END

								IF @DEMAND_TYPE2 = 'NF'
									BEGIN
										SET @priority_count = @priority_count + 1      -- DEMAND_PRIORITY COUNT 증가
	
										-- 하나의 QTY값이 NF로 나뉘어진 값 INSERT
										INSERT INTO #TEMP3_DM_PLN_NET_DEMAND_BP$
											(DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
										, PLANT_SITE_ID, DEMAND_TYPE, YYYYMMDD, DEMAND_PRIORITY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
										, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
										VALUES ( @n_DIVISION_ID, @n_VERSION_NO, @n_CUTOFF_YYYYMMDD, @n_PROJECT_CODE, @n_SCM_SITE_ID, @n_ITEM_ID,@n_DOM_EXP, @n_FCST_TYPE, @n_INCOTERMS, @n_PLANT_SITE_ID 
												,@DEMAND_TYPE2 /*DEMAND_TYPE*/ ,@n_YYYYMMDD,@priority_count /*DEMAND_PRIORITY*/,@insert_calc2,'dm_batch' /*CREATED_BY*/,getdate(),'dm_batch',getdate()
												,null,null,null,null,null,null,null,null,null,null)
									END
						  END
						--------------------------------------- NF ROWS INSERT END

						set @match_rows = @match_rows + 1    -- 처리후 LOOP count 증가

						-- CF값이 남아있지만 당주의 데이터가 끝난경우 나머지값을 'NF'로 생성해야함  --20180410
						IF  @max_rows < @match_rows AND  @calc_CF > 0
							BEGIN
	
							IF  @n_QTY > 0  -- 20180410 전주의 값이 있어도 당주의 값을 모두 INSERT 했으면 더이상 NF를 만들지 않음
								BEGIN
								SET @priority_count = @priority_count + 1      -- DEMAND_PRIORITY COUNT 증가
								-- 하나의 QTY값이 NF로 나뉘어진 값 INSERT
								INSERT INTO #TEMP3_DM_PLN_NET_DEMAND_BP$
									(DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
								, PLANT_SITE_ID, DEMAND_TYPE, YYYYMMDD, DEMAND_PRIORITY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
								, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
								VALUES ( @n_DIVISION_ID, @n_VERSION_NO, @n_CUTOFF_YYYYMMDD, @n_PROJECT_CODE, @n_SCM_SITE_ID, @n_ITEM_ID,@n_DOM_EXP, @n_FCST_TYPE, @n_INCOTERMS, @n_PLANT_SITE_ID 
										,'NF' /*DEMAND_TYPE*/ ,@n_YYYYMMDD,@priority_count /*DEMAND_PRIORITY*/,@calc_CF,'dm_batch' /*CREATED_BY*/,getdate(),'dm_batch',getdate()
										,null,null,null,null,null,null,null,null,null,null)
								END

							SET @calc_CF = 0
							END

						FETCH NEXT FROM CURSOR2_DEMAND INTO 
												  @n_DIVISION_ID    
												 ,@n_VERSION_NO
												 ,@n_CUTOFF_YYYYMMDD
												 ,@n_PROJECT_CODE   
												 ,@n_SCM_SITE_ID    
												 ,@n_ITEM_ID        
												 ,@n_DOM_EXP        
												 ,@n_FCST_TYPE      
												 ,@n_INCOTERMS      
												 ,@n_PLANT_SITE_ID  
												 ,@n_YYYYMMDD       
												 ,@n_QTY

					---------------------------------------------------------------------------------------- 
					END;
					---------------------------------------------------------------------------------------- WHILE_2 LOOP END

					CLOSE CURSOR2_DEMAND;  
					DEALLOCATE CURSOR2_DEMAND;
					---------------------------------------------------------------------------------------- CURSOR_2 CLOSE

		---------------------------------------------------------------------------------------- CURSOR_1 FETCH
            FETCH NEXT FROM CURSOR1_DEMAND INTO 
									  @v_DIVISION_ID    
									 ,@v_VERSION_NO     
									 ,@v_CUTOFF_TYPE    
									 ,@v_CUTOFF_YYYYMMDD
									 ,@v_PROJECT_CODE   
									 ,@v_SCM_SITE_ID    
									 ,@v_ITEM_ID        
									 ,@v_DOM_EXP        
									 ,@v_FCST_TYPE      
									 ,@v_INCOTERMS      
									 ,@v_PLANT_SITE_ID  
						--			 ,@v_MEASURE        
									 ,@v_YYYYMM         
									 ,@v_BATCH_RESULT   
									 --,@v_QTY     
									 --,@v_RTF     
									 --,@v_MKT_FCST
									 --,@v_CF      
									 --,@v_UF      
									 --,@v_NF      

		---------------------------------------------------------------------------------------- 
        END;
		---------------------------------------------------------------------------------------- WHILE_1 LOOP END

		CLOSE CURSOR1_DEMAND;  
        DEALLOCATE CURSOR1_DEMAND;
		---------------------------------------------------------------------------------------- CURSOR_1 CLOSE

PRINT 'EXEC_004                                       =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|
		---------------------------------------------------------------------------------------- 20180403 SongKH (start)
		-- 전주 CutOff 데이터가 존재하지 않아도 당주 CutOff 데이터가 존재하면 DEMAND_TYPE='NF'로 생성함
		---------------------------------------------------------------------------------------- 
		  BEGIN
			INSERT  #TEMP3_DM_PLN_NET_DEMAND_BP$
					( DIVISION_ID,VERSION_NO,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP
					,FCST_TYPE,INCOTERMS,PLANT_SITE_ID,DEMAND_TYPE,YYYYMMDD
					,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
			SELECT 
					 DIVISION_ID,VERSION_NO,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP
					,FCST_TYPE,INCOTERMS,PLANT_SITE_ID,'NF',YYYYMMDD
					,QTY,'dm_batch',getdate(),'dm_batch',getdate(),null,null,null,null,null,null,null,null,null,null
			  FROM  #TEMP2_DM_PLN_NET_DEMAND_BP$
		  END
		---------------------------------------------------------------------------------------- 20180403 SongKH (end)


---------------------------------------------------------------------------------------- customer_LT 적용데이터 insert
		BEGIN
		IF  OBJECT_ID(N'tempdb..#TEMP4_DM_PLN_NET_DEMAND_BP$', N'U') IS NOT NULL 
			BEGIN
				DROP TABLE #TEMP4_DM_PLN_NET_DEMAND_BP$ 
			END;
		IF  OBJECT_ID(N'dbo.#TEMP4_DM_PLN_NET_DEMAND_BP$', N'U') IS NOT NULL 
			BEGIN
				DROP TABLE #TEMP4_DM_PLN_NET_DEMAND_BP$ 
			END;

		-- TEMP 테이블 생성
		SELECT TOP 0 * INTO #TEMP4_DM_PLN_NET_DEMAND_BP$ FROM #TEMP3_DM_PLN_NET_DEMAND_BP$

		-- 확인용
		--SELECT '#TEMP3_DM_PLN_NET_DEMAND_BP$'
--SELECT * FROM #TEMP3_DM_PLN_NET_DEMAND_BP$
PRINT 'EXEC_005                                       =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)

		INSERT INTO #TEMP4_DM_PLN_NET_DEMAND_BP$ 
		SELECT 
		  A.DIVISION_ID,VERSION_NO,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,A.INCOTERMS,PLANT_SITE_ID,
		  DEMAND_TYPE
		  ,
		  A.YYYYMMDD
		  -- 2023-08-26 잘 몰라서 막아둠
		 -- CASE   
			------------------------------------------------------------------------------------------------------------------------------
			---- YYYYMMDD 설정 / DIVISION_ID IN ('81','40') CASE
			------------------------------------------------------------------------------------------------------------------------------
			--WHEN A.DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81' ) ) THEN 
			--		convert( varchar, cast( [YYYYMMDD] as datetime )  - ISNULL( (   select max(lt_total)
			--     																	from dbo.SCP_MST_BOD_V bod WITH(NOLOCK)
			--																		where 1=1
			--																		  AND bod.division_id = A.DIVISION_ID
			--																		  AND bod.from_site   = A.plant_site_id
			--																		  and bod.to_site     = A.SCM_SITE_ID
			--																		  and bod.incoterms   = A.INCOTERMS ) , 0 ) -- Customer L/T 만큼 당겨줌.
			--																, 112)  
			------------------------------------------------------------------------------------------------------------------------------
			---- YYYYMMDD 설정 /  DIVISION_ID = '82' CASE (20181211 KHSONG ESS 출하기준으로 DEMAND SEQ 설정)
			------------------------------------------------------------------------------------------------------------------------------
			--WHEN A.DIVISION_ID = '82' THEN
			--		CONVERT(VARCHAR(8), DATEADD(DD, -1*ISNULL(BOD_V.LT_TOTAL, 0), CAST(A.YYYYMMDD AS DATETIME)) , 112 )  -- ESS Net Demand 생성은 출하일자로 당겨서 사용함
			------------------------------------------------------------------------------------------------------------------------------
			---- YYYYMMDD 설정 /  ELSE CASE
			------------------------------------------------------------------------------------------------------------------------------
			--ELSE YYYYMMDD
		 -- END AS yyyymmdd						 
		  ,DEMAND_PRIORITY
		  ,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
		  ,YYYYMMDD AS ATTRIBUTE1
		  ,CASE   
			----------------------------------------------------------------------------------------------------------------------------
			-- ATTRIBUTE2 설정 / DIVISION_ID IN ('81','40') CASE
			----------------------------------------------------------------------------------------------------------------------------
			WHEN A.DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81' ) ) THEN 
			ISNULL( (   select max(lt_total)
			     			from dbo.SCP_MST_BOD_V bod WITH(NOLOCK)
								where 1=1
								  AND bod.division_id = A.DIVISION_ID
								  AND bod.from_site   = A.plant_site_id
								  and bod.to_site     = A.SCM_SITE_ID
								  and bod.incoterms   = A.INCOTERMS ) , 0 ) -- Customer L/T 확인용테이터
			----------------------------------------------------------------------------------------------------------------------------
			-- ATTRIBUTE2 설정 / DIVISION_ID = '82' CASE
			----------------------------------------------------------------------------------------------------------------------------
			WHEN A.DIVISION_ID = '82' THEN -- 20181211 KHSONG ESS 출하기준으로 DEMAND SEQ 설정
			ISNULL(	BOD_V.LT_TOTAL,0)
		  END AS ATTRIBUTE2
			----------------------------------------------------------------------------------------------------------------------------
			-- ATTRIBUTE3 설정 / DEMAND_TYPE
			----------------------------------------------------------------------------------------------------------------------------
		  ,CASE   WHEN DEMAND_TYPE='CF' THEN 1 WHEN DEMAND_TYPE='UF' THEN 2 WHEN DEMAND_TYPE='NF' THEN 3 ELSE '' END 
		   AS ATTRIBUTE3  --1112

		   
		  ,
		  ISNULL(
		  CASE   
				  ----------------------------------------------------------------------------------------------------------------------------
				  -- ATTRIBUTE4 설정 / DIVISION_ID = '40' CASE (20181130 소형인경우 scm_mst_site_item.ATTRIBUTE7 Priority 를 저장)
				  ----------------------------------------------------------------------------------------------------------------------------
		          WHEN A.DIVISION_ID = '40' THEN 
			(SELECT TOP 1 ATTRIBUTE7 FROM dbo.SCM_MST_SITE_ITEM M WITH(NOLOCK) WHERE 1=1 AND M.DIVISION_ID = A.DIVISION_ID AND M.PROJECT_CODE = A.PROJECT_CODE AND M.SCM_SITE_ID = A.SCM_SITE_ID AND M.ITEM_ID = A.ITEM_ID)

		   
				  ----------------------------------------------------------------------------------------------------------------------------
				  -- ATTRIBUTE4 설정 / DIVISION_ID = '82' CASE (20181210 ESS인경우 DM_MST_SHIPMENT_PRIORITY.PRIORITY 값을 저장)
				  ----------------------------------------------------------------------------------------------------------------------------
				  WHEN A.DIVISION_ID = '82' THEN 
			(SELECT TOP 1 PRIORITY 
				FROM dbo.DM_MST_SHIPMENT_PRIORITY P WITH(NOLOCK) 
					WHERE 1=1 AND P.DIVISION_ID = A.DIVISION_ID AND P.PROJECT_CODE = A.PROJECT_CODE AND P.ITEM_ID = A.ITEM_ID 
						AND P.SCM_SITE_ID = A.SCM_SITE_ID  -- 20190920 KHSONG ADDED

						--기존로직(BEGIN)
						--AND P.YYYYMM = CONVERT(VARCHAR(6), DATEADD(DD, -1*ISNULL(BOD_V.LT_TOTAL, 0), CAST(A.YYYYMMDD AS DATETIME)) , 112 )  -- ESS Net Demand 생성은 출하일자로 당겨서 사용함
						--기존로직(END)

						-- 20190925 KHSONG [CSR ID:4077124] ESS Shipment Priority 화면 변경요청 (월단위 → 주단위) 변경되어 매주 월요일값으로 비교 (BEGIN)
						AND P.YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY((
																							CONVERT(VARCHAR(8), DATEADD(DD, -1*ISNULL(BOD_V.LT_TOTAL, 0), CAST(A.YYYYMMDD AS DATETIME)) , 112 )
																							), 'MON')), 112) -- ESS Net Demand 생성은 출하일자로 당겨서 사용함
						-- 20190925 KHSONG [CSR ID:4077124] ESS Shipment Priority 화면 변경요청 (월단위 → 주단위) 변경되어 매주 월요일값으로 비교 (END)
					)
			ELSE '' END 
			,'99')
		   AS ATTRIBUTE4
					
		  ,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
		 FROM #TEMP3_DM_PLN_NET_DEMAND_BP$ A
					LEFT JOIN (
						SELECT 
							  division_id
							, TO_SITE
							, INCOTERMS
							, PRIORITY
							, LT_TOTAL
							, ROW_NUMBER() OVER ( PARTITION BY TO_SITE, INCOTERMS ORDER BY PRIORITY ASC, LT_TOTAL ASC) AS SEQ
						FROM dbo.SCP_MST_BOD_V B
					) AS BOD_V
					ON		A.DIVISION_ID	= BOD_V.division_id
						AND A.SCM_SITE_ID	= BOD_V.TO_SITE
						AND A.INCOTERMS		= BOD_V.INCOTERMS
						AND BOD_V.SEQ		= 1
		-- 확인용
		--SELECT '#TEMP4_DM_PLN_NET_DEMAND_BP$'
--SELECT * FROM #TEMP4_DM_PLN_NET_DEMAND_BP$

		END
					---------------------------------------------------------------------------------------- CURSOR_3 OPEN
PRINT 'EXEC_006                                       =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
					BEGIN
						set @demand_sort_rows = 1   -- row count 초기화

						IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR3_DEMAND')
							BEGIN
								CLOSE CURSOR3_DEMAND
								DEALLOCATE CURSOR3_DEMAND
							END;


						
						-- 20190830 KHSONG ESS용 SORT기준 추가
						IF @p_division_id = '82'
							BEGIN
								DECLARE CURSOR3_DEMAND CURSOR FAST_FORWARD FOR
								SELECT 
									DIVISION_ID,VERSION_NO,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
									,PLANT_SITE_ID,DEMAND_TYPE,YYYYMMDD,DEMAND_PRIORITY,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY
									,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3

									,ATTRIBUTE4 -- ESS SORT 기준 20190830 KHSONG

									,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10

								FROM #TEMP4_DM_PLN_NET_DEMAND_BP$ 
									  --ORDER BY YYYYMMDD  -- ESS SORT 기준 20190830 KHSONG
									  ORDER BY ATTRIBUTE4,YYYYMMDD  -- ESS SORT 기준 20190920 KHSONG [ 고정값(1자리) + 고객Priority(2자리)+일련번호(4자리)+demand type(1자리) ] → 총 8자리
							END
						ELSE
							BEGIN
								DECLARE CURSOR3_DEMAND CURSOR FAST_FORWARD FOR
								SELECT 
									DIVISION_ID,VERSION_NO,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
									,PLANT_SITE_ID,DEMAND_TYPE,YYYYMMDD,DEMAND_PRIORITY,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY
									,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
								FROM #TEMP4_DM_PLN_NET_DEMAND_BP$ 
									  ORDER BY PLANT_SITE_ID,ATTRIBUTE3,YYYYMMDD  -- PLANT,ATTRIBUTE3(DEMAND_TYPE) 기준으로 SORT하여 INPUT
							END

						SET @demand_sort_max = (SELECT count(*) FROM #TEMP4_DM_PLN_NET_DEMAND_BP$)
						SET @demand_min_yyyymmdd = (SELECT MIN(ATTRIBUTE1) FROM #TEMP4_DM_PLN_NET_DEMAND_BP$)  -- 20181112 KHSONG 최소날짜를 저장
					END

					BEGIN
						OPEN CURSOR3_DEMAND;
						FETCH NEXT FROM CURSOR3_DEMAND INTO 
						       @x_DIVISION_ID,@x_VERSION_NO,@x_CUTOFF_YYYYMMDD,@x_PROJECT_CODE,@x_SCM_SITE_ID
							  ,@x_ITEM_ID,@x_DOM_EXP,@x_FCST_TYPE,@x_INCOTERMS,@x_PLANT_SITE_ID,@x_DEMAND_TYPE
							  ,@x_YYYYMMDD,@x_DEMAND_PRIORITY,@x_QTY,@x_CREATED_BY,@x_CREATION_DATE,@x_LAST_UPDATED_BY
							  ,@x_LAST_UPDATE_DATE,@x_ATTRIBUTE1,@x_ATTRIBUTE2,@x_ATTRIBUTE3,@x_ATTRIBUTE4,@x_ATTRIBUTE5
							  ,@x_ATTRIBUTE6,@x_ATTRIBUTE7,@x_ATTRIBUTE8,@x_ATTRIBUTE9,@x_ATTRIBUTE10

					END

					BEGIN
						IF  OBJECT_ID(N'tempdb..#TEMP5_DM_PLN_NET_DEMAND_BP$', N'U') IS NOT NULL 
							BEGIN
								DROP TABLE #TEMP5_DM_PLN_NET_DEMAND_BP$ 
							END;
						IF  OBJECT_ID(N'dbo.#TEMP5_DM_PLN_NET_DEMAND_BP$', N'U') IS NOT NULL 
							BEGIN
								DROP TABLE #TEMP5_DM_PLN_NET_DEMAND_BP$ 
							END;

						SELECT  TOP 0 * INTO #TEMP5_DM_PLN_NET_DEMAND_BP$ FROM #TEMP4_DM_PLN_NET_DEMAND_BP$

						SET  @FL_PLANT_SITE_ID = ''
					END

PRINT 'EXEC_007                                       =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
					---------------------------------------------------------------------------------------- WHILE_3 LOOP START
					WHILE      @demand_sort_rows <= @demand_sort_max  
					----------------------------------------------------------------------------------------
					BEGIN

						---------------------------------------------------------------------------------------------------◇◇◇◇◇
						--                                                        DIVISION_ID 구분로직추가 20190830 KHSONG (BEGIN)
						---------------------------------------------------------------------------------------------------◇◇◇◇◇
						IF @x_DIVISION_ID = '82'
							BEGIN
							-----------------------------------------------------------------------------------◇◇◇◇◇
							--                                           DIVISION_ID : 82 처리 20190830 KHSONG (BEGIN)
							-----------------------------------------------------------------------------------◇◇◇◇◇
								-- 첫데이터인경우
								IF @FL_YYYYMMDD IS NULL
									BEGIN
										SET @FL_YYYYMMDD = @x_YYYYMMDD
									END

								-- 날짜가 달라지는 경우 count 증가
								IF @FL_YYYYMMDD <> ISNULL(@x_YYYYMMDD,'')
									BEGIN
										SET @ESS_count = @ESS_count + 1
										SET @FL_YYYYMMDD = @x_YYYYMMDD
									END
								SET @INST_count = @ESS_count
								
							END
							-----------------------------------------------------------------------------------◇◇◇◇◇
							--                                           DIVISION_ID : 82 처리 20190830 KHSONG (END)
							-----------------------------------------------------------------------------------◇◇◇◇◇

						ELSE


							BEGIN
							-----------------------------------------------------------------------------------◇◇◇◇◇
							--                                                        DIVISION_ID : 81,40 처리 (BEGIN)
							-----------------------------------------------------------------------------------◇◇◇◇◇
										-- PLANT_SITE_ID 가 변경된 경우
										IF @FL_PLANT_SITE_ID <> ISNULL(@x_PLANT_SITE_ID,'')
										  BEGIN
											SET @FL_PLANT_SITE_ID = @x_PLANT_SITE_ID
											SET @FL_DEMAND_TYPE   = @x_DEMAND_TYPE
											SET @FL_YYYYMMDD = @x_YYYYMMDD
											SET @CF_count = 1001
											SET @UF_count = 2001
											SET @NF_count = 3001
										  END
										-- DEMAND_TYPE이 같은경우 -----------------------------------------------------------
										IF @FL_DEMAND_TYPE = ISNULL(@x_DEMAND_TYPE,'')
										  BEGIN

												IF @FL_DEMAND_TYPE = 'CF'
												  BEGIN
													IF @FL_YYYYMMDD <> ISNULL(@x_YYYYMMDD,'')
														BEGIN
														  SET @CF_count = @CF_count + 1
															SET @FL_YYYYMMDD = @x_YYYYMMDD
														END
														SET @INST_count = @CF_count
												  END

												IF @FL_DEMAND_TYPE = 'UF'
												  BEGIN
													IF @FL_YYYYMMDD <> ISNULL(@x_YYYYMMDD,'')
														BEGIN
														  SET @UF_count = @UF_count + 1
															SET @FL_YYYYMMDD = @x_YYYYMMDD
														END
														SET @INST_count = @UF_count
												  END

												IF @FL_DEMAND_TYPE = 'NF'
												  BEGIN
													IF @FL_YYYYMMDD <> ISNULL(@x_YYYYMMDD,'')
														BEGIN
														  SET @NF_count = @NF_count + 1
															SET @FL_YYYYMMDD = @x_YYYYMMDD
														END
														SET @INST_count = @NF_count
												  END

										  END

										-- DEMAND_TYPE이 바뀐경우
										ELSE

										  BEGIN
												SET @FL_DEMAND_TYPE   = @x_DEMAND_TYPE
												SET @FL_YYYYMMDD = @x_YYYYMMDD

												IF @FL_DEMAND_TYPE = 'CF'
												  BEGIN
														SET @CF_count = 1001
														SET @INST_count = @CF_count
												  END

												IF @FL_DEMAND_TYPE = 'UF'
												  BEGIN
														SET @UF_count = 2001
														SET @INST_count = @UF_count
												  END

												IF @FL_DEMAND_TYPE = 'NF'
												  BEGIN
														SET @NF_count = 3001
														SET @INST_count = @NF_count
												  END
										  END
							END

PRINT 'EXEC_007_1                                       =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
							-----------------------------------------------------------------------------------◇◇◇◇◇
							--                                                        DIVISION_ID : 81,40 처리 (END)
							-----------------------------------------------------------------------------------◇◇◇◇◇
						---------------------------------------------------------------------------------------------------◇◇◇◇◇
						--                                                        DIVISION_ID 구분로직추가 20190830 KHSONG (BEGIN)
						---------------------------------------------------------------------------------------------------◇◇◇◇◇
PRINT @demand_min_yyyymmdd
						SET @demand_min_yyyymmdd = @demand_min_yyyymmdd + '01'
						INSERT	INTO  #TEMP5_DM_PLN_NET_DEMAND_BP$
						       ( DIVISION_ID,VERSION_NO,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID
							  ,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID,DEMAND_TYPE
							  ,YYYYMMDD
							  ,DEMAND_PRIORITY
							  ,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY
							  ,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
							  ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10)
							VALUES
							(
						       @x_DIVISION_ID,@x_VERSION_NO,@x_CUTOFF_YYYYMMDD,@x_PROJECT_CODE,@x_SCM_SITE_ID
							  ,@x_ITEM_ID,@x_DOM_EXP,@x_FCST_TYPE,@x_INCOTERMS,@x_PLANT_SITE_ID,@x_DEMAND_TYPE
							  ,@x_YYYYMMDD
							  --,@INST_count -- @x_DEMAND_PRIORITY cast (기존)
							  -- 20181112 DIV:81 인경우 DEMAND_PRIORITY를 일련번호+type 으로 수정(take2)

							  -- 2023-08-26 잘몰라서 막아둠
							  --,case when @x_DIVISION_ID LIKE '81%' 
									--then (CONVERT(VARCHAR,DATEDIFF(DD,CAST( @demand_min_yyyymmdd AS DATETIME) , CAST(@x_ATTRIBUTE1 AS DATETIME)) +1) + @x_ATTRIBUTE3 )

							  ---- 20181130 DIV:40 인경우 DEMAND_PRIORITY 컬럼값에 고객 Priority(2자리) 추가
									--when @x_DIVISION_ID = '40' 
									----then @x_ATTRIBUTE4 + CONVERT(varchar, @INST_count, 0)
									--then replicate('0',2- len(@x_ATTRIBUTE4)) + cast(@x_ATTRIBUTE4 as varchar) + CONVERT(varchar, @INST_count, 0)  -- 고객Priority를 2자리로 셋팅 + 일련번호

							  ---- 20181210 DIV:82 인경우 DEMAND_PRIORITY 컬럼값에 고객 Priority(2자리) 추가
									--when @x_DIVISION_ID = '82' 
									----then replicate('0',2- len(@x_ATTRIBUTE4)) + cast(@x_ATTRIBUTE4 as varchar) + CONVERT(varchar, @INST_count, 0)  -- 고객Priority를 2자리로 셋팅 + 일련번호


									----------------------------------------------------------------------------------------------------------------------------------------
									---- 20190830 KHSONG ESS전용으로 변경 [ 일련번호(4자리)+고객Priority(2자리)+demand type(1자리)] (BEGIN)
									----------------------------------------------------------------------------------------------------------------------------------------
									----then CONVERT(varchar, @INST_count, 0) + replicate('0',2- len(@x_ATTRIBUTE4)) + cast(@x_ATTRIBUTE4 as varchar) + @x_ATTRIBUTE3  
									----------------------------------------------------------------------------------------------------------------------------------------
									---- 20190830 KHSONG ESS전용으로 변경 [ 일련번호(4자리)+고객Priority(2자리)+demand type(1자리)] (END)
									----------------------------------------------------------------------------------------------------------------------------------------

									----------------------------------------------------------------------------------------------------------------------------------------
									---- ESS SORT 기준 20190920 KHSONG [ 고정값(1자리) + 고객Priority(2자리)+일련번호(4자리)+demand type(1자리) ] → 총 8자리 (BEGIN)
									----------------------------------------------------------------------------------------------------------------------------------------
									--then '1' + replicate('0',2- len(@x_ATTRIBUTE4)) + cast(@x_ATTRIBUTE4 as varchar) + CONVERT(varchar, @INST_count, 0) + @x_ATTRIBUTE3
									----------------------------------------------------------------------------------------------------------------------------------------
									---- ESS SORT 기준 20190920 KHSONG [ 고정값(1자리) + 고객Priority(2자리)+일련번호(4자리)+demand type(1자리) ] → 총 8자리 (END)
									----------------------------------------------------------------------------------------------------------------------------------------

							  -- else CONVERT(varchar, @INST_count, 0) end
							   -- 2023-08-26 잘몰라서 막아둠
							   ,CONVERT(varchar, @INST_count, 0)
							  ,@x_QTY,@x_CREATED_BY,@x_CREATION_DATE,@x_LAST_UPDATED_BY
							  ,@x_LAST_UPDATE_DATE,@x_ATTRIBUTE1,@x_ATTRIBUTE2,@x_ATTRIBUTE3
							  ,replicate('0',2- len(@x_ATTRIBUTE4)) + cast(@x_ATTRIBUTE4 as varchar) --@x_ATTRIBUTE4  -- 고객Priority를 2자리로 셋팅
							  ,@x_ATTRIBUTE5
							  ,@x_ATTRIBUTE6,@x_ATTRIBUTE7,@x_ATTRIBUTE8,@x_ATTRIBUTE9,@x_ATTRIBUTE10
							)

						set @demand_sort_rows = @demand_sort_rows + 1    -- 처리후 LOOP count 증가

						FETCH NEXT FROM CURSOR3_DEMAND INTO 
						       @x_DIVISION_ID,@x_VERSION_NO,@x_CUTOFF_YYYYMMDD,@x_PROJECT_CODE,@x_SCM_SITE_ID
							  ,@x_ITEM_ID,@x_DOM_EXP,@x_FCST_TYPE,@x_INCOTERMS,@x_PLANT_SITE_ID,@x_DEMAND_TYPE
							  ,@x_YYYYMMDD,@x_DEMAND_PRIORITY,@x_QTY,@x_CREATED_BY,@x_CREATION_DATE,@x_LAST_UPDATED_BY
							  ,@x_LAST_UPDATE_DATE,@x_ATTRIBUTE1,@x_ATTRIBUTE2,@x_ATTRIBUTE3,@x_ATTRIBUTE4,@x_ATTRIBUTE5
							  ,@x_ATTRIBUTE6,@x_ATTRIBUTE7,@x_ATTRIBUTE8,@x_ATTRIBUTE9,@x_ATTRIBUTE10

					---------------------------------------------------------------------------------------- 
					END;
					---------------------------------------------------------------------------------------- WHILE_3 LOOP END

					CLOSE CURSOR3_DEMAND;  
					DEALLOCATE CURSOR3_DEMAND;
					---------------------------------------------------------------------------------------- CURSOR_3 CLOSE

--SELECT * FROM #TEMP5_DM_PLN_NET_DEMAND_BP$		

PRINT 'EXEC_008                                       =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
				/*-------------------- DM_PLN_NET_DEMAND_BP 테이블 insert전 데이터 중복제거 ,insert --------------------*/
				BEGIN 

				DELETE
					FROM  dbo.DM_PLN_NET_DEMAND_BP
						WHERE (
						SELECT count(1) 
							FROM #TEMP5_DM_PLN_NET_DEMAND_BP$ B WITH(NOLOCK)
							where  1=1
							and  DM_PLN_NET_DEMAND_BP.VERSION_NO             =  B.VERSION_NO
							and  DM_PLN_NET_DEMAND_BP.CUTOFF_YYYYMMDD        =  B.CUTOFF_YYYYMMDD   
							and  DM_PLN_NET_DEMAND_BP.DIVISION_ID            =  B.DIVISION_ID
							and  B.DIVISION_ID = @p_division_id                    
						) > 0


				INSERT	dbo.DM_PLN_NET_DEMAND_BP
					( DIVISION_ID,VERSION_NO,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS,PLANT_SITE_ID,DEMAND_TYPE,YYYYMMDD,DEMAND_PRIORITY,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
				  select  DIVISION_ID
					,VERSION_NO,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
					,PLANT_SITE_ID,DEMAND_TYPE,YYYYMMDD,DEMAND_PRIORITY,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,GETDATE(),ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				  from #TEMP5_DM_PLN_NET_DEMAND_BP$
				END
				/*-------------------- DM_PLN_NET_DEMAND_BP 테이블 insert전 데이터 중복제거 ,insert --------------------*/

--select * from #TEMP5_DM_PLN_NET_DEMAND_BP$

		BEGIN
			SELECT 'SUCCESS'

		END

		-- 사용된 TEMP TABLE DROP
		BEGIN
		IF  OBJECT_ID(N'tempdb..#TEMP1_DM_PLN_NET_DEMAND_BP$', N'U') IS NOT NULL 
			BEGIN
				DROP TABLE #TEMP1_DM_PLN_NET_DEMAND_BP$ 
			END;
		IF  OBJECT_ID(N'tempdb..#TEMP2_DM_PLN_NET_DEMAND_BP$', N'U') IS NOT NULL 
			BEGIN
				DROP TABLE #TEMP2_DM_PLN_NET_DEMAND_BP$ 
			END;
		IF  OBJECT_ID(N'tempdb..#TEMP3_DM_PLN_NET_DEMAND_BP$', N'U') IS NOT NULL 
			BEGIN
				DROP TABLE #TEMP3_DM_PLN_NET_DEMAND_BP$ 
			END;
		IF  OBJECT_ID(N'tempdb..#TEMP4_DM_PLN_NET_DEMAND_BP$', N'U') IS NOT NULL 
			BEGIN
				DROP TABLE #TEMP4_DM_PLN_NET_DEMAND_BP$ 
			END;
		IF  OBJECT_ID(N'tempdb..#TEMP5_DM_PLN_NET_DEMAND_BP$', N'U') IS NOT NULL 
			BEGIN
				DROP TABLE #TEMP5_DM_PLN_NET_DEMAND_BP$ 
			END;
		END

  	-- 트랜잭션 (COMMIT)
      COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	  -- 트랜잭션 (END)
	  ROLLBACK TRANSACTION PLN_MKT_FCST_TO_NET_DEMAND;

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
	SET @v_description = '@p_division_id : ' + @p_division_id + ' / ' + N'전주CUTOFF VERSION : ' + ISNULL(@input_VERSION1,'NULL') + ' / ' + N'당주CUTOFF VERSION : ' + ISNULL(@input_VERSION2,'NULL') + ' / ' + '@MAX_PLAN_ID : ' + ISNULL(@MAX_PLAN_ID,'NULL')
	+' / ' + N'@CF_count : ' + Convert(NVARCHAR(4), @CF_count) +' / ' + N'@UF_count : ' + Convert(NVARCHAR(4), @UF_count) +' / ' + N'@NF_count : ' + Convert(NVARCHAR(4), @NF_count) 
	+' / ' + N'@ESS_count : ' + Convert(NVARCHAR(4), @ESS_count) --20190830 KHSONG [CSR ID:4074696] Demand 우선순위 개선의 건
	;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	ERR_RTN:
	IF @v_log_type = 'INVALID'
		begin
			ROLLBACK TRANSACTION PLN_MKT_FCST_TO_NET_DEMAND
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		end

;


