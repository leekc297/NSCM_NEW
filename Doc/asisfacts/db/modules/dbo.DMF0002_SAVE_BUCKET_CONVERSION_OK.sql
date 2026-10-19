/****************************************************************************************************/
/* Program ID  : [DMF0002_SAVE_BUCKET_CONVERSION]                                                   */
/* Description : BUCKET COVERSION 저장, 수정, 삭제                                                  */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/11/16  DWOK/DWPARK  Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0002_SAVE_BUCKET_CONVERSION_OK]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_scm_site_id			NVARCHAR(MAX),
	@p_yyyymmdd				NVARCHAR(MAX),
	@p_bucket_per			NVARCHAR(MAX),
	@p_conversion_type		NVARCHAR(MAX)
	--@p_success_yn			NVARCHAR(1) OUTPUT
AS

BEGIN
	SET NOCOUNT ON;

	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag			NVARCHAR(MAX);
	DECLARE @recv_division_id			NVARCHAR(MAX);
	DECLARE @recv_scm_site_id			NVARCHAR(MAX);
	DECLARE @recv_yyyymmdd				NVARCHAR(MAX);
	DECLARE @recv_bucket_per			NVARCHAR(MAX);
	DECLARE @recv_conversion_type		NVARCHAR(MAX);

	SET @recv_active_flag = NULL;
	SET @recv_division_id = NULL;
	SET @recv_scm_site_id = NULL;
	SET @recv_yyyymmdd = NULL;
	SET @recv_bucket_per = NULL;
	SET @recv_conversion_type = NULL;	 
		
	SET @recv_active_flag = @p_active_flag;
	SET @recv_division_id = @p_division_id;
	SET @recv_scm_site_id = @p_scm_site_id;
	SET @recv_yyyymmdd = @p_yyyymmdd;
	SET @recv_bucket_per = @p_bucket_per;
	SET @recv_conversion_type = @p_conversion_type;
	
	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_scm_site_id			NVARCHAR(MAX);
	DECLARE @v_yyyymmdd				NVARCHAR(MAX);
	DECLARE @v_bucket_per			NVARCHAR(MAX);
	DECLARE @v_conversion_type		NVARCHAR(MAX);

	SET @v_active_flag = NULL;
	SET @v_division_id = NULL;
	SET @v_scm_site_id = NULL;
	SET @v_yyyymmdd = NULL;
	SET @v_bucket_per = NULL;
	SET @v_conversion_type = NULL;	 

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0002_SAVE_BUCKET_CONVERSION_OK';
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

				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    
				SELECT @v_active_flag
					  
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
				SELECT @v_division_id

				SET @v_scm_site_id = [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id, @v_delimiter , @mst_loop_cnt) ;    
				SELECT @v_scm_site_id

				SET @v_yyyymmdd = [dbo].[SCM_ARR_SPL_VAL](@p_yyyymmdd, @v_delimiter , @mst_loop_cnt) ;    
				SELECT @v_yyyymmdd

				SET @v_bucket_per = [dbo].[SCM_ARR_SPL_VAL](@p_bucket_per, @v_delimiter , @mst_loop_cnt) ; 
				SELECT @v_bucket_per

				SET @v_conversion_type = [dbo].[SCM_ARR_SPL_VAL](@p_conversion_type, @v_delimiter, @mst_loop_cnt) ; 
				SELECT @v_conversion_type
						
			END
			
			IF @mst_loop_cnt > 0 

				BEGIN       
				
					MERGE INTO [dbo].[dm_mst_bucket_conversion] A
					USING (
							SELECT 
								@v_division_id	as division_id, 
								@v_scm_site_id	as scm_site_id, 
								@v_yyyymmdd		as yyyymmdd
						  ) B
					ON(
							    A.division_id = B.division_id
							AND A.scm_site_id = B.scm_site_id
							AND A.yyyymmdd = B.yyyymmdd
					  )
					WHEN MATCHED THEN
						 UPDATE SET 
									division_id		 = @v_division_id
								   ,scm_site_id		 = @v_scm_site_id 
								   ,yyyymmdd		 = @v_yyyymmdd
								   --,bucket_per		 = @v_bucket_per
								   --,bucket_per		 = CONVERT(INT,  REPLACE(@v_bucket_per,@v_delimiter,''))
								   --,bucket_per		 = CONVERT(INT, @v_bucket_per)
								   , bucket_per		 = CONVERT(INT,  CAST(@v_bucket_per AS NVARCHAR(10)))
								   ,last_updated_by  = 'SYSTEM'
								   ,last_update_date = sysdatetime()
					                
					WHEN NOT MATCHED THEN

						 INSERT (  division_id
								  ,project_code
								  ,scm_site_id
								  ,item_id
								  ,yyyymmdd
								  ,bucket_per
								  ,conversion_type
								  ,valid_yn
								  ,created_by
								  ,creation_date
								  ,last_updated_by
								  ,last_update_date
								)
						 VALUES (   @v_division_id
								   ,'***'
								   ,@v_scm_site_id 
								   ,'***'
								   ,@v_yyyymmdd
								   --,@v_bucket_per
								   ,CONVERT(INT,  CAST(@v_bucket_per AS NVARCHAR(10)))
								   --,CONVERT(INT,  REPLACE(@v_bucket_per,@v_delimiter,''))
								   ,@v_conversion_type
								   ,'Y'
								   ,'SYSTEM'
								   ,sysdatetime()
								   ,'SYSTEM'
								   ,sysdatetime()
								);

			  END



			ELSE    --단일 ROW 일때
			 
				BEGIN        
					SET @v_active_flag = @p_active_flag        
					SET @p_active_flag = NULL       
					SET @v_division_id = @p_division_id        
					SET @p_division_id = NULL      
					SET @v_scm_site_id = @p_scm_site_id        
					SET @p_scm_site_id = NULL    
					SET @v_yyyymmdd = @p_yyyymmdd       
					SET @p_yyyymmdd = NULL  
					SET @v_bucket_per = @p_bucket_per 
					SET @p_bucket_per = NULL
					SET @v_conversion_type = @p_conversion_type 
					SET @p_conversion_type = NULL
					
					MERGE INTO [dbo].[dm_mst_bucket_conversion] A
					USING (
							SELECT @v_division_id as division_id, @v_scm_site_id as scm_site_id, @v_yyyymmdd as yyyymmdd
						  ) B
					ON(
							    A.division_id = B.division_id
							AND A.scm_site_id = B.scm_site_id
							AND A.yyyymmdd = B.yyyymmdd
					  )
					WHEN MATCHED THEN
						 UPDATE SET 
									division_id		 = @v_division_id
								   ,scm_site_id		 = @v_scm_site_id 
								   ,yyyymmdd		 = @v_yyyymmdd
								   ,bucket_per		 = @v_bucket_per
								   ,last_updated_by  = 'system'
								   ,last_update_date = sysdatetime()
					    
					WHEN NOT MATCHED THEN

						 INSERT (  division_id
								  ,project_code
								  ,scm_site_id
								  ,item_id
								  ,yyyymmdd
								  ,bucket_per
								  ,conversion_type
								  ,valid_yn
								  ,created_by
								  ,creation_date
								  ,last_updated_by
								  ,last_update_date
								)
						 VALUES (   @v_division_id
								   ,'***'
								   ,@v_scm_site_id 
								   ,'***'
								   ,@v_yyyymmdd
								   ,@v_bucket_per
								   ,@v_conversion_type
								   ,'Y'
								   ,'system'
								   ,sysdatetime()
								   ,'system'
								   ,sysdatetime()
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
	END;





