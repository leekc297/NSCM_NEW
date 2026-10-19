-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--	PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING '40'
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*=====================================================================================================================================================================
 * Program ID   : PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING
 * Description  : PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING
 * Program History
 *=====================================================================================================================================================================
 *   Date       In Charge   Description
 *=====================================================================================================================================================================
 * 2018.01.     DWOK		Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *							PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING	''
 * 2018.03.13	JHBAEK		1. DM_PLN_SALES_PLAN_RESULT 테이블 CURREYCY COLUMN KEY 추가
 *							2. 프로시져 CUSTOMIZING
 *							기존 : DIVIDSION_ID 를 CURSOR 사용
 *							변경 : CURSOR를 없애고 MASTER TABLE(SCM_MST_DIVISION) IN 조건으로 수정
 * 2018.04.27	ADD			EXEC PR_DM_ERP_MATERIAL_TO_DM_RESULT ->  20180706 KHSONG 오류발생으로 일단 주석처리함
 * 2018.07.27	KHSONG		소형 vmi 재고 및 입고 실적 정보 생성
 * 2018.08.01	KHSONG		Null Warning 발생으로 MAX(ATTRIBUTE2)~MAX(ATTRIBUTE10) 부분 주석처리함 / 1달전 1일부터의 조회조건 보완
 * 2018.08.16	KHSONG		DIVISION 입력로직 변경
 * 2018.08.20	ytchoi		indicator added
 * 2018.09.10	KHSONG		distinct -> top 1 으로 수정
 * 2018.09.11	KHSONG		대상테이블 변경 DM_DNM_SALES_RESULT -> DM_DNM_SALES_RESULT_IF
 * 2018.09.12	KHSONG		날짜조건 변수로 설정
 * 2018.10.15	KHSONG		자동차 dm_pln_mkt_fcst_result 에 VMI_In_Plan, VMI_In_Req 생성
 * 2018.10.19	KHSONG		프로시져 호출 (KPI관련)
 * 2018.11.07   ytchoi		ETC에 대해서는 project code를 통일
 * 2018.11.28	KHSONG		PR_DM_ANL_KPI_SUMMARY 프로시져 호출추가
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.07.25				CSR ID:4048421 KHSONG 실적생성시 RTF_SystemR+P MEASURE를 추가생성함
 * 2019.08.09	KHSONG		CSR ID:4059971 VMI-In Request 로직 변경 (ESS사업부 추가 / storage_id 1BYTE가 알파벳은 대기창고로 실적에서 제외, 숫자인경우만 집계에 합산)
 * 2019.10.01	KHSONG		매월 1일인경우 전전월의 데이터부터 대상으로 해야하므로 날짜산출 로직수정
 * 2019.11.07	KYH			Company_id 추가
 * 2019.11.11	KHSONG		CSR ID:4103469 GSCM Sales Plan, Waterfall ETC 매출 설정 로직 추가의 건
 * 2019.11.14	KYH			Company_id 원복
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2020.01.16	hwi1993		Company_id 추가
 * 2020.04.06	KHSONG		C20200324-000209 VMI in Request 실적값 오류보정
 * 2020.04.16	KHSONG		C20200413-000593 ESS사업부 RTF Measure 추가
 * 2020.07.29	hwi1993		과제 - ESS 실적매핑 내부거래 예외 처리
 * 2020.08.06	hwi1993		[C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건
 * 2020.09.09   P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2020.11.13	hwi1993		[C20201103-000114] [SCM PI팀] ESS 사업부 판매 법인 VMI biz의 MKT FCST 입력 시 VMI in req 자동산출 로직 적용의 건 
 * 2020.12.01	HWI1993		개발에서는 KPI 실행하지 않도록 처리
 * 2020.12.09	hwi1993		customer code 의 길이가 4인 경우 예외처리에 B100 처리
 * 2020.12.17	hwi1993		[C20201217-000126] ESS 판매법인 VMI inventory 수신 프로세스 수정. 재고 받는 부분에 82만 plant id 추가
 * 2020.12.22	hwi1993		[C20201222-000376] VMI Inv 메저 수량 표시
 * 2020.12.23	kuni		I/F 에 SSP NO 추가
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2021.01.20	P.C.I		[C20210120-000090] VMI_Inv 의 Incoterms 는 MKT_FCST에 마지막으로 등록된 순으로 적용
 * 2021.01.28	kuni		[C20210127-000390] ESS사업부 실적 반영 주기 변경의 건
 * 2021.02.09	P.C.I 		[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)
 * 2021.07.02	HWI1993		[C20210629-000239] [SCM PI팀] MKT FCST Amt. 추가의 건
 * 2021.07.07	hwi1993		[C20210618-000288] VMI in Req가 없는 VMI in plan 실적값 불러오기 로직 설정 요청의 건
 * 2021.07.13	HWI1993		[C20210713-000038] VMI in Plan 실적 로직 정비 요청의 건
 * 2021.09.06	SJHAN		[C20210831-000303] GSCM VMI in 수요 없는 실적 발생시 Sales Site Project Model 참조 로직 수정 요청
 * 2021.09.08	SJHAN		[C20210908-000163] Vmi in Req 실적 구간 로직 수정 
 * 2021.10.01	hwi1993		[과제] as plant 처리 추가
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2022.04.14   HWI1993     GM JV
 * 2022.10.17	HWI1993		[C20221004-000309] ERP 피킹실적 VMI In plan(R+P) 실적 반영 요청 건
 * 2022.11.22	KDW2819		[C20221118-000024][SCM PI] GSCM 시스템의 AS 입고 실적 집계를 위한 기능 변경 건
 * 2022.11.28	hwi1993		[C20221118-000024] 오류 수정 ( AS IN PLAN 실적 처리시 Division 조건 추가 )
 * 2022.12.07	hwi1993		[C20221207-000280] 원복 [C20221004-000309]
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2024.04.25   HMIN 		[E20240415-000036]_SCM시스템의 사내간 거래 매출 실적 인식을 위한 신규개발/기능변경
							- 예외캐이스 처리 룩업(DM_EXCEPT_SALES_SITE_MAPPING)추가 , 실적집계프로그램 상 예외처리 프로세스 반영
							- 적용시점기준 : 82번 사업부 LGESVT_US_BOS 의 G810 매출에 한함.
 * 2024.05.29	P.C.I		[PJ20228272] NERP 하드코딩 대응 및 개선
 * 2024.08.20	JSSBAE		[E20240806-000678]_소형사업부 매출실적 스케줄 - 월요일 13시
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2025.02.13	JSSBAE		[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치
 * 2025.04.08	JSSBAE		[E20250404-001534]_[공급생산 SCM PI팀] 지연 빌링 발생 시 수요계획 보정 기능 개발 요청
 * 2025.05.13	KANG.H.J	[PJ2025-50188] 환율반영한 SALES_AMT_KRW / MKT_AMT_KRW 생성
 * 2025.05.26	KANG.H.J	[PJ2025-50188] 환율 반영한 AMT 업데이트 기준일 정의하여 적용 - 기준일 : 당월 1일로 정의함. (@v_start_yyyymmdd_exchange)
 * 2025.06.23   KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.07.09   KANG.H.J	[PJ2025-50188] 환율반영한 SALES_AMT_KRW / MKT_AMT_KRW 생성 보완 - 40사업부가 포함되지 않는 처리시 DUP ERROR 보완 (조건절 해당 코드 반영 : DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division))  
 * 2025.10.30   JSSBAE		[E20251029-000956]_실적 데이터 Project Code 값 Mapping 로직 보완
 * 2025.10.30   JSSBAE		[E20251029-000963]_매출실적 데이터 IF 로직 보완
 * 2026.08.20   JSSBAE		[E20260821-001396]_ERP 매출실적 데이터 적재 로직 수정
 *====================================================================================================================================================================*/

CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING] 
	@p_division_id			NVARCHAR(30)  -- 사용하지 않는 파라메터
AS

