/*
 * Program ID   : [SCP0113_GET_PSI_DATA]
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge			Description
 *===================================================================================================
 * 2024/12/03   Quoc Tan (Tanvq1)	Create new procedure to get PSI Data for SCP0113		 
 */

CREATE PROCEDURE [dbo].[SCP0113_GET_PSI_DATA] 

	-- Add the parameters for the stored procedure here
	@p_plan_date			NVARCHAR(8),
	@p_plan_yyyymm			NVARCHAR(6)

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	
	------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0113_GET_PSI_DATA';
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
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------  
	

	--SELECT PLAN_TP_CD
	--	  ,PLAN_START_YYYYMMDD
	--	  ,PLAN_START_YYYYWW
	--	  ,DATA_TP_CD
	--	  ,SRCE_TP_CD
	--	  ,DIVISION_ID
	--	  ,ORIGIN_DIVISION_ID
	--	  ,GROUP_CODE1
	--	  ,EXCEPTION_MODEL
	--	  ,EXCEPTION_DESC
	--	  ,ITEM_ID
	--	  ,ITEM_NAME
	--	  ,ORIGIN_ITEM_ID
	--	  ,ITEM_CLASS
	--	  ,CLASS_NAME
	--	  ,SRCE_YYYYMM
	--	  ,PLAN_YYYYMM
	--	  ,QTY
	--	  ,AMT
	--	  ,DEVALUATION_AGE
	--	  ,LONG_TERM_TYPE
	--FROM   SCM_LGTM_INV_PSI_SUMMARY_V WITH(NOLOCK)
	--WHERE  PLAN_START_YYYYMMDD = @p_plan_date
	--AND    PLAN_YYYYMM         >= @p_plan_yyyymm
	--AND    PLAN_TP_CD          = N'완제품_INIT'  
	--ORDER BY PLAN_TP_CD, DIVISION_ID, ORIGIN_DIVISION_ID, ITEM_ID, PLAN_YYYYMM, CASE WHEN DATA_TP_CD = N'기초재고' THEN 1
	--																				WHEN DATA_TP_CD = N'생산계획' THEN 2
	--																				WHEN DATA_TP_CD = N'공급계획' THEN 3
	--																				WHEN DATA_TP_CD = N'기말재고' THEN 4 END  
	--SELECT PLAN_TP_CD
	--	  ,PLAN_START_YYYYMMDD
	--	  ,PLAN_START_YYYYWW
	--	  ,DATA_TP_CD
	--	  ,SRCE_TP_CD
	--	  ,DIVISION_ID
	--	  ,ORIGIN_DIVISION_ID
	--	  ,GROUP_CODE1
	--	  ,EXCEPTION_MODEL
	--	  ,EXCEPTION_DESC
	--	  ,ITEM_ID
	--	  ,ITEM_NAME
	--	  ,ORIGIN_ITEM_ID
	--	  ,ITEM_CLASS
	--	  ,CLASS_NAME
	--	  ,SRCE_YYYYMM
	--	  ,PLAN_YYYYMM
	--	  ,QTY
	--	  ,AMT
	--	  ,DEVALUATION_AGE
	--	  ,LONG_TERM_TYPE
	--FROM   SCM_LGTM_INV_PSI_SUMMARY_SPRD_V WITH(NOLOCK)
	--WHERE  PLAN_START_YYYYMMDD = @p_plan_date
	--AND    PLAN_YYYYMM >= @p_plan_yyyymm
	--AND    PLAN_TP_CD = N'반제품_INIT'
	--ORDER BY PLAN_TP_CD, DIVISION_ID, ORIGIN_DIVISION_ID, ITEM_ID, PLAN_YYYYMM, CASE WHEN DATA_TP_CD = N'기초재고' THEN 1
	--																				WHEN DATA_TP_CD = N'생산계획' THEN 2
	--																				WHEN DATA_TP_CD = N'공급계획' THEN 3
	--																				WHEN DATA_TP_CD = N'기말재고' THEN 4 END  

	--SELECT PLAN_TP_CD
	--	  ,PLAN_START_YYYYMMDD
	--	  ,PLAN_START_YYYYWW
	--	  ,DATA_TP_CD
	--	  ,SRCE_TP_CD
	--	  ,DIVISION_ID
	--	  ,ORIGIN_DIVISION_ID
	--	  ,GROUP_CODE1
	--	  ,EXCEPTION_MODEL
	--	  ,EXCEPTION_DESC
	--	  ,ITEM_ID
	--	  ,ITEM_NAME
	--	  ,ORIGIN_ITEM_ID
	--	  ,ITEM_CLASS
	--	  ,CLASS_NAME
	--	  ,SRCE_YYYYMM
	--	  ,PLAN_YYYYMM
	--	  ,QTY
	--	  ,AMT
	--	  ,DEVALUATION_AGE
	--	  ,LONG_TERM_TYPE
	--FROM   SCM_LGTM_INV_PSI_SUMMARY_RMTL_V WITH(NOLOCK)
	--WHERE  PLAN_START_YYYYMMDD = @p_plan_date
	--AND    PLAN_YYYYMM >= @p_plan_yyyymm
	--AND    PLAN_TP_CD = N'원재료_INIT'
	--ORDER BY PLAN_TP_CD, DIVISION_ID, ORIGIN_DIVISION_ID, ITEM_ID, PLAN_YYYYMM, CASE WHEN DATA_TP_CD = N'기초재고' THEN 1
	--																				WHEN DATA_TP_CD = N'생산계획' THEN 2
	--																				WHEN DATA_TP_CD = N'공급계획' THEN 3
	--																				WHEN DATA_TP_CD = N'기말재고' THEN 4 END  

	--SELECT PLAN_TP_CD
	--	  ,PLAN_START_YYYYMMDD
	--	  ,PLAN_START_YYYYWW
	--	  ,DATA_TP_CD
	--	  ,SRCE_TP_CD
	--	  ,DIVISION_ID
	--	  ,ORIGIN_DIVISION_ID
	--	  ,GROUP_CODE1
	--	  ,EXCEPTION_MODEL
	--	  ,EXCEPTION_DESC
	--	  ,ITEM_ID
	--	  ,ITEM_NAME
	--	  ,ORIGIN_ITEM_ID
	--	  ,ITEM_CLASS
	--	  ,CLASS_NAME
	--	  ,SRCE_YYYYMM
	--	  ,PLAN_YYYYMM
	--	  ,QTY
	--	  ,AMT
	--	  ,DEVALUATION_AGE
	--	  ,LONG_TERM_TYPE
	--FROM   SCM_LGTM_INV_PSI_SUMMARY_GODS_V WITH(NOLOCK)
	--WHERE  PLAN_START_YYYYMMDD = @p_plan_date
	--AND    PLAN_YYYYMM >= @p_plan_yyyymm
	--AND    PLAN_TP_CD = N'상품_INIT'
	--ORDER BY PLAN_TP_CD, DIVISION_ID, ORIGIN_DIVISION_ID, ITEM_ID, PLAN_YYYYMM, CASE WHEN DATA_TP_CD = N'기초재고' THEN 1
	--																				WHEN DATA_TP_CD = N'생산계획' THEN 2
	--																				WHEN DATA_TP_CD = N'공급계획' THEN 3
	--																				WHEN DATA_TP_CD = N'기말재고' THEN 4 END  

	SELECT * FROM (
	SELECT PLAN_TP_CD
		  ,PLAN_START_YYYYMMDD
		  ,PLAN_START_YYYYWW
		  ,DATA_TP_CD
		  ,SRCE_TP_CD
		  ,DIVISION_ID
		  ,ORIGIN_DIVISION_ID
		  ,GROUP_CODE1
		  ,EXCEPTION_MODEL
		  ,EXCEPTION_DESC
		  ,ITEM_ID
		  ,ITEM_NAME
		  ,ORIGIN_ITEM_ID
		  ,ITEM_CLASS
		  ,CLASS_NAME
		  ,SRCE_YYYYMM
		  ,PLAN_YYYYMM
		  ,QTY
		  ,AMT
		  ,DEVALUATION_AGE
		  ,LONG_TERM_TYPE
	FROM   SCM_LGTM_INV_PSI_SUMMARY_V WITH(NOLOCK)
	WHERE  PLAN_START_YYYYMMDD = @p_plan_date
	AND    PLAN_YYYYMM         = @p_plan_yyyymm
	AND    PLAN_TP_CD          = N'완제품_INIT'  
	-----------------------------------------------------------------------
	UNION ALL
	-----------------------------------------------------------------------
	SELECT PLAN_TP_CD
		  ,PLAN_START_YYYYMMDD
		  ,PLAN_START_YYYYWW
		  ,DATA_TP_CD
		  ,SRCE_TP_CD
		  ,DIVISION_ID
		  ,ORIGIN_DIVISION_ID
		  ,GROUP_CODE1
		  ,EXCEPTION_MODEL
		  ,EXCEPTION_DESC
		  ,ITEM_ID
		  ,ITEM_NAME
		  ,ORIGIN_ITEM_ID
		  ,ITEM_CLASS
		  ,CLASS_NAME
		  ,SRCE_YYYYMM
		  ,PLAN_YYYYMM
		  ,QTY
		  ,AMT
		  ,DEVALUATION_AGE
		  ,LONG_TERM_TYPE
	FROM   SCM_LGTM_INV_PSI_SUMMARY_SPRD_V WITH(NOLOCK)
	WHERE  PLAN_START_YYYYMMDD = @p_plan_date
	AND    PLAN_YYYYMM = @p_plan_yyyymm
	AND    PLAN_TP_CD = N'반제품_INIT'
	-----------------------------------------------------------------------
	UNION ALL
	-----------------------------------------------------------------------
	SELECT PLAN_TP_CD
		  ,PLAN_START_YYYYMMDD
		  ,PLAN_START_YYYYWW
		  ,DATA_TP_CD
		  ,SRCE_TP_CD
		  ,DIVISION_ID
		  ,ORIGIN_DIVISION_ID
		  ,GROUP_CODE1
		  ,EXCEPTION_MODEL
		  ,EXCEPTION_DESC
		  ,ITEM_ID
		  ,ITEM_NAME
		  ,ORIGIN_ITEM_ID
		  ,ITEM_CLASS
		  ,CLASS_NAME
		  ,SRCE_YYYYMM
		  ,PLAN_YYYYMM
		  ,QTY
		  ,AMT
		  ,DEVALUATION_AGE
		  ,LONG_TERM_TYPE
	FROM   SCM_LGTM_INV_PSI_SUMMARY_RMTL_V WITH(NOLOCK)
	WHERE  PLAN_START_YYYYMMDD = @p_plan_date
	AND    PLAN_YYYYMM = @p_plan_yyyymm
	AND    PLAN_TP_CD = N'원재료_INIT'
	-----------------------------------------------------------------------
    UNION ALL
   -----------------------------------------------------------------------
	SELECT PLAN_TP_CD
		  ,PLAN_START_YYYYMMDD
		  ,PLAN_START_YYYYWW
		  ,DATA_TP_CD
		  ,SRCE_TP_CD
		  ,DIVISION_ID
		  ,ORIGIN_DIVISION_ID
		  ,GROUP_CODE1
		  ,EXCEPTION_MODEL
		  ,EXCEPTION_DESC
		  ,ITEM_ID
		  ,ITEM_NAME
		  ,ORIGIN_ITEM_ID
		  ,ITEM_CLASS
		  ,CLASS_NAME
		  ,SRCE_YYYYMM
		  ,PLAN_YYYYMM
		  ,QTY
		  ,AMT
		  ,DEVALUATION_AGE
		  ,LONG_TERM_TYPE
	FROM   SCM_LGTM_INV_PSI_SUMMARY_GODS_V WITH(NOLOCK)
	WHERE  PLAN_START_YYYYMMDD = @p_plan_date
	AND    PLAN_YYYYMM = @p_plan_yyyymm
	AND    PLAN_TP_CD = N'상품_INIT')  AA
	ORDER BY PLAN_TP_CD, DIVISION_ID, ORIGIN_DIVISION_ID, ITEM_ID, PLAN_YYYYMM, CASE WHEN DATA_TP_CD = N'기초재고' THEN 1
																					WHEN DATA_TP_CD = N'생산계획' THEN 2
																					WHEN DATA_TP_CD = N'공급계획' THEN 3
																					WHEN DATA_TP_CD = N'기말재고' THEN 4 END
																					
	------------------------------------------------------------------------
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @n_log_count   = @@ROWCOUNT;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------

END;





