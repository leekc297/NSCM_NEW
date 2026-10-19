/*
 * Program ID   : PR_DM_TO_XIF_DM_SSPM_CELL_CAR_S
 * Description  : SCM_MST_SITE_ITEM -> XIF_DM_SSPM_CELL_CAR_S 테이블로 I/F 처리 Procedure
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2022.12.06	rosia27			[C20221121-000527] EnSemble 신규 IF 요청건
 * 
 * 
 */

CREATE PROCEDURE [dbo].[PR_DM_TO_XIF_DM_SSPM_CELL_CAR_S]

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_TO_XIF_DM_SSPM_CELL_CAR_S';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION PR_DM_TO_XIF_DM_SSPM_CELL_CAR_S;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY 
	--------------------------------------------------------------------------------------------	

		DECLARE @V_IF_SEQ BIGINT

		SET @V_IF_SEQ = NEXT VALUE FOR SEQ1_XIF_DM_SSPM_CELL_CAR_S

		INSERT INTO XIF_DM_SSPM_CELL_CAR_S_SN
			 ( IF_SEQ, DIVISION_CD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_CAR
			 , CELL_MODULE, MODULE_CAR, KWH_CELL, KWH_MODULE, KWH_PACK
			 , SRC_SYS_CD, GCS_TRANSF_FLAG, GCS_TRANSF_DATE, ATTRIBUTE1_VALUE, ATTRIBUTE2_VALUE
			 , ATTRIBUTE3_VALUE, ATTRIBUTE4_VALUE, ATTRIBUTE5_VALUE, ATTRIBUTE6_VALUE, ATTRIBUTE7_VALUE
			 , ATTRIBUTE8_VALUE, ATTRIBUTE9_VALUE, ATTRIBUTE10_VALU, CREATION_DATE, LAST_UPD_DATE
			 , ETL_LOAD_DATEETL )
		SELECT @V_IF_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PER_CAR
			 , CELL_PER_MODULE
			 , CASE WHEN CELL_PER_MODULE <> 0 THEN CELL_PER_CAR / CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR
			 , CASE WHEN ISNUMERIC(ATTRIBUTE8) > 0 THEN ATTRIBUTE8 ELSE NULL END AS KWH_CELL
			 , CASE WHEN ISNUMERIC(ATTRIBUTE8) > 0 THEN ATTRIBUTE8 * CELL_PER_MODULE ELSE NULL END AS KWH_MODULE
			 , CASE WHEN ISNUMERIC(ATTRIBUTE8) > 0 THEN ATTRIBUTE8 * CELL_PER_CAR ELSE NULL END AS KWH_PACK
			 , '' AS SRC_SYS_CD, NULL AS GCS_TRANSF_FLAG, NULL AS GCS_TRANSF_DATE, NULL, NULL
			 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, GETDATE(), GETDATE()
			 , '' AS ETL_LOAD_DATEETL
		FROM   SCM_MST_SITE_ITEM


  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION PR_DM_TO_XIF_DM_SSPM_CELL_CAR_S;

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/


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