BEGIN	
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @recv_active_flag		NVARCHAR(10);
	DECLARE @v_division_id			NVARCHAR(30);
	DECLARE @v_ver_description		NVARCHAR(10);
	DECLARE @v_ver_type				NVARCHAR(10);
	DECLARE @v_created_by			NVARCHAR(10);

	DECLARE	@v_ver_return_no		NVARCHAR(100);	-- cut off Generated Number	
	SET @v_division_id		 = NULL;	
	SET @v_ver_description	 = NULL;	
	SET @v_ver_type			 = NULL;	
	SET @v_created_by		 = NULL;	

	DECLARE @v2_DIVISION_ID               nvarchar(30);
	SET @v2_DIVISION_ID		 = NULL;	

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	

	---- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 날짜변수설정 20180912 KHSONG 날짜조건 변수로 설정(start)
	DECLARE @v_start_yyyymm               nvarchar(06);
	DECLARE @v_end_yyyymm                 nvarchar(06);
	DECLARE @v_start_yyyymmdd             nvarchar(08);
	DECLARE @v_start_yyyymmdd_exchange    nvarchar(08);			-- [PJ2025-50188] 환율반영한 SALES_AMT_KRW / MKT_AMT_KRW 생성. AMT 업데이트 기준일 정의하여 적용 - 기준일 : 당월 1일로 정의함.
	DECLARE @v_end_yyyymmdd               nvarchar(08);

	-- 20191001 KHSONG 주석처리(BEGIN)
	--SET @v_start_yyyymm		= CONVERT(CHAR(6), dateadd(month,-1,getdate()), 112)						-- 전월 (yyyymm)
	--SET @v_start_yyyymmdd		= substring(CONVERT(CHAR(8), dateadd(month,-1,getdate()), 112),1,6) + '01'  -- 1달전 1일 (yyyymmdd)
	-- 20191001 KHSONG 주석처리(END)

	-- 20191001 KHSONG 매월 1일인경우 전전월의 데이터부터 대상으로 해야하므로 날짜산출 로직수정(BEGIN)
	SET @v_start_yyyymm			= CONVERT(CHAR(6), dateadd(month,	CASE WHEN (SELECT SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, GETDATE()), 112),7,2)) = '01' THEN -2 ELSE -1 END	,getdate()), 112)						-- 전월/1일은 전전월 (yyyymm)
	SET @v_start_yyyymmdd		= substring(CONVERT(CHAR(8), dateadd(month,	CASE WHEN (SELECT SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, GETDATE()), 112),7,2)) = '01' THEN -2 ELSE -1 END	,getdate()), 112),1,6) + '01'	-- 전월1일/1일은 전전월1일 (yyyymmdd)
	-- 20191001 KHSONG 매월 1일인경우 전전월의 데이터부터 대상으로 해야하므로 날짜산출 로직수정(END)

	SET @v_start_yyyymmdd_exchange	= substring(CONVERT(CHAR(8), dateadd(month, 0, getdate()), 112),1,6) + '01'		-- [PJ2025-50188] 환율반영한 SALES_AMT_KRW / MKT_AMT_KRW 생성. AMT 업데이트 기준일 정의하여 적용 - 기준일 : 당월 1일로 정의함.

	SET @v_end_yyyymm		 = CONVERT(CHAR(6), getdate(), 112)                                          -- 당월 (yyyymm)
	SET @v_end_yyyymmdd		 = CONVERT(CHAR(8), getdate(), 112)                                          -- 당일 (yyyymmdd)
	-- 날짜변수설정 20180912 KHSONG 날짜조건 변수로 설정(end)
	
	-- 시작 LOG START
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG END

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                                   20180816 DIVISION 입력조건 변경 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	/*
	----------
	구분
	----------
	일요일 = 1
	월요일 = 2
	화요일 = 3
	수요일 = 4
	목요일 = 5
	금요일 = 6
	토요일 = 7
	----------
	*/
	
	IF OBJECT_ID (N'tempdb..#i_division', N'U') IS NOT NULL 
		DROP TABLE #i_division
	IF OBJECT_ID (N'tempdb..#DM_DNM_SALES_RESULT', N'U') IS NOT NULL 
		DROP TABLE #DM_DNM_SALES_RESULT
	IF OBJECT_ID (N'tempdb..#T_MF', N'U') IS NOT NULL 
		DROP TABLE #T_MF
	IF OBJECT_ID (N'tempdb..#VMI_RESULT', N'U') IS NOT NULL 
		DROP TABLE #VMI_RESULT
		
	CREATE TABLE  #i_division (division_id	NVARCHAR(30)) 
	
	--[E20240806-000678]_소형사업부 매출실적 스케줄 - 월요일 13시 기존 정보 주석처리
	-- 요일에 따른 판단
	/*
	IF (SELECT  DATEPART(WEEKDAY,GETDATE())) = 2  

		-------------------------------------------------------------------- 월요일인경우 (BEGIN)
		BEGIN
				-- 자동차, ESS 작업
				INSERT INTO #i_division (division_id) 
					SELECT DIVISION_ID
                    FROM SCM_MST_DIVISION WITH(NOLOCK)
                    WHERE ATTRIBUTE3 = '81'
					/*   -- [C20210127-000390]
					union
					select '82'
					*/

				-- 소형은 현재시간이 00시~10시 구간에만 작업함
				IF   SUBSTRING(CONVERT(NVARCHAR, GETDATE(), 121), 12, 2) BETWEEN '00' AND '10'  
					BEGIN
						INSERT INTO #i_division (division_id) 
							select '40'
					END

				-- '82' 현재시간이 00시~14시 구간에만 작업함  -- [C20210127-000390]
				IF   SUBSTRING(CONVERT(NVARCHAR, GETDATE(), 121), 12, 2) BETWEEN '00' AND '14'  
				--IF   SUBSTRING(CONVERT(NVARCHAR, GETDATE(), 121), 12, 2) BETWEEN '18' AND '19'  
					BEGIN
						INSERT INTO #i_division (division_id) 
							select '82'
					END 
		END
		-------------------------------------------------------------------- 월요일인경우 (END)

		ELSE

		-------------------------------------------------------------------- 월요일이외인 경우 (BEGIN)
		BEGIN
				-- 자동차, ESS, 소형 작업
				INSERT INTO #i_division (division_id) 
                SELECT DIVISION_ID
                FROM SCM_MST_DIVISION WITH(NOLOCK)
                WHERE ATTRIBUTE3 IN ('40','81','82')

		END
		-------------------------------------------------------------------- 월요일이외인 경우 (END)
	*/
		------------------------------------------------------------------------------------------------------- 
		--[E20240806-000678]_소형사업부 매출실적 스케줄 - 월요일 13시 START
		--위의 하드코딩으로 시간 조절하는 부분이 아니라, 시간 변경이 일어나는 경우 룩업에서 셋팅 가능하도록 수정 
		------------------------------------------------------------------------------------------------------- 
		--당일 날짜가 어떤날짜인지 데이터 추출
		------------------------------------------------------------------------------------------------------- 
		SELECT DAYOFWEEK AS DAYOFWEEKS
		INTO #TEMP_DAYINFO
		FROM [dbo].[SCM_SYS_CALENDAR_M] WITH (NOLOCK)
		WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8), GETDATE(), 112)

		------------------------------------------------------------------------------------------------------- 
		--현재시점 작동해야되는 DIVISION 추출
		------------------------------------------------------------------------------------------------------- 
		
		/*
		INSERT INTO #i_division (division_id) 
        SELECT DIVISION_ID
        FROM SCM_MST_DIVISION WITH(NOLOCK)
        WHERE ATTRIBUTE3 IN ('40','81','82')
		
		INSERT INTO #i_division (division_id) 
		SELECT DIVISION_ID
		FROM SCM_MST_DIVISION WITH(NOLOCK)
		WHERE ATTRIBUTE3 IN ('40','81','82')
		AND DIVISION_ID NOT IN ('81_UC')
		INSERT INTO #i_division (division_id) 
        SELECT DIVISION_ID
        FROM SCM_MST_DIVISION WITH(NOLOCK)
        WHERE ATTRIBUTE3 = '40'
		*/

		--[E20250404-001534]_[공급생산 SCM PI팀] 지연 빌링 발생 시 수요계획 보정 기능 개발 요청
		--해당 룩업을 사용하기 위하여, segment4로 구분하려고함. 조회조건 추가 
		INSERT INTO #i_division (division_id) 
		SELECT SEGMENT1 AS DIVISION_ID
		FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK)
		WHERE LOOKUP_TYPE = N'RESULT_MAPPING_SCHEDULE'
		AND (SEGMENT2 = 'ALL' OR SEGMENT2 IN (SELECT DAYOFWEEKS FROM #TEMP_DAYINFO))
		AND (CASE WHEN ISNULL(ATTRIBUTE1,'') <> '' AND ATTRIBUTE1 IN (SELECT DAYOFWEEKS FROM #TEMP_DAYINFO) THEN SEGMENT1 ELSE 1 END) = 1
		AND LEFT(SEGMENT3,2) BETWEEN SUBSTRING(CONVERT(NVARCHAR, DATEADD(HOUR, -1, GETDATE()), 121), 12, 2) AND SUBSTRING(CONVERT(NVARCHAR, GETDATE(), 121), 12, 2)
		AND VALID_YN = 'Y'
		AND SEGMENT4 = 'RESULT'  --[E20250404-001534]_RESULT MODE 추가
		GROUP BY SEGMENT1

		SELECT * FROM #i_division

		DECLARE @n_update_cnt   INT = 0;
		SET @n_update_cnt = @@ROWCOUNT; 		
		------------------------------------------------------------------------------------------------------- 
		--[E20240806-000678]_소형사업부 매출실적 스케줄 - 월요일 13시 END
		------------------------------------------------------------------------------------------------------- 

		-------------------------------------------------------------------- Log에 작업하는 Division_id 를 표기 (begin)

        DECLARE @T TAB_PIVOT_STRING
        
        INSERT INTO @T ( KEY_VAL )
        SELECT DIVISION_ID
        FROM #I_DIVISION

        SELECT @v_description = DBO.FN_GET_PIVOT_STRING( @T, ',' )

		-------------------------------------------------------------------- Log에 작업하는 Division_id 를 표기 (end)
		
	------------------------------------------------------------------------------------------------------- 
	--[E20240806-000678]_소형사업부 매출실적 스케줄 - 월요일 13시 START INSERT LOG  
	------------------------------------------------------------------------------------------------------- 
	SET @v_log_type    = 'APPEND';  
	SET @v_log_message = 'TARGET DIVISION';  
	SET @v_description = @v_description;
	SET @d_event_date  = SYSDATETIME();
	SET @n_log_count   = @n_update_cnt;
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
	------------------------------------------------------------------------------------------------------- 
	--[E20240806-000678]_소형사업부 매출실적 스케줄 - 월요일 13시 END INSERT LOG  
	------------------------------------------------------------------------------------------------------- 
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                    20180816 DIVISION 입력조건 변경 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	print 'step-1'

	BEGIN TRANSACTION SALES_RESULT_MAPPING;
		BEGIN TRY

			---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
			--                                                                                     20180911 KHSONG 대상테이블 변경 DM_DNM_SALES_RESULT -> DM_DNM_SALES_RESULT_IF (START)
			---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
			BEGIN
			
	print 'step-2'

				-- 대상 생성 쿼리
				
				-- 임시테이블 삭제할경우
				-- DROP TABLE #DM_DNM_SALES_RESULT

				SELECT
					DIVISION_ID
				   ,COMPANY_ID
				   ,PROJECT_CODE
				   ,SALES_SITE_ID
				   ,PLANT_SITE_ID
				   ,ITEM_ID
				   ,ORIGIN_ITEM_ID
				   ,DOM_EXP
				   ,INCOTERMS
				   ,B.MEASURE
				   ,CURRENCY
				   ,YYYYMMDD
				   ,FCST_TYPE
				   ,CASE 
						WHEN B.MEASURE = 'SALES_RESULT_AMOUNT'		THEN  SUM(SALES_AMOUNT_FOR)
						WHEN B.MEASURE = 'SALES_RESULT_AMOUNT_KRW'  THEN  SUM(SALES_AMOUNT_SUM)
						WHEN B.MEASURE = 'SALES_RESULT'				THEN  SUM(SALES_QTY)
					END  AS QTY
				   ,SOLDTO_CODE
				   ,SHIPTO_CODE
				   ,VALID_YN
				   ,MAX(CREATED_BY)		CREATED_BY
				   ,MAX(CREATION_DATE)	CREATION_DATE
				   ,MAX(LAST_UPDATED_BY)	LAST_UPDATED_BY
				   ,MAX(LAST_UPDATE_DATE) LAST_UPDATE_DATE
				   ,MAX(ATTRIBUTE1)		ATTRIBUTE1
				   ,INTERNAL_TYPE
				   , SUM(CASE WHEN ISNUMERIC(ATTRIBUTE3) > 0 THEN CAST(ATTRIBUTE3 AS NUMERIC(30,10))
								ELSE 0 END)  AS ATTRIBUTE3
					, MAX(ATTRIBUTE4) AS ATTRIBUTE4 --2020.12.01 
					--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 START
					, SO_NO, SO_QTY
					/*
					, ISNULL(MAX([SN1]),'') + CASE WHEN MAX([SN2]) IS NULL THEN '' ELSE ',' + MAX([SN2]) END
					+ CASE WHEN MAX([SN3]) IS NULL THEN '' ELSE ',' + MAX([SN3]) END	+ CASE WHEN MAX([SN4]) IS NULL THEN '' ELSE ',' + MAX([SN4]) END
					+ CASE WHEN MAX([SN5]) IS NULL THEN '' ELSE ',' + MAX([SN5]) END	+ CASE WHEN MAX([SN6]) IS NULL THEN '' ELSE ',' + MAX([SN6]) END
					+ CASE WHEN MAX([SN7]) IS NULL THEN '' ELSE ',' + MAX([SN7]) END	+ CASE WHEN MAX([SN8]) IS NULL THEN '' ELSE ',' + MAX([SN8]) END
					+ CASE WHEN MAX([SN9]) IS NULL THEN '' ELSE ',' + MAX([SN9]) END	+ CASE WHEN MAX([SN10]) IS NULL THEN '' ELSE ',' + MAX([SN10]) END 
					+ CASE WHEN MAX([SN11]) IS NULL THEN '' ELSE ',' + MAX([SN11]) END 	+ CASE WHEN MAX([SN12]) IS NULL THEN '' ELSE ',' + MAX([SN12]) END
					+ CASE WHEN MAX([SN13]) IS NULL THEN '' ELSE ',' + MAX([SN13]) END	+ CASE WHEN MAX([SN14]) IS NULL THEN '' ELSE ',' + MAX([SN14]) END
					+ CASE WHEN MAX([SN15]) IS NULL THEN '' ELSE ',' + MAX([SN15]) END	+ CASE WHEN MAX([SN16]) IS NULL THEN '' ELSE ',' + MAX([SN16]) END
					+ CASE WHEN MAX([SN17]) IS NULL THEN '' ELSE ',' + MAX([SN17]) END	+ CASE WHEN MAX([SN18]) IS NULL THEN '' ELSE ',' + MAX([SN18]) END
					+ CASE WHEN MAX([SN19]) IS NULL THEN '' ELSE ',' + MAX([SN19]) END	+ CASE WHEN MAX([SN20]) IS NULL THEN '' ELSE ',' + MAX([SN20]) END
					+ CASE WHEN MAX([SN21]) IS NULL THEN '' ELSE ',' + MAX([SN21]) END 	+ CASE WHEN MAX([SN22]) IS NULL THEN '' ELSE ',' + MAX([SN22]) END
					+ CASE WHEN MAX([SN23]) IS NULL THEN '' ELSE ',' + MAX([SN23]) END	+ CASE WHEN MAX([SN24]) IS NULL THEN '' ELSE ',' + MAX([SN24]) END
					+ CASE WHEN MAX([SN25]) IS NULL THEN '' ELSE ',' + MAX([SN25]) END	+ CASE WHEN MAX([SN26]) IS NULL THEN '' ELSE ',' + MAX([SN26]) END
					+ CASE WHEN MAX([SN27]) IS NULL THEN '' ELSE ',' + MAX([SN27]) END	+ CASE WHEN MAX([SN28]) IS NULL THEN '' ELSE ',' + MAX([SN28]) END
					+ CASE WHEN MAX([SN29]) IS NULL THEN '' ELSE ',' + MAX([SN29]) END	+ CASE WHEN MAX([SN30]) IS NULL THEN '' ELSE ',' + MAX([SN30]) END 
					+ CASE WHEN MAX([SN31]) IS NULL THEN '' ELSE ',' + MAX([SN31]) END 	+ CASE WHEN MAX([SN32]) IS NULL THEN '' ELSE ',' + MAX([SN32]) END
					+ CASE WHEN MAX([SN33]) IS NULL THEN '' ELSE ',' + MAX([SN33]) END	+ CASE WHEN MAX([SN34]) IS NULL THEN '' ELSE ',' + MAX([SN34]) END
					+ CASE WHEN MAX([SN35]) IS NULL THEN '' ELSE ',' + MAX([SN35]) END	+ CASE WHEN MAX([SN36]) IS NULL THEN '' ELSE ',' + MAX([SN36]) END
					+ CASE WHEN MAX([SN37]) IS NULL THEN '' ELSE ',' + MAX([SN37]) END	+ CASE WHEN MAX([SN38]) IS NULL THEN '' ELSE ',' + MAX([SN38]) END
					+ CASE WHEN MAX([SN39]) IS NULL THEN '' ELSE ',' + MAX([SN39]) END	+ CASE WHEN MAX([SN40]) IS NULL THEN '' ELSE ',' + MAX([SN40]) END 
					+ CASE WHEN MAX([SN41]) IS NULL THEN '' ELSE ',' + MAX([SN41]) END 	+ CASE WHEN MAX([SN42]) IS NULL THEN '' ELSE ',' + MAX([SN42]) END
					+ CASE WHEN MAX([SN43]) IS NULL THEN '' ELSE ',' + MAX([SN43]) END	+ CASE WHEN MAX([SN44]) IS NULL THEN '' ELSE ',' + MAX([SN44]) END
					+ CASE WHEN MAX([SN45]) IS NULL THEN '' ELSE ',' + MAX([SN45]) END	+ CASE WHEN MAX([SN46]) IS NULL THEN '' ELSE ',' + MAX([SN46]) END
					+ CASE WHEN MAX([SN47]) IS NULL THEN '' ELSE ',' + MAX([SN47]) END	+ CASE WHEN MAX([SN48]) IS NULL THEN '' ELSE ',' + MAX([SN48]) END
					+ CASE WHEN MAX([SN49]) IS NULL THEN '' ELSE ',' + MAX([SN49]) END	+ CASE WHEN MAX([SN50]) IS NULL THEN '' ELSE ',' + MAX([SN50]) END 
					+ CASE WHEN MAX([SN51]) IS NULL THEN '' ELSE ',' + MAX([SN51]) END 	+ CASE WHEN MAX([SN52]) IS NULL THEN '' ELSE ',' + MAX([SN52]) END
					+ CASE WHEN MAX([SN53]) IS NULL THEN '' ELSE ',' + MAX([SN53]) END	+ CASE WHEN MAX([SN54]) IS NULL THEN '' ELSE ',' + MAX([SN54]) END
					+ CASE WHEN MAX([SN55]) IS NULL THEN '' ELSE ',' + MAX([SN55]) END	+ CASE WHEN MAX([SN56]) IS NULL THEN '' ELSE ',' + MAX([SN56]) END
					+ CASE WHEN MAX([SN57]) IS NULL THEN '' ELSE ',' + MAX([SN57]) END	+ CASE WHEN MAX([SN58]) IS NULL THEN '' ELSE ',' + MAX([SN58]) END
					+ CASE WHEN MAX([SN59]) IS NULL THEN '' ELSE ',' + MAX([SN59]) END	+ CASE WHEN MAX([SN60]) IS NULL THEN '' ELSE ',' + MAX([SN60]) END 
					+ CASE WHEN MAX([SN61]) IS NULL THEN '' ELSE ',' + MAX([SN61]) END 	+ CASE WHEN MAX([SN62]) IS NULL THEN '' ELSE ',' + MAX([SN62]) END
					+ CASE WHEN MAX([SN63]) IS NULL THEN '' ELSE ',' + MAX([SN63]) END	+ CASE WHEN MAX([SN64]) IS NULL THEN '' ELSE ',' + MAX([SN64]) END
					+ CASE WHEN MAX([SN65]) IS NULL THEN '' ELSE ',' + MAX([SN65]) END	+ CASE WHEN MAX([SN66]) IS NULL THEN '' ELSE ',' + MAX([SN66]) END
					+ CASE WHEN MAX([SN67]) IS NULL THEN '' ELSE ',' + MAX([SN67]) END	+ CASE WHEN MAX([SN68]) IS NULL THEN '' ELSE ',' + MAX([SN68]) END
					+ CASE WHEN MAX([SN69]) IS NULL THEN '' ELSE ',' + MAX([SN69]) END	+ CASE WHEN MAX([SN70]) IS NULL THEN '' ELSE ',' + MAX([SN70]) END 
					+ CASE WHEN MAX([SN71]) IS NULL THEN '' ELSE ',' + MAX([SN71]) END 	+ CASE WHEN MAX([SN72]) IS NULL THEN '' ELSE ',' + MAX([SN72]) END
					+ CASE WHEN MAX([SN73]) IS NULL THEN '' ELSE ',' + MAX([SN73]) END	+ CASE WHEN MAX([SN74]) IS NULL THEN '' ELSE ',' + MAX([SN74]) END
					+ CASE WHEN MAX([SN75]) IS NULL THEN '' ELSE ',' + MAX([SN75]) END	+ CASE WHEN MAX([SN76]) IS NULL THEN '' ELSE ',' + MAX([SN76]) END
					+ CASE WHEN MAX([SN77]) IS NULL THEN '' ELSE ',' + MAX([SN77]) END	+ CASE WHEN MAX([SN78]) IS NULL THEN '' ELSE ',' + MAX([SN78]) END
					+ CASE WHEN MAX([SN79]) IS NULL THEN '' ELSE ',' + MAX([SN79]) END	+ CASE WHEN MAX([SN80]) IS NULL THEN '' ELSE ',' + MAX([SN80]) END 
					+ CASE WHEN MAX([SN81]) IS NULL THEN '' ELSE ',' + MAX([SN81]) END 	+ CASE WHEN MAX([SN82]) IS NULL THEN '' ELSE ',' + MAX([SN82]) END
					+ CASE WHEN MAX([SN83]) IS NULL THEN '' ELSE ',' + MAX([SN83]) END	+ CASE WHEN MAX([SN84]) IS NULL THEN '' ELSE ',' + MAX([SN84]) END
					+ CASE WHEN MAX([SN85]) IS NULL THEN '' ELSE ',' + MAX([SN85]) END	+ CASE WHEN MAX([SN86]) IS NULL THEN '' ELSE ',' + MAX([SN86]) END
					+ CASE WHEN MAX([SN87]) IS NULL THEN '' ELSE ',' + MAX([SN87]) END	+ CASE WHEN MAX([SN88]) IS NULL THEN '' ELSE ',' + MAX([SN88]) END
					+ CASE WHEN MAX([SN89]) IS NULL THEN '' ELSE ',' + MAX([SN89]) END	+ CASE WHEN MAX([SN90]) IS NULL THEN '' ELSE ',' + MAX([SN90]) END
					+ CASE WHEN MAX([SN91]) IS NULL THEN '' ELSE ',' + MAX([SN91]) END 	+ CASE WHEN MAX([SN92]) IS NULL THEN '' ELSE ',' + MAX([SN92]) END
					+ CASE WHEN MAX([SN93]) IS NULL THEN '' ELSE ',' + MAX([SN93]) END	+ CASE WHEN MAX([SN94]) IS NULL THEN '' ELSE ',' + MAX([SN94]) END
					+ CASE WHEN MAX([SN95]) IS NULL THEN '' ELSE ',' + MAX([SN95]) END	+ CASE WHEN MAX([SN96]) IS NULL THEN '' ELSE ',' + MAX([SN96]) END
					+ CASE WHEN MAX([SN97]) IS NULL THEN '' ELSE ',' + MAX([SN97]) END	+ CASE WHEN MAX([SN98]) IS NULL THEN '' ELSE ',' + MAX([SN98]) END
					+ CASE WHEN MAX([SN99]) IS NULL THEN '' ELSE ',' + MAX([SN99]) END	+ CASE WHEN MAX([SN100]) IS NULL THEN '' ELSE ',' + MAX([SN100]) END AS SO_NO --[C20210225-000385] SO_NO 추가(','로 구분)
				, ISNULL(MAX([SQ1]),'') + CASE WHEN MAX([SQ2]) IS NULL THEN '' ELSE ',' + MAX([SQ2]) END
					+ CASE WHEN MAX([SQ3]) IS NULL THEN '' ELSE ',' + MAX([SQ3]) END	+ CASE WHEN MAX([SQ4]) IS NULL THEN '' ELSE ',' + MAX([SQ4]) END
					+ CASE WHEN MAX([SQ5]) IS NULL THEN '' ELSE ',' + MAX([SQ5]) END	+ CASE WHEN MAX([SQ6]) IS NULL THEN '' ELSE ',' + MAX([SQ6]) END
					+ CASE WHEN MAX([SQ7]) IS NULL THEN '' ELSE ',' + MAX([SQ7]) END	+ CASE WHEN MAX([SQ8]) IS NULL THEN '' ELSE ',' + MAX([SQ8]) END
					+ CASE WHEN MAX([SQ9]) IS NULL THEN '' ELSE ',' + MAX([SQ9]) END	+ CASE WHEN MAX([SQ10]) IS NULL THEN '' ELSE ',' + MAX([SQ10]) END 
					+ CASE WHEN MAX([SQ11]) IS NULL THEN '' ELSE ',' + MAX([SQ11]) END 	+ CASE WHEN MAX([SQ12]) IS NULL THEN '' ELSE ',' + MAX([SQ12]) END
					+ CASE WHEN MAX([SQ13]) IS NULL THEN '' ELSE ',' + MAX([SQ13]) END	+ CASE WHEN MAX([SQ14]) IS NULL THEN '' ELSE ',' + MAX([SQ14]) END
					+ CASE WHEN MAX([SQ15]) IS NULL THEN '' ELSE ',' + MAX([SQ15]) END	+ CASE WHEN MAX([SQ16]) IS NULL THEN '' ELSE ',' + MAX([SQ16]) END
					+ CASE WHEN MAX([SQ17]) IS NULL THEN '' ELSE ',' + MAX([SQ17]) END	+ CASE WHEN MAX([SQ18]) IS NULL THEN '' ELSE ',' + MAX([SQ18]) END
					+ CASE WHEN MAX([SQ19]) IS NULL THEN '' ELSE ',' + MAX([SQ19]) END	+ CASE WHEN MAX([SQ20]) IS NULL THEN '' ELSE ',' + MAX([SQ20]) END
					+ CASE WHEN MAX([SQ21]) IS NULL THEN '' ELSE ',' + MAX([SQ21]) END 	+ CASE WHEN MAX([SQ22]) IS NULL THEN '' ELSE ',' + MAX([SQ22]) END
					+ CASE WHEN MAX([SQ23]) IS NULL THEN '' ELSE ',' + MAX([SQ23]) END	+ CASE WHEN MAX([SQ24]) IS NULL THEN '' ELSE ',' + MAX([SQ24]) END
					+ CASE WHEN MAX([SQ25]) IS NULL THEN '' ELSE ',' + MAX([SQ25]) END	+ CASE WHEN MAX([SQ26]) IS NULL THEN '' ELSE ',' + MAX([SQ26]) END
					+ CASE WHEN MAX([SQ27]) IS NULL THEN '' ELSE ',' + MAX([SQ27]) END	+ CASE WHEN MAX([SQ28]) IS NULL THEN '' ELSE ',' + MAX([SQ28]) END
					+ CASE WHEN MAX([SQ29]) IS NULL THEN '' ELSE ',' + MAX([SQ29]) END	+ CASE WHEN MAX([SQ30]) IS NULL THEN '' ELSE ',' + MAX([SQ30]) END 
					+ CASE WHEN MAX([SQ31]) IS NULL THEN '' ELSE ',' + MAX([SQ31]) END 	+ CASE WHEN MAX([SQ32]) IS NULL THEN '' ELSE ',' + MAX([SQ32]) END
					+ CASE WHEN MAX([SQ33]) IS NULL THEN '' ELSE ',' + MAX([SQ33]) END	+ CASE WHEN MAX([SQ34]) IS NULL THEN '' ELSE ',' + MAX([SQ34]) END
					+ CASE WHEN MAX([SQ35]) IS NULL THEN '' ELSE ',' + MAX([SQ35]) END	+ CASE WHEN MAX([SQ36]) IS NULL THEN '' ELSE ',' + MAX([SQ36]) END
					+ CASE WHEN MAX([SQ37]) IS NULL THEN '' ELSE ',' + MAX([SQ37]) END	+ CASE WHEN MAX([SQ38]) IS NULL THEN '' ELSE ',' + MAX([SQ38]) END
					+ CASE WHEN MAX([SQ39]) IS NULL THEN '' ELSE ',' + MAX([SQ39]) END	+ CASE WHEN MAX([SQ40]) IS NULL THEN '' ELSE ',' + MAX([SQ40]) END 
					+ CASE WHEN MAX([SQ41]) IS NULL THEN '' ELSE ',' + MAX([SQ41]) END 	+ CASE WHEN MAX([SQ42]) IS NULL THEN '' ELSE ',' + MAX([SQ42]) END
					+ CASE WHEN MAX([SQ43]) IS NULL THEN '' ELSE ',' + MAX([SQ43]) END	+ CASE WHEN MAX([SQ44]) IS NULL THEN '' ELSE ',' + MAX([SQ44]) END
					+ CASE WHEN MAX([SQ45]) IS NULL THEN '' ELSE ',' + MAX([SQ45]) END	+ CASE WHEN MAX([SQ46]) IS NULL THEN '' ELSE ',' + MAX([SQ46]) END
					+ CASE WHEN MAX([SQ47]) IS NULL THEN '' ELSE ',' + MAX([SQ47]) END	+ CASE WHEN MAX([SQ48]) IS NULL THEN '' ELSE ',' + MAX([SQ48]) END
					+ CASE WHEN MAX([SQ49]) IS NULL THEN '' ELSE ',' + MAX([SQ49]) END	+ CASE WHEN MAX([SQ50]) IS NULL THEN '' ELSE ',' + MAX([SQ50]) END 
					+ CASE WHEN MAX([SQ51]) IS NULL THEN '' ELSE ',' + MAX([SQ51]) END 	+ CASE WHEN MAX([SQ52]) IS NULL THEN '' ELSE ',' + MAX([SQ52]) END
					+ CASE WHEN MAX([SQ53]) IS NULL THEN '' ELSE ',' + MAX([SQ53]) END	+ CASE WHEN MAX([SQ54]) IS NULL THEN '' ELSE ',' + MAX([SQ54]) END
					+ CASE WHEN MAX([SQ55]) IS NULL THEN '' ELSE ',' + MAX([SQ55]) END	+ CASE WHEN MAX([SQ56]) IS NULL THEN '' ELSE ',' + MAX([SQ56]) END
					+ CASE WHEN MAX([SQ57]) IS NULL THEN '' ELSE ',' + MAX([SQ57]) END	+ CASE WHEN MAX([SQ58]) IS NULL THEN '' ELSE ',' + MAX([SQ58]) END
					+ CASE WHEN MAX([SQ59]) IS NULL THEN '' ELSE ',' + MAX([SQ59]) END	+ CASE WHEN MAX([SQ60]) IS NULL THEN '' ELSE ',' + MAX([SQ60]) END 
					+ CASE WHEN MAX([SQ61]) IS NULL THEN '' ELSE ',' + MAX([SQ61]) END 	+ CASE WHEN MAX([SQ62]) IS NULL THEN '' ELSE ',' + MAX([SQ62]) END
					+ CASE WHEN MAX([SQ63]) IS NULL THEN '' ELSE ',' + MAX([SQ63]) END	+ CASE WHEN MAX([SQ64]) IS NULL THEN '' ELSE ',' + MAX([SQ64]) END
					+ CASE WHEN MAX([SQ65]) IS NULL THEN '' ELSE ',' + MAX([SQ65]) END	+ CASE WHEN MAX([SQ66]) IS NULL THEN '' ELSE ',' + MAX([SQ66]) END
					+ CASE WHEN MAX([SQ67]) IS NULL THEN '' ELSE ',' + MAX([SQ67]) END	+ CASE WHEN MAX([SQ68]) IS NULL THEN '' ELSE ',' + MAX([SQ68]) END
					+ CASE WHEN MAX([SQ69]) IS NULL THEN '' ELSE ',' + MAX([SQ69]) END	+ CASE WHEN MAX([SQ70]) IS NULL THEN '' ELSE ',' + MAX([SQ70]) END 
					+ CASE WHEN MAX([SQ71]) IS NULL THEN '' ELSE ',' + MAX([SQ71]) END 	+ CASE WHEN MAX([SQ72]) IS NULL THEN '' ELSE ',' + MAX([SQ72]) END
					+ CASE WHEN MAX([SQ73]) IS NULL THEN '' ELSE ',' + MAX([SQ73]) END	+ CASE WHEN MAX([SQ74]) IS NULL THEN '' ELSE ',' + MAX([SQ74]) END
					+ CASE WHEN MAX([SQ75]) IS NULL THEN '' ELSE ',' + MAX([SQ75]) END	+ CASE WHEN MAX([SQ76]) IS NULL THEN '' ELSE ',' + MAX([SQ76]) END
					+ CASE WHEN MAX([SQ77]) IS NULL THEN '' ELSE ',' + MAX([SQ77]) END	+ CASE WHEN MAX([SQ78]) IS NULL THEN '' ELSE ',' + MAX([SQ78]) END
					+ CASE WHEN MAX([SQ79]) IS NULL THEN '' ELSE ',' + MAX([SQ79]) END	+ CASE WHEN MAX([SQ80]) IS NULL THEN '' ELSE ',' + MAX([SQ80]) END 
					+ CASE WHEN MAX([SQ81]) IS NULL THEN '' ELSE ',' + MAX([SQ81]) END 	+ CASE WHEN MAX([SQ82]) IS NULL THEN '' ELSE ',' + MAX([SQ82]) END
					+ CASE WHEN MAX([SQ83]) IS NULL THEN '' ELSE ',' + MAX([SQ83]) END	+ CASE WHEN MAX([SQ84]) IS NULL THEN '' ELSE ',' + MAX([SQ84]) END
					+ CASE WHEN MAX([SQ85]) IS NULL THEN '' ELSE ',' + MAX([SQ85]) END	+ CASE WHEN MAX([SQ86]) IS NULL THEN '' ELSE ',' + MAX([SQ86]) END
					+ CASE WHEN MAX([SQ87]) IS NULL THEN '' ELSE ',' + MAX([SQ87]) END	+ CASE WHEN MAX([SQ88]) IS NULL THEN '' ELSE ',' + MAX([SQ88]) END
					+ CASE WHEN MAX([SQ89]) IS NULL THEN '' ELSE ',' + MAX([SQ89]) END	+ CASE WHEN MAX([SQ90]) IS NULL THEN '' ELSE ',' + MAX([SQ90]) END
					+ CASE WHEN MAX([SQ91]) IS NULL THEN '' ELSE ',' + MAX([SQ91]) END 	+ CASE WHEN MAX([SQ92]) IS NULL THEN '' ELSE ',' + MAX([SQ92]) END
					+ CASE WHEN MAX([SQ93]) IS NULL THEN '' ELSE ',' + MAX([SQ93]) END	+ CASE WHEN MAX([SQ94]) IS NULL THEN '' ELSE ',' + MAX([SQ94]) END
					+ CASE WHEN MAX([SQ95]) IS NULL THEN '' ELSE ',' + MAX([SQ95]) END	+ CASE WHEN MAX([SQ96]) IS NULL THEN '' ELSE ',' + MAX([SQ96]) END
					+ CASE WHEN MAX([SQ97]) IS NULL THEN '' ELSE ',' + MAX([SQ97]) END	+ CASE WHEN MAX([SQ98]) IS NULL THEN '' ELSE ',' + MAX([SQ98]) END
					+ CASE WHEN MAX([SQ99]) IS NULL THEN '' ELSE ',' + MAX([SQ99]) END	+ CASE WHEN MAX([SQ100]) IS NULL THEN '' ELSE ',' + MAX([SQ100]) END AS SO_QTY --[C20210225-000385] SO_QTY 추가(','로 구분)
				   */
					, FROM_COMPANY_ID, PLANT_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				   --INTO #DM_DNM_SALES_RESULT
				   INTO #TEMP_DM_DNM_SALES_RESULT
				   --[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 END
				   FROM
					(
					select 
							 DIVISION_ID
							,COMPANY_ID
							,PROJECT_CODE
							,SALES_SITE_ID
							,PLANT_SITE_ID
							,ITEM_ID
							,ORIGIN_ITEM_ID
							,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', distribution_channel), 'E') AS DOM_EXP
							,INCOTERMS
							,SALES_AMOUNT_FOR
							,SALES_AMOUNT_SUM
							,SALES_QTY       
							,CURRENCY
							,sales_posting_date AS YYYYMMDD
							,FCST_TYPE
							,customer_code		AS SOLDTO_CODE
							,SHIPTO_CODE
							,'Y'				AS VALID_YN
							,'scm_batch'		AS CREATED_BY
							,GETDATE()			AS CREATION_DATE
							,'scm_batch'		AS LAST_UPDATED_BY
							,GETDATE()			AS LAST_UPDATE_DATE
							,ATTRIBUTE1
							,INTERNAL_TYPE
							,ATTRIBUTE3, ATTRIBUTE4 --2020.12.01   
							, SO_NO, SO_QTY --[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)
							--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 START
							/*
							, 'SN' + CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID,COMPANY_ID,PROJECT_CODE,SALES_SITE_ID,PLANT_SITE_ID,ITEM_ID,ORIGIN_ITEM_ID
															 ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', distribution_channel), 'E'),INCOTERMS
							                                 ,CURRENCY,sales_posting_date,FCST_TYPE,customer_code,SHIPTO_CODE,INTERNAL_TYPE ORDER BY SO_NO) AS NVARCHAR(10)) AS SO_NO_ROW_NUM --[C20210225-000385] SO_NO Rownum 추가
							, 'SQ' + CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID,COMPANY_ID,PROJECT_CODE,SALES_SITE_ID,PLANT_SITE_ID,ITEM_ID
															 ,ORIGIN_ITEM_ID,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', distribution_channel), 'E'),INCOTERMS
							                                 ,CURRENCY,sales_posting_date,FCST_TYPE,customer_code,SHIPTO_CODE,INTERNAL_TYPE ORDER BY SO_NO) AS NVARCHAR(1000)) AS SO_QTY_ROW_NUM --[C20210225-000385] SO_QTY Rownum 추가
							*/
							--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 END							
							--[E20251029-000963]_원소스 주석 처리 후 40 사업부 외 다른 사업부는 CELL_PROD_SITE_ID를 보관하지 않으므로 '-'로 변환하도록 수정  (START)
							--이유: COMPANY_ID [VTOO]로 새로 데이터를 넣으면서, 동일한 날짜에 FROM_COMPAY_ID가 다르게 들어오면서 오류가 발생함. 40 사업부 외는 필요없으므로 '-'를 상단에서 처리
							--, FROM_COMPANY_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
							, '-' AS FROM_COMPANY_ID	-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
							--[E20251029-000963]_원소스 주석 처리 후 40 사업부 외 다른 사업부는 CELL_PROD_SITE_ID를 보관하지 않으므로 '-'로 변환하도록 수정 (END)
							--[E20260821-001396]_PLANT_ID 중복건으로 오류발생 40 사업부에만 의미있는 값으로 40사업부 외는 변환 처리 (START)
							--, PLANT_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 --[E20260821-001396]_원소스 주석처리
							, '-' AS PLANT_ID				--[E20260821-001396]_40외는 '-'처리로 변경
							--[E20260821-001396]_PLANT_ID 중복건으로 오류발생 40 사업부에만 의미있는 값으로 40사업부 외는 변환 처리 (END)
					  from DM_DNM_SALES_RESULT_IF  WITH(NOLOCK)
						where 1=1
							AND DIVISION_ID LIKE '81%'
							AND DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)
							AND SALES_YYYYMM BETWEEN @v_start_yyyymm                        -- 전월 (yyyymm)
										         AND @v_end_yyyymm                          -- 당월 (yyyymm)
							and ( (customer_code <> '' ) or (customer_code = ''   AND profit_center_id = 'A40012'   AND partner_profit_center_id = 'A50101' ))
					--
					UNION ALL
					--
					select 
							 DIVISION_ID
							,COMPANY_ID
							,PROJECT_CODE
							,SALES_SITE_ID
							,PLANT_SITE_ID
							,ITEM_ID
							,ORIGIN_ITEM_ID
							,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', distribution_channel), 'E') AS DOM_EXP
							,INCOTERMS
							,SALES_AMOUNT_FOR
							,SALES_AMOUNT_SUM
							,SALES_QTY       
							,CURRENCY
							,sales_posting_date AS YYYYMMDD
							,FCST_TYPE
							,customer_code		AS SOLDTO_CODE
							,SHIPTO_CODE
							,'Y'				AS VALID_YN
							,'scm_batch'		AS CREATED_BY
							,GETDATE()			AS CREATION_DATE
							,'scm_batch'		AS LAST_UPDATED_BY
							,GETDATE()			AS LAST_UPDATE_DATE
							,ATTRIBUTE1
							,INTERNAL_TYPE
							,ATTRIBUTE3, ATTRIBUTE4 --2020.12.01    
							, SO_NO, SO_QTY --[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)
							--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 START
							/*
							, 'SN' + CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID,COMPANY_ID,PROJECT_CODE,SALES_SITE_ID,PLANT_SITE_ID,ITEM_ID,ORIGIN_ITEM_ID
															 ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', distribution_channel), 'E'),INCOTERMS
							                                 ,CURRENCY,sales_posting_date,FCST_TYPE,customer_code,SHIPTO_CODE,INTERNAL_TYPE ORDER BY SO_NO) AS NVARCHAR(10)) AS SO_NO_ROW_NUM --[C20210225-000385] SO_NO Rownum 추가
							, 'SQ' + CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID,COMPANY_ID,PROJECT_CODE,SALES_SITE_ID,PLANT_SITE_ID,ITEM_ID
															 ,ORIGIN_ITEM_ID,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', distribution_channel), 'E'),INCOTERMS
							                                 ,CURRENCY,sales_posting_date,FCST_TYPE,customer_code,SHIPTO_CODE,INTERNAL_TYPE ORDER BY SO_NO) AS NVARCHAR(1000)) AS SO_QTY_ROW_NUM --[C20210225-000385] SO_QTY Rownum 추가
							*/
							--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 END
							--[E20251029-000963]_원소스 주석 처리 후 40 사업부 외 다른 사업부는 CELL_PROD_SITE_ID를 보관하지 않으므로 '-'로 변환하도록 수정  (START)
							--이유: COMPANY_ID [VTOO]로 새로 데이터를 넣으면서, 동일한 날짜에 FROM_COMPAY_ID가 다르게 들어오면서 오류가 발생함. 40 사업부 외는 필요없으므로 '-'를 상단에서 처리
							--, FROM_COMPANY_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
							, '-' AS FROM_COMPANY_ID	-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
							--[E20260821-001396]_PLANT_ID 중복건으로 오류발생 40 사업부에만 의미있는 값으로 40사업부 외는 변환 처리 (START)
							--, PLANT_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 [E20260821-001396]_원소스 주석처리
							, '-' AS PLANT_ID				-- 40외는 '-'처리로 변경
							--[E20260821-001396]_PLANT_ID 중복건으로 오류발생 40 사업부에만 의미있는 값으로 40사업부 외는 변환 처리 (END)
							--[E20251029-000963]_원소스 주석 처리 후 40 사업부 외 다른 사업부는 CELL_PROD_SITE_ID를 보관하지 않으므로 '-'로 변환하도록 수정  (END)
					  from DM_DNM_SALES_RESULT_IF  WITH(NOLOCK)
						where 1=1
							AND DIVISION_ID = '82'
							AND DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)
							AND SALES_YYYYMM BETWEEN @v_start_yyyymm                        -- 전월 (yyyymm)
										         AND @v_end_yyyymm                          -- 당월 (yyyymm)						
					--
					UNION ALL
					--

				/*  소형 예외조건 적용
				1. 제품국내매출:사내 인 경우에는 오창 전력저장 전지 는 포함하고, 전지사업본부 공통 은 수량은 0 으로 하고 금액만 ETC에 포함시킴
				--------------------------------------------------------------------------------------------
				  COST_ITEM	      COST_ITEM_NAME	PARTNER_PROFIT_CENTER_ID	PARTNER_PROFIT_CENTER_NAME			
				--------------------------------------------------------------------------------------------
				  0004111120	     제품국내매출:사내	    189000	                     전지사업본부 공통
				  0004111120	     제품국내매출:사내	    A50101	                     오창 전력저장 전지
				--------------------------------------------------------------------------------------------
				   (Code)
					,CASE WHEN COST_ITEM = '0004111120' AND PARTNER_PROFIT_CENTER_ID = '189000' THEN 'ETC' ELSE ITEM_ID END ITEM_ID
					,CASE WHEN COST_ITEM = '0004111120' AND PARTNER_PROFIT_CENTER_ID = '189000' THEN 0  -- 제품국내매출:사내 인 경우에는 오창 전력저장 전지 는 포함하고, 전지사업본부 공통 은 수량은 0 으로 하고 금액만 ETC에 포함시킴
							ELSE SALES_QTY END SALES_QTY

				2. G450은 SITE Mapping을 하지 말고, ETC로 묶여서 보여줬으면 함. G450은 소형에서 자동차 사업부로 파는 매출로 연결 매출이라고 함. G450을 N 으로 바꾸면 연결로 변경됨.
				   (Code)
				   ,CASE WHEN customer_code = 'G450' THEN 'N' ELSE SALES_SITE_ID END SALES_SITE_ID
				*/
					select 
							 DIVISION_ID
							,COMPANY_ID
						--	,PROJECT_CODE
							,CASE WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) THEN 'Peopleworks'
							      -- added by ytchoi 181107 ETC에 대해서는 project code를 통일 
							      WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME not in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) THEN ''
							      ELSE PROJECT_CODE END PROJECT_CODE
							,CASE WHEN customer_code = 'G450' THEN 'N' 
							      WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) THEN 'Peopleworks_KR_KUM'
								  -- added by ytchoi 181107 ETC에 대해서는 project code를 통일 
								  WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME not in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) THEN ''
							      ELSE SALES_SITE_ID END SALES_SITE_ID
							,PLANT_SITE_ID
							--,CASE WHEN COST_ITEM = '0004111120' AND PARTNER_PROFIT_CENTER_ID = '189000' THEN 'ETC' ELSE ITEM_ID END ITEM_ID
							--,CASE WHEN PARTNER_PROFIT_CENTER_NAME = N'전지사업본부 공통' THEN 'ETC' ELSE ITEM_ID END ITEM_ID  -- 구희택 사원 요청건
							,CASE WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME NOT in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) 
									OR	(COMPANY_ID = 'G180' AND CUSTOMER_CODE IN ('G450','G630'))  -- 20191111 KHSONG CSR ID:4103469 GSCM Sales Plan, Waterfall ETC 매출 설정 로직 추가의 건
									THEN
							         CASE ( SELECT CELL_TYPE FROM DM_MST_ITEM_SINGLE_V V WITH(NOLOCK) WHERE V.DIVISION_ID = '40' AND V.ITEM_ID = X.ITEM_ID)  
									      WHEN  'POUCH'       THEN  'ETC_P'
									      WHEN  'CYLINDRICAL' THEN  'ETC_C'
										  WHEN  'PRISMATIC'   THEN  'ETC_R'
										  WHEN  'POLYMER'     THEN  'ETC_P'
										  -- added by ytchoi 181107 CELL_TYPE 추가 
										  WHEN  'SPIN-TYPE CYLINDRICAL' THEN 'ETC_C'
										  WHEN  'CCYLINDRICAL' THEN 'ETC_C'
										  ELSE  'ETC' END
							      ELSE ITEM_ID END ITEM_ID  -- 구희택 사원 요청건
							,ORIGIN_ITEM_ID
							,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', distribution_channel), 'E') AS DOM_EXP
							-- ,INCOTERMS
							,CASE WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) THEN 'EXW'
							      ELSE INCOTERMS END INCOTERMS
							,SALES_AMOUNT_FOR
							,SALES_AMOUNT_SUM
							--,CASE WHEN COST_ITEM = '0004111120' AND PARTNER_PROFIT_CENTER_ID = '189000' THEN 0 ELSE SALES_QTY END SALES_QTY      
							--,CASE WHEN PARTNER_PROFIT_CENTER_NAME = N'전지사업본부 공통' THEN 0 ELSE SALES_QTY END SALES_QTY  -- 구희택 사원 요청건 
							,CASE WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME NOT in ( N'전력저장전지 공통',N'오창 전력저장 전지' )  THEN 0 ELSE SALES_QTY END SALES_QTY  -- 구희택 사원 요청건 
							,CURRENCY
							,sales_posting_date AS YYYYMMDD
							,FCST_TYPE
							,customer_code		AS SOLDTO_CODE
							,SHIPTO_CODE
							,'Y'				AS VALID_YN
							,'scm_batch'		AS CREATED_BY
							,GETDATE()			AS CREATION_DATE
							,'scm_batch'		AS LAST_UPDATED_BY
							,GETDATE()			AS LAST_UPDATE_DATE
							,ATTRIBUTE1
							,INTERNAL_TYPE
							,ATTRIBUTE3, ATTRIBUTE4 --2020.12.01   
							, SO_NO, SO_QTY --[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)
							--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 START
							/*
							, 'SN' + CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID,COMPANY_ID
															 ,CASE WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) THEN 'Peopleworks'
															  WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME not in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) THEN ''
															  ELSE PROJECT_CODE END
															 ,CASE WHEN customer_code = 'G450' THEN 'N' 
															  WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) THEN 'Peopleworks_KR_KUM'
															  WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME not in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) THEN ''
															  ELSE SALES_SITE_ID END
															 ,PLANT_SITE_ID
															 ,CASE WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME NOT in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) 
																OR	(COMPANY_ID = 'G180' AND CUSTOMER_CODE IN ('G450','G630'))  -- 20191111 KHSONG CSR ID:4103469 GSCM Sales Plan, Waterfall ETC 매출 설정 로직 추가의 건
																THEN
																 CASE ( SELECT CELL_TYPE FROM DM_MST_ITEM_SINGLE_V V WITH(NOLOCK) WHERE V.DIVISION_ID = '40' AND V.ITEM_ID = X.ITEM_ID)  
																	  WHEN  'POUCH'       THEN  'ETC_P'
																	  WHEN  'CYLINDRICAL' THEN  'ETC_C'
																	  WHEN  'PRISMATIC'   THEN  'ETC_R'
																	  WHEN  'POLYMER'     THEN  'ETC_P'
																	  WHEN  'SPIN-TYPE CYLINDRICAL' THEN 'ETC_C'
																	  WHEN  'CCYLINDRICAL' THEN 'ETC_C'
																	  ELSE  'ETC' END
															  ELSE ITEM_ID END
															 ,ORIGIN_ITEM_ID
															 ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', distribution_channel), 'E')
															 ,CASE WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) THEN 'EXW'
																	ELSE INCOTERMS END
							                                 ,CURRENCY,sales_posting_date,FCST_TYPE,customer_code,SHIPTO_CODE,INTERNAL_TYPE ORDER BY SO_NO) AS NVARCHAR(10)) AS SO_NO_ROW_NUM --[C20210225-000385] SO_NO Rownum 추가
							, 'SQ' + CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID,COMPANY_ID
															 ,CASE WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) THEN 'Peopleworks'
															  WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME not in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) THEN ''
															  ELSE PROJECT_CODE END
															 ,CASE WHEN customer_code = 'G450' THEN 'N' 
															  WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) THEN 'Peopleworks_KR_KUM'
															  WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME not in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) THEN ''
															  ELSE SALES_SITE_ID END
															 ,PLANT_SITE_ID
															 ,CASE WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME NOT in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) 
																OR	(COMPANY_ID = 'G180' AND CUSTOMER_CODE IN ('G450','G630'))  -- 20191111 KHSONG CSR ID:4103469 GSCM Sales Plan, Waterfall ETC 매출 설정 로직 추가의 건
																THEN
																 CASE ( SELECT CELL_TYPE FROM DM_MST_ITEM_SINGLE_V V WITH(NOLOCK) WHERE V.DIVISION_ID = '40' AND V.ITEM_ID = X.ITEM_ID)  
																	  WHEN  'POUCH'       THEN  'ETC_P'
																	  WHEN  'CYLINDRICAL' THEN  'ETC_C'
																	  WHEN  'PRISMATIC'   THEN  'ETC_R'
																	  WHEN  'POLYMER'     THEN  'ETC_P'
																	  WHEN  'SPIN-TYPE CYLINDRICAL' THEN 'ETC_C'
																	  WHEN  'CCYLINDRICAL' THEN 'ETC_C'
																	  ELSE  'ETC' END
															  ELSE ITEM_ID END
															 ,ORIGIN_ITEM_ID
															 ,dbo.FN_SCM_SYS_NVL(dbo.FN_GET_LOOKUP_CODE_DESC('DISTRIBUTION_CHANNEL', distribution_channel), 'E')
															 ,CASE WHEN DISTRIBUTION_CHANNEL = '70'	and PARTNER_PROFIT_CENTER_NAME in ( N'전력저장전지 공통',N'오창 전력저장 전지' ) THEN 'EXW'
																	ELSE INCOTERMS END
							                                 ,CURRENCY,sales_posting_date,FCST_TYPE,customer_code,SHIPTO_CODE,INTERNAL_TYPE ORDER BY SO_NO) AS NVARCHAR(1000)) AS SO_QTY_ROW_NUM --[C20210225-000385] SO_QTY Rownum 추가
					  */	
					  --[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 END						
							, FROM_COMPANY_ID, PLANT_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						from DM_DNM_SALES_RESULT_IF X  WITH(NOLOCK)
						where 1=1
							AND DIVISION_ID = '40'
							AND DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)
							AND SALES_YYYYMM BETWEEN @v_start_yyyymm                        -- 전월 (yyyymm)
										         AND @v_end_yyyymm                          -- 당월 (yyyymm)
												  -- table partion 적용되어서 이 컬럼 쓰도록 하자.
							AND SALES_AMOUNT_SUM <> 0 -- Amount가 0 인것은 제외
							AND SALES_GROUP NOT IN ( 'A10', 'A11' ) -- 유상사급 수출공통 / 40유상사급 제외
					) A
	--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 START
	/*
	PIVOT (
		MAX(SO_NO) FOR SO_NO_ROW_NUM IN ( [SN1], [SN2], [SN3], [SN4], [SN5], [SN6], [SN7], [SN8], [SN9], [SN10] ,[SN11], [SN12], [SN13], [SN14], [SN15], [SN16], [SN17], [SN18], [SN19], [SN20]
									,[SN21], [SN22], [SN23], [SN24], [SN25], [SN26], [SN27], [SN28], [SN29], [SN30],[SN31], [SN32], [SN33], [SN34], [SN35], [SN36], [SN37], [SN38], [SN39], [SN40]
									,[SN41], [SN42], [SN43], [SN44], [SN45], [SN46], [SN47], [SN48], [SN49], [SN50],[SN51], [SN52], [SN53], [SN54], [SN55], [SN56], [SN57], [SN58], [SN59], [SN60]
									,[SN61], [SN62], [SN63], [SN64], [SN65], [SN66], [SN67], [SN68], [SN69], [SN70],[SN71], [SN72], [SN73], [SN74], [SN75], [SN76], [SN77], [SN78], [SN79], [SN80]
									,[SN81], [SN82], [SN83], [SN84], [SN85], [SN86], [SN87], [SN88], [SN89], [SN90],[SN91], [SN92], [SN93], [SN94], [SN95], [SN96], [SN97], [SN98], [SN99], [SN100]  )
		) AS PVT1 --[C20210225-000385] Key 값 기준으로 최대 100개 SO_NO를 갖을 수 있음
	PIVOT (
		MAX(SO_QTY) FOR SO_QTY_ROW_NUM IN ( [SQ1], [SQ2], [SQ3], [SQ4], [SQ5], [SQ6], [SQ7], [SQ8], [SQ9], [SQ10] ,[SQ11], [SQ12], [SQ13], [SQ14], [SQ15], [SQ16], [SQ17], [SQ18], [SQ19], [SQ20]
									,[SQ21], [SQ22], [SQ23], [SQ24], [SQ25], [SQ26], [SQ27], [SQ28], [SQ29], [SQ30],[SQ31], [SQ32], [SQ33], [SQ34], [SQ35], [SQ36], [SQ37], [SQ38], [SQ39], [SQ40]
									,[SQ41], [SQ42], [SQ43], [SQ44], [SQ45], [SQ46], [SQ47], [SQ48], [SQ49], [SQ50],[SQ51], [SQ52], [SQ53], [SQ54], [SQ55], [SQ56], [SQ57], [SQ58], [SQ59], [SQ60]
									,[SQ61], [SQ62], [SQ63], [SQ64], [SQ65], [SQ66], [SQ67], [SQ68], [SQ69], [SQ70],[SQ71], [SQ72], [SQ73], [SQ74], [SQ75], [SQ76], [SQ77], [SQ78], [SQ79], [SQ80]
									,[SQ81], [SQ82], [SQ83], [SQ84], [SQ85], [SQ86], [SQ87], [SQ88], [SQ89], [SQ90],[SQ91], [SQ92], [SQ93], [SQ94], [SQ95], [SQ96], [SQ97], [SQ98], [SQ99], [SQ100]  )
		) AS PVT2  --[C20210225-000385] Key 값 기준으로 최대 100개 SO_QTY를 갖을 수 있음	
		*/
	--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 END
							,
					( SELECT 'SALES_RESULT' MEASURE
						UNION 
					  SELECT 'SALES_RESULT_AMOUNT' MEASURE
						UNION 
					  SELECT 'SALES_RESULT_AMOUNT_KRW' MEASURE
					) B
					WHERE 1=1
				GROUP BY 	DIVISION_ID
						   ,COMPANY_ID
						   ,PROJECT_CODE
						   ,SALES_SITE_ID
						   ,PLANT_SITE_ID
						   ,ITEM_ID
						   ,ORIGIN_ITEM_ID
						   ,DOM_EXP
						   ,INCOTERMS
						   ,CURRENCY
						   ,YYYYMMDD
						   ,FCST_TYPE
						   ,SOLDTO_CODE
						   ,SHIPTO_CODE
						   ,VALID_YN
						   ,B.MEASURE
						   ,INTERNAL_TYPE
						   --[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 START
						   ,SO_NO
						   ,SO_QTY
						   --[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 END
						   , FROM_COMPANY_ID, PLANT_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			END
			---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
			--                                                                                     20180911 KHSONG 대상테이블 변경 DM_DNM_SALES_RESULT -> DM_DNM_SALES_RESULT_IF (END)
			---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 START
	print 'step-2-A'		

	BEGIN
		SELECT	DIVISION_ID, COMPANY_ID, PROJECT_CODE, SALES_SITE_ID, PLANT_SITE_ID, ITEM_ID
		   , ORIGIN_ITEM_ID, DOM_EXP, INCOTERMS, MEASURE, CURRENCY, YYYYMMDD, FCST_TYPE, SUM(QTY) AS QTY
		   , SOLDTO_CODE, SHIPTO_CODE, VALID_YN
		   ,'scm_batch'		AS CREATED_BY
		   , GETDATE()		AS CREATION_DATE
		   ,'scm_batch'		AS LAST_UPDATED_BY
		   , GETDATE()		AS LAST_UPDATE_DATE
		   , INTERNAL_TYPE		
		   , MAX(ATTRIBUTE1)		ATTRIBUTE1
		   , SUM(CASE WHEN ISNUMERIC(ATTRIBUTE3) > 0 THEN CAST(ATTRIBUTE3 AS NUMERIC(30,10))
					   ELSE 0 END)  AS ATTRIBUTE3
		   , MAX(ATTRIBUTE4) AS ATTRIBUTE4 
		   , STUFF((SELECT ',' + SO_NO 
					FROM #TEMP_DM_DNM_SALES_RESULT B WITH(NOLOCK)
					WHERE A.DIVISION_ID = B.DIVISION_ID
					AND A.COMPANY_ID = B.COMPANY_ID
					AND A.PROJECT_CODE = B.PROJECT_CODE
					AND A.SALES_SITE_ID = B.SALES_SITE_ID	
					AND A.PLANT_SITE_ID = B.PLANT_SITE_ID	
					AND A.ITEM_ID = B.ITEM_ID	
					AND A.ORIGIN_ITEM_ID = B.ORIGIN_ITEM_ID	   
					AND A.DOM_EXP = B.DOM_EXP	   
					AND A.INCOTERMS = B.INCOTERMS	  
					AND A.CURRENCY = B.CURRENCY	 
					AND A.YYYYMMDD = B.YYYYMMDD	  
					AND A.FCST_TYPE = B.FCST_TYPE	  
					AND A.SOLDTO_CODE = B.SOLDTO_CODE	
					AND A.SHIPTO_CODE = B.SHIPTO_CODE	 
					AND A.VALID_YN = B.VALID_YN	  
					AND A.MEASURE = B.MEASURE	  
					AND ISNULL(A.INTERNAL_TYPE,'') = ISNULL(B.INTERNAL_TYPE,'')	    
					AND A.FROM_COMPANY_ID	= B.FROM_COMPANY_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					 FOR XML PATH('')
				), 1, 1, '') AS SO_NO
		   , STUFF((SELECT ',' + SO_QTY
					FROM #TEMP_DM_DNM_SALES_RESULT B WITH(NOLOCK)
					WHERE A.DIVISION_ID = B.DIVISION_ID
					AND A.COMPANY_ID = B.COMPANY_ID
					AND A.PROJECT_CODE = B.PROJECT_CODE
					AND A.SALES_SITE_ID = B.SALES_SITE_ID	
					AND A.PLANT_SITE_ID = B.PLANT_SITE_ID	
					AND A.ITEM_ID = B.ITEM_ID	
					AND A.ORIGIN_ITEM_ID = B.ORIGIN_ITEM_ID	   
					AND A.DOM_EXP = B.DOM_EXP	   
					AND A.INCOTERMS = B.INCOTERMS	  
					AND A.CURRENCY = B.CURRENCY	 
					AND A.YYYYMMDD = B.YYYYMMDD	  
					AND A.FCST_TYPE = B.FCST_TYPE	  
					AND A.SOLDTO_CODE = B.SOLDTO_CODE	
					AND A.SHIPTO_CODE = B.SHIPTO_CODE	
					AND A.VALID_YN = B.VALID_YN	   
					AND A.MEASURE = B.MEASURE	  
					AND ISNULL(A.INTERNAL_TYPE,'') = ISNULL(B.INTERNAL_TYPE,'')	
					AND A.FROM_COMPANY_ID	= B.FROM_COMPANY_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					 FOR XML PATH('')
				), 1, 1, '') AS SO_QTY
			, FROM_COMPANY_ID, PLANT_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
		INTO #DM_DNM_SALES_RESULT
		FROM #TEMP_DM_DNM_SALES_RESULT A WITH(NOLOCK)
		GROUP BY DIVISION_ID, COMPANY_ID, PROJECT_CODE, SALES_SITE_ID, PLANT_SITE_ID, ITEM_ID
			   , ORIGIN_ITEM_ID, DOM_EXP, INCOTERMS, MEASURE, CURRENCY, YYYYMMDD, FCST_TYPE
			   , SOLDTO_CODE, SHIPTO_CODE, VALID_YN, INTERNAL_TYPE		
			   , FROM_COMPANY_ID, PLANT_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가

	END
	--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 END
	
	print 'step-3'

			DELETE
			  FROM	dbo.DM_PLN_MKT_FCST_RESULT
			 WHERE	MEASURE   = 'RTF'
				AND YYYYMMDD <  @v_end_yyyymmdd    -- 당일 (yyyymmdd)
				AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
			    AND DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)

			/* [E20240415-000036]_SCM시스템의 사내간 거래 매출 실적 인식을 위한 신규개발/기능변경  
			- 예외캐이스 처리 룩업(DM_EXCEPT_SALES_SITE_MAPPING)추가 , 실적집계프로그램 상 예외처리 프로세스 반영 (AND ISNULL(C.SEGMENT4,'') = ''  조건 추가) */
			SELECT 
				DIVISION_ID,PROJECT_CODE,CASE WHEN len(soldto_code) = 4 AND ISNULL(C.SEGMENT4,'') = '' THEN CASE WHEN soldto_code = 'B100' THEN 'C100' ELSE soldto_code END ELSE SALES_SITE_ID END SALES_SITE_ID
				,ISNULL(PLANT_SITE_ID, '')	 PLANT_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,YYYYMMDD
				,SUM(CASE WHEN ISNULL(B.SEGMENT4,'') = 'Y' THEN 0 ELSE QTY END ) AS QTY
				,MAX(A.CREATED_BY) AS CREATED_BY,MAX(A.CREATION_DATE)	AS CREATION_DATE,MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY,MAX(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
				,MAX(A.ATTRIBUTE1) AS ATTRIBUTE1
				,SUM(CASE WHEN ISNULL(B.SEGMENT4,'') = 'Y' THEN QTY ELSE 0 END ) AS INTERNAL_QTY
				,SUM(A.ATTRIBUTE3) AS ATTRIBUTE3, MAX(A.ATTRIBUTE4) AS ATTRIBUTE4 -- 2020.12.01
				, B.SEGMENT4 AS DM_ESS_RESULT_MAP, SO_NO, SO_QTY --[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)		
				--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 START
				/*					
				, 'SN' + CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID,PROJECT_CODE,CASE WHEN len(soldto_code) = 4 AND ISNULL(C.SEGMENT4,'') = ''  THEN CASE WHEN soldto_code = 'B100' THEN 'C100' ELSE soldto_code END ELSE SALES_SITE_ID END
													,ISNULL(PLANT_SITE_ID, '')	,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,YYYYMMDD ORDER BY SO_NO) AS NVARCHAR(10)) AS SO_NO_ROW_NUM --[C20210225-000385] SO_NO Rownum 추가
					
				, 'SQ' + CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID,PROJECT_CODE,CASE WHEN len(soldto_code) = 4 AND ISNULL(C.SEGMENT4,'') = ''  THEN CASE WHEN soldto_code = 'B100' THEN 'C100' ELSE soldto_code END ELSE SALES_SITE_ID END
													,ISNULL(PLANT_SITE_ID, '')	,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,YYYYMMDD ORDER BY SO_NO) AS NVARCHAR(10)) AS SO_QTY_ROW_NUM --[C20210225-000385] SO_QTY Rownum 추가
				*/
				--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 END
				, FROM_COMPANY_ID, PLANT_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			INTO #DM_DNM_SALES_RESULT_BEFORE
			FROM #DM_DNM_SALES_RESULT A WITH  (NOLOCK)  --20180911 KHSONG 대상테이블 변경 DM_DNM_SALES_RESULT -> DM_DNM_SALES_RESULT_IF
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.INTERNAL_TYPE = B.ATTRIBUTE1 AND B.LOOKUP_TYPE = 'DM_ESS_RESULT_MAP'
			/* [E20240415-000036] : 예외캐이스 룩업 정보 (SEGMENT4 : SALES_SITE_ID) */
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK) ON C.LOOKUP_TYPE = 'DM_EXCEPT_SALES_SITE_MAPPING' AND C.SEGMENT1 = A.DIVISION_ID AND C.SEGMENT2 = A.SOLDTO_CODE AND C.SEGMENT3 = A.SHIPTO_CODE
			WHERE	DIVISION_ID   IN  (SELECT DIVISION_ID FROM #i_division)
				AND	MEASURE   = 'SALES_RESULT'	-- 확인해야하는값
				AND YYYYMMDD <  @v_end_yyyymmdd    -- 당일 (yyyymmdd)
				AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
				AND ISNULL(B.SEGMENT4, 'Y') <> 'N'
			GROUP BY DIVISION_ID,PROJECT_CODE,CASE WHEN len(soldto_code) = 4 AND ISNULL(C.SEGMENT4,'') = '' THEN CASE WHEN soldto_code = 'B100' THEN 'C100' ELSE soldto_code END ELSE SALES_SITE_ID END
				,PLANT_SITE_ID ,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,YYYYMMDD
				, B.SEGMENT4, SO_NO, SO_QTY --[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)
				, FROM_COMPANY_ID, PLANT_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가

			INSERT dbo.DM_PLN_MKT_FCST_RESULT
				( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
				,INCOTERMS,MEASURE,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
				,ATTRIBUTE1,ATTRIBUTE2 
				,ATTRIBUTE3, ATTRIBUTE4 -- 2020.12.01
				,SO_NO, SO_QTY --[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)
				,CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가					
				)
			SELECT 
				A.DIVISION_ID,PROJECT_CODE,SALES_SITE_ID,PLANT_SITE_ID,A.ITEM_ID,DOM_EXP,ISNULL(FCST_TYPE,'MASS') AS FCST_TYPE	--FCST_TYPE
				,INCOTERMS,'RTF' AS  MEASURE,YYYYMMDD
				,SUM(CASE WHEN ISNULL(DM_ESS_RESULT_MAP,'') = 'Y' THEN 0 ELSE QTY END ) AS QTY
				,MAX(CREATED_BY) AS CREATED_BY,MAX(CREATION_DATE)	AS CREATION_DATE,MAX(LAST_UPDATED_BY) AS LAST_UPDATED_BY,GETDATE()
				,MAX(ATTRIBUTE1) AS ATTRIBUTE1
				,SUM(CASE WHEN ISNULL(DM_ESS_RESULT_MAP,'') = 'Y' THEN QTY ELSE 0 END ) AS INTERNAL_QTY
				,SUM(ATTRIBUTE3) AS ATTRIBUTE3, MAX(ATTRIBUTE4) AS ATTRIBUTE4 -- 2020.12.01
				--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 START
				, STUFF((SELECT ',' + SO_NO 
					FROM #DM_DNM_SALES_RESULT_BEFORE B WITH(NOLOCK)
					WHERE A.DIVISION_ID = B.DIVISION_ID
					AND A.PROJECT_CODE = B.PROJECT_CODE
					AND A.SALES_SITE_ID = B.SALES_SITE_ID	
					AND A.PLANT_SITE_ID = B.PLANT_SITE_ID	
					AND A.ITEM_ID = B.ITEM_ID	
					AND A.DOM_EXP = B.DOM_EXP	
					AND ISNULL(A.FCST_TYPE,'MASS') = ISNULL(B.FCST_TYPE,'MASS')	
					AND A.INCOTERMS = B.INCOTERMS	
					AND A.YYYYMMDD = B.YYYYMMDD	
					 FOR XML PATH('')
				), 1, 1, '') AS SO_NO
		   , STUFF((SELECT ',' + SO_QTY
					FROM #DM_DNM_SALES_RESULT_BEFORE B WITH(NOLOCK)
					WHERE A.DIVISION_ID = B.DIVISION_ID
					AND A.PROJECT_CODE = B.PROJECT_CODE
					AND A.SALES_SITE_ID = B.SALES_SITE_ID	
					AND A.PLANT_SITE_ID = B.PLANT_SITE_ID	
					AND A.ITEM_ID = B.ITEM_ID	
					AND A.DOM_EXP = B.DOM_EXP	
					AND ISNULL(A.FCST_TYPE,'MASS') = ISNULL(B.FCST_TYPE,'MASS')	
					AND A.INCOTERMS = B.INCOTERMS	
					AND A.YYYYMMDD = B.YYYYMMDD	
					 FOR XML PATH('')
				), 1, 1, '') AS SO_QTY
				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 START		
				-- 조건1 : 40 사업부만 CELL_PROD_SITE_ID 생성 / 그외 사업부는 모두 '-'로 처리
				-- 조건2 : FROM_COMPANY_ID가 있을 경우 FROM_COMPANY의 CELL_SITE(-A인 사이트)를 찾아서 처리하되 없으면 '-'로 처리 / FROM_COMPANY_ID가 없을 경우 PLANT_ID 기반으로 처리하되 기준정보가 부족할 경우 '-'로 처리
				-- 조건3 : CELL ITEM에 한해서만 CELL_PROD_SITE_ID 생성 / CELL_ITEM_ID가 아닐 경우 모두 '-'로 처리 (참고. CELL_ITEM의 구분은 SCM_ITEM_M_SN 가 MASTER임)
				, CASE WHEN (A.DIVISION_ID = '40' AND ISNULL(A.FROM_COMPANY_ID, '') != '' AND A.ITEM_ID = ISNULL(C.ITEM_ID, '')) THEN ISNULL(B.SCM_SITE_ID, '-')
						WHEN (A.DIVISION_ID = '40' AND ISNULL(A.FROM_COMPANY_ID, '') = '' AND A.ITEM_ID = ISNULL(C.ITEM_ID, '')) THEN DBO.FN_SCM_SYS_NVL(DBO.FN_GET_SCM_SITE_ID_PLANT(A.plant_id, DBO.FN_GET_ITEM_OPERATION_GROUP(A.division_id, A.item_id)),'-') 	
						ELSE '-'					END AS CELL_PROD_SITE_ID
				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 END	
					/*
				, ISNULL(MAX([SN1]),'') + CASE WHEN MAX([SN2]) IS NULL THEN '' ELSE ',' + MAX([SN2]) END
					+ CASE WHEN MAX([SN3]) IS NULL THEN '' ELSE ',' + MAX([SN3]) END	+ CASE WHEN MAX([SN4]) IS NULL THEN '' ELSE ',' + MAX([SN4]) END
					+ CASE WHEN MAX([SN5]) IS NULL THEN '' ELSE ',' + MAX([SN5]) END	+ CASE WHEN MAX([SN6]) IS NULL THEN '' ELSE ',' + MAX([SN6]) END
					+ CASE WHEN MAX([SN7]) IS NULL THEN '' ELSE ',' + MAX([SN7]) END	+ CASE WHEN MAX([SN8]) IS NULL THEN '' ELSE ',' + MAX([SN8]) END
					+ CASE WHEN MAX([SN9]) IS NULL THEN '' ELSE ',' + MAX([SN9]) END	+ CASE WHEN MAX([SN10]) IS NULL THEN '' ELSE ',' + MAX([SN10]) END 
					+ CASE WHEN MAX([SN11]) IS NULL THEN '' ELSE ',' + MAX([SN11]) END 	+ CASE WHEN MAX([SN12]) IS NULL THEN '' ELSE ',' + MAX([SN12]) END
					+ CASE WHEN MAX([SN13]) IS NULL THEN '' ELSE ',' + MAX([SN13]) END	+ CASE WHEN MAX([SN14]) IS NULL THEN '' ELSE ',' + MAX([SN14]) END
					+ CASE WHEN MAX([SN15]) IS NULL THEN '' ELSE ',' + MAX([SN15]) END	+ CASE WHEN MAX([SN16]) IS NULL THEN '' ELSE ',' + MAX([SN16]) END
					+ CASE WHEN MAX([SN17]) IS NULL THEN '' ELSE ',' + MAX([SN17]) END	+ CASE WHEN MAX([SN18]) IS NULL THEN '' ELSE ',' + MAX([SN18]) END
					+ CASE WHEN MAX([SN19]) IS NULL THEN '' ELSE ',' + MAX([SN19]) END	+ CASE WHEN MAX([SN20]) IS NULL THEN '' ELSE ',' + MAX([SN20]) END
					+ CASE WHEN MAX([SN21]) IS NULL THEN '' ELSE ',' + MAX([SN21]) END 	+ CASE WHEN MAX([SN22]) IS NULL THEN '' ELSE ',' + MAX([SN22]) END
					+ CASE WHEN MAX([SN23]) IS NULL THEN '' ELSE ',' + MAX([SN23]) END	+ CASE WHEN MAX([SN24]) IS NULL THEN '' ELSE ',' + MAX([SN24]) END
					+ CASE WHEN MAX([SN25]) IS NULL THEN '' ELSE ',' + MAX([SN25]) END	+ CASE WHEN MAX([SN26]) IS NULL THEN '' ELSE ',' + MAX([SN26]) END
					+ CASE WHEN MAX([SN27]) IS NULL THEN '' ELSE ',' + MAX([SN27]) END	+ CASE WHEN MAX([SN28]) IS NULL THEN '' ELSE ',' + MAX([SN28]) END
					+ CASE WHEN MAX([SN29]) IS NULL THEN '' ELSE ',' + MAX([SN29]) END	+ CASE WHEN MAX([SN30]) IS NULL THEN '' ELSE ',' + MAX([SN30]) END 
					+ CASE WHEN MAX([SN31]) IS NULL THEN '' ELSE ',' + MAX([SN31]) END 	+ CASE WHEN MAX([SN32]) IS NULL THEN '' ELSE ',' + MAX([SN32]) END
					+ CASE WHEN MAX([SN33]) IS NULL THEN '' ELSE ',' + MAX([SN33]) END	+ CASE WHEN MAX([SN34]) IS NULL THEN '' ELSE ',' + MAX([SN34]) END
					+ CASE WHEN MAX([SN35]) IS NULL THEN '' ELSE ',' + MAX([SN35]) END	+ CASE WHEN MAX([SN36]) IS NULL THEN '' ELSE ',' + MAX([SN36]) END
					+ CASE WHEN MAX([SN37]) IS NULL THEN '' ELSE ',' + MAX([SN37]) END	+ CASE WHEN MAX([SN38]) IS NULL THEN '' ELSE ',' + MAX([SN38]) END
					+ CASE WHEN MAX([SN39]) IS NULL THEN '' ELSE ',' + MAX([SN39]) END	+ CASE WHEN MAX([SN40]) IS NULL THEN '' ELSE ',' + MAX([SN40]) END 
					+ CASE WHEN MAX([SN41]) IS NULL THEN '' ELSE ',' + MAX([SN41]) END 	+ CASE WHEN MAX([SN42]) IS NULL THEN '' ELSE ',' + MAX([SN42]) END
					+ CASE WHEN MAX([SN43]) IS NULL THEN '' ELSE ',' + MAX([SN43]) END	+ CASE WHEN MAX([SN44]) IS NULL THEN '' ELSE ',' + MAX([SN44]) END
					+ CASE WHEN MAX([SN45]) IS NULL THEN '' ELSE ',' + MAX([SN45]) END	+ CASE WHEN MAX([SN46]) IS NULL THEN '' ELSE ',' + MAX([SN46]) END
					+ CASE WHEN MAX([SN47]) IS NULL THEN '' ELSE ',' + MAX([SN47]) END	+ CASE WHEN MAX([SN48]) IS NULL THEN '' ELSE ',' + MAX([SN48]) END
					+ CASE WHEN MAX([SN49]) IS NULL THEN '' ELSE ',' + MAX([SN49]) END	+ CASE WHEN MAX([SN50]) IS NULL THEN '' ELSE ',' + MAX([SN50]) END 
					+ CASE WHEN MAX([SN51]) IS NULL THEN '' ELSE ',' + MAX([SN51]) END 	+ CASE WHEN MAX([SN52]) IS NULL THEN '' ELSE ',' + MAX([SN52]) END
					+ CASE WHEN MAX([SN53]) IS NULL THEN '' ELSE ',' + MAX([SN53]) END	+ CASE WHEN MAX([SN54]) IS NULL THEN '' ELSE ',' + MAX([SN54]) END
					+ CASE WHEN MAX([SN55]) IS NULL THEN '' ELSE ',' + MAX([SN55]) END	+ CASE WHEN MAX([SN56]) IS NULL THEN '' ELSE ',' + MAX([SN56]) END
					+ CASE WHEN MAX([SN57]) IS NULL THEN '' ELSE ',' + MAX([SN57]) END	+ CASE WHEN MAX([SN58]) IS NULL THEN '' ELSE ',' + MAX([SN58]) END
					+ CASE WHEN MAX([SN59]) IS NULL THEN '' ELSE ',' + MAX([SN59]) END	+ CASE WHEN MAX([SN60]) IS NULL THEN '' ELSE ',' + MAX([SN60]) END 
					+ CASE WHEN MAX([SN61]) IS NULL THEN '' ELSE ',' + MAX([SN61]) END 	+ CASE WHEN MAX([SN62]) IS NULL THEN '' ELSE ',' + MAX([SN62]) END
					+ CASE WHEN MAX([SN63]) IS NULL THEN '' ELSE ',' + MAX([SN63]) END	+ CASE WHEN MAX([SN64]) IS NULL THEN '' ELSE ',' + MAX([SN64]) END
					+ CASE WHEN MAX([SN65]) IS NULL THEN '' ELSE ',' + MAX([SN65]) END	+ CASE WHEN MAX([SN66]) IS NULL THEN '' ELSE ',' + MAX([SN66]) END
					+ CASE WHEN MAX([SN67]) IS NULL THEN '' ELSE ',' + MAX([SN67]) END	+ CASE WHEN MAX([SN68]) IS NULL THEN '' ELSE ',' + MAX([SN68]) END
					+ CASE WHEN MAX([SN69]) IS NULL THEN '' ELSE ',' + MAX([SN69]) END	+ CASE WHEN MAX([SN70]) IS NULL THEN '' ELSE ',' + MAX([SN70]) END 
					+ CASE WHEN MAX([SN71]) IS NULL THEN '' ELSE ',' + MAX([SN71]) END 	+ CASE WHEN MAX([SN72]) IS NULL THEN '' ELSE ',' + MAX([SN72]) END
					+ CASE WHEN MAX([SN73]) IS NULL THEN '' ELSE ',' + MAX([SN73]) END	+ CASE WHEN MAX([SN74]) IS NULL THEN '' ELSE ',' + MAX([SN74]) END
					+ CASE WHEN MAX([SN75]) IS NULL THEN '' ELSE ',' + MAX([SN75]) END	+ CASE WHEN MAX([SN76]) IS NULL THEN '' ELSE ',' + MAX([SN76]) END
					+ CASE WHEN MAX([SN77]) IS NULL THEN '' ELSE ',' + MAX([SN77]) END	+ CASE WHEN MAX([SN78]) IS NULL THEN '' ELSE ',' + MAX([SN78]) END
					+ CASE WHEN MAX([SN79]) IS NULL THEN '' ELSE ',' + MAX([SN79]) END	+ CASE WHEN MAX([SN80]) IS NULL THEN '' ELSE ',' + MAX([SN80]) END 
					+ CASE WHEN MAX([SN81]) IS NULL THEN '' ELSE ',' + MAX([SN81]) END 	+ CASE WHEN MAX([SN82]) IS NULL THEN '' ELSE ',' + MAX([SN82]) END
					+ CASE WHEN MAX([SN83]) IS NULL THEN '' ELSE ',' + MAX([SN83]) END	+ CASE WHEN MAX([SN84]) IS NULL THEN '' ELSE ',' + MAX([SN84]) END
					+ CASE WHEN MAX([SN85]) IS NULL THEN '' ELSE ',' + MAX([SN85]) END	+ CASE WHEN MAX([SN86]) IS NULL THEN '' ELSE ',' + MAX([SN86]) END
					+ CASE WHEN MAX([SN87]) IS NULL THEN '' ELSE ',' + MAX([SN87]) END	+ CASE WHEN MAX([SN88]) IS NULL THEN '' ELSE ',' + MAX([SN88]) END
					+ CASE WHEN MAX([SN89]) IS NULL THEN '' ELSE ',' + MAX([SN89]) END	+ CASE WHEN MAX([SN90]) IS NULL THEN '' ELSE ',' + MAX([SN90]) END
					+ CASE WHEN MAX([SN91]) IS NULL THEN '' ELSE ',' + MAX([SN91]) END 	+ CASE WHEN MAX([SN92]) IS NULL THEN '' ELSE ',' + MAX([SN92]) END
					+ CASE WHEN MAX([SN93]) IS NULL THEN '' ELSE ',' + MAX([SN93]) END	+ CASE WHEN MAX([SN94]) IS NULL THEN '' ELSE ',' + MAX([SN94]) END
					+ CASE WHEN MAX([SN95]) IS NULL THEN '' ELSE ',' + MAX([SN95]) END	+ CASE WHEN MAX([SN96]) IS NULL THEN '' ELSE ',' + MAX([SN96]) END
					+ CASE WHEN MAX([SN97]) IS NULL THEN '' ELSE ',' + MAX([SN97]) END	+ CASE WHEN MAX([SN98]) IS NULL THEN '' ELSE ',' + MAX([SN98]) END
					+ CASE WHEN MAX([SN99]) IS NULL THEN '' ELSE ',' + MAX([SN99]) END	+ CASE WHEN MAX([SN100]) IS NULL THEN '' ELSE ',' + MAX([SN100]) END AS SO_NO --[C20210225-000385] SO_NO 추가(','로 구분)
				, ISNULL(MAX([SQ1]),'') + CASE WHEN MAX([SQ2]) IS NULL THEN '' ELSE ',' + MAX([SQ2]) END
					+ CASE WHEN MAX([SQ3]) IS NULL THEN '' ELSE ',' + MAX([SQ3]) END	+ CASE WHEN MAX([SQ4]) IS NULL THEN '' ELSE ',' + MAX([SQ4]) END
					+ CASE WHEN MAX([SQ5]) IS NULL THEN '' ELSE ',' + MAX([SQ5]) END	+ CASE WHEN MAX([SQ6]) IS NULL THEN '' ELSE ',' + MAX([SQ6]) END
					+ CASE WHEN MAX([SQ7]) IS NULL THEN '' ELSE ',' + MAX([SQ7]) END	+ CASE WHEN MAX([SQ8]) IS NULL THEN '' ELSE ',' + MAX([SQ8]) END
					+ CASE WHEN MAX([SQ9]) IS NULL THEN '' ELSE ',' + MAX([SQ9]) END	+ CASE WHEN MAX([SQ10]) IS NULL THEN '' ELSE ',' + MAX([SQ10]) END 
					+ CASE WHEN MAX([SQ11]) IS NULL THEN '' ELSE ',' + MAX([SQ11]) END 	+ CASE WHEN MAX([SQ12]) IS NULL THEN '' ELSE ',' + MAX([SQ12]) END
					+ CASE WHEN MAX([SQ13]) IS NULL THEN '' ELSE ',' + MAX([SQ13]) END	+ CASE WHEN MAX([SQ14]) IS NULL THEN '' ELSE ',' + MAX([SQ14]) END
					+ CASE WHEN MAX([SQ15]) IS NULL THEN '' ELSE ',' + MAX([SQ15]) END	+ CASE WHEN MAX([SQ16]) IS NULL THEN '' ELSE ',' + MAX([SQ16]) END
					+ CASE WHEN MAX([SQ17]) IS NULL THEN '' ELSE ',' + MAX([SQ17]) END	+ CASE WHEN MAX([SQ18]) IS NULL THEN '' ELSE ',' + MAX([SQ18]) END
					+ CASE WHEN MAX([SQ19]) IS NULL THEN '' ELSE ',' + MAX([SQ19]) END	+ CASE WHEN MAX([SQ20]) IS NULL THEN '' ELSE ',' + MAX([SQ20]) END
					+ CASE WHEN MAX([SQ21]) IS NULL THEN '' ELSE ',' + MAX([SQ21]) END 	+ CASE WHEN MAX([SQ22]) IS NULL THEN '' ELSE ',' + MAX([SQ22]) END
					+ CASE WHEN MAX([SQ23]) IS NULL THEN '' ELSE ',' + MAX([SQ23]) END	+ CASE WHEN MAX([SQ24]) IS NULL THEN '' ELSE ',' + MAX([SQ24]) END
					+ CASE WHEN MAX([SQ25]) IS NULL THEN '' ELSE ',' + MAX([SQ25]) END	+ CASE WHEN MAX([SQ26]) IS NULL THEN '' ELSE ',' + MAX([SQ26]) END
					+ CASE WHEN MAX([SQ27]) IS NULL THEN '' ELSE ',' + MAX([SQ27]) END	+ CASE WHEN MAX([SQ28]) IS NULL THEN '' ELSE ',' + MAX([SQ28]) END
					+ CASE WHEN MAX([SQ29]) IS NULL THEN '' ELSE ',' + MAX([SQ29]) END	+ CASE WHEN MAX([SQ30]) IS NULL THEN '' ELSE ',' + MAX([SQ30]) END 
					+ CASE WHEN MAX([SQ31]) IS NULL THEN '' ELSE ',' + MAX([SQ31]) END 	+ CASE WHEN MAX([SQ32]) IS NULL THEN '' ELSE ',' + MAX([SQ32]) END
					+ CASE WHEN MAX([SQ33]) IS NULL THEN '' ELSE ',' + MAX([SQ33]) END	+ CASE WHEN MAX([SQ34]) IS NULL THEN '' ELSE ',' + MAX([SQ34]) END
					+ CASE WHEN MAX([SQ35]) IS NULL THEN '' ELSE ',' + MAX([SQ35]) END	+ CASE WHEN MAX([SQ36]) IS NULL THEN '' ELSE ',' + MAX([SQ36]) END
					+ CASE WHEN MAX([SQ37]) IS NULL THEN '' ELSE ',' + MAX([SQ37]) END	+ CASE WHEN MAX([SQ38]) IS NULL THEN '' ELSE ',' + MAX([SQ38]) END
					+ CASE WHEN MAX([SQ39]) IS NULL THEN '' ELSE ',' + MAX([SQ39]) END	+ CASE WHEN MAX([SQ40]) IS NULL THEN '' ELSE ',' + MAX([SQ40]) END 
					+ CASE WHEN MAX([SQ41]) IS NULL THEN '' ELSE ',' + MAX([SQ41]) END 	+ CASE WHEN MAX([SQ42]) IS NULL THEN '' ELSE ',' + MAX([SQ42]) END
					+ CASE WHEN MAX([SQ43]) IS NULL THEN '' ELSE ',' + MAX([SQ43]) END	+ CASE WHEN MAX([SQ44]) IS NULL THEN '' ELSE ',' + MAX([SQ44]) END
					+ CASE WHEN MAX([SQ45]) IS NULL THEN '' ELSE ',' + MAX([SQ45]) END	+ CASE WHEN MAX([SQ46]) IS NULL THEN '' ELSE ',' + MAX([SQ46]) END
					+ CASE WHEN MAX([SQ47]) IS NULL THEN '' ELSE ',' + MAX([SQ47]) END	+ CASE WHEN MAX([SQ48]) IS NULL THEN '' ELSE ',' + MAX([SQ48]) END
					+ CASE WHEN MAX([SQ49]) IS NULL THEN '' ELSE ',' + MAX([SQ49]) END	+ CASE WHEN MAX([SQ50]) IS NULL THEN '' ELSE ',' + MAX([SQ50]) END 
					+ CASE WHEN MAX([SQ51]) IS NULL THEN '' ELSE ',' + MAX([SQ51]) END 	+ CASE WHEN MAX([SQ52]) IS NULL THEN '' ELSE ',' + MAX([SQ52]) END
					+ CASE WHEN MAX([SQ53]) IS NULL THEN '' ELSE ',' + MAX([SQ53]) END	+ CASE WHEN MAX([SQ54]) IS NULL THEN '' ELSE ',' + MAX([SQ54]) END
					+ CASE WHEN MAX([SQ55]) IS NULL THEN '' ELSE ',' + MAX([SQ55]) END	+ CASE WHEN MAX([SQ56]) IS NULL THEN '' ELSE ',' + MAX([SQ56]) END
					+ CASE WHEN MAX([SQ57]) IS NULL THEN '' ELSE ',' + MAX([SQ57]) END	+ CASE WHEN MAX([SQ58]) IS NULL THEN '' ELSE ',' + MAX([SQ58]) END
					+ CASE WHEN MAX([SQ59]) IS NULL THEN '' ELSE ',' + MAX([SQ59]) END	+ CASE WHEN MAX([SQ60]) IS NULL THEN '' ELSE ',' + MAX([SQ60]) END 
					+ CASE WHEN MAX([SQ61]) IS NULL THEN '' ELSE ',' + MAX([SQ61]) END 	+ CASE WHEN MAX([SQ62]) IS NULL THEN '' ELSE ',' + MAX([SQ62]) END
					+ CASE WHEN MAX([SQ63]) IS NULL THEN '' ELSE ',' + MAX([SQ63]) END	+ CASE WHEN MAX([SQ64]) IS NULL THEN '' ELSE ',' + MAX([SQ64]) END
					+ CASE WHEN MAX([SQ65]) IS NULL THEN '' ELSE ',' + MAX([SQ65]) END	+ CASE WHEN MAX([SQ66]) IS NULL THEN '' ELSE ',' + MAX([SQ66]) END
					+ CASE WHEN MAX([SQ67]) IS NULL THEN '' ELSE ',' + MAX([SQ67]) END	+ CASE WHEN MAX([SQ68]) IS NULL THEN '' ELSE ',' + MAX([SQ68]) END
					+ CASE WHEN MAX([SQ69]) IS NULL THEN '' ELSE ',' + MAX([SQ69]) END	+ CASE WHEN MAX([SQ70]) IS NULL THEN '' ELSE ',' + MAX([SQ70]) END 
					+ CASE WHEN MAX([SQ71]) IS NULL THEN '' ELSE ',' + MAX([SQ71]) END 	+ CASE WHEN MAX([SQ72]) IS NULL THEN '' ELSE ',' + MAX([SQ72]) END
					+ CASE WHEN MAX([SQ73]) IS NULL THEN '' ELSE ',' + MAX([SQ73]) END	+ CASE WHEN MAX([SQ74]) IS NULL THEN '' ELSE ',' + MAX([SQ74]) END
					+ CASE WHEN MAX([SQ75]) IS NULL THEN '' ELSE ',' + MAX([SQ75]) END	+ CASE WHEN MAX([SQ76]) IS NULL THEN '' ELSE ',' + MAX([SQ76]) END
					+ CASE WHEN MAX([SQ77]) IS NULL THEN '' ELSE ',' + MAX([SQ77]) END	+ CASE WHEN MAX([SQ78]) IS NULL THEN '' ELSE ',' + MAX([SQ78]) END
					+ CASE WHEN MAX([SQ79]) IS NULL THEN '' ELSE ',' + MAX([SQ79]) END	+ CASE WHEN MAX([SQ80]) IS NULL THEN '' ELSE ',' + MAX([SQ80]) END 
					+ CASE WHEN MAX([SQ81]) IS NULL THEN '' ELSE ',' + MAX([SQ81]) END 	+ CASE WHEN MAX([SQ82]) IS NULL THEN '' ELSE ',' + MAX([SQ82]) END
					+ CASE WHEN MAX([SQ83]) IS NULL THEN '' ELSE ',' + MAX([SQ83]) END	+ CASE WHEN MAX([SQ84]) IS NULL THEN '' ELSE ',' + MAX([SQ84]) END
					+ CASE WHEN MAX([SQ85]) IS NULL THEN '' ELSE ',' + MAX([SQ85]) END	+ CASE WHEN MAX([SQ86]) IS NULL THEN '' ELSE ',' + MAX([SQ86]) END
					+ CASE WHEN MAX([SQ87]) IS NULL THEN '' ELSE ',' + MAX([SQ87]) END	+ CASE WHEN MAX([SQ88]) IS NULL THEN '' ELSE ',' + MAX([SQ88]) END
					+ CASE WHEN MAX([SQ89]) IS NULL THEN '' ELSE ',' + MAX([SQ89]) END	+ CASE WHEN MAX([SQ90]) IS NULL THEN '' ELSE ',' + MAX([SQ90]) END
					+ CASE WHEN MAX([SQ91]) IS NULL THEN '' ELSE ',' + MAX([SQ91]) END 	+ CASE WHEN MAX([SQ92]) IS NULL THEN '' ELSE ',' + MAX([SQ92]) END
					+ CASE WHEN MAX([SQ93]) IS NULL THEN '' ELSE ',' + MAX([SQ93]) END	+ CASE WHEN MAX([SQ94]) IS NULL THEN '' ELSE ',' + MAX([SQ94]) END
					+ CASE WHEN MAX([SQ95]) IS NULL THEN '' ELSE ',' + MAX([SQ95]) END	+ CASE WHEN MAX([SQ96]) IS NULL THEN '' ELSE ',' + MAX([SQ96]) END
					+ CASE WHEN MAX([SQ97]) IS NULL THEN '' ELSE ',' + MAX([SQ97]) END	+ CASE WHEN MAX([SQ98]) IS NULL THEN '' ELSE ',' + MAX([SQ98]) END
					+ CASE WHEN MAX([SQ99]) IS NULL THEN '' ELSE ',' + MAX([SQ99]) END	+ CASE WHEN MAX([SQ100]) IS NULL THEN '' ELSE ',' + MAX([SQ100]) END AS SO_QTY --[C20210225-000385] SO_QTY 추가(','로 구분)	
					*/					
					--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 END
			FROM #DM_DNM_SALES_RESULT_BEFORE A WITH(NOLOCK)
			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 START			 
			LEFT OUTER JOIN (
								SELECT DIVISION_ID, COMPANY_ID, SCM_SITE_ID
								FROM SCM_MST_SITE WITH(NOLOCK)
								WHERE SITE_TYPE			= 'PLANT'
								AND   OPERATION_GROUP	= 'A'	
								AND   VALID_YN			= 'Y'
			) B
			ON    A.DIVISION_ID = B.DIVISION_ID
			AND   A.FROM_COMPANY_ID = B.COMPANY_ID  
			LEFT OUTER JOIN (
					SELECT DISTINCT ITEM_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (CELL ITEM_ID 만 추출하여 활용)
					FROM SCM_ITEM_M_SN WITH(NOLOCK)
					WHERE DIVISION_ID			= '40' 
					AND  FORECAST_INFO_BIZ_TYPE = 'CELL'
					AND  ACTIVE_FLAG			= 'Y'
			) C
			ON A.ITEM_ID	= C.ITEM_ID
			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 END			 
			/*
			(
				/* [E20240415-000036]_SCM시스템의 사내간 거래 매출 실적 인식을 위한 신규개발/기능변경  
				   - 예외캐이스 처리 룩업(DM_EXCEPT_SALES_SITE_MAPPING)추가 , 실적집계프로그램 상 예외처리 프로세스 반영 (AND ISNULL(C.SEGMENT4,'') = ''  조건 추가) */
				SELECT 
					DIVISION_ID,PROJECT_CODE,CASE WHEN len(soldto_code) = 4 AND ISNULL(C.SEGMENT4,'') = '' THEN CASE WHEN soldto_code = 'B100' THEN 'C100' ELSE soldto_code END ELSE SALES_SITE_ID END SALES_SITE_ID
					,ISNULL(PLANT_SITE_ID, '')	 PLANT_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,YYYYMMDD
					,SUM(CASE WHEN ISNULL(B.SEGMENT4,'') = 'Y' THEN 0 ELSE QTY END ) AS QTY
					,MAX(A.CREATED_BY) AS CREATED_BY,MAX(A.CREATION_DATE)	AS CREATION_DATE,MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY,MAX(A.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
					,MAX(A.ATTRIBUTE1) AS ATTRIBUTE1
					,SUM(CASE WHEN ISNULL(B.SEGMENT4,'') = 'Y' THEN QTY ELSE 0 END ) AS INTERNAL_QTY
					,SUM(A.ATTRIBUTE3) AS ATTRIBUTE3, MAX(A.ATTRIBUTE4) AS ATTRIBUTE4 -- 2020.12.01
					, B.SEGMENT4 AS DM_ESS_RESULT_MAP, SO_NO, SO_QTY --[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)		
					--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 START
					/*					
					, 'SN' + CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID,PROJECT_CODE,CASE WHEN len(soldto_code) = 4 AND ISNULL(C.SEGMENT4,'') = ''  THEN CASE WHEN soldto_code = 'B100' THEN 'C100' ELSE soldto_code END ELSE SALES_SITE_ID END
													 ,ISNULL(PLANT_SITE_ID, '')	,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,YYYYMMDD ORDER BY SO_NO) AS NVARCHAR(10)) AS SO_NO_ROW_NUM --[C20210225-000385] SO_NO Rownum 추가
					
					, 'SQ' + CAST(ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID,PROJECT_CODE,CASE WHEN len(soldto_code) = 4 AND ISNULL(C.SEGMENT4,'') = ''  THEN CASE WHEN soldto_code = 'B100' THEN 'C100' ELSE soldto_code END ELSE SALES_SITE_ID END
													 ,ISNULL(PLANT_SITE_ID, '')	,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,YYYYMMDD ORDER BY SO_NO) AS NVARCHAR(10)) AS SO_QTY_ROW_NUM --[C20210225-000385] SO_QTY Rownum 추가
					*/
					--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 END
				FROM #DM_DNM_SALES_RESULT A WITH  (NOLOCK)  --20180911 KHSONG 대상테이블 변경 DM_DNM_SALES_RESULT -> DM_DNM_SALES_RESULT_IF
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.INTERNAL_TYPE = B.ATTRIBUTE1 AND B.LOOKUP_TYPE = 'DM_ESS_RESULT_MAP'
				/* [E20240415-000036] : 예외캐이스 룩업 정보 (SEGMENT4 : SALES_SITE_ID) */
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C ON C.LOOKUP_TYPE = 'DM_EXCEPT_SALES_SITE_MAPPING' AND C.SEGMENT1 = A.DIVISION_ID AND C.SEGMENT2 = A.SOLDTO_CODE AND C.SEGMENT3 = A.SHIPTO_CODE
				WHERE	DIVISION_ID   IN  (SELECT DIVISION_ID FROM #i_division)
					AND	MEASURE   = 'SALES_RESULT'	-- 확인해야하는값
					AND YYYYMMDD <  @v_end_yyyymmdd    -- 당일 (yyyymmdd)
					AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
					AND ISNULL(B.SEGMENT4, 'Y') <> 'N'
				GROUP BY DIVISION_ID,PROJECT_CODE,CASE WHEN len(soldto_code) = 4 AND ISNULL(C.SEGMENT4,'') = '' THEN CASE WHEN soldto_code = 'B100' THEN 'C100' ELSE soldto_code END ELSE SALES_SITE_ID END
					,PLANT_SITE_ID ,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,YYYYMMDD
					, B.SEGMENT4, SO_NO, SO_QTY --[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)
			) A	*/
		--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 START
		/*
		PIVOT (
			MAX(SO_NO) FOR SO_NO_ROW_NUM IN ( [SN1], [SN2], [SN3], [SN4], [SN5], [SN6], [SN7], [SN8], [SN9], [SN10] ,[SN11], [SN12], [SN13], [SN14], [SN15], [SN16], [SN17], [SN18], [SN19], [SN20]
										,[SN21], [SN22], [SN23], [SN24], [SN25], [SN26], [SN27], [SN28], [SN29], [SN30],[SN31], [SN32], [SN33], [SN34], [SN35], [SN36], [SN37], [SN38], [SN39], [SN40]
										,[SN41], [SN42], [SN43], [SN44], [SN45], [SN46], [SN47], [SN48], [SN49], [SN50],[SN51], [SN52], [SN53], [SN54], [SN55], [SN56], [SN57], [SN58], [SN59], [SN60]
										,[SN61], [SN62], [SN63], [SN64], [SN65], [SN66], [SN67], [SN68], [SN69], [SN70],[SN71], [SN72], [SN73], [SN74], [SN75], [SN76], [SN77], [SN78], [SN79], [SN80]
										,[SN81], [SN82], [SN83], [SN84], [SN85], [SN86], [SN87], [SN88], [SN89], [SN90],[SN91], [SN92], [SN93], [SN94], [SN95], [SN96], [SN97], [SN98], [SN99], [SN100]  )
			) AS PVT1 --[C20210225-000385] Key 값 기준으로 최대 100개 SO_NO를 갖을 수 있음
		PIVOT (
			MAX(SO_QTY) FOR SO_QTY_ROW_NUM IN ( [SQ1], [SQ2], [SQ3], [SQ4], [SQ5], [SQ6], [SQ7], [SQ8], [SQ9], [SQ10] ,[SQ11], [SQ12], [SQ13], [SQ14], [SQ15], [SQ16], [SQ17], [SQ18], [SQ19], [SQ20]
										,[SQ21], [SQ22], [SQ23], [SQ24], [SQ25], [SQ26], [SQ27], [SQ28], [SQ29], [SQ30],[SQ31], [SQ32], [SQ33], [SQ34], [SQ35], [SQ36], [SQ37], [SQ38], [SQ39], [SQ40]
										,[SQ41], [SQ42], [SQ43], [SQ44], [SQ45], [SQ46], [SQ47], [SQ48], [SQ49], [SQ50],[SQ51], [SQ52], [SQ53], [SQ54], [SQ55], [SQ56], [SQ57], [SQ58], [SQ59], [SQ60]
										,[SQ61], [SQ62], [SQ63], [SQ64], [SQ65], [SQ66], [SQ67], [SQ68], [SQ69], [SQ70],[SQ71], [SQ72], [SQ73], [SQ74], [SQ75], [SQ76], [SQ77], [SQ78], [SQ79], [SQ80]
										,[SQ81], [SQ82], [SQ83], [SQ84], [SQ85], [SQ86], [SQ87], [SQ88], [SQ89], [SQ90],[SQ91], [SQ92], [SQ93], [SQ94], [SQ95], [SQ96], [SQ97], [SQ98], [SQ99], [SQ100]  )
			) AS PVT2  --[C20210225-000385] Key 값 기준으로 최대 100개 SO_QTY를 갖을 수 있음	
		*/
		--[E20250213-001224]_N-ERP ZSDOMR5070 ↔ SCM 출하 실적 불일치 END
		GROUP BY A.DIVISION_ID,PROJECT_CODE,SALES_SITE_ID,PLANT_SITE_ID,A.ITEM_ID,DOM_EXP,ISNULL(FCST_TYPE,'MASS')
				,INCOTERMS,YYYYMMDD
				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 START			 
				, CASE WHEN (A.DIVISION_ID = '40' AND ISNULL(A.FROM_COMPANY_ID, '') != '' AND A.ITEM_ID = ISNULL(C.ITEM_ID, '') ) THEN ISNULL(B.SCM_SITE_ID, '-')
						WHEN (A.DIVISION_ID = '40' AND ISNULL(A.FROM_COMPANY_ID, '') = '' AND A.ITEM_ID = ISNULL(C.ITEM_ID, '') ) THEN DBO.FN_SCM_SYS_NVL(DBO.FN_GET_SCM_SITE_ID_PLANT(A.plant_id, DBO.FN_GET_ITEM_OPERATION_GROUP(A.division_id, A.item_id)),'-')  	
						ELSE '-'					END 
				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 END		


			-- [PJ2025-50188] 환율반영한 SALES_AMT_KRW / MKT_AMT_KRW 생성 로직
			------------------------------------------------------------------------
			-- ERP 인터페이스 부분
			-- 전 사업부 : ERP로부터 받는 SalesAmt_KRW / MKT_AMT_KRW (1달전 1일 ~ 당일) 삭제 및 ERP 데이터 INSERT

			-- 40 사업부 로직추가
			-- ERP 데이터 COPY (1달전 1일 ~ 당일) : SalesAmt_KRW ==> SalesAmt_KRW_KRW 복사 / MKT_AMT_KRW ==> MKT_AMT_KRW_ERP 복사 
			-- 환율 재계산하여 SalesAmt_KRW / MKT_AMT_KRW DELETE/INSERT 처리 (당월 1일 ~ 당일)
			------------------------------------------------------------------------
			DELETE 
			FROM	dbo.DM_PLN_SALES_PLAN_RESULT
			WHERE	MEASURE in (
					'RTF',
					'SalesAmt_LOC',
					'SalesAmt_KRW',
					'MKT_AMT_LOC',
					'MKT_AMT_KRW',
					'SalesAmt_KRW_ERP',		-- [PJ2025-50188] 환율반영한 SALES_AMT_KRW / MKT_AMT_KRW 생성. 40사업부에 한해서 ERP에서 받은 데이터를 저장함 
					'MKT_AMT_KRW_ERP'		-- [PJ2025-50188] 환율반영한 SALES_AMT_KRW / MKT_AMT_KRW 생성. 40사업부에 한해서 ERP에서 받은 데이터를 저장함
					)
			AND YYYYMMDD < @v_end_yyyymmdd     -- 당일 (yyyymmdd) / [PJ2025-50188] 당일은 제외되어야 함.
			AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
			AND DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)
			;

			INSERT dbo.DM_PLN_SALES_PLAN_RESULT
				( DIVISION_ID,COMPANY_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
				,INCOTERMS,MEASURE,YYYYMMDD,CURRENCY,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
				,ATTRIBUTE1,ATTRIBUTE2
				,CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				)
			SELECT A.DIVISION_ID,A.COMPANY_ID,A.PROJECT_CODE,A.SCM_SITE_ID,ISNULL(PLANT_SITE_ID, '') AS PLANT_SITE_ID,A.ITEM_ID,A.DOM_EXP
				,ISNULL(A.FCST_TYPE,'MASS') AS FCST_TYPE,A.INCOTERMS,A.MEASURE AS  MEASURE,A.YYYYMMDD,A.CURRENCY,A.QTY
				,A.CREATED_BY,A.CREATION_DATE,A.LAST_UPDATED_BY,GETDATE() AS LAST_UPDATE_DATE,A.ATTRIBUTE1,A.INTERNAL_QTY
				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 START			 
				, CASE WHEN (A.DIVISION_ID = '40' AND ISNULL(A.FROM_COMPANY_ID, '') != '' AND A.ITEM_ID = ISNULL(C.ITEM_ID, '')) THEN ISNULL(B.SCM_SITE_ID, '-')
						WHEN (A.DIVISION_ID = '40' AND ISNULL(A.FROM_COMPANY_ID, '') = '' AND A.ITEM_ID = ISNULL(C.ITEM_ID, '')) THEN DBO.FN_SCM_SYS_NVL(DBO.FN_GET_SCM_SITE_ID_PLANT(A.plant_id, DBO.FN_GET_ITEM_OPERATION_GROUP(A.division_id, A.item_id)),'-')  	
						ELSE '-'					END AS CELL_PROD_SITE_ID
				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 END		
			FROM
			(
				/* [E20240415-000036]_SCM시스템의 사내간 거래 매출 실적 인식을 위한 신규개발/기능변경  
				   - 예외캐이스 처리 룩업(DM_EXCEPT_SALES_SITE_MAPPING)추가 , 실적집계프로그램 상 예외처리 프로세스 반영 (AND ISNULL(C.SEGMENT4,'') = ''  조건 추가) */
				SELECT DIVISION_ID,COMPANY_ID,PROJECT_CODE,CASE WHEN len(soldto_code) = 4 AND ISNULL(C.SEGMENT4,'') = ''  THEN CASE WHEN soldto_code = 'B100' THEN 'C100' ELSE soldto_code END ELSE SALES_SITE_ID END AS SCM_SITE_ID
					,PLANT_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
					,CASE MEASURE
						WHEN 'SALES_RESULT'             THEN 'RTF'
						WHEN 'SALES_RESULT_AMOUNT'      THEN 'SalesAmt_LOC'
						WHEN 'SALES_RESULT_AMOUNT_KRW'  THEN 'SalesAmt_KRW' 			
					ELSE 
						MEASURE
					END AS MEASURE
					,YYYYMMDD,CURRENCY
					,SUM(CASE WHEN ISNULL(B.SEGMENT4,'') = 'Y' THEN 0 ELSE QTY END ) AS QTY
					,MAX(A.CREATED_BY) AS CREATED_BY,MAX(A.CREATION_DATE) AS CREATION_DATE,MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
					,MAX(A.ATTRIBUTE1) AS ATTRIBUTE1
					,SUM(CASE WHEN ISNULL(B.SEGMENT4,'') = 'Y' THEN QTY ELSE 0 END ) AS INTERNAL_QTY
					,FROM_COMPANY_ID, PLANT_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				FROM #DM_DNM_SALES_RESULT A WITH  (NOLOCK) --20180911 KHSONG 대상테이블 변경 DM_DNM_SALES_RESULT -> DM_DNM_SALES_RESULT_IF  
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.INTERNAL_TYPE = B.ATTRIBUTE1 AND B.LOOKUP_TYPE = 'DM_ESS_RESULT_MAP'
				/* [E20240415-000036] : 예외캐이스 룩업 정보 (SEGMENT4 : SALES_SITE_ID) */
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK) ON C.LOOKUP_TYPE = 'DM_EXCEPT_SALES_SITE_MAPPING' AND C.SEGMENT1 = A.DIVISION_ID AND C.SEGMENT2 = A.SOLDTO_CODE AND C.SEGMENT3 = A.SHIPTO_CODE
				WHERE DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)
					AND MEASURE in (
					'SALES_RESULT'
					,'SALES_RESULT_AMOUNT'
					,'SALES_RESULT_AMOUNT_KRW'
					)
					-- 확인해야하는값
					AND YYYYMMDD < @v_end_yyyymmdd     -- 당일 (yyyymmdd) / [PJ2025-50188] 당일은 제외되어야 함.
					AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
					AND ISNULL(B.SEGMENT4, 'Y') <> 'N'
				GROUP BY DIVISION_ID,COMPANY_ID,PROJECT_CODE,CASE WHEN len(soldto_code) = 4 AND ISNULL(C.SEGMENT4,'') = ''  THEN CASE WHEN soldto_code = 'B100' THEN 'C100' ELSE soldto_code END ELSE SALES_SITE_ID END
					,PLANT_SITE_ID ,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,YYYYMMDD,CURRENCY        
					,FROM_COMPANY_ID, PLANT_ID 				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				
				UNION ALL
				
				SELECT DIVISION_ID,COMPANY_ID,PROJECT_CODE,CASE WHEN len(soldto_code) = 4 AND ISNULL(C.SEGMENT4,'') = ''  THEN CASE WHEN soldto_code = 'B100' THEN 'C100' ELSE soldto_code END ELSE SALES_SITE_ID END AS SCM_SITE_ID
					,PLANT_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
					,CASE MEASURE
						WHEN 'SALES_RESULT_AMOUNT'      THEN 'MKT_AMT_LOC'
						WHEN 'SALES_RESULT_AMOUNT_KRW'  THEN 'MKT_AMT_KRW' 
					END AS MEASURE
					,YYYYMMDD,CURRENCY
					,SUM(CASE WHEN ISNULL(B.SEGMENT4,'') = 'Y' THEN 0 ELSE QTY END ) AS QTY
					,MAX(A.CREATED_BY) AS CREATED_BY,MAX(A.CREATION_DATE) AS CREATION_DATE,MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
					,MAX(A.ATTRIBUTE1) AS ATTRIBUTE1
					,SUM(CASE WHEN ISNULL(B.SEGMENT4,'') = 'Y' THEN QTY ELSE 0 END ) AS INTERNAL_QTY
					,FROM_COMPANY_ID, PLANT_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				FROM #DM_DNM_SALES_RESULT A WITH  (NOLOCK) --20180911 KHSONG 대상테이블 변경 DM_DNM_SALES_RESULT -> DM_DNM_SALES_RESULT_IF  
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.INTERNAL_TYPE = B.ATTRIBUTE1 AND B.LOOKUP_TYPE = 'DM_ESS_RESULT_MAP'
				/* [E20240415-000036] : 예외캐이스 룩업 정보 (SEGMENT4 : SALES_SITE_ID) */
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK) ON C.LOOKUP_TYPE = 'DM_EXCEPT_SALES_SITE_MAPPING' AND C.SEGMENT1 = A.DIVISION_ID AND C.SEGMENT2 = A.SOLDTO_CODE AND C.SEGMENT3 = A.SHIPTO_CODE
				WHERE DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)
					--AND DIVISION_ID = '40'	[C20210629-000239]
					AND MEASURE in (
					'SALES_RESULT_AMOUNT'
					,'SALES_RESULT_AMOUNT_KRW'
					)
					-- 확인해야하는값
					AND YYYYMMDD < @v_end_yyyymmdd     -- 당일 (yyyymmdd) / [PJ2025-50188] 당일은 제외되어야 함.	
					AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
					AND ISNULL(B.SEGMENT4, 'Y') <> 'N'
				GROUP BY DIVISION_ID,COMPANY_ID,PROJECT_CODE,CASE WHEN len(soldto_code) = 4 AND ISNULL(C.SEGMENT4,'') = ''  THEN CASE WHEN soldto_code = 'B100' THEN 'C100' ELSE soldto_code END ELSE SALES_SITE_ID END
					,PLANT_SITE_ID ,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,YYYYMMDD,CURRENCY   
					,FROM_COMPANY_ID, PLANT_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			) A  
			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 START			 
			LEFT OUTER JOIN (
								SELECT DIVISION_ID, COMPANY_ID, SCM_SITE_ID
								FROM SCM_MST_SITE  WITH(NOLOCK)
								WHERE SITE_TYPE			= 'PLANT'
								AND   OPERATION_GROUP	= 'A'	
								AND   VALID_YN			= 'Y'
			) B
			ON    A.DIVISION_ID = B.DIVISION_ID
			AND   A.FROM_COMPANY_ID = B.COMPANY_ID  
			LEFT OUTER JOIN (
					SELECT DISTINCT ITEM_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (CELL ITEM_ID 만 추출하여 활용)
					FROM SCM_ITEM_M_SN 
					WHERE DIVISION_ID			= '40' 
					AND  FORECAST_INFO_BIZ_TYPE = 'CELL'
					AND  ACTIVE_FLAG			= 'Y'
			) C
			ON    A.ITEM_ID = C.ITEM_ID
			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 END		 

			-- [PJ2025-50188] 환율반영한 SALES_AMT_KRW 생성 Start (40사업부에 한해서만 진행)
			-- [PJ2025-50188] COPY (SalesAmt_KRW ==> SalesAmt_KRW_ERP / MKT_AMT_KRW ==> MKT_AMT_KRW_ERP) : 1달전 1일 ~ 당일

			INSERT INTO dbo.DM_PLN_SALES_PLAN_RESULT
			(		DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP ,FCST_TYPE, INCOTERMS
				  , MEASURE
				  , PLANT_SITE_ID, YYYYMMDD
				  , CURRENCY, QTY, CREATED_BY, CREATION_DATE ,LAST_UPDATED_BY, LAST_UPDATE_DATE
				  , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
				  , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				  , COMPANY_ID
				  , CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			)
			SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP ,FCST_TYPE, INCOTERMS
				  , MEASURE + '_ERP'			AS MEASURE
				  , PLANT_SITE_ID, YYYYMMDD
				  , CURRENCY, QTY, CREATED_BY, CREATION_DATE ,LAST_UPDATED_BY, LAST_UPDATE_DATE
				  , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
				  , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
				  , COMPANY_ID
				  , CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			FROM	dbo.DM_PLN_SALES_PLAN_RESULT WITH(NOLOCK)
			WHERE	MEASURE in ('SalesAmt_KRW',	'MKT_AMT_KRW')
			AND YYYYMMDD < @v_end_yyyymmdd     -- 당일 (yyyymmdd) / [PJ2025-50188] 당일은 제외되어야 함.
			AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
			AND DIVISION_ID IN ('40')		-- [PJ2025-50188] 40 사업부만 진행함.
			AND DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)		-- [PJ2025-50188] 환율반영한 SALES_AMT_KRW / MKT_AMT_KRW 생성 보완 - 40사업부가 포함되지 않는 처리시 DUP ERROR 보완 (조건절에 반영)
			;


			-- [PJ2025-50188] 환율고려하여 SalesAmt_KRW/MKT_AMT_KRW 재계산 : 당월 1일 ~ 당일
			DELETE 
			FROM	dbo.DM_PLN_SALES_PLAN_RESULT
			WHERE	MEASURE in (
					'SalesAmt_KRW',
					'MKT_AMT_KRW'
					)
			AND YYYYMMDD >= @v_start_yyyymmdd_exchange		-- 당월 1일 (yyyymmdd)
			AND YYYYMMDD < @v_end_yyyymmdd					-- 당일 (yyyymmdd) / [PJ2025-50188] 당일은 제외되어야 함.
			AND DIVISION_ID IN ('40')		-- [PJ2025-50188] 40 사업부만 진행함.
			AND DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)		-- [PJ2025-50188] 환율반영한 SALES_AMT_KRW / MKT_AMT_KRW 생성 보완 - 40사업부가 포함되지 않는 처리시 DUP ERROR 보완 (조건절에 반영)
			;
	
			INSERT dbo.DM_PLN_SALES_PLAN_RESULT
				( DIVISION_ID,COMPANY_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
				,INCOTERMS
				,MEASURE
				,YYYYMMDD,CURRENCY
				,QTY
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
				,ATTRIBUTE1,ATTRIBUTE2
				, CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				)
			SELECT A.DIVISION_ID, A.COMPANY_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
				, A.INCOTERMS
				, C.MEASURE						-- [PJ2025-50188] SalesAmt_LOC*QTY ==> MKT_AMT_KRW / SalesAmt_KRW 생성함.	SalesAmt_LOC와 MKT_AMT_LOC 값은 동일하므로 SalesAmt_LOC 데이터 기반으로 생성함.
				, A.YYYYMMDD, A.CURRENCY
				, A.QTY * B.EXCHANGE_PRICE				AS QTY		-- [PJ2025-50188] 주의. A.QTY에는 (수량*단가)이므로 환율만 고려하면 됨.
				, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
				, A.ATTRIBUTE1,A.ATTRIBUTE2
				, A.CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			FROM dbo.DM_PLN_SALES_PLAN_RESULT A WITH(NOLOCK)
			INNER JOIN DM_MST_EXCHANGE_RATE B WITH(NOLOCK)
			ON	A.DIVISION_ID	= B.DIVISION_ID
			AND	SUBSTRING(A.YYYYMMDD,1,6) + '01'= B.YYYYMMDD		-- EXCHANGE는 월별로 1일에 데이터가 있음 
			AND	A.CURRENCY		= B.UNIT_CURRENCY
			AND B.CURRENCY		= 'KRW'
			INNER JOIN (SELECT 'MKT_AMT_KRW' AS MEASURE UNION ALL SELECT 'SalesAmt_KRW' AS MEASURE ) C
			ON 1=1
			WHERE A.DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)		-- [PJ2025-50188] 환율반영한 SALES_AMT_KRW / MKT_AMT_KRW 생성 보완 - 40사업부가 포함되지 않는 처리시 DUP ERROR 보완 (조건절에 반영)
			AND A.DIVISION_ID IN ('40')		-- [PJ2025-50188] 40 사업부만 진행함.
			AND A.MEASURE = 'SalesAmt_LOC'
			AND A.YYYYMMDD >= @v_start_yyyymmdd_exchange		-- 당월 1일 (yyyymmdd)
			AND A.YYYYMMDD < @v_end_yyyymmdd					-- 당일 (yyyymmdd) / [PJ2025-50188] 당일은 제외되어야 함.
			
			-- [PJ2025-50188] 환율반영한 SALES_AMT_KRW 생성 End (40사업부에 한해서만 진행)
			
	print 'step-4'
			---------------------------------------------------------------------------------------- 20190725 CSR ID:4048421 KHSONG 실적생성시 RTF_SystemR+P MEASURE를 추가생성함(START)
			DELETE
			  FROM	dbo.DM_PLN_MKT_FCST_RESULT
			 WHERE	MEASURE   = 'RTF_SYS_RP'
				AND YYYYMMDD <  @v_end_yyyymmdd    -- 당일 (yyyymmdd) / [PJ2025-50188] 당일은 제외되어야 함.
				AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
			    AND DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)
			    --AND DIVISION_ID IN ('40','81')  -- 현재 소형과 자동차 사업부만 생성함  -- 20200416 KHSONG C20200413-000593 주석처리 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨
				;
			INSERT INTO dbo.DM_PLN_MKT_FCST_RESULT (
				DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE, ATTRIBUTE2
				, ATTRIBUTE3, ATTRIBUTE4 -- 2020.12.01
				,SO_NO, SO_QTY --[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)
				, A.CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				)
			SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,'RTF_SYS_RP' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE, ATTRIBUTE2
				, ATTRIBUTE3, ATTRIBUTE4 -- 2020.12.01
				,SO_NO, SO_QTY --[C20210225-000385] SO_NO, SO_QTY 추가(','로 구분)
				, CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			  FROM dbo.DM_PLN_MKT_FCST_RESULT WITH(NOLOCK)
				WHERE	MEASURE = 'RTF'
				AND YYYYMMDD <  @v_end_yyyymmdd    -- 당일 (yyyymmdd)
				AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
				AND DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)
			    --AND DIVISION_ID IN ('40','81')  -- 현재 소형과 자동차 사업부만 생성함 -- 20200416 KHSONG C20200413-000593 주석처리 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨
				;
			DELETE 
				FROM	dbo.DM_PLN_SALES_PLAN_RESULT
				WHERE	MEASURE = 'RTF_SYS_RP'
				AND YYYYMMDD <  @v_end_yyyymmdd    -- 당일 (yyyymmdd)
				AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
				AND DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)
			    --AND DIVISION_ID IN ('40','81')  -- 현재 소형과 자동차 사업부만 생성함 -- 20200416 KHSONG C20200413-000593 주석처리 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨
				;

			INSERT INTO dbo.DM_PLN_SALES_PLAN_RESULT (
				DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE, COMPANY_ID, ATTRIBUTE2
				,CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				)
			SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,'RTF_SYS_RP' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY
				,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE, ISNULL(COMPANY_ID, ''), ATTRIBUTE2
				,CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			  FROM dbo.DM_PLN_SALES_PLAN_RESULT WITH(NOLOCK)
				WHERE	MEASURE = 'RTF'
				AND YYYYMMDD <  @v_end_yyyymmdd    -- 당일 (yyyymmdd)
				AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
				AND DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)
			    --AND DIVISION_ID IN ('40','81')  -- 현재 소형과 자동차 사업부만 생성함 -- 20200416 KHSONG C20200413-000593 주석처리 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨
				;
			---------------------------------------------------------------------------------------- 20190725 CSR ID:4048421 KHSONG 실적생성시 RTF_SystemR+P MEASURE를 추가생성함(END)

