CREATE FUNCTION [dbo].[FN_GET_COUNTRY_KR_NAME]
(
 @P_COUNTRY_CODE NCHAR(2)
)

RETURNS NVARCHAR(50)
WITH EXEC AS CALLER
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : [FN_GET_COUNTRY_KR_NAME]
  * DESCRIPTION   : COUNTRY 약어를 받아서 KR_NAME 을 리턴함
  *
  * INPUT         : @P_COUNTRY_CODE : 2자리 약어
  * OUTPUT        : COUNTRY_KR_NAME
  * USAGE         : SELECT DBO.[FN_GET_COUNTRY_KR_NAME]('DE')
			        SELECT DBO.[FN_GET_COUNTRY_KR_NAME]('KR')
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2021-05-04   HWI1993	INITIAL
  ****************************************************************************/
BEGIN



	DECLARE @RESULT_NAME NVARCHAR(50)

	SELECT @RESULT_NAME = A.COUNTRY_KR_NAME
	 FROM SCM_MST_COUNTRY A 
	WHERE A.COUNTRY = @P_COUNTRY_CODE

	
	RETURN @RESULT_NAME;
END
