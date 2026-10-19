/*
 * Program ID   : SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN
 * Description  : CATEGORY_SETUP_COLUMN 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/01/03   kimjaejung		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/18   byunghunjung	개발, 운영간 소스일치화
 * 2018/05/24   hwyoon			콤보박스용 파라미터 5개 추가
 * 2018/06/19   hwyoon			유저카테고리 저장 항목 추가
 * 2018/07/09	KYH				DIVISION_ID 추가
 */
CREATE PROCEDURE [dbo].[SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN]

	-- Add the parameters for the stored procedure here
	@p_active_flag						NVARCHAR(MAX),
	@p_program_id						NVARCHAR(MAX),
	@p_sheet_name						NVARCHAR(MAX),      
	@p_column_name						NVARCHAR(MAX),      
	@p_column_label_name				NVARCHAR(MAX),
	@p_sort_order_no					NVARCHAR(MAX),
	@p_data_sort_method_code			NVARCHAR(MAX),
	@p_small_class_label_name			NVARCHAR(MAX),
	@p_large_class_label_name			NVARCHAR(MAX),
	@p_fixed_flag						NVARCHAR(MAX),
	@p_column_width						NVARCHAR(MAX),
	@p_cell_control_object_type_code	NVARCHAR(MAX),
	@p_cell_combo_data_type				NVARCHAR(MAX),
	@p_data_scale_number				NVARCHAR(MAX),
	@p_data_max_length					NVARCHAR(MAX),
	@p_horizontal_align_code			NVARCHAR(MAX),
	@p_uppercase_apply_flag				NVARCHAR(MAX),
	@p_visible_flag						NVARCHAR(MAX),      
	@p_default_flag						NVARCHAR(MAX),
	@p_user_selectable_flag				NVARCHAR(MAX),
	@p_division_id						NVARCHAR(MAX),
	@p_valid_yn							NVARCHAR(MAX),
	@p_attribute1						NVARCHAR(MAX),
	@p_attribute2						NVARCHAR(MAX),
	@p_attribute3						NVARCHAR(MAX),
	@p_attribute4						NVARCHAR(MAX),
	@p_attribute5						NVARCHAR(MAX),
	@p_created_by						NVARCHAR(MAX),
	@p_creation_date					NVARCHAR(MAX),
	@p_last_updated_by					NVARCHAR(MAX),
	@p_attribute6						NVARCHAR(MAX)=''

AS

