/*
 * Program ID   : SCP0030_SAVE_BOD_ITEM
 * Description  : BOD ITEM 등록, 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/09/10   ygkim			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/11/23	ywoon			SAFETY_STOCK 추가
 */
CREATE PROCEDURE [dbo].[SCP0030_SAVE_BOD_ITEM]
	 @p_active_flag 	  NVARCHAR(MAX)
	,@p_seq				  NVARCHAR(MAX)
	,@p_bod_id            NVARCHAR(MAX)
	,@p_division_id       NVARCHAR(MAX)
	,@p_item_id			  NVARCHAR(MAX)
	,@p_priority          NVARCHAR(MAX)
	,@p_from_yyyymmdd     NVARCHAR(MAX)
	,@p_to_yyyymmdd       NVARCHAR(MAX)
	,@p_safety_stock      NVARCHAR(MAX)=null
	,@p_valid_yn          NVARCHAR(MAX)
	,@p_user_id           NVARCHAR(MAX)
	
	,@debug_mode          NVARCHAR(1) ='F'
AS

BEGIN

	DECLARE @v_working_time       datetime =sysdatetime();     
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;


	DECLARE @v_active_flag       NVARCHAR(MAX);  
	DECLARE @v_seq	             NVARCHAR(MAX);  
	DECLARE @v_bod_id            NVARCHAR(MAX);  
	DECLARE @v_division_id       NVARCHAR(MAX);   
	DECLARE @v_item_id			 NVARCHAR(MAX);   
	DECLARE @v_safety_stock		 NVARCHAR(MAX);   
	DECLARE @v_priority          NVARCHAR(MAX);   
	DECLARE @v_from_yyyymmdd     NVARCHAR(MAX);   
	DECLARE @v_to_yyyymmdd       NVARCHAR(MAX); 
	DECLARE @v_valid_yn          NVARCHAR(MAX);   
	DECLARE @v_created_by        NVARCHAR(MAX);
	DECLARE @v_creation_date     datetime	;
	DECLARE @v_last_updated_by   NVARCHAR(MAX);
	DECLARE @v_last_update_date  datetime	;

	SET @v_created_by       = @p_user_id;
	SET @v_creation_date    = @v_working_time;
	SET @v_last_updated_by  = @p_user_id
	SET @v_last_update_date = @v_working_time
	
	SET @v_active_flag   = NULL;
	SET @v_seq           = NULL;
	SET @v_bod_id        = NULL;
	SET @v_division_id   = NULL;
	SET @v_item_id		 = NULL;
	SET @v_safety_stock	 = NULL;
	SET @v_priority      = NULL;
	SET @v_from_yyyymmdd = NULL;
	SET @v_to_yyyymmdd   = NULL;
	SET @v_valid_yn      = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	DECLARE @mst_loop_cnt_chk	INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0030_SAVE_BOM_ITEM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	DECLARE @v_dup_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY

			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
				
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag   = dbo.SCM_ARR_SPL_VAL( @p_active_flag       , @v_delimiter, @mst_loop_cnt );
				SET @v_seq	         = dbo.SCM_ARR_SPL_VAL( @p_seq              , @v_delimiter, @mst_loop_cnt );
				SET @v_bod_id        = dbo.SCM_ARR_SPL_VAL( @p_bod_id            , @v_delimiter, @mst_loop_cnt );
				SET @v_division_id   = dbo.SCM_ARR_SPL_VAL( @p_division_id       , @v_delimiter, @mst_loop_cnt );
				SET @v_item_id		 = dbo.SCM_ARR_SPL_VAL( @p_item_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_safety_stock	 = dbo.SCM_ARR_SPL_VAL( @p_safety_stock     , @v_delimiter, @mst_loop_cnt );
				SET @v_priority      = dbo.SCM_ARR_SPL_VAL( @p_priority         , @v_delimiter, @mst_loop_cnt );
				SET @v_from_yyyymmdd = dbo.SCM_ARR_SPL_VAL( @p_from_yyyymmdd           , @v_delimiter, @mst_loop_cnt );
				SET @v_to_yyyymmdd   = dbo.SCM_ARR_SPL_VAL( @p_to_yyyymmdd         , @v_delimiter, @mst_loop_cnt );
				SET @v_valid_yn      = dbo.SCM_ARR_SPL_VAL( @p_valid_yn          , @v_delimiter, @mst_loop_cnt );
			END;

			-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '=================INPUT==============================';			
				PRINT '@mst_loop_cnt     = ' + CONVERT(VARCHAR,@mst_loop_cnt)   ;
				PRINT '@v_active_flag    = ' + @v_active_flag   ;
				PRINT '@v_seq            = ' + @v_seq        ;
				PRINT '@v_bod_id         = ' + @v_bod_id        ;
				PRINT '@v_division_id    = ' + @v_division_id   ;
				PRINT '@v_item_id		 = ' + @v_item_id ;
				PRINT '@v_safety_stock	 = ' + @v_safety_stock ;
				PRINT '@v_priority		 = ' + @v_priority ;
				PRINT '@v_from_yyyymmdd  = ' + @v_from_yyyymmdd     ;
				PRINT '@v_to_yyyymmdd    = ' + @v_to_yyyymmdd       ;
				PRINT '@v_valid_yn       = ' + @v_valid_yn      ;

			END;

			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		
					-- 수정
					IF( @v_active_flag ='M' OR @v_active_flag ='I') 
						BEGIN
							
							IF ISNULL(@v_seq,'') = '' or @v_seq is null
								BEGIN
									SET @v_seq = NEXT VALUE FOR SEQ1_SCP_MST_BOD_ITEM
								END
							
							 --이력저장
							EXEC [dbo].[PR_SCP_MST_BOD_ITEM_HIST]
									 @v_seq           
									,@v_bod_id      
									,@v_division_id        
									,@v_item_id          
									,@v_priority        
									,@v_from_yyyymmdd     
									,@v_to_yyyymmdd      
									,@v_safety_stock
									,@v_valid_yn         
									,@v_created_by       
									,@v_creation_date    
									,@v_last_updated_by  
									,@v_last_update_date ;

							MERGE INTO SCP_MST_BOD_ITEM A
							USING (
									SELECT @v_seq as seq
									) B
							ON(
										A.seq = B.seq
								)
							WHEN MATCHED THEN
								UPDATE 
								   SET division_id      = @v_division_id      
									  ,from_yyyymmdd    = @v_from_yyyymmdd 
									  ,to_yyyymmdd      = @v_to_yyyymmdd  
									  ,priority         = @v_priority         
									  ,safety_stock		= @v_safety_stock  
									  ,valid_yn         = @v_valid_yn         
									  ,last_updated_by  = @v_last_updated_by  
									  ,last_update_date = @v_last_update_date 
					                
							WHEN NOT MATCHED THEN							                                             
								INSERT 
									   (seq
									   ,division_id
									   ,bod_id
									   ,item_id
									   ,priority
									   ,from_yyyymmdd
									   ,to_yyyymmdd
									   ,safety_stock
									   ,valid_yn
									   ,created_by
									   ,creation_date
									   ,last_updated_by
									   ,last_update_date
									   )
								 VALUES
									   ( @v_seq                
										,@v_division_id           
										,@v_bod_id
										,@v_item_id             
										,@v_priority               
										,@v_from_yyyymmdd             
										,@v_to_yyyymmdd    
										,@v_safety_stock       
										,@v_valid_yn              
										,@v_created_by            
										,@v_creation_date         
										,@v_last_updated_by       
										,@v_last_update_date      
									   ); 
						END ;
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

		END;
	END CATCH;
END
