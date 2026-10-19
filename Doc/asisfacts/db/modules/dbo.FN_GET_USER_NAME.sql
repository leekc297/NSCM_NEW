CREATE FUNCTION [dbo].[FN_GET_USER_NAME]
(@str1 nvarchar(MAX))
RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_USER_NAME
  * DESCRIPTION   : USER NAME를 반환한다. 
  *
  * INPUT         : @str1 : USER_ID
  * OUTPUT        : USER NAME
  * USAGE         : SELECT DBO.FN_GET_USER_NAME('A100480') 
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2017-01-17   kth        INITIAL
  ****************************************************************************/
BEGIN
DECLARE @retVal nvarchar(max);

	set @retVal = (select USER_NAME from SCM_MST_SSO_USER_INFO where USER_ID = @str1 group by USER_NAME)
--  set @retVal = (select (CASE WHEN @str2 = 'EN' THEN ISNULL(LTRIM(RTRIM(USER_NAME_EN)),USER_NAME)  ELSE USER_NAME END) from SCM_MST_SSO_USER_INFO where USER_ID = @str1)

	RETURN @retVal;
END

