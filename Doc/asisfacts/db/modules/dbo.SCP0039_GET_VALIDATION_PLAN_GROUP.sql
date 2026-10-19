
/*
 * Program ID   : SCP0039_GET_VALIDATION_PLAN_GROUP
 * Description  : Plan Group 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/10	kh  			Initial Release  PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축
 * 2025/08/14   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- MKT FCST 최종 수정일시 정보 추가
 *										- line assign 참조시 scp plan operation으로 공정 참조 범위 제한
 *										- plan group 매핑이 안된 데이터만 조회 
 * 2025/08/26   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- plan_group_info 임시테이블 추가 사용 
 * 2025/09/05   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- MKT_FCST 참조시 to AS Sales 사이트 제외 (AS_SITE_PLANT) 
 * 2025/09/12   hrkim           PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *										- 소형/ESS plan group 매핑 로직 자동차와 동일하게 적용
 * 
 */
 
CREATE PROCEDURE [dbo].[SCP0039_GET_VALIDATION_PLAN_GROUP]  
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
### Plan Group  요구사항  

1) CURRENT MKT FCST DP에 입력되어 있는 '모델' 정보를 기반으로
 >> 해당 모델의 Plan Group이 설정되어 있지 않은 경우

※1. Plan Group 입력 영향을 받지 않고 모두 조회함
※2. 81 like division은 기입력된 plan group 의 모델정보를 활용하여 수요의 모델을 엮을것.
    : 로직은 left 12 / distinct
※3. 2번로직으로 찾은 모델은 PLAN GROUP에 '(예상)' 추가하여 송출함

* 40 / 82 는 최적화 확장시에 논의하여 결정필요..
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
	SELECT MK.DIVISION_ID
		  ,MK.SCM_SITE_ID		AS SALES_SITE_ID	
		  ,MK.PROJECT_CODE		AS PROJECT_CODE	
		  ,MK.ITEM_ID			AS SALES_ITEM_ID
		  ,MK.INCOTERMS
		  ,LEFT(FI.FLOW_ID,5)	AS MODEL_OPERATION_ID
		  ,FI.OPERATION_GROUP	AS MODEL_OPERATION_GROUP
		  ,FI.NICK_NAME			AS MODEL_NICK_NAME
		  ,BI.BASIC_NICK_NAME	AS BASIC_CELL_NICK_NAME 
		  ,MIN(MK.YYYYMMDD)		AS SALES_FROM_YYYYMMDD
		  ,MAX(MK.YYYYMMDD)		AS SALES_TO_YYYYMMDD
		  ,SUM(MK.QTY)			AS QTY
		  ,CONVERT(NVARCHAR(50), MAX(MK.LAST_UPDATE_DATE), 120)	AS MF_LAST_UPDATE_DATE	-- 2025.08.14 추가
	 INTO #MKT_FCST 
	 FROM DM_PLN_MKT_FCST MK WITH(NOLOCK)    -- DIVISION_ID, MEASURE, YYYYMMDD
		  INNER JOIN SCM_MST_SITE WS WITH(NOLOCK) 
				  ON WS.DIVISION_ID		=	MK.DIVISION_ID 
				 AND WS.SCM_SITE_ID		=	MK.SCM_SITE_ID 
		  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
				  ON FI.DIVISION_ID		= MK.DIVISION_ID
				 AND FI.ITEM_ID			= MK.ITEM_ID 
		  LEFT  JOIN SCP_MST_ITEM_BSI_IFO DE WITH(NOLOCK)   -- Doe model
		  		  ON DE.ITEM_ID			= MK.ITEM_ID
		  LEFT  JOIN SCP_MST_FINAL_ITEM DF WITH(NOLOCK)
				  ON DF.DIVISION_ID		= MK.DIVISION_ID
				 AND DF.ITEM_ID			= DE.APPLIED_DOE
		  LEFT  JOIN SCP_MST_ITEM_BSI_IFO BI WITH(NOLOCK)   -- Cell Model 기준 Basic nick name 참조 
				  ON BI.ITEM_ID		= CASE WHEN FI.OPERATION_GROUP = 'P'
										   THEN ISNULL(FI.ATTRIBUTE1, DF.ATTRIBUTE1) 
										   ELSE MK.ITEM_ID -- sales_item_id 
									  END 
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
	GROUP BY MK.DIVISION_ID
			,MK.SCM_SITE_ID
			,MK.PROJECT_CODE
		    ,MK.ITEM_ID		
			,MK.INCOTERMS	
			,FI.FLOW_ID		
			,FI.OPERATION_GROUP 
			,FI.NICK_NAME
			,BI.BASIC_NICK_NAME

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
	print  convert(varchar(30), getdate(), 121) + N' MKT FCST Plan group 매핑' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#MKT_FCST_PLAN_GROUP') IS NOT NULL DROP TABLE #MKT_FCST_PLAN_GROUP
	SELECT ISNULL(PG.OPMZ_PLAN_GR_ID	,PG_NICK.OPMZ_PLAN_GR_ID	)	AS OPMZ_PLAN_GR_ID	
		  ,ISNULL(PG.OPMZ_PLAN_GR_NAME	,PG_NICK.OPMZ_PLAN_GR_NAME	)	AS OPMZ_PLAN_GR_NAME	
		  ,ISNULL(PG.LINE_ID			,PG_NICK.LINE_ID			)	AS LINE_ID			
		  ,ISNULL(PG.BASIC_NICK_NAME 	,PG_NICK.BASIC_NICK_NAME 	)	AS BASIC_NICK_NAME 	
		  ,CASE WHEN PG.LINE_ID IS NOT NULL			THEN 'A'	-- item id mapping 
				WHEN PG_NICK.LINE_ID IS NOT NULL	THEN 'B'	-- basic cell nick name mapping 
				ELSE 'Z'
			END															AS DV 
		  ,MK.BASIC_CELL_NICK_NAME
		  ,MK.DIVISION_ID
		  ,MK.SALES_SITE_ID
		  ,MK.PROJECT_CODE
		  ,MK.SALES_ITEM_ID
		  ,MK.INCOTERMS
		  ,MK.MODEL_OPERATION_ID
		  ,MK.MODEL_OPERATION_GROUP
		  ,MK.MODEL_NICK_NAME
		  ,MK.SALES_FROM_YYYYMMDD
		  ,MK.SALES_TO_YYYYMMDD
		  ,MK.QTY
		  ,MK.MF_LAST_UPDATE_DATE
	 INTO #MKT_FCST_PLAN_GROUP
	 FROM #MKT_FCST MK
		  LEFT JOIN #PLAN_GROUP_INFO PG	-- item_id로 매핑 
				 ON PG.DIVISION_ID	= MK.DIVISION_ID
				AND PG.ITEM_ID		= MK.SALES_ITEM_ID
				AND PG.RN			= 1 
		  LEFT JOIN #PLAN_GROUP_INFO PG_NICK	-- basic cell nick name으로 매핑 
				 ON PG_NICK.DIVISION_ID		= MK.DIVISION_ID
				AND PG_NICK.BASIC_NICK_NAME	= MK.BASIC_CELL_NICK_NAME
				AND PG_NICK.RN_NICK			= 1 
	WHERE 1=1
	 -- AND PG.OPMZ_PLAN_GR_ID IS NOT NULL 
	ORDER BY 1, 2 


