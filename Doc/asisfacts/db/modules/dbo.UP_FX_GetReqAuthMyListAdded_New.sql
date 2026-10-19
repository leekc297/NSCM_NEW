
/*
 * Program ID   : UP_FX_GetReqAuthMyListAdded_New
 * Description  : 신규사용자 권한요청 - 신청한 요청에 대한 조회 및 결과 조회[GSCM+FP통합]
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/10/19   jyj		      GSCM+FP통합
 */

CREATE PROCEDURE [dbo].[UP_FX_GetReqAuthMyListAdded_New]
	@p_UserID		NVARCHAR(50)
AS
BEGIN

	/*SELECT 
		' ' as CHK ,
		a.USER_ID , g.grpName ,
		a.GROUP_ID, 
		a.DIVISION_ID , d.DIVISION_NAME ,
		a.PLANT_ID , p.PLANT_NAME ,
		a.CUSTOMER_CODE , a.CUSTOMER_CODE as SHIPTO_DESCRIPTION ,
		a.APPROVAL_RESULT, a.APPROVAL_USER, a.CREATED_BY ,a.CREATION_DATE, a.LAST_UPDATED_BY
		, a.LAST_UPDATE_DATE
	FROM SCM_MST_AUTH_REQUEST (nolock) a
	inner join TB_FX_GroupInfo (nolock) g on a.group_id=g.groupid
	inner join scm_mst_division (nolock) d on a.DIVISION_ID = d.DIVISION_ID
	left join SCM_MST_PLANT_SN (nolock) p on a.DIVISION_ID = p.DIVISION_ID and a.PLANT_ID=p.PLANT_ID
	WHERE USER_ID = @p_UserID
	order by a.GROUP_ID , a.DIVISION_ID , a.PLANT_ID , a.CUSTOMER_CODE , a.CREATION_DATE
*/

	SELECT chk
		  ,user_id
		  ,group_id
		  ,grpname
		  ,a.division_id
		  ,division_name
		  ,a.plant_id
		  ,MAX((CASE WHEN SN.PLANT_NAME IS NULL OR SN.PLANT_NAME = '' THEN V.VENDOR_NAME ELSE SN.PLANT_NAME END )) AS plant_name
		  ,approval_result
		  ,a.approval_user
		  ,a.created_by
		  ,a.creation_date
		  ,a.last_updated_by
		  ,a.last_update_date,
		  a.reject_reason
		  ,Language
		  ,TimeZone
		  ,a.fp_request  --FP추가:20211018
		  ,Case When sum(a.fp_request_count) > 0 Then 'Y' else 'N' end fp_request_flag --FP추가:20211018
	FROM(
		SELECT 
				' ' AS chk ,
				a.user_id, 
				a.group_id,  g.grpname ,
				a.division_id , a.division_id + ' ' + d.division_name as division_name ,
				a.plant_id , --p.site_description as  plant_name ,
				--a.customer_code , 
				a.approval_result, a.approval_user, a.created_by ,a.creation_date, a.last_updated_by, a.last_update_date,
				a.reject_reason,
				u.Language,
				u.TimeZone,
				'' fp_request,
				(  SELECT count(*) FROM LGCE_FP_TR.dbo.FP_AUTH_REQUEST_INFO_M  B WITH(NOLOCK) 
					WHERE B.DIVISION_ID = a.division_id AND APPROVAL_FLAG = 'R'
					AND B.USER_ID =a.user_id 
					AND B.MENU_AUTHORITY_ID = ( CASE WHEN A.group_id ='FP Viewer' THEN 'VIEWER'
				                                     WHEN A.group_id ='FP Planner' THEN 'PLANNER'
												  ELSE A.group_id END )
				) fp_request_count
		FROM SCM_MST_AUTH_REQUEST   (nolock) a
		INNER JOIN TB_FX_GroupInfo  (nolock) g on a.group_id=g.groupid
		INNER JOIN scm_mst_division (nolock) d on a.DIVISION_ID = d.DIVISION_ID
		--	LEFT JOIN scm_mst_site  (nolock) p on a.DIVISION_ID = p.DIVISION_ID and a.PLANT_ID=p.PLANT_ID
		LEFT OUTER JOIN TB_FX_User (nolock) u on a.USER_ID = u.UserID and u.UseYN = 'Y'
		WHERE 1=1 
		AND USER_ID =  @p_UserID
	) A LEFT OUTER JOIN  SCM_MST_PLANT_SN SN ON A.DIVISION_ID = SN.DIVISION_ID AND A.PLANT_ID = SN.PLANT_ID
		LEFT OUTER JOIN  SCM_MST_VENDOR V ON V.VENDOR_CODE = A.PLANT_ID
	GROUP BY chk
		  ,user_id
		  ,group_id
		  ,grpname
		  ,a.division_id
		  ,division_name
		  ,a.plant_id
		  ,approval_result
		  ,a.approval_user
		  ,a.created_by
		  ,a.creation_date
		  ,a.last_updated_by
		  ,a.last_update_date,
		  a.reject_reason
		  ,Language
		  ,TimeZone
		  ,a.fp_request
	UNION ALL
	SELECT '' chk
		  ,a.UserID
		  ,a.GroupID
		  ,g.grpname
		  ,a.division_id, a.division_id + ' ' + d.division_name as division_name
		  ,a.plant_id
		  --,p.plant_name
		  ,MAX((CASE WHEN SN.PLANT_NAME IS NULL OR SN.PLANT_NAME = '' THEN V.VENDOR_NAME ELSE SN.PLANT_NAME END )) AS plant_name
		  --,(CASE WHEN p.site_description IS NULL THEN V.VENDOR_NAME
				--					   ELSE p.site_description END ) plant_name
		  ,'APPROVED' reject_reason
		  ,a.RegtUserID approval_user
		  ,a.RegtUserID created_by
		  ,a.RegtDateTime creation_date
		  --,a.UpdateUserID last_updated_by
		  ,'Group User' last_updated_by
		  ,a.UpdateDateTime last_update_date
		  ,'' reject_reason
		  ,u.Language
		  ,u.TimeZone
		  ,'' fp_request --FP추가:20211018
		  , Case When sum(a.fp_request_count) > 0 Then 'Y' else 'N' end fp_request_flag  --FP추가:20211018
	FROM(
		SELECT a.UserID
			   ,a.GroupID		   
				,case when a.AuthType = 'D' then a.Code 
					when a.AuthType = 'P' then a.PrntCode end division_id
				,case when a.AuthType = 'P' then a.Code else '' end plant_id
				,a.RegtDateTime
				,a.RegtUserID
				,a.UpdateDateTime
				,a.UpdateUserID		
				,(  SELECT count(*) FROM LGCE_FP_TR.dbo.FP_AUTH_REQUEST_INFO_M  B WITH(NOLOCK) 
					WHERE B.DIVISION_ID = a.GroupID AND APPROVAL_FLAG = 'R'
					AND B.USER_ID =a.UserID 
					AND B.MENU_AUTHORITY_ID = ( CASE WHEN A.GroupID ='FP Viewer' THEN 'VIEWER'
				                                     WHEN A.GroupID ='FP Planner' THEN 'PLANNER'
												  ELSE A.GroupID END )
				) fp_request_count
		FROM TB_FX_UserGroupAuthExtention a with(nolock)
		WHERE UserID = @p_UserID
	) a INNER JOIN TB_FX_GroupInfo  (nolock) g on a.GroupID=g.groupid
		INNER JOIN scm_mst_division (nolock) d on a.DIVISION_ID = d.DIVISION_ID
		LEFT OUTER JOIN  SCM_MST_PLANT_SN SN ON A.DIVISION_ID = SN.DIVISION_ID AND A.PLANT_ID = SN.PLANT_ID
		LEFT OUTER JOIN  SCM_MST_VENDOR V ON V.VENDOR_CODE = A.PLANT_ID
		LEFT OUTER JOIN TB_FX_User (nolock) u on a.UserID = u.UserID and u.UseYN = 'Y'
	WHERE 1=1
	  AND NOT EXISTS (SELECT 1 
					  FROM SCM_MST_AUTH_REQUEST b with(nolock)
					  where a.GroupID = b.GROUP_ID
						and a.UserID = b.USER_ID
						AND a.division_id = b.DIVISION_ID)
	group by 
		  a.UserID
		  ,a.GroupID
		  ,g.grpname
		  ,a.division_id, a.division_id + ' ' + d.division_name
		  ,a.plant_id
		  ,a.RegtUserID 
		  ,a.RegtUserID 
		  ,a.RegtDateTime 
		  ,a.UpdateDateTime 
		  ,u.Language
		  ,u.TimeZone
	Order by a.group_id, a.division_id, a.plant_id

END
