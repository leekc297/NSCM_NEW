CREATE FUNCTION [dbo].[FN_GET_WEEK_ENG](@P_WEEK INT)
      RETURNS VARCHAR(8)
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_WEEK_ENG
  * DESCRIPTION   : 숫자로된 요일을 영문으로 반환해준다.
  *
  * INPUT         : @P_WEEK : 요일
  * OUTPUT        : 영문 요일
  * USAGE         : SELECT DBO.FN_GET_WEEK_ENG(1)
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-02-23   YGKIM        INITIAL
  ****************************************************************************/
BEGIN
  
  DECLARE @X_RETURN VARCHAR(8) 
  
	IF @P_WEEK = 1
		SET @X_RETURN = 'SUN';
	ELSE IF @P_WEEK = 2
		SET @X_RETURN = 'MON';
	ELSE IF @P_WEEK = 3
		SET @X_RETURN = 'TUE';
	ELSE IF @P_WEEK = 4
		SET @X_RETURN = 'WED';
	ELSE IF @P_WEEK = 5
		SET @X_RETURN = 'THU';
	ELSE IF @P_WEEK = 6
		SET @X_RETURN = 'FRI';
	ELSE IF @P_WEEK = 7
		SET @X_RETURN = 'SAT';

  RETURN @X_RETURN;

END
;



