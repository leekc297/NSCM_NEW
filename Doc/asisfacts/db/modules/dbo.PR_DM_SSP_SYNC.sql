

/*
 *===================================================================================================
 * PROGRAM ID   : PR_DM_SSP_SYNC
 * DESCRIPTION  : SSP 의 출하계획에 BOD를 감안한 매출일자와 MKT FCST 를 동기화함
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE      DESCRIPTION
 *===================================================================================================
 * 2020.09.16    HWI1993     INITIAL RELEASE [C20200804-000123]업무 정확도 향상을 위한 MKT FCST - SSP 동기화 기능 추가
 * 2021.01.14	 HWI1993	[C20210112-000446] [SCM PI팀] 소형사업부 MKT FCST - SSP 동기화 ( 동기화구간 및 일부 수정 )
 * 2021.01.25	 KUNI		[C20210126-000023] [SCMPI팀] 소형 MKT FCST & SSP 동기화 시 내/외수 구분자 개선 요청건
 * 2021.02.09	 P.C.I 		   [C20210225-000385] MKT_FCST_CONFIRM Table 생성하여 출하실적/매출실적 매핑
 * 2021.04.20	 P.C.I 		   [C20210420-000162] 매출실적이 없는 데이터만 동기화 대상으로 적용(네팅)
 * 2021.05.26	 P.C.I 		   [C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일) 
 * 2021.07.01	HWI1993		[C20210625-000103] SSP - DM 연동 로직 수정 요청의 건
 * 2021.08.24	hwi1993		[pj20209643] bod 유효기간 추가 건
 * 2021.11.23	hwi1993		[C20211122-000433] GSCM SSP - DM간 동기화 대상 중 Pack 제외 요청의 건
							[C20211122-000007]SSP-DM 사내 플랜트 동기화건 수정 요청의 건
 * 2022.01.20	kdw2819		[C20220120-000145] SSP 입력 수량 MKT FCST 미연동 건
 2022.04.07  hwi1993     GM JV 작업
	2022.07.11	hwi1993		[C20220707-000107] MKT FCST 입력 오류건(carry over 중복오류 )
	2022.07.11	hwi1993		[C20220704-000441] 소형수요 간소화 - dom_exp 를 e 로 고정
	2022.07.18	hwi1993		[C20220707-000107]	추가 - change_type 조건 추가 ( 'N':신규생성중, 'C':확정, 'P':계획 -- 현재 미사용)
	2022.08.19	rosia27		[C20220809-000013] SSP-DM 동기화 로직 정비 요청의 건
	2022.09.12	hwi1993		오류 수정
	2025.06.23	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가

   *===================================================================================================
        
-- 1. 동기화할 SSP 데이터를 가져온다.
-- 2. MKT FCST 와 join 해서 INSERT/UPDATE 한다.
-- 3. 네팅 대상 데이터를 가져와서 복사본을 만든다.
-- 4. 키값별로 루프를 돌면서 YYYYMMDD 순서대로 네팅처리한다.
-- 5. 네팅이 끝난 값을 한꺼번에 UPDATE/INSERT 한다.

주의 : 1. 이 프로시저는 월요일에 돌아간다는 가정이라, 월요일이 아닐 경우 일자를 조정해줘야 함.
       2. ERP 실적배치가 끝난 이후에 돌아가야 일요일까지의 실적이 들어온 상태에서 동작하게 됨.

EXEC PR_DM_SSP_SYNC '40'

*/

CREATE PROCEDURE [dbo].[PR_DM_SSP_SYNC]
	@P_DIVISION_ID NVARCHAR(30)				-- 사업부 확장에 대비해서 사업부별로 호출하도록 한다.
AS

BEGIN

	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @V_PROGRAM_NAME		NVARCHAR(150) = 'PR_DM_SSP_SYNC';
    DECLARE @V_LOG_TYPE			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @N_LOG_COUNT		INTEGER = 0;
    DECLARE @V_LOG_MESSAGE		NVARCHAR(1000);
    DECLARE @V_DESCRIPTION		NVARCHAR(500);
    DECLARE @D_EVENT_DATE		DATETIME;
    DECLARE @N_DELETE_COUNT		INTEGER = 0;
    DECLARE @N_INSERT_COUNT     INTEGER = 0;

	-- 시작 LOG
	SET @V_LOG_TYPE = 'START';
	SET @V_LOG_MESSAGE = '########## START OF PROCEDURE ##########';
	SET @V_DESCRIPTION = '';
	SET @D_EVENT_DATE = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE;

	-- 시작 LOG  (END)
	SET @V_LOG_MESSAGE = NULL

	IF OBJECT_ID (N'TEMPDB..#T_SSP', N'U') IS NOT NULL 
		DROP TABLE #T_SSP
	IF OBJECT_ID (N'TEMPDB..#T_SSP_SUM', N'U') IS NOT NULL 
		DROP TABLE #T_SSP_SUM
	IF OBJECT_ID (N'TEMPDB..#T_MKT_RESULT', N'U') IS NOT NULL 
		DROP TABLE #T_MKT_RESULT
	IF OBJECT_ID (N'TEMPDB..#T_MKT_RESULT_SUM', N'U') IS NOT NULL 
		DROP TABLE #T_MKT_RESULT_SUM
	IF OBJECT_ID (N'TEMPDB..#TEMP_SHIP_RESULT', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SHIP_RESULT
	IF OBJECT_ID (N'TEMPDB..#TEMP_SALES_RESULT', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SALES_RESULT


	DECLARE @V_SYNC_DAY_CNT INT			-- 동기화 구간
		, @V_START_YYYYMMDD NVARCHAR(8)
		, @V_END_YYYYMMDD	NVARCHAR(8)
		, @V_NET_YN			NVARCHAR(1)		-- 네팅작업 처리 여부

		-- 네팅 기간
		, @V_NET_START_YYYYMMDD NVARCHAR(8)
		, @V_NET_END_YYYYMMDD	NVARCHAR(8)
		, @V_NET_START_WEEK_CNT	NVARCHAR(2)	-- 네팅시작기간을 몇 주 전부터 시작하는지

		
		, @V_RESULT_START_YYYYMMDD NVARCHAR(8) --[C20210225-000385]

	--BEGIN

	--		SET @V_SYNC_DAY_CNT = 0
	--		SELECT @V_SYNC_DAY_CNT	= SEGMENT2
	--			--, @V_NET_YN			= SEGMENT3 --[C20210225-000385] 룩업 네팅 정보 삭제
	--			, @V_START_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)		-- 동기화구간 ( 금주월요일 부터 시작 )
	--			--, @V_NET_START_WEEK_CNT = SEGMENT4 --[C20210225-000385] 룩업 네팅 정보 삭제
	--		FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	--		WHERE LOOKUP_TYPE = 'DM_SSP_SYNC_OPTION'
	--			AND SEGMENT1 = @P_DIVISION_ID
	--			AND VALID_YN = 'Y'
			
	--		--PRINT @V_SYNC_DAY_CNT

	--		IF ( ISNUMERIC(@V_SYNC_DAY_CNT) < 1 
	--			OR @V_SYNC_DAY_CNT < 1
	--			--OR ISNULL(@V_NET_YN,'') NOT IN ('Y','N') --[C20210225-000385] 룩업 네팅 정보 삭제
	--			)
	--		BEGIN
	--			SET @V_LOG_TYPE = 'END'
	--			SET @V_DESCRIPTION = N'LOOKUP 정보가 없습니다.'
	--			GOTO ERR_RTN
	--		END

	--END


	BEGIN TRAN SALES_SITE_MODEL_PRODUCTION;
	
	BEGIN TRY


		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- 1. 동기화할 SSP 데이터를 가져온다.
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		BEGIN -- SSP 데이터를 가져온다. START
			SET @V_SYNC_DAY_CNT = 0
			SELECT @V_SYNC_DAY_CNT	= SEGMENT2
				--, @V_NET_YN			= SEGMENT3 --[C20210225-000385] 룩업 네팅 정보 삭제
				, @V_START_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)		-- 동기화구간 ( 금주월요일 부터 시작 )
				--, @V_NET_START_WEEK_CNT = SEGMENT4 --[C20210225-000385] 룩업 네팅 정보 삭제
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE LOOKUP_TYPE = 'DM_SSP_SYNC_OPTION'
				AND SEGMENT1 = @P_DIVISION_ID
				AND VALID_YN = 'Y'
			
			IF ( ISNUMERIC(@V_SYNC_DAY_CNT) < 1 
				OR @V_SYNC_DAY_CNT < 1
				--OR ISNULL(@V_NET_YN,'') NOT IN ('Y','N') --[C20210225-000385] 룩업 네팅 정보 삭제
				)
			BEGIN
PRINT @V_SYNC_DAY_CNT

				SET @V_LOG_TYPE = 'INVALID'
				SET @V_DESCRIPTION = N'LOOKUP 정보가 없습니다.'
				GOTO ERR_RTN
			END

			--[C20210225-000385] 룩업 네팅 정보 삭제
			/*
			IF ( ISNUMERIC(@V_NET_START_WEEK_CNT) < 1 
				OR @V_NET_START_WEEK_CNT < 0 )
				AND ISNULL(@V_NET_YN,'') = 'Y'
			BEGIN
				SET @V_LOG_TYPE = 'INVALID'
				SET @V_DESCRIPTION = N'LOOKUP 정보가 잘못되었습니다.'
				GOTO ERR_RTN
			END
			*/
							
			SET @V_END_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DAY, @V_SYNC_DAY_CNT - 1, @V_START_YYYYMMDD), 112)


			-- 네팅 기간 -- 5주전 월요일부터
			-- 지난주 일요일
			/*
			SELECT @V_NET_START_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DAY, -1*(@V_NET_START_WEEK_CNT+1)*7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
				, @V_NET_END_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -1, DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON'))), 112)  
				*/
			-- [C20210225-000385] 실적 기준 Start YYYYMMDD (전월1일/1일은 전전월1일)
			SET @V_RESULT_START_YYYYMMDD = substring(CONVERT(CHAR(8), dateadd(month,	CASE WHEN (SELECT SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, GETDATE()), 112),7,2)) = '01' THEN -2 ELSE -1 END	,getdate()), 112),1,6) + '01'
			
			-- [C20210225-000385] 네팅 구간은 실적일 부터 적용
			SET @V_NET_START_YYYYMMDD = @V_RESULT_START_YYYYMMDD; 
			SET @V_NET_END_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -1, DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON'))), 112)  

				

