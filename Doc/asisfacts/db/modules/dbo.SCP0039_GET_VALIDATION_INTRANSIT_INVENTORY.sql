
/*
 * Program ID   : SCP0039_GET_VALIDATION_INTRANSIT_INVENTORY
 * Description  : Plan Group 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/10	kh  			Initial Release [PXXXXXXXXX] 전지본부 자동차 GSCP  최적화 구축 프로젝트
 * 2025/08/14   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- plan_group/line assign 참조시 scp plan operation으로 공정 참조 범위 제한
 * 2025/08/26   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- plan_group_info 임시테이블 추가 사용 
 * 2025/09/12   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- 소형/ESS plan group 매핑 로직 자동차와 동일하게 적용
 * 
 */
 
CREATE PROCEDURE [dbo].[SCP0039_GET_VALIDATION_INTRANSIT_INVENTORY]  
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

### Intransit Invetory 요구사항 

※ 조회되는 정보는 조회되는주 일요일 CUT-OFF된 재고로 제한
※ DEMAND GROUPING 고려해야함.

1) INTRANST INV에 모델 및 TO SITE 정보를 기반으로 
 >> DP에 해당 SALES SITE정보 없는 경우
 ** 고객위탁 정보도 활용해야함 (SO RESERVED)

2) INTRANST INV에 모델, TO SITE, INCOTERMS 정보를 기반으로
 >>  DP에 해당 SALES SITE의 INCOTERMS 가 없는 경우

3) INTRANST INV 도착예상 일자정보를 기반으로
 >> 금주 월요일이 1주일이상 지연 경우

--================================================================================================================================

