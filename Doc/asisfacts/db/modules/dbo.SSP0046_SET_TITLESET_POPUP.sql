

/*
 * Program ID   : SSP0046_SET_TITLESET_POPUP
 * Description  : Column Setting, Measure Setting
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.21   정병훈         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[SSP0046_SET_TITLESET_POPUP]

  @p_program_id				NVARCHAR(MAX),
  @p_sheet_name				NVARCHAR(MAX),
  @p_column_type			NVARCHAR(MAX),
  @p_active_flag			NVARCHAR(MAX),
  @p_column_name			NVARCHAR(MAX),
  @p_sort_order_no			NVARCHAR(MAX),
  @p_sub_total_flag			NVARCHAR(MAX),
  @p_sort_method_code		NVARCHAR(MAX),
  @p_user_id				NVARCHAR(MAX) 
AS
BEGIN
	SET NOCOUNT ON;
	-- SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag			NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

    DECLARE @v_program_id			NVARCHAR(MAX);
    DECLARE @v_sheet_name			NVARCHAR(MAX);
    DECLARE @v_column_type			NVARCHAR(MAX);
	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_column_name			NVARCHAR(MAX);
	DECLARE @v_sort_order_no		NVARCHAR(MAX);
    DECLARE @v_sub_total_flag		NVARCHAR(MAX);
    DECLARE @v_sort_method_code		NVARCHAR(MAX);
    DECLARE @v_user_id				NVARCHAR(MAX);

	SET  @v_program_id= NULL;
	SET  @v_sheet_name= NULL;
	SET  @v_column_type= NULL;	
	SET  @v_active_flag = NULL;
	SET  @v_column_name = NULL;
	SET  @v_sort_order_no = NULL;
	SET  @v_sub_total_flag = NULL;
	SET  @v_sort_method_code = NULL;
	SET  @v_user_id= NULL;

	DECLARE @v_delimiter			NVARCHAR(10)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(1500) = 'SCM_MST_SET_TITLESET';
    DECLARE @v_log_type     NVARCHAR(300); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(1000);
    DECLARE @d_event_date   DATETIME;

 BEGIN 

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

		DELETE FROM scm_mst_titleset_user
		WHERE  user_id          = @p_user_id 
		AND    program_id       = @p_program_id 
		AND    sheet_name       = @p_sheet_name
		AND    user_inquiry_column_type_code = @p_column_type;


	BEGIN TRY

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN    
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				
				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    		  
				SET @v_column_name = [dbo].[SCM_ARR_SPL_VAL](@p_column_name, @v_delimiter , @mst_loop_cnt) ; 			
				SET @v_sort_order_no = [dbo].[SCM_ARR_SPL_VAL](@p_sort_order_no, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_sub_total_flag = [dbo].[SCM_ARR_SPL_VAL](@p_sub_total_flag, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_sort_method_code = [dbo].[SCM_ARR_SPL_VAL](@p_sort_method_code, @v_delimiter , @mst_loop_cnt) ;
			END
		
			IF @mst_loop_cnt > 0 -- 여러개
			 
			BEGIN      

				IF @p_column_type = 'C'  --Column	

				INSERT INTO scm_mst_titleset_user
				( user_id    , program_id   , sheet_name    , user_inquiry_column_type_code
				, column_name, sort_order_no, sub_total_flag, data_sort_method_code
				, created_by , creation_date, last_updated_by, last_update_date )
				SELECT @p_user_id
					 , c.program_id
					 , c.sheet_name
					 , @p_column_type
					 , c.column_name
					 --, p_sort_order_no(i) + c.sort_order_no - TRUNC(c.sort_order_no)
					 , CASE WHEN @v_sort_order_no IS NULL OR @v_sort_order_no = 0 THEN c.sort_order_no
							ELSE @v_sort_order_no + c.sort_order_no - ROUND(c.sort_order_no,0,1)
					   END
					 , @v_sub_total_flag
					 , @v_sort_method_code
					 , @p_user_id
					 , sysdatetime()
					 , @p_user_id
					 , sysdatetime()
				FROM   scm_mst_sheet_columns c  WITH(NOLOCK)
				WHERE  c.program_id = @p_program_id
				AND    c.sheet_name = @p_sheet_name
				AND    c.sort_order_no = (SELECT sort_order_no
												 FROM   scm_mst_sheet_columns  WITH(NOLOCK)
												 WHERE  program_id  = @p_program_id
												 AND    sheet_name  = @p_sheet_name
												 AND    column_name = @v_column_name)
				AND    NOT EXISTS (SELECT 1 FROM scm_mst_titleset_user  WITH(NOLOCK)
								   WHERE  program_id  = c.program_id
								   AND    sheet_name  = c.sheet_name
								   AND    column_name = c.column_name
								   AND    user_id     = @p_user_id);

				
								   
				ELSE IF(@v_column_name != NULL OR @v_column_name !='' ) -- Measure
				
				INSERT INTO scm_mst_titleset_user
				( user_id    , program_id   , sheet_name    , user_inquiry_column_type_code
				, column_name, sort_order_no, sub_total_flag, data_sort_method_code
				, created_by , creation_date, last_updated_by, last_update_date )
				VALUES
				( @p_user_id       , @p_program_id   , @p_sheet_name    , @p_column_type
				, @v_column_name, @v_sort_order_no, @v_sub_total_flag, @v_sort_method_code
				, @p_user_id , sysdatetime(), @p_user_id, sysdatetime());
				
				/*
				INSERT INTO scm_mst_titleset_user
				( user_id    , program_id   , sheet_name    , user_inquiry_column_type_code
				, column_name, sort_order_no, sub_total_flag, data_sort_method_code
				, created_by , creation_date, last_updated_by, last_update_date )
				SELECT 
				 @p_user_id       , @p_program_id   , @p_sheet_name    , @p_column_type
				, m.column_name, @v_sort_order_no, @v_sub_total_flag, @v_sort_method_code
				, @p_user_id , sysdatetime(), @p_user_id, sysdatetime()
				FROM   scm_mst_sheet_measure m
				WHERE  m.program_id = @p_program_id
				AND    m.sheet_name = @p_sheet_name
				AND    m.column_name = @p_column_name
				;*/
			  
			END
			
			ELSE 

			  BEGIN
				SET @v_active_flag = @p_active_flag        
				SET @p_active_flag = NULL       
				SET @v_column_name = @p_column_name        
				SET @p_column_name = NULL      
				SET @v_sort_order_no = @p_sort_order_no        
				SET @p_sort_order_no = NULL    
				SET @v_sub_total_flag = @p_sub_total_flag       
				SET @p_sub_total_flag = NULL  
				SET @v_sort_method_code = @p_sort_method_code 
				SET @p_sort_method_code = NULL
		      
			  	IF @p_column_type = 'C'  --Column		
				INSERT INTO scm_mst_titleset_user
				( user_id    , program_id   , sheet_name    , user_inquiry_column_type_code
				, column_name, sort_order_no, sub_total_flag, data_sort_method_code
				, created_by , creation_date, last_updated_by, last_update_date )
				SELECT @p_user_id
					 , c.program_id
					 , c.sheet_name
					 , @p_column_type
					 , c.column_name
					 --, p_sort_order_no(i) + c.sort_order_no - TRUNC(c.sort_order_no)
					 , CASE WHEN @v_sort_order_no IS NULL OR @v_sort_order_no = 0 THEN c.sort_order_no
							ELSE @v_sort_order_no + c.sort_order_no - ROUND(c.sort_order_no,0,1)
					   END
					 , @v_sub_total_flag
					 , @v_sort_method_code
					 , @p_user_id
					 , sysdatetime()
					 , @p_user_id
					 , sysdatetime()
				FROM   scm_mst_sheet_columns c  WITH(NOLOCK)
				WHERE  c.program_id = @p_program_id
				AND    c.sheet_name = @p_sheet_name
				AND    ROUND(c.sort_order_no,0,1) = (SELECT ROUND(sort_order_no,0,1)
												 FROM   scm_mst_sheet_columns  WITH(NOLOCK)
												 WHERE  program_id  = @p_program_id
												 AND    sheet_name  = @p_sheet_name
												 AND    column_name = @v_column_name)
				AND    NOT EXISTS (SELECT 1 FROM scm_mst_titleset_user  WITH(NOLOCK)
								   WHERE  program_id  = c.program_id
								   AND    sheet_name  = c.sheet_name
								   AND    column_name = c.column_name
								   AND    user_id     = @p_user_id);
				ELSE IF(@v_column_name != NULL OR @v_column_name !='' )-- Measure
				INSERT INTO scm_mst_titleset_user
				( user_id    , program_id   , sheet_name    , user_inquiry_column_type_code
				, column_name, sort_order_no, sub_total_flag, data_sort_method_code
				, created_by , creation_date, last_updated_by, last_update_date )
				VALUES
				( @p_user_id       , @p_program_id   , @p_sheet_name    , @p_column_type
				, @v_column_name, @v_sort_order_no, @v_sub_total_flag, @v_sort_method_code
				, @p_user_id , sysdatetime(), @p_user_id, sysdatetime());
			  
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
END


