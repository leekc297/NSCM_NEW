
CREATE FUNCTION [dbo].[FN_GET_SITE_NAME]
(@str1 nvarchar(MAX), @str2 nvarchar(MAX))
RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_SITE_NAME
  * DESCRIPTION   : SITE NAME를 반환한다. 
  *
  * INPUT         : @str1 : COMPANY_ID, @str2 : SITE_ID
  * OUTPUT        : SITE NAME
  * USAGE         : SELECT DBO.FN_GET_SITE_NAME('C100','A001') 
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2017-01-17   kth        INITIAL
  ****************************************************************************/
BEGIN
DECLARE @retVal nvarchar(max);

	set @retVal = (select SITE_NAME from SCM_MST_SITE_SN where COMPANY_ID = @str1 and SITE_ID = @str2 group by SITE_NAME)

	RETURN @retVal;
END