*/

 	-- 파라미터로 받을 값 변수  
	DECLARE @v_division_id			NVARCHAR(30)	= @p_division_id
	DECLARE @v_plan_group_id		NVARCHAR(30)	= @p_plan_group_id

	-- 참조 기간 및 기준일자 정보 변수
	DECLARE @v_from_yyyymmdd		NVARCHAR(8)		= NULL	-- 당주 월요일 (plan_start_yyyymmdd) 
	DECLARE @v_to_yyyymmdd			NVARCHAR(8)		= NULL	-- horizon_end_date ?
	DECLARE @V_LAST_SUNDAY			NVARCHAR(8)		= NULL	-- 재고 기준 일자  

	-- DM 참조를 위한 변수
	DECLARE @V_DM_CUTOFF_YYYYMMDD	NVARCHAR(8)		= NULL
	DECLARE @V_DM_VERSION_NO		NVARCHAR(50)	= NULL;

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

	-- 마지막 일요일 (재고 참조 기준일자) 
	SET @V_LAST_SUNDAY =  CONVERT(NVARCHAR(8), DATEADD(DAY, -1, CAST(@v_from_yyyymmdd AS DATE)), 112) 

	---------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' DM Cutoff YYYYMMDD / 버전 정보 ' 
	---------------------------------------------------------------------------------------------------
	SELECT TOP 1
		   @V_DM_CUTOFF_YYYYMMDD = DP.CUTOFF_YYYYMMDD
		  ,@V_DM_VERSION_NO		 = DP.VERSION_NO
	 FROM  DM_PLN_NET_DEMAND DP WITH(NOLOCK)  -- DIVISION_ID, CUTOFF_YYYYMMDD (IDX01_DM_PLN_NET_DEMAND) 
		   INNER JOIN DM_MST_VERSION  DV WITH(NOLOCK) -- DIVISION_ID, VERSION_NO
				   ON DV.DIVISION_ID	= DP.DIVISION_ID 
				  AND DV.VERSION_NO		= DP.VERSION_NO
				  AND DV.VERSION_TYPE	= 'MF_W'
	WHERE  DP.DIVISION_ID      = @V_DIVISION_ID 
	ORDER BY DP.CUTOFF_YYYYMMDD DESC
			,DP.VERSION_NO		DESC 
	
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
	PRINT '@v_division_id			= ' + @v_division_id;
	PRINT '@v_from_yyyymmdd			= ' + @v_from_yyyymmdd;	--- plan start yyyymmdd 
	PRINT '@v_to_yyyymmdd			= ' + @v_to_yyyymmdd;
	PRINT '@V_LAST_SUNDAY			= ' + @V_LAST_SUNDAY;
	PRINT '@V_DM_CUTOFF_YYYYMMDD	= ' + @V_DM_CUTOFF_YYYYMMDD;
	PRINT '@V_DM_VERSION_NO			= ' + @V_DM_VERSION_NO;
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
	 FROM #PLAN_GROUP_LINE GL
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
	print  convert(varchar(30), getdate(), 121) + N' Intransit Inventory ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#INTRANSIT_INVENTORY') IS NOT NULL DROP TABLE #INTRANSIT_INVENTORY
	SELECT  
			ISNULL(GD.GROUP_ID, 'NONE')				AS GROUP_ID
		   ,GM.GROUP_NAME
		   ,FI.NICK_NAME 
		   ,IV.RESULT_DATE
		   ,IV.RESULT_TYPE
		   ,IV.DIVISION_ID 
		   ,IV.COMPANY_ID
		   ,IV.PLANT_ID
		   ,IV.SHIPMENT_NO
		   ,IV.PROJECT_CODE
		   ,IV.ITEM_ID
		   ,IV.PLANT_ISSUE_DATE
		   ,IV.INCOTERMS							AS INCOTERMS_ORG
		   ,ISNULL(IV.FINAL_INCOTERMS,IV.INCOTERMS) AS INCOTERMS
		   ,IV.SHIPTO_CODE
		   ,IV.FROM_SCM_SITE_ID
		   ,IV.TO_SCM_SITE_ID
		   ,SS.SITE_DESCRIPTION						AS SALES_SITE_DESCRIPTION
		   ,IV.DELIVERY_QTY
		   ,IV.UOM
		   ,IV.TRANSPORT_MODE
		   ,IV.F_DEST_ETA_DATE
		   ,IV.F_DEST_ATA_DATE
	 INTO #INTRANSIT_INVENTORY
	 FROM SCM_DNM_INTRANSIT_C  IV  WITH(NOLOCK) -- RESULT_DATE, RESULT_TYPE, COMPANY_ID, DIVISION_ID, PLANT_ID, SHIPMENT_NO, PROJECT_CODE, ITEM_ID, PLANT_ISSUE_DATE, INCOTERMS, FCST_TYPE
		  INNER JOIN SCM_MST_SITE SS WITH(NOLOCK)
				  ON SS.DIVISION_ID = IV.DIVISION_ID
				 AND SS.SCM_SITE_ID = IV.TO_SCM_SITE_ID
				 AND SS.SITE_TYPE	= 'SALES'
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON FI.DIVISION_ID	= IV.DIVISION_ID
				 AND FI.ITEM_ID		= IV.ITEM_ID 
		  LEFT  JOIN SCP_MST_ITEM_GROUP_DETAIL GD WITH(NOLOCK)   -- DIVISION_ID, PROJECT_CODE, ITEM_ID 
				  ON GD.DIVISION_ID	= IV.DIVISION_ID
				 AND GD.PROJECT_CODE= IV.PROJECT_CODE
				 AND GD.ITEM_ID		= IV.ITEM_ID
				 AND EXISTS (SELECT 'Y' 
							  FROM SCP_MST_ITEM_GROUP GM WITH(NOLOCK)
							 WHERE GM.DIVISION_ID	= GD.DIVISION_ID
							   AND GM.GROUP_ID		= GD.GROUP_ID 
							   AND GM.VALID_YN		= 'Y'
							   )
		  LEFT  JOIN SCP_MST_ITEM_GROUP GM WITH(NOLOCK)		-- DIVISION_ID, GROUP_ID 
				  ON GM.DIVISION_ID	= GD.DIVISION_ID
				 AND GM.GROUP_ID	= GD.GROUP_ID
	WHERE 1=1
	  AND IV.RESULT_DATE	= @V_LAST_SUNDAY
	  AND IV.RESULT_TYPE IN ('C', 'B', 'I')  -- C(법인간)/B(SO Reserved)/I(GTS)
	  AND IV.DIVISION_ID	= @v_division_id --  '81'

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Sales Site Inventory ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SALES_SITE_INVENTORY') IS NOT NULL DROP TABLE #SALES_SITE_INVENTORY
	SELECT --DISTINCT
		 DS.CUTOFF_DATE
		,DS.STOCK_TYPE
		,DS.COMPANY_ID
		,DS.DIVISION_ID
		,DS.PLANT_ID
		,FI.NICK_NAME
		,DS.ITEM_ID
		,CASE DS.STOCK_TYPE 
			  WHEN 'VMI' THEN DS.STORAGE_ID 
			  ELSE '' 
		 END					AS CUSTOMER_CODE
		,DS.SCM_SITE_ID
		,SS.SITE_DESCRIPTION	AS SALES_SITE_DESCRIPTION
		,DS.SCM_QTY
		,DS.QTY_UOM
	 INTO #SALES_SITE_INVENTORY
	 FROM SCM_DNM_STOCK DS WITH(NOLOCK) 
		  INNER JOIN SCM_MST_SITE SS WITH(NOLOCK)
				  ON SS.DIVISION_ID = DS.DIVISION_ID
				 AND SS.SCM_SITE_ID = DS.SCM_SITE_ID 
				 AND SS.SITE_TYPE	= 'SALES'
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON FI.DIVISION_ID = DS.DIVISION_ID
				 AND FI.ITEM_ID		= DS.ITEM_ID
	WHERE 1=1
	  AND DS.CUTOFF_DATE	= @V_LAST_SUNDAY 
	  AND DS.DIVISION_ID	= @v_division_id
	  AND DS.SCM_QTY > 0

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Demand Plan ' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#DEMAND_PLAN') IS NOT NULL DROP TABLE #DEMAND_PLAN

	SELECT ----- TOP 100000 
		   DP.DIVISION_ID
		  ,ISNULL(GM.GROUP_ID,'NONE')		AS GROUP_ID
		  ,GM.GROUP_NAME
		  ,DP.ITEM_ID
		  ,DP.SCM_SITE_ID
		  ,CASE WHEN SM.VMI_YN = 'Y'
				THEN 'DAP'
				ELSE DP.INCOTERMS
			END							AS INCOTERMS
		  ,DP.PROJECT_CODE
		  ,DP.CUTOFF_YYYYMMDD		
		  ,DP.QTY
		  ,ROW_NUMBER() OVER (PARTITION BY DP.DIVISION_ID
										  ,ISNULL(GD.ITEM_ID, DP.ITEM_ID)
										  ,DP.SCM_SITE_ID 
										  ,DP.PROJECT_CODE
						 		ORDER BY DP.QTY DESC )				AS RN_1
		  ,ROW_NUMBER() OVER (PARTITION BY DP.DIVISION_ID
										  ,ISNULL(GD.ITEM_ID, DP.ITEM_ID)
										  ,DP.SCM_SITE_ID 
										  ,DP.PROJECT_CODE
										  ,DP.INCOTERMS
								ORDER BY DP.QTY DESC )				AS RN_2
		  ,ROW_NUMBER() OVER (PARTITION BY DP.DIVISION_ID
										  ,ISNULL(GD.ITEM_ID, DP.ITEM_ID)
										  ,DP.SCM_SITE_ID 
						 		ORDER BY DP.QTY DESC )				AS RN_3 -- sales site 재고  확인용  
	 INTO #DEMAND_PLAN
	 FROM DM_PLN_NET_DEMAND DP WITH(NOLOCK)  -- DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, DEMAND_TYPE, YYYYMMDD, CELL_PROD_SITE_ID
		  INNER JOIN SCM_MST_SITE SM
	  			  ON SM.DIVISION_ID	= DP.DIVISION_ID
	  			 AND SM.SCM_SITE_ID	= DP.SCM_SITE_ID
		  LEFT  JOIN SCP_MST_ITEM_GROUP_DETAIL GD WITH(NOLOCK) -- DIVISION_ID, PROJECT_CODE, ITEM_ID
				  ON GD.DIVISION_ID	= DP.DIVISION_ID
				 AND GD.PROJECT_CODE= DP.PROJECT_CODE
				 AND GD.ITEM_ID		= DP.ITEM_ID
				 AND EXISTS (SELECT 'Y' 
							  FROM SCP_MST_ITEM_GROUP GM WITH(NOLOCK)
							 WHERE GM.DIVISION_ID	= GD.DIVISION_ID
							   AND GM.GROUP_ID		= GD.GROUP_ID 
							   AND GM.VALID_YN		= 'Y')
		  LEFT  JOIN SCP_MST_ITEM_GROUP GM WITH(NOLOCK)		-- DIVISION_ID, GROUP_ID 
				  ON GM.DIVISION_ID	= GD.DIVISION_ID
				 AND GM.GROUP_ID	= GD.GROUP_ID
	WHERE 1=1
	  AND DP.DIVISION_ID	 = @v_division_id -- '81'
	  AND DP.VERSION_NO		 = @V_DM_VERSION_NO
	  AND DP.CUTOFF_YYYYMMDD = @V_DM_CUTOFF_YYYYMMDD

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Intransit Inventory 확인 대상 Case 1  ' 
	/*
	1) INTRANST INV에 모델 및 TO SITE 정보를 기반으로 
	 >> DP에 해당 SALES SITE정보 없는 경우
	 ** 고객위탁 정보도 활용해야함 (SO RESERVED)
	*/
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#INT_TARGET_CASE_1') IS NOT NULL DROP TABLE #INT_TARGET_CASE_1
	SELECT *
	 INTO #INT_TARGET_CASE_1
	 FROM (
			SELECT IV.*
			 FROM #INTRANSIT_INVENTORY IV 
				  LEFT JOIN #DEMAND_PLAN DP
						 ON DP.DIVISION_ID	= IV.DIVISION_ID
						AND DP.ITEM_ID		= IV.ITEM_ID
						AND DP.SCM_SITE_ID	= IV.TO_SCM_SITE_ID
						AND DP.PROJECT_CODE	= CASE WHEN IV.PROJECT_CODE LIKE '000%' 
														OR IV.PROJECT_CODE = '-' 
														OR IV.PROJECT_CODE='TBD' 
														OR IV.PROJECT_CODE='' 
												   THEN DP.PROJECT_CODE 
												   ELSE IV.PROJECT_CODE 
											  END
						AND DP.RN_1			= 1 
			WHERE 1=1
			   AND DP.SCM_SITE_ID IS NULL 
			UNION ALL 
			SELECT NULL					AS GROUP_ID
				  ,NULL					AS GROUP_NAME
				  ,SI.NICK_NAME	
				  ,SI.CUTOFF_DATE		AS RESULT_DATE
				  ,SI.STOCK_TYPE		AS RESULT_TYPE
				  ,SI.DIVISION_ID
				  ,NULL					AS COMPANY_ID
				  ,NULL					AS PLANT_ID
				  ,NULL					AS SHIPMENT_NO
				  ,NULL					AS PROJECT_CODE
				  ,SI.ITEM_ID
				  ,NULL					AS PLANT_ISSUE_DATE
				  ,NULL					AS INCOTERMS_ORG
				  ,NULL					AS INCOTERMS
				  ,NULL					AS SHIPTO_CODE
				  ,NULL					AS FROM_SCM_SITE_ID
				  ,SI.SCM_SITE_ID		AS TO_SCM_SITE_ID
				  ,SI.SALES_SITE_DESCRIPTION
				  ,SI.SCM_QTY			AS DELIVERY_QTY
				  ,SI.QTY_UOM			AS UOM
				  ,NULL					AS TRANSPORT_MODE
				  ,NULL					AS F_DEST_ETA_DATE
				  ,NULL					AS F_DEST_ATA_DATE
			 FROM #SALES_SITE_INVENTORY SI 
				  LEFT JOIN #DEMAND_PLAN DP
						 ON DP.DIVISION_ID	= SI.DIVISION_ID
						AND DP.ITEM_ID		= SI.ITEM_ID
						AND DP.SCM_SITE_ID	= SI.SCM_SITE_ID
						AND DP.RN_3			= 1 
			WHERE 1=1
			  AND DP.SCM_SITE_ID IS NULL 
		) TG 
	WHERE 1=1

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Intransit Inventory 확인 대상 Case 2  '
	/*
	2) INTRANST INV에 모델, TO SITE, INCOTERMS 정보를 기반으로
	 >>  DP에 해당 SALES SITE의 INCOTERMS 가 없는 경우
	*/
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#INT_TARGET_CASE_2') IS NOT NULL DROP TABLE #INT_TARGET_CASE_2
	SELECT IV.*
	 INTO #INT_TARGET_CASE_2 
	 FROM #INTRANSIT_INVENTORY IV 
		  LEFT JOIN #DEMAND_PLAN DP
				 ON DP.DIVISION_ID	= IV.DIVISION_ID
				AND DP.ITEM_ID		= IV.ITEM_ID
				AND DP.SCM_SITE_ID	= IV.TO_SCM_SITE_ID
				AND DP.PROJECT_CODE	= CASE WHEN IV.PROJECT_CODE LIKE '000%' 
												OR IV.PROJECT_CODE = '-' 
												OR IV.PROJECT_CODE='TBD' 
												OR IV.PROJECT_CODE='' 
										   THEN DP.PROJECT_CODE 
										   ELSE IV.PROJECT_CODE 
									  END
				AND DP.INCOTERMS	= IV.INCOTERMS
				AND DP.RN_2			= 1 
	WHERE 1=1
	  AND DP.SCM_SITE_ID IS NULL 
	  AND NOT EXISTS (SELECT 'Y'
						FROM #INT_TARGET_CASE_1 TC 
					   WHERE TC.DIVISION_ID		= IV.DIVISION_ID
						 AND TC.ITEM_ID			= IV.ITEM_ID
						 AND TC.TO_SCM_SITE_ID	= IV.TO_SCM_SITE_ID
						 AND TC.PROJECT_CODE	= IV.PROJECT_CODE) 


	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Intransit Inventory 확인 대상 Case 3  '
	/*
	3) INTRANST INV 도착예상 일자정보를 기반으로
	 >> 금주 월요일이 1주일이상 지연 경우
	 */
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#INT_TARGET_CASE_3') IS NOT NULL DROP TABLE #INT_TARGET_CASE_3
	SELECT
	       IV.* 
	 INTO #INT_TARGET_CASE_3
	 FROM #INTRANSIT_INVENTORY IV 
	WHERE 1=1
	  AND F_DEST_ETA_DATE IS NOT NULL	-- 도착예정일 
	  AND DATEDIFF(DAY ,CAST(F_DEST_ETA_DATE AS DATE) ,CAST(@v_from_yyyymmdd AS DATE)) > 7 
	  AND F_DEST_ATA_DATE IS NULL		-- 실제도착일(미착)

