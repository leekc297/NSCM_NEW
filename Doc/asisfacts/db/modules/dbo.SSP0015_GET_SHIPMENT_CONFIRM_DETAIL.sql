
/*
 * Program ID   : SSP0015_GET_SHIPMENT_CONFIRM_DETAIL
 * Description  : Shipment PSI(Small)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/03/11   AYJ 			Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
 * 2019/05/09   AYJ 			MyModel 체크여부에 따른 조회조건 분기처리
 * 2019/05/20	AYJ				[CSR ID:3994743] REQUESTOR 컬럼 추가
 * 2019/06/17	AYJ			    조회 조건 추가(p_partLeaderChk, p_teamLeaderChk)
 * 2019/08/28	AYJ			    조회 조건 추가(p_delegateeChk)
 * 2019/12/17	KIMYONGHO		[C20191216-000311] Expected Shipping Date 컬럼 추가
 * 2020/09/21   KIMYONHHO      SSP INCOTERMS 변경 작업
 * 2021/02/04   KIMYONGHO	  ETA_DATE 조회 시 항차를 고려한 LT 적용되도록 함수 적용 FN_GET_SSP_ETA_DATE
 * 2021/10/05   SHINMYUNGSU	  SSP_ANL_SHIP_CONFIRM 의 Attribute3,6 항목 추가
 * 2021/10/12   KIMYONGHO	  [C20211001-000241] Confirm 복사하여 신규 생성 기능 추가
 * 2023/09/21   jilee          G182-P (Group='P',OSP='N')조회 추가
 * 2024/09/03   SSP           Team 컬럼 추가
 * 2024/10/01   KHJ           NERP_SSP

	ex) EXEC SSP0015_GET_SHIPMENT_CONFIRM_DETAIL @p_division_id='40', @p_from_site='', @p_to_site='', @p_erp_so_no='', @p_item_id='', @p_from_yyyymmdd='20181023', @p_to_yyyymmdd='20181123', @p_status='', @p_language='KO', @debug_mode='F', @p_change_type='C,P', @p_checked=NULL, @p_myModelChk='Y', @p_user_id = 'addio777'
 */

