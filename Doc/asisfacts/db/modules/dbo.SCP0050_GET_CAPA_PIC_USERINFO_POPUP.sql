


/*
 * Program ID   : SCP0050_GET_CAPA_PIC_USERINFO_POPUP
 * Description  : MDM Auth Management
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/07/20   khj79          [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성

 ex)  EXEC	SCP0050_GET_CAPA_PIC_USERINFO_POPUP
		  @Search = ''	, @Language = ''
 */
 
CREATE PROCEDURE [dbo].[SCP0050_GET_CAPA_PIC_USERINFO_POPUP]
	
	@Search			NVARCHAR(12)
   ,@Language		NVARCHAR(2) = 'KO'

AS
BEGIN
	
	SELECT UI.USER_ID
		 , UI.USER_NAME
		 , UI.USER_NAME_EN
		 , UI.DEPT_ID
		 , DI.DEPT_NAME_KO	AS DEPT_NAME
		 , UI.COMPANY_ID
		 , UI.WORKING_CODE
		 , UI.WORKING_NAME
		 , UI.SSO_LOCATE
	FROM SCM_MST_SSO_USER_INFO UI WITH(NOLOCK)
	JOIN SCM_MST_SSO_DEPT_INFO DI WITH(NOLOCK)
	  ON UI.DEPT_ID = DI.DEPT_ID
	WHERE (@Search IS NULL OR UI.USER_ID		LIKE '%' + @Search + '%')
	   OR (@Search IS NULL OR UI.USER_NAME		LIKE '%' + @Search + '%')
	   OR (@Search IS NULL OR UI.USER_NAME_EN	LIKE '%' + @Search + '%')

END





