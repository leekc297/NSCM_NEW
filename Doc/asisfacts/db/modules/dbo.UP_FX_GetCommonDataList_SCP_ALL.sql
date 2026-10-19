/* ==========================================================================================================================================================
프로그램ID : UP_FX_GetCommonDataList_SCP_ALL
업  무  명 : 공통 코드성 조회
프로그램명 : 공통 코드성 조회
최초작성일 : 2018.07.05
최종작성일 : 2018.07.05
개  발  자 : ygkim
입  력  값 :
출  력  값 :
==========================================================================================================================================================
 Date         In Charge     Description
==========================================================================================================================================================
 2024/01/11   chaan         V1.1.1  Initial Release - 중첩제약으로 UP_FX_GetCommonDataList_SCP 분리
 2024/01/23   chaan         V1.1.2  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - PlantSiteByDivisionOSP 제거
 2024/01/25   chaan         V1.1.2  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 조회오류 수정 - WaterfallVer21
                                                                                                     - WaterfallVer_FG21
                                                                                                     - FnVersionByDivisionId1 : TOP 제약 제거
 2024/02/01   chaan         V1.1.3  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ElecRoutePlantByOperation1 수정
 2024/02/07   chaan         V1.1.4  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - YearFromThisYear
                                                                                                     - OperationElectrodeType
                                                                                                     - Company
 2024/04/23   chaan         V1.1.5  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 개발서버 기준 소스 맞춤
 2024/05/23   mrchois		V1.1.6  PJ20244573 재료비task 과제 Group Mapping 용 @Code = 'GroupMaster' 추가
 2024/05/31   chaan         V1.1.7  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 개발서버 기준 소스 맞춤
 2024/06/03   chaan         V1.1.8  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - CapaPlantEE 추가
 2024.06.09   vadabi3               NERP - 특정 Company 별도 처리 개선
 2024/06/12   chaan         V1.1.9  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - CapaLineMasterEE 추가
 2024/06/24   chaan         V1.1.10 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - CapaCompany 추가
 2024/06/28   chaan         V1.1.11 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - CAPA 시스템 최초 수정 적용
 2024/07/01   chaan         V1.1.12 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - CapaLineMaster - Name is not null 처리
                                                                                                   - SCP0104 Line Assign 용 검색목록 명칭 표시 변경(Operation, Elecrode Type 을 제외하고 "code + ' ' + name" 형식으로 변경)
 2024/07/11   chaan         V1.1.13 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - CapaLineMaster - Name is not null 처리 원복
 2024/07/14   chaan         V1.1.14 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - CapaLine - 조립 라인 조회시 'F' 제외
                                                                                                   - CapaLineMaster - 더미코드 SHOP_GROUP_ID 처리
 
 2024/08/06   chaan         V1.1.15 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - CapaFactory - Comapany Id 추가
 2024/08/16   chaan         V1.1.16 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - CapaVersion - SEQ 목록 및 BP 표시를 위해 BIZ_PLAN_USE_YN 추가
 2024/08/22   chaan         V1.1.17 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Capa 더미 포함 검색조건 목록 수정
                                                                                                     ~ CapaSite
                                                                                                     ~ CapaCompany
                                                                                                     ~ CapaPlant
                                                                                                     ~ CapaPlantEE
                                                                                                     ~ CapaFactory
                                                                                                     ~ CapaLine
                                                                                                     ~ CapaOperationByLine
                                                                                                     ~ CapaOperationByLineEE
                                                                                                    - CPS 전용뷰로 대체
 2024/09/25   chaan         V1.1.18 PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Capa 더미 포함 검색조건 목록 수정
                                                                                                    - Capa Dummy Line master용 DummyCapaLineMaster 추가
 2025/03/31   mrchois       PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선	- 소형(40)에서 AFFFF(가상공정) 제외 할 것 							
 2025/05/13   mrchois       PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선	- 최적화용 Plan Group, Activity Code, Plan ID 정보 추가						
 2025/08/20   mrchois       PJ20257329	 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산	- Plan ID 정보 조회시 ATTRIBUTE10 = 'AI' 인 정보 제외						
 2025/09/03   mrchois       PJ20257329	 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산	- Plan Group 검색조건에 삭제한 Plan Group 미표시	
 2025/09/30   mrchois       PJ20257329	 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산	- 최적화용 Plan Date 정보 조회 추가
 2025/11/26   mrchois		PJ20257329   최적화 Planning Input Constraint UI 개발 및 Master Validation 확산	- JV법인 ESS 혼용 생산 시스템 개선 LINK_PLANT_SITE_CODE 정보 조회 추가
========================================================================================================================================================== */
--CREATE PROCEDURE [dbo].[UP_FX_GetCommonDataList_SCP_ALL]
CREATE PROCEDURE [dbo].[UP_FX_GetCommonDataList_SCP_ALL]
      @Code         NVARCHAR(100)
    , @Param1       NVARCHAR(100)
    , @Param2       NVARCHAR(100)
    , @Param3       NVARCHAR(MAX)
    , @Param4       NVARCHAR(MAX)
    , @Param5       NVARCHAR(MAX)
    , @Param6       NVARCHAR(MAX) = NULL
    , @TimeZone     NVARCHAR(MAX) = 'AS054'
AS
BEGIN
     SET NOCOUNT ON;
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

  -- NERP 매핑코드
  DECLARE @v_B100 NVARCHAR(8);
  DECLARE @v_C100 NVARCHAR(8);
  DECLARE @v_G182 NVARCHAR(8);

  SELECT @v_B100 = dbo.FN_GET_LOOKUP_VALUE('UP_FX_GetCommonDataList_SCP','COMPANY_SALES')	-- B100
  SELECT @v_C100 = dbo.FN_GET_LOOKUP_VALUE('UP_FX_GetCommonDataList_SCP','ESOC')			-- C100
  SELECT @v_G182 = dbo.FN_GET_LOOKUP_VALUE('UP_FX_GetCommonDataList_SCP','PLANT')			-- G182




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
IF (@Code = 'FromSite_PSI1' )
BEGIN
	SELECT
		A.FROM_SITE AS CODE ,
		CASE WHEN B.SITE_DESCRIPTION IS NULL  THEN A.FROM_SITE
		WHEN B.SITE_DESCRIPTION IS NOT NULL THEN B.SITE_DESCRIPTION
		END AS NAME
		,A.OPERATION_GROUP
		,A.DIVISION_ID
	FROM (
		SELECT distinct SEGMENT3 FROM_SITE , SEGMENT2 OPERATION_GROUP , SEGMENT1  DIVISION_ID
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'EE_PSI_PRODUCTION'
			AND SEGMENT1 = 'SCP'
			AND ( ( @PARAM2 IS NULL OR  @PARAM2='' ) OR SEGMENT2 = @PARAM2)
			AND VALID_YN = 'Y'
	)  A
	LEFT OUTER JOIN SCM_MST_SITE B  WITH(NOLOCK) ON A.FROM_SITE = B.SCM_SITE_ID
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
 ELSE IF (@Code = 'PlantSitePlanProblem1' )
 BEGIN
	SELECT '-' AS CODE, '-' AS NAME , '-' AS DIVISION_ID
	UNION ALL
	SELECT A.PLANT_SITE_ID AS CODE
			,CASE WHEN B.SITE_DESCRIPTION IS NULL  THEN A.PLANT_SITE_ID
				WHEN B.SITE_DESCRIPTION IS NOT NULL THEN B.SITE_DESCRIPTION
			END AS NAME, A.DIVISION_ID
	FROM (
		SELECT DISTINCT SEGMENT2 PLANT_SITE_ID , SEGMENT4 DIVISION_ID
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'EE_PROBLEM_REPORT_DEMAND'
			AND SEGMENT1 = 'SCP'
			AND VALID_YN = 'Y'
			AND ( ( @Param1 IS NULL OR  @Param1='' ) OR SEGMENT4 = @Param1 )
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
 ELSE IF (@Code = 'SalesSitePlanProblem1' )
 BEGIN
	SELECT DISTINCT SEGMENT3 CODE
		 ,SEGMENT3 NAME
		 ,SEGMENT4 DIVISION_ID
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	WHERE LOOKUP_TYPE = 'EE_PROBLEM_REPORT_DEMAND'
		AND SEGMENT1 = 'SCP'
		AND VALID_YN = 'Y'
		AND ( ( @Param1 IS NULL OR  @Param1='' ) OR SEGMENT4 = @Param1)--chaan
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
	 ELSE IF (@Code = 'PlantSiteProdPlan1' )
	 BEGIN
		SELECT	  A.SCM_SITE_ID AS CODE
				, CASE
					WHEN B.SITE_DESCRIPTION IS NULL THEN A.SCM_SITE_ID
					WHEN B.SITE_DESCRIPTION IS NOT NULL THEN B.SITE_DESCRIPTION
				  END AS NAME
				  ,A.DIVISION_ID
		         ,A.OPERATION_GROUP
		FROM	(
					SELECT DISTINCT
							SEGMENT3 SCM_SITE_ID,
							ATTRIBUTE2 DIVISION_ID,
							SEGMENT2 OPERATION_GROUP
					FROM	SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
					WHERE	1=1
						AND LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
						AND SEGMENT1 = 'SCP'
						AND ((@Param2 IS NULL OR @Param2 ='') OR SEGMENT2 IN (SELECT token FROM dbo.String_Split(@Param2, ',')))
						AND VALID_YN = 'Y'
						AND ((@Param1 IS NULL OR @Param1 ='') OR ATTRIBUTE2 = @Param1)
						AND ((@Param3 <> 'JV Planner') OR SEGMENT3 IN (SELECT token FROM dbo.String_Split(@Param4, ',')))
				) A
				LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) ON
						A.SCM_SITE_ID = B.SCM_SITE_ID
		ORDER BY	CODE
	 END

 ELSE IF (@Code = 'LineProdPlanLine1' )
BEGIN
	SELECT	A.*
	FROM	(
				SELECT	  A.LINE_ID                         AS CODE
						, A.LINE_ID + '   ' + A.LINE_NAME   AS NAME
						, C.DIVISION_ID
						, C.OPERATION_GROUP
						, C.SCM_SITE_ID                     AS SITE_ID
				FROM	SCM_MST_LINE_SN A WITH(NOLOCK),
						(
							SELECT	  SEGMENT2      AS OPERATION_GROUP
									, SEGMENT3      AS SCM_SITE_ID
									, SEGMENT4      AS LINE_ID
									, SEGMENT5      AS OPERATION_ID
									, ATTRIBUTE1    AS ORIGIN_DIVISION_ID
									, ATTRIBUTE2    AS DIVISION_ID
							FROM	SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							WHERE	1=1
								AND LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
								AND SEGMENT1	= 'SCP'
								AND VALID_YN	= 'Y'
						) C
				WHERE	1=1
					AND A.ACTIVE_FLAG   ='Y'
					AND A.DIVISION_ID   = C.ORIGIN_DIVISION_ID
					AND A.LINE_ID       = C.LINE_ID
					AND A.OPERATION_ID  = C.OPERATION_ID
			) A
	GROUP BY CODE, NAME, DIVISION_ID, OPERATION_GROUP, SITE_ID
	UNION ALL
	SELECT	  '-'  AS CODE
			, '-'  AS NAME
			, '-'  AS B
			, '-'  AS C
			, '-'  AS D
	ORDER BY	NAME
 END
	 ELSE IF (@Code = 'LineProdPlanLineSSP1' )
	 BEGIN
			SELECT DISTINCT
				A.LINE_ID                          AS CODE
				,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
				,C.ORIGIN_DIVISION_ID DIVISION_ID
				, C.OPERATION_GROUP
				, C.SCM_SITE_ID SITE_ID
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
			,'-'  AS B
			, '-'  AS C
			,'-'  AS ED
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
	ELSE IF (@Code = 'ToSiteBOD1' )
	 BEGIN
		 SELECT  SCM_SITE_ID   AS CODE
		   ,SCM_SITE_ID   AS NAME
		   ,SITE_TYPE
		   ,CITY
		   ,A.DIVISION_ID DIVISION_ID
		  FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
		 WHERE  A.VALID_YN  = 'Y'
		   AND (( @Param1 IS NULL OR  @Param1='' ) OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',') ))
		   --AND  A.SCM_SITE_ID NOT LIKE '%' + '-P'
		 UNION
		 SELECT  SCM_SITE_ID   AS CODE
		   , SCM_SITE_ID AS NAME
		   ,SITE_TYPE
		   ,CITY
		   ,A.DIVISION_ID
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
  최 종 작 성:  chaan
  수  정  자 :  chaan
  수 정 사 항:
  ===============================================*/
ELSE IF (@Code = 'ElecRoutePlantByOperation1' )
BEGIN
	SELECT	A.*
	FROM	(
				SELECT	  A.SCM_SITE_ID		AS CODE
						, A.DIVISION_ID + '   ' + A.SCM_SITE_ID + '   ' + A.SITE_DESCRIPTION + (CASE WHEN B.PLANT_SITE_ID IS NOT NULL THEN ' Y' ELSE ' N' END) AS NAME
						, A.DIVISION_ID
						, A.OPERATION_GROUP
						, B.ITEM_ID
				FROM	[dbo].[SCM_MST_SITE] A WITH(NOLOCK)
						LEFT JOIN (
									SELECT	  T.PLANT_SITE_ID
											, T.ITEM_ID
									FROM	SCP_MST_TACT_TIME T WITH(NOLOCK)
											JOIN SCM_MST_SITE S WITH(NOLOCK) ON
													S.SCM_SITE_ID	= T.PLANT_SITE_ID
											JOIN SCM_MST_LINE_SN LS WITH(NOLOCK) ON
													LS.COMPANY_ID	= S.COMPANY_ID
												AND LS.DIVISION_ID	= T.DIVISION_ID
												AND LS.SITE_ID		= S.SITE_ID
												AND LS.PLANT_ID		= S.PLANT_ID
												AND LS.OPERATION_ID	= T.OPERATION_ID
												AND LS.LINE_ID		= T.LINE_ID
												AND LS.ACTIVE_FLAG	= 'Y'
									WHERE	1=1
										AND T.VALID_YN		= 'Y'
									GROUP BY  T.ITEM_ID
											, T.PLANT_SITE_ID
                                    UNION ALL
									SELECT	  PLANT_SITE_ID
											, ITEM_ID
									FROM	SCP_MST_OUTSOURCING_CAPA WITH(NOLOCK)
									WHERE	1=1
										AND VALID_YN ='Y'
									GROUP BY  PLANT_SITE_ID
											, ITEM_ID
								) B ON
								A.SCM_SITE_ID = B.PLANT_SITE_ID
				WHERE	1=1
					AND A.VALID_YN ='Y'
					AND A.SITE_TYPE = 'PLANT'
			) A
    GROUP BY  DIVISION_ID
			, CODE
			, NAME
			, OPERATION_GROUP
			, ITEM_ID
	ORDER BY  DIVISION_ID
			, CODE;
