



/*
 * Program ID   : SCP0039_GET_VALIDATION_BOD
 * Description  : BOD
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/12/10	hwyoon			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2021/07/07   khj79			PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 FROM , TO 조건 추가 , scp_mst_bod_v => scp_mst_bod_n_v 변경
 * 2021/10/05	khj79	       [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - W/S AS UI 변경
 * 2022/11/07   jahn1501		PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MKT FCST 조건 변경
 * 2025/07/09   kh              PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축
 * 2025/08/04   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : project route 참조시 40/82 division case 처리
 * 2025/08/14   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- MKT FCST 최종 수정일시 정보 추가
 *										- line assign 참조시 scp plan operation으로 공정 참조 범위 제한
 * 2025/08/26   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *									-- Model BOM 참조시 parent/child FP item master active 'Y'만 참조 
 * 2025/09/05   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- MKT_FCST 참조시 to AS Sales 사이트 제외 (AS_SITE_PLANT) 
 * 2025/09/12   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- 소형/ESS plan group 매핑 로직 자동차와 동일하게 적용
 *										- 소형 MKT FCST 수요계획 데이터(DM_PLN_CFM_MKT_DEMAND_PLAN) Cell Prod Site 적용 
 * 
 */
 
CREATE PROCEDURE [dbo].[SCP0039_GET_VALIDATION_BOD]  
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
### BOD 요구사항 

1)CURRENT MKT FCST DP에 입력되어 있는 '모델' 정보를 기반으로
 >> 해당 모델의 PJT ROUTE가 설정되어 있지 않은 경우

2)CURRENT MKT FCST DP에 입력되어 있는 '모델' / TO SITE'/ 'INCOTERMS'와
   해당 모델의 PJT ROUTE의 FROM SITE 정보를 기반으로
 >> FROM SITE/TO SITE/INCOTERMS 로 MAPPING되는 BOD ID 정보가 없는 경우

3) CURRENT SHIP SEMI/FG SHIP PLAN 에 입력되어 있는 모델
 >> 해당 모델의 출하계획 시기가 BOD ID의 FROM-TO 날짜외 계획있는 경우, 사용한 BOD ID의 VALID N 인 경우
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

--------------// start plan group info -- function으로 ??? 

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

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' From Site (SCM_MST_SITE) '  -- 6/27 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCM_MST_SITE_FROM') IS NOT NULL DROP TABLE #SCM_MST_SITE_FROM
	SELECT SCM_SITE_ID
		  ,SITE_DESCRIPTION
		  ,OSP_YN
		  ,OPERATION_GROUP
		  ,COUNTRY
		  ,CITY
	 INTO #SCM_MST_SITE_FROM
	 FROM SCM_MST_SITE WITH(NOLOCK)
	WHERE 1=1
	  AND DIVISION_ID	= @v_division_id
	  AND SITE_TYPE		= 'PLANT'
	  AND VALID_YN		= 'Y'

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' To Site (SCM_MST_SITE) '  -- 6/27 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCM_MST_SITE_TO') IS NOT NULL DROP TABLE #SCM_MST_SITE_TO
	SELECT SCM_SITE_ID
		  ,MAX(SITE_DESCRIPTION)																				AS SITE_DESCRIPTION
		  ,MAX(SITE_TYPE)																						AS SITE_TYPE
		  ,MAX(OPERATION_GROUP)																					AS OPERATION_GROUP
		  ,MAX(CASE WHEN SITE_TYPE = 'SALES' AND DIVISION_ID = @v_division_id THEN VMI_YN		ELSE NULL END)	AS VMI_YN
		  ,MAX(CASE WHEN SITE_TYPE = 'SALES' AND DIVISION_ID = @v_division_id THEN COUNTRY		ELSE NULL END)	AS COUNTRY
		  ,MAX(CASE WHEN SITE_TYPE = 'SALES' AND DIVISION_ID = @v_division_id THEN CITY			ELSE NULL END)	AS CITY
		  ,MAX(CASE WHEN SITE_TYPE = 'SALES' AND DIVISION_ID = @v_division_id THEN END_CUSTOMER ELSE NULL END)	AS END_CUSTOMER
	INTO #SCM_MST_SITE_TO
	FROM (
		SELECT DIVISION_ID
			 , SCM_SITE_ID
			 , SITE_DESCRIPTION
			 , SITE_TYPE
			 , OPERATION_GROUP
			 , VMI_YN
			 , COUNTRY
			 , CITY
			 , END_CUSTOMER
		 FROM  SCM_MST_SITE AS A WITH(NOLOCK)   
		WHERE  A.VALID_YN	 = 'Y'  
		  AND  A.DIVISION_ID = @v_division_id
		UNION  
		SELECT DIVISION_ID
			 , SCM_SITE_ID
			 , SITE_DESCRIPTION
			 , SITE_TYPE
			 , OPERATION_GROUP
			 , VMI_YN
			 , COUNTRY
			 , CITY
			 , END_CUSTOMER
		 FROM  SCM_MST_SITE AS A WITH(NOLOCK)   
		WHERE  A.VALID_YN  = 'Y'  
		  AND  A.SCM_SITE_ID LIKE '%' + '-A'  
	) A
	WHERE 1=1
	GROUP BY SCM_SITE_ID

