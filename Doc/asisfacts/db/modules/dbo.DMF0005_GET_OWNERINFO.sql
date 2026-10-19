
/****************************************************************************************************/
/* Program ID  : UP_FX_GetUserInfoList              												*/
/* Description : 시스템관리 - 사용자관리 목록														*/
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 20180704 creation
** 20180723 MODIFY
** 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
**
**
**
*/
/****************************************************************************************************/


CREATE PROCEDURE [dbo].[DMF0005_GET_OWNERINFO]
	
	@Search		    NVARCHAR(50)
   ,@Language		NVARCHAR(2) = 'KO'
   --,@SSOUserYN      NVARCHAR(1) = 'N'	
   ,@p_created_by   NVARCHAR(50)

AS
BEGIN

	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	DECLARE @v_group_id     NVARCHAR(50);

	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함 
						AND SEGMENT1 = @p_created_by
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------

	SELECT DISTINCT  A.user_id UserID			
		,A.user_name UserName
		,A.user_name_en	UserName_E
		,A.dept_id 
		,CASE @Language WHEN 'KO' THEN B.dept_name_ko
						WHEN 'EN' THEN B.dept_name_en
						WHEN 'CN' THEN B.dept_name_cn
			END dept_name  
	FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK)
	INNER JOIN SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK) 
	ON A.DEPT_ID = B.DEPT_ID
	AND B.DEPT_ID in (
	                    select dept_id
						  from [dbo].[TB_FX_User] zz WITH(NOLOCK)
						  where zz.dept_id = B.dept_id
	                  )
	INNER JOIN (SELECT USER_ID, DEPT_ID FROM SCM_MST_SSO_USER_INFO WITH(NOLOCK) ) C ON A.DEPT_ID = C.DEPT_ID 
	WHERE A.ACTIVE_FLAG != 'D'

	--AND C.USER_ID = CASE WHEN ( SELECT top 1 w.DefaultGroupID FROM [dbo].[TB_FX_User] w  WITH(NOLOCK) where w.USERID = @p_created_by  ) like '%ADMIN'THEN C.USER_ID ELSE @p_created_by END

	AND C.USER_ID = CASE WHEN @v_group_id = 'ADMIN' THEN C.USER_ID ELSE @p_created_by END  --20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
	
	-- AND C.USER_ID = @p_created_by   --추가, 20180704
		AND (
			   (@Search IS NULL OR A.user_id LIKE '%' + @Search + '%')
			OR (@Search IS NULL OR A.user_name LIKE '%' + @Search + '%')
			OR (@Search IS NULL OR A.user_name_en LIKE '%' + @Search + '%')
			)

END
