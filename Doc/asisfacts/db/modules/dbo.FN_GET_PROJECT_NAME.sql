CREATE FUNCTION [dbo].[FN_GET_PROJECT_NAME]
      (
       @P_DIVISION_ID      NVARCHAR(30),
       @P_PROJECT_CODE     NVARCHAR(150)                      
       )
       RETURNS NVARCHAR(1000)
       WITH EXEC AS CALLER       
AS

/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_PROJECT_NAME
  * DESCRIPTION   : PROJECT NAME RETURN
  * INPUT         : P_DIVISION_ID,P_PROJECT_CODE
  * OUTPUT        : NICK NAME
  * PROGRAM HISTORY
  *--------------------------------------------------------------
    DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-01-30   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
   DECLARE @X_PROJECT_NAME NVARCHAR(100)='';

   
     SELECT TOP 1 @X_PROJECT_NAME   = ISNULL(PROJECT_NAME,'')
		   FROM DBO.SCM_MST_PROJECT WITH(NOLOCK)
		  WHERE 1=1
		    AND DIVISION_ID          = @P_DIVISION_ID
		    AND PROJECT_CODE         = @P_PROJECT_CODE;
		    
   RETURN  ISNULL(@X_PROJECT_NAME,'');

END
;
