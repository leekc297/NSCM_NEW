--exec [PR_SCM_LGTM_PCY_INV_MGMT_PLAN_DATE_CREATE] '20250623'
-- exec [PR_SCM_LGTM_PCY_INV_MGMT_PLAN_DATE_CREATE] '20250630'
-- exec [PR_SCM_LGTM_PCY_INV_MGMT_PLAN_DATE_CREATE] '20250707'
-- exec [PR_SCM_LGTM_PCY_INV_MGMT_PLAN_DATE_CREATE] '20250714'
/*
 * Program ID   : PR_SCM_LGTM_PCY_INV_MGMT_PLAN_DATE_CREATE
 * Description  : Tac TIme Master History 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025.07.22   ymh			   [csr :E20250721-000256] Policy-based Inv - PLAN DATE 생성건	
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCM_LGTM_PCY_INV_MGMT_PLAN_DATE_CREATE]
    @p_plan_start_yyyymmdd     NVARCHAR(8)
AS

BEGIN

	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = OBJECT_NAME(@@PROCID);
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	------------------------------------------------------------------------  

	------------------------------------------------------------------------
	-- LOG 시작
	------------------------------------------------------------------------
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description =  @p_plan_start_yyyymmdd; 
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------  

    ------------------------------------------------------------------------
	-- Parameter 대신 변수 할당
	------------------------------------------------------------------------
    DECLARE @v_plan_start_yyyymmdd  NVARCHAR(8)     = @p_plan_start_yyyymmdd    -- '20240701';
	DECLARE @v_chk_plan_start_yyyymmdd  NVARCHAR(8)
    ------------------------------------------------------------------------  


	BEGIN TRANSACTION LGTM_PCY_INV_CREATE;
	------------------------------------------------------------------------  
    BEGIN TRY

        ------------------------------------------------------------------------
		-- Step 1. Initialize Data
		------------------------------------------------------------------------
        
		------------------------------------------------------------------------
		-- Step 1-1. Delete PLAN DATA
		------------------------------------------------------------------------   
        BEGIN


			DELETE 
            FROM   SCP_ANL_LGTM_PCY_INV_MGMT_PLAN
			WHERE   1=1
            AND     PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd


        END
		------------------------------------------------------------------------   
           
		------------------------------------------------------------------------
		
		SELECT @v_chk_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD) FROM SCP_ANL_LGTM_PCY_INV_MGMT_PLAN WHERE  PLAN_START_YYYYMMDD < @v_plan_start_yyyymmdd

        BEGIN

			INSERT INTO SCP_ANL_LGTM_PCY_INV_MGMT_PLAN
			SELECT 
			@v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
			, PLAN_TP_CD
			, DIVISION_ID
			, PLANT_ID
			, ITEM_ID
			, PLAN_YYYYMMDD
			, OCCR_RSN_CD
			, OCCR_RSN_CTN
			, EXHT_TP_CD
			, EXHT_TP_CTN
			, QTY
			, SUPPLIER_CODE
			, GETDATE() AS CREATE_DATE
			, 'SYSTEM' AS CREATED_BY
			, GETDATE() AS LAST_UPDATE_DATE
			, 'SYSTEM' AS LAST_UPDATED_BY
			, @v_plan_start_yyyymmdd + '-'+ CAST( NEXT VALUE FOR SEQ1_SCP_ANL_LGTM_PCY_INV_MGMT_PLAN AS NVARCHAR) AS REQUEST_NO
			, COMPANY_ID
			FROM SCP_ANL_LGTM_PCY_INV_MGMT_PLAN
			WHERE PLAN_START_YYYYMMDD = @v_chk_plan_start_yyyymmdd
			AND PLAN_YYYYMMDD >= left(@v_chk_plan_start_yyyymmdd,6) + '01'
        END



        COMMIT TRANSACTION;
    END TRY
    
    ------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	ROLLBACK TRANSACTION LGTM_PCY_INV_CREATE;
	------------------------------------------------------------------------
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	------------------------------------------------------------------------  
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	
	------------------------------------------------------------------------
    END CATCH
	------------------------------------------------------------------------

	------------------------------------------------------------------------
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------
  END;
