
/* =============================================================================
프로그램ID	: UP_FX_GetBaseCodeList
업  무  명	: 시스템관리 - 공통코드
프로그램명	: 공통코드 조회
최초작성일	: 2017.10.14
최종작성일	: 2017.10.14
개  발  자	: SJSHIN
입  력  값	: 
출  력  값	: 

============================================================================= */

CREATE PROCEDURE [dbo].[UP_FX_GetBaseCodeList]
	@Level		SMALLINT,	
	@BaseCode	NCHAR(7)
	--@Search NVARCHAR(50)
AS
BEGIN
		SET NOCOUNT ON;

		IF @Level = 1

			BEGIN
				SELECT
					BaseCode, ClsCode1, ClsCode2, ClsCode3, CodeName, PrntCode, SortOrder, UseYN, RegtUserID
				FROM 
					dbo.TB_FX_BaseCode WITH(NOLOCK)		
				WHERE 
					PrntCode = ''
					--(@Search IS NULL OR BaseCode LIKE '%' + @Search + '%')
					--OR (@Search IS NULL OR CodeName LIKE '%' + @Search + '%')
				ORDER BY SortOrder
			END
		
		ELSE

			IF @Level <> 100

				BEGIN				
					SELECT
						BaseCode, ClsCode1, ClsCode2, ClsCode3, CodeName, PrntCode, SortOrder, UseYN, RegtUserID
					FROM 
						dbo.TB_FX_BaseCode WITH(NOLOCK)		
					WHERE 
						--PrntCode = @BaseCode
						(@BaseCode IS NULL OR PrntCode LIKE '%' + @BaseCode + '%')
					ORDER BY SortOrder
				END

			ELSE

				BEGIN
					-- Level 이 100 인 경우 : UI 공통코드 조회용
					-- Parent Code 를 기준으로 하위코드 목록을 가져온다.
					SELECT
						BaseCode as CODE, CodeName as NAME
					FROM 
						dbo.TB_FX_BaseCode WITH(NOLOCK)		
					WHERE 
						PrntCode = @BaseCode AND UseYN = 'Y'
					ORDER BY SortOrder
				END

END
