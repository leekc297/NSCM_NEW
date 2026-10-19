


/* ==========================================================================================================================================================
프로그램ID : UP_FX_GetCommonDataList_SCP
업  무  명 : 공통 코드성 조회
프로그램명 : 공통 코드성 조회
최초작성일 : 2018.07.05
최종작성일 : 2018.07.05
개  발  자 : ygkim
입  력  값 :
출  력  값 :
==========================================================================================================================================================
 Date         In Charge      Description
==========================================================================================================================================================
 2018/07/05   ygkim                 Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 2022.08.17   KSG  ==> 주석 정리 
 2022/02/10   chaan                 OperationByLineSCP SCP에 해당하는 Operaion 목록만 조회
 2022/03/03   SMS                   EndCustomerByItemForSSP 수정, param5 추가,  소형외주 packer Item 이중화 이슈
 2022/03/03   chaan         V1.3    선택한 Category 에 해당하는 Key 목록만 조회  MDMKeyIdByCategory 추가
 2022/03/15   chaan         V1.5    Division & Operation & Model 에 해당하는 Plant목록 조회  PlantByDivisionOperationItem 추가
 2022/03/21   chaan         V1.6    Division & Operation & Model 에 해당하는 Plant목록 조회 수정
 2022/04/18   SMS                   MyDivisionOut40, SSPToSiteByDivision, ShipmentPlanToSite 가상디비젼 적용
 2022/04/20   chaan         V1.8    RTFYear RTF, RTFWeek(연도/주), RTFGubun(ESS->구분) 목록 조회 추가
                                    RTF Division->Gubun 목록 조회 추가
 2022/05/03   chaan         V1.98   DIvision 필터링 추가(lookup->SEGMENT4)
                                    Lookup(EE_PROBLEM_REPORT_DEMAND)
                                        PlantSitePlanProblem
                                        SalesSitePlanProblem
                                        PlantSitePlanProblemSSP
                                        SalesSitePlanProblemSSP
                                    Lookup(EE_PRODUCTION_PLAN)
                                        PlantSiteProdPlan
                                        LineProdPlanLine
                                        PlantSiteProdPlanSSP
                                        LineProdPlanLineSSP
 2022/05/17   jahn1501              project name 조회 추가
 2022/05/24   jahn1501              WaterfallVer2, WaterfallVer_FG2 (주차), PlanDate_AlloTarget2 조회 추가
 2022/06/08   chaan         V1.11   RTFWeek 당해년도 조회시 현재 기준 전주까지만 조회되도록 수정
 2022/06/10   jahn1501              PlanDate_REPORT: YYYY-MM-DD (주차) 형식 변경
 							        FnVersionByDivisionId: name + (주차) 형식 변경
 2022/06/17   chaan         V1.13   RTFYear, RTFWeek 최근 일자가 앞에 오도록
 2022/06/29   vadabi3               PlanDate_FN 주차 적용
 2022/07/01   lwy                   PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - Group Code Management 화면 공정 추가 (P5000, R5500)
 2022/07/07   chaan         V1.2.1  전극 사업부 ShopGorup 조회를 위해 ShopGroupIdEE, ShopGroupIdNotEE 추가
 2022/07/07   chaan         V1.2.2  BucketISO  ISO_WEEK 추가
 2022/08/31   lwy                   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Isuzu 추가 (LineByOperationAddOSP - 수정)
 2022/09/28   jahn1501              PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - WaterfallVer2, WaterfallVer_FG2 => no plan 적용
 2022/10/27   chaan         V1.2.3  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - PlantSiteProdPlan, LineProdPlanLine 전극 사업부 적용에 따른 조회 오류 수정
 2022/11/24   vadabi3               PlantSitePackerHoldStock
 2022/12/09   chaan         V1.2.4  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - SCMTeamByDivision 추가
 2022-12-22   vadabi3               PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - SCP구간 내 Plan 에서 조회 > SCPPlanPeriod
 2023/01/04   chaan         V1.2.5  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - RTFWeek 전체 연도 조회 가능하도록 수정 (RTFYear 목록 조회방식 변경)
 2023/01/04   chaan         V1.2.6  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - CellGroup
 2023/01/19   chaan		    V1.2.7  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - RTFYear, RTFWeek - 정기 CUTOFF 구분 추가
 2023/02/03   chaan		    V1.2.8  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - @Param3 오류 수정
 2023/03/23   chaan		    V1.2.9  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - @Param3 오류 수정 - OperationForPlanDivisionId 'F' 추가
                                                                                                     - DivisionEE, DivisionExceptEE 추가
 2023/06/13   vadabi3		V1.2.10 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - PLANT_DOMESTIC) 활성화 국내 제약 체크
 2023/06/30   vadabi3		V1.2.11 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ITEM_NO_ACTIVE) Item No Active 체크
 2023/07/05   chaan		    V1.2.12 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - PlantByDivisionOperationItem 속도개선
 2023/10/30   chaan		    V1.2.13 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MRP 검색조건용 추가
 2023/11/06   chaan		    V1.2.14 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - PlantByDivisionOperationItem 속도개선
 2023/11/09   chaan		    V1.2.15 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MRP 검색조건용 추가(Nickname, ItemId)
 2023/11/16   chaan		    V1.2.16 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MRP 검색조건용 Material 수정
 2023/11/20   chaan		    V1.2.17 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MRP 검색조건용 Supplier 수정
 2023/11/20   chaan		    V1.2.18 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MRP 검색조건 속도개선 (WHERE 조건을 UI Filter로 대체)
                                                                                                            ~ SCP_PLAN_START_DATE
                                                                                                            ~ MRP_PLAN_START_DATE
                                                                                                            ~ MRP_ITEM_CATEGORY
                                                                                                            ~ MRP_MATERIAL
                                                                                                            ~ MRP_SUPPLIER
                                                                                                            ~ MRP_OPERATION
                                                                                                            ~ MRP_PLANT
                                                                                                            ~ MRP_NICKNAME
                                                                                                            ~ MRP_ITEM_ID
                                                                                                     - MRP_OPERATION : Operation => Operation Group 으로 변경
 2023/12/19   chaan		    V1.2.19 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MRP_SUPPLIER 키에서 Company 제외
                                                                                                     - MRP_NICKNAME 키에서 Operation Group 제외
                                                                                                     - MRP_ITEM_ID  키에서 Operation Group 제외
 2024/01/08   chaan         V1.2.20 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선
 2024/01/11   chaan         V1.2.21 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선 - Plant_REPORT1 추가 및 UP_FX_GetCommonDataList_SCP_ALL 로 분리
 2024/01/15   chaan         V1.2.22 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ITEM_NO_ACTIVE - FN_GET_SCP_ITEM_ACTIVE 오류로 FN_GET_SCP_ITEM_INACTIVE 로 대체
 2024/02/07   chaan         V1.2.23 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - YEAR_FROM_THIS_YEAR
 2024/05/24   chaan         V1.2.24 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - SCP_PLAN_START_DATE 속도 개선 및 지연 오류 수정
 2024/05/30   chaan         V1.2.25 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MRP_SUPPLIER 조회 속도 개선
 2024.12.15   vadabi3       NERP - 특정 Company, Plant , Storage 별도 처리 개선
 2025/09/23   chkim.68              [NERP]COMPANY 예외적용 (IT20250117A)
  ========================================================================================================================================================== */

CREATE PROCEDURE [dbo].[UP_FX_GetCommonDataList_SCP]
--CREATE PROCEDURE [dbo].[UP_FX_GetCommonDataList_SCP]
   @Code NVARCHAR(100)
 , @Param1 NVARCHAR(100)
 , @Param2 NVARCHAR(100)
 , @Param3 NVARCHAR(MAX)  --split 사용 변수
 , @Param4 NVARCHAR(MAX)  --split 사용 변수
 , @Param5 NVARCHAR(MAX)  --split 사용 변수
 , @Param6 NVARCHAR(MAX)=NULL  --split 사용 변수
 , @TimeZone NVARCHAR(MAX) = 'AS054'
--WITH RECOMPILE
AS

BEGIN
 SET NOCOUNT ON;
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

  -- NERP 매핑코드
  DECLARE @v_B100 NVARCHAR(8);
  DECLARE @v_C100 NVARCHAR(8);
  DECLARE @v_G182 NVARCHAR(8);

  SELECT @v_B100 = dbo.FN_GET_LOOKUP_VALUE('UP_FX_GetCommonDataList_SCP','COMPANY_SALES')	-- B100 -> HQ00
  SELECT @v_C100 = dbo.FN_GET_LOOKUP_VALUE('UP_FX_GetCommonDataList_SCP','ESOC')			-- C100 -> HQ00
  SELECT @v_G182 = dbo.FN_GET_LOOKUP_VALUE('UP_FX_GetCommonDataList_SCP','PLANT')			-- G182 -> G182

  DECLARE @exception_company TABLE ( company_id nvarchar(100) );--[NERP]COMPANY 예외적용--NERP (IT20250117A)

 /*===============================================
 용   도:  DIVISION  조회
 사 용 화 면:  Plan 결과 조회화면  - 조회조건
 변       수:  Param1 = GroupID, Param2 = UserID
 최 초 작 성:  2018. 07. 05
 개  발  자 :  정병훈
 최 종 작 성:  2018. 07. 05
 수  정  자 :  정병훈
 수 정 사 항:
 ===============================================*/

 IF (@Code = 'MyDivisionInEE' )
	 BEGIN
		  Declare @AuthTypePara varchar(100) = 'D'
		  if(@Param1 = 'JV Planner') SET @AuthTypePara = 'J';

		  SELECT DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME
			FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)
		   WHERE DIVISION_ID IN (SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = @AuthTypePara)
		   GROUP BY DIVISION_ID
		   ORDER BY DIVISION_ID
	 END

 /*===============================================
 용   도:  PSI From Site 조회
 사 용 화 면:  Plan 결과 조회화면  - 조회조건
 변       수:  Param1 = DIVISION_ID , Param2 = OPERATION_GROUP
 최 초 작 성:  2018. 07. 05
 개  발  자 :  김용현
 최 종 작 성:  2018. 07. 05
 수  정  자 :  -
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'FromSite_PSI' )
	 BEGIN
			SELECT
				A.FROM_SITE AS CODE ,
				CASE WHEN B.SITE_DESCRIPTION IS NULL  THEN A.FROM_SITE
				WHEN B.SITE_DESCRIPTION IS NOT NULL THEN B.SITE_DESCRIPTION
				END AS NAME
			FROM (
				SELECT distinct SEGMENT3 FROM_SITE
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
				WHERE LOOKUP_TYPE = 'EE_PSI_PRODUCTION'
					AND SEGMENT1 = 'SCP'
					AND SEGMENT2 = @PARAM2
					AND VALID_YN = 'Y'
			)  A
			LEFT OUTER JOIN SCM_MST_SITE B  WITH(NOLOCK) ON A.FROM_SITE = B.SCM_SITE_ID
			ORDER BY CODE
	 END

 /*===============================================
 용   도:  Plan Problem(SSP) Plant Site 조회
 사 용 화 면:  Plan Problem(SSP)  - 조회조건
 변       수:  Param1 = DIVISION_ID
 최 초 작 성:  2018. 07. 05
 개  발  자 :  ygkim
 최 종 작 성:  2018. 07. 05
 수  정  자 :  -
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'PlantSitePlanProblemSSP' )
	 BEGIN
		SELECT '-' AS CODE, '-' AS NAME
		UNION ALL
		SELECT A.PLANT_SITE_ID AS CODE
			  ,CASE WHEN B.SITE_DESCRIPTION IS NULL  THEN A.PLANT_SITE_ID
					WHEN B.SITE_DESCRIPTION IS NOT NULL THEN B.SITE_DESCRIPTION
			   END AS NAME
		FROM (
			SELECT DISTINCT SEGMENT2 PLANT_SITE_ID
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE LOOKUP_TYPE = 'EE_PROBLEM_REPORT_DEMAND'
			  AND SEGMENT1 = 'SSP'
			  AND VALID_YN = 'Y'
              AND SEGMENT4 = @Param1--chaan
		)  A
		LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.PLANT_SITE_ID = B.SCM_SITE_ID
		ORDER BY CODE;
 END

 /*===============================================
 용   도:  Plan Problem(SSP) Sales Site 조회
 사 용 화 면:  Plan Problem(SSP)  - 조회조건
 변       수:  Param1 = DIVISION_ID
 최 초 작 성:  2018. 07. 05
 개  발  자 :  ygkim
 최 종 작 성:  2018. 07. 05
 수  정  자 :  -
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'SalesSitePlanProblemSSP' )
	 BEGIN
		SELECT DISTINCT SEGMENT3 CODE
			 ,SEGMENT3 NAME
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'EE_PROBLEM_REPORT_DEMAND'
			AND SEGMENT1 = 'SSP'
			AND VALID_YN = 'Y'
            AND SEGMENT4 = @Param1--chaan
		ORDER BY CODE;
	 END

 /*===============================================
 용   도:  Production Plan(SSP) Plant Site 조회
 사 용 화 면:  Production Plan(SSP)  - 조회조건
 변       수:  Param1 = DIVISION_ID , Param2 = OPERATION_GROUP
 최 초 작 성:  2018. 07. 05
 개  발  자 :  ygkim
 최 종 작 성:  2018. 07. 05
 수  정  자 :  -
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'PlantSiteProdPlanSSP' )
	 BEGIN
		SELECT A.SCM_SITE_ID AS CODE
			  ,CASE WHEN B.SITE_DESCRIPTION IS NULL  THEN A.SCM_SITE_ID
					WHEN B.SITE_DESCRIPTION IS NOT NULL THEN B.SITE_DESCRIPTION
			   END AS NAME
		FROM (
			SELECT DISTINCT SEGMENT3 SCM_SITE_ID
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
				AND SEGMENT1 = 'SSP'
				AND SEGMENT2 = @PARAM2
				AND VALID_YN = 'Y'
		        AND ATTRIBUTE2 = @Param1--chaan
            )  A
		LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.SCM_SITE_ID = B.SCM_SITE_ID
		ORDER BY CODE
	 END

 /*===============================================
 용   도:  PSI(SSP) Plant Site 조회
 사 용 화 면:  PSI(SSP)  - 조회조건
 변       수:  Param1 = DIVISION_ID , Param2 = OPERATION_GROUP
 최 초 작 성:  2018. 07. 06
 개  발  자 :  ygkim
 최 종 작 성:  2018. 07. 06
 수  정  자 :  -
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'PlanSitePSISSP' )
	 BEGIN
		SELECT
			A.FROM_SITE AS CODE ,
			CASE WHEN B.SITE_DESCRIPTION IS NULL  THEN A.FROM_SITE
			WHEN B.SITE_DESCRIPTION IS NOT NULL THEN B.SITE_DESCRIPTION
			END AS NAME
		FROM (
			SELECT distinct SEGMENT3 FROM_SITE
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE LOOKUP_TYPE = 'EE_PSI_PRODUCTION'
				AND SEGMENT1 = 'SSP'
				AND SEGMENT2 = @PARAM2
				AND VALID_YN = 'Y'
		)  A
		LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.FROM_SITE = B.SCM_SITE_ID
		ORDER BY CODE
	 END

 /*===============================================
 용   도:  Plan Problem Plant Site 조회
 사 용 화 면:  Plan Problem  - 조회조건
 변       수:  Param1 = DIVISION_ID
 최 초 작 성:  2018. 07. 05
 개  발  자 :  ygkim
 최 종 작 성:  2018. 07. 05
 수  정  자 :  -
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'PlantSitePlanProblem' )
	 BEGIN
		SELECT '-' AS CODE, '-' AS NAME
		UNION ALL
		SELECT A.PLANT_SITE_ID AS CODE
				,CASE WHEN B.SITE_DESCRIPTION IS NULL  THEN A.PLANT_SITE_ID
					WHEN B.SITE_DESCRIPTION IS NOT NULL THEN B.SITE_DESCRIPTION
				END AS NAME
		FROM (
			SELECT DISTINCT SEGMENT2 PLANT_SITE_ID
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			WHERE LOOKUP_TYPE = 'EE_PROBLEM_REPORT_DEMAND'
				AND SEGMENT1 = 'SCP'
				AND VALID_YN = 'Y'
                AND SEGMENT4 = @Param1--chaan
		)  A
		LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.PLANT_SITE_ID = B.SCM_SITE_ID
		ORDER BY CODE;
	 END

 /*===============================================
 용   도:  Plan Problem Sales Site 조회
 사 용 화 면:  Plan Problem  - 조회조건
 변       수:  Param1 = DIVISION_ID
 최 초 작 성:  2018. 07. 05
 개  발  자 :  ygkim
 최 종 작 성:  2018. 07. 05
 수  정  자 :  -
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'SalesSitePlanProblem' )
	 BEGIN
		SELECT DISTINCT SEGMENT3 CODE
			 ,SEGMENT3 NAME
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'EE_PROBLEM_REPORT_DEMAND'
			AND SEGMENT1 = 'SCP'
			AND VALID_YN = 'Y'
            AND SEGMENT4 = @Param1--chaan
		ORDER BY CODE;
	 END

 /*===============================================
 용   도:  Production Plan Plant Site 조회
 사 용 화 면:  Production Plan  - 조회조건
 변       수:  Param1 = DIVISION_ID , Param2 = OPERATION_GROUP
 최 초 작 성:  2018. 07. 05
 개  발  자 :  ygkim
 최 종 작 성:  2022. 10. 27
 수  정  자 :  chaan
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'PlantSiteProdPlan' )
	 BEGIN
		SELECT	  A.SCM_SITE_ID AS CODE
				, CASE
					WHEN B.SITE_DESCRIPTION IS NULL THEN A.SCM_SITE_ID
					WHEN B.SITE_DESCRIPTION IS NOT NULL THEN B.SITE_DESCRIPTION
				  END AS NAME
		FROM	(
					SELECT DISTINCT
							SEGMENT3 SCM_SITE_ID
					FROM	SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
					WHERE	1=1
						AND LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
						AND SEGMENT1 = 'SCP'
						AND ((@Param2 IS NULL OR @Param2 ='') OR SEGMENT2 IN (SELECT token FROM dbo.String_Split(@Param2, ',')))
						AND VALID_YN = 'Y'
						AND ATTRIBUTE2 = @Param1
						AND ((@Param3 <> 'JV Planner') OR SEGMENT3 IN (SELECT token FROM dbo.String_Split(@Param4, ',')))
				) A
				LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) ON
						A.SCM_SITE_ID = B.SCM_SITE_ID
		ORDER BY	CODE
	 END


 /*===============================================
 용   도:  Production Plan Line - Line ID 조회
 사 용 화 면:  Production Plan Line -  조회조건
 변       수:  Param1 = DIVISION_ID , Param2 = OPERATION_GROUP , Param3 = SCM_SITE_ID
 최 초 작 성:  2018. 07. 11
 개  발  자 :  ygkim
 최 종 작 성:  2022. 10. 27
 수  정  자 :  chaan
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'LineProdPlanLine' )
	 BEGIN
		SELECT DISTINCT
				  A.LINE_ID AS CODE
				, A.LINE_ID + '   ' + A.LINE_NAME AS NAME
		FROM	SCM_MST_LINE_SN A WITH (NOLOCK)
				JOIN
					(
						SELECT	  SEGMENT2 OPERATION_GROUP
								, SEGMENT3 SCM_SITE_ID
								, SEGMENT4 LINE_ID
								, SEGMENT5 OPERATION_ID
								, ATTRIBUTE1 ORIGIN_DIVISION_ID
						FROM	SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
						WHERE	LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
							AND SEGMENT1 = 'SCP'
							AND VALID_YN = 'Y'
							AND ATTRIBUTE2 = @Param1
					) C ON
						((@Param2 IS NULL OR @Param2 = '') OR C.OPERATION_GROUP IN (SELECT token FROM dbo.String_Split(@Param2, ',')))
					AND ((@Param3 IS NULL OR @Param3 ='') OR C.SCM_SITE_ID IN (SELECT token FROM dbo.String_Split(@Param3, ',')))
		WHERE	1=1
			AND A.ACTIVE_FLAG   ='Y'
			AND A.DIVISION_ID   = C.ORIGIN_DIVISION_ID
			AND A.LINE_ID       = C.LINE_ID
			AND A.OPERATION_ID  = C.OPERATION_ID
		UNION ALL
		SELECT	  '-'  AS CODE
				, '-'  AS NAME
		ORDER BY	NAME

 END


 /*===============================================
 용   도:  Production Plan Line(SSP) - Line ID 조회
 사 용 화 면:  Production Plan Line(SSP) -  조회조건
 변       수:  Param1 = DIVISION_ID , Param2 = OPERATION_GROUP , Param3 = SCM_SITE_ID
 최 초 작 성:  2018. 07. 11
 개  발  자 :  ygkim
 최 종 작 성:  2018. 07. 11
 수  정  자 :  -
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'LineProdPlanLineSSP' )
	 BEGIN
			SELECT DISTINCT
				A.LINE_ID                          AS CODE
				,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
			FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
			JOIN (SELECT SEGMENT2 OPERATION_GROUP
							,SEGMENT3 SCM_SITE_ID
							,SEGMENT4 LINE_ID
							,SEGMENT5 OPERATION_ID
							,ATTRIBUTE1 ORIGIN_DIVISION_ID
					FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
					WHERE LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
						AND SEGMENT1 = 'SSP'
						AND VALID_YN = 'Y'
       		            AND ATTRIBUTE2 = @Param1--chaan
                        ) C
			ON C.OPERATION_GROUP   = @Param2
			AND ( (@Param3 IS NULL OR @Param3 ='') OR C.SCM_SITE_ID IN ( SELECT token FROM dbo.String_Split(@Param3,','))   )
			WHERE 1=1
			AND A.ACTIVE_FLAG   ='Y'
			AND A.DIVISION_ID   = C.ORIGIN_DIVISION_ID
			AND A.LINE_ID       = C.LINE_ID
			AND A.OPERATION_ID  = C.OPERATION_ID
			UNION ALL
			SELECT
			'-'  AS CODE
			,'-'  AS NAME
			ORDER BY NAME
	 END


 /*===============================================
 용   도:  BOD - ToSite 조회 ( 전극 사업부 전용: From SIte로 SCM_SITE_ID = XXX-E 선택시 To Site 조회전용)
 사 용 화 면:  BOD - 조회조건
 변       수:  Param1 = DIVISION_ID
 최 초 작 성:  2018. 07. 13
 개  발  자 :  byunghunjung
 최 종 작 성:  2018. 07. 13
 수  정  자 :  -
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'ToSiteBOD' )
	 BEGIN
		 SELECT  SCM_SITE_ID   AS CODE
		   ,SCM_SITE_ID   AS NAME
		   ,SITE_TYPE
		   ,CITY
		  FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
		 WHERE  A.VALID_YN  = 'Y'
		   AND  A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',') )
		   --AND  A.SCM_SITE_ID NOT LIKE '%' + '-P'
		 UNION
		 SELECT  SCM_SITE_ID   AS CODE
		   , SCM_SITE_ID AS NAME
		   ,SITE_TYPE
		   ,CITY
		  FROM  [SCM_MST_SITE] AS A WITH(NOLOCK)
		 WHERE  A.VALID_YN  = 'Y'
			  AND  A.SCM_SITE_ID LIKE '%' + '-A'
		   ORDER BY SITE_TYPE

	 END



 /*===============================================
  용   도:  Plant Site 반환(Division, Operation Group별)
  사 용 화 면:  SCP0027 - Electrode Route
  변       수:  -
  최 초 작 성:  2018. 07. 17
  개  발  자 :  윤 혜 원
  최 종 작 성:  -
  수  정  자 :  -
  수 정 사 항:
  ===============================================*/
 ELSE IF (@Code = 'ElecRoutePlantByOperation' )
	 BEGIN
		SELECT A.SCM_SITE_ID AS CODE
			   ,A.DIVISION_ID + '   ' + A.SCM_SITE_ID + '   ' + A.SITE_DESCRIPTION + (CASE WHEN B.PLANT_SITE_ID IS NOT NULL OR C.PLANT_SITE_ID IS NOT NULL THEN ' Y' ELSE ' N' END) AS NAME
		  FROM  [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		  LEFT JOIN (
					SELECT T.ITEM_ID , T.PLANT_SITE_ID
					FROM SCP_MST_TACT_TIME T WITH(NOLOCK)
					JOIN SCM_MST_SITE S WITH(NOLOCK) ON S.SCM_SITE_ID=T.PLANT_SITE_ID
					JOIN SCM_MST_LINE_SN LS WITH(NOLOCK) ON LS.COMPANY_ID=S.COMPANY_ID AND LS.DIVISION_ID=T.DIVISION_ID AND LS.SITE_ID=S.SITE_ID AND LS.PLANT_ID=S.PLANT_ID
											AND LS.OPERATION_ID=T.OPERATION_ID AND LS.LINE_ID=T.LINE_ID AND LS.ACTIVE_FLAG='Y'
					WHERE T.DIVISION_ID = @Param1
						AND T.ITEM_ID = @Param3
						AND T.VALID_YN='Y'
					GROUP BY T.ITEM_ID , T.PLANT_SITE_ID
					/*
					SELECT ITEM_ID , PLANT_SITE_ID FROM SCP_MST_TACT_TIME WITH(NOLOCK)
					 WHERE DIVISION_ID = @Param1
					   AND ITEM_ID = @Param3
					   AND VALID_YN='Y'
					 GROUP BY ITEM_ID , PLANT_SITE_ID
					 */
					) B ON A.SCM_SITE_ID=B.PLANT_SITE_ID
		  LEFT JOIN (
					SELECT PLANT_SITE_ID FROM SCP_MST_OUTSOURCING_CAPA WITH(NOLOCK)
					 WHERE DIVISION_ID = @PARAM1
					   AND ITEM_ID = @Param3
					   AND VALID_YN ='Y'
					 GROUP BY PLANT_SITE_ID
					) C ON A.SCM_SITE_ID= C.PLANT_SITE_ID
		 WHERE 1 = 1
		   AND A.VALID_YN ='Y'
		   AND A.SITE_TYPE = 'PLANT'
		   AND ( ( @Param1 IS NULL OR  @Param1='' ) OR  A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')) )
		   AND ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )
		 ORDER BY A.DIVISION_ID, CODE
	 END;
 /*===============================================
  용   도:  Shipment FG & SEMI의 To Site 반환(Division, Operation Group별)
  사 용 화 면:  SCP0027 - Electrode Route
  변       수:  @Param1 : 폼 명 (FG , SEMI ...) , @Param2= division_id ,
				@Param3 = operation group or biz_type
  최 초 작 성:  2018. 07. 19
  개  발  자 :  KYH
  최 종 작 성:  -
  수  정  자 :  -
  수 정 사 항:
  ===============================================*/
 ELSE IF (@Code = 'ToSiteShipmentPlan' )
	 BEGIN
		IF @Param1 = 'S'
		BEGIN
			select
				A.TO_SITE AS CODE ,
				CASE WHEN B.SITE_DESCRIPTION IS NULL  THEN A.TO_SITE
				WHEN B.SITE_DESCRIPTION IS NOT NULL THEN B.SITE_DESCRIPTION
				END AS NAME
			from (
					select TO_SITE
					from SCP_ANL_SHIPMENT_PLAN_SEMI WITH(NOLOCK)
					where DIVISION_ID = @Param2 and OPERATION_GROUP = @Param3
					group by TO_SITE
			)  A
			LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.TO_SITE = B.SCM_SITE_ID
			order by CODE
		END
		ELSE IF @Param1 = 'F'
		BEGIN
			SELECT
				TO_SITE AS CODE , TO_SITE AS NAME
			FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)
			WHERE DIVISION_ID = @Param2
				AND BIZ_TYPE = @Param3
			GROUP BY TO_SITE
			ORDER BY TO_SITE ASC
		END
	 END;

 /*===============================================
  용   도:  Shipment SEMI의 To Site 반환(Division, Operation Group별)
  사 용 화 면:  SCP0010 - Shipment Plan SEMI
  변       수:  @Param1 : division_id , @Param2= operation group or biz_type
  최 초 작 성:  2018. 08. 08
  개  발  자 :  ygkim
  최 종 작 성:  -
  수  정  자 :  -
  수 정 사 항:
  ===============================================*/
 ELSE IF (@Code = 'ToSiteShipmentPlanSEMI' )
	 BEGIN
		SELECT
			A.TO_SITE AS CODE ,
			CASE WHEN B.SITE_DESCRIPTION IS NULL  THEN A.TO_SITE
			WHEN B.SITE_DESCRIPTION IS NOT NULL THEN B.SITE_DESCRIPTION
			END AS NAME
		FROM (
				SELECT distinct SEGMENT3 TO_SITE
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
				WHERE LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_SEMI'
					AND SEGMENT1 = 'SCP'
					AND SEGMENT2 = @PARAM2
					AND VALID_YN = 'Y'
		)  A
		LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.TO_SITE = B.SCM_SITE_ID
		ORDER BY CODE
	 END;

