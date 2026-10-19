/*
 * Program ID   : PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE_ESS
 * Description  : 
 * Program History
 *============================================================================================================
 *   Date       In Charge              Description
 *============================================================================================================
 * 2018.10.10   KHSONG                 Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * -----------------------------------------------------------------------------------------------------------
 * PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 에서 호출되는 Procedure로 Cufoff 테이블 관련처리를 수행함
 * 20190624 KHSONG [CSR_ID:4016234]자동차전지 사업부 RTF(Manual 입력) 메져 추가건 적용 
 *                 -> @p_division_id 으로 RTF_SCP 수행되므로 특별히 수정할부분은 없음
 * 20190709 KHSONG [CSR ID:4027463] RTF_System[R+P] Measure 추가 요청의 건
** 20190709 KHSONG [CSR ID:4034895] 상품 매출에 대한 마케팅의 RTF[R+P] 수정 권한 요청 및 MKT FCST 기본값 삭제 요청 (자동차사업부)
** 20190809 KHSONG [CSR ID:4059971] VMI-In Request 로직 변경
** 20190903 KHSONG [CSR ID:4066366] Sales Plan Waterfall 화면 메져값 수정
** 20191016 KHSONG 'RTF_SCP'Measure로 Sales Amt를 계산하던 오류를 'RTF'Measure로 수정함
** 20191028 KHSONG Cutoff Version 'RTF' Measure 삭제 오류로직 수정
** 20191104 KHSONG [CSR ID:4107133] VMI대상 RTF_SYS_RP MEASURE 생성로직 추가
** 20200213 HWI1993 자동차 사업부의 경우 'RTF_SCP'Measure로 Sales Amt를 계산하도록 수정
** 20200416 KHSONG C20200413-000593 ESS사업부 RTF Measure 추가 (scp plan 수행시 모든사업부가 이 Procedure 로 호출됨)
** 20200507 KHSONG C20200507-000035 (소형사업부 RTF 관련 Measure 숨기기)
*  20200615 hwi1993 C20200518-000359 GSCM RMA값 표기 로직 수정 요청의 건
*  20200701 P.C.I   [PJ20200138] Sales Plan Waterfall cut-off 주기 변경 - MKT_FCST_C/SALES_PLAN_C 분리
                    PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE_ESS_40 -> PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE_ESS 명칭 변경
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2020/11/13	hwi1993		[C20201103-000114] [SCM PI팀] ESS 사업부 판매 법인 VMI biz의 MKT FCST 입력 시 VMI in req 자동산출 로직 적용의 건 
 * 2020/12/08     P.C.I		[C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용
 * 2020.12.23	hwi1993		[C20201222-000376] VMI Inv 메저 수량 표시
 * 2021/3/29	hwi1993		[C20210323-000456] ESS 판매법인 VMI LT 반영
 * 2021/05/11     P.C.I		[C20210511-000221] 자동차 전극 RTF 적용
 * 2021/07/08	SJHAN		[C20210705-000574] Google 반품(RMA) Sales Amount 조회 기능 요청
 * 2021/08/23	hwi1993		[중장기] 52주를 82주로 변경
 * 2021.11.09	HWI1993		[과제]W/S, CUTOFF 버전에 AS RTF 를 업데이트 하도록 프로시저 호출 추가
 * 2022-03-29   kdw2819     [C20220224-000448] ESS 사업부 VMI 기능 자동차사업부 확산 전개 요청 (VMI_IN_PLAN 으로 RTF 생성)
 * 2022.04.05   hwi1993     GM JV 작업
 * 2022.06.17	kdw2819		[C20220615-000414] RESU16H_Prime RTF 에러의 건
 * 2022.06.30	HWI1993		[C20220615-000093] [영업마케팅PI] MKT_FCST Waterfall 內 SaftyStock LevelGap measure 추가 요청 건
 * 2022.07.20	HWI1993		[C20220615-000414] RESU16H_Prime RTF 에러의 건 - RTF 중복오류 수정
 * 2022.10.17	rosia27		[C20221004-000309] ERP 피킹실적 VMI In plan(R+P) 실적 반영 요청 건
   2022.12.02		hwi1993		[C20221104-000430] UC법인 MKT FCST화면의 'Balance' Measure 로직 변경 요청의 件
   2022.12.06		HWI1993		[C20221207-000259] VMI 재고 계산시 소형사업부만 11자리 LIKE 먹도록 변경
	2022.12.07		hwi1993		[C20221207-000280] 원복 [C20221004-000309]
 * 2023-01-17   chano0612   [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건 - 선박BIZ건
** -----------------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE_ESS]

	-- Add the parameters for the stored procedure here
	@p_division_id				NVARCHAR(30)  -- DIVISION_ID
   ,@p_cut_off_version          NVARCHAR(18)  -- MKT_FCST_C의 Version

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE_ESS';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

    DECLARE @plan_start_yyyymmdd          NVARCHAR(08);
    DECLARE @c_plan_id                    NVARCHAR(20);
    DECLARE @c_cutoff_yyyymmdd			  NVARCHAR(08);
    DECLARE @c_cutoff_TYPE				  NVARCHAR(04);
    DECLARE @c_SP_TYPE					  NVARCHAR(04);
    DECLARE @c_SP_version				  NVARCHAR(18);
    DECLARE @c_plan_id_ee                 NVARCHAR(20); --[C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용(자동차 전극 : W-1)
	DECLARE @plan_week_cnt				  INT;			-- 중장기 계획 주차 기간
	-------------------------------------------------------------------------------------------------------------------------------------------	
	-- 변수값 셋팅
	-------------------------------------------------------------------------------------------------------------------------------------------	
	SELECT @c_cutoff_yyyymmdd = YYYYMMDD
	FROM DM_MST_VERSION
	WHERE DIVISION_ID = @P_DIVISION_ID
		AND VERSION_NO = @P_CUT_OFF_VERSION

	SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(@c_cutoff_yyyymmdd, 'MON')), 112)   -- 월요일
	SET @c_cutoff_TYPE		 = SUBSTRING(@p_cut_off_version,1,4)
	SET @c_SP_TYPE			 = 'SP'+ SUBSTRING(@c_cutoff_TYPE,3,2)        -- SALES PLAN 용
	SET @c_SP_version		 = 'SP'+ SUBSTRING(@p_cut_off_version,3,16)   -- SALES PLAN 용
	SET @c_plan_id			 = ISNULL((SELECT MAX(plan_id) FROM [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCP_PLN_RTF_ALLOCATION_V] WITH(NOLOCK)  WHERE division_id = @p_division_id and plan_start_yyyymmdd <= @plan_start_yyyymmdd ),'')  -- plan_id 추출
	
	DECLARE @c_scp_rtf_flag 		      NVARCHAR(02); --[C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 MKT Fcst에 RTF를 업데이트 하지 않음
    DECLARE @max_plan_start_yyyymmdd	  NVARCHAR(08); --[C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용
	
	SET @c_plan_id_ee			 = ISNULL((SELECT MAX(plan_id)-1 FROM [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCP_PLN_RTF_ALLOCATION_V] WITH(NOLOCK)  WHERE division_id = @p_division_id and plan_start_yyyymmdd <= @plan_start_yyyymmdd ),'')  --[C20210511-000221] plan_id_ee 추출
	DECLARE @c_scp_rtf_flag_ee 		      NVARCHAR(02); --[C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 MKT Fcst에 RTF를 업데이트 하지 않음(자동차 전극 : W-1)
    DECLARE @max_plan_start_yyyymmdd_ee	  NVARCHAR(08); --[C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용(자동차 전극 : W-1)

	-- 중장기 계획 주차 기간
	SELECT @plan_week_cnt = ATTRIBUTE1
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
	WHERE LOOKUP_TYPE = 'DM_LONG_PLAN_WEEK_CNT'
	AND VALID_YN = 'Y'
	AND SEGMENT1 = @p_division_id

	IF ISNUMERIC(@plan_week_cnt) < 1
	BEGIN
		SET @plan_week_cnt = 54;
	END
	-------------------------------------------------------------------------------------------------------------------------------------------	

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = N'@p_division_id : ' + RTRIM(LTRIM(@p_division_id)) +' / ' + N'@p_cut_off_version : ' + RTRIM(LTRIM(@p_cut_off_version))  +' / ' + N'@c_plan_id : ' + RTRIM(LTRIM(@c_plan_id))   ;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	--BEGIN TRANSACTION MKT_FCST_C_QTY_BALANCE_CREATE;

	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------	
	
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                                TEMP TABLE SETTING (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		BEGIN
		-------
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
				
				-- 임시확인테이블 사용시
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




			CREATE TABLE  #T2_CUTOFF_MST
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
				)

			CREATE CLUSTERED INDEX [IDX_T_CUTOFF_MST_N1] ON [#T2_CUTOFF_MST]
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
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
			;

			CREATE TABLE  #T2_CUTOFF_MST_ACCUM
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
				,ACCUM_SUM		NUMERIC(30,10) NOT NULL
				)
			CREATE CLUSTERED INDEX [IDX_T_CUTOFF_MST_ACCUM] ON [#T2_CUTOFF_MST_ACCUM]
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
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
			;

			CREATE TABLE  #T2_CUTOFF_TEMPX
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
			,ACCUM_X		NUMERIC(30,10) NOT NULL
			)

			CREATE CLUSTERED INDEX [IDX_CUTOFF_TEMPX_N1] ON [#T2_CUTOFF_TEMPX]
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
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			;
			CREATE TABLE  #T2_VMI_MST
			(
			DIVISION_ID	NVARCHAR(30) NOT NULL
			,PROJECT_CODE	NVARCHAR(50) NOT NULL
			,SCM_SITE_ID	NVARCHAR(30) NOT NULL
			,ITEM_ID		NVARCHAR(50) NOT NULL
			,DOM_EXP		NVARCHAR(03) NOT NULL
			,FCST_TYPE		NVARCHAR(20) NOT NULL
			,INCOTERMS		NVARCHAR(10) NOT NULL
			,PLANT_SITE_ID NVARCHAR(30) NOT NULL
			,MEASURE		NVARCHAR(50) NOT NULL
			,YYYYMMDD		NVARCHAR(08) NOT NULL
			,QTY			NUMERIC(30,10) NOT NULL
			);

			CREATE TABLE  #T2_VMI_MST_MAIN
			(DIVISION_ID	NVARCHAR(30) NOT NULL
			,PROJECT_CODE	NVARCHAR(50) NOT NULL
			,SCM_SITE_ID	NVARCHAR(30) NOT NULL
			,ITEM_ID		NVARCHAR(50) NOT NULL
			,DOM_EXP		NVARCHAR(03) NOT NULL
			,FCST_TYPE		NVARCHAR(20) NOT NULL
			,INCOTERMS		NVARCHAR(10) NOT NULL
			,PLANT_SITE_ID NVARCHAR(30) NOT NULL
			,MEASURE		NVARCHAR(50) NOT NULL
			,YYYYMMDD		NVARCHAR(08) NOT NULL
			,QTY			NUMERIC(30,10) NOT NULL
			);

			CREATE TABLE  #T2_VMI_TEMP1
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
			,last_accum_sum	NUMERIC(30,10) NOT NULL
			)

			CREATE CLUSTERED INDEX [IDX_40_TEMP1_N1] ON [#T2_VMI_TEMP1]
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
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			;
			CREATE TABLE  #T2_VMI_TEMP2
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
			,last_accum_sum	NUMERIC(30,10) NOT NULL
			)

			CREATE CLUSTERED INDEX [IDX_40_TEMP2_N1] ON [#T2_VMI_TEMP2]
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
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			;
			CREATE TABLE  #T2_VMI_TEMP_all
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
			)

			CREATE CLUSTERED INDEX [IDX_40_TEMP_all_N1] ON [#T2_VMI_TEMP_all]
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
			)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			;
						
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

		END

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                                TEMP TABLE SETTING (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                 MKT_FCST, RTF 대상 날짜및 값 추출 (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		---------------------------------- RTF MEASURE MKT_FCST TABLE INSERT (START)
		BEGIN
		
			--Start [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용
			SET @max_plan_start_yyyymmdd = ISNULL(( SELECT MAX(plan_start_yyyymmdd) 
													FROM [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCP_PLN_RTF_ALLOCATION_V] WITH(NOLOCK)
													WHERE division_id = @p_division_id
													AND   plan_id	  = @c_plan_id),'')
													
			SET @c_scp_rtf_flag = ( SELECT ISNULL(MAX(dm_rtf_yn), 'Y')
									FROM   DBO.scp_pln_interface_yn with(nolock)
									WHERE  division_id         = @p_division_id
									AND    plan_start_yyyymmdd = @max_plan_start_yyyymmdd);

			IF (@c_scp_rtf_flag = 'N') 			
				BEGIN
					-- [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용
					SET @c_plan_id =  (select MAX(PLAN_ID)
										from   DBO.SCM_MST_PLAN with(nolock)
										where  division_id = @p_division_id
										and    plan_cycle  = 'WEEKLY'
										and    PLAN_NAME   = (SELECT MAX(plan_start_yyyymmdd)
																FROM   DBO.scp_pln_interface_yn with(nolock)
																WHERE  division_id         = @p_division_id
																AND    plan_start_yyyymmdd < @max_plan_start_yyyymmdd
																AND    dm_rtf_yn		   = 'Y' ))


					SET @v_log_type = 'ING';
					SET @v_log_message = N'SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용';
					SET @v_description = '@p_division_id : ' + ISNULL(@p_division_id,'NULL') + ' / ' + '@c_plan_id : ' + ISNULL(@c_plan_id,'NULL');
					SET @d_event_date = SYSDATETIME();
					EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

				END
			--End [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용
			
			--Start [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용(자동차 전극 : W-1)
			SET @max_plan_start_yyyymmdd_ee = ISNULL(( SELECT MAX(plan_start_yyyymmdd) 
													FROM [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCP_PLN_RTF_ALLOCATION_V] WITH(NOLOCK)
													WHERE division_id = 'EE'
													AND   origin_division_id = @p_division_id
													AND   plan_id	  = @c_plan_id_ee),'')
													
			SET @c_scp_rtf_flag_ee = ( SELECT ISNULL(MAX(dm_rtf_yn), 'Y')
									FROM   DBO.scp_pln_interface_yn with(nolock)
									WHERE  division_id         = 'EE'
									AND    plan_start_yyyymmdd = @max_plan_start_yyyymmdd_ee);

			IF (@c_scp_rtf_flag_ee = 'N') 			
				BEGIN
					-- [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용
					SET @c_plan_id_ee =  (select MAX(PLAN_ID)
										from   DBO.SCM_MST_PLAN with(nolock)
										where  division_id = 'EE'
										and    plan_cycle  = 'WEEKLY'
										and    PLAN_NAME   = (SELECT MAX(plan_start_yyyymmdd)
																FROM   DBO.scp_pln_interface_yn with(nolock)
																WHERE  division_id         = 'EE'
																AND    plan_start_yyyymmdd < @max_plan_start_yyyymmdd_ee
																AND    dm_rtf_yn		   = 'Y' ))


					SET @v_log_type = 'ING';
					SET @v_log_message = N'SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용(EE)';
					SET @v_description = '@p_division_id : ' + ISNULL(@p_division_id,'NULL') + ' / ' + '@c_plan_id_ee : ' + ISNULL(@c_plan_id_ee,'NULL');
					SET @d_event_date = SYSDATETIME();
					EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

				END
			--End [C20210511-000221] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용(자동차 전극 : W-1)

			
			SET @v_log_type = 'ING';
			SET @v_log_message = N'Plan ID';
			SET @v_description = '@p_division_id : ' + ISNULL(@p_division_id,'NULL') + ' / ' + ' / @c_plan_id : ' + ISNULL(@c_plan_id,'NULL') + ' / @c_plan_id_ee : ' + ISNULL(@c_plan_id_ee,'NULL');
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			--PRINT N'mkt_fcst  Cutoff RTF insert START               =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|
			DELETE FROM DM_PLN_MKT_FCST_C
				WHERE MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_In_Plan', 'AS_In_Plan','SS_LVL', 'SS_GAP')  -- 20190709 KHSONG [CSR ID:4027463] 'RTF_SYS_RP' MEASURE 추가
				and		DIVISION_ID			= @p_division_id
				AND     VERSION_NO			= @p_cut_off_version
				AND     cutoff_type			= @c_cutoff_TYPE
				and     cutoff_yyyymmdd     = @c_cutoff_yyyymmdd

				--SELECT @p_division_id,@c_plan_id,@plan_start_yyyymmdd,@p_cut_off_version,@c_cutoff_TYPE,@c_cutoff_yyyymmdd
				
			--[C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용				   
			DELETE FROM DM_PLN_MKT_FCST_C
			WHERE MEASURE IN ( 'RTF')
			and		DIVISION_ID			= @p_division_id
			AND     VERSION_NO			= @p_cut_off_version
			AND     cutoff_type			= @c_cutoff_TYPE
			and     cutoff_yyyymmdd     = @c_cutoff_yyyymmdd
			and     DIVISION_ID = '82'

			-----------------------------------------------------------------------
			
			SELECT		 distinct
						 a.DIVISION_ID
						,@p_cut_off_version AS VERSION_NO
						,@c_cutoff_TYPE     AS CUTOFF_TYPE
						,@c_cutoff_yyyymmdd AS CUTOFF_YYYYMMDD
						,a.PROJECT_CODE
						,a.SALES_SITE_ID AS SCM_SITE_ID
						,a.ITEM_ID
						,a.DOM_EXP
						,a.FCST_TYPE
						,a.INCOTERMS
						,CASE  WHEN  c.VMI_YN = 'Y' AND A.DIVISION_ID in ('82','40') THEN 'VMI_In_Plan'
								WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
								ELSE 'RTF_SCP'  END MEASURE --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
						--,PLANT_SITE_ID 
						,CASE WHEN a.DIVISION_ID in ('82','40') THEN '' ELSE a.PLANT_SITE_ID END PLANT_SITE_ID
						,a.YYYYMMDD 
						,SUM(a.ALLOCATION_QTY) QTY
						,'SYSTEM'  CREATED_BY
						,GETDATE() CREATION_DATE
						,'SYSTEM'  LAST_UPDATED_BY
						,GETDATE() LAST_UPDATE_DATE
			INTO #T2_MKT_FCST_INSERT  -- 20190709 KHSONG [CSR ID:4027463] 임시테이블에 넣고 MEASURE 추가할 용도임
			FROM [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCP_PLN_RTF_ALLOCATION_V] a WITH(NOLOCK)
   			inner join [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCM_MST_SITE] C WITH(NOLOCK)
			on( a.division_id        =   C.division_id      
			AND a.sales_site_id      =   C.scm_site_id )
			WHERE a.DIVISION_ID          = @p_division_id
			and a.plan_id            = @c_plan_id
			and YYYYMMDD			>= @plan_start_yyyymmdd
			GROUP BY a.DIVISION_ID , a.PROJECT_CODE, a.SALES_SITE_ID,a.ITEM_ID, a.DOM_EXP,a.FCST_TYPE, a.INCOTERMS, CASE WHEN a.DIVISION_ID in ('82','40')  THEN '' ELSE a.PLANT_SITE_ID END, a.YYYYMMDD,c.VMI_YN,C.OPERATION_GROUP
			-- 상품인 건에 대해서는 RTF를 MKT FCST와 동일하게 생성 함.

			--Start [C20210511-000221] 자동자 전극 RTF 적용 (자동차 전극 RTF 적용)			
			UNION ALL
						
			SELECT		 distinct
						 a.ORIGIN_DIVISION_ID AS DIVISION_ID
						,@p_cut_off_version AS VERSION_NO
						,@c_cutoff_TYPE     AS CUTOFF_TYPE
						,@c_cutoff_yyyymmdd AS CUTOFF_YYYYMMDD
						,a.PROJECT_CODE
						,a.SALES_SITE_ID AS SCM_SITE_ID
						,a.ITEM_ID
						,a.DOM_EXP
						,a.FCST_TYPE
						,a.INCOTERMS
						,CASE  WHEN  C.VMI_YN = 'Y' and a.DIVISION_ID in ('82','40') THEN 'VMI_In_Plan'
								WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan' 
								ELSE 'RTF_SCP'  END MEASURE --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
						--,PLANT_SITE_ID 
						,CASE WHEN a.DIVISION_ID in ('82','40') THEN '' ELSE a.PLANT_SITE_ID END PLANT_SITE_ID
						,a.YYYYMMDD 
						,SUM(a.ALLOCATION_QTY) QTY
						,'SYSTEM'  CREATED_BY
						,GETDATE() CREATION_DATE
						,'SYSTEM'  LAST_UPDATED_BY
						,GETDATE() LAST_UPDATE_DATE
			FROM [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCP_PLN_RTF_ALLOCATION_V] a WITH(NOLOCK)
   			inner join [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCM_MST_SITE] C WITH(NOLOCK)
			on( a.ORIGIN_DIVISION_ID	=   C.division_id      
			AND a.sales_site_id			=   C.scm_site_id )
			WHERE a.DIVISION_ID			= 'EE'
			--and a.ORIGIN_DIVISION_ID	= '81'
			and a.ORIGIN_DIVISION_ID	= @p_division_id
			and a.plan_id				= @c_plan_id_ee
			and YYYYMMDD			   >= @plan_start_yyyymmdd
			GROUP BY a.ORIGIN_DIVISION_ID , a.PROJECT_CODE, a.SALES_SITE_ID,a.ITEM_ID, a.DOM_EXP,a.FCST_TYPE, a.INCOTERMS, CASE WHEN a.DIVISION_ID in ('82','40')  THEN '' ELSE a.PLANT_SITE_ID END, a.YYYYMMDD,c.VMI_YN, C.OPERATION_GROUP			
                , a.division_id
			--End [C20210511-000221] 자동자 전극 RTF 적용

			UNION ALL

			select  
					 a.[DIVISION_ID]
					,a.VERSION_NO,a.CUTOFF_TYPE,a.CUTOFF_YYYYMMDD
					,a.[PROJECT_CODE]
					,a.[SCM_SITE_ID]
					,a.[ITEM_ID]
					,a.[DOM_EXP]
					,a.[FCST_TYPE]
					,a.[INCOTERMS]
					,CASE  WHEN  c.VMI_YN = 'Y' AND A.DIVISION_ID in ('82','40') THEN 'VMI_In_Plan' 
							WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
							ELSE 'RTF_SCP'  END  --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
					,a.[PLANT_SITE_ID]
					,a.[YYYYMMDD]
					,SUM( A.QTY ) QTY
						,'SYSTEM'  CREATED_BY
						,GETDATE() CREATION_DATE
						,'SYSTEM'  LAST_UPDATED_BY
						,GETDATE() LAST_UPDATE_DATE
				from DM_PLN_MKT_FCST_C a WITH(NOLOCK)
				inner join [DBO].[DM_MST_ITEM_SINGLE_V] b WITH(NOLOCK)
					on (a.division_id		= b.division_id
					and a.item_id			= b.item_id)
   				inner join [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCM_MST_SITE] C WITH(NOLOCK)
						on( a.division_id        =   C.division_id      
						AND a.SCM_SITE_ID        =   C.scm_site_id )
				where 1=1
					and  A.DIVISION_ID		= @p_division_id
					AND  A.VERSION_NO		= @p_cut_off_version
					AND  A.cutoff_type		= @c_cutoff_TYPE
					and  A.cutoff_yyyymmdd  = @c_cutoff_yyyymmdd
					and  a.measure			= CASE  WHEN  c.VMI_YN = 'Y' AND A.DIVISION_ID in ('82','40') THEN 'VMI_In_Req' 
													WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
													ELSE 'MKT_FCST'  END -- VMI = 'Y'인경우에만 VMI_In_Req 'N'이면 MKT_FCST 사용 --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
					-- 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
					-- [C20210511-000221] 상품인 경우에 RTF를 MKT_FCST와 동일하게 생성
					and (b.item_type in ('Q' , 'R' ) /*OR ( a.item_id in ( select k.item_id from scm_mst_item_sn k  WITH (NOLOCK) where k.division_id = a.division_id and k.SCP_OPERATION_GROUP = 'E'  )  )*/)
					--AND a.division_id IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895] DIVISION_ID 구분으로 추가
					
				group by a.[DIVISION_ID]
				    ,a.VERSION_NO,a.CUTOFF_TYPE,a.CUTOFF_YYYYMMDD
					,a.[PROJECT_CODE]
					,a.[SCM_SITE_ID]
					,a.[ITEM_ID]
					,a.[DOM_EXP]
					,a.[FCST_TYPE]
					,a.[INCOTERMS]
					,CASE  WHEN  c.VMI_YN = 'Y' AND A.DIVISION_ID in ('82','40') THEN 'VMI_In_Plan' 
							WHEN C.OPERATION_GROUP = 'W' THEN 'AS_In_Plan'
							ELSE 'RTF_SCP'  END --[CSR ID:4059971] 20190809 KHSONG ESS사업부 추가
					,a.[PLANT_SITE_ID]
					,a.[YYYYMMDD]

					
				UNION ALL
				-- RMA 처리 C20200518-000359
				select  
					 a.[DIVISION_ID]
					,a.VERSION_NO,a.CUTOFF_TYPE,a.CUTOFF_YYYYMMDD
					,a.[PROJECT_CODE]
					,a.[SCM_SITE_ID]
					,a.[ITEM_ID]
					,a.[DOM_EXP]
					,a.[FCST_TYPE]
					,a.[INCOTERMS]
					,'RTF_SCP'
					,a.[PLANT_SITE_ID]
					,a.[YYYYMMDD]
					,A.QTY
					,'SYSTEM'  CREATED_BY
					,GETDATE() CREATION_DATE
					,'SYSTEM'  LAST_UPDATED_BY
					,GETDATE() LAST_UPDATE_DATE
				from DM_PLN_MKT_FCST_C a WITH(NOLOCK)
				--JOIN ( SELECT 'RTF_SCP' AS MEASURE
				--		UNION ALL
				--		SELECT 'RTF_SYS_RP' AS MEASURE ) B ON 1=1
				where 1=1
					and  A.DIVISION_ID		= @p_division_id
					AND  A.VERSION_NO		= @p_cut_off_version
					AND  A.cutoff_type		= @c_cutoff_TYPE
					and  A.cutoff_yyyymmdd  = @c_cutoff_yyyymmdd
					and  a.measure			= 'MKT_FCST'
					--AND a.division_id ='40'		[C20210705-000574] Google 반품(RMA) Sales Amount 조회 기능 요청 - ESS 82 사업부 포함을 위해 주석 처리 
					AND A.FCST_TYPE = 'RMA'
					
			-----------------------------------------------------------------------------------------
			-- [C20210323-000456] ESS 판매법인의 VMI_IN_PLAN 에 대해서 5영업일 뒤로 미뤄줌