--//########################### case 1 Start

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
	print  convert(varchar(30), getdate(), 121) + N' MKT FCST (To Site)' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#MKT_FCST') IS NOT NULL DROP TABLE #MKT_FCST
	SELECT MK.SCM_SITE_ID		AS SALES_SITE_ID
		  ,TS.COUNTRY			AS TO_COUNTRY
		  ,TS.CITY				AS TO_CITY
		  ,TS.END_CUSTOMER		AS CUSTOMER 
		  ,MK.PROJECT_CODE		AS PROJECT_CODE	
		  ,MK.ITEM_ID			AS SALES_ITEM_ID
		  ,MK.INCOTERMS
		  ,MK.MEASURE
		  ,LEFT(FI.FLOW_ID,5)	AS MODEL_OPERATION_ID
		  ,FI.OPERATION_GROUP	AS MODEL_OPERATION_GROUP
		  ,FI.NICK_NAME			AS MODEL_NICK_NAME
		  ,MIN(MK.YYYYMMDD)		AS SALES_FROM_YYYYMMDD
		  ,MAX(MK.YYYYMMDD)		AS SALES_TO_YYYYMMDD
		  ,SUM(CASE WHEN ISNULL(DP.RN, 1) = 1 THEN MK.QTY ELSE 0 END)	AS QTY					-- PJ20257329 2025.09.12 소형 Cell Prod Site 적용
		  ,CONVERT(NVARCHAR(50), MAX(MK.LAST_UPDATE_DATE), 120)			AS MF_LAST_UPDATE_DATE	-- 2025.08.13 추가
		  -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	Start 
		  ,DP.CELL_PROD_SITE_ID	
		  ,DP.COMPANY_ID		AS COMPANY_ID_CELL_PROD
		  ,DP.SITE_ID			AS SITE_ID_CELL_PROD
		  ,DP.PLANT_ID			AS PLANT_ID_CELL_PROD
		  -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	End 
	 INTO #MKT_FCST
	 FROM DM_PLN_MKT_FCST MK WITH(NOLOCK)    -- DIVISION_ID, MEASURE, YYYYMMDD
		  LEFT  JOIN #SCM_MST_SITE_TO TS WITH(NOLOCK) 
				  ON TS.SCM_SITE_ID		 =	MK.SCM_SITE_ID 
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
	  AND MK.MEASURE		= CASE WHEN TS.SITE_TYPE = 'SALES' AND TS.OPERATION_GROUP = 'W'	THEN 'AS_In_Req' 
								   WHEN TS.VMI_YN = 'Y'										THEN 'VMI_In_Req' 
								   WHEN ISNULL(MK.ATTRIBUTE10, '') = ''						THEN 'MKT_FCST' 
							  END
	  AND MK.YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
	  AND MK.QTY		   != 0 
	  AND SS.SCM_SITE_ID IS NULL -- PJ20257329 2025.09.05 AS Sales Site 제외 
	GROUP BY MK.SCM_SITE_ID		
		    ,TS.COUNTRY	
		    ,TS.CITY
			,TS.END_CUSTOMER
		    ,MK.PROJECT_CODE		
		    ,MK.ITEM_ID		
			,MK.INCOTERMS	
			,MK.MEASURE	
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
	SELECT DISTINCT 
		   BO.MODEL_ID
		  -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	Start
		  ,BO.COMPANY_ID
		  ,BO.SITE_ID
		  ,BO.PLANT_ID
		  -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	End 
		  ,BO.CHILD_ITEM_ID
		  ,CASE WHEN FI.OPERATION_GROUP_ID NOT IN ('A', 'E')
				THEN 'P'
				ELSE FI.OPERATION_GROUP_ID	
		   END						AS CHILD_OPERATION_GROUP
		  ,LEFT(FI.FLOW_ID,5)		AS CHILD_OPERATION_ID 
		  ,FI.ELECTRODE_TYPE		AS CHILD_ELECTRODE_TYPE
	 INTO #SCP_BOM
	 FROM SCM_MST_MODEL_BOM BO WITH(NOLOCK) -- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CONCATENATE_ITEM
		  INNER JOIN SCM_MST_ITEM_SN IM WITH(NOLOCK)
				  ON IM.ITEM_ID		= BO.CHILD_ITEM_ID
				 AND IM.COMPANY_ID	= BO.CHILD_COMPANY_ID
				 AND IM.DIVISION_ID	= BO.CHILD_DIVISION_ID
				 AND IM.SITE_ID		= BO.CHILD_SITE_ID
				 AND IM.ACTIVE_FLAG = 'Y'						-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON FI.DIVISION_ID	= BO.DIVISION_ID
				 AND FI.ITEM_ID		= BO.CHILD_ITEM_ID
				 AND FI.ATTRIBUTE8 NOT LIKE 'CA%'	-- Cell Assy 제외 
				 AND FI.OPERATION_GROUP != 'E'		-- 전극 제외 
		-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조 -- start 
		  LEFT  JOIN SCM_MST_ITEM_SN P WITH(NOLOCK)		  
				  ON P.ITEM_ID		= BO.PARENT_ITEM_ID	  
				 AND P.COMPANY_ID	= BO.COMPANY_ID		  
				 AND P.DIVISION_ID	= BO.DIVISION_ID	  
				 AND P.SITE_ID		= BO.SITE_ID		  
				 AND P.ACTIVE_FLAG  = 'Y'
		-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조 -- end 
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
		  INNER JOIN #SCM_MST_SITE_FROM PS WITH(NOLOCK)
				  ON PS.SCM_SITE_ID = PR.PLANT_SITE_ID
	WHERE 1=1
	  AND PR.DIVISION_ID  = @v_division_id
	  AND PR.VALID_YN	  = 'Y'
	  AND PR.TO_YYYYMMDD >= @v_from_yyyymmdd

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' MKT FCST 기준 Project Route 존재하지 않는 데이터' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#PROJECT_ROUTE_NOT_EXISTS') IS NOT NULL DROP TABLE #PROJECT_ROUTE_NOT_EXISTS
	SELECT MK.*
		  ,BO.CHILD_ITEM_ID
		  ,BO.CHILD_OPERATION_GROUP
		  ,BO.CHILD_OPERATION_ID
		  ,CONVERT(NVARCHAR(200),'COM01'	)								AS MASTER_INVLD_CD 
		  ,CONVERT(NVARCHAR(200), CONCAT('Sales Period:',MK.SALES_FROM_YYYYMMDD,'~',MK.SALES_TO_YYYYMMDD,', Target Item:',BO.CHILD_ITEM_ID, ', FCST Last Update :',MK.MF_LAST_UPDATE_DATE))	AS MASTER_INVLD_CTN  -- 상세내용 -- 2025.08.13 수요 최종 변경일 추가 
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
	  AND NOT EXISTS (SELECT 'X'
					   FROM #PROJECT_ROUTE PR
					  WHERE PR.ITEM_ID			= BO.CHILD_ITEM_ID
					    -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 Start 
					    AND PR.PLANT_SITE_ID	= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND BO.CHILD_OPERATION_GROUP = 'A'
													   THEN MK.CELL_PROD_SITE_ID 
													   ELSE PR.PLANT_SITE_ID
												  END 
					    -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 Start 
						AND PR.PROJECT_CODE		= CASE WHEN @v_division_id IN ('40', '82') OR BO.CHILD_OPERATION_GROUP = 'E'	 -- 2025.08.04 수정 (40/82 division case 처리) 
													   THEN '-'																	 -- 2025.08.04 수정 (40/82 division case 처리) 
													   ELSE MK.PROJECT_CODE														 -- 2025.08.04 수정 (40/82 division case 처리) 
												  END 
						AND PR.SALES_SITE_ID	= CASE WHEN @v_division_id IN ('40', '82') OR BO.CHILD_OPERATION_GROUP = 'E'
													   THEN '-'
													   ELSE MK.SALES_SITE_ID
												   END )

		
