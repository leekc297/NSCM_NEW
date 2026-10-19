


/*
 * Program ID   : SCP0130_GET_VIRTUAL_BOM
 * Description  : 자재/포장재 입고예정 정보 VIRTUAL_BOM 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/24   kh   			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 *
 */

CREATE PROCEDURE [dbo].[SCP0130_GET_VIRTUAL_BOM]
	  @p_division_id		NVARCHAR(MAX)
	, @p_plan_group_id	    NVARCHAR(MAX)
	, @p_plant_site_id		NVARCHAR(MAX)
	, @p_item_id			NVARCHAR(MAX)
    , @p_item_id_child		NVARCHAR(MAX)
	, @p_valid_yn			NVARCHAR(MAX)
    , @p_from_date          NVARCHAR(MAX)

AS
BEGIN
	
  SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- 파라미터로 받을 값 변수  
  DECLARE @v_division_id		NVARCHAR(200)	= @p_division_id
  DECLARE @v_plan_group_id		NVARCHAR(200)	= @p_plan_group_id
  DECLARE @v_plant_site_id		NVARCHAR(200)	= @p_plant_site_id
  DECLARE @v_item_id		    NVARCHAR(200)	= @p_item_id
  DECLARE @v_item_id_child		NVARCHAR(200)	= @p_item_id_child
  DECLARE @v_valid_yn		    NVARCHAR(200)	= @p_valid_yn

  SELECT a.DIVISION_ID
        ,a.OPMZ_PLAN_GR_ID
        ,a.PLANT_SITE_ID
        ,a.ITEM_ID
        ,a.ITEM_ID_CHILD
        ,IIF(ISNULL(a.TO_YYYYMMDD,'')='','', convert(char(10), convert(datetime, a.TO_YYYYMMDD), 23)) as TO_YYYYMMDD
        ,a.TO_EXPC_QTY
        ,a.VALUE_DESCRIPTION
        ,a.VALID_YN
        ,a.CREATED_BY
        ,a.CREATION_DATE
        ,a.LAST_UPDATED_BY
        ,a.LAST_UPDATE_DATE
        ,a.DIVISION_ID+ '|' + a.OPMZ_PLAN_GR_ID+ '|' + a.PLANT_SITE_ID+ '|' + a.ITEM_ID + '|' + a.ITEM_ID_CHILD + '|' +  a.TO_YYYYMMDD  
         + '|' + CAST(a.TO_EXPC_QTY AS nvarchar(30)) + '|' +  VALID_YN+ '|' + VALUE_DESCRIPTION    AS PRE_KEY_VALUES
    FROM DBO.SCP_OPMZ_VIRTUAL_BOM a  with(nolock)
    INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
            ON a.ITEM_ID  like  b.tst 

    WHERE 1=1
    AND  CASE WHEN A.TO_YYYYMMDD  IS NULL OR A.TO_YYYYMMDD = '' THEN'99991231' ELSE  A.TO_YYYYMMDD END >= @p_from_date 
    AND ( ( @v_division_id   IS NULL OR @v_division_id = '' )   OR a.DIVISION_ID     IN (SELECT token FROM dbo.String_Split(@v_division_id  ,',')) )
    AND ( ( @v_plant_site_id IS NULL OR @v_plant_site_id = '' ) OR a.PLANT_SITE_ID     IN (SELECT token FROM dbo.String_Split(@v_plant_site_id  ,',')) )
    AND ( ( @p_valid_yn      IS NULL OR @v_valid_yn   = '' )    OR a.VALID_YN        IN (SELECT token FROM dbo.String_Split(@v_valid_yn  ,',')) )
    AND ( ( @v_plan_group_id IS NULL OR @v_plan_group_id = '' ) OR a.OPMZ_PLAN_GR_ID IN (SELECT token FROM dbo.String_Split(@v_plan_group_id  ,',')) )
    AND ( ( @v_item_id       IS NULL OR @v_item_id = '' )       OR a.ITEM_ID         IN (SELECT token FROM dbo.String_Split(@v_item_id  ,',')) )
    AND ( ( @v_item_id_child IS NULL OR @v_item_id_child = '' ) OR a.ITEM_ID_CHILD   IN (SELECT token FROM dbo.String_Split(@v_item_id_child  ,',')) )
  
END

