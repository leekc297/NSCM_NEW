
/*=====================================================================================================================================================
 * Program ID   : PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE
 * Description  : MKT FCST CUTOFF 프로시져 화요일 CUTOFF
 * Program History
 *=====================================================================================================================================================
 *	  Date		In Charge		Description
 *=====================================================================================================================================================
 * 2018.10.10	KHSONG		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * -----------------------------------------------------------------------------------------------------------
 * PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 에서 호출되는 Procedure로 Cufoff 테이블 관련처리를 수행함
 * -----------------------------------------------------------------------------------------------------------
 * 2019.06.24	KHSONG		[CSR_ID:4016234]자동차전지 사업부 RTF(Manual 입력) 메져 추가건 적용 
 *                 			-> @p_division_id 으로 RTF_SCP 수행되므로 특별히 수정할부분은 없음
 * 2019.07.09	KHSONG 		[CSR ID:4027463] RTF_System[R+P] Measure 추가 요청의 건
 * 2019.07.09	KHSONG 		[CSR ID:4034895] 상품 매출에 대한 마케팅의 RTF[R+P] 수정 권한 요청 및 MKT FCST 기본값 삭제 요청 (자동차사업부)
 * 2019.08.09	KHSONG 		[CSR ID:4059971] VMI-In Request 로직 변경
 * 2019.09.03	KHSONG 		[CSR ID:4066366] Sales Plan Waterfall 화면 메져값 수정
 * 2019.10.16	KHSONG 		'RTF_SCP'Measure로 Sales Amt를 계산하던 오류를 'RTF'Measure로 수정함
 * 2019.10.28	KHSONG 		Cutoff Version 'RTF' Measure 삭제 오류로직 수정
 * 2019.11.04	KHSONG 		[CSR ID:4107133] VMI대상 RTF_SYS_RP MEASURE 생성로직 추가
 * 2020.02.13	HWI1993 	자동차 사업부의 경우 'RTF_SCP'Measure로 Sales Amt를 계산하도록 수정
 * 2020.04.16	KHSONG 		C20200413-000593 ESS사업부 RTF Measure 추가 (scp plan 수행시 모든사업부가 이 Procedure 로 호출됨)
 * 2020.05.07	KHSONG 		C20200507-000035 (소형사업부 RTF 관련 Measure 숨기기)
 * 2020.06.15	hwi1993 	C20200518-000359 GSCM RMA값 표기 로직 수정 요청의 건
 * 2020.07.01	P.C.I   	[PJ20200138] Sales Plan Waterfall cut-off 주기 변경 - MKT_FCST_C/SALES_PLAN_C 분리
                    		PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE_40 -> PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE 명칭 변경
 * 2020.09.09	P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2020.11.13	hwi1993		[C20201103-000114] [SCM PI팀] ESS 사업부 판매 법인 VMI biz의 MKT FCST 입력 시 VMI in req 자동산출 로직 적용의 건 
 * 2020.12.08	P.C.I		[C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용
 * 2020.12.23	hwi1993		[C20201222-000376] VMI Inv 메저 수량 표시
 * 2021.03.29	hwi1993		[C20210323-000456] ESS 판매법인 VMI LT 반영
 * 2021.05.11	P.C.I		[C20210511-000221] 자동차 전극 RTF 적용
 * 2021.07.08	SJHAN		[C20210705-000574] Google 반품(RMA) Sales Amount 조회 기능 요청
 * 2021.08.23	hwi1993		[중장기] 52주를 82주로 변경
 * 2021.11.09	HWI1993		[과제]W/S, CUTOFF 버전에 AS RTF 를 업데이트 하도록 프로시저 호출 추가
 * 2022.03.29   kdw2819     [C20220224-000448] ESS 사업부 VMI 기능 자동차사업부 확산 전개 요청 (VMI_IN_PLAN 으로 RTF 생성)
 * 2022.04.05   hwi1993     GM JV 작업
 * 2022.06.17	kdw2819		[C20220615-000414] RESU16H_Prime RTF 에러의 건
 * 2022.06.30	HWI1993		[C20220615-000093] [영업마케팅PI] MKT_FCST Waterfall 內 SaftyStock LevelGap measure 추가 요청 건
 * 2022.07.20	HWI1993		[C20220615-000414] RESU16H_Prime RTF 에러의 건 - RTF 중복오류 수정
 * 2022.10.17	rosia27		[C20221004-000309] ERP 피킹실적 VMI In plan(R+P) 실적 반영 요청 건
 * 2022.12.02	hwi1993		[C20221104-000430] UC법인 MKT FCST화면의 'Balance' Measure 로직 변경 요청의 件
 * 2022.12.06	HWI1993		[C20221207-000259] VMI 재고 계산시 소형사업부만 11자리 LIKE 먹도록 변경
 * 2022.12.07	hwi1993		[C20221207-000280] 원복 [C20221004-000309]
 * 2023.01.17   chano0612   [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건 - 선박BIZ건
 * 2024.05.28	HMIN		[E20240508-000695] Corvus/Siemens사 자동차사업부 RTF 산출 시 동기화 반영 요청  
							룩업(DM_NET_DEMAND_EXCEPTION)에 등록된 SITE대상으로 82번 사업부에 RTF정보를 81번 RTF 정보로 반영 처리
 * 2024.06.10	KCW3408		이동계획(SCP_PLN_RTF_ALLOCATION_V 테이블 에서 ITEM_ID를 가져오는 기준 변경,FROM_ITEM_ID가 존재시 먼저가져옴)                   
 * 2024.11.15	KANG.H.J	[PJ2024-50611] 소형 매출 프로세스 개선		
 * 2024.11.29	KANG.H.J	[PJ2024-50611] 전극데이터 생성 시 ORIGIN_DIVISION_ID in ('82','40') 변경, 전 사업부 FROM_SITE_ID 추가
 * 2024.12.11	JSSBAE		[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청
 * 2025.01.07	JSSBAE		[E20250107-000853]_[공급생산 SCM PI팀] 40번 사업부 전극 MA Plan Sales Plan Cutoff 시 적용요청
 * 2025.02.05	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화
 * 2025.03.05	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - EE_FN 수행시 RTF UPDATE 제외
 * 2025.04.02	KANG.H.J	[E20250402-000992] 81사업부 BPS 전송 매출계획 로직 보완
 * 2025.04.08	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제처리
 * 2025.04.24	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - 40사업부 PACK 제약 제거
 * 2025.04.28	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
 * 2025.05.08	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성) 보완
 * 2025.05.19	KANG.H.J	[PJ2025-50188] 기준수요 - RMA 등등 MKT_FCST 기반으로 RTF 생성하는 로직에서 40사업부는 SCM_FCST / 그외는 MKT_FCST로 정의함.
 * 2025.05.20	KANG.H.J	[PJ2025-50188] BALANCE MEASURE에 CELL_PROD_SITE_ID 고려
 * 2025.05.29	KANG.H.J	[PJ2025-50188] 임시테이블 #T2_MKT_FCST DROP 추가, 임시테이블 #T2_MKT_FCST ==> #T_MF_C_BALANCE_MKT_FCST 변경
 * 2025.05.29	KANG.H.J	[PJ2025-50188] @c_ee_fn_flag 처리 (현재 수행되는 것이 EE_FN 버젼일 경우 ==> 'Y' ==> RTF_SYS_RP / VMI_IN_PLAN / AS_IN_PLAN 업데이트 X)
 * 2025.06.02	KANG.H.J	[PJ2025-50188] EE_FN의 경우 VMI_IN_PLAN도 업데이트 처리
 * 2025.06.10	KANG.H.J	[PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V DROP 추가
 * 2025.06.11	KANG.H.J	[PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_C_RTF_ALLOCATION 이름변경
 * 2025.06.12	KANG.H.J	[PJ2025-50188] 임시테이블 #T_MF_C_EE_FN_MEASURE (EE-FINAL 구분관리용)
 * 2025.06.13	KANG.H.J	[PJ2025-50188] EE_FN 분기 로직 통합처리 (IF 분기문 밖에서 통합 처리)
 * 2025.06.24	KANG.H.J	[PJ2025-50188] ITEM_TYPE IN (Q,R)의 경우 DM_PLN_MKT_FCST_C에서 데이터 수집
 * 2025.11.11	JSSBAE		[E20251111-000455]_40사업부 전극 MA RTF 미반영 요청
 * 2026.01.09	JSSBAE		[E20260107-001287]_Sales Plan Waterfall W80F1 모델 RTF 미산출 건 (버전 SP_W_20260106_V002(W02))
 * 2026.04.09	JSSBAE		[E20260331-000648]_[자동차 SCM] 자동차사업부 '기준수요'기능 중 'RTF수정기능'만 우선 적용 요청 건
 * 2026.05.07	JSSBAE		[E20260507-000749]_자동차 RTF수정 오류 현상
 * 2026.05.13	JSSBAE		[E20260512-000502]_자동차 사업부 Cell Prod Site ID
 * 2026.08.28	JSSBAE		[E20260812-001054]_화요일 Sales Plan 재수행 후 H5.5 RTF 오류 발생
 *===================================================================================================================================================*/

CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE]
	-- Add the parameters for the stored procedure here
	  @p_division_id				NVARCHAR(30)  -- DIVISION_ID
	, @p_cut_off_version			NVARCHAR(18)  -- MKT_FCST_C의 Version
AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;
	
	--================================================================================================================
	-- LOG 용 변수 설정
	--================================================================================================================
    DECLARE @v_program_name					NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE';
    DECLARE @v_log_type						NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count					INTEGER = 0;
    DECLARE @v_log_message					NVARCHAR(1000);
    DECLARE @v_description					NVARCHAR(500);
    DECLARE @d_event_date					DATETIME;
    DECLARE @plan_start_yyyymmdd			NVARCHAR(08);
    DECLARE @c_plan_id						NVARCHAR(20);
    DECLARE @c_cutoff_yyyymmdd				NVARCHAR(08);
    DECLARE @c_cutoff_TYPE					NVARCHAR(04);

    DECLARE @c_SP_TYPE						NVARCHAR(04);
    DECLARE @c_SP_version					NVARCHAR(18);
    DECLARE @c_plan_id_ee					NVARCHAR(20); --[C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용(자동차 전극 : W-1)
	DECLARE @plan_week_cnt					INT;			-- 중장기 계획 주차 기간
	--DECLARE @c_ee_40_fn_cnt				  INT;			-- [PJ2025-50017] EE(40)의 FN 버전 수량 Count
	DECLARE @c_ee_fn_flag					NVARCHAR(02);	-- [PJ2025-50017] EE(40)의 FN 버전 여부 FLAG
	DECLARE @v_measure						NVARCHAR(30);	-- [PJ2025-50188] 40사업부는 SCM_FCST / 그외는 MKT_FCST.
	DECLARE @v_sp_cutoff_flag				NVARCHAR(02);	-- [E20260331-000648]_SALES PLAN CUTOFF 여부를 판단한 후 RTF 데이터 수정여부를 판단하기 위해 FLAG를 추가한다.

	--================================================================================================================
	-- 변수값 셋팅
	--================================================================================================================
	SELECT @c_cutoff_yyyymmdd = YYYYMMDD
	  FROM DM_MST_VERSION WITH(NOLOCK)
	 WHERE DIVISION_ID	= @P_DIVISION_ID
	   AND VERSION_NO	= @P_CUT_OFF_VERSION

	SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(@c_cutoff_yyyymmdd, 'MON')), 112)   -- 월요일
	SET @c_cutoff_TYPE		 = SUBSTRING(@p_cut_off_version,1,4)
	SET @c_SP_TYPE			 = 'SP'+ SUBSTRING(@c_cutoff_TYPE,3,2)        -- SALES PLAN 용
	SET @c_SP_version		 = 'SP'+ SUBSTRING(@p_cut_off_version,3,16)   -- SALES PLAN 용
	SET @c_plan_id			 = ISNULL((SELECT MAX(PLAN_ID) FROM SCP_PLN_RTF_ALLOCATION_V WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD <= @plan_start_yyyymmdd ),'')  -- plan_id 추출
	
	DECLARE @c_scp_rtf_flag 				NVARCHAR(02); --[C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 MKT Fcst에 RTF를 업데이트 하지 않음
    DECLARE @max_plan_start_yyyymmdd		NVARCHAR(08); --[C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용
	
	------------------------------------------------------------------------------------------------------------------
	-- [E20250107-000853]_[공급생산 SCM PI팀] 40번 사업부 전극 MA Plan Sales Plan Cutoff 시 적용요청 (START)
	-- 40사업부인 경우에만 당주 반영하고, 타사업부는 원 로직과 동일하게 전주 반영
	------------------------------------------------------------------------------------------------------------------
	IF @p_division_id = '40'
	BEGIN
		------------------------------------------------------------------------------------------------------------------
		-- [E20251111-000455]_40사업부 전극 MA RTF 미반영 요청 (START)
		-- EE 전극 미반영 요청으로 해당 부분 주석처리 후 PLAN_ID 체크하지 않도록 공백값 으로 설정 
		------------------------------------------------------------------------------------------------------------------
		/*
		SET @c_plan_id_ee			 = ISNULL((SELECT MAX(plan_id)
											   FROM SCP_PLN_RTF_ALLOCATION_V WITH(NOLOCK)   
											   --[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 START
											   --WHERE division_id = @p_division_id 
											   WHERE division_id = 'EE' 
											   AND origin_division_id = @p_division_id 
											   --[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 END
											   and plan_start_yyyymmdd <= @plan_start_yyyymmdd ),'')  --[C20210511-000221] plan_id_ee 추출
		;
		*/
		SET @c_plan_id_ee = '';
		------------------------------------------------------------------------------------------------------------------
		-- [E20251111-000455]_EE 전극 미반영 요청으로 해당 부분 주석처리 후 PLAN_ID 체크하지 않도록 공백값 으로 설정 (END)
		------------------------------------------------------------------------------------------------------------------

		SET @v_measure = 'SCM_FCST';			-- [PJ2025-50188] 40사업부는 SCM_FCST / 그외는 MKT_FCST.
	END
	ELSE 
	BEGIN
		SET @c_plan_id_ee = ISNULL((SELECT MAX(PLAN_ID)-1
									  FROM SCP_PLN_RTF_ALLOCATION_V WITH(NOLOCK)   
									  --[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 START
									  --WHERE division_id = @p_division_id 
									 WHERE DIVISION_ID = 'EE' 
									   AND ORIGIN_DIVISION_ID = @p_division_id 
									  --[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 END
									   AND PLAN_START_YYYYMMDD <= @plan_start_yyyymmdd ), '')  --[C20210511-000221] plan_id_ee 추출
		;
		SET @v_measure = 'MKT_FCST';			-- [PJ2025-50188] 40사업부는 SCM_FCST / 그외는 MKT_FCST.
	END
	------------------------------------------------------------------------------------------------------------------
	-- [E20250107-000853]_[공급생산 SCM PI팀] 40번 사업부 전극 MA Plan Sales Plan Cutoff 시 적용요청 (END)
	------------------------------------------------------------------------------------------------------------------
PRINT  @c_plan_id_ee

	DECLARE @c_scp_rtf_flag_ee 		      NVARCHAR(02); --[C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 MKT Fcst에 RTF를 업데이트 하지 않음(자동차 전극 : W-1)
    DECLARE @max_plan_start_yyyymmdd_ee	  NVARCHAR(08); --[C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용(자동차 전극 : W-1)
	
	------------------------------------------------------------------------------------------------------------------
	-- 중장기 계획 주차 기간
	------------------------------------------------------------------------------------------------------------------
	SELECT @plan_week_cnt = ATTRIBUTE1
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	WHERE LOOKUP_TYPE = 'DM_LONG_PLAN_WEEK_CNT'
	AND VALID_YN = 'Y'
	AND SEGMENT1 = @p_division_id

	IF ISNUMERIC(@plan_week_cnt) < 1
	BEGIN
		SET @plan_week_cnt = 54;
	END
	
	------------------------------------------------------------------------------------------------------------------
	-- [E20260331-000648]_당주 월요일이후, SALES PLAN CUTOFF 데이터가 존재하는 경우에만 수정한 RTF를 적용한다. 그 이전에는 SCP RTF를 적용하기위해 FLAG를 받는다. (START) 
	------------------------------------------------------------------------------------------------------------------
	-- 40 사업부와 81사업부에 한하여 해당 부분 요청하였으므로, 40, 81만 쓰도록 한다.
	IF ( @p_division_id = '40' OR LEFT(@p_division_id, 2) = '81' )
	BEGIN
		SELECT @v_sp_cutoff_flag = CASE WHEN A.CNT > 0 THEN 'Y' ELSE 'N' END
		FROM ( SELECT COUNT(*) AS CNT
				FROM DM_MST_VERSION WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				  AND VERSION_TYPE = 'SP_W'
				  AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)) A
	END
	ELSE
	BEGIN
		SET @v_sp_cutoff_flag = 'N'
	END
	------------------------------------------------------------------------------------------------------------------
	--[E20260331-000648]_당주 월요일이후, SALES PLAN CUTOFF 데이터가 존재하는 경우에만 수정한 RTF를 적용한다. 그 이전에는 SCP RTF를 적용하기위해 FLAG를 받는다. (END) 	
	------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------
	/* ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
		[E20240508-000695] 82번 사업부 호출시 81번 정보 RTF 갱신위한 작업
	   ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■*/
	DECLARE @p_cut_off_version_81		NVARCHAR(18);

	SELECT @p_cut_off_version_81 = MAX(VERSION_NO) 
	FROM  DM_MST_VERSION WITH(NOLOCK)	
	WHERE 1=1
	and division_id			=  '81'
	and YYYYMMDD			>= @plan_start_yyyymmdd		-- 당주월요일부터
	and VERSION_TYPE		=  'MF_W';					-- 81 사업부는 MF_W만 있음

--SELECT @p_cut_off_version_81 AS '@p_cut_off_version_81' ;RETURN;
PRINT @p_cut_off_version_81;

	--================================================================================================================
	-- 시작 LOG  (START)
	--================================================================================================================
	SET @v_log_type		= 'START';
	SET @v_log_message	= '########## Start of procedure ##########1';
    SET @v_description	= N'@p_division_id : ' + RTRIM(LTRIM(@p_division_id)) +' / ' + N'@p_cut_off_version : ' + RTRIM(LTRIM(@p_cut_off_version))  +' / ' + N'@c_plan_id : ' + RTRIM(LTRIM(@c_plan_id))   ;
	SET @d_event_date	= SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message	= NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	--================================================================================================================
	-- 시작 LOG  (END)
	--================================================================================================================

	-- 트랜잭션 (START)
	--BEGIN TRANSACTION MKT_FCST_C_QTY_BALANCE_CREATE;	
	------------------------------------------------------------------------------------------------------------------
	BEGIN TRY
	------------------------------------------------------------------------------------------------------------------	
		------------------------------------------------------------------------------------------------------------------
		-- TEMP TABLE SETTING (START)
		------------------------------------------------------------------------------------------------------------------
		BEGIN
		--PRINT 'TEMP TABLE SETTING START                      =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			IF OBJECT_ID (N'tempdb..#T2_CUTOFF_MST', N'U') IS NOT NULL 
				DROP TABLE #T2_CUTOFF_MST ;
			IF OBJECT_ID (N'tempdb..#T2_VMI_MST', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_MST
			IF OBJECT_ID (N'tempdb..#T2_VMI_MST_MAIN', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_MST_MAIN
			IF OBJECT_ID (N'tempdb..#T2_VMI_TEMP1', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_TEMP1
			IF OBJECT_ID (N'tempdb..#T2_VMI_TEMP2', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_TEMP2
			IF OBJECT_ID (N'tempdb..#T2_VMI_TEMP_all', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_TEMP_all
			IF OBJECT_ID (N'tempdb..#T2_CUTOFF_MST_ACCUM', N'U') IS NOT NULL 
				DROP TABLE #T2_CUTOFF_MST_ACCUM
			IF OBJECT_ID (N'tempdb..#T2_CUTOFF_TEMPX', N'U') IS NOT NULL 
				DROP TABLE #T2_CUTOFF_TEMPX
			IF OBJECT_ID (N'tempdb..#T2_MKT_FCST_INSERT', N'U') IS NOT NULL 
				DROP TABLE #T2_MKT_FCST_INSERT
			--IF OBJECT_ID (N'tempdb..#T9_MKT_FCST_INSERT', N'U') IS NOT NULL 
			--   DROP TABLE #T9_MKT_FCST_INSERT
			IF OBJECT_ID (N'tempdb..#T9_RTF_AFTER_INSERT', N'U') IS NOT NULL 
			   DROP TABLE #T9_RTF_AFTER_INSERT
			IF OBJECT_ID (N'tempdb..#T9_RTF_AFTER_INSERT', N'U') IS NOT NULL 
			   DROP TABLE #T9_RTF_AFTER_INSERT2
			IF OBJECT_ID (N'dbo.#T2_CUTOFF_MST', N'U') IS NOT NULL 
				DROP TABLE #T2_CUTOFF_MST ;
			IF OBJECT_ID (N'dbo.#T2_VMI_MST', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_MST
			IF OBJECT_ID (N'dbo.#T2_VMI_MST_MAIN', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_MST_MAIN
			IF OBJECT_ID (N'dbo.#T2_VMI_TEMP1', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_TEMP1
			IF OBJECT_ID (N'dbo.#T2_VMI_TEMP2', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_TEMP2
			IF OBJECT_ID (N'dbo.#T2_VMI_TEMP_all', N'U') IS NOT NULL 
				DROP TABLE #T2_VMI_TEMP_all
			IF OBJECT_ID (N'dbo.#T2_CUTOFF_MST_ACCUM', N'U') IS NOT NULL 
				DROP TABLE #T2_CUTOFF_MST_ACCUM
			IF OBJECT_ID (N'dbo.#T2_CUTOFF_TEMPX', N'U') IS NOT NULL 
				DROP TABLE #T2_CUTOFF_TEMPX
			IF OBJECT_ID (N'dbo.#FP_STOCK_QTY', N'U') IS NOT NULL  --[C20210511-000221] 임시테이블 삭제
				DROP TABLE #FP_STOCK_QTY
			IF OBJECT_ID (N'tempdb..#T_SSLVL', N'U') IS NOT NULL 
				DROP TABLE #T_SSLVL
			------------------------------------------------------------------------------------------------------------------				
			-- [PJ2024-50611] RTF_ALLOC Insert Temp 테이블 (START)
			IF OBJECT_ID (N'tempdb..#T2_RTF_ALLOC_INSERT', N'U') IS NOT NULL 
				DROP TABLE #T2_RTF_ALLOC_INSERT
			IF OBJECT_ID (N'tempdb..#T9_RTF_ALLOC_AFTER_INSERT', N'U') IS NOT NULL 
				DROP TABLE #T9_RTF_ALLOC_AFTER_INSERT
			IF OBJECT_ID (N'tempdb..#T9_RTF_ALLOC_AFTER_INSERT2', N'U') IS NOT NULL 
				DROP TABLE #T9_RTF_ALLOC_AFTER_INSERT2		
			-- [PJ2024-50611] RTF_ALLOC Insert Temp 테이블 (END)
			------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------					
			-- [PJ2025-50017] CFM_DEMAND Insert Temp 테이블 (START)
			IF OBJECT_ID (N'tempdb..#T2_CFM_DEMAND_INSERT', N'U') IS NOT NULL 
				DROP TABLE #T2_CFM_DEMAND_INSERT
			IF OBJECT_ID (N'tempdb..#T9_CFM_DEMAND_AFTER_INSERT', N'U') IS NOT NULL 
				DROP TABLE #T9_CFM_DEMAND_AFTER_INSERT
			IF OBJECT_ID (N'tempdb..#T9_CFM_DEMAND_AFTER_INSERT2', N'U') IS NOT NULL 
				DROP TABLE #T9_CFM_DEMAND_AFTER_INSERT2		
			-- [PJ2025-50017] CFM_DEMAND Insert Temp 테이블 (END)
			------------------------------------------------------------------------------------------------------------------	
			------------------------------------------------------------------------------------------------------------------			
			-- [PJ2025-50188] 임시테이블 #T2_MKT_FCST DROP 추가, 임시테이블 #T2_MKT_FCST ==> #T_MF_C_BALANCE_MKT_FCST 변경 (START)
			IF OBJECT_ID (N'tempdb..#T_MF_C_BALANCE_MKT_FCST', N'U') IS NOT NULL	
				DROP TABLE #T_MF_C_BALANCE_MKT_FCST
			-- [PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V DROP
			--IF OBJECT_ID (N'tempdb..#T2_SCP_PLN_RTF_ALLOCATION_V', N'U') IS NOT NULL 
			--	DROP TABLE #T2_SCP_PLN_RTF_ALLOCATION_V
			-- [PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_C_RTF_ALLOCATION 이름변경
			IF OBJECT_ID (N'tempdb..#T_MF_C_RTF_ALLOCATION', N'U') IS NOT NULL 
				DROP TABLE #T_MF_C_RTF_ALLOCATION
			-- [PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_C_RTF_ALLOCATION 이름변경
			IF OBJECT_ID (N'tempdb..#T_MF_C_RTF_ALLOCATION', N'U') IS NOT NULL 
				DROP TABLE #T_MF_C_RTF_ALLOCATION	
			-- [PJ2025-50188] 임시테이블 #T2_MKT_FCST DROP 추가, 임시테이블 #T2_MKT_FCST ==> #T_MF_C_BALANCE_MKT_FCST 변경 (END)
			------------------------------------------------------------------------------------------------------------------	
			-- [PJ2025-50188] EE_FN 분기 로직 통합처리 (EE_FN 분기에 따른 부분은 임시테이블에 지정하는 Measure로 구분함) (START)
			IF OBJECT_ID (N'tempdb..#T_MEASURE_MF_ALL', N'U') IS NOT NULL 
				DROP TABLE #T_MEASURE_MF_ALL
			IF OBJECT_ID (N'tempdb..#T_MEASURE_VMI_RTF', N'U') IS NOT NULL 
				DROP TABLE #T_MEASURE_VMI_RTF
			IF OBJECT_ID (N'tempdb..#T_MEASURE_RTF', N'U') IS NOT NULL 
				DROP TABLE #T_MEASURE_RTF
			-- [PJ2025-50188] EE_FN 분기 로직 통합처리 (EE_FN 분기에 따른 부분은 임시테이블에 지정하는 Measure로 구분함) (END)
			------------------------------------------------------------------------------------------------------------------
			-- [E20260331-000648]_사용자가 수정한 데이터라 적용하지 않아야하는 데이터에 대해 예외처리하기위한 테이블을 셋업한다. (START) 
			IF OBJECT_ID (N'tempdb..#T_RTF_EXCEPTION_ITEM', N'U') IS NOT NULL 
				DROP TABLE #T_RTF_EXCEPTION_ITEM
			-- [E20260331-000648]_사용자가 수정한 데이터라 적용하지 않아야하는 데이터에 대해 예외처리하기위한 테이블을 셋업한다. (END) 
			------------------------------------------------------------------------------------------------------------------

			CREATE TABLE  #T2_CUTOFF_MST
			( DIVISION_ID			NVARCHAR(30)	NOT NULL
			, PROJECT_CODE			NVARCHAR(50)	NOT NULL
			, SCM_SITE_ID			NVARCHAR(30)	NOT NULL
			, ITEM_ID				NVARCHAR(50)	NOT NULL
			, DOM_EXP				NVARCHAR(03)	NOT NULL
			, FCST_TYPE				NVARCHAR(20)	NOT NULL
			, INCOTERMS				NVARCHAR(10)	NOT NULL
			, PLANT_SITE_ID			NVARCHAR(30)	NOT NULL
			, YYYYMMDD				NVARCHAR(08)	NOT NULL
			, MEASURE				NVARCHAR(50)	NOT NULL
			, QTY					NUMERIC(30,10)	NOT NULL
			, CELL_PROD_SITE_ID		NVARCHAR(30)	NULL )  -- [PJ2025-50017] BALANCE 계산용. CELL_PROD_SITE_ID 추가 

			CREATE CLUSTERED INDEX [IDX_T_CUTOFF_MST_N1] ON [#T2_CUTOFF_MST]
			( DIVISION_ID		ASC
			, PROJECT_CODE		ASC
			, SCM_SITE_ID		ASC
			, ITEM_ID			ASC
			, DOM_EXP			ASC
			, FCST_TYPE			ASC
			, INCOTERMS			ASC
			, PLANT_SITE_ID		ASC
			, YYYYMMDD			ASC
			, MEASURE			ASC
			, CELL_PROD_SITE_ID ASC				-- [PJ2025-50017] 추가 
			) WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY];

			CREATE TABLE  #T2_CUTOFF_MST_ACCUM
			( DIVISION_ID			NVARCHAR(30)	NOT NULL
			, PROJECT_CODE			NVARCHAR(50)	NOT NULL
			, SCM_SITE_ID			NVARCHAR(30)	NOT NULL
			, ITEM_ID				NVARCHAR(50)	NOT NULL
			, DOM_EXP				NVARCHAR(03)	NOT NULL
			, FCST_TYPE				NVARCHAR(20)	NOT NULL
			, INCOTERMS				NVARCHAR(10)	NOT NULL
			, PLANT_SITE_ID			NVARCHAR(30)	NOT NULL
			, YYYYMMDD				NVARCHAR(08)	NOT NULL
			, MEASURE				NVARCHAR(50)	NOT NULL
			, QTY					NUMERIC(30,10)	NOT NULL
			, CELL_PROD_SITE_ID		NVARCHAR(30)	NULL  -- [PJ2025-50017] BALANCE 계산용. CELL_PROD_SITE_ID 추가  
			, ACCUM_SUM				NUMERIC(30,10)	NOT NULL )

			CREATE CLUSTERED INDEX [IDX_T_CUTOFF_MST_ACCUM] ON [#T2_CUTOFF_MST_ACCUM]
			( DIVISION_ID		ASC
			, PROJECT_CODE		ASC
			, SCM_SITE_ID		ASC
			, ITEM_ID			ASC
			, DOM_EXP			ASC
			, FCST_TYPE			ASC
			, INCOTERMS			ASC
			, PLANT_SITE_ID		ASC
			, YYYYMMDD			ASC
			, MEASURE			ASC
			, CELL_PROD_SITE_ID ASC				-- [PJ2025-50017] 추가 
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY];

			CREATE TABLE  #T2_CUTOFF_TEMPX
			( DIVISION_ID			NVARCHAR(30)	NOT NULL
			, PROJECT_CODE			NVARCHAR(50)	NOT NULL
			, SCM_SITE_ID			NVARCHAR(30)	NOT NULL
			, ITEM_ID				NVARCHAR(50)	NOT NULL
			, DOM_EXP				NVARCHAR(03)	NOT NULL
			, FCST_TYPE				NVARCHAR(20)	NOT NULL
			, INCOTERMS				NVARCHAR(10)	NOT NULL
			, PLANT_SITE_ID			NVARCHAR(30)	NOT NULL
			, MEASURE				NVARCHAR(50)	NOT NULL
			, YYYYMMDD				NVARCHAR(08)	NOT NULL
			, CELL_PROD_SITE_ID		NVARCHAR(30)	NULL  -- [PJ2025-50017] BALANCE 계산용. CELL_PROD_SITE_ID 추가 
			, ACCUM_X				NUMERIC(30,10)	NOT NULL )

			CREATE CLUSTERED INDEX [IDX_CUTOFF_TEMPX_N1] ON [#T2_CUTOFF_TEMPX]
			( DIVISION_ID		ASC
			, PROJECT_CODE		ASC
			, SCM_SITE_ID		ASC
			, ITEM_ID			ASC
			, DOM_EXP			ASC
			, FCST_TYPE			ASC
			, INCOTERMS			ASC
			, PLANT_SITE_ID		ASC
			, MEASURE			ASC
			, YYYYMMDD			ASC
			, CELL_PROD_SITE_ID ASC				-- [PJ2025-50017] 추가 
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];

			CREATE TABLE  #T2_VMI_MST
			( DIVISION_ID			NVARCHAR(30)	NOT NULL
			, PROJECT_CODE			NVARCHAR(50)	NOT NULL
			, SCM_SITE_ID			NVARCHAR(30)	NOT NULL
			, ITEM_ID				NVARCHAR(50)	NOT NULL
			, DOM_EXP				NVARCHAR(03)	NOT NULL
			, FCST_TYPE				NVARCHAR(20)	NOT NULL
			, INCOTERMS				NVARCHAR(10)	NOT NULL
			, PLANT_SITE_ID			NVARCHAR(30)	NOT NULL
			, MEASURE				NVARCHAR(50)	NOT NULL
			, YYYYMMDD				NVARCHAR(08)	NOT NULL
			, QTY					NUMERIC(30,10)	NOT NULL
			, CELL_PROD_SITE_ID		NVARCHAR(30)	NULL	-- [PJ2025-50017] VMI RTF 계산을 위해 신규 생성
			, FROM_SITE_ID			NVARCHAR(30)	NULL )	-- [PJ2025-50017] VMI RTF 계산을 위해 신규 생성			

			CREATE TABLE  #T2_VMI_MST_MAIN
			( DIVISION_ID			NVARCHAR(30)	NOT NULL
			, PROJECT_CODE			NVARCHAR(50)	NOT NULL
			, SCM_SITE_ID			NVARCHAR(30)	NOT NULL
			, ITEM_ID				NVARCHAR(50)	NOT NULL
			, DOM_EXP				NVARCHAR(03)	NOT NULL
			, FCST_TYPE				NVARCHAR(20)	NOT NULL
			, INCOTERMS				NVARCHAR(10)	NOT NULL
			, PLANT_SITE_ID			NVARCHAR(30)	NOT NULL
			, MEASURE				NVARCHAR(50)	NOT NULL
			, YYYYMMDD				NVARCHAR(08)	NOT NULL
			, QTY					NUMERIC(30,10)	NOT NULL
			, CELL_PROD_SITE_ID		NVARCHAR(30)	NULL	-- [PJ2025-50017] VMI RTF 계산을 위해 신규 생성
			, FROM_SITE_ID			NVARCHAR(30)	NULL )	-- [PJ2025-50017] VMI RTF 계산을 위해 신규 생성

			CREATE TABLE  #T2_VMI_TEMP1
			( DIVISION_ID			NVARCHAR(30)	NOT NULL
			, PROJECT_CODE			NVARCHAR(50)	NOT NULL
			, SCM_SITE_ID			NVARCHAR(30)	NOT NULL
			, ITEM_ID				NVARCHAR(50)	NOT NULL
			, DOM_EXP				NVARCHAR(03)	NOT NULL
			, FCST_TYPE				NVARCHAR(20)	NOT NULL
			, INCOTERMS				NVARCHAR(10)	NOT NULL
			, PLANT_SITE_ID			NVARCHAR(30)	NOT NULL
			, YYYYMMDD				NVARCHAR(08)	NOT NULL
			, MEASURE				NVARCHAR(50)	NOT NULL
			, QTY					NUMERIC(30,10)	NOT NULL
			, ACCUM_SUM				NUMERIC(30,10)	NOT NULL
			, last_accum_sum		NUMERIC(30,10)	NOT NULL
			, CELL_PROD_SITE_ID		NVARCHAR(30)	NULL	-- [PJ2025-50017] VMI RTF 계산을 위해 신규 생성
			, FROM_SITE_ID			NVARCHAR(30)	NULL )	-- [PJ2025-50017] VMI RTF 계산을 위해 신규 생성

			CREATE CLUSTERED INDEX [IDX_40_TEMP1_N1] ON [#T2_VMI_TEMP1]
			( DIVISION_ID		ASC
			, PROJECT_CODE		ASC
			, SCM_SITE_ID		ASC
			, ITEM_ID			ASC
			, DOM_EXP			ASC
			, FCST_TYPE			ASC
			, INCOTERMS			ASC
			, PLANT_SITE_ID		ASC
			, YYYYMMDD			ASC
			, MEASURE			ASC
			, CELL_PROD_SITE_ID ASC				-- [PJ2025-50017] VMI RTF 계산을 위해 신규 생성
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];

			CREATE TABLE  #T2_VMI_TEMP2
			( DIVISION_ID			NVARCHAR(30)	NOT NULL
			, PROJECT_CODE			NVARCHAR(50)	NOT NULL
			, SCM_SITE_ID			NVARCHAR(30)	NOT NULL
			, ITEM_ID				NVARCHAR(50)	NOT NULL
			, DOM_EXP				NVARCHAR(03)	NOT NULL
			, FCST_TYPE				NVARCHAR(20)	NOT NULL
			, INCOTERMS				NVARCHAR(10)	NOT NULL
			, PLANT_SITE_ID			NVARCHAR(30)	NOT NULL
			, YYYYMMDD				NVARCHAR(08)	NOT NULL
			, MEASURE				NVARCHAR(50)	NOT NULL
			, QTY					NUMERIC(30,10)	NOT NULL
			, ACCUM_SUM				NUMERIC(30,10)	NOT NULL
			, LAST_ACCUM_SUM 		NUMERIC(30,10)	NOT NULL
			, CELL_PROD_SITE_ID		NVARCHAR(30)	NULL	-- [PJ2025-50017] VMI RTF 계산을 위해 신규 생성
			, FROM_SITE_ID			NVARCHAR(30)	NULL )	-- [PJ2025-50017] VMI RTF 계산을 위해 신규 생성

			CREATE CLUSTERED INDEX [IDX_40_TEMP2_N1] ON [#T2_VMI_TEMP2]
			( DIVISION_ID		ASC
			, PROJECT_CODE		ASC
			, SCM_SITE_ID		ASC
			, ITEM_ID			ASC
			, DOM_EXP			ASC
			, FCST_TYPE			ASC
			, INCOTERMS			ASC
			, PLANT_SITE_ID		ASC
			, YYYYMMDD			ASC
			, MEASURE			ASC
			, CELL_PROD_SITE_ID ASC				-- [PJ2025-50017] VMI RTF 계산을 위해 신규 생성
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];

			CREATE TABLE  #T2_VMI_TEMP_all
			( DIVISION_ID			NVARCHAR(30)	NOT NULL
			, PROJECT_CODE			NVARCHAR(50)	NOT NULL
			, SCM_SITE_ID			NVARCHAR(30)	NOT NULL
			, ITEM_ID				NVARCHAR(50)	NOT NULL
			, DOM_EXP				NVARCHAR(03)	NOT NULL
			, FCST_TYPE				NVARCHAR(20)	NOT NULL
			, INCOTERMS				NVARCHAR(10)	NOT NULL
			, PLANT_SITE_ID			NVARCHAR(30)	NOT NULL
			, YYYYMMDD				NVARCHAR(08)	NOT NULL
			, RTF_QTY				NUMERIC(30,10)	NOT NULL
			, INV					NUMERIC(30,10)	NOT NULL
			, CELL_PROD_SITE_ID		NVARCHAR(30)	NULL	-- [PJ2025-50017] VMI RTF 계산을 위해 신규 생성
			, FROM_SITE_ID			NVARCHAR(30)	NULL )	-- [PJ2025-50017] VMI RTF 계산을 위해 신규 생성
			
			CREATE CLUSTERED INDEX [IDX_40_TEMP_all_N1] ON [#T2_VMI_TEMP_all]
			( DIVISION_ID		ASC
			, PROJECT_CODE		ASC
			, SCM_SITE_ID		ASC
			, ITEM_ID			ASC
			, DOM_EXP			ASC
			, FCST_TYPE			ASC
			, INCOTERMS			ASC
			, PLANT_SITE_ID		ASC
			, YYYYMMDD			ASC
			, CELL_PROD_SITE_ID ASC				-- [PJ2025-50017] VMI RTF 계산을 위해 신규 생성
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];
					
			------------------------------------------------------------------------------------------------------------------	
			-- SAFETY STOCK LEVEL 처리용 (START)
			CREATE TABLE #T_SSLVL 
			( DIVISION_ID			NVARCHAR(30)	NOT NULL
			, SCM_SITE_ID			NVARCHAR(30)	NOT NULL
			, ITEM_ID				NVARCHAR(50)	NOT NULL
			, PROJECT_CODE			NVARCHAR(50)	NOT NULL
			, INCOTERMS				NVARCHAR(10)	NOT NULL
			, PLANT_SITE_ID			NVARCHAR(30)	NOT NULL
			, DOM_EXP				NVARCHAR(03)	NOT NULL )
			-- SAFETY STOCK LEVEL 처리용 (END)
			------------------------------------------------------------------------------------------------------------------	
			
			------------------------------------------------------------------------------------------------------------------	
			-- [PJ2025-50188] EE_FN 분기 로직 통합처리 (EE_FN 분기에 따른 부분은 임시테이블에 지정하는 Measure로 구분 ==> 임시테이블 생성) (START)
			CREATE TABLE #T_MEASURE_MF_ALL	( MEASURE NVARCHAR(30) NOT NULL );
			CREATE TABLE #T_MEASURE_VMI_RTF ( MEASURE NVARCHAR(30) NOT NULL );
			CREATE TABLE #T_MEASURE_RTF		( MEASURE NVARCHAR(30) NOT NULL );
			-- [PJ2025-50188] EE_FN 분기 로직 통합처리 (EE_FN 분기에 따른 부분은 임시테이블에 지정하는 Measure로 구분 ==> 임시테이블 생성) (END)
			------------------------------------------------------------------------------------------------------------------				
			------------------------------------------------------------------------------------------------------------------
			-- [E20260331-000648]_사용자가 수정한 데이터라 적용하지 않아야하는 데이터에 대해 예외처리하기위한 테이블을 셋업한다. (START) 
			CREATE TABLE #T_RTF_EXCEPTION_ITEM 
			( DIVISION_ID			NVARCHAR(30)   
			, PROJECT_CODE			NVARCHAR(50)  
			, END_CUSTOMER			NVARCHAR(100)   
			, SCM_SITE_ID			NVARCHAR(30)   
			, ITEM_ID				NVARCHAR(50)   
			, DOM_EXP				NVARCHAR(3)    
			, FCST_TYPE				NVARCHAR(20)   
			, INCOTERMS				NVARCHAR(10)   
			, PLANT_SITE_ID			NVARCHAR(30)   
			, CELL_PROD_SITE_ID		NVARCHAR(30)   			
			, MEASURE				NVARCHAR(50));							
			-- [E20260331-000648]_사용자가 수정한 데이터라 적용하지 않아야하는 데이터에 대해 예외처리하기위한 테이블을 셋업한다. (END)
			------------------------------------------------------------------------------------------------------------------					
			------------------------------------------------------------------------------------------------------------------			
			-- [PJ2025-50017] 소형 매출계획 동기화 개선 (START) 
			-- [SCP_PLN_RTF_ALLOCATION_V] 임시테이블에 저장 후 사용함.
			------------------------------------------------------------------------------------------------------------------		
			-- [PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_C_RTF_ALLOCATION 이름변경 (START)
--			CREATE TABLE  #T2_SCP_PLN_RTF_ALLOCATION_V
			CREATE TABLE  #T_MF_C_RTF_ALLOCATION
			( MASTER_ID				NVARCHAR(50)	NOT NULL
			, PLAN_ID				NVARCHAR(30)	NOT NULL
			, OUT_VERSION_ID		NVARCHAR(30)	NOT NULL
			, DIVISION_ID			NVARCHAR(30)	NOT NULL
			, ORIGIN_DIVISION_ID	NVARCHAR(30)	NOT NULL
			, PLAN_START_YYYYMMDD	NVARCHAR(8)		NOT NULL
			, PLAN_TYPE				NVARCHAR(50)	NOT NULL
			, SEQ					BIGINT			NOT NULL
			, OPERATION_GROUP		NVARCHAR(10)	NOT NULL
			, ENG_DEMAND_ID			NVARCHAR(1000)	NOT NULL
			, ITEM_ID				NVARCHAR(50)	NOT NULL
			, PROJECT_CODE			NVARCHAR(50)	NOT NULL
			, SALES_SITE_ID			NVARCHAR(30)	NOT NULL
			, INCOTERMS				NVARCHAR(10)	NULL
			, DOM_EXP				NVARCHAR(10)	NULL
			, FCST_TYPE				NVARCHAR(20)	NULL
			, DEMAND_TYPE			NVARCHAR(50)	NULL
			, DUE_DATE				NVARCHAR(8)		NULL
			, PLANT_SITE_ID			NVARCHAR(30)	NOT NULL
			, YYYYMMDD				NVARCHAR(8)		NOT NULL
			, ALLOCATION_QTY		NUMERIC(20,10)	NULL
			, DELIVERY_ORDER_ID		NVARCHAR(200)	NULL
			, FROM_SITE				NVARCHAR(150)	NOT NULL
			, FROM_ITEM_ID			NVARCHAR(150)	NULL
			, SCP_INCOTERMS			NVARCHAR(10)	NULL
			, FROM_SITE_ID			NVARCHAR(150)	NOT NULL
			, CELL_PROD_SITE_ID		NVARCHAR(150)	NOT NULL ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가				
			------------------------------------------------------------------------------------------------------------------			
			-- [PJ2025-50017] 소형 매출계획 동기화 개선 (END) 
			-- [SCP_PLN_RTF_ALLOCATION_V] 임시테이블에 저장 후 사용함.
			------------------------------------------------------------------------------------------------------------------	
		END
		
		------------------------------------------------------------------------------------------------------------------
		-- TEMP TABLE SETTING (END)
		------------------------------------------------------------------------------------------------------------------		
		------------------------------------------------------------------------------------------------------------------
		-- MKT_FCST, RTF 대상 날짜및 값 추출 (START)
		------------------------------------------------------------------------------------------------------------------			
		------------------------------------------------------------------------------------------------------------------
		-- RTF MEASURE MKT_FCST TABLE INSERT (START)	
		------------------------------------------------------------------------------------------------------------------
		BEGIN			
			------------------------------------------------------------------------------------------------------------------		
			-- [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용 (START)
			------------------------------------------------------------------------------------------------------------------		
			SET @max_plan_start_yyyymmdd = ISNULL(( SELECT MAX(PLAN_START_YYYYMMDD) 
													  FROM SCP_PLN_RTF_ALLOCATION_V WITH(NOLOCK)
													 WHERE DIVISION_ID	= @p_division_id
													   AND PLAN_ID		= @c_plan_id), '' )
													
			SET @c_scp_rtf_flag = ( SELECT ISNULL(MAX(DM_RTF_YN), 'Y')
									  FROM SCP_PLN_INTERFACE_YN WITH(NOLOCK)
									 WHERE DIVISION_ID			= @p_division_id
									   AND PLAN_START_YYYYMMDD	= @max_plan_start_yyyymmdd );

			IF (@c_scp_rtf_flag = 'N') 			
			BEGIN
				------------------------------------------------------------------------------------------------------------------		
				-- [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용 (START)
				SET @c_plan_id = ( SELECT MAX(PLAN_ID)
									 FROM SCM_MST_PLAN WITH(NOLOCK)
									WHERE DIVISION_ID = @p_division_id
									  AND PLAN_CYCLE  = 'WEEKLY'
									  AND PLAN_NAME	  = ( SELECT MAX(PLAN_START_YYYYMMDD)
														    FROM SCP_PLN_INTERFACE_YN WITH(NOLOCK)
														   WHERE DIVISION_ID		 = @p_division_id
															 AND PLAN_START_YYYYMMDD < @max_plan_start_yyyymmdd
															 AND DM_RTF_YN			 = 'Y' ))
															 
				------------------------------------------------------------------------------------------------------------------		
				-- LOG 생성 (START)
				------------------------------------------------------------------------------------------------------------------	
				SET @v_log_type		= 'ING';
				SET @v_log_message	= N'SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용';
				SET @v_description	= '@p_division_id : ' + ISNULL(@p_division_id,'NULL') + ' / ' + '@c_plan_id : ' + ISNULL(@c_plan_id,'NULL');
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				------------------------------------------------------------------------------------------------------------------		
				-- LOG 생성 (END)
				------------------------------------------------------------------------------------------------------------------	
			END
			-- [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용 (END)
			------------------------------------------------------------------------------------------------------------------				
			------------------------------------------------------------------------------------------------------------------		
			-- [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용(자동차 전극 : W-1) (START)
			SET @max_plan_start_yyyymmdd_ee = ISNULL(( SELECT MAX(PLAN_START_YYYYMMDD) 
														 FROM SCP_PLN_RTF_ALLOCATION_V WITH(NOLOCK)
														WHERE DIVISION_ID			= 'EE'
														  AND ORIGIN_DIVISION_ID	= @p_division_id
														  AND PLAN_ID				= @c_plan_id_ee), '')
													
			SET @c_scp_rtf_flag_ee = ( SELECT ISNULL(MAX(DM_RTF_YN), 'Y')
										 FROM SCP_PLN_INTERFACE_YN WITH(NOLOCK)
										WHERE DIVISION_ID         = 'EE'
										  AND PLAN_START_YYYYMMDD = @max_plan_start_yyyymmdd_ee );

			IF (@c_scp_rtf_flag_ee = 'N') 			
			BEGIN
				------------------------------------------------------------------------------------------------------------------	
				-- [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용 (START)
				SET @c_plan_id_ee = ( SELECT MAX(PLAN_ID)
										FROM SCM_MST_PLAN WITH(NOLOCK)
									   WHERE DIVISION_ID = 'EE'
										 AND PLAN_CYCLE  = 'WEEKLY'
										 AND PLAN_NAME   = ( SELECT MAX(PLAN_START_YYYYMMDD)
															   FROM SCP_PLN_INTERFACE_YN WITH(NOLOCK)
															  WHERE DIVISION_ID         = 'EE'
																AND PLAN_START_YYYYMMDD < @max_plan_start_yyyymmdd_ee
																AND DM_RTF_YN		    = 'Y' ))

				------------------------------------------------------------------------------------------------------------------		
				-- LOG 생성 (START)
				------------------------------------------------------------------------------------------------------------------	
				SET @v_log_type = 'ING';
				SET @v_log_message = N'SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용(EE)';
				SET @v_description = '@p_division_id : ' + ISNULL(@p_division_id,'NULL') + ' / ' + '@c_plan_id_ee : ' + ISNULL(@c_plan_id_ee,'NULL');
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				------------------------------------------------------------------------------------------------------------------		
				-- LOG 생성 (END)
				------------------------------------------------------------------------------------------------------------------	
			END
			-- [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용(자동차 전극 : W-1) (END)
			------------------------------------------------------------------------------------------------------------------				
			------------------------------------------------------------------------------------------------------------------	
			-- [PJ2025-50017] 소형 매출계획 동기화 개선 (START)
			IF (@p_division_id = '40')
			BEGIN
/*
				SELECT @c_ee_fn_flag = CASE WHEN ISNULL(PLAN_TYPE, '') ='FN' THEN 'Y' ELSE 'N' END
				FROM
				(
					SELECT TOP 1 PLAN_TYPE				-- DIVISION_ID/ORIGIN_DIVISION_ID/PLAN_ID ==> 기준으로는 1개의 PLAN_VERSION만 존재함.
					FROM [SCP_PLN_RTF_ALLOCATION_V]  WITH(NOLOCK)
					WHERE DIVISION_ID			= 'EE'
					AND   ORIGIN_DIVISION_ID	= @p_division_id		-- '40'  -- 20250529. 현재는 40만 존재함. 
					AND   PLAN_ID			    = @c_plan_id			-- '1392'
					--AND   PLAN_TYPE				= 'FN'
				) A
				-- 2025.05.28 P.C.I EE_FN 일 때만 RTF_SYS_PR 업데이트 안하도록 EE_FN 기준으로 설정 End
				
				-- 당주 기준의 EE_FN Count하여 해당 데이터가 있을 경우 현재 수행이 EE_FN임을 판별함
				--SELECT @c_ee_40_fn_cnt = COUNT(*)
				--FROM SCP_PLN_RTF_ALLOCATION_V WITH(NOLOCK)
				--WHERE DIVISION_ID			= 'EE'
				--AND   PLAN_START_YYYYMMDD	= @plan_start_yyyymmdd
				--AND   PLAN_TYPE				= 'FN'				

				--IF @c_ee_40_fn_cnt IS NULL
				--BEGIN
				--	SET @c_ee_40_fn_cnt = 0;
				--END	
*/
				-- [PJ2025-50188] PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE 는 40으로 호출되기 때문에 현재 수행되는 DIVISION이 40인지 EE인지 판별 필요함.
				-- START ==> SCM_MST_PLAN_DETAIL 의 최근 수행목록을 기반으로 체크함.
				SELECT @c_ee_fn_flag = CASE WHEN ISNULL(DIVISION_ID, '') = 'EE' THEN 'Y' ELSE 'N' END
				  FROM ( SELECT DIVISION_ID, OUTPUT_END_DATE, RANK() OVER (ORDER BY OUTPUT_END_DATE DESC, PLAN_SEQ DESC) AS RN
						   FROM SCM_MST_PLAN_DETAIL WITH(NOLOCK)
						  WHERE DIVISION_ID IN ( '40', 'EE' )
						    AND PLAN_ID		= @c_plan_id
						    AND PLAN_TYPE	= 'FN' ) A
				 WHERE RN = 1;

				IF @c_ee_fn_flag IS NULL
				BEGIN
					SET @c_ee_fn_flag = 'N';
				END	
				-- [PJ2025-50188] PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE 는 40으로 호출되기 때문에 현재 수행되는 DIVISION이 40인지 EE인지 판별 필요함. END 
			END					
			-- [PJ2025-50017] 소형 매출계획 동기화 개선 (END)		
			------------------------------------------------------------------------------------------------------------------		
			-- LOG 생성 (START)
			------------------------------------------------------------------------------------------------------------------	
			SET @v_log_type		= 'ING';
			SET @v_log_message	= N'Plan ID';
			SET @v_description	= '@p_division_id : ' + ISNULL(@p_division_id,'NULL') + ' / ' + ' / @c_plan_id : ' + ISNULL(@c_plan_id,'NULL') + ' / @c_plan_id_ee : ' + ISNULL(@c_plan_id_ee,'NULL');
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			--PRINT N'mkt_fcst  Cutoff RTF insert START               =>' + CONVERT(VARCHAR(8), GETDATE(), 108)		
			------------------------------------------------------------------------------------------------------------------		
			-- LOG 생성 (END)
			------------------------------------------------------------------------------------------------------------------

			--IF (@p_division_id = '40' AND @c_ee_40_fn_cnt > 0)  -- [PJ2025-50017] 현재 수행되는 기준이 EE_FN일 경우 RTF_SYS_RP/VMI_IN_PLAN/AS_IN_PLAN는 업데이트 안함. (RTF_PR만 업데이트 처리) ==> [PJ2025-50188] VMI_IN_PLAN/AS_IN_PLAN 업데이트 하는 것으로 변경
			IF ( @p_division_id = '40' AND @c_ee_fn_flag = 'Y' )  
			-- [PJ2025-50017] 현재 수행되는 기준이 EE_FN일 경우 RTF_SYS_RP/VMI_IN_PLAN/AS_IN_PLAN는 업데이트 안함. (RTF_PR만 업데이트 처리) ==> [PJ2025-50188] VMI_IN_PLAN/AS_IN_PLAN 업데이트 하는 것으로 변경
			BEGIN
				------------------------------------------------------------------------------------------------------------------
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_MF_ALL (EE_FN에서는 VMI_IN_PLAN/AS_INPLAN/RTF_PR만 SCP와 동기화) (START)
				INSERT INTO #T_MEASURE_MF_ALL		
				SELECT 'VMI_In_Plan'	UNION ALL
				SELECT 'AS_In_Plan'		UNION ALL
				SELECT 'SS_LVL'			UNION ALL
				SELECT 'SS_GAP'			UNION ALL
				SELECT 'RTF_PR'
				-- [PJ2025-50188] 'RTF_SYS_RP', 'RTF_SCP'는 제외함. (END)
				------------------------------------------------------------------------------------------------------------------
			END
			ELSE
			BEGIN
				------------------------------------------------------------------------------------------------------------------
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 ##T_MEASURE_MF_ALL (EE_FN이 아닐 경우는 VMI_IN_PLAN/AS_INPLAN/RTF_PR/RTF_SYS_RP/RTF_SCP 까지 모두 SCP와 동기화) (START)
				--==> 모든 MEASURE 우선 삭제함
				INSERT INTO #T_MEASURE_MF_ALL		
				SELECT 'VMI_In_Plan'	UNION ALL
				SELECT 'AS_In_Plan'		UNION ALL
				SELECT 'SS_LVL'			UNION ALL
				SELECT 'SS_GAP'			UNION ALL
				SELECT 'RTF_PR'			UNION ALL
				SELECT 'RTF_SYS_RP'		UNION ALL
				SELECT 'RTF_SCP'		UNION ALL
				SELECT 'RTF'
				-- [PJ2025-50188] 'RTF_SYS_RP', 'RTF_SCP', 'RTF'는 포함함. (END)
				------------------------------------------------------------------------------------------------------------------
			END
			
			------------------------------------------------------------------------------------------------------------------
			-- [E20260331-000648]_당주 월요일이후 데이터 중 당주 월요일 이후 수정한 이력이 있는 데이터를 TEMP에 담는다. (START) 
			------------------------------------------------------------------------------------------------------------------
			IF ( @v_sp_cutoff_flag = 'Y' )	-- 당주 월요일 이후 SALES PLAN을 CUTOFF한 데이터가 존재하는 경우에만 테이블 데이터를 INSERT 한다. 
			BEGIN
				IF ( @p_division_id = '40' OR @p_division_id LIKE '81%') --[E20260512-000502]_81도 CELL_PROD_SITE_ID를 받기때문에 해당 부분을 타도록 수정한다. 
				BEGIN
					-- 사용자가 변경하는 값은 해당 시점에 데이터가 변경되기때문에 변경때 변경되는 메져 3개는 당주 월요일 이후 수정건에 대한 내역 추출
					INSERT INTO #T_RTF_EXCEPTION_ITEM
					( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID )
					SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
					  FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C WITH(NOLOCK)
					 WHERE DIVISION_ID = @p_division_id --81
					   AND YYYYMMDD	  >= @plan_start_yyyymmdd --당주월요일 이후 데이터만 '20260406'
					   AND VERSION_NO  = @P_CUT_OFF_VERSION
					   AND CONVERT(VARCHAR(8), LAST_UPDATE_DATE, 112) >= @plan_start_yyyymmdd --당주월요일 이후 데이터만 '20260406'
					   AND MEASURE IN ( 'RTF_SYS_RP', 'RTF', 'RTF_SCP' ) 
					   AND LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
					 GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
					
					-- RTF_PR메져는 SCP의 FINAL값을 반영하는 부분으로, 수정된 대상들을 가지고 조회한다.
					INSERT INTO #T_RTF_EXCEPTION_ITEM
					( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID )
					SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
						 , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID
					  FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A WITH(NOLOCK) 
					 INNER JOIN #T_RTF_EXCEPTION_ITEM B 
						     ON A.DIVISION_ID			= B.DIVISION_ID
							AND A.PROJECT_CODE			= B.PROJECT_CODE
							AND A.END_CUSTOMER			= B.END_CUSTOMER
							AND A.SCM_SITE_ID			= B.SCM_SITE_ID
							AND A.ITEM_ID				= B.ITEM_ID
							AND A.DOM_EXP				= B.DOM_EXP
							AND A.FCST_TYPE				= B.FCST_TYPE
							AND A.INCOTERMS				= B.INCOTERMS
							AND A.PLANT_SITE_ID			= B.PLANT_SITE_ID
							AND A.CELL_PROD_SITE_ID		= B.CELL_PROD_SITE_ID
					 WHERE A.MEASURE		= 'RTF_PR'						  
					   AND A.VERSION_NO		= @P_CUT_OFF_VERSION
					 GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
							, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID
				END
				ELSE 
				BEGIN
					-- 사용자가 변경하는 값은 해당 시점에 데이터가 변경되기때문에 변경때 변경되는 메져 3개는 당주 월요일 이후 수정건에 대한 내역 추출
					INSERT INTO #T_RTF_EXCEPTION_ITEM
					( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID )
					SELECT DIVISION_ID, PROJECT_CODE, '' AS END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
						 , MEASURE, PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID
					  FROM DM_PLN_MKT_FCST_C WITH(NOLOCK)
					 WHERE DIVISION_ID = @p_division_id --81
					   AND YYYYMMDD >= @plan_start_yyyymmdd --당주월요일 이후 데이터만 '20260406'
					   AND CONVERT(VARCHAR(8), LAST_UPDATE_DATE, 112) >= @plan_start_yyyymmdd --당주월요일 이후 데이터만 '20260406'
					   AND VERSION_NO  = @P_CUT_OFF_VERSION
					   AND MEASURE IN ( 'RTF_SYS_RP', 'RTF', 'RTF_SCP' ) 
					   AND LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
					 GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					
					-- RTF_PR메져는 SCP의 FINAL값을 반영하는 부분으로, 수정된 대상들을 가지고 조회한다.
					INSERT INTO #T_RTF_EXCEPTION_ITEM
					( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID )
					SELECT A.DIVISION_ID, A.PROJECT_CODE, '' AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
						 , A.MEASURE, A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID
					  FROM DM_PLN_MKT_FCST_C A WITH(NOLOCK) 
					 INNER JOIN #T_RTF_EXCEPTION_ITEM B 
							 ON A.DIVISION_ID			= B.DIVISION_ID
							AND A.PROJECT_CODE			= B.PROJECT_CODE
							AND A.SCM_SITE_ID			= B.SCM_SITE_ID
							AND A.ITEM_ID				= B.ITEM_ID
							AND A.DOM_EXP				= B.DOM_EXP
							AND A.FCST_TYPE				= B.FCST_TYPE
							AND A.INCOTERMS				= B.INCOTERMS
							AND A.PLANT_SITE_ID			= B.PLANT_SITE_ID
					 WHERE A.MEASURE		= 'RTF_PR'
					   AND A.VERSION_NO		= @P_CUT_OFF_VERSION
					 GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
				END
			END
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_당주 월요일이후 데이터 중 당주 월요일 이후 수정한 이력이 있는 데이터를 TEMP에 담는다. (END) 
			-------------------------------------------------------------------------------------------------------------------------------------------	

			--SELECT @p_division_id,@c_plan_id,@plan_start_yyyymmdd,@p_cut_off_version,@c_cutoff_TYPE,@c_cutoff_yyyymmdd
			/*	-- [PJ2025-50188] #T_MEASURE_MF_ALL 참고
				 . EE_FN 인 경우   ('VMI_In_Plan', 'AS_In_Plan', 'SS_LVL', 'SS_GAP', 'RTF_PR')
				 . EE_FN 아닌 경우 ('VMI_In_Plan', 'AS_In_Plan', 'SS_LVL', 'SS_GAP', 'RTF_PR', 'RTF_SYS_RP','RTF_SCP', 'RTF' ) */
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260107-001287]_전극의 경우는 FCSTPRICE MGMT 화면에서 데이터를 저장한 데이터를 반영하기 때문에, 40사업부의 경우는 삭제하지 않도록 수정한다.(START)
			IF (@p_division_id = '40')
			BEGIN				
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_MF_ALL (임시테이블에 정의된 MEASURE 삭제)
				-- [E20260107-001287]_40 사업부 데이터를 삭제할때는 전극 데이터가 삭제되지 않도록 NOT IN 처리를 한다.
				DELETE A
				  FROM DM_PLN_MKT_FCST_C A
				 WHERE A.MEASURE IN (SELECT MEASURE FROM #T_MEASURE_MF_ALL WITH(NOLOCK))		
				   AND A.DIVISION_ID		= @p_division_id
				   AND A.VERSION_NO			= @p_cut_off_version
				   AND A.CUTOFF_TYPE		= @c_cutoff_TYPE
				   AND A.CUTOFF_YYYYMMDD	= @c_cutoff_yyyymmdd
				   AND A.ITEM_ID NOT IN ( SELECT K.ITEM_ID FROM SCM_MST_ITEM_SN K WITH(NOLOCK) 
										   WHERE K.DIVISION_ID = A.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y' AND K.DIVISION_ID = '40' )
				   -------------------------------------------------------------------------------------------------------------------------------------------	
				   -- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (START) 
				   -------------------------------------------------------------------------------------------------------------------------------------------	
				   AND NOT EXISTS ( SELECT DISTINCT ITEM_ID 
									  FROM #T_RTF_EXCEPTION_ITEM B WITH(NOLOCK)
									 WHERE A.DIVISION_ID		= B.DIVISION_ID
									   AND A.PROJECT_CODE		= B.PROJECT_CODE
									   AND A.SCM_SITE_ID		= B.SCM_SITE_ID
									   AND A.ITEM_ID			= B.ITEM_ID
									   AND A.DOM_EXP			= B.DOM_EXP
									   AND A.FCST_TYPE			= B.FCST_TYPE
									   AND A.INCOTERMS			= B.INCOTERMS
									   AND A.MEASURE			= B.MEASURE
									   AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
									   AND A.YYYYMMDD		   >= @plan_start_yyyymmdd /*-- 당주월요일*/
									   AND A.VERSION_NO			= @P_CUT_OFF_VERSION )
				   -------------------------------------------------------------------------------------------------------------------------------------------	
				   -- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (END) 
				   -------------------------------------------------------------------------------------------------------------------------------------------	
			END
			ELSE
			BEGIN
				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [E20260107-001287]_40 사업부 외의 다른 사업부는 원 로직과 동일하게 둔다.
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_MF_ALL (임시테이블에 정의된 MEASURE 삭제)
				-------------------------------------------------------------------------------------------------------------------------------------------	
				DELETE A
				  FROM DM_PLN_MKT_FCST_C A
				 WHERE MEASURE IN (SELECT MEASURE FROM #T_MEASURE_MF_ALL WITH(NOLOCK))		
				   AND DIVISION_ID		= @p_division_id
				   AND VERSION_NO		= @p_cut_off_version
				   AND CUTOFF_TYPE		= @c_cutoff_TYPE
				   AND CUTOFF_YYYYMMDD	= @c_cutoff_yyyymmdd
				   -------------------------------------------------------------------------------------------------------------------------------------------	
				   -- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (START) 
				   -------------------------------------------------------------------------------------------------------------------------------------------	
				   AND NOT EXISTS ( SELECT DISTINCT ITEM_ID 
									  FROM #T_RTF_EXCEPTION_ITEM B WITH(NOLOCK)
									 WHERE A.DIVISION_ID		= B.DIVISION_ID
									   AND A.PROJECT_CODE		= B.PROJECT_CODE
									   AND A.SCM_SITE_ID		= B.SCM_SITE_ID
									   AND A.ITEM_ID			= B.ITEM_ID
									   AND A.DOM_EXP			= B.DOM_EXP
									   AND A.FCST_TYPE			= B.FCST_TYPE
									   AND A.INCOTERMS			= B.INCOTERMS
									   AND A.MEASURE			= B.MEASURE
									   AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
									   AND A.YYYYMMDD		   >= @plan_start_yyyymmdd /*-- 당주월요일*/
									   AND A.VERSION_NO			= @P_CUT_OFF_VERSION )
				   -------------------------------------------------------------------------------------------------------------------------------------------	
				   -- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (END) 
				   -------------------------------------------------------------------------------------------------------------------------------------------	
			END
			-- [E20260107-001287]_전극의 경우는 FCSTPRICE MGMT 화면에서 데이터를 저장한 데이터를 반영하기 때문에, 40사업부의 경우는 삭제하지 않도록 수정한다.(END)
			-------------------------------------------------------------------------------------------------------------------------------------------					
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용				   
			DELETE FROM DM_PLN_MKT_FCST_C
			 WHERE MEASURE IN ( 'RTF')
			   AND DIVISION_ID			= @p_division_id
			   AND VERSION_NO			= @p_cut_off_version
			   AND CUTOFF_TYPE			= @c_cutoff_TYPE
			   AND CUTOFF_YYYYMMDD		= @c_cutoff_yyyymmdd
			   AND DIVISION_ID			= '82'				
			-------------------------------------------------------------------------------------------------------------------------------------------

			/* [E20240508-000695] */
			DELETE A
			  FROM DM_PLN_MKT_FCST_C A
			 WHERE MEASURE IN ( 'RTF')
			   AND DIVISION_ID			= @p_division_id
			   AND VERSION_NO			= @p_cut_off_version
			   AND CUTOFF_TYPE			= @c_cutoff_TYPE
			   AND CUTOFF_YYYYMMDD		= @c_cutoff_yyyymmdd
			   AND DIVISION_ID			= '81'
			   AND DIVISION_ID IN ( SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y' )
			   AND SCM_SITE_ID IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y' )	
			   -------------------------------------------------------------------------------------------------------------------------------------------	
			   -- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (START) 
			   -------------------------------------------------------------------------------------------------------------------------------------------	
			   AND NOT EXISTS ( SELECT DISTINCT ITEM_ID 
								  FROM #T_RTF_EXCEPTION_ITEM B WITH(NOLOCK)
								 WHERE A.DIVISION_ID		= B.DIVISION_ID
								   AND A.PROJECT_CODE		= B.PROJECT_CODE
								   AND A.SCM_SITE_ID		= B.SCM_SITE_ID
								   AND A.ITEM_ID			= B.ITEM_ID
								   AND A.DOM_EXP			= B.DOM_EXP
								   AND A.FCST_TYPE			= B.FCST_TYPE
								   AND A.INCOTERMS			= B.INCOTERMS
								   AND A.MEASURE			= B.MEASURE
								   AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
								   AND A.YYYYMMDD		   >= @plan_start_yyyymmdd /*-- 당주월요일*/
								   AND A.VERSION_NO			= @P_CUT_OFF_VERSION )
			   -------------------------------------------------------------------------------------------------------------------------------------------	
			   -- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (END) 
			   -------------------------------------------------------------------------------------------------------------------------------------------		
			
			-------------------------------------------------------------------------------------------------------------------------------------------	
			/*	-- [PJ2025-50188] #T_MEASURE_MF_ALL 참고
				 . EE_FN 인 경우   ('VMI_In_Plan', 'AS_In_Plan', 'SS_LVL', 'SS_GAP', 'RTF_PR')
				 . EE_FN 아닌 경우 ('VMI_In_Plan', 'AS_In_Plan', 'SS_LVL', 'SS_GAP', 'RTF_PR', 'RTF_SYS_RP','RTF_SCP' )*/
			-------------------------------------------------------------------------------------------------------------------------------------------				
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260107-001287]_전극의 경우는 FCSTPRICE MGMT 화면에서 데이터를 저장한 데이터를 반영하기 때문에, 40사업부의 경우는 삭제하지 않도록 수정한다.(START)
			IF (@p_division_id = '40')
			BEGIN				
				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MF_C_EE_FN_MEASURE (정의된 MEASURE만 업데이트 함.)
				-- [E20260107-001287]_40 사업부 데이터를 삭제할때는 전극 데이터가 삭제되지 않도록 NOT IN 처리를 한다. (START)
				-------------------------------------------------------------------------------------------------------------------------------------------	
				DELETE A
				  FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
				 WHERE A.MEASURE IN (SELECT MEASURE FROM #T_MEASURE_MF_ALL WITH(NOLOCK))		
				   AND A.DIVISION_ID		= @p_division_id
				   AND A.VERSION_NO			= @p_cut_off_version
				   AND A.CUTOFF_TYPE		= @c_cutoff_TYPE
				   AND A.CUTOFF_YYYYMMDD	= @c_cutoff_yyyymmdd
				   AND A.ITEM_ID NOT IN ( SELECT K.ITEM_ID FROM SCM_MST_ITEM_SN K WITH(NOLOCK) 
										   WHERE K.DIVISION_ID = A.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y' AND K.DIVISION_ID = '40' )
				   -------------------------------------------------------------------------------------------------------------------------------------------	
				   -- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (START) 
				   -------------------------------------------------------------------------------------------------------------------------------------------	
				   AND NOT EXISTS ( SELECT DISTINCT ITEM_ID 
									  FROM #T_RTF_EXCEPTION_ITEM B WITH(NOLOCK)
									 WHERE A.DIVISION_ID	= B.DIVISION_ID
									   AND A.PROJECT_CODE	= B.PROJECT_CODE
									   AND A.END_CUSTOMER	= B.END_CUSTOMER
									   AND A.SCM_SITE_ID	= B.SCM_SITE_ID
									   AND A.ITEM_ID		= B.ITEM_ID
									   AND A.DOM_EXP		= B.DOM_EXP
									   AND A.FCST_TYPE		= B.FCST_TYPE
									   AND A.INCOTERMS		= B.INCOTERMS
									   AND A.MEASURE		= B.MEASURE
									   AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
									   AND ISNULL(A.CELL_PROD_SITE_ID, '-') = ISNULL(B.CELL_PROD_SITE_ID, '-') 
									   AND A.YYYYMMDD	   >= @plan_start_yyyymmdd /*-- 당주월요일*/
									   AND A.VERSION_NO		= @P_CUT_OFF_VERSION )
				   -------------------------------------------------------------------------------------------------------------------------------------------	
				   -- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (END) 
				   -------------------------------------------------------------------------------------------------------------------------------------------		
			END
			ELSE
			BEGIN
				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [E20260107-001287]_40 사업부 외의 다른 사업부는 원 로직과 동일하게 둔다. (START) 				
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MF_C_EE_FN_MEASURE (정의된 MEASURE만 업데이트 함.)
				-------------------------------------------------------------------------------------------------------------------------------------------	
				DELETE A
				  FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
				 WHERE MEASURE IN (SELECT MEASURE FROM #T_MEASURE_MF_ALL WITH(NOLOCK) )		
				   AND DIVISION_ID			= @p_division_id
				   AND VERSION_NO			= @p_cut_off_version
				   AND CUTOFF_TYPE			= @c_cutoff_TYPE
				   AND CUTOFF_YYYYMMDD		= @c_cutoff_yyyymmdd
				   -------------------------------------------------------------------------------------------------------------------------------------------	
				   -- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (START) 
				   -------------------------------------------------------------------------------------------------------------------------------------------	
				   AND NOT EXISTS ( SELECT DISTINCT ITEM_ID 
									  FROM #T_RTF_EXCEPTION_ITEM B WITH(NOLOCK)
									 WHERE A.DIVISION_ID	= B.DIVISION_ID
									   AND A.PROJECT_CODE	= B.PROJECT_CODE
									   AND A.SCM_SITE_ID	= B.SCM_SITE_ID
									   AND A.ITEM_ID		= B.ITEM_ID
									   AND A.DOM_EXP		= B.DOM_EXP
									   AND A.FCST_TYPE		= B.FCST_TYPE
									   AND A.INCOTERMS		= B.INCOTERMS
									   AND A.MEASURE		= B.MEASURE
									   AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
									   AND ISNULL(A.CELL_PROD_SITE_ID, '-') = ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260512-000502]_81 사업부도 FROM SITE ID를 관리하기때문에 해당 부분을 수정한다.
									  --AND CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(A.CELL_PROD_SITE_ID, '-') ELSE '-' END = ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260507-000749]_40 외에는 CELL_PROD_SITE_ID가 의미없는 값이므로 주석처리
									   AND A.YYYYMMDD	   >= @plan_start_yyyymmdd /*-- 당주월요일*/
									   AND A.VERSION_NO		= @P_CUT_OFF_VERSION )
				   -------------------------------------------------------------------------------------------------------------------------------------------	
				   -- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (END) 
				   -------------------------------------------------------------------------------------------------------------------------------------------
			END
			-- [E20260107-001287]_전극의 경우는 FCSTPRICE MGMT 화면에서 데이터를 저장한 데이터를 반영하기 때문에, 40사업부의 경우는 삭제하지 않도록 수정한다.(END)
			-------------------------------------------------------------------------------------------------------------------------------------------
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용				   
			DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
			 WHERE MEASURE IN ( 'RTF')
			   AND DIVISION_ID		= @p_division_id
			   AND VERSION_NO		= @p_cut_off_version
			   AND CUTOFF_TYPE		= @c_cutoff_TYPE
			   AND CUTOFF_YYYYMMDD	= @c_cutoff_yyyymmdd
			   AND DIVISION_ID		= '82'

			/* [E20240508-000695] */
			DELETE A
			  FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
			 WHERE MEASURE IN ( 'RTF')
			   AND DIVISION_ID		= @p_division_id
			   AND VERSION_NO		= @p_cut_off_version
			   AND CUTOFF_TYPE		= @c_cutoff_TYPE
			   AND CUTOFF_YYYYMMDD	= @c_cutoff_yyyymmdd
			   AND DIVISION_ID		= '81'
			   AND DIVISION_ID IN ( SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y' )
			   AND SCM_SITE_ID IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y' )	
			   -------------------------------------------------------------------------------------------------------------------------------------------	
			   -- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (START) 
			   -------------------------------------------------------------------------------------------------------------------------------------------	
			   AND NOT EXISTS ( SELECT DISTINCT ITEM_ID 
								  FROM #T_RTF_EXCEPTION_ITEM B WITH(NOLOCK)
								 WHERE A.DIVISION_ID							= B.DIVISION_ID
								   AND A.PROJECT_CODE							= B.PROJECT_CODE
								   AND A.END_CUSTOMER							= B.END_CUSTOMER
								   AND A.SCM_SITE_ID							= B.SCM_SITE_ID
								   AND A.ITEM_ID								= B.ITEM_ID
								   AND A.DOM_EXP								= B.DOM_EXP
								   AND A.FCST_TYPE								= B.FCST_TYPE
								   AND A.INCOTERMS								= B.INCOTERMS
								   AND A.MEASURE								= B.MEASURE
								   AND A.PLANT_SITE_ID							= B.PLANT_SITE_ID
								   AND ISNULL(A.CELL_PROD_SITE_ID, '-')			= ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260512-000502]
								   AND A.YYYYMMDD							   >= @plan_start_yyyymmdd /*-- 당주월요일*/
								   AND A.VERSION_NO								= @P_CUT_OFF_VERSION )
			   -------------------------------------------------------------------------------------------------------------------------------------------	
			   -- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (END) 
			   -------------------------------------------------------------------------------------------------------------------------------------------
			-- [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 (END) 
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [PJ2025-50017] 속도개선을 이유로 임시테이블에 SCP_PLN_RTF_ALLOCATION_V를 담아서 사용함.
			-- [PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_C_RTF_ALLOCATION 이름변경
			--INSERT INTO #T2_SCP_PLN_RTF_ALLOCATION_V
			-------------------------------------------------------------------------------------------------------------------------------------------	
			INSERT INTO #T_MF_C_RTF_ALLOCATION
			( MASTER_ID, PLAN_ID, OUT_VERSION_ID, DIVISION_ID, ORIGIN_DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE
			, SEQ, OPERATION_GROUP, ENG_DEMAND_ID, ITEM_ID, PROJECT_CODE, SALES_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE
			, DEMAND_TYPE, DUE_DATE, PLANT_SITE_ID, YYYYMMDD, ALLOCATION_QTY
			, DELIVERY_ORDER_ID, FROM_SITE, FROM_ITEM_ID, SCP_INCOTERMS, FROM_SITE_ID, CELL_PROD_SITE_ID )		--[PJ2025-50017] CELL_PROD_SITE_ID 추가
			SELECT MASTER_ID, PLAN_ID, OUT_VERSION_ID, DIVISION_ID, ORIGIN_DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE
				 , SEQ, OPERATION_GROUP, ENG_DEMAND_ID, ITEM_ID, PROJECT_CODE, SALES_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE
				 , DEMAND_TYPE, DUE_DATE, PLANT_SITE_ID, YYYYMMDD, ALLOCATION_QTY
				 , DELIVERY_ORDER_ID, FROM_SITE, FROM_ITEM_ID, SCP_INCOTERMS, FROM_SITE_ID, CELL_PROD_SITE_ID	--[PJ2025-50017] CELL_PROD_SITE_ID 추가
			  FROM SCP_PLN_RTF_ALLOCATION_V WITH(NOLOCK)
			 WHERE DIVISION_ID	= @p_division_id
			   AND PLAN_ID		= @c_plan_id
			   AND YYYYMMDD	   >= @plan_start_yyyymmdd
			 UNION ALL
			SELECT MASTER_ID, PLAN_ID, OUT_VERSION_ID, DIVISION_ID, ORIGIN_DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE
				 , SEQ, OPERATION_GROUP, ENG_DEMAND_ID, ITEM_ID, PROJECT_CODE, SALES_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE
				 , DEMAND_TYPE, DUE_DATE, PLANT_SITE_ID, YYYYMMDD, ALLOCATION_QTY
				 , DELIVERY_ORDER_ID, FROM_SITE, FROM_ITEM_ID, SCP_INCOTERMS, FROM_SITE_ID, CELL_PROD_SITE_ID	--[PJ2025-50017] CELL_PROD_SITE_ID 추가
			  FROM SCP_PLN_RTF_ALLOCATION_V WITH(NOLOCK)
			 WHERE DIVISION_ID		= 'EE'
			   AND ORIGIN_DIVISION_ID	= @p_division_id
			   AND PLAN_ID				= @c_plan_id_ee
			   AND YYYYMMDD			   >= @plan_start_yyyymmdd			

			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) 
			-------------------------------------------------------------------------------------------------------------------------------------------	
			DELETE A
			  FROM #T_MF_C_RTF_ALLOCATION A
			 INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
							   , ISNULL(CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
							FROM #T_RTF_EXCEPTION_ITEM 
						   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, ISNULL(CELL_PROD_SITE_ID, '-')) B
					 ON A.DIVISION_ID						= B.DIVISION_ID
					AND A.PROJECT_CODE						= B.PROJECT_CODE
					AND A.SALES_SITE_ID						= B.SCM_SITE_ID
					--[E20260812-001054]_FROM_ITEM_ID 기준으로 적재함으로 FROM_ITEM_ID 기준으로 변경(START)
					--AND A.ITEM_ID							= B.ITEM_ID --[E20260812-001054]_주석처리
					AND A.FROM_ITEM_ID						= B.ITEM_ID --[E20260812-001054]_주석처리
					--[E20260812-001054]_FROM_ITEM_ID 기준으로 적재함으로 FROM_ITEM_ID 기준으로 변경(END)
					AND A.DOM_EXP							= B.DOM_EXP
					AND A.FCST_TYPE							= B.FCST_TYPE
					AND A.INCOTERMS							= B.INCOTERMS
					AND A.PLANT_SITE_ID						= B.PLANT_SITE_ID
					AND ISNULL(A.CELL_PROD_SITE_ID, '-')	= ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260512-000502] 81도 해당 부분을 비교하도록 수정한다.
					--AND CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(A.CELL_PROD_SITE_ID, '-') ELSE '-' END = ISNULL(B.CELL_PROD_SITE_ID, '-')  --[E20260512-000502]_원소스 주석처리
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) 
			-------------------------------------------------------------------------------------------------------------------------------------------		
			   										  
			SELECT DISTINCT A.DIVISION_ID
				 , @p_cut_off_version				AS VERSION_NO
				 , @c_cutoff_TYPE					AS CUTOFF_TYPE
				 , @c_cutoff_yyyymmdd				AS CUTOFF_YYYYMMDD
				 , A.PROJECT_CODE
				 , A.SALES_SITE_ID					AS SCM_SITE_ID
				 , CASE WHEN ISNULL(A.FROM_ITEM_ID, '') = ''  /*--20240610 KCW3408 */ THEN A.ITEM_ID ELSE A.FROM_ITEM_ID END AS ITEM_ID
				 , A.DOM_EXP
				 , A.FCST_TYPE
				 , A.INCOTERMS
				 , CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ( '82', '40' ) THEN 'VMI_In_Plan'
						WHEN C.OPERATION_GROUP = 'W'							THEN 'AS_In_Plan'
						ELSE 'RTF_SCP'  END MEASURE --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
					--,PLANT_SITE_ID 
				 , CASE WHEN A.DIVISION_ID IN ( '82', '40' ) THEN '' ELSE A.PLANT_SITE_ID END PLANT_SITE_ID
				 , A.YYYYMMDD 
				 , SUM(A.ALLOCATION_QTY)			AS QTY
				 , 'SYSTEM'							AS CREATED_BY
				 , GETDATE()						AS CREATION_DATE
				 , 'SYSTEM'							AS LAST_UPDATED_BY
				 , GETDATE()						AS LAST_UPDATE_DATE
			  INTO #T2_MKT_FCST_INSERT  -- 20190709 KHSONG [CSR ID:4027463] 임시테이블에 넣고 MEASURE 추가할 용도임
			--FROM [dbo].[SCP_PLN_RTF_ALLOCATION_V] a WITH(NOLOCK)
			--FROM #T2_SCP_PLN_RTF_ALLOCATION_V a WITH(NOLOCK)				-- [PJ2025-50017] 소형 매출계획 동기화 개선
			-- [PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_C_RTF_ALLOCATION 이름변경
			  FROM #T_MF_C_RTF_ALLOCATION A WITH(NOLOCK)						
   			 INNER JOIN SCM_MST_SITE C WITH(NOLOCK)
					 ON A.DIVISION_ID	= C.DIVISION_ID      
					AND A.SALES_SITE_ID = C.SCM_SITE_ID
			 WHERE A.DIVISION_ID	= @p_division_id
			   AND A.PLAN_ID		= @c_plan_id
			   AND A.YYYYMMDD	   >= @plan_start_yyyymmdd
			 GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SALES_SITE_ID, CASE WHEN ISNULL(A.FROM_ITEM_ID,'') = '' THEN A.ITEM_ID  ELSE A.FROM_ITEM_ID  END
			        , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, CASE WHEN A.DIVISION_ID IN ('82','40') THEN '' ELSE A.PLANT_SITE_ID END, A.YYYYMMDD, C.VMI_YN, C.OPERATION_GROUP
			-- 상품인 건에 대해서는 RTF를 MKT FCST와 동일하게 생성 함.
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [C20210511-000221] 자동자 전극 RTF 적용 (자동차 전극 RTF 적용)(START)			
			 UNION ALL						
			SELECT DISTINCT A.ORIGIN_DIVISION_ID	AS DIVISION_ID
				 , @p_cut_off_version				AS VERSION_NO
				 , @c_cutoff_TYPE					AS CUTOFF_TYPE
				 , @c_cutoff_yyyymmdd				AS CUTOFF_YYYYMMDD
				 , A.PROJECT_CODE
				 , A.SALES_SITE_ID					AS SCM_SITE_ID
				 , CASE WHEN ISNULL(A.FROM_ITEM_ID,'') = '' /* --20240610 KCW3408*/ THEN A.ITEM_ID ELSE A.FROM_ITEM_ID END AS ITEM_ID
				 , A.DOM_EXP
				 , A.FCST_TYPE
				 , A.INCOTERMS
				 , CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ( '82', '40' ) THEN 'VMI_In_Plan'
						WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan' 
						ELSE 'RTF_SCP'  END MEASURE --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
				 --,PLANT_SITE_ID 
				 --[PJ2024-50611] 전극데이터 생성 시 ORIGIN_DIVISION_ID in ('82','40') 변경(82, 40 에서도 PLANT_SITE_ID가 생성되는 오류 보완)
				 --,CASE WHEN a.DIVISION_ID in ('82','40') THEN '' ELSE a.PLANT_SITE_ID END PLANT_SITE_ID
				 , CASE WHEN A.ORIGIN_DIVISION_ID IN ( '82', '40' ) THEN '' ELSE a.PLANT_SITE_ID END PLANT_SITE_ID 
				 , A.YYYYMMDD 
				 , SUM(A.ALLOCATION_QTY)			AS QTY
				 , 'SYSTEM'							AS CREATED_BY
				 , GETDATE()						AS CREATION_DATE
				 , 'SYSTEM'							AS LAST_UPDATED_BY
				 , GETDATE()						AS LAST_UPDATE_DATE
			--FROM [dbo].[SCP_PLN_RTF_ALLOCATION_V] a WITH(NOLOCK)
			--FROM #T2_SCP_PLN_RTF_ALLOCATION_V a WITH(NOLOCK)				-- [PJ2025-50017] 소형 매출계획 동기화 개선
			-- [PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_C_RTF_ALLOCATION 이름변경
			  FROM #T_MF_C_RTF_ALLOCATION A WITH(NOLOCK)				
   			 INNER JOIN SCM_MST_SITE C WITH(NOLOCK)
					 ON A.ORIGIN_DIVISION_ID	= C.DIVISION_ID      
					AND A.SALES_SITE_ID			= C.SCM_SITE_ID 
			 WHERE A.DIVISION_ID		= 'EE'
			 --and a.ORIGIN_DIVISION_ID	= '81'
			   AND A.ORIGIN_DIVISION_ID	= @p_division_id
			   AND A.PLAN_ID			= @c_plan_id_ee
			   AND A.YYYYMMDD		   >= @plan_start_yyyymmdd
			 GROUP BY A.ORIGIN_DIVISION_ID, A.PROJECT_CODE, A.SALES_SITE_ID, CASE WHEN ISNULL(A.FROM_ITEM_ID, '') = '' THEN A.ITEM_ID  ELSE A.FROM_ITEM_ID END
				   --[PJ2024-50611] 전극데이터 생성 시 ORIGIN_DIVISION_ID in ('82','40') 변경(82, 40 에서도 PLANT_SITE_ID가 생성되는 오류 보완)
				   --, a.DOM_EXP,a.FCST_TYPE, a.INCOTERMS, CASE WHEN a.DIVISION_ID in ('82','40')  THEN '' ELSE a.PLANT_SITE_ID END, a.YYYYMMDD,c.VMI_YN, C.OPERATION_GROUP			
					, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, CASE WHEN A.ORIGIN_DIVISION_ID IN ( '82', '40' ) THEN '' ELSE a.PLANT_SITE_ID END --[PJ2024-50611] 전극데이터 생성 시 ORIGIN_DIVISION_ID in ('82','40') 변경(82, 40 에서도 PLANT_SITE_ID가 생성되는 오류 보완)
					, A.YYYYMMDD, C.VMI_YN, C.OPERATION_GROUP, A.DIVISION_ID
			-- [C20210511-000221] 자동자 전극 RTF 적용 (END)		
			-------------------------------------------------------------------------------------------------------------------------------------------	
			 UNION ALL
			SELECT A.DIVISION_ID
				 , A.VERSION_NO
				 , A.CUTOFF_TYPE
				 , A.CUTOFF_YYYYMMDD
				 , A.PROJECT_CODE
				 , A.SCM_SITE_ID
				 , A.ITEM_ID
				 , A.DOM_EXP
				 , A.FCST_TYPE
				 , A.INCOTERMS
				 , CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ( '82', '40' ) THEN 'VMI_In_Plan' 
						WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
						ELSE 'RTF_SCP' END  --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
				 , A.PLANT_SITE_ID
				 , A.YYYYMMDD
				 , SUM(A.QTY)	AS QTY
				 , 'SYSTEM'		AS CREATED_BY
				 , GETDATE()	AS CREATION_DATE
				 , 'SYSTEM'		AS LAST_UPDATED_BY
				 , GETDATE()	AS LAST_UPDATE_DATE
			  FROM DM_PLN_MKT_FCST_C A WITH(NOLOCK)
   			 INNER JOIN DM_MST_ITEM_SINGLE_V B WITH(NOLOCK)
					 ON A.DIVISION_ID		= B.DIVISION_ID
					AND A.ITEM_ID			= B.ITEM_ID
   			 INNER JOIN SCM_MST_SITE C WITH(NOLOCK)
					 ON A.DIVISION_ID       = C.DIVISION_ID      
					AND A.SCM_SITE_ID       = C.SCM_SITE_ID
			 WHERE 1 = 1
			   AND A.DIVISION_ID			= @p_division_id
			   AND A.VERSION_NO				= @p_cut_off_version
			   AND A.CUTOFF_TYPE			= @c_cutoff_TYPE
			   AND A.CUTOFF_YYYYMMDD		= @c_cutoff_yyyymmdd
			   AND A.MEASURE				= CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ( '82', '40' ) THEN 'VMI_In_Req' 
												   WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
												   --ELSE 'MKT_FCST'  END -- VMI = 'Y'인경우에만 VMI_In_Req 'N'이면 MKT_FCST 사용 --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
												   ELSE @v_measure  END	 -- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
			   -- 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
			   -- [C20210511-000221] 상품인 경우에 RTF를 MKT_FCST와 동일하게 생성
			   AND ( B.ITEM_TYPE IN ( 'Q' , 'R' )) /*OR ( a.item_id in ( select k.item_id from scm_mst_item_sn k  WITH (NOLOCK) where k.division_id = a.division_id and k.SCP_OPERATION_GROUP = 'E'  )  )*/
			   --AND a.division_id IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895] DIVISION_ID 구분으로 추가
			 GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
					, CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ('82','40') THEN 'VMI_In_Plan' 
						   WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
						   ELSE 'RTF_SCP'  END --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
					, A.PLANT_SITE_ID, A.YYYYMMDD					
			 UNION ALL
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- RMA 처리 C20200518-000359 (START)
			SELECT A.DIVISION_ID
				 , A.VERSION_NO
				 , A.CUTOFF_TYPE
				 , A.CUTOFF_YYYYMMDD
				 , A.PROJECT_CODE
				 , A.SCM_SITE_ID
				 , A.ITEM_ID
				 , A.DOM_EXP
				 , A.FCST_TYPE
				 , A.INCOTERMS
				 , 'RTF_SCP'
				 , A.PLANT_SITE_ID
				 , A.YYYYMMDD
				 , A.QTY
				 , 'SYSTEM'  AS CREATED_BY
				 , GETDATE() AS CREATION_DATE
				 , 'SYSTEM'  AS LAST_UPDATED_BY
				 , GETDATE() AS LAST_UPDATE_DATE
			  FROM DM_PLN_MKT_FCST_C A WITH(NOLOCK)
			  --JOIN ( SELECT 'RTF_SCP' AS MEASURE
			  --		UNION ALL
			  --		SELECT 'RTF_SYS_RP' AS MEASURE ) B ON 1=1
			 WHERE 1 = 1
			   AND A.DIVISION_ID			= @p_division_id
			   AND A.VERSION_NO				= @p_cut_off_version
			   AND A.CUTOFF_TYPE			= @c_cutoff_TYPE
			   AND A.CUTOFF_YYYYMMDD		= @c_cutoff_yyyymmdd
			   --and  a.measure				= 'MKT_FCST'		
			   AND A.measure				= @v_measure		-- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
			   --AND a.division_id ='40'		[C20210705-000574] Google 반품(RMA) Sales Amount 조회 기능 요청 - ESS 82 사업부 포함을 위해 주석 처리 
			   AND A.FCST_TYPE = 'RMA'
			-- RMA 처리 C20200518-000359 (END)
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) 
			-------------------------------------------------------------------------------------------------------------------------------------------	
			DELETE A
			  FROM #T2_MKT_FCST_INSERT A
			 INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
							FROM #T_RTF_EXCEPTION_ITEM 
						   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID) B
					 ON A.DIVISION_ID						= B.DIVISION_ID
					AND A.PROJECT_CODE						= B.PROJECT_CODE
					AND A.SCM_SITE_ID						= B.SCM_SITE_ID
					AND A.ITEM_ID							= B.ITEM_ID
					AND A.DOM_EXP							= B.DOM_EXP
					AND A.FCST_TYPE							= B.FCST_TYPE
					AND A.INCOTERMS							= B.INCOTERMS
					AND A.PLANT_SITE_ID						= B.PLANT_SITE_ID
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) 
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 (START)
			SELECT DISTINCT A.DIVISION_ID 
				 , @p_cut_off_version		AS VERSION_NO
				 , @c_cutoff_TYPE			AS CUTOFF_TYPE
				 , @c_cutoff_yyyymmdd		AS CUTOFF_YYYYMMDD
				 , A.PROJECT_CODE
				 , A.SCM_SITE_ID
				 , A.ITEM_ID
				 , A.DOM_EXP
				 , A.FCST_TYPE
				 , A.INCOTERMS
				 , A.MEASURE  
				 , A.PLANT_SITE_ID
				 , A.CELL_PROD_SITE_ID								--[PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , MAX(A.FROM_SITE_ID)		AS FROM_SITE_ID			--[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
				 , A.YYYYMMDD 
				 , SUM(A.QTY)				AS QTY
				 , 'SYSTEM'					AS CREATED_BY
				 , GETDATE()				AS CREATION_DATE
				 , 'SYSTEM'					AS LAST_UPDATED_BY
				 , GETDATE()				AS LAST_UPDATE_DATE
			  INTO #T2_CFM_DEMAND_INSERT  -- 20190709 KHSONG [CSR ID:4027463] 임시테이블에 넣고 MEASURE 추가할 용도임
			  FROM ( SELECT DISTINCT A.DIVISION_ID
						  , A.PROJECT_CODE
						  , A.SALES_SITE_ID AS SCM_SITE_ID
						  , CASE WHEN ISNULL(A.FROM_ITEM_ID, '') = '' /*--20240610 KCW3408 */ THEN A.ITEM_ID ELSE A.FROM_ITEM_ID END AS ITEM_ID
						  , A.DOM_EXP
						  , A.FCST_TYPE
						  , A.INCOTERMS
						  , CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ( '82', '40' ) THEN 'VMI_In_Plan'
								 WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
								 ELSE 'RTF_SCP'  END MEASURE --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
						  --,PLANT_SITE_ID 
						  , CASE WHEN A.DIVISION_ID IN ('82','40') THEN '' ELSE A.PLANT_SITE_ID END PLANT_SITE_ID
						  , ISNULL(A.CELL_PROD_SITE_ID, '-')										AS CELL_PROD_SITE_ID				--[PJ2025-50017] CELL_PROD_SITE_ID 추가
						  , CASE WHEN ( A.DIVISION_ID IN ('40') AND ISNULL (A.CELL_PROD_SITE_ID, '-') = '-' ) THEN A.FROM_SITE_ID ELSE ISNULL (A.CELL_PROD_SITE_ID, '-') END AS FROM_SITE_ID	 --[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
						  , A.YYYYMMDD 
						  , SUM(A.ALLOCATION_QTY) AS QTY
					--FROM [SCP_PLN_RTF_ALLOCATION_V] a WITH(NOLOCK)
					--FROM #T2_SCP_PLN_RTF_ALLOCATION_V a WITH(NOLOCK)				-- [PJ2025-50017] 소형 매출계획 동기화 개선
					-- [PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_C_RTF_ALLOCATION 이름변경
					  FROM #T_MF_C_RTF_ALLOCATION A WITH(NOLOCK)				
   					 INNER JOIN SCM_MST_SITE C WITH(NOLOCK)
							 ON A.DIVISION_ID	= C.DIVISION_ID      
							AND A.SALES_SITE_ID	= C.SCM_SITE_ID
   					 WHERE A.DIVISION_ID	= @p_division_id
					   AND A.PLAN_ID		= @c_plan_id
					   AND A.YYYYMMDD	   >= @plan_start_yyyymmdd
					 GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SALES_SITE_ID, CASE WHEN ISNULL(A.FROM_ITEM_ID, '') = '' THEN A.ITEM_ID ELSE A.FROM_ITEM_ID END
						    , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, CASE WHEN A.DIVISION_ID IN ( '82', '40' ) THEN '' ELSE A.PLANT_SITE_ID END
						    , ISNULL(A.FROM_SITE_ID, '') --[PJ2024-50611] SCP FROM_SITE_ID 추가
						    , A.YYYYMMDD, C.VMI_YN, C.OPERATION_GROUP, ISNULL(A.CELL_PROD_SITE_ID, '-')	/*--[PJ2025-50017] CELL_PROD_SITE_ID 추가*/, A.FROM_SITE_ID ) A
				-- 상품인 건에 대해서는 RTF를 MKT FCST와 동일하게 생성 함.
			 GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [C20210511-000221] 자동자 전극 RTF 적용 (자동차 전극 RTF 적용) (START)			
			 UNION ALL						
			SELECT DISTINCT A.ORIGIN_DIVISION_ID	AS DIVISION_ID
				 , @p_cut_off_version				AS VERSION_NO
				 , @c_cutoff_TYPE					AS CUTOFF_TYPE
				 , @c_cutoff_yyyymmdd				AS CUTOFF_YYYYMMDD
				 , A.PROJECT_CODE
				 , A.SALES_SITE_ID AS SCM_SITE_ID
				 , CASE WHEN ISNULL(A.FROM_ITEM_ID, '') = '' /*--20240610 KCW3408 */ THEN A.ITEM_ID ELSE A.FROM_ITEM_ID END AS ITEM_ID
				 , A.DOM_EXP
				 , A.FCST_TYPE
				 , A.INCOTERMS
				 , CASE WHEN C.VMI_YN = 'Y' AND a.DIVISION_ID IN ( '82', '40' ) THEN 'VMI_In_Plan'
						WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan' 
						ELSE 'RTF_SCP'  END MEASURE --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
				 --,PLANT_SITE_ID 
				 --[PJ2024-50611] 전극데이터 생성 시 ORIGIN_DIVISION_ID in ('82','40') 변경(82, 40 에서도 PLANT_SITE_ID가 생성되는 오류 보완)
				 --,CASE WHEN a.DIVISION_ID in ('82','40') THEN '' ELSE a.PLANT_SITE_ID END PLANT_SITE_ID
				 , CASE WHEN A.ORIGIN_DIVISION_ID IN ( '82', '40' ) THEN '' ELSE A.PLANT_SITE_ID END PLANT_SITE_ID 
				 , ISNULL(A.CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID					--[PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , CASE WHEN (A.ORIGIN_DIVISION_ID IN ('40') AND ISNULL (A.CELL_PROD_SITE_ID, '-') = '-' ) THEN A.FROM_SITE_ID ELSE ISNULL (A.CELL_PROD_SITE_ID, '-') END AS FROM_SITE_ID	 --[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
				 , A.YYYYMMDD 
				 , SUM(A.ALLOCATION_QTY)			AS QTY
				 , 'SYSTEM'							AS CREATED_BY
				 , GETDATE()						AS CREATION_DATE
				 , 'SYSTEM'							AS LAST_UPDATED_BY
				 , GETDATE()						AS LAST_UPDATE_DATE
			--FROM [SCP_PLN_RTF_ALLOCATION_V] a WITH(NOLOCK)
			--FROM #T2_SCP_PLN_RTF_ALLOCATION_V a WITH(NOLOCK)				-- [PJ2025-50017] 소형 매출계획 동기화 개선
			-- [PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_C_RTF_ALLOCATION 이름변경
			  FROM #T_MF_C_RTF_ALLOCATION A WITH(NOLOCK)				
   			 INNER JOIN SCM_MST_SITE C WITH(NOLOCK)
					 ON A.ORIGIN_DIVISION_ID	= C.DIVISION_ID      
					AND A.SALES_SITE_ID			= C.SCM_SITE_ID 
			 WHERE A.DIVISION_ID = 'EE'
			 --and a.ORIGIN_DIVISION_ID	= '81'
			   AND A.ORIGIN_DIVISION_ID			= @p_division_id
			   AND A.PLAN_ID					= @c_plan_id_ee
			   AND A.YYYYMMDD				   >= @plan_start_yyyymmdd
			 GROUP BY A.ORIGIN_DIVISION_ID , A.PROJECT_CODE, A.SALES_SITE_ID, CASE WHEN ISNULL(A.FROM_ITEM_ID, '') = '' THEN A.ITEM_ID  ELSE A.FROM_ITEM_ID  END
				      --[PJ2024-50611] 전극데이터 생성 시 ORIGIN_DIVISION_ID in ('82','40') 변경(82, 40 에서도 PLANT_SITE_ID가 생성되는 오류 보완)
				      --, a.DOM_EXP,a.FCST_TYPE, a.INCOTERMS, CASE WHEN a.DIVISION_ID in ('82','40')  THEN '' ELSE a.PLANT_SITE_ID END, a.YYYYMMDD,c.VMI_YN, C.OPERATION_GROUP			
				    , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, CASE WHEN A.ORIGIN_DIVISION_ID IN ('82','40') THEN '' ELSE A.PLANT_SITE_ID END	--[PJ2024-50611] 전극데이터 생성 시 ORIGIN_DIVISION_ID in ('82','40') 변경(82, 40 에서도 PLANT_SITE_ID가 생성되는 오류 보완)
				    , ISNULL(A.CELL_PROD_SITE_ID, '-') /*--[PJ2025-50017] CELL_PROD_SITE_ID 추가*/, A.FROM_SITE_ID, A.YYYYMMDD, C.VMI_YN, C.OPERATION_GROUP, A.DIVISION_ID
			-- [C20210511-000221] 자동자 전극 RTF 적용 (자동차 전극 RTF 적용) (END)		
			-------------------------------------------------------------------------------------------------------------------------------------------	
			 UNION ALL						
			SELECT A.DIVISION_ID
				 , A.VERSION_NO
				 , A.CUTOFF_TYPE
				 , A.CUTOFF_YYYYMMDD
				 , A.PROJECT_CODE
				 , A.SCM_SITE_ID
				 , A.ITEM_ID
				 , A.DOM_EXP
				 , A.FCST_TYPE
				 , A.INCOTERMS
				 , CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ('82','40') THEN 'VMI_In_Plan' 
						WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
						ELSE 'RTF_SCP' END  --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
				 , A.PLANT_SITE_ID
				 , '-'						AS CELL_PROD_SITE_ID	--[PJ2025-50017] ITEM_TYPE IN (Q,R)의 경우 DM_PLN_MKT_FCST_C에서 데이터 수집
				 --,A.CELL_PROD_SITE_ID								--[PJ2025-50017] SCP CELL_PROD_SITE_ID 추가
				 , MAX(A.ATTRIBUTE2)		AS FROM_SITE_ID			--[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
				 , A.YYYYMMDD
				 , SUM(A.QTY)				AS QTY
				 , 'SYSTEM'					AS CREATED_BY
				 , GETDATE()				AS CREATION_DATE
				 , 'SYSTEM'					AS LAST_UPDATED_BY
				 , GETDATE()				AS LAST_UPDATE_DATE
				 /* 2025.05.19 CELL_PROD_SITE_ID 추출을 위해 DM_PLN_MKT_FCST_C ==> DM_PLN_CFM_MKT_DEMAND_PLAN_C 로 변경 */
				 /* 2025.06.24 82사업부의 경우 DM_PLN_CFM_MKT_DEMAND_PLAN_C(MKT_FCST) 데이터가 없기 때문에 DM_PLN_MKT_FCST_C 로 원복*/
				 /* 2025.06.24 40사업부의 경우 Q/R(상품/구매품)인 아이템의 경우 CELL_PROD_SITE_ID가 없는 아이템이므로 '-'로 처리해도 무방. */
				 /* 2025.06.24 종합적으로 점검결과 CELL_PROD_SITE_ID는 '-'로 통일할 수 있음. ==> DM_PLN_MKT_FCST_C로 사용하기로 결정함. ITEM_TYPE IN (Q,R)의 경우 DM_PLN_MKT_FCST_C에서 데이터 수집*/
			  FROM DM_PLN_MKT_FCST_C A WITH(NOLOCK)						
			  --from DBO.DM_PLN_CFM_MKT_DEMAND_PLAN_C a WITH(NOLOCK)			-- [PJ2025-50017] 40사업부는 DM_PLN_MKT_FCST_C ==> DM_PLN_CFM_MKT_DEMAND_PLAN_C 적용
   			 INNER JOIN DM_MST_ITEM_SINGLE_V B WITH(NOLOCK)
					 ON A.DIVISION_ID		= B.DIVISION_ID
					AND A.ITEM_ID			= B.ITEM_ID
   			 INNER JOIN SCM_MST_SITE C WITH(NOLOCK)
					 ON A.DIVISION_ID       = C.DIVISION_ID      
					AND A.SCM_SITE_ID       = C.SCM_SITE_ID
			 WHERE 1 = 1
			   AND A.DIVISION_ID		= @p_division_id
			   AND A.VERSION_NO			= @p_cut_off_version
			   AND A.CUTOFF_TYPE		= @c_cutoff_TYPE
			   AND A.CUTOFF_YYYYMMDD	= @c_cutoff_yyyymmdd
			   AND A.MEASURE			= CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ( '82', '40' ) THEN 'VMI_In_Req' 
											   WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
											   --ELSE 'MKT_FCST'  END -- VMI = 'Y'인경우에만 VMI_In_Req 'N'이면 MKT_FCST 사용 --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
											   ELSE @v_measure END	-- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
			   -- 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
			   -- [C20210511-000221] 상품인 경우에 RTF를 MKT_FCST와 동일하게 생성
			   AND ( B.ITEM_TYPE IN ( 'Q' , 'R' )) /*OR ( a.item_id in ( select k.item_id from scm_mst_item_sn k  WITH (NOLOCK) where k.division_id = a.division_id and k.SCP_OPERATION_GROUP = 'E'  )  )*/
					--AND a.division_id IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895] DIVISION_ID 구분으로 추가
			 GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
					, CASE WHEN C.VMI_YN = 'Y' AND A.DIVISION_ID IN ('82','40') THEN 'VMI_In_Plan' 
						   WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
						   ELSE 'RTF_SCP'  END --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
					, A.PLANT_SITE_ID, A.YYYYMMDD --,A.CELL_PROD_SITE_ID -- [PJ2025-50017] 2025.05.14 추가 ==> 2025.06.24 ITEM_TYPE IN (Q,R)의 경우 DM_PLN_MKT_FCST_C에서 데이터 수집
			 UNION ALL		
			-------------------------------------------------------------------------------------------------------------------------------------------	
				-- RMA 처리 C20200518-000359
			SELECT A.DIVISION_ID
				 , A.VERSION_NO
				 , A.CUTOFF_TYPE
				 , A.CUTOFF_YYYYMMDD
				 , A.PROJECT_CODE
				 , A.SCM_SITE_ID
				 , A.ITEM_ID
				 , A.DOM_EXP
				 , A.FCST_TYPE
				 , A.INCOTERMS
				 , 'RTF_SCP'
				 , A.PLANT_SITE_ID
				 , A.CELL_PROD_SITE_ID								--[PJ2025-50017] SCP CELL_PROD_SITE_ID 추가
				 , MAX(A.ATTRIBUTE2)			AS FROM_SITE_ID		--[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
				 , A.YYYYMMDD
				 , SUM(A.QTY)					AS QTY
				 , 'SYSTEM'						AS CREATED_BY
				 , GETDATE()					AS CREATION_DATE
				 , 'SYSTEM'						AS LAST_UPDATED_BY
				 , GETDATE()					AS LAST_UPDATE_DATE
			  FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A WITH(NOLOCK)				-- [PJ2025-50017] 40사업부는 DM_PLN_MKT_FCST_C ==> DM_PLN_CFM_MKT_DEMAND_PLAN_C 적용
			  --JOIN ( SELECT 'RTF_SCP' AS MEASURE
			  --		UNION ALL
			  --		SELECT 'RTF_SYS_RP' AS MEASURE ) B ON 1=1
			 WHERE 1 = 1
			   AND A.DIVISION_ID		= @p_division_id
			   AND A.VERSION_NO			= @p_cut_off_version
			   AND A.CUTOFF_TYPE		= @c_cutoff_TYPE
			   AND A.CUTOFF_YYYYMMDD	= @c_cutoff_yyyymmdd
			   --and  a.measure			= 'MKT_FCST'			
			   AND A.MEASURE			= @v_measure			-- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
			   --AND a.division_id ='40'		[C20210705-000574] Google 반품(RMA) Sales Amount 조회 기능 요청 - ESS 82 사업부 포함을 위해 주석 처리 
			   AND A.FCST_TYPE = 'RMA'
			 GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
					, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID	/*--[PJ2025-50017] SCP CELL_PROD_SITE_ID 추가*/, A.YYYYMMDD
			--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 (END)
			-------------------------------------------------------------------------------------------------------------------------------------------
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) 
			-------------------------------------------------------------------------------------------------------------------------------------------	
			DELETE A
			  FROM #T2_CFM_DEMAND_INSERT A
			 INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
							   , ISNULL(CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
							FROM #T_RTF_EXCEPTION_ITEM 
						   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, ISNULL(CELL_PROD_SITE_ID, '-')) B
					 ON A.DIVISION_ID						= B.DIVISION_ID
					AND A.PROJECT_CODE						= B.PROJECT_CODE
					AND A.SCM_SITE_ID						= B.SCM_SITE_ID
					AND A.ITEM_ID							= B.ITEM_ID
					AND A.DOM_EXP							= B.DOM_EXP
					AND A.FCST_TYPE							= B.FCST_TYPE
					AND A.INCOTERMS							= B.INCOTERMS
					AND A.PLANT_SITE_ID						= B.PLANT_SITE_ID 
					AND ISNULL(A.CELL_PROD_SITE_ID, '-')	= ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260512-000502] 81도 해당 부분을 비교하도록 수정한다.			
					--AND CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(A.CELL_PROD_SITE_ID, '-') ELSE '-' END = ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260512-000502] 원소스 주석처리
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) 
			-------------------------------------------------------------------------------------------------------------------------------------------		
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [C20210323-000456] ESS 판매법인의 VMI_IN_PLAN 에 대해서 5영업일 뒤로 미뤄줌
			UPDATE A
			   SET YYYYMMDD = DBO.FN_GET_BIZ_DAY(A.YYYYMMDD, B.LT_CNT)
			  FROM #T2_MKT_FCST_INSERT A
			  JOIN ( SELECT SEGMENT1 AS SCM_SITE_ID
						  , SEGMENT2 AS LT_CNT
					   FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
					  WHERE LOOKUP_TYPE = 'ESS_SALES_PLANT_LT'
						AND VALID_YN	= 'Y'
						AND TRY_CAST(SEGMENT2 AS INT) > 0 ) B ON A.SCM_SITE_ID = B.SCM_SITE_ID
			 WHERE A.DIVISION_ID	= '82'
			   AND A.MEASURE		= 'VMI_In_Plan'			   	
			-------------------------------------------------------------------------------------------------------------------------------------------
			-- SAFETY STOCK LEVEL, GAP 메저 처리	
			-------------------------------------------------------------------------------------------------------------------------------------------
			IF @P_division_id LIKE N'81%'
			BEGIN				
				-- TO_SITE, ITEM_ID 기준으로 정렬한다.
				INSERT INTO #T_SSLVL ( DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE, INCOTERMS, PLANT_SITE_ID, DOM_EXP )
				SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.PROJECT_CODE, A.INCOTERMS, A.PLANT_SITE_ID, A.DOM_EXP
				  FROM ( SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.PROJECT_CODE, A.INCOTERMS, A.PLANT_SITE_ID, A.DOM_EXP
							  , ROW_NUMBER() OVER ( PARTITION BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID 
												    ORDER BY A.PROJECT_CODE, A.INCOTERMS, A.PLANT_SITE_ID, A.DOM_EXP ) AS ROW_NUM
						   FROM ( SELECT DISTINCT A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.PROJECT_CODE, A.INCOTERMS, A.PLANT_SITE_ID, A.DOM_EXP
									FROM DM_PLN_MKT_FCST_C A WITH(NOLOCK)
								   WHERE A.YYYYMMDD >= @plan_start_yyyymmdd
								   --AND A.MEASURE IN ( 'MKT_FCST', 'RTF_SYS_RP', 'VMI_IN_REQ', 'AS_IN_REQ', 'BNP_IN' )			
									 AND A.MEASURE IN ( @v_measure, 'RTF_SYS_RP', 'VMI_IN_REQ', 'AS_IN_REQ', 'BNP_IN' )			-- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
									 AND A.DIVISION_ID = @p_division_id
									 AND A.VERSION_NO = @p_cut_off_version ) A
						) A
				  WHERE ROW_NUM = 1
				  
				DECLARE @V_STOCK_SEQ INT 
				SELECT @V_STOCK_SEQ = MAX(SEQ)
				  FROM SCP_ANL_PSI_GLOBAL_V WITH(NOLOCK) 
				 WHERE DIVISION_ID			= @p_division_id
				   AND PLAN_START_YYYYMMDD	= @plan_start_yyyymmdd
				   AND PLAN_TYPE			= 'FN'

				INSERT INTO #T2_MKT_FCST_INSERT 
				( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
				, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
				, QTY
				, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
				SELECT A.DIVISION_ID, @p_cut_off_version AS VERSION_NO, @c_cutoff_TYPE AS CUTOFF_TYPE, @c_cutoff_yyyymmdd AS CUTOFF_YYYYMMDD
					 , A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, 'MPS' AS FCST_TYPE, A.INCOTERMS, C.MEASURE, A.PLANT_SITE_ID, B.YYYYMMDD
					 , CASE WHEN C.MEASURE = 'SS_LVL' THEN B.SAFETY_STOCK ELSE B.GAP END AS QTY
					 , 'SYSTEM' AS CREATED_BY, GETDATE() AS CREATION_DATE, 'SYSTEM' AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
				  FROM #T_SSLVL A
				  JOIN SCP_ANL_PSI_GLOBAL_V B WITH(NOLOCK)
					ON A.DIVISION_ID			= B.DIVISION_ID 
				   AND A.SCM_SITE_ID			= B.TO_SITE 
				   AND A.ITEM_ID				= B.ITEM_ID
				   AND B.PLAN_START_YYYYMMDD	= @plan_start_yyyymmdd
				   AND B.PLAN_TYPE				= 'FN'
				   AND B.SEQ					= @V_STOCK_SEQ
				  JOIN ( SELECT 'SS_LVL' AS MEASURE
						  UNION ALL
						 SELECT 'SS_GAP' AS MEASURE	) C ON 1=1
				 WHERE A.DIVISION_ID = @p_division_id
			END
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) 
			-------------------------------------------------------------------------------------------------------------------------------------------	
			DELETE A
			  FROM #T2_MKT_FCST_INSERT A
			 INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
							FROM #T_RTF_EXCEPTION_ITEM 
						   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID) B
					 ON A.DIVISION_ID						= B.DIVISION_ID
					AND A.PROJECT_CODE						= B.PROJECT_CODE
					AND A.SCM_SITE_ID						= B.SCM_SITE_ID
					AND A.ITEM_ID							= B.ITEM_ID
					AND A.DOM_EXP							= B.DOM_EXP
					AND A.FCST_TYPE							= B.FCST_TYPE
					AND A.INCOTERMS							= B.INCOTERMS
					AND A.PLANT_SITE_ID						= B.PLANT_SITE_ID
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) 
			-------------------------------------------------------------------------------------------------------------------------------------------				
			-------------------------------------------------------------------------------------------------------------------------------------------
			--IF (@p_division_id = '40' AND @c_ee_40_fn_cnt > 0)  -- [PJ2025-50017] 현재 수행되는 기준이 EE_FN일 경우 RTF_SYS_RP/VMI_IN_PLAN/AS_IN_PLAN는 업데이트 안함. (RTF_PR만 업데이트 처리) ==> [PJ2025-50188] VMI_IN_PLAN/AS_IN_PLAN 업데이트 하는 것으로 변경
			IF (@p_division_id = '40' AND @c_ee_fn_flag = 'Y')  -- [PJ2025-50017] 현재 수행되는 기준이 EE_FN일 경우 RTF_SYS_RP/VMI_IN_PLAN/AS_IN_PLAN는 업데이트 안함. (RTF_PR만 업데이트 처리) ==> [PJ2025-50188] VMI_IN_PLAN/AS_IN_PLAN 업데이트 하는 것으로 변경
			BEGIN
				-------------------------------------------------------------------------------------------------------------------------------------------		
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_VMI_RTF - NOT IN 구문에서 사용 (START)
				-------------------------------------------------------------------------------------------------------------------------------------------	
				INSERT INTO #T_MEASURE_VMI_RTF		
				SELECT 'VMI_In_Plan'	
				 UNION ALL
				SELECT 'AS_In_Plan'		
				 UNION ALL
				SELECT 'RTF'			
				 UNION ALL
				SELECT 'RTF_SCP'		
				 UNION ALL
				SELECT 'RTF_SYS_RP'		
				-------------------------------------------------------------------------------------------------------------------------------------------		
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_VMI_RTF - NOT IN 구문에서 사용 (END)
				-------------------------------------------------------------------------------------------------------------------------------------------					
				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_RTF - 생성할 RTF 시리즈 정의 (START)
				-------------------------------------------------------------------------------------------------------------------------------------------	
				INSERT INTO #T_MEASURE_RTF		
				SELECT 'RTF_PR'					-- [PJ2025-50188] 'RTF_PR'만 생성함.
				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_RTF - 생성할 RTF 시리즈 정의 (END) 
				-------------------------------------------------------------------------------------------------------------------------------------------	
			END
			ELSE
			BEGIN
				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_VMI_RTF - NOT IN 구문에서 사용 (START)
				-------------------------------------------------------------------------------------------------------------------------------------------	
				INSERT INTO #T_MEASURE_VMI_RTF		
				SELECT 'VMI_In_Plan'
				 UNION ALL
				SELECT 'AS_In_Plan'		
				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_VMI_RTF - NOT IN 구문에서 사용 (END)
				-------------------------------------------------------------------------------------------------------------------------------------------					
				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_RTF - 생성할 RTF 시리즈 정의 (START)
				-------------------------------------------------------------------------------------------------------------------------------------------	
				INSERT INTO #T_MEASURE_RTF		
				SELECT 'RTF_PR'		
				 UNION ALL
				SELECT 'RTF_SYS_RP'						-- [PJ2025-50188] 'RTF_SYS_RP'까지 포함.
				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_RTF - 생성할 RTF 시리즈 정의 (END)
				-------------------------------------------------------------------------------------------------------------------------------------------	
			END
			
			-------------------------------------------------------------------------------------------------------------------------------------------	
			/*	-- [PJ2025-50188] #T_MEASURE_VMI_RTF 참고
				 . EE_FN 인 경우   ('VMI_In_Plan', 'AS_In_Plan', 'RTF', 'RTF_SCP', 'RTF_SYS_RP')
				 . EE_FN 아닌 경우 ('VMI_In_Plan', 'AS_In_Plan')	*/
			/*	-- [PJ2025-50188] ##T_MEASURE_RTF 참고
				 . EE_FN 인 경우   ('RTF')
				 . EE_FN 아닌 경우 ('RTF', 'RTF_SYS_RP')	*/
			-------------------------------------------------------------------------------------------------------------------------------------------	
			INSERT INTO DM_PLN_MKT_FCST_C
			( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
			, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
			, LAST_UPDATED_BY, LAST_UPDATE_DATE )
			SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
				 , MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
				 , LAST_UPDATED_BY, LAST_UPDATE_DATE
			  FROM #T2_MKT_FCST_INSERT A	WITH(NOLOCK)
			 WHERE DIVISION_ID = @p_division_id
			   AND MEASURE NOT IN ( SELECT MEASURE FROM #T_MEASURE_VMI_RTF WITH(NOLOCK))		-- [PJ2025-50188] EE_FN 분기 로직 통합처리
			 UNION ALL
			SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
				 , MEASURE, PLANT_SITE_ID, YYYYMMDD, SUM(QTY) AS QTY, MAX(CREATED_BY) AS CREATED_BY, MAX(CREATION_DATE) AS CREATION_DATE
				 , MAX(LAST_UPDATED_BY) AS LAST_UPDATED_BY, MAX(LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
			  FROM #T2_MKT_FCST_INSERT	WITH(NOLOCK)
			 WHERE DIVISION_ID	= @p_division_id
			   AND MEASURE IN ('VMI_In_Plan', 'AS_In_Plan')	
			 GROUP BY DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
					, MEASURE, PLANT_SITE_ID, YYYYMMDD
			 UNION ALL
			SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
				 , B.MEASURE /*-- [PJ2025-50188] EE_FN 분기 로직 통합처리. #T_MEASURE_RTF 에서 정의된 모든 MEASURE 생성*/
				 , A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY, A.CREATED_BY, A.CREATION_DATE
				 , A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
			  FROM #T2_MKT_FCST_INSERT A WITH(NOLOCK)
			 INNER JOIN ( SELECT MEASURE FROM #T_MEASURE_RTF WITH(NOLOCK)) B
					 ON	1 = 1		-- [PJ2025-50188] EE_FN 분기 로직 통합처리. #T_MEASURE_RTF 에서 정의된 MEASURE 전체를 동일하게 생성하기 위함.
			 WHERE A.MEASURE		= 'RTF_SCP'  -- 20190709 KHSONG [CSR ID:4027463] MEASURE 추가 INSERT 
			   AND A.DIVISION_ID	= @p_division_id		
			 UNION ALL--[C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용
			SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
				 , 'RTF' AS MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
				 , LAST_UPDATED_BY, LAST_UPDATE_DATE
			  FROM #T2_MKT_FCST_INSERT WITH(NOLOCK)
			 WHERE MEASURE = 'RTF_SCP'
			   AND DIVISION_ID		= @p_division_id		
			   AND DIVISION_ID		= '82'

			-------------------------------------------------------------------------------------------------------------------------------------------	
			/*	-- [PJ2025-50188] #T_MEASURE_VMI_RTF 참고
				 . EE_FN 인 경우   ('VMI_In_Plan', 'AS_In_Plan', 'RTF', 'RTF_SCP', 'RTF_SYS_RP')
				 . EE_FN 아닌 경우 ('VMI_In_Plan', 'AS_In_Plan')	*/
			/*	-- [PJ2025-50188] ##T_MEASURE_RTF 참고
				 . EE_FN 인 경우   ('RTF')
				 . EE_FN 아닌 경우 ('RTF', 'RTF_SYS_RP')	*/				
				 
			INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
			( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
			, END_CUSTOMER
			, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
			, MEASURE
			, PLANT_SITE_ID, CELL_PROD_SITE_ID				--[PJ2025-50017] CELL_PROD_SITE_ID 추가
			, ATTRIBUTE2 /*--[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)*/
			, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
			SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
				 , CASE WHEN DIVISION_ID = '40' THEN PROJECT_CODE ELSE '' END AS END_CUSTOMER
				 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
				 , MEASURE
				 , PLANT_SITE_ID, CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID	--[PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , CASE WHEN DIVISION_ID = '40' THEN FROM_SITE_ID ELSE NULL	END	AS ATTRIBUTE2 --[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
				 , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
			  FROM #T2_CFM_DEMAND_INSERT A WITH(NOLOCK)
			 WHERE DIVISION_ID = @p_division_id
			   AND MEASURE NOT IN ( SELECT MEASURE FROM #T_MEASURE_VMI_RTF WITH(NOLOCK))				-- [PJ2025-50188] EE_FN 분기 로직 통합처리				
			 UNION ALL
			SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE
				 , CASE WHEN DIVISION_ID = '40' THEN PROJECT_CODE ELSE '' END AS END_CUSTOMER
				 , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
				 , MEASURE
				 , PLANT_SITE_ID, CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID	--[PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , CASE WHEN DIVISION_ID = '40' THEN MAX(FROM_SITE_ID) ELSE NULL END AS ATTRIBUTE2		--[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
				 , YYYYMMDD, SUM(QTY) AS QTY, MAX(CREATED_BY), MAX(CREATION_DATE), MAX(LAST_UPDATED_BY), MAX(LAST_UPDATE_DATE)
			  FROM #T2_CFM_DEMAND_INSERT WITH(NOLOCK)
			 WHERE DIVISION_ID = @p_division_id
			   AND MEASURE IN ('VMI_In_Plan', 'AS_In_Plan')	
			 GROUP BY DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					, CELL_PROD_SITE_ID	/*--[PJ2025-50017] CELL_PROD_SITE_ID 추가*/, YYYYMMDD
			 UNION ALL
			SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE
				 , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE '' END AS END_CUSTOMER
				 , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS --,'RTF_PR' AS MEASURE,PLANT_SITE_ID
				 , B.MEASURE					-- [PJ2025-50188] EE_FN 분기 로직 통합처리. #T_MEASURE_RTF 에서 정의된 모든 MEASURE 생성
				 , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID	--[PJ2025-50017] CELL_PROD_SITE_ID 추가
				 , CASE WHEN A.DIVISION_ID = '40' THEN A.FROM_SITE_ID ELSE NULL	END AS ATTRIBUTE2 --[PJ2025-50017] BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
				 , A.YYYYMMDD, A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
			  FROM #T2_CFM_DEMAND_INSERT A	WITH(NOLOCK)
			 INNER JOIN ( SELECT MEASURE FROM #T_MEASURE_RTF WITH(NOLOCK)) B
					 ON	1 = 1		-- [PJ2025-50188] EE_FN 분기 로직 통합처리. #T_MEASURE_RTF 에서 정의된 MEASURE 전체를 동일하게 생성하기 위함.
			 WHERE A.MEASURE			= 'RTF_SCP' 
			   AND A.DIVISION_ID		= @p_division_id			
			;	
			--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 (END)
			-------------------------------------------------------------------------------------------------------------------------------------------	

			/* ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
			--PRINT N'로직적용-E20240508-000695';
			[E20240508-000695] Corvus/Siemens사 자동차사업부 RTF 산출 시 동기화 반영 요청
			■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ */

			IF (@p_division_id = N'81') --20240530: MKT_FCST.DIVISION_ID = 82번 RTF바라보고 처리,  @p_division_id = N'82'일경우 (MKT_FCST_C) 보고처리
			BEGIN 	
				WITH #TEMP_MKT_PLANT_ID_81_MAX_DATE AS 
				( /* 81번만 PLAN_SITE_ID 정보를 사용하고있으므로 DP일자 구간의 MAX(PLAN_ID)사용하기위해 처리 */
				  SELECT T1.*
					FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
								, ROW_NUMBER() OVER( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS 
													 ORDER BY YYYYMMDD DESC) AS ROWNUM
							 FROM DM_PLN_MKT_FCST WITH(NOLOCK) 
							WHERE DIVISION_ID = '81'
							--AND MEASURE     = 'MKT_FCST'			
							  AND MEASURE     = @v_measure			-- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
							  AND SCM_SITE_ID IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
							  AND YYYYMMDD   >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  /*--계획구간에서 정보 추출 */ ) T1
					WHERE 1 = 1
					  AND ROWNUM = 1 /* 계획구간 MKT FCST DP입력 대상 MAX(PLANT_ID) 추출 */	) 
				, #TEMP_MKT_PLANT_ID_81 AS 
				( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					FROM DM_PLN_MKT_FCST WITH(NOLOCK) 
				   WHERE DIVISION_ID = '81'
					--AND MEASURE     = 'MKT_FCST'			
					 AND MEASURE     = @v_measure			-- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
					 AND SCM_SITE_ID IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
					 AND YYYYMMDD   >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --계획구간에서 정보 추출 
				   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID 				) 
				, #TEMP_RTF_DATA_82 AS (
					SELECT F.[DIVISION_ID]		,F.[PROJECT_CODE]		,F.[SCM_SITE_ID]		,F.[ITEM_ID]		,F.[DOM_EXP]		,F.[FCST_TYPE]
							,F.[INCOTERMS] 		,F.[MEASURE]   		    ,F.[PLANT_SITE_ID]		,F.[YYYYMMDD]		,F.[QTY]		--,F.[CREATED_BY]
						--,F.[CREATION_DATE]	,F.[LAST_UPDATED_BY]	,F.[LAST_UPDATE_DATE]
						--,F.[ATTRIBUTE1]		,F.[ATTRIBUTE2]		,F.[ATTRIBUTE3]		,F.[ATTRIBUTE4]		,F.[ATTRIBUTE5]		,F.[ATTRIBUTE6]
						--,F.[ATTRIBUTE7]		,F.[ATTRIBUTE8]		,F.[ATTRIBUTE9]		,F.[ATTRIBUTE10]
					FROM	[dbo].[DM_PLN_MKT_FCST] F  WITH  (NOLOCK)
					INNER JOIN 	SCM_MST_SITE_ITEM	T2  WITH(NOLOCK)  --20230410 JHS [E20230403-000148]
					ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.PROJECT_CODE	= T2.PROJECT_CODE
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
					--AND	T2.VALID_YN		= 'Y'
					WHERE F.[DIVISION_ID]  = '82'
					AND F.[YYYYMMDD]	  >=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					AND F.[MEASURE]        = 'RTF_SYS_RP'
					AND F.SCM_SITE_ID     IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
				)
				, #FINAL_DATA AS (
					SELECT /* 81번정보사용 */ B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PLANT_SITE_ID
						 , /* 82번정보사용 */ A.MEASURE, A.YYYYMMDD, A.QTY
						 --, /* 81번-DP입력구간월까지만 결과 가져올것  */  B.YYYYMMDD AS YYYYMMDD_81
						 , CASE WHEN A.YYYYMMDD <= SUBSTRING(B.MAX_YYYYMMDD,1,6) + '31'  THEN 'Y' ELSE 'N' END AS GUBUN
					FROM #TEMP_RTF_DATA_82 A WITH (NOLOCK)
					LEFT OUTER JOIN (	
										SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
											,  B.YYYYMMDD	AS MAX_YYYYMMDD
										FROM #TEMP_MKT_PLANT_ID_81 A WITH (NOLOCK) 
										INNER JOIN #TEMP_MKT_PLANT_ID_81_MAX_DATE B WITH (NOLOCK) 
										ON	A.DIVISION_ID	= B.DIVISION_ID
										AND A.PROJECT_CODE	= B.PROJECT_CODE	
										AND A.SCM_SITE_ID	= B.SCM_SITE_ID
										AND A.ITEM_ID		= B.ITEM_ID
										AND A.DOM_EXP		= B.DOM_EXP
										AND A.FCST_TYPE		= B.FCST_TYPE
										AND A.INCOTERMS		= B.INCOTERMS
										AND A.MEASURE		= B.MEASURE
										AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
					) B
					ON A.SCM_SITE_ID = B.SCM_SITE_ID  AND A.ITEM_ID = B.ITEM_ID		-->> A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS 추가해야하는지?
					WHERE 1=1
					AND ISNULL(B.DIVISION_ID,'') != ''
				) 
				SELECT *  INTO  #T9_RTF_AFTER_INSERT
				FROM (
					SELECT  DIVISION_ID
						,@p_cut_off_version as VERSION_NO
						,@c_cutoff_TYPE		as CUTOFF_TYPE
						,@c_cutoff_yyyymmdd as CUTOFF_YYYYMMDD
						,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
						,'RTF_SCP' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY
						,'SYSTEM'  AS CREATED_BY
						,GETDATE() AS CREATION_DATE
						,'SYSTEM'  AS LAST_UPDATED_BY
						,GETDATE() AS LAST_UPDATE_DATE 
					FROM  #FINAL_DATA
					/* ■■■■■■■■■■■■ 20240530 : 월 기준으로 자르면 됩니다 81사업부 DP 가 2025-05-01에 DP가 있다면, 2025-05-31까지 들어온 RTF는 반영 */
					WHERE GUBUN = 'Y'
				) T;

				--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start
				WITH #TEMP_MKT_PLANT_ID_81_MAX_DATE AS (
					/* 81번만 PLAN_SITE_ID 정보를 사용하고있으므로 DP일자 구간의 MAX(PLAN_ID)사용하기위해 처리 */
					SELECT T1.*
					FROM (
						SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
								, ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS 
													ORDER BY YYYYMMDD DESC) AS ROWNUM
						FROM DM_PLN_MKT_FCST WITH (NOLOCK) 
						WHERE DIVISION_ID = '81'
						  --AND MEASURE     = 'MKT_FCST'			
						  AND MEASURE     = @v_measure			-- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
						  AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK)  WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						  AND YYYYMMDD   >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --계획구간에서 정보 추출 
					) T1
					WHERE 1=1
					AND ROWNUM = 1 /* 계획구간 MKT FCST DP입력 대상 MAX(PLANT_ID) 추출 */
				) 
				, #TEMP_MKT_PLANT_ID_81 AS (
						SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
						FROM DM_PLN_MKT_FCST WITH (NOLOCK) 
						WHERE DIVISION_ID = '81'
						  --AND MEASURE     = 'MKT_FCST'			
						  AND MEASURE     = @v_measure			-- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
						  AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK)  WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						  AND YYYYMMDD   >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --계획구간에서 정보 추출 
						  GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
				) 
				, #TEMP_RTF_DATA_82 AS (
					SELECT F.[DIVISION_ID]		,F.[PROJECT_CODE]		,F.[SCM_SITE_ID]		,F.[ITEM_ID]		,F.[DOM_EXP]		,F.[FCST_TYPE]
							,F.[INCOTERMS] 		,F.[MEASURE]   		    ,F.[PLANT_SITE_ID]		,F.CELL_PROD_SITE_ID			--[PJ2025-50017] CELL_PROD_SITE_ID 추가
							,F.[YYYYMMDD]		,F.[QTY]		--,F.[CREATED_BY]
					FROM	DBO.DM_PLN_CFM_MKT_DEMAND_PLAN F  WITH  (NOLOCK) 
					INNER JOIN 	SCM_MST_SITE_ITEM	T2  WITH(NOLOCK)  
					ON	F.DIVISION_ID	= T2.DIVISION_ID
					AND	F.PROJECT_CODE	= T2.PROJECT_CODE
					AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
					AND	F.ITEM_ID		= T2.ITEM_ID
					--AND	T2.VALID_YN		= 'Y'
					WHERE F.[DIVISION_ID]  = '82'
					AND F.[YYYYMMDD]	  >=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					AND F.[MEASURE]        = 'RTF_SYS_RP'
					AND F.SCM_SITE_ID     IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
				)
				, #FINAL_DATA AS (
					SELECT /* 81번정보사용 */ B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PLANT_SITE_ID
						 , /* 82번정보사용 */ A.CELL_PROD_SITE_ID					--[PJ2025-50017] CELL_PROD_SITE_ID 추가
						 , /* 82번정보사용 */ A.MEASURE, A.YYYYMMDD, A.QTY
						 , CASE WHEN A.YYYYMMDD <= SUBSTRING(B.MAX_YYYYMMDD,1,6) + '31'  THEN 'Y' ELSE 'N' END AS GUBUN
					FROM #TEMP_RTF_DATA_82 A WITH (NOLOCK)
					LEFT OUTER JOIN (	
										SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
											,  B.YYYYMMDD	AS MAX_YYYYMMDD
										FROM #TEMP_MKT_PLANT_ID_81 A WITH (NOLOCK)
										INNER JOIN #TEMP_MKT_PLANT_ID_81_MAX_DATE B WITH (NOLOCK) 
										ON	A.DIVISION_ID	= B.DIVISION_ID
										AND A.PROJECT_CODE	= B.PROJECT_CODE	
										AND A.SCM_SITE_ID	= B.SCM_SITE_ID
										AND A.ITEM_ID		= B.ITEM_ID
										AND A.DOM_EXP		= B.DOM_EXP
										AND A.FCST_TYPE		= B.FCST_TYPE
										AND A.INCOTERMS		= B.INCOTERMS
										AND A.MEASURE		= B.MEASURE
										AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
					) B
					ON A.SCM_SITE_ID = B.SCM_SITE_ID  AND A.ITEM_ID = B.ITEM_ID		-->> A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS 추가해야하는지?
					WHERE 1=1
					AND ISNULL(B.DIVISION_ID,'') != ''
				) 
				SELECT *  INTO  #T9_CFM_DEMAND_AFTER_INSERT
				FROM (
					SELECT  DIVISION_ID
						,@p_cut_off_version as VERSION_NO
						,@c_cutoff_TYPE		as CUTOFF_TYPE
						,@c_cutoff_yyyymmdd as CUTOFF_YYYYMMDD
						,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
						,'RTF_SCP' AS MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID		--[PJ2025-50017] CELL_PROD_SITE_ID 추가
						,YYYYMMDD,QTY
						,'SYSTEM'  AS CREATED_BY
						,GETDATE() AS CREATION_DATE
						,'SYSTEM'  AS LAST_UPDATED_BY
						,GETDATE() AS LAST_UPDATE_DATE 
					FROM  #FINAL_DATA
					/* ■■■■■■■■■■■■ 20240530 : 월 기준으로 자르면 됩니다 81사업부 DP 가 2025-05-01에 DP가 있다면, 2025-05-31까지 들어온 RTF는 반영 */
					WHERE GUBUN = 'Y'
				) T;
				

				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) 
				-------------------------------------------------------------------------------------------------------------------------------------------	
				DELETE A
				  FROM #T9_RTF_AFTER_INSERT A
				 INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
								FROM #T_RTF_EXCEPTION_ITEM 
							   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID) B
						 ON A.DIVISION_ID						= B.DIVISION_ID
						AND A.PROJECT_CODE						= B.PROJECT_CODE
						AND A.SCM_SITE_ID						= B.SCM_SITE_ID
						AND A.ITEM_ID							= B.ITEM_ID
						AND A.DOM_EXP							= B.DOM_EXP
						AND A.FCST_TYPE							= B.FCST_TYPE
						AND A.INCOTERMS							= B.INCOTERMS
						AND A.PLANT_SITE_ID						= B.PLANT_SITE_ID
						AND A.YYYYMMDD						   >= @plan_start_yyyymmdd /*-- 당주월요일*/
						AND A.VERSION_NO						= @p_cut_off_version ;
				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) 
				-------------------------------------------------------------------------------------------------------------------------------------------	

				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) 
				-------------------------------------------------------------------------------------------------------------------------------------------	
				DELETE A
				  FROM #T9_CFM_DEMAND_AFTER_INSERT A
				 INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
								FROM #T_RTF_EXCEPTION_ITEM 
							   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID) B
						 ON A.DIVISION_ID						= B.DIVISION_ID
						AND A.PROJECT_CODE						= B.PROJECT_CODE
						AND A.SCM_SITE_ID						= B.SCM_SITE_ID
						AND A.ITEM_ID							= B.ITEM_ID
						AND A.DOM_EXP							= B.DOM_EXP
						AND A.FCST_TYPE							= B.FCST_TYPE
						AND A.INCOTERMS							= B.INCOTERMS
						AND A.PLANT_SITE_ID						= B.PLANT_SITE_ID
						AND A.YYYYMMDD						   >= @plan_start_yyyymmdd /*-- 당주월요일*/
						AND A.VERSION_NO						= @p_cut_off_version 
				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) 
				-------------------------------------------------------------------------------------------------------------------------------------------	
				--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End


				--[E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건으로 RTF 추가 - 선박BIZ건 START			
				DECLARE @RTF_SCP_CNT INT, @RTF_CNT INT
					  , @RTF_SYS_RP_CNT INT /* 20240528*/

					SELECT @RTF_SCP_CNT =  COUNT(*)
					FROM DM_PLN_MKT_FCST_C
					WHERE MEASURE = 'RTF_SCP'
					AND VERSION_NO = @p_cut_off_version
					AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
					AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')

					--PRINT '@RTF_SCP_CNT : ' + CONVERT(CHAR, @RTF_SCP_CNT);

					IF (@RTF_SCP_CNT = 0)
						BEGIN
							--PRINT N'■■ RTF_SCP 생성 ■■';

							insert into DM_PLN_MKT_FCST_C
									(DIVISION_ID
									,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
									,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
									,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
									,LAST_UPDATED_BY,LAST_UPDATE_DATE
									)					
							SELECT   DIVISION_ID
								,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
								,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS
								,'RTF_SCP' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE
							--FROM DM_PLN_MKT_FCST_C
							--WHERE MEASURE = 'MKT_FCST'
							FROM #T9_RTF_AFTER_INSERT  /* 20240528*/							
							WHERE MEASURE = 'RTF_SCP'
							AND VERSION_NO = @p_cut_off_version
							AND DIVISION_ID IN (SELECT SEGMENT1 FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
							AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')


							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start							
							insert into DBO.DM_PLN_CFM_MKT_DEMAND_PLAN_C
									(DIVISION_ID
									,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
									,PROJECT_CODE
									,END_CUSTOMER
									,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
									,INCOTERMS,MEASURE,PLANT_SITE_ID
									,CELL_PROD_SITE_ID							--[PJ2025-50017] CELL_PROD_SITE_ID 추가
									,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
									,LAST_UPDATED_BY,LAST_UPDATE_DATE
									)					
							SELECT   DIVISION_ID
								,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
								,PROJECT_CODE
								,CASE WHEN DIVISION_ID='40'	THEN PROJECT_CODE	ELSE ''				END				AS END_CUSTOMER
								,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS
								,'RTF_SCP' AS MEASURE,PLANT_SITE_ID
								,CELL_PROD_SITE_ID								--[PJ2025-50017] CELL_PROD_SITE_ID 추가
								,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE
							FROM #T9_CFM_DEMAND_AFTER_INSERT  /* 20240528*/							
							WHERE MEASURE = 'RTF_SCP'
							AND VERSION_NO = @p_cut_off_version
							AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
							AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')

							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End

						END


					SELECT @RTF_CNT =  COUNT(*)
					FROM DM_PLN_MKT_FCST_C
					WHERE MEASURE = 'RTF'
					AND VERSION_NO = @p_cut_off_version
					AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
					AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
				
					--PRINT '@RTF_CNT : ' + CONVERT(CHAR, @RTF_CNT);

					IF (@RTF_CNT = 0)
						BEGIN
							--PRINT N'■■■■■■■■ RTF 생성 ■■■■■■■■■';
							insert into DM_PLN_MKT_FCST_C
									(DIVISION_ID
									,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
									,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
									,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
									,LAST_UPDATED_BY,LAST_UPDATE_DATE
									)					
							SELECT   DIVISION_ID
								,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
								,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS
								,'RTF' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE
							--FROM DM_PLN_MKT_FCST_C
							--WHERE MEASURE = 'MKT_FCST'
							FROM #T9_RTF_AFTER_INSERT  /* 20240528*/							
							WHERE MEASURE = 'RTF_SCP' /* 20240528*/
							AND VERSION_NO = @p_cut_off_version
							AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
							AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')

							
							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start							
							insert into DBO.DM_PLN_CFM_MKT_DEMAND_PLAN_C
									(DIVISION_ID
									,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
									,PROJECT_CODE
									,END_CUSTOMER
									,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
									,INCOTERMS,MEASURE,PLANT_SITE_ID
									,CELL_PROD_SITE_ID						--[PJ2025-50017] CELL_PROD_SITE_ID 추가
									,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
									,LAST_UPDATED_BY,LAST_UPDATE_DATE
									)					
							SELECT   DIVISION_ID
								,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
								,PROJECT_CODE
								,CASE WHEN DIVISION_ID='40'	THEN PROJECT_CODE	ELSE ''				END				AS END_CUSTOMER
								,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS
								,'RTF' AS MEASURE,PLANT_SITE_ID
								,CELL_PROD_SITE_ID							--[PJ2025-50017] CELL_PROD_SITE_ID 추가
								,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE
							--FROM DM_PLN_MKT_FCST_C
							--WHERE MEASURE = 'MKT_FCST'
							FROM #T9_CFM_DEMAND_AFTER_INSERT  /* 20240528*/							
							WHERE MEASURE = 'RTF_SCP' /* 20240528*/
							AND VERSION_NO = @p_cut_off_version
							AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
							AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End							

						END

					/* 20240528 RTF_SYS_RP 생성 */
					SELECT @RTF_SYS_RP_CNT =  COUNT(*)
					FROM DM_PLN_MKT_FCST_C
					WHERE MEASURE = 'RTF_SYS_RP'
					AND VERSION_NO = @p_cut_off_version
					AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
					AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')

					--PRINT '@RTF_SYS_RP_CNT : ' + CONVERT(CHAR, @RTF_SYS_RP_CNT);

					IF (@RTF_SYS_RP_CNT = 0)
						BEGIN
							--PRINT N'■■■■■■■■ RTF_SYS_RP 생성 ■■■■■■■■■';

							insert into DM_PLN_MKT_FCST_C
									(DIVISION_ID
									,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
									,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
									,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
									,LAST_UPDATED_BY,LAST_UPDATE_DATE
									)

							SELECT   DIVISION_ID
								,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
								,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS
								,'RTF_SYS_RP' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE
							--FROM DM_PLN_MKT_FCST_C
							--WHERE MEASURE = 'MKT_FCST'
							FROM #T9_RTF_AFTER_INSERT
							WHERE MEASURE = 'RTF_SCP'
							AND VERSION_NO = @p_cut_off_version
							AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
							AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')								

							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start							
							insert into DBO.DM_PLN_CFM_MKT_DEMAND_PLAN_C
									(DIVISION_ID
									,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
									,PROJECT_CODE
									,END_CUSTOMER
									,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
									,INCOTERMS,MEASURE,PLANT_SITE_ID
									,CELL_PROD_SITE_ID					--[PJ2025-50017] CELL_PROD_SITE_ID 추가
									,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
									,LAST_UPDATED_BY,LAST_UPDATE_DATE
									)

							SELECT   DIVISION_ID
								,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
								,PROJECT_CODE
								,CASE WHEN DIVISION_ID='40'	THEN PROJECT_CODE	ELSE ''				END				AS END_CUSTOMER
								,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS
								,'RTF_SYS_RP' AS MEASURE,PLANT_SITE_ID
								,CELL_PROD_SITE_ID						--[PJ2025-50017] CELL_PROD_SITE_ID 추가
								,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE
							FROM #T9_CFM_DEMAND_AFTER_INSERT
							WHERE MEASURE = 'RTF_SCP'
							AND VERSION_NO = @p_cut_off_version
							AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
							AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')	
							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End



						END 

					--■■■ 기존 부분은 그대로 유지 : 룩업에 생성되어있으나 82번 사업부 RTF정보 미존재건에 대해서는 기존 로직대로 처리 
					--[E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건으로 RTF 추가 - 선박BIZ건 START
					SELECT @RTF_SCP_CNT =  COUNT(*)
					FROM DM_PLN_MKT_FCST_C
					WHERE MEASURE = 'RTF_SCP'
					AND VERSION_NO = @p_cut_off_version
					AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
					AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
					AND SCM_SITE_ID NOT IN (SELECT Z.SCM_SITE_ID FROM #T9_RTF_AFTER_INSERT Z WITH (NOLOCK) GROUP BY Z.SCM_SITE_ID)

					--PRINT '@RTF_SCP_CNT2 : ' + CONVERT(CHAR, @RTF_SCP_CNT);

					IF (@RTF_SCP_CNT = 0)
						BEGIN
							--PRINT N'■■■■■■■■ RTF_SCP2 생성 ■■■■■■■■■';

							insert into DM_PLN_MKT_FCST_C
									(DIVISION_ID
									,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
									,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
									,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
									,LAST_UPDATED_BY,LAST_UPDATE_DATE
									)
							SELECT   DIVISION_ID
								,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
								,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS
								,'RTF_SCP' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE
							FROM DM_PLN_MKT_FCST_C A
							--WHERE MEASURE = 'MKT_FCST'
							WHERE MEASURE = @v_measure			-- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
							AND VERSION_NO = @p_cut_off_version
							AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
							AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')					
							AND SCM_SITE_ID NOT IN (SELECT Z.SCM_SITE_ID FROM #T9_RTF_AFTER_INSERT Z WITH (NOLOCK) GROUP BY Z.SCM_SITE_ID)							
							-------------------------------------------------------------------------------------------------------------------------------------------	
							-- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (START) 
							-------------------------------------------------------------------------------------------------------------------------------------------	
							AND NOT EXISTS ( SELECT DISTINCT ITEM_ID 
												FROM #T_RTF_EXCEPTION_ITEM B WITH(NOLOCK)
												WHERE A.DIVISION_ID		= B.DIVISION_ID
												AND A.PROJECT_CODE		= B.PROJECT_CODE
												AND A.SCM_SITE_ID		= B.SCM_SITE_ID
												AND A.ITEM_ID			= B.ITEM_ID
												AND A.DOM_EXP			= B.DOM_EXP
												AND A.FCST_TYPE			= B.FCST_TYPE
												AND A.INCOTERMS			= B.INCOTERMS
												AND A.MEASURE			= B.MEASURE
												AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
												AND A.YYYYMMDD		   >= @plan_start_yyyymmdd /*-- 당주월요일*/
												AND A.VERSION_NO		= @p_cut_off_version )
							-------------------------------------------------------------------------------------------------------------------------------------------	
							-- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다 (END) 
							-------------------------------------------------------------------------------------------------------------------------------------------	

							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start							
							insert into DBO.DM_PLN_CFM_MKT_DEMAND_PLAN_C
									(DIVISION_ID
									,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
									,PROJECT_CODE
									,END_CUSTOMER
									,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
									,INCOTERMS,MEASURE,PLANT_SITE_ID
									,CELL_PROD_SITE_ID				--[PJ2025-50017] CELL_PROD_SITE_ID 추가
									,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
									,LAST_UPDATED_BY,LAST_UPDATE_DATE
									)
							SELECT   DIVISION_ID
								,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
								,PROJECT_CODE
								,CASE WHEN DIVISION_ID='40'	THEN PROJECT_CODE	ELSE ''				END				AS END_CUSTOMER
								,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS
								,'RTF_SCP' AS MEASURE,PLANT_SITE_ID
								,'-'																				AS CELL_PROD_SITE_ID	--[PJ2025-50017] CELL_PROD_SITE_ID 추가
								,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE
							FROM DM_PLN_MKT_FCST_C A
							--WHERE MEASURE = 'MKT_FCST'
							WHERE MEASURE = @v_measure			-- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
							AND VERSION_NO = @p_cut_off_version
							AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
							AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')					
							AND SCM_SITE_ID NOT IN (SELECT Z.SCM_SITE_ID FROM #T9_RTF_AFTER_INSERT Z WITH (NOLOCK) GROUP BY Z.SCM_SITE_ID)							
							-------------------------------------------------------------------------------------------------------------------------------------------	
							-- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (START) 
							-------------------------------------------------------------------------------------------------------------------------------------------	
							AND NOT EXISTS ( SELECT DISTINCT ITEM_ID 
												FROM #T_RTF_EXCEPTION_ITEM B WITH(NOLOCK)
												WHERE A.DIVISION_ID		= B.DIVISION_ID
												AND A.PROJECT_CODE		= B.PROJECT_CODE
												AND A.SCM_SITE_ID		= B.SCM_SITE_ID
												AND A.ITEM_ID			= B.ITEM_ID
												AND A.DOM_EXP			= B.DOM_EXP
												AND A.FCST_TYPE			= B.FCST_TYPE
												AND A.INCOTERMS			= B.INCOTERMS
												AND A.MEASURE			= B.MEASURE
												AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
												AND A.YYYYMMDD		   >= @plan_start_yyyymmdd /*-- 당주월요일*/
												AND A.VERSION_NO		= @p_cut_off_version )
							-------------------------------------------------------------------------------------------------------------------------------------------	
							-- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다 (END) 
							-------------------------------------------------------------------------------------------------------------------------------------------	
							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End

						END


					SELECT @RTF_CNT =  COUNT(*)
					FROM DM_PLN_MKT_FCST_C
					WHERE MEASURE = 'RTF'
					AND VERSION_NO = @p_cut_off_version
					AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
					AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
					AND SCM_SITE_ID NOT IN (SELECT Z.SCM_SITE_ID FROM #T9_RTF_AFTER_INSERT Z WITH (NOLOCK) GROUP BY Z.SCM_SITE_ID)

					--PRINT '@RTF_CNT2 : ' + CONVERT(CHAR, @RTF_CNT);
					IF (@RTF_CNT = 0)
						BEGIN
							--PRINT N'■■■■■■■■ RTF2 생성 ■■■■■■■■■';

							insert into DM_PLN_MKT_FCST_C
									(DIVISION_ID
									,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
									,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
									,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
									,LAST_UPDATED_BY,LAST_UPDATE_DATE
									)

							SELECT   DIVISION_ID
								,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
								,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS
								,'RTF' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE
							FROM DM_PLN_MKT_FCST_C A WITH(NOLOCK)
							--WHERE MEASURE = 'MKT_FCST'
							WHERE MEASURE = @v_measure			-- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
							AND VERSION_NO = @p_cut_off_version
							AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
							AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
							AND SCM_SITE_ID NOT IN (SELECT Z.SCM_SITE_ID FROM #T9_RTF_AFTER_INSERT Z WITH (NOLOCK) GROUP BY Z.SCM_SITE_ID)							
							-------------------------------------------------------------------------------------------------------------------------------------------	
							-- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (START) 
							-------------------------------------------------------------------------------------------------------------------------------------------	
							AND NOT EXISTS ( SELECT DISTINCT ITEM_ID 
												FROM #T_RTF_EXCEPTION_ITEM B WITH(NOLOCK)
												WHERE A.DIVISION_ID		= B.DIVISION_ID
												AND A.PROJECT_CODE		= B.PROJECT_CODE
												AND A.SCM_SITE_ID		= B.SCM_SITE_ID
												AND A.ITEM_ID			= B.ITEM_ID
												AND A.DOM_EXP			= B.DOM_EXP
												AND A.FCST_TYPE			= B.FCST_TYPE
												AND A.INCOTERMS			= B.INCOTERMS
												AND A.MEASURE			= B.MEASURE
												AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
												AND A.YYYYMMDD		   >= @plan_start_yyyymmdd /*-- 당주월요일*/
												AND A.VERSION_NO		= @p_cut_off_version )
							-------------------------------------------------------------------------------------------------------------------------------------------	
							-- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다 (END) 
							-------------------------------------------------------------------------------------------------------------------------------------------	
	


							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start
							insert into DBO.DM_PLN_CFM_MKT_DEMAND_PLAN_C
									(DIVISION_ID
									,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
									,PROJECT_CODE
									,END_CUSTOMER
									,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
									,INCOTERMS,MEASURE,PLANT_SITE_ID
									,CELL_PROD_SITE_ID					--[PJ2025-50017] CELL_PROD_SITE_ID 추가
									,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
									,LAST_UPDATED_BY,LAST_UPDATE_DATE
									)

							SELECT   DIVISION_ID
								,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
								,PROJECT_CODE
								,CASE WHEN DIVISION_ID='40'	THEN PROJECT_CODE	ELSE ''				END				AS END_CUSTOMER
								,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS
								,'RTF' AS MEASURE,PLANT_SITE_ID
								,'-'																				AS CELL_PROD_SITE_ID		--[PJ2025-50017] CELL_PROD_SITE_ID 추가
								,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE
							FROM DM_PLN_MKT_FCST_C A WITH(NOLOCK)
							--WHERE MEASURE = 'MKT_FCST'
							WHERE MEASURE = @v_measure			-- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
							AND VERSION_NO = @p_cut_off_version
							AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
							AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
							AND SCM_SITE_ID NOT IN (SELECT Z.SCM_SITE_ID FROM #T9_RTF_AFTER_INSERT Z WITH (NOLOCK) GROUP BY Z.SCM_SITE_ID)
							--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End							
							-------------------------------------------------------------------------------------------------------------------------------------------	
							-- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (START) 
							-------------------------------------------------------------------------------------------------------------------------------------------	
							AND NOT EXISTS ( SELECT DISTINCT ITEM_ID 
												FROM #T_RTF_EXCEPTION_ITEM B WITH(NOLOCK)
												WHERE A.DIVISION_ID		= B.DIVISION_ID
												AND A.PROJECT_CODE		= B.PROJECT_CODE
												AND A.SCM_SITE_ID		= B.SCM_SITE_ID
												AND A.ITEM_ID			= B.ITEM_ID
												AND A.DOM_EXP			= B.DOM_EXP
												AND A.FCST_TYPE			= B.FCST_TYPE
												AND A.INCOTERMS			= B.INCOTERMS
												AND A.MEASURE			= B.MEASURE
												AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
												AND A.YYYYMMDD		   >= @plan_start_yyyymmdd /*-- 당주월요일*/
												AND A.VERSION_NO		= @p_cut_off_version )
							-------------------------------------------------------------------------------------------------------------------------------------------	
							-- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다 (END) 
							-------------------------------------------------------------------------------------------------------------------------------------------	

						END						
						--SELECT * FROM #T2_MKT_FCST_INSERT
						--[E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건으로 RTF 추가 - 선박BIZ건 END

			END
			------------------------------------------------------------------------------------------------------------------------------------------------
			ELSE IF (@p_division_id = N'82')
			BEGIN 

				WITH #LOOKUP_SCM_SITE_ID AS (
					SELECT * 
					FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH (NOLOCK) 
					WHERE 1=1
					AND LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION'
					AND VALID_YN = 'Y' --사용대상
				)
				, #TEMP_CUTOFF_DATA_82 AS (
					SELECT A.*
					FROM DM_PLN_MKT_FCST_C A WITH (NOLOCK)     
						,#LOOKUP_SCM_SITE_ID B WITH(NOLOCK) 
					WHERE A.DIVISION_ID   = @p_division_id
					AND A.VERSION_NO	  = @p_cut_off_version
					AND A.CUTOFF_TYPE     = 'MF_W'
					AND A.MEASURE		  IN ('RTF_SYS_RP')
					AND A.SCM_SITE_ID	  = B.SEGMENT2
				) 
				, #TEMP_CUTOFF_DATA_81_MAX_DATE AS (
					SELECT T.*
					FROM (
						SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
							, A.YYYYMMDD
							, ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS 
												ORDER BY YYYYMMDD DESC) AS ROWNUM
						FROM DM_PLN_MKT_FCST_C A WITH (NOLOCK)     
							,#LOOKUP_SCM_SITE_ID B WITH(NOLOCK) 
						WHERE A.DIVISION_ID   = '81'
						AND A.VERSION_NO	  = @p_cut_off_version_81
						AND A.CUTOFF_TYPE     = 'MF_W'
						AND A.MEASURE IN ('RTF_SYS_RP')
						AND A.DIVISION_ID = B.SEGMENT1
						AND A.SCM_SITE_ID = B.SEGMENT2
					) T
					WHERE T.ROWNUM = 1
				)
				, #TEMP_CUTOFF_DATA_81 AS (
						SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
						FROM DM_PLN_MKT_FCST_C A WITH (NOLOCK)     
							,#LOOKUP_SCM_SITE_ID B WITH(NOLOCK) 
						WHERE A.DIVISION_ID   = '81'
						AND A.VERSION_NO	  = @p_cut_off_version_81
						AND A.CUTOFF_TYPE     = 'MF_W'
						AND A.MEASURE IN ('RTF_SYS_RP')
						AND A.DIVISION_ID = B.SEGMENT1
						AND A.SCM_SITE_ID = B.SEGMENT2
						GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
				) 
				, #FINAL_DATA AS (
					SELECT B.DIVISION_ID, B.VERSION_NO, B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
						  ,A.YYYYMMDD, A.QTY
					FROM #TEMP_CUTOFF_DATA_82 A WITH (NOLOCK) 
					INNER JOIN (	
									SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
										,  B.YYYYMMDD		AS MAX_YYYYMMDD
									FROM #TEMP_CUTOFF_DATA_81 A WITH(NOLOCK)
									INNER JOIN #TEMP_CUTOFF_DATA_81_MAX_DATE B WITH(NOLOCK)
									ON  A.DIVISION_ID		= B.DIVISION_ID
									AND A.VERSION_NO		= B.VERSION_NO
									AND A.CUTOFF_TYPE		= B.CUTOFF_TYPE
									AND A.CUTOFF_YYYYMMDD	= B.CUTOFF_YYYYMMDD
									AND A.PROJECT_CODE		= B.PROJECT_CODE
									AND A.SCM_SITE_ID		= B.SCM_SITE_ID
									AND A.ITEM_ID			= B.ITEM_ID
									AND A.DOM_EXP			= B.DOM_EXP
									AND A.FCST_TYPE			= B.FCST_TYPE
									AND A.INCOTERMS			= B.INCOTERMS
									AND A.MEASURE			= B.MEASURE
									AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
					) B
					ON  A.SCM_SITE_ID = B.SCM_SITE_ID  
					AND A.ITEM_ID = B.ITEM_ID 
					AND A.DOM_EXP   = B.DOM_EXP 
					AND A.FCST_TYPE = B.FCST_TYPE 
					AND A.INCOTERMS = B.INCOTERMS 
					AND A.MEASURE   = B.MEASURE
					WHERE 1=1
					AND CASE WHEN A.YYYYMMDD <= SUBSTRING(B.MAX_YYYYMMDD,1,6) + '31'  THEN 'Y' ELSE 'N' END  = 'Y'
				) 
				SELECT *  INTO  #T9_RTF_AFTER_INSERT2
				FROM (
					SELECT  DIVISION_ID
						,VERSION_NO AS VERSION_NO
						,CUTOFF_TYPE AS CUTOFF_TYPE
						,CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
						,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
						,'RTF_SCP' AS MEASURE
						,PLANT_SITE_ID,YYYYMMDD,QTY
						,'SYSTEM'  AS CREATED_BY
						,GETDATE() AS CREATION_DATE
						,'SYSTEM'  AS LAST_UPDATED_BY
						,GETDATE() AS LAST_UPDATE_DATE 
					FROM  #FINAL_DATA
				) T;

				--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start

				WITH #LOOKUP_SCM_SITE_ID AS (
					SELECT * 
					FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH (NOLOCK) 
					WHERE 1=1
					AND LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION'
					AND VALID_YN = 'Y' --사용대상
				)
				, #TEMP_CUTOFF_DATA_82 AS (
					SELECT A.*
					FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A WITH (NOLOCK)     
						,#LOOKUP_SCM_SITE_ID B WITH(NOLOCK) 
					WHERE A.DIVISION_ID   = @p_division_id
					AND A.VERSION_NO	  = @p_cut_off_version
					AND A.CUTOFF_TYPE     = 'MF_W'
					AND A.MEASURE		  IN ('RTF_SYS_RP')
					AND A.SCM_SITE_ID	  = B.SEGMENT2
				) 
				, #TEMP_CUTOFF_DATA_81_MAX_DATE AS (
					SELECT T.*
					FROM (
						SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
							, A.CELL_PROD_SITE_ID			--[PJ2025-50017] CELL_PROD_SITE_ID 추가
							, A.YYYYMMDD
							, ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS 
												ORDER BY YYYYMMDD DESC) AS ROWNUM
						FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A WITH (NOLOCK)     
							,#LOOKUP_SCM_SITE_ID B WITH(NOLOCK) 
						WHERE A.DIVISION_ID   = '81'
						AND A.VERSION_NO	  = @p_cut_off_version_81
						AND A.CUTOFF_TYPE     = 'MF_W'
						AND A.MEASURE IN ('RTF_SYS_RP')
						AND A.DIVISION_ID = B.SEGMENT1
						AND A.SCM_SITE_ID = B.SEGMENT2
					) T
					WHERE T.ROWNUM = 1
				)
				, #TEMP_CUTOFF_DATA_81 AS (
						SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
							, A.CELL_PROD_SITE_ID			--[PJ2025-50017] CELL_PROD_SITE_ID 추가
						FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A WITH (NOLOCK)     
							,#LOOKUP_SCM_SITE_ID B WITH(NOLOCK) 
						WHERE A.DIVISION_ID   = '81'
						AND A.VERSION_NO	  = @p_cut_off_version_81
						AND A.CUTOFF_TYPE     = 'MF_W'
						AND A.MEASURE IN ('RTF_SYS_RP')
						AND A.DIVISION_ID = B.SEGMENT1
						AND A.SCM_SITE_ID = B.SEGMENT2
                        -- 2025.04.10 Philsu Park: [PJ2024-50611] Group By 미처리로 Data 중복 발생한 케이스 조치.
                        GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
							, A.CELL_PROD_SITE_ID			--[PJ2025-50017] CELL_PROD_SITE_ID 추가
				) 
				, #FINAL_DATA AS (
					SELECT B.DIVISION_ID, B.VERSION_NO, B.CUTOFF_TYPE, B.CUTOFF_YYYYMMDD, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
						  ,A.CELL_PROD_SITE_ID				--[PJ2025-50017] CELL_PROD_SITE_ID 추가
						  ,A.YYYYMMDD, A.QTY
					FROM #TEMP_CUTOFF_DATA_82 A WITH (NOLOCK) 
					INNER JOIN (	
									SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
										,  B.YYYYMMDD		AS MAX_YYYYMMDD
									FROM #TEMP_CUTOFF_DATA_81 A WITH(NOLOCK)
									INNER JOIN #TEMP_CUTOFF_DATA_81_MAX_DATE B WITH(NOLOCK)
									ON  A.DIVISION_ID		= B.DIVISION_ID
									AND A.VERSION_NO		= B.VERSION_NO
									AND A.CUTOFF_TYPE		= B.CUTOFF_TYPE
									AND A.CUTOFF_YYYYMMDD	= B.CUTOFF_YYYYMMDD
									AND A.PROJECT_CODE		= B.PROJECT_CODE
									AND A.SCM_SITE_ID		= B.SCM_SITE_ID
									AND A.ITEM_ID			= B.ITEM_ID
									AND A.DOM_EXP			= B.DOM_EXP
									AND A.FCST_TYPE			= B.FCST_TYPE
									AND A.INCOTERMS			= B.INCOTERMS
									AND A.MEASURE			= B.MEASURE
									AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
									AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID		--[PJ2025-50017] CELL_PROD_SITE_ID 추가
					) B
					ON  A.SCM_SITE_ID = B.SCM_SITE_ID  
					AND A.ITEM_ID = B.ITEM_ID 
					AND A.DOM_EXP   = B.DOM_EXP 
					AND A.FCST_TYPE = B.FCST_TYPE 
					AND A.INCOTERMS = B.INCOTERMS 
					AND A.MEASURE   = B.MEASURE
					WHERE 1=1
					AND CASE WHEN A.YYYYMMDD <= SUBSTRING(B.MAX_YYYYMMDD,1,6) + '31'  THEN 'Y' ELSE 'N' END  = 'Y'
				) 
				SELECT *  INTO  #T9_CFM_DEMAND_AFTER_INSERT2
				FROM (
					SELECT  DIVISION_ID
						,VERSION_NO AS VERSION_NO
						,CUTOFF_TYPE AS CUTOFF_TYPE
						,CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
						,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
						,'RTF_SCP' AS MEASURE
						,PLANT_SITE_ID
						,CELL_PROD_SITE_ID			--[PJ2025-50017] CELL_PROD_SITE_ID 추가
						,YYYYMMDD,QTY
						,'SYSTEM'  AS CREATED_BY
						,GETDATE() AS CREATION_DATE
						,'SYSTEM'  AS LAST_UPDATED_BY
						,GETDATE() AS LAST_UPDATE_DATE 
					FROM  #FINAL_DATA
				) T;
				
				
				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) 
				-------------------------------------------------------------------------------------------------------------------------------------------	
				DELETE A
				  FROM #T9_RTF_AFTER_INSERT2 A
				 INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
								FROM #T_RTF_EXCEPTION_ITEM 
							   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID) B
						 ON A.DIVISION_ID						= B.DIVISION_ID
						AND A.PROJECT_CODE						= B.PROJECT_CODE
						AND A.SCM_SITE_ID						= B.SCM_SITE_ID
						AND A.ITEM_ID							= B.ITEM_ID
						AND A.DOM_EXP							= B.DOM_EXP
						AND A.FCST_TYPE							= B.FCST_TYPE
						AND A.INCOTERMS							= B.INCOTERMS
						AND A.PLANT_SITE_ID						= B.PLANT_SITE_ID
						AND A.YYYYMMDD						   >= @plan_start_yyyymmdd /*-- 당주월요일*/
				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) 
				-------------------------------------------------------------------------------------------------------------------------------------------	

				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) 
				-------------------------------------------------------------------------------------------------------------------------------------------	
				DELETE A
				  FROM #T9_CFM_DEMAND_AFTER_INSERT2 A
				 INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
								FROM #T_RTF_EXCEPTION_ITEM 
							   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID) B
						 ON A.DIVISION_ID						= B.DIVISION_ID
						AND A.PROJECT_CODE						= B.PROJECT_CODE
						AND A.SCM_SITE_ID						= B.SCM_SITE_ID
						AND A.ITEM_ID							= B.ITEM_ID
						AND A.DOM_EXP							= B.DOM_EXP
						AND A.FCST_TYPE							= B.FCST_TYPE
						AND A.INCOTERMS							= B.INCOTERMS
						AND A.PLANT_SITE_ID						= B.PLANT_SITE_ID
						AND A.YYYYMMDD						   >= @plan_start_yyyymmdd /*-- 당주월요일*/
				-------------------------------------------------------------------------------------------------------------------------------------------	
				-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) 
				-------------------------------------------------------------------------------------------------------------------------------------------	

				--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End



				/* #T9_RTF_AFTER_INSERT2 : 81번 CUTOFF대상 중 82번 RTF 정보가 있는 정보
				   81번 CUTOFF 정보 중 해당 테이블에 정보가 있는 대상이면 삭제 후 #T9_RTF_AFTER_INSERT2정보로 다시 INSERT 한다.
				*/
				DECLARE @AFTER_RTF_DATA_CNT AS INT;

				SELECT @AFTER_RTF_DATA_CNT =  COUNT(*)
				FROM DM_PLN_MKT_FCST_C
				WHERE MEASURE IN ('RTF_SCP','RTF','RTF_SYS_RP')
				AND VERSION_NO = @p_cut_off_version_81
				AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
				AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
				/* 다시 넣어야할 대상에 존재하는지 확인 */
				AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM #T9_RTF_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')
				AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM #T9_RTF_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')

				--PRINT '@AFTER_RTF_DATA_CNT : ' + CONVERT(CHAR,@AFTER_RTF_DATA_CNT);

				IF (@AFTER_RTF_DATA_CNT > 0) --삭제 후 다시 넣어준다.
					BEGIN
						--PRINT N'■■■■■■정보재생성(DELETE)■■■■■■ : ' + CONVERT(CHAR, @AFTER_RTF_DATA_CNT) ;
					
						DELETE FROM DM_PLN_MKT_FCST_C
						WHERE MEASURE  IN ('RTF_SCP','RTF_SYS_RP','RTF')
						AND VERSION_NO = @p_cut_off_version_81
						AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						/* 다시 넣어야할 대상에 존재하는지 확인 */
						AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM #T9_RTF_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')
						AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM #T9_RTF_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')						
						-------------------------------------------------------------------------------------------------------------------------------------------	
						-- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (START) 
						-------------------------------------------------------------------------------------------------------------------------------------------	
						AND NOT EXISTS ( SELECT DISTINCT ITEM_ID 
											FROM #T_RTF_EXCEPTION_ITEM B WITH(NOLOCK)
											WHERE DM_PLN_MKT_FCST_C.DIVISION_ID		= B.DIVISION_ID
											AND DM_PLN_MKT_FCST_C.PROJECT_CODE		= B.PROJECT_CODE
											AND DM_PLN_MKT_FCST_C.SCM_SITE_ID		= B.SCM_SITE_ID
											AND DM_PLN_MKT_FCST_C.ITEM_ID			= B.ITEM_ID
											AND DM_PLN_MKT_FCST_C.DOM_EXP			= B.DOM_EXP
											AND DM_PLN_MKT_FCST_C.FCST_TYPE			= B.FCST_TYPE
											AND DM_PLN_MKT_FCST_C.INCOTERMS			= B.INCOTERMS
											AND DM_PLN_MKT_FCST_C.MEASURE			= B.MEASURE
											AND DM_PLN_MKT_FCST_C.PLANT_SITE_ID		= B.PLANT_SITE_ID
											AND DM_PLN_MKT_FCST_C.YYYYMMDD		   >= @plan_start_yyyymmdd /*-- 당주월요일*/
											AND DM_PLN_MKT_FCST_C.VERSION_NO		= @p_cut_off_version_81)
						-------------------------------------------------------------------------------------------------------------------------------------------	
						-- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다 (END) 
						-------------------------------------------------------------------------------------------------------------------------------------------	

						--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start
						DELETE FROM DBO.DM_PLN_CFM_MKT_DEMAND_PLAN_C
						WHERE MEASURE  IN ('RTF_SCP','RTF_SYS_RP','RTF')
						AND VERSION_NO = @p_cut_off_version_81
						AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						/* 다시 넣어야할 대상에 존재하는지 확인 */
						AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM #T9_CFM_DEMAND_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')
						AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM #T9_CFM_DEMAND_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')
						--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End
						-------------------------------------------------------------------------------------------------------------------------------------------	
						-- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다. (START) 
						-------------------------------------------------------------------------------------------------------------------------------------------	
						AND NOT EXISTS ( SELECT DISTINCT ITEM_ID 
											FROM #T_RTF_EXCEPTION_ITEM B WITH(NOLOCK)
											WHERE DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID						= B.DIVISION_ID
											AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.PROJECT_CODE						= B.PROJECT_CODE
											AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.END_CUSTOMER						= B.END_CUSTOMER
											AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.SCM_SITE_ID						= B.SCM_SITE_ID
											AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.ITEM_ID							= B.ITEM_ID
											AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.DOM_EXP							= B.DOM_EXP
											AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.FCST_TYPE							= B.FCST_TYPE
											AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.INCOTERMS							= B.INCOTERMS
											AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.MEASURE							= B.MEASURE
											AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID						= B.PLANT_SITE_ID
										    AND ISNULL(DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID, '-')		= ISNULL(B.CELL_PROD_SITE_ID, '-')
											AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.YYYYMMDD						   >= @plan_start_yyyymmdd /*-- 당주월요일*/
											AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.VERSION_NO						    = @p_cut_off_version_81)
						-------------------------------------------------------------------------------------------------------------------------------------------	
						-- [E20260331-000648]_수정한 데이터가 존재하지 않는 경우에만 삭제를 진행한다 (END) 
						-------------------------------------------------------------------------------------------------------------------------------------------	


						--PRINT N'■■■■■■정보재생성(INSERT)■■■■■■ : RTF, RTF_SYS_RP, RTF_SCP';

						insert into DM_PLN_MKT_FCST_C
								(DIVISION_ID
								,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
								,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE		-- [PJ2024-50611] 2025.01.14 (PLANT_SITE_ID 추가)
								,LAST_UPDATED_BY,LAST_UPDATE_DATE
								)					
						SELECT   DIVISION_ID
							,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
							,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
							,INCOTERMS
							,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE					-- [PJ2024-50611] 2025.01.14 (PLANT_SITE_ID 추가)
							,LAST_UPDATED_BY,LAST_UPDATE_DATE					
						FROM #T9_RTF_AFTER_INSERT2					
						WHERE MEASURE = 'RTF_SCP'
						AND VERSION_NO = @p_cut_off_version_81
						AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM #T9_RTF_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')
						AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM #T9_RTF_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')

						UNION ALL
						SELECT   DIVISION_ID
							,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
							,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
							,INCOTERMS
							,'RTF' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE			-- [PJ2024-50611] 2025.01.14 (PLANT_SITE_ID 추가)
							,LAST_UPDATED_BY,LAST_UPDATE_DATE					
						FROM #T9_RTF_AFTER_INSERT2					
						WHERE MEASURE = 'RTF_SCP'
						AND VERSION_NO = @p_cut_off_version_81
						AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM #T9_RTF_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')
						AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM #T9_RTF_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')

						UNION ALL
						SELECT   DIVISION_ID
							,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
							,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
							,INCOTERMS
							,'RTF_SYS_RP' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE	-- [PJ2024-50611] 2025.01.14 (PLANT_SITE_ID 추가)
							,LAST_UPDATED_BY,LAST_UPDATE_DATE					
						FROM #T9_RTF_AFTER_INSERT2					
						WHERE MEASURE = 'RTF_SCP'
						AND VERSION_NO = @p_cut_off_version_81
						AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM #T9_RTF_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')
						AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM #T9_RTF_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')

		

						--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 Start
						insert into DBO.DM_PLN_CFM_MKT_DEMAND_PLAN_C
								(DIVISION_ID
								,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
								,PROJECT_CODE
								,END_CUSTOMER
								,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
								,INCOTERMS,MEASURE,PLANT_SITE_ID
								,CELL_PROD_SITE_ID				--[PJ2025-50017] CELL_PROD_SITE_ID 추가
								,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
								,LAST_UPDATED_BY,LAST_UPDATE_DATE
								)					
						SELECT   DIVISION_ID
							,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
							,PROJECT_CODE
							,PROJECT_CODE								AS END_CUSTOMER
							,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
							,INCOTERMS
							,MEASURE,PLANT_SITE_ID
							,CELL_PROD_SITE_ID					--[PJ2025-50017] CELL_PROD_SITE_ID 추가
							,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
							,LAST_UPDATED_BY,LAST_UPDATE_DATE					
						FROM #T9_CFM_DEMAND_AFTER_INSERT2					
						WHERE MEASURE = 'RTF_SCP'
						AND VERSION_NO = @p_cut_off_version_81
						AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM #T9_CFM_DEMAND_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')
						AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM #T9_CFM_DEMAND_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')
						UNION ALL
						SELECT   DIVISION_ID
							,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
							,PROJECT_CODE
							,PROJECT_CODE								AS END_CUSTOMER
							,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
							,INCOTERMS
							,'RTF' AS MEASURE,PLANT_SITE_ID
							,CELL_PROD_SITE_ID					--[PJ2025-50017] CELL_PROD_SITE_ID 추가
							,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
							,LAST_UPDATED_BY,LAST_UPDATE_DATE					
						FROM #T9_CFM_DEMAND_AFTER_INSERT2					
						WHERE MEASURE = 'RTF_SCP'
						AND VERSION_NO = @p_cut_off_version_81
						AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM #T9_CFM_DEMAND_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')
						AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM #T9_CFM_DEMAND_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')
						UNION ALL
						SELECT   DIVISION_ID
							,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
							,PROJECT_CODE
							,PROJECT_CODE								AS END_CUSTOMER
							,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
							,INCOTERMS
							,'RTF_SYS_RP' AS MEASURE,PLANT_SITE_ID
							,CELL_PROD_SITE_ID					--[PJ2025-50017] CELL_PROD_SITE_ID 추가
							,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
							,LAST_UPDATED_BY,LAST_UPDATE_DATE					
						FROM #T9_CFM_DEMAND_AFTER_INSERT2					
						WHERE MEASURE = 'RTF_SCP'
						AND VERSION_NO = @p_cut_off_version_81 
						AND DIVISION_ID IN (SELECT SEGMENT1 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK) WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
						AND DIVISION_ID IN (SELECT Z.DIVISION_ID  FROM #T9_CFM_DEMAND_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')
						AND SCM_SITE_ID IN (SELECT Z.SCM_SITE_ID  FROM #T9_CFM_DEMAND_AFTER_INSERT2 Z WITH (NOLOCK) WHERE DIVISION_ID = '81')
						--[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화 End


					END

				END

/* ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ */
			
		END

--PRINT N'■■정상종료■■';
		---------------------------------- RTF MEASURE MKT_FCST TABLE INSERT (END)
		
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                      VMI재고 확인후 RTF 생성 로직 (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
        -- [C20220224-000448] ESS 사업부 VMI 기능 자동차사업부 확산 전개 요청 (자동차 사업부 VMI_INV 생성하지 않음)
        IF @p_division_id NOT LIKE '81%'
		BEGIN
			------------------------------------------------------------------------------------------------
			--PRINT '#T2_VMI_MST_MAIN INSERT START                        =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|
					-- 성능이슈로 TEMP테이블로 사용
					SELECT L.DIVISION_ID, l.SCM_SITE_ID, s.item_id, S.QTY
						INTO #FP_STOCK_QTY
						FROM [DBO].scm_dnm_stock_sn s with(nolock) 
							, [DBO].scm_mst_location l with(nolock)
						where l.division_id = s.division_id
						and l.storage_id = s.storage_id
						and convert( varchar, s.cutoff_date,112)  = @plan_start_yyyymmdd
						UNION ALL	-- [C20201103-000114]
						select l.division_id, l.scm_site_id, s.item_id, s.QTY
						FROM [DBO].scm_dnm_stock_sales s with(nolock)
							,[DBO].scm_mst_location l with(nolock)
						where l.division_id = s.division_id
						and l.storage_id = s.storage_id
						--[C20201222-000376]
						and L.PLANT_ID = S.PLANT_ID				-- 여기는 PLANT까지 걸어야 함.
						AND S.DIVISION_ID = '82'
						and s.result_date = CONVERT(CHAR(8), DATEADD(DAY, -1, @plan_start_yyyymmdd), 112)


					IF @p_division_id = '40'
					BEGIN


						-- INSERT
						insert into #T2_VMI_MST_MAIN  -- 
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
								-- vmi stock qty 를 초재고로 적용 (S)
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
									END AS QTY		,
								-- vmi stock qty 를 초재고로 적용 (E)
								A.CELL_PROD_SITE_ID, A.FROM_SITE_ID						-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
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
													W.ATTRIBUTE2			AS FROM_SITE_ID		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
									FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C W with(nolock)			
									INNER JOIN [DBO].[SCM_MST_SITE] ST WITH(NOLOCK)
										ON  w.division_id        =   st.division_id      
										AND w.scm_site_id        =   st.scm_site_id  
										AND	ST.VMI_YN			 =   'Y'  -- vmi대상만 입력
									and		W.DIVISION_ID			= @p_division_id
									AND     W.VERSION_NO			= @p_cut_off_version
									AND     W.cutoff_type			= @c_cutoff_TYPE
									and     W.cutoff_yyyymmdd       = @c_cutoff_yyyymmdd

									WHERE W.YYYYMMDD between @plan_start_yyyymmdd
									AND CONVERT(CHAR(8), DATEADD(WW, @plan_week_cnt, @plan_start_yyyymmdd  ),112)  -- SCP PLANNING 구간이 52주
									) A
							inner join SCM_SYS_CALENDAR_M  b with(nolock)
								on b.BASIS_YYYYMMDD between @plan_start_yyyymmdd
									AND CONVERT(CHAR(8), DATEADD(WW, @plan_week_cnt, @plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주
							left join DM_PLN_CFM_MKT_DEMAND_PLAN_C c with(nolock)
								ON		a.division_id		= c.division_id
								AND		a.project_code		= c.project_code
								AND		a.scm_site_id		= c.scm_site_id
								AND		a.item_id			= c.item_id
								AND		a.dom_exp			= c.dom_exp
								AND		a.fcst_type			= c.fcst_type
								AND		a.incoterms			= c.incoterms
								AND		a.plant_site_id		= c.plant_site_id
								and     a.measure			= c.measure
								AND		A.CELL_PROD_SITE_ID	= C.CELL_PROD_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가
								and     b.BASIS_YYYYMMDD    = c.yyyymmdd
								and		C.DIVISION_ID		= @p_division_id
								AND     C.VERSION_NO		= @p_cut_off_version
								AND     C.cutoff_type		= @c_cutoff_TYPE
								and     C.cutoff_yyyymmdd   = @c_cutoff_yyyymmdd
							where 1=1
							--and a.measure in ('MKT_FCST', 'Vmi_In_Plan');					
							and a.measure in (@v_measure, 'Vmi_In_Plan');					-- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
							;

					END
					ELSE
					BEGIN

						-- INSERT
						insert into #T2_VMI_MST_MAIN  -- 
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
								-- vmi stock qty 를 초재고로 적용 (S)
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
									END AS QTY	,
								-- vmi stock qty 를 초재고로 적용 (E)
								'-'		AS CELL_PROD_SITE_ID,				-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 (단, 40외에는 형식을 맞추기 위해 DEFAULT값 적용)
								'-'		AS FROM_SITE_ID						-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 (단, 40외에는 형식을 맞추기 위해 DEFAULT값 적용)
							from ( SELECT DISTINCT W.DIVISION_ID 				,
													W.PROJECT_CODE 				,
													W.SCM_SITE_ID 				,
													W.ITEM_ID 					,
													W.DOM_EXP 					,
													W.FCST_TYPE 				,
													W.INCOTERMS 				,
													W.measure					,
													W.PLANT_SITE_ID 			
											FROM DM_PLN_MKT_FCST_C W with(nolock) 
											INNER JOIN [DBO].[SCM_MST_SITE] ST WITH(NOLOCK)
												ON  w.division_id        =   st.division_id      
												AND w.scm_site_id        =   st.scm_site_id  
												AND	ST.VMI_YN			 =   'Y'  -- vmi대상만 입력
											and		W.DIVISION_ID			= @p_division_id
											AND     W.VERSION_NO			= @p_cut_off_version
											AND     W.cutoff_type			= @c_cutoff_TYPE
											and     W.cutoff_yyyymmdd       = @c_cutoff_yyyymmdd

										WHERE W.YYYYMMDD between @plan_start_yyyymmdd
									AND CONVERT(CHAR(8), DATEADD(WW, @plan_week_cnt, @plan_start_yyyymmdd  ),112)  -- SCP PLANNING 구간이 52주
									) A
							inner join SCM_SYS_CALENDAR_M  b with(nolock)
								on b.BASIS_YYYYMMDD between @plan_start_yyyymmdd
									AND CONVERT(CHAR(8), DATEADD(WW, @plan_week_cnt, @plan_start_yyyymmdd),112)  -- SCP PLANNING 구간이 52주
							left join DM_PLN_MKT_FCST_C c with(nolock)
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
								and		C.DIVISION_ID		= @p_division_id
								AND     C.VERSION_NO		= @p_cut_off_version
								AND     C.cutoff_type		= @c_cutoff_TYPE
								and     C.cutoff_yyyymmdd   = @c_cutoff_yyyymmdd
							where 1=1
							--and a.measure in ('MKT_FCST', 'Vmi_In_Plan');				
							and a.measure in (@v_measure, 'Vmi_In_Plan');				-- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
							;

					END;





			--PRINT '#T2_VMI_temp1 INSERT START                         =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
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
							, CELL_PROD_SITE_ID, FROM_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
						FROM  #T2_VMI_MST_MAIN 
						WHERE MEASURE = 'Vmi_In_Plan'
						GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP,FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
								, CELL_PROD_SITE_ID, FROM_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
					)
					INSERT INTO #T2_VMI_MST_MAIN
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
					FROM #T2_VMI_MST_MAIN  AS AA
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

					INSERT INTO #T2_VMI_MST
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty,CELL_PROD_SITE_ID,FROM_SITE_ID)									-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
					SELECT a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp, a.fcst_type, a.incoterms, a.measure, a.plant_site_id, a.yyyymmdd,a.qty,CELL_PROD_SITE_ID,FROM_SITE_ID	-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
					FROM #T2_VMI_MST_MAIN A
					WHERE 1=1

					--
					insert into #T2_VMI_temp1
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty,accum_sum,last_accum_sum,CELL_PROD_SITE_ID,FROM_SITE_ID)		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 

					SELECT a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd, A.QTY , SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) 'accum_sum'
						,SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) - A.QTY  'last_accum_sum' 
						,CELL_PROD_SITE_ID, FROM_SITE_ID		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
						FROM #T2_VMI_MST A
						--where a.measure		= 'MKT_FCST'					
						where a.measure		= @v_measure					-- [PJ2025-50188] 기준수요 (@v_measure : MKT_FCST / SCM_FCST)
						and a.yyyymmdd		>= @plan_start_yyyymmdd



					--PRINT '#T2_VMI_temp2 INSERT START                         =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
					----------------------------------------------------------|

					insert into #T2_VMI_temp2
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty,accum_sum,last_accum_sum,CELL_PROD_SITE_ID,FROM_SITE_ID) -- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 

					SELECT a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd, A.QTY , SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) 'accum_sum'
						,SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) - A.QTY  'last_accum_sum' 
						,CELL_PROD_SITE_ID,FROM_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
						FROM #T2_VMI_MST A
						where a.measure		= 'Vmi_In_Plan'
						and a.yyyymmdd		>= @plan_start_yyyymmdd

			---------------------------------------------------------------------------------------- 

			--PRINT '#T2_VMI_temp_all INSERT START                      =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|

					insert into #T2_VMI_temp_all
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id,yyyymmdd,RTF_QTY,INV,CELL_PROD_SITE_ID,FROM_SITE_ID)		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
					select a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.plant_site_id,a.yyyymmdd
							,SUM( case when isnull(a.accum_sum,0) > isnull(b.accum_sum,0) then isnull(b.accum_sum,0) else isnull(a.accum_sum,0) end ) - SUM( case when isnull(a.last_accum_sum,0) > isnull(b.last_accum_sum,0) then isnull(b.last_accum_sum,0) else isnull(a.last_accum_sum,0) end ) RTF_QTY
							,SUM(isnull(b.accum_sum,0) - isnull(a.accum_sum,0)) INV
							,B.CELL_PROD_SITE_ID,B.FROM_SITE_ID		-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
						from #T2_VMI_temp1 a  --  'MKT_FCST'
							,#T2_VMI_temp2 b  --  'Vmi_In_Plan'
						where a.division_id	= b.DIVISION_ID
						and a.project_code	= b.project_code
						and a.scm_site_id	= b.scm_site_id
						and a.item_id		= b.ITEM_ID
						and a.fcst_type		= b.FCST_TYPE
						and a.incoterms		= b.incoterms
						and a.plant_site_id	= b.PLANT_SITE_ID
						and a.dom_exp		= b.dom_exp
						and a.yyyymmdd		= b.YYYYMMDD
						AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID
					group by a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd
							, B.CELL_PROD_SITE_ID, B.FROM_SITE_ID			-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
					order by a.yyyymmdd
					;


			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) 
			-------------------------------------------------------------------------------------------------------------------------------------------	
			DELETE A
			FROM #T2_VMI_temp_all A
			INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, ISNULL(CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
						FROM #T_RTF_EXCEPTION_ITEM 
						GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, ISNULL(CELL_PROD_SITE_ID, '-')) B
					ON A.DIVISION_ID						= B.DIVISION_ID
				AND A.PROJECT_CODE						= B.PROJECT_CODE
				AND A.SCM_SITE_ID						= B.SCM_SITE_ID
				AND A.ITEM_ID							= B.ITEM_ID
				AND A.DOM_EXP							= B.DOM_EXP
				AND A.FCST_TYPE							= B.FCST_TYPE
				AND A.INCOTERMS							= B.INCOTERMS
				AND A.PLANT_SITE_ID						= B.PLANT_SITE_ID
				AND ISNULL(A.CELL_PROD_SITE_ID, '-')	= ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260512-000502] 81도 해당 부분을 비교하도록 수정한다.
				--AND CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(A.CELL_PROD_SITE_ID, '-') ELSE '-' END = ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260512-000502] 원소스 주석처리
				AND A.YYYYMMDD						   >= @plan_start_yyyymmdd /*-- 당주월요일*/
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) 
			-------------------------------------------------------------------------------------------------------------------------------------------	


			DELETE #T_MEASURE_RTF;  -- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_RTF 초기화

			--IF (@p_division_id = '40' AND @c_ee_40_fn_cnt > 0)  -- [PJ2025-50017] 현재 수행되는 기준이 EE_FN일 경우 RTF_SYS_RP는 업데이트 안함. (RTF_PR만 업데이트 처리)
			IF (@p_division_id = '40' AND @c_ee_fn_flag = 'Y')  -- [PJ2025-50017] 현재 수행되는 기준이 EE_FN일 경우 RTF_SYS_RP/VMI_IN_PLAN/AS_IN_PLAN는 업데이트 안함. (RTF_PR만 업데이트 처리) ==> [PJ2025-50188] VMI_IN_PLAN/AS_IN_PLAN 업데이트 하는 것으로 변경
			BEGIN
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_RTF 
				INSERT INTO #T_MEASURE_RTF		
				SELECT 'RTF_PR'			
			END 
			ELSE 
			BEGIN
				-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 임시테이블 #T_MEASURE_RTF 
				INSERT INTO #T_MEASURE_RTF		
				SELECT 'RTF_PR'			UNION ALL
				SELECT 'RTF_SCP'		UNION ALL
				SELECT 'RTF_SYS_RP'		
			END

			-- [PJ2025-50188] 'VMI_INV' 삭제 START
			DELETE 
			FROM dbo.DM_PLN_MKT_FCST_C
			where MEASURE IN ( 'VMI_Inv' )
			and		DIVISION_ID		  = @p_division_id
			and     VERSION_NO		  = @p_cut_off_version
			and     cutoff_type		  = @c_cutoff_TYPE
			and     cutoff_yyyymmdd   = @c_cutoff_yyyymmdd
			and exists (
					SELECT division_id 
					FROM #T2_VMI_MST
					where 1=1
					and DM_PLN_MKT_FCST_C.division_id        =   division_id      
					AND DM_PLN_MKT_FCST_C.project_code       =   project_code   
					AND DM_PLN_MKT_FCST_C.scm_site_id        =   scm_site_id  
					AND DM_PLN_MKT_FCST_C.item_id            =   item_id      
					AND DM_PLN_MKT_FCST_C.dom_exp            =   dom_exp      
					AND DM_PLN_MKT_FCST_C.fcst_type          =   fcst_type    
					AND DM_PLN_MKT_FCST_C.incoterms          =   incoterms    
					AND DM_PLN_MKT_FCST_C.plant_site_id      =   plant_site_id
					AND DM_PLN_MKT_FCST_C.yyyymmdd           >=   @plan_start_yyyymmdd  -- 월요일
			);

			DELETE 
			FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN_C
			where MEASURE IN ( 'VMI_Inv' )
			and		DIVISION_ID		  = @p_division_id
			and     VERSION_NO		  = @p_cut_off_version
			and     cutoff_type		  = @c_cutoff_TYPE
			and     cutoff_yyyymmdd   = @c_cutoff_yyyymmdd
			and exists (
					SELECT division_id 
					FROM #T2_VMI_MST
					where 1=1
					and DM_PLN_CFM_MKT_DEMAND_PLAN_C.division_id        =   division_id      
					AND CASE WHEN DIVISION_ID = '40' THEN DM_PLN_CFM_MKT_DEMAND_PLAN_C.end_customer ELSE DM_PLN_CFM_MKT_DEMAND_PLAN_C.project_code END =   project_code   
					AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.scm_site_id        =   scm_site_id  
					AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.item_id            =   item_id      
					AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.dom_exp            =   dom_exp      
					AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.fcst_type          =   fcst_type    
					AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.incoterms          =   incoterms    
					AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.plant_site_id      =   plant_site_id
					AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.yyyymmdd           >=  @plan_start_yyyymmdd  -- 월요일
			);
			-- [PJ2025-50188] 'VMI_INV' 삭제 END

			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) 
			-------------------------------------------------------------------------------------------------------------------------------------------	
			DELETE A
			FROM #T2_VMI_MST A
			INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
						FROM #T_RTF_EXCEPTION_ITEM 
						GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID) B
					ON A.DIVISION_ID						= B.DIVISION_ID
				AND A.PROJECT_CODE						= B.PROJECT_CODE
				AND A.SCM_SITE_ID						= B.SCM_SITE_ID
				AND A.ITEM_ID							= B.ITEM_ID
				AND A.DOM_EXP							= B.DOM_EXP
				AND A.FCST_TYPE							= B.FCST_TYPE
				AND A.INCOTERMS							= B.INCOTERMS
				AND A.PLANT_SITE_ID						= B.PLANT_SITE_ID
				AND A.YYYYMMDD						   >= @plan_start_yyyymmdd /*-- 당주월요일*/
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) 
			-------------------------------------------------------------------------------------------------------------------------------------------	


			-- [PJ2025-50188] 임시테이블 #T_MEASURE_RTF MEASURE 삭제 START
			/*	-- [PJ2025-50188] #T_MEASURE_RTF 참고
					. EE_FN 인 경우  ( 'RTF_PR' )
					. EE_FN 아닌 경우( 'RTF_SCP', 'RTF_SYS_RP', 'RTF_PR' )
			*/				
			DELETE 
			FROM dbo.DM_PLN_MKT_FCST_C
			where MEASURE IN ( SELECT MEASURE FROM #T_MEASURE_RTF WITH(NOLOCK) )		-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 
			and		DIVISION_ID		  = @p_division_id
			and     VERSION_NO		  = @p_cut_off_version
			and     cutoff_type		  = @c_cutoff_TYPE
			and     cutoff_yyyymmdd   = @c_cutoff_yyyymmdd
			and exists (
					SELECT division_id 
					FROM #T2_VMI_MST
					where 1=1
					and DM_PLN_MKT_FCST_C.division_id        =   division_id      
					AND DM_PLN_MKT_FCST_C.project_code       =   project_code   
					AND DM_PLN_MKT_FCST_C.scm_site_id        =   scm_site_id  
					AND DM_PLN_MKT_FCST_C.item_id            =   item_id      
					AND DM_PLN_MKT_FCST_C.dom_exp            =   dom_exp      
					AND DM_PLN_MKT_FCST_C.fcst_type          =   fcst_type    
					AND DM_PLN_MKT_FCST_C.incoterms          =   incoterms    
					AND DM_PLN_MKT_FCST_C.plant_site_id      =   plant_site_id
					AND DM_PLN_MKT_FCST_C.yyyymmdd           >=   @plan_start_yyyymmdd  -- 월요일	
			);

			DELETE 
			FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN_C
			where MEASURE IN ( SELECT MEASURE FROM #T_MEASURE_RTF WITH(NOLOCK) )		-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 
			and		DIVISION_ID		  = @p_division_id
			and     VERSION_NO		  = @p_cut_off_version
			and     cutoff_type		  = @c_cutoff_TYPE
			and     cutoff_yyyymmdd   = @c_cutoff_yyyymmdd
			and exists (
					SELECT division_id 
					FROM #T2_VMI_MST
					where 1=1
					and DM_PLN_CFM_MKT_DEMAND_PLAN_C.division_id        =   division_id      
					AND CASE WHEN DIVISION_ID = '40' THEN DM_PLN_CFM_MKT_DEMAND_PLAN_C.end_customer ELSE DM_PLN_CFM_MKT_DEMAND_PLAN_C.project_code END =   project_code   
					AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.scm_site_id        =   scm_site_id  
					AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.item_id            =   item_id      
					AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.dom_exp            =   dom_exp      
					AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.fcst_type          =   fcst_type    
					AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.incoterms          =   incoterms    
					AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.plant_site_id      =   plant_site_id
					AND DM_PLN_CFM_MKT_DEMAND_PLAN_C.yyyymmdd           >=  @plan_start_yyyymmdd  -- 월요일
			);
			-- [PJ2025-50188] 임시테이블 #T_MEASURE_RTF MEASURE 삭제 END

			--PRINT 'DM_PLN_MKT_FCST VMI_Inv INSERT START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|

			/*	-- [PJ2025-50188] #T_MEASURE_RTF 참고
					. EE_FN 인 경우  ( 'RTF_PR' )
					. EE_FN 아닌 경우( 'RTF_SCP', 'RTF_SYS_RP', 'RTF_PR' )
			*/				
			insert into DM_PLN_MKT_FCST_C
						( DIVISION_ID
						,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
						,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
						,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
						,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
						,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
						)
			select A.division_id 
					,@p_cut_off_version,@c_cutoff_TYPE,@c_cutoff_yyyymmdd
					, A.project_code, A.SCM_site_id,A.item_id, A.dom_exp,A.fcst_type, A.incoterms
					, B.measure			-- [PJ2025-50188] #T_MEASURE_RTF 에서 정의된 모든 MEASURE 생성
					,A.plant_site_id, A.yyyymmdd
				--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
				,A.rtf_qty as QTY 
				,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null,null
			from  #T2_VMI_temp_all A WITH(NOLOCK)
			INNER JOIN 
			(
				SELECT MEASURE FROM #T_MEASURE_RTF WITH(NOLOCK)   			-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 	
			) B
			ON	1 = 1		-- [PJ2025-50188] #T_MEASURE_RTF 에서 정의된 MEASURE 전체를 동일하게 생성하기 위함.
			WHERE	A.yyyymmdd	>= @plan_start_yyyymmdd
			AND		A.rtf_qty	> 0 
			UNION ALL --[C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용
			select division_id 
					,@p_cut_off_version,@c_cutoff_TYPE,@c_cutoff_yyyymmdd
					, project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'RTF' as measure ,plant_site_id, yyyymmdd
				--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
				,rtf_qty as QTY 
				,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null,null
			from  #T2_VMI_temp_all
				WHERE yyyymmdd		>= @plan_start_yyyymmdd
				and   division_id = '82'
				AND rtf_qty > 0 
			union ALL
			select division_id 
					,@p_cut_off_version,@c_cutoff_TYPE,@c_cutoff_yyyymmdd
					,project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'VMI_Inv' as measure ,plant_site_id, yyyymmdd
				--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
				,INV as QTY 
				,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null,null
			from  #T2_VMI_temp_all
				WHERE yyyymmdd		>= @plan_start_yyyymmdd
				AND   division_id = '82'
				AND inv > 0 


			insert into DM_PLN_CFM_MKT_DEMAND_PLAN_C
						( DIVISION_ID
						,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
						,PROJECT_CODE
						,END_CUSTOMER
						,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
						,INCOTERMS,MEASURE,PLANT_SITE_ID
						,CELL_PROD_SITE_ID				-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						,ATTRIBUTE2						-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
						,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
						,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE3,ATTRIBUTE4
						,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
						)
			select A.division_id 
					,@p_cut_off_version,@c_cutoff_TYPE,@c_cutoff_yyyymmdd
					, A.PROJECT_CODE
					, CASE WHEN A.DIVISION_ID='40'	THEN A.project_code	ELSE ''				END				AS END_CUSTOMER
					, A.SCM_site_id,A.item_id, A.dom_exp,A.fcst_type, A.incoterms
					, B.measure			-- [PJ2025-50188]  EE_FN 분기 로직 통합처리. #T_MEASURE_RTF에서 정의된 모든 MEASURE 생성
					, A.plant_site_id
					, ISNULL(A.CELL_PROD_SITE_ID,'-')		AS CELL_PROD_SITE_ID			-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					, A.FROM_SITE_ID						AS ATTRIBUTE2					-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
					, A.yyyymmdd
					, A.rtf_qty as QTY 
					,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null
			from  #T2_VMI_temp_all A WITH(NOLOCK)
			INNER JOIN 
			(
				SELECT MEASURE FROM #T_MEASURE_RTF WITH(NOLOCK)			-- [PJ2025-50188] EE_FN 분기 로직 통합처리. 
			) B
			ON	1 = 1		-- [PJ2025-50188] EE_FN 분기 로직 통합처리. #T_MEASURE_RTF 에서 정의된 MEASURE 전체를 동일하게 생성하기 위함.
			WHERE A.yyyymmdd	>= @plan_start_yyyymmdd
			AND A.rtf_qty		> 0 
			UNION ALL --[C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용
			select division_id 
					,@p_cut_off_version,@c_cutoff_TYPE,@c_cutoff_yyyymmdd
					, PROJECT_CODE
					, CASE WHEN DIVISION_ID='40'	THEN project_code	ELSE ''				END				AS END_CUSTOMER
					, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'RTF' as measure ,plant_site_id
					, ISNULL(CELL_PROD_SITE_ID,'-')		AS CELL_PROD_SITE_ID			-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					, FROM_SITE_ID							AS ATTRIBUTE2					-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
					, yyyymmdd
				--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
					,rtf_qty as QTY 
					,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null
			from  #T2_VMI_temp_all
				WHERE yyyymmdd		>= @plan_start_yyyymmdd
				and   division_id = '82'
				AND rtf_qty > 0 
			union ALL
			select division_id 
					,@p_cut_off_version,@c_cutoff_TYPE,@c_cutoff_yyyymmdd
					, PROJECT_CODE
					, CASE WHEN DIVISION_ID='40'	THEN project_code	ELSE ''				END				AS END_CUSTOMER
					, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'VMI_Inv' as measure ,plant_site_id
					, '-'									AS CELL_PROD_SITE_ID			-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					, '-'									AS ATTRIBUTE2					-- [PJ2025-50017] VMI RTF 생성을 위해 CELL_PROD_SITE_ID,FROM_SITE_ID 추가 
					, yyyymmdd
					--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
					,INV as QTY 
					,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null
			from  #T2_VMI_temp_all
				WHERE yyyymmdd		>= @plan_start_yyyymmdd
				AND   division_id = '82'
				AND inv > 0 

		END
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                      VMI재고 확인후 RTF 생성 로직 (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--	AS RTF 생성 프로시저 호출
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		EXEC PR_DM_DNM_CREATE_C_WS_RTF @P_DIVISION_ID, @p_cut_off_version

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                MKT_FCST CUTOFF QTY_BALANCE_CREATE (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		BEGIN

			-- [PJ2025-50188] 임시테이블 #T2_MKT_FCST ==> #T_MF_C_BALANCE_MKT_FCST 변경
			CREATE TABLE #T_MF_C_BALANCE_MKT_FCST (
						 DIVISION_ID        nvarchar(30)   
						,VERSION_NO			nvarchar(50)   
						,CUTOFF_TYPE		nvarchar(10)   
						,CUTOFF_YYYYMMDD	nvarchar(8)   
						,PROJECT_CODE       nvarchar(50)   
						,SCM_SITE_ID        nvarchar(30)   
						,ITEM_ID            nvarchar(50)   
						,DOM_EXP            nvarchar(3)    
						,FCST_TYPE          nvarchar(20)   
						,INCOTERMS          nvarchar(10)   
						,PLANT_SITE_ID      nvarchar(30)   
						,CELL_PROD_SITE_ID  nvarchar(30)				
						,MEASURE        	nvarchar(50)				
						,YYYYMMDD           nvarchar(8)    
						,QTY                numeric(20, 10)
			)
			;
		
			IF @p_division_id = '40'
			BEGIN

				INSERT INTO #T_MF_C_BALANCE_MKT_FCST					-- [PJ2025-50188] 임시테이블 #T2_MKT_FCST ==> #T_MF_C_BALANCE_MKT_FCST 변경
				( 
						DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
						, CELL_PROD_SITE_ID								-- [PJ2025-50188]추가
						, MEASURE, YYYYMMDD, QTY				
				)
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
						, CELL_PROD_SITE_ID								-- [PJ2025-50188]추가
						, MEASURE, YYYYMMDD, QTY
				FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C		WITH(NOLOCK)
				WHERE DIVISION_ID		= @p_division_id
				AND   VERSION_NO		= @p_cut_off_version
				AND   CUTOFF_TYPE		= @c_cutoff_TYPE
				AND   CUTOFF_YYYYMMDD   = @c_cutoff_yyyymmdd
				AND   YYYYMMDD			>= @plan_start_yyyymmdd
				AND MEASURE IN ('MKT_FCST','RTF_SCP')		-- 해당 MEASURE로 국한하지 않으면, MKT_AMT_KRW로 인해 OVERFLOW 발생 가능함.
				;

			END
			ELSE 
			BEGIN

				INSERT INTO #T_MF_C_BALANCE_MKT_FCST					-- [PJ2025-50188] 임시테이블 #T2_MKT_FCST ==> #T_MF_C_BALANCE_MKT_FCST 변경
				( 
						DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
						, CELL_PROD_SITE_ID								-- [PJ2025-50188]추가
						, MEASURE, YYYYMMDD, QTY				
				)
				SELECT DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
						, '-'					AS CELL_PROD_SITE_ID		-- [PJ2025-50188]추가
						, MEASURE, YYYYMMDD, QTY
				FROM DM_PLN_MKT_FCST_C				WITH(NOLOCK)
				WHERE DIVISION_ID	= @p_division_id
				AND   VERSION_NO		= @p_cut_off_version
				AND   CUTOFF_TYPE		= @c_cutoff_TYPE
				AND   CUTOFF_YYYYMMDD   = @c_cutoff_yyyymmdd
				AND   YYYYMMDD		>= @plan_start_yyyymmdd
				AND MEASURE IN ('MKT_FCST','RTF_SCP')		-- 해당 MEASURE로 국한하지 않으면, MKT_AMT_KRW로 인해 OVERFLOW 발생 가능함.
				;

			END
			
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) 
			-------------------------------------------------------------------------------------------------------------------------------------------	
			DELETE A
			  FROM #T_MF_C_BALANCE_MKT_FCST A
			 INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, ISNULL(CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
							FROM #T_RTF_EXCEPTION_ITEM 
							GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, ISNULL(CELL_PROD_SITE_ID, '-')) B
					 ON A.DIVISION_ID						= B.DIVISION_ID
					AND A.PROJECT_CODE						= B.PROJECT_CODE
					AND A.SCM_SITE_ID						= B.SCM_SITE_ID
					AND A.ITEM_ID							= B.ITEM_ID
					AND A.DOM_EXP							= B.DOM_EXP
					AND A.FCST_TYPE							= B.FCST_TYPE
					AND A.INCOTERMS							= B.INCOTERMS
					AND A.PLANT_SITE_ID						= B.PLANT_SITE_ID
					AND ISNULL(A.CELL_PROD_SITE_ID, '-')	= ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260512-000502] 81도 해당 부분을 비교하도록 수정한다.
					--AND CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(A.CELL_PROD_SITE_ID, '-') ELSE '-' END = ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260512-000502] 원소스 주석처리
					AND A.YYYYMMDD						   >= @plan_start_yyyymmdd /*-- 당주월요일*/
					AND A.VERSION_NO						= @p_cut_off_version 
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) 
			-------------------------------------------------------------------------------------------------------------------------------------------	


		--PRINT N'BALANCE #T2_CUTOFF_MST INSERT                    =>' + CONVERT(VARCHAR(8), GETDATE(), 108)

			INSERT INTO #T2_CUTOFF_MST
					(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID,MEASURE,YYYYMMDD,QTY
					, CELL_PROD_SITE_ID							-- [PJ2025-50188] 추가
					)
			SELECT ZZ.division_id, ZZ.project_code, ZZ.scm_site_id, ZZ.item_id, ZZ.dom_exp, ZZ.fcst_type, ZZ.incoterms, ZZ.plant_site_id, ZZ.MEASURE, ZZ.YYYYMMDD, max(ISNULL(C.QTY,0))
					, ZZ.CELL_PROD_SITE_ID							-- [PJ2025-50188] 추가
				FROM 
				 (
				  SELECT * 
				  from 
				  (
					SELECT DISTINCT A.division_id, A.project_code, A.scm_site_id, A.item_id, A.dom_exp, A.fcst_type, A.incoterms, A.plant_site_id
								,	A.CELL_PROD_SITE_ID			-- [PJ2025-50188] 추가
						--from DM_PLN_MKT_FCST_C A WITH(NOLOCK) WHERE 1=1
						from #T_MF_C_BALANCE_MKT_FCST A WITH(NOLOCK) WHERE 1=1		-- [PJ2025-50188] 임시테이블 #T2_MKT_FCST ==> #T_MF_C_BALANCE_MKT_FCST 변경
							AND   A.MEASURE		   IN ('MKT_FCST','RTF_SCP')			
							AND     A.QTY				> 0
							and		DIVISION_ID			= @p_division_id
							AND     A.VERSION_NO		= @p_cut_off_version
							AND     A.cutoff_type		= @c_cutoff_TYPE
							and     A.cutoff_yyyymmdd   = @c_cutoff_yyyymmdd  
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
					--LEFT JOIN DM_PLN_MKT_FCST_C C WITH(NOLOCK)
					LEFT JOIN #T_MF_C_BALANCE_MKT_FCST C WITH(NOLOCK)		-- [PJ2025-50188] 임시테이블 #T2_MKT_FCST ==> #T_MF_C_BALANCE_MKT_FCST 변경
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
													AND     ZZ.CELL_PROD_SITE_ID	= C.CELL_PROD_SITE_ID
													and		C.DIVISION_ID		= @p_division_id
													AND     C.VERSION_NO		= @p_cut_off_version
													AND     C.cutoff_type		= @c_cutoff_TYPE
													and     C.cutoff_yyyymmdd   = @c_cutoff_yyyymmdd

			group by ZZ.division_id, ZZ.project_code, ZZ.scm_site_id, ZZ.item_id, ZZ.dom_exp, ZZ.fcst_type, ZZ.incoterms, ZZ.plant_site_id, ZZ.MEASURE,ZZ.YYYYMMDD
				   , ZZ.CELL_PROD_SITE_ID							-- [PJ2025-50188] 추가

			---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) 
			-------------------------------------------------------------------------------------------------------------------------------------------	
			DELETE A
			  FROM #T2_CUTOFF_MST A
			 INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, ISNULL(CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
							FROM #T_RTF_EXCEPTION_ITEM 
							GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, ISNULL(CELL_PROD_SITE_ID, '-')) B
					 ON A.DIVISION_ID						= B.DIVISION_ID
					AND A.PROJECT_CODE						= B.PROJECT_CODE
					AND A.SCM_SITE_ID						= B.SCM_SITE_ID
					AND A.ITEM_ID							= B.ITEM_ID
					AND A.DOM_EXP							= B.DOM_EXP
					AND A.FCST_TYPE							= B.FCST_TYPE
					AND A.INCOTERMS							= B.INCOTERMS
					AND A.PLANT_SITE_ID						= B.PLANT_SITE_ID
					AND ISNULL(A.CELL_PROD_SITE_ID, '-')	= ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260512-000502] 81도 해당 부분을 비교하도록 수정한다.
					--AND CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(A.CELL_PROD_SITE_ID, '-') ELSE '-' END = ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260512-000502] 원소스 주석처리
					AND A.YYYYMMDD						   >= @plan_start_yyyymmdd /*-- 당주월요일*/
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) 
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건 - 선박BIZ건--- START
			-- BALANCE_MAKE MEASURE 생성 배제

			DELETE FROM #T2_CUTOFF_MST 
			WHERE DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
			AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')


			-- [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건 - 선박BIZ건--- END

			INSERT into #T2_CUTOFF_MST_ACCUM
			(		DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD
				  , MEASURE, QTY
				  , CELL_PROD_SITE_ID			-- [PJ2025-50188] 추가
				  , ACCUM_SUM		
			)
			select DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD
				  , MEASURE, QTY
				  , CELL_PROD_SITE_ID			-- [PJ2025-50188] 추가
				  , SUM(QTY) over ( partition by division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id, measure, CELL_PROD_SITE_ID order by yyyymmdd) accum_sum		-- [PJ2025-50188] CELL_PROD_SITE_ID 추가
				from #T2_CUTOFF_MST

			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) 
			-------------------------------------------------------------------------------------------------------------------------------------------	
			DELETE A
			  FROM #T2_CUTOFF_MST_ACCUM A
			 INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, ISNULL(CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
							FROM #T_RTF_EXCEPTION_ITEM 
							GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, ISNULL(CELL_PROD_SITE_ID, '-')) B
					 ON A.DIVISION_ID						= B.DIVISION_ID
					AND A.PROJECT_CODE						= B.PROJECT_CODE
					AND A.SCM_SITE_ID						= B.SCM_SITE_ID
					AND A.ITEM_ID							= B.ITEM_ID
					AND A.DOM_EXP							= B.DOM_EXP
					AND A.FCST_TYPE							= B.FCST_TYPE
					AND A.INCOTERMS							= B.INCOTERMS
					AND A.PLANT_SITE_ID						= B.PLANT_SITE_ID
					AND ISNULL(A.CELL_PROD_SITE_ID, '-')	= ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260512-000502] 81도 해당 부분을 비교하도록 수정한다.
					--AND CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(A.CELL_PROD_SITE_ID, '-') ELSE '-' END = ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260512-000502] 원소스 주석처리
					AND A.YYYYMMDD						   >= @plan_start_yyyymmdd /*-- 당주월요일*/
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) 
			-------------------------------------------------------------------------------------------------------------------------------------------	

			INSERT into #T2_CUTOFF_TEMPX
			(
				  DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP,FCST_TYPE, INCOTERMS, PLANT_SITE_ID,  MEASURE, YYYYMMDD
				, CELL_PROD_SITE_ID
				, ACCUM_X
			)
			select division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id,  'BALANCE' measure, yyyymmdd
				  , CELL_PROD_SITE_ID		-- [PJ2025-50188] 추가
				  ,  SUM( CASE WHEN MEASURE = 'MKT_FCST' THEN 0 ELSE accum_sum END)  - SUM( CASE WHEN MEASURE = 'MKT_FCST' THEN accum_sum ELSE 0 END) AS ACCUM_X
				from #T2_CUTOFF_MST_ACCUM
			group by division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id, yyyymmdd
				  , CELL_PROD_SITE_ID		-- [PJ2025-50188] 추가
		
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (START) 
			-------------------------------------------------------------------------------------------------------------------------------------------	
			DELETE A
			  FROM #T2_CUTOFF_TEMPX A
			 INNER JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, ISNULL(CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
							FROM #T_RTF_EXCEPTION_ITEM 
							GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, ISNULL(CELL_PROD_SITE_ID, '-')) B
					 ON A.DIVISION_ID						= B.DIVISION_ID
					AND A.PROJECT_CODE						= B.PROJECT_CODE
					AND A.SCM_SITE_ID						= B.SCM_SITE_ID
					AND A.ITEM_ID							= B.ITEM_ID
					AND A.DOM_EXP							= B.DOM_EXP
					AND A.FCST_TYPE							= B.FCST_TYPE
					AND A.INCOTERMS							= B.INCOTERMS
					AND A.PLANT_SITE_ID						= B.PLANT_SITE_ID
					AND ISNULL(A.CELL_PROD_SITE_ID, '-')	= ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260512-000502] 81도 해당 부분을 비교하도록 수정한다.
					--AND CASE WHEN A.DIVISION_ID = '40' THEN ISNULL(A.CELL_PROD_SITE_ID, '-') ELSE '-' END = ISNULL(B.CELL_PROD_SITE_ID, '-') --[E20260512-000502] 원소스 주석처리
					AND A.YYYYMMDD						   >= @plan_start_yyyymmdd /*-- 당주월요일*/
			-------------------------------------------------------------------------------------------------------------------------------------------	
			-- [E20260331-000648]_사용자가 수정한 이력이 존재하는 데이터는 추가 작업을 진행하지 않는다. (END) 
			-------------------------------------------------------------------------------------------------------------------------------------------	

			--PRINT N'BALANCE DM_PLN_MKT_FCST_C DELETE                =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|
			---------------------------------- 초기화 (START)
			DELETE FROM dbo.DM_PLN_MKT_FCST_C
				where MEASURE		= 'BALANCE'
				and		DIVISION_ID			= @p_division_id
				AND     VERSION_NO			= @p_cut_off_version
				AND     cutoff_type			= @c_cutoff_TYPE
				and     cutoff_yyyymmdd     = @c_cutoff_yyyymmdd
			---------------------------------- 초기화 (END)
					

			--PRINT N'BALANCE DM_PLN_MKT_FCST_C insert                =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|
			---------------------------------- 계산된 BALANCE값 INSERT (START)
			INSERT INTO DM_PLN_MKT_FCST_C
						( DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
						,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
						,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
						,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
						)
			SELECT  DIVISION_ID ,@P_CUT_OFF_VERSION,@C_CUTOFF_TYPE,@C_CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID,ITEM_ID, DOM_EXP,FCST_TYPE, INCOTERMS,'BALANCE' MEASURE ,PLANT_SITE_ID, YYYYMMDD
				  , SUM(ACCUM_X) AS ACCUM_X					-- [PJ2025-50188] 40 사업부의 경우 CELL_PROD_SITE_ID 단위로 구분되어 있으므로 SUM으로 처리함. / 그 외 사업부는 1줄씩만 있으므로 SUM이든 아니든 상관없음
				,'BALANCE_MAKE',GETDATE(),'BALANCE_MAKE',GETDATE(), NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
			FROM  #T2_CUTOFF_TEMPX
				WHERE 1=1
					AND ACCUM_X BETWEEN -9999999999 AND 9999999999  -- 오버플로우 예방
					AND ACCUM_X <> 0                                -- ZERO 값은 불필요
			GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID,ITEM_ID, DOM_EXP,FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD
			---------------------------------- 계산된 BALANCE값 INSERT (END)


			IF @p_division_id = '40'
			BEGIN
				--PRINT N'BALANCE DM_PLN_CFM_MKT_DEMAND_PLAN_C DELETE                =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
				----------------------------------------------------------|
				---------------------------------- 초기화 (START)
				DELETE FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN_C
					where MEASURE		= 'BALANCE'
					and		DIVISION_ID			= @p_division_id
					AND     VERSION_NO			= @p_cut_off_version
					AND     cutoff_type			= @c_cutoff_TYPE
					and     cutoff_yyyymmdd     = @c_cutoff_yyyymmdd
				---------------------------------- 초기화 (END)
					

				--PRINT N'BALANCE DM_PLN_MKT_FCST_C insert                =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
				----------------------------------------------------------|
				---------------------------------- 계산된 BALANCE값 INSERT (START)
				INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
							( DIVISION_ID,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
							,PROJECT_CODE
							,END_CUSTOMER
							,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
							,INCOTERMS,MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID, YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
							,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
							,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							)
				SELECT  DIVISION_ID ,@P_CUT_OFF_VERSION,@C_CUTOFF_TYPE,@C_CUTOFF_YYYYMMDD
					, PROJECT_CODE
					, PROJECT_CODE	AS END_CUSTOMER 
					, SCM_SITE_ID,ITEM_ID, DOM_EXP,FCST_TYPE, INCOTERMS,'BALANCE' MEASURE ,PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, ACCUM_X
					,'BALANCE_MAKE',GETDATE(),'BALANCE_MAKE',GETDATE(), NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
				FROM  #T2_CUTOFF_TEMPX
					WHERE 1=1
						AND ACCUM_X BETWEEN -9999999999 AND 9999999999  -- 오버플로우 예방
						AND ACCUM_X <> 0                                -- ZERO 값은 불필요
				---------------------------------- 계산된 BALANCE값 INSERT (END)

			END
			
		END

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                MKT_FCST CUTOFF QTY_BALANCE_CREATE (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎


		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                                  VMI DIO 계산로직 (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		BEGIN

		--PRINT 'DM_PLN_MKT_FCST VMI_DIO DELETE START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|

			IF @p_division_id = '40' 
			BEGIN

				-- 수행전 삭제
				DELETE 
				FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN_C
					where MEASURE = 'VMI_DIO'
						and		DIVISION_ID		  = @p_division_id
						and     VERSION_NO		  = @p_cut_off_version
						and     cutoff_type		  = @c_cutoff_TYPE
						and     cutoff_yyyymmdd   = @c_cutoff_yyyymmdd

				-- VMI_DIO INSERT
				insert into dbo.DM_PLN_CFM_MKT_DEMAND_PLAN_C
				(	 DIVISION_ID
					,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
					,PROJECT_CODE,END_CUSTOMER,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS,MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE		-- [PJ2025-50017] 추가
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				)
				select   distinct
						 a.DIVISION_ID
						,a.VERSION_NO,a.CUTOFF_TYPE,a.CUTOFF_YYYYMMDD
						,a.PROJECT_CODE
						,a.END_CUSTOMER
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
									from DM_PLN_CFM_MKT_DEMAND_PLAN_C b with(nolock)
									where   a.division_id   = b.division_id
										and a.project_code  = b.project_code
										and a.END_CUSTOMER  = b.END_CUSTOMER
										and a.scm_site_id   = b.scm_site_id
										and a.item_id       = b.item_id
										and a.dom_exp       = b.dom_exp
										and a.fcst_type     = b.FCST_TYPE
										and a.incoterms     = b.incoterms
										and a.PLANT_SITE_ID = b.plant_site_id
										and a.CELL_PROD_SITE_ID = b.CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
										and b.measure       = 'RTF_SCP'
										and b.yyyymmdd      > a.[YYYYMMDD]
										and	b.DIVISION_ID		= @p_division_id
										and b.VERSION_NO		= @p_cut_off_version
										and b.cutoff_type		= @c_cutoff_TYPE
										and b.cutoff_yyyymmdd   = @c_cutoff_yyyymmdd
								) zz
							where accum_sum >= a.qty
						) as datetime )  ) , 999 ) QTY
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					from DM_PLN_CFM_MKT_DEMAND_PLAN_C a with(nolock)
						inner join #T2_VMI_MST_MAIN s
						on (            A.division_id        =   s.division_id      
									AND A.project_code       =   s.project_code   
									AND A.scm_site_id        =   s.scm_site_id  
									AND A.item_id            =   s.item_id      
									AND A.dom_exp            =   s.dom_exp      
									AND A.fcst_type          =   s.fcst_type    
									AND A.incoterms          =   s.incoterms    
									AND A.plant_site_id      =   s.plant_site_id
									AND A.CELL_PROD_SITE_ID  =   s.CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
									AND A.yyyymmdd           >=   @plan_start_yyyymmdd  -- 월요일
									)
					where 1=1
					and a.measure = 'VMI_Inv'
					and a.qty > 0 
					and	a.DIVISION_ID		= @p_division_id
					and a.VERSION_NO		= @p_cut_off_version
					and a.cutoff_type		= @c_cutoff_TYPE
					and a.cutoff_yyyymmdd   = @c_cutoff_yyyymmdd

			END
			ELSE
			BEGIN

				-- 수행전 삭제
				DELETE 
				FROM dbo.DM_PLN_MKT_FCST_C
					where MEASURE = 'VMI_DIO'
						and		DIVISION_ID		  = @p_division_id
						and     VERSION_NO		  = @p_cut_off_version
						and     cutoff_type		  = @c_cutoff_TYPE
						and     cutoff_yyyymmdd   = @c_cutoff_yyyymmdd

				-- VMI_DIO INSERT
				insert into dbo.DM_PLN_MKT_FCST_C
				(	 DIVISION_ID
					,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
					,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				)
				select   distinct
						 a.DIVISION_ID
						,a.VERSION_NO,a.CUTOFF_TYPE,a.CUTOFF_YYYYMMDD
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
									from DM_PLN_MKT_FCST_C b with(nolock)
									where   a.division_id   = b.division_id
										and a.project_code  = b.project_code
										and a.scm_site_id   = b.scm_site_id
										and a.item_id       = b.item_id
										and a.dom_exp       = b.dom_exp
										and a.fcst_type     = b.FCST_TYPE
										and a.incoterms     = b.incoterms
										and a.PLANT_SITE_ID = b.plant_site_id
										and b.measure       = 'RTF_SCP'
										and b.yyyymmdd      > a.[YYYYMMDD]
										and	b.DIVISION_ID		= @p_division_id
										and b.VERSION_NO		= @p_cut_off_version
										and b.cutoff_type		= @c_cutoff_TYPE
										and b.cutoff_yyyymmdd   = @c_cutoff_yyyymmdd
								) zz
							where accum_sum >= a.qty
						) as datetime )  ) , 999 ) QTY
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					from DM_PLN_MKT_FCST_C a with(nolock)
						inner join #T2_VMI_MST_MAIN s
						on (            A.division_id        =   s.division_id      
									AND A.project_code       =   s.project_code   
									AND A.scm_site_id        =   s.scm_site_id  
									AND A.item_id            =   s.item_id      
									AND A.dom_exp            =   s.dom_exp      
									AND A.fcst_type          =   s.fcst_type    
									AND A.incoterms          =   s.incoterms    
									AND A.plant_site_id      =   s.plant_site_id
									AND A.yyyymmdd           >=   @plan_start_yyyymmdd  -- 월요일
									)
					where 1=1
					and a.measure = 'VMI_Inv'
					and a.qty > 0 
					and	a.DIVISION_ID		= @p_division_id
					and a.VERSION_NO		= @p_cut_off_version
					and a.cutoff_type		= @c_cutoff_TYPE
					and a.cutoff_yyyymmdd   = @c_cutoff_yyyymmdd

			END

		END
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                                  VMI DIO 계산로직 (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                      Sales Plan  Cutoff 정보 변경 (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- 트랜잭션 (COMMIT)
    --COMMIT WORK;

		BEGIN	
			-- [PJ2025-50188] 임시테이블 #T2_MKT_FCST DROP 추가, 임시테이블 #T2_MKT_FCST ==> #T_MF_C_BALANCE_MKT_FCST 변경
			IF OBJECT_ID (N'tempdb..#T_MF_C_BALANCE_MKT_FCST', N'U') IS NOT NULL 
				DROP TABLE #T_MF_C_BALANCE_MKT_FCST

			-- [PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V DROP
			--IF OBJECT_ID (N'tempdb..#T2_SCP_PLN_RTF_ALLOCATION_V', N'U') IS NOT NULL 
			--	DROP TABLE #T2_SCP_PLN_RTF_ALLOCATION_V

			-- [PJ2025-50188] 임시테이블 #T2_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_C_RTF_ALLOCATION 이름변경
			IF OBJECT_ID (N'tempdb..#T_MF_C_RTF_ALLOCATION', N'U') IS NOT NULL 
				DROP TABLE #T_MF_C_RTF_ALLOCATION
			-- [PJ2025-50188] EE_FN 분기 로직 통합처리 (EE_FN 분기에 따른 부분은 임시테이블에 지정하는 Measure로 구분함)
			IF OBJECT_ID (N'tempdb..#T_MEASURE_MF_ALL', N'U') IS NOT NULL 
				DROP TABLE #T_MEASURE_MF_ALL
			IF OBJECT_ID (N'tempdb..#T_MEASURE_VMI_RTF', N'U') IS NOT NULL 
				DROP TABLE #T_MEASURE_VMI_RTF
			IF OBJECT_ID (N'tempdb..#T_MEASURE_RTF', N'U') IS NOT NULL 
				DROP TABLE #T_MEASURE_RTF
		END




	--------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	--ROLLBACK TRANSACTION MKT_FCST_C_QTY_BALANCE_CREATE;

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
    SET @v_description = N'@p_division_id : ' + RTRIM(LTRIM(@p_division_id)) +' / ' + N'@p_cut_off_version : ' + RTRIM(LTRIM(@p_cut_off_version)) ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	ERR_RTN:
	IF @v_log_type = 'INVALID'
		begin
			--ROLLBACK TRANSACTION MKT_FCST_C_QTY_BALANCE_CREATE
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		end
  END;