BEGIN

	SET NOCOUNT ON;

	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag							NVARCHAR(MAX);
	DECLARE @v_program_id							NVARCHAR(MAX);
	DECLARE @v_sheet_name							NVARCHAR(MAX);      
	DECLARE @v_column_name							NVARCHAR(MAX);      
	DECLARE @v_column_label_name					NVARCHAR(MAX);
	DECLARE @v_sort_order_no						NVARCHAR(MAX); 
	DECLARE @v_data_sort_method_code				NVARCHAR(MAX);     
	DECLARE @v_small_class_label_name				NVARCHAR(MAX);     
	DECLARE @v_large_class_label_name				NVARCHAR(MAX);     
	DECLARE @v_fixed_flag							NVARCHAR(MAX);     
	DECLARE @v_column_width							NVARCHAR(MAX);     
	DECLARE @v_cell_control_object_type_code		NVARCHAR(MAX);
	DECLARE @v_cell_combo_data_type					NVARCHAR(MAX);
	DECLARE @v_data_scale_number					NVARCHAR(MAX);     
	DECLARE @v_data_max_length						NVARCHAR(MAX);     
	DECLARE @v_horizontal_align_code				NVARCHAR(MAX);     
	DECLARE @v_uppercase_apply_flag					NVARCHAR(MAX);     
	DECLARE @v_visible_flag							NVARCHAR(MAX);      
	DECLARE @v_default_flag							NVARCHAR(MAX);
	DECLARE @v_user_selectable_flag					NVARCHAR(MAX);
	DECLARE @v_attribute1							NVARCHAR(MAX);
	DECLARE @v_attribute2							NVARCHAR(MAX);
	DECLARE @v_attribute3							NVARCHAR(MAX);
	DECLARE @v_attribute4							NVARCHAR(MAX);
	DECLARE @v_attribute5							NVARCHAR(MAX);
	DECLARE @v_attribute6							NVARCHAR(MAX);

	DECLARE @v_division_id							NVARCHAR(MAX);
	DECLARE @v_valid_yn								NVARCHAR(MAX);
	DECLARE @v_created_by							NVARCHAR(MAX);
	DECLARE @v_creation_date						DATETIME;
	DECLARE @v_last_updated_by						NVARCHAR(MAX);

	SET @v_active_flag = NULL;
	SET @v_program_id = NULL;
	SET @v_sheet_name = NULL;
	SET @v_column_name = NULL;
	SET @v_column_label_name = NULL;
	SET @v_sort_order_no = NULL;
	SET @v_data_sort_method_code = NULL;
	SET @v_small_class_label_name = NULL;
	SET @v_large_class_label_name = NULL;
	SET @v_fixed_flag = NULL;
	SET @v_column_width = NULL;
	SET @v_cell_control_object_type_code = NULL;
	SET @v_cell_combo_data_type = NULL;
	SET @v_data_scale_number = NULL;
	SET @v_data_max_length = NULL;
	SET @v_horizontal_align_code = NULL;
	SET @v_uppercase_apply_flag = NULL;
	SET @v_visible_flag = NULL;
	SET @v_default_flag = NULL;
	SET @v_user_selectable_flag = NULL;
	
	SET @v_division_id = NULL;
	SET @v_valid_yn = NULL;
	SET @v_attribute1 = NULL;
	SET @v_attribute2 = NULL;
	SET @v_attribute3 = NULL;
	SET @v_attribute4 = NULL;
	SET @v_attribute5 = NULL;
	SET @v_created_by = NULL;	  
	SET @v_creation_date = NULL;
	SET @v_last_updated_by = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		SELECT    @max_loop_cnt;
		--	WHILE LEN(@p_active_flag) > 0
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN    
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
			 
			    SET @v_program_id = [dbo].[SCM_ARR_SPL_VAL](@p_program_id, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_sheet_name = [dbo].[SCM_ARR_SPL_VAL](@p_sheet_name, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_column_name = [dbo].[SCM_ARR_SPL_VAL](@p_column_name, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_column_label_name = [dbo].[SCM_ARR_SPL_VAL](@p_column_label_name, @v_delimiter , @mst_loop_cnt) ;
				SET @v_sort_order_no = [dbo].[SCM_ARR_SPL_VAL](@p_sort_order_no, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_data_sort_method_code = [dbo].[SCM_ARR_SPL_VAL](@p_data_sort_method_code, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_small_class_label_name = [dbo].[SCM_ARR_SPL_VAL](@p_small_class_label_name, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_large_class_label_name = [dbo].[SCM_ARR_SPL_VAL](@p_large_class_label_name, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_fixed_flag = [dbo].[SCM_ARR_SPL_VAL](@p_fixed_flag, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_column_width = [dbo].[SCM_ARR_SPL_VAL](@p_column_width, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_cell_control_object_type_code = [dbo].[SCM_ARR_SPL_VAL](@p_cell_control_object_type_code, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_cell_combo_data_type			 = [dbo].[SCM_ARR_SPL_VAL](@p_cell_combo_data_type,			 @v_delimiter , @mst_loop_cnt) ; 
				SET @v_data_scale_number = [dbo].[SCM_ARR_SPL_VAL](@p_data_scale_number, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_data_max_length = [dbo].[SCM_ARR_SPL_VAL](@p_data_max_length, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_horizontal_align_code = [dbo].[SCM_ARR_SPL_VAL](@p_horizontal_align_code, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_uppercase_apply_flag = [dbo].[SCM_ARR_SPL_VAL](@p_uppercase_apply_flag, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_visible_flag = [dbo].[SCM_ARR_SPL_VAL](@p_visible_flag, @v_delimiter , @mst_loop_cnt) ;     
				SET @v_default_flag = [dbo].[SCM_ARR_SPL_VAL](@p_default_flag, @v_delimiter , @mst_loop_cnt) ;
				SET @v_user_selectable_flag = [dbo].[SCM_ARR_SPL_VAL](@p_user_selectable_flag, @v_delimiter , @mst_loop_cnt) ;
				
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ;
				SET @v_valid_yn = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter , @mst_loop_cnt) ;
				SET @v_attribute1 = [dbo].[SCM_ARR_SPL_VAL](@p_attribute1, @v_delimiter , @mst_loop_cnt) ;     
				SET @v_attribute2 = [dbo].[SCM_ARR_SPL_VAL](@p_attribute2, @v_delimiter , @mst_loop_cnt) ;     
				SET @v_attribute3 = [dbo].[SCM_ARR_SPL_VAL](@p_attribute3, @v_delimiter , @mst_loop_cnt) ;     
				SET @v_attribute4 = [dbo].[SCM_ARR_SPL_VAL](@p_attribute4, @v_delimiter , @mst_loop_cnt) ;     
				SET @v_attribute5 = [dbo].[SCM_ARR_SPL_VAL](@p_attribute5, @v_delimiter , @mst_loop_cnt) ;     
				SET @v_attribute6 = [dbo].[SCM_ARR_SPL_VAL](@p_attribute6, @v_delimiter , @mst_loop_cnt) ;     
				SET @v_created_by = [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_creation_date = CONVERT(DATETIME, [dbo].[SCM_ARR_SPL_VAL](@p_creation_date, @v_delimiter, @mst_loop_cnt) , 120);
				SET @v_last_updated_by = [dbo].[SCM_ARR_SPL_VAL](@p_last_updated_by, @v_delimiter, @mst_loop_cnt) ; 
			END

			IF @mst_loop_cnt > 0 
			BEGIN
				MERGE INTO [SCM_MST_SHEET_COLUMNS] A
				USING (
						SELECT 
								@v_program_id as program_id,
								@v_sheet_name as sheet_name,
								@v_column_name as column_name					
						) B
				ON(
							A.program_id	= B.program_id
						AND	A.sheet_name    = B.sheet_name
						AND A.column_name   = B.column_name
						
					)
				WHEN MATCHED THEN
						UPDATE SET 
							 program_id				= @v_program_id
 							,sheet_name				= @v_sheet_name
							,column_name			= @v_column_name
							,column_label_name		= @v_column_label_name
							,sort_order_no		    = @v_sort_order_no
							,data_sort_method_code  = @v_data_sort_method_code
							,small_class_label_name  = @v_small_class_label_name
							,large_class_label_name	 = @v_large_class_label_name
							,fixed_flag				 = @v_fixed_flag
							,column_width			 = @v_column_width
							,cell_control_object_type_code = @v_cell_control_object_type_code
							, cell_combo_data_type	= @v_cell_combo_data_type
							,data_scale_number		 = case when @v_data_scale_number = '' then null else @v_data_scale_number end
							,data_max_length		 = case when @v_data_max_length = '' then null else @v_data_max_length end
							,horizontal_align_code	 = @v_horizontal_align_code
							,uppercase_apply_flag	 = @v_uppercase_apply_flag
							,visible_flag			= @v_visible_flag
							,default_flag			= @v_default_flag
							,user_selectable_flag	= @v_user_selectable_flag
							,division_id			= @v_division_id
							,valid_yn				= @v_valid_yn
							,attribute1				= @v_attribute1
							,attribute2				= @v_attribute2
							,attribute3				= @v_attribute3
							,attribute4				= @v_attribute4
							,attribute5				= @v_attribute5
							,attribute6				= @v_attribute6
							,last_updated_by		= @v_last_updated_by
							,last_update_date		= sysdatetime()
					                
				WHEN NOT MATCHED THEN
				INSERT	(		
							 program_id, sheet_name, column_name
							,column_label_name, sort_order_no, default_flag, user_selectable_flag, division_id , valid_yn
							,data_sort_method_code, small_class_label_name, large_class_label_name
							,fixed_flag,column_width, cell_control_object_type_code , cell_combo_data_type
							,data_scale_number,data_max_length,horizontal_align_code
							,uppercase_apply_flag,visible_flag
							,attribute1,attribute2,attribute3,attribute4,attribute5,attribute6
							,created_by, creation_date, last_updated_by, last_update_date
						)
				VALUES  (
					 		 @v_program_id ,@v_sheet_name, @v_column_name
							,@v_column_label_name, @v_sort_order_no ,@v_default_flag , @v_user_selectable_flag , @v_division_id , @v_valid_yn
							,@v_data_sort_method_code, @v_small_class_label_name, @v_large_class_label_name
							,@v_fixed_flag, @v_column_width, @v_cell_control_object_type_code , @v_cell_combo_data_type
							, case when @v_data_scale_number = '' then null else @v_data_scale_number end
							, case when @v_data_max_length = '' then null else @v_data_max_length end
							, @v_horizontal_align_code
							,@v_uppercase_apply_flag, @v_visible_flag
							,@v_attribute1,@v_attribute2,@v_attribute3,@v_attribute4,@v_attribute5,@v_attribute6
							,@v_created_by, SYSDATETIME(), @v_created_by, SYSDATETIME()
						);
	
			END
			ELSE -- 단일 row
			 
			BEGIN   			

				SET @v_active_flag = @p_active_flag        
				SET @p_active_flag = NULL       
				SET @v_program_id = @p_program_id        
				SET @p_program_id = NULL      
				SET @v_sheet_name = @p_sheet_name        
				SET @p_sheet_name = NULL    
				SET @v_column_name = @p_column_name        
				SET @p_column_name = NULL  
				SET @v_column_label_name = @p_column_label_name        
				SET @p_column_label_name = NULL  
				SET @v_sort_order_no = @p_sort_order_no        
				SET @p_sort_order_no = NULL 
				SET @v_data_sort_method_code = @p_data_sort_method_code        
				SET @p_data_sort_method_code = NULL  
				SET @v_small_class_label_name = @p_small_class_label_name
				SET @p_small_class_label_name = NULL  
				SET @v_large_class_label_name = @p_large_class_label_name
				SET @p_large_class_label_name = NULL  
				SET @v_fixed_flag = @p_fixed_flag
				SET @p_fixed_flag = NULL  
				SET @v_column_width = @p_column_width
				SET @p_column_width = NULL  
				SET @v_cell_control_object_type_code = @p_cell_control_object_type_code
				SET @p_cell_control_object_type_code = NULL  
				SET @v_cell_combo_data_type = @p_cell_combo_data_type
				SET @p_cell_combo_data_type = NULL  
				SET @v_data_scale_number = @p_data_scale_number
				SET @p_data_scale_number = NULL  
				SET @v_data_max_length = @p_data_max_length
				SET @p_data_max_length = NULL  
				SET @v_horizontal_align_code = @p_horizontal_align_code
				SET @p_horizontal_align_code = NULL  
				SET @v_uppercase_apply_flag = @p_uppercase_apply_flag
				SET @p_uppercase_apply_flag = NULL  
				SET @v_visible_flag = @p_visible_flag        
				SET @p_visible_flag = NULL 
				SET @v_default_flag = @p_default_flag        
				SET @p_default_flag = NULL  
				
				SET @v_user_selectable_flag = @p_user_selectable_flag        
				SET @p_user_selectable_flag = NULL  

				SET @v_attribute1 = @p_attribute1
				SET @p_attribute1 = NULL  
				SET @v_attribute2 = @p_attribute2
				SET @p_attribute2 = NULL  
				SET @v_attribute3 = @p_attribute3
				SET @p_attribute3 = NULL  
				SET @v_attribute4 = @p_attribute4
				SET @p_attribute4 = NULL  
				SET @v_attribute5 = @p_attribute5
				SET @p_attribute5 = NULL  
				SET @v_attribute6 = @p_attribute6
				SET @p_attribute6 = NULL  

				SET @v_division_id = @p_division_id        
				SET @p_division_id = NULL

				SET @v_valid_yn = @p_valid_yn
				SET @p_valid_yn = NULL
				SET @v_created_by = @p_created_by
				SET @p_created_by = NULL
				SET @v_creation_date = @p_creation_date
				SET @p_creation_date = NULL					
				SET @v_last_updated_by = @p_last_updated_by
				SET @p_last_updated_by = NULL
						
			MERGE INTO [SCM_MST_SHEET_COLUMNS] A
			USING (
					SELECT 
						    @v_program_id as program_id,
							@v_sheet_name as sheet_name,
							@v_column_name as column_name					
					) B
			ON(
						A.program_id	= B.program_id
					AND	A.sheet_name    = B.sheet_name
					AND A.column_name   = B.column_name
						
				)
			WHEN MATCHED THEN
					UPDATE SET 
					     program_id				= @v_program_id
 						,sheet_name				= @v_sheet_name
						,column_name			= @v_column_name
						,column_label_name		= @v_column_label_name
						,sort_order_no		    = @v_sort_order_no
						,data_sort_method_code  = @v_data_sort_method_code
						,small_class_label_name  = @v_small_class_label_name
						,large_class_label_name	 = @v_large_class_label_name
						,fixed_flag				 = @v_fixed_flag
						,column_width			 = @v_column_width
						,cell_control_object_type_code = @v_cell_control_object_type_code
						, cell_combo_data_type	 = @v_cell_combo_data_type
						,data_scale_number		 = case when @v_data_scale_number = '' then null else @v_data_scale_number end
						,data_max_length		 = case when @v_data_max_length = '' then null else @v_data_max_length end
						,horizontal_align_code	 = @v_horizontal_align_code
						,uppercase_apply_flag	 = @v_uppercase_apply_flag
						,visible_flag			= @v_visible_flag
						,default_flag			= @v_default_flag
						, user_selectable_flag	= @v_user_selectable_flag
						, division_id			= @v_division_id
						,valid_yn				= @v_valid_yn
						,attribute1				= @v_attribute1
						,attribute2				= @v_attribute2
						,attribute3				= @v_attribute3
						,attribute4				= @v_attribute4
						,attribute5				= @v_attribute5
						,attribute6				= @v_attribute6
						,last_updated_by		= @v_last_updated_by
						,last_update_date		= sysdatetime()
					                
			WHEN NOT MATCHED THEN
			INSERT	(
						 program_id, sheet_name, column_name
						,column_label_name, sort_order_no, default_flag, user_selectable_flag, division_id , valid_yn
						,data_sort_method_code, small_class_label_name, large_class_label_name
						,fixed_flag,column_width,cell_control_object_type_code , cell_combo_data_type
						,data_scale_number,data_max_length,horizontal_align_code
						,uppercase_apply_flag,visible_flag
						,attribute1,attribute2,attribute3,attribute4,attribute5,attribute6
						,created_by, creation_date, last_updated_by, last_update_date
					)
			VALUES  (
					 	 @v_program_id ,@v_sheet_name, @v_column_name
						,@v_column_label_name, @v_sort_order_no ,@v_default_flag , @v_user_selectable_flag , @v_division_id , @v_valid_yn
						,@v_data_sort_method_code, @v_small_class_label_name, @v_large_class_label_name
						,@v_fixed_flag, @v_column_width, @v_cell_control_object_type_code , @v_cell_combo_data_type
						, case when @v_data_scale_number = '' then null else @v_data_scale_number end
						, case when @v_data_max_length	= '' then null else @v_data_max_length end 
						, @v_horizontal_align_code
						,@v_uppercase_apply_flag, @v_visible_flag
						,@v_attribute1,@v_attribute2,@v_attribute3,@v_attribute4,@v_attribute5,@v_attribute6
					    ,@v_created_by, SYSDATETIME(), @v_created_by, SYSDATETIME()
					);

				END	
			END

			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
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
		END CATCH;
	END






