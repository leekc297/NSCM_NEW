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
CREATE FUNCTION [dbo].[FN_GET_DIVISION_YN]
(
	@p_attribute1      NVARCHAR(MAX),		-- '40,81,82'
	@p_division_id      NVARCHAR(100)			-- '40'
)
       RETURNS NVARCHAR(10)
       WITH EXEC AS CALLER       
AS
BEGIN
	DECLARE @Ret NVARCHAR(10) = 'N'
	DECLARE @Cnt int

	SELECT @Cnt = COUNT(token) FROM dbo.String_Split(@p_attribute1 ,',')
	WHERE token = @p_division_id

	IF (@Cnt <> 0) 
	BEGIN
		SET @Ret = 'Y'
	END

	RETURN @Ret
END;
