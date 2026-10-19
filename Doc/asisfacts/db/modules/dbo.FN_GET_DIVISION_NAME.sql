CREATE FUNCTION [dbo].[FN_GET_DIVISION_NAME]
(@P_DIVISION_ID nvarchar(MAX))
RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_DIVISION_NAME
  * DESCRIPTION   : DIVISION NAME를 반환한다. 
  *
  * INPUT         : @str1 : DIVISION ID
  * OUTPUT        : DIVISION NAME
  * USAGE         : SELECT DBO.FN_GET_DIVISION_NAME('40')
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2017-01-17   kth        INITIAL
  ****************************************************************************/
BEGIN
DECLARE @retVal nvarchar(max);

	set @retVal = (select TOP 1 DIVISION_NAME from SCM_MST_DIVISION where DIVISION_ID = @P_DIVISION_ID)

	RETURN @retVal;
END
