




/*
 * Program ID   : PR_DM_CUTOFF_DATA_CLEANSING
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 10. 30    SongKH      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2021/03/16		HWI1993	[C20210316-000106] Daily Cutoff Data Cleansing, 삭제주기를 -7*8 --> -7*2 (2주전 월요일 이전데이터), 삭제단위를 5만으로 변경, 환율테이블 추가함.
 * 2021/03/18		HWI1993	성능문제로 테이블별로 인덱스에 맞춰서 삭제쿼리 다시 작성함.
 * 2021/06/24		hwi1993	[2021하반기과제] 성능개선 - 컷오프테이블 데이터 이동
 * 2021/07/23		hwi1993	[2021하반기과제] 소형 중장기계획에 따른 DM_PLN_BP_FCST_C_KEEP 컬럼변경 적용
 * 2022/01/04		kdw2819 [C20220103-000581] 다빈치 DataLake 데이터 수집을 위한 보관테이블 이력 기록
 * 2022.04.05       HWI1993 GM JV 작업
 * 2022.06.21		rosia27	[C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 * 2022.09.23		rosia27	[C20220905-000191]Sales Report 데이터 보관 기간 설정의 건
 * 2024.05.09		JSSBAE	[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 * 2024.12.01		KANG.H.J [PJ2024-50611]  FROM_SITE_ID 추가
 * 2025.02.05		KANG.H.J [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화
 * 2025.04.08		KANG.H.J [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제처리
 * 2025.04.25		KANG.H.J [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP 등록
 * 2025.06.23		KANG.H.J [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.07.24		KANG.H.J [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP / DM_PLN_CFM_SELLING_PRICE_C_KEEP 등록
*/

