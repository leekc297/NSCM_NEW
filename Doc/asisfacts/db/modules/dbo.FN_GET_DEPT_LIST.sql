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
 * 2018-05-24     JYE      DEPT LIST RETURN 
 *
 */
CREATE FUNCTION [dbo].[FN_GET_DEPT_LIST]
(
	@p_created_by      NVARCHAR(100),
	@p_dept_id      NVARCHAR(100)
)
       RETURNS NVARCHAR(10)
       WITH EXEC AS CALLER       
AS
BEGIN
	DECLARE @Ret NVARCHAR(10) = 'N'
	DECLARE @cnt int

	SELECT @cnt = COUNT(*)
	FROM (
		-- 매핑 데이터가 있는 경우
		SELECT LOOK.SEGMENT3 
		FROM   [dbo].[TB_FX_User] AS USR WITH(NOLOCK)
		INNER JOIN [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] AS LOOK WITH(NOLOCK)
		ON USR.DEPT_ID = LOOK.SEGMENT1 AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING' AND LOOK.VALID_YN = 'Y'
		WHERE  USR.UserID = @p_created_by

		UNION ALL
		-- 매핑이 없는 경우 자기 부서
		SELECT Dept_ID
		FROM   [dbo].[TB_FX_User] WITH(NOLOCK)
		WHERE UserID = @p_created_by
	) AS MA
	WHERE MA.SEGMENT3 = @p_dept_id

	IF (@cnt = 0) BEGIN
		SET @Ret = 'N'
	END ELSE BEGIN
		SET @Ret = 'Y'
	END

	RETURN @Ret
END;

--USE [LGCE_SCMDEV]