/*===============================================
  용   도:  Shipment FG의 To Site 반환(Division, Operation Group별)
  사 용 화 면:  SCP0009 - Shipment Plan FG
  변       수:  @Param1 : division_id , @Param2= operation group or biz_type
  최 초 작 성:  2018. 08. 08
  개  발  자 :  ygkim
  최 종 작 성:  -
  수  정  자 :  -
  수 정 사 항:
  ===============================================*/
 ELSE IF (@Code = 'ToSiteShipmentPlanFG' )
	 BEGIN
		SELECT TO_SITE AS CODE , TO_SITE AS NAME
		FROM(
			SELECT distinct SEGMENT3 TO_SITE
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
				WHERE LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_FG'
				  AND SEGMENT1 = 'SCP'
				  AND SEGMENT2 = @Param2
				  AND VALID_YN = 'Y'
		) A
		ORDER BY TO_SITE ASC;
	 END;

/*===============================================
  용   도:  Operation Group 40, 81, 82
  사 용 화 면:  SCP, SSP, Report
  변       수:
  최 초 작 성:  2018. 07. 20
  개  발  자 :  ygkim
  최 종 작 성:  -
  수  정  자 :  -
  수 정 사 항:
  ===============================================*/
 ELSE IF (@Code = 'OperationGroup' )
	 BEGIN
		SELECT B.SEGMENT1 CODE
			  ,B.SEGMENT2 NAME
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE
		WHERE A.LOOKUP_TYPE = 'OPERATION_GROUP'
		  AND A.VALID_YN = 'Y'
		  AND B.VALID_YN = 'Y'
		  AND B.SEGMENT1 IN ('P','A')
		ORDER BY B.DISPLAY_SEQ;
	 END;

/*===============================================
  용   도:  Operation Group EE
  사 용 화 면:  SCP, SSP, Report
  변       수:
  최 초 작 성:  2018. 07. 20
  개  발  자 :  ygkim
  최 종 작 성:  -
  수  정  자 :  -
  수 정 사 항:
  ===============================================*/
 ELSE IF (@Code = 'OperationGroupEE' )
	 BEGIN
		SELECT B.SEGMENT1 CODE
			  ,B.SEGMENT2 NAME
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE
		WHERE A.LOOKUP_TYPE = 'OPERATION_GROUP'
		  AND A.VALID_YN = 'Y'
		  AND B.VALID_YN = 'Y'
		  AND B.SEGMENT1 IN ('A','E')
		ORDER BY B.DISPLAY_SEQ;
	 END;

/*===============================================
  용   도:  Shipment Plan SEMI To Site
  사 용 화 면: Shipment Plan SEMI
  변       수:
  최 초 작 성:  2018. 08. 08
  개  발  자 :  ygkim
  최 종 작 성:  -
  수  정  자 :  -
  수 정 사 항:
  ===============================================*/
 ELSE IF (@Code = 'ShipmentPlanSEMIToStie' )
	 BEGIN

		DECLARE @operCd nvarchar(10)='';
		IF (@Param1='40')
			SET @operCd='P,A';
		ELSE
			SET @operCd='P';

		SELECT A.SCM_SITE_ID AS CODE
			--,A.SITE_DESCRIPTION AS NAME
			,A.SCM_SITE_ID + '   '+A.SITE_DESCRIPTION AS NAME
		FROM  [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
		AND  A.VALID_YN ='Y'
		AND  A.SITE_TYPE = 'PLANT'
		--AND  A.OSP_YN = 'N'
		AND  A.DIVISION_ID  = @Param1
		--AND A.OPERATION_GROUP = 'P'
		AND A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@operCd,','))
		ORDER BY CODE
	 END;

/*===============================================
  용   도:  Shipment Plan SEMI To Site
  사 용 화 면: Shipment Plan SEMI
  변       수:
  최 초 작 성:  2018. 08. 08
  개  발  자 :  ygkim
  최 종 작 성:  -
  수  정  자 :  -
  수 정 사 항:
  ===============================================*/
 ELSE IF (@Code = 'LocationGroupByCapaWT' )
	 BEGIN
		SELECT *
		FROM(
				SELECT SEGMENT4 as code, d.OPERATION_NAME as name
				FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
					join  SCM_MST_OPERATION_SN d WITH(NOLOCK) on b.SEGMENT4 =  d.OPERATION_ID
				WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
				AND    b.valid_yn = 'Y'
				AND    b.segment3 = 'Y'
				AND    (@Param1 IS NULL OR @Param1='' OR @Param1 IN (SELECT TOKEN FROM dbo.String_Split(b.segment5,',')))
				GROUP BY SEGMENT4,d.OPERATION_NAME
				UNION ALL
				SELECT 'VENDOR' code, 'VENDOR' name
		) A
		ORDER BY name
	END

/*===============================================
	용		 도:  Waterfall Version조회
	사 용 화 면:  SCRP0017 Waterfall Production Plan
	변       수:  @Param1 : Division, @Param2 : operation_group
	최 초 작 성:  2018. 08. 09
	개  발  자 :  ygkim
	최 종 작 성:  2018. 08. 09
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'WaterfallVer'
	BEGIN
		SELECT TOP 10 'PP_W_'+PLAN_START_YYYYMMDD CODE
				, 'PP_W_'+PLAN_START_YYYYMMDD NAME
		FROM SCP_PLAN_VERSION_V WITH(NOLOCK)
		WHERE DIVISION_ID	= @Param1
		AND PLAN_TYPE		='FN'
		AND CONFIRM_FLAG	='Y'
		ORDER BY PLAN_START_YYYYMMDD DESC
	END

/*===============================================
	용		 도:  Waterfall Version 조회
	사 용 화 면:  SCP0016_WaterfallShipmentPlanFG
	변       수:  @Param1 : Division, @Param2 : biz_type
	최 초 작 성:  2018. 08. 09
	개  발  자 :  ygkim
	최 종 작 성:  2018. 08. 09
	수  정  자 :
	수 정 사 항:
	===============================================*/
 ELSE IF @Code = 'WaterfallVer_FG'
	BEGIN
		SELECT TOP 10 'SP_W_'+PLAN_START_YYYYMMDD CODE
				, 'SP_W_'+PLAN_START_YYYYMMDD NAME
		FROM SCP_PLAN_VERSION_V WITH(NOLOCK)
		WHERE DIVISION_ID	= @Param1
		AND PLAN_TYPE		='FN'
		AND CONFIRM_FLAG	='Y'
		ORDER BY PLAN_START_YYYYMMDD DESC
	END

/*===============================================
	용		 도:  Waterfall Version 조회
	사 용 화 면:  SCP0018_WaterfallShipmentPlanSemi
	변       수:  @Param1 : Division, @Param2 : OPERATION_GROUP
	최 초 작 성:  2018. 08. 09
	개  발  자 :  ygkim
	최 종 작 성:  2018. 08. 09
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'WaterfallVer_SEMI'
	BEGIN
		SELECT TOP 10 'SP_W_'+PLAN_START_YYYYMMDD CODE
				, 'SP_W_'+PLAN_START_YYYYMMDD NAME
		FROM SCP_PLAN_VERSION_V WITH(NOLOCK)
		WHERE DIVISION_ID	= @Param1
		AND PLAN_TYPE		='FN'
		AND CONFIRM_FLAG	='Y'
		ORDER BY PLAN_START_YYYYMMDD DESC
	END

/*===============================================
	용		 도:  Plant Site Loaction(OSP) Tab Plant Combo Data
	사 용 화 면:  SCP0001_Plant Site
	변       수:  @Param1 : Division
	최 초 작 성:  2018. 08. 10
	개  발  자 :  ygkim
	최 종 작 성:  2018. 08. 10
	수  정  자 : ymh
	수 정 사 항: 2025.10.03 name 추가붙일때 NULL처리
	===============================================*/
ELSE IF @Code = 'PlantByDivisionAll'
	BEGIN
		SELECT distinct S.PLANT_ID      AS CODE
			,S.PLANT_ID + ' ' +  ISNULL((CASE  WHEN A.PLANT_NAME IS NULL  THEN V.VENDOR_NAME ELSE A.PLANT_NAME END ),'') AS NAME -- 2025.10.03 YMH NULL처리 추가.
		FROM  SCM_MST_SITE S WITH(NOLOCK)
		LEFT OUTER JOIN  SCM_MST_PLANT_SN A WITH(NOLOCK) ON A.DIVISION_ID = S.DIVISION_ID AND A.PLANT_ID = S.PLANT_ID -- AND s.operation_group = A.shop_group_id
		LEFT OUTER JOIN  SCM_MST_VENDOR V WITH(NOLOCK) ON V.VENDOR_CODE = S.PLANT_ID
		WHERE ( (@Param1 IS NULL OR @Param1 = '') OR s.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@Param1	,',')) )
			AND S.VALID_YN ='Y'
			AND S.PLANT_ID IS NOT NULL
			AND S.osp_yn = 'N'
		ORDER BY S.PLANT_ID
	END

/*===============================================
	용		 도:  Plant Site Loaction(OSP) Tab Storage Combo Data
	사 용 화 면:  SCP0001_Plant Site
	변       수:  @Param1 : Division, @Param2 : Plant
	최 초 작 성:  2018. 08. 10
	개  발  자 :  ygkim
	최 종 작 성:  2018. 08. 10
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'StorageByDivPlant'
	BEGIN
		SELECT distinct STORAGE_ID CODE
			,(STORAGE_ID + '  ' + STORAGE_DESCRIPTION) NAME
		FROM SCM_MST_SLOC WITH(NOLOCK)
		WHERE  1=1
			AND	( (@Param1 IS NULL OR @Param1 = '') OR DIVISION_ID IN (SELECT token FROM dbo.String_Split(@Param1	,',')) )
			AND (@Param2 = '' OR PLANT_ID = @Param2)
	END


/*===============================================
	용		 도:  PlantSiteByDivision
	사 용 화 면:  공통
	변       수:  @Param1 : Division
	최 초 작 성:  2018. 08. 14
	개  발  자 :  YWHOON
	최 종 작 성:  2018. 08. 14
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'PlantSiteByDivision'
	BEGIN
		SELECT '-' AS CODE, '-' AS NAME
		UNION ALL
		SELECT A.SCM_SITE_ID AS CODE
			, A.SITE_DESCRIPTION AS NAME
		FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
		AND    A.SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		AND    A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
	END


/*===============================================
	용		 도:  Project Route - PlantSiteOsPack
	사 용 화 면:  공통
	변       수:
	최 초 작 성:  2018. 08. 14
	개  발  자 :  YWHOON
	최 종 작 성:  2018. 08. 14
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'PlantSiteOsPack'
	BEGIN
		SELECT
			s.company_id
			, s.division_id
			, s.scm_site_id
			, s.packer_item_id_suffix
			, s.site_id
		FROM SCM_MST_SITE S(NOLOCK)
		WHERE s.site_type = 'PLANT'
		AND S.DIVISION_ID = '40'
		AND S.OSP_YN = 'Y'
		AND S.VALID_YN = 'Y'
		AND s.operation_group = 'P'
	END

 /*===============================================
 용   도:  BOD - DIVISION 변경시 SITE 조회
 사 용 화 면:  BOD - 조회조건
 변       수:  Param1 = DIVISION_ID,  @Param2 = GroupID , @Param3 = UserID
 최 초 작 성:  2018. 08. 17
 개  발  자 :  ygkim
 최 종 작 성:  2018. 08. 17
 수  정  자 :  -
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'ToSiteByDivision' )
	 BEGIN
		SELECT	 SCM_SITE_ID			AS	CODE
				,SCM_SITE_ID			AS	NAME
				,SITE_TYPE
				,CITY
		FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
		WHERE   A.VALID_YN  = 'Y'
		AND			CASE WHEN @Param1 = 'ALL' OR @Param1 ='' THEN @Param1
					ELSE A.DIVISION_ID
				END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
						)
		AND    A.DIVISION_ID IN (SELECT CODE
		                            FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    			WHERE  GroupID LIKE '%'+ @Param2 + '%'
							    	AND    UserID  LIKE '%'+ @Param3 + '%'
								    AND    AuthType = 'D')
	END

/*===============================================
용		 도:  DIVISION 변경시 SITE 조회
사 용 화 면:  BOD - 조회조건
변       수:  @PARAM1 = DIVISION, @PARAM2 = GROUPID, @PARAM3 = USERID
최 초 작 성:
개  발  자 :
최 종 작 성:  2018. 08. 20
수  정  자 :  ygkim
수 정 사 항:
===============================================*/
 ELSE IF @Code = 'FromSiteByDivision'
	BEGIN
	    Declare @AuthTypeParaDivision varchar(100) = 'D'
		if(@Param1 = 'JV Planner') SET @AuthTypeParaDivision = 'J';

		SELECT	SCM_SITE_ID        AS CODE
			,	SCM_SITE_ID		   AS NAME
			,   CITY
			,   OSP_YN
		FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
		WHERE SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		AND CASE WHEN @Param1 = 'ALL' OR @Param1 ='' THEN @Param1
					ELSE A.DIVISION_ID
			END  IN (  SELECT token FROM dbo.String_Split(@Param1,',')	 )

		AND   A.DIVISION_ID IN (SELECT CODE							--2018-02-14 진준희 수정
									FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    			WHERE  GroupID LIKE '%'+ @Param2 + '%'
									AND    UserID  LIKE '%'+ @Param3 + '%'
									AND    AuthType = @AuthTypeParaDivision)

	END

/*===============================================
용		 도:  Item List 조회
사 용 화 면:  Production Plan Line Insert Popup - 조회조건
변       수:  @PARAM1 = DIVISION, @PARAM2 = OPERATION_GROUP, @PARAM3 = Plan Date, @PARAM4 = Plan Type, @PARAM5 = Seq
최 초 작 성:
개  발  자 :
최 종 작 성:  2021. 05. 24
수  정  자 :  ygkim,khj79
수 정 사 항:  scp_mst_tact_time => SCM_MST_TACT_TIME_SN 변경 , TACT TIME 계획 종료구간 추가
===============================================*/
 ELSE IF @Code = 'ItemProdPlanLinePopup'
	BEGIN
		--IF @Param1 = 'EE'
		IF @Param1 LIKE 'EE%'
			BEGIN
				IF OBJECT_ID('tempdb..#TT') IS NOT NULL
				    BEGIN    DROP TABLE #TT END;

				SELECT DISTINCT DIVISION_ID, ITEM_ID, PLANT_ID
				INTO #TT
									  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
									 WHERE ( @Param3='' or @Param3 is null or X.DIVISION_ID=@Param3)
									   AND X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
									   AND X.TACT_TIME > 0
									    ----- 계획 종료 구간 추가
									   --AND MONTH < = (  SELECT p.horizon_end_date  // LWY
									   AND MONTH < = (  SELECT MAX(p.horizon_end_date) AS horizon_end_date
														 FROM dbo.scm_mst_plan p WITH(NOLOCK)
														WHERE ( @Param3='' or @Param3 is null or P.DIVISION_ID=@Param3)
														  AND p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK)
																				WHERE ( @Param3='' or @Param3 is null or X.DIVISION_ID=@Param3)
																				  and plan_id <  9999)
																				)
													;

				SELECT a.ITEM_ID CODE
						,a.ITEM_ID NAME
						,PLANT_SITE_ID
						,c.SITE_DESCRIPTION
						,(select top 1 NICK_NAME from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID) NICK_NAME
						,CASE WHEN C.OSP_YN='Y' THEN (select top 1 ITEM_TYPE from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID AND (B.ITEM_TYPE='P' OR B.ITEM_TYPE='H'))
							  ELSE (select MIN(ISNULL(ITEM_TYPE,'Z')) from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID and b.site_id=c.site_id)
							  --ELSE (select top 1 ITEM_TYPE from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID and b.site_id=c.site_id)
						 END ITEM_TYPE
						--,(select top 1 ITEM_TYPE from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID and b.site_id=c.site_id) ITEM_TYPE
						,OPERATION_ID
						,a.DIVISION_ID
						,C.OSP_YN
				FROM(
						SELECT distinct a.ITEM_ID, a.PLANT_SITE_ID, SUBSTRING(i.FLOW_ID,1,5) OPERATION_ID, a.division_id
						FROM scm_mst_site_item_priority a (NOLOCK)
						--JOIN scp_mst_tact_time b (NOLOCK) ON a.item_id = b.item_id AND a.PLANT_SITE_ID = b.PLANT_SITE_ID
						--LEFT JOIN scp_mst_tact_time b (NOLOCK) ON a.division_id = b.division_id AND a.item_id = b.item_id AND a.PLANT_SITE_ID = b.PLANT_SITE_ID
						JOIN SCM_MST_SITE C WITH(NOLOCK) ON C.SCM_SITE_ID=A.PLANT_SITE_ID
						-- 테이블 변경
						LEFT JOIN #TT B
					/*	LEFT JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, PLANT_ID
									  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
									 WHERE ( @Param3='' or @Param3 is null or X.DIVISION_ID=@Param3)
									   AND X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
									   AND X.TACT_TIME > 0
									    ----- 계획 종료 구간 추가
									   --AND MONTH <= (  SELECT p.horizon_end_date  // LWY
									   AND MONTH <= (  SELECT MAX(p.horizon_end_date) AS horizon_end_date
														 FROM dbo.scm_mst_plan p WITH(NOLOCK)
														WHERE ( @Param3='' or @Param3 is null or P.DIVISION_ID=@Param3)
														  AND p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK)
																				WHERE ( @Param3='' or @Param3 is null or X.DIVISION_ID=@Param3)
																				  and plan_id < 9999)
																				)
													) B */
							 ON A.DIVISION_ID	= B.DIVISION_ID
							AND A.ITEM_ID		= B.ITEM_ID
							AND C.PLANT_ID		= B.PLANT_ID

						LEFT OUTER JOIN SCP_MST_FINAL_ITEM i (NOLOCK) ON a.division_id = i.division_id AND a.item_id = i.item_id
						LEFT JOIN SCP_MST_OUTSOURCING_CAPA P WITH(NOLOCK) ON P.division_id=A.DIVISION_ID AND P.PLANT_SITE_ID=A.PLANT_SITE_ID AND A.ITEM_ID = P.ITEM_ID
						WHERE a.VALID_YN ='Y'
						AND (
									--(C.OSP_YN='N' AND b.VALID_YN ='Y'	) OR
									( C.OSP_YN='N' ) OR   -- 테이블 변경
									(C.OSP_YN='Y')
								)
						and ( @Param2='' or @Param2 is null or i.OPERATION_GROUP = @Param2 )
						AND (
									--(C.OSP_YN='N' AND B.TACT_TIME IS NOT NULL) OR
									(C.OSP_YN='N' AND B.DIVISION_ID IS NOT NULL) OR  -- 테이블 변경
									(C.OSP_YN='Y' AND P.daily_capa_qty IS NOT NULL)
								)
						and ( @Param3='' or @Param3 is null or a.DIVISION_ID=@Param3)
						-- 생산계획 있는 모델이라고 하더라도 라인 변경해서 추가할 경우가 있으므로 제외함 - 08.31 (정병훈D)
						--AND not exists (select 'x' from SCP_ANL_PRODUCTION_PLAN c (NOLOCK)
						--				where a.division_id = c.DIVISION_ID
						--				and a.ITEM_ID = c.ITEM_ID
						--				and (a.PLANT_SITE_ID = c.SCM_SITE_ID or b.PLANT_SITE_ID = c.SCM_SITE_ID)
						--				AND c.PLAN_START_YYYYMMDD = @Param3
						--				AND PLAN_TYPE = @Param4
						--				AND SEQ = @Param5
						--				AND OPERATION_GROUP = @Param2
						--				)
				) a
				LEFT OUTER JOIN SCM_MST_SITE c WITH(NOLOCK) ON A.PLANT_SITE_ID = c.SCM_SITE_ID AND C.VALID_YN = 'Y'
				--WHERE a.DIVISION_ID IN ('40','81','82')
				WHERE a.DIVISION_ID IN (SELECT division_id FROM SCM_MST_DIVISION WITH(NOLOCK) 
                                        WHERE  attribute4 IN (SELECT attribute4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE division_id = @param1 )
                                      )
				order by a.item_id

				IF OBJECT_ID('tempdb..#TT') IS NOT NULL
				    BEGIN    DROP TABLE #TT END;

			END
		ELSE
			BEGIN
					SELECT a.ITEM_ID CODE
							,a.ITEM_ID NAME
							,PLANT_SITE_ID
							,c.SITE_DESCRIPTION
							,(select top 1 NICK_NAME from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID) NICK_NAME
							,CASE WHEN C.OSP_YN='Y' THEN (select top 1 ITEM_TYPE from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID AND (B.ITEM_TYPE='P' OR B.ITEM_TYPE='H'))
								  ELSE (select MIN(ISNULL(ITEM_TYPE,'Z')) from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID and b.site_id=c.site_id)
							 END ITEM_TYPE
							--,(select top 1 ITEM_TYPE from SCM_MST_ITEM_SN b WITH(NOLOCK) where b.ITEM_ID = a.ITEM_ID and b.site_id=c.site_id) ITEM_TYPE
							,OPERATION_ID
							,a.DIVISION_ID
							,C.OSP_YN
					FROM(
							SELECT distinct a.ITEM_ID, a.PLANT_SITE_ID, SUBSTRING(i.FLOW_ID,1,5) OPERATION_ID, a.DIVISION_ID
							FROM scm_mst_site_item_priority a (NOLOCK)
							--LEFT JOIN scp_mst_tact_time b (NOLOCK) ON a.division_id = b.division_id AND a.item_id = b.item_id AND a.PLANT_SITE_ID = b.PLANT_SITE_ID
							LEFT OUTER JOIN SCP_MST_FINAL_ITEM i (NOLOCK) ON a.division_id = i.division_id AND a.item_id = i.item_id
							JOIN SCM_MST_SITE C WITH(NOLOCK) ON C.SCM_SITE_ID=A.PLANT_SITE_ID
							-- 테이블 변경
							LEFT JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, PLANT_ID
									  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
									 WHERE X.DIVISION_ID  = @Param1
									   AND X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
									   AND X.TACT_TIME > 0
									     ----- 계획 종료 구간 추가
									   AND MONTH <= (  SELECT p.horizon_end_date
														 FROM dbo.scm_mst_plan p WITH(NOLOCK)
														WHERE ( @Param1='' or @Param1 is null or P.DIVISION_ID=@Param1)
														  AND p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK)
																				WHERE ( @Param1='' or @Param1 is null or X.DIVISION_ID=@Param1)
																				  and plan_id < 9999)
													)
										) B
							 ON A.DIVISION_ID	= B.DIVISION_ID
							AND A.ITEM_ID		= B.ITEM_ID
							AND C.PLANT_ID		= B.PLANT_ID

							LEFT JOIN SCP_MST_OUTSOURCING_CAPA P WITH(NOLOCK) ON P.division_id=A.DIVISION_ID AND P.PLANT_SITE_ID=A.PLANT_SITE_ID AND A.ITEM_ID = P.ITEM_ID
							--AND i.site_id = ( select site_id from scm_mst_plant_sn s (NOLOCK) where s.division_id = a.division_id and s.plant_id = dbo.fn_scm_split(a.plant_site_id,1,'-') )
							WHERE a.VALID_YN ='Y'
							AND (
									--(C.OSP_YN='N' AND b.VALID_YN ='Y'	) OR
									( C.OSP_YN='N' ) OR   -- 테이블 변경
									--ESS 외주 Pakcer Line 생산 Target 적용
									--(C.OSP_YN='Y')
									(C.OSP_YN='Y' AND ISNULL(C.ATTRIBUTE1,'N') IN ('','N'))
								)
							AND a.DIVISION_ID = @Param1
							and ( @Param2='' or @Param2 is null or i.OPERATION_GROUP = @Param2 )
							AND (
									--(C.OSP_YN='N' AND B.TACT_TIME IS NOT NULL) OR
									(C.OSP_YN='N' AND B.DIVISION_ID IS NOT NULL) OR  -- 테이블 변경
									--ESS 외주 Pakcer Line 생산 Target 적용
									--(C.OSP_YN='Y' AND P.daily_capa_qty IS NOT NULL)
									(C.OSP_YN='Y' AND P.daily_capa_qty IS NOT NULL AND ISNULL(C.ATTRIBUTE1,'N') IN ('','N'))
								)
							/*
							SELECT distinct a.ITEM_ID, a.PLANT_SITE_ID, SUBSTRING(i.FLOW_ID,1,5) OPERATION_ID, a.DIVISION_ID
							FROM scm_mst_site_item_priority a (NOLOCK)
							JOIN scp_mst_tact_time b (NOLOCK) ON a.division_id = b.division_id AND a.item_id = b.item_id AND a.PLANT_SITE_ID = b.PLANT_SITE_ID
							LEFT OUTER JOIN SCP_MST_FINAL_ITEM i (NOLOCK) ON a.division_id = i.division_id
							AND a.item_id = i.item_id
							--AND i.site_id = ( select site_id from scm_mst_plant_sn s (NOLOCK) where s.division_id = a.division_id and s.plant_id = dbo.fn_scm_split(a.plant_site_id,1,'-') )
							WHERE a.VALID_YN ='Y'
							AND b.VALID_YN ='Y'
							AND a.DIVISION_ID = @Param1
							and i.OPERATION_GROUP = @Param2
							*/
							-- 생산계획 있는 모델이라고 하더라도 라인 변경해서 추가할 경우가 있으므로 제외함 - 08.31 (정병훈D)
							--AND not exists (select 'x' from SCP_ANL_PRODUCTION_PLAN c (NOLOCK)
							--				where a.division_id = c.DIVISION_ID
							--				and a.ITEM_ID = c.ITEM_ID
							--				and (a.PLANT_SITE_ID = c.SCM_SITE_ID or b.PLANT_SITE_ID = c.SCM_SITE_ID)
							--				AND c.PLAN_START_YYYYMMDD = @Param3
							--				AND PLAN_TYPE = @Param4
							--				AND SEQ = @Param5
							--				AND OPERATION_GROUP = @Param2
							--				)
							-- ESS 외주 Pakcer Line 생산 Target 적용
							UNION ALL
							SELECT distinct a.ITEM_ID, a.PLANT_SITE_ID, SUBSTRING(i.FLOW_ID,1,5) OPERATION_ID, a.DIVISION_ID
							FROM scm_mst_site_item_priority a (NOLOCK)
							JOIN scp_mst_tact_time_OSP b (NOLOCK) ON a.division_id = b.division_id AND a.item_id = b.item_id AND a.PLANT_SITE_ID = b.PLANT_SITE_ID	AND B.VALID_YN='Y'
							LEFT OUTER JOIN SCP_MST_FINAL_ITEM i (NOLOCK) ON a.division_id = i.division_id AND a.item_id = i.item_id
							JOIN SCM_MST_SITE C WITH(NOLOCK) ON C.SCM_SITE_ID=A.PLANT_SITE_ID AND C.OSP_YN='Y' AND ISNULL(C.ATTRIBUTE1,'N')='Y'
							WHERE a.VALID_YN ='Y'
							AND a.DIVISION_ID = @Param1
							AND ( @Param2='' or @Param2 is null or i.OPERATION_GROUP = @Param2 )
					) a
					LEFT OUTER JOIN SCM_MST_SITE c WITH(NOLOCK) ON A.PLANT_SITE_ID = c.SCM_SITE_ID AND C.VALID_YN = 'Y'
					order by a.item_id
				END

	END

