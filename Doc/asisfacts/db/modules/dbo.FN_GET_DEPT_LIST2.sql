/*
 * PROJECT       : LG CHEM SCP PRJ.
 * FUNCTION NAME : FN_GET_DEPT_LIST
 * DESCRIPTION   : 
 * INPUT         : P_CREATED_BY
 * OUTPUT        : NVARCHAR
 * PROGRAM HISTORY
 *--------------------------------------------------------------
   DATE      IN CHARGE           DESCRIPTION
 *--------------------------------------------------------------
 * 2018-06-26     lsh      DEPT LIST RETURN 
 select [dbo].[FN_GET_DEPT_LIST2]('kooht', '58520394')
 select [dbo].[FN_GET_DEPT_LIST2]('ztychoi', '58124984')
 */
CREATE FUNCTION [dbo].[FN_GET_DEPT_LIST2]
(
	@p_created_by      NVARCHAR(100),
	--@p_dept_id		   NVARCHAR(100)	
	@p_scm_site_id		   NVARCHAR(100)
)
       RETURNS NVARCHAR(10)
       WITH EXEC AS CALLER       
AS
BEGIN
	DECLARE @Ret NVARCHAR(10) = 'N'
	DECLARE @cnt int

	SELECT @cnt = COUNT(*)
	FROM (
	/*
		SELECT DISTINCT A.OWNER
		FROM SCM_MST_SITE_ITEM A, SCM_MST_SSO_USER_INFO B, SCM_MST_SSO_DEPT_INFO C
		WHERE A.OWNER = B.USER_ID
		AND B.DEPT_ID = C.DEPT_ID
		AND A.OWNER = @p_created_by
		AND B.DEPT_ID = @p_dept_id
    */

		SELECT DISTINCT A.OWNER
		FROM SCM_MST_SITE_ITEM A
		  , SCM_MST_SSO_USER_INFO B
		  , SCM_MST_SSO_USER_INFO C
		WHERE A.OWNER = B.USER_ID
		AND B.DEPT_ID = C.DEPT_ID
		AND C.USER_ID = @p_created_by
		AND A.SCM_SITE_ID = @p_scm_site_id

	) AS T
	
	IF (@cnt = 0) BEGIN
		SET @Ret = 'N'
	END ELSE BEGIN
		SET @Ret = 'Y'
	END

	RETURN @Ret
END;

--USE [LGCE_SCMDEV]
