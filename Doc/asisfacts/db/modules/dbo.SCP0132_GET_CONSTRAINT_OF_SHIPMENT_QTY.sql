



/*
 * Program ID   : SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY
 * Description  : 출하수량 제약(포장재)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/09/05   kh   			PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 *
 */

CREATE PROCEDURE [dbo].[SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY]
	  @p_division_id		NVARCHAR(MAX)
	, @p_plan_group_id	    NVARCHAR(MAX)
	, @p_from_site_id		NVARCHAR(MAX)
    , @p_to_site_id	   	    NVARCHAR(MAX)
    , @p_mdl_gr_nm          NVARCHAR(MAX)
	, @p_item_id			NVARCHAR(MAX)
    , @p_stage		   	    NVARCHAR(MAX)
    , @p_from_yyyymmdd      NVARCHAR(MAX)
    , @p_to_yyyymmdd        NVARCHAR(MAX)
	, @p_valid_yn			NVARCHAR(MAX)


AS
BEGIN
	
  SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    -- 파라미터로 받을 값 변수  
    DECLARE @v_division_id		NVARCHAR(200)	= @p_division_id	
    DECLARE @v_plan_group_id	NVARCHAR(200)	= @p_plan_group_id	
    DECLARE @v_from_site_id		NVARCHAR(200)	= @p_from_site_id	
    DECLARE @v_to_site_id	   	NVARCHAR(200)	= @p_to_site_id	   	
    DECLARE @v_mdl_gr_nm        NVARCHAR(200)	= @p_mdl_gr_nm
    DECLARE @v_item_id		    NVARCHAR(200)	= @p_item_id		
    DECLARE @v_stage		   	NVARCHAR(200)	= @p_stage		   	
    DECLARE @v_from_yyyymmdd  	NVARCHAR(200)	= @p_from_yyyymmdd  
    DECLARE @v_to_yyyymmdd      NVARCHAR(200)	= @p_to_yyyymmdd    
    DECLARE @v_valid_yn		    NVARCHAR(200)	= @p_valid_yn		



    SELECT DIVISION_ID
            ,OPMZ_PLAN_GR_ID
            ,MDL_GR_NM
            ,ITEM_ID
            ,STAGE
            ,FROM_STE_ID
            ,TO_STE_ID
            ,IIF(ISNULL(a.FROM_YYYYMMDD,'')='','', convert(char(10), convert(datetime, a.FROM_YYYYMMDD), 23)) as FROM_YYYYMMDD
            ,IIF(ISNULL(a.TO_YYYYMMDD,'')='','', convert(char(10), convert(datetime, a.TO_YYYYMMDD), 23)) as TO_YYYYMMDD
            ,SIPM_MIN_QYT
            ,SIPM_MAX_QTY
            ,SAT_SIPM_MIN_QTY
            ,SAT_SIPM_MAX_QTY
            ,SUN_SIPM_MIN_QTY
            ,SUN_SIPM_MAX_QTY
            ,VAL_TP_CD
            ,VALUE_DESCRIPTION
            ,VALID_YN
            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE
            ,a.DIVISION_ID+ '|' + a.OPMZ_PLAN_GR_ID+ '|' + a.MDL_GR_NM+ '|' +  A.ITEM_ID  AS PRE_KEY_VALUES
    FROM dbo.SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY a  WITH(NOLOCK)
    INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
            ON a.ITEM_ID  like  b.tst 
    WHERE 1=1
    AND ( ( @v_division_id   IS NULL OR @v_division_id = ''  )   OR a.DIVISION_ID     IN (SELECT token FROM dbo.String_Split(@v_division_id  ,',')) )
    AND ( ( @v_plan_group_id IS NULL OR @v_plan_group_id = '')   OR a.OPMZ_PLAN_GR_ID IN (SELECT token FROM dbo.String_Split(@v_plan_group_id  ,',')) )
    AND ( ( @v_from_site_id  IS NULL OR @v_from_site_id = '' )   OR a.FROM_STE_ID     IN (SELECT token FROM dbo.String_Split(@v_from_site_id  ,',')) )
    AND ( ( @v_to_site_id    IS NULL OR @v_to_site_id = ''   )   OR a.TO_STE_ID       IN (SELECT token FROM dbo.String_Split(@v_to_site_id  ,',')) )
    AND ( ( @v_stage         IS NULL OR @v_stage = ''        )   OR a.STAGE           IN (SELECT token FROM dbo.String_Split(@v_stage  ,',')) )
    AND ( ( @p_valid_yn      IS NULL OR @v_valid_yn   = '' )    OR a.VALID_YN         IN (SELECT token FROM dbo.String_Split(@v_valid_yn  ,',')) )
    AND ( ( @v_mdl_gr_nm     IS NULL OR @v_mdl_gr_nm   = '' )   OR a.MDL_GR_NM        IN (SELECT token FROM dbo.String_Split(@v_mdl_gr_nm  ,',')) )
    AND  FROM_YYYYMMDD  <=  @v_to_yyyymmdd 
    AND  TO_YYYYMMDD    >= @v_from_yyyymmdd
  
END

