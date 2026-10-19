





/*
 * Program ID  : [PR_DM_CUST_DEMAND_ANL_SUMMARY]
 * Description  : 고객수요증감분석 데이터 기초값 생성 및 인터페이스 전송
 * 메인테이블
   DM_CUST_DEMAND_ANL_SUMMARY
   XIF_DM_ANL_MKT_PSI_DW_S
   XIF_DM_ANL_MKT_PSI_DETAIL_DW_S
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *=================================================================================================== 
 2024.10.30    KANG.H.J       [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
 2025.02.03    KANG.H.J       [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선 - 단종예상 및 신규 데이터 기능 보완
 2025.02.11    Philsu Park    [E20250205-000991] 변동비 - ITEM단위 집계 프로시저 추가 호출.
 */
/*
 EXEC PR_DM_CUST_DEMAND_ANL_SUMMARY '81', 'N', '20241210'
 */
----------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[PR_DM_CUST_DEMAND_ANL_SUMMARY] 
	 @p_division_id			NVARCHAR(MAX)
	,@p_replan_yn			NVARCHAR(01)
	,@p_exe_yyyymmdd        NVARCHAR(8)

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET XACT_ABORT ON; 

	
    -- 여기서부터 TRANSACTION 처리
    -- BEGIN TRAN PR_DM_CUST_DEMAND_ANL_SUMMARY;

	BEGIN TRY

		-- LOG 용 변수 설정
		DECLARE @V_PROGRAM_NAME		NVARCHAR(150) = 'PR_DM_CUST_DEMAND_ANL_SUMMARY';
		DECLARE @V_LOG_TYPE			NVARCHAR(30); -- START/END/ERROR/...
		DECLARE @N_LOG_COUNT		INTEGER = 0;
		DECLARE @V_LOG_MESSAGE		NVARCHAR(1000);
		DECLARE @V_DESCRIPTION		NVARCHAR(500);
		DECLARE @D_EVENT_DATE		DATETIME;
		DECLARE @N_DELETE_COUNT		INTEGER = 0;
		DECLARE @N_INSERT_COUNT     INTEGER = 0;
		DECLARE @V_CREATED_BY		NVARCHAR(150)	= 'SYS_CUST_DEMAND_ANL_SUMMARY';

		-- 시작 LOG
		SET @V_LOG_TYPE = 'START';
		SET @V_LOG_MESSAGE = '########## START OF PROCEDURE ##########';
		SET @V_DESCRIPTION = '';
		SET @D_EVENT_DATE = SYSDATETIME();
		EXEC  PR_DM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE, @V_CREATED_BY;
 
		DECLARE @v_curr_month				NVARCHAR(06);		-- YYYYMM (당월)
		DECLARE @v_prev1_month				NVARCHAR(06);		-- YYYYMM (전월)
		DECLARE @v_prev2_month				NVARCHAR(06);		-- YYYYMM (2개월 전월)
		DECLARE @v_prev3_month				NVARCHAR(06);		-- YYYYMM (3개월 전월)
		DECLARE @v_prev4_month				NVARCHAR(06);		-- YYYYMM (4개월 전월)

		DECLARE @v_curr_month_tuesday		NVARCHAR(08);		-- 당월의 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff	
		DECLARE @v_curr_month_monday		NVARCHAR(08);		-- 당월의 첫번째 수요일이 포함된 주차의 월요일 날짜
		DECLARE @v_curr_month_firstday		NVARCHAR(08);		-- 당월의 첫번째 날
		DECLARE @v_curr_month_lastday		NVARCHAR(08);		-- 당월의 마지막 날	
		DECLARE @v_curr_mkt_fcst_version_no		NVARCHAR(MAX);	-- 당월 첫주차의 MKT_FCST Cutoff VERSION_NO	

		DECLARE @v_curr_month_summary_cnt	INTEGER = 0;		-- 당월의 DM_CUST_DEMAND_ANL_SUMMARY row_cnt(만약 0 이면, 이번달은 아직 수행안됨을 의미함) 
		DECLARE @v_exe_yyyymmdd				NVARCHAR(8);		-- 실행일자
			
			
		DECLARE @v_delimiter		NVARCHAR(1);
		
		DECLARE @v_division_id		NVARCHAR(10);
		DECLARE @v_replan_yn		NVARCHAR(01);

		
		DECLARE @v_CNT_RESULT INTEGER = 0;
		DECLARE @v_CNT_FCST INTEGER = 0;

		IF OBJECT_ID(N'tempdb..#temp_DM_PLN_MKT_FCST_RESULT', N'U') IS NOT NULL
			DROP TABLE #temp_DM_PLN_MKT_FCST_RESULT

		CREATE TABLE #temp_DM_PLN_MKT_FCST_RESULT(
			[DIVISION_ID] [nvarchar](30) NOT NULL,
			[VERSION_NO] [nvarchar](50) NOT NULL,
			[CUTOFF_TYPE] [nvarchar](10) NOT NULL,
			[CUTOFF_YYYYMMDD] [nvarchar](8) NOT NULL,
			[PROJECT_CODE] [nvarchar](50) NOT NULL,
			[SCM_SITE_ID] [nvarchar](30) NOT NULL,
			[ITEM_ID] [nvarchar](50) NOT NULL,
			[DOM_EXP] [nvarchar](3) NOT NULL,
			[FCST_TYPE] [nvarchar](20) NOT NULL,
			[INCOTERMS] [nvarchar](10) NOT NULL,
			[MEASURE] [nvarchar](50) NOT NULL,
			[PLANT_SITE_ID] [nvarchar](30) NOT NULL,
			[YYYYMMDD] [nvarchar](8) NOT NULL,
			[QTY] [numeric](20, 10) NOT NULL,
		)

		IF OBJECT_ID(N'tempdb..#temp_DM_PLN_MKT_FCST', N'U') IS NOT NULL
			DROP TABLE #temp_DM_PLN_MKT_FCST

		CREATE TABLE #temp_DM_PLN_MKT_FCST(
			[DIVISION_ID] [nvarchar](30) NOT NULL,
			[VERSION_NO] [nvarchar](50) NOT NULL,
			[CUTOFF_TYPE] [nvarchar](10) NOT NULL,
			[CUTOFF_YYYYMMDD] [nvarchar](8) NOT NULL,
			[PROJECT_CODE] [nvarchar](50) NOT NULL,
			[SCM_SITE_ID] [nvarchar](30) NOT NULL,
			[ITEM_ID] [nvarchar](50) NOT NULL,
			[DOM_EXP] [nvarchar](3) NOT NULL,
			[FCST_TYPE] [nvarchar](20) NOT NULL,
			[INCOTERMS] [nvarchar](10) NOT NULL,
			[MEASURE] [nvarchar](50) NOT NULL,
			[PLANT_SITE_ID] [nvarchar](30) NOT NULL,
			[YYYYMMDD] [nvarchar](8) NOT NULL,
			[QTY] [numeric](20, 10) NOT NULL,
		)

		SET @v_division_id	= @p_division_id;
		SET @v_replan_yn	= @p_replan_yn;
		IF @p_exe_yyyymmdd = '' 
		BEGIN
			SET @v_exe_yyyymmdd = convert (char(8), getdate(), 112);
		END
		ELSE
		BEGIN
			SET @v_exe_yyyymmdd = @p_exe_yyyymmdd ;
		END

