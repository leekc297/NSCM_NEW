
/*
 * Program ID   : SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING
 * Description  : Shipment Change Request 확정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/19   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/05/30   ygkim			project name 가져오는 부분 수정
 * 2018/09/03   ygkim			Division 'EE' 추가로 인한 쿼리 수정
 * 2018/10/17   ygkim			new_base_confirm_yn
 * 2018/10/25   ygkim			Division 40 일 경우 Project Name -> Project Code로
 * 2019/04/04	ayj			    [PJ20189106] 전지.GSCM 고도화 이행- 소형 컬럼추가
 */

CREATE PROCEDURE [dbo].[SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING]
	 @p_change_request_no	NVARCHAR(40)
	 ,@p_language            NVARCHAR(MAX) = 'KO'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT a.division_id
			, a.erp_so_no
			, case when a.DIVISION_ID = '40' then a.PROJECT_CODE else [dbo].[FN_GET_PROJECT_NAME](a.division_id,a.project_code) end project_name
			--, d.project_name
			, a.fcst_type
			, a.item_id
			, a.from_site
			, isnull(dbo.fn_get_scm_site_description( (case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.from_site ),'-') AS from_site_description
			, a.to_site
			, isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.to_site ),'-') as to_site_description
			, dbo.fn_get_site_customer_info( (case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.to_site, 'SOLDTO_DESCRIPTION' ) AS soldto_description
			, dbo.fn_get_site_customer_info( (case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.to_site, 'SHIPTO_DESCRIPTION' ) AS shipto_description
			--, b.incoterms
			, b.ssp_incoterms  AS INCOTERMS  -- 20201223 incoterms 변경 작업 modify KIMYONGHO
			, b.transport_mode	
			, case when isnull(a.yyyymmdd,'') = '' then '' else convert(char(10), convert(datetime, a.yyyymmdd), 23) end shipment_date
			, a.qty AS shipment_confirm_qty	 	 		 
			, a.bod_id		
			, a.ROUTE_ID
			, b.lt_total AS lt_day
			, c.to_site_shipto_code AS SHIPTO_CODE
			, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) AS etd
			, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) AS eta
			, a.new_bod_id new_bod_id
			, a.new_route_id new_route
			, a.new_d_country 
			, a.new_d_port_code
			, a.new_a_country
			, a.new_a_port_code
			, a.new_to_country
			, a.new_to_city
			, a.new_customer_lt AS new_lt_day
			, A.to_site_shipto_code AS NEW_SHIPTO_CODE
			, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.NEW_ETD_DATE,112), 23) AS new_etd
			, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.NEW_ETA_DATE,112), 23) AS new_eta
			, a.new_incoterms new_incoterms
			, a.NEW_TRANSPORT_MODE new_transport_mode
			, case when isnull(a.new_yyyymmdd,'') = '' then '' else convert(char(10), convert(datetime, a.new_yyyymmdd), 23) end new_shipment_date
			, a.new_qty AS new_shipment_confirm_qty	
			, a.confirm_id
			, A.change_req_no
			, a.NEW_YN
			, case when c.CONFIRM_ID is not null then 'Y' else 'N' end new_base_confirm_yn
			, a.remarks
			, a.remarks2
			, a.remarks3
		FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de A WITH(NOLOCK)
		INNER JOIN  [DBO].[scp_mst_bod_n_v] b WITH(NOLOCK) ON (case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end)  = b.division_id  AND a.bod_id = b.bod_id
		LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM c WITH(NOLOCK) on c.DIVISION_ID = a.DIVISION_ID and (case when (c.SHIPMENT_STATUS != 'P' and c.CHANGE_TYPE = 'P' and c.ATTRIBUTE1 is not null) then c.ATTRIBUTE1 else c.CONFIRM_ID end) = a.CONFIRM_ID
		WHERE A.CHANGE_REQ_NO = @p_change_request_no
			AND A.VALID_YN = 'Y'
		ORDER BY new_shipment_date;

		SELECT CHANGE_REQ_NO
			,CHANGE_REQ_STATUS
			,DIVISION_ID
			,FROM_SITE
			,REQUEST_TITLE
			--,REQUEST_USER
			,CASE @p_language WHEN 'KO' THEN C.UserName ELSE C.UserName_E END REQUEST_USER
			--,REQUEST_DEPT
			,CASE @p_language WHEN 'KO' THEN E.DEPT_NAME_KO
				                 WHEN 'EN' THEN E.DEPT_NAME_EN
								 WHEN 'CN' THEN E.DEPT_NAME_CN
						ELSE E.DEPT_NAME_KO END REQUEST_DEPT
			,REQUEST_TIME
			--,APPROVAL_USER
			,CASE @p_language WHEN 'KO' THEN D.UserName ELSE D.UserName_E END APPROVAL_USER
			--,APPROVAL_DEPT
			,CASE @p_language WHEN 'KO' THEN B.DEPT_NAME_KO
				                WHEN 'EN' THEN B.DEPT_NAME_EN
								WHEN 'CN' THEN B.DEPT_NAME_CN
					ELSE B.DEPT_NAME_KO END APPROVAL_DEPT_NAME
			,APPROVAL_TIME
			,CASE WHEN @p_language = 'KO' THEN LMD.SEGMENT2 ELSE LMD.SEGMENT3 END CHANGE_REASON_CODE
			--,CHANGE_REASON_CODE
			,CHANGE_REASON_DETAIL
			,REJECT_REASON
		FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ A WITH(NOLOCK)
		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK) ON A.APPROVAL_DEPT = B.DEPT_ID
		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO E WITH(NOLOCK) ON A.REQUEST_DEPT = E.DEPT_ID
		LEFT OUTER JOIN TB_FX_User C WITH(NOLOCK) ON A.REQUEST_USER = C.UserID
		LEFT OUTER JOIN TB_FX_User D WITH(NOLOCK) ON A.APPROVAL_USER = D.UserID
		LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LMD WITH(NOLOCK) ON A.CHANGE_REASON_CODE = LMD.SEGMENT1 AND LMD.LOOKUP_TYPE = 'CHANGE_REASON_CODE' AND LMD.VALID_YN = 'Y'
		WHERE A.CHANGE_REQ_NO = @p_change_request_no
		  AND A.VALID_YN = 'Y';	
END
