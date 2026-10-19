CREATE FUNCTION [dbo].[FN_GET_COMPANY_ID_FROM_PLANT]
               (@p_scm_site_id         nvarchar(50))
               RETURNS NVARCHAR(10)
AS
/*
 * Program ID   : FN_GET_COMPANY_ID_FROM_PLANT  
 * Description  : PLANT SITE에 대한 COMPANY_ID 추출
 * Parameter    :p_scm_site_id
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.22   yydok         Initial Release 
 * 2024.03.11   vadabi5       사용사례 없음 => 삭제 필요
 * 2024-04-29   vadabi5       NERP) SCM Site ID 로 Plant ID 찾는 로직 정의	
 ----------------------------------------------------------------------------------------------------
  select dbo.FN_GET_COMPANY_ID_FROM_PLANT('G821-A')
  select dbo.NERP_FN_GET_COMPANY_ID_FROM_PLANT('G821-A')

 */
BEGIN

  DECLARE @X_COMPANY_ID      NVARCHAR(10);
  
  
  SELECT TOP 1 @X_COMPANY_ID = COMPANY_ID 
    FROM SCM_MST_PLANT_SN
   WHERE PLANT_ID = dbo.FN_GET_SCM_SITE_TO_PLANT(@p_scm_site_id); 
  RETURN @X_COMPANY_ID;

END
;
