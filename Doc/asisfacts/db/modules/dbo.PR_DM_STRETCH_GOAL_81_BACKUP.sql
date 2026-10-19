---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
 * Program ID   : PR_DM_STRETCH_GOAL_81_BACKUP
 * Description  : 자동차사업부 시뮬레이션 백업 - 2022년 이후 데이터 백업 (MF)
 * Program History
 *============================================================================================================
 *   Date       In Charge              Description
 *============================================================================================================
*  2022-12-26	CHANO0612		스크립트 추가


** -----------------------------------------------------------------------------------------------------------
*/

-- EXEC PR_DM_STRETCH_GOAL_81_BACKUP '81'

CREATE PROCEDURE [dbo].[PR_DM_STRETCH_GOAL_81_BACKUP]
	@p_division_id NVARCHAR(10)
AS
BEGIN 
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET XACT_ABORT ON;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_STRETCH_GOAL_81_BACKUP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE	@v_OK_description		NVARCHAR(1200);	-- cut off Generated Number	
	   	
	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = N'@p_division_id : 81/81_UC, 자동차사업부 STRETCH GOAL'
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	BEGIN TRY
		DECLARE @V_MF_VERSION	NVARCHAR(100);
		--DECLARE @V_SP_VERSION	NVARCHAR(100);
		DECLARE @V_RESTRICT_START_YYYYMMDD NCHAR(8)

		SET @V_RESTRICT_START_YYYYMMDD = '20230101'

		--SELECT @V_RESTRICT_START_YYYYMMDD = ATTRIBUTE1 
		--FROM SCM_ADM_LOOKUP_MASTER_DETAIL
		--WHERE LOOKUP_TYPE = 'DM_STRETCH_GOAL_START_DATE'
		--	AND SEGMENT1 = '81'
		--	AND VALID_YN = 'Y'
			
		IF ISDATE(@V_RESTRICT_START_YYYYMMDD) < 1
		BEGIN
			RAISERROR( N'입력제한 일자가 설정되지 않았습니다.', 16, 1) 
		END


	    -- Cutoff Version 생성
		EXEC	[dbo].[PR_DM_PLN_VERSION_CREATE]	--@return_value = [dbo].[PR_DM_PLN_VERSION_CREATE]
		 @p_division_id
		, N'STRETCH GOAL'
		, 'MF_W' -- @c_ver_type
		, 'SYSTEM-PLAN' --@v_created_by
		,@V_MF_VERSION  OUTPUT
		,@v_OK_description OUTPUT					
		;


		INSERT INTO DM_PLN_MKT_FCST_C
			 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
			 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
			 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY
			 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
			 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
			 , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
		SELECT DIVISION_ID, @V_MF_VERSION AS VERSION_NO, 'MF_W' AS CUTOFF_TYPE, CONVERT(CHAR(8), GETDATE(), 112) AS CUTOFF_YYYYMMDD, PROJECT_CODE
			 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
			 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, 'SYSTEM-PLAN' AS CREATED_BY
			 , GETDATE() AS CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
			 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
			 , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
		FROM   DM_PLN_MKT_FCST
		WHERE YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			AND DIVISION_ID = @p_division_id


		SELECT YYYYMMDD, MEASURE, COUNT(*) AS MF_CURRENT_CNT, SUM(QTY) AS MF_CURRENT_AMT
		FROM DM_PLN_MKT_FCST (NOLOCK)
		WHERE DIVISION_ID = @p_division_id
		AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		AND QTY <> 0
		GROUP BY YYYYMMDD, MEASURE
		ORDER BY 1, 2

		SELECT YYYYMMDD, MEASURE, COUNT(*) AS MF_BACKUP_CNT, SUM(QTY) AS MF_BACKUP_AMT
		FROM DM_PLN_MKT_FCST_C (NOLOCK)
		WHERE VERSION_NO = @V_MF_VERSION
		AND DIVISION_ID = @p_division_id
		AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		AND QTY <> 0
		GROUP BY YYYYMMDD, MEASURE
		ORDER BY 1, 2




	END TRY
	BEGIN CATCH
	
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END CATCH

	    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = N'@p_division_id : 81/81_UC, 자동차사업부 STRETCH GOAL'
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


END




