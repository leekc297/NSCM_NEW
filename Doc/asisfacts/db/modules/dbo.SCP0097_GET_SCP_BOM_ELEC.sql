

/*
 * Program ID   : SCP0097_GET_SCP_BOM_ELEC
 * Description  : SCP BOM ELEC 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023/02/16       jahn1501        PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제  Initial Release
 * 2023/03/06       vadabi3         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제  [컬럼제거 : PLANT_ID, 컬럼추가 : ELECTRODE_TYPE]
 */

CREATE PROCEDURE [dbo].[SCP0097_GET_SCP_BOM_ELEC]
   @p_division_id		 NVARCHAR(MAX)
  ,@p_parent_id          NVARCHAR(MAX)
  ,@p_child_id           NVARCHAR(MAX)
  ,@debug_mode			 NVARCHAR(20)  = 'F'
  
AS

BEGIN
	
	SET NOCOUNT ON; 

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT A.DIVISION_ID
		 , A.PARENT_ITEM_ID
		 , (
				SELECT TOP 1
					   ISNULL(NULLIF(NICK_NAME,''),'-')
				  FROM SCM_MST_ITEM_SN X(NOLOCK)
				 WHERE X.DIVISION_ID = A.DIVISION_ID
				   AND X.ITEM_ID     = A.PARENT_ITEM_ID
		   ) AS PARENT_ITEM_NAME
		 , A.CHILD_ITEM_ID
		 , (
				SELECT TOP 1
					   ISNULL(NULLIF(NICK_NAME,''),'-')
				  FROM SCM_MST_ITEM_SN X(NOLOCK)
				 WHERE X.DIVISION_ID = A.DIVISION_ID
				   AND X.ITEM_ID     = A.CHILD_ITEM_ID
		   ) AS CHILD_ITEM_NAME		 
		 , ROUND(A.[USAGE],3) AS USAGE
		 , A.SCP_YN
		 , A.STOCK_SUM
		 , A.ELECTRODE_TYPE
		 , A.CREATED_BY
		 , A.CREATION_DATE
		 , A.LAST_UPDATED_BY
		 , A.LAST_UPDATE_DATE
	  FROM SCP_MST_BOM_ELEC A WITH(NOLOCK)
	 WHERE 1=1
	   AND A.DIVISION_ID  = @p_division_id
	   AND ( (@p_parent_id IS NULL OR @p_parent_id = '') OR A.PARENT_ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_parent_id  ,',')) )	   
	   AND ( (@p_child_id IS NULL OR @p_child_id = '') OR A.CHILD_ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_child_id  ,',')) )
	 ORDER BY A.DIVISION_ID, A.PARENT_ITEM_ID, A.ELECTRODE_TYPE, A.CHILD_ITEM_ID
END

