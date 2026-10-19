CREATE FUNCTION [dbo].[FN_ZERO_LPAD](@P_STRING VARCHAR(255), @P_INT INT)
       RETURNS VARCHAR(255)
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_ZERO_LPAD
  * DESCRIPTION   : 특정자릿수만큼 왼쪽에 0을 붙여서 리턴한다.
  *
  * INPUT         : @P_STRING : 문자열,@X_INT 자릿수
  * OUTPUT        : 0으로 자릿수만큼 LPAD처리한 문자열
  * USAGE         : SELECT DBO.FN_ZERO_LPAD('1',2) RETURNS '01'
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2016-05-30   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
   RETURN IsNULL(REPLICATE('0',@P_INT-LEN(@P_STRING)),'')+@P_STRING;

END
;
