




/*
 * Program ID  : [PR_DM_CUST_DEMAND_ANL_SUMMARY_SUB]
 * Description  : 고객수요증감분석 데이터 기초값 생성 및 인터페이스 전송
 * 메인테이블
   DM_CUST_DEMAND_ANL_SUMMARY
   XIF_DM_ANL_MKT_PSI_DW_S
   XIF_DM_ANL_MKT_PSI_DETAIL_DW_S
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *=================================================================================================== 
 2024.11.28    KANG.H.J       [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선

 */
/*
 EXEC PR_DM_CUST_DEMAND_ANL_SUMMARY_SUB '81', '202412', '202411', 'M-1'
 */
----------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[PR_DM_CUST_DEMAND_ANL_SUMMARY_SUB] 
	 @p_division_id			NVARCHAR(MAX)			
	,@p_std_month			NVARCHAR(MAX)			-- 202411월 기준월
	,@p_prev_month			NVARCHAR(MAX)			-- 202409월 조사할 데이터
	,@p_prev_desc			NVARCHAR(MAX)			-- M-2 : 202411월 기준으로는 202409월은 M-2월임 

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET XACT_ABORT ON; 

	BEGIN TRY

		-- LOG 용 변수 설정
		DECLARE @V_PROGRAM_NAME		NVARCHAR(150) = 'PR_DM_CUST_DEMAND_ANL_SUMMARY_SUB';
		DECLARE @V_LOG_TYPE			NVARCHAR(30); -- START/END/ERROR/...
		DECLARE @N_LOG_COUNT		INTEGER = 0;
		DECLARE @V_LOG_MESSAGE		NVARCHAR(1000);
		DECLARE @V_DESCRIPTION		NVARCHAR(500);
		DECLARE @D_EVENT_DATE		DATETIME;
		DECLARE @N_DELETE_COUNT		INTEGER = 0;
		DECLARE @N_INSERT_COUNT     INTEGER = 0;
		DECLARE @V_CREATED_BY		NVARCHAR(150)	= 'PR_DM_CUST_DEMAND_ANL_SUMMARY_SUB';

		-- 시작 LOG
		SET @V_LOG_TYPE = 'START';
		SET @V_LOG_MESSAGE = '########## START OF PROCEDURE ##########';
		SET @V_DESCRIPTION = '';
		SET @D_EVENT_DATE = SYSDATETIME();
		EXEC  PR_DM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE, @V_CREATED_BY;
 

		DECLARE @v_curr_month_firstday		NVARCHAR(08);		-- 당월의 첫번째 날
		DECLARE @v_curr_month_lastday		NVARCHAR(08);		-- 당월의 마지막 날	
		DECLARE @v_prev_month_tuesday		NVARCHAR(08);		-- (M-1 ~ M-3) 의 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff	
		DECLARE @v_prev_month_monday		NVARCHAR(08);		-- (M-1 ~ M-3) 의 첫번째 수요일이 포함된 주차의 월요일 날짜
		DECLARE @v_prev_mkt_fcst_version_no		NVARCHAR(MAX);		-- 당월 첫주차의 MKT_FCST Cutoff VERSION_NO	

		DECLARE @v_prev_month				NVARCHAR(8);		-- plan 수립시점 시점
		DECLARE @v_curr_month				NVARCHAR(06);		-- YYYYMM (당월)	-- 조사할 시점을 당월로 정의하고 처리함.		
			
			
		DECLARE @v_delimiter		NVARCHAR(1);
		
		DECLARE @v_division_id		NVARCHAR(10);
		DECLARE @v_std_month		NVARCHAR(10);
		DECLARE @v_prev_desc		NVARCHAR(10);

		DECLARE @v_CNT_FCST INTEGER = 0;

		IF OBJECT_ID(N'tempdb..#temp_DM_PLN_MKT_FCST_RESULT_SUB', N'U') IS NOT NULL
			DROP TABLE #temp_DM_PLN_MKT_FCST_RESULT_SUB

		CREATE TABLE #temp_DM_PLN_MKT_FCST_RESULT_SUB(
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

		IF OBJECT_ID(N'tempdb..#temp_DM_PLN_MKT_FCST_SUB', N'U') IS NOT NULL
			DROP TABLE #temp_DM_PLN_MKT_FCST_SUB

		CREATE TABLE #temp_DM_PLN_MKT_FCST_SUB(
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

		IF OBJECT_ID(N'tempdb..#temp_DM_CUST_DEMAND_ANL_SUMMARY_SUB', N'U') IS NOT NULL
			DROP TABLE #temp_DM_CUST_DEMAND_ANL_SUMMARY_SUB;	

		CREATE TABLE #temp_DM_CUST_DEMAND_ANL_SUMMARY_SUB(
			[DIVISION_ID] [nvarchar](30) NOT NULL,
			[END_CUSTOMER] [nvarchar](100) NOT NULL,
			[PROJECT_CODE] [nvarchar](50) NOT NULL,
			[PLAN_YYYYMM] [nvarchar](8) NOT NULL,
			[PROJECT_NAME] [nvarchar](100) NOT NULL,
			[CUST_FCST_QTY] [numeric](20, 10) NOT NULL,
			[MKT_FCST_QTY] [numeric](20, 10) NOT NULL,
			[PREV_DESC]	[nvarchar](20) NOT NULL
		)


		SET @v_division_id	= @p_division_id;
		SET @v_std_month	= @p_std_month;
		SET @v_prev_month	= @p_prev_month;
		SET @v_prev_desc	= @p_prev_desc;

