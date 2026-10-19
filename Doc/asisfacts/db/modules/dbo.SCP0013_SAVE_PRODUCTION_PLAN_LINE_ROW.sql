/*
 * Program ID   : [SCP0011_SAVE_PRODUCTION_PLAN_LINE]
 * Description  : Production Plan의 Line "Prod. Plan(Amend)" Measure저장(ROW단위 저장방식으로 변경)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/05   PJS		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/18	YHW		전극용 저장항목 추가
 */
CREATE PROCEDURE [dbo].[SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW]
	 @p_active_flag 	     NVARCHAR(MAX)
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
	,@p_origin_division_id   NVARCHAR(MAX)
	,@p_electrode_type       NVARCHAR(MAX)
	,@p_yyyymmdd             NVARCHAR(MAX)
	,@p_qty                  NVARCHAR(MAX)
	,@p_user_id              NVARCHAR(MAX)
	,@p_fix                  NVARCHAR(MAX)
	,@p_loc_flag             NVARCHAR(1) 
	,@p_program_id           NVARCHAR(200) ='SCP0013'
	,@debug_mode             NVARCHAR(1) ='F'
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @v_created_by       NVARCHAR(MAX)=@p_user_id;
	DECLARE @v_creation_date    datetime =SYSDATETIME(); 
	DECLARE @v_last_updated_by  NVARCHAR(MAX)=@p_user_id;
	
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW]';
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

		IF( ISNULL(@p_loc_flag,'') ='F')
			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



		-- LOOP 파라미터 출력 DEBUG용			
		IF (@debug_mode ='T') 
		BEGIN		
			PRINT '===============================================';			
			PRINT '@p_active_flag		  = ' + ISNULL(@p_active_flag        ,'') ;
			PRINT '@p_division_id         = ' + ISNULL(@p_division_id        ,'') ;
			PRINT '@p_plan_start_yyyymmdd = ' + ISNULL(@p_plan_start_yyyymmdd,'') ;
			PRINT '@p_plan_type           = ' + ISNULL(@p_plan_type          ,'') ;
			PRINT '@p_seq                 = ' + ISNULL(@p_seq                ,'') ;
			PRINT '@p_operation_group     = ' + ISNULL(@p_operation_group    ,'') ;
			PRINT '@p_scm_site_id         = ' + ISNULL(@p_scm_site_id        ,'') ;
			PRINT '@p_item_id             = ' + ISNULL(@p_item_id            ,'') ;
			PRINT '@p_line_id             = ' + ISNULL(@p_line_id            ,'') ;
			PRINT '@p_operation_id        = ' + ISNULL(@p_operation_id       ,'') ;
			PRINT '@p_measure             = ' + ISNULL(@p_measure            ,'') ;
			PRINT '@p_origin_division_id  = ' + ISNULL(@p_origin_division_id ,'') ;
			PRINT '@p_electrode_type      = ' + ISNULL(@p_electrode_type     ,'') ;
			PRINT '@p_yyyymmdd            = ' + ISNULL(@p_yyyymmdd           ,'') ;
			PRINT '@p_qty                 = ' + ISNULL(@p_qty                ,'') ;
			PRINT '@p_fix                 = ' + ISNULL(@p_fix                ,'') ;				
			PRINT '@p_created_by		  = ' + ISNULL(@v_created_by	   	 ,'');
			PRINT '@p_last_updated_by	  = ' + ISNULL(@v_last_updated_by	 ,'');

		END;

		--이력저장
		EXEC [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_HIST] @p_division_id, @p_plan_start_yyyymmdd, @p_plan_type, @p_seq, @p_operation_group, @p_scm_site_id, @p_item_id, @p_line_id, @p_operation_id, @p_measure, @p_yyyymmdd, @p_qty, @v_created_by, @v_creation_date, @v_last_updated_by,@p_origin_division_id,@p_electrode_type
			
	
		-- 수정
		IF( @p_active_flag ='M' OR @p_active_flag ='I') 
			BEGIN
				MERGE INTO scp_anl_production_plan A
				USING (
						SELECT 
								 @p_division_id          AS DIVISION_ID          					                                       
								,@p_plan_start_yyyymmdd  AS PLAN_START_YYYYMMDD  
								,@p_plan_type            AS PLAN_TYPE            
								,@p_seq                  AS SEQ                  
								,@p_operation_group      AS OPERATION_GROUP      
								,@p_scm_site_id          AS SCM_SITE_ID          
								,@p_item_id              AS ITEM_ID              
								,@p_line_id              AS LINE_ID              
								,@p_operation_id         AS OPERATION_ID         
								,@p_measure              AS MEASURE              
								,@p_yyyymmdd             AS YYYYMMDD                        
								,@p_electrode_type       AS ELECTRODE_TYPE                      
											
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
							 SET DIVISION_ID          = @p_division_id         
								,PLAN_START_YYYYMMDD  = @p_plan_start_yyyymmdd 
								,PLAN_TYPE            = @p_plan_type           
								,SEQ                  = @p_seq                 
								,OPERATION_GROUP      = @p_operation_group     
								,SCM_SITE_ID          = @p_scm_site_id         
								,ITEM_ID              = @p_item_id             
								,LINE_ID              = @p_line_id             
								,OPERATION_ID         = @p_operation_id        
								,MEASURE              = @p_measure             
								,YYYYMMDD             = @p_yyyymmdd            
								,QTY                  = @p_qty                 
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
								,ORIGIN_DIVISION_ID
								,ELECTRODE_TYPE                     
								,YYYYMMDD                        
								,QTY                             
								,CREATED_BY                      
								,CREATION_DATE                   
								,LAST_UPDATED_BY                 
								,LAST_UPDATE_DATE                
								)                                 
							VALUES                                 
								(@p_division_id                 
								,@p_plan_start_yyyymmdd         
								,@p_plan_type                   
								,@p_seq                         
								,@p_operation_group             
								,@p_scm_site_id                 
								,@p_item_id                     
								,@p_line_id                     
								,@p_operation_id                
								,@p_measure 
								,@p_origin_division_id
								,@p_electrode_type
								,@p_yyyymmdd                    
								,@p_qty                         
								,@v_created_by                  
								,@v_creation_date               
								,@v_last_updated_by             
								,@v_creation_date            
							)
							;								
				END ;
		ELSE IF(@p_active_flag ='D')
			BEGIN
				DELETE FROM dbo.scp_anl_production_plan
				  WHERE DIVISION_ID          = @p_division_id         
					AND PLAN_START_YYYYMMDD  = @p_plan_start_yyyymmdd 
					AND PLAN_TYPE            = @p_plan_type           
					AND SEQ                  = @p_seq                 
					AND OPERATION_GROUP      = @p_operation_group     
					AND SCM_SITE_ID          = @p_scm_site_id         
					AND ITEM_ID              = @p_item_id             
					AND LINE_ID              = @p_line_id             
					AND OPERATION_ID         = @p_operation_id        
					AND MEASURE              = @p_measure             
					AND YYYYMMDD             = @p_yyyymmdd  
					AND ISNULL(NULLIF(ELECTRODE_TYPE,''),'-')  = ISNULL(NULLIF(@p_electrode_type,''),'-')            
				;     
			END; 	

		IF(@p_fix = 'Y')
			BEGIN
				-- FIX데이타 수정
				UPDATE SCP_ANL_PRODUCTION_PLAN_FIX
						SET qty			    = @p_qty
							--,fix_reason	    = ''
							,last_updated_by  = @v_last_updated_by
							,last_update_date = @v_creation_date
					WHERE 1=1
						AND division_id     = @p_division_id
						and operation_group = @p_operation_group
						and scm_site_id     = @p_scm_site_id
						and item_id         = @p_item_id
						and line_id         = @p_line_id
						and operation_id    = @p_operation_id
						and yyyymmdd        = @p_yyyymmdd 	
						and ISNULL(NULLIF(ELECTRODE_TYPE,''),'-')  = ISNULL(NULLIF(@p_electrode_type,''),'-');

				--FIX_ID조회
				DECLARE @v_fix_id NVARCHAR(100)='';
				SELECT @v_fix_id = FIX_ID
				FROM SCP_ANL_PRODUCTION_PLAN_FIX A
				WHERE 1=1
					AND A.division_id     = @p_division_id
					and a.operation_group = @p_operation_group
					and a.scm_site_id     = @p_scm_site_id
					and a.item_id         = @p_item_id
					and a.line_id         = @p_line_id
					and a.operation_id    = @p_operation_id
					and a.yyyymmdd        = @p_yyyymmdd
					and ISNULL(NULLIF(a.ELECTRODE_TYPE,''),'-')  = ISNULL(NULLIF(@p_electrode_type,''),'-');
							
				--이력저장
				EXEC [PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST]
					 @v_fix_id
					,@p_division_id
					,@p_operation_group
					,@p_scm_site_id
					,@p_item_id
					,@p_line_id
					,@p_operation_id
					,@p_yyyymmdd
					,@p_qty
					,''
					,@v_last_updated_by
					,@d_event_date
					,@v_last_updated_by	 
					,@p_origin_division_id	 
					,@p_electrode_type;
									
			END;
			
			
		

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		
		IF( ISNULL(@p_loc_flag,'') ='L')
			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;			
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  1 AS result_cnt ;

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
