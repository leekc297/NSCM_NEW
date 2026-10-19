
/* ==========================================================================================================================================================
프로그램ID	: UP_FX_GetCommonDataList
업  무  명	: 공통 코드성 조회
프로그램명	: 공통 코드성 조회
최초작성일	: 2017.10.20
최종작성일  : 2024.01.16
개  발  자	: SJSHINf
입  력  값	:
출  력  값	:
==========================================================================================================================================================
 Date         In Charge      Description
==========================================================================================================================================================
 2017/10/20   SJSHINf               Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 2018/04/04   kyg                   Code Period_ 로 되어 있는 쿼리 수정(GETDATE() -> dbo.FN_MULTY_TIME(@TimeZone)
                                    파라미터 @TimeZone 추가
 2018/04/13   PJS                   LINE_BY_OPERATION 명칭 코드+명칭으로 출력되도록 수정
 2018/04/16   PJS                   PlanDateShip 추가
 2018/04/18   ygkim                 PlantAll 추가
 2018/04/24   PJS                   WATERFALL VERSION 추가
 2018/04/25   ygkim                 Company 추가
 2018/04/26   ygkim                 TransMode 추가
 2018/05/10   ygkim                 Plant 쿼리 수정
 2018/05/23   ygkim                 LookupCommon3 추가
 2018/05/29   jye                   TeambyDivisionAuth 에 복수 팀 권한 추가
 2018/05/29   jye                   EndCustomerByDivisionDeptAuth 복수 팀 권한 추가
 2018/05/29   jye                   SiteByEndCustomerAuth
 2018/06/12   JYE                   VALID_YN = 'Y' 추가, SiteByEndCustomer 분기 추가
 2018/06/14   PJS                   PlanTypeShip  PlanTypeShip LOOKUP COMBO BOX
 2018/06/14   PJS                   PlanSeqShip  PlanSeq LOOKUP COMBO BOX
 2018/06/19   JYE                   TeambyDivisionAuth, TeambyDivision, EndCustomerByDivision40 에서 디비전 분기 추가
 2018/06/19   JYE                   DeptID. 대상 추가
 2018/07/04   KYH                   PlantByDivisionOperItem 추가
 2018/07/05   ygkim                 MyDivision 조회조건 추가(Division 'EE' 제외)
 2018/07/07   JYE                   TeambyDivision2 추가
 2018/07/20   JYE                   DM_Biz_Type 추가
 2018/08/01   JYE                   SiteByEndCustomer40  수정
 2018/08/16   JYE                   EndCustomerByDivision40 > 멀티 오너 수정
 2018/08/22   JYE                   SiteByEndCustomer_InnerCode 추가
 2018/09/04   son                   young suk   SiteByEndCustomer_InnerCode 수정 법인코드 lookup 테이블 조회
 2018/09/07   son                   young suk   COMPANY_ID_INTERNAL_TXN 추가
 2018/10/04   son                   young suk   MktFcstEditMeasure 수정 - Division '81'일때 Measure 'VMI_In_Plan', 'VMI_In_Req' 추가
 2018/10/15   hwyoon                CycleSub3, CycleSub2_v2 추가
 2018/10/23   JYE                   EOL_ReasonCode, EOL_ReasonStatus 추가
 2018/12/21   hwyoon                PlantByDivisionOperationItem(T/T 등록여부 체크 시 해당 라인 활성화 여부 포함하여 체크)
 2018/01/08   JYE                   SiteByEndCustomer 쿼리
 2019/01/09   JYE                   TeambyDivisionAuth 쿼리
 2019/01/15   hwyoon                TransMode valid Y 추가
 2019/02/18   JYE                   DMF0041_MDF_Team. MDF simulator > 담당 추가
 2019/02/21   JYE                   DMF0041_MDF_Team. MDF simulator > MEASURE 추가
 2019/03/18   mchtej                Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
 2019/03/22   mchtej                OWMS_STOCK_STATUS(Inventory_Status) 추가
 2019/04/03   JYE                   DMF0005 신규 칼럼 추가
 2019/04/08   hwyoon                [CSR ID:3966780] Tact Time 입력 시 Plant, Line 유효성 체크 로직 개선 - LineByOperation 수정
 2019/04/08   hwyoon                [PJ20189106] 전지.GSCM 고도화 이행- 소형 추가
 2019/04/17   JYE                   DMF0041_MDF_Measure 수정, DMF0042_BP_Measure 추가
 2019/04/24   JYE                   DMF0041_MDF_Currency 추가
 2019/05/15   JYE                   DMF0044_MDF_NAME 추가
 2019/05/15   JYE                   DMF0044_MDF_PRODUCT_GROUP 추가
 2019/05/15   JYE                   CHANGE_REASON_CODE 추가
 2019/05/22   JYE                   DMF0044_MDF_ENDCUST_REPORT, DMF0044_MDF_CUST_REPORT 추가
 2019/05/23   JYE                   DMF0044_MDF_Team 추가
 2019/05/23   mcthej                SSP0013, SSP0015 change_reason_code_all 추가
 2019/05/24   JYE                   DMF0044_ETC_SALE_RESULT_TYPE_40, DMF0044_DEPARTMENT_TEAM 추가
 2019/06/03   JYE                   DMF0044_MDF_DEPARTMENT 추가
 2019/06/09   JYE                   TeambyDivision 정렬 수정
 2019/06/13   JYE                   OS_CORP, CONTRIBUTION_TYPE 추가
 2019/06/24   JYE                   DMF0044_MDF_DEPARTMENT > 정렬 추가
 2019/06/26   JYE                   DMF0041_MDF_Team 원복
 2019/06/28   JYE                   DMF0043_UPPER_DEPT, DMF0043_COMPANT_ID, DMF0043_END_CUST_REPORT, DMF0043_CUST_GROUP_DTL 추가
 2019/08/08   JYE                   FCST_TYPE_NOT_ETC2 추가
 2019/08/12   JYE                   MktFcstEditMeasure > 82사업부 추가
 2019/08/19   JYE                   DMF0044_DEPARTMENT_TEAM > MDF 제거
 2019/09/11   JYE                   EndCustomerByDivision40 수정
 2019/09/24   KYH                   TeambyDivision 수정( owner 에 여러명 들어간 경우 반영 )
 2019/10/21   JYE                   CSR ID:4103445. 40사업부 칼럼 통합. REPORT_GROUP4 + REPORT_GROUP5 = REPORT_GROUP4
 2019/10/28   KimYH                 TeamByDivision 등 SCM_MST_SSO_DEPT_INFO.DEPT_NAME_KO 를 사용하는 부분 언어따라가도록 변경작업중
 2019/11/18   KHSONG                [CSR ID:4098705] GSCM(DM)에서 Incoterms 조건에 따라 Customer EDI의 DP 반영 요청의 건
 2019/12/02   KHSONG                DIVISION 조건 ADDED
 2020/01/19   HWI1993               DMF0044_MDF_MEASURE 조건 추가
 2020/01/19   HWI1993               DMF0044_MDF_MEASURE_ETC 추가( ETC데이터에서만 사용)
 2020/02/03   hwyoon                [C20200116-000114] ESS 외주 Packer Line 계획 수립 - LineByOperationOsp 추가 (Packer Line)
 2020/02/04   hwi1993               DM_COMPANY 추가
 2020/02/10   hwyoon                [C20200116-000114] ESS 외주 Packer Line 계획 수립 - PlantByDivisionOperationItem 변경 (Packer Line)
 2020/02/19   HWI1993               DMF0044_DEPARTMENT_TEAM2 쿼리 수정 ( 생성일자기준 최신정보만 받아오도록 )
 2020/02/27   P.C.I                 [C20200221-000128] DMF0005 End Custoer(Report), DMF0005 Sold To Custoer(Report) 추가
 2020/03/06   KHSONG                MktFcstEditMeasure40 부분을 주석처리하고 하나로 통합/TMM Measure관련 추가
 2020/03/09   hwi1993               DMF0044_DEPARTMENT_TEAM2 쿼리 수정 ( lookup 사용하도록 변경 )
 2020/03/13   KHSONG                C20200103-000586 권한그룹을 LOOKUP관리
 2020/04/03   HWI1993               DMF0044_MDF_DEPARTMENT 에 DIVISION 조건 추가
 2020/04/08   HWI1993               DM_LOOKUP_DIV 추가
 2020/04/27   hwi1993               DMF0044_DEPARTMENT_TEAM2 에서 Segment3 사용안하도록 변경
 2020/04/27   KHSONG                C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
 2020/04/28   KHSONG                PM TEAM MAPPING 인경우 본인 팀이 선택이 안되는 오류로 쿼리 수정
 2020/05/14   P.C.I                 [C20200513-000276] Sales Company, Sales Plant 추가
 2020/05/21   khj79                 [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - BuildingForShipMasterElec.COMPANY_ID 추가
 2020/05/22   P.C.I                 [C20200521-000207] SalesCompany, SalesPlant 에 Division, Project, Item 조건 추가
 2020/05/29   HWI1993               SALESCOMPANY, SALESPLANT 수정
 2020/06/01   P.C.I                 [C20200525-000296] Plant Site에 Division, Project, Item 조건 추가
 2020/06/09   P.C.I                 [C20200608-000328] SalesCompany, SalesPlant 콤보는 Item Master의 Company ID, Operation Group ID 기준
 2020/06/12   HWI1993               [C20200602-000030] FCST_TYPE_NOT_FREE 추가
 2020/06/23   khj79                 [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - BuildingForShipMasterElec.SCM_SITE_ID 추가
 2020/06/24   khj79                 [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - PlantCell 추가
 2020/06/24   khj79                 [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - FromSiteByAssembly 추가
 2020/06/26   P.C.I                 [C20200626-000172] SalesCompany, SalesPlant 에 Item Type is not null 조건 추가
 2020/06/26   P.C.I                 [C20200702-000136] 자동차 사업부- PlantSiteByItem은 Item Master의 Company ID, Operation Group 기준으로 조회
 2020/07/07   KIMYONGHO             [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선-   PlantByElectordeShipToSite_EE 추가
 2020/07/16   hwi1993               [C20200713-000189] [VMI-in Req] VMI Biz의 경우 VMI-in Req 입력을 통한 MKT FCST 자동산출 로직 추가
                                    - MKT_FCST_MEASURE 수정
 2020/08/19   P.C.I                 [C20200818-000264] Sales Company / Sales Plant - Project_Item Master Valid 조건 제외
 2020/08/19   P.C.I                 [C20200818-000264] Sales Company / Sales Plant - Project_Item Master Valid 조건 제외
 2020/08/20   KIMYONGHO             외주 Packert 출하 계획 개발 건 ShipToCodeByDivision, FromSiteByDivisionOspPack, SoldToCustomerByDivisionDept 추가
 2020/08/26   P.C.I                 [C20200827-000094] PlantSiteByItem - 자동차 전극(EE) 로직 추가, Project_Item Master Valid 조건 제외
 2020/07/21   khj79                 [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 SiteFP,MDMCategoryId,MDMKeyId 추가
 2020/07/21   khj79                 [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 SysLookup 추가
 2020/08/11   khj79                 [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 OperationByLine
 2020/09/10   hwi1993               [C20200909-000212] ESS Cau 사이트에서 VMI Req 메저 안나오는 현상 수정
 2020/09/17   khj79                 기초정보 UI OperationByLine 조건 추가
 2020/09/21   KIMYONGHO             SSP INCOTERMS 변경 작업
 2021/01/13   KUNI                  [C20210112-000446] 동기화된 수량 내역 보여주는 팝업 창(MKT FCST, SSP수량)
 2021/01/15   khj79                 [PJ20199555] SysLookup CODE 값 SEGMENT1 을 ATTRIBUTE1 으로 변경
 2021/03/31   khj79                 [PJ20199555] MDMCategoryId , MDMKeyId  'M11' 조건 추가
 2021/04/07   khj79                 [PJ20199555] PlanDate , PlanType , PlanSeq CAPA SIMULATION VERSION_ID 정보를 위한 VERSION_ID 추가
 2021/05/12   khj79                 [PJ20209642] 'MDMCategoryId' , 'MDMKeyId' ATTRIBUTE7(수정 여부) 조건 추가
 2021/05/18   winter1203            [C20210423-000315] MDM 기준정보 변경시 EndCustomer의 명칭이 보이도록 수정
 2021/06/25   winter1203            [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
 2021/07/15   winter1203            [C20210715-000075] Cust Group 룩업 내 Valid 참조 요청
 2021/07/21   khj79                 [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - MDMKeyId 수정
 2021/08/13   hwi1993               속도개선 테스트 ( SALESCOMPANY, SALESPLANT )
 2021/08/24   rosia27               [C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
 2021/10/22   hwi1993               [] Division 정렬순서 변경-MyDivision
 2022/03/31   rosia27               [과제PJ20216891R]GM_JV
 2022/04/29   chaan         V1.2.0  MyDivision EE_GM -> EE_UC 로 변경
 2022/05/16   jahn1501              콤보박스 날짜+주차 조회 추가
 2022/06/09   kdw2819               business plan waterfall measure 추가
 2022/06/14   ROSIA27               CELL_PROD_SITE 추가
 2022/09/01   ROSIA27               MktFcstEditMeasure에 AS_YN 추가
 2022/09/28   jahn1501              PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - DATE_WEEKLY => no plan 적용
 2022/10/20   jahn1501              PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - CELL_GROUP 추가
 2022/10/25   jahn1501              PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - SEQ_NUMBER 추가
 2022/11/22   jahn1501              PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - DIVISION_EE 추가
 2022/11/22   jahn1501              PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - COMPANY_EE 추가
 2023/01/25   jahn1501              PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ALL_Y_TYPE 추가 ('Y','NULL') Combobox
 2023/02/20   jahn1501              PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - FINISHED PRODUCT TYPE 추가 ('Y','N','Both')
 2023/03/30   chaan                 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - V1.2.1    - ALL_V_TYPE ('V', '')
 2023/04/13   chaan                 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - V1.2.2    - ESS_CATEGORY 추가
 2023/05/02   chaan                 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - V1.2.3    - GLOBAL_PSI_ELEC_DATE 추가
 2023/05/03   kdmcc14               [EDI과제]
 2023/07/20   chkim.68              MyDivision 상에 EE Division 제외 (권순지 책임 요청)
 2023/08/21   jssbae                PROJECT_INFO(소형프로젝트 추가)
 2023/12/07   kcw3408               [개발요청] 수요분석시스템_4_고객수요 Measure 통합(@CODE = 'Measure' 수정)
 2024/01/16   chaan         V1.2.1  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선용 쿼리 분리
 2024/01/16   chaan         V1.2.2  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - PlantSiteByDivisionOSP 누락 수정
 2024/11/26	  JSSBAE				[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정	
 2024.06.25	  P.C.I			        [PJ20228272] NERP 대응 - INCOTERMS Valid 추가
 2025/07/04	  kjiyoon				[PJ2025-50188] 고도화 - 월수량 일별로 나누기 반영
 2025/07/04	  kjiyoon				[PJ2025-50188] 고도화 - Common 도 Lookup 으로 가져오도록 수정
 2020/08/21	  JSSBAE				[E20250821-001228]_SSPM Sales Company, Sales Plant 로직 수정    
 2025/09/23   chkim.68              [NERP]COMPANY 예외적용 (IT20250117A)
 2025/09/30	 JSSBAE					[E20250919-001699]_Incoterms 데이터 처리 VALID 처리
 2025/11/28	 JSSBAE					[E20251126-001120]_Currency Code 관리 개선 (하드코딩 → Lookup 관리)
 2026/02/19  JSSBAE					[E20260211-001049]_82사업부 MKT FCST 입력 시 프로젝트 코드 입력 불가
 2026/02/20	 JSSBAE					[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선
 2026/04/02	 YMH					E20260316-000026 HQ05-W PLANT 계획 수립위한 ERP 재고 SLOC 추가 요청 - 다른 플랜트에서 SLOC 참고할수 있게 처리
========================================================================================================================================================== */

/********************************************************************************

		수정, 설계시 해당 주석을 If문 위에 붙여 주시면 감사하겠습니다.


		작성 예시 :
		/*===============================================
		용		 도:  DIVISION 변경시 SITE 조회
		사 용 화 면:  DM0001_DM_MST_SITE		   -	MAIN SPREAD의 SITE 컬럼
					  DM0004_DM_MST_SITE_CUSTOMER  -	SUB SPREAD의 SITE 컬럼
		변       수:  @PARAM1 = DIVISION
		최 초 작 성:  2018. 02. 07
		개  발  자 :  진 준 희
		최 종 작 성:  2018. 02. 09
		수  정  자 :  진 준 희
		수 정 사 항:  WHERE 절 로직 변경 (주석 처리로 표시)
		===============================================*/


*********************************************************************************/


--commit
--begin tran
--CREATE PROCEDURE [dbo].[UP_FX_GetCommonDataList]
CREATE PROCEDURE [dbo].[UP_FX_GetCommonDataList]
	  @Code	NVARCHAR(100)
	, @Param1 NVARCHAR(MAX)
	, @Param2 NVARCHAR(MAX)
	, @Param3 NVARCHAR(MAX)
	, @Param4 NVARCHAR(MAX)
	, @Param5 NVARCHAR(MAX)
	, @TimeZone NVARCHAR(MAX) = 'AS054'
