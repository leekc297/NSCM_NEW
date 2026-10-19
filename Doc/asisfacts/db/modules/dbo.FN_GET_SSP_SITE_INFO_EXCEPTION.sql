
CREATE FUNCTION [dbo].[FN_GET_SSP_SITE_INFO_EXCEPTION]
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
  * FUNCTION NAME : [FN_GET_SSP_SITE_INFO_EXCEPTION]
  * DESCRIPTION   : FN_GET_SSP_SITE_INFO에서 FROM 정보를 참고하여야 하는 경우의 예외 처리
  * 일반적으로 FN_GET_SSP_SITE_INFO 함수를 이용해서 TO_COMPANY_ID 정보를 획득한다.
  * 2025/07/08 자동차.마케팅,마케팅1.Ford티에서 WA법인 기준으로 설정된 Ford_MX_CTN 출하사이트에 대해서
  *            From Site가 MI인 경우 MI법인으로 From Site가 WA인 경우 WA법인으로 출하하도록 수정요청
  * 2025/08/18 COMPANY_ID 구현
  * 2025/08/19 같은 룩업에서 SITE_TYPE 예외 추가를 요청함
  * ssp_site_info_exception site_type
  
  * 이 함수는 FN_GET_SSP_SITE_INFO 함수에 
  * FROM_SITE_ID를 추가로 입수하여 동작한다.

  * 예외는 lookup type ssp_site_info_exception에 정의한다

  * INPUT         : @@p_division_id : DIVISION 
					@@p_frpm_scm_site_id : SCM_SITE_ID
					@@p_to_scm_site_id : SCM_SITE_ID
					@@p_return_type : SITE_TYPE, PLANT_ID, VENDOR_ID, SOLDTO_CODE, SHIPTO_CODE, COMPANY_ID , COUNTRY, VMI_YN
  * USAGE         : SELECT DBO.[FN_GET_SSP_SITE_INFO]('81','Ford_MX_CTN','COMPANY_ID')				  ==> 'WA00'
					SELECT DBO.[FN_GET_SSP_SITE_INFO_EXCEPTION]('81','WA-A','Ford_MX_CTN','COMPANY_ID') ==> 'WA00'
					SELECT DBO.[FN_GET_SSP_SITE_INFO_EXCEPTION]('81','MI-A','Ford_MX_CTN','COMPANY_ID') ==> 'MI00'

  * USAGE         : SELECT DBO.[FN_GET_SSP_SITE_INFO_REF_FROM]('81','Ford_MX_CTN','SITE_TYPE') ==> 'A'
					SELECT DBO.[FN_GET_SSP_SITE_INFO_EXCEPTION]('81','WA-A','Ford_MX_CTN','SITE_TYPE') ==> 'A'
					SELECT DBO.[FN_GET_SSP_SITE_INFO_EXCEPTION]('81','MI-A','Ford_MX_CTN','SITE_TYPE') ==> 'B'
			        
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2025.0818   chkim.68     FN_GET_SSP_SITE_INFO의 COMPANY 대체 예외 적용
  ****************************************************************************/
BEGIN

	DECLARE @plant_id    NVARCHAR(100)= '';

    -- company_id 타입 아닌 경우는 from_site 무시하고 fn_get_ssp_site_info를 그대로 사용한다
	IF @p_return_type <> 'COMPANY_ID' BEGIN
		if @p_return_type <> 'SITE_TYPE' BEGIN
			return DBO.FN_GET_SSP_SITE_INFO( @p_division_id, @p_to_scm_site_id,@p_return_type )
		END
	END
	
	-- to_site에 대한 예외가 존재하
	SELECT TOP 1 @plant_id = dbo.FN_GET_SSP_SITE_INFO(@p_division_id, @p_from_scm_site_id, 'PLANT_ID')
	--IF @plant_id is not null BEGIN
	--	return DBO.FN_GET_SSP_SITE_INFO( @p_division_id, @p_to_scm_site_id,@p_return_type )
	--END

	IF @p_to_scm_site_id is null BEGIN
		return DBO.FN_GET_SSP_SITE_INFO( @p_division_id, @p_to_scm_site_id,@p_return_type )
	END

	DECLARE @exception_value NVARCHAR(100) = null;
	IF @p_return_type = 'COMPANY_ID'
	BEGIN
		select TOP 1 @exception_value = l.segment5
			from dbo.scm_adm_lookup_master_detail L with(nolock)
		where 1=1 
		and l.lookup_type = 'ssp_site_info_exception'
		and 
		(
			l.segment4 = @plant_id -- plant_id of from_sizte
			or l.segment4 = '-'
		)
		and l.segment1 = 'COMPANY_ID'
		and l.segment2 = @p_division_id
		and l.segment3 = @p_to_scm_site_id -- to_site
		and l.valid_yn = 'y'
		if isnull(@exception_value,'') = '' BEGIN
			 return DBO.FN_GET_SSP_SITE_INFO( @p_division_id, @p_to_scm_site_id,@p_return_type )
		END
		return @exception_value
	END

	IF @p_return_type = 'SITE_TYPE'
	BEGIN
		select TOP 1 @exception_value = l.segment5
			from dbo.scm_adm_lookup_master_detail L with(nolock)
		where 1=1 
		and l.lookup_type = 'ssp_site_info_exception'
		and 
		(
			l.segment4 = @plant_id -- plant_id of from_sizte
			or l.segment4 = '-'
		)
		and l.segment1 = 'SITE_TYPE'
		and l.segment2 = @p_division_id
		and l.segment3 = @p_to_scm_site_id -- to_site
		and l.valid_yn = 'y'
		if isnull(@exception_value,'') = '' BEGIN
			 return DBO.FN_GET_SSP_SITE_INFO( @p_division_id, @p_to_scm_site_id,@p_return_type )
		END
		return @exception_value
	END
	return DBO.FN_GET_SSP_SITE_INFO( @p_division_id, @p_to_scm_site_id,@p_return_type )
END