--SELECT @V_NET_START_YYYYMMDD as NET_START_YYYYMMDD, @V_NET_END_YYYYMMDD as NET_END_YYYYMMDD , @V_NET_START_WEEK_CNT as NET_START_WEEK_CNT
--	, @V_RESULT_START_YYYYMMDD as RESULT_START_YYYYMMDD, @V_START_YYYYMMDD as V_START_YYYYMMDD
--	, @V_END_YYYYMMDD as v_END_YYYYMMDD



			-- 네팅용과 동기화용을 모두 담고있음.
			CREATE TABLE #T_SSP (
			DIVISION_ID			NVARCHAR(30)
			, CONFIRM_ID		NVARCHAR(30) --[C20210225-000385] CONFIRM_ID 추가
			, PROJECT_CODE		NVARCHAR(50)
			, TO_SITE			NVARCHAR(30)
			, ITEM_ID			NVARCHAR(50)
			, FCST_TYPE			NVARCHAR(20)
			, INCOTERMS			NVARCHAR(10)
			, QTY				NUMERIC(30,10)
			, ETA				NVARCHAR(8)
			, DOM_EXP			NVARCHAR(3)
			)

			-- #T_SSP 를 집계
			CREATE TABLE #T_SSP_SUM (
			DIVISION_ID			NVARCHAR(30)
			, CONFIRM_ID		NVARCHAR(MAX) --[C20210225-000385] CONFIRM_ID 추가
			, PROJECT_CODE		NVARCHAR(50)
			, TO_SITE			NVARCHAR(30)
			, ITEM_ID			NVARCHAR(50)
			, FCST_TYPE			NVARCHAR(20)
			, INCOTERMS			NVARCHAR(10)
			, QTY				NUMERIC(30,10)
			, ETA				NVARCHAR(8)
			, DOM_EXP			NVARCHAR(3)
			)

			CREATE TABLE #T_MKT_RESULT (
			DIVISION_ID		NVARCHAR(30)
			, CONFIRM_ID	NVARCHAR(30) --[C20210225-000385] CONFIRM_ID 추가
			, SO_NO			NVARCHAR(10) --[C20210225-000385] SO_NO 추가
			, PROJECT_CODE	NVARCHAR(50)
			, SCM_SITE_ID	NVARCHAR(30)
			, ITEM_ID		NVARCHAR(50)
			, DOM_EXP		NVARCHAR(3)
			, FCST_TYPE		NVARCHAR(20)
			, INCOTERMS		NVARCHAR(10)
			, QTY			NUMERIC(30,10)
			, ROW_NUM		INT				IDENTITY(1,1)
			, SEQ			INT
			)
			
			--[C20210225-000385]
			CREATE TABLE #T_MKT_RESULT_SUM (
			DIVISION_ID		NVARCHAR(30)
			, CONFIRM_ID	NVARCHAR(MAX) 
			, PROJECT_CODE	NVARCHAR(50)
			, SCM_SITE_ID	NVARCHAR(30)
			, ITEM_ID		NVARCHAR(50)
			, DOM_EXP		NVARCHAR(3)
			, FCST_TYPE		NVARCHAR(20)
			, INCOTERMS		NVARCHAR(10)
			, QTY			NUMERIC(30,10)
			, ROW_NUM		INT				IDENTITY(1,1)
			, SEQ			INT
			)

			CREATE TABLE #TEMP_SALES_RESULT (
			DIVISION_ID			NVARCHAR(30)
			, PROJECT_CODE		NVARCHAR(50)
			, SCM_SITE_ID		NVARCHAR(30)
			, ITEM_ID			NVARCHAR(50)
			, QTY				NUMERIC(20,10)
			, SO_NO				NVARCHAR(MAX)
			, SO_QTY			NVARCHAR(MAX)
			, SPLIT_SO_NO		NVARCHAR(10)
			, SO_NO_NUM			INT
			, SPLIT_SO_QTY		NUMERIC(20,10)
			, SO_QTY_NUM		INT
			, CONFIRM_ID		NVARCHAR(30)
			)

			
			---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- Start[C20210225-000385] DM_PLN_MKT_FCST_CONFIRM 데이터 생성
			-- MKT Fcst Key/Confirm ID/SO_NO/Plan_qty/Result_QTY 관리
			-- 
			---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			
			DELETE FROM DM_PLN_MKT_FCST_CONFIRM
			WHERE  DIVISION_ID = @P_DIVISION_ID
			AND    ( ETA BETWEEN @V_RESULT_START_YYYYMMDD AND @V_END_YYYYMMDD
					OR SHIP_YYYYMMDD BETWEEN @V_RESULT_START_YYYYMMDD AND @V_END_YYYYMMDD --[C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일)
					)

		
			INSERT INTO DM_PLN_MKT_FCST_CONFIRM ( DIVISION_ID, CONFIRM_ID, SO_NO 
								, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, ETA, PLAN_QTY
								, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, SHIP_YYYYMMDD  ) --[C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일), SHIP_YYYYMMDD 출하계획일
			SELECT
				T0.DIVISION_ID
				, T0.CONFIRM_ID
				, ISNULL(T0.ERP_SO_NO, 'X')
				, T0.PROJECT_CODE
				, T0.TO_SITE
				, T0.ITEM_ID
				, 'E' AS DOM_EXP
				, T0.FCST_TYPE
				, T1.INCOTERMS
				, '' AS PLANT_SITE_ID
				, T0.ETA_DATE    AS ETA
				, SUM(T0.QTY)    AS CONFIRM_QTY
				, 'SYSTEM', getdate(), 'SYSTEM', getdate()
				, T0.YYYYMMDD  AS SHIP_YYYYMMDD --[C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일), SHIP_YYYYMMDD 출하계획일
			-- [10.34.221.78,7433].LGCE_SCMDEV.DBO.
			FROM SSP_ANL_SHIP_CONFIRM T0 WITH(NOLOCK)
			INNER JOIN SCP_MST_BOD_N_V T1 WITH(NOLOCK) ON T0.DIVISION_ID = T1.DIVISION_ID AND T0.BOD_ID = T1.BOD_ID
			INNER JOIN SCP_MST_DISTRIBUTION_ROUTE T2 WITH(NOLOCK) ON T2.ROUTE_ID = T1.ROUTE_ID
			INNER JOIN SCM_MST_SITE T3 WITH(NOLOCK) ON T0.DIVISION_ID = T3.DIVISION_ID AND T0.TO_SITE = T3.SCM_SITE_ID AND T3.SITE_TYPE = 'SALES'
			WHERE 1=1
			AND   ( T0.YYYYMMDD BETWEEN @V_RESULT_START_YYYYMMDD AND @V_END_YYYYMMDD --[C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일)
					OR T0.ETA_DATE BETWEEN @V_RESULT_START_YYYYMMDD AND @V_END_YYYYMMDD 
				) -- [C20210625-000103]
			AND T0.QTY <> 0
			AND T0.DIVISION_ID   = @P_DIVISION_ID
			AND FCST_TYPE <> '-'	-- MKT_FCST 없는 경우
			AND SHIPMENT_STATUS = 'C'
			AND EXISTS (SELECT 'X'
						FROM   DM_MST_ITEM_SINGLE_V I WITH(NOLOCK)
						WHERE  I.DIVISION_ID = T0.DIVISION_ID
						AND    I.ITEM_ID = T0.ITEM_ID
						AND    I.FORECAST_INFO_BIZ_TYPE IS NOT NULL ) --[C20210225-000385] 전극대상은 동기화에서 제외(FORECAST_INFO_BIZ_TYPE IS NULL)
			AND T0.BIZ_TYPE = 'A'		-- [C20211122-000433]
			AND T0.CHANGE_TYPE = 'C'
			GROUP BY T0.DIVISION_ID
			, T0.CONFIRM_ID --[C20210225-000385]
			, T0.ERP_SO_NO --[C20210225-000385]
			, T0.PROJECT_CODE
			, T0.TO_SITE
			, T0.ITEM_ID
			, T0.FCST_TYPE
			, T1.INCOTERMS
			, T0.ETA_DATE
			, T0.YYYYMMDD --[C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일), SHIP_YYYYMMDD 출하계획일

			--[C20220704-000441] 소형수요 간소화 - dom_exp 를 e 로 고정			
			-- DOM_EXP 못찾는 경우- 소형 영업관리에서 없는 건은 E로 하기로 함.
			UPDATE DM_PLN_MKT_FCST_CONFIRM
			SET DOM_EXP = 'E'
			WHERE DOM_EXP IS NULL
			AND   DIVISION_ID = @P_DIVISION_ID
			AND   ( SHIP_YYYYMMDD BETWEEN @V_RESULT_START_YYYYMMDD AND @V_END_YYYYMMDD --[C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일), SHIP_YYYYMMDD 실적일 적용
						OR ETA BETWEEN @V_RESULT_START_YYYYMMDD AND @V_END_YYYYMMDD 
						) -- [C20210625-000103]

			-- Confrim ID/SO_NO 기준으로 출하 실적 업데이트
			-- DOC_TYPE : D10 생성, D20 공장출고, D30 운송중 재고, D40 매출, D90 삭제
			SELECT  DIVISION_ID, CONFIRM_ID, REPLICATE('0', 10-LEN(RTRIM(ORDER_NO))) + RTRIM(ORDER_NO) AS SO_NO, ITEM_ID, SUM(EXFACTORY_QTY) AS SHIP_RESULT_QTY
			INTO  #TEMP_SHIP_RESULT
			FROM  SCM_DNM_EXFACTORY_RESULT E WITH(NOLOCK)
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
				ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
				AND L.VALID_YN = 'Y'
				AND L.SEGMENT1 = E.SSP_TYPE 
			WHERE 1=1
			AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
			AND   DIVISION_ID = @P_DIVISION_ID
			AND   E.CONFIRM_ID LIKE 'C%'
			AND   E.EXFACTORY_DATE BETWEEN @V_RESULT_START_YYYYMMDD AND @V_END_YYYYMMDD
			AND   E.ORDER_TYPE_CODE NOT IN ( 'ZKM', 'ZKN' ) --소형마케팅에서 ORDER_TYPE('ZKM', 'ZKN')을 다르게 선택하여 출하 실적/매출 실적의 SO_NO가 달라서 사용 불가능 함
			group by DIVISION_ID, CONFIRM_ID, ORDER_NO, ITEM_ID


			--SCM_DNM_EXFACTORY_RESULT SO_NO 출하 실적 데이터 UPDATE
			UPDATE A
			SET SHIP_RESULT_QTY = B.SHIP_RESULT_QTY
			  , PLAN_QTY = (CASE WHEN PLAN_QTY <> B.SHIP_RESULT_QTY THEN B.SHIP_RESULT_QTY ELSE PLAN_QTY END) -- 출하 실적 QTY 기준으로 Plan 맞춤
			  , LAST_UPDATED_BY = 'SYSTEM_RESULT'
			  , LAST_UPDATE_DATE = getdate()
			FROM DM_PLN_MKT_FCST_CONFIRM A WITH(NOLOCK)
			JOIN (SELECT *
					FROM #TEMP_SHIP_RESULT A WITH(NOLOCK)
			) B ON B.DIVISION_ID  = A.DIVISION_ID
				AND B.SO_NO	  = A.SO_NO	
				AND B.ITEM_ID = A.ITEM_ID	
			AND   A.DIVISION_ID = @P_DIVISION_ID
			AND   ( A.SHIP_YYYYMMDD BETWEEN @V_RESULT_START_YYYYMMDD AND @V_END_YYYYMMDD --[C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일), SHIP_YYYYMMDD 실적일 적용
						OR A.ETA BETWEEN @V_RESULT_START_YYYYMMDD AND @V_END_YYYYMMDD 
						) -- [C20210625-000103]
			
			-- SO_NO 기준으로 매출 실적 업데이트			
			INSERT INTO #TEMP_SALES_RESULT (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, QTY, SO_NO, SO_QTY, SPLIT_SO_NO, SO_NO_NUM
											, SPLIT_SO_QTY, SO_QTY_NUM)
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.QTY, A.SO_NO, A.SO_QTY
				 , REPLICATE('0', 10-LEN(RTRIM(SN.VALUE))) + RTRIM(SN.VALUE) AS SPLIT_SO_NO
				 , SN.ID AS SO_NO_NUM, SQ.VALUE AS SPLIT_SO_QTY , SQ.ID AS SO_QTY_NUM
			--FROM [10.34.221.78,7433].[LGCE_SCMDEV].[DBO].DM_PLN_MKT_FCST_RESULT A WITH(NOLOCK)
			-----------------------------------------------------------------------------------------------------
			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (CELL_PROD_SITE_ID와 무관하게 GROUP BY에 의해 SUM(QTY) 처리함.
			--FROM DM_PLN_MKT_FCST_RESULT A WITH(NOLOCK)
			FROM (
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
					 , SO_NO, SO_QTY
					 , SUM(QTY) AS QTY
				FROM DM_PLN_MKT_FCST_RESULT WITH(NOLOCK)
				WHERE  DIVISION_ID = @P_DIVISION_ID
				AND    YYYYMMDD BETWEEN @V_RESULT_START_YYYYMMDD AND @V_END_YYYYMMDD
				AND    MEASURE IN ('RTF' )
				AND    QTY <> 0
				GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
					 , SO_NO, SO_QTY
			) A
			-----------------------------------------------------------------------------------------------------
			CROSS APPLY (  SELECT ID,VALUE FROM DBO.FN_SPLITSTRING(A.SO_NO,','))  SN
			CROSS APPLY (  SELECT ID,VALUE FROM DBO.FN_SPLITSTRING(A.SO_QTY,','))  SQ
			WHERE  DIVISION_ID = @P_DIVISION_ID
			AND    YYYYMMDD BETWEEN @V_RESULT_START_YYYYMMDD AND @V_END_YYYYMMDD
			AND    MEASURE IN ('RTF' )
			AND    QTY <> 0
			AND    SN.ID = SQ.ID
			AND	   SQ.VALUE <> ''	-- 2022.09.12


			UPDATE A
			SET CONFIRM_ID = B.CONFIRM_ID
			FROM #TEMP_SALES_RESULT A
			JOIN XIF_ERP_SHIP_DOC_R_SN B
				ON A.SPLIT_SO_NO = B.DOC_NO

			
			-- SO_NO 기준으로 매출 실적 업데이트	
			UPDATE A
			SET SALES_RESULT_QTY = B.QTY
			  , LAST_UPDATED_BY = 'SYSTEM_SALES_RESULT'
			  , LAST_UPDATE_DATE = getdate()
			FROM DM_PLN_MKT_FCST_CONFIRM A
			INNER JOIN (SELECT A.DIVISION_ID, A.SPLIT_SO_NO, A.ITEM_ID
						, SUM(CAST(CASE WHEN ISNULL(A.SPLIT_SO_QTY,0) = 0 THEN 0 ELSE A.SPLIT_SO_QTY END AS NUMERIC(30,0))) AS QTY
					FROM #TEMP_SALES_RESULT A
					LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND ISNULL(A.SCM_SITE_ID,'') = B.SCM_SITE_ID
					WHERE A.DIVISION_ID  = @P_DIVISION_ID
					GROUP BY A.DIVISION_ID, A.SPLIT_SO_NO, A.ITEM_ID
			) B ON B.DIVISION_ID		 = A.DIVISION_ID
					AND B.SPLIT_SO_NO	 = A.SO_NO	
					AND B.ITEM_ID		 = A.ITEM_ID

			-- CONFIRM_ID 기준으로 매출 실적 업데이트	
			UPDATE A
			SET SALES_RESULT_QTY = B.QTY
			  , LAST_UPDATED_BY = 'SYSTEM_SALES_RESULT'
			  , LAST_UPDATE_DATE = getdate()
			FROM DM_PLN_MKT_FCST_CONFIRM A
			INNER JOIN (SELECT A.DIVISION_ID, A.SPLIT_SO_NO, A.ITEM_ID
						, SUM(CAST(CASE WHEN ISNULL(A.SPLIT_SO_QTY,0) = 0 THEN 0 ELSE A.SPLIT_SO_QTY END AS NUMERIC(30,0))) AS QTY, A.CONFIRM_ID
					FROM #TEMP_SALES_RESULT A WITH(NOLOCK)
					LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND ISNULL(A.SCM_SITE_ID,'') = B.SCM_SITE_ID
					WHERE A.DIVISION_ID  = @P_DIVISION_ID
					GROUP BY A.DIVISION_ID, A.SPLIT_SO_NO, A.ITEM_ID, A.CONFIRM_ID
			) B ON B.DIVISION_ID		 = A.DIVISION_ID
					AND B.ITEM_ID		 = A.ITEM_ID
					AND B.CONFIRM_ID	 = A.CONFIRM_ID		
			WHERE SALES_RESULT_QTY IS NULL

			---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- End [C20210225-000385] DM_PLN_MKT_FCST_CONFIRM 데이터 생성
			---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			
		END		

---- 동기화 테스트용 데이터 추가 생성
--INSERT INTO #T_SSP ( DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID, FCST_TYPE, INCOTERMS, QTY, ETA )
--VALUES ( '40', 'NT', 'NT_CN_CGU', 'MIF409858C11', 'MPS', 'DDP', 100000, '20210104' )
--INSERT INTO #T_SSP ( DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID, FCST_TYPE, INCOTERMS, QTY, ETA )
--VALUES ( '40', 'NT', 'NT_CN_CGU', 'MIF409858C11', 'MPS', 'DDP', 100000, '20210106' )
--SELECT 'X0', @@ROWCOUNT

	--SELECT 'X1', * 
	--FROM #T_SSP
		-- SSP 데이터를 가져온다. END	-----------------------------------------------------------------------------------------------------------------
		
		
		
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--2. MKT FCST 와 join 해서 INSERT/UPDATE 한다.
		-- ATTRIBUTE1 에는 동기화+네팅수량, ATTRIBUTE2 에는 네팅수량을 넣는다. ( SYNC 를 여러번 돌릴 경우 네팅중복 방지 )
		-- [C20210225-000385] ATTRIBUTE4 에는 동기화 CONFIRM_ID
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		BEGIN		-- MKT FCST 와 join 해서 INSERT/UPDATE 한다.
		
			
			INSERT INTO #T_SSP ( DIVISION_ID, CONFIRM_ID --[C20210225-000385] CONFIRM_ID 추가
							   , PROJECT_CODE, TO_SITE, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ETA, QTY )

			SELECT DIVISION_ID, CONFIRM_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
				 , DOM_EXP, FCST_TYPE, INCOTERMS, ETA, SUM(PLAN_QTY) AS QTY
			FROM   DM_PLN_MKT_FCST_CONFIRM WITH(NOLOCK) --[C20210225-000385] DM_PLN_MKT_FCST_CONFIRM 사용
			WHERE  DIVISION_ID = @P_DIVISION_ID
			--[C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일), SHIP_YYYYMMDD 출하계획일
			--AND    ETA BETWEEN @V_START_YYYYMMDD AND @V_END_YYYYMMDD
			AND    SHIP_YYYYMMDD BETWEEN @V_NET_START_YYYYMMDD AND @V_END_YYYYMMDD
			AND    ETA >= @V_START_YYYYMMDD --[C20210528-000332] 매출계획일 당주이후 동기화 데이터 적용
			AND    ISNULL(SALES_RESULT_QTY, 0) = 0 --[C20210420-000162] 매출실적이 없는 데이터만 동기화 대상으로 적용(네팅)
			GROUP BY DIVISION_ID, CONFIRM_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
				 , DOM_EXP, FCST_TYPE, INCOTERMS, ETA


			--Start [C20210225-000385] CONFIRM_ID 추가 
			INSERT INTO #T_SSP_SUM ( DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID
						, FCST_TYPE, INCOTERMS, ETA, DOM_EXP, QTY, CONFIRM_ID ) --[C20210225-000385] CONFIRM_ID 추가 
			select DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID, FCST_TYPE, INCOTERMS, ETA, DOM_EXP					
				, ISNULL((SUM([Q1]) ),0) + ISNULL((SUM([Q2]) ),0) + ISNULL((SUM([Q3]) ),0)  + ISNULL((SUM([Q4]) ),0) + ISNULL((SUM([Q5]) ),0) 
				+ ISNULL((SUM([Q6]) ),0) + ISNULL((SUM([Q7]) ),0) + ISNULL((SUM([Q8]) ),0)  + ISNULL((SUM([Q9]) ),0) + ISNULL((SUM([Q10]) ),0) 
				+ ISNULL((SUM([Q11]) ),0) + ISNULL((SUM([Q12]) ),0) + ISNULL((SUM([Q13]) ),0)  + ISNULL((SUM([Q14]) ),0) + ISNULL((SUM([Q15]) ),0) 
				+ ISNULL((SUM([Q16]) ),0) + ISNULL((SUM([Q17]) ),0) + ISNULL((SUM([Q18]) ),0)  + ISNULL((SUM([Q19]) ),0) + ISNULL((SUM([Q20]) ),0) 
				+ ISNULL((SUM([Q21]) ),0) + ISNULL((SUM([Q22]) ),0) + ISNULL((SUM([Q23]) ),0)  + ISNULL((SUM([Q24]) ),0) + ISNULL((SUM([Q25]) ),0) 
				+ ISNULL((SUM([Q26]) ),0) + ISNULL((SUM([Q27]) ),0) + ISNULL((SUM([Q28]) ),0)  + ISNULL((SUM([Q29]) ),0) + ISNULL((SUM([Q30]) ),0) 
				+ ISNULL((SUM([Q31]) ),0) + ISNULL((SUM([Q32]) ),0) + ISNULL((SUM([Q33]) ),0)  + ISNULL((SUM([Q34]) ),0) + ISNULL((SUM([Q35]) ),0) 
				+ ISNULL((SUM([Q36]) ),0) + ISNULL((SUM([Q37]) ),0) + ISNULL((SUM([Q38]) ),0)  + ISNULL((SUM([Q39]) ),0) + ISNULL((SUM([Q40]) ),0) 
				+ ISNULL((SUM([Q41]) ),0) + ISNULL((SUM([Q42]) ),0) + ISNULL((SUM([Q43]) ),0)  + ISNULL((SUM([Q44]) ),0) + ISNULL((SUM([Q45]) ),0) 
				+ ISNULL((SUM([Q46]) ),0) + ISNULL((SUM([Q47]) ),0) + ISNULL((SUM([Q48]) ),0)  + ISNULL((SUM([Q49]) ),0) + ISNULL((SUM([Q50]) ),0) 
				+ ISNULL((SUM([Q51]) ),0) + ISNULL((SUM([Q52]) ),0) + ISNULL((SUM([Q53]) ),0)  + ISNULL((SUM([Q54]) ),0) + ISNULL((SUM([Q55]) ),0) 
				+ ISNULL((SUM([Q56]) ),0) + ISNULL((SUM([Q57]) ),0) + ISNULL((SUM([Q58]) ),0)  + ISNULL((SUM([Q59]) ),0) + ISNULL((SUM([Q60]) ),0) 
				+ ISNULL((SUM([Q61]) ),0) + ISNULL((SUM([Q62]) ),0) + ISNULL((SUM([Q63]) ),0)  + ISNULL((SUM([Q64]) ),0) + ISNULL((SUM([Q65]) ),0) 
				+ ISNULL((SUM([Q66]) ),0) + ISNULL((SUM([Q67]) ),0) + ISNULL((SUM([Q68]) ),0)  + ISNULL((SUM([Q69]) ),0) + ISNULL((SUM([Q70]) ),0) 
				+ ISNULL((SUM([Q71]) ),0) + ISNULL((SUM([Q72]) ),0) + ISNULL((SUM([Q73]) ),0)  + ISNULL((SUM([Q74]) ),0) + ISNULL((SUM([Q75]) ),0) 
				+ ISNULL((SUM([Q76]) ),0) + ISNULL((SUM([Q77]) ),0) + ISNULL((SUM([Q78]) ),0)  + ISNULL((SUM([Q79]) ),0) + ISNULL((SUM([Q80]) ),0) 
				+ ISNULL((SUM([Q81]) ),0) + ISNULL((SUM([Q82]) ),0) + ISNULL((SUM([Q83]) ),0)  + ISNULL((SUM([Q84]) ),0) + ISNULL((SUM([Q85]) ),0) 
				+ ISNULL((SUM([Q86]) ),0) + ISNULL((SUM([Q87]) ),0) + ISNULL((SUM([Q88]) ),0)  + ISNULL((SUM([Q89]) ),0) + ISNULL((SUM([Q90]) ),0) 
				+ ISNULL((SUM([Q91]) ),0) + ISNULL((SUM([Q92]) ),0) + ISNULL((SUM([Q93]) ),0)  + ISNULL((SUM([Q94]) ),0) + ISNULL((SUM([Q95]) ),0) 
				+ ISNULL((SUM([Q96]) ),0) + ISNULL((SUM([Q97]) ),0) + ISNULL((SUM([Q98]) ),0)  + ISNULL((SUM([Q99]) ),0) + ISNULL((SUM([Q100]) ),0)  AS QTY --[C20210225-000385] QTY 합계 추가
				, ISNULL(MAX([C1]),'') + CASE WHEN MAX([C2]) IS NULL THEN '' ELSE ',' + MAX([C2]) END
					+ CASE WHEN MAX([C3]) IS NULL THEN '' ELSE ',' + MAX([C3]) END	+ CASE WHEN MAX([C4]) IS NULL THEN '' ELSE ',' + MAX([C4]) END
					+ CASE WHEN MAX([C5]) IS NULL THEN '' ELSE ',' + MAX([C5]) END	+ CASE WHEN MAX([C6]) IS NULL THEN '' ELSE ',' + MAX([C6]) END
					+ CASE WHEN MAX([C7]) IS NULL THEN '' ELSE ',' + MAX([C7]) END	+ CASE WHEN MAX([C8]) IS NULL THEN '' ELSE ',' + MAX([C8]) END
					+ CASE WHEN MAX([C9]) IS NULL THEN '' ELSE ',' + MAX([C9]) END	+ CASE WHEN MAX([C10]) IS NULL THEN '' ELSE ',' + MAX([C10]) END 
					+ CASE WHEN MAX([C11]) IS NULL THEN '' ELSE ',' + MAX([C11]) END 	+ CASE WHEN MAX([C12]) IS NULL THEN '' ELSE ',' + MAX([C12]) END
					+ CASE WHEN MAX([C13]) IS NULL THEN '' ELSE ',' + MAX([C13]) END	+ CASE WHEN MAX([C14]) IS NULL THEN '' ELSE ',' + MAX([C14]) END
					+ CASE WHEN MAX([C15]) IS NULL THEN '' ELSE ',' + MAX([C15]) END	+ CASE WHEN MAX([C16]) IS NULL THEN '' ELSE ',' + MAX([C16]) END
					+ CASE WHEN MAX([C17]) IS NULL THEN '' ELSE ',' + MAX([C17]) END	+ CASE WHEN MAX([C18]) IS NULL THEN '' ELSE ',' + MAX([C18]) END
					+ CASE WHEN MAX([C19]) IS NULL THEN '' ELSE ',' + MAX([C19]) END	+ CASE WHEN MAX([C20]) IS NULL THEN '' ELSE ',' + MAX([C20]) END
					+ CASE WHEN MAX([C21]) IS NULL THEN '' ELSE ',' + MAX([C21]) END 	+ CASE WHEN MAX([C22]) IS NULL THEN '' ELSE ',' + MAX([C22]) END
					+ CASE WHEN MAX([C23]) IS NULL THEN '' ELSE ',' + MAX([C23]) END	+ CASE WHEN MAX([C24]) IS NULL THEN '' ELSE ',' + MAX([C24]) END
					+ CASE WHEN MAX([C25]) IS NULL THEN '' ELSE ',' + MAX([C25]) END	+ CASE WHEN MAX([C26]) IS NULL THEN '' ELSE ',' + MAX([C26]) END
					+ CASE WHEN MAX([C27]) IS NULL THEN '' ELSE ',' + MAX([C27]) END	+ CASE WHEN MAX([C28]) IS NULL THEN '' ELSE ',' + MAX([C28]) END
					+ CASE WHEN MAX([C29]) IS NULL THEN '' ELSE ',' + MAX([C29]) END	+ CASE WHEN MAX([C30]) IS NULL THEN '' ELSE ',' + MAX([C30]) END 
					+ CASE WHEN MAX([C31]) IS NULL THEN '' ELSE ',' + MAX([C31]) END 	+ CASE WHEN MAX([C32]) IS NULL THEN '' ELSE ',' + MAX([C32]) END
					+ CASE WHEN MAX([C33]) IS NULL THEN '' ELSE ',' + MAX([C33]) END	+ CASE WHEN MAX([C34]) IS NULL THEN '' ELSE ',' + MAX([C34]) END
					+ CASE WHEN MAX([C35]) IS NULL THEN '' ELSE ',' + MAX([C35]) END	+ CASE WHEN MAX([C36]) IS NULL THEN '' ELSE ',' + MAX([C36]) END
					+ CASE WHEN MAX([C37]) IS NULL THEN '' ELSE ',' + MAX([C37]) END	+ CASE WHEN MAX([C38]) IS NULL THEN '' ELSE ',' + MAX([C38]) END
					+ CASE WHEN MAX([C39]) IS NULL THEN '' ELSE ',' + MAX([C39]) END	+ CASE WHEN MAX([C40]) IS NULL THEN '' ELSE ',' + MAX([C40]) END 
					+ CASE WHEN MAX([C41]) IS NULL THEN '' ELSE ',' + MAX([C41]) END 	+ CASE WHEN MAX([C42]) IS NULL THEN '' ELSE ',' + MAX([C42]) END
					+ CASE WHEN MAX([C43]) IS NULL THEN '' ELSE ',' + MAX([C43]) END	+ CASE WHEN MAX([C44]) IS NULL THEN '' ELSE ',' + MAX([C44]) END
					+ CASE WHEN MAX([C45]) IS NULL THEN '' ELSE ',' + MAX([C45]) END	+ CASE WHEN MAX([C46]) IS NULL THEN '' ELSE ',' + MAX([C46]) END
					+ CASE WHEN MAX([C47]) IS NULL THEN '' ELSE ',' + MAX([C47]) END	+ CASE WHEN MAX([C48]) IS NULL THEN '' ELSE ',' + MAX([C48]) END
					+ CASE WHEN MAX([C49]) IS NULL THEN '' ELSE ',' + MAX([C49]) END	+ CASE WHEN MAX([C50]) IS NULL THEN '' ELSE ',' + MAX([C50]) END 
					+ CASE WHEN MAX([C51]) IS NULL THEN '' ELSE ',' + MAX([C51]) END 	+ CASE WHEN MAX([C52]) IS NULL THEN '' ELSE ',' + MAX([C52]) END
					+ CASE WHEN MAX([C53]) IS NULL THEN '' ELSE ',' + MAX([C53]) END	+ CASE WHEN MAX([C54]) IS NULL THEN '' ELSE ',' + MAX([C54]) END
					+ CASE WHEN MAX([C55]) IS NULL THEN '' ELSE ',' + MAX([C55]) END	+ CASE WHEN MAX([C56]) IS NULL THEN '' ELSE ',' + MAX([C56]) END
					+ CASE WHEN MAX([C57]) IS NULL THEN '' ELSE ',' + MAX([C57]) END	+ CASE WHEN MAX([C58]) IS NULL THEN '' ELSE ',' + MAX([C58]) END
					+ CASE WHEN MAX([C59]) IS NULL THEN '' ELSE ',' + MAX([C59]) END	+ CASE WHEN MAX([C60]) IS NULL THEN '' ELSE ',' + MAX([C60]) END 
					+ CASE WHEN MAX([C61]) IS NULL THEN '' ELSE ',' + MAX([C61]) END 	+ CASE WHEN MAX([C62]) IS NULL THEN '' ELSE ',' + MAX([C62]) END
					+ CASE WHEN MAX([C63]) IS NULL THEN '' ELSE ',' + MAX([C63]) END	+ CASE WHEN MAX([C64]) IS NULL THEN '' ELSE ',' + MAX([C64]) END
					+ CASE WHEN MAX([C65]) IS NULL THEN '' ELSE ',' + MAX([C65]) END	+ CASE WHEN MAX([C66]) IS NULL THEN '' ELSE ',' + MAX([C66]) END
					+ CASE WHEN MAX([C67]) IS NULL THEN '' ELSE ',' + MAX([C67]) END	+ CASE WHEN MAX([C68]) IS NULL THEN '' ELSE ',' + MAX([C68]) END
					+ CASE WHEN MAX([C69]) IS NULL THEN '' ELSE ',' + MAX([C69]) END	+ CASE WHEN MAX([C70]) IS NULL THEN '' ELSE ',' + MAX([C70]) END 
					+ CASE WHEN MAX([C71]) IS NULL THEN '' ELSE ',' + MAX([C71]) END 	+ CASE WHEN MAX([C72]) IS NULL THEN '' ELSE ',' + MAX([C72]) END
					+ CASE WHEN MAX([C73]) IS NULL THEN '' ELSE ',' + MAX([C73]) END	+ CASE WHEN MAX([C74]) IS NULL THEN '' ELSE ',' + MAX([C74]) END
					+ CASE WHEN MAX([C75]) IS NULL THEN '' ELSE ',' + MAX([C75]) END	+ CASE WHEN MAX([C76]) IS NULL THEN '' ELSE ',' + MAX([C76]) END
					+ CASE WHEN MAX([C77]) IS NULL THEN '' ELSE ',' + MAX([C77]) END	+ CASE WHEN MAX([C78]) IS NULL THEN '' ELSE ',' + MAX([C78]) END
					+ CASE WHEN MAX([C79]) IS NULL THEN '' ELSE ',' + MAX([C79]) END	+ CASE WHEN MAX([C80]) IS NULL THEN '' ELSE ',' + MAX([C80]) END 
					+ CASE WHEN MAX([C81]) IS NULL THEN '' ELSE ',' + MAX([C81]) END 	+ CASE WHEN MAX([C82]) IS NULL THEN '' ELSE ',' + MAX([C82]) END
					+ CASE WHEN MAX([C83]) IS NULL THEN '' ELSE ',' + MAX([C83]) END	+ CASE WHEN MAX([C84]) IS NULL THEN '' ELSE ',' + MAX([C84]) END
					+ CASE WHEN MAX([C85]) IS NULL THEN '' ELSE ',' + MAX([C85]) END	+ CASE WHEN MAX([C86]) IS NULL THEN '' ELSE ',' + MAX([C86]) END
					+ CASE WHEN MAX([C87]) IS NULL THEN '' ELSE ',' + MAX([C87]) END	+ CASE WHEN MAX([C88]) IS NULL THEN '' ELSE ',' + MAX([C88]) END
					+ CASE WHEN MAX([C89]) IS NULL THEN '' ELSE ',' + MAX([C89]) END	+ CASE WHEN MAX([C90]) IS NULL THEN '' ELSE ',' + MAX([C90]) END
					+ CASE WHEN MAX([C91]) IS NULL THEN '' ELSE ',' + MAX([C91]) END 	+ CASE WHEN MAX([C92]) IS NULL THEN '' ELSE ',' + MAX([C92]) END
					+ CASE WHEN MAX([C93]) IS NULL THEN '' ELSE ',' + MAX([C93]) END	+ CASE WHEN MAX([C94]) IS NULL THEN '' ELSE ',' + MAX([C94]) END
					+ CASE WHEN MAX([C95]) IS NULL THEN '' ELSE ',' + MAX([C95]) END	+ CASE WHEN MAX([C96]) IS NULL THEN '' ELSE ',' + MAX([C96]) END
					+ CASE WHEN MAX([C97]) IS NULL THEN '' ELSE ',' + MAX([C97]) END	+ CASE WHEN MAX([C98]) IS NULL THEN '' ELSE ',' + MAX([C98]) END
					+ CASE WHEN MAX([C99]) IS NULL THEN '' ELSE ',' + MAX([C99]) END	+ CASE WHEN MAX([C100]) IS NULL THEN '' ELSE ',' + MAX([C100]) END AS CONFIRM_ID --[C20210225-000385] CONFIRM_ID 추가

			from   (
				select *
						, 'C' + CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID, FCST_TYPE, INCOTERMS, ETA, DOM_EXP
											ORDER BY CONFIRM_ID ) AS NVARCHAR(10)) CONFIRM_ID_ROW
						, 'Q' + CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID, FCST_TYPE, INCOTERMS, ETA, DOM_EXP
											ORDER BY CONFIRM_ID ) AS NVARCHAR(10)) QTY_NUM
				from   #T_SSP WITH(NOLOCK)) A
			PIVOT (				
				MAX(CONFIRM_ID) FOR CONFIRM_ID_ROW IN ( [C1], [C2], [C3], [C4], [C5], [C6], [C7], [C8], [C9], [C10] ,[C11], [C12], [C13], [C14], [C15], [C16], [C17], [C18], [C19], [C20]
											,[C21], [C22], [C23], [C24], [C25], [C26], [C27], [C28], [C29], [C30],[C31], [C32], [C33], [C34], [C35], [C36], [C37], [C38], [C39], [C40]
											,[C41], [C42], [C43], [C44], [C45], [C46], [C47], [C48], [C49], [C50],[C51], [C52], [C53], [C54], [C55], [C56], [C57], [C58], [C59], [C60]
											,[C61], [C62], [C63], [C64], [C65], [C66], [C67], [C68], [C69], [C70],[C71], [C72], [C73], [C74], [C75], [C76], [C77], [C78], [C79], [C80]
											,[C81], [C82], [C83], [C84], [C85], [C86], [C87], [C88], [C89], [C90],[C91], [C92], [C93], [C94], [C95], [C96], [C97], [C98], [C99], [C100]  )
				) AS PVT1 --[C20210225-000385] Key 값 기준으로 최대 100개 SO_NO를 갖을 수 있음
			PIVOT (
				SUM(QTY) FOR QTY_NUM IN ( [Q1], [Q2], [Q3], [Q4], [Q5], [Q6], [Q7], [Q8], [Q9], [Q10] ,[Q11], [Q12], [Q13], [Q14], [Q15], [Q16], [Q17], [Q18], [Q19], [Q20]
											,[Q21], [Q22], [Q23], [Q24], [Q25], [Q26], [Q27], [Q28], [Q29], [Q30],[Q31], [Q32], [Q33], [Q34], [Q35], [Q36], [Q37], [Q38], [Q39], [Q40]
											,[Q41], [Q42], [Q43], [Q44], [Q45], [Q46], [Q47], [Q48], [Q49], [Q50],[Q51], [Q52], [Q53], [Q54], [Q55], [Q56], [Q57], [Q58], [Q59], [Q60]
											,[Q61], [Q62], [Q63], [Q64], [Q65], [Q66], [Q67], [Q68], [Q69], [Q70],[Q71], [Q72], [Q73], [Q74], [Q75], [Q76], [Q77], [Q78], [Q79], [Q80]
											,[Q81], [Q82], [Q83], [Q84], [Q85], [Q86], [Q87], [Q88], [Q89], [Q90],[Q91], [Q92], [Q93], [Q94], [Q95], [Q96], [Q97], [Q98], [Q99], [Q100]  )
				) AS PVT2 --[C20210225-000385] Key 값 기준으로 최대 100개 SO_NO를 갖을 수 있음

			group by DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID, FCST_TYPE, INCOTERMS, ETA, DOM_EXP

			
			--End [C20210225-000385] CONFIRM_ID 추가 

			

			--[C20210225-000385] 동기화 데이터 삭제
			UPDATE A
			SET QTY = CASE	WHEN A.QTY - CAST(A.ATTRIBUTE1 AS NUMERIC(30,10)) - CAST(A.ATTRIBUTE3 AS NUMERIC(30,10)) > 0 THEN A.QTY
							ELSE CAST(A.ATTRIBUTE1 AS NUMERIC(30,10))
					  END
				, ATTRIBUTE3 = ''
				, ATTRIBUTE4 = ''
				, LAST_UPDATED_BY = 'SSP_SYNC_DEL'
				, LAST_UPDATE_DATE = GETDATE() 
			FROM DM_PLN_MKT_FCST A
			WHERE A.DIVISION_ID = @P_DIVISION_ID
			--[C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일), 매출계획일 당주이후 동기화 데이터 삭제
			--AND A.YYYYMMDD BETWEEN @V_START_YYYYMMDD AND @V_END_YYYYMMDD
			AND A.YYYYMMDD >= @V_START_YYYYMMDD
			AND A.MEASURE = 'MKT_FCST'
			AND ISNUMERIC(A.ATTRIBUTE3) > 0


			-- MKT FCST 테이블에 인서트/업데이트
			MERGE INTO DM_PLN_MKT_FCST A
			USING (
				SELECT DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ETA, QTY, CONFIRM_ID --[C20210225-000385] CONFIRM_ID 추가
				FROM #T_SSP_SUM WITH(NOLOCK)
				WHERE 1=1 -- ETA BETWEEN @V_START_YYYYMMDD AND @V_END_YYYYMMDD --[C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일)
				) B ON A.DIVISION_ID		 = B.DIVISION_ID
						AND A.PROJECT_CODE	 = B.PROJECT_CODE	
						AND A.SCM_SITE_ID	 = B.TO_SITE	
						AND A.ITEM_ID		 = B.ITEM_ID
						AND A.DOM_EXP		 = B.DOM_EXP		
						AND A.FCST_TYPE		 = B.FCST_TYPE		
						AND A.INCOTERMS		 = B.INCOTERMS		
						AND A.YYYYMMDD		 = B.ETA
						AND A.MEASURE = 'MKT_FCST'

			WHEN MATCHED THEN
				--UPDATE SET QTY = CASE	WHEN ISNUMERIC(A.ATTRIBUTE1) > 0 AND CAST(A.ATTRIBUTE1 AS NUMERIC(30,10)) > 0 
				--							THEN   CASE	WHEN CAST(A.ATTRIBUTE1 AS NUMERIC(30,10)) > B.QTY THEN A.ATTRIBUTE1
				--										ELSE B.QTY
				--										END	-- 동기화된 적이 있는 건에 대해 다시 동기화하는 경우
				--						ELSE 
				--							CASE WHEN A.QTY > B.QTY THEN A.QTY
				--								ELSE B.QTY
				--								END
				--						END	-- QTY 에는 MF 값과 SSP 중 큰 값을 넣는다.
				-- [C20210112-000446]
				UPDATE SET QTY = CASE WHEN ISNUMERIC(A.ATTRIBUTE3) > 0 AND CAST(A.ATTRIBUTE3 AS NUMERIC(30,10)) > 0 
											AND A.QTY  = CAST(A.ATTRIBUTE3 AS NUMERIC(30,10))
												THEN B.QTY
									ELSE CASE WHEN A.QTY > B.QTY THEN A.QTY
												ELSE B.QTY
												END
									END
						, ATTRIBUTE1 = CASE WHEN ISNUMERIC(A.ATTRIBUTE1) > 0 THEN ATTRIBUTE1
											ELSE A.QTY
											END	-- 동기화 수량에는 mkt fcst수량을 넣는다.
						, ATTRIBUTE2 = NULL
						, ATTRIBUTE3 = B.QTY
						, ATTRIBUTE4 = B.CONFIRM_ID --[C20210225-000385] CONFIRM_ID 추가
						, LAST_UPDATED_BY = 'SSP_SYNC' 
						, LAST_UPDATE_DATE = GETDATE()
			WHEN NOT MATCHED THEN 
				INSERT ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
					 , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
					 , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
					 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
					 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
				VALUES ( B.DIVISION_ID, B.PROJECT_CODE, B.TO_SITE, B.ITEM_ID, B.DOM_EXP
					 , B.FCST_TYPE, B.INCOTERMS, 'MKT_FCST', '', B.ETA
					 , B.QTY, 'SSP_SYNC', GETDATE(), 'SSP_SYNC', GETDATE()
					 , '0', '', B.QTY, B.CONFIRM_ID, '', '', '', '', '', '' );--[C20210225-000385] CONFIRM_ID 추가
		END
		--	2. MKT FCST 와 join 해서 INSERT/UPDATE -- END .-----------------------------------------------------------------------------------
		
		

		
		-- 네팅 시작 ( 실적도 있고, 계획도 있는건 - 계획보다 실적이 빨리 발생한 경우 )
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- 3. 네팅 대상 데이터를 가져와서 복사본을 만든다.
		-- ATTRIBUTE1 에는 동기화+네팅수량, ATTRIBUTE2 에는 네팅수량을 넣는다. ( SYNC 를 여러번 돌릴 경우 네팅중복 방지 )
		-- [C20210225-000385] ATTRIBUTE5 에는 캐리오버 CONFIRM_ID, ATTRIBUTE6 에는 네팅 CONFIRM_ID
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--Start [C20210225-000385] MKT Result CONFIRM_ID - SO_NO 데이터로 변경
		--	Plan 컨펌값이 존재하는 데이터 중 매출일이 지났으나 Result(ERP)에 일치하는 값이 없을 경우 미실행으로 보고 동기화 데이터에서 제외
		INSERT INTO #T_MKT_RESULT ( DIVISION_ID, CONFIRM_ID, SO_NO, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP --[C20210225-000385] CONFIRM_ID, SO_NO 추가
					, FCST_TYPE, INCOTERMS, QTY )
		SELECT DIVISION_ID, CONFIRM_ID, SO_NO, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS --[C20210225-000385] CONFIRM_ID, SO_NO 추가
			 , SUM(ISNULL(PLAN_QTY, 0) - ISNULL(SALES_RESULT_QTY, 0)) AS QTY
		FROM   DM_PLN_MKT_FCST_CONFIRM with(nolock)
		WHERE  DIVISION_ID = @P_DIVISION_ID
		AND    ( SHIP_YYYYMMDD BETWEEN @V_NET_START_YYYYMMDD AND @V_END_YYYYMMDD
				OR ETA BETWEEN @V_NET_START_YYYYMMDD AND @V_END_YYYYMMDD
				) -- [C20210625-000103]
		AND    ISNULL(SHIP_RESULT_QTY, 0) <> 0
		GROUP BY DIVISION_ID, CONFIRM_ID, SO_NO, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS --[C20210225-000385] CONFIRM_ID, SO_NO 추가
		HAVING  SUM(ISNULL(PLAN_QTY, 0)) <> SUM(ISNULL(SALES_RESULT_QTY, 0))

		-- [C20220707-000107] 일반 동기화에 들어있는 confirm id 는 carry over 대상에서 제거함
		DELETE A
		FROM #T_MKT_RESULT A
		JOIN #T_SSP B ON A.CONFIRM_ID = B.CONFIRM_ID

