


/*
 * Program ID   : SCP0002_GET_LINE_MASTER_OSP
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2020/01/21   HWYOON			Initial Release [] GSCM(SCP) 운영 - [C20200116-000114] ESS 외주 Packer Line 계획 수립
 * 2020/10/26   khj79           PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK
 * 2023/03/07   vadabi3         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제  : SCS Prod Amend 추가
 */

CREATE PROCEDURE [dbo].[SCP0002_GET_LINE_MASTER_OSP]
  @p_division_id    NVARCHAR(MAX),  
  @p_scm_site_id    NVARCHAR(MAX),
  @p_line_id		NVARCHAR(MAX),
  @p_valid_yn		NVARCHAR(MAX)
AS
BEGIN
	


	SELECT 
		  L.DIVISION_ID
		  , L.SCM_SITE_ID
		  , S.SITE_DESCRIPTION
		  , L.LINE_ID
		  , L.LINE_NAME
		  , L.VALID_YN
		  , L.OPERATION_ID
		  , (CASE WHEN L.OPERATION_ID LIKE '%R1' THEN 'Y' ELSE 'N' END) AS RACK_YN
		  , ISNULL(L.ATTRIBUTE1, 'N') AS SCS_PROD_AMEND
	FROM SCM_MST_LINE_OSP L(NOLOCK)
	JOIN SCM_MST_SITE S(NOLOCK) ON L.DIVISION_ID = S.DIVISION_ID 
											AND L.SCM_SITE_ID = S.SCM_SITE_ID 
	WHERE 1=1
	  AND L.division_id  = @p_division_id
	  AND ( ( @p_scm_site_id   IS NULL OR  @p_scm_site_id = ''   ) OR L.scm_site_id      IN (SELECT token FROM dbo.String_Split(@p_scm_site_id  ,',')) )
	  AND ( ( @p_line_id       IS NULL OR  @p_line_id = ''       ) OR L.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id  ,',')) )		
	  AND (@p_valid_yn IS NULL OR L.valid_yn = @p_valid_yn) 								 					   
	ORDER BY L.DIVISION_ID, L.SCM_SITE_ID, L.LINE_ID

	;
END



