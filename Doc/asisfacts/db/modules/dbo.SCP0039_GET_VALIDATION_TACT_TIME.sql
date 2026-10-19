
/*
 * Program ID   : SCP0039_GET_VALIDATION_TACT_TIME
 * Description  : TACT TIME 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/12/10   hwyoon			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/12/13	hwyoon			전극 제외
 * 2023/07/10	hrkim			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응 (CP 제외) 
 * 2023/07/17	hrkim			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응 (8월 해외 오픈 대응) 
 * 2025/07/10	kh  			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축
 * 2025/08/06   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : Warranty 및 OSP plant 제외 (case2, case3) 
 * 2025/08/14   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- MKT FCST 최종 수정일시 정보 추가
 *										- plan_group/line assign 참조시 scp plan operation으로 공정 참조 범위 제한
 * 2025/08/20   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- line assign 참조시 scp 계획 공정으로 제한 
 *										- line assign 참조시 유효한 라인만 참조하도록 scm_mst_line_sn 조인 참조 (active_flag = 'Y')
 *										- case 4 cell/전극 동일 plant 조건 추가 (8/20 김도형 선임님 요청)
 * 2025/08/26   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *									-- Model BOM 참조시 parent/child FP item master active 'Y'만 참조 
 * 2025/09/05   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- MKT_FCST 참조시 to AS Sales 사이트 제외 (AS_SITE_PLANT) 
 * 2025/09/12   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- 소형/ESS plan group 매핑 로직 자동차와 동일하게 적용
 *										- case 2, 3 Master Invalid 내용 변경 : Sales Site 및 Project Code 정보 제외
 *										- 소형 MKT FCST 수요계획 데이터(DM_PLN_CFM_MKT_DEMAND_PLAN) Cell Prod Site 적용 
 * 
 */
 
CREATE PROCEDURE [dbo].[SCP0039_GET_VALIDATION_TACT_TIME]  
   @p_division_id    NVARCHAR(MAX)
  ,@p_search_type    NVARCHAR(MAX)
  ,@p_plan_group_id	 NVARCHAR(MAX) 
  ,@p_item_id        NVARCHAR(MAX)
AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	
	SET NOCOUNT ON;
	
/*
--================================================================================================================================
### Capa : Tact Time 요구사항 

1) CURRENT MKT FCST DP에 입력되어 있는 '모델' 정보를 기반으로
 >> 해당 모델의 PJT ROUTE가 설정되어 있지 않은 경우

2) (조립)CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
   해당 모델의 PJT ROUTE의 'PLANT' 정보를 기반으로
 >> ASSIGN 된 PLANT 내 TACT TIME 이 조회되지 않는경우

3) (조립)CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
   해당 모델의 'LINE' ASSIGN 정보를 기반으로
 >> ASSIGN 된 LINE 내 TACT TIME 이 조회되지 않는경우

4) (전극) CURRENT 상위BOM '셀' LINE ASSIGN이 되어있는 '모델' 정보와
    해당 모델의 E2000(코팅) 공정의 BOM 정보를 기반으로
 >> 전극 LINE ASSIGN 정보가 모든 PLANT에서 없거나(LINE ASSIGN미등록)
 >> ASSIGN 된 LINE 내 TACT TIME 이 조회

5) CURRENT PROD AMEND 에 입력되어 있는 '모델'/'PLANT'/'LINE'/'생산계획날짜' 정보를 기반으로
 >> 생산계획 시기가 CAPA:TACT TIME 날짜외 구간에 입력되어 있는 경우
--================================================================================================================================

*/

-- 파라미터로 받을 값 변수  
DECLARE @v_division_id			NVARCHAR(30)	= @p_division_id
DECLARE @v_plan_group_id		NVARCHAR(30)	= @p_plan_group_id

-- 참조 기간 및 기준일자 정보 변수
DECLARE @v_from_yyyymmdd		NVARCHAR(8)		= NULL	-- 당주 월요일 (plan_start_yyyymmdd) 
DECLARE @v_to_yyyymmdd			NVARCHAR(8)		= NULL	-- horizon_end_date ?

	---------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 기준 일자 정보 ' 
	---------------------------------------------------------------------------------------------------
	-- 당주 월요일 (plan_start_yyyymmdd) 
	SELECT @v_from_yyyymmdd = MD.YYYYMMDD
	 FROM SCM_MST_BUCKET TD WITH(NOLOCK)
		  INNER JOIN SCM_MST_BUCKET MD WITH(NOLOCK) 
				  ON MD.YYYYWW = TD.YYYYWW 
				 AND MD.DAYOFWEEK = 'MON'
	WHERE 1=1
	  AND TD.YYYYMMDD = CONVERT(NVARCHAR(8), GETDATE(), 112) 

	-- plan horizon_end_date
	SELECT @v_to_yyyymmdd = PM.HORIZON_END_DATE
	  FROM SCM_MST_PLAN PM WITH(NOLOCK)
	WHERE 1=1 
	  AND PM.DIVISION_ID	= @V_DIVISION_ID
	  AND PM.PLAN_NAME		= @v_from_yyyymmdd
	  AND PM.PLAN_CYCLE		= 'WEEKLY'
	
	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' SCP Plan 공정 정보 ' -- 2025.08.14 추가
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCP_PLAN_OPERATION') IS NOT NULL DROP TABLE #SCP_PLAN_OPERATION
	SELECT DISTINCT SEGMENT1 AS OPERATION_ID 
	  INTO #SCP_PLAN_OPERATION
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE	= 'SCP_PLAN_OPERATION'
	   AND LK.VALID_YN		= 'Y'
	------------------------------------------------------------------------------------------------------------------

	PRINT '------------------------------------------------------------------';
	PRINT '@v_division_id		= ' + @v_division_id;
	PRINT '@v_from_yyyymmdd		= ' + @v_from_yyyymmdd;
	PRINT '@v_to_yyyymmdd		= ' + @v_to_yyyymmdd;
	PRINT '@v_plan_group_id		= ' + @v_plan_group_id;
	PRINT '------------------------------------------------------------------';

-- #######################################-- #######################################-- #######################################-- #######################################

--------------// start plan group info

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Plan Group Line 정보 ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#PLAN_GROUP_LINE') IS NOT NULL DROP TABLE #PLAN_GROUP_LINE
	SELECT GM.OPMZ_PLAN_GR_ID
		  ,GM.OPMZ_PLAN_GR_NAME
		  ,GM.DIVISION_ID
		  ,GL.LINE_ID
		  ,GL.FACTORY_ID
		  ,GL.PLANT_ID
		  ,GL.OPERATION_ID
		  ,GL.ITEM_ID
	INTO #PLAN_GROUP_LINE
	FROM SCP_OPMZ_PLAN_GR_LINE_M GL WITH(NOLOCK) 
		 INNER HASH JOIN SCP_OPMZ_PLAN_GR_M GM WITH(NOLOCK)
				 ON GM.OPMZ_PLAN_GR_ID = GL.OPMZ_PLAN_GR_ID
				AND GM.VALID_YN = 'Y'
		-- PJ20257329 2025.09.12 변경전  INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK) 
		-- PJ20257329 2025.09.12 변경전 		 ON DM.DIVISION_ID = GM.DIVISION_ID
		-- PJ20257329 2025.09.12 변경전 		AND DM.ATTRIBUTE3  = '81' -- 자동차만 (JV포함) 
	WHERE 1=1
	  AND GM.DIVISION_ID	= @v_division_id
	  AND GL.VALID_YN		= 'Y'
	ORDER BY GL.LINE_ID 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' ITEM Line Assign 정보 ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#ITEM_LINE_ASSIGN') IS NOT NULL DROP TABLE #ITEM_LINE_ASSIGN
	SELECT DISTINCT 
		   LA.DIVISION_ID
		  ,LA.PLANT_ID
		  ,LA.FACTORY_ID
		  ,LA.OPERATION_ID
		  ,LA.LINE_ID
		  ,LA.ITEM_ID
	 INTO #ITEM_LINE_ASSIGN  
	 FROM SCM_MST_ITEM_LINE_ASSIGN_SN LA WITH(NOLOCK)
		  INNER JOIN SCM_MST_LINE_SN LM WITH(NOLOCK)	-- 2025.08.20 PJ20257329 유효한 라인만 참조하도록 join 추가 (COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE)
				  ON LM.COMPANY_ID		= LA.COMPANY_ID
				 AND LM.DIVISION_ID		= LA.DIVISION_ID
				 AND LM.SITE_ID			= LA.SITE_ID
				 AND LM.PLANT_ID		= LA.PLANT_ID
				 AND LM.FACTORY_ID		= LA.FACTORY_ID
				 AND LM.OPERATION_ID	= LA.OPERATION_ID
				 AND LM.LINE_ID			= LA.LINE_ID 
				 AND LM.ACTIVE_FLAG		= 'Y'
		  INNER JOIN #SCP_PLAN_OPERATION PO	-- 2025.08.14 SCP Plan Operation으로 참조 범위 제한
				  ON PO.OPERATION_ID = LA.OPERATION_ID
	WHERE 1=1
	  AND LA.ACTIVE_FLAG = 'Y'
	  AND LA.DIVISION_ID = @v_division_id
	  AND LA.MONTH BETWEEN LEFT(@v_from_yyyymmdd, 6) AND  LEFT(@v_to_yyyymmdd, 6)  -- 2025.08.14 당월부터 plan horizon end date까지 참조 
	  AND LA.PRIORITY NOT IN ('0', '9') 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Plan Group Line Model 정보 ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#PLAN_GROUP_LINE_MODEL') IS NOT NULL DROP TABLE #PLAN_GROUP_LINE_MODEL    
	SELECT GL.OPMZ_PLAN_GR_ID
		  ,GL.OPMZ_PLAN_GR_NAME
		  ,GL.DIVISION_ID
		  ,GL.LINE_ID
		  ,GL.FACTORY_ID
		  ,GL.PLANT_ID
		  ,GL.OPERATION_ID
		  ,LA.ITEM_ID 
		  ,LEFT(GL.OPERATION_ID, 1) AS OPERATION_GROUP 
	 INTO #PLAN_GROUP_LINE_MODEL
	 FROM #PLAN_GROUP_LINE GL -- 62
		  INNER JOIN #ITEM_LINE_ASSIGN LA
				  ON LA.LINE_ID			= GL.LINE_ID
				 AND LA.FACTORY_ID		= GL.FACTORY_ID
				 AND LA.PLANT_ID		= GL.PLANT_ID
				 AND LA.OPERATION_ID	= GL.OPERATION_ID
				 AND LA.DIVISION_ID		= GL.DIVISION_ID
				 AND LA.ITEM_ID			= CASE WHEN GL.ITEM_ID = '-' 
											   THEN LA.ITEM_ID
											   ELSE GL.ITEM_ID
										  END 
	WHERE 1=1 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Plan Group Line Model / Cell model Basic Nick name 정보 ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#PLAN_GROUP_LINE_MODEL_BASIC_NICK') IS NOT NULL DROP TABLE #PLAN_GROUP_LINE_MODEL_BASIC_NICK 
	SELECT GM.OPMZ_PLAN_GR_ID
		  ,CONVERT(NVARCHAR(100),	GM.OPMZ_PLAN_GR_NAME)	AS OPMZ_PLAN_GR_NAME
		  ,GM.DIVISION_ID
		  ,GM.LINE_ID
		  ,GM.FACTORY_ID
		  ,GM.PLANT_ID
		  ,GM.OPERATION_ID
		  ,CONVERT(NVARCHAR(100), GM.ITEM_ID)				AS ITEM_ID  
		  ,GM.OPERATION_GROUP 
		  ,CONVERT(NVARCHAR(500), BI.BASIC_NICK_NAME)		AS BASIC_NICK_NAME
	 INTO #PLAN_GROUP_LINE_MODEL_BASIC_NICK
	 FROM #PLAN_GROUP_LINE_MODEL GM
		  INNER JOIN SCP_MST_FINAL_ITEM FP WITH(NOLOCK)	-- Final Pack 
				  ON FP.DIVISION_ID = GM.DIVISION_ID
				 AND FP.ITEM_ID		= GM.ITEM_ID
		  LEFT  JOIN SCP_MST_ITEM_BSI_IFO DE WITH(NOLOCK)   -- Doe model
		  		  ON DE.ITEM_ID			= GM.ITEM_ID
		  LEFT  JOIN SCP_MST_FINAL_ITEM DF WITH(NOLOCK)
				  ON DF.DIVISION_ID		= GM.DIVISION_ID
				 AND DF.ITEM_ID			= DE.APPLIED_DOE
		   LEFT JOIN SCP_MST_ITEM_BSI_IFO BI WITH(NOLOCK)   -- Cell Model 기준 Basic nick name 참조 
				  ON BI.ITEM_ID		= CASE WHEN GM.OPERATION_GROUP = 'P'
										   THEN ISNULL(FP.ATTRIBUTE1, DF.ATTRIBUTE1)
										   ELSE GM.ITEM_ID
									  END 
	WHERE 1=1

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Plan Group Line Model / Cell model Basic Nick name 정보 - Cell Product추가' 
	------------------------------------------------------------------------------------------------------------------
	INSERT INTO #PLAN_GROUP_LINE_MODEL_BASIC_NICK
	SELECT GM.OPMZ_PLAN_GR_ID
		  ,GM.OPMZ_PLAN_GR_NAME
		  ,GM.DIVISION_ID
		  ,GM.LINE_ID
		  ,GM.FACTORY_ID
		  ,GM.PLANT_ID
		  ,GM.OPERATION_ID
		  ,MP.ITEM_ID_PROD		AS ITEM_ID_PROD
		  ,GM.OPERATION_GROUP
		  ,GM.BASIC_NICK_NAME 
	 FROM #PLAN_GROUP_LINE_MODEL_BASIC_NICK GM
		  INNER JOIN SCP_MST_CELL_PROD_ASSY_MAP MP   -- DIVISION_ID, PLANT_ID, ITEM_ID_PROD, ITEM_ID_ASSY
				  ON MP.DIVISION_ID	= GM.DIVISION_ID
				 AND MP.PLANT_ID	= GM.PLANT_ID
				 AND MP.ITEM_ID_ASSY= GM.ITEM_ID
				 AND MP.VALID_YN='Y'                -- 2025.07.24 추가(김혜라 C)
	WHERE 1=1
	  AND GM.OPERATION_GROUP	= 'A'

