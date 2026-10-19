
/*===================================================================================================
 * Program ID   : SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE
 * Description  : CATEGORY_SETUP_MEASURE 저장
 *				  Admin > System > UI Category Setup
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/01/03   kimjaejung		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/09	KYH				DIVISION_ID 추가
 * 2019/02/18	YHW				[CSR:]ATTRIBUTE3 추가(MEASURE별 행 색상 지정)
 * 2025/07/09	JSSBAE			[E20250529-001488]_Sales Plan Waterfall 데이터 조회 로직 개선
 ===================================================================================================*/

CREATE PROCEDURE [dbo].[SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE]
	-- Add the parameters for the stored procedure here
	  @p_active_flag			NVARCHAR(MAX)
	, @p_program_id				NVARCHAR(MAX)
	, @p_sheet_name				NVARCHAR(MAX)    
	, @p_column_name			NVARCHAR(MAX)      
	, @p_column_label_name		NVARCHAR(MAX)
	, @p_sort_order_no			NVARCHAR(MAX)
	, @p_small_class_label_name	NVARCHAR(MAX)
	, @p_large_class_label_name	NVARCHAR(MAX)       
	, @p_default_flag			NVARCHAR(MAX)
	, @p_user_selectable_flag	NVARCHAR(MAX)
	, @p_division_id			NVARCHAR(MAX)
	, @p_valid_yn				NVARCHAR(MAX)
	, @p_created_by				NVARCHAR(MAX)
	, @p_creation_date			NVARCHAR(MAX)
	, @p_last_updated_by		NVARCHAR(MAX)
	, @p_measure_Color			NVARCHAR(MAX)=''	
	----------------------------------------------------------------------------------------------------------------------------
	--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (START)
	, @p_attribute1				NVARCHAR(MAX)
	, @p_attribute2				NVARCHAR(MAX)
	, @p_attribute4				NVARCHAR(MAX)
	, @p_attribute5				NVARCHAR(MAX)
	, @p_attribute6				NVARCHAR(MAX)
	, @p_attribute7				NVARCHAR(MAX)
	, @p_attribute8				NVARCHAR(MAX)
	, @p_attribute9				NVARCHAR(MAX)
	, @p_attribute10			NVARCHAR(MAX)
	--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (END)
	----------------------------------------------------------------------------------------------------------------------------

