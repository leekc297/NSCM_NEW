
/*
 * Program ID   : SSP0013_GET_SHIPMENT_PLAN_CHANGE
 * Description  : Shipment Change Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/08   ygkim			Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/10/23   ygkim			p_myModelChk, p_user_id 파라미터 추가 
 * 2018/11/01	hwyoon			owner 조회항목 추가
 * 2019/03/14	AYJ				[PJ20189106] 전지.GSCM 고도화 이행  REMARKS2 컬럼 추가
 * 2019/03/18	AYJ				[PJ20189106] 전지.GSCM 고도화 이행  REMARKS3 컬럼 추가
 * 2019/05/20	AYJ				[CSR ID:3994743] REQUESTOR 컬럼 추가

	ex) EXEC SSP0013_GET_SHIPMENT_PLAN_CHANGE @p_division_id='40', @p_from_site='', @p_to_site='', @p_erp_so_no='', @p_item_id='', @p_from_yyyymmdd='20181023', @p_to_yyyymmdd='20181123', @p_status='', @p_language='KO', @debug_mode='F', @p_change_type='C,P', @p_checked=NULL, @p_myModelChk='Y', @p_user_id = 'addio777'
 */

CREATE PROCEDURE [dbo].[SSP0013_GET_SHIPMENT_PLAN_CHANGE]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_to_site             NVARCHAR(MAX) = ''
	,@p_erp_so_no			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_from_yyyymmdd		NVARCHAR(8)
	,@p_to_yyyymmdd			NVARCHAR(8)
	,@p_status				NVARCHAR(MAX)
	,@p_change_type			NVARCHAR(MAX)
	,@p_language            NVARCHAR(MAX) = 'KO'
	,@p_checked             NVARCHAR(MAX) = ''
	,@debug_mode			NVARCHAR(1)='F'	
	,@p_myModelChk			NVARCHAR(MAX) = 'N'
	,@p_user_id				NVARCHAR(MAX)
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
	DECLARE  @v_change_type NVARCHAR(MAX)='';
	
	--IN 조건으로 데이터를 가져옴
	SET @v_division_id = [dbo].FN_GET_IN_STR(@p_division_id);
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);
	SET @v_to_site = [dbo].FN_GET_IN_STR(@p_to_site);

	SET @v_erp_so_no = [dbo].FN_GET_IN_STR(@p_erp_so_no);
	SET @v_status = [dbo].FN_GET_IN_STR(@p_status);
	SET @v_change_type = [dbo].FN_GET_IN_STR(@p_change_type);

	SET @mDqry = @mDQry + ' SELECT   a.division_id         																										' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.erp_so_no                                                                                                          ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.shipment_status                                                                                                    ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.project_code                                                                                                       ' + char(10);
	SET @mDqry = @mDQry + ' 		 , [dbo].[FN_GET_PROJECT_NAME]((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end) ,a.project_code) project_name                                               ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.fcst_type                                                                                                          ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.item_id                                                                                                            ' + char(10);
	SET @mDqry = @mDQry + ' 		 , dbo.fn_get_item_nickname((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name                                                    ' + char(10);
	SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) AS shipment_date                                       ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.before_qty AS before_qty                                                                                        ' + char(10);
	SET @mDqry = @mDQry + ' 		 , convert(int, a.qty) AS shipment_confirm_qty                                                                                        ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.remarks																											' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.remarks2																										' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.remarks3																											' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.from_site                                                                                                          ' + char(10);
	SET @mDqry = @mDQry + ' 		 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),''-'') AS from_site_description                    ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.to_site                                                                                                            ' + char(10);
	SET @mDqry = @mDQry + ' 		 , isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.to_site ),''-'') as to_site_description                      ' + char(10);
	SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SOLDTO_DESCRIPTION'' ) AS soldto_description                ' + char(10);
	SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SHIPTO_DESCRIPTION'' ) AS shipto_description                ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.bod_id                                                                                                             ' + char(10);
	SET @mDqry = @mDQry + ' 		 , b.incoterms                                                                                                          ' + char(10);
	SET @mDqry = @mDQry + ' 		 , b.transport_mode                                                                                                     ' + char(10);
	SET @mDqry = @mDQry + ' 		 , b.lt_total AS lt_day                                                                                                 ' + char(10);
	SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) AS etd                                                 ' + char(10);
	SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) AS eta                                                 ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.confirm_id                                                                                                         ' + char(10);
	SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U.UserName ELSE U.UserName_E END + ''('' + a.LAST_UPDATED_BY + '')'' updated_by    ' + char(10);
	SET @mDqry = @mDQry + ' 		 , case when u.UserName is not null then a.LAST_UPDATE_DATE else null end updated_date                                                                                          ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.erp_status                                                                                                         ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.change_type                                                                                                         ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.route_id NEW_ROUTE_ID, a.bod_id NEW_BOD_ID, b.incoterms NEW_INCOTERMS, a.d_country NEW_D_COUNTRY, a.d_port_code NEW_D_PORT_CODE, a.a_country NEW_A_COUNTRY, a.a_port_code NEW_A_PORT_CODE   ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.customer_lt NEW_CUSTOMER_LT, a.to_country NEW_TO_COUNTRY, a.to_city NEW_TO_CITY, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) NEW_ETA, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) NEW_ETD, b.lt_total NEW_LT_DAY, b.transport_mode NEW_TRANSPORT_MODE , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) NEW_SHIPMENT_DATE  ' + char(10);
	SET @mDqry = @mDQry + ' 		 , ''N'' EDIT_REMARKS, ''N'' EDIT_MAIN, isnull(a.CHECK_NEED_YN,''N'') CHECK_NEED_YN  ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , isnull(case when a.DIVISION_ID = ''40'' then a.PROJECT_CODE else f.END_CUSTOMER end,''-'') end_customer            ' + char(10);
	SET @mDqry = @mDQry + ' 		 , isnull(case when a.DIVISION_ID = ''40'' then case when a.PROJECT_CODE is not null and a.PROJECT_CODE != ''-'' then a.PROJECT_CODE else g.PROJECT_CODE end when a.DIVISION_ID = ''EE'' and a.ORIGIN_TO_DIVISION_ID = ''40'' then g.project_code else f.END_CUSTOMER end,''-'') end_customer            ' + char(10);
	SET @mDqry = @mDQry + ' 		 , a.ELECTRODE_YN, a.ELECTRODE_TYPE, a.ORIGIN_FROM_DIVISION_ID, a.ORIGIN_TO_DIVISION_ID, h.CHANGE_REQ_NO                   ' + char(10);
	SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U2.UserName ELSE U2.UserName_E END + ''('' + mu.user_id + '')'' model_user    ' + char(10);
	SET @mDqry = @mDQry + ' 		 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '','', '''+@p_language+''') AS MTK_OWNER                                                                                         ' + char(10);
	SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U3.UserName ELSE U3.UserName_E END + ''('' + a.requestor + '')'' requestor    ' + char(10);
	SET @mDqry = @mDQry + '			 , ''-'' AS CHANGE_REASON_CODE ' + char(10);
	SET @mDqry = @mDQry + '			 , '''' AS CHANGE_REASON_DETAIL	' + char(10);
	--SET @mDqry = @mDQry + ' 		 , CASE WHEN T1.CHANGE_REASON_CODE = ''SELECT''THEN NULL '+ char(10);
	--SET @mDqry = @mDQry + ' 		        WHEN T1.CHANGE_REASON_CODE = ''C00''THEN NULL '+ char(10);
	--SET @mDqry = @mDQry + ' 		   ELSE T1.CHANGE_REASON_CODE END AS CHANGE_REASON_CODE '+ char(10);
	--SET @mDqry = @mDQry + '			 , CASE WHEN T1.CHANGE_REASON_DETAIL = ''change on the Shipment Plan Adjustment screen'' THEN '''' ELSE T1.CHANGE_REASON_DETAIL END AS CHANGE_REASON_DETAIL '+ char(10);
	SET @mDqry = @mDQry + ' 	   FROM SSP_ANL_SHIP_CONFIRM  a WITH(NOLOCK)                                                                                          ' + char(10);
	SET @mDqry = @mDQry + ' 	  INNER JOIN  SCP_MST_BOD_N_V b WITH(NOLOCK) ON (CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID END) = b.division_id  AND a.bod_id = b.bod_id                                   ' + char(10);
	SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = ''Y''                                             ' + char(10);
	--SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN scm_mst_site_item E ON e.division_id = a.division_id and e.SCM_SITE_ID = a.to_site and e.item_id = a.item_id       ' + char(10);
	SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN SCM_MST_SITE f WITH(NOLOCK) ON f.division_id = a.ORIGIN_TO_DIVISION_ID and f.SCM_SITE_ID = a.to_site      ' + char(10);
	SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID										' + char(10);
	SET @mDqry = @mDQry + ' 	  					FROM(																						' + char(10);
	SET @mDqry = @mDQry + ' 	  						SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID									' + char(10);
	SET @mDqry = @mDQry + ' 	  							  ,ROW_NUMBER() over(partition by DIVISION_ID, SCM_SITE_ID, ITEM_ID order by PROJECT_CODE) num	' + char(10);
	SET @mDqry = @mDQry + ' 	  						FROM scm_mst_site_item WITH(NOLOCK)																				' + char(10);
	SET @mDqry = @mDQry + ' 	  					) a WHERE num = 1) g on g.DIVISION_ID =  (CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_TO_DIVISION_ID ELSE a.DIVISION_ID END) and g.SCM_SITE_ID = a.TO_SITE and g.ITEM_ID = a.ITEM_ID	' + char(10);

	SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN (SELECT CONFIRM_ID, CHANGE_REQ_NO FROM(								' + char(10);
	SET @mDqry = @mDQry + ' 	  	SELECT CONFIRM_ID ,CHANGE_REQ_NO								' + char(10);
	SET @mDqry = @mDQry + ' 	  		  ,ROW_NUMBER() OVER(PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) NUM								' + char(10);
	SET @mDqry = @mDQry + ' 	  	FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WITH(NOLOCK)								' + char(10);
	SET @mDqry = @mDQry + ' 	  	WHERE VALID_YN = ''Y''								' + char(10);
	SET @mDqry = @mDQry + ' 	  ) A WHERE NUM = 1) h on h.confirm_id = a.confirm_id								' + char(10);
	SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN SSP_MST_MODEL_USER mu on mu.division_id = a.origin_from_division_id and mu.from_site = a.from_site and mu.item_id = a.item_id and mu.valid_yn = ''Y''                                                                                                              ' + char(10);
	SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN TB_FX_User U2 ON mu.user_id = u2.UserID AND U2.UseYN = ''Y''                                             ' + char(10);
	SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN TB_FX_User U3 ON a.requestor = u3.UserID AND U3.UseYN = ''Y''                                             ' + char(10);
	--20181102 추가
	SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) ON SI.DIVISION_ID  = (CASE WHEN A.DIVISION_ID =''EE'' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END)       ' + char(10);
	SET @mDqry = @mDQry + ' 														AND SI.SCM_SITE_ID  = A.TO_SITE        ' + char(10);
	SET @mDqry = @mDQry + ' 														AND SI.ITEM_ID  = A.ITEM_ID        ' + char(10);
	--SET @mDqry = @mDQry + ' 														AND SI.PROJECT_CODE  = case when CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID end  = ''40'' then g.project_code else A.PROJECT_CODE  end        ' + char(10);
	SET @mDqry = @mDQry + ' 														AND SI.PROJECT_CODE  = A.PROJECT_CODE        ' + char(10);
	SET @mDqry = @mDQry + '			LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ T1 ' + char(10);
	SET @mDqry = @mDQry + '				ON h.CHANGE_REQ_NO = T1.CHANGE_REQ_NO ' + char(10);
	
	SET @mDqry = @mDQry + ' 	  WHERE 1=1                                                                                                               ' + char(10);
	SET @mDqry = @mDQry + ' 	    AND yyyymmdd >= '+ @p_from_yyyymmdd +'                                                                                    ' + char(10);
	SET @mDqry = @mDQry + ' 			AND a.yyyymmdd <= '+ @p_to_yyyymmdd +'                                                                                        ' + char(10);
	SET @mDqry = @mDQry + ' 			AND a.CHANGE_TYPE != ''N''                                                                                   ' + char(10);
	IF ( @v_division_id IS NOT NULL AND @v_division_id    != '') SET @mDQry = @mDQry + ' 					AND  a.division_id   IN ('+ @v_division_id +')'+char(10);  
	IF ( @p_checked IS NOT NULL AND @p_checked    != '') SET @mDQry = @mDQry + ' 					AND  isnull(a.CHECK_NEED_YN,''N'')   = '''+ @p_checked +''' '+char(10);  
	IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mDQry = @mDQry + ' 					AND  a.item_id       IN ('+ @v_item_id     +')'+char(10);  
	IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDQry = @mDQry + ' 					AND  a.from_site     IN ('+ @v_from_site   +')'+char(10);   
	IF ( @v_to_site   IS NOT NULL AND @v_to_site    != '') SET @mDQry = @mDQry + ' 					AND  a.to_site     IN ('+ @v_to_site   +')'+char(10);   
	IF ( @v_erp_so_no   IS NOT NULL AND @v_erp_so_no    != '') SET @mDQry = @mDQry + ' 					AND  a.erp_so_no     IN ('+ @v_erp_so_no   +')'+char(10); 
	SET @mDqry = @mDQry + ' 		  AND (a.shipment_status IS NOT NULL AND isnull(a.shipment_status,'''') != '''') '+char(10); 
	IF ( @v_status   IS NOT NULL AND @v_status    != '') SET @mDQry = @mDQry + ' 					AND  a.shipment_status     IN ('+ @v_status   +')'+char(10); 
	IF ( @v_change_type   IS NOT NULL AND @v_change_type    != '') SET @mDQry = @mDQry + ' 					AND  a.change_type     IN ('+ @v_change_type   +')'+char(10); 
	IF @p_myModelChk = 'Y'
		BEGIN
			SET @mDqry = @mDQry + ' 	AND EXISTS(SELECT 1 FROM SSP_MST_MODEL_USER b WITH(NOLOCK) where b.division_id = a.origin_from_division_id and b.from_site = a.from_site and b.item_id = a.item_id and b.valid_yn = ''Y'' and b.user_id = ''' + @p_user_id + ''')                                                                                                               ' + char(10);
		END
	--SET @mDqry = @mDQry + ' 		  AND a.QTY > 0                        ' + char(10);
	
--	SET @mDqry = @mDQry + ' ORDER BY a.change_type,a.division_id, a.erp_so_no, a.item_id, a.project_code, a.fcst_type, a.yyyymmdd     ' + char(10);
	SET @mDqry = @mDQry + ' ORDER BY a.change_type,a.division_id, a.yyyymmdd,  a.item_id, a.from_site, a.to_site, a.erp_so_no, a.project_code, a.fcst_type     ' + char(10);

	--select @mDQry;
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