--------------// end plan group info

-- #######################################-- #######################################-- #######################################-- #######################################

--//########################### case 1 Start
/*
1) CURRENT MKT FCST DP에 입력되어 있는 '모델' 정보를 기반으로
 >> 해당 모델의 PJT ROUTE가 설정되어 있지 않은 경우
*/

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' AS_SITE_PLANT ' -- PJ20257329 2025.09.05 AS Sales Site 제외
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#AS_SITE_PLANT') IS NOT NULL DROP TABLE #AS_SITE_PLANT
	SELECT DISTINCT 
			SEGMENT1 AS SCM_SITE_ID
		   ,SEGMENT3 AS DIVISION_ID 
	 INTO #AS_SITE_PLANT
	 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	WHERE 1=1
	  AND LK.LOOKUP_TYPE	= 'AS_SITE_PLANT'
	  AND VALID_YN			= 'Y'

	------------------------------------------------------------------------------------------------------------------
	-- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 -- Start  
	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' MKT FCST Cell Prod Site 정보' 
	-- PK : DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, CELL_PROD_SITE_ID
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#DM_PLN_CFM_MKT_DEMAND_PLAN') IS NOT NULL DROP TABLE #DM_PLN_CFM_MKT_DEMAND_PLAN
	SELECT DP.DIVISION_ID
		 , DP.PROJECT_CODE
		 , DP.SCM_SITE_ID
		 , DP.ITEM_ID
		 , DP.DOM_EXP
		 , DP.FCST_TYPE
		 , DP.INCOTERMS
		 , DP.MEASURE
		 , DP.YYYYMMDD
		 , DP.PLANT_SITE_ID 
		 , DP.CELL_PROD_SITE_ID
		 , SM.COMPANY_ID
		 , SM.SITE_ID
		 , CASE WHEN SM.OSP_YN = 'Y' 
			   THEN SM.LOGISTIC_PLANT_ID
				ELSE SM.PLANT_ID 
			END AS PLANT_ID 
		 , ROW_NUMBER() OVER (PARTITION BY DP.DIVISION_ID
										 , DP.PROJECT_CODE
										 , DP.SCM_SITE_ID
										 , DP.ITEM_ID
										 , DP.DOM_EXP
										 , DP.FCST_TYPE
										 , DP.INCOTERMS
										 , DP.MEASURE
										 , DP.YYYYMMDD
										 , DP.PLANT_SITE_ID
								 ORDER BY CELL_PROD_SITE_ID) AS RN 
	  INTO #DM_PLN_CFM_MKT_DEMAND_PLAN 
	  FROM DM_PLN_CFM_MKT_DEMAND_PLAN DP WITH(NOLOCK)
		   INNER JOIN SCM_MST_SITE SM WITH(NOLOCK)
				   ON SM.DIVISION_ID = DP.DIVISION_ID
				  AND SM.SCM_SITE_ID = DP.CELL_PROD_SITE_ID 
	WHERE 1=1
	  AND DP.DIVISION_ID = CASE WHEN @v_division_id = '40' -- 소형 전용 
								THEN @v_division_id
								ELSE NULL
							END 
	  AND DP.MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'AS_In_Req') 
	  AND DP.YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
	  AND DP.CELL_PROD_SITE_ID NOT IN ('-', '') 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' #CELL_PROD_SITE_ID (UP_FX_GetCommonDataList) ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#CELL_PROD_SITE_ID') IS NOT NULL DROP TABLE #CELL_PROD_SITE_ID
	  CREATE TABLE #CELL_PROD_SITE_ID (
		 CODE	NVARCHAR(50)	NULL
		,NAME	NVARCHAR(100)	NULL 
	  )

	  INSERT INTO #CELL_PROD_SITE_ID
	  exec UP_FX_GetCommonDataList
	  @Code			= 'CELL_PROD_SITE_ID'
	, @Param1		= NULL 
	, @Param2		= NULL 
	, @Param3		= NULL 
	, @Param4		= NULL 
	, @Param5		= NULL 
	, @TimeZone		= NULL 
	------------------------------------------------------------------------------------------------------------------
	-- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 -- End  
	------------------------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' MKT FCST' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#MKT_FCST') IS NOT NULL DROP TABLE #MKT_FCST
	SELECT MK.SCM_SITE_ID		AS SALES_SITE_ID	
		  ,MK.PROJECT_CODE		AS PROJECT_CODE	
		  ,MK.ITEM_ID			AS SALES_ITEM_ID
		  ,MK.INCOTERMS
		  ,LEFT(FI.FLOW_ID,5)	AS MODEL_OPERATION_ID
		  ,FI.OPERATION_GROUP	AS MODEL_OPERATION_GROUP
		  ,FI.NICK_NAME			AS MODEL_NICK_NAME
		  ,MIN(MK.YYYYMMDD)		AS SALES_FROM_YYYYMMDD
		  ,MAX(MK.YYYYMMDD)		AS SALES_TO_YYYYMMDD
		  ,SUM(CASE WHEN ISNULL(DP.RN, 1) = 1 THEN MK.QTY ELSE 0 END)	AS QTY					-- PJ20257329 2025.09.12 소형 Cell Prod Site 적용
		  ,CONVERT(NVARCHAR(50), MAX(MK.LAST_UPDATE_DATE), 120)	AS MF_LAST_UPDATE_DATE	-- 2025.08.14 추가
		  -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	Start 
		  ,DP.CELL_PROD_SITE_ID	
		  ,DP.COMPANY_ID		AS COMPANY_ID_CELL_PROD
		  ,DP.SITE_ID			AS SITE_ID_CELL_PROD
		  ,DP.PLANT_ID			AS PLANT_ID_CELL_PROD
		  -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	End 
	 INTO #MKT_FCST
	 FROM DM_PLN_MKT_FCST MK WITH(NOLOCK)    -- DIVISION_ID, MEASURE, YYYYMMDD
		  INNER JOIN SCM_MST_SITE WS WITH(NOLOCK) 
				  ON WS.DIVISION_ID		 =	MK.DIVISION_ID 
				 AND WS.SCM_SITE_ID		 =	MK.SCM_SITE_ID 
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
				  ON FI.DIVISION_ID		 = MK.DIVISION_ID
				 AND FI.ITEM_ID			 = MK.ITEM_ID 
				 AND FI.OPERATION_GROUP != 'E'		-- 전극 제외 
		-- PJ20257329 2025.09.05 AS Sales Site 제외 - start 
		  LEFT  JOIN #AS_SITE_PLANT SS
				  ON SS.SCM_SITE_ID		= MK.SCM_SITE_ID
				 AND SS.DIVISION_ID		= MK.DIVISION_ID
		-- PJ20257329 2025.09.05 AS Sales Site 제외 - End 
		-- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 -- Start  
		  LEFT  JOIN #DM_PLN_CFM_MKT_DEMAND_PLAN DP WITH(NOLOCK) 
				  ON DP.DIVISION_ID			= MK.DIVISION_ID
				 AND DP.PROJECT_CODE		= MK.PROJECT_CODE
				 AND DP.SCM_SITE_ID			= MK.SCM_SITE_ID
				 AND DP.ITEM_ID				= MK.ITEM_ID
				 AND DP.DOM_EXP				= MK.DOM_EXP
				 AND DP.FCST_TYPE			= MK.FCST_TYPE
				 AND DP.INCOTERMS			= MK.INCOTERMS
				 AND DP.MEASURE				= MK.MEASURE
				 AND DP.YYYYMMDD			= MK.YYYYMMDD
				 AND DP.PLANT_SITE_ID		= MK.PLANT_SITE_ID
		-- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 -- End  
	WHERE 1=1
	  AND MK.DIVISION_ID	= @v_division_id
	  AND MK.MEASURE		= CASE WHEN WS.SITE_TYPE = 'SALES' AND WS.OPERATION_GROUP = 'W'	THEN 'AS_In_Req' 
								   WHEN WS.VMI_YN = 'Y'										THEN 'VMI_In_Req' 
								   WHEN ISNULL(MK.ATTRIBUTE10, '') = ''						THEN 'MKT_FCST' 
							  END
	  AND MK.YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
	  AND MK.QTY		   != 0 
	  AND SS.SCM_SITE_ID IS NULL -- PJ20257329 2025.09.05 AS Sales Site 제외 
	GROUP BY MK.SCM_SITE_ID	
		    ,MK.PROJECT_CODE
		    ,MK.ITEM_ID		
			,MK.INCOTERMS	
			,FI.FLOW_ID		
			,FI.OPERATION_GROUP 
			,FI.NICK_NAME
		  -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	Start 
		    ,DP.CELL_PROD_SITE_ID	
		    ,DP.COMPANY_ID
		    ,DP.SITE_ID	
		    ,DP.PLANT_ID
		  -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	End 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' BOM ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCP_BOM') IS NOT NULL DROP TABLE #SCP_BOM  

	SELECT DISTINCT--- TOP 100 
		   BO.MODEL_ID
		  -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	Start
		  ,BO.COMPANY_ID
		  ,BO.SITE_ID
		  ,BO.PLANT_ID
		  -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	End 
		  ,BO.CHILD_ITEM_ID
		  ,FI.OPERATION_GROUP 		AS CHILD_OPERATION_GROUP
		  ,LEFT(FI.FLOW_ID,5)		AS CHILD_OPERATION_ID 
		  ,FI.ELECTRODE_TYPE		AS CHILD_ELECTRODE_TYPE
		  ,FI.ATTRIBUTE8			AS CELL_TYPE 
		  ,FI.NICK_NAME				AS CHILD_NICK_NAME
	 INTO #SCP_BOM
	 FROM SCM_MST_MODEL_BOM BO WITH(NOLOCK) -- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CONCATENATE_ITEM
		-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조 -- start 
		  LEFT  JOIN SCM_MST_ITEM_SN P WITH(NOLOCK)		  
				  ON P.ITEM_ID		= BO.PARENT_ITEM_ID	  
				 AND P.COMPANY_ID	= BO.COMPANY_ID		  
				 AND P.DIVISION_ID	= BO.DIVISION_ID	  
				 AND P.SITE_ID		= BO.SITE_ID		  
				 AND P.ACTIVE_FLAG  = 'Y'
		-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조 -- end 
		  INNER JOIN SCM_MST_ITEM_SN IM WITH(NOLOCK)
				  ON IM.ITEM_ID		= BO.CHILD_ITEM_ID
				 AND IM.COMPANY_ID	= BO.CHILD_COMPANY_ID
				 AND IM.DIVISION_ID	= BO.CHILD_DIVISION_ID
				 AND IM.SITE_ID		= BO.CHILD_SITE_ID
				 AND IM.ACTIVE_FLAG = 'Y'						-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON FI.DIVISION_ID	= BO.DIVISION_ID
				 AND FI.ITEM_ID		= BO.CHILD_ITEM_ID
	WHERE 1=1
	  AND BO.DIVISION_ID	= @v_division_id
	  AND BO.ALT_PRIORITY	= 'Y'
	  AND (BO.PARENT_ITEM_ID = '*'  OR P.ITEM_ID IS NOT NULL)	-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조
	  AND EXISTS (SELECT TOP 1 'X' 
				    FROM #MKT_FCST MK 
				   WHERE BO.MODEL_ID	= MK.SALES_ITEM_ID
				   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 Start 
				     AND BO.COMPANY_ID	= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND FI.OPERATION_GROUP = 'A'
											   THEN MK.COMPANY_ID_CELL_PROD
											   ELSE BO.COMPANY_ID
										  END 
				     AND BO.SITE_ID		= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND FI.OPERATION_GROUP = 'A'
											   THEN MK.SITE_ID_CELL_PROD
											   ELSE BO.SITE_ID
										  END 
				     AND BO.PLANT_ID	= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND FI.OPERATION_GROUP = 'A'
											   THEN MK.PLANT_ID_CELL_PROD
											   ELSE BO.PLANT_ID
										  END 
				   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 End 
				   ) 

	-------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Cell Assy/Prod Mapping 정보' 
	-------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#CELL_PROD_ASSY_MAP') IS NOT NULL DROP TABLE #CELL_PROD_ASSY_MAP 
	SELECT M.DIVISION_ID
		  ,M.PLANT_ID
		  ,M.ITEM_ID_ASSY
		  ,M.ITEM_ID_PROD
		  ,F.NICK_NAME			AS ITEM_ID_PROD_NICK_NAME
		  ,MM.CHILD_ITEM_ID
		  ,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
										  ,M.PLANT_ID
										  ,M.ITEM_ID_ASSY
								  ORDER BY CASE WHEN MM.CHILD_ITEM_ID IS NOT NULL 
												THEN 1
												ELSE 0 
											END DESC 
									      ,M.ITEM_ID_PROD DESC) AS ITEM_ID_PROD_PRIORITY
		  ,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
										  ,M.ITEM_ID_ASSY
								  ORDER BY CASE WHEN MM.CHILD_ITEM_ID IS NOT NULL 
												THEN 1
												ELSE 0 
											END DESC 
									      ,M.ITEM_ID_PROD DESC) AS ITEM_ID_PROD_PRIORITY2
	 INTO #CELL_PROD_ASSY_MAP
	 FROM SCP_MST_CELL_PROD_ASSY_MAP M WITH(NOLOCK)  -- DIVISION_ID, PLANT_ID, ITEM_ID_PROD, ITEM_ID_ASSY
		  INNER JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
				  ON F.DIVISION_ID		= M.DIVISION_ID
				 AND F.ITEM_ID			= M.ITEM_ID_PROD
		  LEFT JOIN #SCP_BOM MM 
				  ON MM.CHILD_ITEM_ID	= M.ITEM_ID_PROD
	WHERE 1=1
	  AND M.DIVISION_ID	= @v_division_id 
	  AND M.VALID_YN	= 'Y'  

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' PROJECT ROUTE ' 
	-- 40/82 소형과 ESS는 Sales site 및 project Code 값이 없음 ('-')
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#PROJECT_ROUTE') IS NOT NULL DROP TABLE #PROJECT_ROUTE

	SELECT PR.ITEM_ID
		  ,PR.SALES_SITE_ID		
		  ,PR.PROJECT_CODE		
		  ,PR.PLANT_SITE_ID
		  ,PR.FROM_YYYYMMDD
		  ,PR.TO_YYYYMMDD
		  ,PS.COUNTRY
		  ,PS.CITY
		  ,ROW_NUMBER() OVER (PARTITION BY PR.ITEM_ID
										  ,PR.SALES_SITE_ID		
										  ,PR.PROJECT_CODE
										  ,PR.FROM_YYYYMMDD
										  ,PR.TO_YYYYMMDD
								  ORDER BY PR.PRIORITY ) AS PR_PRIORITY
	 INTO #PROJECT_ROUTE
	 FROM SCM_MST_SITE_ITEM_PRIORITY PR WITH(NOLOCK)
		  INNER JOIN SCM_MST_SITE PS WITH(NOLOCK)
				  ON PS.DIVISION_ID = PR.DIVISION_ID
				 AND PS.SCM_SITE_ID = PR.PLANT_SITE_ID
				 AND PS.SITE_TYPE	= 'PLANT'
				 AND PS.VALID_YN	= 'Y'
	WHERE 1=1
	  AND PR.DIVISION_ID  = @v_division_id
	  AND PR.VALID_YN	  = 'Y'
	  AND PR.TO_YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE(), 112) 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' MKT FCST 기준 Project Route 존재하지 않는 데이터' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#PROJECT_ROUTE_NOT_EXISTS') IS NOT NULL DROP TABLE #PROJECT_ROUTE_NOT_EXISTS
	SELECT MK.*
		  ,BO.CHILD_ITEM_ID
		  ,BO.CHILD_OPERATION_GROUP
		  ,BO.CHILD_OPERATION_ID
		  ,CONVERT(NVARCHAR(200),'COM01'	)																				AS MASTER_INVLD_CD 
		  ,CONVERT(NVARCHAR(200), CONCAT('Target Item:',BO.CHILD_ITEM_ID, ', FCST Last Update :',MK.MF_LAST_UPDATE_DATE))	AS MASTER_INVLD_CTN  -- 상세내용 -- 2025.08.14 수요 최종 변경일 추가
	 INTO #PROJECT_ROUTE_NOT_EXISTS
	 FROM #MKT_FCST MK
		  INNER JOIN #SCP_BOM BO 
				  ON MK.SALES_ITEM_ID = BO.MODEL_ID
			   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 Start 
			     AND BO.COMPANY_ID	= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND BO.CHILD_OPERATION_GROUP = 'A'
										   THEN MK.COMPANY_ID_CELL_PROD
										   ELSE BO.COMPANY_ID
									  END 
			     AND BO.SITE_ID		= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND BO.CHILD_OPERATION_GROUP = 'A'
										   THEN MK.SITE_ID_CELL_PROD
										   ELSE BO.SITE_ID
									  END 
			     AND BO.PLANT_ID	= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND BO.CHILD_OPERATION_GROUP = 'A'
										   THEN MK.PLANT_ID_CELL_PROD
										   ELSE BO.PLANT_ID
									  END 
			   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 End 
	WHERE 1=1 
	  AND BO.CHILD_OPERATION_GROUP != 'E'
	  AND BO.CELL_TYPE NOT LIKE 'CA%'
	  AND NOT EXISTS (SELECT 'X'
					   FROM #PROJECT_ROUTE PR
					  WHERE PR.ITEM_ID			= BO.CHILD_ITEM_ID
					    -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 Start 
					    AND PR.PLANT_SITE_ID	= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND BO.CHILD_OPERATION_GROUP = 'A'
													   THEN MK.CELL_PROD_SITE_ID 
													   ELSE PR.PLANT_SITE_ID
												  END 
					    -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 Start 
						AND PR.PROJECT_CODE		= CASE WHEN @v_division_id IN ('40', '82') OR BO.CHILD_OPERATION_GROUP = 'E'
													   THEN '-'
													   ELSE MK.PROJECT_CODE
												  END 
						AND PR.SALES_SITE_ID	= CASE WHEN @v_division_id IN ('40', '82') OR BO.CHILD_OPERATION_GROUP = 'E'
													   THEN '-'
													   ELSE MK.SALES_SITE_ID
												   END )

