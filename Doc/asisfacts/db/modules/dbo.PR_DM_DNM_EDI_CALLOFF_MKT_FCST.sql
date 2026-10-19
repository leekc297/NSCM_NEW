


/*
 * Program ID  : PR_DM_DNM_EDI_CALLOFF_MKT_FCST
 * Description  : GSCM COMPLETED EDI 정보 -> MKT_FCST INSERT(CUST_FCST_EDI MEASURE)
 *					  DM_DNM_EDI_CALLOFF_ITEM -> DM_PLN_MKT_FCST
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 배포시 주의사항 : 개발기 -> LGCE_INFDEV , 운영기 -> LGCE_INF
 *===================================================================================================
   20230503 kdmcc14		[EDI과제] PROJECT EDI_CALLOFF DATA -> MKT FCST MEASURE 생성
   20231006 chutoc730	[EDI과제] CUST_MATERIAL_CODE NOT LIKE '9j1%' 예외 분기 추가
   20231101 chutoc730	[EDI과제] MEASURE(SCHEDULING_TYPE) 별 오류 합 수정
   20231116 chutoc730	[EDI과제] Porsche/Audi/DRX Audi_DE_SHM / Porsche_DE_SHM 예외 로직 추가 / 추후 제외 소급 적용 룰 추가
   20231205 chutoc730	[EDI과제] 유통기간내 고객수요를 합산 로직을 기간내 MAX(IF_SEQ) 조건으로 합산 / 그룹조건에 CUSTOMER_PLANT를 추가하고 CUST_MATERIAL_CODE 를 제거 수정.
   20231206 chutoc730	MKT FCST[Auto] 화면 관련하여 발주처 예외처리.
   20240105 chutoc730	기존데이터 삭제 기준 날짜 변경 금주월요일~계획구간에서 당일~계획구간.
   20240116 chutoc730	END_CUSTOMER 추가 및 기준 하드코딩 LOOKUP(DM_EDI_CALLOFF_MKT_FCST_END_CUSTOMER) 에 데이터화.
   20240424 kcw3408     SENDER_NAME 30--> 200 으로 수정
   20240429 kcw3408     N:N Model Mapping_적재 추가(집계 시점에 Cust Item/Unloading Point/Plant 고려,Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음)
   20240626 JSSBAE		[E20240620-001488]_SCM DM 고객수요분석- Cust Plant NULL인 데이터 처리로직 개선
   20240626 JSSBAE		[E20240610-000320]_SCM DM EDI(Cust FCST) 관련 문의사항 (예외로직적용: 앞뒤 공백값, NULL값 공백으로 치환해서 비교 처리)
   20240703 JSSBAE		[E20240701-000472]_[공급 SCM PI팀] ERP EDI Master화면 업데이트 범위 개선   
   20241204 JSSBAE		[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정
   20241216	KANG.H.J	[PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
 */
--EXEC PR_DM_DNM_EDI_CALLOFF_MKT_FCST
CREATE PROCEDURE [dbo].[PR_DM_DNM_EDI_CALLOFF_MKT_FCST]
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	-- LOG 용 변수 설정
	DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_DNM_EDI_CALLOFF_MKT_FCST';
	DECLARE @V_BATCH_CHK_MSG NVARCHAR(150) = N' [DM]SOLDTO_CODE 없이 들어와서 계속해서 에러를 발생시켜서 TRANSFER_FLAG 를 변경함.'
	DECLARE @v_log_type NVARCHAR(30);-- START/END/ERROR/...
	DECLARE @n_log_count INTEGER = 0;
	DECLARE @v_log_message NVARCHAR(1000);
	DECLARE @v_description NVARCHAR(500);
	DECLARE @d_event_date DATETIME;
	DECLARE @v_ifseqno_INSERT NVARCHAR(30);-- 최종 MKT_FCST 테이블 INSERT
	DECLARE @v_SOLDTO_CODE NVARCHAR(10);
	DECLARE @v_SHIPTO_CODE NVARCHAR(10);
	DECLARE @v_UNLOADING_POINT NVARCHAR(35);
	DECLARE @v_CUSTOMER_PLANT NVARCHAR(8);
	DECLARE @v_SCHEDULING_TYPE NVARCHAR(6);
	DECLARE @v_PROJECT_CODE NVARCHAR(100);
	DECLARE @v_SCM_SITE_ID NVARCHAR(100);
	DECLARE @v_CUST_MATERIAL_CODE NVARCHAR(70);
	DECLARE @v_ITEM_ID NVARCHAR(100);
	DECLARE @v_END_CUSTOMER	NVARCHAR(35);
	DECLARE @v_SENDER_NAME	NVARCHAR(200);
	DECLARE @v_CREATE_DATE NVARCHAR(16);
	DECLARE @v_CREATE_TIME NVARCHAR(10);
	DECLARE @v_0week_monday NVARCHAR(08);--W0 월요일
	DECLARE @v_1week_monday NVARCHAR(08);--W1 월요일
	DECLARE @v_today NVARCHAR(08);--당일
	DECLARE @v_HOUR NVARCHAR(2);--시간체크
	DECLARE @v_YYYYMMDD NVARCHAR(8);--PSA YYYYMMDD
	DECLARE @v_DATEADDTODAY DATETIME; --오늘 날짜
	DECLARE @i INT = 1
		,@CNT INT = 0
	DECLARE @j INT = 1
		,@CNT_ORG INT = 0;

	SET @v_HOUR = ''
	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	SET @d_event_date = SYSDATETIME();
	SET @v_DATEADDTODAY = GETDATE();
	SET @v_today = FORMAT(@v_DATEADDTODAY, 'yyyyMMdd');

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
		,@v_log_type
		,@n_log_count
		,@v_log_message
		,@v_description
		,@d_event_date;

	SET @v_0week_monday = CONVERT(CHAR(8), DATEADD(DD, - 7, DBO.FN_NEXT_DAY(CONVERT(VARCHAR, @v_DATEADDTODAY, 112), 'MON')), 112) --W0월요일
	SET @v_1week_monday = CONVERT(CHAR(8), DATEADD(DD, - 7 + 7, DBO.FN_NEXT_DAY(CONVERT(VARCHAR, @v_DATEADDTODAY, 112), 'MON')), 112) --W1월요일
	--현재시간
	SET @v_HOUR = SUBSTRING(CONVERT(NVARCHAR, @v_DATEADDTODAY, 8), 1, 2)

	PRINT @v_1week_monday;


	BEGIN TRY
		DECLARE @v_FROM_YYYYMMDD    NVARCHAR(MAX);
		--오늘 기준 52W 전까지 조회함
		SET @v_FROM_YYYYMMDD = CONVERT(CHAR(8), DATEADD(WEEK,-52, DATEADD(WEEK, DATEDIFF(WEEK,0,GETDATE()), 0)), 112)
		--PSA 데이터 조회일자
		BEGIN
			SELECT @v_YYYYMMDD = (
					-- 다음주 일요일을 날짜기준으로 삼는데. (단 오늘이 일요일이면 오늘부터 기준을 삼음)	
					CASE WHEN DATEPART(WEEKDAY, @v_DATEADDTODAY) = '1'	THEN CONVERT(CHAR(8), DATEADD(DD, - 7, DBO.FN_NEXT_DAY(CONVERT(VARCHAR, @v_DATEADDTODAY, 112), 'SUN')), 112)
						 ELSE CONVERT(CHAR(8), DATEADD(DD, 0, DBO.FN_NEXT_DAY(CONVERT(VARCHAR, @v_DATEADDTODAY, 112), 'SUN')), 112)
					END
					)
		END

		BEGIN
			
			-- 예외 Sales Site 관리 테이블중복제거
			IF OBJECT_ID(N'tempdb..#TEMP_EDI_MGM_SALES_SITE', N'U') IS NOT NULL
				DROP TABLE #TEMP_EDI_MGM_SALES_SITE;

			-- 임시확인용 Sales Site 관리 테이블 중복제거
			IF OBJECT_ID(N'dbo.#TEMP_EDI_MGM_SALES_SITE', N'U') IS NOT NULL
				DROP TABLE #TEMP_EDI_MGM_SALES_SITE;

			--#TEMP_EDI_SALES_SITE	
			CREATE TABLE #TEMP_EDI_MGM_SALES_SITE (
					 PROJECT_CODE		NVARCHAR(100) NULL
					,SCM_SITE_ID		NVARCHAR(60) NULL --Sales Site
					,SENDER_NAME		NVARCHAR(200) NULL --EDI Sender
					,END_CUSTOMER		NVARCHAR(35) NULL --END_CUSTOMER
					,FROM_DAY			NVARCHAR(30) NULL
					,TO_DAY				NVARCHAR(30) NULL
				);


			-- 테이블중복제거
			IF OBJECT_ID(N'tempdb..#TEMP_EDI_END_CUSTOMER', N'U') IS NOT NULL
				DROP TABLE #TEMP_EDI_END_CUSTOMER

			-- 임시확인용테이블 중복제거
			IF OBJECT_ID(N'dbo.#TEMP_EDI_END_CUSTOMER', N'U') IS NOT NULL
				DROP TABLE #TEMP_EDI_END_CUSTOMER

			--#TEMP_EDI_END_CUSTOMER	
			CREATE TABLE #TEMP_EDI_END_CUSTOMER (
				DIVISION_ID			NVARCHAR(10) NULL
				,END_CUSTOMER		NVARCHAR(100) NULL
				,SCM_SITE_ID		NVARCHAR(60) NULL
				,FROM_WEEK			NVARCHAR(30) NULL
				,FROM_DAY			NVARCHAR(30) NULL
				,TO_WEEK			NVARCHAR(30) NULL
				,TO_DAY				NVARCHAR(30) NULL
				,ACTIVE				NVARCHAR(30) NULL
				);

			--EDI END_CUSTOMER별 기간 설정
			BEGIN
				--EDI_END_CUSTOMER Lookup의 Active = 'Off'이면 CREATE_DATE -52주부터, 'On'이면 Lookup 기간 사용
				INSERT INTO #TEMP_EDI_END_CUSTOMER (
					  DIVISION_ID
					, END_CUSTOMER
					, SCM_SITE_ID
					, FROM_WEEK
					, FROM_DAY
					, TO_WEEK
					, TO_DAY
					, ACTIVE
				)
				SELECT A.DIVISION_ID AS DIVISION_ID
					,A.END_CUSTOMER AS END_CUSTOMER
					,ISNULL(B.SEGMENT4, '-')		AS SCM_SITE_ID
					,CASE WHEN ISNULL(B.SEGMENT5, 'On') = 'On' THEN ISNULL(B.ATTRIBUTE1, '-1')
						  ELSE '-52'
					 END							AS FROM_WEEK
					,ISNULL(B.ATTRIBUTE2, 'TUE')	AS FROM_DAY
					,ISNULL(B.ATTRIBUTE3, '0')		AS TO_WEEK
					,ISNULL(B.ATTRIBUTE4, 'MON')	AS TO_DAY
					,ISNULL(B.SEGMENT5, 'On')		AS ACTIVE
				FROM SCM_MST_SITE A WITH (NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH (NOLOCK) 
					ON B.LOOKUP_TYPE	= 'EDI_END_CUSTOMER'
					AND A.DIVISION_ID	= B.SEGMENT1
					AND A.END_CUSTOMER	= B.SEGMENT2
					AND B.VALID_YN		= 'Y'
				WHERE ISNULL(A.END_CUSTOMER, '') <> ''
				GROUP BY A.DIVISION_ID
					,A.END_CUSTOMER
					,B.SEGMENT4
					,B.ATTRIBUTE1
					,B.ATTRIBUTE2
					,B.ATTRIBUTE3
					,B.ATTRIBUTE4
					,B.SEGMENT5
			END
			

			BEGIN
				-- 테이블중복제거
				IF OBJECT_ID(N'tempdb..#TEMP_EDI_ALL', N'U') IS NOT NULL
					DROP TABLE #TEMP_EDI_ALL

				-- 임시확인용테이블 중복제거
				IF OBJECT_ID(N'dbo.#TEMP_EDI_ALL', N'U') IS NOT NULL
					DROP TABLE #TEMP_EDI_ALL

				--#TEMP_EDI_NEW_ALL	
				CREATE TABLE #TEMP_EDI_ALL (
					 NUM				INT NULL
					,DIVISION_ID		NVARCHAR(10) NULL 
					,IFSEQNO			NVARCHAR(30) NULL
					,SOLDTO_CODE		NVARCHAR(10) NULL
					,SHIPTO_CODE		NVARCHAR(10) NULL
					,UNLOADING_POINT	NVARCHAR(35) NULL
					,CUSTOMER_PLANT		NVARCHAR(8) NULL 
					,SCHEDULING_TYPE	NVARCHAR(6) NULL
					,PROJECT_CODE		NVARCHAR(100) NULL
					,SCM_SITE_ID		NVARCHAR(100) NULL
					,CUST_MATERIAL_CODE NVARCHAR(70) NULL
					,ITEM_ID			NVARCHAR(100) NULL
					,ERP_FCST_TYPE		NVARCHAR(10) NULL 
					,CREATE_DATE		NVARCHAR(16) NULL
					,CREATE_TIME		NVARCHAR(10) NULL
					,MESSAGE_TYPE		NVARCHAR(12) NULL 
					,END_CUSTOMER		NVARCHAR(35) NULL
					,SENDER_NAME		NVARCHAR(200) NULL
					,YYYYMMDD			NVARCHAR(10) NULL
					);

				--EDI STATUS_CODE가 SUCCESS인 DATA
				BEGIN
					-- DIVISION_ID, SOLDTO_CODE, SHIPTO_CODE, UNLOADING_POINT, ITEM_ID, SCHEDULING_TYPE 기준으로 DATA 추출
					-- EDI물동 기준이 되는 IFSEQNO 추출함.
					INSERT INTO #TEMP_EDI_ALL (
						 NUM
						,DIVISION_ID 
						,IFSEQNO
						,SOLDTO_CODE
						,SHIPTO_CODE
						,UNLOADING_POINT
						,CUSTOMER_PLANT 
						,SCHEDULING_TYPE
						,PROJECT_CODE
						,SCM_SITE_ID
						,ITEM_ID
						,ERP_FCST_TYPE
						,CREATE_DATE
						,CREATE_TIME
						,MESSAGE_TYPE 
						,END_CUSTOMER
						,SENDER_NAME
						,YYYYMMDD
						)
					SELECT ROW_NUMBER() OVER (ORDER BY A.IFSEQNO) AS NUM					-- 해당 칼럼이 필요한가??
						,A.DIVISION_ID 
						,A.IFSEQNO
						,A.SOLDTO_CODE
						,A.SHIPTO_CODE
						,A.UNLOADING_POINT
						,A.CUSTOMER_PLANT
						,A.SCHEDULING_TYPE
						,A.PROJECT_CODE
						,A.SCM_SITE_ID
						,A.ITEM_ID
						,A.ERP_FCST_TYPE 
						,A.CREATE_DATE
						,A.CREATE_TIME
						,A.MESSAGE_TYPE
						,A.END_CUSTOMER
						,A.SENDER_NAME
						,A.YYYYMMDD
					FROM (
						SELECT ROW_NUMBER() OVER ( PARTITION BY   A.DIVISION_ID,A.SCHEDULING_TYPE,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID 
--																, CASE A.ERP_FCST_TYPE WHEN 'M' THEN 'MPS' WHEN 'S' THEN 'SMC' ELSE 'MPS' END			
																, CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END			
																 ORDER BY A.CREATE_DATE DESC, A.IFSEQNO DESC				
												 ) AS RNK
								, A.DIVISION_ID 
								, A.IFSEQNO
								, A.SOLDTO_CODE
								, A.SHIPTO_CODE
								, ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)), '') AS UNLOADING_POINT
								, ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), '') AS CUSTOMER_PLANT
								, A.SCHEDULING_TYPE
								, A.PROJECT_CODE
								, A.SCM_SITE_ID
								, A.ITEM_ID
								, CASE WHEN A.ERP_FCST_TYPE ='S' THEN 'SMC' ELSE 'MPS' END AS ERP_FCST_TYPE 
								, A.CREATE_DATE
								, A.CREATE_TIME
								, A.MESSAGE_TYPE 
								, B.END_CUSTOMER
								, A.SENDER_NAME
								, A.YYYYMMDD
						FROM DM_DNM_EDI_CALLOFF_ITEM A WITH (NOLOCK)
						LEFT OUTER JOIN SCM_MST_SITE B WITH (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID
							AND A.SCM_SITE_ID = B.SCM_SITE_ID
							AND B.SITE_TYPE = 'SALES'
							AND B.VALID_YN = 'Y'
							AND ISNULL(REPLACE(B.END_CUSTOMER, '-', ''), '') <> ''
						LEFT OUTER JOIN #TEMP_EDI_END_CUSTOMER C WITH (NOLOCK) ON A.DIVISION_ID = C.DIVISION_ID
							AND C.END_CUSTOMER = B.END_CUSTOMER
							AND C.SCM_SITE_ID = ISNULL((				-- ?? 기준정보 정비가 안되어 그런가?
															SELECT SCM_SITE_ID
															FROM #TEMP_EDI_END_CUSTOMER WITH (NOLOCK)
															WHERE DIVISION_ID = A.DIVISION_ID
																AND END_CUSTOMER = B.END_CUSTOMER
																AND SCM_SITE_ID = A.SCM_SITE_ID
															), '-')
						WHERE 1 = 1
							AND A.CREATE_DATE >= @v_FROM_YYYYMMDD		-- 52주 전부터가 유효한 데이터임.
							AND A.YYYYMMDD >= @v_today					-- 당일 이후
/*
							AND A.CREATE_DATE >= (	
													SELECT BASIS_YYYYMMDD		-- 시작일의 정의 (-1주 OR -52주의 날짜를 지정한 요일로 추출함) / (ON : -1, TUE. 1주전 화요일), (OFF : -52, MON. 52주전 월요일), (OFF : -52, TUE. 52주전 화요일)
													FROM (
															SELECT RANK() OVER (ORDER BY BASIS_YYYYMMDD DESC) * - 1 AS RK, DT.BASIS_YYYYMMDD 
															FROM SCM_SYS_CALENDAR_M DT WITH (NOLOCK)
															/* 2==> 월, 3==>화 */
															/* 현시점이 월요일이면, 전일(금주 일요일) 이전에 생성된 데이터만*/ 
															/* 현시점이 화요일 오전 5시이전, 전일(금주 일요일) 이전에 생성된 데이터만*/ 
															/* 현시점이 화요일 오전 5시이후, 당일까지 포함하여 과거 데이터만*/ 
															/* 현시점이 수요일 이후이면, 당일까지 포함하여 과거 데이터만*/ 
															/* 현시점이 일요일이면, 당일까지 포함하여 과거 데이터만*/ 
															WHERE BASIS_YYYYMMDD <=  (CASE WHEN DATEPART(WEEKDAY, @v_DATEADDTODAY) = '2' THEN CONVERT(NVARCHAR, DATEADD(DD, - 1, @v_DATEADDTODAY), 112)
																						   WHEN DATEPART(WEEKDAY, @v_DATEADDTODAY) = '3' THEN (
																																				CASE WHEN @v_HOUR < '05'THEN CONVERT(NVARCHAR, DATEADD(DD, - 2, @v_DATEADDTODAY), 112)
																																					 ELSE CONVERT(NVARCHAR, @v_DATEADDTODAY, 112)
																																				END
																																			  )
																							ELSE CONVERT(NVARCHAR, @v_DATEADDTODAY, 112)
																						END
																					  )
															AND DAYOFWEEK = C.FROM_DAY	-- 사용자가 정의한 요일로 처리
														) D
													WHERE D.RK = C.FROM_WEEK	-- FROM_WEEK는 -1 OR -52로만 존재함. ==> 즉, CREATE_DATE가 전주 또는 52주 전의 데이터부터인지의 기준을 정의함.
												)
							AND A.CREATE_DATE <= (			
													SELECT BASIS_YYYYMMDD	-- 종료일을 지정함 (0주(금주) OR -1주(차주)의 날짜를 지정한 요일로 추출함) /  (ON : 0, MON) / (OFF : 0, MON) / (OFF : -1, SUN) 
													FROM (
															SELECT (
																		CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER (ORDER BY BASIS_YYYYMMDD) - 2   
																			 ELSE RANK() OVER (ORDER BY BASIS_YYYYMMDD) - 1
																		END
																	) AS RK, DT.BASIS_YYYYMMDD 
															FROM SCM_SYS_CALENDAR_M DT WITH (NOLOCK)
															WHERE BASIS_YYYYMMDD >=  (CASE WHEN DATEPART(WEEKDAY, @v_DATEADDTODAY) = '2' THEN CONVERT(NVARCHAR, DATEADD(DD, - 1, @v_DATEADDTODAY), 112)
																						   WHEN DATEPART(WEEKDAY, @v_DATEADDTODAY) = '3' THEN (
																																				CASE WHEN @v_HOUR < '05' THEN CONVERT(NVARCHAR, DATEADD(DD, - 2, @v_DATEADDTODAY), 112)
																																					 ELSE CONVERT(NVARCHAR, @v_DATEADDTODAY, 112)
																																				END
																																			   )
																							ELSE CONVERT(NVARCHAR, @v_DATEADDTODAY, 112)
																						END
																					 )
																AND DAYOFWEEK = C.TO_DAY
														) D 
													WHERE D.RK = C.TO_WEEK
												)
