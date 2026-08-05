PROCEDURE           "SCM0006_GET_USERINFO_LIST"
(

	-- Add the parameters for the stored procedure here
	p_user				VARCHAR2,
	p_dept				VARCHAR2

/*
 * Program ID   : SCM0006_GET_USERINFO_LIST
 * Description  : 사용자 목록
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/21   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/10/15	hwyoon	SSO 사용자 조회로 변경
 *
 */
)
AS

BEGIN
	SELECT *
	FROM(
		SELECT	A.USER_ID UserID
			,	A.USER_NAME UserName
			,	A.USER_NAME_EN UserName_E
			,	A.USER_ID || 'v_lgensol.com' Email
			,	A.Dept_ID
			,	Dept_Name =
				CASE B.Language
				WHEN 'KO' THEN (SELECT DEPT_NAME_KO FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
				WHEN 'EN' THEN (SELECT DEPT_NAME_EN FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
				WHEN 'CN' THEN (SELECT DEPT_NAME_CN FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
				ELSE (SELECT DEPT_NAME_KO FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
				END;
			,	B.CellPhoneNum
			,	B.Language
			,   B.UseYN
		FROM SCM_MST_SSO_USER_INFO A
		LEFT JOIN TB_FX_User B  ON A.USER_ID=B.UserID
	) A;
	WHERE 1=1
	  --AND A.UseYN = 'Y'
	  AND ((p_user IS NULL OR p_user='' OR A.UserID LIKE '%'  ||  p_user  ||  '%')
		OR (p_user IS NULL OR p_user='' OR  A.UserName LIKE '%'  ||  p_user  ||  '%')
		OR (p_user IS NULL OR p_user='' OR  A.UserName_E LIKE '%'  ||  p_user  ||  '%'))
	  AND ((p_dept IS NULL OR p_dept='' OR  A.Dept_ID LIKE '%'  ||  p_dept  ||  '%')
		OR (p_dept IS NULL OR p_dept='' OR  A.Dept_Name LIKE '%'  ||  p_dept  ||  '%'))
	 ORDER BY A.Dept_ID, A.UserID;

	/*
	SELECT *
	FROM(
		SELECT	A.UserID
			,	A.UserName
			,	A.UserName_E
			,	A.Email
			,	A.Dept_ID
			,	Dept_Name =
				CASE A.Language
				WHEN 'KO' THEN (SELECT DEPT_NAME_KO FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
				WHEN 'EN' THEN (SELECT DEPT_NAME_EN FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
				WHEN 'CN' THEN (SELECT DEPT_NAME_CN FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
				END
			,	A.CellPhoneNum
			,	A.Language
			,   A.UseYN
		FROM TB_FX_User A
	) A;
	WHERE 1=1
	  AND A.UseYN = 'Y'
	  AND ((p_user IS NULL OR A.UserID LIKE '%' + p_user + '%')
		OR (p_user IS NULL OR A.UserName LIKE '%' + p_user + '%')
		OR (p_user IS NULL OR A.UserName_E LIKE '%' + p_user + '%'))
	  AND ((p_dept IS NULL OR A.Dept_ID LIKE '%' + p_dept + '%')
		OR (p_dept IS NULL OR A.Dept_Name LIKE '%' + p_dept + '%'))
	 ORDER BY A.Dept_ID, A.UserID;
	*/
END;