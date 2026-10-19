
/*===================================================================================================
 * Program ID   : PR_DM_CHECK_JOB_ERROR_SMS_SEND
 * Description  : DM 배치작업 오류 발생 SMS 발송
 * Program History
 *===================================================================================================
 *   Date       In Charge	Description
 *===================================================================================================
 * 2025.06.04	JSSBAE		[E20250529-001289]_DM 장애 대응 개선을 위한 시스템 개선
 *===================================================================================================
 	● 모니터링 대상 List
	-------------------------------------------------  -------------------------------------------------	--------------------------------------------------------------------------
	BATCH JOB NAME										사유													전송기준
	-------------------------------------------------  -------------------------------------------------	--------------------------------------------------------------------------
	JOB.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_81_2		MKT FCST CUTOFF 정상 작동	(81, 81_ST, 81_HM)			해당 JOB이 오류가 발생하면 문자발송
	JOB.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_81_UC		MKT FCST CUTOFF 정상 작동	(81_UC)						해당 JOB이 오류가 발생하면 문자발송
	JOB.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_TOTAL		MKT FCST CUTOFF 정상 작동	(82, 40)					해당 JOB이 오류가 발생하면 문자발송
	JOB.PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_40			SALES PLAN CUTOFF 정상 작동 40						해당 JOB이 오류가 발생하면 문자발송
	JOB.PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_81			SALES PLAN CUTOFF 정상 작동 81						해당 JOB이 오류가 발생하면 문자발송
	JOB.PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_81_HD		SALES PLAN CUTOFF 정상 작동 81_HD						해당 JOB이 오류가 발생하면 문자발송
	JOB.PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_81_HG		SALES PLAN CUTOFF 정상 작동 81_HG						해당 JOB이 오류가 발생하면 문자발송
	JOB.PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_81_HM		SALES PLAN CUTOFF 정상 작동 81_HM						해당 JOB이 오류가 발생하면 문자발송
	JOB.PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_81_ST		SALES PLAN CUTOFF 정상 작동 81_ST						해당 JOB이 오류가 발생하면 문자발송
	JOB.PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_81_UC		SALES PLAN CUTOFF 정상 작동 81_UC						해당 JOB이 오류가 발생하면 문자발송
	JOB.PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_82			SALES PLAN CUTOFF 정상 작동 82						해당 JOB이 오류가 발생하면 문자발송
	JOB.PR_DM_DNM_SALES_RESULT							Sales Result 반영(to DM)								해당 JOB이 오류가 발생하면 문자발송
	JOB_RFC.매출 실적 정보								ERP Sales Result 수신								해당 JOB이 오류가 발생하면 문자발송
	JOB_RFC.판매법인(G260) 재고							판매법인(G260) 재고									해당 JOB이 오류가 발생하면 문자발송
	JOB_RFC.DM_VMI_재고 입출고 실적						VMI 재고 입출고 실적									해당 JOB이 오류가 발생하면 문자발송
	JOB.PR_DM_PLN_XIF_ERP_MDF_TO_DM_MDF_RESULT			전지사업본부 MDF(판매장려금) 실적 정보					해당 JOB이 오류가 발생하면 문자발송
	-------------------------------------------------  -------------------------------------------------	--------------------------------------------------------------------------
 	● 문자 발송 대상 LIST
	DM : 카테고리 103
*/

CREATE PROCEDURE [dbo].[PR_DM_CHECK_JOB_ERROR_SMS_SEND]
	@p_category_id				int
  ,	@p_check_tm                 int
  , @p_system_name				varchar(10)
AS

