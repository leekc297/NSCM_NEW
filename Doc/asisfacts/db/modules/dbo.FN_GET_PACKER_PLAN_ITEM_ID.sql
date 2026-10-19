CREATE FUNCTION [dbo].[FN_GET_PACKER_PLAN_ITEM_ID]
(
  @p_division_id      NVARCHAR(30)
 ,@p_item_id          NVARCHAR(50)
)
  RETURNS NVARCHAR(100)
  WITH EXEC AS CALLER       
AS
/*
 * Program ID   : FN_GET_PACKER_PLAN_ITEM_ID
 * Description  : 소형 대표 ITEM_ID 리턴
 * Program History
 *===================================================================================================
 *   Date        In Charge     Description
 *===================================================================================================
 * 2018.06.26    Kim Jaejung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 
 */
BEGIN
  
  DECLARE @x_item_id NVARCHAR(50)= NULL;

  BEGIN

    SELECT @x_item_id = fi.packer_plan_item_id
    FROM   scp_mst_final_item fi WITH(NOLOCK)
    WHERE  fi.division_id = @p_division_id
    AND    fi.item_id     = @p_item_id
    ;
				   
  END

  IF (@x_item_id IS NULL)
    SET @x_item_id = @p_item_id;

  RETURN  @x_item_id;

END
;
