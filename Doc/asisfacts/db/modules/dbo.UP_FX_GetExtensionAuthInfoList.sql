



/* =============================================================================
프로그램ID	: UP_FX_GetExtensionAuthInfoList
업  무  명	: 시스템 관리 -  추가 권한 리스트 
프로그램명	: 추가 권한 리스트
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 
============================================================================= */
	
CREATE PROCEDURE [dbo].[UP_FX_GetExtensionAuthInfoList]
   @AuthID			NVARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		 AuthID
		,Description
		,UseYN
	FROM dbo.TB_FX_ExtensionAuthInfo G WITH(NOLOCK)
	WHERE(@AuthID IS NULL OR AuthID LIKE '%' + @AuthID + '%')

END









