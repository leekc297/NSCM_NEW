

/*============================================================================================================================
 * Program ID  : [DMF0003_SAVE_MKT_FCST]                                                             
 * Description : MKT FCST 저장, 수정, 삭제                                                          
 * Usage       : Procedure 작성 시 참조하세요!                                                      
 * Parameter   :                                                                                    
 *=============================================================================================================================
 * Date        In Charge    Description                                                             
 *=============================================================================================================================
 * 2018.03.27	KHSONG		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2018.05.31				insert시 테이블 컬럼지정
 * 2018.06.11				MKT_FCST_QTY_BALANCE_CREATE 로직 추가
 * 2018.06.14	KHSONG		상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직 추가 (임시로직으로 차후삭제필요)
 * 2018.06.18	KHSONG		40 DIVISION 조건 추가
 * 2018.06.27	KHSONG		MKT_FCST 소형 SAVE시 VMI재고 확인후 RTF 생성 로직 개발
 * 2018.07.03	KHSONG		SCM_MST_SITE테이블의 VMI대상조건 추가
 * 2018.07.03	KHSONG		1. 저장하려는 ITEM의 11주 구간에 BOM이 없으면 값을 저장하지 못하도록 함. 
 *							BOM 이 없다고 Alert을 띄우고 ROLLBACK시킴.
 *							2. 저장하려는 SITE의 4주 구간에 SHIPTO 연결 없으면 값을 저장하지 못하도록 함. 
 *							SITE SHIP-TO가 없다고 Alert을 띄우고 ROLLBACK시킴.
 * ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
 * 2018.07.10	SKH			속도개선 수정 버전
 * ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
 * 2018.07.13   KHSONG		VMI_In_Plan 조건 추가, 당주월요일 초재고 VMI_Inv 값은 SCM_DNM_STOCK_V 에서 산출
 * 2018.07.17   KHSONG		속도개선 커서제거 로직으로 수정 (VMI재고 확인후 RTF 생성 로직)
 * 2018.07.20   KHSONG		ACTIVE_FLAG 조건추가
 * 2018.07.25   ytchoi		vmi stock qty 를 초재고로 적용
 * 2018.07.30   KHSONG		대상 Row 수가 20건 이하일 때만 수행하도록 처리
 * 2018.07.31   KHSONG		balance등 저장속도개선
 * 2018.08.06   KHSONG		2018년 10월 scp오픈전까지 vmi값이 존재하지않아 주석처리함 (ui에서 vmi RTF를 수동으로 입력가능하도록함)
 * 2018.08.10-1 KHSONG		소형은 BOM Validation 에서 제외
 * 2018.08.10-3 KHSONG		소형은 SHIP-TO Validation 에서 제외
 * 2018.08.10-2 KHSONG		소형은 BALANCE_CREATE 에서 제외 (임시)
 * 2018.08.13   KHSONG		당주 월요일이후 데이터만 대상으로 하도록 로직보완
 * 2018.08.13   ytchoi		상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직은 Div:40 소형은 제외로직 추가
 * 2018.08.16   KHSONG		DIVISION_ID = '40' PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE Procedure 호출
 * 2018.08.16   KHSONG		Unit Price가 없는 MKT_FCST validation
 * 2018.09.14-1 KHSONG		(20180810-1 KHSONG 소형은 BOM Validation 에서 제외) 부분 주석처리하여 소형도 로직적용
 * 2018.09.14-2 KHSONG		(20180810-3 KHSONG 소형은 SHIP-TO Validation 에서 제외) 부분 주석처리하여 소형도 로직적용
 * 2018.09.14				소형도 FROM_SITE 조건에 추가
 * 2018.09.17	KHSONG		fcst_type LOOKUP참조하여 출력으로 변경
 * 2018.10.02	KHSONG		BALANCE CREATE 프로시져 호출로직으로 변경
 * 2018.10.05	khsong		공백제거로직추가
 * 2018.10.11	khsong		Price가 없는 case Validation 에서 제외
 * 2018.10.12				BLOCK Model
 * 2018.10.16	KHSONG		SALES_PLAN_ADJUST_YN = 'N'인대상에 대해서는 Price Validation 에서 제외
 * 2018.11.07	KHSONG		소형 반품예정수량(RMA) fcst_type 조건추가
 * 2018.11.08				RMA FCST_TYPE 이외의 MEASURE 정수값 validation
 * 2018.11.21	KHSONG		MKT_FCST 수정시 CUST_FCST값이 수정되지 않도록 보완
 * 2019.01.15	KHSONG		SALES_TYPE_CODE 'ASF' 신규 추가 (ESS측 요청사항)
 * 2019.01.18	KHSONG		ESS인경우 ITEM INSERT 후 Unit Price validation을 위해 위치변경
 * 2019.06.14	KHSONG		김성은 책임 요청으로 'ECE0074N5-01' item bom 검증 조건에서 임시 해제시킴
 * 2019.07.08	KHSONG		김성은 책임 요청으로 item bom 검증 조건에서 임시 해제시킴
 * 2019.07.09	KHSONG		[CSR ID:4034895]  GSCM RTF[system] Measure 관련 요청건
 * 2020.03.04	KHSONG		날짜선택 오류수정
 * 2020.05.07	KHSONG		C20200507-000035 (소형사업부 RTF 관련 Measure 숨기기)
 * 2020.05.22	P.C.I		[C20200525-000296] (81 사업부) MKT Fcst 입력 시 Unit Price 체크 기준에 Plant Site 조건 추가
 * 2020.05.29	KHSONG		[C20200424-000010] (Sales Price 필수 입력 구간 관련의 건)
 * 2020.06.08	P.C.I		[C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화
 * 2020.06.15	P.C.I		[C20200615-000238] [ESS사업부] Sales Company/Plant 저장시 기준정보 재생성 로직 삭제
 * 2020.07.07	hwi1993		[C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화 -- 제품일경우에만 적용
 * 2020.07.09	P.C.I		[C20200707-000367] ESS 사업부 Sales Site Project Model validation 추가
 * 2020.07.16	hwi1993		[C20200713-000189] [VMI-in Req] 에 의해 자동계산된 mkt fcst 는 무시하고, 다시 자동계산해서 insert 함.
 * 2020.07.20	P.C.I		[C20200717-000157] ESS 사업부 Sales Site Project Model validation 추가
 * 2020.07.29	P.C.I		[C20200707-000149] 자동차- 환산정보 Validation에 제품(P), 반제품(H), 원재료(R), 상품(Q) 모두 포함
 * 2020.08.31	hwi1993		[C20200812-000104] [시스템 변경요청]  Active = ‘N’ 인 Model 도 조회되도록 변경( 미래구간 에만 적용 )
                            --> 그에따라 MKT FCST 에서 저장시 ACTIVE = 'N' 이면 저장 안되도록 변경
 * 2020.09.02	P.C.I		[C20200819-000105] VMI-In Request 입력시 Sales Price 필수 입력 Validation 추가
 * 2020.09.02	P.C.I		[C20200814-000183] RMA 수요의 MKT FCST 입력 제약 조건 제외
 * 2020.10.15	hwi1993		[C20201015-000200] VMi 원복 (원본은 C20200713-000189 ). 원복하기로 해서 프로시저는 삭제하지 않고, Agent 에서만 제거함.
 * 2020.11.03	P.C.I		[C20201103-000114] [ESS사업부] VMI In Req 자동화
 * 2020.11.27	hwi1993		[C20201103-000114] [ESS사업부] VMI In Req 자동화 - 수정버전
 * 2020.12.18	hwi1993		[C20201217-000126] ESS 판매법인 VMI inventory 수신 프로세스 수정 - MKT FCST ->VMI Req 변환기간을 52주에서 62주로 변경
 * 2020.12.22	kuni		[C20201211-000353] SALES PRICE 팝업 창 문구 변경 : Start  ~ End date
 * 2021.01.01	HWI1993		[C20200804-000123] SSP 동기화 수량보다 작은 수량으로 수정 불가 ( 소형 & MKT FCST 메저 )	
 * 2021.01.14	HWI1993		[C20210112-000446] [SCM PI팀] 소형사업부 MKT FCST - SSP 동기화 ( 초록색도 수정가능하도록 변경 )
 * 2021.02.03	KUNI		[C20210203-000427] Sales Price가 없는 MKT FCST DATA
 * 2021.02.26	P.C.I 		[C20210225-000385] 동기화, Carry Over 된 CONFIRM_ID 추가, 동기화 수량보다 작은 수량은 입력 불가(원복)
 * 2021.02.26	P.C.I 		[C20210420-000162] #RESULTS Table v_attribute4, v_attribute4 사이즈 변경
 * 2021.04.20	hwi1993		[PJ20209642R] PR Request 가 완료된 건은 수정되지 않도록 함. - 수정전 버전은 김영휘에게 문의
 * 2021.08.06	hwi1993		중장기과제 -- 특정 기간동안은 2022년 데이터 수정할 수 없도록
 * 2021.08.11	hwi1993		[C20210811-000230] NET DEMAND 생성 구간 확장
 * 2021.08.18	HWI1993		[C20210817-000420] Net Demand 구간 확장 로직 수정
 * 2021.09.29	hwi1993		[PJ20209643] AS 프로세스
 * 2021.09.29	hwi1993		[PJ20209643] AS 프로세스, SALES SITE 가 AS PLANT 일 경우 INCOTERMS 를 제한함.
 * 2021.12.15	HWI1993		[PJ20209643] AS 프로세스 - AS PLANT 향은 FROM SITE 를 넣지 않도록 변경
 * 2021.12.20	hwi1993		속도개선 버전
 * 2022.01.13	hwi1993		2차 속도개선 버전
 * 2022.01.20	HWI1993		3차 속도개선 및 로그프로시저 변경
 * 2022.01.22	HWI1993		[22년 하반기 과제] PRICE 자동화 진행 중 PRICE 유효성체크 로직이 필요한 기간보다 하루 더 들어가있어서 수정함
 * 2022.03.04	rosia27		[C20220224-000160]DM_LONG_PLAN 기능 고도화 요청의 건
 * 2022.03.30	kdw2819     [C20220328-000205] MKT FCST 입력, 저장 간 오류 확인 요청
 * 2022.04.07	rosia27		[과제PJ20216891R]GM_JV
 * 2022.04.27	hwi1993		C20220428-000211 자동차 VMI Biz 로직 수정 요청의 건 - 자동차 사업부 vmi 는 mkt fcst 메저를 사용하는 관계로 관련 로직 수정
 * 2022.07.15	rosia27		[C20220713-000194][영업마케팅PI P]GSCM DM 시스템의 각 모델별 Cell,Module,Pack 환산자 누락오류 방안 검토
 * 2022.07.27	rosia27		[C20220722-000367][영업마케팅PI]등급품(-K)자재 MKT FCST 입력 요청의 건
 * 2023.06.08	chano0612   [E20230608-000891]MKT FCST, Sales Plan 동일 Measure 실시간 연동건
 * 2023.07.18	CHANO0612   [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선
 * 2023.11.25	HMIN        [E20231020-001565] GSCM 현장설치품 DP입력 시스템/프로세스 개선 요청의 건
 * 2024.02.05	KJJ			MKT FCST 수정시 PR_DETAIL_AUTO 수량도 업데이트 (가장 마지막 줄에 DMF0070_SAVE_QTY_PR_DETAIL_AUTO 호출)
 * 2024.12.11	JSSBAE		[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청
 * 2025.03.26	JSSBAE		[E20250313-001251]_MKT FCST화면 Period 관련 조회입력 기능 개선
 * 2025.05.21   KANG.H.J	[PJ2025-50188] CELL_PROD_SITE_ID 추가 - RTF_BALANCE 계산시 40 사업부와 통일 필요
 * 2025.07.07	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.07.21	JSSBAE		[E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리
 * 2025.08.26	JSSBAE		[E20250825-000297]_SCM_DM 매출계획 BPS 전송 로직 개선
 * 2025.10.02	JSSBAE		[E20250919-001699]_Incoterms 데이터 처리 VALID 처리                 
 * 2026.02.20	JSSBAE		[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선  
 * 2026.06.09	JSSBAE		[E20260604-000994]_[생산SCM PI팀] GSCM시스템내 SCM FCST를 추가하여 기준 수요 관리를 위한 신규 개발 요청의 件
 * 2026.07.21	JSSBAE		[E20260720-000270]_DP 입력시 문제 발생 件
 *============================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0003_SAVE_MKT_FCST]
	-- Add the parameters for the stored procedure here
	  @p_active_flag		NVARCHAR(MAX)
	, @p_division_id		NVARCHAR(MAX)
	, @p_project_code		NVARCHAR(MAX)
	, @p_scm_site_id		NVARCHAR(MAX)
	, @p_item_id			NVARCHAR(MAX)
	, @p_dom_exp			NVARCHAR(MAX)
	, @p_fcst_type			NVARCHAR(MAX)
	, @p_incoterms			NVARCHAR(MAX)
	, @p_measure			NVARCHAR(MAX)
	, @p_plant_site_id  	NVARCHAR(MAX)
	, @p_yyyymmdd			NVARCHAR(MAX)
	, @p_qty				NVARCHAR(MAX)
	, @p_created_by			NVARCHAR(MAX)
	, @p_as_FROM_SITE		NVARCHAR(MAX)
	, @p_bucket				NVARCHAR(MAX)	--[E20250313-001251]_화면의 bucket 정보 받음
	, @p_authority			NVARCHAR(MAX)	--[E20260604-000994]_저장할때 로그인한 권한을 받아온다.
AS

BEGIN

print '1--' + convert(varchar(30), getdate(), 121)

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    --SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_project_code			NVARCHAR(MAX);
	DECLARE @v_scm_site_id			NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_dom_exp				NVARCHAR(MAX);
	DECLARE @v_fcst_type			NVARCHAR(MAX);
	DECLARE @v_incoterms			NVARCHAR(MAX);
	DECLARE @v_measure				NVARCHAR(MAX);
	DECLARE @v_plant_site_id		NVARCHAR(MAX);
	DECLARE @v_yyyymmdd				NVARCHAR(MAX);
	DECLARE @v_qty					NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	DECLARE @v_as_from_site			NVARCHAR(MAX);
	DECLARE @v_as_from_plant		NVARCHAR(MAX);
	DECLARE @v_max_inv_days			INT			 ;	--[C20210817-000420]	
    DECLARE @plan_start_yyyymmdd    NVARCHAR(MAX);  --20180611 KHSONG ADDED
    DECLARE @v_bucket				NVARCHAR(MAX);	--[E20250313-001251]_화면의 bucket 정보 받음

	SET @v_active_flag		= NULL;
	SET @v_division_id		= NULL;
	SET @v_project_code		= NULL;
	SET @v_scm_site_id		= NULL;
	SET @v_item_id			= NULL;
	SET @v_dom_exp			= NULL;	 
	SET @v_fcst_type		= NULL;	 
	SET @v_incoterms		= NULL;	 
	SET @v_measure			= NULL;	 
	SET @v_plant_site_id	= NULL;	 
	SET @v_yyyymmdd			= NULL;	
	SET @v_qty				= NULL;	  
	SET @v_created_by		= NULL;
	SET @v_bucket			= NULL;	--[E20250313-001251]_화면의 bucket 정보 받음

	DECLARE @read_cnt		INTEGER = 0; 
	DECLARE @read_1000_cnt	INTEGER = 0; 	
	-- LOG 용 변수 설정
	DECLARE @v_program_name NVARCHAR(150) = 'DMF0003_SAVE_MKT_FCST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 마지막 데이터 처리를 위한 구분자 추가
	SET @p_active_flag    = RTRIM(@p_active_flag   ) + '^';
	SET @p_division_id    = RTRIM(@p_division_id   ) + '^';
	SET @p_project_code   = RTRIM(@p_project_code  ) + '^';
	SET @p_scm_site_id    = RTRIM(@p_scm_site_id   ) + '^';
	SET @p_item_id        = RTRIM(@p_item_id       ) + '^';
	SET @p_dom_exp        = RTRIM(@p_dom_exp       ) + '^';
	SET @p_fcst_type      = RTRIM(@p_fcst_type     ) + '^';
	SET @p_incoterms      = RTRIM(@p_incoterms     ) + '^';
	SET @p_measure        = RTRIM(@p_measure       ) + '^';
	SET @p_plant_site_id  = RTRIM(@p_plant_site_id ) + '^';
	SET @p_yyyymmdd       = RTRIM(@p_yyyymmdd      ) + '^';
	SET @p_qty            = RTRIM(@p_qty           ) + '^';
	SET @p_created_by     = RTRIM(@p_created_by    ) + '^';
	
	-- TEMP TABLE 확인후 삭제
	IF OBJECT_ID (N'tempdb..#SEND_TARGET_DATA', N'U') IS NOT NULL 
		DROP TABLE #SEND_TARGET_DATA

	--[C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 		
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V

	--[C20200819-000105] 임시테이블 삭제
	IF OBJECT_ID (N'tempdb..#results', N'U') IS NOT NULL 		
		DROP TABLE #results
	IF OBJECT_ID (N'tempdb..#tmp_DM_PLN_MKT_FCST', N'U') IS NOT NULL 		
		DROP TABLE #tmp_DM_PLN_MKT_FCST
	IF OBJECT_ID (N'tempdb..#T_PRICE', N'U') IS NOT NULL 		
		DROP TABLE #T_PRICE
	IF OBJECT_ID (N'tempdb..#T_DISTINCT', N'U') IS NOT NULL 		
		DROP TABLE #T_DISTINCT
	IF OBJECT_ID (N'tempdb..#INVENTORY_SITE', N'U') IS NOT NULL 		
		DROP TABLE #INVENTORY_SITE

	--[E20260720-000270]_DP 입력시 문제 발생 件 (START)
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_ORI_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_ORI_V;
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_A_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_A_V;
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_B_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_B_V;	
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V_ALL', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V_ALL;	
	--[E20260720-000270]_DP 입력시 문제 발생 件 (END)


	CREATE TABLE #SEND_TARGET_DATA  
	( division_id		NVARCHAR(30)	NOT NULL
	, project_code		NVARCHAR(50)	NOT NULL
	, scm_site_id		NVARCHAR(30)	NOT NULL
	, item_id			NVARCHAR(50)	NOT NULL
	, dom_exp			NVARCHAR(3)		NOT NULL
	, fcst_type			NVARCHAR(20)	NOT NULL
	, incoterms			NVARCHAR(10)	NOT NULL
	, plant_site_id		NVARCHAR(30)	NOT NULL
	, cell_prod_site_id  NVARCHAR(30)	NULL				--	[PJ2025-50188] RTF_BALANCE 계산시 40 (CELL_PROD_SITE_ID) / 그외는 (- 로 처리)
	, vmi_yn			NVARCHAR(1)		NULL
	)
				
	CREATE TABLE #T_PRICE 
	( DIVISION_ID		NVARCHAR(30)
	, PROJECT_CODE		NVARCHAR(50)
	, SCM_SITE_ID		NVARCHAR(30)
	, PLANT_SITE_ID		NVARCHAR(30)
	, ITEM_ID			NVARCHAR(50)
	, YYYYMMDD			NVARCHAR(8)
	, CURRENCY			NVARCHAR(10)
	, MEASURE			NVARCHAR(50)
	, DOM_EXP			NVARCHAR(3)
	, FCST_TYPE			NVARCHAR(20)
	, INCOTERMS			NVARCHAR(10)
	, PRICE				NUMERIC(20,10)
	)

	-- #results TEMP TABLE 변경 20180711
	CREATE TABLE #results  
	( v_active_flag		NVARCHAR(1)		NOT NULL
	, v_division_id		NVARCHAR(30)	NOT NULL
	, v_project_code	NVARCHAR(50)	NOT NULL
	, v_scm_site_id		NVARCHAR(30)	NOT NULL
	, v_item_id			NVARCHAR(50)	NOT NULL
	, v_dom_exp			NVARCHAR(3)		NOT NULL
	, v_fcst_type		NVARCHAR(20)	NOT NULL
	, v_incoterms		NVARCHAR(10)	NOT NULL
	, v_measure			NVARCHAR(50)	NOT NULL
	, v_plant_site_id	NVARCHAR(30)	NOT NULL
	, v_yyyymmdd		NVARCHAR(8)		NOT NULL
	, v_qty				NUMERIC(30,10)	NOT NULL
	, v_created_by		NVARCHAR(150)	NULL
	, v_vmi_yn			NCHAR(1)
	, v_dio				INT			
	, v_attribute1		NVARCHAR(150)	NULL
	, v_attribute2		NVARCHAR(150)	NULL
	, v_attribute3		NVARCHAR(150)	NULL
	--[C20210420-000162] v_attribute4, v_attribute4 사이즈 변경
	, v_attribute4		NVARCHAR(MAX)	NULL --[C20210225-000385] 동기화된 CONFIRM_ID
	, v_attribute5		NVARCHAR(MAX)	NULL --[C20210225-000385] Carry Over 된 CONFIRM_ID
	, v_attribute9		NVARCHAR(150)	NULL --[PJ20209642R] ERR PR 관련 Confirm id
	, v_attribute10		NVARCHAR(150)	NULL --[PJ20209643] w/s
	, v_bom_yn			NCHAR(1)			 --[C20220722-000367][영업마케팅PI]등급품(-K)자재 MKT FCST 입력 요청의 건
	, v_bucket			NVARCHAR(30)		 --[E20250313-001251]_MKT FCST화면 Period 관련 조회입력 기능 개선
	)

	-- @@tmp_site_customer_map TEMP TABLE
	DECLARE @tmp_site_customer_map TABLE 
	( DIVISION_ID		NVARCHAR(MAX)
	, SCM_SITE_ID		NVARCHAR(MAX)
	, MEASURE			NVARCHAR(MAX)
	, START_DAY			NVARCHAR(MAX)
	, END_DAY			NVARCHAR(MAX)
	)

	-- DM_PLN_MKT_FCST 최종 insert값 TEMP TABLE
	CREATE TABLE #tmp_DM_PLN_MKT_FCST  
	( v_division_id		NVARCHAR(30)
	, v_project_code	NVARCHAR(50)
	, v_scm_site_id		NVARCHAR(30)
	, v_item_id			NVARCHAR(50)
	, v_dom_exp			NVARCHAR(03)
	, v_fcst_type		NVARCHAR(20)
	, v_incoterms		NVARCHAR(10)
	, v_measure			NVARCHAR(50)
	, v_PLANT_SITE_ID	NVARCHAR(30)
	, v_yyyymmdd		NVARCHAR(08)
	, v_QTY				NUMERIC(20,10)
	, v_CREATED_BY		NVARCHAR(150)
	, v_LAST_UPDATED_BY	NVARCHAR(150)
	, v_attribute10		NVARCHAR(150)
	)
	------------------------------------------------------------- TEMP 추가 20180711

	--[E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선건의 속도저하문제로 SSPM 테이블을 임시테이블로 생성 [START]
	CREATE TABLE #INVENTORY_SITE 
	( DIVISION_ID		NVARCHAR(30)
	, SCM_SITE_ID		NVARCHAR(50)
	, PROJECT_CODE		NVARCHAR(50)
	, ITEM_ID			NVARCHAR(50)			
	, CONSENSUS_MKT	    NVARCHAR(2)
	, CONSENSUS_ESS	    NVARCHAR(2)
	, CONSENSUS_SCM	    NVARCHAR(2)
	, INVENTORY_DAY	    NVARCHAR(5)
	, CHANGE_REASON     NVARCHAR(200)
	)
	--[E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선건의 속도저하문제로 SSPM 테이블을 임시테이블로 생성 [END]

	---- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	SET @v_created_by = LEFT(@P_created_by, CASE WHEN PATINDEX('%^%', @P_created_by) > 1 THEN PATINDEX('%^%', @P_created_by) ELSE 100 END -1)
	
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	SET @v_created_by = NULL
	-- 시작 LOG  (END)

	--BEGIN TRANSACTION DM0003_SAVE_MKT_FCST
	BEGIN TRY
	--PRINT 'SPLIT START                                      =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- #results 테이블에 split후 insert (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

PRINT '@p_as_from_site: ' + @p_as_from_site
PRINT '@P_DIVISION_ID: ' + @P_DIVISION_ID

		--[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선
		/*
		-- AS_FROM_SITE 를 뽑는다.
		IF @p_as_from_site <> 'ALL'
		BEGIN
			-- as from site 세팅
			SELECT TOP 1 @v_as_from_site = A.TOKEN
			FROM DBO.UF_FX_String_Split(@p_as_from_site, '^') A
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
			--[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선
			--ON A.TOKEN = B.SEGMENT1 
			  ON A.TOKEN = B.SEGMENT2 
			 AND B.LOOKUP_TYPE = 'AS_SITE_PLANT' 
			 AND B.SEGMENT2 <> '-' 
			 AND B.SEGMENT3 = LEFT(@P_DIVISION_ID, PATINDEX('%^%', @P_DIVISION_ID)-1)			 
PRINT '@v_as_from_site: ' + @v_as_from_site
		END
		*/
		--[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선

		--[E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선건의 속도저하문제로 SSPM 테이블을 임시테이블로 생성 [START]
		IF ( @P_DIVISION_ID = '82' )
		BEGIN
			INSERT INTO #INVENTORY_SITE 
			( DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CONSENSUS_MKT, CONSENSUS_ESS, CONSENSUS_SCM, INVENTORY_DAY, CHANGE_REASON )
			SELECT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CONSENSUS_MKT, CONSENSUS_ESS, CONSENSUS_SCM, INVENTORY_DAY, CHANGE_REASON 
			FROM SCM_MST_SITE_ITEM WITH(NOLOCK) 
			WHERE 1=1 
			AND DIVISION_ID = @P_DIVISION_ID 
			AND SCM_SITE_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)/*[E20260720-000270]_WITH(NOLOCK)추가*/ WHERE LOOKUP_TYPE = 'INVENTORY_DAYS_SETUP_SITE')
		END
		--[E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선건의 속도저하문제로 SSPM 테이블을 임시테이블로 생성 [END]

print '2--' + convert(varchar(30), getdate(), 121)

	--[E20260720-000270]_DP 입력시 문제 발생 件 (START)
	SELECT *
	INTO #TEMP_DM_MST_ITEM_SINGLE_ORI_V
	FROM SCM_MST_ITEM_SN WITH(NOLOCK)		
	WHERE DIVISION_ID = @p_division_id		
	AND	ACTIVE_FLAG = 'Y'	

	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
	SELECT T1.DIVISION_ID
		 , T1.ITEM_ID
		 , MAX(T1.ITEM_NAME)						AS ITEM_NAME
		 , MAX(T1.ITEM_CLASS)						AS ITEM_CLASS
		 , MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME
		 , MAX(T1.NICK_NAME)						AS NICK_NAME
		 , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1	
						  WHEN T1.ITEM_TYPE = 'H' THEN 2	
						  WHEN T1.ITEM_TYPE = 'Q' THEN 3
					 ELSE 4 END )  
									WHEN 1 THEN 'P' 
									WHEN 2 THEN 'H'
									WHEN 3 THEN 'Q'
									ELSE 'R' END	AS ITEM_TYPE
		 , MAX(T1.MATERIAL_CLASS_NAME)				AS MATERIAL_CLASS_NAME
		 , MAX(T1.ITEM_UOM)							AS ITEM_UOM
		 , MAX(T1.SPEC)								AS SPEC
		 , MAX(T1.MDM_PROJECT_NAME)					AS MDM_PROJECT_NAME
		 , MAX(T1.MIN_CAPACITY)						AS MIN_CAPACITY
		 , MAX(T1.ACTIVE_FLAG)						AS ACTIVE_FLAG
		 , MAX(T1.ENERGE)							AS ENERGE
		 , MAX(T1.CELL_QUANTITY)					AS CELL_QUANTITY
		 , MAX(T1.SCP_EXTRA_SPEC)					AS SCP_EXTRA_SPEC		
	INTO #TEMP_DM_MST_ITEM_SINGLE_A_V
	FROM #TEMP_DM_MST_ITEM_SINGLE_ORI_V T1 WITH(NOLOCK)				
	WHERE 1=1
	GROUP BY T1.DIVISION_ID, T1.ITEM_ID

	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
	SELECT DIVISION_ID
		 , LEFT(ITEM_ID, 12) AS ITEM_ID
		 , MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
		 , MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
		 , MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
		 , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
		 , MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
		 , MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
		 , MAX(CELL_TYPE) AS CELL_TYPE
	INTO #TEMP_DM_MST_ITEM_SINGLE_B_V
	FROM #TEMP_DM_MST_ITEM_SINGLE_ORI_V T2 WITH(NOLOCK) 
	GROUP BY DIVISION_ID, LEFT(ITEM_ID, 12)
	
	--TEMP 테이블에 넣은 데이터를 JOIN 한다.
	SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
		 , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
		 , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
		 , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC 
	INTO #TEMP_DM_MST_ITEM_SINGLE_V_ALL
	FROM ( SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME
				, T1.NICK_NAME, T1.ITEM_TYPE, T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC
				, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY, T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
				, T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION, T1.ACTIVE_FLAG, T2.CELL_TYPE
				, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC	
			FROM #TEMP_DM_MST_ITEM_SINGLE_A_V T1 WITH(NOLOCK)					
		   INNER JOIN #TEMP_DM_MST_ITEM_SINGLE_B_V T2 ON T1.DIVISION_ID = T2.DIVISION_ID AND SUBSTRING(T1.ITEM_ID,1,12) = T2.ITEM_ID
		   WHERE 1=1 ) T2							
	WHERE DIVISION_ID = @p_division_id					
	GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
		   , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
		   , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
		   , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC 
	
	CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V_ALL] ON [#TEMP_DM_MST_ITEM_SINGLE_V_ALL]
	(division_id   ASC
	,item_id       ASC
	)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	;


	--[E20260720-000270]_DP 입력시 문제 발생 件 (END)

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--1. 화면에서 전달받은 데이터 -> temp 테이블로 insert
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

		WHILE LEN(@p_DIVISION_ID) > 0
		BEGIN
			DECLARE @index_active_flag    INT
			DECLARE @index_division_id    INT
			DECLARE @index_project_code   INT
			DECLARE @index_scm_site_id    INT
			DECLARE @index_item_id        INT
			DECLARE @index_dom_exp        INT
			DECLARE @index_fcst_type      INT
			DECLARE @index_incoterms      INT
			DECLARE @index_measure        INT
			DECLARE @index_plant_site_id  INT
			DECLARE @index_yyyymmdd       INT
			DECLARE @index_qty            INT
			DECLARE @index_created_by     INT	
			--[E20260211-001189]_index_as_from_site추가
			DECLARE @index_as_from_site   INT	  

			SET @index_active_flag   = PATINDEX('%' + '^' + '%', @p_active_flag    )
			SET @index_division_id   = PATINDEX('%' + '^' + '%', @p_division_id    )
			SET @index_project_code  = PATINDEX('%' + '^' + '%', @p_project_code   )
			SET @index_scm_site_id   = PATINDEX('%' + '^' + '%', @p_scm_site_id    )
			SET @index_item_id       = PATINDEX('%' + '^' + '%', @p_item_id        )
			SET @index_dom_exp       = PATINDEX('%' + '^' + '%', @p_dom_exp        )
			SET @index_fcst_type     = PATINDEX('%' + '^' + '%', @p_fcst_type      )
			SET @index_incoterms     = PATINDEX('%' + '^' + '%', @p_incoterms      )
			SET @index_measure       = PATINDEX('%' + '^' + '%', @p_measure        )
			SET @index_plant_site_id = PATINDEX('%' + '^' + '%', @p_plant_site_id  )
			SET @index_yyyymmdd      = PATINDEX('%' + '^' + '%', @p_yyyymmdd       )
			SET @index_qty           = PATINDEX('%' + '^' + '%', @p_qty            )
			SET @index_created_by    = PATINDEX('%' + '^' + '%', @p_created_by     )	 
			--[E20260211-001189]_index_as_from_site추가
			SET @index_as_from_site  = PATINDEX('%' + '^' + '%', @p_as_from_site   )	 

			-- 확인  select @index_DIVISION_ID as '@index_DIVISION_ID';
			IF @index_DIVISION_ID > 0
			BEGIN
				SET @v_active_flag   = SUBSTRING(@p_active_flag  , 0, @index_active_flag     )
				SET @v_division_id   = SUBSTRING(@p_division_id  , 0, @index_division_id     )
				SET @v_project_code  = SUBSTRING(@p_project_code , 0, @index_project_code    )
				SET @v_scm_site_id   = SUBSTRING(@p_scm_site_id  , 0, @index_scm_site_id     )
				SET @v_item_id       = SUBSTRING(@p_item_id      , 0, @index_item_id         )
				SET @v_dom_exp       = SUBSTRING(@p_dom_exp      , 0, @index_dom_exp         )
				SET @v_fcst_type     = SUBSTRING(@p_fcst_type    , 0, @index_fcst_type       )
				SET @v_incoterms     = SUBSTRING(@p_incoterms    , 0, @index_incoterms       )
				SET @v_measure       = SUBSTRING(@p_measure      , 0, @index_measure         )
				SET @v_plant_site_id = SUBSTRING(@p_plant_site_id, 0, @index_plant_site_id   )
				SET @v_yyyymmdd      = SUBSTRING(@p_yyyymmdd     , 0, @index_yyyymmdd        )
				SET @v_qty           = SUBSTRING(@p_qty          , 0, @index_qty             )
				SET @v_created_by    = SUBSTRING(@p_created_by   , 0, @index_created_by      )
				--[E20260211-001189]_index_as_from_site추가
				SET @v_as_from_site  = SUBSTRING(@p_as_from_site , 0, @index_as_from_site    )

				SET @p_active_flag   = SUBSTRING(@p_active_flag  , LEN(@v_active_flag   + '^') + 1, LEN(@p_active_flag  ))
				SET @p_division_id   = SUBSTRING(@p_division_id  , LEN(@v_division_id   + '^') + 1, LEN(@p_division_id  ))
				SET @p_project_code  = SUBSTRING(@p_project_code , LEN(@v_project_code  + '^') + 1, LEN(@p_project_code ))
				SET @p_scm_site_id   = SUBSTRING(@p_scm_site_id  , LEN(@v_scm_site_id   + '^') + 1, LEN(@p_scm_site_id  ))
				SET @p_item_id       = SUBSTRING(@p_item_id      , LEN(@v_item_id       + '^') + 1, LEN(@p_item_id      ))
				SET @p_dom_exp       = SUBSTRING(@p_dom_exp      , LEN(@v_dom_exp       + '^') + 1, LEN(@p_dom_exp      ))
				SET @p_fcst_type     = SUBSTRING(@p_fcst_type    , LEN(@v_fcst_type     + '^') + 1, LEN(@p_fcst_type    ))
				SET @p_incoterms     = SUBSTRING(@p_incoterms    , LEN(@v_incoterms     + '^') + 1, LEN(@p_incoterms    ))
				SET @p_measure       = SUBSTRING(@p_measure      , LEN(@v_measure       + '^') + 1, LEN(@p_measure      ))

				IF (@v_measure = 'MKT_FCST_RP')
					BEGIN 
						SET @v_measure = 'MKT_FCST';
					END;

				SET @p_plant_site_id = SUBSTRING(@p_plant_site_id, LEN(@v_plant_site_id + '^') + 1, LEN(@p_plant_site_id))
				SET @p_yyyymmdd      = SUBSTRING(@p_yyyymmdd     , LEN(@v_yyyymmdd      + '^') + 1, LEN(@p_yyyymmdd     ))
				SET @p_qty           = SUBSTRING(@p_qty          , LEN(@v_qty           + '^') + 1, LEN(@p_qty          ))
				SET @p_created_by    = SUBSTRING(@p_created_by   , LEN(@v_created_by    + '^') + 1, LEN(@p_created_by   ))
				--[E20260211-001189]_index_as_from_site추가
				SET @p_as_from_site  = SUBSTRING(@p_as_from_site , LEN(@v_as_from_site  + '^') + 1, LEN(@p_as_from_site ))
 
				--20181005 khsong 공백제거로직추가 (START)
				SET @v_active_flag				= rtrim(ltrim(@v_active_flag))
				SET @v_division_id				= rtrim(ltrim(@v_division_id))
				SET @v_project_code				= rtrim(ltrim(@v_project_code))
				SET @v_scm_site_id				= rtrim(ltrim(@v_scm_site_id))
				--------------------------------------------------------------------------------------------------
				-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (START)	
				--1).RTRIM / 2).LTRIM / 3).CHAR(13): Carriage return / 4).CHAR(10): Line feed / 5).CHAR(9): TAB / 6).' '공백을 ''
				--SET @v_item_id					= rtrim(ltrim(@v_item_id))					
				SET @v_item_id					= REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(@v_item_id)),CHAR(13),''),CHAR(10),''),CHAR(9),''), ' ', '')
				-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (END)	
				--------------------------------------------------------------------------------------------------
				SET @v_dom_exp					= rtrim(ltrim(@v_dom_exp))
				SET @v_fcst_type				= rtrim(ltrim(@v_fcst_type))
				SET @v_incoterms				= rtrim(ltrim(@v_incoterms))
				SET @v_measure					= rtrim(ltrim(@v_measure))
				SET @v_plant_site_id			= rtrim(ltrim(@v_plant_site_id))
				SET @v_yyyymmdd					= rtrim(ltrim(@v_yyyymmdd))
				SET @v_qty						= rtrim(ltrim(@v_qty))
				SET @v_created_by				= rtrim(ltrim(@v_created_by	))
				--[E20260211-001189]_index_as_from_site추가
				SET @v_as_from_site				= rtrim(ltrim(@v_as_from_site	))
				--20181005 khsong 공백제거로직추가 (END)

				-- 20180813 KHSONG 당주 월요일이후 데이터만 대상으로 하도록 로직보완
				IF @v_yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7*1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112) AND ISNUMERIC(@v_yyyymmdd) > 0	-- 2021.09.27
				BEGIN 
					-- 2021.12.15
					IF NOT EXISTS ( SELECT *
									FROM SCM_MST_SITE WITH (NOLOCK)
									WHERE DIVISION_ID = @v_division_id
									AND SCM_SITE_ID = @v_scm_site_id
									AND SITE_TYPE= 'SALES'
									AND OPERATION_GROUP = 'W'
									)
					BEGIN
						SELECT @v_as_from_plant = SEGMENT2
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)--[E20260720-000270]_WITH(NOLOCK)추가
						WHERE LOOKUP_TYPE = 'AS_SITE_PLANT'
						AND SEGMENT1 = @v_as_from_site
						AND SEGMENT3 = @v_division_id
						AND SEGMENT1 <> @v_scm_site_id
					END
					ELSE 
					BEGIN
						SET @v_as_from_plant = ''
					END

					INSERT INTO #results 
					( v_active_flag, v_division_id, v_project_code, v_scm_site_id, v_item_id      
					, v_dom_exp, v_fcst_type, v_incoterms, v_measure, v_plant_site_id	 
					, v_yyyymmdd, v_qty, v_created_by, v_attribute10 
					) 
					VALUES 
					( @v_active_flag, @v_division_id, @v_project_code, @v_scm_site_id, @v_item_id      
					, @v_dom_exp, @v_fcst_type, @v_incoterms, @v_measure, @v_plant_site_id
					, @v_yyyymmdd, @v_qty, @v_created_by
					--[E20260211-001189]_index_as_from_site 원소스 주석처리 (START)
					--, ISNULL(@v_as_from_plant,'')
					, ISNULL(@v_as_from_site,'') --[E20260211-001189]_변경
					--[E20260211-001189]_index_as_from_site 원소스 주석처리 (END)
					)
				END;
			END
			ELSE
			BEGIN
				SET @v_division_id				= @p_DIVISION_ID
				SET @p_DIVISION_ID				= NULL

				--20181005 khsong 공백제거로직추가 (START)
				SET @v_active_flag				= rtrim(ltrim(@v_active_flag))
				SET @v_division_id				= rtrim(ltrim(@v_division_id))
				SET @v_project_code				= rtrim(ltrim(@v_project_code))
				SET @v_scm_site_id				= rtrim(ltrim(@v_scm_site_id))
				--------------------------------------------------------------------------------------------------
				-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (START)	
				--1).RTRIM / 2).LTRIM / 3).CHAR(13): Carriage return / 4).CHAR(10): Line feed / 5).CHAR(9): TAB / 6).' '공백을 ''
				--SET @v_item_id					= rtrim(ltrim(@v_item_id))
				SET @v_item_id					= REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(@v_item_id)),CHAR(13),''),CHAR(10),''),CHAR(9),''), ' ', '')
				-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (END)	
				--------------------------------------------------------------------------------------------------
				SET @v_dom_exp					= rtrim(ltrim(@v_dom_exp))
				SET @v_fcst_type				= rtrim(ltrim(@v_fcst_type))
				SET @v_incoterms				= rtrim(ltrim(@v_incoterms))
				SET @v_measure					= rtrim(ltrim(@v_measure))
				SET @v_plant_site_id			= rtrim(ltrim(@v_plant_site_id))
				SET @v_yyyymmdd					= rtrim(ltrim(@v_yyyymmdd))
				SET @v_qty						= rtrim(ltrim(@v_qty))
				SET @v_created_by				= rtrim(ltrim(@v_created_by	))
				--20181005 khsong 공백제거로직추가 (END)				
				--[E20260211-001189]_v_as_from_site 추가 
				SET @v_as_from_site				= rtrim(ltrim(@v_as_from_site))

				--20180813 KHSONG 당주 월요일이후 데이터만 대상으로 하도록 로직보완
				IF @v_yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7*1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112) AND ISNUMERIC(@v_yyyymmdd) > 0	-- 2021.09.27
					BEGIN 
						-- 2021.12.15
						IF NOT EXISTS ( SELECT *
										FROM SCM_MST_SITE WITH(NOLOCK)--[E20260720-000270]_WITH(NOLOCK)추가
										WHERE DIVISION_ID = @v_division_id
										AND SCM_SITE_ID = @v_scm_site_id
										AND SITE_TYPE= 'SALES'
										AND OPERATION_GROUP = 'W'
									  )
						BEGIN
							SELECT @v_as_from_plant = SEGMENT2
							FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)--[E20260720-000270]_WITH(NOLOCK)추가
							WHERE LOOKUP_TYPE = 'AS_SITE_PLANT'										
							--[E20260211-001189]_v_as_from_site 추가 
							--AND SEGMENT1 = @v_as_from_site
							AND SEGMENT2 = @v_as_from_site
							AND SEGMENT3 = @v_division_id
							AND SEGMENT1 <> @v_scm_site_id
						END
					ELSE 
					BEGIN
						SET @v_as_from_plant = ''
					END

					INSERT INTO #results 
					( v_active_flag, v_division_id, v_project_code, v_scm_site_id, v_item_id      
					, v_dom_exp, v_fcst_type, v_incoterms, v_measure, v_plant_site_id
					, v_yyyymmdd, v_qty, v_created_by, v_attribute10 
					) 
					VALUES 
					( @v_active_flag, @v_division_id, @v_project_code, @v_scm_site_id, @v_item_id      
					, @v_dom_exp, @v_fcst_type, @v_incoterms, @v_measure, @v_plant_site_id
					, @v_yyyymmdd, @v_qty, @v_created_by								
					--[E20260211-001189]_v_as_from_site 원소스 주석처리 (START)
					--, ISNULL(@v_as_from_plant,'')
					, ISNULL(@v_as_from_site,'') --변경				
					--[E20260211-001189]_v_as_from_site 원소스 주석처리 (END)
					)
					END;
				END
	-- if end


