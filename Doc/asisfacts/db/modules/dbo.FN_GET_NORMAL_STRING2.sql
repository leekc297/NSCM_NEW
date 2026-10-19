create FUNCTION [dbo].[FN_GET_NORMAL_STRING2]
(
  @ori       NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
/*
 * Program ID   : FN_GET_NORMAL_STRING
 * Description  : 문자열을 일반 텍스트 문자열로 치환
 *        
 *        
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.04.25   JYE     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
BEGIN
  
	DECLARE @ret NVARCHAR(MAX)
	SET @ret = REPLACE(@ori, 'IFNFTEVDVCA=', ' SELECT ')
	SET @ret = REPLACE(@ret, 'IFNFTEVDVA==', ' SELECT')
	SET @ret = REPLACE(@ret, 'U0VMRUNUIA==', 'SELECT ')
	SET @ret = REPLACE(@ret, 'IEZST00g', ' FROM ')
	SET @ret = REPLACE(@ret, 'lJPTSA=', 'FROM ')
	SET @ret = REPLACE(@ret, 'IEZST00=', ' FROM')
	SET @ret = REPLACE(@ret, 'IFdIRVJFIA==', ' WHERE ')
	SET @ret = REPLACE(@ret, 'V0hFUkUg', 'WHERE  ')
	SET @ret = REPLACE(@ret, 'IFdIRVJF', ' WHERE')
	SET @ret = REPLACE(@ret, 'IFVQREFURSA=', ' UPDATE ')
	SET @ret = REPLACE(@ret, 'VVBEQVRFIA==', 'UPDATE ')
	SET @ret = REPLACE(@ret, 'IFVQREFURQ==', ' UPDATE')
	SET @ret = REPLACE(@ret, 'IEpPSU4g', ' JOIN ')
	SET @ret = REPLACE(@ret, 'IEFORCA=', ' AND ')
	SET @ret = REPLACE(@ret, 'IEdST1VQIEJZIA==', ' GROUP BY ')
	SET @ret = REPLACE(@ret, 'R1JPVVAgQlkg', 'GROUP BY ')
	SET @ret = REPLACE(@ret, 'IFVOSU9OIEFMTCA=', ' UNION ALL ')
	SET @ret = REPLACE(@ret, 'VU5JT04gQUxMIA==', 'UNION ALL ')
	SET @ret = REPLACE(@ret, 'IFVOSU9OIEFMTA==', ' UNION ALL')
	SET @ret = REPLACE(@ret, 'IFVOSU9OIA==', ' UNION ')
	SET @ret = REPLACE(@ret, 'VU5JT04g', 'UNION ')
	SET @ret = REPLACE(@ret, 'IFVOSU9O', ' UNION')
	SET @ret = REPLACE(@ret, 'IE9SREVSIEJZIA==', ' ORDER BY ')
	SET @ret = REPLACE(@ret, 'T1JERVIgQlkg', 'ORDER BY ')
	SET @ret = REPLACE(@ret, 'IE9SREVSIEJZ', ' ORDER BY')
	
	RETURN @ret;

END
;