/*===============================================
용		 도:  Line List 조회
사 용 화 면:  Production Plan Line Insert Popup - 조회조건
변       수:  @PARAM1 = DIVISION, @PARAM2 = OPERATION_GROUP, @PARAM3 = SCM_SITE_ID, @Param4 = OPERATION_ID
최 초 작 성:
개  발  자 :
최 종 작 성:  2021. 05. 24
수  정  자 :  ygkim, khj79
수 정 사 항:  scp_mst_tact_time => SCM_MST_TACT_TIME_SN 변경 , TACT TIME 계획 종료 구간 설정
              2022.07.22        ISUZU 관련 수정 , lwy
===============================================*/
 ELSE IF @Code = 'LineProdPlanLinePopup'
	BEGIN
		--IF @Param1 = 'EE'
		IF @Param1 LIKE 'EE%'
			BEGIN
				SELECT
				DISTINCT
						A.LINE_ID						  AS CODE
					,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
				FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
				JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID
				INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1
								FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
								WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
								AND    b.valid_yn    = 'Y'
								AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
							) f ON a.operation_id = f.segment4 --AND c.operation_group_id = f.segment3 -- operation group id 에 추가된 operation 만보이도록
				--JOIN scp_mst_tact_time t WITH(NOLOCK) on t.division_id=@Param5 and t.plant_site_id=b.SCM_SITE_ID and t.item_id=@Param6 and t.operation_id=@Param4 and t.line_id=A.LINE_ID
				 JOIN ( SELECT DISTINCT X.DIVISION_ID, ITEM_ID , PLANT_ID , LINE_ID
								  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
								 WHERE X.DIVISION_ID  = @Param5
								   AND X.ITEM_ID = @Param6
								   AND X.OPERATION_ID = @Param4
								   AND X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
								   AND X.TACT_TIME > 0
								   ----- 계획 종료 구간 추가
								    AND MONTH <= (  SELECT p.horizon_end_date
													  FROM dbo.scm_mst_plan p WITH(NOLOCK)
													 WHERE ( @Param5='' or @Param5 is null or P.DIVISION_ID=@Param5)
													   AND p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK)
																			 WHERE ( @Param5='' or @Param5 is null or X.DIVISION_ID=@Param5)
																			   and plan_id < 9999)
													)

						) T
				  ON T.LINE_ID = A.LINE_ID
				 AND T.PLANT_ID = B.PLANT_ID
				WHERE 1=1
				AND A.ACTIVE_FLAG ='Y'
				--AND A.DIVISION_ID  IN ('40','81','82')
				AND A.DIVISION_ID IN (SELECT division_id FROM SCM_MST_DIVISION WITH(NOLOCK) 
                                      WHERE  attribute4 IN (SELECT attribute4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE division_id = @param1 )
                                     )
				AND A.OPERATION_ID = @Param4
				AND (@Param2='' OR @Param2 IS NULL OR b.OPERATION_GROUP = @Param2 )
				AND b.SCM_SITE_ID = @Param3
				AND (@Param5='' OR @Param5 IS NULL OR A.DIVISION_ID=@Param5)
			END
		ELSE
			BEGIN
				SELECT
				DISTINCT
						A.LINE_ID						  AS CODE
					,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
				FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
				JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND  A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID
				INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1
								FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
								WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
								AND    b.valid_yn    = 'Y'
								AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
							) f ON a.operation_id = f.segment4 --AND c.operation_group_id = f.segment3 -- operation group id 에 추가된 operation 만보이도록
				--JOIN scp_mst_tact_time t WITH(NOLOCK) on t.division_id=@Param1 and t.plant_site_id=b.SCM_SITE_ID and t.item_id=@Param6 and t.operation_id=@Param4 and t.line_id=A.LINE_ID
				 JOIN ( SELECT DISTINCT X.DIVISION_ID, ITEM_ID , PLANT_ID , LINE_ID
								  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
								 WHERE X.DIVISION_ID  = @Param1
								   AND X.ITEM_ID = @Param6
								   AND X.OPERATION_ID = @Param4
								   AND X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
								   AND X.TACT_TIME > 0
								    ----- 계획 종료 구간 추가
								    AND MONTH <= (  SELECT p.horizon_end_date
													  FROM dbo.scm_mst_plan p WITH(NOLOCK)
													 WHERE ( @Param1='' or @Param1 is null or P.DIVISION_ID=@Param1)
													   AND p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK)
																			 WHERE ( @Param1='' or @Param1 is null or X.DIVISION_ID=@Param1)
																			   and plan_id < 9999)
													)
						) T
				  ON T.LINE_ID = A.LINE_ID
				 AND T.PLANT_ID = B.PLANT_ID
				WHERE 1=1
				AND A.ACTIVE_FLAG ='Y'
				AND A.DIVISION_ID  = @Param1
				AND A.OPERATION_ID = @Param4
				AND (@Param2='' OR @Param2 IS NULL OR b.OPERATION_GROUP = @Param2)
				AND b.SCM_SITE_ID = @Param3
				--ESS 외주 Pakcer Line 생산 Target 적용
				UNION
				SELECT
				DISTINCT
					A.LINE_ID						  AS CODE
					,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
				FROM SCM_MST_LINE_OSP A WITH(NOLOCK)
				JOIN SCM_MST_SITE S WITH(NOLOCK) ON S.DIVISION_ID=A.DIVISION_ID
												 AND S.SCM_SITE_ID=A.SCM_SITE_ID
												 AND S.OSP_YN='Y'
												 AND ISNULL(S.ATTRIBUTE1,'N')='Y'
				JOIN SCP_MST_TACT_TIME_OSP B WITH(NOLOCK) ON A.DIVISION_ID=B.DIVISION_ID
														  AND A.SCM_SITE_ID=B.PLANT_SITE_ID
														  AND B.ITEM_ID=@Param6
														  AND B.VALID_YN='Y'
														  AND A.LINE_ID=B.LINE_ID
				WHERE A.DIVISION_ID=@Param1
				AND A.SCM_SITE_ID=@Param3
				AND A.VALID_YN='Y'
				UNION
				SELECT '-' AS CODE, '-' AS NAME
				FROM SCM_MST_SITE S WITH(NOLOCK)
				WHERE S.DIVISION_ID=@Param1
				AND S.SCM_SITE_ID=@Param3
				AND S.VALID_YN='Y'
				AND S.OSP_YN='Y'
				AND ISNULL(S.ATTRIBUTE1,'N') IN ('','N')

			   -- 2022.07.22 Begin
			   UNION
			   
			   SELECT
				DISTINCT
						A.LINE_ID						  AS CODE
					,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
				FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
				JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND  A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID
				
				 JOIN ( SELECT DISTINCT X.DIVISION_ID, X.ITEM_ID , X.PLANT_ID , X.LINE_ID
								  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
								  JOIN dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
									ON X.ITEM_ID = A.ITEM_ID
								   AND X.DIVISION_ID = A.DIVISION_ID
								 WHERE X.DIVISION_ID  = @Param1
								   AND X.ITEM_ID = @Param6
								   AND X.OPERATION_ID = @Param4
								   AND X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
								   AND X.TACT_TIME > 0
								    ----- 계획 종료 구간 추가
								    AND MONTH <= (  SELECT p.horizon_end_date
													  FROM dbo.scm_mst_plan p WITH(NOLOCK)
													 WHERE ( @Param1='' or @Param1 is null or P.DIVISION_ID=@Param1)
													   AND p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK)
																			 WHERE ( @Param1='' or @Param1 is null or X.DIVISION_ID=@Param1)
																			   and plan_id < 9999)
												 )
						) T
				  ON T.LINE_ID = A.LINE_ID
				 AND T.PLANT_ID = B.PLANT_ID
				WHERE 1=1
				AND A.ACTIVE_FLAG ='Y'
				AND A.DIVISION_ID  = @Param1
				AND A.OPERATION_ID = @Param4
				AND (@Param2='' OR @Param2 IS NULL OR b.OPERATION_GROUP = @Param2)
				AND b.SCM_SITE_ID = @Param3

				-- 2022.07.22 End

			END
	END

 /*===============================================
 용   도:  BOD - From Site가 외주 이고 오른쪽 끝 'A' 일경우
 사 용 화 면:  BOD - 조회조건
 변       수:  Param1 = DIVISION_ID,  @Param2 = GroupID , @Param3 = UserID
 최 초 작 성:  2018. 08. 28
 개  발  자 :  ygkim
 최 종 작 성:  2018. 08. 28
 수  정  자 :  -
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'ToSiteByDivisionPlant' )
	 BEGIN
		SELECT	 SCM_SITE_ID			AS	CODE
				,SCM_SITE_ID			AS	NAME
				,SITE_TYPE
				,CITY
		FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
		WHERE   A.VALID_YN  = 'Y'
		AND			CASE WHEN @Param1 = 'ALL' OR @Param1 ='' THEN @Param1
					ELSE A.DIVISION_ID
				END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')
						)
		AND    A.DIVISION_ID IN (SELECT CODE
		                            FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    			WHERE  GroupID LIKE '%'+ @Param2 + '%'
							    	AND    UserID  LIKE '%'+ @Param3 + '%'
								    AND    AuthType = 'D')
		AND A.SITE_TYPE = 'PLANT'
		AND A.OSP_YN = 'N'
		ANd A.OPERATION_GROUP = 'A'
	END


/*===============================================
 용       도:  End Customer 조회
 사 용 화 면:  Capacity Allocation - 조회조건
 변       수:
 최 초 작 성:  2018. 08. 30
 개  발  자 :  hwyoon
 최 종 작 성:  2018. 08. 30
 수  정  자 :  -
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'EndCustomerFromAllocation' )
	 BEGIN
		SELECT END_CUSTOMER AS CODE
				, END_CUSTOMER AS NAME
		FROM DM_MST_CAPACITY_ALLOCATION WITH(NOLOCK)
		GROUP BY END_CUSTOMER
		ORDER BY END_CUSTOMER
	END


/*===============================================
 용       도:  Sales Site 조회
 사 용 화 면:  Capacity Allocation - 조회조건
 변       수:
 최 초 작 성:  2018. 08. 30
 개  발  자 :  hwyoon
 최 종 작 성:  2018. 08. 30
 수  정  자 :  -
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'SalesSiteFromAllocation' )
	 BEGIN
		SELECT SCM_SITE_ID AS CODE
				, SCM_SITE_ID AS NAME
		FROM DM_MST_CAPACITY_ALLOCATION WITH(NOLOCK)
		GROUP BY SCM_SITE_ID
		ORDER BY SCM_SITE_ID
	END


 /*===============================================
 용   도:  FINAL ITEM DIVISION  조회
 사 용 화 면:  Plan Line NEW Div 조회 - 아이템 입력 시 ORIGIN DIVISION 조회
 변       수:
 최 초 작 성:  2018. 09. 03
 개  발  자 :  윤혜원
 최 종 작 성:  2018. 09. 03
 수  정  자 :
 수 정 사 항:
 ===============================================*/

  ELSE IF (@Code = 'OriginDivFromFinalItem' )
	 BEGIN
		SELECT A.DIVISION_ID CODE,  A.DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME
		  FROM SCP_MST_FINAL_ITEM A WITH(NOLOCK)
		  JOIN SCM_MST_DIVISION B WITH(NOLOCK)
		    ON A.DIVISION_ID=B.DIVISION_ID
		   AND B.VALID_YN='Y'
		 WHERE A.ITEM_ID=@Param1
		 GROUP BY A.DIVISION_ID
	 END

/*===============================================
	용		 도:  Shipment Plant Site
	사 용 화 면:  Shipping
	변       수:  -
	최 초 작 성:  2018. 09. 18
	개  발  자 :  ygkim
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'ShipmentPlanPlantSite'
	BEGIN
		--[NERP]COMPANY 예외적용 시작--NERP (IT20250117A)
		INSERT INTO @exception_company (company_id) select SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock) 
			WHERE 1=1
			AND LOOKUP_TYPE = 'SSP_UI_EXCEPT_COMPANY' and VALID_YN='Y'
		--[NERP]COMPANY 예외적용 끝--NERP (IT20250117A)

		SELECT distinct CODE
		      ,NAME
			  ,COMPANY_ID--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		FROM(
				SELECT A.SCM_SITE_ID AS CODE
					, A.SITE_DESCRIPTION AS NAME
					,A.COMPANY_ID--[NERP]COMPANY 예외적용--NERP (IT20250117A)
				FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'PLANT'
				AND    A.VALID_YN  = 'Y'
				AND    A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
				union all
				SELECT distinct SEGMENT1 CODE
					  ,A.SEGMENT1 + '   '+b.SITE_DESCRIPTION AS NAME
					   , B.COMPANY_ID--[NERP]COMPANY 예외적용--NERP (IT20250117A)
				FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] a WITH(NOLOCK)
--				LEFT OUTER JOIN SCM_MST_SITE b WITH(NOLOCK) on a.SEGMENT1 = b.SCM_SITE_ID and b.VALID_YN ='Y' 	--/* 전극 구코드가 나오는 문제 해결 ==> 이를 보완함. 강현준 (20240705) */
				INNER JOIN SCM_MST_SITE b WITH(NOLOCK) on a.SEGMENT1 = b.SCM_SITE_ID and b.VALID_YN ='Y'
				WHERE LOOKUP_TYPE = 'EE_SHIPMENT_PLAN'
				  AND a.VALID_YN = 'Y'
		) a
		WHERE not exists (select 1 from @exception_company K where a.COMPANY_ID = K.company_id)--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		ORDER BY CODE
	END;

/*===============================================
	용		 도:  Shipment To Site
	사 용 화 면:  Shipping
	변       수:  -
	최 초 작 성:  2018. 09. 18
	개  발  자 :  ygkim
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'ShipmentPlanToSite'
	BEGIN
		-- 20220418	SMS	가상디비젼 권한 체크 추가
		Declare @AuthTypeShipmentPlanToSite varchar(100) = 'D'		   
		if(@Param2 = 'JV Planner') SET @AuthTypeShipmentPlanToSite = 'J';
		--[NERP]COMPANY 예외적용 시작--NERP (IT20250117A)
		INSERT INTO @exception_company (company_id) select SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock) 
			WHERE 1=1
			AND LOOKUP_TYPE = 'SSP_UI_EXCEPT_COMPANY' and VALID_YN='Y'
		--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		SELECT distinct CODE
			   ,NAME
			   ,COMPANY_ID--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		FROM(
			SELECT	 SCM_SITE_ID			AS	CODE
					,SITE_DESCRIPTION			AS	NAME
					,COMPANY_ID--[NERP]COMPANY 예외적용--NERP (IT20250117A)
			FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
			WHERE   A.VALID_YN  = 'Y'
			AND	A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')
									-- 시작 2026-06-12 강주용 튜닝 
									UNION ALL 
									SELECT DIVISION_ID
									 FROM SCM_MST_DIVISION WITH(NOLOCK)
									 WHERE VALID_YN = 'Y'
									 AND ATTRIBUTE3 = @Param1
									 -- 종료 2026-06-12 강주용 튜닝 
								)
			AND    A.DIVISION_ID IN (SELECT CODE
										FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    				WHERE  GroupID LIKE '%'+ @Param2 + '%'
										AND    UserID  LIKE '%'+ @Param3 + '%'
										AND    AuthType = @AuthTypeShipmentPlanToSite)
			--OR     A.DIVISION_ID like (case when @Param1 = '81' THEN '81_%' END) --2026-06-12 강주용 튜닝 
			union all
			SELECT distinct SEGMENT2 CODE
				  ,ISNULL(b.SITE_DESCRIPTION, a.SEGMENT2) NAME
				  ,B.COMPANY_ID --[NERP]COMPANY 예외적용--NERP (IT20250117A)
			FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] a WITH(NOLOCK)
			LEFT OUTER JOIN SCM_MST_SITE b WITH(NOLOCK) on b.SCM_SITE_ID = a.SEGMENT2
			WHERE LOOKUP_TYPE = 'EE_SHIPMENT_PLAN'
			  AND a.VALID_YN = 'Y'
			  AND A.SEGMENT2 != '-'
		) a
		WHERE not exists (select 1 from @exception_company K where a.COMPANY_ID = K.company_id)--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		ORDER BY CODE
	END;

/*===============================================
	용		 도:  Cell Type Gr
	사 용 화 면:  Production Plan Line, PSI
	변       수:  -
	최 초 작 성:  2018. 09. 18
	개  발  자 :  ygkim
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'CellTypeGr'
	BEGIN
		SELECT SEGMENT1 CODE
			  ,SEGMENT2 NAME
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'CELL_TYPE_GROUP_CODE'
		  AND VALID_YN = 'Y'
		ORDER BY DISPLAY_SEQ
	END;


/*===============================================
	용		 도:  Cell Type
	사 용 화 면:  GLOBAL PSI (MOBILITY IT)
	변       수:  -
	최 초 작 성:  2025.07.17
	개  발  자 :  YMH
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'CellType_EM0101'
	BEGIN
		SELECT  
			  CLASS_NAME AS CODE
			, CLASS_NAME AS NAME
		FROM    SCM_MST_ITEM_CLASS_SN IC WITH(NOLOCK)
		WHERE   CLASS_ID LIKE 'EM0101%'
		AND     LEVEL = 4
		ORDER BY CLASS_ID
	END;

/*===============================================
	용		 도:  Plant Site
	사 용 화 면:  Line Master, Loss Time, Formation, Tack Time
	변       수:  -
	최 초 작 성:  2018. 09. 19
	개  발 자 :  ygkim
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:  2019.11.21	yhw	OSPYN, OPERATION GROUP, DIVISION_ID 추가
	===============================================*/
	ELSE IF @Code = 'PlantByDivisionOperNonOsp'
	BEGIN
		SELECT A.SCM_SITE_ID AS CODE
			, A.SITE_DESCRIPTION AS NAME
			,A.OSP_YN
			,A.OPERATION_GROUP
			,A.DIVISION_ID
		FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
		AND    A.SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		ANd    A.OSP_YN = 'N'
		AND    A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
		AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )
	END;

/*===============================================
 용   도:  Shipment Change Request - EE To Site
 사 용 화 면:  Shipment Change Request - 조회조건
 변       수:  Param1 = DIVISION_ID,  @Param2 = GroupID , @Param3 = UserID
 최 초 작 성:  2018. 10. 15
 개  발  자 :  ygkim
 최 종 작 성:  2018. 10. 15
 수  정  자 :  -
 수 정 사 항:
 ===============================================*/
 ELSE IF (@Code = 'ToSiteByDivisionEE' )
	 BEGIN
		SELECT	 SCM_SITE_ID			AS	CODE
				,SITE_DESCRIPTION			AS	NAME
				,SITE_TYPE
				,CITY
		FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
		WHERE   A.VALID_YN  = 'Y'
		AND     A.OSP_YN = 'N'
		AND    A.DIVISION_ID IN (SELECT CODE
		                            FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    			WHERE  GroupID LIKE '%'+ @Param2 + '%'
							    	AND    UserID  LIKE '%'+ @Param3 + '%'
								    AND    AuthType = 'D')
		order by SCM_SITE_ID
	END

/*===============================================
 용   도:  Incoterms 조회
 사 용 화 면:  Shipment Change Request - 조회조건
 변       수:  Param1 = DIVISION_ID,  @Param2 = from_site , @Param3 = to_site
 최 초 작 성:  2018. 10. 15
 개  발  자 :  ygkim
 최 종 작 성:  2018. 10. 15
 수  정  자 :  -
 수 정 사 항: 2018.01.15	hwyoon	valid_yn 추가
             2020/09/21   KIMYONGHO     SSP INCOTERMS 변경 작업
	===============================================*/
	ELSE IF @Code = 'Incoterms'
	BEGIN
		--2020/09/21   KIMYONGHO     SSP INCOTERMS 변경 작업
		--SELECT distinct INCOTERMS CODE
		--      ,INCOTERMS NAME
		SELECT distinct SSP_INCOTERMS CODE
		      ,SSP_INCOTERMS NAME
		FROM SCP_MST_BOD_V
		WHERE 1=1
		AND division_id = @Param1
		AND from_site = @Param2
		AND to_site = @Param3
		AND bod_valid_yn = 'Y'
		order by SSP_INCOTERMS
	END

/*===============================================
 용   도:  Division 조회
 사 용 화 면:  Shipment Change Request - 조회조건
 변       수:  Param1 = From or To Site
 최 초 작 성:  2018. 10. 15
 개  발  자 :  ygkim
 최 종 작 성:  2018. 10. 15
 수  정  자 :  -
 수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'OrigionDivFromTo'
	BEGIN
		SELECT DIVISION_ID, OPERATION_GROUP,COMPANY_ID
		FROM [SCM_MST_SITE] WITH(NOLOCK)
		WHERE 1=1
		AND SCM_SITE_ID = @Param1
	END
/*===============================================
용		 도:  DIVISION 변경시 SITE 조회
사 용 화 면:  Shipment Change Request - 조회조건
변       수:  @PARAM1 = DIVISION, @PARAM2 = GROUPID, @PARAM3 = USERID
최 초 작 성:
개  발  자 :
최 종 작 성:  2018. 08. 20
수  정  자 :  ygkim
수 정 사 항:
===============================================*/
  ELSE IF @Code = 'FromSiteByDivisionEE'
	BEGIN
		SELECT	SCM_SITE_ID        AS CODE
			,	SITE_DESCRIPTION		   AS NAME
		FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
		WHERE SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		AND  A.DIVISION_ID IN (SELECT CODE
									FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    			WHERE  GroupID LIKE '%'+ @Param2 + '%'
									AND    UserID  LIKE '%'+ @Param3 + '%'
									AND    AuthType = 'D')
		ORDER BY SCM_SITE_ID
	END


 /*===============================================
 용   도:  DIVISION  조회
 사 용 화 면:  interface 계획 조회화면  - 조회조건
 변       수:
 최 초 작 성:  2018. 10. 16
 개  발  자 :  윤혜원
 최 종 작 성:  2018. 10. 16
 수  정  자 :  윤혜원
 수 정 사 항:
 ===============================================*/
  ELSE IF @Code = 'AllDivision'
	BEGIN
		  SELECT DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME
			FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)
		   WHERE 1=1
		   GROUP BY DIVISION_ID
		   ORDER BY DIVISION_ID
	 END

 /*===============================================
 용   도:  All Plant Site  조회
 사 용 화 면:  JIG 조회화면  - 조회조건
 변       수:
 최 초 작 성:  2018. 10. 18
 개  발  자 :  윤혜원
 최 종 작 성:  2018. 10. 18
 수  정  자 :  윤혜원
 수 정 사 항:
 ===============================================*/
  ELSE IF @Code = 'AllPlantSite'
	BEGIN
		  SELECT SCM_SITE_ID CODE
				  , SITE_DESCRIPTION NAME
				  , OPERATION_GROUP
			FROM [dbo].[SCM_MST_SITE] WITH(NOLOCK)
		   WHERE 1=1
		     AND VALID_YN  = 'Y'
	 END


/*===============================================
	용		 도:  PlantByDivisionOperNonOsp2
	사 용 화 면:  JIG 조회화면  - 입력 comboBox
	변       수:  -
	최 초 작 성:  2018. 10. 18
	개  발  자 :  hwyoon
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'PlantByDivisionOperNonOsp2'
	BEGIN
		SELECT A.SCM_SITE_ID AS CODE
			,A.SCM_SITE_ID + '   '+A.SITE_DESCRIPTION AS NAME
			,A.OSP_YN
			,A.OPERATION_GROUP
			,A.DIVISION_ID
		FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
		AND    A.SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		ANd    A.OSP_YN = 'N'
		AND    A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
		AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )
		ORDER BY A.SCM_SITE_ID
	END;


/*===============================================
	용		 도:  AllJIGMaster
	사 용 화 면:  JIG Item 입력화면
	변       수:  -
	최 초 작 성:  2018. 10. 19
	개  발  자 :  hwyoon
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'AllJIGMaster'
	BEGIN
		SELECT	A.DIVISION_ID
				, (A.SCM_SITE_ID + ' ' + B.SITE_DESCRIPTION) AS SITE_DESCRIPTION
				, A.SCM_SITE_ID
				, A.OPERATION_ID
				, B.OPERATION_GROUP
				, L.SEGMENT2 OPERATION_GROUP_NM
				, A.JIG_NAME
				, A.JIG_SEQ
				, '-' ACTION_FLAG_DIV
		FROM SCP_MST_JIG A WITH(NOLOCK)
		JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.SCM_SITE_ID = B.SCM_SITE_ID
		JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) ON L.LOOKUP_TYPE='OPERATION_GROUP' AND L.VALID_YN='Y' AND L.SEGMENT1=B.OPERATION_GROUP
	END;

/*===============================================
	용		 도:  CompanyID
	사 용 화 면:  Shipment Plan Adjustment
	변       수:  -
	최 초 작 성:  2018. 10. 23
	개  발  자 :  ygkim
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'CompanyID'
	BEGIN
		SELECT COMPANY_ID
		FROM [dbo].[SCM_MST_SSO_USER_INFO] WITH(NOLOCK)
		WHERE USER_ID = @Param1
	END;

/*===============================================
용		 도:  DIVISION 변경시 SITE 조회
사 용 화 면:  SSP 화면
변       수:  @PARAM1 = DIVISION, @PARAM2 = GROUPID, @PARAM3 = USERID
최 초 작 성:  2018. 10. 24
개  발  자 :  ygkim
최 종 작 성:  -
수  정  자 :  -
수 정 사 항:
===============================================*/
	ELSE IF @Code = 'SSPToSiteByDivision'
	BEGIN
		-- 20220418	SMS	가상디비젼 권한 체크 추가
		Declare @AuthTypeSSPToSiteByDivision varchar(100) = 'D'		   
		if(@Param2 = 'JV Planner') SET @AuthTypeSSPToSiteByDivision = 'J';

		SELECT	 SCM_SITE_ID			AS	CODE
				,SITE_DESCRIPTION			AS	NAME
		FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
		WHERE   A.VALID_YN  = 'Y'
		AND			CASE WHEN @Param1 = 'ALL' OR @Param1 ='' THEN @Param1
					ELSE A.DIVISION_ID
				END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
		AND    A.DIVISION_ID IN (SELECT CODE
									FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    			WHERE  GroupID LIKE '%'+ @Param2 + '%'
									AND    UserID  LIKE '%'+ @Param3 + '%'
									AND    AuthType = @AuthTypeSSPToSiteByDivision)
	END;

