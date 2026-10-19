CREATE FUNCTION [dbo].[FN_GET_SEMI_YN]
(     @p_from_division_id    nvarchar(50),  
      @p_scm_from_site_id    nvarchar(50),  
      @p_to_division_id      nvarchar(50),  
      @p_scm_to_site_id      nvarchar(50)  
)  
      RETURNS nvarchar  
AS  
/*  
 * Program ID   : FN_GET_SEMI_YN    
 * Description  : from site와 to site로 semi 여부를 리턴함. 값이 없을 경우는 '-'  
 * Parameter    : @p_division_id,@p_scm_from_site_id,@p_scm_to_site_id  
 * Execute      :   
                  SELECT dbo.FN_GET_SEMI_YN('40','100009-P','A010-A')  
                  SELECT dbo.FN_GET_SEMI_YN('40','HYUNDAI_KR_04','A010-A')  
                  SELECT dbo.FN_GET_SEMI_YN('40','Audi_BE_Brussels','A010-A')  
                  SELECT dbo.FN_GET_SEMI_YN('40','Audi_BE_Brussels','Audi_MX_SanJoseChiapa')  
                  SELECT dbo.FN_GET_SEMI_YN('40',NULL,NULL)  
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================  
 * 2018.02.06   kth         Initial Release   
 * 2019.07.02   kth         파라미터 수정( @p_from_division_id, @p_to_division_id 로 변경)
 *  
 */  
BEGIN  
    
  DECLARE @x_semi_yn nvarchar(1) = 'N'  
  DECLARE @X_cnt int = 0;  
  
  SELECT @X_cnt = SUM(cnt)  
  FROM   
  (  
    SELECT count(*) AS cnt   
    FROM SCM_MST_SITE WITH (NOLOCK)  
    WHERE 0 = 0   
      AND DIVISION_ID = @p_from_division_id  
      AND SCM_SITE_ID = @p_scm_from_site_id  
      AND SITE_TYPE ='PLANT'   
--      AND OSP_YN ='N' -- 아웃소싱여부   
    UNION ALL   
    SELECT count(*)   
    FROM SCM_MST_SITE WITH (NOLOCK)   
    WHERE 0 = 0   
      AND DIVISION_ID = @p_to_division_id  
      AND SCM_SITE_ID = @p_scm_to_site_id  
      AND SITE_TYPE ='PLANT'   
--      AND OSP_YN ='N' -- 아웃소싱여부   
  ) X  
    
  if isnull(@X_cnt,0) > 1  
    SET @x_semi_yn = 'Y'  
  else if isnull(@X_cnt,0) = 1  
    SET @x_semi_yn = 'N'  
  else  
    SET @x_semi_yn = NULL  
  
  RETURN isnull(@x_semi_yn,'-');  
  
END  
;  
  