-----------------------------------------------------------------------------------------------------	AS 재고 및 입출고 실적 적용	[PJ20209643] --------------------------------------------------------------

	print 'step-5'

			-- TEMP테이블 확인후 초기화
			IF OBJECT_ID (N'tempdb..#AS_tmpData', N'U') IS NOT NULL 
				DROP TABLE #AS_tmpData
				;
			CREATE TABLE #AS_tmpData  (
					 division_id      NVARCHAR(30) NOT NULL
					--,company_id	      NVARCHAR(30) NOT NULL
					,project_code     NVARCHAR(50) NOT NULL
					,scm_site_id      NVARCHAR(30) NOT NULL
					,item_id          NVARCHAR(50) NOT NULL
					,dom_exp          NVARCHAR(03) NOT NULL
					,fcst_type        NVARCHAR(20) NOT NULL
					,incoterms        NVARCHAR(10) NOT NULL
					,measure          NVARCHAR(50) NOT NULL
					,plant_site_id    NVARCHAR(30) NOT NULL
					,CELL_PROD_SITE_ID NVARCHAR(30) NOT NULL		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					,yyyymmdd         NVARCHAR(08) NOT NULL
					,qty              NUMERIC(20,10) NOT NULL
								   )
		   ;


			with AS_inv_data as 
				(
				SELECT mf.division_id, mf.SCM_SITE_ID, mf.item_id, mf.project_code, mf.fcst_type, mf.incoterms, mf.dom_exp 
					, convert( varchar, dateadd(D,-1,s.cutoff_date) ,112) yyyymmdd ,  SUM(s.qty) qty 
					FROM (	SELECT S.DIVISION_ID, S.STORAGE_ID, S.ITEM_ID, S.QTY, S.CUTOFF_DATE, '' AS PLANT_ID
							FROM SCM_DNM_STOCK_SN S WITH(NOLOCK)  -- 운영
							WHERE CUTOFF_DATE >= @V_START_YYYYMMDD
							UNION ALL	-- [C20201103-000114]
							SELECT S.DIVISION_ID, S.STORAGE_ID, S.ITEM_ID, S.QTY, S.RESULT_DATE, S.PLANT_ID
							FROM SCM_DNM_STOCK_SALES S WITH(NOLOCK)
							WHERE S.RESULT_DATE >= @V_START_YYYYMMDD
								AND S.DIVISION_ID = '82'
						) s
						,scm_mst_location l		with(nolock)
						,scm_mst_site m			with(nolock)
						,scm_mst_site_item si	with(nolock)
						,(
							select a.division_id, a.scm_site_id, item_id, project_code, fcst_type, incoterms, dom_exp
							     , row_number() over ( partition by a.division_id, a.scm_site_id, item_id order by yyyymmdd desc) row_nums --[C20210120-000090] VMI_Inv 의 Incoterms 는 MKT_FCST에 마지막으로 등록된 순으로 적용(order by yyyymmdd desc)
								from dm_pln_mkt_fcst a with(nolock)
								    ,scm_mst_site b with(nolock)
									where a.DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)
										and a.qty > 0 
										and a.division_id = b.division_id
										and a.scm_site_id = b.scm_site_id
										and b.OPERATION_GROUP = 'W'
						) mf
						
					where l.division_id = s.division_id
					  and l.storage_id	= s.storage_id
					  AND L.PLANT_ID = CASE WHEN S.PLANT_ID = '' THEN L.PLANT_ID ELSE S.PLANT_ID END 
					  and l.SCM_SITE_ID	= m.scm_site_id
					  and l.VALID_YN = 'Y'  -- 20190809 KHSONG CSR ID:4059971 VMI-In Request 로직 변경
					  and m.site_type	= 'SALES'
					  and m.OPERATION_GROUP = 'W'
					  AND m.DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)
					  and si.item_id like  (case when substring(s.item_id, 1,2) = 'MP' THEN substring( s.item_id, 1,11) ELSE s.item_id END ) +'%' 
					  and l.DIVISION_ID	= si.DIVISION_ID
					  and si.VALID_YN	= 'Y'
					  and l.division_id	= mf.division_id 
					  and l.scm_site_id	= mf.scm_site_id
					  and si.item_id	= mf.item_id
					  and mf.row_nums   = 1

						-- added by ytchoi 180813
						and mf.PROJECT_CODE = si.PROJECT_CODE
						and mf.SCM_SITE_ID   = si.SCM_SITE_ID

				group by mf.division_id, mf.SCM_SITE_ID, mf.item_id, mf.project_code, mf.fcst_type, mf.incoterms, mf.dom_exp , convert( varchar, dateadd(D,-1,s.cutoff_date) ,112)
				)

				-- AS_Inv TEMP테이블에 INSERT
				INSERT INTO #AS_tmpData  
				select DIVISION_ID, PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,'AS_Inv' MEASURE,'' PLANT_SITE_ID
					  ,'-'					AS CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가. / INV는 CELL_PROD_SITE_ID와 무관. 여러 CELL_PROD_SITE_ID와 섞여있음.
					  ,YYYYMMDD,QTY
					from AS_inv_data WITH(NOLOCK)
						where qty <> 0 
							AND YYYYMMDD < @v_end_yyyymmdd     -- 당일 (yyyymmdd)
							AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
							AND PROJECT_CODE NOT LIKE N'%개발%'		-- [C20210831-000303] GSCM VMI in 수요 없는 실적 발생시 Sales Site Project Model 참조 로직 수정 요청
				;

				-- 대상추출 입고정보 AS_In_Plan, AS_In_Req -- 시작
				-- [C20221118-000024][SCM PI] GSCM 시스템의 AS 입고 실적 집계를 위한 기능 변경 건
				--[E20251029-000956]_소스 라인정리 (START)
				WITH CTE_DOM_T 
				AS ( /* DOM_EXP를 가져오기 위해서 DM_PLN_MKT_FCST 테이블에서	YYYYMMDD가 당주 월요일 이후의 정보들을 조회한다. */
					 SELECT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CASE	WHEN COUNT(DOM_EXP) > 1 THEN 'E' ELSE DOM_EXP END DOM_EXP 
					   FROM ( SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, A.DOM_EXP
							   FROM DM_PLN_MKT_FCST A WITH(NOLOCK)
							  INNER JOIN (	SELECT DIVISION_ID, SCM_SITE_ID
											 FROM SCM_MST_SITE WITH(NOLOCK)    
											WHERE VALID_YN		 = 'Y'    
											  AND SITE_TYPE		 = 'SALES'    
											  AND OPERATION_GROUP	 = 'W' ) B
									  ON A.DIVISION_ID IN ( SELECT DIVISION_ID FROM #i_division WITH(NOLOCK) ) 
									 AND A.DIVISION_ID	= B.DIVISION_ID
									 AND A.SCM_SITE_ID	= B.SCM_SITE_ID
									 AND A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(cast(@v_end_yyyymmdd as datetime), 'MON')), 112) -- 당주 월요일 이후 (계획 구간) 
							  GROUP BY A.DIVISION_ID, A.ITEM_ID, A.PROJECT_CODE, A.DOM_EXP, A.SCM_SITE_ID, A.DOM_EXP ) C
					 GROUP BY DIVISION_ID, ITEM_ID, PROJECT_CODE, DOM_EXP, SCM_SITE_ID
				), CTE_AS_TEMP_DATA 
				AS ( --[E20251029-000956]_PROJECT_CODE 처리방식을 변경한 후 해당 작업으로 진행한 후에도 NULL값인 데이터는 적재하지 않도록 한번 더 감싸서 조회하는 부분 추가 (START)
					 SELECT T.DIVISION_ID, T.PROJECT_CODE, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP
						  , T.FCST_TYPE, T.INCOTERMS, T.PLANT_SITE_ID,  T.YYYYMMDD, T.QTY
						  , T.CONFIRM_ID, T.CELL_PROD_SITE_ID
					  FROM ( SELECT A.DIVISION_ID
								  --[E20251029-000956]_원소스 주석 처리 PROJECT_CODE 처리방식 1.SCM_DNM_EXFACTORY_RESULT 테이블의 PROJECT_CODE, 2.SSP_ANL_SHIP_CONFIRM 테이블의 PROJECT_CODE (START)
								  --, A.PROJECT_CODE
								  , CASE WHEN ISNULL(A.PROJECT_CODE, '') = '' THEN D.PROJECT_CODE ELSE A.PROJECT_CODE END AS PROJECT_CODE
								  --[E20251029-000956]_원소스 주석 처리 PROJECT_CODE 처리방식 1.SCM_DNM_EXFACTORY_RESULT 테이블의 PROJECT_CODE, 2.SSP_ANL_SHIP_CONFIRM 테이블의 PROJECT_CODE (END)
								  , C.SCM_SITE_ID AS SCM_SITE_ID, A.ITEM_ID, ISNULL(E.DOM_EXP,'E') AS DOM_EXP
								  , D.FCST_TYPE, INCOTERMS, A.PLANT_ID AS PLANT_SITE_ID, A.PLANT_ISSUE_DATE	AS YYYYMMDD
								  , A.EXFACTORY_QTY	AS QTY, A.CONFIRM_ID, CASE WHEN A.DIVISION_ID = '40' THEN A.FROM_SCM_SITE_ID ELSE '-' END AS CELL_PROD_SITE_ID	-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가. ?? 확인이 필요함.
							   FROM SCM_DNM_EXFACTORY_RESULT A WITH(NOLOCK)
							   /* SALES_SITE_ID를 가져와서 JOIN 한다. */
							  INNER JOIN ( SELECT DIVISION_ID, SCM_SITE_ID
											FROM SCM_MST_SITE WITH(NOLOCK)    
										   WHERE VALID_YN		= 'Y'    
											 AND SITE_TYPE		= 'SALES'    
											 AND OPERATION_GROUP = 'W' ) C
									  ON A.DIVISION_ID		= C.DIVISION_ID
									 AND A.TO_SCM_SITE_ID	= C.SCM_SITE_ID
									 AND ISNULL(EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10')
							   /* [dbo].SSP_ANL_SHIP_CONFIRM 에서 FCST_TYPE을 가져온다.	*/
							  INNER JOIN ( SELECT DIVISION_ID, CONFIRM_ID, FCST_TYPE, DOM_EXP, PROJECT_CODE --[E20251029-000956]_PROJECT_CODE 추가
											 FROM SSP_ANL_SHIP_CONFIRM WITH (NOLOCK)) D
									  ON A.DIVISION_ID	= D.DIVISION_ID
									 AND A.CONFIRM_ID	= D.CONFIRM_ID
							   /* DM_PLN_MKT_FCST에서 가져온 DOM_EXP를 연결한다. 조건 :  DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID */
							  LEFT OUTER JOIN CTE_DOM_T E
										   ON A.DIVISION_ID		= E.DIVISION_ID
										  AND C.SCM_SITE_ID		= E.SCM_SITE_ID
										  AND A.PROJECT_CODE	= E.PROJECT_CODE
										  AND A.ITEM_ID			= E.ITEM_ID
							  WHERE EXFACTORY_DATE < @v_end_yyyymmdd -- 당일    
								AND EXFACTORY_DATE >= @v_start_yyyymmdd  -- 전달 1일
								AND LEN(PLANT_ISSUE_DATE) > 0
							) T
							WHERE ISNULL(T.PROJECT_CODE, '') != '' --[E20251029-000956]_PROJECT_CODE 처리방식 1.SCM_DNM_EXFACTORY_RESULT 테이블의 PROJECT_CODE, 2.SSP_ANL_SHIP_CONFIRM 테이블의 PROJECT_CODE 처리했는데도 들어오지 않은건은 적재하지 않음
						    --[E20251029-000956]_PROJECT_CODE 처리방식을 변경한 후 해당 작업으로 진행한 후에도 NULL값인 데이터는 적재하지 않도록 한번 더 감싸서 조회하는 부분 추가 (END)
				)
				-- AS_In_Plan, AS_In_Req 생성
				INSERT INTO #AS_tmpData
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
					 , FCST_TYPE, INCOTERMS, 'AS_In_Plan' AS MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					 , YYYYMMDD, SUM(QTY) AS QTY
				 FROM CTE_AS_TEMP_DATA WITH(NOLOCK)
				WHERE QTY <>  0
				GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
					  , FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					  , YYYYMMDD
				---------
				UNION ALL
				---------
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
					 , FCST_TYPE, INCOTERMS, 'AS_In_Req' AS MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					 , YYYYMMDD, SUM(QTY) AS QTY
				  FROM CTE_AS_TEMP_DATA WITH(NOLOCK)
				 WHERE QTY <>  0
				 GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
						, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						, YYYYMMDD
				;
				--[E20251029-000956]_소스 라인정리 (END)


				-- 기존 데이터 삭제
				DELETE
				FROM	DM_PLN_MKT_FCST_RESULT
				WHERE	MEASURE   IN ('AS_Inv','AS_In_Plan','AS_In_Req')
					AND YYYYMMDD < @v_end_yyyymmdd     -- 당일 (yyyymmdd)
					AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
					AND DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)
					;


				-- 데이터 추가	
				INSERT DM_PLN_MKT_FCST_RESULT
						(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
						,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
						,CELL_PROD_SITE_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
						)
				SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
						,YYYYMMDD,QTY,'SYSTEM',GETDATE(),'SYSTEM',GETDATE()
						,CELL_PROD_SITE_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					FROM #AS_tmpData WITH(NOLOCK)
					WHERE DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)	-- 2022.11.28
					;
				-- 대상추출 입고정보 AS_In_Plan, AS_In_Req -- 끝


				
	print 'step-6'

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
			---------------------------------------------------------------------------------------- 20180727 KHSONG 소형,ESS vmi 재고 및 입고 실적 정보 생성(START)
			
			-- TEMP테이블 확인후 초기화
			IF OBJECT_ID (N'tempdb..#VMI_tmpData', N'U') IS NOT NULL 
				DROP TABLE #VMI_tmpData
				;
			CREATE TABLE #VMI_tmpData  (
					 division_id      NVARCHAR(30) NOT NULL
					--,company_id	      NVARCHAR(30) NOT NULL
					,project_code     NVARCHAR(50) NOT NULL
					,scm_site_id      NVARCHAR(30) NOT NULL
					,item_id          NVARCHAR(50) NOT NULL
					,dom_exp          NVARCHAR(03) NOT NULL
					,fcst_type        NVARCHAR(20) NOT NULL
					,incoterms        NVARCHAR(10) NOT NULL
					,measure          NVARCHAR(50) NOT NULL
					,plant_site_id    NVARCHAR(30) NOT NULL
					,CELL_PROD_SITE_ID  NVARCHAR(30) NOT NULL		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					,yyyymmdd         NVARCHAR(08) NOT NULL
					,qty              NUMERIC(20,10) NOT NULL
								   )
		   ;

			CREATE CLUSTERED INDEX IDX_tmpData_N1 ON #VMI_tmpData
			(
				 DIVISION_ID ASC
				--,COMPANY_ID ASC
				,PROJECT_CODE ASC
				,SCM_SITE_ID ASC
				,ITEM_ID ASC
				,DOM_EXP ASC
				,FCST_TYPE ASC
				,INCOTERMS ASC
				,MEASURE ASC
				,PLANT_SITE_ID ASC
				,CELL_PROD_SITE_ID ASC				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				,YYYYMMDD ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			
			;
			-- 대상추출 VMI_Inv
			with vmi_inv_data as 
				(
				SELECT mf.division_id, mf.SCM_SITE_ID, mf.item_id, mf.project_code, mf.fcst_type, mf.incoterms, mf.dom_exp 
					, convert( varchar, dateadd(D,-1,s.cutoff_date) ,112) yyyymmdd ,  SUM(s.qty) qty 
					FROM (	SELECT S.DIVISION_ID, S.STORAGE_ID, S.ITEM_ID, S.QTY, S.CUTOFF_DATE, '' AS PLANT_ID
							FROM SCM_DNM_STOCK_SN S WITH(NOLOCK)  -- 운영
							WHERE CUTOFF_DATE >= @V_START_YYYYMMDD
							UNION ALL	-- [C20201103-000114]
							SELECT S.DIVISION_ID, S.STORAGE_ID, S.ITEM_ID, S.QTY, S.RESULT_DATE, S.PLANT_ID
							FROM SCM_DNM_STOCK_SALES S WITH(NOLOCK)
							WHERE S.RESULT_DATE >= @V_START_YYYYMMDD
								AND S.DIVISION_ID = '82'
						) s
						,scm_mst_location l		with(nolock)
						,scm_mst_site m			with(nolock)
						,scm_mst_site_item si	with(nolock)
						,(
							select a.division_id, a.scm_site_id, item_id, project_code, fcst_type, incoterms, dom_exp
							     , row_number() over ( partition by a.division_id, a.scm_site_id, item_id order by yyyymmdd desc) row_nums --[C20210120-000090] VMI_Inv 의 Incoterms 는 MKT_FCST에 마지막으로 등록된 순으로 적용(order by yyyymmdd desc)
								from dm_pln_mkt_fcst a with(nolock)
								    ,scm_mst_site b with(nolock)
									where a.division_id IN ('40','82') --CSR ID:4059971 20190809 KHSONG ESS사업부 추가
										AND a.DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division WITH(NOLOCK) )
										and a.qty > 0 
										and a.division_id = b.division_id
										and a.scm_site_id = b.scm_site_id
										and b.vmi_yn = 'Y'
										--AND A.PROJECT_CODE <> 'R-19-010'
										--AND A.MEASURE LIKE 'VMI%' -- ESS 사업부 [R-19-010] 프로젝트 VMI_INV 재생성 방지 20230626
										--AND A.MEASURE <> 'VMI_DIO'
										-- [C20201222-000376] 아래 두 줄 주석처리
										--and a.measure like 'VMI%'
										--and a.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(cast(@v_end_yyyymmdd as datetime), 'MON')), 112) -- 당주 월요일 이후 
						) mf
						
					where l.division_id = s.division_id
					  and l.storage_id	= s.storage_id
					  AND L.PLANT_ID = CASE WHEN S.PLANT_ID = '' THEN L.PLANT_ID ELSE S.PLANT_ID END 
					  and l.SCM_SITE_ID	= m.scm_site_id
					  and l.VALID_YN = 'Y'  -- 20190809 KHSONG CSR ID:4059971 VMI-In Request 로직 변경
					  and m.site_type	= 'SALES'
					  and m.vmi_yn		= 'Y'
					  and m.division_id	IN ('40','82') --CSR ID:4059971 20190809 KHSONG ESS사업부 추가
					  AND m.DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division WITH(NOLOCK) )
					  and si.item_id like  (case when substring(s.item_id, 1,2) = 'MP' THEN substring( s.item_id, 1,11) ELSE s.item_id END ) +'%' 
					  and l.DIVISION_ID	= si.DIVISION_ID
					  and si.VALID_YN	= 'Y'
					  and l.division_id	= mf.division_id 
					  and l.scm_site_id	= mf.scm_site_id
					  and si.item_id	= mf.item_id
					  and mf.row_nums   = 1

						-- added by ytchoi 180813
						and mf.PROJECT_CODE = si.PROJECT_CODE
						and mf.SCM_SITE_ID   = si.SCM_SITE_ID

				group by mf.division_id, mf.SCM_SITE_ID, mf.item_id, mf.project_code, mf.fcst_type, mf.incoterms, mf.dom_exp , convert( varchar, dateadd(D,-1,s.cutoff_date) ,112)
				)

				-- VMI_Inv TEMP테이블에 INSERT
				INSERT INTO #VMI_tmpData  
				select DIVISION_ID, PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,'VMI_Inv' MEASURE,'' PLANT_SITE_ID
					  ,'-'					AS CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가. / INV는 CELL_PROD_SITE_ID와 무관. 여러 CELL_PROD_SITE_ID와 섞여있음.
					  ,YYYYMMDD,QTY
					from vmi_inv_data WITH(NOLOCK)
						where qty <> 0 
							AND YYYYMMDD < @v_end_yyyymmdd     -- 당일 (yyyymmdd)
							AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
							AND PROJECT_CODE NOT LIKE N'%개발%'		-- [C20210831-000303] GSCM VMI in 수요 없는 실적 발생시 Sales Site Project Model 참조 로직 수정 요청
				;

			-- 대상추출 입고정보 VMI_In_Plan, VMI_In_Req
			
			
			; with vmi_whin_data as 
				(
				SELECT mf.division_id, mf.SCM_SITE_ID, mf.item_id, mf.project_code, mf.fcst_type, mf.incoterms, mf.dom_exp , doc_posting_date yyyymmdd 
					  --,CASE WHEN SUBSTRING(S.STORAGE_ID,1,1) = 'A' AND S.MOVEMENT_TYPE = '312' THEN SUM(S.MAT_QTY) * -1 ELSE SUM(S.MAT_QTY) END AS QTY -- 20200406 KHSONG  C20200324-000209 마이너스로 반영해야 하는건 
					  , CASE WHEN S.STORAGE_ID IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'STORAGE_ID_03')) 
					    AND S.MOVEMENT_TYPE IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'MOVEMENT_TYPE_01')) THEN SUM(S.MAT_QTY) * -1 ELSE SUM(S.MAT_QTY) END AS QTY --[PJ20228272] NERP 대응
					  --,  SUM(s.mat_qty) qty 
					  ,s.storage_id --CSR ID:4059971 20190809 KHSONG
					  --,s.ATTRIBUTE2	-- [C20210908-000163] Vmi in Req 실적 구간 로직 수정
					FROM SCM_DNM_MAT_DOCUMENT s with(nolock)
						,scm_mst_location l		with(nolock)
						,scm_mst_site m			with(nolock)
						,scm_mst_site_item si	with(nolock)
						,(
							select a.division_id, a.scm_site_id, item_id, project_code, fcst_type, incoterms, dom_exp, row_number() over ( partition by a.division_id, a.scm_site_id, item_id order by yyyymmdd) row_nums  
								from dm_pln_mkt_fcst a with(nolock)
								    ,scm_mst_site b with(nolock)
									where a.division_id IN ('82') --CSR ID:4059971 20190809 KHSONG ESS사업부 추가
										AND a.DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)
										and a.qty > 0 
										and a.division_id = b.division_id
										and a.scm_site_id = b.scm_site_id
										and b.vmi_yn = 'Y'
										and a.measure like 'VMI%'
										and a.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(cast(@v_end_yyyymmdd as datetime), 'MON')), 112) -- 당주 월요일 이후 
						) mf
						where 1=1
							and l.storage_id	= s.storage_id
							-- 20200406 KHSONG  C20200324-000209 로직보완 (BEGIN)
							--AND SUBSTRING(S.STORAGE_ID,1,1) IN ('A','6')  -- '6' 입고수량과 'A'+MOVEMENT_TYPE='312' 취소수량을 반영하기위함
							--AND S.MOVEMENT_TYPE = CASE WHEN SUBSTRING(S.STORAGE_ID,1,1) = 'A' THEN '312'  -- STORAGE_ID = 'AXXX' + MOVEMENT_TYPE='312'  → 입고 (-)
							--						   WHEN SUBSTRING(S.STORAGE_ID,1,1) = '6' THEN '311'  -- STORAGE_ID = '6XXX' + MOVEMENT_TYPE='311'  → 입고 (+)
							--		ELSE 'NOT MATCH'
							--	END
							AND S.STORAGE_ID IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'STORAGE_ID_01')) --[PJ20228272] NERP 대응
							AND S.MOVEMENT_TYPE = [dbo].FN_GET_LOOKUP_VALUE_DESC('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'STORAGE_ID_01',S.STORAGE_ID, 'NOT MATCH') --[PJ20228272] NERP 대응
							AND S.INDICATOR = 'S' -- 'S'만 사용함
							-- 20200406 KHSONG  C20200324-000209 로직보완 (END)

						  and l.SCM_SITE_ID	= m.scm_site_id
						  and l.VALID_YN = 'Y'  -- 20190809 KHSONG CSR ID:4059971 VMI-In Request 로직 변경
						  and m.site_type	= 'SALES'
						  and m.vmi_yn		= 'Y'
						  and m.division_id	IN ('82') --CSR ID:4059971 20190809 KHSONG ESS사업부 추가
						  AND m.DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division WITH(NOLOCK) )
						  and si.item_id like  (case when substring(s.item_id, 1,2) = 'MP' THEN substring( s.item_id, 1,11) ELSE s.item_id END ) +'%' 
						  and l.DIVISION_ID	= si.DIVISION_ID
						  and si.VALID_YN	= 'Y'
						  and l.division_id	= mf.division_id 
						  and l.scm_site_id	= mf.scm_site_id
						  and si.item_id	= mf.item_id
						  and mf.row_nums   = 1

						-- added by ytchoi 180813
						and mf.PROJECT_CODE = si.PROJECT_CODE
						and mf.SCM_SITE_ID   = si.SCM_SITE_ID
						AND s.ATTRIBUTE2 IS NULL				-- [C20210908-000163] Vmi in Req 실적 구간 로직 수정

				group by mf.division_id, mf.SCM_SITE_ID, mf.item_id, mf.project_code, mf.fcst_type, mf.incoterms, mf.dom_exp , doc_posting_date,s.storage_id,S.MOVEMENT_TYPE
				)

				---------------------------
				INSERT INTO #VMI_tmpData
					  (DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
					  ,CELL_PROD_SITE_ID							-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가. / 82 사이트는 '-'로 처리
					  ,YYYYMMDD,QTY)
				select DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,'VMI_In_Plan' MEASURE,'' PLANT_SITE_ID
					  ,'-'					AS CELL_PROD_SITE_ID	-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가. / 82 사이트는 '-'로 처리
					  ,YYYYMMDD,SUM(QTY)
				from vmi_whin_data WITH(NOLOCK)
				where qty <> 0 
					AND DIVISION_ID = '82'
					AND YYYYMMDD < @v_end_yyyymmdd     -- 당일 (yyyymmdd)
					AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
					--AND isnumeric (SUBSTRING(storage_id,1,1)) = 1  --CSR ID:4059971 20190809 KHSONG ('0'이면 문자 '1'이면 숫자) / 숫자인경우만 실적에 집계되도록 로직추가 --20200406 KHSONG 주석처리
				GROUP BY DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,YYYYMMDD
				---------
				UNION ALL
				---------
				SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,'VMI_In_Req' MEASURE,'' PLANT_SITE_ID
					  ,'-'					AS CELL_PROD_SITE_ID	-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가. / 82 사이트는 '-'로 처리
					  ,YYYYMMDD,SUM(QTY)
					 FROM 
					(select DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,YYYYMMDD,QTY
					from vmi_whin_data WITH(NOLOCK)
					where qty <> 0
						AND DIVISION_ID = '82'
						AND YYYYMMDD < @v_end_yyyymmdd     -- 당일 (yyyymmdd)
						AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
						--AND isnumeric (SUBSTRING(storage_id,1,1)) = 1  --CSR ID:4059971 20190809 KHSONG ('0'이면 문자 '1'이면 숫자) / 숫자인경우만 실적에 집계되도록 로직추가 --20200406 KHSONG 주석처리
					) A
				GROUP BY DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,YYYYMMDD
				;

				
			-- [C20210618-000288] VMI IN PLAN, REQUEST 를 담을 테이블, 소형에서만 사용하고, ESS 는 CTE 구분을 그대로 사용함.
			CREATE TABLE #VMI_RESULT (
			DIVISION_ID		NVARCHAR(30)
			, SCM_SITE_ID	NVARCHAR(30)
			, ITEM_ID		NVARCHAR(50)
			, PROJECT_CODE	NVARCHAR(50)
			, FCST_TYPE		NVARCHAR(20)
			, INCOTERMS		NVARCHAR(10)
			, DOM_EXP		NVARCHAR(3)
			, YYYYMMDD		NVARCHAR(8)
			, QTY			NUMERIC(20,10)
			, STORAGE_ID	NVARCHAR(30)
			, CELL_PROD_SITE_ID	NVARCHAR(30)		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가. 
			)

			-- [C20210713-000038] 아래 CTE 에서 서브쿼리로 사용시 속도가 안나와서 템프로 처리함.
			SELECT A.DIVISION_ID, A.SCM_SITE_ID, ITEM_ID, PROJECT_CODE, FCST_TYPE, INCOTERMS, DOM_EXP
			    , CELL_PROD_SITE_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가. 
				, ROW_NUMBER() OVER ( PARTITION BY A.DIVISION_ID, A.SCM_SITE_ID, ITEM_ID ORDER BY YYYYMMDD) ROW_NUMS  
			INTO #T_MF
			--FROM DM_PLN_MKT_FCST A WITH(NOLOCK)
			FROM DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가. CELL_PROD_SITE_ID 생성을 위해 DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 사용
			JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND B.VMI_YN = 'Y'
			WHERE A.DIVISION_ID IN ('40')
				AND A.DIVISION_ID IN (SELECT DIVISION_ID FROM #I_DIVISION WITH(NOLOCK) )
				AND A.QTY > 0 
				AND A.MEASURE LIKE 'VMI%'
				AND A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(CAST(@v_end_yyyymmdd AS DATETIME), 'MON')), 112) -- 당주 월요일 이후 


			; WITH VMI_WHIN_DATA_40 AS 
			(
			SELECT ISNULL(MF.DIVISION_ID, SI.DIVISION_ID) AS DIVISION_ID
					, ISNULL(MF.SCM_SITE_ID, SI.SCM_SITE_ID) AS SCM_SITE_ID
					, ISNULL(MF.ITEM_ID, SI.ITEM_ID) AS ITEM_ID
					, ISNULL(MF.PROJECT_CODE, SI.PROJECT_CODE) AS PROJECT_CODE
					, MF.FCST_TYPE, MF.INCOTERMS, MF.DOM_EXP
					, DOC_POSTING_DATE AS YYYYMMDD 
					--,CASE WHEN SUBSTRING(S.STORAGE_ID,1,1) = 'A' AND S.MOVEMENT_TYPE = '312' THEN SUM(S.MAT_QTY) * -1 ELSE SUM(S.MAT_QTY) END AS QTY
					, CASE WHEN S.STORAGE_ID IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'STORAGE_ID_03')) 
					  AND S.MOVEMENT_TYPE IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'MOVEMENT_TYPE_01')) THEN SUM(S.MAT_QTY) * -1 ELSE SUM(S.MAT_QTY) END AS QTY --[PJ20228272] NERP 대응
					,S.STORAGE_ID
					--,s.ATTRIBUTE2	-- [C20210908-000163] Vmi in Req 실적 구간 로직 수정
					,ISNULL(MF.CELL_PROD_SITE_ID, '-')		AS CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가. 
				--FROM SCM_DNM_MAT_DOCUMENT S WITH(NOLOCK)
				FROM SCM_DNM_MAT_DOCUMENT S WITH(NOLOCK)
					JOIN SCM_MST_LOCATION L	WITH(NOLOCK) ON S.STORAGE_ID = L.STORAGE_ID AND L.VALID_YN = 'Y'
					JOIN SCM_MST_SITE M		WITH(NOLOCK) ON L.SCM_SITE_ID	= M.SCM_SITE_ID AND M.SITE_TYPE	= 'SALES' AND M.VMI_YN = 'Y'AND M.DIVISION_ID IN ('40')
															AND L.DIVISION_ID = M.DIVISION_ID	-- [C20210713-000038]
															AND M.DIVISION_ID IN (SELECT DIVISION_ID FROM #I_DIVISION WITH(NOLOCK))
					JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) ON L.DIVISION_ID = SI.DIVISION_ID AND SI.VALID_YN	= 'Y'
															AND M.SCM_SITE_ID = SI.SCM_SITE_ID	-- [C20210713-000038]
															AND SI.ITEM_ID LIKE  (CASE WHEN SUBSTRING(S.ITEM_ID, 1,2) = 'MP' THEN SUBSTRING( S.ITEM_ID, 1,11) ELSE S.ITEM_ID END ) +'%' 
					LEFT OUTER JOIN #T_MF MF WITH(NOLOCK) ON MF.PROJECT_CODE = SI.PROJECT_CODE AND MF.SCM_SITE_ID = SI.SCM_SITE_ID AND SI.ITEM_ID = MF.ITEM_ID AND MF.ROW_NUMS   = 1
									AND L.DIVISION_ID = MF.DIVISION_ID AND L.SCM_SITE_ID	= MF.SCM_SITE_ID
					WHERE 1=1
					--AND SUBSTRING(S.STORAGE_ID,1,1) IN ('A','6') 
					--AND S.MOVEMENT_TYPE = CASE WHEN SUBSTRING(S.STORAGE_ID,1,1) = 'A' THEN '312'  -- STORAGE_ID = 'AXXX' + MOVEMENT_TYPE='312'  → 입고 (-)
					--							WHEN SUBSTRING(S.STORAGE_ID,1,1) = '6' THEN '311'  -- STORAGE_ID = '6XXX' + MOVEMENT_TYPE='311'  → 입고 (+)
					--		ELSE 'NOT MATCH'
					--	END
					AND S.STORAGE_ID IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'STORAGE_ID_01')) --[PJ20228272] NERP 대응
					AND S.MOVEMENT_TYPE = [dbo].FN_GET_LOOKUP_VALUE_DESC('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'STORAGE_ID_01',S.STORAGE_ID, 'NOT MATCH') --[PJ20228272] NERP 대응
					AND S.INDICATOR = 'S'
					AND S.DOC_POSTING_DATE >= @v_start_yyyymmdd
					AND ISNULL(MF.PROJECT_CODE, SI.PROJECT_CODE) NOT LIKE N'%개발%'		-- [C20210831-000303] GSCM VMI in 수요 없는 실적 발생시 Sales Site Project Model 참조 로직 수정 요청
					AND s.ATTRIBUTE2 IS NULL				-- [C20210908-000163] Vmi in Req 실적 구간 로직 수정
			GROUP BY ISNULL(MF.DIVISION_ID, SI.DIVISION_ID), ISNULL(MF.SCM_SITE_ID, SI.SCM_SITE_ID), ISNULL(MF.ITEM_ID, SI.ITEM_ID), ISNULL(MF.PROJECT_CODE, SI.PROJECT_CODE)
				, MF.FCST_TYPE, MF.INCOTERMS, MF.DOM_EXP , DOC_POSTING_DATE,S.STORAGE_ID,S.MOVEMENT_TYPE
				, ISNULL(MF.CELL_PROD_SITE_ID, '-')						-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가. 
			)

			INSERT INTO #VMI_RESULT  ( DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE, FCST_TYPE, INCOTERMS, DOM_EXP, YYYYMMDD, QTY, STORAGE_ID 
									 , CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가. 
									 )
			SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE, FCST_TYPE, INCOTERMS, DOM_EXP, YYYYMMDD, QTY, STORAGE_ID 
				 , CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가. 
			FROM VMI_WHIN_DATA_40 WITH(NOLOCK)

			UPDATE A
			SET FCST_TYPE = B.FCST_TYPE
				, INCOTERMS = B.INCOTERMS
				, DOM_EXP = B.DOM_EXP
			FROM #VMI_RESULT A
			JOIN ( SELECT DISTINCT SCM_SITE_ID, FCST_TYPE, INCOTERMS, DOM_EXP
					FROM #VMI_RESULT WITH(NOLOCK)
					WHERE FCST_TYPE IS NOT NULL
				) B ON A.SCM_SITE_ID = B.SCM_SITE_ID
			WHERE A.FCST_TYPE IS NULL

			UPDATE A
			SET FCST_TYPE = B.FCST_TYPE
				, INCOTERMS = B.INCOTERMS
				, DOM_EXP = B.DOM_EXP
			FROM #VMI_RESULT A
			JOIN (
				SELECT A.DIVISION_ID, A.SCM_SITE_ID, ITEM_ID, PROJECT_CODE, FCST_TYPE, INCOTERMS, DOM_EXP
					, ROW_NUMBER() OVER ( PARTITION BY A.DIVISION_ID, A.SCM_SITE_ID, ITEM_ID ORDER BY YYYYMMDD) ROW_NUMS  
				--FROM DM_PLN_MKT_FCST A WITH(NOLOCK)
				FROM DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가. 40사업부에 한해처 처리되므로 DM_PLN_CFM_MKT_DEMAND_PLAN 로 적용
				JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND B.VMI_YN = 'Y'
				WHERE A.DIVISION_ID IN ('40')
					AND A.DIVISION_ID IN (SELECT DIVISION_ID FROM #I_DIVISION WITH(NOLOCK) )
					AND A.QTY > 0 
					AND A.MEASURE LIKE 'MKT_FCST%'
					AND A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(CAST(@v_end_yyyymmdd AS DATETIME), 'MON')), 112) -- 당주 월요일 이후 
			) B ON A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND B.ROW_NUMS   = 1
					AND A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID	= B.SCM_SITE_ID
			WHERE A.FCST_TYPE IS NULL


			--1. 동일 SITE 의 다른 MODEL 에 대한 VMI 입출고 내역이 있으면 그 내역의 FCST_TYPE, INCOTERMS, DOM_EXP 를 사용
			--   ( FCST_TYPE 이 여러가지 일 경우 랜덤값 )
			--   ( 입출고 내역의 기간은 ERP 실적이 돌아가는 구간 - 보통 1개월전부터 실적구간 마지막날까지)
			--2. 현재는 동일한 SITE, MODEL, END_CUSTOMER 등에 대해서 계획구간의 VMI 메저만 찾고 있는데, MKT FCST 메저도 참조
			--3. 룩업에 설정된 SITE 별 기본값 이용

			UPDATE A
			SET FCST_TYPE = B.ATTRIBUTE1
				, INCOTERMS = B.ATTRIBUTE2
				, DOM_EXP = B.ATTRIBUTE3
			FROM #VMI_RESULT A
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON B.LOOKUP_TYPE = 'DM_VMI_RESULT_DEFAULT' 
													AND A.DIVISION_ID = B.SEGMENT1 AND A.SCM_SITE_ID = B.SEGMENT2
													AND B.VALID_YN = 'Y'
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK) ON B.ATTRIBUTE1 = C.SEGMENT1 AND C.LOOKUP_TYPE = 'SALES_TYPE_CODE' -- 사용자가 FCST TYPE CODE를 정확하게 넣지 못한 부분 제외
													AND B.VALID_YN = 'Y'
			WHERE A.FCST_TYPE IS NULL

			-- 처리할 수 없는 데이터는 삭제한다. ( 아래에서 mkt fcst 에 insert 중 오류나지 않도록 )
			DELETE FROM #VMI_RESULT WHERE FCST_TYPE IS NULL

			INSERT INTO #VMI_tmpData
					(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
					,CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					,YYYYMMDD,QTY)
			select DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,'VMI_In_Plan' MEASURE,'' PLANT_SITE_ID
				  ,CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				  ,YYYYMMDD,SUM(QTY)
			from #VMI_RESULT WITH(NOLOCK)
			where qty <> 0 
				AND DIVISION_ID = '40'
				AND YYYYMMDD < @v_end_yyyymmdd     -- 당일 (yyyymmdd)
				AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
				--AND isnumeric (SUBSTRING(storage_id,1,1)) = 1  --CSR ID:4059971 20190809 KHSONG ('0'이면 문자 '1'이면 숫자) / 숫자인경우만 실적에 집계되도록 로직추가 --20200406 KHSONG 주석처리
			GROUP BY DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
					,CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					,YYYYMMDD
			---------
			UNION ALL
			---------
			SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,'VMI_In_Req' MEASURE,'' PLANT_SITE_ID
				  ,CELL_PROD_SITE_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				  ,YYYYMMDD,SUM(QTY)
					FROM 
				(select DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
					   ,CELL_PROD_SITE_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					   ,YYYYMMDD,QTY
				from #VMI_RESULT WITH(NOLOCK)
				where qty <> 0
					AND DIVISION_ID = '40'
					AND YYYYMMDD < @v_end_yyyymmdd     -- 당일 (yyyymmdd)
					AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
					--AND isnumeric (SUBSTRING(storage_id,1,1)) = 1  --CSR ID:4059971 20190809 KHSONG ('0'이면 문자 '1'이면 숫자) / 숫자인경우만 실적에 집계되도록 로직추가 --20200406 KHSONG 주석처리
				) A
			GROUP BY DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
					,CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					,YYYYMMDD


		-- [C20210618-000288]  end

		
	print 'step-7'
				---------------------------
			-- 기존데이터 삭제
			DELETE
			  FROM	dbo.DM_PLN_MKT_FCST_RESULT
			 WHERE	MEASURE   IN ('VMI_Inv','VMI_In_Plan','VMI_In_Req')
				AND YYYYMMDD < @v_end_yyyymmdd     -- 당일 (yyyymmdd)
				AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
			    AND DIVISION_ID	IN ('40','82') --CSR ID:4059971 20190809 KHSONG ESS사업부 추가
			    AND DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)

			DELETE
			  FROM	dbo.DM_PLN_SALES_PLAN_RESULT
			 WHERE	MEASURE   IN ('VMI_Inv','VMI_In_Plan','VMI_In_Req')
				AND YYYYMMDD < @v_end_yyyymmdd     -- 당일 (yyyymmdd)
				AND YYYYMMDD >= @v_start_yyyymmdd  -- 1달전 1일 (yyyymmdd)
			   AND  DIVISION_ID	IN ('40','82') --CSR ID:4059971 20190809 KHSONG ESS사업부 추가
			   AND  DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division)

			-- 전체 대상INSERT
			INSERT dbo.DM_PLN_MKT_FCST_RESULT
					(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
					,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					,CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					)
			SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
					,YYYYMMDD,QTY,'SYSTEM',GETDATE(),'SYSTEM',GETDATE()
					,CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				FROM #VMI_tmpData WITH(NOLOCK)
				;

			INSERT dbo.DM_PLN_SALES_PLAN_RESULT
					( DIVISION_ID, PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID, COMPANY_ID
					 ,YYYYMMDD,CURRENCY,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					 ,CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					 )
			SELECT DIVISION_ID, PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID, '' AS COMPANY_ID
					,YYYYMMDD,'-' CURRENCY,QTY,'SYSTEM',GETDATE(),'SYSTEM',GETDATE()
					,CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				FROM #VMI_tmpData WITH(NOLOCK)
				;
			---------------------------------------------------------------------------------------- 20180727 KHSONG 소형,ESS vmi 재고 및 입고 실적 정보 생성(END)

			---------------------------------------------------------------------------------------- 20181015 KHSONG 자동차 dm_pln_mkt_fcst_result 에 VMI_In_Plan, VMI_In_Req 생성(START)
			-- 기존데이터 삭제
			DELETE
			  FROM	dbo.DM_PLN_MKT_FCST_RESULT
			 WHERE	MEASURE     IN ('VMI_In_Plan','VMI_In_Req')
				AND YYYYMMDD     < @v_end_yyyymmdd     -- 당일 (yyyymmdd)
				AND YYYYMMDD    >= @v_start_yyyymmdd   -- 1달전 1일 (yyyymmdd)
			    AND DIVISION_ID	   LIKE '81%'                -- 자동차만 해당됨
			    AND DIVISION_ID IN (SELECT DIVISION_ID FROM #i_division WITH(NOLOCK))
			
			-- HLGP 향 제외
			-- DM_PLN_MKT_FCST_RESULT INSERT 수행
			INSERT dbo.DM_PLN_MKT_FCST_RESULT
					(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
					,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					,CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					)
			SELECT exfactory.division_id			AS DIVISION_ID
				 , target_mktfcst.project_code		AS PROJECT_CODE
				 , target_site.SCM_SITE_ID			AS SCM_SITE_ID
				 , exfactory.item_id				AS ITEM_ID
				 , target_mktfcst.dom_exp			AS DOM_EXP
				 , target_mktfcst.fcst_type			AS FCST_TYPE
				 , target_mktfcst.incoterms			AS INCOTERMS
				 , MEASURE_IN.MEASURE				AS MEASURE
				 , target_mktfcst.PLANT_SITE_ID		AS PLANT_SITE_ID
				 , ACTUAL_EXFACTORY_DATE			AS YYYYMMDD
				 , SUM(exfactory_qty)				AS QTY
				 , 'SYSTEM'							AS CREATED_BY
				 , GETDATE()						AS CREATION_DATE
				 , 'SYSTEM'							AS LAST_UPDATED_BY
				 , GETDATE()						AS LAST_UPDATE_DATE
				 , '-'								AS CELL_PROD_SITE_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가. 81사업부 계열이므로 '-'로 처리함.
			  FROM SCM_DNM_EXFACTORY_RESULT exfactory WITH(NOLOCK)
			 INNER JOIN scm_mst_site target_site WITH(NOLOCK)
				ON  exfactory.division_id		=	target_site.division_id
				AND exfactory.to_scm_site_id	=	target_site.scm_site_id
				AND target_site.vmi_yn			=	'Y'
				and target_site.valid_yn		=	'Y'
			 INNER JOIN (
			
			      select a.division_id, a.scm_site_id, item_id, project_code, fcst_type, incoterms, dom_exp,PLANT_SITE_ID
				       -- 상품창고(6000)에서 나간 것은 해외 Plant로 연결요청, 해외 Plant 구분은 안되기 때문에 국내가 아닌것 중에 하나를 선택하도록 함. req by 마재우
				       --, (case when substring(plant_site_id,1,4) = 'A040' then 'A040' else 'OTHER' end) plant2
					   --, row_number() over ( partition by a.division_id, a.scm_site_id, item_id, (case when substring(plant_site_id,1,4) = 'A040' then 'A040' else 'OTHER' end) order by yyyymmdd) row_nums  
					   , [dbo].FN_GET_LOOKUP_VALUE_DESC('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'PLANT_ID_01',substring(plant_site_id,1,4), 'OTHER') plant2 --[PJ20228272] NERP 대응
					   , row_number() over ( partition by a.division_id, a.scm_site_id, item_id
					                                    , ([dbo].FN_GET_LOOKUP_VALUE_DESC('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'PLANT_ID_01',substring(plant_site_id,1,4), 'OTHER')) order by yyyymmdd) row_nums --[PJ20228272] NERP 대응

					from dm_pln_mkt_fcst a with(nolock)
						,scm_mst_site b with(nolock)
						where   a.division_id   LIKE '81%'  -- 자동차만 해당됨
							AND a.DIVISION_ID  IN (SELECT DIVISION_ID FROM #i_division)
							and a.qty           > 0 
							and a.division_id	= b.division_id
							and a.scm_site_id	= b.scm_site_id
							and b.vmi_yn		= 'Y'
							and a.measure	 like 'VMI%'
							and a.yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(cast(@v_end_yyyymmdd as datetime), 'MON')), 112) -- 당주 월요일 이후
						) target_mktfcst
				ON  exfactory.division_id		=	target_mktfcst.division_id
				and exfactory.to_scm_site_id	=	target_mktfcst.scm_site_id
				and target_mktfcst.row_nums		=	1
				and exfactory.item_id			=	target_mktfcst.item_id
				AND ACTUAL_EXFACTORY_DATE     < @v_end_yyyymmdd     -- 당일 (yyyymmdd)
				AND ACTUAL_EXFACTORY_DATE    >= @v_start_yyyymmdd   -- 1달전 1일 (yyyymmdd)
				-- 상품창고(6000)에서 나간 것은 해외 Plant로 연결요청 req by 마재우
				--AND CASE exfactory.storage_id when '6000' then 'OTHER' else 'A040' end = target_mktfcst.plant2
				AND [dbo].FN_GET_LOOKUP_VALUE_DESC('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'STORAGE_ID_02',exfactory.storage_id, [dbo].FN_GET_LOOKUP_VALUE('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'PLANT_ID_02')) = target_mktfcst.plant2 --[PJ20228272] NERP 대응
			   ,(
				SELECT 'VMI_In_Plan' MEASURE
				UNION ALL
				SELECT 'VMI_In_Req' MEASURE
			   ) MEASURE_IN
			 --where exfactory.ORDER_TYPE_CODE  = 'ZKB' -- 고객위탁vmi에 대해서는 ORDER TYPE이 ZKB 임.
			 where exfactory.ORDER_TYPE_CODE  IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'ORDER_TYPE_CODE_01')) --[PJ20228272] NERP 대응
			group by exfactory.division_id, target_site.SCM_SITE_ID, exfactory.item_id, target_mktfcst.project_code, target_mktfcst.fcst_type
			, target_mktfcst.incoterms, target_mktfcst.dom_exp, target_mktfcst.PLANT_SITE_ID , MEASURE_IN.MEASURE, ACTUAL_EXFACTORY_DATE

			
	print 'step-8'	
			---------------------------------------------------------------------------------------- 20181015 KHSONG 자동차 dm_pln_mkt_fcst_result 에 VMI_In_Plan, VMI_In_Req 생성(END)
		COMMIT WORK;

	print 'step-9'		
			--[E20250404-001534]_[공급생산 SCM PI팀] 지연 빌링 발생 시 수요계획 보정 기능 개발 요청 START			
			--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
			--1. 룩업을 이용하여 일정을 조정한다 (월요일 13, 23시 비교 룩업에 설정된 시간)
			--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■		
			IF OBJECT_ID (N'tempdb..#TEMP_DELAY_DAY', N'U') IS NOT NULL 
				DROP TABLE #TEMP_DELAY_DAY;	

			CREATE TABLE #TEMP_DELAY_DAY 
			(	DIVISION_ID		NVARCHAR(30)
			  , STATES			NVARCHAR(50)
			  , SEQ		INT		IDENTITY(1,1)
			)		

			INSERT INTO #TEMP_DELAY_DAY
			(DIVISION_ID, STATES)
			SELECT SEGMENT1 AS DIVISION_ID, ATTRIBUTE1 AS STATES
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
			WHERE LOOKUP_TYPE = N'RESULT_MAPPING_SCHEDULE'
			AND VALID_YN = 'Y'
			AND SEGMENT4 = 'DELAY'  
			AND SEGMENT1 IN (SELECT DIVISION_ID FROM #i_division)
			AND LEFT(SEGMENT3,2) BETWEEN SUBSTRING(CONVERT(NVARCHAR, DATEADD(HOUR, -1, GETDATE()), 121), 12, 2) AND SUBSTRING(CONVERT(NVARCHAR, GETDATE(), 121), 12, 2)
			AND SEGMENT2 = (SELECT DAYOFWEEK FROM [dbo].[SCM_SYS_CALENDAR_M] WITH (NOLOCK) WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8), GETDATE(), 112))
			GROUP BY SEGMENT1, ATTRIBUTE1			
			
			DECLARE @ROWCNT INT
			SET @ROWCNT = @@ROWCOUNT
			
			DECLARE @I		INT
			DECLARE @CNT	INT	
			
			SELECT @I = 1, @CNT = COUNT(*)
			FROM #TEMP_DELAY_DAY WITH(NOLOCK);
			
			DECLARE @V_DEDUCTED_DIVISION_ID VARCHAR(8)
			DECLARE @V_STATES				VARCHAR(8);