-- STEP01 : 기준데이터 정의
		
		-- 오늘기준의 당월 
		SET @v_curr_month = @v_std_month;

		-- 당월의 첫날 구하기
		SET @v_curr_month_firstday = @v_curr_month + '01';
		-- 당월의 마지막날 구하기
		SELECT @v_curr_month_lastday = MAX(BASIS_YYYYMMDD) 
		FROM   [SCM_SYS_CALENDAR_M] A WITH(NOLOCK) 
		WHERE A.BASIS_YYYYMM = @v_curr_month 

		-- M-1~M-3의  첫 수요일 구하기	
		SELECT @v_prev_month_tuesday = MIN(BASIS_YYYYMMDD)
		FROM   [SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
		WHERE  DAYOFWEEK = 'WED'
		AND    A.basis_yyyymmdd >= @v_prev_month+'01' 
		AND    A.basis_yyyymmdd <= @v_prev_month+'28'



		-- M-1~M-3의 첫 수요일이 있는 월요일 날짜
		SELECT @v_prev_month_monday = BASIS_YYYYMMDD
		FROM   [SCM_SYS_CALENDAR_M] WITH(NOLOCK)
		WHERE  ISO_YYYYWW IN	( 
									SELECT ISO_YYYYWW
									FROM   [SCM_SYS_CALENDAR_M] WITH(NOLOCK)
									WHERE  BASIS_YYYYMMDD = @v_prev_month_tuesday
								)
		AND    DAYOFWEEK = 'MON'


		-- M-1~M-3의 첫주의 MKT_FCST VERSION_NO 추출
		SELECT @v_prev_mkt_fcst_version_no = MAX (VERSION_NO)
		FROM DM_MST_VERSION WITH(NOLOCK)
		WHERE DIVISION_ID	= @v_division_id
		AND   VERSION_TYPE	= 'MF_W'
		AND   YYYYMMDD		>= @v_prev_month_monday
		AND   YYYYMMDD		< CONVERT(VARCHAR,DATEADD(WW, 1, CONVERT (DATE, @v_prev_month_monday)), 112)

	   
		-- 여기서부터 TRANSACTION 처리
		BEGIN TRAN PR_DM_CUST_DEMAND_ANL_SUMMARY;

        PRINT ( N'A1--대상 데이터 추출 ' + CONVERT(NVARCHAR(30), GETDATE(), 121))

--STEP02 : 대상 데이터 추출

		SELECT @v_CNT_FCST = COUNT(*) 
		FROM DM_PLN_MKT_FCST_C WITH(NOLOCK)
		WHERE DIVISION_ID = @v_division_id 
		AND VERSION_NO = @v_prev_mkt_fcst_version_no 
		AND CUTOFF_TYPE = 'MF_W'
		

		IF (@v_CNT_FCST != 0) 
		BEGIN
				INSERT INTO #temp_DM_PLN_MKT_FCST_SUB
				(
					   DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY				)
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
				FROM DM_PLN_MKT_FCST_C A WITH(NOLOCK)
				WHERE A.DIVISION_ID	= @v_division_id
				AND   A.VERSION_NO	= @v_prev_mkt_fcst_version_no
				AND   A.FCST_TYPE	IN ('MPS', 'Mass')
		END;

		ELSE 
		BEGIN
				INSERT INTO #temp_DM_PLN_MKT_FCST_SUB
				(
					   DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY				)
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
				FROM DM_PLN_MKT_FCST_C_KEEP A WITH(NOLOCK)
				WHERE A.DIVISION_ID	= @v_division_id
				AND   A.VERSION_NO	= @v_prev_mkt_fcst_version_no
				AND   A.FCST_TYPE	IN ('MPS', 'Mass')
		END;

        PRINT ( N'A2- M-1~M-3 생성 기준마련' + CONVERT(NVARCHAR(30), GETDATE(), 121));

--STEP03 : DM_PLN_MKT_FCST_RESULT_C (M-26 ~ M) 사이에 있는 division / end_customer / project 코드 생성 ==> #temp_Customer_Project (데이터 생성의 기준점이 됨)

		IF OBJECT_ID(N'tempdb..#temp_CUSTOMER_PROJECT_SUB', N'U') IS NOT NULL
			DROP TABLE #temp_CUSTOMER_PROJECT_SUB

		-- 당월은 아래 기준으로만 생성함.
		SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE, C.PROJECT_NAME
		INTO #temp_CUSTOMER_PROJECT_SUB
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
		AND   YYYYMMDD >= CONVERT(VARCHAR,DATEADD(MM, -26, CONVERT (DATE, @v_prev_month+'01')), 112)	-- 당월이전 26개월 이후로 하되.
		AND   YYYYMMDD <  CONVERT(VARCHAR,DATEADD(MM, +1, CONVERT (DATE, @v_prev_month+'01')), 112)		-- 당월보다는 작아야 함.
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

--STEP04 : M-1 ~ M-3 중 대상이 되는 (CUST_FCST / MKT_FCST_FST)의 값 생성 

        PRINT ( N'A3-1--당월 FIRST 생성' + CONVERT(NVARCHAR(30), GETDATE(), 121));

			INSERT INTO #temp_DM_CUST_DEMAND_ANL_SUMMARY_SUB (
				DIVISION_ID, END_CUSTOMER, PROJECT_CODE, PLAN_YYYYMM, PROJECT_NAME
			  , CUST_FCST_QTY, MKT_FCST_QTY, PREV_DESC
			)
			SELECT A.DIVISION_ID, A.END_CUSTOMER, A.PROJECT_CODE
				, @v_curr_month				AS PLAN_YYYYMM
				, A.PROJECT_NAME
				, ISNULL (B.SUM_QTY, 0)		AS CUST_FCST_QTY
				, ISNULL (C.SUM_QTY, 0)		AS MKT_FCST_QTY
				, @p_prev_desc				AS PREV_DESC
			FROM #temp_CUSTOMER_PROJECT_SUB A WITH(NOLOCK)
			LEFT OUTER JOIN 
			(
			   -- CUST_FCST_QTY는 DM_PLN_MKT_FCST_C(Cust.FCST_RPA[P+P], CUST_FCST, CUST_FCST_EDI)에서 가져옴. ==> 버젼은 당주 첫주차 version_no = "MF_W_20241001_V002"
				SELECT A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE
					 , SUM(QTY) AS SUM_QTY
				FROM #temp_DM_PLN_MKT_FCST_SUB A WITH(NOLOCK)
				INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
				ON	A.DIVISION_ID	= B.DIVISION_ID
				AND A.SCM_SITE_ID	= B.SCM_SITE_ID
				WHERE A.DIVISION_ID	= @v_division_id
				AND   A.VERSION_NO	= @v_prev_mkt_fcst_version_no
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
				FROM #temp_DM_PLN_MKT_FCST_SUB A WITH(NOLOCK)
				INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
				ON	A.DIVISION_ID	= B.DIVISION_ID
				AND A.SCM_SITE_ID	= B.SCM_SITE_ID
				WHERE A.DIVISION_ID	= @v_division_id
				AND   A.VERSION_NO	= @v_prev_mkt_fcst_version_no
				AND   A.CUTOFF_TYPE	= 'MF_W'
				AND   A.MEASURE IN ('MKT_FCST')
				AND   A.YYYYMMDD	>= @v_curr_month_firstday
				AND   A.YYYYMMDD	<= @v_curr_month_lastday
				GROUP BY A.DIVISION_ID, B.END_CUSTOMER, A.PROJECT_CODE				
			) C
			ON	A.DIVISION_ID	= C.DIVISION_ID
			AND A.END_CUSTOMER	= C.END_CUSTOMER
			AND A.PROJECT_CODE	= C.PROJECT_CODE
			;


		PRINT ( N'A4--당월 FINAL 생성 ' + CONVERT(NVARCHAR(30), GETDATE(), 121));
