
CREATE FUNCTION [dbo].[FN_GET_SSP_SITE_INFO]
(
 @p_division_id nvarchar(MAX)
,@p_scm_site_id nvarchar(MAX)
,@p_return_type  nvarchar(MAX)
)

RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
/****************************************************************************
  * FUNCTION NAME : [FN_GET_SSP_SITE_INFO]
  * DESCRIPTION   : ERP전송을 위한 SITE 정보 
  * INPUT         : @@p_division_id : DIVISION 
					@@p_scm_site_id : SCM_SITE_ID
					@@p_return_type : SITE_TYPE, PLANT_ID, VENDOR_ID, SOLDTO_CODE, SHIPTO_CODE, COMPANY_ID , COUNTRY, VMI_YN
  * USAGE         : SELECT DBO.[FN_GET_SSP_SITE_INFO]('81','JLR_GB_GAY','SITE_TYPE')
			        SELECT DBO.[FN_GET_SSP_SITE_INFO]('81','JLR_GB_GAY','SOLDTO_CODE')
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018.11.26   juhlee     Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
  ****************************************************************************/
BEGIN

	DECLARE @site_type   NVARCHAR(100)= '';
	DECLARE @plant_id    NVARCHAR(100)= '';
	DECLARE @vendor_id   NVARCHAR(100)= '';
	DECLARE @soldto_code NVARCHAR(100)= '';
	DECLARE @shipto_code NVARCHAR(100)= '';
    DECLARE @company_id  NVARCHAR(100)= '';
	DECLARE @country     NVARCHAR(100)= '';
	DECLARE @vmi_yn      NVARCHAR(100)= '';

	DECLARE @result nvarchar(100)= '';

	SELECT  TOP 1
			@site_type   = CASE WHEN MS.SITE_TYPE = 'SALES' THEN 'A'                     -- Sales Site' 
						  	    WHEN MS.SITE_TYPE = 'PLANT' AND MS.OSP_YN = 'N' THEN 'B' -- Factory Site
							    WHEN MS.SITE_TYPE = 'PLANT' AND MS.OSP_YN = 'Y' THEN 'C' -- Packer
						   END 
	,       @plant_id    = MS.LOGISTIC_PLANT_ID     
	,       @vendor_id   = CASE WHEN MS.SITE_TYPE = 'PLANT' AND MS.OSP_YN = 'Y' THEN MS.PLANT_ID END                                                                              
	,       @soldto_code = SC.SOLDTO_CODE                                                                   
	,       @shipto_code = SC.SHIPTO_CODE         
	,       @company_id  = MS.COMPANY_ID   
	,       @country     = MS.COUNTRY    
	,       @vmi_yn      = MS.VMI_YN  
	FROM   SCM_MST_SITE MS WITH(NOLOCK) 
	LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER SC  WITH(NOLOCK)
				ON  SC.DIVISION_ID = MS.DIVISION_ID --'81'
				AND SC.SCM_SITE_ID = MS.SCM_SITE_ID -- 'JLR_GB_GAY'
				AND SC.VALID_YN    = 'Y'
				AND SC.REP_YN      = 'Y'
	WHERE  MS.DIVISION_ID = @p_division_id --  '81'
	AND    MS.SCM_SITE_ID = @p_scm_site_id  -- 'JLR_GB_GAY' 
	AND    MS.VALID_YN    = 'Y' 
	;

	
	IF(@p_return_type ='SITE_TYPE')
		SET @result= @site_type ;

	ELSE IF(@p_return_type ='PLANT_ID')
		SET @result=  @plant_id;

	ELSE IF(@p_return_type ='VENDOR_ID')
		SET @result=  @vendor_id;	

	ELSE IF(@p_return_type ='SOLDTO_CODE')
		SET @result=  @soldto_code;	

	ELSE IF(@p_return_type ='SHIPTO_CODE')
		SET @result=  @shipto_code;	

	ELSE IF(@p_return_type ='COMPANY_ID')
		SET @result=  @company_id;	

	ELSE IF(@p_return_type ='COUNTRY')
		SET @result=  @country;	

	ELSE IF(@p_return_type ='VMI_YN')
		SET @result=  @vmi_yn;	

    ELSE
	    SET @result=  NULL ;	
	RETURN @result;
END