AS
BEGIN
		SET NOCOUNT ON;

    DECLARE @v_dept_id nvarchar(50)='';
	DECLARE @v_group_id nvarchar(50)='';

	DECLARE @exception_company TABLE ( company_id nvarchar(100) );	--[NERP]COMPANY 예외적용--NERP (IT20250117A)

	-- 사용자의 팀정보 & 권한
	-- 사용자의 팀정보 & 권한
	--SELECT @v_dept_id = U.DEPT_ID
	--FROM   [dbo].[TB_FX_User] U
	--WHERE  U.UserID = @Param4

	----------------------------------------------------------------------------------------------
	-- 20200428 KHSONG PM TEAM MAPPING 인경우 본인 팀이 선택이 안되는 오류로 쿼리 수정 (BEGIN)
	----------------------------------------------------------------------------------------------

										--SELECT @v_dept_id = isnull( (	 select TOP 1 SEGMENT3
										--			  from  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
										--			 where LOOKUP_TYPE   = 'PM_TEAM_MAPPING'
										--				and SEGMENT1         =   U.DEPT_ID AND VALID_YN = 'Y') , U.DEPT_ID )
										--FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)
										--WHERE  U.UserID = @Param4


	SET @v_dept_id = (SELECT TOP 1 isnull(DEPT_ID,'')
								FROM
									(
									SELECT DEPT_ID FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)
										WHERE  U.UserID = @Param4

									UNION ALL

									-- MAPPING 된 팀이 있는경우 후순위로 추출
									SELECT isnull( (
													select TOP 1 SEGMENT3
														from  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
														where LOOKUP_TYPE   = 'PM_TEAM_MAPPING'
														and SEGMENT1         =   U.DEPT_ID AND VALID_YN = 'Y'
													) , U.DEPT_ID
												)
									FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)
										WHERE  U.UserID = @Param4
									) A
						)

			;

	----------------------------------------------------------------------------------------------
	-- 20200428 KHSONG PM TEAM MAPPING 인경우 본인 팀이 선택이 안되는 오류로 쿼리 수정 (END)
	----------------------------------------------------------------------------------------------

	--IF @Param3 = 'ADMIN' OR @Param3 = 'DM ADMIN'-- OR @v_dept_id = 'ADMIN'
	--	SET @v_group_id = 'ADMIN'
	---------------------------------------------------------------------------------
	--            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP'
						AND VALID_YN = 'Y'
						--AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
						AND SEGMENT2 in ('ALL','DMF0003')  -- 'ALL'인경우 기본값 + DMF0003는 W/S 그룹 추가
						AND SEGMENT1 = @Param3
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
	---------------------------------------------------------------------------------
	--            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------

		/*===============================================
		용		 도:  DIVISION  조회
		사 용 화 면:  DM0015_SCM_MST_BOD		   -	조회조건

		변       수:  @PARAM1 = DIVISION, @PARAM2 = DEPT_ID, @PARAM4 = GROUP_ID, @PARAM4 = USER_ID
		최 초 작 성:  2018. 02. 07
		개  발  자 :
		최 종 작 성:  2018. 02. 07
		수  정  자 :  진   준	희
		수 정 사 항:  사용화면 BOD 추가
		===============================================*/
		IF @Code = 'Division'

			BEGIN
				--SELECT DIVISION_ID AS CODE, MIN([DIVISION_NAME]) AS NAME FROM [dbo].[SCM_MST_DIVISION]
				--WHERE (@Param1 IS NULL OR DIVISION_ID LIKE '%' + @Param1 + '%') OR (@Param1 IS NULL OR DIVISION_NAME LIKE '%' + @Param1 + '%')
				--GROUP BY DIVISION_ID
				--ORDER BY DIVISION_ID
				SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)
				WHERE (@Param1 IS NULL OR DIVISION_ID LIKE '%' + @Param1 + '%') OR (@Param1 IS NULL OR DIVISION_NAME LIKE '%' + @Param1 + '%')
				GROUP BY DIVISION_ID
				ORDER BY DIVISION_ID
			END


		-- PLANT
		-- Param1 = Division ID
		IF @Code = 'Plant'

			BEGIN
				SELECT distinct S.PLANT_ID      AS CODE
					, MAX((CASE
					   WHEN A.PLANT_NAME IS NULL
					    THEN V.VENDOR_NAME
					   ELSE A.PLANT_NAME
					   END ))		   AS NAME
				FROM  SCM_MST_SITE S WITH(NOLOCK)
				LEFT OUTER JOIN  SCM_MST_PLANT_SN A  WITH(NOLOCK) ON A.DIVISION_ID = S.DIVISION_ID AND A.PLANT_ID = S.PLANT_ID -- AND s.operation_group = A.shop_group_id
				LEFT OUTER JOIN  SCM_MST_VENDOR V  WITH(NOLOCK) ON V.VENDOR_CODE = S.PLANT_ID
				WHERE (@Param1 IS NULL OR S.DIVISION_ID = @Param1)
					  AND
					  (
						(@Param2 IS NULL OR S.PLANT_ID LIKE '%' + @Param2 + '%') OR (@Param2 IS NULL OR PLANT_NAME LIKE '%' + @Param2 + '%')
					  )
				AND  S.VALID_YN ='Y'
				GROUP BY S.PLANT_ID
				ORDER BY S.PLANT_ID
			END

		-- CUSTOMER
		-- Param1 = Division ID
		IF @Code = 'Customer'

			BEGIN
				SELECT SOLDTO_CODE AS CODE, SOLDTO_DESCRIPTION AS NAME FROM SCM_MST_CUSTOMER
				WHERE (@Param1 IS NULL OR DIVISION_ID = @Param1)
					  AND
					  (
						(@Param2 IS NULL OR SOLDTO_CODE LIKE '%' + @Param2 + '%') OR (@Param2 IS NULL OR SOLDTO_DESCRIPTION LIKE '%' + @Param2 + '%')
					  )
				group by SOLDTO_CODE,	SOLDTO_DESCRIPTION
				ORDER BY SOLDTO_DESCRIPTION

			END


		-- 그룹-사용자별 Division
		-- Param1 = GroupID, Param2 = UserID
		IF @Code = 'MyDivision'

			BEGIN
				--SELECT
				--	DIVISION_ID AS CODE, MIN([DIVISION_NAME]) AS NAME
				--FROM
				--	[dbo].[SCM_MST_DIVISION] WITH(NOLOCK)
				--WHERE
				--	DIVISION_ID IN
				--	(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = 'D')
				--GROUP BY
				--	DIVISION_ID
				--ORDER BY DIVISION_ID

				Declare @AuthTypePara varchar(100) = 'D'
				if(@Param1 = 'JV Planner') SET @AuthTypePara = 'J';

	SELECT
		DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME
		--DIVISION_ID AS CODE, DIVISION_ID AS NAME
    FROM
		[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)
    WHERE
	    A.ATTRIBUTE3 <> 'EE'
		AND DIVISION_ID IN
		(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = @AuthTypePara)
		-- (SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = 'D')
		--AND DIVISION_ID NOT IN ('EE','EE_UC')
		AND VALID_YN = 'Y'
				GROUP BY
					DIVISION_ID, ATTRIBUTE1
				--ORDER BY DIVISION_ID
				ORDER BY ATTRIBUTE1
			END

		-- 그룹-사용자-Division 별 Plant
		-- Param1 = GroupID, Param2 = UserID, Param3 = Division ID
		IF @Code = 'Auth_Plant'

			BEGIN
				SELECT
					 s.plant_id         AS CODE
					,s.site_description AS NAME
				FROM  SCM_MST_SITE S
				WHERE  1 = 1
				AND S.SITE_TYPE ='PLANT'
				AND S.PLANT_ID IS NOT NULL
				AND S.VALID_YN ='Y'
				AND
					S.DIVISION_ID IN
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = 'D')
				AND
					S.PLANT_ID IN
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					-- WHERE PrntCode IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
					--		FROM   (SELECT x = CAST('<t>' + REPLACE(@Param3, ',', '</t><t>') + '</t>' AS xml)) b
					--		CROSS APPLY x.nodes('/t') t(c)
					   WHERE PrntCode IN ( SELECT token FROM dbo.String_Split(@Param3,',') )
					   AND GroupID = @Param1
					   AND UserID = @Param2
					   AND AuthType = 'P')
				ORDER BY S.PLANT_ID
			END

		-- 그룹-사용자-Division 별 Customer
		-- Param1 = GroupID, Param2 = UserID, Param3 : Division ID
		IF @Code = 'Auth_Customer'

			BEGIN
				SELECT
					SOLDTO_CODE AS CODE, SOLDTO_DESCRIPTION AS NAME FROM SCM_MST_CUSTOMER WITH(NOLOCK)
				WHERE
					DIVISION_ID = @Param3
					AND
					SOLDTO_CODE IN
					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE PrntCode = @Param3 AND GroupID = @Param1 AND UserID = @Param2 AND AuthType = 'C')
				ORDER BY SOLDTO_CODE
			END

		-- Language
		IF @Code = 'Language'

			BEGIN
				SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
				WHERE LOOKUP_TYPE = 'LANGUAGE'
				  AND VALID_YN = 'Y'
				ORDER BY DISPLAY_SEQ
			END

		-- TimeZone
		IF @Code = 'TimeZone'

			BEGIN
				SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
				WHERE LOOKUP_TYPE = 'TIME_ZONE'
				  AND VALID_YN = 'Y'
				ORDER BY DISPLAY_SEQ
			END

		-- BOD_TYPE
		IF @Code = 'BodType'

			BEGIN
				SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
				WHERE LOOKUP_TYPE = 'BOD_TYPE_CODE'
				ORDER BY DISPLAY_SEQ
			END

		-- TRANSPORT MODE
		IF @Code = 'TransportMode'

			BEGIN
				-- 2020-08-20 KIMYONGHO 해당 쿼리 오류 구문으로 미사용으로 판단하고 변경 처리
				--SELECT LOOKUP_CODE AS CODE, DESCRIPTION AS NAME FROM SCM_ADM_LOOKUP_VALUES  WITH(NOLOCK)
				--WHERE LOOKUP_TYPE = 'TRANSPORT_MODE_CODE'
				--ORDER BY DISPLAY_SEQ

				SELECT L.SEGMENT1  AS CODE
					 , L.SEGMENT1  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'TRANSPORT_MODE_CODE'
				ORDER BY L.DISPLAY_SEQ			END

		-- Period Type
		IF @Code = 'PeriodType'

			BEGIN
				SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
				WHERE LOOKUP_TYPE = 'PERIOD_TYPE'
				ORDER BY DISPLAY_SEQ
			END

		----HUB_SLOC_CODE

		--IF @Code = 'Hubsloc'

		--	BEGIN
		--		SELECT LOOKUP_CODE AS CODE, DESCRIPTION AS NAME FROM SCM_ADM_LOOKUP_VALUES
		--		WHERE LOOKUP_TYPE = 'HUB_SLOC_CODE'
		--		ORDER BY DISPLAY_SEQ
		--	END

		---- FP_PLAN_PERIOD
		--IF @Code = 'FPPlanPeriod'

		--	BEGIN
		--		SELECT LOOKUP_CODE AS CODE, DESCRIPTION AS NAME FROM SCM_ADM_LOOKUP_VALUES
		--		WHERE LOOKUP_TYPE = 'FP_PLAN_PERIOD'
		--		ORDER BY DISPLAY_SEQ
		--	END

		----PLAN_PERIOD
		--IF @Code = 'PlanPeriod'

		--	BEGIN
		--		SELECT B.LOOKUP_CODE CODE, B.DESCRIPTION NAME
		--		FROM SCM_ADM_LOOKUP_TYPE A WITH(NOLOCK)
		--		INNER JOIN SCM_ADM_LOOKUP_VALUES B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE
		--		WHERE A.LOOKUP_TYPE = 'DEFAULT_PERIOD'
		--		ORDER BY B.DISPLAY_SEQ
		--	END

		---- PROD_TYPE
		--IF @Code = 'ProdType'

		--	BEGIN
		--		SELECT LOOKUP_CODE AS CODE, DESCRIPTION AS NAME FROM SCM_ADM_LOOKUP_VALUES
		--		WHERE LOOKUP_TYPE = 'OPERATION_GROUP'
		--		ORDER BY DISPLAY_SEQ
		--	END

		---- COUNTRY_TYPE_CODE
		--IF @Code = 'CountryTypeCode'

		--	BEGIN
		--		SELECT LOOKUP_CODE AS CODE, DESCRIPTION AS NAME FROM SCM_ADM_LOOKUP_VALUES
		--		WHERE LOOKUP_TYPE = 'COUNTRY_TYPE_CODE'
		--		ORDER BY DISPLAY_SEQ
		--	END

		---- ELECTRODE_TYPE
		--IF @Code = 'ElectrodeType'

		--	BEGIN
		--		SELECT LOOKUP_CODE AS CODE, DESCRIPTION AS NAME FROM SCM_ADM_LOOKUP_VALUES
		--		WHERE LOOKUP_TYPE = 'ELECTRODE_TYPE'
		--		ORDER BY DISPLAY_SEQ
		--	END

		---- LOOKUP_GROUP
		--IF @Code = 'LookupGroup'

		--	BEGIN
		--		SELECT LOOKUP_CODE AS CODE, DESCRIPTION AS NAME FROM SCM_ADM_LOOKUP_VALUES
		--		WHERE LOOKUP_TYPE = 'LOOKUP_GROUP'
		--		ORDER BY DISPLAY_SEQ
		--	END

		---- DIVISION_GROUP
		--IF @Code = 'DivisionGroup'

		--	BEGIN
		--		SELECT LOOKUP_CODE AS CODE, DESCRIPTION AS NAME FROM SCM_ADM_LOOKUP_VALUES
		--		WHERE LOOKUP_TYPE = 'DIVISION_GROUP'
		--		ORDER BY DISPLAY_SEQ
		--	END

		-- GROUPID
		IF @Code = 'GroupID'

			BEGIN
				SELECT GroupID AS CODE, GrpName AS NAME FROM TB_FX_GROUPINFO  WITH(NOLOCK)
				ORDER BY GroupID
			END

		-- My GROUPID
		IF @Code = 'MyGroupID'

			BEGIN
				SELECT G.GroupID AS CODE, G.GrpName AS NAME FROM TB_FX_GroupInfo G WITH(NOLOCK) , TB_FX_UserGroupinfo U  WITH(NOLOCK)
				WHERE G.UseYN = 'Y' AND U.UseYN = 'Y' AND G.GroupID = U.GroupID AND U.UserID = U.UserID AND U.UserID = @Param1
				  AND G.GroupID != 'Guest'
				ORDER BY G.GroupID
			END

		-- My GROUPID_ALL
		IF @Code = 'MyGroupIDALL'

			BEGIN
				SELECT G.GroupID AS CODE, G.GrpName AS NAME FROM TB_FX_GroupInfo G WITH(NOLOCK) , TB_FX_UserGroupInfo U  WITH(NOLOCK)
				WHERE U.UseYN = 'Y' AND G.GroupID = U.GroupID AND U.UserID = U.UserID AND U.UserID = @Param1
				ORDER BY G.GroupID
			END

		-- Dept
		IF @Code = 'Dept'

		BEGIN
			SELECT DEPT_ID AS CODE,
				NAME =
				CASE @Param1
					WHEN 'KO' THEN DEPT_NAME_KO
					WHEN 'EN' THEN DEPT_NAME_EN
					WHEN 'CN' THEN DEPT_NAME_CN
				END
				FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK)
				WHERE (@Param2 IS NULL OR DEPT_ID LIKE '%' + @Param2 + '%')
				OR (@Param2 IS NULL OR DEPT_NAME_KO LIKE '%' + @Param2 + '%')
				OR (@Param2 IS NULL OR DEPT_NAME_EN LIKE '%' + @Param2 + '%')
				OR (@Param2 IS NULL OR DEPT_NAME_CN LIKE '%' + @Param2 + '%')
				ORDER BY CODE
		END

		/*===============================================
		용		 도:  DIVISION 변경시 SITE 조회
		사 용 화 면:  DM0004_SCM_MST_SITE			-	MAIN SPREAD의 SITE 컬럼
					  DM0015_SCM_MST_BOD			-	MAIN SPREAD의 SITE 컬럼
		변       수:  @PARAM1 = DIVISION, @PARAM2 = GROUPID, @PARAM3 = USERID
		최 초 작 성:
		개 발  자 :
		최 종 작 성:  2018. 02. 14
		수  정  자 :  진 준 희
		수 정 사 항:   권한 그룹 추가
		===============================================*/
		IF @Code = 'FromSiteByDivision'

		BEGIN
			Declare @AuthTypeParaDivision varchar(100) = 'D'
			if(@Param2 = 'JV Planner') SET @AuthTypeParaDivision = 'J';

			SELECT	SCM_SITE_ID        AS CODE
				,	SCM_SITE_ID		   AS NAME
				 --, SITE_DESCRIPTION   AS NAME 2018-02-12 진준희 수정
			FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
			WHERE SITE_TYPE = 'PLANT'
			AND    A.VALID_YN  = 'Y'
			AND CASE WHEN @Param1 = 'ALL' OR @Param1 ='' THEN @Param1
					 ELSE A.DIVISION_ID
				END  IN (  SELECT token FROM dbo.String_Split(@Param1,',')

				         /*    SELECT t.c.value('.', 'NVARCHAR(4000)')
							 FROM   (SELECT x = CAST('<t>' + REPLACE( CASE @Param1 WHEN '' THEN 'ALL'ELSE @Param1 END             , ',', '</t><t>') + '</t>' AS xml)) b
							 CROSS APPLY x.nodes('/t') t(c) */				--2018-02-08 진준희 수정
						)

			AND    A.DIVISION_ID IN (SELECT CODE							--2018-02-14 진준희 수정
		    FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    			 WHERE  GroupID LIKE '%'+ @Param2 + '%'
							    	 AND    UserID  LIKE '%'+ @Param3 + '%'
								     AND    AuthType = @AuthTypeParaDivision)
		END

		/*===============================================
		용		 도:  DIVISION 변경시 SITE 조회
		사 용 화 면:  DM0004_SCM_MST_SITE			-	MAIN SPREAD의 SITE 컬럼
					  DM0015_SCM_MST_BOD			-	MAIN SPREAD의 SITE 컬럼
		변       수:  @PARAM1 = DIVISION, @PARAM2 = GROUPID, @PARAM3 = USERID
		최 초 작 성:
		개  발  자 :
		최 종 작 성:  2018. 02. 14
		수  정  자 :  진 준 희
		수 정 사 항:  권한 그룹 추가.
		===============================================*/
		IF @Code = 'ToSiteByDivision'

		BEGIN
			SELECT	 SCM_SITE_ID			AS	CODE
					,SCM_SITE_ID			AS	NAME
					--,SITE_TYPE
						--, SITE_DESCRIPTION   AS NAME 2018-02-12 진준희 수정
			FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
			WHERE   A.VALID_YN  = 'Y'
			AND			CASE WHEN @Param1 = 'ALL' OR @Param1 ='' THEN @Param1
						ELSE A.DIVISION_ID
				   END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
								   /* SELECT t.c.value('.', 'NVARCHAR(4000)')
									FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
									CROSS APPLY x.nodes('/t') t(c)*/		--2018-02-12 진준희 수정
						 )
			AND    A.DIVISION_ID IN (SELECT CODE							--2018-02-14 진준희 수정
		                 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    			 WHERE  GroupID LIKE '%'+ @Param2 + '%'
							    	 AND    UserID  LIKE '%'+ @Param3 + '%'
								     AND    AuthType = 'D')
		END

		-- SALE_SITE_BY_DIVISION
		-- @Param1 = @p_division_id
		IF @Code = 'SaleSiteByDivision'

		BEGIN
			SELECT A.SCM_SITE_ID AS CODE
				, A.SITE_DESCRIPTION AS NAME
			 FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
			WHERE  1 = 1
			  AND    A.SITE_TYPE = 'SALES'
			  AND    A.VALID_YN  = 'Y'
			  AND    A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
						    -- SELECT t.c.value('.', 'NVARCHAR(4000)')
							-- FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
							-- CROSS APPLY x.nodes('/t') t(c)
							)
		END

		-- PLANT_SITE_BY_DIVISION
		-- @Param1 = @p_division_id
		IF @Code = 'PlantSiteByDivision'

		BEGIN
			 SELECT A.SCM_SITE_ID AS CODE
				   , A.SITE_DESCRIPTION AS NAME
			  FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
			  WHERE  1 = 1
			    AND    A.SITE_TYPE = 'PLANT'
				AND    A.VALID_YN  = 'Y'
			    AND    A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
							  -- SELECT t.c.value('.', 'NVARCHAR(4000)')
							  -- FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
							  -- CROSS APPLY x.nodes('/t') t(c)
							   )
		END

		-- PLANT_SITE_BY_DIVISION_OSP
		-- @Param1 = @p_division_id
		IF @Code = 'PlantSiteByDivisionOSP'			
		
		BEGIN
			 SELECT A.SCM_SITE_ID AS CODE
				   , A.SITE_DESCRIPTION AS NAME
			  FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
			  WHERE  1 = 1
			  AND    A.SITE_TYPE = 'PLANT'
			  AND    A.VALID_YN  = 'Y'
			  AND    A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')
								-- SELECT t.c.value('.', 'NVARCHAR(4000)')
								-- FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
								-- CROSS APPLY x.nodes('/t') t(c)
							   )
			  AND A.OSP_YN ='Y'	
			  --AND A.VALID_YN ='Y'	
		END		

		-- PLANT_BY_DIVISION
		-- @Param1 = @p_division_id
		IF @Code = 'PlantByDivision'

		BEGIN
		   SELECT A.PLANT_ID      AS CODE
				, A.PLANT_NAME    AS NAME
			FROM  [dbo].[SCM_MST_PLANT_SN] A WITH(NOLOCK)
			WHERE  1 = 1
			AND    A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')
						    -- SELECT t.c.value('.', 'NVARCHAR(4000)')
							-- FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
							-- CROSS APPLY x.nodes('/t') t(c)
							)
		END

		-- BUILDING_BY_PLANT
		-- @Param1 = @p_plant_id
		IF @Code = 'BuildingByPlant'

		BEGIN
			SELECT
			  DISTINCT
				   A.FACTORY_ID    AS CODE
				  , A.FACTORY_NAME  AS NAME
			 FROM  [dbo].[SCM_MST_FACTORY_SN] A WITH(NOLOCK)
			 WHERE 1=1
			AND ((@Param1 IS NULL or @Param1='') OR A.PLANT_ID IN
						( SELECT token FROM dbo.String_Split(@Param1,',')
						--SELECT t.c.value('.', 'NVARCHAR(4000)')
						--FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
						--CROSS APPLY x.nodes('/t') t(c)
						)
				)
		END


		-- BUILDING_BY_DIVISION
		-- @Param1 = @p_division_id
		IF @Code = 'BuildingByDivision'

		BEGIN
			SELECT
			  DISTINCT
					A.FACTORY_ID    AS CODE
				  , A.FACTORY_NAME  AS NAME
			 FROM  [dbo].[SCM_MST_FACTORY_SN] A WITH(NOLOCK)
			 WHERE 1=1
				AND ( (@Param1 IS NULL or @Param1='') OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,','))  )
				AND ( (@Param2 IS NULL or @Param2='') OR A.PLANT_ID IN ( SELECT token FROM dbo.String_Split(@Param2,','))  )
		END
		-- OPERATION_BY_BUILDING
		/*
		  @Param1 = @p_disivion_id
		  @Param2 = @p_plant_site_id
		  @Param3 = @p_factory_id
		*/
		IF @Code = 'OperationByBuilding'

		BEGIN

		 SELECT
		 DISTINCT
				A.OPERATION_ID    AS CODE
			  , (A.OPERATION_ID + ' ' + B.OPERATION_NAME)  AS NAME, A.OPERATION_ID
		 FROM [dbo].SCM_MST_LINE_SN A  WITH(NOLOCK)
		 JOIN [dbo].SCM_MST_OPERATION_SN B  WITH(NOLOCK) ON  A.OPERATION_ID = B.OPERATION_ID
		 WHERE 1=1
		 AND ( (@Param1 IS NULL or @Param1='') OR A.DIVISION_ID IN
					( SELECT token FROM dbo.String_Split(@Param1,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
					--CROSS APPLY x.nodes('/t') t(c)
					)
			)

		AND ( (@Param2 IS NULL or @Param2='') OR A.PLANT_ID IN
					( SELECT token FROM dbo.String_Split(SUBSTRING(@Param2,1,4),',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--FROM   (SELECT x = CAST('<t>' + REPLACE(SUBSTRING(@Param2,1,4), ',', '</t><t>') + '</t>' AS xml)) b
					--CROSS APPLY x.nodes('/t') t(c)
					)
			)

		 AND ( (@Param3 IS NULL or @Param3='') OR A.FACTORY_ID IN
					( SELECT token FROM dbo.String_Split(@Param3,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--FROM   (SELECT x = CAST('<t>' + REPLACE(@Param3, ',', '</t><t>') + '</t>' AS xml)) b
					--CROSS APPLY x.nodes('/t') t(c)
					)
			)
			ORDER BY A.OPERATION_ID
		END

		IF @Code = 'LocationGroupByCapa'
		BEGIN
			SELECT SEGMENT4 as code, d.OPERATION_NAME as name
			FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
			    join  SCM_MST_OPERATION_SN d  WITH(NOLOCK) on b.SEGMENT4 =  d.OPERATION_ID
			WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
			AND    b.valid_yn = 'Y'
			AND    b.segment3 = 'Y'
			AND    (@Param1 IS NULL OR @Param1='' OR @Param1 IN (SELECT TOKEN FROM dbo.String_Split(b.segment5,',')))
			GROUP BY SEGMENT4,d.OPERATION_NAME
			ORDER BY OPERATION_NAME
		END

		-- INCOTERMS
		/*

		*/
		IF @Code = 'Incoterms'


			BEGIN
				SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
				WHERE LOOKUP_TYPE = 'INCOTERMS'
				AND   VALID_YN = 'Y' --[PJ20228272] NERP 대응 - INCOTERMS Valid 추가
				ORDER BY DISPLAY_SEQ
			END


		/*===============================================
		용		 도:  DIVISION, 팀  변경시 ENDCUSTOMER 조회
		사 용 화 면:  DM0015_SCM_MST_BOD		   -	MAIN SPREAD의 SITE 컬럼
					  DM0004_DM_MST_SITE_CUSTOMER  -	SUB SPREAD의 SITE 컬럼
		변       수:  @PARAM1 = DIVISION, @PARAM2 = DEPT_ID, @PARAM3 = GROUP_ID, @PARAM4 = USER_ID
		최 초 작 성:
		개  발  자 :
		최 종 작 성:  2018. 02. 08
		수  정  자 :  진 준 희
		수 정 사 항:  WHERE절 로직 수정
					  2021.05.18	winter1203  [C20210423-000315] MDM 기준정보 변경시 EndCustomer의 명칭이 보이도록 수정
		===============================================*/

		IF @Code = 'EndCustomerByDivisionDept'

			BEGIN
				SELECT DISTINCT
						A.END_CUSTOMER AS CODE
						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
				WHERE  1 = 1
				AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1 -- 2018-02-08 진준희
							ELSE A.DIVISION_ID
						END  IN (  SELECT TOKEN FROM DBO.STRING_SPLIT(@Param1,',')
								/*SELECT T.C.VALUE('.', 'NVARCHAR(4000)')
								FROM   (SELECT X = CAST('<T>' + REPLACE( CASE @PARAM1 WHEN '' THEN 'ALL' ELSE @PARAM1 END , ',', '</T><T>') + '</T>' AS XML)) B
								CROSS APPLY X.NODES('/T') T(C)*/ -- 2018-02-08 진준희
								)
				AND    CASE WHEN @Param2 = 'ALL'  OR  @Param2 ='' THEN @Param2 -- 2018-02-08 진준희
							ELSE A.DEPT_ID
						END  IN (  SELECT TOKEN FROM DBO.STRING_SPLIT(@Param2,',')
								/*SELECT T.C.VALUE('.', 'NVARCHAR(4000)')
								FROM   (SELECT X = CAST('<T>' + REPLACE( CASE @PARAM2 WHEN '' THEN 'ALL' ELSE @PARAM2 END , ',', '</T><T>') + '</T>' AS XML)) B
								CROSS APPLY X.NODES('/T') T(C)*/ -- 2018-02-08 진준희
				)
				AND    A.DIVISION_ID IN (SELECT CODE
									FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK)
					    					WHERE  GROUPID LIKE '%'+ @Param3 + '%'
											AND    USERID  LIKE '%'+ @Param4 + '%'
											AND    AUTHTYPE = 'D')
				AND    END_CUSTOMER IS NOT NULL
				ORDER BY A.END_CUSTOMER

		END


		/*===============================================
		용		 도:  END CUSTOEMR 변경시 SITE 조회
		사 용 화 면:  DM0015_SCM_MST_BOD		   -	MAIN SPREAD의 SITE 컬럼
					  DM0004_DM_MST_SITE_CUSTOMER  -	SUB SPREAD의 SITE 컬럼
		변       수:  @PARAM1 = ENDCUSTOMER, @PARAM2 =  ★누락되어 있음 화면 담당자 수정 필요, @PARAM3 = GROUP_ID, @PARAM4 = USER_ID
		최 초 작 성:
		개  발  자 :
		최 종 작 성:  2018. 02. 08
		수  정  자 :  진 준 희
		수 정 사 항:  WHERE절 로직 수정
		===============================================*/

	IF @Code = 'SiteByEndCustomer'

		BEGIN
			Declare @AuthTypeParaSite varchar(100) = 'D'
			if(@Param3 = 'JV Planner') SET @AuthTypeParaSite = 'J';
			IF (@Param1 <> '40')
			BEGIN
				SELECT DISTINCT
					   SCM_SITE_ID AS CODE
					 , SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
					-- added by ytchoi 190109 start
					INNER JOIN ( SELECT token FROM dbo.String_Split(@Param2,',') )AS C
					ON A.END_CUSTOMER = CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN A.END_CUSTOMER ELSE C.token END
					-- added by ytchoi 190109 end
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'
				AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1			--2018-02-08  진준희
						 ELSE A.DIVISION_ID
 					END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
                -- delete by ytchoi 190109 start
				--AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2			--2018-02-08  진준희
				--		 ELSE A.END_CUSTOMER
 			    --		END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')
				--			/* SELECT t.c.value('.', 'NVARCHAR(4000)')
				--			 FROM   (SELECT x = CAST('<t>' + REPLACE( CASE @Param1 WHEN '' THEN 'ALL' ELSE @Param1 END , ',', '</t><t>') + '</t>' AS xml)) b
				--			 CROSS APPLY x.nodes('/t') t(c)		*/				--2018-02-08  진준희
				--			)
	            -- delete by ytchoi 190109 end
				AND    A.DIVISION_ID IN (SELECT CODE
										 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    				 WHERE  GroupID LIKE '%'+ @Param3 + '%'
							    		 AND    UserID  LIKE '%'+ @Param4 + '%'
										 AND    AuthType = @AuthTypeParaSite)
				AND A.VALID_YN = 'Y'	-- 20180612 추가
				ORDER BY SCM_SITE_ID ASC;
			END
			ELSE
			BEGIN
				-- 20180612 소형 추가
				SELECT DISTINCT
					   A.SCM_SITE_ID AS CODE
					 , A.SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE AS A WITH(NOLOCK)
					LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK)
					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
					-- added by ytchoi 190109 start
					INNER JOIN ( SELECT token FROM dbo.String_Split(@Param2,',') )AS C
					ON B.PROJECT_CODE = CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN B.PROJECT_CODE ELSE C.token END
					-- added by ytchoi 190109 end
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'
				AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1
						 ELSE A.DIVISION_ID
 					END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
                -- delete by ytchoi 190109 start
				--AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2
				--	   ELSE B.PROJECT_CODE
 			    --	   END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')
				--			)
				-- delete by ytchoi 190109 end
				AND    A.DIVISION_ID IN (SELECT CODE
										 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    				 WHERE  GroupID LIKE '%'+ @Param3 + '%'
							    		 AND    UserID  LIKE '%'+ @Param4 + '%'
										 AND    AuthType = @AuthTypeParaSite)
				AND A.VALID_YN = 'Y'
				ORDER BY A.SCM_SITE_ID ASC;
			END
		END


		/*===============================================
		용		 도:  END CUSTOEMR 변경시 SITE 조회
		사 용 화 면:  DM0015_SCM_MST_BOD		   -	MAIN SPREAD의 SITE 컬럼
					  DM0004_DM_MST_SITE_CUSTOMER  -	SUB SPREAD의 SITE 컬럼
		변       수:  @PARAM1 = ENDCUSTOMER, @PARAM2 =  ★누락되어 있음 화면 담당자 수정 필요, @PARAM3 = GROUP_ID, @PARAM4 = USER_ID
		최 초 작 성:
		개  발  자 :
		최 종 작 성:  2018. 07. 04
		수  정  자 :  이상훈
		수 정 사 항:  SoldtoCustomer 조회 조건 추가
		===============================================*/

	IF @Code = 'SiteByEndCustomerSold'

		BEGIN

			IF (@Param1 <> '40')
			BEGIN
				SELECT DISTINCT
					   SCM_SITE_ID AS CODE
					 , SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE A WITH(NOLOCK)
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'
				AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1			--2018-02-08  진준희
						 ELSE A.DIVISION_ID
 					END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
				AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2			--2018-02-08  진준희
						 ELSE A.END_CUSTOMER
 					END  IN ( SELECT token FROM dbo.String_Split(@Param2,','))
				AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2			--2018-02-08  진준희
						 ELSE A.END_CUSTOMER
 					END  IN ( SELECT token FROM dbo.String_Split(@Param2,','))
				------AND CASE WHEN @Param5 = 'ALL' OR @Param5 = '' THEN @Param5			--2018-07-04  이상훈
				------		 ELSE A.SOLDTO_CUSTOMER
 			------		END  IN ( SELECT token FROM dbo.String_Split(@Param5,','))
				AND    A.DIVISION_ID IN (SELECT CODE
										 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    				 WHERE  GroupID LIKE '%'+ @Param3 + '%'
							    		 AND    UserID  LIKE '%'+ @Param4 + '%'
										 AND    AuthType = 'D')
				AND A.VALID_YN = 'Y'	-- 20180612 추가
				ORDER BY SCM_SITE_ID ASC;
			END
			ELSE
			BEGIN
				-- 20180612 소형 추가
				SELECT DISTINCT
					   A.SCM_SITE_ID AS CODE
					 , A.SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE AS A WITH(NOLOCK)
					LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK)
					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'SALES'
				AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1
						 ELSE A.DIVISION_ID
 					END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
				AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2
						 ELSE B.PROJECT_CODE
 					END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')
							)
				AND CASE WHEN @Param5 = 'ALL' OR @Param5 = '' THEN @Param5			--2018-07-04  이상훈
						 ELSE A.SOLDTO_CUSTOMER
 					END  IN ( SELECT token FROM dbo.String_Split(@Param5,','))
				AND    A.DIVISION_ID IN (SELECT CODE
										 FROM  TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    				 WHERE  GroupID LIKE '%'+ @Param3 + '%'
							    		 AND    UserID  LIKE '%'+ @Param4 + '%'
										 AND    AuthType = 'D')
				AND A.VALID_YN = 'Y'
				ORDER BY A.SCM_SITE_ID ASC;
			END
		END



		/*===============================================
		용		 도:  소형 END CUSTOEMR 변경시 SITE 조회
		사 용 화 면:  DM0015_SCM_MST_BOD		   -	MAIN SPREAD의 SITE 컬럼
					  DM0004_DM_MST_SITE_CUSTOMER  -	SUB SPREAD의 SITE 컬럼
		변       수:
		최 초 작 성:
		개  발  자 :
		최 종 작 성:  2018. 06. 29
		수  정  자 :  이상훈
		수 정 사 항:
		===============================================*/

	IF @Code = 'SiteByEndCustomer40'
		BEGIN
			SELECT DISTINCT A.SCM_SITE_ID AS CODE, A.SCM_SITE_ID AS NAME
			FROM SCM_MST_SITE A WITH(NOLOCK)
			LEFT JOIN SCM_MST_SITE_ITEM B  WITH(NOLOCK)
			ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
			LEFT JOIN (
						SELECT DISTINCT A.USER_ID, A.DEPT_ID
						FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK) , SCM_MST_SSO_DEPT_INFO B  WITH(NOLOCK)
						WHERE A.DEPT_ID = B.DEPT_ID
						AND B.DEPT_ID IN ( SELECT token FROM dbo.String_Split(@Param2,','))	-- 20180801
					) C ON B.OWNER = C.USER_ID
			WHERE  1 = 1
			AND    A.SITE_TYPE = 'SALES'
			AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1
						ELSE A.DIVISION_ID
 				END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
			AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2
						ELSE C.DEPT_ID
 				END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')
						)
			AND CASE WHEN @Param3 = 'ALL' OR @Param3 = '' THEN @Param3
						ELSE B.PROJECT_CODE
 				END  IN ( SELECT token FROM dbo.String_Split(@Param3,',')
						)
			AND    A.DIVISION_ID IN (SELECT CODE
										FROM  TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    				WHERE  GroupID LIKE '%'+ @Param4 + '%'
										AND    UserID  LIKE '%'+ @Param5 + '%'
										AND AuthType = 'D')
			AND A.VALID_YN = 'Y'
			ORDER BY A.SCM_SITE_ID ASC;
		END

		/*===============================================
		용		 도:  END CUSTOEMR 변경시 SITE 조회
		사 용 화 면:  DM0015_SCM_MST_BOD		   -	MAIN SPREAD의 SITE 컬럼
					  DM0004_DM_MST_SITE_CUSTOMER  -	SUB SPREAD의 SITE 컬럼
		변       수:  @PARAM1 = ENDCUSTOMER, @PARAM2 =  ★누락되어 있음 화면 담당자 수정 필요, @PARAM3 = GROUP_ID, @PARAM4 = USER_ID
		최 초 작 성:
		개  발  자 :
		최 종 작 성:  2018. 03. 06
		수  정  자 :  황 승재
		수 정 사 항:  WHERE절 로직 수정
		===============================================*/
		IF @Code = 'SiteByEndCustomerEx'

		BEGIN
			SELECT DISTINCT
			       SCM_SITE_ID AS CODE
			     , SCM_SITE_ID AS NAME
			FROM   SCM_MST_SITE A WITH(NOLOCK)
			WHERE  1 = 1
			AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1
                        ELSE A.DIVISION_ID
	               END  IN (  SELECT token FROM dbo.String_Split(@Param1,',')
	                       )
			AND    A.SITE_TYPE = 'SALES'
			AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2
                     ELSE A.END_CUSTOMER
 	            END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')
	                    )
            AND    A.DIVISION_ID IN (SELECT CODE
		                             FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    			 WHERE  GroupID LIKE '%'+ @Param3 + '%'
							    	 AND    UserID  LIKE '%'+ @Param4 + '%'
								     AND    AuthType = 'D')
			AND A.VALID_YN = 'Y'	-- 20180612 추가
			ORDER BY SCM_SITE_ID ASC;
		END



		-- BUILDING_BY_PLANTSITE
		/*
		@Param1 = @p_plant_site_id
		@Param2 = @p_disivion_id
		*/
		IF @Code = 'BuildingByPlantSite'

		BEGIN
			SELECT
			      DISTINCT
				  A.FACTORY_ID    AS CODE
				, A.FACTORY_NAME  AS NAME
			FROM  [dbo].[SCM_MST_FACTORY_SN] A WITH(NOLOCK)
			WHERE 1=1
			AND (@Param1 IS NULL OR A.PLANT_ID IN
					(  SELECT token FROM dbo.String_Split(SUBSTRING(@Param1,1,4),',')
					 --SELECT t.c.value('.', 'NVARCHAR(4000)')
					 --FROM   (SELECT x = CAST('<t>' + REPLACE(SUBSTRING(@Param1,1,4), ',', '</t><t>') + '</t>' AS xml)) b
					 --CROSS APPLY x.nodes('/t') t(c)
					)
			)
			AND (@Param2 IS NULL OR A.DIVISION_ID IN
					( SELECT token FROM dbo.String_Split(@Param2,',')
					-- SELECT t.c.value('.', 'NVARCHAR(4000)')
					-- FROM   (SELECT x = CAST('<t>' + REPLACE(@Param2, ',', '</t><t>') + '</t>' AS xml)) b
					-- CROSS APPLY x.nodes('/t') t(c)
					)
			)
		END

		-- LINE_BY_OPERATION
		/*
		@Param1 = @p_disivion_id
		@Param2 = @p_plant_site_id
		@Param3 = @p_factory_id
		@Param4 = @p_operation_id
		@Param5 = @scm_site_id
		*/
		IF @Code = 'LineByOperation'

		BEGIN
			  SELECT
				DISTINCT
					 A.LINE_ID						  AS CODE
					,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
					,A.OPERATION_ID
					,B.SCM_SITE_ID
				FROM [dbo].SCM_MST_LINE_SN A  WITH(NOLOCK)
				JOIN [dbo].SCM_MST_SITE B  WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND  A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID
				INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1
								FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
								WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
								AND    b.valid_yn    = 'Y'
								AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
							) f ON a.operation_id = f.segment4 --AND c.operation_group_id = f.segment3 -- operation group id 에 추가된 operation 만보이도록
				WHERE 1=1
				AND A.ACTIVE_FLAG ='Y'
				AND ( (@Param1 IS NULL OR @Param1 ='') OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')) )
				AND ( (@Param2 IS NULL OR @Param2 ='') OR A.PLANT_ID IN ( SELECT token FROM dbo.String_Split(SUBSTRING(@Param2,1,4),','))   )
				AND ( (@Param3 IS NULL OR @Param3 ='') OR A.FACTORY_ID IN ( SELECT token FROM dbo.String_Split(@Param3,','))   )
				AND ( (@Param4 IS NULL OR @Param4 ='') OR A.OPERATION_ID IN ( SELECT token FROM dbo.String_Split(@Param4,','))   )
				AND ( (@Param5 IS NULL OR @Param5 ='') OR B.SCM_SITE_ID IN ( SELECT token FROM dbo.String_Split(@Param5,','))   )
				UNION
				SELECT
					'-'  AS CODE
					,'-'  AS NAME
					,'-'  AS OPERATION_ID
					,'-'  AS SCM_SITE_ID
				ORDER BY NAME
		END

		-- LOCATION_BY_PLANTSITE1
		/*
	    @Param1 = @p_division_id    NVARCHAR(MAX),
	    @Param2 = @p_scm_site_id    NVARCHAR(MAX)
	    */
		IF @Code = 'LocationByPlantSite'

		BEGIN
			SELECT distinct
					 L.LOCATION_CODE AS CODE
				   , L.LOCATION_DESCRIPTION AS NAME
			  FROM   [dbo].[SCM_MST_LOCATION] L WITH(NOLOCK)
			  WHERE 1=1
			  AND    L.LOCATION_CODE = L.LOCATION_CODE
			  AND    L.STORAGE_ID IS NOT NULL
			  AND    (@Param1 IS NULL OR L.DIVISION_ID IN
							( SELECT token FROM dbo.String_Split(@Param1,',')
							--SELECT t.c.value('.', 'NVARCHAR(4000)')
							--FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
							--CROSS APPLY x.nodes('/t') t(c)
							)
					 )
			  AND    (@Param2 IS NULL OR L.SCM_SITE_ID IN
							( SELECT token FROM dbo.String_Split(@Param2,',')
							--SELECT t.c.value('.', 'NVARCHAR(4000)')
							--FROM   (SELECT x = CAST('<t>' + REPLACE(@Param2, ',', '</t><t>') + '</t>' AS xml)) b
							--CROSS APPLY x.nodes('/t') t(c)
							)
					 )
			  ORDER BY L.LOCATION_CODE
		END

		-- ITEM_MASTER_CLASS1
		IF @Code = 'ITEM_MASTER_CLASS1'

		BEGIN
			SELECT
				 DISTINCT
				 B.LEVEL_1_NAME AS CODE
				,B.LEVEL_1_NAME AS NAME
			FROM SCM_MST_ITEM_SN A(NOLOCK)
			INNER HASH JOIN SCM_MST_ITEM_CLASS_SN B(NOLOCK) ON A.ITEM_CLASS = B.CLASS_ID
			ORDER BY B.LEVEL_1_NAME
		END

		-- ITEM_MASTER_CLASS1
		-- Param1 = LEVEL_1_NAME
		IF @Code = 'ITEM_MASTER_CLASS2'

		BEGIN
			SELECT
				 DISTINCT
				 B.LEVEL_2_NAME AS CODE
				,B.LEVEL_2_NAME AS NAME
			FROM SCM_MST_ITEM_SN A(NOLOCK)
			INNER HASH JOIN SCM_MST_ITEM_CLASS_SN B(NOLOCK) ON A.ITEM_CLASS = B.CLASS_ID
			WHERE
				(@Param1 IS NULL  OR  B.LEVEL_1_NAME IN
					( SELECT token FROM dbo.String_Split(@Param1,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
					--CROSS APPLY x.nodes('/t') t(c)
					)
				  )

			ORDER BY B.LEVEL_2_NAME
		END

		-- ITEM_MASTER_CLASS1
		-- Param1 = LEVEL_1_NAME

		-- ITEM_MASTER_ITEM_TYPE
		IF @Code = 'ITEM_MASTER_ITEM_TYPE'

		BEGIN
			SELECT *
			FROM(
			SELECT DISTINCT
				 CASE WHEN ISNULL(LTRIM(RTRIM(A.ITEM_TYPE)),'') = '' THEN '-'
					WHEN A.ITEM_TYPE IS NULL THEN '-' ELSE A.ITEM_TYPE END AS CODE
				,CASE WHEN ISNULL(LTRIM(RTRIM(A.ITEM_TYPE)),'') = '' THEN '-'
					WHEN A.ITEM_TYPE IS NULL THEN '-' ELSE A.ITEM_TYPE END AS NAME
			FROM SCM_MST_ITEM_SN A(NOLOCK)
						--WHERE A.ITEM_TYPE IS NOT NULL AND ISNULL(LTRIM(RTRIM(A.ITEM_TYPE)),'') != ''
			) A ORDER BY CODE
		END

		-- SETUP_MATRIX_CATEGORY
		IF @Code = 'SETUP_MATRIX_CATEGORY'

		BEGIN
			SELECT DISTINCT
			 T.SETUP_CATEGORY_ID AS CODE
			,T.SETUP_CATEGORY_ID AS NAME
			FROM SCM_MST_SETUP_MATRIX_SN T WITH(NOLOCK)
			ORDER BY T.SETUP_CATEGORY_ID
		END

		-- SETUP_MATRIX_PLANT
		-- Param1 = DIVISION_ID, Param2 = GroupID, Param3 = UserID
		IF @Code = 'SETUP_MATRIX_PLANT'

		BEGIN
			SELECT
			   DISTINCT
			   T.PLANT_ID AS CODE
			  ,P.FACTORY_NAME AS NAME
			FROM SCM_MST_SETUP_MATRIX_SN T WITH(NOLOCK)
			JOIN SCM_MST_FACTORY_SN P  WITH(NOLOCK) ON T.COMPANY_ID = P.COMPANY_ID AND T.DIVISION_ID = P.DIVISION_ID AND T.SITE_ID = P.SITE_ID AND T.PLANT_ID = P.PLANT_ID
			WHERE (@Param1 IS NULL OR T.DIVISION_ID IN
					( SELECT token FROM dbo.String_Split(@Param1,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
					--CROSS APPLY x.nodes('/t') t(c)
					)
				  )
			  AND T.PLANT_ID IN (SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param2 AND UserID = @Param3 AND AuthType = 'P' AND
				 (@Param1 IS NULL OR PrntCode IN
					( SELECT token FROM dbo.String_Split(@Param1,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
					--CROSS APPLY x.nodes('/t') t(c)
					)
				  )
				--PrntCode = @Param1 AND
			  )
			ORDER BY T.PLANT_ID

		END

		-- SETUP_MATRIX_OPERATION
		-- Param1 = DIVISION_ID, Param2 = PLANT_ID
		IF @Code = 'SETUP_MATRIX_OPERATION'

		BEGIN
			SELECT
				 DISTINCT
				 T.OPERATION_ID AS CODE
				,O.OPERATION_NAME AS NAME
			FROM SCM_MST_SETUP_MATRIX_SN T WITH(NOLOCK)
			JOIN SCM_MST_OPERATION_SN O  WITH(NOLOCK) ON T.COMPANY_ID = O.COMPANY_ID AND T.DIVISION_ID = O.DIVISION_ID AND T.SITE_ID = O.SITE_ID AND T.OPERATION_ID = O.OPERATION_ID
			WHERE

				(@Param1 = '' OR T.DIVISION_ID IN
					( SELECT token FROM dbo.String_Split(@Param1,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--	FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
					--	CROSS APPLY x.nodes('/t') t(c)
					)
				)
				AND (@Param2 = '' OR T.PLANT_ID IN
					( SELECT token FROM dbo.String_Split(@Param2,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--	FROM   (SELECT x = CAST('<t>' + REPLACE(@Param2, ',', '</t><t>') + '</t>' AS xml)) b
					--	CROSS APPLY x.nodes('/t') t(c)
					)
				)

			ORDER BY T.OPERATION_ID
		END


		-- SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID
		-- Param1 = DIVISION_ID, Param2 = PLANT_ID, Param3 = OPERATION_ID
		IF @Code = 'SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID'

		BEGIN
			SELECT
			     DISTINCT
				 T.FROM_ITEM_SETUP_GROUP_ID AS CODE
				,T.FROM_ITEM_SETUP_GROUP_ID AS NAME
			FROM SCM_MST_SETUP_MATRIX_SN T WITH(NOLOCK)
			WHERE

				(@Param1 = '' OR T.DIVISION_ID IN
					( SELECT token FROM dbo.String_Split(@Param1,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--	FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
					--	CROSS APPLY x.nodes('/t') t(c)
					)
				)
				AND (@Param2 = '' OR T.PLANT_ID IN
					( SELECT token FROM dbo.String_Split(@Param2,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--	FROM   (SELECT x = CAST('<t>' + REPLACE(@Param2, ',', '</t><t>') + '</t>' AS xml)) b
					--	CROSS APPLY x.nodes('/t') t(c)
					)
				)
				AND (@Param3 = '' OR T.OPERATION_ID IN
					( SELECT token FROM dbo.String_Split(@Param3,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--	FROM   (SELECT x = CAST('<t>' + REPLACE(@Param3, ',', '</t><t>') + '</t>' AS xml)) b
					--	CROSS APPLY x.nodes('/t') t(c)
					)
				)
			ORDER BY T.FROM_ITEM_SETUP_GROUP_ID
		END

		-- SETUP_MATRIX_TO_ITEM_SETUP_GROUP_ID
		-- Param1 = DIVISION_ID, Param2 = PLANT_ID, Param3 = OPERATION_ID
		IF @Code = 'SETUP_MATRIX_TO_ITEM_SETUP_GROUP_ID'

		BEGIN
			SELECT
				DISTINCT
				T.TO_ITEM_SETUP_GROUP_ID AS CODE
			   ,T.TO_ITEM_SETUP_GROUP_ID AS NAME
			FROM SCM_MST_SETUP_MATRIX_SN T WITH(NOLOCK)
			WHERE

				(@Param1 = '' OR T.DIVISION_ID IN
					( SELECT token FROM dbo.String_Split(@Param1,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--	FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
					--	CROSS APPLY x.nodes('/t') t(c)
					)
				)
				AND (@Param2 = '' OR T.PLANT_ID IN
					(SELECT token FROM dbo.String_Split(@Param2,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--	FROM   (SELECT x = CAST('<t>' + REPLACE(@Param2, ',', '</t><t>') + '</t>' AS xml)) b
					--	CROSS APPLY x.nodes('/t') t(c)
					)
				)
				AND (@Param3 = '' OR T.OPERATION_ID IN
					( SELECT token FROM dbo.String_Split(@Param3,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--	FROM   (SELECT x = CAST('<t>' + REPLACE(@Param3, ',', '</t><t>') + '</t>' AS xml)) b
					--	CROSS APPLY x.nodes('/t') t(c)
					)
				)
			ORDER BY T.TO_ITEM_SETUP_GROUP_ID
		END

		-- SETUP_MATRIX_SETUP_CONDITION
		-- Param1 = DIVISION_ID, Param2 = PLANT_ID, Param3 = OPERATION_ID, Param4 = FROM_ITEM_SETUP_GROUP_ID, Param5 = TO_ITEM_SETUP_GROUP_ID
		IF @Code = 'SETUP_MATRIX_SETUP_CONDITION'

		BEGIN
			SELECT
				 DISTINCT
				 T.SETUP_CONDITION_ID AS CODE
				,T.SETUP_CONDITION_ID AS NAME
			FROM SCM_MST_SETUP_MATRIX_SN T WITH(NOLOCK)
			WHERE

				(@Param1 = '' OR T.DIVISION_ID IN
					(SELECT token FROM dbo.String_Split(@Param1,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--	FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
					--	CROSS APPLY x.nodes('/t') t(c)
					)
				)
				AND (@Param2 = '' OR T.PLANT_ID IN
					( SELECT token FROM dbo.String_Split(@Param2,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--	FROM   (SELECT x = CAST('<t>' + REPLACE(@Param2, ',', '</t><t>') + '</t>' AS xml)) b
					--	CROSS APPLY x.nodes('/t') t(c)
					)
				)
				AND (@Param3 = '' OR T.OPERATION_ID IN
					( SELECT token FROM dbo.String_Split(@Param3,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--	FROM   (SELECT x = CAST('<t>' + REPLACE(@Param3, ',', '</t><t>') + '</t>' AS xml)) b
					--	CROSS APPLY x.nodes('/t') t(c)
					)
				)
				AND (@Param4 = '' OR T.FROM_ITEM_SETUP_GROUP_ID IN
					( SELECT token FROM dbo.String_Split(@Param4,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--	FROM   (SELECT x = CAST('<t>' + REPLACE(@Param4, ',', '</t><t>') + '</t>' AS xml)) b
					--	CROSS APPLY x.nodes('/t') t(c)
					)
				)
				AND (@Param5 = '' OR T.TO_ITEM_SETUP_GROUP_ID IN
					( SELECT token FROM dbo.String_Split(@Param5,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--	FROM   (SELECT x = CAST('<t>' + REPLACE(@Param5, ',', '</t><t>') + '</t>' AS xml)) b
					--	CROSS APPLY x.nodes('/t') t(c)
					)
				)
		   ORDER BY T.SETUP_CONDITION_ID
		END


		-- CALENDAR_DAY
		IF @Code = 'CalendarDay'
		BEGIN
				SELECT
					 q.BASIS_YYYYMMDD as code, q.date_full_name name
				FROM scm_sys_calendar_m q with(nolock)
				WHERE 1=1
				AND q.basis_yyyymmdd >= @Param1
				AND q.basis_yyyymmdd <= @Param2
		END


		-- CALENDAR_WEEK
		IF @Code = 'CalendarWeek'

		BEGIN
				SELECT
					 q.CALENDAR_MONTH + '/'+ q.CALENDAR_DAY +'('+ DAYOFWEEK +')' as CODE
					,q.week_name +'|'+ q.basis_yyyymmdd as NAME
				FROM scm_sys_calendar_m q with(nolock)
				WHERE 1=1
				AND q.basis_yyyymmdd >= @Param1
				AND q.basis_yyyymmdd <= @Param2

		END

		-- CALENDAR_MONTH
		IF @Code = 'CalendarMonth'

		BEGIN
				SELECT distinct q.basis_yyyymm as code
					  ,convert( varchar(7), q.basis_date ,120) as name
				FROM scm_sys_calendar_m q with(nolock)
				WHERE 1=1
				AND q.basis_yyyymm >= @Param1
				AND q.basis_yyyymm <= @Param2
				order by code, name
		END

		-- PERIOD_DEFAULT (당주 ~ 4주)
		IF @Code = 'PERIOD_DEFAULT'

		BEGIN
			--SELECT
			--(
			--	SELECT MIN(BASIS_YYYYMMDD) FROM [SCM_SYS_CALENDAR_M]
			--	WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, GETDATE(), 112), 0, 7) AND ISO_WEEK IN
			--	(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M] WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, GETDATE(), 112) )
			--) AS FROM_VALUE
			--,
			--(
			--	SELECT MAX(BASIS_YYYYMMDD) FROM [SCM_SYS_CALENDAR_M]
			--	WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, GETDATE() + (7 * 3), 112), 0, 7) AND ISO_WEEK IN
			--	(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M] WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, GETDATE() + (7 * 3), 112))
			--) AS TO_VALUE
			SELECT
			(
				SELECT MIN(BASIS_YYYYMMDD) FROM [SCM_SYS_CALENDAR_M]
				WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR,  dbo.FN_MULTY_TIME(@TimeZone), 112), 0, 7) AND ISO_WEEK IN
				(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M]  WITH(NOLOCK) WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone), 112) )
			) AS FROM_VALUE
			,
			(
				SELECT MAX(BASIS_YYYYMMDD) FROM [SCM_SYS_CALENDAR_M]
				WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR,  dbo.FN_MULTY_TIME(@TimeZone) + (7 * 3), 112), 0, 7) AND ISO_WEEK IN
				(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M]  WITH(NOLOCK) WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR,  dbo.FN_MULTY_TIME(@TimeZone) + (7 * 3), 112))
			) AS TO_VALUE
		END

		-- PERIOD_YESTERDAY
		IF @Code = 'PERIOD_YESTERDAY'

		BEGIN
			--SELECT CONVERT(VARCHAR, GETDATE() - 1 , 112) FROM_VALUE, CONVERT(VARCHAR, GETDATE(), 112) TO_VALUE
			SELECT CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone) - 1 , 112) FROM_VALUE, CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone), 112) TO_VALUE
		END

		-- PERIOD_TOMORROW
		IF @Code = 'PERIOD_TOMORROW'

		BEGIN
			--SELECT CONVERT(VARCHAR, GETDATE(), 112) FROM_VALUE, CONVERT(VARCHAR, GETDATE() + 1, 112) TO_VALUE
			SELECT CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone), 112) FROM_VALUE, CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone) + 1, 112) TO_VALUE
		END

		-- PERIOD_LASTWEEK
		IF @Code = 'PERIOD_LASTWEEK'

		BEGIN
			--SELECT MIN(BASIS_YYYYMMDD) FROM_VALUE, MAX(BASIS_YYYYMMDD) TO_VALUE FROM [SCM_SYS_CALENDAR_M]
			--WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, GETDATE() - 7, 112), 0, 7) AND ISO_WEEK IN
			--(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M]
			--	WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, GETDATE() - 7, 112)
			--)

			SELECT MIN(BASIS_YYYYMMDD) FROM_VALUE, MAX(BASIS_YYYYMMDD) TO_VALUE FROM [SCM_SYS_CALENDAR_M] WITH(NOLOCK)
			WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone) - 7, 112), 0, 7) AND ISO_WEEK IN
			(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
				WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone) - 7, 112)
			)
		END

		-- PERIOD_NEXTWEEK
		IF @Code = 'PERIOD_NEXTWEEK'

		BEGIN
			--SELECT MIN(BASIS_YYYYMMDD) FROM_VALUE, MAX(BASIS_YYYYMMDD) TO_VALUE FROM [SCM_SYS_CALENDAR_M]
			--WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, GETDATE() + 7, 112), 0, 7) AND ISO_WEEK IN
			--(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M]
			--	WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, GETDATE() + 7, 112)
			--)
			SELECT MIN(BASIS_YYYYMMDD) FROM_VALUE, MAX(BASIS_YYYYMMDD) TO_VALUE FROM [SCM_SYS_CALENDAR_M] WITH(NOLOCK)
			WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone) + 7, 112), 0, 7) AND ISO_WEEK IN
			(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
				WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone) + 7, 112)
			)
		END

		-- PERIOD_LASTMONTH
		IF @Code = 'PERIOD_LASTMONTH'

		BEGIN
			--SELECT CONVERT(VARCHAR, DATEADD(MM, DATEDIFF(MM,0,GETDATE()) - 1, 0), 112) FROM_VALUE, CONVERT(VARCHAR, DATEADD(MS,-3,DATEADD(MM, DATEDIFF(MM,0,GETDATE()  ), 0)), 112) TO_VALUE
			SELECT CONVERT(VARCHAR, DATEADD(MM, DATEDIFF(MM,0,dbo.FN_MULTY_TIME(@TimeZone)) - 1, 0), 112) FROM_VALUE, CONVERT(VARCHAR, DATEADD(MS,-3,DATEADD(MM, DATEDIFF(MM,0,dbo.FN_MULTY_TIME(@TimeZone)  ), 0)), 112) TO_VALUE
		END

		-- PERIOD_NEXTMONTH
		IF @Code = 'PERIOD_NEXTMONTH'

		BEGIN
			--SELECT CONVERT(VARCHAR, DATEADD(MM, DATEDIFF(MM,0,GETDATE()) + 1, 0), 112) FROM_VALUE, CONVERT(VARCHAR, DATEADD(S,-1,DATEADD(MM, DATEDIFF(M,0,GETDATE()) + 2,0)) , 112) TO_VALUE
			SELECT CONVERT(VARCHAR, DATEADD(MM, DATEDIFF(MM,0,dbo.FN_MULTY_TIME(@TimeZone)) + 1, 0), 112) FROM_VALUE, CONVERT(VARCHAR, DATEADD(S,-1,DATEADD(MM, DATEDIFF(M,0,dbo.FN_MULTY_TIME(@TimeZone)) + 2,0)) , 112) TO_VALUE
		END


	    -- PERIOD2_DEFAULT (당주 ~ 4주)
		IF @Code = 'PERIOD2_DEFAULT'

		BEGIN
			SELECT
			(
				SELECT MIN(BASIS_YYYYMMDD) FROM [SCM_SYS_CALENDAR_M] WITH(NOLOCK)
				WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, convert(datetime,@Param1), 112), 0, 7) AND ISO_WEEK IN
				(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M]  WITH(NOLOCK) WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, convert(datetime,@Param1), 112) )
			) AS FROM_VALUE
			,
			(
				SELECT MAX(BASIS_YYYYMMDD) FROM [SCM_SYS_CALENDAR_M]
				WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, convert(datetime,@Param1) + (7 * 3), 112), 0, 7) AND ISO_WEEK IN
				(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M]  WITH(NOLOCK) WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, convert(datetime,@Param1) + (7 * 3), 112))
			) AS TO_VALUE
		END

		-- PERIOD2_YESTERDAY
		IF @Code = 'PERIOD2_YESTERDAY'

		BEGIN
			SELECT CONVERT(VARCHAR, convert(datetime,@Param1) - 1 , 112) FROM_VALUE, CONVERT(VARCHAR, convert(datetime,@Param1), 112) TO_VALUE
		END

		-- PERIOD2_TOMORROW
		IF @Code = 'PERIOD2_TOMORROW'

		BEGIN
			SELECT CONVERT(VARCHAR, convert(datetime,@Param1), 112) FROM_VALUE, CONVERT(VARCHAR, convert(datetime,@Param1) + 1, 112) TO_VALUE
		END

		-- PERIOD2_LASTWEEK
		IF @Code = 'PERIOD2_LASTWEEK'

		BEGIN
			SELECT MIN(BASIS_YYYYMMDD) FROM_VALUE, MAX(BASIS_YYYYMMDD) TO_VALUE FROM [SCM_SYS_CALENDAR_M] WITH(NOLOCK)
			WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, convert(datetime,@Param1) - 7, 112), 0, 7) AND ISO_WEEK IN
			(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
			WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, convert(datetime,@Param1) - 7, 112)
			)
		END

		-- PERIOD2_NEXTWEEK
		IF @Code = 'PERIOD2_NEXTWEEK'

		BEGIN
			SELECT MIN(BASIS_YYYYMMDD) FROM_VALUE, MAX(BASIS_YYYYMMDD) TO_VALUE FROM [SCM_SYS_CALENDAR_M] WITH(NOLOCK)
			WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, convert(datetime,@Param1) + 7, 112), 0, 7) AND ISO_WEEK IN
			(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
			WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, convert(datetime,@Param1) + 7, 112)
			)
		END

		-- PERIOD2_LASTMONTH
		IF @Code = 'PERIOD2_LASTMONTH'

		BEGIN
			SELECT CONVERT(VARCHAR, DATEADD(MM, DATEDIFF(MM,0,convert(datetime,@Param1)) - 1, 0), 112) FROM_VALUE, CONVERT(VARCHAR, DATEADD(MS,-3,DATEADD(MM, DATEDIFF(MM,0,convert(datetime,@Param1)  ), 0)), 112) TO_VALUE
		END

		-- PERIOD2_NEXTMONTH
		IF @Code = 'PERIOD2_NEXTMONTH'

		BEGIN
			SELECT CONVERT(VARCHAR, DATEADD(MM, DATEDIFF(MM,0,convert(datetime,@Param1)) + 1, 0), 112) FROM_VALUE, CONVERT(VARCHAR, DATEADD(S,-1,DATEADD(MM, DATEDIFF(M,0,convert(datetime,@Param1)) + 2,0)) , 112) TO_VALUE
		END


	-- 2018.1 : UI Category Setup - Data Sort Method (DESC / ASC / null)
	if @Code = 'DATA_SORT_METHOD'
	begin
		SELECT
			SEGMENT1 AS CODE,
			SEGMENT2 AS NAME
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'DATA_SORT_METHOD'
		ORDER BY DISPLAY_SEQ
	end
	-- 2018.1 : UI Category Setup - Default Flag ( Y or ' '(blank or null)
	if @Code = 'DEFAULT_FLAG'
	begin
		SELECT
			SEGMENT1 as code ,
			SEGMENT2 as name
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'DEFAULT_FLAG'
		ORDER BY DISPLAY_SEQ
	end

	IF @Code = 'CELL_CONTROL_OBJECT_TYPE_CODE'
	BEGIN
		SELECT
			SEGMENT1 as code ,
			SEGMENT2 as name
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'CELL_CONTROL_OBJECT_TYPE_CODE'
		ORDER BY DISPLAY_SEQ
	END

	IF @Code = 'HORIZONTAL_ALIGN_CODE'
	BEGIN
		SELECT
			SEGMENT1 as code ,
			SEGMENT2 as name
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'HORIZONTAL_ALIGN_CODE'
		ORDER BY DISPLAY_SEQ
	END

		/*===============================================
		용		 도:  BIZ TYPE 조회
		사 용 화 면:  PLAN 화면 공통
		변       수:  -
		최 초 작 성:  2018. 02. 24
		개  발  자 :  진 준 희
		최 종 작 성:  2018. 02. 24
		수  정  자 :  진 준 희
		수 정 사 항:  LOOKUP TABLE 변경
		===============================================*/


	if @Code = 'BIZ_TYPE'
	begin
		select
			SEGMENT1 as code ,
			SEGMENT2 as name
		from SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		where LOOKUP_TYPE ='BIZ_TYPE_BPMS'
		order by DISPLAY_SEQ
	end


	if @Code = 'PortBySite'
	begin
		SELECT SEGMENT1 AS CODE,
				SEGMENT2 AS NAME
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		where LOOKUP_TYPE ='PORT_CODE'
		order by DISPLAY_SEQ
	end

	if @Code = 'ItemBySite'
	begin
		select
			ITEM_ID as code ,
			ITEM_ID as name
		from SCM_MST_SITE_ITEM t
		where  1=1
		and			(@Param1 = '' OR T.DIVISION_ID IN
					( SELECT token FROM dbo.String_Split(@Param1,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--	FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
					--	CROSS APPLY x.nodes('/t') t(c)
					)
				)
				AND (@Param2 = '' OR T.scm_site_id IN
					( SELECT token FROM dbo.String_Split(@Param2,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--	FROM   (SELECT x = CAST('<t>' + REPLACE(@Param2, ',', '</t><t>') + '</t>' AS xml)) b
					--	CROSS APPLY x.nodes('/t') t(c)
					)
				)

	end

	if @Code = 'BucketType'
	begin
		    SELECT L.SEGMENT1  AS CODE
			     , L.SEGMENT2  AS NAME
			FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
			WHERE  1 = 1
			AND    L.LOOKUP_TYPE = 'BUCKET_TYPE_CODE'
			ORDER BY L.DISPLAY_SEQ
	end

	if @Code = 'UploadUOM'
	begin
		SELECT
				SEGMENT1 AS CODE,
				SEGMENT2 AS NAME
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		where LOOKUP_TYPE ='UPLOAD_UOM_TYPE_CODE'
		order by DISPLAY_SEQ
	end



   if @Code = 'SpreadTitle'
	begin
		select
			*
		from SCM_MST_SHEET_COLUMNS T1  WITH(NOLOCK)


		where  1=1
		AND T1.PROGRAM_ID =@PARAM1
		AND T1.SHEET_NAME = @PARAM2
		order by SORT_ORDER_NO

		


	end

	IF @CODE = 'StorageID'
	BEGIN
		SELECT distinct STORAGE_ID CODE
		  ,(STORAGE_ID + '  ' + STORAGE_DESCRIPTION) NAME
		FROM SCM_MST_SLOC WITH(NOLOCK)
		WHERE  1=1
			AND	(@Param1 = '' OR DIVISION_ID = @Param1)
			AND (@Param2 = '' OR PLANT_ID = @Param2)
		-- E20260316-000026 HQ05-W PLANT 계획 수립위한 ERP 재고 SLOC 추가 요청 - 다른 플랜트에서 SLOC 참고할수 있게 처리
		UNION 
		SELECT distinct STORAGE_ID CODE
		  ,(STORAGE_ID + '  ' + STORAGE_DESCRIPTION) NAME
		FROM SCM_MST_SLOC WITH(NOLOCK)
		WHERE  1=1
		AND DIVISION_ID = @Param1
		AND PLANT_ID IN (
			SELECT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE LOOKUP_TYPE = 'PLANT_SLOC_REF'
			AND SEGMENT2 = @Param2
		)

	END


	IF @CODE = 'Location'
	BEGIN
		--SELECT B.LOOKUP_CODE CODE, B.DESCRIPTION NAME
		--FROM SCM_ADM_LOOKUP_TYPE A WITH(NOLOCK)
		--INNER JOIN SCM_ADM_LOOKUP_VALUES B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE
		--WHERE A.LOOKUP_TYPE = 'LOCATION_GROUP'
		--  AND @Param1 = '' OR B.SEGMENT1 = @Param1
		--ORDER BY B.DISPLAY_SEQ

		SELECT B.SEGMENT1 CODE, B.SEGMENT2 NAME
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE
		WHERE A.LOOKUP_TYPE = 'LOCATION_GROUP'
			AND (@Param1 = '' OR B.SEGMENT3 = @Param1)
		ORDER BY B.DISPLAY_SEQ

	END


	IF @CODE = 'TeambyDivision'
	BEGIN

		DEClARE @TeambyDivision_Lang NVARCHAR(200)
		SELECT @TeambyDivision_Lang = Language
		FROM dbo.TB_FX_User
		WHERE UserID = @Param3

		SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')

		IF @Param1 = ''
			SET @Param1 = 'ALL';

		IF (@Param1 <> '40') -- 20180615 수정. Division 분기
		BEGIN
			SELECT DISTINCT
				B.DEPT_ID       AS CODE
				-- Modify by ytchoi 180310
				, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN
				                            WHEN 'CN' THEN B.DEPT_NAME_CN
											ELSE B.DEPT_NAME_KO
											END
				AS NAME
				--, SUBSTRING(B.DEPT_NAME_KO  ,CHARINDEX('.',B.DEPT_NAME_KO )+1, len(B.DEPT_NAME_KO ) ) AS NAME
			FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK)
				, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)
			WHERE  A.SITE_TYPE = 'SALES'
			AND    A.DEPT_ID  = B.DEPT_ID
			AND    CASE WHEN @Param1 = 'ALL' THEN 'ALL'
				ELSE A.DIVISION_ID
				END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
				--SELECT t.c.value('.', 'NVARCHAR(4000)')
			--                  FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
			--                  CROSS APPLY x.nodes('/t') t(c)
					)
			AND    A.DIVISION_ID IN (SELECT CODE
					FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					WHERE  GroupID LIKE '%'+ @Param2 + '%'
					AND    UserID  LIKE '%'+ @Param3 + '%'
					AND    AuthType = 'D')
			ORDER BY  NAME,CODE		--20190609
		END
		ELSE
		BEGIN
			-- 20180615 수정. 소형 Division 추가
			select distinct c.dept_id AS CODE
				, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN
				            WHEN 'CN' THEN C.DEPT_NAME_CN
							ELSE C.DEPT_NAME_KO
							END AS NAME
			  from scm_mst_site_item a  WITH(NOLOCK)
			      ,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)
				  ,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)
			 where -- a.owner = b.user_id
			   b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )
			   and b.dept_id = c.dept_id
			   and a.division_id = '40'
			  order by NAME

            /*
			SELECT DISTINCT
				B.DEPT_ID       AS CODE
				, B.DEPT_NAME_KO  AS NAME
			FROM   [dbo].[SCM_MST_SITE] A WITH(NOLOCK)
			INNER JOIN [dbo].[SCM_MST_SITE_ITEM] ITEM WITH(NOLOCK)
			ON A.DIVISION_ID = ITEM.DIVISION_ID AND A.SCM_SITE_ID = ITEM.SCM_SITE_ID
			LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)
			ON B.DEPT_ID  = CASE WHEN A.DIVISION_ID <> '40' THEN A.DEPT_ID
											ELSE (
							SELECT su.DEPT_ID
						FROM [dbo].[SCM_MST_SSO_USER_INFO] su
					WHERE su.user_id = ITEM.OWNER
							)
					END
			WHERE  A.SITE_TYPE = 'SALES'
			AND    CASE WHEN @Param1 = 'ALL' THEN 'ALL'
				ELSE A.DIVISION_ID
				END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
					)
			AND    A.DIVISION_ID IN (SELECT CODE
					FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					WHERE  GroupID LIKE '%'+ @Param2 + '%'
					AND    UserID  LIKE '%'+ @Param3 + '%'
					AND    AuthType = 'D')
			ORDER BY CODE, NAME
			*/

		END
	END

	IF @CODE = 'ItemType'
	BEGIN

		SET @Param1 = 'ITEM_TYPE_CODE';

	    DECLARE @tITC TABLE (CODE NVARCHAR(100), NAME NVARCHAR(100))
	    INSERT @tITC EXEC SCM0001_GET_LOOKUP_VALUES @Param1
		SELECT * FROM @tITC

	END

	IF @CODE = 'PlantSitebyEndCustomer'
	BEGIN
	    SELECT DISTINCT
	           SCM_SITE_ID AS CODE
		     , SCM_SITE_ID AS NAME
		FROM   SCM_MST_SITE A
		WHERE  1 = 1
		AND    A.SITE_TYPE = 'PLANT'
		AND CASE	  WHEN @Param1 = 'ALL'	OR @Param1 = ''THEN @Param1
					  ELSE A.DIVISION_ID
            END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
					 /*SELECT t.c.value('.', 'NVARCHAR(4000)')
                        FROM   (SELECT x = CAST('<t>' + REPLACE( CASE @Param1 WHEN '' THEN 'ALL'ELSE @Param1 END , ',', '</t><t>') + '</t>' AS xml)) b
                        CROSS APPLY x.nodes('/t') t(c)*/
                    )
		AND CASE	  WHEN @Param2 = 'ALL'	OR @Param2 = ''THEN @Param2
					  ELSE A.END_CUSTOMER
            END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')
					 /*SELECT t.c.value('.', 'NVARCHAR(4000)')
                        FROM   (SELECT x = CAST('<t>' + REPLACE( CASE @Param1 WHEN '' THEN 'ALL'ELSE @Param1 END , ',', '</t><t>') + '</t>' AS xml)) b
                        CROSS APPLY x.nodes('/t') t(c)*/
                    )
        AND    A.DIVISION_ID IN (SELECT CODE
	                             FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
							     WHERE  GroupID LIKE @Param3 + '%'
						    	 AND    UserID  LIKE @Param4 + '%'
								 AND    AuthType = 'D')

	END;

	IF @CODE = 'Module'
	BEGIN
		SELECT DISTINCT B.SEGMENT1 CODE
				,B.SEGMENT3 NAME
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'
		WHERE A.LOOKUP_TYPE = @Param1 -- 'SMS_MAIL_SEND_SYSTEM'
			AND A.VALID_YN = 'Y'
	END;

	IF @CODE = 'SubModule'
	BEGIN
	    SELECT B.SEGMENT2 CODE
				,B.SEGMENT4 NAME
				,B.SEGMENT1 SYSTEM_CODE
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'
		WHERE A.LOOKUP_TYPE = @Param1 --'SMS_MAIL_SEND_SYSTEM'
		    AND (ISNULL(@Param2,'') = '' OR B.SEGMENT1 = @Param2)
			AND A.VALID_YN = 'Y'
		ORDER BY B.DISPLAY_SEQ

	END;



	IF @CODE = 'Cycle'
	BEGIN
	    SELECT B.SEGMENT1 CODE
				,B.SEGMENT3 NAME
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'
		WHERE A.LOOKUP_TYPE = @Param1 --'MAIL_SEND_CYCLE'
			AND A.VALID_YN = 'Y'
		ORDER BY B.DISPLAY_SEQ

	END;

	IF @CODE = 'CycleSub1'
	BEGIN
	    SELECT B.SEGMENT2 CODE
				,B.SEGMENT3 NAME
				,B.SEGMENT1 CYCLE_CODE
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'
		WHERE A.LOOKUP_TYPE = @Param1 --'MAIL_SEND_CYCLE_DETAIL'
			AND A.VALID_YN = 'Y'
		ORDER BY B.SEGMENT1, B.DISPLAY_SEQ

	END;

	IF @CODE = 'CycleSub2'
	BEGIN
	    SELECT B.SEGMENT2 CODE
				,B.SEGMENT3 NAME
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'
		WHERE A.LOOKUP_TYPE = @Param1 --'MAIL_SEND_CYCLE_DETAIL'
			AND A.VALID_YN = 'Y'
			AND B.SEGMENT1 = 'DAY'
		ORDER BY B.SEGMENT1, B.DISPLAY_SEQ

	END;


	IF @CODE = 'CycleSub2_v2'
	BEGIN
	    SELECT B.SEGMENT2 CODE
				,B.SEGMENT3 NAME
				,B.SEGMENT1 CYCLE_CODE
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'
		WHERE A.LOOKUP_TYPE = @Param1 --'MAIL_SEND_CYCLE_DETAIL'
			AND A.VALID_YN = 'Y'
			AND B.SEGMENT1 IN ('DAY','HOUR')
		ORDER BY B.SEGMENT1, B.DISPLAY_SEQ

	END;

	IF @CODE = 'CycleSub3'
	BEGIN
	    SELECT B.SEGMENT2 CODE
				,B.SEGMENT3 NAME
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'
		WHERE A.LOOKUP_TYPE = @Param1 --'MAIL_SEND_CYCLE_DETAIL'
			AND A.VALID_YN = 'Y'
			AND B.SEGMENT1 = 'HOUR'
		ORDER BY B.SEGMENT1, B.DISPLAY_SEQ

	END;

	--IF @CODE = 'NoticeCycleSub1'
	--BEGIN
	--    SELECT B.SEGMENT2 CODE
	--			,B.SEGMENT3 NAME
	--			,B.SEGMENT1 CYCLE_CODE
	--	FROM SCM_ADM_LOOKUP_MASTER A
	--	INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'
	--	WHERE A.LOOKUP_TYPE = 'NOTICE_SEND_CYCLE_DETAIL'
	--		AND A.VALID_YN = 'Y'
	--	ORDER BY B.SEGMENT1, B.DISPLAY_SEQ

	--END;

	--IF @CODE = 'NoticeCycleSub2'
	--BEGIN
	--    SELECT B.SEGMENT2 CODE
	--			,B.SEGMENT3 NAME
	--	FROM SCM_ADM_LOOKUP_MASTER A
	--	INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'
	--	WHERE A.LOOKUP_TYPE = 'NOTICE_SEND_CYCLE_DETAIL'
	--		AND A.VALID_YN = 'Y'
	--		AND B.SEGMENT1 = 'DAY'
	--	ORDER BY B.SEGMENT1, B.DISPLAY_SEQ

	--END;


		/*===============================================
		용		 도:  Measure  FPComboBox 조회
		사 용 화 면: DMF0053(CUST Fcst Waterfall 조회)
                     DMF0003(MKT_FCST 조회)
                     DMF0035(MKT FCST Waterfall 조회)
		변       수:
		최 초 작 성:
		개 발  자 :
		최 종 작 성:  2023. 12. 07
		수  정  자 :  kcw3408
		수 정 사 항:   COLUMN_LABEL_NAME 간격조정
		===============================================*/
	IF @CODE = 'Measure'
	BEGIN
	    SELECT A.COLUMN_NAME        AS CODE
             , CASE WHEN  A.COLUMN_NAME IN ('CUST_FCST_EDI_ORG')
			        THEN  N' └ ' + 'EDI[Org.]'
					WHEN  A.COLUMN_NAME IN ('CUST_FCST_EDI') AND @Param1 IN ( 'DMF0053')
			        THEN  N' └ ' + 'EDI'
					WHEN  A.COLUMN_NAME IN ('CUST_FCST_EDI')
			        THEN  N' └ ' + 'EDI'
					ELSE A.COLUMN_LABEL_NAME
			   END AS NAME
        FROM [dbo].[SCM_MST_SHEET_MEASURE] A WITH(NOLOCK)
        WHERE 1 = 1
        AND   PROGRAM_ID = @Param1
        AND   SHEET_NAME = @Param2
		AND    VALID_YN = 'Y'  --20191118 추가
		UNION ALL
		SELECT --DISTINCT  modified by ytchoi MS-SQL Distinct 할때 대소문자 무시
		       MEASURE AS CODE
			 , concat(N' └ ',MEASURE) AS NAME -- modified by ytchoi 180310
		FROM   [dbo].[DM_MST_CUSTOMER_FCST] WITH(NOLOCK)
		WHERE  1 = 1
		AND  VALID_YN = 'Y'
		AND    MEASURE <> ''
		AND    MEASURE_GROUP = 'CUST_FCST'
		AND   @Param1 IN ( 'DMF0003', 'DMF0035','DMF0003_TEST' )
		GROUP BY MEASURE  --20191118 추가
		-- 20191118 KHSONG [CSR ID:4098705] GSCM(DM)에서 Incoterms 조건에 따라 Customer EDI의 DP 반영 요청의 건 (BEGIN)
		UNION ALL
		SELECT	'Immidiate'				AS CODE	, N'    └ ' + 'Immidiate'				AS NAME

		UNION ALL
		SELECT	'Planning_Forecast'		AS CODE	, N'    └ ' + 'Planning_Forecast'		AS NAME

		UNION ALL
		SELECT	'Commercial_Agreement'	AS CODE	, N'    └ ' + 'Commercial_Agreement'	AS NAME

		UNION ALL
		SELECT 'Firm_Temp'    AS CODE , N'    └ ' + 'Firm_Temp'    AS NAME

		UNION ALL
		SELECT 'Manumacturing_Material_Temp'  AS CODE , N'    └ ' + 'Manumacturing_Material_Temp'  AS NAME

		UNION ALL
		SELECT 'Material_Temp' AS CODE , N'    └ ' + 'Material_Temp' AS NAME

		UNION ALL
		SELECT 'Backorder' AS CODE , N'    └ ' + 'Backorder' AS NAME

		UNION ALL
		SELECT 'Cust.FCST_EXCEL[P+P]' AS CODE , N' └ ' + 'EXCEL' AS NAME

		UNION ALL
		SELECT 'Cust.FCST_RPA[P+P]' AS CODE , N' └ ' + 'RPA' AS NAME

		UNION ALL
		SELECT 'Immidiate[Org.]'    AS CODE , N'    └ ' + 'Immidiate[Org.]'    AS NAME

		UNION ALL
		SELECT 'Planning_Forecast[Org.]'  AS CODE , N'    └ ' + 'Planning_Forecast[Org.]'  AS NAME

		UNION ALL
		SELECT 'Commercial_Agreement[Org.]' AS CODE , N'    └ ' + 'Commercial_Agreement[Org.]' AS NAME

		UNION ALL
		SELECT 'Firm_Temp[Org.]'    AS CODE , N'    └ ' + 'Firm_Temp[Org.]'    AS NAME

		UNION ALL
		SELECT 'Manumacturing_Material_Temp[Org.]'  AS CODE , N'    └ ' + 'Manumacturing_Material_Temp[Org.]'  AS NAME

		UNION ALL
		SELECT 'Material_Temp[Org.]' AS CODE , N'    └ ' + 'Material_Temp[Org.]' AS NAME

		UNION ALL
		SELECT 'Backorder[Org.]' AS CODE , N'    └ ' + 'Backorder[Org.]' AS NAME

		UNION ALL
		SELECT 'Cust.FCST_EXCEL[Org.]' AS CODE , N' └ ' + 'EXCEL[Org.]' AS NAME

		UNION ALL
		SELECT 'Cust.FCST_RPA[Org.]' AS CODE , N' └ ' + 'RPA[Org.]' AS NAME

		UNION ALL
		SELECT 'Cust.FCST_EXCEL' AS CODE , N' └ ' + 'EXCEL' AS NAME

		UNION ALL
		SELECT 'Cust.FCST_RPA' AS CODE , N' └ ' + 'RPA' AS NAME

		UNION ALL
		SELECT	'Ship Plan'	AS CODE	, N'Ship Plan'	AS NAME		-- [C20210112-000446]
		--[E20241126-000426]_CUST_FCST안에 CUST_FCST_EDI를 포함한다. START		
		UNION ALL
		SELECT	'CUST_FCST_EDI'	AS CODE	, N' └ ' + 'EDI' AS NAME	
		--[E20241126-000426]_CUST_FCST안에 CUST_FCST_EDI를 포함한다. END		
		-- 20191118 KHSONG [CSR ID:4098705] GSCM(DM)에서 Incoterms 조건에 따라 Customer EDI의 DP 반영 요청의 건 (END)
	END;


	IF @CODE = 'MeasureGroup'
	BEGIN
	    SELECT DISTINCT
		       A.SMALL_CLASS_LABEL_NAME  AS CODE
             , A.SMALL_CLASS_LABEL_NAME  AS NAME
        FROM [dbo].[SCM_MST_SHEET_MEASURE] A WITH(NOLOCK)
        WHERE 1 = 1
        AND   PROGRAM_ID = @Param1
        AND   SHEET_NAME = @Param2

	END;


	/*===============================================
		용		 도:  SITE MASTER 화면 신규 ROW INSERT 시 SOLDTO_CODE컬럼  조회
		사 용 화 면:  DM0004_SCM_MST_SITE		   -	MAIN SPREAD END_CUSTOMER 컬럼
		변       수:  --
		최 초 작 성:  2018. 02. 08
		개  발  자 :  진   준	희
		최 종 작 성:  2018. 02. 08
		수  정  자 :  진   준	희
		수 정 사 항:  신규 콤보 박스 추가
					2020.10.15 hwi1993 [C20201008-000332] 정렬순서 수정 ( 코드순으로 )
		===============================================*/
	IF @Code = 'SoldCustomer'
	BEGIN
		SELECT SEGMENT2 AS CODE
		     , SEGMENT3 AS NAME
		FROM   SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
		WHERE  LOOKUP_TYPE = 'SOLD_CUSTOMER'
		AND    (@Param1 = '' OR SEGMENT1    = @Param1)
		ORDER BY SEGMENT2
	END

	IF @Code = 'DeptId'
	BEGIN
		  SELECT DISTINCT
				 B.DEPT_ID       AS CODE
			   , B.DEPT_NAME_KO  AS NAME
		  FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK)
			   , [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)
		  WHERE  A.DEPT_ID  = B.DEPT_ID
				AND A.SITE_TYPE = 'SALES'

		  -- 20180619 추가
		  UNION ALL

		  SELECT DISTINCT
				B.DEPT_ID       AS CODE
			, B.DEPT_NAME_KO  AS NAME
		  FROM   [dbo].[SCM_MST_SITE_ITEM]          A WITH(NOLOCK)
		  join [dbo].[SCM_MST_SSO_DEPT_INFO] B  WITH(NOLOCK)
		  ON B.DEPT_ID  = (
					SELECT SU.DEPT_ID
					FROM [dbo].[SCM_MST_SSO_USER_INFO] su
					WHERE SU.USER_ID = A.OWNER
				)
		  -- 20180619 추가
	END

	IF @Code = 'UpperDeptId'
	BEGIN
		  SELECT DISTINCT
				 D.DEPT_ID       AS CODE
			   , D.DEPT_NAME_KO  AS NAME
		  FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK)
			   , [dbo].[SCM_MST_SSO_DEPT_INFO] D WITH(NOLOCK)
			   , [dbo].[SCM_MST_SSO_DEPT_INFO] T WITH(NOLOCK)
		  WHERE  A.DEPT_ID  = T.DEPT_ID
		  AND    D.DEPT_ID  = T.UPPER_DEPT_ID
		  AND    A.SITE_TYPE = 'SALES'
	END

	IF @Code = 'DivisionByUser'
	BEGIN
		SELECT DIVISION_ID AS CODE, MIN([DIVISION_NAME]) AS NAME
		FROM   [dbo].[SCM_MST_DIVISION]
		WHERE  1 = 1
		--AND    (@Param1 IS NULL OR DIVISION_ID LIKE '%' + @Param1 + '%') OR (@Param1 IS NULL OR DIVISION_NAME LIKE '%' + @Param1 + '%')
		AND    DIVISION_ID IN ( SELECT CODE
		                        FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
								WHERE  1 = 1
								AND    ( GroupID LIKE '%' + @Param2 + '%' )
								AND    ( UserID  LIKE '%' + @Param3 + '%' )
								AND    AuthType = 'D')
		GROUP BY DIVISION_ID
		ORDER BY DIVISION_ID
	END

	IF @Code = 'MeasureGroupByUser'
	BEGIN
	    SELECT DISTINCT
               C.SMALL_CLASS_LABEL_NAME AS CODE
             , C.SMALL_CLASS_LABEL_NAME AS NAME
        FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
             , [dbo].[SCM_MST_SHEET_MEASURE] C WITH(NOLOCK)
        WHERE  1 = 1
        AND    U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = @Param1
        AND    U.SHEET_NAME  = @Param2
        AND    U.USER_ID     = @Param3
     AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
	END

	IF @Code = 'MeasureByUser'
	BEGIN
	    SELECT U.COLUMN_NAME       AS CODE
             , C.COLUMN_LABEL_NAME AS NAME
        FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
             , [dbo].[SCM_MST_SHEET_MEASURE] C WITH(NOLOCK)
        WHERE  1 = 1
     AND    U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = @Param1
        AND    U.SHEET_NAME  = @Param2
        AND    U.USER_ID     = @Param3
		AND    C.SMALL_CLASS_LABEL_NAME LIKE @Param4 + '%'
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
	END

	IF @Code = 'VersionNo'
	BEGIN
	   SELECT 'CURRENT' AS CODE, 'Current' AS NAME
	   UNION ALL
	   SELECT [VERSION_NO] AS CODE
		     ,[VERSION_NO] AS NAME
		 FROM [dbo].[DM_MST_VERSION] WITH(NOLOCK)
		where 1=1
		  and ( (@Param1 IS NULL OR @Param1 = '') OR DIVISION_ID   IN (SELECT token FROM dbo.String_Split(@Param1	,',')) )
		  and [VERSION_NO] like 'MF_%'
       /* -- Modified by ytchoi 180309
	   SELECT VERSION_NO AS CODE
             ,VERSION_NO AS NAME
       FROM DBO.DM_PLN_MKT_FCST_C
       WHERE 1=1
         --AND ( isnull(@Param1, '' ) = '' OR DIVISION_ID   IN (SELECT token FROM dbo.String_Split(@Param1	,',')) )
         --AND ( isnull(@Param2, '' ) = '' OR SCM_SITE_ID   IN (SELECT token FROM dbo.String_Split(@Param2	,',')) )
         --AND ( isnull(@Param3, '' ) = '' OR PLANT_SITE_ID IN (SELECT token FROM dbo.String_Split(@Param3	,',')) )
         --AND ( isnull(@Param4, '' ) = '' OR PROJECT_CODE  IN (SELECT token FROM dbo.String_Split(@Param4	,',')) )
        -- AND ( isnull(@Param5, '' ) = '' OR ITEM_ID       IN (SELECT token FROM dbo.String_Split(@Param5	,',')) )
         AND ( (@Param1 IS NULL OR @Param1 = '') OR DIVISION_ID   IN (SELECT token FROM dbo.String_Split(@Param1	,',')) )
         AND ( (@Param2 IS NULL OR @Param2 = '') OR SCM_SITE_ID   IN (SELECT token FROM dbo.String_Split(@Param2	,',')) )
         AND ( (@Param3 IS NULL OR @Param3 = '') OR PLANT_SITE_ID IN (SELECT token FROM dbo.String_Split(@Param3	,',')) )
         AND ( (@Param4 IS NULL OR @Param4 = '') OR PROJECT_CODE  IN (SELECT token FROM dbo.String_Split(@Param4	,',')) )
		 AND ( (@Param5 IS NULL OR @Param5 = '') OR ITEM_ID       IN (SELECT token FROM dbo.String_Split(@Param5	,',')) )
       GROUP BY VERSION_NO,VERSION_NO
	   */
       ORDER BY NAME;

	END

		IF @Code = 'VersionNo_SalesPlan'
	BEGIN
	   SELECT 'SP_Z_CURRENT' AS CODE, 'Current' AS NAME
	   UNION ALL
	   SELECT [VERSION_NO] AS CODE
		     ,[VERSION_NO] AS NAME
		 FROM [dbo].[DM_MST_VERSION] WITH(NOLOCK)
		where 1=1
		  --and ( (@Param1 IS NULL OR @Param1 = '') OR DIVISION_ID   IN (SELECT token FROM dbo.String_Split(@Param1	,',')) )
		  and DIVISION_ID   IN (SELECT token FROM dbo.String_Split(@Param1	,','))
		  and [VERSION_NO] like 'SP_%'
      /* -- Modified by ytchoi 180309
	   SELECT VERSION_NO AS CODE
             ,VERSION_NO AS NAME
       FROM DBO.DM_PLN_SALES_PLAN_C
       WHERE 1=1
         AND ( (@Param1 IS NULL OR @Param1 = '') OR DIVISION_ID   IN (SELECT token FROM dbo.String_Split(@Param1	,',')) )
		-- AND CASE WHEN @Param2 = 'ALL' THEN 'ALL'
		--   		 ELSE SCM_SITE_ID
		--	END IN (
		--			Select * from dbo.UF_FX_String_SplitForIN (@Param2,',') as P Where
		--			(CASE WHEN @Param2 = 'ALL' THEN 'ALL' ELSE SCM_SITE_ID END) = P.data
	 --              )
		--AND CASE WHEN @Param3 = 'ALL' THEN 'ALL'
		--   		 ELSE PLANT_SITE_ID
		--	END IN (
		--			Select * from dbo.UF_FX_String_SplitForIN (@Param3,',') as P Where
		--			(CASE WHEN @Param3 = 'ALL' THEN 'ALL' ELSE PLANT_SITE_ID END) = P.data
	 --              )
         AND ( (@Param2 IS NULL OR @Param2 = 'ALL') OR SCM_SITE_ID   IN (SELECT token FROM dbo.String_Split(@Param2	,',')) )
         AND ( (@Param3 IS NULL OR @Param3 = 'ALL') OR PLANT_SITE_ID IN (SELECT token FROM dbo.String_Split(@Param3	,',')) )
AND ( (@Param4 IS NULL OR @Param4 = '') OR PROJECT_CODE  IN (SELECT token FROM dbo.String_Split(@Param4	,',')) )
		 AND ( (@Param5 IS NULL OR @Param5 = '') OR ITEM_ID       IN (SELECT token FROM dbo.String_Split(@Param5	,',')) )
       GROUP BY VERSION_NO,VERSION_NO
	   */
       ORDER BY CODE DESC;

	END

	IF @Code = 'BizTypeByDivision'
	BEGIN
	   		select
			SEGMENT1 as code ,
			SEGMENT2 as name
		from SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		where LOOKUP_TYPE ='BIZ_TYPE_BPMS'
		order by DISPLAY_SEQ
     /*   AND    CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN ''

 	           END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
						 /*SELECT t.c.value('.', 'NVARCHAR(4000)')
                         FROM   (SELECT x = CAST('<t>' + REPLACE( CASE @Param1 WHEN '' THEN 'ALL'ELSE @Param1 END , ',', '</t><t>') + '</t>' AS xml)) b
                         CROSS APPLY x.nodes('/t') t(c)*/
	                   )
        AND    DIVISION_ID IN (SELECT CODE
		                       FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
							   WHERE  GroupID LIKE @Param2 + '%'
							   AND   UserID  LIKE @Param3 + '%'
							   AND    AuthType = 'D')
