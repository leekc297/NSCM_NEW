CREATE FUNCTION [dbo].[FN_LEAST](@P_VAL1 SQL_VARIANT,@P_VAL2 SQL_VARIANT)
      RETURNS SQL_VARIANT
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : [FN_LEAST]
  * DESCRIPTION   : 2개의 숫자중에 작은값을 리턴한다. 
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2016-11-23   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
  RETURN  (CASE WHEN @P_VAL1 <  @P_VAL2 THEN @P_VAL1 ELSE @P_VAL2 END);

END
;