/*
			UPDATE A
			SET YYYYMMDD = DBO.FN_GET_BIZ_DAY(A.YYYYMMDD, B.LT_CNT)
			FROM #T2_MKT_FCST_INSERT A
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
				*/

			-----------------------------------------------------------------------------------------
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
						FROM DM_PLN_MKT_FCST_C A
						WHERE A.YYYYMMDD >= @plan_start_yyyymmdd
						AND A.MEASURE IN ( 'MKT_FCST', 'RTF_SYS_RP', 'VMI_IN_REQ', 'AS_IN_REQ', 'BNP_IN' )
						AND A.DIVISION_ID = @p_division_id
						AND A.VERSION_NO = @p_cut_off_version
						) A
					) A
				WHERE ROW_NUM = 1

							
				DECLARE @V_STOCK_SEQ INT
				SELECT @V_STOCK_SEQ = MAX(SEQ)
				FROM SCP_ANL_PSI_GLOBAL_V 
				WHERE DIVISION_ID = @p_division_id
					AND PLAN_START_YYYYMMDD = @plan_start_yyyymmdd
				AND PLAN_TYPE = 'FN'

				INSERT INTO #T2_MKT_FCST_INSERT ( DIVISION_ID
					,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
					,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE )
				SELECT A.DIVISION_ID
					,@p_cut_off_version AS VERSION_NO
					,@c_cutoff_TYPE     AS CUTOFF_TYPE
					,@c_cutoff_yyyymmdd AS CUTOFF_YYYYMMDD
					, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, 'MPS' AS FCST_TYPE
					, A.INCOTERMS, C.MEASURE, A.PLANT_SITE_ID, B.YYYYMMDD
					, CASE WHEN C.MEASURE = 'SS_LVL' THEN B.SAFETY_STOCK
								ELSE B.GAP
								END AS QTY
					, 'SYSTEM' AS CREATED_BY, GETDATE() AS CREATION_DATE, 'SYSTEM' AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
				FROM #T_SSLVL A
				JOIN SCP_ANL_PSI_GLOBAL_V B ON A.DIVISION_ID = B.DIVISION_ID 
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
			END

			---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




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
					,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE
				FROM #T2_MKT_FCST_INSERT
				where DIVISION_ID          = @p_division_id
					and Measure NOT IN ( 'VMI_In_Plan', 'AS_In_Plan' )
			UNION ALL
			
			SELECT   DIVISION_ID
					,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
					,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS
					,MEASURE,PLANT_SITE_ID,YYYYMMDD, SUM(QTY) AS QTY, MAX(CREATED_BY), MAX(CREATION_DATE)
					, MAX(LAST_UPDATED_BY), MAX(LAST_UPDATE_DATE)
				FROM #T2_MKT_FCST_INSERT
				where DIVISION_ID          = @p_division_id
					and Measure IN ( 'VMI_In_Plan', 'AS_In_Plan' )
			GROUP BY DIVISION_ID
					,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
					,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS
					,MEASURE,PLANT_SITE_ID,YYYYMMDD

			UNION ALL

			SELECT   DIVISION_ID
					,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
					,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS
					,'RTF_SYS_RP' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE
				FROM #T2_MKT_FCST_INSERT
					WHERE MEASURE = 'RTF_SCP'  -- 20190709 KHSONG [CSR ID:4027463] MEASURE 추가 INSERT 
					and  DIVISION_ID          = @p_division_id		
					
			UNION ALL --[C20201208-000087] ESS 'RTF'(RTF_MKT) 을 사용하지 않으나 GDW, 챔피온에서 사용하므로 'RTF_SCP'으로 대신 적용

			SELECT   DIVISION_ID
					,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
					,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS
					,'RTF' AS MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE
				FROM #T2_MKT_FCST_INSERT
					WHERE MEASURE = 'RTF_SCP'
					and  DIVISION_ID          = @p_division_id		
					AND  DIVISION_ID		  = '82'

			--[E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건으로 RTF 추가 - 선박BIZ건 START

			DECLARE @RTF_SCP_CNT INT, @RTF_CNT INT

				SELECT @RTF_SCP_CNT =  COUNT(*)
				FROM DM_PLN_MKT_FCST_C
				WHERE MEASURE = 'RTF_SCP'
				AND VERSION_NO = @p_cut_off_version
				AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
				AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')

				IF (@RTF_SCP_CNT = 0)
				BEGIN
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
					FROM DM_PLN_MKT_FCST_C
					WHERE MEASURE = 'MKT_FCST'
					AND VERSION_NO = @p_cut_off_version
					AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
					AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
				END


				SELECT @RTF_CNT =  COUNT(*)
				FROM DM_PLN_MKT_FCST_C
				WHERE MEASURE = 'RTF'
				AND VERSION_NO = @p_cut_off_version
				AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
				AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')

				IF (@RTF_CNT = 0)
				BEGIN
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
					FROM DM_PLN_MKT_FCST_C
					WHERE MEASURE = 'MKT_FCST'
					AND VERSION_NO = @p_cut_off_version
					AND DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
					AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
				END

				--SELECT * FROM #T2_MKT_FCST_INSERT
				
			--[E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건으로 RTF 추가 - 선박BIZ건 END






		END

		
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
							,[DBO].scm_mst_location l with(nolock)
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

					-- INSERT
					insert into #T2_VMI_MST_MAIN  -- 
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty)
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
													END AS QTY
												-- vmi stock qty 를 초재고로 적용 (E)
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
										INNER JOIN [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[SCM_MST_SITE] ST WITH(NOLOCK)
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
						and a.measure in ('MKT_FCST', 'Vmi_In_Plan'); -- MKT_FCST랑 VMI_IN_PLAN

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
						FROM  #T2_VMI_MST_MAIN 
						WHERE MEASURE = 'Vmi_In_Plan'
						GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP,FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					)
					INSERT INTO #T2_VMI_MST_MAIN
					SELECT  AA.DIVISION_ID
							, AA.PROJECT_CODE
							, AA.SCM_SITE_ID
							, AA.ITEM_ID
							, AA.DOM_EXP
							, AA.FCST_TYPE
							, AA.INCOTERMS
							, AA.PLANT_SITE_ID
							, 'Vmi_In_Plan' AS MEASURE
							, AA.YYYYMMDD AS YYYYMMDD, 
							CASE WHEN @plan_start_yyyymmdd = AA.YYYYMMDD  THEN BB.QTY ELSE 0 END AS QTY 
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
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty)
					SELECT a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp, a.fcst_type, a.incoterms, a.measure, a.plant_site_id, a.yyyymmdd,a.qty
						FROM #T2_VMI_MST_MAIN A
							WHERE 1=1

					--
					insert into #T2_VMI_temp1
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty,accum_sum,last_accum_sum)

					SELECT a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd, A.QTY , SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) 'accum_sum'
						,SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) - A.QTY  'last_accum_sum' 
						FROM #T2_VMI_MST A
						where a.measure		= 'MKT_FCST'
						and a.yyyymmdd		>= @plan_start_yyyymmdd

					--PRINT '#T2_VMI_temp2 INSERT START                         =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
					----------------------------------------------------------|

					insert into #T2_VMI_temp2
					(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, measure,plant_site_id,yyyymmdd,qty,accum_sum,last_accum_sum)

					SELECT a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd, A.QTY , SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) 'accum_sum'
						,SUM(A.QTY) OVER ( PARTITION BY a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id ORDER BY yyyymmdd) - A.QTY  'last_accum_sum' 
						FROM #T2_VMI_MST A
						where a.measure		= 'Vmi_In_Plan'
						and a.yyyymmdd		>= @plan_start_yyyymmdd

			---------------------------------------------------------------------------------------- 

			--PRINT '#T2_VMI_temp_all INSERT START                      =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|

			insert into #T2_VMI_temp_all
			(division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id,yyyymmdd,RTF_QTY,INV)
			select a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.plant_site_id,a.yyyymmdd
					,SUM( case when isnull(a.accum_sum,0) > isnull(b.accum_sum,0) then isnull(b.accum_sum,0) else isnull(a.accum_sum,0) end ) - SUM( case when isnull(a.last_accum_sum,0) > isnull(b.last_accum_sum,0) then isnull(b.last_accum_sum,0) else isnull(a.last_accum_sum,0) end ) RTF_QTY
					,SUM(isnull(b.accum_sum,0) - isnull(a.accum_sum,0)) INV
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
			group by a.division_id, a.project_code, a.scm_site_id, a.item_id, a.dom_exp,a.fcst_type, a.incoterms, a.measure, a.plant_site_id,a.yyyymmdd
			order by a.yyyymmdd
			;

			--PRINT 'DM_PLN_MKT_FCST VMI_Inv DELETE START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|
			---------------------------------- 초기화 (START)
			DELETE 
			FROM dbo.DM_PLN_MKT_FCST_C
				where MEASURE IN ('VMI_Inv','RTF_SCP')
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
								
			--PRINT 'DM_PLN_MKT_FCST VMI_Inv INSERT START           =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|
			---------------------------------- 계산된 VMI_Inv값 INSERT (START)
			insert into DM_PLN_MKT_FCST_C
						( DIVISION_ID
						,VERSION_NO,CUTOFF_TYPE,CUTOFF_YYYYMMDD
						,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
						,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
						,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
						,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
						)
			select division_id 
			      ,@p_cut_off_version,@c_cutoff_TYPE,@c_cutoff_yyyymmdd
				 , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'RTF_SCP' as measure ,plant_site_id, yyyymmdd
				--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
				,rtf_qty as QTY 
				,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null,null
			from  #T2_VMI_temp_all
				WHERE yyyymmdd		>= @plan_start_yyyymmdd
				AND rtf_qty > 0 

			-- 20191104 KHSONG [CSR ID:4107133] VMI대상 RTF_SYS_RP MEASURE 생성로직 추가(START)
			UNION ALL
			select division_id 
			      ,@p_cut_off_version,@c_cutoff_TYPE,@c_cutoff_yyyymmdd
				 , project_code, SCM_site_id,item_id, dom_exp,fcst_type, incoterms, 'RTF_SYS_RP' as measure ,plant_site_id, yyyymmdd
				--, CASE WHEN VMI_Inv < 0 THEN 0 ELSE VMI_Inv END  alloc_qty  -- 음수는 0으로 변경
				,rtf_qty as QTY 
				,'SYSTEM',getdate(),'SYSTEM',getdate(), null,null,null,null,null,null,null,null,null,null
			from  #T2_VMI_temp_all
				WHERE yyyymmdd		>= @plan_start_yyyymmdd
				AND rtf_qty > 0 
			-- 20191104 KHSONG [CSR ID:4107133] VMI대상 RTF_SYS_RP MEASURE 생성로직 추가(END)
			
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

			union

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

			---------------------------------- 계산된 VMI_Inv값 INSERT (END)

			--지선이 맘대로 수정하기버전
							
			UPDATE A
			SET YYYYMMDD = DBO.FN_GET_BIZ_DAY(A.YYYYMMDD, B.LT_CNT)
			FROM DM_PLN_MKT_FCST_C A
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
			AND A.yyyymmdd		>= @plan_start_yyyymmdd

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
		
		--PRINT N'BALANCE #T2_CUTOFF_MST INSERT                    =>' + CONVERT(VARCHAR(8), GETDATE(), 108)

		INSERT INTO #T2_CUTOFF_MST
				(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,PLANT_SITE_ID,MEASURE,YYYYMMDD,QTY)
		SELECT ZZ.division_id, ZZ.project_code, ZZ.scm_site_id, ZZ.item_id, ZZ.dom_exp, ZZ.fcst_type, ZZ.incoterms, ZZ.plant_site_id, ZZ.MEASURE, ZZ.YYYYMMDD, max(ISNULL(C.QTY,0))
			FROM 
			 (
			  SELECT * from 
			  (
				SELECT DISTINCT A.division_id, A.project_code, A.scm_site_id, A.item_id, A.dom_exp, A.fcst_type, A.incoterms, A.plant_site_id
					from DM_PLN_MKT_FCST_C A WITH(NOLOCK) WHERE 1=1
						AND     A.MEASURE		   IN ('MKT_FCST','RTF_SCP')
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
				LEFT JOIN DM_PLN_MKT_FCST_C C WITH(NOLOCK)
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
												and		C.DIVISION_ID		= @p_division_id
												AND     C.VERSION_NO		= @p_cut_off_version
												AND     C.cutoff_type		= @c_cutoff_TYPE
												and     C.cutoff_yyyymmdd   = @c_cutoff_yyyymmdd

		group by ZZ.division_id, ZZ.project_code, ZZ.scm_site_id, ZZ.item_id, ZZ.dom_exp, ZZ.fcst_type, ZZ.incoterms, ZZ.plant_site_id, ZZ.MEASURE,ZZ.YYYYMMDD

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		-- [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건 - 선박BIZ건--- START
		-- BALANCE_MAKE MEASURE 생성 배제

		DELETE FROM #T2_CUTOFF_MST 
		WHERE DIVISION_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')
		AND SCM_SITE_ID IN (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'DM_NET_DEMAND_EXCEPTION' AND VALID_YN = 'Y')


		-- [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건 - 선박BIZ건--- END

		INSERT into #T2_CUTOFF_MST_ACCUM
		select *, SUM(QTY) over ( partition by division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id, measure order by yyyymmdd) accum_sum
			from #T2_CUTOFF_MST

		INSERT into #T2_CUTOFF_TEMPX
		select division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id,  'BALANCE' measure, yyyymmdd,  SUM( CASE WHEN MEASURE = 'MKT_FCST' THEN 0 ELSE accum_sum END)  - SUM( CASE WHEN MEASURE = 'MKT_FCST' THEN accum_sum ELSE 0 END) AS ACCUM_X
			from #T2_CUTOFF_MST_ACCUM
		group by division_id, project_code, scm_site_id, item_id, dom_exp,fcst_type, incoterms, plant_site_id, yyyymmdd

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
		SELECT  DIVISION_ID ,@P_CUT_OFF_VERSION,@C_CUTOFF_TYPE,@C_CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID,ITEM_ID, DOM_EXP,FCST_TYPE, INCOTERMS,'BALANCE' MEASURE ,PLANT_SITE_ID, YYYYMMDD, ACCUM_X
			,'BALANCE_MAKE',GETDATE(),'BALANCE_MAKE',GETDATE(), NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
		FROM  #T2_CUTOFF_TEMPX
			WHERE 1=1
				AND ACCUM_X BETWEEN -9999999999 AND 9999999999  -- 오버플로우 예방
				AND ACCUM_X <> 0                                -- ZERO 값은 불필요
		---------------------------------- 계산된 BALANCE값 INSERT (END)


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
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                                  VMI DIO 계산로직 (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                                      Sales Plan  Cutoff 정보 변경 (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- 트랜잭션 (COMMIT)
    --COMMIT WORK;
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