--select * from #T_MKT_RESULT
		
		--End [C20210225-000385] MKT Result CONFIRM_ID - SO_NO 데이터로 변경

-- N'★★★★★★		PK 오류 날 수 있는 지 확인 필요함	--> 안남. PK 로 GROUP BY 처리	★★★★★'


		-- [C20210225-000385] 실적이 계획보다 적게 들어온 경우 SUM

-- 네팅 및 캐리오버 대상		
		INSERT INTO #T_MKT_RESULT_SUM ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP --[C20210225-000385] CONFIRM_ID, SO_NO 추가
					, FCST_TYPE, INCOTERMS, QTY, CONFIRM_ID )
		select DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
			, ISNULL((SUM([Q1]) ),0) + ISNULL((SUM([Q2]) ),0) + ISNULL((SUM([Q3]) ),0)  + ISNULL((SUM([Q4]) ),0) + ISNULL((SUM([Q5]) ),0) 
			+ ISNULL((SUM([Q6]) ),0) + ISNULL((SUM([Q7]) ),0) + ISNULL((SUM([Q8]) ),0)  + ISNULL((SUM([Q9]) ),0) + ISNULL((SUM([Q10]) ),0) 
			+ ISNULL((SUM([Q11]) ),0) + ISNULL((SUM([Q12]) ),0) + ISNULL((SUM([Q13]) ),0)  + ISNULL((SUM([Q14]) ),0) + ISNULL((SUM([Q15]) ),0) 
			+ ISNULL((SUM([Q16]) ),0) + ISNULL((SUM([Q17]) ),0) + ISNULL((SUM([Q18]) ),0)  + ISNULL((SUM([Q19]) ),0) + ISNULL((SUM([Q20]) ),0) 
			+ ISNULL((SUM([Q21]) ),0) + ISNULL((SUM([Q22]) ),0) + ISNULL((SUM([Q23]) ),0)  + ISNULL((SUM([Q24]) ),0) + ISNULL((SUM([Q25]) ),0) 
			+ ISNULL((SUM([Q26]) ),0) + ISNULL((SUM([Q27]) ),0) + ISNULL((SUM([Q28]) ),0)  + ISNULL((SUM([Q29]) ),0) + ISNULL((SUM([Q30]) ),0) 
			+ ISNULL((SUM([Q31]) ),0) + ISNULL((SUM([Q32]) ),0) + ISNULL((SUM([Q33]) ),0)  + ISNULL((SUM([Q34]) ),0) + ISNULL((SUM([Q35]) ),0) 
			+ ISNULL((SUM([Q36]) ),0) + ISNULL((SUM([Q37]) ),0) + ISNULL((SUM([Q38]) ),0)  + ISNULL((SUM([Q39]) ),0) + ISNULL((SUM([Q40]) ),0) 
			+ ISNULL((SUM([Q51]) ),0) + ISNULL((SUM([Q52]) ),0) + ISNULL((SUM([Q53]) ),0)  + ISNULL((SUM([Q54]) ),0) + ISNULL((SUM([Q55]) ),0) 
			+ ISNULL((SUM([Q56]) ),0) + ISNULL((SUM([Q57]) ),0) + ISNULL((SUM([Q58]) ),0)  + ISNULL((SUM([Q59]) ),0) + ISNULL((SUM([Q60]) ),0) 
			+ ISNULL((SUM([Q61]) ),0) + ISNULL((SUM([Q62]) ),0) + ISNULL((SUM([Q63]) ),0)  + ISNULL((SUM([Q64]) ),0) + ISNULL((SUM([Q65]) ),0) 
			+ ISNULL((SUM([Q66]) ),0) + ISNULL((SUM([Q67]) ),0) + ISNULL((SUM([Q68]) ),0)  + ISNULL((SUM([Q69]) ),0) + ISNULL((SUM([Q70]) ),0) 
			+ ISNULL((SUM([Q71]) ),0) + ISNULL((SUM([Q72]) ),0) + ISNULL((SUM([Q73]) ),0)  + ISNULL((SUM([Q74]) ),0) + ISNULL((SUM([Q75]) ),0) 
			+ ISNULL((SUM([Q76]) ),0) + ISNULL((SUM([Q77]) ),0) + ISNULL((SUM([Q78]) ),0)  + ISNULL((SUM([Q79]) ),0) + ISNULL((SUM([Q80]) ),0) 
			+ ISNULL((SUM([Q81]) ),0) + ISNULL((SUM([Q82]) ),0) + ISNULL((SUM([Q83]) ),0)  + ISNULL((SUM([Q84]) ),0) + ISNULL((SUM([Q85]) ),0) 
			+ ISNULL((SUM([Q86]) ),0) + ISNULL((SUM([Q87]) ),0) + ISNULL((SUM([Q88]) ),0)  + ISNULL((SUM([Q89]) ),0) + ISNULL((SUM([Q90]) ),0) 
			+ ISNULL((SUM([Q91]) ),0) + ISNULL((SUM([Q92]) ),0) + ISNULL((SUM([Q93]) ),0)  + ISNULL((SUM([Q94]) ),0) + ISNULL((SUM([Q95]) ),0) 
			+ ISNULL((SUM([Q96]) ),0) + ISNULL((SUM([Q97]) ),0) + ISNULL((SUM([Q98]) ),0)  + ISNULL((SUM([Q99]) ),0) + ISNULL((SUM([Q100]) ),0)  AS QTY --[C20210225-000385] QTY 합계 추가
			, ISNULL(MAX([C1]),'') + CASE WHEN MAX([C2]) IS NULL THEN '' ELSE ',' + MAX([C2]) END
				+ CASE WHEN MAX([C3]) IS NULL THEN '' ELSE ',' + MAX([C3]) END	+ CASE WHEN MAX([C4]) IS NULL THEN '' ELSE ',' + MAX([C4]) END
				+ CASE WHEN MAX([C5]) IS NULL THEN '' ELSE ',' + MAX([C5]) END	+ CASE WHEN MAX([C6]) IS NULL THEN '' ELSE ',' + MAX([C6]) END
				+ CASE WHEN MAX([C7]) IS NULL THEN '' ELSE ',' + MAX([C7]) END	+ CASE WHEN MAX([C8]) IS NULL THEN '' ELSE ',' + MAX([C8]) END
				+ CASE WHEN MAX([C9]) IS NULL THEN '' ELSE ',' + MAX([C9]) END	+ CASE WHEN MAX([C10]) IS NULL THEN '' ELSE ',' + MAX([C10]) END 
				+ CASE WHEN MAX([C11]) IS NULL THEN '' ELSE ',' + MAX([C11]) END 	+ CASE WHEN MAX([C12]) IS NULL THEN '' ELSE ',' + MAX([C12]) END
				+ CASE WHEN MAX([C13]) IS NULL THEN '' ELSE ',' + MAX([C13]) END	+ CASE WHEN MAX([C14]) IS NULL THEN '' ELSE ',' + MAX([C14]) END
				+ CASE WHEN MAX([C15]) IS NULL THEN '' ELSE ',' + MAX([C15]) END	+ CASE WHEN MAX([C16]) IS NULL THEN '' ELSE ',' + MAX([C16]) END
				+ CASE WHEN MAX([C17]) IS NULL THEN '' ELSE ',' + MAX([C17]) END	+ CASE WHEN MAX([C18]) IS NULL THEN '' ELSE ',' + MAX([C18]) END
				+ CASE WHEN MAX([C19]) IS NULL THEN '' ELSE ',' + MAX([C19]) END	+ CASE WHEN MAX([C20]) IS NULL THEN '' ELSE ',' + MAX([C20]) END
				+ CASE WHEN MAX([C21]) IS NULL THEN '' ELSE ',' + MAX([C21]) END 	+ CASE WHEN MAX([C22]) IS NULL THEN '' ELSE ',' + MAX([C22]) END
				+ CASE WHEN MAX([C23]) IS NULL THEN '' ELSE ',' + MAX([C23]) END	+ CASE WHEN MAX([C24]) IS NULL THEN '' ELSE ',' + MAX([C24]) END
				+ CASE WHEN MAX([C25]) IS NULL THEN '' ELSE ',' + MAX([C25]) END	+ CASE WHEN MAX([C26]) IS NULL THEN '' ELSE ',' + MAX([C26]) END
				+ CASE WHEN MAX([C27]) IS NULL THEN '' ELSE ',' + MAX([C27]) END	+ CASE WHEN MAX([C28]) IS NULL THEN '' ELSE ',' + MAX([C28]) END
				+ CASE WHEN MAX([C29]) IS NULL THEN '' ELSE ',' + MAX([C29]) END	+ CASE WHEN MAX([C30]) IS NULL THEN '' ELSE ',' + MAX([C30]) END 
				+ CASE WHEN MAX([C31]) IS NULL THEN '' ELSE ',' + MAX([C31]) END 	+ CASE WHEN MAX([C32]) IS NULL THEN '' ELSE ',' + MAX([C32]) END
				+ CASE WHEN MAX([C33]) IS NULL THEN '' ELSE ',' + MAX([C33]) END	+ CASE WHEN MAX([C34]) IS NULL THEN '' ELSE ',' + MAX([C34]) END
				+ CASE WHEN MAX([C35]) IS NULL THEN '' ELSE ',' + MAX([C35]) END	+ CASE WHEN MAX([C36]) IS NULL THEN '' ELSE ',' + MAX([C36]) END
				+ CASE WHEN MAX([C37]) IS NULL THEN '' ELSE ',' + MAX([C37]) END	+ CASE WHEN MAX([C38]) IS NULL THEN '' ELSE ',' + MAX([C38]) END
				+ CASE WHEN MAX([C39]) IS NULL THEN '' ELSE ',' + MAX([C39]) END	+ CASE WHEN MAX([C40]) IS NULL THEN '' ELSE ',' + MAX([C40]) END 
				+ CASE WHEN MAX([C41]) IS NULL THEN '' ELSE ',' + MAX([C41]) END 	+ CASE WHEN MAX([C42]) IS NULL THEN '' ELSE ',' + MAX([C42]) END
				+ CASE WHEN MAX([C43]) IS NULL THEN '' ELSE ',' + MAX([C43]) END	+ CASE WHEN MAX([C44]) IS NULL THEN '' ELSE ',' + MAX([C44]) END
				+ CASE WHEN MAX([C45]) IS NULL THEN '' ELSE ',' + MAX([C45]) END	+ CASE WHEN MAX([C46]) IS NULL THEN '' ELSE ',' + MAX([C46]) END
				+ CASE WHEN MAX([C47]) IS NULL THEN '' ELSE ',' + MAX([C47]) END	+ CASE WHEN MAX([C48]) IS NULL THEN '' ELSE ',' + MAX([C48]) END
				+ CASE WHEN MAX([C49]) IS NULL THEN '' ELSE ',' + MAX([C49]) END	+ CASE WHEN MAX([C50]) IS NULL THEN '' ELSE ',' + MAX([C50]) END 
				+ CASE WHEN MAX([C51]) IS NULL THEN '' ELSE ',' + MAX([C51]) END 	+ CASE WHEN MAX([C52]) IS NULL THEN '' ELSE ',' + MAX([C52]) END
				+ CASE WHEN MAX([C53]) IS NULL THEN '' ELSE ',' + MAX([C53]) END	+ CASE WHEN MAX([C54]) IS NULL THEN '' ELSE ',' + MAX([C54]) END
				+ CASE WHEN MAX([C55]) IS NULL THEN '' ELSE ',' + MAX([C55]) END	+ CASE WHEN MAX([C56]) IS NULL THEN '' ELSE ',' + MAX([C56]) END
				+ CASE WHEN MAX([C57]) IS NULL THEN '' ELSE ',' + MAX([C57]) END	+ CASE WHEN MAX([C58]) IS NULL THEN '' ELSE ',' + MAX([C58]) END
				+ CASE WHEN MAX([C59]) IS NULL THEN '' ELSE ',' + MAX([C59]) END	+ CASE WHEN MAX([C60]) IS NULL THEN '' ELSE ',' + MAX([C60]) END 
				+ CASE WHEN MAX([C61]) IS NULL THEN '' ELSE ',' + MAX([C61]) END 	+ CASE WHEN MAX([C62]) IS NULL THEN '' ELSE ',' + MAX([C62]) END
				+ CASE WHEN MAX([C63]) IS NULL THEN '' ELSE ',' + MAX([C63]) END	+ CASE WHEN MAX([C64]) IS NULL THEN '' ELSE ',' + MAX([C64]) END
				+ CASE WHEN MAX([C65]) IS NULL THEN '' ELSE ',' + MAX([C65]) END	+ CASE WHEN MAX([C66]) IS NULL THEN '' ELSE ',' + MAX([C66]) END
				+ CASE WHEN MAX([C67]) IS NULL THEN '' ELSE ',' + MAX([C67]) END	+ CASE WHEN MAX([C68]) IS NULL THEN '' ELSE ',' + MAX([C68]) END
				+ CASE WHEN MAX([C69]) IS NULL THEN '' ELSE ',' + MAX([C69]) END	+ CASE WHEN MAX([C70]) IS NULL THEN '' ELSE ',' + MAX([C70]) END 
				+ CASE WHEN MAX([C71]) IS NULL THEN '' ELSE ',' + MAX([C71]) END 	+ CASE WHEN MAX([C72]) IS NULL THEN '' ELSE ',' + MAX([C72]) END
				+ CASE WHEN MAX([C73]) IS NULL THEN '' ELSE ',' + MAX([C73]) END	+ CASE WHEN MAX([C74]) IS NULL THEN '' ELSE ',' + MAX([C74]) END
				+ CASE WHEN MAX([C75]) IS NULL THEN '' ELSE ',' + MAX([C75]) END	+ CASE WHEN MAX([C76]) IS NULL THEN '' ELSE ',' + MAX([C76]) END
				+ CASE WHEN MAX([C77]) IS NULL THEN '' ELSE ',' + MAX([C77]) END	+ CASE WHEN MAX([C78]) IS NULL THEN '' ELSE ',' + MAX([C78]) END
				+ CASE WHEN MAX([C79]) IS NULL THEN '' ELSE ',' + MAX([C79]) END	+ CASE WHEN MAX([C80]) IS NULL THEN '' ELSE ',' + MAX([C80]) END 
				+ CASE WHEN MAX([C81]) IS NULL THEN '' ELSE ',' + MAX([C81]) END 	+ CASE WHEN MAX([C82]) IS NULL THEN '' ELSE ',' + MAX([C82]) END
				+ CASE WHEN MAX([C83]) IS NULL THEN '' ELSE ',' + MAX([C83]) END	+ CASE WHEN MAX([C84]) IS NULL THEN '' ELSE ',' + MAX([C84]) END
				+ CASE WHEN MAX([C85]) IS NULL THEN '' ELSE ',' + MAX([C85]) END	+ CASE WHEN MAX([C86]) IS NULL THEN '' ELSE ',' + MAX([C86]) END
				+ CASE WHEN MAX([C87]) IS NULL THEN '' ELSE ',' + MAX([C87]) END	+ CASE WHEN MAX([C88]) IS NULL THEN '' ELSE ',' + MAX([C88]) END
				+ CASE WHEN MAX([C89]) IS NULL THEN '' ELSE ',' + MAX([C89]) END	+ CASE WHEN MAX([C90]) IS NULL THEN '' ELSE ',' + MAX([C90]) END
				+ CASE WHEN MAX([C91]) IS NULL THEN '' ELSE ',' + MAX([C91]) END 	+ CASE WHEN MAX([C92]) IS NULL THEN '' ELSE ',' + MAX([C92]) END
				+ CASE WHEN MAX([C93]) IS NULL THEN '' ELSE ',' + MAX([C93]) END	+ CASE WHEN MAX([C94]) IS NULL THEN '' ELSE ',' + MAX([C94]) END
				+ CASE WHEN MAX([C95]) IS NULL THEN '' ELSE ',' + MAX([C95]) END	+ CASE WHEN MAX([C96]) IS NULL THEN '' ELSE ',' + MAX([C96]) END
				+ CASE WHEN MAX([C97]) IS NULL THEN '' ELSE ',' + MAX([C97]) END	+ CASE WHEN MAX([C98]) IS NULL THEN '' ELSE ',' + MAX([C98]) END
				+ CASE WHEN MAX([C99]) IS NULL THEN '' ELSE ',' + MAX([C99]) END	+ CASE WHEN MAX([C100]) IS NULL THEN '' ELSE ',' + MAX([C100]) END AS CONFIRM_ID --[C20210225-000385] CONFIRM_ID 추가

		from   (
			select *
					, 'C' + CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, FCST_TYPE, INCOTERMS, DOM_EXP
										ORDER BY CONFIRM_ID ) AS NVARCHAR(10)) CONFIRM_ID_ROW
					, 'Q' + CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, FCST_TYPE, INCOTERMS, DOM_EXP
										ORDER BY CONFIRM_ID ) AS NVARCHAR(10)) QTY_NUM
			from   #T_MKT_RESULT WITH(NOLOCK)
			--WHERE  QTY > 0 
			) A
		PIVOT (				
			MAX(CONFIRM_ID) FOR CONFIRM_ID_ROW IN ( [C1], [C2], [C3], [C4], [C5], [C6], [C7], [C8], [C9], [C10] ,[C11], [C12], [C13], [C14], [C15], [C16], [C17], [C18], [C19], [C20]
										,[C21], [C22], [C23], [C24], [C25], [C26], [C27], [C28], [C29], [C30],[C31], [C32], [C33], [C34], [C35], [C36], [C37], [C38], [C39], [C40]
										,[C41], [C42], [C43], [C44], [C45], [C46], [C47], [C48], [C49], [C50],[C51], [C52], [C53], [C54], [C55], [C56], [C57], [C58], [C59], [C60]
										,[C61], [C62], [C63], [C64], [C65], [C66], [C67], [C68], [C69], [C70],[C71], [C72], [C73], [C74], [C75], [C76], [C77], [C78], [C79], [C80]
										,[C81], [C82], [C83], [C84], [C85], [C86], [C87], [C88], [C89], [C90],[C91], [C92], [C93], [C94], [C95], [C96], [C97], [C98], [C99], [C100]  )
			) AS PVT1 --[C20210225-000385] Key 값 기준으로 최대 100개 SO_NO를 갖을 수 있음
		PIVOT (
			SUM(QTY) FOR QTY_NUM IN ( [Q1], [Q2], [Q3], [Q4], [Q5], [Q6], [Q7], [Q8], [Q9], [Q10] ,[Q11], [Q12], [Q13], [Q14], [Q15], [Q16], [Q17], [Q18], [Q19], [Q20]
										,[Q21], [Q22], [Q23], [Q24], [Q25], [Q26], [Q27], [Q28], [Q29], [Q30],[Q31], [Q32], [Q33], [Q34], [Q35], [Q36], [Q37], [Q38], [Q39], [Q40]
										,[Q41], [Q42], [Q43], [Q44], [Q45], [Q46], [Q47], [Q48], [Q49], [Q50],[Q51], [Q52], [Q53], [Q54], [Q55], [Q56], [Q57], [Q58], [Q59], [Q60]
										,[Q61], [Q62], [Q63], [Q64], [Q65], [Q66], [Q67], [Q68], [Q69], [Q70],[Q71], [Q72], [Q73], [Q74], [Q75], [Q76], [Q77], [Q78], [Q79], [Q80]
										,[Q81], [Q82], [Q83], [Q84], [Q85], [Q86], [Q87], [Q88], [Q89], [Q90],[Q91], [Q92], [Q93], [Q94], [Q95], [Q96], [Q97], [Q98], [Q99], [Q100]  )
			) AS PVT2 --[C20210225-000385] Key 값 기준으로 최대 100개 SO_NO를 갖을 수 있음

		group by DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
				
		-- QTY 의 부호에 따라 순번을 세팅
		-- 실적이 덜 들어온 경우에 오늘 날짜에 캐리오버		
		UPDATE A
		SET SEQ = B.SEQ
		FROM #T_MKT_RESULT_SUM A
		JOIN ( SELECT ROW_NUM, ROW_NUMBER() OVER ( ORDER BY QTY ) AS SEQ
				FROM #T_MKT_RESULT_SUM
				WHERE QTY > 0
				) B ON A.ROW_NUM = B.ROW_NUM
				
		-- 실적이 더 들어온 경우에 미래 계획구간 네팅
		UPDATE A
		SET SEQ = B.SEQ
		FROM #T_MKT_RESULT_SUM A
		JOIN ( SELECT ROW_NUM, ROW_NUMBER() OVER ( ORDER BY QTY ) AS SEQ
				FROM #T_MKT_RESULT_SUM
				WHERE QTY < 0
				) B ON A.ROW_NUM = B.ROW_NUM
		

		--[C20210225-000385] Carray Over 데이터 삭제
		UPDATE A
		SET QTY = CASE	WHEN ISNUMERIC(A.ATTRIBUTE2) > 0 AND CAST(A.ATTRIBUTE2 AS NUMERIC(30,10)) > 0
							THEN A.QTY - CAST(A.ATTRIBUTE2 AS NUMERIC(30,10))
						ELSE A.QTY
						END
			, ATTRIBUTE2 = ''
			, ATTRIBUTE5 = ''
			, LAST_UPDATED_BY = 'SSP_SYNC_DEL'
			, LAST_UPDATE_DATE = GETDATE() 
		FROM DM_PLN_MKT_FCST A
		WHERE A.DIVISION_ID = @P_DIVISION_ID
			AND A.YYYYMMDD = CONVERT(CHAR(8), DATEADD(DAY, 1, @V_NET_END_YYYYMMDD), 112)	-- 오늘 ( 첫번째 계획구간 일자)
			AND A.MEASURE = 'MKT_FCST'
			AND ISNUMERIC(A.ATTRIBUTE2) > 0


		-- 실적이 계획보다 적게 들어온 경우를 먼저 일괄 업데이트 한다.
		UPDATE A
		SET QTY = CASE	WHEN ISNUMERIC(A.ATTRIBUTE2) > 0 AND CAST(A.ATTRIBUTE2 AS NUMERIC(30,10)) > 0
							THEN A.QTY
						ELSE A.QTY + B.QTY
						END
			-- ATTR1 은 있든없든 그대로 유지
			-- ATTR2 는 있으면 그대로 유지. 없으면 생성
			, ATTRIBUTE2 = CASE WHEN ISNUMERIC(A.ATTRIBUTE2) > 0 AND CAST(A.ATTRIBUTE2 AS NUMERIC(30,10)) > 0
										THEN A.ATTRIBUTE2
								ELSE B.QTY
								END
			-- [C20210225-000385] ATTRIBUTE5 는 CARRY OVER CONFIRM ID
			, ATTRIBUTE5 = B.CONFIRM_ID
			, LAST_UPDATED_BY = 'SSP_CARRY_OVER'
			, LAST_UPDATE_DATE = GETDATE()
		FROM DM_PLN_MKT_FCST A
		JOIN #T_MKT_RESULT_SUM B ON A.DIVISION_ID		 = B.DIVISION_ID --[C20210225-000385]
		AND A.PROJECT_CODE	 = B.PROJECT_CODE	
		AND A.SCM_SITE_ID	 = B.SCM_SITE_ID	
		AND A.ITEM_ID		 = B.ITEM_ID
		AND A.DOM_EXP		 = B.DOM_EXP		
		AND A.FCST_TYPE		 = B.FCST_TYPE		
		AND A.INCOTERMS		 = B.INCOTERMS
		AND B.QTY > 0	
		WHERE A.DIVISION_ID = @P_DIVISION_ID
			AND A.YYYYMMDD = CONVERT(CHAR(8), DATEADD(DAY, 1, @V_NET_END_YYYYMMDD), 112)	-- 오늘 ( 첫번째 계획구간 일자)
			AND A.MEASURE = 'MKT_FCST'

		INSERT INTO DM_PLN_MKT_FCST
			 ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
			 , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
			 , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
			 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			  )
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
			 , A.FCST_TYPE, A.INCOTERMS, 'MKT_FCST' AS MEASURE, '' AS PLANT_SITE_ID
			 , CONVERT(CHAR(8), DATEADD(DAY, 1, @V_NET_END_YYYYMMDD), 112) AS YYYYMMDD
			 , A.QTY, 'SSP_SYNC' AS CREATED_BY, GETDATE() AS CREATION_DATE, 'SSP_CARRY_OVER' AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
			 , 0 AS ATTRIBUTE1, A.QTY AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4, A.CONFIRM_ID AS ATTRIBUTE5 -- [C20210225-000385] ATTRIBUTE5 는 CARRY OVER CONFIRM ID
			 , '' AS ATTRIBUTE6, '' AS ATTRIBUTE7, '' AS ATTRIBUTE8, '' AS ATTRIBUTE9, '' AS ATTRIBUTE10
		FROM   #T_MKT_RESULT_SUM A WITH(NOLOCK) --[C20210225-000385]
		LEFT OUTER JOIN DM_PLN_MKT_FCST B ON A.DIVISION_ID		 = B.DIVISION_ID
		AND A.PROJECT_CODE	 = B.PROJECT_CODE	
		AND A.SCM_SITE_ID	 = B.SCM_SITE_ID	
		AND A.ITEM_ID		 = B.ITEM_ID
		AND A.DOM_EXP		 = B.DOM_EXP		
		AND A.FCST_TYPE		 = B.FCST_TYPE		
		AND A.INCOTERMS		 = B.INCOTERMS
		AND B.YYYYMMDD		= CONVERT(CHAR(8), DATEADD(DAY, 1, @V_NET_END_YYYYMMDD), 112)	-- 오늘 ( 첫번째 계획구간 일자)
		AND B.MEASURE		= 'MKT_FCST'
		AND B.DIVISION_ID	= @P_DIVISION_ID
		WHERE A.QTY > 0
		AND B.DIVISION_ID IS NULL
		

		COMMIT TRAN SALES_SITE_MODEL_PRODUCTION ;	

	END TRY
	BEGIN CATCH
	    		
		ROLLBACK TRAN SALES_SITE_MODEL_PRODUCTION ;	
				
		-- ERROR LOG
		SET @V_LOG_TYPE = 'ERROR';
		SET @V_LOG_MESSAGE = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @V_DESCRIPTION = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @D_EVENT_DATE = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE;
		SELECT '[' + CONVERT(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		
    END CATCH;

	IF  @V_LOG_TYPE NOT IN ('INVALID','ERROR')
		BEGIN
			-- 종료 LOG
			SET @V_LOG_TYPE = 'END';
			SET @V_LOG_MESSAGE = '########## END OF PROCEDURE ##########';
			SET @D_EVENT_DATE = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE;
		END

	-- INVALID 인경우 ROLLBACK 처리
	ERR_RTN:
		IF  @V_LOG_TYPE ='INVALID'
			BEGIN
				SELECT @V_LOG_TYPE
				ROLLBACK TRAN SALES_SITE_MODEL_PRODUCTION;	
				-- 종료 LOG
				SET @V_LOG_TYPE = 'END';
				SET @V_LOG_MESSAGE = '########## END OF PROCEDURE ##########';
				SET @D_EVENT_DATE = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE;
			END;

  END;
