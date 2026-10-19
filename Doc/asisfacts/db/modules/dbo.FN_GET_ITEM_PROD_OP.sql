
/****************************************************************************
  * FUNCTION NAME : FN_GET_ITEM_PROD_OP
  * DESCRIPTION   : ITEM_ID_ASSY 로 ITEM_PROD 찾기
  * INPUT         : P_DIVISION_ID,P_ITEM_ID
  * OUTPUT        : ITEM_PROD
  * PROGRAM HISTORY
  *--------------------------------------------------------------
    DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2023-08-02   vadabi3        INITIAL
  ****************************************************************************/


CREATE FUNCTION [dbo].[FN_GET_ITEM_PROD_OP]
      (
       @P_DIVISION_ID      NVARCHAR(30),
       @P_OPERATION_GROUP  NVARCHAR(30),
       @P_ITEM_ID          NVARCHAR(150)                      
       )
       RETURNS NVARCHAR(MAX)
       WITH EXEC AS CALLER       
AS

BEGIN
  
   DECLARE @X_ITEM_ID_PROD NVARCHAR(100)='';

   -- CELL, PaCK, 전극 중 CELL일 경우만 체크
   IF(@P_OPERATION_GROUP != 'A')
      RETURN  @P_ITEM_ID;

     -- VALID_YN 이 조건에 없어 Multi row 리턴 될 수 있어 Top 1 Return
	 -- 20230804 값이 Null 인 경우 입력 받은 값 리턴
     SELECT TOP 1 @X_ITEM_ID_PROD       = ISNULL(ITEM_ID_PROD, @P_ITEM_ID)
		   FROM DBO.SCP_MST_CELL_PROD_ASSY_MAP WITH(NOLOCK)
		  WHERE 1=1
		    AND DIVISION_ID          = @P_DIVISION_ID
		    AND ITEM_ID_ASSY         = @P_ITEM_ID
     ORDER BY ISNULL(ITEM_ID_PROD, @P_ITEM_ID) DESC

   IF(@X_ITEM_ID_PROD = '')
        set @X_ITEM_ID_PROD = @P_ITEM_ID;


   RETURN  @X_ITEM_ID_PROD;

END
;
