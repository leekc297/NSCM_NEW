
/*
 * Program ID   : SCP0114_GET_CAPA_LINE_MASTER
 * Description  : CAPA LINE MASTER
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/09/23   jahn1502        Initial Release
 
 */

CREATE PROCEDURE [dbo].[SCP0114_GET_CAPA_LINE_MASTER]
	@p_menu_level		SMALLINT,
	@p_division_id		NVARCHAR(20),
	@p_site_id			NVARCHAR(20),
	@p_company_id		NVARCHAR(20),
	@p_plant_id			NVARCHAR(20),
	@p_factory_id		NVARCHAR(20),
	@p_line_id		    NVARCHAR(20),
	@p_shop_group_id    NVARCHAR(20)
AS
BEGIN
SET NOCOUNT ON;

	--Pack,Cell => SCP_MST_CAPA_LINE
	--Elec =>SCP_MST_CAPA_ELTR_LINE
	IF @p_shop_group_id = 'P' or @p_shop_group_id = 'A' 
	BEGIN
		IF @p_menu_level = 1
		BEGIN
			SELECT LVL.DIVISION_ID
				 , LVL.SITE_ID
				 , LVL.SITE_NAME
				 , LVL.VALID_YN
				 , LVL.DUMMY_YN
				 , ROW_NUMBER() OVER(ORDER BY LVL.DIVISION_ID,LVL.SITE_ID) AS SORT_ORDER
			FROM (
			/*
					SELECT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN
						FROM SCP_MST_CAPA_LINE SC WITH(NOLOCK)						
						WHERE 1=1 
						  AND SC.VALID_YN <> 'N'
				          AND SC.COMPANY_ID = '-'
						  --AND ((SC.ATTRIBUTE2 = 'N' AND SC.ATTRIBUTE1 = @p_shop_group_id) -- Dummy 아닌 경우
						  --  OR (SC.ATTRIBUTE2 = 'Y' AND SC.COMPANY_ID = '-') -- Dummy 인 경우 하위 ID가 ‘-‘임
						  --    )
						  AND SC.DIVISION_ID = @p_division_id
					      --AND SC.ATTRIBUTE1 = @p_shop_group_id
			*/
					SELECT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN
					  FROM SCP_MST_CAPA_LINE SC WITH(NOLOCK)						
					 WHERE 1=1 
					   AND SC.VALID_YN <> 'N'
					   AND SC.COMPANY_ID = '-'
					   AND SC.DIVISION_ID = @p_division_id
					 UNION
					SELECT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN
					  FROM SCP_MST_CAPA_ELTR_LINE SC WITH(NOLOCK)						
					 WHERE 1=1 
					   AND SC.VALID_YN <> 'N'
					   AND SC.COMPANY_ID = '-'
					   AND SC.DIVISION_ID = @p_division_id
				  ) LVL
		END
		ELSE IF @p_menu_level = 2
		BEGIN
			SELECT LVL.DIVISION_ID
				 , LVL.SITE_ID
				 , LVL.SITE_NAME
				 , LVL.COMPANY_ID
				 , LVL.COMPANY_NAME
				 , LVL.DUMMY_YN
				 , LVL.VALID_YN
				 , ROW_NUMBER() OVER(ORDER BY LVL.DIVISION_ID,LVL.SITE_ID,LVL.COMPANY_ID) AS SORT_ORDER
			FROM (
			/*
					SELECT DISTINCT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.COMPANY_ID
						 , SC.COMPANY_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN	 
					  FROM SCP_MST_CAPA_LINE SC WITH(NOLOCK)					 
					 WHERE 1=1
					   AND SC.VALID_YN <> 'N'
				       AND SC.PLANT_ID = '-'
						  --AND ((SC.ATTRIBUTE2 = 'N' AND SC.ATTRIBUTE1 = @p_shop_group_id) -- Dummy 아닌 경우
						  --  OR (SC.ATTRIBUTE2 = 'Y' AND SC.PLANT_ID = '-') -- Dummy 인 경우 하위 ID가 ‘-‘임
						  --    )
					   AND SC.DIVISION_ID = @p_division_id 
					   AND SC.SITE_ID = @p_site_id
					   --AND SC.ATTRIBUTE1 = @p_shop_group_id
					   AND SC.COMPANY_ID <> '-'
					   */
					SELECT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.COMPANY_ID
						 , SC.COMPANY_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN	 
					  FROM SCP_MST_CAPA_LINE SC WITH(NOLOCK)					 
					 WHERE 1=1
					   AND SC.VALID_YN <> 'N'
					   AND SC.PLANT_ID = '-'
					   AND SC.DIVISION_ID = @p_division_id 
					   AND SC.SITE_ID = @p_site_id
					   AND SC.COMPANY_ID <> '-'
					UNION
					SELECT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.COMPANY_ID
						 , SC.COMPANY_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN	 
					  FROM SCP_MST_CAPA_ELTR_LINE SC WITH(NOLOCK)					 
					 WHERE 1=1
					   AND SC.VALID_YN <> 'N'
					   AND SC.PLANT_ID = '-'
					   AND SC.DIVISION_ID = @p_division_id 
					   AND SC.SITE_ID = @p_site_id
					   AND SC.COMPANY_ID <> '-'
				  ) LVL
		END
		ELSE IF @p_menu_level = 3
		BEGIN
			SELECT LVL.DIVISION_ID
				 , LVL.SITE_ID
				 , LVL.SITE_NAME
				 , LVL.COMPANY_ID
				 , LVL.COMPANY_NAME
				 , LVL.PLANT_ID
				 , LVL.PLANT_NAME
				 , LVL.DUMMY_YN
				 , LVL.VALID_YN
				 , ROW_NUMBER() OVER(ORDER BY LVL.DIVISION_ID,LVL.SITE_ID,LVL.COMPANY_ID,LVL.PLANT_ID) AS SORT_ORDER
			FROM (
			/*
				SELECT DISTINCT SC.DIVISION_ID
					 , SC.SITE_ID AS SITE_ID
					 , SC.SITE_NAME AS SITE_NAME
					 , SC.COMPANY_ID
					 , SC.COMPANY_NAME
					 , SC.PLANT_ID
					 , SC.PLANT_NAME
					 , SC.ATTRIBUTE2 AS DUMMY_YN
					 , SC.VALID_YN	 
				  FROM SCP_MST_CAPA_LINE SC WITH(NOLOCK)
				 WHERE 1=1
				   AND SC.VALID_YN <> 'N'
				   AND SC.FACTORY_ID = '-'
						  --AND ((SC.ATTRIBUTE2 = 'N' AND SC.ATTRIBUTE1 = @p_shop_group_id) -- Dummy 아닌 경우
						  --  OR (SC.ATTRIBUTE2 = 'Y' AND SC.FACTORY_ID = '-') -- Dummy 인 경우 하위 ID가 ‘-‘임
						  --    )
				   AND SC.DIVISION_ID = @p_division_id 
				   AND SC.SITE_ID = @p_site_id
				   AND SC.COMPANY_ID = @p_company_id
				   --AND SC.ATTRIBUTE1 = @p_shop_group_id
				   AND SC.PLANT_ID <> '-'
				   */
					SELECT DISTINCT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.COMPANY_ID
						 , SC.COMPANY_NAME
						 , SC.PLANT_ID
						 , SC.PLANT_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN	 
					  FROM SCP_MST_CAPA_LINE SC WITH(NOLOCK)
					 WHERE 1=1
					   AND SC.VALID_YN <> 'N'
					   AND SC.FACTORY_ID = '-'
					   AND SC.DIVISION_ID = @p_division_id 
					   AND SC.SITE_ID = @p_site_id
					   AND SC.COMPANY_ID = @p_company_id
					   AND SC.PLANT_ID <> '-'
					UNION
					SELECT DISTINCT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.COMPANY_ID
						 , SC.COMPANY_NAME
						 , SC.PLANT_ID
						 , SC.PLANT_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN	 
					  FROM SCP_MST_CAPA_ELTR_LINE SC WITH(NOLOCK)
					 WHERE 1=1
					   AND SC.VALID_YN <> 'N'
					   AND SC.FACTORY_ID = '-'
					   AND SC.DIVISION_ID = @p_division_id 
					   AND SC.SITE_ID = @p_site_id
					   AND SC.COMPANY_ID = @p_company_id
					   AND SC.PLANT_ID <> '-'
			) LVL
		END
		ELSE IF @p_menu_level = 4
		BEGIN
			SELECT LVL.DIVISION_ID
				 , LVL.SITE_ID
				 , LVL.SITE_NAME
				 , LVL.COMPANY_ID
				 , LVL.COMPANY_NAME
				 , LVL.PLANT_ID
				 , LVL.PLANT_NAME
				 , LVL.FACTORY_ID
				 , LVL.FACTORY_NAME
				 , LVL.DUMMY_YN
				 , LVL.VALID_YN
				 , ROW_NUMBER() OVER(ORDER BY LVL.DIVISION_ID,LVL.SITE_ID,LVL.COMPANY_ID,LVL.PLANT_ID, LVL.FACTORY_ID) AS SORT_ORDER
			FROM (
					SELECT DISTINCT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.COMPANY_ID
						 , SC.COMPANY_NAME
						 , SC.PLANT_ID
						 , SC.PLANT_NAME
						 , SC.FACTORY_ID
						 , SC.FACTORY_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN	 
					  FROM SCP_MST_CAPA_LINE SC WITH(NOLOCK)
					 WHERE 1=1
					   AND SC.VALID_YN <> 'N'
						  AND (SC.ATTRIBUTE2 = 'N' -- Dummy 아닌 경우
						    OR (SC.ATTRIBUTE2 = 'Y' AND SC.LINE_ID = '-') -- Dummy 인 경우 하위 ID가 ‘-‘임
						      )
					   AND SC.DIVISION_ID = @p_division_id 
					   AND SC.SITE_ID = @p_site_id
					   AND SC.COMPANY_ID = @p_company_id
					   AND SC.PLANT_ID = @p_plant_id
					   AND SC.ATTRIBUTE1 = @p_shop_group_id
					   AND SC.FACTORY_ID <> '-'
				) LVL
		END
		ELSE IF @p_menu_level = 5
		BEGIN
			SELECT LVL.DIVISION_ID
				 , LVL.SITE_ID
				 , LVL.SITE_NAME
				 , LVL.COMPANY_ID
				 , LVL.COMPANY_NAME
				 , LVL.PLANT_ID
				 , LVL.PLANT_NAME
				 , LVL.FACTORY_ID
				 , LVL.FACTORY_NAME
				 , LVL.LINE_ID
				 , LVL.LINE_NAME
				 , LVL.SHOP_GROUP_ID
				 , LVL.DUMMY_YN
				 , LVL.VALID_YN
				 , ROW_NUMBER() OVER(ORDER BY LVL.DIVISION_ID,LVL.SITE_ID,LVL.COMPANY_ID,LVL.PLANT_ID, LVL.FACTORY_ID, LVL.LINE_ID) AS SORT_ORDER
			FROM (
					SELECT DISTINCT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.COMPANY_ID
						 , SC.COMPANY_NAME
						 , SC.PLANT_ID
						 , SC.PLANT_NAME
						 , SC.FACTORY_ID
						 , SC.FACTORY_NAME
						 , SC.LINE_ID
						 , SC.LINE_NAME
						 , SC.ATTRIBUTE1 AS SHOP_GROUP_ID
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN	 
					  FROM SCP_MST_CAPA_LINE SC WITH(NOLOCK)
					 WHERE 1=1
					   AND SC.VALID_YN <> 'N'
					   AND SC.DIVISION_ID = @p_division_id 
					   AND SC.SITE_ID = @p_site_id
					   AND SC.COMPANY_ID = @p_company_id
					   AND SC.PLANT_ID = @p_plant_id
					   AND SC.FACTORY_ID = @p_factory_id
					   AND (SC.ATTRIBUTE1 = @p_shop_group_id OR SC.ATTRIBUTE1 = 'D')
					   AND SC.LINE_ID <> '-'
				) LVL
		END
	END;
	ELSE
	BEGIN
		IF @p_menu_level = 1
		BEGIN
			SELECT LVL.DIVISION_ID
				 , LVL.SITE_ID
				 , LVL.SITE_NAME
				 , LVL.VALID_YN
				 , LVL.DUMMY_YN
				 , ROW_NUMBER() OVER(ORDER BY LVL.DIVISION_ID,LVL.SITE_ID) AS SORT_ORDER
			FROM (
			/*
					SELECT DISTINCT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN
						FROM SCP_MST_CAPA_ELTR_LINE SC WITH(NOLOCK)
						WHERE 1=1 
						  AND SC.VALID_YN <> 'N'
						  AND ((SC.ATTRIBUTE2 = 'N' AND SC.ATTRIBUTE1 = @p_shop_group_id) -- Dummy 아닌 경우
						    OR (SC.ATTRIBUTE2 = 'Y' AND SC.COMPANY_ID = '-') -- Dummy 인 경우 하위 ID가 ‘-‘임
						      )
						  AND SC.DIVISION_ID = @p_division_id
						  --AND SC.ATTRIBUTE1 = @p_shop_group_id
				  ) LVL
				  */
					SELECT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN
					  FROM SCP_MST_CAPA_LINE SC WITH(NOLOCK)						
					 WHERE 1=1 
					   AND SC.VALID_YN <> 'N'
					   AND SC.COMPANY_ID = '-'
					   AND SC.DIVISION_ID = @p_division_id
					 UNION
					SELECT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN
					  FROM SCP_MST_CAPA_ELTR_LINE SC WITH(NOLOCK)						
					 WHERE 1=1 
					   AND SC.VALID_YN <> 'N'
					   AND SC.COMPANY_ID = '-'
					   AND SC.DIVISION_ID = @p_division_id
				  ) LVL
		END
		ELSE IF @p_menu_level = 2
		BEGIN
			SELECT LVL.DIVISION_ID
				 , LVL.SITE_ID
				 , LVL.SITE_NAME
				 , LVL.COMPANY_ID
				 , LVL.COMPANY_NAME
				 , LVL.DUMMY_YN
				 , LVL.VALID_YN
				 , ROW_NUMBER() OVER(ORDER BY LVL.DIVISION_ID,LVL.SITE_ID,LVL.COMPANY_ID) AS SORT_ORDER
			FROM (
			/*
					SELECT DISTINCT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.COMPANY_ID
						 , SC.COMPANY_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN	 
					  FROM SCP_MST_CAPA_ELTR_LINE SC WITH(NOLOCK)
					 WHERE 1=1
					   AND SC.VALID_YN <> 'N'
						  AND ((SC.ATTRIBUTE2 = 'N' AND SC.ATTRIBUTE1 = @p_shop_group_id) -- Dummy 아닌 경우
						    OR (SC.ATTRIBUTE2 = 'Y' AND SC.PLANT_ID = '-') -- Dummy 인 경우 하위 ID가 ‘-‘임
						      )
					   AND SC.DIVISION_ID = @p_division_id 
					   AND SC.SITE_ID = @p_site_id
					   --AND SC.ATTRIBUTE1 = @p_shop_group_id
					   AND SC.COMPANY_ID <> '-'
				  */
					SELECT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.COMPANY_ID
						 , SC.COMPANY_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN	 
					  FROM SCP_MST_CAPA_LINE SC WITH(NOLOCK)					 
					 WHERE 1=1
					   AND SC.VALID_YN <> 'N'
					   AND SC.PLANT_ID = '-'
					   AND SC.DIVISION_ID = @p_division_id 
					   AND SC.SITE_ID = @p_site_id
					   AND SC.COMPANY_ID <> '-'
					UNION
					SELECT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.COMPANY_ID
						 , SC.COMPANY_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN	 
					  FROM SCP_MST_CAPA_ELTR_LINE SC WITH(NOLOCK)					 
					 WHERE 1=1
					   AND SC.VALID_YN <> 'N'
					   AND SC.PLANT_ID = '-'
					   AND SC.DIVISION_ID = @p_division_id 
					   AND SC.SITE_ID = @p_site_id
					   AND SC.COMPANY_ID <> '-'
				  ) LVL
		END
		ELSE IF @p_menu_level = 3
		BEGIN
			SELECT LVL.DIVISION_ID
				 , LVL.SITE_ID
				 , LVL.SITE_NAME
				 , LVL.COMPANY_ID
				 , LVL.COMPANY_NAME
				 , LVL.PLANT_ID
				 , LVL.PLANT_NAME
				 , LVL.DUMMY_YN
				 , LVL.VALID_YN
				 , ROW_NUMBER() OVER(ORDER BY LVL.DIVISION_ID,LVL.SITE_ID,LVL.COMPANY_ID,LVL.PLANT_ID) AS SORT_ORDER
			FROM (
			/*
				SELECT DISTINCT SC.DIVISION_ID
					 , SC.SITE_ID AS SITE_ID
					 , SC.SITE_NAME AS SITE_NAME
					 , SC.COMPANY_ID
					 , SC.COMPANY_NAME
					 , SC.PLANT_ID
					 , SC.PLANT_NAME
					 , SC.ATTRIBUTE2 AS DUMMY_YN
					 , SC.VALID_YN	 
				  FROM SCP_MST_CAPA_ELTR_LINE SC WITH(NOLOCK)
				 WHERE 1=1
				   AND SC.VALID_YN <> 'N'
						  AND ((SC.ATTRIBUTE2 = 'N' AND SC.ATTRIBUTE1 = @p_shop_group_id) -- Dummy 아닌 경우
						    OR (SC.ATTRIBUTE2 = 'Y' AND SC.FACTORY_ID = '-') -- Dummy 인 경우 하위 ID가 ‘-‘임
						      )
				   AND SC.DIVISION_ID = @p_division_id 
				   AND SC.SITE_ID = @p_site_id
				   AND SC.COMPANY_ID = @p_company_id
				   --AND SC.ATTRIBUTE1 = @p_shop_group_id
				   AND SC.PLANT_ID <> '-'
				   */
					SELECT DISTINCT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.COMPANY_ID
						 , SC.COMPANY_NAME
						 , SC.PLANT_ID
						 , SC.PLANT_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN	 
					  FROM SCP_MST_CAPA_LINE SC WITH(NOLOCK)
					 WHERE 1=1
					   AND SC.VALID_YN <> 'N'
					   AND SC.FACTORY_ID = '-'
					   AND SC.DIVISION_ID = @p_division_id 
					   AND SC.SITE_ID = @p_site_id
					   AND SC.COMPANY_ID = @p_company_id
					   AND SC.PLANT_ID <> '-'
					UNION
					SELECT DISTINCT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.COMPANY_ID
						 , SC.COMPANY_NAME
						 , SC.PLANT_ID
						 , SC.PLANT_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN	 
					  FROM SCP_MST_CAPA_ELTR_LINE SC WITH(NOLOCK)
					 WHERE 1=1
					   AND SC.VALID_YN <> 'N'
					   AND SC.FACTORY_ID = '-'
					   AND SC.DIVISION_ID = @p_division_id 
					   AND SC.SITE_ID = @p_site_id
					   AND SC.COMPANY_ID = @p_company_id
					   AND SC.PLANT_ID <> '-'
			) LVL
		END
		ELSE IF @p_menu_level = 4
		BEGIN
			SELECT LVL.DIVISION_ID
				 , LVL.SITE_ID
				 , LVL.SITE_NAME
				 , LVL.COMPANY_ID
				 , LVL.COMPANY_NAME
				 , LVL.PLANT_ID
				 , LVL.PLANT_NAME
				 , LVL.FACTORY_ID
				 , LVL.FACTORY_NAME
				 , LVL.DUMMY_YN
				 , LVL.VALID_YN
				 , ROW_NUMBER() OVER(ORDER BY LVL.DIVISION_ID,LVL.SITE_ID,LVL.COMPANY_ID,LVL.PLANT_ID, LVL.FACTORY_ID) AS SORT_ORDER
			FROM (
					SELECT DISTINCT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.COMPANY_ID
						 , SC.COMPANY_NAME
						 , SC.PLANT_ID
						 , SC.PLANT_NAME
						 , SC.FACTORY_ID
						 , SC.FACTORY_NAME
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN	 
					  FROM SCP_MST_CAPA_ELTR_LINE SC WITH(NOLOCK)
					 WHERE 1=1
					   AND SC.VALID_YN <> 'N'
						  AND (SC.ATTRIBUTE2 = 'N' -- Dummy 아닌 경우
						    OR (SC.ATTRIBUTE2 = 'Y' AND SC.LINE_ID = '-') -- Dummy 인 경우 하위 ID가 ‘-‘임
						      )
					   AND SC.DIVISION_ID = @p_division_id 
					   AND SC.SITE_ID = @p_site_id
					   AND SC.COMPANY_ID = @p_company_id
					   AND SC.PLANT_ID = @p_plant_id
					   AND SC.ATTRIBUTE1 = @p_shop_group_id
					   AND SC.FACTORY_ID <> '-'
				) LVL
		END
		ELSE IF @p_menu_level = 5
		BEGIN
			SELECT LVL.DIVISION_ID
				 , LVL.SITE_ID
				 , LVL.SITE_NAME
				 , LVL.COMPANY_ID
				 , LVL.COMPANY_NAME
				 , LVL.PLANT_ID
				 , LVL.PLANT_NAME
				 , LVL.FACTORY_ID
				 , LVL.FACTORY_NAME
				 , LVL.LINE_ID
				 , LVL.LINE_NAME
				 , LVL.SHOP_GROUP_ID
				 , LVL.DUMMY_YN
				 , LVL.VALID_YN
				 , ROW_NUMBER() OVER(ORDER BY LVL.DIVISION_ID,LVL.SITE_ID,LVL.COMPANY_ID,LVL.PLANT_ID, LVL.FACTORY_ID, LVL.LINE_ID) AS SORT_ORDER
			FROM (
					SELECT DISTINCT SC.DIVISION_ID
						 , SC.SITE_ID AS SITE_ID
						 , SC.SITE_NAME AS SITE_NAME
						 , SC.COMPANY_ID
						 , SC.COMPANY_NAME
						 , SC.PLANT_ID
						 , SC.PLANT_NAME
						 , SC.FACTORY_ID
						 , SC.FACTORY_NAME
						 , SC.LINE_ID
						 , SC.LINE_NAME
						 , SC.ATTRIBUTE1 AS SHOP_GROUP_ID
						 , SC.ATTRIBUTE2 AS DUMMY_YN
						 , SC.VALID_YN	 
					  FROM SCP_MST_CAPA_ELTR_LINE SC WITH(NOLOCK)
					 WHERE 1=1
					   AND SC.VALID_YN <> 'N'
					   AND SC.DIVISION_ID = @p_division_id 
					   AND SC.SITE_ID = @p_site_id
					   AND SC.COMPANY_ID = @p_company_id
					   AND SC.PLANT_ID = @p_plant_id
					   AND SC.FACTORY_ID = @p_factory_id
					   AND SC.ATTRIBUTE1 = @p_shop_group_id
					   AND SC.LINE_ID <> '-'
				) LVL
		END
	END;

	BEGIN
	IF OBJECT_ID('tempdb..#T_SCP0109_RAW') IS NOT NULL
		DROP TABLE #T_SCP0109_RAW;
	END
END