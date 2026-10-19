



/*
 * Program ID   : SCP0039_GET_VALIDATION_BOM
 * Description  : BOD
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * Initial Release  PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축
 * 2025/08/14   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- line assign 참조시 scp plan operation으로 공정 참조 범위 제한
 * 2025/08/26   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *									-- Model BOM 참조시 parent/child FP item master active 'Y'만 참조 
 * 2025/09/05   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- MKT_FCST 참조시 to AS Sales 사이트 제외 (AS_SITE_PLANT) 
 *										- Pack모델 기준 Cell확장/전극 미확장인 경우 -> 타Plant Cell모델 기준 전극 확장된 경우 제외
 * 2025/09/12   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- 소형/ESS plan group 매핑 로직 자동차와 동일하게 적용
 *										- 소형 MKT FCST 수요계획 데이터(DM_PLN_CFM_MKT_DEMAND_PLAN) Cell Prod Site 적용 
 * 
 */
 
CREATE PROCEDURE [dbo].[SCP0039_GET_VALIDATION_BOM]  
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
### BOM 요구사항 ###############################################################

1) CURRENT MKT FCST 에 입력되어 있는 '모델' 정보를 기반으로
 >> 해당 모델의 A9000(조립)/ E2000(전극) 공정에 대한 PLANT 확장 정보가 미존재하는 경우 (모든 PLANT 중)

2) CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
   해당모델의 A900(조립)/E2000(전극)공정 '모델' 기반으로
 >> ITEM TYPE = NULL 인경우
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
-- #######################################-- #######################################-- #######################################-- #######################################

--------------// start plan group info -- function으로 ??? 
--------------// start plan group info -- function으로 ??? 
--------------// start plan group info -- function으로 ??? 
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
--------------// end plan group info
--------------// end plan group info
--------------// end plan group info

