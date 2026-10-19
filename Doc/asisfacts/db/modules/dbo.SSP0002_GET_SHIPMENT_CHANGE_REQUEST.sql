/*
 * Program ID   : SSP0002_GET_SHIPMENT_CHANGE_REQUEST
 * Description  : Shipment Change Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/12   byunghunjung   Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/05/30   ygkim			project name 가져오는 부분 수정
 * 2018/06/27   ygkim			nick_name 컬럼 추가
 * 2018/07/09   ygkim			Change Type 추가로 인한 수정
 * 2018/08/30   ygkim			Division 'EE' 추가로 인한 쿼리 수정
 * 2018/10/17   ygkim			origin_from_division_id 컬럼 추가
 * 2018/10/25   ygkim			Division 40 일 경우 Project Name -> Project Code로, REMARKS 컬럼 추가 
 * 2018/11/01   hwyoon			owner 조회 추가 
 * 2019/04/04	ayj				[PJ20189106] 전지.GSCM 고도화 이행- 소형컬럼 추가
 * 2019/12/17	KIMYONGHO		[C20191216-000311] Expected Shipping Date 컬럼 추가
 * 2020/05/17	KIMYONGHO		ELECTRODE_YN, EleCTRODE_Type 컬럼추가
 * 2020/09/21  KIMYONGHO      SSP INCOTERMS 변경 작업
 */