--//########################### case 2 Start
/*
2) (조립)CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
   해당 모델의 PJT ROUTE의 'PLANT' 정보를 기반으로
 >> ASSIGN 된 PLANT 내 TACT TIME 이 조회되지 않는경우
*/
	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' FP Tact Time ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#FP_TACT_TIME') IS NOT NULL DROP TABLE #FP_TACT_TIME
	SELECT DISTINCT 
		   PLANT_SITE_ID
		  ,ITEM_ID
		  ,OPERATION_ID
		  ,LINE_ID
		  ,MONTH
	 INTO #FP_TACT_TIME
	 FROM SCM_MST_TACT_TIME_VER_H_V WITH(NOLOCK)
	WHERE 1=1
	  AND DIVISION_ID = @v_division_id
	  AND TACT_TIME	  > 0 
	  AND MONTH		 BETWEEN LEFT(@v_from_yyyymmdd, 6) AND  LEFT(@v_to_yyyymmdd, 6)  -- 2025.08.20 PJ20257329 

	CREATE INDEX #FP_TACT_TIME_IDX1 ON #FP_TACT_TIME(PLANT_SITE_ID, ITEM_ID) 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' SCP Tact Time ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCP_TACT_TIME') IS NOT NULL DROP TABLE #SCP_TACT_TIME
	SELECT DISTINCT 
		   PLANT_SITE_ID
		  ,ITEM_ID
		  ,LINE_ID
		  ,OPERATION_ID
	 INTO #SCP_TACT_TIME
	 FROM SCP_MST_TACT_TIME WITH(NOLOCK)  
	WHERE 1=1
	  AND DIVISION_ID = @v_division_id
	  AND TACT_TIME	  > 0
	  AND VALID_YN	  = 'Y'

	CREATE INDEX #SCP_TACT_TIME_IDX1 ON #SCP_TACT_TIME(PLANT_SITE_ID, ITEM_ID) 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' SCP Tact Time Except' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCP_TACT_TIME_EXCEPT') IS NOT NULL DROP TABLE #SCP_TACT_TIME_EXCEPT
	SELECT DISTINCT 
		   PLANT_SITE_ID
		  ,ITEM_ID
		  ,LINE_ID
		  ,OPERATION_ID
	 INTO #SCP_TACT_TIME_EXCEPT 
	 FROM SCP_MST_TACT_TIME_EXCEPT WITH(NOLOCK)  
	WHERE 1=1
	  AND DIVISION_ID			= @v_division_id
	  AND TACT_TIME_END_DATE	> @v_from_yyyymmdd
	  AND TACT_TIME				> 0
	  AND USE_YN				= 'Y'

	CREATE INDEX #SCP_TACT_TIME_EXCEPT_IDX1 ON #SCP_TACT_TIME_EXCEPT(PLANT_SITE_ID, ITEM_ID) 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 조립/팩/전극 Tact Time 누락 데이터 (MKT_FCST & BOM & PROJECT_ROUTE)' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TACT_TIME_CASE_2') IS NOT NULL DROP TABLE #TACT_TIME_CASE_2
	SELECT DISTINCT 
		   PR.PLANT_SITE_ID
		 , PS.SITE_DESCRIPTION	AS PLANT_SITE 
		 , CASE WHEN BO.CHILD_OPERATION_GROUP = 'A'
				THEN ISNULL(ISNULL(MP.ITEM_ID_PROD, MP2.ITEM_ID_PROD), PR.ITEM_ID) 
				ELSE PR.ITEM_ID
			END AS MODEL_ID 
		 , BO.CHILD_OPERATION_GROUP 
		 , BO.CHILD_OPERATION_ID
		 -- , MK.SALES_SITE_ID 
		 -- , MK.PROJECT_CODE
		 -- , MK.SALES_ITEM_ID
		 , PS.COMPANY_ID
		 , PS.DIVISION_ID
		 , PS.SITE_ID
		 , PS.PLANT_ID
		 ,CONCAT('Sales Model:',MK.SALES_ITEM_ID) AS DESCR		-- PJ20257329 2025.09.12 Sales Site 및 Project Code 정보 제외 
		 -- PJ20257329 2025.09.12 변경전 ,CONCAT('Sales Model:',MK.SALES_ITEM_ID ,', Project : ',PR.PROJECT_CODE, ', SalesSite : ', PR.SALES_SITE_ID) AS DESCR
	 INTO #TACT_TIME_CASE_2 
	 FROM #MKT_FCST MK
		  INNER JOIN #SCP_BOM BO 
				  ON BO.MODEL_ID = MK.SALES_ITEM_ID 
				 AND ISNULL(BO.CELL_TYPE,'-') != 'CP'	-- Cell Tact Time 은 Cell Assy 기준으로 관리 ? 
				 AND BO.CHILD_OPERATION_GROUP != 'E' -- 전극 제외 
			   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 Start 
			     AND BO.COMPANY_ID	= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND BO.CHILD_OPERATION_GROUP = 'A'
										   THEN MK.COMPANY_ID_CELL_PROD
										   ELSE BO.COMPANY_ID
									  END 
			     AND BO.SITE_ID		= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND BO.CHILD_OPERATION_GROUP = 'A'
										   THEN MK.SITE_ID_CELL_PROD
										   ELSE BO.SITE_ID
									  END 
			     AND BO.PLANT_ID	= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND BO.CHILD_OPERATION_GROUP = 'A'
										   THEN MK.PLANT_ID_CELL_PROD
										   ELSE BO.PLANT_ID
									  END 
			   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 End 
		  INNER JOIN #PROJECT_ROUTE PR
				  ON PR.ITEM_ID			= BO.CHILD_ITEM_ID
				 AND PR.PROJECT_CODE	= CASE WHEN @v_division_id IN ('40', '82') OR BO.CHILD_OPERATION_GROUP = 'E'
				 							   THEN '-'
				 							   ELSE MK.PROJECT_CODE
				 						  END 
				 AND PR.SALES_SITE_ID	= CASE WHEN @v_division_id IN ('40', '82') OR BO.CHILD_OPERATION_GROUP = 'E'
				 							   THEN '-'
				 							   ELSE MK.SALES_SITE_ID
				 						   END
		  INNER JOIN SCM_MST_SITE PS WITH(NOLOCK) -- plant site 
				  ON PS.VALID_YN	= 'Y'
				 AND PS.SITE_TYPE	= 'PLANT'
				 AND PS.SCM_SITE_ID	= PR.PLANT_SITE_ID
				 AND ISNULL(PS.OPERATION_GROUP,'Z') != 'W'	-- 2025.08.06 Warranty Plant 제외 
				 AND ISNULL(PS.OSP_YN,'Z')			!= 'Y'	-- 2025.08.06 OSP제외 
		  LEFT  JOIN #CELL_PROD_ASSY_MAP MP
				  ON MP.DIVISION_ID		= PS.DIVISION_ID
				 AND MP.PLANT_ID		= PS.PLANT_ID
				 AND MP.ITEM_ID_ASSY	= PR.ITEM_ID
				 AND MP.ITEM_ID_PROD_PRIORITY = 1 
		  LEFT  JOIN #CELL_PROD_ASSY_MAP MP2
				  ON MP2.DIVISION_ID	= PS.DIVISION_ID
				 AND MP2.ITEM_ID_ASSY	= PR.ITEM_ID
				 AND MP2.ITEM_ID_PROD_PRIORITY2 = 1 
	WHERE 1=1
	  AND CHILD_OPERATION_ID NOT LIKE 'F%'   
	  AND NOT EXISTS (SELECT 'X'	-- fp tact time 
					   FROM #FP_TACT_TIME TT 
					  WHERE 1=1
					    AND TT.PLANT_SITE_ID	= PR.PLANT_SITE_ID
						AND TT.ITEM_ID			= PR.ITEM_ID
						--6/30 F6000 공정 불일치 AND TT.OPERATION_ID		= BO.CHILD_OPERATION_ID
						) 
	  AND NOT EXISTS (SELECT 'X'  
					   FROM #SCP_TACT_TIME TT WITH(NOLOCK)
					  WHERE 1=1
					    AND TT.PLANT_SITE_ID	= PR.PLANT_SITE_ID
						AND TT.ITEM_ID			= PR.ITEM_ID
						--6/30 F6000 공정 불일치 AND TT.OPERATION_ID		= BO.CHILD_OPERATION_ID
						) 
	  AND NOT EXISTS (SELECT 'X'
					   FROM #SCP_TACT_TIME_EXCEPT TT WITH(NOLOCK) 
					  WHERE 1=1
					    AND TT.PLANT_SITE_ID	= PR.PLANT_SITE_ID
						AND TT.ITEM_ID			= PR.ITEM_ID
						--6/30 F6000 공정 불일치 AND TT.OPERATION_ID		= BO.CHILD_OPERATION_ID
						) 



