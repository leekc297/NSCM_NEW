
/*
 * Program ID   : SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM
 * Description  : Shipment Change Request Confirm
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/04/19   ygkim			Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/06/27   ygkim			Item_id, nick_name 컬럼 추가, @p_item_id 파라미터 추가
 * 2018/07/10   ygkim			Change Type 컬럼 추가
 * 2018/09/03   ygkim			Division 'EE' 추가로 인한 쿼리 수정
 * 2018/10/11   ygkim			Shipment Plan Change 화면에서 승인한 항목은 제외
 * 2019/02/14	hwyoon			[CSR ID:3920817] Shipment change Request Confirm List 에 To site 정보 추가 요청
 * 2019/06/17   mcTheJ			[CSR ID:3994058] [요청]생산관리 출하변경 시 사유 code화 관리 Cnage_Type = 'A' 주석처리
 * 2019/07/15	mcTheJ			[CSR ID:4044806] Model PIC 담당자 위임 기능 추가 - 위임자 결재 추가
 */

CREATE PROCEDURE [dbo].[SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_request_id			NVARCHAR(MAX)
	,@p_from_yyyymmdd		NVARCHAR(8)
	,@p_to_yyyymmdd			NVARCHAR(8)
	,@p_status				NVARCHAR(MAX)
	,@p_language            NVARCHAR(MAX) = 'KO'
	,@p_item_id				NVARCHAR(MAX)
	,@p_change_type         NVARCHAR(MAX) = 'C'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT a.division_id
			,a.from_site
			,a.change_req_no
			,shipment_status
			,item_id
			,dbo.fn_get_item_nickname( (case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name
			,a.request_title
			,A.change_reason_code
			,a.request_user
			,a.request_dept
			,a.request_time
			,a.approval_user
			,a.approval_dept
			,a.DELEGATEE_USER
			,a.DELEGATEE_DEPT 
			,a.DELEGATEE_USER
			,a.DELEGATEE_DEPT
			,a.approval_time
			,a.reject_reason
			,request_user_name
			,approval_user_name
			,a.delegatee_user_name 
			,change_type
			,to_site
	FROM(
		SELECT a.division_id
				,a.from_site
				,a.change_req_no
				,a.change_req_status shipment_status
				,(select max(item_id) from SSP_ANL_SHIP_CONFIRM_CHG_REQ_de where DIVISION_ID = a.division_id and  CHANGE_REQ_NO = a.CHANGE_REQ_NO) item_id
				,a.request_title
				,A.change_reason_code
				,a.request_user
				,a.request_dept
				,a.request_time
				,a.approval_user
				,a.approval_dept
				,CASE WHEN a.DELEGATEE_USER IS NOT NULL THEN
					a.DELEGATEE_USER
				 ELSE
					CASE WHEN a.change_req_status = 'Q' OR a.change_req_status = 'D' THEN
						b.DELEGATEE_ID
					ELSE
						NULL
					END
				END AS DELEGATEE_USER
				,CASE WHEN a.DELEGATEE_DEPT IS NOT NULL THEN 
					a.DELEGATEE_DEPT
				 ELSE 
					CASE WHEN a.change_req_status = 'Q' OR a.change_req_status = 'D' THEN
						U4.Dept_ID
					ELSE
						NULL
					END
				 END AS DELEGATEE_DEPT
				,a.approval_time
				,a.reject_reason
				,a.change_type
				,CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.request_user + ')' request_user_name
				,CASE WHEN @p_language = 'KO' THEN U2.UserName ELSE U2.UserName_E END + '(' +  a.approval_user + ')' approval_user_name
				,CASE WHEN a.DELEGATEE_USER IS NOT NULL THEN
					CASE WHEN @p_language = 'KO' THEN U3.UserName ELSE U3.UserName_E END + '(' +  a.DELEGATEE_USER + ')' 
				ELSE
					CASE WHEN a.change_req_status = 'Q' OR a.change_req_status = 'D' THEN
						CASE WHEN @p_language = 'KO' THEN U4.UserName ELSE U4.UserName_E END + '(' +  b.DELEGATEE_ID + ')'
					ELSE
						NULL
					END
				END AS delegatee_user_name
				,origin_from_division_id
				,(select max(TO_SITE) from SSP_ANL_SHIP_CONFIRM_CHG_REQ_de WITH(NOLOCK) where DIVISION_ID = a.division_id and  CHANGE_REQ_NO = a.CHANGE_REQ_NO) to_site
		FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ a WITH(NOLOCK)
		LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON a.REQUEST_USER = U.UserID AND U.UseYN = 'Y'
		LEFT OUTER JOIN TB_FX_User U2 WITH(NOLOCK) ON a.approval_user = U2.UserID AND U2.UseYN = 'Y'
		LEFT OUTER JOIN TB_FX_User U3 WITH(NOLOCK) ON a.DELEGATEE_USER = U3.UserID AND U3.UseYN = 'Y'
		LEFT OUTER JOIN SSP_MST_DELEGATE b WITH(NOLOCK)
			ON a.division_id = b.division_id
			AND a.approval_user = b.USER_ID
			AND b.VALID_YN = 'Y'
			AND CONVERT(NVARCHAR(8), GETDATE(), 112) BETWEEN b.FROM_DATE AND b.TO_DATE
		LEFT OUTER JOIN TB_FX_User U4 WITH(NOLOCK) ON b.DELEGATEE_ID = U4.UserID AND U4.UseYN = 'Y'
		WHERE 1=1
			AND convert(nvarchar(8), a.request_time, 112) >= @p_from_yyyymmdd
			AND convert(nvarchar(8), a.request_time, 112) <= @p_to_yyyymmdd
			AND ( ( @p_division_id   IS NULL OR @p_division_id ='')  OR a.division_id IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
			AND ( ( @p_from_site   IS NULL OR @p_from_site ='')  OR a.from_site IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
			AND ( ( @p_request_id   IS NULL OR @p_request_id ='')  OR a.request_user IN (SELECT token FROM dbo.String_Split(@p_request_id,',')) )
			AND ( ( @p_status   IS NULL OR @p_status ='')  OR a.change_req_status = @p_status )
			AND ( ( @p_change_type   IS NULL OR @p_change_type ='')  OR a.change_type = @p_change_type )
			AND a.VALID_YN = 'Y'
			AND NOT EXISTS (SELECT MS.SCM_SITE_ID FROM SCM_MST_SITE MS WITH(NOLOCK) WHERE MS.DIVISION_ID ='40' AND MS.SITE_TYPE='PLANT' AND MS.OSP_YN = 'Y' AND A.FROM_SITE = MS.SCM_SITE_ID )
			--AND a.change_type != 'A'
	) A
	where 1=1
	  AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
	order by a.request_time DESC,a.change_req_no
	 
END
