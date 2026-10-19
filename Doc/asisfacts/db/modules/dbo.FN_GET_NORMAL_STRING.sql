create FUNCTION [dbo].[FN_GET_NORMAL_STRING]
(
  @base64       NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
/*
 * Program ID   : FN_GET_NORMAL_STRING
 * Description  : base64 인코딩 된 문자열을 일반 텍스트 문자열로 변환
*        
*        
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.04.16   JYE     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
BEGIN
  
	DECLARE @ret NVARCHAR(MAX)
  
	SELECT @ret = CAST(CAST(N'' AS XML).value('xs:base64Binary(sql:column("bin"))', 'VARBINARY(MAX)') AS VARCHAR(MAX))
	FROM (
		SELECT CAST(@base64 AS VARCHAR(MAX)) AS bin
	) AS bin_sql_server_temp;
	
	RETURN @ret;

END
;
