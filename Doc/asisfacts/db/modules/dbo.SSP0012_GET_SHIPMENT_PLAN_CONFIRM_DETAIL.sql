/*
 * Program ID   : SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL
 * Description  : Shipment Plan Confrim Detail
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/07/24   ygkim			Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/07/25	ygkim			order by 추가
 * 2018/08/14   ygkim			Departure Port, Arrival Port, Depature days, Lead Time 컬럼 추가
 * 2018/09/03   ygkim			Division 'EE' 추가로 인한 쿼리 수정
 * 2018/10/23   ygkim			속도 개선
 * 2018/10/25   ygkim			Division 40 일 경우 Project Name -> Project Code로
 * 2018/11/01	hwyoon			owner 조회항목 추가
 * 2019/02/13	hwyoon			[CSR ID:3907873] SSP Distribution route/BOD상 'L/T TYPE'컬럼 추가요청
 * 2019-03-22   mcthej          Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
 * 2019-03-28   mcthej			MasterTable ssp_anl_ship_plan -> SSP_ANL_SHIP_CONFIRM 변경으로 인한 프로시저 전체 변경(Org BackUp : SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL_20190328)
 * 2019/12/17	KIMYONGHO		[C20191216-000311] Expected Shipping Date 컬럼 추가
 * 2021/09/02   KIMYONGHO      SCP_MST_BOD_N_V -> SCP_MST_BOD_N_V 변경
 * 2022/04/20	SMS	            가상디비젼관련 추가   81, 81_GM에 같은 SCM_SITE_ID 가 존재해서 Division_id 도 비교
 ex) 
 EXEC SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL @p_division_id='40,81,82,EE', @p_from_site='', @p_item_id=''
 , @p_from_yyyymmdd='20190329', @p_to_yyyymmdd='20190522', @p_Sold_To_Party='', @p_Ship_To_Party='', @debug_mode='F', @p_language='KO'
 */