/*===============================================
용		 도:  Operation ID 콤보박스 조회
사 용 화 면:  JIG 화면
변       수:
최 초 작 성:  2018. 11. 01
개  발  자 :  hwyoon
최 종 작 성:  -
수  정  자 :  -
수 정 사 항:
===============================================*/
	ELSE IF @Code = 'JIGOperationId'
	BEGIN
		SELECT DISTINCT RTRIM(LTRIM(SEGMENT4)) AS CODE
						,SEGMENT4 NAME
						,SUBSTRING(SEGMENT4,1,1) AS OPERATION_GROUP
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
		AND VALID_YN='Y'
		AND ( @Param2='' OR @Param2=NULL OR @Param2=SUBSTRING(SEGMENT4,1,1) )
		ORDER BY SEGMENT4
	END;

/*===============================================
용		 도:  JIG Item 조회
사 용 화 면:  JIG Item 입력화면
변       수:
최 초 작 성:  2018. 11. 02
개  발  자 :  hwyoon
최 종 작 성:  -
수  정  자 :  -
수 정 사 항:
===============================================*/
	ELSE IF @Code = 'AllJIGItem'
	BEGIN
		SELECT  CONVERT(NVARCHAR(MAX), JIG_ITEM_SEQ) AS JIG_ITEM_SEQ
				, CONVERT(NVARCHAR(MAX), JIG_SEQ) AS JIG_SEQ
				, ITEM_ID
				, CONVERT(NVARCHAR(10),dbo.fn_char_to_date(FROM_YYYYMMDD),121) AS FROM_YYYYMMDD
				, CONVERT(NVARCHAR(10),dbo.fn_char_to_date(TO_YYYYMMDD)  ,121) AS TO_YYYYMMDD
				, VALID_YN
				, '-' ACTION_FLAG_DIV
		FROM SCP_MST_JIG_ITEM WITH(NOLOCK)
	END

/*===============================================
	용		 도:  PlantSiteByDivisionOperation
	사 용 화 면:  공통
	변       수:  @PARAM1 = DIVISION, @PARAM2 = GROUPID, @PARAM3 = USERID
	최 초 작 성:  2018. 11. 23
	개  발  자 :  YWHOON
	최 종 작 성:  2018. 11. 23
	수  정  자 :
	수 정 사 항:  KIMYONGHO 2021-05-18 소형 사업부의 경우 Packer 제외
	===============================================*/
ELSE IF @Code = 'PlantSiteByDivisionEEOperation'
	BEGIN
		SELECT A.SCM_SITE_ID AS CODE
			, A.SITE_DESCRIPTION AS NAME
			--, A.SCM_SITE_ID AS NAME
		FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
		AND    A.SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		--AND	  A.DIVISION_ID = @Param1
		AND	   (@Param1='EE' OR A.DIVISION_ID=@Param1)
		AND NOT EXISTS (SELECT D.SCM_SITE_ID
								 FROM [dbo].[SCM_MST_SITE] D  WITH(NOLOCK)
								WHERE 1=1
									AND A.SCM_SITE_ID = D.SCM_SITE_ID
								  AND D.DIVISION_ID = '40'
								  AND D.OPERATION_GROUP = 'P'
								  -- 220809 jilee Packer항목 조건추가
								  AND D.OSP_YN = 'Y'
						)
		ORDER BY A.SCM_SITE_ID
	END
/*===============================================
	용		 도:  ToSiteByDivisionEEForSSP
	사 용 화 면:  공통
	변       수:  @PARAM1 = DIVISION
	최 초 작 성:  2018. 11. 23
	개  발  자 :  YWHOON
	최 종 작 성:  2018. 11. 23
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'ToSiteByDivisionEEForSSP'
	BEGIN

		SELECT DISTINCT AA.CODE, AA.NAME
		FROM (
			SELECT A.SCM_SITE_ID AS CODE
				, A.SITE_DESCRIPTION AS NAME
			FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
			WHERE  1 = 1
			AND    A.VALID_YN  = 'Y'
			AND	   (@Param1='EE' OR A.DIVISION_ID=@Param1)
			OR     A.DIVISION_ID like (case when @Param1 = '81' THEN '81_%' END)

			--ORDER BY A.SITE_DESCRIPTION

			UNION ALL

			SELECT A.ATTRIBUTE1  AS CODE
				, B.SITE_DESCRIPTION  AS NAME
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
			LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
			 ON A.ATTRIBUTE1 = B.SCM_SITE_ID
			WHERE A.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
			AND A.VALID_YN = 'Y'
			AND (@Param1 IS NULL OR @Param1='' OR A.SEGMENT2=@Param1)
			AND (@Param2 IS NULL OR @Param2='' OR A.SEGMENT3=@Param2)
			--AND (@Param1 IS NULL OR @Param1='' OR SEGMENT2=@Param1)
			--AND (@Param2 IS NULL OR @Param2='' OR SEGMENT4=@Param2)

			GROUP BY A.ATTRIBUTE1, B.SITE_DESCRIPTION
		) AA
		ORDER BY AA.CODE
	END

/*===============================================
	용		 도:  EndCustomerByItemForSSP
	사 용 화 면:  공통
	변       수:  @PARAM1 = DIVISION, @PARAM2 = TO_SITE, @PARAM3 = ITEM_ID
	최 초 작 성:  2018. 11. 23
	개  발  자 :  YWHOON
	최 종 작 성:  2018. 11. 23
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'EndCustomerByItemForSSP'
	BEGIN
		IF @Param5 = 'P'	-- 20220303	SMS	추가  소형외주 Packer
			BEGIN
				SELECT	A.PROJECT_CODE AS CODE
						,A.PROJECT_CODE AS NAME
				  FROM [dbo].[SCM_MST_SITE_ITEM] A  WITH(NOLOCK) -- 13858
                  JOIN SCM_MST_SITE SMS WITH(NOLOCK)
				    ON SMS.DIVISION_ID = A.DIVISION_ID
				 WHERE 1 = 1
				   AND A.VALID_YN	 = 'Y'
				   AND A.DIVISION_ID = @Param1
				   AND A.SCM_SITE_ID = @Param2
				   AND SMS.SCM_SITE_ID = @Param4
				   AND CASE WHEN ISNULL(SMS.PACKER_ITEM_ID_SUFFIX,'') = '' THEN A.ITEM_ID ELSE SUBSTRING(A.ITEM_ID,1,11) END = CASE WHEN ISNULL(SMS.PACKER_ITEM_ID_SUFFIX,'') = '' THEN @Param3 ELSE SUBSTRING(@Param3,1,11) END
				ORDER BY A.PROJECT_CODE ASC
			END
		ELSE
			BEGIN
				SELECT	A.PROJECT_CODE AS CODE
						,A.PROJECT_CODE AS NAME
				  FROM [dbo].[SCM_MST_SITE_ITEM] A  WITH(NOLOCK) -- 13858
				 WHERE 1 = 1
				   AND A.VALID_YN	 = 'Y'
				   AND A.DIVISION_ID = @Param1
				   AND A.SCM_SITE_ID = @Param2
				   AND A.ITEM_ID	 = @Param3
				ORDER BY A.PROJECT_CODE ASC
			END
	END


/*===============================================
	용		 도:  AllPlantByOperation
	사 용 화 면:  공통
	변       수:  @PARAM1 = DIVISION, @PARAM2 = OPERATION_GROUP
	최 초 작 성:  2018. 11. 23
	개  발  자 :  YWHOON
	최 종 작 성:  2018. 11. 23
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'AllPlantByOperation'
	BEGIN
		SELECT SCM_SITE_ID AS CODE
			   , SITE_DESCRIPTION AS NAME
		  FROM SCM_MST_SITE WITH(NOLOCK)
		 WHERE DIVISION_ID		= @Param1
		   AND SITE_TYPE		= 'PLANT'
		   AND OPERATION_GROUP	= @Param2
		   AND VALID_YN			= 'Y'
		   AND OSP_YN			= 'N'
		 ORDER BY OSP_YN, SCM_SITE_ID
	END



/*===============================================
	용		 도:  ShipmentRequestPlantSite
	사 용 화 면:  공통
	변       수:  @PARAM1 = DIVISION, @PARAM2 = OPERATION_GROUP
	최 초 작 성:  2019. 03. 12
	개  발  자 :  YWHOON
	최 종 작 성:  2019. 03. 12
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'ShipmentRequestPlantSite'
	BEGIN
		--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		INSERT INTO @exception_company (company_id) select SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock) 
			WHERE 1=1
			AND LOOKUP_TYPE = 'SSP_UI_EXCEPT_COMPANY' and VALID_YN='Y'
		--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		SELECT  CODE, NAME, COMPANY_ID--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		FROM
		(
		SELECT SCM_SITE_ID AS CODE
			   , SITE_DESCRIPTION AS NAME
			   , COMPANY_ID--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		FROM SCM_MST_SITE WITH(NOLOCK)
		 WHERE DIVISION_ID		= @Param1
		   AND SITE_TYPE		= 'PLANT'
		   AND OPERATION_GROUP	NOT IN (@Param2, @Param3)
		   AND VALID_YN			= 'Y'
		   AND OSP_YN			= 'N'
		--ORDER BY OSP_YN, SCM_SITE_ID
		 UNION ALL
		SELECT SCM_SITE_ID AS CODE
			, SITE_DESCRIPTION AS NAME
			, COMPANY_ID--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		FROM SCM_MST_SITE WITH(NOLOCK)
		WHERE DIVISION_ID		= '40'
		AND SITE_TYPE		= 'PLANT'		   
		AND SITE_DESCRIPTION = 'LGESNJ BATTERY-Pack'	
		AND VALID_YN			= 'Y'
		AND OSP_YN			= 'N'	
		) A
		WHERE not exists (select 1 from @exception_company K where a.COMPANY_ID = K.company_id)		--[NERP]COMPANY 예외적용--NERP (IT20250117A)

	END

/*===============================================
	용		 도:  PlanDateShipReq40
	사 용 화 면:  공통
	변       수:  @PARAM1 = DIVISION
	최 초 작 성:  2019. 03. 12
	개  발  자 :  YWHOON
	최 종 작 성:  2019. 03. 12
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'PlanDateShipReq40'
	BEGIN
		SELECT TOP 10 DIVISION_ID
				,PLAN_START_YYYYMMDD AS CODE
				,convert(VARCHAR(10), convert(DATETIME, PLAN_START_YYYYMMDD),121) NAME
				,PLAN_TYPE
				,SEQ
				,REQ_START_DATE
				,REQ_END_DATE
				,REQ_IN_START_DATE
				,REQ_IN_END_DATE
		FROM SSP_MST_SHIP_REQ WITH(NOLOCK)
		WHERE DIVISION_ID = @Param1
		AND  CUTOFF_FLAG  = 'Y'
		ORDER BY PLAN_START_YYYYMMDD DESC;
	END

/*===============================================
	용		 도:  SSPBlockCheckIF
	사 용 화 면:  공통
	변       수:  @PARAM1 = PRG_ID
	최 초 작 성:  2019. 03. 12
	개  발  자 :  YWHOON
	최 종 작 성:  2019. 03. 12
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'SSPBlockCheckIF'
	BEGIN
		SELECT CASE WHEN GETDATE()>=CONVERT(DATETIME, SEGMENT2, 21) AND GETDATE()<=CONVERT(DATETIME, SEGMENT3, 21) THEN 'Y'
					ELSE 'N'
				END AS BLOCK_YN, SEGMENT2 + ' ~ '+ SEGMENT3 AS PERIOD
		FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
		WHERE LOOKUP_TYPE='FUNCTION_BLOCK'
		AND SEGMENT1=@Param1
		AND VALID_YN='Y'
	END

/*===============================================
	용		 도:  SSP16LocToSite
	사 용 화 면:  SSP0016 - Shipment Request(Small)에서 사용
	변       수:  @PARAM1 = division_id, @PARAM2 = item_id
	최 초 작 성:  2019. 03. 13
	개  발  자 :  YWHOON
	최 종 작 성:  2019. 03. 13
	수  정  자 :  mcthj
	수 정 사 항:  [PJ20189106] 전지.GSCM 고도화 이행- 소형 추가
	              SCM_MST_SITE의 To_Site 테이블 union
	===============================================*/
ELSE IF @Code = 'SSP16LocToSite'
	BEGIN
		SELECT
			DISTINCT TT.CODE, TT.NAME
		FROM
		(
			SELECT SCM_SITE_ID AS CODE, SCM_SITE_ID AS NAME
			FROM SCM_MST_SITE_ITEM WITH(NOLOCK)
			WHERE DIVISION_ID = @Param1
			AND   ITEM_ID = @Param2
			UNION ALL
			SELECT DISTINCT SCM_SITE_ID AS CODE, SITE_DESCRIPTION AS NAME
			FROM SCM_MST_SITE WITH(NOLOCK)
			WHERE SITE_TYPE = 'PLANT'
			AND   OSP_YN  = 'Y'
			AND   DIVISION_ID = @Param1
			AND   VALID_YN = 'Y'
		) TT
		ORDER BY TT.NAME

	END

/*===============================================
	용		 도:  SSP16LocProjectCode
	사 용 화 면:  SSP0016 - Shipment Request(Small)에서 사용
	변       수:  @PARAM1 = division_id, @PARAM2 = item_id, @PARAM3 = to_site
	최 초 작 성:  2019. 03. 13
	개  발  자 :  YWHOON
	최 종 작 성:  2019. 03. 13
	수  정  자 :
	수 정 사 항:  [PJ20189106] 전지.GSCM 고도화 이행- 소형 추가
	===============================================*/
ELSE IF @Code = 'SSP16LocProjectCode'
	BEGIN
		DECLARE @DATA_CNT INT
		SET @DATA_CNT = (
							SELECT COUNT(*) FROM SCM_MST_SITE_ITEM WITH(NOLOCK)
							WHERE DIVISION_ID = @Param1 AND ITEM_ID = @Param2 AND SCM_SITE_ID = @Param3
						)
		IF @DATA_CNT = 0
			BEGIN
				SELECT '-' AS CODE, '-' AS NAME
			END
		ELSE
			BEGIN
				SELECT DISTINCT PROJECT_CODE AS CODE, PROJECT_CODE AS NAME
				FROM SCM_MST_SITE_ITEM WITH(NOLOCK)
				WHERE DIVISION_ID = @Param1
				AND   ITEM_ID = @Param2
				AND   SCM_SITE_ID = @Param3
				ORDER BY PROJECT_CODE
			END
	END

/*===============================================
	용		 도:  SSP16LocIncoterms
	사 용 화 면:  SSP0016 - Shipment Request(Small)에서 사용
	변       수:  @PARAM1 = division_id, @PARAM2 = from_site, @PARAM3 = to_site
	최 초 작 성:  2019. 03. 13
	개  발  자 :  YWHOON
	최 종 작 성:  2019. 03. 13
	수  정  자 :
	수 정 사 항:  [PJ20189106] 전지.GSCM 고도화 이행- 소형 추가
	             2020/09/21   KIMYONGHO     SSP INCOTERMS 변경 작업
	===============================================*/
ELSE IF @Code = 'SSP16LocIncoterms'
	BEGIN
		--2020/09/21   KIMYONGHO     SSP INCOTERMS 변경 작업
		--SELECT DISTINCT INCOTERMS AS CODE, INCOTERMS AS NAME
		SELECT DISTINCT SSP_INCOTERMS AS CODE, SSP_INCOTERMS AS NAME
		FROM  SCP_MST_BOD_V
		WHERE DIVISION_ID = @Param1
		AND   FROM_SITE = @Param2
		AND   TO_SITE = @Param3
		ORDER BY SSP_INCOTERMS
	END

/*===============================================
	용		 도:  SSP16LocTransMode
	사 용 화 면:  SSP0016 - Shipment Request(Small)에서 사용
	변       수:  @PARAM1 = division_id, @PARAM2 = from_site, @PARAM3 = to_site, @PARAM4 = incoterms
	최 초 작 성:  2019. 03. 13
	개  발  자 :  YWHOON
	최 종 작 성:  2019. 03. 13
	수  정  자 :
	수 정 사 항:  [PJ20189106] 전지.GSCM 고도화 이행- 소형 추가
	             2020/09/21   KIMYONGHO     SSP INCOTERMS 변경 작업
	===============================================*/
ELSE IF @Code = 'SSP16LocTransMode'
	BEGIN
		SELECT TRANSPORT_MODE+':'+BOD_ID+':'+convert(nvarchar,ROUTE_ID)+':'+convert(nvarchar,LT_TOTAL) as CODE , TRANSPORT_MODE AS NAME
		FROM   SCP_MST_BOD_V
		WHERE  DIVISION_ID = @Param1
		AND    FROM_SITE   = @Param2
		AND    TO_SITE     = @Param3
		--2020/09/21   KIMYONGHO     SSP INCOTERMS 변경 작업
		--AND    INCOTERMS   = @Param4
		AND    SSP_INCOTERMS   = @Param4
		ORDER BY PRIORITY
	END


/*===============================================
	용		 도:  SSP16LocTransMode
	사 용 화 면:  SSP0016 - Shipment Request(Small)에서 사용
	변       수:  @PARAM1 = division_id, @PARAM2 = from_site
	최 초 작 성:  2019. 03. 13
	개  발  자 :  YWHOON
	최 종 작 성:  2019. 03. 13
	수  정  자 :
	수 정 사 항:  [PJ20189106] 전지.GSCM 고도화 이행- 소형 추가
	===============================================*/
ELSE IF @Code = 'SSP16LocBodTotal'
	BEGIN
		SELECT TRANSPORT_MODE+':'+BOD_ID+':'+convert(nvarchar,ROUTE_ID)+':'+convert(nvarchar,LT_TOTAL) AS CODE
				, TRANSPORT_MODE NAME
		FROM   SCP_MST_BOD_V
		WHERE  DIVISION_ID = @Param1
		AND    FROM_SITE   = @Param2
	END



/*===============================================
	용		 도:  OriginDivFromFinalItemEE
	사 용 화 면:  Production Plan Line New 입력 팝업에서 사용
	변       수:  @PARAM 없음.
	최 초 작 성:  2019. 03. 22
	개  발  자 :  YWHOON
	최 종 작 성:  2019. 03. 22
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'OriginDivFromFinalItemEE'
	BEGIN
		SELECT DISTINCT A.DIVISION_ID CODE,  A.DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME, A.ITEM_ID
		FROM SCP_MST_FINAL_ITEM A WITH(NOLOCK)
		JOIN SCM_MST_DIVISION B WITH(NOLOCK)
		ON A.DIVISION_ID=B.DIVISION_ID
		AND B.VALID_YN='Y'
		WHERE 1=1
		GROUP BY A.DIVISION_ID, A.ITEM_ID
		ORDER BY A.ITEM_ID
	END


/*===============================================
	용		 도:  LineProdPlanLinePopupAll
	사 용 화 면:  Production Plan Line New 입력 팝업에서 사용
	변       수:  @PARAM1=OPERATION_GROUP
	최 초 작 성:  2019. 03. 22
	개  발  자 :  YWHOON
	최 종 작 성:  2019. 03. 22
	수  정  자 :
	수 정 사 항:  [CSR ID:3962713]  Production Plan Line 신규 다건입력 로직 개선의 건
	              2020.02.27		ESS 외주 Pakcer Line 생산 Target 적용
				  2021.05.24		scp_mst_tact_time => SCM_MST_TACT_TIME_SN 변경 , khj79
				  2022.07.22        ISUZU 관련 수정 , lwy
	===============================================*/
ELSE IF @Code = 'LineProdPlanLinePopupAll'
	BEGIN
		SELECT
		DISTINCT
				A.LINE_ID						  AS CODE
			,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
			--,t.PLANT_SITE_ID
			,B.SCM_SITE_ID	AS plant_site_id
			,t.ITEM_ID
			,t.OPERATION_ID
			,A.DIVISION_ID
		FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
		JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID AND A.DIVISION_ID=B.DIVISION_ID
		INNER HASH JOIN  (SELECT DISTINCT b.segment4, b.segment1
						FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
						WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
						AND    b.valid_yn    = 'Y'
						AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
					) f ON a.operation_id = f.segment4 --AND c.operation_group_id = f.segment3 -- operation group id 에 추가된 operation 만보이도록
		--JOIN scp_mst_tact_time t WITH(NOLOCK) on t.division_id=A.DIVISION_ID and t.plant_site_id=b.SCM_SITE_ID and t.operation_id=A.OPERATION_ID and t.line_id=A.LINE_ID
		 JOIN ( SELECT DISTINCT X.DIVISION_ID, ITEM_ID , PLANT_ID , LINE_ID , OPERATION_ID
				  FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
				 WHERE X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
				   AND X.TACT_TIME > 0
			  ) T
		   ON T.DIVISION_ID = A.DIVISION_ID AND T.PLANT_ID = B.PLANT_ID AND T.OPERATION_ID = A.OPERATION_ID AND T.LINE_ID=A.LINE_ID
		WHERE 1=1
		AND A.ACTIVE_FLAG ='Y'
		AND  (@Param1 IS NULL OR @Param1='' OR b.OPERATION_GROUP = @Param1 )
		UNION
		SELECT
		DISTINCT
			A.LINE_ID						  AS CODE
			,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
			,B.PLANT_SITE_ID
			,B.ITEM_ID
			,B.OPERATION_ID
			,A.DIVISION_ID
		FROM SCM_MST_LINE_OSP A WITH(NOLOCK)
		JOIN SCM_MST_SITE S WITH(NOLOCK) ON S.DIVISION_ID=A.DIVISION_ID
											AND S.SCM_SITE_ID=A.SCM_SITE_ID
											AND S.OSP_YN='Y'
											AND ISNULL(S.ATTRIBUTE1,'N')='Y'
		JOIN SCP_MST_TACT_TIME_OSP B WITH(NOLOCK) ON A.DIVISION_ID=B.DIVISION_ID
													AND A.SCM_SITE_ID=B.PLANT_SITE_ID
													--AND B.ITEM_ID=@Param6
													AND B.VALID_YN='Y'
													AND A.LINE_ID=B.LINE_ID
		WHERE 1=1--A.DIVISION_ID=@Param1
		--AND A.SCM_SITE_ID=@Param3
		AND A.VALID_YN='Y'
		AND  (@Param1 IS NULL OR @Param1='' OR S.OPERATION_GROUP=@Param1 )

		-- 2022.07.22 Begin
		UNION

		SELECT
		DISTINCT
				A.LINE_ID						  AS CODE
			   ,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME			
			   ,B.SCM_SITE_ID	AS plant_site_id
			   ,t.ITEM_ID
			   ,t.OPERATION_ID
			   ,A.DIVISION_ID
		FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
		JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID AND A.DIVISION_ID=B.DIVISION_ID
		
		JOIN ( SELECT DISTINCT X.DIVISION_ID, X.ITEM_ID , X.PLANT_ID , X.LINE_ID , X.OPERATION_ID
			     FROM SCM_MST_TACT_TIME_SN X WITH(NOLOCK)
				 JOIN dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
					ON X.ITEM_ID = A.ITEM_ID
				   AND X.DIVISION_ID = A.DIVISION_ID
				WHERE X.MONTH >= CONVERT(VARCHAR(6),GETDATE(),112)
				  AND X.TACT_TIME > 0
			 ) T
		   ON T.DIVISION_ID = A.DIVISION_ID AND T.PLANT_ID = B.PLANT_ID AND T.OPERATION_ID = A.OPERATION_ID AND T.LINE_ID=A.LINE_ID
		WHERE 1=1
		AND A.ACTIVE_FLAG ='Y'
		AND  (@Param1 IS NULL OR @Param1='' OR b.OPERATION_GROUP = @Param1 )
		-- 2022.07.22 End

	END

/*===============================================
	용		 도:  전지재료 OPERATION_GROUP 조회 용
	사 용 화 면:  SUPPLY MASTER, SUPPLY PLAN에서 사용
	변       수:  @PARAM1=DIVISION_ID
	최 초 작 성:  2019. 03. 26
	개  발  자 :  YWHOON
	최 종 작 성:  2019. 03. 26
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'OperationGroupByDivision'
	BEGIN
		SELECT SEGMENT1 CODE
			   , SEGMENT2 NAME
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE LOOKUP_TYPE='OPERATION_GROUP'
		AND (@Param1 IS NULL OR @Param1='' OR @Param1 IN (SELECT TOKEN FROM dbo.String_Split(SEGMENT3,',')))
		AND VALID_YN='Y'
		ORDER BY DISPLAY_SEQ
	END

/*===============================================
	용		 도:  전지재료 OPERATION_ID 조회 용
	사 용 화 면:  LINE MASTER에서 사용
	변       수:
	최 초 작 성:  2019. 03. 29
	개  발  자 :  YWHOON
	최 종 작 성:  2019. 03. 29
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'OperationIdFPAll'
	BEGIN
		SELECT DIVISION_ID, SITE_ID, COMPANY_ID, OPERATION_ID, OPERATION_NAME
			   , CASE WHEN DIVISION_ID IN ('42','44') THEN SUBSTRING(OPERATION_ID, 1, 2) ELSE SUBSTRING(OPERATION_ID, 1, 1) END OPERATION_GROUP
		FROM SCM_MST_OPERATION_SN WITH(NOLOCK)
		WHERE 1=1
		AND ACTIVE_FLAG='Y'
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
			SCM_SITE_ID AS NAME
		FROM SCM_MST_SITE WITH(NOLOCK)
		WHERE DIVISION_ID = '40'--@P_DIVISION_ID
		  AND   SITE_TYPE  = 'PLANT'
		  AND   OSP_YN  = 'Y'
		  AND   VALID_YN = 'Y'
		ORDER BY SITE_DESCRIPTION
	END
/*===============================================
	용		 도:  Shipment Date Input 가능 기간
	사 용 화 면:  Shipment Change Request, Shipment Plan Adjustment, Shipment Plan
	변       수:
	최 초 작 성:  2019. 06. 18
	개  발  자 :  MCTHEJ
	최 종 작 성:  2019. 06. 18
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'SHIPMENT_PERIOD_DAY'
	BEGIN
		SELECT
			SEGMENT1 AS CODE,
			CASE WHEN SEGMENT1 = '1D+' THEN CONVERT(NVARCHAR(10), DATEADD(DAY, CONVERT(INT, SEGMENT2), GETDATE()), 120)
				 WHEN SEGMENT1 = '2D-' THEN CONVERT(NVARCHAR(10), DATEADD(DAY, CONVERT(INT, SEGMENT2) * -1, GETDATE()), 120)
			END  AS VALUE,
			SEGMENT2 AS Diff_VALUE
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE 1 = 1
		  AND LOOKUP_TYPE = 'SHIPMENT_PERIOD_DAY'
		  AND VALID_YN = 'Y'
		ORDER BY SEGMENT1
	END
/*===============================================
	용		 도:  ssp0019_TransportMode
	사 용 화 면:  Shipment Change History
	변       수:
	최 초 작 성:  2019. 06. 21
	개  발  자 :  MCTHEJ
	최 종 작 성:  2019. 06. 21
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'ssp0019_TransportMode'
	BEGIN
		SELECT
			TRANSPORT_MODE AS CODE
			, TRANSPORT_MODE AS NAME
		FROM   SCP_MST_BOD_V
		WHERE  1= 1
		AND ( (@Param1 IS NULL OR @Param1 ='') OR DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,','))   )
		--AND ( (@Param2 IS NULL OR @Param2 ='') OR FROM_SITE IN ( SELECT token FROM dbo.String_Split(@Param2,','))   )
		--AND ( (@Param3 IS NULL OR @Param3 ='') OR TO_SITE IN ( SELECT token FROM dbo.String_Split(@Param3,','))   )
		--AND ( (@Param4 IS NULL OR @Param4 ='') OR INCOTERMS IN ( SELECT token FROM dbo.String_Split(@Param4,','))   )
		AND bod_valid_yn = 'Y'
		GROUP BY TRANSPORT_MODE
	END
	   	
/*===============================================
	용		 도:  ssp0030_TransportMode
	사 용 화 면:  Shipment Change History
	변       수:
	최 초 작 성:  2022. 11. 22
	개  발  자 :  THPARK
	최 종 작 성:  2022. 11. 22
	수  정  자 :
	수 정 사 항: 신규
	===============================================*/