--//########################### case 2 Start

/*
2) CURRENT MKT FCST DP에 입력되어 있는 '모델' / TO SITE'/ 'INCOTERMS'와
   해당 모델의 PJT ROUTE의 FROM SITE 정보를 기반으로
 >> FROM SITE/TO SITE/INCOTERMS 로 MAPPING되는 BOD ID 정보가 없는 경우
*/

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' BOD ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#BOD') IS NOT NULL DROP TABLE #BOD
	SELECT B.BOD_ID 
		  ,D.ROUTE_ID
		  ,B.DIVISION_ID
		  ,B.FROM_SITE
		  ,B.TO_SITE
		  ,B.INCOTERMS
		  ,D.TRANSPORT_MODE
		  ,B.ATTRIBUTE2		AS FROM_YYYYMMDD
		  ,B.ATTRIBUTE3		AS TO_YYYYMMDD 
		  ,B.VALID_YN		AS BOD_VALID_YN
		  ,D.VALID_YN		AS ROUTE_VALID_YN 
	  INTO #BOD
	  FROM SCP_MST_BOD B WITH(NOLOCK)
		   INNER JOIN SCP_MST_DISTRIBUTION_ROUTE D WITH(NOLOCK)
				   ON D.ROUTE_ID = B.ROUTE_ID
	 WHERE 1=1

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Transport Mode' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TRANSPORT_MODE') IS NOT NULL DROP TABLE #TRANSPORT_MODE
	SELECT DISTINCT 
		   FROM_COUNTRY
		  ,FROM_CITY
		  ,TO_COUNTRY
		  ,TO_CITY
		  ,TRANSPORT_MODE
	 INTO #TRANSPORT_MODE
	 FROM SCP_MST_DISTRIBUTION_ROUTE WITH(NOLOCK)
	WHERE 1=1
	  AND VALID_YN = 'Y'

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' From Site - Project Route 기준' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#FROM_SITE_BY_PROJECT_ROUTE') IS NOT NULL DROP TABLE #FROM_SITE_BY_PROJECT_ROUTE
	SELECT  DISTINCT
			SI.DIVISION_ID
	      , FS.SCM_SITE_ID				AS FROM_SITE
		  , FS.COUNTRY					AS FROM_COUNTRY
		  , FS.CITY						AS FROM_CITY
		  , SI.ITEM_ID					AS ITEM_ID
		  , SI.PROJECT_CODE				AS PROJECT_CODE
		  , SP.SALES_SITE_ID
		  , RIGHT(SP.PLANT_SITE_ID,1)	AS PLANT_TYPE		
		  , SP.FROM_YYYYMMDD
		  , SP.TO_YYYYMMDD 
	 INTO #FROM_SITE_BY_PROJECT_ROUTE
	 FROM #SCM_MST_SITE_FROM FS WITH(NOLOCK)	-- From site (Plant Site) 
		  INNER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK)
		  		ON SI.DIVISION_ID	= @v_division_id																							
  		  	   AND SI.SCM_SITE_ID	= FS.SCM_SITE_ID
			   AND SI.VALID_YN		= 'Y'
		  INNER JOIN #PROJECT_ROUTE SP	 WITH(NOLOCK)
		  		ON SP.PLANT_SITE_ID = SI.SCM_SITE_ID																				
  		  	   AND SP.PROJECT_CODE	= SI.PROJECT_CODE																							
  		  	   AND SP.ITEM_ID		= SI.ITEM_ID		
	WHERE 1=1																							
	  AND NOT (FS.OSP_YN = 'Y' AND FS.OPERATION_GROUP = 'A')  -- From site가 외주 Cell 사이트인 경우 제외 (소형 KR02149300_40-A) : asis 로직 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' To Sales BOD가 없는 경우 - Sales Model ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#BOD_NOT_EXISTS') IS NOT NULL DROP TABLE #BOD_NOT_EXISTS

	-- BOD Requried Case 1 (asis 1.1과 1.2) 
	-- Current MKT FCST의 Model/ToSite/Incoterms와 Project Route의 Plant Site 정보를 기준으로 BOD 매핑 유무 확인
	;WITH BOD_NOT_EXISTS AS ( 
		SELECT DISTINCT 
			   FS.DIVISION_ID
			  ,FS.ITEM_ID
			  ,FS.FROM_SITE
			  ,FS.FROM_COUNTRY
			  ,FS.FROM_CITY
			  ,TS.SALES_SITE_ID			AS TO_SITE 
			  ,TS.TO_COUNTRY
			  ,TS.TO_CITY
			  ,TS.INCOTERMS
			  ,TS.PROJECT_CODE
			  ,TS.MODEL_OPERATION_GROUP AS OPERATION_GROUP
			  ,TS.MODEL_NICK_NAME		AS NICK_NAME
		  FROM #MKT_FCST TS
			   INNER JOIN #FROM_SITE_BY_PROJECT_ROUTE FS 
					   ON TS.SALES_ITEM_ID	= FS.ITEM_ID	-- Sales Model 
					   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	Start
					  AND CASE WHEN TS.CELL_PROD_SITE_ID IS NOT NULL AND TS.MODEL_OPERATION_GROUP = 'A'
							   THEN TS.CELL_PROD_SITE_ID
							   ELSE FS.FROM_SITE 
						  END				= FS.FROM_SITE 
					   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	End
					  AND CASE WHEN @v_division_id in ('40', '82') OR TS.MODEL_OPERATION_GROUP = 'E'
							   THEN '-'
							   ELSE TS.PROJECT_CODE 
						   END				= FS.PROJECT_CODE
					  AND CASE WHEN @v_division_id in ('40', '82') OR TS.MODEL_OPERATION_GROUP = 'E' 
							   THEN '-'
							   ELSE TS.SALES_SITE_ID 
						   END				= FS.SALES_SITE_ID
		  WHERE 1=1
			AND NOT EXISTS (SELECT 'X' 
							  FROM #BOD B
								   INNER JOIN SCP_MST_BOD_ITEM BI WITH(NOLOCK)			-- 7/2 추가  
										   ON BI.BOD_ID = B.BOD_ID 
							 WHERE 1=1
							   AND B.DIVISION_ID	= FS.DIVISION_ID
							   AND B.FROM_SITE		= FS.FROM_SITE
							   AND B.TO_SITE		= TS.SALES_SITE_ID
							   AND B.INCOTERMS		= TS.INCOTERMS
							   AND BI.ITEM_ID		= FS.ITEM_ID						-- 7/2 BOD item 확인  
							   AND BI.TO_YYYYMMDD  >= @v_from_yyyymmdd
							   ) 
		-- To Sales(VMI 및 AS창고) incoterms DAP BOD가 없는 경우
		-- BOD Requried Case 2 (asis 2.1과 2.2) 
		-- Current MKT FCST의 Model/ToSite/Incoterms와 Project Route의 Plant Site 정보를 기준으로 BOD 매핑 유무 확인
		UNION
		SELECT DISTINCT 
			   FS.DIVISION_ID
			  ,FS.ITEM_ID
			  ,FS.FROM_SITE
			  ,FS.FROM_COUNTRY
			  ,FS.FROM_CITY
			  ,TS.SALES_SITE_ID			AS TO_SITE 
			  ,TS.TO_COUNTRY
			  ,TS.TO_CITY
			  ,'DAP'					AS INCOTERMS
			  ,TS.PROJECT_CODE
			  ,TS.MODEL_OPERATION_GROUP AS OPERATION_GROUP
			  ,TS.MODEL_NICK_NAME		AS NICK_NAME
		  FROM #MKT_FCST TS
			   INNER JOIN #FROM_SITE_BY_PROJECT_ROUTE FS 
					   ON TS.SALES_ITEM_ID	= FS.ITEM_ID	-- Sales Model 
					   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	Start
					  AND CASE WHEN TS.CELL_PROD_SITE_ID IS NOT NULL AND TS.MODEL_OPERATION_GROUP = 'A'
							   THEN TS.CELL_PROD_SITE_ID
							   ELSE FS.FROM_SITE 
						  END				= FS.FROM_SITE 
					   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	End
					  AND CASE WHEN @v_division_id in ('40', '82')  OR TS.MODEL_OPERATION_GROUP = 'E'
							   THEN '-'
							   ELSE TS.PROJECT_CODE 
						   END				= FS.PROJECT_CODE
					  AND CASE WHEN @v_division_id in ('40', '82')  OR TS.MODEL_OPERATION_GROUP = 'E'
							   THEN '-'
							   ELSE TS.SALES_SITE_ID 
						   END				= FS.SALES_SITE_ID
		  WHERE 1=1
			AND TS.MEASURE IN ('AS_In_Req', 'VMI_In_Req') 
			AND NOT EXISTS (SELECT 'X' 
							  FROM #BOD B
								   INNER JOIN SCP_MST_BOD_ITEM BI WITH(NOLOCK)			-- 7/2 추가  
										   ON BI.BOD_ID = B.BOD_ID 
							 WHERE 1=1
							   AND B.DIVISION_ID	= FS.DIVISION_ID
							   AND B.FROM_SITE		= FS.FROM_SITE
							   AND B.TO_SITE		= TS.SALES_SITE_ID
							   AND B.INCOTERMS		= 'DAP'
							   AND BI.ITEM_ID		= FS.ITEM_ID						-- 7/2 BOD item 확인  
							   AND BI.TO_YYYYMMDD  >= @v_from_yyyymmdd
							   ) 
	)
	SELECT *
	 INTO #BOD_NOT_EXISTS
	 FROM BOD_NOT_EXISTS
	WHERE 1=1 

		