-- #######################################-- #######################################-- #######################################-- #######################################
-- #######################################-- #######################################-- #######################################-- #######################################

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
	-- PK : DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
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
		  ,SUM(CASE WHEN ISNULL(DP.RN, 1) = 1 THEN MK.QTY ELSE 0 END)	AS QTY	-- PJ20257329 2025.09.12 소형 Cell Prod Site 적용
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
	print  convert(varchar(30), getdate(), 121) + N' MKT FCST가 존재하는 모델 BOM ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCP_BOM') IS NOT NULL DROP TABLE #SCP_BOM
	SELECT DISTINCT 
		   BO.MODEL_ID
		  -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	Start
		  ,BO.COMPANY_ID
		  ,BO.SITE_ID
		  ,BO.PLANT_ID
		  -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용	End 
		  ,MF.OPERATION_GROUP		AS MODEL_OPERATION_GROUP -- PJ20257329 2025.09.05 추가 	
		  ,BO.CHILD_DIVISION_ID
		  ,BO.CHILD_COMPANY_ID
		  ,BO.CHILD_SITE_ID
		  ,BO.CHILD_ITEM_ID
		  ,CASE WHEN FI.OPERATION_GROUP_ID NOT IN ('A', 'E')
				THEN 'P'
				ELSE FI.OPERATION_GROUP_ID	
		   END						AS CHILD_OPERATION_GROUP
		  ,LEFT(FI.FLOW_ID,5)		AS CHILD_OPERATION_ID 
		  ,FI.ELECTRODE_TYPE		AS CHILD_ELECTRODE_TYPE
		  ,IM.ITEM_TYPE				AS CHILD_ITEM_TYPE
		  ,IM.NICK_NAME				AS CHILD_ITEM_NICK_NAME
	 INTO #SCP_BOM
	 FROM SCM_MST_MODEL_BOM BO WITH(NOLOCK) -- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CONCATENATE_ITEM
		  INNER JOIN SCP_MST_FINAL_ITEM MF WITH(NOLOCK)  -- PJ20257329 2025.09.05 추가 JOIN 
				  ON MF.DIVISION_ID	= BO.DIVISION_ID
				 AND MF.ITEM_ID		= BO.MODEL_ID
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON FI.DIVISION_ID	= BO.DIVISION_ID
				 AND FI.ITEM_ID		= BO.CHILD_ITEM_ID
				 AND FI.ATTRIBUTE8 NOT LIKE 'CA%'	-- Cell Assy 제외  
		  INNER JOIN SCM_MST_ITEM_SN IM WITH(NOLOCK)
				  ON IM.ITEM_ID		= BO.CHILD_ITEM_ID
				 AND IM.COMPANY_ID	= BO.CHILD_COMPANY_ID
				 AND IM.DIVISION_ID	= BO.CHILD_DIVISION_ID
				 AND IM.SITE_ID		= BO.CHILD_SITE_ID
				 AND IM.ACTIVE_FLAG = 'Y'						-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조
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
	print  convert(varchar(30), getdate(), 121) + N' BOM - 모델별 셀 또는 전극(Anode/Cathod) 견수 정보 ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCP_BOM_CHILD_CNT') IS NOT NULL DROP TABLE #SCP_BOM_CHILD_CNT

	SELECT MODEL_ID
	      ,MAX(MODEL_OPERATION_GROUP)																									  AS MODEL_OPERATION_GROUP 	-- PJ20257329 2025.09.05 추가
		  ,MAX (CASE WHEN CHILD_OPERATION_GROUP = 'A'													THEN CHILD_ITEM_ID ELSE NULL END) AS CELL_MODEL_ID 			-- PJ20257329 2025.09.05 추가
		  ,COUNT(DISTINCT CASE WHEN CHILD_OPERATION_GROUP = 'A'											THEN CHILD_ITEM_ID ELSE NULL END) AS CELL_CNT
		  ,COUNT(DISTINCT CASE WHEN CHILD_OPERATION_GROUP = 'E' AND CHILD_ELECTRODE_TYPE = 'ANODE'		THEN CHILD_ITEM_ID ELSE NULL END) AS ANODE_CNT
		  ,COUNT(DISTINCT CASE WHEN CHILD_OPERATION_GROUP = 'E' AND CHILD_ELECTRODE_TYPE = 'CATHODE'	THEN CHILD_ITEM_ID ELSE NULL END) AS CATHODE_CNT
	 INTO #SCP_BOM_CHILD_CNT
	 FROM #SCP_BOM
	WHERE 1=1
	GROUP BY MODEL_ID

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' BOM - 모델별 셀 또는 전극(Anode/Cathod) 0인 건' 
	-- PJ20257329 2025.09.05 추가 
	-- Pack Model기준 Cell모델 확장 / 동일 plant 전극 미확장 이더라도 
	-- 타 plant에 해당 cell 모델의 전극 BOM확장된 경우 -> BOM 확장 된 것으로 본다.
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCP_BOM_CHILD_CNT_0') IS NOT NULL DROP TABLE #SCP_BOM_CHILD_CNT_0
	SELECT *
	 INTO #SCP_BOM_CHILD_CNT_0
	 FROM #SCP_BOM_CHILD_CNT PM
	WHERE (CELL_CNT = 0 OR ANODE_CNT = 0 OR CATHODE_CNT = 0)
	  AND NOT EXISTS (SELECT 'X'	-- Pack model 기준 Cell 확인되어 있고 
					    FROM #SCP_BOM_CHILD_CNT CM
					   WHERE CM.MODEL_OPERATION_GROUP = 'A'
					     AND PM.MODEL_OPERATION_GROUP = 'P'
						 AND PM.CELL_CNT    > 0		-- Pack model의 하위 cell 확장 
						 AND CM.ANODE_CNT	> 0 	-- Cell 모델의 하위 전극 확장
						 AND CM.CATHODE_CNT > 0 	-- Cell 모델의 하위 전극 확장
						 AND CM.MODEL_ID	= PM.CELL_MODEL_ID) 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' BOM에 Sales Model 또는 하위 Child item이 없는 경우 ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#BOM_NOT_EXISTS') IS NOT NULL DROP TABLE #BOM_NOT_EXISTS
	SELECT *
	 INTO #BOM_NOT_EXISTS
	 FROM (  
			--### 1. BOM에 Sales Model이 없는 경우 
			SELECT MK.*
				  ,CONVERT(NVARCHAR(200),'BOM01'	)	AS MASTER_INVLD_CD 
				  ,CONVERT(NVARCHAR(200),'Model:0'+ CASE WHEN MK.CELL_PROD_SITE_ID IS NULL 
														 THEN '' 
														 ELSE ' ,Cell Prod Site : ' + CS.NAME -- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가
													END) AS MASTER_INVLD_CTN  -- 상세내용
			  FROM #MKT_FCST MK
				 -- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 Start 
				   LEFT JOIN #CELL_PROD_SITE_ID CS
						  ON CS.CODE = MK.CELL_PROD_SITE_ID 
				 -- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 End 
			 WHERE 1=1
			   AND NOT EXISTS (SELECT 'X'
								 FROM #SCP_BOM SB
								WHERE 1=1
								  AND SB.MODEL_ID = MK.SALES_ITEM_ID) 
			UNION ALL
			--### 2. BOM에 Sales Model 정보는 있으나, BOM 하위에 Cell 또는 전극(양극 또는 음극) 품목이 없는 경우  (Final item 기준)
			SELECT MK.*
				  ,'BOM02'												AS MASTER_INVLD_CD 
				  ,CONCAT('Cell:',CONVERT(NVARCHAR(10),CELL_CNT)
						  ,',Anode:',CONVERT(NVARCHAR(10),ANODE_CNT)
						  ,',Cathode:',CONVERT(NVARCHAR(10),CATHODE_CNT)
							,CASE WHEN MK.CELL_PROD_SITE_ID IS NULL 
								  THEN '' 
								  ELSE ', Cell Prod Site ID : ' + CS.NAME	-- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가
							  END)										AS MASTER_INVLD_CTN  -- 상세내용
			  FROM #MKT_FCST MK
				   INNER JOIN #SCP_BOM_CHILD_CNT_0 CC  -- PJ20257329 2025.09.05 변경 (#SCP_BOM_CHILD_CNT -> #SCP_BOM_CHILD_CNT_0) 
						   ON CC.MODEL_ID = MK.SALES_ITEM_ID 
				 -- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 Start 
				   LEFT JOIN #CELL_PROD_SITE_ID CS
						  ON CS.CODE = MK.CELL_PROD_SITE_ID 
				 -- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 End 
			 WHERE 1=1
			   AND MK.MODEL_OPERATION_GROUP != 'E'
	) BOM_NOT_EXISTS_DATA


	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Item Type is NULL ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#ITEM_TYPE_IS_NULL') IS NOT NULL DROP TABLE #ITEM_TYPE_IS_NULL
	SELECT SB.CHILD_ITEM_TYPE
		  ,SB.CHILD_DIVISION_ID
		  ,SB.CHILD_COMPANY_ID
		  ,SB.CHILD_SITE_ID
		  ,SB.CHILD_ITEM_ID
		  ,SB.CHILD_ITEM_NICK_NAME
		  ,SB.CHILD_OPERATION_GROUP
		  ,MK.*
		  ,SB.CHILD_OPERATION_ID
		  ,SB.CHILD_ELECTRODE_TYPE
		  ,'BOM03'																											AS MASTER_INVLD_CD
		  ,CONCAT('Child Division:',SB.CHILD_DIVISION_ID, ', Sales Item : ',MK.SALES_ITEM_ID,', Company:', CM.COMPANY_NAME
							,CASE WHEN MK.CELL_PROD_SITE_ID IS NULL 
								  THEN '' 
								  ELSE ', Cell Prod Site ID : ' + CS.NAME	-- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가
							  END)																							AS MASTER_INVLD_CTN
	 INTO #ITEM_TYPE_IS_NULL
	 FROM #MKT_FCST MK
		  INNER JOIN #SCP_BOM SB	-- BOM이 존재한다는 전제하에 project route 확인 대상  
				  ON SB.MODEL_ID	= MK.SALES_ITEM_ID
			   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 Start 
			     AND SB.COMPANY_ID	= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND SB.CHILD_OPERATION_GROUP = 'A'
										   THEN MK.COMPANY_ID_CELL_PROD
										   ELSE SB.COMPANY_ID
									  END 
			     AND SB.SITE_ID		= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND SB.CHILD_OPERATION_GROUP = 'A'
										   THEN MK.SITE_ID_CELL_PROD
										   ELSE SB.SITE_ID
									  END 
			     AND SB.PLANT_ID	= CASE WHEN MK.CELL_PROD_SITE_ID IS NOT NULL AND SB.CHILD_OPERATION_GROUP = 'A'
										   THEN MK.PLANT_ID_CELL_PROD
										   ELSE SB.PLANT_ID
									  END 
			   -- PJ20257329 2025.09.12 소형 Cell Prod Site 적용 End 
		  LEFT  JOIN SCM_MST_COMPANY_SN CM WITH(NOLOCK)
				  ON CM.COMPANY_ID = SB.CHILD_COMPANY_ID
		 -- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 Start 
		  LEFT  JOIN #CELL_PROD_SITE_ID CS
				  ON CS.CODE = MK.CELL_PROD_SITE_ID 
		 -- PJ20257329 2025.09.12 소형 Cell Prod Site 정보 추가 End 
	WHERE 1=1
	  AND SB.CHILD_ITEM_TYPE IS NULL


