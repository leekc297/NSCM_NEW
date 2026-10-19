
/*
 * Program ID   : FN_GET_SITE_NAME_SHIPMENT                                                             
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/07/11	KYH				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 *                                                                                                  
*/


CREATE FUNCTION [dbo].[FN_GET_SITE_NAME_SHIPMENT]
(
	@p_org_site_name         NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS    
BEGIN
    DECLARE @ret nvarchar(100) = '';
	DECLARE @tmp_site nvarchar(100) = RIGHT(@p_org_site_name , 2);

	IF @tmp_site = '-S'
		SET @ret = LEFT(@p_org_site_name , LEN(@p_org_site_name) - 2);
	ELSE
		SET @ret = @p_org_site_name;
	
    ----------------------------------------------------------------------------
    RETURN (@ret);
    ----------------------------------------------------------------------------   
	
END;

