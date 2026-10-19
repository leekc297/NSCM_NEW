
/*
 * Program ID   : SCM0002_GET_VENDOR_POPUP
 * Description  : Vendor 조회 Popup
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/11   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE procedure [dbo].[SCM0002_GET_VENDOR_POPUP]
  @p_vendor_code    NVARCHAR(300),
  @p_vendor_name    NVARCHAR(300),
  @p_paker		    NVARCHAR(1)
AS
BEGIN
	
	SET NOCOUNT ON;
  
	SELECT 
		distinct 
		  t.company_id
	     ,t.vendor_code
	     ,t.vendor_name
		 ,t.representative
	     ,t.country
	     ,t.vendor_address
		 ,t.packer_yn
	FROM SCM_MST_VENDOR T  WITH(NOLOCK)
	WHERE 1=1
    AND  (@p_paker IS NULL OR t.packer_yn  IN 
				(SELECT t.c.value('.', 'NVARCHAR(4000)')
				 FROM   (SELECT x = CAST('<t>' + REPLACE(@p_paker, ',', '</t><t>') + '</t>' AS xml)) b
				 CROSS APPLY x.nodes('/t') t(c)
				)   
	     )
	AND  (@p_vendor_code IS NULL OR t.vendor_code LIKE '%' + @p_vendor_code + '%') 
    AND  (@p_vendor_name IS NULL OR t.vendor_name LIKE '%' + @p_vendor_name + '%')	

END
