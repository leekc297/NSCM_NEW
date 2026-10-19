

/*
 * Program ID   : SSP0200_GET_SHIPMENT_CHANGE_REQUEST
 * Description  : Shipment Change Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/05/25   KIMYONGHO      최초작성
 * 2021/10/18   SHINMYUNGSU	   SSP_ANL_SHIP_CONFIRM의 ERP_ATTR1~3 항목 추가
 * 2021/11/11   SHINMYUNGSU    조회조건 CONFIRM_ID 추가
 * 2024/10/01   KHJ            NERP_SSP
 */

CREATE PROCEDURE [dbo].[SSP0200_GET_SHIPMENT_CHANGE_REQUEST]
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
	-- 20211111 SHINMYUNGSU  추가
	,@p_confirm_id          NVARCHAR(MAX)
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
	
	-- 20211111 SHINMYUNGSU  추가
	DECLARE  @v_confirm_id NVARCHAR(MAX)='';

	--IN 조건으로 데이터를 가져옴
	SET @v_division_id = [dbo].FN_GET_IN_STR(@p_division_id);
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);
	SET @v_to_site = [dbo].FN_GET_IN_STR(@p_to_site);

	SET @v_erp_so_no = [dbo].FN_GET_IN_STR(@p_erp_so_no);
	SET @v_status = [dbo].FN_GET_IN_STR(@p_status);

	-- 20211111 SHINMYUNGSU  추가
	SET @v_confirm_id = [dbo].FN_GET_IN_STR(@p_confirm_id);

			SET @mDqry = @mDQry + ' SELECT  AA.*  FROM      																										' + char(10);
			SET @mDqry = @mDQry + '  ( SELECT  a.division_id         																										' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.erp_so_no                                                                                                          ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.shipment_status                                                                                                    ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.project_code                                                                                                       ' + char(10);
			SET @mDqry = @mDQry + ' 		 , [dbo].[FN_GET_PROJECT_NAME]((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end) ,a.project_code) project_name                                               ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.fcst_type                                                                                                          ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.item_id                                                                                                            ' + char(10);
			SET @mDqry = @mDQry + ' 		 , dbo.fn_get_item_nickname((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name                                                    ' + char(10);
			SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) AS shipment_date                                       ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.before_qty AS before_qty                                                                                        ' + char(10);
			SET @mDqry = @mDQry + ' 		 , convert(decimal(19,3),a.qty) AS shipment_confirm_qty                                                                                        ' + char(10);			
			SET @mDqry = @mDQry + ' 		 , a.remarks					                                                                                        ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.remarks2																											' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.remarks3																											' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.from_site                                                                                                          ' + char(10);

			SET @mDqry = @mDQry + ' 		 , SMF.operation_group  ' + char(10);

			SET @mDqry = @mDQry + ' 		 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),''-'') AS from_site_description                    ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.to_site                                                                                                            ' + char(10);
			SET @mDqry = @mDQry + ' 		 , isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.to_site ),''-'') as to_site_description                      ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.TO_SITE_SOLDTO_CODE		' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.TO_SITE_SHIPTO_CODE		' + char(10);
			SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SOLDTO_DESCRIPTION'' ) AS soldto_description                ' + char(10);
			SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SHIPTO_DESCRIPTION'' ) AS shipto_description                ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.bod_id                                                                                                             ' + char(10);
			
			SET @mDqry = @mDQry + ' 		 , b.ssp_incoterms  AS INCOTERMS                                                                                                         ' + char(10);
			SET @mDqry = @mDQry + ' 		 , b.transport_mode                                                                                                     ' + char(10);
			SET @mDqry = @mDQry + ' 		 , b.lt_total AS lt_day                                                                                                 ' + char(10);
			SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) AS etd                                                 ' + char(10);
			SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) AS eta                                                 ' + char(10);
			SET @mDQry = @mDQry + ' 		 , CASE WHEN b.transport_mode = ''TRK'' then ''-'' else CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](a.DIVISION_ID, a.BOD_ID, a.YYYYMMDD), 112), 23) end as Expected_Shipping_Date    ' + char(10) ;
			SET @mDqry = @mDQry + ' 		 , a.confirm_id                                                                                                         ' + char(10);
			SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U.UserName ELSE U.UserName_E END + ''('' + a.LAST_UPDATED_BY + '')'' updated_by    ' + char(10);
			SET @mDqry = @mDQry + ' 		 , case when u.UserName is not null then a.LAST_UPDATE_DATE else null end updated_date                                                                                          ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.erp_status                                                                                                         ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.change_type                                                                                                         ' + char(10);
			
			SET @mDqry = @mDQry + ' 		 , a.route_id NEW_ROUTE_ID, a.bod_id NEW_BOD_ID, b.ssp_incoterms NEW_INCOTERMS, a.d_country NEW_D_COUNTRY, a.d_port_code NEW_D_PORT_CODE, a.a_country NEW_A_COUNTRY, a.a_port_code NEW_A_PORT_CODE   ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.customer_lt NEW_CUSTOMER_LT, a.to_country NEW_TO_COUNTRY, a.to_city NEW_TO_CITY, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) NEW_ETA, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) NEW_ETD, b.lt_total NEW_LT_DAY, b.transport_mode NEW_TRANSPORT_MODE , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) NEW_SHIPMENT_DATE  ' + char(10);
			SET @mDqry = @mDQry + ' 		 , ''N'' EDIT_REMARKS, ''N'' EDIT_MAIN, isnull(a.CHECK_NEED_YN,''N'') CHECK_NEED_YN  ' + char(10);
			
			SET @mDqry = @mDQry + ' 		 , isnull(case when a.DIVISION_ID = ''40'' then case when a.PROJECT_CODE is not null and a.PROJECT_CODE != ''-'' then a.PROJECT_CODE else g.PROJECT_CODE end when a.DIVISION_ID = ''EE'' and a.ORIGIN_TO_DIVISION_ID = ''40'' then g.project_code else f.END_CUSTOMER end,''-'') end_customer            ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.ELECTRODE_YN, a.ELECTRODE_TYPE, a.ORIGIN_FROM_DIVISION_ID, a.ORIGIN_TO_DIVISION_ID, h.CHANGE_REQ_NO                   ' + char(10);
			SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U2.UserName ELSE U2.UserName_E END + ''('' + mu.user_id + '')'' model_user    ' + char(10);
			SET @mDqry = @mDQry + ' 		 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '','', '''+@p_language+''') AS MTK_OWNER                                                                                         ' + char(10);
			SET @mDqry = @mDQry + ' 		 , CASE WHEN a.LAST_UPDATED_BY = ''ssp_batch'' THEN  ''System'' ELSE  CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U3.UserName ELSE U3.UserName_E END + ''('' + a.LAST_UPDATED_BY + '')'' END requestor    ' + char(10);
			SET @mDqry = @mDQry + '			 , ''-'' AS CHANGE_REASON_CODE ' + char(10);
			SET @mDqry = @mDQry + '			 , '''' AS CHANGE_REASON_DETAIL	' + char(10);
			SET @mDqry = @mDQry + '			 , A.ATTRIBUTE10 AS ATTRIBUTE10	' + char(10);
			SET @mDqry = @mDQry + '			 , A.LAST_UPDATE_DATE AS REQUEST_DATE	' + char(10);
			/**** 20211018   SHINMYUNGSU   열람항목추가   ******************************************************/
			SET @mDqry = @mDQry + '			 , A.ERP_ATTR1 	'					+ char(10);
			SET @mDqry = @mDQry + '			 , A.ERP_ATTR2	'					+ char(10);
			SET @mDqry = @mDQry + '			 , A.ERP_ATTR3	'					+ char(10);
			/***********************************************************************************/
			SET @mDqry = @mDQry + ' 	   FROM SSP_ANL_SHIP_CONFIRM  a with(nolock)                                                                                          ' + char(10);
			SET @mDqry = @mDQry + '		   JOIN [dbo].[scm_item_m_sn] AS T WITH(NOLOCK)				 ' + char(10);
			SET @mDqry = @mDQry + '			ON a.ITEM_ID		= T.ITEM_ID					 ' + char(10);
			SET @mDqry = @mDQry + '		   AND a.DIVISION_ID	= T.DIVISION_ID				 ' + char(10);
			SET @mDqry = @mDQry + '		   AND a.FROM_SITE_COMPANY_ID =	 T.COMPANY_ID				 ' + char(10);
			SET @mDqry = @mDQry + '		   AND T.ITEM_TYPE		NOT IN (''Q'',''R'')			 ' + char(10);
			SET @mDqry = @mDQry + ' 	  INNER JOIN SCM_MST_SITE MS with(nolock) ON A.DIVISION_ID = MS.DIVISION_ID AND A.FROM_SITE = MS.SCM_SITE_ID AND MS.SITE_TYPE = ''PLANT''                ' + char(10);
			--SET @mDqry = @mDQry + ' 	  INNER JOIN  scp_mst_bod_n_v b with(nolock) ON (CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID END) = b.division_id  AND a.bod_id = b.bod_id                                   ' + char(10);
			SET @mDqry = @mDQry + ' 	  INNER JOIN  scp_mst_bod_n_v b with(nolock) ON (CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID END) = b.division_id  AND a.bod_id = b.bod_id                                   ' + char(10);
			SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN TB_FX_User U with(nolock) ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = ''Y''                                             ' + char(10);
			SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN SCM_MST_SITE f with(nolock) ON f.division_id = a.ORIGIN_TO_DIVISION_ID and f.SCM_SITE_ID = a.to_site          ' + char(10);
