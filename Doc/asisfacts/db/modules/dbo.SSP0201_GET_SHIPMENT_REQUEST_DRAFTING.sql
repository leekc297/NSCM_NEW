

/*
 * Program ID   : SSP0200_GET_SHIPMENT_REQUEST_DRAFTING
 * Description  : Shipment Change Request 작성중
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/05/26  KIMYONGHO	   최초작성
 * 2022/03/03  SMS	           소형 외주 Packer Item 코드 이중화로 인한 Model PIC 검색 변경
 */

CREATE PROCEDURE [dbo].[SSP0201_GET_SHIPMENT_REQUEST_DRAFTING]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_to_site				NVARCHAR(MAX) = ''
	,@p_erp_so_no			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)

	,@p_bod_id				NVARCHAR(MAX) = ''
	,@p_incoterms			NVARCHAR(MAX) = ''
	,@p_transport_mode		NVARCHAR(MAX) = ''
	,@p_project_code		NVARCHAR(MAX) = ''
	,@p_fcst_type			NVARCHAR(MAX) = ''

	,@p_confirm_id			NVARCHAR(MAX)
	,@p_from_yyyymmdd		NVARCHAR(8)
	,@p_to_yyyymmdd			NVARCHAR(8)
	,@p_change_request_no	NVARCHAR(40)
	,@p_request_user_id		NVARCHAR(150)
	,@p_request_status		NVARCHAR(1)
	,@p_language            NVARCHAR(MAX) = 'KO'
	,@p_change_type         NVARCHAR(MAX) = 'C'
	,@debug_mode			NVARCHAR(1)='F'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @mDQry NVARCHAR(MAX)='';


		-- SHIPMENT BOH
	IF OBJECT_ID('tempdb..#Tmp_SSP_ANL_SHIP_CONFIRM_CHG_REQ_de') IS NOT NULL	
		DROP TABLE #Tmp_SSP_ANL_SHIP_CONFIRM_CHG_REQ_de;

--	IF @p_request_status = 'C' or @p_request_status = 'P'
--		BEGIN
--			SET @mDqry = @mDQry + ' SELECT a.division_id																																															' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.erp_so_no                                                                                               ' + char(10)
--			--SET @mDqry = @mDQry + ' 			, [dbo].[FN_GET_PROJECT_NAME](a.division_id,a.project_code) project_name                                    ' + char(10)
--			SET @mDqry = @mDQry + ' 			, case when a.division_id = ''40'' then a.project_code else [dbo].[FN_GET_PROJECT_NAME]((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end),a.project_code) end project_name                                    ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.project_code                                                                                            ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.fcst_type                                                                                               ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.shipment_status                                                                                         ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.item_id                                                                                                 ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.from_site                                                                                               ' + char(10)
--			SET @mDqry = @mDQry + ' 			, isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),''-'') AS from_site_description         ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.to_site                                                                                                 ' + char(10)
--			SET @mDqry = @mDQry + ' 			, isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.to_site ),''-'') as to_site_description           ' + char(10)
--			--SET @mDqry = @mDQry + ' 			, dbo.fn_get_site_customer_info( a.division_id, a.to_site, ''SOLDTO_DESCRIPTION'' ) AS soldto_description     ' + char(10)
--			--SET @mDqry = @mDQry + ' 			, dbo.fn_get_site_customer_info( a.division_id, a.to_site, ''SHIPTO_DESCRIPTION'' ) AS shipto_description     ' + char(10)
--			SET @mDqry = @mDQry + ' 			, dbo.fn_get_site_customer_info( (case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SOLDTO_DESCRIPTION'' ) AS soldto_description     ' + char(10)
--			SET @mDqry = @mDQry + ' 			, dbo.fn_get_site_customer_info( (case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SHIPTO_DESCRIPTION'' ) AS shipto_description     ' + char(10)
--			--* 2020/09/21  KIMYONGHO		  SSP INCOTERMS 변경 작업
--			--SET @mDqry = @mDQry + ' 			, b.incoterms                                                                                               ' + char(10)
--			SET @mDqry = @mDQry + ' 			, b.ssp_incoterms  AS INCOTERMS                                                                                             ' + char(10)
--			SET @mDqry = @mDQry + ' 			, b.transport_mode	                                                                                        ' + char(10)
--			SET @mDqry = @mDQry + ' 			, b.lt_total AS lt_day                                                                                      ' + char(10)
--			SET @mDqry = @mDQry + ' 			, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) AS etd                                      ' + char(10)
--			SET @mDqry = @mDQry + ' 			, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) AS eta					                            ' + char(10)
--			SET @mDqry = @mDQry + ' 			, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) AS shipment_date                            ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.qty AS shipment_confirm_qty	                                                                            ' + char(10)
--			SET @mDqry = @mDQry + ' 			, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) new_shipment_date                           ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.qty new_shipment_confirm_qty                                                                            ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.bod_id new_bod_id                                                                                       ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.route_id new_route_id                                                                                   ' + char(10)
--			SET @mDqry = @mDQry + ' 			, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) AS new_etd                                  ' + char(10)
--			SET @mDqry = @mDQry + ' 			, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) AS new_eta                                  ' + char(10)
--			--* 2020/09/21  KIMYONGHO		  SSP INCOTERMS 변경 작업
--			--SET @mDqry = @mDQry + ' 			, b.incoterms new_incoterms                                                                                 ' + char(10)
--			SET @mDqry = @mDQry + ' 			, b.ssp_incoterms new_incoterms                                                                             ' + char(10)
			