ELSE IF @Code = 'ssp0030_Incoterms'
	BEGIN		
		SELECT SSP_INCOTERMS AS CODE
		,SSP_INCOTERMS AS NAME
		FROM SCP_MST_BOD_V
		WHERE 1=1
		AND ( (@Param1 IS NULL OR @Param1 ='') OR DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,','))   )
		AND SSP_INCOTERMS NOT IN ('A01','CFR','CPT','DAT','DDU','EXW','FAS','FCA','Z01','Z02','Z04')
		AND bod_valid_yn = 'Y'
		GROUP BY SSP_INCOTERMS
		order by SSP_INCOTERMS
	END


/*===============================================
	용		 도:  ssp0019_Incoterms
	사 용 화 면:  Shipment Change History
	변       수:
	최 초 작 성:  2019. 06. 21
	개  발  자 :  MCTHEJ
	최 종 작 성:  2019. 06. 21
	수  정  자 :
	수 정 사 항:  2020/09/21   KIMYONGHO     SSP INCOTERMS 변경 작업
	===============================================*/
ELSE IF @Code = 'ssp0019_Incoterms'
	BEGIN
		--2020/09/21   KIMYONGHO     SSP INCOTERMS 변경 작업
		--SELECT INCOTERMS AS CODE
		--      ,INCOTERMS AS NAME
		SELECT SSP_INCOTERMS AS CODE
		,SSP_INCOTERMS AS NAME
		FROM SCP_MST_BOD_V
		WHERE 1=1
		AND ( (@Param1 IS NULL OR @Param1 ='') OR DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,','))   )
		--AND ( (@Param2 IS NULL OR @Param2 ='') OR FROM_SITE IN ( SELECT token FROM dbo.String_Split(@Param2,','))   )
		--AND ( (@Param3 IS NULL OR @Param3 ='') OR TO_SITE IN ( SELECT token FROM dbo.String_Split(@Param3,','))   )
		--AND ( (@Param4 IS NULL OR @Param4 ='') OR TRANSPORT_MODE IN ( SELECT token FROM dbo.String_Split(@Param4,','))   )
		AND bod_valid_yn = 'Y'
		GROUP BY SSP_INCOTERMS
		order by SSP_INCOTERMS
	END

/*===============================================
	용		 도:  ORIGIN_DIVISION
	사 용 화 면:  SCP Shipment Plan New
	변       수:
	최 초 작 성:  2019. 07. 03
	개  발  자 :  HWYOON
	최 종 작 성:  2019. 07. 03
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'OriginDivision'
	BEGIN
		SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)
		--WHERE DIVISION_ID NOT IN ('EE', 'EE_UC')
		WHERE DIVISION_ID NOT IN (SELECT division_id FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE attribute3 = 'EE')
		GROUP BY DIVISION_ID
		ORDER BY DIVISION_ID
	END

/*===============================================
	용		 도:  BOD ITEM
	사 용 화 면:  SCP Shipment Plan New
	변       수:
	최 초 작 성:  2019. 07. 04
	개  발  자 :  HWYOON
	최 종 작 성:  2019. 07. 04
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'BODItem'
	BEGIN
		DECLARE @Param1_c NVARCHAR(100) = @Param1;
		DECLARE @Param2_c NVARCHAR(100) = @Param2;
		DECLARE @Param3_c NVARCHAR(MAX) = @Param3;
		DECLARE @Param4_c NVARCHAR(MAX) = @Param4;
		DECLARE @Param5_c NVARCHAR(MAX) = @Param5;
		DECLARE @Param6_c NVARCHAR(MAX) = @Param6;

		SELECT *
		FROM(
				SELECT  distinct
						a.item_id as code
						,a.item_id as name
						,a.division_id
						,a.item_id
						,sf.DIVISION_ID as FROM_DIVISION_ID
						,st.division_id as TO_DIVISION_ID
				FROM scp_mst_bod_item a  with(nolock)
				INNER JOIN scp_mst_bod b  with(nolock) ON a.bod_id = b.bod_id
				INNER JOIN SCM_MST_SITE SF with(nolock) ON SF.SCM_SITE_ID=b.from_site
										   and sf.SITE_TYPE='PLANT'
										   and sf.operation_group=@Param2_c
										   and ( @Param4_c IS NULL OR @Param4_c='' OR sf.DIVISION_ID=@Param4_c )
				INNER JOIN SCM_MST_SITE ST with(nolock) ON ST.SCM_SITE_ID=b.to_site
										   and ( @Param3_c IS NULL OR @Param3_c='' OR ST.SITE_TYPE=@Param3_c )
										   and ( @Param5_c IS NULL OR @Param5_c='' OR ST.DIVISION_ID=@Param5_c )
		) a
		WHERE 1=1
			--and ( @Param1_c IN ('EE','EE_UC') OR a.division_id = @Param1_c )
			and ( @Param1_c IN (SELECT division_id FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE attribute3 = 'EE') OR a.division_id = @Param1_c )
		ORDER BY a.division_id, a.item_id
	END

/*===============================================
	용		 도:  BOD ITEM - All
	사 용 화 면:  SCP Shipment Plan New
	변       수:
	최 초 작 성:  2019. 07. 04
	개  발  자 :  HWYOON
	최 종 작 성:  2019. 07. 04
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'BODItemAll'
	BEGIN
		SELECT *
		FROM(
				SELECT  distinct
						a.division_id
						,b.from_site
						,SF.SITE_TYPE AS FROM_SITE_TYPE
						,b.to_site
						,ST.SITE_TYPE AS TO_SITE_TYPE
						,a.item_id
				FROM scp_mst_bod_item a WITH(NOLOCK)
				INNER JOIN scp_mst_bod b WITH(NOLOCK)  ON a.bod_id = b.bod_id
				INNER JOIN SCM_MST_SITE SF WITH(NOLOCK) ON SF.SCM_SITE_ID=b.from_site and sf.SITE_TYPE='PLANT' and sf.operation_group=@Param2
				INNER JOIN SCM_MST_SITE ST WITH(NOLOCK) ON ST.SCM_SITE_ID=b.to_site -- 30157
		) a
		WHERE 1=1
			--and ( @Param1 IN ('EE','EE_UC') OR a.division_id = @Param1 )
			and ( @Param1 IN (SELECT division_id FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE attribute3 = 'EE') OR a.division_id = @Param1 )
		ORDER BY a.division_id, a.item_id
	END

/*===============================================
	용		 도:  BOD ITEM - SiteMasterAll
	사 용 화 면:  SCP Shipment Plan New
	변       수:
	최 초 작 성:  2019. 07. 08
	개  발  자 :  HWYOON
	최 종 작 성:  2019. 07. 08
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'SiteMasterAll'
	BEGIN
		SELECT A.SCM_SITE_ID AS CODE
			   , A.SITE_DESCRIPTION AS NAME
		FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
			AND    A.SITE_TYPE = @Param2
			AND    A.VALID_YN  = 'Y'
			AND	   (@Param1 IS NULL OR @Param1='' OR A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,',') ) )
	END

/*===============================================
	용		 도:  BOD ITEM - ProjectCdAll
	사 용 화 면:  SCP Shipment Plan New
	변       수:
	최 초 작 성:  2019. 07. 08
	개  발  자 :  HWYOON
	최 종 작 성:  2019. 07. 08
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'ProjectCdAll'
	BEGIN
		SELECT distinct project_code as code
						, project_code as name
						, DIVISION_ID
						, SCM_SITE_ID
						, ITEM_ID
		FROM SCM_MST_SITE_ITEM WITH(NOLOCK)
		WHERE 1=1
		AND (@Param1 IS NULL OR @Param1='' OR DIVISION_ID=@Param1)
		AND (@Param2 IS NULL OR @Param2='' OR SCM_SITE_ID=@Param2)
		AND (@Param3 IS NULL OR @Param3='' OR ITEM_ID=@Param3)
	END

/*===============================================
	용		 도:  Plan UnFix - PlanExecYn
	사 용 화 면:  SCP Plan Unfix
	변       수:
	최 초 작 성:  2019. 07. 26
	개  발  자 :  HWYOON
	최 종 작 성:  2019. 07. 26
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'PlanExecYn'
	BEGIN
		SELECT TOP(1) D.MODELING_ID, D.DIVISION_ID, D.PLAN_ID, D.PLAN_SEQ, D.PLAN_TYPE, D.PLAN_STATUS
		FROM scm_mst_modeling M with(nolock),
		scm_mst_plan_detail d with(nolock),
		scm_mst_plan        p with(nolock),
		SCM_ADM_LOOKUP_MASTER_DETAIL c with(nolock)
		WHERE M.PLAN_CYCLE    = 'WEEKLY'
		AND M.DIVISION_ID = @Param1
		and m.MODELING_ID   = d.MODELING_ID
		and m.DIVISION_ID   = d.DIVISION_ID
		and p.DIVISION_ID   = d.DIVISION_ID
		and p.PLAN_CYCLE    = m.PLAN_CYCLE
		and p.PLAN_ID       = d.PLAN_ID
		and d.division_id = @Param1
		and d.plan_type not in ('TE','TM')
		and c.lookup_type='PLAN_TYPE'
		and c.valid_yn='Y'
		and c.segment1=d.plan_type
		ORDER BY p.plan_name DESC, C.display_seq DESC,D.PLAN_SEQ DESC
	END
/*===============================================
	용		 도:  Divison에 따른 Compnay ID Load
	사 용 화 면:  SSP0021 Shipment Plan
	변       수:
	최 초 작 성:  2019. 08. 23
	개  발  자 :  mcTheJ
	최 종 작 성:  2019. 09. 04
	수  정  자 :  mcTheJ
	수 정 사 항:  BLANK 삭재
	===============================================*/
ELSE IF @Code = 'Div_Company'
	BEGIN
		SELECT
			S.COMPANY_ID AS CODE, D.SEGMENT2 AS NAME, S.DIVISION_ID
		FROM SCM_MST_SITE S WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
			ON S.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'COMPANY_DESC'
		WHERE 1 = 1
		AND S.SITE_TYPE = 'PLANT'
		--AND S.VALID_YN = 'Y'			-- NERP 추가
		AND (@Param1 IS NULL OR @Param1='' OR DIVISION_ID=@Param1)
		GROUP BY S.COMPANY_ID, D.SEGMENT2, S.DIVISION_ID;
	END
/*===============================================
	용		 도:  Company에 따른 From_Site Load
	사 용 화 면:  SSP0021 Shipment Plan
	변       수:
	최 초 작 성:  2019. 08. 23
	개  발  자 :  mcTheJ
	최 종 작 성:  2019. 08. 23
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'Com_FromSite'
	BEGIN
		--[NERP]COMPANY 예외적용 시작--NERP (IT20250117A)
		INSERT INTO @exception_company (company_id) select SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
				where 1=1
				AND lookup_type = 'SSP_UI_EXCEPT_COMPANY'
				AND VALID_YN = 'y'
		--[NERP]COMPANY 예외적용 끝--NERP (IT20250117A)
		SELECT
			S.SCM_SITE_ID AS CODE, S.SITE_DESCRIPTION AS NAME
		FROM SCM_MST_SITE S WITH(NOLOCK)
		WHERE 1 = 1
		AND S.SITE_TYPE = 'PLANT'
		AND S.OPERATION_GROUP <> 'E'
		AND (@Param1 IS NULL OR @Param1='' OR S.DIVISION_ID=@Param1)
		AND (@Param2 IS NULL OR @Param2='' OR S.COMPANY_ID=@Param2)
		AND not exists (select 1 from @exception_company K where @Param2 = K.company_id)--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		;
	END
/*===============================================
	용		 도:  Cutoff에 따른 Company별 Plan 정보
	사 용 화 면:  SSP0021 Shipment Plan
	변       수:
	최 초 작 성:  2019. 08. 23
	개  발  자 :  mcTheJ
	최 종 작 성:  2019. 08. 23
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'Plan_Infor'
	BEGIN
		SELECT TOP 50
			REPLACE(PLAN_START_YYYYMMDD, '-', '')  AS CODE
		  , CONVERT(NVARCHAR(10), CONVERT(DATE, PLAN_START_YYYYMMDD,23))  AS NAME
		  , CONVERT(NVARCHAR(10),CONVERT(DATE, PLAN_START_YYYYMMDD, 23)) AS FROM_DATE
		  , DATEADD(DD, 55, CONVERT(NVARCHAR(10),CONVERT(DATE, PLAN_START_YYYYMMDD, 23))) AS TO_DATE
		  , DATEADD(DD, 14, CONVERT(NVARCHAR(10), CONVERT(DATE, PLAN_START_YYYYMMDD, 23))) AS TO_DATE1 -- Ship Plan UI(WA/UC) 신규화면에서 사용
		  ,  PLAN_CUTOFF_CREATE_YN AS PLAN_YN, COMPANY_ID
		FROM [dbo].[SSP_MST_SHIP_PLAN_SCHEDULE] WITH(NOLOCK)
		WHERE 1= 1
		  AND ERP_STOCK_CUTOFF_YN = 'Y'
		  AND OWMS_STOCK_CUTOFF_YN = 'Y'
		  AND CURRENT_PLAN_DATE_YN = 'Y'
		  AND (@Param1 IS NULL OR @Param1='' OR COMPANY_ID=@Param1)
		GROUP BY PLAN_START_YYYYMMDD, PLAN_CUTOFF_CREATE_YN, COMPANY_ID
		ORDER BY CONVERT(DATETIME, PLAN_START_YYYYMMDD,23) DESC;
	END
/*===============================================
	용		 도:  BODItemProjectRoute - SCP Shipment Request
	사 용 화 면:  SCP Shipment Request
	변       수:
	최 초 작 성:  2019. 08. 26
	개  발  자 :  HWYOON
	최 종 작 성:  2020. 11. 27
	수  정  자 :  khj79
	수 정 사 항:  불필요 조인 제거
	===============================================*/
ELSE IF @Code = 'BODItemProjectRoute'
	BEGIN
		SELECT  DISTINCT
				a.ITEM_ID CODE
				,a.ITEM_ID NAME
		FROM scp_mst_bod_item a WITH(NOLOCK)
		INNER JOIN scp_mst_bod b WITH(NOLOCK) ON a.bod_id = b.bod_id AND B.incoterms='DAP'
		--INNER JOIN scp_mst_distribution_route c WITH(NOLOCK) ON b.route_id = c.route_id  //불필요 조인 제거
		INNER HASH JOIN scm_mst_site sf WITH(NOLOCK) on sf.scm_site_id=b.from_site and sf.valid_yn='Y' and sf.operation_group=@Param2
		INNER HASH JOIN scm_mst_site st WITH(NOLOCK) on st.scm_site_id=b.TO_SITE and st.valid_yn='Y' and st.SITE_TYPE='PLANT'
		WHERE A.DIVISION_ID=@Param1
		AND EXISTS (SELECT 'X'
					FROM SCM_MST_SITE_ITEM_PRIORITY P WITH(NOLOCK)
					WHERE P.DIVISION_ID=A.DIVISION_ID
					AND P.PLANT_SITE_ID=B.FROM_SITE
					AND P.ITEM_ID=A.ITEM_ID
					AND P.VALID_YN='Y')
		order by item_id
	END
/*===============================================
	용		 도:  MyCompanyID
	사 용 화 면:  Sipment Plan
	변       수:  User ID
	최 초 작 성:  2019. 09. 04
	개  발  자 :  mcThe J
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
	*20201207 KIMYONGHO SCM_MST_SSO_USER_INFO LGES 사용자 COMPANY 정보 변경(B100 -> C100 )으로 긴급 변경  Reqeust by 정인천 팀장
	===============================================*/
	ELSE IF @Code = 'MyCompanyID'
	BEGIN
		SELECT TOP 1
			S.COMPANY_ID AS CODE, D.SEGMENT2 AS NAME
		FROM SCM_MST_SITE S WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
			ON S.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'COMPANY_DESC'
		INNER JOIN SCM_MST_SSO_USER_INFO U WITH(NOLOCK)
--			ON S.COMPANY_ID = CASE WHEN  U.COMPANY_ID = 'B100' THEN 'C100' ELSE U.COMPANY_ID END
			ON S.COMPANY_ID = CASE WHEN  U.COMPANY_ID = @v_B100 THEN @v_C100 ELSE U.COMPANY_ID END
		WHERE 1 = 1
		AND S.SITE_TYPE = 'PLANT'
		AND (@Param1 IS NULL OR @Param1='' OR U.USER_ID=@Param1)
		GROUP BY S.COMPANY_ID, D.SEGMENT2, S.DIVISION_ID;
	END
/*===============================================
 용   도:  DIVISION  조회
 사 용 화 면:  Shipment Plan 결과 조회화면  - 조회조건
 변       수:  Param1 = GroupID, Param2 = UserID
 최 초 작 성:  2019. 09. 04
 개  발  자 :  mcThe J
 최 종 작 성:
 수  정  자 :
 수 정 사 항:
 ===============================================*/

 ELSE IF (@Code = 'MyDivisionOut40' )
	 BEGIN
	 -- 20220418   SMS	가상디비젼 관련 수정... 
		 -- SELECT DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME
			--FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)
		 --  WHERE DIVISION_ID IN (SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = 'D')
		 --  AND DIVISION_ID != '40'
		 --  GROUP BY DIVISION_ID
		 --  ORDER BY DIVISION_ID

		Declare @AuthTypeParaDivisionOut40 varchar(100) = 'D'		   
		if(@Param1 = 'JV Planner') SET @AuthTypeParaDivisionOut40 = 'J';

		  SELECT DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME
			FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)
		   WHERE DIVISION_ID IN (SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = @AuthTypeParaDivisionOut40)
--		   WHERE DIVISION_ID IN (SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = 'D')
		   AND DIVISION_ID != '40' 
		   -- 220614 jilee  EE Division 목록 제외
		   AND ATTRIBUTE3 != 'EE'
		   GROUP BY DIVISION_ID
		   ORDER BY DIVISION_ID
	 END

/*===============================================
	용		 도:  AllInputModelAllocation - SCP Model Allocation
	사 용 화 면:  Model Allocation
	변       수:
	최 초 작 성:  2019. 09. 09
	개  발  자 :  HWYOON
	최 종 작 성:  2019. 09. 09
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'AllInputModelAllocation'
	BEGIN
		SELECT DISTINCT P.DIVISION_ID
					,P.ITEM_ID
					,P.PLANT_SITE_ID
					,S.SITE_DESCRIPTION
					,LS.LINE_ID
			FROM SCM_MST_SITE_ITEM_PRIORITY P (NOLOCK)
			JOIN SCM_MST_SITE S (NOLOCK) ON P.DIVISION_ID = S.DIVISION_ID
										AND S.OPERATION_GROUP=@Param2
										AND P.PLANT_SITE_ID = S.SCM_SITE_ID
			JOIN SCM_MST_LINE_SN LS (NOLOCK) ON LS.COMPANY_ID = S.COMPANY_ID
											AND LS.DIVISION_ID = S.DIVISION_ID
											AND LS.PLANT_ID = S.PLANT_ID
											AND LS.SITE_ID = S.SITE_ID
											AND LS.ACTIVE_FLAG='Y'
			WHERE 1=1
			ORDER BY P.ITEM_ID, P.PLANT_SITE_ID, LS.LINE_ID
	END
/*===============================================
 용   도:  Container_Size
 사 용 화 면:  SSP0021 Shipment Plan 결과 조회화면  - 조회조건
 변       수:
 최 초 작 성:  2019. 09. 23
 개  발  자 :  mcThe J
 최 종 작 성:
 수  정  자 :
 수 정 사 항: 2019.11.05 LJH CMI법인(G380)은 TRUCK 그외 SEA
 ===============================================*/
 ELSE IF (@Code = 'Container_Size' )
	 BEGIN
		SELECT
			DIVISION_ID, FROM_SITE, ITEM_ID, ISNULL(MAX(LOT_SIZE), 0) AS Container_Qty
		FROM scp_mst_shipment_lot_size WITH(NOLOCK)
		WHERE 1 = 1
		AND VALID_YN = 'Y'
		-- CMI법인(G380)은 TRUCK 그외 SEA
		AND TRANSPORT_MODE = CASE WHEN FROM_SITE IN ('G382-A','G382-P') THEN 'TRK' ELSE 'SEA' END
		GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID
	 END


/*===============================================
 용		  도:  Plant Site OSP
 사 용 화 면: Operation LT
 변       수:  -
 최 초 작 성:  2019. 11. 12
 개  발  자 :  hwyoon
 최  종 작 성:  -
 수  정  자 :  -
 수 정 사 항:
===============================================*/
 ELSE IF @Code = 'PlantByDivisionOperOsp'
	BEGIN
		SELECT A.SCM_SITE_ID AS CODE
			, A.SITE_DESCRIPTION AS NAME
		FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
		AND    A.SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		ANd    A.OSP_YN = 'Y'
		AND    A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
		AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )
	END;

/*===============================================
 용		  도:  Plant Site OSP
 사 용 화 면: Operation LT
 변       수:  -
 최 초 작 성:  2019. 11. 12
 개  발  자 :  hwyoon
최  종 작 성:  -
 수  정  자 :  -
 수 정 사 항:
===============================================*/
 ELSE IF @Code = 'PlantByDivisionOperOsp2'
	BEGIN
		SELECT A.SCM_SITE_ID AS CODE
			--, A.SCM_SITE_ID + '   '+A.SITE_DESCRIPTION AS NAME
			, A.SITE_DESCRIPTION AS NAME
			, A.OSP_YN
			, A.OPERATION_GROUP
			, A.DIVISION_ID
		FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
		AND    A.SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		ANd    A.OSP_YN = 'Y'
		AND    A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
		AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )
	END;

/*===============================================
 용		  도:  SCP KPI TARGET
 사 용 화 면: KPI Target
 변       수:  -
 최 초 작 성:  2019. 12. 19
 개  발  자 :  hwyoon
 최  종 작 성:  -
 수  정  자 :  -
 수 정 사 항:
===============================================*/
 ELSE IF @Code = 'SCPKPI'
	BEGIN
		SELECT A.SEGMENT1 AS KPI_ID
				, A.SEGMENT2 AS KPI_NM
				, A.SEGMENT3 AS DIVISION_ID
				, A.SEGMENT4 AS DEPT_ID
				, A.DISPLAY_SEQ
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
		WHERE A.LOOKUP_TYPE='SCM_KPI_GOAL'
		AND A.VALID_YN='Y'
		ORDER BY A.SEGMENT1, A.SEGMENT3, A.DISPLAY_SEQ
	END;

/*===============================================
 용		  도: Line Master
 사 용 화 면: Line Master
 변       수:  -
 최 초 작 성:  2020. 01. 20
 개  발  자 :  hwyoon
 최  종 작 성:  -
 수  정  자 :  -
 수 정 사 항:
===============================================*/
 ELSE IF @Code = 'LineByPlantPacker'
	BEGIN
		SELECT LINE_ID AS CODE
				, LINE_NAME AS NAME
				, DIVISION_ID
				, SCM_SITE_ID
		FROM SCM_MST_LINE_OSP WITH(NOLOCK)
		WHERE 1=1
		AND  ( ( @Param1 IS NULL OR  @Param1='' ) OR  DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')) )
		AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  SCM_SITE_ID IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )
		AND ISNULL(VALID_YN,'Y')='Y'
	END;

/*===============================================
 용		  도: Plant Site OSP(라인지정 Plant 조회)
 사 용 화 면: Line Master
 변       수:  -
 최 초 작 성:  2020. 01. 22
 개  발  자 :  hwyoon
 최  종 작 성:  -
 수  정  자 :  -
 수 정 사 항:
===============================================*/
 ELSE IF @Code = 'PlantByDivisionOperOsp3'
	BEGIN
		SELECT A.SCM_SITE_ID AS CODE
			, A.SITE_DESCRIPTION AS NAME
			, A.OSP_YN
			, A.OPERATION_GROUP
			, A.DIVISION_ID
			, A.PLANT_ID AS OPERATION_ID
		FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
		AND    A.SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		ANd    A.OSP_YN = 'Y'
		AND    A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
		AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )
		AND  ( ( @Param3 IS NULL OR  @Param3='' ) OR  ISNULL(A.ATTRIBUTE1,'N') = @Param3 )
	END;

