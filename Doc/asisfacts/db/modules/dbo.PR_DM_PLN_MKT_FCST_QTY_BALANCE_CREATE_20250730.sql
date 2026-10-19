

--PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_20250730 '81','1241'
--PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_20250730 '82',''
--PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_20250730 '81_UC','1241'
--[[[2627]PRIMARY KEY 제약 조건 'PK_DM_PLN_MKT_FCST'을(를) 위반했습니다. 개체 'dbo.DM_PLN_MKT_FCST'에 중복 키를 삽입할 수 없습니다. 중복 키 값은 (81, A15AI7001, Audi_DE_ING, APAAGIHEV-A1, E, MPS, FCA, SS_GAP, 20220718, G481-P)입니다.
/*=====================================================================================================================================================================
 * Program ID   : PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_20250730
 * Description  : RTF 산출하는 프로시져 
 *                방식 ① PLAN_ID가 들어오는경우: SCP 엔진 수행 후 SCP에서 호출
 *					   ② PLAN_ID가 NULL로 들어오는경우: 주1회 WEEKLY ROLLING 작업시 호출받은 경우임 (SP:PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING)
 *                     ③ PLAN_ID가 CALL로 들어오는 경우: MKT FCST 화면에서 저장시 호출하는 경우MKT_FCST값 저장시 특정대상만 전달받으며 호출된 경우임 (SP:DMF0003_SAVE_MKT_FCST)
 * Program History
 *=====================================================================================================================================================================
 *   Date       In Charge		Description
 *=====================================================================================================================================================================
 * 2018.05.14   JunHee Jeen
				/ KHSONG		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * -----------------------------------------------------------------------------------------------------------
 * 2018.06.07	KHSONG			Sales Plan AMT Create Procedure 호출추가 
 * 2018.06.11	ytchoi			한주가 지나면 화면에서 과거 RTF P 를 보기 어렵기 때문에 당주 월요일 이후로만 계산 함
 * 2018.06.14	KHSONG			CUTOFF RTF MEASURE 정보변경 로직 추가
 * 2018.06.18	KHSONG			CUTOFF TABLE BALANCE 값 재계산 로직 추가
 * 2018.08.20	KHSONG			BALANCE 생성로직 CURSOR에서 테이블구조로 수정
 * 2018.08.23	KHSONG			VMI재고 확인후 RTF 생성 로직, VMI DIO 계산로직 보완
 * 2018.09.27	KHSONG			DIO,BALANCE CURSOR제거 로직반영
 * 2018.10.02	KHSONG			PROCEDURE 에서 대상 전달받아 처리되는 로직 추가반영
 * 2018.10.11	KHSONG			CUTOFF테이블작업 호출추가
 * 2018.11.08	KHSONG			소형 반품예정수량(RMA) fcst_type인 경우에 RTF를 MKT_FCST와 동일하게 생성 조건추가
 * 2018.12.20	KHSONG			연말특정일 제외조건 추가 -> 20190110 KHSONG 주석처리
 *				KHSONG			소형 RTF_SCP 사용하는 시점을 조건으로 추가 -> 20190110 KHSONG 주석처리
 * 2019.01.11	KHSONG			소형 'RTF_SCP' MEASURE 적용
 * 2019.02.21					실적없이 BALANCE만 남아있는 데이터 삭제하기위하여 'RTF','BALANCE' MEASURE 추가함
 * 2019.06.24	KHSONG			[CSR_ID:4016234]자동차전지 사업부 RTF(Manual 입력) 메져 추가건 적용
								운영데이터 원격 사용부분 이관전에 삭제필요
 * 2019.07.09	KHSONG			[CSR ID:4027463] RTF_System[R+P] Measure 추가 요청의 건
 * 2019.07.09	KHSONG			[CSR ID:4034895] 상품 매출에 대한 마케팅의 RTF[R+P] 수정 권한 요청 및 MKT FCST 기본값 삭제 요청 (자동차사업부)
 * 2019.08.09	KHSONG			[CSR ID:4059971] VMI-In Request 로직 변경
 * 2019.11.04	KHSONG			[CSR ID:4107133] VMI대상 RTF_SYS_RP MEASURE 생성로직 추가
 * 2020.03.03	HWI1993			[CSR ID:C20200302-000164] SCP SHIP PLAN 이 생성되면 SCP_SHIP_PLAN 을 DM_PLN_SHIPMENT_REQ 에 복사하도록 DMF0045_SCPSHIPPLAN_TO_SHIPREQ 호출 추가
 * 2020.03.27	HWI1993			운영동기화
 * 2020.04.16	KHSONG			C20200413-000593 ESS사업부 RTF Measure 추가
 * 2020.06.15	hwi1993			C20200518-000359 GSCM RMA값 표기 로직 수정 요청의 건
 * 2020.07.01	P.C.I			[PJ20200138] [SCM PI팀] Sales Plan Waterfall cut-off 주기 변경 - SALES_PLAN_C 는 금요일에 한번 cutoff
								PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE_40 -> PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE 명칭 변경
 * 2020.08.27	P.C.I			[C20200827-000094] 자동차 전극(EE) RTF를 매출계획에 반영
 * 2020.08.28	P.C.I			[C20200827-000351] SSP Shipment Req 프로시저 호출 제외
 * 2020.09.09   P.C.I			[C20200909-000203] LOG 표준화 적용
 * 2020.11.13	hwi1993			[C20201103-000114] [SCM PI팀] ESS 사업부 판매 법인 VMI biz의 MKT FCST 입력 시 VMI in req 자동산출 로직 적용의 건  
 * 2020.12.07   P.C.I			[C20201207-000326] SCP에서 계획을 수립하지 않는 주차는 MKT Fcst에 RTF를 업데이트 하지 않음
 * 2020.12.08   P.C.I			[C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용
 * 2020.12.23	hwi1993			[C20201222-000376] VMI Inv 메저 수량 표시
 * 2021.02.15   P.C.I			[C20210215-000212] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용
 * 2021.03.29	hwi1993			[C20210323-000456] ESS 판매법인 VMI LT 반영
 * 2021.08.23	hwi1993			[중장기] 52주를 82주로 변경
 * 2021.09.29	hwi1993			[PJ20209643] W/S 프로세스 - AS_In_Plan, Req 추가
 * 2021.11.02   hwi1993			[PJ20209643] W/S 프로세스 
 * 2022.03.29   kdw2819			[C20220224-000448] ESS 사업부 VMI 기능 자동차사업부 확산 전개 요청 (VMI_IN_PLAN 으로 RTF 생성)
 * 2022.04.05   hwi1993			GM JV 작업
 * 2022.06.16	kdw2819			[C20220615-000414] RESU16H_Prime RTF 에러의 건
 * 2022.06.30	HWI1993			[C20220615-000093] [영업마케팅PI] MKT_FCST Waterfall 內 SaftyStock LevelGap measure 추가 요청 건
 * 2022.07.20	HWI1993			[C20220615-000414] RESU16H_Prime RTF 에러의 건 - RTF 중복오류 수정
 * 2022.10.17	rosia27			[C20221004-000309] ERP 피킹실적 VMI In plan(R+P) 실적 반영 요청 건
 * 2022.11.08	HWI1993			[C20221107-000257] UC법인 RTF누락 건 
 * 2022.11.08	hwi1993			[C20221104-000430] UC법인 MKT FCST화면의 'Balance' Measure 로직 변경 요청의 件 -- 보류(원복함)
 * 2022.12.02	hwi1993			[C20221104-000430] UC법인 MKT FCST화면의 'Balance' Measure 로직 변경 요청의 件
 * 2022.12.06	HWI1993			[C20221207-000259] VMI 재고 계산시 소형사업부만 11자리 LIKE 먹도록 변경
 * 2022.12.07	hwi1993			[C20221207-000280] 원복 [C20221004-000309]
 * 2024.01.26	JSSBAE			[E20240102-000530]_[마케팅PI팀] VMI Inv 데이터 - PJT Code 매핑 개선
 * 2024.06.10	KCW3408			이동계획(SCP_PLN_RTF_ALLOCATION_V 테이블 에서 ITEM_ID를 가져오는 기준 변경,FROM_ITEM_ID가 존재시 먼저가져옴)          
 * 2024.08.20	JSSBAE			[E20240716-000662]_81_HD신규 Division SCM.DM에 셋팅 요청드립니다.
 * 2024.11.15	KANG.H.J		[PJ2024-50611] 소형 매출 프로세스 개선	
 * 2024.12.01	KANG.H.J		[PJ2024-50611] BPS 매출(RTF_SYS_RP Measrue) 전송 시 전 사업부 FROM_SITE_ID 추가
 * 2024.12.11	JSSBAE			[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청
 * 2025.01.16	JSSBAE			[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청
 * 2025.02.23	JSSBAE			[E20250210-000219]_SCP 엔진 재수행에 따른 Sales Plan Cutoff 재수행 자동화
 * 2025.03.05	KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화
 * 2025.03.07	JSSBAE			[E20250307-001264]_40사업부 Sales Plan Cutoff 수행 조건 변경
 * 2025.03.20	JSSBAE			[E20250318-000623]_81_HG 사업부 셋팅 및 모듈간 연계테스트 요청
 * 2025.03.24	JSSBAE			[E20250321-001569]_Sales Plan Cutoff 자동 재수행 로직 개선
 * 2025.03.05	KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선 - EE_FN 수행시 RTF UPDATE 제외
 * 2025.04.08	KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제처리
 * 2025.04.18	JSSBAE			[E20250418-001548]_40사업부 Sales Plan Cutoff 시 Cell Prod Site 칼럼 적용
 * 2025.04.23	KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선 - SF_W도 PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE
 * 2025.04.28	KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선 - BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
 * 2025.05.08	KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선 - BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성) 보완
 * 2025.05.19	KANG.H.J		[PJ2025-50188] 기준수요 - RMA 등등 MKT_FCST 기반으로 RTF 생성하는 로직에서 40사업부는 SCM_FCST / 그외는 MKT_FCST로 정의함.
 * 2025.05.20	KANG.H.J		[PJ2025-50188] BALANCE MEASURE에 CELL_PROD_SITE_ID 고려
 * 2025.05.29	JSSBAE			[E20250529-001353]_Sales Plan Cutoff 자동 재수행 로직 개선
 * 2025.05.30	KANG.H.J		[PJ2025-50188] 임시테이블 #T_MKT_FCST DROP 추가, 임시테이블 #T_MKT_FCST ==> #T_MF_BALANCE_MKT_FCST 변경
 * 2025.06.02	KANG.H.J		[PJ2025-50188] EE_FN의 경우 VMI_IN_PLAN도 업데이트 처리
 * 2025.06.05	JSSBAE			[E20250529-001289]_DM 장애 대응 개선을 위한 시스템 개선
 * 2025.06.02	KANG.H.J		[PJ2025-50188] EE_FN의 경우 CURRENT는 RTF_SYS_RP 업데이트 / CUTOFF는 유지 ==> CURRENT는 EE_FN 불필요
 * 2025.06.09	KANG.H.J		[PJ2025-50188] EE_FN의 current 소스 원복 (EE_FN 변수 및 분기문 모두 삭제)
 * 2025.06.10	KANG.H.J		[PJ2025-50188] 임시테이블 #T_SCP_PLN_RTF_ALLOCATION_V DROP 추가
 * 2025.06.11	KANG.H.J		[PJ2025-50188] 임시테이블 #T_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_RTF_ALLOCATION 이름변경
=====================================================================================================================================================================*/

CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_20250730]
	  @p_division_id			NVARCHAR(30)  -- DIVISION_ID 값은 필수
	, @p_plan_id				NVARCHAR(30)  -- plan_id, NULL,'CALL' 값을 받아 구분하여 처리함
AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_20250730';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

    DECLARE @batch_call_yn                NVARCHAR(01) = 'N'
    DECLARE @max_plan_id                  NVARCHAR(30);
    DECLARE @plan_start_yyyymmdd          NVARCHAR(08);
    DECLARE @c_division_id                NVARCHAR(30);
    DECLARE @c_plan_id                    NVARCHAR(30);
    DECLARE @c_plan_start_yyyymmdd        NVARCHAR(08);
    DECLARE @c_VERSION_NO				  NVARCHAR(50);
    DECLARE @c_cutoff_type				  NVARCHAR(10);
    DECLARE @c_cutoff_yyyymmdd			  NVARCHAR(08);
    DECLARE @c_scp_division_id		      NVARCHAR(30);	--[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(SCP Division)
	DECLARE @c_scp_rtf_flag 		      NVARCHAR(02); --[C20201207-000326] SCP에서 계획을 수립하지 않는 주차는 MKT Fcst에 RTF를 업데이트 하지 않음
	
    DECLARE @max_plan_start_yyyymmdd	  NVARCHAR(08); --[C20210215-000212] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용
	DECLARE @plan_week_cnt				  INT;			-- 중장기 계획 주차 기간

	DECLARE @v_measure					  NVARCHAR(30);	-- [PJ2025-50188] 40사업부는 SCM_FCST / 그외는 MKT_FCST.

	-------------------------------------------------------------------------------------------------------------------------------------------	
	-- 변수값 셋팅
	-------------------------------------------------------------------------------------------------------------------------------------------	
	SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주월요일 (한주가 지나면 화면에서 과거 RTF P 를 보기 어렵기 때문에 당주 월요일 이후로만 계산 함)
	SET @c_plan_start_yyyymmdd  = @plan_start_yyyymmdd
	SET @c_division_id          = @p_division_id
	SET @c_scp_division_id		= @p_division_id	-- [C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(SCP Division)

	IF @p_plan_id IS NULL
		BEGIN
			SET @p_plan_id = ''
			SET @batch_call_yn = 'Y'
		END

	--[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(SCP Division)
	--[E20241211-000856]_40사업부 전극 RTF 적용가능하도록 수정요청으로 EE로 들어오는 건에 대해 해결 방안을 수정한다. START
	IF (@p_plan_id  <>  'CALL')
	BEGIN
		IF @c_division_id = 'EE' 
		BEGIN
			set @c_division_id = '40'
			SET @c_scp_division_id = 'EE'
		END
	--[E20241211-000856]_40사업부 전극 RTF 적용가능하도록 수정요청으로 EE로 들어오는 건에 대해 해결 방안을 수정한다. END
	--근데 EE로 DIVISION_ID해서 2개 이상 들어오면 어쩌지? TOP 1로 써야하나 고민이 필요하다.
	/*
	IF @c_division_id = 'EE' 
		BEGIN
			SET @c_division_id = '81'
			SET @c_scp_division_id = 'EE'
		END
	*/
	ELSE IF @c_division_id = 'EE_UC' 
		BEGIN
			SET @c_division_id = '81_UC'
			SET @c_scp_division_id = 'EE_UC'
		END
	ELSE IF @c_division_id = 'EE_HM' 
		BEGIN
			SET @c_division_id = '81_HM'
			SET @c_scp_division_id = 'EE_HM'
		END
	/* [SM]20240222 : 81_ST 신규사업부추가건 선조치 */
	ELSE IF @c_division_id = 'EE_ST' 
		BEGIN
			SET @c_division_id = '81_ST'
			SET @c_scp_division_id = 'EE_ST'
		END
	/* [E20240716-000662]_81_HD신규 Division SCM.DM에 셋팅 요청드립니다.*/
	ELSE IF @c_division_id = 'EE_HD' 
		BEGIN
			SET @c_division_id = '81_HD'
			SET @c_scp_division_id = 'EE_HD'
		END
	/* [E20250318-000623]_81_HG 사업부 셋팅 및 모듈간 연계테스트 요청 */
	ELSE IF @c_division_id = 'EE_HG' 
		BEGIN
			SET @c_division_id = '81_HG'
			SET @c_scp_division_id = 'EE_HG'
		END
	END

	-- 중장기 계획 주차 기간
	SELECT @plan_week_cnt = ATTRIBUTE1
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
	WHERE LOOKUP_TYPE = 'DM_LONG_PLAN_WEEK_CNT'
	AND VALID_YN = 'Y'
	AND SEGMENT1 = @c_division_id

	IF @plan_week_cnt IS NULL
	BEGIN
		SET @plan_week_cnt = 54;
	END

	-- [PJ2025-50188] 40사업부는 SCM_FCST / 그외는 MKT_FCST.
	IF @p_division_id = '40' 
	BEGIN
		SET @v_measure = 'SCM_FCST';
	END
	ELSE 
	BEGIN
		SET @v_measure = 'MKT_FCST';
	END

	-------------------------------------------------------------------------------------------------------------------------------------------	

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########11';
    SET @v_description = '@p_division_id : ' + ISNULL(@p_division_id,'NULL') + ' / ' + '@p_plan_id : ' + ISNULL(@p_plan_id,'NULL');
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		--BEGIN TRANSACTION MKT_FCST_QTY_BALANCE_CREATE;

		--------------------------------------------------------------------------------------------	
		BEGIN TRY
		--------------------------------------------------------------------------------------------	
		/* -- 20190110 KHSONG 주석처리
		IF CONVERT(VARCHAR(8), GETDATE(), 112) BETWEEN '20181226' AND '20190110' -- 20181220 KHSONG 연말특정일 제외조건 추가 => 12/24주차, 12/31주차에 자동차,소형,ESS SCP 타겟 인터페이스가 없음.(SCP팀 계획 미수립)
		   AND @p_plan_id  <>  'CALL'  -- 20181220 KHSONG MKT_FCST 값 저장시 호출되는 케이스는 제외
			BEGIN
				SET @v_log_type = 'INVALID';
				SET @v_description = N'2018/12/26~2019/01/10까지 수행하지않음!  '+'@p_division_id : ' + ISNULL(@p_division_id,'NULL') + ' / ' + '@p_plan_id : ' + ISNULL(@p_plan_id,'NULL')
				GOTO ERR_RTN
			END
		ELSE
		*/

		
		--Start[C20201207-000326] SCP에서 계획을 수립하지 않는 주차는 MKT Fcst에 RTF를 업데이트 하지 않음
		--Start [C20210215-000212] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용
		/*SET @c_scp_rtf_flag = ( SELECT ISNULL(MAX(dm_rtf_yn), 'Y')
								FROM   scp_pln_interface_yn with(nolock)
								WHERE  division_id         = @c_scp_division_id
								AND    plan_start_yyyymmdd = @plan_start_yyyymmdd);

		IF (@c_scp_rtf_flag = 'N' AND @p_plan_id <> 'CALL') 			
			BEGIN
				SET @v_log_type = 'ING';
				SET @v_log_message = N'SCP에서 계획을 수립하지 않는 주차는 MKT Fcst에 RTF를 업데이트 하지 않음';
				SET @v_description = '@p_division_id : ' + ISNULL(@p_division_id,'NULL') + ' / ' + '@p_plan_id : ' + ISNULL(@p_plan_id,'NULL');
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			END
			
		ELSE*/ --End [C20201207-000326] SCP에서 계획을 수립하지 않는 주차는 MKT Fcst에 RTF를 업데이트 하지 않음
		--End [C20210215-000212] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용
			BEGIN


				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                                                                                                TEMP TABLE SETTING (START)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				BEGIN
				-------
				--PRINT 'TEMP TABLE SETTING START                      =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)

				IF OBJECT_ID (N'tempdb..#T_results', N'U') IS NOT NULL 
					DROP TABLE #T_results
				IF OBJECT_ID (N'tempdb..#T_MST_ACCUM', N'U') IS NOT NULL 
					DROP TABLE #T_MST_ACCUM
				IF OBJECT_ID (N'tempdb..#T_MST', N'U') IS NOT NULL 
					DROP TABLE #T_MST
				IF OBJECT_ID (N'tempdb..#T_TEMPX', N'U') IS NOT NULL 
					DROP TABLE #T_TEMPX
				IF OBJECT_ID (N'tempdb..#T_VMI_MST', N'U') IS NOT NULL 
					DROP TABLE #T_VMI_MST
				IF OBJECT_ID (N'tempdb..#T_VMI_MST_MAIN', N'U') IS NOT NULL 
					DROP TABLE #T_VMI_MST_MAIN
				IF OBJECT_ID (N'tempdb..#T_VMI_TEMP1', N'U') IS NOT NULL 
					DROP TABLE #T_VMI_TEMP1
				IF OBJECT_ID (N'tempdb..#T_VMI_TEMP2', N'U') IS NOT NULL 
					DROP TABLE #T_VMI_TEMP2
				IF OBJECT_ID (N'tempdb..#T_VMI_TEMP_all', N'U') IS NOT NULL 
					DROP TABLE #T_VMI_TEMP_all
				IF OBJECT_ID (N'tempdb..#T_MKT_FCST_INSERT', N'U') IS NOT NULL 
					DROP TABLE #T_MKT_FCST_INSERT
				-- [C20200827-000094] 임시테이블 삭제
				IF OBJECT_ID (N'tempdb..#T_cutoff', N'U') IS NOT NULL 
					DROP TABLE #T_cutoff
				IF OBJECT_ID (N'tempdb..#FP_STOCK_QTY', N'U') IS NOT NULL 
					DROP TABLE #FP_STOCK_QTY
				IF OBJECT_ID (N'tempdb..#T_SSLVL', N'U') IS NOT NULL 
					DROP TABLE #T_SSLVL
				-- [PJ2024-50611] RTF_ALLOC Insert Temp 테이블
				IF OBJECT_ID (N'tempdb..#T_RTF_ALLOC_INSERT', N'U') IS NOT NULL 
					DROP TABLE #T_RTF_ALLOC_INSERT
				-- [PJ2025-50017] CFM_DEMAND Insert Temp 테이블
				IF OBJECT_ID (N'tempdb..#T_CFM_DEMAND_INSERT', N'U') IS NOT NULL 
					DROP TABLE #T_CFM_DEMAND_INSERT
				-- [PJ2025-50188] 임시테이블 #T_MKT_FCST ==> #T_MF_BALANCE_MKT_FCST 변경
				IF OBJECT_ID (N'tempdb..#T_MF_BALANCE_MKT_FCST', N'U') IS NOT NULL 
					DROP TABLE #T_MF_BALANCE_MKT_FCST
				-- [PJ2025-50188] 임시테이블 #T_SCP_PLN_RTF_ALLOCATION_V DROP
				--IF OBJECT_ID (N'tempdb..#T_SCP_PLN_RTF_ALLOCATION_V', N'U') IS NOT NULL 
				--	DROP TABLE #T_SCP_PLN_RTF_ALLOCATION_V

				-- [PJ2025-50188] 임시테이블 #T_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_RTF_ALLOCATION 이름변경
				IF OBJECT_ID (N'tempdb..#T_MF_RTF_ALLOCATION', N'U') IS NOT NULL 
					DROP TABLE #T_MF_RTF_ALLOCATION


 PRINT ( @v_program_name + ' A001: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	

				CREATE TABLE #T_results  (							-- [PJ2025-50017] BALACE 계산시 UI에서 호출할 때는 #T_results로 처리
							division_id      NVARCHAR(30) NOT NULL
						,project_code     NVARCHAR(50) NOT NULL
						,scm_site_id      NVARCHAR(30) NOT NULL
						,item_id          NVARCHAR(50) NOT NULL
						,dom_exp          NVARCHAR(03) NOT NULL
						,fcst_type        NVARCHAR(20) NOT NULL
						,incoterms        NVARCHAR(10) NOT NULL
						,plant_site_id    NVARCHAR(30) NOT NULL
						,vmi_yn		      NVARCHAR(01)  NULL
						,CELL_PROD_SITE_ID	NVARCHAR(30)  NULL  -- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
						,FROM_SITE_ID		NVARCHAR(30)  NULL  -- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
										)
							   
				CREATE CLUSTERED INDEX [IDX_RESULTS_N1] ON [#T_results]
				(
						division_id ASC
					,project_code ASC
					,scm_site_id ASC
					,item_id ASC
					,dom_exp ASC
					,fcst_type ASC
					,incoterms ASC
					,plant_site_id ASC
					,vmi_yn			 ASC
					,CELL_PROD_SITE_ID	ASC						-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				;


				CREATE TABLE  #T_MST_ACCUM
					(DIVISION_ID	NVARCHAR(30) NOT NULL
					,PROJECT_CODE	NVARCHAR(50) NOT NULL
					,SCM_SITE_ID	NVARCHAR(30) NOT NULL
					,ITEM_ID		NVARCHAR(50) NOT NULL
					,DOM_EXP		NVARCHAR(03) NOT NULL
					,FCST_TYPE		NVARCHAR(20) NOT NULL
					,INCOTERMS		NVARCHAR(10) NOT NULL
					,PLANT_SITE_ID  NVARCHAR(30) NOT NULL
					,YYYYMMDD		NVARCHAR(08) NOT NULL
					,MEASURE		NVARCHAR(50) NOT NULL
					,QTY			NUMERIC(30,10) NOT NULL
					,CELL_PROD_SITE_ID	NVARCHAR(30)  NULL  -- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
					,FROM_SITE_ID		NVARCHAR(30)  NULL  -- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
					,ACCUM_SUM		NUMERIC(30,10) NOT NULL
					)
				CREATE CLUSTERED INDEX [IDX_T_MST_ACCUM] ON [#T_MST_ACCUM]
				(
						DIVISION_ID ASC
					,PROJECT_CODE ASC
					,SCM_SITE_ID ASC
					,ITEM_ID ASC
					,DOM_EXP ASC
					,FCST_TYPE ASC
					,INCOTERMS ASC
					,PLANT_SITE_ID ASC
					,YYYYMMDD ASC
					,MEASURE ASC
					,CELL_PROD_SITE_ID ASC
				)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
				;

				CREATE TABLE  #T_MST
					(DIVISION_ID	NVARCHAR(30) NOT NULL
					,PROJECT_CODE	NVARCHAR(50) NOT NULL
					,SCM_SITE_ID	NVARCHAR(30) NOT NULL
					,ITEM_ID		NVARCHAR(50) NOT NULL
					,DOM_EXP		NVARCHAR(03) NOT NULL
					,FCST_TYPE		NVARCHAR(20) NOT NULL
					,INCOTERMS		NVARCHAR(10) NOT NULL
					,PLANT_SITE_ID  NVARCHAR(30) NOT NULL
					,YYYYMMDD		NVARCHAR(08) NOT NULL
					,MEASURE		NVARCHAR(50) NOT NULL
					,QTY			NUMERIC(30,10) NOT NULL
					,CELL_PROD_SITE_ID  NVARCHAR(30)  NULL	-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
					,FROM_SITE_ID		NVARCHAR(30)  NULL  -- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
					)

				CREATE CLUSTERED INDEX [IDX_MST_N1] ON [#T_MST]
				(
						DIVISION_ID ASC
					,PROJECT_CODE ASC
					,SCM_SITE_ID ASC
					,ITEM_ID ASC
					,DOM_EXP ASC
					,FCST_TYPE ASC
					,INCOTERMS ASC
					,PLANT_SITE_ID ASC
					,YYYYMMDD ASC
					,MEASURE ASC
					,CELL_PROD_SITE_ID ASC			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
				;


				CREATE TABLE  #T_TEMPX
				(DIVISION_ID	NVARCHAR(30) NOT NULL
				,PROJECT_CODE	NVARCHAR(50) NOT NULL
				,SCM_SITE_ID	NVARCHAR(30) NOT NULL
				,ITEM_ID		NVARCHAR(50) NOT NULL
				,DOM_EXP		NVARCHAR(03) NOT NULL
				,FCST_TYPE		NVARCHAR(20) NOT NULL
				,INCOTERMS		NVARCHAR(10) NOT NULL
				,PLANT_SITE_ID  NVARCHAR(30) NOT NULL
				,MEASURE		NVARCHAR(50) NOT NULL
				,YYYYMMDD		NVARCHAR(08) NOT NULL
				,CELL_PROD_SITE_ID  NVARCHAR(30)  NULL	-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				,FROM_SITE_ID		NVARCHAR(30)  NULL  -- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				,ACCUM_X		NUMERIC(30,10) NOT NULL
				)

				CREATE CLUSTERED INDEX [IDX_TEMPX_N1] ON [#T_TEMPX]
				(
					DIVISION_ID ASC
				,PROJECT_CODE ASC
				,SCM_SITE_ID ASC
				,ITEM_ID ASC
				,DOM_EXP ASC
				,FCST_TYPE ASC
				,INCOTERMS ASC
				,PLANT_SITE_ID ASC
				,MEASURE ASC
				,YYYYMMDD ASC
				,CELL_PROD_SITE_ID ASC			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				;

				CREATE TABLE  #T_VMI_MST
				(
				DIVISION_ID	NVARCHAR(30) NOT NULL
				,PROJECT_CODE	NVARCHAR(50) NOT NULL
				,SCM_SITE_ID	NVARCHAR(30) NOT NULL
				,ITEM_ID		NVARCHAR(50) NOT NULL
				,DOM_EXP		NVARCHAR(03) NOT NULL
				,FCST_TYPE		NVARCHAR(20) NOT NULL
				,INCOTERMS		NVARCHAR(10) NOT NULL
				,PLANT_SITE_ID  NVARCHAR(30) NOT NULL
				,MEASURE		NVARCHAR(50) NOT NULL
				,YYYYMMDD		NVARCHAR(08) NOT NULL
				,QTY			NUMERIC(30,10) NOT NULL
				,CELL_PROD_SITE_ID  NVARCHAR(30)  NULL	-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				,FROM_SITE_ID		NVARCHAR(30)  NULL  -- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				)

				CREATE CLUSTERED INDEX [IDX_MST_N1] ON [#T_VMI_MST]
				(
					DIVISION_ID ASC
				,PROJECT_CODE ASC
				,SCM_SITE_ID ASC
				,ITEM_ID ASC
				,DOM_EXP ASC
				,FCST_TYPE ASC
				,INCOTERMS ASC
				,PLANT_SITE_ID ASC
				,MEASURE ASC
				,YYYYMMDD ASC
				,CELL_PROD_SITE_ID  ASC			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				;
				CREATE TABLE  #T_VMI_MST_MAIN
				(DIVISION_ID	NVARCHAR(30) NOT NULL
				,PROJECT_CODE	NVARCHAR(50) NOT NULL
				,SCM_SITE_ID	NVARCHAR(30) NOT NULL
				,ITEM_ID		NVARCHAR(50) NOT NULL
				,DOM_EXP		NVARCHAR(03) NOT NULL
				,FCST_TYPE		NVARCHAR(20) NOT NULL
				,INCOTERMS		NVARCHAR(10) NOT NULL
				,PLANT_SITE_ID  NVARCHAR(30) NOT NULL
				,MEASURE		NVARCHAR(50) NOT NULL
				,YYYYMMDD		NVARCHAR(08) NOT NULL
				,QTY			NUMERIC(30,10) NOT NULL
				,CELL_PROD_SITE_ID  NVARCHAR(30)  NULL	-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				,FROM_SITE_ID		NVARCHAR(30)  NULL  -- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				)

				CREATE CLUSTERED INDEX [IDX_MST_MAIN_N1] ON [#T_VMI_MST_MAIN]
				(
					DIVISION_ID ASC
				,PROJECT_CODE ASC
				,SCM_SITE_ID ASC
				,ITEM_ID ASC
				,DOM_EXP ASC
				,FCST_TYPE ASC
				,INCOTERMS ASC
				,PLANT_SITE_ID ASC
				,MEASURE ASC
				,YYYYMMDD ASC
				,CELL_PROD_SITE_ID	ASC			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				;


				CREATE TABLE  #T_VMI_TEMP1
				(DIVISION_ID		NVARCHAR(30) NOT NULL
				,PROJECT_CODE		NVARCHAR(50) NOT NULL
				,SCM_SITE_ID		NVARCHAR(30) NOT NULL
				,ITEM_ID			NVARCHAR(50) NOT NULL
				,DOM_EXP			NVARCHAR(03) NOT NULL
				,FCST_TYPE			NVARCHAR(20) NOT NULL
				,INCOTERMS			NVARCHAR(10) NOT NULL
				,PLANT_SITE_ID		NVARCHAR(30) NOT NULL
				,YYYYMMDD			NVARCHAR(08) NOT NULL
				,MEASURE			NVARCHAR(50) NOT NULL
				,QTY				NUMERIC(30,10) NOT NULL
				,ACCUM_SUM			NUMERIC(30,10) NOT NULL
				,last_accum_sum		NUMERIC(30,10) NOT NULL
				,CELL_PROD_SITE_ID  NVARCHAR(30)  NULL		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				,FROM_SITE_ID		NVARCHAR(30)  NULL		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				)

				CREATE CLUSTERED INDEX [IDX_40_TEMP1_N1] ON [#T_VMI_TEMP1]
				(
					DIVISION_ID ASC
				,PROJECT_CODE ASC
				,SCM_SITE_ID ASC
				,ITEM_ID ASC
				,DOM_EXP ASC
				,FCST_TYPE ASC
				,INCOTERMS ASC
				,PLANT_SITE_ID ASC
				,YYYYMMDD ASC
				,MEASURE ASC
				,CELL_PROD_SITE_ID ASC					-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				;
				CREATE TABLE  #T_VMI_TEMP2
				(DIVISION_ID		NVARCHAR(30) NOT NULL
				,PROJECT_CODE		NVARCHAR(50) NOT NULL
				,SCM_SITE_ID		NVARCHAR(30) NOT NULL
				,ITEM_ID			NVARCHAR(50) NOT NULL
				,DOM_EXP			NVARCHAR(03) NOT NULL
				,FCST_TYPE			NVARCHAR(20) NOT NULL
				,INCOTERMS			NVARCHAR(10) NOT NULL
				,PLANT_SITE_ID		NVARCHAR(30) NOT NULL
				,YYYYMMDD			NVARCHAR(08) NOT NULL
				,MEASURE			NVARCHAR(50) NOT NULL
				,QTY				NUMERIC(30,10) NOT NULL
				,ACCUM_SUM			NUMERIC(30,10) NOT NULL
				,last_accum_sum		NUMERIC(30,10) NOT NULL
				,CELL_PROD_SITE_ID  NVARCHAR(30)  NULL		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				,FROM_SITE_ID		NVARCHAR(30)  NULL		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				)

				CREATE CLUSTERED INDEX [IDX_40_TEMP2_N1] ON [#T_VMI_TEMP2]
				(
					DIVISION_ID ASC
				,PROJECT_CODE ASC
				,SCM_SITE_ID ASC
				,ITEM_ID ASC
				,DOM_EXP ASC
				,FCST_TYPE ASC
				,INCOTERMS ASC
				,PLANT_SITE_ID ASC
				,YYYYMMDD ASC
				,MEASURE ASC
				,CELL_PROD_SITE_ID ASC					-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				;
				CREATE TABLE  #T_VMI_TEMP_all
				(DIVISION_ID		NVARCHAR(30) NOT NULL
				,PROJECT_CODE		NVARCHAR(50) NOT NULL
				,SCM_SITE_ID		NVARCHAR(30) NOT NULL
				,ITEM_ID			NVARCHAR(50) NOT NULL
				,DOM_EXP			NVARCHAR(03) NOT NULL
				,FCST_TYPE			NVARCHAR(20) NOT NULL
				,INCOTERMS			NVARCHAR(10) NOT NULL
				,PLANT_SITE_ID		NVARCHAR(30) NOT NULL
				,YYYYMMDD			NVARCHAR(08) NOT NULL
				,RTF_QTY			NUMERIC(30,10) NOT NULL
				,INV				NUMERIC(30,10) NOT NULL
				,CELL_PROD_SITE_ID  NVARCHAR(30)  NULL	-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				,FROM_SITE_ID		NVARCHAR(30)  NULL	-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
				)

				CREATE CLUSTERED INDEX [IDX_40_TEMP_all_N1] ON [#T_VMI_TEMP_all]
				(
					DIVISION_ID ASC
				,PROJECT_CODE ASC
				,SCM_SITE_ID ASC
				,ITEM_ID ASC
				,DOM_EXP ASC
				,FCST_TYPE ASC
				,INCOTERMS ASC
				,PLANT_SITE_ID ASC
				,YYYYMMDD ASC
				,CELL_PROD_SITE_ID ASC
				)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				;
				-- CUTOFF용 TEMP TABLE (START)

				CREATE TABLE #T_cutoff  (VERSION_NO			NVARCHAR(30) NOT NULL)

				---- AS Inv 계산을 위한 테이블
				--CREATE TABLE #T_AS_INV (
				--	DIVISION_ID		NVARCHAR(30) NOT NULL
				--, PROJECT_CODE		NVARCHAR(50) NOT NULL
				--, SCM_SITE_ID		NVARCHAR(30) NOT NULL
				--, ITEM_ID			NVARCHAR(50) NOT NULL
				--, DOM_EXP			NVARCHAR(03) NOT NULL
				--, FCST_TYPE			NVARCHAR(20) NOT NULL
				--, INCOTERMS			NVARCHAR(10) NOT NULL
				--, MEASURE			NVARCHAR(50) NOT NULL
				--, YYYYMMDD			NCHAR(8)	
				--, PLANT_SITE_ID		NVARCHAR(30) NOT NULL
				--, QTY				NUMERIC(30,10)
				--, SITE_SEQ			INT
				--)

				-- SAFETY STOCK LEVEL 처리용
				CREATE TABLE #T_SSLVL (
				DIVISION_ID			NVARCHAR(30) NOT NULL
				,SCM_SITE_ID		NVARCHAR(30) NOT NULL
				,ITEM_ID			NVARCHAR(50) NOT NULL
				,PROJECT_CODE		NVARCHAR(50) NOT NULL
				,INCOTERMS			NVARCHAR(10) NOT NULL
				,PLANT_SITE_ID		NVARCHAR(30) NOT NULL
				,DOM_EXP			NVARCHAR(03) NOT NULL
				)

				-- [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN / DM_PLN_MKT_FCST  ==>  임시테이블에 담음
				-- [PJ2025-50188] 임시테이블 #T_MKT_FCST ==> #T_MF_BALANCE_MKT_FCST 변경
				CREATE TABLE #T_MF_BALANCE_MKT_FCST (
								DIVISION_ID        nvarchar(30)   
							,PROJECT_CODE       nvarchar(50)   
							,SCM_SITE_ID        nvarchar(30)   
							,ITEM_ID            nvarchar(50)   
							,DOM_EXP            nvarchar(3)    
							,FCST_TYPE          nvarchar(20)   
							,INCOTERMS          nvarchar(10)   
							,PLANT_SITE_ID      nvarchar(30)   
							,CELL_PROD_SITE_ID  nvarchar(30)				
							,FROM_SITE_ID		nvarchar(30)				
							,MEASURE        	nvarchar(50)				
							,YYYYMMDD           nvarchar(8)    
							,QTY                numeric(20, 10)
				)
				;

				-- CUTOFF용 TEMP TABLE (END)
				-------
				END
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                                                                                                TEMP TABLE SETTING (END)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                                                                                                          대상추출 (START)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				IF  @p_plan_id  =  'CALL'  -- PROCEDURE에서 호출된 케이스일경우 (20181002 KHSONG PROCEDURE 에서 대상 전달받아 처리되는 로직 추가반영)
					BEGIN
 PRINT ( @v_program_name + ' A002: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )							
						
						INSERT  INTO  #T_results
									(division_id   
									,project_code  
									,scm_site_id   
									,item_id       
									,dom_exp       
									,fcst_type     
									,incoterms   
									,plant_site_id 
									,vmi_yn
									,CELL_PROD_SITE_ID			-- [PJ2025-50017] 추가 
									,FROM_SITE_ID				-- [PJ2025-50017] 추가 
									)
						SELECT		 DISTINCT 
										division_id   
									,project_code  
									,scm_site_id   
									,item_id       
									,dom_exp       
									,fcst_type     
									,incoterms   
									,plant_site_id 
									,vmi_yn
									,CELL_PROD_SITE_ID			-- [PJ2025-50188] 40 사업부는 CELL_PROD_SITE_ID / 그 외 '-' 	
									,'-'		AS FROM_SITE_ID
						FROM #SEND_TARGET_DATA  WITH(NOLOCK)  -- 40 (PR_DM_PLN_CFM_TO_MKT_FCST) / 그외 (DMF0003_SAVE_MKT_FCST). 공통 (PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_20250730_BATCH)
						WHERE 1=1
						AND FCST_TYPE <> 'RMA'  --20181108						


					END
				ELSE
					BEGIN
					-------
						-------------------------------------------------------------------------------------------------------------------------------------------	
						IF @p_plan_id = ''  -- @p_plan_id 값이 없는경우
							BEGIN
								--20240530
								SET @max_plan_id = ISNULL((SELECT MAX(plan_id) FROM [SCP_PLN_RTF_ALLOCATION_V] WITH(NOLOCK)  -- plan_id 추출
													WHERE division_id = @p_division_id),'')
								set @p_plan_id = @max_plan_id
							END
						-------------------------------------------------------------------------------------------------------------------------------------------	
						
 PRINT ( @v_program_name + ' A003: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )		
						-------------------------------------------------------------------------------------------------------------------------------------------	
						-- DIVISION_ID, plan_id 값이 없으면 수행하지 않음
						-------------------------------------------------------------------------------------------------------------------------------------------	
						IF  (SELECT COUNT(1) FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id) = 0 OR @p_plan_id = ''
							BEGIN
								SET @v_log_type = 'INVALID';
								SET @v_description = '@p_division_id : ' + ISNULL(@p_division_id,'NULL') + ' / ' + '@p_plan_id : ' + ISNULL(@p_plan_id,'NULL')
								GOTO ERR_RTN
							END
						-------------------------------------------------------------------------------------------------------------------------------------------	

						-------------------------------------------------------------------------------------------------------------------------------------------	
						--사용할 변수값 셋팅
						-------------------------------------------------------------------------------------------------------------------------------------------	

						--Start [C20210215-000212] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용
						SET @max_plan_start_yyyymmdd = ISNULL(( SELECT MAX(plan_start_yyyymmdd) 
																--20240530
																FROM [SCP_PLN_RTF_ALLOCATION_V] WITH(NOLOCK)  -- plan_id 추출
																WHERE division_id = @p_division_id
																AND   plan_id	  = @p_plan_id),'')
													
						SET @c_scp_rtf_flag = ( SELECT ISNULL(MAX(dm_rtf_yn), 'Y')
												FROM   [dbo].scp_pln_interface_yn with(nolock)
												WHERE  division_id         = @c_scp_division_id
												AND    plan_start_yyyymmdd = @max_plan_start_yyyymmdd);

						IF (@c_scp_rtf_flag = 'N') 			
							BEGIN

								-- [C20210215-000212] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용
								SET @c_plan_id =  (select MAX(PLAN_ID)
													--20240530
													from   [dbo].SCM_MST_PLAN with(nolock)
													where  division_id = @p_division_id
													and    plan_cycle  = 'WEEKLY'
													and    PLAN_NAME   = (SELECT MAX(plan_start_yyyymmdd)
																			FROM   scp_pln_interface_yn with(nolock)
																			WHERE  division_id         = @p_division_id
																			AND    plan_start_yyyymmdd < @max_plan_start_yyyymmdd
																			AND    dm_rtf_yn		   = 'Y' ))


								SET @v_log_type = 'ING';
								SET @v_log_message = N'SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용';
								SET @v_description = '@p_division_id : ' + ISNULL(@p_division_id,'NULL') + ' / ' + '@c_plan_id : ' + ISNULL(@c_plan_id,'NULL');
								SET @d_event_date = SYSDATETIME();
								EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

							END
						ELSE
							BEGIN
								SET @c_plan_id = @p_plan_id
							END
						--End [C20210215-000212] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용
						
 PRINT ( @v_program_name + ' A004: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )		

 -- [PJ2025-50188] EE_FN의 current 소스 원복 (EE_FN 변수 및 분기문 모두 삭제). 해당위치에서 삭제됨.
 PRINT ( @v_program_name + ' A005: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	
						-------------------------------------------------------------------------------------------------------------------------------------------	
						--PRINT '#T_results INSERT START                      =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)

						-- [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN / DM_PLN_MKT_FCST  ==>  임시테이블에 담음
						IF (@p_division_id = '40')
						BEGIN
							INSERT INTO #T_MF_BALANCE_MKT_FCST	-- [PJ2025-50188] 임시테이블 #T_MKT_FCST ==> #T_MF_BALANCE_MKT_FCST 변경
							( 
									DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
								  , CELL_PROD_SITE_ID								-- [PJ2025-50017]추가
								  , FROM_SITE_ID									-- [PJ2025-50017]추가
								  , MEASURE, YYYYMMDD, QTY				
							)
							SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
								  , CELL_PROD_SITE_ID								-- [PJ2025-50017]추가
								  , ATTRIBUTE2			AS FROM_SITE_ID				-- [PJ2025-50017]추가
								  , MEASURE, YYYYMMDD, QTY
							FROM DM_PLN_CFM_MKT_DEMAND_PLAN
							WHERE DIVISION_ID	= @p_division_id
							AND   YYYYMMDD		>= @plan_start_yyyymmdd
							AND MEASURE IN ('MKT_FCST','SCM_FCST','VMI_In_Req','AS_In_Req', 'BALANCE', 'RTF_SYS_RP', 'RTF_SCP', 'RTF', 'VMI_Inv')		-- 해당 MEASURE로 국한하지 않으면, MKT_AMT_KRW로 인해 OVERFLOW 발생 가능함.
							;
						END
						ELSE
						BEGIN
							INSERT INTO #T_MF_BALANCE_MKT_FCST	-- [PJ2025-50188] 임시테이블 #T_MKT_FCST ==> #T_MF_BALANCE_MKT_FCST 변경
							( 
									DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
								  , CELL_PROD_SITE_ID								-- [PJ2025-50017]추가
								  , FROM_SITE_ID									-- [PJ2025-50017]추가
								  , MEASURE, YYYYMMDD, QTY				
							)
							SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
								  , '-'					AS CELL_PROD_SITE_ID		-- [PJ2025-50017]추가
								  , '-'					AS FROM_SITE_ID				-- [PJ2025-50017]추가
								  , MEASURE, YYYYMMDD, QTY
							FROM DM_PLN_MKT_FCST
							WHERE DIVISION_ID	= @p_division_id
							AND   YYYYMMDD		>= @plan_start_yyyymmdd
							AND MEASURE IN ('MKT_FCST','SCM_FCST','VMI_In_Req','AS_In_Req', 'BALANCE', 'RTF_SYS_RP', 'RTF_SCP', 'RTF', 'VMI_Inv')		-- 해당 MEASURE로 국한하지 않으면, MKT_AMT_KRW로 인해 OVERFLOW 발생 가능함.
							;
						END


						INSERT  INTO  #T_results
									(division_id   
									,project_code  
									,scm_site_id   
									,item_id       
									,dom_exp       
									,fcst_type     
									,incoterms   
									--,measure  
									,plant_site_id 
									,vmi_yn
									,CELL_PROD_SITE_ID	-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
									,FROM_SITE_ID		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
									)
						SELECT		 DISTINCT 
										DIVISION_ID
									,PROJECT_CODE
									,SCM_SITE_ID
									,ITEM_ID
									,DOM_EXP
									,FCST_TYPE
									,INCOTERMS
									--,'VMI_IN_PLAN'			AS MEASURE						
									,PLANT_SITE_ID
									,'N'					AS VMI_YN				-- vmi_yn 초기값
									,CASE WHEN @p_division_id = '40' THEN CELL_PROD_SITE_ID ELSE '-' END	AS 	CELL_PROD_SITE_ID		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
									,CASE WHEN @p_division_id = '40' THEN MAX(FROM_SITE_ID) ELSE '-' END	AS 	FROM_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
							FROM #T_MF_BALANCE_MKT_FCST  WITH(NOLOCK)	-- [PJ2025-50188] 임시테이블 #T_MKT_FCST ==> #T_MF_BALANCE_MKT_FCST 변경
								WHERE	1=1
								and	YYYYMMDD BETWEEN @plan_start_yyyymmdd AND CONVERT(CHAR(8), DATEADD(WW, @plan_week_cnt, @plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주
								/*
								--AND	MEASURE			in ('MKT_FCST','RTF','RTF_SCP','BALANCE','VMI_INV')  -- 20190221 실적없이 BALANCE만 남아있는 데이터 삭제하기위하여 'RTF','BALANCE' MEASURE 추가함
								AND	MEASURE			in ('MKT_FCST','RTF','RTF_SCP','BALANCE')  -- 20190221 실적없이 BALANCE만 남아있는 데이터 삭제하기위하여 'RTF','BALANCE' MEASURE 추가함
								*/
								--20240126_[E20240102-000530]_[마케팅PI팀] VMI Inv 데이터 - PJT Code 매핑 개선 VMI_INV 메져가 클렌징되지 않음, 신규로 생성하지 않는 경우에는 삭제할 수 있도록 대상 범위에 추가
--									AND	MEASURE			in ('MKT_FCST','RTF','RTF_SCP','BALANCE', 'VMI_Inv')  -- 20190221 실적없이 BALANCE만 남아있는 데이터 삭제하기위하여 'RTF','BALANCE' MEASURE 추가함
								AND	MEASURE			in (@v_measure,'RTF','RTF_SCP','BALANCE', 'VMI_Inv')  -- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
								AND FCST_TYPE <> 'RMA'  --20181108
								AND DIVISION_ID		= @c_division_id
							group by division_id, project_code, scm_site_id, item_id, dom_exp, fcst_type, incoterms, plant_site_id
									, CELL_PROD_SITE_ID				-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
						-----
						UNION
						-----						
						
						--[C20200827-000094] [SCM PI팀] 자동차 전극 RTF를 매출계획에 반영 (@c_scp_division_id = '81', @c_division_id = 'EE')
						SELECT	 ORIGIN_DIVISION_ID AS DIVISION_ID --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(a.division_id -> a.origin_division_id)
								,PROJECT_CODE
								,SALES_SITE_ID
					          	,CASE WHEN ISNULL(FROM_ITEM_ID,'') = ''   --20240610 KCW3408 
										THEN ITEM_ID
										ELSE FROM_ITEM_ID 
									END AS ITEM_ID
								,DOM_EXP
								,FCST_TYPE
								,INCOTERMS
								--,'VMI_IN_PLAN'			AS MEASURE
								--[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청
								--20250116 EE인경우 PLANT_SITE_ID에 데이터가 들어오는 경우가 발생하므로, ORIGIN_DIVISION_ID로 변경
								--,CASE WHEN DIVISION_ID in ('82','40') THEN '' ELSE PLANT_SITE_ID END PLANT_SITE_ID
								,CASE WHEN ORIGIN_DIVISION_ID in ('82','40') THEN '' ELSE PLANT_SITE_ID END PLANT_SITE_ID
								,'N'					AS	VMI_YN-- vmi_yn 초기값
								--,YYYYMMDD		
								,CASE WHEN @p_division_id = '40' THEN CELL_PROD_SITE_ID ELSE '-' END	AS 	CELL_PROD_SITE_ID		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
								,CASE WHEN @p_division_id = '40' THEN MAX(FROM_SITE_ID) ELSE '-' END	AS 	FROM_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
						--20240530
						FROM [SCP_PLN_RTF_ALLOCATION_V]  WITH(NOLOCK)
							WHERE DIVISION_ID		   = @c_scp_division_id --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(@c_division_id -> @c_scp_division_id)
								AND ORIGIN_DIVISION_ID = @c_division_id --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(ORIGIN_DIVISION_ID 조건 추가)
								and plan_id			= @c_plan_id
								-- added by ytchoi 180611 한주가 지나면 화면에서 과거 RTF P 를 보기 어렵기 때문에 당주 월요일 이후로만 계산 함.
								and yyyymmdd		>= @c_plan_start_yyyymmdd
						GROUP BY ORIGIN_DIVISION_ID , PROJECT_CODE, SALES_SITE_ID
								, CASE WHEN ISNULL(FROM_ITEM_ID,'') = '' THEN ITEM_ID  ELSE FROM_ITEM_ID  END
								, DOM_EXP,FCST_TYPE, INCOTERMS
								--[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청
								--20250116 EE인경우 PLANT_SITE_ID에 데이터가 들어오는 경우가 발생하므로, ORIGIN_DIVISION_ID로 변경
								--, CASE WHEN DIVISION_ID in ('82','40')  THEN '' ELSE PLANT_SITE_ID END
								, CASE WHEN ORIGIN_DIVISION_ID in ('82','40')  THEN '' ELSE PLANT_SITE_ID END
								, YYYYMMDD
								, CELL_PROD_SITE_ID								-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 

 PRINT ( @v_program_name + ' A006: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	

					END
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                                                                                                          대상추출 (END)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

				-- [PJ2025-50017] 소형 매출계획 동기화 개선 Start
				-- [SCP_PLN_RTF_ALLOCATION_V] 임시테이블에 저장 후 사용함.

				-- [PJ2025-50188] 임시테이블 #T_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_RTF_ALLOCATION 이름변경
				--CREATE TABLE  #T_SCP_PLN_RTF_ALLOCATION_V
				CREATE TABLE  #T_MF_RTF_ALLOCATION
				(
					 [MASTER_ID]			NVARCHAR(50) NOT NULL
					,[PLAN_ID]				NVARCHAR(30) NOT NULL
					,[OUT_VERSION_ID]		NVARCHAR(30) NOT NULL
					,[DIVISION_ID]			NVARCHAR(30) NOT NULL
					,[ORIGIN_DIVISION_ID]	NVARCHAR(30) NOT NULL
					,[PLAN_START_YYYYMMDD]	NVARCHAR(8) NOT NULL
					,[PLAN_TYPE]			NVARCHAR(50) NOT NULL
					,[SEQ]					BIGINT NOT NULL
					,[OPERATION_GROUP]		NVARCHAR(10) NOT NULL
					,[ENG_DEMAND_ID]		NVARCHAR(1000) NOT NULL
					,[ITEM_ID]				NVARCHAR(50) NOT NULL
					,[PROJECT_CODE]			NVARCHAR(50) NOT NULL
					,[SALES_SITE_ID]		NVARCHAR(30) NOT NULL
					,[INCOTERMS]			NVARCHAR(10) NULL
					,[DOM_EXP]				NVARCHAR(10) NULL
					,[FCST_TYPE]			NVARCHAR(20) NULL
					,[DEMAND_TYPE]			NVARCHAR(50) NULL
					,[DUE_DATE]				NVARCHAR(8) NULL
					,[PLANT_SITE_ID]		NVARCHAR(30) NOT NULL
					,[YYYYMMDD]				NVARCHAR(8) NOT NULL
					,[ALLOCATION_QTY]		NUMERIC(20,10) NULL
					,[DELIVERY_ORDER_ID]	NVARCHAR(200) NULL
					,[FROM_SITE]			NVARCHAR(150) NOT NULL
					,[FROM_ITEM_ID]			NVARCHAR(150) NULL
					,[SCP_INCOTERMS]		NVARCHAR(10) NULL
					,[FROM_SITE_ID]			NVARCHAR(150) NOT NULL
					,[CELL_PROD_SITE_ID]	NVARCHAR(150) NOT NULL				-- [PJ2025-50017] 추가
				)
				;

				-- [PJ2025-50188] 임시테이블 #T_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_RTF_ALLOCATION 이름변경
				--INSERT INTO #T_SCP_PLN_RTF_ALLOCATION_V
				INSERT INTO #T_MF_RTF_ALLOCATION
				(
					MASTER_ID, PLAN_ID, OUT_VERSION_ID, DIVISION_ID, ORIGIN_DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE
				  , SEQ, OPERATION_GROUP, ENG_DEMAND_ID, ITEM_ID, PROJECT_CODE, SALES_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE
				  , DEMAND_TYPE, DUE_DATE, PLANT_SITE_ID, YYYYMMDD, ALLOCATION_QTY
				  , DELIVERY_ORDER_ID, FROM_SITE, FROM_ITEM_ID, SCP_INCOTERMS, FROM_SITE_ID, CELL_PROD_SITE_ID			-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				)
				SELECT 	MASTER_ID, PLAN_ID, OUT_VERSION_ID, DIVISION_ID, ORIGIN_DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE
					  , SEQ, OPERATION_GROUP, ENG_DEMAND_ID, ITEM_ID, PROJECT_CODE, SALES_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE
					  , DEMAND_TYPE, DUE_DATE, PLANT_SITE_ID, YYYYMMDD, ALLOCATION_QTY
					  , DELIVERY_ORDER_ID, FROM_SITE, FROM_ITEM_ID, SCP_INCOTERMS, FROM_SITE_ID, CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM [SCP_PLN_RTF_ALLOCATION_V]  WITH(NOLOCK)
				WHERE DIVISION_ID		= @c_scp_division_id 
				AND ORIGIN_DIVISION_ID	= @c_division_id 
				AND PLAN_ID				= @c_plan_id
				AND YYYYMMDD			>= @c_plan_start_yyyymmdd

				-- [PJ2025-50017] 소형 매출계획 동기화 개선 End


				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                                                                        SCM_MST_SITE테이블의 VMI대상을 컬럼에 셋팅 (START)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				BEGIN

					update #T_results set vmi_yn = 'Y'
					  where 1=1
					  and exists (select division_id from SCM_MST_SITE C WITH(NOLOCK) WHERE 1=1
									and #T_results.division_id        =   C.division_id      
									and #T_results.division_id        IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81', '82' ) )
									AND #T_results.scm_site_id        =   C.scm_site_id  
									and c.vmi_yn = 'Y'
									)
					;


				END
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                                                                        SCM_MST_SITE테이블의 VMI대상을 컬럼에 셋팅 (END)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

 PRINT ( @v_program_name + ' A007: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	

				IF  @p_plan_id  <>  'CALL'  -- PROCEDURE에서 호출된 케이스가 아닌경우만 수행
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                                                                                            RTF, VMI DIO 관련 작업 (START)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				BEGIN
						---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
						--                                                                                                                                 MKT_FCST, RTF 대상 날짜및 값 추출 (START)
						---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

						---------------------------------- RTF MEASURE MKT_FCST TABLE INSERT (START)
						BEGIN
							
							/*
							-- 20200416 KHSONG C20200413-000593 주석처리
							DELETE FROM DM_PLN_MKT_FCST
								WHERE MEASURE IN ('RTF','VMI_In_Plan')
								and YYYYMMDD >= @c_plan_start_yyyymmdd
								and DIVISION_ID = @c_division_id
								and DIVISION_ID IN ( '82' )  -- 20190624 KHSONG [CSR_ID:4016234]
								AND FCST_TYPE <> 'RMA' --20181108
							*/
							--[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(81사업부 전극은 SCM_MST_ITEM_SN.scp_operation_group_id = 'E'만 대상)

							IF @c_scp_division_id LIKE 'EE%' 
							BEGIN
								DELETE
								FROM  DBO.DM_PLN_MKT_FCST
								WHERE MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN', 'AS_IN_PLAN', 'RTF_PR')		-- [PJ2025-50017] RTF_PR 신규 추가
								AND   DIVISION_ID = @c_division_id	-- C20221107-000257
								AND   FCST_TYPE <> 'RMA' 
								AND   EXISTS ( SELECT DISTINCT ITEM_ID
									            FROM   SCM_MST_FINAL_ITEM_V WITH(NOLOCK)
												WHERE  DM_PLN_MKT_FCST.DIVISION_ID = SCM_MST_FINAL_ITEM_V.DIVISION_ID
												AND    DM_PLN_MKT_FCST.ITEM_ID     = SCM_MST_FINAL_ITEM_V.ITEM_ID
												AND    DM_PLN_MKT_FCST.YYYYMMDD   >= @PLAN_START_YYYYMMDD  -- 당주월요일
												AND    SCM_MST_FINAL_ITEM_V.OPERATION_GROUP_ID = 'E' )
	
								--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start
								DELETE
								FROM  DBO.DM_PLN_CFM_MKT_DEMAND_PLAN 
								WHERE MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN', 'AS_IN_PLAN', 'RTF_PR')		-- [PJ2025-50017] RTF_PR 신규 추가
								AND   DIVISION_ID = @c_division_id	-- C20221107-000257
								AND   FCST_TYPE <> 'RMA' 
								AND   EXISTS ( SELECT DISTINCT ITEM_ID
									            FROM   SCM_MST_FINAL_ITEM_V WITH(NOLOCK)
												WHERE  DM_PLN_CFM_MKT_DEMAND_PLAN.DIVISION_ID = SCM_MST_FINAL_ITEM_V.DIVISION_ID
												AND    DM_PLN_CFM_MKT_DEMAND_PLAN.ITEM_ID     = SCM_MST_FINAL_ITEM_V.ITEM_ID
												AND    DM_PLN_CFM_MKT_DEMAND_PLAN.YYYYMMDD   >= @PLAN_START_YYYYMMDD  -- 당주월요일
												AND    SCM_MST_FINAL_ITEM_V.OPERATION_GROUP_ID = 'E' )

								--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End
							END
							ELSE
							BEGIN

								DELETE FROM DM_PLN_MKT_FCST
								WHERE MEASURE IN ('RTF_SYS_RP','RTF_SCP','RTF','VMI_In_Plan', 'AS_In_Plan', 'RTF_PR')  --20190111 KHSONG 소형 'RTF_SCP' MEASURE 적용, 20220630, SS_ 메저 추가 -- , 'RTF_PR') -- [PJ2025-50017] RTF_PR 신규 추가
									and YYYYMMDD >= @c_plan_start_yyyymmdd
									and DIVISION_ID = @c_division_id
									AND FCST_TYPE <> 'RMA' --20181108
									and not exists (select distinct item_id --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(81사업부 전극 대상 SCM_MST_ITEM_SN.scp_operation_group_id = 'E'은 제외)
									               from   SCM_MST_FINAL_ITEM_V with(nolock)
												   where  DM_PLN_MKT_FCST.division_id = SCM_MST_FINAL_ITEM_V.division_id
												   and    DM_PLN_MKT_FCST.item_id     = SCM_MST_FINAL_ITEM_V.item_id
												   and    DM_PLN_MKT_FCST.yyyymmdd   >= @plan_start_yyyymmdd  -- 당주월요일
												   and    SCM_MST_FINAL_ITEM_V.operation_group_id = 'E' 
												   --[E20241211-000856]_40사업부 전극 RTF 적용가능하도록 수정요청으로 EE로 들어오는 건에 대해 해결 방안을 수정한다. START
												   --and    SCM_MST_FINAL_ITEM_V.division_id LIKE '81%')
												   and    SCM_MST_FINAL_ITEM_V.division_id LIKE '40%')
												   --[E20241211-000856]_40사업부 전극 RTF 적용가능하도록 수정요청으로 EE로 들어오는 건에 대해 해결 방안을 수정한다. END

								--[C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용				   
								DELETE FROM DM_PLN_MKT_FCST
								WHERE MEASURE IN ( 'RTF')
								and YYYYMMDD   >= @c_plan_start_yyyymmdd
								and DIVISION_ID = @c_division_id
								and DIVISION_ID = '82'
								AND FCST_TYPE  <> 'RMA'

								-- RMA 수정 hwi1993 C20200518-000359
								DELETE FROM DM_PLN_MKT_FCST
								WHERE MEASURE IN ('RTF_SYS_RP','RTF_SCP' , 'RTF_PR') -- [PJ2025-50017] RTF_PR 신규 추가
									and YYYYMMDD >= @c_plan_start_yyyymmdd
									and DIVISION_ID = @c_division_id
									AND FCST_TYPE = 'RMA'
									AND DIVISION_ID = '40'

								IF @P_division_id LIKE N'81%'
								BEGIN
									DELETE FROM DM_PLN_MKT_FCST
									WHERE MEASURE IN ( 'SS_LVL', 'SS_GAP' )
										and YYYYMMDD >= @c_plan_start_yyyymmdd
										and DIVISION_ID = @P_division_id
								END

								--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start	
								DELETE FROM DBO.DM_PLN_CFM_MKT_DEMAND_PLAN 
								WHERE MEASURE IN ('RTF_SYS_RP','RTF_SCP','RTF','VMI_In_Plan', 'AS_In_Plan', 'RTF_PR')  --20190111 KHSONG 소형 'RTF_SCP' MEASURE 적용, 20220630, SS_ 메저 추가  -- [PJ2025-50017] RTF_PR 신규 추가
									and YYYYMMDD >= @c_plan_start_yyyymmdd
									and DIVISION_ID = @c_division_id
									AND FCST_TYPE <> 'RMA' --20181108
									and not exists (select distinct item_id --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(81사업부 전극 대상 SCM_MST_ITEM_SN.scp_operation_group_id = 'E'은 제외)
													from   [dbo].SCM_MST_FINAL_ITEM_V with(nolock)
													where  DM_PLN_CFM_MKT_DEMAND_PLAN.division_id = SCM_MST_FINAL_ITEM_V.division_id
													and    DM_PLN_CFM_MKT_DEMAND_PLAN.item_id     = SCM_MST_FINAL_ITEM_V.item_id
													and    DM_PLN_CFM_MKT_DEMAND_PLAN.yyyymmdd   >= @plan_start_yyyymmdd  -- 당주월요일
													and    SCM_MST_FINAL_ITEM_V.operation_group_id = 'E' 
												   --[E20241211-000856]_40사업부 전극 RTF 적용가능하도록 수정요청으로 EE로 들어오는 건에 대해 해결 방안을 수정한다. START
												   --and    SCM_MST_FINAL_ITEM_V.division_id LIKE '81%')
												   and    SCM_MST_FINAL_ITEM_V.division_id LIKE '40%')
												   --[E20241211-000856]_40사업부 전극 RTF 적용가능하도록 수정요청으로 EE로 들어오는 건에 대해 해결 방안을 수정한다. END


								--[C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용				   
								DELETE FROM DBO.DM_PLN_CFM_MKT_DEMAND_PLAN
								WHERE MEASURE IN ( 'RTF')
								and YYYYMMDD   >= @c_plan_start_yyyymmdd
								and DIVISION_ID = @c_division_id
								and DIVISION_ID = '82'
								AND FCST_TYPE  <> 'RMA'

								DELETE FROM DBO.DM_PLN_CFM_MKT_DEMAND_PLAN
								WHERE MEASURE IN ('RTF_SYS_RP','RTF_SCP', 'RTF_PR')  -- [PJ2025-50017] RTF_PR 신규 추가
									and YYYYMMDD >= @c_plan_start_yyyymmdd
									and DIVISION_ID = @c_division_id
									AND FCST_TYPE = 'RMA'
									AND DIVISION_ID = '40'

								IF @P_division_id LIKE N'81%'
								BEGIN
									DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN
									WHERE MEASURE IN ( 'SS_LVL', 'SS_GAP' )
										and YYYYMMDD >= @c_plan_start_yyyymmdd
										and DIVISION_ID = @P_division_id
								END

								--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End
		
		
							END
							
 PRINT ( @v_program_name + ' A008: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	

							-----------------------------------------------------------------------
						    --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영 (@c_scp_division_id = '81', @c_division_id = 'EE')
							SELECT		distinct
										 A.ORIGIN_DIVISION_ID AS DIVISION_ID --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(a.division_id -> a.origin_division_id)
										,a.PROJECT_CODE
										,a.SALES_SITE_ID AS SCM_SITE_ID
					                 	,CASE WHEN ISNULL(A.FROM_ITEM_ID,'') = ''   --20240610 KCW3408 
						                      THEN A.ITEM_ID
						                      ELSE A.FROM_ITEM_ID 
						                 END AS ITEM_ID
										,a.DOM_EXP
										,a.FCST_TYPE
										,a.INCOTERMS
										/*
										-- 20200416 KHSONG C20200413-000593 주석처리
										,CASE  WHEN  c.VMI_YN  = 'Y' AND A.DIVISION_ID in ('40','81','82') THEN 'VMI_In_Plan'   --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
											   WHEN  c.VMI_YN <> 'Y' AND A.DIVISION_ID in ('40','81') THEN 'RTF_SCP' --20190111 KHSONG 소형 'RTF_SCP' MEASURE 적용 -- 20190624 KHSONG [CSR_ID:4016234]
											   ELSE 'RTF'  END MEASURE
										*/
										,CASE  WHEN  c.VMI_YN  = 'Y' AND a.DIVISION_ID in ('82','40') THEN 'VMI_In_Plan' 
												WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
												ELSE 'RTF_SCP'  END MEASURE  -- 20200416 KHSONG C20200413-000593 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨
										--,PLANT_SITE_ID 
									    --[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청
									    --20250116 EE인경우 PLANT_SITE_ID에 데이터가 들어오는 경우가 발생하므로, ORIGIN_DIVISION_ID로 변경
										--,CASE WHEN a.DIVISION_ID in ('82','40') THEN '' ELSE a.PLANT_SITE_ID END PLANT_SITE_ID
										,CASE WHEN a.ORIGIN_DIVISION_ID in ('82','40') THEN '' ELSE a.PLANT_SITE_ID END PLANT_SITE_ID
										,a.YYYYMMDD 
										,SUM(a.ALLOCATION_QTY) QTY
										,'SYSTEM' CREATED_BY
										,GETDATE() CREATION_DATE
										,'SYSTEM' LAST_UPDATED_BY
										,GETDATE() LAST_UPDATE_DATE

							INTO #T_MKT_FCST_INSERT  -- 20190709 KHSONG [CSR ID:4027463] 임시테이블에 넣고 MEASURE 추가할 용도임
							--20240530
--							FROM [dbo].[SCP_PLN_RTF_ALLOCATION_V] a WITH(NOLOCK)			
--							FROM #T_SCP_PLN_RTF_ALLOCATION_V a WITH(NOLOCK)				-- [PJ2025-50017] 소형 매출계획 동기화 개선
							-- [PJ2025-50188] 임시테이블 #T_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_RTF_ALLOCATION 이름변경
							FROM #T_MF_RTF_ALLOCATION a WITH(NOLOCK)				-- [PJ2025-50017] 소형 매출계획 동기화 개선
   								inner join SCM_MST_SITE C WITH(NOLOCK)
										on( A.ORIGIN_DIVISION_ID =   C.division_id      --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(a.division_id -> a.origin_division_id)
										AND a.sales_site_id      =   C.scm_site_id )
								WHERE a.DIVISION_ID          = @c_scp_division_id --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(@c_division_id -> @c_scp_division_id)
									AND ORIGIN_DIVISION_ID   = @c_division_id --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(ORIGIN_DIVISION_ID 조건 추가)
									and a.plan_id            = @c_plan_id
									and YYYYMMDD >= @c_plan_start_yyyymmdd
							GROUP BY a.ORIGIN_DIVISION_ID , a.PROJECT_CODE, a.SALES_SITE_ID
			                       , CASE WHEN ISNULL(A.FROM_ITEM_ID,'') = '' THEN A.ITEM_ID  ELSE A.FROM_ITEM_ID  END
				                   , a.DOM_EXP,a.FCST_TYPE, a.INCOTERMS								   
								   --[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청
								   --20250116 EE인경우 PLANT_SITE_ID에 데이터가 들어오는 경우가 발생하므로, ORIGIN_DIVISION_ID로 변경
								   --, CASE WHEN a.DIVISION_ID in ('82','40')  THEN '' ELSE a.PLANT_SITE_ID END
								   , CASE WHEN a.ORIGIN_DIVISION_ID in ('82','40')  THEN '' ELSE a.PLANT_SITE_ID END
								   , a.YYYYMMDD,c.VMI_YN, C.OPERATION_GROUP
                                , A.DIVISION_ID
							-- 상품인 건에 대해서는 RTF를 MKT FCST와 동일하게 생성 함.

							UNION ALL

							select  
									 a.[DIVISION_ID]
									,a.[PROJECT_CODE]
									,a.[SCM_SITE_ID]
									,a.[ITEM_ID]
									,a.[DOM_EXP]
									,a.[FCST_TYPE]
									,a.[INCOTERMS]
										/*
										-- 20200416 KHSONG C20200413-000593 주석처리
										,CASE  WHEN  c.VMI_YN  = 'Y' AND A.DIVISION_ID in ('40','81','82') THEN 'VMI_In_Plan'   --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
											   WHEN  c.VMI_YN <> 'Y' AND A.DIVISION_ID in ('40','81') THEN 'RTF_SCP' --20190111 KHSONG 소형 'RTF_SCP' MEASURE 적용 -- 20190624 KHSONG [CSR_ID:4016234]
											   ELSE 'RTF'  END MEASURE
										*/
										,CASE  WHEN  c.VMI_YN  = 'Y' AND A.DIVISION_ID IN ('40', '82' ) THEN 'VMI_In_Plan' 
												WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
												ELSE 'RTF_SCP'  END MEASURE  -- 20200416 KHSONG C20200413-000593 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨

									,a.[PLANT_SITE_ID]
									,a.[YYYYMMDD]
									,SUM( CASE  WHEN  c.VMI_YN  = 'Y' AND MEASURE = 'VMI_In_Req' THEN a.qty --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
												WHEN  C.OPERATION_GROUP = 'W' AND MEASURE = 'AS_In_Req' THEN A.QTY
												--WHEN  c.VMI_YN <> 'Y' AND MEASURE = 'MKT_FCST'   THEN a.qty --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
												WHEN  c.VMI_YN <> 'Y' AND MEASURE = @v_measure   THEN a.qty --  [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
										ELSE 0  END ) QTY
									,'SYSTEM'  CREATED_BY
									,GETDATE() CREATION_DATE
									,'SYSTEM'  LAST_UPDATED_BY
									,GETDATE() LAST_UPDATE_DATE
								from DM_PLN_MKT_FCST a WITH(NOLOCK)
								inner join [dbo].[DM_MST_ITEM_SINGLE_V] b WITH(NOLOCK)
									on (a.division_id		= b.division_id
									and a.item_id			= b.item_id)
   								inner join [dbo].SCM_MST_SITE C WITH(NOLOCK)
										on( a.division_id        =   C.division_id      
										AND a.SCM_SITE_ID        =   C.scm_site_id )
								where a.division_id		= @c_scp_division_id --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(@c_division_id ->@c_scp_division_id)
								and a.yyyymmdd			>= @c_plan_start_yyyymmdd
								AND A.FCST_TYPE <> 'RMA'  -- 20181108 KHSONG 소형 반품예정수량(RMA) fcst_type인 경우 VMI대상로직에서 제외
								and a.measure			= CASE  WHEN  c.VMI_YN = 'Y' AND A.DIVISION_ID IN  ('40','82') THEN 'VMI_In_Req' 
																WHEN  C.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
--																ELSE 'MKT_FCST'  END -- VMI = 'Y'인경우에만 VMI_In_Req 'N'이면 MKT_FCST 사용 --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
																ELSE @v_measure  END --  [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
								-- 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
								and (b.item_type in ('Q' , 'R' ) OR ( a.item_id in ( select k.item_id from scm_mst_item_sn k  WITH (NOLOCK) where k.division_id = a.division_id and k.SCP_OPERATION_GROUP = 'E'  )  )
								--[E20241211-000856]_40사업부 전극 RTF가 생성된 건에 대해서는 MKT FCST로 RFT를 생성하면 안되므로 추가함 START						
								--AND a.division_id IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895] DIVISION_ID 구분으로 추가
								AND a.division_id IN ('82')  -- 20190709 KHSONG [CSR ID:4034895] DIVISION_ID 구분으로 추가
								--[E20241211-000856]_40사업부 전극 RTF가 생성된 건에 대해서는 MKT FCST로 RFT를 생성하면 안되므로 추가함 END
								)
								group by a.[DIVISION_ID]
									,a.[PROJECT_CODE]
									,a.[SCM_SITE_ID]
									,a.[ITEM_ID]
									,a.[DOM_EXP]
									,a.[FCST_TYPE]
									,a.[INCOTERMS]
										/*-- 20200416 KHSONG C20200413-000593 주석처리
										,CASE  WHEN  c.VMI_YN  = 'Y' AND A.DIVISION_ID in ('40','81','82') THEN 'VMI_In_Plan' --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
											   WHEN  c.VMI_YN <> 'Y' AND A.DIVISION_ID in ('40','81') THEN 'RTF_SCP' --20190111 KHSONG 소형 'RTF_SCP' MEASURE 적용 -- 20190624 KHSONG [CSR_ID:4016234] --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
											   ELSE 'RTF'  END
										*/
										,CASE WHEN  c.VMI_YN  = 'Y' AND A.DIVISION_ID IN ('40', '82' ) THEN 'VMI_In_Plan' WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan' ELSE 'RTF_SCP'  END   -- 20200416 KHSONG C20200413-000593 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨
									,a.[PLANT_SITE_ID]
									,a.[YYYYMMDD]
							

							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start (#T_CFM_DEMAND_INSERT)		

						    --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영 (@c_scp_division_id = '81', @c_division_id = 'EE')
							SELECT distinct
								 A.DIVISION_ID 
								,A.PROJECT_CODE
								,A.SCM_SITE_ID
					            ,A.ITEM_ID
								,A.DOM_EXP
								,A.FCST_TYPE
								,A.INCOTERMS
								,A.MEASURE  
								,A.PLANT_SITE_ID
								,A.CELL_PROD_SITE_ID									--[PJ2025-50017] 추가
								,MAX(A.FROM_SITE_ID)		AS FROM_SITE_ID				--[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
								,A.YYYYMMDD 
								,SUM(A.QTY)			AS QTY
								,'SYSTEM' CREATED_BY
								,GETDATE() CREATION_DATE
								,'SYSTEM' LAST_UPDATED_BY
								,GETDATE() LAST_UPDATE_DATE
							INTO #T_CFM_DEMAND_INSERT  -- 20190709 KHSONG [CSR ID:4027463] 임시테이블에 넣고 MEASURE 추가할 용도임
							FROM (
								SELECT		distinct
											 A.ORIGIN_DIVISION_ID AS DIVISION_ID --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(a.division_id -> a.origin_division_id)
											,a.PROJECT_CODE
											,a.SALES_SITE_ID AS SCM_SITE_ID
					                 		,CASE WHEN ISNULL(A.FROM_ITEM_ID,'') = ''   --20240610 KCW3408 
												  THEN A.ITEM_ID
												  ELSE A.FROM_ITEM_ID 
											 END AS ITEM_ID
											,a.DOM_EXP
											,a.FCST_TYPE
											,a.INCOTERMS
											/*
											-- 20200416 KHSONG C20200413-000593 주석처리
											,CASE  WHEN  c.VMI_YN  = 'Y' AND A.DIVISION_ID in ('40','81','82') THEN 'VMI_In_Plan'   --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
												   WHEN  c.VMI_YN <> 'Y' AND A.DIVISION_ID in ('40','81') THEN 'RTF_SCP' --20190111 KHSONG 소형 'RTF_SCP' MEASURE 적용 -- 20190624 KHSONG [CSR_ID:4016234]
												   ELSE 'RTF'  END MEASURE
											*/
											,CASE  WHEN  c.VMI_YN  = 'Y' AND a.DIVISION_ID in ('82','40') THEN 'VMI_In_Plan' 
													WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
													ELSE 'RTF_SCP'  END MEASURE  -- 20200416 KHSONG C20200413-000593 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨
											--,PLANT_SITE_ID 
											--[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청
											--20250116 EE인경우 PLANT_SITE_ID에 데이터가 들어오는 경우가 발생하므로, ORIGIN_DIVISION_ID로 변경
											--,CASE WHEN a.DIVISION_ID in ('82','40') THEN '' ELSE a.PLANT_SITE_ID END PLANT_SITE_ID
											,CASE WHEN a.ORIGIN_DIVISION_ID in ('82','40') THEN '' ELSE a.PLANT_SITE_ID END PLANT_SITE_ID
											,ISNULL (A.CELL_PROD_SITE_ID, '-')				AS CELL_PROD_SITE_ID		--[PJ2025-50017] 추가
											,CASE WHEN (A.ORIGIN_DIVISION_ID in ('40') AND ISNULL (A.CELL_PROD_SITE_ID, '-') = '-' ) THEN A.FROM_SITE_ID ELSE ISNULL (A.CELL_PROD_SITE_ID, '-')		END		AS FROM_SITE_ID	 --[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
											,a.YYYYMMDD 
											,SUM(a.ALLOCATION_QTY)	AS QTY
											,'SYSTEM' CREATED_BY
											,GETDATE() CREATION_DATE
											,'SYSTEM' LAST_UPDATED_BY
											,GETDATE() LAST_UPDATE_DATE
								--FROM [SCP_PLN_RTF_ALLOCATION_V] A WITH(NOLOCK) 
								--FROM #T_SCP_PLN_RTF_ALLOCATION_V a WITH(NOLOCK)				-- [PJ2025-50017] 소형 매출계획 동기화 개선
								-- [PJ2025-50188] 임시테이블 #T_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_RTF_ALLOCATION 이름변경
								FROM #T_MF_RTF_ALLOCATION a WITH(NOLOCK)				-- [PJ2025-50017] 소형 매출계획 동기화 개선
   									inner join SCM_MST_SITE C WITH(NOLOCK)
											on( A.ORIGIN_DIVISION_ID =   C.division_id      --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(a.division_id -> a.origin_division_id)
											AND a.sales_site_id      =   C.scm_site_id )
									WHERE a.DIVISION_ID          = @c_scp_division_id --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(@c_division_id -> @c_scp_division_id)
										AND ORIGIN_DIVISION_ID   = @c_division_id --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(ORIGIN_DIVISION_ID 조건 추가)
										and a.plan_id            = @c_plan_id
										and YYYYMMDD >= @c_plan_start_yyyymmdd
								GROUP BY a.ORIGIN_DIVISION_ID , a.PROJECT_CODE, a.SALES_SITE_ID
									   , CASE WHEN ISNULL(A.FROM_ITEM_ID,'') = '' THEN A.ITEM_ID  ELSE A.FROM_ITEM_ID  END
									   , a.DOM_EXP,a.FCST_TYPE, a.INCOTERMS
									   --[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청
									   --20250116 EE인경우 PLANT_SITE_ID에 데이터가 들어오는 경우가 발생하므로, ORIGIN_DIVISION_ID로 변경
									   --, CASE WHEN a.DIVISION_ID in ('82','40')  THEN '' ELSE a.PLANT_SITE_ID END
									   , CASE WHEN a.ORIGIN_DIVISION_ID in ('82','40')  THEN '' ELSE a.PLANT_SITE_ID END
									   , a.YYYYMMDD,c.VMI_YN, C.OPERATION_GROUP, A.DIVISION_ID
									   , ISNULL (A.CELL_PROD_SITE_ID, '-')				--[PJ2025-50017] 추가
									   , A.FROM_SITE_ID
								-- 상품인 건에 대해서는 RTF를 MKT FCST와 동일하게 생성 함.
							) A
							GROUP BY A.DIVISION_ID 
								,A.PROJECT_CODE
								,A.SCM_SITE_ID
					            ,A.ITEM_ID
								,A.DOM_EXP
								,A.FCST_TYPE
								,A.INCOTERMS
								,A.MEASURE  
								,A.PLANT_SITE_ID
								,A.CELL_PROD_SITE_ID				--[PJ2025-50017] 추가
								,A.YYYYMMDD 

							UNION ALL

							select  
									 a.[DIVISION_ID]
									,a.[PROJECT_CODE]
									,a.[SCM_SITE_ID]
									,a.[ITEM_ID]
									,a.[DOM_EXP]
									,a.[FCST_TYPE]
									,a.[INCOTERMS]
										/*
										-- 20200416 KHSONG C20200413-000593 주석처리
										,CASE  WHEN  c.VMI_YN  = 'Y' AND A.DIVISION_ID in ('40','81','82') THEN 'VMI_In_Plan'   --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
											   WHEN  c.VMI_YN <> 'Y' AND A.DIVISION_ID in ('40','81') THEN 'RTF_SCP' --20190111 KHSONG 소형 'RTF_SCP' MEASURE 적용 -- 20190624 KHSONG [CSR_ID:4016234]
											   ELSE 'RTF'  END MEASURE
										*/
										,CASE  WHEN  c.VMI_YN  = 'Y' AND A.DIVISION_ID IN ('40', '82' ) THEN 'VMI_In_Plan' 
												WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
												ELSE 'RTF_SCP'  END MEASURE  -- 20200416 KHSONG C20200413-000593 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨

									,a.[PLANT_SITE_ID]
									,'-' AS CELL_PROD_SITE_ID --[PJ2025-50017] 추가
									,'-' AS FROM_SITE_ID	  --[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
									,a.[YYYYMMDD]
									,SUM( CASE  WHEN  c.VMI_YN  = 'Y' AND MEASURE = 'VMI_In_Req' THEN a.qty --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
												WHEN  C.OPERATION_GROUP = 'W' AND MEASURE = 'AS_In_Req' THEN A.QTY
												--WHEN  c.VMI_YN <> 'Y' AND MEASURE = 'MKT_FCST'   THEN a.qty --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
												WHEN  c.VMI_YN <> 'Y' AND MEASURE = @v_measure   THEN a.qty --  [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
										ELSE 0  END ) QTY
									,'SYSTEM'  CREATED_BY
									,GETDATE() CREATION_DATE
									,'SYSTEM'  LAST_UPDATED_BY
									,GETDATE() LAST_UPDATE_DATE
								from DM_PLN_MKT_FCST a WITH(NOLOCK)
								inner join [dbo].[DM_MST_ITEM_SINGLE_V] b WITH(NOLOCK)
									on (a.division_id		= b.division_id
									and a.item_id			= b.item_id)
   								inner join [dbo].SCM_MST_SITE C WITH(NOLOCK)
										on( a.division_id        =   C.division_id      
										AND a.SCM_SITE_ID        =   C.scm_site_id )
								where a.division_id		= @c_scp_division_id --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(@c_division_id ->@c_scp_division_id)
								and a.yyyymmdd			>= @c_plan_start_yyyymmdd
								AND A.FCST_TYPE <> 'RMA'  -- 20181108 KHSONG 소형 반품예정수량(RMA) fcst_type인 경우 VMI대상로직에서 제외
								and a.measure			= CASE  WHEN  c.VMI_YN = 'Y' AND A.DIVISION_ID IN  ('40','82') THEN 'VMI_In_Req' 
																WHEN  C.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
																--ELSE 'MKT_FCST'  END -- VMI = 'Y'인경우에만 VMI_In_Req 'N'이면 MKT_FCST 사용 --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
																ELSE @v_measure  END --  [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
								-- 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
								and (b.item_type in ('Q' , 'R' ) OR ( a.item_id in ( select k.item_id from scm_mst_item_sn k  WITH (NOLOCK) where k.division_id = a.division_id and k.SCP_OPERATION_GROUP = 'E'  )  )
								--[E20241211-000856]_40사업부 전극 RTF가 생성된 건에 대해서는 MKT FCST로 RFT를 생성하면 안되므로 추가함 START
								--AND a.division_id IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895] DIVISION_ID 구분으로 추가
								AND a.division_id IN ('82')  -- 20190709 KHSONG [CSR ID:4034895] DIVISION_ID 구분으로 추가
								--[E20241211-000856]_40사업부 전극 RTF가 생성된 건에 대해서는 MKT FCST로 RFT를 생성하면 안되므로 추가함 END
								)
								group by a.[DIVISION_ID]
									,a.[PROJECT_CODE]
									,a.[SCM_SITE_ID]
									,a.[ITEM_ID]
									,a.[DOM_EXP]
									,a.[FCST_TYPE]
									,a.[INCOTERMS]
										/*-- 20200416 KHSONG C20200413-000593 주석처리
										,CASE  WHEN  c.VMI_YN  = 'Y' AND A.DIVISION_ID in ('40','81','82') THEN 'VMI_In_Plan' --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
											   WHEN  c.VMI_YN <> 'Y' AND A.DIVISION_ID in ('40','81') THEN 'RTF_SCP' --20190111 KHSONG 소형 'RTF_SCP' MEASURE 적용 -- 20190624 KHSONG [CSR_ID:4016234] --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
											   ELSE 'RTF'  END
										*/
										,CASE WHEN  c.VMI_YN  = 'Y' AND A.DIVISION_ID IN ('40', '82' ) THEN 'VMI_In_Plan' WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan' ELSE 'RTF_SCP'  END   -- 20200416 KHSONG C20200413-000593 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨
									,a.[PLANT_SITE_ID]
									,a.[YYYYMMDD]
							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End (#T_CFM_DEMAND_INSERT)		


							UPDATE #T_CFM_DEMAND_INSERT 
							SET CELL_PROD_SITE_ID = '-'			--[PJ2025-50017] CELL_PROD_SITE_ID 기본값을 '-'로 정의
							WHERE DIVISION_ID = '40'
							AND   CELL_PROD_SITE_ID = ''
							AND   MEASURE IN ('RTF','RTF_SYS_RP','RTF_SCP','RTF_PR')
							;


														---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
							-- [C20210323-000456] ESS 판매법인의 VMI_IN_PLAN 에 대해서 5영업일 뒤로 미뤄줌
							UPDATE A
							SET YYYYMMDD = DBO.FN_GET_BIZ_DAY(A.YYYYMMDD, B.LT_CNT)
							FROM #T_MKT_FCST_INSERT A
							JOIN (
								SELECT SEGMENT1 AS SCM_SITE_ID
									, SEGMENT2 AS LT_CNT
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
								WHERE LOOKUP_TYPE = 'ESS_SALES_PLANT_LT'
									AND VALID_YN = 'Y'
									AND TRY_CAST(SEGMENT2 AS INT) > 0
								) B ON A.SCM_SITE_ID = B.SCM_SITE_ID
							WHERE A.DIVISION_ID = '82'
								AND A.MEASURE = 'VMI_In_Plan'


							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start (#T_CFM_DEMAND_INSERT)		
							UPDATE A
							SET YYYYMMDD = DBO.FN_GET_BIZ_DAY(A.YYYYMMDD, B.LT_CNT)
							FROM #T_CFM_DEMAND_INSERT A
							JOIN (
								SELECT SEGMENT1 AS SCM_SITE_ID
									, SEGMENT2 AS LT_CNT
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
								WHERE LOOKUP_TYPE = 'ESS_SALES_PLANT_LT'
									AND VALID_YN = 'Y'
									AND TRY_CAST(SEGMENT2 AS INT) > 0
								) B ON A.SCM_SITE_ID = B.SCM_SITE_ID
							WHERE A.DIVISION_ID = '82'
								AND A.MEASURE = 'VMI_In_Plan'
							;

							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End (#T_CFM_DEMAND_INSERT)	

 PRINT ( @v_program_name + ' A009: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	

							-------------- SAFETY STOCK LEVEL, GAP 메저 처리		----------------------------------------------------
							IF @P_division_id LIKE N'81%'
							BEGIN
								-- TO_SITE, ITEM_ID 기준으로 정렬한다.
								INSERT INTO #T_SSLVL ( DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE, INCOTERMS, PLANT_SITE_ID, DOM_EXP )
								SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.PROJECT_CODE, A.INCOTERMS, A.PLANT_SITE_ID, A.DOM_EXP
								FROM (
									SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.PROJECT_CODE, A.INCOTERMS, A.PLANT_SITE_ID, A.DOM_EXP
										, ROW_NUMBER() OVER ( PARTITION BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID 
															ORDER BY A.PROJECT_CODE, A.INCOTERMS, A.PLANT_SITE_ID, A.DOM_EXP ) AS ROW_NUM
									FROM (
										SELECT DISTINCT A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.PROJECT_CODE, A.INCOTERMS, A.PLANT_SITE_ID, A.DOM_EXP
										FROM DM_PLN_MKT_FCST A
										WHERE A.YYYYMMDD >= @plan_start_yyyymmdd
										--AND A.MEASURE IN ( 'MKT_FCST', 'RTF_SYS_RP', 'VMI_IN_REQ', 'AS_IN_REQ', 'BNP_IN' )
										AND A.MEASURE IN ( @v_measure, 'RTF_SYS_RP', 'VMI_IN_REQ', 'AS_IN_REQ', 'BNP_IN' )		--  [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
										AND A.DIVISION_ID = @p_division_id
										) A
									) A
								WHERE ROW_NUM = 1

							
								DECLARE @V_STOCK_SEQ INT
								SELECT @V_STOCK_SEQ = MAX(SEQ)
								FROM SCP_ANL_PSI_GLOBAL_V 	WITH(NOLOCK)
								WHERE DIVISION_ID = @p_division_id
								AND PLAN_START_YYYYMMDD = @plan_start_yyyymmdd
								AND PLAN_TYPE = 'FN'

								INSERT INTO #T_MKT_FCST_INSERT ( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
											,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
											,LAST_UPDATED_BY,LAST_UPDATE_DATE )

								SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, 'MPS' AS FCST_TYPE
									, A.INCOTERMS, C.MEASURE, A.PLANT_SITE_ID, B.YYYYMMDD
									, CASE WHEN C.MEASURE = 'SS_LVL' THEN B.SAFETY_STOCK
												ELSE B.GAP
												END AS QTY
									, 'SYSTEM' AS CREATED_BY, GETDATE() AS CREATION_DATE, 'SYSTEM' AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
								FROM #T_SSLVL A
								JOIN [dbo].SCP_ANL_PSI_GLOBAL_V B 
															ON A.DIVISION_ID = B.DIVISION_ID 
															AND A.SCM_SITE_ID = B.TO_SITE 
															AND A.ITEM_ID = B.ITEM_ID
															AND B.PLAN_START_YYYYMMDD = @plan_start_yyyymmdd
															AND B.PLAN_TYPE = 'FN'
															AND B.SEQ = @V_STOCK_SEQ
								JOIN ( 
										SELECT 'SS_LVL' AS MEASURE
										UNION ALL
										SELECT 'SS_GAP' AS MEASURE
									) C ON 1=1
								WHERE A.DIVISION_ID = @p_division_id



							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start (#T_CFM_DEMAND_INSERT)		

								INSERT INTO #T_CFM_DEMAND_INSERT ( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
											,INCOTERMS,MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE		--[PJ2025-50017] CELL_PROD_SITE_ID 추가
											,LAST_UPDATED_BY,LAST_UPDATE_DATE )

								SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, 'MPS' AS FCST_TYPE
									, A.INCOTERMS, C.MEASURE, A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID, B.YYYYMMDD							--[PJ2025-50017] CELL_PROD_SITE_ID 추가
									, CASE WHEN C.MEASURE = 'SS_LVL' THEN B.SAFETY_STOCK
												ELSE B.GAP
												END AS QTY
									, 'SYSTEM' AS CREATED_BY, GETDATE() AS CREATION_DATE, 'SYSTEM' AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
								FROM #T_SSLVL A
								JOIN [dbo].SCP_ANL_PSI_GLOBAL_V B 
															ON A.DIVISION_ID = B.DIVISION_ID 
															AND A.SCM_SITE_ID = B.TO_SITE 
															AND A.ITEM_ID = B.ITEM_ID
															AND B.PLAN_START_YYYYMMDD = @plan_start_yyyymmdd
															AND B.PLAN_TYPE = 'FN'
															AND B.SEQ = @V_STOCK_SEQ
								JOIN ( 
										SELECT 'SS_LVL' AS MEASURE
										UNION ALL
										SELECT 'SS_GAP' AS MEASURE
									) C ON 1=1
								WHERE A.DIVISION_ID = @p_division_id

							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End (#T_CFM_DEMAND_INSERT)		


							END
							---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 PRINT ( @v_program_name + ' A010: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	


							insert into DM_PLN_MKT_FCST
										( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
										,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
										,LAST_UPDATED_BY,LAST_UPDATE_DATE
										)
							SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
										,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
										,LAST_UPDATED_BY,LAST_UPDATE_DATE
							FROM #T_MKT_FCST_INSERT	WITH(NOLOCK)
							WHERE MEASURE NOT IN ( 'VMI_IN_PLAN', 'AS_In_Plan' )
							
							UNION ALL

							SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
										,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD, SUM(QTY) AS QTY, MAX(CREATED_BY), MAX(CREATION_DATE)
										,MAX(LAST_UPDATED_BY), MAX(LAST_UPDATE_DATE)
							FROM #T_MKT_FCST_INSERT	WITH(NOLOCK)
							WHERE MEASURE IN ( 'VMI_IN_PLAN', 'AS_In_Plan' )
							GROUP BY DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
										,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD

							UNION ALL

							SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
										,INCOTERMS,'RTF_SYS_RP' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
										,LAST_UPDATED_BY,LAST_UPDATE_DATE
							FROM #T_MKT_FCST_INSERT	WITH(NOLOCK)
							WHERE MEASURE = 'RTF_SCP'  -- 20190709 KHSONG [CSR ID:4027463] MEASURE 추가 INSERT 
														
							UNION ALL 
							-- [PJ2025-50017] RTF_PR 신규 추가 Start
							SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
										,INCOTERMS,'RTF_PR' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE		 
										,LAST_UPDATED_BY,LAST_UPDATE_DATE
							FROM #T_MKT_FCST_INSERT	WITH(NOLOCK)
							WHERE MEASURE = 'RTF_SCP' 
							-- [PJ2025-50017] RTF_PR 신규 추가 End
							UNION ALL --[C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용

							SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
										,INCOTERMS,'RTF' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
										,LAST_UPDATED_BY,LAST_UPDATE_DATE
							FROM #T_MKT_FCST_INSERT	WITH(NOLOCK)
							WHERE MEASURE = 'RTF_SCP'
							AND   DIVISION_ID = '82'

							

							-- RMA 처리 C20200518-000359
							insert into DM_PLN_MKT_FCST
										( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
										,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
										,LAST_UPDATED_BY,LAST_UPDATE_DATE )
							SELECT		 a.DIVISION_ID, a.PROJECT_CODE, a.SCM_SITE_ID, a.ITEM_ID, a.DOM_EXP, a.FCST_TYPE
										,a.INCOTERMS,'RTF_SYS_RP' AS MEASURE, a.PLANT_SITE_ID, a.YYYYMMDD, a.QTY
										,'SYSTEM' CREATED_BY
										,GETDATE() CREATION_DATE
										,'SYSTEM' LAST_UPDATED_BY
										,GETDATE() LAST_UPDATE_DATE
								FROM DM_PLN_MKT_FCST a WITH(NOLOCK)
   							--	JOIN ( SELECT 'RTF_SYS_RP' AS MEASURE
										--UNION ALL
										--  SELECT 'RTF_SCP' AS MEASURE ) B ON 1=1
								WHERE a.DIVISION_ID          = @c_division_id
									and YYYYMMDD >= @c_plan_start_yyyymmdd
									AND A.DIVISION_ID = '40'
									--AND A.MEASURE = 'MKT_FCST'			
									AND A.MEASURE = @v_measure			--  [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
									AND A.FCST_TYPE = 'RMA'
									AND @c_division_id = @c_scp_division_id -- 2025.01.10 P.C.I 전극인 경우에 RMA 처리 로직 제외

							-- [PJ2025-50017] RTF_PR 신규 추가 Start
							UNION ALL
							SELECT		 a.DIVISION_ID, a.PROJECT_CODE, a.SCM_SITE_ID, a.ITEM_ID, a.DOM_EXP, a.FCST_TYPE
										,a.INCOTERMS,'RTF_PR' AS MEASURE, a.PLANT_SITE_ID, a.YYYYMMDD, a.QTY
										,'SYSTEM' CREATED_BY
										,GETDATE() CREATION_DATE
										,'SYSTEM' LAST_UPDATED_BY
										,GETDATE() LAST_UPDATE_DATE
							FROM DM_PLN_MKT_FCST a WITH(NOLOCK)
							WHERE a.DIVISION_ID    = @c_division_id
								and YYYYMMDD >= @c_plan_start_yyyymmdd
								AND A.DIVISION_ID = '40'
								--AND A.MEASURE = 'MKT_FCST'
								AND A.MEASURE = @v_measure			--  [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
								AND A.FCST_TYPE = 'RMA'
								AND @c_division_id = @c_scp_division_id 
							-- [PJ2025-50017] RTF_PR 신규 추가 Start


		

							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start (#T_CFM_DEMAND_INSERT)				
							
							insert into DBO.DM_PLN_CFM_MKT_DEMAND_PLAN 
										( DIVISION_ID
										,PROJECT_CODE
										,END_CUSTOMER
										,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
										,INCOTERMS,MEASURE,PLANT_SITE_ID
										,CELL_PROD_SITE_ID							--[PJ2025-50017] CELL_PROD_SITE_ID 추가
										,ATTRIBUTE2									--[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
										,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
										,LAST_UPDATED_BY,LAST_UPDATE_DATE
										)
							SELECT DIVISION_ID
										,PROJECT_CODE
										,CASE WHEN DIVISION_ID='40'	THEN PROJECT_CODE	ELSE ''				END				AS END_CUSTOMER
										,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
										,INCOTERMS,MEASURE,PLANT_SITE_ID
										,CELL_PROD_SITE_ID																						--[PJ2025-50017] CELL_PROD_SITE_ID 추가
										,CASE WHEN DIVISION_ID = '40' THEN FROM_SITE_ID	ELSE NULL			END				AS ATTRIBUTE2		--[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
										,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
										,LAST_UPDATED_BY,LAST_UPDATE_DATE
							FROM #T_CFM_DEMAND_INSERT	WITH(NOLOCK)
							WHERE MEASURE NOT IN ( 'VMI_IN_PLAN', 'AS_In_Plan' )
							
							UNION ALL

							SELECT DIVISION_ID
										,PROJECT_CODE
										,CASE WHEN DIVISION_ID='40'	THEN PROJECT_CODE	ELSE ''				END				AS END_CUSTOMER
										,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
										,INCOTERMS,MEASURE,PLANT_SITE_ID
										,CELL_PROD_SITE_ID																						--[PJ2025-50017] CELL_PROD_SITE_ID 추가
										,CASE WHEN DIVISION_ID = '40' THEN MAX(FROM_SITE_ID)	ELSE NULL	END				AS ATTRIBUTE2		--[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
										,YYYYMMDD, SUM(QTY) AS QTY, MAX(CREATED_BY), MAX(CREATION_DATE)
										,MAX(LAST_UPDATED_BY), MAX(LAST_UPDATE_DATE)
							FROM #T_CFM_DEMAND_INSERT	WITH(NOLOCK)
							WHERE MEASURE IN ( 'VMI_IN_PLAN', 'AS_In_Plan' )
							GROUP BY DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
										,INCOTERMS,MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID														--[PJ2025-50017] CELL_PROD_SITE_ID 추가
										,YYYYMMDD

							UNION ALL
							SELECT DIVISION_ID
										,PROJECT_CODE
										,CASE WHEN DIVISION_ID='40'	THEN PROJECT_CODE	ELSE ''				END				AS END_CUSTOMER
										,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
										,INCOTERMS,'RTF_SYS_RP' AS MEASURE,PLANT_SITE_ID	
										,CELL_PROD_SITE_ID																						--[PJ2025-50017] CELL_PROD_SITE_ID 추가
										,CASE WHEN DIVISION_ID = '40' THEN FROM_SITE_ID	ELSE NULL			END				AS ATTRIBUTE2		--[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
										,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
										,LAST_UPDATED_BY,LAST_UPDATE_DATE
							FROM #T_CFM_DEMAND_INSERT	WITH(NOLOCK)
							WHERE MEASURE = 'RTF_SCP'  -- 20190709 KHSONG [CSR ID:4027463] MEASURE 추가 INSERT 

							-- [PJ2025-50017] RTF_PR 신규 추가 Start
							UNION ALL
							SELECT DIVISION_ID
										,PROJECT_CODE
										,CASE WHEN DIVISION_ID='40'	THEN PROJECT_CODE	ELSE ''				END				AS END_CUSTOMER
										,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
										,INCOTERMS,'RTF_PR' AS MEASURE,PLANT_SITE_ID
										,CELL_PROD_SITE_ID																						--[PJ2025-50017] CELL_PROD_SITE_ID 추가
										,CASE WHEN DIVISION_ID = '40' THEN FROM_SITE_ID	ELSE NULL			END				AS ATTRIBUTE2		--[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
										,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
										,LAST_UPDATED_BY,LAST_UPDATE_DATE
							FROM #T_CFM_DEMAND_INSERT	WITH(NOLOCK)
							WHERE MEASURE = 'RTF_SCP'  
							-- [PJ2025-50017] RTF_PR 신규 추가 End
													

							-- RMA 처리 C20200518-000359
							insert into DBO.DM_PLN_CFM_MKT_DEMAND_PLAN 
										( DIVISION_ID
										,PROJECT_CODE
										,END_CUSTOMER
										,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
										,INCOTERMS,MEASURE,PLANT_SITE_ID
										,CELL_PROD_SITE_ID																						--[PJ2025-50017] CELL_PROD_SITE_ID 추가
										,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
										,LAST_UPDATED_BY,LAST_UPDATE_DATE )
							SELECT		 a.DIVISION_ID
										,A.PROJECT_CODE
										,A.END_CUSTOMER
										,a.SCM_SITE_ID, a.ITEM_ID, a.DOM_EXP, a.FCST_TYPE
										,a.INCOTERMS,'RTF_SYS_RP' AS MEASURE, a.PLANT_SITE_ID
										,A.CELL_PROD_SITE_ID																					--[PJ2025-50017] CELL_PROD_SITE_ID 추가
										,a.YYYYMMDD, a.QTY
										,'SYSTEM' CREATED_BY
										,GETDATE() CREATION_DATE
										,'SYSTEM' LAST_UPDATED_BY
										,GETDATE() LAST_UPDATE_DATE
--								FROM DM_PLN_MKT_FCST A WITH(NOLOCK)						-- [PJ2025-50017] 소형매출 동기화 계획
							FROM DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)
   						--	JOIN ( SELECT 'RTF_SYS_RP' AS MEASURE
									--UNION ALL
									--  SELECT 'RTF_SCP' AS MEASURE ) B ON 1=1
							WHERE a.DIVISION_ID          = @c_division_id
								and YYYYMMDD >= @c_plan_start_yyyymmdd
								AND A.DIVISION_ID = '40'
								--AND A.MEASURE = 'MKT_FCST'		
								AND A.MEASURE = @v_measure				--  [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
								AND A.FCST_TYPE = 'RMA'
								AND @c_division_id = @c_scp_division_id -- 2025.01.10 P.C.I 전극인 경우에 RMA 처리 로직 제외
							-- [PJ2025-50017] RTF_PR 신규 추가 Start
							UNION ALL
							SELECT		 a.DIVISION_ID
										,A.PROJECT_CODE
										,A.END_CUSTOMER
										,a.SCM_SITE_ID, a.ITEM_ID, a.DOM_EXP, a.FCST_TYPE
										,a.INCOTERMS,'RTF_PR' AS MEASURE, a.PLANT_SITE_ID
										,A.CELL_PROD_SITE_ID																					--[PJ2025-50017] CELL_PROD_SITE_ID 추가
										,a.YYYYMMDD, a.QTY
										,'SYSTEM' CREATED_BY
										,GETDATE() CREATION_DATE
										,'SYSTEM' LAST_UPDATED_BY
										,GETDATE() LAST_UPDATE_DATE
--								FROM DM_PLN_MKT_FCST A WITH(NOLOCK)						-- [PJ2025-50017] 소형매출 동기화 계획
							FROM DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)
							WHERE a.DIVISION_ID          = @c_division_id
								and YYYYMMDD >= @c_plan_start_yyyymmdd
								AND A.DIVISION_ID = '40'
								--AND A.MEASURE = 'MKT_FCST'
								AND A.MEASURE = @v_measure 				--  [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
								AND A.FCST_TYPE = 'RMA'
								AND @c_division_id = @c_scp_division_id 
							-- [PJ2025-50017] RTF_PR 신규 추가 End

							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End (#T_CFM_DEMAND_INSERT)				

							
						END
						---------------------------------- RTF MEASURE MKT_FCST TABLE INSERT (END)

 PRINT ( @v_program_name + ' A011: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	
						---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
						--                                                                                                                                      VMI재고 확인후 RTF 생성 로직 (START)
						---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
                        -- [C20220224-000448] ESS 사업부 VMI 기능 자동차사업부 확산 전개 요청 (자동차 사업부 VMI_INV 생성하지 않음)
                        IF @c_division_id NOT LIKE '81%'
						BEGIN
							------------------------------------------------------------------------------------------------
							--PRINT '#T_VMI_MST_MAIN INSERT START                        =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
							----------------------------------------------------------|
									-- 성능이슈로 TEMP테이블로 사용
									SELECT L.DIVISION_ID, l.SCM_SITE_ID, s.item_id, S.QTY
									INTO #FP_STOCK_QTY
									FROM scm_dnm_stock_sn s with(nolock)  
										,scm_mst_location l with(nolock)
									where l.division_id = s.division_id
									and l.storage_id = s.storage_id
									and convert( varchar, s.cutoff_date,112)  = @plan_start_yyyymmdd
									UNION ALL	-- [C20201103-000114]
									select l.division_id, l.scm_site_id, s.item_id, s.QTY
									FROM scm_dnm_stock_sales s with(nolock)
										,scm_mst_location l with(nolock)
									where l.division_id = s.division_id
									and l.storage_id = s.storage_id
									--[C20201222-000376]
									and L.PLANT_ID = S.PLANT_ID				-- 여기는 PLANT까지 걸어야 함.
									AND S.DIVISION_ID = '82'
									and s.result_date = CONVERT(CHAR(8), DATEADD(DAY, -1, @plan_start_yyyymmdd), 112)



PRINT ( 'A3--' + CONVERT(NVARCHAR(30), GETDATE(), 121))	

									IF @p_division_id = '40'
									BEGIN
										-- INSERT
										insert into #T_VMI_MST_MAIN
										(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty,CELL_PROD_SITE_ID,FROM_SITE_ID)		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
										select  distinct
												a.DIVISION_ID 				,
												a.PROJECT_CODE 				,
												a.SCM_SITE_ID 				,
												a.ITEM_ID 					,
												a.DOM_EXP 					,
												a.FCST_TYPE 				,
												a.INCOTERMS 				,
												a.measure					,
												a.PLANT_SITE_ID 			,
												b.BASIS_YYYYMMDD   YYYYMMDD ,
												-- 20180725 ytchoi vmi stock qty 를 기초재고로 적용 (S)
												-- 20221206 -- 11 자리 LIKE 는 소형사업부에만 적용
												CASE WHEN A.DIVISION_ID = '40' THEN 
															CASE WHEN b.BASIS_YYYYMMDD = @plan_start_yyyymmdd AND  a.measure in ('Vmi_In_Plan')
																	THEN ISNULL(c.qty,0) + ISNULL(( SELECT SUM(s.qty)  
																									FROM #FP_STOCK_QTY S
																									where S.SCM_SITE_ID = A.SCM_SITE_ID
																										AND S.DIVISION_ID = A.DIVISION_ID
																										and s.item_id like  (case when substring(a.ITEM_ID, 1,2) = 'MP' THEN substring( a.ITEM_ID, 1,11) ELSE a.ITEM_ID END ) +'%' 
																																			) ,0)
																	ELSE ISNULL(c.qty,0) END
													ELSE 
															CASE WHEN b.BASIS_YYYYMMDD = @plan_start_yyyymmdd AND  a.measure in ('Vmi_In_Plan')
																	THEN ISNULL(c.qty,0) + ISNULL(( SELECT SUM(s.qty)  
																									FROM #FP_STOCK_QTY S
																									where S.SCM_SITE_ID = A.SCM_SITE_ID
																										AND S.DIVISION_ID = A.DIVISION_ID
																										and s.item_id = a.ITEM_ID
																									) ,0)
																	ELSE ISNULL(c.qty,0) END
													END AS QTY				,
													-- 20180725 ytchoi vmi stock qty 를 초재고로 적용 (E)
												A.CELL_PROD_SITE_ID		,						-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
												A.FROM_SITE_ID									-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
											from ( SELECT DISTINCT W.DIVISION_ID 				,
																	W.PROJECT_CODE 				,
																	W.SCM_SITE_ID 				,
																	W.ITEM_ID 					,
																	W.DOM_EXP 					,
																	W.FCST_TYPE 				,
																	W.INCOTERMS 				,
																	W.measure					,
																	W.PLANT_SITE_ID 			,		
																	W.CELL_PROD_SITE_ID			,				-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
																	W.ATTRIBUTE2		AS FROM_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
													FROM DM_PLN_CFM_MKT_DEMAND_PLAN W with(nolock)			-- [PJ2025-50017] 40사업부는 DM_PLN_MKT_FCST ==>  DM_PLN_CFM_MKT_DEMAND_PLAN 기준 변경
													INNER JOIN #T_results ST WITH(NOLOCK)
													ON  w.division_id        =   st.division_id      
													AND w.project_code       =   st.project_code   
													AND w.scm_site_id        =   st.scm_site_id  
													AND w.item_id            =   st.item_id      
													AND w.dom_exp            =   st.dom_exp      
													AND w.fcst_type          =   st.fcst_type    
													AND w.incoterms          =   st.incoterms    
													AND w.plant_site_id      =   st.plant_site_id
													AND w.CELL_PROD_SITE_ID  =   st.CELL_PROD_SITE_ID		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
													AND	ST.VMI_YN   = 'Y'  -- vmi대상만 입력

													WHERE W.YYYYMMDD between @plan_start_yyyymmdd
													AND CONVERT(CHAR(8), DATEADD(WW, @plan_week_cnt, @plan_start_yyyymmdd  ),112)  -- SCP PLANNING 구간이 52주
													) A
											inner join SCM_SYS_CALENDAR_M  b with(nolock)
												on b.BASIS_YYYYMMDD between @plan_start_yyyymmdd
													AND CONVERT(CHAR(8), DATEADD(WW, @plan_week_cnt, @plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주
											left join DM_PLN_CFM_MKT_DEMAND_PLAN c with(nolock)				-- [PJ2025-50017] 40사업부는 DM_PLN_MKT_FCST ==>  DM_PLN_CFM_MKT_DEMAND_PLAN 기준 변경
												ON		a.division_id		= c.division_id
												AND		a.project_code		= c.project_code
												AND		a.scm_site_id		= c.scm_site_id
												AND		a.item_id			= c.item_id
												AND		a.dom_exp			= c.dom_exp
												AND		a.fcst_type			= c.fcst_type
												AND		a.incoterms			= c.incoterms
												AND		a.plant_site_id		= c.plant_site_id
												and     a.measure			= c.measure
												and     b.BASIS_YYYYMMDD    = c.yyyymmdd
												AND     A.CELL_PROD_SITE_ID	= C.CELL_PROD_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
											where 1=1
											--and a.measure in ('MKT_FCST', 'Vmi_In_Plan'); 
											and a.measure in (@v_measure, 'Vmi_In_Plan');			--  [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
											;

									END
									ELSE
									BEGIN
										-- INSERT
										insert into #T_VMI_MST_MAIN
										(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty, CELL_PROD_SITE_ID, FROM_SITE_ID)		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
										select  distinct																																			
												a.DIVISION_ID 				,
												a.PROJECT_CODE 				,
												a.SCM_SITE_ID 				,
												a.ITEM_ID 					,
												a.DOM_EXP 					,
												a.FCST_TYPE 				,
												a.INCOTERMS 				,
												a.measure					,
												a.PLANT_SITE_ID 			,
												b.BASIS_YYYYMMDD   YYYYMMDD ,
												-- 20180725 ytchoi vmi stock qty 를 기초재고로 적용 (S)
												-- 20221206 -- 11 자리 LIKE 는 소형사업부에만 적용
												CASE WHEN A.DIVISION_ID = '40' THEN 
															CASE WHEN b.BASIS_YYYYMMDD = @plan_start_yyyymmdd AND  a.measure in ('Vmi_In_Plan')
																	THEN ISNULL(c.qty,0) + ISNULL(( SELECT SUM(s.qty)  
																									FROM #FP_STOCK_QTY S
																									where S.SCM_SITE_ID = A.SCM_SITE_ID
																										AND S.DIVISION_ID = A.DIVISION_ID
																										and s.item_id like  (case when substring(a.ITEM_ID, 1,2) = 'MP' THEN substring( a.ITEM_ID, 1,11) ELSE a.ITEM_ID END ) +'%' 
																																			) ,0)
																	ELSE ISNULL(c.qty,0) END
													ELSE 
															CASE WHEN b.BASIS_YYYYMMDD = @plan_start_yyyymmdd AND  a.measure in ('Vmi_In_Plan')
																	THEN ISNULL(c.qty,0) + ISNULL(( SELECT SUM(s.qty)  
																									FROM #FP_STOCK_QTY S
																									where S.SCM_SITE_ID = A.SCM_SITE_ID
																										AND S.DIVISION_ID = A.DIVISION_ID
																										and s.item_id = a.ITEM_ID
																									) ,0)
																	ELSE ISNULL(c.qty,0) END
													END AS QTY			,
												-- 20180725 ytchoi vmi stock qty 를 초재고로 적용 (E)
												'-'			AS CELL_PROD_SITE_ID		,						-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 (단, 40사업부 이외는 형식을 맞추기 위해 DEFAULT 값 입력)
												'-'			AS FROM_SITE_ID										-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 (단, 40사업부 이외는 형식을 맞추기 위해 DEFAULT 값 입력)
											from ( SELECT DISTINCT W.DIVISION_ID 				,
																	W.PROJECT_CODE 				,
																	W.SCM_SITE_ID 				,
																	W.ITEM_ID 					,
																	W.DOM_EXP 					,
																	W.FCST_TYPE 				,
																	W.INCOTERMS 				,
																	W.measure					,
																	W.PLANT_SITE_ID 			
															FROM DM_PLN_MKT_FCST W with(nolock) 
															INNER JOIN #T_results ST WITH(NOLOCK)
															ON  w.division_id        =   st.division_id      
															AND w.project_code       =   st.project_code   
															AND w.scm_site_id        =   st.scm_site_id  
															AND w.item_id            =   st.item_id      
															AND w.dom_exp            =   st.dom_exp      
															AND w.fcst_type          =   st.fcst_type    
															AND w.incoterms          =   st.incoterms    
															AND w.plant_site_id      =   st.plant_site_id
															AND	ST.VMI_YN   = 'Y'  -- vmi대상만 입력

														WHERE W.YYYYMMDD between @plan_start_yyyymmdd
													AND CONVERT(CHAR(8), DATEADD(WW, @plan_week_cnt, @plan_start_yyyymmdd  ),112)  -- SCP PLANNING 구간이 52주
													) A
											inner join SCM_SYS_CALENDAR_M  b with(nolock)
												on b.BASIS_YYYYMMDD between @plan_start_yyyymmdd
													AND CONVERT(CHAR(8), DATEADD(WW, @plan_week_cnt, @plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주
											left join DM_PLN_MKT_FCST c with(nolock)
												ON		a.division_id		= c.division_id
												AND		a.project_code		= c.project_code
												AND		a.scm_site_id		= c.scm_site_id
												AND		a.item_id			= c.item_id
												AND		a.dom_exp			= c.dom_exp
												AND		a.fcst_type			= c.fcst_type
												AND		a.incoterms			= c.incoterms
												AND		a.plant_site_id		= c.plant_site_id
												and     a.measure			= c.measure
												and     b.BASIS_YYYYMMDD    = c.yyyymmdd
												where 1=1
											--and a.measure in ('MKT_FCST', 'Vmi_In_Plan'); 
											and a.measure in (@v_measure, 'Vmi_In_Plan');				--  [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
											;
									END;

								--PRINT '#T_VMI_temp1 INSERT START                         =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
								----------------------------------------------------------|

									/*
									[C20220615-000414] RESU16H_Prime RTF 에러의 건
									MKT_FCST는 존재하나 Vmi_In_Plan이 존재하지 않고 scm_dnm_stock_sn에 기초재고가 존재하는 site의 item들은 Vmi_In_Plan을 생성
									plan 시작일 기준 기초재고 수량 이후 0으로 qty 설정
									*/
									WITH T_CHK_PLAN AS (
										SELECT  DIVISION_ID
											, PROJECT_CODE
											, SCM_SITE_ID
											, ITEM_ID
											, DOM_EXP
											, FCST_TYPE
											, INCOTERMS
											, MEASURE,PLANT_SITE_ID  
											, CELL_PROD_SITE_ID , FROM_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
										FROM  #T_VMI_MST_MAIN 
										WHERE MEASURE = 'Vmi_In_Plan'
										GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP,FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
												, CELL_PROD_SITE_ID , FROM_SITE_ID		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
									)
									INSERT INTO #T_VMI_MST_MAIN
									-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
									-- 2025.05.30 MEASURE와 PLANT_SITE_ID 뒤집힘 에러 발생 ==> 원래대로 주석처리
									--(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id,measure,yyyymmdd,qty,CELL_PROD_SITE_ID,FROM_SITE_ID)		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
									SELECT  AA.DIVISION_ID
											, AA.PROJECT_CODE
											, AA.SCM_SITE_ID
											, AA.ITEM_ID
											, AA.DOM_EXP
											, AA.FCST_TYPE
											, AA.INCOTERMS
											, AA.PLANT_SITE_ID
											, 'Vmi_In_Plan' AS MEASURE
											, AA.YYYYMMDD AS YYYYMMDD 
											, CASE WHEN @plan_start_yyyymmdd = AA.YYYYMMDD  THEN BB.QTY ELSE 0 END AS QTY 
											, CELL_PROD_SITE_ID, FROM_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
									FROM #T_VMI_MST_MAIN  AS AA
									INNER JOIN (
										SELECT A.DIVISION_ID
											,A.SCM_SITE_ID
											,A.ITEM_ID
											, SUM(A.QTY) AS QTY
										FROM #FP_STOCK_QTY AS A
										LEFT OUTER JOIN  T_CHK_PLAN AS B
										ON	A.DIVISION_ID	= B.DIVISION_ID
										AND A.SCM_SITE_ID	= B.SCM_SITE_ID
										AND A.ITEM_ID		= B.ITEM_ID
										WHERE B.DIVISION_ID IS NULL
										GROUP BY A.DIVISION_ID
											,A.SCM_SITE_ID
											,A.ITEM_ID
									)  AS BB
									ON		AA.DIVISION_ID		= BB.DIVISION_ID
									AND		AA.SCM_SITE_ID		= BB.SCM_SITE_ID
									AND		AA.ITEM_ID			= BB.ITEM_ID
									AND		BB.QTY > 0;


 PRINT ( @v_program_name + ' A012: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	

									INSERT INTO #T_VMI_MST
									(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty,CELL_PROD_SITE_ID,FROM_SITE_ID)		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
									SELECT a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp, a.fcst_type, a.incoterms, a.measure, a.plant_site_id, a.yyyymmdd,a.qty
											, A.CELL_PROD_SITE_ID, A.FROM_SITE_ID				-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
									FROM #T_VMI_MST_MAIN A
									inner join #T_results s
													on (    a.division_id        =   s.division_id      
														AND a.project_code       =   s.project_code   
														AND a.scm_site_id        =   s.scm_site_id  
														AND a.item_id            =   s.item_id      
														AND a.dom_exp            =   s.dom_exp      
														AND a.fcst_type          =   s.fcst_type    
														AND a.incoterms          =   s.incoterms    
														AND a.plant_site_id      =   s.plant_site_id
														AND A.CELL_PROD_SITE_ID	 =   S.CELL_PROD_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
														and s.VMI_YN   = 'Y'
														)
									WHERE 1=1

									--
									insert into #T_VMI_temp1
									(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty,accum_sum,last_accum_sum,CELL_PROD_SITE_ID,FROM_SITE_ID) -- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가

									SELECT a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd, A.QTY 
										, SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) 'accum_sum'
										, SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) - A.QTY  'last_accum_sum' 
										, A.CELL_PROD_SITE_ID, A.FROM_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
										FROM #T_VMI_MST A
										inner join #T_results s
														on (    a.division_id        =   s.division_id      
															AND a.project_code       =   s.project_code   
															AND a.scm_site_id        =   s.scm_site_id  
															AND a.item_id            =   s.item_id      
															AND a.dom_exp            =   s.dom_exp      
															AND a.fcst_type          =   s.fcst_type    
															AND a.incoterms          =   s.incoterms    
															AND a.plant_site_id      =   s.plant_site_id
															AND A.CELL_PROD_SITE_ID	 =   S.CELL_PROD_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
															and s.VMI_YN   = 'Y'
															)
										--where a.measure		= 'MKT_FCST'				
										where a.measure		= @v_measure				--  [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
										and a.yyyymmdd		>= @plan_start_yyyymmdd

									--PRINT '#T_VMI_temp2 INSERT START                         =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
									----------------------------------------------------------|

									insert into #T_VMI_temp2
									(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty,accum_sum,last_accum_sum,CELL_PROD_SITE_ID,FROM_SITE_ID)	-- 2025.04.30 P.C.I 

									SELECT a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd, A.QTY 
										, SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) 'accum_sum'
										, SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) - A.QTY  'last_accum_sum' 
										, A.CELL_PROD_SITE_ID, A.FROM_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
										FROM #T_VMI_MST A
										inner join #T_results s
														on (    a.division_id        =   s.division_id      
															AND a.project_code       =   s.project_code   
															AND a.scm_site_id        =   s.scm_site_id  
															AND a.item_id            =   s.item_id      
															AND a.dom_exp            =   s.dom_exp      
															AND a.fcst_type          =   s.fcst_type    
															AND a.incoterms          =   s.incoterms    
															AND a.plant_site_id      =   s.plant_site_id
															AND A.CELL_PROD_SITE_ID	 =   S.CELL_PROD_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
															and s.VMI_YN   = 'Y'
															)
										where a.measure		= 'Vmi_In_Plan'
										and a.yyyymmdd		>= @plan_start_yyyymmdd

								---------------------------------------------------------------------------------------- 

								--PRINT '#T_VMI_temp_all INSERT START                      =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
								----------------------------------------------------------|

 PRINT ( @v_program_name + ' A013: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	
									insert into #T_VMI_temp_all
									(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id,yyyymmdd,RTF_QTY,INV,CELL_PROD_SITE_ID,FROM_SITE_ID)		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
									select a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.plant_site_id,a.yyyymmdd
											,SUM( case when isnull(a.accum_sum,0) > isnull(b.accum_sum,0) then isnull(b.accum_sum,0) else isnull(a.accum_sum,0) end ) - SUM( case when isnull(a.last_accum_sum,0) > isnull(b.last_accum_sum,0) then isnull(b.last_accum_sum,0) else isnull(a.last_accum_sum,0) end ) RTF_QTY
											,SUM(isnull(b.accum_sum,0) - isnull(a.accum_sum,0)) INV
											,B.CELL_PROD_SITE_ID, B.FROM_SITE_ID		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
										from #T_VMI_temp1 a  --  'MKT_FCST'
											,#T_VMI_temp2 b  --  'Vmi_In_Plan'
										where a.division_id	= b.DIVISION_ID
										and a.project_code	= b.project_code
										and a.scm_site_id	= b.scm_site_id
										and a.item_id		= b.ITEM_ID
										and a.fcst_type		= b.FCST_TYPE
										and a.incoterms		= b.incoterms
										and a.plant_site_id	= b.PLANT_SITE_ID
										and a.dom_exp		= b.dom_exp
										and a.yyyymmdd		= b.YYYYMMDD
										AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
									group by a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd
											, B.CELL_PROD_SITE_ID, B.FROM_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
									order by a.yyyymmdd
									;										



							--PRINT 'DM_PLN_MKT_FCST VMI_Inv DELETE START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
							----------------------------------------------------------|
							---------------------------------- 초기화 (START)
					/*
					-- 20200416 KHSONG C20200413-000593 주석처리
					DELETE 
					FROM dbo.DM_PLN_MKT_FCST
						where MEASURE IN ('VMI_Inv','RTF')
						    and division_id in ('82')  -- 20190624 KHSONG [CSR_ID:4016234]
							and exists (
									SELECT division_id 
										FROM #T_results
										where 1=1
										and DM_PLN_MKT_FCST.division_id        =   division_id      
										AND DM_PLN_MKT_FCST.project_code       =   project_code   
										AND DM_PLN_MKT_FCST.scm_site_id        =   scm_site_id  
										AND DM_PLN_MKT_FCST.item_id            =   item_id      
										AND DM_PLN_MKT_FCST.dom_exp            =   dom_exp      
										AND DM_PLN_MKT_FCST.fcst_type          =   fcst_type    
										AND DM_PLN_MKT_FCST.incoterms          =   incoterms    
										AND DM_PLN_MKT_FCST.plant_site_id      =   plant_site_id
										AND vmi_yn = 'Y'
										AND DM_PLN_MKT_FCST.yyyymmdd           >=   @plan_start_yyyymmdd  -- 당주월요일
										and division_id in ('82') -- 20190624 KHSONG [CSR_ID:4016234]
										);
					*/


 PRINT ( @v_program_name + ' A014: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	

					DELETE 
					FROM dbo.DM_PLN_MKT_FCST
						where MEASURE IN ('VMI_Inv','RTF_SCP','RTF_SYS_RP', 'RTF_PR') --20190111 KHSONG 소형 'RTF_SCP' MEASURE 적용  -- 20190709 KHSONG [CSR ID:4027463] 'RTF_SYS_RP' MEASURE 추가 -- [PJ2025-50017] RTF_PR 신규 추가
							--and division_id in ('40','81')     -- 20190624 KHSONG [CSR_ID:4016234]  -- 20200416 KHSONG C20200413-000593 주석처리 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨
							and exists (
									SELECT division_id 
										FROM #T_results
										where 1=1
										and DM_PLN_MKT_FCST.division_id        =   division_id      
										AND DM_PLN_MKT_FCST.project_code       =   project_code   
										AND DM_PLN_MKT_FCST.scm_site_id        =   scm_site_id  
										AND DM_PLN_MKT_FCST.item_id            =   item_id      
										AND DM_PLN_MKT_FCST.dom_exp            =   dom_exp      
										AND DM_PLN_MKT_FCST.fcst_type          =   fcst_type    
										AND DM_PLN_MKT_FCST.incoterms          =   incoterms    
										AND DM_PLN_MKT_FCST.plant_site_id      =   plant_site_id
										AND vmi_yn = 'Y'
										AND DM_PLN_MKT_FCST.yyyymmdd           >=   @plan_start_yyyymmdd  -- 당주월요일
										--and division_id in ('40','81') -- 20190624 KHSONG [CSR_ID:4016234]  -- 20200416 KHSONG C20200413-000593 주석처리 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨
										);
							--PRINT 'DM_PLN_MKT_FCST VMI_Inv INSERT START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
							----------------------------------------------------------|

					--[C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용
					
 PRINT ( @v_program_name + ' A015: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	

					DELETE 
					FROM dbo.DM_PLN_MKT_FCST
					where MEASURE   IN ('RTF')
					and division_id = '82'
					and exists (
							SELECT division_id 
								FROM #T_results
								where 1=1
								and DM_PLN_MKT_FCST.division_id        =   division_id      
								AND DM_PLN_MKT_FCST.project_code       =   project_code   
								AND DM_PLN_MKT_FCST.scm_site_id        =   scm_site_id  
								AND DM_PLN_MKT_FCST.item_id            =   item_id      
								AND DM_PLN_MKT_FCST.dom_exp            =   dom_exp      
								AND DM_PLN_MKT_FCST.fcst_type          =   fcst_type    
								AND DM_PLN_MKT_FCST.incoterms          =   incoterms    
								AND DM_PLN_MKT_FCST.plant_site_id      =   plant_site_id
								AND vmi_yn = 'Y'
								AND DM_PLN_MKT_FCST.yyyymmdd           >=   @plan_start_yyyymmdd
								);


				--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start		
							
					DELETE 
					FROM DBO.DM_PLN_CFM_MKT_DEMAND_PLAN 
					where MEASURE IN ('VMI_Inv','RTF_SCP','RTF_SYS_RP', 'RTF_PR') --20190111 KHSONG 소형 'RTF_SCP' MEASURE 적용  -- 20190709 KHSONG [CSR ID:4027463] 'RTF_SYS_RP' MEASURE 추가 -- [PJ2025-50017] RTF_PR 신규 추가
						--and division_id in ('40','81')     -- 20190624 KHSONG [CSR_ID:4016234]  -- 20200416 KHSONG C20200413-000593 주석처리 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨
						and exists (
								SELECT division_id 
									FROM #T_results
									where 1=1
									and DM_PLN_CFM_MKT_DEMAND_PLAN.division_id        =   division_id      
									AND CASE WHEN DM_PLN_CFM_MKT_DEMAND_PLAN.division_id = '40' then DM_PLN_CFM_MKT_DEMAND_PLAN.end_customer ELSE DM_PLN_CFM_MKT_DEMAND_PLAN.project_code END =   project_code   
									AND DM_PLN_CFM_MKT_DEMAND_PLAN.scm_site_id        =   scm_site_id  
									AND DM_PLN_CFM_MKT_DEMAND_PLAN.item_id            =   item_id      
									AND DM_PLN_CFM_MKT_DEMAND_PLAN.dom_exp            =   dom_exp      
									AND DM_PLN_CFM_MKT_DEMAND_PLAN.fcst_type          =   fcst_type    
									AND DM_PLN_CFM_MKT_DEMAND_PLAN.incoterms          =   incoterms    
									AND DM_PLN_CFM_MKT_DEMAND_PLAN.plant_site_id      =   plant_site_id
									AND vmi_yn = 'Y'
									AND DM_PLN_CFM_MKT_DEMAND_PLAN.yyyymmdd           >=   @plan_start_yyyymmdd  -- 당주월요일
									--and division_id in ('40','81') -- 20190624 KHSONG [CSR_ID:4016234]  -- 20200416 KHSONG C20200413-000593 주석처리 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨
									);
				--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End		



					---------------------------------- 계산된 VMI_Inv값 INSERT (START)
					insert into DM_PLN_MKT_FCST
								( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
								,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
								)
					/*
					-- 20200416 KHSONG C20200413-000593 주석처리
					select division_id , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'RTF' as measure ,plant_site_id, yyyymmdd
						--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
						,rtf_qty as QTY 
						,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null,null
					from  #T_VMI_temp_all
						WHERE yyyymmdd		>= @plan_start_yyyymmdd
						AND rtf_qty > 0 
						and division_id in ('82')  -- 20190624 KHSONG [CSR_ID:4016234]

					union all
					*/

					-- 20190709 KHSONG [CSR ID:4027463] 신규코드 (BEGIN)
					select division_id , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'RTF_SCP' as measure ,plant_site_id, yyyymmdd --20190111 KHSONG 소형 'RTF_SCP' MEASURE 적용
						--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
						,rtf_qty as QTY 
						,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null,null
					from  #T_VMI_temp_all
						WHERE yyyymmdd		>= @plan_start_yyyymmdd
						AND rtf_qty > 0 
						--and division_id in ('40','81')  -- 20190624 KHSONG [CSR_ID:4016234] -- 20200416 KHSONG C20200413-000593 주석처리 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨
					-- 20190709 KHSONG [CSR ID:4027463] 신규코드 (END)

					-- 20191104 KHSONG [CSR ID:4107133] VMI대상 RTF_SYS_RP MEASURE 생성로직 추가(START)
					UNION ALL

					select division_id , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'RTF_SYS_RP' as measure ,plant_site_id, yyyymmdd
						--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
						,rtf_qty as QTY 
						,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null,null
					FROM #T_VMI_temp_all
						WHERE yyyymmdd		>= @plan_start_yyyymmdd
						AND rtf_qty > 0 
						--and division_id in ('40','81')  -- 20190624 KHSONG [CSR_ID:4016234] -- 20200416 KHSONG C20200413-000593 주석처리 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨
					-- 20191104 KHSONG [CSR ID:4107133] VMI대상 RTF_SYS_RP MEASURE 생성로직 추가(END)

					-- [PJ2025-50017] RTF_PR 신규 추가 Start
					union all
					select division_id , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'RTF_PR' as measure ,plant_site_id, yyyymmdd
						,rtf_qty as QTY 
						,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null,null
					FROM #T_VMI_temp_all
						WHERE yyyymmdd		>= @plan_start_yyyymmdd
						AND rtf_qty > 0 
					-- [PJ2025-50017] RTF_PR 신규 추가 End

					union all

					select division_id , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'VMI_Inv' as measure ,plant_site_id, yyyymmdd
						--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
						,INV as QTY 
						,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null,null
					from  #T_VMI_temp_all
						WHERE yyyymmdd		>= @plan_start_yyyymmdd
						AND inv > 0 
								
					union all --[C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용
							
					select division_id , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'RTF' as measure ,plant_site_id, yyyymmdd
						--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
						,rtf_qty as QTY 
						,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null,null
					FROM #T_VMI_temp_all
						WHERE yyyymmdd		>= @plan_start_yyyymmdd
						AND rtf_qty > 0 
						AND   division_id = '82'
					---------------------------------- 계산된 VMI_Inv값 INSERT (END)
						
 PRINT ( @v_program_name + ' A016: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	
							

					--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start		
							
					INSERT INTO DBO.DM_PLN_CFM_MKT_DEMAND_PLAN 
								( DIVISION_ID
								,PROJECT_CODE
								,END_CUSTOMER
								,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS,MEASURE,PLANT_SITE_ID		
								,CELL_PROD_SITE_ID							-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
								,ATTRIBUTE2									-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
								,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE
								)
					SELECT DIVISION_ID
						,PROJECT_CODE
						,CASE WHEN DIVISION_ID='40'	THEN PROJECT_CODE	ELSE ''				END				AS END_CUSTOMER
						, SCM_SITE_ID,ITEM_ID, DOM_EXP,FCST_TYPE, INCOTERMS, 'RTF_SCP' AS MEASURE ,PLANT_SITE_ID
						, ISNULL(CELL_PROD_SITE_ID,'-')			AS CELL_PROD_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
						, FROM_SITE_ID							AS ATTRIBUTE2					-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
						, YYYYMMDD 
						,RTF_QTY AS QTY 
						,'SYSTEM',GETDATE(),'SYSTEM',GETDATE()
					FROM  #T_VMI_TEMP_ALL A WITH(NOLOCK)
					WHERE YYYYMMDD		>= @PLAN_START_YYYYMMDD
					AND RTF_QTY > 0 
					UNION ALL
					SELECT DIVISION_ID 
						,PROJECT_CODE
						,CASE WHEN DIVISION_ID='40'	THEN PROJECT_CODE	ELSE ''				END				AS END_CUSTOMER
						, SCM_SITE_ID,ITEM_ID, DOM_EXP,FCST_TYPE, INCOTERMS, 'RTF_SYS_RP' AS MEASURE ,PLANT_SITE_ID
						, ISNULL(CELL_PROD_SITE_ID,'-')			AS CELL_PROD_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
						, FROM_SITE_ID							AS ATTRIBUTE2					-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
						, YYYYMMDD
						,RTF_QTY AS QTY 
						,'SYSTEM',GETDATE(),'SYSTEM',GETDATE()
					FROM #T_VMI_TEMP_ALL	WITH(NOLOCK)
					WHERE YYYYMMDD		>= @PLAN_START_YYYYMMDD
					AND RTF_QTY > 0 
					-- [PJ2025-50017] RTF_PR 신규 추가 Start
					UNION ALL
					SELECT DIVISION_ID 
						,PROJECT_CODE
						,CASE WHEN DIVISION_ID='40'	THEN PROJECT_CODE	ELSE ''				END				AS END_CUSTOMER
						, SCM_SITE_ID,ITEM_ID, DOM_EXP,FCST_TYPE, INCOTERMS, 'RTF_PR' AS MEASURE ,PLANT_SITE_ID
						, ISNULL(CELL_PROD_SITE_ID,'-')			AS CELL_PROD_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
						, FROM_SITE_ID							AS ATTRIBUTE2					-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
						, YYYYMMDD
						,RTF_QTY AS QTY 
						,'SYSTEM',GETDATE(),'SYSTEM',GETDATE()
					FROM #T_VMI_TEMP_ALL	WITH(NOLOCK)
					WHERE YYYYMMDD		>= @PLAN_START_YYYYMMDD
					AND RTF_QTY > 0 
					-- [PJ2025-50017] RTF_PR 신규 추가 End

					UNION ALL
					SELECT DIVISION_ID 
						,PROJECT_CODE
						,CASE WHEN DIVISION_ID='40'	THEN PROJECT_CODE	ELSE ''				END				AS END_CUSTOMER
						, SCM_SITE_ID,ITEM_ID, DOM_EXP,FCST_TYPE, INCOTERMS, 'VMI_Inv' AS MEASURE ,PLANT_SITE_ID
						, '-' 									AS CELL_PROD_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
						, '-'									AS ATTRIBUTE2					-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
						, YYYYMMDD
						,INV AS QTY 
						,'SYSTEM',GETDATE(),'SYSTEM',GETDATE()
					FROM  #T_VMI_TEMP_ALL	WITH(NOLOCK)
					WHERE YYYYMMDD		>= @PLAN_START_YYYYMMDD
					AND INV > 0 
							
					--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End	

				
					
					END
					---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
					--                                                                                                                                      VMI재고 확인후 RTF 생성 로직 (END)
					---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		
		
					---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
					--                                                                                                                                      AS 재고 처리 (START )
					---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
					BEGIN
 PRINT ( @v_program_name + ' A017: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	

						-- RTF 프로시저를 호출하는 구조로 변경되어서 Inv 만드는 로직은 주석처리함.[PJ20209643] W/S 프로세스 
						EXEC PR_DM_DNM_CREATE_WS_RTF @P_DIVISION_ID


				
					END

		
					
						
					---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
					--                                                                                                                                      AS 재고 처리 (END )
					---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

					---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
					--                                                                                                                                                  VMI DIO 계산로직 (START)
					---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
					BEGIN

					--PRINT 'DM_PLN_MKT_FCST VMI_DIO DELETE START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
					----------------------------------------------------------|
						IF (@p_division_id = '40')
						BEGIN

							-- 수행전 삭제
							DELETE 
							FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
								where MEASURE = 'VMI_DIO'
									and exists (
											SELECT division_id 
												FROM #T_results
												where 1=1
												and DM_PLN_CFM_MKT_DEMAND_PLAN.division_id        =   division_id      
												AND DM_PLN_CFM_MKT_DEMAND_PLAN.project_code       =   project_code   
												AND DM_PLN_CFM_MKT_DEMAND_PLAN.scm_site_id        =   scm_site_id  
												AND DM_PLN_CFM_MKT_DEMAND_PLAN.item_id            =   item_id      
												AND DM_PLN_CFM_MKT_DEMAND_PLAN.dom_exp            =   dom_exp      
												AND DM_PLN_CFM_MKT_DEMAND_PLAN.fcst_type          =   fcst_type    
												AND DM_PLN_CFM_MKT_DEMAND_PLAN.incoterms          =   incoterms    
												AND DM_PLN_CFM_MKT_DEMAND_PLAN.plant_site_id      =   plant_site_id
												AND DM_PLN_CFM_MKT_DEMAND_PLAN.CELL_PROD_SITE_ID  =   CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
												AND DM_PLN_CFM_MKT_DEMAND_PLAN.ATTRIBUTE2		  =   FROM_SITE_ID
												AND vmi_yn = 'Y'
												AND DM_PLN_CFM_MKT_DEMAND_PLAN.yyyymmdd           >=   @plan_start_yyyymmdd  -- 당주월요일
												)

							-- VMI_DIO INSERT
							insert into dbo.DM_PLN_CFM_MKT_DEMAND_PLAN															-- [PJ2025-50017] 40사업부 기준테이블
							( DIVISION_ID,PROJECT_CODE,END_CUSTOMER,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS,MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
								,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
								,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							)
							select a.DIVISION_ID
									,a.PROJECT_CODE
									,a.PROJECT_CODE			AS END_CUSTOMER
									,a.SCM_SITE_ID
									,a.ITEM_ID
									,a.DOM_EXP
									,a.FCST_TYPE
									,a.INCOTERMS
									,'VMI_DIO' AS MEASURE
									,a.PLANT_SITE_ID
									,a.CELL_PROD_SITE_ID			-- [PJ2025-50017] 추가
									,a.YYYYMMDD
									--,QTY
									,ISNULL( datediff( day, cast( a.yyyymmdd as datetime) , cast ( (
									select min(yyyymmdd)
										from 
											(
												select yyyymmdd, SUM(QTY) over ( partition by a.division_id order by yyyymmdd) accum_sum
												from DM_PLN_CFM_MKT_DEMAND_PLAN b with(nolock)
												where a.division_id = b.division_id
												and a.project_code = b.project_code
												and a.END_CUSTOMER = b.END_CUSTOMER
												and a.scm_site_id  = b.scm_site_id
												and a.item_id      = b.item_id
												and a.dom_exp      = b.dom_exp
												and a.fcst_type    = b.FCST_TYPE
												and a.incoterms    = b.incoterms
												and a.PLANT_SITE_ID = b.plant_site_id
												and a.CELL_PROD_SITE_ID = b.CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
												and b.measure = 'RTF'
												and b.yyyymmdd > a.[YYYYMMDD]
											) zz
										where accum_sum >= a.qty
									) as datetime )  ) , 999 ) QTY
								,CREATED_BY
								,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
								,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
								from DM_PLN_CFM_MKT_DEMAND_PLAN a with(nolock)
								inner join #T_results s
								on (              A.division_id        =   s.division_id      
											AND A.project_code       =   s.project_code   
											AND A.scm_site_id        =   s.scm_site_id  
											AND A.item_id            =   s.item_id      
											AND A.dom_exp            =   s.dom_exp      
											AND A.fcst_type          =   s.fcst_type    
											AND A.incoterms          =   s.incoterms    
											AND A.plant_site_id      =   s.plant_site_id
											AND A.CELL_PROD_SITE_ID  =   s.CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
											AND A.ATTRIBUTE2		 =   S.FROM_SITE_ID
											AND s.vmi_yn = 'Y'
											AND A.yyyymmdd           >=   @plan_start_yyyymmdd  -- 당주월요일)
											)
								where a.division_id = @c_division_id
								and a.measure = 'VMI_Inv'
								and a.qty > 0 

						END
						ELSE
						BEGIN

							-- 수행전 삭제
							DELETE 
							FROM dbo.DM_PLN_MKT_FCST
								where MEASURE = 'VMI_DIO'
									and exists (
											SELECT division_id 
												FROM #T_results
												where 1=1
												and DM_PLN_MKT_FCST.division_id        =   division_id      
												AND DM_PLN_MKT_FCST.project_code       =   project_code   
												AND DM_PLN_MKT_FCST.scm_site_id        =   scm_site_id  
												AND DM_PLN_MKT_FCST.item_id            =   item_id      
												AND DM_PLN_MKT_FCST.dom_exp            =   dom_exp      
												AND DM_PLN_MKT_FCST.fcst_type          =   fcst_type    
												AND DM_PLN_MKT_FCST.incoterms          =   incoterms    
												AND DM_PLN_MKT_FCST.plant_site_id      =   plant_site_id
												AND vmi_yn = 'Y'
												AND DM_PLN_MKT_FCST.yyyymmdd           >=   @plan_start_yyyymmdd  -- 당주월요일
												)

							-- VMI_DIO INSERT
							insert into dbo.DM_PLN_MKT_FCST																-- [PJ2025-50017] 40 사업부 외의 기준테이블
							( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
								,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							)
							select a.DIVISION_ID
									,a.PROJECT_CODE
									,a.SCM_SITE_ID
									,a.ITEM_ID
									,a.DOM_EXP
									,a.FCST_TYPE
									,a.INCOTERMS
									,'VMI_DIO' AS MEASURE
									,a.PLANT_SITE_ID
									,a.YYYYMMDD
									--,QTY
									,ISNULL( datediff( day, cast( a.yyyymmdd as datetime) , cast ( (
									select min(yyyymmdd)
										from 
											(
												select yyyymmdd, SUM(QTY) over ( partition by a.division_id order by yyyymmdd) accum_sum
												from DM_PLN_MKT_FCST b with(nolock)
												where a.division_id = b.division_id
												and a.project_code = b.project_code
												and a.scm_site_id  = b.scm_site_id
												and a.item_id      = b.item_id
												and a.dom_exp      = b.dom_exp
												and a.fcst_type    = b.FCST_TYPE
												and a.incoterms    = b.incoterms
												and a.PLANT_SITE_ID = b.plant_site_id
												and b.measure = 'RTF'
												and b.yyyymmdd > a.[YYYYMMDD]
											) zz
										where accum_sum >= a.qty
									) as datetime )  ) , 999 ) QTY
								,CREATED_BY
								,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
								,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
								from DM_PLN_MKT_FCST a with(nolock)
								inner join #T_results s
								on (              A.division_id        =   s.division_id      
											AND A.project_code       =   s.project_code   
											AND A.scm_site_id        =   s.scm_site_id  
											AND A.item_id            =   s.item_id      
											AND A.dom_exp            =   s.dom_exp      
											AND A.fcst_type          =   s.fcst_type    
											AND A.incoterms          =   s.incoterms    
											AND A.plant_site_id      =   s.plant_site_id
											AND s.vmi_yn = 'Y'
											AND A.yyyymmdd           >=   @plan_start_yyyymmdd  -- 당주월요일)
											)
								where a.division_id = @c_division_id
								and a.measure = 'VMI_Inv'
								and a.qty > 0 

						END



					END
					---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
					--                                                                                                                                                  VMI DIO 계산로직 (END)
					---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
						


				END
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                                                                                            RTF, VMI DIO 관련 작업 (END)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                                                                                       MKT_FCST_QTY_BALANCE_CREATE (START)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				BEGIN

					--PRINT N'BALANCE #T_MST INSERT                           =>' + CONVERT(VARCHAR(8), GETDATE(), 108)


						-- [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN / DM_PLN_MKT_FCST 의 RTF가 업데이트 되었기 때문에 모든 데이터를 지우고 재 생성
						-- [PJ2025-50188] 임시테이블 #T_MKT_FCST ==> #T_MF_BALANCE_MKT_FCST 변경
						DELETE #T_MF_BALANCE_MKT_FCST		
						WHERE DIVISION_ID	= @p_division_id
						;

						IF (@p_division_id = '40')
						BEGIN
							INSERT INTO #T_MF_BALANCE_MKT_FCST		-- [PJ2025-50188] 임시테이블 #T_MKT_FCST ==> #T_MF_BALANCE_MKT_FCST 변경
							( 
									DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
								  , CELL_PROD_SITE_ID								-- [PJ2025-50188]추가
								  , FROM_SITE_ID									-- [PJ2025-50188]추가
								  , MEASURE, YYYYMMDD, QTY				
							)
							SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
								  , CELL_PROD_SITE_ID								-- [PJ2025-50188]추가
								  , ATTRIBUTE2			AS FROM_SITE_ID				-- [PJ2025-50188]추가
								  , MEASURE, YYYYMMDD, QTY
							FROM DM_PLN_CFM_MKT_DEMAND_PLAN
							WHERE DIVISION_ID	= @p_division_id
							AND   YYYYMMDD		>= @plan_start_yyyymmdd
							AND MEASURE IN ('MKT_FCST','SCM_FCST','VMI_In_Req','AS_In_Req', 'BALANCE', 'RTF_SYS_RP', 'RTF_SCP', 'RTF', 'VMI_Inv')		-- 해당 MEASURE로 국한하지 않으면, MKT_AMT_KRW로 인해 OVERFLOW 발생 가능함.
							;
						END
						ELSE
						BEGIN
							INSERT INTO #T_MF_BALANCE_MKT_FCST		-- [PJ2025-50188] 임시테이블 #T_MKT_FCST ==> #T_MF_BALANCE_MKT_FCST 변경
							( 
									DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
								  , CELL_PROD_SITE_ID								-- [PJ2025-50188]추가
								  , FROM_SITE_ID									-- [PJ2025-50188]추가
								  , MEASURE, YYYYMMDD, QTY				
							)
							SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
								  , '-'					AS CELL_PROD_SITE_ID		-- [PJ2025-50188]추가
								  , '-'					AS FROM_SITE_ID				-- [PJ2025-50188]추가
								  , MEASURE, YYYYMMDD, QTY
							FROM DM_PLN_MKT_FCST
							WHERE DIVISION_ID	= @p_division_id
							AND   YYYYMMDD		>= @plan_start_yyyymmdd
							AND MEASURE IN ('MKT_FCST','SCM_FCST','VMI_In_Req','AS_In_Req', 'BALANCE', 'RTF_SYS_RP', 'RTF_SCP', 'RTF', 'VMI_Inv')		-- 해당 MEASURE로 국한하지 않으면, MKT_AMT_KRW로 인해 OVERFLOW 발생 가능함.
							;
						END


					INSERT INTO #T_MST
							(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID,MEASURE,YYYYMMDD,QTY, CELL_PROD_SITE_ID, FROM_SITE_ID)
					SELECT ZZ.division_id, ZZ.project_code, ZZ.scm_site_id, ZZ.item_id, ZZ.dom_exp, ZZ.fcst_type, ZZ.incoterms, ZZ.plant_site_id, ZZ.MEASURE, ZZ.YYYYMMDD, max(ISNULL(C.QTY,0))
							, ZZ.CELL_PROD_SITE_ID, '-' AS FROM_SITE_ID		-- [PJ2025-50188] CELL_PROD_SITE_ID, FROM_SITE_ID 추가
						FROM 
							(
							SELECT * from 
							(
							SELECT DISTINCT A.division_id, A.project_code, A.scm_site_id, A.item_id, A.dom_exp, A.fcst_type, A.incoterms, A.plant_site_id, A.CELL_PROD_SITE_ID, A.FROM_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID, FROM_SITE_ID 추가
								FROM #T_results A
							) TARGET_DATA
							,(
							SELECT 'MKT_FCST' MEASURE			
							UNION ALL
							SELECT 'RTF_SCP' MEASURE
							) MEASURE
							,		(
									SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
										FROM SCM_SYS_CALENDAR_M C WITH(NOLOCK)
										WHERE C.BASIS_YYYYMMDD between @plan_start_yyyymmdd AND CONVERT(CHAR(8), DATEADD(WW, @plan_week_cnt, @plan_start_yyyymmdd  ),112)  -- SCP PLANNING 구간이 52주
									) DS
							) ZZ
--							LEFT JOIN DM_PLN_MKT_FCST C WITH(NOLOCK)
							LEFT JOIN #T_MF_BALANCE_MKT_FCST C WITH(NOLOCK)					--  [PJ2025-50188] DM_PLN_MKT_FCST / DM_PLN_CFM_MKT_DEMAND_PLAN	-- [PJ2025-50188] 임시테이블 #T_MKT_FCST ==> #T_MF_BALANCE_MKT_FCST 변경
															ON		ZZ.division_id		= C.DIVISION_ID
															AND		ZZ.project_code		= C.PROJECT_CODE
															AND		ZZ.scm_site_id		= C.SCM_SITE_ID
															AND		ZZ.item_id			= C.ITEM_ID
															AND		ZZ.dom_exp			= C.DOM_EXP
															AND		ZZ.fcst_type		= C.FCST_TYPE
															AND		ZZ.incoterms		= C.INCOTERMS
															AND		ZZ.plant_site_id	= C.PLANT_SITE_ID
															AND     ZZ.MEASURE          = C.MEASURE
															AND     ZZ.YYYYMMDD         = C.YYYYMMDD
															AND     ZZ.CELL_PROD_SITE_ID	= C.CELL_PROD_SITE_ID		-- [PJ2025-50188] 추가

					group by ZZ.division_id, ZZ.project_code, ZZ.scm_site_id, ZZ.item_id, ZZ.dom_exp, ZZ.fcst_type, ZZ.incoterms, ZZ.plant_site_id, ZZ.MEASURE,ZZ.YYYYMMDD, ZZ.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가

				END
		
 PRINT ( @v_program_name + ' A018: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	

				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                                                                                 MKT_FCST, RTF 대상 날짜및 값 추출 (END)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

				INSERT into #T_MST_ACCUM
				(	  DIVISION_ID ,PROJECT_CODE ,SCM_SITE_ID ,ITEM_ID, DOM_EXP ,FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD
					, MEASURE, QTY
					, CELL_PROD_SITE_ID, FROM_SITE_ID   -- [PJ2025-50188] 추가 
					, ACCUM_SUM	
				)
				select    DIVISION_ID ,PROJECT_CODE ,SCM_SITE_ID ,ITEM_ID, DOM_EXP ,FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD
						, MEASURE, QTY
						, CELL_PROD_SITE_ID, FROM_SITE_ID   -- [PJ2025-50188] 추가 
						, SUM(QTY) over ( partition by division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id, measure, CELL_PROD_SITE_ID order by yyyymmdd) accum_sum		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				  from #T_MST

				INSERT into #T_TEMPX
				(	  DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID  
					, MEASURE, YYYYMMDD		
					, CELL_PROD_SITE_ID, FROM_SITE_ID							--[PJ2025-50188]  CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
					, ACCUM_X		
				)
				select division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id,  'BALANCE' measure, yyyymmdd
					,  CELL_PROD_SITE_ID, FROM_SITE_ID							--[PJ2025-50188]  CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
					,  SUM( CASE WHEN MEASURE = 'MKT_FCST' THEN 0 ELSE accum_sum END)  - SUM( CASE WHEN MEASURE = 'MKT_FCST' THEN accum_sum ELSE 0 END) AS ACCUM_X
				  from #T_MST_ACCUM
				group by division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id, yyyymmdd, CELL_PROD_SITE_ID, FROM_SITE_ID		--[PJ2025-50017]  CELL_PROD_SITE_ID,FROM_SITE_ID 추가 


				--PRINT N'BALANCE DM_PLN_MKT_FCST DELETE                  =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
				----------------------------------------------------------|
				---------------------------------- 초기화 (START)
				DELETE 
				FROM dbo.DM_PLN_MKT_FCST
					where MEASURE = 'BALANCE'
					and exists (
							SELECT division_id 
								FROM #T_TEMPX 
								where 1=1
								and DM_PLN_MKT_FCST.division_id        =   division_id      
								AND DM_PLN_MKT_FCST.project_code       =   project_code   
								AND DM_PLN_MKT_FCST.scm_site_id        =   scm_site_id  
								AND DM_PLN_MKT_FCST.item_id            =   item_id      
								AND DM_PLN_MKT_FCST.dom_exp            =   dom_exp      
								AND DM_PLN_MKT_FCST.fcst_type          =   fcst_type    
								AND DM_PLN_MKT_FCST.incoterms          =   incoterms    
								AND DM_PLN_MKT_FCST.plant_site_id      =   plant_site_id
								AND DM_PLN_MKT_FCST.yyyymmdd           >=  @plan_start_yyyymmdd
							) 
						;
				---------------------------------- 초기화 (END)
					

				--PRINT N'BALANCE DM_PLN_MKT_FCST insert                  =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
				----------------------------------------------------------|
				---------------------------------- 계산된 BALANCE값 INSERT (START)
				
 PRINT ( @v_program_name + ' A019: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	

				insert into DM_PLN_MKT_FCST
							( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
							,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
							,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
							,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							)
				select division_id , project_code, scm_site_id,item_id, dom_exp,fcst_type, incoterms,'BALANCE' measure ,plant_site_id, yyyymmdd
					, SUM(ACCUM_X) AS ACCUM_X		-- [PJ2025-50188] 40 사업부의 경우 CELL_PROD_SITE_ID 단위로 구분되어 있으므로 SUM으로 처리함. / 그 외 사업부는 1줄씩만 있으므로 SUM이든 아니든 상관없음
					,'BALANCE_MAKE',getdate(),'BALANCE_MAKE',getdate(), null,null,null,null,null,null,null,null,null,null
				from  #T_TEMPX
					WHERE yyyymmdd		>= @plan_start_yyyymmdd
						AND ACCUM_X BETWEEN -9999999999 AND 9999999999  -- 오버플로우 예방
						AND ACCUM_X <> 0                                -- ZERO 값은 불필요
				GROUP BY division_id , project_code, scm_site_id,item_id, dom_exp,fcst_type, incoterms, plant_site_id, yyyymmdd

				---------------------------------- 계산된 BALANCE값 INSERT (END)

				IF (@p_division_id = '40')
				BEGIN

					--PRINT N'BALANCE DM_PLN_MKT_FCST DELETE                  =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
					----------------------------------------------------------|
					---------------------------------- 초기화 (START)

					--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start
					DELETE 
					FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN 
						where MEASURE = 'BALANCE'
						and exists (
								SELECT division_id 
									FROM #T_TEMPX 
									where 1=1
									and DM_PLN_CFM_MKT_DEMAND_PLAN.division_id        =   division_id      
									AND CASE WHEN DM_PLN_CFM_MKT_DEMAND_PLAN.division_id = '40' then DM_PLN_CFM_MKT_DEMAND_PLAN.end_customer ELSE DM_PLN_CFM_MKT_DEMAND_PLAN.project_code END =   project_code   
									AND DM_PLN_CFM_MKT_DEMAND_PLAN.scm_site_id        =   scm_site_id  
									AND DM_PLN_CFM_MKT_DEMAND_PLAN.item_id            =   item_id      
									AND DM_PLN_CFM_MKT_DEMAND_PLAN.dom_exp            =   dom_exp      
									AND DM_PLN_CFM_MKT_DEMAND_PLAN.fcst_type          =   fcst_type    
									AND DM_PLN_CFM_MKT_DEMAND_PLAN.incoterms          =   incoterms    
									AND DM_PLN_CFM_MKT_DEMAND_PLAN.plant_site_id      =   plant_site_id
									AND DM_PLN_CFM_MKT_DEMAND_PLAN.yyyymmdd           >=  @plan_start_yyyymmdd
									AND DM_PLN_CFM_MKT_DEMAND_PLAN.CELL_PROD_SITE_ID  =   CELL_PROD_SITE_ID			--[PJ2025-50017]  CELL_PROD_SITE_ID 추가 
								) 
							;
					---------------------------------- 초기화 (END)

					--PRINT N'BALANCE DM_PLN_CFM_MKT_DEMAND_PLAN insert                  =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
					----------------------------------------------------------|
					---------------------------------- 계산된 BALANCE값 INSERT (START)
					insert into DM_PLN_CFM_MKT_DEMAND_PLAN
								( DIVISION_ID
								,PROJECT_CODE
								,END_CUSTOMER
								,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS,MEASURE,PLANT_SITE_ID
								,CELL_PROD_SITE_ID						--[PJ2025-50017] CELL_PROD_SITE_ID 추가
								,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
								,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
								)
					select division_id 
						, PROJECT_CODE
						, CASE WHEN DIVISION_ID='40'	THEN project_code	ELSE ''				END				AS END_CUSTOMER
						, SCM_site_id,item_id, dom_exp,fcst_type, incoterms,'BALANCE' measure ,plant_site_id
						, CELL_PROD_SITE_ID					--[PJ2025-50017] CELL_PROD_SITE_ID 추가
						, yyyymmdd, ACCUM_X
						,'BALANCE_MAKE',getdate(),'BALANCE_MAKE',getdate(), null,null,null,null,null,null,null,null,null,null
					from  #T_TEMPX
						WHERE yyyymmdd		>= @plan_start_yyyymmdd
							AND ACCUM_X BETWEEN -9999999999 AND 9999999999  -- 오버플로우 예방
							AND ACCUM_X <> 0                                -- ZERO 값은 불필요
					--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End

					---------------------------------- 계산된 BALANCE값 INSERT (END)

				END


				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                                                                                       MKT_FCST_QTY_BALANCE_CREATE (END)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		

				IF  @p_plan_id  <>  'CALL'  -- PROCEDURE에서 호출된 케이스가 아닌경우만 수행
				------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                                 SALES_PLAN_AMT_CREATE_LOCAL_KRW 호출 (START)
				------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				BEGIN
				
 PRINT ( @v_program_name + ' A020: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	

					--PRINT N'EXECUTE SALES_PLAN_AMT_CREATE_LOCAL_KRW         =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
					----------------------------------------------------------|
					EXEC	[dbo].[PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW]	
								@c_division_id
								, 'SYSTEM'
				END
				------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                                 SALES_PLAN_AMT_CREATE_LOCAL_KRW 호출 (END)
				------------------------------------------------------------------------------------------------------------------------◎◎◎◎


				IF  @p_plan_id  <>  'CALL' AND @batch_call_yn = 'N' -- UI에서 호촐된 대상만 CUFOFF 관련작업 수행함 (@batch_call_yn = 'Y' 이면 주1회 WEEKLY ROLLING 작업시 (SP:PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING) 호출된 케이스임)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                        SALES_PLAN_AMT_CREATE_LOCAL_KRW, MKT_FCST , Sales Plan CUTOFF QTY_BALANCE_CREATE 관련 작업 (START)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				BEGIN
						---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
						--                                                                                                                   MKT_FCST , Sales Plan CUTOFF QTY_BALANCE_CREATE (START)
						---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
						BEGIN

 PRINT ( @v_program_name + ' A021: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	

							--PRINT N'mkt_fcst  Cutoff VERSION_NO SELECT              =>' + CONVERT(VARCHAR(8), GETDATE(), 108)

							INSERT INTO #T_cutoff  -- 작업대상 cutoff version insert
							SELECT 	  VERSION_NO
							FROM  DM_MST_VERSION WITH(NOLOCK)	
							WHERE 1=1
							--[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청
							--EE로 들어오는 경우 40 사업부로 보기로 했는데, 40사업부 EE인경우 CUTOFF 반영요청으로 해당 부분 수정
							--and division_id			=  @c_scp_division_id --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(@c_division_id -> @c_scp_division_id) EE는 MKT Fcst Cutoff 업데이트 안함
							and division_id			=  @c_division_id --[C20200827-000094] 자동차 전극 RTF를 매출계획에 반영(@c_division_id -> @c_scp_division_id) EE는 MKT Fcst Cutoff 업데이트 안함
							and YYYYMMDD			>= @plan_start_yyyymmdd  -- 당주월요일부터
							and VERSION_TYPE		IN  ('MF_W', 'SF_W')		-- [PJ2025-50017] SF_W 추가에 따라 VERSION_TYPE 추가
							--and VERSION_TYPE = 'MF_D'  -- 임시
							ORDER BY VERSION_NO

							IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR2_CUTOFF')
								BEGIN
									CLOSE CURSOR2_CUTOFF
									DEALLOCATE CURSOR2_CUTOFF
								END;

							DECLARE CURSOR2_CUTOFF CURSOR FAST_FORWARD FOR
							SELECT  VERSION_NO
							  FROM  #T_cutoff	

							BEGIN
								OPEN CURSOR2_CUTOFF;
								FETCH NEXT FROM CURSOR2_CUTOFF  INTO  @c_VERSION_NO
							END
		
							------------------------------------------------------------------------------------------------------------------------◎◎◎◎
							--                                                                                     CURSOR2_CUTOFF VERSION_NO별 LOOP (START)
							------------------------------------------------------------------------------------------------------------------------◎◎◎◎
							WHILE @@FETCH_STATUS = 0
							----------------------------------------------------------------------------------------
							BEGIN

 PRINT ( @v_program_name + ' A022: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	
		

								--PRINT N'EXECUTE PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
								----------------------------------------------------------|
								------------------------------------------------------------------------------------------------------------------------◎◎◎◎
								--                                                       MKT_FCST , Sales Plan CUTOFF QTY_BALANCE_CREATE Procedure 호출 (START)
								------------------------------------------------------------------------------------------------------------------------◎◎◎◎

								-- 20200416 KHSONG C20200413-000593 ESS사업부 RTF Measure 추가되어 DIV구분없이 간소화됨
								-- [PJ20200138] [SCM PI팀] Sales Plan Waterfall cut-off 주기 변경 - SALES_PLAN_C 는 금요일에 한번 cutoff
								EXEC	[dbo].[PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE]	 -- 모든 사업부 대상 Cutoff 버전에 RTF_SCP MEASURE 작업 Procedure
												@c_division_id
											,@c_VERSION_NO


								/*-- 20200416 KHSONG C20200413-000593 주석처리 
								IF  @c_division_id IN ('40','81')  -- 20190624 KHSONG [CSR_ID:4016234]
								   -- AND CONVERT(VARCHAR(8), GETDATE(), 112) < '20181211'  -- 소형 RTF_SCP 사용하는 시점을 조건으로 추가 -> 20190110 KHSONG 주석처리
									BEGIN
										EXEC	[dbo].[PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE_40]	 -- 20181012 소형 RTF_SCP MEASURE 작업 전용 PROCEDURE
													 @c_division_id
													,@c_VERSION_NO
									END
								ELSE
									BEGIN
										EXEC	[dbo].[PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE]	 -- 20181011 KHSONG CUTOFF테이블작업 호출추가
													 @c_division_id
													,@c_VERSION_NO
									END
								*/
								------------------------------------------------------------------------------------------------------------------------◎◎◎◎
								--                                                       MKT_FCST , Sales Plan CUTOFF QTY_BALANCE_CREATE Procedure 호출 (END)
								------------------------------------------------------------------------------------------------------------------------◎◎◎◎

								FETCH NEXT FROM CURSOR2_CUTOFF INTO  @c_VERSION_NO

							END

							CLOSE CURSOR2_CUTOFF;  
							DEALLOCATE CURSOR2_CUTOFF;
							------------------------------------------------------------------------------------------------------------------------◎◎◎◎
							--                                                                                     CURSOR2_CUTOFF VERSION_NO별 LOOP (END)
							------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				
						END
						---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
						--                                                                                                                   MKT_FCST , Sales Plan CUTOFF QTY_BALANCE_CREATE (END)
						---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

					--[E20250210-000219]_SCP 엔진 재수행에 따른 Sales Plan Cutoff 재수행 자동화 START
					--1. CALL된 형태가 SCP에서 CALL한 건인지 확인한다. SCP에서 CALL하는 경우 PLAN_ID를 주기 때문에, 해당 건으로 판단
					IF (@p_plan_id <> 'CALL' AND ISNULL(@p_plan_id, '') <> '')		
					BEGIN
 PRINT ( 'CHECK--00--00 : ' + @p_plan_id + '/' + @c_division_id)		
						--2. SALES PLAN CUTOFF가 한번이라도 진행 된 이후부터 RTF 반영된 건을 CUTOFF 하기위해, SALE PLAN CUTOFF 유무 확인
						IF (SELECT COUNT(*)
							FROM  DM_MST_VERSION WITH(NOLOCK)	
							WHERE DIVISION_ID =  @c_division_id 
							AND YYYYMMDD	  >= @plan_start_yyyymmdd  -- 당주월요일부터
							AND VERSION_TYPE  = 'SP_W') > 0
						BEGIN			
 PRINT ( 'CHECK2--00--00 : ' + @p_plan_id + '/' + @c_division_id)				
						--3. [E20250307-001264]_40사업부 Sales Plan Cutoff 수행 조건 변경  START
						--SCP에서 01:30시 Semi Plan, 14:00시 FN이 정기 프로세스로 수행됨에 따라 Sales Plan Cutoff가 재수행으로 인식되지 않도록 하기 위함
							IF (	SELECT COUNT(*)
									FROM SCM_MST_DIVISION A WITH (NOLOCK)
									WHERE A.ATTRIBUTE3 IN ('40','81','82')
									AND A.DIVISION_ID NOT IN (SELECT SEGMENT1 AS DIVISION_ID
															 FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK)
															 WHERE LOOKUP_TYPE = N'CUTOFF_EXCLUDE_TIME_DIVISION'
															 AND SEGMENT1 = @c_division_id
															 AND SEGMENT2 IN (SELECT DAYOFWEEK AS DAYOFWEEKS FROM [dbo].[SCM_SYS_CALENDAR_M] WITH (NOLOCK)
																			  WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8), GETDATE(), 112)
															 AND SUBSTRING(CONVERT(CHAR(8), GETDATE(), 8), 0, 3) + SUBSTRING(CONVERT(CHAR(8), GETDATE(), 8), 4,2) BETWEEN SEGMENT3 AND SEGMENT4)
															 AND VALID_YN = 'Y')
									AND A.DIVISION_ID = @c_division_id) > 0
						--[E20250307-001264]_40사업부 Sales Plan Cutoff 수행 조건 변경  END
							BEGIN
 PRINT ( 'CHECK3--00--00 : ' + @p_plan_id + '/' + @c_division_id)			
								--[E20250418-001548]_DM_PLN_SALES_PLAN_C 테이블 Cell Prod Site 칼럼추가 / DM_PLN_MKT_FCST_C -> DM_PLN_CFM_MKT_DEMAND_PLAN_로 변경
								--4. RTF 기준으로 변경이 있는 경우에만 SALES PLAN CUTOFF를 진행한다.
								--[E20250321-001569]_Sales Plan Cutoff 자동 재수행 로직 개선 START
								SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
									 , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY			--[PJ2025-50017] CELL_PROD_SITE_ID 추가
								INTO #TEMP_DM_PLN_SALES_PLAN_C
								FROM DM_PLN_SALES_PLAN_C WITH (NOLOCK)
								WHERE DIVISION_ID = @c_division_id
								AND VERSION_NO = (SELECT MAX(VERSION_NO) FROM DM_MST_VERSION WHERE VERSION_TYPE = 'SP_W' AND DIVISION_ID = @c_division_id )
								AND MEASURE = 'RTF_SYS_RP'
								AND YYYYMMDD >= @plan_start_yyyymmdd

								SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
									 , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY			--[PJ2025-50017] CELL_PROD_SITE_ID 추가
								INTO #TEMP_DM_PLN_MKT_FCST_C
								--[E20250418-001548]_DM_PLN_MKT_FCST_C -> DM_PLN_CFM_MKT_DEMAND_PLAN_로 변경
								--FROM DM_PLN_MKT_FCST_C WITH (NOLOCK)
								FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C WITH (NOLOCK)
								WHERE DIVISION_ID =  @c_division_id
								AND VERSION_NO = (SELECT MAX(VERSION_NO) FROM DM_MST_VERSION WHERE VERSION_TYPE = 'MF_W' AND DIVISION_ID = @c_division_id )
								AND MEASURE = 'RTF_SYS_RP'
								AND YYYYMMDD >= @plan_start_yyyymmdd
								--[E20250321-001569]_Sales Plan Cutoff 자동 재수행 로직 개선 END

								IF (	SELECT COUNT(*)
										FROM 
										(
											SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
												 , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY		--[PJ2025-50017] CELL_PROD_SITE_ID 추가
											FROM #TEMP_DM_PLN_SALES_PLAN_C
										) A
										FULL OUTER JOIN 
														(
															SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
																 , INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CELL_PROD_SITE_ID, QTY	--[PJ2025-50017] CELL_PROD_SITE_ID 추가
															FROM #TEMP_DM_PLN_MKT_FCST_C
														) B
													 ON A.DIVISION_ID = B.DIVISION_ID
													AND A.PROJECT_CODE = B.PROJECT_CODE
													AND A.SCM_SITE_ID = B.SCM_SITE_ID
													AND A.ITEM_ID = B.ITEM_ID
													AND A.DOM_EXP = B.DOM_EXP
													AND A.FCST_TYPE = B.FCST_TYPE
													AND A.INCOTERMS = B.INCOTERMS
													AND A.MEASURE = B.MEASURE
													AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
													AND A.YYYYMMDD = B.YYYYMMDD
													AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID			--[PJ2025-50017] CELL_PROD_SITE_ID 추가
										--WHERE A.QTY <> B.QTY ) > 0		--[E20250529-001353]_Sales Plan Cutoff 자동 재수행 로직 개선 원소스 주석처리												
										WHERE ((A.QTY <> B.QTY) OR (ISNULL(A.DIVISION_ID, '') = '') OR (ISNULL(B.DIVISION_ID, '') = ''))) > 0	--[E20250529-001353]_MKT FCST CUTOFF 데이터와 SALES PLAN CUTOFF 데이터 간의 서로 존재하지 않는 경우가 발생한 경우에도 SALES PLAN CUTOFF 재수행 로직 보완		
								BEGIN 
PRINT ( 'CHECK4--00--00 : ' + @p_plan_id + '/' + @c_division_id )				
									--5. SALES PLAN CUTOFF를 실행한다. 
									--[E20250529-001289]_해당부분으로 실행되는 경우에는 비정기적인 부분이므로, 재수행 메일링이 가야함으로 CRAETION_TYPE을 추가해준다
									EXEC [dbo].[PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE] @c_division_id, @p_cutoff_yyyymmdd = '', @p_creation_type = 'IRREGULAR'
									--6. SALES PLAN 일정대로 CUTOFF 하지 않은 경우에는 메일을 발송한다.
									--[E20250529-001289]_SALES PLAN 정기실행인 경우에도 메일 발송을 요청하여 PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE 프로시져 안에 추가하여 따로 수행할 필요 없으므로 주석처리
									--EXEC [dbo].[PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND] @c_division_id
								END
							END
						END
					END
					--[E20250210-000219]_SCP 엔진 재수행에 따른 Sales Plan Cutoff 재수행 자동화 END		
				END
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
				--                                                                        SALES_PLAN_AMT_CREATE_LOCAL_KRW, MKT_FCST , Sales Plan CUTOFF QTY_BALANCE_CREATE 관련 작업 (END)
				---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

			--[PJ2025-50017] 소형 매출계획 동기화 개선 START - DEMAND가 있으나 SCP에서 RTF가 생성되지 않는 건 강제로 0으로 생성함

			
 PRINT ( @v_program_name + ' A023: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	


				INSERT INTO DM_PLN_SALES_PLAN
				(
					  DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					, MEASURE
					, PLANT_SITE_ID
					, CELL_PROD_SITE_ID					--[PJ2025-50017] CELL_PROD_SITE_ID 추가
					, YYYYMMDD
					, CURRENCY
					, QTY
					, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
				)
				SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
							  , 'RTF_SYS_RP'		AS MEASURE
							  , A.PLANT_SITE_ID
							  , A.CELL_PROD_SITE_ID		--[PJ2025-50017] CELL_PROD_SITE_ID 추가
							  , B.YYYYMMDD
							  , B.CURRENCY
							  , 0					AS QTY
							  ,'SYSTEM'				AS CREATED_BY
							  ,GETDATE()			AS CREATION_DATE
							  ,'SYSTEM'				AS LAST_UPDATED_BY
							  ,GETDATE()			AS LAST_UPDATE_DATE
				FROM 
				(
					SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID		--[PJ2025-50017] CELL_PROD_SITE_ID 추가
					FROM 
					(
						SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID	--[PJ2025-50017] CELL_PROD_SITE_ID 추가
						FROM 
						(
							SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID				--[PJ2025-50017] CELL_PROD_SITE_ID 추가
							FROM DM_PLN_NET_DEMAND	WITH(NOLOCK)
							WHERE DIVISION_ID = @c_division_id
							AND   VERSION_NO IN (
													SELECT   MAX(VERSION_NO)
													FROM dbo.DM_MST_VERSION WITH(NOLOCK)
													WHERE 1=1
														AND VERSION_TYPE IN (CASE WHEN @c_division_id = '40' THEN 'SF_W' ELSE 'MF_W' END)		
														AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7*1, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)    -- 당주 월요일부터
														AND YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, 0, dbo.FN_NEXT_DAY(getdate(), 'SUN')), 112)       -- 당주 일요일까지
														AND DIVISION_ID		 = @c_division_id
												) 
						) A
						LEFT OUTER JOIN 
						(
							SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID				--[PJ2025-50017] CELL_PROD_SITE_ID 추가
							FROM DM_PLN_SALES_PLAN	WITH(NOLOCK)
							WHERE DIVISION_ID = @c_division_id
							AND   YYYYMMDD >= @c_plan_start_yyyymmdd
							AND   MEASURE = 'RTF_SYS_RP'
						) B
						ON  A.DIVISION_ID	= B.DIVISION_ID
						AND A.PROJECT_CODE	= B.PROJECT_CODE
						AND A.SCM_SITE_ID	= B.SCM_SITE_ID
						AND A.ITEM_ID		= B.ITEM_ID
						AND A.DOM_EXP		= B.DOM_EXP
						AND A.FCST_TYPE		= B.FCST_TYPE
						AND A.INCOTERMS		= B.INCOTERMS
						AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
						AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID		--[PJ2025-50017] CELL_PROD_SITE_ID 추가
						WHERE B.DIVISION_ID IS NULL
					) A
					LEFT OUTER JOIN 
					(
						SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SALES_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID		--[PJ2025-50017] CELL_PROD_SITE_ID 추가
						--FROM #T_SCP_PLN_RTF_ALLOCATION_V B WITH(NOLOCK)
						-- [PJ2025-50188] 임시테이블 #T_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_RTF_ALLOCATION 이름변경
						FROM #T_MF_RTF_ALLOCATION B WITH(NOLOCK)
						WHERE DIVISION_ID		= @c_scp_division_id 
						AND ORIGIN_DIVISION_ID	= @c_division_id 
						AND PLAN_ID				= @c_plan_id
						AND YYYYMMDD			>= @c_plan_start_yyyymmdd
						AND ALLOCATION_QTY		!= 0
					) B
					ON  A.DIVISION_ID	= B.DIVISION_ID
					AND A.PROJECT_CODE	= B.PROJECT_CODE
					AND A.SCM_SITE_ID	= B.SALES_SITE_ID
					AND A.ITEM_ID		= B.ITEM_ID
					AND A.DOM_EXP		= B.DOM_EXP
					AND A.FCST_TYPE		= B.FCST_TYPE
					AND A.INCOTERMS		= B.INCOTERMS
					AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
					AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID		--[PJ2025-50017] CELL_PROD_SITE_ID 추가
					WHERE B.DIVISION_ID IS NULL
				) A
				INNER JOIN (
							SELECT DISTINCT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, CURRENCY, YYYYMMDD		--[PJ2025-50017] CELL_PROD_SITE_ID 추가
							FROM DM_PLN_CFM_SELLING_PRICE	WITH(NOLOCK)
							WHERE DIVISION_ID	= @c_scp_division_id
							AND   YYYYMMDD		= @c_plan_start_yyyymmdd
							AND   MEASURE		= 'LOC'
				) B
				ON  A.DIVISION_ID	= B.DIVISION_ID
				AND A.PROJECT_CODE	= B.PROJECT_CODE
				AND A.PROJECT_CODE	= B.END_CUSTOMER
				AND A.SCM_SITE_ID	= B.SCM_SITE_ID
				AND A.ITEM_ID		= B.ITEM_ID
				AND A.DOM_EXP		= B.DOM_EXP
				AND A.FCST_TYPE		= B.FCST_TYPE
				AND A.INCOTERMS		= B.INCOTERMS
				AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
				AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID		--[PJ2025-50017] CELL_PROD_SITE_ID 추가

			--[PJ2025-50017] 소형 매출계획 동기화 개선 End
 PRINT ( @v_program_name + ' A024: ' + 'DIVISION_ID: '+ @p_division_id + 'PLAN_ID: '+ @p_plan_id )	


			END
			
			BEGIN	
			-- [PJ2025-50188] 임시테이블 #T_MKT_FCST DROP 추가
			-- [PJ2025-50188] 임시테이블 #T_MKT_FCST ==> #T_MF_BALANCE_MKT_FCST 변경
				IF OBJECT_ID (N'tempdb..#T_MF_BALANCE_MKT_FCST', N'U') IS NOT NULL 
					DROP TABLE #T_MF_BALANCE_MKT_FCST
			-- [PJ2025-50188] 임시테이블 #T_SCP_PLN_RTF_ALLOCATION_V DROP
				--IF OBJECT_ID (N'tempdb..#T_SCP_PLN_RTF_ALLOCATION_V', N'U') IS NOT NULL 
				--	DROP TABLE #T_SCP_PLN_RTF_ALLOCATION_V
				-- [PJ2025-50188] 임시테이블 #T_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_RTF_ALLOCATION 이름변경
				IF OBJECT_ID (N'tempdb..#T_MF_RTF_ALLOCATION', N'U') IS NOT NULL 
					DROP TABLE #T_MF_RTF_ALLOCATION

			END
		
			-- 2020.3.3
			--[C20200827-000351] SSP Shipment Req 프로시저 호출 제외
			/*
			IF ISNUMERIC(@p_plan_id) > 0
			BEGIN
				EXEC DMF0045_SCPSHIPPLAN_TO_SHIPREQ @P_DIVISION_ID, @p_plan_id
			END */
  	-- 트랜잭션 (COMMIT)
        --COMMIT WORK;
	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	--ROLLBACK TRANSACTION MKT_FCST_QTY_BALANCE_CREATE;

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[[[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '@p_division_id : ' + ISNULL(@p_division_id,'NULL') + ' / ' + '@p_plan_id : ' + ISNULL(@p_plan_id,'NULL');
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	ERR_RTN:
	IF @v_log_type = 'INVALID'
		begin
			--ROLLBACK TRANSACTION MKT_FCST_QTY_BALANCE_CREATE
			SET @v_log_message = '########## INVALID of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		end
  END;
