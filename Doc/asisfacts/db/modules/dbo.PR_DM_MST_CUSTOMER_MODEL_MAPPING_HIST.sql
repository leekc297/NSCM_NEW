
/*
 * Program ID   : PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST
 * Description  : DM MST CUSTOMER MODEL MAPPING HISTORYT
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 11. 27    DWOK/DWPARK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST]

	@p_division_id				NVARCHAR(MAX),
	@p_customer_project_code	NVARCHAR(MAX),
	@p_customer_model			NVARCHAR(MAX),
	@p_scm_site_id				NVARCHAR(MAX),
	@p_project_code				NVARCHAR(MAX),
	@p_item_id					NVARCHAR(MAX),
	@p_valid_yn					NVARCHAR(MAX),
	@p_customer_model_type		NVARCHAR(MAX),
	@p_convert_qty_pack			NVARCHAR(MAX),
	@p_convert_qty_module		NVARCHAR(MAX),
	@p_convert_qty_cell			NVARCHAR(MAX),
	@p_created_by				NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @v_division_id				NVARCHAR(MAX);
	DECLARE @v_customer_project_code	NVARCHAR(MAX);
	DECLARE @v_customer_model			NVARCHAR(MAX);
	DECLARE @v_scm_site_id				NVARCHAR(MAX);
	DECLARE @v_project_code				NVARCHAR(MAX);
	DECLARE @v_item_id					NVARCHAR(MAX);
	DECLARE @v_valid_yn					NVARCHAR(MAX);
	DECLARE @v_customer_model_type		NVARCHAR(MAX);
	DECLARE @v_convert_qty_pack			NVARCHAR(MAX);
	DECLARE @v_convert_qty_module		NVARCHAR(MAX);
	DECLARE @v_convert_qty_cell			NVARCHAR(MAX);
	DECLARE @v_created_by				NVARCHAR(MAX);
	DECLARE @n_history_seq			INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	--[C20200909-000203] LOG 표준화 적용
	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)
		-- 트랜잭션 (START)
		BEGIN TRANSACTION CUSTOMER_MODEL_MAPPING_HIST;

		BEGIN TRY
				
			BEGIN    
				SET @n_history_seq = NEXT VALUE FOR SEQ1_DM_MST_CUSTOMER_MODEL_H
				   BEGIN
						
						--[2018-03-19][수정]
						--MERGE INTO [dbo].[DM_MST_CUSTOMER_MODEL_H] A
						--USING (
						--		SELECT
						--			 @p_division_id				AS DIVISION_ID
						--			,@p_customer_project_code	AS CUSTOMER_PROJECT_CODE
						--			,@p_customer_model			AS CUSTOMER_MODEL
						--			,@p_scm_site_id				AS SCM_SITE_ID
						--			,@p_project_code			AS PROJECT_CODE
						--			,@p_item_id					AS ITEM_ID
						--			,@p_valid_yn				AS VALID_YN
						--			,@p_customer_model_type		AS CUSTOMER_MODEL_TYPE
						--			,@p_convert_qty_pack		AS CONVERT_QTY_PACK
						--			,@p_convert_qty_module		AS CONVERT_QTY_MODULE
						--			,@p_convert_qty_cell		AS CONVERT_QTY_CELL
						--	  ) B
						--ON (
						--			A.DIVISION_ID				= B.DIVISION_ID
						--		AND A.CUSTOMER_PROJECT_CODE		= B.CUSTOMER_PROJECT_CODE
						--		AND A.CUSTOMER_MODEL			= B.CUSTOMER_MODEL
						--		AND A.SCM_SITE_ID				= B.SCM_SITE_ID
						--		AND A.PROJECT_CODE				= B.PROJECT_CODE
						--		AND A.ITEM_ID					= B.ITEM_ID
						--		AND A.VALID_YN					= B.VALID_YN
						--		AND A.CUSTOMER_MODEL_TYPE		= B.CUSTOMER_MODEL_TYPE
						--		AND A.CONVERT_QTY_PACK			= B.CONVERT_QTY_PACK
						--		AND A.CONVERT_QTY_MODULE		= B.CONVERT_QTY_MODULE
						--		AND A.CONVERT_QTY_CELL			= B.CONVERT_QTY_CELL

						--   )
						----WHEN MATCHED THEN
						--	--UPDATE SET
						--	--			 last_updated_by = @p_created_by
						--	--			,last_update_date = sysdatetime()
						--WHEN NOT MATCHED THEN
						--	INSERT	  (
						--			   DIVISION_ID ,HISTORY_SEQ, CUSTOMER_PROJECT_CODE ,CUSTOMER_MODEL 
						--			  ,SCM_SITE_ID ,PROJECT_CODE ,ITEM_ID ,VALID_YN ,CUSTOMER_MODEL_TYPE 
						--			  ,CONVERT_QTY_PACK ,CONVERT_QTY_MODULE ,CONVERT_QTY_CELL
						--			  ,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE)
						--	VALUES  
						--			  (
						--			   @p_division_id , @n_history_seq ,@p_customer_project_code, @p_customer_model 
						--			  ,@p_scm_site_id ,@p_project_code ,@p_item_id ,@p_valid_yn ,@p_customer_model_type 
						--			  ,@p_convert_qty_pack ,@p_convert_qty_module ,@p_convert_qty_cell
						--			  ,@p_created_by ,SYSDATETIME() ,@p_created_by ,SYSDATETIME()
						--			  );

							INSERT	INTO  [dbo].[DM_MST_CUSTOMER_MODEL_H]
							(									   
									   DIVISION_ID ,HISTORY_SEQ, CUSTOMER_PROJECT_CODE ,CUSTOMER_MODEL 
									  ,SCM_SITE_ID ,PROJECT_CODE ,ITEM_ID ,VALID_YN ,CUSTOMER_MODEL_TYPE 
									  ,CONVERT_QTY_PACK ,CONVERT_QTY_MODULE ,CONVERT_QTY_CELL
									  ,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE
							)
							VALUES  
							(
									   @p_division_id , @n_history_seq ,@p_customer_project_code, @p_customer_model 
									  ,@p_scm_site_id ,@p_project_code ,@p_item_id ,@p_valid_yn ,@p_customer_model_type 
									  ,@p_convert_qty_pack ,@p_convert_qty_module ,@p_convert_qty_cell
									  ,@p_created_by ,SYSDATETIME() ,@p_created_by ,SYSDATETIME()
						   );

				   END

				
			END

		COMMIT WORK ;	

		END TRY

     BEGIN CATCH
		--[C20200909-000203] LOG 표준화 적용
		ROLLBACK TRANSACTION CUSTOMER_MODEL_MAPPING_HIST;

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
      
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


    END CATCH

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END; 