-- #######################################-- #######################################-- #######################################-- #######################################
-- #######################################-- #######################################-- #######################################-- #######################################

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' 최종 확인 필요 대상 조회   ' -- #################################
	------------------------------------------------------------------------------------------------------------------
	--- Project Route 미등록 
	SELECT MG.DIVISION_ID
		  ,MG.SALES_ITEM_ID					AS ITEM_ID
		  ,MG.MODEL_NICK_NAME				AS NICK_NAME
		  ,CASE WHEN MG.DV IN ('A', 'B')				THEN CONCAT(MG.OPMZ_PLAN_GR_NAME, '')	-- , ' (', MG.OPMZ_PLAN_GR_ID, ')') 
				WHEN MG.BASIC_CELL_NICK_NAME IS NULL	THEN '-'
				ELSE CONCAT(MG.BASIC_CELL_NICK_NAME, N' (예상)') 
		    END								AS PLAN_GROUP
		  ,ISNULL(MG.OPMZ_PLAN_GR_ID,'-')	AS OPMZ_PLAN_GR_ID 
		  ,MG.DV							AS PLAN_GROUP_MAPPING_DV 
		  ,LK.SEGMENT1						AS MASTER_INVLD_CD
		  ,LK.ATTRIBUTE2					AS MASTER_INVLD_MSG
		  ,SS.SITE_DESCRIPTION				AS SALES_PLANT_SITE
		  ,MG.PROJECT_CODE					AS PROJECT_OPERATION
		  ,MG.INCOTERMS						AS INCOERMS_LINE
		  ,MG.QTY
		  ,CONCAT(N'Sales기간:', MG.SALES_FROM_YYYYMMDD, '~', MG.SALES_TO_YYYYMMDD, ', FCST Last Update :',MG.MF_LAST_UPDATE_DATE, ', Sales Site:', MG.SALES_SITE_ID,  '')	AS MASTER_INVLD_CTN  -- 2025.08.14 수요 최종 변경일 추가 
	 FROM #MKT_FCST_PLAN_GROUP MG
		  INNER JOIN SCM_MST_SITE SS WITH(NOLOCK)
				  ON SS.DIVISION_ID		= @v_division_id
				 AND SS.SCM_SITE_ID		= MG.SALES_SITE_ID
		  LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
				  ON LK.LOOKUP_TYPE		= 'MASTER_INVLD_CD'
				 AND LK.SEGMENT1		= 'PG001'
				 AND LK.VALID_YN		= 'Y'
				 AND ISNULL(MG.OPMZ_PLAN_GR_ID,'-') = '-'
         INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
                 ON MG.SALES_ITEM_ID   like  b.tst 
                 OR MG.MODEL_NICK_NAME like  b.tst  	
	WHERE 1=1
	  AND ISNULL(MG.OPMZ_PLAN_GR_ID,'-') = '-'  -- 2025.08.14 plan group 매핑이 안되는 데이터만 조회 
     -- AND ( ( @p_plan_group_id IS NULL OR  @p_plan_group_id = '' ) OR MG.OPMZ_plan_gr_id IN (SELECT token FROM dbo.String_Split(@p_plan_group_id  ,',')) )
	ORDER BY MG.DIVISION_ID
			,CASE WHEN MG.DV IN ('A', 'B')				THEN CONCAT(MG.OPMZ_PLAN_GR_NAME, '')	-- , ' (', MG.OPMZ_PLAN_GR_ID, ')') 
				  WHEN MG.BASIC_CELL_NICK_NAME IS NULL	THEN '-'
				  ELSE CONCAT(MG.BASIC_CELL_NICK_NAME, N' (예상)') 
		     END	
			,MG.MODEL_OPERATION_GROUP
			,MG.MODEL_NICK_NAME
			,MG.SALES_ITEM_ID
END






