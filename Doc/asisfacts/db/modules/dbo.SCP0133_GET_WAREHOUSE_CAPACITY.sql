



/*
 * Program ID   : SCP0133_GET_WAREHOUSE_CAPACITY
 * Description  : Warehouse Capacity 탭 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/11/11   mrchois   		PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2025/11/24   mrchois   		PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Warehouse Capacity에 From/to date 키로 추가
 *
 */

CREATE  PROCEDURE [dbo].[SCP0133_GET_WAREHOUSE_CAPACITY]
	  @p_division_id		NVARCHAR(MAX)
	, @p_opmz_plan_gr_id    NVARCHAR(MAX)
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
    DECLARE @v_from_yyyymmdd    NVARCHAR(200)	= @p_from_yyyymmdd 
    DECLARE @v_to_yyyymmdd     	NVARCHAR(200)	= @p_to_yyyymmdd   
    DECLARE @v_valid_yn			NVARCHAR(200)	= @p_valid_yn			


    SELECT DIVISION_ID
         , OPMZ_PLAN_GR_ID
         , WH_NM
         , SCM_SITE_ID
         , STAGE
         , IIF(ISNULL(a.FROM_YYYYMMDD,'')='','', convert(char(10), convert(datetime, a.FROM_YYYYMMDD), 23)) as FROM_YYYYMMDD
         , IIF(ISNULL(a.TO_YYYYMMDD,'')='','', convert(char(10), convert(datetime, a.TO_YYYYMMDD), 23)) as TO_YYYYMMDD
         , MAX_CAPA
         , VALUE_DESCRIPTION
         , VALID_YN
         , CREATED_BY
         , CREATION_DATE
         , LAST_UPDATED_BY
         , LAST_UPDATE_DATE
		 , a.DIVISION_ID + '|' + a.OPMZ_PLAN_GR_ID + '|' + a.WH_NM + '|' + a.FROM_YYYYMMDD + '|' + a.TO_YYYYMMDD AS PRE_KEY_VALUES	--[PJ20257329] Warehouse Capacity에 From/to date 키로 추가
      FROM SCP_OPMZ_WAREHOUSE_CAPACITY a  WITH(NOLOCK)
     WHERE 1=1
       AND ( ( @v_division_id   IS NULL OR @v_division_id = ''  )   OR a.DIVISION_ID     IN (SELECT token FROM dbo.String_Split(@v_division_id  ,',')) )
       AND ( ( @v_opmz_plan_gr_id IS NULL OR @v_opmz_plan_gr_id = '')   OR a.OPMZ_PLAN_GR_ID IN (SELECT token FROM dbo.String_Split(@v_opmz_plan_gr_id  ,',')) )
       AND ( ( @v_site_id       IS NULL OR @v_site_id = '' )        OR a.SCM_SITE_ID     IN (SELECT token FROM dbo.String_Split(@v_site_id  ,',')) )
       AND ( ( @v_stage         IS NULL OR @v_stage = '' )          OR a.STAGE           IN (SELECT token FROM dbo.String_Split(@v_stage  ,',')) )
       AND ( ( @p_valid_yn      IS NULL OR @v_valid_yn   = '' )     OR a.VALID_YN        IN (SELECT token FROM dbo.String_Split(@v_valid_yn  ,',')) )
       AND ( ( @v_wh_nm         IS NULL OR @v_wh_nm   = '' )        OR a.WH_NM           IN (SELECT token FROM dbo.String_Split(@v_wh_nm  ,',')) )
       AND  FROM_YYYYMMDD  <=  @v_to_yyyymmdd 
       AND  TO_YYYYMMDD    >= @v_from_yyyymmdd
 
 
END

