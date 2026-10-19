CREATE FUNCTION [dbo].[FN_DATE_TO_CHAR](@P_DATE DATETIME)
      RETURNS VARCHAR(8)
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_TO_DATE
  * DESCRIPTION   : 년월일 기준으로 DATETIME으로 변환하여 리턴한다. 
  *
  * INPUT         : @P_YYYYMMDD : 년월일
  * OUTPUT        : DATETIME
  * USAGE         : SELECT DBO.FN_DATE_TO_CHAR(GETDATE())
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2016-05-31   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
   DECLARE @X_YYYYMMDD CHAR(8)

   SET @X_YYYYMMDD = CONVERT(CHAR(8),@P_DATE,112)    
	
  RETURN  @X_YYYYMMDD;

END
;