--//########################### case 3 Start

/*
3) (조립)CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
   해당 모델의 'LINE' ASSIGN 정보를 기반으로
 >> ASSIGN 된 LINE 내 TACT TIME 이 조회되지 않는경우
*/
	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Line Assign된 모델 ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#LINE_ASSIGN_MODEL') IS NOT NULL DROP TABLE #LINE_ASSIGN_MODEL
	SELECT -- DISTINCT --- top 100 
		   LA.COMPANY_ID
		  ,LA.DIVISION_ID
		  ,LA.SITE_ID
		  ,LA.PLANT_ID
		  ,LA.LINE_ID 
		  ,LA.ITEM_ID
		  ,MAX(FI.NICK_NAME)	AS NICK_NAME
	 INTO #LINE_ASSIGN_MODEL
	 FROM SCM_MST_ITEM_LINE_ASSIGN_SN LA WITH(NOLOCK)	-- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, MONTH 
		  INNER JOIN SCM_MST_LINE_SN LM WITH(NOLOCK)	-- 2025.08.20 PJ20257329 유효한 라인만 참조하도록 join 추가 (COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE)
				  ON LM.COMPANY_ID		= LA.COMPANY_ID
				 AND LM.DIVISION_ID		= LA.DIVISION_ID
				 AND LM.SITE_ID			= LA.SITE_ID
				 AND LM.PLANT_ID		= LA.PLANT_ID
				 AND LM.FACTORY_ID		= LA.FACTORY_ID
				 AND LM.OPERATION_ID	= LA.OPERATION_ID
				 AND LM.LINE_ID			= LA.LINE_ID 
				 AND LM.ACTIVE_FLAG		= 'Y'
		  INNER JOIN #SCP_PLAN_OPERATION PO				-- 2025.08.20 PJ20257329 SCP Plan Operation으로 참조 범위 제한
				  ON PO.OPERATION_ID = LA.OPERATION_ID
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON FI.DIVISION_ID		= LA.DIVISION_ID
				 AND FI.ITEM_ID			= LA.ITEM_ID
				 AND FI.OPERATION_GROUP!= 'E' -- 전극 제외 -- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE
	WHERE 1=1
	  AND LA.DIVISION_ID = @v_division_id
	  AND LA.MONTH BETWEEN LEFT(@v_from_yyyymmdd, 6) AND  LEFT(@v_to_yyyymmdd, 6)
	  AND LA.ACTIVE_FLAG = 'Y'
	  AND LA.PRIORITY	NOT IN ('0', '9') 
	GROUP BY LA.COMPANY_ID
		    ,LA.DIVISION_ID
		    ,LA.SITE_ID
		    ,LA.PLANT_ID
		    ,LA.LINE_ID 
		    ,LA.ITEM_ID

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 조립/팩 Tact Time 누락 데이터 (MKT_FCST & BOM & Line Assign)' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TACT_TIME_CASE_3') IS NOT NULL DROP TABLE #TACT_TIME_CASE_3
	SELECT DISTINCT 
		   PS.SCM_SITE_ID		AS PLANT_SITE_ID
		 , PS.SITE_DESCRIPTION	AS PLANT_SITE
		 , CASE WHEN BO.CHILD_OPERATION_GROUP = 'A'
				THEN ISNULL(ISNULL(MP.ITEM_ID_PROD, MP2.ITEM_ID_PROD), LA.ITEM_ID) 
				ELSE LA.ITEM_ID
			END AS MODEL_ID 
		 , LA.LINE_ID
		 , BO.CHILD_OPERATION_GROUP 
		 , BO.CHILD_OPERATION_ID
		 -- , MK.SALES_SITE_ID 
		 -- , MK.PROJECT_CODE
		 -- , MK.SALES_ITEM_ID
		 , LA.COMPANY_ID
		 , LA.DIVISION_ID
		 , LA.SITE_ID
		 , LA.PLANT_ID
		 ,CONCAT('Sales Model:',MK.SALES_ITEM_ID ) AS DESCR -- PJ20257329 2025.09.12 Sales Site 및 Project Code 정보 제외 
		  -- PJ20257329 2025.09.12 변경전 ,CONCAT('Sales Model:',MK.SALES_ITEM_ID ,', Project : ',MK.PROJECT_CODE, ', SalesSite : ', MK.SALES_SITE_ID) AS DESCR
	 INTO #TACT_TIME_CASE_3
	 FROM #MKT_FCST MK
		  INNER JOIN #SCP_BOM BO 
				  ON BO.MODEL_ID = MK.SALES_ITEM_ID 
			   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 Start 
			     AND BO.COMPANY_ID	= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND BO.CHILD_OPERATION_GROUP = 'A'
										   THEN MK.COMPANY_ID_CELL_PROD
										   ELSE BO.COMPANY_ID
									  END 
			     AND BO.SITE_ID		= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND BO.CHILD_OPERATION_GROUP = 'A'
										   THEN MK.SITE_ID_CELL_PROD
										   ELSE BO.SITE_ID
									  END 
			     AND BO.PLANT_ID	= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND BO.CHILD_OPERATION_GROUP = 'A'
										   THEN MK.PLANT_ID_CELL_PROD
										   ELSE BO.PLANT_ID
									  END 
			   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 End 
				 AND ISNULL(BO.CELL_TYPE,'-') != 'CP'	-- Cell Tact Time 은 Cell Assy 기준으로 관리 ? 
				 AND BO.CHILD_OPERATION_GROUP != 'E'	-- 전극 제외 
		  INNER JOIN #LINE_ASSIGN_MODEL LA				-- 전극을 제외한 Line Assign된 모델 
				  ON LA.ITEM_ID		= BO.CHILD_ITEM_ID
		  INNER JOIN SCM_MST_SITE PS WITH(NOLOCK)
				  ON PS.DIVISION_ID		= LA.DIVISION_ID
				 AND PS.PLANT_ID		= LA.PLANT_ID
				 AND PS.SITE_TYPE		= 'PLANT'
				 AND PS.OPERATION_GROUP = BO.CHILD_OPERATION_GROUP 
				 AND PS.VALID_YN		= 'Y'
				 AND ISNULL(PS.OPERATION_GROUP,'Z') != 'W'	-- 2025.08.06 Warranty Plant 제외 
				 AND ISNULL(PS.OSP_YN,'Z')			!= 'Y'	-- 2025.08.06 OSP제외 
		  LEFT  JOIN #CELL_PROD_ASSY_MAP MP
				  ON MP.DIVISION_ID		= LA.DIVISION_ID
				 AND MP.PLANT_ID		= LA.PLANT_ID
				 AND MP.ITEM_ID_ASSY	= LA.ITEM_ID
				 AND MP.ITEM_ID_PROD_PRIORITY = 1 
		  LEFT  JOIN #CELL_PROD_ASSY_MAP MP2
				  ON MP2.DIVISION_ID	= LA.DIVISION_ID
				 AND MP2.ITEM_ID_ASSY	= LA.ITEM_ID
				 AND MP2.ITEM_ID_PROD_PRIORITY2 = 1 
	WHERE 1=1
	  AND CHILD_OPERATION_ID NOT LIKE 'F%'   
	  AND NOT EXISTS (SELECT 'X'	-- fp tact time 
					   FROM #FP_TACT_TIME TT 
					  WHERE 1=1
					    AND TT.PLANT_SITE_ID	= PS.SCM_SITE_ID
						AND TT.ITEM_ID			= LA.ITEM_ID
						AND TT.LINE_ID			= LA.LINE_ID
						-- 6/30 Formation operation이 다름 ?  AND TT.OPERATION_ID		= BO.CHILD_OPERATION_ID
						) 
	  AND NOT EXISTS (SELECT 'X'  
					   FROM #SCP_TACT_TIME TT WITH(NOLOCK)
					  WHERE 1=1
					    AND TT.PLANT_SITE_ID	= PS.SCM_SITE_ID -- Plant site 
						AND TT.LINE_ID			= LA.LINE_ID
						AND TT.ITEM_ID			= LA.ITEM_ID
						-- 6/30 Formation operation이 다름 ?   AND TT.OPERATION_ID		= BO.CHILD_OPERATION_ID
						) 
	  AND NOT EXISTS (SELECT 'X' 
					   FROM #SCP_TACT_TIME_EXCEPT TT WITH(NOLOCK)
					  WHERE 1=1
					    AND TT.PLANT_SITE_ID	= PS.SCM_SITE_ID -- Plant site 
						AND TT.LINE_ID			= LA.LINE_ID
						AND TT.ITEM_ID			= LA.ITEM_ID
						-- 6/30 Formation operation이 다름 ?   AND TT.OPERATION_ID		= BO.CHILD_OPERATION_ID
						) 


