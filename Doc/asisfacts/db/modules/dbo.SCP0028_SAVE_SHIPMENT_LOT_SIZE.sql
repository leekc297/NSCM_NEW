/*
 * Program ID   : [SCP0028_SAVE_SHIPMENT_LOT_SIZE]
 * Description  : Shipment Lot Size 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/07/25   ygkim   		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/09/11	hwyoon			Lot Size에 입력 시 sales site 추가
 * 2018/12/17	hwyoon			Split Yn 항목 추가
 */
CREATE PROCEDURE [dbo].[SCP0028_SAVE_SHIPMENT_LOT_SIZE]
     @p_active_flag	      NVARCHAR(MAX)
	,@p_division_id       NVARCHAR(MAX)
	,@p_operation_group   NVARCHAR(MAX)
	,@p_from_site         NVARCHAR(MAX)
	,@p_to_site			  NVARCHAR(MAX)
	,@p_item_id           NVARCHAR(MAX)
	,@p_transport_mode    NVARCHAR(MAX)
	,@p_lot_size          NVARCHAR(MAX)
	,@p_increment         NVARCHAR(MAX)
	,@p_split_yn		  NVARCHAR(MAX)
	,@p_valid_yn		  NVARCHAR(MAX)
	,@p_user_id           NVARCHAR(MAX)
	,@debug_mode          NVARCHAR(1) ='F'
AS

