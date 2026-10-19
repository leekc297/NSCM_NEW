

/*
 * Program ID   : SCM0006_GET_RECIPIENT_ASSIGN
 * Description  : 카테고리별 수신자 리스트 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/20   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/10/15	hwyoon	메일링 분단위 발송 추가
 */

CREATE PROCEDURE [dbo].[SCM0006_GET_RECIPIENT_ASSIGN]
  @p_use_type		NVARCHAR(MAX),
  @p_categoryID		NVARCHAR(MAX)
AS
BEGIN
		
		SELECT a.use_type_code
			  ,a.category_id
			  ,b.category_desc
			  ,a.user_id userid
			  ,E.user_name username
			  ,CASE C.Language
						WHEN 'KO' THEN D.DEPT_NAME_KO
						WHEN 'EN' THEN D.DEPT_NAME_EN
						WHEN 'CN' THEN D.DEPT_NAME_CN
						ELSE D.DEPT_NAME_KO
					END	 dept_name
			   ,c.email
			   ,c.cellphonenum
			   ,c.language
		FROM SCM_ADM_RECIPIENT_ASSIGN A WITH(NOLOCK)
		INNER JOIN SCM_ADM_RECIPIENT_LIST B WITH(NOLOCK) ON a.category_id = b.category_id
		LEFT JOIN SCM_MST_SSO_USER_INFO E WITH(NOLOCK) ON E.USER_ID=a.user_id
		LEFT JOIN TB_FX_User C WITH(NOLOCK) ON c.userid = a.user_id
		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D WITH(NOLOCK) ON E.Dept_ID = D.DEPT_ID
		WHERE a.use_type_code = @p_use_type
		  AND a.category_id   = @p_categoryID
		  ORDER BY C.Dept_ID, A.USER_ID

		/*
		SELECT a.use_type_code
			  ,a.category_id
			  ,b.category_desc
			  ,a.user_id userid
			  ,c.username username
			  ,CASE C.Language
						WHEN 'KO' THEN D.DEPT_NAME_KO
						WHEN 'EN' THEN D.DEPT_NAME_EN
						WHEN 'CN' THEN D.DEPT_NAME_CN
					END	 dept_name
			   ,c.email
			   ,c.cellphonenum
			   ,c.language
		FROM SCM_ADM_RECIPIENT_ASSIGN A WITH(NOLOCK)
		INNER JOIN SCM_ADM_RECIPIENT_LIST B WITH(NOLOCK) ON a.category_id = b.category_id
		INNER JOIN TB_FX_User C WITH(NOLOCK) ON c.userid = a.user_id
		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D WITH(NOLOCK) ON C.Dept_ID = D.DEPT_ID
		WHERE a.use_type_code = @p_use_type
		  AND a.category_id   = @p_categoryID
		  ORDER BY C.Dept_ID, A.USER_ID
		*/
   ;
END