-- STEP01 : 오늘이 당월의 첫주 수요일보다 작으면 RETURN
		
		-- 오늘기준의 당월 / 전월 
		SET @v_curr_month = SUBSTRING(CONVERT(VARCHAR, @v_exe_yyyymmdd, 112), 1, 6) ;
		SET @v_prev1_month =  SUBSTRING(CONVERT(VARCHAR, DATEADD (M, -1,@v_exe_yyyymmdd), 112), 1, 6);
		SET @v_prev2_month =  SUBSTRING(CONVERT(VARCHAR, DATEADD (M, -2,@v_exe_yyyymmdd), 112), 1, 6);
		SET @v_prev3_month =  SUBSTRING(CONVERT(VARCHAR, DATEADD (M, -3,@v_exe_yyyymmdd), 112), 1, 6);
		SET @v_prev4_month =  SUBSTRING(CONVERT(VARCHAR, DATEADD (M, -4,@v_exe_yyyymmdd), 112), 1, 6);

		-- 당월의 첫날 구하기
		SET @v_curr_month_firstday = SUBSTRING(CONVERT(VARCHAR, @v_exe_yyyymmdd, 112), 1, 6) + '01';
		-- 당월의 마지막날 구하기
		SELECT @v_curr_month_lastday = MAX(BASIS_YYYYMMDD) 
		FROM   [SCM_SYS_CALENDAR_M] A WITH(NOLOCK) 
		WHERE A.BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, @v_exe_yyyymmdd, 112), 1, 6) 
		-- 당월의 첫 수요일 구하기	(당월의 첫 수요일이 있는 주가 당월의 첫주로 인식함.)
		SELECT @v_curr_month_tuesday = MIN(BASIS_YYYYMMDD)
		FROM   [SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
		WHERE  DAYOFWEEK = 'WED'
		AND    A.basis_yyyymmdd >= @v_curr_month_firstday 
		AND    A.basis_yyyymmdd <= @v_curr_month_lastday 
		-- 당월의 첫 수요일이 있는 월요일 날짜
		SELECT @v_curr_month_monday = BASIS_YYYYMMDD
		FROM   [SCM_SYS_CALENDAR_M] WITH(NOLOCK)
		WHERE  ISO_YYYYWW IN	( 
									SELECT ISO_YYYYWW
									FROM   [DBO].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
									WHERE  BASIS_YYYYMMDD = @v_curr_month_tuesday
								)
		AND    DAYOFWEEK = 'MON'

		-- 당월 첫주의 MKT_FCST VERSION_NO 추출
		SELECT @v_curr_mkt_fcst_version_no = MAX (VERSION_NO)
		FROM DM_MST_VERSION
		WHERE DIVISION_ID	= @v_division_id
		AND   VERSION_TYPE	= 'MF_W'
		AND   YYYYMMDD		>= @v_curr_month_monday
		AND   YYYYMMDD		< CONVERT(VARCHAR,DATEADD(WW, 1, CONVERT (DATE, @v_curr_month_monday)), 112)


		--------------------------------------------------------------------------------------------------------
		-- 대상데이터 LOG (START)
		--------------------------------------------------------------------------------------------------------
		SET @v_log_type    = N'APPEND';  
		SET @v_log_message = N'MKT_FCST : ' + @v_division_id ;  
		SET @v_description = N'VERSION(M+0) : ' + @v_curr_mkt_fcst_version_no;
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, 0, @v_log_message, @v_description, @d_event_date;  

	
		IF (CONVERT(VARCHAR, @v_exe_yyyymmdd, 112) < @v_curr_month_tuesday) 
		BEGIN
			-- 종료 LOG
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
				,@v_log_type
				,@n_log_count
				,@v_log_message
				,@v_description
				,@d_event_date;

			RETURN;
		END

		IF (@v_curr_mkt_fcst_version_no IS NULL)
		BEGIN
			-- 종료 LOG
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
				,@v_log_type
				,@n_log_count
				,@v_log_message
				,@v_description
				,@d_event_date;

			RETURN;
		END

--STEP02 : REPLAN을 할 경우는 재수행을 위해서 당월 SUMMARY 데이터 삭제 
		IF (@v_replan_yn = 'Y') 
		BEGIN

			DELETE DM_CUST_DEMAND_ANL_SUMMARY
			WHERE DIVISION_ID = @v_division_id
			AND   PLAN_YYYYMM = @v_curr_month

		END;


--STEP03 : 당월의 DM_CUST_DEMAND_ANL_SUMMARY cnt=0이면 당월 Summary 수행 (단, 그렇지 않다면 프로시져 종료)
		SELECT @v_curr_month_summary_cnt = COUNT(*) 
		FROM DM_CUST_DEMAND_ANL_SUMMARY WITH(NOLOCK)
		WHERE DIVISION_ID = @v_division_id
		AND   PLAN_YYYYMM = @v_curr_month

		IF (@v_curr_month_summary_cnt != 0) 
		BEGIN
			-- 종료 LOG
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
				,@v_log_type
				,@n_log_count
				,@v_log_message
				,@v_description
				,@d_event_date;

			RETURN;
		END

		-- 여기서부터 TRANSACTION 처리
		BEGIN TRAN PR_DM_CUST_DEMAND_ANL_SUMMARY;

		PRINT ( N'A1--전월 FINAL 생성 ' + CONVERT(NVARCHAR(30), GETDATE(), 121))

--STEP04 : DM_CUST_DEMAND_ANL_SUMMARY.YYYYMM(전월-MKT_FCST_FNL)의 값 생성
		SELECT @v_CNT_RESULT = COUNT(*) 
		FROM DM_PLN_MKT_FCST_RESULT_C 
		WHERE DIVISION_ID = @v_division_id 
		AND VERSION_NO = @v_curr_mkt_fcst_version_no 
		AND CUTOFF_TYPE = 'MF_W'

		SELECT @v_CNT_FCST = COUNT(*) 
		FROM DM_PLN_MKT_FCST_C 
		WHERE DIVISION_ID = @v_division_id 
		AND VERSION_NO = @v_curr_mkt_fcst_version_no 
		AND CUTOFF_TYPE = 'MF_W'
		
		IF (@v_CNT_RESULT != 0)		-- DM_PLN_MKT_FCST_RESULT_C / DM_PLN_MKT_FCST_C 에 데이터가 없을 경우 KEEP에서 생성함.
		BEGIN
				INSERT INTO #temp_DM_PLN_MKT_FCST_RESULT
				(
					   DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY				)
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
				FROM DM_PLN_MKT_FCST_RESULT_C A WITH(NOLOCK)
				WHERE A.DIVISION_ID	= @v_division_id
				AND   A.VERSION_NO	= @v_curr_mkt_fcst_version_no
				AND   A.FCST_TYPE	IN ('MPS', 'Mass')
		END;

		ELSE 
		BEGIN
				INSERT INTO #temp_DM_PLN_MKT_FCST_RESULT
				(
					   DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY				)
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
				FROM DM_PLN_MKT_FCST_RESULT_C_KEEP A WITH(NOLOCK)
				WHERE A.DIVISION_ID	= @v_division_id
				AND   A.VERSION_NO	= @v_curr_mkt_fcst_version_no
				AND   A.FCST_TYPE	IN ('MPS', 'Mass')
		END;



		IF (@v_CNT_FCST != 0) 
		BEGIN
				INSERT INTO #temp_DM_PLN_MKT_FCST
				(
					   DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY				)
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
				FROM DM_PLN_MKT_FCST_C A WITH(NOLOCK)
				WHERE A.DIVISION_ID	= @v_division_id
				AND   A.VERSION_NO	= @v_curr_mkt_fcst_version_no
				AND   A.FCST_TYPE	IN ('MPS', 'Mass')
		END;

		ELSE 
		BEGIN
				INSERT INTO #temp_DM_PLN_MKT_FCST
				(
					   DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY				)
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
				FROM  DM_PLN_MKT_FCST_C_KEEP A WITH(NOLOCK)
				WHERE A.DIVISION_ID	= @v_division_id
				AND   A.VERSION_NO	= @v_curr_mkt_fcst_version_no
				AND   A.FCST_TYPE	IN ('MPS', 'Mass')
		END;

		-- 당월 CUST_FCST_QTY 및 각 월별 CUST_FCST_QTY/MKT_FCST는 동일 월의 FIRST에서 가져옴
		UPDATE A
		SET   A.CUST_FCST_QTY		= B.CUST_FCST_QTY
			, A.M1_CUST_FCST_QTY	= B.M1_CUST_FCST_QTY
			, A.M2_CUST_FCST_QTY	= B.M2_CUST_FCST_QTY
			, A.M3_CUST_FCST_QTY	= B.M3_CUST_FCST_QTY
			, A.M1_MKT_FCST_QTY		= B.M1_MKT_FCST_QTY
			, A.M2_MKT_FCST_QTY		= B.M2_MKT_FCST_QTY
			, A.M3_MKT_FCST_QTY		= B.M3_MKT_FCST_QTY
			, A.LAST_UPDATED_BY		= @V_CREATED_BY
			, A.LAST_UPDATE_DATE	= GETDATE()
		FROM DM_CUST_DEMAND_ANL_SUMMARY A WITH(NOLOCK)
		INNER JOIN DM_CUST_DEMAND_ANL_SUMMARY B WITH(NOLOCK)
		ON	  A.DIVISION_ID		= B.DIVISION_ID
		AND	  A.END_CUSTOMER	= B.END_CUSTOMER
		AND	  A.PROJECT_CODE	= B.PROJECT_CODE
		AND	  A.PLAN_YYYYMM		= B.PLAN_YYYYMM
		AND   B.MEASURE			= 'MKT_FCST_FST'
		WHERE A.DIVISION_ID = @v_division_id
		AND   A.PLAN_YYYYMM = @v_prev1_month
		AND   A.MEASURE		= 'MKT_FCST_FNL'

		-- 전월(MKT_FCST_FNL) MKT_FCST_QTY는 전월 실적에서 가져옴. 
		-- 당월 첫주 월요일이 당월일 경우 전월은 모두 실적임.
		IF ( SUBSTRING (@v_curr_month_monday,1,6) = @v_curr_month)		
		BEGIN

			UPDATE A
			SET   A.MKT_FCST_QTY		= B.SUM_QTY
				, A.LAST_UPDATED_BY		= @V_CREATED_BY
				, A.LAST_UPDATE_DATE	= GETDATE()
			FROM DM_CUST_DEMAND_ANL_SUMMARY A WITH(NOLOCK)
			INNER JOIN 
			(
				SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
					, SUBSTRING(A.YYYYMMDD, 1, 6) AS PLAN_YYYYMM
					, SUM(A.QTY) AS  SUM_QTY
				FROM #temp_DM_PLN_MKT_FCST_RESULT A WITH(NOLOCK)
				INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
				ON   A.DIVISION_ID = B.DIVISION_ID
				AND  A.SCM_SITE_ID = B.SCM_SITE_ID
				WHERE A.DIVISION_ID	= @v_division_id
				AND   A.VERSION_NO	= @v_curr_mkt_fcst_version_no
				AND	  A.MEASURE		= 'RTF_SYS_RP'	
				AND   SUBSTRING(A.YYYYMMDD, 1, 6) = @v_prev1_month
				GROUP BY  A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, SUBSTRING(A.YYYYMMDD, 1, 6) 
			) B
			ON	  A.DIVISION_ID		= B.DIVISION_ID
			AND	  A.END_CUSTOMER	= B.END_CUSTOMER
			AND	  A.PROJECT_CODE	= B.PROJECT_CODE
			AND	  A.PLAN_YYYYMM		= B.PLAN_YYYYMM
			AND	  A.MEASURE			= 'MKT_FCST_FNL'

		END;

		-- 당월 첫주 월요일이 전월일 경우 전월은 모두 (실적+계획)이 포함됨
		ELSE IF (SUBSTRING (@v_curr_month_monday,1,6) = @v_prev1_month) 
		BEGIN

			UPDATE A
			SET   A.MKT_FCST_QTY		= B.SUM_QTY
				, A.LAST_UPDATED_BY		= @V_CREATED_BY
				, A.LAST_UPDATE_DATE	= GETDATE()
			FROM DM_CUST_DEMAND_ANL_SUMMARY A WITH(NOLOCK)
			INNER JOIN 
			(
				SELECT A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE, A.PLAN_YYYYMM
					 , SUM(A.SUM_QTY) AS  SUM_QTY
				FROM 
				(
					SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
						, SUBSTRING(A.YYYYMMDD, 1, 6) AS PLAN_YYYYMM
						, SUM(A.QTY) AS  SUM_QTY
					FROM #temp_DM_PLN_MKT_FCST_RESULT A WITH(NOLOCK)
					INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
					ON   A.DIVISION_ID = B.DIVISION_ID
					AND  A.SCM_SITE_ID = B.SCM_SITE_ID
					WHERE A.DIVISION_ID	= @v_division_id
					AND   A.VERSION_NO	= @v_curr_mkt_fcst_version_no
					AND	  A.MEASURE		= 'RTF_SYS_RP'	
					AND   SUBSTRING(A.YYYYMMDD, 1, 6) = @v_prev1_month	-- '202409'
					GROUP BY  A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, SUBSTRING(A.YYYYMMDD, 1, 6) 
					UNION ALL
					SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
						, SUBSTRING(A.YYYYMMDD, 1, 6) AS PLAN_YYYYMM
						, SUM(A.QTY) AS  SUM_QTY
					FROM #temp_DM_PLN_MKT_FCST A WITH(NOLOCK)
					INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
					ON   A.DIVISION_ID = B.DIVISION_ID
					AND  A.SCM_SITE_ID = B.SCM_SITE_ID
					WHERE A.DIVISION_ID	= @v_division_id
					AND   A.VERSION_NO  = @v_curr_mkt_fcst_version_no
					AND	  A.MEASURE		= 'MKT_FCST'	
					AND   A.YYYYMMDD	>= @v_curr_month_monday			-- '20240930'
					AND   A.YYYYMMDD	< @v_curr_month_firstday		-- '20241001'
					GROUP BY  A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, SUBSTRING(A.YYYYMMDD, 1, 6) 
				) A
				GROUP BY A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE, A.PLAN_YYYYMM		
			) B
			ON	  A.DIVISION_ID		= B.DIVISION_ID
			AND	  A.END_CUSTOMER	= B.END_CUSTOMER
			AND	  A.PROJECT_CODE	= B.PROJECT_CODE
			AND	  A.PLAN_YYYYMM		= B.PLAN_YYYYMM
			AND	  A.MEASURE			= 'MKT_FCST_FNL'

		END;


        PRINT ( N'A2--당월 FIRST 생성 기준마련' + CONVERT(NVARCHAR(30), GETDATE(), 121));
--STEP05 : DM_PLN_MKT_FCST_RESULT_C (M-26 ~ M) 사이에 있는 division / end_customer / project 코드 생성 ==> #temp_Customer_Project

		IF OBJECT_ID(N'tempdb..#temp_CUSTOMER_PROJECT', N'U') IS NOT NULL
			DROP TABLE #temp_CUSTOMER_PROJECT

		-- 당월은 아래 기준으로만 생성함.
		SELECT DISTINCT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, C.PROJECT_NAME
		INTO #temp_CUSTOMER_PROJECT
		FROM DM_PLN_MKT_FCST_RESULT A WITH(NOLOCK)
		INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
		ON   A.DIVISION_ID = B.DIVISION_ID
		AND  A.SCM_SITE_ID = B.SCM_SITE_ID
		INNER JOIN SCM_MST_PROJECT C WITH(NOLOCK)
		ON   A.DIVISION_ID	= C.DIVISION_ID
		AND  A.PROJECT_CODE = C.PROJECT_CODE
		WHERE A.DIVISION_ID = @v_division_id
		AND   ISNULL(A.PROJECT_CODE, '') != ''
		AND   ISNULL(B.END_CUSTOMER, '') != '' 
		AND   MEASURE = 'RTF_SYS_RP'
		AND   YYYYMMDD >= CONVERT(VARCHAR,DATEADD(MM, -12, CONVERT (DATE, @v_exe_yyyymmdd)), 112)	-- 12개월 기준 실적이 있을 경우만
		AND   YYYYMMDD <= @v_exe_yyyymmdd
		AND   QTY != 0																				-- 실적이 있을 때만
		GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, C.PROJECT_NAME
		UNION 
		SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, C.PROJECT_NAME
		FROM DM_PLN_MKT_FCST A WITH(NOLOCK)
		INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
		ON   A.DIVISION_ID = B.DIVISION_ID
		AND  A.SCM_SITE_ID = B.SCM_SITE_ID
		INNER JOIN SCM_MST_PROJECT C WITH(NOLOCK)
		ON   A.DIVISION_ID	= C.DIVISION_ID
		AND  A.PROJECT_CODE = C.PROJECT_CODE
		WHERE A.DIVISION_ID = @v_division_id
		AND   ISNULL(A.PROJECT_CODE, '') != ''
		AND   ISNULL(B.END_CUSTOMER, '') != '' 
		AND   MEASURE = 'MKT_FCST'
		AND   YYYYMMDD >= @v_curr_month_firstday
		AND   YYYYMMDD <= @v_curr_month_lastday
		GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, C.PROJECT_NAME


        PRINT ( N'A3--당월 FIRST 생성 ' + CONVERT(NVARCHAR(30), GETDATE(), 121));

--STEP06 : DM_CUST_DEMAND_ANL_SUMMARY.YYYYMM(당월-MKT_FCST_FST)의 값 생성 

   -- 과거 데이터는 집계시점의 데이터를 가져옴.

		
		-- 당월 첫주 월요일이 당월일 경우 당월 계획은 (전주 실적+ 당월 계획) 이어야 함..
		IF ( SUBSTRING (@v_curr_month_monday,1,6) = @v_curr_month)		
		BEGIN
        PRINT ( N'A3-1--당월 FIRST 생성(1) ' + CONVERT(NVARCHAR(30), GETDATE(), 121));

			INSERT INTO DM_CUST_DEMAND_ANL_SUMMARY(
				 DIVISION_ID,END_CUSTOMER,PROJECT_CODE
				,MEASURE
				,PLAN_YYYYMM
				,PROJECT_NAME
				,CUST_FCST_QTY
				,MKT_FCST_QTY
				--,M1_CUST_FCST_QTY,M2_CUST_FCST_QTY,M3_CUST_FCST_QTY
				--,M1_MKT_FCST_QTY,M2_MKT_FCST_QTY,M3_MKT_FCST_QTY
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
			)

			SELECT A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE
				, 'MKT_FCST_FST'			AS MEASURE
				, @v_curr_month				AS PLAN_YYYYMM
				, A.PROJECT_NAME
				, ISNULL (B.SUM_QTY, 0)				AS CUST_FCST_QTY
				, ISNULL (C.SUM_QTY, 0)				AS MKT_FCST_QTY
				--, ISNULL (D.M1_CUST_FCST_QTY, 0)	AS M1_CUST_FCST_QTY
				--, ISNULL (D.M2_CUST_FCST_QTY, 0)	AS M2_CUST_FCST_QTY
				--, ISNULL (D.M3_CUST_FCST_QTY, 0)	AS M3_CUST_FCST_QTY
				--, ISNULL (D.M1_MKT_FCST_QTY, 0)		AS M1_MKT_FCST_QTY
				--, ISNULL (D.M2_MKT_FCST_QTY, 0)		AS M2_MKT_FCST_QTY
				--, ISNULL (D.M3_MKT_FCST_QTY, 0)		AS M3_MKT_FCST_QTY
				, @V_CREATED_BY						AS CREATED_BY		
				, GETDATE()							AS CREATION_DATE	 
				, @V_CREATED_BY						AS LAST_UPDATED_BY		
				, GETDATE()							AS LAST_UPDATE_DATE	 
			FROM #temp_CUSTOMER_PROJECT A WITH(NOLOCK)
			LEFT OUTER JOIN 
			(
			   -- CUST_FCST_QTY는 DM_PLN_MKT_FCST_C (CUST_FCST)에서 가져옴.
			   -- 단, 당월의 계획값이 Result에 있어도 가져옴
			   --==> 버젼은 당주 첫주차 version_no = "MF_W_20241001_V002"
			    SELECT A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE
					 , SUM(A.SUM_QTY) AS SUM_QTY
				FROM (
					/*당월의 전주 실적*/
					SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
						, SUM(A.QTY) AS  SUM_QTY
					FROM #temp_DM_PLN_MKT_FCST_RESULT A WITH(NOLOCK)
					INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
					ON   A.DIVISION_ID = B.DIVISION_ID
					AND  A.SCM_SITE_ID = B.SCM_SITE_ID
					WHERE A.DIVISION_ID	= @v_division_id
					AND   A.VERSION_NO	= @v_curr_mkt_fcst_version_no
--					AND   A.MEASURE IN ('Customer FCST','CUST_FCST_EDI')	
					AND   A.MEASURE IN ('CUST_FCST')						-- CUST_FCST = Customer FCST + CUST_FCST_EDI 임
					AND   A.YYYYMMDD	>= @v_curr_month_firstday
					AND   A.YYYYMMDD	<  @v_curr_month_monday
					GROUP BY  A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
					UNION ALL
					/*당월의 당주 이후 계획*/
					SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
						 , SUM(QTY) AS SUM_QTY
					FROM #temp_DM_PLN_MKT_FCST A WITH(NOLOCK)
					INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
					ON	A.DIVISION_ID	= B.DIVISION_ID
					AND A.SCM_SITE_ID	= B.SCM_SITE_ID
					WHERE A.DIVISION_ID	= @v_division_id
					AND   A.VERSION_NO	= @v_curr_mkt_fcst_version_no
					AND   A.CUTOFF_TYPE	= 'MF_W'
					--AND   A.MEASURE IN ('Customer FCST','CUST_FCST_EDI')
					AND   A.MEASURE IN ('CUST_FCST')						-- CUST_FCST = Customer FCST + CUST_FCST_EDI 임
					AND   A.YYYYMMDD	>= @v_curr_month_monday
					AND   A.YYYYMMDD	<= @v_curr_month_lastday
					GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE				
				) A
				GROUP BY  A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE
			) B
			ON	A.DIVISION_ID	= B.DIVISION_ID
			AND A.END_CUSTOMER	= B.END_CUSTOMER
			AND A.PROJECT_CODE	= B.PROJECT_CODE
			LEFT OUTER JOIN 
			(
			   -- MTK_FCST는 당월 계획 (MKT_FCST_C.MKT_FCST mesaure.version_no = "MF_W_20241001_V002" )에서 가져옴. 
			   -- (단, 당월 첫주가 전주라면  DM_PLN_MKT_FCST_RESULT_C(RTF_SYS_RP)에서 전주 1일 실적부터 합산함)
				SELECT A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE
					 , SUM(SUM_QTY) AS SUM_QTY
				FROM (
					/*당월의 전주 실적*/
					SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
						 , SUM(QTY) AS SUM_QTY
					FROM #temp_DM_PLN_MKT_FCST_RESULT A WITH(NOLOCK)
					INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
					ON	A.DIVISION_ID	= B.DIVISION_ID
					AND A.SCM_SITE_ID	= B.SCM_SITE_ID
					WHERE A.DIVISION_ID	= @v_division_id
					AND   A.VERSION_NO	= @v_curr_mkt_fcst_version_no
					AND   A.MEASURE IN ('RTF_SYS_RP')
					AND   A.YYYYMMDD	>= @v_curr_month_firstday		--'20241101'
					AND   A.YYYYMMDD	<  @v_curr_month_monday			--'20241104'
					GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE		
					UNION ALL
					/*당월의 당주 이후 계획*/
					SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
						 , SUM(QTY) AS SUM_QTY
					FROM #temp_DM_PLN_MKT_FCST A WITH(NOLOCK)
					INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
					ON	A.DIVISION_ID	= B.DIVISION_ID
					AND A.SCM_SITE_ID	= B.SCM_SITE_ID
					WHERE A.DIVISION_ID	= @v_division_id
					AND   A.VERSION_NO	= @v_curr_mkt_fcst_version_no
					AND   A.CUTOFF_TYPE	= 'MF_W'
					AND   A.MEASURE IN ('MKT_FCST')
					AND   A.YYYYMMDD	>= @v_curr_month_monday			--'20241104'
					AND   A.YYYYMMDD	<= @v_curr_month_lastday		--'20241130'
					GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE	
				) A
				GROUP BY  A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE
			) C
			ON	A.DIVISION_ID	= C.DIVISION_ID
			AND A.END_CUSTOMER	= C.END_CUSTOMER
			AND A.PROJECT_CODE	= C.PROJECT_CODE
			/* 아래 로직은 PR_DM_CUST_DEMAND_ANL_SUMMARY_SUB 에서 생성함 */
			--LEFT OUTER JOIN 
			--(
			--	-- M1_CUST_FCST_QTY / M2_CUST_FCST_QTY / M3_CUST_FCST_QTY / M1_MKT_FCST_QTY / M2_MKT_FCST_QTY / M3_MKT_FCST_QTY는  DM_CUST_DEMAND_ANL_SUMMARY (Final) 에서 가져옴.
			--	SELECT DIVISION_ID, END_CUSTOMER, PROJECT_CODE
			--		 , CUST_FCST_QTY		AS M1_CUST_FCST_QTY		-- 전월의 현재는 당월은 M-1임
			--		 , M1_CUST_FCST_QTY		AS M2_CUST_FCST_QTY		-- 전월의 M-1는 당월은 M-2임
			--		 , M2_CUST_FCST_QTY		AS M3_CUST_FCST_QTY		-- 전월의 M-2는 당월은 M-3임
			--		 , MKT_FCST_QTY			AS M1_MKT_FCST_QTY
			--		 , M1_MKT_FCST_QTY		AS M2_MKT_FCST_QTY
			--		 , M2_MKT_FCST_QTY		AS M3_MKT_FCST_QTY
			--	FROM DM_CUST_DEMAND_ANL_SUMMARY A WITH(NOLOCK)
			--	WHERE A.DIVISION_ID	= @v_division_id
			--	AND   A.MEASURE		= 'MKT_FCST_FNL'
			--	AND   A.PLAN_YYYYMM	= @v_prev1_month
			--) D
			--ON	A.DIVISION_ID	= D.DIVISION_ID
			--AND A.END_CUSTOMER	= D.END_CUSTOMER
			--AND A.PROJECT_CODE	= D.PROJECT_CODE
			;

		END
		
		-- 당월 첫주 월요일이 전월일 경우 당월은 모두 계획임.
		ELSE IF (SUBSTRING (@v_curr_month_monday,1,6) = @v_prev1_month) 
		BEGIN
        PRINT ( N'A3-2--당월 FIRST 생성(2) ' + CONVERT(NVARCHAR(30), GETDATE(), 121));

			INSERT INTO DM_CUST_DEMAND_ANL_SUMMARY(
				 DIVISION_ID,END_CUSTOMER,PROJECT_CODE
				,MEASURE
				,PLAN_YYYYMM
				,PROJECT_NAME
				,CUST_FCST_QTY
				,MKT_FCST_QTY
				--,M1_CUST_FCST_QTY,M2_CUST_FCST_QTY,M3_CUST_FCST_QTY
				--,M1_MKT_FCST_QTY,M2_MKT_FCST_QTY,M3_MKT_FCST_QTY
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
			)

			SELECT A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE
				, 'MKT_FCST_FST'			AS MEASURE
				, @v_curr_month				AS PLAN_YYYYMM
				, A.PROJECT_NAME
				, ISNULL (B.SUM_QTY, 0)				AS CUST_FCST_QTY
				, ISNULL (C.SUM_QTY, 0)				AS MKT_FCST_QTY
				--, ISNULL (D.M1_CUST_FCST_QTY, 0)	AS M1_CUST_FCST_QTY
				--, ISNULL (D.M2_CUST_FCST_QTY, 0)	AS M2_CUST_FCST_QTY
				--, ISNULL (D.M3_CUST_FCST_QTY, 0)	AS M3_CUST_FCST_QTY
				--, ISNULL (D.M1_MKT_FCST_QTY, 0)	AS M1_MKT_FCST_QTY
				--, ISNULL (D.M2_MKT_FCST_QTY, 0)	AS M2_MKT_FCST_QTY
				--, ISNULL (D.M3_MKT_FCST_QTY, 0)	AS M3_MKT_FCST_QTY
				, @V_CREATED_BY						AS CREATED_BY		
				, GETDATE()							AS CREATION_DATE	 
				, @V_CREATED_BY						AS LAST_UPDATED_BY		
				, GETDATE()							AS LAST_UPDATE_DATE	 
			FROM #temp_CUSTOMER_PROJECT A WITH(NOLOCK)
			LEFT OUTER JOIN 
			(
			   -- CUST_FCST_QTY는 DM_PLN_MKT_FCST_C(Cust.FCST_RPA[P+P], CUST_FCST, CUST_FCST_EDI)에서 가져옴. ==> 버젼은 당주 첫주차 version_no = "MF_W_20241001_V002"
				SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
					 , SUM(QTY) AS SUM_QTY
				FROM #temp_DM_PLN_MKT_FCST A WITH(NOLOCK)
				INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
				ON	A.DIVISION_ID	= B.DIVISION_ID
				AND A.SCM_SITE_ID	= B.SCM_SITE_ID
				WHERE A.DIVISION_ID	= @v_division_id
				AND   A.VERSION_NO	= @v_curr_mkt_fcst_version_no
				AND   A.CUTOFF_TYPE	= 'MF_W'
--				AND   A.MEASURE IN ('Customer FCST','CUST_FCST_EDI')
				AND   A.MEASURE IN ('CUST_FCST')						-- CUST_FCST = Customer FCST + CUST_FCST_EDI 임
				AND   A.YYYYMMDD	>= @v_curr_month_firstday
				AND   A.YYYYMMDD	<= @v_curr_month_lastday
				GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
			) B
			ON	A.DIVISION_ID	= B.DIVISION_ID
			AND A.END_CUSTOMER	= B.END_CUSTOMER
			AND A.PROJECT_CODE	= B.PROJECT_CODE
			LEFT OUTER JOIN 
			(
			   -- MTK_FCST는 당월 계획 (MKT_FCST_C.MKT_FCST mesaure.version_no = "MF_W_20241001_V002" )에서 가져옴. 
			   -- (단, 당월 첫주가 전주라면  DM_PLN_MKT_FCST_RESULT_C(RTF_SYS_RP)에서 전주 1일 실적부터 합산함)
				SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
					 , SUM(QTY) AS SUM_QTY
				FROM #temp_DM_PLN_MKT_FCST A WITH(NOLOCK)
				INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
				ON	A.DIVISION_ID	= B.DIVISION_ID
				AND A.SCM_SITE_ID	= B.SCM_SITE_ID
				WHERE A.DIVISION_ID	= @v_division_id
				AND   A.VERSION_NO	= @v_curr_mkt_fcst_version_no
				AND   A.CUTOFF_TYPE	= 'MF_W'
				AND   A.MEASURE IN ('MKT_FCST')
				AND   A.YYYYMMDD	>= @v_curr_month_firstday
				AND   A.YYYYMMDD	<= @v_curr_month_lastday
				GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE				
			) C
			ON	A.DIVISION_ID	= C.DIVISION_ID
			AND A.END_CUSTOMER	= C.END_CUSTOMER
			AND A.PROJECT_CODE	= C.PROJECT_CODE
			--LEFT OUTER JOIN 
			--(
			--   -- M1_CUST_FCST_QTY / M2_CUST_FCST_QTY / M3_CUST_FCST_QTY / M1_MKT_FCST_QTY / M2_MKT_FCST_QTY / M3_MKT_FCST_QTY는  DM_CUST_DEMAND_ANL_SUMMARY (Final) 에서 가져옴.
			--	SELECT DIVISION_ID, END_CUSTOMER, PROJECT_CODE
			--		 , CUST_FCST_QTY		AS M1_CUST_FCST_QTY		-- 전월의 현재는 당월은 M-1임
			--		 , M1_CUST_FCST_QTY		AS M2_CUST_FCST_QTY		-- 전월의 M-1는 당월은 M-2임
			--		 , M2_CUST_FCST_QTY		AS M3_CUST_FCST_QTY		-- 전월의 M-2는 당월은 M-3임
			--		 , MKT_FCST_QTY			AS M1_MKT_FCST_QTY
			--		 , M1_MKT_FCST_QTY		AS M2_MKT_FCST_QTY
			--		 , M2_MKT_FCST_QTY		AS M3_MKT_FCST_QTY
			--	FROM DM_CUST_DEMAND_ANL_SUMMARY A WITH(NOLOCK)
			--	WHERE A.DIVISION_ID	= @v_division_id
			--	AND   A.MEASURE		= 'MKT_FCST_FNL'
			--	AND   A.PLAN_YYYYMM	= @v_prev1_month
			--) D
			--ON	A.DIVISION_ID	= D.DIVISION_ID
			--AND A.END_CUSTOMER	= D.END_CUSTOMER
			--AND A.PROJECT_CODE	= D.PROJECT_CODE
			;

		END;

        PRINT ( N'A4--당월 FINAL 생성 ' + CONVERT(NVARCHAR(30), GETDATE(), 121));

--STEP07 : DM_CUST_DEMAND_ANL_SUMMARY.YYYYMM(당월-MKT_FCST_FNL)의 값 DEFALT로 생성 


		INSERT INTO DM_CUST_DEMAND_ANL_SUMMARY(
				DIVISION_ID,END_CUSTOMER,PROJECT_CODE
			,MEASURE
			,PLAN_YYYYMM
			,PROJECT_NAME
			,CUST_FCST_QTY
			,MKT_FCST_QTY
			--,M1_CUST_FCST_QTY,M2_CUST_FCST_QTY,M3_CUST_FCST_QTY
			--,M1_MKT_FCST_QTY,M2_MKT_FCST_QTY,M3_MKT_FCST_QTY
			,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
		)
		SELECT A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE
			, 'MKT_FCST_FNL'			AS MEASURE
			, @v_curr_month				AS PLAN_YYYYMM
			, A.PROJECT_NAME
			, ISNULL (B.CUST_FCST_QTY, 0)				AS CUST_FCST_QTY
			, 0							AS MKT_FCST_QTY
			--, ISNULL (D.M1_CUST_FCST_QTY, 0)	AS M1_CUST_FCST_QTY
			--, ISNULL (D.M2_CUST_FCST_QTY, 0)	AS M2_CUST_FCST_QTY
			--, ISNULL (D.M3_CUST_FCST_QTY, 0)	AS M3_CUST_FCST_QTY
			--, ISNULL (D.M1_MKT_FCST_QTY, 0)	AS M1_MKT_FCST_QTY
			--, ISNULL (D.M2_MKT_FCST_QTY, 0)	AS M2_MKT_FCST_QTY
			--, ISNULL (D.M3_MKT_FCST_QTY, 0)	AS M3_MKT_FCST_QTY
			, @V_CREATED_BY				AS CREATED_BY		
			, GETDATE()					AS CREATION_DATE	 
			, @V_CREATED_BY				AS LAST_UPDATED_BY		
			, GETDATE()					AS LAST_UPDATE_DATE	 
		FROM #temp_CUSTOMER_PROJECT A WITH(NOLOCK)
		LEFT OUTER JOIN 
		(
			SELECT DIVISION_ID, END_CUSTOMER, PROJECT_CODE
					, CUST_FCST_QTY			AS CUST_FCST_QTY		-- 당월의 FIRST의 CUST_FCST 가져옴
			FROM DM_CUST_DEMAND_ANL_SUMMARY A WITH(NOLOCK)
			WHERE A.DIVISION_ID	= @v_division_id
			AND   A.MEASURE		= 'MKT_FCST_FST'
			AND   A.PLAN_YYYYMM	= @v_curr_month
		) B
		ON	A.DIVISION_ID	= B.DIVISION_ID
		AND A.END_CUSTOMER	= B.END_CUSTOMER
		AND A.PROJECT_CODE	= B.PROJECT_CODE
		--LEFT OUTER JOIN 
		--(
		--	-- M1_CUST_FCST_QTY / M2_CUST_FCST_QTY / M3_CUST_FCST_QTY / M1_MKT_FCST_QTY / M2_MKT_FCST_QTY / M3_MKT_FCST_QTY는  DM_CUST_DEMAND_ANL_SUMMARY (Final) 에서 가져옴.
		--	SELECT DIVISION_ID, END_CUSTOMER, PROJECT_CODE
		--			, CUST_FCST_QTY		AS M1_CUST_FCST_QTY		-- 전월의 현재는 당월은 M-1임
		--			, M1_CUST_FCST_QTY		AS M2_CUST_FCST_QTY		-- 전월의 M-1는 당월은 M-2임
		--			, M2_CUST_FCST_QTY		AS M3_CUST_FCST_QTY		-- 전월의 M-2는 당월은 M-3임
		--			, MKT_FCST_QTY			AS M1_MKT_FCST_QTY
		--			, M1_MKT_FCST_QTY		AS M2_MKT_FCST_QTY
		--			, M2_MKT_FCST_QTY		AS M3_MKT_FCST_QTY
		--	FROM DM_CUST_DEMAND_ANL_SUMMARY A WITH(NOLOCK)
		--	WHERE A.DIVISION_ID	= @v_division_id
		--	AND   A.MEASURE		= 'MKT_FCST_FNL'
		--	AND   A.PLAN_YYYYMM	= @v_prev1_month
		--) D
		--ON	A.DIVISION_ID	= D.DIVISION_ID
		--AND A.END_CUSTOMER	= D.END_CUSTOMER
		--AND A.PROJECT_CODE	= D.PROJECT_CODE
		;		


        --STEP08 : 당월 기준 데이터가 없는 내용 0으로 추가

		INSERT INTO DM_CUST_DEMAND_ANL_SUMMARY
		(
			 DIVISION_ID,END_CUSTOMER,PROJECT_CODE
			,MEASURE
			,PLAN_YYYYMM
			,PROJECT_NAME
			,CUST_FCST_QTY
			,MKT_FCST_QTY
			,M1_CUST_FCST_QTY,M2_CUST_FCST_QTY,M3_CUST_FCST_QTY
			,M1_MKT_FCST_QTY,M2_MKT_FCST_QTY,M3_MKT_FCST_QTY
			,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
		)
		SELECT A.DIVISION_ID,A.END_CUSTOMER,A.PROJECT_CODE
			 , B.MEASURE
			 , @v_curr_month	AS PLAN_YYYYMM
			 , A.PROJECT_NAME
			 , 0				AS CUST_FCST_QTY
			 , 0				AS MKT_FCST_QTY
			 , 0				AS M1_CUST_FCST_QTY
			 , 0				AS M2_CUST_FCST_QTY
			 , 0				AS M3_CUST_FCST_QTY
			 , 0				AS M1_MKT_FCST_QTY
			 , 0				AS M2_MKT_FCST_QTY
			 , 0				AS M3_MKT_FCST_QTY
			 , @V_CREATED_BY	AS CREATED_BY
			 , GETDATE()		AS CREATION_DATE
			 , @V_CREATED_BY	AS LAST_UPDATED_BY
			 , GETDATE()		AS LAST_UPDATE_DATE
		FROM (
			SELECT A.DIVISION_ID,A.END_CUSTOMER,A.PROJECT_CODE, A.PROJECT_NAME
			FROM #temp_CUSTOMER_PROJECT A
			LEFT OUTER JOIN (
				SELECT *
				FROM DM_CUST_DEMAND_ANL_SUMMARY 
				WHERE DIVISION_ID = @v_division_id
				AND   PLAN_YYYYMM = @v_curr_month
			) B
			ON  A.DIVISION_ID = B.DIVISION_ID
			AND A.END_CUSTOMER = B.END_CUSTOMER
			AND A.PROJECT_CODE = B.PROJECT_CODE
			WHERE B.DIVISION_ID IS NULL
		) A,
		( 
			SELECT 'MKT_FCST_FST' AS MEASURE 
			UNION ALL
			SELECT 'MKT_FCST_FNL' AS MEASURE
		) B



--STEP09 : (M-1 ~ M-3) 기준의 당월 계획 수집

		DECLARE @v_std_month	NVARCHAR(10);
		SET	@v_std_month = @v_curr_month;

		EXEC PR_DM_CUST_DEMAND_ANL_SUMMARY_SUB @v_division_id, @v_std_month, @v_prev1_month, 'M-1';
		EXEC PR_DM_CUST_DEMAND_ANL_SUMMARY_SUB @v_division_id, @v_std_month, @v_prev2_month, 'M-2';
		EXEC PR_DM_CUST_DEMAND_ANL_SUMMARY_SUB @v_division_id, @v_std_month, @v_prev3_month, 'M-3';

--STEP10 : null 데이터 0으로 치환
		UPDATE DM_CUST_DEMAND_ANL_SUMMARY
		SET CUST_FCST_QTY = 0
		WHERE DIVISION_ID = @v_division_id
		AND   PLAN_YYYYMM = @v_curr_month
		AND   CUST_FCST_QTY IS NULL

		UPDATE DM_CUST_DEMAND_ANL_SUMMARY
		SET MKT_FCST_QTY = 0
		WHERE DIVISION_ID = @v_division_id
		AND   PLAN_YYYYMM = @v_curr_month
		AND   MKT_FCST_QTY IS NULL

		UPDATE DM_CUST_DEMAND_ANL_SUMMARY
		SET M1_CUST_FCST_QTY = 0
		WHERE DIVISION_ID = @v_division_id
		AND   PLAN_YYYYMM = @v_curr_month
		AND   M1_CUST_FCST_QTY IS NULL

		UPDATE DM_CUST_DEMAND_ANL_SUMMARY
		SET M2_CUST_FCST_QTY = 0
		WHERE DIVISION_ID = @v_division_id
		AND   PLAN_YYYYMM = @v_curr_month
		AND   M2_CUST_FCST_QTY IS NULL

		UPDATE DM_CUST_DEMAND_ANL_SUMMARY
		SET M3_CUST_FCST_QTY = 0
		WHERE DIVISION_ID = @v_division_id
		AND   PLAN_YYYYMM = @v_curr_month
		AND   M3_CUST_FCST_QTY IS NULL

		UPDATE DM_CUST_DEMAND_ANL_SUMMARY
		SET M1_MKT_FCST_QTY = 0
		WHERE DIVISION_ID = @v_division_id
		AND   PLAN_YYYYMM = @v_curr_month
		AND   M1_MKT_FCST_QTY IS NULL

		UPDATE DM_CUST_DEMAND_ANL_SUMMARY
		SET M2_MKT_FCST_QTY = 0
		WHERE DIVISION_ID = @v_division_id
		AND   PLAN_YYYYMM = @v_curr_month
		AND   M2_MKT_FCST_QTY IS NULL

		UPDATE DM_CUST_DEMAND_ANL_SUMMARY
		SET M3_MKT_FCST_QTY = 0
		WHERE DIVISION_ID = @v_division_id
		AND   PLAN_YYYYMM = @v_curr_month
		AND   M3_MKT_FCST_QTY IS NULL

        BEGIN
            --2025.02.11 Philsu Park: [E20250205-000991] ITEM 단위 집계 처리 추가 수행.
            EXEC PR_DM_CUST_DEMAND_BY_ITM_SUMMARY @p_division_id, @p_replan_yn, @v_exe_yyyymmdd;
        END;

        COMMIT TRAN PR_DM_CUST_DEMAND_ANL_SUMMARY;

    END TRY

	BEGIN CATCH
		ROLLBACK TRAN PR_DM_CUST_DEMAND_ANL_SUMMARY;

		-- ERROR LOG
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
			,@v_log_type
			,@n_log_count
			,@v_log_message
			,@v_description
			,@d_event_date;
			
         PRINT ( 'A12-- ERROR ' + CONVERT(NVARCHAR(30), GETDATE(), 121) + @v_log_message)
			 
	END CATCH;

	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
		,@v_log_type
		,@n_log_count
		,@v_log_message
		,@v_description
		,@d_event_date;
		
   PRINT ( 'A13-- END ' + CONVERT(NVARCHAR(30), GETDATE(), 121));

END;
 
	 