/*	NERP 적용시 GERP COMPANY_ID에 해당하는 것은 제외 필요함 */	
			SET @mDqry = @mDQry + '			AND  F.VALID_YN = ''Y''			'+ char(10);		
			SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID										' + char(10);
			SET @mDqry = @mDQry + ' 	  					FROM(																						' + char(10);
			SET @mDqry = @mDQry + ' 	  						SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID									' + char(10);
			SET @mDqry = @mDQry + ' 	  							  ,ROW_NUMBER() over(partition by DIVISION_ID, SCM_SITE_ID, ITEM_ID order by PROJECT_CODE) num	' + char(10);
			SET @mDqry = @mDQry + ' 	  						FROM scm_mst_site_item with(nolock)																				' + char(10);
			SET @mDqry = @mDQry + ' 	  					) a WHERE num = 1) g on g.DIVISION_ID =  (CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_TO_DIVISION_ID ELSE a.DIVISION_ID END) and g.SCM_SITE_ID = a.TO_SITE and g.ITEM_ID = a.ITEM_ID	' + char(10);

			SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN (SELECT CONFIRM_ID, CHANGE_REQ_NO FROM(								' + char(10);
			SET @mDqry = @mDQry + ' 	  	SELECT CONFIRM_ID ,CHANGE_REQ_NO								' + char(10);
			SET @mDqry = @mDQry + ' 	  		  ,ROW_NUMBER() OVER(PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) NUM								' + char(10);
			SET @mDqry = @mDQry + ' 	  	FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE with(nolock)								' + char(10);
			SET @mDqry = @mDQry + ' 	  	WHERE VALID_YN = ''Y''								' + char(10);
			SET @mDqry = @mDQry + ' 	  ) A WHERE NUM = 1) h on h.confirm_id = a.confirm_id								' + char(10);
			SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN SSP_MST_MODEL_USER mu with(nolock) on mu.division_id = a.origin_from_division_id and mu.from_site = a.from_site and mu.item_id = a.item_id and mu.valid_yn = ''Y''                                                                                                              ' + char(10);
			SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN TB_FX_User U2 with(nolock) ON mu.user_id = u2.UserID AND U2.UseYN = ''Y''                                             ' + char(10);
			SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN TB_FX_User U3 with(nolock) ON a.LAST_UPDATED_BY = u3.UserID AND U3.UseYN = ''Y''                                             ' + char(10);
			SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) ON SI.DIVISION_ID  = (CASE WHEN A.DIVISION_ID =''EE'' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END)       ' + char(10);
			SET @mDqry = @mDQry + ' 														AND SI.SCM_SITE_ID  = A.TO_SITE        ' + char(10);
			SET @mDqry = @mDQry + ' 														AND SI.ITEM_ID  = A.ITEM_ID        ' + char(10);
			SET @mDqry = @mDQry + ' 														AND SI.PROJECT_CODE  = A.PROJECT_CODE        ' + char(10);
			SET @mDqry = @mDQry + '			LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ T1 with(nolock) ' + char(10);
			SET @mDqry = @mDQry + '				ON h.CHANGE_REQ_NO = T1.CHANGE_REQ_NO ' + char(10);

			SET @mDqry = @mDQry + 'LEFT OUTER JOIN [SCP_MST_FINAL_ITEM_V] SMF'+char(10);
			SET @mDqry = @mDQry + 'ON A.ITEM_ID = SMF.ITEM_ID '+char(10);

			SET @mDqry = @mDQry + ' 	  WHERE 1=1                                                                                                               ' + char(10);

		
			SET @mDqry = @mDQry + ' 	    AND yyyymmdd >= '+ @p_from_yyyymmdd +'		AND yyyymmdd <= '+ @p_to_yyyymmdd +'                                                    ' + char(10);
				

			IF ( @v_division_id IS NOT NULL AND @v_division_id    != '') SET @mDQry = @mDQry + ' 				AND  a.division_id   IN ('+ @v_division_id +')'+char(10);  
			IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mDQry = @mDQry + ' 					AND  a.item_id       IN ('+ @v_item_id     +')'+char(10); 
			IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDQry = @mDQry + ' 					AND  a.from_site     IN ('+ @v_from_site   +')'+char(10); 
			IF ( @v_to_site     IS NOT NULL AND @v_to_site    != '') SET @mDQry = @mDQry + ' 					AND  a.to_site		 IN ('+ @v_to_site   +')'+char(10); 
			IF ( @v_erp_so_no   IS NOT NULL AND @v_erp_so_no    != '') SET @mDQry = @mDQry + ' 					AND  a.erp_so_no     IN ('+ @v_erp_so_no   +')'+char(10); 
			
			SET @mDqry = @mDQry + ' 		  AND (a.shipment_status IS NOT NULL AND isnull(a.shipment_status,'''') != '''') '+char(10); 
			SET @mDqry = @mDQry + ' 		  AND a.qty > 0 '+char(10); 
			--SET @mDqry = @mDQry + ' 		  AND A.ATTRIBUTE10 <> N''I'' '+char(10); 
			SET @mDqry = @mDQry + ' 		  AND a.change_type <> ''N''  '+char(10);
			SET @mDqry = @mDQry + ' 		  AND a.CONFIRM_ID LIKE ''C%''  '+char(10); 
			-- 20211111 SHINMYUNGSU  추가   CONFIRM_ID 조회조건 추가
			IF ( @v_confirm_id   IS NOT NULL AND @v_confirm_id    != '') 
				SET @mDQry = @mDQry + ' 					AND  a.confirm_id     IN ('+ @v_confirm_id   +')'+char(10); 
			--SET @mDqry = @mDQry + ' 	  AND a.CHANGE_TYPE = ''' + @p_change_type + '''	 ' + char(10);
			--SET @mDqry = @mDQry + ' 		  AND a.biz_type <> ''E''  '+char(10);
	
			
			SET @mDqry = @mDQry + ' ) AS  AA ' + char(10);

			SET @mDqry = @mDQry + ' ORDER BY AA.division_id, AA.shipment_status, AA.shipment_date,  AA.item_id, AA.ERP_SO_NO DESC , AA.from_site, AA.to_site, AA.project_code, AA.fcst_type     ' + char(10);

	--SET @mDqry = @mDQry + ' SELECT a.division_id         																										' + char(10);
	
	--IF @p_change_type = 'C'
	--	SET @mDqry = @mDQry + ' 		 , a.erp_so_no                                                                                                          ' + char(10);
	--ELSE IF @p_change_type = 'P'
	--	SET @mDqry = @mDQry + ' 		 , null erp_so_no                                                                                                          ' + char(10);

	--SET @mDqry = @mDQry + ' 		 , a.shipment_status                                                                                                    ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , a.project_code                                                                                                       ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , case when a.division_id = ''40'' then a.project_code else [dbo].[FN_GET_PROJECT_NAME]((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end) ,a.project_code) end project_name                                               ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , a.fcst_type                                                                                                          ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , a.item_id                                                                                                            ' + char(10);
	
	--SET @mDqry = @mDQry + ' 		 , dbo.fn_get_item_nickname((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name                                                    ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) AS shipment_date                                       ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , a.qty AS shipment_confirm_qty                                                                                        ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , a.from_site                                                                                                          ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),''-'') AS from_site_description                    ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , a.to_site                                                                                                            ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.to_site ),''-'') as to_site_description                      ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SOLDTO_DESCRIPTION'' ) AS soldto_description                ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SHIPTO_DESCRIPTION'' ) AS shipto_description                ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , a.bod_id                                                                                                             ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , b.ssp_incoterms AS INCOTERMS                                                                                                          ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , b.transport_mode                                                                                                     ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , b.lt_total AS lt_day                                                                                                 ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) AS etd                                                 ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) AS eta                                                 ' + char(10);
	--SET @mDQry = @mDQry + ' 		 , CASE WHEN b.transport_mode = ''TRK'' then ''-'' else CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](a.DIVISION_ID, a.BOD_ID, a.YYYYMMDD), 112), 23) end as Expected_Shipping_Date    ' + char(10) ;
	--SET @mDqry = @mDQry + ' 		 , a.confirm_id                                                                                                         ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , a.change_req_no                                                                                                      ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , c.request_user                                                                                                       ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U.UserName ELSE U.UserName_E END + ''('' + c.request_user + '')'' request_user_name    ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , c.request_time request_time                                                                                          ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , a.erp_status                                                                                                         ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , a.attribute1 plan_confirm_id,a.origin_from_division_id, a.REMARKS                                                                                         ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '','', '''+@p_language+''') AS MTK_OWNER                                                                                         ' + char(10);
	--SET @mDqry = @mDQry + ' 		 , a.remarks																											' + char(10);
	--SET @mDqry = @mDQry + ' 		 , a.remarks2																											' + char(10);
	--SET @mDqry = @mDQry + ' 		 , a.remarks3																											' + char(10);
	--SET @mDqry = @mDQry + ' 		 , a.ELECTRODE_YN																											' + char(10);
	--SET @mDqry = @mDQry + ' 		 , a.ELECTRODE_TYPE																											' + char(10);
	--SET @mDqry = @mDQry + ' 	   FROM SSP_ANL_SHIP_CONFIRM  a                                                                                           ' + char(10);

	--SET @mDqry = @mDQry + ' 	  INNER JOIN  scp_mst_bod_n_v b ON (CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID END) = b.division_id  AND a.bod_id = b.bod_id                                   ' + char(10);
	--SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ c on a.change_req_no = c.change_req_no AND c.VALID_YN = ''Y''                ' + char(10);	
	--SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN TB_FX_User U ON c.request_user = u.UserID AND U.UseYN = ''Y''                                             ' + char(10);
	--SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) ON SI.DIVISION_ID  = (CASE WHEN A.DIVISION_ID =''EE'' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END)       ' + char(10);
	--SET @mDqry = @mDQry + ' 														AND SI.SCM_SITE_ID  = A.TO_SITE        ' + char(10);
	--SET @mDqry = @mDQry + ' 														AND SI.ITEM_ID  = A.ITEM_ID        ' + char(10);
	--SET @mDqry = @mDQry + ' 														AND SI.PROJECT_CODE  = A.PROJECT_CODE        ' + char(10);
	--SET @mDqry = @mDQry + ' 	  WHERE 1=1                                                                                                               ' + char(10);
	--SET @mDqry = @mDQry + ' 	    AND yyyymmdd >= '+ @p_from_yyyymmdd +'                                                                                    ' + char(10);
	--SET @mDqry = @mDQry + ' 			AND yyyymmdd <= '+ @p_to_yyyymmdd +'                                                                                        ' + char(10);
	--IF ( @v_division_id IS NOT NULL AND @v_division_id    != '') SET @mDQry = @mDQry + ' 					AND  a.division_id   IN ('+ @v_division_id +')'+char(10);  
	--IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mDQry = @mDQry + ' 					AND  a.item_id       IN ('+ @v_item_id     +')'+char(10);  
	--IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDQry = @mDQry + ' 					AND  a.from_site     IN ('+ @v_from_site   +')'+char(10);   
	--IF ( @v_to_site   IS NOT NULL AND @v_to_site    != '') SET @mDQry = @mDQry + ' 					AND  a.to_site     IN ('+ @v_to_site   +')'+char(10);   
	--IF ( @v_erp_so_no   IS NOT NULL AND @v_erp_so_no    != '') SET @mDQry = @mDQry + ' 					AND  a.erp_so_no     IN ('+ @v_erp_so_no   +')'+char(10); 
	--SET @mDqry = @mDQry + ' 		  AND (a.shipment_status IS NOT NULL AND isnull(a.shipment_status,'''') != '''') '+char(10); 
	--IF ( @v_status   IS NOT NULL AND @v_status    != '') SET @mDQry = @mDQry + ' 					AND  a.shipment_status     IN ('+ @v_status   +')'+char(10); 
	--SET @mDqry = @mDQry + ' 		  AND a.QTY > 0                        ' + char(10);
	
	--SET @mDqry = @mDQry + ' 	  AND a.CHANGE_TYPE = ''' + @p_change_type + '''	 ' + char(10);

	--SET @mDqry = @mDQry + ' ORDER BY a.division_id, a.erp_so_no, a.item_id, a.project_code, a.fcst_type, a.yyyymmdd     ' + char(10);

	EXEC (@mDQry);

END