--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--2. 데이터 정합성 Validation 
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

	--[E20260604-000994]_현재 들어온 권한으로 저장 가능 여부를 판단하여 VALIDATION을 체크하여 사용여부를 판단한 후 VALIDATION을 뱉어낸다. (START)
	IF ( @p_authority = N'SCP Planner')
	BEGIN 
		IF (  SELECT COUNT(*) CNT
			   FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
			  WHERE B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
		 	   AND B.VALID_YN = 'Y' 
			   AND B.SEGMENT2 = 'DMF0003'
			   AND B.SEGMENT3 = @v_division_id
			   AND B.SEGMENT1 = 'SCP Planner'
			   AND (B.ATTRIBUTE1 = 'ALL' OR B.ATTRIBUTE1 IN (SELECT DAYOFWEEK FROM SCM_SYS_CALENDAR_M WITH (NOLOCK) WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8), GETDATE(), 112)))
			   AND CAST(REPLACE(LEFT(CONVERT(VARCHAR,GETDATE(), 108),5), ':', '')AS INT) BETWEEN CAST(B.ATTRIBUTE2 AS INT) AND CAST(B.ATTRIBUTE3 AS INT)) = 0
		 BEGIN
			SET @v_log_type		= 'INVALID';
			SELECT  N'SCP Planner 권한사용자의 수정 가능한 시간이 아닙니다.';	
			SET @v_description	=  N'SCP Planner 권한사용자의 수정 가능한 시간이 아닙니다.';		
			GOTO ERR_RTN
		 END	
	END
	
	DECLARE	@V_EDIT_DAYS	NVARCHAR(100);
	DECLARE	@V_FROM_TIME	NVARCHAR(100);
	DECLARE	@V_TO_TIME		NVARCHAR(100);
	DECLARE	@V_LIMIT_AUTH	NVARCHAR(100);		

	IF ( @p_authority != N'SCP Planner')
	BEGIN	  
		SELECT @V_EDIT_DAYS = ATTRIBUTE1
			 , @V_FROM_TIME = LEFT(ATTRIBUTE2,2)+':'+RIGHT(ATTRIBUTE2,2) 
			 , @V_TO_TIME   = LEFT(ATTRIBUTE3,2)+':'+RIGHT(ATTRIBUTE3,2) 
			 , @V_LIMIT_AUTH = SEGMENT1
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
		AND VALID_YN = 'Y' 
		AND SEGMENT2 = 'DMF0003'--@PARAM1
		AND SEGMENT3 = @v_division_id
		AND SEGMENT1 IN ( SELECT LIMIT_AUTH 
						    FROM ( SELECT B.SEGMENT1 AS AUTH, B.SEGMENT4 AS MEASURE, ATTRIBUTE1 AS EDIT_DAYS, ATTRIBUTE2 AS FROM_TIME, ATTRIBUTE3 AS TO_TIME, ATTRIBUTE4 AS LIMIT_AUTH
									 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
									WHERE B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
									  AND B.VALID_YN = 'Y' 
									  AND B.SEGMENT2 = 'DMF0003'
									  AND B.SEGMENT3 = @v_division_id
									  AND B.SEGMENT1 = @p_authority ) A )		
		AND (ATTRIBUTE1 = 'ALL' OR ATTRIBUTE1 IN (SELECT DAYOFWEEK FROM SCM_SYS_CALENDAR_M WITH (NOLOCK) WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8), GETDATE(), 112)))
		AND CAST(REPLACE(LEFT(CONVERT(VARCHAR,GETDATE(), 108),5), ':', '')AS INT) BETWEEN CAST(ATTRIBUTE2 AS INT) AND CAST(ATTRIBUTE3 AS INT)

		SELECT @V_EDIT_DAYS = ATTRIBUTE1
			 , @V_FROM_TIME = LEFT(ATTRIBUTE2,2)+':'+RIGHT(ATTRIBUTE2,2) 
			 , @V_TO_TIME   = LEFT(ATTRIBUTE3,2)+':'+RIGHT(ATTRIBUTE3,2) 
			 , @V_LIMIT_AUTH = SEGMENT1
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
		AND VALID_YN = 'Y' 
		AND SEGMENT2 = 'DMF0003'--@PARAM1
		AND SEGMENT3 = @v_division_id
		AND SEGMENT1 IN ( SELECT LIMIT_AUTH 
						    FROM ( SELECT B.SEGMENT1 AS AUTH, B.SEGMENT4 AS MEASURE, ATTRIBUTE1 AS EDIT_DAYS, ATTRIBUTE2 AS FROM_TIME, ATTRIBUTE3 AS TO_TIME, ATTRIBUTE4 AS LIMIT_AUTH
									 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
									WHERE B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
									  AND B.VALID_YN = 'Y' 
									  AND B.SEGMENT2 = 'DMF0003'
									  AND B.SEGMENT3 = @v_division_id
									  AND B.SEGMENT1 = @p_authority ) A )		
		AND (ATTRIBUTE1 = 'ALL' OR ATTRIBUTE1 IN (SELECT DAYOFWEEK FROM SCM_SYS_CALENDAR_M WITH (NOLOCK) WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8), GETDATE(), 112)))
		AND CAST(REPLACE(LEFT(CONVERT(VARCHAR,GETDATE(), 108),5), ':', '')AS INT) BETWEEN CAST(ATTRIBUTE2 AS INT) AND CAST(ATTRIBUTE3 AS INT)
		IF 	(	SELECT COUNT(*) AS CNT
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
				WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
				AND VALID_YN = 'Y' 
				AND SEGMENT2 = 'DMF0003'--@PARAM1
				AND SEGMENT3 = @v_division_id
				AND SEGMENT1 IN ( SELECT LIMIT_AUTH 
									FROM ( SELECT B.SEGMENT1 AS AUTH, B.SEGMENT4 AS MEASURE, ATTRIBUTE1 AS EDIT_DAYS, ATTRIBUTE2 AS FROM_TIME, ATTRIBUTE3 AS TO_TIME, ATTRIBUTE4 AS LIMIT_AUTH
											 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
											WHERE B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
											  AND B.VALID_YN = 'Y' 
											  AND B.SEGMENT2 = 'DMF0003'
											  AND B.SEGMENT3 = @v_division_id
											  AND B.SEGMENT1 = @p_authority ) A )		
				AND (ATTRIBUTE1 = 'ALL' OR ATTRIBUTE1 IN (SELECT DAYOFWEEK FROM SCM_SYS_CALENDAR_M WITH (NOLOCK) WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8), GETDATE(), 112)))
				AND CAST(REPLACE(LEFT(CONVERT(VARCHAR,GETDATE(), 108),5), ':', '')AS INT) BETWEEN CAST(ATTRIBUTE2 AS INT) AND CAST(ATTRIBUTE3 AS INT)) > 0
			BEGIN
				SET @v_log_type		= 'INVALID';
				SELECT @V_LIMIT_AUTH + N' 권한 사용자가 '+@V_EDIT_DAYS +' '+ @V_FROM_TIME+ N' 부터 '+ @V_TO_TIME+ N'까지 수정하는 시간입니다.\r\n'+@p_authority+N' 권한 사용자는 해당 시간에 수정이 불가합니다.';
				SET @v_description	= @V_LIMIT_AUTH + N' 권한 사용자가 '+@V_EDIT_DAYS +' '+ @V_FROM_TIME+ N' 부터 '+ @V_TO_TIME+ N'"까지 수정하는 시간입니다.\r\n'+@p_authority+N' 권한 사용자는 해당 시간에 수정이 불가합니다.';		
				GOTO ERR_RTN
			END
	END			
	--[E20260604-000994]_현재 들어온 권한으로 저장 가능 여부를 판단하여 VALIDATION을 체크하여 사용여부를 판단한 후 VALIDATION을 뱉어낸다. (END)


				----------- 20180810 KHSONG NULL VALIDATION ADDED
				BEGIN
				-----------
					IF     @v_division_id	IS NULL OR @v_division_id    = ''
						OR @v_project_code	IS NULL OR @v_project_code	 = ''
						OR @v_scm_site_id	IS NULL OR @v_scm_site_id	 = ''
						OR @v_item_id		IS NULL OR @v_item_id		 = ''
						OR @v_dom_exp		IS NULL OR @v_dom_exp		 = ''
						OR @v_fcst_type		IS NULL OR @v_fcst_type		 = ''
						OR @v_incoterms		IS NULL OR @v_incoterms		 = ''
						OR @v_measure		IS NULL OR @v_measure		 = ''
						BEGIN
							SET @v_log_type = 'INVALID';
							SELECT N' Check Mandatory Columns ( Fcst type or Incoterms or Customs Handbook ) !'
							SET @v_description = N' Check Mandatory Columns ( Fcst type or Incoterms or Customs Handbook ) !'
							goto err_rtn
						END
					END
				-----------
				END
				-----------

		-- [C20220328-000205] MKT FCST 입력, 저장 간 오류 확인 요청
		IF EXISTS (	SELECT COUNT(v_division_id) AS CNT 
					FROM #results
					GROUP BY v_active_flag, v_division_id, v_project_code, v_scm_site_id, v_item_id	
						   , v_dom_exp, v_fcst_type, v_incoterms, v_measure, v_plant_site_id, v_yyyymmdd		
					HAVING COUNT(v_division_id)  > 1 )
			BEGIN
				SET @v_log_type = 'INVALID';
				SELECT N'동일한 일자에 AS From Site 만 다른 DP 를 입력할 수 없습니다.'
				SET @v_description =  N'동일한 일자에 AS From Site 만 다른 DP 를 입력할 수 없습니다.'
				GOTO ERR_RTN
			END
		-- select * from #results
		-----------------------	SALES PRICE 미리 수집 --------------------------------
			
		DECLARE @MIN_DATE NCHAR(8), @MAX_DATE NCHAR(8)

		SELECT @MIN_DATE = MIN(BASIS_START_DATE)
			 , @MAX_DATE = MAX(BASIS_END_DATE)
		FROM [DBO].[SCM_SYS_CALENDAR_M] M WITH(NOLOCK) 
		-----------------------------------------------------------------------------------------------------------------------------------
		-- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
		/*
		WHERE M.BASIS_YYYYMMDD BETWEEN CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --당주 월요일부터
									AND CONVERT(CHAR(8), DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112)  -- 52주후 월요일까지*/
		-----------------------------------------------------------------------------------------------------------------------------------
		WHERE M.BASIS_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --당주 월요일부터
		AND   M.BASIS_YYYYMMDD	< CONVERT(CHAR(8), DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112)  -- 52주후 월요일까지
		-- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (END)
		-----------------------------------------------------------------------------------------------------------------------------------

		INSERT INTO #T_PRICE 
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID		
		, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE	)
		SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID		
					  , B.YYYYMMDD, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PRICE
		FROM #RESULTS A
		JOIN SCM_MST_FUTURE_PRICE B WITH(NOLOCK) 
		  ON A.v_division_id	= B.DIVISION_ID
		 AND A.v_project_code	= B.PROJECT_CODE
		 AND A.v_scm_site_id	= B.SCM_SITE_ID
		 AND A.v_plant_site_id  = CASE WHEN A.v_division_id LIKE '81%' THEN B.plant_site_id ELSE A.v_plant_site_id END
		 AND A.v_item_id		= B.ITEM_ID
		 AND A.v_dom_exp		= B.DOM_EXP
		 AND A.v_fcst_type		= B.FCST_TYPE
		 AND A.v_incoterms		= B.INCOTERMS
		WHERE B.DIVISION_ID	= @v_division_id
		AND B.YYYYMMDD BETWEEN @MIN_DATE AND @MAX_DATE
		AND B.PRICE <> 0

	---------------------------------------------------------------------------------------------------------
	
