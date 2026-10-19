


CREATE FUNCTION [dbo].[FN_XLS_DEPT]
      ( 
		@P_DIVISION_ID			NVARCHAR(30)
		, @P_SITE_ID				NVARCHAR(30)
		, @P_ITEM_ID			   NVARCHAR(30)
		, @P_PROJECT_CODE	NVARCHAR(30) = NULL
	  )
      RETURNS NVARCHAR(50)
AS
/*
 * Program ID   : [[FN_XLS_DEPT]]
 * Description  :  사이트/아이템 및 프로젝트 코드기반의 부서명 찾기
 * 사용례		    
  SELECT DBO.[[FN_XLS_DEPT]]( '20250210', 364)  ;
 * Program History
 *===================================================================================================
 *   Date			In Charge			Description
 *===================================================================================================
 * 2025.02.17   luckydohan         Initial Release 
 */
BEGIN
    DECLARE @RES AS NVARCHAR(50)

	IF @P_PROJECT_CODE IS NULL OR @P_PROJECT_CODE = '-' 
		SELECT @RES = TEAM.DEPT_NAME_KO	
				-- , SM.PROJECT_CODE
				--, SM.DIVISION_ID, , SITE_CUST.SOLDTO_CODE, SITE_CUST.SHIPTO_CODE, 								
			FROM   SCM_MST_SITE_ITEM SM with(nolock)												
			LEFT JOIN (											
							SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO 											
							FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)											
							INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)											
							ON B.DEPT_ID = C.DEPT_ID											
						) AS TEAM												
				ON  TEAM.USER_ID   IN (SELECT top 1 TOKEN FROM  String_Split(SM.owner, ','))												
			LEFT JOIN		SCM_MST_SITE_CUSTOMER							AS SITE_CUST  WITH(NOLOCK)			
			ON				SM.SCM_SITE_ID = SITE_CUST.SCM_SITE_ID								
			AND				SM.DIVISION_ID = SITE_CUST.DIVISION_ID								
			AND				SITE_CUST.REP_YN      = 'Y'								
			LEFT JOIN		SCM_MST_CUSTOMER								AS CUST  WITH(NOLOCK)		
			ON				SITE_CUST.SOLDTO_CODE = CUST.SOLDTO_CODE								
			AND				SITE_CUST.SHIPTO_CODE = CUST.SHIPTO_CODE								
			AND				SITE_CUST.DIVISION_ID = CUST.DIVISION_ID								
			WHERE 1=1												
			AND SM.DIVISION_ID = @P_DIVISION_ID
			AND SM.SCM_SITE_ID = @P_SITE_ID
			AND SM.ITEM_ID = @P_ITEM_ID
	ELSE
		SELECT @RES = DEPT_NAME_KO
		FROM SCM_MST_SITE_ITEM  SM WITH (NOLOCK)
		INNER JOIN  SCM_MST_SSO_USER_INFO UI WITH (NOLOCK)
			ON SM.OWNER = UI.USER_ID
		INNER JOIN SCM_MST_SSO_DEPT_INFO DI WITH (NOLOCK)
			ON UI.DEPT_ID = DI.DEPT_ID
		WHERE SM.DIVISION_ID = @P_DIVISION_ID
		AND SM.SCM_SITE_ID = @P_SITE_ID
		AND SM.ITEM_ID = @P_ITEM_ID
		AND SM.PROJECT_CODE =@P_PROJECT_CODE


	RETURN @RES

END
;