--STEP05 : M-1 ~ M-3 중 대상이 되는 (CUST_FCST / MKT_FCST_FST)의 데이터 UPDATE

		IF ( @p_prev_desc = 'M-1')
		BEGIN

			MERGE INTO DM_CUST_DEMAND_ANL_SUMMARY A 
			USING #temp_DM_CUST_DEMAND_ANL_SUMMARY_SUB B
			ON (		A.DIVISION_ID	= B.DIVISION_ID
					AND A.END_CUSTOMER	= B.END_CUSTOMER
					AND A.PROJECT_CODE	= B.PROJECT_CODE 
					AND A.PROJECT_NAME	= B.PROJECT_NAME 
					AND A.PLAN_YYYYMM	= @p_std_month
			)
			WHEN MATCHED THEN
				UPDATE SET A.M1_CUST_FCST_QTY	= B.CUST_FCST_QTY
						 , A.M1_MKT_FCST_QTY	= B.MKT_FCST_QTY
			;

			--------------------------------------------------------------------------------------------------------
			-- 대상데이터 LOG (START)
			--------------------------------------------------------------------------------------------------------
			SET @v_log_type    = N'APPEND';  
			SET @v_log_message = N'MKT_FCST : ' + @v_division_id; 
			SET @v_description = N'VERSION(M-1) : ' + @v_prev_mkt_fcst_version_no;
			SET @d_event_date  = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, 0, @v_log_message, @v_description, @d_event_date;  


		END;
		ELSE IF ( @p_prev_desc = 'M-2')
		BEGIN
			MERGE INTO DM_CUST_DEMAND_ANL_SUMMARY A 
			USING #temp_DM_CUST_DEMAND_ANL_SUMMARY_SUB B
			ON (		A.DIVISION_ID	= B.DIVISION_ID
					AND A.END_CUSTOMER	= B.END_CUSTOMER
					AND A.PROJECT_CODE	= B.PROJECT_CODE 
					AND A.PROJECT_NAME	= B.PROJECT_NAME 
					AND A.PLAN_YYYYMM	= @p_std_month
			)
			WHEN MATCHED THEN
				UPDATE SET A.M2_CUST_FCST_QTY	= B.CUST_FCST_QTY
						 , A.M2_MKT_FCST_QTY	= B.MKT_FCST_QTY
			;

			--------------------------------------------------------------------------------------------------------
			-- 대상데이터 LOG (START)
			--------------------------------------------------------------------------------------------------------
			SET @v_log_type    = N'APPEND';  
			SET @v_log_message = N'MKT_FCST : ' + @v_division_id; 
			SET @v_description = N'VERSION(M-2) : ' + @v_prev_mkt_fcst_version_no;
			SET @d_event_date  = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, 0, @v_log_message, @v_description, @d_event_date;  

		END;
		ELSE IF ( @p_prev_desc = 'M-3')
		BEGIN
			MERGE INTO DM_CUST_DEMAND_ANL_SUMMARY A 
			USING #temp_DM_CUST_DEMAND_ANL_SUMMARY_SUB B
			ON (		A.DIVISION_ID	= B.DIVISION_ID
					AND A.END_CUSTOMER	= B.END_CUSTOMER
					AND A.PROJECT_CODE	= B.PROJECT_CODE 
					AND A.PROJECT_NAME	= B.PROJECT_NAME 
					AND A.PLAN_YYYYMM	= @p_std_month
			)
			WHEN MATCHED THEN
				UPDATE SET A.M3_CUST_FCST_QTY	= B.CUST_FCST_QTY
						 , A.M3_MKT_FCST_QTY	= B.MKT_FCST_QTY
			;

			--------------------------------------------------------------------------------------------------------
			-- 대상데이터 LOG (START)
			--------------------------------------------------------------------------------------------------------
			SET @v_log_type    = N'APPEND';  
			SET @v_log_message = N'MKT_FCST : ' + @v_division_id; 
			SET @v_description = N'VERSION(M-3) : ' + @v_prev_mkt_fcst_version_no;
			SET @d_event_date  = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, 0, @v_log_message, @v_description, @d_event_date;  

		END;

		COMMIT;


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
 
	 
