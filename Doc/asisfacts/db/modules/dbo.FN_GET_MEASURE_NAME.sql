
CREATE FUNCTION [dbo].[FN_GET_MEASURE_NAME]
      (
       @P_COLUMN_NAME      NVARCHAR(200)                
       )
       RETURNS NVARCHAR(150)
       WITH EXEC AS CALLER       
AS

/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_MEASURE_NAME
  * DESCRIPTION   : COLUMN_LABEL_NAME(MEASURE NAME) RETURN
  * INPUT         : P_COLUMN_NAME
  * OUTPUT        : COLUMN_LABEL_NAME
  * USAGE         : SELECT DBO.FN_GET_MEASURE_NAME('SHIP_PLAN')
  * PROGRAM HISTORY
  *--------------------------------------------------------------
    DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-01-23   KTH              INITIAL
  ****************************************************************************/
BEGIN
  
   DECLARE @X_COLUMN_LABEL_NAME NVARCHAR(150)='';

     SELECT TOP 1 @X_COLUMN_LABEL_NAME       = ISNULL(COLUMN_LABEL_NAME,'')
		   FROM DBO.SCM_MST_SHEET_MEASURE WITH(NOLOCK)
		  WHERE 1=1
		    AND COLUMN_NAME          = @P_COLUMN_NAME
		    
   RETURN  ISNULL(@X_COLUMN_LABEL_NAME,'');

END
;


