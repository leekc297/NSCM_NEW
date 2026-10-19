CREATE FUNCTION [dbo].[FN_GET_SCP_CELL_TYPE_SORT]
      ( @p_cell_type         nvarchar(50))

      RETURNS INT
AS
/*
 * Program ID   : FN_GET_SCP_CELL_TYPE_SORT  
 * Description  : [활성화] Final Item) Cell Type 기준 Sort 적용 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.06.14   vadabi3         Initial Release 
 */
BEGIN
  
  DECLARE @x_sort           int = 0;  

   SELECT @x_sort = CASE WHEN @p_cell_type = 'CP'  THEN 100000
						 WHEN @p_cell_type = 'CA1' THEN 200000
						 WHEN @p_cell_type = 'CA2' THEN 300000
						 WHEN @p_cell_type = ''    THEN 400000
						 ELSE 0
						  END
   
  RETURN @x_sort;

END
;