/*===============================================
	용		  도: 외주사 line 정보 추가
	사 용 화 면: SCP0019_WorkingTime
	변       수:  -
	최 초 작 성:  2020. 02. 05
	개  발  자 :  khj79
	최  종 작 성:  -
	수  정  자 :  -
	수 정 사 항:
===============================================*/
 ELSE IF @Code = 'LineByOperationAddOSP'
	BEGIN
		SELECT
				DISTINCT
				A.LINE_ID						  AS CODE
			, A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
			, A.OPERATION_ID
			, B.SCM_SITE_ID
			FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
			JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND  A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID
		INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1
						FROM scm_adm_lookup_master_detail b WITH(NOLOCK)
						WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
						AND    b.valid_yn    = 'Y'
						AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
					) f ON a.operation_id = f.segment4 --AND c.operation_group_id = f.segment3 -- operation group id 에 추가된 operation 만보이도록
			WHERE 1=1
			AND A.ACTIVE_FLAG ='Y'
			AND ( (@Param1 IS NULL OR @Param1 ='') OR A.DIVISION_ID IN  ( SELECT token FROM dbo.String_Split(@Param1,',')))
			AND ( (@Param2 IS NULL OR @Param2 ='') OR A.PLANT_ID IN     ( SELECT token FROM dbo.String_Split(SUBSTRING(@Param2,1,4),',')))
			AND ( (@Param3 IS NULL OR @Param3 ='') OR A.FACTORY_ID IN   ( SELECT token FROM dbo.String_Split(@Param3,',')))
			AND ( (@Param4 IS NULL OR @Param4 ='') OR A.OPERATION_ID IN ( SELECT token FROM dbo.String_Split(@Param4,',')))
			AND ( (@Param5 IS NULL OR @Param5 ='') OR B.SCM_SITE_ID IN  ( SELECT token FROM dbo.String_Split(@Param5,',')))
		UNION
		SELECT
				'-'  AS CODE
				, '-'  AS NAME
				, '-'  AS OPERATION_ID
				, '-'  AS SCM_SITE_ID
		UNION
		-- 외주
		SELECT
				DISTINCT
				A.LINE_ID						AS CODE
			, A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
			, A.OPERATION_ID
			, B.SCM_SITE_ID
			FROM [dbo].SCM_MST_LINE_OSP A WITH(NOLOCK)
			JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
		WHERE b.ATTRIBUTE1 = 'Y'
			AND ( (@Param1 IS NULL OR @Param1 ='') OR A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,',')))
			AND ( (@Param2 IS NULL OR @Param2 ='') OR B.PLANT_ID     IN ( SELECT token FROM dbo.String_Split(SUBSTRING(@Param2,1,4),',')))
			AND ( (@Param4 IS NULL OR @Param4 ='') OR A.OPERATION_ID IN ( SELECT token FROM dbo.String_Split(@Param4,',')))
			AND ( (@Param5 IS NULL OR @Param5 ='') OR B.SCM_SITE_ID  IN ( SELECT token FROM dbo.String_Split(@Param5,',')))
		
		-- 2022/08/31 start
		--ORDER BY NAME		
		UNION
		--Isuzu : P5000
		SELECT
				  DISTINCT
				  A.LINE_ID						  AS CODE
				, A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
				, A.OPERATION_ID
				, B.SCM_SITE_ID
			FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
			JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND  A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID

			WHERE 1=1
			AND A.ACTIVE_FLAG ='Y'
			AND ( (@Param1 IS NULL OR @Param1 ='') OR A.DIVISION_ID IN  ( SELECT token FROM dbo.String_Split(@Param1,',')))
			AND ( (@Param2 IS NULL OR @Param2 ='') OR A.PLANT_ID IN     ( SELECT token FROM dbo.String_Split(SUBSTRING(@Param2,1,4),',')))
			AND ( (@Param3 IS NULL OR @Param3 ='') OR A.FACTORY_ID IN   ( SELECT token FROM dbo.String_Split(@Param3,',')))
			AND ( (@Param4 IS NULL OR @Param4 ='') OR A.OPERATION_ID IN ( SELECT token FROM dbo.String_Split(@Param4,',')))
			AND ( (@Param5 IS NULL OR @Param5 ='') OR B.SCM_SITE_ID IN  ( SELECT token FROM dbo.String_Split(@Param5,',')))
			AND A.PLANT_ID = @v_G182 --'G182'
			and A.OPERATION_ID = 'P5000'

		ORDER BY NAME
		-- 2022/08/31 end

	END;

/*===============================================
 용		  도:  Sales Site
 사 용 화 면: Operation LT (VMI LT)
 변       수:  -
 최 초 작 성:  2020. 03. 10
 개  발  자 :  hwyoon
 최  종 작 성:  -
 수  정  자 :  -
 수 정 사 항:
===============================================*/
 ELSE IF @Code = 'SalesByDivision'
	BEGIN
		SELECT A.SCM_SITE_ID AS CODE
			--, A.SCM_SITE_ID + '   '+A.SITE_DESCRIPTION AS NAME
			, A.SITE_DESCRIPTION AS NAME
			, 'S' AS OSP_YN
			, '' AS OPERATION_GROUP
			, A.DIVISION_ID
		FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
		AND    A.SITE_TYPE = 'SALES'
		AND    A.VALID_YN  = 'Y'
		AND    A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
	END;
/*===============================================
	용	    도:  Cutoff에 따른 Company별 Plan 정보 (Electrode)
	사 용 화 면:  SSP0022 Shipment Request
	변       수:
	최 초 작 성:  2020-04-02
	개  발  자 :  KIMYONGHO
	최 종 작 성:  2020-04-02
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'Plan_InforElectrode'
	BEGIN
		SELECT TOP 50
			REPLACE(PLAN_START_YYYYMMDD, '-', '')  AS CODE,
			CONVERT(NVARCHAR(10), CONVERT(DATE, PLAN_START_YYYYMMDD,23))  AS NAME,
			--DATEADD(DD, @@DATEFIRST - DATEPART(dw, PLAN_START_YYYYMMDD) -5, CONVERT(DATE, PLAN_START_YYYYMMDD,23)) AS FROM_DATE, -- 이번주 월요일
			DATEADD(WK, DATEDIFF(D, 0, PLAN_START_YYYYMMDD) / 7 - 1, 0) AS FROM_DATE, -- 지난주 월요일
			DATEADD(DD, 55, CONVERT(NVARCHAR(10),CONVERT(DATE, PLAN_START_YYYYMMDD, 23))) AS TO_DATE,
			PLAN_CUTOFF_CREATE_YN AS PLAN_YN,
			COMPANY_ID
		FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE WITH(NOLOCK)
		WHERE 1= 1
		  AND CURRENT_PLAN_DATE_YN = 'Y'
		  AND (@Param1 IS NULL OR @Param1='' OR COMPANY_ID=@Param1)
		GROUP BY PLAN_START_YYYYMMDD, PLAN_CUTOFF_CREATE_YN, COMPANY_ID
		ORDER BY CONVERT(DATETIME, PLAN_START_YYYYMMDD,23) DESC;
	END
/*===============================================
	용		 도:  Company에 따른 From_Site Load
	사 용 화 면:  SSP0023 Shipment Plan(Electrode)
	변       수:
	최 초 작 성:  2020. 05. 20
	개  발  자 :  khj79
	최 종 작 성:  2020. 05. 20
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'Com_FromSitePlantEE'
	BEGIN
		SELECT
			  S.SCM_SITE_ID      AS CODE
			, S.SITE_DESCRIPTION AS NAME
		FROM SCM_MST_SITE S WITH(NOLOCK)
		WHERE 1 = 1
		AND S.SITE_TYPE = 'PLANT'
		AND S.OPERATION_GROUP = 'E'
		AND (@Param1 IS NULL OR @Param1='' OR S.DIVISION_ID=@Param1)
		AND (@Param2 IS NULL OR @Param2='' OR S.COMPANY_ID=@Param2)
		;
	END
/*===============================================
	용		 도:  Divison에 따른 Compnay ID Load ELECTRODE
	사 용 화 면:  SSP0023 Shipment Plan(Electrode)
	변       수:
	최 초 작 성:  2020. 06. 03
	개  발  자 :  khj79
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'Div_CompanyEE'
	BEGIN
		SELECT
			S.COMPANY_ID AS CODE, D.SEGMENT2 AS NAME, S.DIVISION_ID
		FROM SCM_MST_SITE S WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
			ON S.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'COMPANY_DESC'
		WHERE 1 = 1
		AND S.SITE_TYPE = 'PLANT'
		AND (@Param1 IS NULL OR @Param1='' OR DIVISION_ID=@Param1)
		AND S.OPERATION_GROUP = 'E'
		GROUP BY S.COMPANY_ID, D.SEGMENT2, S.DIVISION_ID;
	END
/*===============================================
	용		 도:  PLANT ID 를 조건으로 LINE 정보 조회
	사 용 화 면:  SCP0049
	변       수:
	최 초 작 성:  2020. 07. 17
	개  발  자 :  khj79
	수  정  자 :  khj79
	수 정 사 항:  OPERATION_ID , SCM_SITE_ID 삭제
				 후공정 라인 제외
	===============================================*/
ELSE IF @Code = 'LineByOperationPlantId'
	BEGIN
		SELECT DISTINCT
			   A.LINE_ID						AS CODE
			 , A.LINE_ID  +' ' +  A.LINE_NAME	AS NAME
		  FROM SCM_LINE_HIERARCHY_V_SN A WITH(NOLOCK)
		 WHERE NOT EXISTS (SELECT 1
							 FROM SCM_SYS_LOOKUP_VALUE_SN B WITH(NOLOCK)
							WHERE B.LOOKUP_TYPE_CODE = 'CAPA_UI_EXCEPT_LINE'
							  AND B.ACTIVE_FLAG		= 'Y'
							  AND A.DIVISION_ID		= B.SEGMENT1
							  AND A.PLANT_ID		= B.SEGMENT2
							  AND A.LINE_ID			= B.SEGMENT4
							  AND A.OPERATION_ID	= B.SEGMENT3
							  AND A.ELECTRODE_TYPE	= B.SEGMENT5
							)
		   AND ( (@Param1 IS NULL OR @Param1 ='') OR A.DIVISION_ID			IN ( SELECT token FROM dbo.String_Split(@Param1,',')))
		   AND ( (@Param2 IS NULL OR @Param2 ='') OR A.PLANT_ID				IN ( SELECT token FROM dbo.String_Split(@Param2,',')))
		   AND ( (@Param3 IS NULL OR @Param3 ='') OR A.FACTORY_ID			IN ( SELECT token FROM dbo.String_Split(@Param3,',')))
		   AND ( (@Param4 IS NULL OR @Param4 ='') OR A.OPERATION_GROUP_ID	IN ( SELECT token FROM dbo.String_Split(@Param4,',')))
		ORDER BY A.LINE_ID
	END
 /*===============================================
 용   도:  All Plant Site + Description 조회
 사 용 화 면:  SCP0010 Shipment Plan Semi
 변       수:
 최 초 작 성:  2020. 07. 27
 개  발  자 :  khj79
 최 종 작 성:  2020. 07. 27
 수  정  자 :  khj79
 수 정 사 항:
 ===============================================*/
  ELSE IF @Code = 'AllPlantSiteDescription'
	BEGIN
		  SELECT A.SCM_SITE_ID		AS CODE
			   , A.SCM_SITE_ID + '   '+A.SITE_DESCRIPTION AS NAME
			   , A.DIVISION_ID
			   , A.OPERATION_GROUP
			FROM [dbo].[SCM_MST_SITE] A WITH(NOLOCK)
		   WHERE 1=1
		     AND VALID_YN  = 'Y'
	 END

/*===============================================
	용	    도:  Cutoff에 따른 Company별 Plan 정보 (Packer)
	사 용 화 면:  SSP0026 Shipment Request
	변       수:
	최 초 작 성:  2020-08-03
	개  발  자 :  KIMYONGHO
	최 종 작 성:  2020-11-02
	수  정  자 :  KIMYONGHO
	수 정 사 항:  CONFIRM_DAY 추가
	===============================================*/
ELSE IF @Code = 'Plan_InforPacker'
	BEGIN
		SELECT TOP 50
			REPLACE(sysdatetime(), '-', '')  AS CODE,
			CONVERT(NVARCHAR(10), CONVERT(DATE, sysdatetime(),23))  AS NAME,
			CONVERT(NVARCHAR(10),CONVERT(DATE,DATEADD(DD, @@DATEFIRST - DATEPART(dw, sysdatetime()) -5, CONVERT(DATE, sysdatetime(),23)),23),23) AS FROM_DATE, -- 이번주 월요일
			--DATEADD(WK, DATEDIFF(D, 0, PLAN_START_YYYYMMDD) / 7 - 1, 0) AS FROM_DATE, -- 지난주 월요일
			DATEADD(DD, 55, CONVERT(NVARCHAR(10),CONVERT(DATE, sysdatetime(), 23))) AS TO_DATE,
			CONVERT(NVARCHAR(10), DATEADD(D, -DAY(GETDATE()-1),GETDATE()),23) AS FIRST_DATE,
			CONVERT(NVARCHAR(10), DATEADD(DAY, 20, GETDATE()), 120) AS CONFIRM_DAY
	END
/*===============================================
	용		 도:  version id 정보 조회
	사 용 화 면:  SCP0049
	변       수:
	최 초 작 성:  2020. 08. 26
	개  발  자 :  khj79
	수  정  자 :  khj79
	수 정 사 항:  division 조건 추가 , 조회 조건 수정, VERSION_NAME 추가 , SCP_USE_FLAG 조건 추가
	===============================================*/
ELSE IF @Code = 'MDMVersionId'
	BEGIN
		SELECT TOP 30 CODE , NAME
		 FROM (
			SELECT DISTINCT VERSION_ID	AS CODE
				 , VERSION_ID	+ '  ' + VERSION_NAME		AS NAME
			 FROM SCM_MASTER_VERSION_INFO_H_SN A WITH(NOLOCK)
			  WHERE 1 = 1
			  AND (DIVISION_ID = 'EE' OR DIVISION_ID = @Param1 )
			  AND ( (@Param3 IS NULL or @Param3='') OR A.SCP_USE_FLAG IN ( SELECT token FROM dbo.String_Split(@Param3,','))  )
			  ) A
	    ORDER BY CODE DESC
	END
/*===============================================
	용		 도:  Building(factory) 정보 조회 shop_group_id
	사 용 화 면:  SCP0049
	변       수:
	최 초 작 성:  2020. 09. 10
	개  발  자 :  khj79
	수  정  자 :  khj79
	수 정 사 항:  SHOP_GROUP_ID 의 조건이  'F'를 'A'로 치환한다
	===============================================*/
ELSE IF @Code = 'BuildingByShopGroupId'
	BEGIN
		SELECT
			  DISTINCT
					A.FACTORY_ID    AS CODE
				  , A.FACTORY_NAME  AS NAME
			 FROM  [dbo].[SCM_MST_FACTORY_SN] A WITH(NOLOCK)
			 WHERE 1=1
			    AND ISNULL(A.ACTIVE_FLAG,'N') = 'Y'
				AND ( (@Param1 IS NULL or @Param1='') OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,','))  )
				AND ( (@Param2 IS NULL or @Param2='') OR A.PLANT_ID IN ( SELECT token FROM dbo.String_Split(@Param2,','))  )
				AND ( (@Param3 IS NULL or @Param3='') OR A.SHOP_GROUP_ID IN ( SELECT CASE WHEN TOKEN = 'F' THEN 'A' ELSE TOKEN end FROM dbo.String_Split(@Param3,','))  )
	END
	/*===============================================
	용		 도:  shop_group_id 조회
	사 용 화 면:  SCP0049
	변       수:
	최 초 작 성:  2020. 09. 10
	개  발  자 :  khj79
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'ShopGroupId'
	BEGIN
		SELECT DISTINCT
		       SHOP_GROUP_ID   AS CODE
		     , OPERATION_GROUP AS NAME
          FROM SCM_SITE_HIERARCHY_V_SN A WITH(NOLOCK)
		  WHERE 1 = 1
		  AND ( (@Param1 IS NULL or @Param1='') OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,','))  )
	END
/*===============================================
	용		 도:  plant 조회
	사 용 화 면:  SCP0049
	변       수:
	최 초 작 성:  2020. 09. 10
	개  발  자 :  khj79
	수  정  자 :  khj79
	수 정 사 항:  SHOP_GROUP_ID 파라미터 수정
	===============================================*/
ELSE IF @Code = 'PlantByGroup'
	BEGIN
		SELECT DISTINCT
		       PLANT_ID   AS CODE
		     , PLANT_NAME AS NAME
          FROM SCM_SITE_HIERARCHY_V_SN A WITH(NOLOCK)
		  WHERE 1 = 1
		  AND ( (@Param1 IS NULL or @Param1='') OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,','))  )
		  AND ( (@Param2 IS NULL or @Param2='') OR A.SHOP_GROUP_ID IN ( SELECT token FROM dbo.String_Split(@Param2,','))  )
	END
/*===============================================
	용		 도:  line 조회
	사 용 화 면:  SCP0051
	변       수:
	최 초 작 성:  2020. 12. 22
	개  발  자 :  khj79
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'LineProdPlanTarget'
	BEGIN
		SELECT DISTINCT
			   A.LINE_ID						  AS CODE
			 , A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
		  FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
		  JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID
		 INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1
					    FROM scm_adm_lookup_master_detail b WITH(NOLOCK)
					   WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
						 AND b.valid_yn    = 'Y'
						 AND b.segment3    = 'Y' -- Capa 세부 공정 여부
					) f ON a.operation_id = f.segment4 --AND c.operation_group_id = f.segment3 -- operation group id 에 추가된 operation 만보이도록
		  JOIN scp_mst_tact_time t WITH(NOLOCK) on t.division_id=@Param1 and t.plant_site_id=b.SCM_SITE_ID and t.item_id=@Param5 and t.operation_id=@Param4 and t.line_id=A.LINE_ID
		 WHERE 1=1
		   AND A.ACTIVE_FLAG ='Y'
		   AND (@Param1='' OR @Param1 IS NULL OR A.DIVISION_ID=@Param1)
		   AND A.OPERATION_ID = @Param4
		   AND (@Param2='' OR @Param2 IS NULL OR b.OPERATION_GROUP = @Param2 )
		   AND b.SCM_SITE_ID = @Param3
	END
/*===============================================
	용		 도:  line 전체 조회
	사 용 화 면:  SCP0051
	변       수:
	최 초 작 성:  2020. 12. 22
	개  발  자 :  khj79
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'LineProdPlanTargetAll'
	BEGIN
		SELECT
		DISTINCT
				A.LINE_ID						  AS CODE
			,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
			,t.PLANT_SITE_ID
			,t.ITEM_ID
			,t.OPERATION_ID
			,A.DIVISION_ID
		FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
		JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID AND A.DIVISION_ID=B.DIVISION_ID
		INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1
						FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
						WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
						AND    b.valid_yn    = 'Y'
						AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
					) f ON a.operation_id = f.segment4 --AND c.operation_group_id = f.segment3 -- operation group id 에 추가된 operation 만보이도록
		JOIN scp_mst_tact_time t WITH(NOLOCK) on t.division_id=A.DIVISION_ID and t.plant_site_id=b.SCM_SITE_ID and t.operation_id=A.OPERATION_ID and t.line_id=A.LINE_ID
		WHERE 1=1
		AND A.ACTIVE_FLAG ='Y'
		AND B.OSP_YN = 'N'
	END
/*===============================================
	용		 도:  pancake 별 assign 가능 line 및 lane qty 정보 조회
	사 용 화 면:  SCP0049
	변       수:
	최 초 작 성:  2021. 01. 21
	개  발  자 :  khj79
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'LaneQtyOfLineAssign'
	BEGIN

		SELECT CONVERT(INT,B.LANE_QTY) AS CODE
			 , CONVERT(INT,B.LANE_QTY) AS NAME
			 , A.COMPANY_ID
			 , A.DIVISION_ID
			 , A.SITE_ID
			 , A.ITEM_ID
			 , B.PROD_VERSION_TYPE
			 , C.LINE_ID
			 , C.ELECTRODE_TYPE
			 , C.OPERATION_ID
		  FROM SCM_ITEM_M_SN A WITH(NOLOCK)
			 , SCM_ITEM_LANE_M_SN B WITH(NOLOCK)
			 , SCM_LINE_M_SN C WITH(NOLOCK)
		 WHERE A.ACTIVE_FLAG 		= 'Y'
		   AND B.ACTIVE_FLAG 		= 'Y'
		   AND C.ACTIVE_FLAG 		= 'Y'
		   AND A.COMPANY_ID 		= B.COMPANY_ID
		   AND A.DIVISION_ID 		= B.DIVISION_ID
		   AND A.SITE_ID 			= B.SITE_ID
		   AND A.ITEM_ID 			= B.ITEM_ID
		   AND A.COMPANY_ID 		= C.COMPANY_ID
		   AND A.DIVISION_ID 		= C.DIVISION_ID
		   AND A.SITE_ID 			= C.SITE_ID
		   AND B.FACTORY_ID 		= C.FACTORY_ID
		   AND B.PROD_VERSION_TYPE	= C.PROD_VERSION_TYPE
		   AND (LEFT(A.FLOW_ID,5) 				= C.OPERATION_ID
   				 OR SUBSTRING(A.FLOW_ID,6,5) 	= C.OPERATION_ID
   				 OR SUBSTRING(A.FLOW_ID,11,5) 	= C.OPERATION_ID
   				 OR SUBSTRING(A.FLOW_ID,16,5) 	= C.OPERATION_ID
   				 OR SUBSTRING(A.FLOW_ID,12,5) 	= C.OPERATION_ID)

		 ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID
				, B.LANE_QTY, B.PROD_VERSION_TYPE
				, C.LINE_ID, C.ELECTRODE_TYPE
	END

/*===============================================
	용		 도:  Cutoff에 따른 Plan 정보
	사 용 화 면:  SSP0027 Purchasing PSI(ESS)
	변       수:
	최 초 작 성:  2021. 03. 25
	개  발  자 :  KIMYONGHO
	최 종 작 성:  2021. 03. 25
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'Plan_Infor_ESS'
	BEGIN
		SELECT DISTINCT REPLACE(PLAN_START_YYYYMMDD, '-', '')  AS CODE, CONVERT(NVARCHAR(10), CONVERT(DATE, PLAN_START_YYYYMMDD,23))  AS NAME, CONVERT(NVARCHAR(10),CONVERT(DATE, PLAN_START_YYYYMMDD, 23)) AS FROM_DATE, DATEADD(DD, 84, CONVERT(NVARCHAR(10),CONVERT(DATE, PLAN_START_YYYYMMDD, 23))) AS TO_DATE
		FROM
		(
			SELECT  ATTRIBUTE1 AS PLAN_START_YYYYMMDD
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL AS X WITH(NOLOCK)
			WHERE X.LOOKUP_TYPE	= 'SSP_ANL_ESS_PLAN'
			AND X.SEGMENT1		= '82'

			UNION ALL

			SELECT DISTINCT PLAN_START_YYYYMMDD
			FROM SSP_ANL_ESS_PLAN WITH(NOLOCK)
		) T0
		ORDER BY REPLACE(PLAN_START_YYYYMMDD, '-', '') DESC;
	END

 /*===============================================
	용		 도:  제품 구분(ItemExtraSpec) 조회
	사 용 화 면:  SCP0056_MPP_Result_Mgmt.cs
	변       수:
	최 초 작 성:  2021. 05. 06
	개  발  자 :  PJG
	최 종 작 성:  2021. 07. 15
	수  정  자 :  KDW
	수 정 사 항:  공정추가
	===============================================*/
ELSE IF @Code = 'ItemExtraSpec'
	BEGIN
		IF @Param1 ='40'
			SELECT DISTINCT SCP_EXTRA_SPEC AS CODE, SCP_EXTRA_SPEC AS  NAME
			FROM SCM_MST_ITEM_SN AS A WITH (NOLOCK)
			INNER JOIN (
							SELECT SITE_ID FROM SCM_MST_SITE WITH (NOLOCK)
							WHERE  ((@Param2 IS NULL OR @Param2	='') OR PLANT_ID IN ( SELECT token FROM dbo.String_Split(@Param2, ',')))
					  		AND    ((@Param3 IS NULL OR @Param3	='') OR OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param3, ',')))
					   )B ON A.SITE_ID IN (B.SITE_ID)
			WHERE  1=1
			AND    A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1, ','))
			--AND    ((@Param3 IS NULL OR @Param3	='') OR A.ITEM_TYPE IN ( SELECT token FROM dbo.String_Split(@Param3, ',')))
			AND    A.SCP_EXTRA_SPEC IS NOT NULL
			AND    A.SCP_EXTRA_SPEC <> ''
			AND    A.FLOW_ID in (SELECT token FROM dbo.String_Split(@Param4, ',')) -- 공정조건 추가
			ORDER BY A.SCP_EXTRA_SPEC;
		ELSE
		SELECT '-'  AS CODE,'-'  AS NAME
	END

 /*===============================================
	용		 도:  형태 구분(ItemClass) 조회
	사 용 화 면:  SCP0056_MPP_Result_Mgmt.cs
	변       수:
	최 초 작 성:  2021. 05. 06
	개  발  자 :  PJG
	최 종 작 성:  2021. 07. 15
	수  정  자 :  KDW
	수 정 사 항:  공정추가
	===============================================*/
ELSE IF @Code = 'ItemClass'
	BEGIN
		IF @Param1 ='40'
			SELECT DISTINCT ITEM_CLASS_NAME AS CODE, ITEM_CLASS_NAME AS NAME
			FROM   SCM_MST_ITEM_SN A WITH (NOLOCK)
			INNER JOIN (
							SELECT SITE_ID FROM SCM_MST_SITE WITH (NOLOCK)
							WHERE  ((@Param2 IS NULL OR @Param2	='') OR PLANT_ID IN ( SELECT token FROM dbo.String_Split(@Param2, ',')))
					  		AND    ((@Param3 IS NULL OR @Param3	='') OR OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param3, ',')))
					   )B ON A.SITE_ID IN (B.SITE_ID)
			WHERE  1=1
			AND    DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1, ','))
			--AND    ((@Param3 IS NULL OR @Param3	='') OR A.ITEM_TYPE IN ( SELECT token FROM dbo.String_Split(@Param3, ',')))
			AND    A.ITEM_CLASS IS NOT NULL
			AND    A.ITEM_CLASS <> ''
			AND    A.ITEM_CLASS_NAME IS NOT NULL
			AND    A.ITEM_CLASS_NAME <> ''
			AND    A.FLOW_ID in (SELECT token FROM dbo.String_Split(@Param4, ',')) -- 공정조건 추가
			AND    A.SCP_EXTRA_SPEC in (SELECT token FROM dbo.String_Split(@Param5, ',')) -- EXTRA_SPEC 조건추가
			ORDER BY A.ITEM_CLASS_NAME;
		ELSE
			SELECT '-'  AS CODE,'-'  AS NAME
	END

 /*===============================================
	용		 도:  MPP 사유관리 화면 Operation ID 조회
	사 용 화 면:  SCP0056_MPP_Result_Mgmt.cs
	변       수:
	최 초 작 성:  2021. 06. 23
	개  발  자 :  PJG
	최 종 작 성:  2021. 06. 23
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'OperationForMPP'
	BEGIN
		SELECT DISTINCT SEGMENT2 AS CODE, SEGMENT4 AS NAME
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
         WHERE LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
   AND SEGMENT3    = 'Y'
           AND VALID_YN    = 'Y'
           AND SEGMENT4 <> 'E2000'
        ORDER BY SEGMENT4;
	END

 /*===============================================
	용		 도:  Division별 Plan 수립 대상 Operation 조회 (Electrode 제외)
	사 용 화 면:  SCP0080_GroupCodeManagement.cs
	변       수:  @Param1 = DIVISION_ID
	최 초 작 성:  2021. 08. 20
	개  발  자 :  kmj
	최 종 작 성:  2023. 03. 23
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'OperationForPlanDivisionId'
	BEGIN
		SELECT DISTINCT
				A.OPERATION_ID	AS CODE,
				CASE
					WHEN A.OPERATION_ID = 'R5500' THEN (A.OPERATION_ID + ' ' + 'ESS Eack')
					ELSE (A.OPERATION_ID + ' ' + C.OPERATION_NAME)
				END				AS NAME
		FROM	(
					SELECT DISTINCT
							  OPERATION_GROUP
							, SUBSTRING(FLOW_ID, 1, 5) AS OPERATION_ID
					FROM	SCP_MST_FINAL_ITEM WITH(NOLOCK)
				) A
				LEFT JOIN SCM_MST_OPERATION_SN C WITH(NOLOCK) ON
						A.OPERATION_ID = C.OPERATION_ID
		WHERE	1=1
			AND A.OPERATION_GROUP <> 'E'
--V1.2.9			AND SUBSTRING(A.OPERATION_ID,1, 1) <> 'F'
			AND A.OPERATION_ID NOT IN ('P5200')
		ORDER BY 1;
	END

/*===============================================
	용		 도:  Production Plan Report > Version 조회
	사 용 화 면:  SCP0081 Production Plan Report
	변       수:  @Param1 : Division
	최 초 작 성:  2021. 09. 28
	개  발  자 :  kmj
	최 종 작 성:  2022. 05. 26
	수  정  자 : jahn1501
	수 정 사 항: NAME + (WEEKLY) 조회
	===============================================*/
