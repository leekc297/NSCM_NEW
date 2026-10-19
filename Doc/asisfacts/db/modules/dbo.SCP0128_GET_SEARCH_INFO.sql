


/*
 * Program ID   : SCP0128_GET_SEARCH_INFO
 * Description  : 안전재고(SCP0128), 수요제외(SCP0129) 조회, 콤보용 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/25   kh    			PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2025/11/14   mrchois    		PJ20257329	최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 수요제외(SCP0129)용은 Attribute3 = 'Y'인 것으로 가져오도록 변경
 * 2025/11/24   mrchois    		PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - ITEM 유효성 체크 마스터 테이블 변경, SCP_MST_FINAL_ITEM -> SCM_MST_ITEM_SN
 * 2025/12/17   mrchois    		PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Scheduled Reciept Information-Virtual BOM에 등록한 ITEM도 입력 가능하도록 변경
 *
 */

CREATE PROCEDURE [dbo].[SCP0128_GET_SEARCH_INFO]
	 @p_division_id		NVARCHAR(MAX)
	,@p_site_id         NVARCHAR(MAX)
AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
 	DECLARE @v_division_id   NVARCHAR(200)   = @p_division_id
	DECLARE @v_site_id       NVARCHAR(200)   = @p_site_id
     -- 참조 기간 및 기준일자 정보 변수
    DECLARE @v_from_yyyymmdd		NVARCHAR(8)		= NULL	-- 당주 월요일 (plan_start_yyyymmdd) 
    DECLARE @v_to_yyyymmdd			NVARCHAR(8)		= NULL	-- horizon_end_date ?

	--1. Plan Group 정보 
	select OPMZ_PLAN_GR_ID	AS CODE
		, OPMZ_PLAN_GR_NAME	AS NAME
		, DIVISION_ID
	from SCP_OPMZ_PLAN_GR_M with(nolock)
	WHERE 1=1
	 AND VALID_YN='Y'
	ORDER BY OPMZ_PLAN_GR_NAME
	


	--2. 재고 SCM SITE ID 
	SELECT DIVISION_ID
			,CODE
			,NAME
	FROM (
 			SELECT DISTINCT A.DIVISION_ID
				, SCM_SITE_ID AS CODE 
				, SCM_SITE_ID AS NAME
				, SITE_TYPE
			FROM   SCM_MST_SITE A WITH(NOLOCK) 
			WHERE  1 = 1
			AND A.SITE_TYPE = 'SALES'	
			AND A.DIVISION_ID != '40'
			AND A.VALID_YN = 'Y'	
			UNION ALL
			SELECT DISTINCT A.DIVISION_ID
				, A.SCM_SITE_ID AS CODE 
				, A.SCM_SITE_ID AS NAME
				, A.SITE_TYPE
			FROM   SCM_MST_SITE AS A WITH(NOLOCK) 
			LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK) 
				ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
			WHERE  1 = 1
			AND A.SITE_TYPE = 'SALES'
			AND  A.DIVISION_ID = '40'
			AND A.VALID_YN = 'Y'
			UNION ALL
			SELECT DISTINCT A.DIVISION_ID
				, SCM_SITE_ID AS CODE 
				, SCM_SITE_ID AS NAME
				, A.SITE_TYPE
			FROM   [dbo].[SCM_MST_SITE] A
			WHERE  1 = 1
			AND    A.SITE_TYPE = 'PLANT'
			) X
	ORDER BY SITE_TYPE, NAME  -- A.DIVISION_ID
	 
  
   -- 3. STAGE 최적화 (안전재고(SCP0128) 용)
   SELECT M.SEGMENT1  AS DIVISION_ID
         ,M.SEGMENT3 AS CODE
         ,M.ATTRIBUTE1 AS NAME
   FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)
   WHERE M.LOOKUP_TYPE LIKE 'OPMZ_STAGE_CD'
   AND   M.VALID_YN='Y'
	

	-- 4. TYPE (COVER_DAY_TYPE : MIN/MAX) 호출
	SELECT M.SEGMENT1 AS CODE
		,M.SEGMENT2 AS NAME
	FROM   dbo.SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)
	WHERE  LOOKUP_TYPE = 	 'COVER_DAY_TYPE'
    ORDER BY M.DISPLAY_SEQ
  
    -- 5. valid YN
    SELECT M.SEGMENT1 AS CODE
		,M.SEGMENT2 AS NAME
	FROM   dbo.SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)
	WHERE  LOOKUP_TYPE = 	'DM_YN' -- 'DEFAULT_FLAG'
    ORDER BY M.DISPLAY_SEQ

   --6.ITEM_ID 조회
   	  SELECT distinct
		   I.DIVISION_ID
		 , I.ITEM_ID	 
	  FROM   SCM_MST_ITEM_SN I WITH(NOLOCK)		--[PJ20257329]ITEM 유효성 체크 마스터 테이블 변경, SCP_MST_FINAL_ITEM -> SCM_MST_ITEM_SN (2025-11-24)
	  WHERE 1=1
	  AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END IN (SELECT token FROM dbo.String_Split(@p_division_id  ,','))
	  --[PJ20257329] Scheduled Reciept Information-Virtual BOM에 등록한 ITEM도 입력 가능하도록 변경 (2025-12-17) START
	  UNION
	  SELECT distinct
		   DIVISION_ID
		 , ITEM_ID_CHILD	 AS ITEM_ID
	  FROM   SCP_OPMZ_VIRTUAL_BOM I WITH(NOLOCK)
	  WHERE 1=1
	  AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END IN (SELECT token FROM dbo.String_Split(@p_division_id  ,','))
	  ORDER BY ITEM_ID, DIVISION_ID 
	  --[PJ20257329] Scheduled Reciept Information-Virtual BOM에 등록한 ITEM도 입력 가능하도록 변경 (2025-12-17) END
	 
   --[PJ20257329]수요제외(SCP0129)용은 Attribute3 = 'Y' 인 것으로 가져오도록 변경 (2025-11-14) START
   -- 7. STAGE 최적화 (수요제외(SCP0129) 용)
   SELECT M.SEGMENT1  AS DIVISION_ID
         ,M.SEGMENT3 AS CODE
         ,M.ATTRIBUTE1 AS NAME
   FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)
   WHERE M.LOOKUP_TYPE LIKE 'OPMZ_STAGE_CD'
   AND   M.VALID_YN='Y'
   AND   M.ATTRIBUTE3 ='Y'
   --[PJ20257329]수요제외(SCP0129)용은 Attribute3 = 'Y' 인 것으로 가져오도록 변경 (2025-11-14) END

END