CREATE PROCEDURE [dbo].[SSP0002_GET_SHIPMENT_CHANGE_REQUEST]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_erp_so_no			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_from_yyyymmdd		NVARCHAR(8)
	,@p_to_yyyymmdd			NVARCHAR(8)
	,@p_status				NVARCHAR(MAX)
	,@p_change_type         NVARCHAR(MAX) = 'C'
	,@p_language            NVARCHAR(MAX) = 'KO'
	,@debug_mode			NVARCHAR(1)='F'
	,@p_to_site             NVARCHAR(MAX) = ''
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @mDQry NVARCHAR(MAX)='';

	DECLARE  @v_division_id NVARCHAR(MAX)='';
	DECLARE  @v_from_site NVARCHAR(MAX)='';
	DECLARE  @v_item_id NVARCHAR(MAX)='';
	DECLARE  @v_to_site NVARCHAR(MAX)='';

	DECLARE  @v_erp_so_no NVARCHAR(MAX)='';
	DECLARE  @v_status NVARCHAR(MAX)='';
	
	--IN 조건으로 데이터를 가져옴
	SET @v_division_id = [dbo].FN_GET_IN_STR(@p_division_id);
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);
	SET @v_to_site = [dbo].FN_GET_IN_STR(@p_to_site);

	SET @v_erp_so_no = [dbo].FN_GET_IN_STR(@p_erp_so_no);
	SET @v_status = [dbo].FN_GET_IN_STR(@p_status);

	SET @mDqry = @mDQry + ' SELECT a.division_id         																										' + char(10);
	IF @p_change_type = 'C'
		SET @mDqry = @mDQry + ' 		 , a.erp_so_no                                                                                                          ' + char(10);
	ELSE IF @p_change_type = 'P'
		SET @mDqry = @mDQry + ' 		 , null erp_so_no                                                                                                          ' + char(10);

	SET @mDqry = @mDQry + ' 		 , a.shipment_status                                                                                                    ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.project_code                                                                                                       ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , [dbo].[FN_GET_PROJECT_NAME](a.division_id,a.project_code) project_name                                               ' + char(10);
	SET @mDqry = @mDQry + ' 		 , case when a.division_id = ''40'' then a.project_code else [dbo].[FN_GET_PROJECT_NAME]((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end) ,a.project_code) end project_name                                               ' + char(10);
	SET @mDqry = @mDQry + ' 		 --, d.project_name                                                                                                     ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.fcst_type                                                                                                          ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.item_id                                                                                                            ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , dbo.fn_get_item_nickname( a.division_id, a.item_id ) AS nick_name                                                    ' + char(10);
	SET @mDqry = @mDQry + ' 		 , dbo.fn_get_item_nickname((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name                                                    ' + char(10);
	SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) AS shipment_date                                       ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.qty AS shipment_confirm_qty                                                                                        ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.from_site                                                                                                          ' + char(10);
	SET @mDqry = @mDQry + ' 		 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),''-'') AS from_site_description                    ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.to_site                                                                                                            ' + char(10);
	SET @mDqry = @mDQry + ' 		 , isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.to_site ),''-'') as to_site_description                      ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info( a.division_id, a.to_site, ''SOLDTO_DESCRIPTION'' ) AS soldto_description                ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info( a.division_id, a.to_site, ''SHIPTO_DESCRIPTION'' ) AS shipto_description                ' + char(10);
	SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SOLDTO_DESCRIPTION'' ) AS soldto_description                ' + char(10);
	SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SHIPTO_DESCRIPTION'' ) AS shipto_description                ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.bod_id                                                                                                             ' + char(10);
	-- 2020/09/21  KIMYONGHO      SSP INCOTERMS 변경 작업
	--SET @mDqry = @mDQry + ' 		 , b.incoterms                                                                                                          ' + char(10);
	SET @mDqry = @mDQry + ' 		 , b.ssp_incoterms AS INCOTERMS                                                                                                          ' + char(10);
	SET @mDqry = @mDQry + ' 		 , b.transport_mode                                                                                                     ' + char(10);
	SET @mDqry = @mDQry + ' 		 , b.lt_total AS lt_day                                                                                                 ' + char(10);
	SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) AS etd                                                 ' + char(10);
	SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) AS eta                                                 ' + char(10);
	SET @mDQry = @mDQry + ' 		 , CASE WHEN b.transport_mode = ''TRK'' then ''-'' else CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](a.DIVISION_ID, a.BOD_ID, a.YYYYMMDD), 112), 23) end as Expected_Shipping_Date    ' + char(10) ;
	SET @mDqry = @mDQry + ' 		 , a.confirm_id                                                                                                         ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.change_req_no                                                                                                      ' + char(10);
	SET @mDqry = @mDQry + ' 		 , c.request_user                                                                                                       ' + char(10);
	SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U.UserName ELSE U.UserName_E END + ''('' + c.request_user + '')'' request_user_name    ' + char(10);
	SET @mDqry = @mDQry + ' 		 , c.request_time request_time                                                                                          ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.erp_status                                                                                                         ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.attribute1 plan_confirm_id,a.origin_from_division_id, a.REMARKS                                                                                         ' + char(10);
	SET @mDqry = @mDQry + ' 		 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '','', '''+@p_language+''') AS MTK_OWNER                                                                                         ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.remarks																											' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.remarks2																											' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.remarks3																											' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.ELECTRODE_YN																											' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.ELECTRODE_TYPE																											' + char(10);
	SET @mDqry = @mDQry + ' 	   FROM SSP_ANL_SHIP_CONFIRM  a WITH(NOLOCK)                                                                                            ' + char(10);
	--SET @mDqry = @mDQry + ' 	  INNER JOIN  scp_mst_bod_n_v b ON a.division_id = b.division_id  AND a.bod_id = b.bod_id                                   ' + char(10);
	SET @mDqry = @mDQry + ' 	  INNER JOIN  scp_mst_bod_n_v b WITH(NOLOCK) ON (CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID END) = b.division_id  AND a.bod_id = b.bod_id                                   ' + char(10);
	SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ c WITH(NOLOCK) on a.change_req_no = c.change_req_no AND c.VALID_YN = ''Y''                ' + char(10);	
	SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON c.request_user = u.UserID AND U.UseYN = ''Y''                                             ' + char(10);
	--20181102 추가
	SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) ON SI.DIVISION_ID  = (CASE WHEN A.DIVISION_ID =''EE'' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END)       ' + char(10);
	SET @mDqry = @mDQry + ' 														AND SI.SCM_SITE_ID  = A.TO_SITE        ' + char(10);
	SET @mDqry = @mDQry + ' 														AND SI.ITEM_ID  = A.ITEM_ID        ' + char(10);
	SET @mDqry = @mDQry + ' 														AND SI.PROJECT_CODE  = A.PROJECT_CODE        ' + char(10);
	SET @mDqry = @mDQry + ' 	  WHERE 1=1                                                                                                               ' + char(10);
	SET @mDqry = @mDQry + ' 	    AND yyyymmdd >= '+ @p_from_yyyymmdd +'                                                                                    ' + char(10);
	SET @mDqry = @mDQry + ' 			AND yyyymmdd <= '+ @p_to_yyyymmdd +'                                                                                        ' + char(10);
	IF ( @v_division_id IS NOT NULL AND @v_division_id    != '') SET @mDQry = @mDQry + ' 					AND  a.division_id   IN ('+ @v_division_id +')'+char(10);  
	IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mDQry = @mDQry + ' 					AND  a.item_id       IN ('+ @v_item_id     +')'+char(10);  
	IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDQry = @mDQry + ' 					AND  a.from_site     IN ('+ @v_from_site   +')'+char(10);   
	IF ( @v_to_site   IS NOT NULL AND @v_to_site    != '') SET @mDQry = @mDQry + ' 					AND  a.to_site     IN ('+ @v_to_site   +')'+char(10);   
	IF ( @v_erp_so_no   IS NOT NULL AND @v_erp_so_no    != '') SET @mDQry = @mDQry + ' 					AND  a.erp_so_no     IN ('+ @v_erp_so_no   +')'+char(10); 
	SET @mDqry = @mDQry + ' 		  AND (a.shipment_status IS NOT NULL AND isnull(a.shipment_status,'''') != '''') '+char(10); 
	IF ( @v_status   IS NOT NULL AND @v_status    != '') SET @mDQry = @mDQry + ' 					AND  a.shipment_status     IN ('+ @v_status   +')'+char(10); 
	SET @mDqry = @mDQry + ' 		  AND a.QTY > 0                        ' + char(10);
	
	SET @mDqry = @mDQry + ' 	  AND a.CHANGE_TYPE = ''' + @p_change_type + '''	 ' + char(10);

	SET @mDqry = @mDQry + ' ORDER BY a.division_id, a.erp_so_no, a.item_id, a.project_code, a.fcst_type, a.yyyymmdd     ' + char(10);

	EXEC (@mDQry);

	IF( @debug_mode ='T')
	BEGIN				
		DECLARE @POS INT =1;
		DECLARE @LEN INT =LEN(@mDQry);
		WHILE @POS <= @LEN
			BEGIN
				PRINT SUBSTRING(@mDQry,@POS,4000);
				SET @POS = @POS+4000;
			END;
	END;

	/*
	SELECT a.division_id
		 , a.erp_so_no
		 , a.shipment_status
		 , a.project_code
		 , [dbo].[FN_GET_PROJECT_NAME](a.division_id,a.project_code) project_name
		 --, d.project_name
		 , a.fcst_type
		 , a.item_id
		 , dbo.fn_get_item_nickname( a.division_id, a.item_id ) AS nick_name
		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) AS shipment_date
		 , a.qty AS shipment_confirm_qty
		 , a.from_site
		 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-') AS from_site_description
		 , a.to_site
		 , isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.to_site ),'-') as to_site_description
		 , dbo.fn_get_site_customer_info( a.division_id, a.to_site, 'SOLDTO_DESCRIPTION' ) AS soldto_description
		 , dbo.fn_get_site_customer_info( a.division_id, a.to_site, 'SHIPTO_DESCRIPTION' ) AS shipto_description
		 , a.bod_id
		 , b.incoterms
		 , b.transport_mode
		 , b.lt_total AS lt_day
		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) AS etd
		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) AS eta
		 , a.confirm_id
		 , a.change_req_no
		 , c.request_user
		 , CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + c.request_user + ')' request_user_name
		 , c.request_time request_time
		 , a.erp_status
	   FROM SSP_ANL_SHIP_CONFIRM  a 
	  INNER JOIN  scp_mst_bod_n_v b ON a.division_id = b.division_id  AND a.bod_id = b.bod_id
	  LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ c on a.change_req_no = c.change_req_no AND c.VALID_YN = 'Y'
	  --LEFT OUTER JOIN (SELECT pi.item_id, pi.project_code, pp.project_name 
			--			FROM scm_mst_project_item pi(NOLOCK)
			--			,    scm_mst_project pp  
			--			WHERE pi.project_code = pp.project_code) d on d.item_id = a.item_id and d.project_code = a.project_code
	  LEFT OUTER JOIN TB_FX_User U ON c.request_user = u.UserID AND U.UseYN = 'Y'
	  WHERE 1=1
	    AND yyyymmdd >= @p_from_yyyymmdd
		AND yyyymmdd <= @p_to_yyyymmdd
	    AND ( ( @p_division_id   IS NULL OR @p_division_id ='')  OR a.division_id IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
		AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
		AND ( ( @p_from_site   IS NULL OR @p_from_site ='')  OR a.from_site IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
		AND ( ( @p_erp_so_no   IS NULL OR @p_erp_so_no ='')  OR a.erp_so_no IN (SELECT token FROM dbo.String_Split(@p_erp_so_no,',')) )
		AND (a.shipment_status IS NOT NULL AND isnull(a.shipment_status,'') != '')
		AND ( ( @p_status   IS NULL OR @p_status ='')  OR a.shipment_status = @p_status )
		AND a.QTY > 0
	 ORDER BY a.division_id, a.erp_so_no, a.item_id, a.project_code, a.fcst_type, a.yyyymmdd
	 */
END
