
CREATE FUNCTION [dbo].[FN_GET_SCM_SITE_DESCRIPTION]
(@str1 nvarchar(MAX), @str2 nvarchar(MAX))
RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_SCM_SITE_DESCRIPTION
  * DESCRIPTION   : SITE DESCRIPTION를 반환한다. 
  *
  * INPUT         : @str1 : DIVISION_ID, @str2 : SCM_SITE_ID
  * OUTPUT        : SITE_DESCRIPTION
  * USAGE         : SELECT DBO.FN_GET_SCM_SITE_DESCRIPTION('81','A040-A') 
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2017-01-17   KTH        INITIAL
  * 2018-07-05   byunghunjung EE사업부는 division 정보가 없으므로 param에서 division제외
  * 2018-07-06   ygkim      SITE_DESCRIPTION MAX로 가져오는걸로 수정(EE 사업부 추가로 인해 수정)
  ****************************************************************************/
BEGIN
DECLARE @retVal nvarchar(max);

	set @retVal = (select max(SITE_DESCRIPTION)
					 from SCM_MST_SITE 
				    where 1=1 -- DIVISION_ID = @str1 
					  and SCM_SITE_ID = @str2 group by SCM_SITE_ID)

	RETURN @retVal;
END