CREATE PROCEDURE [dbo].[SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_from_yyyymmdd		NVARCHAR(MAX)
	,@p_to_yyyymmdd			NVARCHAR(MAX)
	,@p_Sold_To_Party		NVARCHAR(MAX) =''
	,@p_Ship_To_Party		NVARCHAR(MAX) = ''
	,@debug_mode			NVARCHAR(1)='F'
	,@p_language			NVARCHAR(MAX) = 'KO'

AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/	
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SSP0012') IS NOT NULL
		   DROP TABLE #TblDynamicPivot_SSP0012 

    create table #TblDynamicPivot_SSP0012(
		 division_id NVARCHAR(60)
		,plan_start_yyyymmdd NVARCHAR(8)
		,plan_type NVARCHAR(50)
		,seq int
		,item_id NVARCHAR(50)
		,from_site NVARCHAR(30)
		,from_site_description NVARCHAR(max)
		,to_site_description NVARCHAR(max)
		,to_site NVARCHAR(30)
		,yyyymmdd NVARCHAR(8)
		,bod_id NVARCHAR(150)
		,biz_type NVARCHAR(30)
		,biz_type_name NVARCHAR(100)
		,project_code NVARCHAR(50)
		,project_name NVARCHAR(max)
		,nick_name NVARCHAR(max)
		,soldto_description NVARCHAR(max)
		,shipto_description NVARCHAR(max)
		,lt_day int
		,etd NVARCHAR(10)
		,eta NVARCHAR(10)
		,incoterms NVARCHAR(10)
		,transport_mode NVARCHAR(10)
		,plan_date NVARCHAR(10)
		,Expected_Shipping_Date NVARCHAR(10)
		,confirm_flag NVARCHAR(2)
		,plan_qty INT
		,confirm_qty INT
		,fcst_type NVARCHAR(20)
		,confirm_id NVARCHAR(20)
		,ERP_SO_NO NVARCHAR(50)
		,LAST_UPDATED_BY NVARCHAR(150)
		,LAST_UPDATE_DATE DATETIME
		,CHANGE_REQ_NO NVARCHAR(20)
		,d_port_name NVARCHAR(50)
		,d_country NVARCHAR(3)
		,d_port_code NVARCHAR(10)
		,a_port_name NVARCHAR(50)
		,a_country NVARCHAR(3)
		,a_port_code NVARCHAR(10)
		,days_mon NVARCHAR(1)
		,days_tue NVARCHAR(1)
		,days_wed NVARCHAR(1)
		,days_thu NVARCHAR(1)
		,days_fri NVARCHAR(1)
		,days_sat NVARCHAR(1)
		,days_sun NVARCHAR(1)
		,lt_departure_inland INT
		,lt_wait_shipping INT
		,lt_voyage INT
		,lt_lay_off_clearance INT
		,lt_arrival_inland INT
		,lt_sum INT
		,origin_from_division_id NVARCHAR(30)
		,MTK_OWNER NVARCHAR(150)
		,lt_type NVARCHAR(100)
		,BUILDING NVARCHAR(510)
		,CUST_REQUIREMENT NVARCHAR(510)
		,REMARKS NVARCHAR(510)
	);

	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
	DECLARE @mDQry NVARCHAR(MAX)='';
	
	DECLARE  @v_division_id NVARCHAR(MAX)='';
	DECLARE  @v_from_site NVARCHAR(MAX)='';
	DECLARE  @v_item_id NVARCHAR(MAX)='';
	
	--IN 조건으로 데이터를 가져옴
	SET @v_division_id = [dbo].FN_GET_IN_STR(@p_division_id);
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);

	SET @mDQry = @mDQry + ' INSERT INTO #TblDynamicPivot_SSP0012	                          																																								' + char(10) ;
	SET @mDQry = @mDQry + ' SELECT 																																																							' + char(10) ;
	SET @mDQry = @mDQry + ' 	*                                                                                                                                                                                                                           ' + char(10) ;
	SET @mDQry = @mDQry + ' FROM                                                                                                                                                                                                                            ' + char(10) ;
	SET @mDQry = @mDQry + ' (                                                                                                                                                                                                                               ' + char(10) ;
	SET @mDQry = @mDQry + ' 	SELECT                                                                                                                                                                                                                      ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T0.DIVISION_ID,				T0.PLAN_START_YYYYMMDD,				T0.PLAN_TYPE,				max(T0.SEQ) AS SEQ,				T0.ITEM_ID,                                                                                 ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T0.FROM_SITE,				MAX(ISNULL(T1.SITE_DESCRIPTION, ''-'')) AS FROM_SITE_DESCRIPTION,                                                                                                                           ' + char(10) ;
	SET @mDQry = @mDQry + ' 		MAX(ISNULL(T2.SITE_DESCRIPTION, ''-'')) AS T0_SITE_DESCRIPTION,	T0.TO_SITE,                                                                                                                                             ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T0.YYYYMMDD,				T0.BOD_ID,                                                                                                                                                                                  ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T0.BIZ_TYPE,				(SELECT TOP 1 A.SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WHERE A.VALID_YN = ''Y''   AND A.LOOKUP_TYPE = ''BIZ_TYPE''   AND A.SEGMENT1 = T0.BIZ_TYPE ) AS BIZ_TYPE_NAME,                 ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T0.PROJECT_CODE, MAX(ISNULL(                                                                                                                                                                                                             ' + char(10) ;
	SET @mDQry = @mDQry + ' 					CASE WHEN T0.DIVISION_ID = ''40'' THEN T0.PROJECT_CODE                                                                                                                                                      ' + char(10) ;
	SET @mDQry = @mDQry + ' 						 ELSE T3.PROJECT_NAME END                                                                                                                                                                               ' + char(10) ;
	SET @mDQry = @mDQry + ' 		, ''-'')) AS PROJECT_NAME,																																																' + char(10) ;
	SET @mDQry = @mDQry + ' 		(SELECT TOP 1 ISNULL(NICK_NAME,''-'') FROM DBO.SCM_MST_ITEM_SN WITH(NOLOCK) WHERE 1=1 AND ITEM_ID = T0.ITEM_ID) NICK_NAME,                                                                                              ' + char(10) ;
	SET @mDQry = @mDQry + ' 		ISNULL(NULLIF(dbo.fn_get_site_customer_info( (CASE WHEN T0.DIVISION_ID = ''EE'' THEN T0.ORIGIN_FROM_DIVISION_ID else T0.DIVISION_ID end), T0.TO_SITE, ''SOLDTO_DESCRIPTION'' ),''''),''-'') AS SOLDTO_DESCRIPTION, 	    ' + char(10) ;
	SET @mDQry = @mDQry + ' 		ISNULL(NULLIF(dbo.fn_get_site_customer_info( (CASE WHEN T0.DIVISION_ID = ''EE'' THEN T0.ORIGIN_FROM_DIVISION_ID else T0.DIVISION_ID end), T0.TO_SITE, ''SHIPTO_DESCRIPTION'' ),''''),''-'') AS SHIPTO_DESCRIPTION,      ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T4.lt_total AS IT_DAY,                                                                                                                                                                                                  ' + char(10) ;
