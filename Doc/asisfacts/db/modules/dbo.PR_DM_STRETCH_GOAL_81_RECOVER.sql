---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
 * Program ID   : PR_DM_STRETCH_GOAL_81_RECOVER
 * Description  : 자동차사업부(81) 시뮬레이션 - 2022년 이후 데이터 원복 ( MF)
 * Program History
 *============================================================================================================
 *   Date       In Charge              Description
 *============================================================================================================
*  2022-12-26	CHANO0612		스크립트 추가

** -----------------------------------------------------------------------------------------------------------
*/

-- EXEC PR_DM_STRETCH_GOAL_81_RECOVER 'MF_W_20230103_V001'

CREATE PROCEDURE [dbo].[PR_DM_STRETCH_GOAL_81_RECOVER]
	@V_MF_VERSION_NO NVARCHAR(50)
	,@V_DIVISION_ID NVARCHAR(10)
AS
BEGIN 
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET XACT_ABORT ON;

	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_STRETCH_GOAL_81_RECOVER';
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
		
		DECLARE @V_RESTRICT_START_YYYYMMDD NCHAR(8)
				, @V_RESTRICT_START_YYYYMM NCHAR(6)
				, @V_SP_VERSION_NO			NVARCHAR(50)

        SET @V_RESTRICT_START_YYYYMMDD = '20230102'

		--SELECT @V_RESTRICT_START_YYYYMMDD = ATTRIBUTE1 
		--FROM SCM_ADM_LOOKUP_MASTER_DETAIL
		--WHERE LOOKUP_TYPE = 'DM_STRETCH_GOAL_START_DATE'
		--	AND SEGMENT1 = '81'
		--	AND VALID_YN = 'Y'
			
		IF ISDATE(@V_RESTRICT_START_YYYYMMDD) < 1
		BEGIN
			RAISERROR( N'입력제한 일자가 설정되지 않았습니다.', 16, 1) 
		END


		DELETE FROM DM_PLN_MKT_FCST WHERE DIVISION_ID = @V_DIVISION_ID AND YYYYMMDD >= @V_RESTRICT_START_YYYYMMDD

		INSERT INTO DM_PLN_MKT_FCST
			 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
			 , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
			 , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
			 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			  )
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
			 , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
			 , A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
			 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
			 , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
		FROM DM_PLN_MKT_FCST_C A
		WHERE A.DIVISION_ID = @V_DIVISION_ID
			AND A.YYYYMMDD >= @V_RESTRICT_START_YYYYMMDD
			AND A.VERSION_NO = @V_MF_VERSION_NO
			
		SELECT YYYYMMDD, MEASURE, COUNT(*) AS MF_CURRENT_CNT, SUM(QTY) AS MF_CURRENT_AMT
		FROM DM_PLN_MKT_FCST (NOLOCK)
		WHERE DIVISION_ID = @V_DIVISION_ID
			AND YYYYMMDD >= @V_RESTRICT_START_YYYYMMDD
			AND QTY <> 0
		GROUP BY YYYYMMDD, MEASURE
		ORDER BY 1, 2

		
		SELECT YYYYMMDD, MEASURE, COUNT(*) AS MF_BACKUP_CNT, SUM(QTY) AS MF_BACKUP_AMT
		FROM DM_PLN_MKT_FCST_C (NOLOCK)
		WHERE VERSION_NO = @V_MF_VERSION_NO
			AND DIVISION_ID = @V_DIVISION_ID
			AND YYYYMMDD >= @V_RESTRICT_START_YYYYMMDD
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