CREATE PROCEDURE [dbo].[PR_DM_CUTOFF_DATA_CLEANSING]
AS

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_CUTOFF_DATA_CLEANSING';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = ''
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------	

		--------------------------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇◇◇◇◇◇◇◇
		--                                                                                                      전주, 당주 CUTOFF VERSION, PLAN_ID 값 Validation (start)
		--------------------------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇◇◇◇◇◇◇◇

		-- DAILY CUTOFF DATA 삭제
		BEGIN 
			DECLARE @VERSION_NO NVARCHAR(50), @I INT, @CNT INT, @WEEKDAY TINYINT
			
			SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())
			

			-- dm_pln_mkt_fcst_c 삭제 
			CREATE TABLE  #T_VERSION (
			VERSION_NO NVARCHAR(50)
			, SEQ INT IDENTITY(0,1)
			)				
				
			INSERT INTO #T_VERSION ( VERSION_NO )
			SELECT A.VERSION_NO
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN DM_PLN_MKT_FCST_C B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_TYPE = B.CUTOFF_TYPE AND A.YYYYMMDD = B.CUTOFF_YYYYMMDD AND A.VERSION_NO = B.VERSION_NO
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)  
				AND A.VERSION_TYPE = 'MF_D'
			GROUP BY A.VERSION_NO
			ORDER BY 1

			SELECT @CNT = COUNT(*), @I = 0
			FROM #T_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO
				FROM #T_VERSION
				WHERE SEQ = @I
			
				DELETE FROM DM_PLN_MKT_FCST_C WHERE VERSION_NO = @VERSION_NO AND DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81', '82' ) )

				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END


			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'dm_pln_mkt_fcst_c 삭제'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end)

			-- dm_pln_sales_plan_c 삭제

			TRUNCATE TABLE #T_VERSION
			
			INSERT INTO #T_VERSION ( VERSION_NO )
			SELECT DISTINCT A.VERSION_NO
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN DM_PLN_SALES_PLAN_C B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_NO = B.VERSION_NO AND B.CUTOFF_TYPE = 'SP_D' AND B.CUTOFF_YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) 
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)  
				AND A.VERSION_TYPE = 'SP_D'
			GROUP BY A.VERSION_NO
			ORDER BY 1
			
			SELECT @CNT = COUNT(*), @I = 0
			FROM #T_VERSION
			
			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO
				FROM #T_VERSION
				WHERE SEQ = @I
			
				DELETE FROM DM_PLN_SALES_PLAN_C WHERE VERSION_NO = @VERSION_NO AND DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81', '82' ) )

				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())
				SET @I += 1
			END

			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'dm_pln_sales_plan_c 삭제'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end)

			-- dm_pln_mkt_fcst_result_c 삭제
			TRUNCATE TABLE #T_VERSION

			INSERT INTO #T_VERSION ( VERSION_NO )
			SELECT A.VERSION_NO
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN DM_PLN_MKT_FCST_RESULT_C B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_TYPE = B.CUTOFF_TYPE AND A.YYYYMMDD = B.CUTOFF_YYYYMMDD AND A.VERSION_NO = B.VERSION_NO
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)  
				AND A.VERSION_TYPE = 'MF_D'
			GROUP BY A.VERSION_NO
			ORDER BY 1

			SELECT @CNT = COUNT(*), @I = 0
			FROM #T_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO
				FROM #T_VERSION
				WHERE SEQ = @I
			
				DELETE FROM DM_PLN_MKT_FCST_RESULT_C WHERE VERSION_NO = @VERSION_NO AND DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81', '82' ) )

				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END


			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'dm_pln_mkt_fcst_result_c 삭제'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end)

				-- dm_pln_sales_plan_result_c 삭제
			TRUNCATE TABLE #T_VERSION

			INSERT INTO #T_VERSION ( VERSION_NO )
			SELECT A.VERSION_NO
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN DM_PLN_SALES_PLAN_RESULT_C B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_TYPE = B.CUTOFF_TYPE AND A.YYYYMMDD = B.CUTOFF_YYYYMMDD AND A.VERSION_NO = B.VERSION_NO
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)  
				AND A.VERSION_TYPE = 'SP_D'
			GROUP BY A.VERSION_NO
			ORDER BY 1

			SELECT @CNT = COUNT(*), @I = 0
			FROM #T_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO
				FROM #T_VERSION
				WHERE SEQ = @I
			
				DELETE FROM DM_PLN_SALES_PLAN_RESULT_C WHERE VERSION_NO = @VERSION_NO AND DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81', '82' ) )

				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END

			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'dm_pln_sales_plan_result_c 삭제'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end)


			TRUNCATE TABLE #T_VERSION

			INSERT INTO #T_VERSION ( VERSION_NO )
			SELECT A.VERSION_NO
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN DM_PLN_CFM_MKT_DEMAND_PLAN_C B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_TYPE = B.CUTOFF_TYPE AND A.YYYYMMDD = B.CUTOFF_YYYYMMDD AND A.VERSION_NO = B.VERSION_NO
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)  
				AND A.VERSION_TYPE IN ( 'MF_D', 'SF_D', 'SP_D')
			GROUP BY A.VERSION_NO
			ORDER BY 1

			SELECT @CNT = COUNT(*), @I = 0
			FROM #T_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO
				FROM #T_VERSION
				WHERE SEQ = @I
			
				DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C WHERE VERSION_NO = @VERSION_NO AND DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81', '82' ) )

				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END

			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'dm_pln_cfm_mkt_demand_plan_c 삭제'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end)

			-- [소형매출계획 동기화] DM_PLN_CFM_SELLING_PRICE_C 삭제 
			TRUNCATE TABLE #T_VERSION

			INSERT INTO #T_VERSION ( VERSION_NO )
			SELECT A.VERSION_NO
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN DM_PLN_CFM_SELLING_PRICE_C B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_TYPE = B.CUTOFF_TYPE AND A.YYYYMMDD = B.CUTOFF_YYYYMMDD AND A.VERSION_NO = B.VERSION_NO
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)  
				AND A.VERSION_TYPE IN ( 'MF_D', 'SF_D', 'SP_D')
			GROUP BY A.VERSION_NO
			ORDER BY 1

			SELECT @CNT = COUNT(*), @I = 0
			FROM #T_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO
				FROM #T_VERSION
				WHERE SEQ = @I
			
				DELETE FROM DM_PLN_CFM_SELLING_PRICE_C WHERE VERSION_NO = @VERSION_NO AND DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81', '82' ) )

				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END

			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'dm_pln_cfm_selling_price_c 삭제'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------


			-- SCM_MST_FUTURE_PRICE_C 삭제
			TRUNCATE TABLE #T_VERSION

			INSERT INTO #T_VERSION ( VERSION_NO )
			SELECT A.VERSION_NO
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN SCM_MST_FUTURE_PRICE_C B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_TYPE = B.CUTOFF_TYPE AND A.YYYYMMDD = B.CUTOFF_YYYYMMDD AND A.VERSION_NO = B.VERSION_NO
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)  
				AND A.VERSION_TYPE = 'SP_D'
			GROUP BY A.VERSION_NO
			ORDER BY 1

			SELECT @CNT = COUNT(*), @I = 0
			FROM #T_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO
				FROM #T_VERSION
				WHERE SEQ = @I
			
				DELETE FROM SCM_MST_FUTURE_PRICE_C WHERE VERSION_NO = @VERSION_NO AND DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81', '82' ) )

				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END

			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'SCM_MST_FUTURE_PRICE_C 삭제'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end)

				--[C20210316-000106]
				-- DM_MST_EXCHANGE_RATE_C 삭제
			TRUNCATE TABLE #T_VERSION

			INSERT INTO #T_VERSION ( VERSION_NO )
			SELECT A.VERSION_NO
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN DM_MST_EXCHANGE_RATE_C B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_TYPE = B.CUTOFF_TYPE AND A.YYYYMMDD = B.CUTOFF_YYYYMMDD AND A.VERSION_NO = B.VERSION_NO
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)  
				AND A.VERSION_TYPE = 'SP_D'
			GROUP BY A.VERSION_NO
			ORDER BY 1

			SELECT @CNT = COUNT(*), @I = 0
			FROM #T_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO
				FROM #T_VERSION
				WHERE SEQ = @I
			
				DELETE FROM DM_MST_EXCHANGE_RATE_C WHERE VERSION_NO = @VERSION_NO AND DIVISION_ID IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81', '82' ) )

				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END

			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'DM_MST_EXCHANGE_RATE_C 삭제'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end)
		END


		-- 보관기간 지난 건들 이동처리
		BEGIN
			
			DECLARE 
			  @DATA_CNT		INT				-- 대상 건수
			, @MOVE_CNT		INT				-- 옮겨진 건수
			, @DIVISION_ID	NVARCHAR(30)
			
			CREATE TABLE #T_MOVE_VERSION (
			VERSION_NO		NVARCHAR(50)
			, DIVISION_ID	NVARCHAR(30)
			, CNT			INT
			, SEQ			INT IDENTITY(0,1)
			)

			---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			TRUNCATE TABLE #T_MOVE_VERSION

			INSERT INTO #T_MOVE_VERSION ( VERSION_NO, DIVISION_ID, CNT )
			SELECT A.VERSION_NO, A.DIVISION_ID, COUNT(*)
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN DM_PLN_MKT_FCST_C B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_TYPE = B.CUTOFF_TYPE AND A.YYYYMMDD = B.CUTOFF_YYYYMMDD AND A.VERSION_NO = B.VERSION_NO
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*54, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)  
				AND ISNULL(A.ATTRIBUTE1,'') <> 'MOVE'
			GROUP BY A.VERSION_NO, A.DIVISION_ID

			
			SELECT @CNT = COUNT(*), @I = 0, @VERSION_NO = NULL, @DIVISION_ID = NULL, @DATA_CNT = 0, @MOVE_CNT = 0
			FROM #T_MOVE_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO, @DIVISION_ID = DIVISION_ID, @DATA_CNT = CNT
				FROM #T_MOVE_VERSION
				WHERE SEQ = @I

				UPDATE DM_MST_VERSION
				SET ATTRIBUTE1 = 'ING'
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				INSERT INTO DM_PLN_MKT_FCST_C_KEEP
					 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
					 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY
					 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
					 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
					 , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
					 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY
					 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
					 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
					 , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM   DM_PLN_MKT_FCST_C
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				-- [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP / DM_PLN_CFM_SELLING_PRICE_C_KEEP 등록 START
				INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP
					 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER
					 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY
					 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
					 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
					 , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER
					 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY
					 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
					 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
					 , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM   DM_PLN_CFM_MKT_DEMAND_PLAN_C WITH(NOLOCK)
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO
				-- [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP / DM_PLN_CFM_SELLING_PRICE_C_KEEP 등록 END

				SELECT @MOVE_CNT = COUNT(*)
				FROM DM_PLN_MKT_FCST_C_KEEP
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				IF ( @MOVE_CNT = @DATA_CNT )
				BEGIN
					DELETE A
					FROM DM_PLN_MKT_FCST_C A
					JOIN DM_PLN_MKT_FCST_C_KEEP B ON	A.DIVISION_ID		= B.DIVISION_ID 
													AND A.VERSION_NO 		= B.VERSION_NO 
													AND A.CUTOFF_TYPE 		= B.CUTOFF_TYPE 
													AND A.CUTOFF_YYYYMMDD 	= B.CUTOFF_YYYYMMDD
													AND A.PROJECT_CODE 		= B.PROJECT_CODE 
													AND A.SCM_SITE_ID 		= B.SCM_SITE_ID 
													AND A.ITEM_ID 			= B.ITEM_ID 
													AND A.DOM_EXP 			= B.DOM_EXP 
													AND A.FCST_TYPE 		= B.FCST_TYPE 
													AND A.INCOTERMS 		= B.INCOTERMS 
													AND A.MEASURE 			= B.MEASURE 
													AND A.PLANT_SITE_ID 	= B.PLANT_SITE_ID 
													AND A.YYYYMMDD			= B.YYYYMMDD
					WHERE A.VERSION_NO = @VERSION_NO 
						AND A.DIVISION_ID = @DIVISION_ID
					;

					-- [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP / DM_PLN_CFM_SELLING_PRICE_C_KEEP 등록 START
					DELETE A
					FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
					JOIN DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP B 
													ON	A.DIVISION_ID		= B.DIVISION_ID 
													AND A.VERSION_NO 		= B.VERSION_NO 
													AND A.CUTOFF_TYPE 		= B.CUTOFF_TYPE 
													AND A.CUTOFF_YYYYMMDD 	= B.CUTOFF_YYYYMMDD
													AND A.PROJECT_CODE 		= B.PROJECT_CODE 
													AND A.END_CUSTOMER 		= B.END_CUSTOMER 
													AND A.SCM_SITE_ID 		= B.SCM_SITE_ID 
													AND A.ITEM_ID 			= B.ITEM_ID 
													AND A.DOM_EXP 			= B.DOM_EXP 
													AND A.FCST_TYPE 		= B.FCST_TYPE 
													AND A.INCOTERMS 		= B.INCOTERMS 
													AND A.MEASURE 			= B.MEASURE 
													AND A.PLANT_SITE_ID 	= B.PLANT_SITE_ID 
													AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID 
													AND A.YYYYMMDD			= B.YYYYMMDD
					WHERE A.VERSION_NO = @VERSION_NO 
						AND A.DIVISION_ID = @DIVISION_ID
					;
					-- [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP / DM_PLN_CFM_SELLING_PRICE_C_KEEP 등록 END

					
				END

				UPDATE DM_MST_VERSION
				SET ATTRIBUTE1 = 'MOVE',
					-- [C20220103-000581] 다빈치 DataLake 데이터 수집을 위한 보관테이블 이력 기록
					ATTRIBUTE4 =  CONVERT(CHAR(8), GETDATE(), 112)
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END

			
			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'DM_PLN_MKT_FCST_C 이동'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end)

			---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

			TRUNCATE TABLE #T_MOVE_VERSION

			INSERT INTO #T_MOVE_VERSION ( VERSION_NO, DIVISION_ID, CNT )
			SELECT A.VERSION_NO, A.DIVISION_ID, COUNT(*)
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN DM_PLN_MKT_FCST_RESULT_C B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_TYPE = B.CUTOFF_TYPE AND A.YYYYMMDD = B.CUTOFF_YYYYMMDD AND A.VERSION_NO = B.VERSION_NO
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*54, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)  
				AND ISNULL(A.ATTRIBUTE2,'') <> 'MOVE'
			GROUP BY A.VERSION_NO, A.DIVISION_ID

			
			SELECT @CNT = COUNT(*), @I = 0, @VERSION_NO = NULL, @DIVISION_ID = NULL, @DATA_CNT = 0, @MOVE_CNT = 0
			FROM #T_MOVE_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO, @DIVISION_ID = DIVISION_ID, @DATA_CNT = CNT
				FROM #T_MOVE_VERSION
				WHERE SEQ = @I

				UPDATE DM_MST_VERSION
				SET ATTRIBUTE2 = 'ING'
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				INSERT INTO DM_PLN_MKT_FCST_RESULT_C_KEEP
					 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
					 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY
					 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
					 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
					 , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 
					 , CELL_PROD_SITE_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					 )
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
					 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY
					 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
					 , ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
					 , ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
					 , CELL_PROD_SITE_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				FROM   DM_PLN_MKT_FCST_RESULT_C WITH(NOLOCK)
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				SELECT @MOVE_CNT = COUNT(*)
				FROM DM_PLN_MKT_FCST_RESULT_C_KEEP WITH(NOLOCK)
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				IF ( @MOVE_CNT = @DATA_CNT )
				BEGIN
					DELETE A
					FROM DM_PLN_MKT_FCST_RESULT_C A 
					JOIN DM_PLN_MKT_FCST_RESULT_C_KEEP B ON 	A.DIVISION_ID		= B.DIVISION_ID 
															AND A.VERSION_NO 		= B.VERSION_NO 
															AND A.CUTOFF_TYPE 		= B.CUTOFF_TYPE 
															AND A.CUTOFF_YYYYMMDD 	= B.CUTOFF_YYYYMMDD 
															AND A.PROJECT_CODE 		= B.PROJECT_CODE 
															AND A.SCM_SITE_ID 		= B.SCM_SITE_ID 
															AND A.ITEM_ID 			= B.ITEM_ID 
															AND A.DOM_EXP 			= B.DOM_EXP 
															AND A.FCST_TYPE 		= B.FCST_TYPE 
															AND A.INCOTERMS 		= B.INCOTERMS 
															AND A.MEASURE 			= B.MEASURE 
															AND A.PLANT_SITE_ID 	= B.PLANT_SITE_ID 
															AND A.YYYYMMDD			= B.YYYYMMDD
															AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					WHERE A.VERSION_NO = @VERSION_NO 
						AND A.DIVISION_ID = @DIVISION_ID
				END

				UPDATE DM_MST_VERSION
				SET ATTRIBUTE2 = 'MOVE',
					-- [C20220103-000581] 다빈치 DataLake 데이터 수집을 위한 보관테이블 이력 기록
					ATTRIBUTE5 =  CONVERT(CHAR(8), GETDATE(), 112)
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END

			
			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'DM_PLN_MKT_FCST_RESULT_C 이동'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end)

			---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			TRUNCATE TABLE #T_MOVE_VERSION

			INSERT INTO #T_MOVE_VERSION ( VERSION_NO, DIVISION_ID, CNT )
			SELECT A.VERSION_NO, A.DIVISION_ID, COUNT(*)
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN DM_PLN_SALES_PLAN_C B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_TYPE = B.CUTOFF_TYPE AND A.YYYYMMDD = B.CUTOFF_YYYYMMDD AND A.VERSION_NO = B.VERSION_NO
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*54, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)  
				AND ISNULL(A.ATTRIBUTE1,'') <> 'MOVE'
			GROUP BY A.VERSION_NO, A.DIVISION_ID

			
			SELECT @CNT = COUNT(*), @I = 0, @VERSION_NO = NULL, @DIVISION_ID = NULL, @DATA_CNT = 0, @MOVE_CNT = 0
			FROM #T_MOVE_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO, @DIVISION_ID = DIVISION_ID, @DATA_CNT = CNT
				FROM #T_MOVE_VERSION
				WHERE SEQ = @I

				UPDATE DM_MST_VERSION
				SET ATTRIBUTE1 = 'ING'
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				INSERT INTO DM_PLN_SALES_PLAN_C_KEEP
					 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
					 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY
					 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
					 , ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
					 , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 
					 , CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					 )
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
					 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY
					 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
					 , ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
					 , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
					 , CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				FROM   DM_PLN_SALES_PLAN_C
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				SELECT @MOVE_CNT = COUNT(*)
				FROM DM_PLN_SALES_PLAN_C_KEEP
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				IF ( @MOVE_CNT = @DATA_CNT )
				BEGIN
					DELETE A
					FROM DM_PLN_SALES_PLAN_C A
					JOIN DM_PLN_SALES_PLAN_C_KEEP B ON		A.DIVISION_ID		= B.DIVISION_ID 
														AND A.VERSION_NO 		= B.VERSION_NO 
														AND A.CUTOFF_TYPE 		= B.CUTOFF_TYPE 
														AND A.CUTOFF_YYYYMMDD 	= B.CUTOFF_YYYYMMDD
														AND A.PROJECT_CODE 		= B.PROJECT_CODE 
														AND A.SCM_SITE_ID 		= B.SCM_SITE_ID 
														AND A.ITEM_ID 			= B.ITEM_ID 
														AND A.DOM_EXP 			= B.DOM_EXP 
														AND A.FCST_TYPE 		= B.FCST_TYPE 
														AND A.INCOTERMS 		= B.INCOTERMS 
														AND A.MEASURE 			= B.MEASURE 
														AND A.PLANT_SITE_ID 	= B.PLANT_SITE_ID 
														AND A.YYYYMMDD			= B.YYYYMMDD
														AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					WHERE A.VERSION_NO = @VERSION_NO 
						AND A.DIVISION_ID = @DIVISION_ID
				END

				UPDATE DM_MST_VERSION
				SET ATTRIBUTE1 = 'MOVE',
					-- [C20220103-000581] 다빈치 DataLake 데이터 수집을 위한 보관테이블 이력 기록
					ATTRIBUTE4 =  CONVERT(CHAR(8), GETDATE(), 112)
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END

			
			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'DM_PLN_SALES_PLAN_C 이동'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end)


			---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			TRUNCATE TABLE #T_MOVE_VERSION

			INSERT INTO #T_MOVE_VERSION ( VERSION_NO, DIVISION_ID, CNT )
			SELECT A.VERSION_NO, A.DIVISION_ID, COUNT(*)
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN DM_PLN_SALES_PLAN_RESULT_C B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_TYPE = B.CUTOFF_TYPE AND A.YYYYMMDD = B.CUTOFF_YYYYMMDD AND A.VERSION_NO = B.VERSION_NO
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*54, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) 
				AND ISNULL(A.ATTRIBUTE2,'') <> 'MOVE' 
			GROUP BY A.VERSION_NO, A.DIVISION_ID

			
			SELECT @CNT = COUNT(*), @I = 0, @VERSION_NO = NULL, @DIVISION_ID = NULL, @DATA_CNT = 0, @MOVE_CNT = 0
			FROM #T_MOVE_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO, @DIVISION_ID = DIVISION_ID, @DATA_CNT = CNT
				FROM #T_MOVE_VERSION
				WHERE SEQ = @I

				UPDATE DM_MST_VERSION
				SET ATTRIBUTE2 = 'ING'
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				INSERT INTO DM_PLN_SALES_PLAN_RESULT_C_KEEP
					 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
					 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID
					 , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
					 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
					 , CELL_PROD_SITE_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					  )
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
					 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					 , MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, COMPANY_ID
					 , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
					 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
					 , CELL_PROD_SITE_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				FROM   DM_PLN_SALES_PLAN_RESULT_C WITH(NOLOCK)
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				SELECT @MOVE_CNT = COUNT(*)
				FROM DM_PLN_SALES_PLAN_RESULT_C_KEEP WITH(NOLOCK)
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				IF ( @MOVE_CNT = @DATA_CNT )
				BEGIN
					DELETE A
					FROM DM_PLN_SALES_PLAN_RESULT_C A
					JOIN DM_PLN_SALES_PLAN_RESULT_C_KEEP B ON	A.DIVISION_ID		= B.DIVISION_ID	 
															AND A.VERSION_NO 		= B.VERSION_NO 
															AND A.CUTOFF_TYPE 		= B.CUTOFF_TYPE 
															AND A.CUTOFF_YYYYMMDD 	= B.CUTOFF_YYYYMMDD
															AND A.PROJECT_CODE 		= B.PROJECT_CODE 
															AND A.SCM_SITE_ID 		= B.SCM_SITE_ID 
															AND A.ITEM_ID 			= B.ITEM_ID 
															AND A.DOM_EXP 			= B.DOM_EXP 
															AND A.FCST_TYPE 		= B.FCST_TYPE 
															AND A.INCOTERMS 		= B.INCOTERMS 
															AND A.MEASURE 			= B.MEASURE 
															AND A.PLANT_SITE_ID 	= B.PLANT_SITE_ID 
															AND A.YYYYMMDD 			= B.YYYYMMDD 
															AND A.CURRENCY 			= B.CURRENCY 
															AND A.COMPANY_ID		= B.COMPANY_ID
															AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가

					WHERE A.VERSION_NO = @VERSION_NO 
						AND A.DIVISION_ID = @DIVISION_ID
				END

				UPDATE DM_MST_VERSION
				SET ATTRIBUTE2 = 'MOVE',
					-- [C20220103-000581] 다빈치 DataLake 데이터 수집을 위한 보관테이블 이력 기록
					ATTRIBUTE5 = CONVERT(CHAR(8), GETDATE(), 112)
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END
			
			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'DM_PLN_SALES_PLAN_RESULT_C 이동'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end)
			---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			TRUNCATE TABLE #T_MOVE_VERSION

			INSERT INTO #T_MOVE_VERSION ( VERSION_NO, DIVISION_ID, CNT )
			SELECT A.VERSION_NO, A.DIVISION_ID, COUNT(*)
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN DM_PLN_BP_FCST_C B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_TYPE = B.CUTOFF_TYPE AND A.YYYYMMDD = B.CUTOFF_YYYYMMDD AND A.VERSION_NO = B.VERSION_NO
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*54, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) 
				AND ISNULL(A.ATTRIBUTE1,'') <> 'MOVE' 
			GROUP BY A.VERSION_NO, A.DIVISION_ID

			
			SELECT @CNT = COUNT(*), @I = 0, @VERSION_NO = NULL, @DIVISION_ID = NULL, @DATA_CNT = 0, @MOVE_CNT = 0
			FROM #T_MOVE_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO, @DIVISION_ID = DIVISION_ID, @DATA_CNT = CNT
				FROM #T_MOVE_VERSION
				WHERE SEQ = @I

				UPDATE DM_MST_VERSION
				SET ATTRIBUTE1 = 'ING'
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				INSERT INTO DM_PLN_BP_FCST_C_KEEP
					 ( VERSION_NO, DIVISION_ID, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
					 , PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
					 , MEASURE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
					 , YYYYMM, CURRENCY, ITEM_USE, UNIT_ENERGY, QTY
					 , CELL_PER_PACK, CELL_PER_MODULE, MODULE_PER_PACK, CREATED_BY, CREATION_DATE
					 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
					 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					 , ATTRIBUTE9, ATTRIBUTE10, SEQ_NO, INCOTERMS, CELL_PROD_SITE )
				SELECT VERSION_NO, DIVISION_ID, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
					 , PROJECT_NAME, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
					 , MEASURE, PLANT_SITE_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
					 , YYYYMM, CURRENCY, ITEM_USE, UNIT_ENERGY, QTY
					 , CELL_PER_PACK, CELL_PER_MODULE, MODULE_PER_PACK, CREATED_BY, CREATION_DATE
					 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
					 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					 , ATTRIBUTE9, ATTRIBUTE10, SEQ_NO, INCOTERMS, CELL_PROD_SITE
				FROM   DM_PLN_BP_FCST_C
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				SELECT @MOVE_CNT = COUNT(*)
				FROM DM_PLN_BP_FCST_C_KEEP
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				IF ( @MOVE_CNT = @DATA_CNT )
				BEGIN
					DELETE A
					FROM DM_PLN_BP_FCST_C A	
					JOIN DM_PLN_BP_FCST_C_KEEP B ON A.DIVISION_ID	= B.DIVISION_ID		
												AND A.VERSION_NO 	= B.VERSION_NO 
												AND A.SEQ_NO		= B.SEQ_NO
					WHERE A.VERSION_NO = @VERSION_NO 
						AND A.DIVISION_ID = @DIVISION_ID
				END

				UPDATE DM_MST_VERSION
				SET ATTRIBUTE1 = 'MOVE',
					-- [C20220103-000581] 다빈치 DataLake 데이터 수집을 위한 보관테이블 이력 기록
					ATTRIBUTE4 = CONVERT(CHAR(8), GETDATE(), 112)
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END

			
			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'DM_PLN_BP_FCST_C 이동'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end)
			---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

			TRUNCATE TABLE #T_MOVE_VERSION

			INSERT INTO #T_MOVE_VERSION ( VERSION_NO, DIVISION_ID, CNT )
			SELECT A.VERSION_NO, A.DIVISION_ID, COUNT(*)
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN SCM_MST_FUTURE_PRICE_C B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_TYPE = B.CUTOFF_TYPE AND A.YYYYMMDD = B.CUTOFF_YYYYMMDD AND A.VERSION_NO = B.VERSION_NO
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*54, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112) 
				AND ISNULL(A.ATTRIBUTE3,'') <> 'MOVE' 
			GROUP BY A.VERSION_NO, A.DIVISION_ID

			
			SELECT @CNT = COUNT(*), @I = 0, @VERSION_NO = NULL, @DIVISION_ID = NULL, @DATA_CNT = 0, @MOVE_CNT = 0
			FROM #T_MOVE_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO, @DIVISION_ID = DIVISION_ID, @DATA_CNT = CNT
				FROM #T_MOVE_VERSION
				WHERE SEQ = @I

				UPDATE DM_MST_VERSION
				SET ATTRIBUTE3 = 'ING'
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				INSERT INTO SCM_MST_FUTURE_PRICE_C_KEEP
					 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
					 , SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY
					 , MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE
					 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
					 , ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
					 , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
					 , SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY
					 , MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE
					 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
					 , ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
					 , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM   SCM_MST_FUTURE_PRICE_C
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				-- [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP / DM_PLN_CFM_SELLING_PRICE_C_KEEP 등록 START
				INSERT INTO DM_PLN_CFM_SELLING_PRICE_C_KEEP
					 ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER
					 , SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY
					 , MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE
					 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
					 , ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
					 , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER
					 , SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY
					 , MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE
					 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
					 , ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
					 , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				FROM   DM_PLN_CFM_SELLING_PRICE_C
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO
				-- [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP / DM_PLN_CFM_SELLING_PRICE_C_KEEP 등록 END


				SELECT @MOVE_CNT = COUNT(*)
				FROM SCM_MST_FUTURE_PRICE_C_KEEP
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				IF ( @MOVE_CNT = @DATA_CNT )
				BEGIN
					DELETE A
					FROM SCM_MST_FUTURE_PRICE_C A
					JOIN SCM_MST_FUTURE_PRICE_C_KEEP B ON	A.DIVISION_ID		= B.DIVISION_ID 
														AND A.VERSION_NO 		= B.VERSION_NO 
														AND A.CUTOFF_TYPE 		= B.CUTOFF_TYPE 
														AND A.CUTOFF_YYYYMMDD	= B.CUTOFF_YYYYMMDD 
														AND A.PROJECT_CODE 		= B.PROJECT_CODE 
														AND A.SCM_SITE_ID 		= B.SCM_SITE_ID 
														AND A.PLANT_SITE_ID 	= B.PLANT_SITE_ID 
														AND A.ITEM_ID 			= B.ITEM_ID 
														AND A.YYYYMMDD 			= B.YYYYMMDD 
														AND A.CURRENCY 			= B.CURRENCY 
														AND A.MEASURE 			= B.MEASURE 
														AND A.DOM_EXP 			= B.DOM_EXP 
														AND A.FCST_TYPE 		= B.FCST_TYPE 
														AND A.INCOTERMS			= B.INCOTERMS
					WHERE A.VERSION_NO = @VERSION_NO 
						AND A.DIVISION_ID = @DIVISION_ID
					;

					-- [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP / DM_PLN_CFM_SELLING_PRICE_C_KEEP 등록 START
					DELETE A
					FROM DM_PLN_CFM_SELLING_PRICE_C A
					JOIN DM_PLN_CFM_SELLING_PRICE_C_KEEP B 
														ON	A.DIVISION_ID		= B.DIVISION_ID 
														AND A.VERSION_NO 		= B.VERSION_NO 
														AND A.CUTOFF_TYPE 		= B.CUTOFF_TYPE 
														AND A.CUTOFF_YYYYMMDD	= B.CUTOFF_YYYYMMDD 
														AND A.PROJECT_CODE 		= B.PROJECT_CODE 
														AND A.END_CUSTOMER 		= B.END_CUSTOMER 
														AND A.SCM_SITE_ID 		= B.SCM_SITE_ID 
														AND A.PLANT_SITE_ID 	= B.PLANT_SITE_ID 
														AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID 
														AND A.ITEM_ID 			= B.ITEM_ID 
														AND A.YYYYMMDD 			= B.YYYYMMDD 
														AND A.CURRENCY 			= B.CURRENCY 
														AND A.MEASURE 			= B.MEASURE 
														AND A.DOM_EXP 			= B.DOM_EXP 
														AND A.FCST_TYPE 		= B.FCST_TYPE 
														AND A.INCOTERMS			= B.INCOTERMS
					WHERE A.VERSION_NO = @VERSION_NO 
						AND A.DIVISION_ID = @DIVISION_ID
					;
					-- [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP / DM_PLN_CFM_SELLING_PRICE_C_KEEP 등록 END

				END

				UPDATE DM_MST_VERSION
				SET ATTRIBUTE3 = 'MOVE',
					-- [C20220103-000581] 다빈치 DataLake 데이터 수집을 위한 보관테이블 이력 기록
					ATTRIBUTE6 =  CONVERT(CHAR(8), GETDATE(), 112)
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END
			
			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'SCM_MST_FUTURE_PRICE_C 이동'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end)
			---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

			DELETE FROM DM_ANL_KPI_SUMMARY WHERE WORK_YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*27, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)  
			DELETE FROM DM_ANL_KPI_SALES_ACCURACY WHERE WORK_YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*27, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
			
			
			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'KPI 삭제'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end) 

			---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

			TRUNCATE TABLE #T_MOVE_VERSION

			INSERT INTO #T_MOVE_VERSION ( VERSION_NO, DIVISION_ID )
			SELECT A.VERSION_NO, A.DIVISION_ID
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN DM_PLN_DEMANDID_PEGGING B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_NO = B.VERSION_NO
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*14, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)  
			GROUP BY A.VERSION_NO, A.DIVISION_ID

			
			SELECT @CNT = COUNT(*), @I = 0, @VERSION_NO = NULL, @DIVISION_ID = NULL, @DATA_CNT = 0, @MOVE_CNT = 0
			FROM #T_MOVE_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO, @DIVISION_ID = DIVISION_ID
				FROM #T_MOVE_VERSION
				WHERE SEQ = @I
				
				DELETE FROM DM_PLN_DEMANDID_PEGGING WHERE VERSION_NO = @VERSION_NO AND DIVISION_ID = @DIVISION_ID
				
				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END
			
			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'DM_PLN_DEMANDID_PEGGING 삭제'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end) 


			---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

			TRUNCATE TABLE #T_MOVE_VERSION

			INSERT INTO #T_MOVE_VERSION ( VERSION_NO, DIVISION_ID )
			SELECT A.VERSION_NO, A.DIVISION_ID
			FROM DM_MST_VERSION A (NOLOCK )
			JOIN DM_PLN_NET_DEMAND B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_NO = B.VERSION_NO
			WHERE A.YYYYMMDD < CONVERT(CHAR(8), DATEADD(DD, -7*14, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)  
			GROUP BY A.VERSION_NO, A.DIVISION_ID

			
			SELECT @CNT = COUNT(*), @I = 0, @VERSION_NO = NULL, @DIVISION_ID = NULL, @DATA_CNT = 0, @MOVE_CNT = 0
			FROM #T_MOVE_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO, @DIVISION_ID = DIVISION_ID
				FROM #T_MOVE_VERSION
				WHERE SEQ = @I
				
				DELETE FROM DM_PLN_NET_DEMAND WHERE VERSION_NO = @VERSION_NO AND DIVISION_ID = @DIVISION_ID
				
				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END
			
			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'DM_PLN_NET_DEMAND 삭제'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end) 
			---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

			TRUNCATE TABLE #T_MOVE_VERSION

			DELETE A FROM DM_PLN_SALES_PLAN_REPORT_C A (NOLOCK) 
					JOIN DM_MDF_VERSION B (NOLOCK)
					ON A.DIVISION_ID = B.DIVISION_ID
					AND A.VERSION_NO = B.VERSION_NO
			WHERE B.CREATION_DATE < DATEADD(MONTH, -3, GETDATE())
				AND B.SEND_YN <> 'Y'

			INSERT INTO #T_MOVE_VERSION ( VERSION_NO, DIVISION_ID, CNT )
			SELECT A.VERSION_NO, A.DIVISION_ID, COUNT(*)
			FROM DM_MDF_VERSION A (NOLOCK )
			JOIN DM_PLN_SALES_PLAN_REPORT_C B (NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_NO = B.VERSION_NO
			WHERE A.CREATION_DATE < DATEADD(MONTH, -18, GETDATE())
				AND ISNULL(A.ATTRIBUTE3,'') <> 'MOVE'
			GROUP BY A.VERSION_NO, A.DIVISION_ID
			
			SELECT @CNT = COUNT(*), @I = 0, @VERSION_NO = NULL, @DIVISION_ID = NULL, @DATA_CNT = 0, @MOVE_CNT = 0
			FROM #T_MOVE_VERSION

			WHILE @I < @CNT AND @WEEKDAY IN ( 1, 7 ) 
			BEGIN 
			
				SELECT @VERSION_NO = VERSION_NO, @DIVISION_ID = DIVISION_ID, @DATA_CNT = CNT
				FROM #T_MOVE_VERSION
				WHERE SEQ = @I

				UPDATE DM_MDF_VERSION
				SET ATTRIBUTE3 = 'ING'
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C_KEEP
					 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
						, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
						, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
						, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
						, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME
						, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
						, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
						, COUNTRY_KR_NAME, ROUTE
						, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
						 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
						 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
						 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
						 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
						 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME
						 , CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
						 , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
						 , COUNTRY_KR_NAME, ROUTE 
						 , CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM   DM_PLN_SALES_PLAN_REPORT_C
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				SELECT @MOVE_CNT = COUNT(*)
				FROM DM_PLN_SALES_PLAN_REPORT_C_KEEP
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO
					
				IF ( @MOVE_CNT = @DATA_CNT )
				BEGIN
					DELETE A
					FROM DM_PLN_SALES_PLAN_REPORT_C A 
					JOIN DM_PLN_SALES_PLAN_REPORT_C_KEEP B  ON 	A.DIVISION_ID		= B.DIVISION_ID 
															AND A.VERSION_NO 		= B.VERSION_NO 
															AND A.DEPARTMENT_ID		= B.DEPARTMENT_ID
															AND A.DEPT_ID			= B.DEPT_ID
															AND A.PROJECT_CODE 		= B.PROJECT_CODE 
															AND A.SCM_SITE_ID 		= B.SCM_SITE_ID 
															AND A.ITEM_ID 			= B.ITEM_ID 
															AND A.FCST_TYPE 		= B.FCST_TYPE 
															AND A.INCOTERMS 		= B.INCOTERMS 
															AND A.MEASURE 			= B.MEASURE 
															AND A.PLANT_SITE_ID 	= B.PLANT_SITE_ID 
															AND A.YYYYMMDD			= B.YYYYMMDD
															AND A.CURRENCY			= B.CURRENCY
															AND A.COMPANY_ID		= B.COMPANY_ID
															AND A.COMPO_40			= B.COMPO_40
					WHERE A.VERSION_NO = @VERSION_NO 
						AND A.DIVISION_ID = @DIVISION_ID
				END

				UPDATE DM_MDF_VERSION
				SET ATTRIBUTE3 = 'MOVE',
					-- [C20220103-000581] 다빈치 DataLake 데이터 수집을 위한 보관테이블 이력 기록
					ATTRIBUTE5 =  CONVERT(CHAR(8), GETDATE(), 112)
				WHERE DIVISION_ID = @DIVISION_ID
					AND VERSION_NO = @VERSION_NO

				SELECT @WEEKDAY = DATEPART(WEEKDAY, GETDATE())

				SET @I += 1
			END
			
			----------------------------------------------------------------------------------------------- PROCESS LOG (START)
			SET @v_log_type = 'PROCESS';
			SET @v_log_message = '########## Process............##########';
			SET @v_description = N'DM_PLN_SALES_PLAN_REPORT_C 이동'
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
			----------------------------------------------------------------------------------------------- PROCESS LOG (end)

		END

	--------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	  -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
