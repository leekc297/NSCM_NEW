
/*
 * Program ID   : SSP0028_GET_COUNTRY
 * Description  : Delivery Tracking LT
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/09/13   PARKTAEHAK		신규추가
*/


CREATE PROCEDURE [dbo].[SSP0028_GET_COUNTRY] 

AS
BEGIN
    SET NOCOUNT ON;
    
    --Form Country	

			  select distinct FROM_COUNTRY AS CODE , '[' + FROM_COUNTRY + ']' + c.COUNTRY_NAME, '[' + FROM_COUNTRY + ']' + c.COUNTRY_KR_NAME AS NAME
			  from [dbo].[SCP_MST_DISTRIBUTION_ROUTE] as r WITH(NOLOCK)
			  join scm_mst_country as c with(nolock)
			  on r.FROM_COUNTRY = c.COUNTRY
			  where 1 = 1
			 order by r.From_Country

  --To Country
			 select distinct TO_COUNTRY AS CODE,  '[' + TO_COUNTRY + ']' + c.COUNTRY_NAME,  '[' + TO_COUNTRY + ']' +c.COUNTRY_KR_NAME AS NAME
			  from [dbo].[SCP_MST_DISTRIBUTION_ROUTE] as r WITH(NOLOCK)
			  join scm_mst_country as c with(nolock)
			  on r.TO_COUNTRY = c.COUNTRY
			  where 1 = 1
			  order by r.To_Country;    
END



