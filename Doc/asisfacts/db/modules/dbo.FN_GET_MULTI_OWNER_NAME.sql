/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_MULTI_OWNER_NAME
  * DESCRIPTION   : 여러 Owner(User_ID
  *
  * INPUT         : NVARCHAR
  * OUTPUT        : NVARCHAR
  * USAGE         : SELECT dbo.FN_GET_MULTI_OWNER_NAME('kimsuhyeon,youngsangkim', ',', '1')
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-08-03   JYE                  INITIAL
  ****************************************************************************/
CREATE FUNCTION [dbo].[FN_GET_MULTI_OWNER_NAME] 
( 
	@p_owner NVARCHAR(MAX) ,
	@Delim VARCHAR(1),
	@FLAG NVARCHAR(1)
) 
RETURNS nvarchar(max)
AS 
BEGIN

--declare @p_owner nvarchar(max) = 'kimsuhyeon,youngsangkim,hoonkim,naturalhr,parkgyuyoung,bumapark'
--declare @p_owner nvarchar(max) = 'kimsuhyeon'
--declare @Delim VARCHAR(1) = ','

	DECLARE @Idx INT
	DECLARE @FoundIdx INT 
	DECLARE @ReStr NVARCHAR(MAX)
	DECLARE @UserName NVARCHAR(MAX)

	SET @Idx = 1
	SET @FoundIdx = CHARINDEX(@Delim, @p_owner)
	SET @ReStr = '';

	IF (@FoundIdx <> 0)
	BEGIN
		WHILE (@FoundIdx > 0)
		BEGIN 
			IF (@FLAG = '1') BEGIN
				SELECT @UserName = USER_NAME_EN FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = LTRIM(RTRIM(SUBSTRING(@p_owner, 1, @FoundIdx - 1)))
			END ELSE BEGIN
				SELECT @UserName = USER_NAME FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = LTRIM(RTRIM(SUBSTRING(@p_owner, 1, @FoundIdx - 1)))
			END
		
			SET @ReStr = LTRIM(RTRIM(@ReStr)) + @UserName + ','
		
			SET @p_owner = SUBSTRING(@p_owner, @FoundIdx + 1, len(@p_owner) - @FoundIdx)
			SET @Idx = @Idx + 1 
			SET @FoundIdx = CHARINDEX(@Delim, @p_owner)
		END

		IF (@FLAG = '1') BEGIN
			SELECT @ReStr = @ReStr + USER_NAME_EN FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = LTRIM(RTRIM(@p_owner)) 
		END ELSE BEGIN
			SELECT @ReStr = @ReStr + USER_NAME FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = LTRIM(RTRIM(@p_owner)) 
		END
  
	END
	ELSE
	BEGIN
		IF (@FLAG = '1') BEGIN
			SELECT @ReStr = USER_NAME_EN FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = LTRIM(RTRIM(@p_owner))
		END ELSE BEGIN
			SELECT @ReStr = USER_NAME FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = LTRIM(RTRIM(@p_owner))
		END
	END

	--select @ReStr
	RETURN @ReStr

END 
