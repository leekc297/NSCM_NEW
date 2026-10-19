/*
 * Program ID   : SSP0025_GET_ITEM_BY_DIVISION_POPUP
 * Description  : Material 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2020/06/25   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선
 */

CREATE PROCEDURE [dbo].[SSP0025_GET_ITEM_BY_DIVISION_POPUP]
	@p_division_id		NVARCHAR(30),
	@p_from_site_id		NVARCHAR(30),
	@p_to_site_id		NVARCHAR(30),
	@p_item_id			NVARCHAR(50),
	@p_model_id			NVARCHAR(50)
AS
BEGIN
	
  SET NOCOUNT ON;

	SELECT A.DIVISION_ID               AS DIVISION_ID
		 , A.SCM_SITE_ID               AS FROM_SITE_CODE
		 , S.SITE_DESCRIPTION          AS FROM_SITE
		 , A.ITEM_ID                   AS ITEM_ID
		 , A.MODEL_ID                  AS MODEL_ID
		 , A.CELL_TYPE                 AS CELL_TYPE
		 , A.ITEM_ID_NICK_NAME         AS NICK_NAME
		 , A.ELECTRODE_TYPE            AS ELECTRODE_TYPE
		 , A.ITEM_UOM                  AS ITEM_UOM
		 , A.UOM_CONVERT_IN_TACT_TIME  AS UOM_CONVERT_IN_TACT_TIME
		 , L.SEGMENT5                  AS TO_DIVISION_ID
		 , L.ATTRIBUTE1                AS TO_SITE_CODE
		 , S2.SITE_DESCRIPTION         AS TO_SITE
	  FROM SSP_MST_SITE_ITEM_EE_V A WITH(NOLOCK)

	  JOIN SCM_MST_SITE S WITH(NOLOCK)
		ON S.DIVISION_ID = A.DIVISION_ID
	   AND S.SCM_SITE_ID = A.SCM_SITE_ID

	  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
		ON L.SEGMENT2    = A.DIVISION_ID
	   AND L.SEGMENT3    = A.SCM_SITE_ID
	   AND L.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO' 

	  LEFT JOIN SCM_MST_SITE S2 WITH(NOLOCK)
		ON S2.DIVISION_ID = L.SEGMENT5
	   AND S2.SCM_SITE_ID = L.ATTRIBUTE1

	  WHERE 1=1
	    AND ( ( @p_division_id	IS NULL OR @p_division_id	= '' ) OR A.DIVISION_ID	IN (SELECT token FROM dbo.String_Split(@p_division_id ,',')) )
	    AND ( ( @p_from_site_id	IS NULL OR @p_from_site_id	= '' ) OR S.SCM_SITE_ID	IN (SELECT token FROM dbo.String_Split(@p_from_site_id,',')) )
	    AND ( ( @p_item_id		IS NULL OR @p_item_id		= '' ) OR A.ITEM_ID		IN (SELECT token FROM dbo.String_Split(@p_item_id	  ,',')) )
		AND ( ( @p_model_id		IS NULL OR @p_model_id		= '' ) OR A.MODEL_ID	IN (SELECT token FROM dbo.String_Split(@p_model_id    ,',')) )
		AND ( ( @p_to_site_id	IS NULL OR @p_to_site_id	= '' ) OR L.ATTRIBUTE1	IN (SELECT token FROM dbo.String_Split(@p_to_site_id  ,',')) )
	  ORDER BY A.ITEM_ID,A.DIVISION_ID, S.SCM_SITE_ID, S.SITE_DESCRIPTION
END