--//########################### case 3 Start

/*
3) CURRENT SHIP SEMI/FG SHIP PLAN 에 입력되어 있는 모델
 >> 해당 모델의 출하계획 시기가 BOD ID의 FROM-TO 날짜외 계획있는 경우, 사용한 BOD ID의 VALID N 인 경우
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

	-------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' FG 출하계획'  -- 6/27
	-------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SHIP_PLAN_FG') IS NOT NULL DROP TABLE #SHIP_PLAN_FG; 

	SELECT SP.DIVISION_ID
		  ,SP.ITEM_ID
		  ,SP.YYYYMMDD
		  ,SP.BOD_ID
		  ,SP.QTY
	 INTO #SHIP_PLAN_FG
	 FROM #SCP_PLAN_VERSION PV 
		  INNER JOIN SCP_ANL_SHIPMENT_PLAN_FG SP WITH(NOLOCK)  -- PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, DIVISION_ID, YYYYMMDD, BIZ_TYPE, ITEM_ID, PROJECT_CODE, TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, MEASURE
				  ON SP.PLAN_START_YYYYMMDD = PV.PLAN_START_YYYYMMDD
				 AND SP.DIVISION_ID			= PV.DIVISION_ID
				 AND SP.PLAN_TYPE			= PV.PLAN_TYPE
				 AND SP.SEQ					= PV.PLAN_SEQ 
				 AND SP.YYYYMMDD		   <= PV.HORIZON_END_DATE -- 6/13 
				 AND SP.MEASURE				='SHIP_PLAN_AMEND'
	WHERE 1=1
	  AND SP.QTY  != 0  

	-------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' SEMI 출하계획' -- 6/27 
	-------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SHIP_PLAN_SEMI') IS NOT NULL DROP TABLE #SHIP_PLAN_SEMI; 

	SELECT SP.DIVISION_ID
		  ,SP.ITEM_ID
		  ,SP.YYYYMMDD
		  ,SP.BOD_ID
		  ,SP.QTY
	 INTO #SHIP_PLAN_SEMI
	 FROM #SCP_PLAN_VERSION PV   
		  INNER JOIN SCP_ANL_SHIPMENT_PLAN_SEMI SP WITH(NOLOCK)	-- DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, FROM_SITE, BOD_ID, MEASURE, YYYYMMDD
				  ON SP.DIVISION_ID			= PV.DIVISION_ID			
				 AND SP.PLAN_START_YYYYMMDD	= PV.PLAN_START_YYYYMMDD
				 AND SP.PLAN_TYPE			= PV.PLAN_TYPE	
				 AND SP.SEQ 				= PV.PLAN_SEQ	
				 AND SP.MEASURE				= 'SHIP_PLAN_AMEND'
				 AND SP.YYYYMMDD		   <= PV.HORIZON_END_DATE   
	WHERE 1=1
	  AND SP.QTY  != 0 

	-------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' BOD Valid N인 FG/SEMI 출하 계획' 
	-------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#INVALID_BOD_SHIP_PLAN') IS NOT NULL DROP TABLE #INVALID_BOD_SHIP_PLAN; 
	;WITH INVALID_BOD_SHIP_PLAN AS ( 
		-- BOD Valid 'N' 이거나 BOD 유효기간 범위 밖 FG출하 계획 
		SELECT 'FG'	AS DV
			  ,B.BOD_VALID_YN
			  ,SP.DIVISION_ID
			  ,SP.ITEM_ID
			  ,FI.NICK_NAME
			  ,B.FROM_SITE
			  ,B.TO_SITE
			  ,B.INCOTERMS
			  ,B.TRANSPORT_MODE
			  ,SUM(SP.QTY)		AS QTY
			  ,MIN(SP.YYYYMMDD)	AS MIN_YMD
			  ,MAX(SP.YYYYMMDD) AS MAX_YMD
		 FROM #SHIP_PLAN_FG SP WITH(NOLOCK)
			  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.DIVISION_ID = SP.DIVISION_ID
					 AND FI.ITEM_ID		= SP.ITEM_ID 
			  INNER JOIN #BOD B
					  ON B.BOD_ID = SP.BOD_ID
		WHERE 1=1
		  AND (B.BOD_VALID_YN = 'N' 
			   OR
			   NOT (SP.YYYYMMDD BETWEEN B.FROM_YYYYMMDD AND B.TO_YYYYMMDD)	-- 유효기간 범위 밖 출하계획 
			  )
		GROUP BY B.BOD_VALID_YN
				,SP.DIVISION_ID
				,SP.ITEM_ID
				,FI.NICK_NAME
				,B.FROM_SITE
				,B.TO_SITE
				,B.INCOTERMS
				,B.TRANSPORT_MODE
		UNION ALL 
		-- BOD Valid 'N' 이거나 BOD 유효기간 범위 밖 SEMI출하 계획 
		SELECT 'SEMI'	AS DV
			  ,B.BOD_VALID_YN
			  ,SP.DIVISION_ID
			  ,SP.ITEM_ID
			  ,FI.NICK_NAME
			  ,B.FROM_SITE
			  ,B.TO_SITE
			  ,B.INCOTERMS
			  ,B.TRANSPORT_MODE
			  ,SUM(SP.QTY)		AS QTY
			  ,MIN(SP.YYYYMMDD)	AS MIN_YMD
			  ,MAX(SP.YYYYMMDD) AS MAX_YMD
		 FROM #SHIP_PLAN_SEMI SP WITH(NOLOCK)
			  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.DIVISION_ID = SP.DIVISION_ID
					 AND FI.ITEM_ID		= SP.ITEM_ID 
			  INNER JOIN #BOD B
					  ON B.BOD_ID				= SP.BOD_ID
		WHERE 1=1
		  AND (B.BOD_VALID_YN = 'N' 
			   OR
			   NOT (SP.YYYYMMDD BETWEEN B.FROM_YYYYMMDD AND B.TO_YYYYMMDD) -- 유효기간 범위 밖 출하계획 
			  )
		GROUP BY B.BOD_VALID_YN
				,SP.DIVISION_ID
				,SP.ITEM_ID
				,FI.NICK_NAME
				,B.FROM_SITE
				,B.TO_SITE
				,B.INCOTERMS
				,B.TRANSPORT_MODE
	)
	SELECT *
	 INTO #INVALID_BOD_SHIP_PLAN
	 FROM INVALID_BOD_SHIP_PLAN
	WHERE 1=1 

-- #######################################-- #######################################-- #######################################-- #######################################
-- #######################################-- #######################################-- #######################################-- #######################################

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 확인대상 데이터 전체' -- #######################################
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TARGET_DATA') IS NOT NULL DROP TABLE #TARGET_DATA
	SELECT TG.*
	 INTO #TARGET_DATA
	 FROM ( 
			--- Project Route 미등록 
			SELECT @v_division_id		AS DIVISION_ID
				  ,RN.SALES_ITEM_ID		AS MODEL_ID
				  ,RN.MODEL_NICK_NAME	AS NICK_NAME
				  ,RN.MASTER_INVLD_CD
				  ,SM.SITE_DESCRIPTION	AS SALES_PLANT_SITE
				  ,RN.PROJECT_CODE		AS PROJECT_OPERATION
				  ,RN.INCOTERMS			AS INCOTERMS_LINE
				  ,RN.QTY
				  ,RN.MASTER_INVLD_CTN
				 -- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 Start 
				   +CASE WHEN RN.CELL_PROD_SITE_ID IS NOT NULL AND RN.CHILD_OPERATION_GROUP = 'A'
						 THEN ' ,Cell Prod Site : ' + CS.NAME 
						 ELSE '' 
					END AS MASTER_INVLD_CTN
				 -- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 End 
			 FROM #PROJECT_ROUTE_NOT_EXISTS RN
				  INNER JOIN #SCM_MST_SITE_TO SM WITH(NOLOCK)
						  ON SM.SCM_SITE_ID = RN.SALES_SITE_ID
				 -- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 Start 
				   LEFT JOIN #CELL_PROD_SITE_ID CS
						  ON CS.CODE = RN.CELL_PROD_SITE_ID 
				 -- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 End 

			-- BOD 미등록 
			-- BOD 미등록 
			UNION ALL 
			SELECT BN.DIVISION_ID
				  ,BN.ITEM_ID
				  ,BN.NICK_NAME
				  ,'BOD02'				AS MASTER_INVLD_CD
				  ,TS.SITE_DESCRIPTION	AS SALES_PLANT_SITE
				  ,BN.PROJECT_CODE		AS PROJECT_OPERATION
				  ,BN.INCOTERMS			AS INCOTERMS_LINE
				  ,NULL					AS QTY
				  ,CONCAT('From Site:',FS.SITE_DESCRIPTION) AS MASTER_INVLD_CTN
			 FROM #BOD_NOT_EXISTS BN
				  INNER JOIN #SCM_MST_SITE_TO TS WITH(NOLOCK)
						  ON TS.SCM_SITE_ID = BN.TO_SITE
				  INNER JOIN #SCM_MST_SITE_FROM FS WITH(NOLOCK)
						  ON FS.SCM_SITE_ID = BN.FROM_SITE
			WHERE 1=1
			-- BOD 유효기간 밖의 출하계획 또는 invalid BOD
			-- BOD 유효기간 밖의 출하계획 또는 invalid BOD
			UNION ALL 
			SELECT IB.DIVISION_ID
				  ,IB.ITEM_ID
				  ,IB.NICK_NAME
				  ,'BOD03'				AS MASTER_INVLD_CD
				  ,TS.SITE_DESCRIPTION	AS SALES_PLANT_SITE
				  ,NULL					AS PROJECT_OPERATION
				  ,IB.INCOTERMS			AS INCOTERMS_LINE
				  ,QTY
				  ,CONCAT('From Site:',FS.SITE_DESCRIPTION, ', FROM YMD : ', MIN_YMD, ', TO_YMD : ' , MAX_YMD) AS MASTER_INVLD_CTN
			 FROM #INVALID_BOD_SHIP_PLAN IB 
				  INNER JOIN #SCM_MST_SITE_TO TS WITH(NOLOCK)
						  ON TS.SCM_SITE_ID = IB.TO_SITE
				  INNER JOIN #SCM_MST_SITE_FROM FS WITH(NOLOCK)
						  ON FS.SCM_SITE_ID = IB.FROM_SITE 
		) AS TG
	WHERE 1=1 


	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 확인 대상 전체 데이터 - Basic Cell Nickname 매핑  '  ----########
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TARGET_DATA_BC_NICK_NAME') IS NOT NULL DROP TABLE #TARGET_DATA_BC_NICK_NAME
	SELECT TD.DIVISION_ID
		  ,TD.MODEL_ID
		  ,TD.NICK_NAME
		  ,BI.BASIC_NICK_NAME		AS BASIC_CELL_NICK_NAME 
		  ,TD.MASTER_INVLD_CD
		  ,TD.SALES_PLANT_SITE
		  ,TD.PROJECT_OPERATION
		  ,TD.INCOTERMS_LINE
		  ,TD.QTY
		  ,TD.MASTER_INVLD_CTN 
	 INTO #TARGET_DATA_BC_NICK_NAME
	 FROM #TARGET_DATA TD   
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON FI.DIVISION_ID = TD.DIVISION_ID
				 AND FI.ITEM_ID		= TD.MODEL_ID
		  LEFT  JOIN SCP_MST_ITEM_BSI_IFO BI WITH(NOLOCK)
				  ON BI.ITEM_ID		= CASE WHEN FI.OPERATION_GROUP = 'P'	THEN FI.ATTRIBUTE1
										   ELSE TD.MODEL_ID
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
	print  convert(varchar(30), getdate(), 121) + N' 확인 대상 전체 데이터 - Plan Group 매핑  '  ----#################
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TARGET_DATA_PLAN_GROUP') IS NOT NULL DROP TABLE #TARGET_DATA_PLAN_GROUP
	SELECT ISNULL(PG.OPMZ_PLAN_GR_ID	,PG_NICK.OPMZ_PLAN_GR_ID	)	AS OPMZ_PLAN_GR_ID	
		  ,ISNULL(PG.OPMZ_PLAN_GR_NAME	,PG_NICK.OPMZ_PLAN_GR_NAME	)	AS OPMZ_PLAN_GR_NAME	
		  ,ISNULL(PG.LINE_ID			,PG_NICK.LINE_ID			)	AS LINE_ID			
		  ,ISNULL(PG.BASIC_NICK_NAME 	,PG_NICK.BASIC_NICK_NAME 	)	AS BASIC_NICK_NAME 	
		  ,CASE WHEN PG.LINE_ID IS NOT NULL			THEN 'A'	-- item id mapping 
				WHEN PG_NICK.LINE_ID IS NOT NULL	THEN 'B'	-- basic cell nick name mapping 
				ELSE 'Z'
			END															AS DV 
		  ,TD.DIVISION_ID
		  ,TD.MODEL_ID
		  ,TD.NICK_NAME
		  ,TD.BASIC_CELL_NICK_NAME 
		  ,TD.MASTER_INVLD_CD
		  ,TD.SALES_PLANT_SITE
		  ,TD.PROJECT_OPERATION
		  ,TD.INCOTERMS_LINE
		  ,TD.QTY
		  ,TD.MASTER_INVLD_CTN 
	 INTO #TARGET_DATA_PLAN_GROUP
	 FROM #TARGET_DATA_BC_NICK_NAME TD 
		  LEFT JOIN #PLAN_GROUP_INFO PG	-- item_id로 매핑 
				 ON PG.DIVISION_ID	= TD.DIVISION_ID
				AND PG.ITEM_ID		= TD.MODEL_ID
				AND PG.RN			= 1 
		  LEFT JOIN #PLAN_GROUP_INFO PG_NICK	-- basic cell nick name으로 매핑 
				 ON PG_NICK.DIVISION_ID		= TD.DIVISION_ID
				AND PG_NICK.BASIC_NICK_NAME	= TD.BASIC_CELL_NICK_NAME
				AND PG_NICK.RN_NICK			= 1 
	WHERE 1=1

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 전체 확인 필요 대상 조회' -- ####################################
	------------------------------------------------------------------------------------------------------------------
	SELECT DISTINCT								-- PJ20257329 2025.09.12 중복 데이터 제거 
		   TD.DIVISION_ID
		  ,TD.MODEL_ID   AS ITEM_ID
		  ,TD.NICK_NAME
		  ,TD.BASIC_CELL_NICK_NAME
		  ,CASE WHEN TD.DV IN ('A', 'B')				THEN CONCAT(TD.OPMZ_PLAN_GR_NAME, '')	-- , ' (', MG.OPMZ_PLAN_GR_ID, ')') 
				WHEN TD.BASIC_CELL_NICK_NAME IS NULL	THEN '-'
				ELSE CONCAT(TD.BASIC_CELL_NICK_NAME, N' (예상)') 
		    END								AS PLAN_GROUP
		  ,ISNULL(TD.OPMZ_PLAN_GR_ID,'-')	AS OPMZ_PLAN_GR_ID 
		  ,TD.MASTER_INVLD_CD
		  ,LK.ATTRIBUTE2					AS MASTER_INVLD_MSG
		  ,TD.SALES_PLANT_SITE
		  ,TD.PROJECT_OPERATION
		  ,TD.INCOTERMS_LINE
		  ,TD.QTY
		  ,TD.MASTER_INVLD_CTN 
		  ,TD.DV							-- 2025.08.13 확인 차원에서 추가
	 FROM #TARGET_DATA_PLAN_GROUP TD
		  LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
				  ON LK.LOOKUP_TYPE		= 'MASTER_INVLD_CD'
				 AND LK.SEGMENT1		= TD.MASTER_INVLD_CD
				 AND LK.VALID_YN		= 'Y'
      INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
              ON TD.MODEL_ID  like  b.tst 
              OR TD.NICK_NAME like  b.tst  				 
   WHERE 1=1 
	   AND ( ( @p_plan_group_id IS NULL OR  @p_plan_group_id = '' ) OR TD.OPMZ_plan_gr_id IN (SELECT token FROM dbo.String_Split(@p_plan_group_id  ,',')) )
	 ORDER BY LK.ATTRIBUTE2, 1,2,3,4,5,6 
   

END