*/
							AND A.STATUS_CODE = 'S'
							AND EXISTS 
							(
								SELECT 1 
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK) 
								WHERE LUP.LOOKUP_TYPE = 'DM_EDI_CALLOFF_MKT_FCST_END_CUSTOMER'	
								AND LUP.SEGMENT1  = A.DIVISION_ID
								AND LUP.SEGMENT2  = A.SENDER_NAME
								AND LUP.SEGMENT3  = B.END_CUSTOMER
								AND LUP.SEGMENT4  = A.SCHEDULING_TYPE
								AND A.MESSAGE_TYPE  = (
														CASE WHEN LUP.SEGMENT5 IN ('DELJIT','DELFOR') THEN LUP.SEGMENT5		-- DELJIT / DELFOR로 정의되어 있으면. 정의된 데이터만 추출함.
														ELSE (												-- 그렇지 않을 경우 이번주 일요일까지는 DELJIT / 그 이후로는 DELFOR 로 정의된 추출함.
																CASE WHEN A.YYYYMMDD <= @v_YYYYMMDD THEN 'DELJIT'	
																		ELSE 'DELFOR'
																END
														)
														END
														)
								AND LUP.VALID_YN = 'Y'
								AND ((LEN(LUP.ATTRIBUTE2) < 8 AND LEN(LUP.ATTRIBUTE3) < 8) OR (A.YYYYMMDD BETWEEN LUP.ATTRIBUTE1 AND LUP.ATTRIBUTE2))	-- 유효날짜 체크함.
							)
						GROUP BY A.DIVISION_ID 
							,A.IFSEQNO
							,A.SOLDTO_CODE
							,A.SHIPTO_CODE
							,ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)), '')
							,ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), '') 
							,A.SCHEDULING_TYPE
							,A.PROJECT_CODE
							,A.SCM_SITE_ID
							,A.ITEM_ID
							,CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END 
							,A.CREATE_DATE
							,A.CREATE_TIME
							,A.MESSAGE_TYPE 
							,B.END_CUSTOMER
							,A.SENDER_NAME
							,A.YYYYMMDD
						) A
					WHERE RNK = 1
					AND   LEN(A.YYYYMMDD) = 8				-- 강현준 추가 ('444444' 가 추가되어 있음
					ORDER BY A.IFSEQNO;
				END

				
				/* 자료 추출(고객수요 N:N Mapping 적용) */	
				-- 테이블중복제거
				IF OBJECT_ID(N'tempdb..#TEMP_EDI_MKT_FCST', N'U') IS NOT NULL
					DROP TABLE #TEMP_EDI_MKT_FCST

				-- 임시확인용테이블 중복제거
				IF OBJECT_ID(N'dbo.#TEMP_EDI_MKT_FCST', N'U') IS NOT NULL
					DROP TABLE #TEMP_EDI_MKT_FCST

				--#TEMP_EDI_MKT_FCST	
				CREATE TABLE #TEMP_EDI_MKT_FCST (
					 EDI_IF_SEQ				NVARCHAR(35) NULL
					,SUB_NO					SMALLINT NULL
					,YYYYMMDD				NVARCHAR(8) NULL
					,DIVISION_ID			NVARCHAR(30) NULL
					,SCM_SITE_ID			NVARCHAR(50) NULL
					,ITEM_ID				NVARCHAR(50) NULL
					,PROJECT_CODE			NVARCHAR(50) NULL
					,ERP_FCST_TYPE			NVARCHAR(10) NULL
					,BASIS_YYYYMMDD			NVARCHAR(8) NULL
					,QTY					NVARCHAR(35) NULL
					,EDI_INCOTERMS			NVARCHAR(50) NULL
					,SALES_PLANT_SITE_ID	NVARCHAR(50) NULL
					,DOM_EXP				NVARCHAR(10) NULL
					,COMPANY_ID				NVARCHAR(30) NULL
					,SOLDTO_CODE			NVARCHAR(10) NULL
					,SHIPTO_CODE			NVARCHAR(10) NULL
					,DOC_IDENTIFINER		NVARCHAR(35) NULL
					,MESSAGE_TYPE			NVARCHAR(6) NULL
					,UNLOADING_POINT		NVARCHAR(70) NULL
					,CUSTOMER_PLANT			NVARCHAR(8) NULL 
					,RDD_START				NVARCHAR(35) NULL
					,RDD_END				NVARCHAR(35) NULL
					,IFSEQNO				NVARCHAR(35) NULL
					,SCHEDULING_TYPE		NVARCHAR(3) NULL
					,DELFOR_TYPE			NVARCHAR(30) NULL
					,EDI_LT					INT NULL
					,CUST_MATERIAL_CODE		NVARCHAR(35) NULL
					,CREATE_DATE			NVARCHAR(8) NULL
					,CREATE_TIME			NVARCHAR(6) NULL
					,SENDER_CODE			NVARCHAR(10) NULL
					,SENDER_NAME			NVARCHAR(200) NULL
					,CHANGE_STATUS			NVARCHAR(10) NULL
					);

				-- 테이블중복제거
				IF OBJECT_ID(N'tempdb..#TEMP_EDI_MKT_FCST_ALL', N'U') IS NOT NULL
					DROP TABLE #TEMP_EDI_MKT_FCST_ALL

				-- 임시확인용테이블 중복제거
				IF OBJECT_ID(N'dbo.#TEMP_EDI_MKT_FCST_ALL', N'U') IS NOT NULL
					DROP TABLE #TEMP_EDI_MKT_FCST_ALL

				--#TEMP_EDI_MKT_FCST_ALL	
				CREATE TABLE #TEMP_EDI_MKT_FCST_ALL (
					 EDI_IF_SEQ				NVARCHAR(35) NULL
					,SUB_NO					SMALLINT NULL
					,YYYYMMDD				NVARCHAR(8) NULL
					,DIVISION_ID			NVARCHAR(30) NULL
					,SCM_SITE_ID			NVARCHAR(50) NULL
					,ITEM_ID				NVARCHAR(50) NULL
					,PROJECT_CODE			NVARCHAR(50) NULL
					,ERP_FCST_TYPE			NVARCHAR(10) NULL
					,BASIS_YYYYMMDD			NVARCHAR(8) NULL
					,QTY					NVARCHAR(35) NULL
					,EDI_INCOTERMS			NVARCHAR(50) NULL
					,SALES_PLANT_SITE_ID	NVARCHAR(50) NULL
					,DOM_EXP				NVARCHAR(10) NULL
					,COMPANY_ID				NVARCHAR(30) NULL
					,SOLDTO_CODE			NVARCHAR(10) NULL
					,SHIPTO_CODE			NVARCHAR(10) NULL
					,DOC_IDENTIFINER		NVARCHAR(35) NULL
					,MESSAGE_TYPE			NVARCHAR(6) NULL
					,UNLOADING_POINT		NVARCHAR(70) NULL
					,CUSTOMER_PLANT			NVARCHAR(8) NULL 
					,RDD_START				NVARCHAR(35) NULL
					,RDD_END				NVARCHAR(35) NULL
					,IFSEQNO				NVARCHAR(35) NULL
					,SCHEDULING_TYPE		NVARCHAR(3) NULL
					,DELFOR_TYPE			NVARCHAR(30) NULL
					,EDI_LT					INT			NULL
					,CUST_MATERIAL_CODE		NVARCHAR(35) NULL
					,CREATE_DATE			NVARCHAR(8) NULL
					,CREATE_TIME			NVARCHAR(6) NULL
					,SENDER_CODE			NVARCHAR(10) NULL
					,SENDER_NAME			NVARCHAR(200) NULL
					,CHANGE_STATUS			NVARCHAR(10) NULL
					);
					
				/* 2024.04.29    kcw3408       고객수요 N:N Mapping  */ 
				BEGIN 
					IF OBJECT_ID (N'tempdb..#TEMP_DM_CUST_MODEL_MAPPING_M', N'U') IS NOT NULL 
						DROP TABLE #TEMP_DM_CUST_MODEL_MAPPING_M
					IF OBJECT_ID(N'dbo.#TEMP_DM_CUST_MODEL_MAPPING_M', N'U') IS NOT NULL 
						DROP TABLE #TEMP_DM_CUST_MODEL_MAPPING_M

					-- [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선 START
					SELECT DISTINCT 
						   A.DIVISION_ID
						 --, A.DATA_TYPE_CODE	-- MKT_FCST(CUST_FCST)는 롤인/롤아웃 구분없이 모두 생성하므로 DATA_TYPE_CODE 구분없이 처리함.
						 , A.END_CUSTOMER, A.SCM_SITE_ID, A.PROJECT_CODE
						 , A.FCST_TYPE, A.INCOTERMS, A.DOM_EXP, A.ITEM_ID, A.MAPPING_ITEM_ID							
						 , ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)),'') AS UNLOADING_POINT, ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),'') AS CUSTOMER_PLANT	
						 , ISNULL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)),'') AS CUSTOMER_ITEM_ID 
						 , MAX(A.VALID_START_DATE) AS VALID_START_DATE, MAX(A.VALID_END_DATE) AS VALID_END_DATE
					INTO #TEMP_DM_CUST_MODEL_MAPPING_M
					FROM DM_CUST_MODEL_MAPPING_M A WITH(NOLOCK) 
					WHERE A.ACTIVE_YN = 'Y'  
					--AND A.DATA_TYPE_CODE = 'SCM'
					GROUP BY A.DIVISION_ID
						 , A.END_CUSTOMER, A.SCM_SITE_ID, A.PROJECT_CODE
						 , A.FCST_TYPE, A.INCOTERMS, A.DOM_EXP, A.ITEM_ID, A.MAPPING_ITEM_ID	 							
						 , ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)),''), ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),'')	
						 , ISNULL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)),'') 

					-- [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선 END

				END 
				
				SELECT @CNT = COUNT(*)
				FROM #TEMP_EDI_ALL

				IF (@CNT > 0)
				BEGIN

					INSERT INTO #TEMP_EDI_MKT_FCST_ALL (
						  EDI_IF_SEQ, SUB_NO, YYYYMMDD
						, DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE
						, ERP_FCST_TYPE
						, BASIS_YYYYMMDD, QTY, EDI_INCOTERMS, SALES_PLANT_SITE_ID
						, DOM_EXP
						, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE
						, DOC_IDENTIFINER, MESSAGE_TYPE
						, UNLOADING_POINT
						, CUSTOMER_PLANT 
						, RDD_START, RDD_END
						, IFSEQNO
						, SCHEDULING_TYPE
						, DELFOR_TYPE
						, EDI_LT
						, CUST_MATERIAL_CODE
						, CREATE_DATE, CREATE_TIME
						, SENDER_CODE, SENDER_NAME
						, CHANGE_STATUS
						) 
					SELECT X1.EDI_IF_SEQ, X1.SUB_NO, X1.YYYYMMDD
						, X1.DIVISION_ID, X1.SCM_SITE_ID, X1.ITEM_ID, X1.PROJECT_CODE
						, CASE WHEN X1.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END		AS ERP_FCST_TYPE
						, X1.BASIS_YYYYMMDD, X1.QTY, X1.EDI_INCOTERMS, X1.SALES_PLANT_SITE_ID
						, 'E'																AS DOM_EXP
						, X1.COMPANY_ID, X1.SOLDTO_CODE, X1.SHIPTO_CODE
						, X1.DOC_IDENTIFINER, X1.MESSAGE_TYPE
						, ISNULL(RTRIM(LTRIM(X1.UNLOADING_POINT)),'')						AS UNLOADING_POINT
						, ISNULL(RTRIM(LTRIM(X1.CUSTOMER_PLANT)),'')						AS CUSTOMER_PLANT 
						, X1.RDD_START, X1.RDD_END
						, X1.IFSEQNO
						, X1.SCHEDULING_TYPE
						, CASE WHEN (X1.MESSAGE_TYPE = 'DELFOR' AND X1.SOLDTO_CODE = 'FR000064' AND X1.RDD_START <> X1.RDD_END AND X1.RDD_START >= @v_1week_monday) THEN 'Periodic DELFOR'
  							 	ELSE ''
							END																AS DELFOR_TYPE
						, X1.EDI_LT
						, ISNULL(RTRIM(LTRIM(X1.CUST_MATERIAL_CODE)),'')					AS CUST_MATERIAL_CODE
						, X1.CREATE_DATE, X1.CREATE_TIME
						, X1.SENDER_CODE, X1.SENDER_NAME
						, X1.ATTRIBUTE10										 
					FROM DM_DNM_EDI_CALLOFF_ITEM X1 WITH (NOLOCK)
					INNER JOIN #TEMP_EDI_ALL X2 WITH (NOLOCK)
						ON	X1.IFSEQNO			= X2.IFSEQNO
						AND X1.SOLDTO_CODE		= X2.SOLDTO_CODE
						AND X1.SHIPTO_CODE		= X2.SHIPTO_CODE
						AND X1.SCHEDULING_TYPE	= X2.SCHEDULING_TYPE
						AND X1.PROJECT_CODE		= X2.PROJECT_CODE
						AND X1.SCM_SITE_ID		= X2.SCM_SITE_ID
						AND X1.ITEM_ID			= X2.ITEM_ID
						AND X1.SENDER_NAME		= X2.SENDER_NAME
						AND X1.CREATE_DATE		= X2.CREATE_DATE
						AND X1.CREATE_TIME		= X2.CREATE_TIME
						AND X1.SHIPTO_CODE		= X2.SHIPTO_CODE
					WHERE 1 = 1
					AND STATUS_CODE = 'S'
					AND CONVERT(INT, REPLACE(ISNULL(X1.QTY, '0'), ',', '')) <> 0
					AND ISNULL(EXCEPTION_FLAG,'') != 'Y'


				END

				BEGIN

					BEGIN

					/* 
					   2024.04.29    kcw3408       고객수요 N:N Mapping 
					   전체 대생 추출후 N:N Model Mapping 작업
					    .집계 시점에 Cust Item/Unloading Point/Plant 반영
						.Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음 
						. #TEMP_EDI_MKT_FCST_ALL:전체,삭제 작업
						. #TEMP_EDI_MKT_FCST: 최종 결과,insert 작업
					*/
						BEGIN 
							INSERT INTO #TEMP_EDI_MKT_FCST (
									 EDI_IF_SEQ
									,SUB_NO
									,YYYYMMDD
									,DIVISION_ID
									,SCM_SITE_ID
									,ITEM_ID
									,PROJECT_CODE
									,ERP_FCST_TYPE
									,BASIS_YYYYMMDD
									,QTY
									,EDI_INCOTERMS
									,SALES_PLANT_SITE_ID
									,DOM_EXP
									,COMPANY_ID
									,SOLDTO_CODE
									,SHIPTO_CODE
									,DOC_IDENTIFINER
									,MESSAGE_TYPE
									,UNLOADING_POINT
									,CUSTOMER_PLANT 
									,RDD_START
									,RDD_END
									,IFSEQNO
									,SCHEDULING_TYPE
									,DELFOR_TYPE
									,EDI_LT
									,CUST_MATERIAL_CODE
									,CREATE_DATE
									,SENDER_CODE
									,SENDER_NAME
									,CHANGE_STATUS
									) 
							SELECT	 
									X.EDI_IF_SEQ
								, X.SUB_NO
								, X.YYYYMMDD
								, X.DIVISION_ID
								, X.SCM_SITE_ID
								, B.ITEM_ID 
								, X.PROJECT_CODE
								, X.ERP_FCST_TYPE
								, X.BASIS_YYYYMMDD
								, X.QTY
								, X.EDI_INCOTERMS
								, X.SALES_PLANT_SITE_ID
								, X.DOM_EXP
								, X.COMPANY_ID
								, X.SOLDTO_CODE
								, X.SHIPTO_CODE
								, X.DOC_IDENTIFINER
								, X.MESSAGE_TYPE
								, ISNULL(RTRIM(LTRIM(X.UNLOADING_POINT)), '')		AS UNLOADING_POINT
								, ISNULL(RTRIM(LTRIM(X.CUSTOMER_PLANT)), '')		AS CUSTOMER_PLANT
								, X.RDD_START
								, X.RDD_END
								, X.IFSEQNO
								, X.SCHEDULING_TYPE
								, X.DELFOR_TYPE
								, X.EDI_LT
								, ISNULL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)), '')	AS CUST_MATERIAL_CODE
								, X.CREATE_DATE
								, X.SENDER_CODE
								, X.SENDER_NAME
								, X.CHANGE_STATUS
							FROM #TEMP_EDI_MKT_FCST_ALL X WITH (NOLOCK)
		                    JOIN #TEMP_DM_CUST_MODEL_MAPPING_M B WITH (NOLOCK)
								ON X.DIVISION_ID	= B.DIVISION_ID  
								AND X.SCM_SITE_ID	= B.SCM_SITE_ID 
								AND X.PROJECT_CODE	= B.PROJECT_CODE 
								AND X.ERP_FCST_TYPE = B.FCST_TYPE 
								AND X.EDI_INCOTERMS = B.INCOTERMS 
								AND X.DOM_EXP		= B.DOM_EXP 
								AND X.ITEM_ID		= B.ITEM_ID 
								AND ISNULL(RTRIM(LTRIM(X.UNLOADING_POINT)), '')		= ISNULL(RTRIM(LTRIM(B.UNLOADING_POINT)), '') 
								AND ISNULL(RTRIM(LTRIM(X.CUSTOMER_PLANT)), '')		= ISNULL(RTRIM(LTRIM(B.CUSTOMER_PLANT)), '') 
								AND ISNULL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)), '')	= ISNULL(RTRIM(LTRIM(B.CUSTOMER_ITEM_ID)), '')  
							WHERE 1 = 1
		                        AND X.BASIS_YYYYMMDD >= B.VALID_START_DATE
		                        AND X.BASIS_YYYYMMDD <= B.VALID_END_DATE
		                        AND ISNULL(B.ITEM_ID,'') > ''
							; 
						END 
					END


					BEGIN
					-------------------------------------------------------------------------------------------------------------------------------------------------------------------
					-- CUST_FCST_EDI 및 하위 MEASURE 생성 (BEGIN)
					-------------------------------------------------------------------------------------------------------------------------------------------------------------------
						DELETE
						FROM DM_PLN_MKT_FCST
							WHERE MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')	-- CUST_fcst는 제외
							AND YYYYMMDD >= @v_today 
							AND EXISTS (
											SELECT X.PROJECT_CODE
											FROM #TEMP_EDI_MKT_FCST_ALL X WITH (NOLOCK)
											WHERE	DM_PLN_MKT_FCST.DIVISION_ID		= X.DIVISION_ID
											AND		DM_PLN_MKT_FCST.DOM_EXP			= 'E'
											AND		DM_PLN_MKT_FCST.ATTRIBUTE5		= X.SENDER_NAME 
											AND		X.BASIS_YYYYMMDD				>= @v_today				--금일 20240105 @v_0week_monday -- 당주월요일이후	
										);
				
					------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
					-- 날짜 중복데이터는 SUM한 값으로 입력		==? 중복데이터가 있을수 있나?
					------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
						INSERT INTO DM_PLN_MKT_FCST (
								DIVISION_ID
							,PROJECT_CODE
							,SCM_SITE_ID
							,ITEM_ID
							,DOM_EXP
							,FCST_TYPE
							,INCOTERMS
							,MEASURE
							,PLANT_SITE_ID
							,YYYYMMDD
							,QTY
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
							,ATTRIBUTE4					-- SENDER_CODE 값 저장
							,ATTRIBUTE5					-- SENDER_NAME 값 저장
							,ATTRIBUTE6					-- IFSEQNO 값 저장
							,ATTRIBUTE7					-- LEADTIME 적용전 ORIGINAL YYYYMMDD 값 저장
							,ATTRIBUTE8					-- EDI_LT 값 저장
							,ATTRIBUTE9					-- CREATE_DATE 값 저장
							,ATTRIBUTE10				-- 소급적용여부
							)
						SELECT A.DIVISION_ID
							,A.PROJECT_CODE
							,A.SCM_SITE_ID
							,A.ITEM_ID
							,A.DOM_EXP
							,A.ERP_FCST_TYPE					AS FCST_TYPE
							,A.EDI_INCOTERMS					AS INCOTERMS
							,'CUST_FCST_EDI'					AS MEASURE
							,ISNULL(A.SALES_PLANT_SITE_ID, '')	AS PLANT_SITE_ID
							,A.BASIS_YYYYMMDD					AS YYYYMMDD
							,SUM(CAST(REPLACE(A.QTY, ',', '') AS NUMERIC))		AS QTY
							,'EDI'
							,GETDATE()
							,'EDI'
							,GETDATE()
							,MAX(A.SENDER_CODE)					AS ATTRIBUTE4	
							,MAX(A.SENDER_NAME)					AS ATTRIBUTE5	
							,MAX(A.IFSEQNO)						AS ATTRIBUTE6	
							,MAX(A.YYYYMMDD)					AS ATTRIBUTE7	
							,MAX(A.EDI_LT)						AS ATTRIBUTE8	
							,MAX(A.CREATE_DATE)					AS ATTRIBUTE9	
							,MAX(A.CHANGE_STATUS)				AS ATTRIBUTE10
						FROM #TEMP_EDI_MKT_FCST A WITH (NOLOCK)
						INNER JOIN (
									SELECT DIVISION_ID
										,PROJECT_CODE
										,SCM_SITE_ID
										,ITEM_ID
										,SCHEDULING_TYPE
										,DOM_EXP
										,ERP_FCST_TYPE
										,UNLOADING_POINT
										,CUSTOMER_PLANT 
										,EDI_INCOTERMS
										,ISNULL(SALES_PLANT_SITE_ID, '')				AS SALES_PLANT_SITE_ID
										,BASIS_YYYYMMDD
										,CREATE_DATE
									FROM #TEMP_EDI_MKT_FCST WITH (NOLOCK)
									WHERE BASIS_YYYYMMDD >= @v_today --금일 20240105 
									GROUP BY DIVISION_ID
										,PROJECT_CODE
										,SCM_SITE_ID
										,ITEM_ID
										,SCHEDULING_TYPE
										,DOM_EXP
										,ERP_FCST_TYPE
										,UNLOADING_POINT
										,CUSTOMER_PLANT 
										,EDI_INCOTERMS
										,ISNULL(SALES_PLANT_SITE_ID, '')
										,BASIS_YYYYMMDD
										,CREATE_DATE
									) B 
						ON A.DIVISION_ID = B.DIVISION_ID
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.ITEM_ID = B.ITEM_ID
						AND A.SCHEDULING_TYPE = B.SCHEDULING_TYPE 
						AND A.DOM_EXP = B.DOM_EXP
						AND A.ERP_FCST_TYPE = B.ERP_FCST_TYPE
						AND A.UNLOADING_POINT = B.UNLOADING_POINT
						AND A.CUSTOMER_PLANT = B.CUSTOMER_PLANT 
						AND A.EDI_INCOTERMS = B.EDI_INCOTERMS
						AND ISNULL(A.SALES_PLANT_SITE_ID, '') = ISNULL(B.SALES_PLANT_SITE_ID, '')
						AND A.CREATE_DATE = B.CREATE_DATE
						AND A.BASIS_YYYYMMDD = B.BASIS_YYYYMMDD
						WHERE 1 = 1
						GROUP BY A.DIVISION_ID
							,A.PROJECT_CODE
							,A.SCM_SITE_ID
							,A.ITEM_ID
							,A.DOM_EXP
							,A.ERP_FCST_TYPE
							,A.EDI_INCOTERMS
							,ISNULL(A.SALES_PLANT_SITE_ID, '')
							,A.BASIS_YYYYMMDD
					END

					------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
					-- MEASURE별 SUM한 값으로 생성
					------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
					BEGIN
						INSERT INTO DM_PLN_MKT_FCST (
							DIVISION_ID
							,PROJECT_CODE
							,SCM_SITE_ID
							,ITEM_ID
							,DOM_EXP
							,FCST_TYPE
							,INCOTERMS
							,MEASURE
							,PLANT_SITE_ID
							,YYYYMMDD
							,QTY
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
							,ATTRIBUTE4 -- SENDER_CODE 값 저장
							,ATTRIBUTE5 -- SENDER_NAME 값 저장
							,ATTRIBUTE6 -- IFSEQNO 값 저장
							,ATTRIBUTE7 -- LEADTIME 적용전 ORIGINAL YYYYMMDD 값 저장
							,ATTRIBUTE8 -- EDI_LT 값 저장
							,ATTRIBUTE9 -- CREATE_DATE 값 저장
							,ATTRIBUTE10 -- 소급적용여부
							)
						SELECT A.DIVISION_ID
							,A.PROJECT_CODE
							,A.SCM_SITE_ID
							,A.ITEM_ID
							,A.DOM_EXP
							,A.ERP_FCST_TYPE
							,A.EDI_INCOTERMS
							,CASE WHEN A.SCHEDULING_TYPE = '4'		THEN 'Planning_Forecast'
								  WHEN A.SCHEDULING_TYPE = '10'		THEN 'Immidiate'
								  WHEN A.SCHEDULING_TYPE = '24'		THEN 'Commercial_Agreement'
								  WHEN A.SCHEDULING_TYPE = '1'		THEN 'Firm_Temp'
								  WHEN A.SCHEDULING_TYPE = '2'		THEN 'Manumacturing_Material_Temp'
								  WHEN A.SCHEDULING_TYPE = '3'		THEN 'Material_Temp'
								  WHEN A.SCHEDULING_TYPE = '83'		THEN 'Backorder'
							  END															AS MEASURE
							,ISNULL(A.SALES_PLANT_SITE_ID, '')								AS PLANT_SITE_ID
							,A.BASIS_YYYYMMDD
							,SUM(CAST(REPLACE(A.QTY, ',', '') AS NUMERIC))						
							,'EDI'
							,GETDATE()
							,'EDI'
							,GETDATE()
							,MAX(A.SENDER_CODE)											AS ATTRIBUTE4	
							,MAX(A.SENDER_NAME)											AS ATTRIBUTE5	
							,MAX(A.IFSEQNO)												AS ATTRIBUTE6	
							,MAX(A.YYYYMMDD)											AS ATTRIBUTE7	
							,MAX(A.EDI_LT)												AS ATTRIBUTE8	
							,MAX(A.CREATE_DATE)											AS ATTRIBUTE9	
							,MAX(A.CHANGE_STATUS)										AS ATTRIBUTE10
						FROM #TEMP_EDI_MKT_FCST A WITH (NOLOCK)
						INNER JOIN (
										SELECT DIVISION_ID
											,PROJECT_CODE
											,SCM_SITE_ID
											,ITEM_ID
											,SCHEDULING_TYPE
											,DOM_EXP
											,ERP_FCST_TYPE
											,UNLOADING_POINT
											,CUSTOMER_PLANT 
											,EDI_INCOTERMS
											,ISNULL(SALES_PLANT_SITE_ID, '') AS SALES_PLANT_SITE_ID
											,BASIS_YYYYMMDD
											,CREATE_DATE
										FROM #TEMP_EDI_MKT_FCST WITH (NOLOCK)
										WHERE BASIS_YYYYMMDD >= @v_today --금일 20240105 
										GROUP BY DIVISION_ID
											,PROJECT_CODE
											,SCM_SITE_ID
											,ITEM_ID
											,SCHEDULING_TYPE
											,DOM_EXP
											,ERP_FCST_TYPE
											,UNLOADING_POINT
											,CUSTOMER_PLANT 
											,EDI_INCOTERMS
											,ISNULL(SALES_PLANT_SITE_ID, '')
											,BASIS_YYYYMMDD
											,CREATE_DATE
							) B 
							ON A.DIVISION_ID		= B.DIVISION_ID
							AND A.PROJECT_CODE		= B.PROJECT_CODE
							AND A.SCM_SITE_ID		= B.SCM_SITE_ID
							AND A.ITEM_ID			= B.ITEM_ID
							AND A.SCHEDULING_TYPE	= B.SCHEDULING_TYPE 
							AND A.DOM_EXP			= B.DOM_EXP
							AND A.ERP_FCST_TYPE		= B.ERP_FCST_TYPE
							AND A.UNLOADING_POINT	= B.UNLOADING_POINT
							AND A.CUSTOMER_PLANT	= B.CUSTOMER_PLANT 
							AND A.EDI_INCOTERMS		= B.EDI_INCOTERMS
							AND ISNULL(A.SALES_PLANT_SITE_ID, '') = ISNULL(B.SALES_PLANT_SITE_ID, '')
							AND A.CREATE_DATE		= B.CREATE_DATE
							AND A.BASIS_YYYYMMDD	= B.BASIS_YYYYMMDD
						WHERE 1 = 1						
						GROUP BY A.DIVISION_ID
							,A.PROJECT_CODE
							,A.SCM_SITE_ID
							,A.ITEM_ID
							,A.DOM_EXP
							,A.ERP_FCST_TYPE
							,A.EDI_INCOTERMS
							,A.SCHEDULING_TYPE
							,ISNULL(A.SALES_PLANT_SITE_ID, '')
							,A.BASIS_YYYYMMDD
					END

					-------------------------------------------------------------------------------------------------------------------------------------------------------------------
					-- CUST_FCST_EDI 및 하위 MEASURE 생성 (END)
					-------------------------------------------------------------------------------------------------------------------------------------------------------------------
					----------------------------------------------------------------------------------------
					-- [E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 START
					----------------------------------------------------------------------------------------
					--프로시져를 호출하여, CUST_FCST 메져 데이터를 생성한다 

					CREATE TABLE #TEMP_CUST_FCST_DIVISION 
					(	  DIVISION_ID		NVARCHAR(30)
						, SEQ				INT			IDENTITY(0,1)
					)
			
					INSERT INTO #TEMP_CUST_FCST_DIVISION (DIVISION_ID)
					SELECT DISTINCT DIVISION_ID
					FROM #TEMP_EDI_MKT_FCST

					DECLARE @CUST_FCST_I INT, @CUST_FCST_CNT INT, @V_CUST_FCST_DIVISION NVARCHAR(30)	

					SELECT @CUST_FCST_I				= 0
					, @CUST_FCST_CNT				= MAX(SEQ)				
					, @V_CUST_FCST_DIVISION			= NULL
					FROM #TEMP_CUST_FCST_DIVISION

					BEGIN
					WHILE @CUST_FCST_I <= @CUST_FCST_CNT 
						BEGIN	
							SELECT @V_CUST_FCST_DIVISION = DIVISION_ID
							FROM #TEMP_CUST_FCST_DIVISION
							WHERE SEQ = @CUST_FCST_I
													   
							-- DIVISION 단위로 생성 (CUST_FCST = CUST_FCST_EDI + RPA + EXCEL)
							EXEC PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST @V_CUST_FCST_DIVISION	--> 81, 81_UC
							SET @CUST_FCST_I += 1
						END
					END	
					-------------------------------------------------------------------------------------------------------------------------------------------------------------------
					-- History 기능 추가 (BEGIN)
					-------------------------------------------------------------------------------------------------------------------------------------------------------------------
					BEGIN
						--PRINT('HISTORY : ' + convert(nvarchar(30), getdate(), 121))
						INSERT INTO DM_PLN_MKT_FCST_H (
							DIVISION_ID
							,HISTORY_SEQ
							,PROJECT_CODE
							,SCM_SITE_ID
							,ITEM_ID
							,DOM_EXP
							,FCST_TYPE
							,INCOTERMS
							,MEASURE
							,PLANT_SITE_ID
							,YYYYMMDD
							,QTY
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
							,ATTRIBUTE1
							,ATTRIBUTE2
							,ATTRIBUTE3
							,ATTRIBUTE4
							,ATTRIBUTE5
							,ATTRIBUTE6
							,ATTRIBUTE7
							,ATTRIBUTE8
							,ATTRIBUTE9
							,ATTRIBUTE10
							)
						SELECT B.DIVISION_ID
							,NEXT VALUE	FOR SEQ1_DM_PLN_MKT_FCST_H -- History Seqno
							,B.PROJECT_CODE
							,B.SCM_SITE_ID
							,B.ITEM_ID
							,B.DOM_EXP
							,FCST_TYPE
							,INCOTERMS
							,MEASURE
							,PLANT_SITE_ID
							,B.BASIS_YYYYMMDD
							,CAST(REPLACE(B.QTY, ',', '') AS NUMERIC)
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
							,ATTRIBUTE1
							,ATTRIBUTE2
							,ATTRIBUTE3
							,ATTRIBUTE4
							,ATTRIBUTE5
							,ATTRIBUTE6
							,ATTRIBUTE7
							,ATTRIBUTE8
							,ATTRIBUTE9
							,ATTRIBUTE10
						FROM DM_PLN_MKT_FCST A WITH (NOLOCK)
						INNER JOIN #TEMP_EDI_MKT_FCST B WITH (NOLOCK) 
							ON A.DIVISION_ID	= B.DIVISION_ID
							AND A.PROJECT_CODE = B.PROJECT_CODE
							AND A.SCM_SITE_ID	= B.SCM_SITE_ID
							AND A.ITEM_ID		= B.ITEM_ID
							AND A.MEASURE		= CASE  WHEN B.SCHEDULING_TYPE = '4'		THEN 'Planning_Forecast'
														WHEN B.SCHEDULING_TYPE = '10'		THEN 'Immidiate'
														WHEN B.SCHEDULING_TYPE = '24'		THEN 'Commercial_Agreement'
														WHEN B.SCHEDULING_TYPE = '1'		THEN 'Firm_Temp'
														WHEN B.SCHEDULING_TYPE = '2'		THEN 'Manumacturing_Material_Temp'
														WHEN B.SCHEDULING_TYPE = '3'		THEN 'Material_Temp'
														WHEN B.SCHEDULING_TYPE = '83'		THEN 'Backorder'
												   END
							AND A.PLANT_SITE_ID = B.SALES_PLANT_SITE_ID
							AND A.YYYYMMDD = B.BASIS_YYYYMMDD
						INNER JOIN (
									SELECT DIVISION_ID
										,PROJECT_CODE
										,SCM_SITE_ID
										,ITEM_ID
										,DOM_EXP
										,ERP_FCST_TYPE
										,UNLOADING_POINT
										,CUSTOMER_PLANT --추가 20231128 YU
										,EDI_INCOTERMS
										,ISNULL(SALES_PLANT_SITE_ID, '') AS SALES_PLANT_SITE_ID
										,BASIS_YYYYMMDD
										,CREATE_DATE
									FROM #TEMP_EDI_MKT_FCST WITH (NOLOCK)
									WHERE BASIS_YYYYMMDD >= @v_today --금일 20240105 @v_0week_monday
									GROUP BY DIVISION_ID
										,PROJECT_CODE
										,SCM_SITE_ID
										,ITEM_ID
										,DOM_EXP
										,ERP_FCST_TYPE
										,UNLOADING_POINT
										,CUSTOMER_PLANT 
										,EDI_INCOTERMS
										,ISNULL(SALES_PLANT_SITE_ID, '')
										,BASIS_YYYYMMDD
										,CREATE_DATE
									) C 
							ON A.DIVISION_ID	= C.DIVISION_ID
							AND B.PROJECT_CODE	= C.PROJECT_CODE
							AND B.SCM_SITE_ID	= C.SCM_SITE_ID
							AND B.ITEM_ID		= C.ITEM_ID
							AND B.DOM_EXP		= C.DOM_EXP
							AND B.ERP_FCST_TYPE = C.ERP_FCST_TYPE
							AND B.UNLOADING_POINT	= C.UNLOADING_POINT
							AND B.CUSTOMER_PLANT	= C.CUSTOMER_PLANT 
							AND B.EDI_INCOTERMS		= C.EDI_INCOTERMS
							AND ISNULL(B.SALES_PLANT_SITE_ID, '') = ISNULL(C.SALES_PLANT_SITE_ID, '')
							AND B.CREATE_DATE		= C.CREATE_DATE
							AND B.BASIS_YYYYMMDD	= C.BASIS_YYYYMMDD
						WHERE 1 = 1
							AND A.YYYYMMDD >= @v_today --금일 20240105 @v_0week_monday -- W1월요일이후
							AND A.MEASURE IN (
								 'CUST_FCST_EDI'
								,'Immidiate'
								,'Planning_Forecast'
								,'Commercial_Agreement'
								,'Firm_Temp'
								,'Manumacturing_Material_Temp'
								,'Material_Temp'
								,'Backorder'
								)
					END
					-------------------------------------------------------------------------------------------------------------------------------------------------------------------
					-- History 기능 추가 (END)
					-------------------------------------------------------------------------------------------------------------------------------------------------------------------
				
				END 

			END   

		END    

		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇		
		-- ◇◇◇◇◇                                  CUST_FCST_EDI[Org.] START
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		BEGIN
			-- 테이블중복제거
			IF OBJECT_ID(N'tempdb..#TEMP_EDI_END_CUSTOMER_ORG', N'U') IS NOT NULL
				DROP TABLE #TEMP_EDI_END_CUSTOMER_ORG

			-- 임시확인용테이블 중복제거
			IF OBJECT_ID(N'dbo.#TEMP_EDI_END_CUSTOMER_ORG', N'U') IS NOT NULL
				DROP TABLE #TEMP_EDI_END_CUSTOMER_ORG

			--#TEMP_EDI_END_CUSTOMER	
			CREATE TABLE #TEMP_EDI_END_CUSTOMER_ORG (
				  DIVISION_ID		NVARCHAR(10) NULL
				, END_CUSTOMER		NVARCHAR(100) NULL
				, SCM_SITE_ID		NVARCHAR(60) NULL
				, FROM_WEEK			NVARCHAR(30) NULL
				, FROM_DAY			NVARCHAR(30) NULL
				, TO_WEEK			NVARCHAR(30) NULL
				, TO_DAY			NVARCHAR(30) NULL
				, ACTIVE			NVARCHAR(30) NULL
				);

			--EDI END_CUSTOMER별 기간 설정
			BEGIN
				--EDI_END_CUSTOMER_ORG Lookup의 Active = 'Off'이면 CREATE_DATE -52주부터, 'On'이면 Lookup 기간 사용
				--ORG Lookup의 Active가 'On'이면 Lookup기간중 EDI 데이터 미수신시 수량 0으로 변경
				INSERT INTO #TEMP_EDI_END_CUSTOMER_ORG (
					 DIVISION_ID
					,END_CUSTOMER
					,SCM_SITE_ID
					,FROM_WEEK
					,FROM_DAY
					,TO_WEEK
					,TO_DAY
					,ACTIVE
					)
				SELECT A.DIVISION_ID				AS DIVISION_ID
					,A.END_CUSTOMER					AS END_CUSTOMER
					,ISNULL(B.SEGMENT4, '-')		AS SCM_SITE_ID
					,CASE WHEN ISNULL(B.SEGMENT5, 'On') = 'On'	THEN ISNULL(B.ATTRIBUTE1, '-1')
						  ELSE '-52'
					 END							AS FROM_WEEK
					,ISNULL(B.ATTRIBUTE2, 'TUE')	AS FROM_DAY
					,ISNULL(B.ATTRIBUTE3, '0')		AS TO_WEEK
					,ISNULL(B.ATTRIBUTE4, 'MON')	AS TO_DAY
					,ISNULL(B.SEGMENT5, 'On')		AS ACTIVE
				FROM SCM_MST_SITE A WITH (NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH (NOLOCK) 
					ON B.LOOKUP_TYPE		= 'EDI_END_CUSTOMER_ORG'
					AND A.DIVISION_ID		= B.SEGMENT1
					AND A.END_CUSTOMER		= B.SEGMENT2
					AND B.VALID_YN			= 'Y'
				WHERE ISNULL(A.END_CUSTOMER, '') <> ''
				GROUP BY A.DIVISION_ID
					,A.END_CUSTOMER
					,B.SEGMENT4
					,B.ATTRIBUTE1
					,B.ATTRIBUTE2
					,B.ATTRIBUTE3
					,B.ATTRIBUTE4
					,B.SEGMENT5
			END

			BEGIN
				-- 테이블중복제거
				IF OBJECT_ID(N'tempdb..#TEMP_EDI_ORG_ALL', N'U') IS NOT NULL
					DROP TABLE #TEMP_EDI_ORG_ALL

				-- 임시확인용테이블 중복제거
				IF OBJECT_ID(N'dbo.#TEMP_EDI_ORG_ALL', N'U') IS NOT NULL
					DROP TABLE #TEMP_EDI_ORG_ALL

				--#TEMP_EDI_NEW_ALL	
				CREATE TABLE #TEMP_EDI_ORG_ALL (
					 NUM				INT NULL
					,DIVISION_ID		NVARCHAR(10) NULL 
					,IFSEQNO			NVARCHAR(30) NULL
					,SOLDTO_CODE		NVARCHAR(10) NULL
					,SHIPTO_CODE		NVARCHAR(10) NULL
					,UNLOADING_POINT	NVARCHAR(35) NULL
					,CUSTOMER_PLANT		NVARCHAR(8) NULL 
					,SCHEDULING_TYPE	NVARCHAR(6) NULL
					,PROJECT_CODE		NVARCHAR(100) NULL
					,SCM_SITE_ID		NVARCHAR(100) NULL
					,CUST_MATERIAL_CODE NVARCHAR(70) NULL
					,ITEM_ID			NVARCHAR(100) NULL
					,ERP_FCST_TYPE		NVARCHAR(10) NULL 
					,CREATE_DATE		NVARCHAR(16) NULL
					,CREATE_TIME		NVARCHAR(10) NULL
					,MESSAGE_TYPE		NVARCHAR(12) NULL 
					,END_CUSTOMER		NVARCHAR(35) NULL
					,SENDER_NAME		NVARCHAR(200) NULL
					,YYYYMMDD			NVARCHAR(10) NULL
					);

				--EDI STATUS_CODE가 SUCCESS인 DATA
				BEGIN
					--SOLDTO_CODE, SHIPTO_CODE, UNLOADING_POINT, ITEM_ID, SCHEDULING 기준으로 DATA 추출
					INSERT INTO #TEMP_EDI_ORG_ALL (
						 NUM
						,DIVISION_ID 
						,IFSEQNO
						,SOLDTO_CODE
						,SHIPTO_CODE
						,UNLOADING_POINT
						,CUSTOMER_PLANT 
						,SCHEDULING_TYPE
						,PROJECT_CODE
						,SCM_SITE_ID
						,ITEM_ID
						,ERP_FCST_TYPE 
						,CREATE_DATE
						,CREATE_TIME
						,MESSAGE_TYPE 
						,END_CUSTOMER
						,SENDER_NAME
						,YYYYMMDD
						)
					SELECT ROW_NUMBER() OVER (ORDER BY A.IFSEQNO ) AS NUM
						,A.DIVISION_ID 
						,A.IFSEQNO
						,A.SOLDTO_CODE
						,A.SHIPTO_CODE
						,A.UNLOADING_POINT
						,A.CUSTOMER_PLANT 
						,A.SCHEDULING_TYPE
						,A.PROJECT_CODE
						,A.SCM_SITE_ID
						,A.ITEM_ID
						,A.ERP_FCST_TYPE 
						,A.CREATE_DATE
						,A.CREATE_TIME
						,A.MESSAGE_TYPE 
						,A.END_CUSTOMER
						,A.SENDER_NAME
						,A.YYYYMMDD
					FROM (
							SELECT ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID ,A.SCHEDULING_TYPE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID 
																,  CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END 					
																   ORDER BY A.CREATE_DATE DESC, A.IFSEQNO DESC 
													)		AS RNK
								, A.DIVISION_ID 
								, A.IFSEQNO
								, A.SOLDTO_CODE
								, A.SHIPTO_CODE
								, A.UNLOADING_POINT
								, A.CUSTOMER_PLANT 
								, A.SCHEDULING_TYPE
								, A.PROJECT_CODE
								, A.SCM_SITE_ID
								, A.ITEM_ID
								, CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS'				END AS ERP_FCST_TYPE 
								, A.CREATE_DATE
								, A.CREATE_TIME
								, A.MESSAGE_TYPE 
								, B.END_CUSTOMER
								, A.SENDER_NAME
								, A.YYYYMMDD
							FROM DM_DNM_EDI_CALLOFF_ITEM A WITH (NOLOCK)
							LEFT OUTER JOIN SCM_MST_SITE B WITH (NOLOCK) 
								ON A.DIVISION_ID = B.DIVISION_ID
								AND A.SCM_SITE_ID = B.SCM_SITE_ID
								AND B.SITE_TYPE = 'SALES'
								AND B.VALID_YN = 'Y'
								AND ISNULL(REPLACE(B.END_CUSTOMER, '-', ''), '') <> ''
							LEFT OUTER JOIN #TEMP_EDI_END_CUSTOMER_ORG C WITH (NOLOCK) 
								ON A.DIVISION_ID = C.DIVISION_ID
								AND C.END_CUSTOMER = B.END_CUSTOMER
								AND C.SCM_SITE_ID = ISNULL((
																SELECT SCM_SITE_ID
																FROM #TEMP_EDI_END_CUSTOMER_ORG WITH (NOLOCK)
																WHERE DIVISION_ID = A.DIVISION_ID
																AND END_CUSTOMER = B.END_CUSTOMER
																AND SCM_SITE_ID = A.SCM_SITE_ID
															), '-')
							WHERE 1 = 1
							AND A.CREATE_DATE >= @v_FROM_YYYYMMDD
							AND A.YYYYMMDD >= @v_today					-- 당일 이후
