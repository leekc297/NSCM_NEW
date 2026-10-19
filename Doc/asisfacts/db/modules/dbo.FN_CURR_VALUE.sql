CREATE FUNCTION [dbo].[FN_CURR_VALUE](@P_SEQUENCE_NAME  VARCHAR(100))
      RETURNS INT
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_CURR_VALUE
  * DESCRIPTION   : sequence의 current value를 리턴한다. 
  *
  * INPUT         : N/A
  * OUTPUT        : INT
  * USAGE         : SELECT FN_CURR_VALUE(SEQUENCE_NAME)
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2016-06-24   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
   DECLARE @X_CURR_VALUE INT

   SELECT @X_CURR_VALUE = CONVERT(INT,CURRENT_VALUE) 
     FROM SYS.SEQUENCES
    WHERE NAME = @P_SEQUENCE_NAME;
	
  RETURN  @X_CURR_VALUE;

END
;

