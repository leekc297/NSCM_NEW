CREATE FUNCTION [dbo].[FN_CHAR_TO_DATE](@P_YYYYMMDD VARCHAR(8))
      RETURNS DATETIME
AS
/****************************************************************************
  * PROJECT       : LG CHEM RCCP PRJ.
  * FUNCTION NAME : FN_TO_DATE
  * DESCRIPTION   : 년월일 기준으로 DATETIME으로 변환하여 리턴한다. 
  *
  * INPUT         : @P_YYYYMMDD : 년월일
  * OUTPUT        : DATETIME
  * USAGE         : SELECT DBO.FN_GET_YYYYWW('20160530')
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2016-05-31   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
   DECLARE @X_DATE DATETIME

   SET @X_DATE = CONVERT(DATETIME,@P_YYYYMMDD,112)    
	
  RETURN  @X_DATE;

END
;