*/
	END

	IF @CODE = 'TeambyAll'
	BEGIN
	    IF @Param1 = ''
		    SET @Param1 = 'ALL';

		SELECT DISTINCT
               B.DEPT_ID       AS CODE
             , B.DEPT_NAME_KO  AS NAME
        FROM   [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)

	END

	/*===============================================
		용		 도:  SITE MASTER 화면 신규 ROW INSERT 시 END_CUSTOMER컬럼  조회
		사 용 화 면:  DM0004_SCM_MST_SITE		   -	MAIN SPREAD END_CUSTOMER 컬럼
		변       수:  --
		최 초 작 성:  2018. 02. 08
		개  발  자 :  진   준	희
		최 종 작 성:  2018. 02. 08
		수  정  자 :  진   준	희
		수 정 사 항:  신규 콤보 박스 추가
		===============================================*/
	IF @Code = 'EndCustomer'
	BEGIN
		SELECT SEGMENT2 AS CODE
		     , SEGMENT3 AS NAME
		FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
		AND    (@Param1 = '' OR SEGMENT1    = @Param1)
		AND VALID_YN = 'Y' --20190129 ADD
		ORDER BY DISPLAY_SEQ
	END

	IF @Code = 'UpperDept_DeptByScmSiteID'
	BEGIN
		SELECT
			C.SCM_SITE_ID
			,isnull(DEPRTMENT.DEPT_ID,'')AS UPPER_DEPT_ID
			,isnull(TEAM.DEPT_ID,'')AS DEPT_ID

		FROM (SELECT * FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y' AND SITE_TYPE = 'SALES') AS C
		LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y') AS TEAM
			ON C.DEPT_ID = TEAM.DEPT_ID
		LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y') AS DEPRTMENT
			ON TEAM.UPPER_DEPT_ID = DEPRTMENT.DEPT_ID
		WHERE
		C.SCM_SITE_ID = @Param1 --'Audi_BE_BRU'
	END

	/*===============================================
		용		 도:  Lookup 화면 System 콤보 조회
		사 용 화 면:  SCM0003_Lookup		   -	MAIN SPREAD System 컬럼
		변       수:  --
		최 초 작 성:  2018. 02. 09
		개  발  자 :  김   영   곤
		최 종 작 성:  2018. 02. 09
		수  정  자 :
		수 정 사 항:
		===============================================*/
	IF @Code = 'System'
	BEGIN
		SELECT B.SEGMENT1 CODE
			  ,B.SEGMENT2 NAME
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
		WHERE A.LOOKUP_TYPE = 'SYSTEM'
		  AND A.VALID_YN = 'Y'
		ORDER BY B.DISPLAY_SEQ
	END

	/*===============================================
		용		 도:  LookUp 테이블 Code, Name 공통 조회
		사 용 화 면:
		변       수:  --
		최 초 작 성:  2018. 02. 09
		개  발  자 :  김   영   곤
		최 종 작 성:  2018. 02. 09
		수  정  자 :
		수 정 사 항:
		===============================================*/
	IF @Code = 'LookupCommon'
	BEGIN
		SELECT B.SEGMENT1 CODE
			  ,B.SEGMENT2 NAME
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
		WHERE A.LOOKUP_TYPE = @Param1
		  AND A.VALID_YN = 'Y'
		ORDER BY B.DISPLAY_SEQ
	END

	/*===============================================
		용		 도:  FCST TYPE LOOKUP COMBO BOX
		사 용 화 면:  DM0001_DM_PLN_MKT_FCST	-	FCST_TYPE컬럼
					  DM0004_DM_PLN_CUST_FCST	-	FCST_TYPE컬럼
		변       수:  -
		최 초 작 성:  2018. 02	.14
		개  발  자 :  황 승 재
		최 종 작 성:  -
		수  정  자 :  -
		수 정 사 항:
		===============================================*/
	IF @Code = 'FCST_TYPE'
	BEGIN
		SELECT SEGMENT1 AS CODE,
		SEGMENT2 AS NAME,
		DISPLAY_SEQ
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE VALID_YN = 'Y'
		AND LOOKUP_TYPE = 'SALES_TYPE_CODE'
		ORDER BY DISPLAY_SEQ
	END

	/*===============================================
		용		 도:  DOM_EXP LOOKUP COMBO BOX
		사 용 화 면:  DM0001_DM_PLN_MKT_FCST	-	FCST_TYPE컬럼
					  DM0004_DM_PLN_CUST_FCST	-	FCST_TYPE컬럼
		변       수:  -
		최 초 작 성:  2018. 02. 14
		개  발  자 :  황 승 재
		최 종 작 성:  -
		수  정  자 :  -
		수 정 사 항:
		===============================================*/

	IF @Code = 'DOM_EXP'
	BEGIN
		SELECT B.SEGMENT1 CODE
			  ,B.SEGMENT2 NAME
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
		WHERE A.LOOKUP_TYPE = 'DOM/EXP'
		  AND A.VALID_YN = 'Y'
		ORDER BY B.DISPLAY_SEQ
	END

	/*===============================================
		용		 도:  PlanDate LOOKUP COMBO BOX
		사 용 화 면:  SCP0011	-	Plan Date
		변       수:  -
		최 초 작 성:  2018. 02. 19
		개  발  자 :  박 진 수
		최 종 작 성:  2021. 04. 07
		수  정  자 :  khj79
		수 정 사 항:  version_id 조건 추가
		===============================================*/

	IF @Code = 'PlanDate'
	BEGIN
		SELECT plan_start_yyyymmdd AS code
	  	 	  ,CONVERT(char(10), dbo.FN_CHAR_TO_DATE(plan_start_yyyymmdd),121) AS name
		  FROM SCP_PLAN_VERSION_V WITH(NOLOCK)
		WHERE division_id=@Param1
		  AND (( @Param2 IS NULL OR  @Param2='' ) OR version_id = @Param2 )
		GROUP BY plan_start_yyyymmdd
		ORDER BY plan_start_yyyymmdd DESC
	END

	/*===============================================
		용		 도:  PlanTYPE LOOKUP COMBO BOX
		사 용 화 면:  SCP0011	-	Plan TYPE
		변       수:  -
		최 초 작 성:  2018. 02. 19
		개  발  자 :  박 진 수
		최 종 작 성:  2021. 04. 07
		수  정  자 :  khj79
		수 정 사 항:  version_id 조건 추가
		===============================================*/

	IF @Code = 'PlanType'
	BEGIN
		SELECT plan_type as code
			 , plan_type as name
			 ,max(plan_type_order) as plan_type_order
		FROM SCP_PLAN_VERSION_V WITH(NOLOCK)
		WHERE 1=1
		  and division_id         = @Param1
		  and ( ( @Param2 IS NULL OR  @Param2='' ) OR plan_start_yyyymmdd = @Param2 )
		  AND ( ( @Param3 IS NULL OR  @Param3='' ) OR version_id		  = @Param3 )
		GROUP BY plan_type
		order by plan_type_order
	END;
	/*===============================================
		용		 도:  PlanSeq LOOKUP COMBO BOX
		사 용 화 면:  SCP0011	-	Plan SEQ
		변       수:  -
		최 초 작 성:  2018. 02. 19
		개  발  자 :  박 진 수
		최 종 작 성:  2021. 04. 07
		수  정  자 :  khj79
		수 정 사 항:  version_id 조건 추가
		===============================================*/
	IF @Code = 'PlanSeq'
	BEGIN
		SELECT plan_seq as CODE
	  		  -- ,convert(varchar, plan_seq)+ ' - ' + isnull(confirm_flag,'N') AS NAME
			    ,( convert(varchar, plan_seq)+ ' - ' + (case when confirm_flag is null or confirm_flag ='' then 'N'
														  when confirm_flag = 'Y' then 'Confirm' end) )AS NAME
		 FROM SCP_PLAN_VERSION_V WITH(NOLOCK)
		WHERE 1=1
		  and division_id  = @Param1
		  and ( ( @Param2 IS NULL OR  @Param2='' ) OR plan_start_yyyymmdd = @Param2 )
		  and ( ( @Param3 IS NULL OR  @Param3='' ) OR plan_type           = @Param3 )
		  AND ( ( @Param4 IS NULL OR  @Param4='' ) OR version_id		  = @Param4 )
		GROUP BY plan_seq,confirm_flag
		ORDER BY plan_seq DESC
	END;
	   /*===============================================
		용		 도:  PlanDate Shipment
		사 용 화 면:  SSP0001	-	Plan Date
		변       수:  -
		최 초 작 성:  2018. 04. 16
		개  발  자 :  박 진 수
		최 종 작 성:  -
		수  정  자 :  -
		수 정 사 항:
		===============================================*/

	IF @Code = 'PlanDateShip'
	BEGIN

	  IF @Param2 = 'P'
			BEGIN
				SELECT DISTINCT TOP 20 A.PLAN_START_YYYYMMDD AS CODE , convert(VARCHAR(10), convert(DATETIME, A.PLAN_START_YYYYMMDD),121) name
				FROM
				(
					SELECT CONVERT(CHAR(8), DATEADD(DD, 1, CONVERT(VARCHAR, ATTRIBUTE1, 121)), 112)   as PLAN_START_YYYYMMDD
					FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL]
					WHERE LOOKUP_TYPE = 'SSP_ANL_SHIP_PLAN_P'

					UNION ALL

					SELECT DISTINCT PLAN_START_YYYYMMDD
					FROM [DBO].[SSP_ANL_SHIP_PLAN_P] WITH(NOLOCK)
					WHERE DIVISION_ID = '40'
				) A
				ORDER BY 1 DESC
			END
		ELSE
			BEGIN
				 SELECT TOP 20 plan_start_yyyymmdd code
				,convert(VARCHAR(10), convert(DATETIME, plan_start_yyyymmdd),121) name
				FROM [dbo].[SSP_PLAN_VERSION_V] WITH(NOLOCK)
				WHERE CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1
								ELSE division_id
 						   END  IN ( SELECT token FROM dbo.String_Split(@Param1,',') )
				GROUP BY plan_start_yyyymmdd
				ORDER BY plan_start_yyyymmdd DESC;
			END

	  /*
		기존 코드 백업(21.10.07)
		SELECT TOP 20 plan_start_yyyymmdd code
			,convert(VARCHAR(10), convert(DATETIME, plan_start_yyyymmdd),121) name
		FROM SSP_PLAN_VERSION_V WITH(NOLOCK)
		WHERE CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1
                        ELSE division_id
 	               END  IN ( SELECT token FROM dbo.String_Split(@Param1,',') )
		GROUP BY plan_start_yyyymmdd
		ORDER BY plan_start_yyyymmdd DESC;
	  */

	END