print 'step A-' + N'지연빌링 일정시작: '+ CONVERT(NVARCHAR(30), GETDATE(), 121) + N'  사업부: '+ @V_DEDUCTED_DIVISION_ID	+ N' 요청상태: ' + @V_STATES	
			------------------------------------------------------------------------------------------------------------------------------------------------ 
			--[E20250404-001534]_데이터 존재하여 작업 시작 START	
			------------------------------------------------------------------------------------------------------------------------------------------------ 
			SET @v_log_type    = 'APPEND';  
			SET @v_log_message = N'지연빌링 확인';  
			SET @v_description = N'지연빌링 대상확인: '+ CONVERT(NVARCHAR(30), GETDATE(), 121) + N'  사업부: '+ @V_DEDUCTED_DIVISION_ID	+ N' 요청상태: ' + @V_STATES;	
			SET @d_event_date  = SYSDATETIME();
			SET @n_log_count   = @ROWCNT;
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
			-----------------------------------------------------------------------------------------------------------------------------------------------
			--[E20250404-001534]_데이터 존재하여 작업 시작 START	
			-----------------------------------------------------------------------------------------------------------------------------------------------

			WHILE ( @I <= @CNT )
			BEGIN			
				SELECT @V_DEDUCTED_DIVISION_ID	= A.DIVISION_ID
					 , @V_STATES				= A.STATES
				FROM #TEMP_DELAY_DAY A WITH(NOLOCK)
				WHERE SEQ = @I				

				--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
				--1).13시 데이터와 23시 데이터 비교시에도 활용해야 되기때문에 테이블 생성한다. 	
				-- (1). 룩업에 등록된 대상 기준으로 DIVISION_ID, ITEM, TEAM정보로 SCM_MST_SITE_ITEM에서 TEAM은 없으므로 OWNER로 TEAM정보를 추출한다. 		
				-- (2). 현재 구조상 SCM_MST_SITE_ITEM에는 여러명의 OWNER가 존재한다. 하여 여러명의 OWNER의 DEPT_ID를 모두 추출한다.
				-- (3). 대상 데이터로 잡을 수 있는 데이터에서 SCM_MST_SITE_ITEM PK값을 최대한 추출하여 담는다.
				--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■			
				IF OBJECT_ID (N'tempdb..#TEMP_DEDUCTED_ITEM', N'U') IS NOT NULL 
					DROP TABLE #TEMP_DEDUCTED_ITEM;			