END

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
ELSE IF (@Code = 'ToSiteShipmentPlanSEMI1' )
BEGIN
	SELECT	  A.TO_SITE AS CODE
			, CASE
				WHEN B.SITE_DESCRIPTION IS NULL		THEN A.TO_SITE
				WHEN B.SITE_DESCRIPTION IS NOT NULL THEN B.SITE_DESCRIPTION
			  END AS NAME
			, A.DIVISION_ID
			, A.OPERATION_GROUP
	FROM	(
				SELECT DISTINCT
						  SEGMENT3 AS TO_SITE
						, SEGMENT4 AS DIVISION_ID
						, SEGMENT2 AS OPERATION_GROUP
				FROM	SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
				WHERE	1=1
					AND LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_SEMI'
					AND SEGMENT1 = 'SCP'
					AND VALID_YN = 'Y'
			) A
			LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK) ON
					A.TO_SITE = B.SCM_SITE_ID
	ORDER BY  A.TO_SITE
			, A.DIVISION_ID
			, A.OPERATION_GROUP
END
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
ELSE IF (@Code = 'ToSiteShipmentPlanFG1' )
BEGIN
	SELECT    SEGMENT3 As CODE
            , SEGMENT3 As NAME
            , SEGMENT4 AS DIVISION_ID
            , SEGMENT2 AS OPERATION_GROUP
	FROM    SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	WHERE   1=1
        AND LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_FG'
		AND SEGMENT1 = 'SCP'
		AND VALID_YN = 'Y'
    GROUP BY  SEGMENT3
            , SEGMENT4
                , SEGMENT2
        ORDER BY SEGMENT3;
END
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
ELSE IF (@Code = 'ShipmentPlanSEMIToStie1' )
BEGIN
    SELECT    A.SCM_SITE_ID AS CODE
            , A.SCM_SITE_ID + '   '+A.SITE_DESCRIPTION AS NAME
            , A.DIVISION_ID
            , A.OPERATION_GROUP
    FROM    [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
    WHERE   1 = 1
        AND  A.VALID_YN  = 'Y'
        AND  A.SITE_TYPE = 'PLANT'
    ORDER BY CODE
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
	ELSE IF @Code = 'PlantSiteByDivision1'
	BEGIN
		SELECT '-' AS CODE, '-' AS NAME, '-' AS DIVISION_ID
		UNION ALL
		SELECT A.SCM_SITE_ID AS CODE
			, A.SITE_DESCRIPTION AS NAME
			,A.DIVISION_ID
		FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
		AND    A.SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		AND    ( ( @Param1 IS NULL OR  @Param1='' ) OR A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,',')))
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
 ELSE IF (@Code = 'ToSiteByDivision1' )
	 BEGIN
		SELECT	 SCM_SITE_ID			AS	CODE
				,SCM_SITE_ID			AS	NAME
				,SITE_TYPE
				,CITY
				,A.DIVISION_ID
		FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
		WHERE   A.VALID_YN  = 'Y'
		AND			CASE WHEN (@Param1 = 'ALL' OR @Param1 ='') THEN @Param1
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
	 ELSE IF @Code = 'FromSiteByDivision1'
	BEGIN
	    Declare @AuthTypeParaDivision1 varchar(100) = 'D'
		if(@Param1 = 'JV Planner') SET @AuthTypeParaDivision1 = 'J';
		SELECT	SCM_SITE_ID        AS CODE
			,	SCM_SITE_ID		   AS NAME
			,   CITY
			,   OSP_YN
			,   A.DIVISION_ID      AS DIVISION_ID
		FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
		WHERE SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		AND CASE WHEN (@Param1 = 'ALL' OR @Param1 ='') THEN @Param1
					ELSE A.DIVISION_ID
			END  IN (  SELECT token FROM dbo.String_Split(@Param1,',')	 )
		AND   A.DIVISION_ID IN (SELECT CODE							--2018-02-14 진준희 수정
									FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)
					    			WHERE  GroupID LIKE '%'+ @Param2 + '%'
									AND    UserID  LIKE '%'+ @Param3 + '%'
									AND    AuthType = @AuthTypeParaDivision1)
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
	 ELSE IF (@Code = 'ToSiteByDivisionPlant1' )
	 BEGIN
		SELECT	 SCM_SITE_ID			AS	CODE
				,SCM_SITE_ID			AS	NAME
				,SITE_TYPE
				,CITY
				,A.DIVISION_ID			AS  DIVISION_ID
		FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
		WHERE   A.VALID_YN  = 'Y'
		AND			CASE WHEN (@Param1 = 'ALL' OR @Param1 ='') THEN @Param1
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
	용		 도:  Plant Site
	사 용 화 면:  Line Master, Loss Time, Formation, Tack Time
	변       수:  -
	최 초 작 성:  2018. 09. 19
	개  발 자 :  ygkim
	최 종 작 성:  -
	수  정  자 :  -
	수 정 사 항:  2019.11.21	yhw	OSPYN, OPERATION GROUP, DIVISION_ID 추가
	===============================================*/
	ELSE IF @Code = 'PlantByDivisionOperNonOsp1'
	BEGIN
        SELECT    A.SCM_SITE_ID         AS CODE
                , A.SITE_DESCRIPTION    AS NAME
                , A.OSP_YN
                , A.OPERATION_GROUP
                , A.DIVISION_ID
        FROM    [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
        WHERE   1=1
            AND A.SITE_TYPE = 'PLANT'
            AND A.VALID_YN  = 'Y'
            ANd A.OSP_YN    = 'N'
	END
	ELSE IF @Code = 'PlantByDivisionOperNonOsp12'
	BEGIN
		SELECT A.SCM_SITE_ID AS CODE
			, A.SITE_DESCRIPTION AS NAME
			,A.OSP_YN
			,A.DIVISION_ID
		FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
		AND    A.SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		ANd    A.OSP_YN = 'N'
		AND   ( ( @Param1 IS NULL OR  @Param1='' ) OR  A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,',')))
		AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )
	END
