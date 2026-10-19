
/*
 * Program ID   : SSP0021_GET_SHIPMENT_PLAN_DETAIL
 * Description  : 자동차 Shipment Plan
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/09/06   mcThej			Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
 * 2019/11/14   ayj				CHANGE_REASON_CODE, CHANGE_REASON_DETAIL SELECT 값 수정
 * 2019/12/17	KIMYONGHO		[C20191216-000311] Expected Shipping Date 컬럼 추가
 * 2020/01/21   juhlee          [C20200121-000352]  ESS Packer출하 적용 
								 - [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외)  
 * 2020/02/10   KIMYONGHO       Shipmnet Status 조회 시 하드코딩 제외하고 SIPMENT_STATUS 공통코드 타입으로 조회 되게 변경 ('Confirm' -> 'C', 'Plan' - > 'P')
 * 2020/03/12   KIMYONGHO     [C20200226-000471] Shipment Detail 탭 Project code 표시
 * 2020/03/26   KIMYONGHO     [C20200326-000217] Shipment Detail 탭 Team, Project Name 표시
 * 2021/02/04   KIMYONGHO	  ETA_DATE 조회 시 항차를 고려한 LT 적용되도록 함수 적용 FN_GET_SSP_ETA_DAE
 * 2021/10/18   KIMYONGHO	  [C20211001-000241][SCM PI팀] Shipment Plan (Auto ESS) 기능 개선 의건
 * 2022/12/19   jilee    	  오창 출하 물류 R&R 관련 F.Destination 정보 활용 방안 (요청자:임화영)
 * 2024/05/10   hsbang          확정구간 조회 일수(CONFIRM_DAY)를 펑션 FN_GET_ANL_SHIP_FROZEN_DAY_CNT] 에서 가져오도록 반영
 * ex)
	EXEC SSP0021_GET_SHIPMENT_PLAN_DETAIL @p_division_id = '81', @p_company_id = 'C100', @p_from_site = 'A040-A',  @p_item_id = 'ACEN2052I-A1', @p_requestor = '', @p_plan_start_yyyymmdd = '20190917', @p_from_yyyymmdd = '20190917', @p_to_yyyymmdd = '20190917', @p_dbl_flag = 'Y', @p_real_flag = 'N', @p_language = 'KO', @p_program_id = 'SSP0021', @p_sheet_name ='Shipment Plan', @debug_mode = 'T'
 */
CREATE PROCEDURE [dbo].[SSP0021_GET_SHIPMENT_PLAN_DETAIL]
	@p_division_id			VARCHAR(10)
	,@p_company_id			NVARCHAR(10)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_requestor			NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd NVARCHAR(8)
	,@p_from_yyyymmdd		NVARCHAR(8)
	,@p_to_yyyymmdd			NVARCHAR(8)
	,@p_dbl_flag			CHAR(1)
	,@p_real_flag			CHAR(1)
	,@p_language            NVARCHAR(MAX) = 'KO'
	,@p_program_id			NVARCHAR(MAX) = 'SSP0021'
	,@p_sheet_name			NVARCHAR(MAX) = 'Shipment Plan Detail'
	,@debug_mode			NVARCHAR(1)='T'

AS

BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @mDQry NVARCHAR(MAX)='';

	DECLARE  @v_division_id NVARCHAR(MAX)='';
	DECLARE  @v_from_site NVARCHAR(MAX)='';
	DECLARE  @v_item_id NVARCHAR(MAX)='';
	DECLARE  @v_requestor NVARCHAR(MAX)='';
	DECLARE @v_app_type    NVARCHAR(8) = 'SSP';

	--IN 조건으로 데이터를 가져옴
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);
	SET @v_requestor = @p_requestor;
	--select @v_requestor; --SET @v_requestor = [dbo].FN_GET_IN_STR2(@p_requestor);

	SET @mDqry = @mDQry + ' WITH LOOK AS																						' + char(10);
	SET @mDqry = @mDQry + ' (																									' + char(10);
	SET @mDqry = @mDQry + ' SELECT  a.segment2 as PLANT_ID																			' + char(10);
	SET @mDqry = @mDQry + '       , SITE_PROJECT.division_id, SITE_PROJECT.project_code, SITE_PROJECT.scm_site_id, SITE_PROJECT.item_id ' + char(10);
	SET @mDqry = @mDQry + '       , TEAM.DEPT_ID, isnull(TEAM.DEPT_NAME_KO, ''-'') as DEPT_NAME_KO											' + char(10);
	SET @mDqry = @mDQry + '       , SITE_PROJECT.OWNER AS OWNER																	' + char(10);
	SET @mDqry = @mDQry + '       , isnull(MST_SITE.end_customer, ''-'') as END_CUSTOMER																		' + char(10);
	SET @mDqry = @mDQry + '       , isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.SEGMENT3 , a.SEGMENT2 ),''-'') as to_site_description																				' + char(10);
	SET @mDqry = @mDQry + '  FROM SCM_ADM_LOOKUP_MASTER_DETAIL a (nolock)														' + char(10);
	SET @mDqry = @mDQry + '		INNER JOIN SCM_MST_SITE_ITEM SITE_PROJECT (nolock)													' + char(10);
	SET @mDqry = @mDQry + '		   ON a.lookup_type = ''AS_SITE_PLANT''																' + char(10);
	SET @mDqry = @mDQry + '		  AND a.SEGMENT1 = SITE_PROJECT.scm_site_id															' + char(10);
	SET @mDqry = @mDQry + '		LEFT JOIN (																							' + char(10);
	SET @mDqry = @mDQry + '			SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO							' + char(10);
	SET @mDqry = @mDQry + '			  FROM SCM_MST_SSO_USER_INFO  AS B (nolock)															' + char(10);
	SET @mDqry = @mDQry + '			 INNER JOIN [SCM_MST_SSO_DEPT_INFO] AS C (nolock)													' + char(10);
	SET @mDqry = @mDQry + '				ON B.DEPT_ID = C.DEPT_ID																	' + char(10);
	SET @mDqry = @mDQry + '		) AS TEAM																							' + char(10);
	SET @mDqry = @mDQry + '		ON   TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](SITE_PROJECT.owner, '',''))	' + char(10);
	SET @mDqry = @mDQry + '		LEFT OUTER JOIN SCM_MST_SITE MST_SITE																' + char(10);
	SET @mDqry = @mDQry + '			ON SITE_PROJECT.division_id = MST_SITE.division_id												' + char(10);
	SET @mDqry = @mDQry + '		   AND  SITE_PROJECT.scm_site_id = MST_SITE.scm_site_id												' + char(10);
	SET @mDqry = @mDQry + ' )' + char(10);

	IF @p_real_flag = 'Y'
	BEGIN
		SET @mDqry = @mDQry + ' SELECT   a.division_id         																										' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.erp_so_no                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.shipment_status                                                                                                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.item_id                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' 		 , dbo.fn_get_item_nickname((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name                                                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.from_site                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.to_site                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),''-'') AS from_site_description                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.to_site ),''-'') as to_site_description                      ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(a.PROJECT_CODE,''-'') as PROJECT_CODE                      ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(dbo.FN_GET_PROJECT_NAME(a.division_id,a.PROJECT_CODE),''-'') as PROJECT_NAME                      ' + char(10);
		--20211118 SMS 수정
		--SET @mDqry = @mDQry + ' 		 , isnull(case when a.DIVISION_ID = ''40'' then case when a.PROJECT_CODE is not null and a.PROJECT_CODE != ''-'' then a.PROJECT_CODE else g.PROJECT_CODE end when a.DIVISION_ID = ''EE'' and a.ORIGIN_TO_DIVISION_ID = ''40'' then g.project_code else f.END_CUSTOMER end,''-'') end_customer            ' + char(10);
		--SET @mDqry = @mDQry + ' 		 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '','', '''+@p_language+''') AS MTK_OWNER                                                                                         ' + char(10);

		SET @mDqry = @mDQry + ' 		 , isnull(case when a.DIVISION_ID = ''40'' then case when a.PROJECT_CODE is not null and a.PROJECT_CODE != ''-'' then a.PROJECT_CODE else g.PROJECT_CODE end when a.DIVISION_ID = ''EE'' and a.ORIGIN_TO_DIVISION_ID = ''40'' then g.project_code else f.END_CUSTOMER end, isnull(L1.end_customer,''-'')) end_customer            ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CASE WHEN SI.OWNER is not null THEN DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '','', '''+@p_language+''') ELSE DBO.FN_GET_SSP_MKT_OWNER_NAME (L1.OWNER, '','', '''+@p_language+''') END AS MTK_OWNER                                                                                         ' + char(10);
--=============================
		SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U3.UserName ELSE U3.UserName_E END + ''('' + a.requestor + '')'' requestor    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , convert(int, a.qty) AS shipment_confirm_qty                                                                                        ' + char(10);
		SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) AS shipment_date                                       ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.transport_mode                                                                                                     ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.remarks2																											' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.remarks					                                                                                        ' + char(10);
		SET @mDqry = @mDQry + '			 , ''-'' AS CHANGE_REASON_CODE ' + char(10);
		SET @mDqry = @mDQry + '			 , '''' AS CHANGE_REASON_DETAIL ' + char(10);
		SET @mDqry = @mDQry + ' 		 , a.remarks3																											' + char(10);
		SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SOLDTO_DESCRIPTION'' ) AS soldto_description                ' + char(10);
		SET @mDqry = @mDQry + ' 		 , dbo.fn_get_site_customer_info((case when a.division_id = ''EE'' then a.origin_from_division_id else a.division_id end), a.to_site, ''SHIPTO_DESCRIPTION'' ) AS shipto_description                ' + char(10);
		-- 20201223 incoterms 변경 작업 modify KIMYONGHO
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
		--SET @mDqry = @mDQry + ' 		 , h.DEPT_NAME_KO AS TEAM' + CHAR(10);
		--20211117	SMS	수정
		--SET @mDqry = @mDQry + ' 		 , isnull(g.DEPT_NAME_KO,''-'') as TEAM                      ' + char(10);
		SET @mDqry = @mDQry + ' 		 , isnull(g.DEPT_NAME_KO, isnull(L1.DEPT_NAME_KO,''-'')) as TEAM                      ' + char(10);

		SET @mDqry = @mDQry + ' 		 , a.ATTRIBUTE10                      ' + char(10);
		-- 221219 jilee 오창 출하 물류 R&R 관련 F.Destination 정보 활용 방안 (요청자:임화영)
		SET @mDqry = @mDQry + ' 		 , b.A_COUNTRY                        ' + char(10);
		SET @mDqry = @mDQry + ' 		 , b.A_PORT_CODE                      ' + char(10);
		SET @mDqry = @mDQry + ' 		 , t8.A_PORT_NAME                     ' + char(10);
		SET @mDqry = @mDQry + ' 		 , co.COUNTRY_NAME                    ' + char(10);
		SET @mDqry = @mDQry + ' 		 , ct.CITY_NAME                       ' + char(10);
		SET @mDqry = @mDQry + ' 		 , cm.SHIPTO_REGION_NAME              ' + char(10);    
		SET @mDqry = @mDQry + ' 		 , cm.SHIPTO_CITY_NAME                ' + char(10);
		SET @mDqry = @mDQry + ' FROM                                                                                                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' (                                                                                                                                                                                                                                                                                               ' + char(10);
		SET @mDqry = @mDQry + ' 	SELECT                                                                                                                                                                                                                                                                                      ' + char(10);
		SET @mDqry = @mDQry + ' 		  C.DIVISION_ID                                                                                                                                                                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.ERP_SO_NO                                                                                                                                                                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.SHIPMENT_STATUS AS SHIPMENT_STATUS                                                                                                                                                                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.ITEM_ID                                                                                                                                                                                                                                                                               ' + char(10);
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
		SET @mDqry = @mDQry + ' 		, isnull(C.CHECK_NEED_YN,''N'') AS CHECK_NEED_YN ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.ELECTRODE_YN ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.ELECTRODE_TYPE ' + char(10);
		SET @mDqry = @mDQry + ' 		, C.ATTRIBUTE10 ' + char(10);
		SET @mDqry = @mDQry + ' 	FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)                                                                                                                                                                                                                                                                  ' + char(10);

		SET @mDqry = @mDQry + '		JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 ' + char(10);
		SET @mDqry = @mDQry + '			ON C.ITEM_ID		= T.ITEM_ID					 ' + char(10);
		SET @mDqry = @mDQry + '		   AND C.DIVISION_ID	= T.DIVISION_ID				 ' + char(10);
		SET @mDqry = @mDQry + '		   AND C.FROM_SITE_COMPANY_ID = T.COMPANY_ID				 ' + char(10);
		SET @mDqry = @mDQry + '		   AND T.ITEM_TYPE		NOT IN (''Q'',''R'')		 ' + char(10);

		SET @mDqry = @mDQry + ' 	WHERE 1 = 1    AND change_type  = ''C''                                                                                                                                                                                                                                                                           ' + char(10);
		SET @mDQry = @mDQry + ' 	AND C.DIVISION_ID = '''+ @p_division_id     +''' '+char(10)
		SET @mDQry = @mDQry + ' 	AND C.FROM_SITE_COMPANY_ID = '''+ @p_company_id + ''' ' +char(10);
		SET @mDQry = @mDQry + ' 	AND C.BIZ_TYPE <> ''E''       ' +char(10);
		--//Model
		IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mDQry = @mDQry + ' 					AND  C.item_id       IN ('+ @v_item_id     +')'+char(10);
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
				SET @mDQry = @mDQry + '													(SELECT UserID FROM [TB_FX_User] ' + char(10) ;
				SET @mDQry = @mDQry + '													WHERE 1 = 1 ' + char(10) ;
				SET @mDQry = @mDQry + '													AND UserName		IN (' + @v_requestor + ')' +char(10);
				SET @mDQry = @mDQry + '													UNION ALL ' + char(10);
				SET @mDQry = @mDQry + '													SELECT UserID FROM [TB_FX_User] ' + char(10) ;
				SET @mDQry = @mDQry + '													WHERE 1 = 1 ' + char(10) ;
				SET @mDQry = @mDQry + '													AND UserID		IN (' + @v_requestor + '))) TT1 ' +char(10);
				SET @mDQry = @mDQry + '												) ' + char(10);
			END
		END
		IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDQry = @mDQry + ' 					AND  C.from_site     IN ('+ @v_from_site   +')'+char(10);

		SET @mDqry = @mDQry + ' 	UNION ALL                                                                                                                                                                                                                                                                                   ' + char(10);
		SET @mDqry = @mDQry + ' 	SELECT							' + char(10);
		SET @mDqry = @mDQry + '			DIVISION_ID					' + char(10);
		SET @mDqry = @mDQry + '			, ERP_SO_NO                 ' + char(10);
		SET @mDqry = @mDQry + '			, SHIPMENT_STATUS           ' + char(10);
		SET @mDqry = @mDQry + '			, ITEM_ID                   ' + char(10);
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
		SET @mDqry = @mDQry + ' 		, ''-'' AS ATTRIBUTE10 ' + char(10);
		SET @mDqry = @mDQry + ' 	FROM							' + char(10);
		SET @mDqry = @mDQry + ' 	(								' + char(10);
		SET @mDqry = @mDQry + ' 		SELECT                                                                                                                                                                                                                                                                                      ' + char(10);
		SET @mDqry = @mDQry + ' 			tt0.DIVISION_ID                                                                                                                                                                                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS ERP_SO_NO                                                                                                                                                                                                                                                                      ' + char(10);
		SET @mDqry = @mDQry + ' 			, ''P'' AS SHIPMENT_STATUS                                                                                                                                                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0. ITEM_ID                                                                                                                                                                                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.DIVISION_ID AS ORIGIN_FROM_DIVISION_ID                                                                                                                                                                                                                                                        ' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.DIVISION_ID AS ORIGIN_TO_DIVISION_ID                                                                                                                                                                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.PLANT_SITE_ID AS FROM_SITE                                                                                                                                                                                                                                                        ' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.SCM_SITE_ID AS TO_SITE                                                                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.PROJECT_CODE                                                                                                                                                                                                                                                                      ' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS REQUESTOR                                                                                                                                                                                                                                                                      ' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.QTY                                                                                                                                                                                                                                                                               ' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.YYYYMMDD                                                                                                                                                                                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.BOD_ID                                                                                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS REMARKS2                                                                                                                                                                                                                                                                       ' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS REMARKS                                                                                                                                                                                                                                                                        ' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS CHANGE_REQ_NO                                                                                                                                                                                                                                                                  ' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS REMARKS3                                                                                                                                                                                                                                                                       ' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.YYYYMMDD AS ETD_DATE                                                                                                                                                                                                                                                                        ' + char(10);
		-- * 2021/02/04   KIMYONGHO	  ETA_DATE 조회 시 항차를 고려한 LT 적용되도록 함수 적용 FN_GET_SSP_ETA_DATE
		--SET @mDqry = @mDQry + ' 			, convert(VARCHAR(8), dateadd(dd, convert(int, ISNULL(tt1.lt_total, 0)), convert(datetime, tt0.YYYYMMDD)),112) AS ETA_DATE                                                                                                                                                                                                                                                                        ' + char(10);
		SET @mDqry = @mDQry + ' 			, CONVERT(VARCHAR(8),CONVERT(DATETIME,[dbo].[FN_GET_SSP_ETA_DATE](tt0.DIVISION_ID, tt0.BOD_ID, tt0.YYYYMMDD) ,112), 112) AS ETA_DATE                                                                                                                                                                                                                                                                        ' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.LAST_UPDATED_BY                                                                                                                                                                                                                                                                   ' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.LAST_UPDATE_DATE                                                                                                                                                                                                                                                                  ' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS CONFIRM_ID                                                                                                                                                                                                                                                                     ' + char(10);
		SET @mDqry = @mDQry + ' 			, tt0.FCST_TYPE                                                                                                                                                                                                                                                                         ' + char(10);
		--SET @mDqry = @mDQry + ' 			, CASE WHEN isnull(tt2.ship_frozen,0) > 0 THEN CONVERT(CHAR(8), DATEADD(DD, isnull(tt2.ship_frozen,0), CONVERT(VARCHAR, ''' + @p_plan_start_yyyymmdd + ''', 121)), 112) ELSE ''' + @p_plan_start_yyyymmdd + ''' END AS frozen_yyyymmdd ' + char(10);
		SET @mDqry = @mDQry + ' 			, CASE WHEN isnull(tt2.ship_frozen,0) > 0 THEN CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](''' + @v_app_type + ''', tt2.DIVISION_ID, tt2.SCM_SITE_ID, ''' + @p_plan_start_yyyymmdd + ''') , CONVERT(DATETIME, '''+ @p_plan_start_yyyymmdd + ''' ,112)) ,112) ELSE ''' + @p_plan_start_yyyymmdd + ''' END AS frozen_yyyymmdd ' + char(10);
		SET @mDqry = @mDQry + ' 	FROM DM_PLN_SHIPMENT_REQ tt0 WITH(NOLOCK)                                                                                                                                                                                                                                                               ' + char(10);
		SET @mDqry = @mDQry + ' 	INNER JOIN  scp_mst_bod_n_v tt1 WITH(NOLOCK) ON tt0.DIVISION_ID = tt1.division_id  AND tt0.bod_id = tt1.bod_id                                                                                                                                                                                                                  ' + char(10);
		SET @mDqry = @mDQry + ' 	INNER JOIN SCM_MST_SITE tt2 WITH(NOLOCK)                                                                                                                                                                                                                  ' + char(10);
		SET @mDqry = @mDQry + ' 		ON tt0.DIVISION_ID = tt2.DIVISION_ID ' + char(10);
		SET @mDqry = @mDQry + ' 		AND tt0.PLANT_SITE_ID = tt2.SCM_SITE_ID ' + char(10);
		SET @mDqry = @mDQry + ' 		AND tt2.site_type		= ''PLANT'' ' + char(10);
-- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외)
--		SET @mDqry = @mDQry + ' 		AND tt2.osp_yn			= ''N'' ' + char(10);
		SET @mDqry = @mDQry + ' 		AND tt2.valid_yn		= ''Y'' ' + char(10);
		SET @mDqry = @mDQry + ' 	WHERE 1 = 1                                                                                                                                                                                                                                                                                 ' + char(10);
		SET @mDQry = @mDQry + ' 	AND  tt0.DIVISION_ID       = '''+ @p_division_id     +''' '+char(10)
		SET @mDQry = @mDQry + ' 	AND  tt2.COMPANY_ID       = '''+ @p_company_id     +''' '+char(10)
		IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mDQry = @mDQry + ' 					AND  tt0.item_id       IN ('+ @v_item_id     +')'+char(10);
		--//Double Click
		IF ( @p_dbl_flag = 'Y')
		BEGIN
			SET @mDQry = @mDQry + ' 					AND  tt0.yyyymmdd       = '''+ @p_from_yyyymmdd     +''' '+char(10)
		END
		ELSE
		BEGIN
			SET @mDqry = @mDQry + ' 	    AND tt0.yyyymmdd >= '''+ @p_from_yyyymmdd +'''		AND tt0.yyyymmdd <= '''+ @p_to_yyyymmdd +'''                                                    ' + char(10);
		END
		IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDQry = @mDQry + ' 					AND  tt0.PLANT_SITE_ID     IN ('+ @v_from_site   +')'+char(10);
		SET @mDqry = @mDQry + '		) t	' + char(10);
		SET @mDqry = @mDQry + ' 	WHERE 1 = 1	' + char(10);
		SET @mDqry = @mDQry + ' 	AND t.YYYYMMDD >= t.frozen_yyyymmdd ' + char(10);
		SET @mDqry = @mDQry + ' ) a                                                                                                                                                                                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' INNER JOIN  scp_mst_bod_n_v b WITH(NOLOCK)                                                                                                                                                                                                                                                                    ' + char(10);
		SET @mDqry = @mDQry + ' 	ON (CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID END) = b.division_id  AND a.bod_id = b.bod_id                                                                                                                                                          ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = ''Y''                                                                                                                                                                                                                  ' + char(10);
		SET @mDqry = @mDQry + ' INNER JOIN SCM_MST_SITE f WITH(NOLOCK) ON f.division_id = a.DIVISION_ID and f.SCM_SITE_ID = a.TO_SITE                                                                                                                                                                                       ' + char(10);
/*	NERP 적용시 GERP COMPANY_ID에 해당하는 것은 제외 필요함 */	
		SET @mDqry = @mDqry + '			AND  F.VALID_YN = ''Y''																																																																	'+ char(10);		
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_NAME_KO										                                                                                                                                                                                    ' + char(10);
		SET @mDqry = @mDQry + '  	  	FROM(																						                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + '  	  		SELECT aa.DIVISION_ID, aa.PROJECT_CODE, aa.SCM_SITE_ID, aa.ITEM_ID,ac.DEPT_NAME_KO									                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + '  	  				,ROW_NUMBER() over(partition by aa.DIVISION_ID, aa.SCM_SITE_ID, aa.ITEM_ID order by aa.PROJECT_CODE) num		                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + '  	  		FROM scm_mst_site_item aa WITH(NOLOCK)																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  		LEFT OUTER JOIN SCM_MST_SITE  BB WITH(NOLOCK) 																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  			ON BB.SCM_SITE_ID = aa.SCM_SITE_ID																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  		LEFT OUTER JOIN SCM_MST_SSO_USER_INFO  ab WITH(NOLOCK) 																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  			ON  ab.USER_ID = aa.OWNER 																				                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO  ac WITH(NOLOCK) 																			                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + '  	  			ON  bb.DEPT_ID = ac.DEPT_ID																				                                                                                                                                                                                ' + char(10);
		--SET @mDqry = @mDQry + '  	  		SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID									                                                                                                                                                                                            ' + char(10);
		--SET @mDqry = @mDQry + '  	  				,ROW_NUMBER() over(partition by DIVISION_ID, SCM_SITE_ID, ITEM_ID order by PROJECT_CODE) num		                                                                                                                                                                            ' + char(10);
		--SET @mDqry = @mDQry + '  	  		FROM scm_mst_site_item 																				                                                                                                                                                                                ' + char(10);			
		SET @mDqry = @mDQry + '  	  	) a WHERE num = 1) g on g.DIVISION_ID =  (CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_TO_DIVISION_ID ELSE a.DIVISION_ID END) and g.SCM_SITE_ID = a.TO_SITE and g.ITEM_ID = a.ITEM_ID	                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN (SELECT CONFIRM_ID, CHANGE_REQ_NO FROM(								                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' SELECT CONFIRM_ID ,CHANGE_REQ_NO								                                                                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' ,ROW_NUMBER() OVER(PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) NUM								                                                                                                                                                                                        ' + char(10);
		SET @mDqry = @mDQry + ' FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WITH(NOLOCK)								                                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' WHERE VALID_YN = ''Y''								                                                                                                                                                                                                                                            ' + char(10);
		SET @mDqry = @mDQry + ' ) A WHERE NUM = 1) h on h.confirm_id = a.confirm_id								                                                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN SSP_MST_MODEL_USER mu WITH(NOLOCK) on mu.division_id = a.origin_from_division_id and mu.from_site = a.from_site and mu.item_id = a.item_id and mu.valid_yn = ''Y''                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U2 WITH(NOLOCK) ON mu.user_id = u2.UserID AND U2.UseYN = ''Y''                                                                                                                                                                                                                      ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U3 WITH(NOLOCK) ON a.requestor = u3.UserID AND U3.UseYN = ''Y''                                                                                                                                                                                                                     ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) ON SI.DIVISION_ID  = (CASE WHEN A.DIVISION_ID =''EE'' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END)                                                                                                                                      ' + char(10);
		SET @mDqry = @mDQry + '  										AND SI.SCM_SITE_ID  = A.TO_SITE                                                                                                                                                                                                                         ' + char(10);
		SET @mDqry = @mDQry + '  										AND SI.ITEM_ID  = A.ITEM_ID                                                                                                                                                                                                                             ' + char(10);
		SET @mDqry = @mDQry + '  										AND SI.PROJECT_CODE  = A.PROJECT_CODE                                                                                                                                                                                                                   ' + char(10);
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ T1 WITH(NOLOCK)                                                                                                                                                                                                                                                ' + char(10);
		SET @mDqry = @mDQry + ' ON h.CHANGE_REQ_NO = T1.CHANGE_REQ_NO                                                                                                                                                                                                                                                           ' + char(10);

		-- 20211117	SMS	추가
		SET @mDqry = @mDQry + ' LEFT OUTER JOIN LOOK L1 (NOLOCK)' + char(10);
		SET @mDqry = @mDQry + '   ON a.DIVISION_ID = L1.DIVISION_ID' + char(10);
		SET @mDqry = @mDQry + '  AND a.PROJECT_CODE = L1.PROJECT_CODE' + char(10);
		SET @mDqry = @mDQry + '  AND a.to_site = L1.PLANT_ID' + char(10);
		SET @mDqry = @mDQry + '  AND a.item_id = L1.item_id' + char(10);
		-- 221219 jilee 오창 출하 물류 R&R 관련 F.Destination 정보 활용 방안 (요청자:임화영)
		SET @mDqry = @mDQry + ' LEFT JOIN SCP_MST_DISTRIBUTION_ROUTE T8  WITH(NOLOCK)    ' + char(10);                                                                                                                                                                                  
 		SET @mDqry = @mDQry + '   ON T8.ROUTE_ID = b.ROUTE_ID 	                         ' + char(10); 
        SET @mDqry = @mDQry + ' LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER AS C  WITH(NOLOCK) ' + char(10); 
	    SET @mDqry = @mDQry + '   ON (    f.DIVISION_ID = C.DIVISION_ID                  ' + char(10); 
	    SET @mDqry = @mDQry + '  AND f.SCM_SITE_ID = C.SCM_SITE_ID                       ' + char(10);
	    SET @mDqry = @mDQry + '  AND C.REP_YN = ''Y''                                    ' + char(10); 
		SET @mDqry = @mDQry + '  AND C.VALID_YN = ''Y''                                  ' + char(10); 
		SET @mDqry = @mDQry + '      )                                                   ' + char(10); 
        SET @mDqry = @mDQry + ' LEFT JOIN SCM_MST_CUSTOMER  CM WITH(NOLOCK)              ' + char(10);
	    SET @mDqry = @mDQry + '   ON (    C.DIVISION_ID = CM.DIVISION_ID                 ' + char(10);
		SET @mDqry = @mDQry + '  AND C.SOLDTO_CODE = CM.SOLDTO_CODE                      ' + char(10);
		SET @mDqry = @mDQry + '  AND C.SHIPTO_CODE = CM.SHIPTO_CODE                      ' + char(10);
		SET @mDqry = @mDQry + '      )                                                   ' + char(10); 
        SET @mDqry = @mDQry + ' LEFT JOIN SCM_MST_COUNTRY AS CO  WITH(NOLOCK)            ' + char(10);
	    SET @mDqry = @mDQry + '   ON f.COUNTRY = CO.COUNTRY                              ' + char(10);
        SET @mDqry = @mDQry + ' LEFT JOIN SCM_MST_CITY AS CT  WITH(NOLOCK)               ' + char(10);
	    SET @mDqry = @mDQry + '   ON (    f.COUNTRY = CT.COUNTRY                         ' + char(10);
	    SET @mDqry = @mDQry + '  AND f.CITY    = CT.CITY )	                             ' + char(10);
		SET @mDqry = @mDQry + ' 	  WHERE 1=1                                                                                                               ' + char(10);
		SET @mDqry = @mDQry + ' 		AND (a.shipment_status IS NOT NULL AND isnull(a.shipment_status,'''') != '''') '+char(10);
		SET @mDqry = @mDQry + ' 		AND a.qty > 0 '+char(10);
		
		SET @mDqry = @mDQry + ' ORDER BY a.division_id, a.shipment_status, a.yyyymmdd,  a.item_id, a.ERP_SO_NO DESC, a.from_site, a.to_site, a.project_code, a.fcst_type     ' + char(10);
	END
	ELSE
	BEGIN
			SET @mDqry = @mDQry + ' SELECT  AA.*  FROM      																										' + char(10);
			SET @mDqry = @mDQry + '  ( ' + char(10);
			SET @mDqry = @mDQry + ' 	SELECT							' + char(10);
			SET @mDqry = @mDQry + '			T0.DIVISION_ID					' + char(10);
			SET @mDqry = @mDQry + '			, T0.ERP_SO_NO                 ' + char(10);
			SET @mDqry = @mDQry + '			, T0.SHIPMENT_STATUS           ' + char(10);
			SET @mDqry = @mDQry + '			, T0.PROJECT_CODE              ' + char(10);
			SET @mDqry = @mDQry + '			, T0.PROJECT_NAME              ' + char(10);
			SET @mDqry = @mDQry + '			, T0.FCST_TYPE                 ' + char(10);
			SET @mDqry = @mDQry + '			, T0.ITEM_ID                   ' + char(10);
			SET @mDqry = @mDQry + '			, T0.NICK_NAME                 ' + char(10);
			SET @mDqry = @mDQry + '			, T0.SHIPMENT_DATE             ' + char(10);
			--SET @mDqry = @mDQry + '			, 0 AS BEFORE_QTY			' + char(10);
			SET @mDqry = @mDQry + '			, T0.SHIPMENT_CONFIRM_QTY              ' + char(10);
			SET @mDqry = @mDQry + '			, T0.REMARKS                   ' + char(10);
			SET @mDqry = @mDQry + '			, T0.REMARKS2                  ' + char(10);
			SET @mDqry = @mDQry + '			, T0.REMARKS3					' + char(10);
			SET @mDqry = @mDQry + '			, T0.FROM_SITE                 ' + char(10);
			SET @mDqry = @mDQry + '			, T0.FROM_SITE_DESCRIPTION     ' + char(10);
			SET @mDqry = @mDQry + '			, T0.TO_SITE                   ' + char(10);
			SET @mDqry = @mDQry + '			, T0.TO_SITE_DESCRIPTION       ' + char(10);
			SET @mDqry = @mDQry + ' 		, T0.TO_SITE_SOLDTO_CODE		' + char(10);
			SET @mDqry = @mDQry + ' 		, T0.TO_SITE_SHIPTO_CODE		' + char(10);
			SET @mDqry = @mDQry + '			, T0.SOLDTO_DESCRIPTION        ' + char(10);
			SET @mDqry = @mDQry + '			, T0.SHIPTO_DESCRIPTION        ' + char(10);
			SET @mDqry = @mDQry + '			, T0.BOD_ID                    ' + char(10);
			SET @mDqry = @mDQry + '			, T0.INCOTERMS					' + char(10);
			SET @mDqry = @mDQry + '			, T0.TRANSPORT_MODE            ' + char(10);
			SET @mDqry = @mDQry + '			, T0.LT_DAY					' + char(10);
			SET @mDqry = @mDQry + '			, T0.ETD						' + char(10);
			SET @mDqry = @mDQry + '			, T0.ETA						' + char(10);
			SET @mDqry = @mDQry + '			, T0.EXPECTED_SHIPPING_DATE    ' + char(10);
			SET @mDqry = @mDQry + '			, T0.CONFIRM_ID                ' + char(10);
			SET @mDqry = @mDQry + '			, T0.UPDATED_BY           ' + char(10);
			SET @mDqry = @mDQry + '			, T0.UPDATED_DATE          ' + char(10);
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
			-- 20211118	SMS	수정 
			--SET @mDqry = @mDQry + ' 		, END_CUSTOMER AS END_CUSTOMER ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, CASE WHEN T0.END_CUSTOMER is not null and T0.END_CUSTOMER != ''-'' THEN T0.END_CUSTOMER ELSE isnull(L1.END_CUSTOMER, ''-'') END AS END_CUSTOMER ' + CHAR(10);

			SET @mDqry = @mDQry + ' 		, ''-'' AS ELECTRODE_YN ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ELECTRODE_TYPE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ORIGIN_FROM_DIVISION_ID ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ORIGIN_TO_DIVISION_ID ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, T0.CHANGE_REQ_NO AS CHANGE_REQ_NO ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, T0.MODEL_USER AS MODEL_USER   ' + CHAR(10);
			-- 20211118	SMS	수정 
			--SET @mDqry = @mDQry + ' 		, T0.MTK_OWNER AS MTK_OWNER   ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, CASE WHEN T0.MTK_OWNER is not null and T0.MTK_OWNER != ''-''  and T0.MTK_OWNER != '''' THEN T0.MTK_OWNER ELSE DBO.FN_GET_SSP_MKT_OWNER_NAME (L1.OWNER, '','', '''+@p_language+''') END AS MTK_OWNER ' + CHAR(10);

			SET @mDqry = @mDQry + ' 		, T0.REQUESTOR AS REQUESTOR   ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS CHANGE_REASON_CODE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS CHANGE_REASON_DETAIL ' + CHAR(10);
			-- 221219 jilee 오창 출하 물류 R&R 관련 F.Destination 정보 활용 방안 (요청자:임화영)
			SET @mDqry = @mDQry + ' 		 , b.A_COUNTRY              ' + char(10);
			SET @mDqry = @mDQry + ' 		 , b.A_PORT_CODE            ' + char(10);
			SET @mDqry = @mDQry + ' 		 , t8.A_PORT_NAME           ' + char(10);
			SET @mDqry = @mDQry + ' 		 , co.COUNTRY_NAME          ' + char(10);
			SET @mDqry = @mDQry + ' 		 , ct.CITY_NAME             ' + char(10);
			SET @mDqry = @mDQry + ' 		 , cm.SHIPTO_REGION_NAME    ' + char(10);    
			SET @mDqry = @mDQry + ' 		 , cm.SHIPTO_CITY_NAME      ' + char(10);
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
			SET @mDqry = @mDQry + '			FROM SSP_ANL_SHIP_PLAN_ALL TT0 WITH(NOLOCK)					' + char(10);
			SET @mDqry = @mDQry + '			JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)						' + char(10);
			SET @mDqry = @mDQry + '			ON TT0.ITEM_ID		= T.ITEM_ID								' + char(10);
			SET @mDqry = @mDQry + '			AND TT0.DIVISION_ID	= T.DIVISION_ID							' + char(10);
			SET @mDqry = @mDQry + '			AND TT0.COMPANY_ID  = T.COMPANY_ID						' + char(10);
			SET @mDqry = @mDQry + '			AND T.ITEM_TYPE		NOT IN (''Q'',''R'')					' + char(10);
			SET @mDqry = @mDQry + '			LEFT OUTER JOIN SSP_MST_MODEL_USER MU WITH(NOLOCK) 			' + char(10);
			SET @mDqry = @mDQry + '				ON MU.DIVISION_ID =TT0.ORIGIN_FROM_DIVISION_ID 			' + char(10);
			SET @mDqry = @mDQry + '				AND MU.FROM_SITE = TT0.FROM_SITE 						' + char(10);
			SET @mDqry = @mDQry + '				AND MU.ITEM_ID = TT0.ITEM_ID 							' + char(10);
			SET @mDqry = @mDQry + '				AND MU.VALID_YN = ''Y''									' + char(10);
			SET @mDqry = @mDQry + '			WHERE 1=1													' + char(10);
			SET @mDqry = @mDQry + '			  AND TT0.PLAN_START_YYYYMMDD = '+@p_plan_start_yyyymmdd +'	' + char(10);
			SET @mDqry = @mDQry + '			  AND TT0.DIVISION_ID		  = '''+@p_division_id +'''		' + char(10);
			--SET @mDqry = @mDQry + '			  AND TT0.DIVISION_ID		  = '+@p_division_id +'			' + char(10);
			SET @mDQry = @mDQry + ' 		  AND TT0.COMPANY_ID		  = '''+ @p_company_id     +''' '+char(10)
			SET @mDQry = @mDQry + '			  AND TT0.SHIPMENT_CONFIRM_QTY > 0							' + char(10);
			SET @mDQry = @mDQry + '			  AND TT0.OPERATION_GROUP <> ''E''							' + char(10);
			SET @mDqry = @mDQry + '			  AND TT0.YYYYMMDD >= '+ @p_from_yyyymmdd +' AND TT0.YYYYMMDD <= '+ @p_to_yyyymmdd +' ' + char(10);
			
			IF ( @v_division_id IS NOT NULL AND @v_division_id  != '')	SET @mDQry = @mDQry + ' AND  TT0.DIVISION_ID   IN ('+ @v_division_id +')'+char(10);  
			IF ( @v_item_id     IS NOT NULL AND @v_item_id		!= '')	SET @mDQry = @mDQry + ' AND  TT0.ITEM_ID       IN ('+ @v_item_id     +')'+char(10); 
			IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '')	SET @mDQry = @mDQry + ' AND  TT0.FROM_SITE     IN ('+ @v_from_site   +')'+char(10); 
			
			IF ( @p_dbl_flag = 'Y')
			BEGIN
				SET @mDQry = @mDQry + ' 					AND  TT0.yyyymmdd       = '''+ @p_from_yyyymmdd     +''' '+char(10)
			END
			ELSE
			BEGIN
				SET @mDqry = @mDQry + ' 	    AND TT0.yyyymmdd >= '''+ @p_from_yyyymmdd +'''		AND TT0.yyyymmdd <= '''+ @p_to_yyyymmdd +'''                                                    ' + char(10);

				IF ( @v_requestor     IS NOT NULL AND @v_requestor    != ''  )
				BEGIN
					SET @mDQry = @mDQry + ' 					AND  TT0.requestor       IN ( ' + char(10) ;
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
	
			SET @mDqry = @mDQry + '		) AS  T0 ' + char(10);
			-- 20211117	SMS	추가
			SET @mDqry = @mDQry + '			LEFT OUTER JOIN LOOK L1 (NOLOCK)' + char(10);
			SET @mDqry = @mDQry + '				ON T0.DIVISION_ID = L1.DIVISION_ID' + char(10);
			SET @mDqry = @mDQry + '			   AND T0.PROJECT_CODE = L1.PROJECT_CODE' + char(10);
			SET @mDqry = @mDQry + '			   AND T0.to_site_description = L1.to_site_description' + char(10);
			SET @mDqry = @mDQry + '			   AND T0.item_id = L1.item_id' + char(10);
			-- 221219 jilee 오창 출하 물류 R&R 관련 F.Destination 정보 활용 방안 (요청자:임화영)
			SET @mDqry = @mDQry + '         LEFT JOIN SCM_MST_SITE f WITH(NOLOCK)                    ' + char(10);  
			SET @mDqry = @mDQry + '             ON f.division_id = T0.DIVISION_ID                    ' + char(10); 
			SET @mDqry = @mDQry + '			   AND f.SCM_SITE_ID = T0.TO_SITE                        ' + char(10);
/*	NERP 적용시 GERP COMPANY_ID에 해당하는 것은 제외 필요함 */	
			SET @mDqry = @mDqry + '			AND  F.VALID_YN = ''Y''									 '+ char(10);		
			SET @mDqry = @mDQry + '        LEFT JOIN  scp_mst_bod_n_v b WITH(NOLOCK)                 ' + char(10);
		    SET @mDqry = @mDQry + ' 	       ON (CASE WHEN T0.DIVISION_ID = ''EE'' THEN T0.ORIGIN_FROM_DIVISION_ID ELSE T0.DIVISION_ID END) = b.division_id  AND T0.bod_id = b.bod_id  ' + char(10);
            SET @mDqry = @mDQry + '         LEFT JOIN SCP_MST_DISTRIBUTION_ROUTE T8  WITH(NOLOCK)    ' + char(10);                                                                                                                                                                               
    		SET @mDqry = @mDQry + '	           ON T8.ROUTE_ID = b.ROUTE_ID 				             ' + char(10);
			SET @mDqry = @mDQry + '         LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER AS C  WITH(NOLOCK) ' + char(10);
			SET @mDqry = @mDQry + '            ON (    f.DIVISION_ID = C.DIVISION_ID                 ' + char(10);
			SET @mDqry = @mDQry + '     	  AND f.SCM_SITE_ID = C.SCM_SITE_ID                      ' + char(10);
			SET @mDqry = @mDQry + '           AND C.REP_YN = ''Y''                                   ' + char(10); 
			SET @mDqry = @mDQry + '           AND C.VALID_YN = ''Y''                                 ' + char(10);
			SET @mDqry = @mDQry + '	              )                                                  ' + char(10);
		    SET @mDqry = @mDQry + '         LEFT JOIN SCM_MST_CUSTOMER  CM WITH(NOLOCK)              ' + char(10);   
			SET @mDqry = @mDQry + '            ON (    C.DIVISION_ID = CM.DIVISION_ID                ' + char(10);
			SET @mDqry = @mDQry + '           AND C.SOLDTO_CODE = CM.SOLDTO_CODE                     ' + char(10); 
			SET @mDqry = @mDQry + '           AND C.SHIPTO_CODE = CM.SHIPTO_CODE                     ' + char(10);
			SET @mDqry = @mDQry + '      	      )                                                  ' + char(10);
			SET @mDqry = @mDQry + '         LEFT JOIN SCM_MST_COUNTRY AS CO  WITH(NOLOCK)            ' + char(10); 
			SET @mDqry = @mDQry + '	           ON f.COUNTRY = CO.COUNTRY                             ' + char(10);
			SET @mDqry = @mDQry + '         LEFT JOIN SCM_MST_CITY AS CT  WITH(NOLOCK)               ' + char(10);
			SET @mDqry = @mDQry + '        	   ON (    f.COUNTRY = CT.COUNTRY                        ' + char(10);
			SET @mDqry = @mDQry + '		      AND f.CITY    = CT.CITY )                              ' + char(10);  
			SET @mDqry = @mDQry + ' ) AS  AA ' + char(10);

			SET @mDqry = @mDQry + ' ORDER BY AA.division_id, AA.shipment_status, AA.shipment_date,  AA.item_id, AA.ERP_SO_NO DESC , AA.from_site, AA.to_site, AA.project_code, AA.fcst_type     ' + char(10);
	END

	--select @mDQry;
	IF( @debug_mode <> 'S')
	BEGIN
		EXEC (@mDQry);
	END 

	IF( @debug_mode ='T')
	BEGIN
		DECLARE @POS INT =1;
		DECLARE @LEN INT =LEN(@mDQry);
		WHILE @POS <= @LEN
			BEGIN
				PRINT SUBSTRING(@mDQry,@POS,4000);
				SET @POS = @POS+4000;
			END;
	END
	else IF( @debug_mode ='S')
	BEGIN
		SELECT @mDQry as 'QUERY'
		--DECLARE @POS INT =1;
		--DECLARE @LEN INT =LEN(@mDQry);
		--WHILE @POS <= @LEN
		--	BEGIN
		--		PRINT SUBSTRING(@mDQry,@POS,4000);
		--		SET @POS = @POS+4000;
		--	END;

	END;




END
