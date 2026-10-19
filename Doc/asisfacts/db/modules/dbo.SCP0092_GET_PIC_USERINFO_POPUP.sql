



/*
 * Program ID   : SCP0092_GET_PIC_USERINFO_POPUP
 * Description  : PIC 조회 (from Group Code)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/09/15   chaan          V1.1.1   Inititialize
 */

--CREATE PROCEDURE [dbo].[SCP0092_GET_PIC_USERINFO_POPUP]
CREATE PROCEDURE [dbo].[SCP0092_GET_PIC_USERINFO_POPUP]
	  @p_division_id	NVARCHAR(30)
	, @p_item_id        NVARCHAR(4000)
	, @p_user			NVARCHAR(12)
	, @p_language		NVARCHAR(2)  = 'KO'
AS
BEGIN
 --   DECLARE @p_division_id		NVARCHAR(30)
	--DECLARE @p_item_id          NVARCHAR(4000)
 --   DECLARE @p_user			    NVARCHAR(12)
	--DECLARE @p_language		    NVARCHAR(2)  = 'KO'


	SELECT DISTINCT
              U.USER_ID
			, U.USER_NAME
			, U.USER_NAME_EN
			, U.DEPT_ID
			, D.DEPT_NAME_KO AS DEPT_NAME
			, U.COMPANY_ID
			, U.WORKING_CODE
			, U.WORKING_NAME
			, U.SSO_LOCATE
	FROM    SCP_MST_FINAL_ITEM F WITH(NOLOCK)
			JOIN SCM_MST_SSO_USER_INFO U WITH(NOLOCK) ON
					F.ATTRIBUTE6 = U.USER_ID
			JOIN SCM_MST_SSO_DEPT_INFO D WITH(NOLOCK) ON
					U.DEPT_ID = D.DEPT_ID
	WHERE	1=1
        AND ((@p_division_id IS NULL OR @p_division_id	='') OR (F.DIVISION_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id, ','))))
        AND ((@p_item_id IS NULL OR @p_item_id = '') OR (F.ITEM_ID   IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id, ','))))
		AND ((@p_user IS NULL OR U.USER_ID LIKE '%' + @p_user + '%') OR (@p_user IS NULL OR U.USER_NAME LIKE '%' + @p_user + '%') OR (@p_user IS NULL OR U.USER_NAME_EN	LIKE '%' + @p_user + '%'))
    ORDER BY USER_ID, USER_NAME, USER_NAME_EN
END
