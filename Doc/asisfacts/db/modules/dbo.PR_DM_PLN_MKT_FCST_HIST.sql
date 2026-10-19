
/*
 * Program ID   : PR_DM_PLN_MKT_FCST_HIST
 * Description  : DM PLN MKT FCST HISTORY INSERT 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 11. 27    DWOK/DWPARK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_HIST]

	@p_division_id			NVARCHAR(MAX),
	@p_project_code			NVARCHAR(MAX),
	@p_scm_site_id			NVARCHAR(MAX),
	@p_item_id				NVARCHAR(MAX),
	@p_dom_exp				NVARCHAR(MAX),
	@p_fcst_type			NVARCHAR(MAX),
	@p_incoterms			NVARCHAR(MAX),
	@p_measure				NVARCHAR(MAX),
	@p_PLANT_SITE_ID   	    NVARCHAR(MAX),
	@p_yyyymmdd				NVARCHAR(MAX),
	@p_qty					NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX)
AS

BEGIN

	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_project_code			NVARCHAR(MAX);
	DECLARE @v_scm_site_id			NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_dom_exp				NVARCHAR(MAX);
	DECLARE @v_fcst_type			NVARCHAR(MAX);
	DECLARE @v_incoterms			NVARCHAR(MAX);
	DECLARE @v_measure				NVARCHAR(MAX);
	DECLARE @v_PLANT_SITE_ID		NVARCHAR(MAX);
	DECLARE @v_yyyymmdd				NVARCHAR(MAX);
	DECLARE @v_qty					NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	DECLARE @n_history_seq			INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_HIST';
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
		BEGIN TRANSACTION PR_DM_MST_SITE_HIST;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

			BEGIN    
				SET @n_history_seq = NEXT VALUE FOR SEQ1_DM_PLN_MKT_FCST_H
				   BEGIN
						
						--[2018-03-19][수정]
						--MERGE INTO [dbo].[DM_PLN_MKT_FCST_H] A
						--USING (
						--		SELECT
						--			 @p_division_id			AS DIVISION_ID
						--			,@p_project_code		AS PROJECT_CODE
						--			,@p_scm_site_id			AS SCM_SITE_ID
						--			,@p_item_id				AS ITEM_ID
						--			,@p_dom_exp				AS DOM_EXP
						--			,@p_fcst_type			AS FCST_TYPE
						--			,@p_incoterms			AS INCOTERMS
						--			,@p_measure				AS MEASURE
						--			,@p_PLANT_SITE_ID		AS PLANT_SITE_ID
						--			,@p_yyyymmdd			AS YYYYMMDD
						--			,@p_qty					AS QTY
						--	  ) B
						--ON (
						--			A.DIVISION_ID	= B.DIVISION_ID
						--		AND A.PROJECT_CODE	= B.PROJECT_CODE
						--		AND A.SCM_SITE_ID	= B.SCM_SITE_ID
						--		AND A.ITEM_ID		= B.ITEM_ID
						--		AND A.DOM_EXP		= B.DOM_EXP
						--		AND A.FCST_TYPE		= B.FCST_TYPE
						--		AND A.INCOTERMS		= B.INCOTERMS
						--		AND A.MEASURE		= B.MEASURE
						--		AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
						--		AND A.YYYYMMDD		= B.YYYYMMDD
						--		AND A.QTY			= B.QTY
						--   )
						--WHEN NOT MATCHED THEN
						--	INSERT	  (
						--			   DIVISION_ID ,HISTORY_SEQ, PROJECT_CODE ,SCM_SITE_ID 
						--			  ,ITEM_ID ,DOM_EXP ,FCST_TYPE ,INCOTERMS ,MEASURE ,PLANT_SITE_ID,YYYYMMDD, QTY
						--			  ,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE)
						--	VALUES  
						--			  (
						--			   @p_division_id ,@n_history_seq , @p_project_code, @p_scm_site_id 
						--			  ,@p_item_id ,@p_dom_exp ,@p_fcst_type ,@p_incoterms ,@p_measure ,@p_PLANT_SITE_ID, @p_yyyymmdd, @p_qty
						--			  ,@p_created_by ,SYSDATETIME() ,@p_created_by ,SYSDATETIME()
						--			  );

						INSERT	INTO  [dbo].[DM_PLN_MKT_FCST_H]
						(									   
									   DIVISION_ID ,HISTORY_SEQ, PROJECT_CODE ,SCM_SITE_ID 
									  ,ITEM_ID ,DOM_EXP ,FCST_TYPE ,INCOTERMS ,MEASURE ,PLANT_SITE_ID,YYYYMMDD, QTY
									  ,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE
						)
						VALUES  
						(
									   @p_division_id ,@n_history_seq , @p_project_code, @p_scm_site_id 
									  ,@p_item_id ,@p_dom_exp ,@p_fcst_type ,@p_incoterms ,@p_measure ,@p_PLANT_SITE_ID, @p_yyyymmdd, @p_qty
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
	ROLLBACK TRANSACTION  PR_DM_MST_SITE_HIST;
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


