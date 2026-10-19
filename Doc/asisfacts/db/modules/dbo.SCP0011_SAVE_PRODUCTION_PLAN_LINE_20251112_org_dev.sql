
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
 */
CREATE PROCEDURE [dbo].[SCP0011_SAVE_PRODUCTION_PLAN_LINE_20251112_org_dev]
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
									
						END;
				END  -- END OF STMT. IF( @mst_loop_cnt > 0 )			
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;			
		
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
