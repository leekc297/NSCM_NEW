


/* =============================================================================
프로그램ID	: [UP_FX_GetMenuSecurityACL]
업  무  명	: 확장권한 관리
프로그램명	: 화면별 권한정보
최초작성일	: 2017.02.27
최종작성일	: 2017.02.27
개  발  자	: 이정석
입  력  값	: 
출  력  값	: 

============================================================================= */
CREATE PROCEDURE [dbo].[UP_FX_GetSecurityACL]
(
	  @UserID		NVARCHAR(20)
	 ,@MenuID		NVARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN
		SELECT
		   ISNULL(CAST(MAX(CAST(BasicACLC AS INT)) AS BIT),0) BasicACLC
		 , ISNULL(CAST(MAX(CAST(BasicACLR AS INT)) AS BIT),0) BasicACLR
		 , ISNULL(CAST(MAX(CAST(BasicACLU AS INT)) AS BIT),0) BasicACLU
		 , ISNULL(CAST(MAX(CAST(BasicACLD AS INT)) AS BIT),0) BasicACLD
		 , ISNULL(MAX(ExtendedACL),0) ExtendedACL
		FROM
		(
			SELECT	UM.BasicACLC
					,UM.BasicACLR
					,UM.BasicACLU
					,UM.BasicACLD
					,UM.ExtendedACL		
				FROM dbo.TB_FX_User	AS	U	WITH (NOLOCK)	
				INNER JOIN	dbo.TB_FX_UserGroupInfo	AS UI	WITH (NOLOCK)			
					ON UI.UserID	=	U.UserID
					AND UI.UseYN =	'Y'
				INNER JOIN	dbo.TB_FX_GroupMenuAuth	AS	UM	WITH (NOLOCK)
					ON	UI.GroupID	=	UM.GroupID	
					AND UM.UseYN	=	'Y'
				WHERE UI.UserID		=	@UserID
					AND UM.MenuID	=	@MenuID
					AND UM.UseYN	=	'Y'
				UNION 
				SELECT	UM.BasicACLC
					,UM.BasicACLR
					,UM.BasicACLU
					,UM.BasicACLD
					,UM.ExtendedACL
				FROM dbo.TB_FX_User	AS	U	WITH (NOLOCK)	
				INNER JOIN	dbo.TB_FX_UserGroupInfo	AS UI	WITH (NOLOCK)		
					ON UI.UserID	=	U.UserID
					AND UI.UseYN	=	'Y'
				INNER JOIN	dbo.TB_FX_UserMenuAuth	AS	UM	WITH (NOLOCK)
					ON	UI.UserID	=	UM.UserID	
					AND UM.UseYN	=	'Y'
				WHERE  UM.UserID	=	@UserID
					AND UM.MenuID	=	@MenuID
					AND UM.UseYN	=	'Y'
		) X
	END

	BEGIN
	SELECT STUFF((
		SELECT '|' + X.AuthID FROM
		(  
			SELECT GE.AuthID
			FROM TB_FX_ExtensionAuthInfo E WITH (NOLOCK)
			INNER JOIN TB_FX_GroupMenuAuthExtension GE	WITH (NOLOCK) 	
				ON GE.AuthID	=	E.AuthID
				AND E.UseYN		=	'Y'
			INNER JOIN TB_FX_GroupMenuAuth GA WITH (NOLOCK)
				ON GE.MenuID	=	GA.MenuID
				AND GE.GroupID	=	GA.GroupID
				AND GE.UseYN	=	'Y'
			WHERE GA.MenuID		=	@MenuID	
			AND GE.UseYN		=	'Y'
			UNION 
			SELECT GE.AuthID
			FROM TB_FX_ExtensionAuthInfo E WITH (NOLOCK)
			INNER JOIN TB_FX_UserMenuAuthExtension GE WITH (NOLOCK)
				ON GE.AuthID	=	E.AuthID
				AND E.UseYN		=	'Y'
			INNER JOIN TB_FX_UserMenuAuth UA WITH (NOLOCK)
				ON GE.MenuID	=	UA.MenuID
				AND GE.UserID	=	UA.UserID				
				AND GE.UseYN	=	'Y'
			WHERE UA.MenuID	=	@MenuID		
				AND UA.UserID	=	@UserID
				AND UA.UseYN	=	'Y'
		) X
			FOR XML PATH(''), TYPE)
					.value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS StrACL
	END
END