CREATE PROCEDURE [dbo].[SSP0015_GET_SHIPMENT_CONFIRM_DETAIL]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_from_yyyymmdd		NVARCHAR(MAX)
	,@p_to_yyyymmdd			NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(MAX)
	,@p_language            NVARCHAR(MAX) = 'KO'
	,@p_user_id				NVARCHAR(MAX)
	,@p_myModelChk			NVARCHAR(MAX) = 'N'
	,@p_requestor			NVARCHAR(MAX)
	,@p_partLeaderChk		NVARCHAR(MAX)
	,@p_teamLeaderChk		NVARCHAR(MAX)
	,@p_search_yn			NVARCHAR(MAX)
	,@p_nonChk				NVARCHAR(MAX) = 'N'
	,@p_real_flag			NVARCHAR(MAX) = 'N'
	,@debug_mode			NVARCHAR(1)='T'
	,@p_delegateeChk		NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @mDQry NVARCHAR(MAX)='';

	DECLARE  @v_division_id NVARCHAR(MAX)='';
	DECLARE  @v_from_site NVARCHAR(MAX)='';
	DECLARE  @v_item_id NVARCHAR(MAX)='';
	DECLARE  @v_requestor NVARCHAR(MAX)='';
	
	--IN 조건으로 데이터를 가져옴
	SET @v_division_id = [dbo].FN_GET_IN_STR(@p_division_id);
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);
	SET @v_requestor = @p_requestor;
	--select @v_requestor; --SET @v_requestor = [dbo].FN_GET_IN_STR2(@p_requestor);

	IF @p_real_flag = 'Y'
		BEGIN
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
			SET @mDqry = @mDQry + ' 		 , convert(int, a.qty) AS shipment_confirm_qty                                                                                        ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.remarks					                                                                                        ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.remarks2																											' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.remarks3																											' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.from_site                                                                                                          ' + char(10);
			SET @mDqry = @mDQry + ' 		 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),''-'') AS from_site_description                    ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.to_site                                                                                                            ' + char(10);
			SET @mDqry = @mDQry + ' 		 , isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.to_site ),''-'') as to_site_description                      ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.TO_SITE_SOLDTO_CODE		' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.TO_SITE_SHIPTO_CODE		' + char(10);
			SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SOLDTO_DESCRIPTION'' ) AS soldto_description                ' + char(10);
			SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SHIPTO_DESCRIPTION'' ) AS shipto_description                ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.bod_id                                                                                                             ' + char(10);
			--* 2020/09/21  KIMYONHHO      SSP INCOTERMS 변경 작업
			--SET @mDqry = @mDQry + ' 		 , b.incoterms                                                                                                          ' + char(10);
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
			--* 2020/09/21  KIMYONHHO      SSP INCOTERMS 변경 작업
			--SET @mDqry = @mDQry + ' 		 , a.route_id NEW_ROUTE_ID, a.bod_id NEW_BOD_ID, b.incoterms NEW_INCOTERMS, a.d_country NEW_D_COUNTRY, a.d_port_code NEW_D_PORT_CODE, a.a_country NEW_A_COUNTRY, a.a_port_code NEW_A_PORT_CODE   ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.route_id NEW_ROUTE_ID, a.bod_id NEW_BOD_ID, b.ssp_incoterms NEW_INCOTERMS, a.d_country NEW_D_COUNTRY, a.d_port_code NEW_D_PORT_CODE, a.a_country NEW_A_COUNTRY, a.a_port_code NEW_A_PORT_CODE   ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.customer_lt NEW_CUSTOMER_LT, a.to_country NEW_TO_COUNTRY, a.to_city NEW_TO_CITY, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23) NEW_ETA, CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23) NEW_ETD, b.lt_total NEW_LT_DAY, b.transport_mode NEW_TRANSPORT_MODE , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) NEW_SHIPMENT_DATE  ' + char(10);
			SET @mDqry = @mDQry + ' 		 , ''N'' EDIT_REMARKS, ''N'' EDIT_MAIN, isnull(a.CHECK_NEED_YN,''N'') CHECK_NEED_YN  ' + char(10);
			--SET @mDqry = @mDQry + ' 		 , isnull(case when a.DIVISION_ID = ''40'' then a.PROJECT_CODE else f.END_CUSTOMER end,''-'') end_customer            ' + char(10);
			SET @mDqry = @mDQry + ' 		 , isnull(case when a.DIVISION_ID = ''40'' then case when a.PROJECT_CODE is not null and a.PROJECT_CODE != ''-'' then a.PROJECT_CODE else g.PROJECT_CODE end when a.DIVISION_ID = ''EE'' and a.ORIGIN_TO_DIVISION_ID = ''40'' then g.project_code else f.END_CUSTOMER end,''-'') end_customer            ' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.ELECTRODE_YN, a.ELECTRODE_TYPE, a.ORIGIN_FROM_DIVISION_ID, a.ORIGIN_TO_DIVISION_ID, h.CHANGE_REQ_NO                   ' + char(10);
			SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U2.UserName ELSE U2.UserName_E END + ''('' + mu.user_id + '')'' model_user    ' + char(10);
			SET @mDqry = @mDQry + ' 		 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '','', '''+@p_language+''') AS MTK_OWNER                                                                                         ' + char(10);			
			SET @mDqry = @mDQry + '          , (SELECT ISNULL(DEPT_NAME_KO,''-'') FROM SCM_MST_SSO_DEPT_INFO A1 WITH(NOLOCK) LEFT OUTER JOIN TB_FX_User B1 WITH(NOLOCK) ON A1.DEPT_ID = B1.DEPT_ID WHERE B1.UserID = SI.OWNER ) AS TEAM  ' + char(10);
			SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U3.UserName ELSE U3.UserName_E END + ''('' + a.requestor + '')'' requestor    ' + char(10);
			--SET @mDqry = @mDQry + ' 		 , CASE WHEN T1.CHANGE_REASON_CODE = ''SELECT''THEN NULL '+ char(10);
			--SET @mDqry = @mDQry + ' 		        WHEN T1.CHANGE_REASON_CODE = ''C00''THEN NULL '+ char(10);
			--SET @mDqry = @mDQry + ' 		   ELSE T1.CHANGE_REASON_CODE END AS CHANGE_REASON_CODE '+ char(10);
			--SET @mDqry = @mDQry + '			 , CASE WHEN T1.CHANGE_REASON_DETAIL = ''change on the Shipment Plan Adjustment screen'' THEN '''' ELSE T1.CHANGE_REASON_DETAIL END AS CHANGE_REASON_DETAIL '+ char(10);
			SET @mDqry = @mDQry + '			 , ''-'' AS CHANGE_REASON_CODE ' + char(10);
			SET @mDqry = @mDQry + '			 , '''' AS CHANGE_REASON_DETAIL	' + char(10);
			-- [C20211001-000241] Confirm 복사하여 신규 생성 기능 추가
			SET @mDqry = @mDQry + '			 , isnull(a.attribute10, ''-'') AS attribute10'+ char(10);
			--* 2021/10/05   SHINMYUNGSU    열람 항목추가
			SET @mDqry = @mDQry + '			 , isnull(a.attribute3, ''-'') AS attribute3'+ char(10);
			SET @mDqry = @mDQry + '			 , isnull(a.attribute6, ''-'') AS attribute6'+ char(10);
			--*********************************************************************************************************
			SET @mDqry = @mDQry + ' 	   FROM SSP_ANL_SHIP_CONFIRM  a with(nolock)                                                                                          ' + char(10);
			SET @mDqry = @mDQry + ' 	  INNER JOIN SCM_MST_SITE MS with(nolock) ON A.DIVISION_ID = MS.DIVISION_ID AND A.FROM_SITE = MS.SCM_SITE_ID AND MS.SITE_TYPE = ''PLANT'' AND A.DIVISION_ID = ''40'' AND (MS.OPERATION_GROUP = ''A'' OR MS.OSP_YN = ''N'') --MS.OPERATION_GROUP = ''A''                                     ' + char(10);
			--SET @mDqry = @mDQry + ' 	  INNER JOIN  scp_mst_bod_v b with(nolock) ON (CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID END) = b.division_id  AND a.bod_id = b.bod_id                                   ' + char(10);
			SET @mDqry = @mDQry + ' 	  INNER JOIN  scp_mst_bod_n_v b with(nolock) ON (CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID END) = b.division_id  AND a.bod_id = b.bod_id                                   ' + char(10);
			SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN TB_FX_User U with(nolock) ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = ''Y''                                             ' + char(10);
			--SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN scm_mst_site_item E ON e.division_id = a.division_id and e.SCM_SITE_ID = a.to_site and e.item_id = a.item_id       ' + char(10);
			SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN SCM_MST_SITE f with(nolock) ON f.division_id = a.ORIGIN_TO_DIVISION_ID and f.SCM_SITE_ID = a.to_site      ' + char(10);
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
			SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN TB_FX_User U3 with(nolock) ON a.requestor = u3.UserID AND U3.UseYN = ''Y''                                             ' + char(10);
			--20181102 추가
			SET @mDqry = @mDQry + ' 	  LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) ON SI.DIVISION_ID  = (CASE WHEN A.DIVISION_ID =''EE'' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END)       ' + char(10);
			SET @mDqry = @mDQry + ' 														AND SI.SCM_SITE_ID  = A.TO_SITE        ' + char(10);
			SET @mDqry = @mDQry + ' 														AND SI.ITEM_ID  = A.ITEM_ID        ' + char(10);
			--SET @mDqry = @mDQry + ' 														AND SI.PROJECT_CODE  = case when CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID end  = ''40'' then g.project_code else A.PROJECT_CODE  end        ' + char(10);
			SET @mDqry = @mDQry + ' 														AND SI.PROJECT_CODE  = A.PROJECT_CODE        ' + char(10);
			SET @mDqry = @mDQry + '			LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ T1 with(nolock) ' + char(10);
			SET @mDqry = @mDQry + '				ON h.CHANGE_REQ_NO = T1.CHANGE_REQ_NO ' + char(10);
			SET @mDqry = @mDQry + ' 	  WHERE 1=1                                                                                                               ' + char(10);

			--Search 버튼으로 조회 시작(체크박스 체크 여부에 따라 조회 - (@p_nonChk = 'Y' : 체크박스 선택 안한 상태))
			IF @p_search_yn = 'Y'
				BEGIN
					--SET @mDQry = @mDQry + '		AND ((''' + @p_nonChk + ''' = ''Y'' AND 1 = 1 OR mu.USER_ID = CASE WHEN ''' + @p_myModelChk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END			' + char(10) ;
					SET @mDQry = @mDQry + '		AND ((''' + @p_nonChk + ''' = ''Y'' AND 1 = 1 OR mu.USER_ID IN (SELECT CASE WHEN ''' + @p_myModelChk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END	' + char(10) ;
					SET @mDQry = @mDQry + '																		UNION																							' + char(10) ;
					SET @mDQry = @mDQry + '																		SELECT CASE WHEN ''' + @p_delegateeChk + ''' = ''Y'' THEN USER_ID ELSE ''X'' END				' + char(10) ;
					SET @mDQry = @mDQry + '																		FROM SSP_MST_DELEGATE with(nolock) WHERE VALID_YN = ''Y'' AND DELEGATEE_ID = ''' + @p_user_id + ''' GROUP BY USER_ID)				' + char(10) ;
					SET @mDQry = @mDQry + '		   											  OR mu.PART_LEADER = CASE WHEN ''' + @p_partLeaderChk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END		' + char(10) ;
					SET @mDQry = @mDQry + '		   											  OR mu.TEAM_LEADER = CASE WHEN ''' + @p_teamLeaderChk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END))	' + char(10) ;
				END	
			--Search 버튼으로 조회 끝

