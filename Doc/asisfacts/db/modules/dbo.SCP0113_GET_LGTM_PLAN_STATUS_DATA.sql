


/*
 * Program ID   : [SCP0113_GET_LGTM_PLAN_STATUS_DATA]
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge			Description
 *===================================================================================================
 * 2025/02/07   OIJ				Create new procedure
 */

CREATE PROCEDURE [dbo].[SCP0113_GET_LGTM_PLAN_STATUS_DATA] 
	@p_plan_date			NVARCHAR(8),
	@p_division_id			NVARCHAR(500)
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	
	------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0113_GET_LGTM_PLAN_STATUS_DATA';
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
	
	SELECT @p_plan_date AS PLAN_DATE, DIVISION_ID, P_SORT, PLAN_TP,  FERT, SPRD, GODS, RMTL
	FROM (
		SELECT S.DIVISION_ID, LEFT(S.PLAN_TP_CD, 4) AS PLAN_TYPE 
		, CASE WHEN RIGHT(PLAN_TP_CD, 4) = 'INIT' THEN 'INIT' ELSE 'FINAL' END PLAN_TP
		, CASE WHEN RIGHT(PLAN_TP_CD, 4) = 'INIT' THEN '1' ELSE '2' END P_SORT 
		, END_DATE
		FROM (
			SELECT PLAN_TP_CD, A.ORIGIN_DIVISION_ID AS DIVISION_ID, MAX(CREATION_DATE) AS END_DATE
			FROM   SCM_LGTM_INV_PSI_SUMMARY A WITH(NOLOCK)
			WHERE  A.PLAN_START_YYYYMMDD = @p_plan_date
			AND	   ( ISNULL(@p_division_id, '') = '' OR A.ORIGIN_DIVISION_ID	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
			GROUP BY PLAN_TP_CD, A.ORIGIN_DIVISION_ID
			UNION ALL
			SELECT PLAN_TP_CD, A.DIVISION_ID, MAX(CREATION_DATE) AS END_DATE
			FROM   SCM_LGTM_INV_PSI_SUMMARY_SPRD A WITH(NOLOCK)
			WHERE  A.PLAN_START_YYYYMMDD = @p_plan_date
			AND	   ( ISNULL(@p_division_id, '') = '' OR A.DIVISION_ID	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
			GROUP BY PLAN_TP_CD, A.DIVISION_ID
			UNION ALL
			SELECT PLAN_TP_CD, A.DIVISION_ID, MAX(CREATION_DATE) AS END_DATE
			FROM   SCM_LGTM_INV_PSI_SUMMARY_GODS A WITH(NOLOCK)
			WHERE  A.PLAN_START_YYYYMMDD = @p_plan_date
			AND	   ( ISNULL(@p_division_id, '') = '' OR A.DIVISION_ID	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
			GROUP BY PLAN_TP_CD, A.DIVISION_ID
			UNION ALL
			SELECT PLAN_TP_CD, A.DIVISION_ID, MAX(CREATION_DATE) AS END_DATE
			FROM   SCM_LGTM_INV_PSI_SUMMARY_RMTL A WITH(NOLOCK)
			WHERE  A.PLAN_START_YYYYMMDD = @p_plan_date
			AND	   ( ISNULL(@p_division_id, '') = '' OR A.DIVISION_ID	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
			GROUP BY PLAN_TP_CD, A.DIVISION_ID
		) S
	)AS INFO
	PIVOT (
		MIN(END_DATE) FOR PLAN_TYPE IN ([FERT], [SPRD], [GODS],[RMTL])
		) AS PIVOT_RESULT
	ORDER BY 1, 2
	;
	
	------------------------------------------------------------------------
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @n_log_count   = @@ROWCOUNT;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------

END;