--//########################### case 4 Start

/*
4) (전극) CURRENT 상위BOM '셀' LINE ASSIGN이 되어있는 '모델' 정보와
    해당 모델의 E2000(코팅) 공정의 BOM 정보를 기반으로
 >> 전극 LINE ASSIGN 정보가 모든 PLANT에서 없거나(LINE ASSIGN미등록)
 >> ASSIGN 된 LINE 내 TACT TIME 이 조회
*/
	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' MKT_FCST 기준 Model Cell BOM  ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#MKT_FCST_MODEL_CELL_BOM') IS NOT NULL DROP TABLE #MKT_FCST_MODEL_CELL_BOM
	SELECT DISTINCT--- TOP 100 
		   BO.MODEL_ID
		  ,BO.CHILD_ITEM_ID
		  ,CASE WHEN FI.OPERATION_GROUP_ID NOT IN ('A', 'E')
				THEN 'P'
				ELSE FI.OPERATION_GROUP_ID	
		   END						AS CHILD_OPERATION_GROUP
		  ,LEFT(FI.FLOW_ID,5)		AS CHILD_OPERATION_ID 
		  ,FI.ELECTRODE_TYPE		AS CHILD_ELECTRODE_TYPE
	 INTO #MKT_FCST_MODEL_CELL_BOM
	 FROM SCM_MST_MODEL_BOM BO WITH(NOLOCK) -- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CONCATENATE_ITEM
		-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조 -- start 
		  LEFT  JOIN SCM_MST_ITEM_SN P WITH(NOLOCK)		  
				  ON P.ITEM_ID		= BO.PARENT_ITEM_ID	  
				 AND P.COMPANY_ID	= BO.COMPANY_ID		  
				 AND P.DIVISION_ID	= BO.DIVISION_ID	  
				 AND P.SITE_ID		= BO.SITE_ID		  
				 AND P.ACTIVE_FLAG  = 'Y'
		-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조 -- end 
		  INNER JOIN SCM_MST_ITEM_SN IM WITH(NOLOCK)
				  ON IM.ITEM_ID		= BO.CHILD_ITEM_ID
				 AND IM.COMPANY_ID	= BO.CHILD_COMPANY_ID
				 AND IM.DIVISION_ID	= BO.CHILD_DIVISION_ID
				 AND IM.SITE_ID		= BO.CHILD_SITE_ID
				 AND IM.ACTIVE_FLAG = 'Y'						-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON FI.DIVISION_ID	= BO.DIVISION_ID
				 AND FI.ITEM_ID		= BO.CHILD_ITEM_ID
				 AND FI.OPERATION_GROUP = 'A'		-- Cell 
	WHERE 1=1
	  AND BO.DIVISION_ID	= @v_division_id
	  AND BO.ALT_PRIORITY	= 'Y'
	  AND (BO.PARENT_ITEM_ID = '*'  OR P.ITEM_ID IS NOT NULL)	-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조
	  AND EXISTS (SELECT TOP 1 'X' 
				    FROM #MKT_FCST MK 
				   WHERE BO.MODEL_ID	= MK.SALES_ITEM_ID
				   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 Start 
				     AND BO.COMPANY_ID	= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND FI.OPERATION_GROUP = 'A'
											   THEN MK.COMPANY_ID_CELL_PROD
											   ELSE BO.COMPANY_ID
										  END 
				     AND BO.SITE_ID		= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND FI.OPERATION_GROUP = 'A'
											   THEN MK.SITE_ID_CELL_PROD
											   ELSE BO.SITE_ID
										  END 
				     AND BO.PLANT_ID	= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND FI.OPERATION_GROUP = 'A'
											   THEN MK.PLANT_ID_CELL_PROD
											   ELSE BO.PLANT_ID
										  END 
				   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 End 
				   ) 
				   

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Line Assign된 Cell 모델 (Cell Product기준)' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#LINE_ASSIGN_CELL') IS NOT NULL DROP TABLE #LINE_ASSIGN_CELL
	SELECT 
		   LA.COMPANY_ID
		  ,LA.DIVISION_ID
		  ,LA.SITE_ID
		  ,LA.PLANT_ID
		  ,ISNULL(ISNULL(MP.ITEM_ID_PROD, MP2.ITEM_ID_PROD), LA.ITEM_ID)							AS CELL_MODEL_ID
		  ,MAX(ISNULL(ISNULL(MP.ITEM_ID_PROD_NICK_NAME, MP2.ITEM_ID_PROD_NICK_NAME),FI.NICK_NAME))	AS CELL_NICK_NAME
	 INTO #LINE_ASSIGN_CELL
	 FROM SCM_MST_ITEM_LINE_ASSIGN_SN LA WITH(NOLOCK)  -- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, MONTH 
		  INNER JOIN SCM_MST_LINE_SN LM WITH(NOLOCK)	-- 2025.08.20 PJ20257329 유효한 라인만 참조하도록 join 추가 (COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE)
				  ON LM.COMPANY_ID		= LA.COMPANY_ID
				 AND LM.DIVISION_ID		= LA.DIVISION_ID
				 AND LM.SITE_ID			= LA.SITE_ID
				 AND LM.PLANT_ID		= LA.PLANT_ID
				 AND LM.FACTORY_ID		= LA.FACTORY_ID
				 AND LM.OPERATION_ID	= LA.OPERATION_ID
				 AND LM.LINE_ID			= LA.LINE_ID 
				 AND LM.ACTIVE_FLAG		= 'Y'
		  INNER JOIN #SCP_PLAN_OPERATION PO				-- 2025.08.20 PJ20257329 SCP Plan Operation으로 참조 범위 제한
				  ON PO.OPERATION_ID = LA.OPERATION_ID
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON FI.DIVISION_ID		= LA.DIVISION_ID
				 AND FI.ITEM_ID			= LA.ITEM_ID 
				 AND FI.OPERATION_GROUP = 'A'
		  LEFT  JOIN #CELL_PROD_ASSY_MAP MP
				  ON MP.DIVISION_ID		= LA.DIVISION_ID
				 AND MP.PLANT_ID		= LA.PLANT_ID
				 AND MP.ITEM_ID_ASSY	= LA.ITEM_ID
				 AND MP.ITEM_ID_PROD_PRIORITY = 1 
		  LEFT  JOIN #CELL_PROD_ASSY_MAP MP2
				  ON MP2.DIVISION_ID	= LA.DIVISION_ID
				 AND MP2.ITEM_ID_ASSY	= LA.ITEM_ID
				 AND MP2.ITEM_ID_PROD_PRIORITY2 = 1 
	WHERE 1=1
	  AND LA.DIVISION_ID = @v_division_id
	  AND LA.MONTH BETWEEN LEFT(@v_from_yyyymmdd, 6) AND  LEFT(@v_to_yyyymmdd, 6)
	  AND LA.ACTIVE_FLAG = 'Y'
	  AND LA.PRIORITY NOT IN ('0', '9') 
	  AND EXISTS (SELECT 'Y'  --- 상위 모델 MKT FCST 존재 6/24 
				   FROM #MKT_FCST_MODEL_CELL_BOM MK
				  WHERE 1=1
				    AND MK.CHILD_ITEM_ID = ISNULL(ISNULL(MP.ITEM_ID_PROD, MP2.ITEM_ID_PROD), LA.ITEM_ID))
	GROUP BY LA.COMPANY_ID
		    ,LA.DIVISION_ID
		    ,LA.SITE_ID
		    ,LA.PLANT_ID
		    ,ISNULL(ISNULL(MP.ITEM_ID_PROD, MP2.ITEM_ID_PROD), LA.ITEM_ID)

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 라인 Assign된 Cell Model BOM (셀-전극)' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#LINE_ASSIGN_CELL_BOM') IS NOT NULL DROP TABLE #LINE_ASSIGN_CELL_BOM

	SELECT DISTINCT
		   BO.MODEL_ID
		  ,BO.PLANT_ID
		  ,BO.CHILD_COMPANY_ID
		  ,BO.CHILD_DIVISION_ID
		  ,BO.CHILD_SITE_ID
		  ,BO.CHILD_PLANT_ID
		  ,BO.CHILD_ITEM_ID
		  ,CASE WHEN FI.OPERATION_GROUP_ID NOT IN ('A', 'E')
				THEN 'P'
				ELSE FI.OPERATION_GROUP_ID	
		   END						AS CHILD_OPERATION_GROUP
		  ,LEFT(FI.FLOW_ID,5)		AS CHILD_OPERATION_ID 
		  ,FI.ELECTRODE_TYPE		AS CHILD_ELECTRODE_TYPE
		  ,FI.NICK_NAME				AS ELEC_NICK_NAME
	 INTO #LINE_ASSIGN_CELL_BOM
	 FROM SCM_MST_MODEL_BOM BO WITH(NOLOCK) -- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CONCATENATE_ITEM
		-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조 -- start 
		  LEFT  JOIN SCM_MST_ITEM_SN P WITH(NOLOCK)		  
				  ON P.ITEM_ID		= BO.PARENT_ITEM_ID	  
				 AND P.COMPANY_ID	= BO.COMPANY_ID		  
				 AND P.DIVISION_ID	= BO.DIVISION_ID	  
				 AND P.SITE_ID		= BO.SITE_ID		  
				 AND P.ACTIVE_FLAG  = 'Y'
		-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조 -- end 
		  INNER JOIN #LINE_ASSIGN_CELL LA WITH(NOLOCK)
				  ON LA.COMPANY_ID		= BO.COMPANY_ID
				 AND LA.DIVISION_ID		= BO.DIVISION_ID
				 AND LA.SITE_ID			= BO.SITE_ID
				 AND LA.PLANT_ID		= BO.PLANT_ID
				 AND LA.CELL_MODEL_ID	= BO.MODEL_ID
		  INNER JOIN SCM_MST_ITEM_SN IM WITH(NOLOCK)
				  ON IM.ITEM_ID			= BO.CHILD_ITEM_ID
				 AND IM.COMPANY_ID		= BO.CHILD_COMPANY_ID
				 AND IM.DIVISION_ID		= BO.CHILD_DIVISION_ID
				 AND IM.SITE_ID			= BO.CHILD_SITE_ID
				 AND IM.ACTIVE_FLAG = 'Y'						-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON FI.DIVISION_ID		= BO.DIVISION_ID
				 AND FI.ITEM_ID			= BO.CHILD_ITEM_ID
				 AND FI.ATTRIBUTE8 NOT LIKE 'CA%'	-- Cell Assy 제외 
				 AND FI.OPERATION_GROUP = 'E'		-- Child 전극  
	WHERE 1=1
	  AND BO.DIVISION_ID	= @v_division_id
	  AND BO.ALT_PRIORITY	= 'Y'
	  AND (BO.PARENT_ITEM_ID = '*'  OR P.ITEM_ID IS NOT NULL)	-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 전극 PROJECT ROUTE ' 
	-- 40/82 소형과 ESS는 Sales site 및 project Code 값이 없음 ('-')
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#PROJECT_ROUTE_ELEC') IS NOT NULL DROP TABLE #PROJECT_ROUTE_ELEC
	SELECT PR.ITEM_ID
		  ,PR.SALES_SITE_ID		
		  ,PR.PROJECT_CODE		
		  ,PR.FROM_YYYYMMDD
		  ,PR.TO_YYYYMMDD
		  ,PR.PLANT_SITE_ID
		  ,PS.DIVISION_ID
		  ,PS.COMPANY_ID
		  ,PS.SITE_ID
		  ,PS.PLANT_ID
		  ,ROW_NUMBER() OVER (PARTITION BY PR.ITEM_ID
										  ,PR.SALES_SITE_ID		
										  ,PR.PROJECT_CODE
										  ,PR.FROM_YYYYMMDD
										  ,PR.TO_YYYYMMDD
								  ORDER BY PR.PRIORITY ) AS PR_PRIORITY
	 INTO #PROJECT_ROUTE_ELEC
	 FROM SCM_MST_SITE_ITEM_PRIORITY PR WITH(NOLOCK)
		  INNER JOIN SCM_MST_SITE PS WITH(NOLOCK)
				  ON PS.DIVISION_ID = PR.DIVISION_ID
				 AND PS.SCM_SITE_ID = PR.PLANT_SITE_ID
				 AND PS.SITE_TYPE	= 'PLANT'
				 AND PS.VALID_YN	= 'Y'
				 AND PS.OPERATION_GROUP = 'E' -- 전극 Plant Site
	WHERE 1=1
	  AND PR.DIVISION_ID  = @v_division_id
	  AND PR.VALID_YN	  = 'Y'
	  AND PR.TO_YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE(), 112) 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 전극 Line Assign 안된 데이터 ' 
	-- MKT FCST가 존재하는 Model BOM 하위 Cell 모델 (Sales Model포함)
	-- Line Assign된 Cell 모델 기준 하위 전극 모델에 대한 Line Assign 데이터 확인
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TACT_TIME_CASE_4') IS NOT NULL DROP TABLE #TACT_TIME_CASE_4
	SELECT DISTINCT
		   PE.DIVISION_ID						AS DIVISION_ID
		  ,PE.ITEM_ID							AS ELEC_MODEL_ID
		  ,CE.ELEC_NICK_NAME	
		  ,PE.PLANT_SITE_ID
		  ,CE.CHILD_OPERATION_ID				AS OPERATION_ID
		  ,CONVERT(NVARCHAR(250), NULL)			AS MASTER_INVLD_CTN
		 -- ,CONCAT('Cell Model:',CE.MODEL_ID)	AS MASTER_INVLD_CTN
	 INTO #TACT_TIME_CASE_4
	 FROM #LINE_ASSIGN_CELL_BOM CE
		  INNER JOIN #PROJECT_ROUTE_ELEC PE 
				 ON CE.CHILD_ITEM_ID = PE.ITEM_ID
				AND CE.PLANT_ID		 = PE.PLANT_ID					-- 2025.08.20 PJ20257329 cell/전극 동일 plant 조건 추가 
		  LEFT  JOIN SCM_MST_ITEM_LINE_ASSIGN_SN LA WITH(NOLOCK)	-- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, MONTH 
				  ON LA.COMPANY_ID	= PE.COMPANY_ID
				 AND LA.DIVISION_ID	= PE.DIVISION_ID
				 AND LA.SITE_ID		= PE.SITE_ID
				 AND LA.PLANT_ID	= PE.PLANT_ID
				 AND LA.ITEM_ID		= PE.ITEM_ID
				 AND LA.OPERATION_ID= CE.CHILD_OPERATION_ID
				 AND LA.MONTH	BETWEEN LEFT(@v_from_yyyymmdd, 6) AND LEFT(@v_to_yyyymmdd, 6)  -- 6/30 
				 AND LA.PRIORITY   NOT IN ('0', '9') 
				 AND LA.ACTIVE_FLAG = 'Y'	-- 6/30 
				 AND LA.OPERATION_ID IN (SELECT PO.OPERATION_ID FROM #SCP_PLAN_OPERATION PO) --  PJ20257329 SCP Plan Operation으로 참조 범위 제한
				 AND EXISTS (SELECT TOP 1 'X'
							   FROM SCM_MST_LINE_SN LM WITH(NOLOCK)	-- 2025.08.20 PJ20257329 유효한 라인만 참조하도록 join 추가 (COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE)
							  WHERE LM.COMPANY_ID		= LA.COMPANY_ID
								AND LM.DIVISION_ID		= LA.DIVISION_ID
								AND LM.SITE_ID			= LA.SITE_ID
								AND LM.PLANT_ID			= LA.PLANT_ID
								AND LM.FACTORY_ID		= LA.FACTORY_ID
								AND LM.OPERATION_ID		= LA.OPERATION_ID
								AND LM.LINE_ID			= LA.LINE_ID 
								AND LM.ACTIVE_FLAG		= 'Y' )

	WHERE 1=1
	  AND LA.LINE_ID IS NULL -- 전극 line assign 누락 데이터  


	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 전극 Line Assign되고 Tact Time 미등록 데이터 ' 
	-- MKT FCST가 존재하는 Model BOM 하위 Cell 모델 (Sales Model포함)
	-- Line Assign된 Cell 모델 기준 하위 전극 모델에 대한 Line Assign 데이터 확인
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TACT_TIME_CASE_4_2') IS NOT NULL DROP TABLE #TACT_TIME_CASE_4_2
	SELECT DISTINCT 
		   LA.DIVISION_ID
		  ,LA.ITEM_ID
		  ,PE.PLANT_SITE_ID
		  ,LA.OPERATION_ID
		  ,LA.LINE_ID
		  ----,CE.MODEL_ID
		  --,PE.*
	 INTO #TACT_TIME_CASE_4_2
	 FROM #LINE_ASSIGN_CELL_BOM CE
		  INNER JOIN #PROJECT_ROUTE_ELEC PE 
				 ON CE.CHILD_ITEM_ID = PE.ITEM_ID
				AND CE.PLANT_ID		 = PE.PLANT_ID					-- 2025.08.20 PJ20257329 cell/전극 동일 plant 조건 추가 
		  INNER JOIN SCM_MST_ITEM_LINE_ASSIGN_SN LA WITH(NOLOCK)    -- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, MONTH 
				  ON LA.COMPANY_ID	= PE.COMPANY_ID
				 AND LA.DIVISION_ID	= PE.DIVISION_ID
				 AND LA.SITE_ID		= PE.SITE_ID
				 AND LA.PLANT_ID	= PE.PLANT_ID
				 AND LA.ITEM_ID		= PE.ITEM_ID
				 AND LA.OPERATION_ID= CE.CHILD_OPERATION_ID
				 AND LA.MONTH	BETWEEN LEFT(@v_from_yyyymmdd, 6) AND LEFT(@v_to_yyyymmdd, 6)  -- 6/30 
				 AND LA.PRIORITY   NOT IN ('0', '9') 
				 AND LA.ACTIVE_FLAG = 'Y'	-- 6/30 
		  INNER JOIN SCM_MST_LINE_SN LM WITH(NOLOCK)	-- 2025.08.20 PJ20257329 유효한 라인만 참조하도록 join 추가 (COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE)
				  ON LM.COMPANY_ID		= LA.COMPANY_ID
				 AND LM.DIVISION_ID		= LA.DIVISION_ID
				 AND LM.SITE_ID			= LA.SITE_ID
				 AND LM.PLANT_ID		= LA.PLANT_ID
				 AND LM.FACTORY_ID		= LA.FACTORY_ID
				 AND LM.OPERATION_ID	= LA.OPERATION_ID
				 AND LM.LINE_ID			= LA.LINE_ID 
				 AND LM.ACTIVE_FLAG		= 'Y'
		  INNER JOIN #SCP_PLAN_OPERATION PO				-- 2025.08.20 PJ20257329 SCP Plan Operation으로 참조 범위 제한
				  ON PO.OPERATION_ID = LA.OPERATION_ID
	WHERE 1=1
	  AND NOT EXISTS (SELECT 'X'	-- fp tact time 
					   FROM #FP_TACT_TIME TT 
					  WHERE 1=1
					    AND TT.PLANT_SITE_ID	= PE.PLANT_SITE_ID
						AND TT.ITEM_ID			= LA.ITEM_ID
						AND TT.LINE_ID			= LA.LINE_ID
						AND TT.OPERATION_ID		= LA.OPERATION_ID) 
	  AND NOT EXISTS (SELECT 'X'
					   FROM #SCP_TACT_TIME TT WITH(NOLOCK)
					  WHERE 1=1
					    AND TT.PLANT_SITE_ID	= PE.PLANT_SITE_ID
						AND TT.LINE_ID			= LA.LINE_ID
						AND TT.ITEM_ID			= LA.ITEM_ID
						AND TT.OPERATION_ID		= LA.OPERATION_ID
						) 
	  AND NOT EXISTS (SELECT 'X'
					   FROM #SCP_TACT_TIME_EXCEPT TT WITH(NOLOCK)
					  WHERE 1=1
					    AND TT.PLANT_SITE_ID	= PE.PLANT_SITE_ID
						AND TT.LINE_ID			= LA.LINE_ID
						AND TT.ITEM_ID			= LA.ITEM_ID
						AND TT.OPERATION_ID		= LA.OPERATION_ID
						) 


--//########################### case 5 Start
/*
5) CURRENT PROD AMEND 에 입력되어 있는 '모델'/'PLANT'/'LINE'/'생산계획날짜' 정보를 기반으로
 >> 생산계획 시기가 CAPA:TACT TIME 날짜외 구간에 입력되어 있는 경우
*/
	-------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' SCP Plan 버전 정보' 
	-------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCP_PLAN_VERSION') IS NOT NULL DROP TABLE #SCP_PLAN_VERSION; 
	;WITH SCP_FN_PLAN_INFO AS (
		SELECT 
			  P.DIVISION_ID
			 ,D.PLAN_TYPE
			 ,D.PLAN_SEQ
			 ,P.PLAN_NAME														AS PLAN_START_YYYYMMDD
			 ,SUBSTRING(P.HORIZON_END_DATE, 1, 8)								AS HORIZON_END_DATE 
			 ,D.PLAN_STATUS 
			 ,D.CONFIRM_FLAG
			 ,DENSE_RANK() OVER (PARTITION BY P.DIVISION_ID 
									 ORDER BY P.PLAN_NAME DESC 
											 ,D.INPUT_START_DATE DESC)			AS PLAN_PRIORITY
		 FROM SCM_MST_PLAN  P WITH(NOLOCK)
			  INNER JOIN SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
					  ON D.DIVISION_ID  = P.DIVISION_ID
					 AND D.PLAN_ID      = P.PLAN_ID
					 AND D.PLAN_STATUS  = '1'  -- 정상 완료
		WHERE 1=1
		  AND P.DIVISION_ID	= @v_division_id
		  AND P.PLAN_CYCLE	= 'WEEKLY'
		  AND P.PLAN_NAME   = @v_from_yyyymmdd 
	)
	SELECT FP.*
	  INTO #SCP_PLAN_VERSION  
	  FROM SCP_FN_PLAN_INFO FP
	 WHERE 1=1
	   AND FP.PLAN_PRIORITY = 1 

	---------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Current 생산계획  - Tact Time 범위 밖의 생산계획 ? ' 
	---------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TACT_TIME_CASE_5') IS NOT NULL DROP TABLE #TACT_TIME_CASE_5
	SELECT PP.DIVISION_ID
		  ,PP.PLAN_START_YYYYMMDD
		  ,PP.PLAN_TYPE
		  ,PP.SEQ
		  ,PP.OPERATION_GROUP
		  ,PP.SCM_SITE_ID
		  ,PS.SITE_DESCRIPTION 
		  ,PP.ITEM_ID
		  ,PP.LINE_ID
		  ,PP.OPERATION_ID
		  ,LEFT(PP.YYYYMMDD, 6) AS PROD_MONTH
		  ,SUM(QTY)				AS QTY
	 INTO #TACT_TIME_CASE_5
	 FROM SCP_ANL_PRODUCTION_PLAN PP WITH(NOLOCK)  --DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD
		  INNER JOIN #SCP_PLAN_VERSION PV 
				  ON PV.DIVISION_ID			= PP.DIVISION_ID
				 AND PV.PLAN_START_YYYYMMDD = PP.PLAN_START_YYYYMMDD
				 AND PV.PLAN_TYPE			= PP.PLAN_TYPE
				 AND PV.PLAN_SEQ			= PP.SEQ 
				 AND PV.HORIZON_END_DATE   >= PP.YYYYMMDD
		  INNER JOIN SCM_MST_SITE	PS WITH(NOLOCK)
				  ON PS.SCM_SITE_ID			= PP.SCM_SITE_ID
				 AND PS.SITE_TYPE			= 'PLANT'
				 AND PS.VALID_YN			= 'Y'
		  LEFT  JOIN SCM_MST_TACT_TIME_SN TT WITH(NOLOCK)   -- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, ITEM_ID, MONTH
				  ON TT.COMPANY_ID	= PS.COMPANY_ID
				 AND TT.DIVISION_ID	= PS.DIVISION_ID
				 AND TT.SITE_ID		= PS.SITE_ID
				 AND TT.PLANT_ID	= PS.PLANT_ID
				 AND TT.OPERATION_ID= PP.OPERATION_ID
				 AND TT.LINE_ID		= PP.LINE_ID
				 AND TT.ITEM_ID		= PP.ITEM_ID
				 AND TT.MONTH	   >= CONVERT(NVARCHAR(6), GETDATE(),112)	
				 AND TT.MONTH		= LEFT(PP.YYYYMMDD,6) -- 해당 범위 내 
				 AND TT.TACT_TIME  != 0
		  LEFT  JOIN SCP_MST_TACT_TIME_EXCEPT TE WITH(NOLOCK)   ---DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID, TACT_TIME_START_DATE, TACT_TIME_END_DATE
				  ON TE.DIVISION_ID	= PP.DIVISION_ID
				 AND TE.PLANT_SITE_ID= PP.SCM_SITE_ID
				 AND TE.ITEM_ID		= PP.ITEM_ID
				 AND TE.OPERATION_ID = PP.OPERATION_ID
				 AND TE.LINE_ID		= PP.LINE_ID
				 AND TE.USE_YN		= 'Y'
				 AND TE.TACT_TIME	> 0 
				 AND PP.YYYYMMDD BETWEEN TE.TACT_TIME_START_DATE AND TE.TACT_TIME_END_DATE 
	WHERE 1=1
	  AND PP.MEASURE = 'PROD_PLAN_AMEND' 
	  AND PP.QTY  != 0  
	  AND TT.ITEM_ID IS NULL -- FP Tact Time 기간 범위내 생산계획이 아닌 경우 
	  AND TE.ITEM_ID IS NULL -- SCP Tact Time Except 기간 범위내 생산계획이 아닌 경우 
	  AND (
			EXISTS (SELECT TOP 1 'X'  -- fp tact time 존재
				    FROM SCM_MST_TACT_TIME_SN TT WITH(NOLOCK)  -- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, ITEM_ID, MONTH 
				  WHERE TT.COMPANY_ID	= PS.COMPANY_ID
					AND TT.DIVISION_ID	= PS.DIVISION_ID
					AND TT.SITE_ID		= PS.SITE_ID
					AND TT.PLANT_ID		= PS.PLANT_ID
					-- 6/30 AND TT.OPERATION_ID = PP.OPERATION_ID
					AND TT.LINE_ID		= PP.LINE_ID
					AND TT.ITEM_ID		= PP.ITEM_ID
					AND TT.MONTH	   BETWEEN LEFT(@v_from_yyyymmdd, 6) AND  LEFT(@v_to_yyyymmdd, 6)
				    AND TT.TACT_TIME    > 0 )
			OR
			EXISTS (SELECT TOP 1 'X'
					 FROM SCP_MST_TACT_TIME TT WITH(NOLOCK)   ---DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID, TACT_TIME_START_DATE, TACT_TIME_END_DATE
				    WHERE TT.DIVISION_ID	= PP.DIVISION_ID
					  AND TT.PLANT_SITE_ID  = PP.SCM_SITE_ID
					  AND TT.ITEM_ID		= PP.ITEM_ID
					  AND TT.OPERATION_ID   = PP.OPERATION_ID
					  AND TT.LINE_ID		= PP.LINE_ID
					  AND TT.VALID_YN		= 'Y'
					  AND TT.TACT_TIME	> 0 )
			OR
			EXISTS (SELECT TOP 1 'X'
					 FROM SCP_MST_TACT_TIME_EXCEPT TT WITH(NOLOCK)   ---DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID, TACT_TIME_START_DATE, TACT_TIME_END_DATE
				    WHERE TT.DIVISION_ID	= PP.DIVISION_ID
				  	  AND TT.PLANT_SITE_ID  = PP.SCM_SITE_ID
				  	  AND TT.ITEM_ID		= PP.ITEM_ID
				  	  AND TT.OPERATION_ID   = PP.OPERATION_ID
				  	  AND TT.LINE_ID		= PP.LINE_ID
				  	  AND TT.USE_YN		    = 'Y'
				  	  AND TT.TACT_TIME	> 0 )
		 ) 
	GROUP BY PP.DIVISION_ID
			,PP.PLAN_START_YYYYMMDD
			,PP.PLAN_TYPE
			,PP.SEQ
			,PP.OPERATION_GROUP
			,PP.SCM_SITE_ID
			,PS.SITE_DESCRIPTION                          
			,PP.ITEM_ID
			,PP.LINE_ID
			,PP.OPERATION_ID
			,LEFT(PP.YYYYMMDD, 6)


-- #######################################-- #######################################-- #######################################-- #######################################
	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 전체 확인 필요 대상    ' -- #######################################
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TACT_TIME_TARGET_DATA') IS NOT NULL DROP TABLE #TACT_TIME_TARGET_DATA
	SELECT *
	 INTO #TACT_TIME_TARGET_DATA
	 FROM (
		--- Project Route 미등록 
		SELECT @v_division_id			AS DIVISION_ID
			  ,RN.SALES_ITEM_ID			AS MODEL_ID
			  ,RN.MODEL_NICK_NAME		AS NICK_NAME
			  ,RN.MASTER_INVLD_CD
			  ,SM.SITE_DESCRIPTION		AS SALES_PLANT_SITE
			  ,RN.PROJECT_CODE			AS PROJECT_OPERATION
			  ,RN.INCOTERMS				AS INCOTERMS_LINE
			  ,RN.QTY
			  ,RN.MASTER_INVLD_CTN
			 -- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 Start 
			   +CASE WHEN RN.CELL_PROD_SITE_ID IS NOT NULL AND RN.CHILD_OPERATION_GROUP = 'A'
					 THEN ' ,Cell Prod Site : ' + CS.NAME 
					 ELSE '' 
				END AS MASTER_INVLD_CTN
			 -- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 End 
		 FROM #PROJECT_ROUTE_NOT_EXISTS RN
			  INNER JOIN SCM_MST_SITE SM WITH(NOLOCK)
					  ON SM.DIVISION_ID		= @v_division_id
					 AND SM.SCM_SITE_ID		= RN.SALES_SITE_ID
				 -- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 Start 
				   LEFT JOIN #CELL_PROD_SITE_ID CS
						  ON CS.CODE = RN.CELL_PROD_SITE_ID 
				 -- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 End 
		/*
		2) (조립)CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
		   해당 모델의 PJT ROUTE의 'PLANT' 정보를 기반으로
		 >> ASSIGN 된 PLANT 내 TACT TIME 이 조회되지 않는경우
		*/
		UNION ALL
		SELECT @v_division_id			AS DIVISION_ID
			  ,TN.MODEL_ID
			  ,FI.NICK_NAME
			  ,'TTT02'					AS MASTER_INVLD_CD
			  ,TN.PLANT_SITE
			  ,TN.CHILD_OPERATION_ID	AS PROJECT_OPERATION
			  ,NULL						AS INCOTERMS_LINE
			  ,NULL						AS QTY
			  ,TN.DESCR					AS MASTER_INVLD_CTN
		 FROM #TACT_TIME_CASE_2 TN 
			  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.DIVISION_ID		= @v_division_id
					 AND FI.ITEM_ID			= TN.MODEL_ID
		WHERE 1=1
		/*
		3) (조립)CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
		   해당 모델의 'LINE' ASSIGN 정보를 기반으로
		 >> ASSIGN 된 LINE 내 TACT TIME 이 조회되지 않는경우
		*/
		UNION ALL
		SELECT TN.DIVISION_ID
			  ,TN.MODEL_ID
			  ,FI.NICK_NAME
			  ,'TTT03'					AS MASTER_INVLD_CD
			  ,TN.PLANT_SITE 
			  ,TN.CHILD_OPERATION_ID	AS PROJECT_OPERATION
			  ,TN.LINE_ID				AS INCOTERMS_LINE
			  ,NULL						AS QTY
			  ,TN.DESCR					AS MASTER_INVLD_CTN
		 FROM #TACT_TIME_CASE_3 TN 
			  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.DIVISION_ID		= @v_division_id
					 AND FI.ITEM_ID			= TN.MODEL_ID
		WHERE 1=1
		/*
		4) (전극) CURRENT 상위BOM '셀' LINE ASSIGN이 되어있는 '모델' 정보와
			해당 모델의 E2000(코팅) 공정의 BOM 정보를 기반으로
		 >> 전극 LINE ASSIGN 정보가 모든 PLANT에서 없거나(LINE ASSIGN미등록)
		 >> ASSIGN 된 LINE 내 TACT TIME 이 조회
		*/
		UNION ALL
		SELECT TN.DIVISION_ID
			  ,TN.ELEC_MODEL_ID
			  ,TN.ELEC_NICK_NAME
			  ,'TTT04'					AS MASTER_INVLD_CD
			  ,PS.SITE_DESCRIPTION		AS SALES_PLANT_SITE 
			  ,TN.OPERATION_ID			AS PROJECT_OPERATION
			  ,NULL						AS INCOTERMS_LINE
			  ,NULL						AS QTY
			  ,N'line assign 미등록'	AS MASTER_INVLD_CTN
		 FROM #TACT_TIME_CASE_4 TN  --- line assign 미등록
			  INNER JOIN SCM_MST_SITE PS WITH(NOLOCK)
					  ON PS.DIVISION_ID		= TN.DIVISION_ID
					 AND PS.SCM_SITE_ID		= TN.PLANT_SITE_ID
		UNION ALL
		SELECT TN.DIVISION_ID
			  ,TN.ITEM_ID
			  ,FI.NICK_NAME
			  ,'TTT04'					AS MASTER_INVLD_CD
			  ,PS.SITE_DESCRIPTION		AS SALES_PLANT_SITE 
			  ,TN.OPERATION_ID			AS PROJECT_OPERATION
			  ,NULL						AS INCOTERMS_LINE
			  ,NULL						AS QTY
			  ,CONCAT(N'line assign 등록 / tact time 미등록 / Line ',TN.LINE_ID)		AS MASTER_INVLD_CTN
		 FROM #TACT_TIME_CASE_4_2 TN  --- line assign 등록 / tact time 미등록 
			  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.DIVISION_ID		= TN.DIVISION_ID
					 AND FI.ITEM_ID			= TN.ITEM_ID
			  INNER JOIN SCM_MST_SITE PS WITH(NOLOCK)
					  ON PS.DIVISION_ID		= TN.DIVISION_ID
					 AND PS.SCM_SITE_ID		= TN.PLANT_SITE_ID
		WHERE 1=1
		/*
		5) CURRENT PROD AMEND 에 입력되어 있는 '모델'/'PLANT'/'LINE'/'생산계획날짜' 정보를 기반으로
		 >> 생산계획 시기가 CAPA:TACT TIME 날짜외 구간에 입력되어 있는 경우
		*/
		UNION ALL 
		SELECT TN.DIVISION_ID
			  ,TN.ITEM_ID
			  ,FI.NICK_NAME
			  ,'TTT05'					AS MASTER_INVLD_CD
			  ,TN.SITE_DESCRIPTION		AS SALES_PLANT_SITE 
			  ,TN.OPERATION_ID			AS PROJECT_OPERATION
			  ,TN.LINE_ID				AS INCOTERMS_LINE
			  ,TN.QTY
			  ,CONCAT('Prod Plan Month :', TN.PROD_MONTH)	AS MASTER_INVLD_CTN
		 FROM #TACT_TIME_CASE_5 TN 
			  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.DIVISION_ID		= TN.DIVISION_ID
					 AND FI.ITEM_ID			= TN.ITEM_ID
		WHERE 1=1
	) TG 


	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 전극 Applied Cell Model  ' 	
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#ELEC_APPLIED_MODEL') IS NOT NULL DROP TABLE #ELEC_APPLIED_MODEL
	SELECT *
	INTO #ELEC_APPLIED_MODEL
	FROM (
			SELECT FI.DIVISION_ID 
				  ,FI.ITEM_ID
				  ,SI.APPLIED_MODEL
				  ,ROW_NUMBER() OVER (PARTITION BY FI.DIVISION_ID
												  ,FI.ITEM_ID
										  ORDER BY CASE WHEN DM.ATTRIBUTE3 = '81' AND FI.ITEM_ID LIKE 'A%' THEN 1
														WHEN DM.ATTRIBUTE3 = '40' AND FI.ITEM_ID LIKE 'M%' THEN 2
														WHEN DM.ATTRIBUTE3 = '82' AND FI.ITEM_ID LIKE 'M%' THEN 3
														ELSE 9
												   END
												   ) AS RN 
			 FROM SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  INNER JOIN SCM_MST_ITEM_SN SI WITH(NOLOCK)
						  ON SI.DIVISION_ID					= FI.DIVISION_ID
						 AND SI.ITEM_ID						= FI.ITEM_ID 
						 AND SI.ACTIVE_FLAG					= 'Y'
						 AND ISNULL(SI.APPLIED_MODEL, 'Z') != 'Z'
				  INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
						  ON DM.DIVISION_ID = FI.DIVISION_ID
			WHERE 1=1
			  AND FI.DIVISION_ID     = @v_division_id
			  AND FI.OPERATION_GROUP = 'E'
		) A
	WHERE 1=1
	  AND RN = 1 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 전체 확인 필요 대상 -  Basic Cell Nick Name 매핑  ' -- ##########
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TACT_TIME_TARGET_DATA_BC_NICK_NAME') IS NOT NULL DROP TABLE #TACT_TIME_TARGET_DATA_BC_NICK_NAME
	SELECT TC.DIVISION_ID
		  ,TC.MODEL_ID
		  ,TC.NICK_NAME
		  ,BI.BASIC_NICK_NAME		AS BASIC_CELL_NICK_NAME 
		  ,TC.MASTER_INVLD_CD
		  ,TC.SALES_PLANT_SITE
		  ,TC.PROJECT_OPERATION
		  ,TC.INCOTERMS_LINE
		  ,TC.QTY
		  ,TC.MASTER_INVLD_CTN
	 INTO #TACT_TIME_TARGET_DATA_BC_NICK_NAME
	 FROM #TACT_TIME_TARGET_DATA TC 
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON FI.DIVISION_ID = TC.DIVISION_ID
				 AND FI.ITEM_ID		= TC.MODEL_ID
		  LEFT  JOIN #ELEC_APPLIED_MODEL EA
				  ON EA.DIVISION_ID = TC.DIVISION_ID
				 AND EA.ITEM_ID		= TC.MODEL_ID 
		  LEFT  JOIN SCP_MST_ITEM_BSI_IFO BI WITH(NOLOCK)
				  ON BI.ITEM_ID		= CASE WHEN FI.OPERATION_GROUP = 'E'	THEN EA.APPLIED_MODEL
										   WHEN FI.OPERATION_GROUP = 'P'	THEN FI.ATTRIBUTE1
										   ELSE TC.MODEL_ID
									  END 
	WHERE 1=1

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' #PLAN_GROUP_INFO 임시테이블  '
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#PLAN_GROUP_INFO') IS NOT NULL DROP TABLE #PLAN_GROUP_INFO
	SELECT ITEM_ID
		  ,DIVISION_ID
		  ,LINE_ID
		  ,OPMZ_PLAN_GR_ID
		  ,OPMZ_PLAN_GR_NAME
		  ,BASIC_NICK_NAME
		  ,ROW_NUMBER() OVER (PARTITION BY ITEM_ID
										 , DIVISION_ID
								  ORDER BY OPMZ_PLAN_GR_ID DESC
										  ,LINE_ID DESC)			AS RN 
		  ,ROW_NUMBER() OVER (PARTITION BY BASIC_NICK_NAME
										 , DIVISION_ID
								  ORDER BY OPMZ_PLAN_GR_ID DESC
										  ,LINE_ID DESC)			AS RN_NICK 
	 INTO #PLAN_GROUP_INFO
	 FROM #PLAN_GROUP_LINE_MODEL_BASIC_NICK

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 전체 확인 필요 대상 - Plan Group 매핑  ' -- #####################
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TACT_TIME_TARGET_DATA_PLAN_GROUP') IS NOT NULL DROP TABLE #TACT_TIME_TARGET_DATA_PLAN_GROUP
	SELECT ISNULL(PG.OPMZ_PLAN_GR_ID	,PG_NICK.OPMZ_PLAN_GR_ID	)	AS OPMZ_PLAN_GR_ID	
		  ,ISNULL(PG.OPMZ_PLAN_GR_NAME	,PG_NICK.OPMZ_PLAN_GR_NAME	)	AS OPMZ_PLAN_GR_NAME	
		  ,ISNULL(PG.LINE_ID			,PG_NICK.LINE_ID			)	AS LINE_ID			
		  ,ISNULL(PG.BASIC_NICK_NAME 	,PG_NICK.BASIC_NICK_NAME 	)	AS BASIC_NICK_NAME 	
		  ,CASE WHEN PG.LINE_ID IS NOT NULL			THEN 'A'	-- item id mapping 
				WHEN PG_NICK.LINE_ID IS NOT NULL	THEN 'B'	-- basic cell nick name mapping 
				ELSE 'Z'
			END															AS DV 
		  ,TC.DIVISION_ID
		  ,TC.MODEL_ID
		  ,TC.NICK_NAME
		  ,TC.BASIC_CELL_NICK_NAME 
		  ,TC.MASTER_INVLD_CD
		  ,TC.SALES_PLANT_SITE
		  ,TC.PROJECT_OPERATION
		  ,TC.INCOTERMS_LINE
		  ,TC.QTY
		  ,TC.MASTER_INVLD_CTN 
	 INTO #TACT_TIME_TARGET_DATA_PLAN_GROUP
	 FROM #TACT_TIME_TARGET_DATA_BC_NICK_NAME TC
		  LEFT JOIN #PLAN_GROUP_INFO PG	-- item_id로 매핑 
				 ON PG.DIVISION_ID	= TC.DIVISION_ID
				AND PG.ITEM_ID		= TC.MODEL_ID
				AND PG.RN			= 1 
		  LEFT JOIN #PLAN_GROUP_INFO PG_NICK	-- basic cell nick name으로 매핑 
				 ON PG_NICK.DIVISION_ID		= TC.DIVISION_ID
				AND PG_NICK.BASIC_NICK_NAME	= TC.BASIC_CELL_NICK_NAME
				AND PG_NICK.RN_NICK			= 1 
	WHERE 1=1

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 전체 확인 필요 대상 조회' -- ####################################
	------------------------------------------------------------------------------------------------------------------
	SELECT DISTINCT								-- PJ20257329 2025.09.12 중복 데이터 제거 
		   TC.DIVISION_ID
		  ,TC.MODEL_ID     AS ITEM_ID
		  ,TC.NICK_NAME
		  ,TC.BASIC_CELL_NICK_NAME
		  ,CASE WHEN TC.DV IN ('A', 'B')				THEN CONCAT(TC.OPMZ_PLAN_GR_NAME, '')
				WHEN TC.BASIC_CELL_NICK_NAME IS NULL	THEN '-'
				ELSE CONCAT(TC.BASIC_CELL_NICK_NAME, N' (예상)') 
		    END								AS PLAN_GROUP
		  ,ISNULL(TC.OPMZ_PLAN_GR_ID,'-')	AS OPMZ_PLAN_GR_ID 
		  ,TC.MASTER_INVLD_CD
		  ,LK.ATTRIBUTE2					AS MASTER_INVLD_MSG
		  ,TC.SALES_PLANT_SITE
		  ,TC.PROJECT_OPERATION
		  ,TC.INCOTERMS_LINE
		  ,TC.QTY
		  ,TC.MASTER_INVLD_CTN 
	 FROM #TACT_TIME_TARGET_DATA_PLAN_GROUP TC
		  LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
				  ON LK.LOOKUP_TYPE		= 'MASTER_INVLD_CD'
				 AND LK.SEGMENT1		= TC.MASTER_INVLD_CD
				 AND LK.VALID_YN		= 'Y'
         INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
                ON TC.MODEL_ID  like  b.tst 
                OR TC.NICK_NAME like  b.tst  				 
   WHERE 1=1 
	   AND ( ( @p_plan_group_id IS NULL OR  @p_plan_group_id = '' ) OR TC.OPMZ_plan_gr_id IN (SELECT token FROM dbo.String_Split(@p_plan_group_id  ,',')) )
	ORDER BY MASTER_INVLD_CD, 1,2,3,4,5,6 


END
