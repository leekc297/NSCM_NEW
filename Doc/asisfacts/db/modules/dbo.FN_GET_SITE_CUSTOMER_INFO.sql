CREATE FUNCTION [dbo].[FN_GET_SITE_CUSTOMER_INFO]
      (@p_division_id         nvarchar(50),
       @p_scm_site_id         nvarchar(50),
       @p_info_type           nvarchar(50))
      RETURNS nvarchar(100)
AS
/*
 * Program ID   : FN_GET_SITE_CUSTOMER_INFO  
 * Description  : sales site의 대표 sold to ,ship to 정보를 조회
 *                p_info_type: SOLDTO_CODE,SOLDTO_DESCRIPTION,SHIPTO_CODE,SHIPTO_DESCRIPTION
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.15   yydok         Initial Release 
 */
BEGIN
  
  DECLARE @x_info   nvarchar(100) ='';
  
  DECLARE @x_soldto_code          nvarchar(100) ='';
  DECLARE @x_soldto_description   nvarchar(100) ='';  
  DECLARE @x_shipto_code          nvarchar(100) ='';
  DECLARE @x_shipto_description   nvarchar(100) ='';    

/* 
select top 1 c.soldto_code,c.soldto_description,c.shipto_code,c.shipto_description
  from scm_mst_customer       c with(nolock)
      ,scm_mst_site_customer sc with(nolock)
	  ,scm_mst_site           s with(nolock)
 where 1=1
   and s.division_id    = sc.division_id
   and s.scm_site_id    = sc.scm_site_id
   and sc.rep_yn        = 'Y'
   and sc.division_id   = c.division_id
   and sc.soldto_code   = c.soldto_code
   and sc.shipto_code   = c.shipto_code
   and s.division_id    = '81'
   and s.scm_site_id    = 'Audi_BE_BRU'
   ;
*/

select top 1 @x_soldto_code        = c.soldto_code,
             @x_soldto_description = c.soldto_description,
             @x_shipto_code        = c.shipto_code,
             @x_shipto_description = c.shipto_description
  from scm_mst_customer       c with(nolock)
      ,scm_mst_site_customer sc with(nolock)
	    ,scm_mst_site           s with(nolock)
 where 1=1
   and s.division_id    = sc.division_id
   and s.scm_site_id    = sc.scm_site_id
   and sc.rep_yn        = 'Y'
   and sc.division_id   = c.division_id
   and sc.soldto_code   = c.soldto_code
   and sc.shipto_code   = c.shipto_code
   and s.division_id    = @p_division_id
   and s.scm_site_id    = @p_scm_site_id
   ;

  if @p_info_type = 'SOLDTO_CODE'        begin set @x_info = @x_soldto_code;        end
  if @p_info_type = 'SOLDTO_DESCRIPTION' begin set @x_info = @x_soldto_description; end
  if @p_info_type = 'SHIPTO_CODE'        begin set @x_info = @x_shipto_code;        end
  if @p_info_type = 'SHIPTO_DESCRIPTION' begin set @x_info = @x_shipto_description; end      
   
  RETURN isnull(@x_info,'');

END
;
