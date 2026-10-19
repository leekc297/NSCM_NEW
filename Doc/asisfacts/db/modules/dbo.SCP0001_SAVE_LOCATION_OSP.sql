/*
 * Program ID   : SCP0001_SAVE_LOCATION_OSP
 * Description  : LOCATION OSP 등록,수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/08/10   ygkim          Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE PROCEDURE [dbo].[SCP0001_SAVE_LOCATION_OSP]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_scm_site_id 			NVARCHAR(MAX),
	@p_plant_id 			NVARCHAR(MAX),
	@p_description			NVARCHAR(MAX),
	@p_storage_id			NVARCHAR(MAX),
	@p_valid_yn			    NVARCHAR(MAX),
	@p_last_updated_by		NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_scm_site_id 			NVARCHAR(MAX);
	DECLARE @v_plant_id 			NVARCHAR(MAX);
	DECLARE @v_osp_description		NVARCHAR(MAX);
	DECLARE @v_storage_id			NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);
	DECLARE @v_last_updated_by		NVARCHAR(MAX);

	SET @v_active_flag = NULL;
	SET @v_division_id = NULL;
	SET @v_scm_site_id = NULL;
	SET @v_plant_id = NULL;
	SET @v_osp_description = NULL;	 
	SET @v_storage_id = NULL;	
	SET @v_valid_yn = NULL;	
	SET @v_last_updated_by = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0001_SAVE_LOCATION_OSP';
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
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_scm_site_id = [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_osp_description = [dbo].[SCM_ARR_SPL_VAL](@p_description, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_storage_id = [dbo].[SCM_ARR_SPL_VAL](@p_storage_id, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_valid_yn = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter, @mst_loop_cnt) ; 	
				SET @v_last_updated_by = [dbo].[SCM_ARR_SPL_VAL](@p_last_updated_by, @v_delimiter, @mst_loop_cnt) ; 
			END

			EXEC [PR_SCM_MST_LOCATION_OSP_HIST]
										 @v_division_id
										,@v_scm_site_id
										,@v_plant_id
										,@v_osp_description
										,@v_storage_id
										,@v_valid_yn
										,@v_last_updated_by
															
			 ;
			
			IF @mst_loop_cnt > 0 
			
			BEGIN
		
			MERGE INTO [SCM_MST_OSP_SLOC] A
			USING (
					SELECT 
						    @v_division_id as division_id
						   ,@v_plant_id as plant_id
						   ,@v_storage_id as storage_id
						   ,@v_scm_site_id as scm_site_id		
					) B
			ON(
						a.division_id = b.division_id
					and a.plant_id = b.plant_id
					and a.storage_id = b.storage_id
					and a.scm_site_id = b.scm_site_id
				)
			WHEN MATCHED THEN
					UPDATE SET 
					     DESCRIPTION = @v_osp_description
						,valid_yn			  = @v_valid_yn
						,last_updated_by	  = @v_last_updated_by
						,last_update_date	  = sysdatetime()
					                
			WHEN NOT MATCHED THEN
			INSERT	(		
						 DIVISION_ID
						,PLANT_ID
						,STORAGE_ID
						,SCM_SITE_ID
						,DESCRIPTION
						,VALID_YN
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
					)
			VALUES  (
					 	@v_division_id
					   ,@v_plant_id
					   ,@v_storage_id
					   ,@v_scm_site_id
					   ,@v_osp_description
					   ,@v_valid_yn
					   ,@v_last_updated_by
					   ,SYSDATETIME()
					   ,@v_last_updated_by
					   ,SYSDATETIME()
					);
	
			END
			END

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






