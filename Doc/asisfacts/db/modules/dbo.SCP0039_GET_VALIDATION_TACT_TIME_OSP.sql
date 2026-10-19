
/*
 * Program ID   : SCP0039_GET_VALIDATION_TACT_TIME_OSP
 * Description  : Tact Time(OSP) [ESS - 82]  조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/10	kh  			Initial Release  PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축
 * 2025/08/06   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : Warranty 및 OSP plant 제외 (case2, case3) 
 * 2025/08/14   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- MKT FCST 최종 수정일시 정보 추가
 *										- plan_group/line assign 참조시 scp plan operation으로 공정 참조 범위 제한
 * 2025/08/26   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *									-- Model BOM 참조시 parent/child FP item master active 'Y'만 참조 
 * 2025/09/05   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- MKT_FCST 참조시 to AS Sales 사이트 제외 (AS_SITE_PLANT) 
 * 2025/09/12   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- 소형/ESS plan group 매핑 로직 자동차와 동일하게 적용
 * 
 */
 
CREATE PROCEDURE [dbo].[SCP0039_GET_VALIDATION_TACT_TIME_OSP]  
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
### 요구사항 Tact Time(OSP) [ESS]

1)CURRENT MKT FCST DP에 입력되어 있는 '모델' 정보를 기반으로
 >> 해당 모델의 PJT ROUTE가 설정되어 있지 않은 경우

2) CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
   해당 모델의 PJT ROUTE의 'PLANT' 정보를 기반으로
 >> ASSIGN 된 PLANT 내 TACT TIME 이 조회되지 않는경우  
--================================================================================================================================

*/

-- 파라미터로 받을 값 변수  
DECLARE @v_division_id			NVARCHAR(30)	= '82'; -- @p_division_id  // 40만 조회 김도형선임 (2025.07.15)
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

--//########################### case 1 Start
--//########################### case 1 Start
/*
1)CURRENT MKT FCST DP에 입력되어 있는 '모델' 정보를 기반으로
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
	print  convert(varchar(30), getdate(), 121) + N' MKT FCST' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#MKT_FCST') IS NOT NULL DROP TABLE #MKT_FCST
	SELECT MK.SCM_SITE_ID	AS SALES_SITE_ID	
		  ,MK.PROJECT_CODE	AS PROJECT_CODE	
		  ,MK.ITEM_ID			AS SALES_ITEM_ID
		  ,MK.INCOTERMS
		  ,LEFT(FI.FLOW_ID,5)	AS MODEL_OPERATION_ID
		  ,FI.OPERATION_GROUP	AS MODEL_OPERATION_GROUP
		  ,FI.NICK_NAME			AS MODEL_NICK_NAME
		  ,MIN(MK.YYYYMMDD)		AS SALES_FROM_YYYYMMDD
		  ,MAX(MK.YYYYMMDD)		AS SALES_TO_YYYYMMDD
		  ,SUM(MK.QTY)			AS QTY
		  ,CONVERT(NVARCHAR(50), MAX(MK.LAST_UPDATE_DATE), 120)	AS MF_LAST_UPDATE_DATE	-- 2025.08.14 추가
	 INTO #MKT_FCST
	 FROM DM_PLN_MKT_FCST MK WITH(NOLOCK)    -- DIVISION_ID, MEASURE, YYYYMMDD
		  INNER JOIN SCM_MST_SITE WS WITH(NOLOCK) 
				  ON WS.DIVISION_ID		 =	MK.DIVISION_ID 
				 AND WS.SCM_SITE_ID		 =	MK.SCM_SITE_ID 
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
				  ON FI.DIVISION_ID		 = MK.DIVISION_ID
				 AND FI.ITEM_ID			 = MK.ITEM_ID 
				 -- ??AND FI.OPERATION_GROUP  = 'P'		-- ESS Pack 
		-- PJ20257329 2025.09.05 AS Sales Site 제외 - start 
		  LEFT  JOIN #AS_SITE_PLANT SS
				  ON SS.SCM_SITE_ID		= MK.SCM_SITE_ID
				 AND SS.DIVISION_ID		= MK.DIVISION_ID
		-- PJ20257329 2025.09.05 AS Sales Site 제외 - End 
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

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' BOM ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCP_BOM') IS NOT NULL DROP TABLE #SCP_BOM 
	SELECT DISTINCT--- TOP 100 
		   BO.MODEL_ID
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
				 AND FI.ATTRIBUTE8 NOT LIKE 'CA%'	-- Cell Assy 제외 
				 AND FI.OPERATION_GROUP != 'E'		-- 전극 제외 
	WHERE 1=1
	  AND BO.DIVISION_ID	= @v_division_id
	  AND BO.ALT_PRIORITY	= 'Y'
	  AND (BO.PARENT_ITEM_ID = '*'  OR P.ITEM_ID IS NOT NULL)	-- PJ20257329 2025.08.26 parent/child item master active 'Y'만 참조
	  AND EXISTS (SELECT TOP 1 'X' 
				    FROM #MKT_FCST MK 
				   WHERE MK.SALES_ITEM_ID	= BO.MODEL_ID) 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' PROJECT ROUTE ' 
	-- 40/82 소형과 ESS는 Sales site 및 project Code 값이 없음 ('-')
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#PROJECT_ROUTE') IS NOT NULL DROP TABLE #PROJECT_ROUTE

	SELECT PR.ITEM_ID
		  ,PR.PLANT_SITE_ID
		  ,PR.FROM_YYYYMMDD
		  ,PR.TO_YYYYMMDD
		  ,PS.COUNTRY
		  ,PS.CITY
		  ,PS.OSP_YN 
		  ,ROW_NUMBER() OVER (PARTITION BY PR.ITEM_ID
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
		  ,CONVERT(NVARCHAR(200), CONCAT(N'Target Item :',MK.SALES_ITEM_ID, ', FCST Last Update :',MK.MF_LAST_UPDATE_DATE))	AS MASTER_INVLD_CTN  -- 상세내용 -- 2025.08.14 수요 최종 변경일 추가
	 INTO #PROJECT_ROUTE_NOT_EXISTS
	 FROM #MKT_FCST MK
		  INNER JOIN #SCP_BOM BO 
				  ON MK.SALES_ITEM_ID = BO.MODEL_ID
	WHERE 1=1 
	  AND BO.CHILD_OPERATION_GROUP != 'E'
	  AND BO.CELL_TYPE NOT LIKE 'CA%'
	  AND NOT EXISTS (SELECT 'X'
					   FROM #PROJECT_ROUTE PR
					  WHERE PR.ITEM_ID			= BO.CHILD_ITEM_ID)


--//########################### case 2 Start
--//########################### case 2 Start

/*
2) CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
   해당 모델의 PJT ROUTE의 'PLANT' 정보를 기반으로
 >> ASSIGN 된 PLANT 내 TACT TIME 이 조회되지 않는경우  
*/

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' MKT FCST / Project Route기준 Tact Time 존재하지 않는 경우 ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TACT_TIME_OSP_NOT_EXISTS') IS NOT NULL DROP TABLE #TACT_TIME_OSP_NOT_EXISTS
	SELECT DISTINCT 
		   MK.SALES_ITEM_ID
		  ,MK.SALES_SITE_ID
		  ,MK.INCOTERMS
		  ,MK.MODEL_NICK_NAME
		  ,MK.QTY
		  ,MK.SALES_FROM_YYYYMMDD
		  ,MK.SALES_TO_YYYYMMDD
		  ,PR.PLANT_SITE_ID
		  ,PS.SITE_DESCRIPTION	AS PLANT_SITE 
		  ,PR.ITEM_ID
		  ,PR.COUNTRY
		  ,PR.CITY
		  ,CONVERT(NVARCHAR(200), CONCAT('SalesSite:',MK.SALES_SITE_ID))		AS MASTER_INVLD_CTN  -- 상세내용
	 INTO #TACT_TIME_OSP_NOT_EXISTS
	 FROM #MKT_FCST MK
		  INNER JOIN #PROJECT_ROUTE PR
				  ON PR.ITEM_ID	= MK.SALES_ITEM_ID
		  INNER JOIN SCM_MST_SITE PS WITH(NOLOCK)
				  ON PS.DIVISION_ID = @v_division_id
				 AND PS.SCM_SITE_ID = PR.PLANT_SITE_ID
				 AND PS.OSP_YN		= 'Y'	-- OSP 외주 
				 AND PS.VALID_YN	= 'Y'
	WHERE 1=1 
	  AND NOT EXISTS (SELECT 'X'
					   FROM SCP_MST_TACT_TIME_OSP TT WITH(NOLOCK)
					  WHERE 1=1
					    AND TT.DIVISION_ID	 = PS.DIVISION_ID
						AND TT.PLANT_SITE_ID = PR.PLANT_SITE_ID
						AND TT.ITEM_ID		 = PR.ITEM_ID
						--  AND TT.OPERATION_ID  = PS.PLANT_ID  -------------------------------test ####################
						AND TT.TACT_TIME	!= 0 ) 