-- #######################################-- #######################################-- #######################################-- #######################################
-- #######################################-- #######################################-- #######################################-- #######################################

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' BOM확인 대상 전체 데이터   '  ----###############################
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#BOM_TARGET_DATA') IS NOT NULL DROP TABLE #BOM_TARGET_DATA
	SELECT *
	 INTO #BOM_TARGET_DATA
	 FROM (
			-- BOM not exists  
			SELECT @v_division_id		AS DIVISION_ID
				  ,BN.SALES_ITEM_ID		AS MODEL_ID
				  ,BN.MODEL_NICK_NAME	AS NICK_NAME
				  ,BN.SALES_SITE_ID		AS SALES_PLANT_SITE
				  ,BN.PROJECT_CODE		AS PROJECT_OPERATION		
				  ,BN.INCOTERMS			AS INCOTERMS_LINE
				  ,BN.QTY
				  ,BN.MASTER_INVLD_CD
				  ,BN.MASTER_INVLD_CTN
			 FROM #BOM_NOT_EXISTS BN 
			UNION ALL 
			-- Item_type is null (SCM_MST_ITEM_SN)   
			SELECT @v_division_id			AS DIVISION_ID
				  ,TN.CHILD_ITEM_ID			AS MODE_ID
				  ,TN.CHILD_ITEM_NICK_NAME	AS NICK_NAME
				  ,TN.SALES_SITE_ID
				  ,TN.PROJECT_CODE		
				  ,TN.INCOTERMS
				  ,TN.QTY
				  ,TN.MASTER_INVLD_CD
				  ,TN.MASTER_INVLD_CTN
			 FROM #ITEM_TYPE_IS_NULL TN 
		) AS TG 
	WHERE 1=1		

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 전극 Applied Cell Model  ' ----##################################	
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
	print  convert(varchar(30), getdate(), 121) + N' BOM확인 대상 전체 데이터 - Basic Cell Nickname 매핑  '  ----#####
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#BOM_TARGET_DATA_BC_NICK_NAME') IS NOT NULL DROP TABLE #BOM_TARGET_DATA_BC_NICK_NAME
	SELECT BT.DIVISION_ID
		  ,BT.MODEL_ID
		  ,BT.NICK_NAME
		  ,BI.BASIC_NICK_NAME		AS BASIC_CELL_NICK_NAME 
		  ,BT.MASTER_INVLD_CD
		  ,BT.SALES_PLANT_SITE
		  ,BT.PROJECT_OPERATION
		  ,BT.INCOTERMS_LINE
		  ,BT.QTY
		  ,BT.MASTER_INVLD_CTN
	 INTO #BOM_TARGET_DATA_BC_NICK_NAME
	 FROM #BOM_TARGET_DATA BT   
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON FI.DIVISION_ID = BT.DIVISION_ID
				 AND FI.ITEM_ID		= BT.MODEL_ID
		  LEFT  JOIN #ELEC_APPLIED_MODEL EA
				  ON EA.DIVISION_ID = BT.DIVISION_ID
				 AND EA.ITEM_ID		= BT.MODEL_ID 
		  LEFT  JOIN SCP_MST_ITEM_BSI_IFO BI WITH(NOLOCK)
				  ON BI.ITEM_ID		= CASE WHEN FI.OPERATION_GROUP = 'E'	THEN EA.APPLIED_MODEL
										   WHEN FI.OPERATION_GROUP = 'P'	THEN FI.ATTRIBUTE1
										   ELSE BT.MODEL_ID
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
	print  convert(varchar(30), getdate(), 121) + N' BOM확인 대상 전체 데이터 - Plan Group 매핑  '  ----##############
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#BOM_TARGET_DATA_PLAN_GROUP') IS NOT NULL DROP TABLE #BOM_TARGET_DATA_PLAN_GROUP
	SELECT ISNULL(PG.OPMZ_PLAN_GR_ID	,PG_NICK.OPMZ_PLAN_GR_ID	)	AS OPMZ_PLAN_GR_ID	
		  ,ISNULL(PG.OPMZ_PLAN_GR_NAME	,PG_NICK.OPMZ_PLAN_GR_NAME	)	AS OPMZ_PLAN_GR_NAME	
		  ,ISNULL(PG.LINE_ID			,PG_NICK.LINE_ID			)	AS LINE_ID			
		  ,ISNULL(PG.BASIC_NICK_NAME 	,PG_NICK.BASIC_NICK_NAME 	)	AS BASIC_NICK_NAME 	
		  ,CASE WHEN PG.LINE_ID IS NOT NULL			THEN 'A'	-- item id mapping 
				WHEN PG_NICK.LINE_ID IS NOT NULL	THEN 'B'	-- basic cell nick name mapping 
				ELSE 'Z'
			END															AS DV 
		  ,BT.DIVISION_ID
		  ,BT.MODEL_ID
		  ,BT.NICK_NAME
		  ,BT.BASIC_CELL_NICK_NAME 
		  ,BT.MASTER_INVLD_CD
		  ,BT.SALES_PLANT_SITE
		  ,BT.PROJECT_OPERATION
		  ,BT.INCOTERMS_LINE
		  ,BT.QTY
		  ,BT.MASTER_INVLD_CTN 
	 INTO #BOM_TARGET_DATA_PLAN_GROUP
	 FROM #BOM_TARGET_DATA_BC_NICK_NAME BT 
		  LEFT JOIN #PLAN_GROUP_INFO PG	-- item_id로 매핑 
				 ON PG.DIVISION_ID	= BT.DIVISION_ID
				AND PG.ITEM_ID		= BT.MODEL_ID
				AND PG.RN			= 1 
		  LEFT JOIN #PLAN_GROUP_INFO PG_NICK	-- basic cell nick name으로 매핑 
				 ON PG_NICK.DIVISION_ID		= BT.DIVISION_ID
				AND PG_NICK.BASIC_NICK_NAME	= BT.BASIC_CELL_NICK_NAME
				AND PG_NICK.RN_NICK			= 1 
	WHERE 1=1

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 전체 확인 필요 대상 조회' -- ####################################
	------------------------------------------------------------------------------------------------------------------
	SELECT 
		   BT.DIVISION_ID
		  ,BT.MODEL_ID   AS ITEM_ID
		  ,BT.NICK_NAME
		  ,BT.BASIC_CELL_NICK_NAME
		  ,CASE WHEN BT.DV IN ('A', 'B')				THEN CONCAT(BT.OPMZ_PLAN_GR_NAME, '')
				WHEN BT.BASIC_CELL_NICK_NAME IS NULL	THEN '-'
				ELSE CONCAT(BT.BASIC_CELL_NICK_NAME, N' (예상)') 
		    END								AS PLAN_GROUP
		  ,ISNULL(BT.OPMZ_PLAN_GR_ID,'-')	AS OPMZ_PLAN_GR_ID 
		  ,BT.MASTER_INVLD_CD
		  ,LK.ATTRIBUTE2					AS MASTER_INVLD_MSG
		  ,BT.SALES_PLANT_SITE
		  ,BT.PROJECT_OPERATION
		  ,BT.INCOTERMS_LINE
		  ,BT.QTY
		  ,BT.MASTER_INVLD_CTN 
	 FROM #BOM_TARGET_DATA_PLAN_GROUP BT
		  LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
				  ON LK.LOOKUP_TYPE		= 'MASTER_INVLD_CD'
				 AND LK.SEGMENT1		= BT.MASTER_INVLD_CD
				 AND LK.VALID_YN		= 'Y'
    INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
            ON BT.MODEL_ID  like  b.tst 
            OR BT.NICK_NAME like  b.tst  						 
	WHERE 1=1 
	  AND ( ( @p_plan_group_id IS NULL OR  @p_plan_group_id = '' ) OR BT.OPMZ_PLAN_GR_ID IN (SELECT token FROM dbo.String_Split(@p_plan_group_id  ,',')) )
	ORDER BY MASTER_INVLD_CD, 1,2,3,4,5,6 

   
END

