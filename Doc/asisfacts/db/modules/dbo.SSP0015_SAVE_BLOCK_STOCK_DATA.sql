


/****************************************************************************************************/
/* Program ID  : [SSP0015_SAVE_BLOCK STOCK_DATA]													*/
/* Description : Shipment PSI BLOCK STOCK 시트 저장													*/
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/03/06  AYJ	   Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT					*/
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[SSP0015_SAVE_BLOCK_STOCK_DATA]

	@p_active_flag				NVARCHAR(MAX),
	@p_hold_id					NVARCHAR(MAX),
	@p_plan_start_yyyymmdd		NVARCHAR(MAX),
	@p_plan_type				NVARCHAR(MAX),
	@p_seq						NVARCHAR(MAX),
	@p_division_id				NVARCHAR(MAX),
	@p_from_site				NVARCHAR(MAX),
	@p_item_id					NVARCHAR(MAX),
	@p_hold_yyyymmdd			NVARCHAR(MAX),
	@p_release_yyyymmdd			NVARCHAR(MAX),
	@p_hold_qty					NVARCHAR(MAX),
	@p_remarks					NVARCHAR(MAX),
	@p_user_id					NVARCHAR(MAX)
	
AS

BEGIN

	SET NOCOUNT ON; 
--    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
--    SET XACT_ABORT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_hold_id				NVARCHAR(MAX);
	DECLARE @v_plan_start_yyyymmdd	NVARCHAR(MAX);
	DECLARE @v_plan_type			NVARCHAR(MAX);
	DECLARE @v_seq					NVARCHAR(MAX);
	DECLARE @v_division_id         	NVARCHAR(MAX);
	DECLARE @v_from_site           	NVARCHAR(MAX);
	DECLARE @v_item_id             	NVARCHAR(MAX);
	DECLARE @v_hold_yyyymmdd       	NVARCHAR(MAX);
	DECLARE @v_release_yyyymmdd    	NVARCHAR(MAX);
	DECLARE @v_hold_qty            	NVARCHAR(MAX);
    DECLARE @v_remarks              NVARCHAR(MAX);
	DECLARE @v_user_id				NVARCHAR(MAX);
	DECLARE @v_last_updated_by      NVARCHAR(MAX)
	--DECLARE	@v_OK_description		NVARCHAR(1200);	-- 자식 프로시저 성공/에러 셋팅

	SET @v_active_flag = NULL;
	SET @v_hold_id = NULL;
	SET @v_plan_start_yyyymmdd = NULL;
	SET @v_plan_type = NULL;
	SET @v_seq = NULL;
	SET @v_division_id = NULL;
	SET @v_from_site = NULL;
	SET @v_item_id = NULL;	 
	SET @v_hold_yyyymmdd = NULL;	 
	SET @v_release_yyyymmdd = NULL;	 
	SET @v_hold_qty = NULL;	 
	SET @v_remarks = NULL;	
	SET @v_user_id = NULL;
	SET @v_last_updated_by     = @p_user_id;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0015_SAVE_BLOCK STOCK_DATA';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 시작 LOG  (END)
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		--SELECT    @max_loop_cnt;
		--	WHILE LEN(@p_active_flag) > 0
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN    
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			--SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
			 
				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_hold_id = [dbo].[SCM_ARR_SPL_VAL](@p_hold_id, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_plan_start_yyyymmdd = [dbo].[SCM_ARR_SPL_VAL](@p_plan_start_yyyymmdd, @v_delimiter , @mst_loop_cnt) ;
				SET @v_plan_type = [dbo].[SCM_ARR_SPL_VAL](@p_plan_type, @v_delimiter , @mst_loop_cnt) ;
				SET @v_seq = [dbo].[SCM_ARR_SPL_VAL](@p_seq, @v_delimiter , @mst_loop_cnt) ;
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_from_site = [dbo].[SCM_ARR_SPL_VAL](@p_from_site, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_item_id = [dbo].[SCM_ARR_SPL_VAL](@p_item_id, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_hold_yyyymmdd = [dbo].[SCM_ARR_SPL_VAL](@p_hold_yyyymmdd, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_release_yyyymmdd = [dbo].[SCM_ARR_SPL_VAL](@p_release_yyyymmdd, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_hold_qty = [dbo].[SCM_ARR_SPL_VAL](@p_hold_qty, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_remarks = [dbo].[SCM_ARR_SPL_VAL](@p_remarks, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_user_id = [dbo].[SCM_ARR_SPL_VAL](@p_user_id, @v_delimiter, @mst_loop_cnt) ; 
				
			END

			IF @mst_loop_cnt > 0 

				BEGIN       
				
				-- 	SSP_ANL_HOLD_STOCK SAVE LOGIC
					
					IF EXISTS
					(
						SELECT 
							A.hold_id
							,A.plan_start_yyyymmdd
							,A.plan_type
							,A.seq							 
						FROM	
						[dbo].[SSP_ANL_HOLD_STOCK] A  WITH(NOLOCK)	,
						(
								SELECT 
									@v_hold_id				as hold_id
									,@v_plan_start_yyyymmdd	as plan_start_yyyymmdd
									,@v_plan_type			as plan_type
									,@v_seq					as seq
						) B
						WHERE  1 = 1
								AND A.hold_id				= B.hold_id
								AND A.plan_start_yyyymmdd   = B.plan_start_yyyymmdd
								AND A.plan_type				= B.plan_type
								AND A.seq					= B.seq
					)

						BEGIN

							UPDATE [dbo].[SSP_ANL_HOLD_STOCK] 
								SET 
									release_yyyymmdd			= @v_release_yyyymmdd
									,hold_qty					= @v_hold_qty
									,remarks					= @v_remarks
									,last_updated_by			= @v_user_id
									,last_update_date			= sysdatetime()
							WHERE
										hold_id				 = @v_hold_id
									AND plan_start_yyyymmdd  = @v_plan_start_yyyymmdd
									AND plan_type			 = @v_plan_type
									AND seq					 = @v_seq
							;

						END


					ELSE

						INSERT INTO	[dbo].[SSP_ANL_HOLD_STOCK]
								(  
									hold_id
								   ,plan_start_yyyymmdd
								   ,plan_type
								   ,seq
								   ,division_id		
								   ,from_site							   
								   ,item_id
								   ,hold_yyyymmdd
								   ,release_yyyymmdd
								   ,hold_qty
								   ,remarks
								   ,origin_from_division_id
								   ,created_by
								   ,creation_date
								   ,last_updated_by
								   ,last_update_date
								)
						 VALUES (  
									'H'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('0000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_HOLD_ID),6) 
								   ,@v_plan_start_yyyymmdd
								   ,@v_plan_type
								   ,@v_seq
								   ,@v_division_id
								   ,@v_from_site	
								   ,@v_item_id
								   ,@v_hold_yyyymmdd
								   ,@v_release_yyyymmdd
								   ,@v_hold_qty
								   ,@v_remarks
								   ,@v_division_id -- origin_from_division_id
								   ,@v_user_id
								   ,sysdatetime()
								   ,@v_user_id
								   ,sysdatetime()
								);

				END

			ELSE    --단일 ROW 일때
			 
				BEGIN        
					SET @v_active_flag			= @p_active_flag        
					SET @p_active_flag			= NULL  
					SET @v_hold_id				= @p_hold_id
					SET @p_hold_id				= NULL 
					SET @v_plan_start_yyyymmdd	= @p_plan_start_yyyymmdd
					SET @p_plan_start_yyyymmdd	= NULL 
					SET @v_plan_type			= @p_plan_type
					SET @p_plan_type			= NULL 
					SET @v_seq					= @p_seq
					SET @p_seq					= NULL 
					SET @v_division_id			= @p_division_id        
					SET @p_division_id			= NULL      
					SET @v_from_site			= @p_from_site        
					SET @p_from_site			= NULL  
					SET @v_item_id				= @p_item_id        
					SET @p_item_id				= NULL  
					SET @v_hold_yyyymmdd		= @p_hold_yyyymmdd        
					SET @p_hold_yyyymmdd		= NULL 
					SET @v_release_yyyymmdd		= @p_release_yyyymmdd     
					SET @p_release_yyyymmdd		= NULL  
					SET @v_hold_qty				= @p_hold_qty      
					SET @p_hold_qty				= NULL  
					SET @v_remarks				= @p_remarks      
					SET @p_remarks				= NULL  
					SET @v_user_id				= @p_user_id
					SET @p_user_id				= NULL


					IF EXISTS
					(
						SELECT 
							A.hold_id
							,A.plan_start_yyyymmdd
							,A.plan_type
							,A.seq
						FROM	
						[dbo].[SSP_ANL_HOLD_STOCK] A  WITH(NOLOCK)	,
						(
								SELECT 
									@v_hold_id				as hold_id
									,@v_plan_start_yyyymmdd	as plan_start_yyyymmdd
									,@v_plan_type			as plan_type
									,@v_seq					as seq
						) B
						WHERE  1 = 1
								AND A.hold_id				= B.hold_id	
								AND A.plan_start_yyyymmdd   = B.plan_start_yyyymmdd
								AND A.plan_type				= B.plan_type
								AND A.seq					= B.seq
					)

						BEGIN
							
							UPDATE [dbo].[SSP_ANL_HOLD_STOCK] 
								SET 
									release_yyyymmdd			= @v_release_yyyymmdd
									,hold_qty					= @v_hold_qty
									,remarks					= @v_remarks
									,last_updated_by			= @v_user_id
									,last_update_date			= sysdatetime()
							WHERE
										hold_id				 = @v_hold_id
									AND plan_start_yyyymmdd  = @v_plan_start_yyyymmdd
									AND plan_type			 = @v_plan_type
									AND seq					 = @v_seq
							;

						END


					ELSE

						INSERT INTO	[dbo].[SSP_ANL_HOLD_STOCK]
								(  
									hold_id
								   ,plan_start_yyyymmdd
								   ,plan_type
								   ,seq
								   ,division_id		
								   ,from_site							   
								   ,item_id
								   ,hold_yyyymmdd
								   ,release_yyyymmdd
								   ,hold_qty
								   ,remarks
								   ,origin_from_division_id
								   ,created_by
								   ,creation_date
								   ,last_updated_by
								   ,last_update_date
								)
						 VALUES (  
									'H'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('0000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_HOLD_ID),6) 
								   ,@v_plan_start_yyyymmdd
								   ,@v_plan_type
								   ,@v_seq
								   ,@v_division_id
								   ,@v_from_site	
								   ,@v_item_id
								   ,@v_hold_yyyymmdd
								   ,@v_release_yyyymmdd
								   ,@v_hold_qty
								   ,@v_remarks
								   ,@v_division_id -- origin_from_division_id
								   ,@v_user_id
								   ,sysdatetime()
								   ,@v_user_id
								   ,sysdatetime()
								);

				END

			END

			--EXEC PR_SSP_ANL_SHIP_UPDATE_BOH_VAL_40 @v_division_id, @v_item_id, @v_from_site, @v_hold_yyyymmdd, @v_last_updated_by

			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			-- 결과코드, 결과 카운트 반환
			SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;
		
		END TRY

		BEGIN CATCH
		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name
										  ,log_type
										  ,log_count
										  ,log_message
										  ,description
										  ,event_date
										  ,creation_date
										  ,created_by
										  ,last_update_date
										  ,last_updated_by)
			VALUES (ERROR_PROCEDURE()
				   ,'ERROR'
				   ,NULL
				   ,ERROR_MESSAGE()
				   ,NULL
				   ,SYSDATETIME()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
	END