ELSE IF @Code = 'FnVersionByDivisionId'
	BEGIN
		SELECT TOP 10
			'PP_W_' + A.plan_start_yyyymmdd AS CODE
			, 'PP_W_' + A.plan_start_yyyymmdd  + ' (' + B.WEEK_NAME + ')'  AS NAME
		FROM SCP_PLAN_VERSION_V A WITH(NOLOCK) INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.plan_start_yyyymmdd = B.basis_yyyymmdd
		--JOIN (
		--	SELECT DISTINCT
		--		DIVISION_ID
		--		, VERSION_NO
		--	FROM SCP_ANL_PRODUCTION_PLAN_C WITH(NOLOCK)
		--	WHERE 1=1
		--	AND ( (@Param1 IS NULL or @Param1='') OR DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')) )
		--	AND PLAN_TYPE = 'FN'
		--	AND MEASURE = 'PROD_PLAN_AMEND'
		--) B
		--ON A.division_id = B.DIVISION_ID
		--AND 'PP_W_' + A.plan_start_yyyymmdd = B.VERSION_NO
		WHERE 1=1
		AND ( (@Param1 IS NULL or @Param1='') OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')) )
		AND A.PLAN_TYPE = 'FN'
		AND A.CONFIRM_FLAG = 'Y'
		AND A.UI_DISPLAY_YN = 'Y'
		AND A.ACTIVE_FLAG = 'Y'
		ORDER BY A.plan_start_yyyymmdd DESC
		;
	END

/*===============================================
	용		 도:  DIO Report > Version 조회 : PLAN_START_YYYYMMD별 마지막 SEQ
	사 용 화 면:  SCP0083 DIO Report
	변       수:  @Param1 : Division
	최 초 작 성:  2021. 10. 29
	개  발  자 :  kmj
	최 종 작 성:  2021. 10. 29
	수  정  자 :
	수 정 사 항:  다른 프로시저로 대체, 최종 적용 후 삭제 예정
	===============================================*/
ELSE IF @Code = 'FnSeqVersionByDivisionId'
	BEGIN
		SELECT TOP 10
			(A.plan_start_yyyymmdd+'-FN-'+CONVERT(VARCHAR, MAX(A.plan_seq))) AS CODE,
			(A.plan_start_yyyymmdd+'-FN-'+CONVERT(VARCHAR, MAX(A.plan_seq))) AS NAME,
			(SELECT DISTINCT 1 FROM SCP_ANL_DIO_REPORT B WITH(NOLOCK) WHERE B.DIVISION_ID=A.DIVISION_ID AND B.PLAN_START_YYYYMMDD=A.PLAN_START_YYYYMMDD AND B.PLAN_TYPE='FN' AND B.SEQ=MAX(A.PLAN_SEQ)) AS CODEDESC,
			(SELECT TOP 1 (PLAN_START_YYYYMMDD+'-FN-'+CONVERT(NVARCHAR, SEQ)) FROM SCP_ANL_DIO_REPORT C WITH(NOLOCK) WHERE C.DIVISION_ID=@Param1 GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ) AS EDIT_CYCLE_VERSION
		FROM SCP_PLAN_VERSION_V A WITH(NOLOCK)
		WHERE A.division_id = @Param1
		AND A.plan_type = 'FN'
		AND A.confirm_flag = 'Y'
		AND A.ui_display_yn = 'Y'
		AND A.active_flag = 'Y'
		GROUP BY A.division_id, A.plan_start_yyyymmdd
		ORDER BY CODE DESC
		;

	END


	/*===============================================
	용		 도:  Plan Date 조회(금주 월요일 추가)
	사 용 화 면:  SCP0076 , SCP0077
	변       수:  @Param1 : Division
	최 초 작 성:  2021. 11. 16
	개  발  자 :  khj79
	최 종 작 성:  2021. 11. 16
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'PlanDate_REPORT'
	BEGIN
		SELECT DISTINCT CODE
			 , NAME
		  FROM ( SELECT BASIS_YYYYMMDD AS CODE
					  , DATE_FULL_NAME +' ('+ WEEK_NAME + ')' AS NAME--CALENDAR_YYYY +'-'+ WEEK_NAME AS NAME
				   FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
				  WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8), DATEADD(WK,DATEDIFF(WK,0,GETDATE()),0) ,112)
				  UNION ALL
				 SELECT PLAN_START_YYYYMMDD AS CODE
					  , B.DATE_FULL_NAME +' ('+ B.WEEK_NAME + ')' AS NAME--B.CALENDAR_YYYY +'-'+ B.WEEK_NAME AS NAME
				   FROM SCP_PLAN_VERSION_V A WITH(NOLOCK)
				   JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK)
				     ON A.PLAN_START_YYYYMMDD = B.BASIS_YYYYMMDD
				  WHERE (( @Param1 IS NULL OR  @Param1='' ) OR  DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')) )
				) A
		  ORDER BY CODE DESC
	END
/*===============================================
	용		 도:  PLANT_ID 조회
	사 용 화 면:  SCP0076 , SCP0077
	변       수:  @Param1 : Division
	최 초 작 성:  2021. 12. 16
	개  발  자 :  khj79
	최 종 작 성:  2021. 12. 16
	수  정  자 :  lwy - 20220426
	수 정 사 항:  PLANT_NAME 변경 (PRODUCTION RESULT CHECK, SHIPPING RESULT CHECK 화면 적용)
	===============================================*/
ELSE IF @Code = 'Plant_REPORT'
	BEGIN

SELECT DISTINCT PLANT_ID , PLANT_NAME
		  FROM (
				--SELECT A.DIVISION_ID , A.PLANT_ID , ISNULL(B.PLANT_NAME, V.VENDOR_NAME) AS PLANT_NAME
				SELECT A.DIVISION_ID , A.PLANT_ID 	    
					 , CASE WHEN B.DESCRIPTION IS NULL THEN ISNULL(B.PLANT_NAME, V.VENDOR_NAME)
					   ELSE B.DESCRIPTION END AS PLANT_NAME
				  FROM SCM_MST_SITE  A WITH(NOLOCK)
				   LEFT JOIN SCM_PLANT_M_SN B WITH(NOLOCK)
					 ON A.DIVISION_ID = B.DIVISION_ID
					AND A.PLANT_ID = B.PLANT_ID
					LEFT OUTER JOIN  SCM_MST_VENDOR V WITH(NOLOCK) ON V.VENDOR_CODE = A.PLANT_ID AND V.COMPANY_ID = A.COMPANY_ID
				 WHERE 1=1
				   AND ((@Param1 IS NULL or @Param1='') OR A.DIVISION_ID = @Param1)
				   AND SITE_TYPE = 'PLANT'
				   AND A.VALID_YN  ='Y'
				   AND (@Param1 NOT IN ('EE','EE_UC') AND OPERATION_GROUP IN  ('A','P' ))
				   AND OSP_YN = 'N'

				-- 82 외주 추가
				UNION ALL

				-- lwy
				--SELECT A.DIVISION_ID , A.PLANT_ID , ISNULL(B.PLANT_NAME, V.VENDOR_NAME) AS PLANT_NAME
				SELECT A.DIVISION_ID , A.PLANT_ID 	    
					 , CASE WHEN V.ATTRIBUTE1 IS NULL THEN ISNULL(B.PLANT_NAME, V.VENDOR_NAME)
					   ELSE V.ATTRIBUTE1 END AS PLANT_NAME  
				  
				  FROM SCM_MST_SITE  A WITH(NOLOCK)
				   LEFT JOIN SCM_PLANT_M_SN B WITH(NOLOCK)
					 ON A.DIVISION_ID = B.DIVISION_ID
					AND A.PLANT_ID = B.PLANT_ID
					LEFT OUTER JOIN  SCM_MST_VENDOR V WITH(NOLOCK) ON V.VENDOR_CODE = A.PLANT_ID AND V.COMPANY_ID = A.COMPANY_ID
				 WHERE 1=1
				   AND ((@Param1 IS NULL or @Param1='') OR A.DIVISION_ID = @Param1)
				   AND SITE_TYPE = 'PLANT'
				   AND A.VALID_YN  ='Y'
				   AND OPERATION_GROUP IN  ('A','P' )
				   AND OSP_YN = 'Y'
				   AND A.DIVISION_ID = '82'

				-- 전극
				UNION ALL

				SELECT A.DIVISION_ID , A.PLANT_ID,B.PLANT_NAME
				  FROM SCM_MST_SITE  A WITH(NOLOCK)
				  LEFT JOIN SCM_PLANT_M_SN B WITH(NOLOCK)
				   ON A.DIVISION_ID = B.DIVISION_ID
					AND A.PLANT_ID = B.PLANT_ID
				 WHERE 1=1
				  AND SITE_TYPE = 'PLANT'
				  AND A.VALID_YN  ='Y'
				  AND OSP_YN = 'N'
				  AND ((@Param1 IS NULL or @Param1='' OR @PARAM1 IN ('EE','EE_UC')) AND  OPERATION_GROUP = 'E' )
				) X

			ORDER BY X.PLANT_ID
	END

/*===============================================
	용		 도:  Allo Target Plan Date 조회(현재주 월요일 ~ 이전 4주)
	사 용 화 면:  SCP0075
	변       수:
	최 초 작 성:  2021. 12. 15
	개  발  자 :  lwy
	최 종 작 성:  2021. 12. 15
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'PlanDate_AlloTarget'
	BEGIN

		SELECT code, name
		 FROM (
				SELECT format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-4, 0), 'yyyyMMdd') AS code,
					   format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-4, 0), 'yyyy-MM-dd') AS name
				union
				SELECT format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-3, 0), 'yyyyMMdd') AS code,
					   format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-3, 0), 'yyyy-MM-dd') AS name
				union
				SELECT format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-2, 0), 'yyyyMMdd')   AS code,
					   format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-2, 0), 'yyyy-MM-dd') AS name
				union
				SELECT format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-1, 0), 'yyyyMMdd') AS code,
					   format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-1, 0), 'yyyy-MM-dd') AS name
				union
				SELECT format(DATEADD(WK, DATEDIFF(WK, 0, getdate()), 0), 'yyyyMMdd') AS code,
					   format(DATEADD(WK, DATEDIFF(WK, 0, getdate()), 0), 'yyyy-MM-dd') AS name
			  ) A
		ORDER BY CODE DESC
		;
	END


	/*===============================================
	용		 도:  OPERATION 조회
	사 용 화 면:  SCP0081_ProductionPlanReport
	변       수:
	최 초 작 성:  2022. 02. 10
	개  발  자 : chaan
	수  정  자 :
	수 정 사 항:
	===============================================*/
	ELSE IF @Code = 'OperationByLineSCP'
	BEGIN
		SELECT DISTINCT
				A.OPERATION_ID AS CODE,
				(A.OPERATION_ID + ' ' + B.OPERATION_NAME)  AS NAME, A.OPERATION_ID,
				B.SORT_BASIS
		FROM	[dbo].SCM_line_HIERARCHY_V_SN A  WITH(NOLOCK)
				JOIN
					(
						SELECT DISTINCT
								OPERATION_ID ,
								CASE
									WHEN OPERATION_GROUP_ID = 'E' THEN 1
									WHEN OPERATION_GROUP_ID = 'A' THEN 2
									WHEN OPERATION_GROUP_ID = 'F' THEN 3
									WHEN OPERATION_GROUP_ID = 'P' THEN 4
									ELSE                          5
								END SORT_BASIS,
								OPERATION_NAME
						FROM	[dbo].SCM_MST_OPERATION_SN B  WITH(NOLOCK)
					) B
				ON  A.OPERATION_ID = B.OPERATION_ID
		 WHERE	1=1
			AND ( (@Param1 IS NULL or @Param1='') OR A.DIVISION_ID			IN ( SELECT token FROM dbo.String_Split(@Param1,',')))
			AND ( (@Param2 IS NULL or @Param2='') OR A.PLANT_ID				IN ( SELECT token FROM dbo.String_Split(@Param2,',')))
			AND ( (@Param3 IS NULL or @Param3='') OR A.FACTORY_ID			IN ( SELECT token FROM dbo.String_Split(@Param3,',')))
			AND ( (@Param4 IS NULL or @Param4='') OR A.LINE_ID				IN ( SELECT token FROM dbo.String_Split(@Param4,',')))
			AND ( (@Param5 IS NULL or @Param5='') OR A.OPERATION_GROUP_ID	IN ( SELECT token FROM dbo.String_Split(@Param5,',')))
			AND LEFT(A.OPERATION_ID, 5) IN
				(
					SELECT	SEGMENT1 AS OPERATION_ID
					FROM	SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
					WHERE	LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
						AND VALID_YN    = 'Y'
				)
		ORDER BY B.SORT_BASIS, A.OPERATION_ID;
	END

/*===============================================
용		 도:  LOSS CODE KEY_ID 조회
사 용 화 면:  CAPA PIC(SCP0050)
변  수:
최 초 작 성:  2020. 07. 21
개  발  자 :  khj79
수  정  자 :  chaan
수 정 사 항:  Category 에 해당하는 ID만 조회
===============================================*/
ELSE IF @Code = 'MDMKeyIdByCategory'
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
			--AND (@Param1 IS NULL OR @Param1='' OR LV.ATTRIBUTE1 = @Param1)
			AND (@Param1 IS NULL OR @Param1='' OR LV.ATTRIBUTE1 IN (SELECT TOKEN FROM dbo.String_Split(@Param1, ',')))
	END

/*===============================================
용		 도: Plan Date 조회
사 용 화 면: SCP0079_RTF_Analysis_Report
변       수:
최 초 작 성: 2022. 02. 18
개  발  자 : khj79
수  정  자 : vadabi3
수 정 사 항: 2022. 06. 29 주차 적용
===============================================*/
ELSE IF @Code = 'PlanDate_FN'
BEGIN
		SELECT TOP 10
			   A.plan_start_yyyymmdd AS CODE
			 , CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.PLAN_START_YYYYMMDD),121) + ' (' + B.WEEK_NAME + ')' AS NAME
		  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK)
		INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.plan_start_yyyymmdd = B.basis_yyyymmdd
		 WHERE 1=1
		   AND A.DIVISION_ID  = @Param1
		   AND A.PLAN_TYPE		= 'FN'
		   AND A.CONFIRM_FLAG	= 'Y'
		   AND A.UI_DISPLAY_YN	= 'Y'
		   AND A.ACTIVE_FLAG	= 'Y'
		 ORDER BY A.PLAN_START_YYYYMMDD DESC
END

/*===============================================
용		 도: Plan Seq 조회
사 용 화 면: SCP0079_RTF_Analysis_Report
변       수:  -
최 초 작 성: 2022. 02. 19
개  발  자 : khj79
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'PlanSeq_FN'
	BEGIN
		SELECT PLAN_SEQ						AS CODE
			 , CONVERT(VARCHAR, PLAN_SEQ)	AS NAME
		  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK)
		 WHERE 1=1
		   AND DIVISION_ID			= @Param1
		   AND PLAN_START_YYYYMMDD	= @Param2
		   AND PLAN_TYPE			= @Param3
		   AND A.CONFIRM_FLAG		= 'Y'
		   AND A.UI_DISPLAY_YN		= 'Y'
		   AND A.ACTIVE_FLAG		= 'Y'
		 GROUP BY PLAN_SEQ
		 ORDER BY PLAN_SEQ DESC
	END;


/*===============================================
용		 도:  Plant Site 반환(Division, Operation Group, Model 별)
사 용 화 면:  SCP0006_ProjectRoute
변       수:  -
최 초 작 성:  2022. 03. 15
개  발  자 :  chaan
최 종 작 성:  -
수  정  자 :  -
수 정 사 항:
===============================================*/
ELSE IF @Code = 'PlantByDivisionOperationItem'
BEGIN
	IF OBJECT_ID (N'tempdb..#TblPlantByDivisionOperationItem_X', N'U') IS NOT NULL
		DROP TABLE #TblPlantByDivisionOperationItem_X

    SELECT	  S.SCM_SITE_ID
            , S.SITE_DESCRIPTION
            , PLANT_ID
            , OSP_YN
            , COMPANY_ID
            , SITE_ID
    INTO    #TblPlantByDivisionOperationItem_X
    FROM	[dbo].[SCM_MST_SITE] S  WITH(NOLOCK)
    WHERE	1 = 1
        AND S.VALID_YN ='Y'
        AND S.SITE_TYPE = 'PLANT'
        AND ((@Param1 IS NULL OR  @Param1='') OR  S.DIVISION_ID     IN (SELECT token FROM dbo.String_Split(@Param1,',')))
        AND ((@Param2 IS NULL OR  @Param2='') OR  S.OPERATION_GROUP IN (SELECT token FROM dbo.String_Split(@Param2,',')))

	CREATE CLUSTERED INDEX IDX_#TblPlantByDivisionOperationItem_X ON #TblPlantByDivisionOperationItem_X (OSP_YN, PLANT_ID);


	IF OBJECT_ID (N'tempdb..#TblPlantByDivisionOperationItem_A', N'U') IS NOT NULL
		DROP TABLE #TblPlantByDivisionOperationItem_A

    -- 외주가 아니면 해당 PLANT만
    SELECT  A.*
    INTO    #TblPlantByDivisionOperationItem_A
    FROM    (
                SELECT  *
                FROM    #TblPlantByDivisionOperationItem_X
                WHERE   1=1
                    AND OSP_YN = 'N'
		            AND PLANT_ID IN
			            (
				            SELECT	DISTINCT PLANT_ID
				            FROM	SCM_MST_BOM_SN_V T (NOLOCK)
					        WHERE	MODEL_ID IN (SELECT token FROM dbo.String_Split(@Param3,','))
                        )
                UNION
                -- 외주는 전체
                SELECT  *
                FROM    #TblPlantByDivisionOperationItem_X
                WHERE   OSP_YN = 'Y'
            ) A

	IF OBJECT_ID (N'tempdb..#TblPlantByDivisionOperationItem_ESS', N'U') IS NOT NULL
		DROP TABLE #TblPlantByDivisionOperationItem_ESS

    SELECT  A.*
    INTO    #TblPlantByDivisionOperationItem_ESS
    FROM    (
                SELECT DISTINCT
                        T.PLANT_SITE_ID
                FROM    SCM_MST_SITE S  WITH(NOLOCK),
                        SCM_MST_LINE_SN LS  WITH(NOLOCK),
                        SCP_MST_TACT_TIME T WITH(NOLOCK)
                WHERE       1=1
                        AND S.SCM_SITE_ID = T.PLANT_SITE_ID
                        AND LS.COMPANY_ID = S.COMPANY_ID
                        AND LS.DIVISION_ID = T.DIVISION_ID
                        AND LS.SITE_ID = S.SITE_ID
                        AND LS.PLANT_ID = S.PLANT_ID
                        AND LS.OPERATION_ID = T.OPERATION_ID
                        AND LS.LINE_ID = T.LINE_ID
                        AND LS.ACTIVE_FLAG = 'Y'
                        --AND T.DIVISION_ID = @Param1
                        --AND T.ITEM_ID = @Param3
    			        AND ((@Param1 IS NULL OR  @Param1='') OR  T.DIVISION_ID     IN (SELECT token FROM dbo.String_Split(@Param1,',')))
    			        AND ((@Param3 IS NULL OR  @Param3='') OR  T.ITEM_ID         IN (SELECT token FROM dbo.String_Split(@Param3,',')))
                        AND T.VALID_YN = 'Y'
                --ESS 외주 Pakcer Line 생산 Target 적용 union 추가
                UNION ALL
                SELECT DISTINCT
                        T.PLANT_SITE_ID
                FROM    SCM_MST_SITE S WITH(NOLOCK),
                        SCM_MST_LINE_OSP LS WITH(NOLOCK),
                        SCP_MST_TACT_TIME_OSP T WITH(NOLOCK)
                WHERE   1=1
                        AND S.SCM_SITE_ID = T.PLANT_SITE_ID
                        AND LS.DIVISION_ID = T.DIVISION_ID
                        AND LS.SCM_SITE_ID = T.PLANT_SITE_ID
                        AND LS.LINE_ID = T.LINE_ID
                        AND LS.VALID_YN = 'Y'
                        AND T.VALID_YN = 'Y'
                        --AND T.DIVISION_ID = @Param1
                        --AND T.ITEM_ID = @Param3
    			        AND ((@Param1 IS NULL OR  @Param1='') OR  T.DIVISION_ID     IN (SELECT token FROM dbo.String_Split(@Param1,',')))
    			        AND ((@Param3 IS NULL OR  @Param3='') OR  T.ITEM_ID         IN (SELECT token FROM dbo.String_Split(@Param3,',')))
            ) A

	CREATE CLUSTERED INDEX IDX_TblPlantByDivisionOperationItem_ESS ON #TblPlantByDivisionOperationItem_ESS (PLANT_SITE_ID);

            

    SELECT    A.SCM_SITE_ID AS CODE
            , (A.SCM_SITE_ID + ' ' + A.SITE_DESCRIPTION + ' ' + IIF(B.PLANT_SITE_ID IS NOT NULL, 'Y', 'N')) AS NAME
    FROM    #TblPlantByDivisionOperationItem_A A  WITH(NOLOCK)
            LEFT JOIN
                (
                    SELECT DISTINCT
                            PLANT_SITE_ID
                    FROM    #TblPlantByDivisionOperationItem_ESS A
                ) B ON A.SCM_SITE_ID = B.PLANT_SITE_ID
    GROUP BY  A.SCM_SITE_ID
            , (A.SCM_SITE_ID + ' ' + A.SITE_DESCRIPTION + ' ' + IIF(B.PLANT_SITE_ID IS NOT NULL, 'Y', 'N'))
    ORDER BY CODE;


	IF OBJECT_ID (N'tempdb..#TblPlantByDivisionOperationItem_X', N'U') IS NOT NULL
		DROP TABLE #TblPlantByDivisionOperationItem_X
	IF OBJECT_ID (N'tempdb..#TblPlantByDivisionOperationItem_A', N'U') IS NOT NULL
		DROP TABLE #TblPlantByDivisionOperationItem_A
	IF OBJECT_ID (N'tempdb..#TblPlantByDivisionOperationItem_ESS', N'U') IS NOT NULL
		DROP TABLE #TblPlantByDivisionOperationItem_ESS
END;
/*===============================================
용		 도: RTF 연도 목록 조회
사 용 화 면: SCP0092_RTF_ArcheivementRate
변       수:  -
최 초 작 성: 2022. 04. 20
개  발  자 : chaan
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'RTFYear'
	BEGIN
        SELECT DISTINCT
                SUBSTRING(VERSION_NO, 6, 4) AS CODE
        FROM    DM_MST_VERSION WITH(NOLOCK)
        WHERE   1=1
                AND VERSION_TYPE = 'MF_W'
                AND VERSION_DESCRIPTION   = 'MKT FCST Weekly Cutoff'  -- 정기 CUTOFF 만 해당
                AND
					(
                        ISNULL(@Param1, '') = ''
                        OR DIVISION_ID IN
                         (
              SELECT  token
                                FROM    dbo.String_Split(@Param1,',')
                            )
                    )
        ORDER BY CODE DESC
	END;

/*===============================================
용		 도: RTF 주 목록 조회
사 용 화 면: SCP0092_RTF_ArcheivementRate
변       수:  -
최 초 작 성: 2022. 04. 20
개  발  자 : chaan
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'RTFWeek'
	BEGIN
        SELECT    B.WEEK_NAME AS CODE
                , MAX(A.YYYYMMDD + '-' + B.WEEK_NAME) AS NAME
        FROM    DM_MST_VERSION A
                JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON  
                    A.YYYYMMDD = B.BASIS_YYYYMMDD
        WHERE   1=1
                AND A.VERSION_TYPE = 'MF_W'
                AND VERSION_DESCRIPTION   = 'MKT FCST Weekly Cutoff'  -- 정기 CUTOFF 만 해당
                AND
					(
                        ISNULL(@Param1, '') = ''
                        OR A.DIVISION_ID IN
                            (
                       SELECT  token
                                FROM    dbo.String_Split(@Param1,',')
                            )
                    )
                --AND SUBSTRING(A.YYYYMMDD, 1, 4) = @Param2
                AND
					(
                           ISNULL(@Param2, '') = ''
                        OR SUBSTRING(A.YYYYMMDD, 1, 4) = @Param2
                    )
                AND A.YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( GETDATE(), 'SUN')), 112) --당해년도 조회시 현재 기준 전주까지만 조회되도록 수정
        GROUP BY B.WEEK_NAME
        ORDER BY NAME DESC;
	END;


/*===============================================
용		 도: RTF Division->Gubun 목록 조회
사 용 화 면: SCP0092_RTF_ArcheivementRate
변       수:  -
최 초 작 성: 2022. 04. 26
개  발  자 : chaan
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'RTFGubun'
	BEGIN
        SELECT    DIVISION_ID
				, CODE
				, NAME
		FROM
                (
                    SELECT DISTINCT TOP 100 -- ORDER BY 절 사용을 위해 TOP 사용
					            A.DIVISION_ID
				            , LK2.SEGMENT2 AS CODE
				            , LK2.SEGMENT3 AS NAME
				            , LK2.DISPLAY_SEQ
		            FROM	DM_PLN_MKT_FCST A
				            LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 ON
						            A.PROJECT_CODE  = LK1.SEGMENT1
					            AND LK1.LOOKUP_TYPE = 'DM_ITEM_USE_EX'
				            LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK2 ON
						            A.DIVISION_ID = LK2.SEGMENT1
					            AND ISNULL(LK1.SEGMENT2, LEFT(A.PROJECT_CODE, 1)) = LK2.SEGMENT2
					            AND LK2.LOOKUP_TYPE = 'DM_ITEM_USE'
		            WHERE	A.MEASURE = 'RTF_SYS_RP'
			            AND LK2.VALID_YN = 'Y'
			            AND
			            	(
			            		ISNULL(@Param1, '') = ''
			            		OR A.DIVISION_ID IN
			            			(
			            				SELECT  token
			            				FROM    dbo.String_Split(@Param1,',')
			            			)
			            	)
		            ORDER BY DISPLAY_SEQ
                ) X
    END;
/*===============================================
	용		 도: Project Name 조회
	사 용 화 면:  SCP Shipment Plan New
	변       수:
	최 초 작 성:  2022. 05. 17
	개  발  자 : jahn1501
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'ProjectCdName'
	BEGIN		
		SELECT DISTINCT A.PROJECT_CODE  AS CODE
			 , A.PROJECT_CODE AS NAME
			 , CASE WHEN B.PROJECT_NAME IS NULL THEN '-' ELSE B.PROJECT_NAME END AS NAME2
			 , A.DIVISION_ID
			 , A.SCM_SITE_ID
			 , A.ITEM_ID
		  FROM SCM_MST_SITE_ITEM A WITH(NOLOCK) LEFT JOIN SCM_MST_PROJECT B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID
												AND A.PROJECT_CODE = B.PROJECT_CODE
		 WHERE 1=1
		   AND (@Param1 IS NULL OR @Param1='' OR A.DIVISION_ID=@Param1)
		   AND (@Param2 IS NULL OR @Param2='' OR A.SCM_SITE_ID=@Param2)
		   AND (@Param3 IS NULL OR @Param3='' OR A.ITEM_ID=@Param3)
	END 
/*===============================================
용		 도: WaterfallVer (주차) 조회
사 용 화 면  : SCP0017_WaterfallProductionPlan
변       수 : @Param1 : Division
최 초 작 성  : 20202. 05. 24
개  발  자  : jahn1501
수 정  자  :  2022. 09. 28
수 정 사 항  : no plan 적용
===============================================*/
ELSE IF @Code = 'WaterfallVer2'
	BEGIN
		
		/*SELECT 'PP_W_'+PLAN_START_YYYYMMDD CODE
 	  		 , 'PP_W_'+PLAN_START_YYYYMMDD + ' (' + B.WEEK_NAME + ')'  AS NAME
  		  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK) INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.plan_start_yyyymmdd = B.basis_yyyymmdd
		 WHERE A.DIVISION_ID= @Param1
		   AND PLAN_TYPE		='FN'
		   AND CONFIRM_FLAG	='Y'
		 ORDER BY PLAN_START_YYYYMMDD DESC*/
		SELECT 'PP_W_'+ A.PLAN_START_YYYYMMDD CODE
 	  		 , CASE WHEN FP_TARGET_YN = 'Y' THEN 'PP_W_'+ A.PLAN_START_YYYYMMDD + ' (' + B.WEEK_NAME + ')'
 	  		 		ELSE 'PP_W_'+ A.PLAN_START_YYYYMMDD + ' (' + B.WEEK_NAME + ')' + ' (No Plan)' END NAME		
  		  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK) 
  		 INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.PLAN_START_YYYYMMDD = B.BASIS_YYYYMMDD
  		 LEFT JOIN 
  		 (
  		 	SELECT DIVISION_ID
		 		, PLAN_START_YYYYMMDD
		 		, FP_TARGET_YN
		 		, MRP_TARGET_YN
		 		, DM_RTF_YN	 
	  		 FROM [dbo].[SCP_PLN_INTERFACE_YN] WITH(NOLOCK)
			WHERE 1=1
	   		  AND DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@Param1,','))	   
  		 ) C ON A.PLAN_START_YYYYMMDD = C.PLAN_START_YYYYMMDD  	
		    AND A.DIVISION_ID         = C.DIVISION_ID 	 
		 WHERE 1=1
		   AND A.DIVISION_ID= @Param1
		   AND PLAN_TYPE		='FN'
		   AND CONFIRM_FLAG	='Y'
		 ORDER BY A.PLAN_START_YYYYMMDD DESC		
	END