/*===============================================
		용		 도:  PlanTypeShip LOOKUP COMBO BOX
		사 용 화 면:  SSP	-	Plan TYPE
		변       수:  -
		최 초 작 성:  2018. 06. 14
		개  발  자 :  박 진 수
		최 종 작 성:  -
		수  정  자 :  -
		수 정 사 항:
		===============================================*/

	IF @Code = 'PlanTypeShip'
	BEGIN
		SELECT plan_type as code
			 , plan_type as name
			 --,max(plan_type_order) as plan_type_order
			 ,'1' as plan_type_order
		FROM SSP_PLAN_VERSION_V WITH(NOLOCK)
		WHERE 1=1
		  and division_id   = @Param1
		  and ( ( @Param2 IS NULL OR  @Param2='' ) OR plan_start_yyyymmdd = @Param2 )
		GROUP BY plan_type
		order by plan_type_order
	END;
	/*===============================================
		용		 도:  PlanSeq LOOKUP COMBO BOX
		사 용 화 면:  SSP	-	Plan SEQ
		변       수:  -
		최 초 작 성:  2018. 06. 14
		개  발  자 :  박 진 수
		최 종 작 성:  -
		수  정  자 :
		수 정 사 항:
		===============================================*/
	IF @Code = 'PlanSeqShip'
	BEGIN
		SELECT plan_seq as CODE
	  		  -- ,convert(varchar, plan_seq)+ ' - ' + isnull(confirm_flag,'N') AS NAME
			    ,( convert(varchar, plan_seq)+ ' - ' + (case when confirm_flag is null or confirm_flag ='' then 'N'
														 when confirm_flag = 'Y' then 'Confirm' end) )AS NAME
		 FROM SSP_PLAN_VERSION_V WITH(NOLOCK)
		WHERE 1=1
		  and division_id  = @Param1
		  and ( ( @Param2 IS NULL OR  @Param2='' ) OR plan_start_yyyymmdd = @Param2 )
		  and ( ( @Param3 IS NULL OR  @Param3='' ) OR plan_type           = @Param3 )
		GROUP BY plan_seq,confirm_flag
		ORDER BY plan_seq DESC
	END;

	/*===============================================
		용		 도:  Plant Site 반환(Division, Operation Group별)
		사 용 화 면:  SCP0011	-	Plant Site
		변       수:  -
		최 초 작 성:  2018. 02. 19
		개  발  자 :  박 진 수
		최 종 작 성:  -
		수  정  자 :  -
		수 정 사 항:
		===============================================*/
	IF @Code = 'PlantByDivisionOperation'
	BEGIN
		 SELECT A.SCM_SITE_ID AS CODE
			   --,A.SITE_DESCRIPTION AS NAME
			   ,A.SCM_SITE_ID + '   '+A.SITE_DESCRIPTION AS NAME
		  FROM  [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		 WHERE  1 = 1
		   AND  A.VALID_YN ='Y'
		   AND  A.SITE_TYPE = 'PLANT'
		   AND  ( ( @Param1 IS NULL OR  @Param1='' ) OR  A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')) )
		   AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )
		   --JV 용 AND 조건 추가 (lgda106 김승일 21.07.02)
		   AND  ( ( @Param3 <> 'JV Planner' ) OR  A.PLANT_ID IN ( SELECT token FROM dbo.String_Split(@Param4,',')) )
          ORDER BY CODE
	END;
	/*===============================================
		용		 도:  Plant Year 반환(Division별)
		사 용 화 면:  SCP0015	-	Plan Management
		변       수:  -
		최 초 작 성:  2018. 02. 23
		개  발  자 :  박 진 수
		최 종 작 성:  -
		수  정  자 :  -
		수 정 사 항:
		===============================================*/
	IF @Code = 'PlanYear'
	BEGIN
		SELECT DISTINCT SUBSTRING(plan_version_id,1,4 ) AS code
			   ,SUBSTRING(plan_version_id,1,4 ) AS name
		FROM dbo.[FN_SCP_PLAN_VERSION_V](@Param1,'','','')
		ORDER BY code DESC
	END;

	/*===============================================
		용		 도:  Plant Week 반환(Division, Year별)
		사 용 화 면:  SCP0015	-	Plan Management
		변       수:  -
		최 초 작 성:  2018. 02. 23
		개  발  자 :  박 진 수
		최 종 작 성:  -
		수  정  자 :  -
		수 정 사 항:
		===============================================*/
	IF @Code = 'PlanWeek'
	BEGIN
		SELECT   B.WEEK_NAME AS CODE
				,plan_start_yyyymmdd +'-' + B.WEEK_NAME AS name
		FROM  dbo.[FN_SCP_PLAN_VERSION_V](@Param1,'', @Param2,'') a  JOIN
				 scm_sys_calendar_m b  WITH(NOLOCK) ON  a.plan_start_yyyymmdd = b.basis_yyyymmdd
		WHERE    1=1
		--AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  b.calendar_yyyy = @Param2)
		GROUP BY plan_start_yyyymmdd
			   , b.WEEK_NAME
		ORDER BY name DESC ;
	END;

    /*===============================================
		용		 도:  Customer FCST에 등록된 Measure 반환
		사 용 화 면:  DM0014    -    Customer FCST Upload
		변       수:  -
		최 초 작 성:  2018. 02. 23
		개  발  자 :  Songdh
		최 종 작 성:  -
		수  정  자 :  -
		수 정 사 항:
		===============================================*/
	IF @Code = 'CustomerMeasure'
	    BEGIN
		    SELECT DISTINCT
			       CF.MEASURE  AS CODE
			     , CF.MEASURE  AS NAME
			FROM   [dbo].[DM_MST_CUSTOMER_FCST] CF WITH(NOLOCK)
			WHERE  1 = 1
			AND    CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1
                        ELSE CF.DIVISION_ID
 	               END  IN ( SELECT token FROM dbo.String_Split(@Param1,',') )
			AND    CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2
          ELSE CF.CUSTOMER_CODE
 	               END  IN ( SELECT token FROM dbo.String_Split(@Param2,',') )
            AND    CASE WHEN @Param3 = 'ALL' OR @Param3 = '' THEN @Param3
      ELSE CF.SCM_SITE_ID
 	               END  IN ( SELECT token FROM dbo.String_Split(@Param3,',') )
            AND    CASE WHEN @Param4 = 'ALL' OR @Param4 = '' THEN @Param4
                        ELSE CF.UPLOAD_BUCKET_TYPE
 	               END  IN ( SELECT token FROM dbo.String_Split(@Param4,',') )
			AND    CASE WHEN @Param5 = 'ALL' OR @Param5 = '' THEN @Param5
                        ELSE CF.MEASURE_GROUP
 	               END  IN ( SELECT token FROM dbo.String_Split(@Param5,',') )
			AND    CF.MEASURE <> ''
			AND    CF.VALID_YN = 'Y'
		END;

	/*===============================================
	용		 도:  Customer FCST에서 사용할 PSI Data
	사 용 화 면:  DM0007    -    Customer FCST Master
	변       수:  -
	최 초 작 성:  2018. 02. 27
	개  발  자 :  Songdh
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'CustomerPSI'
	    BEGIN
		    SELECT L.SEGMENT1  AS CODE
			     , L.SEGMENT2  AS NAME
			FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
			WHERE  1 = 1
			AND    L.LOOKUP_TYPE = 'CUSTOMER_PSI_TYPE'
			ORDER BY L.DISPLAY_SEQ
		END;


	/*===============================================
	MktFcstEditMeasure
	용		 도:  MKT FCST에서 수정 할 수 있는 Measure
	사 용 화 면:  DM0003    -    MKT FCST
	변       수:  - @Param1 = DIVISION_ID, @Param2 = SCM_SITE_ID
	최 초 작 성:  2018. 02. 27
	개  발  자 :  Songdh
	최 종 작 성:  - 2020.07.16
	수  정  자 :  - hwi1993
	수 정 사 항:  [C20200713-000189] [VMI-in Req] VMI Biz의 경우 VMI-in Req 입력을 통한 MKT FCST 자동산출 로직 추가
				2020/09/10     hwi1993		[C20200909-000212] ESS Cau 사이트에서 VMI Req 메저 안나오는 현상 수정
				2020/10/15		hwi1993		[C20201015-000200] VMi 원복 (원본은 C20200713-000189 ). 원복하기로 해서 프로시저는 삭제하지 않고, Agent 에서만 제거함.
	===============================================*/

	-- 20200306 KHSONG MktFcstEditMeasure40 부분을 주석처리하고 하나로 통합/TMM Measure관련 추가
	-- INSERT MEASURE 선택
	-- Parameter 설정현황 : @Param1 : DIVISION_ID / @Param2 : SCM_SITE_ID / @Param3 : PROJECT_CODE / @Param4 : USER_ID
	IF @Code = 'MktFcstEditMeasure'
	    BEGIN
			DECLARE @MKT_FCST_MEASURE_VMI_YN NCHAR(1) = N'N'	-- VMI 를 위한 변수

			-- 2020.11.17 [C20201103-000114]
			-- @Param5 에 메저값을 받으면 해당 메저만 그대로 리턴한다.
			IF ( @PARAM1 = '82' AND ISNULL(@PARAM5,'') <> '')
			BEGIN
				SELECT SEGMENT2 AS CODE, SEGMENT3 AS NAME
				FROM [SCM_ADM_LOOKUP_MASTER_DETAIL]
				WHERE LOOKUP_TYPE = 'MKT_FCST_MEASURE'
					AND SEGMENT1 = @PARAM1
					AND SEGMENT2 = @PARAM5

			END
			ELSE
			BEGIN
				SELECT @MKT_FCST_MEASURE_VMI_YN = VMI_YN
				FROM scm_mst_site
				WHERE DIVISION_ID =@PARAM1
					AND SCM_SITE_ID = @PARAM2
					--AND DIVISION_ID = '40'	[C20200909-000212]

				-- TMM제외한 일반 MEASURE 추출
				SELECT
				  L.SEGMENT2  AS CODE  -- Measure코드
				, L.SEGMENT3  AS NAME  -- 사용자 입력 Measure명
				, L.DISPLAY_SEQ
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
					WHERE 1=1
					AND L.LOOKUP_TYPE	= 'MKT_FCST_MEASURE'
					AND L.VALID_YN		= 'Y'
					AND L.ATTRIBUTE2   <> 'Y'       -- TMM Measure여부
					AND L.SEGMENT1		= @Param1   -- Division_id
					AND SEGMENT4		= 'Y'       -- INSERT_YN 여부
					--[C20201015-000200]
					AND (( @MKT_FCST_MEASURE_VMI_YN = 'N' AND L.ATTRIBUTE1  <> 'Y' ) OR ( @MKT_FCST_MEASURE_VMI_YN = 'Y' ))
					----[C20200713-000189] [VMI-in Req] VMI Biz의 경우 VMI-in Req 입력을 통한 MKT FCST 자동산출 로직 추가
					--AND (	(@Param1 = '40' AND (( @MKT_FCST_MEASURE_VMI_YN = 'N' AND L.ATTRIBUTE1  <> 'Y' ) OR ( @MKT_FCST_MEASURE_VMI_YN = 'Y' AND L.ATTRIBUTE1  = 'Y')))
					--		OR (@Param1 <> '40' AND (( @MKT_FCST_MEASURE_VMI_YN = 'N' AND L.ATTRIBUTE1  <> 'Y' ) OR ( @MKT_FCST_MEASURE_VMI_YN = 'Y' )))
					--	)
					--AND ( L.ATTRIBUTE1  = 'ALL'     -- Vmi외의 Measure
					--	OR L.ATTRIBUTE1 = case when ( select count(1)  from scm_mst_site a WITH(NOLOCK) where a.VMI_YN = 'Y' and a.DIVISION_ID = @Param1 and a.SCM_SITE_ID = @Param2 ) > 0 THEN 'Y' ELSE 'N' END)  -- Vmi Measure선택조건
				----------
				UNION ALL
				----------

				--CUST_FCST MEASURE 추출
				SELECT T.CODE  -- Measure코드
					 , T.NAME  -- 사용자 입력 Measure명
					 , ROW_NUMBER() OVER (ORDER BY T.CODE) + 900 AS DISPLAY_SEQ
				FROM   (SELECT DISTINCT
							   CF.MEASURE              AS CODE
							 , CONCAT(N' └ ',MEASURE) AS NAME
						FROM   [dbo].[DM_MST_CUSTOMER_FCST] CF WITH(NOLOCK)
						WHERE  1 = 1
						AND    CF.VALID_YN      = 'Y'
						AND   CF.MEASURE_GROUP = 'CUST_FCST'
						AND    CF.DIVISION_ID   = @Param1
						AND    CF.SCM_SITE_ID   = @Param2
					   ) T
				----------
				UNION ALL
				----------

				--TMM Measure 추출
				SELECT
					  L.SEGMENT2  AS CODE  -- Measure코드
					, L.SEGMENT3  AS NAME  -- 사용자 입력 Measure명
					, L.DISPLAY_SEQ
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
					INNER JOIN (SELECT TOP 1 VALID_YN,SEGMENT1,SEGMENT2,SEGMENT4 FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK) WHERE 1=1
									AND LOOKUP_TYPE	= 'TMM_MEASURE_ADMIN'
									AND VALID_YN	= 'Y'
									AND SEGMENT1	= @Param1	-- Division_id (@Param1)
									AND SEGMENT2	= @Param3	-- Project_Code (@Param3)
									AND SEGMENT4	= @Param4	-- UserId (@Param4)
									) T
						ON
						(
							L.SEGMENT1 = T.SEGMENT1  -- Division_id
						AND L.VALID_YN = T.VALID_YN
						AND L.LOOKUP_TYPE	= 'MKT_FCST_MEASURE'
						AND L.VALID_YN		= 'Y'
						AND L.SEGMENT1		= @Param1	-- Division_id (@Param1)
						AND L.ATTRIBUTE2    = 'Y'	-- TMM Measure여부
						AND L.SEGMENT4	  = 'Y'	-- INSERT_YN 여부
						)

				ORDER BY DISPLAY_SEQ
			END

		END;
	/*===============================================
	용		 도:  SALES PLAN, WATERFALL
	사 용 화 면:  DM0020,21
	변       수:  -
	최 초 작 성:  2018. 02. 28
	개  발  자 :  SeungJae.Hwang
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'SALES_PLAN_AMOUNT_KRW'
	    BEGIN
			SELECT SEGMENT1 AS CODE,
					SEGMENT2 AS NAME
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE VALID_YN = 'Y'
			AND LOOKUP_TYPE = 'SALES_PLAN_AMOUNT_KRW'
			ORDER BY DISPLAY_SEQ
		END;
	/*===============================================
	용		 도:  SALES PLAN, WATERFALL
	사 용 화 면:  DM0020,21
	변       수:  -
	최 초 작 성:  2018. 02. 28
	개  발  자 :  SeungJae.Hwang
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'SALES_PLAN_AMOUNT_USD'
	    BEGIN
			SELECT SEGMENT1 AS CODE,
					SEGMENT2 AS NAME
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE VALID_YN = 'Y'
			AND LOOKUP_TYPE = 'SALES_PLAN_AMOUNT_USD'
			ORDER BY DISPLAY_SEQ
		END;
	/*===============================================
	용		 도:  SALES PLAN, WATERFALL
	사 용 화 면:  DM0020,21
	변       수:  -
	최 초 작 성:  2018. 02. 28
	개  발  자 :  SeungJae.Hwang
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'SALES_PLAN_AMOUNT_LOC'
	    BEGIN
			SELECT SEGMENT1 AS CODE,
					SEGMENT2 AS NAME
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE VALID_YN = 'Y'
			AND LOOKUP_TYPE = 'SALES_PLAN_AMOUNT_LOC'
			ORDER BY DISPLAY_SEQ
		END;
	/*===============================================
	용		 도:  SALES PLAN
	사 용 화 면:  DM0020,21
	변       수:  -
	최 초 작 성:  2018. 02. 28
	개  발  자 :  SeungJae.Hwang
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'SALES_PLAN_ITEM_ID'
	    BEGIN
			--SELECT LOOKUP_CODE AS CODE, [DESCRIPTION] AS NAME, DISPLAY_SEQ
			--FROM [dbo].[SCM_ADM_LOOKUP_VALUES]
			--WHERE VALID_YN = 'Y'
			--AND LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
			--ORDER BY DISPLAY_SEQ
			SELECT SEGMENT1 AS CODE,
					SEGMENT2 AS NAME,
					SEGMENT3 AS GUBUN
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE VALID_YN = 'Y'
			AND LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'
			ORDER BY DISPLAY_SEQ
		END;
    /*===============================================
	용		 도:  ESS CHANNGE PSI DIVISION_ID
	사 용 화 면:  DM0026
	변       수:  -
	최 초 작 성:  2018. 03. 05
	개  발  자 :  Songdh
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'ESS_DIVISION_ID'
	    BEGIN
		    SELECT D.DIVISION_ID    AS CODE
			     , D.DIVISION_NAME  AS NAME
			FROM   [dbo].[SCM_MST_DIVISION] D WITH(NOLOCK)
			WHERE  1 = 1
			AND    D.DIVISION_ID = '82'
			AND    DIVISION_ID IN (SELECT CODE
			                       FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
								   WHERE  GroupID = @Param1 AND UserID = @Param2 AND AuthType = 'D')

		END;

	/*===============================================
	용		 도:  ESS CHANNGE PSI SCM_SITE_ID
	사 용 화 면:  DM0026
	변       수:  -
	최 초 작 성:  2018. 03. 05
	개  발  자 :  Songdh
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'ESS_SCM_SITE_ID'
	    BEGIN
		    SELECT DISTINCT
			       EC.SCM_SITE_ID  AS CODE
			     , EC.SCM_SITE_ID  AS NAME
			FROM   [dbo].[DM_PLN_ESS_CHANNEL_PSI] EC WITH(NOLOCK)
			WHERE  1 = 1
			AND    EC.DIVISION_ID = '82'

		END;

	/*===============================================
	용		 도:  ESS CHANNGE PSI ITEM_ID
	사 용 화 면:  DM0026
	변       수:  -
	최 초 작 성:  2018. 03. 06
	개  발  자 :  Songdh
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'ESS_ITEM_ID'
	    BEGIN
		    SELECT DISTINCT
			       EC.ITEM_ID  AS CODE
			     , EC.ITEM_ID  AS NAME
			FROM   [dbo].[DM_PLN_ESS_CHANNEL_PSI] EC WITH(NOLOCK)
			WHERE  1 = 1
			AND    EC.DIVISION_ID = '82'

		END;
    /*===============================================
	용		 도:   ESS CHANNGE PSI Type Code
	사 용 화 면:  DM0007    -    Customer FCST Master
	변       수:  -
	최 초 작 성:  2018. 03. 06
	개  발  자 :  Songdh
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'ESS_PSI_TYPE'
	    BEGIN
		    SELECT L.SEGMENT1  AS CODE
			     , L.SEGMENT2  AS NAME
			FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
			WHERE  1 = 1
			AND    L.LOOKUP_TYPE = 'ESS_PSI_TYPE'
			ORDER BY L.DISPLAY_SEQ
		END;

  /*===============================================
	용		 도:  COUNTRY
	사 용 화 면:  SCP0005
	변       수:  -
	최 초 작 성:  2018. 03. 08
	개  발  자 :  PJS
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'COUNTRY_MST'
	    BEGIN
		  SELECT A.COUNTRY CODE
			   , A.COUNTRY_NAME NAME
		  FROM   [dbo].[SCM_MST_COUNTRY] A WITH(NOLOCK)
		  WHERE  1=1
		  AND    A.VALID_YN = 'Y'
		  ORDER BY A.COUNTRY_NAME
		END;

  /*===============================================
	용		 도:  COUNTRY-CITY
	사 용 화 면:  SCP0005
	변       수:  -
	최 초 작 성:  2018. 03. 08
	개  발  자 :  PJS
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'CITY_MST'
	    BEGIN
			SELECT B.CITY CODE
			     , B.CITY_NAME NAME
			 FROM  [dbo].[SCM_MST_CITY]    B WITH(NOLOCK)
			WHERE B.VALID_YN = 'Y'
			  --AND B.COUNTRY ='KR'
			  AND ( (@Param1 IS NULL OR @Param1 = '') OR B.COUNTRY IN (SELECT token FROM dbo.String_Split(@Param1	,',')) )
			ORDER BY  B.CITY_NAME
		END;
  /*===============================================
	용		 도:  CURRENCY_LIST
	사 용 화 면:  DM0020_SalesFuturePricePopUp
	변       수:  -
	최 초 작 성:  2018. 03. 10
	개  발  자 :  HSJ
	최 종 작 성:  -
	수  정  자 : [E20251126-001120]_Currency Code 관리 개선 (하드코딩 → Lookup 관리)
	수 정 사 항: 
	===============================================*/
	IF @Code = 'CURRENCY_LIST'
	    BEGIN
			SELECT SEGMENT1 AS CODE,
					SEGMENT2 AS NAME
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE  (LOOKUP_TYPE = 'CURRENCY_LIST')
			AND  VALID_YN = 'Y' --[E20251126-001120]_VALID_YN 조건 추가
			ORDER BY  DISPLAY_SEQ
		END;
  /*===============================================
	용		 도:  MULTITIMEZONECODE
	사 용 화 면:  MULTITIMEZONECODE
	변       수:  -
	최 초 작 성:  2018. 03. 10
	개  발  자 :  HSJ
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'MULTITIMEZONECODE'
	    BEGIN
			select dbo.FN_MULTY_TIME(@Param1)
		END;
	/*===============================================
	용		 도:  CUST FCST MASTER UPLOAD UOM
	사 용 화 면:  DM0013_CustPsiUpload, DM0014_CustFcstUpload
	변       수:  -
	최 초 작 성:  2018. 03. 10
	개  발  자 :  HSJ
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'CUST_FCST_UPLOAD_UOM'
	    BEGIN
			SELECT CF.UPLOAD_UOM
            FROM   [dbo].[DM_MST_CUSTOMER_FCST] CF WITH(NOLOCK)
         WHERE  1 = 1
            AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1
                     ELSE CF.DIVISION_ID
 	            END  IN ( SELECT token FROM dbo.String_Split(@Param1,',') )
			AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2
                     ELSE CF.SCM_SITE_ID
 	            END  IN ( SELECT token FROM dbo.String_Split(@Param2,',') )
            AND CASE WHEN @Param3 = 'ALL' OR @Param3 = '' THEN @Param3
                ELSE CF.MEASURE_GROUP
 	            END  IN ( SELECT token FROM dbo.String_Split(@Param3,',') )
            AND CASE WHEN @Param4 = 'ALL' OR @Param4 = '' THEN @Param4
                     ELSE CF.MEASURE
 	            END  IN ( SELECT token FROM dbo.String_Split(@Param4,',') )
			AND CASE WHEN @Param5 = 'ALL' OR @Param5 = '' THEN @Param5
                     ELSE CF.UPLOAD_BUCKET_TYPE
 	            END  IN ( SELECT token FROM dbo.String_Split(@Param5,',') )
		END;

	/*===============================================
	용		 도:  Popup Division Code, Name
	사 용 화 면:  CommonDataPopup
	변       수:  -
	최 초 작 성:  2018. 03. 19
	개  발  자 :  ygkim
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'DIVISION_COD_NAME'
		BEGIN
			SELECT DIVISION_ID AS CODE, MIN([DIVISION_NAME]) AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)
			WHERE (@Param1 IS NULL OR DIVISION_ID LIKE '%' + @Param1 + '%') OR (@Param1 IS NULL OR DIVISION_NAME LIKE '%' + @Param1 + '%')
			GROUP BY DIVISION_ID
			ORDER BY DIVISION_ID
		END
	/*===============================================
	용		 도:  Sales Site -- 사용자의 팀정보 & 권한에 따른 Team, End Customer, Sales Site 데이타 조절
	사 용 화 면:  DM 화면
	변       수:  -
	최 초 작 성:  2018. 03. 26
	개  발  자 :  Seung Jae Hwang
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'SiteByEndCustomerAuth'
		BEGIN

			SELECT @v_dept_id = U.DEPT_ID
			FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)
			WHERE  U.UserID = @Param4

			SELECT DISTINCT
			       SCM_SITE_ID AS CODE
			     , SCM_SITE_ID AS NAME
			FROM   SCM_MST_SITE A WITH(NOLOCK)
			WHERE  1 = 1
			AND A.VALID_YN = 'Y'
			AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1
                        ELSE A.DIVISION_ID
	               END  IN (  SELECT token FROM dbo.String_Split(@Param1,',')
	 )
			AND    A.SITE_TYPE = 'SALES'
			AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2
                    ELSE A.END_CUSTOMER
 	            END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')
	                    )
            AND    A.DIVISION_ID IN (SELECT CODE
		                          FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    			 WHERE  GroupID LIKE '%'+ @Param3 + '%'
							    	 AND    UserID  LIKE '%'+ @Param4 + '%'
								     AND    AuthType = 'D')
			-- 팀, 권한에 대한 것
			--AND    CASE WHEN @v_group_id = 'ADMIN' THEN 'ADMIN'
				--   ELSE A.DEPT_ID END = CASE WHEN @v_group_id = 'ADMIN' THEN 'ADMIN' ELSE @v_dept_id END

				AND   ( @v_group_id = 'ADMIN'  OR  A.DEPT_ID IN  (
								SELECT  SEGMENT3
								FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
								WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'
								AND SEGMENT1     =   @v_dept_id AND VALID_YN = 'Y'
								UNION
								SELECT U.DEPT_ID
								FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)
								WHERE  U.UserID = @Param4 )     )
			ORDER BY SCM_SITE_ID ASC;
		END
	/*===============================================
	용		 도:  End Customer -- 사용자의 팀정보 & 권한에 따른 Team, End Customer, Sales Site 데이타 조절
	사 용 화 면:  DM 화면
	변       수:  -
	최 초 작 성:  2018. 03. 26
	개  발  자 :  Seung Jae Hwang
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:  2021.05.12	winter1203  [C20210423-000315] MDM 기준정보 변경시 EndCustomer의 명칭이 보이도록 수정
	===============================================*/
	IF @Code = 'EndCustomerByDivisionDeptAuth'
		BEGIN

			SELECT @V_DEPT_ID = U.DEPT_ID
			FROM   [DBO].[TB_FX_USER] U WITH(NOLOCK)
			WHERE  U.USERID = @PARAM4

			SELECT DISTINCT
					A.END_CUSTOMER AS CODE
					, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME
			FROM   SCM_MST_SITE A WITH(NOLOCK)
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
				ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
			WHERE  1 = 1
			AND    CASE WHEN @PARAM1 = 'ALL'  OR   @PARAM1 ='' THEN @PARAM1
						ELSE A.DIVISION_ID
					END  IN (  SELECT TOKEN FROM DBO.STRING_SPLIT(@PARAM1,',')
							)
			AND    CASE WHEN @PARAM2 = 'ALL'  OR  @PARAM2 ='' THEN @PARAM2
						ELSE A.DEPT_ID
					END  IN (  SELECT TOKEN FROM DBO.STRING_SPLIT(@PARAM2,',')
							)
			AND    A.DIVISION_ID IN (SELECT CODE
										FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK)
					    				WHERE  GROUPID LIKE '%'+ @PARAM3 + '%'
										AND    USERID  LIKE '%'+ @PARAM4 + '%'
										AND    AUTHTYPE = 'D')
			AND    END_CUSTOMER IS NOT NULL
			-- 팀, 권한에 대한 것
			--AND    CASE WHEN @V_GROUP_ID = 'ADMIN' THEN 'ADMIN'
					--ELSE A.DEPT_ID END = CASE WHEN @V_GROUP_ID = 'ADMIN' THEN 'ADMIN' ELSE @V_DEPT_ID END
			AND   ( @V_GROUP_ID = 'ADMIN'  OR  A.DEPT_ID IN  (
								SELECT  SEGMENT3
								FROM  [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
								WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'
								AND SEGMENT1     =   @V_DEPT_ID AND VALID_YN = 'Y'
								UNION
								SELECT U.DEPT_ID
								FROM   [DBO].[TB_FX_USER] U WITH(NOLOCK)
								WHERE  U.USERID = @PARAM4 )     )
			ORDER BY A.END_CUSTOMER
		END
	/*===============================================
	용		 도:  Team -- 사용자의 팀정보 & 권한에 따른 Team, End Customer, Sales Site 데이타 조절
	사 용 화 면:  DM 화면
	변       수:  -
	최 초 작 성:  2018. 03. 26
	개  발  자 :  Seung Jae Hwang
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/

IF @Code = 'TeambyDivisionAuth'
		BEGIN
			-- 복수 팀 권한 작업. 20180529
			DECLARE @v_team_cnt int=0; -- 다수 팀 권한

			----------------------------------------------------------------------------------------------
			-- 20200428 KHSONG PM TEAM MAPPING 인경우 본인 팀이 선택이 안되는 오류로 쿼리 수정 (BEGIN)
			----------------------------------------------------------------------------------------------

												--SELECT  @v_team_cnt = count(SEGMENT3)
												--FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
												--WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'
												--AND VALID_YN = 'Y'
												--AND SEGMENT1         = (SELECT DEPT_ID FROM [DBO].[TB_FX_USER] WITH(NOLOCK)  WHERE UserID = @Param4)
			SELECT  @v_team_cnt = COUNT(DEPT_ID)
				FROM
					(
					SELECT SEGMENT3 AS DEPT_ID
						FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
							WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'
								AND VALID_YN = 'Y'
								AND SEGMENT1 = (SELECT DEPT_ID FROM [DBO].[TB_FX_USER] WITH(NOLOCK)  WHERE UserID = @Param4)
					UNION

					SELECT DEPT_ID FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)
						WHERE  U.UserID = @Param4
					) A
			----------------------------------------------------------------------------------------------
			-- 20200428 KHSONG PM TEAM MAPPING 인경우 본인 팀이 선택이 안되는 오류로 쿼리 수정 (BEGIN)
			----------------------------------------------------------------------------------------------


			IF (@v_team_cnt <= 1) -- 일반적인 팀 정보 조회
			BEGIN

				IF (@Param1 <> '40')
				BEGIN
					SELECT DISTINCT
						B.DEPT_ID       AS CODE
						-- Modify by ytchoi 180310
						, B.DEPT_NAME_KO  AS NAME
						--, SUBSTRING(B.DEPT_NAME_KO  ,CHARINDEX('.',B.DEPT_NAME_KO )+1, len(B.DEPT_NAME_KO ) ) AS NAME
					FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK)
						, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)
					WHERE  A.SITE_TYPE = 'SALES'
					AND    A.DEPT_ID  = B.DEPT_ID
					AND    CASE WHEN @Param1 = 'ALL' THEN 'ALL'
						ELSE A.DIVISION_ID
						END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
						--SELECT t.c.value('.', 'NVARCHAR(4000)')
					--                  FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
					--                  CROSS APPLY x.nodes('/t') t(c)
							)
					AND    A.DIVISION_ID IN (SELECT CODE
							FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
							WHERE  GroupID LIKE '%'+ @Param3 + '%'
							AND    UserID  LIKE '%'+ @Param4 + '%'
							AND    AuthType = 'D')
					and B.DEPT_ID = CASE WHEN @v_group_id = 'ADMIN' THEN B.DEPT_ID ELSE @v_dept_id END	-- 20190107
					ORDER BY CODE, NAME


					-- 속도 개선. 20190109
					--SELECT DISTINCT
					--   B.DEPT_ID       AS CODE
					--  , B.DEPT_NAME_KO  AS NAME
					--FROM   [dbo].[SCM_MST_SITE]          A  WITH(NOLOCK)
					--INNER JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)
					--ON A.DEPT_ID  = B.DEPT_ID
					--WHERE  A.SITE_TYPE = 'SALES'
					--AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1
					--			ELSE A.DIVISION_ID
					--	   END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
					--			   )
				 --  -- 팀, 권한에 대한 것
					----AND    CASE WHEN @v_group_id = 'ADMIN' THEN 'ADMIN'
					----	   ELSE B.DEPT_ID END = CASE WHEN @v_group_id = 'ADMIN' THEN 'ADMIN' ELSE @v_dept_id END

					--and B.DEPT_ID = CASE WHEN @v_group_id = 'ADMIN' THEN B.DEPT_ID ELSE @v_dept_id END	-- 20190107
				END
				ELSE
				BEGIN

					SELECT DISTINCT C.DEPT_ID AS CODE , C.DEPT_NAME_KO AS NAME
					  FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
						  ,[SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK)
						  ,[SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK)
					 WHERE A.OWNER = B.USER_ID
					 AND B.DEPT_ID = C.DEPT_ID
					   AND A.DIVISION_ID = '40'
					   AND B.DEPT_ID = CASE WHEN @v_group_id = 'ADMIN' THEN B.DEPT_ID ELSE @v_dept_id END	-- 20190107
					  ORDER BY NAME
					-- 속도 개선. 20190109
					--SELECT DISTINCT
					--   B.DEPT_ID       AS CODE
					--  , B.DEPT_NAME_KO  AS NAME
					--FROM   [dbo].[SCM_MST_SITE]          A  WITH(NOLOCK)
					---- 20180615 수정 start
					--LEFT JOIN [dbo].[SCM_MST_SITE_ITEM] ITEM WITH(NOLOCK)
					--	ON A.DIVISION_ID = ITEM.DIVISION_ID AND A.SCM_SITE_ID = ITEM.SCM_SITE_ID
					--LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)
					--	ON B.DEPT_ID  = CASE WHEN A.DIVISION_ID <> '40' THEN A.DEPT_ID
					--							ELSE (
					--			SELECT SU.DEPT_ID
					--		FROM [dbo].[SCM_MST_SSO_USER_INFO] su
					--	WHERE SU.USER_ID = ITEM.OWNER
					--			)
					--	END
					---- 20180615 수정 end
					--WHERE  A.SITE_TYPE = 'SALES'
					----AND    A.DEPT_ID  = B.DEPT_ID   --20180615
					--AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1
					--			ELSE A.DIVISION_ID
					--	   END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
					--			   )
				 --  -- 팀, 권한에 대한 것
					----AND    CASE WHEN @v_group_id = 'ADMIN' THEN 'ADMIN'
					----	   ELSE B.DEPT_ID END = CASE WHEN @v_group_id = 'ADMIN' THEN 'ADMIN' ELSE @v_dept_id END

					--and B.DEPT_ID = CASE WHEN @v_group_id = 'ADMIN' THEN B.DEPT_ID ELSE @v_dept_id END	-- 20190107
				END
			END
			ELSE
			BEGIN
				IF (@Param1 <> '40')
				BEGIN
					-- 복수 팀 정보 조회
					SELECT DISTINCT
					   B.DEPT_ID       AS CODE
					  , B.DEPT_NAME_KO  AS NAME
					FROM   [dbo].[SCM_MST_SITE]          A  WITH(NOLOCK)
						 , [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)
					WHERE  A.SITE_TYPE = 'SALES'
					AND    A.DEPT_ID  = B.DEPT_ID
					AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1
								ELSE A.DIVISION_ID
						   END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
								   )
					AND B.DEPT_ID IN (
						SELECT  SEGMENT3
						FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
						WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'
						AND VALID_YN = 'Y'
						AND SEGMENT1         = (SELECT DEPT_ID FROM [DBO].[TB_FX_USER] WITH(NOLOCK) WHERE UserID = @Param4)
						-- 2018/05/29   jye (start)
						UNION
						SELECT U.DEPT_ID
						FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)
						WHERE  U.UserID = @Param4
						-- 2018/05/29   jye (end)
					)
				END
				ELSE
				BEGIN
					-- 복수 팀 정보 조회
					SELECT DISTINCT
					   B.DEPT_ID       AS CODE
					  , B.DEPT_NAME_KO  AS NAME
					FROM   [dbo].[SCM_MST_SITE]       A  WITH(NOLOCK)
					-- 20180615 수정 start
					LEFT JOIN [dbo].[SCM_MST_SITE_ITEM] ITEM WITH(NOLOCK)
						ON A.DIVISION_ID = ITEM.DIVISION_ID AND A.SCM_SITE_ID = ITEM.SCM_SITE_ID
					LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)
						ON B.DEPT_ID  = CASE WHEN A.DIVISION_ID <> '40' THEN A.DEPT_ID
												ELSE (
								SELECT SU.DEPT_ID
							FROM [dbo].[SCM_MST_SSO_USER_INFO] su
						WHERE SU.USER_ID = ITEM.OWNER
								)
						END
					-- 20180615 수정 end
					WHERE  A.SITE_TYPE = 'SALES'
					-- AND    A.DEPT_ID  = B.DEPT_ID  --20180615
					AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1
								ELSE A.DIVISION_ID
						   END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
								  )
					AND B.DEPT_ID IN (
						SELECT  SEGMENT3
						FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
						WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'
						AND VALID_YN = 'Y'
						AND SEGMENT1         = (SELECT DEPT_ID FROM [DBO].[TB_FX_USER] WITH(NOLOCK) WHERE UserID = @Param4)
						-- 2018/05/29   jye (start)
						UNION
						SELECT U.DEPT_ID
						FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)
						WHERE  U.UserID = @Param4
						-- 2018/05/29   jye (end)
					)
				END
			END
		END

	IF 	@Code = 'Auth_Dept'

	    BEGIN
			DECLARE @v_admin  NVARCHAR(50);
			SET @v_admin = @Param2;

			---------------------------------------------------------------------------------
			--            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
			---------------------------------------------------------------------------------
			DECLARE @v_admin_group_id  NVARCHAR(50);
			IF ISNULL((
						SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							where LOOKUP_TYPE = 'GET_ADMIN_GROUP'
								AND VALID_YN = 'Y'
								AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
								AND SEGMENT1 = @v_admin
					  ),0) > 0
				BEGIN
					SET @v_admin_group_id = 'ADMIN'
				END
			---------------------------------------------------------------------------------
			--            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
			---------------------------------------------------------------------------------

			SELECT CASE WHEN @v_admin_group_id = 'ADMIN' THEN 'ADMIN'
			            ELSE @v_dept_id END AS CODE
				 , CASE WHEN @v_admin_group_id = 'ADMIN' THEN 'ADMIN'
			            ELSE @v_dept_id END AS NAME
	        FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)
	        WHERE  U.USERID = @Param1
	    END;

	    /*
		-- 20200313 KHSONG 기존로직 주석처리
		BEGIN
			DECLARE @v_admin  NVARCHAR(10);

			SET @v_admin = @Param2;

			SELECT CASE WHEN @v_admin = 'ADMIN' OR @v_admin =  'DM ADMIN' THEN 'ADMIN'
			            ELSE @v_dept_id END AS CODE
				 , CASE WHEN @v_admin = 'ADMIN' OR @v_admin = 'DM ADMIN' THEN 'ADMIN'
			            ELSE @v_dept_id END AS NAME
	        FROM   [dbo].[TB_FX_User] U
	        WHERE  U.USERID = @Param1
	    END;
		*/

	/*===============================================
		용		 도:  FCST TYPE LOOKUP COMBO BOX
		사 용 화 면:  DM0003_DM_PLN_MKT_FCST	-	FCST_TYPE컬럼
		변       수:  -
		최 초 작 성:  2018. 04	.04
		개  발  자 :  Songdh70
		최 종 작 성:  -
		수  정  자 :  -
		수 정 사 항:
		===============================================*/
	IF @Code = 'FCST_TYPE_NOT_ETC'
	BEGIN
		SELECT SEGMENT1 AS CODE
		     , SEGMENT2 AS NAME
		     , DISPLAY_SEQ
		FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE  1 = 1
		AND    VALID_YN    = 'Y'
		AND    LOOKUP_TYPE = 'SALES_TYPE_CODE'
		AND    SEGMENT1  <> 'ETC'
		ORDER BY DISPLAY_SEQ
	END

	/*===============================================
		용		 도:  LookUp 테이블 Code, Name Code : Name 공통 조회
		사 용 화 면:
		변       수:  --
		최 초 작 성:  2018. 04. 16
		개  발  자 :  ygkim
		최 종 작 성:  2018. 04. 16
		수  정  자 :
		수 정 사 항:
		===============================================*/
	IF @Code = 'LookupCommon2'
	BEGIN
		SELECT B.SEGMENT1 CODE
			  ,B.SEGMENT1 + ' : ' + B.SEGMENT2 NAME
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
		WHERE A.LOOKUP_TYPE = @Param1
		  AND A.VALID_YN = 'Y'
		ORDER BY B.DISPLAY_SEQ
	END

	/*===============================================
		용		 도:  권한 상관없이 전체 Plant 정보를 가져온다.
		사 용 화 면:
		변       수:  --
		최 초 작 성:  2018. 04. 18
		개  발  자 :  ygkim
		최 종 작 성:  2018. 04. 18
		수  정  자 :
		수 정 사 항:
		===============================================*/
	-- PLANT
		-- Param1 = Division ID
		IF @Code = 'PlantAll'

			BEGIN
				SELECT distinct S.PLANT_ID      AS CODE
					, (CASE
					   WHEN A.PLANT_NAME IS NULL
					        THEN V.VENDOR_NAME
					   ELSE A.PLANT_NAME
					   END )		   AS NAME
				FROM  SCM_MST_SITE S WITH(NOLOCK)
				LEFT OUTER JOIN  SCM_MST_PLANT_SN A  WITH(NOLOCK) ON A.DIVISION_ID = S.DIVISION_ID AND A.PLANT_ID = S.PLANT_ID -- AND s.operation_group = A.shop_group_id
				LEFT OUTER JOIN  SCM_MST_VENDOR V  WITH(NOLOCK) ON V.VENDOR_CODE = S.PLANT_ID
				WHERE (@Param1 = '' OR S.DIVISION_ID = @Param1)
					  AND
					  (
						(@Param2 IS NULL OR S.PLANT_ID LIKE '%' + @Param2 + '%') OR (@Param2 IS NULL OR PLANT_NAME LIKE '%' + @Param2 + '%')
					  )
				AND   S.VALID_YN ='Y'
				ORDER BY S.PLANT_ID
			END
    /*===============================================
		용		 도:  LookUp 테이블 Code, Name Code : Name 공통 조회
		사 용 화 면:  MKT FCST
		변       수:  -- @Param1 : Division, @Param2 : BucketType
		최 초 작 성:  2018. 04. 19
		개  발  자 :  Songdh
		최 종 작 성:  2018. 04. 19
		수  정  자 :
		수 정 사 항:		
		2025/07/04	  kjiyoon				[PJ2025-50188] 고도화 - 월수량 일별로 나누기 반영
		===============================================*/
		IF @Code = 'DefaultBucketDay'
	    BEGIN
		    SELECT L.SEGMENT3  AS DEFAULTBUCKETDAY
            FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
            WHERE  1 = 1
            AND    L.LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'
            AND    L.VALID_YN    = 'Y'
            AND    L.SEGMENT1    = @Param1
            AND    L.SEGMENT2    = CASE WHEN @Param2 = 'DAILY' 
										THEN 'MONTHLY'
										ELSE @Param2 
									END -- WEEKLY or MONTHLY 의 조건이 빠져있어서 다시 추가 하였음 - [PJ2025-50188] 고도화 - 월수량 일별로 나누기 반영
	    END

		/*===============================================
		용		 도:  Waterfall Version조회
		사 용 화 면:  SCRP0017 Waterfall Production Plan
		변       수:  @Param1 : Division, @Param2 : operation_group
		최 초 작 성:  2018. 04. 24
		개  발  자 : PJS
		최 종 작 성:  2018. 04. 24
		수  정  자 :
		수 정 사 항:
		===============================================*/
		IF @Code = 'WaterfallVer'
	    BEGIN
			SELECT TOP 10 version_no AS code
			          ,version_no AS name
			FROM scp_anl_production_plan_c WITH(NOLOCK)
			WHERE division_id    = @Param1
			  AND ( (@Param2 IS NULL OR @Param2 = '') OR operation_group IN (SELECT token FROM dbo.String_Split(@Param2	,',')) )
			GROUP BY version_no
			ORDER BY version_no DESC

	    END

		/*===============================================
		용		 도:  Waterfall Version 조회
		사 용 화 면:  SCP0016_WaterfallShipmentPlanFG
		변       수:  @Param1 : Division, @Param2 : biz_type
		최 초 작 성:  2018. 04. 24
		개  발  자 :  KYH
		최 종 작 성:  2018. 04. 24
		수  정  자 :
		수 정 사 항:
		===============================================*/
		IF @Code = 'WaterfallVer_FG'
		BEGIN
			SELECT TOP 10 version_no AS code
			             ,version_no AS name
			from SCP_ANL_SHIPMENT_PLAN_FG_C WITH(NOLOCK)
			WHERE division_id     = @Param1
			  AND ( (@Param2 IS NULL OR @Param2 = '') OR biz_type IN (SELECT token FROM dbo.String_Split(@Param2	,',')) )
			GROUP BY version_no
			ORDER BY version_no DESC

	    END

		/*===============================================
		용		 도:  Company 조회
		사 용 화 면:  SSP0005_ShipmentWorkingDay
		변       수:
		최 초 작 성:  2018. 04. 25
		개  발  자 :  ygkim
		최 종 작 성:  2018. 04. 25
		수  정  자 :
		수 정 사 항:
		===============================================*/
		IF @Code = 'Company'
		BEGIN
			SELECT A.COMPANY_ID CODE
				  ,A.COMPANY_NAME NAME
			FROM SCM_MST_COMPANY_SN A WITH(NOLOCK)
	    END

		/*===============================================
		용		 도:  Waterfall Version 조회
		사 용 화 면:  SCP0018_WaterfallShipmentPlanSemi
		변       수:  @Param1 : Division, @Param2 : OPERATION_GROUP
		최 초 작 성:  2018. 04. 25
		개  발  자 :  KYH
		최 종 작 성:  2018. 04. 25
		수  정  자 :
		수 정 사 항:
		===============================================*/
		IF @Code = 'WaterfallVer_SEMI'
		BEGIN
			SELECT TOP 10 version_no AS code
			             ,version_no AS name
			from SCP_ANL_SHIPMENT_PLAN_SEMI_C WITH(NOLOCK)
			WHERE division_id     = @Param1
			  AND ( (@Param2 IS NULL OR @Param2 = '') OR OPERATION_GROUP IN (SELECT token FROM dbo.String_Split(@Param2	,',')) )
			GROUP BY version_no
			ORDER BY version_no DESC
	    END

		/*===============================================
		용		 도:  Transport Mode 조회
		사 용 화 면:  SSP0002_ShipmentChangeRequest
		변       수:  @Param1 : Division, @Param2 : from_site, @Param3 : to_site, @Param4 : incoterms
		최 초 작 성:  2018. 04. 26
		개  발  자 :  ygkim
		최 종 작 성:  2018. 04. 26
		수  정  자 :
		수 정 사 항:  2018.01.15	hwyoon	valid_yn 추가
		             2020/09/21     KIMYONGHO     SSP INCOTERMS 변경 작업
		===============================================*/
		IF @Code = 'TransMode'
		BEGIN
			SELECT TRANSPORT_MODE CODE
			     ,TRANSPORT_MODE NAME
				 ,BOD_ID
				,ROUTE_ID
				--2020/09/21     KIMYONGHO     SSP INCOTERMS 변경 작업
				--,INCOTERMS
				,SSP_INCOTERMS         AS INCOTERMS
				,D_COUNTRY
				,D_PORT_CODE
				,A_COUNTRY
				,A_PORT_CODE
				,LT_TOTAL
				,LT_TOTAL_ORIGIN	-- 전극 출하계획 대응 컬럼 추가
				,TO_COUNTRY
				,TO_CITY
			FROM [DBO].[SCP_MST_BOD_V]  WITH(NOLOCK)   -- SCP_MST_BOD_V  WITH(NOLOCK)
			WHERE 1=1			
			AND division_id = @Param1
			AND from_site = @Param2
			AND to_site = @Param3
			--2020/09/21     KIMYONGHO     SSP INCOTERMS 변경 작업
			--AND incoterms = @Param4
			AND ssp_incoterms = @Param4
			AND bod_valid_yn = 'Y'			
			order by priority
	    END	

		/*===============================================
		용		 도:  Lookup 테이블 다국어 처리 Segment1(Code), Segment2(한국어), Segment3(영어)
		사 용 화 면:
		변       수:  @Param1 : Code, @Param2 : User
		최 초 작 성:  2018. 05. 23
		개  발  자 :  ygkim
		최 종 작 성:  2018. 05. 23
		수  정  자 :
		수 정 사 항:
		===============================================*/
		IF @Code = 'LookupCommon3'
		BEGIN
			SELECT B.SEGMENT1 CODE
				  ,B.SEGMENT1 + ' : ' + CASE WHEN U.Language = 'KO' THEN B.SEGMENT2 ELSE B.SEGMENT3 END NAME
			FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
			INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
			LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON U.UserID = @Param2 AND U.UseYN = 'Y'
			WHERE A.LOOKUP_TYPE = @Param1
				AND A.VALID_YN = 'Y'
			ORDER BY B.DISPLAY_SEQ
	    END


		/*===============================================
		용		 도:  소형 DIVISION, 팀  변경시 ENDCUSTOMER(SCM_MST_SITE_ITEM.PROJECT_CODE) 조회
		사 용 화 면:  DM0020	   -	MAIN SPREAD의 ENDCUSTOMER 컬럼 및 ENDCUSTOMER 컨트롤
		변       수:  @PARAM1 = DIVISION, @PARAM2 = DEPT_ID, @PARAM3 = GROUP_ID, @PARAM4 = USER_ID
		최 초 작 성:  2018.06.08
		개  발  자 :  jye
		최 종 작 성:
		수  정  자 :
		수 정 사 항: 2021.05.12	winter1203  [C20210423-000315] MDM 기준정보 변경시 EndCustomer의 명칭이 보이도록 수정
		===============================================*/

		IF @Code = 'EndCustomerByDivision40'
		BEGIN
		    /*
			SELECT DISTINCT PROJECT_CODE AS CODE, PROJECT_CODE AS NAME
			FROM SCM_MST_SITE AS ST WITH(NOLOCK)
			LEFT JOIN SCM_MST_SITE_ITEM AS IT WITH(NOLOCK)
			ON ST.DIVISION_ID = IT.DIVISION_ID AND ST.SCM_SITE_ID = IT.SCM_SITE_ID
			-- 20180615 수정. start
			LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)
			ON B.DEPT_ID  = CASE WHEN ST.DIVISION_ID <> '40' THEN ST.DEPT_ID
											ELSE (
							SELECT SU.DEPT_ID
						FROM [dbo].[SCM_MST_SSO_USER_INFO] SU
					WHERE SU.USER_ID = IT.OWNER
							)
					END
			-- 20180615 수정. end
			WHERE 1=1
				AND ST.DIVISION_ID = '40'

				AND    CASE WHEN @Param2 = 'ALL'  OR  @Param2 ='' THEN @Param2
							--ELSE ST.DEPT_ID  --20180615
							ELSE B.DEPT_ID
						END  IN (  SELECT token FROM dbo.String_Split(@Param2,',')
								)
				AND    ST.DIVISION_ID IN (SELECT CODE
											FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    					WHERE  GroupID LIKE '%'+ @Param3 + '%'
											AND    UserID  LIKE '%'+ @Param4 + '%'
											AND    AuthType = 'D')
				AND IT.PROJECT_CODE IS NOT NULL		-- 20180615
			ORDER BY PROJECT_CODE			-- 20180615
			*/

 			SELECT DISTINCT A.PROJECT_CODE AS CODE
				, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
			FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
				INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
				INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
					ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
			WHERE --A.OWNER = B.USER_ID
			B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  -- 20180816
			AND B.DEPT_ID = C.DEPT_ID
			AND A.DIVISION_ID = '40'
			AND CASE WHEN @PARAM2 = 'ALL'  OR  @PARAM2 ='' THEN @PARAM2
						--ELSE ST.DEPT_ID  --20180615
					ELSE B.DEPT_ID
					END  IN (  SELECT TOKEN FROM DBO.STRING_SPLIT(@PARAM2,',') )
			-- ORDER BY PROJECT_CODE
			AND A.VALID_YN = 'Y'		-- 20190911. JYE
			UNION
			SELECT SEGMENT2 AS CODE , SEGMENT3 AS NAME
			FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
			WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
			AND (@PARAM2 = 'ALL' OR  @PARAM2 =''  )
			AND SEGMENT2 <> '-'
			AND SEGMENT1  = CASE WHEN @PARAM1 = '' THEN SEGMENT1 ELSE @PARAM1 END -- ADDED BY YTCHOI 190211
			AND VALID_YN = 'Y'		-- 20190911. JYE
			AND SEGMENT1 = '40'  -- 20191202 KHSONG DIVISION 조건 ADDED
			ORDER BY CODE


		END


		/*===============================================
		용		 도:  소형 DIVISION, 팀, END CUSTOMER  변경시 SCM_SITE(SCM_MST_SITE_ITEM.PROJECT_CODE) 조회
		사 용 화 면:  DM0020	   -	MAIN SPREAD의 ENDCUSTOMER 컬럼 및 ENDCUSTOMER 컨트롤
		변       수:
		최 초 작 성:  2018.06.11
		개  발  자 :  LSH
		최 종 작 성:
		수  정  자 :
		수 정 사 항:
		===============================================*/

		IF @Code = 'ScmSitebyEndCustomer40'
		BEGIN

			SELECT DISTINCT ST.SCM_SITE_ID AS CODE, SITE_DESCRIPTION AS NAME
			FROM SCM_MST_SITE AS ST WITH(NOLOCK)
			--WHERE ST.DIVISION_ID = '40'
			--AND    CASE WHEN @Param2 = 'ALL'  OR  @Param2 ='' THEN @Param2 -- 2018-02-08 진준희
			--				ELSE IT.PROJECT_CODE
			--			END  IN (  SELECT token FROM dbo.String_Split(@Param2,',')
			--					)
			WHERE  1 = 1
			AND    ST.DIVISION_ID = '40'
			AND    ST.SITE_TYPE = 'SALES'
			--AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1
   --                  ELSE ST.DIVISION_ID
 	 --           END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))

			----------AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2
   ----------                  ELSE IT.PROJECT_CODE
 	 ----------           END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')
	                    ----------) -->40은 scm_site_id와 end_customer와 무관함.
            AND    ST.DIVISION_ID IN (SELECT CODE
		                             FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    			 WHERE  GroupID LIKE '%'+ @Param3 + '%'
							    	 AND    UserID  LIKE '%'+ @Param4 + '%'
								     AND    AuthType = 'D')
			ORDER BY ST.SCM_SITE_ID ASC;

		END


	/*===============================================
	용		 도:  CUST_GROUP
	사 용 화 면:  DM0005_SaleSite_PjtModelMapping
	변       수:  -
	최 초 작 성:  2018. 06. 08
	개  발  자 :  LSH
	최 종 작 성:  -
	수  정  자 :  - winter1203
	수 정 사 항:  [C20210715-000075] Cust Group 룩업 내 Valid 참조 요청
	===============================================*/
	IF @Code = 'CUST_GROUP'
	    BEGIN

			SELECT SEGMENT1 AS CODE,
					SEGMENT2 AS NAME
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE  (LOOKUP_TYPE = 'CUST_GROUP')
				AND VALID_YN = 'Y'	-- [C20210715-000075] Cust Group 룩업 내 Valid 참조 요청
			ORDER BY  SEGMENT1  -- modify by ytchoi 20180730
		END;

	/*===============================================
	용		 도:  CUST_GROUP_DETAIL
	사 용 화 면:  DM0005_SaleSite_PjtModelMapping
	변       수:  -
	최 초 작 성:  2018. 06. 08
	개  발  자 :  LSH
	최 종 작 성:  -
	수  정  자 :  - winter1203
	수 정 사 항:  [C20210715-000075] Cust Group 룩업 내 Valid 참조 요청
	===============================================*/
	IF @Code = 'CUST_GROUP_DTL'
	    BEGIN

			SELECT SEGMENT1 AS CODE,
					SEGMENT2 AS NAME
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE  (LOOKUP_TYPE = 'CUST_GROUP_DTL')
				AND VALID_YN = 'Y'	-- [C20210715-000075] Cust Group 룩업 내 Valid 참조 요청
			ORDER BY  SEGMENT1  -- modify by ytchoi 20180730
		END;

	/*===============================================
	용		 도:  CUST_GROUP_DETAIL
	사 용 화 면:  DM0005_SaleSite_PjtModelMapping
	변       수:  -
	최 초 작 성:  2018. 06. 08
	개  발  자 :  LSH
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'APPLICATION'
	  BEGIN

			SELECT SEGMENT1 AS CODE,
					SEGMENT2 AS NAME
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE  (LOOKUP_TYPE = 'APPLICATION')
			--ORDER BY  DISPLAY_SEQ
			ORDER BY  SEGMENT1  -- modify by ytchoi 20180730
		END;



	/*===============================================
	용		 도:  CUST_GROUP_DETAIL
	사 용 화 면:  DM0005_SaleSite_PjtModelMapping
	변       수:  -
	최 초 작 성:  2018. 06. 08
	개  발  자 :  LSH
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'ROUTE'
	    BEGIN

			SELECT SEGMENT1 AS CODE,
					SEGMENT2 AS NAME
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE  (LOOKUP_TYPE = 'ROUTE')
			--ORDER BY  DISPLAY_SEQ
			ORDER BY  SEGMENT1  -- modify by ytchoi 20180730
		END;


		/*===============================================
		용		 도:  소형 DIVISION, 팀, END CUSTOMER  조회
		사 용 화 면:  DM0020	   -	MAIN SPREAD의 ENDCUSTOMER 컬럼 및 ENDCUSTOMER 컨트롤
		변       수:
		최 초 작 성:  2018.06.14
		개  발  자 :  LSH
		최 종 작 성:
		수  정  자 :
		수 정 사 항:
		===============================================*/

		IF @Code = 'EndCustomerByDivisionSml'
		BEGIN
		    SELECT
				   segment2 AS CODE
				  ,segment3 AS NAME
			 FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			 WHERE LOOKUP_TYPE = 'END_CUSTOMER'
			 AND SEGMENT1 = '40'
			 AND VALID_YN = 'Y' -- 20190129 ADD
			 ORDER BY segment2 ASC;
		END

	/*===============================================
	용		 도:  Plant Assign 콤보박스 내용 추가
	사 용 화 면:  SCP0006_ProjectRoute
	변       수:  -
	최 초 작 성:  2018. 07. 04
	개  발  자 :  KYH
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:  ESS 외주 Pakcer Line 생산 Target 적용 (외주 Line Capa 대상 Tact Time 입력여부 체크조회 추가)
	===============================================*/
	IF @Code = 'PlantByDivisionOperationItem'
	BEGIN
		SELECT DISTINCT
			A.SCM_SITE_ID AS CODE ,
			A.SCM_SITE_ID + '   '+ A.SITE_DESCRIPTION +
			CASE WHEN B.PLANT_SITE_ID IS NOT NULL THEN ' Y' ELSE ' N' END	AS NAME
		FROM  [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		LEFT JOIN (
			SELECT DISTINCT ITEM_ID, PLANT_SITE_ID
			FROM (
				SELECT T.ITEM_ID , T.PLANT_SITE_ID
				FROM SCP_MST_TACT_TIME T WITH(NOLOCK)
				JOIN SCM_MST_SITE S  WITH(NOLOCK) ON S.SCM_SITE_ID=T.PLANT_SITE_ID
				JOIN SCM_MST_LINE_SN LS  WITH(NOLOCK) ON LS.COMPANY_ID=S.COMPANY_ID AND LS.DIVISION_ID=T.DIVISION_ID AND LS.SITE_ID=S.SITE_ID AND LS.PLANT_ID=S.PLANT_ID
										AND LS.OPERATION_ID=T.OPERATION_ID AND LS.LINE_ID=T.LINE_ID AND LS.ACTIVE_FLAG='Y'
				WHERE T.DIVISION_ID = @Param1
					AND T.ITEM_ID = @Param3
					AND T.VALID_YN='Y'
				GROUP BY T.ITEM_ID , T.PLANT_SITE_ID
				--ESS 외주 Pakcer Line 생산 Target 적용 union 추가
				UNION ALL
				SELECT T.ITEM_ID , T.PLANT_SITE_ID
				FROM SCP_MST_TACT_TIME_OSP T WITH(NOLOCK)
				JOIN SCM_MST_SITE S  WITH(NOLOCK) ON S.SCM_SITE_ID=T.PLANT_SITE_ID
				JOIN SCM_MST_LINE_OSP LS  WITH(NOLOCK) ON LS.DIVISION_ID=T.DIVISION_ID AND LS.SCM_SITE_ID=T.PLANT_SITE_ID AND LS.LINE_ID=T.LINE_ID AND LS.VALID_YN='Y'
				WHERE T.DIVISION_ID = @Param1
				AND T.ITEM_ID = @Param3
				AND T.VALID_YN='Y'
				GROUP BY T.ITEM_ID , T.PLANT_SITE_ID
			) A
		) B ON A.SCM_SITE_ID=B.PLANT_SITE_ID
		WHERE  1 = 1
		AND  A.VALID_YN ='Y'
		AND  A.SITE_TYPE = 'PLANT'
		AND  ( ( @Param1 IS NULL OR  @Param1='' ) OR  A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')) )
		AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )
		ORDER BY CODE
		/*
		SELECT DISTINCT
			A.SCM_SITE_ID AS CODE ,
			A.SCM_SITE_ID + '   '+ A.SITE_DESCRIPTION +
			CASE WHEN B.PLANT_SITE_ID IS NOT NULL THEN ' Y' ELSE ' N' END	AS NAME
		FROM  [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		LEFT JOIN (
			SELECT T.ITEM_ID , T.PLANT_SITE_ID
			FROM SCP_MST_TACT_TIME T
			JOIN SCM_MST_SITE S ON S.SCM_SITE_ID=T.PLANT_SITE_ID
			JOIN SCM_MST_LINE_SN LS ON LS.COMPANY_ID=S.COMPANY_ID AND LS.DIVISION_ID=T.DIVISION_ID AND LS.SITE_ID=S.SITE_ID AND LS.PLANT_ID=S.PLANT_ID
									AND LS.OPERATION_ID=T.OPERATION_ID AND LS.LINE_ID=T.LINE_ID AND LS.ACTIVE_FLAG='Y'
			WHERE T.DIVISION_ID = @Param1
				AND T.ITEM_ID = @Param3
				AND T.VALID_YN='Y'
			GROUP BY T.ITEM_ID , T.PLANT_SITE_ID
		) B ON A.SCM_SITE_ID=B.PLANT_SITE_ID
		WHERE  1 = 1
		AND  A.VALID_YN ='Y'
		AND  A.SITE_TYPE = 'PLANT'
		AND  ( ( @Param1 IS NULL OR  @Param1='' ) OR  A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')) )
		AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )
		ORDER BY CODE
		*/
	END;

	/*===============================================
	용		 도:  팀 구분. 전체 / 40 / 81,82
	사 용 화 면:
	변       수:  -
	최 초 작 성:  2018. 07. 07
	개  발  자 :  JYE
	최 종 작 성:  2018. 07. 07
	수  정  자 :
	수 정 사 항:
	===============================================*/

	IF @CODE = 'TeambyDivision2'
	BEGIN

		IF @Param1 = ''
			SET @Param1 = 'ALL';

		IF (@Param1 = 'ALL') -- 20180615 수정. Division 분기
		BEGIN
			SELECT CODE, NAME FROM (
				SELECT DISTINCT C.DEPT_ID AS CODE , C.DEPT_NAME_KO AS NAME
				  FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
					  ,[SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK)
					  ,[SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK)
				 WHERE A.OWNER = B.USER_ID
				   AND B.DEPT_ID = C.DEPT_ID
				   AND A.DIVISION_ID IN ('40', '42', '44')		-- 20190124
				UNION ALL
				SELECT DISTINCT
					B.DEPT_ID       AS CODE
					-- Modify by ytchoi 180310
					, B.DEPT_NAME_KO  AS NAME
					--, SUBSTRING(B.DEPT_NAME_KO  ,CHARINDEX('.',B.DEPT_NAME_KO )+1, len(B.DEPT_NAME_KO ) ) AS NAME
				FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK)
					, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)
				WHERE  A.SITE_TYPE = 'SALES'
				AND    A.DEPT_ID  = B.DEPT_ID
				AND    CASE WHEN @Param1 = 'ALL' THEN 'ALL'
					ELSE A.DIVISION_ID
					END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
					--SELECT t.c.value('.', 'NVARCHAR(4000)')
				--                  FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
				--                  CROSS APPLY x.nodes('/t') t(c)
						)
				AND    A.DIVISION_ID IN (SELECT CODE
						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
						WHERE  GroupID LIKE '%'+ @Param2 + '%'
						AND    UserID  LIKE '%'+ @Param3 + '%'
						AND    AuthType = 'D')
			) MA
			ORDER BY NAME, CODE
		END
		ELSE IF (@Param1 = '40')
		BEGIN
			-- 20180615 수정. 소형 Division 추가
			SELECT DISTINCT C.DEPT_ID AS CODE , C.DEPT_NAME_KO AS NAME
			  FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
			      ,[SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK)
				  ,[SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK)
			 WHERE A.OWNER = B.USER_ID
			   AND B.DEPT_ID = C.DEPT_ID
			   AND A.DIVISION_ID = '40'

		END
		ELSE
		BEGIN
			SELECT DISTINCT
				B.DEPT_ID       AS CODE
				-- Modify by ytchoi 180310
				, B.DEPT_NAME_KO  AS NAME
				--, SUBSTRING(B.DEPT_NAME_KO  ,CHARINDEX('.',B.DEPT_NAME_KO )+1, len(B.DEPT_NAME_KO ) ) AS NAME
			FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK)
				, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)
			WHERE  A.SITE_TYPE = 'SALES'
			AND    A.DEPT_ID  = B.DEPT_ID
			AND    CASE WHEN @Param1 = 'ALL' THEN 'ALL'
				ELSE A.DIVISION_ID
				END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
				--SELECT t.c.value('.', 'NVARCHAR(4000)')
			--       FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
			--                  CROSS APPLY x.nodes('/t') t(c)
					)
			AND    A.DIVISION_ID IN (SELECT CODE
					FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					WHERE  GroupID LIKE '%'+ @Param2 + '%'
					AND    UserID  LIKE '%'+ @Param3 + '%'
					AND    AuthType = 'D')
			ORDER BY CODE, NAME
		END
	END



	/*===============================================
	용		 도:
	사 용 화 면:
	변       수:  -
	최 초 작 성:
	개  발  자 :  KYH
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'LineProdPlanLine'
	BEGIN
		SELECT
		DISTINCT
				A.LINE_ID						  AS CODE
				,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
		FROM [dbo].SCM_MST_LINE_SN A  WITH(NOLOCK)
		JOIN [dbo].SCM_MST_SITE B  WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND  A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID
		JOIN [dbo].SCP_ANL_PRODUCTION_PLAN C  WITH(NOLOCK) ON C.DIVISION_ID = @Param1
												AND C.OPERATION_GROUP=@Param2
												AND ( (@Param3 IS NULL OR @Param3 ='') OR C.SCM_SITE_ID IN ( SELECT token FROM dbo.String_Split(@Param3,','))   )
		INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1
						FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
						WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
						AND    b.valid_yn    = 'Y'
						AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
					) f ON a.operation_id = f.segment4 --AND c.operation_group_id = f.segment3 -- operation group id 에 추가된 operation 만보이도록
		WHERE 1=1
		AND A.ACTIVE_FLAG ='Y'
		AND A.DIVISION_ID = C.ORIGIN_DIVISION_ID
		AND A.LINE_ID = C.LINE_ID
		UNION ALL
		SELECT
			'-'  AS CODE
			,'-'  AS NAME
		ORDER BY NAME
	END;

	/*===============================================
	용		 도:  소형 Biz_Type
	사 용 화 면:
	변       수:  -
	최 초 작 성:  2018. 07. 20
	개  발  자 :  JYE
	최 종 작 성:  2018. 07. 20
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @CODE = 'DM_Biz_Type'
	BEGIN
		SELECT L.SEGMENT1  AS CODE
			, L.SEGMENT2  AS NAME
		FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
		WHERE  1 = 1
		AND    L.LOOKUP_TYPE = 'DM_BIZ_TYPE'
		ORDER BY L.DISPLAY_SEQ
	END

	/*===============================================
	용		 도:  Sales Plan, Sales Plan Waterfall > Sales Site 에 내부 코드 추가
	사 용 화 면:
	변       수:  -
	최 초 작 성:  2018. 08. 22
	개  발  자 :  JYE
	최 종 작 성:  2018. 08. 22
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'SiteByEndCustomer_InnerCode'

	BEGIN

		IF (@Param1 <> '40')
		BEGIN
			SELECT DISTINCT
					SCM_SITE_ID AS CODE
					, SCM_SITE_ID AS NAME
			FROM   SCM_MST_SITE A WITH(NOLOCK)
			WHERE  1 = 1
			AND    A.SITE_TYPE = 'SALES'
			AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1			--2018-02-08  진준희
						ELSE A.DIVISION_ID
 				END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
			AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2			--2018-02-08  진준희
						ELSE A.END_CUSTOMER
 				END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')
						/* SELECT t.c.value('.', 'NVARCHAR(4000)')
							FROM   (SELECT x = CAST('<t>' + REPLACE( CASE @Param1 WHEN '' THEN 'ALL' ELSE @Param1 END , ',', '</t><t>') + '</t>' AS xml)) b
							CROSS APPLY x.nodes('/t') t(c)		*/				--2018-02-08  진준희
						)
			AND    A.DIVISION_ID IN (SELECT CODE
										FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    				WHERE  GroupID LIKE '%'+ @Param3 + '%'
							    		AND    UserID  LIKE '%'+ @Param4 + '%'
										AND    AuthType = 'D')
			AND A.VALID_YN = 'Y'	-- 20180612 추가

			UNION ALL	-- 20180822

			--SELECT DISTINCT CUSTOMER_CODE AS CODE
			--	, CUSTOMER_CODE AS NAME
			--FROM [LGCE_INFDEV].[DBO].[XIF_ERP_SALES_RESULT_R]
			--WHERE LEN(CUSTOMER_CODE) < 6 AND CUSTOMER_CODE <> ''

			-- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)

										--SELECT SEGMENT1  AS CODE
										--	 , SEGMENT1  AS NAME
										--FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
										--WHERE LOOKUP_TYPE = 'INTERNAL_TXN'

			SELECT COMPANY_ID AS CODE,COMPANY_ID AS NAME  FROM SCM_MST_COMPANY_SN WITH(NOLOCK)

			-- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)

			ORDER BY SCM_SITE_ID ASC;

		END
		ELSE
		BEGIN
			-- 20180612 소형 추가
			SELECT DISTINCT
					A.SCM_SITE_ID AS CODE
					, A.SCM_SITE_ID AS NAME
			FROM   SCM_MST_SITE AS A WITH(NOLOCK)
				LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK)
				ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
			WHERE  1 = 1
			AND    A.SITE_TYPE = 'SALES'
			AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1
						ELSE A.DIVISION_ID
 				END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
			AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2
						ELSE B.PROJECT_CODE
 				END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')
						)
			AND    A.DIVISION_ID IN (SELECT CODE
										FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    				WHERE  GroupID LIKE '%'+ @Param3 + '%'
							    		AND    UserID  LIKE '%'+ @Param4 + '%'
										AND    AuthType = 'D')
			AND A.VALID_YN = 'Y'

			UNION ALL	-- 20180822

			--SELECT DISTINCT CUSTOMER_CODE AS CODE
			--	, CUSTOMER_CODE AS NAME
			--FROM [LGCE_INFDEV].[DBO].[XIF_ERP_SALES_RESULT_R]
			--WHERE LEN(CUSTOMER_CODE) < 6 AND CUSTOMER_CODE <> ''

			-- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
											--SELECT SEGMENT1  AS CODE
											--	 , SEGMENT1  AS NAME
											--FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
											--WHERE LOOKUP_TYPE = 'INTERNAL_TXN'

			SELECT COMPANY_ID AS CODE,COMPANY_ID AS NAME  FROM SCM_MST_COMPANY_SN WITH(NOLOCK)

			-- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)


			ORDER BY A.SCM_SITE_ID ASC;
		END
	END

	/*===============================================
	용		 도:  Sales Site 에 InsertRow COMPANY_ID 콤보 조회
	사 용 화 면:  DMF0004_SalesSite
	변       수:  -
	최 초 작 성:  2018. 09. 07
	개  발  자 :  son young suk
	최 종 작 성:  2018. 09. 07
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'COMPANY_ID_INTERNAL_TXN'

	BEGIN

		-- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
										--SELECT SEGMENT1  AS CODE
										--		, SEGMENT1  AS NAME
										--FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
										--WHERE LOOKUP_TYPE = 'INTERNAL_TXN'
		SELECT COMPANY_ID AS CODE,COMPANY_ID AS NAME  FROM SCM_MST_COMPANY_SN WITH(NOLOCK)
		-- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)


	END


		/*===============================================
	용		 도:  EOL 에 Reason 콤보 조회
	사 용 화 면:  DMF0038_EOL
	변       수:  -
	최 초 작 성:  2018. 10. 23
	개  발  자 :  JYE
	최 종 작 성:  2018. 10. 23
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'EOL_ReasonCode'
	BEGIN

		SELECT SEGMENT1  AS CODE
				, SEGMENT2  AS NAME
		FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'EOL_REASON'

	END


	/*===============================================
	용		 도:  EOL 에 Status 콤보 조회
	사 용 화 면:  DMF0038_EOL
	변       수:  -
	최 초 작 성:  2018. 10. 23
	개  발  자 :  JYE
	최 종 작 성:  2018. 10. 23
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'EOL_ReasonStatus'
	BEGIN

		SELECT SEGMENT1  AS CODE
				, SEGMENT2  AS NAME
		FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'EOL_STATUS'

	END

	/*===============================================
	용		 도:  MDF Simulator > 담당 조회
	사 용 화 면:  DMF0041
	변       수:  -
	최 초 작 성:  2019. 02. 18
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0041_MDF_Team'
	BEGIN

		SELECT
			DEPT_ID	AS CODE
			, DEPT_NAME_KO		AS NAME
		FROM[DBO].[SCM_MST_SSO_DEPT_INFO] WITH(NOLOCK)
		WHERE DEPT_NAME_KO LIKE N'%소형%마케팅%담당'
		  AND VALID_YN = 'Y'

	END

	/*===============================================
	용		 도:  MDF Simulator > Measure 조회
	사 용 화 면:  DMF0041
	변       수:  -
	최 초 작 성:  2019. 02. 21
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0041_MDF_Measure'
	BEGIN

		SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME		-- 20190417
		FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)
		WHERE PROGRAM_ID = 'DMF0041' AND SHEET_NAME = 'MDFSimulator'
		ORDER BY SORT_ORDER_NO

		--SELECT SEGMENT1 AS CODE , SEGMENT2 AS NAME
		--FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL]
		--WHERE lookup_type = 'MDF_MEASURE_TYPE'
		--ORDER BY DISPLAY_SEQ

	END


	/*===============================================
	용		 도:  SSP Shipment Request(Small)
	사 용 화 면: SSP0016
	변       수:  -
	최 초 작 성:  2019. 03. 18
	개  발  자 :  YHW
	최 종 작 성:
	수  정  자 :
	수 정 사 항:  [PJ20189106] 전지.GSCM 고도화 이행- 소형 추가
	===============================================*/
	IF @Code = 'dtlocToSite'
	BEGIN

		SELECT DISTINCT PROJECT_CODE AS CODE, PROJECT_CODE AS NAME
		FROM SCM_MST_SITE_ITEM WITH(NOLOCK)
		WHERE DIVISION_ID = @Param1
		AND   ITEM_ID = @Param2
		AND   SCM_SITE_ID = @Param3
		ORDER BY PROJECT_CODE

	END

	/*===============================================
	용		 도:  SSP Shipment Request(Small)
	사 용 화 면:  SSP0016
	변       수:  -
	최 초 작 성:  2019. 03. 18
	개  발  자 :  YHW
	최 종 작 성:
	수  정  자 :
	수 정 사 항:  [PJ20189106] 전지.GSCM 고도화 이행- 소형 추가
	===============================================*/
	IF @Code = 'dtlocBodTotal'
	BEGIN

		SELECT TRANSPORT_MODE+':'+BOD_ID+':'+convert(nvarchar,ROUTE_ID)+':'+convert(nvarchar,LT_TOTAL) AS CODE
				, TRANSPORT_MODE NAME
		FROM   SCP_MST_BOD_V WITH(NOLOCK)
		WHERE  DIVISION_ID = @Param1
		AND    FROM_SITE   = @Param2

	END
	/*===============================================
	용		 도:  SSP Inventory Raw(Small)
	사 용 화 면:  SSP0017
	변       수:  -
	최 초 작 성:  2019. 03. 26
	개  발  자 :  mcthej
	최 종 작 성:
	수  정  자 :
	수 정 사 항:  [PJ20189106] 전지.GSCM 고도화 이행- 소형 추가
	===============================================*/
	IF @Code = 'OWMS_STOCK_STATUS'
	BEGIN

		SELECT
			SEGMENT1 AS CODE,
			NAME =	CASE @Param2
						WHEN 'KO' THEN SEGMENT2
						WHEN 'EN' THEN SEGMENT3
						WHEN 'CN' THEN SEGMENT4
					END

		FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE  LOOKUP_TYPE = @Param1
	END

	/*===============================================
	용		 도:  DMF0005 > 40 > 8개 칼럼 추가
	사 용 화 면:  DMF0041
	변       수:  -
	최 초 작 성:  2019. 04. 03
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0005_REPORT_GROUP1'
	BEGIN

	  SELECT L.SEGMENT1  AS CODE
		   , L.SEGMENT2  AS NAME
	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
	  WHERE  1 = 1
	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP1'
	  AND    L.VALID_YN    = 'Y'

	END
	IF @Code = 'DMF0005_REPORT_GROUP2'
	BEGIN

	  SELECT L.SEGMENT1  AS CODE
		   , L.SEGMENT2  AS NAME
	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
	  WHERE  1 = 1
	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP2'
	  AND    L.VALID_YN    = 'Y'

	END
	IF @Code = 'DMF0005_REPORT_GROUP3'
	BEGIN

	  SELECT L.SEGMENT1  AS CODE
		   , L.SEGMENT2  AS NAME
	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
	  WHERE  1 = 1
	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP3'
	  AND    L.VALID_YN    = 'Y'

	END
	IF @Code = 'DMF0005_REPORT_GROUP4'
	BEGIN

	  SELECT
			DISTINCT
			L.SEGMENT1  AS CODE
		   , L.SEGMENT2  AS NAME
	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
	  WHERE  1 = 1
	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP4'
	  AND    L.VALID_YN    = 'Y'

	END
	IF @Code = 'DMF0005_REPORT_GROUP5'
	BEGIN

	  SELECT L.SEGMENT1  AS CODE
		   , L.SEGMENT2  AS NAME
	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
	  WHERE  1 = 1
	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP5'
	  AND    L.VALID_YN    = 'Y'

	END
	IF @Code = 'DMF0005_REPORT_GROUP6'
	BEGIN

	  SELECT L.SEGMENT1  AS CODE
		   , L.SEGMENT2  AS NAME
	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
	  WHERE  1 = 1
	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP6'
	  AND    L.VALID_YN    = 'Y'

	END
	IF @Code = 'DMF0005_REPORT_GROUP7'
	BEGIN

	  SELECT L.SEGMENT1  AS CODE
		   , L.SEGMENT2  AS NAME
	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
	  WHERE  1 = 1
	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP7'
	  AND    L.VALID_YN    = 'Y'

	END
	IF @Code = 'DMF0005_REPORT_GROUP8'
	BEGIN

	  SELECT L.SEGMENT1  AS CODE
		   , L.SEGMENT2  AS NAME
	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
	  WHERE  1 = 1
	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP8'
	  AND    L.VALID_YN    = 'Y'

	END

	/*===============================================
	용		 도:  Business Plan > Measure 조회
	사 용 화 면:  DMF0042
	변       수:  -
	최 초 작 성:  2019. 04. 17
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0042_BP_Measure'
	BEGIN

		IF (@Param1 = '') BEGIN
			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME
			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)
			WHERE PROGRAM_ID = 'DMF0042' AND SHEET_NAME = 'Biz Plan'
			ORDER BY SORT_ORDER_NO
		END ELSE BEGIN
			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME
			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)
			WHERE PROGRAM_ID = 'DMF0042' AND SHEET_NAME = 'Biz Plan'
				--AND @Param1 IN (SELECT token FROM dbo.String_Split(DIVISION_ID ,',') )
				AND @Param1 IN (SELECT token FROM dbo.String_Split(DIVISION_ID ,',') )
			ORDER BY SORT_ORDER_NO
		END

	END

	/*===============================================
	용		 도:  MDF Simulator > Currency 조회
	사 용 화 면:  DMF0041
	변       수:  -
	최 초 작 성:  2019. 04. 24
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0041_MDF_Currency'
	BEGIN

		SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME
		FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)
		WHERE PROGRAM_ID = 'DMF0041' AND SHEET_NAME = 'MDF_Unit'
		ORDER BY SORT_ORDER_NO
	END

	/*===============================================
	용		 도:  Product Plan OSP PlanSite
	사 용 화 면:  Production Plan(OSP)
	변       수:  @PARAM1 = division_id
	최 초 작 성:  2019. 04. 19
	개  발  자 :  MCTHEJ
	최 종 작 성:  2019. 04. 19
	수  정  자 :
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'ProductionPlanOSP'
		BEGIN
			SELECT
				SCM_SITE_ID AS CODE,
				SITE_DESCRIPTION + ' ('+ SCM_SITE_ID + ')' AS NAME
			FROM SCM_MST_SITE WITH(NOLOCK)
			WHERE DIVISION_ID = '40'--@P_DIVISION_ID
			  AND   SITE_TYPE  = 'PLANT'
			  AND   OSP_YN  = 'Y'
			  AND   VALID_YN = 'Y'
			ORDER BY SITE_DESCRIPTION
		END

	/*===============================================
	용		 도:  MDF Reports > MDF Name 조회
	사 용 화 면:  DMF0044
	변       수:  -
	최 초 작 성:  2019. 05. 15
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0044_MDF_Name'

	BEGIN
		SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'MDF_NAME'
			AND VALID_YN = 'Y'
		ORDER BY DISPLAY_SEQ
	END

	/*===============================================
	용		 도:  MDF Reports > MDF Product Group 조회
	사 용 화 면:  DMF0044
	변       수:  -
	최 초 작 성:  2019. 05. 15
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0044_MDF_PRODUCT_GROUP'

	BEGIN
		SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'MDF_MODEL_TYPE'
			AND VALID_YN = 'Y'
		ORDER BY DISPLAY_SEQ
	END

	/*===============================================
	용		 도:  MDF Reports > Measure 조회
	사 용 화 면:  DMF0041
	변       수:  -
	최 초 작 성:  2019. 05. 15
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0044_MDF_MEASURE'
	BEGIN

		SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME
		FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)
		WHERE PROGRAM_ID = 'DMF0044' AND SHEET_NAME = 'MDF Reports'
		ORDER BY SORT_ORDER_NO
	END
	/*===============================================
	용		 도:  MDF Reports > Measure 조회
	사 용 화 면:  DMF0041
	변       수:  -
	최 초 작 성:  2020. 01. 19
	개  발  자 :  hwi1993
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0044_MDF_MEASURE_ETC'
	BEGIN

		SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME
		FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)
		WHERE PROGRAM_ID = 'DMF0044' AND SHEET_NAME = 'MDF Reports'
			AND COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC')
		ORDER BY SORT_ORDER_NO
	END

	/*===============================================
		용		 도:  CHANGE_REASON_CODE
		사 용 화 면:
		변       수:  @Param1 : Code, @Param2 : User
		최 초 작 성:  2018. 05. 23
		개  발  자 :  mcthej
		최 종 작 성:  2019. 05. 15
		수  정  자 :
		수 정 사 항:
		===============================================*/
		IF @Code = 'CHANGE_REASON_CODE_ALL'
		BEGIN
			SELECT
				T0.CODE
				, T0.NAME
			FROM
			(
				/*
				SELECT 'Select' AS CODE
						, '' AS NAME
						, 0 AS DISPLAY_SEQ
				UNION ALL
				SELECT 'C00' AS CODE
						--, N'change on the Shipment Plan Adjustment screen' AS NAME
						, 'C00 : Temp' AS NAME
						, 9999 AS DISPLAY_SEQ
				*/
				SELECT '-' AS CODE, NULL AS NAME, 0 AS DISPLAY_SEQ
				UNION ALL
				SELECT B.SEGMENT1 CODE
						,B.SEGMENT1 + ' : ' + CASE WHEN U.Language = 'KO' THEN B.SEGMENT2 ELSE B.SEGMENT3 END NAME
						,B.DISPLAY_SEQ AS DISPLAY_SEQ
				FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
				INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
				LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON U.UserID = @Param2 AND U.UseYN = 'Y'
				WHERE A.LOOKUP_TYPE = @Param1
					AND A.VALID_YN = 'Y'
			) T0
			ORDER BY T0.DISPLAY_SEQ

	    END

	/*===============================================
	용		 도:  MDF Reports > End Cust.(Report) 조회
	사 용 화 면:  DMF0044
	변       수:  -
	최 초 작 성:  2019. 05. 22
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0044_MDF_ENDCUST_REPORT'
	BEGIN

		-- ATTRIBUTE2/End Cust.(Report)
		SELECT DISTINCT T1.ATTRIBUTE2 AS CODE
			,T1.ATTRIBUTE2 AS NAME
		FROM	SCM_MST_SITE_ITEM		T1  WITH(NOLOCK)
		JOIN 	DM_MST_ITEM_SINGLE_V	T2  WITH(NOLOCK)
		ON	T1.DIVISION_ID = T2.DIVISION_ID
		AND	T1.ITEM_ID   = T2.ITEM_ID
		WHERE (T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '40' THEN T2.ITEM_TYPE ELSE 'H' END
			OR	 T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '40' THEN T2.ITEM_TYPE ELSE 'P' END)
			AND T1.ATTRIBUTE2 IS NOT NULL AND T1.ATTRIBUTE2 <> ''
		ORDER BY T1.ATTRIBUTE2
	END

	/*===============================================
	용		 도:  MDF Reports > Cust. (Report) 조회
	사 용 화 면:  DMF0044
	변       수:  -
	최 초 작 성:  2019. 05. 22
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0044_MDF_CUST_REPORT'
	BEGIN

		-- REPORT_GROUP2/Cust. (Report)
		SELECT DISTINCT T1.REPORT_GROUP2 AS CODE
			,T1.REPORT_GROUP2 AS NAME
		FROM	SCM_MST_SITE_ITEM		T1  WITH(NOLOCK)
		JOIN 	DM_MST_ITEM_SINGLE_V	T2  WITH(NOLOCK)
		ON	T1.DIVISION_ID = T2.DIVISION_ID
		AND	T1.ITEM_ID   = T2.ITEM_ID
		WHERE T1.REPORT_GROUP2 IS NOT NULL AND T1.REPORT_GROUP2 <> ''
	END

	/*===============================================
	용		 도:  MDF Reports > 담당 + MDF 조회
	사 용 화 면:  DMF0044
	변       수:  -
	최 초 작 성:  2019. 05. 23
	개  발  자 :  JYE
	최 종 작 성:
	수  정 자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0044_MDF_Team'
	BEGIN

		SELECT
			DEPT_ID	AS CODE
			, DEPT_NAME_KO		AS NAME
		FROM[DBO].[SCM_MST_SSO_DEPT_INFO] WITH(NOLOCK)
		WHERE DEPT_NAME_KO LIKE N'%소형%마케팅%담당'
		  AND VALID_YN = 'Y'
	END


	/*===============================================
	용		 도:  MDF Reports > Default Team 조회
	사 용 화 면:  DMF0044
	변       수:  -
	최 초 작 성:  2019. 05. 24
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0044_ETC_SALE_RESULT_TYPE_40'
	BEGIN

		SELECT L.SEGMENT1  AS CODE
			, L.SEGMENT2  AS NAME
		FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
		WHERE  1 = 1
		AND    L.LOOKUP_TYPE = 'DMF0044_ETC_SALE_RESULT_TYPE_40'
		AND    L.VALID_YN    = 'Y'

	END

	/*===============================================
	용		 도:  MDF Reports > Department -> Team 조회
	사 용 화 면:  DMF0044
	변       수:  -
	최 초 작 성:  2019. 05. 24
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0044_DEPARTMENT_TEAM'
	BEGIN

		--SELECT DISTINCT CODE, NAME
		--FROM
		--(
		--	SELECT 'MDF' AS CODE, 'MDF' AS NAME
		--	UNION ALL
		--	SELECT DISTINCT ISNULL(DEPT_ID, '')	AS CODE, ISNULL(DEPT_NAME, '')	AS NAME
		--	FROM [DBO].[DM_PLN_SALES_PLAN_REPORT_C]
		--	WHERE ISNULL(DEPT_ID, '') <> '' AND ISNULL(DEPT_NAME, '') <> ''
		--	UNION ALL
		--	SELECT DISTINCT ISNULL(DEPT_ID, '')	AS CODE, ISNULL(DEPT_NAME, '')	AS NAME
		--	FROM DM_PLN_BP_FCST_C
		--	WHERE ISNULL(DEPT_ID, '') <> '' AND ISNULL(DEPT_NAME, '') <> ''
		--) MA

		--SELECT 'MDF' AS CODE, 'MDF' AS NAME
		--UNION ALL
		SELECT DEPT_ID	AS CODE, DEPT_NAME_KO	AS NAME
		FROM [DBO].[SCM_MST_SSO_DEPT_INFO] WITH(NOLOCK)
		--FROM [DBO].[DM_PLN_SALES_PLAN_REPORT_C]
		WHERE UPPER_DEPT_ID = @Param1 AND VALID_YN = 'Y'

	END

	/*===============================================
	용		 도:  MDF Reports > Department -> Team 조회 (디스플레이 용)
	사 용 화 면:  DMF0044. 그리드 콤보에서 팀 조회
	변       수:  -
	최 초 작 성:  2019. 06. 03
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0044_DEPARTMENT_TEAM2'
	BEGIN

		IF @Param1 <> ''
		BEGIN
			IF @Param1 = '40'
			BEGIN
				SELECT L.SEGMENT1  AS CODE
					, L.SEGMENT2  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'
				AND    L.VALID_YN    = 'Y'
				--AND	   L.SEGMENT3 = CASE WHEN @Param4 = 'Y' THEN 'Y' ELSE L.SEGMENT3 END
				ORDER BY DISPLAY_SEQ
			END
			ELSE
			BEGIN
				SELECT L.SEGMENT1  AS CODE
					, L.SEGMENT2  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2_' + RTRIM(@Param1)
				AND    L.VALID_YN    = 'Y'
				--AND	   L.SEGMENT3 = CASE WHEN @Param4 = 'Y' THEN 'Y' ELSE L.SEGMENT3 END
				ORDER BY DISPLAY_SEQ
			END
		END
		ELSE
		BEGIN
			SELECT L.SEGMENT1  AS CODE
				, L.SEGMENT2  AS NAME
			FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
			WHERE  1 = 1
			AND    L.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'
			AND    L.VALID_YN    = 'Y'
			--AND	   L.SEGMENT3 = CASE WHEN @Param4 = 'Y' THEN 'Y' ELSE L.SEGMENT3 END
			ORDER BY DISPLAY_SEQ
		END

		--SELECT DISTINCT CODE, NAME
		--FROM
		--(
		--	SELECT 'MDF' AS CODE, 'MDF' AS NAME
		--	UNION
		--	SELECT CODE, NAME
		--	FROM (
		--		SELECT CODE, NAME, ROW_NUMBER() OVER (PARTITION BY CODE ORDER BY CRDATE DESC) AS ROW_NUM
		--		FROM (
		--			SELECT DEPT_ID AS CODE, DEPT_NAME AS NAME, MAX(CREATION_DATE) AS CRDATE
		--			FROM [DBO].[DM_PLN_SALES_PLAN_REPORT_C] WITH(NOLOCK)
		--			WHERE DEPT_ID <> '' AND DEPT_NAME <> ''
		--				AND DIVISION_ID = '40'
		--				AND CUTOFF_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(MONTH, -6, GETDATE()), 112)
		--			GROUP BY DEPT_ID, DEPT_NAME
		--			) A
		--		) X
		--	WHERE ROW_NUM = 1
		--	UNION
		--	SELECT CODE, NAME
		--	FROM (
		--		SELECT CODE, NAME, ROW_NUMBER() OVER (PARTITION BY CODE ORDER BY CRDATE DESC) AS ROW_NUM
		--		FROM (
		--			SELECT DEPT_ID AS CODE, DEPT_NAME AS NAME, MAX(CREATION_DATE) AS CRDATE
		--			FROM DM_PLN_BP_FCST_REPORT_C WITH(NOLOCK)
		--			WHERE DEPT_ID <> '' AND DEPT_NAME <> ''
		--				AND DIVISION_ID = '40'
		--				AND CUTOFF_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(MONTH, -6, GETDATE()), 112)
		--			GROUP BY DEPT_ID, DEPT_NAME
		--			) A
		--		) X
		--	WHERE ROW_NUM = 1
		--) MA
		--ORDER BY NAME
	END


	/*===============================================
	용		 도:  MDF Reports > Default 담당 조회(DEPARTMENT)
	사 용 화 면:  DMF0044
	변       수: -
	최 초 작 성:  2019. 06. 03
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0044_MDF_DEPARTMENT'
	BEGIN

		IF @Param1 <> ''
		BEGIN
			IF @Param1  = '40'
			BEGIN
				SELECT L.SEGMENT1  AS CODE
					, L.SEGMENT2  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'MDF_DEPARTMENT'
				AND    L.VALID_YN    = 'Y'
				ORDER BY DISPLAY_SEQ
			END
			ELSE
			BEGIN
				SELECT L.SEGMENT1  AS CODE
					, L.SEGMENT2  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'MDF_DEPARTMENT_' + RTRIM(@Param1)
				AND    L.VALID_YN    = 'Y'
				ORDER BY DISPLAY_SEQ
			END
		END
		ELSE	-- 파라미터 추가하기 전까지는 소형만 사용
		BEGIN
				SELECT L.SEGMENT1  AS CODE
					, L.SEGMENT2  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'MDF_DEPARTMENT'
				AND    L.VALID_YN    = 'Y'
				ORDER BY DISPLAY_SEQ
		END

	END

	/*===============================================
	용		 도:  DMF0005 > OS_CORP 칼럼
	사 용 화 면:  DMF0005
	변       수:  -
	최 초 작 성:  2019. 06. 13
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0005_DM_OS_CORP_CD'
	BEGIN

		SELECT L.SEGMENT1  AS CODE
			, L.SEGMENT2  AS NAME
		FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
		WHERE  1 = 1
		AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
		AND    L.VALID_YN    = 'Y'

	END

	/*===============================================
	용		 도:  MDF Reports > CONTRIBUTION_TYPE 칼럼
	사 용 화 면:  DMF0005
	변   수: -
	최 초 작 성:  2019. 06. 13
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0005_DM_CONTRIBUTION_TYPE_CD'
	BEGIN

		SELECT L.SEGMENT1  AS CODE
			, L.SEGMENT2  AS NAME
		FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
		WHERE  1 = 1
		AND    L.LOOKUP_TYPE = 'DM_CONTRIBUTION_TYPE_CD'
		AND    L.VALID_YN    = 'Y'

	END

	/*===============================================
	용		 도:  기여율 메인 > 부문 칼럼
	사 용 화 면:  DMF0043_Contribute_Main
	변       수:  -
	최 초 작 성:  2019. 06. 28
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0043_UPPER_DEPT'
	BEGIN
		SELECT
			DEPT_INFO.DEPT_ID AS CODE
			,DEPT_INFO.DEPT_NAME_KO AS NAME
			--,DEPT_INFO.DEPT_NAME_EN
		FROM (
			SELECT
				--DISTINCT C.DEPT_ID AS CODE , C.DEPT_NAME_KO AS NAME
				DISTINCT C.UPPER_DEPT_ID
			FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
				,[SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK)
				,[SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK)
			WHERE A.OWNER = B.USER_ID
				AND B.DEPT_ID = C.DEPT_ID
				AND A.DIVISION_ID = '40'
		) MA
		JOIN SCM_MST_SSO_DEPT_INFO AS DEPT_INFO
		ON DEPT_INFO.DEPT_ID = MA.UPPER_DEPT_ID
		ORDER BY DEPT_NAME_KO
	END

	/*===============================================
	용		 도:  기여율 메인 > 법인 칼럼
	사 용 화 면:  DMF0043_Contribute_Main
	변       수:  -
	최 초 작 성:  2019. 06. 28
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0043_COMPANT_ID'
	BEGIN
		SELECT
			DISTINCT
			MA.CODE
			,MA.NAME
		FROM (
		-- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
										--SELECT L.SEGMENT1  AS CODE
										--	, L.SEGMENT2  AS NAME
										--FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
										--WHERE  1 = 1
										--AND    L.LOOKUP_TYPE = 'INTERNAL_TXN'
										--AND   L.VALID_YN    = 'Y'
		SELECT COMPANY_ID AS CODE,COMPANY_NAME AS NAME  FROM SCM_MST_COMPANY_SN WITH(NOLOCK)
		-- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)

		) MA
		JOIN SCM_MST_SITE AS SITE
		ON MA.CODE = SITE.COMPANY_ID
	END

	/*===============================================
	용		 도:  기여율 메인 > 고객군 칼럼
	사 용 화 면:  DMF0043_Contribute_Main
	변       수:  -
	최 초 작 성:  2019. 06. 28
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0043_END_CUST_REPORT'
	BEGIN
		SELECT DISTINCT ATTRIBUTE2 COLLATE Korean_Wansung_CS_AS AS CODE, ATTRIBUTE2 COLLATE Korean_Wansung_CS_AS AS NAME
		FROM SCM_MST_SITE_ITEM WITH(NOLOCK)
		WHERE ATTRIBUTE2 IS NOT NULL AND ATTRIBUTE2 <> ''
		ORDER BY CODE
	END

	/*===============================================
	용		 도:  기여율 메인 > 고객상세 칼럼
	사 용 화 면:  DMF0043_Contribute_Main
	변       수:  -
	최 초 작 성:  2019. 06. 28
	개  발  자 :  JYE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	IF @Code = 'DMF0043_CUST_GROUP_DTL'
	BEGIN
		SELECT DISTINCT ATTRIBUTE1 COLLATE Korean_Wansung_CS_AS AS CODE, ATTRIBUTE1 COLLATE Korean_Wansung_CS_AS AS NAME
		FROM SCM_MST_SITE_ITEM WITH(NOLOCK)
		WHERE ATTRIBUTE1 IS NOT NULL AND ATTRIBUTE1 <> ''
		ORDER BY CODE
	END

	/*===============================================
	용		 도:  FCST TYPE LOOKUP COMBO BOX - Warranty 용도.
	사 용 화 면:  DM0003_DM_PLN_MKT_FCST	-	FCST_TYPE컬럼
	변       수:  -
	최 초 작 성:  2019. 08	.08
	개  발  자 :  JYE
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	IF @Code = 'FCST_TYPE_NOT_ETC2'
	BEGIN
		SELECT SEGMENT1 AS CODE
		     , SEGMENT2 AS NAME
		     , DISPLAY_SEQ
		FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE  1 = 1
		AND    VALID_YN    = 'Y'
		AND    LOOKUP_TYPE = 'SALES_TYPE_CODE2'
		AND    SEGMENT1   <> 'ETC'
		ORDER BY DISPLAY_SEQ
	END

	/*===============================================
	 용		  도: Line Master
	 사 용 화 면: Line Master
	 변       수:  -
	 최 초 작 성:  2020. 02. 03
	 개  발 자 :  hwyoon
	 최  종 작 성:  -
	 수  정  자 :  -
	 수 정 사 항:
	===============================================*/
	 ELSE IF @Code = 'LineByOperationOsp'
		BEGIN
			SELECT LINE_ID AS CODE
					, LINE_NAME AS NAME
					, DIVISION_ID
					, SCM_SITE_ID
			FROM SCM_MST_LINE_OSP WITH(NOLOCK)
			WHERE 1=1
			AND ISNULL(VALID_YN,'Y')='Y'
		END;
	/*===============================================
	 용		  도: DM 에서 CompanyId 를 룩업에서 찾아다 사용
	 사 용 화 면: DMF0044_SalesReport
	 변       수:  -
	 최 초 작 성:  2020. 02. 04
	 개  발  자 :  hwi1993
	 최  종 작 성:  -
	 수  정  자 :  -
	 수 정 사 항:
	===============================================*/
	 ELSE IF @Code = 'DM_COMPANY'
		BEGIN

		SELECT B.SEGMENT1 CODE
			  ,B.SEGMENT2 NAME
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
		WHERE A.LOOKUP_TYPE = 'DM_COMPANY'
		  AND A.VALID_YN = 'Y'
		ORDER BY B.DISPLAY_SEQ
		END;
	/*===============================================
	 용		  도: [C20200221-000128] End-Cust. (Report) 셀 Drop Down List 추가
	 사 용 화 면: DMF0005_SaleSite_PjtModelMapping
	 변       수: -
	 최 초 작 성: 2020. 02. 26
	 개  발  자 : P.C.I
	 최  종 작 성:  -
	 수  정  자 :  -
	 수 정 사 항:
	===============================================*/
	 ELSE IF @Code = 'EndCustReport'
		BEGIN
			SELECT B.SEGMENT1 CODE
				  ,B.SEGMENT2 NAME
			FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
			INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
			WHERE A.LOOKUP_TYPE = 'END_CUST_REPORT'
			  AND A.VALID_YN = 'Y'
			ORDER BY B.DISPLAY_SEQ
		END;

	/*===============================================
	 용		  도: [C20200221-000128] Sold-To Cust.(Report) 셀 Drop Down List 추가
	 사 용 화 면: DMF0005_SaleSite_PjtModelMapping
	 변       수: -
	 최 초 작 성: 2020. 02. 26
	 개  발  자 : P.C.I
	 최  종 작 성:  -
	 수  정  자 :  -
	 수 정 사 항:  2020.10.15 hwi1993 [C20201008-000332] 정렬순서 수정 ( 코드순으로 )
	===============================================*/
	 ELSE IF @Code = 'SoldToCustReport'
		BEGIN
			SELECT B.SEGMENT1 CODE
				  ,B.SEGMENT2 NAME
			FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
			INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
			WHERE A.LOOKUP_TYPE = 'SOLD_TO_CUST_REPORT'
			  AND A.VALID_YN = 'Y'
			ORDER BY B.SEGMENT1
		END;
	/*===============================================
		용		 도:  LOOKUP 을 DIV 조건으로 조회
		사 용 화 면:  DMF0049
		변       수:  @PARAM1 = DIVISION
					  @PARAM2 = LOOKUP_TYPE
					  SEGMENT1 이 DIVISION 이어야 함. 이후 SEG2 : CODE, SEG3 : NAME 형식
		최 초 작 성:  2020. 04. 08
		개  발  자 :  김 영 휘
		최 종 작 성:  2020. 04. 08
		수  정  자 :  김 영 휘
		수 정 사 항:
		===============================================*/
		ELSE IF @Code = 'DM_LOOKUP_DIV'
			BEGIN
				SELECT B.SEGMENT2 CODE
					 ,B.SEGMENT3 NAME
				FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
				INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
				WHERE A.LOOKUP_TYPE = @param2
				  AND B.SEGMENT1 = @param1
				  AND A.VALID_YN = 'Y'
				ORDER BY B.DISPLAY_SEQ
			END;
		/*===============================================
		용		 도:  PLANT SITE 조회
		사 용 화 면:  SSP0024
		변       수:  @PARAM1 = DIVISION_ID
		최 초 작 성:  2020. 04. 22
		개  발  자 :  khj79
		최 종 작 성:  2020. 04. 22
		수  정  자 :
		수 정 사 항:
		===============================================*/
		ELSE IF @Code = 'PlantSiteByFactoryEEOperation'
		BEGIN
			 SELECT DISTINCT
			        A.SCM_SITE_ID      AS CODE
				  , A.SITE_DESCRIPTION AS NAME
				  , A.DIVISION_ID      AS DIVISION_ID
				  , A.PLANT_ID         AS PLANT_ID
			   FROM [dbo].[SCM_MST_SITE] A WITH(NOLOCK)
			   JOIN [dbo].[SCM_MST_FACTORY_SN] F WITH(NOLOCK)
				 ON A.COMPANY_ID  = F.COMPANY_ID
				AND A.PLANT_ID    = F.PLANT_ID
				AND A.DIVISION_ID = F.DIVISION_ID
			  WHERE 1 = 1
			    AND A.SITE_TYPE = 'PLANT'
				AND A.VALID_YN  = 'Y'
				AND A.OPERATION_GROUP = 'E'
			    AND A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,','))

		END
		/*===============================================
		용		 도:  동,동명 조회
		사 용 화 면:  SSP0024
		변       수:  @PARAM1 = DIVISION_ID
					  @PARAM2 = PLANT_ID
		최 초 작 성:  2020. 04. 22
		개  발  자 :  khj79
		최 종 작 성:  2020. 06. 28
		수  정  자 :  khj79
		수 정 사 항:  COMPANY_ID 추가 , SCM_SITE_ID 추가
		===============================================*/
		ELSE IF @Code = 'BuildingForShipMasterElec'
			BEGIN
				SELECT
				  DISTINCT
						  F.FACTORY_NAME  AS CODE
						, F.FACTORY_ID    AS NAME
						, F.DIVISION_ID   AS DIVISION_ID
						, F.PLANT_ID      AS PLANT_ID
						, F.COMPANY_ID    AS COMPANY_ID
						, S.SCM_SITE_ID   AS SCM_SITE_ID
				     FROM [dbo].[SCM_MST_FACTORY_SN] F WITH(NOLOCK)
				     JOIN [dbo].[SCM_MST_SITE] S WITH(NOLOCK)
					   ON S.DIVISION_ID = F.DIVISION_ID
					  AND S.PLANT_ID    = F.PLANT_ID
				 WHERE 1=1
					AND ( (@Param1 IS NULL or @Param1='') OR F.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,','))  )
					AND ( (@Param2 IS NULL or @Param2='') OR F.PLANT_ID IN ( SELECT token FROM dbo.String_Split(@Param2,','))  )
			END
		/*===============================================
		용		 도:  후공정타입 LOOKUP 조회
		사 용 화 면:  SSP0024
		변       수:  @PARAM1 = DIVISION_ID
		최 초 작 성:  2020. 04. 22
		개  발  자 :  khj79
		최 종 작 성:
		수  정  자 :
		수 정 사 항:
		===============================================*/
		ELSE IF @Code = 'ElectrodePostOperCode'
			BEGIN
				SELECT  SEGMENT2 AS CODE -- ELECTRODE_POST_OPER_CODE
					 , SEGMENT4 AS NAME -- Post Oper.
					 , SEGMENT5 AS POST_OPER_LT -- Post Oper. LT(Day)
					 , SEGMENT1 AS DIVISION_ID
				  FROM  SCM_ADM_LOOKUP_MASTER_DETAIL LP WITH(NOLOCK)
				 WHERE LP.LOOKUP_TYPE = 'ELECTRODE_POST_OPER_CODE'
				   AND LP.VALID_YN    = 'Y'
				   AND ( (@Param1 IS NULL or @Param1='') OR LP.SEGMENT1 IN ( SELECT token FROM dbo.String_Split(@Param1,','))  )
			END;
		/*===============================================
		용		 도:  내외수 코드 조회
		사 용 화 면:  SSP0024
		변       수:
		최 초 작 성:  2020. 04. 22
		개  발  자 :  khj79
		최 종 작 성:  2020. 04. 22
		수  정  자 :
		수 정 사 항:
		===============================================*/
		ELSE IF @Code = 'DomExpTypeCode'
			BEGIN
				SELECT L.SEGMENT1  AS CODE
					 , L.SEGMENT2  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'DOM_EXP_TYPE_CODE'
				ORDER BY L.DISPLAY_SEQ
			END;
		/*===============================================
		용		 도:  팩키지 유형 조회
		사 용 화 면:  SSP0024
		변       수:
		최 초 작 성:  2020. 04. 23
		개  발  자 :  khj79
		최 종 작 성:  2020. 04. 23
		수  정  자 :
		수 정 사 항:
		===============================================*/
		ELSE IF @Code = 'ElectrodePackageType'
			BEGIN
				SELECT L.SEGMENT1  AS CODE
					 , L.SEGMENT2 AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
				WHERE  1 = 1
				AND    L.LOOKUP_TYPE = 'ELECTRODE_PACKAGE_TYPE'
				ORDER BY L.DISPLAY_SEQ
			END;
		/*===============================================
		용		 도:  전극 PLANT 조회
		사 용 화 면:  SSP0022
		변       수:
		최 초 작 성:  2020. 04. 29
		개  발  자 :  KIMYONGHO
		최 종 작 성:  2020. 04. 29
		수  정  자 :
		수 정 사 항:
		===============================================*/
		ELSE IF @Code = 'PlantEE'
			BEGIN
				SELECT DISTINCT
					  LOGISTIC_PLANT_ID      AS CODE
					, LOGISTIC_PLANT_ID      AS NAME
				FROM SCM_MST_SITE S
				WHERE (@Param1 IS NULL OR @Param1='' OR DIVISION_ID=@Param1)
					AND (@Param2 IS NULL OR @Param2='' OR COMPANY_ID=@Param2)
					AND SITE_TYPE = 'PLANT'
					AND OPERATION_GROUP  ='E'
					AND OSP_YN = 'N'
				ORDER  BY S.LOGISTIC_PLANT_ID DESC
			END;
		ELSE IF @Code = 'PlantByElectordeShipFromSite'
			BEGIN
				SELECT SEGMENT3  AS CODE
					, SEGMENT3  AS NAME
				fROM SCM_ADM_LOOKUP_MASTER_DETAIL
				WHERE LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
				AND VALID_YN = 'Y'
				AND (@Param1 IS NULL OR @Param1='' OR SEGMENT5=@Param1)
				AND (@Param2 IS NULL OR @Param2='' OR SEGMENT4=@Param2)
				--AND (@Param1 IS NULL OR @Param1='' OR SEGMENT2=@Param1)
				--AND (@Param2 IS NULL OR @Param2='' OR SEGMENT1!=@Param2)
				GROUP BY SEGMENT3
			END;
		ELSE IF @Code = 'PlantByElectordeShipToSite'
			BEGIN
				SELECT ATTRIBUTE1  AS CODE
					, ATTRIBUTE1  AS NAME
				fROM SCM_ADM_LOOKUP_MASTER_DETAIL
				WHERE LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
				AND VALID_YN = 'Y'
				AND (@Param1 IS NULL OR @Param1='' OR SEGMENT5=@Param1)
				AND (@Param2 IS NULL OR @Param2='' OR SEGMENT4=@Param2)
				--AND (@Param1 IS NULL OR @Param1='' OR SEGMENT2=@Param1)
				--AND (@Param2 IS NULL OR @Param2='' OR SEGMENT4=@Param2)

				GROUP BY  ATTRIBUTE1
			END;
		ELSE IF @Code = 'PlantByElectordeShipToSite_EE'
			BEGIN
				SELECT ATTRIBUTE1  AS CODE
					, ATTRIBUTE1  AS NAME
				fROM SCM_ADM_LOOKUP_MASTER_DETAIL
				WHERE LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
				AND VALID_YN = 'Y'
				AND (@Param1 IS NULL OR @Param1='' OR SEGMENT2=@Param1)
				AND (@Param2 IS NULL OR @Param2='' OR SEGMENT3=@Param2)
				--AND (@Param1 IS NULL OR @Param1='' OR SEGMENT2=@Param1)
				--AND (@Param2 IS NULL OR @Param2='' OR SEGMENT4=@Param2)

				GROUP BY  ATTRIBUTE1
			END;
		/*===============================================
		용		 도:  TRANS MODE 조회
		사 용 화 면:  SSP0023
		변       수:
		최 초 작 성:  2020. 05. 13
		개  발  자 :  khj79
		최 종 작 성:  2020. 05. 13
		수  정  자 :
		수 정 사 항:
		===============================================*/
		ELSE IF @Code = 'TransModeCode'
			BEGIN
				SELECT L.SEGMENT1  AS CODE
					 , L.SEGMENT2  AS NAME
				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
				WHERE  1 = 1
				AND   L.LOOKUP_TYPE = 'TRANSPORT_MODE_CODE'
				ORDER BY L.DISPLAY_SEQ
			END;

		/*===============================================
		용		 도:  [C20200513-000276] Sales Company 조회
		사 용 화 면:  DMF0005
		변       수:
		최 초 작 성:  2020. 05. 14
		개  발  자 :  P.C.I
		최 종 작 성:  2020. 05. 14
		수  정  자 :
		수 정 사 항:  [C20200521-000207] SalesCompany, SalesPlant 에 Division, Project, Item 조건 추가
		1. Item Master의 SCP_OPERATION_GROUP 에 해당하는 Plant만 List에 조회 됨
		2. Item Master의 SCP_OPERATION_GROUP 이 없는 경우에 모든 Plant가 List에 조회 됨
		3. Site Type이 'CORP' 인 Plant는 항상 List에 조회 됨
		2020.05.29 HWI1993 OSP_YN 제거, 첫번째 구문을 SITE_TYPE IN ( 'PLANT', 'CORP') 으로 변경
		[C20200608-000328] SalesCompany 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회
		[C20200626-000172] SalesCompany, SalesPlant 에 Item Type is not null 조건 추가
		[C20200818-000264] Sales Company / Sales Plant - Project_Item Master Valid 조건 제외
		2021.08.13 hwi1993	속도개선 테스트
		===============================================*/
		ELSE IF @Code = 'SalesCompany'
			BEGIN
				IF ( @Param4 = '')
				BEGIN
					SELECT DISTINCT
						   S.COMPANY_ID AS CODE
						 , S.COMPANY_ID AS NAME
					FROM   SCM_MST_SITE S WITH(NOLOCK)
					WHERE SITE_TYPE = 'PLANT'
						AND    (@Param1 IS NULL OR @Param1='' OR PLANT_ID=@Param1)
						AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)
					UNION ALL
					SELECT DISTINCT
						   COMPANY_ID AS CODE
						 , COMPANY_ID AS NAME
					FROM   SCM_MST_SITE S WITH(NOLOCK)
					WHERE  1 = 1
						AND    SITE_TYPE = 'CORP'
						AND    (@Param1 IS NULL OR @Param1='' OR PLANT_ID=@Param1)
						AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)
					ORDER BY 1,2

				END
				ELSE
				BEGIN
					SELECT DISTINCT
						   S.COMPANY_ID AS CODE
						 , S.COMPANY_ID AS NAME
					FROM   SCM_MST_SITE S WITH(NOLOCK)
					INNER join (SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP --[C20200608-000328] SalesCompany 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회
								from   scm_mst_project_item SI with(nolock)
								inner join SCM_MST_ITEM_SN I with(nolock)
								on     SI.ITEM_ID = I.ITEM_ID
								--AND    SCP_OPERATION_GROUP IS NOT NULL --[C20200608-000328] SalesCompany 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회
								WHERE  1=1 --si.valid_yn = 'Y' --[C20200818-000264] Project_Item Master Valid 조건 제외, Item Master Valid 조건 추가
								AND    i.active_flag = 'Y'
								AND    (i.division_id LIKE '81%' OR i.division_id = '82')
								AND    i.item_type is not null --[C20200626-000172] SalesCompany, SalesPlant Item Type is not null 조건 추가
								AND    (@Param2 IS NULL OR @Param2='' OR SI.DIVISION_ID=@Param2)
								AND    (@Param3 IS NULL OR @Param3='' OR SI.PROJECT_CODE=@Param3)
								AND    (@Param4 IS NULL OR @Param4='' OR SI.ITEM_ID=@Param4)

								UNION ALL
								SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP --[C20200608-000328] SalesCompany 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회
								from   SCM_MST_ITEM_SN I with(nolock)
								WHERE  1=1
								AND    i.active_flag = 'Y' --[C20200818-000264] Project_Item Master Valid 조건 제외, Item Master Valid 조건 추가
								AND    i.division_id in ('40')
								AND    i.item_type is not null --[C20200626-000172] SalesCompany, SalesPlant 에 Item Type is not null 조건 추가
								AND    (@Param2 IS NULL OR @Param2='' OR I.DIVISION_ID=@Param2)
								AND    (@Param4 IS NULL OR @Param4='' OR I.ITEM_ID=@Param4)
								) SS
					ON  S.DIVISION_ID = SS.DIVISION_ID
					AND S.OPERATION_GROUP = ISNULL(SS.SCP_OPERATION_GROUP, S.OPERATION_GROUP)
					AND S.COMPANY_ID = SS.COMPANY_ID --[C20200608-000328] SalesCompany 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회
					WHERE  1 = 1
					AND    SITE_TYPE = 'PLANT'
					--AND    OSP_YN    <> 'Y'
					AND    (@Param1 IS NULL OR @Param1='' OR PLANT_ID=@Param1)
					AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)
					UNION ALL
					SELECT DISTINCT
						   COMPANY_ID AS CODE
						 , COMPANY_ID AS NAME
					FROM   SCM_MST_SITE S WITH(NOLOCK)
					WHERE  1 = 1
					AND    SITE_TYPE = 'CORP'
					AND    (@Param1 IS NULL OR @Param1='' OR PLANT_ID=@Param1)
					AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)
					ORDER BY 1,2
				END

			END;
		/*===============================================
		용		 도:  [C20200513-000276] Sales Plant 조회
		사 용 화 면:  DMF0005
		변       수:
		최 초 작 성:  2020. 05. 14
		개  발  자 :  P.C.I
		최 종 작 성:  2020. 05. 14
		수  정  자 :
		수 정 사 항:  [C20200521-000207] SalesCompany, SalesPlant 에 Division, Project, Item 조건 추가
		1. Item Master의 SCP_OPERATION_GROUP 에 해당하는 Plant만 List에 조회 됨
		2. Item Master의 SCP_OPERATION_GROUP 이 없는 경우에 모든 Plant가 List에 조회 됨
		3. Site Type이 'CORP' 인 Plant는 항상 List에 조회 됨
		2020.05.29 HWI1993 OSP_YN 제거 --> CASE 문으로 CODE, NAME 에서 OSP_YN 처리
		[C20200608-000328]  SalesPlant 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회
		[C20200626-000172] SalesCompany, SalesPlant 에 Item Type is not null 조건 추가
		[C20200818-000264] Sales Company / Sales Plant - Project_Item Master Valid 조건 제외
		2021.08.13 hwi1993	속도개선 테스트
		===============================================*/
		ELSE IF @Code = 'SalesPlant'
			BEGIN
				IF ( ISNULL(@Param4,'') = '')
				BEGIN
					SELECT DISTINCT
						   CASE WHEN OSP_YN = 'Y' THEN LOGISTIC_PLANT_ID ELSE PLANT_ID END AS CODE
						 , CASE WHEN OSP_YN = 'Y' THEN LOGISTIC_PLANT_ID ELSE PLANT_ID END AS NAME
					FROM   SCM_MST_SITE S WITH(NOLOCK)
					WHERE  1 = 1
					AND    SITE_TYPE = 'PLANT'
					--AND    OSP_YN    <> 'Y'
					AND    (@Param1 IS NULL OR @Param1='' OR S.COMPANY_ID=@Param1)
					AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)
					UNION ALL
					SELECT DISTINCT
						   PLANT_ID AS CODE
						 , PLANT_ID AS NAME
					FROM   SCM_MST_SITE S WITH(NOLOCK)
					WHERE  1 = 1
					AND    SITE_TYPE = 'CORP'
					AND    (@Param1 IS NULL OR @Param1='' OR S.COMPANY_ID=@Param1)
					AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)
					ORDER BY 1,2
				END
				ELSE
				BEGIN
					SELECT DISTINCT
						   CASE WHEN OSP_YN = 'Y' THEN LOGISTIC_PLANT_ID ELSE PLANT_ID END AS CODE
						 , CASE WHEN OSP_YN = 'Y' THEN LOGISTIC_PLANT_ID ELSE PLANT_ID END AS NAME
					FROM   SCM_MST_SITE S WITH(NOLOCK)
					INNER join (SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP --[C20200608-000328] SalesCompany 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회
								from   scm_mst_project_item SI with(nolock)
								inner join SCM_MST_ITEM_SN I with(nolock)
								on     SI.ITEM_ID = I.ITEM_ID
								--AND    SCP_OPERATION_GROUP IS NOT NULL --[C20200608-000328] SalesCompany 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회
								WHERE  1=1 --si.valid_yn = 'Y' --[C20200818-000264] Project_Item Master Valid 조건 제외, Item Master Valid 조건 추가
								AND    i.active_flag = 'Y'
								AND    (i.division_id LIKE '81%' OR i.division_id = '82')
								AND    i.item_type is not null --[C20200626-000172] SalesCompany, SalesPlant 에 Item Type is not null 조건 추가
								AND    (@Param2 IS NULL OR @Param2='' OR SI.DIVISION_ID=@Param2)
								AND    (@Param3 IS NULL OR @Param3='' OR SI.PROJECT_CODE=@Param3)
								AND    (@Param4 IS NULL OR @Param4='' OR SI.ITEM_ID=@Param4)
								UNION ALL
								SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP --[C20200608-000328] SalesCompany 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회
								from   SCM_MST_ITEM_SN I with(nolock)
								WHERE  1=1
								AND    i.active_flag = 'Y' --[C20200818-000264] Project_Item Master Valid 조건 제외, Item Master Valid 조건 추가
								AND    i.division_id in ('40')
								AND    i.item_type is not null --[C20200626-000172] SalesCompany, SalesPlant 에 Item Type is not null 조건 추가
								AND    (@Param2 IS NULL OR @Param2='' OR I.DIVISION_ID=@Param2)
								AND    (@Param4 IS NULL OR @Param4='' OR I.ITEM_ID=@Param4)
								) SS
					ON  S.DIVISION_ID = SS.DIVISION_ID
					AND S.OPERATION_GROUP = ISNULL(SS.SCP_OPERATION_GROUP, S.OPERATION_GROUP)
					AND S.COMPANY_ID = SS.COMPANY_ID --[C20200608-000328] SalesPlant 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회
					WHERE  1 = 1
					AND    SITE_TYPE = 'PLANT'
					--AND    OSP_YN    <> 'Y'
					AND    (@Param1 IS NULL OR @Param1='' OR S.COMPANY_ID=@Param1)
					AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)
					UNION ALL
					SELECT DISTINCT
						   PLANT_ID AS CODE
						 , PLANT_ID AS NAME
					FROM   SCM_MST_SITE S WITH(NOLOCK)
					WHERE  1 = 1
					AND    SITE_TYPE = 'CORP'
					AND    (@Param1 IS NULL OR @Param1='' OR S.COMPANY_ID=@Param1)
					AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)
					ORDER BY 1,2
				END

			END;

		/*===============================================
		용		 도:  [C20200525-000296] Plant Site에 Division, Project, Item 조건 추가
		사 용 화 면:  DMF0005
		변   수:
		최 초 작 성:  2020. 06. 01
		개  발  자 :  P.C.I
		최 종 작 성:  2020. 06. 01
		수  정  자 :
		수 정 사 항:
		[C20200702-000136] 자동차사업부 - PlantSiteByItem은 Item Master의 Company ID, Operation Group 기준으로 조회
		[C20200827-000094] PlantSiteByItem - 자동차 전극(EE) 로직 추가, Project_Item Master Valid 조건 제외
		===============================================*/
		ELSE IF @Code = 'PlantSiteByItem'
			BEGIN

				SELECT DISTINCT
						SCM_SITE_ID AS CODE
					  , SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE S WITH(NOLOCK)
				INNER join (SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID --[C20200702-000136] PlantSiteByItem은 Item Master의 Company ID, Operation Group 기준으로 조회
						 , (CASE WHEN I.SCP_OPERATION_GROUP = 'E' THEN 'A' ELSE I.SCP_OPERATION_GROUP END) AS SCP_OPERATION_GROUP --[C20200827-000094] 자동차 전극(EE) 로직 추가 반영
							from   scm_mst_project_item SI with(nolock)
							inner join SCM_MST_ITEM_SN I with(nolock)
							on     SI.ITEM_ID = I.ITEM_ID
							WHERE  1=1 --si.valid_yn = 'Y' --[C20200827-000094] Project_Item Master Valid 조건 제외
							AND    i.item_type is not null
							AND    (@Param2 IS NULL OR @Param2='' OR SI.DIVISION_ID=@Param2)
							AND    (@Param3 IS NULL OR @Param3='' OR SI.PROJECT_CODE=@Param3)
							AND    (@Param4 IS NULL OR @Param4='' OR SI.ITEM_ID=@Param4)
							) SS
				ON  S.DIVISION_ID = SS.DIVISION_ID
				AND S.OPERATION_GROUP = ISNULL(SS.SCP_OPERATION_GROUP, S.OPERATION_GROUP)
				AND S.COMPANY_ID = SS.COMPANY_ID --[C20200702-000136] PlantSiteByItem은 Item Master의 Company ID, Operation Group 기준으로 조회
				WHERE  1 = 1
				AND    SITE_TYPE = 'PLANT'
				AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)
				ORDER BY 1,2

			END;
		/*===============================================
		용		 도:  [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - PLANT 조회
		사 용 화 면:  SSP0025
		변       수:
		최 초 작 성:  2020. 06. 24
		개  발  자 :  khj79
		최 종 작 성:  2020. 06. 24
		수  정  자 :
		수 정 사 항:
		===============================================*/
		ELSE IF @Code = 'PlantCell'
			BEGIN
				SELECT DISTINCT
				       S.SCM_SITE_ID		AS CODE
				     , S.SITE_DESCRIPTION	AS NAME
				  FROM SCM_MST_SITE S WITH(NOLOCK)
				 WHERE (@Param1 IS NULL OR @Param1='' OR S.DIVISION_ID = @Param1)
				   AND S.OPERATION_GROUP    =  'A'	-- CELL
				   AND ISNULL(S.OSP_YN,'Y') <> 'Y'
				ORDER BY S.SITE_DESCRIPTION
			END;
		/*===============================================
		용		 도:  [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 조립 기준 From Site 조회
		사 용 화 면:  SSP0025
		변       수:
		최 초 작 성:  2020. 06. 25
		개  발  자 :  khj79
		최 종 작 성:  2020. 06. 25
		수  정  자 :
		수 정 사 항:
		===============================================*/
		ELSE IF @Code = 'FromSiteByAssembly'
			BEGIN
				SELECT DISTINCT
					   S.SCM_SITE_ID		AS CODE
					 , S.SITE_DESCRIPTION	AS NAME
					 , S.DIVISION_ID		AS DIVISION_ID
					 --, L.SEGMENT5			AS DIVISION_ID_ASS
					 --, L.ATTRIBUTE1			AS SCM_SITE_ID_ASS
				  FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
				  JOIN SCM_MST_SITE S WITH(NOLOCK)
					ON S.DIVISION_ID = L.SEGMENT2 -- 전극
				   AND S.SCM_SITE_ID = L.SEGMENT3
				 WHERE L.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
				 AND (@Param1 IS NULL OR @Param1='' OR L.SEGMENT5   = @Param1) -- DIVISION   -- 조립
				   AND (@Param2 IS NULL OR @Param2='' OR L.ATTRIBUTE1 = @Param2)  --TO_SITE  -- 조립
			END;
	/*===============================================
		용		 도:  FP Site 정보 조회
		사 용 화 면:  SCP0050_MDMAuthManagement
		변    수:
		최 초 작 성:  2020. 07. 21
		개  발  자 :  khj79
		수  정  자 :
		수 정 사 항:
		===============================================*/
		ELSE IF @Code = 'SiteFP'
			BEGIN
				SELECT distinct
					   S.SITE_ID	AS CODE
					 , S.SITE_NAME	AS NAME
				  FROM SCM_MST_SITE_SN S WITH(NOLOCK)
				 WHERE 1 = 1
				   AND (@Param1 IS NULL OR @Param1='' OR S.COMPANY_ID = @Param1)
				 ORDER BY S.SITE_ID
			END
		/*===============================================
		용		 도:  LOSS CODE CATEGORY_ID 조회
		사 용 화 면:  CAPA PIC(SCP0050)
		변       수:
		최 초 작 성:  2020. 07. 21
		개  발  자 :  khj79
		수  정  자 :  khj79
		수 정 사 항:  'M11' 조건 추가
		===============================================*/
		ELSE IF @Code = 'MDMCategoryId'
			BEGIN
				SELECT DISTINCT
					   ATTRIBUTE1 AS CODE
					 , ATTRIBUTE1 AS NAME
				  FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
				 WHERE 1=1
				   AND LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
				   AND ACTIVE_FLAG = 'Y'
				   --AND SEGMENT1 NOT IN ('M08','M10','M11')
				   AND ATTRIBUTE7 = 'Y'
			END
		/*===============================================
		용		 도:  LOSS CODE KEY_ID 조회
		사 용 화 면:  CAPA PIC(SCP0050)
		변  수:
		최 초 작 성:  2020. 07. 21
		개  발  자 :  khj79
		수  정  자 :  khj79
		수 정 사 항:  'M11' 조건 추가
		===============================================*/
		ELSE IF @Code = 'MDMKeyId'
			BEGIN
				SELECT SEGMENT1   AS CODE
					 , CASE WHEN SEGMENT1 IN ('LA001', 'LA002','LA003' ) THEN ATTRIBUTE1
							ELSE ATTRIBUTE2
					   END        AS NAME
					 , SEGMENT1   AS LOSS_CODE
					 , ATTRIBUTE1 AS CATEGORY_ID
					 , ATTRIBUTE3 AS DATA_TABLE
					 , ATTRIBUTE4 AS OFF_CAL
					 , ATTRIBUTE5 AS FP_UTIL_CAL
					 , ATTRIBUTE6 AS SCP_UTIL_CAL
					 , SORT_ORDER
				  FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
				 WHERE 1=1
				   AND LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT' -- LOSS_TYPE_DEFINITION => CAPA_UI_LOSS_TYPE_DEFINIT 변경
				   AND ACTIVE_FLAG = 'Y'
				   --AND SEGMENT1 NOT IN ('M08','M10','M11')
				   AND ATTRIBUTE7 = 'Y'
				   AND (@Param1 IS NULL OR @Param1='' OR LV.ATTRIBUTE1 = @Param1)
			END
		/*===============================================
		용		 도:  SYS_LOOKUP 조회
		사 용 화 면:  SCP0049_CAPANewVersionConfirmPopup
		변       수:
		최 초 작 성:  2020. 07. 23
		개  발  자 :  khj79
		수  정  자 :  khj79
		수 정 사 항:  CODE 값 SEGMENT1 을 ATTRIBUTE1 으로 변경
		===============================================*/
		ELSE IF @Code = 'SysLookup'
			BEGIN
				SELECT ATTRIBUTE1			AS CODE
					 , CASE WHEN LOOKUP_TYPE_CODE = 'SHOP_GROUP_ID' THEN SEGMENT2 + '(' + SEGMENT1 + ')'
					   ELSE  SEGMENT2
					   END				AS NAME
				  FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
				 WHERE 1=1
				   AND LOOKUP_TYPE_CODE = @Param1
				   AND ACTIVE_FLAG = 'Y'
				   AND (@Param2 IS NULL OR @Param2='' OR LV.ATTRIBUTE1 = @Param2)
			END
		/*===============================================
		용		 도:  OPERATION 조회
		사 용 화 면:  SCP0049_MDMAuthManagement
		변       수:
		최 초 작 성:  2020. 08. 11
		개  발  자 :  khj79
		수  정  자 :
		수 정 사 항:
		===============================================*/
		ELSE IF @Code = 'OperationByLine'
			BEGIN
				 SELECT DISTINCT
						A.OPERATION_ID    AS CODE
						, (A.OPERATION_ID + ' ' + B.OPERATION_NAME)  AS NAME, A.OPERATION_ID
					 FROM [dbo].SCM_line_HIERARCHY_V_SN A  WITH(NOLOCK)
					 JOIN (SELECT DISTINCT OPERATION_ID , OPERATION_NAME
					        FROM [dbo].SCM_MST_OPERATION_SN B  WITH(NOLOCK)
						  ) B
					     ON  A.OPERATION_ID = B.OPERATION_ID
					 WHERE 1=1
					 AND ( (@Param1 IS NULL or @Param1='') OR A.DIVISION_ID			IN ( SELECT token FROM dbo.String_Split(@Param1,',')))
					 AND ( (@Param2 IS NULL or @Param2='') OR A.PLANT_ID			IN ( SELECT token FROM dbo.String_Split(@Param2,',')))
					 AND ( (@Param3 IS NULL or @Param3='') OR A.FACTORY_ID			IN ( SELECT token FROM dbo.String_Split(@Param3,',')))
					 AND ( (@Param4 IS NULL or @Param4='') OR A.LINE_ID				IN ( SELECT token FROM dbo.String_Split(@Param4,',')))
					 AND ( (@Param5 IS NULL or @Param5='') OR A.OPERATION_GROUP_ID	IN ( SELECT token FROM dbo.String_Split(@Param5,',')))
			ORDER BY A.OPERATION_ID
			END
	/*===============================================

		용		 도:  FCST TYPE LOOKUP COMBO BOX
		사 용 화 면:  DM0001_DM_PLN_MKT_FCST	-	FCST_TYPE컬럼
					  DM0004_DM_PLN_CUST_FCST	-	FCST_TYPE컬럼
		변       수:  -
		최 초 작 성:  2018. 02	.14
		개  발  자 :  황 승 재
		최 종 작 성:  -
		수  정  자 :  -
		수 정 사 항:
		===============================================*/
	IF @Code = 'FCST_TYPE_NOT_FREE'
	BEGIN
		SELECT SEGMENT1 AS CODE,
		SEGMENT2 AS NAME,
		DISPLAY_SEQ
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE VALID_YN = 'Y'
		AND LOOKUP_TYPE = 'SALES_TYPE_CODE'
		AND SEGMENT4 <> 'FREE'
		ORDER BY DISPLAY_SEQ
	END

	/*===============================================
	용		 도:  DIVISION, 팀  변경시 SOLDTO_CUSTOMER 조회
	사 용 화 면:  SSP0026
	변       수:  @PARAM1 = DIVISION, @PARAM2 = DEPT_ID, @PARAM3 = GROUP_ID, @PARAM4 = USER_ID
	최 초 작 성:  KIMYONGHO
	개  발  자 :  KIMYONGHO
	최 종 작 성:  2020-08-10
	수  정  자 :  KIMYONGHO
	수 정 사 항:
	===============================================*/
	IF @Code = 'SoldToCustomerByDivisionDept'

		BEGIN

		SELECT DISTINCT
			  SOLDTO_CUSTOMER AS CODE
			, SOLDTO_CUSTOMER AS NAME
		FROM   SCM_MST_SITE A WITH(NOLOCK)
		WHERE  1 = 1
		AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1
                    ELSE A.DIVISION_ID
	          END  IN (  SELECT token FROM dbo.String_Split(@Param1,','))
		--AND    CASE WHEN @Param2 = 'ALL'  OR  @Param2 ='' THEN @Param2
		--                  ELSE A.DEPT_ID
		--         END  IN (  SELECT token FROM dbo.String_Split(@Param2,','))
		AND    A.DIVISION_ID IN (SELECT CODE
		       FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    			WHERE  GroupID LIKE '%'+ @Param3 + '%'
							    	AND    UserID  LIKE '%'+ @Param4 + '%'
								AND    AuthType = 'D')
		AND    SOLDTO_CUSTOMER IS NOT NULL

	END

	IF @Code = 'FromSiteByDivisionOspPack'

		BEGIN
		/*===============================================
		용		 도:  DIVISION 변경시 SITE 조회
		사 용 화 면:  SSP0026
		변       수:  @PARAM1 = DIVISION, @PARAM2 = GROUPID, @PARAM3 = USERID
		최 초 작 성: KIMYONGHO
		개 발  자 : KIMYONGHO
		최 종 작 성:  2020. 08. 10
		수  정  자 :  KIMYONGHO
		수 정 사 항:
		===============================================*/
		--[NERP]COMPANY 예외적용 시작 --NERP (IT20250117A)
		INSERT INTO @exception_company (company_id) select SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock) 
			WHERE 1=1
			AND LOOKUP_TYPE = 'SSP_UI_EXCEPT_COMPANY' and VALID_YN='Y'
		--[NERP]COMPANY 예외적용 끝--NERP (IT20250117A)


		SELECT	SCM_SITE_ID        AS CODE
		,	   SITE_DESCRIPTION	   AS NAME
		,     COMPANY_ID --[NERP]COMPANY 예외적용--NERP (IT20250117A)
		FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
		WHERE SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		AND    A.OSP_YN  = 'Y'
		AND    A.OPERATION_GROUP = 'P'
		AND CASE WHEN @Param1 = 'ALL' OR @Param1 ='' THEN @Param1
				ELSE A.DIVISION_ID
		END  IN (  SELECT token FROM dbo.String_Split(@Param1,',')	 )
		AND    A.DIVISION_ID IN (SELECT CODE
						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
							WHERE  GroupID LIKE '%'+ @Param2 + '%'
							AND    UserID  LIKE '%'+ @Param3 + '%'
							AND    AuthType = 'D')
		AND not exists (select 1 from @exception_company K where a.COMPANY_ID = K.company_id)--[NERP]COMPANY 예외적용--NERP (IT20250117A)
	END


	IF @Code = 'FromSiteByDivisionNoOspPack'

		BEGIN

		SELECT	SCM_SITE_ID        AS CODE
		,	   SITE_DESCRIPTION	   AS NAME
		FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
		WHERE SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		AND    A.OSP_YN  = 'N'
		AND    A.OPERATION_GROUP = 'P'
		AND CASE WHEN @Param1 = 'ALL' OR @Param1 ='' THEN @Param1
				ELSE A.DIVISION_ID
		END  IN (  SELECT token FROM dbo.String_Split(@Param1,',')	 )
		AND    A.DIVISION_ID IN (SELECT CODE
						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
							WHERE  GroupID LIKE '%'+ @Param2 + '%'
							AND    UserID  LIKE '%'+ @Param3 + '%'
							AND    AuthType = 'D')

	END



	IF @Code = 'ShipToCodeByDivision'

		BEGIN
		/*===============================================
		용		 도:  ShipToCode 조회
		사 용 화 면:  SSP0026
		변       수:  @PARAM1 = DIVISION, @PARAM2 = Plant Site
		최 초 작 성: KIMYONGHO
		개 발  자 : KIMYONGHO
		최 종 작 성:  2020. 08. 20
		수  정  자 :  KIMYONGHO
		수 정 사 항:
		===============================================*/

		SELECT
		   C.SHIPTO_CODE AS CODE,
		   --C.SHIPTO_DESCRIPTION AS NAME
		   C.SHIPTO_CODE AS NAME
		FROM SCM_MST_CUSTOMER       C WITH(NOLOCK)
			,SCM_MST_SITE_CUSTOMER SC WITH(NOLOCK)
			,SCM_MST_SITE           S WITH(NOLOCK)
		WHERE 1=1
		AND S.DIVISION_ID    = SC.DIVISION_ID
		AND S.SCM_SITE_ID    = SC.SCM_SITE_ID
		--AND SC.REP_YN        = 'Y'
		/* 2021-11-22 김광희 책임님 요청 사항 VALID_YN 여부 상관없이 전체 Display
		AND SC.VALID_YN	 = 'Y'
		*/
		AND SC.DIVISION_ID   = C.DIVISION_ID
		AND SC.SOLDTO_CODE   = C.SOLDTO_CODE
		AND SC.SHIPTO_CODE   = C.SHIPTO_CODE
		AND S.DIVISION_ID    = @param1
		AND S.SCM_SITE_ID    = @param2
		;
	END
	else if @Code = 'DM_VMI_YN'

		BEGIN
		/*===============================================
		용		 도:  site 코드를 입력받아서 vmi 여부를 리턴한다. VMI 여부 + '^' + 재고일수
		사 용 화 면:  DMF0003
		변       수:  @PARAM1 = DIVISION, @PARAM2 = SCM_SITE_ID
		최 초 작 성: hwi1993
		개 발  자 : hwi1993
		최 종 작 성:  2020.11.11
		수  정  자 :
		수 정 사 항:
		===============================================*/

		SELECT  RTRIM(ISNULL(A.VMI_YN,'')) + '^' + LTRIM(ISNULL(ATTRIBUTE5,'')) AS VMI_VAL
		FROM SCM_MST_SITE A WITH(NOLOCK)
		WHERE A.DIVISION_ID    = @param1
			AND A.SCM_SITE_ID    = @param2
		;
	END
	else if @Code = 'JV_Plant'

		BEGIN
		/*===============================================
		용		 도:  JV Plant 코드를 조회한다
		사 용 화 면:  GroupUserInfo -> JVPlantDataPopup
		변       수:  @PARAM1 = Plant_id(segment2)
		최 초 작 성: lgda106
		개 발  자 : lgda106
		최 종 작 성:  2021.06.18
		수  정  자 :
		수 정 사 항:
		===============================================*/


		SELECT md.segment1 as DIVISION_ID, md.segment2 as PLANT_ID, md.DESCRIPTION
		FROM [dbo].[scm_adm_lookup_master_detail] md WITH(NOLOCK)
		WHERE md.lookup_type = 'JV_PLANT'
		  AND md.valid_yn    = 'Y'
		  AND (@Param1 IS NULL OR md.segment1 LIKE '%' + @Param1 + '%')
		  AND (@Param2 = md.segment1 OR md.segment2 LIKE '%' + @Param2 + '%')
		;
	END
	else if @Code = 'CELL_TYPE_81'

		BEGIN
		/*===============================================
		용		 도: 자동차 사업부 Cell type 코드를 조회한다
		사 용 화 면: Sales Site Project Model
		변       수: @PARAM1 = LOOKUP_TYPE
		최 초 작 성: winter1203
		개 발   자 : winter1203
		최 종 작 성: 2021.06.25
		수  정  자 :
		수 정 사 항: [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
		===============================================*/

		SELECT
			SEGMENT2 AS CODE,
			SEGMENT3 AS NAME
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
		WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO'
			AND SEGMENT1 = '81'
		;
	END
	else if @Code = 'CELL_TYPE_82'

		BEGIN
		/*===============================================
		용		 도: 자동차 사업부 Cell type 코드를 조회한다
		사 용 화 면: Sales Site Project Model
		변       수: @PARAM1 = LOOKUP_TYPE
		최 초 작 성: winter1203
		개 발   자 : winter1203
		최 종 작 성: 2021.06.25
		수  정  자 :
		수 정 사 항: [C20210624-000068] 자동차 중장기 계획 수립시 필요한 컬럼 추가
		===============================================*/

		SELECT
			SEGMENT2 AS CODE,
			SEGMENT3 AS NAME
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
		WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO'
			AND SEGMENT1 = '82'
		;
	END
	else if @Code = 'PRODUCTION_PROCESS'

		BEGIN
		/*===============================================
		용		 도: 소형 사업부 Production Process 코드를 조회한다
		사 용 화 면: Sales Site Project Model
		변       수: @PARAM1 = LOOKUP_TYPE
		최 초 작 성: rosia27
		개 발   자 : rosia27
		최 종 작 성: 2021.08.24
		수  정  자 :
		수 정 사 항: [C20210722-000230] GSCM Sales Site Project Model 마케팅 입력 컬럼 추가 요청의 건
		===============================================*/


		SELECT
			SEGMENT1 AS CODE
			, ATTRIBUTE1 AS NAME
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
		WHERE LOOKUP_TYPE = 'DM_PROD_PROCESS'
			AND VALID_YN = 'Y'
		;
	END
	/*===============================================
	용		 도: Combobox 날짜 (주차) 조회
	사 용 화 면:
	변       수:  -
	최 초 작 성:  2022. 05. 16
	개  발  자:  jahn1501
	최 종 작 성:
	수  정  자:  2022. 09. 28
	수 정 사 항:  no plan 적용
	===============================================*/
	ELSE IF @Code = 'DATE_WEEKLY'
	BEGIN

		SELECT A.plan_start_yyyymmdd AS code
 	  		 --, CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')'  AS name
 	  		 , CASE WHEN FP_TARGET_YN = 'Y' THEN CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')'
 	  		 		ELSE CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')' + ' (No Plan)' END name
  		  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK)
  		 INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.plan_start_yyyymmdd = B.basis_yyyymmdd
  		 LEFT JOIN
  		 (
  		 	SELECT DIVISION_ID
		 		, PLAN_START_YYYYMMDD
		 		, FP_TARGET_YN
		 		, MRP_TARGET_YN
		 		, DM_RTF_YN
	  		 FROM [dbo].[SCP_PLN_INTERFACE_YN] WITH(NOLOCK)
			WHERE 1=1
			  --AND PLAN_START_YYYYMMDD >= [dbo].[FN_GET_BUCKET_YYYYMMDD](0)
	   		  AND DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@Param1,','))
  		 ) C ON A.plan_start_yyyymmdd = C.PLAN_START_YYYYMMDD
		    AND A.DIVISION_ID         = C.DIVISION_ID 
		 WHERE 1=1
		   AND (( @Param1 IS NULL OR  @Param1='' ) OR A.division_id= @Param1 )
  		   AND (( @Param2 IS NULL OR  @Param2='' ) OR A.version_id = @Param2 )
		 GROUP BY A.plan_start_yyyymmdd, B.WEEK_NAME, C.FP_TARGET_YN
		 ORDER BY A.plan_start_yyyymmdd DESC
		;
	END

	ELSE IF @Code = 'DATE_WEEKLY2'
	BEGIN

		SELECT A.plan_start_yyyymmdd AS code
 	  		 --, CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')'  AS name
 	  		 , CASE WHEN FP_TARGET_YN = 'Y' THEN CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')'
 	  		 		ELSE CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')' + ' (No Plan)' END name
             , A.DIVISION_ID
  		  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK)
  		 INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.plan_start_yyyymmdd = B.basis_yyyymmdd
  		 LEFT JOIN
  		 (
  		 	SELECT DIVISION_ID
		 		, PLAN_START_YYYYMMDD
		 		, FP_TARGET_YN
		 		, MRP_TARGET_YN
		 		, DM_RTF_YN
	  		 FROM [dbo].[SCP_PLN_INTERFACE_YN] WITH(NOLOCK)
			WHERE 1=1
			  --AND PLAN_START_YYYYMMDD >= [dbo].[FN_GET_BUCKET_YYYYMMDD](0)
	   		  AND DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@Param1,','))
  		 ) C ON A.plan_start_yyyymmdd = C.PLAN_START_YYYYMMDD
		    AND A.DIVISION_ID         = C.DIVISION_ID 
		 WHERE 1=1
		   AND (( @Param1 IS NULL OR  @Param1='' ) OR A.division_id= @Param1 )
  		   AND (( @Param2 IS NULL OR  @Param2='' ) OR A.version_id = @Param2 )
		 GROUP BY A.plan_start_yyyymmdd, B.WEEK_NAME, C.FP_TARGET_YN  ,A.DIVISION_ID
		 ORDER BY A.plan_start_yyyymmdd DESC
		;
	END

	/*===============================================

	용		 도:  Business Plan Waterfall > Measure 조회
	사 용 화 면:  DMF0051
	변       수:  -
	최 초 작 성:  2022. 06. 09
	개  발  자 :  kdw2819
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'DMF0051_BP_Measure'
	BEGIN

		IF (@Param1 = '') BEGIN
			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME
			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)
			WHERE PROGRAM_ID = 'DMF0051' AND SHEET_NAME = 'Biz Plan Waterfall'
			ORDER BY SORT_ORDER_NO
		END ELSE BEGIN
			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME
			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)
			WHERE PROGRAM_ID = 'DMF0051' AND SHEET_NAME = 'Biz Plan Waterfall'
				--AND @Param1 IN (SELECT token FROM dbo.String_Split(DIVISION_ID ,',') )
				AND @Param1 IN (SELECT token FROM dbo.String_Split(DIVISION_ID ,',') )
			ORDER BY SORT_ORDER_NO
		END

	END

	ELSE IF @Code = 'DMF0051_1_BP_Measure'
	BEGIN

		IF (@Param1 = '')
		BEGIN
			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME
			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)
			WHERE PROGRAM_ID = 'DMF0051_1' AND SHEET_NAME = 'Biz Plan Waterfall'
			ORDER BY SORT_ORDER_NO
		END ELSE BEGIN
			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME
			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)
			WHERE PROGRAM_ID = 'DMF0051_1' AND SHEET_NAME = 'Biz Plan Waterfall'
				--AND @Param1 IN (SELECT token FROM dbo.String_Split(DIVISION_ID ,',') )
				AND @Param1 IN (SELECT token FROM dbo.String_Split(DIVISION_ID ,',') )
			ORDER BY SORT_ORDER_NO
		END

	END

	/*===============================================
	용		 도:  소형 CELL_PROD_SITE
	사 용 화 면:
	변       수:  -
	최 초 작 성:  2022. 06. 14
	개  발  자 :  ROSIA27
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	ELSE IF @CODE = 'DM_CELL_PROD_SITE'
	BEGIN
		SELECT L.SEGMENT1	AS CODE
			 , L.ATTRIBUTE1	AS NAME
		FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
		WHERE  1 = 1
		AND    L.LOOKUP_TYPE = 'DM_CELL_PROD_SITE'
		ORDER BY L.DISPLAY_SEQ
	END

	/*===============================================
	용		 도: Combobox Cell Group 조회
	사 용 화 면:
	변       수:  -
	최 초 작 성:  2022. 10. 20
	개  발  자:  jahn1501
	최 종 작 성:
	수  정  자:
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'CELL_GROUP'
	BEGIN

		SELECT DISTINCT ISNULL(G.CELL_GROUP, '') AS CODE
		     , ISNULL(G.CELL_GROUP, '') AS NAME
		  FROM SCP_XLS_PSI_GLOBAL_TG G WITH(NOLOCK),
			   SCP_MST_FINAL_ITEM F WITH(NOLOCK)
		 WHERE 0 = 0
		   AND G.OPERATION_GROUP ='A'
		   AND G.DIVISION_ID     = @Param1
		   AND G.DIVISION_ID     = F.DIVISION_ID
		   AND G.CELL_ITEM_ID    = F.ITEM_ID
		   AND ISNULL(G.CELL_GROUP, '') <> ''
		 ORDER BY ISNULL(G.CELL_GROUP, '') DESC
		;
	END

	/*===============================================
	용		 도: Number 조회
	사 용 화 면: SCP BOM(Cell~ Pack)
	변       수: @Param1 => MAX 숫자
	최 초 작 성:  2022. 10. 25
	개  발  자:  jahn1501
	최 종 작 성:
	수  정  자:
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'SEQ_NUMBER'
	BEGIN

		WITH SEQ AS
		     (
		        SELECT 1 AS NUM
		         UNION ALL
		        SELECT NUM + 1
		          FROM SEQ
		         WHERE NUM < @Param1 )
	  SELECT NUM AS CODE
	       , NUM AS NAME
	    FROM SEQ
		;
	END

	/*===============================================
	용		 도:  전극 division 조회
	사 용 화 면:  Global PSI Elec
	변       수:
	최 초 작 성:  2022. 11. 22
	개  발  자 : jahn1501
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'DIVISION_EE'
		BEGIN
			SELECT DIVISION_ID AS CODE
			     , DIVISION_ID AS NAME
			  FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)
			 WHERE DIVISION_ID IN ('EE', 'EE_UC')
			 GROUP BY DIVISION_ID
			 ORDER BY DIVISION_ID
		END

	/*===============================================
	용		 도:  Company 조회
	사 용 화 면:  Global PSI Elec
	변       수:
	최 초 작 성:  2022. 12. 12
	개  발  자 :  jahn1501
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'COMPANY_EE'
		BEGIN
			SELECT A.COMPANY_NAME CODE
				 , A.COMPANY_ID NAME
			FROM SCM_MST_COMPANY_SN A WITH(NOLOCK)
	    END

	/*===============================================
	용		 도:  'Y' 조회
	사 용 화 면:  Group Code Management
	변       수:
	최 초 작 성:  2023. 01. 25
	개  발  자 :  jahn1501
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'ALL_Y_TYPE'
		BEGIN
			SELECT SEGMENT2 AS CODE
			     , SEGMENT1 AS NAME
			  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			 WHERE 1=1
			   AND LOOKUP_TYPE = 'ALL_Y_TYPE'
			   AND SEGMENT1 <> 'ALL'
	    END

	/*===============================================
	용		 도:  'Y','N','Both' 조회
	사 용 화 면:  Group Code Management
	변       수:
	최 초 작 성:  2023. 02. 20
	개  발  자 :  jahn1501
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'FINISHED_YN'
		BEGIN
			SELECT 1 AS CODE
			     , 'Y' AS NAME
			UNION
			SELECT 2 AS CODE
				, 'N' AS NAME
			UNION
			SELECT '3' AS CODE
				, 'Both' AS NAME
	    END

 /*===============================================
 용   도	:  'V' 조회
 사 용 화 면:  Group Code Management
 변		  수:
 최 초 작 성:  2023. 01. 25
 개  발  자 :  jahn1501
 최 종 작 성:
 수  정  자 :
 수 정 사 항:
 ===============================================*/
 ELSE IF @Code = 'ALL_V_TYPE'
  BEGIN
   SELECT SEGMENT2 AS CODE
		   , SEGMENT1 AS NAME
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
    WHERE 1=1
		 AND LOOKUP_TYPE = 'ALL_V_TYPE'
		 AND SEGMENT1 <> 'ALL'
		END

