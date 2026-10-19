

/*
 * Program ID   : SSP0002_GET_SHIPMENT_CHANGE_REQUEST_ADD
 * Description  : Shipment Change Request add
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/04/17   ygkim			Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/06/29   ygkim			@p_sameDate_add 파라미터 추가
 * 2018/08/09   ygkim			p_change_type 파라미터 추가
 * 2018/08/30   ygkim			Division 'EE' 추가로 인한 쿼리 수정
 * 2019/01/03	 hwyoon			qty 조회 시 소숫점 버림
 * 2019/04/04	 ayj				[PJ20189106] 전지.GSCM 고도화 이행- 소형 컬럼추가
 * 2019/05/30	 ayj				addDate로 새로운 날짜 추가 시에 remarks,remarks2,remarks3 null로 가져오도록 수정  
 * 2020/09/21   KIMYONGHO          SSP INCOTERMS 변경 작업
 */

CREATE PROCEDURE [dbo].[SSP0002_GET_SHIPMENT_CHANGE_REQUEST_ADD]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_to_site				NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)

	,@p_bod_id				NVARCHAR(MAX) = ''
	,@p_incoterms			NVARCHAR(MAX) = ''
	,@p_transport_mode		NVARCHAR(MAX) = ''
	,@p_project_code		NVARCHAR(MAX) = ''
	,@p_fcst_type			NVARCHAR(MAX) = ''

	,@p_yyyymmdd			NVARCHAR(10)
	,@p_from_date			NVARCHAR(8)
	,@p_to_date				NVARCHAR(8)
	,@p_confirm_id			NVARCHAR(MAX)
	,@p_time_zone			NVARCHAR(MAX)
	,@p_sameDate_add		NVARCHAR(MAX) = 'N'
	,@p_change_type			NVARCHAR(MAX) = 'C'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_shipment_date   NVARCHAR(10)
	DECLARE @v_chk			   INT
	DECLARE @v_confirm_id	   NVARCHAR(max)	
	SET @v_chk = 0

	SET @v_shipment_date = @p_yyyymmdd
	SET @v_confirm_id = null

	BEGIN
		SELECT @v_confirm_id = max(confirm_id), @v_chk = COUNT(*)
		FROM(
			SELECT a.division_id
					, a.erp_so_no
					, a.shipment_status
					, a.item_id
					, yyyymmdd AS shipment_date
					, a.qty AS shipment_confirm_qty
					, a.from_site
					, a.to_site
					--, dbo.fn_get_site_customer_info( a.division_id, a.to_site, 'SOLDTO_DESCRIPTION' ) AS soldto_description
					--, dbo.fn_get_site_customer_info( a.division_id, a.to_site, 'SHIPTO_DESCRIPTION' ) AS shipto_description
					, dbo.fn_get_site_customer_info( (case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.to_site, 'SOLDTO_DESCRIPTION' ) AS soldto_description
					, dbo.fn_get_site_customer_info( (case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.to_site, 'SHIPTO_DESCRIPTION' ) AS shipto_description
					, a.bod_id
					--* 2020/09/21   KIMYONGHO          SSP INCOTERMS 변경 작업
					--, b.incoterms
					, b.ssp_incoterms AS INCOTERMS
					, b.transport_mode
					, b.lt_total AS lt_day
					, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) AS etd
					, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) AS eta
					, a.confirm_id
					, a.remarks
					, a.remarks2
					, a.remarks3
					, a.requestor
				FROM SSP_ANL_SHIP_CONFIRM  a WITH(NOLOCK)
				--INNER JOIN  scp_mst_bod_n_v b ON a.division_id = b.division_id  AND a.bod_id = b.bod_id
				INNER JOIN  scp_mst_bod_n_v b WITH(NOLOCK) ON (case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end) = b.division_id  AND a.bod_id = b.bod_id
				WHERE 1=1
				AND yyyymmdd >= @p_from_date
				AND yyyymmdd <= @p_to_date
				AND a.division_id = @p_division_id
				AND a.from_site = @p_from_site
				AND a.to_site = @p_to_site
				AND a.item_id = @p_item_id
				AND (@p_bod_id = '' or a.BOD_ID = @p_bod_id)
				 --* 2020/09/21   KIMYONGHO          SSP INCOTERMS 변경 작업
				AND (@p_incoterms = '' or b.SSP_INCOTERMS = @p_incoterms)
				AND (@p_transport_mode = '' or a.TRANSPORT_MODE = @p_transport_mode)
				AND (@p_project_code = '' or a.PROJECT_CODE = @p_project_code)
				AND (@p_fcst_type = '' or a.FCST_TYPE = @p_fcst_type)
				--AND a.shipment_status = 'C'
				ANd (a.ERP_SO_NO IS NULL AND ISNULL(a.ERP_DO_NO,'') = '')
				AND a.QTY > 0
				AND a.CHANGE_TYPE = @p_change_type
			) A WHERE shipment_date = @v_shipment_date
			group by confirm_id
	END

	--같은 날짜를 추가할 경우 신규로 추가해준다.
	IF @p_sameDate_add = 'Y'
		BEGIN
			SET @v_chk = 0;
		END
	
	IF @v_chk = 0
		BEGIN
			SET @v_confirm_id = 'C'+CONVERT(VARCHAR(8), [dbo].[FN_MULTY_TIME](@p_time_zone), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_ID),6)
		ENd
	ELSE
		BEGIN
			SET @p_confirm_id = @v_confirm_id
		END
	
	SELECT a.division_id
			, a.erp_so_no
			, a.shipment_status
			, a.item_id
			, a.from_site
			, a.to_site
			, a.project_code
			, a.fcst_type
			--, dbo.fn_get_site_customer_info( a.division_id, a.to_site, 'SOLDTO_DESCRIPTION' ) AS soldto_description
			--, dbo.fn_get_site_customer_info( a.division_id, a.to_site, 'SHIPTO_DESCRIPTION' ) AS shipto_description
			, dbo.fn_get_site_customer_info( (case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.to_site, 'SOLDTO_DESCRIPTION' ) AS soldto_description
			, dbo.fn_get_site_customer_info( (case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.to_site, 'SHIPTO_DESCRIPTION' ) AS shipto_description
			--* 2020/09/21   KIMYONGHO          SSP INCOTERMS 변경 작업
			--, b.incoterms
			, b.ssp_incoterms AS INCOTERMS
			, b.transport_mode	
			, b.lt_total AS lt_day
			, CASE WHEN @v_chk = 0 THEN CONVERT(VARCHAR(10),   CONVERT(DATETIME, @p_yyyymmdd,112), 23) ELSE CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) END AS etd
			, CASE WHEN @v_chk = 0 THEN CONVERT(VARCHAR(10),   CONVERT(DATETIME, DATEADD(DAY, b.lt_total, @p_yyyymmdd),112),23) ELSE CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) END AS eta				
			, CASE WHEN @v_chk = 0 THEN CONVERT(VARCHAR(10),   CONVERT(DATETIME, @p_yyyymmdd,112), 23) ELSE CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) END shipment_date
			, CASE WHEN @v_chk = 0 THEN CONVERT(VARCHAR(10),   CONVERT(DATETIME, @p_yyyymmdd,112), 23) ELSE CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) END new_shipment_date
			, CASE WHEN @v_chk = 0 THEN null ELSE FLOOR(a.qty) END shipment_confirm_qty
			, CASE WHEN @v_chk = 0 THEN null ELSE FLOOR(a.qty) END new_shipment_confirm_qty
			, CASE WHEN @v_chk = 0 THEN CONVERT(VARCHAR(10),   CONVERT(DATETIME, @p_yyyymmdd,112), 23) ELSE CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) END AS new_etd
			, CASE WHEN @v_chk = 0 THEN CONVERT(VARCHAR(10),   CONVERT(DATETIME, DATEADD(DAY, b.lt_total, @p_yyyymmdd),112),23)  ELSE CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) END AS new_eta
			--* 2020/09/21   KIMYONGHO          SSP INCOTERMS 변경 작업
			--, b.incoterms
			, b.ssp_incoterms new_incoterms
			--, b.incoterms new_incoterms
			, b.lt_total AS new_lt_day
			, b.transport_mode new_transport_mode
			, @v_confirm_id confirm_id
			, c.change_req_no
			, a.bod_id
			, a.route_id
			, a.d_country
			, a.d_port_code
			, a.a_country
			, a.a_port_code
			, a.to_country
			, a.to_city
			, a.bod_id new_bod_id
			, a.route_id new_route_id
			, a.d_country new_d_country
			, a.d_port_code new_d_port_code
			, a.a_country new_a_country
			, a.a_port_code new_a_port_code
			, a.customer_lt new_customer_lt
			, a.to_country new_to_country
			, a.to_city new_to_city	
			, CASE WHEN @v_chk = 0 THEN 'Y' ELSE 'N' END new_yn		
			, CASE WHEN U.Language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + c.request_user + ')' request_user_name
			, a.ATTRIBUTE1 plan_confirm_id
			, a.electrode_yn
			, a.electrode_type
			, a.origin_from_division_id
			, a.origin_to_division_id
			--, a.remarks
			--, a.remarks2
			--, a.remarks3
			, CASE WHEN @v_chk = 0 THEN null ELSE a.remarks END remarks
			, CASE WHEN @v_chk = 0 THEN null ELSE a.remarks2 END remarks2
			, CASE WHEN @v_chk = 0 THEN null ELSE a.remarks3 END remarks3
			, a.requestor
	FROM SSP_ANL_SHIP_CONFIRM  a WITH(NOLOCK)
	--INNER JOIN  scp_mst_bod_n_v b ON a.division_id = b.division_id  AND a.bod_id = b.bod_id
	INNER JOIN  scp_mst_bod_n_v b WITH(NOLOCK) ON (case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end) = b.division_id  AND a.bod_id = b.bod_id
	LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ C WITH(NOLOCK) ON A.CHANGE_REQ_NO = C.CHANGE_REQ_NO AND C.VALID_YN = 'Y'
	LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON C.REQUEST_USER = U.UserID AND U.UseYN = 'Y'
	WHERE 1=1
	AND CONFIRM_ID = @p_confirm_id;
END
