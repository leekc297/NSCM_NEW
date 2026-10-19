
/*
 * Program ID   : PR_DM_PLN_CUSTOMER_PSI_CUTOFF
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 03. 13    JHBAEK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_CUSTOMER_PSI_CUTOFF]

	-- Add the parameters for the stored procedure here
      @p_division_id          NVARCHAR(8)    -- division_id 전달받음
	, @p_version_description  NVARCHAR(MAX)  -- description 전달받음
	, @p_ver_type			  NVARCHAR(MAX)
	, @p_created_by			  NVARCHAR(MAX)
AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @n_history_seq		INTEGER;
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_CUSTOMER_PSI_CUTOFF';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_ver_description		NVARCHAR(MAX);
	DECLARE @v_ver_type				NVARCHAR(MAX);
	DECLARE @v_rolling_type			NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);

	DECLARE	@v_ver_return_no		NVARCHAR(100);	-- cut off Generated Number	
	DECLARE @v_plan_week			NVARCHAR(MAX);
	DECLARE	@v_OK_description		NVARCHAR(1200);	-- cut off Generated Number	

	SET @v_division_id		 = NULL;	
	SET @v_ver_description	 = NULL;	
	SET @v_ver_type			 = NULL;	
	SET @v_rolling_type		 = NULL;	
	SET @v_created_by		 = NULL;	

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION PR_DM_PLN_CUSTOMER_PSI_CUTOFF;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
            set @v_division_id = @p_division_id;

			EXEC	[dbo].[PR_DM_PLN_VERSION_CREATE]	--@return_value = [dbo].[PR_DM_PLN_VERSION_CREATE]
			 @v_division_id
			,@p_version_description
			,@p_ver_type
			,@p_created_by
			,@v_ver_return_no  OUTPUT
			,@v_OK_description OUTPUT
					
			--확인 SELECT @v_division_id AS '@v_division_id' ;
			--확인 SELECT @v_ver_return_no AS '@v_ver_return_no' , @v_OK_description AS '@v_OK_description';

			-- (1) 	 

			/* CUTOFF DATA INSERT */
			BEGIN
				INSERT INTO [dbo].[DM_PLN_CUSTOMER_PSI_C]
				SELECT 
					 DIVISION_ID
					,@v_ver_return_no AS VERSION_NO --VERSION_NO
					,@p_ver_type AS CUTOFF_TYPE      -- CUTOFF_TYPE
					,CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS CUTOFF_YYYYMMDD  -- CUTOFF_YYYYMMDD
					,[CUSTOMER_PROJECT_CODE]	
					,[CUSTOMER_MODEL]			
					,[SCM_SITE_ID]				
					,[DOM_EXP]					
					,[FCST_TYPE]				
					,[MEASURE_GROUP]			
					,[MEASURE]					
					,[YYYYMMDD]					
					,[INCOTERMS]				
					,[PLANT_SITE_ID]			
					,[PROJECT_CODE]				
					,[ITEM_ID]					
					,[QTY]						
					,[UPLOAD_UOM]				
					,[CREATED_BY]				
					,[CREATION_DATE]			
					,[LAST_UPDATED_BY]			
					,[LAST_UPDATE_DATE]			
					,[BATCH_RESULT]				
					,[MST_UPLOAD_UOM]			
					,[MST_UPLOAD_BUCKET_TYPE]	
					,[MST_SUMMARY_BUCKET_TYPE]	
					,[MST_CONVERT_QTY]			
					,[PLAN_WEEK]				
					,[SPLIT_RESULT]				
					,[ATTRIBUTE1]				
					,[ATTRIBUTE2]				
					,[ATTRIBUTE3]				
					,[ATTRIBUTE4]				
					,[ATTRIBUTE5]				
					,[ATTRIBUTE6]				
					,[ATTRIBUTE7]				
					,[ATTRIBUTE8]				
					,[ATTRIBUTE9]				
					,[ATTRIBUTE10]				
			    FROM [dbo].DM_PLN_CUSTOMER_PSI WITH(NOLOCK)
			   WHERE DIVISION_ID  LIKE '%' + @v_division_id + '%'
				 AND [YYYYMMDD]     >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			END

	
  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION PR_DM_PLN_CUSTOMER_PSI_CUTOFF;
		-- ROLLBACK
		-- ERROR LOG VALUE SAVE
		SET @v_log_type    = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date  = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/


		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  END;
