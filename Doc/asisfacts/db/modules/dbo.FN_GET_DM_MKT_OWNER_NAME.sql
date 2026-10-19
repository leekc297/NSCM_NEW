
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : FN_GET_SSP_MKT_OWNER_NAME
 * Description  : PROJECT OWNER  
 *        
 *        
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.11.01   juhlee     Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2019.12.18	hwi1993	DM 에서 사용하기 위해 복사함 ( FN_GET_SSP_MKT_OWNER_NAME ). 혹시모를 변경을 피하기 위해

 */
CREATE FUNCTION [dbo].[FN_GET_DM_MKT_OWNER_NAME] 
( 
	@p_owner NVARCHAR(MAX) ,
	@p_delim VARCHAR(1),
	@p_language NVARCHAR(2)
) 
RETURNS nvarchar(max)
AS 
BEGIN

	DECLARE @Idx INT
	DECLARE @FoundIdx INT 
	DECLARE @ReStr NVARCHAR(MAX)
	DECLARE @UserName NVARCHAR(MAX)

	SET @Idx = 1
	SET @FoundIdx = CHARINDEX(@p_delim, @p_owner)
	SET @ReStr = '';

	IF (@FoundIdx <> 0)
	BEGIN
		WHILE (@FoundIdx > 0)
		BEGIN 
			IF (@p_language = 'KO') BEGIN
				SELECT @UserName = USER_NAME    + '(' + USER_ID + ')' FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = LTRIM(RTRIM(SUBSTRING(@p_owner, 1, @FoundIdx - 1)))
			END ELSE BEGIN
				SELECT @UserName = USER_NAME_EN + '(' + USER_ID + ')' FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = LTRIM(RTRIM(SUBSTRING(@p_owner, 1, @FoundIdx - 1)))
			END
		
			SET @ReStr = LTRIM(RTRIM(@ReStr)) + @UserName + ','
		
			SET @p_owner = SUBSTRING(@p_owner, @FoundIdx + 1, len(@p_owner) - @FoundIdx)
			SET @Idx = @Idx + 1 
			SET @FoundIdx = CHARINDEX(@p_delim, @p_owner)
		END

		IF (@p_language = 'KO') BEGIN
			SELECT @ReStr = @ReStr + USER_NAME    + '(' + USER_ID + ')' FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = LTRIM(RTRIM(@p_owner)) 
		END ELSE BEGIN
			SELECT @ReStr = @ReStr + USER_NAME_EN + '(' + USER_ID + ')' FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = LTRIM(RTRIM(@p_owner)) 
		END
  
	END
	ELSE
	BEGIN
		IF (@p_language = 'KO') BEGIN
			SELECT @ReStr = USER_NAME    + '(' + USER_ID + ')' FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = LTRIM(RTRIM(@p_owner))
		END ELSE BEGIN
			SELECT @ReStr = USER_NAME_EN + '(' + USER_ID + ')' FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = LTRIM(RTRIM(@p_owner))
		END
	END

	--select @ReStr
	RETURN @ReStr

END 

