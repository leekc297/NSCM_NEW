CREATE FUNCTION [dbo].[FN_GET_PLANT_NAME]
(@str1 nvarchar(MAX), @str2 nvarchar(MAX), @str3 nvarchar(MAX), @str4 nvarchar(MAX))
RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_PLANT_NAME
  * DESCRIPTION   : PLANT NAME를 반환한다. 
  *
  * INPUT         : @str1 : COMPANY_ID, @str2 : DIVISION_ID, @str3 : SITE_ID, @str4 : PLANT_ID
  * OUTPUT        : PLANT NAME
  * USAGE         : SELECT DBO.FN_GET_PLANT_NAME('C100','81','A001','A041') 
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2017-01-17   kth        INITIAL
  ****************************************************************************/

BEGIN
DECLARE @retVal nvarchar(max);

	set @retVal = (select PLANT_NAME from SCM_MST_PLANT_SN where COMPANY_ID = @str1 and DIVISION_ID = @str2 and SITE_ID = @str3 and PLANT_ID = @str4 group by PLANT_NAME)
 
	RETURN @retVal;
END