-- #######################################-- #######################################-- #######################################-- #######################################
-- #######################################-- #######################################-- #######################################-- #######################################

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 확인 대상 전체 데이터   '  ----##################################
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TARGET_DATA') IS NOT NULL DROP TABLE #TARGET_DATA
	SELECT TG.*
	 INTO #TARGET_DATA
	FROM ( 
			SELECT 'INT01'			AS MASTER_INVLD_CD
				  ,TC.*
			 FROM #INT_TARGET_CASE_1 TC
			UNION ALL 
			SELECT 'INT02'			AS MASTER_INVLD_CD
				  ,TC.*
			 FROM #INT_TARGET_CASE_2 TC
			UNION ALL 
			SELECT 'INT03'			AS MASTER_INVLD_CD
				  ,TC.*
			 FROM #INT_TARGET_CASE_3 TC
		) TG
	WHERE 1=1 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 확인 대상 전체 데이터 - Basic Cell Nickname 매핑  '  ----########
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TARGET_DATA_BC_NICK_NAME') IS NOT NULL DROP TABLE #TARGET_DATA_BC_NICK_NAME
	SELECT BI.BASIC_NICK_NAME		AS BASIC_CELL_NICK_NAME 
		  ,TD.* 
	 INTO #TARGET_DATA_BC_NICK_NAME
	 FROM #TARGET_DATA TD   
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON FI.DIVISION_ID = TD.DIVISION_ID
				 AND FI.ITEM_ID		= TD.ITEM_ID
		  LEFT  JOIN SCP_MST_ITEM_BSI_IFO BI WITH(NOLOCK)
				  ON BI.ITEM_ID		= CASE WHEN FI.OPERATION_GROUP = 'P'	THEN FI.ATTRIBUTE1
										   ELSE TD.ITEM_ID
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
		  ,TD.*
	 INTO #TARGET_DATA_PLAN_GROUP
	 FROM #TARGET_DATA_BC_NICK_NAME TD 
		  LEFT JOIN #PLAN_GROUP_INFO PG	-- item_id로 매핑 
				 ON PG.DIVISION_ID	= TD.DIVISION_ID
				AND PG.ITEM_ID		= TD.ITEM_ID
				AND PG.RN			= 1 
		  LEFT JOIN #PLAN_GROUP_INFO PG_NICK	-- basic cell nick name으로 매핑 
				 ON PG_NICK.DIVISION_ID		= TD.DIVISION_ID
				AND PG_NICK.BASIC_NICK_NAME	= TD.BASIC_CELL_NICK_NAME
				AND PG_NICK.RN_NICK			= 1 
	WHERE 1=1

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
		  ,ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
										  ,B.FROM_SITE
										  ,B.TO_SITE
										  ,B.INCOTERMS
										  ,D.TRANSPORT_MODE
								  ORDER BY B.VALID_YN DESC
									      ,D.VALID_YN DESC
										  ,B.PRIORITY
										  ,D.PRIORITY
										  ,B.BOD_ID DESC )	AS RN 
	  INTO #BOD
	  FROM SCP_MST_BOD B WITH(NOLOCK)
		   INNER JOIN SCP_MST_DISTRIBUTION_ROUTE D WITH(NOLOCK)
				   ON D.ROUTE_ID = B.ROUTE_ID
	 WHERE 1=1
	   AND B.ATTRIBUTE3 >= @V_FROM_YYYYMMDD 

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 전체 확인 필요 대상 조회' -- ####################################
	------------------------------------------------------------------------------------------------------------------
	SELECT 
		   TD.DIVISION_ID
		  ,TD.ITEM_ID				
		  ,TD.NICK_NAME
		  ,TD.BASIC_CELL_NICK_NAME
		  ,CASE WHEN TD.DV IN ('A', 'B')				THEN CONCAT(TD.OPMZ_PLAN_GR_NAME, '')
				WHEN TD.BASIC_CELL_NICK_NAME IS NULL	THEN '-'
				ELSE CONCAT(TD.BASIC_CELL_NICK_NAME, N' (예상)') 
		    END								AS PLAN_GROUP
		  ,ISNULL(TD.OPMZ_PLAN_GR_ID,'-')	AS OPMZ_PLAN_GR_ID 
		  ,TD.DV
		  ,TD.MASTER_INVLD_CD
		  ,LK.ATTRIBUTE2					AS MASTER_INVLD_MSG
		  ,TD.FROM_SCM_SITE_ID				AS PLANT_SITE
		  ,TD.TO_SCM_SITE_ID				AS SALES_SITE
		  ,TD.INCOTERMS
		  ,TD.SHIPMENT_NO
		  ,TD.RESULT_TYPE
		  ,TD.DELIVERY_QTY
		  ,CONVERT(DATE, TD.PLANT_ISSUE_DATE, 112)				AS EXFACTORY_DATE 			-- 출하일자?
		  ,CONVERT(DATE, TD.F_DEST_ETA_DATE, 112)				AS F_DEST_ETA_DATE			-- 도착예정일
		  ,TD.F_DEST_ATA_DATE																-- 실제도착일
		  ,TD.TRANSPORT_MODE 
		  ,BD.BOD_ID
		  ,@v_from_yyyymmdd					AS PLAN_START_YYYYMMDD 
		  ,@V_DM_CUTOFF_YYYYMMDD			AS DM_CUTOFF_YYYYMMDD
		  ,@V_DM_VERSION_NO					AS DM_VERSION_NO
	 FROM #TARGET_DATA_PLAN_GROUP TD
		  LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
				  ON LK.LOOKUP_TYPE		= 'MASTER_INVLD_CD'
				 AND LK.SEGMENT1		= TD.MASTER_INVLD_CD
				 AND LK.VALID_YN		= 'Y'
		  LEFT  JOIN #BOD BD
				  ON BD.DIVISION_ID		= TD.DIVISION_ID
				 AND BD.FROM_SITE		= TD.FROM_SCM_SITE_ID
				 AND BD.TO_SITE			= TD.TO_SCM_SITE_ID
				 AND BD.INCOTERMS		= TD.INCOTERMS
				 AND BD.TRANSPORT_MODE	= TD.TRANSPORT_MODE
		 INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
				 ON TD.ITEM_ID  like  b.tst 
				 OR TD.NICK_NAME like  b.tst  					 
	WHERE 1=1 
    AND ( ( @p_plan_group_id IS NULL OR  @p_plan_group_id = '' ) OR TD.OPMZ_plan_gr_id IN (SELECT token FROM dbo.String_Split(@p_plan_group_id  ,',')) )
	ORDER BY TD.MASTER_INVLD_CD, 1,2,3,4,5,6 

END






