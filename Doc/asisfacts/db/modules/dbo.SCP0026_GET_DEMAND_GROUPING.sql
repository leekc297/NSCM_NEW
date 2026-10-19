
/*
 * Program ID   : [SCP0026_GET_DEMAND_GROUPING]
 * Description  : Demand Grouping 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/18   byunghunjung   Initial Release  전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
  */

CREATE PROCEDURE [dbo].[SCP0026_GET_DEMAND_GROUPING] 
	
@p_division_id nvarchar(30) ,
@p_operation_group nvarchar(30) ,
@p_item_id nvarchar(500)

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

SELECT division_id
      ,item_id
      ,nick_name
      ,item_class
      ,operation_group
      ,operation_group_id
	  ,dbo.fn_get_lookup_code_desc('OPERATION_GROUP',operation_group) operation_group_name
      ,electrode_type
      ,flow_id
      ,demand_grouping_days
      ,created_by
      ,creation_date
      ,last_updated_by
      ,last_update_date
  FROM SCP_MST_FINAL_ITEM
  WHERE 1=1
  AND division_id       = @p_division_id
  And operation_group   = @p_operation_group
  And ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR item_id IN (SELECT token FROM dbo.String_Split(@p_item_id  ,',')) )
  Order by division_id, operation_group, item_id
  
END
