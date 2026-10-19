
/*
 * Program ID   : SSP0027_GET_SHIPMENT_PLAN_DETAIL
 * Description  : 상품자재 ESS Shipment Plan
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/03/22   KIMYONGHO		신규추가
 * 2021/09/02   KIMYONGHO		[C20210827-000414] Shipment Plan Detail 검색 조건에 'PR No' 추가 
 * 2021/09/02   KIMYONGHO       SCP_MST_BOD_N_V -> SCP_MST_BOD_N_V 변경
 * 2024/10/01   KHJ             NERP_SSP
 
 */
CREATE PROCEDURE [dbo].[SSP0027_GET_SHIPMENT_PLAN_DETAIL]
	@p_division_id			VARCHAR(10)
	,@p_company_id			NVARCHAR(10)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_project_code		NVARCHAR(MAX)
	,@p_requestor			NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd NVARCHAR(8)
	,@p_from_yyyymmdd		NVARCHAR(8)
	,@p_to_yyyymmdd			NVARCHAR(8)
	,@p_dbl_flag			CHAR(1)
	,@p_real_flag			CHAR(1)
	,@p_language            NVARCHAR(MAX) = 'KO'
	,@p_program_id			NVARCHAR(MAX) = 'SSP0027'
	,@p_sheet_name			NVARCHAR(MAX) = 'Shipment Plan Detail'
	,@p_pr_no				NVARCHAR(MAX)	
	,@debug_mode			NVARCHAR(1)='T'

AS

BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @mDQry NVARCHAR(MAX)='';

	DECLARE  @v_division_id NVARCHAR(MAX)='';
	DECLARE  @v_from_site NVARCHAR(MAX)='';
	DECLARE  @v_item_id NVARCHAR(MAX)='';
	DECLARE  @v_project_code NVARCHAR(MAX)='';
	DECLARE  @v_requestor NVARCHAR(MAX)='';
	DECLARE  @v_pr_no NVARCHAR(MAX)='';

	-- NERP 매핑코드
    DECLARE @v_KR012031 NVARCHAR(20);
	SET @v_KR012031 = dbo.FN_GET_LOOKUP_VALUE('SSP0027_GET_SHIPMENT_PLAN_DETAIL'  ,'KR012031P' )

	--IN 조건으로 데이터를 가져옴
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);
	SET @v_project_code = [dbo].FN_GET_IN_STR(@p_project_code)
	SET @v_requestor = @p_requestor;
	SET @v_pr_no = [dbo].FN_GET_IN_STR(@p_pr_no);

	IF @p_real_flag = 'Y'
	BEGIN
		SET @mDqry = @mDQry + ' SELECT   a.division_id         																										' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.erp_so_no AS ERP_SO_NO                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.shipment_status                                                                                                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.item_id                                                                                                            ' + char(10);
		--SET @mDqry = @mDQry + ' 		 , dbo.fn_get_item_nickname((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name                                                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.nick_name AS nick_name                                                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.from_site                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.to_site                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),''-'') AS from_site_description                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.to_site ),''-'') as to_site_description                      ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(a.PROJECT_CODE,''-'') as PROJECT_CODE                      ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(dbo.FN_GET_PROJECT_NAME(a.division_id,a.PROJECT_CODE),''-'') as PROJECT_NAME                      ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(case when a.DIVISION_ID = ''40'' then case when a.PROJECT_CODE is not null and a.PROJECT_CODE != ''-'' then a.PROJECT_CODE else g.PROJECT_CODE end when a.DIVISION_ID = ''EE'' and a.ORIGIN_TO_DIVISION_ID = ''40'' then g.project_code else f.END_CUSTOMER end,''-'') end_customer            ' + char(10);
		SET @mDqry = @mDQry + ' 		 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '','', '''+@p_language+''') AS MTK_OWNER                                                                                         ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U3.UserName ELSE U3.UserName_E END + ''('' + a.requestor + '')'' requestor    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , convert(int, a.qty) AS shipment_confirm_qty                                                                                        ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) AS shipment_date                                       ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.transport_mode                                                                                                     ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.remarks2																											' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.remarks					                                                                                        ' + char(10);
		SET @mDqry = @mDQry + '			 , ''-'' AS CHANGE_REASON_CODE ' + char(10);
		SET @mDqry = @mDQry + '			 , '''' AS CHANGE_REASON_DETAIL ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.remarks3																											' + char(10);
		SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SOLDTO_CODE'' ) AS soldto_description                ' + char(10);
		SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SHIPTO_CODE'' ) AS shipto_description                ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.ssp_incoterms AS INCOTERMS                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.lt_total AS lt_day                                                                                                 ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) AS etd                                                 ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) AS eta                                                 ' + char(10);
		SET @mDQry = @mDQry + ' 		 , CASE WHEN b.transport_mode = ''TRK'' then ''-'' else CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](a.DIVISION_ID, a.BOD_ID, a.YYYYMMDD), 112), 23) end as Expected_Shipping_Date    ' + char(10) ;
		SET @mDqry = @mDQry + ' 		 , a.fcst_type                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U.UserName ELSE U.UserName_E END + ''('' + a.LAST_UPDATED_BY + '')'' AS updated_by    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , case when u.UserName is not null then a.LAST_UPDATE_DATE else null end updated_date                                                                                          ' + char(10);
		SET @mDqry = @mDQry + '			 , h.CHANGE_REQ_NO                   ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U2.UserName ELSE U2.UserName_E END + ''('' + mu.user_id + '')'' AS model_user    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.confirm_id                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.PR_NO                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.lt_total AS NEW_LT_DAY                                                                                                 ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.transport_mode AS NEW_TRANSPORT_MODE                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.ERP_STATUS ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.change_type ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.NEW_ROUTE_ID ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.NEW_BOD_ID ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.NEW_INCOTERMS ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.NEW_D_COUNTRY ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.NEW_D_PORT_CODE ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.NEW_A_COUNTRY ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.NEW_A_PORT_CODE ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.NEW_CUSTOMER_LT ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.NEW_TO_COUNTRY ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.NEW_TO_CITY ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.NEW_ETA ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.NEW_ETD ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.NEW_SHIPMENT_DATE ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.EDIT_REMARKS ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.EDIT_MAIN ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.CHECK_NEED_YN ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.ELECTRODE_YN ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , a.ELECTRODE_TYPE ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		 , isnull(g.DEPT_NAME_KO,''-'') as TEAM                      ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.ATTRIBUTE10                      ' + char(10);
		SET @mDqry = @mDQry + ' FROM                                                                                                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' (                                                                                                                                                                                                                                                                                               ' + char(10);
		SET @mDqry = @mDQry + ' 	SELECT                                                                                                                                                                                                                                                                                      ' + char(10);
		SET @mDqry = @mDQry + ' 		C.DIVISION_ID                                                                                                                                                                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.ERP_SO_NO                                                                                                                                                                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.SHIPMENT_STATUS AS SHIPMENT_STATUS                                                                                                                                                                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.ITEM_ID                                                                                                                                                                                                                                                                               ' + char(10);
		SET @mDqry = @mDQry + ' 		, T.ITEM_NAME AS NICK_NAME                                                                                                                                                                                                                                                                               ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.ORIGIN_FROM_DIVISION_ID                                                                                                                                                                                                                                                               ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.ORIGIN_TO_DIVISION_ID                                                                                                                                                                                                                                                                 ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.FROM_SITE                                                                                                                                                                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.TO_SITE                                                                                                                                                                                                                                                                               ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.PROJECT_CODE                                                                                                                                                                                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.REQUESTOR                                                                                                                                                                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.QTY                                                                                                                                                                                                                                                                                   ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.YYYYMMDD                                                                                                                                                                                                                                                                              ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.BOD_ID                                                                                                                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.REMARKS2                                                                                                                                                                                                                                                                              ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.REMARKS                                                                                                                                                                                                                                                                               ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.CHANGE_REQ_NO                                                                                                                                                                                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.REMARKS3                                                                                                                                                                                                                                                                              ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.ETD_DATE                                                                                                                                                                                                                                                                              ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.ETA_DATE                                                                                                                                                                                                                                                                              ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.LAST_UPDATED_BY                                                                                                                                                                                                                                                                       ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.LAST_UPDATE_DATE                                                                                                                                                                                                                                                                      ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.CONFIRM_ID                                                                                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' 		, D.PR_NO                                                                                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.FCST_TYPE                                                                                                                                                                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.ERP_STATUS ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.change_type ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.route_id AS NEW_ROUTE_ID ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.bod_id AS NEW_BOD_ID ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.incoterms AS NEW_INCOTERMS ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.d_country AS NEW_D_COUNTRY ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.d_port_code AS NEW_D_PORT_CODE ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.a_country AS NEW_A_COUNTRY ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.a_port_code AS NEW_A_PORT_CODE ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.customer_lt AS NEW_CUSTOMER_LT ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.to_country AS NEW_TO_COUNTRY ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.to_city AS NEW_TO_CITY ' + char(10);
		SET @mDqry = @mDQry + ' 		, CONVERT(VARCHAR(10),		CONVERT(DATETIME, C.ETA_DATE,112), 23)		AS NEW_ETA ' + char(10);
		SET @mDqry = @mDQry + ' 		, CONVERT(VARCHAR(10),		CONVERT(DATETIME, C.ETD_DATE,112), 23)		AS NEW_ETD ' + char(10);
		SET @mDqry = @mDQry + ' 		, CONVERT(VARCHAR(10),		CONVERT(DATETIME, C.yyyymmdd,112), 23)		AS NEW_SHIPMENT_DATE ' + char(10);
		SET @mDqry = @mDQry + ' 		, ''N'' AS EDIT_REMARKS ' + char(10);
		SET @mDqry = @mDQry + ' 		, ''N'' AS EDIT_MAIN ' + char(10);
		SET @mDqry = @mDQry + ' 		, isnull(CHECK_NEED_YN,''N'') AS CHECK_NEED_YN ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.ELECTRODE_YN ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.ELECTRODE_TYPE ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.ATTRIBUTE10	 												AS 	ATTRIBUTE10							' + char(10);
		SET @mDqry = @mDQry + ' 	FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)                                                                                                                                                                                                                                                        ' + char(10);
		SET @mDqry = @mDQry + '		JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 ' + char(10);
		SET @mDqry = @mDQry + '			ON C.FROM_SITE		= S.SCM_SITE_ID				 ' + char(10);
		SET @mDqry = @mDQry + '		   AND C.DIVISION_ID	= S.DIVISION_ID				 ' + char(10);
		SET @mDqry = @mDQry + '		   AND S.SITE_TYPE		= ''PLANT''					 ' + char(10);	
		--SET @mDqry = @mDQry + '	  	LEFT OUTER JOIN SCP_MST_BOD_N_V  B WITH(NOLOCK)		 ' + char(10);
		SET @mDqry = @mDQry + '	  	LEFT OUTER JOIN SCP_MST_BOD_N_V  B WITH(NOLOCK)		 ' + char(10);
		SET @mDqry = @mDQry + '			ON B.DIVISION_ID	= C.DIVISION_ID				 ' + char(10);
		SET @mDqry = @mDQry + '		   AND B.BOD_ID			= C.BOD_ID					 ' + char(10);
		SET @mDqry = @mDQry + '		JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 ' + char(10);
		SET @mDqry = @mDQry + '			ON C.ITEM_ID		= T.ITEM_ID					 ' + char(10);
		SET @mDqry = @mDQry + '		   AND C.DIVISION_ID	= T.DIVISION_ID				 ' + char(10);
		SET @mDqry = @mDQry + '		   AND S.COMPANY_ID		= T.COMPANY_ID				 ' + char(10);
		SET @mDqry = @mDQry + '		   AND T.ITEM_TYPE		IN (''Q'',''R'')			 ' + char(10);

		SET @mDqry = @mDQry + '		LEFT OUTER JOIN (																																					 ' + char(10);					
		SET @mDqry = @mDQry + '			SELECT AA.CONFIRM_ID, BB.PR_NO, AA.REQUEST_NO																														 ' + char(10);
		SET @mDqry = @mDQry + '			FROM (																																								 ' + char(10);
		SET @mDqry = @mDQry + '				SELECT MAX(B.DM_REQ_NO) AS REQUEST_NO , A.ATTRIBUTE9  AS CONFIRM_ID , A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.YYYYMMDD	 ' + char(10);
		SET @mDqry = @mDQry + '				FROM DM_PLN_MKT_FCST A WITH(NOLOCK)																																	 ' + char(10);
		SET @mDqry = @mDQry + '				LEFT OUTER JOIN SSP_ANL_ESS_REQ B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID 																								 ' + char(10);
		SET @mDqry = @mDQry + '				 AND A.PROJECT_CODE = B.PROJECT_CODE																																 ' + char(10);
		SET @mDqry = @mDQry + '				 AND A.SCM_SITE_ID = B.SCM_SITE_ID																																	 ' + char(10);
		SET @mDqry = @mDQry + '				 AND A.ITEM_ID = B.ITEM_ID																																			 ' + char(10);
		SET @mDqry = @mDQry + '				 AND A.DOM_EXP = B.DOM_EXP																																			 ' + char(10);
		SET @mDqry = @mDQry + '				 AND A.FCST_TYPE = B.FCST_TYPE																																		 ' + char(10);
		SET @mDqry = @mDQry + '				 AND A.INCOTERMS = B.INCOTERMS																																		 ' + char(10);
		SET @mDqry = @mDQry + '				 AND A.YYYYMMDD = B.YYYYMMDD																																		 ' + char(10);
		SET @mDqry = @mDQry + '				WHERE A.MEASURE = ''BNPIN''																																			 ' + char(10);
		SET @mDqry = @mDQry + ' 			AND A.yyyymmdd >= '''+ @p_from_yyyymmdd +'''		AND A.yyyymmdd <= '''+ @p_to_yyyymmdd +'''                                                    ' + char(10);
	
		SET @mDqry = @mDQry + '				GROUP BY  A.ATTRIBUTE9 , A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.YYYYMMDD													 ' + char(10);
		SET @mDqry = @mDQry + '			) AA																																								 ' + char(10);
		SET @mDqry = @mDQry + '			LEFT OUTER JOIN SSP_ANL_ESS_PR BB  WITH(NOLOCK)																														 ' + char(10);
		SET @mDqry = @mDQry + '			 ON AA.REQUEST_NO = BB.DM_REQ_NO 																																	 ' + char(10);
		SET @mDqry = @mDQry + '			 AND AA.ITEM_ID = BB.PR_ITEM_ID 																																	 ' + char(10);
		SET @mDqry = @mDQry + '			 AND AA.YYYYMMDD = BB.YYYYMMDD																																		 ' + char(10);
		SET @mDqry = @mDQry + '		) D																																									 ' + char(10);
		SET @mDqry = @mDQry + '		ON C.CONFIRM_ID = D.CONFIRM_ID	' + char(10);

		SET @mDqry = @mDQry + ' 	WHERE 1 = 1    AND C.change_type  = ''C''                                                                                                                                                                                                                                                        ' + char(10);
		SET @mDQry = @mDQry + ' 	AND C.DIVISION_ID = '''+ @p_division_id     +''' '+char(10)
		SET @mDQry = @mDQry + ' 	AND C.FROM_SITE_COMPANY_ID = '''+ @p_company_id + ''' ' +char(10);
		SET @mDQry = @mDQry + ' 	AND C.FROM_SITE_COMPANY_ID = '''+ @p_company_id + ''' ' +char(10);

		SET @mDQry = @mDQry + ' 	AND C.BIZ_TYPE <> ''E''       ' +char(10);
		--//Model
		IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mDQry = @mDQry + ' 					AND  C.item_id       IN ('+ @v_item_id     +')'+char(10);
		IF ( @v_project_code     IS NOT NULL AND @v_project_code    != ''  ) SET @mDQry = @mDQry + ' 					AND  C.PROJECT_CODE       IN ('+ @v_project_code     +')'+char(10);
		IF ( @v_pr_no    IS NOT NULL AND @v_pr_no    != ''  ) SET @mDQry = @mDQry + ' 					AND  D.PR_NO       IN ('+ @v_pr_no     +')'+char(10);
		--//Double Click
		IF ( @p_dbl_flag = 'Y')
		BEGIN
			SET @mDQry = @mDQry + ' 					AND  C.yyyymmdd       = '''+ @p_from_yyyymmdd     +''' '+char(10)
		END
		ELSE
		BEGIN
			SET @mDqry = @mDQry + ' 	    AND C.yyyymmdd >= '''+ @p_from_yyyymmdd +'''		AND C.yyyymmdd <= '''+ @p_to_yyyymmdd +'''                                                    ' + char(10);

			IF ( @v_requestor     IS NOT NULL AND @v_requestor    != ''  )
			BEGIN
				SET @mDQry = @mDQry + ' 					AND  C.requestor       IN ( ' + char(10) ;
				SET @mDQry = @mDQry + '													SELECT DISTINCT TT1.UserID FROM (' + char(10);
				SET @mDQry = @mDQry + '													(SELECT UserID FROM TB_FX_User WITH(NOLOCK) ' + char(10) ;
				SET @mDQry = @mDQry + '													WHERE 1 = 1 ' + char(10) ;
				SET @mDQry = @mDQry + '													AND UserName		IN (' + @v_requestor + ')' +char(10);
				SET @mDQry = @mDQry + '													UNION ALL ' + char(10);
				SET @mDQry = @mDQry + '													SELECT UserID FROM TB_FX_User WITH(NOLOCK) ' + char(10) ;
				SET @mDQry = @mDQry + '													WHERE 1 = 1 ' + char(10) ;
				SET @mDQry = @mDQry + '													AND UserID		IN (' + @v_requestor + '))) TT1 ' +char(10);
				SET @mDQry = @mDQry + '												) ' + char(10);
			END
		END
		IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDQry = @mDQry + ' 					AND  C.FROM_SITE     IN ('+ @v_from_site   +')'+char(10);

		SET @mDqry = @mDQry + ' 	UNION ALL                                                                                                                                                                                                                                                                                   ' + char(10);
		SET @mDqry = @mDQry + ' 	SELECT							' + char(10);
		SET @mDqry = @mDQry + '			DIVISION_ID					' + char(10);
		SET @mDqry = @mDQry + '			, ERP_SO_NO                 ' + char(10);
		SET @mDqry = @mDQry + '			, SHIPMENT_STATUS           ' + char(10);
		SET @mDqry = @mDQry + '			, ITEM_ID                   ' + char(10);
		SET @mDqry = @mDQry + '			, NICK_NAME                 ' + char(10);
		SET @mDqry = @mDQry + '			, ORIGIN_FROM_DIVISION_ID   ' + char(10);
		SET @mDqry = @mDQry + '			, ORIGIN_TO_DIVISION_ID     ' + char(10);
		SET @mDqry = @mDQry + '			, FROM_SITE                 ' + char(10);
		SET @mDqry = @mDQry + '			, TO_SITE                   ' + char(10);
		SET @mDqry = @mDQry + '			, PROJECT_CODE              ' + char(10);
		SET @mDqry = @mDQry + '			, REQUESTOR                 ' + char(10);
		SET @mDqry = @mDQry + '			, QTY                       ' + char(10);
		SET @mDqry = @mDQry + '			, YYYYMMDD                  ' + char(10);
		SET @mDqry = @mDQry + '			, BOD_ID                    ' + char(10);
		SET @mDqry = @mDQry + '			, REMARKS2                  ' + char(10);
		SET @mDqry = @mDQry + '			, REMARKS                   ' + char(10);
		SET @mDqry = @mDQry + '			, CHANGE_REQ_NO             ' + char(10);
		SET @mDqry = @mDQry + '			, REMARKS3                  ' + char(10);
		SET @mDqry = @mDQry + '			, ETD_DATE                  ' + char(10);
		SET @mDqry = @mDQry + '			, ETA_DATE                  ' + char(10);
		SET @mDqry = @mDQry + '			, LAST_UPDATED_BY           ' + char(10);
		SET @mDqry = @mDQry + '			, LAST_UPDATE_DATE          ' + char(10);
		SET @mDqry = @mDQry + '			, CONFIRM_ID                ' + char(10);
		SET @mDqry = @mDQry + '			, PR_NO						' + char(10);
		SET @mDqry = @mDQry + '			, FCST_TYPE                 ' + char(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS ERP_STATUS ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS change_type ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_ROUTE_ID ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_BOD_ID ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_INCOTERMS ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_D_COUNTRY ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_D_PORT_CODE ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_A_COUNTRY ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_A_PORT_CODE ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_CUSTOMER_LT ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_TO_COUNTRY ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_TO_CITY ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_ETA ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_ETD ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_SHIPMENT_DATE ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS EDIT_REMARKS ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS EDIT_MAIN ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS CHECK_NEED_YN ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS ELECTRODE_YN ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS ELECTRODE_TYPE ' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS ATTRIBUTE10 ' + CHAR(10);
		SET @mDqry = @mDQry + ' 	FROM							' + char(10);
		SET @mDqry = @mDQry + ' 	(								' + char(10);
		--SET @mDqry = @mDQry + ' 		SELECT                                                                                                                                                                                                                                                                                      ' + char(10);
		--SET @mDqry = @mDQry + ' 			tt0.DIVISION_ID                                                                                                                                                                                                                                                                         ' + char(10);
		--SET @mDqry = @mDQry + ' 			, ''-'' AS ERP_SO_NO                                                                                                                                                                                                                                                                      ' + char(10);
		--SET @mDqry = @mDQry + ' 			, ''P'' AS SHIPMENT_STATUS                                                                                                                                                                                                                                                             ' + char(10);
		--SET @mDqry = @mDQry + ' 			, tt0. ITEM_ID                                                                                                                                                                                                                                                                          ' + char(10);
		--SET @mDqry = @mDQry + ' 			, tt0.DIVISION_ID AS ORIGIN_FROM_DIVISION_ID                                                                                                                                                                                                                                                        ' + char(10);
		--SET @mDqry = @mDQry + ' 			, tt0.DIVISION_ID AS ORIGIN_TO_DIVISION_ID                                                                                                                                                                                                                                                          ' + char(10);
		--SET @mDqry = @mDQry + ' 			, tt0.PLANT_SITE_ID AS FROM_SITE                                                                                                                                                                                                                                                        ' + char(10);
		--SET @mDqry = @mDQry + ' 			, tt0.SCM_SITE_ID AS TO_SITE                                                                                                                                                                                                                                                            ' + char(10);
		--SET @mDqry = @mDQry + ' 			, tt0.PROJECT_CODE                                                                                                                                                                                                                                                                      ' + char(10);
		--SET @mDqry = @mDQry + ' 			, ''-'' AS REQUESTOR                                                                                                                                                                                                                                                                      ' + char(10);
		--SET @mDqry = @mDQry + ' 			, tt0.PLAN_QTY AS QTY                                                                                                                                                                                                                                                                              ' + char(10);
		--SET @mDqry = @mDQry + ' 			, tt0.YYYYMMDD                                                                                                                                                                                                                                                                          ' + char(10);
		--SET @mDqry = @mDQry + ' 			, tt0.BOD_ID                                                                                                                                                                                                                                                                            ' + char(10);
		--SET @mDqry = @mDQry + ' 			, ''-'' AS REMARKS2                                                                                                                                                                                                                                                                       ' + char(10);
		--SET @mDqry = @mDQry + ' 			, ''-'' AS REMARKS                                                                                                                                                                                                                                                                        ' + char(10);
		--SET @mDqry = @mDQry + ' 			, ''-'' AS CHANGE_REQ_NO                                                                                                                                                                                                                                                                  ' + char(10);
		--SET @mDqry = @mDQry + ' 			, ''-'' AS REMARKS3                                                                                                                                                                                                                                                                       ' + char(10);
		--SET @mDqry = @mDQry + ' 			, tt0.YYYYMMDD AS ETD_DATE                                                                                                                                                                                                                                                                        ' + char(10);
		--SET @mDqry = @mDQry + ' 			, CONVERT(VARCHAR(8),CONVERT(DATETIME,[dbo].[FN_GET_SSP_ETA_DATE](tt0.DIVISION_ID, tt0.BOD_ID, tt0.YYYYMMDD) ,112), 112) AS ETA_DATE                                                                                                                                                                                                                                                                        ' + char(10);
		--SET @mDqry = @mDQry + ' 			, tt0.LAST_UPDATED_BY                                                                                                                                                                                                                                                                   ' + char(10);
		--SET @mDqry = @mDQry + ' 			, tt0.LAST_UPDATE_DATE                                                                                                                                                                                                                                                                  ' + char(10);
		--SET @mDqry = @mDQry + ' 			, ''-'' AS CONFIRM_ID                                                                                                                                                                                                                                                                     ' + char(10);
		--SET @mDqry = @mDQry + ' 			, tt0.FCST_TYPE                                                                                                                                                                                                                                                                         ' + char(10);
		--SET @mDqry = @mDQry + ' 			, CASE WHEN isnull(tt2.ship_frozen,0) > 0 THEN CONVERT(CHAR(8), DATEADD(DD, isnull(tt2.ship_frozen,0), CONVERT(VARCHAR, ''' + @p_plan_start_yyyymmdd + ''', 121)), 112) ELSE ''' + @p_plan_start_yyyymmdd + ''' END AS frozen_yyyymmdd ' + char(10);
		--SET @mDqry = @mDQry + ' 	FROM SSP_ANL_ESS_REQ tt0  WITH(NOLOCK)                                                                                                                                                                                                                                                                 ' + char(10);
		--SET @mDqry = @mDQry + ' 	INNER JOIN  SCP_MST_BOD_N_V tt1 WITH(NOLOCK) ON tt0.DIVISION_ID = tt1.division_id  AND tt0.bod_id = tt1.bod_id                                                                                                                                                                                                                  ' + char(10);
		--SET @mDqry = @mDQry + ' 	INNER JOIN SCM_MST_SITE tt2 WITH(NOLOCK)                                                                                                                                                                                                                  ' + char(10);
		--SET @mDqry = @mDQry + ' 		ON tt0.DIVISION_ID = tt2.DIVISION_ID ' + char(10);
		--SET @mDqry = @mDQry + ' 		AND tt0.PLANT_SITE_ID = tt2.SCM_SITE_ID ' + char(10);
		--SET @mDqry = @mDQry + ' 		AND tt2.site_type		= ''PLANT'' ' + char(10);
		--SET @mDqry = @mDQry + ' 		AND tt2.valid_yn		= ''Y'' ' + char(10);
		--SET @mDqry = @mDQry + ' 	WHERE 1 = 1                                                                                                                                                                                                                                                                                 ' + char(10);
		--SET @mDQry = @mDQry + ' 	AND  tt0.DIVISION_ID       = '''+ @p_division_id     +''' '+char(10)
		--SET @mDQry = @mDQry + ' 	AND  tt2.COMPANY_ID       = '''+ @p_company_id     +''' '+char(10)
		SET @mDqry = @mDQry + ' 		SELECT                                                                                                                                       																			' + char(10);
		SET @mDqry = @mDQry + ' 			tt0.DIVISION_ID                                                                                                                          																			' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS ERP_SO_NO                                                                                                                     																			' + char(10);
		SET @mDqry = @mDQry + ' 			, ''P'' AS SHIPMENT_STATUS                                                                                                               																			' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.ITEM_ID                                                                                                                           																			' + char(10);
		SET @mDqry = @mDQry + ' 			, T.ITEM_NAME AS NICK_NAME                                                                                                                           																			' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.DIVISION_ID AS ORIGIN_FROM_DIVISION_ID                                                                                             																			' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.DIVISION_ID AS ORIGIN_TO_DIVISION_ID                                                                                               																			' + char(10);
		--SET @mDqry = @mDQry + ' 			, CASE WHEN tt0.PLANT_SITE_ID IS NULL OR tt0.PLANT_SITE_ID = '''' THEN ''KR012031-P'' ELSE  tt0.PLANT_SITE_ID END AS FROM_SITE																						' + char(10);                    
		SET @mDqry = @mDQry + ' 			, tt1.FROM_SITE AS FROM_SITE																						' + char(10);                    
		SET @mDqry = @mDQry + ' 			, tt0.SCM_SITE_ID AS TO_SITE                                                                                                             																			' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.PROJECT_CODE                                                                                                                       																			' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS REQUESTOR                                                                                                                     																			' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.QTY AS QTY                                                                                                                    																				' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.YYYYMMDD                                                                                                                           																			' + char(10);
		SET @mDqry = @mDQry + ' 			, tt1.BOD_ID AS BOD_ID  																																															' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS REMARKS2                                                                                                                      																			' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS REMARKS                                                                                                                       																			' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS CHANGE_REQ_NO                                                                                                                 																			' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS REMARKS3                                                                                                                      																			' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.YYYYMMDD AS ETD_DATE                                                                                                               																			' + char(10);
		SET @mDqry = @mDQry + ' 			, CONVERT(VARCHAR(8),CONVERT(DATETIME,[dbo].[FN_GET_SSP_ETA_DATE](tt0.DIVISION_ID, tt1.BOD_ID, tt0.YYYYMMDD) ,112), 112) AS ETA_DATE     																			' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.LAST_UPDATED_BY                                                                                                                    																			' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.LAST_UPDATE_DATE                                                                                                                   																			' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS CONFIRM_ID                                                                                                                    																				' + char(10);
		SET @mDqry = @mDQry + ' 			, tt3.PR_NO AS PR_NO                                                                                                                    																				' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.FCST_TYPE                                                                                                                          																			' + char(10);
		SET @mDqry = @mDQry + ' 			, CASE WHEN isnull(tt2.ship_frozen,0) > 0 THEN CONVERT(CHAR(8), DATEADD(DD, isnull(tt2.ship_frozen,0), CONVERT(VARCHAR, ''' + @p_plan_start_yyyymmdd + ''', 121)), 112) ELSE ''' + @p_plan_start_yyyymmdd + ''' END AS frozen_yyyymmdd ' + char(10);
		SET @mDqry = @mDQry + ' 	FROM DM_PLN_MKT_FCST tt0  WITH(NOLOCK)																																														' + char(10);


		SET @mDqry = @mDQry + '		INNER JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 ' + char(10);
		SET @mDqry = @mDQry + '			ON tt0.ITEM_ID		= T.ITEM_ID					 ' + char(10);
		SET @mDqry = @mDQry + '		   AND tt0.DIVISION_ID	= T.DIVISION_ID				 ' + char(10);
		SET @mDqry = @mDQry + '		   AND T.ITEM_TYPE		IN (''Q'',''R'')			 ' + char(10);


		SET @mDqry = @mDQry + '     LEFT OUTER JOIN SSP_ANL_ESS_REQ B WITH(NOLOCK)	 ON tt0.DIVISION_ID = B.DIVISION_ID ' + char(10);
		SET @mDqry = @mDQry + '      AND tt0.PROJECT_CODE = B.PROJECT_CODE   ' + char(10);
		SET @mDqry = @mDQry + '      AND tt0.SCM_SITE_ID = B.SCM_SITE_ID		' + char(10);
		SET @mDqry = @mDQry + '      AND tt0.ITEM_ID = B.ITEM_ID				' + char(10);
		SET @mDqry = @mDQry + '      AND tt0.DOM_EXP = B.DOM_EXP				' + char(10);
		SET @mDqry = @mDQry + '      AND tt0.FCST_TYPE = B.FCST_TYPE			' + char(10);
		SET @mDqry = @mDQry + '      AND tt0.INCOTERMS = B.INCOTERMS			' + char(10);
		SET @mDqry = @mDQry + '      AND tt0.YYYYMMDD = B.YYYYMMDD				' + char(10);


		SET @mDqry = @mDQry + '		LEFT OUTER JOIN SSP_ANL_ESS_PR tt3  WITH(NOLOCK)		' + char(10);
		SET @mDqry = @mDQry + '			ON B.DM_REQ_NO = tt3.DM_REQ_NO				   ' + char(10);
		SET @mDqry = @mDQry + '			AND B.ITEM_ID = tt3.PR_ITEM_ID					 ' + char(10);
		SET @mDqry = @mDQry + '			AND B.YYYYMMDD = tt3.YYYYMMDD					 ' + char(10);

		
		SET @mDqry = @mDQry + ' 	INNER JOIN  scp_mst_bod_n_v tt1 WITH(NOLOCK) ON tt0.DIVISION_ID = tt1.division_id  AND (SELECT TOP 1 BOD_ID 																													' + char(10);
		SET @mDqry = @mDQry + ' 																						 	FROM SCP_MST_BOD_N_V WITH(NOLOCK)																										' + char(10);
		SET @mDqry = @mDQry + ' 																						 	WHERE DIVISION_ID	= tt0.DIVISION_ID  																								' + char(10);
--		SET @mDqry = @mDQry + ' 																						 	AND FROM_SITE	= CASE WHEN tt0.PLANT_SITE_ID IS NULL OR tt0.PLANT_SITE_ID = '''' THEN ''KR012031-P'' ELSE  tt0.PLANT_SITE_ID END   ' + char(10);
		SET @mDqry = @mDQry + ' 																						 	AND FROM_SITE	= CASE WHEN tt0.PLANT_SITE_ID IS NULL OR tt0.PLANT_SITE_ID = '''' THEN ''' + @v_KR012031 + ''' ELSE  tt0.PLANT_SITE_ID END   ' + char(10);
		SET @mDqry = @mDQry + ' 																						 	AND TO_SITE		= tt0.SCM_SITE_ID 																								    ' + char(10);
		SET @mDqry = @mDQry + ' 																						 	AND FROM_YYYYMMDD <= tt0.YYYYMMDD																								    ' + char(10);
		SET @mDqry = @mDQry + ' 																						 	AND TO_YYYYMMDD >= tt0.YYYYMMDD																								    ' + char(10);
		SET @mDqry = @mDQry + ' 																						 	AND INCOTERMS = tt0.INCOTERMS																								    ' + char(10);		
		SET @mDqry = @mDQry + ' 																						 	ORDER BY 																														    ' + char(10);
		SET @mDqry = @mDQry + ' 																						 	PRIORITY ASC																												    ' + char(10);
		SET @mDqry = @mDQry + ' 																						 ) = tt1.bod_id                                     																				    ' + char(10);
		SET @mDqry = @mDQry + ' 	INNER JOIN SCM_MST_SITE tt2 WITH(NOLOCK)                                                                                                         																		    ' + char(10);
		SET @mDqry = @mDQry + ' 		ON tt0.DIVISION_ID = tt2.DIVISION_ID 																																												    ' + char(10);
--		SET @mDqry = @mDQry + ' 		AND CASE WHEN tt1.FROM_SITE IS NULL OR tt1.FROM_SITE = '''' THEN ''KR012031-P'' ELSE  tt1.FROM_SITE END = tt2.SCM_SITE_ID 																				    ' + char(10);
		SET @mDqry = @mDQry + ' 		AND CASE WHEN tt1.FROM_SITE IS NULL OR tt1.FROM_SITE = '''' THEN ''' + @v_KR012031 +''' ELSE  tt1.FROM_SITE END = tt2.SCM_SITE_ID 																				    ' + char(10);
		SET @mDqry = @mDQry + ' 		AND tt2.site_type		= ''PLANT''																																													    ' + char(10);
		SET @mDqry = @mDQry + ' 		AND tt2.valid_yn		= ''Y''																																														    ' + char(10);

	
		SET @mDqry = @mDQry + ' 	WHERE 1 = 1      																																																		    ' + char(10);
		SET @mDqry = @mDQry + ' 	AND  tt0.MEASURE     = ''BNPIn''																																														    ' + char(10);
		SET @mDqry = @mDQry + ' 	AND  tt0.ATTRIBUTE9 IS NULL																																											    ' + char(10);

		SET @mDQry = @mDQry + ' 	AND  tt0.DIVISION_ID       = '''+ @p_division_id     +''' '+char(10)
		SET @mDQry = @mDQry + ' 	AND  tt2.COMPANY_ID        = '''+ @p_company_id     +''' '+char(10)
		IF ( @v_pr_no    IS NOT NULL AND @v_pr_no    != ''  ) SET @mDQry = @mDQry + ' 					AND  tt3.PR_NO      IN ('+ @v_pr_no     +')'+char(10);
																											
		IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mDQry = @mDQry + ' 					AND  tt0.item_id       IN ('+ @v_item_id     +')'+char(10);
		IF ( @v_project_code     IS NOT NULL AND @v_project_code    != ''  ) SET @mDQry = @mDQry + ' 					AND  tt0.PROJECT_CODE       IN ('+ @v_project_code     +')'+char(10);
		
		--//Double Click
		IF ( @p_dbl_flag = 'Y')
		BEGIN
			SET @mDQry = @mDQry + ' 					AND  tt0.yyyymmdd       = '''+ @p_from_yyyymmdd     +''' '+char(10)
		END
		ELSE
		BEGIN
			SET @mDqry = @mDQry + ' 	    AND tt0.yyyymmdd >= '''+ @p_from_yyyymmdd +'''		AND tt0.yyyymmdd <= '''+ @p_to_yyyymmdd +'''                                                    ' + char(10);
		END
		IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDQry = @mDQry + ' 					AND  tt1.FROM_SITE     IN ('+ @v_from_site   +')'+char(10);
		SET @mDqry = @mDQry + '		) t	' + char(10);
		SET @mDqry = @mDQry + ' 	WHERE 1 = 1	' + char(10);
		--SET @mDqry = @mDQry + ' 	AND t.YYYYMMDD >= t.frozen_yyyymmdd ' + char(10);
		SET @mDqry = @mDQry + ' ) a                                                                                                                                                                                                                                                                                             ' + char(10);
		--SET @mDqry = @mDQry + ' INNER JOIN  SCP_MST_BOD_N_V b  WITH(NOLOCK)                                                                                                                                                                                                                                                                     ' + char(10);
		SET @mDqry = @mDQry + ' INNER JOIN  scp_mst_bod_n_v b  WITH(NOLOCK)                                                                                                                                                                                                                                                                     ' + char(10);
		SET @mDqry = @mDQry + ' 	ON (CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID END) = b.division_id  AND a.bod_id = b.bod_id                                                                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U  WITH(NOLOCK) ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = ''Y''                                                                                                                                                                                                                  ' + char(10);
		
		--SET @mDqry = @mDQry + ' LEFT OUTER JOIN  DM_MST_ITEM_SINGLE_V DMIV  WITH(NOLOCK)                                                                                                                                                                                                                                                                     ' + char(10);
		--SET @mDqry = @mDQry + ' 	ON (CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID END) = DMIV.division_id  AND a.ITEM_ID = DMIV.ITEM_ID                                                                                                                                                          ' + char(10);
		
		
		SET @mDqry = @mDQry + ' INNER JOIN SCM_MST_SITE f  WITH(NOLOCK) ON f.division_id = a.DIVISION_ID and f.SCM_SITE_ID = a.TO_SITE                                                                                                                                                                                       ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_NAME_KO										                                                                                                                                                                                    ' + char(10);
		SET @mDqry = @mDQry + '  	  	FROM(																						                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + '  	  		SELECT aa.DIVISION_ID, aa.PROJECT_CODE, aa.SCM_SITE_ID, aa.ITEM_ID,ac.DEPT_NAME_KO									                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + '  	  				,ROW_NUMBER() over(partition by aa.DIVISION_ID, aa.SCM_SITE_ID, aa.ITEM_ID order by aa.PROJECT_CODE) num		                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + '  	  		FROM scm_mst_site_item aa  WITH(NOLOCK)																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  		LEFT OUTER JOIN SCM_MST_SITE  BB WITH(NOLOCK) 																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  			ON BB.SCM_SITE_ID = aa.SCM_SITE_ID																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  		LEFT OUTER JOIN SCM_MST_SSO_USER_INFO  ab WITH(NOLOCK) 																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  			ON  ab.USER_ID = aa.OWNER 																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO  ac WITH(NOLOCK) 																			                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  			ON  bb.DEPT_ID = ac.DEPT_ID																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  	) a WHERE num = 1) g on g.DIVISION_ID =  (CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_TO_DIVISION_ID ELSE a.DIVISION_ID END) and g.SCM_SITE_ID = a.TO_SITE and g.ITEM_ID = a.ITEM_ID	                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN (SELECT CONFIRM_ID, CHANGE_REQ_NO FROM(								                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' SELECT CONFIRM_ID ,CHANGE_REQ_NO								                                                                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' ,ROW_NUMBER() OVER(PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) NUM								                                                                                                                                                                                        ' + char(10);
		SET @mDqry = @mDQry + ' FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE  WITH(NOLOCK)	 							                                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' WHERE VALID_YN = ''Y''								                                                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' ) A WHERE NUM = 1) h on h.confirm_id = a.confirm_id								                                                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN SSP_MST_MODEL_USER mu  WITH(NOLOCK) on mu.division_id = a.origin_from_division_id and mu.from_site = a.from_site and mu.item_id = a.item_id and mu.valid_yn = ''Y''                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U2  WITH(NOLOCK) ON mu.user_id = u2.UserID AND U2.UseYN = ''Y''                                                                                                                                                                                                                      ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U3  WITH(NOLOCK) ON a.requestor = u3.UserID AND U3.UseYN = ''Y''                                                                                                                                                                                                                     ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) ON SI.DIVISION_ID  = (CASE WHEN A.DIVISION_ID =''EE'' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END)                                                                                                                                      ' + char(10);
		SET @mDqry = @mDQry + '  										AND SI.SCM_SITE_ID  = A.TO_SITE                                                                                                                                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + '  										AND SI.ITEM_ID  = A.ITEM_ID                                                                                                                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + '  										AND SI.PROJECT_CODE  = A.PROJECT_CODE                                                                                                                                                                                                                   ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ T1  WITH(NOLOCK)                                                                                                                                                                                                                                                 ' + char(10);
		SET @mDqry = @mDQry + ' ON h.CHANGE_REQ_NO = T1.CHANGE_REQ_NO                                                                                                                                                                                                                                                           ' + char(10);
		SET @mDqry = @mDQry + ' 	  WHERE 1=1                                                                                                               ' + char(10);
		SET @mDqry = @mDQry + ' 		AND (a.shipment_status IS NOT NULL AND isnull(a.shipment_status,'''') != '''') '+char(10);
		SET @mDqry = @mDQry + ' 		AND a.qty > 0 '+char(10);
		
		SET @mDqry = @mDQry + ' ORDER BY a.division_id, a.shipment_status, a.yyyymmdd,  a.item_id, a.ERP_SO_NO DESC, a.from_site, a.to_site, a.project_code, a.fcst_type     ' + char(10);
	END
	ELSE
	BEGIN
		SET @mDqry = @mDQry + ' SELECT   AA.*FROM (      																										' + char(10);
		SET @mDqry = @mDQry + ' SELECT   a.division_id         																										' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(con.erp_so_no, ''-'') AS erp_so_no                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 		 , case WHEN (a.CONFIRM_ID is null OR a.CONFIRM_ID = ''-'') THEN ''P'' else ''C'' END as shipment_status                                                                                                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.item_id                                                                                                            ' + char(10);
		--SET @mDqry = @mDQry + ' 		 , dbo.fn_get_item_nickname(a.division_id, a.item_id ) AS nick_name                                                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , M.ITEM_NAME AS nick_name                                                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.plant_site_id as from_site                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.scm_site_id as to_site                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.plant_site_id ),''-'') AS from_site_description                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.scm_site_id ),''-'') as to_site_description                      ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(a.PROJECT_CODE,''-'') as PROJECT_CODE                      ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(dbo.FN_GET_PROJECT_NAME(a.division_id,a.PROJECT_CODE),''-'') as PROJECT_NAME                      ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(case when a.DIVISION_ID = ''40'' then case when a.PROJECT_CODE is not null and a.PROJECT_CODE != ''-'' then a.PROJECT_CODE else g.PROJECT_CODE end when a.DIVISION_ID = ''EE'' and a.DIVISION_ID = ''40'' then g.project_code else f.END_CUSTOMER end,''-'') end_customer            ' + char(10);
		SET @mDqry = @mDQry + ' 		 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '','', '''+@p_language+''') AS MTK_OWNER                                                                                         ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U3.UserName ELSE U3.UserName_E END + ''('' + t0.dm_requested_by + '')'' requestor    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , convert(int, a.qty) AS shipment_confirm_qty                                                                                        ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) AS shipment_date                                       ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.transport_mode                                                                                                     ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(con.remarks2, ''-'') AS remarks2																											' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(con.remarks, ''-'') AS remarks				                                                                                        ' + char(10);
		SET @mDqry = @mDQry + '			 , ''-'' AS CHANGE_REASON_CODE ' + char(10);
		SET @mDqry = @mDQry + '			 , '''' AS CHANGE_REASON_DETAIL ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(con.remarks3, ''-'') AS remarks3																											' + char(10);
		SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info(a.division_id, a.scm_site_id, ''SOLDTO_CODE'' ) AS soldto_description                ' + char(10);
		SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info(a.division_id, a.scm_site_id, ''SHIPTO_CODE'' ) AS shipto_description                ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.ssp_incoterms  AS INCOTERMS                                                                                                        ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.lt_total AS lt_day                                                                                                 ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_ETD_DATE](a.division_id, t0.bod_id, a.yyyymmdd)), 23)  AS etd                                                 ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_ETA_DATE](a.division_id, t0.bod_id, a.yyyymmdd)), 23)  AS eta                                                 ' + char(10);
		SET @mDQry = @mDQry + ' 		 , CASE WHEN b.transport_mode = ''TRK'' then ''-'' else CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](a.DIVISION_ID, t0.BOD_ID, a.YYYYMMDD), 112), 23) end as Expected_Shipping_Date    ' + char(10) ;
		--SET @mDqry = @mDQry + ' 		 , a.fcst_type                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U.UserName ELSE U.UserName_E END + ''('' + a.LAST_UPDATED_BY + '')'' updated_by    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , case when u.UserName is not null then a.LAST_UPDATE_DATE else null end as updated_date                                                                                          ' + char(10);
		SET @mDqry = @mDQry + '			 , h.CHANGE_REQ_NO                   ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U2.UserName ELSE U2.UserName_E END + ''('' + mu.user_id + '')'' model_user    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.confirm_id                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + ' 		 , T2.PR_NO                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.lt_total AS NEW_LT_DAY                                                                                                 ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.transport_mode AS NEW_TRANSPORT_MODE                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.FCST_TYPE                                                                                                                                                                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.ERP_STATUS ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.change_type ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.route_id AS NEW_ROUTE_ID ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.bod_id AS NEW_BOD_ID ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.incoterms AS NEW_INCOTERMS ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.d_country AS NEW_D_COUNTRY ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.d_port_code AS NEW_D_PORT_CODE ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.a_country AS NEW_A_COUNTRY ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.a_port_code AS NEW_A_PORT_CODE ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.customer_lt AS NEW_CUSTOMER_LT ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.to_country AS NEW_TO_COUNTRY ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.to_city AS NEW_TO_CITY ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_ETA_DATE](a.division_id, t0.bod_id, a.yyyymmdd)), 23) 		AS NEW_ETA ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_ETD_DATE](a.division_id, t0.bod_id, a.yyyymmdd)), 23) 		AS NEW_ETD ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),		CONVERT(DATETIME, a.yyyymmdd,112), 23)		AS NEW_SHIPMENT_DATE ' + char(10);
		SET @mDqry = @mDQry + ' 		 , ''N'' AS EDIT_REMARKS ' + char(10);
		SET @mDqry = @mDQry + ' 		 , ''N'' AS EDIT_MAIN ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(con.CHECK_NEED_YN,''N'') AS CHECK_NEED_YN ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(g.DEPT_NAME_KO,''-'') as TEAM                      ' + char(10);
		SET @mDqry = @mDQry + '			 , CASE WHEN isnull(BB.ship_frozen,0) > 0 THEN CONVERT(CHAR(8), DATEADD(DD, isnull(BB.ship_frozen,0), CONVERT(VARCHAR, ''' + @p_plan_start_yyyymmdd + ''', 121)), 112) ELSE ''' + @p_plan_start_yyyymmdd + ''' END AS frozen_yyyymmdd   ' + char(10);
		SET @mDqry = @mDQry + ' FROM  SSP_ANL_ESS_PLAN a WITH(NOLOCK)                                                                                                                                                                                                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + ' 	INNER JOIN DM_MST_ITEM_SINGLE_V M WITH(NOLOCK)																																												' + char(10);
		SET @mDqry = @mDQry + '      ON a.DIVISION_ID = M.DIVISION_ID																																															' + char(10);
		SET @mDqry = @mDQry + '        AND a.ITEM_ID       = M.ITEM_ID       																																													' + char(10);

		SET @mDqry = @mDQry + ' LEFT OUTER JOIN  SSP_ANL_SHIP_CONFIRM con WITH(NOLOCK) ON a.DIVISION_ID = con.DIVISION_ID and a.CONFIRM_ID = con.CONFIRM_ID'+ char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN  SSP_ANL_ESS_REQ	  T0  WITH(NOLOCK) ON a.DIVISION_ID = T0.DIVISION_ID and a.PLANT_SITE_ID = T0.PLANT_SITE_ID and a.SCM_SITE_ID = T0.SCM_SITE_ID and a.ITEM_ID = T0.ITEM_ID and a.yyyymmdd = T0.yyyymmdd and a.dm_req_no = T0.dm_req_no' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN  SSP_ANL_ESS_PR		  T2  WITH(NOLOCK) ON T2.DM_REQ_NO = T0.DM_REQ_NO and T2.PR_ITEM_ID = T0.ITEM_ID and T2.yyyymmdd = T0.yyyymmdd' + char(10);
		--SET @mDqry = @mDQry + ' LEFT OUTER JOIN  SCP_MST_BOD_N_V b                                                                                                                                                                                                                                                                     ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN  scp_mst_bod_n_v b                                                                                                                                                                                                                                                                     ' + char(10);
		SET @mDqry = @mDQry + ' 	ON b.bod_id = T0.bod_id                                                                                                                                                                  ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = ''Y''                                                                                                                                                                                                                  ' + char(10);
		SET @mDqry = @mDQry + ' INNER JOIN SCM_MST_SITE f ON f.division_id = a.DIVISION_ID and f.SCM_SITE_ID = a.SCM_SITE_ID                                                                                                                                                                                       ' + char(10);
		SET @mDqry = @mDQry + ' INNER JOIN SCM_MST_SITE BB ON A.DIVISION_ID = BB.DIVISION_ID	AND A.PLANT_SITE_ID = BB.SCM_SITE_ID	AND BB.site_type		= ''PLANT''	AND BB.valid_yn		= ''Y''																					' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_NAME_KO										                                                                                                                                                                                    ' + char(10);
		SET @mDqry = @mDQry + '  	  	FROM(																						                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + '  	  		SELECT aa.DIVISION_ID, aa.PROJECT_CODE, aa.SCM_SITE_ID, aa.ITEM_ID,ac.DEPT_NAME_KO									                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + '  	  				,ROW_NUMBER() over(partition by aa.DIVISION_ID, aa.SCM_SITE_ID, aa.ITEM_ID order by aa.PROJECT_CODE) num		                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + '  	  		FROM scm_mst_site_item aa																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  		LEFT OUTER JOIN SCM_MST_SITE  BB WITH(NOLOCK) 																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  			ON BB.SCM_SITE_ID = aa.SCM_SITE_ID																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  		LEFT OUTER JOIN SCM_MST_SSO_USER_INFO  ab WITH(NOLOCK) 																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  			ON  ab.USER_ID = aa.OWNER																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO  ac WITH(NOLOCK) 																			                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  			ON  bb.DEPT_ID = ac.DEPT_ID																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  	) a WHERE num = 1) g on g.DIVISION_ID =  a.DIVISION_ID and g.SCM_SITE_ID = a.SCM_SITE_ID and g.ITEM_ID = a.ITEM_ID	                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN (SELECT CONFIRM_ID, CHANGE_REQ_NO FROM(								                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' SELECT CONFIRM_ID ,CHANGE_REQ_NO								                                                                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' ,ROW_NUMBER() OVER(PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) NUM								                                                                                                                                                                                        ' + char(10);
		SET @mDqry = @mDQry + ' FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WITH(NOLOCK)								                                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' WHERE VALID_YN = ''Y''								                                                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' ) A WHERE NUM = 1) h on h.confirm_id = a.confirm_id								                                                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN SSP_MST_MODEL_USER mu on mu.division_id = a.division_id and mu.from_site = a.PLANT_SITE_ID and mu.item_id = a.item_id and mu.valid_yn = ''Y''                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U2 WITH(NOLOCK) ON mu.user_id = u2.UserID AND U2.UseYN = ''Y''                                                                                                                                                                                                                      ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U3 WITH(NOLOCK) ON t0.dm_requested_by = u3.UserID AND U3.UseYN = ''Y''                                                                                                                                                                                                                     ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) ON SI.DIVISION_ID  = A.DIVISION_ID                                                                                                                                    ' + char(10);
		SET @mDqry = @mDQry + '  										AND SI.SCM_SITE_ID  = A.SCM_SITE_ID                                                                                                                                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + '  										AND SI.ITEM_ID  = A.ITEM_ID                                                                                                                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + '  										AND SI.PROJECT_CODE  = A.PROJECT_CODE                                                                                                                                                                                                                   ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ T1 WITH(NOLOCK)                                                                                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' ON h.CHANGE_REQ_NO = T1.CHANGE_REQ_NO                                                                                                                                                                                                                                                           ' + char(10);
		SET @mDqry = @mDQry + ' 	  WHERE 1=1 and MEASURE = ''BNP_IN''                                                                                                              ' + char(10);
		SET @mDQry = @mDQry + ' 		AND  a.division_id = '''+ @p_division_id + ''' ' +char(10);
		SET @mDQry = @mDQry + ' 		AND  a.PLAN_START_YYYYMMDD = '''+ @p_plan_start_yyyymmdd + ''' ' +char(10);
		IF ( @p_dbl_flag = 'Y')
			BEGIN
				SET @mDQry = @mDQry + ' 					AND  a.yyyymmdd       = '''+ @p_from_yyyymmdd     +''' '+char(10)
			END
		ELSE
			BEGIN
				SET @mDqry = @mDQry + ' 	    AND a.yyyymmdd >= '''+ @p_from_yyyymmdd +'''		AND a.yyyymmdd <= '''+ @p_to_yyyymmdd +'''                                                    ' + char(10);

				IF ( @v_requestor     IS NOT NULL AND @v_requestor    != ''  )
				BEGIN
					SET @mDQry = @mDQry + ' 					AND  t0.dm_requested_by       IN ( ' + char(10) ;
					SET @mDQry = @mDQry + '													SELECT DISTINCT TT1.UserID FROM (' + char(10);
					SET @mDQry = @mDQry + '													(SELECT UserID FROM TB_FX_User ' + char(10) ;
					SET @mDQry = @mDQry + '													WHERE 1 = 1 ' + char(10) ;
					SET @mDQry = @mDQry + '													AND UserName		IN (' + @v_requestor + ')' +char(10);
					SET @mDQry = @mDQry + '													UNION ALL ' + char(10);
					SET @mDQry = @mDQry + '													SELECT UserID FROM TB_FX_User ' + char(10) ;
					SET @mDQry = @mDQry + '													WHERE 1 = 1 ' + char(10) ;
					SET @mDQry = @mDQry + '													AND UserID		IN (' + @v_requestor + '))) TT1 ' +char(10);
					SET @mDQry = @mDQry + '												) ' + char(10);
				END
			END


		IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mDQry = @mDQry + ' 					AND  a.item_id       IN ('+ @v_item_id     +')'+char(10);
		IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDQry = @mDQry + ' 					AND  a.PLANT_SITE_ID     IN ('+ @v_from_site   +')'+char(10);
		IF ( @v_pr_no    IS NOT NULL AND @v_pr_no    != ''  ) SET @mDQry = @mDQry + ' 						AND  T2.PR_NO       IN ('+ @v_pr_no     +')'+char(10);



		SET @mDqry = @mDQry + ' 		  AND a.qty > 0 '+char(10);
		SET @mDqry = @mDQry + ' 		  AND a.CONFIRM_ID IS NULL '+char(10);

		SET @mDqry = @mDQry + ' UNION ALL'+char(10);

		SET @mDqry = @mDQry + ' SELECT   a.division_id         																										' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(con.erp_so_no, ''-'') AS erp_so_no                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 		 , case WHEN (a.CONFIRM_ID is null OR a.CONFIRM_ID = ''-'') THEN ''P'' else ''C'' END as shipment_status                                                                                                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.item_id                                                                                                            ' + char(10);
		--SET @mDqry = @mDQry + ' 		 , dbo.fn_get_item_nickname(a.division_id, a.item_id ) AS nick_name                                                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , M.ITEM_NAME AS nick_name                                                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.plant_site_id as from_site                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.scm_site_id as to_site                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.plant_site_id ),''-'') AS from_site_description                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.scm_site_id ),''-'') as to_site_description                      ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(a.PROJECT_CODE,''-'') as PROJECT_CODE                      ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(dbo.FN_GET_PROJECT_NAME(a.division_id,a.PROJECT_CODE),''-'') as PROJECT_NAME                      ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(case when a.DIVISION_ID = ''40'' then case when a.PROJECT_CODE is not null and a.PROJECT_CODE != ''-'' then a.PROJECT_CODE else g.PROJECT_CODE end when a.DIVISION_ID = ''EE'' and a.DIVISION_ID = ''40'' then g.project_code else f.END_CUSTOMER end,''-'') end_customer            ' + char(10);
		SET @mDqry = @mDQry + ' 		 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '','', '''+@p_language+''') AS MTK_OWNER                                                                                         ' + char(10);
		SET @mDqry = @mDQry + ' 		 , t0.dm_requested_by AS requestor    ' + char(10);
		--SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U3.UserName ELSE U3.UserName_E END + ''('' + t0.dm_requested_by + '')'' AS requestor    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , convert(int, a.qty) AS shipment_confirm_qty                                                                                        ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) AS shipment_date                                       ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.transport_mode                                                                                                     ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(con.remarks2, ''-'') AS remarks2																											' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(con.remarks, ''-'') AS remarks				                                                                                        ' + char(10);
		SET @mDqry = @mDQry + '			 , ''-'' AS CHANGE_REASON_CODE ' + char(10);
		SET @mDqry = @mDQry + '			 , '''' AS CHANGE_REASON_DETAIL ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(con.remarks3, ''-'') AS remarks3																											' + char(10);
		SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info(a.division_id, a.scm_site_id, ''SOLDTO_CODE'' ) AS soldto_description                ' + char(10);
		SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info(a.division_id, a.scm_site_id, ''SHIPTO_CODE'' ) AS shipto_description                ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.ssp_incoterms  AS INCOTERMS                                                                                                        ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.lt_total AS lt_day                                                                                                 ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_ETD_DATE](a.division_id, t0.bod_id, a.yyyymmdd)), 23)  AS etd                                                 ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_ETA_DATE](a.division_id, t0.bod_id, a.yyyymmdd)), 23)  AS eta                                                 ' + char(10);
		SET @mDQry = @mDQry + ' 		 , CASE WHEN b.transport_mode = ''TRK'' then ''-'' else CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](a.DIVISION_ID, t0.BOD_ID, a.YYYYMMDD), 112), 23) end as Expected_Shipping_Date    ' + char(10) ;
		--SET @mDqry = @mDQry + ' 		 , a.fcst_type                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U.UserName ELSE U.UserName_E END + ''('' + T0.LAST_UPDATED_BY + '')'' updated_by    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , case when u.UserName is not null then a.LAST_UPDATE_DATE else null end as updated_date                                                                                          ' + char(10);
		SET @mDqry = @mDQry + '			 , h.CHANGE_REQ_NO                   ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U2.UserName ELSE U2.UserName_E END + ''('' + mu.user_id + '')'' model_user    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.confirm_id                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + ' 		 , T2.PR_NO                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.lt_total AS NEW_LT_DAY                                                                                                 ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.transport_mode AS NEW_TRANSPORT_MODE                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.FCST_TYPE                                                                                                                                                                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.ERP_STATUS ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.change_type ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.route_id AS NEW_ROUTE_ID ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.bod_id AS NEW_BOD_ID ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.incoterms AS NEW_INCOTERMS ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.d_country AS NEW_D_COUNTRY ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.d_port_code AS NEW_D_PORT_CODE ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.a_country AS NEW_A_COUNTRY ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.a_port_code AS NEW_A_PORT_CODE ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.customer_lt AS NEW_CUSTOMER_LT ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.to_country AS NEW_TO_COUNTRY ' + char(10);
		SET @mDqry = @mDQry + ' 		 , con.to_city AS NEW_TO_CITY ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_ETA_DATE](a.division_id, t0.bod_id, a.yyyymmdd)), 23) 		AS NEW_ETA ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_ETD_DATE](a.division_id, t0.bod_id, a.yyyymmdd)), 23) 		AS NEW_ETD ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),		CONVERT(DATETIME, a.yyyymmdd,112), 23)		AS NEW_SHIPMENT_DATE ' + char(10);
		SET @mDqry = @mDQry + ' 		 , ''N'' AS EDIT_REMARKS ' + char(10);
		SET @mDqry = @mDQry + ' 		 , ''N'' AS EDIT_MAIN ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(con.CHECK_NEED_YN,''N'') AS CHECK_NEED_YN ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(g.DEPT_NAME_KO,''-'') as TEAM                      ' + char(10);
		SET @mDqry = @mDQry + ' 		 , '+@p_from_yyyymmdd+' as frozen_yyyymmdd                      ' + char(10);
		SET @mDqry = @mDQry + ' FROM  SSP_ANL_ESS_PLAN a WITH(NOLOCK)                                                                                                                                                                                                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + ' 	INNER JOIN DM_MST_ITEM_SINGLE_V M WITH(NOLOCK)																																												' + char(10);
		SET @mDqry = @mDQry + '      ON a.DIVISION_ID = M.DIVISION_ID																																															' + char(10);
		SET @mDqry = @mDQry + '        AND a.ITEM_ID       = M.ITEM_ID       																																													' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN  SSP_ANL_SHIP_CONFIRM con WITH(NOLOCK) ON a.DIVISION_ID = con.DIVISION_ID and a.CONFIRM_ID = con.CONFIRM_ID'+ char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN  SSP_ANL_ESS_REQ	  T0 WITH(NOLOCK) ON a.DIVISION_ID = T0.DIVISION_ID and a.PLANT_SITE_ID = T0.PLANT_SITE_ID and a.SCM_SITE_ID = T0.SCM_SITE_ID and a.ITEM_ID = T0.ITEM_ID and a.yyyymmdd = T0.yyyymmdd and  a.DM_REQ_NO = T0.DM_REQ_NO ' + char(10);
	    SET @mDqry = @mDQry + ' LEFT OUTER JOIN  SSP_ANL_ESS_PR		  T2 WITH(NOLOCK) ON T2.DM_REQ_NO = T0.DM_REQ_NO and T2.PR_ITEM_ID = T0.ITEM_ID and T2.yyyymmdd = T0.yyyymmdd' + char(10);
		--SET @mDqry = @mDQry + ' LEFT OUTER JOIN  SCP_MST_BOD_N_V b                                                                                                                                                                                                                                                                     ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN  scp_mst_bod_n_v b                                                                                                                                                                                                                                                                     ' + char(10);
		SET @mDqry = @mDQry + ' 	ON B.BOD_ID = CON.BOD_ID                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = ''Y''                                                                                                                                                                                                                  ' + char(10);
		SET @mDqry = @mDQry + ' INNER JOIN SCM_MST_SITE f ON f.division_id = a.DIVISION_ID and f.SCM_SITE_ID = a.SCM_SITE_ID                                                                                                                                                                                       ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_NAME_KO										                                                                                                                                                                                    ' + char(10);
		SET @mDqry = @mDQry + '  	  	FROM(																						                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + '  	  		SELECT aa.DIVISION_ID, aa.PROJECT_CODE, aa.SCM_SITE_ID, aa.ITEM_ID,ac.DEPT_NAME_KO									                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + '  	  				,ROW_NUMBER() over(partition by aa.DIVISION_ID, aa.SCM_SITE_ID, aa.ITEM_ID order by aa.PROJECT_CODE) num		                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + '  	  		FROM scm_mst_site_item aa																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  		LEFT OUTER JOIN SCM_MST_SITE  BB WITH(NOLOCK) 																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  			ON BB.SCM_SITE_ID = aa.SCM_SITE_ID																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  		LEFT OUTER JOIN SCM_MST_SSO_USER_INFO  ab WITH(NOLOCK) 																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  			ON  ab.USER_ID = aa.OWNER																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO  ac WITH(NOLOCK) 																			                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  			ON  bb.DEPT_ID = ac.DEPT_ID																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  	) a WHERE num = 1) g on g.DIVISION_ID =  a.DIVISION_ID and g.SCM_SITE_ID = a.SCM_SITE_ID and g.ITEM_ID = a.ITEM_ID	                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN (SELECT CONFIRM_ID, CHANGE_REQ_NO FROM(								                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' SELECT CONFIRM_ID ,CHANGE_REQ_NO								                                                                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' ,ROW_NUMBER() OVER(PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) NUM								                                                                                                                                                                                        ' + char(10);
		SET @mDqry = @mDQry + ' FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WITH(NOLOCK)								                                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' WHERE VALID_YN = ''Y''								                                                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' ) A WHERE NUM = 1) h on h.confirm_id = a.confirm_id								                                                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN SSP_MST_MODEL_USER mu on mu.division_id = a.division_id and mu.from_site = a.PLANT_SITE_ID and mu.item_id = a.item_id and mu.valid_yn = ''Y''                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U2 ON mu.user_id = u2.UserID AND U2.UseYN = ''Y''                                                                                                                                                                                                                      ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U3 ON t0.dm_requested_by = u3.UserID AND U3.UseYN = ''Y''                                                                                                                                                                                                                     ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) ON SI.DIVISION_ID  = A.DIVISION_ID                                                                                                                                    ' + char(10);
		SET @mDqry = @mDQry + '  										AND SI.SCM_SITE_ID  = A.SCM_SITE_ID                                                                                                                                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + '  										AND SI.ITEM_ID  = A.ITEM_ID                                                                                                                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + '  										AND SI.PROJECT_CODE  = A.PROJECT_CODE                                                                                                                                                                                                                   ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ T1 WITH(NOLOCK)                                                                                                                                                                                                                                                 ' + char(10);
		SET @mDqry = @mDQry + ' ON h.CHANGE_REQ_NO = T1.CHANGE_REQ_NO                                                                                                                                                                                                                                                           ' + char(10);
		SET @mDqry = @mDQry + ' 	  WHERE 1=1 and MEASURE = ''SHIP_CONFIRM''                                                                                                              ' + char(10);
		SET @mDQry = @mDQry + ' 		AND  a.division_id = '''+ @p_division_id + ''' ' +char(10);
		SET @mDQry = @mDQry + ' 		AND  a.PLAN_START_YYYYMMDD = '''+ @p_plan_start_yyyymmdd + ''' ' +char(10);
		IF ( @p_dbl_flag = 'Y')
			BEGIN
				SET @mDQry = @mDQry + ' 					AND  a.yyyymmdd       = '''+ @p_from_yyyymmdd     +''' '+char(10)
			END
		ELSE
			BEGIN
				SET @mDqry = @mDQry + ' 	    AND a.yyyymmdd >= '''+ @p_from_yyyymmdd +'''		AND a.yyyymmdd <= '''+ @p_to_yyyymmdd +'''                                                    ' + char(10);

				IF ( @v_requestor     IS NOT NULL AND @v_requestor    != ''  )
				BEGIN
					SET @mDQry = @mDQry + ' 					AND  t0.dm_requested_by       IN ( ' + char(10) ;
					SET @mDQry = @mDQry + '													SELECT DISTINCT TT1.UserID FROM (' + char(10);
					SET @mDQry = @mDQry + '													(SELECT UserID FROM TB_FX_User ' + char(10) ;
					SET @mDQry = @mDQry + '													WHERE 1 = 1 ' + char(10) ;
					SET @mDQry = @mDQry + '													AND UserName		IN (' + @v_requestor + ')' +char(10);
					SET @mDQry = @mDQry + '													UNION ALL ' + char(10);
					SET @mDQry = @mDQry + '													SELECT UserID FROM TB_FX_User ' + char(10) ;
					SET @mDQry = @mDQry + '													WHERE 1 = 1 ' + char(10) ;
					SET @mDQry = @mDQry + '													AND UserID		IN (' + @v_requestor + '))) TT1 ' +char(10);
					SET @mDQry = @mDQry + '												) ' + char(10);
				END
			END
		IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mDQry = @mDQry + ' 					AND  a.item_id       IN ('+ @v_item_id     +')'+char(10);
		IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDQry = @mDQry + ' 					AND  a.PLANT_SITE_ID     IN ('+ @v_from_site   +')'+char(10);
		IF ( @v_project_code    IS NOT NULL AND @v_project_code    != ''  ) SET @mDQry = @mDQry + ' 					AND  a.PROJECT_CODE       IN ('+ @v_project_code     +')'+char(10);
		IF ( @v_pr_no    IS NOT NULL AND @v_pr_no    != ''  ) SET @mDQry = @mDQry + ' 					AND  T2.PR_NO       IN ('+ @v_pr_no     +')'+char(10);
		SET @mDqry = @mDQry + ' 		  AND a.qty > 0 '+char(10);
		SET @mDqry = @mDQry + ') AA      																										' + char(10);
		SET @mDqry = @mDQry + ' WHERE CONVERT(VARCHAR(8), CONVERT(DATETIME, AA.SHIPMENT_DATE), 112) >= AA.frozen_yyyymmdd  																										' + char(10);
		--SET @mDqry = @mDQry + ' ORDER BY AA.division_id, AA.ERP_SO_NO DESC, AA.shipment_date,  AA.item_id, AA.FROM_SITE, AA.TO_SITE, AA.project_code, AA.fcst_type     ' + char(10);
		SET @mDqry = @mDQry + ' ORDER BY AA.division_id, AA.shipment_status, AA.shipment_date,  AA.item_id, AA.ERP_SO_NO DESC, AA.from_site, AA.to_site, AA.project_code, AA.fcst_type     ' + char(10);
	END
	-- 추후 PLAN_ALL로 데이터 쌓이면 주석 해제 후 변경
	--BEGIN
	--		SET @mDqry = @mDQry + ' SELECT  AA.*  FROM      																										' + char(10);
	--		SET @mDqry = @mDQry + '  ( ' + char(10);
	--		SET @mDqry = @mDQry + ' 	SELECT							' + char(10);
	--		SET @mDqry = @mDQry + '			DIVISION_ID					' + char(10);
	--		SET @mDqry = @mDQry + '			, ERP_SO_NO                 ' + char(10);
	--		SET @mDqry = @mDQry + '			, SHIPMENT_STATUS           ' + char(10);
	--		SET @mDqry = @mDQry + '			, PROJECT_CODE              ' + char(10);
	--		SET @mDqry = @mDQry + '			, PROJECT_NAME              ' + char(10);
	--		SET @mDqry = @mDQry + '			, FCST_TYPE                 ' + char(10);
	--		SET @mDqry = @mDQry + '			, ITEM_ID                   ' + char(10);
	--		SET @mDqry = @mDQry + '			, NICK_NAME                 ' + char(10);
	--		SET @mDqry = @mDQry + '			, SHIPMENT_DATE             ' + char(10);
	--		--SET @mDqry = @mDQry + '			, 0 AS BEFORE_QTY			' + char(10);
	--		SET @mDqry = @mDQry + '			, SHIPMENT_CONFIRM_QTY              ' + char(10);
	--		SET @mDqry = @mDQry + '			, REMARKS                   ' + char(10);
	--		SET @mDqry = @mDQry + '			, REMARKS2                  ' + char(10);
	--		SET @mDqry = @mDQry + '			, REMARKS3					' + char(10);
	--		SET @mDqry = @mDQry + '			, FROM_SITE                 ' + char(10);
	--		SET @mDqry = @mDQry + '			, FROM_SITE_DESCRIPTION     ' + char(10);
	--		SET @mDqry = @mDQry + '			, TO_SITE                   ' + char(10);
	--		SET @mDqry = @mDQry + '			, TO_SITE_DESCRIPTION       ' + char(10);
	--		SET @mDqry = @mDQry + ' 		, TO_SITE_SOLDTO_CODE		' + char(10);
	--		SET @mDqry = @mDQry + ' 		, TO_SITE_SHIPTO_CODE		' + char(10);
	--		SET @mDqry = @mDQry + '			, SOLDTO_DESCRIPTION        ' + char(10);
	--		SET @mDqry = @mDQry + '			, SHIPTO_DESCRIPTION        ' + char(10);
	--		SET @mDqry = @mDQry + '			, BOD_ID                    ' + char(10);
	--		SET @mDqry = @mDQry + '			, INCOTERMS					' + char(10);
	--		SET @mDqry = @mDQry + '			, TRANSPORT_MODE            ' + char(10);
	--		SET @mDqry = @mDQry + '			, LT_DAY					' + char(10);
	--		SET @mDqry = @mDQry + '			, ETD						' + char(10);
	--		SET @mDqry = @mDQry + '			, ETA						' + char(10);
	--		SET @mDqry = @mDQry + '			, EXPECTED_SHIPPING_DATE    ' + char(10);
	--		SET @mDqry = @mDQry + '			, CONFIRM_ID                ' + char(10);
	--		SET @mDqry = @mDQry + '			, UPDATED_BY           ' + char(10);
	--		SET @mDqry = @mDQry + '			, UPDATED_DATE          ' + char(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS ERP_STATUS ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS change_type ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_ROUTE_ID ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_BOD_ID ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_INCOTERMS ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_D_COUNTRY ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_D_PORT_CODE ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_A_COUNTRY ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_A_PORT_CODE ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_CUSTOMER_LT ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_TO_COUNTRY ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_TO_CITY ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_ETA ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_ETD ' + CHAR(10);
	--		SET @mDqry = @mDQry + '			, ''-'' AS NEW_LT_DAY					' + char(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_TRANSPORT_MODE ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_SHIPMENT_DATE ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS EDIT_REMARKS ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS EDIT_MAIN ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS CHECK_NEED_YN ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, END_CUSTOMER AS END_CUSTOMER ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS ELECTRODE_YN ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS ELECTRODE_TYPE ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS ORIGIN_FROM_DIVISION_ID ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS ORIGIN_TO_DIVISION_ID ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, CHANGE_REQ_NO AS CHANGE_REQ_NO ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, MODEL_USER AS MODEL_USER   ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, MTK_OWNER AS MTK_OWNER   ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, REQUESTOR AS REQUESTOR   ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS CHANGE_REASON_CODE ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 		, ''-'' AS CHANGE_REASON_DETAIL ' + CHAR(10);
	--		SET @mDqry = @mDQry + ' 	FROM							' + char(10);
	--		SET @mDqry = @mDQry + ' 	(								' + char(10);
	--		SET @mDqry = @mDQry + '			SELECT TT0.DIVISION_ID										' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.ERP_SO_NO											' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.SHIPMENT_STATUS									' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.ITEM_ID											' + char(10);
	--		SET @mDqry = @mDQry + '			    , TT0.NICK_NAME											' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.ORIGIN_FROM_DIVISION_ID							' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.ORIGIN_TO_DIVISION_ID								' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.FROM_SITE											' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.FROM_SITE_DESCRIPTION								' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.TO_SITE											' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.TO_SITE_DESCRIPTION								' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.PROJECT_CODE										' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.PROJECT_NAME										' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.REQUESTOR											' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.SHIPMENT_CONFIRM_QTY								' + char(10);
	--		SET @mDqry = @mDQry + '				, CONVERT(VARCHAR(10),   CONVERT(DATETIME, TT0.YYYYMMDD,112), 23) AS SHIPMENT_DATE	' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.BOD_ID											' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.INCOTERMS											' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.TRANSPORT_MODE									' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.TO_SITE_SOLDTO_CODE								' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.TO_SITE_SHIPTO_CODE								' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.SOLDTO_DESCRIPTION								' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.SHIPTO_DESCRIPTION								' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.REMARKS2											' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.REMARKS											' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.CHANGE_REQ_NO										' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.REMARKS3											' + char(10);
	--		SET @mDqry = @mDQry + '				, CONVERT(VARCHAR(10),   CONVERT(DATETIME, TT0.ETD,112), 23) AS ETD	' + char(10);
	--		SET @mDqry = @mDQry + '				, CONVERT(VARCHAR(10),   CONVERT(DATETIME, TT0.ETA,112), 23) AS ETA	' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.EXPECTED_SHIPPING_DATE							' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.LT_DAY						AS LT_DAY			' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.UPDATED_BY					AS UPDATED_BY		' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.UPDATED_DATE					AS UPDATED_DATE		' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.CONFIRM_ID					AS CONFIRM_ID       ' + char(10);                                                                                                                                                                                                 
	--		SET @mDqry = @mDQry + '				, TT0.FCST_TYPE											' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.END_CUSTOMER										' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.MTK_OWNER											' + char(10);
	--		SET @mDqry = @mDQry + '				, TT0.MODEL_USER											' + char(10);
	--		SET @mDqry = @mDQry + '			FROM SSP_ANL_SHIP_PLAN_ALL TT0 WITH(NOLOCK)					' + char(10);
	--		SET @mDqry = @mDQry + '			JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 ' + char(10);
	--		SET @mDqry = @mDQry + '				ON TT0.FROM_SITE	= S.SCM_SITE_ID				 ' + char(10);
	--		SET @mDqry = @mDQry + '			   AND TT0.DIVISION_ID	= S.DIVISION_ID				 ' + char(10);
	--		SET @mDqry = @mDQry + '			   AND S.SITE_TYPE		= ''PLANT''					 ' + char(10);	
	----		SET @mDqry = @mDQry + '	  		LEFT OUTER JOIN SCP_MST_BOD_N_V  B WITH(NOLOCK)		 ' + char(10);
	--		SET @mDqry = @mDQry + '	  		LEFT OUTER JOIN SCP_MST_BOD__N_V  B WITH(NOLOCK)		 ' + char(10);
	--		SET @mDqry = @mDQry + '				ON B.DIVISION_ID	= TT0.DIVISION_ID				 ' + char(10);
	--		SET @mDqry = @mDQry + '			   AND B.BOD_ID			= TT0.BOD_ID					 ' + char(10);
	--		SET @mDqry = @mDQry + '			JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 ' + char(10);
	--		SET @mDqry = @mDQry + '				ON TT0.ITEM_ID		= T.ITEM_ID					 ' + char(10);
	--		SET @mDqry = @mDQry + '			   AND TT0.DIVISION_ID	= T.DIVISION_ID				 ' + char(10);
	--		SET @mDqry = @mDQry + '			   AND S.COMPANY_ID		= T.COMPANY_ID				 ' + char(10);
	--		SET @mDqry = @mDQry + '			   AND T.ITEM_TYPE		= ''Q''						 ' + char(10);
	--		SET @mDqry = @mDQry + '			LEFT OUTER JOIN SSP_MST_MODEL_USER MU WITH(NOLOCK) 			' + char(10);
	--		SET @mDqry = @mDQry + '				ON MU.DIVISION_ID =TT0.ORIGIN_FROM_DIVISION_ID 			' + char(10);
	--		SET @mDqry = @mDQry + '				AND MU.FROM_SITE = TT0.FROM_SITE 						' + char(10);
	--		SET @mDqry = @mDQry + '				AND MU.ITEM_ID = TT0.ITEM_ID 							' + char(10);
	--		SET @mDqry = @mDQry + '				AND MU.VALID_YN = ''Y''									' + char(10);
	--		SET @mDqry = @mDQry + '			WHERE 1=1													' + char(10);
	--		SET @mDqry = @mDQry + '			  AND TT0.PLAN_START_YYYYMMDD = '+@p_plan_start_yyyymmdd +'	' + char(10);
	--		SET @mDqry = @mDQry + '			  AND TT0.DIVISION_ID		  = '+@p_division_id +'			' + char(10);
	--		SET @mDQry = @mDQry + ' 		  AND TT0.COMPANY_ID		  = '''+ @p_company_id     +''' '+char(10)
	--		SET @mDQry = @mDQry + '			  AND TT0.SHIPMENT_CONFIRM_QTY > 0							' + char(10);
	--		SET @mDQry = @mDQry + '			  AND TT0.OPERATION_GROUP <> ''E''							' + char(10);
	--		SET @mDqry = @mDQry + '			  AND TT0.YYYYMMDD >= '+ @p_from_yyyymmdd +' AND TT0.YYYYMMDD <= '+ @p_to_yyyymmdd +' ' + char(10);
			
	--		IF ( @v_division_id IS NOT NULL AND @v_division_id  != '')	SET @mDQry = @mDQry + ' AND  TT0.DIVISION_ID   IN ('+ @v_division_id +')'+char(10);  
	--		IF ( @v_item_id     IS NOT NULL AND @v_item_id		!= '')	SET @mDQry = @mDQry + ' AND  TT0.ITEM_ID       IN ('+ @v_item_id     +')'+char(10); 
	--		IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '')	SET @mDQry = @mDQry + ' AND  TT0.FROM_SITE     IN ('+ @v_from_site   +')'+char(10); 
	--		IF ( @v_project_code IS NOT NULL AND @v_project_code    != ''  ) SET @mDQry = @mDQry + '  AND  TT0.PROJECT_CODE       IN ('+ @v_project_code     +')'+char(10);
			
	--		IF ( @p_dbl_flag = 'Y')
	--		BEGIN
	--			SET @mDQry = @mDQry + ' 					AND  TT0.yyyymmdd       = '''+ @p_from_yyyymmdd     +''' '+char(10)
	--		END
	--		ELSE
	--		BEGIN
	--			SET @mDqry = @mDQry + ' 	    AND TT0.yyyymmdd >= '''+ @p_from_yyyymmdd +'''		AND TT0.yyyymmdd <= '''+ @p_to_yyyymmdd +'''                                                    ' + char(10);

	--			IF ( @v_requestor     IS NOT NULL AND @v_requestor    != ''  )
	--			BEGIN
	--				SET @mDQry = @mDQry + ' 					AND  TT0.requestor       IN ( ' + char(10) ;
	--				SET @mDQry = @mDQry + '													SELECT DISTINCT TT1.UserID FROM (' + char(10);
	--				SET @mDQry = @mDQry + '													(SELECT UserID FROM TB_FX_User ' + char(10) ;
	--				SET @mDQry = @mDQry + '													WHERE 1 = 1 ' + char(10) ;
	--				SET @mDQry = @mDQry + '													AND UserName		IN (' + @v_requestor + ')' +char(10);
	--				SET @mDQry = @mDQry + '													UNION ALL ' + char(10);
	--				SET @mDQry = @mDQry + '													SELECT UserID FROM TB_FX_User ' + char(10) ;
	--				SET @mDQry = @mDQry + '													WHERE 1 = 1 ' + char(10) ;
	--				SET @mDQry = @mDQry + '													AND UserID		IN (' + @v_requestor + '))) TT1 ' +char(10);
	--				SET @mDQry = @mDQry + '												) ' + char(10);
	--			END
	--		END
	
	--		SET @mDqry = @mDQry + '		) AS  T0 ' + char(10);
	--		SET @mDqry = @mDQry + ' ) AS  AA ' + char(10);

	--		SET @mDqry = @mDQry + ' ORDER BY AA.division_id, AA.shipment_status, AA.shipment_date,  AA.item_id, AA.ERP_SO_NO DESC , AA.from_site, AA.to_site, AA.project_code, AA.fcst_type     ' + char(10);
	--END

	print @mDQry;
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
END