/*
							AND A.CREATE_DATE >= (
													SELECT BASIS_YYYYMMDD
													FROM (
															SELECT RANK() OVER (ORDER BY BASIS_YYYYMMDD DESC) * - 1 AS RK, DT.BASIS_YYYYMMDD 
															FROM SCM_SYS_CALENDAR_M DT WITH (NOLOCK)
															WHERE BASIS_YYYYMMDD <=  (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN CONVERT(NVARCHAR, DATEADD(DD, - 1, GETDATE()), 112)
																						   WHEN DATEPART(WEEKDAY, GETDATE()) = '3' THEN (CASE WHEN @v_HOUR < '05' THEN CONVERT(NVARCHAR, DATEADD(DD, - 2, GETDATE()), 112)
																																			  ELSE CONVERT(NVARCHAR, GETDATE(), 112)
																																		  END)
																					  ELSE CONVERT(NVARCHAR, GETDATE(), 112)
																					  END
																					 )
																AND DAYOFWEEK = C.FROM_DAY
															) D
													WHERE D.RK = C.FROM_WEEK
												)
							AND A.CREATE_DATE <= (
													SELECT BASIS_YYYYMMDD
													FROM (
															SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER (ORDER BY BASIS_YYYYMMDD) - 2   
																		 ELSE RANK() OVER (ORDER BY BASIS_YYYYMMDD) - 1
																	 END) AS RK, DT.BASIS_YYYYMMDD 
															FROM SCM_SYS_CALENDAR_M DT WITH (NOLOCK)
															WHERE BASIS_YYYYMMDD >=  (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN CONVERT(NVARCHAR, DATEADD(DD, - 1, GETDATE()), 112)
																						   WHEN DATEPART(WEEKDAY, GETDATE()) = '3' THEN (CASE WHEN @v_HOUR < '05' THEN CONVERT(NVARCHAR, DATEADD(DD, - 2, GETDATE()), 112)
																																			   ELSE CONVERT(NVARCHAR, GETDATE(), 112)
																																		 END
																																		)
																					  ELSE CONVERT(NVARCHAR, GETDATE(), 112)
																					  END)
															AND DAYOFWEEK = C.TO_DAY
														) D 
													WHERE D.RK = C.TO_WEEK
												 )
*/
							AND A.STATUS_CODE = 'S'
							AND EXISTS
										(
											SELECT * 
											FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK) 
											WHERE LUP.LOOKUP_TYPE	= 'DM_EDI_CALLOFF_MKT_FCST_END_CUSTOMER'	
											AND LUP.SEGMENT1		= A.DIVISION_ID
											AND LUP.SEGMENT2		= A.SENDER_NAME
											AND LUP.SEGMENT3		= B.END_CUSTOMER
											AND LUP.SEGMENT4		= A.SCHEDULING_TYPE
											AND A.MESSAGE_TYPE		= 
