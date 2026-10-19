

/*
 * Program ID   : SSP0001_GET_SHIPMENT_PLAN_CONFIRM_DETAIL
 * Description  : Shipment Plan Confrim Detail
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/10   byunghunjung   Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/05/30   ygkim			project name 가져오는 부분 수정
 * 2018/06/04   ygkim		    seq 파라미터 추가
 * 2018/07/03   ygkim			ComfirmID 컬럼 수정
 * 2018/07/11   ygkim			LAST_UPDATED_BY, LAST_UPDATE_DATE, CHANGE_REQ_NO 컬럼 추가
 * 2018/07/16   ygkim			LAST_UPDATED_BY, LAST_UPDATE_DATE, CHANGE_REQ_NO 가져오는 쿼리 변경
 * 2018/07/24   ygkim			Plan Qty, LAST_UPDATED_BY 가져오는 쿼리 수정
 * 2018/09/03   ygkim			Division 'EE' 추가에 따른 쿼리 수정
 * 2018/10/25   ygkim			Division 40 일 경우 Project Name -> Project Code로 
 * 2019/02/13   hwyoon			[CSR ID:3907873] SSP Distribution route/BOD상 'L/T TYPE'컬럼 추가요청
 ex) 
  EXEC SSP0001_GET_SHIPMENT_PLAN_CONFIRM_DETAIL @p_division_id='81', @p_from_site='A040-A', @p_item_id='ACEN1042I-A1', @p_plan_start_yyyymmdd='20180409', @p_plan_type='SP', @p_yyyymmdd='20180423', @p_user_id='20140001', @p_program_id='SSP0001', @p_sheet_name='Shipment Plan Confirm Detail', @debug_mode='F'

 */

CREATE PROCEDURE [dbo].[SSP0001_GET_SHIPMENT_PLAN_CONFIRM_DETAIL]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd NVARCHAR(8)
	,@p_plan_type			NVARCHAR(50)
	,@p_yyyymmdd			NVARCHAR(8)
	,@p_seq					NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_program_id			NVARCHAR(MAX) = 'SSP0001' 
	,@p_sheet_name			NVARCHAR(MAX) = 'Shipment Plan Confirm Detail'
	,@debug_mode			NVARCHAR(1)='F'
	,@p_language			NVARCHAR(MAX) = 'KO'

AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT a.division_id
		 , a.plan_start_yyyymmdd
		 , a.plan_type
		 , a.seq
		 , a.item_id
		 , a.from_site
		 , isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id , a.to_site ),'-') as to_site_description
		 , a.to_site
		 , a.yyyymmdd
		 , a.bod_id
		 , a.biz_type 
		 , (SELECT TOP 1 b.segment2  FROM scm_adm_lookup_master_detail b   WHERE b.valid_yn = 'Y'   AND b.lookup_type = 'BIZ_TYPE'   AND b.segment1 = a.biz_type   ) AS biz_type_name 
		 , a.project_code
		 --, [dbo].[FN_GET_PROJECT_NAME](a.division_id,a.project_code) as project_name
		 , case when a.DIVISION_ID = '40' then a.PROJECT_CODE else [dbo].[FN_GET_PROJECT_NAME](CASE WHEN a.division_id = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END,a.project_code) end as project_name
		 --,( SELECT TOP 1 pp.project_name FROM scm_mst_project_item pi(NOLOCK),scm_mst_project pp  WHERE pi.project_code = pp.project_code	AND pi.item_id = a.item_id AND pi.PROJECT_CODE = a.PROJECT_CODE ) AS project_name

		 --, dbo.fn_get_item_nickname( a.division_id, a.item_id ) AS nick_name
		 --, dbo.fn_get_site_customer_info( a.division_id, a.to_site, 'SOLDTO_DESCRIPTION' ) AS soldto_description
		 --, dbo.fn_get_site_customer_info( a.division_id, a.to_site, 'SHIPTO_DESCRIPTION' ) AS shipto_description
		 
		 -- 전극추가(8/29, LJH)
		 , dbo.fn_get_item_nickname( CASE WHEN a.division_id = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, a.item_id ) AS nick_name
		 , dbo.fn_get_site_customer_info(CASE WHEN a.division_id = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, a.to_site, 'SOLDTO_DESCRIPTION' ) AS soldto_description
		 , dbo.fn_get_site_customer_info(CASE WHEN a.division_id = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, a.to_site, 'SHIPTO_DESCRIPTION' ) AS shipto_description


		 
		 , b.lt_total as lt_day
		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23) AS etd
		 , CONVERT(VARCHAR(10), ( CONVERT(DATETIME, a.yyyymmdd,112) + b.lt_total ), 23) AS eta
		 , b.incoterms
		 , b.transport_mode
		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.yyyymmdd,112), 23)  AS plan_date
		 , ISNULL(MAX(a.confirm_flag),'N') AS confirm_flag
		 --, SUM(CASE WHEN a.measure ='SHIP_PLAN' THEN a.qty END ) AS plan_qty
		 --, SUM(CASE WHEN a.measure ='SHIP_CONFIRM' THEN a.qty END ) AS confirm_qty	 
		 ,SUM(F.plan_qty) AS plan_qty
		 ,SUM(A.qty) AS confirm_qty
		 , a.fcst_type
		 --, max(a.confirm_id)  confirm_id
		 , a.confirm_id
		 , d.ERP_SO_NO
		 ,CASE WHEN U.UserName is null THEN a.LAST_UPDATED_BY ELSE CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + c.LAST_UPDATED_BY + ')' END LAST_UPDATED_BY
		 ,CASE WHEN c.LAST_UPDATE_DATE is null then a.LAST_UPDATE_DATE else c.LAST_UPDATE_DATE end LAST_UPDATE_DATE
		 ,c.CHANGE_REQ_NO
		 ,a.origin_from_division_id
		 ,b.lt_type
		FROM ssp_anl_ship_plan  a 
		-- INNER JOIN SCP_MST_BOD_N_V      b ON a.division_id = b.division_id AND a.bod_id = b.bod_id

		--전극추가(8/29, LJH)
		INNER JOIN SCP_MST_BOD_N_V      b ON CASE WHEN a.division_id = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END = b.division_id AND a.bod_id = b.bod_id
		LEFT OUTER JOIN ( SELECT A.CONFIRM_ID, LAST_UPDATED_BY, LAST_UPDATE_DATE, CHANGE_REQ_NO
							FROM SSP_ANL_SHIP_CONFIRM_H A
							WHERE a.HISTORY_SEQ = (select max(HISTORY_SEQ) from SSP_ANL_SHIP_CONFIRM_H b where a.CONFIRM_ID = b.CONFIRM_ID group by CONFIRM_ID)
					) c on a.CONFIRM_ID = c.CONFIRM_ID
		LEFT OUTER JOIN TB_FX_User U ON c.LAST_UPDATED_BY = u.UserID AND U.UseYN = 'Y' 
		LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM d on a.CONFIRM_ID = d.CONFIRM_ID and d.ERP_STATUS <> 'B' 
		--INNER JOIN (select a.division_id
		--					 , a.plan_start_yyyymmdd
		--					 , a.plan_type
		--					 , a.seq
		--					 , a.item_id
		--					 , a.from_site
		--					 , a.to_site
		--					 , a.yyyymmdd
		--					 , a.bod_id
		--					 , a.biz_type 
		--					 , a.project_code
		--					 , a.fcst_type
		--					 , a.confirm_id
		--				  ,max(LAST_UPDATE_DATE) LAST_UPDATE_DATE
		--			from ssp_anl_ship_plan a
		--			where 1=1
		--			    AND a.division_id         = @p_division_id
		--				AND a.plan_start_yyyymmdd = @p_plan_start_yyyymmdd
		--				AND a.plan_type           = @p_plan_type
		--				AND a.from_site           = @p_from_site
		--				AND a.item_id             = @p_item_id
		--				AND a.yyyymmdd            = @p_yyyymmdd
		--				AND a.seq				  = @p_seq
		--				AND a.measure = 'SHIP_CONFIRM'
		--			GROUP BY  a.division_id
		--					 , a.plan_start_yyyymmdd
		--					 , a.plan_type
		--					 , a.seq
		--					 , a.item_id
		--					 , a.from_site
		--					 , a.to_site
		--					 , a.yyyymmdd
		--					 , a.bod_id
		--					 , a.biz_type 
		--					 , a.project_code
		--					 , a.fcst_type
		--					 , a.confirm_id) E ON a.DIVISION_ID = e.DIVISION_ID and a.PLAN_START_YYYYMMDD = e.PLAN_START_YYYYMMDD
		--					                    and a.PLAN_TYPE = e.PLAN_TYPE and a.SEQ = e.SEQ and a.ITEM_ID = e.ITEM_ID
		--										and a.FROM_SITE = e.FROM_SITE and a.YYYYMMDD = e.YYYYMMDD
		--										AND a.CONFIRM_ID = e.CONFIRM_ID AND A.TO_SITE = E.TO_SITE AND A.PROJECT_CODE = E.PROJECT_CODE
		--										AND A.FCST_TYPE = E.FCST_TYPE AND A.LAST_UPDATE_DATE = E.LAST_UPDATE_DATE
		INNER JOIN (select a.division_id
							 , a.plan_start_yyyymmdd
							 , a.plan_type
							 , a.seq
							 , a.item_id
							 , a.from_site
							 , a.to_site
							 , a.yyyymmdd
							 , a.bod_id
							 , a.biz_type 
							 , a.project_code
							 , a.fcst_type
							 , a.confirm_id
						  ,SUM(QTY) plan_qty
					from ssp_anl_ship_plan a
					where 1=1
					    AND a.division_id         = @p_division_id
						AND a.plan_start_yyyymmdd = @p_plan_start_yyyymmdd
						AND a.plan_type           = @p_plan_type
						AND a.from_site           = @p_from_site
						AND a.item_id             = @p_item_id
						AND a.yyyymmdd            = @p_yyyymmdd
						AND a.seq				  = @p_seq
						AND a.measure = 'SHIP_PLAN'
					GROUP BY  a.division_id
							 , a.plan_start_yyyymmdd
							 , a.plan_type
							 , a.seq
							 , a.item_id
							 , a.from_site
							 , a.to_site
							 , a.yyyymmdd
							 , a.bod_id
							 , a.biz_type 
							 , a.project_code
							 , a.fcst_type
							 , a.confirm_id) F ON a.DIVISION_ID = f.DIVISION_ID and a.PLAN_START_YYYYMMDD = f.PLAN_START_YYYYMMDD
							                    and a.PLAN_TYPE = f.PLAN_TYPE and a.SEQ = f.SEQ and a.ITEM_ID = f.ITEM_ID
												and a.FROM_SITE = f.FROM_SITE and a.YYYYMMDD = f.YYYYMMDD
												AND a.CONFIRM_ID = f.CONFIRM_ID and A.TO_SITE = F.TO_SITE AND A.PROJECT_CODE = F.PROJECT_CODE
												AND A.FCST_TYPE = F.FCST_TYPE
	  WHERE 1=1
		AND a.measure = 'SHIP_CONFIRM' --IN ( 'SHIP_PLAN','SHIP_CONFIRM')
		AND a.division_id         = @p_division_id
		AND a.plan_start_yyyymmdd = @p_plan_start_yyyymmdd
		AND a.plan_type           = @p_plan_type
		AND a.from_site           = @p_from_site
		AND a.item_id             = @p_item_id
		AND a.yyyymmdd            = @p_yyyymmdd
		AND a.seq				  = @p_seq
		-- AND isnull(a.qty,0)       <> 0
	 GROUP BY  a.division_id
			 , a.plan_start_yyyymmdd
			 , a.plan_type
			 , a.seq
			 , a.item_id
			 , a.from_site
			 , a.to_site
			 , a.yyyymmdd
			 , a.bod_id
			 , a.biz_type 
			 , a.project_code
			 , b.lt_total
			 , b.incoterms
			 , b.transport_mode
			 , a.fcst_type
			 , a.confirm_id
			 ,CASE WHEN U.UserName is null THEN a.LAST_UPDATED_BY ELSE CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + c.LAST_UPDATED_BY + ')' END
		     ,CASE WHEN c.LAST_UPDATE_DATE is null then a.LAST_UPDATE_DATE else c.LAST_UPDATE_DATE end
			 , c.CHANGE_REQ_NO
			 , d.ERP_SO_NO
			 , A.ORIGIN_FROM_DIVISION_ID -- 전극추가(8/29, LJH)
			 , b.lt_type
			 --, a.confirm_flag
	--SELECT
	--	 a.biz_type 
	--	 ,( SELECT TOP 1 b.segment2  FROM scm_adm_lookup_master_detail b   WHERE b.valid_yn = 'Y'   AND b.lookup_type = 'BIZ_TYPE'   AND b.segment1 = a.biz_type   ) AS biz_type_name 
	--	,a.project_code
	--	,( SELECT TOP 1 pp.project_name FROM scm_mst_project_item pi(NOLOCK),scm_mst_project pp(NOLOCK)
	--	   WHERE pi.project_code = pp.project_code	AND pi.item_id = a.item_id ) AS project_name
	--	, a.item_id
	--	, dbo.FN_GET_ITEM_NICKNAME( a.division_id, a.item_id ) AS nick_name
	--	, a.to_site
	--	, dbo.FN_GET_SITE_CUSTOMER_INFO( a.division_id, a.to_site, 'SOLDTO_DESCRIPTION' ) AS SOLDTO_DESCRIPTION
	--	, dbo.FN_GET_SITE_CUSTOMER_INFO( a.division_id, a.to_site, 'SHIPTO_DESCRIPTION' ) AS SHIPTO_DESCRIPTION
	--	, c.lt_total AS LT_DAY
	--	, CONVERT(char(10),   CONVERT(datetime, a.yyyymmdd,112), 23) AS ETD
	--	, CONVERT(char(10), ( CONVERT(datetime, a.yyyymmdd,112) + c.lt_total ), 23) AS ETA
	--	, c.incoterms
	--	, c.transport_mode
	--	, a.bod_id
	--	, CONVERT(char(10),   CONVERT(datetime, a.yyyymmdd,112), 23)  AS plan_date
	--	, CONVERT(INT,a.qty) AS plan_qty
	--	, a.confirm_flag
	--FROM SSP_ANL_SHIP_PLAN  a INNER JOIN 
	--      SCP_MST_BOD_N_V     c ON a.division_id = c.division_id 
	--	                     AND a.bod_id      = c.bod_id
	--WHERE 1=1
	--AND a.measure  IN ( 'SHIP_PLAN','')
	--AND a.division_id         = @p_division_id
	--AND a.plan_start_yyyymmdd = @p_plan_start_yyyymmdd
	--AND a.plan_type           = @p_plan_type
	--AND a.from_site           = @p_from_site
	--AND a.item_id             = @p_item_id
	--and a.yyyymmdd            = @p_yyyymmdd
END

