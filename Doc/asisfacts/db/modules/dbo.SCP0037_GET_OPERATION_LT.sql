





/*
 * Program ID   : SCP0037_GET_OPERATION_LT
 * Description  : Operation LT 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/10/24   yhw				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019/11/19	yhw				[IT서비스 C20191107-000099] 외주 Packer 후공정 L/T 적용 요청
                                LT_OPERATION 조회조건 추가
 * 2021/08/20   kmj				PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - INV_FLAG 칼럼 추가(SCP_MST_OPERATION_LT.ATTRIBUTE1)
 */
CREATE PROCEDURE [dbo].[SCP0037_GET_OPERATION_LT]
  @p_division_id		NVARCHAR(MAX),
  @p_scm_site_id		NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX),
  @p_scm_valid_yn		NVARCHAR(MAX),
  @p_lt_operation		NVARCHAR(MAX)=''
AS  
  
BEGIN
  SET NOCOUNT ON; 
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	


	SELECT A.DIVISION_ID
		   , A.SCM_SITE_ID as PLANT_SITE_ID
		   , A.SCM_SITE_ID
		   , A.ITEM_ID
		   , X.NICK_NAME
		   --, (SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN '-' WHEN X.NICK_NAME = '' THEN '-' ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK) WHERE X.ITEM_ID = A.ITEM_ID) AS NICK_NAME
		   , LT_OPERATION
		   , B.SEGMENT2 LT_OPERATION_NM
		   , LT_DAY
		   , (SELECT TOP 1 X.VALID_YN FROM DBO.SCM_MST_SITE_ITEM X WITH (NOLOCK) WHERE X.DIVISION_ID=A.DIVISION_ID AND X.SCM_SITE_ID=A.SCM_SITE_ID AND X.ITEM_ID=A.ITEM_ID) AS SITE_ITEM_VALID_YN
		   , A.CREATED_BY
		   , A.CREATION_DATE
		   , A.LAST_UPDATED_BY
		   , A.LAST_UPDATE_DATE
		   , ISNULL(A.ATTRIBUTE1, 'N') AS INV_FLAG
	FROM SCP_MST_OPERATION_LT A WITH(NOLOCK)
	JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON B.LOOKUP_TYPE='OPERATION_LT' AND B.VALID_YN='Y' AND A.LT_OPERATION=B.SEGMENT1
	JOIN ( SELECT X.ITEM_ID
				  ,  MAX(X.NICK_NAME) NICK_NAME
			 FROM SCM_MST_ITEM_SN X WITH(NOLOCK)
			GROUP BY X.ITEM_ID
		 ) X ON X.ITEM_ID=A.ITEM_ID
	WHERE 1=1
	  AND ( ( @p_division_id		IS NULL OR  @p_division_id = ''	) OR	 A.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
	  AND ( ( @p_scm_site_id		IS NULL OR  @p_scm_site_id = ''	) OR	 A.SCM_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_scm_site_id  ,',')) )
	  AND ( ( @p_lt_operation		IS NULL OR  @p_lt_operation = '') OR	 A.LT_OPERATION IN (SELECT token FROM dbo.String_Split(@p_lt_operation  ,',')) )
	  AND ( ( @p_item_id IS NULL OR     @p_item_id     ='' ) OR A.ITEM_ID  IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) OR Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where X.NICK_NAME LIKE P.token +'%'))
	  AND ( ( @p_scm_valid_yn			IS NULL OR  @p_scm_valid_yn = ''		) 
			OR (SELECT TOP 1 X.VALID_YN FROM DBO.SCM_MST_SITE_ITEM X WITH (NOLOCK) WHERE X.DIVISION_ID=A.DIVISION_ID AND X.SCM_SITE_ID=A.SCM_SITE_ID AND X.ITEM_ID=A.ITEM_ID) = @p_scm_valid_yn)

	--validation용 전체조회
	SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID, LT_OPERATION, '-' ACTION_FLAG_DIV
	FROM SCP_MST_OPERATION_LT
	;

END