--																		CASE WHEN LEN(LUP.SEGMENT5) = 6 THEN LUP.SEGMENT5 
																		CASE WHEN LUP.SEGMENT5 IN ('DELJIT','DELFOR') THEN LUP.SEGMENT5		-- DELJIT / DELFOR로 정의되어 있으면. 정의된 데이터만 추출함.
																			 ELSE (CASE WHEN A.YYYYMMDD <= @v_YYYYMMDD THEN 'DELJIT' ELSE 'DELFOR'	END) 
																		END
											AND LUP.VALID_YN = 'Y'
											AND ((LEN(LUP.ATTRIBUTE2) < 8 AND LEN(LUP.ATTRIBUTE3) < 8) OR (A.YYYYMMDD BETWEEN LUP.ATTRIBUTE1 AND LUP.ATTRIBUTE2))
										)
							GROUP BY A.DIVISION_ID 
								,A.IFSEQNO
								,A.SOLDTO_CODE
								,A.SHIPTO_CODE
								,A.UNLOADING_POINT
								,A.CUSTOMER_PLANT 
								,A.SCHEDULING_TYPE
								,A.PROJECT_CODE
								,A.SCM_SITE_ID
								,A.ITEM_ID
								,CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END 
								,A.CREATE_DATE
								,A.CREATE_TIME
								,A.MESSAGE_TYPE 
								,B.END_CUSTOMER
								,A.SENDER_NAME
								,A.YYYYMMDD

						) A
					WHERE RNK = 1
					AND   LEN(A.YYYYMMDD) = 8				-- 강현준 추가 ('444444' 가 추가되어 있음
					ORDER BY A.IFSEQNO;
				END

				-- 테이블중복제거
				IF OBJECT_ID(N'tempdb..#TEMP_EDI_MKT_FCST_ORG', N'U') IS NOT NULL
					DROP TABLE #TEMP_EDI_MKT_FCST_ORG

				-- 임시확인용테이블 중복제거
				IF OBJECT_ID(N'dbo.#TEMP_EDI_MKT_FCST_ORG', N'U') IS NOT NULL
					DROP TABLE #TEMP_EDI_MKT_FCST_ORG

				--#TEMP_EDI_MKT_FCST	
				CREATE TABLE #TEMP_EDI_MKT_FCST_ORG (
					 EDI_IF_SEQ			NVARCHAR(35) NULL
					,SUB_NO				SMALLINT NULL
					,YYYYMMDD			NVARCHAR(8) NULL
					,DIVISION_ID		NVARCHAR(30) NULL
					,SCM_SITE_ID		NVARCHAR(50) NULL
					,ITEM_ID			NVARCHAR(50) NULL
					,PROJECT_CODE		NVARCHAR(50) NULL
					,ERP_FCST_TYPE		NVARCHAR(10) NULL
					,BASIS_YYYYMMDD		NVARCHAR(8) NULL
					,QTY				NVARCHAR(35) NULL
					,EDI_INCOTERMS		NVARCHAR(50) NULL
					,SALES_PLANT_SITE_ID NVARCHAR(50) NULL
					,DOM_EXP			NVARCHAR(10) NULL
					,COMPANY_ID			NVARCHAR(30) NULL
					,SOLDTO_CODE		NVARCHAR(10) NULL
					,SHIPTO_CODE		NVARCHAR(10) NULL
					,DOC_IDENTIFINER	NVARCHAR(35) NULL
					,MESSAGE_TYPE		NVARCHAR(6) NULL
					,UNLOADING_POINT	NVARCHAR(70) NULL
					,CUSTOMER_PLANT		NVARCHAR(8) NULL 
					,RDD_START			NVARCHAR(35) NULL
					,RDD_END			NVARCHAR(35) NULL
					,IFSEQNO			NVARCHAR(35) NULL
					,SCHEDULING_TYPE	NVARCHAR(3) NULL
					,DELFOR_TYPE		NVARCHAR(30) NULL
					,EDI_LT				INT NULL
					,CUST_MATERIAL_CODE NVARCHAR(35) NULL
					,CREATE_DATE		NVARCHAR(8) NULL
					,SENDER_CODE		NVARCHAR(10) NULL
					,SENDER_NAME		NVARCHAR(200) NULL
					,CHANGE_STATUS		NVARCHAR(10) NULL
					);
					
				/* 기존 로직: 전체 대상 추출 ,삭제를 위한 자료 추출(고객수요 N:N Mapping 적용전 전체) */
				-- 테이블중복제거
				IF OBJECT_ID(N'tempdb..#TEMP_EDI_MKT_FCST_ORG_ALL', N'U') IS NOT NULL
					DROP TABLE #TEMP_EDI_MKT_FCST_ORG_ALL

				-- 임시확인용테이블 중복제거
				IF OBJECT_ID(N'dbo.#TEMP_EDI_MKT_FCST_ORG_ALL', N'U') IS NOT NULL
					DROP TABLE #TEMP_EDI_MKT_FCST_ORG_ALL

				--#TEMP_EDI_MKT_FCST_ALL	
				CREATE TABLE #TEMP_EDI_MKT_FCST_ORG_ALL (
					 EDI_IF_SEQ			NVARCHAR(35) NULL
					,SUB_NO				SMALLINT NULL
					,YYYYMMDD			NVARCHAR(8) NULL
					,DIVISION_ID		NVARCHAR(30) NULL
					,SCM_SITE_ID		NVARCHAR(50) NULL
					,ITEM_ID			NVARCHAR(50) NULL
					,PROJECT_CODE		NVARCHAR(50) NULL
					,ERP_FCST_TYPE		NVARCHAR(10) NULL
					,BASIS_YYYYMMDD		NVARCHAR(8) NULL
					,QTY				NVARCHAR(35) NULL
					,EDI_INCOTERMS		NVARCHAR(50) NULL
					,SALES_PLANT_SITE_ID NVARCHAR(50) NULL
					,DOM_EXP			NVARCHAR(10) NULL
					,COMPANY_ID			NVARCHAR(30) NULL
					,SOLDTO_CODE		NVARCHAR(10) NULL
					,SHIPTO_CODE		NVARCHAR(10) NULL
					,DOC_IDENTIFINER	NVARCHAR(35) NULL
					,MESSAGE_TYPE		 NVARCHAR(6) NULL
					,UNLOADING_POINT	NVARCHAR(70) NULL
					,CUSTOMER_PLANT		NVARCHAR(8) NULL 
					,RDD_START			NVARCHAR(35) NULL
					,RDD_END			NVARCHAR(35) NULL
					,IFSEQNO			NVARCHAR(35) NULL
					,SCHEDULING_TYPE	NVARCHAR(3) NULL
					,DELFOR_TYPE		NVARCHAR(30) NULL
					,EDI_LT				INT NULL
					,CUST_MATERIAL_CODE NVARCHAR(35) NULL
					,CREATE_DATE		NVARCHAR(8) NULL
					,CREATE_TIME		NVARCHAR(8) NULL
					,SENDER_CODE		NVARCHAR(10) NULL
					,SENDER_NAME		NVARCHAR(200) NULL
					,CHANGE_STATUS		NVARCHAR(10) NULL
					);
					
				SELECT @CNT_ORG = COUNT(*)
				FROM #TEMP_EDI_ORG_ALL

				IF @CNT_ORG > 0
				BEGIN				 
					
					INSERT INTO #TEMP_EDI_MKT_FCST_ORG_ALL (
						  EDI_IF_SEQ, SUB_NO, YYYYMMDD
						, DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE
						, ERP_FCST_TYPE
						, BASIS_YYYYMMDD, QTY, EDI_INCOTERMS, SALES_PLANT_SITE_ID
						, DOM_EXP
						, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE
						, DOC_IDENTIFINER, MESSAGE_TYPE
						, UNLOADING_POINT
						, CUSTOMER_PLANT 
						, RDD_START, RDD_END
						, IFSEQNO
						, SCHEDULING_TYPE
						, DELFOR_TYPE
						, EDI_LT
						, CUST_MATERIAL_CODE
						, CREATE_DATE
						, CREATE_TIME
						, SENDER_CODE
						, SENDER_NAME
						, CHANGE_STATUS
						)
					SELECT X1.EDI_IF_SEQ, X1.SUB_NO, X1.YYYYMMDD
						 , X1.DIVISION_ID, X1.SCM_SITE_ID, X1.ITEM_ID, X1.PROJECT_CODE
						 , CASE WHEN X1.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END				AS ERP_FCST_TYPE
						 , X1.BASIS_YYYYMMDD, X1.QTY, X1.EDI_INCOTERMS, X1.SALES_PLANT_SITE_ID
						 , 'E'				AS DOM_EXP
						 , X1.COMPANY_ID, X1.SOLDTO_CODE, X1.SHIPTO_CODE
						 , X1.DOC_IDENTIFINER, X1.MESSAGE_TYPE
						 , ISNULL(RTRIM(LTRIM(X1.UNLOADING_POINT)),'')								AS UNLOADING_POINT
						 , ISNULL(RTRIM(LTRIM(X1.CUSTOMER_PLANT)),'')								AS CUSTOMER_PLANT 
						 , X1.RDD_START, X1.RDD_END
						 , X1.IFSEQNO
						 , X1.SCHEDULING_TYPE
						 , CASE WHEN (X1.MESSAGE_TYPE = 'DELFOR' AND X1.SOLDTO_CODE = 'FR000064' AND X1.RDD_START <> X1.RDD_END AND X1.RDD_START >= @v_1week_monday) THEN 'Periodic DELFOR'
						  		ELSE ''
						  	END													AS DELFOR_TYPE
						 , X1.EDI_LT
						 , ISNULL(RTRIM(LTRIM(X1.CUST_MATERIAL_CODE)),'')		AS CUST_MATERIAL_CODE
						 , X1.CREATE_DATE
						 , X1.CREATE_TIME
						 , X1.SENDER_CODE
						 , X1.SENDER_NAME
						 , X1.ATTRIBUTE10 
					FROM DM_DNM_EDI_CALLOFF_ITEM X1 WITH (NOLOCK)
					INNER JOIN #TEMP_EDI_ORG_ALL X2 WITH (NOLOCK)
						ON	X1.IFSEQNO			= X2.IFSEQNO
						AND X1.SOLDTO_CODE		= X2.SOLDTO_CODE
						AND X1.SHIPTO_CODE		= X2.SHIPTO_CODE
						AND X1.SCHEDULING_TYPE	= X2.SCHEDULING_TYPE
						AND X1.PROJECT_CODE		= X2.PROJECT_CODE
						AND X1.SCM_SITE_ID		= X2.SCM_SITE_ID
						AND X1.ITEM_ID			= X2.ITEM_ID
						AND X1.SENDER_NAME		= X2.SENDER_NAME
						AND X1.CREATE_DATE		= X2.CREATE_DATE
						AND X1.CREATE_TIME		= X2.CREATE_TIME
						AND X1.SHIPTO_CODE		= X2.SHIPTO_CODE
					WHERE 1 = 1
					AND X1.STATUS_CODE = 'S'
					AND CONVERT(INT, REPLACE(ISNULL(X1.QTY, '0'), ',', '')) <> 0
					AND ISNULL(EXCEPTION_FLAG,'') != 'Y'

							
					/* 
					   2024.04.29    kcw3408       고객수요 N:N Mapping 
					   전체 대생 추출후 N:N Model Mapping 작업
					    .집계 시점에 Cust Item/Unloading Point/Plant 반영
						.Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음 
						. #TEMP_EDI_MKT_FCST_ORG_ALL:전체,삭제 작업
						. #TEMP_EDI_MKT_FCST_ORG: 최종 결과,insert 작업
					*/
					BEGIN 
						INSERT INTO #TEMP_EDI_MKT_FCST_ORG (
								EDI_IF_SEQ
							,SUB_NO
							,YYYYMMDD
							,DIVISION_ID
							,SCM_SITE_ID
							,ITEM_ID
							,PROJECT_CODE
							,ERP_FCST_TYPE
							,BASIS_YYYYMMDD
							,QTY
							,EDI_INCOTERMS
							,SALES_PLANT_SITE_ID
							,DOM_EXP
							,COMPANY_ID
							,SOLDTO_CODE
							,SHIPTO_CODE
							,DOC_IDENTIFINER
							,MESSAGE_TYPE
							,UNLOADING_POINT
							,CUSTOMER_PLANT 
							,RDD_START
							,RDD_END
							,IFSEQNO
							,SCHEDULING_TYPE
							,DELFOR_TYPE
							,EDI_LT
							,CUST_MATERIAL_CODE
							,CREATE_DATE
							,SENDER_CODE
							,SENDER_NAME
							,CHANGE_STATUS
							) 
							SELECT	 
									X.EDI_IF_SEQ
								,X.SUB_NO
								,X.YYYYMMDD
								,X.DIVISION_ID
								,X.SCM_SITE_ID
								,B.ITEM_ID 
								,X.PROJECT_CODE
								,X.ERP_FCST_TYPE
								,X.BASIS_YYYYMMDD
								,X.QTY
								,X.EDI_INCOTERMS
								,X.SALES_PLANT_SITE_ID
								,X.DOM_EXP
								,X.COMPANY_ID
								,X.SOLDTO_CODE
								,X.SHIPTO_CODE
								,X.DOC_IDENTIFINER
								,X.MESSAGE_TYPE
								,ISNULL(RTRIM(LTRIM(X.UNLOADING_POINT)), '') AS UNLOADING_POINT
								,ISNULL(RTRIM(LTRIM(X.CUSTOMER_PLANT)), '') AS CUSTOMER_PLANT
								,X.RDD_START
								,X.RDD_END
								,X.IFSEQNO
								,X.SCHEDULING_TYPE
								,X.DELFOR_TYPE
								,X.EDI_LT
								,ISNULL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)), '') AS CUST_MATERIAL_CODE
								,X.CREATE_DATE
								,X.SENDER_CODE
								,X.SENDER_NAME
								,X.CHANGE_STATUS
							FROM #TEMP_EDI_MKT_FCST_ORG_ALL X WITH (NOLOCK)
							JOIN #TEMP_DM_CUST_MODEL_MAPPING_M B WITH (NOLOCK)
								ON X.DIVISION_ID = B.DIVISION_ID  
								AND X.SCM_SITE_ID = B.SCM_SITE_ID 
								AND X.PROJECT_CODE = B.PROJECT_CODE 
								AND X.ERP_FCST_TYPE = B.FCST_TYPE 
								AND X.EDI_INCOTERMS = B.INCOTERMS 
								AND X.DOM_EXP = B.DOM_EXP 
								AND X.ITEM_ID = B.ITEM_ID 
								AND ISNULL(RTRIM(LTRIM(X.UNLOADING_POINT)), '') = ISNULL(RTRIM(LTRIM(B.UNLOADING_POINT)), '') 
								AND ISNULL(RTRIM(LTRIM(X.CUSTOMER_PLANT)), '') = ISNULL(RTRIM(LTRIM(B.CUSTOMER_PLANT)), '') 
								AND ISNULL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)), '') = ISNULL(RTRIM(LTRIM(B.CUSTOMER_ITEM_ID)), '')  
							WHERE 1 = 1
								AND X.BASIS_YYYYMMDD >= B.VALID_START_DATE
								AND X.BASIS_YYYYMMDD <= B.VALID_END_DATE
								AND ISNULL(B.ITEM_ID,'') > ''
							; 
					 
					
						DELETE
						FROM DM_PLN_MKT_FCST
						WHERE MEASURE IN (
											 'CUST_FCST_EDI_ORG'
											,'Immidiate[Org.]'
											,'Planning_Forecast[Org.]'
											,'Commercial_Agreement[Org.]'
											,'Firm_Temp[Org.]'
											,'Manumacturing_Material_Temp[Org.]'
											,'Material_Temp[Org.]'
											,'Backorder[Org.]'
											)
							AND YYYYMMDD < @v_0week_monday --당주월요일이전 
							AND YYYYMMDD >= (
												SELECT MIN(X.BASIS_YYYYMMDD)
												FROM #TEMP_EDI_MKT_FCST_ORG_ALL X WITH (NOLOCK)
												WHERE DM_PLN_MKT_FCST.SCM_SITE_ID		= X.SCM_SITE_ID
													AND DM_PLN_MKT_FCST.ITEM_ID			= X.ITEM_ID
													AND DM_PLN_MKT_FCST.PROJECT_CODE	= X.PROJECT_CODE
													AND DM_PLN_MKT_FCST.FCST_TYPE		= X.ERP_FCST_TYPE
													AND DM_PLN_MKT_FCST.INCOTERMS		= X.EDI_INCOTERMS
													AND DM_PLN_MKT_FCST.PLANT_SITE_ID	= CASE WHEN X.DIVISION_ID = '81' THEN X.SALES_PLANT_SITE_ID
																							   ELSE DM_PLN_MKT_FCST.PLANT_SITE_ID
																						  END
													AND DM_PLN_MKT_FCST.DOM_EXP = 'E'
													AND DM_PLN_MKT_FCST.DIVISION_ID = X.DIVISION_ID
											)
							AND EXISTS (
												SELECT X.PROJECT_CODE
												FROM #TEMP_EDI_MKT_FCST_ORG_ALL X WITH (NOLOCK)
												WHERE DM_PLN_MKT_FCST.SCM_SITE_ID		= X.SCM_SITE_ID
													AND DM_PLN_MKT_FCST.ITEM_ID			= X.ITEM_ID
													AND DM_PLN_MKT_FCST.PROJECT_CODE	= X.PROJECT_CODE
													AND DM_PLN_MKT_FCST.FCST_TYPE		= X.ERP_FCST_TYPE
													AND DM_PLN_MKT_FCST.INCOTERMS		= X.EDI_INCOTERMS
													AND DM_PLN_MKT_FCST.PLANT_SITE_ID	= CASE WHEN X.DIVISION_ID = '81' THEN X.SALES_PLANT_SITE_ID
																							   ELSE DM_PLN_MKT_FCST.PLANT_SITE_ID
																						  END
													AND DM_PLN_MKT_FCST.DOM_EXP			= 'E'
													AND DM_PLN_MKT_FCST.DIVISION_ID		= X.DIVISION_ID
											);


						DELETE
						FROM DM_PLN_MKT_FCST
						WHERE MEASURE IN ( 
											 'CUST_FCST_EDI_ORG'
											,'Immidiate[Org.]'
											,'Planning_Forecast[Org.]'
											,'Commercial_Agreement[Org.]'
											,'Firm_Temp[Org.]'
											,'Manumacturing_Material_Temp[Org.]'
											,'Material_Temp[Org.]'
											,'Backorder[Org.]'
										)
							AND YYYYMMDD >= @v_0week_monday --금주월요일이후
							AND YYYYMMDD >= (
												SELECT MIN(X.BASIS_YYYYMMDD)
												FROM #TEMP_EDI_MKT_FCST_ORG_ALL X WITH (NOLOCK)
												WHERE DM_PLN_MKT_FCST.SCM_SITE_ID		= X.SCM_SITE_ID
													AND DM_PLN_MKT_FCST.ITEM_ID			= X.ITEM_ID
													AND DM_PLN_MKT_FCST.PROJECT_CODE	= X.PROJECT_CODE
													AND DM_PLN_MKT_FCST.FCST_TYPE		= X.ERP_FCST_TYPE
													AND DM_PLN_MKT_FCST.INCOTERMS		= X.EDI_INCOTERMS
													AND DM_PLN_MKT_FCST.PLANT_SITE_ID	= CASE WHEN X.DIVISION_ID = '81' THEN X.SALES_PLANT_SITE_ID
																							   ELSE DM_PLN_MKT_FCST.PLANT_SITE_ID
																						  END
													AND DM_PLN_MKT_FCST.DOM_EXP			= 'E'
													AND DM_PLN_MKT_FCST.DIVISION_ID		= X.DIVISION_ID
								)
							AND EXISTS (
												SELECT X.PROJECT_CODE
												FROM #TEMP_EDI_MKT_FCST_ORG_ALL X WITH (NOLOCK)
												WHERE DM_PLN_MKT_FCST.DIVISION_ID	= X.DIVISION_ID
													AND DM_PLN_MKT_FCST.ATTRIBUTE5	= X.SENDER_NAME 
													AND DM_PLN_MKT_FCST.DOM_EXP		= 'E'
										);

							
						DELETE
						FROM DM_PLN_MKT_FCST
						WHERE MEASURE IN (
											 'CUST_FCST_EDI_ORG'
											,'Immidiate[Org.]'
											,'Planning_Forecast[Org.]'
											,'Commercial_Agreement[Org.]'
											,'Firm_Temp[Org.]'
											,'Manumacturing_Material_Temp[Org.]'
											,'Material_Temp[Org.]'
											,'Backorder[Org.]'
										)
							AND YYYYMMDD < @v_0week_monday --당주월요일이전 
							AND YYYYMMDD >= (
												SELECT MIN(X.BASIS_YYYYMMDD)
												FROM #TEMP_EDI_MKT_FCST_ORG X WITH (NOLOCK)
												WHERE DM_PLN_MKT_FCST.SCM_SITE_ID		= X.SCM_SITE_ID
													AND DM_PLN_MKT_FCST.ITEM_ID			= X.ITEM_ID
													AND DM_PLN_MKT_FCST.PROJECT_CODE	= X.PROJECT_CODE
													AND DM_PLN_MKT_FCST.FCST_TYPE		= X.ERP_FCST_TYPE
													AND DM_PLN_MKT_FCST.INCOTERMS		= X.EDI_INCOTERMS
													AND DM_PLN_MKT_FCST.PLANT_SITE_ID	= CASE WHEN X.DIVISION_ID = '81' THEN X.SALES_PLANT_SITE_ID
																							   ELSE DM_PLN_MKT_FCST.PLANT_SITE_ID
																						  END
													AND DM_PLN_MKT_FCST.DOM_EXP			= 'E'
													AND DM_PLN_MKT_FCST.DIVISION_ID		= X.DIVISION_ID
								)
							AND EXISTS (
											SELECT X.PROJECT_CODE
											FROM #TEMP_EDI_MKT_FCST_ORG X WITH (NOLOCK)
											WHERE DM_PLN_MKT_FCST.SCM_SITE_ID		= X.SCM_SITE_ID
												AND DM_PLN_MKT_FCST.ITEM_ID			= X.ITEM_ID
												AND DM_PLN_MKT_FCST.PROJECT_CODE	= X.PROJECT_CODE
												AND DM_PLN_MKT_FCST.FCST_TYPE		= X.ERP_FCST_TYPE
												AND DM_PLN_MKT_FCST.INCOTERMS		= X.EDI_INCOTERMS
												AND DM_PLN_MKT_FCST.PLANT_SITE_ID	= CASE WHEN X.DIVISION_ID = '81' THEN X.SALES_PLANT_SITE_ID
																						   ELSE DM_PLN_MKT_FCST.PLANT_SITE_ID
																					  END
												AND DM_PLN_MKT_FCST.DOM_EXP			= 'E'
												AND DM_PLN_MKT_FCST.DIVISION_ID		= X.DIVISION_ID
										);

					DELETE
					FROM DM_PLN_MKT_FCST
					WHERE MEASURE IN (
										 'CUST_FCST_EDI_ORG'
										,'Immidiate[Org.]'
										,'Planning_Forecast[Org.]'
										,'Commercial_Agreement[Org.]'
										,'Firm_Temp[Org.]'
										,'Manumacturing_Material_Temp[Org.]'
										,'Material_Temp[Org.]'
										,'Backorder[Org.]'
									)
						AND YYYYMMDD >= @v_0week_monday --금주월요일이후
						AND YYYYMMDD >= (
											SELECT MIN(X.BASIS_YYYYMMDD)
											FROM #TEMP_EDI_MKT_FCST_ORG X WITH (NOLOCK)
											WHERE DM_PLN_MKT_FCST.SCM_SITE_ID		= X.SCM_SITE_ID
											AND DM_PLN_MKT_FCST.ITEM_ID				= X.ITEM_ID
											AND DM_PLN_MKT_FCST.PROJECT_CODE		= X.PROJECT_CODE
											AND DM_PLN_MKT_FCST.FCST_TYPE			= X.ERP_FCST_TYPE
											AND DM_PLN_MKT_FCST.INCOTERMS			= X.EDI_INCOTERMS
											AND DM_PLN_MKT_FCST.PLANT_SITE_ID		= CASE WHEN X.DIVISION_ID = '81' THEN X.SALES_PLANT_SITE_ID
																						   ELSE DM_PLN_MKT_FCST.PLANT_SITE_ID
																					  END
											AND DM_PLN_MKT_FCST.DOM_EXP				= 'E'
											AND DM_PLN_MKT_FCST.DIVISION_ID			= X.DIVISION_ID
										)
						AND EXISTS (
											SELECT X.PROJECT_CODE
											FROM #TEMP_EDI_MKT_FCST_ORG X WITH (NOLOCK) 
									);
				END

				------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
				-- 날짜 중복데이터는 SUM한 값으로 입력
				------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
				BEGIN
					INSERT INTO DM_PLN_MKT_FCST (
						  DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS
						, MEASURE
						, PLANT_SITE_ID
						, YYYYMMDD
						, QTY
						, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
						, ATTRIBUTE4 -- SENDER_CODE 값 저장
						, ATTRIBUTE5 -- SENDER_NAME 값 저장
						, ATTRIBUTE6 -- IFSEQNO 값 저장
						, ATTRIBUTE7 -- LEADTIME 적용전 ORIGINAL YYYYMMDD 값 저장
						, ATTRIBUTE8 -- EDI_LT 값 저장
						, ATTRIBUTE9 -- CREATE_DATE 값 저장
						, ATTRIBUTE10 -- 소급적용여부
						)
					SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
						, A.DOM_EXP, A.ERP_FCST_TYPE, A.EDI_INCOTERMS
						,'CUST_FCST_EDI_ORG'					AS MEASURE
						, ISNULL(A.SALES_PLANT_SITE_ID, '')		AS PLANT_SITE_ID
						, A.BASIS_YYYYMMDD						AS YYYYMMDD
						, SUM(CAST(REPLACE(A.QTY, ',', '') AS NUMERIC))	AS QTY
						, 'EDI'						AS CREATED_BY
						, GETDATE()					AS CREATION_DATE
						, 'EDI'						AS LAST_UPDATED_BY
						, GETDATE()					AS LAST_UPDATE_DATE
						, MAX(A.SENDER_CODE)		AS ATTRIBUTE4
						, MAX(A.SENDER_NAME)		AS ATTRIBUTE5
						, MAX(A.IFSEQNO)			AS ATTRIBUTE6
						, MAX(A.YYYYMMDD)			AS ATTRIBUTE7
						, MAX(A.EDI_LT)				AS ATTRIBUTE8
						, MAX(A.CREATE_DATE)		AS ATTRIBUTE9
						, MAX(A.CHANGE_STATUS)		AS ATTRIBUTE10
					FROM #TEMP_EDI_MKT_FCST_ORG A WITH (NOLOCK)
					INNER JOIN (
									SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
										, SCHEDULING_TYPE
										, DOM_EXP
										, ERP_FCST_TYPE
										, UNLOADING_POINT
										, CUSTOMER_PLANT 
										, EDI_INCOTERMS
										, ISNULL(SALES_PLANT_SITE_ID, '')	AS SALES_PLANT_SITE_ID
										, BASIS_YYYYMMDD
										, CREATE_DATE
									FROM #TEMP_EDI_MKT_FCST_ORG WITH (NOLOCK)
									WHERE 1 = 1
									GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
										,SCHEDULING_TYPE
										,DOM_EXP
										,ERP_FCST_TYPE
										,UNLOADING_POINT
										,CUSTOMER_PLANT 
										,EDI_INCOTERMS
										,ISNULL(SALES_PLANT_SITE_ID, '')
										,BASIS_YYYYMMDD
										,CREATE_DATE
						) B 
						ON  A.DIVISION_ID		= B.DIVISION_ID
						AND A.PROJECT_CODE		= B.PROJECT_CODE
						AND A.SCM_SITE_ID		= B.SCM_SITE_ID
						AND A.ITEM_ID			= B.ITEM_ID
						AND A.SCHEDULING_TYPE	= B.SCHEDULING_TYPE
						AND A.DOM_EXP			= B.DOM_EXP
						AND A.ERP_FCST_TYPE		= B.ERP_FCST_TYPE
						AND A.UNLOADING_POINT	= B.UNLOADING_POINT
						AND A.CUSTOMER_PLANT	= B.CUSTOMER_PLANT 
						AND A.EDI_INCOTERMS		= B.EDI_INCOTERMS
						AND ISNULL(A.SALES_PLANT_SITE_ID, '') = ISNULL(B.SALES_PLANT_SITE_ID, '')
						AND A.CREATE_DATE		= B.CREATE_DATE
						AND A.BASIS_YYYYMMDD	= B.BASIS_YYYYMMDD
					WHERE 1 = 1
					GROUP BY A.DIVISION_ID
						,A.PROJECT_CODE
						,A.SCM_SITE_ID
						,A.ITEM_ID
						,A.DOM_EXP
						,A.ERP_FCST_TYPE
						,A.EDI_INCOTERMS
						,ISNULL(A.SALES_PLANT_SITE_ID, '')
						,A.BASIS_YYYYMMDD
				END

				------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
				-- MEASURE별 SUM한 값으로 생성
				------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
				BEGIN
					INSERT INTO DM_PLN_MKT_FCST (
						DIVISION_ID
						,PROJECT_CODE
						,SCM_SITE_ID
						,ITEM_ID
						,DOM_EXP
						,FCST_TYPE
						,INCOTERMS
						,MEASURE
						,PLANT_SITE_ID
						,YYYYMMDD
						,QTY
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						,ATTRIBUTE4 -- SENDER_CODE 값 저장
						,ATTRIBUTE5 -- SENDER_NAME 값 저장
						,ATTRIBUTE6 -- IFSEQNO 값 저장
						,ATTRIBUTE7 -- LEADTIME 적용전 ORIGINAL YYYYMMDD 값 저장
						,ATTRIBUTE8 -- EDI_LT 값 저장
						,ATTRIBUTE9 -- CREATE_DATE 값 저장
						,ATTRIBUTE10 -- 소급적용여부
						)
					SELECT A.DIVISION_ID
						,A.PROJECT_CODE
						,A.SCM_SITE_ID
						,A.ITEM_ID
						,A.DOM_EXP
						,A.ERP_FCST_TYPE
						,A.EDI_INCOTERMS
						,CASE WHEN A.SCHEDULING_TYPE = '1'		THEN 'Firm_Temp[Org.]'
							  WHEN A.SCHEDULING_TYPE = '2'		THEN 'Manumacturing_Material_Temp[Org.]'
							  WHEN A.SCHEDULING_TYPE = '3'		THEN 'Material_Temp[Org.]'
							  WHEN A.SCHEDULING_TYPE = '4'		THEN 'Planning_Forecast[Org.]'
							  WHEN A.SCHEDULING_TYPE = '10'		THEN 'Immidiate[Org.]'
							  WHEN A.SCHEDULING_TYPE = '24'		THEN 'Commercial_Agreement[Org.]'
							  WHEN A.SCHEDULING_TYPE = '83'		THEN 'Backorder[Org.]'
						 END												AS MEASURE
						,ISNULL(A.SALES_PLANT_SITE_ID, '')					AS PLANT_SITE_ID
						,A.BASIS_YYYYMMDD									AS YYYYMMDD
						,SUM(CAST(REPLACE(A.QTY, ',', '') AS NUMERIC))		AS QTY
						,'EDI'							AS CREATED_BY
						,GETDATE()						AS CREATION_DATE
						,'EDI'							AS LAST_UPDATED_BY
						,GETDATE()						AS LAST_UPDATE_DATE
						,MAX(A.SENDER_CODE)				AS ATTRIBUTE4
						,MAX(A.SENDER_NAME)				AS ATTRIBUTE5
						,MAX(A.IFSEQNO)					AS ATTRIBUTE6
						,MAX(A.YYYYMMDD)				AS ATTRIBUTE7
						,MAX(A.EDI_LT)					AS ATTRIBUTE8
						,MAX(A.CREATE_DATE)				AS ATTRIBUTE9
						,MAX(A.CHANGE_STATUS)			AS ATTRIBUTE10
					FROM #TEMP_EDI_MKT_FCST_ORG A WITH (NOLOCK)
					INNER JOIN (
									SELECT DIVISION_ID
										,PROJECT_CODE
										,SCM_SITE_ID
										,ITEM_ID
										,SCHEDULING_TYPE
										,DOM_EXP
										,ERP_FCST_TYPE
										,UNLOADING_POINT
										,CUSTOMER_PLANT 
										,EDI_INCOTERMS
										,ISNULL(SALES_PLANT_SITE_ID, '') AS SALES_PLANT_SITE_ID
										,BASIS_YYYYMMDD
										,CREATE_DATE
									FROM #TEMP_EDI_MKT_FCST_ORG WITH (NOLOCK)
									WHERE 1 = 1
									GROUP BY DIVISION_ID
										,PROJECT_CODE
										,SCM_SITE_ID
										,ITEM_ID
										,SCHEDULING_TYPE
										,DOM_EXP
										,ERP_FCST_TYPE
										,UNLOADING_POINT
										,CUSTOMER_PLANT --추가 20231128 YU
										,EDI_INCOTERMS
										,ISNULL(SALES_PLANT_SITE_ID, '')
										,BASIS_YYYYMMDD
										,CREATE_DATE
									) B 
						ON A.DIVISION_ID		= B.DIVISION_ID
						AND A.PROJECT_CODE		= B.PROJECT_CODE
						AND A.SCM_SITE_ID		= B.SCM_SITE_ID
						AND A.ITEM_ID			= B.ITEM_ID
						AND A.SCHEDULING_TYPE	= B.SCHEDULING_TYPE
						AND A.DOM_EXP			= B.DOM_EXP
						AND A.ERP_FCST_TYPE		= B.ERP_FCST_TYPE
						AND A.UNLOADING_POINT	= B.UNLOADING_POINT
						AND A.CUSTOMER_PLANT	= B.CUSTOMER_PLANT 
						AND A.EDI_INCOTERMS		= B.EDI_INCOTERMS
						AND ISNULL(A.SALES_PLANT_SITE_ID, '') = ISNULL(B.SALES_PLANT_SITE_ID, '')
						AND A.CREATE_DATE		= B.CREATE_DATE
						AND A.BASIS_YYYYMMDD	= B.BASIS_YYYYMMDD
					WHERE 1 = 1
					GROUP BY A.DIVISION_ID
						,A.PROJECT_CODE
						,A.SCM_SITE_ID
						,A.ITEM_ID
						,A.SCHEDULING_TYPE
						,A.DOM_EXP
						,A.ERP_FCST_TYPE
						,A.EDI_INCOTERMS
						,ISNULL(A.SALES_PLANT_SITE_ID, '')
						,A.BASIS_YYYYMMDD
				END

				-------------------------------------------------------------------------------------------------------------------------------------------------------------------
				-- CUST_FCST_EDI_ORG 및 하위 MEASURE 생성 (END)
				-------------------------------------------------------------------------------------------------------------------------------------------------------------------
				-------------------------------------------------------------------------------------------------------------------------------------------------------------------
				-- History 기능 추가 (BEGIN)
				-------------------------------------------------------------------------------------------------------------------------------------------------------------------
				BEGIN
					INSERT INTO DM_PLN_MKT_FCST_H (
						DIVISION_ID
						,HISTORY_SEQ
						,PROJECT_CODE
						,SCM_SITE_ID
						,ITEM_ID
						,DOM_EXP
						,FCST_TYPE
						,INCOTERMS
						,MEASURE
						,PLANT_SITE_ID
						,YYYYMMDD
						,QTY
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						,ATTRIBUTE1
						,ATTRIBUTE2
						,ATTRIBUTE3
						,ATTRIBUTE4
						,ATTRIBUTE5
						,ATTRIBUTE6
						,ATTRIBUTE7
						,ATTRIBUTE8
						,ATTRIBUTE9
						,ATTRIBUTE10
						)
					SELECT B.DIVISION_ID
						,NEXT VALUE FOR SEQ1_DM_PLN_MKT_FCST_H -- History Seqno
						,B.PROJECT_CODE
						,B.SCM_SITE_ID
						,B.ITEM_ID
						,B.DOM_EXP
						,FCST_TYPE
						,INCOTERMS
						,MEASURE
						,PLANT_SITE_ID
						,B.BASIS_YYYYMMDD
						,CAST(REPLACE(B.QTY, ',', '') AS NUMERIC)
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						,ATTRIBUTE1
						,ATTRIBUTE2
						,ATTRIBUTE3
						,ATTRIBUTE4
						,ATTRIBUTE5
						,ATTRIBUTE6
						,ATTRIBUTE7
						,ATTRIBUTE8
						,ATTRIBUTE9
						,ATTRIBUTE10
					FROM DM_PLN_MKT_FCST A WITH (NOLOCK)
					INNER JOIN #TEMP_EDI_MKT_FCST_ORG B WITH (NOLOCK) 
						ON A.DIVISION_ID	= B.DIVISION_ID
						AND A.PROJECT_CODE	= B.PROJECT_CODE
						AND A.SCM_SITE_ID	= B.SCM_SITE_ID
						AND A.ITEM_ID		= B.ITEM_ID
						AND A.YYYYMMDD		= B.BASIS_YYYYMMDD
					INNER JOIN (
									SELECT DIVISION_ID
										,PROJECT_CODE
										,SCM_SITE_ID
										,ITEM_ID
										,DOM_EXP
										,ERP_FCST_TYPE
										,UNLOADING_POINT
										,CUSTOMER_PLANT --추가 20231128 YU
										,EDI_INCOTERMS
										,ISNULL(SALES_PLANT_SITE_ID, '') AS SALES_PLANT_SITE_ID
										,BASIS_YYYYMMDD
										,CREATE_DATE
									FROM #TEMP_EDI_MKT_FCST_ORG WITH (NOLOCK)
									WHERE BASIS_YYYYMMDD >= @v_0week_monday
									GROUP BY DIVISION_ID
										,PROJECT_CODE
										,SCM_SITE_ID
										,ITEM_ID
										,DOM_EXP
										,ERP_FCST_TYPE
										,UNLOADING_POINT
										,CUSTOMER_PLANT --추가 20231128 YU
										,EDI_INCOTERMS
										,ISNULL(SALES_PLANT_SITE_ID, '')
										,BASIS_YYYYMMDD
										,CREATE_DATE
						) C 
						ON A.DIVISION_ID		= C.DIVISION_ID
						AND B.PROJECT_CODE		= C.PROJECT_CODE
						AND B.SCM_SITE_ID		= C.SCM_SITE_ID
						AND B.ITEM_ID			= C.ITEM_ID
						AND B.DOM_EXP			= C.DOM_EXP
						AND B.ERP_FCST_TYPE		= C.ERP_FCST_TYPE
						AND B.UNLOADING_POINT	= C.UNLOADING_POINT
						AND B.CUSTOMER_PLANT	= C.CUSTOMER_PLANT --추가 20231128 YU
						AND B.EDI_INCOTERMS		= C.EDI_INCOTERMS
						AND ISNULL(B.SALES_PLANT_SITE_ID, '') = ISNULL(C.SALES_PLANT_SITE_ID, '')
						AND B.CREATE_DATE		= C.CREATE_DATE
						AND B.BASIS_YYYYMMDD	= C.BASIS_YYYYMMDD
					WHERE 1 = 1
						--AND A.YYYYMMDD	>= @v_0week_monday		-- W1월요일이후
						AND A.MEASURE IN (
											'CUST_FCST_EDI_ORG'
											,'Immidiate[Org.]'
											,'Planning_Forecast[Org.]'
											,'Commercial_Agreement[Org.]'
											,'Firm_Temp[Org.]'
											,'Manumacturing_Material_Temp[Org.]'
											,'Material_Temp[Org.]'
											,'Backorder[Org.]'
										)
				END
					-------------------------------------------------------------------------------------------------------------------------------------------------------------------
					-- History 기능 추가 (END)
					-------------------------------------------------------------------------------------------------------------------------------------------------------------------
					------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
					-- EDI 데이터 LOOKUP FROM 기간 이후 데이터 미전송시 MKT_FCST 기존 수량을 전부 0으로 변경 START
					------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇		
					BEGIN
						-- 테이블중복제거
						IF OBJECT_ID(N'tempdb..#TEMP_MKT_ORG_DATA', N'U') IS NOT NULL
							DROP TABLE #TEMP_MKT_ORG_DATA

						-- 임시확인용테이블 중복제거
						IF OBJECT_ID(N'dbo.#TEMP_MKT_ORG_DATA', N'U') IS NOT NULL
							DROP TABLE #TEMP_MKT_ORG_DATA

						--#TEMP_MKT_DATA
						CREATE TABLE #TEMP_MKT_ORG_DATA (
							 DIVISION_ID		NVARCHAR(30) NULL
							,PROJECT_CODE		NVARCHAR(50) NULL
							,SCM_SITE_ID		NVARCHAR(50) NULL
							,ITEM_ID			NVARCHAR(50) NULL
							,PLANT_SITE_ID		NVARCHAR(50) NULL
						);

						--MKT_FCST 데이터 생성일 체크
						BEGIN
							BEGIN
								--LOOKUP적용
								INSERT INTO #TEMP_MKT_ORG_DATA (
									DIVISION_ID
									,PROJECT_CODE
									,SCM_SITE_ID
									,ITEM_ID
									,PLANT_SITE_ID
								)
								SELECT A.DIVISION_ID
									,A.PROJECT_CODE
									,A.SCM_SITE_ID
									,A.ITEM_ID
									,A.PLANT_SITE_ID
								FROM (
										SELECT DIVISION_ID
											,PROJECT_CODE
											,SCM_SITE_ID
											,ITEM_ID
											,PLANT_SITE_ID
											,MAX(ATTRIBUTE6) AS IFSEQNO
											,MAX(ATTRIBUTE9) AS CREATE_DATE
										FROM DM_PLN_MKT_FCST WITH (NOLOCK)
										WHERE MEASURE IN (
															'CUST_FCST_EDI_ORG'
															,'Immidiate[Org.]'
															,'Planning_Forecast[Org.]'
															,'Commercial_Agreement[Org.]'
															,'Firm_Temp[Org.]'
															,'Manumacturing_Material_Temp[Org.]'
															,'Material_Temp[Org.]'
															,'Backorder[Org.]'
															)
											AND QTY <> 0
										GROUP BY DIVISION_ID
											,PROJECT_CODE
											,SCM_SITE_ID
											,ITEM_ID
											,PLANT_SITE_ID
									) A
								LEFT OUTER JOIN SCM_MST_SITE B WITH (NOLOCK) 
									ON A.DIVISION_ID = B.DIVISION_ID
									AND A.SCM_SITE_ID = B.SCM_SITE_ID
									AND B.SITE_TYPE = 'SALES'
									AND B.VALID_YN = 'Y'
									AND ISNULL(REPLACE(B.END_CUSTOMER, '-', ''), '') <> ''
								LEFT OUTER JOIN #TEMP_EDI_END_CUSTOMER_ORG C WITH (NOLOCK) 
									ON A.DIVISION_ID = C.DIVISION_ID
									AND C.END_CUSTOMER = B.END_CUSTOMER
									AND C.SCM_SITE_ID = ISNULL((
																	SELECT SCM_SITE_ID
																	FROM #TEMP_EDI_END_CUSTOMER_ORG WITH (NOLOCK)
																	WHERE DIVISION_ID = A.DIVISION_ID
																		AND END_CUSTOMER = B.END_CUSTOMER
																		AND SCM_SITE_ID = A.SCM_SITE_ID
																), '-')
								WHERE A.CREATE_DATE < (
										SELECT BASIS_YYYYMMDD
										FROM (
											SELECT RANK() OVER (ORDER BY BASIS_YYYYMMDD DESC) * - 1 AS RK, DT.BASIS_YYYYMMDD 
											FROM SCM_SYS_CALENDAR_M DT WITH (NOLOCK)
											WHERE BASIS_YYYYMMDD <=  (CASE WHEN DATEPART(WEEKDAY, GETDATE()) = '2' THEN CONVERT(NVARCHAR, DATEADD(DD, - 1, GETDATE()), 112)
																		  WHEN DATEPART(WEEKDAY, GETDATE()) = '3' THEN ( CASE WHEN @v_HOUR < '05'THEN CONVERT(NVARCHAR, DATEADD(DD, - 2, GETDATE()), 112)
																															  ELSE CONVERT(NVARCHAR, GETDATE(), 112)
																														  END
																													    )
																			ELSE CONVERT(NVARCHAR, GETDATE(), 112)
																		END)
												AND DAYOFWEEK = C.FROM_DAY
											) D
										WHERE D.RK = C.FROM_WEEK
									)
								AND C.ACTIVE = 'On'
							END

							BEGIN
								UPDATE MK
								SET  QTY = 0
									,LAST_UPDATED_BY = 'EDI'
									,LAST_UPDATE_DATE = GETDATE()
								FROM DM_PLN_MKT_FCST MK WITH (NOLOCK)
								JOIN #TEMP_MKT_ORG_DATA ED WITH (NOLOCK) 
									ON MK.DIVISION_ID	= ED.DIVISION_ID
									AND MK.PROJECT_CODE	= ED.PROJECT_CODE
									AND MK.SCM_SITE_ID	= ED.SCM_SITE_ID
									AND MK.ITEM_ID		= ED.ITEM_ID
									AND MK.PLANT_SITE_ID = ED.PLANT_SITE_ID
								WHERE MK.MEASURE IN (
														'CUST_FCST_EDI_ORG'
														,'Immidiate[Org.]'
														,'Planning_Forecast[Org.]'
														,'Commercial_Agreement[Org.]'
														,'Firm_Temp[Org.]'
														,'Manumacturing_Material_Temp[Org.]'
														,'Material_Temp[Org.]'
														,'Backorder[Org.]'
													)
								AND MK.QTY <> 0
							END
						END
					END
						------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
						-- EDI 데이터 LOOKUP FROM 기간 이후 데이터 미전송시 MKT_FCST 기존 수량을 전부 0으로 변경 END
						------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

			    END
			END

		END
			------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇		
			-- ◇◇◇◇◇                                  CUST_FCST_EDI[Org.] END
			------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇							
			------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
	END TRY

	BEGIN CATCH
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + CAST(ERROR_LINE() AS NVARCHAR(10));
		SET @d_event_date = SYSDATETIME();

		SELECT @v_log_message

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
			,@v_log_type
			,@n_log_count
			,@v_log_message
			,@v_description
			,@d_event_date;
	END CATCH;

	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = 'CUST_FCST_EDI Insert';
	SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
		,@v_log_type
		,@n_log_count
		,@v_log_message
		,@v_description
		,@d_event_date;

	ERR_RTN:

	PRINT 'end ' + convert(NVARCHAR(30), getdate(), 121)
END;
