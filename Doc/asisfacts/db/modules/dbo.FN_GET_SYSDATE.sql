CREATE FUNCTION [dbo].[FN_GET_SYSDATE]()
      RETURNS DATETIME
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_SYSDATE
  * DESCRIPTION   : 시스템의 DATETIME을 리턴한다. 
  *
  * INPUT         : N/A
  * OUTPUT        : DATETIME
  * USAGE         : SELECT FN_GET_SYSDATE
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2016-05-31   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
   DECLARE @X_DATE DATETIME

   SET @X_DATE = SYSDATETIME()  
	
  RETURN  @X_DATE;

END
;
