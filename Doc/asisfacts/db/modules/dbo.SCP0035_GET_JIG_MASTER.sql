




/*
 * Program ID   : SCP0035_GET_JIG_MASTER
 * Description  : Jig Master 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/10/18   yhw				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/11/01	yhw				Operation Id 조회 추가
 */
CREATE PROCEDURE [dbo].[SCP0035_GET_JIG_MASTER]
  @p_division_id		NVARCHAR(MAX),
  @p_scm_site_id		NVARCHAR(MAX),
  @p_operation_group	NVARCHAR(MAX),
  @p_jig_name			NVARCHAR(MAX),
  @p_valid_yn				NVARCHAR(MAX)
AS  
  
BEGIN
  SET NOCOUNT ON; 
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

	SELECT	A.DIVISION_ID
			, A.SCM_SITE_ID
			, B.OPERATION_GROUP
			, A.OPERATION_ID
			, A.JIG_NAME
			, A.JIG_SEQ
			, A.VALID_YN
			, A.VALID_YN AS S_VALUE_YN
			, A.CREATED_BY
			, A.CREATION_DATE
			, A.LAST_UPDATED_BY
			, A.LAST_UPDATE_DATE
	FROM SCP_MST_JIG A WITH(NOLOCK)
	JOIN SCM_MST_SITE B WITH(NOLOCK)
	ON A.SCM_SITE_ID = B.SCM_SITE_ID
	WHERE 1=1
	  AND ( ( @p_division_id		IS NULL OR  @p_division_id = ''	) OR	 A.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
	  AND ( ( @p_scm_site_id		IS NULL OR  @p_scm_site_id = ''	) OR	 A.SCM_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_scm_site_id  ,',')) )
	  AND ( ( @p_operation_group	IS NULL OR  @p_operation_group = ''	) OR B.OPERATION_GROUP = @p_operation_group)
	  AND ( @p_jig_name IS NULL OR A.JIG_NAME LIKE '%' + @p_jig_name + '%' ) 
	  AND ( ( @p_valid_yn			IS NULL OR  @p_valid_yn = ''		) OR A.VALID_YN = @p_valid_yn)
	ORDER BY A.DIVISION_ID, A.SCM_SITE_ID, B.OPERATION_GROUP
	;

	--validation용 전체조회
	SELECT DIVISION_ID, SCM_SITE_ID, OPERATION_ID, JIG_NAME, JIG_SEQ, '-' ACTION_FLAG_DIV
	FROM SCP_MST_JIG
	;

END


