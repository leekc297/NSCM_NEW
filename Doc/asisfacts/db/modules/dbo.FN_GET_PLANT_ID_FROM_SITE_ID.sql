
/*
 * Program ID   : FN_GET_PLANT_ID_FROM_SITE_ID  
 * Description  : SITE_ID 에 대한 PLANT_ID 추출
 * Parameter    : p_scm_site_id
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024.01.30   vadabi3        NERP) Initial Release   
 *
 */
CREATE FUNCTION [dbo].[FN_GET_PLANT_ID_FROM_SITE_ID]
               (
			   @p_scm_site_id         nvarchar(50)
			   )
               RETURNS NVARCHAR(16)
AS

BEGIN

  DECLARE @X_PLANT_ID  NVARCHAR(16);


  --################################################
  -- ASIS 
  --################################################
  SELECT @X_PLANT_ID = SUBSTRING(@p_scm_site_id,1,4); 


  --################################################
  -- TOBE) NERP 적용버전 구현
  --################################################


  RETURN @X_PLANT_ID;

END
;
