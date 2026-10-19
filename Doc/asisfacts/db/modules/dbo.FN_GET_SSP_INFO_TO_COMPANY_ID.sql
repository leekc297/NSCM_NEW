
CREATE FUNCTION [dbo].[FN_GET_SSP_INFO_TO_COMPANY_ID]
(
 @p_division_id nvarchar(MAX)
,@p_from_scm_site_id nvarchar(MAX)
,@p_to_scm_site_id nvarchar(MAX)
,@p_return_type nvarchar(MAX)
)

RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
/****************************************************************************
  * FUNCTION NAME : [FN_GET_SSP_INFO_TO_COMPANY_ID]
  * DESCRIPTION   : ERP전송을 위한 TO_COMPANY_ID의 예외 처리
  * 일반적으로 FN_GET_SSP_SITE_INFO 함수를 이용해서 TO_COMPANY_ID 정보를 획득한다.
  * 2025/07/08 자동차.마케팅,마케팅1.Ford티에서 WA법인 기준으로 설정된 Ford_MX_CTN 출하사이트에 대해서
  *            From Site가 MI인 경우 MI법인으로 From Site가 WA인 경우 WA법인으로 출하하도록 수정요청
  
  * 이 함수는 return type을 COMPANY_ID만 사용하고
  * FROM_SITE_ID를 추가로 입수하여 동작한다.

  * 예외는 scm_site_company_exception에 정의한다

  * INPUT         : @@p_division_id : DIVISION 
					@@p_frpm_scm_site_id : SCM_SITE_ID
					@@p_to_scm_site_id : SCM_SITE_ID
					@@p_return_type : SITE_TYPE, PLANT_ID, VENDOR_ID, SOLDTO_CODE, SHIPTO_CODE, COMPANY_ID , COUNTRY, VMI_YN
  * USAGE         : SELECT DBO.[FN_GET_SSP_INFO_TO_COMPANY_ID]('81','WA-A','Ford_MX_CTN','COMPANY_ID') ==> 'WA00'
					SELECT DBO.[FN_GET_SSP_INFO_TO_COMPANY_ID]('81','MI-A','Ford_MX_CTN','COMPANY_ID') ==> 'MI00'
			        
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2025.0818   chkim.68     FN_GET_SSP_SITE_INFO의 COMPANY 대체 예외 적용
  ****************************************************************************/
BEGIN

	DECLARE @plant_id    NVARCHAR(100)= '';
	DECLARE @exception_company_id NVARCHAR(100) = '';

    -- company_id 타입 아닌 경우는 from_site 무시하고 fn_get_ssp_site_info를 그대로 사용한다
	IF @p_return_type <> 'COMPANY_ID' BEGIN
		return DBO.FN_GET_SSP_SITE_INFO( @p_division_id, @p_to_scm_site_id,@p_return_type )
	END
	
	-- to_site에 대한 예외가 존재하
	SELECT TOP 1 @plant_id = dbo.FN_GET_SSP_SITE_INFO(@p_division_id, @p_from_scm_site_id, 'PLANT_ID')
	IF @plant_id is null BEGIN
		return DBO.FN_GET_SSP_SITE_INFO( @p_division_id, @p_to_scm_site_id,@p_return_type )
	END

	IF @p_to_scm_site_id is null BEGIN
		return DBO.FN_GET_SSP_SITE_INFO( @p_division_id, @p_to_scm_site_id,@p_return_type )
	END

	select TOP 1 @exception_company_id = l.segment3
		from dbo.scm_adm_lookup_master_detail L with(nolock)
	where 1=1 
	and l.lookup_type = 'scm_site_company_exception'
	and l.segment1 = @p_to_scm_site_id -- to_site
	and l.segment2 = @plant_id -- plant_id of from_sizte
	and l.valid_yn = 'y'

	return isnull(@exception_company_id,  DBO.FN_GET_SSP_SITE_INFO( @p_division_id, @p_to_scm_site_id,@p_return_type ))
END

