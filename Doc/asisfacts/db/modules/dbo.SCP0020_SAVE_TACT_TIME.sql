/*
 * Program ID   : [SCP0020_SAVE_TACT_TIME]
 * Description  : Tac Time 등록, 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/27   pjs				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/30	yhw				yield 소수점저장
 * 2018/09/17	yhw				Tact Time 조회항목 추가(item UOM, UOM Convert)
 * 2019/12/09	yhw				Tact Time 삭제기능 추가
 * 2019/12/13	yhw				Lane Qty 항목 추가(입력/수정 가능)
 * 2020/04/23	yhw				Lane Qty 저장 시 빈 값이면 null 처리
 *
 */
CREATE PROCEDURE [dbo].[SCP0020_SAVE_TACT_TIME]
	 @p_active_flag        NVARCHAR(MAX)
	,@p_division_id        NVARCHAR(MAX)
	,@p_plant_site_id      NVARCHAR(MAX)
	,@p_item_id            NVARCHAR(MAX)
	,@p_operation_id       NVARCHAR(MAX)
	,@p_line_id            NVARCHAR(MAX)
	,@p_priority           NVARCHAR(MAX)
	,@p_tact_time          NVARCHAR(MAX)
	,@p_yield              NVARCHAR(MAX)
	,@p_valid_yn           NVARCHAR(MAX)

	--,@p_key_division_id    NVARCHAR(MAX)
	--,@p_key_plant_site_id  NVARCHAR(MAX)
	--,@p_key_item_id        NVARCHAR(MAX)
	--,@p_key_operation_id   NVARCHAR(MAX)
	--,@p_key_line_id        NVARCHAR(MAX)
	,@p_input_status		NVARCHAR(MAX)
	,@p_item_uom			NVARCHAR(MAX)
	,@p_uom_convert_value   NVARCHAR(MAX)
	,@p_lane_qty			NVARCHAR(MAX)

	,@p_user_id            NVARCHAR(MAX)
	,@debug_mode           NVARCHAR(1) ='F'
AS

