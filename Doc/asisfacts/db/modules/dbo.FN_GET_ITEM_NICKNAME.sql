CREATE FUNCTION [dbo].[FN_GET_ITEM_NICKNAME]
      (
       @P_DIVISION_ID      NVARCHAR(30),
       @P_ITEM_ID          NVARCHAR(150)                      
       )
       RETURNS NVARCHAR(100)
       WITH EXEC AS CALLER       
AS

/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_ITEM_NICKNAME
  * DESCRIPTION   : NICK NAME RETURN
  * INPUT         : P_DIVISION_ID,P_ITEM_ID
  * OUTPUT        : NICK NAME
  * PROGRAM HISTORY
  *--------------------------------------------------------------
    DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-01-17   YYDOK        INITIAL
  * 2018-07-15   byunghunjung EE사업부는 division 정보가 없으므로 param에서 division제외
  * 2021-05-17   khj79           nick name null 인 item 추가되어 조건 추가
  ****************************************************************************/
BEGIN
  
   DECLARE @X_NICK_NAME NVARCHAR(100)='';

   
     SELECT TOP 1 @X_NICK_NAME       = ISNULL(NICK_NAME,'')
		   FROM DBO.SCM_MST_ITEM_SN WITH(NOLOCK)
		  WHERE 1=1
		   -- AND DIVISION_ID          = @P_DIVISION_ID
		    AND ITEM_ID              = @P_ITEM_ID
			AND NICK_NAME IS NOT NULL;
		    
   RETURN  ISNULL(@X_NICK_NAME,'');

END
;