print 'step0-' + N'지연빌링 수행 시작: ' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'  사업부: '+ @V_DEDUCTED_DIVISION_ID + N' 요청상태: ' + @V_STATES				

				--룩업에서 생성한 SSPM과 맵핑된 데이터 
				CREATE TABLE #TEMP_DEDUCTED_ITEM
				(  DIVISION_ID		NVARCHAR(30) NOT NULL
				 , SCM_SITE_ID		NVARCHAR(30) NOT NULL
				 , PROJECT_CODE		NVARCHAR(50) NOT NULL
				 , ITEM_ID			NVARCHAR(50) NOT NULL)

				INSERT INTO #TEMP_DEDUCTED_ITEM
				( DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID)
				SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID
				FROM 
				(   SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.OWNER, A.REAL_OWNER, B.DEPT_ID
					FROM 
					(  
						SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.OWNER, TOKEN AS REAL_OWNER
						FROM SCM_MST_SITE_ITEM A WITH (NOLOCK) 
						CROSS APPLY STRING_SPLIT(OWNER, ',')
						WHERE A.VALID_YN = 'Y'
						AND ISNULL(A.OWNER, '') != ''
					) A
					INNER JOIN SCM_MST_SSO_USER_INFO B WITH(NOLOCK)
							ON A.REAL_OWNER = B.USER_ID
					INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
							ON A.DIVISION_ID = @V_DEDUCTED_DIVISION_ID
						   AND A.ITEM_ID	 = C.SEGMENT2
						   AND B.DEPT_ID	 = C.SEGMENT3
						   AND C.LOOKUP_TYPE = 'DM_DELAY_BILLING_AUTO_DEDUCTED'
				) A
				GROUP BY  A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID	
				
				SET @ROWCNT = @@ROWCOUNT	
				------------------------------------------------------------------------------------------------------------------------------------------------ 
				--[E20250404-001534]_데이터 존재하여 작업 시작 START	
				------------------------------------------------------------------------------------------------------------------------------------------------ 
				SET @v_log_type    = 'APPEND';  
				SET @v_log_message = N'지연빌링수행시작';  
				SET @v_description = N'지연빌링 수행 시작: ' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'  사업부: '+ @V_DEDUCTED_DIVISION_ID + N' 요청상태: ' + @V_STATES;	
				SET @d_event_date  = SYSDATETIME();
				SET @n_log_count   = @ROWCNT;
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
				-----------------------------------------------------------------------------------------------------------------------------------------------
				--[E20250404-001534]_데이터 존재하여 작업 시작 START	
				-----------------------------------------------------------------------------------------------------------------------------------------------
					
				--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
				--2). 룩업에 해당하는 데이터에 한하여 13시 실적 데이터를 MF_D로 보관한다.
				-- (1). PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING 프로시져에서 13시에 생성한 MF_D를 생성한다.	
				-- (2). 13시에 생성한 MF_D는 버전테이블에 버전은 생성하지 않고(화면에 노출하지 않기위함), 룩업에 해당하는 데이터 만을 보관한다.
				--		해당 목적으로 보관하는 데이터는 버전 UP이 필요없기때문에 "DM_MST_VERSION" 테이블에 데이터를 저장하지 않고
				--		MF_D에 영향이 없도록 "MF_D+날짜+V000"로 고정하여 버전을 생성한다.(매일 CUTOFF 하는 MF_D 버전은 V001로 시작한다.) 
				--		DM_PLN_MKT_FCST_RESULT_C 테이블에만 MF_D로 "MF_D+날짜+V000"로 고정하여 버전을 생성
				-- (3). 직전주차 실적구간에 대해서 한정한다(전주 월요일 ~ 일요일). 대상 메져는 RTF_SYS_RP
				--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
				IF (@V_STATES = 'STORAGE')
				BEGIN		
					/*================================================================================================================
					--대상으로 잡은 데이터가 한건이라도 있는 경우에 대해서만 실행한다. 
					--룩업에 저장되지 않은 사업부는 따로 데이터를 보관할 필요가 없기때문에 해당 비교 작업을 한다.
					================================================================================================================*/
					DECLARE @v_version VARCHAR(20)
					SET @v_version = 'MF_D_'+CONVERT(VARCHAR(8), GETDATE(), 112)+'_V000'
