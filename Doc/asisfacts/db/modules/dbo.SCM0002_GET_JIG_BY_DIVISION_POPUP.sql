


/*
 * Program ID   : SCM0002_GET_JIG_BY_DIVISION_POPUP
 * Description  : Jig Master 조회(Popup)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/10/19   yhw				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/11/01	yhw				Operation ID 적용
 */
CREATE PROCEDURE [dbo].[SCM0002_GET_JIG_BY_DIVISION_POPUP]
  @p_division_id		NVARCHAR(MAX),
  @p_jig_name			NVARCHAR(MAX)
AS  
  
BEGIN
  SET NOCOUNT ON; 
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

	SELECT	A.DIVISION_ID
			, (A.SCM_SITE_ID + ' ' + B.SITE_DESCRIPTION) AS SITE_DESCRIPTION
			, A.SCM_SITE_ID
			, B.OPERATION_GROUP
			, A.OPERATION_ID
			, L.SEGMENT2 OPERATION_GROUP_NM
			, A.JIG_NAME
			, A.JIG_SEQ
	FROM SCP_MST_JIG A WITH(NOLOCK)
	JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.SCM_SITE_ID = B.SCM_SITE_ID
	JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) ON L.LOOKUP_TYPE='OPERATION_GROUP' AND L.VALID_YN='Y' AND L.SEGMENT1=B.OPERATION_GROUP
	WHERE 1=1
	  AND A.VALID_YN = 'Y'
	  AND ( ( @p_division_id		IS NULL OR  @p_division_id = ''	) OR	 A.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
	  AND ( @p_jig_name IS NULL OR A.JIG_NAME LIKE '%' + @p_jig_name + '%' ) 
	ORDER BY A.DIVISION_ID, A.SCM_SITE_ID, B.OPERATION_GROUP
	;

END



