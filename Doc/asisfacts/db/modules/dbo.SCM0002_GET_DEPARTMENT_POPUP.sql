
/*
 * Program ID   : SCM0002_GET_DEPARTMENT_POPUP
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/11/15   Songdh         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE procedure [dbo].[SCM0002_GET_DEPARTMENT_POPUP]
  @p_department  NVARCHAR(MAX)
AS
BEGIN
	
	SET NOCOUNT ON;
  
	SELECT T.UPPER_DEPT_ID
	     , D.DEPT_NAME_KO
		 , T.DEPT_ID      AS TEAM_ID
		 , T.DEPT_NAME_KO AS TEAM_NAME_KO
    FROM   SCM_MST_SSO_DEPT_INFO D  WITH(NOLOCK)
	     , SCM_MST_SSO_DEPT_INFO T  WITH(NOLOCK)
    WHERE  T.UPPER_DEPT_ID = D.DEPT_ID
	AND    D.VALID_YN = 'Y'
	AND    D.DEPT_NAME_KO <> '_'
	AND    T.[2LEVEL_DEPT_ID] = '58174290' 
	AND    D.DEPT_ID <> T.DEPT_ID
    AND    (   T.DEPT_NAME_KO LIKE N'%'+ @p_department + '%'
            OR T.DEPT_NAME_EN LIKE N'%'+ @p_department + '%'
            OR T.DEPT_NAME_CN LIKE N'%'+ @p_department + '%'
           )
    ORDER BY T.UPPER_DEPT_ID, D.DEPT_NAME_KO, T.DEPT_ID, T.DEPT_NAME_KO
	;

END


