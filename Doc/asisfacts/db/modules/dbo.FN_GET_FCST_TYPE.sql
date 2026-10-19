CREATE FUNCTION [dbo].[FN_GET_FCST_TYPE]
(
  @p_sales_type_2       NVARCHAR(20)
)

RETURNS NVARCHAR(100)
AS
/*
 * Program ID   : FN_GET_FCST_TYPE
 * Description  : SAP 실적 정보의 SALES_TYPE_2 컬럼을 FCST_TYPE 으로 변환
*        
*        
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.08   Kim jihye     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.15	Kim jaejung   Fcst_type mapping 로직 변경
 *
 */
BEGIN
  
  DECLARE @v_fcst_type NVARCHAR(100)
  
  SELECT  @v_fcst_type = segment1
  FROM   scm_adm_lookup_master_detail WITH(NOLOCK)
  WHERE  lookup_type = 'SALES_TYPE_CODE'
  AND    valid_yn = 'Y'
  AND    segment3 = @p_sales_type_2
  ;
	
  IF @v_fcst_type IS NULL 
    SET @v_fcst_type = '-';	-- 2018.05.15
	
  RETURN @v_fcst_type;

END
;
