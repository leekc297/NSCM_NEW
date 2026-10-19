

CREATE FUNCTION [dbo].[FN_GET_FINAL_ITEM]
      ( @P_DIVISION_ID  NVARCHAR(30), 
		@P_ITEM_ID         NVARCHAR(50),
		@CATEGORY			NVARCHAR(30)
	  )
      RETURNS NVARCHAR(1000)
AS
/*
 * Program ID   : FN_GET_FINAL_ITEM
 * Description  :  최종품목의  카테고리별(cell_sort, Cell_Type, IS_CA등) 관련정보 반환
 * 사용례		
    SELECT DBO.FN_GET_FINAL_ITEM('81', 'AAEF1047I-A1', 'CELL_SORT') => '2'
 * Program History
 *===================================================================================================
 *   Date			In Charge			Description
 *===================================================================================================
 * 2023.06.15   luckydohan         Initial Release 
 */
BEGIN
  
  DECLARE @RES           NVARCHAR(100) ;  

  IF @CATEGORY = 'CELL_SORT'
  BEGIN
   SET @RES = '9'
   SELECT @RES =	CASE WHEN ATTRIBUTE8 = 'CP'  THEN '1'
			WHEN ATTRIBUTE8 = 'CA1' THEN '2'
			WHEN ATTRIBUTE8 = 'CA2' THEN '3'
			WHEN ATTRIBUTE8 = ''    THEN '4'
			ELSE '9'  END
	FROM [dbo].[SCP_MST_FINAL_ITEM] with (nolock)
  WHERE DIVISION_ID = @P_DIVISION_ID AND ITEM_ID = @P_ITEM_ID   
  END

  IF @CATEGORY = 'CELL_TYPE'
  BEGIN
   SELECT @RES =	ATTRIBUTE8
	FROM [dbo].[SCP_MST_FINAL_ITEM] with (nolock)
  WHERE DIVISION_ID = @P_DIVISION_ID AND ITEM_ID = @P_ITEM_ID   
  END

  IF @CATEGORY = 'IS_CA'
  BEGIN
   SELECT @RES =	CASE WHEN LEFT(ATTRIBUTE8, 2) = 'CA' THEN 'Y' ELSE 'N' END
	FROM [dbo].[SCP_MST_FINAL_ITEM] with (nolock)
  WHERE DIVISION_ID = @P_DIVISION_ID AND ITEM_ID = @P_ITEM_ID   
  END

    RETURN ISNULL(@RES, '');

END
;