BEGIN

	SET NOCOUNT ON;
	
	DECLARE @v_working_time     datetime =sysdatetime();     
	DECLARE @recv_active_flag	NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;


	DECLARE @v_active_flag        NVARCHAR(MAX);
	DECLARE @v_division_id        NVARCHAR(MAX);
	DECLARE @v_plant_site_id      NVARCHAR(MAX);
	DECLARE @v_item_id            NVARCHAR(MAX);
	DECLARE @v_operation_id       NVARCHAR(MAX);
	DECLARE @v_line_id            NVARCHAR(MAX);
	DECLARE @v_priority           NVARCHAR(MAX);
	DECLARE @v_tact_time          NVARCHAR(MAX);
	DECLARE @v_yield              NVARCHAR(MAX);
	DECLARE @v_valid_yn           NVARCHAR(MAX);

	DECLARE @v_created_by        NVARCHAR(MAX);
	DECLARE @v_creation_date     datetime	;
	DECLARE @v_last_updated_by   NVARCHAR(MAX);
	DECLARE @v_last_update_date  datetime	;

	--DECLARE @v_key_division_id    NVARCHAR(MAX) ;
	--DECLARE @v_key_plant_site_id  NVARCHAR(MAX) ;
	--DECLARE @v_key_item_id        NVARCHAR(MAX) ;
	--DECLARE @v_key_operation_id   NVARCHAR(MAX) ;
	--DECLARE @v_key_line_id        NVARCHAR(MAX) ;
	DECLARE @v_input_status			NVARCHAR(MAX) ;
	DECLARE @v_item_uom				NVARCHAR(MAX) ;
	DECLARE @v_uom_convert_value    NVARCHAR(MAX) ;
	DECLARE @v_lane_qty				NVARCHAR(MAX) ;


	
	DECLARE @v_transport_mode    NVARCHAR(100) = ''; --에러반환용


	SET @v_created_by       = @p_user_id;
	SET @v_creation_date    = @v_working_time;
	SET @v_last_updated_by  = @p_user_id
	SET @v_last_update_date = @v_working_time

	SET @v_active_flag   = NULL;
	SET @v_division_id   = NULL;
	SET @v_plant_site_id = NULL;
	SET @v_item_id       = NULL;
	SET @v_operation_id  = NULL;
	SET @v_line_id       = NULL;
	SET @v_priority      = NULL;
	SET @v_tact_time     = NULL;
	SET @v_yield         = NULL;
	SET @v_valid_yn      = NULL;

	--SET @v_key_division_id   = NULL;
	--SET @v_key_plant_site_id = NULL;
	--SET @v_key_item_id       = NULL;
	--SET @v_key_operation_id  = NULL;
	--SET @v_key_line_id       = NULL;
	SET @v_input_status			= NULL;
	SET @v_item_uom				= NULL;
	SET @v_uom_convert_value	= NULL;
	SET @v_lane_qty	= NULL;



	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SCP0020_SAVE_TAC_TIME]';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	DECLARE @v_data_dup_cnt  INT=0;
	DECLARE @v_data_dup_priority_cnt  INT=0;
	
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

				SET @v_active_flag   = dbo.SCM_ARR_SPL_VAL(@p_active_flag  , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_division_id   = dbo.SCM_ARR_SPL_VAL(@p_division_id  , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_plant_site_id = dbo.SCM_ARR_SPL_VAL(@p_plant_site_id, @v_delimiter, @mst_loop_cnt ) ;
				SET @v_item_id       = dbo.SCM_ARR_SPL_VAL(@p_item_id      , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_operation_id  = dbo.SCM_ARR_SPL_VAL(@p_operation_id , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_line_id       = dbo.SCM_ARR_SPL_VAL(@p_line_id      , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_priority      = dbo.SCM_ARR_SPL_VAL(@p_priority     , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_tact_time     = dbo.SCM_ARR_SPL_VAL(@p_tact_time    , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_yield         = dbo.SCM_ARR_SPL_VAL(@p_yield        , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_valid_yn      = dbo.SCM_ARR_SPL_VAL(@p_valid_yn     , @v_delimiter, @mst_loop_cnt ) ;

				--SET @v_key_division_id   = dbo.SCM_ARR_SPL_VAL(@p_key_division_id  , @v_delimiter, @mst_loop_cnt ) ;
				--SET @v_key_plant_site_id = dbo.SCM_ARR_SPL_VAL(@p_key_plant_site_id, @v_delimiter, @mst_loop_cnt ) ;
				--SET @v_key_item_id       = dbo.SCM_ARR_SPL_VAL(@p_key_item_id      , @v_delimiter, @mst_loop_cnt ) ;
				--SET @v_key_operation_id  = dbo.SCM_ARR_SPL_VAL(@p_key_operation_id , @v_delimiter, @mst_loop_cnt ) ;
				--SET @v_key_line_id       = dbo.SCM_ARR_SPL_VAL(@p_key_line_id      , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_input_status			= dbo.SCM_ARR_SPL_VAL(@p_input_status		, @v_delimiter, @mst_loop_cnt ) ;

				SET @v_item_uom				= dbo.SCM_ARR_SPL_VAL(@p_item_uom			, @v_delimiter, @mst_loop_cnt ) ;
				SET @v_uom_convert_value	= dbo.SCM_ARR_SPL_VAL(@p_uom_convert_value	, @v_delimiter, @mst_loop_cnt ) ;
				SET @v_lane_qty				= dbo.SCM_ARR_SPL_VAL(@p_lane_qty			, @v_delimiter, @mst_loop_cnt ) ;

			END;

			SET @v_yield= (case when  @v_yield ='' or  @v_yield =null then null else convert(float, @v_yield)/100 end) ;        
			SET @v_uom_convert_value= (case when  @v_uom_convert_value ='' or  @v_uom_convert_value =null then null else @v_uom_convert_value end) ;
			SET @v_lane_qty = (case when  @v_lane_qty ='' or  @v_lane_qty =null then null else @v_lane_qty end) ;

			-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '===============================================';			
				PRINT '@mst_loop_cnt     = ' + CONVERT(VARCHAR,@mst_loop_cnt)   ;
				PRINT '@v_active_flag   = ''' + @v_active_flag   + '''' ;
				PRINT '@v_division_id   = ''' + @v_division_id   + '''' ;
				PRINT '@v_plant_site_id = ''' + @v_plant_site_id + '''' ;
				PRINT '@v_item_id       = ''' + @v_item_id       + '''' ;
				PRINT '@v_operation_id  = ''' + @v_operation_id  + '''' ;
				PRINT '@v_line_id       = ''' + @v_line_id       + '''' ;
				PRINT '@v_priority      = ''' + @v_priority      + '''' ;
				PRINT '@v_tact_time     = ''' + @v_tact_time     + '''' ;
				PRINT '@v_yield         = ''' + @v_yield         + '''' ;
				PRINT '@v_valid_yn      = ''' + @v_valid_yn      + '''' ;

				--PRINT '@@v_key_division_id  = ''' + @v_key_division_id   + '''' ;
				--PRINT '@v_key_plant_site_id = ''' + @v_key_plant_site_id + '''' ;
				--PRINT '@v_key_item_id       = ''' + @v_key_item_id       + '''' ;
				--PRINT '@v_key_operation_id  = ''' + @v_key_operation_id  + '''' ;
				--PRINT '@v_key_line_id       = ''' + @v_key_line_id       + '''' ;
				PRINT '@v_input_status			= ''' + @v_input_status      + '''' ;
				PRINT '@v_item_uom				= ''' + @v_item_uom      + '''' ;
				PRINT '@v_uom_convert_value		= ''' + @v_uom_convert_value      + '''' ;

			END;

		   --이력저장
			EXEC [dbo].PR_SCP_MST_TACT_TIME_HIST
						 @v_division_id  
						,@v_plant_site_id
						,@v_item_id      
						,@v_operation_id 
						,@v_line_id      
						,@v_priority     
						,@v_tact_time    
						,@v_yield        
						,@v_item_uom        
						,@v_uom_convert_value        
						,@v_valid_yn     
						,@v_created_by       
						,@v_creation_date    
						,@v_last_updated_by  
						,@v_last_update_date 
						,@v_lane_qty


			SET @v_data_dup_cnt  =0;

			-- trans mode 중복체크
			IF( @v_active_flag ='I' OR @v_input_status ='I')
				BEGIN
					SELECT @v_data_dup_cnt = COUNT(*) 			
					  FROM SCP_MST_TACT_TIME A
					 WHERE A.DIVISION_ID   = @v_division_id
					   AND A.PLANT_SITE_ID = @v_plant_site_id
					   AND A.ITEM_ID       = @v_item_id
					   AND A.OPERATION_ID  = @v_operation_id
					   AND A.LINE_ID       = @v_line_id
					   ;
				END;
			--ELSE IF(@v_input_status ='M')
			--	BEGIN
			--	    -- 수정일 경우는 자기 자신을 제외하고 카운트
			--		SELECT @v_data_dup_cnt = COUNT(*) 			
			--		  FROM SCP_MST_TACT_TIME A
			--		 WHERE A.DIVISION_ID   = @v_division_id
			--		   AND A.PLANT_SITE_ID = @v_plant_site_id
			--		   AND A.ITEM_ID       = @v_item_id
			--		   AND A.OPERATION_ID  = @v_operation_id
			--		   AND A.LINE_ID       = @v_line_id
			--		   AND A.LINE_ID      != @v_key_line_id
			--		   ;
			--	END;

			IF (@debug_mode ='T') 
				PRINT '@v_data_dup_cnt  = ' + CONVERT(VARCHAR,@v_data_dup_cnt)     ;


			IF( @v_data_dup_cnt>0) 
			BEGIN
				SET @v_err_code    = 99010 ; 
				SET @v_err_message = N'이미 존재하는 데이타 입니다.';
				THROW  @v_err_code, @v_err_message , 1; --예외발생
			END; 


			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		
					-- 수정, 입력일 경우 상태필드를 @v_active_flag 대신에 @v_input_status를 사용해야 함					
					IF( @v_input_status ='M' AND @v_active_flag ='M') 
						BEGIN
							UPDATE dbo.SCP_MST_TACT_TIME                 
							   SET PRIORITY         = @v_priority        
								  ,TACT_TIME        = @v_tact_time       
								  ,YIELD            = @v_yield           
								  ,VALID_YN         = @v_valid_yn        
								  ,LAST_UPDATED_BY  = @v_last_updated_by 
								  ,LAST_UPDATE_DATE = @v_last_update_date
								  ,ATTRIBUTE1		= @v_lane_qty
							 WHERE DIVISION_ID      = @v_division_id     
							   AND PLANT_SITE_ID    = @v_plant_site_id   
							   AND ITEM_ID          = @v_item_id         
							   AND OPERATION_ID     = @v_operation_id    
							   AND LINE_ID          = @v_line_id
							  ;
						END ;
					ELSE IF( @v_active_flag ='I' OR @v_input_status ='I')
						BEGIN						
							INSERT INTO dbo.SCP_MST_TACT_TIME
									   (DIVISION_ID
									   ,PLANT_SITE_ID
									   ,ITEM_ID
									   ,OPERATION_ID
									   ,LINE_ID
									   ,PRIORITY
									   ,TACT_TIME
									   ,YIELD
									   ,VALID_YN
									   ,CREATED_BY
									   ,CREATION_DATE
									   ,LAST_UPDATED_BY
									   ,LAST_UPDATE_DATE
									   ,ATTRIBUTE1
									   )
								 VALUES
									   (@v_division_id  
									   ,@v_plant_site_id
									   ,@v_item_id      
									   ,@v_operation_id 
									   ,@v_line_id      
									   ,@v_priority     
									   ,@v_tact_time    
									   ,@v_yield        
									   ,@v_valid_yn     
									   ,@v_created_by
									   ,@v_creation_date
									   ,@v_last_updated_by
									   ,@v_last_update_date
									   ,@v_lane_qty
									  );
						END;
					ELSE IF(@v_active_flag ='D' AND @v_input_status ='M')
						BEGIN
							
							-- Except 이력 저장
							INSERT INTO SCP_MST_TACT_TIME_EXCEPT_H
								(history_seq
								,division_id
								,plant_site_id
								,item_id
								,operation_id
								,line_id
								,tact_time_start_date
								,tact_time_end_date
								,tact_time
								,yield
								,except_comment
								,use_yn
								,created_by
								,creation_date
								,last_updated_by
								,last_update_date
								,history_creation_date
								,ATTRIBUTE1)
							SELECT (NEXT VALUE FOR SEQ1_SCP_MST_TACT_TIME_EXCEPT_H),
									division_id, 
									plant_site_id, 
									item_id, 
									operation_id,
									line_id,
									tact_time_start_date,
									tact_time_end_date,
									tact_time , 
									yield , 
									except_comment ,
									use_yn,
									@v_created_by , 
									@d_event_date, 
									@v_created_by,	
									SYSDATETIME() ,
									SYSDATETIME() ,
									@v_active_flag
							FROM SCP_MST_TACT_TIME_EXCEPT
							WHERE DIVISION_ID	= @v_division_id
							  AND PLANT_SITE_ID = @v_plant_site_id
							  AND ITEM_ID		= @v_item_id
							  AND OPERATION_ID	= @v_operation_id
							  AND LINE_ID		= @v_line_id
							;

							--Except 삭제
							DELETE FROM dbo.SCP_MST_TACT_TIME_EXCEPT 
							 WHERE DIVISION_ID   = @v_division_id
							   AND PLANT_SITE_ID = @v_plant_site_id
							   AND ITEM_ID       = @v_item_id
							   AND OPERATION_ID  = @v_operation_id
							   AND LINE_ID       = @v_line_id						
							;  

							DELETE FROM dbo.SCP_MST_TACT_TIME 
							 WHERE DIVISION_ID   = @v_division_id
							   AND PLANT_SITE_ID = @v_plant_site_id
							   AND ITEM_ID       = @v_item_id
							   AND OPERATION_ID  = @v_operation_id
							   AND LINE_ID       = @v_line_id						
							;     
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
				   ,@v_division_id   AS DIVISION_ID  
				   ,@v_plant_site_id AS PLANT_SITE_ID
				   ,@v_item_id       AS ITEM_ID      
				   ,@v_operation_id  AS OPERATION_ID 
				   ,@v_line_id       AS LINE_ID      

			; 

		END;
	END CATCH;
END
