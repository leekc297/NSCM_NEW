
/*
 * Program ID   : PR_DM_PLN_CUSTOMER_PSI_UPLOAD_HIST
 * Description  : SCM MST SITE ITEM H HISTORYT
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 11. 29    DWOK/DWPARK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_CUSTOMER_PSI_UPLOAD_HIST]

	@p_division_id				NVARCHAR(MAX),
	@p_customer_project_code	NVARCHAR(MAX),
	@p_customer_model			NVARCHAR(MAX),
	@p_dom_exp					NVARCHAR(MAX),
	@p_fcst_type				NVARCHAR(MAX),
	@p_measure1					NVARCHAR(MAX),
	@p_measure2					NVARCHAR(MAX),
	@p_yyyymmdd					NVARCHAR(MAX),
	@p_incoterms				NVARCHAR(MAX),
	@p_customer_name			NVARCHAR(MAX),
	@p_site_description			NVARCHAR(MAX),
	@p_qty						NVARCHAR(MAX),
	@p_upload_user_id			NVARCHAR(MAX),
	@p_upload_date				NVARCHAR(MAX),
	@p_created_by				NVARCHAR(MAX)
AS

BEGIN

	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @v_division_id				NVARCHAR(MAX);
	DECLARE @v_customer_project_code	NVARCHAR(MAX);
	DECLARE @v_customer_model			NVARCHAR(MAX);
	DECLARE @v_dom_exp					NVARCHAR(MAX);
	DECLARE @v_fcst_type				NVARCHAR(MAX);
	DECLARE @v_measure1					NVARCHAR(MAX);
	DECLARE @v_measure2					NVARCHAR(MAX);
	DECLARE @v_yyyymmdd					NVARCHAR(MAX);
	DECLARE @v_incoterms				NVARCHAR(MAX);
	DECLARE @v_customer_name			NVARCHAR(MAX);
	DECLARE @v_site_description			NVARCHAR(MAX);
	DECLARE @v_qty						NVARCHAR(MAX);
	DECLARE @v_upload_user_id			NVARCHAR(MAX);
	DECLARE @v_upload_date				NVARCHAR(MAX);
	DECLARE @v_created_by				NVARCHAR(MAX);
	DECLARE @n_history_seq				INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_CUSTOMER_PSI_UPLOAD_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	--[C20200909-000203] LOG 표준화 적용
		-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 트랜잭션 (START)
		BEGIN TRANSACTION CUSTOMER_PSI_UPLOAD_HIST;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

			BEGIN    
				SET @n_history_seq = NEXT VALUE FOR SEQ1_DM_TMP_CUSTOMER_UPLOAD_PSI_H
				   BEGIN
						
						--[2018-03-19][수정]
						--MERGE INTO [dbo].[DM_TMP_CUSTOMER_UPLOAD_PSI_H] A
						--USING (
						--		SELECT
						--			 @p_division_id				AS DIVISION_ID
						--			,@p_customer_project_code	AS CUSTOMER_PROJECT_CODE
						--			,@p_customer_model			AS CUSTOMER_MODEL
						--			,@p_dom_exp					AS DOM_EXP
						--			,@p_fcst_type				AS FCST_TYPE
						--			,@p_measure1				AS MEASURE1
						--			,@p_measure2				AS MEASURE2
						--			,@p_yyyymmdd				AS YYYYMMDD
						--			,@p_incoterms				AS INCOTERMS
						--			,@p_customer_name			AS CUSTOMER_NAME
						--			,@p_site_description		AS SITE_DESCRIPTION
						--			,@p_qty						AS QTY
						--			,@p_upload_user_id			AS UPLOAD_USER_ID
						--			,@p_upload_date				AS UPLOAD_DATE
						--	  ) B
						--ON (
						--			A.DIVISION_ID			= B.DIVISION_ID
						--		AND A.CUSTOMER_PROJECT_CODE	= B.CUSTOMER_PROJECT_CODE
						--		AND A.CUSTOMER_MODEL		= B.CUSTOMER_MODEL
						--		AND A.DOM_EXP				= B.DOM_EXP
						--		AND A.FCST_TYPE				= B.FCST_TYPE
						--		AND A.MEASURE1				= B.MEASURE1
						--		AND A.MEASURE2				= B.MEASURE2
						--		AND A.YYYYMMDD				= B.YYYYMMDD

						--		AND A.INCOTERMS				= B.INCOTERMS
						--		AND A.CUSTOMER_NAME			= B.CUSTOMER_NAME
						--		AND A.SITE_DESCRIPTION		= B.SITE_DESCRIPTION
						--		AND A.QTY					= B.QTY
						--		AND A.UPLOAD_USER_ID		= B.UPLOAD_USER_ID
						--		AND A.UPLOAD_DATE			= B.UPLOAD_DATE
						--   )
						--WHEN NOT MATCHED THEN
						--	INSERT	  (
						--			   DIVISION_ID ,HISTORY_SEQ, CUSTOMER_PROJECT_CODE ,CUSTOMER_MODEL 
						--			  ,DOM_EXP ,FCST_TYPE ,MEASURE1 ,MEASURE2 ,YYYYMMDD
						--			  ,INCOTERMS ,CUSTOMER_NAME ,SITE_DESCRIPTION ,QTY ,UPLOAD_USER_ID ,UPLOAD_DATE
						--			  ,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE)
						--	VALUES  
						--			  (
						--			   @p_division_id , @n_history_seq ,@p_customer_project_code, @p_customer_model 
						--			  ,@p_dom_exp ,@p_fcst_type ,@p_measure1 ,@p_measure2 ,@p_yyyymmdd
						--			  ,@p_incoterms ,@p_customer_name ,@p_site_description ,@p_qty ,@p_upload_user_id ,@p_upload_date
						--			  ,@p_created_by ,SYSDATETIME() ,@p_created_by ,SYSDATETIME()
						--			  );


							INSERT	INTO  [dbo].[DM_TMP_CUSTOMER_UPLOAD_PSI_H]
							(									   
									   DIVISION_ID ,HISTORY_SEQ, CUSTOMER_PROJECT_CODE ,CUSTOMER_MODEL 
									  ,DOM_EXP ,FCST_TYPE ,MEASURE1 ,MEASURE2 ,YYYYMMDD
									  ,INCOTERMS ,CUSTOMER_NAME ,SITE_DESCRIPTION ,QTY ,UPLOAD_USER_ID ,UPLOAD_DATE
									  ,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE
							)
							VALUES  
							(
									   @p_division_id , @n_history_seq ,@p_customer_project_code, @p_customer_model 
									  ,@p_dom_exp ,@p_fcst_type ,@p_measure1 ,@p_measure2 ,@p_yyyymmdd
									  ,@p_incoterms ,@p_customer_name ,@p_site_description ,@p_qty ,@p_upload_user_id ,@p_upload_date
									  ,@p_created_by ,SYSDATETIME() ,@p_created_by ,SYSDATETIME()
						   );

				   END
		
				
			END

		COMMIT WORK;

		END TRY

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	--[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION  CUSTOMER_PSI_UPLOAD_HIST;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

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