--			SET @mDqry = @mDQry + ' 			, b.lt_total AS new_lt_day                                                                                  ' + char(10)
--			SET @mDqry = @mDQry + ' 			, b.transport_mode new_transport_mode                                                                       ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.confirm_id                                                                                              ' + char(10)
--			SET @mDqry = @mDQry + ' 			, c.change_req_no                                                                                           ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.bod_id                                                                                                  ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.route_id                                                                                                ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.d_country                                                                                               ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.d_port_code                                                                                             ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.a_country                                                                                               ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.a_port_code                                                                                             ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.customer_lt                                                                                             ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.to_country                                                                                              ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.to_city                                                                                                 ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.bod_id new_bod_id                                                                                       ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.route_id new_route_id                                                                                   ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.d_country new_d_country                                                                                 ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.d_port_code new_d_port_code                                                                             ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.a_country new_a_country                                                                                 ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.a_port_code new_a_port_code                                                                             ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.customer_lt new_customer_lt                                                                             ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.to_country new_to_country                                                                               ' + char(10)
--			SET @mDqry = @mDQry + ' 			, a.to_city new_to_city	                                                                                    ' + char(10)
--			SET @mDqry = @mDQry + ' 			, ''N'' new_yn				                                                                                ' + char(10)
--			SET @mDqry = @mDQry + ' 		    , a.attribute1 plan_confirm_id                                                                              ' + char(10);
--			SET @mDqry = @mDQry + ' 		    , a.electrode_yn, a.electrode_type, a.origin_from_division_id, a.origin_to_division_id, ''Y'' NEW_BASE_CONFIRM_YN  ' + char(10);
--			SET @mDqry = @mDQry + ' 		    , a.remarks																									' + char(10);
--			SET @mDqry = @mDQry + ' 		    , a.remarks2																								' + char(10);
--			SET @mDqry = @mDQry + ' 		    , a.remarks3																								' + char(10);
--			SET @mDqry = @mDQry + ' 		    , a.requestor																								' + char(10);
--			SET @mDqry = @mDQry + ' FROM SSP_ANL_SHIP_CONFIRM  a                                                                                      ' + char(10)
--			--SET @mDqry = @mDQry + ' INNER JOIN  scp_mst_bod_v b ON a.division_id = b.division_id  AND a.bod_id = b.bod_id                             ' + char(10)
--			SET @mDqry = @mDQry + ' INNER JOIN  scp_mst_bod_v b ON (case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end) = b.division_id  AND a.bod_id = b.bod_id                             ' + char(10)
--			SET @mDqry = @mDQry + ' LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ C ON A.CHANGE_REQ_NO = C.CHANGE_REQ_NO AND c.VALID_YN = ''Y''          ' + char(10)
--			SET @mDqry = @mDQry + ' WHERE 1=1                                                                                                         ' + char(10)
--/*
--			SET @mDqry = @mDQry + ' 	AND yyyymmdd >= ''' + @p_from_yyyymmdd + '''                                                                                ' + char(10)
--			SET @mDqry = @mDQry + ' 	AND yyyymmdd <= ''' + @p_to_yyyymmdd + '''                                                                                  ' + char(10)
--			SET @mDqry = @mDQry + ' 	AND a.division_id = ''' + @p_division_id + '''                                                                              ' + char(10)
--			SET @mDqry = @mDQry + ' 	AND a.from_site = '''+@p_from_site + '''                                                                                  ' + char(10)
--			SET @mDqry = @mDQry + ' 	AND (''' + @p_to_site + ''' = '''' or a.TO_SITE = ''' + @p_to_site + ''')                                                 ' + char(10)
--			SET @mDqry = @mDQry + ' 	AND ((''' + @p_erp_so_no + ''' != '''' and a.erp_so_no = ''' + @p_erp_so_no +''')                                                        ' + char(10)
--			SET @mDqry = @mDQry + ' 	OR ('''+@p_erp_so_no+''' = '''' and a.CONFIRM_ID = '''+@p_confirm_id+'''))                                                        ' + char(10)
--			SET @mDqry = @mDQry + ' 	AND ('''+@p_bod_id+''' = '''' or a.BOD_ID = '''+@p_bod_id+''')                                                                    ' + char(10)
--			SET @mDqry = @mDQry + ' 	AND ('''+@p_incoterms+''' = '''' or a.INCOTERMS = '''+@p_incoterms+''')                                                           ' + char(10)
--			SET @mDqry = @mDQry + ' 	AND ('''+@p_transport_mode+''' = '''' or a.TRANSPORT_MODE = '''+@p_transport_mode+''')                                            ' + char(10)
--			SET @mDqry = @mDQry + ' 	AND ('''+@p_project_code+''' = '''' or a.PROJECT_CODE = '''+@p_project_code+''')                                                  ' + char(10)
--			SET @mDqry = @mDQry + ' 	AND ('''+@p_fcst_type+''' = '''' or a.FCST_TYPE = '''+@p_fcst_type+''')                                                           ' + char(10)
--			SET @mDqry = @mDQry + ' 	AND A.CHANGE_TYPE = ''' + @p_change_type + '''                                                                                ' + char(10)			
--*/
--			SET @mDqry = @mDQry + ' 	AND a.division_id = ''' + @p_division_id + '''                                                                              ' + char(10)
--			SET @mDqry = @mDQry + ' 	AND a.from_site = '''+@p_from_site + '''                                                                                  ' + char(10)
--			IF @p_erp_so_no IS NULL OR @p_erp_so_no = ''
--				BEGIN
--					SET @mDqry = @mDQry + ' 	AND yyyymmdd >= ''' + @p_from_yyyymmdd + '''                                                                                ' + char(10)
--					SET @mDqry = @mDQry + ' 	AND yyyymmdd <= ''' + @p_to_yyyymmdd + '''                                                                                  ' + char(10)
--					SET @mDqry = @mDQry + ' 	AND (''' + @p_to_site + ''' = '''' or a.TO_SITE = ''' + @p_to_site + ''')                                                 ' + char(10)
--					SET @mDqry = @mDQry + ' 	AND ((''' + @p_erp_so_no + ''' != '''' and a.erp_so_no = ''' + @p_erp_so_no +''')                                                        ' + char(10)
--					SET @mDqry = @mDQry + ' 	OR ('''+@p_erp_so_no+''' = '''' and a.CONFIRM_ID = '''+@p_confirm_id+'''))                                                        ' + char(10)
--					SET @mDqry = @mDQry + ' 	AND ('''+@p_bod_id+''' = '''' or a.BOD_ID = '''+@p_bod_id+''')                                                                    ' + char(10)
--					SET @mDqry = @mDQry + ' 	AND ('''+@p_incoterms+''' = '''' or b.ssp_incoterms = '''+@p_incoterms+''')                                                           ' + char(10)
--					SET @mDqry = @mDQry + ' 	AND ('''+@p_transport_mode+''' = '''' or a.TRANSPORT_MODE = '''+@p_transport_mode+''')                                            ' + char(10)
--					SET @mDqry = @mDQry + ' 	AND ('''+@p_project_code+''' = '''' or a.PROJECT_CODE = '''+@p_project_code+''')                                                  ' + char(10)
--					SET @mDqry = @mDQry + ' 	AND ('''+@p_fcst_type+''' = '''' or a.FCST_TYPE = '''+@p_fcst_type+''')                                                           ' + char(10)
--					--SET @mDqry = @mDQry + ' 	AND A.CHANGE_TYPE = ''' + @p_change_type + '''                                                                                ' + char(10)
--				END	
--			ELSE
--			--erp_so_no 번호가 같은 플랜은 모두 조회
--				BEGIN
--					SET @mDqry = @mDQry + ' 	AND a.erp_so_no = '''+@p_erp_so_no + '''                                                                                  ' + char(10)
--				END			
--			SET @mDqry = @mDQry + ' ORDER BY a.division_id, a.erp_so_no, a.shipment_status, a.item_id, etd	;                                         ' + char(10)
--			--select @mDQry;
--			EXEC (@mDQry);

--			IF( @debug_mode ='T')
--			BEGIN				
--				DECLARE @POS INT =1;
--				DECLARE @LEN INT =LEN(@mDQry);
--				WHILE @POS <= @LEN
--					BEGIN
--						PRINT SUBSTRING(@mDQry,@POS,4000);
--						SET @POS = @POS+4000;
--					END;
--			END;
--		END
--	ELSE
		--BEGIN
			SELECT a.division_id
				, a.erp_so_no
				, case when a.division_id = '40' then a.PROJECT_CODE else [dbo].[FN_GET_PROJECT_NAME]((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end),a.project_code) end project_name
				, a.project_code
				, a.fcst_type
				, a.item_id
				, DBO.FN_GET_ITEM_NICKNAME(a.division_id , A.ITEM_ID ) AS NICK_NAME
				, a.from_site
				, isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-') AS from_site_description
				, a.to_site
				, isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.to_site ),'-') as to_site_description
				, dbo.fn_get_site_customer_info( (case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.to_site, 'SOLDTO_DESCRIPTION' ) AS soldto_description
				, dbo.fn_get_site_customer_info( (case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.to_site, 'SHIPTO_DESCRIPTION' ) AS shipto_description
				--* 2020/09/21  KIMYONGHO		  SSP INCOTERMS 변경 작업
				--, b.incoterms
				, a.TO_SITE_SHIPTO_CODE AS SHIPTO_CODE
				, b.ssp_incoterms AS INCOTERMS
				, case when new_yn ='Y' THEN '-' ELSE b.transport_mode	END  AS transport_mode
				, case when new_yn ='Y' THEN '-' ELSE case when isnull(a.yyyymmdd,'') = '' then '' else convert(char(10), convert(datetime, a.yyyymmdd), 23) end END shipment_date
				, case when new_yn ='Y' THEN 0 ELSE a.qty END AS shipment_confirm_qty	 	 		 
				, a.bod_id		
				, case when new_yn ='Y' THEN 0 ELSE b.lt_total END AS lt_day
				, case when new_yn ='Y' THEN '-' ELSE CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) END AS etd 
				, case when new_yn ='Y' THEN '-' ELSE CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) END AS eta
				, a.ROUTE_ID
				, a.new_route_id
				, a.new_bod_id
				, a.new_customer_lt new_lt_day
				, a.new_d_country
				, a.new_d_port_code
				, a.new_a_country
				, a.new_a_port_code
				, a.new_to_country
				, a.new_to_city
				, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.NEW_ETD_DATE,112), 23) AS new_etd
				, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.NEW_ETA_DATE,112), 23) AS new_eta
				, A.TO_SITE_SHIPTO_CODE AS NEW_SHIPTO_CODE
				, a.new_incoterms
				, a.new_transport_mode
				, case when isnull(a.new_yyyymmdd,'') = '' then '' else convert(char(10), convert(datetime, a.new_yyyymmdd), 23) end new_shipment_date
				, a.new_qty AS new_shipment_confirm_qty	
				, a.confirm_id
				, a.change_req_no
				, a.NEW_YN
				, c.CONFIRM_ID plan_confirm_id
				, a.electrode_yn, a.electrode_type, a.origin_from_division_id, a.origin_to_division_id
				, case when C.CONFIRM_ID is not null then 'Y' else 'N' end new_base_confirm_yn
				, a.remarks
				, a.remarks2
				, a.remarks3
				, a.REQUESTOR
			INTO #Tmp_SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
			FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de A WITH(NOLOCK)
			INNER JOIN [DBO].[scp_mst_bod_n_v] b ON (case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end)  = b.division_id  AND a.bod_id = b.bod_id
			INNER JOIN SSP_ANL_SHIP_CONFIRM c on a.CONFIRM_ID = c.CONFIRM_ID AND C.SHIPMENT_STATUS = 'D' -- and C.CHANGE_TYPE = 'C'

			WHERE 1=1
			AND A.CHANGE_REQ_NO = C.CHANGE_REQ_NO
			AND A.LAST_UPDATED_BY = @p_request_user_id  
			AND A.VALID_YN = 'Y'
			AND A.ATTRIBUTE1 = 'Y'
			AND c.CONFIRM_ID LIKE 'R%'
			  
									--IN ( 
									--	SELECT MAX(CHANGE_REQ_NO) AS CHANGE_REQ_NO
									--	FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de 
									--   WHERE 1=1  
									--	 AND YYYYMMDD >= @p_from_yyyymmdd
									--	 AND YYYYMMDD <= @p_to_yyyymmdd
									--	 AND LAST_UPDATED_BY = @p_request_user_id  
									--	 AND VALID_YN = 'Y' 
									--	 AND ATTRIBUTE1 = 'Y' 
									  
									--)--@p_change_request_no


			  --AND A.CHANGE_REQ_NO IN ( 
					--					SELECT MAX(CHANGE_REQ_NO) AS CHANGE_REQ_NO
					--					FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de 
					--				   WHERE 1=1  
					--					 AND YYYYMMDD >= @p_from_yyyymmdd
					--					 AND YYYYMMDD <= @p_to_yyyymmdd
					--					 AND LAST_UPDATED_BY = @p_request_user_id  
					--					 AND VALID_YN = 'Y' 
					--					 AND ATTRIBUTE1 = 'Y' 
					--				   --GROUP BY CONFIRM_ID , ITEM_ID
					--				)--@p_change_request_no
			 
			ORDER BY new_shipment_date;


			SELECT * FROM #Tmp_SSP_ANL_SHIP_CONFIRM_CHG_REQ_de;

			--SELECT CHANGE_REQ_NO
			--	,CHANGE_REQ_STATUS
			--	,DIVISION_ID
			--	,FROM_SITE
			--	,REQUEST_TITLE
			--	,REQUEST_USER
			--	,CASE @p_language WHEN 'KO' THEN C.UserName ELSE C.UserName_E END REQUEST_USER_NAME
			--	,REQUEST_DEPT
			--	,CASE @p_language WHEN 'KO' THEN E.DEPT_NAME_KO
			--	                 WHEN 'EN' THEN E.DEPT_NAME_EN
			--					 WHEN 'CN' THEN E.DEPT_NAME_CN
			--			ELSE E.DEPT_NAME_KO END REQUEST_DEPT_NAME
			--	,REQUEST_TIME
			--	,APPROVAL_USER
			--	,CASE @p_language WHEN 'KO' THEN D.UserName ELSE D.UserName_E END APPROVAL_USER_NAME
			--	,APPROVAL_DEPT
			--	,CASE C.Language WHEN 'KO' THEN B.DEPT_NAME_KO
			--	                 WHEN 'EN' THEN B.DEPT_NAME_EN
			--					 WHEN 'CN' THEN B.DEPT_NAME_CN
			--			ELSE B.DEPT_NAME_KO END APPROVAL_DEPT_NAME
			--	,APPROVAL_TIME
			--	,CHANGE_REASON_CODE
			--	,CHANGE_REASON_DETAIL
			--	,REJECT_REASON
			--FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ A
			--LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO B ON A.APPROVAL_DEPT = B.DEPT_ID
			--LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO E ON A.REQUEST_DEPT = E.DEPT_ID
			--LEFT OUTER JOIN TB_FX_User C ON A.REQUEST_USER = C.UserID
			--LEFT OUTER JOIN TB_FX_User D ON A.APPROVAL_USER = D.UserID
			--WHERE 1=1
			--  AND A.CHANGE_REQ_NO = @p_change_request_no
			--  AND A.REQUEST_USER = @p_request_user_id
			--  AND A.VALID_YN = 'Y';		

-- * 2022/03/03  SMS 소형 외주 Packer Item 코드 이중화로 인한 Model PIC 검색 변경
			SELECT TOP 1 A.USER_ID
				   , B.USER_NAME
				   , B.USER_NAME_EN
				   , B.DEPT_ID
				   , C.DEPT_NAME_KO
				   , C.DEPT_NAME_EN
			FROM SSP_MST_MODEL_USER A WITH(NOLOCK)
			INNER JOIN #Tmp_SSP_ANL_SHIP_CONFIRM_CHG_REQ_de DE
				ON A.DIVISION_ID = DE.DIVISION_ID
				AND A.FROM_SITE = DE.FROM_SITE
				--AND A.ITEM_ID = DE.ITEM_ID
			INNER JOIN SCM_MST_SITE	BB WITH(NOLOCK)
				ON BB.DIVISION_ID = DE.DIVISION_ID
			    AND BB.SCM_SITE_ID = DE.FROM_SITE
			JOIN SCM_MST_SSO_USER_INFO B WITH(NOLOCK) ON A.USER_ID = B.USER_ID
			LEFT JOIN SCM_MST_SSO_DEPT_INFO C WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
			WHERE 1=1
			  AND A.VALID_YN	= 'Y'
  			  AND CASE WHEN ISNULL(BB.PACKER_ITEM_ID_SUFFIX,'') = '' THEN A.ITEM_ID ELSE SUBSTRING(A.ITEM_ID,1,11) END = CASE WHEN ISNULL(BB.PACKER_ITEM_ID_SUFFIX,'') = '' THEN DE.ITEM_ID ELSE SUBSTRING(DE.ITEM_ID,1,11) END	;

			--SELECT TOP 1 A.USER_ID
			--	   , B.USER_NAME
			--	   , B.USER_NAME_EN
			--	   , B.DEPT_ID
			--	   , C.DEPT_NAME_KO
			--	   , C.DEPT_NAME_EN
			--FROM SSP_MST_MODEL_USER A WITH(NOLOCK)
			--INNER JOIN #Tmp_SSP_ANL_SHIP_CONFIRM_CHG_REQ_de DE
			--	ON A.DIVISION_ID = DE.DIVISION_ID
			--	AND A.FROM_SITE = DE.FROM_SITE
			--	AND A.ITEM_ID = DE.ITEM_ID
			--JOIN SCM_MST_SSO_USER_INFO B WITH(NOLOCK) ON A.USER_ID = B.USER_ID
			--LEFT JOIN SCM_MST_SSO_DEPT_INFO C WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
			--WHERE 1=1
			--  AND A.VALID_YN	= 'Y';
-- =========================================================================================

		--END
END

