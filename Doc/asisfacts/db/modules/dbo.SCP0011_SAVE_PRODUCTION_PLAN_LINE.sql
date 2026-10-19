
/*
 * Program ID   : [SCP0011_SAVE_PRODUCTION_PLAN_LINE]
 * Description  : Production Plan의 Line "Prod. Plan(Amend)" Measure저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/05/17   PJS   SInitial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/23   PJS	  FIX값 저장 기능 추가	
 * 2018/07/18	YHW	  전극용 데이터 저장 추가(ORIGIN_DIVISION_ID, ELECTRODE_TYPE)
 * 2025/11/11   hrkim [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 
 *						: ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
 */
CREATE PROCEDURE [dbo].[SCP0011_SAVE_PRODUCTION_PLAN_LINE]
	 @p_active_flag 	 NVARCHAR(MAX)
	,@p_division_id          NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd  NVARCHAR(MAX)
	,@p_plan_type            NVARCHAR(MAX)
	,@p_seq                  NVARCHAR(MAX)
	,@p_operation_group      NVARCHAR(MAX)
	,@p_scm_site_id          NVARCHAR(MAX)
	,@p_item_id              NVARCHAR(MAX)
	,@p_line_id              NVARCHAR(MAX)
	,@p_operation_id         NVARCHAR(MAX)
	,@p_measure              NVARCHAR(MAX)
	,@p_yyyymmdd             NVARCHAR(MAX)
	,@p_qty                  NVARCHAR(MAX)
	,@p_user_id              NVARCHAR(MAX)
	,@p_fix                  NVARCHAR(MAX)
	,@p_electrode_type       NVARCHAR(MAX) = ''
	,@p_origin_division_id   NVARCHAR(MAX) = ''
	,@p_program_id           NVARCHAR(200) ='SCP0011'
	,@debug_mode             NVARCHAR(1) ='F'
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	--DECLARE @DEBUG_MODE NVARCHAR(20) ='FALSE';
	--DECLARE @DEBUG_MODE NVARCHAR(20) ='TRUE';

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag		NVARCHAR(MAX);
	DECLARE @v_division_id          NVARCHAR(MAX);
	DECLARE @v_plan_start_yyyymmdd  NVARCHAR(MAX);
	DECLARE @v_plan_type            NVARCHAR(MAX);
	DECLARE @v_seq                  NVARCHAR(MAX);
	DECLARE @v_operation_group      NVARCHAR(MAX);
	DECLARE @v_scm_site_id          NVARCHAR(MAX);
	DECLARE @v_item_id              NVARCHAR(MAX);
	DECLARE @v_line_id              NVARCHAR(MAX);
	DECLARE @v_operation_id         NVARCHAR(MAX);
	DECLARE @v_measure              NVARCHAR(MAX);
	DECLARE @v_yyyymmdd             NVARCHAR(MAX);
	DECLARE @v_qty                  NVARCHAR(MAX);
	DECLARE @v_fix                  NVARCHAR(MAX);
	DECLARE @v_electrode_type       NVARCHAR(MAX);
	DECLARE @v_origin_division_id   NVARCHAR(MAX);

	DECLARE @v_created_by       NVARCHAR(MAX)=NULL;
	DECLARE @v_creation_date    datetime =SYSDATETIME(); 
	DECLARE @v_last_updated_by  NVARCHAR(MAX)=NULL;
	--DECLARE @v_last_update_date NVARCHAR(MAX);


	SET @v_active_flag		    = NULL;
	SET @v_division_id          = NULL;
	SET @v_plan_start_yyyymmdd  = NULL;
	SET @v_plan_type            = NULL;
	SET @v_seq                  = NULL;
	SET @v_operation_group      = NULL;
	SET @v_scm_site_id          = NULL;
	SET @v_item_id              = NULL;
	SET @v_line_id              = NULL;
	SET @v_operation_id         = NULL;
	SET @v_measure              = NULL;
	SET @v_yyyymmdd             = NULL;
	SET @v_qty                  = NULL;
	SET @v_fix                  = NULL;
	SET @v_electrode_type       = NULL;
	SET @v_origin_division_id   = NULL;



	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SCP0011_SAVE_PRODUCTION_PLAN_LINE]';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	DECLARE @v_data_dup_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	

	-- SCP0011, SCP0013에서 공용으로 사용하는 프로시져 이기 때문에 SCP0013에서 호출되었을 경우 @v_program_name 변경
	IF( @p_program_id = 'SCP0013' )
		SET @v_program_name ='SCP0013';

	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY

		--PRINT '1';

			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		------------------------------------------------------------------------------------------------------------------------------------------------------- 
		--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
		print  convert(varchar(30), getdate(), 121) + N' JV/ESS 라인 및 scm site 매핑 정보 추출' 
		-------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#JV_ESS_LINE_MAP')		IS NOT NULL DROP TABLE #JV_ESS_LINE_MAP
		IF OBJECT_ID('TEMPDB..#JV_ESS_SCM_SITE_MAP')	IS NOT NULL DROP TABLE #JV_ESS_SCM_SITE_MAP
		SELECT VL_COMPANY_ID
			  ,VL_DIVISION_ID
			  ,VL_SITE_ID
			  ,VL_PLANT_ID
			  ,VL_FACTORY_ID
			  ,VL_LINE_ID
			  ,RL_COMPANY_ID
			  ,RL_DIVISION_ID
			  ,RL_SITE_ID
			  ,RL_PLANT_ID
			  ,RL_FACTORY_ID
			  ,RL_LINE_ID
		 INTO #JV_ESS_LINE_MAP
		 FROM FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP() 

		SELECT VP_COMPANY_ID
			  ,VP_DIVISION_ID
			  ,VP_SITE_ID
			  ,VP_PLANT_ID
			  ,VP_SCM_SITE_ID
			  ,RP_COMPANY_ID
			  ,RP_DIVISION_ID
			  ,RP_SITE_ID
			  ,RP_PLANT_ID
			  ,RP_SCM_SITE_ID
		 INTO #JV_ESS_SCM_SITE_MAP
		 FROM FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP () 
		------------------------------------------------------------------------------------------------------------  
		print  convert(varchar(30), getdate(), 121) + N' DIVISION 주차별 최종 수행 Plan 버전 정보 ' 
		-- ESS 가상 라인 매핑 JV division의 동기화 대상 버전 정보 확인을 위한 데이터
		-- Final Plan은 수정 대상에서 제외 ? 
		------------------------------------------------------------------------------------------------------------  
		IF OBJECT_ID('TEMPDB..#DIVISION_LAST_PLAN_INFO') IS NOT NULL DROP TABLE #DIVISION_LAST_PLAN_INFO;
		;WITH SCP_PLAN_INFO AS (
			SELECT PD.DIVISION_ID
				 , PM.PLAN_NAME			AS PLAN_START_YYYYMMDD
				 , PD.PLAN_TYPE
				 , PD.PLAN_SEQ
				 , PM.HORIZON_END_DATE	
				 , PD.PLAN_STATUS
				 , PD.INPUT_START_DATE 
				 , ROW_NUMBER()	OVER (PARTITION BY PD.DIVISION_ID
												 , PM.PLAN_NAME
										 ORDER  BY CASE WHEN PD.PLAN_TYPE = 'PR' THEN 4
														WHEN PD.PLAN_TYPE = 'MA' THEN 3
														WHEN PD.PLAN_TYPE = 'SE' THEN 2
														WHEN PD.PLAN_TYPE = 'FN' THEN 1
														ELSE 0
												   END
												  ,PD.PLAN_SEQ DESC
												  ,PD.INPUT_START_DATE DESC ) AS RN
			 FROM SCM_MST_PLAN PM WITH(NOLOCK)
				  INNER JOIN SCM_MST_PLAN_DETAIL PD WITH(NOLOCK)
						  ON PD.DIVISION_ID = PM.DIVISION_ID
						 AND PD.PLAN_ID		= PM.PLAN_ID
						 AND PD.PLAN_STATUS	= 1
				  INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
						  ON DM.DIVISION_ID	= PM.DIVISION_ID 
						 AND DM.ATTRIBUTE3 != 'EE'
			WHERE 1=1 
			  AND PM.PLAN_CYCLE = 'WEEKLY'
			  AND PM.PLAN_NAME	>= CONVERT(NVARCHAR(8), DATEADD(DAY, -20, GETDATE()) , 112)
		)
		SELECT DIVISION_ID
			  ,PLAN_START_YYYYMMDD
			  ,PLAN_TYPE
			  ,PLAN_SEQ
			  ,HORIZON_END_DATE
			  ,PLAN_STATUS
			  ,INPUT_START_DATE
			  ,RN
		  INTO #DIVISION_LAST_PLAN_INFO
		 FROM SCP_PLAN_INFO
		WHERE 1=1
		  AND RN = 1 
		  AND PLAN_TYPE != 'FN' -- Final plan 대상에서 제외 
		  ;
		------------------------------------------------------------------------------------------------------------------------------ 
		--### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
		------------------------------------------------------------------------------------------------------------------------------

		--PRINT '2';
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    

		
		
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
				
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag		    = dbo.SCM_ARR_SPL_VAL( @p_active_flag		   	    , @v_delimiter, @mst_loop_cnt );
				SET @v_division_id          = dbo.SCM_ARR_SPL_VAL( @p_division_id         	    , @v_delimiter, @mst_loop_cnt );
				SET @v_plan_start_yyyymmdd  = dbo.SCM_ARR_SPL_VAL( @p_plan_start_yyyymmdd 	    , @v_delimiter, @mst_loop_cnt );
				SET @v_plan_type            = dbo.SCM_ARR_SPL_VAL( @p_plan_type           	    , @v_delimiter, @mst_loop_cnt );
				SET @v_seq                  = dbo.SCM_ARR_SPL_VAL( @p_seq                 	    , @v_delimiter, @mst_loop_cnt );
				SET @v_operation_group      = dbo.SCM_ARR_SPL_VAL( @p_operation_group     	    , @v_delimiter, @mst_loop_cnt );
				SET @v_scm_site_id          = dbo.SCM_ARR_SPL_VAL( @p_scm_site_id         	    , @v_delimiter, @mst_loop_cnt );
				SET @v_item_id              = dbo.SCM_ARR_SPL_VAL( @p_item_id             	    , @v_delimiter, @mst_loop_cnt );
				SET @v_line_id              = dbo.SCM_ARR_SPL_VAL( @p_line_id             	    , @v_delimiter, @mst_loop_cnt );
				SET @v_operation_id         = dbo.SCM_ARR_SPL_VAL( @p_operation_id        	    , @v_delimiter, @mst_loop_cnt );
				SET @v_measure              = dbo.SCM_ARR_SPL_VAL( @p_measure             	    , @v_delimiter, @mst_loop_cnt );
				SET @v_yyyymmdd             = dbo.SCM_ARR_SPL_VAL( @p_yyyymmdd            	    , @v_delimiter, @mst_loop_cnt );
				SET @v_qty                  = dbo.SCM_ARR_SPL_VAL( @p_qty                 	    , @v_delimiter, @mst_loop_cnt );
				SET @v_fix                  = dbo.SCM_ARR_SPL_VAL( @p_fix                 	    , @v_delimiter, @mst_loop_cnt );
				SET @v_electrode_type       = dbo.SCM_ARR_SPL_VAL( @p_electrode_type       	    , @v_delimiter, @mst_loop_cnt );
				SET @v_origin_division_id   = dbo.SCM_ARR_SPL_VAL( @p_origin_division_id       	, @v_delimiter, @mst_loop_cnt );
				
				SET @v_created_by			= dbo.SCM_ARR_SPL_VAL( @p_user_id					, @v_delimiter, @mst_loop_cnt );
				SET @v_last_updated_by		= dbo.SCM_ARR_SPL_VAL( @p_user_id					, @v_delimiter, @mst_loop_cnt );

				IF( @v_qty ='') SET @v_qty =NULL; 

						--PRINT '6';
						--PRINT ' @v_valid_yn ='+ ISNULL(@v_valid_yn,'') ;
			END;

			-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '===============================================';			
				PRINT '@v_active_flag		  = ' + ISNULL(@v_active_flag        ,'') ;
				PRINT '@v_division_id         = ' + ISNULL(@v_division_id        ,'') ;
				PRINT '@v_plan_start_yyyymmdd = ' + ISNULL(@v_plan_start_yyyymmdd,'') ;
				PRINT '@v_plan_type           = ' + ISNULL(@v_plan_type          ,'') ;
				PRINT '@v_seq                 = ' + ISNULL(@v_seq                ,'') ;
				PRINT '@v_operation_group     = ' + ISNULL(@v_operation_group    ,'') ;
				PRINT '@v_scm_site_id         = ' + ISNULL(@v_scm_site_id        ,'') ;
				PRINT '@v_item_id             = ' + ISNULL(@v_item_id            ,'') ;
				PRINT '@v_line_id             = ' + ISNULL(@v_line_id            ,'') ;
				PRINT '@v_operation_id        = ' + ISNULL(@v_operation_id       ,'') ;
				PRINT '@v_measure             = ' + ISNULL(@v_measure            ,'') ;
				PRINT '@v_yyyymmdd            = ' + ISNULL(@v_yyyymmdd           ,'') ;
				PRINT '@v_qty                 = ' + ISNULL(@v_qty                ,'') ;
				PRINT '@v_fix                 = ' + ISNULL(@v_fix                ,'') ;				
				PRINT '@v_electrode_type      = ' + ISNULL(@v_electrode_type     ,'') ;				
				PRINT '@v_origin_division_id  = ' + ISNULL(@v_origin_division_id ,'') ;				
				PRINT '@v_created_by		  = ' + ISNULL(@v_created_by	   	 ,'');
				PRINT '@v_last_updated_by	  = ' + ISNULL(@v_last_updated_by	 ,'');


			END;

			------------------------------------------------------------------------------------------------------------------------------------------------------- 
			--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
			-------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ESS 가상 라인에 매핑된 JV 라인 계획 skip처리 (단방향 저장)' 
			-------------------------------------------------------------------------------------------------------------------------------------------------------
			IF EXISTS (SELECT TOP 1 'X' 
						 FROM #JV_ESS_LINE_MAP LM
							  INNER JOIN #JV_ESS_SCM_SITE_MAP SM WITH(NOLOCK)
									  ON SM.RP_COMPANY_ID	= LM.RL_COMPANY_ID
									 AND SM.RP_DIVISION_ID	= LM.RL_DIVISION_ID
									 AND SM.RP_SITE_ID		= LM.RL_SITE_ID
									 AND SM.RP_PLANT_ID		= LM.RL_PLANT_ID
						WHERE 1=1
						  AND SM.RP_DIVISION_ID	= @v_division_id
						  AND SM.RP_SCM_SITE_ID	= @v_scm_site_id
						  AND LM.RL_LINE_ID		= @v_line_id
						)  CONTINUE ;  -- ESS 가상 라인에 매핑된 JV Real line이면 skip  
			-------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ESS 가상 라인에 매핑된 동기화 대상 JV 라인 정보' 
			-------------------------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#JV_LINE_SYNC_TARGET')		IS NOT NULL DROP TABLE #JV_LINE_SYNC_TARGET
			SELECT DISTINCT SM.RP_DIVISION_ID
						  , SM.RP_SCM_SITE_ID
						  , LM.RL_LINE_ID
			 INTO #JV_LINE_SYNC_TARGET
			 FROM #JV_ESS_LINE_MAP LM
				  INNER JOIN #JV_ESS_SCM_SITE_MAP SM WITH(NOLOCK)
						  ON SM.VP_COMPANY_ID	= LM.VL_COMPANY_ID
						 AND SM.VP_DIVISION_ID	= LM.VL_DIVISION_ID
						 AND SM.VP_SITE_ID		= LM.VL_SITE_ID
						 AND SM.VP_PLANT_ID		= LM.VL_PLANT_ID
			WHERE 1=1
			  AND SM.VP_DIVISION_ID	= @v_division_id
			  AND SM.VP_SCM_SITE_ID	= @v_scm_site_id
			  AND LM.VL_LINE_ID		= @v_line_id
			------------------------------------------------------------------------------------------------------------------------------------------------------- 
			--### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
			------------------------------------------------------------------------------------------------------------------------------------------------------- 

		   --이력저장
			EXEC [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_HIST] @v_division_id, @v_plan_start_yyyymmdd, @v_plan_type, @v_seq, @v_operation_group, @v_scm_site_id, @v_item_id, @v_line_id, @v_operation_id, @v_measure, @v_yyyymmdd, @v_qty, @v_created_by, @v_creation_date, @v_last_updated_by, @v_origin_division_id, @v_electrode_type
			
			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		

					-- 수정
					IF( @v_active_flag ='M' OR @v_active_flag ='I') 
						BEGIN
							MERGE INTO scp_anl_production_plan A
							USING (
									SELECT 
											 @v_division_id          AS DIVISION_ID          					                                       
											,@v_plan_start_yyyymmdd  AS PLAN_START_YYYYMMDD  
											,@v_plan_type            AS PLAN_TYPE            
											,@v_seq                  AS SEQ                  
											,@v_operation_group      AS OPERATION_GROUP      
											,@v_scm_site_id          AS SCM_SITE_ID          
											,@v_item_id              AS ITEM_ID              
											,@v_line_id              AS LINE_ID              
											,@v_operation_id         AS OPERATION_ID         
											,@v_measure              AS MEASURE              
											,@v_yyyymmdd             AS YYYYMMDD                        
											,@v_electrode_type       AS ELECTRODE_TYPE

											
									) B
							ON(
										    A.DIVISION_ID          = B.DIVISION_ID          
										AND A.PLAN_START_YYYYMMDD  = B.PLAN_START_YYYYMMDD  
										AND A.PLAN_TYPE            = B.PLAN_TYPE            
										AND A.SEQ                  = B.SEQ                  
										AND A.OPERATION_GROUP      = B.OPERATION_GROUP      
										AND A.SCM_SITE_ID          = B.SCM_SITE_ID          
										AND A.ITEM_ID              = B.ITEM_ID              
										AND A.LINE_ID              = B.LINE_ID              
										AND A.OPERATION_ID         = B.OPERATION_ID         
										AND A.MEASURE              = B.MEASURE              
										AND A.YYYYMMDD             = B.YYYYMMDD           
										AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')  = ISNULL(NULLIF(B.ELECTRODE_TYPE,''),'-')

								)
							WHEN MATCHED THEN
									UPDATE 
									   SET DIVISION_ID          = @v_division_id         
										  ,PLAN_START_YYYYMMDD  = @v_plan_start_yyyymmdd 
										  ,PLAN_TYPE            = @v_plan_type           
										  ,SEQ                  = @v_seq                 
										  ,OPERATION_GROUP      = @v_operation_group     
										  ,SCM_SITE_ID          = @v_scm_site_id         
										  ,ITEM_ID              = @v_item_id             
										  ,LINE_ID              = @v_line_id             
										  ,OPERATION_ID         = @v_operation_id        
										  ,MEASURE              = @v_measure             
										  ,YYYYMMDD             = @v_yyyymmdd            
										  ,QTY                  = @v_qty                 
										  ,LAST_UPDATED_BY      = @v_last_updated_by     
										  ,LAST_UPDATE_DATE     = @v_creation_date
					                
							WHEN NOT MATCHED THEN
								INSERT 
										   (DIVISION_ID                     
										   ,PLAN_START_YYYYMMDD             
										   ,PLAN_TYPE                       
										   ,SEQ                             
										   ,OPERATION_GROUP                 
										   ,SCM_SITE_ID                     
										   ,ITEM_ID                         
										   ,LINE_ID                         
										   ,OPERATION_ID                    
										   ,MEASURE                         
										   ,YYYYMMDD                        
										   ,QTY                             
										   ,CREATED_BY                      
										   ,CREATION_DATE                   
										   ,LAST_UPDATED_BY                 
										   ,LAST_UPDATE_DATE   
										   ,ORIGIN_DIVISION_ID
										   ,ELECTRODE_TYPE             
										  )                                 
									 VALUES                                 
										   ( @v_division_id                 
											,@v_plan_start_yyyymmdd         
											,@v_plan_type                   
											,@v_seq                         
											,@v_operation_group             
											,@v_scm_site_id                 
											,@v_item_id                     
											,@v_line_id                     
											,@v_operation_id                
											,@v_measure                     
											,@v_yyyymmdd                    
											,@v_qty                         
											,@v_created_by                  
											,@v_creation_date               
											,@v_last_updated_by             
											,@v_creation_date     
											,@v_origin_division_id
											,@v_electrode_type       
										)
										;								

							------------------------------------------------------------------------------------------------------------------------------------------------------- 
							--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
							-- PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD 
							-------------------------------------------------------------------------------------------------------------------------------------------------------
							print  convert(varchar(30), getdate(), 121) + N' ESS 가상 라인에 매핑된 동기화 대상 JV 라인 계획 Insert/Update ' 
							-------------------------------------------------------------------------------------------------------------------------------------------------------
							MERGE INTO SCP_ANL_PRODUCTION_PLAN  TG
							USING (
									SELECT TG.RP_DIVISION_ID		AS DIVISION_ID
										  ,EP.PLAN_START_YYYYMMDD
										  ,PV.PLAN_TYPE			
										  ,PV.PLAN_SEQ				AS SEQ
										  ,EP.OPERATION_GROUP
										  ,TG.RP_SCM_SITE_ID		AS SCM_SITE_ID
										  ,EP.ITEM_ID
										  ,TG.RL_LINE_ID			AS LINE_ID
										  ,EP.OPERATION_ID
										  ,EP.MEASURE
										  ,EP.YYYYMMDD
										  ,EP.QTY
										  ,TG.RP_DIVISION_ID		AS ORIGIN_DIVISION_ID	-- 전극은 대상이 아니기 때문에 division_id와 origin division_id 일치 ?
										  ,EP.ELECTRODE_TYPE
										  ,EP.LAST_UPDATED_BY
										  ,EP.CELL_QTY
									 FROM SCP_ANL_PRODUCTION_PLAN EP WITH(NOLOCK)	 -- ESS Plan
										  INNER JOIN #JV_LINE_SYNC_TARGET TG
												  ON 1=1
										  INNER JOIN #DIVISION_LAST_PLAN_INFO PV 
												  ON PV.DIVISION_ID			= TG.RP_DIVISION_ID
												 AND PV.PLAN_START_YYYYMMDD	= EP.PLAN_START_YYYYMMDD
									WHERE EP.DIVISION_ID			= @v_division_id
									  AND EP.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
									  AND EP.PLAN_TYPE				= @v_plan_type
									  AND EP.SEQ					= @v_seq
									  AND EP.OPERATION_GROUP		= @v_operation_group
									  AND EP.SCM_SITE_ID			= @v_scm_site_id
									  AND EP.ITEM_ID				= @v_item_id
									  AND EP.LINE_ID				= @v_line_id
									  AND EP.OPERATION_ID			= @v_operation_id
									  AND EP.MEASURE				= @v_measure
									  AND EP.YYYYMMDD				= @v_yyyymmdd
								) AS SRC
							   ON TG.DIVISION_ID			=  SRC.DIVISION_ID		
							  AND TG.PLAN_START_YYYYMMDD	=  SRC.PLAN_START_YYYYMMDD
							  AND TG.PLAN_TYPE				=  SRC.PLAN_TYPE			
							  AND TG.SEQ					=  SRC.SEQ				
							  AND TG.OPERATION_GROUP		=  SRC.OPERATION_GROUP	
							  AND TG.SCM_SITE_ID			=  SRC.SCM_SITE_ID		
							  AND TG.ITEM_ID				=  SRC.ITEM_ID			
							  AND TG.LINE_ID				=  SRC.LINE_ID			
							  AND TG.OPERATION_ID			=  SRC.OPERATION_ID		
							  AND TG.MEASURE				=  SRC.MEASURE			
							  AND TG.YYYYMMDD				=  SRC.YYYYMMDD			
							WHEN MATCHED THEN
								 UPDATE 
									SET  TG.QTY                  = SRC.QTY 
										,TG.LAST_UPDATED_BY      = @v_last_updated_by   
										,TG.LAST_UPDATE_DATE     = GETDATE()
							WHEN NOT MATCHED THEN
								 INSERT (DIVISION_ID
										,PLAN_START_YYYYMMDD
										,PLAN_TYPE
										,SEQ
										,OPERATION_GROUP
										,SCM_SITE_ID
										,ITEM_ID
										,LINE_ID
										,OPERATION_ID
										,MEASURE
										,YYYYMMDD
										,QTY
										,ORIGIN_DIVISION_ID
										,ELECTRODE_TYPE
										,CREATED_BY
										,CREATION_DATE
										,LAST_UPDATED_BY
										,LAST_UPDATE_DATE
										,CELL_QTY
									)
								VALUES  (SRC.DIVISION_ID
										,SRC.PLAN_START_YYYYMMDD
										,SRC.PLAN_TYPE
										,SRC.SEQ
										,SRC.OPERATION_GROUP
										,SRC.SCM_SITE_ID
										,SRC.ITEM_ID
										,SRC.LINE_ID
										,SRC.OPERATION_ID
										,SRC.MEASURE
										,SRC.YYYYMMDD
										,SRC.QTY
										,SRC.ORIGIN_DIVISION_ID
										,SRC.ELECTRODE_TYPE
										,@v_last_updated_by
										,GETDATE()
										,@v_last_updated_by
										,GETDATE()
										,SRC.CELL_QTY
										) ;

							-------------------------------------------------------------------------------------------------------------------------------------------------------
							print  convert(varchar(30), getdate(), 121) + N' ESS 가상 라인에 매핑된 동기화 대상 JV 라인 계획 이력 생성' 
							-------------------------------------------------------------------------------------------------------------------------------------------------------
							INSERT INTO SCP_ANL_PRODUCTION_PLAN_H ( 
									  HISTORY_SEQ
									 ,DIVISION_ID
									 ,PLAN_START_YYYYMMDD
									 ,PLAN_TYPE
									 ,SEQ
									 ,OPERATION_GROUP
									 ,SCM_SITE_ID
									 ,ITEM_ID
									 ,LINE_ID
									 ,OPERATION_ID
									 ,MEASURE
									 ,YYYYMMDD
									 ,QTY
									 ,ORIGIN_DIVISION_ID
									 ,ELECTRODE_TYPE
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
									 ,HISTORY_CREATION_DATE
							)
							SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_H HISTORY_SEQ
								  ,PP.DIVISION_ID
								  ,PP.PLAN_START_YYYYMMDD
								  ,PP.PLAN_TYPE
								  ,PP.SEQ
								  ,PP.OPERATION_GROUP
								  ,PP.SCM_SITE_ID
								  ,PP.ITEM_ID
								  ,PP.LINE_ID
								  ,PP.OPERATION_ID
								  ,PP.MEASURE
								  ,PP.YYYYMMDD
								  ,PP.QTY
								  ,PP.ORIGIN_DIVISION_ID
								  ,PP.ELECTRODE_TYPE
								  ,PP.CREATED_BY
								  ,PP.CREATION_DATE
								  ,PP.LAST_UPDATED_BY
								  ,PP.LAST_UPDATE_DATE
								  ,PP.ATTRIBUTE1
								  ,PP.ATTRIBUTE2
								  ,PP.ATTRIBUTE3
								  ,PP.ATTRIBUTE4
								  ,PP.ATTRIBUTE5
								  ,PP.ATTRIBUTE6
								  ,PP.ATTRIBUTE7
								  ,PP.ATTRIBUTE8
								  ,PP.ATTRIBUTE9
								  ,PP.ATTRIBUTE10
								  ,GETDATE()	AS HISTORY_CREATION_DATE
							 FROM #JV_LINE_SYNC_TARGET TG
								  INNER JOIN #DIVISION_LAST_PLAN_INFO PV
										  ON PV.DIVISION_ID			= TG.RP_DIVISION_ID		-- JV division
										 AND PV.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
								  INNER JOIN SCP_ANL_PRODUCTION_PLAN PP WITH(NOLOCK) -- DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD
										  ON PP.DIVISION_ID			= TG.RP_DIVISION_ID		-- JV division
										 AND PP.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
										 AND PP.PLAN_TYPE			= PV.PLAN_TYPE
										 AND PP.SEQ					= PV.PLAN_SEQ 
										 AND PP.OPERATION_GROUP		= @v_operation_group
										 AND PP.SCM_SITE_ID			= TG.RP_SCM_SITE_ID		-- JV Real scm site_id 
										 AND PP.ITEM_ID				= @v_item_id
										 AND PP.LINE_ID				= TG.RL_LINE_ID			-- JV Real line 
										 AND PP.OPERATION_ID		= @v_operation_id
										 AND PP.MEASURE				= @v_measure
										 AND PP.YYYYMMDD			= @v_yyyymmdd
							WHERE 1=1
							------------------------------------------------------------------------------------------------------------------------------------------------------- 
							--### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
							-------------------------------------------------------------------------------------------------------------------------------------------------------

						END ;
					ELSE IF(@v_active_flag ='D')
						BEGIN
							DELETE FROM dbo.scp_anl_production_plan
							WHERE DIVISION_ID          = @v_division_id         
							  AND PLAN_START_YYYYMMDD  = @v_plan_start_yyyymmdd 
							  AND PLAN_TYPE            = @v_plan_type           
							  AND SEQ                  = @v_seq                 
							  AND OPERATION_GROUP      = @v_operation_group     
							  AND SCM_SITE_ID          = @v_scm_site_id         
							  AND ITEM_ID              = @v_item_id             
							  AND LINE_ID              = @v_line_id             
							  AND OPERATION_ID         = @v_operation_id        
							  AND MEASURE              = @v_measure             
							  AND YYYYMMDD             = @v_yyyymmdd   
							  AND ISNULL(NULLIF(ELECTRODE_TYPE,''),'-') = ISNULL(NULLIF(@v_electrode_type,''),'-')
							;    
							
							------------------------------------------------------------------------------------------------------------------------------------------------------- 
							--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
							-------------------------------------------------------------------------------------------------------------------------------------------------------
							print  convert(varchar(30), getdate(), 121) + N' ESS 가상 라인에 매핑된 동기화 대상 JV 라인 계획 삭제' 
							-------------------------------------------------------------------------------------------------------------------------------------------------------
							DELETE PP 
							 FROM #JV_LINE_SYNC_TARGET TG
								  INNER JOIN #DIVISION_LAST_PLAN_INFO PV 
										  ON PV.DIVISION_ID			= TG.RP_DIVISION_ID
										 AND PV.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
								  INNER JOIN SCP_ANL_PRODUCTION_PLAN PP WITH(NOLOCK) -- DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD
										  ON PP.DIVISION_ID			= TG.RP_DIVISION_ID		-- JV division
										 AND PP.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
										 AND PP.PLAN_TYPE			= PV.PLAN_TYPE
										 AND PP.SEQ					= PV.PLAN_SEQ 
										 AND PP.OPERATION_GROUP		= @v_operation_group
										 AND PP.SCM_SITE_ID			= TG.RP_SCM_SITE_ID		-- JV Real scm site_id 
										 AND PP.ITEM_ID				= @v_item_id
										 AND PP.LINE_ID				= TG.RL_LINE_ID			-- JV Real line 
										 AND PP.OPERATION_ID		= @v_operation_id
										 AND PP.MEASURE				= @v_measure
										 AND PP.YYYYMMDD			= @v_yyyymmdd
							WHERE 1=1
							------------------------------------------------------------------------------------------------------------------------------------------------------- 
							--### END : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
							------------------------------------------------------------------------------------------------------------------------------------------------------- 
						END; 	

					IF(@v_fix = 'Y')
						BEGIN
						    -- FIX데이타 수정
							UPDATE SCP_ANL_PRODUCTION_PLAN_FIX
								   SET qty			    = @v_qty
									  --,fix_reason	    = ''
									  ,last_updated_by  = @v_last_updated_by
									  ,last_update_date = @d_event_date
								WHERE 1=1
								  AND division_id     = @v_division_id
								  and operation_group = @v_operation_group
								  and scm_site_id     = @v_scm_site_id
								  and item_id         = @v_item_id
								  and line_id         = @v_line_id
								  and operation_id    = @v_operation_id
								  and yyyymmdd        = @v_yyyymmdd 	
								  and ISNULL(NULLIF(ELECTRODE_TYPE,''),'-') = ISNULL(NULLIF(@v_electrode_type,''),'-');

							--FIX_ID조회
							DECLARE @v_fix_id NVARCHAR(100)='';
							SELECT @v_fix_id = FIX_ID
							FROM SCP_ANL_PRODUCTION_PLAN_FIX A
							WHERE 1=1
								AND A.division_id     = @v_division_id
								and a.operation_group = @v_operation_group
								and a.scm_site_id     = @v_scm_site_id
								and a.item_id         = @v_item_id
								and a.line_id         = @v_line_id
								and a.operation_id    = @v_operation_id
								and a.yyyymmdd        = @v_yyyymmdd
								and ISNULL(NULLIF(a.ELECTRODE_TYPE,''),'-') = ISNULL(NULLIF(@v_electrode_type,''),'-');
							
							--이력저장
							EXEC [PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST]
								 @v_fix_id
								,@v_division_id
								,@v_operation_group
								,@v_scm_site_id
								,@v_item_id
								,@v_line_id
								,@v_operation_id
								,@v_yyyymmdd
								,@v_qty
								,''
								,@v_last_updated_by
								,@d_event_date
								,@v_last_updated_by	 
								,@v_origin_division_id
								,@v_electrode_type;

							------------------------------------------------------------------------------------------------------------------------------------------------------- 
							--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
							-------------------------------------------------------------------------------------------------------------------------------------------------------
							print  convert(varchar(30), getdate(), 121) + N' ESS 가상 라인에 매핑된 동기화 대상 JV 라인 계획 Fix 데이터 변경 ' 
							-------------------------------------------------------------------------------------------------------------------------------------------------------
							UPDATE PF 
							   SET PF.QTY				= @v_qty
							      ,PF.LAST_UPDATED_BY	= @v_last_updated_by 
								  ,PF.LAST_UPDATE_DATE	= GETDATE()
							 FROM #JV_LINE_SYNC_TARGET TG
								  INNER JOIN SCP_ANL_PRODUCTION_PLAN_FIX PF WITH(NOLOCK) -- FIX_ID, DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, YYYYMMDD
										  ON PF.DIVISION_ID			= TG.RP_DIVISION_ID
										 AND PF.OPERATION_GROUP		= @v_operation_group
										 AND PF.SCM_SITE_ID			= TG.RP_SCM_SITE_ID		-- JV Real scm site_id 
										 AND PF.ITEM_ID				= @v_item_id
										 AND PF.LINE_ID				= TG.RL_LINE_ID			-- JV Real line 
										 AND PF.OPERATION_ID		= @v_operation_id
										 AND PF.YYYYMMDD			= @v_yyyymmdd
							WHERE 1=1 
							;
							-------------------------------------------------------------------------------------------------------------------------------------------------------
							print  convert(varchar(30), getdate(), 121) + N' ESS 가상 라인에 매핑된 동기화 대상 JV 라인 계획 Fix 데이터 변경후 이력 생성 ' 
							-------------------------------------------------------------------------------------------------------------------------------------------------------
							INSERT INTO SCP_ANL_PRODUCTION_PLAN_FIX_H ( 
									    HISTORY_SEQ
									   ,FIX_ID
									   ,DIVISION_ID
									   ,OPERATION_GROUP
									   ,SCM_SITE_ID
									   ,ITEM_ID
									   ,LINE_ID
									   ,OPERATION_ID
									   ,YYYYMMDD
									   ,QTY
									   ,FIX_REASON
									   ,ORIGIN_DIVISION_ID
									   ,ELECTRODE_TYPE
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
									   ,HISTORY_CREATION_DATE
								)
							SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H AS HISTORY_SEQ
								  ,PF.FIX_ID
								  ,PF.DIVISION_ID
								  ,PF.OPERATION_GROUP
								  ,PF.SCM_SITE_ID
								  ,PF.ITEM_ID
								  ,PF.LINE_ID
								  ,PF.OPERATION_ID
								  ,PF.YYYYMMDD
								  ,PF.QTY
								  ,PF.FIX_REASON
								  ,PF.ORIGIN_DIVISION_ID
								  ,PF.ELECTRODE_TYPE
								  ,PF.CREATED_BY
								  ,PF.CREATION_DATE
								  ,PF.LAST_UPDATED_BY
								  ,PF.LAST_UPDATE_DATE
								  ,PF.ATTRIBUTE1
								  ,PF.ATTRIBUTE2
								  ,PF.ATTRIBUTE3
								  ,PF.ATTRIBUTE4
								  ,PF.ATTRIBUTE5
								  ,PF.ATTRIBUTE6
								  ,PF.ATTRIBUTE7
								  ,PF.ATTRIBUTE8
								  ,PF.ATTRIBUTE9
								  ,PF.ATTRIBUTE10
								  ,GETDATE()	AS HISTORY_CREATION_DATE 
							 FROM #JV_LINE_SYNC_TARGET TG
								  INNER JOIN SCP_ANL_PRODUCTION_PLAN_FIX PF WITH(NOLOCK) -- FIX_ID, DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, YYYYMMDD
										  ON PF.DIVISION_ID			= TG.RP_DIVISION_ID
										 AND PF.OPERATION_GROUP		= @v_operation_group
										 AND PF.SCM_SITE_ID			= TG.RP_SCM_SITE_ID		-- JV Real scm site_id 
										 AND PF.ITEM_ID				= @v_item_id
										 AND PF.LINE_ID				= TG.RL_LINE_ID			-- JV Real line 
										 AND PF.OPERATION_ID		= @v_operation_id
										 AND PF.YYYYMMDD			= @v_yyyymmdd
							WHERE 1=1
							;		
							------------------------------------------------------------------------------------------------------------------------------------------------------- 
							--### ENd : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
							-------------------------------------------------------------------------------------------------------------------------------------------------------
					END;
				END  -- END OF STMT. IF( @mst_loop_cnt > 0 )			
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;			
		
		------------------------------------------------------------------------------------------------------------------------------------------------------- 
		--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
		print  convert(varchar(30), getdate(), 121) + N' 임시테이블 정리' 
		-------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#JV_ESS_LINE_MAP')		IS NOT NULL DROP TABLE #JV_ESS_LINE_MAP
		IF OBJECT_ID('TEMPDB..#JV_ESS_SCM_SITE_MAP')	IS NOT NULL DROP TABLE #JV_ESS_SCM_SITE_MAP
		IF OBJECT_ID('TEMPDB..#JV_LINE_SYNC_TARGET')	IS NOT NULL DROP TABLE #JV_LINE_SYNC_TARGET
		------------------------------------------------------------------------------------------------------------------------------------------------------- 
		--### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
					  

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				     
			; 
		END;
	END CATCH;
END
