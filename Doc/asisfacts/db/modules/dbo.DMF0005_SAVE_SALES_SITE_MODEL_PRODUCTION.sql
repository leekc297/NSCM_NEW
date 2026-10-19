
/*=====================================================================================================================================================
 * Program ID   : DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION
 * Description  : SCM_MST_SITE_ITEM 등록,수정
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge		Description
 *=====================================================================================================================================================
 * 2017/12/13	DWOK			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/06/01	khsong			소형관련 신규 컬럼추가
 * 2018/06/19	khsong			소형관련 Validation 조건추가
 * 2018/07/04	KHSONG			owner조회조건수정
 * 2018/07/16	KHSONG			11자리 코드중복건 validation 추가
 * 2018/07/21	sonyoungsuk		저장항목추가
 * 2018/07/27	KHSONG			attribute4 추가
 * 2018/08/13	KHSONG			PK값 기준으로 Validation 될수있도록 주석처리
 * 2018/08/14	KHSONG			PROJECT_CODE,ITEM_ID VALIDATION 추가
 * 2018/09/03	KHSONG			소형 11자리 모델 코드 validation 처리조건 추가 , 81,82 중복값 INSERT VALIDATION 추가
 * 2018/09/06	KHSONG			소형 11자리 모델 코드 validation 처리조건 재수정
 * 2018/10/05	khsong			공백제거로직추가
 * 2018/10/05	KHSONG			owner정보가 Key-In 되는경우 정상여부 확인후 비정상이면 Reject 시킴
 * 2018/10/31	KHSONG			EDI Incoterms용 컬럼추가
 * 2018/11/21	KHSONG			VALID_YN='N' 처리시 DM_PLN_SALES_PLAN,DM_PLN_SALES_PLAN_RESULT 테이블의 정보를 확인후 alert창을 띄움
 * 2019/01/25	KHSONG			전지재료 DIVISION_ID 추가 -> 삭제
 * 2019/04/02	KHSONG			소형 Report 컬럼 추가 
 * 2019/10/15	KHSONG			[CSR ID:4098705] GSCM(DM)에서 Incoterms 조건에 따라 Customer EDI의 DP 반영 요청의 건
 * 2019/10/18   KYH				[CSR ID:4103445] 컬럼통합. REPORT_GROUP4, 5 --> REPORT_GROUP4 
 * 2019/11/18	KHSONG			[CSR:C20191031-000137] EDI로 수신 받은 Call-off 정보 편집 기능 제외 처리
 * 2019/11/26	KHSONG			[CSR:C20191031-000137] 속도문제로 TimeOut 발생됨에따라 Split 기능으로 구조변경
 * 2020/01/13	KHSONG			해당 Sales Site의 소속팀의 아닌경우 Reject 시킴
 * 2020/03/17	hwi1993			[C20200311-000086] VMI_LT 추가
 * 2020/03/24	hwi1993			소형은 Sales Site 의 부서체크 안하도록 변경
 * 2020/04/22	P.C.I 			[PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선-셀명 추가
 * 2020/05/14	KHSONG			C20200409-000351 (내부 거래 DP 입력 관련 건)
 * 2020/05/14   P.C.I			[C20200513-000276] Sales Company, Sales Plant 추가 
 * 2020/06/04	KHSONG			C20200422-000403 WS Owner 정보추가요청건 반영
 * 2020/06/03   P.C.I			[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
 * 2020/06/25   P.C.I			[C20200506-000277] Owner 의 site 확인 시 Lookup PM_TEAM_MAPPING 의 PM Team도 대상에 포함
 * 2020/08/31	hwi1993			[C20200812-000104] [시스템 변경요청]  Active = ‘N’ 인 Model 도 조회되도록 변경( 미래구간 에만 적용 )
                                Sales Site Project Model 에서는 당주 월요일 이후의 Sales Plan 이 있을 경우만 Active 를 N 으로 변경못하도록 함
 * 2020/09/07	hwi1993			[C20200812-000104] Active N 처리
 * 2020/09/21	HWI1993			[C20200916-000412] [SCM PI팀] 소형 사업부 Sales Site Project Model에서의 중복모델 Validation 체크 시 Active "Y' 인 모델만 체크되도록 로직 변경 
 * 2021/03/25	kuni			[C20210323-000363] Sales Site Project Model 등록시 에러로그 수정
 * 2021/05/31	SJHAN			[C20210525-000374] 셀용량 및 팩 당 용량 추가
 * 2021/06/24	SJHAN			[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
 * 2021/08/23   rosia27			[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
 * 2021/12/02	kdw2819			[C20211126-000348] AS In Req관련 추가 체크 로직 보완 건
 * 2021/12/21	rosia27			[C20211221-000020]GSCM Sales Site Project Model 의 Active N 변경시 로직 추가 요청의 건
 * 2023/03/23	heesan91		[E20230322-001672] GSCM 셀 환산자 적용 관련 서비스 요청의 건
 * 2022/03/31	rosia27			[과제PJ20216891R]GM_JV
 * 2023/05/03	kdmcc14			[EDI과제]
 * 2023/07/18	CHANO0612		[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
 * 2023/08/14	ilovu1			대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
 * 2023/08/17	ilovu1			설명(DESCRIPTION) 컬럼 추가
 * 2023/08/21	JSSBAE			PROJECT_INF0(소형프로젝트) 컬럼 추가
 * 2024/09/19	KJJ				[PJ2024-50461] Team Mapping
 * 2024/09/25	JSSBAE			[E20240904-001037]_DM > Master > Sales Site Project Model 수정 요청
 * 2024/11/04	JSSBAE			[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건 
 * 2024/11/27   dsiol           [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가)  
 * 2024/11/28	JSSBAE			[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 
 * 2024/11/11	P.C.I			[PJ20228272] NERP 대응 - 81 사업부 신규 등록 I/F(PR_DM_XIF_ERP_SITE_ITEM_S)
 * 2025/07/15	JSSBAE			[E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리
 * 2026/03/27	JSSBAE			[E20260325-001071]_소형사업부 MKT FCST UI 모델코드 Validation 기준 수정
 * ===================================================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION]
	@p_active_flag			NVARCHAR(MAX),	-- I:[SCM_MST_PROJECT_ITEM]를 찾아서 [PROJECT_CODE]의 [PROJECT_VER_SEQ]의 MAX를 찾아서 그들을 SELECT
	@p_division_id			NVARCHAR(MAX),
	@p_project_code			NVARCHAR(MAX),
	@p_scm_site_id			NVARCHAR(MAX),
	@p_item_id				NVARCHAR(MAX),	-- @p_active_flag = 'I'일 경우 @p_item_id 값이 공백이므로 SCM_MST_PROJECT_ITEM 에서 착아서 INSERT 함
	@p_currency				NVARCHAR(MAX),
	@p_cell_per_car	 	    NVARCHAR(MAX),  -- 20180417 add skh
	@p_cell_per_module		NVARCHAR(MAX),  -- 20180417 add skh
	@p_liability_period		NVARCHAR(MAX),
	@p_sales_plan_adjust_yn	NVARCHAR(MAX),
	@p_item_hrcy_id			NVARCHAR(MAX),
	@p_bpms_exist			NVARCHAR(MAX),
	@p_valid_yn		 		NVARCHAR(MAX),
	--20180601 khsong 소형관련 신규 컬럼추가
	@p_cust_group			NVARCHAR(MAX),
	@p_cust_group_dtl		NVARCHAR(MAX),
	@p_owner				NVARCHAR(MAX),
	@p_application			NVARCHAR(MAX),
	@p_route				NVARCHAR(MAX),
	--20180601 khsong 소형관련 신규 컬럼추가
	@p_created_by			NVARCHAR(MAX),
	--@p_success_yn			NVARCHAR(1) OUTPUT
	@p_attribute1			NVARCHAR(MAX),
	@p_attribute2			NVARCHAR(MAX),
	@p_attribute4			NVARCHAR(MAX),  -- 20180727
	@p_attribute6			NVARCHAR(MAX),  -- 20181031 EDI Incoterms용 컬럼추가
	@p_edi_lt				NVARCHAR(MAX),  -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
	-- 20190402 KHSONG 소형 Report 컬럼 추가 
	@report_group1			NVARCHAR(MAX),
	@report_group2			NVARCHAR(MAX),
	@report_group3			NVARCHAR(MAX),
	@report_group4			NVARCHAR(MAX),
	--@report_group5			NVARCHAR(MAX),
	@report_group6			NVARCHAR(MAX),
	@report_group7			NVARCHAR(MAX),
	@report_group8			NVARCHAR(MAX),
	@p_vmi_LT				NVARCHAR(MAX),
	@p_cell_name			NVARCHAR(MAX), --[PJ20200138] Cell Name 추가
	@p_sales_company		NVARCHAR(MAX), --[C20200513-000276] Sales Company, Sales Plant 추가 
	@p_sales_plant			NVARCHAR(MAX),
	@p_partial_plan_yn		NVARCHAR(MAX), --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
	@p_kwh					NVARCHAR(MAX), --[C20210525-000374] 셀용량 및 팩 당 용량 추가
	@p_celltypeCD			NVARCHAR(MAX), --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
	@p_production_process	NVARCHAR(MAX), --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
	--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
	@p_consensus_Mkt        NVARCHAR(MAX), 
	@p_consensus_Ess        NVARCHAR(MAX),
	@p_consensus_Scm        NVARCHAR(MAX),
	@p_inventory_Day        NVARCHAR(MAX),
	@p_change_Reason        NVARCHAR(MAX),
	--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
    @p_alt_sim_yn		    NVARCHAR(MAX),   --20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
	@p_description		    NVARCHAR(MAX),   --20230817 설명(DESCRIPTION) 컬럼 추가
	@p_projectinfo		    NVARCHAR(MAX),   --20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가	
	@p_project_s_op_report  NVARCHAR(MAX),   --[E20240904-001037]_DM > Master > Sales Site Project Model 
	@p_cell_s_op_report		NVARCHAR(MAX),   --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
	@p_prj_ownr_id			NVARCHAR(MAX),   --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 
	@p_crge_org_nm		    NVARCHAR(MAX),  -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
	@p_cust_eng_nm		    NVARCHAR(MAX)   -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
AS

BEGIN
	PRINT @p_change_Reason
	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	-- 스플릿관련 변수
	DECLARE @s_active_flag			NVARCHAR(MAX);
	DECLARE @s_division_id			NVARCHAR(MAX);
	DECLARE @s_project_code			NVARCHAR(MAX);
	DECLARE @s_scm_site_id			NVARCHAR(MAX);
	DECLARE @s_item_id				NVARCHAR(MAX);
	DECLARE @s_currency				NVARCHAR(MAX);
	DECLARE @s_cell_per_car			NVARCHAR(MAX);
	DECLARE @s_cell_per_module		NVARCHAR(MAX);
	DECLARE @s_liability_period		NVARCHAR(MAX);
	DECLARE @s_sales_plan_adjust_yn	NVARCHAR(MAX);
	DECLARE @s_item_hrcy_id			NVARCHAR(MAX);
	DECLARE @s_bpms_exist			NVARCHAR(MAX);
	DECLARE @s_valid_yn				NVARCHAR(MAX);
	--20180601 khsong 소형관련 신규 컬럼추가
	DECLARE @s_cust_group			NVARCHAR(MAX);
	DECLARE @s_cust_group_dtl		NVARCHAR(MAX);
	DECLARE @s_owner				NVARCHAR(MAX);
	DECLARE @s_application			NVARCHAR(MAX);
	DECLARE @s_route				NVARCHAR(MAX);
	--20180601 khsong 소형관련 신규 컬럼추가
	DECLARE @s_created_by			NVARCHAR(MAX);
	DECLARE @s_attribute1			NVARCHAR(MAX);
	DECLARE @s_attribute2			NVARCHAR(MAX);
	DECLARE @s_attribute4			NVARCHAR(MAX);  -- 20180727
	DECLARE @s_attribute6			NVARCHAR(MAX);  -- 20181031
	DECLARE @s_edi_lt				NVARCHAR(MAX);  -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
	--DECLARE @v_project_item_cnt     INTEGER;
	--DECLARE @v_project_item_cnt_40  INTEGER;
	--DECLARE @v_project_item_cnt_41  INTEGER;

	-- 20190402 KHSONG 소형 Report 컬럼 추가 
	DECLARE @s_report_group1		NVARCHAR(MAX);
	DECLARE @s_report_group2		NVARCHAR(MAX);
	DECLARE @s_report_group3		NVARCHAR(MAX);
	DECLARE @s_report_group4		NVARCHAR(MAX);
	--DECLARE @v_report_group5		NVARCHAR(MAX);
	DECLARE @s_report_group6		NVARCHAR(MAX);
	DECLARE @s_report_group7		NVARCHAR(MAX);
	DECLARE @s_report_group8		NVARCHAR(MAX);
	DECLARE @s_vmi_lt				NVARCHAR(MAX);
	DECLARE @s_cell_name			NVARCHAR(MAX); --[PJ20200138] Cell Name 추가
	
	DECLARE @s_sales_company		NVARCHAR(MAX); --[C20200513-000276] Sales Company, Sales Plant 추가 
	DECLARE @s_sales_plant			NVARCHAR(MAX);
	DECLARE @s_partial_plan_yn		NVARCHAR(MAX); --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
	DECLARE @s_kwh					NVARCHAR(MAX); --[C20210525-000374] 셀용량 및 팩 당 용량 추가
	DECLARE @s_celltypeCD			NVARCHAR(MAX); --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
	DECLARE @s_production_process	NVARCHAR(MAX); --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

	--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
	DECLARE @s_consensus_Mkt        NVARCHAR(MAX);
	DECLARE @s_consensus_Ess        NVARCHAR(MAX);
	DECLARE @s_consensus_Scm        NVARCHAR(MAX);
	DECLARE @s_inventory_Day        NVARCHAR(MAX);
	DECLARE @s_change_Reason        NVARCHAR(MAX);
	--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
	DECLARE @s_alt_sim_yn           NVARCHAR(MAX);	--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
	DECLARE @s_description          NVARCHAR(MAX);	--20230817 설명(DESCRIPTION) 컬럼 추가
	DECLARE @s_project_info	        NVARCHAR(MAX);	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
	DECLARE @s_project_s_op_report  NVARCHAR(MAX);	--[E20240904-001037]_DM > Master > Sales Site Project Model
	DECLARE @s_cell_s_op_report		NVARCHAR(MAX);  --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건  
	DECLARE @s_prj_ownr_id			NVARCHAR(MAX);	--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 
	
	DECLARE @s_crge_org_nm		    NVARCHAR(MAX); -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
	DECLARE @s_cust_eng_nm		    NVARCHAR(MAX); -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 

	SET @s_active_flag			= NULL;
	SET @s_division_id			= NULL;
	SET @s_project_code			= NULL;
	SET @s_scm_site_id			= NULL;
	SET @s_item_id				= NULL;
	SET @s_currency				= NULL;
	SET @s_cell_per_car			= NULL;
	SET @s_cell_per_module		= NULL;
	SET @s_liability_period		= NULL;
	SET @s_sales_plan_adjust_yn = NULL;
	SET @s_item_hrcy_id			= NULL;
	SET @s_bpms_exist			= NULL;
	SET @s_valid_yn				= NULL;
	SET @s_created_by			= NULL;
	SET @s_attribute1			= NULL;
	SET @s_attribute2			= NULL;
	SET @s_attribute4			= NULL;  -- 20180727
	SET @s_attribute6			= NULL;  -- 20181031
	SET @s_edi_lt				= NULL;  -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
	--SET @v_project_item_cnt     = 1;
	--SET @v_project_item_cnt_40  = 0;
	--SET @v_project_item_cnt_41  = 0;

	-- 20190402 KHSONG 소형 Report 컬럼 추가 
	SET @s_report_group1		= NULL
	SET @s_report_group2		= NULL
	SET @s_report_group3		= NULL
	SET @s_report_group4		= NULL
	--SET @v_report_group5		= NULL
	SET @s_report_group6		= NULL
	SET @s_report_group7		= NULL
	SET @s_report_group8		= NULL
	SET @s_vmi_lt				= NULL
	SET @s_cell_name			= NULL --[PJ20200138] Cell Name 추가	
	SET @s_sales_company		= NULL --[C20200513-000276] Sales Company, Sales Plant 추가 
	SET @s_sales_plant			= NULL
	SET @s_partial_plan_yn		= NULL --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
	SET @s_kwh					= NULL --[C20210525-000374] 셀용량 및 팩 당 용량 추가
	SET @s_celltypeCD			= NULL --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
	SET @s_production_process	= NULL --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

	--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
	SET	@s_consensus_Mkt	      = NULL
	SET	@s_consensus_Ess	      = NULL
	SET	@s_consensus_Scm	      = NULL
	SET	@s_inventory_Day	      = NULL
	SET	@s_change_Reason	      = NULL
	--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
	SET	@s_alt_sim_yn	          = NULL	--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
	SET	@s_description	          = NULL	--20230817 설명(DESCRIPTION) 컬럼 추가
	SET	@s_project_info	          = NULL	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
	SET	@s_project_s_op_report    = NULL	--[E20240904-001037]_DM > Master > Sales Site Project Model 
	SET @s_cell_s_op_report		  = NULL    --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건  
	SET @s_prj_ownr_id			  = NULL    --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 

	SET @s_crge_org_nm		      = NULL	-- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
	SET @s_cust_eng_nm		      = NULL	-- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 

	-- 마지막 데이터 처리를 위한 구분자 추가
	SET @p_active_flag					= RTRIM(@p_active_flag						) + '^';
	SET @p_division_id					= RTRIM(@p_division_id						) + '^';
	SET @p_project_code					= RTRIM(@p_project_code						) + '^';
	SET @p_scm_site_id					= RTRIM(@p_scm_site_id						) + '^';
	SET @p_item_id						= RTRIM(@p_item_id							) + '^';
	SET @p_currency						= RTRIM(@p_currency							) + '^';
	SET @p_cell_per_car	 	    		= RTRIM(@p_cell_per_car	 	    			) + '^';
	SET @p_cell_per_module				= RTRIM(@p_cell_per_module					) + '^';
	SET @p_liability_period				= RTRIM(@p_liability_period					) + '^';
	SET @p_sales_plan_adjust_yn			= RTRIM(@p_sales_plan_adjust_yn				) + '^';
	SET @p_item_hrcy_id					= RTRIM(@p_item_hrcy_id						) + '^';
	SET @p_bpms_exist					= RTRIM(@p_bpms_exist						) + '^';
	SET @p_valid_yn		 				= RTRIM(@p_valid_yn		 					) + '^';
	SET @p_cust_group					= RTRIM(@p_cust_group						) + '^';
	SET @p_cust_group_dtl				= RTRIM(@p_cust_group_dtl					) + '^';
	SET @p_owner						= RTRIM(@p_owner							) + '^';
	SET @p_application					= RTRIM(@p_application						) + '^';
	SET @p_route						= RTRIM(@p_route							) + '^';
	SET @p_created_by					= RTRIM(@p_created_by						) + '^';
	SET @p_attribute1					= RTRIM(@p_attribute1						) + '^';
	SET @p_attribute2					= RTRIM(@p_attribute2						) + '^';
	SET @p_attribute4					= RTRIM(@p_attribute4						) + '^';
	SET @p_attribute6					= RTRIM(@p_attribute6						) + '^';
	SET @p_edi_lt						= RTRIM(@p_edi_lt							) + '^';
	
	SET @report_group1					= RTRIM(@report_group1					) + '^';
	SET @report_group2					= RTRIM(@report_group2					) + '^';
	SET @report_group3					= RTRIM(@report_group3					) + '^';
	SET @report_group4					= RTRIM(@report_group4					) + '^';
	--SET @report_group5					= RTRIM(@report_group5					) + '^';
	SET @report_group6					= RTRIM(@report_group6					) + '^';
	SET @report_group7					= RTRIM(@report_group7					) + '^';
	SET @report_group8					= RTRIM(@report_group8					) + '^';
	SET @p_vmi_lt						= RTRIM(@p_vmi_lt						) + '^';	
	SET @p_cell_name					= RTRIM(@p_cell_name					) + '^'; --[PJ20200138] Cell Name 추가
	
	SET @p_sales_company				= RTRIM(@p_sales_company				) + '^';  --[C20200513-000276] Sales Company, Sales Plant 추가 
	SET @p_sales_plant					= RTRIM(@p_sales_plant					) + '^'; 
	SET @p_partial_plan_yn				= RTRIM(@p_partial_plan_yn				) + '^'; --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
	SET @p_kwh							= RTRIM(@p_kwh							) + '^'; --[C20210525-000374] 셀용량 및 팩 당 용량 추가
	SET @p_celltypeCD					= RTRIM(@p_celltypeCD					) + '^'; --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
	SET @p_production_process			= RTRIM(@p_production_process			) + '^'; --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

	--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
	SET @p_consensus_Mkt                = RTRIM(@p_consensus_Mkt				) + '^'; 
	SET @p_consensus_Ess                = RTRIM(@p_consensus_Ess				) + '^';
	SET @p_consensus_Scm                = RTRIM(@p_consensus_Scm				) + '^';
	SET @p_inventory_Day                = RTRIM(@p_inventory_Day				) + '^';
	SET @p_change_Reason                = RTRIM(@p_change_Reason				) + '^';
	--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
	SET @p_alt_sim_yn                   = RTRIM(@p_alt_sim_yn					) + '^';	--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
	SET @p_description                  = RTRIM(@p_description					) + '^';	--20230817 설명(DESCRIPTION) 컬럼 추가
	SET @p_projectinfo                  = RTRIM(@p_projectinfo					) + '^';	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
	SET @p_project_s_op_report          = RTRIM(@p_project_s_op_report			) + '^';	--[E20240904-001037]_DM > Master > Sales Site Project Model 
	SET @p_cell_s_op_report				= RTRIM(@p_cell_s_op_report				) + '^';    --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건  
	SET @p_prj_ownr_id					= RTRIM(@p_prj_ownr_id					) + '^';    --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 
	
	SET @p_crge_org_nm				    = RTRIM(@p_crge_org_nm				    ) + '^'; -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
	SET @p_cust_eng_nm				    = RTRIM(@p_cust_eng_nm				    ) + '^'; -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 

	-- #results_MST TEMP TABLE
	CREATE TABLE #results_MST  (
             active_flag			NVARCHAR(01)		NOT NULL
			,division_id			NVARCHAR(30)		NOT NULL
			,project_code			NVARCHAR(50)		NOT NULL
			,scm_site_id			NVARCHAR(30)		NOT NULL
			,item_id				NVARCHAR(50)		NOT NULL
			,currency				NVARCHAR(10)		NOT NULL
			,cell_per_car	 	    numeric(20, 10)		NULL
			,cell_per_module		numeric(20, 10)		NULL
			,liability_period		int					NOT NULL
			,sales_plan_adjust_yn	NVARCHAR(01)		NOT NULL
			,item_hrcy_id			NVARCHAR(50)		NOT NULL
			,bpms_exist				NVARCHAR(01)		NOT NULL
			,valid_yn		 		NVARCHAR(01)		NOT NULL
			,cust_group				NVARCHAR(100)		NOT NULL
			,cust_group_dtl			NVARCHAR(100)		NOT NULL
			,owner					NVARCHAR(100)		NOT NULL
			,application			NVARCHAR(100)		NOT NULL
			,route					NVARCHAR(40)		NOT NULL
			,created_by				NVARCHAR(150)		NOT NULL
			,LAST_UPDATED_BY		NVARCHAR(150)		NULL
			,LAST_UPDATE_DATE		NVARCHAR(150)		NULL
			,attribute1				NVARCHAR(150)		NOT NULL
			,attribute2				NVARCHAR(150)		NOT NULL
			,attribute4				NVARCHAR(150)		NOT NULL
			,attribute6				NVARCHAR(150)		NOT NULL
			,edi_lt					int					NOT NULL
			,report_group1			NVARCHAR(300)		NOT NULL
			,report_group2			NVARCHAR(300)		NOT NULL
			,report_group3			NVARCHAR(300)		NOT NULL
			,report_group4			NVARCHAR(300)		NOT NULL
			--,report_group5			NVARCHAR(300)   NOT NULL
			,report_group6			NVARCHAR(300)		NOT NULL
			,report_group7			NVARCHAR(300)		NOT NULL
			,report_group8			NVARCHAR(300)		NOT NULL
			,vmi_lt					NVARCHAR(300)		NOT NULL
			,cell_name				NVARCHAR(300)		NULL --[PJ20200138] Cell Name 추가
			,sales_company			NVARCHAR(300)		NULL --[C20200513-000276] Sales Company, Sales Plant 추가 
			,sales_plant			NVARCHAR(300)		NULL
			,partial_plan_yn		NVARCHAR(300)		NULL --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
			,kwh					NVARCHAR(300)		NULL --[C20210525-000374] 셀용량 및 팩 당 용량 추가
			,celltypeCD				NVARCHAR(300)		NULL --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
			,production_process		NVARCHAR(150)		NOT NULL  --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

			--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
			,Consensus_Mkt         NVARCHAR(2)		    NULL 
			,Consensus_Ess         NVARCHAR(2)		    NULL 
			,Consensus_Scm         NVARCHAR(2)		    NULL 
			,Inventory_Day         NVARCHAR(5)		    NULL 
			,Change_Reason         NVARCHAR(200)		NULL 
			,Change_String         NVARCHAR(20)		    NULL 
			--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
			,ALT_SIM_YN			   NVARCHAR(1)          NULL	--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
			,DESCRIPTION		   NVARCHAR(100)        NULL	--20230817 설명(DESCRIPTION) 컬럼 추가
			,PROJECT_INFO		   NVARCHAR(200)        NULL	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
			,PROJECT_S_OP_REPORT   NVARCHAR(200)        NULL	--[E20240904-001037]_DM > Master > Sales Site Project Model
			,CELL_S_OP_REPORT	   NVARCHAR(200)		NULL    --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	
			,prj_ownr_id		   NVARCHAR(200)		NULL    --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 
			,CRGE_ORG_NM		   NVARCHAR(100)		NULL    -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
			,CUST_ENG_NM           NVARCHAR(300)		NULL    -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
    )
	
	-- [PJ20228272] NERP 대응 - 81 사업부 신규 등록 I/F(PR_DM_XIF_ERP_SITE_ITEM_S) START
	
	IF OBJECT_ID (N'tempdb..#TEMP_RESULT_MST', N'U') IS NOT NULL 
		DROP TABLE #TEMP_RESULT_MST

	-- #TEMP_RESULT_MST TEMP TABLE
	CREATE TABLE #TEMP_RESULT_MST  (
             division_id			NVARCHAR(30)		NOT NULL
			,project_code			NVARCHAR(50)		NOT NULL
			,scm_site_id			NVARCHAR(30)		NOT NULL
			,item_id				NVARCHAR(50)		NOT NULL
			,currency				NVARCHAR(10)		NOT NULL
			,cell_per_car	 	    numeric(20, 10)		NULL
			,cell_per_module		numeric(20, 10)		NULL
			,liability_period		int					NOT NULL
			,sales_plan_adjust_yn	NVARCHAR(01)		NOT NULL
			,item_hrcy_id			NVARCHAR(50)		NOT NULL
			,bpms_exist				NVARCHAR(01)		NOT NULL
			,valid_yn		 		NVARCHAR(01)		NOT NULL
			--,cust_group				NVARCHAR(100)		NOT NULL
			--,cust_group_dtl			NVARCHAR(100)		NOT NULL
			,owner					NVARCHAR(100)		NOT NULL
			--,application			NVARCHAR(100)		NOT NULL
			--,route					NVARCHAR(40)		NOT NULL
			,created_by				NVARCHAR(150)		NOT NULL
			,CREATION_DATE			DATETIME			NULL
			,LAST_UPDATED_BY		NVARCHAR(150)		NULL
			,LAST_UPDATE_DATE		DATETIME			NULL
			,attribute1				NVARCHAR(150)		NOT NULL
			,attribute2				NVARCHAR(150)		NOT NULL
			,attribute4				NVARCHAR(150)		NOT NULL
			,attribute6				NVARCHAR(150)		NOT NULL
			,edi_lt					int					NOT NULL
			,report_group1			NVARCHAR(300)		NOT NULL
			,report_group2			NVARCHAR(300)		NOT NULL
			,report_group3			NVARCHAR(300)		NOT NULL
			,report_group4			NVARCHAR(300)		NOT NULL
			--,report_group5			NVARCHAR(300)   NOT NULL
			,report_group6			NVARCHAR(300)		NOT NULL
			,report_group7			NVARCHAR(300)		NOT NULL
			,report_group8			NVARCHAR(300)		NOT NULL
			,vmi_lt					NVARCHAR(300)		NOT NULL
			,cell_name				NVARCHAR(300)		NULL --[PJ20200138] Cell Name 추가
			,sales_company			NVARCHAR(300)		NULL --[C20200513-000276] Sales Company, Sales Plant 추가 
			,sales_plant			NVARCHAR(300)		NULL
			,partial_plan_yn		NVARCHAR(300)		NULL --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
			,kwh					NVARCHAR(300)		NULL --[C20210525-000374] 셀용량 및 팩 당 용량 추가
			,celltypeCD				NVARCHAR(300)		NULL --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
			--,production_process		NVARCHAR(150)		NOT NULL  --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

			--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
			,Consensus_Mkt         NVARCHAR(2)		    NULL 
			,Consensus_Ess         NVARCHAR(2)		    NULL 
			,Consensus_Scm         NVARCHAR(2)		    NULL 
			,Inventory_Day         NVARCHAR(5)		    NULL 
			,Change_Reason         NVARCHAR(200)		NULL 
			,Change_String         NVARCHAR(20)		    NULL 
			--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
			,ALT_SIM_YN			   NVARCHAR(1)          NULL	--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
			,DESCRIPTION		   NVARCHAR(100)        NULL	--20230817 설명(DESCRIPTION) 컬럼 추가
			,PROJECT_INFO		   NVARCHAR(200)        NULL	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
			,PROJECT_S_OP_REPORT   NVARCHAR(200)        NULL	--[E20240904-001037]_DM > Master > Sales Site Project Model
			,CELL_S_OP_REPORT	   NVARCHAR(200)		NULL    --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	
			,prj_ownr_id		   NVARCHAR(200)		NULL    --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 
			,CRGE_ORG_NM		   NVARCHAR(100)		NULL    -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
			,CUST_ENG_NM           NVARCHAR(300)		NULL    -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
    )

	IF OBJECT_ID (N'tempdb..#XIF_ERP_SITE_ITEM', N'U') IS NOT NULL 
		DROP TABLE #XIF_ERP_SITE_ITEM

	CREATE TABLE #XIF_ERP_SITE_ITEM  (
             DIVISION_ID			NVARCHAR(30)		NOT NULL
			,SCM_SITE_ID			NVARCHAR(30)		NOT NULL
			,PROJECT_CODE			NVARCHAR(50)		NOT NULL
			,ITEM_ID				NVARCHAR(50)		NOT NULL
			,CREATED_BY				NVARCHAR(150)		NOT NULL
			,CREATION_DATE			DATETIME			NULL
			,LAST_UPDATED_BY		NVARCHAR(150)		NULL
			,LAST_UPDATE_DATE		DATETIME			NULL
    )
	-- [PJ20228272] NERP 대응 - 81 사업부 신규 등록 I/F(PR_DM_XIF_ERP_SITE_ITEM_S) END


	-- LOG 용 변수 설정
    DECLARE @v_program_name		NVARCHAR(150) = 'DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description2		NVARCHAR(500);
    DECLARE @d_event_date		DATETIME;
    DECLARE @n_delete_count		INTEGER = 0;
    DECLARE @n_insert_count     INTEGER = 0;
    DECLARE @n_logo_count		INTEGER = 0;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description2 = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description2, @d_event_date;

	-- 시작 LOG  (END)
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	------------------------------------------------------------------------------------------
	-- 20191118 KHSONG [CSR:C20191031-000137] EDI_LT 데이터 판단용 TEMP TABLE 생성 (BEGIN)
	------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#TEMP_EDI_LT', N'U') IS NOT NULL 
		DROP TABLE #TEMP_EDI_LT

	SELECT TOP 0 DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,EDI_LT
	INTO #TEMP_EDI_LT
		FROM SCM_MST_SITE_ITEM WITH(NOLOCK)

	-- 월요일 변수 셋팅
	DECLARE @v_0week_monday			NVARCHAR(08);  --W0 월요일
	set @v_0week_monday = CONVERT(CHAR(8), DATEADD(DD, -7,      DBO.FN_NEXT_DAY(CONVERT(VARCHAR,GETDATE(),112), 'MON')), 112)  --W0월요일

	------------------------------------------------------------------------------------------
	-- 20191118 KHSONG [CSR:C20191031-000137] EDI_LT 데이터 판단용 TEMP TABLE 생성 (END)
	------------------------------------------------------------------------------------------


	BEGIN TRAN SALES_SITE_MODEL_PRODUCTION;
	
	BEGIN TRY

	--------------------------------------------------------------------------------------------◇◇◇◇
	--          #results_MST 테이블에 split후 insert (BEGIN)
	--------------------------------------------------------------------------------------------◇◇◇◇
	BEGIN  --split

		WHILE LEN(@p_DIVISION_ID) > 0

		---------------------------(2)
		BEGIN  -- WHILE
		---------------------------(2)
			DECLARE @index_active_flag			INT
			DECLARE @index_division_id			INT
			DECLARE @index_project_code			INT
			DECLARE @index_scm_site_id			INT
			DECLARE @index_item_id				INT
			DECLARE @index_currency				INT
			DECLARE @index_cell_per_car	 		INT
			DECLARE @index_cell_per_module		INT
			DECLARE @index_liability_period		INT
			DECLARE @index_sales_plan_adjust_yn	INT
			DECLARE @index_item_hrcy_id			INT
			DECLARE @index_bpms_exist			INT
			DECLARE @index_valid_yn		 		INT
			DECLARE @index_cust_group			INT
			DECLARE @index_cust_group_dtl		INT
			DECLARE @index_owner				INT
			DECLARE @index_application			INT
			DECLARE @index_route				INT
			DECLARE @index_created_by			INT
			DECLARE @index_attribute1			INT
			DECLARE @index_attribute2			INT
			DECLARE @index_attribute4			INT
			DECLARE @index_attribute6			INT
			DECLARE @index_edi_lt				INT
			DECLARE @index_report_group1		INT
			DECLARE @index_report_group2		INT
			DECLARE @index_report_group3		INT
			DECLARE @index_report_group4		INT
			--DECLARE @index_report_group5		INT
			DECLARE @index_report_group6		INT
			DECLARE @index_report_group7		INT
			DECLARE @index_report_group8		INT
			DECLARE @index_vmi_lt				INT
			DECLARE @index_cell_name			INT --[PJ20200138] Cell Name 추가
			DECLARE @index_sales_company		INT --[C20200513-000276] Sales Company, Sales Plant 추가 
			DECLARE @index_sales_plant			INT
			DECLARE @index_partial_plan_yn		INT --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
			DECLARE @index_kwh					INT --[C20210525-000374] 셀용량 및 팩 당 용량 추가
			DECLARE @index_celltypeCD			INT --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
			DECLARE @index_production_process	INT --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

			--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
			DECLARE @index_consensus_Mkt	    INT 
			DECLARE @index_consensus_Ess	    INT 
			DECLARE @index_consensus_Scm	    INT 
			DECLARE @index_inventory_Day	    INT 
			DECLARE @index_change_Reason	    INT 
			--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
			DECLARE @index_alt_sim_yn   	    INT --20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
			DECLARE @index_description   	    INT --20230817 설명(DESCRIPTION) 컬럼 추가
			DECLARE @index_project_info   	    INT --20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
			DECLARE @index_project_s_op_report  INT --[E20240904-001037]_DM > Master > Sales Site Project Model 
			DECLARE @index_cell_s_op_report		INT --[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	
			DECLARE @index_prj_ownr_id		    INT --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 

			DECLARE @index_crge_org_nm			INT -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
			DECLARE @index_cust_eng_nm			INT -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 

			SET @index_active_flag			  = PATINDEX('%' + '^' + '%', @p_active_flag			)
			SET @index_division_id			  = PATINDEX('%' + '^' + '%', @p_division_id			)
			SET @index_project_code			  = PATINDEX('%' + '^' + '%', @p_project_code			)
			SET @index_scm_site_id			  = PATINDEX('%' + '^' + '%', @p_scm_site_id			)
			SET @index_item_id				  = PATINDEX('%' + '^' + '%', @p_item_id				)
			SET @index_currency				  = PATINDEX('%' + '^' + '%', @p_currency				)
			SET @index_cell_per_car	 		  = PATINDEX('%' + '^' + '%', @p_cell_per_car	 		)
			SET @index_cell_per_module		  = PATINDEX('%' + '^' + '%', @p_cell_per_module		)
			SET @index_liability_period		  = PATINDEX('%' + '^' + '%', @p_liability_period		)
			SET @index_sales_plan_adjust_yn	  = PATINDEX('%' + '^' + '%', @p_sales_plan_adjust_yn	)
			SET @index_item_hrcy_id			  = PATINDEX('%' + '^' + '%', @p_item_hrcy_id			)
			SET @index_bpms_exist			  = PATINDEX('%' + '^' + '%', @p_bpms_exist			    )
			SET @index_valid_yn		 		  = PATINDEX('%' + '^' + '%', @p_valid_yn		 		)
			SET @index_cust_group			  = PATINDEX('%' + '^' + '%', @p_cust_group			    )
			SET @index_cust_group_dtl		  = PATINDEX('%' + '^' + '%', @p_cust_group_dtl		    )
			SET @index_owner				  = PATINDEX('%' + '^' + '%', @p_owner				    )
			SET @index_application			  = PATINDEX('%' + '^' + '%', @p_application			)
			SET @index_route				  = PATINDEX('%' + '^' + '%', @p_route				    )
			SET @index_created_by			  = PATINDEX('%' + '^' + '%', @p_created_by			    )
			SET @index_attribute1			  = PATINDEX('%' + '^' + '%', @p_attribute1			    )
			SET @index_attribute2			  = PATINDEX('%' + '^' + '%', @p_attribute2			    )
			SET @index_attribute4			  = PATINDEX('%' + '^' + '%', @p_attribute4			    )
			SET @index_attribute6			  = PATINDEX('%' + '^' + '%', @p_attribute6			    )
			SET @index_edi_lt				  = PATINDEX('%' + '^' + '%', @p_edi_lt				    )
			SET @index_report_group1		  = PATINDEX('%' + '^' + '%', @report_group1		    )
			SET @index_report_group2		  = PATINDEX('%' + '^' + '%', @report_group2		    )
			SET @index_report_group3		  = PATINDEX('%' + '^' + '%', @report_group3		    )
			SET @index_report_group4		  = PATINDEX('%' + '^' + '%', @report_group4		    )
			--SET @index_report_group5		  = PATINDEX('%' + '^' + '%', @report_group5		    )
			SET @index_report_group6		  = PATINDEX('%' + '^' + '%', @report_group6		    )
			SET @index_report_group7		  = PATINDEX('%' + '^' + '%', @report_group7		    )
			SET @index_report_group8		  = PATINDEX('%' + '^' + '%', @report_group8		    )
			SET @index_vmi_lt				  = PATINDEX('%' + '^' + '%', @p_vmi_lt		            )
			SET @index_cell_name			  = PATINDEX('%' + '^' + '%', @p_cell_name		        ) --[PJ20200138] Cell Name 추가
			SET @index_sales_company		  = PATINDEX('%' + '^' + '%', @p_sales_company          ) --[C20200513-000276] Sales Company, Sales Plant 추가 
			SET @index_sales_plant			  = PATINDEX('%' + '^' + '%', @p_sales_plant            )
			SET @index_partial_plan_yn		  = PATINDEX('%' + '^' + '%', @p_partial_plan_yn        ) --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
			SET @index_kwh					  = PATINDEX('%' + '^' + '%', @p_kwh					) --[C20210525-000374] 셀용량 및 팩 당 용량 추가
			SET @index_celltypeCD			  = PATINDEX('%' + '^' + '%', @p_celltypeCD				) --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
			SET	@index_production_process	  = PATINDEX('%' + '^' + '%', @p_production_process		) --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

			--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
			SET	@index_consensus_Mkt	      = PATINDEX('%' + '^' + '%', @p_consensus_Mkt			)
			SET	@index_consensus_Ess	      = PATINDEX('%' + '^' + '%', @p_consensus_Ess			)
			SET	@index_consensus_Scm	      = PATINDEX('%' + '^' + '%', @p_consensus_Scm			)
			SET	@index_inventory_Day	      = PATINDEX('%' + '^' + '%', @p_inventory_Day			)
			SET	@index_change_Reason	      = PATINDEX('%' + '^' + '%', @p_change_Reason			)
			--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
			SET	@index_alt_sim_yn	          = PATINDEX('%' + '^' + '%', @p_alt_sim_yn				)		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
			SET	@index_description	          = PATINDEX('%' + '^' + '%', @p_description			)		--20230817 설명(DESCRIPTION) 컬럼 추가
			SET	@index_project_info	          = PATINDEX('%' + '^' + '%', @p_projectinfo			)		--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
			SET	@index_project_s_op_report    = PATINDEX('%' + '^' + '%', @p_project_s_op_report	)		--[E20240904-001037]_DM > Master > Sales Site Project Model 
			SET	@index_cell_s_op_report		  = PATINDEX('%' + '^' + '%', @p_cell_s_op_report		)		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	
			SET	@index_prj_ownr_id	          = PATINDEX('%' + '^' + '%', @p_prj_ownr_id			)		--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 
						
			SET	@index_crge_org_nm			  = PATINDEX('%' + '^' + '%', @p_crge_org_nm		    ) -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
			SET	@index_cust_eng_nm      	  = PATINDEX('%' + '^' + '%', @p_cust_eng_nm		    ) -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 

			---------------------------(1)
			IF @index_DIVISION_ID > 0
			---------------------------(1)
				BEGIN
					SET @s_active_flag						= SUBSTRING(@p_active_flag				, 0, @index_active_flag			)
					SET @s_division_id						= SUBSTRING(@p_division_id				, 0, @index_division_id			)
					SET @s_project_code						= SUBSTRING(@p_project_code				, 0, @index_project_code			)
					SET @s_scm_site_id						= SUBSTRING(@p_scm_site_id				, 0, @index_scm_site_id			)
					SET @s_item_id							= SUBSTRING(@p_item_id					, 0, @index_item_id				)
					SET @s_currency							= SUBSTRING(@p_currency					, 0, @index_currency				)
					SET @s_cell_per_car	 					= SUBSTRING(@p_cell_per_car	 			, 0, @index_cell_per_car	 		)
					SET @s_cell_per_module					= SUBSTRING(@p_cell_per_module			, 0, @index_cell_per_module		)
					SET @s_liability_period					= SUBSTRING(@p_liability_period			, 0, @index_liability_period		)
					SET @s_sales_plan_adjust_yn				= SUBSTRING(@p_sales_plan_adjust_yn		, 0, @index_sales_plan_adjust_yn	)
					SET @s_item_hrcy_id						= SUBSTRING(@p_item_hrcy_id				, 0, @index_item_hrcy_id			)
					SET @s_bpms_exist						= SUBSTRING(@p_bpms_exist				, 0, @index_bpms_exist			    )
					SET @s_valid_yn		 					= SUBSTRING(@p_valid_yn					, 0, @index_valid_yn		 		)
					SET @s_cust_group						= SUBSTRING(@p_cust_group				, 0, @index_cust_group			    )
					SET @s_cust_group_dtl					= SUBSTRING(@p_cust_group_dtl			, 0, @index_cust_group_dtl		    )
					SET @s_owner							= SUBSTRING(@p_owner					, 0, @index_owner				    )
					SET @s_application						= SUBSTRING(@p_application				, 0, @index_application			)
					SET @s_route							= SUBSTRING(@p_route					, 0, @index_route				    )
					SET @s_created_by						= SUBSTRING(@p_created_by				, 0, @index_created_by			    )
					SET @s_attribute1						= SUBSTRING(@p_attribute1				, 0, @index_attribute1			    )
					SET @s_attribute2						= SUBSTRING(@p_attribute2				, 0, @index_attribute2			    )
					SET @s_attribute4						= SUBSTRING(@p_attribute4				, 0, @index_attribute4			    )
					SET @s_attribute6						= SUBSTRING(@p_attribute6				, 0, @index_attribute6			    )
					SET @s_edi_lt							= SUBSTRING(@p_edi_lt					, 0, @index_edi_lt				    )
					SET @s_report_group1					= SUBSTRING(@report_group1				, 0, @index_report_group1		    )
					SET @s_report_group2					= SUBSTRING(@report_group2				, 0, @index_report_group2		    )
					SET @s_report_group3					= SUBSTRING(@report_group3				, 0, @index_report_group3		    )
					SET @s_report_group4					= SUBSTRING(@report_group4				, 0, @index_report_group4		    )
					--SET @v_report_group5					= SUBSTRING(@report_group5				, 0, @index_report_group5		    )
					SET @s_report_group6					= SUBSTRING(@report_group6				, 0, @index_report_group6		    )
					SET @s_report_group7					= SUBSTRING(@report_group7				, 0, @index_report_group7		    )
					SET @s_report_group8					= SUBSTRING(@report_group8				, 0, @index_report_group8		    )
					SET @s_vmi_lt							= SUBSTRING(@p_vmi_lt					, 0, @index_vmi_lt					)
					SET @s_cell_name						= SUBSTRING(@p_cell_name				, 0, @index_cell_name				) --[PJ20200138] Cell Name 추가
					SET @s_sales_company					= SUBSTRING(@p_sales_company			, 0, @index_sales_company			) --[C20200513-000276] Sales Company, Sales Plant 추가 
					SET @s_sales_plant						= SUBSTRING(@p_sales_plant				, 0, @index_sales_plant				)
					SET @s_partial_plan_yn					= SUBSTRING(@p_partial_plan_yn			, 0, @index_partial_plan_yn			) --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
					SET @s_kwh								= SUBSTRING(@p_kwh						, 0, @index_kwh						) --[C20210525-000374] 셀용량 및 팩 당 용량 추가
					SET @s_celltypeCD						= SUBSTRING(@p_celltypeCD				, 0, @index_celltypeCD				) --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
					SET @s_production_process				= SUBSTRING(@p_production_process		, 0, @index_production_process		) --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
					SET	@s_consensus_Mkt	                = SUBSTRING(@p_consensus_Mkt		    , 0, @index_consensus_Mkt			) 
					SET	@s_consensus_Ess	                = SUBSTRING(@p_consensus_Ess		    , 0, @index_consensus_Ess			) 
					SET	@s_consensus_Scm	                = SUBSTRING(@p_consensus_Scm		    , 0, @index_consensus_Scm			) 
					SET	@s_inventory_Day	                = SUBSTRING(@p_inventory_Day		    , 0, @index_inventory_Day			) 
					SET	@s_change_Reason	                = SUBSTRING(@p_change_Reason		    , 0, @index_change_Reason			) 
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
					SET	@s_alt_sim_yn	                    = SUBSTRING(@p_alt_sim_yn		        , 0, @index_alt_sim_yn				)		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
					SET	@s_description	                    = SUBSTRING(@p_description		        , 0, @index_description				)		--20230817 설명(DESCRIPTION) 컬럼 추가
					SET	@s_project_info	                    = SUBSTRING(@p_projectinfo		        , 0, @index_project_info			)		--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
					SET	@s_project_s_op_report	            = SUBSTRING(@p_project_s_op_report      , 0, @index_project_s_op_report	    )		--[E20240904-001037]_DM > Master > Sales Site Project Model 					
					SET	@s_cell_s_op_report					= SUBSTRING(@p_cell_s_op_report			, 0, @index_cell_s_op_report	    )		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건
					SET	@s_prj_ownr_id						= SUBSTRING(@p_prj_ownr_id				, 0, @index_prj_ownr_id				)		--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건


					SET	@s_crge_org_nm					    = SUBSTRING(@p_crge_org_nm			    , 0, @index_crge_org_nm	            )		-- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
					SET	@s_cust_eng_nm					    = SUBSTRING(@p_cust_eng_nm			    , 0, @index_cust_eng_nm	            )		-- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 

					SET @p_active_flag						= SUBSTRING(@p_active_flag				, LEN(@s_active_flag			 + '^') + 1, LEN(@p_active_flag				))
					SET @p_division_id						= SUBSTRING(@p_division_id				, LEN(@s_division_id			 + '^') + 1, LEN(@p_division_id				))
					SET @p_project_code						= SUBSTRING(@p_project_code				, LEN(@s_project_code			 + '^') + 1, LEN(@p_project_code			))
					SET @p_scm_site_id						= SUBSTRING(@p_scm_site_id				, LEN(@s_scm_site_id			 + '^') + 1, LEN(@p_scm_site_id				))
					SET @p_item_id							= SUBSTRING(@p_item_id					, LEN(@s_item_id				 + '^') + 1, LEN(@p_item_id					))
					SET @p_currency							= SUBSTRING(@p_currency					, LEN(@s_currency				 + '^') + 1, LEN(@p_currency				))
					SET @p_cell_per_car	 					= SUBSTRING(@p_cell_per_car	 			, LEN(@s_cell_per_car	 		 + '^') + 1, LEN(@p_cell_per_car	 		))
					SET @p_cell_per_module					= SUBSTRING(@p_cell_per_module			, LEN(@s_cell_per_module		 + '^') + 1, LEN(@p_cell_per_module			))
					SET @p_liability_period					= SUBSTRING(@p_liability_period			, LEN(@s_liability_period		 + '^') + 1, LEN(@p_liability_period		))
					SET @p_sales_plan_adjust_yn				= SUBSTRING(@p_sales_plan_adjust_yn		, LEN(@s_sales_plan_adjust_yn	 + '^') + 1, LEN(@p_sales_plan_adjust_yn	))
					SET @p_item_hrcy_id						= SUBSTRING(@p_item_hrcy_id				, LEN(@s_item_hrcy_id			 + '^') + 1, LEN(@p_item_hrcy_id			))
					SET @p_bpms_exist						= SUBSTRING(@p_bpms_exist				, LEN(@s_bpms_exist				 + '^') + 1, LEN(@p_bpms_exist				))
					SET @p_valid_yn		 					= SUBSTRING(@p_valid_yn		 			, LEN(@s_valid_yn		 		 + '^') + 1, LEN(@p_valid_yn		 		))
					SET @p_cust_group						= SUBSTRING(@p_cust_group				, LEN(@s_cust_group				 + '^') + 1, LEN(@p_cust_group				))
					SET @p_cust_group_dtl					= SUBSTRING(@p_cust_group_dtl			, LEN(@s_cust_group_dtl			 + '^') + 1, LEN(@p_cust_group_dtl			))
					SET @p_owner							= SUBSTRING(@p_owner					, LEN(@s_owner					 + '^') + 1, LEN(@p_owner					))
					SET @p_application						= SUBSTRING(@p_application				, LEN(@s_application			 + '^') + 1, LEN(@p_application				))
					SET @p_route							= SUBSTRING(@p_route					, LEN(@s_route					 + '^') + 1, LEN(@p_route					))
					SET @p_created_by						= SUBSTRING(@p_created_by				, LEN(@s_created_by				 + '^') + 1, LEN(@p_created_by				))
					SET @p_attribute1						= SUBSTRING(@p_attribute1				, LEN(@s_attribute1				 + '^') + 1, LEN(@p_attribute1				))
					SET @p_attribute2						= SUBSTRING(@p_attribute2				, LEN(@s_attribute2				 + '^') + 1, LEN(@p_attribute2				))
					SET @p_attribute4						= SUBSTRING(@p_attribute4				, LEN(@s_attribute4				 + '^') + 1, LEN(@p_attribute4				))
					SET @p_attribute6						= SUBSTRING(@p_attribute6				, LEN(@s_attribute6				 + '^') + 1, LEN(@p_attribute6				))
					SET @p_edi_lt							= SUBSTRING(@p_edi_lt					, LEN(@s_edi_lt					 + '^') + 1, LEN(@p_edi_lt					))
					SET @report_group1						= SUBSTRING(@report_group1				, LEN(@s_report_group1			 + '^') + 1, LEN(@report_group1				))
					SET @report_group2						= SUBSTRING(@report_group2				, LEN(@s_report_group2			 + '^') + 1, LEN(@report_group2				))
					SET @report_group3						= SUBSTRING(@report_group3				, LEN(@s_report_group3			 + '^') + 1, LEN(@report_group3				))
					SET @report_group4						= SUBSTRING(@report_group4				, LEN(@s_report_group4			 + '^') + 1, LEN(@report_group4				))
					--SET @report_group5						  = SUBSTRING(@report_group5				, LEN(@v_report_group5			 + '^') + 1, LEN(@report_group5		))
					SET @report_group6						= SUBSTRING(@report_group6				, LEN(@s_report_group6			 + '^') + 1, LEN(@report_group6				))
					SET @report_group7						= SUBSTRING(@report_group7				, LEN(@s_report_group7			 + '^') + 1, LEN(@report_group7				))
					SET @report_group8						= SUBSTRING(@report_group8				, LEN(@s_report_group8			 + '^') + 1, LEN(@report_group8				))
					SET @p_vmi_lt							= SUBSTRING(@p_vmi_lt					, LEN(@s_vmi_lt					 + '^') + 1, LEN(@p_vmi_lt					))
					SET @p_cell_name						= SUBSTRING(@p_cell_name				, LEN(@s_cell_name				 + '^') + 1, LEN(@p_cell_name				)) --[PJ20200138] Cell Name 추가
					SET @p_sales_company					= SUBSTRING(@p_sales_company			, LEN(@s_sales_company			 + '^') + 1, LEN(@p_sales_company			)) --[C20200513-000276] Sales Company, Sales Plant 추가 
					SET @p_sales_plant						= SUBSTRING(@p_sales_plant				, LEN(@s_sales_plant			 + '^') + 1, LEN(@p_sales_plant				))
					SET @p_partial_plan_yn					= SUBSTRING(@p_partial_plan_yn			, LEN(@s_partial_plan_yn		 + '^') + 1, LEN(@p_partial_plan_yn			)) --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
					SET @p_kwh								= SUBSTRING(@p_kwh						, LEN(@s_kwh					 + '^') + 1, LEN(@p_kwh						)) --[C20210525-000374] 셀용량 및 팩 당 용량 추가
					SET @p_celltypeCD						= SUBSTRING(@p_celltypeCD				, LEN(@s_celltypeCD				 + '^') + 1, LEN(@p_celltypeCD				)) --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
					SET @p_production_process				= SUBSTRING(@p_production_process		, LEN(@s_production_process		 + '^') + 1, LEN(@p_production_process		)) --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

					PRINT @s_consensus_Mkt
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
					SET	@p_consensus_Mkt	      = SUBSTRING(@p_consensus_Mkt		, LEN(@s_consensus_Mkt		 + '^') + 1, LEN(@p_consensus_Mkt		)) 
					SET	@p_consensus_Ess	      = SUBSTRING(@p_consensus_Ess		, LEN(@s_consensus_Ess		 + '^') + 1, LEN(@p_consensus_Ess		)) 
					SET	@p_consensus_Scm	      = SUBSTRING(@p_consensus_Scm		, LEN(@s_consensus_Scm		 + '^') + 1, LEN(@p_consensus_Scm		)) 
					SET	@p_inventory_Day	      = SUBSTRING(@p_inventory_Day		, LEN(@s_inventory_Day		 + '^') + 1, LEN(@p_inventory_Day		)) 
					SET	@p_change_Reason	      = SUBSTRING(@p_change_Reason		, LEN(@s_change_Reason		 + '^') + 1, LEN(@p_change_Reason		)) 
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
					PRINT @p_consensus_Mkt
					SET	@p_alt_sim_yn				= SUBSTRING(@p_alt_sim_yn		, LEN(@s_alt_sim_yn		 + '^') + 1, LEN(@p_alt_sim_yn		))	--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
					SET	@p_description				= SUBSTRING(@p_description	, LEN(@s_description	 + '^') + 1, LEN(@p_description		))	--20230817 설명(DESCRIPTION) 컬럼 추가
					SET	@p_projectinfo				= SUBSTRING(@p_projectinfo	, LEN(@s_project_info	 + '^') + 1, LEN(@p_projectinfo	))	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
					SET	@p_project_s_op_report	    = SUBSTRING(@p_project_s_op_report	, LEN(@s_project_s_op_report	 + '^') + 1, LEN(@p_project_s_op_report	))	--[E20240904-001037]_DM > Master > Sales Site Project Model
					SET	@p_cell_s_op_report			= SUBSTRING(@p_cell_s_op_report	, LEN(@s_cell_s_op_report	 + '^') + 1, LEN(@p_cell_s_op_report	))			--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   
					SET	@p_prj_ownr_id				= SUBSTRING(@p_prj_ownr_id		, LEN(@s_prj_ownr_id		 + '^') + 1, LEN(@p_prj_ownr_id		))				--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 

					SET	@p_crge_org_nm	            = SUBSTRING(@p_crge_org_nm	, LEN(@s_crge_org_nm	 + '^') + 1, LEN(@p_crge_org_nm	)) -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
					SET	@p_cust_eng_nm		        = SUBSTRING(@p_cust_eng_nm	, LEN(@s_cust_eng_nm	 + '^') + 1, LEN(@p_cust_eng_nm	)) -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 

					-- 공백제거(START)
					SET @s_active_flag				     	= rtrim(ltrim(@s_active_flag			))
					SET @s_division_id				     	= rtrim(ltrim(@s_division_id			))
					SET @s_project_code				     	= rtrim(ltrim(@s_project_code			))
					SET @s_scm_site_id				     	= rtrim(ltrim(@s_scm_site_id			))					
					--------------------------------------------------------------------------------------------------
					-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (START)	
					--1).RTRIM / 2).LTRIM / 3).CHAR(13): Carriage return / 4).CHAR(10): Line feed / 5).CHAR(9): TAB / 6).' '공백을 ''
					--SET @s_item_id					     	= rtrim(ltrim(@s_item_id				))
					SET @s_item_id					     	= REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(@s_item_id)),CHAR(13),''),CHAR(10),''),CHAR(9),''), ' ', '')
					-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (END)	
					--------------------------------------------------------------------------------------------------
					SET @s_currency					     	= rtrim(ltrim(@s_currency				))
					SET @s_cell_per_car	 			     	= rtrim(ltrim(@s_cell_per_car	 		))
					SET @s_cell_per_module			     	= rtrim(ltrim(@s_cell_per_module		))
					SET @s_liability_period			     	= rtrim(ltrim(@s_liability_period		))
					SET @s_sales_plan_adjust_yn		     	= rtrim(ltrim(@s_sales_plan_adjust_yn	))
					SET @s_item_hrcy_id				     	= rtrim(ltrim(@s_item_hrcy_id			))
					SET @s_bpms_exist				     	= rtrim(ltrim(@s_bpms_exist			    ))
					SET @s_valid_yn		 			     	= rtrim(ltrim(@s_valid_yn		 		))
					SET @s_cust_group				     	= rtrim(ltrim(@s_cust_group			    ))
					SET @s_cust_group_dtl			     	= rtrim(ltrim(@s_cust_group_dtl		    ))
					SET @s_owner					     	= rtrim(ltrim(@s_owner				    ))
					SET @s_application				     	= rtrim(ltrim(@s_application			))
					SET @s_route					     	= rtrim(ltrim(@s_route				    ))
					SET @s_created_by				     	= rtrim(ltrim(@s_created_by			    ))
					SET @s_attribute1				     	= rtrim(ltrim(@s_attribute1			    ))
					SET @s_attribute2				     	= rtrim(ltrim(@s_attribute2			    ))
					SET @s_attribute4				     	= rtrim(ltrim(@s_attribute4			    ))
					SET @s_attribute6				     	= rtrim(ltrim(@s_attribute6			    ))
					SET @s_edi_lt					     	= rtrim(ltrim(@s_edi_lt				    ))
					SET @s_report_group1			     	= rtrim(ltrim(@s_report_group1		    ))
					SET @s_report_group2			     	= rtrim(ltrim(@s_report_group2		    ))
					SET @s_report_group3			     	= rtrim(ltrim(@s_report_group3		    ))
					SET @s_report_group4			     	= rtrim(ltrim(@s_report_group4		    ))
					--SET @v_report_group5			     	= rtrim(ltrim(@v_report_group5		    ))
					SET @s_report_group6			     	= rtrim(ltrim(@s_report_group6		    ))
					SET @s_report_group7			     	= rtrim(ltrim(@s_report_group7		    ))
					SET @s_report_group8			     	= rtrim(ltrim(@s_report_group8		    ))
					SET @s_vmi_lt			     			= rtrim(ltrim(@s_vmi_lt					))
					SET @s_cell_name			     		= rtrim(ltrim(@s_cell_name				)) --[PJ20200138] Cell Name 추가
					SET @s_sales_company			     	= rtrim(ltrim(@s_sales_company			)) --[C20200513-000276] Sales Company, Sales Plant 추가 
					SET @s_sales_plant			     		= rtrim(ltrim(@s_sales_plant			))		
					SET @s_partial_plan_yn					= rtrim(ltrim(@s_partial_plan_yn  		)) --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가			 	 
					SET @s_kwh								= rtrim(ltrim(@s_kwh					)) --[C20210525-000374] 셀용량 및 팩 당 용량 추가
					SET @s_celltypeCD						= rtrim(ltrim(@s_celltypeCD				)) --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
					SET @s_production_process				= rtrim(ltrim(@s_production_process		)) --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
					SET	@s_consensus_Mkt	      = rtrim(ltrim(@s_consensus_Mkt				))
					SET	@s_consensus_Ess	      = rtrim(ltrim(@s_consensus_Ess				))
					SET	@s_consensus_Scm	      = rtrim(ltrim(@s_consensus_Scm				))
					SET	@s_inventory_Day	      = rtrim(ltrim(@s_inventory_Day				))
					SET	@s_change_Reason	      = rtrim(ltrim(@s_change_Reason				))
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
					SET	@s_alt_sim_yn	          = rtrim(ltrim(@s_alt_sim_yn					))		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
					SET	@s_description	          = rtrim(ltrim(@s_description					))		--20230817 설명(DESCRIPTION) 컬럼 추가
					SET	@s_project_info	          = rtrim(ltrim(@s_project_info					))		--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
					SET	@s_project_s_op_report	  = rtrim(ltrim(@s_project_s_op_report		    ))		--[E20240904-001037]_DM > Master > Sales Site Project Model 
					SET	@s_cell_s_op_report		  = rtrim(ltrim(@s_cell_s_op_report				))		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	
					SET	@s_prj_ownr_id	          = rtrim(ltrim(@s_prj_ownr_id					))		--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 
					
					SET	@s_crge_org_nm	      = rtrim(ltrim(@s_crge_org_nm)) --[PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
					SET	@s_cust_eng_nm		  = rtrim(ltrim(@s_cust_eng_nm)) --[PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 	

					DECLARE @s_modify NVARCHAR(MAX)
					DECLARE @s_count INT
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
					IF (@s_division_id = '82')
					BEGIN
						SET @s_modify = ''
						--SET @s_count = 0
						--SELECT @s_count = COUNT(*)
						--FROM SCM_MST_SITE_ITEM WITH(NOLOCK) WHERE 1=1 
						--AND DIVISION_ID = @s_division_id
						--AND PROJECT_CODE = @s_project_code
						--AND SCM_SITE_ID = @s_scm_site_id
						--AND ITEM_ID = @s_item_id

						--IF @s_count = 0
						--BEGIN
						--	SET @s_modify = ''
						--END
						--ELSE
						BEGIN
							SELECT @s_modify = (ISNULL(CONSENSUS_MKT, '') + ISNULL(CONSENSUS_ESS, '')  + ISNULL(CONSENSUS_SCM, '') + CONVERT(NVARCHAR, INVENTORY_DAY) + ISNULL(CHANGE_REASON, ''))
							FROM SCM_MST_SITE_ITEM WITH(NOLOCK) WHERE 1=1 
							AND DIVISION_ID = @s_division_id
							AND PROJECT_CODE = @s_project_code
							AND SCM_SITE_ID = @s_scm_site_id
							AND ITEM_ID = @s_item_id
						END
					END


					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END

					-- 공백제거(END)

					-- 컬럼값 컨버젼 오류 방지
					IF @s_cell_per_car = ''
						  BEGIN
							SET @s_cell_per_car = NULL
						  END

					IF @s_cell_per_module = ''
						  BEGIN
							SET @s_cell_per_module = NULL
						  END
					--[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag  Default 'N'추가
					IF (@s_partial_plan_yn = '' OR @s_partial_plan_yn IS NULL)
						  BEGIN
							SET @s_partial_plan_yn = N'N'
						  END

					INSERT INTO #results_MST ( 
											 active_flag	 
											,division_id			
											,project_code			
											,scm_site_id			
											,item_id				
											,currency				
											,cell_per_car	 	    
											,cell_per_module		
											,liability_period		
											,sales_plan_adjust_yn	
											,item_hrcy_id			
											,bpms_exist				
											,valid_yn		 		
											,cust_group				
											,cust_group_dtl			
											,owner					
											,application			
											,route					
											,created_by				
											,attribute1				
											,attribute2				
											,attribute4				
											,attribute6	
											,edi_lt			
											,report_group1			
											,report_group2			
											,report_group3			
											,report_group4			
											--,report_group5			
											,report_group6			
											,report_group7			
											,report_group8
											,vmi_lt			
											,cell_name  --[PJ20200138] Cell Name 추가											
											,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
											,sales_plant
											,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
											,kwh				-- [C20210525-000374] 셀용량 및 팩 당 용량 추가
											,celltypeCD			-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
											,production_process  --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
											,consensus_Mkt
											,consensus_Ess
											,consensus_Scm
											,inventory_Day
											,change_Reason
											,Change_String
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
											,alt_sim_yn		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,description	--20230817 설명(DESCRIPTION) 컬럼 추가
											,project_info	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,project_s_op_report	--[E20240904-001037]_DM > Master > Sales Site Project Model 
											,cell_s_op_report		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건  
											,prj_ownr_id			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 
											,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
											,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
					) VALUES ( 
											 @s_active_flag	 
											,@s_division_id			
											,@s_project_code			
											,@s_scm_site_id			
											,@s_item_id				
											,@s_currency				
											,@s_cell_per_car	 	    
											,@s_cell_per_module		
											,@s_liability_period		
											,@s_sales_plan_adjust_yn	
											,@s_item_hrcy_id			
											,@s_bpms_exist				
											,@s_valid_yn		 		
											,@s_cust_group				
											,@s_cust_group_dtl			
											,@s_owner					
											,@s_application			
											,@s_route					
											,@s_created_by				
											,@s_attribute1				
											,@s_attribute2				
											,@s_attribute4
											,@s_attribute6		
											,@s_edi_lt		
											,@s_report_group1			
											,@s_report_group2			
											,@s_report_group3			
											,@s_report_group4			
											--,@v_report_group5			
											,@s_report_group6			
											,@s_report_group7			
											,@s_report_group8	
											,@s_vmi_lt		
											,@s_cell_name  --[PJ20200138] Cell Name 추가
											,@s_sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
											,@s_sales_plant
											,@s_partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
											,@s_kwh				--[C20210525-000374] 셀용량 및 팩 당 용량 추가
											,@s_celltypeCD		--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
											,@s_production_process  --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
											,@s_consensus_Mkt
											,@s_consensus_Ess
											,@s_consensus_Scm
											,@s_inventory_Day
											,@s_change_Reason
											-- 이전 데이터를 입력한다.
											,(SELECT ISNULL(CONSENSUS_MKT, '') + ISNULL(CONSENSUS_ESS, '')  + ISNULL(CONSENSUS_SCM, '') + CONVERT(NVARCHAR, INVENTORY_DAY) + ISNULL(CHANGE_REASON, '')
												FROM SCM_MST_SITE_ITEM WITH(NOLOCK) WHERE 1=1 
												AND DIVISION_ID = @s_division_id
												AND PROJECT_CODE = @s_project_code
												AND SCM_SITE_ID = @s_scm_site_id
												AND ITEM_ID = @s_item_id)
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
											,@s_alt_sim_yn		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,@s_description		--20230817 설명(DESCRIPTION) 컬럼 추가
											,@s_project_info	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,@s_project_s_op_report	--[E20240904-001037]_DM > Master > Sales Site Project Model 
											,@s_cell_s_op_report	--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   									
											,@s_prj_ownr_id			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 
											,@s_crge_org_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
											,@s_cust_eng_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
					)
				END	
			ELSE
				BEGIN
					SET @s_DIVISION_ID = @p_DIVISION_ID
					SET @p_DIVISION_ID = NULL
 
					-- 공백제거(START)
					SET @s_active_flag				     	= rtrim(ltrim(@s_active_flag			))
					SET @s_division_id				     	= rtrim(ltrim(@s_division_id			))
					SET @s_project_code				     	= rtrim(ltrim(@s_project_code			))
					SET @s_scm_site_id				     	= rtrim(ltrim(@s_scm_site_id			))
					--------------------------------------------------------------------------------------------------
					-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (START)	
					--1).RTRIM / 2).LTRIM / 3).CHAR(13): Carriage return / 4).CHAR(10): Line feed / 5).CHAR(9): TAB / 6).' '공백을 ''
					--SET @s_item_id					     	= rtrim(ltrim(@s_item_id				))
					SET @s_item_id					     	= REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(@s_item_id)),CHAR(13),''),CHAR(10),''),CHAR(9),''), ' ', '')
					-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (END)	
					--------------------------------------------------------------------------------------------------
					SET @s_currency					     	= rtrim(ltrim(@s_currency				))
					SET @s_cell_per_car	 			     	= rtrim(ltrim(@s_cell_per_car	 		))
					SET @s_cell_per_module			     	= rtrim(ltrim(@s_cell_per_module		))
					SET @s_liability_period			     	= rtrim(ltrim(@s_liability_period		))
					SET @s_sales_plan_adjust_yn		     	= rtrim(ltrim(@s_sales_plan_adjust_yn	))
					SET @s_item_hrcy_id				     	= rtrim(ltrim(@s_item_hrcy_id			))
					SET @s_bpms_exist				     	= rtrim(ltrim(@s_bpms_exist			    ))
					SET @s_valid_yn		 			     	= rtrim(ltrim(@s_valid_yn		 		))
					SET @s_cust_group				     	= rtrim(ltrim(@s_cust_group			    ))
					SET @s_cust_group_dtl			     	= rtrim(ltrim(@s_cust_group_dtl		    ))
					SET @s_owner					     	= rtrim(ltrim(@s_owner				    ))
					SET @s_application				     	= rtrim(ltrim(@s_application			))
					SET @s_route					     	= rtrim(ltrim(@s_route				    ))
					SET @s_created_by				     	= rtrim(ltrim(@s_created_by			    ))
					SET @s_attribute1				     	= rtrim(ltrim(@s_attribute1			    ))
					SET @s_attribute2				     	= rtrim(ltrim(@s_attribute2			    ))
					SET @s_attribute4				     	= rtrim(ltrim(@s_attribute4			    ))
					SET @s_attribute6				     	= rtrim(ltrim(@s_attribute6			    ))
					SET @s_edi_lt					     	= rtrim(ltrim(@s_edi_lt				    ))
					SET @s_report_group1			     	= rtrim(ltrim(@s_report_group1		    ))
					SET @s_report_group2			     	= rtrim(ltrim(@s_report_group2		    ))
					SET @s_report_group3			     	= rtrim(ltrim(@s_report_group3		    ))
					SET @s_report_group4			     	= rtrim(ltrim(@s_report_group4		    ))
					--SET @v_report_group5			     	= rtrim(ltrim(@v_report_group5		    ))
					SET @s_report_group6			     	= rtrim(ltrim(@s_report_group6		    ))
					SET @s_report_group7			     	= rtrim(ltrim(@s_report_group7		    ))
					SET @s_report_group8			     	= rtrim(ltrim(@s_report_group8		    ))
					SET @s_vmi_lt			     			= rtrim(ltrim(@s_vmi_lt					))
					SET @s_cell_name			     		= rtrim(ltrim(@s_cell_name				)) --[PJ20200138] Cell Name 추가
					SET @s_sales_company			     	= rtrim(ltrim(@s_sales_company			)) --[C20200513-000276] Sales Company, Sales Plant 추가
					SET @s_sales_plant			     		= rtrim(ltrim(@s_sales_plant			))
					SET @s_partial_plan_yn		     		= rtrim(ltrim(@s_partial_plan_yn		)) --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
					SET @s_kwh					     		= rtrim(ltrim(@s_kwh					)) --[C20210525-000374] 셀용량 및 팩 당 용량 추가
					SET @s_celltypeCD					    = rtrim(ltrim(@s_celltypeCD				)) --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
					SET @s_production_process				= rtrim(ltrim(@s_production_process		)) --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
					SET	@s_consensus_Mkt	      = rtrim(ltrim(@s_consensus_Mkt				))
					SET	@s_consensus_Ess	      = rtrim(ltrim(@s_consensus_Ess				))
					SET	@s_consensus_Scm	      = rtrim(ltrim(@s_consensus_Scm				))
					SET	@s_inventory_Day	      = rtrim(ltrim(@s_inventory_Day				))
					SET	@s_change_Reason	      = rtrim(ltrim(@s_change_Reason				))
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
					SET	@s_alt_sim_yn	          = rtrim(ltrim(@s_alt_sim_yn					))		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
					SET	@s_description	          = rtrim(ltrim(@s_description					))		--20230817 설명(DESCRIPTION) 컬럼 추가
					SET	@s_project_info	          = rtrim(ltrim(@s_project_info					))		--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
					SET	@s_project_s_op_report	  = rtrim(ltrim(@s_project_s_op_report		    ))		--[E20240904-001037]_DM > Master > Sales Site Project Model 
					SET	@s_cell_s_op_report		  = rtrim(ltrim(@s_cell_s_op_report				))		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	
					SET	@s_prj_ownr_id	          = rtrim(ltrim(@s_prj_ownr_id					))		--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 
																
					SET	@s_crge_org_nm	  = rtrim(ltrim(@s_crge_org_nm)) -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
					SET	@s_cust_eng_nm	  = rtrim(ltrim(@s_cust_eng_nm)) -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
					-- 공백제거(END)
				
					-- 컬럼값 컨버젼 오류 방지
					IF @s_cell_per_car = ''
						  BEGIN
							SET @s_cell_per_car = NULL
						  END

					IF @s_cell_per_module = ''
						  BEGIN
							SET @s_cell_per_module = NULL
						  END
					--[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag  Default 'N'추가
					IF (@s_partial_plan_yn = '' OR @s_partial_plan_yn IS NULL)
						  BEGIN
							SET @s_partial_plan_yn = N'N'
						  END

					INSERT INTO #results_MST ( 
											 active_flag	 
											,division_id			
											,project_code			
											,scm_site_id			
											,item_id				
											,currency				
											,cell_per_car	 	    
											,cell_per_module		
											,liability_period		
											,sales_plan_adjust_yn	
											,item_hrcy_id			
											,bpms_exist				
											,valid_yn		 		
											,cust_group				
											,cust_group_dtl			
											,owner					
											,application			
											,route					
											,created_by				
											,attribute1				
											,attribute2				
											,attribute4	
											,attribute6		
											,edi_lt		
											,report_group1			
											,report_group2			
											,report_group3			
											,report_group4			
											--,report_group5			
											,report_group6			
											,report_group7			
											,report_group8
											,vmi_lt			
											,cell_name  --[PJ20200138] Cell Name 추가									
											,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
											,sales_plant
											,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
											,kwh			--[C20210525-000374] 셀용량 및 팩 당 용량 추가
											,celltypeCD		--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
											,production_process  --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
											,consensus_Mkt
											,consensus_Ess
											,consensus_Scm
											,inventory_Day
											,change_Reason
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
											,alt_sim_yn		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,description	--20230817 설명(DESCRIPTION) 컬럼 추가
											,project_info	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,project_s_op_report	--[E20240904-001037]_DM > Master > Sales Site Project Model 
											,cell_s_op_report		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	
											,prj_ownr_id	        --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건 
											,CRGE_ORG_NM --[PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
											,CUST_ENG_NM --[PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
					) VALUES ( 
											 @s_active_flag	 
											,@s_division_id			
											,@s_project_code			
											,@s_scm_site_id			
											,@s_item_id				
											,@s_currency				
											,@s_cell_per_car	 	    
											,@s_cell_per_module		
											,@s_liability_period		
											,@s_sales_plan_adjust_yn	
											,@s_item_hrcy_id			
											,@s_bpms_exist				
											,@s_valid_yn		 		
											,@s_cust_group				
											,@s_cust_group_dtl			
											,@s_owner					
											,@s_application			
											,@s_route					
											,@s_created_by				
											,@s_attribute1				
											,@s_attribute2				
											,@s_attribute4
											,@s_attribute6		
											,@s_edi_lt		
											,@s_report_group1			
											,@s_report_group2			
											,@s_report_group3			
											,@s_report_group4			
											--,@v_report_group5			
											,@s_report_group6			
											,@s_report_group7			
											,@s_report_group8
											,@s_vmi_lt			
											,@s_cell_name  --[PJ20200138] Cell Name 추가
											,@s_sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
											,@s_sales_plant
											,@s_partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
											,@s_kwh				--[C20210525-000374] 셀용량 및 팩 당 용량 추가
											,@s_celltypeCD		--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
											,@s_production_process  --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
											,@s_consensus_Mkt
											,@s_consensus_Ess
											,@s_consensus_Scm
											,@s_inventory_Day
											,@s_change_Reason
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
											,@s_alt_sim_yn		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,@s_description		--20230817 설명(DESCRIPTION) 컬럼 추가
											,@s_project_info	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,@s_project_s_op_report	--[E20240904-001037]_DM > Master > Sales Site Project Model 
											,@s_cell_s_op_report	--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   
											,@s_prj_ownr_id			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
											,@s_crge_org_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
											,@s_cust_eng_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
					)
			---------------------------(1)
				END
			---------------------------(1)

		---------------------------(2)
		END  -- WHILE
		---------------------------(2)

        DECLARE	@v_active_flag				NVARCHAR(01)	;
		DECLARE	@v_division_id				NVARCHAR(30)	;
		DECLARE	@v_project_code				NVARCHAR(50)	;
		DECLARE	@v_scm_site_id				NVARCHAR(30)	;
		DECLARE	@v_item_id					NVARCHAR(50)	;
		DECLARE	@v_currency					NVARCHAR(10)	;
		DECLARE	@v_cell_per_car	 			NUMERIC(20, 10)	;
		DECLARE	@v_cell_per_module			NUMERIC(20, 10)	;
		DECLARE	@v_liability_period			INT				;
		DECLARE	@v_sales_plan_adjust_yn		NVARCHAR(01)	;
		DECLARE	@v_item_hrcy_id				NVARCHAR(50)	;
		DECLARE	@v_bpms_exist				NVARCHAR(01)	;
		DECLARE	@v_valid_yn		 			NVARCHAR(01)	;
		DECLARE	@v_cust_group				NVARCHAR(100)	;
		DECLARE	@v_cust_group_dtl			NVARCHAR(100)	;
		DECLARE	@v_owner					NVARCHAR(100)	;
		DECLARE	@v_application				NVARCHAR(100)	;
		DECLARE	@v_route					NVARCHAR(40)	;
		DECLARE	@v_created_by				NVARCHAR(150)	;
		DECLARE	@v_LAST_UPDATED_BY			NVARCHAR(150)	;
		DECLARE	@v_LAST_UPDATE_DATE			NVARCHAR(150)	;
		DECLARE	@v_attribute1				NVARCHAR(150)	;
		DECLARE	@v_attribute2				NVARCHAR(150)	;
		DECLARE	@v_attribute4				NVARCHAR(150)	;
		DECLARE	@v_attribute6				NVARCHAR(150)	;
		DECLARE	@v_edi_lt					INT				;
		DECLARE	@v_report_group1			NVARCHAR(300)	;
		DECLARE	@v_report_group2			NVARCHAR(300)	;
		DECLARE	@v_report_group3			NVARCHAR(300)	;
		DECLARE	@v_report_group4			NVARCHAR(300)	;
		DECLARE	@v_report_group6			NVARCHAR(300)	;
		DECLARE	@v_report_group7			NVARCHAR(300)	;
		DECLARE	@v_report_group8			NVARCHAR(300)	;
		DECLARE	@v_vmi_lt					NVARCHAR(300)	;
		DECLARE	@v_cell_name				NVARCHAR(300)	; --[PJ20200138] Cell Name 추가
		DECLARE	@v_sales_company			NVARCHAR(300)	; --[C20200513-000276] Sales Company, Sales Plant 추가 
		DECLARE	@v_sales_plant				NVARCHAR(300)	;
		DECLARE	@v_partial_plan_yn			NVARCHAR(300)	; --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
		DECLARE	@v_kwh						NVARCHAR(300)	; --[C20210525-000374] 셀용량 및 팩 당 용량 추가
		DECLARE	@v_celltypeCD				NVARCHAR(300)	; --[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
		DECLARE @v_production_process		NVARCHAR(150)	; --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

		--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
		DECLARE @v_consensus_Mkt            NVARCHAR(2);
		DECLARE @v_consensus_Ess            NVARCHAR(2);
		DECLARE @v_consensus_Scm            NVARCHAR(2);
		DECLARE @v_inventory_Day            NVARCHAR(5);
		DECLARE @v_change_Reason            NVARCHAR(500);
		--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
		DECLARE @v_alt_sim_yn               NVARCHAR(1);	--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
		DECLARE @v_description              NVARCHAR(100);	--20230817 설명(DESCRIPTION) 컬럼 추가
		DECLARE @v_project_info             NVARCHAR(200);	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
		DECLARE @v_project_s_op_report      NVARCHAR(200);	--[E20240904-001037]_DM > Master > Sales Site Project Model 
		DECLARE @v_cell_s_op_report			NVARCHAR(200);	--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	
		DECLARE @v_prj_ownr_id				NVARCHAR(200);	--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
													
		DECLARE @v_crge_org_nm				NVARCHAR(100);  -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
		DECLARE @v_cust_eng_nm			    NVARCHAR(300);  -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 

		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR_m1_MST')
			BEGIN
				CLOSE CURSOR_m1_MST
				DEALLOCATE CURSOR_m1_MST
			END;
		DECLARE CURSOR_m1_MST CURSOR FAST_FORWARD FOR
		SELECT 
			 active_flag			
			,division_id			
			,project_code			
			,scm_site_id			
			,item_id				
			,currency				
			,cell_per_car	 	    
			,cell_per_module		
			,liability_period		
			,sales_plan_adjust_yn	
			,item_hrcy_id			
			,bpms_exist				
			,valid_yn		 		
			,cust_group				
			,cust_group_dtl			
			,owner					
			,application			
			,route					
			,created_by				
			,LAST_UPDATED_BY		
			,LAST_UPDATE_DATE		
			,attribute1				
			,attribute2				
			,attribute4				
			,attribute6				
			,edi_lt					
			,report_group1			
			,report_group2			
			,report_group3			
			,report_group4			
			,report_group6			
			,report_group7			
			,report_group8		
			,CASE WHEN vmi_lt = '' THEN 0 ELSE vmi_lt END
			,cell_name --[PJ20200138] Cell Name 추가
			,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
			,sales_plant
			,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
			,kwh				--[C20210525-000374] 셀용량 및 팩 당 용량 추가
			,celltypeCD			-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
			,production_process --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건

		--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
			,consensus_Mkt 
			,consensus_Ess 
			,consensus_Scm 
			,inventory_Day 
			,change_Reason 
		--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
		    ,alt_sim_yn		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
			,description	--20230817 설명(DESCRIPTION) 컬럼 추가
			,project_info	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
			,project_s_op_report	--[E20240904-001037]_DM > Master > Sales Site Project Model 
			,cell_s_op_report		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건  
			,prj_ownr_id			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
			,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
			,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
		FROM  #results_MST WHERE 1=1

		BEGIN
			OPEN CURSOR_m1_MST;
			FETCH NEXT FROM CURSOR_m1_MST INTO
										 @v_active_flag			
										,@v_division_id			
										,@v_project_code		
										,@v_scm_site_id			
										,@v_item_id				
										,@v_currency			
										,@v_cell_per_car	 	
										,@v_cell_per_module		
										,@v_liability_period	
										,@v_sales_plan_adjust_yn
										,@v_item_hrcy_id		
										,@v_bpms_exist			
										,@v_valid_yn		 	
										,@v_cust_group			
										,@v_cust_group_dtl		
										,@v_owner				
										,@v_application			
										,@v_route				
										,@v_created_by			
										,@v_LAST_UPDATED_BY		
										,@v_LAST_UPDATE_DATE	
										,@v_attribute1			
										,@v_attribute2			
										,@v_attribute4			
										,@v_attribute6			
										,@v_edi_lt				
										,@v_report_group1		
										,@v_report_group2		
										,@v_report_group3		
										,@v_report_group4		
										,@v_report_group6		
										,@v_report_group7		
										,@v_report_group8	
										,@v_vmi_lt	
										,@v_cell_name --[PJ20200138] Cell Name 추가
										,@v_sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
										,@v_sales_plant
										,@v_partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
										,@v_kwh				-- [C20210525-000374] 셀용량 및 팩 당 용량 추가
										,@v_celltypeCD		-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
										,@v_production_process --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
										,@v_consensus_Mkt            
										,@v_consensus_Ess            
										,@v_consensus_Scm            
										,@v_inventory_Day            
										,@v_change_Reason            
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선
										,@v_alt_sim_yn		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
										,@v_description		--20230817 설명(DESCRIPTION) 컬럼 추가
										,@v_project_info	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
										,@v_project_s_op_report	--[E20240904-001037]_DM > Master > Sales Site Project Model
										,@v_cell_s_op_report	--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건  			
										,@v_prj_ownr_id			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
										,@v_crge_org_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
										,@v_cust_eng_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 

		END
		---------------------------------------------------------------------------------------- WHILE_m1 LOOP START
		WHILE @@FETCH_STATUS = 0   
		----------------------------------------------------------------------------------------
		BEGIN


				----------◎◎◎◎ 20181121 KHSONG VALID_YN='N' 처리시 DM_PLN_SALES_PLAN,DM_PLN_SALES_PLAN_RESULT 테이블의 정보를 확인후 alert창을 띄움 (START)
				----------◎◎◎◎ [C20200812-000104] 당주 월요일 이후의 Sales Plan 이 있을 경우로 제한함.
				IF @v_valid_yn = 'N' and @v_division_id = '40'
					BEGIN
						--IF (
						--	SELECT ISNULL(COUNT(1),0) FROM
						--									(SELECT TOP 1 DIVISION_ID
						--										FROM  DM_PLN_SALES_PLAN WITH(NOLOCK)
						--											WHERE 1=1
						--											  AND DIVISION_ID		=	@v_DIVISION_ID
						--											  AND PROJECT_CODE		=	@v_PROJECT_CODE
						--											  AND SCM_SITE_ID		=	@v_SCM_SITE_ID
						--											  AND ITEM_ID			=	@v_ITEM_ID
						--											  AND QTY <> 0
						--									UNION
						--									SELECT TOP 1 DIVISION_ID
						--										FROM  DM_PLN_SALES_PLAN_RESULT WITH(NOLOCK)
						--											WHERE 1=1
						--											  AND DIVISION_ID		=	@v_DIVISION_ID
						--											  AND PROJECT_CODE		=	@v_PROJECT_CODE
						--											  AND SCM_SITE_ID		=	@v_SCM_SITE_ID
						--											  AND ITEM_ID			=	@v_ITEM_ID
						--											  AND QTY <> 0
						--										) A
						--   ) > 0
							IF EXISTS (
									SELECT DIVISION_ID
									FROM DM_PLN_MKT_FCST
									WHERE YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7*1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
										AND DIVISION_ID		=	@v_DIVISION_ID
										AND PROJECT_CODE	=	@v_PROJECT_CODE
										AND SCM_SITE_ID		=	@v_SCM_SITE_ID
										AND ITEM_ID			=	@v_ITEM_ID
										AND QTY <> 0
										-- [C20211126-000348] AS_In_Req 메저 체크 추가
										AND MEASURE IN  ('MKT_FCST', 'RTF_SCP', 'RTF', 'VMI_In_Req', 'VMI_In_Plan','AS_In_Req')
									)
							BEGIN
								set @v_description2 =  N'당주 월요일 이후의 MKT FCST 정보가 존재하므로 Active=''N'' 처리가 불가합니다.'+char(10) + N'Sales Site : ' + @v_SCM_SITE_ID +char(10) + N'Model : ' + @v_ITEM_ID
								select @v_description2
								SET @v_log_type = 'INVALID';
								GOTO ERR_RTN;	
							END

							IF EXISTS (
									SELECT DIVISION_ID 
									FROM DM_PLN_BP_FCST 
									WHERE YYYYMM >= CONVERT(CHAR(6), GETDATE(),112)
										AND DIVISION_ID		=	@v_DIVISION_ID
										AND PROJECT_CODE	=	@v_PROJECT_CODE
										AND SCM_SITE_ID		=	@v_SCM_SITE_ID
										AND ITEM_ID			=	@v_ITEM_ID
										AND QTY <> 0)
							BEGIN
								set @v_description2 =  N'계획구간의 Business Plan 정보가 존재하므로 Active=''N'' 처리가 불가합니다.'+char(10) + N'Sales Site : ' + @v_SCM_SITE_ID +char(10) + N'Model : ' + @v_ITEM_ID
								select @v_description2
								SET @v_log_type = 'INVALID';
								GOTO ERR_RTN;
							END
					END
				----------◎◎◎◎ 20181121 KHSONG VALID_YN='N' 처리시 DM_PLN_SALES_PLAN,DM_PLN_SALES_PLAN_RESULT 테이블의 정보를 확인후 alert창을 띄움 (END)

				----------◎◎◎◎ 20181005 KHSONG owner정보가 Key-In 되는경우 정상여부 확인후 비정상이면 Reject 시킴 (START)
				BEGIN
					IF ISNULL((SELECT COUNT(1)
						FROM  (SELECT token FROM dbo.String_Split(@v_owner ,','))  new_user
						LEFT JOIN dbo.TB_FX_User u  WITH(NOLOCK) 
						--LEFT JOIN [10.34.221.78,7433].[LGCE_SCMPROD].[dbo].[TB_FX_User] u  WITH(NOLOCK) 
						ON   new_user.token = u.UserID
						AND  u.UseYN = 'Y' 
							WHERE u.UserID is null
							),0) > 0
						BEGIN
							SELECT N'Owner정보가 존재하지 않습니다.' +char(10) + N'● Owner : ' + @v_owner
							SET @v_log_type = 'INVALID';
							GOTO ERR_RTN;	
						END
				END
				----------◎◎◎◎ 20181005 KHSONG owner정보가 Key-In 되는경우 정상여부 확인후 비정상이면 Reject 시킴 (END)

				----------◎◎◎◎ 20200113 KHSONG 해당 Sales Site의 소속팀의 아닌경우 Reject 시킴 (START)
				--[PJ2024-50461] Team Mapping------------------------------------
				--OWNER 체크 주석처리
				/*DECLARE @v_invalid_owner NVARCHAR(50);
				IF @v_DIVISION_ID <> '40'
				BEGIN
					set @v_invalid_owner = 
						-- 20200514 KHSONG C20200409-000351 신규로직(BEGIN)
						(
						SELECT TOP 1 TOKEN FROM 
								(
								SELECT new_user.TOKEN
									,CASE WHEN SITE.DEPT_ID IS NOT NULL
											THEN SITE.DEPT_ID
										  ELSE LOOKUP.SEGMENT3
									END AS DEPT_ID
									,FXU.UserID  -- 20200604 KHSONG C20200422-000403 FXU.UserID추가
									--,LOOKUP.SEGMENT1,LOOKUP.SEGMENT3
									FROM  (SELECT token FROM dbo.String_Split(@v_owner ,','))  new_user
									LEFT JOIN dbo.SCM_MST_SSO_USER_INFO u  WITH(NOLOCK) 
										ON 	u.USER_ID = new_user.token
										AND	u.ACTIVE_FLAG <> 'D' -- 퇴사정보는 제외
									LEFT JOIN dbo.SCM_MST_SITE SITE  WITH(NOLOCK) 
										ON  SITE.DIVISION_ID	= @v_DIVISION_ID
										AND SITE.SCM_SITE_ID	= @v_SCM_SITE_ID
										AND SITE.DEPT_ID		= u.DEPT_ID

									LEFT JOIN dbo.SCM_MST_SITE SITE2  WITH(NOLOCK) 
										ON  SITE2.DIVISION_ID	= @v_DIVISION_ID
										AND SITE2.SCM_SITE_ID	= @v_SCM_SITE_ID

									LEFT JOIN dbo.SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP WITH(NOLOCK) 
										ON 	LOOKUP.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
										AND LOOKUP.VALID_YN = 'Y'
										AND LOOKUP.SEGMENT1 = u.DEPT_ID       --[C20200506-000277] Owner 의 site 확인 시 Lookup PM_TEAM_MAPPING 의 PM Team도 대상에 포함
										AND LOOKUP.SEGMENT3 = SITE2.DEPT_ID
										
										--AND LOOKUP.SEGMENT3 = u.DEPT_ID
										--AND LOOKUP.SEGMENT1 = SITE2.DEPT_ID

									-- 20200604 KHSONG C20200422-000403 GSCM USER정보 추가 (BEGIN)
									LEFT JOIN dbo.TB_FX_UserGroupAuthExtention FXU WITH(NOLOCK) 
										ON 	FXU.GroupID = 'DM Planner (W/S)'
										AND FXU.UserID = new_user.token
									-- 20200604 KHSONG C20200422-000403 GSCM USER정보 추가 (END)

									WHERE 1=1
								GROUP BY new_user.TOKEN,SITE.DEPT_ID,LOOKUP.SEGMENT3,FXU.UserID  -- 20200604 KHSONG C20200422-000403 FXU.UserID추가
								) Z
						WHERE DEPT_ID IS NULL -- 소속팀이 아닌경우
						  AND UserID  IS NULL -- 20200604 KHSONG C20200422-000403 FXU.UserID 가 WS Owner인경우는 아이디값이 조회됨. NULL인경우만 Validation 조건대상으로 포함.
						)
						-- 20200514 KHSONG C20200409-000351 신규로직(END)

																									-- 20200514 KHSONG C20200409-000351 주석처리(BEGIN)
																									/*
																									(SELECT TOP 1 TOKEN FROM 
																											(SELECT new_user.TOKEN,SITE.DEPT_ID
																												FROM  (SELECT token FROM dbo.String_Split(@v_owner ,','))  new_user
																												LEFT JOIN dbo.SCM_MST_SSO_USER_INFO u  WITH(NOLOCK) 
																													ON 	u.USER_ID = new_user.token
																													AND	u.ACTIVE_FLAG <> 'D' -- 퇴사정보는 제외
																												LEFT JOIN dbo.SCM_MST_SITE SITE  WITH(NOLOCK) 
																													ON  SITE.DIVISION_ID	= @v_DIVISION_ID
																													AND SITE.SCM_SITE_ID	= @v_SCM_SITE_ID
																													AND SITE.DEPT_ID		= u.DEPT_ID
																												WHERE 1=1
																											GROUP BY new_user.TOKEN,SITE.DEPT_ID
																											) Z
																									WHERE DEPT_ID IS NULL -- 소속팀이 아닌경우
																									)
																									*/
																									-- 20200514 KHSONG C20200409-000351 주석처리(END)
					IF @v_invalid_owner IS NOT NULL
						BEGIN
							SELECT N'● Owner : ' + @v_invalid_owner + N' 은(는) ' + N'[ ' + @v_SCM_SITE_ID + N' ]' + N' Sales Site의 소속팀이 아닙니다.'
							SET @v_log_type = 'INVALID';
							GOTO ERR_RTN;	
						END
				END
				*/
				----------◎◎◎◎ 20200113 KHSONG 해당 Sales Site의 소속팀의 아닌경우 Reject 시킴 (END)
				--[PJ2024-50461] Team Mapping------------------------------------
				-------------------------------------------------------------------◎◎◎◎ PRODUCT DETAILS. Validation (Start )
								
				IF NOT EXISTS (
					SELECT 1
					FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
					WHERE  LOOKUP_TYPE = 'REPORT_GROUP4'
					AND VALID_YN = 'Y'
					AND SEGMENT3 = @v_report_group3
					AND SEGMENT1 = @v_report_group4
					) AND @v_report_group3 <> '' AND @v_report_group4 <> ''
				BEGIN 
					BEGIN
						SELECT @v_report_group4 + N'는 ' + @v_report_group3 + N'과 같이 사용될 수 없습니다.' +char(10) + N'다른 Product Details.를 사용하시기 바랍니다. ' 
						SET @v_log_type = 'INVALID';
						GOTO ERR_RTN;	
					END
				END
				-------------------------------------------------------------------◎◎◎◎ PRODUCT DETAILS. Validation ( END )

				BEGIN        

					IF @v_active_flag = 'I'

						BEGIN
							PRINT N'I적용'
							IF @v_division_id = '40'  -- 20190125 KHSONG 전지재료 DIVISION_ID 추가 -> 삭제
								BEGIN  -- '40' DIVISION 인 경우

								-------------------------------------------------------------------◎◎◎◎ Site Item ID 존재여부 Validation
								IF ISNULL((SELECT COUNT(1)
									FROM dbo.DM_MST_ITEM_SINGLE_V SN WITH(NOLOCK)
									where 1=1
 										and SN.division_id   = @v_division_id
										and SN.ITEM_ID       = @v_item_id
										and SN.ACTIVE_FLAG	   = 'Y'
										),0) = 0
									BEGIN
										SELECT '['+ @v_item_id +']'+ N' Invalid Item ID !'
										SET @v_description2 = '['+ @v_item_id +']'+ N' Invalid Item ID !'
										SET @v_log_type = 'INVALID';
										GOTO ERR_RTN;	
									END
								-------------------------------------------------------------------◎◎◎◎
								-------------------------------------------------------------------◎◎◎◎ 11자리 모델 코드 중복여부 Validation
								DECLARE @DUP_ITEM_ID     NVARCHAR(MAX);
								SET @DUP_ITEM_ID = NULL;

								-- 20180716 KHSONG 11자리 코드중복건 validation 추가 (START) 20180906 수정함
								SET @DUP_ITEM_ID = ( SELECT TOP 1 A.ITEM_ID
													   FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
													   JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND B.SITE_TYPE = 'SALES'
													  WHERE A.DIVISION_ID = @v_division_id
														AND SUBSTRING(UPPER(@v_ITEM_ID),1,2) = 'MP'
														--[E20260325-001071]_11자리 체크부분 -> 12자리로 변경 (START)
														--AND SUBSTRING(A.ITEM_ID, 1, 11) = SUBSTRING(@v_ITEM_ID, 1, 11) --[E20260325-001071]_원소스 주석처리
														AND SUBSTRING(A.ITEM_ID, 1, 12) = SUBSTRING(@v_ITEM_ID, 1, 12) --[E20260325-001071]_11자리 -> 12자리로 변경
														--[E20260325-001071]_11자리 체크부분 -> 12자리로 변경 (END)
														AND A.ITEM_ID <> @v_ITEM_ID																
														AND	A.VALID_YN = 'Y'	-- [C20200916-000412 ]
														--AND VALID_YN = 'Y'  -- 20180813 KHSONG PK값 기준으로 Validation 될수있도록 주석처리
										           )
								IF @DUP_ITEM_ID IS NOT NULL
								BEGIN
									--[E20260325-001071]_11자리 체크부분 -> 12자리로 변경 (START)
									--SELECT N'동일 Pack Model이 존재합니다.'+char(10) + N'11자리 모델 코드에 대하여 중복저장이 불가합니다.' +char(10) + N'아래 Model을 사용하시기 바랍니다. ' +char(10) + N'● Model : ' + @DUP_ITEM_ID --[E20260325-001071]_원소스 주석처리
									SELECT N'동일 Pack Model이 존재합니다.'+char(10) + N'12자리 모델 코드에 대하여 중복저장이 불가합니다.' +char(10) + N'아래 Model을 사용하시기 바랍니다. ' +char(10) + N'● Model : ' + @DUP_ITEM_ID --[E20260325-001071]_11자리 -> 12자리로 변경
									--[E20260325-001071]_11자리 체크부분 -> 12자리로 변경 (END)
									   SET @v_log_type = 'INVALID';
									GOTO ERR_RTN;	
								END

								-- 20180716 KHSONG 11자리 코드중복건 validation 추가 (END) 20180906 수정함
								-------------------------------------------------------------------◎◎◎◎
								-------------------------------------------------------------------◎◎◎◎ ITEM_ID 중복여부 Validation
								IF ISNULL((SELECT COUNT(1)
									FROM   [dbo].SCM_MST_SITE_ITEM WITH(NOLOCK)
										WHERE   DIVISION_ID					= @v_division_id
											AND PROJECT_CODE				= @v_project_code
											AND SCM_SITE_ID					= @v_scm_site_id
											AND ITEM_ID						= @v_ITEM_ID
										  --AND VALID_YN     = 'Y'  -- 20180813 KHSONG PK값 기준으로 Validation 될수있도록 주석처리
										),0) > 0
									BEGIN
										SELECT 'MSG00210'
										-- 동일한 EndCustomer, SalesSite, Model에 대하여 중복저장이 불가합니다.
										SET @v_log_type = 'INVALID';
										GOTO ERR_RTN;	
									END
									

								-------------------------------------------------------------------◎◎◎◎
										INSERT [dbo].[SCM_MST_SITE_ITEM]
										(
											 [DIVISION_ID]
											,[PROJECT_CODE]
											,[SCM_SITE_ID]
											,[ITEM_ID]
											,[CURRENCY]
											,[CELL_PER_CAR]     --20180417 add skh
											,[CELL_PER_MODULE]  --20180417 add skh
											,[LIABILITY_PERIOD]
											,[SALES_PLAN_ADJUST_YN]
											,[ITEM_HRCY_ID]
											,[VALID_YN]
											,[BPMS_EXIST]
											--20180601 khsong 소형관련 신규 컬럼추가(START)
											,[cust_group]
											,[cust_group_dtl]
											,[owner]
											,[application]
											,[route]
											--20180601 khsong 소형관련 신규 컬럼추가(END)
											,[CREATED_BY]
											,[CREATION_DATE]
											,[LAST_UPDATED_BY]
											,[LAST_UPDATE_DATE]
											,[ATTRIBUTE1]
											,[ATTRIBUTE2]
											,[ATTRIBUTE4]  -- 20180727
											,[ATTRIBUTE6]  -- 20181031
											,[edi_lt]	   -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
											-- 20190402 KHSONG 소형 Report 컬럼 추가 
											,REPORT_GROUP1
											,REPORT_GROUP2
											,REPORT_GROUP3
											,REPORT_GROUP4
											--,REPORT_GROUP5
											,REPORT_GROUP6
											,REPORT_GROUP7
											,REPORT_GROUP8
											,SCP_VMI_LT
											,ATTRIBUTE9 --[PJ20200138] Cell Name 추가
											,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
											,sales_plant
											,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
											,CONSENSUS_MKT
											,CONSENSUS_ESS
											,CONSENSUS_SCM
											,INVENTORY_DAY
											,CHANGE_REASON
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
											,ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
											,PROJECT_INFO	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model
											,CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	
											,PRJ_OWNR_ID            --[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
											,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
											,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
										)
										SELECT 
											 @v_division_id				AS	[DIVISION_ID] 
											,@v_project_code			AS	[PROJECT_CODE]
											,@v_scm_site_id				AS	[SCM_SITE_ID]
											,@v_item_id					AS  ITEM_ID
											,@v_currency				AS	[CURRENCY]
											,@v_cell_per_car			AS	[CELL_PER_CAR]
											,@v_cell_per_module			AS	[CELL_PER_MODULE]
											,@v_liability_period		AS	[LIABILITY_PERIOD]
											,@v_sales_plan_adjust_yn	AS	[SALES_PLAN_ADJUST_YN]
											,@v_item_hrcy_id			AS	[ITEM_HRCY_ID]
											,'Y'						AS	[VALID_YN]
											,@v_bpms_exist				AS	[BPMS_EXIST]

											--20180601 khsong 소형관련 신규 컬럼추가(START)
											,@v_cust_group				AS	[cust_group]
											,@v_cust_group_dtl			AS	[cust_group_dtl]
											,@v_owner--(SELECT MAX(USER_ID) FROM SCM_MST_SSO_USER_INFO WITH(NOLOCK) WHERE USER_ID = @v_owner OR USER_NAME = @v_owner OR USER_NAME_EN = @v_owner) AS [owner]  --20180704 KHSONG owner조회조건수정
											--,@v_owner					AS	[owner]
											,@v_application				AS	[application]
											,@v_route					AS	[route]
											--20180601 khsong 소형관련 신규 컬럼추가(END)

											,@v_created_by				AS	[CREATED_BY]
											,sysdatetime()				AS	[CREATION_DATE]
											,@v_created_by				AS	[LAST_UPDATED_BY]
											,sysdatetime()				AS	[LAST_UPDATE_DATE]
											,@v_attribute1				AS	[ATTRIBUTE1]
											,@v_attribute2				AS	[ATTRIBUTE2]
											,@v_attribute4				AS	[ATTRIBUTE4]  -- 20180727
											,@v_attribute6				AS	[ATTRIBUTE6]  -- 20181031
											,@v_edi_lt					AS	[edi_lt]      -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
											-- 20190402 KHSONG 소형 Report 컬럼 추가 
											,@v_report_group1			AS	REPORT_GROUP1
											,@v_report_group2			AS	REPORT_GROUP2
											,@v_report_group3			AS	REPORT_GROUP3
											,@v_report_group4			AS	REPORT_GROUP4
											--,@v_report_group5			AS	REPORT_GROUP5
											,@v_report_group6			AS	REPORT_GROUP6
											,@v_report_group7			AS	REPORT_GROUP7
											,@v_report_group8			AS	REPORT_GROUP8
											,@v_vmi_lt					AS  SCP_VMI_LT
											,@v_production_process		AS  PRODUCTION_PROCESS --[PJ20200138] Cell Name 추가 --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건										
											,@v_sales_company			AS SALES_COMPANY --[C20200513-000276] Sales Company, Sales Plant 추가 
											,@v_sales_plant				AS SALES_PLANT
											,@v_partial_plan_yn			AS PARTIAL_PLAN_YN --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
											,@v_consensus_Mkt           AS CONSENSUS_MKT
											,@v_consensus_Ess           AS CONSENSUS_ESS
											,@v_consensus_Scm           AS CONSENSUS_SCM
											,@v_inventory_Day           AS INVENTORY_DAY
											,@v_change_Reason           AS CHANGE_REASON
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
										    ,@v_alt_sim_yn              AS ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,@v_description             AS DESCRIPTION		--20230817 설명(DESCRIPTION) 컬럼 추가
											,@v_project_info            AS PROJECT_INFO		--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,@v_project_s_op_report     AS PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model 
											,@v_cell_s_op_report		AS CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	
											,@v_prj_ownr_id				AS PRJ_OWNR_ID			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
											,@v_crge_org_nm             AS CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
											,@v_cust_eng_nm             AS CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
								END
							-- 20180619 khsong 소형관련 Validation 조건추가 (END)
							ELSE   
								BEGIN  -- 81,82 DIVISION 인 경우
										
									PRINT '82사업부 시작'
									-------------------------------------------------------------------◎◎◎◎ project_code 존재여부 Validation
									IF @v_division_id LIKE '81%' OR @v_division_id = '82'  -- 20190122 KHSONG 재료관련 로직추가
										BEGIN
											IF ISNULL((SELECT COUNT(1)
												FROM   [dbo].SCM_MST_PROJECT_ITEM WITH(NOLOCK)
														WHERE  DIVISION_ID  = @v_division_id
														AND	   PROJECT_CODE = @v_project_code
														AND    VALID_YN     = 'Y'
													),0) = 0
												BEGIN
													SELECT 'MSG00156';
													-- 해당프로젝트에 연결된 모델이 없습니다.  프로젝트 모델 연결 정보를 확인해주세요.
													SET @v_log_type = 'INVALID';
													GOTO ERR_RTN;	
												END
												-------------------------------------------------------------------◎◎◎◎ 20180903 KHSONG 81,82 중복값 INSERT VALIDATION 추가 (START)
												IF ISNULL((SELECT COUNT(1) FROM [SCM_MST_SITE_ITEM] WITH(NOLOCK)
													WHERE 1=1
														AND DIVISION_ID	    = @v_division_id
														AND	PROJECT_CODE	= @v_project_code
														AND scm_site_id     = @v_scm_site_id
														AND EXISTS
																(
																SELECT	
																		[DIVISION_ID]
																FROM [dbo].[SCM_MST_PROJECT_ITEM] WITH(NOLOCK)
																WHERE	[DIVISION_ID]	= @v_division_id
																	AND	[PROJECT_CODE]	= @v_project_code
																	and [VALID_YN]		= 'Y'	
																GROUP BY 
																	 [DIVISION_ID]
																	,[PROJECT_CODE]
																	,[ITEM_ID]
																	,[ITEM_TYPE]
																)),0) > 0										
												BEGIN
													SELECT N'동일한 Sales Site, Project Code 가 이미 존재합니다..'
													SET @v_log_type = 'INVALID';
													GOTO ERR_RTN;	
												END
												-------------------------------------------------------------------◎◎◎◎ 20180903 KHSONG 81,82 중복값 INSERT VALIDATION 추가 (END)
											
												DELETE FROM #TEMP_RESULT_MST;

												-- [PJ20228272] NERP 대응 - 81 사업부 신규 등록 I/F(PR_DM_XIF_ERP_SITE_ITEM_S) START
												-- #TEMP_RESULT_MST 에 Input 데이터 생성

												--INSERT [dbo].[SCM_MST_SITE_ITEM]
												INSERT #TEMP_RESULT_MST
												(
													 [DIVISION_ID]
													,[PROJECT_CODE]
													,[SCM_SITE_ID]
													,[ITEM_ID]
													,[CURRENCY]
													,[CELL_PER_CAR]  --20180417 add skh
													,[CELL_PER_MODULE]  --20180417 add skh
													,[LIABILITY_PERIOD]
													,[SALES_PLAN_ADJUST_YN]
													,[ITEM_HRCY_ID]
													,[VALID_YN]
													,[BPMS_EXIST]
													,[owner]  --20180721 add sonyoungsuk
													,[CREATED_BY]
													,[CREATION_DATE]
													,[LAST_UPDATED_BY]
													,[LAST_UPDATE_DATE]
													,[ATTRIBUTE1]
													,[ATTRIBUTE2]
													,[ATTRIBUTE4]  -- 20180727
													,[ATTRIBUTE6]  -- 20181031
													,[edi_lt]      -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
													-- 20190402 KHSONG 소형 Report 컬럼 추가 
													,REPORT_GROUP1
													,REPORT_GROUP2
													,REPORT_GROUP3
													,REPORT_GROUP4
													--,REPORT_GROUP5
													,REPORT_GROUP6
													,REPORT_GROUP7
													,REPORT_GROUP8
													,VMI_LT
													,CELL_NAME --[PJ20200138] Cell Name 추가
													,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
													,sales_plant
													,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
													,KWH --[C20210525-000374] 셀용량 및 팩 당 용량 추가
													,CellTypeCD	--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
													,CONSENSUS_MKT
													,CONSENSUS_ESS
													,CONSENSUS_SCM
													,INVENTORY_DAY
													,CHANGE_REASON
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
													,ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
													,DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
													,PROJECT_INFO	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
													,PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model 													
													,CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	
													,PRJ_OWNR_ID			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
													,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
													,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
												)
												SELECT 
													 @v_division_id			AS [DIVISION_ID]
													,@v_project_code		AS [PROJECT_CODE]
													,@v_scm_site_id			AS [SCM_SITE_ID]
													,A.[ITEM_ID]			AS [ITEM_ID]
													,@v_currency			AS [CURRENCY]
													,@v_cell_per_car		AS [CELL_PER_CAR]
													--, CASE WHEN  @v_division_id	 LIKE '81%' and @v_cell_per_module IS NULL THEN A.CELL_CF
													--	   ELSE @v_cell_per_module	END	AS [CELL_PER_MODULE] -- 20230323 [E20230322-001672] 셀환산자
													,@v_cell_per_module		AS [CELL_PER_MODULE]
													,@v_liability_period	AS [LIABILITY_PERIOD]
													,@v_sales_plan_adjust_yn AS [SALES_PLAN_ADJUST_YN]
													,@v_item_hrcy_id		AS [ITEM_HRCY_ID]
													,'Y'					AS [VALID_YN]
													,@v_bpms_exist			AS [BPMS_EXIST]
													,@v_owner--((SELECT MAX(USER_ID) FROM SCM_MST_SSO_USER_INFO WITH(NOLOCK) WHERE USER_ID = @v_owner OR USER_NAME = @v_owner OR USER_NAME_EN = @v_owner) AS [owner]  --20180721 sonyoungsuk 저장항목추가
													,@v_created_by			AS [CREATED_BY]
													,sysdatetime()			AS [CREATION_DATE]
													,@v_created_by			AS [LAST_UPDATED_BY]
													,sysdatetime()			AS [LAST_UPDATE_DATE]
													,@v_attribute1			AS [ATTRIBUTE1]
													,@v_attribute2			AS [ATTRIBUTE2]
													,@v_attribute4			AS [ATTRIBUTE4]  -- 20180727
													,@v_attribute6			AS [ATTRIBUTE6]  -- 20181031
													,@v_edi_lt				AS [edi_lt    ]  -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
													-- 20190402 KHSONG 소형 Report 컬럼 추가 
													,@v_report_group1		AS	REPORT_GROUP1
													,@v_report_group2		AS	REPORT_GROUP2
													,@v_report_group3		AS	REPORT_GROUP3
													,@v_report_group4		AS	REPORT_GROUP4
													--,@v_report_group5		AS	REPORT_GROUP5
													,@v_report_group6		AS	REPORT_GROUP6
													,@v_report_group7		AS	REPORT_GROUP7
													,@v_report_group8		AS	REPORT_GROUP8
													,@v_vmi_lt				AS  SCP_VMI_LT													
													,ISNULL(A.CELL_NAME,@v_cell_name) AS  CELL_NAME --[PJ20200138] Cell Name 추가																					
													,@v_sales_company			AS SALES_COMPANY --[C20200513-000276] Sales Company, Sales Plant 추가 
													,@v_sales_plant				AS SALES_PLANT
													,@v_partial_plan_yn			AS PARTIAL_PLAN_YN --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
													,@v_kwh						AS KWH				--[C20210525-000374] 셀용량 및 팩 당 용량 추가
													,@v_celltypeCD				AS CELL_TYPE_CD		--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
													,@v_consensus_Mkt           AS CONSENSUS_MKT
													,@v_consensus_Ess           AS CONSENSUS_ESS
													,@v_consensus_Scm           AS CONSENSUS_SCM
													,@v_inventory_Day           AS INVENTORY_DAY
													,@v_change_Reason           AS CHANGE_REASON
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
													,@v_alt_sim_yn              AS ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
													,@v_description             AS DESCRIPTION		--20230817 설명(DESCRIPTION) 컬럼 추가
													,@v_project_info	        AS PROJECT_INFO		--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
													,@v_project_s_op_report     AS PROJECT_S_OP_REPORT		--[E20240904-001037]_DM > Master > Sales Site Project Model 
													,@v_cell_s_op_report		AS CELL_S_OP_REPORT			--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	
													,@v_prj_ownr_id				AS PRJ_OWNR_ID				--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
													,@v_crge_org_nm             AS CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
													,@v_cust_eng_nm             AS CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
												FROM
												(									
													SELECT	
															P.[DIVISION_ID]
														,P.[PROJECT_CODE]
														,max(P.[PROJECT_VER_SEQ]) AS [PROJECT_VER_SEQ]
														,P.[ITEM_ID]
														,P.[ITEM_TYPE]
														,MAX(S.ATTRIBUTE9) AS CELL_NAME --[PJ20200138] Cell Name 추가
														--,MAX(F.CELL_CF) AS CELL_CF -- 20230323 [E20230322-001672] 셀환산자
													FROM [dbo].[SCM_MST_PROJECT_ITEM] P WITH(NOLOCK)
													LEFT OUTER JOIN SCM_MST_SITE_ITEM S WITH(NOLOCK)													 
													ON ( P.DIVISION_ID		= S.DIVISION_ID
														AND P.ITEM_ID		= S.ITEM_ID )
													--LEFT OUTER JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- 20230323 [E20230322-001672] 셀환산자
													--ON ( P.DIVISION_ID		= F.DIVISION_ID
													--	AND P.ITEM_ID		= F.ITEM_ID )
													WHERE	P.[DIVISION_ID]		= @v_division_id
														AND	P.[PROJECT_CODE]	= @v_project_code
														and P.[VALID_YN]		= 'Y'	
													GROUP BY 
															P.[DIVISION_ID]
														,P.[PROJECT_CODE]
														,P.[ITEM_ID]
														,P.[ITEM_TYPE]			
												) A													
												;

												
												-- SCM_MST_SITE_ITEM 에 Input
												INSERT [dbo].[SCM_MST_SITE_ITEM]
												(
													 [DIVISION_ID]
													,[PROJECT_CODE]
													,[SCM_SITE_ID]
													,[ITEM_ID]
													,[CURRENCY]
													,[CELL_PER_CAR]  --20180417 add skh
													,[CELL_PER_MODULE]  --20180417 add skh
													,[LIABILITY_PERIOD]
													,[SALES_PLAN_ADJUST_YN]
													,[ITEM_HRCY_ID]
													,[VALID_YN]
													,[BPMS_EXIST]
													,[owner]  --20180721 add sonyoungsuk
													,[CREATED_BY]
													,[CREATION_DATE]
													,[LAST_UPDATED_BY]
													,[LAST_UPDATE_DATE]
													,[ATTRIBUTE1]
													,[ATTRIBUTE2]
													,[ATTRIBUTE4]  -- 20180727
													,[ATTRIBUTE6]  -- 20181031
													,[edi_lt]      -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
													-- 20190402 KHSONG 소형 Report 컬럼 추가 
													,REPORT_GROUP1
													,REPORT_GROUP2
													,REPORT_GROUP3
													,REPORT_GROUP4
													--,REPORT_GROUP5
													,REPORT_GROUP6
													,REPORT_GROUP7
													,REPORT_GROUP8
													,SCP_VMI_LT
													,ATTRIBUTE9 --[PJ20200138] Cell Name 추가
													,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
													,sales_plant
													,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
													,ATTRIBUTE8		--[C20210525-000374] 셀용량 및 팩 당 용량 추가
													,ATTRIBUTE10	--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
													,CONSENSUS_MKT
													,CONSENSUS_ESS
													,CONSENSUS_SCM
													,INVENTORY_DAY
													,CHANGE_REASON
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
													,ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
													,DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
													,PROJECT_INFO	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
													,PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model 													
													,CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	
													,PRJ_OWNR_ID			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
													,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
													,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
												)
												SELECT 
													 [DIVISION_ID]
													,[PROJECT_CODE]
													,[SCM_SITE_ID]
													,[ITEM_ID]
													,[CURRENCY]
													,[CELL_PER_CAR]  --20180417 add skh
													,[CELL_PER_MODULE]  --20180417 add skh
													,[LIABILITY_PERIOD]
													,[SALES_PLAN_ADJUST_YN]
													,[ITEM_HRCY_ID]
													,[VALID_YN]
													,[BPMS_EXIST]
													,[owner]  --20180721 add sonyoungsuk
													,[CREATED_BY]
													,[CREATION_DATE]
													,[LAST_UPDATED_BY]
													,[LAST_UPDATE_DATE]
													,[ATTRIBUTE1]
													,[ATTRIBUTE2]
													,[ATTRIBUTE4]  -- 20180727
													,[ATTRIBUTE6]  -- 20181031
													,[edi_lt]      -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
													-- 20190402 KHSONG 소형 Report 컬럼 추가 
													,REPORT_GROUP1
													,REPORT_GROUP2
													,REPORT_GROUP3
													,REPORT_GROUP4
													--,REPORT_GROUP5
													,REPORT_GROUP6
													,REPORT_GROUP7
													,REPORT_GROUP8
													,VMI_LT
													,CELL_NAME --[PJ20200138] Cell Name 추가
													,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
													,sales_plant
													,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
													,KWH --[C20210525-000374] 셀용량 및 팩 당 용량 추가
													,CellTypeCD	--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
													,CONSENSUS_MKT
													,CONSENSUS_ESS
													,CONSENSUS_SCM
													,INVENTORY_DAY
													,CHANGE_REASON
													--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
													,ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
													,DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
													,PROJECT_INFO	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
													,PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model 													
													,CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	
													,PRJ_OWNR_ID			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
													,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
													,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
												FROM  #TEMP_RESULT_MST WITH(NOLOCK)
												;
												

												IF @v_division_id LIKE '81%'

												BEGIN
												
													-- #XIF_ERP_SITE_ITEM 에 Input
													INSERT #XIF_ERP_SITE_ITEM
													(		DIVISION_ID
														  , SCM_SITE_ID
														  , PROJECT_CODE
														  , ITEM_ID
														  , CREATED_BY
														  , CREATION_DATE
														  , LAST_UPDATED_BY
														  , LAST_UPDATE_DATE
													)
													SELECT DIVISION_ID
														 , SCM_SITE_ID
														 , PROJECT_CODE
														 , ITEM_ID
														 , CREATED_BY
														 , CREATION_DATE
														 , LAST_UPDATED_BY
														 , LAST_UPDATE_DATE
													FROM   #TEMP_RESULT_MST
													WHERE  DIVISION_ID LIKE '81%'
													;

												END
												-- [PJ20228272] NERP 대응 - 81 사업부 신규 등록 I/F(PR_DM_XIF_ERP_SITE_ITEM_S) END

										END
									------------
									ELSE
									------------
										-- 재료 데이터 INSERT시 타는 로직
										BEGIN
												INSERT [dbo].[SCM_MST_SITE_ITEM]
												(
													 [DIVISION_ID]
													,[PROJECT_CODE]
													,[SCM_SITE_ID]
													,[ITEM_ID]
													,[CURRENCY]
													,[CELL_PER_CAR]  --20180417 add skh
													,[CELL_PER_MODULE]  --20180417 add skh
													,[LIABILITY_PERIOD]
													,[SALES_PLAN_ADJUST_YN]
													,[ITEM_HRCY_ID]
													,[VALID_YN]
													,[BPMS_EXIST]
													,[owner]  --20180721 add sonyoungsuk
													,[CREATED_BY]
													,[CREATION_DATE]
													,[LAST_UPDATED_BY]
													,[LAST_UPDATE_DATE]
													,[ATTRIBUTE1]
													,[ATTRIBUTE2]
													,[ATTRIBUTE4]  -- 20180727
													,[ATTRIBUTE6]  -- 20181031
													,[edi_lt]	   -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
													-- 20190402 KHSONG 소형 Report 컬럼 추가 
													,REPORT_GROUP1
													,REPORT_GROUP2
													,REPORT_GROUP3
													,REPORT_GROUP4
													--,REPORT_GROUP5
													,REPORT_GROUP6
													,REPORT_GROUP7
													,REPORT_GROUP8
													,SCP_VMI_LT
													,ATTRIBUTE9 --[PJ20200138] Cell Name 추가
													,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
													,sales_plant
													,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
													,ATTRIBUTE8		--[C20210525-000374] 셀용량 및 팩 당 용량 추가
													,ATTRIBUTE10		--[C20210525-000374] 셀용량 및 팩 당 용량 추가

												)
												SELECT 
													 @v_division_id			AS [DIVISION_ID]
													,@v_project_code		AS [PROJECT_CODE]
													,@v_scm_site_id			AS [SCM_SITE_ID]
													,@v_item_id				AS [ITEM_ID]
													,@v_currency			AS [CURRENCY]
													,@v_cell_per_car		AS [CELL_PER_CAR]
													,@v_cell_per_module		AS [CELL_PER_MODULE]
													,@v_liability_period	AS [LIABILITY_PERIOD]
													,@v_sales_plan_adjust_yn AS [SALES_PLAN_ADJUST_YN]
													,@v_item_hrcy_id		AS [ITEM_HRCY_ID]
													,'Y'					AS [VALID_YN]
													,@v_bpms_exist			AS [BPMS_EXIST]
													,@v_owner--((SELECT MAX(USER_ID) FROM SCM_MST_SSO_USER_INFO WITH(NOLOCK) WHERE USER_ID = @v_owner OR USER_NAME = @v_owner OR USER_NAME_EN = @v_owner) AS [owner]  --20180721 sonyoungsuk 저장항목추가
													,@v_created_by			AS [CREATED_BY]
													,sysdatetime()			AS [CREATION_DATE]
													,@v_created_by			AS [LAST_UPDATED_BY]
													,sysdatetime()			AS [LAST_UPDATE_DATE]
													,@v_attribute1			AS [ATTRIBUTE1]
													,@v_attribute2			AS [ATTRIBUTE2]
													,@v_attribute4			AS [ATTRIBUTE4]  -- 20180727
													,@v_attribute6			AS [ATTRIBUTE6]  -- 20181031
													,@v_edi_lt				AS [edi_lt]		 -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
													-- 20190402 KHSONG 소형 Report 컬럼 추가 
													,@v_report_group1		AS	REPORT_GROUP1
													,@v_report_group2		AS	REPORT_GROUP2
													,@v_report_group3		AS	REPORT_GROUP3
													,@v_report_group4		AS	REPORT_GROUP4
													--,@v_report_group5		AS	REPORT_GROUP5
													,@v_report_group6		AS	REPORT_GROUP6
													,@v_report_group7		AS	REPORT_GROUP7
													,@v_report_group8		AS	REPORT_GROUP8
													,@v_vmi_lt				AS  SCP_VMI_LT
													
													,@v_cell_name			AS  CELL_NAME --[PJ20200138] Cell Name 추가		
													,@v_sales_company		AS SALES_COMPANY --[C20200513-000276] Sales Company, Sales Plant 추가 
													,@v_sales_plant			AS SALES_PLANT
													,@v_partial_plan_yn		AS PARTIAL_PLAN_YN --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
													,@v_kwh					AS KWH				-- [C20210525-000374] 셀용량 및 팩 당 용량 추가
													,@v_celltypeCD			AS CELL_TYPE_CD		--[C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가

										END
									-------------------------------------------------------------------◎◎◎◎
										
								END

						END

					ELSE
						--PRINT N'M적용'
						--PRINT @v_consensus_Mkt
						BEGIN
															 
							MERGE INTO [dbo].[SCM_MST_SITE_ITEM] A
							USING (
									SELECT 
										@v_division_id	as division_id, 
										@v_project_code	as project_code,
										@v_scm_site_id	as scm_site_id,
										@v_item_id		as item_id 
								  ) B
							ON(
										A.division_id  = B.division_id
									AND A.project_code = B.project_code
									AND A.scm_site_id  = B.scm_site_id
									AND A.item_id	   = B.item_id
							  )
							WHEN MATCHED THEN
								 UPDATE SET 
										 division_id			= @v_division_id
										,project_code			= @v_project_code
										,scm_site_id			= @v_scm_site_id 
										,item_id				= @v_item_id
										,currency				= @v_currency
										,cell_per_car			= @v_cell_per_car
										,cell_per_module		= @v_cell_per_module
										,liability_period		= @v_liability_period
										,sales_plan_adjust_yn	= @v_sales_plan_adjust_yn
										,item_hrcy_id			= @v_item_hrcy_id
										,bpms_exist				= @v_bpms_exist
										,valid_yn				= @v_valid_yn
										--20180601 khsong 소형관련 신규 컬럼추가
										,cust_group				= @v_cust_group
										,cust_group_dtl			= @v_cust_group_dtl
										,owner	= @v_owner--(SELECT MAX(USER_ID) FROM SCM_MST_SSO_USER_INFO WITH(NOLOCK) WHERE USER_ID = @v_owner OR USER_NAME = @v_owner OR USER_NAME_EN = @v_owner)  --20180704 KHSONG owner조회조건수정
										--,owner					= @v_owner
										,application			= @v_application
										,route					= @v_route
										--20180601 khsong 소형관련 신규 컬럼추가
										,last_updated_by		= @v_created_by
										,last_update_date		= sysdatetime()
										,attribute1				= @v_attribute1
										,attribute2				= @v_attribute2
										,attribute4				= @v_attribute4  -- 20180727
										,attribute6				= @v_attribute6  -- 20181031
										,edi_lt					= @v_edi_lt		 -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가

										-- 20190402 KHSONG 소형 Report 컬럼 추가 
										,REPORT_GROUP1			= @v_report_group1
										,REPORT_GROUP2			= @v_report_group2
										,REPORT_GROUP3			= @v_report_group3
										,REPORT_GROUP4			= @v_report_group4
										--,REPORT_GROUP5			= @v_report_group5
										,REPORT_GROUP6			= @v_report_group6
										,REPORT_GROUP7			= @v_report_group7
										,REPORT_GROUP8			= @v_report_group8
										,SCP_VMI_LT				= @v_vmi_lt
										,ATTRIBUTE9				= CASE WHEN A.division_id = '40' 
																	THEN @v_production_process --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
																  ELSE @v_cell_name END --[PJ20200138] Cell Name 추가							
										,SALES_COMPANY			= @v_sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
										,SALES_PLANT			= @v_sales_plant
										,PARTIAL_PLAN_YN		= @v_partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
										,ATTRIBUTE8				= @v_kwh			-- [C20210525-000374] 셀용량 및 팩 당 용량 추가
										,ATTRIBUTE10			= @v_celltypeCD		-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
										,CONSENSUS_MKT          = @v_consensus_Mkt          
										,CONSENSUS_ESS          = @v_consensus_Ess          
										,CONSENSUS_SCM          = @v_consensus_Scm          
										,INVENTORY_DAY          = @v_inventory_Day          
										,CHANGE_REASON          = @v_change_Reason          
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
										,ALT_SIM_YN				= @v_alt_sim_yn		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
										,DESCRIPTION			= @v_description	--20230817 설명(DESCRIPTION) 컬럼 추가
										,PROJECT_INFO			= @v_project_info	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
										,PROJECT_S_OP_REPORT	= @v_project_s_op_report	--[E20240904-001037]_DM > Master > Sales Site Project Model 
										,CELL_S_OP_REPORT		= @v_cell_s_op_report		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	
										,PRJ_OWNR_ID			= @v_prj_ownr_id			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
										,CRGE_ORG_NM            = @v_crge_org_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
										,CUST_ENG_NM            = @v_cust_eng_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
							WHEN NOT MATCHED THEN
						
								 INSERT (  
											division_id		
										   ,project_code							   
										   ,scm_site_id
										   ,item_id
										   ,currency
										   ,cell_per_car
										   ,cell_per_module
										   ,liability_period
										   ,sales_plan_adjust_yn
										   ,item_hrcy_id
										   ,bpms_exist
										   ,valid_yn
										   --20180601 khsong 소형관련 신규 컬럼추가
										   ,cust_group
										   ,cust_group_dtl
										   ,owner
										   ,application
										   ,route
										   --20180601 khsong 소형관련 신규 컬럼추가
										   ,created_by
										   ,creation_date
										   ,last_updated_by
										   ,last_update_date
										   ,attribute1
										   ,attribute2
										   ,attribute4  -- 20180727
										   ,attribute6  -- 20181031
										   ,edi_lt		-- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가

											-- 20190402 KHSONG 소형 Report 컬럼 추가 
										   ,REPORT_GROUP1
										   ,REPORT_GROUP2
										   ,REPORT_GROUP3
										   ,REPORT_GROUP4
										   --,REPORT_GROUP5
										   ,REPORT_GROUP6
										   ,REPORT_GROUP7
										   ,REPORT_GROUP8
										   ,SCP_VMI_LT
										   ,ATTRIBUTE9 --[PJ20200138] Cell Name 추가
											,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
											,sales_plant
											,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
											,ATTRIBUTE8		-- [C20210525-000374] 셀용량 및 팩 당 용량 추가
											,ATTRIBUTE10	-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
											,CONSENSUS_MKT        
											,CONSENSUS_ESS        
											,CONSENSUS_SCM        
											,INVENTORY_DAY        
											,CHANGE_REASON        
											--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
											,ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
											,PROJECT_INFO	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model 
											,CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   
											,PRJ_OWNR_ID			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
											,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
											,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
										)
								 VALUES (   
											@v_division_id
										   ,@v_project_code
										   ,@v_scm_site_id
										   ,@v_item_id
										   ,@v_currency
										   ,@v_cell_per_car
										   ,@v_cell_per_module
										   ,@v_liability_period
										   ,@v_sales_plan_adjust_yn
										   ,@v_item_hrcy_id
										   ,@v_bpms_exist
										   ,@v_valid_yn
										   --20180601 khsong 소형관련 신규 컬럼추가
										   ,@v_cust_group
										   ,@v_cust_group_dtl
										   ,@v_owner--(SELECT MAX(USER_ID) FROM SCM_MST_SSO_USER_INFO WITH(NOLOCK) WHERE USER_ID = @v_owner OR USER_NAME = @v_owner OR USER_NAME_EN = @v_owner)  --20180704 KHSONG owner조회조건수정
										    --,@v_owner
										   ,@v_application
										   ,@v_route
										   --20180601 khsong 소형관련 신규 컬럼추가
										   ,@v_created_by
										   ,sysdatetime()
										   ,@v_created_by
										   ,sysdatetime()
										   ,@v_attribute1
										   ,@v_attribute2
										   ,@v_attribute4  -- 20180727
										   ,@v_attribute6  -- 20181031
										   ,@v_edi_lt	   -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가

											-- 20190402 KHSONG 소형 Report 컬럼 추가 
											,@v_report_group1
											,@v_report_group2
											,@v_report_group3
											,@v_report_group4
											--,@v_report_group5
											,@v_report_group6
											,@v_report_group7
											,@v_report_group8
											,@v_vmi_lt
											,CASE WHEN @v_division_id = '40' 
												THEN @v_production_process --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
											 ELSE @v_cell_name END --[PJ20200138] Cell Name 추가
											,@v_sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
											,@v_sales_plant
											,@v_partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
											,@v_kwh				-- [C20210525-000374] 셀용량 및 팩 당 용량 추가
											,@v_celltypeCD		-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
										    ,@v_consensus_Mkt          
										    ,@v_consensus_Ess          
										    ,@v_consensus_Scm          
										    ,@v_inventory_Day          
										    ,@v_change_Reason          
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
										    ,@v_alt_sim_yn	--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
											,@v_description	--20230817 설명(DESCRIPTION) 컬럼 추가
											,@v_project_info --20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
											,@v_project_s_op_report --[E20240904-001037]_DM > Master > Sales Site Project Model
											,@v_cell_s_op_report	--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건 
											,@v_prj_ownr_id		--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
											,@v_crge_org_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
											,@v_cust_eng_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
										);

						END

						-- 2020.3.17 division_id, scm_site_ite, item_id 기준으로 동일한 모델에는 동일한 SCP_VMI_LT 를 적용한다. ( Project Code 는 무시 )-----------------------------
						UPDATE SCM_MST_SITE_ITEM
						SET SCP_VMI_LT = ISNULL(@V_VMI_LT,0)
						WHERE DIVISION_ID = @v_division_id
							AND SCM_SITE_ID = @v_scm_site_id
							AND ITEM_ID = @v_item_id
						-- 2020.3.17 SCP_VMI_LT update 끝	----------------------------------------------------------------------------------------------------------------------

					

				END
				

			FETCH NEXT FROM CURSOR_m1_MST INTO
										 @v_active_flag			
										,@v_division_id			
										,@v_project_code		
										,@v_scm_site_id			
										,@v_item_id				
										,@v_currency			
										,@v_cell_per_car	 	
										,@v_cell_per_module		
										,@v_liability_period	
										,@v_sales_plan_adjust_yn
										,@v_item_hrcy_id		
										,@v_bpms_exist			
										,@v_valid_yn		 	
										,@v_cust_group			
										,@v_cust_group_dtl		
										,@v_owner				
										,@v_application			
										,@v_route				
										,@v_created_by			
										,@v_LAST_UPDATED_BY		
										,@v_LAST_UPDATE_DATE	
										,@v_attribute1			
										,@v_attribute2			
										,@v_attribute4			
										,@v_attribute6			
										,@v_edi_lt				
										,@v_report_group1		
										,@v_report_group2		
										,@v_report_group3		
										,@v_report_group4		
										,@v_report_group6		
										,@v_report_group7		
										,@v_report_group8		
										,@v_vmi_lt
										,@v_cell_name --[PJ20200138] Cell Name 추가
										,@v_sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
										,@v_sales_plant
										,@v_partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
										,@v_kwh				-- [C20210525-000374] 셀용량 및 팩 당 용량 추가
										,@v_celltypeCD		-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
										,@v_production_process --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
										,@v_consensus_Mkt          
										,@v_consensus_Ess          
										,@v_consensus_Scm          
										,@v_inventory_Day          
										,@v_change_Reason          
										--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
										,@v_alt_sim_yn	--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
										,@v_description	--20230817 설명(DESCRIPTION) 컬럼 추가
										,@v_project_info --20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
										,@v_project_s_op_report --[E20240904-001037]_DM > Master > Sales Site Project Model 
										,@v_cell_s_op_report	--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건 
										,@v_prj_ownr_id		--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
										,@v_crge_org_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
										,@v_cust_eng_nm -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 

		---------------------------------------------------------------------------------------- 
		END;
		---------------------------------------------------------------------------------------- WHILE_m1 LOOP END

		CLOSE CURSOR_m1_MST;  
		DEALLOCATE CURSOR_m1_MST;

		-----------------------------------------------------------------------------------------------------
		END
		-----------------------------------------------------------------------------------------------------
				
		--------------------------------------------------------------------------------------------------------------
		-- history insert (begin)
		--------------------------------------------------------------------------------------------------------------
	
		

		INSERT	INTO  [dbo].[SCM_MST_SITE_ITEM_H]
				(									   
					DIVISION_ID ,HISTORY_SEQ, PROJECT_CODE ,SCM_SITE_ID 
					,ITEM_ID ,CURRENCY ,CELL_PER_CAR, CELL_PER_MODULE, LIABILITY_PERIOD ,SALES_PLAN_ADJUST_YN ,ITEM_HRCY_ID ,VALID_YN ,BPMS_EXIST
					,cust_group,cust_group_dtl,owner,application,route  -- 20180618  KHSONG 소형관련 신규컬럼 5개 추가
					,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE4, ATTRIBUTE6 -- 20180727 KHSONG attribute4 추가
					,edi_lt  -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
					,report_group1,report_group2,report_group3,report_group4
					-- ,report_group5								-- 20191021 kyh report_group4, 5 통합 
					,report_group6,report_group7,report_group8  -- 20190408 KHSONG 신규컬럼추가
					--,os_corp,contribution_type
					,SCP_VMI_LT
					,ATTRIBUTE9 --[PJ20200138] Cell Name 추가
					,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
					,sales_plant
					,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
					,ATTRIBUTE8		-- [C20210525-000374] 셀용량 및 팩 당 용량 추가
					,ATTRIBUTE10	-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
					,CONSENSUS_MKT          
					,CONSENSUS_ESS          
					,CONSENSUS_SCM          
					,INVENTORY_DAY          
					,CHANGE_REASON          
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
					,ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
					,DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
					,PROJECT_INFO	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
					,ATTRIBUTE3
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
					,PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model 
					,CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   
					,PRJ_OWNR_ID			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
					,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
					,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
				)		   
				select 
					 DIVISION_ID
					,NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_H  -- History Seqno
					,PROJECT_CODE ,SCM_SITE_ID 
					,ITEM_ID ,CURRENCY ,CELL_PER_CAR, CELL_PER_MODULE, LIABILITY_PERIOD ,SALES_PLAN_ADJUST_YN ,ITEM_HRCY_ID ,VALID_YN ,BPMS_EXIST
					,cust_group,cust_group_dtl,owner,application,route  -- 20180618  KHSONG 소형관련 신규컬럼 5개 추가
					,CREATED_BY,SYSDATETIME(),CREATED_BY,SYSDATETIME(),ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE4, ATTRIBUTE6
					,edi_lt,report_group1,report_group2,report_group3,report_group4
					,report_group6,report_group7,report_group8
					,vmi_lt
					,CASE WHEN division_id = '40' 
						THEN production_process  --[C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
					 ELSE cell_name END --[PJ20200138] Cell Name 추가
					,sales_company --[C20200513-000276] Sales Company, Sales Plant 추가 
					,sales_plant
					,partial_plan_yn --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
					,kwh
					,celltypeCD		-- [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 START
					,consensus_Mkt          
					,consensus_Ess          
					,consensus_Scm          
					,inventory_Day          
					,change_Reason          
					--[E20230619-000273]ESS 법인향 Inventory Days 모델별 설정개선 END
					,ALT_SIM_YN		--20230814 대체/유사모델 여부(ALT_SIM_YN) 컬럼 추가
					,DESCRIPTION	--20230817 설명(DESCRIPTION) 컬럼 추가
					,PROJECT_INFO	--20230821 PROJECT_INF0(소형프로젝트) 컬럼 추가
					,CASE WHEN ISNULL(Change_String, '') != ISNULL(CONSENSUS_MKT, '') + ISNULL(CONSENSUS_ESS, '')  + ISNULL(CONSENSUS_SCM, '') + CONVERT(NVARCHAR, INVENTORY_DAY) + ISNULL(CHANGE_REASON, '') THEN 'Y' END
					--,CASE WHEN @s_modify != (consensus_Mkt +  consensus_Ess + consensus_Scm + CONVERT(NVARCHAR,inventory_Day) + change_Reason)  THEN 'Y' END 
					,PROJECT_S_OP_REPORT	--[E20240904-001037]_DM > Master > Sales Site Project Model 
					,CELL_S_OP_REPORT		--[E20241028-000049]_[공급SCM PI팀] SCM Sales Site Project Model Master 내 소형사업부 S&OP Report 활용을 위한 신규 컬럼 개발 요청의 건   	 					
					,PRJ_OWNR_ID			--[E20241120-000817]_82사업부 SSPM 수정 요청 개발 요청의 건
					,CRGE_ORG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
					,CUST_ENG_NM -- [PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선(으로 인한 CRGE_ORG_NM,CUST_ENG_NM 2개 컬럼 추가) 
				FROM #results_MST WITH(NOLOCK) WHERE 1=1

--SELECT CASE WHEN ISNULL(Change_String, '') != ISNULL(CONSENSUS_MKT, '') + ISNULL(CONSENSUS_ESS, '')  + ISNULL(CONSENSUS_SCM, '') + CONVERT(NVARCHAR, INVENTORY_DAY) + ISNULL(CHANGE_REASON, '') THEN 'Y' END
--FROM #results_MST WITH(NOLOCK) WHERE 1=1
		--------------------------------------------------------------------------------------------------------------
		-- history insert (end)
		--------------------------------------------------------------------------------------------------------------


		IF (SELECT COUNT(1) FROM #results_MST WHERE DIVISION_ID LIKE '81%')
			> 0
			--------------------------------------------------------------------------------------------------------------
			BEGIN                  --20191118 KHSONG [CSR:C20191031-000137] SEQUENCE별로 TEMP 테이블에 데이터 입력 (BEGIN)
			--------------------------------------------------------------------------------------------------------------
				INSERT INTO #TEMP_EDI_LT
				(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,EDI_LT)
				SELECT 	 division_id
						,project_code
						,scm_site_id
						,item_id
						,edi_lt
					 FROM  #results_MST WITH(NOLOCK) WHERE DIVISION_ID LIKE '81%'
					 
				-- [PJ20228272] NERP 대응 - 81 사업부 신규 등록 I/F(PR_DM_XIF_ERP_SITE_ITEM_S) 
				EXEC PR_DM_XIF_ERP_SITE_ITEM_S;

			--------------------------------------------------------------------------------------------------------------
			END                    --20191118 KHSONG [CSR:C20191031-000137] SEQUENCE별로 TEMP 테이블에 데이터 입력 (END)
			--------------------------------------------------------------------------------------------------------------
		
		-----------------------------------------------------------------------------------------------------------------------
		BEGIN        --20191118 KHSONG [CSR:C20191031-000137] TEMP 테이블에서 EDI_LT 값이 변경된 데이터 찾아서 업데이트(BEGIN)
		-----------------------------------------------------------------------------------------------------------------------

			IF OBJECT_ID (N'tempdb..#TEMP_EDI_TRGT', N'U') IS NOT NULL 
				DROP TABLE #TEMP_EDI_TRGT

			------------------ 변경대상이 존재할경우 기준정보 저장
			SELECT DISTINCT A.DIVISION_ID,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,A.DOM_EXP,A.FCST_TYPE,A.INCOTERMS,A.MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,B.EDI_LT 
				INTO #TEMP_EDI_TRGT
				FROM  DM_PLN_MKT_FCST A WITH(NOLOCK) 
					INNER JOIN #TEMP_EDI_LT B WITH(NOLOCK)
					ON (A.division_id	=	B.division_id
					AND A.project_code	=	B.project_code
					AND A.scm_site_id	=	B.scm_site_id
					AND A.item_id		=	B.item_id
					AND A.ATTRIBUTE8	<>	B.edi_lt
						)
				WHERE 1=1
				AND A.DIVISION_ID LIKE '81%'
				--AND A.MEASURE in ('CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement')
				AND A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')
				AND A.YYYYMMDD >= @v_0week_monday  -- 당주 월요일 이후 데이터

			------------------
			IF
			------------------
				(SELECT COUNT(1) FROM  #TEMP_EDI_TRGT WITH(NOLOCK) ) > 0  -- EDI_LT 값이 기존과 달라진 기준정보가 존재하는경우
				------------------
				BEGIN
				------------------

					SELECT 
						  A.DIVISION_ID,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,A.DOM_EXP,A.FCST_TYPE,A.INCOTERMS,A.MEASURE,A.PLANT_SITE_ID
						-- Original YYYYMMDD 값에서 재계산
						 ,A.YYYYMMDD AS YYYYMMDD_ASIS
						 ,CONVERT(CHAR(8), dbo.FN_NEXT_WORK_DAY(ISNULL(MAX(ATTRIBUTE7),MAX(A.YYYYMMDD)), MAX(B.EDI_LT) * -1), 112) AS YYYYMMDD_TOBE -- 날짜값과 EDI_LT 값을 음수로 입력함
						 ,MAX(A.QTY) AS QTY
						 ,MAX(A.CREATED_BY) AS CREATED_BY
						 ,MAX(A.CREATION_DATE) AS CREATION_DATE
						 ,@v_created_by AS LAST_UPDATED_BY -- UPDATE 수행자 기록
						 ,GETDATE() AS LAST_UPDATE_DATE
						 ,MAX(A.ATTRIBUTE1) AS ATTRIBUTE1
						 ,MAX(A.ATTRIBUTE2)	AS ATTRIBUTE2
						 ,MAX(A.ATTRIBUTE3)	AS ATTRIBUTE3
						 ,MAX(A.ATTRIBUTE4)	AS ATTRIBUTE4
						 ,MAX(A.ATTRIBUTE5)	AS ATTRIBUTE5
						 ,MAX(A.ATTRIBUTE6)	AS ATTRIBUTE6
						 ,MAX(A.ATTRIBUTE7)	AS ATTRIBUTE7
						 ,MAX(B.EDI_LT) AS ATTRIBUTE8 -- EDI_LT 값을 변경된 값으로 업데이트함
						 --,'Edi Leadtime User Update' AS ATTRIBUTE9
						 ,MAX(A.ATTRIBUTE9) AS ATTRIBUTE9
						 ,MAX(A.ATTRIBUTE10) AS ATTRIBUTE10
					INTO #TEMP_EDI_FCST_TABLE
					FROM DM_PLN_MKT_FCST A WITH(NOLOCK)
						INNER JOIN #TEMP_EDI_TRGT B WITH(NOLOCK)
							ON (A.DIVISION_ID			=   B.DIVISION_ID
							AND A.PROJECT_CODE			=   B.PROJECT_CODE
							AND A.SCM_SITE_ID			=   B.SCM_SITE_ID
							AND A.ITEM_ID				=   B.ITEM_ID
							)
					  where 1=1
						--AND A.MEASURE in ('CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement')
						AND A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')
						AND A.YYYYMMDD >= @v_0week_monday  -- 당주 월요일 이후 데이터
					GROUP BY  A.DIVISION_ID,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,A.DOM_EXP,A.FCST_TYPE,A.INCOTERMS,A.MEASURE,A.PLANT_SITE_ID,A.YYYYMMDD,B.EDI_LT

					-- 111 확인용
					--SELECT * FROM #TEMP_EDI_FCST_TABLE

					-- PK 오류발생하므로 기존데이터 삭제
					--(1) AS-IS 날짜를 삭제
					DELETE FROM DM_PLN_MKT_FCST
					  where 1=1
					  and exists (select division_id from #TEMP_EDI_FCST_TABLE C WITH(NOLOCK) WHERE 1=1
									AND DM_PLN_MKT_FCST.DIVISION_ID			=   C.DIVISION_ID  
									AND DM_PLN_MKT_FCST.PROJECT_CODE		=   C.PROJECT_CODE  
									AND DM_PLN_MKT_FCST.SCM_SITE_ID			=   C.SCM_SITE_ID  
									AND DM_PLN_MKT_FCST.ITEM_ID				=   C.ITEM_ID  
									AND DM_PLN_MKT_FCST.DOM_EXP				=   C.DOM_EXP  
									AND DM_PLN_MKT_FCST.FCST_TYPE			=   C.FCST_TYPE  
									AND DM_PLN_MKT_FCST.INCOTERMS			=   C.INCOTERMS  
									AND DM_PLN_MKT_FCST.PLANT_SITE_ID		=   C.PLANT_SITE_ID  
									AND DM_PLN_MKT_FCST.YYYYMMDD			=   C.YYYYMMDD_ASIS  -- AS-IS 날짜
									)
						--AND MEASURE in ('CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement')
						AND MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')

					--(2) TO-BE 날짜를 삭제
					DELETE FROM DM_PLN_MKT_FCST
					  where 1=1
					  and exists (select division_id from #TEMP_EDI_FCST_TABLE C WITH(NOLOCK) WHERE 1=1
									AND DM_PLN_MKT_FCST.DIVISION_ID			=   C.DIVISION_ID  
									AND DM_PLN_MKT_FCST.PROJECT_CODE		=   C.PROJECT_CODE  
									AND DM_PLN_MKT_FCST.SCM_SITE_ID			=   C.SCM_SITE_ID  
									AND DM_PLN_MKT_FCST.ITEM_ID				=   C.ITEM_ID  
									AND DM_PLN_MKT_FCST.DOM_EXP				=   C.DOM_EXP  
									AND DM_PLN_MKT_FCST.FCST_TYPE			=   C.FCST_TYPE  
									AND DM_PLN_MKT_FCST.INCOTERMS			=   C.INCOTERMS  
									AND DM_PLN_MKT_FCST.PLANT_SITE_ID		=   C.PLANT_SITE_ID  
									AND DM_PLN_MKT_FCST.YYYYMMDD			=   C.YYYYMMDD_TOBE  -- TO-BE 날짜
									)
						--AND MEASURE in ('CUST_FCST_EDI','Immidiate','Planning_Forecast','Commercial_Agreement')
						AND MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')

					-- MKT_FCST DATA Insert
					INSERT INTO dbo.DM_PLN_MKT_FCST
					(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10)
					SELECT  DIVISION_ID
							,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
							,YYYYMMDD_TOBE  -- TO-BE 날짜
							,SUM(QTY) as qty
							,max(CREATED_BY) as CREATED_BY,max(CREATION_DATE) as CREATION_DATE,max(LAST_UPDATED_BY) as LAST_UPDATED_BY,max(LAST_UPDATE_DATE) as LAST_UPDATE_DATE
							,MAX(ATTRIBUTE1),MAX(ATTRIBUTE2),MAX(ATTRIBUTE3),MAX(ATTRIBUTE4),MAX(ATTRIBUTE5),MAX(ATTRIBUTE6),MAX(ATTRIBUTE7),MAX(ATTRIBUTE8),MAX(ATTRIBUTE9),MAX(ATTRIBUTE10)
						FROM #TEMP_EDI_FCST_TABLE WITH(NOLOCK) WHERE 1=1
						GROUP BY DIVISION_ID  -- GROUP이 필요함, 토,일요일 데이터가 평일로 편성되는경우 PK중복오류 발생함
							,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
							,YYYYMMDD_TOBE

					-- History Insert
					INSERT INTO dbo.DM_PLN_MKT_FCST_H
					(DIVISION_ID,HISTORY_SEQ,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10)
					SELECT  DIVISION_ID
							,NEXT VALUE FOR SEQ1_DM_PLN_MKT_FCST_H -- History Seqno
							,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
							,YYYYMMDD_TOBE  -- TO-BE 날짜
							,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
						FROM #TEMP_EDI_FCST_TABLE WITH(NOLOCK) WHERE 1=1

				------------------
				END
				------------------

		-----------------------------------------------------------------------------------------------------------------------
		END        --20191118 KHSONG [CSR:C20191031-000137] TEMP 테이블에서 EDI_LT 값이 변경된 데이터 찾아서 업데이트(END)
		-----------------------------------------------------------------------------------------------------------------------

		COMMIT TRAN SALES_SITE_MODEL_PRODUCTION ;	

		END TRY
				
	BEGIN CATCH
	    		
		ROLLBACK TRAN SALES_SITE_MODEL_PRODUCTION ;	
				
		-- ERROR LOG
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description2 = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description2, @d_event_date;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		
    END CATCH;


	IF  @v_log_type not in ('INVALID','ERROR')
		BEGIN
			-- 종료 LOG
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description2, @d_event_date;
		END

	-- INVALID 인경우 ROLLBACK 처리
	ERR_RTN:
		IF  @v_log_type = 'INVALID'
			BEGIN
				SELECT 'INVALID'
				ROLLBACK TRAN SALES_SITE_MODEL_PRODUCTION;	
				-- 종료 LOG
				SET @v_log_message = '########## END of procedure ##########';
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description2, @d_event_date;
				-- [C20210323-000363]
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'END', @n_log_count, @v_log_message, @v_description2, @d_event_date;
			END;

  END;	