/*===============================================
 용   도	:  ESS 구분 조회
 사 용 화 면:  Group Code Management
 변		  수:
 최 초 작 성:  2023. 04. 13
 개  발  자 :  chaan
 최 종 작 성:
 수  정  자 :
 수 정 사 항:
 ===============================================*/
ELSE IF @Code = 'ESS_CATEGORY'
BEGIN
    SELECT    SEGMENT1 AS CODE
            , SEGMENT1 AS NAME
    FROM    SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
    WHERE   1=1
        AND LOOKUP_TYPE = 'ESS_CATEGORY'
END

/*===============================================
 용   도	:  Global PSI Elec -> 주차(Plandate) 조회
 사 용 화 면:  Group Code Management
 변		  수:
 최 초 작 성:  2023. 05. 02
 개  발  자 :  chaan
 최 종 작 성:
 수  정  자 :
 수 정 사 항:
 ===============================================*/
ELSE IF @Code = 'GLOBAL_PSI_ELEC_DATE'
BEGIN
    SELECT    A.PLAN_START_YYYYMMDD                                                                     AS CODE
            , CONVERT(VARCHAR, CONVERT(DATE, A.PLAN_START_YYYYMMDD), 121) + ' (' + B.WEEK_NAME + ')'    AS NAME
    FROM    (
                SELECT DISTINCT
                        PLAN_START_YYYYMMDD
                FROM    SCP_RPT_ELEC_PSI A
                WHERE   1=1
                    AND ((@Param1 IS NULL OR  @Param1 = '') OR A.division_id= @Param1)
            ) A
            INNER JOIN
            (
                SELECT DISTINCT
                          BASIS_YYYYMMDD
                        , WEEK_NAME
                FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK)
            ) B ON A.PLAN_START_YYYYMMDD = B.BASIS_YYYYMMDD
    GROUP BY A.PLAN_START_YYYYMMDD, B.WEEK_NAME
    ORDER BY A.PLAN_START_YYYYMMDD DESC