print '3--' + convert(varchar(30), getdate(), 121)	

		-- #results 테이블의 VMI_YN UPDATE
		UPDATE A
		SET V_VMI_YN = CASE WHEN ISNULL(B.VMI_YN, '') = 'Y' THEN 'Y' ELSE 'N' END
		FROM #results A
		JOIN SCM_MST_SITE B WITH(NOLOCK) 
		  ON A.v_division_id = B.DIVISION_ID 
		 AND A.v_scm_site_id = B.SCM_SITE_ID

		-- AS 이더라도 AS Plant 에는 Attribute10 을 지워준다.
		UPDATE A
		SET v_attribute10 = ''
		FROM #results A
		WHERE v_scm_site_id = v_attribute10
	
		/* [E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선 사용하지 않아도 됨 (START)
		-- AS 인데, FROM Site 가 없는 건들은 오류처리한다. ( WS, 20211103 )
		-- FCST Type 에 WS, WSF가 포함되어있는데, From Site 가 없는 경우 에러처리
		IF EXISTS ( SELECT * 
					FROM #results A
					JOIN SCM_MST_SITE B WITH(NOLOCK) 
					  ON A.v_division_id = B.DIVISION_ID 
					 AND A.v_scm_site_id = B.SCM_SITE_ID 
					 AND ISNULL(B.OPERATION_GROUP,'') <> 'W'
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK) 
					  ON A.v_fcst_type = C.SEGMENT1 
					 AND C.LOOKUP_TYPE = 'SALES_TYPE_CODE' 
					 AND C.ATTRIBUTE2 = 'Y'
				    )
			AND NOT EXISTS ( SELECT *
							 FROM SCM_MST_SITE WITH(NOLOCK) 
							 WHERE DIVISION_ID = @v_division_id
							 AND SCM_SITE_ID = @v_as_from_site
							)
			BEGIN
				SET @v_log_type = 'INVALID';		
				--[E20260211-001189]_내용변경 (START)
				--SELECT N'AS 관련 FCST TYPE 을 사용할 경우 상단 Sales Site 에 AS Plant 가 선택되어있어야 합니다.'
				SELECT N'AS 관련 FCST TYPE 을 사용할 경우 AS FROM SITE를 선택해야 합니다.'
				--SET @v_description =  N'AS 관련 FCST TYPE 을 사용할 경우 상단 Sales Site 에 AS Plant 가 선택되어있어야 합니다.'
				SET @v_description =  N'AS 관련 FCST TYPE 을 사용할 경우 AS FROM SITE를 선택해야 합니다.'
				--[E20260211-001189]_내용변경 (END)				
				GOTO ERR_RTN
			END
	
		-- AS 유효성 체크
		-- AS FROM SITE 가 여러개 있거나 없는 경우
		IF NOT EXISTS (	SELECT COUNT(*)
						FROM DBO.UF_FX_String_Split(@p_as_from_site, '^') A
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
						  ON A.TOKEN = B.SEGMENT1 
						 AND B.LOOKUP_TYPE = 'AS_SITE_PLANT' 
						 AND B.SEGMENT2 <> '-' AND B.SEGMENT3 = @v_division_id
						 HAVING COUNT(*) = 1
						)
			-- 고객향이 포함된 경우 ( AS PLANT 로 가는 데이터만 있을 경우 FROM SITE 필요 없음 )
			AND EXISTS ( SELECT *
						 FROM #results A
						 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
									  ON A.v_scm_site_id = B.SEGMENT1 
									 AND B.LOOKUP_TYPE = 'AS_SITE_PLANT' 
									 AND B.SEGMENT2 <> '-' AND B.SEGMENT3 = @v_division_id
						 WHERE B.SEGMENT1 IS NULL
						) -- AS FCST TYPE 이 있을 경우
			AND EXISTS ( SELECT * 
						 FROM #results A
						 JOIN SCM_MST_SITE B WITH(NOLOCK) 
						   ON A.v_division_id = B.DIVISION_ID 
						  AND A.v_scm_site_id = B.SCM_SITE_ID 
						  AND ISNULL(B.OPERATION_GROUP,'') <> 'W'
						 JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK) 
						   ON A.v_fcst_type = C.SEGMENT1
						  AND C.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND C.ATTRIBUTE2 = 'Y'
						)
			BEGIN		
				SET @v_log_type = 'INVALID';
				--[E20260211-001189]_내용변경 (START)
				--SELECT N'AS 가 체크되었을 때에는 한 개의 AS PLANT 가 Sales Site 에 선택이 되어야 합니다.'
				SELECT N'AS 관련 FCST TYPE을 선택했을 때에는 한 개의 AS FROM SITE가 선택이 되어야 합니다.'
				--SET @v_description =  N'AS 가 체크되었을 때에는 한 개의 AS PLANT 가 Sales Site 에 선택이 되어야 합니다.!'
				SET @v_description =  N'AS 관련 FCST TYPE을 선택했을 때에는 한 개의 AS FROM SITE가 선택이 되어야 합니다.!'
				--[E20260211-001189]_내용변경 (END)
				goto err_rtn
			END
		--[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선 사용하지 않아도 됨 (END) */
	
		-- AS PLANT 로 가는 DP의 INCOTERMS 를 제한한다.
		-- 
		IF EXISTS ( SELECT * 
					FROM #results A
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
					  ON A.v_division_id = B.SEGMENT3 
					 AND A.v_scm_site_id = B.SEGMENT1 
					 AND B.LOOKUP_TYPE = 'AS_SITE_PLANT' 
					 AND B.VALID_YN = 'Y'
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK) 
								 ON A.v_division_id = C.SEGMENT1 
								AND A.v_incoterms = C.SEGMENT2 
								AND C.VALID_YN = 'Y'
					WHERE C.SEGMENT1 IS NULL
						)
			BEGIN
				SET @v_log_type = 'INVALID';
				SELECT N'AS In Request 메저는 지정된 Incoterms 만 사용가능합니다.'
				SET @v_description =  N'AS In Request 메저는 지정된 Incoterms 만 사용가능합니다.'
				GOTO ERR_RTN
			END

