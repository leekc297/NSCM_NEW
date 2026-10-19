
create FUNCTION [dbo].[FN_GET_SSP_DOM_EXP]
(
  @p_division_id   NVARCHAR(30),
  @p_from_site     NVARCHAR(30),
  @p_to_site       NVARCHAR(30)

)

RETURNS NVARCHAR(1)
AS
/*
 * Program ID   : FN_GET_SSP_DOM_EXP
 * Description  : DOM EXP 여부 FROM_SITE와 TO_SITE의 국가가 같으면 D(Domestic) , 다르면 E(Export) 반환  
 *        
 *        
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.09.17   juhlee     Initial Release  [PJ20189106] 전지.GSCM 고도화 이행

 */
BEGIN
  
	DECLARE @v_dom_exp NVARCHAR(1) = 'E' ;
	DECLARE @v_cnt INT  

	SELECT @v_cnt = COUNT(DISTINCT X.COUNTRY) 
	FROM (
		SELECT top 1 COUNTRY
		FROM  SCM_MST_SITE FS WITH(NOLOCK) 
		WHERE FS.DIVISION_ID = @p_division_id
		AND   FS.SCM_SITE_ID = @p_from_site

		UNION ALL 

		SELECT top 1COUNTRY
		FROM  SCM_MST_SITE TS WITH(NOLOCK) 
		WHERE TS.DIVISION_ID = @p_division_id
		AND   TS.SCM_SITE_ID = @p_to_site
	) X 
  

  IF @v_cnt = 1 
   
       SET @v_dom_exp = 'D' ;



	
  RETURN @v_dom_exp;

END
;
