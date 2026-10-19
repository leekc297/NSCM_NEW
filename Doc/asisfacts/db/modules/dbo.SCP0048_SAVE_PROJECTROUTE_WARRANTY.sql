
/*
 * Program ID   : SCP0048_SAVE_PROJECTROUTE_WARRANTY
 * Description  : Project Route Plant Site 등록,수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020-03-03   KIMYONGHO	신규추가 [C20200303-000208]Warranty Service 제품의 출하 계획 가시성 확보 및 실행 연계
 */
CREATE PROCEDURE [dbo].[SCP0048_SAVE_PROJECTROUTE_WARRANTY]
	 @p_active_flag		NVARCHAR(MAX)
	,@p_priority_seq		NVARCHAR(MAX)
	,@p_division_id		NVARCHAR(MAX)
	,@p_project_code		NVARCHAR(MAX)
	,@p_scm_site_id 		NVARCHAR(MAX)
	,@p_plant_site_id 		NVARCHAR(MAX)
	,@p_item_id 			NVARCHAR(MAX)
	,@p_created_by			NVARCHAR(MAX)
	,@p_creation_date		NVARCHAR(MAX)
	,@p_last_updated_by		NVARCHAR(MAX)

	,@p_priority			NVARCHAR(MAX)
	,@p_from_yyyymmdd		NVARCHAR(MAX)
	,@p_to_yyyymmdd		NVARCHAR(MAX)
	,@p_valid_yn			NVARCHAR(MAX)
	,@debug_mode             NVARCHAR(20) ='F'
AS

