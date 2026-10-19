
/*
 * Program ID   : SCP0039_GET_VALIDATION_STOCK_OSP
 * Description  : Stock OSP 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/10	kh  			Initial Release  PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축
 * 
 */
 
CREATE PROCEDURE [dbo].[SCP0039_GET_VALIDATION_STOCK_OSP]  
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
### Stock OSP 요구사항  

1) 협력사별 자료 업로드 여부 (DIVISION PLANT(패커사별)별)
--================================================================================================================================

*/

-- 파라미터로 받을 값 변수  
DECLARE @v_division_id			NVARCHAR(30)	= @p_division_id
DECLARE @v_plan_group_id		NVARCHAR(30)	= @p_plan_group_id


	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' UPLOAD 재고 기준 일자 - 일요일' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#TARGET_SUNDAY') IS NOT NULL DROP TABLE #TARGET_SUNDAY

	SELECT YYYYMMDD
		  ,CONCAT('D_',YYYYMMDD) AS D_YYYYMMDD 
		  ,ROW_NUMBER()	OVER (PARTITION BY 'A' ORDER BY YYYYMMDD DESC) AS YMD_SEQ 
	 INTO #TARGET_SUNDAY
	 FROM SCM_MST_BUCKET WITH(NOLOCK) 
	WHERE 1=1
	  AND YYYYMMDD BETWEEN CONVERT(VARCHAR(8), DATEADD(DAY, -45, GETDATE()), 112)
					   AND CONVERT(VARCHAR(8), GETDATE(), 112) 
	  AND DAYOFWEEK = 'SUN'

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N' Packer Site' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#PACKER_SITE_INFO') IS NOT NULL DROP TABLE #PACKER_SITE_INFO
	SELECT OS.DIVISION_ID
		 , OS.SCM_SITE_ID
		 , OS.SITE_DESCRIPTION
		 , OS.ATTRIBUTE1
		 , OS.ATTRIBUTE2
		 , TS.YYYYMMDD
		 , TS.D_YYYYMMDD
		 , TS.YMD_SEQ 
	 INTO #PACKER_SITE_INFO
	 FROM SCM_MST_SITE OS WITH(NOLOCK)
		  INNER JOIN #TARGET_SUNDAY TS
				  ON 1=1
	WHERE 1=1
	  AND OS.DIVISION_ID	= @v_division_id 
	  AND OS.OSP_YN			= 'Y'
	  AND OS.VALID_YN		= 'Y'

	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N'Packer별 Upload Item 건수' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#PACKER_UPLOAD_ITEM_CNT') IS NOT NULL DROP TABLE #PACKER_UPLOAD_ITEM_CNT
	SELECT PS.DIVISION_ID
		 , PS.SCM_SITE_ID
		 , PS.SITE_DESCRIPTION
		 , MAX  (CASE WHEN PS.YMD_SEQ = 1		   THEN PS.YYYYMMDD		ELSE NULL END)		AS W0
		 , ISNULL(MAX  (DISTINCT CASE WHEN PS.YMD_SEQ = 1 
									  THEN CONVERT(NVARCHAR(50), SO.LAST_UPDATE_DATE, 120) 
									  ELSE NULL 
								  END), N'미입력')											AS W0_LAST_UPDATE_DATE
		 -- , MAX(CASE WHEN PS.YMD_SEQ = 2 THEN PS.YYYYMMDD ELSE NULL END)						AS "W-1"
		 -- , MAX(CASE WHEN PS.YMD_SEQ = 3 THEN PS.YYYYMMDD ELSE NULL END)						AS "W-2"
		 -- , MAX(CASE WHEN PS.YMD_SEQ = 4 THEN PS.YYYYMMDD ELSE NULL END)						AS "W-3"
		 -- , MAX(CASE WHEN PS.YMD_SEQ = 5 THEN PS.YYYYMMDD ELSE NULL END)						AS "W-4"
		 , COUNT(DISTINCT CASE WHEN PS.YMD_SEQ = 1 THEN SO.ITEM_ID			ELSE NULL END)	AS W0_ITEM_COUNT
		 , COUNT(DISTINCT CASE WHEN PS.YMD_SEQ = 2 THEN SO.ITEM_ID			ELSE NULL END)	AS "W-1_ITEM_COUNT"
		 , COUNT(DISTINCT CASE WHEN PS.YMD_SEQ = 3 THEN SO.ITEM_ID			ELSE NULL END)	AS "W-2_ITEM_COUNT"
		 , COUNT(DISTINCT CASE WHEN PS.YMD_SEQ = 4 THEN SO.ITEM_ID			ELSE NULL END)	AS "W-3_ITEM_COUNT"
		 , COUNT(DISTINCT CASE WHEN PS.YMD_SEQ = 5 THEN SO.ITEM_ID			ELSE NULL END)	AS "W-4_ITEM_COUNT"
		 , CASE WHEN COUNT(DISTINCT CASE WHEN PS.YMD_SEQ = 1 THEN SO.ITEM_ID ELSE NULL END) = 0 
				THEN 'SP001'
				ELSE NULL
		    END																				AS MASTER_INVLD_CD
		 -- , LK.ATTRIBUTE2																	AS MASTER_INVLD_MSG
	 INTO #PACKER_UPLOAD_ITEM_CNT
	 FROM #PACKER_SITE_INFO PS
		  LEFT JOIN SCM_DNM_STOCK_OSP SO WITH(NOLOCK)  -- DIVISION_ID, SCM_SITE_ID, ITEM_ID, YYYYMMDD, ATTRIBUTE1, ATTRIBUTE2
				 ON SO.DIVISION_ID	= PS.DIVISION_ID
				AND SO.SCM_SITE_ID	= PS.SCM_SITE_ID
				AND SO.YYYYMMDD		= PS.YYYYMMDD
		  --LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
				--  ON LK.LOOKUP_TYPE		= 'MASTER_INVLD_CD'
				-- AND LK.SEGMENT1		= 'SP001'
				-- AND LK.VALID_YN		= 'Y'
	WHERE 1=1
	GROUP BY PS.DIVISION_ID
		   , PS.SCM_SITE_ID
		   , PS.SITE_DESCRIPTION
	ORDER BY PS.SITE_DESCRIPTION 


	------------------------------------------------------------------------------------------------------------------
	print  convert(varchar(30), getdate(), 121) + N'최종 결과 조회' 
	------------------------------------------------------------------------------------------------------------------
	SELECT PS.*
		 , LK.ATTRIBUTE2				AS MASTER_INVLD_MSG
	 FROM #PACKER_UPLOAD_ITEM_CNT PS 
		  LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
				  ON LK.LOOKUP_TYPE		= 'MASTER_INVLD_CD'
				 AND LK.SEGMENT1		= PS.MASTER_INVLD_CD
				 AND LK.VALID_YN		= 'Y'
	WHERE 1=1 

END