BEGIN 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;	
	------------------------------------------------------------------------------------------------------- 
	-- 대상건 Fetch 변수
	------------------------------------------------------------------------------------------------------- 
	DECLARE @v_job_name				NVARCHAR(150);
	DECLARE @v_job_description		NVARCHAR(MAX);
	DECLARE @v_code					NVARCHAR(150);
	DECLARE @v_text					NVARCHAR(MAX);
	DECLARE @n_def_check_tm			INTEGER = 6;		-- check time (min) :: 현시간 이전 시간 --[E20250529-001289]_시간변경:6분으로
	DECLARE @n_check_tm				INTEGER;
	
	------------------------------------------------------------------------------------------------------- 
	-- LOG 용 변수 설정
	------------------------------------------------------------------------------------------------------- 
    DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_CHECK_JOB_ERROR_SMS_SEND';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;
	
	
	------------------------------------------------------------------------------------------------------- 
	-- 시간이 들어오지 않은 경우에는 기 선언한 시간으로 변경해준다.
	------------------------------------------------------------------------------------------------------- 
	BEGIN
		IF (@p_check_tm > 0)
			SET @n_check_tm = @p_check_tm
		ELSE
			SET @n_check_tm = @n_def_check_tm
	END
	------------------------------------------------------------------------------------------------------- 
	-- 시작 LOG
	------------------------------------------------------------------------------------------------------- 
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
    BEGIN TRY
		BEGIN
			------------------------------------------------------------------------------------------------------- 
			-- 임시TB 삭제하고 시작한다.
			------------------------------------------------------------------------------------------------------- 
			IF OBJECT_ID (N'tempdb..#TEMP_CHECKED', N'U') IS NOT NULL 
				DROP TABLE #TEMP_CHECKED		
			IF OBJECT_ID (N'tempdb..#TMP_DM_CHECK_BEFOREHAND', N'U') IS NOT NULL 
				DROP TABLE #TMP_DM_CHECK_BEFOREHAND

			------------------------------------------------------------------------------------------------------- 
			--모니터링할 대상의 배치에 대해서를 추출한다. (룩업: DM_CHECKED_BEFOREHAND)
			------------------------------------------------------------------------------------------------------- 			
			SELECT SEGMENT2 AS JOB_NAMES
			INTO #TEMP_CHECKED
			FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK)
			WHERE LOOKUP_TYPE = 'DM_CHECKED_BEFOREHAND'
			AND VALID_YN = 'Y'
			AND SEGMENT1 = CASE WHEN @p_system_name = '' OR @p_system_name = 'ALL' THEN SEGMENT1 ELSE @p_system_name END
			GROUP BY SEGMENT2
			
			------------------------------------------------------------------------------------------------------- 
			--룩업에 등록된 JOB이 실행되고 있는 이력을 확인하여, 대상만 TEMP 테이블에 담는다.
			------------------------------------------------------------------------------------------------------- 
			SELECT T.PROGRAM_NAME AS JOB_NAME, T.PROGRAM_NAME AS SMS_MESSAGE
			INTO #TMP_DM_CHECK_BEFOREHAND
			FROM (	SELECT JOB.NAME AS PROGRAM_NAME, 'ERROR' AS LOG_TYPE
							, msdb.dbo.agent_datetime(run_date, run_time) as EVENT_DATE
					FROM  [msdb].[dbo].[sysjobhistory] HS
					INNER JOIN [msdb].[dbo].[sysjobs] JOB
							ON HS.job_id = JOB.job_id
					INNER JOIN #TEMP_CHECKED LOOK
							ON LOOK.JOB_NAMES = JOB.NAME
					WHERE	HS.run_status = 0
					AND     HS.step_id > 0 ) T
			WHERE 1=1
			AND DATEDIFF ( mi , T.EVENT_DATE , getdate() ) < @n_check_tm
			AND T.LOG_TYPE = 'ERROR'
			GROUP BY PROGRAM_NAME, LOG_TYPE
			;	

			DECLARE CUR_DM_CHECK_LOG SCROLL CURSOR FOR
			SELECT JOB_NAME, SMS_MESSAGE FROM #TMP_DM_CHECK_BEFOREHAND

			BEGIN
				OPEN CUR_DM_CHECK_LOG;
				FETCH NEXT FROM CUR_DM_CHECK_LOG INTO @v_job_name, @v_job_description;			
			END
				
			WHILE @@FETCH_STATUS = 0
			BEGIN
				BEGIN
					SET @v_text = ''
					SET @v_code = @p_category_id
					SET @v_text = @v_job_description

					EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text
				END
			
				FETCH NEXT FROM CUR_DM_CHECK_LOG INTO @v_job_name, @v_job_description
			END
				
			CLOSE CUR_DM_CHECK_LOG;  
			DEALLOCATE CUR_DM_CHECK_LOG;

		END
    END TRY
	------------------------------------------------------------------------------------------------------------------------------
    BEGIN CATCH	
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE())
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;
	------------------------------------------------------------------------------------------------------------------------------
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
END
	