BEGIN
  
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;


	DECLARE @v_active_flag       NVARCHAR(MAX);   
	DECLARE @v_division_id       NVARCHAR(MAX);   
	DECLARE @v_operation_group   NVARCHAR(MAX);   
	DECLARE @v_from_site         NVARCHAR(MAX);   
	DECLARE @v_to_site           NVARCHAR(MAX);   
	DECLARE @v_item_id           NVARCHAR(MAX);   
	DECLARE @v_transport_mode    NVARCHAR(MAX);   
	DECLARE @v_lot_size          NVARCHAR(MAX);   
	DECLARE @v_increment         NVARCHAR(MAX);   
	DECLARE @v_split_yn			 NVARCHAR(MAX);   
	DECLARE @v_valid_yn          NVARCHAR(MAX);   
	DECLARE @v_created_by        NVARCHAR(MAX);
	DECLARE @v_creation_date     datetime	;
	DECLARE @v_last_updated_by   NVARCHAR(MAX);
	DECLARE @v_last_update_date  datetime	;
	

	SET @v_created_by       = @p_user_id;
	SET @v_creation_date    = sysdatetime();
	SET @v_last_updated_by  = @p_user_id
	SET @v_last_update_date = sysdatetime()

	SET @v_active_flag			= NULL;
	SET @v_division_id			= NULL;
	SET @v_operation_group		= NULL;
	SET @v_from_site			= NULL;
	SET @v_to_site				= NULL;
	SET @v_item_id				= NULL;
	SET @v_transport_mode       = NULL;
	SET @v_lot_size				= NULL;
	SET @v_increment			= NULL;
	SET @v_split_yn				= NULL;
	SET @v_valid_yn				= NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	DECLARE @mst_loop_cnt_chk	INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0028_SAVE_SHIPMENT_LOT_SIZE';
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

				SET @v_active_flag   = dbo.SCM_ARR_SPL_VAL( @p_active_flag       , @v_delimiter, @mst_loop_cnt );
				SET @v_division_id   = dbo.SCM_ARR_SPL_VAL( @p_division_id       , @v_delimiter, @mst_loop_cnt );
				SET @v_operation_group = dbo.SCM_ARR_SPL_VAL( @p_operation_group     , @v_delimiter, @mst_loop_cnt );
				SET @v_from_site     = dbo.SCM_ARR_SPL_VAL( @p_from_site         , @v_delimiter, @mst_loop_cnt );
				SET @v_to_site     = dbo.SCM_ARR_SPL_VAL( @p_to_site         , @v_delimiter, @mst_loop_cnt );
				SET @v_item_id       = dbo.SCM_ARR_SPL_VAL( @p_item_id           , @v_delimiter, @mst_loop_cnt );
				SET @v_transport_mode     = dbo.SCM_ARR_SPL_VAL( @p_transport_mode         , @v_delimiter, @mst_loop_cnt );
				SET @v_lot_size      = dbo.SCM_ARR_SPL_VAL( @p_lot_size          , @v_delimiter, @mst_loop_cnt );
				SET @v_increment      = dbo.SCM_ARR_SPL_VAL( @p_increment          , @v_delimiter, @mst_loop_cnt );
				SET @v_split_yn      = dbo.SCM_ARR_SPL_VAL( @p_split_yn          , @v_delimiter, @mst_loop_cnt );
				SET @v_valid_yn      = dbo.SCM_ARR_SPL_VAL( @p_valid_yn          , @v_delimiter, @mst_loop_cnt );
			END;

			-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '=================INPUT==============================';			
				PRINT '@mst_loop_cnt		= ' + CONVERT(VARCHAR,@mst_loop_cnt)   ;
				PRINT '@v_active_flag		= ' + @v_active_flag   ;
				PRINT '@v_division_id		= ' + @v_division_id        ;
				PRINT '@v_operation_group   = ' + @v_operation_group        ;
				PRINT '@v_from_site			= ' + @v_from_site   ;
				PRINT '@v_to_site			= ' + @v_to_site   ;
				PRINT '@v_item_id			= ' + @v_item_id ;
				PRINT '@v_transport_mode    = ' + @v_transport_mode     ;
				PRINT '@v_lot_size			= ' + @v_lot_size       ;
				PRINT '@v_increment			= ' + @v_increment     ;
				PRINT '@v_split_yn			= ' + @v_split_yn     ;
				PRINT '@v_valid_yn			= ' + @v_valid_yn      ;

			END;
							
		    --이력저장
			EXEC [dbo].[PR_SCP_MST_SHIPMENT_LOT_SIZE_HIST]
					 @v_division_id           
					,@v_operation_group      
					,@v_from_site        
					,@v_to_site        
					,@v_item_id          
					,@v_transport_mode        
					,@v_lot_size     
					,@v_increment  
					,@v_split_yn       
					,@v_valid_yn  
					,@v_created_by       
					,@v_creation_date    
					,@v_last_updated_by  ;

			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		
					
					IF( @v_active_flag ='M') 
						BEGIN

							MERGE INTO SCP_MST_SHIPMENT_LOT_SIZE A
									USING (
											SELECT @v_division_id as division_id 
												 ,@v_operation_group as operation_group
												 ,@v_from_site as from_site
												 ,@v_to_site as to_site
												 ,@v_item_id  as item_id      
												 ,@v_transport_mode as transport_mode        
											) B
									ON(
												a.division_id = b.division_id
											and a.operation_group = b.operation_group
											and a.from_site = b.from_site
											and a.to_site = b.to_site
											and a.item_id = b.item_id
											and a.transport_mode = b.transport_mode
										)
									WHEN MATCHED THEN
										UPDATE 
										   SET lot_size			= @v_lot_size
											  ,increment		= @v_increment
											  ,split_yn         = @v_split_yn         
											  ,valid_yn         = @v_valid_yn         
											  ,last_updated_by  = @v_last_updated_by  
											  ,last_update_date = @v_last_update_date 
					                
									WHEN NOT MATCHED THEN							                                             
										INSERT 
											   (division_id
												,operation_group
												,from_site
												,to_site
												,item_id
												,transport_mode
												,lot_size
												,increment
												,split_yn
												,valid_yn
												,created_by
												,creation_date
												,last_updated_by
												,last_update_date
											   )
										 VALUES
											   ( @v_division_id                
												,@v_operation_group           
												,@v_from_site
												,@v_to_site
												,@v_item_id             
												,@v_transport_mode               
												,@v_lot_size             
												,@v_increment    
												,@v_split_yn         
												,@v_valid_yn              
												,@v_created_by            
												,@v_creation_date         
												,@v_last_updated_by       
												,@v_last_update_date      
											   ); 
						END;

					ELSE IF(@v_active_flag ='D')
						BEGIN
							DELETE FROM SCP_MST_SHIPMENT_LOT_SIZE
							WHERE division_id = @v_division_id
							AND operation_group=@v_operation_group
							AND from_site=@v_from_site
							AND to_site=@v_to_site
							AND item_id=@v_item_id
							;
				     
						END;
				END  -- END OF STMT. IF( @mst_loop_cnt > 0 )			

		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt_chk < @max_loop_cnt

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