ELSE IF @Code = 'PlantByDivisionOperNonOsp123'
BEGIN
	SELECT    A.SCM_SITE_ID         AS CODE
		    , A.SITE_DESCRIPTION    AS NAME
		    , A.DIVISION_ID
	FROM    [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
	WHERE   1=1
	    AND A.SITE_TYPE = 'PLANT'
	    AND A.VALID_YN  = 'Y'
	    ANd A.OSP_YN    = 'N'
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
	ELSE IF @Code = 'PlantByDivisionOperOsp1'
	BEGIN
		SELECT A.SCM_SITE_ID AS CODE
			, A.SITE_DESCRIPTION AS NAME
			, A.DIVISION_ID
			,A.OPERATION_GROUP
		FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
		AND    A.SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		ANd    A.OSP_YN = 'Y'
		AND   ( ( @Param1 IS NULL OR  @Param1='' ) OR A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,',')))
		AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )
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
	 ELSE IF @Code = 'PlantByDivisionOperOsp21'
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
		AND    ( ( @Param1 IS NULL OR  @Param1='' ) OR A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,',')))
		AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )
	END
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
	 ELSE IF @Code = 'PlantByDivisionOperOsp4'
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
		AND    ( ( @Param1 IS NULL OR  @Param1='' ) OR A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,',')))
		AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )
		AND  ( ( @Param3 IS NULL OR  @Param3='' ) OR  ISNULL(A.ATTRIBUTE1,'N') = @Param3 )
	END
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
	ELSE IF @Code = 'LineByOperationAddOSP1'
	BEGIN
        SELECT    CODE
                , NAME
                , DIVISION_ID
                , PLANT_ID
                , OPERATION_GROUP
                , SITE_ID
        FROM    (
                    SELECT    A.LINE_ID						   AS CODE
		                    , A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
		                    , A.DIVISION_ID
		                    , A.PLANT_ID                       AS PLANT_ID
		                    , A.OPERATION_ID                   AS OPERATION_GROUP
		                    , B.SCM_SITE_ID                    AS SITE_ID
                    FROM	[dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
		                    JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON
				                    A.COMPANY_ID	= B.COMPANY_ID
			                    AND A.SITE_ID		= B.SITE_ID
			                    AND A.DIVISION_ID	= B.DIVISION_ID
			                    AND A.PLANT_ID		= B.PLANT_ID
		                    INNER JOIN (
						                    SELECT DISTINCT
								                    b.segment4, b.segment1
						                    FROM	SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
						                    WHERE	1=1
							                    AND B.LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
							                    AND    B.VALID_YN    = 'Y'
							                    AND    B.SEGMENT3    = 'Y' -- CAPA 세부 공정 여부
					                    ) F ON
				                    A.OPERATION_ID = F.SEGMENT4
                    WHERE	1=1
	                    AND A.ACTIVE_FLAG = 'Y'
                    UNION
                    -- 외주
                    SELECT    A.LINE_ID						   AS CODE
		                    , A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
		                    , A.DIVISION_ID
		                    , B.PLANT_ID                       AS PLANT_ID
		                    , A.OPERATION_ID                   AS OPERATION_GROUP
		                    , B.SCM_SITE_ID                    AS SITE_ID
                    FROM	[dbo].SCM_MST_LINE_OSP A WITH(NOLOCK)
		                    JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
                    WHERE	1=1
	                    AND B.ATTRIBUTE1 = 'Y'
                    UNION
                    --Isuzu : P5000
                    SELECT    A.LINE_ID						   AS CODE
		                    , A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
		                    , A.DIVISION_ID
		                    , A.PLANT_ID                       AS PLANT_ID
		                    , A.OPERATION_ID                   AS OPERATION_GROUP
		                    , B.SCM_SITE_ID                    AS SITE_ID
                    FROM	[dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
		                    JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON
				                    A.COMPANY_ID	= B.COMPANY_ID
			                    AND A.SITE_ID		= B.SITE_ID
			                    AND A.DIVISION_ID	= B.DIVISION_ID
			                    AND A.PLANT_ID		= B.PLANT_ID
                    WHERE	1=1
	                    AND A.ACTIVE_FLAG	='Y'
	                    AND A.PLANT_ID		= @v_G182
	                    AND A.OPERATION_ID	= 'P5000'
                ) A
        GROUP BY  CODE
		        , NAME
		        , DIVISION_ID
		        , PLANT_ID
		        , OPERATION_GROUP
		        , SITE_ID
        ORDER BY NAME
	END
	ELSE IF @Code = 'LineByOperationAddOSP2'
	BEGIN
		SELECT
				DISTINCT
				A.LINE_ID						  AS CODE
			, A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
			,A.DIVISION_ID
			, A.PLANT_ID PLANT_ID
			,A.FACTORY_ID
			, A.OPERATION_ID OPERATION_GROUP
			, B.SCM_SITE_ID SITE_ID
			FROM [dbo].SCM_MST_LINE_SN A WITH(NOLOCK)
			JOIN [dbo].SCM_MST_SITE B WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND  A.DIVISION_ID = B.DIVISION_ID
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
		-- 외주
		SELECT
				DISTINCT
				A.LINE_ID						AS CODE
			, A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
			, A.DIVISION_ID
			, B.PLANT_ID PLANT_ID
			,'' AS FACTORY_ID
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
				, A.DIVISION_ID
				, A.PLANT_ID PLANT_ID
				,A.FACTORY_ID
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
			AND A.PLANT_ID = @v_G182
			and A.OPERATION_ID = 'P5000'
		ORDER BY NAME
		-- 2022/08/31 end
	END

/*===============================================
	용		 도:  LINE 정보 조회
	사 용 화 면:  SCP0104
	변       수:
	최 초 작 성:  2024. 02. 21
	개  발  자 :  chaan
	수  정  자 :  chaan
	수 정 사 항:  
				 후공정 라인 제외
	===============================================*/
ELSE IF @Code = 'LineByOperationPlantId'
BEGIN
    SELECT    A.LINE_ID						    AS CODE
            , A.LINE_ID  + ' ' + A.LINE_NAME	AS NAME
            , A.DIVISION_ID                     AS DIVISION_ID
            , A.OPERATION_GROUP_ID              AS SHOP_GROUP_ID
            , A.PLANT_ID                        AS PLANT_ID
            , A.FACTORY_ID                      AS FACTORY_ID
    FROM    SCM_LINE_HIERARCHY_CPS_V_SN A WITH(NOLOCK)
    WHERE   1=1
        ------AND NOT EXISTS (
        ------                    SELECT  1
        ------                    FROM    SCM_SYS_LOOKUP_VALUE_SN B WITH(NOLOCK)
        ------                    WHERE   1=1
        ------                        AND B.LOOKUP_TYPE_CODE  = 'CAPA_UI_EXCEPT_LINE'
        ------                        AND B.ACTIVE_FLAG		= 'Y'
        ------                        AND A.DIVISION_ID		= B.SEGMENT1
        ------                        AND A.PLANT_ID		    = B.SEGMENT2
        ------                        AND A.LINE_ID			= B.SEGMENT4
        ------                        AND A.OPERATION_ID	    = B.SEGMENT3
        ------                        AND A.ELECTRODE_TYPE	= B.SEGMENT5
        ------               )
    GROUP BY      A.LINE_ID
                , A.LINE_NAME
                , A.DIVISION_ID
                , A.OPERATION_GROUP_ID
                , A.PLANT_ID
                , A.FACTORY_ID
    ORDER BY    A.LINE_ID;
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
	ELSE IF @Code = 'MDMVersionId1'
	BEGIN
		SELECT TOP 30 CODE , NAME , DIVISION_ID, SHOP_GROUP_ID
		 FROM (
			SELECT DISTINCT VERSION_ID	AS CODE
				 , VERSION_ID	+ '  ' + VERSION_NAME		AS NAME
				 ,A.DIVISION_ID AS DIVISION_ID
				 ,A.SCP_USE_FLAG AS SHOP_GROUP_ID
			 FROM SCM_MASTER_VERSION_INFO_H_SN A WITH(NOLOCK)
			  WHERE 1 = 1
			  AND ( (@Param1 IS NULL or @Param1='') OR (DIVISION_ID = 'EE' OR DIVISION_ID = @Param1 ))
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
	수  정  자 :  chaan
	수 정 사 항:  
	===============================================*/
ELSE IF @Code = 'BuildingByShopGroupId1'
BEGIN
    SELECT    A.FACTORY_ID      AS CODE
            , A.FACTORY_NAME    AS NAME
            , A.DIVISION_ID
            , A.SHOP_GROUP_ID
            , A.SITE_ID
            , A.PLANT_ID
    FROM    [dbo].[SCM_MST_FACTORY_SN] A WITH(NOLOCK)
    WHERE   1=1
        AND ISNULL(A.ACTIVE_FLAG,'N') = 'Y'
    GROUP BY  A.FACTORY_ID
            , A.FACTORY_NAME
            , A.DIVISION_ID
            , A.SHOP_GROUP_ID
            , A.SITE_ID
            , A.PLANT_ID;
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
    SELECT    SHOP_GROUP_ID     AS CODE
            , OPERATION_GROUP   AS NAME
            , A.DIVISION_ID     AS DIVISION_ID
    FROM SCM_SITE_HIERARCHY_CPS_V_SN A WITH(NOLOCK)
    GROUP BY  SHOP_GROUP_ID
            , OPERATION_GROUP
            , A.DIVISION_ID
END
/*===============================================
	용		 도:  plant 조회
	사 용 화 면:  SCP0104
	변       수:
	최 초 작 성:  2020. 09. 10
	개  발  자 :  chaan
	수  정  자 :  chaan
	수 정 사 항:  SHOP_GROUP_ID 파라미터 추가
	===============================================*/
ELSE IF @Code = 'PlantByGroup'
BEGIN
    SELECT    PLANT_ID       AS CODE
            , PLANT_NAME     AS NAME
            , DIVISION_ID    AS DIVISION_ID
            , SHOP_GROUP_ID
    FROM    SCM_SITE_HIERARCHY_CPS_V_SN WITH(NOLOCK)
    GROUP BY  PLANT_ID
            , PLANT_NAME
            , DIVISION_ID
            , SHOP_GROUP_ID
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
ELSE IF @Code = 'PlantByGroup1'
BEGIN
    SELECT    PLANT_ID       AS CODE
            , PLANT_NAME     AS NAME
            , DIVISION_ID    AS DIVISION_ID
    FROM    SCM_SITE_HIERARCHY_CPS_V_SN WITH(NOLOCK)
    GROUP BY  PLANT_ID
            , PLANT_NAME
            , DIVISION_ID
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
ELSE IF @Code = 'FnVersionByDivisionId1'
BEGIN
	SELECT	  'PP_W_' + A.PLAN_START_YYYYMMDD								AS CODE
			, 'PP_W_' + A.PLAN_START_YYYYMMDD  + ' (' + B.WEEK_NAME + ')'	AS NAME
			, A.DIVISION_ID
	FROM	SCP_PLAN_VERSION_V A WITH(NOLOCK)
			INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON
					A.PLAN_START_YYYYMMDD = B.BASIS_YYYYMMDD
	WHERE	1=1
		AND A.PLAN_TYPE      = 'FN'
		AND A.CONFIRM_FLAG   = 'Y'
		AND A.UI_DISPLAY_YN  = 'Y'
		AND A.ACTIVE_FLAG    = 'Y'
	ORDER BY A.plan_start_yyyymmdd DESC;
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
	ELSE IF @Code = 'PlanDate_REPORT1'
	BEGIN
		SELECT DISTINCT CODE
			 , NAME
			 ,A.DIVISION_ID
		  FROM ( SELECT BASIS_YYYYMMDD AS CODE
					  , DATE_FULL_NAME +' ('+ WEEK_NAME + ')' AS NAME--CALENDAR_YYYY +'-'+ WEEK_NAME AS NAME
					  , '' AS DIVISION_ID
				   FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
				  WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8), DATEADD(WK,DATEDIFF(WK,0,GETDATE()),0) ,112)
				  UNION ALL
				 SELECT PLAN_START_YYYYMMDD AS CODE
					  , B.DATE_FULL_NAME +' ('+ B.WEEK_NAME + ')' AS NAME--B.CALENDAR_YYYY +'-'+ B.WEEK_NAME AS NAME
					  ,A.DIVISION_ID
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
	변       수:
	최 초 작 성:  2024. 01. 11
	개  발  자 :  chaan
	최 종 작 성:  2024. 01. 11
	수  정  자 :
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'Plant_REPORT1'
BEGIN
    SELECT    X.DIVISION_ID
		    , X.PLANT_ID
		    , X.PLANT_NAME
    FROM	(
			    SELECT	  A.DIVISION_ID
					    , A.PLANT_ID
					    , CASE
						    WHEN B.DESCRIPTION IS NULL THEN ISNULL(B.PLANT_NAME, V.VENDOR_NAME)
						    ELSE B.DESCRIPTION
					      END	AS PLANT_NAME
			    FROM	SCM_MST_SITE  A WITH(NOLOCK)
					    LEFT JOIN SCM_PLANT_M_SN B WITH(NOLOCK) ON
							    A.DIVISION_ID	= B.DIVISION_ID
						    AND A.PLANT_ID		= B.PLANT_ID
					    LEFT OUTER JOIN  SCM_MST_VENDOR V WITH(NOLOCK) ON
							    V.VENDOR_CODE	= A.PLANT_ID
						    AND V.COMPANY_ID	= A.COMPANY_ID
			    WHERE	1=1
				    AND SITE_TYPE	= 'PLANT'
				    AND A.VALID_YN	='Y'
				    AND (A.DIVISION_ID NOT IN ('EE','EE_UC') AND OPERATION_GROUP IN  ('A','P' ))
				    AND OSP_YN = 'N'
			    UNION ALL
			    -- 82 외주 추가
			    SELECT	  A.DIVISION_ID
					    , A.PLANT_ID
					    , CASE
						    WHEN V.ATTRIBUTE1 IS NULL THEN ISNULL(B.PLANT_NAME, V.VENDOR_NAME)
						    ELSE V.ATTRIBUTE1
					      END	AS PLANT_NAME
			    FROM	SCM_MST_SITE  A WITH(NOLOCK)
					    LEFT JOIN SCM_PLANT_M_SN B WITH(NOLOCK) ON
							    A.DIVISION_ID	= B.DIVISION_ID
						    AND A.PLANT_ID		= B.PLANT_ID
					    LEFT OUTER JOIN SCM_MST_VENDOR V WITH(NOLOCK) ON
							    V.VENDOR_CODE	= A.PLANT_ID
						    AND V.COMPANY_ID	= A.COMPANY_ID
			    WHERE	1=1
				    AND SITE_TYPE		= 'PLANT'
				    AND A.VALID_YN		='Y'
				    AND OPERATION_GROUP IN ('A','P' )
				    AND OSP_YN			= 'Y'
				    AND A.DIVISION_ID	= '82'
			    UNION ALL
			    -- 전극
			    SELECT	  A.DIVISION_ID
					    , A.PLANT_ID
					    , B.PLANT_NAME
			    FROM	SCM_MST_SITE  A WITH(NOLOCK)
					    LEFT JOIN SCM_PLANT_M_SN B WITH(NOLOCK) ON
							    A.DIVISION_ID	= B.DIVISION_ID
						    AND A.PLANT_ID		= B.PLANT_ID
			    WHERE	1=1
				    AND SITE_TYPE = 'PLANT'
				    AND A.VALID_YN  ='Y'
				    AND A.OSP_YN = 'N'
				    AND ((A.DIVISION_ID IN ('EE','EE_UC')) AND  OPERATION_GROUP = 'E')
		    ) X
    GROUP BY  X.DIVISION_ID
            , X.PLANT_ID
            , X.PLANT_NAME
    ORDER BY  X.DIVISION_ID
            , X.PLANT_ID
            , X.PLANT_NAME;
END
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
ELSE IF @Code = 'PlantByDivisionOperationItem1'
BEGIN
	IF OBJECT_ID (N'tempdb..#TblPlantByDivisionOperationItem_X1', N'U') IS NOT NULL
		DROP TABLE #TblPlantByDivisionOperationItem_X1
    SELECT	  S.SCM_SITE_ID
            , S.SITE_DESCRIPTION
            , PLANT_ID
            , OSP_YN
            , COMPANY_ID
            , SITE_ID
			,S.DIVISION_ID
			,S.OPERATION_GROUP
    INTO    #TblPlantByDivisionOperationItem_X1
    FROM	[dbo].[SCM_MST_SITE] S  WITH(NOLOCK)
    WHERE	1 = 1
        AND S.VALID_YN ='Y'
        AND S.SITE_TYPE = 'PLANT'
        AND ((@Param1 IS NULL OR  @Param1='') OR  S.DIVISION_ID     IN (SELECT token FROM dbo.String_Split(@Param1,',')))
        AND ((@Param2 IS NULL OR  @Param2='') OR  S.OPERATION_GROUP IN (SELECT token FROM dbo.String_Split(@Param2,',')))
	CREATE CLUSTERED INDEX IDX_#TblPlantByDivisionOperationItem_X1 ON #TblPlantByDivisionOperationItem_X1 (OSP_YN, PLANT_ID);
	IF OBJECT_ID (N'tempdb..#TblPlantByDivisionOperationItem_A1', N'U') IS NOT NULL
		DROP TABLE #TblPlantByDivisionOperationItem_A1
    -- 외주가 아니면 해당 PLANT만
    SELECT  A.*
    INTO    #TblPlantByDivisionOperationItem_A1
    FROM    (
                SELECT  *
                FROM    #TblPlantByDivisionOperationItem_X1
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
                FROM    #TblPlantByDivisionOperationItem_X1
                WHERE   OSP_YN = 'Y'
            ) A
	IF OBJECT_ID (N'tempdb..#TblPlantByDivisionOperationItem_ESS1', N'U') IS NOT NULL
		DROP TABLE #TblPlantByDivisionOperationItem_ESS1
    SELECT  A.*
    INTO    #TblPlantByDivisionOperationItem_ESS1
    FROM    (
                SELECT DISTINCT
                        T.PLANT_SITE_ID
						,T.ITEM_ID
						,T.DIVISION_ID
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
						,T.DIVISION_ID
						, T.ITEM_ID  ITEM_ID
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
	CREATE CLUSTERED INDEX IDX_TblPlantByDivisionOperationItem_ESS1 ON #TblPlantByDivisionOperationItem_ESS1 (PLANT_SITE_ID);
    SELECT DISTINCT
              A.SCM_SITE_ID AS CODE
            , A.SCM_SITE_ID + '   ' +
              A.SITE_DESCRIPTION + ' ' +
              CASE
                WHEN B.PLANT_SITE_ID IS NOT NULL THEN  'Y'
                ELSE 'N'
              END AS NAME
			  , A.DIVISION_ID
			  , A.OPERATION_GROUP
			  , B.ITEM_ID
    FROM    #TblPlantByDivisionOperationItem_A1 A  WITH(NOLOCK)
            LEFT JOIN
                (
                    SELECT DISTINCT
                            PLANT_SITE_ID
							,ITEM_ID
                    FROM    #TblPlantByDivisionOperationItem_ESS1
                ) B ON A.SCM_SITE_ID = B.PLANT_SITE_ID
    ORDER BY CODE
	IF OBJECT_ID (N'tempdb..#TblPlantByDivisionOperationItem_X1', N'U') IS NOT NULL
		DROP TABLE #TblPlantByDivisionOperationItem_X1
	IF OBJECT_ID (N'tempdb..#TblPlantByDivisionOperationItem_A1', N'U') IS NOT NULL
		DROP TABLE #TblPlantByDivisionOperationItem_A1
	IF OBJECT_ID (N'tempdb..#TblPlantByDivisionOperationItem_ESS1', N'U') IS NOT NULL
		DROP TABLE #TblPlantByDivisionOperationItem_ESS1
END
	ELSE IF @Code = 'WaterfallVer21'
	BEGIN
        SELECT	  CODE
		        , NAME
		        , DIVISION_ID
        FROM	(
			        SELECT	  'PP_W_'+ A.PLAN_START_YYYYMMDD	AS CODE
					        , CASE
						        WHEN FP_TARGET_YN = 'Y' THEN 'PP_W_'+ A.PLAN_START_YYYYMMDD + ' (' + B.WEEK_NAME + ')'
						        ELSE 'PP_W_'+ A.PLAN_START_YYYYMMDD + ' (' + B.WEEK_NAME + ')' + ' (No Plan)'
					          END								AS NAME
					        , C.DIVISION_ID
			        FROM	SCP_PLAN_VERSION_V A WITH(NOLOCK)
					        INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON
							        A.PLAN_START_YYYYMMDD = B.BASIS_YYYYMMDD
					        LEFT JOIN
								        (
									        SELECT	  DIVISION_ID
											        , PLAN_START_YYYYMMDD
											        , FP_TARGET_YN
											        , MRP_TARGET_YN
											        , DM_RTF_YN
									        FROM	[dbo].[SCP_PLN_INTERFACE_YN] WITH(NOLOCK)
								        ) C ON
							        A.PLAN_START_YYYYMMDD = C.PLAN_START_YYYYMMDD	
		                        AND A.DIVISION_ID         = C.DIVISION_ID 
			        WHERE	1=1
				        AND PLAN_TYPE		= 'FN'
				        AND CONFIRM_FLAG	= 'Y'
		        ) A
        GROUP BY  CODE
		        , NAME
		        , DIVISION_ID
        ORDER BY A.NAME DESC
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
ELSE IF @Code = 'WaterfallVer_FG21'
BEGIN
    SELECT    A.CODE
		    , A.NAME
		    , A.DIVISION_ID
    FROM	(
			    SELECT	  'SP_W_'+A.PLAN_START_YYYYMMDD	AS CODE
					    , CASE
						    WHEN FP_TARGET_YN = 'Y' THEN 'SP_W_'+A.PLAN_START_YYYYMMDD + ' (' + B.WEEK_NAME + ')'
						    ELSE 'SP_W_'+A.PLAN_START_YYYYMMDD + ' (' + B.WEEK_NAME + ')' + ' (No Plan)'
					      END							AS NAME
					    , A.DIVISION_ID
			    FROM	SCP_PLAN_VERSION_V A WITH(NOLOCK)
					    INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON
							    A.PLAN_START_YYYYMMDD = B.BASIS_YYYYMMDD
					    LEFT JOIN (
								    SELECT	  DIVISION_ID
										    , PLAN_START_YYYYMMDD
										    , FP_TARGET_YN
										    , MRP_TARGET_YN
										    , DM_RTF_YN
								    FROM	[dbo].[SCP_PLN_INTERFACE_YN] WITH(NOLOCK)
							      ) C ON
							    A.PLAN_START_YYYYMMDD = C.PLAN_START_YYYYMMDD	
		                    AND A.DIVISION_ID         = C.DIVISION_ID 
			    WHERE	1=1
				    AND PLAN_TYPE		='FN'
				    AND CONFIRM_FLAG	='Y'
		    ) A
    GROUP BY  A.CODE
		    , A.NAME
		    , A.DIVISION_ID
    ORDER BY A.CODE DESC;
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
ELSE IF @Code = 'PlantSitePackerHoldStock1'
BEGIN
	SELECT DISTINCT
			SCM_SITE_ID AS CODE
			, SCM_SITE_ID AS NAME
			, S.DIVISION_ID
	FROM   SCM_MST_SITE S WITH(NOLOCK)
	WHERE  1 = 1
	AND    SITE_TYPE = 'PLANT'
	AND    OSP_YN = 'Y'
	AND    ((@Param1 IS NULL OR @Param1='') OR S.DIVISION_ID=@Param1)
	ORDER BY 1,2
END
 /*===============================================
용		 도:  StorageByDivPlant1
사 용 화 면:  SCP0001
변       수:
최 초 작 성:  2024. 01. 15
개  발  자 :  maintt26
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'StorageByDivPlant1'
BEGIN
	SELECT DISTINCT
		  STORAGE_ID                                AS CODE
		, (STORAGE_ID + '  ' + STORAGE_DESCRIPTION) AS NAME
		, DIVISION_ID
		, PLANT_ID
	FROM	SCM_MST_SLOC WITH(NOLOCK)
	WHERE  1=1
		AND	( (@Param1 IS NULL OR @Param1 = '') OR DIVISION_ID IN (SELECT token FROM dbo.String_Split(@Param1	,',')) )
		AND ( (@Param2 IS NULL OR @Param2 = '') OR (@Param2 = '' OR PLANT_ID = @Param2))
END
ELSE IF @Code = 'BuildingByDivision1'
		BEGIN
			SELECT
			  DISTINCT
					A.FACTORY_ID    AS CODE
				  , A.FACTORY_NAME  AS NAME
				 , A.DIVISION_ID
			 FROM  [dbo].[SCM_MST_FACTORY_SN] A WITH(NOLOCK)
			 WHERE 1=1
				AND ( (@Param1 IS NULL or @Param1='') OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,','))  )
				AND ( (@Param2 IS NULL or @Param2='') OR A.PLANT_ID IN ( SELECT token FROM dbo.String_Split(@Param2,','))  )
		END
		IF @Code = 'BuildingByPlant1'
		BEGIN
			SELECT
			  DISTINCT
				   A.FACTORY_ID    AS CODE
				  , A.FACTORY_NAME  AS NAME
				  ,PLANT_ID
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
	-- Param1 = Division ID
		IF @Code = 'Customer1'
			BEGIN
				SELECT SOLDTO_CODE AS CODE, SOLDTO_DESCRIPTION AS NAME, A.DIVISION_ID FROM SCM_MST_CUSTOMER A
				WHERE (( @Param1 IS NULL OR  @Param1='' ) OR DIVISION_ID = @Param1)
					  AND
					  (
						(( @Param2 IS NULL OR  @Param2='' ) OR SOLDTO_CODE LIKE '%' + @Param2 + '%') OR (( @Param2 IS NULL OR  @Param2='' ) OR SOLDTO_DESCRIPTION LIKE '%' + @Param2 + '%')
					  )
				group by SOLDTO_CODE,	SOLDTO_DESCRIPTION, A.DIVISION_ID
				ORDER BY SOLDTO_DESCRIPTION
			END
	ELSE IF @Code = 'DATE_WEEKLY1'
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
	   		  AND (( @Param1 IS NULL OR  @Param1='' ) OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@Param1,',')))
  		 ) C ON A.plan_start_yyyymmdd = C.PLAN_START_YYYYMMDD	
		    AND A.DIVISION_ID         = C.DIVISION_ID 
		 WHERE 1=1
		   AND (( @Param1 IS NULL OR  @Param1='' ) OR A.division_id= @Param1 )
  		   AND (( @Param2 IS NULL OR  @Param2='' ) OR A.version_id = @Param2 )
		 GROUP BY A.plan_start_yyyymmdd, B.WEEK_NAME, C.FP_TARGET_YN, A.DIVISION_ID
		 ORDER BY A.plan_start_yyyymmdd DESC
		;
	END
		IF @Code = 'FromSiteByDivision1Ex'
		BEGIN
			Declare @AuthTypeParaDivision1Ex varchar(100) = 'D'
			if(@Param2 = 'JV Planner') SET @AuthTypeParaDivision1Ex = 'J';
			SELECT	SCM_SITE_ID        AS CODE
				,	SCM_SITE_ID		   AS NAME
				, A.DIVISION_ID		   AS DIVISION_ID
				 --, SITE_DESCRIPTION   AS NAME 2018-02-12 진준희 수정
			FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)
			WHERE SITE_TYPE = 'PLANT'
			AND    A.VALID_YN  = 'Y'
			AND CASE WHEN (@Param1 is null OR @Param1 ='' OR @Param1 = 'ALL') THEN @Param1
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
								     AND    AuthType = @AuthTypeParaDivision1Ex)
		END
ELSE IF @Code = 'GLOBAL_PSI_ELEC_DATE1'
BEGIN
    SELECT    A.PLAN_START_YYYYMMDD                                                                     AS CODE
            , CONVERT(VARCHAR, CONVERT(DATE, A.PLAN_START_YYYYMMDD), 121) + ' (' + B.WEEK_NAME + ')'    AS NAME
			, A.DIVISION_ID
    FROM    (
                SELECT DISTINCT
                        PLAN_START_YYYYMMDD
						,DIVISION_ID
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
    GROUP BY A.PLAN_START_YYYYMMDD, B.WEEK_NAME , A.DIVISION_ID
    ORDER BY A.PLAN_START_YYYYMMDD DESC
END
	ELSE IF @Code = 'LineByOperation1'
		BEGIN
			  SELECT
				DISTINCT
					 A.LINE_ID						  AS CODE
					,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
					,A.DIVISION_ID
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
					,'-'  AS DIVISION_ID
					,'-'  AS SCM_SITE_ID
				ORDER BY NAME
		END
	ELSE IF @Code = 'LineByOperation2'
		BEGIN
			  SELECT
				DISTINCT
					 A.LINE_ID						  AS CODE
					,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
					,A.DIVISION_ID
					,A.FACTORY_ID
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
					,'-'  AS DIVISION_ID
					,'-'  AS FACTORY_ID
					,'-'  AS OPERATION_ID
					,'-'  AS SCM_SITE_ID
				ORDER BY NAME
		END
ELSE IF @Code = 'Location1'
	BEGIN
		--SELECT B.LOOKUP_CODE CODE, B.DESCRIPTION NAME
		--FROM SCM_ADM_LOOKUP_TYPE A WITH(NOLOCK)
		--INNER JOIN SCM_ADM_LOOKUP_VALUES B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE
		--WHERE A.LOOKUP_TYPE = 'LOCATION_GROUP'
		--  AND @Param1 = '' OR B.SEGMENT1 = @Param1
		--ORDER BY B.DISPLAY_SEQ
		SELECT B.SEGMENT1 CODE, B.SEGMENT2 NAME, A.LOOKUP_TYPE LOOKUP_TYPE
		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE
		WHERE A.LOOKUP_TYPE = 'LOCATION_GROUP'
			AND (@Param1 = '' OR B.SEGMENT3 = @Param1)
		ORDER BY B.DISPLAY_SEQ
	END
ELSE IF @Code = 'LookupCommon1'
BEGIN
	SELECT B.SEGMENT1 CODE
			,B.SEGMENT2 NAME
			,A.LOOKUP_TYPE
	FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
	INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
	WHERE( ( @Param1 IS NULL OR  @Param1='' ) OR A.LOOKUP_TYPE = @Param1)
		AND A.VALID_YN = 'Y'
	ORDER BY B.DISPLAY_SEQ
END
ELSE IF @Code = 'OperationByBuilding1'
BEGIN
	SELECT
	DISTINCT
		A.OPERATION_ID    AS CODE
		, (A.OPERATION_ID + ' ' + B.OPERATION_NAME)  AS NAME, A.OPERATION_ID
		, A.DIVISION_ID   AS DIVISION_ID
		, A.SITE_ID   AS  SITE_ID
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
	AND ( (@Param4 IS NULL or @Param4='') OR A.SITE_ID IN
			( SELECT token FROM dbo.String_Split(@Param4,',')
			--SELECT t.c.value('.', 'NVARCHAR(4000)')
			--FROM   (SELECT x = CAST('<t>' + REPLACE(@Param3, ',', '</t><t>') + '</t>' AS xml)) b
			--CROSS APPLY x.nodes('/t') t(c)
			)
	)
	ORDER BY A.OPERATION_ID
END
ELSE IF @Code = 'OperationByLine'
BEGIN
	SELECT	  A.OPERATION_ID							AS CODE
			, A.OPERATION_ID + ' ' + B.OPERATION_NAME	AS NAME
			, A.DIVISION_ID								AS DIVISION_ID
			, A.OPERATION_GROUP_ID						AS SHOP_GROUP_ID
			, A.PLANT_ID								AS PLANT_ID
			, A.FACTORY_ID								AS FACTORY_ID
			, A.LINE_ID									AS LINE_ID
	FROM	[dbo].SCM_LINE_HIERARCHY_CPS_V_SN A  WITH(NOLOCK)
			JOIN (
					SELECT DISTINCT 
							  OPERATION_ID 
							, OPERATION_NAME
					FROM	[dbo].SCM_MST_OPERATION_SN B WITH(NOLOCK)
				) B ON  
					A.OPERATION_ID = B.OPERATION_ID
	GROUP BY  A.OPERATION_ID
			, B.OPERATION_NAME
			, A.DIVISION_ID
			, A.OPERATION_GROUP_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
    ORDER BY  A.OPERATION_ID;
END
ELSE IF @Code = 'PlanSeq1'
BEGIN
	SELECT plan_seq as CODE
	  		-- ,convert(varchar, plan_seq)+ ' - ' + isnull(confirm_flag,'N') AS NAME
			,( convert(varchar, plan_seq)+ ' - ' + (case when confirm_flag is null or confirm_flag ='' then 'N'
														when confirm_flag = 'Y' then 'Confirm' end) )AS NAME
            ,division_id DIVISION_ID
			,plan_start_yyyymmdd PLANDATE
			,plan_type  PLANTYPE
		FROM SCP_PLAN_VERSION_V WITH(NOLOCK)
	WHERE 1=1
		and  ( ( @Param1 IS NULL OR  @Param1='' ) OR division_id  = @Param1)
		and ( ( @Param2 IS NULL OR  @Param2='' ) OR plan_start_yyyymmdd = @Param2 )
		and ( ( @Param3 IS NULL OR  @Param3='' ) OR plan_type           = @Param3 )
		AND ( ( @Param4 IS NULL OR  @Param4='' ) OR version_id		  = @Param4 )
	GROUP BY plan_seq,confirm_flag, division_id, plan_start_yyyymmdd, plan_type
	ORDER BY plan_seq DESC
END
ELSE IF @Code = 'PlanType1'
BEGIN
    SELECT	  PLAN_TYPE				AS CODE
		    , PLAN_TYPE				AS NAME
		    , MAX(PLAN_TYPE_ORDER)	AS PLAN_TYPE_ORDER
		    , DIVISION_ID			AS DIVISION_ID
		    , PLAN_START_YYYYMMDD	AS PLANDATE
    FROM	SCP_PLAN_VERSION_V WITH(NOLOCK)
    WHERE	1=1
    GROUP BY	  PLAN_TYPE
			    , DIVISION_ID
			    , PLAN_START_YYYYMMDD
    ORDER BY	  PLAN_TYPE_ORDER
			    , DIVISION_ID
			    , PLAN_START_YYYYMMDD
END
ELSE IF @Code = 'PlanWeek1'
BEGIN
	SELECT   B.WEEK_NAME AS CODE
			,plan_start_yyyymmdd +'-' + B.WEEK_NAME AS name
			,division_id DIVISION_ID
			,plan_start_yyyymmdd PLAN_YEAR
	FROM  dbo.[FN_SCP_PLAN_VERSION_V1]('','', '','') a  JOIN
				scm_sys_calendar_m b  WITH(NOLOCK) ON  a.plan_start_yyyymmdd = b.basis_yyyymmdd
	WHERE    1=1
	--AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  b.calendar_yyyy = @Param2)
	GROUP BY plan_start_yyyymmdd
			, b.WEEK_NAME
			,division_id
	ORDER BY name DESC ;
END
ELSE IF @Code = 'PlanYear1'
BEGIN
	SELECT DISTINCT SUBSTRING(plan_version_id,1,4 ) AS code
			,SUBSTRING(plan_version_id,1,4 ) AS name
			,division_id DIVISION_ID
	FROM dbo.[FN_SCP_PLAN_VERSION_V1]('','','','')
	ORDER BY code DESC
END
ELSE IF @Code = 'PlantByDivision1'
BEGIN
	SELECT A.PLANT_ID      AS CODE
		, A.PLANT_NAME    AS NAME
		, A.DIVISION_ID   AS DIVISION_ID
	FROM  [dbo].[SCM_MST_PLANT_SN] A WITH(NOLOCK)
	WHERE  1 = 1
	AND    ( ( @Param1 IS NULL OR  @Param1='' ) OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,','))
					-- SELECT t.c.value('.', 'NVARCHAR(4000)')
					-- FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
					-- CROSS APPLY x.nodes('/t') t(c)
					)
END
ELSE IF @Code = 'PlantByDivisionOperation1'
BEGIN
	SELECT A.SCM_SITE_ID AS CODE
			--,A.SITE_DESCRIPTION AS NAME
			,A.SCM_SITE_ID + '   '+A.SITE_DESCRIPTION AS NAME
			,A.DIVISION_ID
			,A.OPERATION_GROUP
	FROM  [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
	WHERE  1 = 1
		AND  A.VALID_YN ='Y'
		AND  A.SITE_TYPE = 'PLANT'
		AND  ( ( @Param1 IS NULL OR  @Param1='' ) OR  A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')) )
		AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )
		--JV 용 AND 조건 추가 (lgda106 김승일 21.07.02)
		AND  ( ( @Param3 <> 'JV Planner' ) OR  A.PLANT_ID IN ( SELECT token FROM dbo.String_Split(@Param4,',')) )
    ORDER BY CODE
END
-- PLANT_SITE_BY_DIVISION
	-- @Param1 = @p_division_id
ELSE IF @Code = 'PlantSiteByDivision1Ex'
	BEGIN
			SELECT A.SCM_SITE_ID AS CODE
				, A.SITE_DESCRIPTION AS NAME
				, A.DIVISION_ID
			FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
			WHERE  1 = 1
			AND    A.SITE_TYPE = 'PLANT'
			AND    A.VALID_YN  = 'Y'
			AND ( ( @Param1 IS NULL OR  @Param1='' ) OR  A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
							-- SELECT t.c.value('.', 'NVARCHAR(4000)')
							-- FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
							-- CROSS APPLY x.nodes('/t') t(c)
							)
	END
-- PLANT_SITE_BY_DIVISION_OSP
	-- @Param1 = @p_division_id
ELSE IF @Code = 'PlantSiteByDivisionOSP1'
	BEGIN
			SELECT A.SCM_SITE_ID AS CODE
				, A.SITE_DESCRIPTION AS NAME
				, A.DIVISION_ID
			FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
			WHERE  1 = 1
			AND    A.SITE_TYPE = 'PLANT'
			AND    A.VALID_YN  = 'Y'
			AND    ( ( @Param1 IS NULL OR  @Param1='' ) OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,','))
							-- SELECT t.c.value('.', 'NVARCHAR(4000)')
							-- FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
							-- CROSS APPLY x.nodes('/t') t(c)
							)
			AND A.OSP_YN ='Y'
			--AND A.VALID_YN ='Y'
	END
ELSE IF @Code = 'SaleSiteByDivision1'
	BEGIN
		SELECT A.SCM_SITE_ID AS CODE
			, A.SITE_DESCRIPTION AS NAME
			,A.DIVISION_ID
			FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
			AND    A.SITE_TYPE = 'SALES'
			AND    A.VALID_YN  = 'Y'
			AND ((@Param1 IS NULL OR @Param1 ='') OR A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,','))
						-- SELECT t.c.value('.', 'NVARCHAR(4000)')
						-- FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
						-- CROSS APPLY x.nodes('/t') t(c)
						)
	END
ELSE IF @Code = 'StorageID1'
	BEGIN
		SELECT distinct STORAGE_ID CODE
		  ,(STORAGE_ID + '  ' + STORAGE_DESCRIPTION) NAME
		  ,DIVISION_ID
		  ,PLANT_ID
		FROM SCM_MST_SLOC WITH(NOLOCK)
		WHERE  1=1
			AND	(@Param1 = '' OR DIVISION_ID = @Param1)
			AND (@Param2 = '' OR PLANT_ID = @Param2)
	END
	ELSE IF @Code = 'ToSiteByDivision1Ex'
		BEGIN
			SELECT	 SCM_SITE_ID			AS	CODE
					,SCM_SITE_ID			AS	NAME
					,A.DIVISION_ID
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
		ELSE IF @Code = 'OperationForPlanDivisionId1'
	BEGIN
		SELECT DISTINCT
				A.OPERATION_ID	AS CODE,
				CASE
					WHEN A.OPERATION_ID = 'R5500' THEN (A.OPERATION_ID + ' ' + 'ESS Eack')
					ELSE (A.OPERATION_ID + ' ' + C.OPERATION_NAME)
				END				AS NAME,
				C.DIVISION_ID
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
ELSE IF @Code = 'ITEM_MASTER_CLASS21'
BEGIN
	SELECT
		 DISTINCT
		 B.LEVEL_2_NAME AS CODE
		,B.LEVEL_2_NAME AS NAME
		,B.LEVEL_1_NAME AS CLASS1
	FROM SCM_MST_ITEM_SN A(NOLOCK)
	INNER HASH JOIN SCM_MST_ITEM_CLASS_SN B(NOLOCK) ON A.ITEM_CLASS = B.CLASS_ID
	WHERE
		((@Param1 IS NULL  OR  @Param1='' ) OR B.LEVEL_1_NAME IN
			( SELECT token FROM dbo.String_Split(@Param1,',')
			--SELECT t.c.value('.', 'NVARCHAR(4000)')
			--FROM   (SELECT x = CAST('<t>' + REPLACE(@Param1, ',', '</t><t>') + '</t>' AS xml)) b
			--CROSS APPLY x.nodes('/t') t(c)
			)
		  )
	ORDER BY B.LEVEL_2_NAME
END
ELSE IF @Code = 'YearFromThisYear'
BEGIN
	SELECT    A.CALENDAR_YYYY	AS CODE
	        , A.CALENDAR_YYYY	AS NAME
	FROM	[dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
	WHERE	1=1
        AND A.CALENDAR_YYYY >= FORMAT(GETDATE(),'yyyy')
	GROUP BY	A.CALENDAR_YYYY
    ORDER BY    A.CALENDAR_YYYY;
END
ELSE IF @Code = 'OperationElectrodeType'
BEGIN
	SELECT	  B.SEGMENT1 AS DIVISION_ID
			, B.SEGMENT2 AS OPERATION_ID
			, B.SEGMENT3 AS CODE
			, B.SEGMENT3 AS NAME
			, B.SEGMENT4 AS SHOP_GROUP_ID
			, B.DISPLAY_SEQ
    FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
            INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
                    A.LOOKUP_TYPE = B.LOOKUP_TYPE
	WHERE	1=1
		AND A.LOOKUP_GROUP  = 'SCP'
		AND A.LOOKUP_TYPE   = 'OPERATION_ELECTRODE_TYPE'
		AND B.VALID_YN      = 'Y'
        AND B.SEGMENT4 IN ('A', 'P', 'E')
END

ELSE IF @Code = 'Company'
BEGIN
    SELECT	  A.COMPANY_ID	        	AS CODE
		    , MAX(B.COMPANY_NAME)		AS NAME
			, A.DIVISION_ID
			, A.SITE_ID
    FROM	SCM_MST_PLANT_SN A
            LEFT JOIN  (
                            SELECT    COMPANY_ID
                                    , MAX(COMPANY_NAME) AS COMPANY_NAME
                            FROM    SCM_MST_COMPANY_SN WITH(NOLOCK)
                            GROUP BY COMPANY_ID
                       ) B ON
                    A.COMPANY_ID = B.COMPANY_ID
    GROUP BY	  A.COMPANY_ID
			    , A.DIVISION_ID
    			, A.SITE_ID
    ORDER BY	  A.COMPANY_ID
			    , A.DIVISION_ID
    			, A.SITE_ID
END
ELSE IF @Code = 'CapaSite'
BEGIN
    SELECT    A.CODE
            , A.CODE + ' ' + MAX(A.NAME)       AS NAME
            , A.DIVISION_ID
            , A.GR
    FROM    (
                SELECT    SITE_ID                   AS CODE
                        , SITE_NAME                 AS NAME
                        , DIVISION_ID
                        , IIF(DUMMY_YN = 'Y', 2, 1) AS GR
                FROM SCP_MST_CAPA_LINE_MDL_V WITH(NOLOCK)
                WHERE   1=1
                    AND SHOP_GROUP_ID IN ('A', 'P', 'E')
            ) A
    GROUP BY  A.CODE
            , A.DIVISION_ID
            , A.GR
    ORDER BY  A.GR
            , A.CODE
END
ELSE IF @Code = 'CapaProgressStatus'
BEGIN
	SELECT	  B.SEGMENT1 AS CODE
			, B.SEGMENT2 AS NAME
    FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
            INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
                    A.LOOKUP_TYPE = B.LOOKUP_TYPE
	WHERE	1=1
		AND A.LOOKUP_GROUP  = 'SCP'
		AND A.LOOKUP_TYPE   = 'CAPA_PROG_STAT'
		AND B.VALID_YN      = 'Y'
    ORDER BY B.DISPLAY_SEQ;
END
ELSE IF @Code = 'CapaVersion'
BEGIN
	SELECT	  A.DIVISION_ID
			, A.VER_ID              AS CODE
			, A.VER_ID              AS NAME
			, A.VER_SEQ
			, A.PROG_STAT
            , A.BIZ_PLAN_USE_YN
            , B.NAME                AS PROG_STAT_NAME
	FROM	SCP_MST_CAPA_VERSION A
            JOIN (
	                SELECT	  B.SEGMENT1 AS CODE
			                , B.SEGMENT2 AS NAME
                    FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                            INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
                                    A.LOOKUP_TYPE = B.LOOKUP_TYPE
	                WHERE	1=1
		                AND A.LOOKUP_GROUP  = 'SCP'
		                AND A.LOOKUP_TYPE   = 'CAPA_PROG_STAT'
		                AND B.VALID_YN      = 'Y'
                 ) B ON
                    A.PROG_STAT = B.CODE
    ORDER BY  A.DIVISION_ID
			, A.VER_ID DESC
			, A.VER_SEQ DESC
			, A.PROG_STAT DESC;
END

/*===============================================
	용		 도:  plant 조회
	사 용 화 면:  SCP0104
	변       수:
	최 초 작 성:  2020. 09. 10
	개  발  자 :  chaan
	수  정  자 :  chaan
	수 정 사 항:  SHOP_GROUP_ID 파라미터 추가
	===============================================*/
ELSE IF @Code = 'CapaPlant'
BEGIN
    SELECT    A.CODE
            , A.CODE + ' ' + MAX(A.NAME)           NAME
            , A.COMPANY_ID
            , A.DIVISION_ID
            , A.SITE_ID
            , A.SHOP_GROUP_ID
            , A.GR
    FROM    (
                SELECT    A.PLANT_ID                    AS CODE
                        , A.PLANT_NAME                  AS NAME
                        , A.COMPANY_ID
                        , A.DIVISION_ID
                        , A.SITE_ID
                        , A.SHOP_GROUP_ID
                        , IIF(A.DUMMY_YN = 'Y', 2, 1)   AS GR
                FROM    SCP_MST_CAPA_LINE_MDL_V A WITH(NOLOCK)
                WHERE   1=1
                    AND A.SHOP_GROUP_ID IN ('A', 'P', 'E')
            ) A
    WHERE   1=1
        AND NAME IS NOT NULL
    GROUP BY  A.CODE
            , A.COMPANY_ID
            , A.DIVISION_ID
            , A.SITE_ID
            , A.SHOP_GROUP_ID
            , A.GR
    ORDER BY  A.GR
            , A.CODE
            , MAX(A.NAME)
            , A.COMPANY_ID
            , A.DIVISION_ID
            , A.SITE_ID
            , A.SHOP_GROUP_ID
END
/*===============================================
	용		 도:  Nickname 조회
	사 용 화 면:  SCP0104
	변       수:
	최 초 작 성:  2024. 04. 02
	개  발  자 :  chaan
	수  정  자 :  chaan
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'CapaNickname'
BEGIN
    SELECT    DIVISION_ID
            , OPERATION_GROUP
            , OPERATION_ID
            , ITEM_ID
            , ITEM_NAME
            , NICK_NAME
    FROM    FN_SCM0002_GET_CAPA_ITEM_POPUP('', '');
END

/*===============================================
	용		 도:  CAPA Dummpy master 조회
	사 용 화 면:  SCP0104
	변       수:
	최 초 작 성:  2024. 04. 03
	개  발  자 :  chaan
	수  정  자 :  chaan
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'CapaDummyCode'
BEGIN
                SELECT    CODE_TP
						, CODE
                        , NAME
                FROM    (
                            SELECT    'S'						AS CODE_TP
						            , SITE_ID                   AS CODE
                                    , MAX(SITE_NAME)            AS NAME
                            FROM SCP_MST_CAPA_LINE_MDL_V WITH(NOLOCK)
                            WHERE   1=1
					            AND DUMMY_YN = 'Y'
				            GROUP BY  SITE_ID
				            UNION ALL
                            SELECT    'C'						AS CODE_TP
						            , COMPANY_ID                   AS CODE
                                    , MAX(COMPANY_NAME)            AS NAME
                            FROM SCP_MST_CAPA_LINE_MDL_V WITH(NOLOCK)
                            WHERE   1=1
					            AND DUMMY_YN = 'Y'
				            GROUP BY  COMPANY_ID
				            UNION ALL
                            SELECT    'P'						AS CODE_TP
						            , PLANT_ID                   AS CODE
                                    , MAX(PLANT_NAME)            AS NAME
                            FROM SCP_MST_CAPA_LINE_MDL_V WITH(NOLOCK)
                            WHERE   1=1
					            AND DUMMY_YN = 'Y'
				            GROUP BY  PLANT_ID
				            UNION ALL
                            SELECT    'F'						AS CODE_TP
						            , FACTORY_ID                   AS CODE
                                    , MAX(FACTORY_NAME)            AS NAME
                            FROM SCP_MST_CAPA_LINE_MDL_V WITH(NOLOCK)
                            WHERE   1=1
					            AND DUMMY_YN = 'Y'
				            GROUP BY  FACTORY_ID
				            UNION ALL
                            SELECT    'L'						AS CODE_TP
						            , LINE_ID                   AS CODE
                                    , MAX(LINE_NAME)            AS NAME
                            FROM SCP_MST_CAPA_LINE_MDL_V WITH(NOLOCK)
                            WHERE   1=1
					            AND DUMMY_YN = 'Y'
				            GROUP BY  LINE_ID
                            UNION ALL
                            SELECT    MAX(CODE_TP)  AS CODE_TP
						            , CODE
                                    , MAX(NAME)     AS NAME
                            FROM SCP_MST_CAPA_DUMMY_CODE WITH(NOLOCK)
                            WHERE   1=1
                                AND CODE_TP     = 'I'
                                AND VALID_YN    = 'Y'
				            GROUP BY  CODE
                            UNION ALL
                            SELECT    MAX(CODE_TP)  AS CODE_TP
						            , CODE
                                    , MAX(NAME)     AS NAME
                            FROM SCP_MST_CAPA_DUMMY_CODE WITH(NOLOCK)
                            WHERE   1=1
                                AND CODE_TP =    'N'
                                AND VALID_YN    = 'Y'
				            GROUP BY  CODE
                        ) A
                WHERE   1=1
                    AND NAME IS NOT NULL
END

/*===============================================
	용		 도:  CAPA Line Master 조회
	사 용 화 면:  SCP0104
	변       수:
	최 초 작 성:  2024. 04. 04
	개  발  자 :  chaan
	수  정  자 :  chaan
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'CapaLineMaster'
BEGIN
	WITH tbl_CODE_ALL AS
	(
		SELECT  *
		FROM    SCP_MST_CAPA_LINE WITH(NOLOCK)
		WHERE   VALID_YN = 'Y'
	)
	,
	tbl_SITE AS
	(
		SELECT    SITE_ID
				, SITE_NAME
	    FROM    tbl_CODE_ALL
		GROUP BY  SITE_ID
				, SITE_NAME
	)
    ,
    tbl_COMPANY AS
	(
		SELECT    COMPANY_ID
				, COMPANY_NAME
		FROM    tbl_CODE_ALL
		GROUP BY  COMPANY_ID
				, COMPANY_NAME
	)
    ,
    tbl_PLANT AS
	(
		SELECT    PLANT_ID
				, PLANT_NAME
	    FROM    tbl_CODE_ALL
		GROUP BY  PLANT_ID
				, PLANT_NAME
	)
    ,
    tbl_FACTORY AS
	(
		SELECT    FACTORY_ID
				, FACTORY_NAME
		FROM    tbl_CODE_ALL
		GROUP BY  FACTORY_ID
				, FACTORY_NAME
	)
    ,
    tbl_LINE AS
	(
		SELECT    LINE_ID
				, LINE_NAME
		FROM    tbl_CODE_ALL
		GROUP BY  LINE_ID
				, LINE_NAME
	)
    ,
    tbl_SHOP_GROUP AS
    (
        SELECT    DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_GROUP_ID        AS SHOP_GROUP_ID
                , OPERATION_ID
                , MAX(OPERATION_GROUP)      AS SHOP_GROUP_NAME
        FROM    SCM_LINE_HIERARCHY_CPS_V_SN WITH(NOLOCK)
        GROUP BY  DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_GROUP_ID
                , OPERATION_ID
    )
    ,
    tbl_SHOP_GROUP_CELL AS
    (
        SELECT    DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , SHOP_GROUP_ID
                , OPERATION_ID
                , SHOP_GROUP_NAME
        FROM    tbl_SHOP_GROUP
        WHERE   1=1
                AND SHOP_GROUP_ID   = 'A'
    )
    ,
    tblAll AS
    (
        SELECT    A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.ITEM_ID
			    , A.NICK_NAME
			    , A.DUMMY_YN
        FROM    SCP_MST_CAPA_LINE_MDL A WITH(NOLOCK)
        UNION ALL
        SELECT    A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , 'AFFFF'
			    , '-'
			    , NULL
			    , NULL
			    , 'N'
        FROM    (        
                    SELECT    A.DIVISION_ID
			                , A.COMPANY_ID
			                , A.SITE_ID
			                , A.PLANT_ID
			                , A.FACTORY_ID
			                , A.LINE_ID
			                , A.OPERATION_ID
                    FROM    SCP_MST_CAPA_LINE_MDL A WITH(NOLOCK)
                    GROUP BY  A.DIVISION_ID
			                , A.COMPANY_ID
			                , A.SITE_ID
			                , A.PLANT_ID
			                , A.FACTORY_ID
			                , A.LINE_ID
			                , A.OPERATION_ID
                ) A
                INNER JOIN tbl_SHOP_GROUP_CELL SS ON
                        A.DIVISION_ID   = SS.DIVISION_ID
		            AND A.SITE_ID		= SS.SITE_ID
		            AND A.PLANT_ID		= SS.PLANT_ID
		            AND A.FACTORY_ID	= SS.FACTORY_ID
		            AND A.LINE_ID		= SS.LINE_ID
                    AND A.OPERATION_ID	= SS.OPERATION_ID
    )
    ,
    tbl_OPERATION AS
    (
		SELECT    A.CODE    AS OPERATION_ID
				, A.NAME    AS OPERATION_NAME
		FROM    (
					SELECT    A.OPERATION_ID        AS CODE
							, MAX(A.OPERATION_NAME) AS NAME
					FROM	[dbo].SCM_MST_OPERATION_SN A WITH(NOLOCK)
					GROUP BY  A.OPERATION_ID
					UNION ALL
					SELECT	  B.SEGMENT1   AS CODE
							, B.ATTRIBUTE1 AS NAME
					FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
							INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
									A.LOOKUP_TYPE = B.LOOKUP_TYPE
					WHERE	1=1
						AND A.LOOKUP_GROUP  = 'SCP'
						AND A.LOOKUP_TYPE   = 'CPS_FORMATION_OPERATION'
						AND B.VALID_YN      = 'Y'
					GROUP BY  B.SEGMENT1
							, B.ATTRIBUTE1
				) A
    )
    ,
    tbl_ElectrodeType AS
    (
	    SELECT	  B.SEGMENT1                                            AS DIVISION_ID
			    , B.SEGMENT2                                            AS OPERATION_ID
			    , B.SEGMENT3                                            AS ELTR_LN_TP_CD
			    , B.SEGMENT3                                            AS ELTR_LN_TP_NM
                , SUBSTRING(CONVERT(NVARCHAR(6), B.DISPLAY_SEQ), 3, 4)  AS DISPLAY_SEQ
        FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
                        A.LOOKUP_TYPE = B.LOOKUP_TYPE
	    WHERE	1=1
		    AND A.LOOKUP_GROUP  = 'SCP'
		    AND A.LOOKUP_TYPE   = 'OPERATION_ELECTRODE_TYPE'
		    AND B.VALID_YN      = 'Y'
   )
        SELECT    A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.ITEM_ID
			    , A.NICK_NAME
			    , A.DUMMY_YN
                , dbo.FN_GET_DIVISION_NAME(A.DIVISION_ID)                       AS DIVISION_NAME
			    , (A.SITE_ID		+ ' ' + S.SITE_NAME)						AS SITE_NAME
			    , (A.COMPANY_ID		+ ' ' + C.COMPANY_NAME)						AS COMPANY_NAME
			    , (A.PLANT_ID		+ ' ' + P.PLANT_NAME)						AS PLANT_NAME
			    , (A.FACTORY_ID		+ ' ' + F.FACTORY_NAME)						AS FACTORY_NAME
			    , (A.LINE_ID		+ ' ' + L.LINE_NAME)						AS LINE_NAME
                , ISNULL(SS.SHOP_GROUP_ID, SUBSTRING(A.OPERATION_ID, 1, 1))     AS SHOP_GROUP_ID
                , (SS.SHOP_GROUP_ID	+ ' ' + SS.SHOP_GROUP_NAME)					AS SHOP_GROUP_NAME
                , (A.OPERATION_ID	+ ' ' + O.OPERATION_NAME)					AS OPERATION_NAME
                ----, (A.ELTR_LN_TP_CD	+ ' ' + E.ELTR_LN_TP_NM)				AS ELTR_LN_TP_NM
                , A.ELTR_LN_TP_CD                                               AS ELTR_LN_TP_NM

                --sheet 용 name 컬럼(속도개선용) begin
			    , S.SITE_NAME						                            AS SITE_NAME_
			    , C.COMPANY_NAME						                        AS COMPANY_NAME_
			    , P.PLANT_NAME						                            AS PLANT_NAME_
			    , F.FACTORY_NAME					                            AS FACTORY_NAME_
			    , L.LINE_NAME						                            AS LINE_NAME_
                , SS.SHOP_GROUP_NAME				                            AS SHOP_GROUP_NAME_
                , O.OPERATION_NAME					                            AS OPERATION_NAME_
                --sheet 용 name 컬럼(속도개선용) end

                , E.DISPLAY_SEQ
        FROM    tblAll A
                LEFT JOIN tbl_SITE S ON
					    A.SITE_ID			= S.SITE_ID
                LEFT JOIN tbl_COMPANY C ON
					    A.COMPANY_ID		= C.COMPANY_ID
                LEFT JOIN tbl_PLANT P ON
					    A.PLANT_ID			= P.PLANT_ID
                LEFT JOIN tbl_FACTORY F ON
					    A.FACTORY_ID		= F.FACTORY_ID
                LEFT JOIN tbl_LINE L ON
					    A.LINE_ID			= L.LINE_ID
                LEFT JOIN tbl_SHOP_GROUP SS ON
                        A.DIVISION_ID   = SS.DIVISION_ID
		            AND A.SITE_ID		= SS.SITE_ID
		            AND A.PLANT_ID		= SS.PLANT_ID
		            AND A.FACTORY_ID    = SS.FACTORY_ID
		            AND A.LINE_ID		= SS.LINE_ID
                --LEFT JOIN tbl_ElectrodeType E ON
				INNER JOIN tbl_ElectrodeType E ON			--소형(40)에서 AFFFF(가상공정) 제외 할 것 2025-03-31 mrchois
                        A.DIVISION_ID   = E.DIVISION_ID
		            AND A.OPERATION_ID  = E.OPERATION_ID
		            AND A.ELTR_LN_TP_CD	= E.ELTR_LN_TP_CD
                LEFT JOIN tbl_OPERATION O ON
                        A.OPERATION_ID = O.OPERATION_ID
        WHERE   1=1
            --AND ISNULL(B.SITE_NAME, '') <> '' 
            --AND ISNULL(B.COMPANY_NAME, '') <> '' 
            --AND ISNULL(B.PLANT_NAME, '') <> '' 
            --AND ISNULL(B.FACTORY_NAME, '') <> '' 
            --AND ISNULL(B.LINE_NAME, '') <> '' 
            --AND A.PLANT_ID LIKE 'DMY%'
        ORDER BY  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
                , E.DISPLAY_SEQ
END
ELSE IF @Code = 'CapaOperationByLine'
BEGIN
    ;WITH tblLook AS
    (
        SELECT	  B.SEGMENT1                                            AS DIVISION_ID
                , B.SEGMENT2                                            AS OPERATION_ID
			    , B.SEGMENT3                                            AS ELTR_LN_TP_CD
			    , B.SEGMENT3                                            AS ELTR_LN_TP_NM
			    , B.SEGMENT4                                            AS OPERATION_GROUP_ID
                , SUBSTRING(CONVERT(NVARCHAR(6), B.DISPLAY_SEQ), 3, 4)  AS DISPLAY_SEQ
        FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
                        A.LOOKUP_TYPE = B.LOOKUP_TYPE
	    WHERE	1=1
		    AND A.LOOKUP_GROUP  = 'SCP'
		    AND A.LOOKUP_TYPE   = 'OPERATION_ELECTRODE_TYPE'
		    AND B.VALID_YN      = 'Y'
    )
    ,
    tblAll AS
    (
	    SELECT    A.OPERATION_ID
			    , A.OPERATION_NAME
	    FROM    (
				    SELECT    A.OPERATION_ID
						    , MAX(A.OPERATION_NAME) AS OPERATION_NAME
				    FROM	[dbo].SCM_MST_OPERATION_SN A WITH(NOLOCK)
				    GROUP BY  A.OPERATION_ID
				    UNION ALL
				    SELECT	  B.SEGMENT1            AS OPERATION_ID
						    , B.ATTRIBUTE1          AS OPERATION_NAME
				    FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
						    INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
								    A.LOOKUP_TYPE = B.LOOKUP_TYPE
				    WHERE	1=1
					    AND A.LOOKUP_GROUP  = 'SCP'
					    AND A.LOOKUP_TYPE   = 'CPS_FORMATION_OPERATION'
					    AND B.VALID_YN      = 'Y'
				    GROUP BY  B.SEGMENT1
						    , B.ATTRIBUTE1
			    ) A
    )
    ,
    tblOperatioEltrrodeType AS
    (
        SELECT	  A.DIVISION_ID
                , A.OPERATION_ID
			    , O.OPERATION_NAME
			    , A.OPERATION_GROUP_ID  AS SHOP_GROUP_ID
			    , A.ELTR_LN_TP_CD
			    , A.ELTR_LN_TP_NM
                , A.DISPLAY_SEQ
        FROM    tblLook A
                LEFT JOIN tblAll O ON
                        A.OPERATION_ID = O.OPERATION_ID
    )
    ,
    tblOperation AS
    (
        SELECT	  A.DIVISION_ID
                , A.OPERATION_ID
			    , A.OPERATION_NAME
			    , A.SHOP_GROUP_ID
                , MAX(A.DISPLAY_SEQ)    AS DISPLAY_SEQ
        FROM    tblOperatioEltrrodeType A
        GROUP BY  A.DIVISION_ID
                , A.OPERATION_ID
			    , A.OPERATION_NAME
			    , A.SHOP_GROUP_ID
    )
        SELECT	  A.DIVISION_ID
                , A.OPERATION_ID                                AS CODE
			    , A.OPERATION_ID + ' ' + A.OPERATION_NAME       AS NAME
			    , A.SHOP_GROUP_ID
                , A.DISPLAY_SEQ
        FROM    tblOperation A
        WHERE   1=1
            AND A.SHOP_GROUP_ID IN ('P', 'A')
END
/*===============================================
용		 도:  Group Mapping 용 
사 용 화 면:  SCP0110
변       수:  -
최 초 작 성:  2024. 05. 23
개  발  자 :  mrchois
최 종 작 성:
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'GroupMaster'
BEGIN
	SELECT  GROUP_ID AS CODE
		,	GROUP_NAME AS NAME
		,	DIVISION_ID 
		,	OPERATION_GROUP 
	FROM    SCP_MST_ITEM_GROUP WITH(NOLOCK)
	WHERE   1=1
		--AND DIVISION_ID = '81'
		AND VALID_YN = 'Y'
	ORDER BY GROUP_ID
END
/*===============================================
용		 도:  CapaLine - Dummy 포함
사 용 화 면:  SCP0104
변       수:  -
최 초 작 성:  2024. 05. 31
개  발  자 :  chaan
최 종 작 성:
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'CapaLine'
BEGIN
    SELECT    A.CODE
            , A.CODE + ' ' + MAX(A.NAME)       AS NAME
            , A.DIVISION_ID
            , A.SHOP_GROUP_ID
            , A.PLANT_ID
            , A.FACTORY_ID
    FROM    (
                SELECT    A.LINE_ID						    AS CODE
                        , A.LINE_NAME	                    AS NAME
                        , A.DIVISION_ID                     AS DIVISION_ID
                        , A.SHOP_GROUP_ID                   AS SHOP_GROUP_ID
                        , A.PLANT_ID                        AS PLANT_ID
                        , A.FACTORY_ID                      AS FACTORY_ID
                        , IIF(A.DUMMY_YN = 'Y', 2, 1)       AS GR
                FROM    SCP_MST_CAPA_LINE_MDL_V A WITH(NOLOCK)
                WHERE   1=1
                        AND A.SHOP_GROUP_ID IN ('A', 'P', 'E')
            ) A
    WHERE   1=1
            AND NAME IS NOT NULL
    GROUP BY  A.CODE
            , A.DIVISION_ID
            , A.SHOP_GROUP_ID
            , A.PLANT_ID
            , A.FACTORY_ID
            , A.GR
    ORDER BY  A.GR
            , A.CODE
            , MAX(A.NAME);
END
/*===============================================
용		 도:  CapaFactory - Dummy 포함
사 용 화 면:  SCP0104
변       수:  -
최 초 작 성:  2024. 05. 31
개  발  자 :  chaan
최 종 작 성:
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'CapaFactory'
BEGIN
    SELECT    A.CODE
            , A.CODE + ' ' + MAX(A.NAME)                   AS NAME
            , A.DIVISION_ID
            , A.COMPANY_ID
            , A.SHOP_GROUP_ID
            , A.SITE_ID
            , A.PLANT_ID
            , A.GR
    FROM    (
                SELECT    A.FACTORY_ID      AS CODE
                        , A.FACTORY_NAME    AS NAME
                        , A.DIVISION_ID
                        , A.COMPANY_ID
                        , A.SHOP_GROUP_ID
                        , A.SITE_ID
                        , A.PLANT_ID
                        , IIF(A.DUMMY_YN = 'Y', 2, 1)       AS GR
                FROM    SCP_MST_CAPA_LINE_MDL_V A WITH(NOLOCK)
                WHERE   1=1
                    AND SHOP_GROUP_ID IN ('A', 'P', 'E')
            ) A
    WHERE   1=1
            AND NAME IS NOT NULL
    GROUP BY  A.CODE
            , A.DIVISION_ID
            , A.COMPANY_ID
            , A.SHOP_GROUP_ID
            , A.SITE_ID
            , A.PLANT_ID
            , A.GR
    ORDER BY  A.GR
            , MAX(A.CODE)
            , MAX(A.NAME)
END

/*===============================================
	용		 도:  Capa plant 조회 - 전극
	사 용 화 면:  SCP0104
	변       수:
	최 초 작 성:  2024. 06. 03
	개  발  자 :  chaan
	수  정  자 :  chaan
	수 정 사 항:  
	===============================================*/
ELSE IF @Code = 'CapaPlantEE'
BEGIN
    SELECT    A.CODE
            , A.CODE + ' ' + MAX(A.NAME)                           AS NAME
            , A.COMPANY_ID
            , A.DIVISION_ID
            , A.SITE_ID
            , A.SHOP_GROUP_ID
            , A.GR
    FROM    (
                SELECT    A.PLANT_ID                        AS CODE
                        , A.PLANT_NAME                      AS NAME
                        , A.COMPANY_ID
                        , A.DIVISION_ID
                        , A.SITE_ID
                        , A.SHOP_GROUP_ID
                        , IIF(A.DUMMY_YN = 'Y', 2, 1)       AS GR
                FROM	SCP_MST_CAPA_LINE_MDL_V A
                WHERE	1=1
	                AND A.SHOP_GROUP_ID    = 'E'
            ) A
    WHERE   1=1
            AND NAME IS NOT NULL
    GROUP BY  A.CODE
            , A.COMPANY_ID
            , A.DIVISION_ID
            , A.SITE_ID
            , A.SHOP_GROUP_ID
            , A.GR
    ORDER BY  A.GR
            , A.CODE
            , MAX(A.NAME)
            , A.COMPANY_ID
            , A.DIVISION_ID
            , A.SITE_ID
            , A.SHOP_GROUP_ID
END
/*===============================================
	용		 도:  CAPA Line Master 조회 (전극용)
	사 용 화 면:  SCP0104
	변       수:
	최 초 작 성:  2024. 04. 04
	개  발  자 :  chaan
	수  정  자 :  chaan
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'CapaLineMasterEE'
BEGIN
	WITH tbl_CODE_ALL AS
	(
		SELECT  *
		FROM    SCP_MST_CAPA_ELTR_LINE WITH(NOLOCK)
		WHERE   VALID_YN = 'Y'
	)
	,
	tbl_SITE AS
	(
		SELECT    SITE_ID
				, SITE_NAME
	    FROM    tbl_CODE_ALL
		GROUP BY  SITE_ID
				, SITE_NAME
	)
    ,
    tbl_COMPANY AS
	(
		SELECT    COMPANY_ID
				, COMPANY_NAME
		FROM    tbl_CODE_ALL
		GROUP BY  COMPANY_ID
				, COMPANY_NAME
	)
    ,
    tbl_PLANT AS
	(
		SELECT    PLANT_ID
				, PLANT_NAME
	    FROM    tbl_CODE_ALL
		GROUP BY  PLANT_ID
				, PLANT_NAME
	)
    ,
    tbl_FACTORY AS
	(
		SELECT    FACTORY_ID
				, FACTORY_NAME
		FROM    tbl_CODE_ALL
		GROUP BY  FACTORY_ID
				, FACTORY_NAME
	)
    ,
    tbl_LINE AS
	(
		SELECT    LINE_ID
				, LINE_NAME
		FROM    tbl_CODE_ALL
		GROUP BY  LINE_ID
				, LINE_NAME
	)
    ,
    tbl_SHOP_GROUP AS
    (
        SELECT    DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_GROUP_ID        AS SHOP_GROUP_ID
                , OPERATION_ID
                , MAX(OPERATION_GROUP)      AS SHOP_GROUP_NAME
        FROM    SCM_LINE_HIERARCHY_CPS_V_SN WITH(NOLOCK)
        GROUP BY  DIVISION_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_GROUP_ID
                , OPERATION_ID
    )
    ,
    tblAll AS
    (
        SELECT    A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.ITEM_ID
			    , A.NICK_NAME
			    , A.DUMMY_YN
        FROM    SCP_MST_CAPA_ELTR_LINE_MDL A WITH(NOLOCK)
    )
    ,
    tbl_OPERATION AS
    (
		SELECT    A.OPERATION_ID
				, MAX(A.OPERATION_NAME) AS OPERATION_NAME
		FROM	[dbo].SCM_MST_OPERATION_SN A WITH(NOLOCK)
		GROUP BY  A.OPERATION_ID
    )
    ,
    tbl_ElectrodeType AS
    (
	    SELECT	  B.SEGMENT1                                            AS DIVISION_ID
			    , B.SEGMENT2                                            AS OPERATION_ID
			    , B.SEGMENT3                                            AS ELTR_LN_TP_CD
			    , B.SEGMENT3                                            AS ELTR_LN_TP_NM
                , B.DISPLAY_SEQ
        FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
                        A.LOOKUP_TYPE = B.LOOKUP_TYPE
	    WHERE	1=1
		    AND A.LOOKUP_GROUP  = 'SCP'
		    AND A.LOOKUP_TYPE   = 'OPERATION_ELECTRODE_TYPE'
		    AND B.VALID_YN      = 'Y'
   )
        SELECT    A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.ITEM_ID
			    , A.NICK_NAME
			    , A.DUMMY_YN
                , dbo.FN_GET_DIVISION_NAME(A.DIVISION_ID)                       AS DIVISION_NAME
			    , (A.SITE_ID		+ ' ' + S.SITE_NAME)						AS SITE_NAME
			    , (A.COMPANY_ID		+ ' ' + C.COMPANY_NAME)						AS COMPANY_NAME
			    , (A.PLANT_ID		+ ' ' + P.PLANT_NAME)						AS PLANT_NAME
			    , (A.FACTORY_ID		+ ' ' + F.FACTORY_NAME)						AS FACTORY_NAME
			    , (A.LINE_ID		+ ' ' + L.LINE_NAME)						AS LINE_NAME
                , ISNULL(SS.SHOP_GROUP_ID, SUBSTRING(A.OPERATION_ID, 1, 1))     AS SHOP_GROUP_ID
                , (SS.SHOP_GROUP_ID	+ ' ' + SS.SHOP_GROUP_NAME)					AS SHOP_GROUP_NAME
                , (A.OPERATION_ID	+ ' ' + O.OPERATION_NAME)					AS OPERATION_NAME
                ----, (A.ELTR_LN_TP_CD	+ ' ' + E.ELTR_LN_TP_NM)				AS ELTR_LN_TP_NM
                , A.ELTR_LN_TP_CD                                               AS ELTR_LN_TP_NM

                --sheet 용 name 컬럼(속도개선용) begin
			    , S.SITE_NAME						                            AS SITE_NAME_
			    , C.COMPANY_NAME						                        AS COMPANY_NAME_
			    , P.PLANT_NAME						                            AS PLANT_NAME_
			    , F.FACTORY_NAME					                            AS FACTORY_NAME_
			    , L.LINE_NAME						                            AS LINE_NAME_
                , SS.SHOP_GROUP_NAME				                            AS SHOP_GROUP_NAME_
                , O.OPERATION_NAME					                            AS OPERATION_NAME_
                --sheet 용 name 컬럼(속도개선용) end

                , E.DISPLAY_SEQ
        FROM    tblAll A
                LEFT JOIN tbl_SITE S ON
					    A.SITE_ID			= S.SITE_ID
                LEFT JOIN tbl_COMPANY C ON
					    A.COMPANY_ID		= C.COMPANY_ID
                LEFT JOIN tbl_PLANT P ON
					    A.PLANT_ID			= P.PLANT_ID
                LEFT JOIN tbl_FACTORY F ON
					    A.FACTORY_ID		= F.FACTORY_ID
                LEFT JOIN tbl_LINE L ON
					    A.LINE_ID			= L.LINE_ID
                LEFT JOIN tbl_SHOP_GROUP SS ON
                        A.DIVISION_ID   = SS.DIVISION_ID
		            AND A.SITE_ID		= SS.SITE_ID
		            AND A.PLANT_ID		= SS.PLANT_ID
		            AND A.FACTORY_ID    = SS.FACTORY_ID
		            AND A.LINE_ID		= SS.LINE_ID
                LEFT JOIN tbl_ElectrodeType E ON
                        A.DIVISION_ID   = E.DIVISION_ID
		            AND A.OPERATION_ID  = E.OPERATION_ID
		            AND A.ELTR_LN_TP_CD	= E.ELTR_LN_TP_CD
                LEFT JOIN tbl_OPERATION O ON
                        A.OPERATION_ID = O.OPERATION_ID
        WHERE   1=1
            --AND ISNULL(B.SITE_NAME, '') <> '' 
            --AND ISNULL(B.COMPANY_NAME, '') <> '' 
            --AND ISNULL(B.PLANT_NAME, '') <> '' 
            --AND ISNULL(B.FACTORY_NAME, '') <> '' 
            --AND ISNULL(B.LINE_NAME, '') <> '' 
            --AND A.PLANT_ID LIKE 'DMY%'
        ORDER BY  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
                , E.DISPLAY_SEQ
END
ELSE IF @Code = 'CapaCompany'
BEGIN
    SELECT	  A.CODE
		    , A.CODE + ' ' + MAX(A.NAME)        AS NAME
		    , A.DIVISION_ID
		    , A.SITE_ID
            , A.GR
    FROM    (   
                SELECT	  A.COMPANY_ID		                AS CODE
		                , MAX(A.COMPANY_NAME)               AS NAME
		                , A.DIVISION_ID
		                , A.SITE_ID
                        , IIF(MAX(A.DUMMY_YN) = 'Y', 2, 1)       AS GR
                FROM	SCP_MST_CAPA_LINE_MDL_V A
                WHERE   1=1
                    AND SHOP_GROUP_ID IN ('A', 'P', 'E')
                GROUP BY	  A.COMPANY_ID
			                , A.DIVISION_ID
    		                , A.SITE_ID
            ) A
    GROUP BY	  CODE
			    , DIVISION_ID
    		    , SITE_ID
                , GR
    ORDER BY	  GR
                , CODE
			    , DIVISION_ID
    			, SITE_ID
END
ELSE IF @Code = 'CapaOperationByLineEE'
BEGIN
    ;WITH tblLook AS
    (
        SELECT	  B.SEGMENT1      AS DIVISION_ID
                , B.SEGMENT2      AS OPERATION_ID
			    , B.SEGMENT3      AS ELTR_LN_TP_CD
			    , B.SEGMENT3      AS ELTR_LN_TP_NM
			    , B.SEGMENT4      AS OPERATION_GROUP_ID
                , B.DISPLAY_SEQ
        FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
                        A.LOOKUP_TYPE = B.LOOKUP_TYPE
	    WHERE	1=1
		    AND A.LOOKUP_GROUP  = 'SCP'
		    AND A.LOOKUP_TYPE   = 'OPERATION_ELECTRODE_TYPE'
		    AND B.VALID_YN      = 'Y'
    )
    ,
    tblAll AS
    (
	    SELECT    A.OPERATION_ID
			    , A.OPERATION_NAME
	    FROM    (
				    SELECT    A.OPERATION_ID
						    , MAX(A.OPERATION_NAME) AS OPERATION_NAME
				    FROM	[dbo].SCM_MST_OPERATION_SN A WITH(NOLOCK)
				    GROUP BY  A.OPERATION_ID
				    UNION ALL
				    SELECT	  B.SEGMENT1            AS OPERATION_ID
						    , B.ATTRIBUTE1          AS OPERATION_NAME
				    FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
						    INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
								    A.LOOKUP_TYPE = B.LOOKUP_TYPE
				    WHERE	1=1
					    AND A.LOOKUP_GROUP  = 'SCP'
					    AND A.LOOKUP_TYPE   = 'CPS_FORMATION_OPERATION'
					    AND B.VALID_YN      = 'Y'
				    GROUP BY  B.SEGMENT1
						    , B.ATTRIBUTE1
			    ) A
    )
    ,
    tblOperatioEltrrodeType AS
    (
        SELECT	  A.DIVISION_ID
                , A.OPERATION_ID
			    , O.OPERATION_NAME
			    , A.OPERATION_GROUP_ID  AS SHOP_GROUP_ID
			    , A.ELTR_LN_TP_CD
			    , A.ELTR_LN_TP_NM
                , A.DISPLAY_SEQ
        FROM    tblLook A
                LEFT JOIN tblAll O ON
                        A.OPERATION_ID = O.OPERATION_ID
    )
    ,
    tblOperation AS
    (
        SELECT	  A.DIVISION_ID
                , A.OPERATION_ID
			    , A.OPERATION_NAME
			    , A.SHOP_GROUP_ID
                , MAX(A.DISPLAY_SEQ)    AS DISPLAY_SEQ
        FROM    tblOperatioEltrrodeType A
        GROUP BY  A.DIVISION_ID
                , A.OPERATION_ID
			    , A.OPERATION_NAME
			    , A.SHOP_GROUP_ID
    )
        SELECT	  A.DIVISION_ID
                , A.OPERATION_ID                                AS CODE
			    , A.OPERATION_ID + ' ' + A.OPERATION_NAME       AS NAME
			    , A.SHOP_GROUP_ID
                , A.DISPLAY_SEQ
        FROM    tblOperation A
        WHERE   1=1
            AND A.SHOP_GROUP_ID IN ('E')
END
/*===============================================
	용		 도:  Dummy CAPA Line Master 조회
	사 용 화 면:  SCP0104
	변       수:
	최 초 작 성:  2024. 10. 01
	개  발  자 :  chaan
	수  정  자 :  chaan
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'DummyCapaLineMaster'
BEGIN
    SELECT    A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
            , dbo.FN_GET_DIVISION_NAME(A.DIVISION_ID)                       AS DIVISION_NAME
			, (A.SITE_ID		+ ' ' + A.SITE_NAME)						AS SITE_NAME
			, (A.COMPANY_ID		+ ' ' + A.COMPANY_NAME)						AS COMPANY_NAME
			, (A.PLANT_ID		+ ' ' + A.PLANT_NAME)						AS PLANT_NAME
			, (A.FACTORY_ID		+ ' ' + A.FACTORY_NAME)						AS FACTORY_NAME
			, (A.LINE_ID		+ ' ' + A.LINE_NAME)						AS LINE_NAME
            , A.ATTRIBUTE1                                                  AS SHOP_GROUP_ID
            , CASE
                WHEN A.ATTRIBUTE1 = 'A' THEN 'Assembly'
                WHEN A.ATTRIBUTE1 = 'B' THEN 'Pack'
                WHEN A.ATTRIBUTE1 = 'E' THEN 'Electrode'
                WHEN A.ATTRIBUTE1 = 'F' THEN 'Formation'
                WHEN A.ATTRIBUTE1 = 'P' THEN 'Pack'
                ELSE '-'
              END                                                           AS SHOP_GROUP_NAME

			, A.SITE_NAME						                            AS SITE_NAME_
			, A.COMPANY_NAME						                        AS COMPANY_NAME_
			, A.PLANT_NAME						                            AS PLANT_NAME_
			, A.FACTORY_NAME					                            AS FACTORY_NAME_
			, A.LINE_NAME						                            AS LINE_NAME_
            , CASE
                WHEN A.ATTRIBUTE1 = 'A' THEN 'Assembly'
                WHEN A.ATTRIBUTE1 = 'B' THEN 'Pack'
                WHEN A.ATTRIBUTE1 = 'E' THEN 'Electrode'
                WHEN A.ATTRIBUTE1 = 'F' THEN 'Formation'
                WHEN A.ATTRIBUTE1 = 'P' THEN 'Pack'
                ELSE '-'
              END                                                           AS SHOP_GROUP_NAME_
    FROM    SCP_MST_CAPA_LINE A WITH(NOLOCK)
    WHERE   1=1
END

/*===============================================
	용		 도:  전극 Dummy CAPA Line Master 조회
	사 용 화 면:  SCP0104
	변       수:
	최 초 작 성:  2024. 10. 01
	개  발  자 :  chaan
	수  정  자 :  chaan
	수 정 사 항:
	===============================================*/
ELSE IF @Code = 'DummyCapaLineMasterEE'
BEGIN
    SELECT    A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
            , dbo.FN_GET_DIVISION_NAME(A.DIVISION_ID)                       AS DIVISION_NAME
			, (A.SITE_ID		+ ' ' + A.SITE_NAME)						AS SITE_NAME
			, (A.COMPANY_ID		+ ' ' + A.COMPANY_NAME)						AS COMPANY_NAME
			, (A.PLANT_ID		+ ' ' + A.PLANT_NAME)						AS PLANT_NAME
			, (A.FACTORY_ID		+ ' ' + A.FACTORY_NAME)						AS FACTORY_NAME
			, (A.LINE_ID		+ ' ' + A.LINE_NAME)						AS LINE_NAME
            , A.ATTRIBUTE1                                                  AS SHOP_GROUP_ID
            , CASE
                WHEN A.ATTRIBUTE1 = 'A' THEN 'Assembly'
                WHEN A.ATTRIBUTE1 = 'B' THEN 'Pack'
                WHEN A.ATTRIBUTE1 = 'E' THEN 'Electrode'
                WHEN A.ATTRIBUTE1 = 'F' THEN 'Formation'
                WHEN A.ATTRIBUTE1 = 'P' THEN 'Pack'
                ELSE '-'
              END                                                           AS SHOP_GROUP_NAME
			, A.SITE_NAME						                            AS SITE_NAME_
			, A.COMPANY_NAME						                        AS COMPANY_NAME_
			, A.PLANT_NAME						                            AS PLANT_NAME_
			, A.FACTORY_NAME					                            AS FACTORY_NAME_
			, A.LINE_NAME						                            AS LINE_NAME_
            , CASE
                WHEN A.ATTRIBUTE1 = 'A' THEN 'Assembly'
                WHEN A.ATTRIBUTE1 = 'B' THEN 'Pack'
                WHEN A.ATTRIBUTE1 = 'E' THEN 'Electrode'
                WHEN A.ATTRIBUTE1 = 'F' THEN 'Formation'
                WHEN A.ATTRIBUTE1 = 'P' THEN 'Pack'
                ELSE '-'
              END                                                           AS SHOP_GROUP_NAME_
    FROM    SCP_MST_CAPA_ELTR_LINE A WITH(NOLOCK)
    WHERE   1=1
END
/*===============================================
용		 도:  Plan Group 용 
사 용 화 면:  SCP0121
변       수:  -
최 초 작 성:  2025. 04. 23
개  발  자 :  mrchois
최 종 작 성:
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'PlanGroup'
BEGIN
	select OPMZ_PLAN_GR_ID	AS CODE
		, OPMZ_PLAN_GR_NAME	AS NAME
		, DIVISION_ID
	from SCP_OPMZ_PLAN_GR_M
   where VALID_YN = 'Y'	--[PJ20257329] Plan Group 검색조건에 삭제한 Plan Group 미표시 (2025-09-03)
END
/*===============================================
용		 도:  Activity Code 용 
사 용 화 면:  SCP0122
변       수:  -
최 초 작 성:  2025. 04. 28
개  발  자 :  mrchois
최 종 작 성:
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'ActivityCode'
BEGIN
	SELECT
		A.SEGMENT1 AS CODE
		, A.ATTRIBUTE1 AS NAME
		, A.ATTRIBUTE4 AS LINK_UI_TYPE
		, A.ATTRIBUTE5 AS PROGRAM_NAME
		, A.ATTRIBUTE6 AS CONFIRM_YN
		, A.ATTRIBUTE7 AS AUTO_YN
		, A.ATTRIBUTE8 AS OPTION_YN
	FROM (
		SELECT * 
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)
		WHERE LOOKUP_TYPE = 'OPMZ_ACTV_CD'
		AND VALID_YN = 'Y'
	)  A
	ORDER BY CODE
END
/*===============================================
용		 도:  Plan Control화면의 Plan ID 선택용 
사 용 화 면:  SCP0123
변       수:  -
최 초 작 성:  2025. 05. 13
개  발  자 :  mrchois
최 종 작 성:
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'PlanID'
BEGIN
	select OPMZ_PLAN_ID	AS CODE
		, OPMZ_PLAN_ID	AS NAME
		, OPMZ_PLAN_GR_ID
		, OPMZ_PRS_CD
		, DIVISION_ID
		, PLAN_START_YYYYMMDD
	from SCP_OPMZ_PLAN_M
  where 1=1
  and ISNULL(ATTRIBUTE10, '') != 'AI'--[PJ20257329] Plan ID 정보 조회시 ATTRIBUTE10 = 'AI' 인 정보 제외 (2025-08-20)
  and PLAN_START_YYYYMMDD between CONVERT(char(8), dateadd(month, -6, GETDATE()), 112) and CONVERT(char(8), GETDATE(), 112)	-- 현재부터 6개월전까지 대상
END
--[PJ20257329] 최적화용 Plan Date 정보 조회 추가 (2025-09-30) START
/*===============================================
용		 도:  최적화용 Plan Date 정보 조회
사 용 화 면:  SCP0123, SCP0125
변       수:  -
최 초 작 성:  2025. 09. 30
개  발  자 :  mrchois
최 종 작 성:
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'OPMZ_DATE_WEEKLY'
BEGIN
	SELECT A.PLAN_NAME        AS CODE
 	  	 , CASE WHEN FP_TARGET_YN = 'Y' THEN CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.PLAN_NAME),121) + ' (' + B.WEEK_NAME + ')'
 	  			ELSE CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.PLAN_NAME),121) + ' (' + B.WEEK_NAME + ')' + ' (No Plan)' END name
         , A.DIVISION_ID
	  FROM SCM_MST_PLAN A
     INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.PLAN_NAME = B.BASIS_YYYYMMDD
  	  LEFT JOIN (
  				SELECT DIVISION_ID
					 , PLAN_START_YYYYMMDD
					 , FP_TARGET_YN
					 , MRP_TARGET_YN
					 , DM_RTF_YN
	  			  FROM [dbo].[SCP_PLN_INTERFACE_YN] WITH(NOLOCK)
				 WHERE 1=1
  				) C ON A.PLAN_NAME		= C.PLAN_START_YYYYMMDD	
					AND A.DIVISION_ID	= C.DIVISION_ID 
	 WHERE 1=1
	   AND A.plan_cycle    = 'WEEKLY'
	   AND A.plan_name >= [dbo].[FN_GET_BUCKET_YYYYMMDD](-24)
	 ORDER BY A.PLAN_NAME DESC
END
--[PJ20257329] 최적화용 Plan Date 정보 조회 추가 (2025-09-30) END
--[PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 LINK_PLANT_SITE_CODE 정보 조회 추가 (2025-11-26) START
/*===============================================
용		 도:  JV법인 ESS 혼용 생산 시스템 개선 LINK_PLANT_SITE_CODE 정보 조회
사 용 화 면:  SCP0001 
변       수:  -
최 초 작 성:  2025. 11. 26
개  발  자 :  mrchois
최 종 작 성:
수  정  자 :
수 정 사 항:
===============================================*/
ELSE IF @Code = 'LINK_PLANT_SITE_CODE'
BEGIN
	
	SELECT LMS.SCM_SITE_ID AS CODE
		 , LMS.SCM_SITE_ID AS NAME
		 , LMS.SITE_DESCRIPTION
	FROM SCM_MST_SITE     MS WITH(NOLOCK)
	INNER JOIN SCM_MST_PLANT_SN MP WITH(NOLOCK) 
	ON  MS.PLANT_ID     = MP.PLANT_ID
	AND MS.COMPANY_ID   = MP.COMPANY_ID
	AND MS.DIVISION_ID  = MP.DIVISION_ID
	AND MP.PLANT_TYPE   = 'VIRTUAL'
	INNER JOIN SCM_MST_SITE LMS WITH(NOLOCK)
	ON  MP.LINK_PLANT_ID   = LMS.PLANT_ID
	AND MS.OPERATION_GROUP = LMS.OPERATION_GROUP
	WHERE  MS.SCM_SITE_ID = @Param1			-- 현재 RECORD SITE_ID
	AND    MS.DIVISION_ID = @Param2         -- 현재 RECORD DIVISION ID

END
--[PJ20257329] JV법인 ESS 혼용 생산 시스템 개선 LINK_PLANT_SITE_CODE 정보 조회 추가 (2025-11-26) END

ELSE


RETURN;


END
