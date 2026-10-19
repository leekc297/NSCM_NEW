/*
 * Program ID   : SSP0024_GET_ITEM_BY_DIVISION_POPUP
 * Description  : Material 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2020/04/17   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선
 */

CREATE PROCEDURE [dbo].[SSP0024_GET_ITEM_BY_DIVISION_POPUP]
	@p_division_id		NVARCHAR(30),
	@p_plant_site_id	NVARCHAR(30),
	@p_material_id		NVARCHAR(50)
AS
BEGIN
	
  SET NOCOUNT ON;

	SELECT A.DIVISION_ID               AS DIVISION_ID
		 , A.SCM_SITE_ID               AS PLANT_SITE_CODE
		 , S.SITE_DESCRIPTION          AS PLANT_SITE_ID
		 , A.ITEM_ID                   AS MATERIAL_ID
		 , A.MODEL_ID                  AS MODEL_ID
		 , A.CELL_TYPE                 AS CELL_TYPE
		 , A.ITEM_ID_NICK_NAME         AS NICK_NAME
		 , A.ELECTRODE_TYPE            AS ELECTRODE_TYPE
		 , A.ITEM_UOM                  AS ITEM_UOM
		 , A.UOM_CONVERT_IN_TACT_TIME  AS UOM_CONVERT_IN_TACT_TIME
	  FROM SSP_MST_SITE_ITEM_EE_V A WITH(NOLOCK)

	  JOIN SCM_MST_SITE S WITH(NOLOCK)
		ON S.DIVISION_ID = A.DIVISION_ID
	   AND S.SCM_SITE_ID = A.SCM_SITE_ID

	  WHERE 1=1
	    AND ( ( @p_division_id	 IS NULL OR @p_division_id   = '' ) OR A.DIVISION_ID  IN (SELECT token FROM dbo.String_Split(@p_division_id   ,',')) )
	    AND ( ( @p_plant_site_id IS NULL OR @p_plant_site_id = '' ) OR S.SCM_SITE_ID  IN (SELECT token FROM dbo.String_Split(@p_plant_site_id ,',')) )
	    AND ( ( @p_material_id	 IS NULL OR @p_material_id	 = '' ) OR A.ITEM_ID      IN (SELECT token FROM dbo.String_Split(@p_material_id   ,',')) )
	  ORDER BY A.DIVISION_ID, S.SCM_SITE_ID, S.SITE_DESCRIPTION, A.ITEM_ID
END