END

	/*===============================================
	용		 도:  PROJECT_MODEL_MAPPING(소형프로젝트 추가) 20230821
	사 용 화 면:  DMF0005
	변       수:  -
	최 초 작 성:  2023. 08. 21
	개  발  자 :  JSSBAE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'PROJECT_MODEL_MAPPING'
	BEGIN
		SELECT  SEGMENT1 AS CODE
			,	SEGMENT1 AS NAME
		FROM    SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE   1=1
			AND LOOKUP_TYPE = 'PROJECT_MODEL_MAPPING'
		ORDER BY DISPLAY_SEQ
	END

	/*===============================================
	용		 도:  Fcst&PRICE MGMT [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
	사 용 화 면:  DMF0082
	변       수:  -
	최 초 작 성:  2025. 04. 10
	개  발  자 :  dsiol
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
		2025/07/04	  kjiyoon				[PJ2025-50188] 고도화 - Common 도 Lookup 으로 가져오도록 수정
	===============================================*/
	ELSE IF @Code = 'CELL_PROD_SITE_ID'
	BEGIN
	  	  --EXEC UP_FX_GETCOMMONDATALIST 'CELL_PROD_SITE_ID','40','MCMM9319V9A1-D15','','',''
		  --EXEC UP_FX_GETCOMMONDATALIST 'CELL_PROD_SITE_ID','','','','',''
		  -- @p_division_id -> @PARAM1  
		  -- @p_item_id     -> @PARAM2
		
		IF @PARAM1 IS NULL OR LEN(@PARAM1) = 0 OR @PARAM1 = '' 	-- 조회 했을 때 실행 (아래 IF문의 결과가 조회용 콤보박스가 된다.)
		BEGIN
				--SELECT '-' CODE,'Common' NAME
				--[PJ2025-50188] 고도화 - Common 도 Lookup 으로 가져오도록 수정
				--기본적으로 사용되는 CODE '-' 를 강제로 추가 - START 
				SELECT SEGMENT1 AS CODE, ATTRIBUTE1 AS [NAME]
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
				WHERE LOOKUP_TYPE = 'SP_CELL_PROD_SITE' AND SEGMENT1 = '-' AND VALID_YN  = 'Y'
				--기본적으로 사용되는 CODE '-' 를 강제로 추가 - END
				UNION ALL
				--현재 사용 중인 모든 셀생산지 리스트 가져오기 - START
				SELECT DISTINCT
					   S.SCM_SITE_ID  AS CODE
					 , M.ATTRIBUTE1    AS NAME
				FROM   SCM_MST_SITE S WITH(NOLOCK)
				INNER JOIN (
							SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP 
							--[C20200608-000328] SALESCOMPANY 콤보는 ITEM MASTER의 COMPANY ID, OPERATION GROUP 기준으로 조회
							FROM   SCM_MST_ITEM_SN I WITH(NOLOCK)
							WHERE  1=1
							AND    I.ACTIVE_FLAG = 'Y'
							AND    I.ITEM_TYPE IS NOT NULL 
							--AND    I.DIVISION_ID = @PARAM1
							--AND    I.ITEM_ID = CASE WHEN TRIM(@PARAM2) IN( '','ALL') THEN I.ITEM_ID ELSE @PARAM2 END
							AND    I.FORECAST_INFO_BIZ_TYPE = 'CELL'
							) SS
				ON  S.DIVISION_ID = SS.DIVISION_ID
				AND S.OPERATION_GROUP = SS.SCP_OPERATION_GROUP
				AND S.COMPANY_ID = SS.COMPANY_ID 
				INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)
				ON  M.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'
				AND S.SCM_SITE_ID = M.SEGMENT1
				AND M.VALID_YN  = 'Y'
				WHERE  1 = 1
				AND    S.SITE_TYPE = 'PLANT'
				AND    S.OPERATION_GROUP = 'A'
				AND    S.OSP_YN = 'N' 
				--현재 사용 중인 모든 셀생산지 리스트 가져오기 - END
		END
		ELSE	--그 외 이벤트에서 실행 ( ex)대표적으로 ITEM_ID (@PARAM2) 를 변경 했을시 실행 된다.)
		BEGIN
			DECLARE @BIZ_TYPE NVARCHAR(100) = '';

			IF (SELECT COUNT(1) 
				FROM [SCM_ITEM_M_SN] T1 WITH (NOLOCK) 
				WHERE DIVISION_ID = @PARAM1 
				AND ACTIVE_FLAG = 'Y'	
				AND ITEM_ID = @PARAM2 
				AND FORECAST_INFO_BIZ_TYPE = 'CELL') > 0 -- CELL인 경우 @BIZ_TYPE을 CELL로 넣고 아닐 경우 빈칸이다.
			BEGIN
				SET @BIZ_TYPE = 'CELL'	
			END

			IF @BIZ_TYPE <> 'CELL'
			BEGIN
				--SELECT '-' CODE,'Common' NAME
				--[PJ2025-50188] 고도화 - Common 도 Lookup 으로 가져오도록 수정
				--기본적으로 사용되는 CODE '-' 를 강제로 추가 - START 
				SELECT SEGMENT1 AS CODE, ATTRIBUTE1 AS [NAME]
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
				WHERE LOOKUP_TYPE = 'SP_CELL_PROD_SITE' AND SEGMENT1 = '-' AND VALID_YN  = 'Y'	--만약에 @BIZ_TYPE이 CELL이 아니라면 현재 기준 Comon으로 매핑 시킨다.
				--기본적으로 사용되는 CODE '-' 를 강제로 추가 - END
			END
			ELSE
			BEGIN
				--SELECT '-' CODE,'Common' NAME WHERE @BIZ_TYPE <> 'CELL'
				--[PJ2025-50188] 고도화 - Common 도 Lookup 으로 가져오도록 수정
				--기본적으로 사용되는 CODE '-' 를 강제로 추가 - START 
				SELECT SEGMENT1 AS CODE, ATTRIBUTE1 AS [NAME]
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
				WHERE LOOKUP_TYPE = 'SP_CELL_PROD_SITE' AND SEGMENT1 = '-' AND VALID_YN  = 'Y'	--만약에 @BIZ_TYPE이 CELL이 맞다면, Common은 사용하지 않는다.
				AND @BIZ_TYPE <> 'CELL'															--아예 빼도 상관은 없겠으나, 추가안한다는걸 확실히 알려주기 위해 넣었음.
				--기본적으로 사용되는 CODE '-' 를 강제로 추가 - END								--혹시나 Common을 다시 넣어야 한다면 AND @BIZ_TYPE <> 'CELL' 주석하면 됨.
				UNION ALL
				SELECT DISTINCT																	
					   S.SCM_SITE_ID  AS CODE
					 , M.ATTRIBUTE1    AS NAME
				FROM   SCM_MST_SITE S WITH(NOLOCK)
				INNER JOIN (
							SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP 
							--[C20200608-000328] SALESCOMPANY 콤보는 ITEM MASTER의 COMPANY ID, OPERATION GROUP 기준으로 조회
							FROM   SCM_MST_ITEM_SN I WITH(NOLOCK)
							WHERE  1=1
							AND    I.ACTIVE_FLAG = 'Y'
							AND    I.ITEM_TYPE IS NOT NULL 
							AND    I.DIVISION_ID = @PARAM1
							AND    I.ITEM_ID = CASE WHEN TRIM(@PARAM2) IN( '','ALL') THEN I.ITEM_ID ELSE @PARAM2 END --ITEM_ID(@PARAM2)에 맞는 셀생산지만 가져온다.
							AND    I.FORECAST_INFO_BIZ_TYPE = 'CELL'
							) SS
				ON  S.DIVISION_ID = SS.DIVISION_ID
				AND S.OPERATION_GROUP = SS.SCP_OPERATION_GROUP
				AND S.COMPANY_ID = SS.COMPANY_ID 
				INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)
				ON  M.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'
				AND S.SCM_SITE_ID = M.SEGMENT1
				AND M.VALID_YN  = 'Y'
				WHERE  1 = 1
				AND    S.SITE_TYPE = 'PLANT'
				AND    S.OPERATION_GROUP = 'A'
				AND    S.OSP_YN = 'N' 
			END
		END
	END

	/*==============================================================================================
	용		 도: [E20250821-001228]_Sales Site Project Model화면 Sales Plant Combo Box List 변경
	사 용 화 면: DMF0005
	변       수: @PARAM1 = DIVISION_ID, @PARAM2 = COMPANY_ID
	최 초 작 성: 2025.08.21
	개  발  자 : JSSBAE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	==============================================================================================*/
	ELSE IF @Code = 'PlantByDivisionCompany'
	BEGIN
		SELECT A.PLANT_ID      AS CODE
			 , A.PLANT_ID      AS NAME
		  FROM SCM_MST_PLANT_SN A WITH(NOLOCK)
		 WHERE (( @Param1 IS NULL OR  @Param1='' ) OR A.DIVISION_ID = @Param1 ) 
  		   AND (( @Param2 IS NULL OR  @Param2='' ) OR A.COMPANY_ID = @Param2 )
	END
	
	/*==============================================================================================
	용		 도: [E20250821-001228]_Sales Site Project Model화면 Sales Company Combo Box List 변경 
	사 용 화 면: DMF0005
	변       수: @PARAM1 = DIVISION_ID, @PARAM2 = SCM_SITE_ID
	최 초 작 성: 2025.08.21
	개  발  자 : JSSBAE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	==============================================================================================*/
	ELSE IF @Code = 'CompanySalesSite'
	BEGIN	
		IF @PARAM2 IS NULL OR LEN(@PARAM2) = 0 OR @PARAM2 = '' 	-- 조회 했을 때 실행 (아래 IF문의 결과가 조회용 콤보박스가 된다.)
		BEGIN
			SELECT A.COMPANY_ID AS CODE
				 , A.COMPANY_ID AS NAME  
			  FROM SCM_MST_COMPANY_SN A WITH(NOLOCK)
		END
		ELSE	--@PARAM2[SCM_SITE_ID]가 존재하는 경우 해당 부분 쿼리 실행
		BEGIN
			SELECT A.COMPANY_ID AS CODE
				 , A.COMPANY_ID AS NAME  
			  FROM SCM_MST_SITE A WITH(NOLOCK)
			 WHERE (( @Param1 IS NULL OR  @Param1='' ) OR A.DIVISION_ID = @Param1 ) 
			   AND (( @Param2 IS NULL OR  @Param2='' ) OR A.SCM_SITE_ID = @Param2 )
		END
	END	
	/*===============================================================================================================
	용		 도: [E20250919-001699]_INCOTERMS 데이터 처리 VALID 처리 
	사 용 화 면: DMF0005, DMF0004
	변       수: 
	최 초 작 성: 2025.09.30
	개  발  자 : JSSBAE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	==================================================================================================================*/
	ELSE IF @CODE = 'incotermsEdit'
	BEGIN		
		SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'INCOTERMS'
		AND   VALID_YN = 'Y'
		AND   ATTRIBUTE2 = 'Y'
		ORDER BY DISPLAY_SEQ
	END
	/*===============================================================================================================
	용		 도:[E20260211-001189]_MKT FCST UI AS From Site 입력 방식 개선
	사 용 화 면: DMF0003
	변       수: @PARAM1 = DIVISION_ID
	최 초 작 성: 2026.02.20
	개  발  자 : JSSBAE
	최 종 작 성:
	수  정  자 :
	수 정 사 항:
	==================================================================================================================*/
	ELSE IF @CODE = 'AS_FROM_SITE'
	BEGIN		
		IF @PARAM1 IS NULL OR LEN(@PARAM1) = 0 OR @PARAM1 = '' 	-- 조회 했을 때 실행 (아래 IF문의 결과가 조회용 콤보박스가 된다.)
		BEGIN
			SELECT SEGMENT2 AS CODE, SEGMENT1 AS NAME 
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
			WHERE LOOKUP_TYPE = 'AS_SITE_PLANT'
			AND VALID_YN = 'Y'
			ORDER BY DISPLAY_SEQ
		END
		ELSE
		BEGIN
			SELECT SEGMENT2 AS CODE, SEGMENT1 AS NAME 
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
			WHERE LOOKUP_TYPE = 'AS_SITE_PLANT'
			AND VALID_YN = 'Y'
			AND SEGMENT3 = @PARAM1
			ORDER BY DISPLAY_SEQ
		END
	END
END
