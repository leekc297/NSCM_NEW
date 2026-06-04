
/*
 * Program ID   : UP_FX_GetApprAuthRequest
 * Description  : 신규사용자 권한 요청 승인 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/06   KYH            Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/04/06   ygkim          조회 기간 조건 수정
 * 2018/06/05   ygkim		   Plant Name 가져오는 부분 수정
 * 2023/02/01   lwy            PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - E20230130-000220 GSCM 권한 승인 화면내 법인정보 추가 요청 (컬럼추가: COMPANY_ID, WORKING_NAME, SSO_LOCATE)
 */

CREATE PROCEDURE [dbo].[UP_FX_GetApprovalAuthRequest]
	@p_Division_id		NVARCHAR(max) ,
	@p_User_id			NVARCHAR(150) ,
	@p_Dept_Name		NVARCHAR(50) ,
	@p_ReqFromDate		NVARCHAR(12) ,
	@p_ReqToDate		NVARCHAR(12) ,
	@p_ApprFromDate		nvarchar(12) ,
	@p_ApprToDate		nvarchar(12) ,
	@p_ApprResult		nvarchar(max)
AS
BEGIN

	SELECT
		' ' as CHK,
		a.CREATION_DATE as 'REQUEST_DATE' , 
		a.USER_ID ,  b.USER_NAME ,		
		b.COMPANY_ID,
		b.WORKING_NAME,
		b.SSO_LOCATE,
		b.DEPT_ID , c.DEPT_NAME_KO ,
		a.GROUP_ID ,
		a.DIVISION_ID , d.DIVISION_NAME ,
		--a.PLANT_ID , e.site_description as PLANT_NAME ,
		a.PLANT_ID,MAX((CASE WHEN SN.PLANT_NAME IS NULL OR SN.PLANT_NAME = '' THEN V.VENDOR_NAME ELSE SN.PLANT_NAME END )) AS PLANT_NAME,
		a.APPROVAL_RESULT ,
		a.APPROVAL_USER ,
		a.REJECT_REASON ,
		a.LAST_UPDATE_DATE as 'APPROVAL_DATE'
	FROM SCM_MST_AUTH_REQUEST a
	INNER JOIN SCM_MST_SSO_USER_INFO (NOLOCK) B ON A.USER_ID=B.USER_ID
	LEFT JOIN SCM_MST_SSO_DEPT_INFO (NOLOCK) C ON B.DEPT_ID = C.DEPT_ID
	LEFT JOIN SCM_MST_DIVISION (NOLOCK) D ON A.DIVISION_ID = D.DIVISION_ID
	LEFT OUTER JOIN  SCM_MST_PLANT_SN SN ON A.DIVISION_ID = SN.DIVISION_ID AND A.PLANT_ID = SN.PLANT_ID
	LEFT OUTER JOIN  SCM_MST_VENDOR V ON V.VENDOR_CODE = A.PLANT_ID
	where 1=1
		AND a.CREATION_DATE >= @p_ReqFromDate + ' 00:00:00'
		AND a.CREATION_DATE <= @p_ReqToDate	+ ' 23:59:59'
		AND (isnull(@p_division_id,   '' ) = '' OR a.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@p_Division_id	 ,',')) )
		AND (isnull(@p_ApprResult,   '' ) = '' OR a.APPROVAL_RESULT IN ( SELECT token FROM dbo.String_Split(@p_ApprResult	 ,',')) )
		AND (isnull(@p_Dept_Name, '') = '' OR c.DEPT_NAME_KO like N'%' + @p_Dept_Name + N'%')
		AND (ISNULL(@p_User_id,'') = '' or b.USER_NAME like N'%' + @p_User_id + N'%' or a.USER_ID like '%' + @p_User_id + '%' )
	group by a.CREATION_DATE,
		a.USER_ID ,  b.USER_NAME ,
		b.COMPANY_ID,
		b.WORKING_NAME,
		b.SSO_LOCATE,
		b.DEPT_ID , c.DEPT_NAME_KO ,
		a.GROUP_ID ,
		a.DIVISION_ID , d.DIVISION_NAME ,a.PLANT_ID,
		a.APPROVAL_RESULT ,
		a.APPROVAL_USER ,
		a.REJECT_REASON ,
		a.LAST_UPDATE_DATE
	ORDER BY A.CREATION_DATE asc ,  A.DIVISION_ID asc, A.USER_ID asc

END

