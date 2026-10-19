
/*
 * Program ID   : PR_DM_MST_CUSTOMER_FCST_HIST
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_PARAMETER' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 03. 14    JHBAEK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_MST_CUSTOMER_FCST_HIST]

	-- Add the parameters for the stored procedure here
	@p_division_id				NVARCHAR(MAX),
	@p_plan_week				NVARCHAR(MAX),
	@p_customer_code			NVARCHAR(MAX),
	@p_scm_site_id				NVARCHAR(MAX),		
	@p_summary_bucket_value		NVARCHAR(MAX),
	@p_measure_group			NVARCHAR(MAX),
	@p_measure					NVARCHAR(MAX),
	@p_valid_yn					NVARCHAR(MAX),
	@p_customer_psi				NVARCHAR(MAX),
	@p_upload_uom				NVARCHAR(MAX),
	@p_upload_bucket_type		NVARCHAR(MAX),
	@p_summary_bucket_type		NVARCHAR(MAX),
	@p_edi_fcst_yn				NVARCHAR(MAX),
	@p_upload_user_id			NVARCHAR(MAX),
	@p_created_by				NVARCHAR(MAX),
	@p_update_by				NVARCHAR(MAX)
														
AS														

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @n_history_seq		INTEGER;
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_CUSTOMER_FCST_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_trancount    INT;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		BEGIN TRANSACTION PR_DM_MST_CUSTOMER_FCST_HIST;
		
	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

			-- (1) 	 
            /* HISTIRY INSERT */
			BEGIN
        	SET @n_history_seq = NEXT VALUE FOR SEQ1_DM_MST_CUSTOMER_FCST_H
            INSERT INTO dbo.DM_MST_CUSTOMER_FCST_H 
				   (DIVISION_ID					,  
					HISTORY_SEQ					,
					PLAN_WEEK					,
					CUSTOMER_CODE				,
					SCM_SITE_ID					,
					SUMMARY_BUCKET_VALUE		,
					MEASURE_GROUP				,
					MEASURE						,
					VALID_YN					,
					CUSTOMER_PSI				,
					UPLOAD_UOM					,
					UPLOAD_BUCKET_TYPE			,
					SUMMARY_BUCKET_TYPE			,
					EDI_FCST_YN					,
					UPLOAD_USER_ID				,
					CREATED_BY					,
					CREATION_DATE				,
					LAST_UPDATED_BY				,
					LAST_UPDATE_DATE			,
					ATTRIBUTE1					,
					ATTRIBUTE2					,
					ATTRIBUTE3					,
					ATTRIBUTE4					,
					ATTRIBUTE5					,
					ATTRIBUTE6					,
					ATTRIBUTE7					,
					ATTRIBUTE8					,
					ATTRIBUTE9					,
					ATTRIBUTE10					
					)
         VALUES
               (
					@p_division_id			
					,@n_history_seq	
					,@p_plan_week				
					,@p_customer_code			
					,@p_scm_site_id		
					,@p_summary_bucket_value		
					,@p_measure_group			
					,@p_measure					
					,@p_valid_yn					
					,@p_customer_psi	
					,@p_upload_uom				
					,@p_upload_bucket_type		
					,@p_summary_bucket_type		
					,@p_edi_fcst_yn				
					,@p_upload_user_id	
					,@p_created_by	
					,sysdatetime()			
					,@p_update_by	
					,sysdatetime()						
				,null,null,null,null,null,null,null,null,null,null
    	         )
			END
			-- (1) 
			
			IF @@TRANCOUNT > 0 
				COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
		BEGIN CATCH
	--------------------------------------------------------------	

	-- 트랜잭션 (END)
		ROLLBACK TRANSACTION PR_DM_MST_CUSTOMER_FCST_HIST;

		-- ROLLBACK
		-- ERROR LOG VALUE SAVE
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

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

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    --EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  -- TRANSACTION 충돌되므로 주석처리

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
