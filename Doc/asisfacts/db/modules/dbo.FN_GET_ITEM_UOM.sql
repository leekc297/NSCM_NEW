CREATE FUNCTION [dbo].[FN_GET_ITEM_UOM]
      (
       @P_DIVISION_ID      NVARCHAR(30),
       @P_ITEM_ID          NVARCHAR(150)                      
       )
       RETURNS NVARCHAR(100)
       WITH EXEC AS CALLER       
AS

/*
 * PROJECT       : LG CHEM SCP PRJ.
 * FUNCTION NAME : FN_GET_ITEM_UOM
 * DESCRIPTION   : UOM  RETURN
 * INPUT         : P_DIVISION_ID,P_ITEM_ID
 * OUTPUT        : UOM
 * PROGRAM HISTORY
 *--------------------------------------------------------------
   DATE      IN CHARGE           DESCRIPTION
 *--------------------------------------------------------------
 * 2018-02-06   YYDOK        INITIAL
 *
 */
 
BEGIN
  
   DECLARE @X_UOM NVARCHAR(100)='';

   
     SELECT TOP 1 @X_UOM   = ISNULL(ITEM_UOM,'')
		   FROM DBO.SCM_MST_ITEM_SN WITH(NOLOCK)
		  WHERE 1=1
		    AND DIVISION_ID          = @P_DIVISION_ID
		    AND ITEM_ID              = @P_ITEM_ID;
		    
   RETURN  ISNULL(@X_UOM,'');

END
;
