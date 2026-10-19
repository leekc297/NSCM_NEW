
/*
 * Program ID   : SCP0007_GET_BOD
 * Description  : BOD
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/03/08   byunghunjung	            Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/04/20   PJS				            Division 82 JOIN조건 변경
 * 2018/04/25   byunghunjung	            우선순위 1번만 보여주는 로직 삭제
 * 2018/05/18   byunghunjung	            Route Count 결함 수정
 * 2018/05/28   byunghunjung	            81 사업부는 Mkt Fcst와 Project Route 등록된 모델 비교시 sales site 같은것만 조회되도록 수정
 * 2018/06/11   byunghunjung	            82 사업부 중복제거
 * 2018/06/26   ygkim			            전극 관련 수정 VMI = 'Y' 인건 DAP로 로우를 추가, VMI = 'N' -> VMI = 'Y'로 변경될 경우 DAP로 로우 추가
 * 2018/07/11   byunghunjung	            40,82 사업부는 Project code, sales site join조건에서 제외
 * 2018/07/12   ygkim			            DAP 가져오는 쿼리 수정
 * 2018/07/18   ygkim			            From Site -E 가 아닐 경우 VMI_YN 가져오는 쿼리 수정
								            From Site -E 일 경우 scm_mst_site_item_priority 테이블 조인 조건 수정
 * 2018/08/17   ygkim			            route_chk 컬럼 추가, FN_GET_COUNTRY_CITY_NAME 함수 제거(속도 개선)
 * 2018/08/21   ygkim			            From City, To City 가져오는 부분 수정
 * 2018/08/28   ygkim			            Input Status 'Required' 일 경우 From Site가 외주 이고 오른쪽 끝이 'A' 인건 제외
 * 2018/09/04   ygkim			            주석 제거 및 Input Status Completed 일 경우 등록된 BOD 안나오는 오류 수정
 * 2018/09/11   byunghunjung	            division All 조회 가능토록 수정
 * 2018/11/09	HWYOON			            MKT MEASURE VMI_YN 에 따라 MEASURE 조정
 * 2019/02/12	HWYOON			            [CSR ID:3907873] SSP Distribution route/BOD상 'L/T TYPE'컬럼 추가요청
 * 2020/08/31   KSW                         PJ20202001R    LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : 법인간 거래 Incoterms 동기화
 *                                          SSP용 Incoterms 컬럼 추가 <== SCP_MST_BOD.attribute1
 * 2021/05/10   khj79                       [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - BOD LT 1단계 개발(BEFORE_LEAD_TIME, AFTER_LEAD_TIME,REMARKS 추가)
 * 2021/06/10   khj79			            [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - BOD LT 2단계 개발(From , To 추가) , scp_mst_bod_v -> scp_mst_bod_n_v
 * 2021/10/05	khj79			            [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - W/S AS UI 변경
 * 2022/05/03	chaan			V1.1.1      GM_JV 적용 (81_UC 추가)
 * 2022/11/07   jahn1501		            PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MKT FCST 조건 변경
 * 2023/04/10   LWY				            PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 * 2023/06/28   vadabi3			            PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - @p_to_site  한글 께짐 조치
 * 2023/08/16	chaan			V1.1.2      PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Completed 조회시 키값이 중복되어 보이는 에러 수정
 *
   ex)
    exec dbo.SCP0007_GET_BOD @p_division_id ='81',@p_from_site='',@p_to_site='',@p_incoterms='',@p_trans_mode='',@p_input_status='R',@p_valid ='',@debug_mode ='T'
 */
 
CREATE PROCEDURE [dbo].[SCP0007_GET_BOD_NEW]
	  @p_division_id			NVARCHAR(MAX)
	, @p_from_site				NVARCHAR(MAX)
	, @p_to_site				NVARCHAR(MAX)
	, @p_incoterms				NVARCHAR(MAX)
	, @p_incoterms_ssp			NVARCHAR(MAX)
	, @p_trans_mode				NVARCHAR(MAX)
	, @p_input_status			NVARCHAR(100)
	, @p_valid					NVARCHAR(1)
	, @debug_mode				NVARCHAR(1)		= 'F'
AS


BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	
	SET NOCOUNT ON;
	
	DECLARE @qry NVARCHAR(MAX);

	DECLARE @arr_division_id nvarchar(max);
	DECLARE @arr_from_site nvarchar(max);
	DECLARE @arr_to_site nvarchar(max);
	DECLARE @arr_incoterms nvarchar(max);
	DECLARE @arr_incoterms_ssp nvarchar(max);
	DECLARE @arr_transmode nvarchar(max);

	SELECT @arr_division_id     = ISNULL(@arr_division_id + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_division_id,',')
	SELECT @arr_from_site		= ISNULL(@arr_from_site + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_from_site,',')
	SELECT @arr_to_site			= ISNULL(@arr_to_site + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_to_site,',')
	SELECT @arr_to_site			= ISNULL(@arr_to_site + ',N''' + token +'''', 'N'''+token+'''')     FROM dbo.String_Split(@p_to_site,',')
	SELECT @arr_incoterms		= ISNULL(@arr_incoterms + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_incoterms,',')
	SELECT @arr_incoterms_ssp   = ISNULL(@arr_incoterms_ssp + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_incoterms_ssp,',')
	SELECT @arr_transmode		= ISNULL(@arr_transmode + ',''' + token +'''', ''''+token+'''')     FROM dbo.String_Split(@p_trans_mode,',')

	PRINT ' @arr_division_id' +  @arr_division_id;

	SET @qry ='';

	SET @qry = @qry + ' SELECT DISTINCT					' + CHAR(10);
	SET @qry = @qry + '		   T.DIVISION_ID			' + CHAR(10);
	SET @qry = @qry + '		 , T.BOD_ID					' + CHAR(10);
	SET @qry = @qry + '		 , T.CUSTOMER				' + CHAR(10);
	SET @qry = @qry + '		 , T.INCOTERMS				' + CHAR(10);
	SET @qry = @qry + '		 , T.INCOTERMS_SSP 			' + CHAR(10);
	SET @qry = @qry + '		 , T.FROM_SITE_CODE 		' + CHAR(10);
	SET @qry = @qry + '		 , T.TO_SITE_CODE 			' + CHAR(10);
	SET @qry = @qry + '		 , T.FROM_COUNTRY 			' + CHAR(10);
	SET @qry = @qry + '		 , T.FROM_CITY 				' + CHAR(10);
	SET @qry = @qry + '		 , T.TO_COUNTRY				' + CHAR(10);
	SET @qry = @qry + '		 , T.TO_CITY				' + CHAR(10);
	SET @qry = @qry + '		 , T.TRANSPORT_MODE_CODE	' + CHAR(10);
	SET @qry = @qry + '		 , ISNULL(( SELECT TOP 1 C.SEGMENT2																	' + CHAR(10);
	SET @qry = @qry + '			   FROM DBO.SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)										' + CHAR(10);
	SET @qry = @qry + '			  WHERE  C.LOOKUP_TYPE         = ''TRANSPORT_MODE_CODE''									' + CHAR(10);
	SET @qry = @qry + '				AND ISNULL(C.SEGMENT1,'''') = ISNULL(T.transport_mode_code,'''') ),'''') AS transport_mode	' + CHAR(10);
	SET @qry = @qry + '		 , T.SAFETY_STOCK			' + CHAR(10);
	SET @qry = @qry + '		 , T.PRIORITY				' + CHAR(10);
	SET @qry = @qry + '		 , T.BOD_VALID				' + CHAR(10);
	SET @qry = @qry + '		 , T.ROUTE_VALID			' + CHAR(10);
	SET @qry = @qry + '		 , T.ROUTE_ID				' + CHAR(10);
	SET @qry = @qry + '		 , T.LT_TYPE 				' + CHAR(10);
	SET @qry = @qry + '		 , T.DAYS_MON 				' + CHAR(10);
	SET @qry = @qry + '		 , T.DAYS_TUE 				' + CHAR(10);
	SET @qry = @qry + '		 , T.DAYS_WED 				' + CHAR(10);
	SET @qry = @qry + '		 , T.DAYS_THU 				' + CHAR(10);
	SET @qry = @qry + '		 , T.DAYS_FRI 				' + CHAR(10);
	SET @qry = @qry + '		 , T.DAYS_SAT 				' + CHAR(10);
	SET @qry = @qry + '		 , T.DAYS_SUN 				' + CHAR(10);
	SET @qry = @qry + '		 , T.LEAD_TIME 				' + CHAR(10);
	SET @qry = @qry + '		 , T.DIS_TOTAL_LEAD_TIME	' + CHAR(10);
	SET @qry = @qry + '		 , T.FROM_YYYYMMDD 			' + CHAR(10);
	SET @qry = @qry + '		 , T.TO_YYYYMMDD			' + CHAR(10);
	SET @qry = @qry + '		 , T.BEFORE_LEAD_TIME		' + CHAR(10);
	SET @qry = @qry + '		 , T.AFTER_LEAD_TIME		' + CHAR(10);
	SET @qry = @qry + '		 , T.REMARKS				' + CHAR(10);
	SET @qry = @qry + '		 , T.CREATED_BY				' + CHAR(10);
	SET @qry = @qry + '		 , T.CREATION_DATE			' + CHAR(10);
	SET @qry = @qry + '		 , T.LAST_UPDATED_BY		' + CHAR(10);
	SET @qry = @qry + '		 , T.LAST_UPDATE_DATE		' + CHAR(10);
	SET @qry = @qry + '		 , T.ROUTE_CHK				' + CHAR(10);
	SET @qry = @qry + '		 , (SELECT COUNT(*) AS route_cnt FROM scp_mst_distribution_route WHERE transport_mode=t.transport_mode_code AND from_city =t.from_city  AND to_city =t.to_city ) AS route_cnt ' + CHAR(10); 
	SET @qry = @qry + '		 , CASE WHEN RIGHT(t.from_site_code,1) = ''E'' THEN (SELECT top 1 ISNULL(VMI_YN,''N'') FROM scm_mst_site WHERE scm_site_id = t.to_site_code )									' + CHAR(10); 
    SET @qry = @qry + '				ELSE (SELECT ISNULL(VMI_YN,''N'') FROM scm_mst_site WHERE division_id =t.division_id AND scm_site_id = t.to_site_code ) END vmi_yn										' + CHAR(10); 
	SET @qry = @qry + '  FROM (																																										' + CHAR(10); 
	SET @qry = @qry + '        SELECT																																								' + CHAR(10); 
	SET @qry = @qry + '  		 ma.division_id																																						' + CHAR(10); 
	SET @qry = @qry + '         ,bo.bod_id																																							' + CHAR(10); 
	--SET @qry = @qry + '  		,dbo.fn_get_division_name (ma.division_id) AS division_name																											' + CHAR(10); 
	SET @qry = @qry + '  		,ma.customer																																						' + CHAR(10); 
	SET @qry = @qry + '  		,ma.incoterms																																						' + CHAR(10); 
	SET @qry = @qry + '  		,ISNULL(ma.attribute1, ma.incoterms) AS incoterms_ssp																												' + CHAR(10);  --<< KSW :: SSP용 Incoterms 컬럼 추가
	SET @qry = @qry + '  		,ma.from_site AS from_site_code																																		' + CHAR(10); 
	--SET @qry = @qry + '  		,ISNULL(dbo.fn_get_scm_site_description (ma.division_id, ma.from_site) , ''-'') AS from_site_name																	' + CHAR(10); 
	SET @qry = @qry + '  		,ma.to_site AS to_site_code																																			' + CHAR(10); 
	--SET @qry = @qry + '  		,ISNULL(dbo.fn_get_scm_site_description (ma.division_id, ma.to_site) , ''-'') AS to_site_name																		' + CHAR(10); 
	SET @qry = @qry + ' 		,ma.from_country																																					' + CHAR(10); 
	SET @qry = @qry + ' 		,ma.from_city																																						' + CHAR(10); 
	SET @qry = @qry + ' 		,ma.to_country																																						' + CHAR(10); 
	SET @qry = @qry + ' 		,ma.to_city																																							' + CHAR(10); 
	SET @qry = @qry + ' 		,ma.transport_mode as transport_mode_code																															' + CHAR(10); 
	--SET @qry = @qry + '         ,dbo.FN_GET_LOOKUP_CODE_DESC (''TRANSPORT_MODE_CODE'' , ma.transport_mode ) AS transport_mode																		' + CHAR(10); 
	SET @qry = @qry + '  		,bo.safety_stock, bo.priority																																		' + CHAR(10); 
	SET @qry = @qry + '  		,bo.valid_yn as bod_valid																																			' + CHAR(10); 
	SET @qry = @qry + '  		,ro.valid_yn as route_valid																																			' + CHAR(10); 
	SET @qry = @qry + '  		,ro.route_id																																						' + CHAR(10); 
	SET @qry = @qry + '  		,ro.lt_type																																							' + CHAR(10); 
	SET @qry = @qry + '  		,ro.days_mon																																						' + CHAR(10); 
	SET @qry = @qry + '  		,ro.days_tue																																						' + CHAR(10); 
	SET @qry = @qry + '  		,ro.days_wed																																						' + CHAR(10); 
	SET @qry = @qry + '  		,ro.days_thu																																						' + CHAR(10); 
	SET @qry = @qry + '  		,ro.days_fri																																						' + CHAR(10); 
	SET @qry = @qry + '  		,ro.days_sat																																						' + CHAR(10); 
	SET @qry = @qry + '  		,ro.days_sun																																						' + CHAR(10); 
	SET @qry = @qry + '  		,(select v.lt_total from scp_mst_bod_n_v v where v.division_id = ma.division_id  and v.BOD_ID = bo.bod_id ) AS lead_time											' + CHAR(10); --PJ20209642 : BOD LT 1단계 개발 , 2단계 (scp_mst_bod_v -> scp_mst_bod_n_v )
	SET @qry = @qry + '  		,ISNULL(BO.LT_DEPARTURE_INLAND,0)+ISNULL(BO.LT_WAIT_SHIPPING,0)+ISNULL(BO.LT_VOYAGE,0)+ISNULL(BO.LT_LAY_OFF_CLEARANCE,0)+ISNULL(BO.LT_ARRIVAL_INLAND,0) AS DIS_TOTAL_LEAD_TIME		' + CHAR(10); --PJ20209642 : BOD LT 1단계 개발
	SET @qry = @qry + '  		,convert(date, BO.ATTRIBUTE2,112)		AS FROM_YYYYMMDD																											' + CHAR(10); --PJ20209642 : BOD LT 2단계 개발
	SET @qry = @qry + '  		,convert(date, BO.ATTRIBUTE3,112)		AS TO_YYYYMMDD																												' + CHAR(10); --PJ20209642 : BOD LT 2단계 개발
	SET @qry = @qry + '  		,ISNULL(BO.ATTRIBUTE4,0)				AS BEFORE_LEAD_TIME																											' + CHAR(10); --PJ20209642 : BOD LT 1단계 개발
	SET @qry = @qry + '  		,ISNULL(BO.ATTRIBUTE5,0)				AS AFTER_LEAD_TIME																											' + CHAR(10); --PJ20209642 : BOD LT 1단계 개발
	SET @qry = @qry + '  		,BO.ATTRIBUTE6							AS REMARKS																													' + CHAR(10); --PJ20209642 : BOD LT 1단계 개발
	SET @qry = @qry + '  		,ISNULL(bo.created_by,ma.created_by)  created_by																													' + CHAR(10); 
	SET @qry = @qry + '  		,ISNULL(bo.creation_date,ma.creation_date)  creation_date																											' + CHAR(10); 
	SET @qry = @qry + '  		,ISNULL(bo.last_updated_by,ma.last_updated_by)  last_updated_by																										' + CHAR(10); 
	SET @qry = @qry + '  		,ISNULL(bo.last_update_date,ma.last_update_date)  last_update_date																									' + CHAR(10); 
	SET @qry = @qry + '  		,CASE WHEN (ro.FROM_CITY = ma.from_city) AND (ro.TO_CITY = ma.to_city) THEN ''Y'' ELSE ''N'' END route_chk															' + CHAR(10); 	
	SET @qry = @qry + '	        /* [ma] table - division_id ~ transport_mode_code -> 4 Steps */																										' + CHAR(10); 
	SET @qry = @qry + '  		FROM  (																																								' + CHAR(10); 
	SET @qry = @qry + '                /* 1-1. # Div = 81, BOD Requied - From Site : Project route , To Site : Mkt FCST project_code, sales_site_id Join */											' + CHAR(10); 
	SET @qry = @qry + '  				SELECT t.division_id, t.to_site, t.customer, t.incoterms, t.from_site, t.from_country, t.from_city, t.to_country, t.to_city,u.transport_mode				' + CHAR(10); 
	SET @qry = @qry + ' 					  ,null created_by, null creation_date, null last_updated_by, null last_update_date, NULL AS attribute1													' + CHAR(10); 
	-- BOD 2단계 개발
	SET @qry = @qry + ' 					  ,''-'' AS BOD_ID																																		' + CHAR(10); 
	SET @qry = @qry + ' 				FROM																																						' + CHAR(10); 
	SET @qry = @qry + '					(																																							' + CHAR(10); 
	SET @qry = @qry + ' 					SELECT DISTINCT de.division_id, de.scm_site_id as to_site,  de.customer, de.Incoterms, si.scm_site_id AS from_site 										' + CHAR(10); 
	SET @qry = @qry + ' 						, f_ci.country AS from_country																														' + CHAR(10); 
	SET @qry = @qry + ' 						, f_ci.city	   AS from_city																															' + CHAR(10); 
	SET @qry = @qry + ' 						, t_ci.country AS to_country																														' + CHAR(10); 
	SET @qry = @qry + ' 						, t_ci.city	   AS to_city																															' + CHAR(10); 
	SET @qry = @qry + ' 					  FROM																																					' + CHAR(10); 
	SET @qry = @qry + '  						( SELECT  f.division_id, f.scm_site_id, m.end_customer AS customer, f.incoterms, f.project_code, f.item_id											' + CHAR(10); 
	SET @qry = @qry + '  							FROM  dm_pln_mkt_fcst f																															' + CHAR(10); 
	SET @qry = @qry + '  							JOIN  scm_mst_site m ON f.division_id = m.division_id AND f.scm_site_id = m.scm_site_id	AND m.valid_yn = ''Y''      							' + CHAR(10); 
	--2021/10/05 : W/S AS
	--SET @qry = @qry + '  							LEFT JOIN scm_mst_site s ON s.DIVISION_ID=F.DIVISION_ID AND s.SCM_SITE_ID=F.SCM_SITE_ID AND s.VMI_YN=''Y''										' + CHAR(10); 
	SET @qry = @qry + '  							LEFT JOIN scm_mst_site s ON s.DIVISION_ID=F.DIVISION_ID AND s.SCM_SITE_ID=F.SCM_SITE_ID AND (s.VMI_YN=''Y'' OR ( s.SITE_TYPE = ''SALES'' AND s.OPERATION_GROUP = ''W'')) ' + CHAR(10); 
	SET @qry = @qry + '  							WHERE 1=1																																		' + CHAR(10); 
	--SET @qry = @qry + '     						 AND  f.division_id IN ( ''81'', ''81_UC'' )																									' + char(10);
	SET @qry = @qry + '     						 AND  f.division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV(''81''))																' + char(10); -- div_commonization
	--SET @qry = @qry + '  							 AND  measure       = ''MKT_FCST''																												' + CHAR(10); 
	--2021/10/05 : W/S AS
	--SET @qry = @qry + '  							 AND  F.MEASURE = IIF( ISNULL(s.vmi_yn, ''N'') = ''Y'', ''VMI_In_Req'',  ''MKT_FCST'')															' + CHAR(10); 
	--2022/11/07
	--SET @qry = @qry + '  							 AND  F.MEASURE = IIF(ISNULL(s.OPERATION_GROUP,'''') = ''W'', ''AS_In_Req'', IIF(s.vmi_yn = ''Y'', ''VMI_In_Req'',  ''MKT_FCST''))				' + CHAR(10); 
	SET @qry = @qry + '  							 AND  F.MEASURE = CASE WHEN ISNULL(S.OPERATION_GROUP, '''') = ''W'' THEN ''AS_In_Req'' WHEN S.vmi_yn = ''Y'' THEN ''VMI_In_Req'' WHEN ISNULL(f.attribute10, '''') = '''' THEN ''MKT_FCST'' END	' + CHAR(10);
	SET @qry = @qry + '  						) de																																				' + CHAR(10); 
	SET @qry = @qry + '  						LEFT OUTER JOIN	(SELECT a.division_id, a.scm_site_id, b.item_id, b.project_code, c.priority ,c.sales_site_id, right(plant_site_id,1) plant_type		' + CHAR(10); 
	SET @qry = @qry + '  										   FROM  scm_mst_site a																												' + CHAR(10); 
	SET @qry = @qry + '  											   , scm_mst_site_item b																										' + CHAR(10); 
	SET @qry = @qry + '  											   , scm_mst_site_item_priority c																								' + CHAR(10); 
	SET @qry = @qry + '  										  WHERE    a.division_id  = b.division_id																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.scm_site_id  = b.scm_site_id																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.division_id  = c.division_id																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.scm_site_id  = c.plant_site_id																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.project_code = c.project_code																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.item_id      = c.item_id																								' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.valid_yn     = ''Y''																									' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.valid_yn     = ''Y''																									' + CHAR(10); 
	SET @qry = @qry + '  										    AND    c.valid_yn     = ''Y''																									' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.site_type    = ''PLANT''																								' + CHAR(10); 
	--SET @qry = @qry + '  										    AND    a.division_id  IN ( ''81'', ''81_UC'' )																					' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.division_id  IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV(''81''))												' + CHAR(10);  -- div_commonization
	SET @qry = @qry + '  									   ) si ON  de.division_id  = si.division_id																							' + CHAR(10); 
	SET @qry = @qry + '  										AND ((si.plant_type != ''E'' AND de.project_code = si.project_code  AND de.SCM_SITE_ID  = si.sales_site_id)							' + CHAR(10); 
	SET @qry = @qry + '  											or (si.plant_type = ''E''))																										' + CHAR(10); 
	SET @qry = @qry + '  										    AND de.item_id      = si.item_id																								' + CHAR(10); 
	SET @qry = @qry + '  						LEFT OUTER JOIN (SELECT	division_id, scm_site_id, country, city																						' + CHAR(10); 
	SET @qry = @qry + '  									      FROM scm_mst_site A where a.valid_yn = ''Y'') f_ci ON de.division_id = f_ci.division_id AND si.scm_site_id = f_ci.scm_site_id		' + CHAR(10); 	    
	SET @qry = @qry + '  						LEFT OUTER JOIN (SELECT division_id, scm_site_id,country,city																						' + CHAR(10); 
	SET @qry = @qry + '  									      FROM scm_mst_site A WHERE a.valid_yn = ''Y'') t_ci ON de.division_id = t_ci.division_id AND de.scm_site_id = t_ci.scm_site_id		' + CHAR(10); 
	SET @qry = @qry + ' 			    ) t LEFT JOIN ( SELECT DISTINCT from_country, from_city, to_country, to_city, transport_mode																' + CHAR(10); 
	SET @qry = @qry + ' 								  FROM scp_mst_distribution_route																											' + CHAR(10); 
	SET @qry = @qry + ' 							     WHERE VALID_YN =''Y''																														' + CHAR(10); 
	SET @qry = @qry + ' 							  ) u ON t.from_country = u.from_country																										' + CHAR(10); 
	SET @qry = @qry + ' 							     AND t.from_city    = u.from_city																											' + CHAR(10); 
	SET @qry = @qry + ' 							     AND t.to_country   = u.to_country																											' + CHAR(10); 
	SET @qry = @qry + ' 					 		     AND t.to_city      = u.to_city																												' + CHAR(10); 
	SET @qry = @qry + '					UNION ALL																																					' + CHAR(10);
	SET @qry = @qry + '                /* 1-2. # Div = 40,82,  BOD Requied - From Site : Project route , To Site : Mkt FCST project_code, sales_site_id NOT Join */									' + CHAR(10); 
	SET @qry = @qry + '  				SELECT t.division_id, t.to_site, t.customer, t.incoterms, t.from_site, t.from_country, t.from_city, t.to_country, t.to_city,u.transport_mode				' + CHAR(10); 
	SET @qry = @qry + ' 					  ,null created_by, null creation_date, null last_updated_by, null last_update_date, NULL AS attribute1													' + CHAR(10); 
	-- BOD 2단계 개발
	SET @qry = @qry + ' 					  ,''-'' AS BOD_ID																																		' + CHAR(10); 
	SET @qry = @qry + ' 				FROM																																						' + CHAR(10); 
	SET @qry = @qry + '					(																																							' + CHAR(10); 
	SET @qry = @qry + ' 					SELECT DISTINCT de.division_id, de.scm_site_id as to_site,  de.customer, de.Incoterms, si.scm_site_id AS from_site 										' + CHAR(10); 
	SET @qry = @qry + ' 						, f_ci.country AS from_country																														' + CHAR(10); 
	SET @qry = @qry + ' 						, f_ci.city	   AS from_city																															' + CHAR(10); 
	SET @qry = @qry + ' 						, t_ci.country AS to_country																														' + CHAR(10); 
	SET @qry = @qry + ' 						, t_ci.city	   AS to_city																															' + CHAR(10); 
	SET @qry = @qry + ' 					  FROM																																					' + CHAR(10); 
	SET @qry = @qry + '  						( SELECT  f.division_id, f.scm_site_id, m.end_customer AS customer, f.incoterms, f.project_code, f.item_id											' + CHAR(10); 
	SET @qry = @qry + '  							FROM  dm_pln_mkt_fcst f																															' + CHAR(10); 
	SET @qry = @qry + '  							JOIN  scm_mst_site m ON f.division_id = m.division_id AND f.scm_site_id = m.scm_site_id	AND m.valid_yn = ''Y''									' + CHAR(10); 
	--2021/10/05 : W/S AS
	--SET @qry = @qry + '  							LEFT JOIN scm_mst_site s ON s.DIVISION_ID=F.DIVISION_ID AND s.SCM_SITE_ID=F.SCM_SITE_ID AND s.VMI_YN=''Y''										' + CHAR(10); 
	SET @qry = @qry + '  							LEFT JOIN scm_mst_site s ON s.DIVISION_ID=F.DIVISION_ID AND s.SCM_SITE_ID=F.SCM_SITE_ID AND (s.VMI_YN=''Y'' OR ( s.SITE_TYPE = ''SALES'' AND s.OPERATION_GROUP = ''W'')) ' + CHAR(10); 
	SET @qry = @qry + '  							WHERE 1=1																																		' + CHAR(10); 
	SET @qry = @qry + '     						 AND  f.division_id IN ( ''40'',''82'')																											' + char(10);
	--SET @qry = @qry + '     						 AND  f.division_id IN ( ''40'',''82'',''42'',''44'')																											' + char(10);
	--SET @qry = @qry + '  							 AND  measure       = ''MKT_FCST''																												' + CHAR(10); 
	--2021/10/05 : W/S AS
	--SET @qry = @qry + '  							 AND  F.MEASURE = IIF( ISNULL(s.vmi_yn, ''N'') = ''Y'', ''VMI_In_Req'',  ''MKT_FCST'')															' + CHAR(10); 
	--2022/11/07
	--SET @qry = @qry + '  							 AND  F.MEASURE = IIF(ISNULL(s.OPERATION_GROUP,'''') = ''W'', ''AS_In_Req'', IIF(s.vmi_yn = ''Y'', ''VMI_In_Req'',  ''MKT_FCST''))				' + CHAR(10); 
	SET @qry = @qry + '  							 AND  F.MEASURE = CASE WHEN ISNULL(S.OPERATION_GROUP, '''') = ''W'' THEN ''AS_In_Req'' WHEN S.vmi_yn = ''Y'' THEN ''VMI_In_Req'' WHEN ISNULL(f.attribute10, '''') = '''' THEN ''MKT_FCST'' END	' + CHAR(10);
	SET @qry = @qry + '  						) de																																				' + CHAR(10); 
	SET @qry = @qry + '  						LEFT OUTER JOIN	(SELECT a.division_id, a.scm_site_id, b.item_id, b.project_code, c.priority ,c.sales_site_id, right(plant_site_id,1) plant_type		' + CHAR(10); 
	SET @qry = @qry + '  										   FROM  scm_mst_site a																												' + CHAR(10); 
	SET @qry = @qry + '  											   , scm_mst_site_item b																										' + CHAR(10); 
	SET @qry = @qry + '  											   , scm_mst_site_item_priority c																								' + CHAR(10); 
	SET @qry = @qry + '  										  WHERE    a.division_id  = b.division_id																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.scm_site_id  = b.scm_site_id																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.division_id  = c.division_id																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.scm_site_id  = c.plant_site_id																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.project_code = c.project_code																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.item_id      = c.item_id																								' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.valid_yn     = ''Y''																									' + CHAR(10); 
	SET @qry = @qry + '  										 AND    b.valid_yn     = ''Y''																									' + CHAR(10); 
	SET @qry = @qry + '  										    AND    c.valid_yn     = ''Y''																									' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.site_type    = ''PLANT''																								' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.division_id  IN ( ''40'',''82'')																						' + CHAR(10); 
	--SET @qry = @qry + '  										    AND    a.division_id  IN ( ''40'',''82'',''42'',''44'')																						' + CHAR(10); 
	SET @qry = @qry + '  									   ) si ON  de.division_id  = si.division_id																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND de.item_id      = si.item_id																								' + CHAR(10); 
	SET @qry = @qry + '  						LEFT OUTER JOIN (SELECT	division_id, scm_site_id, country, city																						' + CHAR(10); 
	SET @qry = @qry + '  									      FROM scm_mst_site A where a.valid_yn = ''Y'') f_ci ON de.division_id = f_ci.division_id AND si.scm_site_id = f_ci.scm_site_id		' + CHAR(10); 	    
	SET @qry = @qry + '  						LEFT OUTER JOIN (SELECT division_id, scm_site_id,country,city																						' + CHAR(10); 
	SET @qry = @qry + '  									      FROM scm_mst_site A WHERE a.valid_yn = ''Y'') t_ci ON de.division_id = t_ci.division_id AND de.scm_site_id = t_ci.scm_site_id		' + CHAR(10); 
	SET @qry = @qry + ' 			    ) t LEFT JOIN ( SELECT DISTINCT from_country, from_city, to_country, to_city, transport_mode																' + CHAR(10); 
	SET @qry = @qry + ' 								  FROM scp_mst_distribution_route																											' + CHAR(10); 
	SET @qry = @qry + ' 							     WHERE VALID_YN =''Y''																														' + CHAR(10); 
	SET @qry = @qry + ' 							  ) u ON t.from_country = u.from_country																										' + CHAR(10); 
	SET @qry = @qry + ' 							     AND t.from_city    = u.from_city																											' + CHAR(10); 
	SET @qry = @qry + ' 							     AND t.to_country   = u.to_country																											' + CHAR(10); 
	SET @qry = @qry + ' 					 		     AND t.to_city      = u.to_city																												' + CHAR(10); 
	SET @qry = @qry + '					UNION ALL																																					' + CHAR(10);
	SET @qry = @qry + '					/* 2-1. # Div = 81, BOD Requied - VMI = Y and scp_mst_bod not exists DAP raw insert.project_code, sales_site_id Join */										' + CHAR(10); 
	SET @qry = @qry + '                 SELECT a.division_id, a.to_site, a.customer, ''DAP'' incoterms, a.from_site, a.from_country, a.from_city, a.to_country, a.to_city,a.transport_mode			' + CHAR(10); 
 	SET @qry = @qry + '	                      ,created_by, creation_date, last_updated_by, last_update_date, NULL AS attribute1																		' + CHAR(10); 
	-- BOD 2단계 개발
	SET @qry = @qry + ' 					  ,''-'' AS BOD_ID																																		' + CHAR(10); 
	SET @qry = @qry + '                 FROM(																																						' + CHAR(10); 
	SET @qry = @qry + '  					SELECT t.division_id, t.to_site, t.customer, t.incoterms, t.from_site, t.from_country, t.from_city, t.to_country, t.to_city,u.transport_mode			' + CHAR(10); 
	SET @qry = @qry + ' 						,null created_by, null creation_date, null last_updated_by, null last_update_date																	' + CHAR(10); 
	SET @qry = @qry + ' 					FROM(																																					' + CHAR(10); 
	SET @qry = @qry + ' 						SELECT DISTINCT de.division_id, de.scm_site_id as to_site,  de.customer, de.Incoterms, si.scm_site_id AS from_site 									' + CHAR(10); 
	SET @qry = @qry + ' 							, f_ci.country  AS from_country																													' + CHAR(10); 
	SET @qry = @qry + ' 							, f_ci.city		AS from_city																													' + CHAR(10); 
	SET @qry = @qry + ' 							, t_ci.country	AS to_country																													' + CHAR(10); 
	SET @qry = @qry + ' 							, t_ci.city		AS to_city																														' + CHAR(10); 
	SET @qry = @qry + ' 						FROM																																				' + CHAR(10); 
	SET @qry = @qry + '  						( SELECT  f.division_id, f.scm_site_id, m.end_customer AS customer, f.incoterms, f.project_code, f.item_id											' + CHAR(10); 
	SET @qry = @qry + '  							FROM dm_pln_mkt_fcst f																															' + CHAR(10); 
	--2021/10/05 : W/S AS
	--SET @qry = @qry + '  							JOIN scm_mst_site m ON f.division_id = m.division_id AND f.scm_site_id = m.scm_site_id AND m.vmi_yn = ''Y''										' + CHAR(10); 
	--SET @qry = @qry + '  							LEFT JOIN scm_mst_site s ON s.DIVISION_ID=F.DIVISION_ID AND s.SCM_SITE_ID=F.SCM_SITE_ID AND s.VMI_YN=''Y''										' + CHAR(10); 
	SET @qry = @qry + '  							JOIN scm_mst_site m ON f.division_id = m.division_id AND f.scm_site_id = m.scm_site_id	AND m.valid_yn = ''Y'' AND (m.VMI_YN=''Y'' OR ( m.SITE_TYPE = ''SALES'' AND m.OPERATION_GROUP = ''W''))	' + CHAR(10); 
	SET @qry = @qry + '  							LEFT JOIN scm_mst_site s ON s.DIVISION_ID=F.DIVISION_ID AND s.SCM_SITE_ID=F.SCM_SITE_ID AND (s.VMI_YN=''Y'' OR ( s.SITE_TYPE = ''SALES'' AND s.OPERATION_GROUP = ''W''))	' + CHAR(10); 
	SET @qry = @qry + '  							WHERE  1=1																																		' + CHAR(10); 
	--SET @qry = @qry + '     						  AND  f.division_id IN ( ''81'', ''81_UC''  )																									' + char(10);
	SET @qry = @qry + '     						  AND  f.division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV(''81''))																' + char(10); --div_commonization
	--SET @qry = @qry + '  							  AND  measure     = ''MKT_FCST''																												' + CHAR(10); 
	--2021/10/05 : W/S AS
	--SET @qry = @qry + '  							  AND  F.MEASURE = IIF( ISNULL(s.vmi_yn, ''N'') = ''Y'', ''VMI_In_Req'',  ''MKT_FCST'')															' + CHAR(10); 
	--2022/11/07
	--SET @qry = @qry + '  							 AND  F.MEASURE = IIF(ISNULL(s.OPERATION_GROUP,'''') = ''W'', ''AS_In_Req'', IIF(s.vmi_yn = ''Y'', ''VMI_In_Req'',''MKT_FCST''))					' + CHAR(10); 
	SET @qry = @qry + '  							 AND  F.MEASURE = CASE WHEN ISNULL(S.OPERATION_GROUP, '''') = ''W'' THEN ''AS_In_Req'' WHEN S.vmi_yn = ''Y'' THEN ''VMI_In_Req'' WHEN ISNULL(f.attribute10, '''') = '''' THEN ''MKT_FCST'' END	' + CHAR(10);
	SET @qry = @qry + '  						) de																																				' + CHAR(10); 
	SET @qry = @qry + '  						LEFT OUTER JOIN	(SELECT a.division_id, a.scm_site_id, b.item_id, b.project_code, c.priority ,c.sales_site_id, right(plant_site_id,1) plant_type		' + CHAR(10); 
	SET @qry = @qry + '  										   FROM   scm_mst_site a																											' + CHAR(10); 
	SET @qry = @qry + '  											    , scm_mst_site_item b																										' + CHAR(10); 
	SET @qry = @qry + '  											    , scm_mst_site_item_priority c																								' + CHAR(10); 
	SET @qry = @qry + '  									      WHERE    a.division_id  = b.division_id																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.scm_site_id  = b.scm_site_id																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.division_id  = c.division_id																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.scm_site_id  = c.PLANT_SITE_ID																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.project_code = c.project_code																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.item_id      = c.item_id																								' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.valid_yn     = ''Y''																									' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.valid_yn     = ''Y''																									' + CHAR(10); 
	SET @qry = @qry + '  										    AND    c.valid_yn     = ''Y''																									' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.site_type    = ''PLANT''																								' + CHAR(10); 
	--SET @qry = @qry + '  										    AND    a.division_id  IN ( ''81'', ''81_UC'' )																					' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.division_id  IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV(''81''))												' + CHAR(10); --div_commonization
	SET @qry = @qry + '  						                 ) si ON  de.division_id  = si.division_id																							' + CHAR(10); 
	SET @qry = @qry + '  											 AND ((si.plant_type  != ''E'' AND de.project_code = si.project_code  AND de.scm_site_id  = si.sales_site_id)					' + CHAR(10); 
	SET @qry = @qry + '  							                     OR (si.plant_type = ''E''))																								' + CHAR(10); 
	SET @qry = @qry + '  							                 AND de.item_id      = si.item_id																								' + CHAR(10); 
	SET @qry = @qry + '  						LEFT OUTER JOIN (SELECT	division_id, scm_site_id,country,city																						' + CHAR(10); 
	SET @qry = @qry + '  									     FROM scm_mst_site A WHERE a.valid_yn = ''Y'') f_ci ON de.division_id = f_ci.division_id AND si.scm_site_id = f_ci.scm_site_id		' + CHAR(10); 	    
	SET @qry = @qry + '  						LEFT OUTER JOIN (SELECT division_id, scm_site_id,country,city																						' + CHAR(10); 
	SET @qry = @qry + '  									     FROM scm_mst_site A WHERE a.valid_yn = ''Y'') t_ci ON de.division_id = t_ci.division_id AND de.scm_site_id = t_ci.scm_site_id		' + CHAR(10); 
	SET @qry = @qry + ' 			        ) t																																						' + CHAR(10); 
	SET @qry = @qry + ' 		        LEFT JOIN ( SELECT DISTINCT from_country, from_city, to_country, to_city, transport_mode																	' + CHAR(10); 
	SET @qry = @qry + ' 		 		              FROM scp_mst_distribution_route																												' + CHAR(10); 
	SET @qry = @qry + ' 					         WHERE valid_yn =''Y''																															' + CHAR(10); 
	SET @qry = @qry + ' 					      ) u ON t.from_country = u.from_country																											' + CHAR(10); 
	SET @qry = @qry + ' 						     AND t.from_city    = u.from_city																												' + CHAR(10); 
	SET @qry = @qry + ' 						     AND t.to_country   = u.to_country																												' + CHAR(10); 
	SET @qry = @qry + ' 						     AND t.to_city      = u.to_city																													' + CHAR(10); 
	SET @qry = @qry + '			        ) a																																							' + CHAR(10); 
	SET @qry = @qry + ' 			    WHERE NOT EXISTS  ( SELECT 1																																' + CHAR(10); 
	SET @qry = @qry + '									      FROM																																	' + CHAR(10); 
	SET @qry = @qry + '										     (SELECT DISTINCT a.division_id, a.from_site, a.to_site, b.transport_mode 															' + CHAR(10); 
	SET @qry = @qry + '                  					        FROM scp_mst_bod a																												' + CHAR(10);
	-- BOD 2단계 개발 : scp_mst_bod_v -> scp_mst_bod_n_v
	--SET @qry = @qry + '                  					       INNER JOIN scp_mst_bod_v b  ON a.division_id = b.division_id																		' + CHAR(10);
	SET @qry = @qry + '                  					       INNER JOIN scp_mst_bod_n_v b  ON a.division_id = b.division_id																	' + CHAR(10);
	SET @qry = @qry + ' 																      AND a.bod_id = b.bod_id																				' + CHAR(10);
	SET @qry = @qry + ' 																      AND a.from_site = b.from_site																			' + CHAR(10);
	SET @qry = @qry + ' 																      AND a.to_site = b.to_site																				' + CHAR(10);
	SET @qry = @qry + ' 																      AND a.incoterms = b.incoterms																			' + CHAR(10); 
	SET @qry = @qry + '                  				            WHERE a.incoterms = ''DAP''																										' + CHAR(10); 
	SET @qry = @qry + '                  			              ) b																																' + CHAR(10); 
	SET @qry = @qry + ' 			                        WHERE a.division_id    =  b.division_id																									' + CHAR(10); 
	SET @qry = @qry + ' 			                          AND a.from_site      =  b.from_site																									' + CHAR(10); 
	SET @qry = @qry + ' 			                          AND a.to_site        =  b.to_site																										' + CHAR(10); 
	SET @qry = @qry + ' 			                          AND a.transport_mode =  b.transport_mode																								' + CHAR(10); 
	SET @qry = @qry + '                                    )																																		' + CHAR(10); 
	SET @qry = @qry + '				   UNION ALL																																					' + CHAR(10);
	SET @qry = @qry + '					/* 2-2. # Div = 40,82, BOD Requied - VMI = Y and scp_mst_bod not exists DAP raw insert. project_code, sales_site_id NOT Join */								' + CHAR(10); 
	SET @qry = @qry + '                 SELECT a.division_id, a.to_site, a.customer, ''DAP'' incoterms, a.from_site, a.from_country, a.from_city, a.to_country, a.to_city,a.transport_mode			' + CHAR(10); 
 	SET @qry = @qry + '	                      ,created_by, creation_date, last_updated_by, last_update_date, NULL AS attribute1																		' + CHAR(10); 
	-- BOD 2단계 개발
	SET @qry = @qry + ' 					  ,''-'' AS BOD_ID																																		' + CHAR(10); 
	SET @qry = @qry + '                 FROM(																																						' + CHAR(10); 
	SET @qry = @qry + '  					SELECT t.division_id, t.to_site, t.customer, t.incoterms, t.from_site, t.from_country, t.from_city, t.to_country, t.to_city,u.transport_mode			' + CHAR(10); 
	SET @qry = @qry + ' 						,null created_by, null creation_date, null last_updated_by, null last_update_date																	' + CHAR(10); 
	SET @qry = @qry + ' 					FROM(																																					' + CHAR(10); 
	SET @qry = @qry + ' 						SELECT DISTINCT de.division_id, de.scm_site_id as to_site,  de.customer, de.Incoterms, si.scm_site_id AS from_site 									' + CHAR(10); 
	SET @qry = @qry + ' 							, f_ci.country  AS from_country																													' + CHAR(10); 
	SET @qry = @qry + ' 							, f_ci.city		AS from_city																													' + CHAR(10); 
	SET @qry = @qry + ' 							, t_ci.country	AS to_country																													' + CHAR(10); 
	SET @qry = @qry + ' 							, t_ci.city		AS to_city																														' + CHAR(10); 
	SET @qry = @qry + ' 						FROM																																				' + CHAR(10); 
	SET @qry = @qry + '  						( SELECT  f.division_id, f.scm_site_id, m.end_customer AS customer, f.incoterms, f.project_code, f.item_id											' + CHAR(10); 
	SET @qry = @qry + '  							FROM dm_pln_mkt_fcst f																															' + CHAR(10); 
	--2021/10/05 : W/S AS
	--SET @qry = @qry + '  							JOIN scm_mst_site m ON f.division_id = m.division_id AND f.scm_site_id = m.scm_site_id AND m.vmi_yn = ''Y''										' + CHAR(10); 
	--SET @qry = @qry + '  							LEFT JOIN scm_mst_site s ON s.DIVISION_ID=F.DIVISION_ID AND s.SCM_SITE_ID=F.SCM_SITE_ID AND s.VMI_YN=''Y''										' + CHAR(10); 
	SET @qry = @qry + '  							JOIN scm_mst_site m ON f.division_id = m.division_id AND f.scm_site_id = m.scm_site_id	AND m.valid_yn = ''Y'' AND (m.VMI_YN=''Y'' OR ( m.SITE_TYPE = ''SALES'' AND m.OPERATION_GROUP = ''W''))	' + CHAR(10); 
	SET @qry = @qry + '  							LEFT JOIN scm_mst_site s ON s.DIVISION_ID=F.DIVISION_ID AND s.SCM_SITE_ID=F.SCM_SITE_ID AND (s.VMI_YN=''Y'' OR ( s.SITE_TYPE = ''SALES'' AND s.OPERATION_GROUP = ''W''))	' + CHAR(10); 
	SET @qry = @qry + '  							WHERE  1=1																																		' + CHAR(10); 
	SET @qry = @qry + '     						  AND  f.division_id IN ( ''40'',''82'')																										' + char(10);
	--SET @qry = @qry + '     						  AND  f.division_id IN ( ''40'',''82'',''42'',''44'')																										' + char(10);
	--SET @qry = @qry + '  							  AND  measure     = ''MKT_FCST''																												' + CHAR(10); 
	--2021/10/05 : W/S AS
	--SET @qry = @qry + '  							  AND  F.MEASURE = IIF( ISNULL(s.vmi_yn, ''N'') = ''Y'', ''VMI_In_Req'',  ''MKT_FCST'')															' + CHAR(10); 
	--2022/11/07
	--SET @qry = @qry + '  							 AND  F.MEASURE = IIF(ISNULL(s.OPERATION_GROUP,'''') = ''W'', ''AS_In_Req'', IIF(s.vmi_yn = ''Y'', ''VMI_In_Req'',''MKT_FCST''))					' + CHAR(10); 
	SET @qry = @qry + '  							 AND  F.MEASURE = CASE WHEN ISNULL(S.OPERATION_GROUP, '''') = ''W'' THEN ''AS_In_Req'' WHEN S.vmi_yn = ''Y'' THEN ''VMI_In_Req'' WHEN ISNULL(f.attribute10, '''') = '''' THEN ''MKT_FCST'' END	' + CHAR(10);
	SET @qry = @qry + '  						) de																																				' + CHAR(10); 
	SET @qry = @qry + '  						LEFT OUTER JOIN	(SELECT a.division_id, a.scm_site_id, b.item_id, b.project_code, c.priority ,c.sales_site_id, right(plant_site_id,1) plant_type		' + CHAR(10); 
	SET @qry = @qry + '  										   FROM   scm_mst_site a																											' + CHAR(10); 
	SET @qry = @qry + '  											    , scm_mst_site_item b																										' + CHAR(10); 
	SET @qry = @qry + '  											 , scm_mst_site_item_priority c																								' + CHAR(10); 
	SET @qry = @qry + '  									      WHERE    a.division_id  = b.division_id																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.scm_site_id  = b.scm_site_id																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.division_id  = c.division_id																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.scm_site_id  = c.PLANT_SITE_ID																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.project_code = c.project_code																							' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.item_id      = c.item_id																								' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.valid_yn     = ''Y''																									' + CHAR(10); 
	SET @qry = @qry + '  										    AND    b.valid_yn     = ''Y''																									' + CHAR(10); 
	SET @qry = @qry + '  										    AND    c.valid_yn     = ''Y''																									' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.site_type    = ''PLANT''																								' + CHAR(10); 
	SET @qry = @qry + '  										    AND    a.division_id  IN ( ''40'',''82'')																						' + CHAR(10); 
	--SET @qry = @qry + '  										    AND    a.division_id  IN ( ''40'',''82'',''42'',''44'')																						' + CHAR(10); 
	SET @qry = @qry + '  						                 ) si ON  de.division_id  = si.division_id																							' + CHAR(10); 
	SET @qry = @qry + '  							                 AND  de.item_id      = si.item_id																								' + CHAR(10); 
	SET @qry = @qry + '  						LEFT OUTER JOIN (SELECT	division_id, scm_site_id,country,city																						' + CHAR(10); 
	SET @qry = @qry + '  									     FROM scm_mst_site A WHERE a.valid_yn = ''Y'') f_ci ON de.division_id = f_ci.division_id AND si.scm_site_id = f_ci.scm_site_id		' + CHAR(10); 	    
	SET @qry = @qry + '  						LEFT OUTER JOIN (SELECT division_id, scm_site_id,country,city																						' + CHAR(10); 
	SET @qry = @qry + '  									     FROM scm_mst_site A WHERE a.valid_yn = ''Y'') t_ci ON de.division_id = t_ci.division_id AND de.scm_site_id = t_ci.scm_site_id		' + CHAR(10); 
	SET @qry = @qry + ' 			        ) t																																						' + CHAR(10); 
	SET @qry = @qry + ' 		        LEFT JOIN ( SELECT DISTINCT from_country, from_city, to_country, to_city, transport_mode																	' + CHAR(10); 
	SET @qry = @qry + ' 		 		              FROM scp_mst_distribution_route																												' + CHAR(10); 
	SET @qry = @qry + ' 					         WHERE valid_yn =''Y''																															' + CHAR(10); 
	SET @qry = @qry + ' 					      ) u ON t.from_country = u.from_country																											' + CHAR(10); 
	SET @qry = @qry + ' 						     AND t.from_city    = u.from_city																												' + CHAR(10); 
	SET @qry = @qry + ' 						     AND t.to_country   = u.to_country																												' + CHAR(10); 
	SET @qry = @qry + ' 						     AND t.to_city      = u.to_city																													' + CHAR(10); 
	SET @qry = @qry + '			        ) a																																							' + CHAR(10); 
	SET @qry = @qry + ' 			    WHERE NOT EXISTS  ( SELECT 1																																' + CHAR(10); 
	SET @qry = @qry + '									      FROM																																	' + CHAR(10); 
	SET @qry = @qry + '										     (SELECT DISTINCT a.division_id, a.from_site, a.to_site, b.transport_mode 															' + CHAR(10); 
	SET @qry = @qry + '                  					        FROM scp_mst_bod a																												' + CHAR(10);
	-- BOD 2단계 개발 : scp_mst_bod_v -> scp_mst_bod_n_v
	--SET @qry = @qry + '                  					       INNER JOIN scp_mst_bod_v b  ON a.division_id = b.division_id																		' + CHAR(10);
	SET @qry = @qry + '                  					       INNER JOIN scp_mst_bod_n_v b  ON a.division_id = b.division_id																	' + CHAR(10);
	SET @qry = @qry + ' 																      AND a.bod_id = b.bod_id																				' + CHAR(10);
	SET @qry = @qry + ' 																      AND a.from_site = b.from_site																			' + CHAR(10);
	SET @qry = @qry + ' 																      AND a.to_site = b.to_site																				' + CHAR(10);
	SET @qry = @qry + ' 																      AND a.incoterms = b.incoterms																			' + CHAR(10); 
	SET @qry = @qry + '                  				            WHERE a.incoterms = ''DAP''																										' + CHAR(10); 
	SET @qry = @qry + '                  			              ) b																																' + CHAR(10); 
	SET @qry = @qry + ' 			                        WHERE a.division_id    =  b.division_id																									' + CHAR(10); 
	SET @qry = @qry + ' 			                          AND a.from_site      =  b.from_site																									' + CHAR(10); 
	SET @qry = @qry + ' 			                          AND a.to_site        =  b.to_site																										' + CHAR(10); 
	SET @qry = @qry + ' 			                          AND a.transport_mode =  b.transport_mode																								' + CHAR(10); 
	SET @qry = @qry + '                                    )																																		' + CHAR(10); 
	SET @qry = @qry + '		           UNION ALL																																					' + CHAR(10); 
	SET @qry = @qry + '                /*  3. BOD Completed - BOD Master */																															' + CHAR(10); 
	SET @qry = @qry + '		           SELECT a.division_id, a.to_site																																' + CHAR(10); 
	SET @qry = @qry + '                      ,(SELECT end_customer FROM scm_mst_site WHERE division_id = a.division_id AND scm_site_id = a.to_site) AS customer										' + CHAR(10); 
	SET @qry = @qry + '				         ,a.incoterms, a.from_site																																' + CHAR(10); 
	SET @qry = @qry + '				         ,f_ci.country AS from_country																															' + CHAR(10); 
	SET @qry = @qry + '				         ,f_ci.city	   AS from_city																																' + CHAR(10); 
	SET @qry = @qry + '				         ,t_ci.country AS to_country																															' + CHAR(10); 
	SET @qry = @qry + '				         ,t_ci.city	   AS to_city																																' + CHAR(10); 
	SET @qry = @qry + '				         ,ro.transport_mode																																		' + CHAR(10); 
	SET @qry = @qry + '				         ,a.created_by,a.creation_date, a.last_updated_by,a.last_update_date, a.attribute1																		' + CHAR(10); 
	-- BOD 2단계 개발
	SET @qry = @qry + ' 					  ,a.bod_id		AS BOD_ID																																' + CHAR(10); 
	SET @qry = @qry + '		             FROM scp_mst_bod a																																			' + CHAR(10); 
	SET @qry = @qry + '			         INNER JOIN scp_mst_distribution_route ro  ON a.route_id = ro.route_id																						' + CHAR(10); 
	SET @qry = @qry + ' 	             LEFT OUTER JOIN scm_mst_site f_ci ON f_ci.division_id = a.division_id AND f_ci.scm_site_id = a.from_site AND f_ci.valid_yn = ''Y''							' + CHAR(10); 
	SET @qry = @qry + ' 		         LEFT OUTER JOIN scm_mst_site t_ci ON t_ci.scm_site_id = a.to_site	   AND t_ci.valid_yn = ''Y''															' + CHAR(10); 
	SET @qry = @qry + '                UNION ALL																																					' + CHAR(10);  
	SET @qry = @qry + '                /* 4. BOD Required - VMI = N -> Y Change and scp_mst_bod not exists DAP raw insert. */																		' + CHAR(10); 
	SET @qry = @qry + '		             SELECT a.division_id, a.to_site																															' + CHAR(10);
	SET @qry = @qry + '				           ,(SELECT end_customer FROM scm_mst_site WHERE division_id = a.division_id AND scm_site_id = a.to_site) AS customer									' + CHAR(10);
	SET @qry = @qry + '				           ,''DAP'' incoterms, a.from_site																														' + CHAR(10);
	SET @qry = @qry + '				           ,from_country																																		' + CHAR(10);
	SET @qry = @qry + '				           ,from_city																																			' + CHAR(10);
	SET @qry = @qry + '				           ,to_country																																			' + CHAR(10);
	SET @qry = @qry + '				           ,to_city																																				' + CHAR(10);
	SET @qry = @qry + '				           ,transport_mode																																		' + CHAR(10);
	SET @qry = @qry + '				           ,null created_by,null creation_date, null last_updated_by,null last_update_date, a.attribute1														' + CHAR(10);
	-- BOD 2단계 개발
	SET @qry = @qry + ' 					  ,a.bod_id		AS BOD_ID																																' + CHAR(10); 
	SET @qry = @qry + '			           FROM (																																					' + CHAR(10);
	SET @qry = @qry + '					        SELECT  a.division_id, a.to_site																													' + CHAR(10); 
	SET @qry = @qry + '                                ,(SELECT end_customer FROM scm_mst_site WHERE division_id = a.division_id AND scm_site_id = a.to_site) AS customer							' + CHAR(10); 
	SET @qry = @qry + '						           ,a.incoterms, a.from_site																													' + CHAR(10); 
	SET @qry = @qry + '						           ,f_ci.country AS from_country																												' + CHAR(10); 
	SET @qry = @qry + '						           ,f_ci.city	 AS from_city																													' + CHAR(10); 
	SET @qry = @qry + '						           ,t_ci.country AS to_country																													' + CHAR(10); 
	SET @qry = @qry + '						           ,t_ci.city    AS to_city																														' + CHAR(10); 
	SET @qry = @qry + '						           ,ro.transport_mode																															' + CHAR(10); 
	SET @qry = @qry + '						           ,a.created_by,a.creation_date, a.last_updated_by,a.last_update_date, a.attribute1															' + CHAR(10); 
	-- BOD 2단계 개발
	SET @qry = @qry + ' 								,a.bod_id		AS BOD_ID																													' + CHAR(10); 
	SET @qry = @qry + '					         FROM scp_mst_bod a																																	' + CHAR(10); 
	SET @qry = @qry + '					         INNER JOIN scp_mst_distribution_route ro  ON a.route_id = ro.route_id																				' + CHAR(10); 
	SET @qry = @qry + ' 				         LEFT OUTER JOIN scm_mst_site f_ci ON f_ci.division_id = a.division_id AND f_ci.scm_site_id = a.from_site AND f_ci.valid_yn = ''Y''					' + CHAR(10); 
	SET @qry = @qry + ' 				         LEFT OUTER JOIN scm_mst_site t_ci ON t_ci.scm_site_id = a.to_site	  AND t_ci.VALID_YN = ''Y''														' + CHAR(10);  
	SET @qry = @qry + '				            ) a																																					' + CHAR(10);
	SET @qry = @qry + '			          INNER JOIN SCM_MST_SITE c ON a.DIVISION_ID = c.DIVISION_ID AND a.to_site = c.SCM_SITE_ID																	' + CHAR(10);
	SET @qry = @qry + '			          WHERE c.VMI_YN = ''Y''																																	' + CHAR(10);
	SET @qry = @qry + '			          AND INCOTERMS != ''DAP''																																	' + CHAR(10);
	SET @qry = @qry + '			          AND NOT EXISTS (SELECT 1																																	' + CHAR(10);
	SET @qry = @qry + '							            FROM (SELECT distinct a.division_id, a.from_site, a.to_site, b.transport_mode															' + CHAR(10);
    SET @qry = @qry + '				  					            FROM scp_mst_bod a																												' + CHAR(10);
	-- BOD 2단계 개발 : scp_mst_bod_v -> scp_mst_bod_n_v
	--SET @qry = @qry + '				  					            INNER JOIN scp_mst_bod_v b ON a.division_id = b.division_id																		' + CHAR(10);
    SET @qry = @qry + '				  					            INNER JOIN scp_mst_bod_n_v b ON a.division_id = b.division_id																	' + CHAR(10);
	SET @qry = @qry + '																          AND a.bod_id = b.bod_id																				' + CHAR(10);
	SET @qry = @qry + '																          AND a.from_site = b.from_site																			' + CHAR(10);
	SET @qry = @qry + '																          AND a.to_site = b.to_site																				' + CHAR(10);
	SET @qry = @qry + '																          AND a.incoterms = b.incoterms																			' + CHAR(10);
    SET @qry = @qry + '				  					            WHERE a.incoterms = ''DAP''																										' + CHAR(10);
	SET @qry = @qry + '									         ) b																																' + CHAR(10);
	SET @qry = @qry + '							            INNER JOIN scm_mst_site c ON a.division_id = c.division_id AND b.to_site = c.scm_site_id												' + CHAR(10);
	SET @qry = @qry + '							            WHERE c.vmi_yn       =  ''Y''																											' + CHAR(10);
	SET @qry = @qry + '							            AND a.from_site      =  b.from_site																										' + CHAR(10);
	SET @qry = @qry + '							            AND a.to_site        =  b.to_site																										' + CHAR(10);
	SET @qry = @qry + '							            AND a.transport_mode =  b.transport_mode																								' + CHAR(10);
	SET @qry = @qry + '									  )																																			' + CHAR(10);
	SET @qry = @qry + ' ) ma																																										' + CHAR(10); 
	SET @qry = @qry + '	/* bo table - Trasport Mode Add  */																																			' + CHAR(10); 
	--PJ20209642 : BOD LT 1단계 개발 (B.lt_departure_inland, B.lt_wait_shipping,B.lt_voyage,B.lt_lay_off_clearance, B.lt_arrival_inland 추가)
	SET @qry = @qry + ' LEFT OUTER JOIN ( SELECT a.*, b.transport_mode,B.lt_departure_inland, B.lt_wait_shipping,B.lt_voyage,B.lt_lay_off_clearance, B.lt_arrival_inland							' + CHAR(10); 
	SET @qry = @qry + '					    FROM scp_mst_bod a																																		' + CHAR(10); 
	SET @qry = @qry + '						INNER JOIN scp_mst_distribution_route b ON a.ROUTE_ID = b.ROUTE_ID																						' + CHAR(10); 
	SET @qry = @qry + '					) bo ON  bo.division_id   = ma.division_id																													' + CHAR(10); 
	SET @qry = @qry + ' 				     AND bo.to_site       = ma.to_site																														' + CHAR(10); 
	SET @qry = @qry + ' 					 AND bo.incoterms     = ma.incoterms																													' + CHAR(10); 
	SET @qry = @qry + ' 					 AND bo.from_site     = ma.from_site																													' + CHAR(10); 
	SET @qry = @qry + ' 					 AND bo.transport_mode= ma.transport_mode																												' + CHAR(10); 
	
    IF( ISNULL(@p_input_status,'') ='C' )
    	SET @qry = @qry + ' 					 AND bo.bod_id			= ma.bod_id																														' + CHAR(10); 

	SET @qry = @qry + '	/* ro table - Distribution Route Add */																																		' + CHAR(10); 
	SET @qry = @qry + ' LEFT OUTER JOIN scp_mst_distribution_route ro  ON bo.route_id = ro.route_id																									' + CHAR(10); 
	SET @qry = @qry + ' WHERE 1=1																																									' + CHAR(10); 
	
	-- R : Required , C: completed
	IF( ISNULL(@p_input_status,'') ='R' )
		SET @qry = @qry + ' 		AND  bo.route_id IS NULL				'+ char(10);
	ELSE IF( ISNULL(@p_input_status,'') ='C' )
		SET @qry = @qry + ' 		AND  bo.route_id IS NOT NULL			'+ char(10);
	IF( ISNULL(@p_valid,'') !='' )
		SET @qry = @qry + ' 		AND  bo.valid_yn ='''+@p_valid+'''		'+ char(10);

    -- 화면 조회조건 
	IF( (@p_division_id  IS NOT NULL AND @p_division_id  != '' ) )
		SET @qry = @qry + ' 		AND ma.division_id    IN ('+ @arr_division_id + ')	'+ char(10);
	IF( (@p_from_site    IS NOT NULL AND @p_from_site    != '' ) )
		SET @qry = @qry + ' 		AND ma.from_site      IN ('+ @arr_from_site + ')	'+ char(10);
	IF( (@p_to_site      IS NOT NULL AND @p_to_site      != '' ) )
		SET @qry = @qry + ' 		AND ma.to_site        IN (N'+@arr_to_site+')	'+ char(10);
	IF( (@p_incoterms    IS NOT NULL AND @p_incoterms    != '' )  )
		SET @qry = @qry + ' 		AND ma.incoterms      IN ('+@arr_incoterms+')	'+ char(10);

	IF( ISNULL(@p_input_status,'') ='C' )
	BEGIN
		IF( (@p_incoterms_ssp    IS NOT NULL AND @p_incoterms_ssp    != '' )  )
			SET @qry = @qry + ' 		AND ma.attribute1      IN ('+@arr_incoterms_ssp+')	'+ char(10);
	END

	IF( (@p_trans_mode   IS NOT NULL AND @p_trans_mode   != '' )  )
		SET @qry = @qry + ' 		AND ro.transport_mode IN ('+@arr_transmode+')	'+ char(10);
		
	SET @qry = @qry + ' ) T	' + char(10);
	
	IF( ISNULL(@p_input_status,'') ='R' )
		BEGIN
			-- From Site가 외주 이고 오른쪽 끝이 'A'(Cell) 인건은 Required에서 보여주지 않음.  Completed 에서는 공장간 이동 등록된것 보여야 함
			SET @qry = @qry + 'WHERE NOT EXISTS (SELECT 1 FROM scm_mst_site s WHERE s.division_id = t.division_id AND s.scm_site_id = t.from_site_code AND s.valid_yn = ''Y'' AND s.osp_yn = ''Y'' AND s.operation_group = ''A'')	'+ char(10);
			SET @qry = @qry + 'ORDER BY division_id, route_cnt, customer, incoterms, from_site_code, to_site_code, priority, route_id, transport_mode , days_mon, days_tue, days_wed, days_thu, days_fri, days_sat, days_sun     	'+ char(10);
		END
	ELSE IF( ISNULL(@p_input_status,'') ='C' )
		--SET @qry = @qry + 'ORDER BY  division_id, customer, incoterms, from_site_code, to_site_code, priority, route_id, transport_mode , days_mon, days_tue, days_wed, days_thu, days_fri, days_sat, days_sun     					'+ char(10);
		--SET @qry = @qry + 'ORDER BY  division_id, customer, incoterms, from_site_code, to_site_code, priority, route_id,  days_mon, days_tue, days_wed, days_thu, days_fri, days_sat, days_sun     					'+ char(10);
		SET @qry = @qry + 'ORDER BY  division_id, customer, incoterms, from_site_code, to_site_code, T.FROM_YYYYMMDD, priority, route_id,  days_mon, days_tue, days_wed, days_thu, days_fri, days_sat, days_sun     					'+ char(10);  -- BOD LT 2단계 개발(From , To 추가)

		SET @qry = @qry + ' OPTION (HASH GROUP, FAST 10) ; '+ char(10);


	-----------------------------------------------------------
	-- DEBUG QRY 출력
	-----------------------------------------------------------	
	IF( @debug_mode ='T')
		BEGIN				
			DECLARE @POS INT =1;
			DECLARE @LEN INT =LEN(@qry);
			WHILE @POS <= @LEN
				BEGIN
					PRINT SUBSTRING(@qry,@POS,4000);
					SET @POS = @POS+4000;
				END;
		END;
	-----------------------------------------------------------

		
	EXEC (@qry);
	
   
END