/*===============================================
용		 도: Waterfall Version 조회
사 용 화 면  : SCP0016_WaterfallShipmentPlanFG
			SCP0018_WaterfallShipmentPlanSemi
변       수 : @Param1 : Division
최 초 작 성  : 2022. 05. 24
개  발  자  : jahn1501
수  정  자  :  2022. 09. 27
수 정 사 항  : no plan 적용
===============================================*/
ELSE IF @Code = 'WaterfallVer_FG2'
		BEGIN
			
			/*SELECT TOP 10 'SP_W_'+PLAN_START_YYYYMMDD CODE
					, 'SP_W_'+PLAN_START_YYYYMMDD + ' (' + B.WEEK_NAME + ')'  AS NAME
	  		  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK) INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.plan_start_yyyymmdd = B.basis_yyyymmdd
			 WHERE A.DIVISION_ID= @Param1
			   AND PLAN_TYPE		='FN'
			   AND CONFIRM_FLAG	='Y'
			 ORDER BY PLAN_START_YYYYMMDD DESC*/
			SELECT TOP 10 'SP_W_'+A.PLAN_START_YYYYMMDD CODE
	 	  		 , CASE WHEN FP_TARGET_YN = 'Y' THEN 'SP_W_'+A.PLAN_START_YYYYMMDD + ' (' + B.WEEK_NAME + ')'
	 	  		 		ELSE 'SP_W_'+A.PLAN_START_YYYYMMDD + ' (' + B.WEEK_NAME + ')' + ' (No Plan)' END NAME		
	  		  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK) 
	  		 INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.PLAN_START_YYYYMMDD = B.BASIS_YYYYMMDD
	  		 LEFT JOIN 
	  		 (
	  		 	SELECT DIVISION_ID
			 		, PLAN_START_YYYYMMDD
			 		, FP_TARGET_YN
			 		, MRP_TARGET_YN
			 		, DM_RTF_YN	 
		  		 FROM [dbo].[SCP_PLN_INTERFACE_YN] WITH(NOLOCK)
				WHERE 1=1
		   		  AND DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@Param1,','))	   
	  		 ) C ON A.PLAN_START_YYYYMMDD = C.PLAN_START_YYYYMMDD  	
		        AND A.DIVISION_ID         = C.DIVISION_ID 	 
			 WHERE 1=1
			   AND A.DIVISION_ID= @Param1
			   AND PLAN_TYPE		='FN'
			   AND CONFIRM_FLAG	='Y'
			 ORDER BY A.PLAN_START_YYYYMMDD DESC			
			
		END
/*===============================================
용		 도: Allo Target Plan Date 조회(현재주 월요일 ~ 이전 4주)
사 용 화 면  : SCP0075_Allo_Target
변       수 :
최 초 작 성  : 2022.05.25
개  발  자  : jahn1501
수  정  자  :
수 정 사 항  :
===============================================*/
ELSE IF @Code = 'PlanDate_AlloTarget2'
		BEGIN
	
			SELECT code, name + ' (' + B.WEEK_NAME + ')' as name
			  FROM (
					SELECT format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-4, 0), 'yyyyMMdd') AS code,
						   format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-4, 0), 'yyyy-MM-dd') AS name
					union
					SELECT format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-3, 0), 'yyyyMMdd') AS code,
						   format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-3, 0), 'yyyy-MM-dd') AS name
					union
					SELECT format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-2, 0), 'yyyyMMdd')   AS code,
						   format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-2, 0), 'yyyy-MM-dd') AS name
					union
					SELECT format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-1, 0), 'yyyyMMdd') AS code,
						   format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-1, 0), 'yyyy-MM-dd') AS name
					union
					SELECT format(DATEADD(WK, DATEDIFF(WK, 0, getdate()), 0), 'yyyyMMdd') AS code,
						   format(DATEADD(WK, DATEDIFF(WK, 0, getdate()), 0), 'yyyy-MM-dd') AS name
				  ) A
	  		   INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.code = B.basis_yyyymmdd
			ORDER BY CODE DESC
		END
/*===============================================
용		 도:  shop_group_id 조회(전극 구분)
사 용 화 면:  SCP0081
변       수:
최 초 작 성:  2022. 07. 07
개  발  자 :  chaan
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'ShopGroupIdEE'
	BEGIN
		SELECT DISTINCT
		       SHOP_GROUP_ID   AS CODE
		     , OPERATION_GROUP AS NAME
          FROM SCM_SITE_HIERARCHY_V_SN A WITH(NOLOCK)
		  WHERE 1 = 1
		  --AND ( (@Param1 IS NULL or @Param1='') OR A.DIVISION_ID    IN ( SELECT token FROM dbo.String_Split(@Param1,','))  )
		  AND A.SHOP_GROUP_ID = 'E'
	END
ELSE IF @Code = 'ShopGroupIdNotEE'
	BEGIN
		SELECT DISTINCT
		       SHOP_GROUP_ID   AS CODE
		     , OPERATION_GROUP AS NAME
          FROM SCM_SITE_HIERARCHY_V_SN A WITH(NOLOCK)
		  WHERE 1 = 1
		  AND ( (@Param1 IS NULL or @Param1='') OR A.DIVISION_ID    IN ( SELECT token FROM dbo.String_Split(@Param1,','))  )
		  AND A.SHOP_GROUP_ID <> 'E'
	END
/*===============================================
용		 도:  Bucket 타입 조회시 ISO_WEEK 추가
사 용 화 면:  SCP0017/SCP0018/SCP0019
변       수:
최 초 작 성:  2022. 07. 14
개  발  자 :  chaan
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'BucketISO'
	BEGIN
        SELECT    L.SEGMENT1  AS CODE
                , L.SEGMENT2  AS NAME
        FROM    [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
        WHERE   L.LOOKUP_TYPE = 'BUCKET_TYPE_CODE_ISO'
            AND L.VALID_YN    = 'Y'
        ORDER BY DISPLAY_SEQ
    END

/*===============================================
용		 도:  PlantSitePackerHoldStock
사 용 화 면:  SCP0041
변       수:
최 초 작 성:  2022. 11. 24
개  발  자 :  vadabi3
수  정  자 :
수 정 사 항:
===============================================*/
		ELSE IF @Code = 'PlantSitePackerHoldStock'
			BEGIN
			
				SELECT DISTINCT 
						SCM_SITE_ID AS CODE
					  , SCM_SITE_ID AS NAME
				FROM   SCM_MST_SITE S WITH(NOLOCK) 
				WHERE  1 = 1
				AND    SITE_TYPE = 'PLANT'
				AND    OSP_YN = 'Y'
				AND    (@Param1 IS NULL OR @Param1='' OR S.DIVISION_ID=@Param1)
				ORDER BY 1,2
			END;

/*===============================================
용		 도:  SCMTeam 조회
사 용 화 면:  SCP0092
변       수:
최 초 작 성:  2022. 12. 09
개  발  자 :  chaan
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'SCMTeamByDivision'
	BEGIN
		DECLARE @V_LANG NVARCHAR(200);

		SELECT  @V_LANG = U.LANGUAGE
		FROM    dbo.TB_FX_USER U
		WHERE   U.USERID = @Param2;

		SET @V_LANG = ISNULL(@V_LANG, 'KO');

	    SELECT DISTINCT
		        D.DEPT_ID             AS CODE
			    , CASE
                    WHEN @V_LANG  = 'EN' THEN D.DEPT_NAME_EN
				    WHEN @V_LANG  = 'CN' THEN D.DEPT_NAME_CN
                    ELSE D.DEPT_NAME_KO
            	  END AS NAME
		        , D.DEPT_NAME_KO
		        , D.DEPT_NAME_EN
		        , D.DEPT_NAME_CN
	    FROM    SCP_MST_FINAL_ITEM F WITH(NOLOCK)
			    JOIN SCM_MST_SSO_USER_INFO U WITH(NOLOCK) ON
					    F.ATTRIBUTE6 = U.USER_ID
			    JOIN SCM_MST_SSO_DEPT_INFO D WITH(NOLOCK) ON
					    U.DEPT_ID    = D.DEPT_ID
	    WHERE	1=1
		    AND ((@Param1 IS NULL or @Param1='') OR F.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@Param1,',')))
    END


/*===============================================
용		 도:  SCPPlanPeriod
사 용 화 면:  SCP0013
변       수:
최 초 작 성:  2022. 12. 22
개  발  자 :  vadabi3
수  정  자 :
수 정 사 항:
===============================================*/
		ELSE IF @Code = 'SCPPlanPeriod'
			BEGIN
			
				----------------------------------------------
				-- 1, Weekly 기준 조회
				-- 2, Month , Week, Day 모두 동일
				----------------------------------------------
				SELECT HORIZON_START_DATE
				      ,HORIZON_END_DATE
				      ,PLAN_CYCLE
					  ,DATEDIFF(WW, PLAN_NAME, HORIZON_END_DATE) AS DIFF_WEEK
					FROM SCM_MST_PLAN  WITH(NOLOCK)
				WHERE 1 = 1
				AND PLAN_NAME = @PARAM1
				AND DIVISION_ID = @PARAM2
				AND PLAN_CYCLE = 'WEEKLY'

			END;

/*===============================================
용		 도:  CellGroup 조회
사 용 화 면:  SCP0094
변       수:
최 초 작 성:  2022. 01. 16
개  발  자 :  chaan
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'CellGroup'
	BEGIN
        SELECT DISTINCT
                  A.GROUP_CODE1  AS CODE
                , A.GROUP_CODE1  AS NAME
        FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
        WHERE   1=1
            AND A.OPERATION_GROUP IN ('A', 'P')
            AND (( @Param1	IS NULL OR @Param1	='') OR A.DIVISION_ID		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@Param1, ',')))
            --AND (( @Param2	IS NULL OR @Param2	='') OR A.FLOW_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@Param2, ',')))
            AND (( @Param3	IS NULL OR @Param3	='') OR A.ITEM_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@Param3, ',')))
            AND (( @Param4	IS NULL OR @Param4	='') OR A.NICK_NAME			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@Param4, ',')))
        ORDER BY CODE
    END

/*===============================================
용		 도:  PLANT_DOMESTIC 조회
사 용 화 면:  SCP0051
변       수:
최 초 작 성:  2023. 06. 16
개  발  자 :  VADABI3
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'PLANT_DOMESTIC'
	BEGIN
			SELECT 
				 s.division_id
				,s.plant_id
				,s.scm_site_id
				,s.country
				,s.company_id
			FROM SCM_MST_SITE S(NOLOCK)
			WHERE s.site_type = 'PLANT'
			and s.operation_group = 'A'
			and s.company_id = @v_C100 --'C100'
			and s.valid_yn = 'Y'
    END
/*===============================================
용		 도:  Item No Active 조회
사 용 화 면:  SCP0030
변       수:
최 초 작 성:  2023. 06. 30
개  발  자 :  chaan
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'ITEM_NO_ACTIVE'
BEGIN
    SELECT  * 
	FROM    dbo.FN_GET_SCP_ITEM_INACTIVE(@Param1, @Param2);
END

ELSE IF @Code = 'Division'
	BEGIN
        SELECT  * 
        FROM    [dbo].[FN_GET_DIVISION](@Param1, @Param2)
        ORDER BY ATTRIBUTE1
    END

/*===============================================
용		 도:  MRP 검색조건용
사 용 화 면:  SCP0103
변       수:
최 초 작 성:  2023. 10. 30
개  발  자 :  chaan
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'SCP_PLAN_START_DATE'
BEGIN
	IF OBJECT_ID('tempdb..#tblCommonSCP_SCP_PLAN_START_DATE_TEMP') IS NOT NULL
		DROP TABLE #tblCommonSCP_SCP_PLAN_START_DATE_TEMP;

    --빈테이블 생성
    SELECT    CONVERT(NVARCHAR(100), NULL)      AS DIVISION_ID
            , CONVERT(NVARCHAR(100), NULL)      AS CODE
            , CONVERT(NVARCHAR(100), NULL)      AS NAME
            , CONVERT(BIGINT, NULL)             RN
    INTO    #tblCommonSCP_SCP_PLAN_START_DATE_TEMP
    WHERE   1<>1;

    INSERT INTO #tblCommonSCP_SCP_PLAN_START_DATE_TEMP
    SELECT    DIVISION_ID
            , CODE
            , NAME
            , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, CODE ORDER BY NAME DESC) AS RN
    FROM    (
                SELECT	  A.DIVISION_ID
		                , A.PLAN_START_YYYYMMDD AS CODE
		                , CASE
			                WHEN C.FP_TARGET_YN = 'Y' THEN A.PLAN_START_YYYYMMDD + ' (' + B.WEEK_NAME + ')'
			                ELSE                           A.PLAN_START_YYYYMMDD + ' (' + B.WEEK_NAME + ')' + ' (No Plan)'
		                    END AS NAME
                FROM	SCP_PLAN_VERSION_V A WITH(NOLOCK)
		                INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON
				                A.PLAN_START_YYYYMMDD = B.BASIS_YYYYMMDD
		                LEFT JOIN (
					                SELECT	  DIVISION_ID
							                , PLAN_START_YYYYMMDD
							                , FP_TARGET_YN
							                , MRP_TARGET_YN
							                , DM_RTF_YN
					                FROM	dbo.SCP_PLN_INTERFACE_YN WITH(NOLOCK)
					                WHERE	1=1
				                    ) C ON
				                A.PLAN_START_YYYYMMDD = C.PLAN_START_YYYYMMDD
		                    AND A.DIVISION_ID         = C.DIVISION_ID 
                WHERE	1=1
                GROUP BY	  A.DIVISION_ID
			                , A.PLAN_START_YYYYMMDD
			                , B.WEEK_NAME
			                , C.FP_TARGET_YN
        ) A

    SELECT    A.DIVISION_ID
            , B.CODE
            , B.NAME
    FROM    dbo.SCP_ANL_MAT_SUPPLY A WITH(NOLOCK)
            INNER JOIN #tblCommonSCP_SCP_PLAN_START_DATE_TEMP B ON
                    A.DIVISION_ID           = B.DIVISION_ID
                AND SCP_PLAN_START_YYYYMMDD = B.CODE
        AND RN = 1
    GROUP BY      A.DIVISION_ID
                , B.CODE
                , B.NAME
    ORDER BY    NAME DESC;

    IF OBJECT_ID('tempdb..#tblCommonSCP_SCP_PLAN_START_DATE_TEMP') IS NOT NULL
		DROP TABLE #tblCommonSCP_SCP_PLAN_START_DATE_TEMP;
END
ELSE IF @Code = 'MRP_PLAN_START_DATE'
BEGIN
    SELECT    DIVISION_ID
            , SCP_PLAN_START_YYYYMMDD
            , MRP_PLAN_START_YYYYMMDD AS CODE
            , MRP_PLAN_START_YYYYMMDD AS NAME
    FROM    dbo.SCP_ANL_MAT_SUPPLY A WITH(NOLOCK)
    WHERE   1=1
    GROUP BY  DIVISION_ID
            , SCP_PLAN_START_YYYYMMDD
            , MRP_PLAN_START_YYYYMMDD
    ORDER BY  MRP_PLAN_START_YYYYMMDD DESC
END
ELSE IF @Code = 'MRP_ITEM_CATEGORY'
BEGIN
    SELECT    DIVISION_ID
            , SCP_PLAN_START_YYYYMMDD
            , ITEM_CATEGORY AS CODE
            , ITEM_CATEGORY AS NAME
    FROM    dbo.SCP_ANL_MAT_SUPPLY A WITH(NOLOCK)
    WHERE   1=1
    GROUP BY  DIVISION_ID
            , SCP_PLAN_START_YYYYMMDD
            , ITEM_CATEGORY
    ORDER BY  ITEM_CATEGORY
END
ELSE IF @Code = 'MRP_MATERIAL'
BEGIN
    SELECT    DIVISION_ID
            , SCP_PLAN_START_YYYYMMDD
            , NICKNAME
            , MATERIAL AS CODE
            , MATERIAL AS NAME
    FROM    dbo.SCP_ANL_MAT_SUPPLY A WITH(NOLOCK)
    WHERE   1=1
    GROUP BY  DIVISION_ID
            , SCP_PLAN_START_YYYYMMDD
            , NICKNAME
            , MATERIAL
    ORDER BY  MATERIAL
END
ELSE IF @Code = 'MRP_SUPPLIER'
BEGIN
 	DECLARE @V_ELAPSED_TIME_BEG     DATETIME                = CURRENT_TIMESTAMP;


    IF OBJECT_ID('tempdb..#tblCommonSCP_MRP_SUPPLIER_RAW_TEMP') IS NOT NULL
		DROP TABLE #tblCommonSCP_MRP_SUPPLIER_RAW_TEMP;

    SELECT    A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.COMPANY
            , A.SUPPLIER
    INTO    #tblCommonSCP_MRP_SUPPLIER_RAW_TEMP
    FROM    dbo.SCP_ANL_MAT_SUPPLY A WITH(NOLOCK)
    WHERE   1=1
        AND A.SUPPLIER IS NOT NULL
    GROUP BY  A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.COMPANY
            , A.SUPPLIER

--TESTING : NOK
--select * from #tblCommonSCP_MRP_SUPPLIER_RAW_TEMP;

	CREATE CLUSTERED INDEX IDX_tblCommonSCP_MRP_SUPPLIER_RAW_TEMP ON #tblCommonSCP_MRP_SUPPLIER_RAW_TEMP(SUPPLIER);

--PRINT CONCAT('ELAPSED_TIME - #tblCommonSCP_MRP_SUPPLIER_RAW_TEMP : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;


    IF OBJECT_ID('tempdb..#tblCommonSCP_MRP_SUPPLIER_RAW') IS NOT NULL
		DROP TABLE #tblCommonSCP_MRP_SUPPLIER_RAW;
                
    SELECT    A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.COMPANY
            , B.SUPPLIER
    INTO    #tblCommonSCP_MRP_SUPPLIER_RAW
    FROM    #tblCommonSCP_MRP_SUPPLIER_RAW_TEMP A
            CROSS APPLY (
                            SELECT    TOKEN     AS SUPPLIER
                            FROM    dbo.String_Split(A.SUPPLIER, '^') 
                            GROUP BY  TOKEN
                        ) B
    WHERE   1=1
    GROUP BY  A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.COMPANY
            , B.SUPPLIER

--PRINT CONCAT('ELAPSED_TIME - #tblCommonSCP_MRP_SUPPLIER_RAW : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from #tblCommonSCP_MRP_SUPPLIER_RAW;

    IF OBJECT_ID('tempdb..#tblCommonSCP_MRP_SUPPLIER_TEMP') IS NOT NULL
		DROP TABLE #tblCommonSCP_MRP_SUPPLIER_TEMP;
    
    --빈테이블 생성
    SELECT    CONVERT(NVARCHAR(100), NULL)      AS DIVISION_ID
            , CONVERT(NVARCHAR(100), NULL)      AS SCP_PLAN_START_YYYYMMDD
            , CONVERT(NVARCHAR(100), NULL)      AS COMPANY
            , CONVERT(NVARCHAR(100), NULL)      AS CODE
            , CONVERT(NVARCHAR(100), NULL)      AS NAME
    INTO    #tblCommonSCP_MRP_SUPPLIER_TEMP
    WHERE   1<>1

    INSERT INTO #tblCommonSCP_MRP_SUPPLIER_TEMP
    SELECT    A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.COMPANY
            , A.SUPPLIER                                                        AS CODE
            , IIF(V1.VENDOR_NAME IS NOT NULL, V1.VENDOR_NAME, V2.VENDOR_NAME)   AS NAME
    FROM    #tblCommonSCP_MRP_SUPPLIER_RAW A
            LEFT JOIN (
                        SELECT    VENDOR_CODE
                                , VENDOR_NAME
                        FROM    SCM_MST_VENDOR WITH(NOLOCK)
                        WHERE   1=1
                            AND COMPANY_ID = @v_C100 -- 'C100'
                        GROUP BY  VENDOR_CODE
                                , VENDOR_NAME
                        ) V1 ON --1순위 C100
                    A.SUPPLIER  = V1.VENDOR_CODE
            LEFT JOIN (
                        SELECT    COMPANY_ID
                                , VENDOR_CODE
                                , VENDOR_NAME
                        FROM    SCM_MST_VENDOR WITH(NOLOCK)
                        ) V2 ON --2순위 자기COMPANY
                    A.COMPANY   = V2.COMPANY_ID
                AND A.SUPPLIER  = V2.VENDOR_CODE;

    SELECT    A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.CODE
            , A.NAME
    FROM    #tblCommonSCP_MRP_SUPPLIER_TEMP A
    WHERE   1=1
        --AND DIVISION_ID             = '81'
        --AND SCP_PLAN_START_YYYYMMDD = '20231211'
    GROUP BY  A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.CODE
            , A.NAME
    ORDER BY  A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.CODE
            , A.NAME

--PRINT CONCAT('ELAPSED_TIME - fianl : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

    IF OBJECT_ID('tempdb..#tblCommonSCP_MRP_SUPPLIER_RAW_TEMP') IS NOT NULL
		DROP TABLE #tblCommonSCP_MRP_SUPPLIER_RAW_TEMP;

    IF OBJECT_ID('tempdb..#tblCommonSCP_MRP_SUPPLIER_RAW') IS NOT NULL
		DROP TABLE #tblCommonSCP_MRP_SUPPLIER_RAW;
END
ELSE IF @Code = 'MRP_OPERATION'
BEGIN
    SELECT    A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.OPERATION_GROUP      AS CODE
            , A.OPERATION_GROUP      AS NAME
	FROM	dbo.SCP_ANL_MAT_SUPPLY A WITH(NOLOCK)
    WHERE    1=1
        AND ISNULL(OPERATION_GROUP, '-') <> '-'
    GROUP BY  A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.OPERATION_GROUP
	ORDER BY  A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.OPERATION_GROUP
END
ELSE IF @Code = 'MRP_PLANT'
BEGIN
    SELECT    A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.PLANT_ID                            AS CODE
            , (A.PLANT_ID + ' ' + B.PLANT_NAME)     AS NAME
	FROM	dbo.SCP_ANL_MAT_SUPPLY A WITH(NOLOCK)
            JOIN SCM_MST_PLANT_SN B WITH(NOLOCK) ON
					A.DIVISION_ID	= B.DIVISION_ID
				AND A.PLANT_ID		= B.PLANT_ID
    WHERE    1=1
    GROUP BY  A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.PLANT_ID
            , B.PLANT_NAME
	ORDER BY  A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.PLANT_ID
END
ELSE IF @Code = 'MRP_NICKNAME'
BEGIN
    SELECT    A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            --, A.ATTRIBUTE3					AS OPERATION_GROUP
            , ''          					AS OPERATION_GROUP
            , A.NICKNAME					AS CODE
            , A.NICKNAME					AS NAME
	FROM	dbo.SCP_ANL_MAT_SUPPLY A WITH(NOLOCK)
    WHERE    1=1
    GROUP BY  A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            --, A.ATTRIBUTE3
            , A.NICKNAME
	ORDER BY  A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            --, A.ATTRIBUTE3
            , A.NICKNAME
END
ELSE IF @Code = 'MRP_ITEM_ID'
BEGIN
    SELECT    A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            --, A.ATTRIBUTE3                  AS OPERATION_GROUP
            , ''                            AS OPERATION_GROUP
            , A.NICKNAME
            , A.ITEM_ID                     AS CODE
            , A.ITEM_ID                     AS NAME
	FROM	dbo.SCP_ANL_MAT_SUPPLY A WITH(NOLOCK)
    WHERE   1=1
        AND A.ITEM_ID <> 'SUM'
        AND A.ITEM_ID <> '-'
    GROUP BY  A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.ATTRIBUTE3
            , A.NICKNAME
            , A.ITEM_ID
	ORDER BY  A.DIVISION_ID
            , A.SCP_PLAN_START_YYYYMMDD
            , A.ATTRIBUTE3
            , A.NICKNAME
            , A.ITEM_ID
END

ELSE

RETURN;

 --------------
END
