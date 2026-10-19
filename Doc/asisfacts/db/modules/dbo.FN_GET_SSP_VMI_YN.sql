
CREATE FUNCTION [dbo].[FN_GET_SSP_VMI_YN]
(
  @p_division_id     NVARCHAR(30),
  @p_to_site         NVARCHAR(30)

)

RETURNS NVARCHAR(100)
AS
/*
 * Program ID   : FN_GET_SSP_VMI_YN
 * Description  : Sales Site의 VMI 여부   
 *        
 *        
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.07.09   juhlee     Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트

 */
BEGIN
  
  DECLARE @v_vmi_yn NVARCHAR(100)
  

	SELECT top 1 @v_vmi_yn = VMI_YN
	FROM  SCM_MST_SITE WITH(NOLOCK) 
	WHERE 1=1 
	AND   DIVISION_ID   = @p_division_id
	AND   SCM_SITE_ID   = @p_to_site     


  IF @v_vmi_yn IS NULL 
   
       SET @v_vmi_yn = 'N' ;



	
  RETURN @v_vmi_yn;

END
;