--			SET @mDqry = @mDQry + ' 	    AND yyyymmdd >= '+ @p_from_yyyymmdd +'		AND yyyymmdd <= '+ @p_to_yyyymmdd +'                                                    ' + char(10);
			--IF ( @p_plan_start_yyyymmdd     IS NOT NULL AND @p_plan_start_yyyymmdd    != ''  )
				--BEGIN
				--	SET @mDQry = @mDQry + ' 					AND  yyyymmdd       = '+ @p_plan_start_yyyymmdd     +''+char(10)
				--END
			
				--BEGIN
					SET @mDqry = @mDQry + ' 	    AND yyyymmdd >= '+ @p_from_yyyymmdd +'		AND yyyymmdd <= '+ @p_to_yyyymmdd +'                                                    ' + char(10);
				--END

			IF ( @v_division_id IS NOT NULL AND @v_division_id    != '') SET @mDQry = @mDQry + ' 					AND  a.division_id   IN ('+ @v_division_id +')'+char(10);  
			IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mDQry = @mDQry + ' 					AND  a.item_id       IN ('+ @v_item_id     +')'+char(10); 
			--SET @mDQry = @mDQry + ' 					AND  a.item_id       IN ('+ @v_item_id     +')'+char(10);
			IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDQry = @mDQry + ' 					AND  a.from_site     IN ('+ @v_from_site   +')'+char(10); 
			IF ( @v_requestor     IS NOT NULL AND @v_requestor    != ''  )
			BEGIN
				SET @mDQry = @mDQry + ' 					AND  a.requestor       IN ( ' + char(10) ;
				SET @mDQry = @mDQry + '													SELECT DISTINCT TT1.UserID FROM (' + char(10);
				SET @mDQry = @mDQry + '													(SELECT UserID FROM TB_FX_User with(nolock) ' + char(10) ;
				SET @mDQry = @mDQry + '													WHERE 1 = 1 ' + char(10) ;
				SET @mDQry = @mDQry + '													AND UserName		IN (' + @v_requestor + ')' +char(10);
				SET @mDQry = @mDQry + '													UNION ALL ' + char(10);
				SET @mDQry = @mDQry + '													SELECT UserID FROM TB_FX_User with(nolock) ' + char(10) ;
				SET @mDQry = @mDQry + '													WHERE 1 = 1 ' + char(10) ;
				SET @mDQry = @mDQry + '													AND UserID		IN (' + @v_requestor + '))) TT1 ' +char(10);
				SET @mDQry = @mDQry + '												) ' + char(10);
			END 
			SET @mDqry = @mDQry + ' 		  AND (a.shipment_status IS NOT NULL AND isnull(a.shipment_status,'''') != '''') '+char(10); 
			SET @mDqry = @mDQry + ' 		  AND a.qty > 0 '+char(10); 
			SET @mDqry = @mDQry + ' 		  AND a.change_type <> ''N''  '+char(10); 
			SET @mDqry = @mDQry + ' 		  AND a.biz_type <> ''E''  '+char(10);

			SET @mDqry = @mDQry + ' 	UNION ALL                                                                                                                                                                                                                                                                                    ' + char(10);
			SET @mDqry = @mDQry + ' 	SELECT							' + char(10);
			SET @mDqry = @mDQry + '			DIVISION_ID					' + char(10);
			SET @mDqry = @mDQry + '			, ERP_SO_NO                 ' + char(10);
			SET @mDqry = @mDQry + '			, SHIPMENT_STATUS           ' + char(10);
			SET @mDqry = @mDQry + '			, PROJECT_CODE              ' + char(10);
			SET @mDqry = @mDQry + '			, PROJECT_NAME              ' + char(10);
			SET @mDqry = @mDQry + '			, FCST_TYPE                 ' + char(10);
			SET @mDqry = @mDQry + '			, ITEM_ID                   ' + char(10);
			SET @mDqry = @mDQry + '			, NICK_NAME                 ' + char(10);
			SET @mDqry = @mDQry + '			, CONVERT(VARCHAR(10),   CONVERT(DATETIME, shipment_date,112), 23)             ' + char(10);
			SET @mDqry = @mDQry + '			, 0 AS BEFORE_qty			' + char(10);
			SET @mDqry = @mDQry + '			, QTY                       ' + char(10);
			SET @mDqry = @mDQry + '			, REMARKS                   ' + char(10);
			SET @mDqry = @mDQry + '			, REMARKS2                  ' + char(10);
			SET @mDqry = @mDQry + '			, REMARKS3					' + char(10);
			SET @mDqry = @mDQry + '			, FROM_SITE                 ' + char(10);
			SET @mDqry = @mDQry + '			, FROM_SITE_DESCRIPTION     ' + char(10);
			SET @mDqry = @mDQry + '			, TO_SITE                   ' + char(10);
			SET @mDqry = @mDQry + '			, TO_SITE_DESCRIPTION       ' + char(10);
			SET @mDqry = @mDQry + ' 		, TO_SITE_SOLDTO_CODE		' + char(10);
			SET @mDqry = @mDQry + ' 		, TO_SITE_SHIPTO_CODE		' + char(10);
			SET @mDqry = @mDQry + '			, SOLDTO_DESCRIPTION        ' + char(10);
			SET @mDqry = @mDQry + '			, SHIPTO_DESCRIPTION        ' + char(10);
			SET @mDqry = @mDQry + '			, BOD_ID                    ' + char(10);
			SET @mDqry = @mDQry + '			, INCOTERMS					' + char(10);
			SET @mDqry = @mDQry + '			, TRANSPORT_MODE            ' + char(10);
			SET @mDqry = @mDQry + '			, LT_TOTAL					' + char(10);
			SET @mDqry = @mDQry + '			, ETD                 ' + char(10);
			SET @mDqry = @mDQry + '			, ETA                  ' + char(10);
			SET @mDqry = @mDQry + '			, EXPECTED_SHIPPING_DATE    ' + char(10);
			SET @mDqry = @mDQry + '			, CONFIRM_ID                ' + char(10);
			SET @mDqry = @mDQry + '			, LAST_UPDATED_BY           ' + char(10);
			SET @mDqry = @mDQry + '			, LAST_UPDATE_DATE          ' + char(10);
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
			SET @mDqry = @mDQry + '			, ''-'' AS NEW_LT_DAY					' + char(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_TRANSPORT_MODE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_SHIPMENT_DATE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS EDIT_REMARKS ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS EDIT_MAIN ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS CHECK_NEED_YN ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS END_CUSTOMER ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ELECTRODE_YN ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ELECTRODE_TYPE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ORIGIN_FROM_DIVISION_ID ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ORIGIN_TO_DIVISION_ID ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS CHANGE_REQ_NO ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS MODEL_USER   ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS MTK_OWNER   ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS TEAM        ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS REQUESTOR   ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS CHANGE_REASON_CODE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS CHANGE_REASON_DETAIL ' + CHAR(10);
			-- [C20211001-000241] Confirm 복사하여 신규 생성 기능 추가
			SET @mDqry = @mDQry + '			, ''-'' AS attribute10 '+ char(10);
			--* 2021/10/05   SHINMYUNGSU    열람 항목추가
			SET @mDqry = @mDQry + ' 		, ''-'' AS attribute3 ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS attribute6 ' + CHAR(10);
			--*********************************************************************************************************
			SET @mDqry = @mDQry + ' 	FROM							' + char(10);
			SET @mDqry = @mDQry + ' 	(								' + char(10);
			SET @mDqry = @mDQry + ' 		SELECT                                                                                                                                                                                                                                                                                      ' + char(10);
			SET @mDqry = @mDQry + ' 			tt0.DIVISION_ID                                                                                                                                                                                                                                                                         ' + char(10);
			SET @mDqry = @mDQry + ' 			, NULL AS ERP_SO_NO                                                                                                                                                                                                                                                                      ' + char(10);
			SET @mDqry = @mDQry + ' 			, ''P'' AS SHIPMENT_STATUS                                                                                                                                                                                                                                                             ' + char(10);
			SET @mDqry = @mDQry + ' 			, tt0. ITEM_ID                                                                                                                                                                                                                                                                          ' + char(10);
			SET @mDqry = @mDQry + ' 		    , dbo.fn_get_item_nickname(tt0.division_id , tt0.item_id ) AS NICK_NAME                                                    ' + char(10);
			SET @mDqry = @mDQry + ' 			, tt0.DIVISION_ID AS ORIGIN_FROM_DIVISION_ID                                                                                                                                                                                                                                                        ' + char(10);
			SET @mDqry = @mDQry + ' 			, tt0.DIVISION_ID AS ORIGIN_TO_DIVISION_ID                                                                                                                                                                                                                                                          ' + char(10);
			SET @mDqry = @mDQry + ' 			, tt0.PLANT_SITE_ID AS FROM_SITE                                                                                                                                                                                                                                                        ' + char(10);
			SET @mDqry = @mDQry + ' 			, isnull(dbo.fn_get_scm_site_description(tt0.division_id, tt0.PLANT_SITE_ID ),''-'') AS from_site_description                    ' + char(10);
			SET @mDqry = @mDQry + ' 			, tt0.SCM_SITE_ID AS TO_SITE                                                                                                                                                                                                                                                            ' + char(10);
			SET @mDqry = @mDQry + ' 			, isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (tt0.division_id , tt0.SCM_SITE_ID ),''-'') as to_site_description                      ' + char(10);
			SET @mDqry = @mDQry + ' 			, tt0.PROJECT_CODE                                                                                                                                                                                                                                                                      ' + char(10);
			SET @mDqry = @mDQry + ' 			, [dbo].[FN_GET_PROJECT_NAME]( tt0.division_id ,tt0.project_code) AS  PROJECT_NAME                                                                                                                                     ' + char(10);
			SET @mDqry = @mDQry + ' 			, ''-'' AS REQUESTOR                                                                                                                                                                                                                                                                      ' + char(10);
			SET @mDqry = @mDQry + ' 			, tt0.QTY                                                                                                                                                                                                                                                                               ' + char(10);
			SET @mDqry = @mDQry + ' 			, tt0.YYYYMMDD   as shipment_date                                                                                                                                                                                                                                                                       ' + char(10);
			SET @mDqry = @mDQry + ' 			, tt0.BOD_ID                                                                                                                                                                                                                                                                            ' + char(10);
			SET @mDqry = @mDQry + ' 			, tt0.INCOTERMS                                                                                                                                                                                                                                                                            ' + char(10);
			SET @mDqry = @mDQry + ' 			, tt0.TRANSPORT_MODE                                                                                                                                                                                                                                                                            ' + char(10);       
			SET @mDqry = @mDQry + ' 			, dbo.fn_get_site_customer_info(tt0.division_id, tt0.SCM_SITE_ID,''SOLDTO_CODE'' ) AS TO_SITE_SOLDTO_CODE                ' + char(10);
			SET @mDqry = @mDQry + ' 			, dbo.fn_get_site_customer_info(tt0.division_id, tt0.SCM_SITE_ID, ''SHIPTO_CODE'' ) AS TO_SITE_SHIPTO_CODE                ' + char(10);
			SET @mDqry = @mDQry + ' 			, dbo.fn_get_site_customer_info(tt0.division_id, tt0.SCM_SITE_ID, ''SOLDTO_DESCRIPTION'' ) AS soldto_description                ' + char(10);
			SET @mDqry = @mDQry + ' 			, dbo.fn_get_site_customer_info(tt0.division_id, tt0.SCM_SITE_ID, ''SHIPTO_DESCRIPTION'' ) AS shipto_description                ' + char(10);
			SET @mDqry = @mDQry + ' 			, ''-'' AS REMARKS2                                                                                                                                                                                                                                                                       ' + char(10);
			SET @mDqry = @mDQry + ' 			, ''-'' AS REMARKS                                                                                                                                                                                                                                                                        ' + char(10);
			SET @mDqry = @mDQry + ' 			, ''-'' AS CHANGE_REQ_NO                                                                                                                                                                                                                                                                  ' + char(10);
			SET @mDqry = @mDQry + ' 			, ''-'' AS REMARKS3                                                                                                                                                                                                                                                                       ' + char(10);
			SET @mDqry = @mDQry + ' 			, CONVERT(VARCHAR(10), CONVERT(DATETIME, tt0.YYYYMMDD ,112), 23)  AS etd                                                                                                                                                                                                                                                                       ' + char(10);
			-- * 2021/02/04   KIMYONGHO	  ETA_DATE 조회 시 항차를 고려한 LT 적용되도록 함수 적용 FN_GET_SSP_ETA_DATE
			SET @mDqry = @mDQry + ' 			, CONVERT(VARCHAR(10),CONVERT(DATETIME,[dbo].[FN_GET_SSP_ETA_DATE](tt0.DIVISION_ID, tt0.BOD_ID, tt0.YYYYMMDD) ,112), 23) AS eta                                                                                                                                                                                                                                                                        ' + char(10);
			--SET @mDqry = @mDQry + ' 			, CONVERT(VARCHAR(10), CONVERT(DATETIME, tt0.YYYYMMDD ,112), 23)  AS etd                                                                                                                                                                                                                                                                       ' + char(10);
			--SET @mDqry = @mDQry + ' 			, convert(VARCHAR(10), dateadd(dd, convert(int, ISNULL(tt1.lt_total, 0)), convert(datetime, tt0.YYYYMMDD)),23) AS eta                                                                                                                                                                                                                                                                        ' + char(10);
			SET @mDQry = @mDQry + ' 			, CASE WHEN tt0.transport_mode = ''TRK'' then ''-'' else CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](tt0.DIVISION_ID, tt0.BOD_ID, tt0.YYYYMMDD), 112), 23) end as Expected_Shipping_Date    ' + char(10) ;
			SET @mDqry = @mDQry + ' 			, tt1.lt_total                                                                                                                                                                                                                                                                        ' + char(10);
			SET @mDqry = @mDQry + ' 			, tt0.LAST_UPDATED_BY                                                                                                                                                                                                                                                                   ' + char(10);
			SET @mDqry = @mDQry + ' 			, tt0.LAST_UPDATE_DATE                                                                                                                                                                                                                                                                  ' + char(10);
			SET @mDqry = @mDQry + ' 			, ''-'' AS CONFIRM_ID                                                                                                                                                                                                                                                                     ' + char(10);
			SET @mDqry = @mDQry + ' 			, tt0.FCST_TYPE                                                                                                                                                                                                                                                                         ' + char(10);
			SET @mDqry = @mDQry + ' 			, CASE WHEN isnull(tt2.ship_frozen,0) > 0 THEN CONVERT(CHAR(8), DATEADD(DD, isnull(tt2.ship_frozen,0), CONVERT(VARCHAR, ''' + @p_plan_start_yyyymmdd + ''', 121)), 112) ELSE ''' + @p_plan_start_yyyymmdd + ''' END AS frozen_yyyymmdd ' + char(10);
			SET @mDqry = @mDQry + ' 	FROM DM_PLN_SHIPMENT_REQ tt0 with(nolock)                                                                                                                                                                                                                                                              ' + char(10);
			--SET @mDqry = @mDQry + ' 	INNER JOIN  scp_mst_bod_v tt1 with(nolock) ON tt0.DIVISION_ID = tt1.division_id  AND tt0.bod_id = tt1.bod_id                                                                                                                                                                                                                  ' + char(10);
			SET @mDqry = @mDQry + ' 	INNER JOIN  scp_mst_bod_n_v tt1 with(nolock) ON tt0.DIVISION_ID = tt1.division_id  AND tt0.bod_id = tt1.bod_id                                                                                                                                                                                                                  ' + char(10);
			SET @mDqry = @mDQry + ' 	INNER JOIN SCM_MST_SITE tt2 with(nolock)                                                                                                                                                                                                                  ' + char(10);
			SET @mDqry = @mDQry + ' 		ON tt0.DIVISION_ID = tt2.DIVISION_ID ' + char(10);
			SET @mDqry = @mDQry + ' 		AND tt0.PLANT_SITE_ID = tt2.SCM_SITE_ID ' + char(10);
			SET @mDqry = @mDQry + ' 		AND tt2.site_type		= ''PLANT'' ' + char(10);
			SET @mDqry = @mDQry + ' 		AND tt2.valid_yn		= ''Y'' ' + char(10);
			SET @MDQRY = @MDQRY + ' 	LEFT OUTER JOIN SSP_MST_MODEL_USER MU with(nolock) ON MU.DIVISION_ID = tt0.DIVISION_ID AND MU.FROM_SITE = TT0.PLANT_SITE_ID AND MU.ITEM_ID = TT0.ITEM_ID AND MU.VALID_YN = ''Y''                                                                                                              ' + CHAR(10);
			SET @mDqry = @mDQry + ' 	LEFT OUTER JOIN TB_FX_User U2 with(nolock) ON mu.user_id = u2.UserID AND U2.UseYN = ''Y''                                             ' + char(10);
			SET @mDqry = @mDQry + ' 	WHERE 1 = 1                                                                                                                                                                                                                                                                                 ' + char(10);
			SET @mDQry = @mDQry + ' 	AND  tt0.DIVISION_ID       = '''+ @p_division_id     +''' '+char(10)


			IF @p_search_yn = 'Y'
				BEGIN
					SET @mDQry = @mDQry + '		AND ((''' + @p_nonChk + ''' = ''Y'' AND 1 = 1 OR mu.USER_ID IN (SELECT CASE WHEN ''' + @p_myModelChk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END	' + char(10) ;
					SET @mDQry = @mDQry + '																		UNION																							' + char(10) ;
					SET @mDQry = @mDQry + '																		SELECT CASE WHEN ''' + @p_delegateeChk + ''' = ''Y'' THEN USER_ID ELSE ''X'' END				' + char(10) ;
					SET @mDQry = @mDQry + '																		FROM SSP_MST_DELEGATE with(nolock) WHERE VALID_YN = ''Y'' AND DELEGATEE_ID = ''' + @p_user_id + ''' GROUP BY USER_ID)				' + char(10) ;
					SET @mDQry = @mDQry + '		   											  OR mu.PART_LEADER = CASE WHEN ''' + @p_partLeaderChk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END		' + char(10) ;
					SET @mDQry = @mDQry + '		   											  OR mu.TEAM_LEADER = CASE WHEN ''' + @p_teamLeaderChk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END))	' + char(10) ;
				END	
			SET @mDqry = @mDQry + '		) t	' + char(10);
			SET @mDqry = @mDQry + ' 	WHERE 1 = 1	' + char(10);
			--Search 버튼으로 조회 시작(체크박스 체크 여부에 따라 조회 - (@p_nonChk = 'Y' : 체크박스 선택 안한 상태))
			SET @mDqry = @mDQry + ' 	AND t.shipment_date >= t.frozen_yyyymmdd ' + char(10);
			SET @mDqry = @mDQry + ' 	AND t.shipment_date >= '''+ @p_from_yyyymmdd +''' '+ char(10);	
			SET @mDqry = @mDQry + ' 	AND t.shipment_date <= '''+ @p_to_yyyymmdd +''' '+ char(10);	
			IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mDQry = @mDQry + ' 					AND  t.item_id       IN ('+ @v_item_id     +')'+char(10); 
			IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDQry = @mDQry + ' 					AND  t.from_site     IN ('+ @v_from_site   +')'+char(10); 
			IF ( @v_requestor     IS NOT NULL AND @v_requestor    != ''  )
			BEGIN
				SET @mDQry = @mDQry + ' 					AND  t.LAST_UPDATED_BY       IN ( ' + char(10) ;
				SET @mDQry = @mDQry + '													SELECT DISTINCT TT1.UserID FROM (' + char(10);
				SET @mDQry = @mDQry + '													(SELECT UserID FROM TB_FX_User with(nolock) ' + char(10) ;
				SET @mDQry = @mDQry + '													WHERE 1 = 1 ' + char(10) ;
				SET @mDQry = @mDQry + '													AND UserName		IN (' + @v_requestor + ')' +char(10);
				SET @mDQry = @mDQry + '													UNION ALL ' + char(10);
				SET @mDQry = @mDQry + '													SELECT UserID FROM TB_FX_User with(nolock) ' + char(10) ;
				SET @mDQry = @mDQry + '													WHERE 1 = 1 ' + char(10) ;
				SET @mDQry = @mDQry + '													AND UserID		IN (' + @v_requestor + '))) TT1 ' +char(10);
				SET @mDQry = @mDQry + '												) ' + char(10);
			END 
			SET @mDqry = @mDQry + ' ) AS  AA ' + char(10);

			SET @mDqry = @mDQry + ' ORDER BY AA.division_id, AA.shipment_status, AA.shipment_date,  AA.item_id, AA.ERP_SO_NO DESC , AA.from_site, AA.to_site, AA.project_code, AA.fcst_type     ' + char(10);

		END
	ELSE
		BEGIN
			SET @mDqry = @mDQry + ' SELECT  AA.*  FROM      																										' + char(10);
			SET @mDqry = @mDQry + '  ( ' + char(10);
			SET @mDqry = @mDQry + ' 	SELECT							' + char(10);
			SET @mDqry = @mDQry + '			DIVISION_ID					' + char(10);
			SET @mDqry = @mDQry + '			, ERP_SO_NO                 ' + char(10);
			SET @mDqry = @mDQry + '			, SHIPMENT_STATUS           ' + char(10);
			SET @mDqry = @mDQry + '			, PROJECT_CODE              ' + char(10);
			SET @mDqry = @mDQry + '			, PROJECT_NAME              ' + char(10);
			SET @mDqry = @mDQry + '			, FCST_TYPE                 ' + char(10);
			SET @mDqry = @mDQry + '			, ITEM_ID                   ' + char(10);
			SET @mDqry = @mDQry + '			, NICK_NAME                 ' + char(10);
			SET @mDqry = @mDQry + '			, SHIPMENT_DATE             ' + char(10);
			--SET @mDqry = @mDQry + '			, 0 AS BEFORE_QTY			' + char(10);
			SET @mDqry = @mDQry + '			, SHIPMENT_CONFIRM_QTY              ' + char(10);
			SET @mDqry = @mDQry + '			, REMARKS                   ' + char(10);
			SET @mDqry = @mDQry + '			, REMARKS2                  ' + char(10);
			SET @mDqry = @mDQry + '			, REMARKS3					' + char(10);
			SET @mDqry = @mDQry + '			, FROM_SITE                 ' + char(10);
			SET @mDqry = @mDQry + '			, FROM_SITE_DESCRIPTION     ' + char(10);
			SET @mDqry = @mDQry + '			, TO_SITE                   ' + char(10);
			SET @mDqry = @mDQry + '			, TO_SITE_DESCRIPTION       ' + char(10);
			SET @mDqry = @mDQry + ' 		, TO_SITE_SOLDTO_CODE		' + char(10);
			SET @mDqry = @mDQry + ' 		, TO_SITE_SHIPTO_CODE		' + char(10);
			SET @mDqry = @mDQry + '			, SOLDTO_DESCRIPTION        ' + char(10);
			SET @mDqry = @mDQry + '			, SHIPTO_DESCRIPTION        ' + char(10);
			SET @mDqry = @mDQry + '			, BOD_ID                    ' + char(10);
			SET @mDqry = @mDQry + '			, INCOTERMS					' + char(10);
			SET @mDqry = @mDQry + '			, TRANSPORT_MODE            ' + char(10);
			SET @mDqry = @mDQry + '			, LT_DAY					' + char(10);
			SET @mDqry = @mDQry + '			, ETD						' + char(10);
			SET @mDqry = @mDQry + '			, ETA						' + char(10);
			SET @mDqry = @mDQry + '			, EXPECTED_SHIPPING_DATE    ' + char(10);
			SET @mDqry = @mDQry + '			, CONFIRM_ID                ' + char(10);
			SET @mDqry = @mDQry + '			, UPDATED_BY           ' + char(10);
			SET @mDqry = @mDQry + '			, UPDATED_DATE          ' + char(10);
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
			SET @mDqry = @mDQry + '			, ''-'' AS NEW_LT_DAY					' + char(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_TRANSPORT_MODE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_SHIPMENT_DATE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS EDIT_REMARKS ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS EDIT_MAIN ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS CHECK_NEED_YN ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, END_CUSTOMER AS END_CUSTOMER ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ELECTRODE_YN ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ELECTRODE_TYPE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ORIGIN_FROM_DIVISION_ID ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ORIGIN_TO_DIVISION_ID ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, CHANGE_REQ_NO AS CHANGE_REQ_NO ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, MODEL_USER AS MODEL_USER   ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, MTK_OWNER AS MTK_OWNER   ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, REQUESTOR AS REQUESTOR   ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS CHANGE_REASON_CODE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS CHANGE_REASON_DETAIL ' + CHAR(10);
			-- [C20211001-000241] Confirm 복사하여 신규 생성 기능 추가
			SET @mDqry = @mDQry + ' 		, ''-'' AS attribute10  ' + CHAR(10);			
			--* 2021/10/05   SHINMYUNGSU    열람 항목추가
			SET @mDqry = @mDQry + ' 		, attribute3 ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, attribute6 ' + CHAR(10);
			--*********************************************************************************************************
			SET @mDqry = @mDQry + ' 	FROM							' + char(10);
			SET @mDqry = @mDQry + ' 	(								' + char(10);
			SET @mDqry = @mDQry + '			SELECT TT0.DIVISION_ID										' + char(10);
			SET @mDqry = @mDQry + '				, TT0.ERP_SO_NO											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.SHIPMENT_STATUS									' + char(10);
			SET @mDqry = @mDQry + '				, TT0.ITEM_ID											' + char(10);
			SET @mDqry = @mDQry + '			    , TT0.NICK_NAME											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.ORIGIN_FROM_DIVISION_ID							' + char(10);
			SET @mDqry = @mDQry + '				, TT0.ORIGIN_TO_DIVISION_ID								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.FROM_SITE											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.FROM_SITE_DESCRIPTION								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.TO_SITE											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.TO_SITE_DESCRIPTION								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.PROJECT_CODE										' + char(10);
			SET @mDqry = @mDQry + '				, TT0.PROJECT_NAME										' + char(10);
			SET @mDqry = @mDQry + '				, TT0.REQUESTOR											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.SHIPMENT_CONFIRM_QTY								' + char(10);
			SET @mDqry = @mDQry + '				, CONVERT(VARCHAR(10),   CONVERT(DATETIME, TT0.YYYYMMDD,112), 23) AS SHIPMENT_DATE	' + char(10);
			SET @mDqry = @mDQry + '				, TT0.BOD_ID											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.INCOTERMS											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.TRANSPORT_MODE									' + char(10);
			SET @mDqry = @mDQry + '				, TT0.TO_SITE_SOLDTO_CODE								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.TO_SITE_SHIPTO_CODE								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.SOLDTO_DESCRIPTION								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.SHIPTO_DESCRIPTION								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.REMARKS2											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.REMARKS											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.CHANGE_REQ_NO										' + char(10);
			SET @mDqry = @mDQry + '				, TT0.REMARKS3											' + char(10);
			SET @mDqry = @mDQry + '				, CONVERT(VARCHAR(10),   CONVERT(DATETIME, TT0.ETD,112), 23) AS ETD	' + char(10);
			SET @mDqry = @mDQry + '				, CONVERT(VARCHAR(10),   CONVERT(DATETIME, TT0.ETA,112), 23) AS ETA	' + char(10);
			SET @mDqry = @mDQry + '				, TT0.EXPECTED_SHIPPING_DATE							' + char(10);
			SET @mDqry = @mDQry + '				, TT0.LT_DAY						AS LT_DAY			' + char(10);
			SET @mDqry = @mDQry + '				, TT0.UPDATED_BY					AS UPDATED_BY		' + char(10);
			SET @mDqry = @mDQry + '				, TT0.UPDATED_DATE					AS UPDATED_DATE		' + char(10);
			SET @mDqry = @mDQry + '				, TT0.CONFIRM_ID					AS CONFIRM_ID       ' + char(10);                                                                                                                                                                                                 
			SET @mDqry = @mDQry + '				, TT0.FCST_TYPE											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.END_CUSTOMER										' + char(10);
			SET @mDqry = @mDQry + '				, TT0.MTK_OWNER											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.MODEL_USER											' + char(10);
			--* 2021/10/05   SHINMYUNGSU    열람 항목추가
			SET @mDqry = @mDQry + ' 		    , ''-'' AS attribute3									' + CHAR(10);
			SET @mDqry = @mDQry + ' 		    , ''-'' AS attribute6									' + CHAR(10);
			--*********************************************************************************************************
			SET @mDqry = @mDQry + '			FROM SSP_ANL_SHIP_PLAN_ALL TT0 WITH(NOLOCK)					' + char(10);
			SET @mDqry = @mDQry + '			LEFT OUTER JOIN SSP_MST_MODEL_USER MU WITH(NOLOCK) 			' + char(10);
			SET @mDqry = @mDQry + '				ON MU.DIVISION_ID =TT0.ORIGIN_FROM_DIVISION_ID 			' + char(10);
			SET @mDqry = @mDQry + '				AND MU.FROM_SITE = TT0.FROM_SITE 						' + char(10);
			SET @mDqry = @mDQry + '				AND MU.ITEM_ID = TT0.ITEM_ID 							' + char(10);
			SET @mDqry = @mDQry + '				AND MU.VALID_YN = ''Y''									' + char(10);
			SET @mDqry = @mDQry + '			WHERE 1=1													' + char(10);
			SET @mDqry = @mDQry + '			  AND TT0.PLAN_START_YYYYMMDD = '+@p_plan_start_yyyymmdd +'	' + char(10);
			SET @mDqry = @mDQry + '			  AND TT0.DIVISION_ID		  = '+@p_division_id +'			' + char(10);
			SET @mDQry = @mDQry + '			  AND TT0.SHIPMENT_CONFIRM_QTY > 0							' + char(10);
			SET @mDQry = @mDQry + '			  AND TT0.OPERATION_GROUP <> ''E''							' + char(10);
			SET @mDqry = @mDQry + '			  AND TT0.YYYYMMDD >= '+ @p_from_yyyymmdd +' AND TT0.YYYYMMDD <= '+ @p_to_yyyymmdd +' ' + char(10);

			IF ( @v_division_id IS NOT NULL AND @v_division_id  != '')	SET @mDQry = @mDQry + ' AND  TT0.DIVISION_ID   IN ('+ @v_division_id +')'+char(10);  
			IF ( @v_item_id     IS NOT NULL AND @v_item_id		!= '')	SET @mDQry = @mDQry + ' AND  TT0.ITEM_ID       IN ('+ @v_item_id     +')'+char(10); 
			IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '')	SET @mDQry = @mDQry + ' AND  TT0.FROM_SITE     IN ('+ @v_from_site   +')'+char(10); 
			IF ( @v_requestor   IS NOT NULL AND @v_requestor    != '')
				BEGIN
					SET @mDQry = @mDQry + ' AND  TT0.REQUESTOR IN (																				' + char(10);
					SET @mDQry = @mDQry + '						  SELECT DISTINCT TT1.UserID FROM (												' + char(10);
					SET @mDQry = @mDQry + '						  (SELECT UserID FROM TB_FX_User with(nolock)									' + char(10);
					SET @mDQry = @mDQry + '						  WHERE 1 = 1																	' + char(10);
					SET @mDQry = @mDQry + '						  AND UserName		IN (' + @v_requestor + ')									' + char(10);
					SET @mDQry = @mDQry + '						  UNION ALL ' + char(10);
					SET @mDQry = @mDQry + '						  SELECT UserID FROM TB_FX_User with(nolock) ' + char(10) ;
					SET @mDQry = @mDQry + '						  WHERE 1 = 1 ' + char(10) ;
					SET @mDQry = @mDQry + '						  AND UserID		IN (' + @v_requestor + '))) TT1 ' +char(10);
					SET @mDQry = @mDQry + '						) ' + char(10);
				END 
			IF @p_search_yn = 'Y'
				BEGIN
					SET @mDQry = @mDQry + '		AND ((''' + @p_nonChk + ''' = ''Y'' AND 1 = 1 OR mu.USER_ID IN (SELECT CASE WHEN ''' + @p_myModelChk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END	' + char(10) ;
					SET @mDQry = @mDQry + '																		UNION																							' + char(10) ;
					SET @mDQry = @mDQry + '																		SELECT CASE WHEN ''' + @p_delegateeChk + ''' = ''Y'' THEN USER_ID ELSE ''X'' END				' + char(10) ;
					SET @mDQry = @mDQry + '																		FROM SSP_MST_DELEGATE with(nolock) WHERE VALID_YN = ''Y'' AND DELEGATEE_ID = ''' + @p_user_id + ''' GROUP BY USER_ID)				' + char(10) ;
					SET @mDQry = @mDQry + '		   											  OR mu.PART_LEADER = CASE WHEN ''' + @p_partLeaderChk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END		' + char(10) ;
					SET @mDQry = @mDQry + '		   											  OR mu.TEAM_LEADER = CASE WHEN ''' + @p_teamLeaderChk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END))	' + char(10) ;
				END	
	
			SET @mDqry = @mDQry + '		) AS  T0 ' + char(10);
			SET @mDqry = @mDQry + ' ) AS  AA ' + char(10);

			SET @mDqry = @mDQry + ' ORDER BY AA.division_id, AA.shipment_status, AA.shipment_date,  AA.item_id, AA.ERP_SO_NO DESC , AA.from_site, AA.to_site, AA.project_code, AA.fcst_type     ' + char(10);
		END

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