BEGIN

	SET NOCOUNT ON;


	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	--DECLARE @DEBUG_MODE NVARCHAR(20) ='FALSE';
	--DECLARE @DEBUG_MODE NVARCHAR(20) ='TRUE';

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	
	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_priority_seq		    NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_project_code 		NVARCHAR(MAX);
	DECLARE @v_scm_site_id 			NVARCHAR(MAX);
	DECLARE @v_plant_site_id		NVARCHAR(MAX);
	
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_s_valid_yn			NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	DECLARE @v_creation_date		DATETIME;
	DECLARE @v_last_updated_by		NVARCHAR(MAX);

	DECLARE @v_priority				NVARCHAR(MAX);
	DECLARE @v_from_yyyymmdd		NVARCHAR(MAX);
	DECLARE @v_to_yyyymmdd			NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);

	DECLARE @p_currency				NVARCHAR(MAX);
	DECLARE @p_liability_period		NVARCHAR(MAX);
	DECLARE @p_sales_plan_adjust_yn	NVARCHAR(MAX);
	DECLARE @p_item_hrcy_id			NVARCHAR(MAX);
	DECLARE @p_bpms_exist			NVARCHAR(MAX);


	SET @v_active_flag = NULL;
	SET @v_priority_seq= NULL;
	SET @v_division_id = NULL;
	SET @v_project_code = NULL;
	SET @v_scm_site_id = NULL;
	SET @v_item_id = NULL;
	SET @v_priority = NULL;
	SET @v_s_valid_yn = NULL;
	SET @v_created_by = NULL;	  
	SET @v_creation_date = NULL;
	SET @v_last_updated_by = NULL;

	SET @p_currency				 = NULL;
	SET @p_liability_period		 = NULL;
	SET @p_sales_plan_adjust_yn	 = NULL;
	SET @p_item_hrcy_id			 = NULL;
	SET @p_bpms_exist			 = 'Y';

	SET @v_priority = NULL;
	SET @v_from_yyyymmdd = NULL;
	SET @v_to_yyyymmdd = NULL;
	SET @v_valid_yn = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0048_SAVE_PROJECTROUTE_WARRANTY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY

		PRINT '1';

			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--PRINT '2';
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
			--PRINT '3';	
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				--PRINT '4';
				SET @v_priority_seq		= [dbo].[SCM_ARR_SPL_VAL](@p_priority_seq	, @v_delimiter , @mst_loop_cnt) ;    
				IF(ISNULL(@v_priority_seq,'') ='')
					SET @v_priority_seq = NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_PRIORITY;
				--PRINT '5';

				SET @v_active_flag		= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag	, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_division_id		= [dbo].[SCM_ARR_SPL_VAL](@p_division_id	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_project_code		= [dbo].[SCM_ARR_SPL_VAL](@p_project_code	, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_scm_site_id		= [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_plant_site_id	= [dbo].[SCM_ARR_SPL_VAL](@p_plant_site_id	, @v_delimiter , @mst_loop_cnt) ; 				   				
				SET @v_item_id			= [dbo].[SCM_ARR_SPL_VAL](@p_item_id		, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_s_valid_yn		= (select t.VALID_YN from scm_mst_site_item t where t.division_id = @v_division_id AND t.SCM_SITE_ID =@v_scm_site_id AND t.ITEM_ID = @v_item_id AND t.project_code =@v_project_code)
				SET @v_created_by		= [dbo].[SCM_ARR_SPL_VAL](@p_created_by		, @v_delimiter, @mst_loop_cnt) ; 
				--SET @v_creation_date	= CONVERT(DATETIME, [dbo].[SCM_ARR_SPL_VAL](@p_creation_date, @v_delimiter, @mst_loop_cnt) , 112);
				SET @v_creation_date	=  [dbo].[SCM_ARR_SPL_VAL](@p_creation_date, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_last_updated_by	= [dbo].[SCM_ARR_SPL_VAL](@p_last_updated_by, @v_delimiter, @mst_loop_cnt) ; 

				SET @v_priority			= [dbo].[SCM_ARR_SPL_VAL](@p_priority		, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_from_yyyymmdd	= [dbo].[SCM_ARR_SPL_VAL](@p_from_yyyymmdd	, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_to_yyyymmdd		= [dbo].[SCM_ARR_SPL_VAL](@p_to_yyyymmdd	, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_valid_yn			= [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn		, @v_delimiter, @mst_loop_cnt) ; 
				--PRINT '6';
			END

			-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '===============================================';			
				PRINT '@v_active_flag     = ''' +@v_active_flag +'''';
				PRINT '@v_priority_seq    = ''' +@v_priority_seq +'''';
				PRINT '@v_division_id     = ''' +@v_division_id +'''';
				PRINT '@v_project_code    = ''' +@v_project_code +'''';
				PRINT '@v_scm_site_id     = ''' +@v_scm_site_id +'''';
				PRINT '@v_plant_site_id   = ''' +@v_plant_site_id +'''';				
				PRINT '@v_item_id         = ''' +@v_item_id +'''';
				PRINT '@v_s_valid_yn      = ''' +@v_s_valid_yn +'''';
				PRINT '@v_priority        = ''' +@v_priority +'''';
				PRINT '@v_from_yyyymmdd   = ''' +@v_from_yyyymmdd +'''';
				PRINT '@v_to_yyyymmdd     = ''' +@v_to_yyyymmdd +'''';
				PRINT '@v_valid_yn        = ''' +@v_valid_yn +'''';
				PRINT '@v_last_updated_by = ''' +@v_last_updated_by +'''';				
				PRINT '@mst_loop_cnt      = ''' +CONVERT(VARCHAR(10), @mst_loop_cnt) +'''';				


			END;

		   --이력저장
			--EXEC [PR_SCM_MST_SITE_ITEM_HIST] @v_division_id,@v_project_code,@v_scm_site_id,@v_item_id,@p_currency,@p_liability_period,@p_sales_plan_adjust_yn,@p_item_hrcy_id,@v_s_valid_yn,@p_bpms_exist,@v_created_by,@v_creation_date,@v_last_updated_by ; 
			EXEC [PR_SCM_MST_SITE_ITEM_HIST] @v_division_id,@v_project_code,@v_plant_site_id,@v_item_id,@p_currency,@p_liability_period,@p_sales_plan_adjust_yn,@p_item_hrcy_id,@v_s_valid_yn,@p_bpms_exist,@v_created_by,@v_creation_date,@v_last_updated_by ; 
			EXEC [PR_SCM_MST_SITE_ITEM_PRIORITY_HIST] @v_priority_seq,@v_division_id,@v_project_code,@v_scm_site_id ,@v_plant_site_id,@v_item_id ,@v_priority,@v_from_yyyymmdd,@v_to_yyyymmdd,@v_valid_yn,@v_created_by,@v_creation_date,@v_last_updated_by ;
			
			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		
					MERGE INTO SCM_MST_SITE_ITEM A
					USING (
							SELECT 
									 @v_division_id as division_id
									,@v_project_code as project_code
									,@v_plant_site_id as scm_site_id
									,@v_item_id	 as	 item_id
							) B
					ON(
									a.division_id = b.division_id
								AND a.project_code = b.project_code
								AND	a.scm_site_id = b.scm_site_id
								AND	a.item_id = b.item_id
						)
					WHEN MATCHED THEN
							UPDATE SET 	
								-- valid_yn			  = @v_valid_yn
								 last_updated_by	  = @v_last_updated_by
								,last_update_date	  = sysdatetime()
					                
					WHEN NOT MATCHED THEN
					INSERT	(		
								 division_id,project_code,scm_site_id,item_id
								,currency,liability_period,sales_plan_adjust_yn,item_hrcy_id
								,valid_yn,bpms_exist
								,created_by, creation_date, last_updated_by, last_update_date
							)
					VALUES  (
					 			 @v_division_id,@v_project_code,@v_plant_site_id,@v_item_id
								,null,null,null,null
								,'Y','Y'
								,@v_created_by, SYSDATETIME(), @v_created_by, SYSDATETIME()
							);


					-- SCM_MST_SITE_ITEM_PRIORITY입력/수정
					IF( @v_active_flag ='M') 
						BEGIN
							UPDATE SCM_MST_SITE_ITEM_PRIORITY
							SET  SALES_SITE_ID        = @v_scm_site_id
								,PLANT_SITE_ID        = @v_plant_site_id
							    ,priority			  = @v_priority
								,from_yyyymmdd		  = @v_from_yyyymmdd
								,to_yyyymmdd		  = @v_to_yyyymmdd
								,valid_yn			  = @v_valid_yn
								,last_updated_by	  = @v_last_updated_by
								,last_update_date	  = sysdatetime()
							WHERE priority_seq   = @v_priority_seq
							;

							  
						END
					ELSE IF(@v_active_flag ='I') 
						BEGIN
							INSERT INTO SCM_MST_SITE_ITEM_PRIORITY(		
									 priority_seq,division_id,project_code,SALES_SITE_ID,PLANT_SITE_ID,item_id
									,priority,from_yyyymmdd,to_yyyymmdd,valid_yn
									,created_by, creation_date, last_updated_by, last_update_date
								)
							VALUES  (
					 				 @v_priority_seq,@v_division_id,@v_project_code,@v_scm_site_id,@v_plant_site_id,@v_item_id
									,@v_priority,@v_from_yyyymmdd,@v_to_yyyymmdd,@v_valid_yn
									,@v_created_by, SYSDATETIME(), @v_created_by, SYSDATETIME()
								);
	
						END
				END  -- END OF STMT. IF( @mst_loop_cnt > 0 )			
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		COMMIT TRAN;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 

		  if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리

		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
	END
