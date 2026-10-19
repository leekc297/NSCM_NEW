
/*
 * Program ID  : PR_DM_PLN_CUST_FCST_RECORD
 * Description  : EDI, CUST_FCST 데이터 HISTORY에 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.04.11   chano0612	EDI, CUST_FCST 데이터 HISTORY에 저장
 * 2024.03.18   kcw3408   	아래 속도 개선(DBA 정기훈 부장)
 * 2024.04.30   kcw3408     N:N Model Mapping_적재 추가(집계 시점에 Cust Item/Unloading Point/Plant 고려,Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음)
 * 2024.06.26	JSSBAE		[E20240620-001488]_SCM DM 고객수요분석- Cust Plant NULL인 데이터 처리로직 개선
 * 2025.01.20	KANG.H.J	[PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
 * 2025.03.18	JSSBAE		[E20250313-001202]_Customer Forecast Upload 데이터 오류 수정
 * 2025.10.31	JSSBAE		[E20251016-001453]_ERP NN Mapping 데이터 반영 수행시간 단축 및 로그 보완

 <아래1>
 20240315
1.쿼리수정 - IDX_DM_DNM_EDI_CALLOFF_ITEM_N01 힌트추가
FROM  DM_DNM_EDI_CALLOFF_ITEM A WITH(NOLOCK, INDEX(IDX_DM_DNM_EDI_CALLOFF_ITEM_N01))  

2.DM_DNM_EDI_CALLOFF_ITEM 테이블에 IFSEQNO를 선두컬럼으로 하는 인덱스 추가
CREATE NONCLUSTERED INDEX IDX_DM_DNM_EDI_CALLOFF_ITEM_N02 ON dbo.DM_DNM_EDI_CALLOFF_ITEM
(IFSEQNO) WITH (ONLINE = ON)

3.DM_PLN_CUST_FCST_H 테이블에 EDI_IF_SEQ를 선두컬럼으로 하는 인덱스 추가
CREATE NONCLUSTERED INDEX IDX_DM_PLN_CUST_FCST_H_N01 ON dbo.DM_PLN_CUST_FCST_H
(EDI_IF_SEQ) WITH (ONLINE = ON)

4.DM_PLN_CUST_FCST_H에 LAST_UPDATE_DATE 선두컬럼으로 하는 인덱스 추가 및 쿼리수정
CREATE NONCLUSTERED INDEX IDX_DM_PLN_CUST_FCST_H_N02 ON dbo.DM_PLN_CUST_FCST_H
(LAST_UPDATE_DATE, MEASURE, DIVISION_ID) WITH (ONLINE = ON)

추가한 인덱스를 활용할 수 있게 조건절 수정
DELETE FROM DM_PLN_CUST_FCST_H  
WHERE MEASURE IN ('CUST_FCST', 'Customer FCST')  
AND DIVISION_ID = @v_division_id  
--AND CONVERT(NVARCHAR, LAST_UPDATE_DATE, 112) >= @v_from_date        
LAST_UPDATE_DATE > CONVERT(DATETIME, @v_from_date)

 <아래1>

 
EXEC PR_DM_PLN_CUST_FCST_RECORD '81', 'EDI'
EXEC PR_DM_PLN_CUST_FCST_RECORD '81_UC', 'EDI'
EXEC PR_DM_PLN_CUST_FCST_RECORD '81', 'RPA'
EXEC PR_DM_PLN_CUST_FCST_RECORD '40', 'RPA'

 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_CUST_FCST_RECORD]
	 @p_division_id			NVARCHAR(8),	-- division_id 전달받음
	 @p_accept_flag			NVARCHAR(10)	-- 업무구분(EDI, RPA)

AS
BEGIN

	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;											
	
	---- LOG 용 변수 설정
    DECLARE @v_program_name				NVARCHAR(150) = 'PR_DM_PLN_CUST_FCST_RECORD';
    DECLARE @v_log_type					NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count				INTEGER = 0;
    DECLARE @v_log_message				NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);
    DECLARE @d_event_date				DATETIME;

	DECLARE @v_division_id				NVARCHAR(30);
	DECLARE @v_ifseqno_INSERT			NVARCHAR(30);
	DECLARE @v_accept_flag				NVARCHAR(10);
		
	DECLARE @v_0week_monday				NVARCHAR(08);  --W0 월요일	
	DECLARE @v_1week_monday				NVARCHAR(08);  --W1 월요일		

	DECLARE @v_from_date   				NVARCHAR(8);	
	--DECLARE @v_from_date_C				NVARCHAR(8);

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = 'Div: ' + @p_division_id + '_' + @p_accept_flag
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRY
	
	--SET @v_from_date   = CONVERT(NVARCHAR, DATEADD(DD, -1, CONVERT(CHAR(8), GETDATE(), 112)), 112)
	SET @v_from_date   = '20250101'--CONVERT(NVARCHAR, DATEADD(DD, -1, CONVERT(CHAR(8), GETDATE(), 112)), 112)
	--SET @v_from_date_C	= CONVERT(NVARCHAR, DATEADD(DD, -30, CONVERT(CHAR(8), GETDATE(), 112)), 112)

	SET @v_0week_monday = CONVERT(CHAR(8), DATEADD(DD, -7,				DBO.FN_NEXT_DAY(CONVERT(VARCHAR,GETDATE(),112), 'MON')), 112)  --W0월요일	
	SET @v_1week_monday	= CONVERT(CHAR(8), DATEADD(DD, -7+7,			DBO.FN_NEXT_DAY(CONVERT(VARCHAR,GETDATE(),112), 'MON')), 112)  --W1월요일		

	SET @v_division_id = @p_division_id
	SET @v_accept_flag = @p_accept_flag

		--******************** EDI DATA 생성 START ********************
		BEGIN

			IF @v_accept_flag = 'EDI'
			BEGIN   
				/* 현시점에서는 불필요.. 2025.01.16
				BEGIN
				 --	 ATTRIBUTE10 = 'C' 데이터 정의 
					UPDATE A
					SET A.ATTRIBUTE10	= 'C'
					FROM DM_DNM_EDI_CALLOFF_ITEM A
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
					  ON B.SEGMENT1		= A.DIVISION_ID
					 AND B.SEGMENT3		= A.SENDER_CODE
					 AND B.SEGMENT2		= A.SENDER_NAME
					 AND B.LOOKUP_TYPE	= 'DM_EDI_ITEM_MST_CODE'
					 AND B.VALID_YN		= 'Y'
					 AND REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(B.SEGMENT4, ' ', ''), '-', ''), '.', ''), '/', ''), ',', ''), ':', ''), ';', ''), '+', ''), '_', ''), '(', ''), ')', ''), '*', ''), '^', ''), '$', ''), '#', '') = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(A.CUST_MATERIAL_CODE, ' ', ''), '-', ''), '.', ''), '/', ''), ',', ''), ':', ''), ';', ''), '+', ''), '_', ''), '(', ''), ')', ''), '*', ''), '^', ''), '$', ''), '#', '')			
					WHERE A.STATUS_CODE = 'U'
					AND A.CREATE_DATE	>= @v_from_date_C
					--AND ISNULL(LTRIM(RTRIM(A.CUST_MATERIAL_CODE)),'') <> ''
					--AND (ISNULL(LTRIM(RTRIM(A.ITEM_ID)),'') = '' OR (A.ITEM_ID = A.CUST_MATERIAL_CODE))
					AND  EXCEPTION_FLAG <> 'Y'
					;

				END
				*/

				BEGIN

				    PRINT('EDI_01:'+ CONVERT(NVARCHAR, @v_accept_flag)) + convert(varchar(30), getdate(), 121) 

					-- 테이블중복제거
					IF OBJECT_ID (N'tempdb..#TEMP_EDI_ALL', N'U')			IS NOT NULL	DROP TABLE #TEMP_EDI_ALL	
					-- 임시확인용테이블 중복제거
					IF OBJECT_ID (N'dbo.#TEMP_EDI_ALL', N'U')			    IS NOT NULL	DROP TABLE #TEMP_EDI_ALL	

					--#TEMP_EDI_NEW_ALL	
					CREATE TABLE #TEMP_EDI_ALL	
					(
						NUM					INT	NULL,
						IFSEQNO			NVARCHAR(35)	NULL
					);

					--EDI STATUS_CODE가 SUCCESS인 DATA
					BEGIN			
						INSERT INTO #TEMP_EDI_ALL ( NUM, IFSEQNO )
						SELECT ROW_NUMBER() OVER(ORDER BY A.IFSEQNO) AS NUM, A.IFSEQNO
						FROM  DM_DNM_EDI_CALLOFF_ITEM A WITH(NOLOCK, INDEX(IDX_DM_DNM_EDI_CALLOFF_ITEM_N01))
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
						ON A.SENDER_CODE	= B.SEGMENT2
						AND B.LOOKUP_TYPE	= 'EDI_SENDER_CODE'
						WHERE 1=1
						AND A.DIVISION_ID	= @v_division_id				
						AND A.CREATE_DATE	>= @v_from_date
						--AND ISNULL(A.ATTRIBUTE10, '') = ''		-- 현 시점에서는 불필요. 삭제
						GROUP BY A.IFSEQNO
						ORDER BY A.IFSEQNO;

					END
					
				    PRINT('EDI_02:'+ CONVERT(NVARCHAR, @v_accept_flag)) + convert(varchar(30), getdate(), 121) 

					/* 현시점에서는 불필요.. 2025.01.16
					-- 테이블중복제거
					IF OBJECT_ID (N'tempdb..#TEMP_EDI_ALL_C', N'U')			IS NOT NULL	DROP TABLE #TEMP_EDI_ALL_C
					-- 임시확인용테이블 중복제거
					IF OBJECT_ID (N'dbo.#TEMP_EDI_ALL_C', N'U')				IS NOT NULL	DROP TABLE #TEMP_EDI_ALL_C

					--#TEMP_EDI_NEW_ALL	
					CREATE TABLE #TEMP_EDI_ALL_C	
					(
						NUM					INT	NULL,
						IFSEQNO			NVARCHAR(35)	NULL
					);

					--EDI STATUS_CODE가 SUCCESS인 DATA
					BEGIN			
						INSERT INTO #TEMP_EDI_ALL_C ( NUM, IFSEQNO )
						SELECT ROW_NUMBER() OVER(ORDER BY A.IFSEQNO) AS NUM, A.IFSEQNO
						FROM  DM_DNM_EDI_CALLOFF_ITEM A WITH(NOLOCK, INDEX(IDX_DM_DNM_EDI_CALLOFF_ITEM_N01))
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
						ON A.SENDER_CODE = B.SEGMENT2
						AND B.LOOKUP_TYPE = 'EDI_SENDER_CODE'
						WHERE 1=1
						AND A.DIVISION_ID = @v_division_id				
						AND A.CREATE_DATE >= @v_from_date_C
						AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) >= @v_from_date
						AND A.ATTRIBUTE10 = 'C'
						GROUP BY A.IFSEQNO
						ORDER BY A.IFSEQNO;

					END
					*/

				    PRINT('EDI_03:'+ CONVERT(NVARCHAR, @v_accept_flag)) + convert(varchar(30), getdate(), 121) 

					DECLARE @CNT INT = 0; 
					SELECT @CNT = SUM(A.CNT) 
					  FROM (
								SELECT  COUNT(*) AS CNT FROM #TEMP_EDI_ALL 
								/* 현시점에서는 불필요.. 2025.01.16
								UNION ALL
								SELECT  COUNT(*) AS CNT FROM #TEMP_EDI_ALL_C
								*/
							) A
							
				    PRINT('EDI_04:'+ CONVERT(NVARCHAR, @CNT)) + convert(varchar(30), getdate(), 121) 

					IF @CNT > 0    
					BEGIN	
						 /* 2024.03.19    kcw3408       DM 프로시저 속도개선: #TEMP_DM_MST_ITEM_SINGLE_V 테이블 변경 */ 
						IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U')	IS NOT NULL  DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V
						IF OBJECT_ID (N'dbo.#TEMP_DM_MST_ITEM_SINGLE_V', N'U')		IS NOT NULL	 DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V

						SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_NAME, ITEM_TYPE   
						INTO #TEMP_DM_MST_ITEM_SINGLE_V  
						FROM 
						(
							SELECT	T1.DIVISION_ID
								  , T1.ITEM_ID
								  , MAX(T1.ITEM_NAME)					AS ITEM_NAME				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
								  , CASE  MIN ( 
												CASE WHEN T1.ITEM_TYPE = 'P' THEN 1					--타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
													 WHEN T1.ITEM_TYPE = 'H' THEN 2					--또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
													 WHEN T1.ITEM_TYPE = 'Q' THEN 3
													 ELSE 4 END 
											  )  
											WHEN 1 THEN 'P' 
											WHEN 2 THEN 'H'
											WHEN 3 THEN 'Q'
											ELSE 'R' 
									END									AS ITEM_TYPE 
							FROM SCM_MST_ITEM_SN T1 WITH(NOLOCK) 
							WHERE	T1.DIVISION_ID = @v_division_id
							AND		T1.ACTIVE_FLAG = 'Y'
							GROUP BY T1.DIVISION_ID, T1.ITEM_ID
						)  A 
						WHERE A.DIVISION_ID = @v_division_id

						CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V] 
							ON [#TEMP_DM_MST_ITEM_SINGLE_V] (division_id ASC, item_id ASC) WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
							 
						IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE', N'U')	IS NOT NULL  DROP TABLE #TEMP_SCM_MST_SITE
						IF OBJECT_ID (N'dbo.#TEMP_SCM_MST_SITE', N'U')		IS NOT NULL	 DROP TABLE #TEMP_SCM_MST_SITE

						SELECT DIVISION_ID,SCM_SITE_ID,END_CUSTOMER,SOLDTO_CUSTOMER,VMI_YN,DEPT_ID,COUNTRY,CITY
						INTO #TEMP_SCM_MST_SITE  
						FROM SCM_MST_SITE  WITH(NOLOCK)
						WHERE SITE_TYPE = 'SALES' 
						AND VALID_YN = 'Y' 
						AND DIVISION_ID = @v_division_id

						IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM', N'U') IS NOT NULL  DROP TABLE #TEMP_SCM_MST_SITE_ITEM
						IF OBJECT_ID (N'dbo.#TEMP_SCM_MST_SITE_ITEM', N'U')		IS NOT NULL	 DROP TABLE #TEMP_SCM_MST_SITE_ITEM

						SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PER_CAR, CELL_PER_MODULE, OWNER, ATTRIBUTE8 
						INTO #TEMP_SCM_MST_SITE_ITEM 
						FROM SCM_MST_SITE_ITEM WITH(NOLOCK)
						WHERE VALID_YN = 'Y' 
						AND DIVISION_ID = @v_division_id

						IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_PROJECT', N'U') IS NOT NULL  DROP TABLE #TEMP_SCM_MST_PROJECT
						IF OBJECT_ID (N'dbo.#TEMP_SCM_MST_PROJECT', N'U')		IS NOT NULL	 DROP TABLE #TEMP_SCM_MST_PROJECT

						SELECT DIVISION_ID, PROJECT_CODE, BIZ_TYPE, PROJECT_NAME, PROJECT_STATUS, PROJECT_OWNER
						INTO #TEMP_SCM_MST_PROJECT
						FROM SCM_MST_PROJECT WITH(NOLOCK)
						WHERE DROP_YN = 'N' 
						AND DIVISION_ID = @v_division_id 

						  
						/* 2024.04.30    kcw3408       고객수요 N:N Mapping  */ 
/* 삭제		-- DM_CUST_MODEL_MAPPING_M 테이블 활용
						BEGIN 
							IF OBJECT_ID (N'tempdb..#TEMP_DM_CUST_ITEM_MAPPING_DTL_N', N'U') IS NOT NULL 
								DROP TABLE #TEMP_DM_CUST_ITEM_MAPPING_DTL_N 
							IF OBJECT_ID(N'dbo.#TEMP_DM_CUST_ITEM_MAPPING_DTL_N', N'U') IS NOT NULL 
								DROP TABLE #TEMP_DM_CUST_ITEM_MAPPING_DTL_N  

								SELECT B.DIVISION_ID
									, B.DATA_TYPE_CODE
									, B.END_CUSTOMER
									, B.SCM_SITE_ID
									, B.PROJECT_CODE
									, B.FCST_TYPE
									, B.INCOTERMS
									, B.DOM_EXP
									, B.ITEM_ID 
									, ISNULL(RTRIM(LTRIM(B.UNLOADING_POINT)),'') AS UNLOADING_POINT 
									, ISNULL(RTRIM(LTRIM(B.CUSTOMER_PLANT)),'') AS CUSTOMER_PLANT	
									, ISNULL(RTRIM(LTRIM(B.CUSTOMER_ITEM_ID)),'') AS CUSTOMER_ITEM_ID 
									, B.VALID_START_DATE
									, B.VALID_END_DATE
									, B.MAPPING_ITEM_ID
								INTO #TEMP_DM_CUST_ITEM_MAPPING_DTL_N
								FROM DM_CUST_ITEM_MAPPING_M A WITH(NOLOCK) 
								JOIN DM_CUST_ITEM_MAPPING_DTL_N B WITH(NOLOCK)
									ON A.DIVISION_ID = B.DIVISION_ID 
									AND A.DATA_TYPE_CODE = B.DATA_TYPE_CODE 
									AND A.END_CUSTOMER = B.END_CUSTOMER 
									AND A.SCM_SITE_ID = B.SCM_SITE_ID 
									AND A.PROJECT_CODE = B.PROJECT_CODE 
									AND A.FCST_TYPE = B.FCST_TYPE 
									AND A.INCOTERMS = B.INCOTERMS 
									AND A.DOM_EXP = B.DOM_EXP 
									AND A.ITEM_ID = B.ITEM_ID 
									--[E20240620-001488]_SCM DM 고객수요분석- CUSTOMER_PLANT, CUSTOMER_ITEM_ID NULL인 데이터 처리로직 개선
									AND ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)),'') = ISNULL(RTRIM(LTRIM(B.UNLOADING_POINT)),'') 
									AND ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),'') = ISNULL(RTRIM(LTRIM(B.CUSTOMER_PLANT)),'') 
									AND ISNULL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)),'') = ISNULL(RTRIM(LTRIM(B.CUSTOMER_ITEM_ID)),'')  
								WHERE A.ACTIVE_YN = 'Y'  
								AND A.DATA_TYPE_CODE = 'EDI'
						END
*/						
					END
				END

				--[E20250313-001202]_Customer Forecast Upload 데이터 오류 수정 START
				--테이블의 컬럼이 변경되면서 한 SCM_SITE_ID기준으로 SOLDTO_CODE, SHIPTO_CODE가 다른건이 여러건 발생
				--하여, 데이터가 더블링되는 현상이 발생하여, MKT FCST와 동일한 형태로 수정한다.
				BEGIN
					IF OBJECT_ID (N'tempdb..#TEMP_DM_CUST_MODEL_MAPPING_M', N'U') IS NOT NULL 
						DROP TABLE #TEMP_DM_CUST_MODEL_MAPPING_M
					IF OBJECT_ID(N'dbo.#TEMP_DM_CUST_MODEL_MAPPING_M', N'U') IS NOT NULL 
						DROP TABLE #TEMP_DM_CUST_MODEL_MAPPING_M

					SELECT DISTINCT 
						   A.DIVISION_ID
						 , A.END_CUSTOMER, A.SCM_SITE_ID, A.PROJECT_CODE
						 , A.FCST_TYPE, A.INCOTERMS, A.DOM_EXP, A.ITEM_ID, A.MAPPING_ITEM_ID							
						 , ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)),'') AS UNLOADING_POINT, ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),'') AS CUSTOMER_PLANT	
						 , ISNULL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)),'') AS CUSTOMER_ITEM_ID 
						 , MAX(A.VALID_START_DATE) AS VALID_START_DATE, MAX(A.VALID_END_DATE) AS VALID_END_DATE
					INTO #TEMP_DM_CUST_MODEL_MAPPING_M
					FROM DM_CUST_MODEL_MAPPING_M A WITH(NOLOCK) 
					WHERE A.ACTIVE_YN = 'Y'  
					GROUP BY A.DIVISION_ID
						 , A.END_CUSTOMER, A.SCM_SITE_ID, A.PROJECT_CODE
						 , A.FCST_TYPE, A.INCOTERMS, A.DOM_EXP, A.ITEM_ID, A.MAPPING_ITEM_ID	 							
						 , ISNULL(RTRIM(LTRIM(A.UNLOADING_POINT)),''), ISNULL(RTRIM(LTRIM(A.CUSTOMER_PLANT)),'')	
						 , ISNULL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)),'') 
				END
				--[E20250313-001202]_Customer Forecast Upload 데이터 오류 수정 END
				
				PRINT('EDI_05:'+ CONVERT(NVARCHAR, @v_accept_flag)) + convert(varchar(30), getdate(), 121) 

				BEGIN
					-- 테이블중복제거
					IF OBJECT_ID (N'tempdb..#TEMP_EDI_CUST_FCST', N'U')				IS NOT NULL	DROP TABLE #TEMP_EDI_CUST_FCST
					IF OBJECT_ID (N'dbo.#TEMP_EDI_CUST_FCST', N'U')					IS NOT NULL	DROP TABLE #TEMP_EDI_CUST_FCST

					IF OBJECT_ID (N'tempdb..#TEMP_QTY_SUM', N'U')				IS NOT NULL	DROP TABLE #TEMP_QTY_SUM
					IF OBJECT_ID (N'dbo.#TEMP_QTY_SUM', N'U')					IS NOT NULL	DROP TABLE #TEMP_QTY_SUM
			
					--#TEMP_EDI_CUST_FCST	
					CREATE TABLE #TEMP_EDI_CUST_FCST	(				
								EDI_IF_SEQ					NVARCHAR(35)	NULL
							   ,SUB_NO						SMALLINT		NULL
							   ,YYYYMMDD					NVARCHAR(8)		NULL
							   ,DIVISION_ID					NVARCHAR(30)	NULL
							   ,SCM_SITE_ID					NVARCHAR(50)	NULL
							   ,ITEM_ID						NVARCHAR(50)	NULL
							   ,PROJECT_CODE				NVARCHAR(50)	NULL
							   ,ERP_FCST_TYPE				NVARCHAR(10)	NULL
							   ,BASIS_YYYYMMDD				NVARCHAR(8)		NULL
							   ,QTY							NVARCHAR(35)	NULL
							   ,EDI_INCOTERMS				NVARCHAR(50)	NULL
							   ,SALES_PLANT_SITE_ID			NVARCHAR(50)	NULL
							   ,DOM_EXP						NVARCHAR(10)	NULL
							   ,COMPANY_ID					NVARCHAR(30)	NULL
							   ,SOLDTO_CODE					NVARCHAR(10)	NULL
							   ,SHIPTO_CODE					NVARCHAR(10)	NULL
							   ,DOC_IDENTIFINER				NVARCHAR(35)	NULL
							   ,MESSAGE_TYPE				NVARCHAR(6)		NULL
							   ,RDD_START					NVARCHAR(35)	NULL
							   ,RDD_END						NVARCHAR(35)	NULL
							   ,IFSEQNO						NVARCHAR(35)	NULL
							   ,SCHEDULING_TYPE				NVARCHAR(3)		NULL
							   ,DELFOR_TYPE					NVARCHAR(30)	NULL
							   ,EDI_LT						INT				NULL
							   ,CUST_MATERIAL_CODE			NVARCHAR(35)	NULL
							   ,CREATE_DATE					NVARCHAR(8)		NULL
							   ,SENDER_CODE					NVARCHAR(10)	NULL
							   ,SENDER_NAME					NVARCHAR(100)	NULL
							   ,CUSTOMER_PLANT				NVARCHAR(100)	NULL
							   ,UNLOADING_POINT				NVARCHAR(100)	NULL
							   ,NICK_NAME					NVARCHAR(100)	NULL
							   ,END_CUSTOMER				NVARCHAR(100)	NULL
							   ,DEPT_NAME_KO				NVARCHAR(100)	NULL
							   ,TEAM_NAME_KO				NVARCHAR(100)	NULL
							   ,SOLDTO_CUSTOMER				NVARCHAR(100)	NULL
							   ,COUNTRY						NVARCHAR(100)	NULL
							   ,CITY						NVARCHAR(100)	NULL
							   ,ITEM_NAME					NVARCHAR(100)	NULL
							   ,ITEM_TYPE					NVARCHAR(100)	NULL
							   ,OWNER						NVARCHAR(100)	NULL
							   ,VMI_YN						NVARCHAR(100)	NULL
							   ,BIZ_TYPE					NVARCHAR(100)	NULL
							   ,PROJECT_NAME				NVARCHAR(100)	NULL
							   ,PROJECT_STATUS				NVARCHAR(100)	NULL
							   ,PROJECT_OWNER				NVARCHAR(100)	NULL
							   ,CELL_PER_CAR				NVARCHAR(100)	NULL
							   ,CELL_PER_MODULE				NVARCHAR(100)	NULL
							   ,MODULE_PER_CAR				NVARCHAR(100)	NULL
							   ,KWH_PER_CELL				NVARCHAR(100)	NULL
							   ,KWH_PER_MODULE				NVARCHAR(100)	NULL
							   ,KWH_PER_PACK				NVARCHAR(100)	NULL							   
							   );

					CREATE TABLE #TEMP_QTY_SUM	(				
								IFSEQNO						NVARCHAR(35)	NULL
							   ,EDI_IF_SEQ					NVARCHAR(35)	NULL
							   ,CREATE_DATE					NVARCHAR(8)		NULL
							   ,DIVISION_ID					NVARCHAR(30)	NULL
							   ,PROJECT_CODE				NVARCHAR(50)	NULL
							   ,ERP_FCST_TYPE				NVARCHAR(10)	NULL
							   ,SCM_SITE_ID					NVARCHAR(50)	NULL
							   ,ITEM_ID						NVARCHAR(50)	NULL
							   ,BASIS_YYYYMMDD				NVARCHAR(8)		NULL
							   ,QTY							NVARCHAR(35)	NULL
							   ,EDI_INCOTERMS				NVARCHAR(50)	NULL
							   ,SALES_PLANT_SITE_ID			NVARCHAR(50)	NULL
							   ,DOM_EXP						NVARCHAR(10)	NULL
							   ,UNLOADING_POINT				NVARCHAR(70)	NULL
							   ,CUST_MATERIAL_CODE			NVARCHAR(70)	NULL
							   );
					   
					DECLARE @i INT = 1 
					SET @CNT = 0;
					------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
					SELECT @CNT = COUNT(*) FROM #TEMP_EDI_ALL		
                    PRINT('EDI_A:'+CONVERT(NVARCHAR, @CNT))

					IF @CNT > 0
					BEGIN
						BEGIN
							INSERT INTO #TEMP_EDI_CUST_FCST ( 
									  EDI_IF_SEQ, SUB_NO, YYYYMMDD, DIVISION_ID, SCM_SITE_ID
									, ITEM_ID, PROJECT_CODE
									, ERP_FCST_TYPE
									, BASIS_YYYYMMDD, QTY, EDI_INCOTERMS, SALES_PLANT_SITE_ID
									, DOM_EXP
									, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE, DOC_IDENTIFINER, MESSAGE_TYPE
									, RDD_START, RDD_END, IFSEQNO, SCHEDULING_TYPE
									, DELFOR_TYPE
									, EDI_LT, CUST_MATERIAL_CODE, CREATE_DATE, SENDER_CODE, SENDER_NAME, CUSTOMER_PLANT, UNLOADING_POINT
									, END_CUSTOMER
									, NICK_NAME
									, DEPT_NAME_KO
									, TEAM_NAME_KO
									, SOLDTO_CUSTOMER
									, COUNTRY
									, CITY, ITEM_NAME, ITEM_TYPE, OWNER, VMI_YN, BIZ_TYPE
									, PROJECT_NAME, PROJECT_STATUS, PROJECT_OWNER
									, CELL_PER_CAR, CELL_PER_MODULE
									, MODULE_PER_CAR
									, KWH_PER_CELL
									, KWH_PER_MODULE
									, KWH_PER_PACK 
							)
							SELECT    A.EDI_IF_SEQ, A.SUB_NO, A.YYYYMMDD, A.DIVISION_ID, A.SCM_SITE_ID
									, A.ITEM_ID, A.PROJECT_CODE
									, CASE WHEN	A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END		AS ERP_FCST_TYPE
									, A.BASIS_YYYYMMDD, A.QTY, A.EDI_INCOTERMS, A.SALES_PLANT_SITE_ID
									, 'E'	AS DOM_EXP
									, A.COMPANY_ID, A.SOLDTO_CODE, A.SHIPTO_CODE, DOC_IDENTIFINER, MESSAGE_TYPE
									, A.RDD_START, RDD_END, IFSEQNO, SCHEDULING_TYPE		
									, CASE WHEN MESSAGE_TYPE = 'DELFOR' AND SOLDTO_CODE = 'FR000064' AND RDD_START <> RDD_END AND RDD_START >= @v_1week_monday THEN 'Periodic DELFOR' 
										   ELSE '' 
									  END															AS DELFOR_TYPE
									, A.EDI_LT, A.CUST_MATERIAL_CODE, A.CREATE_DATE, A.SENDER_CODE, A.SENDER_NAME, A.CUSTOMER_PLANT, A.UNLOADING_POINT
									, C.END_CUSTOMER
									, [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.ITEM_ID)		AS NICK_NAME
									, E.DEPT_NAME_KO												AS DEPT_NAME_KO
									, F.DEPT_NAME_KO												AS TEAM_NAME_KO 
									, C.SOLDTO_CUSTOMER		
									, G.COUNTRY, G.CITY, H.ITEM_NAME, H.ITEM_TYPE, D.OWNER, C.VMI_YN, I.BIZ_TYPE
									, I.PROJECT_NAME, I.PROJECT_STATUS, I.PROJECT_OWNER
									, D.CELL_PER_CAR, D.CELL_PER_MODULE
									, CASE WHEN D.CELL_PER_MODULE  <> 0 THEN D.CELL_PER_CAR / D.CELL_PER_MODULE 
										   ELSE 0 
									  END															AS MODULE_PER_CAR
									, D.ATTRIBUTE8													AS KWH_PER_CELL
									, CASE WHEN (A.DIVISION_ID LIKE '81%' AND D.CELL_PER_MODULE > 0 AND ISNULL(D.ATTRIBUTE8, '''') <> '''') THEN CONVERT(FLOAT,(D.CELL_PER_MODULE * D.ATTRIBUTE8))   
					 					   ELSE NULL 
									  END															AS KWH_PER_MODULE
									, CASE WHEN (A.DIVISION_ID LIKE '81%' AND D.CELL_PER_CAR > 0	AND ISNULL(D.ATTRIBUTE8, '''') <> '''') THEN CONVERT(FLOAT,(D.CELL_PER_CAR * D.ATTRIBUTE8))   
					 					   ELSE NULL 
									  END															AS KWH_PER_PACK
							FROM  (
									/* 
										2024.04.29    kcw3408       고객수요 N:N Mapping 
										전체 대생 추출후 N:N Model Mapping 작업
										.집계 시점에 Cust Item/Unloading Point/Plant 반영
										.Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음 
										. #TEMP_EDI_MKT_FCST_ALL:전체,삭제 작업
										. #TEMP_EDI_MKT_FCST: 최종 결과,insert 작업
									*/
									SELECT   X.EDI_IF_SEQ, X.SUB_NO, X.YYYYMMDD, X.DIVISION_ID, X.SCM_SITE_ID
											, B.MAPPING_ITEM_ID AS ITEM_ID, X.PROJECT_CODE,X.ERP_FCST_TYPE
											, X.BASIS_YYYYMMDD, X.QTY, X.EDI_INCOTERMS, X.SALES_PLANT_SITE_ID 
											, X.COMPANY_ID, X.SOLDTO_CODE, X.SHIPTO_CODE, X.DOC_IDENTIFINER, X.MESSAGE_TYPE
											, X.RDD_START, X.RDD_END, X.IFSEQNO, X.SCHEDULING_TYPE 
											, X.EDI_LT
											, ISNULL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)),'') AS CUST_MATERIAL_CODE
											, ISNULL(RTRIM(LTRIM(X.CUSTOMER_PLANT)),'') AS CUSTOMER_PLANT
											, ISNULL(RTRIM(LTRIM(X.UNLOADING_POINT)),'') AS UNLOADING_POINT
											, X.CREATE_DATE
											, X.SENDER_CODE, X.SENDER_NAME 
									FROM  DM_DNM_EDI_CALLOFF_ITEM  AS X  WITH(NOLOCK)
									--[E20250313-001202]_Customer Forecast Upload 데이터 오류 수정 START
									--JOIN DM_CUST_MODEL_MAPPING_M B WITH (NOLOCK) --원소스 주석처리
									JOIN #TEMP_DM_CUST_MODEL_MAPPING_M B WITH (NOLOCK)
									--[E20250313-001202]_Customer Forecast Upload 데이터 오류 수정 END
										ON X.DIVISION_ID	= B.DIVISION_ID  
										AND X.SCM_SITE_ID	= B.SCM_SITE_ID 
										AND X.PROJECT_CODE	= B.PROJECT_CODE 
										AND X.EDI_INCOTERMS = B.INCOTERMS 
										AND X.ITEM_ID		= B.ITEM_ID 
										--[E20240620-001488]_SCM DM 고객수요분석- CUSTOMER_PLANT, CUSTOMER_ITEM_ID NULL인 데이터 처리로직 개선
										AND ISNULL(RTRIM(LTRIM(X.UNLOADING_POINT)), '')		= ISNULL(RTRIM(LTRIM(B.UNLOADING_POINT)), '') 
										AND ISNULL(RTRIM(LTRIM(X.CUSTOMER_PLANT)), '')		= ISNULL(RTRIM(LTRIM(B.CUSTOMER_PLANT)), '') 
										AND ISNULL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)), '')	= ISNULL(RTRIM(LTRIM(B.CUSTOMER_ITEM_ID)), '')  
									WHERE 1 = 1	
									AND X.BASIS_YYYYMMDD	>= B.VALID_START_DATE
									AND X.BASIS_YYYYMMDD	<= B.VALID_END_DATE
									AND ISNULL(B.MAPPING_ITEM_ID,'') > ''
									AND X.DIVISION_ID = @p_division_id  --[E20251016-001453]_실행하려는 사업부 데이터만 돌리도록 조건 추가
								) A
							LEFT OUTER JOIN #TEMP_SCM_MST_SITE AS C  WITH(NOLOCK)  
								ON A.DIVISION_ID	= C.DIVISION_ID 
								AND A.SCM_SITE_ID	= C.SCM_SITE_ID
							LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM AS D WITH(NOLOCK) 
								ON A.DIVISION_ID	= D.DIVISION_ID
								AND A.PROJECT_CODE	= D.PROJECT_CODE
								AND A.SCM_SITE_ID	= D.SCM_SITE_ID
								AND A.ITEM_ID		= D.ITEM_ID
							LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO E WITH(NOLOCK)
								ON C.DEPT_ID		= E.DEPT_ID
							LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO F WITH(NOLOCK)
								ON E.UPPER_DEPT_ID	= F.DEPT_ID
							LEFT OUTER JOIN SCM_MST_CITY G 
								ON C.COUNTRY		= G.COUNTRY
								AND C.CITY			= G.CITY  
							LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V  H  WITH(NOLOCK)  
								ON A.DIVISION_ID	= H.DIVISION_ID  
								AND A.ITEM_ID		= H.ITEM_ID  
							LEFT OUTER JOIN #TEMP_SCM_MST_PROJECT AS I 
								ON A.DIVISION_ID	= I.DIVISION_ID 
								AND A.PROJECT_CODE	= I.PROJECT_CODE													
						
						END						



						BEGIN
								INSERT INTO #TEMP_QTY_SUM ( 
											 IFSEQNO				
											,EDI_IF_SEQ			
											,CREATE_DATE			
											,DIVISION_ID			
											,PROJECT_CODE		
											,ERP_FCST_TYPE		
											,BASIS_YYYYMMDD	
											,SCM_SITE_ID
											,ITEM_ID
											,QTY					
											,EDI_INCOTERMS		
											,SALES_PLANT_SITE_ID	
											,DOM_EXP
											,UNLOADING_POINT
											,CUST_MATERIAL_CODE
								)
								SELECT		 IFSEQNO				
											,EDI_IF_SEQ			
											,CREATE_DATE			
											,DIVISION_ID			
											,PROJECT_CODE		
											,ERP_FCST_TYPE		
											,BASIS_YYYYMMDD		
											,SCM_SITE_ID
											,ITEM_ID
											,SUM(CAST(REPLACE(QTY, ',', '') AS NUMERIC))		AS QTY		
											,EDI_INCOTERMS		
											,SALES_PLANT_SITE_ID	
											,DOM_EXP
											,UNLOADING_POINT
											,CUST_MATERIAL_CODE
								FROM  #TEMP_EDI_CUST_FCST WITH(NOLOCK)  
								WHERE 1 = 1
								AND DIVISION_ID		= @p_division_id
								AND SCHEDULING_TYPE <> '83'										
								GROUP BY  IFSEQNO, EDI_IF_SEQ, CREATE_DATE, DIVISION_ID, PROJECT_CODE
										, ERP_FCST_TYPE, BASIS_YYYYMMDD, SCM_SITE_ID, ITEM_ID
										, EDI_INCOTERMS, SALES_PLANT_SITE_ID, DOM_EXP
										, UNLOADING_POINT, CUST_MATERIAL_CODE
						END

						BEGIN
							DELETE FROM DM_PLN_CUST_FCST_H
							WHERE EDI_IF_SEQ IN ( SELECT DISTINCT X.EDI_IF_SEQ FROM #TEMP_EDI_CUST_FCST X WITH(NOLOCK));	
						END

						------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
						-- 날짜 중복데이터는 SUM한 값으로 입력
						------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
						BEGIN
							INSERT INTO DM_PLN_CUST_FCST_H (
										  HISTORY_SEQ
										, EDI_IF_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
										, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
										, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
										, CREATE_DATE
										, SENDER_CODE
										, SENDER_NAME
										, END_CUSTOMER
										, CUSTOMER_PLANT
										, UNLOADING_POINT
										, NICK_NAME
										, DEPT_NAME_KO
										, TEAM_NAME_KO 
										, SOLDTO_CUSTOMER
										, COUNTRY		
										, CITY			
										, ITEM_NAME			
										, ITEM_TYPE			
										, OWNER				
										, VMI_YN			
										, BIZ_TYPE		
										, PROJECT_NAME		
										, PROJECT_STATUS	
										, PROJECT_OWNER		
										, CELL_PER_CAR		
										, CELL_PER_MODULE	
										, MODULE_PER_CAR	
										, KWH_PER_CELL		
										, KWH_PER_MODULE	
										, KWH_PER_PACK		
										, SCHEDULING_TYPE
										, CUST_MATERIAL_CODE
										)
								SELECT NEXT VALUE FOR SEQ1_DM_PLN_CUST_FCST_H
										, A.EDI_IF_SEQ, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.ERP_FCST_TYPE
										, A.EDI_INCOTERMS, 'CUST_FCST_EDI', ISNULL(A.SALES_PLANT_SITE_ID, ''), A.BASIS_YYYYMMDD, B.QTY
										, 'EDI', GETDATE(), 'EDI', GETDATE()
										, A.CREATE_DATE
										, A.SENDER_CODE
										, A.SENDER_NAME
										, A.END_CUSTOMER
										, A.CUSTOMER_PLANT
										, A.UNLOADING_POINT
										, A.NICK_NAME
										, A.DEPT_NAME_KO
										, A.TEAM_NAME_KO 
										, A.SOLDTO_CUSTOMER
										, A.COUNTRY		
										, A.CITY			
										, A.ITEM_NAME			
										, A.ITEM_TYPE			
										, A.OWNER				
										, A.VMI_YN			
										, A.BIZ_TYPE		
										, A.PROJECT_NAME		
										, A.PROJECT_STATUS	
										, A.PROJECT_OWNER		
										, A.CELL_PER_CAR		
										, A.CELL_PER_MODULE	
										, A.MODULE_PER_CAR	
										, A.KWH_PER_CELL		
										, A.KWH_PER_MODULE	
										, A.KWH_PER_PACK		
										, A.SCHEDULING_TYPE
										, A.CUST_MATERIAL_CODE
								FROM  #TEMP_EDI_CUST_FCST A WITH(NOLOCK)  
								INNER JOIN #TEMP_QTY_SUM B 
									ON A.IFSEQNO							= B.IFSEQNO 
									AND A.EDI_IF_SEQ						= B.EDI_IF_SEQ 
									AND A.CREATE_DATE						= B.CREATE_DATE 
									AND A.DIVISION_ID						= B.DIVISION_ID 
									AND ISNULL(A.PROJECT_CODE, '')			= ISNULL(B.PROJECT_CODE, '')
									AND ISNULL(A.SCM_SITE_ID, '')			= ISNULL(B.SCM_SITE_ID, '')
									AND ISNULL(A.ITEM_ID, '')				= ISNULL(B.ITEM_ID, '')
									AND A.DOM_EXP							= B.DOM_EXP 
									AND A.ERP_FCST_TYPE						= B.ERP_FCST_TYPE 
									AND A.EDI_INCOTERMS						= B.EDI_INCOTERMS
									AND A.SALES_PLANT_SITE_ID				= B.SALES_PLANT_SITE_ID 
									AND A.BASIS_YYYYMMDD					= B.BASIS_YYYYMMDD
									AND ISNULL(A.UNLOADING_POINT, '')		= ISNULL(B.UNLOADING_POINT, '')
									AND ISNULL(A.CUST_MATERIAL_CODE, '')	= ISNULL(B.CUST_MATERIAL_CODE, '')
								WHERE 1 = 1

						END

						------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
						-- MEASURE별 SUM한 값으로 생성
						------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
						BEGIN
							INSERT INTO DM_PLN_CUST_FCST_H (
										  HISTORY_SEQ
										, EDI_IF_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
										, INCOTERMS
										, MEASURE
										, PLANT_SITE_ID
										, YYYYMMDD
										, QTY
										, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
										, CREATE_DATE
										, SENDER_CODE	-- SENDER_CODE 값 저장
										, SENDER_NAME	-- SENDER_NAME 값 저장
										, END_CUSTOMER
										, CUSTOMER_PLANT
										, UNLOADING_POINT
										, NICK_NAME
										, DEPT_NAME_KO
										, TEAM_NAME_KO 
										, SOLDTO_CUSTOMER
										, COUNTRY		
										, CITY			
										, ITEM_NAME			
										, ITEM_TYPE			
										, OWNER				
										, VMI_YN			
										, BIZ_TYPE		
										, PROJECT_NAME		
										, PROJECT_STATUS	
										, PROJECT_OWNER		
										, CELL_PER_CAR		
										, CELL_PER_MODULE	
										, MODULE_PER_CAR	
										, KWH_PER_CELL		
										, KWH_PER_MODULE	
										, KWH_PER_PACK		
										, SCHEDULING_TYPE
										, CUST_MATERIAL_CODE
										)
								SELECT NEXT VALUE FOR SEQ1_DM_PLN_CUST_FCST_H
										, A.EDI_IF_SEQ , A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.ERP_FCST_TYPE
										, A.EDI_INCOTERMS
										, CASE WHEN A.SCHEDULING_TYPE		= '4'  THEN 'Planning_Forecast'
												  WHEN A.SCHEDULING_TYPE	= '10' THEN 'Immidiate'
												  WHEN A.SCHEDULING_TYPE	= '24' THEN 'Commercial_Agreement'
												  WHEN A.SCHEDULING_TYPE	= '1'  THEN 'Firm_Temp'
												  WHEN A.SCHEDULING_TYPE	= '2'  THEN 'Manumacturing_Material_Temp'
												  WHEN A.SCHEDULING_TYPE	= '3'  THEN 'Material_Temp'
												  WHEN A.SCHEDULING_TYPE	= '83' THEN 'Backorder' 
										  END														AS MEASURE
										, ISNULL(A.SALES_PLANT_SITE_ID, '')							AS PLANT_SITE_ID
										, A.BASIS_YYYYMMDD											AS YYYYMMDD
										, SUM(CAST(REPLACE(A.QTY, ',', '') AS NUMERIC))				AS QTY	
										, 'EDI', GETDATE(), 'EDI', GETDATE()
										, A.CREATE_DATE
										, A.SENDER_CODE
										, A.SENDER_NAME
										, A.END_CUSTOMER
										, A.CUSTOMER_PLANT
										, A.UNLOADING_POINT
										, A.NICK_NAME
										, A.DEPT_NAME_KO
										, A.TEAM_NAME_KO 
										, A.SOLDTO_CUSTOMER
										, A.COUNTRY		
										, A.CITY			
										, A.ITEM_NAME			
										, A.ITEM_TYPE			
										, A.OWNER				
										, A.VMI_YN			
										, A.BIZ_TYPE		
										, A.PROJECT_NAME		
										, A.PROJECT_STATUS	
										, A.PROJECT_OWNER		
										, A.CELL_PER_CAR		
										, A.CELL_PER_MODULE	
										, A.MODULE_PER_CAR	
										, A.KWH_PER_CELL		
										, A.KWH_PER_MODULE	
										, A.KWH_PER_PACK		
										, A.SCHEDULING_TYPE
										, A.CUST_MATERIAL_CODE
								FROM  #TEMP_EDI_CUST_FCST A WITH(NOLOCK)
								WHERE 1 = 1
								AND A.SCHEDULING_TYPE is not null  --20240507 임시
								GROUP BY  A.EDI_IF_SEQ , A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.ERP_FCST_TYPE
										, A.EDI_INCOTERMS, A.SCHEDULING_TYPE, ISNULL(A.SALES_PLANT_SITE_ID, ''), A.BASIS_YYYYMMDD, A.CREATE_DATE
										, A.SENDER_CODE, A.SENDER_NAME, A.END_CUSTOMER, A.CUSTOMER_PLANT, A.UNLOADING_POINT
										, A.NICK_NAME, A.DEPT_NAME_KO, A.TEAM_NAME_KO, A.SOLDTO_CUSTOMER, A.COUNTRY, A.CITY			
										, A.ITEM_NAME, A.ITEM_TYPE, A.OWNER, A.VMI_YN, A.BIZ_TYPE, A.PROJECT_NAME, A.PROJECT_STATUS, A.PROJECT_OWNER		
										, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR, A.KWH_PER_CELL, A.KWH_PER_MODULE, A.KWH_PER_PACK		
										, A.SCHEDULING_TYPE, A.CUST_MATERIAL_CODE
						END 

					END

				END

				/* 현시점에서는 불필요.. 2025.01.16
				BEGIN

					-- 테이블중복제거
					IF OBJECT_ID (N'tempdb..#TEMP_EDI_CUST_FCST_C', N'U')		IS NOT NULL	DROP TABLE #TEMP_EDI_CUST_FCST_C
					IF OBJECT_ID (N'dbo.#TEMP_EDI_CUST_FCST_C', N'U')			IS NOT NULL	DROP TABLE #TEMP_EDI_CUST_FCST_C

					IF OBJECT_ID (N'tempdb..#TEMP_QTY_SUM_C', N'U')				IS NOT NULL	DROP TABLE #TEMP_QTY_SUM_C
					IF OBJECT_ID (N'dbo.#TEMP_QTY_SUM_C', N'U')					IS NOT NULL	DROP TABLE #TEMP_QTY_SUM_C
			
					--#TEMP_EDI_CUST_FCST_C
					CREATE TABLE #TEMP_EDI_CUST_FCST_C	(				
								EDI_IF_SEQ					NVARCHAR(35)	NULL
							   ,SUB_NO						SMALLINT		NULL
							   ,YYYYMMDD					NVARCHAR(8)		NULL
							   ,DIVISION_ID					NVARCHAR(30)	NULL
							   ,SCM_SITE_ID					NVARCHAR(50)	NULL
							   ,ITEM_ID						NVARCHAR(50)	NULL
							   ,PROJECT_CODE				NVARCHAR(50)	NULL
							   ,ERP_FCST_TYPE				NVARCHAR(10)	NULL
							   ,BASIS_YYYYMMDD				NVARCHAR(8)		NULL
							   ,QTY							NVARCHAR(35)	NULL
							   ,EDI_INCOTERMS				NVARCHAR(50)	NULL
							   ,SALES_PLANT_SITE_ID			NVARCHAR(50)	NULL
							   ,DOM_EXP						NVARCHAR(10)	NULL
							   ,COMPANY_ID					NVARCHAR(30)	NULL
							   ,SOLDTO_CODE					NVARCHAR(10)	NULL
							   ,SHIPTO_CODE					NVARCHAR(10)	NULL
							   ,DOC_IDENTIFINER				NVARCHAR(35)	NULL
							   ,MESSAGE_TYPE				NVARCHAR(6)		NULL
							   ,RDD_START					NVARCHAR(35)	NULL
							   ,RDD_END						NVARCHAR(35)	NULL
							   ,IFSEQNO						NVARCHAR(35)	NULL
							   ,SCHEDULING_TYPE				NVARCHAR(3)		NULL
							   ,DELFOR_TYPE					NVARCHAR(30)	NULL
							   ,EDI_LT						INT				NULL
							   ,CUST_MATERIAL_CODE			NVARCHAR(35)	NULL
							   ,CREATE_DATE					NVARCHAR(8)		NULL
							   ,SENDER_CODE					NVARCHAR(10)	NULL
							   ,SENDER_NAME					NVARCHAR(100)	NULL
							   ,CUSTOMER_PLANT				NVARCHAR(100)	NULL
							   ,UNLOADING_POINT				NVARCHAR(100)	NULL
							   ,NICK_NAME					NVARCHAR(100)	NULL
							   ,END_CUSTOMER				NVARCHAR(100)	NULL
							   ,DEPT_NAME_KO				NVARCHAR(100)	NULL
							   ,TEAM_NAME_KO				NVARCHAR(100)	NULL
							   ,SOLDTO_CUSTOMER				NVARCHAR(100)	NULL
							   ,COUNTRY						NVARCHAR(100)	NULL
							   ,CITY						NVARCHAR(100)	NULL
							   ,ITEM_NAME					NVARCHAR(100)	NULL
							   ,ITEM_TYPE					NVARCHAR(100)	NULL
							   ,OWNER						NVARCHAR(100)	NULL
							   ,VMI_YN						NVARCHAR(100)	NULL
							   ,BIZ_TYPE					NVARCHAR(100)	NULL
							   ,PROJECT_NAME				NVARCHAR(100)	NULL
							   ,PROJECT_STATUS				NVARCHAR(100)	NULL
							   ,PROJECT_OWNER				NVARCHAR(100)	NULL
							   ,CELL_PER_CAR				NVARCHAR(100)	NULL
							   ,CELL_PER_MODULE				NVARCHAR(100)	NULL
							   ,MODULE_PER_CAR				NVARCHAR(100)	NULL
							   ,KWH_PER_CELL				NVARCHAR(100)	NULL
							   ,KWH_PER_MODULE				NVARCHAR(100)	NULL
							   ,KWH_PER_PACK				NVARCHAR(100)	NULL							   
							   );

					CREATE TABLE #TEMP_QTY_SUM_C	(				
								IFSEQNO						NVARCHAR(35)	NULL
							   ,EDI_IF_SEQ					NVARCHAR(35)	NULL
							   ,CREATE_DATE					NVARCHAR(8)		NULL
							   ,DIVISION_ID					NVARCHAR(30)	NULL
							   ,PROJECT_CODE				NVARCHAR(50)	NULL
							   ,ERP_FCST_TYPE				NVARCHAR(10)	NULL
							   ,SCM_SITE_ID					NVARCHAR(50)	NULL
							   ,ITEM_ID						NVARCHAR(50)	NULL
							   ,BASIS_YYYYMMDD				NVARCHAR(8)		NULL
							   ,QTY							NVARCHAR(35)	NULL
							   ,EDI_INCOTERMS				NVARCHAR(50)	NULL
							   ,SALES_PLANT_SITE_ID			NVARCHAR(50)	NULL
							   ,DOM_EXP						NVARCHAR(10)	NULL
							   ,UNLOADING_POINT				NVARCHAR(70)	NULL
							   ,CUST_MATERIAL_CODE			NVARCHAR(70)	NULL
							   );
					
					SET @i = 1;
					SET @CNT = 0;
					------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
					SELECT @CNT = COUNT(*) FROM #TEMP_EDI_ALL_C
PRINT('EDI_C:'+CONVERT(NVARCHAR, @CNT))

					IF @CNT > 0
					BEGIN
						BEGIN

							INSERT INTO #TEMP_EDI_CUST_FCST_C ( 
										  EDI_IF_SEQ, SUB_NO, YYYYMMDD, DIVISION_ID, SCM_SITE_ID
										, ITEM_ID, PROJECT_CODE
										, ERP_FCST_TYPE
										, BASIS_YYYYMMDD, QTY, EDI_INCOTERMS, SALES_PLANT_SITE_ID
										, DOM_EXP
										, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE, DOC_IDENTIFINER, MESSAGE_TYPE
										, RDD_START, RDD_END, IFSEQNO, SCHEDULING_TYPE
										, DELFOR_TYPE
										, EDI_LT, CUST_MATERIAL_CODE, CREATE_DATE
										, SENDER_CODE, SENDER_NAME, CUSTOMER_PLANT, UNLOADING_POINT
										, END_CUSTOMER
										, NICK_NAME
										, DEPT_NAME_KO
										, TEAM_NAME_KO
										, SOLDTO_CUSTOMER
										, COUNTRY, CITY, ITEM_NAME, ITEM_TYPE, OWNER, VMI_YN, BIZ_TYPE
										, PROJECT_NAME, PROJECT_STATUS, PROJECT_OWNER
										, CELL_PER_CAR, CELL_PER_MODULE
										, MODULE_PER_CAR
										, KWH_PER_CELL
										, KWH_PER_MODULE
										, KWH_PER_PACK 
							)
							SELECT    A.EDI_IF_SEQ, A.SUB_NO, A.YYYYMMDD, A.DIVISION_ID, A.SCM_SITE_ID
									, A.ITEM_ID, A.PROJECT_CODE
									, CASE WHEN A.ERP_FCST_TYPE  = 'S' THEN 'SMC' ELSE 'MPS' END			AS ERP_FCST_TYPE
									, A.BASIS_YYYYMMDD, A.QTY, A.EDI_INCOTERMS, A.SALES_PLANT_SITE_ID
									, 'E' AS DOM_EXP
									, A.COMPANY_ID, A.SOLDTO_CODE, A.SHIPTO_CODE, DOC_IDENTIFINER, MESSAGE_TYPE
									, A.RDD_START, RDD_END, IFSEQNO, SCHEDULING_TYPE		
									, CASE WHEN MESSAGE_TYPE = 'DELFOR' AND SOLDTO_CODE = 'FR000064' AND RDD_START <> RDD_END AND RDD_START >= @v_1week_monday THEN 'Periodic DELFOR' 
										   ELSE '' 
									  END																	AS DELFOR_TYPE
									, A.EDI_LT, A.CUST_MATERIAL_CODE, A.CREATE_DATE
									, A.SENDER_CODE, A.SENDER_NAME, A.CUSTOMER_PLANT, A.UNLOADING_POINT
									, C.END_CUSTOMER
									, [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
									, E.DEPT_NAME_KO														AS DEPT_NAME_KO
									, F.DEPT_NAME_KO														AS TEAM_NAME_KO 
									, C.SOLDTO_CUSTOMER		
									, G.COUNTRY, G.CITY, H.ITEM_NAME, H.ITEM_TYPE, D.OWNER, C.VMI_YN, I.BIZ_TYPE
									, I.PROJECT_NAME, I.PROJECT_STATUS, I.PROJECT_OWNER
									, D.CELL_PER_CAR, D.CELL_PER_MODULE
									, CASE WHEN D.CELL_PER_MODULE  <> 0 THEN D.CELL_PER_CAR / D.CELL_PER_MODULE ELSE 0 END					AS MODULE_PER_CAR
									, D.ATTRIBUTE8																							AS KWH_PER_CELL
									, CASE WHEN A.DIVISION_ID LIKE '81%' AND D.CELL_PER_MODULE > 0 AND ISNULL(D.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT,(D.CELL_PER_MODULE * D.ATTRIBUTE8))   
				 						   ELSE NULL 
									  END																									AS KWH_PER_MODULE
									, CASE WHEN A.DIVISION_ID LIKE '81%' AND D.CELL_PER_CAR > 0 AND ISNULL(D.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT,(D.CELL_PER_CAR * D.ATTRIBUTE8))   
					 					   ELSE NULL 
									  END																									AS KWH_PER_PACK
							FROM   (
										/* 
											2024.04.29    kcw3408       고객수요 N:N Mapping 
											전체 대생 추출후 N:N Model Mapping 작업
											.집계 시점에 Cust Item/Unloading Point/Plant 반영
											.Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음 
											. #TEMP_EDI_MKT_FCST_ALL:전체,삭제 작업
											. #TEMP_EDI_MKT_FCST: 최종 결과,insert 작업
										*/
									SELECT    X.EDI_IF_SEQ, X.SUB_NO, X.YYYYMMDD, X.DIVISION_ID, X.SCM_SITE_ID
											, B.MAPPING_ITEM_ID									AS ITEM_ID
											, X.PROJECT_CODE,X.ERP_FCST_TYPE
											, X.BASIS_YYYYMMDD, X.QTY, X.EDI_INCOTERMS, X.SALES_PLANT_SITE_ID 
											, X.COMPANY_ID, X.SOLDTO_CODE, X.SHIPTO_CODE, X.DOC_IDENTIFINER, X.MESSAGE_TYPE
											, X.RDD_START, X.RDD_END, X.IFSEQNO, X.SCHEDULING_TYPE 
											, X.EDI_LT
											, ISNULL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)),'')		AS CUST_MATERIAL_CODE
											, ISNULL(RTRIM(LTRIM(X.CUSTOMER_PLANT)),'')			AS CUSTOMER_PLANT
											, ISNULL(RTRIM(LTRIM(X.UNLOADING_POINT)),'')		AS UNLOADING_POINT
											, X.CREATE_DATE
											, X.SENDER_CODE, X.SENDER_NAME  
										FROM  DM_DNM_EDI_CALLOFF_ITEM  AS X  WITH(NOLOCK)
										JOIN DM_CUST_MODEL_MAPPING_M B WITH (NOLOCK)
											ON X.DIVISION_ID	= B.DIVISION_ID  
											AND X.SCM_SITE_ID	= B.SCM_SITE_ID 
											AND X.PROJECT_CODE	= B.PROJECT_CODE 
											AND X.EDI_INCOTERMS = B.INCOTERMS 
											AND X.ITEM_ID		= B.ITEM_ID 
											--[E20240620-001488]_SCM DM 고객수요분석- CUSTOMER_PLANT, CUSTOMER_ITEM_ID NULL인 데이터 처리로직 개선
											AND ISNULL(RTRIM(LTRIM(X.UNLOADING_POINT)), '')		= ISNULL(RTRIM(LTRIM(B.UNLOADING_POINT)), '') 
											AND ISNULL(RTRIM(LTRIM(X.CUSTOMER_PLANT)), '')		= ISNULL(RTRIM(LTRIM(B.CUSTOMER_PLANT)), '') 
											AND ISNULL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)), '')	= ISNULL(RTRIM(LTRIM(B.CUSTOMER_ITEM_ID)), '')   
										WHERE 1 = 1	
											AND X.BASIS_YYYYMMDD >= B.VALID_START_DATE
											AND X.BASIS_YYYYMMDD <= B.VALID_END_DATE
											AND ISNULL(B.MAPPING_ITEM_ID,'') > '' 		
									) A
							LEFT OUTER JOIN #TEMP_SCM_MST_SITE AS C  WITH(NOLOCK)   
								ON A.DIVISION_ID	= C.DIVISION_ID 
								AND A.SCM_SITE_ID	= C.SCM_SITE_ID
							LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM AS D WITH(NOLOCK) 
								ON A.DIVISION_ID	= D.DIVISION_ID
								AND A.PROJECT_CODE	= D.PROJECT_CODE
								AND A.SCM_SITE_ID	= D.SCM_SITE_ID
								AND A.ITEM_ID		= D.ITEM_ID
							LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO E WITH(NOLOCK)
								ON C.DEPT_ID		= E.DEPT_ID
							LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO F WITH(NOLOCK)
								ON E.UPPER_DEPT_ID	= F.DEPT_ID
							LEFT OUTER JOIN SCM_MST_CITY G 
								ON C.COUNTRY		= G.COUNTRY
								AND C.CITY			= G.CITY  
							LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V H WITH(NOLOCK)    
								ON A.DIVISION_ID	= H.DIVISION_ID  
								AND A.ITEM_ID		= H.ITEM_ID   
							LEFT OUTER JOIN #TEMP_SCM_MST_PROJECT AS I  
								ON A.DIVISION_ID	= I.DIVISION_ID 
								AND A.PROJECT_CODE	= I.PROJECT_CODE	 	

						END

						BEGIN
								INSERT INTO #TEMP_QTY_SUM_C
											( IFSEQNO				
											,EDI_IF_SEQ			
											,CREATE_DATE			
											,DIVISION_ID			
											,PROJECT_CODE		
											,ERP_FCST_TYPE		
											,BASIS_YYYYMMDD	
											,SCM_SITE_ID
											,ITEM_ID
											,QTY					
											,EDI_INCOTERMS		
											,SALES_PLANT_SITE_ID	
											,DOM_EXP
											,UNLOADING_POINT
											,CUST_MATERIAL_CODE)
								SELECT   IFSEQNO				
											,EDI_IF_SEQ			
											,CREATE_DATE			
											,DIVISION_ID			
											,PROJECT_CODE		
											,ERP_FCST_TYPE		
											,BASIS_YYYYMMDD		
											,SCM_SITE_ID
											,ITEM_ID
											,SUM(CAST(REPLACE(QTY, ',', '') AS NUMERIC))	AS QTY	
											,EDI_INCOTERMS		
											,SALES_PLANT_SITE_ID	
											,DOM_EXP
											,UNLOADING_POINT
											,CUST_MATERIAL_CODE
								FROM  #TEMP_EDI_CUST_FCST_C WITH(NOLOCK)  
								WHERE 1 = 1
								AND DIVISION_ID		= @p_division_id
								AND SCHEDULING_TYPE <> '83'										
								GROUP BY IFSEQNO, EDI_IF_SEQ, CREATE_DATE, DIVISION_ID, PROJECT_CODE
										, ERP_FCST_TYPE, BASIS_YYYYMMDD, SCM_SITE_ID, ITEM_ID
										, EDI_INCOTERMS, SALES_PLANT_SITE_ID, DOM_EXP
										, UNLOADING_POINT, CUST_MATERIAL_CODE
						END

						BEGIN
							DELETE FROM DM_PLN_CUST_FCST_H
							WHERE EDI_IF_SEQ IN ( SELECT DISTINCT X.EDI_IF_SEQ FROM #TEMP_EDI_CUST_FCST_C X WITH(NOLOCK));			
						END

						------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
						-- 날짜 중복데이터는 SUM한 값으로 입력
						------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
						BEGIN
							INSERT INTO DM_PLN_CUST_FCST_H (
										  HISTORY_SEQ
										, EDI_IF_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
										, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
										, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
										, CREATE_DATE
										, SENDER_CODE
										, SENDER_NAME
										, END_CUSTOMER
										, CUSTOMER_PLANT
										, UNLOADING_POINT
										, NICK_NAME
										, DEPT_NAME_KO
										, TEAM_NAME_KO 
										, SOLDTO_CUSTOMER
										, COUNTRY		
										, CITY			
										, ITEM_NAME			
										, ITEM_TYPE			
										, OWNER				
										, VMI_YN			
										, BIZ_TYPE		
										, PROJECT_NAME		
										, PROJECT_STATUS	
										, PROJECT_OWNER		
										, CELL_PER_CAR		
										, CELL_PER_MODULE	
										, MODULE_PER_CAR	
										, KWH_PER_CELL		
										, KWH_PER_MODULE	
										, KWH_PER_PACK		
										, SCHEDULING_TYPE
										, CUST_MATERIAL_CODE
										)
								SELECT NEXT VALUE FOR SEQ1_DM_PLN_CUST_FCST_H
										, A.EDI_IF_SEQ, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.ERP_FCST_TYPE
										, A.EDI_INCOTERMS, 'CUST_FCST_EDI', ISNULL(A.SALES_PLANT_SITE_ID, ''), A.BASIS_YYYYMMDD, B.QTY
										, 'EDI', GETDATE(), 'EDI', GETDATE()
										, A.CREATE_DATE
										, A.SENDER_CODE
										, A.SENDER_NAME
										, A.END_CUSTOMER
										, A.CUSTOMER_PLANT
										, A.UNLOADING_POINT
										, A.NICK_NAME
										, A.DEPT_NAME_KO
										, A.TEAM_NAME_KO 
										, A.SOLDTO_CUSTOMER
										, A.COUNTRY		
										, A.CITY			
										, A.ITEM_NAME			
										, A.ITEM_TYPE			
										, A.OWNER				
										, A.VMI_YN			
										, A.BIZ_TYPE		
										, A.PROJECT_NAME		
										, A.PROJECT_STATUS	
										, A.PROJECT_OWNER		
										, A.CELL_PER_CAR		
										, A.CELL_PER_MODULE	
										, A.MODULE_PER_CAR	
										, A.KWH_PER_CELL		
										, A.KWH_PER_MODULE	
										, A.KWH_PER_PACK		
										, A.SCHEDULING_TYPE
										, A.CUST_MATERIAL_CODE
								FROM  #TEMP_EDI_CUST_FCST_C A WITH(NOLOCK)  
								INNER JOIN #TEMP_QTY_SUM_C B 
									ON A.IFSEQNO		= B.IFSEQNO 
									AND A.EDI_IF_SEQ	= B.EDI_IF_SEQ 
									AND A.CREATE_DATE	= B.CREATE_DATE 
									AND A.DIVISION_ID	= B.DIVISION_ID 
									AND ISNULL(A.PROJECT_CODE, '')			= ISNULL(B.PROJECT_CODE, '')
									AND ISNULL(A.SCM_SITE_ID, '')			= ISNULL(B.SCM_SITE_ID, '')
									AND ISNULL(A.ITEM_ID, '')				= ISNULL(B.ITEM_ID, '')
									AND A.DOM_EXP							= B.DOM_EXP 
									AND A.ERP_FCST_TYPE						= B.ERP_FCST_TYPE 
									AND A.EDI_INCOTERMS						= B.EDI_INCOTERMS
									AND A.SALES_PLANT_SITE_ID				= B.SALES_PLANT_SITE_ID 
									AND A.BASIS_YYYYMMDD					= B.BASIS_YYYYMMDD
									AND ISNULL(A.UNLOADING_POINT, '')		= ISNULL(B.UNLOADING_POINT, '')
									AND ISNULL(A.CUST_MATERIAL_CODE, '')	= ISNULL(B.CUST_MATERIAL_CODE, '')
								WHERE 1 = 1

						END

						------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
						-- MEASURE별 SUM한 값으로 생성
						------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
						BEGIN
							INSERT INTO DM_PLN_CUST_FCST_H (
										  HISTORY_SEQ
										, EDI_IF_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
										, INCOTERMS
										, MEASURE
										, PLANT_SITE_ID, YYYYMMDD, QTY
										, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
										, CREATE_DATE
										, SENDER_CODE	-- SENDER_CODE 값 저장
										, SENDER_NAME	-- SENDER_NAME 값 저장
										, END_CUSTOMER
										, CUSTOMER_PLANT
										, UNLOADING_POINT
										, NICK_NAME
										, DEPT_NAME_KO
										, TEAM_NAME_KO 
										, SOLDTO_CUSTOMER
										, COUNTRY		
										, CITY			
										, ITEM_NAME			
										, ITEM_TYPE			
										, OWNER				
										, VMI_YN			
										, BIZ_TYPE		
										, PROJECT_NAME		
										, PROJECT_STATUS	
										, PROJECT_OWNER		
										, CELL_PER_CAR		
										, CELL_PER_MODULE	
										, MODULE_PER_CAR	
										, KWH_PER_CELL		
										, KWH_PER_MODULE	
										, KWH_PER_PACK		
										, SCHEDULING_TYPE
										, CUST_MATERIAL_CODE
										)
								SELECT NEXT VALUE FOR SEQ1_DM_PLN_CUST_FCST_H
										, A.EDI_IF_SEQ , A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.ERP_FCST_TYPE
										, A.EDI_INCOTERMS
										, CASE WHEN A.SCHEDULING_TYPE = '4'  THEN 'Planning_Forecast'
												  WHEN A.SCHEDULING_TYPE = '10' THEN 'Immidiate'
												  WHEN A.SCHEDULING_TYPE = '24' THEN 'Commercial_Agreement'
												  WHEN A.SCHEDULING_TYPE = '1' THEN 'Firm_Temp'
												  WHEN A.SCHEDULING_TYPE = '2' THEN 'Manumacturing_Material_Temp'
												  WHEN A.SCHEDULING_TYPE = '3' THEN 'Material_Temp'
												  WHEN A.SCHEDULING_TYPE = '83' THEN 'Backorder' 
										  END													AS MEASURE
										, ISNULL(A.SALES_PLANT_SITE_ID, '')
										, A.BASIS_YYYYMMDD
										, SUM(CAST(REPLACE(A.QTY, ',', '') AS NUMERIC))			AS QTY
										, 'EDI', GETDATE(), 'EDI', GETDATE()
										, A.CREATE_DATE
										, A.SENDER_CODE
										, A.SENDER_NAME
										, A.END_CUSTOMER
										, A.CUSTOMER_PLANT
										, A.UNLOADING_POINT
										, A.NICK_NAME
										, A.DEPT_NAME_KO
										, A.TEAM_NAME_KO 
										, A.SOLDTO_CUSTOMER
										, A.COUNTRY		
										, A.CITY			
										, A.ITEM_NAME			
										, A.ITEM_TYPE			
										, A.OWNER				
										, A.VMI_YN			
										, A.BIZ_TYPE		
										, A.PROJECT_NAME		
										, A.PROJECT_STATUS	
										, A.PROJECT_OWNER		
										, A.CELL_PER_CAR		
										, A.CELL_PER_MODULE	
										, A.MODULE_PER_CAR	
										, A.KWH_PER_CELL		
										, A.KWH_PER_MODULE	
										, A.KWH_PER_PACK		
										, A.SCHEDULING_TYPE
										, A.CUST_MATERIAL_CODE
								FROM  #TEMP_EDI_CUST_FCST_C A WITH(NOLOCK)
								WHERE 1 = 1
								AND   A.SCHEDULING_TYPE is not null  --20240507 임시
								GROUP BY A.EDI_IF_SEQ , A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.ERP_FCST_TYPE
										, A.EDI_INCOTERMS, A.SCHEDULING_TYPE, ISNULL(A.SALES_PLANT_SITE_ID, ''), A.BASIS_YYYYMMDD, A.CREATE_DATE
										, A.SENDER_CODE, A.SENDER_NAME, A.END_CUSTOMER, A.CUSTOMER_PLANT, A.UNLOADING_POINT
										, A.NICK_NAME, A.DEPT_NAME_KO, A.TEAM_NAME_KO, A.SOLDTO_CUSTOMER, A.COUNTRY, A.CITY			
										, A.ITEM_NAME, A.ITEM_TYPE, A.OWNER, A.VMI_YN, A.BIZ_TYPE, A.PROJECT_NAME, A.PROJECT_STATUS, A.PROJECT_OWNER		
										, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR, A.KWH_PER_CELL, A.KWH_PER_MODULE, A.KWH_PER_PACK		
										, A.SCHEDULING_TYPE, A.CUST_MATERIAL_CODE
						END
									
					END	
				END		 
				*/

			 END    
				--******************** EDI DATA 생성 END ********************	


			IF @v_accept_flag = 'RPA'

				BEGIN

					BEGIN
						DELETE FROM DM_PLN_CUST_FCST_H
						WHERE MEASURE IN ('CUST_FCST', 'Customer FCST')
						AND DIVISION_ID = @v_division_id
						AND LAST_UPDATE_DATE >= CONVERT(DATETIME, @v_from_date)
					END

PRINT ('RPA_A:'+  ' @v_division_id:' + @v_division_id +  ', @v_accept_flag:' + @v_accept_flag +  ', @@v_from_date:' + @v_from_date)		

					IF (@v_division_id = '40')						

						BEGIN
							INSERT INTO DM_PLN_CUST_FCST_H
										(HISTORY_SEQ
										, EDI_IF_SEQ
										, DIVISION_ID
										, PROJECT_CODE
										, SCM_SITE_ID
										, ITEM_ID
										, DOM_EXP
										, FCST_TYPE
										, INCOTERMS
										, MEASURE
										, PLANT_SITE_ID
										, YYYYMMDD, QTY
										, CREATED_BY
										, CREATION_DATE
										, LAST_UPDATED_BY
										, LAST_UPDATE_DATE
										, CREATE_DATE
										, SENDER_CODE
										, SENDER_NAME
										, END_CUSTOMER
										, CUSTOMER_PLANT
										, UNLOADING_POINT
										, NICK_NAME
										, DEPT_NAME_KO
										, TEAM_NAME_KO 
										, SOLDTO_CUSTOMER
										, COUNTRY		
										, CITY			
										, ITEM_NAME			
										, ITEM_TYPE			
										, OWNER				
										, VMI_YN			
										, BIZ_TYPE		
										, PROJECT_NAME		
										, PROJECT_STATUS	
										, PROJECT_OWNER		
										, CELL_PER_CAR		
										, CELL_PER_MODULE	
										, MODULE_PER_CAR	
										, KWH_PER_CELL		
										, KWH_PER_MODULE	
										, KWH_PER_PACK		
										, SCHEDULING_TYPE
										)
							   SELECT NEXT VALUE FOR SEQ1_DM_PLN_CUST_FCST_H
										, ''									AS EDI_IF_SEQ
										, AA.DIVISION_ID
										, ''									AS PROJECT_CODE
										, AA.SCM_SITE_ID
										, AA.ITEM_ID
										, AA.DOM_EXP
										, AA.FCST_TYPE
										, AA.INCOTERMS
										, AA.MEASURE
										, AA.PLANT_SITE_ID
										, AA.YYYYMMDD
										, IIF(AA.QTY IS NULL , NULL,  CONVERT(NUMERIC(30, 10), AA.QTY))		AS QTY
										, AA.CREATED_BY
										, CREATION_DATE
										, LAST_UPDATED_BY
										, LAST_UPDATE_DATE
										, AA.CREATE_DATE
										, AA.SENDER_CODE
										, AA.SENDER_NAME
										, AA.END_CUSTOMER
										, AA.CUSTOMER_PLANT
										, AA.UNLOADING_POINT
										, AA.NICK_NAME
										, AA.DEPT_NAME_KO
										, AA.TEAM_NAME_KO 
										, AA.SOLDTO_CUSTOMER
										, AA.COUNTRY_NAME	
										, AA.CITY_NAME	
										, AA.ITEM_NAME			
										, AA.ITEM_TYPE			
										, AA.OWNER				
										, AA.VMI_YN			
										, AA.BIZ_TYPE_NAME		
										, AA.PROJECT_NAME		
										, AA.PROJECT_STATUS	
										, AA.PROJECT_OWNER		
										, ISNULL(AA.CELL_PER_CAR, 0)		AS CELL_PER_CAR
										, ISNULL(AA.CELL_PER_MODULE, 0)		AS CELL_PER_MODULE
										, ISNULL(AA.MODULE_PER_CAR, 0)		AS MODULE_PER_CAR
										, 0									AS  KWH_PER_CELL		--ISNULL(CONVERT(NUMERIC(30, 10), AA.KWH_PER_CELL)), 0)
										, ISNULL(AA.KWH_PER_MODULE, 0)		AS KWH_PER_MODULE
										, ISNULL(AA.KWH_PER_PACK, 0)		AS KWH_PER_PACK
										, ''
							   FROM (
										  SELECT DISTINCT A.DIVISION_ID
												   , ''						AS SENDER_CODE
												   , ''						AS SENDER_NAME
												   , A.YYYYMMDD
												   , ''						AS CUSTOMER_PLANT
												   , ''						AS UNLOADING_POINT
												   , ''						AS CUST_MATERIAL_CODE
												   , C.END_CUSTOMER
												   , A.SCM_SITE_ID
												   , A.ITEM_ID
												   , [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
												   , A.INCOTERMS
												   , A.FCST_TYPE
												   , A.DOM_EXP 
												   , E.DEPT_NAME_KO			AS DEPT_NAME_KO
												   , F.DEPT_NAME_KO			AS TEAM_NAME_KO 
												   , C.SOLDTO_CUSTOMER		
												   , G.COUNTRY_NAME
												   , G.CITY_NAME
												   , H.ITEM_NAME
												   , H.ITEM_TYPE
												   , D.OWNER
												   , C.VMI_YN
												   , I.BIZ_TYPE_NAME
												   , A.PROJECT_CODE
												   , I.PROJECT_NAME
												   , I.PROJECT_STATUS
												   , I.PROJECT_OWNER
												   , A.PLANT_SITE_ID AS PLANT_SITE_ID
												   , D.CELL_PER_CAR
												   , D.CELL_PER_MODULE
												   , (CASE WHEN D.CELL_PER_MODULE <> 0 THEN D.CELL_PER_CAR / D.CELL_PER_MODULE ELSE 0 END) AS MODULE_PER_CAR
												   , ''						AS SOLDTO_CODE
												   , ''						AS COMPANY_ID
												   , D.ATTRIBUTE8 AS KWH_PER_CELL
												   , CASE WHEN A.DIVISION_ID = @v_division_id AND D.CELL_PER_MODULE > 0 AND ISNULL(D.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT, (D.CELL_PER_MODULE * D.ATTRIBUTE8))   
														  ELSE NULL 
													 END					AS KWH_PER_MODULE
												   , CASE WHEN A.DIVISION_ID = @v_division_id AND D.CELL_PER_CAR > 0 AND ISNULL(D.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT, (D.CELL_PER_CAR * D.ATTRIBUTE8))   
														  ELSE NULL 
													 END					AS KWH_PER_PACK
												   , A.MEASURE
												   , A.QTY
												   , CONVERT(NVARCHAR, A.CREATION_DATE, 112)		AS CREATE_DATE
												   , A.CREATED_BY
												   , A.CREATION_DATE
												   , A.LAST_UPDATED_BY
												   , A.LAST_UPDATE_DATE
										  FROM DM_PLN_MKT_FCST A WITH(NOLOCK)
										  LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
											ON A.DIVISION_ID	= C.DIVISION_ID
											AND A.SCM_SITE_ID	= C.SCM_SITE_ID
											AND C.SITE_TYPE		= 'SALES'
											AND C.VALID_YN		= 'Y'
										  LEFT OUTER JOIN SCM_MST_SITE_ITEM D WITH(NOLOCK)
											ON A.DIVISION_ID	= D.DIVISION_ID						
											AND A.SCM_SITE_ID	= D.SCM_SITE_ID
											AND A.ITEM_ID		= D.ITEM_ID
										  LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO E WITH(NOLOCK)
											ON C.DEPT_ID		= E.DEPT_ID
										  LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO F WITH(NOLOCK)
											ON E.UPPER_DEPT_ID	= F.DEPT_ID
										  LEFT OUTER JOIN SCM_MST_CITY G 
											ON C.COUNTRY		= G.COUNTRY
											AND C.CITY			= G.CITY  
										  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V H WITH(NOLOCK)  
											ON A.DIVISION_ID	= H.DIVISION_ID  
											AND A.ITEM_ID		= H.ITEM_ID  
										  LEFT OUTER JOIN SCM_MST_PROJECT I 
											ON A.DIVISION_ID	= I.DIVISION_ID 						
										  WHERE A.MEASURE IN ('CUST_FCST', 'Customer FCST')		--> RPA는 CUST_FCST_EDI가 없기 때문인건지?
										  AND A.DIVISION_ID		= @v_division_id
										  AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) >= @v_from_date											  
										) AA
						END

					ELSE

						BEGIN
							INSERT INTO DM_PLN_CUST_FCST_H (
										  HISTORY_SEQ
										, EDI_IF_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
										, INCOTERMS
										, MEASURE
										, PLANT_SITE_ID, YYYYMMDD, QTY
										, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
										, CREATE_DATE
										, SENDER_CODE	-- SENDER_CODE 값 저장
										, SENDER_NAME	-- SENDER_NAME 값 저장
										, END_CUSTOMER
										, CUSTOMER_PLANT
										, UNLOADING_POINT
										, NICK_NAME
										, DEPT_NAME_KO
										, TEAM_NAME_KO 
										, SOLDTO_CUSTOMER
										, COUNTRY		
										, CITY			
										, ITEM_NAME			
										, ITEM_TYPE			
										, OWNER				
										, VMI_YN			
										, BIZ_TYPE		
										, PROJECT_NAME		
										, PROJECT_STATUS	
										, PROJECT_OWNER		
										, CELL_PER_CAR		
										, CELL_PER_MODULE	
										, MODULE_PER_CAR	
										, KWH_PER_CELL		
										, KWH_PER_MODULE	
										, KWH_PER_PACK		
										)
								SELECT NEXT VALUE FOR SEQ1_DM_PLN_CUST_FCST_H
										, ''									AS EDI_IF_SEQ
										, AA.DIVISION_ID
										, AA.PROJECT_CODE PROJECT_CODE
										, AA.SCM_SITE_ID
										, AA.ITEM_ID
										, AA.DOM_EXP
										, AA.FCST_TYPE
										, AA.INCOTERMS
										, AA.MEASURE
										, AA.PLANT_SITE_ID
										, AA.YYYYMMDD
										, IIF(AA.QTY IS NULL , NULL,  CONVERT(NUMERIC(30, 10), AA.QTY)) AS QTY
										, AA.CREATED_BY
										, CREATION_DATE
										, LAST_UPDATED_BY
										, LAST_UPDATE_DATE
										, AA.CREATE_DATE
										, AA.SENDER_CODE
										, AA.SENDER_NAME
										, AA.END_CUSTOMER
										, AA.CUSTOMER_PLANT
										, AA.UNLOADING_POINT
										, AA.NICK_NAME
										, AA.DEPT_NAME_KO
										, AA.TEAM_NAME_KO 
										, AA.SOLDTO_CUSTOMER
										, AA.COUNTRY_NAME	
										, AA.CITY_NAME	
										, AA.ITEM_NAME			
										, AA.ITEM_TYPE			
										, AA.OWNER				
										, AA.VMI_YN			
										, AA.BIZ_TYPE_NAME		
										, AA.PROJECT_NAME		
										, AA.PROJECT_STATUS	
										, AA.PROJECT_OWNER
										, IIF(AA.CELL_PER_CAR IS NULL, NULL, CONVERT(NUMERIC(30, 10), AA.CELL_PER_CAR))			AS CELL_PER_CAR
										, IIF(AA.CELL_PER_MODULE IS NULL, NULL, CONVERT(NUMERIC(30, 10), AA.CELL_PER_MODULE))	AS CELL_PER_MODULE
										, IIF(AA.MODULE_PER_CAR IS NULL, NULL, CONVERT(NUMERIC(30, 10), AA.MODULE_PER_CAR))		AS MODULE_PER_CAR
										, IIF(AA.KWH_PER_CELL IS NULL, NULL, CONVERT(NUMERIC(30, 10), AA.KWH_PER_CELL))			AS KWH_PER_CELL
										, IIF(AA.KWH_PER_MODULE IS NULL, NULL, CONVERT(NUMERIC(30, 10), AA.KWH_PER_MODULE))		AS KWH_PER_MODULE
										, IIF(AA.KWH_PER_PACK IS NULL, NULL, CONVERT(NUMERIC(30, 10), AA.KWH_PER_PACK))			AS KWH_PER_PACK
							   FROM (
										  SELECT DISTINCT 
												  A.DIVISION_ID
												, ''					AS SENDER_CODE
												, ''					AS SENDER_NAME
												, A.YYYYMMDD
												, ''					AS CUSTOMER_PLANT
												, ''					AS UNLOADING_POINT
												, ''					AS CUST_MATERIAL_CODE
												, C.END_CUSTOMER
												, A.SCM_SITE_ID
												, A.ITEM_ID
												, [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
												, A.INCOTERMS
												, A.FCST_TYPE
												, A.DOM_EXP 
												, E.DEPT_NAME_KO		AS DEPT_NAME_KO
												, F.DEPT_NAME_KO		AS TEAM_NAME_KO 
												, C.SOLDTO_CUSTOMER		
												, G.COUNTRY_NAME
												, G.CITY_NAME
												, H.ITEM_NAME
												, H.ITEM_TYPE
												, D.OWNER
												, C.VMI_YN
												, I.BIZ_TYPE_NAME
												, A.PROJECT_CODE
												, I.PROJECT_NAME
												, I.PROJECT_STATUS
												, I.PROJECT_OWNER
												, A.PLANT_SITE_ID AS PLANT_SITE_ID
												, D.CELL_PER_CAR
												, D.CELL_PER_MODULE
												, (CASE WHEN D.CELL_PER_MODULE <> 0 THEN D.CELL_PER_CAR / D.CELL_PER_MODULE ELSE 0 END) AS MODULE_PER_CAR
												, ''											AS SOLDTO_CODE
												, ''											AS COMPANY_ID
												, D.ATTRIBUTE8									AS KWH_PER_CELL
												, CASE WHEN A.DIVISION_ID = @v_division_id AND D.CELL_PER_MODULE > 0 AND ISNULL(D.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT, (D.CELL_PER_MODULE * D.ATTRIBUTE8))   
													   ELSE NULL 
												  END											AS KWH_PER_MODULE
												, CASE WHEN A.DIVISION_ID = @v_division_id AND D.CELL_PER_CAR > 0 AND ISNULL(D.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT, (D.CELL_PER_CAR * D.ATTRIBUTE8))   
													   ELSE NULL 
												  END											AS KWH_PER_PACK
												, A.MEASURE
												, A.QTY
												, CONVERT(NVARCHAR, A.CREATION_DATE, 112)		AS CREATE_DATE
												, A.CREATED_BY
												, A.CREATION_DATE
												, A.LAST_UPDATED_BY
												, A.LAST_UPDATE_DATE
										  FROM DM_PLN_MKT_FCST A WITH(NOLOCK)
										  LEFT OUTER JOIN SCM_MST_SITE C WITH(NOLOCK)
											ON A.DIVISION_ID	= C.DIVISION_ID
											AND A.SCM_SITE_ID	= C.SCM_SITE_ID
											AND C.SITE_TYPE		= 'SALES'
											AND C.VALID_YN		= 'Y'
										  LEFT OUTER JOIN SCM_MST_SITE_ITEM D WITH(NOLOCK)
											ON A.DIVISION_ID	= D.DIVISION_ID
											AND A.PROJECT_CODE	= D.PROJECT_CODE
											AND A.SCM_SITE_ID	= D.SCM_SITE_ID
											AND A.ITEM_ID		= D.ITEM_ID
										  LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO E WITH(NOLOCK)
											ON C.DEPT_ID		= E.DEPT_ID
										  LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO F WITH(NOLOCK)
											ON E.UPPER_DEPT_ID	= F.DEPT_ID
										  LEFT OUTER JOIN SCM_MST_CITY G 
											ON C.COUNTRY		= G.COUNTRY
											AND C.CITY			= G.CITY  
										  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V H WITH(NOLOCK)  
											ON A.DIVISION_ID	= H.DIVISION_ID  
											AND A.ITEM_ID		= H.ITEM_ID  
										  LEFT OUTER JOIN SCM_MST_PROJECT I 
											ON A.DIVISION_ID	= I.DIVISION_ID 
											AND A.PROJECT_CODE	= I.PROJECT_CODE
										  WHERE A.MEASURE IN ('CUST_FCST', 'Customer FCST')		--> RPA는 CUST_FCST_EDI가 없기 때문인건지?
										  AND A.DIVISION_ID		= @v_division_id
										  AND CONVERT(NVARCHAR, A.LAST_UPDATE_DATE, 112) >= @v_from_date										  
										) AA
						END		

				END

		END

	END TRY
    BEGIN CATCH

			SET @v_log_type = 'ERROR';
			SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
			SET @v_description = 'ERROR_LINE ' + '(' + @p_division_id + '_' + @p_accept_flag + ') : ' + STR(ERROR_LINE());
			SET @d_event_date = SYSDATETIME();
			SELECT 'catch', @v_log_message 

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH

    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @v_from_date + '(' + @p_division_id + '_' + @p_accept_flag + ')';
    SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
  END;