print 'step1-' + N'지연빌링건 수행 13시 CUTOFF: ' + @v_version + N'  사업부: '+ @V_DEDUCTED_DIVISION_ID + N' 요청상태: ' + @V_STATES		

					--2번 수행되는 경우가 발생할 수 있으므로, 버전 삭제 후 재생성한다.
					DELETE FROM DM_PLN_MKT_FCST_RESULT_C
					WHERE DIVISION_ID = @V_DEDUCTED_DIVISION_ID
					AND VERSION_NO = @v_version

					--MF_D 데이터를 생성한다.
					INSERT INTO DM_PLN_MKT_FCST_RESULT_C 
					( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
					, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
					, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
					, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
					, CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					)
					SELECT A.DIVISION_ID, @v_version AS VERSION_NO, 'MF_D' AS CUTOFF_TYPE, CONVERT(VARCHAR(8), GETDATE(), 112) AS CUTOFF_YYYYMMDD, A.PROJECT_CODE
						 , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
					 	 , A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
						 , A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
						 , A.CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					FROM DM_PLN_MKT_FCST_RESULT A WITH (NOLOCK)
					INNER JOIN #TEMP_DEDUCTED_ITEM B  WITH(NOLOCK)
					 		ON A.DIVISION_ID = B.DIVISION_ID
					  	   AND A.SCM_SITE_ID = B.SCM_SITE_ID
						   AND A.PROJECT_CODE = B.PROJECT_CODE
						   AND A.ITEM_ID = B.ITEM_ID
					WHERE A.MEASURE = 'RTF_SYS_RP'
					AND A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -14, dbo.FN_NEXT_DAY(CAST(GETDATE() as datetime), 'MON')), 112) --전주 월요일
					AND A.YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CAST(GETDATE() as datetime), 'MON')), 112)  --당주 월요일 이전
					
					SET @ROWCNT = @@ROWCOUNT	
					------------------------------------------------------------------------------------------------------------------------------------------------ 
					--[E20250404-001534]_데이터 존재하여 작업 시작 START	
					------------------------------------------------------------------------------------------------------------------------------------------------ 
					SET @v_log_type    = 'APPEND';  
					SET @v_log_message = N'지연빌링 VERSION CUTOFF';  
					SET @v_description = N'지연빌링 VERSION CUTOFF: ' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'  사업부: '+ @V_DEDUCTED_DIVISION_ID + N' VERSION_NO: ' + @v_version;	
					SET @d_event_date  = SYSDATETIME();
					SET @n_log_count   = @ROWCNT;
					EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
					-----------------------------------------------------------------------------------------------------------------------------------------------
					--[E20250404-001534]_데이터 존재하여 작업 시작 START	
					-----------------------------------------------------------------------------------------------------------------------------------------------
				END				
				--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
				--3). 23시에 실적이 발생하면 비교하는 프로시져를 실행한다.
				-- (1). 23시에 81 사업부인 경우 한번 더 실적을 받기 때문에 
				-- (2). 23시에 발생한 실적과 13시에 발생한 실적 MF_D로 보관한 데이터가 다른경우 MKT FCST에서 차감하기 위해 하단 작업을 진행한다. 
				-- (3). 매주 월요일 23-24시 사이에만 실행한다.
				--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
				IF (@V_STATES = 'DEDUCTED')
				/*================================================================================================================
				--룩업에 등록한 아이템에 대하여, 전주 실적이 발생하지 않은 건에 대해서는 실행할 필요가 없으므로, (전주만 비교하기로함)
				--전주 실적이 발생하지 않은 경우에 대해서는 실행 시키지 않는다. 
				================================================================================================================*/
				BEGIN
					------------------------------------------------------------------------------------------------------------------------------------------------ 
					--[E20250404-001534]_데이터 존재하여 작업 시작 START	
					------------------------------------------------------------------------------------------------------------------------------------------------ 
					SET @v_log_type    = 'APPEND';  
					SET @v_log_message = N'지연빌링 차감로직 시작';  
					SET @v_description = N'지연빌링 차감로직 시작: ' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'  사업부: '+ @V_DEDUCTED_DIVISION_ID + N' 요청상태: ' + @V_STATES;	
					SET @d_event_date  = SYSDATETIME();
					SET @n_log_count   = @ROWCNT;
					EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
					-----------------------------------------------------------------------------------------------------------------------------------------------
					--[E20250404-001534]_데이터 존재하여 작업 시작 START	
					-----------------------------------------------------------------------------------------------------------------------------------------------
					IF ( SELECT COUNT(1)
						 FROM DM_PLN_MKT_FCST_RESULT A WITH (NOLOCK)
						 INNER JOIN #TEMP_DEDUCTED_ITEM B  WITH(NOLOCK)
								 ON A.DIVISION_ID = B.DIVISION_ID
								AND A.SCM_SITE_ID = B.SCM_SITE_ID
								AND A.PROJECT_CODE = B.PROJECT_CODE
								AND A.ITEM_ID = B.ITEM_ID
						 WHERE A.MEASURE = 'RTF_SYS_RP'
						 AND A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -14, dbo.FN_NEXT_DAY(CAST(GETDATE() as datetime), 'MON')), 112) --전주 월요일
						 AND A.YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CAST(GETDATE() as datetime), 'MON')), 112)  --당주 월요일 이전
						 ) > 0
					BEGIN	
						EXEC PR_DM_PLN_MKT_FCST_DELAY_BILLING_AUTO_DEDUCTED @V_DEDUCTED_DIVISION_ID
					END		
				END	
			SET @I += 1	
		END
		------------------------------------------------------------------------------------------------------------------------------------------------ 
		--[E20250404-001534]_데이터 존재하여 작업 종료 START	
		------------------------------------------------------------------------------------------------------------------------------------------------ 
		SET @v_log_type    = 'APPEND';  
		SET @v_log_message = N'지연빌링 수행종료';  
		SET @v_description = N'지연빌링 수행종료: ' + CONVERT(NVARCHAR(30), GETDATE(), 121) + N'  사업부: '+ @V_DEDUCTED_DIVISION_ID + N' 요청상태: ' + @V_STATES;	
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @ROWCNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		-----------------------------------------------------------------------------------------------------------------------------------------------
		--[E20250404-001534]_데이터 존재하여 작업 시작 START	
		-----------------------------------------------------------------------------------------------------------------------------------------------
		SET @v_description = ''; 
	--[E20250404-001534]_[공급생산 SCM PI팀] 지연 빌링 발생 시 수요계획 보정 기능 개발 요청 END			

	print 'step-10'	

		IF DB_NAME() <> 'LGCE_SCMDEV'
		BEGIN
			-- 20181019 프로시져 호출 KPI_SALES_ACCURACY (매출계획 적확도/전월 마지막에 짠 당월 RTF 대비 당월 실적 값의 비율)
			EXEC  dbo.PR_DM_ANL_KPI_SALES_ACCURACY;

			-- 20181128 KHSONG PR_DM_ANL_KPI_SUMMARY 프로시져 호출추가
			EXEC  dbo.PR_DM_ANL_KPI_SUMMARY;
		END
		
		----------------------------------------------------------------------------------------------	
		
	print 'step-11'
		
		END TRY
		----------------------------------------------------------------------------------------------	

		----------------------------------------------------------------	
		BEGIN CATCH
		----------------------------------------------------------------	
		--[C20200909-000203] LOG 표준화 적용
		---- 트랜잭션 (END)
		ROLLBACK TRANSACTION SALES_RESULT_MAPPING;
		  -- ERROR LOG VALUE SAVE
		  SET @v_log_type = 'ERROR';
		  SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		  SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		  SET @d_event_date = SYSDATETIME();

		  SELECT '' + Convert(NVARCHAR(10), ERROR_NUMBER()) + '' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

		  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		----------------------------------------------------------------	
		END CATCH;
		----------------------------------------------------------------	

	---- 수행결과 성공여부 DISPLAY
 --   IF @v_log_message IS NULL
	--  SELECT 'success'
	--;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