AS
BEGIN
	SET NOCOUNT ON;
	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag			NVARCHAR(MAX);
	DECLARE @v_active_flag				NVARCHAR(MAX);
	DECLARE @v_program_id				NVARCHAR(MAX);
	DECLARE @v_sheet_name				NVARCHAR(MAX);      
	DECLARE @v_column_code				NVARCHAR(MAX);      
	DECLARE @v_column_label_name		NVARCHAR(MAX);
	DECLARE @v_sort_order_no			NVARCHAR(MAX); 
	DECLARE @v_small_class_label_name	NVARCHAR(MAX); 
	DECLARE @v_large_class_label_name	NVARCHAR(MAX);       
	DECLARE @v_default_flag				NVARCHAR(MAX);

	DECLARE @v_user_selectable_flag		NVARCHAR(MAX);
	DECLARE @v_division_id				NVARCHAR(MAX);
	DECLARE @v_valid_yn					NVARCHAR(MAX);
	DECLARE @v_created_by				NVARCHAR(MAX);
	DECLARE @v_creation_date			DATETIME;
	DECLARE @v_last_updated_by			NVARCHAR(MAX);
	DECLARE @v_measure_Color			NVARCHAR(MAX);	
	----------------------------------------------------------------------------------------------------------------------------
	--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (START)
	DECLARE @v_attribute1				NVARCHAR(MAX);	
	DECLARE @v_attribute2				NVARCHAR(MAX);	
	DECLARE @v_attribute4				NVARCHAR(MAX);	
	
	DECLARE @v_attribute5				NVARCHAR(MAX);	
	DECLARE @v_attribute6				NVARCHAR(MAX);	
	DECLARE @v_attribute7				NVARCHAR(MAX);	
	DECLARE @v_attribute8				NVARCHAR(MAX);	
	DECLARE @v_attribute9				NVARCHAR(MAX);	
	DECLARE @v_attribute10				NVARCHAR(MAX);	
	--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (END)
	----------------------------------------------------------------------------------------------------------------------------
	
	SET	@recv_active_flag			= NULL;		
	SET	@recv_active_flag			= @p_active_flag;
	SET @v_active_flag				= NULL;
	SET @v_program_id				= NULL;
	SET @v_sheet_name				= NULL;
	SET @v_column_code				= NULL;
	SET @v_column_label_name		= NULL;
	SET @v_sort_order_no			= NULL;
	SET @v_small_class_label_name	= NULL;
	SET @v_large_class_label_name	= NULL;

	SET @v_default_flag				= NULL;
	SET @v_user_selectable_flag		= NULL;
	SET @v_division_id				= NULL;
	SET @v_valid_yn					= NULL;
	SET @v_created_by				= NULL;	  
	SET @v_creation_date			= NULL;
	SET @v_last_updated_by			= NULL;
	SET @v_measure_Color			= NULL;
	----------------------------------------------------------------------------------------------------------------------------
	--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (START)
	SET @v_attribute1				= NULL;
	SET @v_attribute2				= NULL;
	
	SET @v_attribute4				= NULL;
	SET @v_attribute5				= NULL;
	SET @v_attribute6				= NULL;
	SET @v_attribute7				= NULL;
	SET @v_attribute8				= NULL;
	SET @v_attribute9				= NULL;
	SET @v_attribute10				= NULL;
	--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (END)
	----------------------------------------------------------------------------------------------------------------------------

	DECLARE	@v_delimiter		NVARCHAR(1)
	DECLARE	@max_loop_cnt		INTEGER = 0; 
	DECLARE	@mst_loop_cnt		INTEGER = 0;
	
	--==================================================================================
	-- LOG 용 변수 설정
	--==================================================================================
    DECLARE @v_program_name NVARCHAR(150) = 'SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	SET		@v_delimiter = '^' 

	BEGIN TRY
		--==================================================================================
		-- 시작 LOG
		--==================================================================================
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		--==================================================================================
		-- 프로시저 LOOP 길이를 판단
		--==================================================================================
		SET		@max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		SELECT	@max_loop_cnt;
		--	WHILE LEN(@p_active_flag) > 0

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    		
			------------------------------------------------------------------------------------------
			-- @mst_loop_cnt 1증가
			------------------------------------------------------------------------------------------
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			SELECT @mst_loop_cnt,'@mst_loop_cnt'		
			
			------------------------------------------------------------------------------------------
			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			------------------------------------------------------------------------------------------
			BEGIN			 
			    SET @v_program_id = [dbo].[SCM_ARR_SPL_VAL](@p_program_id, @v_delimiter , @mst_loop_cnt);  
				SET @v_sheet_name = [dbo].[SCM_ARR_SPL_VAL](@p_sheet_name, @v_delimiter , @mst_loop_cnt);    
				SET @v_column_code = [dbo].[SCM_ARR_SPL_VAL](@p_column_name, @v_delimiter , @mst_loop_cnt); 
				SET @v_column_label_name = [dbo].[SCM_ARR_SPL_VAL](@p_column_label_name, @v_delimiter , @mst_loop_cnt);
				SET @v_sort_order_no = [dbo].[SCM_ARR_SPL_VAL](@p_sort_order_no, @v_delimiter , @mst_loop_cnt);  
				SET @v_small_class_label_name = [dbo].[SCM_ARR_SPL_VAL](@p_small_class_label_name, @v_delimiter , @mst_loop_cnt);  
				SET @v_large_class_label_name = [dbo].[SCM_ARR_SPL_VAL](@p_large_class_label_name, @v_delimiter , @mst_loop_cnt);        
				SET @v_default_flag = [dbo].[SCM_ARR_SPL_VAL](@p_default_flag, @v_delimiter , @mst_loop_cnt);   				
				SET @v_user_selectable_flag = [dbo].[SCM_ARR_SPL_VAL](@p_user_selectable_flag, @v_delimiter , @mst_loop_cnt);    
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt);

				SET @v_valid_yn = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter , @mst_loop_cnt);
				SET @v_created_by = [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter, @mst_loop_cnt); 
				SET @v_creation_date = CONVERT(DATETIME, [dbo].[SCM_ARR_SPL_VAL](@p_creation_date, @v_delimiter, @mst_loop_cnt) , 120);
				SET @v_last_updated_by = [dbo].[SCM_ARR_SPL_VAL](@p_last_updated_by, @v_delimiter, @mst_loop_cnt); 
				SET @v_measure_Color = [dbo].[SCM_ARR_SPL_VAL](@p_measure_Color, @v_delimiter, @mst_loop_cnt);
				---------------------------------------------------------------------------------------------------------------------------- 				
				--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (START)
				SET @v_attribute1 = [dbo].[SCM_ARR_SPL_VAL](@p_attribute1, @v_delimiter, @mst_loop_cnt); 		
				SET @v_attribute2 = [dbo].[SCM_ARR_SPL_VAL](@p_attribute2, @v_delimiter, @mst_loop_cnt); 		
				SET @v_attribute4 = [dbo].[SCM_ARR_SPL_VAL](@p_attribute4, @v_delimiter, @mst_loop_cnt); 		
				SET @v_attribute5 = [dbo].[SCM_ARR_SPL_VAL](@p_attribute5, @v_delimiter, @mst_loop_cnt); 			
				SET @v_attribute6 = [dbo].[SCM_ARR_SPL_VAL](@p_attribute6, @v_delimiter, @mst_loop_cnt); 	
						
				SET @v_attribute7 = [dbo].[SCM_ARR_SPL_VAL](@p_attribute7, @v_delimiter, @mst_loop_cnt); 	
				SET @v_attribute8 = [dbo].[SCM_ARR_SPL_VAL](@p_attribute8, @v_delimiter, @mst_loop_cnt); 
				SET @v_attribute9 = [dbo].[SCM_ARR_SPL_VAL](@p_attribute9, @v_delimiter, @mst_loop_cnt); 
				SET @v_attribute10 = [dbo].[SCM_ARR_SPL_VAL](@p_attribute10, @v_delimiter, @mst_loop_cnt); 
				--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (END)
				----------------------------------------------------------------------------------------------------------------------------
			END

			IF @mst_loop_cnt > 0 			
			BEGIN		
				MERGE INTO SCM_MST_SHEET_MEASURE A
				USING (	SELECT	@v_program_id	AS PROGRAM_ID,
								@v_sheet_name	AS SHEET_NAME,
								@v_column_code	AS COLUMN_CODE					
						) B
					ON(		A.PROGRAM_ID	= B.PROGRAM_ID
						AND	A.SHEET_NAME    = B.SHEET_NAME
						AND A.COLUMN_NAME   = B.COLUMN_CODE )
				WHEN MATCHED THEN
					UPDATE SET PROGRAM_ID				= @v_program_id
							 , SHEET_NAME				= @v_sheet_name
							 , COLUMN_NAME				= @v_column_code
							 , COLUMN_LABEL_NAME		= @v_column_label_name
							 , SORT_ORDER_NO			= @v_sort_order_no
							 , SMALL_CLASS_LABEL_NAME	= @v_small_class_label_name
							 , LARGE_CLASS_LABEL_NAME	= @v_large_class_label_name  
							 , DEFAULT_FLAG				= @v_default_flag
							 , USER_SELECTABLE_FLAG		= @v_user_selectable_flag
							 , DIVISION_ID				= @v_division_id
							 , VALID_YN					= @v_valid_yn
							 , LAST_UPDATED_BY			= @v_last_updated_by
							 , LAST_UPDATE_DATE			= sysdatetime()
							 , ATTRIBUTE3				= @v_measure_Color
							----------------------------------------------------------------------------------------------------------------------------
							--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (START)
							 , ATTRIBUTE1				= @v_attribute1
							 , ATTRIBUTE2				= @v_attribute2
							 , ATTRIBUTE4				= @v_attribute4
							 , ATTRIBUTE5				= @v_attribute5
							 , ATTRIBUTE6				= @v_attribute6
							 , ATTRIBUTE7				= @v_attribute7
							 , ATTRIBUTE8				= @v_attribute8
							 , ATTRIBUTE9				= @v_attribute9
							 , ATTRIBUTE10				= @v_attribute10
							--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (END)
							----------------------------------------------------------------------------------------------------------------------------
				WHEN NOT MATCHED THEN
				INSERT ( PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, SMALL_CLASS_LABEL_NAME
						, LARGE_CLASS_LABEL_NAME, DEFAULT_FLAG, USER_SELECTABLE_FLAG, DIVISION_ID, VALID_YN, CREATED_BY
						, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE3
						----------------------------------------------------------------------------------------------------------------------------
						--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (START)
						, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
						, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
						--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (END)
						---------------------------------------------------------------------------------------------------------------------------- 
				VALUES (  @v_program_id, @v_sheet_name, @v_column_code, @v_column_label_name, @v_sort_order_no, @v_small_class_label_name
						, @v_large_class_label_name, @v_default_flag, @v_user_selectable_flag, @v_division_id, @v_valid_yn, @v_created_by
						, SYSDATETIME(), @v_created_by, SYSDATETIME(), @v_measure_Color --실제값 ATTRIBUTE3
						----------------------------------------------------------------------------------------------------------------------------
						--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (START)
						, @v_attribute1, @v_attribute2, @v_attribute4, @v_attribute5, @v_attribute6, @v_attribute7
						, @v_attribute8, @v_attribute9, @v_attribute10 )
						--[E20250529-001488]_SCM_MST_SHEET_MEASURE에서 ATTRIBUTE를 화면에서 보고 사용하고자 하는 니즈가 있어 해당 부분 노출되도록 추가 (END)
						---------------------------------------------------------------------------------------------------------------------------- 
					;	
			END
			--ELSE -- 단일 row			 
			--BEGIN   		

			--	SET @v_active_flag = @p_active_flag        
			--	SET @p_active_flag = NULL       
			--	SET @v_program_id = @p_program_id        
			--	SET @p_program_id = NULL      
			--	SET @v_sheet_name = @p_sheet_name        
			--	SET @p_sheet_name = NULL    
			--	SET @v_column_code = @p_column_name        
			--	SET @p_column_name = NULL  
			--	SET @v_column_label_name = @p_column_label_name        
			--	SET @p_column_label_name = NULL 
			--	SET @v_sort_order_no = @p_sort_order_no        
			--	SET @p_sort_order_no = NULL  
			--	SET @v_default_flag = @p_default_flag        
			--	SET @p_default_flag = NULL  
			--	SET @v_valid_yn = @p_valid_yn        
			--	SET @p_valid_yn = NULL  
			--	SET @v_created_by = @p_created_by
			--	SET @p_created_by = NULL
			--	SET @v_creation_date = @p_creation_date
			--	SET @p_creation_date = NULL					
			--	SET @v_last_updated_by = @p_last_updated_by
			--	SET @p_last_updated_by = NULL
						
			--MERGE INTO [SCM_MST_SHEET_MEASURE] A
			--USING (
			--		SELECT 
			--			    @v_program_id as program_id,
			--				@v_sheet_name as sheet_name,
			--				@v_column_code as column_code					
			--		) B
			--ON(
			--			A.program_id	= B.program_id
			--		AND	A.sheet_name    = B.sheet_name
			--		AND A.column_name   = B.column_code
						
			--	)
			--WHEN MATCHED THEN
			--		UPDATE SET 
			--		     program_id			  = @v_program_id
 		--				,sheet_name			  = @v_sheet_name
			--			,column_name          = @v_column_code
			--			,column_label_name    = @v_column_label_name
			--			,sort_order_no		  = @v_sort_order_no
			--			,default_flag         = @v_default_flag
			--			,valid_yn		      = @v_valid_yn
			--			,last_updated_by	  = @v_last_updated_by
			--			,last_update_date	  = sysdatetime()
					                
			--WHEN NOT MATCHED THEN
			--INSERT	(		
			--			 program_id, sheet_name, column_name,
			--			 column_label_name,sort_order_no ,default_flag, valid_yn,
			--			 created_by, creation_date, last_updated_by, last_update_date
			--		)
			--VALUES  (
			--		 	@v_program_id ,@v_sheet_name, @v_column_code, 
			--			@v_column_label_name , @v_sort_order_no ,@v_default_flag ,@v_valid_yn,
			--		    @v_created_by, SYSDATETIME(), @v_created_by, SYSDATETIME()
			--		);

			--	END	
		END
			--==================================================================================
			-- 종료 LOG
			--==================================================================================
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
	END TRY
	BEGIN CATCH
		BEGIN
			INSERT INTO SCM_SYS_LOG_BATCH 
			( PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, EVENT_DATE
			, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
			VALUES ( ERROR_PROCEDURE(), 'ERROR', NULL, ERROR_MESSAGE(), NULL, SYSDATETIME()
					, SYSDATETIME(), ERROR_PROCEDURE(), SYSDATETIME(), ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
		END;
	END CATCH;
END






