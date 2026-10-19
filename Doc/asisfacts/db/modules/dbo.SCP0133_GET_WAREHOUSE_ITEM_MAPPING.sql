



/*
 * Program ID   : SCP0133_GET_WAREHOUSE_ITEM_MAPPING
 * Description  : Warehouse ITEM_MAPPING 탭 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/11/11   mrchois   		PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2025/11/24   mrchois   		PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Model 검색조건 오류 수정 
 *
 */

CREATE  PROCEDURE [dbo].[SCP0133_GET_WAREHOUSE_ITEM_MAPPING]
	  @p_division_id		NVARCHAR(MAX)
	, @p_opmz_plan_gr_id	NVARCHAR(MAX)
	, @p_site_id		    NVARCHAR(MAX)
    , @p_stage		   	    NVARCHAR(MAX)
    , @p_wh_nm              NVARCHAR(MAX)
    , @p_from_yyyymmdd      NVARCHAR(MAX)
    , @p_to_yyyymmdd        NVARCHAR(MAX)
	, @p_item_id			NVARCHAR(MAX)
	, @p_valid_yn			NVARCHAR(MAX)


AS
BEGIN
	
  SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    -- 파라미터로 받을 값 변수  
    DECLARE @v_division_id	  	NVARCHAR(200)	= @p_division_id	  
    DECLARE @v_opmz_plan_gr_id 	NVARCHAR(200)	= @p_opmz_plan_gr_id 
    DECLARE @v_site_id		    NVARCHAR(200)	= @p_site_id		    
    DECLARE @v_stage		   	NVARCHAR(200)	= @p_stage		   	  
    DECLARE @v_wh_nm            NVARCHAR(200)	= @p_wh_nm         
    DECLARE @v_item_id			NVARCHAR(200)	= @p_item_id			  
    DECLARE @v_valid_yn			NVARCHAR(200)	= @p_valid_yn			


    SELECT DIVISION_ID
         , OPMZ_PLAN_GR_ID
         , WH_NM
         , ITEM_ID
         , SCM_SITE_ID
         , STAGE
		 , STOR_PER
		 , STOR_LOC 
		 , CASE WHEN STOR_LOC = '@E' THEN 'East' 
		        WHEN STOR_LOC = '@W' THEN 'West' 
				ELSE '' END AS STOR_LOC_NAME
         , VALUE_DESCRIPTION
         , VALID_YN
         , CREATED_BY
         , CREATION_DATE
         , LAST_UPDATED_BY
         , LAST_UPDATE_DATE
         , a.DIVISION_ID + '|' + a.OPMZ_PLAN_GR_ID + '|' + A.WH_NM + '|' + ITEM_ID AS PRE_KEY_VALUES
      FROM SCP_OPMZ_WAREHOUSE_ITEM_MAPPING a  WITH(NOLOCK)
     WHERE 1=1
       AND ( ( @v_division_id   IS NULL OR @v_division_id = ''  )   OR a.DIVISION_ID     IN (SELECT token FROM dbo.String_Split(@v_division_id  ,',')) )
       AND ( ( @v_opmz_plan_gr_id IS NULL OR @v_opmz_plan_gr_id = '')   OR a.OPMZ_PLAN_GR_ID IN (SELECT token FROM dbo.String_Split(@v_opmz_plan_gr_id  ,',')) )
       AND ( ( @v_site_id       IS NULL OR @v_site_id = '' )        OR a.SCM_SITE_ID     IN (SELECT token FROM dbo.String_Split(@v_site_id  ,',')) )
       AND ( ( @v_stage         IS NULL OR @v_stage = '' )          OR a.STAGE           IN (SELECT token FROM dbo.String_Split(@v_stage  ,',')) )
       AND ( ( @p_valid_yn      IS NULL OR @v_valid_yn   = '' )     OR a.VALID_YN        IN (SELECT token FROM dbo.String_Split(@v_valid_yn  ,',')) )
       AND ( ( @v_wh_nm         IS NULL OR @v_wh_nm   = '' )        OR a.WH_NM           IN (SELECT token FROM dbo.String_Split(@v_wh_nm  ,',')) )
	   AND ( ( @v_item_id		IS NULL OR @v_item_id = '' )		OR a.ITEM_ID		 LIKE '%' + @v_item_id + '%' )		--[PJ20257329] Model 검색조건 오류 수정 
 
END

