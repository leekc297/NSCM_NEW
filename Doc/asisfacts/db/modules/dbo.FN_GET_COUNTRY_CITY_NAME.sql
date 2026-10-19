create FUNCTION [dbo].[FN_GET_COUNTRY_CITY_NAME]
(
 @P_DIVISION_ID nvarchar(MAX)
,@P_SCM_SITE_ID nvarchar(MAX)
,@P_RET_TYPE  nvarchar(MAX)
)

RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : [FN_GET_COUNTRY_CITY_NAME]
  * DESCRIPTION   : SCM_SITE의 COUNTRY, CITY명을 반환
  *
  * INPUT         : @P_DIVISION_ID : DIVISION 
					@P_SCM_SITE_ID : SCM_SITE_ID
					@P_RET_TYPE    : 'C':국가명,'T' : 도시명 
  * OUTPUT        : DIVISION NAME
  * USAGE         : SELECT DBO.[FN_GET_COUNTRY_CITY_NAME]('81','Audi_DE_ING','T')
			        SELECT DBO.[FN_GET_COUNTRY_CITY_NAME]('81','Audi_DE_ING','C')
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-03-23   PJS        INITIAL
  ****************************************************************************/
BEGIN



	DECLARE @result_country nvarchar(1000);
	DECLARE @result_city nvarchar(1000);
	DECLARE @result nvarchar(1000);

	SET @result_country='';
	SET @result_city='';
  	SET @result='';

	SELECT TOP 1 
	       @result_country=country
		  ,@result_city= city 
	 FROM scm_mst_site A 
	WHERE 1=1
	  AND A.division_id= @P_DIVISION_ID
	  AND A.scm_site_id =@P_SCM_SITE_ID

	IF(@P_RET_TYPE ='C')
		SET @result= @result_country;
	ELSE 
		SET @result=  @result_city;
	
	RETURN @result;
END
