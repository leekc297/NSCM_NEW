
/*
 * Program ID   : SCP0039_GET_VALIDATION_YIELD
 * Description  : 수율 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/10	kh  			Initial Release  PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축
 * 2025/08/14   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- plan_group/line assign 참조시 scp plan operation으로 공정 참조 범위 제한
 * 2025/08/26   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *									-- SCP 완성공정 조건 하드코딩 lookup 데이터 참조로 변경 
 * 2025/09/12   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- 소형/ESS plan group 매핑 로직 자동차와 동일하게 적용
 * 
 */
 
CREATE PROCEDURE [dbo].[SCP0039_GET_VALIDATION_YIELD]  
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
### 수율 요구사항 
------------------------------------------------------------------------------
1) CURRENT CAPA 입력되어 있는 'LINE', '모델' 정보를 기반으로
 >> E2000, A9000, P5500, P9500 공정의 수율이 50% 미만인경우

2) CURRENT FORMATION 입력되어 있는 'LINE', '모델' 정보를 기반으로
  >> 활성화/특성 공정의 수율이 50% 미만인경우"	

### 메시지   
------------------------------------------------------------------------------
1) CAPA 수율이 50%미만으로 낮습니다. 확인필요합니다.
2) FORMATION 수율이 50%미만으로 낮습니다. 확인필요합니다."

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

	------------------------------------------------------------------------------------
	-- [PJ20257329] 2025.08.26 SCP 완성 공정 하드 코딩 변경 (임시 테이블)
	print  convert(varchar(30), getdate(), 121) + N' SCP 완성 공정 하드 코딩 변경' 
	------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCP_FINAL_OPERATION') IS NOT NULL DROP TABLE #SCP_FINAL_OPERATION;
	SELECT DISTINCT
		   LK.SEGMENT1		AS OPERATION_ID
	  INTO #SCP_FINAL_OPERATION
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	   AND LK.ATTRIBUTE1  = 'Y'			-- Final Operation
	------------------------------------------------------------------------------------

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
	print  convert(varchar(30), getdate(), 121) + N' 확인 대상 전체 데이터   '  ----##################################
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TARGET_DATA') IS NOT NULL DROP TABLE #TARGET_DATA
	SELECT TG.*
	 INTO #TARGET_DATA
	 FROM ( 
			/*
			 1) CURRENT CAPA 입력되어 있는 'LINE', '모델' 정보를 기반으로
			 >> E2000, A9000, P5500, P9500 공정의 수율이 50% 미만인경우
			*/
			SELECT YM.DIVISION_ID
				  ,YM.ITEM_ID				AS MODEL_ID
				  ,FI.NICK_NAME
				  ,'YLD01'					AS MASTER_INVLD_CD
				  ,PS.SITE_DESCRIPTION		AS SALES_PLANT_SITE
				  ,YM.OPERATION_ID			AS PROJECT_OPERATION
				  ,YM.LINE_ID				AS INCOTERMS_LINE
				  ,YM.YIELD
				  ,'CAPA'					AS FROM_UI
				  ,CONCAT('Min/Max Month : ', MIN(YM.MONTH), '/', MAX(YM.MONTH))		AS MASTER_INVLD_CTN
			 FROM SCM_MST_YIELD_SN YM WITH(NOLOCK)  -- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, MONTH 
				  INNER JOIN SCM_MST_SITE PS WITH(NOLOCK)
						  ON PS.DIVISION_ID		= YM.DIVISION_ID
						 AND PS.PLANT_ID		= YM.PLANT_ID
						 AND PS.OPERATION_GROUP	= LEFT(YM.OPERATION_ID, 1) 
						 AND PS.COMPANY_ID		= YM.COMPANY_ID
				  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
						  ON FI.DIVISION_ID		= YM.DIVISION_ID
						 AND FI.ITEM_ID			= YM.ITEM_ID
				-- PJ20257329 2025.08.26 완성 공정 하드 코딩 변경 -- start 
				  INNER JOIN #SCP_FINAL_OPERATION FO
						  ON FO.OPERATION_ID	= YM.OPERATION_ID
				-- PJ20257329 2025.08.26 완성 공정 하드 코딩 변경 -- end 
			WHERE 1=1
			  AND YM.DIVISION_ID	= @v_division_id
			  AND YM.MONTH		   >= left(@v_from_yyyymmdd, 6) 
			  AND ISNULL(YM.YIELD, 1) < 0.5
			GROUP BY YM.DIVISION_ID
				    ,YM.ITEM_ID				
				    ,FI.NICK_NAME
				    ,PS.SITE_DESCRIPTION	
				    ,YM.OPERATION_ID		
				    ,YM.LINE_ID				
				    ,YM.YIELD
					,PS.SCM_SITE_ID
			UNION ALL
			/*
			2) CURRENT FORMATION 입력되어 있는 'LINE', '모델' 정보를 기반으로
			  >> 활성화/특성 공정의 수율이 50% 미만인경우"	
			*/
			SELECT FY.DIVISION_ID
				  ,FY.ITEM_ID
				  ,FI.NICK_NAME
				  ,'YLD02'						AS MASTER_INVLD_CD
				  ,PS.SITE_DESCRIPTION			AS SALES_PLANT_SITE
				  ,NULL							AS PROJECT_OPERATION
				  ,NULL							AS INCOTERMS_LINE
				  ,ISNULL(FY.SSP_MODIFY_YIELD
					     ,FY.FORMATION_TOTAL_YIELD) AS YIELD
				  ,'FORMATION'					AS FROM_UI
				  ,CONCAT('FORMATION YIELD :'	, CONVERT(NVARCHAR(50), FY.FORMATION_YIELD)
						 ,'CHAR_YIELD :'		, CONVERT(NVARCHAR(50), FY.CHAR_YIELD)			
						 )						AS MASTER_INVLD_CTN  
			 FROM SCP_MST_FORMATION_V FY WITH(NOLOCK)	 --- DIVISION_ID, PLANT_SITE_ID, ITEM_ID
				  INNER JOIN SCM_MST_SITE PS WITH(NOLOCK)
						  ON PS.DIVISION_ID = FY.DIVISION_ID
						 AND PS.SCM_SITE_ID	= FY.PLANT_SITE_ID
				  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
						  ON FI.DIVISION_ID	= FY.DIVISION_ID
						 AND FI.ITEM_ID		= FY.ITEM_ID
			WHERE 1=1
			  AND FY.DIVISION_ID			= @v_division_id
			  AND ISNULL(FY.SSP_MODIFY_YIELD ,FY.FORMATION_TOTAL_YIELD) < 0.5 
		) TG 
	WHERE 1=1

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
		  ,TD.YIELD
		  ,TD.FROM_UI
		  ,TD.MASTER_INVLD_CTN
	 INTO #TARGET_DATA_BC_NICK_NAME
	 FROM #TARGET_DATA TD   
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON FI.DIVISION_ID = TD.DIVISION_ID
				 AND FI.ITEM_ID		= TD.MODEL_ID
		  LEFT  JOIN #ELEC_APPLIED_MODEL EA
				  ON EA.DIVISION_ID = TD.DIVISION_ID
				 AND EA.ITEM_ID		= TD.MODEL_ID 
		  LEFT  JOIN SCP_MST_ITEM_BSI_IFO BI WITH(NOLOCK)
				  ON BI.ITEM_ID		= CASE WHEN FI.OPERATION_GROUP = 'E'	THEN EA.APPLIED_MODEL
										   WHEN FI.OPERATION_GROUP = 'P'	THEN FI.ATTRIBUTE1
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
		  ,TD.YIELD
		  ,TD.FROM_UI
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
	SELECT 
		   TD.DIVISION_ID
		  ,TD.MODEL_ID    AS ITEM_ID
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
		  ,TD.YIELD
		  ,TD.FROM_UI
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
      AND TD.YIELD <>0
      AND ( ( @p_plan_group_id IS NULL OR  @p_plan_group_id = '' ) OR TD.OPMZ_PLAN_GR_ID IN (SELECT token FROM dbo.String_Split(@p_plan_group_id  ,',')) )
	ORDER BY MASTER_INVLD_CD, 1,2,3,4,5,6 

END