--	SET @mDQry = @mDQry + ' 		CONVERT(VARCHAR(10), CONVERT(DATETIME, T0.YYYYMMDD, 112), 23) AS ETD, CONVERT(VARCHAR(10), (CONVERT(DATETIME, T0.YYYYMMDD,112) + T4.lt_total), 23) AS ETA,                                        ' + char(10) ;
	SET @mDQry = @mDQry + ' 		CONVERT(VARCHAR(10), CONVERT(DATETIME, T0.YYYYMMDD, 112), 23) AS ETD, CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_ETA_DATE](T0.DIVISION_ID, T0.BOD_ID, T0.YYYYMMDD), 112), 23) AS ETA,                     ' + char(10) ;
	-- 20201223 incoterms 변경 작업 modify KIMYONGHO
	SET @mDQry = @mDQry + ' 		T4.ssp_incoterms AS INCOTERMS,				T4.transport_mode,					CONVERT(VARCHAR(10), CONVERT(DATETIME, T0.YYYYMMDD, 112), 23) AS PLAN_DATE,                                                                             ' + char(10) ;
--	SET @mDQry = @mDQry + ' 		CASE WHEN T4.transport_mode = ''TRK'' then ''-'' else CONVERT(VARCHAR(10), CONVERT(DATETIME, DATEADD(D, T4.lt_departure_inland + T4.lt_wait_shipping, T0.YYYYMMDD), 112), 23) end as Expected_Shipping_Date,            ' + char(10) ;
	SET @mDQry = @mDQry + ' 		CASE WHEN T4.transport_mode = ''TRK'' then ''-'' else CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](T0.DIVISION_ID, T0.BOD_ID, T0.YYYYMMDD), 112), 23) end as Expected_Shipping_Date,    ' + char(10) ;
	SET @mDQry = @mDQry + ' 		CASE WHEN T0.CHANGE_TYPE = ''P'' THEN ''N'' ELSE ''Y'' END AS CONFIRM_FLAG,		SUM(T0.PLANNED_QTY) AS PLAN_QTY,	SUM(T0.QTY) AS CONFIRM_QTY,                                                                         ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T0.FCST_TYPE,				CASE WHEN SUBSTRING(T0.CONFIRM_ID, 1, 1) = ''P'' THEN ''-'' ELSE T0.CONFIRM_ID END CONFIRM_ID,			T5.ERP_SO_NO,                                                               ' + char(10) ;
	SET @mDQry = @mDQry + ' 		CASE WHEN T7.UserName is null THEN T0.LAST_UPDATED_BY ELSE CASE WHEN ''' +  @p_language + ''' = ''KO'' THEN T7.UserName ELSE T7.UserName_E END + ''('' + T6.LAST_UPDATED_BY + '')'' END LAST_UPDATED_BY,                ' + char(10) ;
	SET @mDQry = @mDQry + ' 		CASE WHEN T6.LAST_UPDATE_DATE is null then T0.LAST_UPDATE_DATE else T6.LAST_UPDATE_DATE end LAST_UPDATE_DATE,                                                                                                         ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T6.CHANGE_REQ_NO,			T8.d_port_name,						T4.d_country,					T4.d_port_code,			T8.a_port_name,				T4.a_country,                                                       ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T4.a_port_code,				T4.days_mon,						T4.days_tue,					T4.days_wed,			T4.days_thu,				T4.days_fri,                                                        ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T4.days_sat,				T4.days_sun,						T4.lt_departure_inland,			T4.lt_wait_shipping,	T4.lt_voyage,				T4.lt_lay_off_clearance,                                            ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T4.lt_arrival_inland,                                                                                                                                                                                                   ' + char(10) ;
	SET @mDQry = @mDQry + ' 		ISNULL(T4.lt_departure_inland,0)+ISNULL(T4.lt_wait_shipping,0)+ISNULL(T4.lt_voyage,0)+ISNULL(T4.lt_lay_off_clearance,0)+ISNULL(T4.lt_arrival_inland,0) AS lt_sum,                                                       ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T0.origin_from_division_id,										DBO.FN_GET_SSP_MKT_OWNER_NAME (T9.OWNER, '','', ''' + @p_language + ''') AS MTK_OWNER,		T4.lt_type                                                ' + char(10) ;
	SET @mDQry = @mDQry + ' 		,T0.REMARKS2 AS BUILDING,	T0.REMARKS3 AS CUST_REQUIREMENT,	T0.REMARKS' + char(10) ;
	SET @mDQry = @mDQry + ' 	FROM SSP_ANL_SHIP_CONFIRM T0  WITH(NOLOCK)                                                                                                                                                                                                ' + char(10) ;
	SET @mDQry = @mDQry + ' 	INNER JOIN SCM_MST_SITE T1  WITH(NOLOCK)                                                                                                                                                                                                  ' + char(10) ;
	SET @mDQry = @mDQry + ' 		ON T0.FROM_SITE = T1.SCM_SITE_ID                                                                                                                                                                                        ' + char(10) ;
	-- 20220420	SMS	가상디비젼관련 추가   81, 81_UC에 같은 SCM_SITE_ID 가 존재해서 Division_id 도 비교
	SET @mDQry = @mDQry + ' 	   AND T0.DIVISION_ID = T1.DIVISION_ID                                                                                                                                                                                        ' + char(10) ;

	SET @mDQry = @mDQry + ' 	INNER JOIN SCM_MST_SITE T2  WITH(NOLOCK)                                                                                                                                                                                                  ' + char(10) ;
	SET @mDQry = @mDQry + ' 		ON T0.TO_SITE = T2.SCM_SITE_ID                                                                                                                                                                                          ' + char(10) ;
	-- 20220420	SMS	가상디비젼관련 추가   81, 81_UC에 같은 SCM_SITE_ID 가 존재해서 Division_id 도 비교
	SET @mDQry = @mDQry + ' 	   AND T0.DIVISION_ID = T2.DIVISION_ID                                                                                                                                                                                          ' + char(10) ;

	SET @mDQry = @mDQry + ' 	LEFT JOIN DBO.SCM_MST_PROJECT T3 WITH(NOLOCK)                                                                                                                                                                               ' + char(10) ;
	SET @mDQry = @mDQry + ' 		ON T0.PROJECT_CODE = T3.PROJECT_CODE                                                                                                                                                                                    ' + char(10) ;
	SET @mDQry = @mDQry + ' 		AND T3.DIVISION_ID = (CASE WHEN T0.DIVISION_ID = ''EE'' THEN T0.ORIGIN_FROM_DIVISION_ID ELSE T0.DIVISION_ID END)                                                                                                        ' + char(10) ;
	--SET @mDQry = @mDQry + ' 	INNER JOIN scp_mst_bod_n_v T4                                                                                                                                                                                                 ' + char(10) ;
	SET @mDQry = @mDQry + ' 	INNER JOIN SCP_MST_BOD_N_V T4  WITH(NOLOCK)                                                                                                                                                                                                 ' + char(10) ;
	SET @mDQry = @mDQry + ' 		ON (CASE WHEN T0.DIVISION_ID  = ''EE'' THEN T0.ORIGIN_FROM_DIVISION_ID else T0.DIVISION_ID end) = T4.DIVISION_ID                                                                                                        ' + char(10) ;
	SET @mDQry = @mDQry + ' 		AND T0.BOD_ID = T4.BOD_ID                                                                                                                                                                                               ' + char(10) ;
	SET @mDQry = @mDQry + ' 	LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM T5  WITH(NOLOCK)                                                                                                                                                                                     ' + char(10) ;
	SET @mDQry = @mDQry + ' 		ON T5.CONFIRM_ID = T0.CONFIRM_ID                                                                                                                                                                                        ' + char(10) ;
	SET @mDQry = @mDQry + ' 		AND T5.ERP_STATUS <> ''B''                                                                                                                                                                                              ' + char(10) ;
	SET @mDQry = @mDQry + ' 	LEFT OUTER JOIN                                                                                                                                                                                                             ' + char(10) ;
	SET @mDQry = @mDQry + ' 	(                                                                                                                                                                                                                           ' + char(10) ;
	SET @mDQry = @mDQry + ' 		SELECT A.CONFIRM_ID, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.CHANGE_REQ_NO				                                                                                                                                ' + char(10) ;
	SET @mDQry = @mDQry + ' 		FROM SSP_ANL_SHIP_CONFIRM_H A  WITH(NOLOCK)													                                                                                                                                        ' + char(10) ;
	SET @mDQry = @mDQry + ' 		WHERE A.HISTORY_SEQ = (select max(B.HISTORY_SEQ) from SSP_ANL_SHIP_CONFIRM_H B where A.CONFIRM_ID = B.CONFIRM_ID group by B.CONFIRM_ID)	                                                                                ' + char(10) ;
	SET @mDQry = @mDQry + ' 	) T6                                                                                                                                                                                                                        ' + char(10) ;
	SET @mDQry = @mDQry + ' 		ON T0.CONFIRM_ID = T6.CONFIRM_ID                                                                                                                                                                                        ' + char(10) ;
	SET @mDQry = @mDQry + ' 	LEFT OUTER JOIN TB_FX_User T7  WITH(NOLOCK)                                                                                                                                                                                               ' + char(10) ;
	SET @mDQry = @mDQry + ' 		ON T6.LAST_UPDATED_BY = T7.UserID                                                                                                                                                                                       ' + char(10) ;
	SET @mDQry = @mDQry + ' 		AND T7.UseYN = ''Y''                                                                                                                                                                                                    ' + char(10) ;
	SET @mDQry = @mDQry + ' 	INNER JOIN SCP_MST_DISTRIBUTION_ROUTE T8  WITH(NOLOCK)                                                                                                                                                                                   ' + char(10) ;
	SET @mDQry = @mDQry + ' 			ON T8.ROUTE_ID = T4.ROUTE_ID                                                                                                                                                                                        ' + char(10) ;
	SET @mDQry = @mDQry + ' 	LEFT OUTER JOIN SCM_MST_SITE_ITEM T9 WITH(NOLOCK)                                                                                                                                                                           ' + char(10) ;
	SET @mDQry = @mDQry + ' 			ON T9.DIVISION_ID = (CASE WHEN T0.DIVISION_ID =''EE'' THEN T0.ORIGIN_TO_DIVISION_ID ELSE T0.DIVISION_ID END)                                                                                                        ' + char(10) ;
	SET @mDQry = @mDQry + ' 			AND T9.SCM_SITE_ID = T0.TO_SITE                                                                                                                                                                                     ' + char(10) ;
	SET @mDQry = @mDQry + ' 			AND T9.ITEM_ID = T0.ITEM_ID                                                                                                                                                                                         ' + char(10) ;
	SET @mDQry = @mDQry + ' 			AND T9.PROJECT_CODE = T0.PROJECT_CODE                                                                                                                                                                               ' + char(10) ;
	SET @mDQry = @mDQry + ' 	WHERE 1=1	                                                                                                                                                                                                                ' + char(10) ;
	SET @mDQry = @mDQry + ' 	  AND CONVERT(nVarchar(8), T0.YYYYMMDD, 112) >= ''' + @p_from_yyyymmdd  + '''                                                                                                                                               ' + char(10) ;
	SET @mDQry = @mDQry + ' 	  AND CONVERT(nVarchar(8), T0.YYYYMMDD, 112) <= ''' + @p_to_yyyymmdd + '''                                                                                                                                                  ' + char(10) ;
	SET @mDQry = @mDQry + ' 	  AND T0.QTY > 0 --OR T0.PLANNED_QTY > 0                                                                                                                                                                                    ' + char(10) ;
	IF ( @v_division_id IS NOT NULL AND @v_division_id    != '') SET @mDQry = @mDQry + ' 				AND  T0.DIVISION_ID   IN ('+ @v_division_id +')																										' + char(10);                     
	IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDQry = @mDQry + ' 					AND  T0.FROM_SITE     IN ('+ @v_from_site   +')																										' + char(10);                     
	IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mDQry = @mDQry + ' 					AND  T0.ITEM_ID       IN ('+ @v_item_id     +')																										' + char(10);         
	SET @mDQry = @mDQry + ' 	GROUP BY                                                                                                                                                                                                                    ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T0.DIVISION_ID,	T0.PLAN_START_YYYYMMDD,	T0.PLAN_TYPE, T0.ITEM_ID, T0.FROM_SITE,	T0.TO_SITE, T0.YYYYMMDD, T0.BOD_ID, T0.PROJECT_CODE,                                                                                    ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T0.BIZ_TYPE, T4.lt_total, T4.ssp_incoterms, T4.transport_mode, T4.lt_departure_inland, T4.lt_wait_shipping,	T0.FCST_TYPE, CASE WHEN SUBSTRING(T0.CONFIRM_ID, 1, 1) = ''P'' THEN ''-'' ELSE T0.CONFIRM_ID END, T5.ERP_SO_NO,                                                                      ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T7.UserName, T7.UserName_E, T0.LAST_UPDATED_BY, T6.LAST_UPDATED_BY, T0.LAST_UPDATE_DATE, T6.LAST_UPDATE_DATE,                                                                                                           ' + char(10) ;
	SET @mDQry = @mDQry + ' 		CASE WHEN T0.CHANGE_TYPE = ''P'' THEN ''N'' ELSE ''Y'' END,                                                                                                                                                             ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T6.CHANGE_REQ_NO, T8.d_port_name, T4.d_country, T4.d_port_code,                                                                                                                                                         ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T8.a_port_name, T4.a_country, T4.a_port_code, T4.days_mon, T4.days_tue, T4.days_wed, T4.days_thu, T4.days_fri, T4.days_sat, T4.days_sun, T4.lt_departure_inland,                                                        ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T4.lt_wait_shipping, T4.lt_voyage, T4.lt_lay_off_clearance,	T4.lt_arrival_inland, T4.lt_departure_inland, T4.lt_wait_shipping, T4.lt_voyage, T4.lt_lay_off_clearance,                                                   ' + char(10) ;
	SET @mDQry = @mDQry + ' 		T4.lt_arrival_inland, T0.origin_from_division_id, T9.OWNER, T4.lt_type, T0.REMARKS2, T0.REMARKS3, T0.REMARKS' + char(10) ;
	--SET @mDQry = @mDQry + ' , T0.REMARKS2, T0.REMARKS3, T0.REMARKS	' + char(10) ;
	SET @mDQry = @mDQry + ' ) TT                                                                                                                                                                                                                            ' + char(10) ;
	SET @mDQry = @mDQry + ' WHERE 1 = 1                                                                                                                                                                                                                     ' + char(10) ;
	IF (@p_Sold_To_Party IS NOT NULL AND @p_Sold_To_Party != '') SET @mDQry = @mDQry + ' 		and	TT.soldto_description like ''%'' + '''+@p_Sold_To_Party+''' + ''%''		' + char(10) ;
	IF (@p_Ship_To_Party IS NOT NULL AND @p_Ship_To_Party != '') SET @mDQry = @mDQry + ' 		and	TT.shipto_description like ''%'' + '''+@p_Ship_To_Party+''' + ''%''		' + char(10) ; 
	SET @mDQry = @mDQry + ' ORDER BY TT.DIVISION_ID, TT.FROM_SITE, TT.ITEM_ID, TT.TO_SITE, TT.YYYYMMDD, TT.PROJECT_CODE                                                                                                                                                      ' + char(10) ;
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

	SELECT *
	FROM #TblDynamicPivot_SSP0012
	order by division_id, from_site,item_id, to_site, yyyymmdd
END