-- #######################################-- #######################################-- #######################################-- #######################################
-- #######################################-- #######################################-- #######################################-- #######################################

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 확인 대상 전체 데이터   '  ----##################################
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
			 FROM #PROJECT_ROUTE_NOT_EXISTS RN
				  INNER JOIN SCM_MST_SITE SM WITH(NOLOCK)
						  ON SM.DIVISION_ID = @v_division_id
						 AND SM.SCM_SITE_ID = RN.SALES_SITE_ID
			--- Tact Time 미등록
			/*
			2) CURRENT MKT FCST 에 입력되어 있는 '모델' 정보와
			   해당 모델의 PJT ROUTE의 'PLANT' 정보를 기반으로
			 >> ASSIGN 된 PLANT 내 TACT TIME 이 조회되지 않는경우  
			*/
			UNION ALL 
			SELECT @v_division_id		AS DIVISION_ID
				  ,TN.SALES_ITEM_ID		AS MODEL_ID
				  ,TN.MODEL_NICK_NAME	AS NICK_NAME
				  ,'TTO02'				AS MASTER_INVLD_ID
				  ,TN.PLANT_SITE		AS SALES_PLANT_SITE
				  ,NULL					AS PROJECT_OPERATION
				  ,TN.INCOTERMS			AS INCOTERMS_LINE
				  ,TN.QTY
				  ,TN.MASTER_INVLD_CTN
			 FROM #TACT_TIME_OSP_NOT_EXISTS TN
			WHERE 1=1
		) TG 
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
	print  convert(varchar(30), getdate(), 121) + N' 전체 확인 필요 대상 조회' -- #######################################
	------------------------------------------------------------------------------------------------------------------
	SELECT 
		   TD.DIVISION_ID
		  ,TD.MODEL_ID   AS ITEM_ID
		  ,TD.NICK_NAME
		  ,TD.BASIC_CELL_NICK_NAME
		  ,CASE WHEN TD.DV IN ('A', 'B')				THEN CONCAT(TD.OPMZ_PLAN_GR_NAME, '')
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
 	ORDER BY MASTER_INVLD_CD, 1,2,3,4,5,6 

END
