
CREATE FUNCTION [dbo].[FN_GET_MEASURE_CODE]
      (
       @P_COLUMN_LABEL_NAME      NVARCHAR(150)                
       )
       RETURNS NVARCHAR(200)
       WITH EXEC AS CALLER       
AS

/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_MEASURE_CODE
  * DESCRIPTION   : FN_GET_MEASURE_CODE(MEASURE CODE) RETURN
  * INPUT         : COLUMN_LABEL_NAME
  * OUTPUT        : COLUMN_NAME
  * USAGE         : SELECT DBO.FN_GET_MEASURE_CODE('POD Plan')
  * PROGRAM HISTORY
  *--------------------------------------------------------------
    DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-01-23   KTH              INITIAL
  ****************************************************************************/
BEGIN
  
   DECLARE @X_COLUMN_NAME NVARCHAR(200)='';

     SELECT TOP 1 @X_COLUMN_NAME       = ISNULL(COLUMN_NAME,'')
		   FROM DBO.SCM_MST_SHEET_MEASURE WITH(NOLOCK)
		  WHERE 1=1
		    AND COLUMN_LABEL_NAME          = @P_COLUMN_LABEL_NAME
		    
   RETURN  ISNULL(@X_COLUMN_NAME,'');

END
;