print '4--' + convert(varchar(30), getdate(), 121)

	--==========================================================================================================================
	-- [E20250919-001699]_Incoterms 데이터 처리 VALID 처리 (START)
	--==========================================================================================================================
	IF ( SELECT COUNT(*) FROM #results A WHERE A.v_incoterms IN ( SELECT OLD_VALUE1 FROM [dbo].[NERP_CONV_MASTER] WITH(NOLOCK) WHERE CODETYPE = 'INCOTERMS_ID' GROUP BY OLD_VALUE1)) > 0
	BEGIN
print '5--' + convert(varchar(30), getdate(), 121)
		SET @v_log_type		= 'INVALID';
		SELECT N'구코드 INCOTERMS는 저장할 수 없습니다.'
		SET @v_description	=  N'구코드 INCOTERMS는 저장할 수 없습니다.';	
print '6--:' + @v_log_type + @v_description + convert(varchar(30), getdate(), 121)	
		GOTO ERR_RTN
	END			
	--==========================================================================================================================
	-- [E20250919-001699]_Incoterms 데이터 처리 VALID 처리 (END)
	--==========================================================================================================================
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- #results 테이블에 split후 insert (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		DECLARE @FROM_DATE NCHAR(8), @TO_DATE NCHAR(8);

		SELECT @FROM_DATE = MIN(BASIS_YYYYMMDD), @TO_DATE = MAX(BASIS_YYYYMMDD)
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
		JOIN [SCM_SYS_CALENDAR_M] C WITH(NOLOCK) 
		  ON C.BASIS_YYYYMM = L.ATTRIBUTE1 OR C.BASIS_YYYYMM = L.ATTRIBUTE2
		WHERE L.LOOKUP_TYPE = 'DM_LONG_PLAN'
		AND L.SEGMENT1 = '40'
		AND L.SEGMENT2 = 'MKT FCST'
		AND L.VALID_YN = 'Y'

		-- 소형일 경우 중장기계획 관련 2022년 입력 마감여부 확인
		-- 소형이고 2022년이 마감되어있는데, 2022년 데이터가 들어있으면 에러처리
		IF @v_division_id = '40' AND EXISTS ( SELECT * 
											  FROM #RESULTS AS R
											  WHERE R.v_yyyymmdd < @FROM_DATE OR R.v_yyyymmdd > @TO_DATE)
			BEGIN
				SET @v_log_type = 'INVALID';
				SELECT @FROM_DATE + N' ~ ' + @TO_DATE + N' 구간 내의 데이터만 수정할 수 있습니다.';
				SET @v_description =  @FROM_DATE + N' ~ ' + @TO_DATE + N' 구간 내의 데이터만 수정할 수 있습니다.';		
				GOTO ERR_RTN
			END

print '5--' + convert(varchar(30), getdate(), 121)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- 20181012 BLOCK Model (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		DECLARE @s_BLOCK_Model  NVARCHAR(max);
		set @s_BLOCK_Model = '';
		set @s_BLOCK_Model = ISNULL((select TOP 1 v_item_id
									 from #results a 
									 where 1=1
									 and ( select count(1)
										   from [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] with(nolock)
										   where LOOKUP_TYPE = 'FCST_EXCEPT_MODEL'
										   and SEGMENT1 = '40'
										   and valid_yn = 'Y'
										   and SEGMENT2 = A.v_item_id
										  ) > 0
										--and a.v_measure IN ('MKT_FCST','RTF')
									 and a.v_qty <> 0),'') 
		IF @s_BLOCK_Model <> ''
			BEGIN
				SET @v_log_type = 'INVALID';
				SELECT 'Model : ' + @s_BLOCK_Model +char(10) + N'FCST INPUT BLOCK Model. contact 영업관리팀'
				SET @v_description = 'Model : ' + @s_BLOCK_Model +char(10) + N'FCST INPUT BLOCK Model. contact 영업관리팀'
				GOTO ERR_RTN
			END

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- 20181012 BLOCK Model (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- PROJECT_CODE,ITEM_ID 잘못들어왔을때 강제 에러발생시킴 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
print '6--' + convert(varchar(30), getdate(), 121)			
	-----------
		BEGIN
		-----------
		--PRINT 'VALIDATION_1 START                               =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
			-- 저장전 변수 초기화
			DECLARE @valid_project_code		 NVARCHAR(MAX);
			DECLARE @valid_item_id		     NVARCHAR(MAX);
			DECLARE @valid_item_id_2	     NVARCHAR(MAX);

			SET @valid_project_code	  = NULL
			SET @valid_item_id = NULL
			SET @valid_item_id_2 = NULL
			----------------------------------------------------------------------------------------------------------◎◎◎◎
			IF ( select count(1)  
				 from #results  where v_division_id <> '40'  -- 20180618 KHSONG 40 DIVISION 조건 추가
				) > 0
				BEGIN
					SET @valid_project_code = (	SELECT TOP 1 A.v_project_code
												FROM #results A
												WHERE NOT EXISTS (SELECT c.division_id 
																  FROM dbo.scm_mst_project C  WITH(NOLOCK)
																  WHERE A.v_division_id  = c.division_id 
																  AND A.v_project_code = c.project_code 
																  AND c.division_id <> '40' )
												AND A.v_division_id <> '40' )
					IF @valid_project_code IS NOT NULL
						BEGIN
							SET @v_log_type = 'INVALID';
							SELECT '['+ @valid_project_code +']'+ N' Invalid Project Code !'
							SET @v_description = '['+ @valid_project_code +']'+ N' Invalid Project Code !'
							goto err_rtn
						END
				END
			----------------------------------------------------------------------------------------------------------◎◎◎◎

		--임시저장
		--select * into temp_skh_0903_01 from #results
		----------------------------------------------------------------------------------------------------------◎◎◎◎
		--[C20200707-000367] ESS 사업부 Sales Site Project Model validation 추가(81, 40 validation에 82 추가)
			/*IF (select count(1)  
					from #results  where v_division_id IN ('81','40')  -- 자동차,소형인경우
				) > 0*/
print '7--' + convert(varchar(30), getdate(), 121)
				----------------------------------------------------------------------------------◎◎◎◎
			BEGIN
				SET @valid_item_id = ( SELECT TOP 1 A.v_item_id
									   FROM #results A
									   WHERE NOT EXISTS (	SELECT ITEM.division_id  
															FROM dbo.SCM_MST_SITE_ITEM ITEM WITH(NOLOCK)
															, dbo.SCM_MST_ITEM_SN SN WITH(NOLOCK)  -- 2022.01.20
															WHERE 1=1
 															AND ITEM.division_id   = A.v_division_id 
															AND ITEM.PROJECT_CODE  = A.v_project_code
															AND ITEM.scm_site_id   = A.v_scm_site_id
															AND ITEM.ITEM_ID       = A.v_item_id 
															AND ITEM.division_id   = SN.division_id	--20180720 ACTIVE_FLAG 조건추가
															AND ITEM.ITEM_ID       = SN.ITEM_ID		--20180720 ACTIVE_FLAG 조건추가
															AND SN.ACTIVE_FLAG		= 'Y'				--20180720 ACTIVE_FLAG 조건추가
															AND ITEM.VALID_YN		= 'Y'				-- [C20200812-000104]
														 --and ITEM.division_id IN ('81','40') --[C20200707-000367] ESS 사업부 Sales Site Project Model validation 추가(81, 40 validation에 82 추가)
														 )
							--AND A.v_division_id IN ('81','40') --[C20200707-000367] ESS 사업부 Sales Site Project Model validation 추가(81, 40 validation에 82 추가)
									    )
					IF @valid_item_id IS NOT NULL
						BEGIN
							SET @v_log_type = 'INVALID';
							SELECT '['+ @valid_item_id +']'+ N' Invalid Site Item ID !'
							SET @v_description = '['+ @valid_item_id +']'+ N' Invalid Site Item ID !'
							goto err_rtn
						END
			END
				----------------------------------------------------------------------------------◎◎◎◎
				
				--[C20200717-000157] ESS사업부 Sales Site Project Model Sales Company, Sales Plant Validation 추가 
				----------------------------------------------------------------------------------◎◎◎◎				
			IF ( SELECT COUNT(1)  
				 FROM #results  
				 WHERE v_division_id = '82') > 0
				BEGIN
					SET @valid_item_id = (  SELECT TOP 1 A.v_item_id
											FROM #results A
											WHERE EXISTS (  SELECT ITEM.division_id  
															FROM dbo.SCM_MST_SITE_ITEM ITEM WITH(NOLOCK)
																,dbo.SCM_MST_ITEM_SN SN WITH(NOLOCK) 
															WHERE 1=1
 															AND ITEM.division_id   = A.v_division_id 
															AND ITEM.PROJECT_CODE  = A.v_project_code
															AND ITEM.scm_site_id   = A.v_scm_site_id
															AND ITEM.ITEM_ID       = A.v_item_id 
															AND ITEM.division_id   = SN.division_id
															AND ITEM.ITEM_ID       = SN.ITEM_ID
															AND SN.ACTIVE_FLAG	   = 'Y' 
															AND ((ITEM.SALES_COMPANY IS NULL OR ITEM.SALES_COMPANY = '') OR (ITEM.SALES_PLANT IS NULL OR ITEM.SALES_PLANT = '') )
														  )
											)

						IF @valid_item_id IS NOT NULL
							BEGIN
								SET @v_log_type = 'INVALID';
								SELECT '['+ @valid_item_id +']'+ N' Sales Company/Plant does not exist !'
								SET @v_description = '['+ @valid_item_id +']'+ N' Sales Company/Plant does not exist !'
								goto err_rtn
							END
				END
				----------------------------------------------------------------------------------◎◎◎◎
print '8--' + convert(varchar(30), getdate(), 121)				
		----------------------------------------------------------------------------------------------------------◎◎◎◎
		--[C20200707-000367] ESS 사업부 Sales Site Project Model validation 추가(81, 40 validation에 82 추가)
			/*IF (select count(1)  
					from #results  where v_division_id = '82'  -- ESS인경우
				) > 0

				----------------------------------------------------------------------------------◎◎◎◎
				BEGIN
					SET @valid_item_id_2 =
					(
						SELECT TOP 1 A.v_item_id
							FROM #results A
							where NOT EXISTS (SELECT  ITEM.division_id  
												FROM dbo.scm_mst_item_sn ITEM WITH(NOLOCK)
												where 1=1
 													and ITEM.division_id   = A.v_division_id 
													and ITEM.ITEM_ID       = A.v_item_id 
													and ITEM.ACTIVE_FLAG   = 'Y' 
													and ITEM.division_id   = '82'
											  )
								AND v_division_id = '82'
					)

						-------------------------------------------------------------------◎◎◎◎
						IF @valid_item_id_2 IS NOT NULL
							BEGIN
								SET @v_log_type = 'INVALID';
								SELECT '['+ @valid_item_id_2 +']'+ N' Invalid Site Item ID !'
								SET @v_description = '['+ @valid_item_id_2 +']'+ N' Invalid Site Item ID !'
								goto err_rtn
							END
						-------------------------------------------------------------------◎◎◎◎
				END*/
				----------------------------------------------------------------------------------◎◎◎◎

	-----------
		END
	-----------

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- PROJECT_CODE,ITEM_ID 잘못들어왔을때 강제 에러발생시킴 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- ESS인경우 SCM_MST_SITE_ITEM 테이블에 INPUT 데이터를 INSERT 수행 (START)  20190118 KHSONG ESS인경우 ITEM INSERT 후 Unit Price validation을 위해 위치변경
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--[C20200615-000238] [ESS사업부] Sales Company/Plant 저장시 기준정보 재생성 로직 삭제
	/*IF (select count(1)  
			from #results  where v_division_id = '82'  -- ESS인경우
		) > 0
	BEGIN
			   DELETE 
			   FROM dbo.SCM_MST_SITE_ITEM
			   WHERE exists (
						SELECT v_division_id
						  FROM #results 
						 where v_division_id      = '82'
						   and division_id        =   v_division_id      
						   AND project_code       =   v_project_code   
						   AND scm_site_id        =   v_scm_site_id  
						   AND item_id            =   v_item_id      
					  ) ;

			   INSERT INTO dbo.SCM_MST_SITE_ITEM
			   -- 20180531 insert시 테이블 컬럼지정
					(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,CURRENCY,CELL_PER_CAR,CELL_PER_MODULE,LIABILITY_PERIOD
					,SALES_PLAN_ADJUST_YN,ITEM_HRCY_ID,VALID_YN,BPMS_EXIST
					,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3
					,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
			   SELECT distinct
					 v_division_id  
					,v_project_code 
					,v_scm_site_id  
					,v_item_id 
					,(select top 1 CURRENCY from SCM_MST_PROJECT WITH(NOLOCK) where DIVISION_ID = v_division_id and PROJECT_CODE = v_project_code and CURRENCY is not null)  -- CURRENCY     
					,null         -- CELL_PER_CAR
					,null         -- CELL_PER_MODULE
					,null         -- LIABILITY_PERIOD
					,'Y'          -- SALES_PLAN_ADJUST_YN
					,null         -- ITEM_HRCY_ID
					,'Y'          -- VALID_YN
					,'N'          -- BPMS_EXIST
					,'SYSTEM'     --CREATED_BY
					,GETDATE()    -- CREATION_DATE
					,'SYSTEM'     -- LAST_UPDATED_BY
					, GETDATE()   -- LAST_UPDATE_DATE
					,null,null,null,null,null,null,null,null,null,null
			  FROM #results 
				where v_division_id      = '82'

	END*/
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--  ESS인경우 SCM_MST_SITE_ITEM 테이블에 INPUT 데이터를 INSERT 수행 (END)    20190118 KHSONG ESS인경우 ITEM INSERT 후 Unit Price validation을 위해 위치변경
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
print '81--' + convert(varchar(30), getdate(), 121)		
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--  20200529 KHSONG C20200424-000010 (Sales Price 필수 입력 구간 관련의 건) FCST주차의 Unit Price 유무 Validation (BEGIN)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		/* @s_unit_price_valid 변수내에는 Null이 발생하는 컬럼값이 존재하면 안됨 (변수전체가 Null로 저장됨)  */
		IF OBJECT_ID (N'tempdb..#mshychu1', N'U') IS NOT NULL 
			DROP TABLE #mshychu1
		IF OBJECT_ID (N'tempdb..#mshychu2', N'U') IS NOT NULL 
			DROP TABLE #mshychu2

		SELECT SEGMENT2 
		INTO #mshychu1 --[C20200819-000105] 'VMI-In Request' 입력시 Sales Price 필수 입력 Validation 추가(Lookup)
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST WITH(NOLOCK) 
		WHERE 1=1
		AND MST.LOOKUP_TYPE	= 'MKT_FCST_VALIDATION_PRICE'
		AND MST.SEGMENT1    = 'MEASURE'
		AND VALID_YN        = 'Y' 

		SELECT SEGMENT2 
		INTO #mshychu2 --[C20200814-000183] Fcst Type 'RMA' Sales Price 필수 입력 제외 Validation 추가(Lookup)
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST WITH(NOLOCK) 
		WHERE 1=1
		AND MST.LOOKUP_TYPE	= 'MKT_FCST_VALIDATION_PRICE'
		AND MST.SEGMENT1    = 'FCST_TYPE'
		AND VALID_YN        = 'Y' 
	
		--[E20231020-001565] GSCM 현장설치품 DP입력 시스템/프로세스 개선 요청의 건======
		IF OBJECT_ID (N'tempdb..#ess_price_except_model', N'U') IS NOT NULL 
			DROP TABLE #ess_price_except_model

		SELECT SEGMENT2 
		INTO #ess_price_except_model 
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST WITH(NOLOCK) 
		WHERE 1=1
		AND MST.LOOKUP_TYPE = 'ESS_PRICE_EXCEPT_MODEL'
		AND MST.SEGMENT1    = @v_division_id	--82번사업부만해당
		AND VALID_YN        = 'Y' 	
	--==================================================================
	
		DECLARE @s_unit_price_valid  NVARCHAR(1000);

		set @s_unit_price_valid = null;
		set @s_unit_price_valid = ( SELECT TOP 1 
										   CASE WHEN a.v_division_id = '40' THEN 'End Customer________ : '+ ISNULL(v_project_code ,'')
												ELSE 'Project_________ : '+ ISNULL(v_project_code ,'') END
										   +char(10) + 'Sales site_____________ : '+ ISNULL(v_scm_site_id ,'') 
										   +char(10) + 'Model________________ : '+ ISNULL(v_item_id ,'')  
										   +char(10) + 'Customs Handbook__ : '+ ISNULL(v_dom_exp ,'')    
										   +char(10) + 'Fcst Type_____________ : '+ 
										   ISNULL(( SELECT TOP 1 SEGMENT2
													FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST WITH (NOLOCK)
													WHERE 1=1
													AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
													AND MST.SEGMENT1    = A.v_fcst_type),'')  -- 20180917 KHSONG fcst_type LOOKUP참조하여 출력으로 변경
											+char(10) + 'Incoterms____________ : '+ ISNULL(v_incoterms ,'')    
											+char(10) + 'Plant Site___________ : '+ ISNULL(v_plant_site_id ,'')     --[C20200525-000296] (81 사업부) Plant Site 조건 추가
											+CHAR(10) + 'YYYYMMDD_________ : '+ ISNULL( MIN(M.BASIS_START_DATE),'')  + ' ~ ' + ISNULL(MAX(M.BASIS_START_DATE),'')   -- [C20210203-000427]
											+char(10) +char(10)
									FROM #results A
									--  20181016 KHSONG SALES_PLAN_ADJUST_YN = 'N'인대상에 대해서는 Price Validation 에서 제외
									INNER JOIN SCM_MST_SITE_ITEM z WITH(NOLOCK) 
											ON a.v_division_id		 = z.DIVISION_ID
										   AND a.v_project_code		  = z.PROJECT_CODE
										   AND a.v_scm_site_id		 = z.SCM_SITE_ID
										   AND a.v_item_id			 = z.ITEM_ID
										   AND z.VALID_YN			 = 'Y'
										   AND ( z.SALES_PLAN_ADJUST_YN = 'Y' OR z.SALES_PLAN_ADJUST_YN = '' OR z.SALES_PLAN_ADJUST_YN IS NULL )  -- 20181023 보완
									--  20181016 KHSONG SALES_PLAN_ADJUST_YN = 'N'인대상에 대해서는 Price Validation 에서 제외
									LEFT JOIN ( -- [C20210203-000427]
												SELECT BASIS_START_DATE 
												FROM SCM_SYS_CALENDAR_M M WITH(NOLOCK) 																	   
												-----------------------------------------------------------------------------------------------------------------------------------
												-- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
												/*
												WHERE M.BASIS_YYYYMMDD BETWEEN CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --당주 월요일부터
																		   AND CONVERT(CHAR(8), DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112)  -- 52주후 월요일까지*/
												-----------------------------------------------------------------------------------------------------------------------------------
												WHERE M.BASIS_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --당주 월요일부터
												AND   M.BASIS_YYYYMMDD	< CONVERT(CHAR(8), DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112)  -- 52주후 월요일까지
												-- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (END)
												-----------------------------------------------------------------------------------------------------------------------------------
												GROUP BY BASIS_START_DATE ) M
											ON 1=1
									LEFT HASH JOIN #T_PRICE P WITH (NOLOCK)
												ON (a.v_division_id		= p.division_id
											   AND	a.v_project_code	= p.project_code
											   AND	a.v_scm_site_id		= p.scm_site_id
											   AND	a.v_item_id			= p.item_id
											   AND	a.v_dom_exp			= p.dom_exp
											   AND	a.v_fcst_type		= p.fcst_type
											   AND	a.v_incoterms		= p.INCOTERMS
											   AND	a.v_plant_site_id	= CASE WHEN a.v_division_id LIKE '81%' THEN p.plant_site_id ELSE a.v_plant_site_id END --[C20200525-000296] (81 사업부) Plant Site 조건 추가
											   AND	p.yyyymmdd			= M.basis_start_date
											   AND	p.price > 0	)
									WHERE 1=1
									AND p.yyyymmdd IS NULL  -- PRICE값이 없는경우
									--AND a.v_measure IN ('MKT_FCST','RTF')  -- 20181010 								
									--AND a.v_measure in (SELECT SEGMENT2 --[C20200819-000105] 'VMI-In Request' 입력시 Sales Price 필수 입력 Validation 추가(Lookup)
									--					FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
									--					WHERE 1=1
									--					AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
									--					AND MST.SEGMENT1     = 'MEASURE'
									--					AND VALID_YN        = 'Y' )
									AND a.v_measure in (SELECT * from #mshychu1)
									AND a.v_qty <> 0
									--AND a.v_fcst_type not in (  SELECT SEGMENT2 --[C20200814-000183] Fcst Type 'RMA' Sales Price 필수 입력 제외 Validation 추가(Lookup)
									--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
									--							WHERE 1=1
									--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
									--							AND MST.SEGMENT1     = 'FCST_TYPE'
									--							AND VALID_YN        = 'Y' 
									--						)  -- 무상제공인경우는 Validation 에서 제외 / 기존 하드코딩을 Lookup으로 변경
									AND a.v_fcst_type NOT IN ( SELECT * from #mshychu2)
									AND A.v_item_id NOT IN (SELECT * FROM #ess_price_except_model)  --[E20231020-001565] GSCM 현장설치품 DP입력 시스템/프로세스 개선
									GROUP BY v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_measure,V_PLANT_SITE_ID,P.YYYYMMDD -- [C20210203-000427] ,M.BASIS_START_DATE , M.BASIS_END_DATE 
									ORDER BY v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_measure,V_PLANT_SITE_ID,P.YYYYMMDD
									)

		IF @s_unit_price_valid IS NOT NULL
			BEGIN	
print '811--' + convert(varchar(30), getdate(), 121)	
				SET @v_log_type = 'INVALID';
				SET @v_description = @s_unit_price_valid + N'Unit Price Not Found !'+char(10) + N'해당주차의 Sales Price 값을 입력하시기 바랍니다.'+char(10) + N'미래구간 52주차까지 Sales Price 값이 모두 입력되어야 합니다.'
				SELECT @v_description
				GOTO ERR_RTN
			END

	print '82--' + convert(varchar(30), getdate(), 121)		
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--  20200529 KHSONG C20200424-000010 (Sales Price 필수 입력 구간 관련의 건) FCST주차의 Unit Price 유무 Validation (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--  20180816 Unit Price가 없는 MKT_FCST validation (START)  -- 20200529 KHSONG C20200424-000010 주석처리
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	/*

				DECLARE @s_unit_price_valid  NVARCHAR(max);
				set @s_unit_price_valid = null;
				set @s_unit_price_valid = 
				(select top 1 'Project :                    '+ v_project_code +char(10) +'Sales site :                 '+ v_scm_site_id +char(10) +'Model :                     '+ v_item_id 
								+char(10) +'Customs Handbook :   '+ v_dom_exp +char(10) +'Fcst Type :                 '+ 
								(SELECT TOP 1 SEGMENT2
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
									WHERE 1=1
									AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
									AND MST.SEGMENT1    = A.v_fcst_type
									)  -- 20180917 KHSONG fcst_type LOOKUP참조하여 출력으로 변경
								+char(10) +'incoterms :                '+ v_incoterms 
								+char(10) +'YYYYMMDD :            '+ v_yyyymmdd +char(10) +char(10)
																									--'-----------------------------'                                      
					from #results a 
						--  20181016 KHSONG SALES_PLAN_ADJUST_YN = 'N'인대상에 대해서는 Price Validation 에서 제외
						inner join scm_mst_site_item z with(nolock)
						on  a.v_division_id		 = z.DIVISION_ID
						and a.v_project_code		 = z.PROJECT_CODE
						and a.v_scm_site_id		 = z.SCM_SITE_ID
						and a.v_item_id			 = z.ITEM_ID
						and z.VALID_YN			 = 'Y'
						AND ( z.SALES_PLAN_ADJUST_YN = 'Y' OR z.SALES_PLAN_ADJUST_YN = '' OR z.SALES_PLAN_ADJUST_YN IS NULL )  -- 20181023 보완
						--  20181016 KHSONG SALES_PLAN_ADJUST_YN = 'N'인대상에 대해서는 Price Validation 에서 제외
					where 1=1
						and (
								select count(1)
								from [dbo].[SCM_MST_FUTURE_PRICE] p with(nolock)
								where a.v_division_id	= p.division_id
									and a.v_project_code  = p.project_code
									and a.v_scm_site_id	= p.scm_site_id
									and a.v_item_id		= p.item_id
									and a.v_dom_exp		= p.dom_exp
									and a.v_fcst_type		= p.fcst_type
									and a.v_incoterms		= p.INCOTERMS
									and a.v_plant_site_id = CASE WHEN a.v_division_id = '81' THEN p.plant_site_id ELSE a.v_plant_site_id END
									and p.yyyymmdd		= ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] with(nolock) where basis_yyyymmdd = a.v_yyyymmdd )
									and p.price > 0
							) = 0

						----------------------------------------------------------------------------------------------------------------------
						-- 날짜선택 오류수정 20200304 KHSONG (주석처리) BEGIN
						----------------------------------------------------------------------------------------------------------------------
						--and a.v_yyyymmdd between ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] with(nolock) where basis_yyyymmdd = a.v_yyyymmdd ) and ( select basis_start_date + 6 from [dbo].[SCM_SYS_CALENDAR_M] with(nolock) where basis_yyyymmdd = a.v_yyyymmdd )  -- 주석처리
						----------------------------------------------------------------------------------------------------------------------
						-- 날짜선택 오류수정 20200304 KHSONG (주석처리) END
						----------------------------------------------------------------------------------------------------------------------

						----------------------------------------------------------------------------------------------------------------------
						-- 20200304 KHSONG 날짜선택 오류수정 : Partial Week 인경우 2개의 Price값이 존재하므로 구분하여 선택 가능하도록 수정(BEGIN)
						----------------------------------------------------------------------------------------------------------------------
						and a.v_yyyymmdd between ( select basis_start_date  from [dbo].[SCM_SYS_CALENDAR_M] with(nolock) where basis_yyyymmdd = a.v_yyyymmdd ) 
							and ( select CONVERT(CHAR(8), DATEADD(DD, +6,(DATEADD(DD, -7, dbo.FN_NEXT_DAY(basis_yyyymmdd, 'MON')) )),112) from [dbo].[SCM_SYS_CALENDAR_M] with(nolock) where basis_yyyymmdd = a.v_yyyymmdd ) -- 반영로직
						----------------------------------------------------------------------------------------------------------------------
						-- 20200304 KHSONG 날짜선택 오류수정 : Partial Week 인경우 2개의 Price값이 존재하므로 구분하여 선택 가능하도록 수정 (END)
						----------------------------------------------------------------------------------------------------------------------

						--and a.v_measure =  'RTF'  -- 'MKT_FCST'
						and a.v_measure IN ('MKT_FCST','RTF')  -- 20181010
						and a.v_qty <> 0
						and a.v_fcst_type not in ('SDF','SMF','TST','ASF')  -- 20181011 khsong Price가 없는 case Validation 에서 제외  -- 20190115 KHSONG SALES_TYPE_CODE 'ASF' 신규 추가 (ESS측 요청사항)
							)

					IF @s_unit_price_valid IS NOT NULL
						BEGIN
							SET @v_log_type = 'INVALID';
							SET @v_description = @s_unit_price_valid + N'Unit Price Not Found !'+char(10) + N'해당주차의 Sales Price 값을 입력하시기 바랍니다.'
							SELECT @v_description
							GOTO ERR_RTN
						END
	*/
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- 20180816 Unit Price가 없는 MKT_FCST validation (END)  -- 20200529 KHSONG C20200424-000010 주석처리
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
print '83--' + convert(varchar(30), getdate(), 121)		
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- 20181107 RMA FCST_TYPE 음수값 validation (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		IF ( SELECT ISNULL(COUNT(*),0) 
			 FROM #results 
			 WHERE v_fcst_type = 'RMA'
			 AND v_qty > 0 ) > 0
			BEGIN
				SET @v_log_type = 'INVALID';
				SELECT N'반품수량(RMA)은 음수값만 입력가능합니다 !'
				SET @v_description = N'반품수량(RMA)은 음수값만 입력가능합니다 !'
				GOTO ERR_RTN
			END

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- 20181107 RMA FCST_TYPE 음수값 validation (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- 20181108 RMA FCST_TYPE 이외의 MEASURE 정수값 validation (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		IF ( SELECT ISNULL(COUNT(*),0) 
			 FROM #results 
			 WHERE v_fcst_type <> 'RMA'
			 AND v_qty < 0 ) > 0
			BEGIN
				SET @v_log_type = 'INVALID';
				SELECT N'정수값만 입력가능합니다 !'
				SET @v_description = N'정수값만 입력가능합니다 !'
				GOTO ERR_RTN
			END

print '9--' + convert(varchar(30), getdate(), 121)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--  20181108 RMA FCST_TYPE 이외의 MEASURE 정수값 validation (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--Start [C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화
		DECLARE @valid_type	NVARCHAR(100); 
		SET @valid_type = NULL;

		IF ( SELECT COUNT(1)  
			 FROM #results  
			 WHERE v_division_id LIKE '81%') > 0
			BEGIN
				SELECT DIVISION_ID, ITEM_ID, ITEM_NAME,	ITEM_CLASS, ITEM_CLASS_NAME
					 , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
					 , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
					 , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG,CELL_TYPE, ENERGE
					 , CELL_QUANTITY
				INTO #TEMP_DM_MST_ITEM_SINGLE_V
				FROM (  SELECT *
						--FROM DM_MST_ITEM_SINGLE_V T2 WITH(NOLOCK)	--[E20260720-000270]_TEMP로 변경
						FROM #TEMP_DM_MST_ITEM_SINGLE_V_ALL T2 WITH(NOLOCK) --[E20260720-000270]_TEMP로 변경
						INNER JOIN #results A WITH(NOLOCK)
								ON A.v_division_id	   = T2.DIVISION_ID
							   AND A.v_item_id         = T2.ITEM_ID ) G
				GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
					   , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
					   , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
					   , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE, ENERGE
					   , CELL_QUANTITY
			
				CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V] ON [#TEMP_DM_MST_ITEM_SINGLE_V]
				(  division_id   ASC
				 , item_id       ASC
				) WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				;
			
				SET @valid_item_id = (  SELECT TOP 1 A.v_item_id 
										FROM #results A
										LEFT JOIN SCM_MST_SITE_ITEM F  WITH(NOLOCK)
											   ON A.v_division_id	= F.DIVISION_ID
											  AND A.v_item_id       = F.ITEM_ID
											  AND A.v_project_code	= F.PROJECT_CODE
											  AND A.v_scm_site_id	= F.SCM_SITE_ID
										INNER JOIN #TEMP_DM_MST_ITEM_SINGLE_V X  WITH(NOLOCK)
												ON  A.v_division_id	= X.DIVISION_ID
												AND A.v_item_id     = X.ITEM_ID
										WHERE 1=1	/*X.ITEM_TYPE = 'P' --[C20200707-000149] 자동차- 환산정보 Validation에 제품(P), 반제품(H), 원재료(R), 상품(Q) 모두 포함 AND*/
										AND CASE WHEN CHARINDEX('Cell', X.ITEM_CLASS_NAME) > 0 AND ISNULL(F.CELL_PER_CAR, 0) = 0 THEN 1
												 --WHEN CHARINDEX('Module', X.ITEM_CLASS_NAME) > 0 AND (ISNULL(F.CELL_PER_CAR, 0) = 0 OR ISNULL(F.CELL_PER_MODULE, 0) = 0 ) THEN 1
												 WHEN CHARINDEX('Module', X.ITEM_CLASS_NAME) > 0 AND (ISNULL(F.CELL_PER_CAR, 0) = 0) THEN 1
												 WHEN CHARINDEX('Pack', X.ITEM_CLASS_NAME) > 0 AND ISNULL(F.CELL_PER_CAR, 0) = 0  THEN 1
												 ELSE 0
											 END = 1
										-- 20.7.7 [C20200511-000360] WHERE 절에 ITEM_TYPE = 'P' 추가, ITEM_SINGLE_V --> iNNER JOIN 으로 변경
									   )			

				IF @valid_item_id IS NOT NULL
					BEGIN
						SET @valid_type = ISNULL((  SELECT CASE WHEN CHARINDEX('Module', X.ITEM_CLASS_NAME) > 0 THEN 'Cell/Car or Cell/Module'
															  ELSE 'Cell/Car' END
													FROM #TEMP_DM_MST_ITEM_SINGLE_V X  WITH(NOLOCK)
													WHERE X.ITEM_ID = @valid_item_id ) , '')
						SET @v_log_type = 'INVALID';
						SELECT '['+ @valid_item_id +'] ' + @valid_type + N' does not exist !'
						SET @v_description = '['+ @valid_item_id +'] ' + @valid_type + N' does not exist !'
						goto err_rtn
					END
			END		
		--End [C20200511-000360] Sales Site Project Model - 자동차 사업부 Cell , Car 수량 환산 기준정보 필수화

		-- START [C20220713-000194][영업마케팅PI P]GSCM DM 시스템의 각 모델별 Cell,Module,Pack 환산자 누락오류 방안 검토
		IF EXISTS ( SELECT * FROM #RESULTS A WHERE A.v_division_id LIKE '81%' )
			BEGIN					
				SELECT TOP 1 @v_description = N'[' + RTRIM(A.v_item_id) + N'] '
					 + CASE WHEN ( ISNUMERIC(B.ATTRIBUTE8) <  1 OR CAST(B.ATTRIBUTE8 AS NUMERIC(28,8)) < = 0)
							THEN 'Kwh/Cell does not exist !'
							WHEN B.ATTRIBUTE10 NOT IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)/*[E20260720-000270]_WITH(NOLOCK)추가*/WHERE LOOKUP_TYPE ='CELL_TYPE_INFO' AND SEGMENT1 LIKE '81%' AND VALID_YN = 'Y' )
							THEN 'CELL_TYPE does not exist !'
							WHEN ISNULL(B.CELL_PER_CAR,0) < = 0
							THEN 'Cell/Car does not exist !'
							--WHEN ISNULL(B.CELL_PER_MODULE,0) < = 0
							--		THEN 'Cell/Module does not exist !'
						END
					 + CHAR(10) + N'Sales Site Project Model 에서 해당 항목을 채워주세요.'
				FROM #RESULTS A
				JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK)--[E20260720-000270]_WITH(NOLOCK)추가
				  ON A.v_division_id	= B.DIVISION_ID
				 AND A.v_project_code	= B.PROJECT_CODE
				 AND A.v_scm_site_id	= B.SCM_SITE_ID
				 AND A.v_item_id		= B.ITEM_ID
				JOIN #TEMP_DM_MST_ITEM_SINGLE_V C
				  ON A.v_division_id	= C.DIVISION_ID 
				 AND A.v_item_id		= C.ITEM_ID
				AND C.ITEM_TYPE			= 'P'
				WHERE A.v_division_id LIKE '81%'
				AND ( --Kwh/Cell
					  ( ISNUMERIC(B.ATTRIBUTE8) <  1	-- NULL, 공백, 문자형 걸러짐
						OR CAST(B.ATTRIBUTE8 AS NUMERIC(28,18)) < = 0	-- 0 또는 음수는 여기에서 걸러짐 
					  )
					  -- CELL_TYPE
					  OR B.ATTRIBUTE10 NOT IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)/*[E20260720-000270]_WITH(NOLOCK)추가*/ WHERE LOOKUP_TYPE ='CELL_TYPE_INFO' AND SEGMENT1 LIKE '81%' AND VALID_YN = 'Y' )
					  -- Cell/Car
					  OR ISNULL(B.CELL_PER_CAR,0) < = 0
					  --Cell/Module
					  --OR ISNULL(B.CELL_PER_MODULE,0) < = 0
					  )
					IF @v_description <> ''
						BEGIN
							SET @v_log_type = 'INVALID';
							SELECT @v_description
							GOTO ERR_RTN
						END

			END
		-- END [C20220713-000194][영업마케팅PI P]GSCM DM 시스템의 각 모델별 Cell,Module,Pack 환산자 누락오류 방안 검토
		
		-- [C20200804-000123] SSP 동기화 수량보다 작은 수량으로 수정 불가 ( 소형 & MKT FCST 메저 )	------------	START
		IF EXISTS ( SELECT * FROM #results WHERE v_division_id = '40' AND v_measure = 'MKT_FCST' )
			BEGIN
				-- 아래에서 I/O 처리시 DELETE 후 INSERT 이므로 ATTRIBUTE를 보존하기 위해 업데이트
				UPDATE A
				SET v_attribute1 = B.ATTRIBUTE1
				  , v_attribute2 = B.ATTRIBUTE2
				  , v_attribute3 = B.ATTRIBUTE3
				  , v_attribute4 = B.ATTRIBUTE4 --[C20210225-000385] 동기화된 CONFIRM_ID
				  , v_attribute5 = B.ATTRIBUTE5 --[C20210225-000385] Carry Over 된 CONFIRM_ID
				FROM #RESULTS A
				JOIN DM_PLN_MKT_FCST B WITH(NOLOCK)--[E20260720-000270]_WITH(NOLOCK)추가
				  ON B.DIVISION_ID	= A.v_division_id
				 AND B.PROJECT_CODE	= A.v_project_code
				 AND B.SCM_SITE_ID	= A.v_scm_site_id
				 AND B.ITEM_ID		= A.v_item_id
				 AND B.DOM_EXP		= A.v_dom_exp
				 AND B.FCST_TYPE	= A.v_fcst_type
				 AND B.INCOTERMS	= A.v_incoterms
				 AND B.MEASURE		= A.v_measure
				 AND B.YYYYMMDD		= A.v_yyyymmdd
				 AND B.MEASURE		= 'MKT_FCST'
				 AND ISNUMERIC(B.ATTRIBUTE1) > 0 
				 AND B.DIVISION_ID = @v_division_id
				 --AND B.PLANT_SITE_ID = A.V_PLANT_SITE_ID
				 --AND A.v_measure = 'MKT_FCST_RP'
				 JOIN SCM_MST_SITE C 
				   ON B.DIVISION_ID	= C.DIVISION_ID
				  AND B.SCM_SITE_ID	= C.SCM_SITE_ID
				  AND C.VMI_YN <> 'Y'
						
				--  [C20210112-000446] [SCM PI팀] 소형사업부 MKT FCST - SSP 동기화 
				-- 1. 삭제가 아닌 건 중 QTY < DM_PLN_MKT_FCST.ATTRIBUTE1 인 경우 구분 ( 계획구간의 첫 월요일은 제외 )
				-- ※ MKT FCST 에서는 삭제 플래그는 없음. 해당 행을 0으로 처리함
				-- [C20210225-000385] 동기화 수량보다 작은 수량은 입력 불가(원복)
				SELECT A.v_project_code	AS PROJECT_CODE
					 , A.v_scm_site_id	AS SCM_SITE_ID
					 , A.v_item_id		AS ITEM_ID
					 , A.v_dom_exp		AS DOM_EXP
					 , A.v_fcst_type	AS FCST_TYPE
					 , A.v_incoterms	AS INCOTERMS
					 , A.v_measure		AS MEASURE
					 , A.v_yyyymmdd		AS YYYYMMDD
					 , CASE WHEN ISNUMERIC(A.v_attribute2) > 0 THEN CAST(A.v_attribute2 AS NUMERIC(30,10)) ELSE 0 END
					 + CASE WHEN ISNUMERIC(A.v_attribute3) > 0 THEN CAST(A.v_attribute3 AS NUMERIC(30,10)) ELSE 0 END
					 AS SYNC_QTY
					, A.V_QTY			AS QTY
				INTO #T_ERR
				FROM #RESULTS A
				JOIN SCM_MST_SITE C WITH(NOLOCK)--[E20260720-000270]_WITH(NOLOCK)추가
				  ON A.v_division_id = C.DIVISION_ID
				 AND A.v_scm_site_id = C.SCM_SITE_ID
				 AND C.VMI_YN <> 'Y'
				WHERE A.v_division_id = @v_division_id
				AND ISNUMERIC(A.v_attribute1) > 0
				AND A.v_measure = 'MKT_FCST'
				AND CASE WHEN ISNUMERIC(A.v_attribute2) > 0 THEN CAST(A.v_attribute2 AS NUMERIC(30,10)) ELSE 0 END
				  + CASE WHEN ISNUMERIC(A.v_attribute3) > 0 THEN CAST(A.v_attribute3 AS NUMERIC(30,10)) ELSE 0 END
					> A.V_QTY
				AND A.v_yyyymmdd <> CONVERT(CHAR(8), DATEADD(DD, -7*1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		
				IF EXISTS ( SELECT * FROM #T_ERR )
					BEGIN
						SET @v_log_type = 'INVALID';
						SELECT N'SSP 동기화 수량보다 작은 수량으로 수정된 건이 있습니다.'
						SET @v_description = N'SSP 동기화 수량보다 작은 수량으로 수정된 건이 있습니다.'
						
						GOTO err_rtn
					END		
			END	
	-- [C20200804-000123] END	------------

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- 20180703 KHSONG 저장하려는 ITEM의 11주 구간에 BOM이 없으면 값을 저장하지 못하도록 함. SELECT count가 0 이면 BOM 이 없다고 Alert을 띄우고 ROLLBACK시킴 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--IF (SELECT count(1) FROM #results where v_division_id = '40') = 0  --20180914-1   KHSONG (20180810-1 KHSONG 소형은 BOM Validation 에서 제외) 부분 주석처리하여 소형도 로직적용
		BEGIN
		--PRINT 'VALIDATION_2 START                               =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
			UPDATE A
			SET V_BOM_YN = 'N'
			FROM #RESULTS A
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
			  ON B.LOOKUP_TYPE		= 'AS_SITE_PLANT' 
			AND B.SEGMENT3			= @v_division_id
			AND B.VALID_YN			= 'Y'
			AND A.v_attribute10		= B.SEGMENT2
			JOIN SCM_MST_ITEM_SN C WITH(NOLOCK) 
			  ON A.v_division_id	= C.DIVISION_ID
			 AND A.v_item_id		= C.ITEM_ID
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
			  ON D.LOOKUP_TYPE		= 'DM_BOM_EXCEPT_CLASS'
			 AND D.VALID_YN			= 'Y'
			 AND C.EVAL_CLASS		= D.SEGMENT1
			WHERE A.v_division_id	= @v_division_id
			AND A.v_measure			= 'MKT_FCST'

			IF EXISTS(SELECT * FROM #RESULTS WHERE V_BOM_YN IS NULL)
			BEGIN
				-- 저장전 변수 초기화
				DECLARE @valid_bom		 NVARCHAR(MAX);
				DECLARE @valid_shipto    NVARCHAR(MAX);

				SET @valid_bom	 = NULL
				SET @valid_shipto = NULL

				SET @valid_bom = (	SELECT TOP 1 A.v_item_id
									FROM #results A
									--INNER JOIN [DBO].[DM_MST_ITEM_SINGLE_V] C  WITH (NOLOCK) --[E20260720-000270]_테이블 변경 주석처리
									INNER JOIN #TEMP_DM_MST_ITEM_SINGLE_V_ALL C  WITH (NOLOCK)  --[E20260720-000270]_테이블 변경
											ON  A.v_item_id			= C.ITEM_ID
											AND A.v_division_id		= C.DIVISION_ID
											AND C.ITEM_TYPE			IN ( 'P','H' )
											AND C.ACTIVE_FLAG		= 'Y' --20180720 ACTIVE_FLAG 조건추가
									LEFT JOIN [DBO].[SCM_MST_BOM_ENG_SN] X  WITH(INDEX = [PK_SCM_BOM_M], NOLOCK) --[E20260720-000270]_속도개선으로 INDEX 추가
										   ON  A.v_division_id		= X.DIVISION_ID
										  AND A.v_item_id			= X.PARENT_ITEM_ID
									LEFT JOIN (	SELECT DIVISION_ID, CASE WHEN DIVISION_ID IN ('82','40') THEN '' ELSE FROM_SITE END FROM_SITE , TO_SITE, INCOTERMS, MIN(LT_TOTAL) LT_TOTAL --20180914 소형도 FROM_SITE 조건에 추가
												FROM [DBO].[SCP_MST_BOD_V] WITH(NOLOCK)
												WHERE PRIORITY = 1
												GROUP BY DIVISION_ID, CASE WHEN DIVISION_ID IN ('82','40') THEN '' ELSE FROM_SITE END , TO_SITE, INCOTERMS  --20180914 소형도 FROM_SITE 조건에 추가
											   ) BOD  
											ON  A.v_division_id		= BOD.DIVISION_ID
										   AND A.V_PLANT_SITE_ID	= BOD.FROM_SITE
										   AND A.v_scm_site_id		= BOD.TO_SITE
										   AND A.v_incoterms		= BOD.INCOTERMS
									WHERE A.v_measure	IN ('MKT_FCST','Vmi_In_Req')
									AND A.v_yyyymmdd	>= CONVERT(CHAR(8), DATEADD(DD, -7*1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주 월요일부터
									AND A.v_yyyymmdd	< CONVERT(CHAR(8), DATEADD(DD, ISNULL(LT_TOTAL,0)+(7*10) , DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주 월요일 + 11주 까지
									AND A.V_QTY			> 0
									AND X.PARENT_ITEM_ID IS NULL  -- 존재하지 않는대상
									AND A.v_item_id NOT IN ('ECE0074N5-01')  -- 20190614 김성은 책임 요청으로 'ECE0074N5-01' item bom 검증 조건에서 임시 해제시킴
									AND A.v_item_id NOT IN ('MCCH120022B2-K','MCCH120022B2-GD')  -- 20190708 김성은 책임 요청으로 item bom 검증 조건에서 임시 해제시킴
									AND A.V_BOM_YN IS NULL
									)

				IF @valid_bom IS NOT NULL
					BEGIN
						SET @v_log_type = 'INVALID';
						SELECT '['+ @valid_bom +']'+ N' BOM does not exist !'
						SET @v_description = '['+ @valid_bom +']'+ N' BOM does not exist !'
						goto err_rtn
					END
				END
		END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--  20180703 KHSONG 저장하려는 ITEM의 11주 구간에 BOM이 없으면 값을 저장하지 못하도록 함. SELECT count가 0 이면 BOM 이 없다고 Alert을 띄우고 ROLLBACK시킴 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
print '10--' + convert(varchar(30), getdate(), 121)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- 20180703 KHSONG 저장하려는 SITE의 11주 구간에 SHIPTO 연결 없으면 값을 저장하지 못하도록 함. SELECT count가 0 이면 scm_site_id 가 없다고 Alert을 띄우고 ROLLBACK시킴 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--IF (SELECT count(1) FROM #results where v_division_id = '40') = 0  --20180914-2 KHSONG (20180810-3 KHSONG 소형은 SHIP-TO Validation 에서 제외) 부분 주석처리하여 소형도 로직적용
		BEGIN
			SET @valid_shipto =	( SELECT TOP 1 A.v_scm_site_id
								  FROM #results A
								  LEFT JOIN [DBO].[SCM_MST_SITE_CUSTOMER] X  WITH(NOLOCK)
										 ON A.v_division_id	= X.DIVISION_ID
										AND A.v_scm_site_id     = X.SCM_SITE_ID
										AND X.VALID_YN			= 'Y'
										AND X.REP_YN			= 'Y'
								  LEFT JOIN ( SELECT DIVISION_ID, CASE WHEN DIVISION_ID IN ('82','40') THEN '' ELSE FROM_SITE END FROM_SITE , TO_SITE, INCOTERMS, MIN(LT_TOTAL) LT_TOTAL --20180914 소형도 FROM_SITE 조건에 추가
										  	  FROM [DBO].[SCP_MST_BOD_V] WITH(NOLOCK)
											  WHERE PRIORITY = 1
											  GROUP BY DIVISION_ID, CASE WHEN DIVISION_ID IN ('82','40') THEN '' ELSE FROM_SITE END , TO_SITE, INCOTERMS --20180914 소형도 FROM_SITE 조건에 추가
											 ) BOD  
										 ON A.v_division_id		= BOD.DIVISION_ID
										AND A.V_PLANT_SITE_ID	= BOD.FROM_SITE
										AND A.v_scm_site_id		= BOD.TO_SITE
										AND A.v_incoterms		= BOD.INCOTERMS
								  WHERE A.v_measure	IN ('MKT_FCST','Vmi_In_Req')
								  AND A.v_yyyymmdd	>= CONVERT(CHAR(8), DATEADD(DD, -7*1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주 월요일부터
								  AND A.v_yyyymmdd	< CONVERT(CHAR(8), DATEADD(DD, ISNULL(LT_TOTAL,0)+(7*3) , DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- BOD LT + 4W
								  AND A.V_QTY			> 0
								  AND X.SHIPTO_CODE IS NULL
								)

			IF @valid_shipto IS NOT NULL
				BEGIN
					SET @v_log_type = 'INVALID';
					SELECT '['+ @valid_shipto +']'+ N' SITE SHIP-TO does not exist !'
					SET @v_description = '['+ @valid_shipto +']'+ N' SITE SHIP-TO does not exist !'
					goto err_rtn
				END
		END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- 20180703 KHSONG 저장하려는 SITE의 11주 구간에 SHIPTO 연결 없으면 값을 저장하지 못하도록 함. SELECT count가 0 이면 scm_site_id 가 없다고 Alert을 띄우고 ROLLBACK시킴 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- 2021.4.20 hwi1993 [PJ20209642R]과제 - PR Request 가 존재하는 건들은 수정 못하도록 함.
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		IF EXISTS ( SELECT * FROM #RESULTS WHERE v_division_id = '82' AND v_measure = 'BNPIn')
		BEGIN		
			SELECT DISTINCT B.SCM_SITE_ID, B.ITEM_ID, B.FCST_TYPE, B.YYYYMMDD
			INTO #T_ERR2
			FROM #results A
			JOIN DM_PLN_PR_DETAIL B WITH(NOLOCK)--[E20260720-000270]_WITH(NOLOCK)추가
			  ON A.v_division_id	= B.DIVISION_ID		
			 AND A.v_project_code	= B.PROJECT_CODE	
			 AND A.v_scm_site_id	= B.SCM_SITE_ID	
			 AND A.v_item_id		= B.ITEM_ID		
			 AND A.v_dom_exp		= B.DOM_EXP		
			 AND A.v_fcst_type		= B.FCST_TYPE		
			 AND A.v_incoterms		= B.INCOTERMS		
			 AND A.v_PLANT_SITE_ID	= B.PLANT_SITE_ID	
			 AND A.v_yyyymmdd		= B.YYYYMMDD	
			
			IF EXISTS ( SELECT * FROM #T_ERR2 )
			BEGIN		
				DECLARE @v_ERR_CNT NVARCHAR(10)

				SELECT @V_ERR_CNT = COUNT(*) FROM #T_ERR2
						
				SET @v_log_type = 'INVALID';
				SELECT TOP 1 
					  N'[Sales Site:' + RTRIM(SCM_SITE_ID) + N']'
					+ N'[Model :' + RTRIM(ITEM_ID) + N']'
					+ N'[FCST Type :' + RTRIM(FCST_TYPE) + N']'
					+ N'[YYYYMMDd :' + RTRIM(YYYYMMDD) + N']'
					+ CASE WHEN @V_ERR_CNT > 1 THEN N'외 ' + CAST(@V_ERR_CNT-1 AS NVARCHAR(3)) + N'건' ELSE ' ' END
					+ N'은 기 Request 가 생성된 건입니다. \r\n ADD History 팝업을 이용해서 수정해주세요'
				FROM #T_ERR2
				
				SELECT TOP 1 @v_description = 
					  N'[Sales Site:' + RTRIM(SCM_SITE_ID) + N']'
					+ N'[Model :' + RTRIM(ITEM_ID) + N']'
					+ N'[FCST Type :' + RTRIM(FCST_TYPE) + N']'
					+ N'[YYYYMMDd :' + RTRIM(YYYYMMDD) + N']'
					+ CASE WHEN @V_ERR_CNT > 1 THEN N'외 ' + CAST(@V_ERR_CNT-1 AS NVARCHAR(3)) + N'건' ELSE ' ' END
					+ N'은 기 Request 가 생성된 건입니다. \r\n ADD History 팝업을 이용해서 수정해주세요'
				FROM #T_ERR2
				goto err_rtn
			END
		END

		-- ATTRIBUTE9 가 '' 이 아닌 경우 수정불가 ( ESS )
		IF EXISTS ( SELECT * FROM #RESULTS WHERE v_division_id = '82' AND v_measure = 'BNPIn')
		BEGIN 
			UPDATE A
			SET V_ATTRIBUTE9 = B.ATTRIBUTE9
			FROM #RESULTS A
			JOIN DM_PLN_MKT_FCST B WITH(NOLOCK)--[E20260720-000270]_WITH(NOLOCK)추가
			  ON B.DIVISION_ID	= A.v_division_id
			 AND B.PROJECT_CODE = A.v_project_code
			 AND B.SCM_SITE_ID	= A.v_scm_site_id
			 AND B.ITEM_ID		= A.v_item_id
			 AND B.DOM_EXP		= A.v_dom_exp
			 AND B.FCST_TYPE	= A.v_fcst_type
			 AND B.INCOTERMS	= A.v_incoterms
			 AND B.MEASURE		= A.v_measure
			 AND B.YYYYMMDD		= A.v_yyyymmdd
			 AND B.MEASURE		= 'BNPIn'
			 AND B.DIVISION_ID	= @v_division_id
					
			 IF EXISTS ( SELECT * FROM #RESULTS WHERE ISNULL(V_ATTRIBUTE9,'') <> '' )
			 BEGIN				
				SELECT @V_ERR_CNT = COUNT(*)
				FROM #RESULTS
				WHERE ISNULL(V_ATTRIBUTE9,'') <> ''
						
				SET @v_log_type = 'INVALID';
				SELECT TOP 1 
					N'[Sales Site:' + RTRIM(v_scm_site_id) + N']'
					+ N'[Model :' + RTRIM(v_item_id) + N']'
					+ N'[FCST Type :' + RTRIM(v_fcst_type) + N']'
					+ N'[YYYYMMDd :' + RTRIM(v_yyyymmdd) + N']'
					+ CASE WHEN @V_ERR_CNT > 1 THEN N'외 ' + CAST(@V_ERR_CNT-1 AS NVARCHAR(3)) + N'건' ELSE ' ' END
					+ N'은 기 Confirm ID 가 생성된 건입니다. \r\n ADD History 팝업을 이용해서 수정해주세요'
				FROM #RESULTS
				WHERE ISNULL(V_ATTRIBUTE9,'') <> ''
			
				SELECT TOP 1 @v_description = 
					N'[Sales Site:' + RTRIM(v_scm_site_id) + N']'
					+ N'[Model :' + RTRIM(v_item_id) + N']'
					+ N'[FCST Type :' + RTRIM(v_fcst_type) + N']'
					+ N'[YYYYMMDd :' + RTRIM(v_yyyymmdd) + N']'
					+ CASE WHEN @V_ERR_CNT > 1 THEN N'외 ' + CAST(@V_ERR_CNT-1 AS NVARCHAR(3)) + N'건' ELSE ' ' END
					+ N'은 기 Confirm ID 가 생성된 건입니다. \r\n ADD History 팝업을 이용해서 수정해주세요'
				FROM #RESULTS
				WHERE ISNULL(V_ATTRIBUTE9,'') <> ''

				goto err_rtn
			 END
		END

	---- AS PLANT 가 없는 경우 WS 계열 FCST_TYPE 입력 불가
	--IF EXISTS ( SELECT * 
	--			FROM #RESULTS A
	--			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.FCST_TYPE = B.SEGMENT1 AND B.ATTRIBUTE2 = 'Y' AND T5.LOOKUP_TYPE = 'SALES_TYPE_CODE'
				
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	

print '11--' + convert(varchar(30), getdate(), 121)

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--  INPUT MEASURE 중복값 delete후 INSERT (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
--3. MKT FCST 테이블 INSERT
--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■	

		--[E20250313-001251]_bucket = 'Monthly' or 'Weekly'인 경우 우선 데이터를 0으로 UPDATE를 한뒤 데이터 작업을 시작한다. START
		IF (@p_bucket = 'MONTHLY')
		BEGIN 				
			UPDATE A
			SET A.QTY = 0 
			FROM DM_PLN_MKT_FCST A
			JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD
			JOIN ( SELECT v_division_id
						, v_project_code
						, v_scm_site_id
						, v_item_id
						, v_dom_exp
						, v_fcst_type
						, v_incoterms
						, v_measure
						, B.BASIS_YYYYMM
						, v_plant_site_id
						, B.ISO_YYYYWW
					FROM #results A
					JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) 
					  ON A.v_yyyymmdd = B.BASIS_YYYYMMDD
				) C ON  A.DIVISION_ID		= C.v_division_id
					AND A.PROJECT_CODE		= C.v_project_code
					AND A.SCM_SITE_ID		= C.v_scm_site_id
					AND A.ITEM_ID			= C.v_item_id
					AND A.DOM_EXP			= C.v_dom_exp
					AND A.FCST_TYPE			= C.v_fcst_type
					AND A.INCOTERMS			= C.v_incoterms
					AND A.MEASURE			= C.v_measure
					AND A.PLANT_SITE_ID		= C.v_plant_site_id
					AND B.BASIS_YYYYMM		= C.BASIS_YYYYMM
		END
		ELSE IF (@p_bucket = 'WEEKLY')
		BEGIN 			
			UPDATE A
			SET A.QTY = 0 
			FROM DM_PLN_MKT_FCST A
			JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD
			JOIN ( SELECT v_division_id
						, v_project_code
						, v_scm_site_id
						, v_item_id
						, v_dom_exp
						, v_fcst_type
						, v_incoterms
						, v_measure
						, B.BASIS_YYYYMM
						, v_plant_site_id
						, B.ISO_YYYYWW
					FROM #results A
					JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) 
					  ON A.v_yyyymmdd = B.BASIS_YYYYMMDD
				) C ON  A.DIVISION_ID		= C.v_division_id
					AND A.PROJECT_CODE		= C.v_project_code
					AND A.SCM_SITE_ID		= C.v_scm_site_id
					AND A.ITEM_ID			= C.v_item_id
					AND A.DOM_EXP			= C.v_dom_exp
					AND A.FCST_TYPE			= C.v_fcst_type
					AND A.INCOTERMS			= C.v_incoterms
					AND A.MEASURE			= C.v_measure
					AND A.PLANT_SITE_ID		= C.v_plant_site_id
					AND B.BASIS_YYYYMM		= C.BASIS_YYYYMM
					AND B.ISO_YYYYWW		= C.ISO_YYYYWW
		END
		--[E20250313-001251]_bucket = 'Monthly' or 'Weekly'인 경우 우선 데이터를 0으로 UPDATE를 한뒤 데이터 작업을 시작한다. END

		BEGIN		
		--[] 81 -VMI 에 MKT FCST 가 있으면 VMI IN REQ 메저도 동일하게 생성/삭제한다.
		IF EXISTS ( SELECT * 
					FROM #results A
					JOIN SCM_MST_SITE B ON A.v_scm_site_id = B.SCM_SITE_ID AND A.v_division_id = B.DIVISION_ID AND B.VMI_YN = 'Y'
					WHERE A.v_division_id LIKE '81%'
					AND A.v_measure = 'MKT_FCST')
			BEGIN
				INSERT INTO #results 
				( v_active_flag, v_division_id, v_project_code, v_scm_site_id, v_item_id      
				, v_dom_exp, v_fcst_type, v_incoterms, v_measure, v_plant_site_id
				, v_yyyymmdd, v_qty, v_created_by, v_attribute10 ) 
				SELECT v_active_flag, v_division_id, v_project_code, v_scm_site_id, v_item_id      
					 , v_dom_exp, v_fcst_type, v_incoterms, N'VMI_In_Req' AS v_measure, v_plant_site_id
					 , v_yyyymmdd, v_qty, v_created_by, v_attribute10  
				FROM #results A
				JOIN SCM_MST_SITE B WITH(NOLOCK)--[E20260720-000270]_WITH(NOLOCK)추가
				  ON A.v_scm_site_id = B.SCM_SITE_ID 
				 AND A.v_division_id = B.DIVISION_ID 
				 AND B.VMI_YN = 'Y'
				WHERE A.v_division_id LIKE '81%'
				AND A.v_measure = 'MKT_FCST'
			END
		
			DELETE 
			FROM dbo.DM_PLN_MKT_FCST
			WHERE EXISTS (  SELECT v_division_id
							FROM #results 
							WHERE 1=1
							AND division_id        =   v_division_id      
							AND project_code       =   v_project_code   
							AND scm_site_id        =   v_scm_site_id  
							AND item_id            =   v_item_id      
							AND dom_exp            =   v_dom_exp      
							AND fcst_type          =   v_fcst_type    
							AND incoterms          =   v_incoterms    
							AND measure            =   v_measure      
							AND plant_site_id      =   v_plant_site_id
							AND yyyymmdd           =   v_yyyymmdd
						  )

			INSERT INTO dbo.DM_PLN_MKT_FCST 
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
			, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
			, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			)
			SELECT v_division_id, v_project_code, v_scm_site_id, v_item_id, v_dom_exp
				 , v_fcst_type, v_incoterms, v_measure, v_plant_site_id, v_yyyymmdd
				 , v_qty, v_created_by, getdate(), v_created_by, getdate()
				 , v_attribute1, v_attribute2, v_attribute3, v_attribute4, v_attribute5--[C20210225-000385]동기화,CarryOver된CONFIRM_ID
				 , null, null, null, null, v_attribute10
			FROM #results 
			WHERE 1=1

print '12--' + convert(varchar(30), getdate(), 121)
				
			------------------------------------------------------------------------------------------------------------------------------------
			--[C20201103-000114]	ESS 법인 MKT_FCST 메저에 따라 VMI_IN_REQ 자동 계산
			------------------------------------------------------------------------------------------------------------------------------------
			DECLARE @Ev_division_id		NVARCHAR(30)
				  , @Ev_scm_site_id     NVARCHAR(50)
				  , @Ev_project_code	NVARCHAR(50)
				  , @Ev_item_id			NVARCHAR(50)
				  , @Ev_dom_exp			NVARCHAR(3)
				  , @Ev_fcst_type		NVARCHAR(20)
				  , @Ev_incoterms		NVARCHAR(10)
				  , @EV_PLANT_SITE_ID	NVARCHAR(30)
				  , @EV_DIO				INT				-- 재고일수
				  , @EV_BINV			INT				-- 기초재고

			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR_ESSVMI1')
				BEGIN
					CLOSE CURSOR_ESSVMI1
					DEALLOCATE CURSOR_ESSVMI1
				END

			DECLARE CURSOR_ESSVMI1 CURSOR FAST_FORWARD FOR
			--SELECT DISTINCT A.v_division_id, A.v_scm_site_id, A.v_project_code, A.v_item_id, A.v_dom_exp
			--		, A.v_fcst_type, A.v_incoterms, A.V_PLANT_SITE_ID
			--		, CASE WHEN ISNUMERIC(ISNULL(ATTRIBUTE5, '')) > 0 THEN ATTRIBUTE5 ELSE 0 END AS V_DIO
			--FROM  #results A
			--JOIN SCM_MST_SITE B ON A.v_division_id = B.DIVISION_ID AND A.v_scm_site_id = B.SCM_SITE_ID
			--WHERE 1=1
			--	AND A.v_measure = 'MKT_FCST'
			--	AND A.V_VMI_YN = 'Y'
			--	AND A.v_division_id = '82'				

			--[E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선건으로 기존 SCM_MST_SITE ATTRIBUTE5에서 SSPM INVENTORY DAYS 컬럼으로 변경 [START]
			SELECT DISTINCT A.v_division_id, A.v_scm_site_id, A.v_project_code, A.v_item_id, A.v_dom_exp
					, A.v_fcst_type, A.v_incoterms, A.V_PLANT_SITE_ID
					, CASE WHEN ISNUMERIC(ISNULL(B.INVENTORY_DAY, '')) > 0 THEN B.INVENTORY_DAY ELSE 0 END AS V_DIO
			FROM  #results A
			JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK)--[E20260720-000270]_WITH(NOLOCK)추가
			  ON A.v_division_id	= B.DIVISION_ID 
			 AND A.v_scm_site_id	= B.SCM_SITE_ID 
			 AND A.v_item_id		= B.ITEM_ID 
			 AND A.v_project_code	= B.PROJECT_CODE
			WHERE 1=1
			AND A.v_measure = 'MKT_FCST'
			AND A.V_VMI_YN = 'Y'
			AND A.v_division_id = '82'
			--[E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선건으로 기존 SCM_MST_SITE ATTRIBUTE5에서 SSPM INVENTORY DAYS 컬럼으로 변경 [END]

			--SELECT * FROM #results
				
			BEGIN
				OPEN CURSOR_ESSVMI1;
				FETCH NEXT FROM CURSOR_ESSVMI1 INTO @Ev_division_id, @Ev_scm_site_id, @Ev_project_code, @Ev_item_id
													, @Ev_dom_exp, @Ev_fcst_type, @Ev_incoterms, @EV_PLANT_SITE_ID, @EV_DIO
			END

			---------------------------------------------------------------------------------------- WHILE_m4 LOOP START
			WHILE @@FETCH_STATUS = 0   
			----------------------------------------------------------------------------------------
			BEGIN
			--SELECT 'x0', @Ev_division_id, @Ev_scm_site_id, @Ev_project_code, @Ev_item_id
			--														, @Ev_dom_exp, @Ev_fcst_type, @Ev_incoterms, @EV_PLANT_SITE_ID, @EV_DIO
				-- 기초재고를 가져온다.
				SET @EV_BINV = 0;

				SELECT @EV_BINV = ISNULL(QTY,0)
				FROM DM_PLN_MKT_FCST_RESULT A WITH(NOLOCK)--[E20260720-000270]_WITH(NOLOCK)추가
				WHERE A.DIVISION_ID = '82'
				AND A.MEASURE		= 'VMI_Inv'
				AND A.YYYYMMDD		= CONVERT(CHAR(8), DATEADD(DD, -8, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	-- 실적구간 마지막일자
				AND A.SCM_SITE_ID	= @Ev_scm_site_id
				AND A.PROJECT_CODE	= @Ev_project_code
				AND A.ITEM_ID		= @Ev_item_id
				AND A.DOM_EXP		= @Ev_dom_exp
				AND A.FCST_TYPE		= @Ev_fcst_type
				AND A.INCOTERMS		= @Ev_incoterms
				AND A.PLANT_SITE_ID = @EV_PLANT_SITE_ID			
				AND A.CELL_PROD_SITE_ID = '-'					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가		
							
				-- 해당 SITE 의 미래구간의 VMI_IN_REQ 를 모두 지운다.									   
				DELETE A
				FROM DM_PLN_MKT_FCST A
				WHERE A.DIVISION_ID = '82'
				AND A.MEASURE		= 'VMI_In_Req'
				AND A.YYYYMMDD		>= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) --	계획구간만
				AND A.SCM_SITE_ID	= @Ev_scm_site_id
				AND A.PROJECT_CODE	= @Ev_project_code
				AND A.ITEM_ID		= @Ev_item_id
				AND A.DOM_EXP		= @Ev_dom_exp
				AND A.FCST_TYPE		= @Ev_fcst_type
				AND A.INCOTERMS		= @Ev_incoterms
				AND A.PLANT_SITE_ID = @EV_PLANT_SITE_ID
--SELECT 'X1', @@ROWCOUNT

				-------------------------------		계산			-----------------------------------------------------------
				INSERT INTO DM_PLN_MKT_FCST 
				( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
				, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
				, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
				SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE
					 , X.INCOTERMS, 'VMI_In_Req' as MEASURE
					 , CONVERT(CHAR(8), DATEADD(DAY, -@EV_DIO, X.YYYYMMDD), 112)		-- MKT FCST 의 일자를 기준으로 집계했으므로 재고일수만큼 앞으로 밀어준다.
					 , X.PLANT_SITE_ID
					 , CASE	WHEN ROW_NUM <= @EV_DIO THEN 0
							WHEN ROW_NUM = @EV_DIO + 1 THEN CASE WHEN SUM_QTY > @EV_BINV THEN SUM_QTY - @EV_BINV ELSE 0 END		-- 재고일수를 처음 넘어가는 날
							WHEN SUM_QTY > @EV_BINV AND BF_SUM <= @EV_BINV THEN SUM_QTY - @EV_BINV	-- 처음으로 기초재고를 넘어가는 행
							WHEN BF_SUM > @EV_BINV  THEN QTY
							ELSE 0
						END AS QTY
					 , @V_CREATED_BY, GETDATE(), @V_CREATED_BY, GETDATE()
				FROM ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
							, A.INCOTERMS, A.YYYYMMDD, A.PLANT_SITE_ID
							, SUM(A.QTY) OVER ( ORDER BY A.YYYYMMDD ) AS SUM_QTY
							, SUM(A.QTY) OVER ( ORDER BY A.YYYYMMDD ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ) AS BF_SUM
							, QTY
							, ROW_NUMBER() OVER ( ORDER BY A.YYYYMMDD ) AS ROW_NUM
						FROM (	SELECT A.BASIS_YYYYMMDD AS YYYYMMDD, 'MKT_FCST' AS MEASURE, ISNULL(B.QTY, 0) AS QTY
									 , @Ev_division_id AS DIVISION_ID, @Ev_scm_site_id AS SCM_SITE_ID, @Ev_project_code AS PROJECT_CODE, @Ev_item_id AS ITEM_ID
									 , @Ev_dom_exp AS DOM_EXP, @Ev_fcst_type AS FCST_TYPE, @Ev_incoterms AS INCOTERMS, @EV_PLANT_SITE_ID AS PLANT_SITE_ID
								FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)--[E20260720-000270]_WITH(NOLOCK)추가
								LEFT OUTER JOIN DM_PLN_MKT_FCST B WITH(NOLOCK) --[E20260720-000270]_WITH(NOLOCK)추가
											 ON A.BASIS_YYYYMMDD	= B.YYYYMMDD AND B.MEASURE = 'MKT_FCST'
											AND B.DIVISION_ID		= '82'	
											AND B.SCM_SITE_ID		= @Ev_scm_site_id
											AND B.PROJECT_CODE		= @Ev_project_code
											AND B.ITEM_ID			= @Ev_item_id
											AND B.DOM_EXP			= @Ev_dom_exp
											AND B.FCST_TYPE			= @Ev_fcst_type
											AND B.INCOTERMS			= @Ev_incoterms
											AND B.PLANT_SITE_ID		= @EV_PLANT_SITE_ID
								WHERE A.BASIS_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	--	계획구간만
								AND A.BASIS_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, CASE WHEN @EV_DIO > 0 THEN @EV_DIO + 1 ELSE @EV_DIO + 10 END + 7*84, CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112) 
								-- [C20201217-000126], [C20210811-000230] 62주에서 92주로 확장(MKT FCST 메저 기준), [C20210817-000420]
							 ) A
						) X
				WHERE CASE WHEN ROW_NUM <= @EV_DIO THEN 0
						   WHEN ROW_NUM = @EV_DIO + 1 THEN CASE WHEN SUM_QTY > @EV_BINV THEN SUM_QTY - @EV_BINV ELSE 0 END		-- 재고일수를 처음 넘어가는 날
						   WHEN SUM_QTY > @EV_BINV AND BF_SUM <= @EV_BINV THEN SUM_QTY - @EV_BINV	-- 처음으로 기초재고를 넘어가는 행
						   WHEN BF_SUM > @EV_BINV  THEN QTY
						   ELSE 0
					  END > 0
--select 'x2', @@Rowcount

				FETCH NEXT FROM CURSOR_ESSVMI1 INTO @Ev_division_id, @Ev_scm_site_id, @Ev_project_code, @Ev_item_id
												  , @Ev_dom_exp, @Ev_fcst_type, @Ev_incoterms, @EV_PLANT_SITE_ID, @EV_DIO
			---------------------------------------------------------------------------------------- 
			END;
			---------------------------------------------------------------------------------------- WHILE_m4 LOOP END

			CLOSE CURSOR_ESSVMI1;  
			DEALLOCATE CURSOR_ESSVMI1;	
		END

print '13--' + convert(varchar(30), getdate(), 121)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--  INPUT MEASURE 중복값 delete후 INSERT (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--   HISTORY INSERT (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		BEGIN
		--PRINT 'FCST DATA HISTORY INSERT START                   =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
			INSERT INTO dbo.DM_PLN_MKT_FCST_H 
			( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
			, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
			, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
			, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
			, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			SELECT v_division_id, NEXT VALUE FOR SEQ1_DM_PLN_MKT_FCST_H, v_project_code, v_scm_site_id, v_item_id
				 , v_dom_exp, v_fcst_type, v_incoterms, v_measure ,v_plant_site_id 
				 , v_yyyymmdd, v_qty, v_created_by, getdate(), v_created_by
				 , getdate(), null, null, null, null, null
				 , null, null, null, null, v_attribute10
			FROM #results 
		END
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                   HISTORY INSERT (END)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		--                                                                                                                           20180409 DM_MST_CUSTOMER_FCST map create (START)
		---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		BEGIN
			--PRINT 'DM_MST_CUSTOMER_FCST map create START            =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
			----------------------------------------------------------|
			insert into  @tmp_site_customer_map
			select  a.DIVISION_ID, a.SCM_SITE_ID, a.MEASURE, a.SUMMARY_BUCKET_VALUE as start_day
				  , case when summary_bucket_type = 'WEEKLY' THEN CONVERT(CHAR(8), DATEADD(DD, 0, dbo.FN_NEXT_DAY( cast( SUMMARY_BUCKET_VALUE as datetime) , 'SUN')), 112) 
					     else a.SUMMARY_BUCKET_VALUE
					END  end_day
			FROM dbo.DM_MST_CUSTOMER_FCST a WITH(NOLOCK) 
			inner join (select distinct v_division_id,v_scm_site_id
						from #results 
						WHERE v_measure NOT IN ('MKT_FCST','RTF')  -- 20181121 KHSONG MKT_FCST 수정시 CUST_FCST값이 수정되지 않도록 보완
					   ) rslt
				    on(	a.DIVISION_ID   = rslt.v_division_id
					and a.SCM_SITE_ID   = rslt.v_scm_site_id )
			where 1=1
			and VALID_YN = 'Y'
			and a.MEASURE_GROUP = 'CUST_FCST'
			and a.PLAN_WEEK = (SELECT MAX(PLAN_WEEK) FROM DM_MST_CUSTOMER_FCST WITH(NOLOCK))
			and a.SUMMARY_BUCKET_VALUE >=  CONVERT(CHAR(8), DATEADD(DD, -7*1, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일 이후데이터만 
			and summary_bucket_type in ('DAILY','WEEKLY')
			UNION
			select a.DIVISION_ID, a.SCM_SITE_ID, a.MEASURE
   				  , case when  SUMMARY_BUCKET_VALUE = convert(varchar(8),  DATEADD(DAY,1,DATEADD(DAY,-DATEPART(DD,getdate()),getdate())) ,112) THEN  CONVERT(CHAR(8), DATEADD(DD, -7*1, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
						 else  SUMMARY_BUCKET_VALUE 
				    end as start_day
				  , CONVERT(CHAR(8),  dateadd(day,-DATEPART(DD, dateadd(month,1,cast( SUMMARY_BUCKET_VALUE as datetime) )), dateadd(month,1,cast( SUMMARY_BUCKET_VALUE as datetime) ))   , 112) end_day
			FROM dbo.DM_MST_CUSTOMER_FCST a WITH(NOLOCK) 
			inner join ( select distinct v_division_id,v_scm_site_id
						 from #results 
						 WHERE v_measure NOT IN ('MKT_FCST','RTF')  -- 20181121 KHSONG MKT_FCST 수정시 CUST_FCST값이 수정되지 않도록 보완
						) rslt
					on(	a.DIVISION_ID   = rslt.v_division_id
					and a.SCM_SITE_ID   = rslt.v_scm_site_id
					)
			where 1=1
			and VALID_YN = 'Y'
			and a.MEASURE_GROUP = 'CUST_FCST'
			and a.PLAN_WEEK = (SELECT MAX(PLAN_WEEK) FROM DM_MST_CUSTOMER_FCST WITH(NOLOCK))
			and a.SUMMARY_BUCKET_VALUE >=  convert(varchar(8),  DATEADD(DAY,1,DATEADD(DAY,-DATEPART(DD,getdate()),getdate())) ,112)
			and summary_bucket_type in ('MONTHLY')
		END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                       20180409 DM_MST_CUSTOMER_FCST map create (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
print '14--' + convert(varchar(30), getdate(), 121)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                      20180409 DM_PLN_MKT_FCST CUST_FCST MEASURE insert (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	BEGIN
		--PRINT 'DM_PLN_MKT_FCST insert START                     =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		--BEGIN TRANSACTION DM0003_SAVE_MKT_FCST3
	insert into #tmp_DM_PLN_MKT_FCST
			 (v_division_id    
			 ,v_project_code   
			 ,v_scm_site_id    
			 ,v_item_id        
			 ,v_dom_exp        
			 ,v_fcst_type      
			 ,v_incoterms      
			 ,v_measure        
			 ,v_PLANT_SITE_ID  
			 ,v_yyyymmdd       
			 ,v_QTY            
			 ,v_CREATED_BY     
			 ,v_LAST_UPDATED_BY
			  )
	select   distinct 
			  a.DIVISION_ID		,a.PROJECT_CODE		,a.SCM_SITE_ID		,a.ITEM_ID	   ,a.DOM_EXP	  ,a.FCST_TYPE
			 ,a.INCOTERMS		,'CUST_FCST'		,a.PLANT_SITE_ID	,a.YYYYMMDD	   ,a.QTY		  ,a.CREATED_BY
			 ,a.LAST_UPDATED_BY	
	  from dbo.DM_PLN_MKT_FCST a WITH(NOLOCK)
		  inner join 
		  (select distinct v_division_id,v_scm_site_id,v_item_id,v_incoterms, v_PLANT_SITE_ID, v_project_code,v_dom_exp,v_fcst_type, v_attribute10
		  from #results ) rslt
	  on(
		    a.DIVISION_ID   = rslt.v_division_id
		and a.SCM_SITE_ID   = rslt.v_scm_site_id
		and a.ITEM_ID       = rslt.v_item_id
		and a.incoterms     = rslt.v_incoterms
		and a.PLANT_SITE_ID = rslt.v_PLANT_SITE_ID
		and a.PROJECT_CODE  = rslt.v_project_code
		and a.DOM_EXP       = rslt.v_dom_exp
		and a.FCST_TYPE     = rslt.v_fcst_type
	   )
		  inner join 
		  (select DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day  
		  from @tmp_site_customer_map group by DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day) map

	  on(
			a.DIVISION_ID   = map.DIVISION_ID 
		and a.SCM_SITE_ID   = map.SCM_SITE_ID
		and a.MEASURE       = map.MEASURE
	   )
		where 1=1
		and a.YYYYMMDD between map.start_day and map.end_day
		and a.YYYYMMDD >=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
		--COMMIT TRANSACTION DM0003_SAVE_MKT_FCST3
	END

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                 20180409 DM_PLN_MKT_FCST CUST_FCST MEASURE insert (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--    20180409 DM_PLN_MKT_FCST insert전 중복값 delete 후 INSERT (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	BEGIN
		--PRINT 'DM_PLN_MKT_FCST DUP CHECK DELETE START           =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|

					DELETE 
					FROM dbo.DM_PLN_MKT_FCST
					WHERE exists (
							SELECT v_division_id 
								FROM #tmp_DM_PLN_MKT_FCST 
								where 1=1
								and DM_PLN_MKT_FCST.division_id        =   v_division_id      
								AND DM_PLN_MKT_FCST.project_code       =   v_project_code   
								AND DM_PLN_MKT_FCST.scm_site_id        =   v_scm_site_id  
								AND DM_PLN_MKT_FCST.item_id            =   v_item_id      
								AND DM_PLN_MKT_FCST.dom_exp            =   v_dom_exp      
								AND DM_PLN_MKT_FCST.fcst_type          =   v_fcst_type    
								AND DM_PLN_MKT_FCST.incoterms          =   v_incoterms    
								AND DM_PLN_MKT_FCST.measure            =   v_measure      
								AND DM_PLN_MKT_FCST.plant_site_id      =   v_plant_site_id
							--   AND yyyymmdd           =   v_yyyymmdd     
								AND DM_PLN_MKT_FCST.yyyymmdd           >=   CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
							) 
		----------------------------------------------------------|
					INSERT INTO dbo.DM_PLN_MKT_FCST
							(DIVISION_ID    
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
							,ATTRIBUTE10 )
					SELECT 
							 v_division_id ,v_project_code ,v_scm_site_id	 ,v_item_id       ,v_dom_exp      
							,v_fcst_type   ,v_incoterms    ,v_measure    	 ,v_plant_site_id ,v_yyyymmdd     
							,v_qty         ,v_created_by   ,getdate()		 ,v_created_by    ,getdate()
							,v_attribute10
					FROM #tmp_DM_PLN_MKT_FCST 
	END

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                          20180409 DM_PLN_MKT_FCST insert전 중복값 delete 후 INSERT (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
		 
		 print '15--' + convert(varchar(30), getdate(), 121)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                      20180614 KHSONG 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직 추가 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	BEGIN
		--PRINT N'상품 전극 RTF생성                               =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|
		SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  -- 월요일 변수설정
		--BEGIN TRANSACTION DM0003_SAVE_MKT_FCST5

		DELETE 
		FROM dbo.DM_PLN_MKT_FCST 
			--where MEASURE = 'RTF'
			where MEASURE = 'RTF_SYS_RP' --20200427 변경
			AND yyyymmdd >= @plan_start_yyyymmdd -- 당주 월요일이후
			-- modified by ytchoi 20180813
			-- AND DIVISION_ID <> '40'
			AND exists (
				SELECT v_division_id
					FROM #results rslt
					--,[dbo].[DM_MST_ITEM_SINGLE_V] item WITH(NOLOCK)
					,#TEMP_DM_MST_ITEM_SINGLE_V_ALL item WITH(NOLOCK) --[E20260720-000270]_테이블변경
				where 1=1
				AND rslt.v_division_id					=	item.division_id
				AND rslt.v_item_id						=	item.item_id
				AND DM_PLN_MKT_FCST.division_id			=   rslt.v_division_id      
				AND DM_PLN_MKT_FCST.project_code		=   rslt.v_project_code   
				AND DM_PLN_MKT_FCST.scm_site_id			=   rslt.v_scm_site_id  
				AND DM_PLN_MKT_FCST.item_id				=   rslt.v_item_id      
				AND DM_PLN_MKT_FCST.dom_exp				=   rslt.v_dom_exp      
				AND DM_PLN_MKT_FCST.fcst_type			=   rslt.v_fcst_type    
				AND DM_PLN_MKT_FCST.incoterms			=   rslt.v_incoterms    
				AND DM_PLN_MKT_FCST.plant_site_id		=   rslt.v_plant_site_id
				AND DM_PLN_MKT_FCST.yyyymmdd			>=  @plan_start_yyyymmdd
				AND item.ACTIVE_FLAG = 'Y'  --20180720 ACTIVE_FLAG 조건추가
				--↓상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
				AND ( item.item_type in ('Q' , 'R' ) OR 
					( rslt.v_item_id in ( select k.item_id from scm_mst_item_sn k  WITH (NOLOCK) 
					  where k.division_id = rslt.v_division_id and k.SCP_OPERATION_GROUP = 'E' and k.ACTIVE_FLAG = 'Y'  )  ))  --20180720 ACTIVE_FLAG 조건추가
				--↑상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
				--[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 START
				--AND DM_PLN_MKT_FCST.division_id IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895] DIVISION_ID 구분으로 추가
				AND DM_PLN_MKT_FCST.division_id IN ('82')  -- 20190709 KHSONG [CSR ID:4034895] DIVISION_ID 구분으로 추가
				--[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 START
				)
				option (force order, optimize for(@plan_start_yyyymmdd unknown))
				;


		insert into dm_pln_mkt_fcst
					( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
		select a.[DIVISION_ID]
			  ,a.[PROJECT_CODE]
			  ,a.[SCM_SITE_ID]
			  ,a.[ITEM_ID]
			  ,a.[DOM_EXP]
			  ,a.[FCST_TYPE]
			  ,a.[INCOTERMS]
			  --,'RTF' 
			  ,'RTF_SYS_RP'  --20200427 변경
			  ,a.[PLANT_SITE_ID]
			  ,a.[YYYYMMDD]
			  ,a.[QTY]
			  ,'SYSTEM'
			  ,GETDATE()
			  ,'SYSTEM'
			  ,GETDATE()
			  ,a.[ATTRIBUTE1]
			  ,a.[ATTRIBUTE2]
			  ,a.[ATTRIBUTE3]
			  ,a.[ATTRIBUTE4]
			  ,a.[ATTRIBUTE5]
			  ,a.[ATTRIBUTE6]
			  ,a.[ATTRIBUTE7]
			  ,a.[ATTRIBUTE8]
			  ,a.[ATTRIBUTE9]
			  ,a.[ATTRIBUTE10]
		  from dm_pln_mkt_fcst a WITH(NOLOCK)
			where a.MEASURE = 'MKT_FCST'
			AND a.yyyymmdd >= @plan_start_yyyymmdd -- 당주 월요일이후
			-- modified by ytchoi 20180813
			-- AND DIVISION_ID <> '40'
			AND exists (
				SELECT v_division_id
					FROM #results rslt
					--,[dbo].[DM_MST_ITEM_SINGLE_V] item WITH(NOLOCK) --[E20260720-000270]_테이블변경
					,#TEMP_DM_MST_ITEM_SINGLE_V_ALL item WITH(NOLOCK) --[E20260720-000270]_테이블변경
				where 1=1
				AND rslt.v_division_id		=	item.division_id
				AND rslt.v_item_id			=	item.item_id
				AND a.division_id			=   rslt.v_division_id      
				AND a.project_code			=   rslt.v_project_code   
				AND a.scm_site_id			=   rslt.v_scm_site_id  
				AND a.item_id				=   rslt.v_item_id      
				AND a.dom_exp				=   rslt.v_dom_exp      
				AND a.fcst_type				=   rslt.v_fcst_type    
				AND a.incoterms				=   rslt.v_incoterms    
				AND a.plant_site_id			=   rslt.v_plant_site_id
				AND item.ACTIVE_FLAG = 'Y'  --20180720 ACTIVE_FLAG 조건추가
				--↓상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
				AND ( item.item_type in ('Q' , 'R' ) OR 
					( rslt.v_item_id in ( select k.item_id from scm_mst_item_sn k  WITH (NOLOCK) 
					  where k.division_id = rslt.v_division_id and k.SCP_OPERATION_GROUP = 'E' and k.ACTIVE_FLAG = 'Y'  )  ))  --20180720 ACTIVE_FLAG 조건추가
				--↑상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
				--[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 START
				--AND a.division_id IN ('82','40')  -- 20190709 KHSONG [CSR ID:4034895] DIVISION_ID 구분으로 추가
				AND a.division_id IN ('82')  -- 20190709 KHSONG [CSR ID:4034895] DIVISION_ID 구분으로 추가
				--[E20241211-000856]_40사업부 전극 RTF 적용 로직 개선요청 END
				) 
				option (force order, optimize for(@plan_start_yyyymmdd unknown))

		--COMMIT TRANSACTION DM0003_SAVE_MKT_FCST5
	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                  20180614 KHSONG 상품이거나 전극인 경우에 RTF를 MKT_FCST와 동일하게 생성 로직 추가 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	print '16--' + convert(varchar(30), getdate(), 121)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                 20181107 KHSONG 소형 반품예정수량(RMA) fcst_type인 경우에 RTF를 MKT_FCST와 동일하게 생성 조건추가 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	BEGIN
		----------------------------------------------------------|
		SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  -- 월요일 변수설정

		DELETE 
		FROM dbo.DM_PLN_MKT_FCST
			--where MEASURE = 'RTF'
			where MEASURE = 'RTF_SYS_RP'  --20200507 변경
			AND yyyymmdd >= @plan_start_yyyymmdd -- 당주 월요일이후
			AND exists (
				SELECT v_division_id
					FROM #results rslt
					--,[dbo].[DM_MST_ITEM_SINGLE_V] item WITH(NOLOCK) --[E20260720-000270]_테이블변경
					,#TEMP_DM_MST_ITEM_SINGLE_V_ALL item WITH(NOLOCK) --[E20260720-000270]_테이블변경
				where 1=1
				AND rslt.v_division_id					=	item.division_id
				AND rslt.v_item_id						=	item.item_id
				AND DM_PLN_MKT_FCST.division_id			=   rslt.v_division_id      
				AND DM_PLN_MKT_FCST.project_code		=   rslt.v_project_code   
				AND DM_PLN_MKT_FCST.scm_site_id			=   rslt.v_scm_site_id  
				AND DM_PLN_MKT_FCST.item_id				=   rslt.v_item_id      
				AND DM_PLN_MKT_FCST.dom_exp				=   rslt.v_dom_exp      
				AND DM_PLN_MKT_FCST.fcst_type			=   rslt.v_fcst_type    
				AND DM_PLN_MKT_FCST.incoterms			=   rslt.v_incoterms    
				AND DM_PLN_MKT_FCST.plant_site_id		=   rslt.v_plant_site_id
				AND DM_PLN_MKT_FCST.yyyymmdd			>=  @plan_start_yyyymmdd
				AND item.ACTIVE_FLAG = 'Y'
				AND rslt.v_fcst_type  = 'RMA'
				) 
				option (force order, optimize for(@plan_start_yyyymmdd unknown))
				;


		insert into dm_pln_mkt_fcst
					( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
					,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE
					,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4
					,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					)
		select a.[DIVISION_ID]
			  ,a.[PROJECT_CODE]
			  ,a.[SCM_SITE_ID]
			  ,a.[ITEM_ID]
			  ,a.[DOM_EXP]
			  ,a.[FCST_TYPE]
			  ,a.[INCOTERMS]
			  --,'RTF' 
			  ,'RTF_SYS_RP'  --20200507 변경
			  ,a.[PLANT_SITE_ID]
			  ,a.[YYYYMMDD]
			  ,a.[QTY]
			  ,'SYSTEM'
			  ,GETDATE()
			  ,'SYSTEM'
			  ,GETDATE()
			  ,a.[ATTRIBUTE1]
			  ,a.[ATTRIBUTE2]
			  ,a.[ATTRIBUTE3]
			  ,a.[ATTRIBUTE4]
			  ,a.[ATTRIBUTE5]
			  ,a.[ATTRIBUTE6]
			  ,a.[ATTRIBUTE7]
			  ,a.[ATTRIBUTE8]
			  ,a.[ATTRIBUTE9]
			  ,a.[ATTRIBUTE10]
		  from dm_pln_mkt_fcst a WITH(NOLOCK)
			where a.MEASURE = 'MKT_FCST'
			AND a.yyyymmdd >= @plan_start_yyyymmdd -- 당주 월요일이후
			AND exists (
				SELECT v_division_id
					FROM #results rslt
					--,[dbo].[DM_MST_ITEM_SINGLE_V] item WITH(NOLOCK) --[E20260720-000270]_테이블변경
					,#TEMP_DM_MST_ITEM_SINGLE_V_ALL item WITH(NOLOCK) --[E20260720-000270]_테이블변경
				where 1=1
				AND rslt.v_division_id		=	item.division_id
				AND rslt.v_item_id			=	item.item_id
				AND a.division_id			=   rslt.v_division_id      
				AND a.project_code			=   rslt.v_project_code   
				AND a.scm_site_id			=   rslt.v_scm_site_id  
				AND a.item_id				=   rslt.v_item_id      
				AND a.dom_exp				=   rslt.v_dom_exp      
				AND a.fcst_type				=   rslt.v_fcst_type    
				AND a.incoterms				=   rslt.v_incoterms    
				AND a.plant_site_id			=   rslt.v_plant_site_id
				AND item.ACTIVE_FLAG = 'Y'
				AND rslt.v_fcst_type  = 'RMA'
				) 

	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                 20181107 KHSONG 소형 반품예정수량(RMA) fcst_type인 경우에 RTF를 MKT_FCST와 동일하게 생성 조건추가 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	print '17--' + convert(varchar(30), getdate(), 121)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                                                                                          BALANCE_CREATE 호출 로직 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	BEGIN


		DECLARE @c_division_id         NVARCHAR(MAX);

		INSERT INTO #SEND_TARGET_DATA
		        (division_id  
				,project_code 
				,scm_site_id  
				,item_id      
				,dom_exp      
				,fcst_type    
				,incoterms    
				,plant_site_id
				,cell_prod_site_id					--	[PJ2025-00188] RTF_BALANCE 계산시 40 (CELL_PROD_SITE_ID) / 그외는 (- 로 처리)
				,vmi_yn )
		SELECT 
			     v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,V_PLANT_SITE_ID
				,'-'	AS cell_prod_site_id		--	[PJ2025-00188] RTF_BALANCE 계산시 40 (CELL_PROD_SITE_ID) / 그외는 (- 로 처리)
				,'N'	AS vmi_yn					-- vmi_yn 초기값
			FROM  #results WHERE 1=1
		GROUP BY v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,V_PLANT_SITE_ID

		SET @c_division_id = (SELECT TOP 1 DIVISION_ID FROM #SEND_TARGET_DATA)
			
		--PRINT N'BALANCE_CREATE CALL START  Division => ' + @c_division_id + N'              '+ CONVERT(VARCHAR(8), GETDATE(), 108)

		---------------------------------------------------------------------------------------- PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 호출 (START)
		EXEC PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 
													  @c_division_id
													, @p_plan_id = 'CALL'
		---------------------------------------------------------------------------------------- PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 호출 (END)

		--PRINT N'BALANCE_CREATE CALL END    Division => ' + @c_division_id + N'              '+ CONVERT(VARCHAR(8), GETDATE(), 108)

	END
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                BALANCE_CREATE 호출 로직 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	
	print '18--' + convert(varchar(30), getdate(), 121)

	--[E20230608-000891]MKT FCST, Sales Plan 동일 Measure 실시간 연동건 [START] ------------------------------------------------------------------------------------------------

	IF (@v_division_id = '82')
	BEGIN
		EXEC [dbo].[DMF0003_MKT_FCST_SALES_PLAN_SYNC] @v_division_id,	@v_created_by
	END

	--[E20230608-000891]MKT FCST, Sales Plan 동일 Measure 실시간 연동건 [END] ------------------------------------------------------------------------------------------------

	print '19--' + convert(varchar(30), getdate(), 121)
 
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                20180816 KHSONG DIVISION_ID = '40' PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE Procedure 호출 (START)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	-- SCP가 Open 했기 때문에 RTF 값을 MKT FCST에서 수정하지 않음.
	IF (SELECT count(1) FROM #results where v_division_id = '40') > 0
		BEGIN
			EXEC dbo.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE  
		END
	--PRINT N'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE   end                            =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎
	--                                                                20180816 KHSONG DIVISION_ID = '40' PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE Procedure 호출 (END)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------◎◎◎◎


    --COMMIT TRANSACTION DM0003_SAVE_MKT_FCST ;
		--PRINT N'ALL JOB END                                     =>' + CONVERT(VARCHAR(8), GETDATE(), 108)
		----------------------------------------------------------|

		print '20--' + convert(varchar(30), getdate(), 121)

		---------------------------------------------------------------------
		--DMF0070_SAVE_QTY_PR_DETAIL_AUTO 호출
		---------------------------------------------------------------------
		--MKT FCST 수정시 PR_DETAIL_AUTO 수량도 업데이트--KJJ 2024.02.05
		/*
		EXEC dbo.DMF0070_SAVE_QTY_PR_DETAIL_AUTO
			@p_division_id	,
			@p_project_code,
			@p_scm_site_id,
			@p_item_id,
			@p_dom_exp,
			@p_fcst_type,
			@p_incoterms,
			@p_plant_site_id,
			@p_yyyymmdd	,
			@p_qty
			*/
		
		--[E20260720-000270]_현재 사용하지 않는 프로시져로 주석처리 (START)
		/*
		EXEC dbo.DMF0070_SAVE_QTY_PR_DETAIL_AUTO
			@v_division_id	,
			@v_project_code,
			@v_scm_site_id,
			@v_item_id,
			@v_dom_exp,
			@v_fcst_type,
			@v_incoterms,
			@v_plant_site_id,
			@v_yyyymmdd	,
			@v_qty */
		--[E20260720-000270]_현재 사용하지 않는 프로시져로 주석처리 (END)
		print '21--' + convert(varchar(30), getdate(), 121)


	END TRY

	BEGIN CATCH

		--ROLLBACK TRANSACTION DM0003_SAVE_MKT_FCST
		--ROLLBACK TRANSACTION DM0003_SAVE_MKT_FCST9
  
		-- ROLLBACK
		-- ERROR LOG VALUE SAVE
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']_O' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
		EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;

	END CATCH

	SET NOCOUNT OFF;

	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
	
  END;

	-- 트랜잭션 (END)
	err_rtn:
	IF @v_log_type = 'INVALID'
		begin
			--ROLLBACK TRANSACTION DM0003_SAVE_MKT_FCST

			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, N'END', @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;

						--[C20200804-000123]
			IF OBJECT_ID (N'tempdb..#T_ERR', N'U') IS NOT NULL 
			BEGIN
				SELECT A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD
					, A.SYNC_QTY, A.QTY
				FROM #T_ERR A
				ORDER BY A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD
			END
		end
