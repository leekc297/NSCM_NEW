
/*
 * Program ID   : SSP0024_GET_SHIP_MASTER
 * Description  : Shipment Master(Electrode) 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2020/04/17   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선
 */
CREATE PROCEDURE [dbo].[SSP0024_GET_SHIP_MASTER]
  @p_division_id		NVARCHAR(MAX),
  @p_plant_site_id		NVARCHAR(MAX),
  @p_material_id		NVARCHAR(MAX),
  @p_nick_name			NVARCHAR(MAX),
  @p_model_id			NVARCHAR(MAX)=''
AS  
  
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	
	SELECT M.DIVISION_ID                                     AS DIVISION_ID
		 , M.SCM_SITE_ID                                     AS PLANT_SITE_CODE
		 , M.SCM_SITE_ID                                     AS PLANT_SITE_ID
		 , M.ITEM_ID                                         AS MATERIAL_ID
		 , F.MODEL_ID                                        AS MODEL_ID
		 , F.CELL_TYPE                                       AS CELL_TYPE
		 , F.ITEM_ID_NICK_NAME                               AS NICK_NAME
		 , F.ELECTRODE_TYPE                                  AS ELECTRODE_TYPE
		 , F.ITEM_UOM                                        AS ITEM_UOM
		 , M.ELECTRODE_POST_OPER_CODE                        AS POST_OPER
		 , F.ELECTRODE_POST_OPER_LT                          AS POST_OPER_LT
--		 , F.UOM_CONVERT_IN_TACT_TIME                        AS UOM_CONVERT_IN_TACT_TIME -- PANCAKE(CELL/M)
		 , F.METER_PER_CELL                                  AS UOM_CONVERT_IN_TACT_TIME -- PANCAKE(CELL/M)
		 , M.PC_ROLL_LENGTH                                  AS PC_ROLL_LENGTH           -- 정권길이
		 , F.PACKAGE_TYPE_CODE                               AS PACKAGE_TYPE_CODE
		 , M.STEELCRATE_PER_CUT                              AS STEELCRATE_PER_CUT       -- STEELCRATE/CUT
		 , CAST(M.BOX_PER_CUT       AS NUMERIC(10,2))        AS BOX_PER_CUT
		 , CAST(M.STEELRACK_PER_CUT AS NUMERIC(10,2))        AS STEELRACK_PER_CUT
		 , M.DOM_EXP_TYPE_CODE                               AS DOM_EXP_TYPE_CODE
		 , CASE WHEN F.FACTORY_ID = 'ALL' THEN F.FACTORY_ID
		        ELSE F.FACTORY_NAME END                      AS BUILDING
		 , CASE WHEN F.FACTORY_ID = 'ALL' THEN F.FACTORY_ID
		        ELSE F.FACTORY_NAME END                      AS BUILDING_DESC
		 , M.REMARKS                                         AS REMARKS
		 , M.CREATED_BY                                      AS CREATED_BY
		 , M.CREATION_DATE                                   AS CREATION_DATE
		 , M.LAST_UPDATED_BY                                 AS LAST_UPDATED_BY
		 , M.LAST_UPDATE_DATE                                AS LAST_UPDATE_DATE
	  FROM SSP_MST_SHIP_MASTER_EE M WITH(NOLOCK)

	  JOIN SSP_MST_SITE_ITEM_EE_V F WITH(NOLOCK)
	    ON F.DIVISION_ID = M.DIVISION_ID
	   AND F.SCM_SITE_ID = M.SCM_SITE_ID
	   AND F.ITEM_ID     = M.ITEM_ID
	  
	  JOIN SCM_MST_SITE S WITH(NOLOCK)
		ON S.DIVISION_ID = M.DIVISION_ID
	   AND S.SCM_SITE_ID = M.SCM_SITE_ID
	 WHERE 1=1 
	  AND ( ( @p_division_id	IS NULL OR  @p_division_id   = ''	) OR M.DIVISION_ID       IN (SELECT token FROM dbo.String_Split(@p_division_id   ,',')) )
	  AND ( ( @p_plant_site_id	IS NULL OR  @p_plant_site_id = ''	) OR M.SCM_SITE_ID       IN (SELECT token FROM dbo.String_Split(@p_plant_site_id ,',')) )
	  AND ( ( @p_material_id	IS NULL OR  @p_material_id	 = ''	) OR M.ITEM_ID           IN (SELECT token FROM dbo.String_Split(@p_material_id   ,',')) )
	  AND ( ( @p_nick_name		IS NULL OR  @p_nick_name	 = ''	) OR F.ITEM_ID_NICK_NAME IN (SELECT token FROM dbo.String_Split(@p_nick_name     ,',')) )
	  AND ( ( @p_model_id			IS NULL OR  @p_model_id	 = ''	) OR F.MODEL_ID          IN (SELECT token FROM dbo.String_Split(@p_model_id      ,',')) )
	ORDER BY M.DIVISION_ID, M.SCM_SITE_ID, M.ITEM_ID, F.MODEL_ID, F.CELL_TYPE
END
