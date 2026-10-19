/*
 * Program ID   : PR_SSP_MAIL_SEND_BATCH_N
 * Description  : SSP Mail 발송
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/10/17   mcthej		  Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
 * 2019/10/23   mcthej		  Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT - REAL DATA로 수정
 * 2019/10/28   mcThej          BOH = BOH + MES_TOTAL - (MES_OQC_NG + MES_QMS/MES_HOLD)
 * 2020/01/21   juhlee          [C20200121-000352]  ESS Packer출하 적용 
                                 - [C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V) 
								 - [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외)  
                                 - [C20200121-000352]-3 : Production Plan Measure에 Paker생산계획 추가(SCP_ANL_PRODUCTION_PLAN 의 PROD_PLAN_AMEND measure) 
 * 2020/03/17   juhlee	        BOH 수량에 CMA_BMA 제외 (requested by 김광희)
 * 2020/07/09   juhlee         [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 전극 제외   
 * 2022/02/08   SSP Pjt.       SSP_DNM_MES_STOCK_81_82 -> SSP_DNM_GMES_STOCK_81_82
 * 2022/04/01   SSP Pjt.       JV DIVISION_ID 적용
 * 2023/10/10   jilee          @v_body_contents 강제 삭제 문구 제외
 * 2026.08.13	강주용		   [E20260811-000692] ESMI AZ 링크 2호기 생산계획 받아오지 못하는 현상 처리
 */
CREATE PROCEDURE [dbo].[PR_SSP_MAIL_SEND_BATCH_N]
	@p_company_id1				NVARCHAR(10),
	@p_log_messge				NVARCHAR(1000) OUTPUT
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @p_company_id  NVARCHAR(10); --속도개선을 위해 별도 DECLARE , SET설정 
	SET     @p_company_id = @p_company_id1 ;

	DECLARE @v_plan_start_yyyymmdd	NVARCHAR(8);
	DECLARE @v_from_yyyymmdd		NVARCHAR(8);
	DECLARE @v_to_yyyymmdd			NVARCHAR(8);

	DECLARE @v_site_from_yyyymmdd		NVARCHAR(8);
	DECLARE @v_site_to_yyyymmdd			NVARCHAR(8);

	DECLARE @v_boh_yyyymmdd			NVARCHAR(8);
	DECLARE @v_stock_yyyymmdd		NVARCHAR(8);

	DECLARE @v_program_id			NVARCHAR(50);
	DECLARE @v_sheet_name			NVARCHAR(50);

	DECLARE @v_fromsite_cnt			INT;
	DECLARE @v_fromsite_tmpcnt		INT;
	
	DECLARE @v_receiver_cnt			INT;
	DECLARE @v_receiver_tmpcnt		INT;

	DECLARE @v_item_cnt				INT;
	DECLARE @v_item_tmpcnt			INT;

	DECLARE @v_head_cont		NVARCHAR(max);
	DECLARE @v_body_cont		NVARCHAR(max);
	DECLARE @v_receiver_temp	NVARCHAR(150);
	DECLARE @v_to_mail			NVARCHAR(max);
	DECLARE @TABLE_BODY			NVARCHAR(MAX);
	DECLARE @v_body_contents    NVARCHAR(MAX);
	DECLARE @v_mail_title       NVARCHAR(100);
	DECLARE @v_mail_receiver	NVARCHAR(100);

	DECLARE @v_division_id				NVARCHAR(100);
	DECLARE @v_company_id				NVARCHAR(100);
	DECLARE @v_from_site_description    NVARCHAR(100);
	DECLARE @v_item_id					NVARCHAR(100);
	DECLARE @v_nick_name				NVARCHAR(100);
	DECLARE @v_measure_name				NVARCHAR(100);
	DECLARE @v_seq						NVARCHAR(100);
	DECLARE @v_segment1					NVARCHAR(100);
	DECLARE @v_segment2					NVARCHAR(100);
	DECLARE @v_segment3					NVARCHAR(100);
	DECLARE @v_segment4					NVARCHAR(100);
	DECLARE @v_segment5					NVARCHAR(100);
	DECLARE @v_cnt						INT;


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SSP_MAIL_SEND_BATCH_N';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	SET @v_fromsite_tmpcnt = 0;
	SET @v_receiver_tmpcnt = 0;

	-- SHIPMENT BOH
	IF OBJECT_ID('tempdb..#Tmp_BOHData') IS NOT NULL	
		DROP TABLE #Tmp_BOHData;

	-- SHIPMENT ROW DATA
	IF OBJECT_ID('tempdb..#Tmp_RowData') IS NOT NULL	
		DROP TABLE #Tmp_RowData;
	
	IF OBJECT_ID('tempdb..#Tmp_Raw_Result_Table') IS NOT NULL	
		DROP TABLE #Tmp_Raw_Result_Table;

	IF OBJECT_ID('tempdb..#Tmp_Raw_Result_Table') IS NOT NULL	
		DROP TABLE #Tmp_Raw_Result_Table;
	
	IF OBJECT_ID('tempdb..#Tmp_Result_01') IS NOT NULL	
		DROP TABLE #TMP_Tbl_SSP_MAIL_SEND_BATCH_N;
	
	IF OBJECT_ID('tempdb..#Tmp_Result_02') IS NOT NULL	
		DROP TABLE #Tmp_Result_02;
	
	IF OBJECT_ID('tempdb..#TMP_Tbl_SSP_MAIL_SEND_BATCH_N') IS NOT NULL
		DROP TABLE #TMP_Tbl_SSP_MAIL_SEND_BATCH_N;

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/	
	CREATE TABLE #Tmp_Raw_Result_Table
	(
		DIVISION_ID		NVARCHAR(30)
		, FROM_SITE		NVARCHAR(30)
		, TO_SITE		NVARCHAR(30)
		, ITEM_ID		NVARCHAR(50)
		, PROJECT_CODE	NVARCHAR(100)
		, MEASURE		NVARCHAR(50)
		, MEASURE_NAME	NVARCHAR(50)
		, SEQ			INT
		, CONFIRM_DAY   INT
		, YYYYMMDD		NVARCHAR(8)
		, QTY			NUMERIC(20, 10)
		, REQUESTOR		NVARCHAR(200)
	);

	CREATE TABLE #TMP_Tbl_SSP_MAIL_SEND_BATCH_N (
			SITE_SEQ					INT
			, REC_SEQ					INT
			, ITEM_SEQ					INT
			, MAIL_RECEIVER				NVARCHAR(100)
			, division_id				NVARCHAR(100) 
			, COMPANY_ID				NVARCHAR(100)
			, from_site_description		NVARCHAR(100)
			, item_id					NVARCHAR(100)
			, nick_name					NVARCHAR(100)
			, measure_name				NVARCHAR(100)
			, seq						INT
			, segment1					NVARCHAR(100) -- 현재일
			, segment2					NVARCHAR(100) -- 현재일 + 1
			, segment3					NVARCHAR(100) -- 현재일 + 2
			, segment4					NVARCHAR(100) -- 현재일 + 3
			, segment5					NVARCHAR(100) -- 현재일 + 4
	);
	/********************************************************************************/

	--Cutoff 전 Date 추출
	SELECT 
		@v_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
	FROM SSP_MST_SHIP_PLAN_SCHEDULE WITH(NOLOCK)
	WHERE 1= 1
	AND ERP_STOCK_CUTOFF_YN = 'Y'
	AND OWMS_STOCK_CUTOFF_YN = 'Y'
	AND CURRENT_PLAN_DATE_YN = 'Y'
	AND COMPANY_ID = @p_company_id
	;

	SET @v_from_yyyymmdd = @v_plan_start_yyyymmdd;
	SET @v_to_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, 55, CONVERT(VARCHAR, @v_from_yyyymmdd, 121)), 112); --FROM +55일;
	SET @v_boh_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(VARCHAR, @v_from_yyyymmdd, 121)), 112); --FROM -1일
	SET @v_stock_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -3, CONVERT(VARCHAR, @v_from_yyyymmdd, 121)), 112); --FROM -3일

	SET @v_program_id = 'SSP0021';
	SET @v_sheet_name = 'Shipment Plan';

	BEGIN TRY	
		--//시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		--//LOG END
		--실시간 Data Load 
		WITH MST_STOCK AS
		(
			SELECT
				division_id
				, company_id
				, scm_site_id
				, item_id
				, ssp_qty
				, scm_qty
				, cutoff_date
				, site_id
				, storage_id
				, PLANT_ID
				, OPERATION_ID
				, stock_type
			FROM  SCM_DNM_STOCK_V WITH(NOLOCK) --SCM_DNM_STOCK_V
			WHERE 1 = 1
			AND company_id = @p_company_id
			AND cutoff_date >  @v_stock_yyyymmdd -- 현재일 - 3
			AND cutoff_date = @v_boh_yyyymmdd	
		),
		------------------------------------------------------------------------------------------------------------------------------------
		--[C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V) 
		PACKER_STOCK AS -- SSP_DNM_ESS_PACKER_STOCK_V  ESS(82) PACKER STOCK,  STORAGE_ID : 6000(구미 People works), E400(남경 People works) 
		(
			SELECT
				 division_id
				, company_id
				, scm_site_id
				, item_id
				, ssp_qty
				, cutoff_date
			FROM  SSP_DNM_ESS_PACKER_STOCK_V WITH(NOLOCK) 
			WHERE 1 = 1
			AND company_id =  @p_company_id
			AND cutoff_date > @v_stock_yyyymmdd -- 현재일 - 3
			AND cutoff_date = @v_boh_yyyymmdd	

		),
		------------------------------------------------------------------------------------------------------------------------------------
		MST_LOCATION AS
		(
			SELECT
				tt0.DIVISION_ID,	tt0.STORAGE_ID,		tt0.SCM_SITE_ID,		tt0.LOCATION_CODE,		tt0.PLANT_ID,	tt1.COMPANY_ID,		tt0.VALID_YN
			FROM SSP_MST_LOCATION_V tt0 WITH(NOLOCK)
			INNER JOIN SCM_MST_SITE tt1 WITH(NOLOCK)
				ON tt0.DIVISION_ID = tt1.DIVISION_ID	AND tt0.SCM_SITE_ID = tt1.SCM_SITE_ID
				AND tt0.PLANT_ID = tt1.PLANT_ID
				AND tt1.COMPANY_ID = @p_company_id
				AND tt1.VALID_YN ='Y'					AND tt1.site_type = 'PLANT' 
			WHERE 1 = 1
			AND tt0.VALID_YN ='Y'
			AND tt1.company_id = @p_company_id
			AND tt0.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING','CMA_BMA')
			GROUP BY tt0.DIVISION_ID, tt0.STORAGE_ID, tt0.SCM_SITE_ID, tt0.LOCATION_CODE, tt0.PLANT_ID, tt1.COMPANY_ID,	tt0.VALID_YN
		)
		SELECT
			DIVISION_ID,		FROM_SITE,		ITEM_ID,		CONVERT(NVARCHAR(8), YYYYMMDD, 112) AS YYYYMMDD,		BOH_TYPE AS BOH_TYPE,		SUM(BOH_QTY) AS BOH_QTY,	SEQ--,	STORAGE_ID
		INTO #Tmp_BOHData
		FROM
		(
			--//BOH : 5s==================================================================================================================================
			SELECT
				DIVISION_ID
				, FROM_SITE
				, ITEM_ID
				, BOH_TYPE
				, YYYYMMDD
				, SUM(BOH_QTY) AS BOH_QTY
				, SEQ
			FROM
			(
				SELECT
					T0.division_id			AS DIVISION_ID
					, T0.scm_site_id		AS FROM_SITE
					, T0.item_id			AS ITEM_ID
					, 'BOH'					AS BOH_TYPE
					, cutoff_date			AS YYYYMMDD
					, T0.ssp_qty            AS BOH_QTY
					, 1						AS SEQ				--MEASURE 위치와 동일하게
				FROM MST_STOCK T0 WITH(NOLOCK)
				INNER JOIN MST_LOCATION T1
					ON T0.division_id = T1.DIVISION_ID			AND T0.storage_id = T1.STORAGE_ID
					AND T0.PLANT_ID = T1.PLANT_ID				AND T0.COMPANY_ID = T1.COMPANY_ID
					AND T0.scm_site_id = T1.SCM_SITE_ID
					AND T1.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS') --,'CMA_BMA')		-- 특성완료 이후 창고
				WHERE 1 = 1
				UNION ALL
				--MES TOTAL - (OQC_NG + QMS/MES_HOLD)
				SELECT
					T0.DIVISION_ID
					, T0.FROM_SITE
					, T0.ITEM_ID
					, 'BOH'					AS BOH_TYPE
					, T0.YYYYMMDD
					, ISNULL(SUM(TOTAL) - (SUM(OQC_NG) + SUM(QMS_MES_Hold)), 0) AS BOH_QTY
					, 1						AS SEQ
				FROM
				(
					SELECT
						S.DIVISION_ID,
						S.FROM_SITE,
						S.ITEM_ID,
						@v_boh_yyyymmdd AS YYYYMMDD,
						CASE WHEN S.AVAILABLE_YN = 'N' AND S.OQC_INSP_RESULT = 'N' THEN SUM(ISNULL(S.LOT_QTY, 0)) ELSE 0  END AS OQC_NG,
						CASE WHEN S.AVAILABLE_YN = 'N' AND (S.QMS_HOLD_YN = 'Y' OR S.MES_HOLD_YN = 'Y') THEN SUM(ISNULL(S.LOT_QTY, 0)) ELSE 0  END AS QMS_MES_Hold,
						SUM(ISNULL(S.LOT_QTY, 0)) AS TOTAL
					FROM SSP_DNM_GMES_STOCK_81_82 AS S with(nolock)
			             JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
			          ON S.DIVISION_ID = D.DIVISION_ID
					WHERE 1 = 1
					AND S.COMPANY_ID = @p_company_id
					--AND S.DIVISION_ID IN ('81','82') 
					AND D.ATTRIBUTE3 IN ('81','82')
					AND S.YYYYMMDD = @v_plan_start_yyyymmdd
					GROUP BY S.DIVISION_ID, S.FROM_SITE, S.ITEM_ID, S.YYYYMMDD, S.AVAILABLE_YN, S.OQC_INSP_RESULT, S.MES_HOLD_YN, S.QMS_HOLD_YN
				) AS T0
				GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD
				------------------------------------------------------------------------------------------------------------------------------------
				--[C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V) 
				UNION ALL -- ESS PACKER 재고 -BOH MEASURE
					SELECT
						 T0.division_id			AS DIVISION_ID
						, T0.scm_site_id		AS FROM_SITE
						, T0.item_id			AS ITEM_ID
						, 'BOH'					AS BOH_TYPE
						, cutoff_date			AS YYYYMMDD
						, ISNULL(T0.ssp_qty, 0)     AS BOH_QTY
						, 1						AS SEQ				
					FROM PACKER_STOCK T0 WITH(NOLOCK)
					WHERE 1 = 1
					AND T0.COMPANY_ID = @p_company_id
				------------------------------------------------------------------------------------------------------------------------------------
			) AS T0
			GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.BOH_TYPE, T0.YYYYMMDD, T0.SEQ
		) AS TMP_BOH
		GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID,  YYYYMMDD, BOH_TYPE, SEQ
		;

		--SELECT * FROM #Tmp_BOHData ORDER BY ITEM_ID, YYYYMMDD;
		--RETURN;
		--////////////////////////////////////////////////////////////////////////////////--
		--//2. DATA ROW DATE															//--
		--////////////////////////////////////////////////////////////////////////////////--
		--SELECT @p_company_id, @v_from_yyyymmdd, @v_to_yyyymmdd
		--;
		--RETURN;
		SELECT
			T0.DIVISION_ID
			, T0.ITEM_ID
			, T0.FROM_SITE
			, T0.TO_SITE
			, T0.PROJECT_CODE
			, T0.MEASURE
			, T0.SEQ
			, T0.YYYYMMDD
			, SUM(T0.QTY) AS QTY
			, CASE WHEN (T1.SHIP_FROZEN - 1) > 0 THEN (T1.SHIP_FROZEN - 1) ELSE 0 END AS CONFIRM_DAY
			, T0.REQUESTOR
		INTO #Tmp_RowData
		FROM 
		(
	
			--//SHIPMENT REQUEST//================================================================
			--////////////////////////////////////////////////////////////////////////////////--
			--//2-1. Ship Req : 출하 요청(Plant향 Ship Req)									//--
			--//	DM_PLN_SHIPMENT_REQ / MEASURE = 'SHIP_REQ'								//--
			--////////////////////////////////////////////////////////////////////////////////--
			SELECT 
				T0.division_id				AS DIVISION_ID
				, T0.item_id				AS ITEM_ID
				, T0.plant_site_id			AS FROM_SITE
				, T0.scm_site_id			AS TO_SITE
				, T0.PROJECT_CODE			AS PROJECT_CODE
				, 'SHIP_REQ'				AS MEASURE
				, T0.yyyymmdd				AS YYYYMMDD
				, T0.qty					AS QTY
				, 1							AS SEQ
				, T0.LAST_UPDATED_BY		AS REQUESTOR
			FROM   dm_pln_shipment_req T0 WITH(NOLOCK)
			INNER JOIN scm_mst_site T1 WITH(NOLOCK)
				ON T0.PLANT_SITE_ID = T1.SCM_SITE_ID
				AND T0.division_id = T1.DIVISION_ID
				AND T1.COMPANY_ID = @p_company_id
				AND T1.site_type = 'PLANT'				AND T1.VALID_YN = 'Y'
			--	AND T1.osp_yn = 'N'  -- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외) 
			      JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
			    ON T0.DIVISION_ID = D.DIVISION_ID
			WHERE  1=1
			AND T1.COMPANY_ID = @p_company_id
			--AND T0.division_id IN ('81','82')
			AND D.ATTRIBUTE3 IN ('81','82')
			AND T0.measure = 'SHIP_REQ' -- 확정 후 수정할 것
			AND T0.yyyymmdd >= @v_from_yyyymmdd	
			AND T0.yyyymmdd <= @v_to_yyyymmdd	
			AND T0.qty > 0
			
			--//SHIPMENT PLAN//===================================================================
			--////////////////////////////////////////////////////////////////////////////////--
			--//2-2. Ship Plan : 출하 계획(Plant향 Ship Req)									//--
			--//	scp_anl_shipment_plan_semi / MEASURE = 'SHIP_PLAN'					//--
			--//	ssp_anl_ship_confirm	   / MEASURE = 'SHIP_PLAN'					//--
			--////////////////////////////////////////////////////////////////////////////////--
			UNION ALL
			SELECT
				T0.division_id			AS DIVISION_ID
				, T0.item_id			AS ITEM_ID
				, T0.from_site			AS FROM_SITE
				, T0.to_site			AS TO_SITE
				, T0.PROJECT_CODE		AS PROJECT_CODE
				, T0.measure			AS MEASURE
				, T0.yyyymmdd			AS YYYYMMDD
				, ISNULL(SUM(T0.qty), 0)			AS QTY
				, T0.seq				AS SEQ
				, T0.REQUESTOR
			FROM
			(
				--//2) Ship Plan : SSP(Daily) Plant향 Shipment Plan====================================================================================================
				--//===================================================================================================================================================
				SELECT 
					T0.division_id
					, T0.item_id
					, T0.from_site
					, T0.to_site
					, T0.PROJECT_CODE
					, 'SHIP_PLAN'         AS measure
					, T0.yyyymmdd
					, T0.qty
					, 2                     AS seq
					, T0.REQUESTOR
				FROM ssp_anl_ship_confirm T0 WITH (NOLOCK)
				JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
			          ON T0.DIVISION_ID = D.DIVISION_ID
				WHERE 1 = 1
				--AND T0.division_id IN ('81','82') 
                AND D.ATTRIBUTE3 IN ('81','82')
				AND T0.change_type  = 'C'
				AND T0.BIZ_TYPE  = 'E' --[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 전극 제외
				AND T0.qty >  0
				AND T0.FROM_SITE_COMPANY_ID = @p_company_id
				AND T0.yyyymmdd >= @v_from_yyyymmdd
				AND T0.yyyymmdd <= @v_to_yyyymmdd
			
				UNION ALL
				--확정구간 이후 Ship Req 수량 합
				SELECT
					DIVISION_ID,
					ITEM_ID,
					FROM_SITE,
					TO_SITE,
					PROJECT_CODE,
					MEASURE,
					YYYYMMDD,
					QTY,
					SEQ,
					NULL AS REQUESTOR
				FROM
				(
					SELECT 
						T0.division_id				AS DIVISION_ID
						, T0.item_id				AS ITEM_ID
						, T0.plant_site_id			AS FROM_SITE
						, T0.scm_site_id			AS TO_SITE
						, T0.PROJECT_CODE			AS PROJECT_CODE
						, 'SHIP_PLAN'				AS MEASURE
						, T0.yyyymmdd				AS YYYYMMDD
						, T0.qty					AS QTY
						, 2							AS SEQ
						, CASE WHEN isnull(fs.ship_frozen,0) > 0 THEN CONVERT(CHAR(8), DATEADD(DD, isnull(fs.ship_frozen,0), CONVERT(VARCHAR, @v_from_yyyymmdd, 121)), 112) ELSE @v_from_yyyymmdd END AS frozen_yyyymmdd -- Ship Frozen구간 다음일자
					FROM dm_pln_shipment_req T0 WITH(NOLOCK)
						JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
			          ON T0.DIVISION_ID = D.DIVISION_ID

					INNER JOIN scm_mst_site fs WITH(NOLOCK)	
						ON  T0.plant_site_id    = fs.scm_site_id
						AND T0.DIVISION_ID      = FS.DIVISION_ID 
						AND fs.COMPANY_ID		= @p_company_id
						AND fs.site_type		= 'PLANT'  
						--AND fs.osp_yn			= 'N' -- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외) 
						AND fs.valid_yn			= 'Y'
					WHERE  1=1
					AND fs.COMPANY_ID = @p_company_id
					--AND T0.division_id IN ('81','82')
                    AND D.ATTRIBUTE3 IN ('81','82')
					AND T0.measure = 'SHIP_REQ'
					AND T0.yyyymmdd >= @v_from_yyyymmdd	
					AND T0.yyyymmdd <= @v_to_yyyymmdd	
					AND T0.qty > 0
				) T1
				WHERE 1 = 1
				AND YYYYMMDD > frozen_yyyymmdd 
			) T0
			GROUP BY T0.division_id, T0.item_id, T0.from_site, T0.to_site, T0.PROJECT_CODE, T0.measure, T0.yyyymmdd, T0.seq, T0.REQUESTOR
			
			--//PROD_PLAN//===================================================================
			--////////////////////////////////////////////////////////////////////////////////--
			--//2-4. PROD_PLAN : 생산 계획													//--
			--//	SCM_DNM_PLAN_FROZEN_V / MEASURE = 'PROD_PLAN'							//--
			--//	Pack : 'P5500', 'P9500' / Cell : 'F5300', 'F5500', 'F5600', 'F6000'		//--
			--////////////////////////////////////////////////////////////////////////////////--
			UNION ALL
			--SELECT
			--	  T0.DIVISION_ID
			--	, T0.ITEM_ID
			--	, T0.SCM_SITE_ID AS FROM_SITE
			--	, NULL AS TO_SITE
			--	, NULL AS PROJECT_CODE
			--	, 'PROD_PLAN' AS MEASURE
			--	, CONVERT(NVARCHAR(8), T0.plan_date, 112) AS YYYYMMDDD
			--	, T0.plan_qty AS QTY
			--	, 4 AS SEQ
			--	, NULL AS REQUESTOR
			--FROM SCM_DNM_PLAN_FROZEN_V AS T0 WITH(NOLOCK) -- SCM_DNM_PLAN_FROZEN_V T0
			--WHERE 1 = 1
			--AND T0.division_id IN ('81','82','81_UC') -- 조회속도로 인해 division 조건 추가 
   --         --AND AND T0.division_id IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE ATTRIBUTE3 IN ('81','82' ) )
			--AND T0.operation_id IN ('P5500', 'P9500', 'F5300', 'F5500', 'F5600', 'F6000')
			--AND T0.plan_qty > 0 
			--AND T0.plan_in_qty > 0 
			--AND T0.COMPANY_ID = @p_company_id
			----AND CONVERT(NVARCHAR(8), T0.plan_date, 112)   >= @v_from_yyyymmdd
			----AND CONVERT(NVARCHAR(8), T0.plan_date, 112)   <= @v_to_yyyymmdd
			--AND T0.plan_date >= CONVERT(datetime, @v_from_yyyymmdd)
			--AND T0.plan_date <= CONVERT(datetime, @v_to_yyyymmdd)			
			--AND T0.site_id IN ( SELECT DISTINCT SITE_ID 
			--					FROM  SCM_MST_SITE
			--					WHERE 1 = 1
			--					AND COMPANY_ID = @p_company_id
			--					AND SITE_TYPE = 'PLANT'
			--					--AND OSP_YN  = 'N' -- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외) 
			--					AND VALID_YN = 'Y'    )
			SELECT
				  T0.DIVISION_ID
				, T0.ITEM_ID
				, T0.SCM_SITE_ID AS FROM_SITE
				, NULL AS TO_SITE
				, NULL AS PROJECT_CODE
				, 'PROD_PLAN' AS MEASURE
				, T0.plan_date AS YYYYMMDDD
				, T0.plan_qty AS QTY
				, 4 AS SEQ
				, NULL AS REQUESTOR
			FROM SSP_DNM_FP_PLAN_FROZEN AS T0 WITH(NOLOCK) -- SCM_DNM_PLAN_FROZEN_V T0
			WHERE 1 = 1
            AND T0.division_id IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE ATTRIBUTE3 IN ('81','82' ) )
			-- START [E20260811-000692] ESMI AZ 링크 2호기 생산계획 받아오지 못하는 현상 처리
			-- 원본 AND T0.operation_id IN ('P5500', 'P9500', 'F5300', 'F5500', 'F5600', 'F6000')
			AND T0.operation_id IN ('P5500', 'P9500', 'F5300', 'F5500', 'F5600', 'F6000', 'PL500')
			-- END [E20260811-000692] ESMI AZ 링크 2호기 생산계획 받아오지 못하는 현상 처리
			AND T0.plan_qty > 0 
			AND T0.COMPANY_ID = @p_company_id
			AND T0.plan_date >= @v_from_yyyymmdd
			AND T0.plan_date <= @v_to_yyyymmdd		
			AND T0.site_id IN ( SELECT DISTINCT SITE_ID 
								FROM  SCM_MST_SITE
								WHERE 1 = 1
								AND COMPANY_ID = @p_company_id
								AND SITE_TYPE = 'PLANT'
								--AND OSP_YN  = 'N' -- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외) 
								AND VALID_YN = 'Y'    )
			UNION ALL		
            -- [C20200121-000352]-3 : Production Plan Measure에 Paker생산계획 추가(SCP_ANL_PRODUCTION_PLAN 의 PROD_PLAN_AMEND measure) 		
			SELECT P.DIVISION_ID 
			,      P.ITEM_ID 
			,      P.SCM_SITE_ID  AS FROM_SITE
			,      NULL AS TO_SITE
			,      NULL AS PROJECT_CODE
			,      'PROD_PLAN'    AS MEASURE  
			,      P.YYYYMMDD     AS YYYYMMDDD   
			,      P.QTY          AS QTY
			,      4 AS SEQ
			,      NULL AS REQUESTOR
			FROM SCP_ANL_PRODUCTION_PLAN P WITH(NOLOCK) 
			JOIN (
                    SELECT TOP 1 
					       A.DIVISION_ID 
					,      A.PLAN_START_YYYYMMDD 
					,      A.PLAN_TYPE 
					,      A.PLAN_SEQ   AS SEQ 
					FROM   SCP_PLAN_VERSION_V A WITH(NOLOCK) 
					WHERE  A.DIVISION_ID  = '82' -- ESS(82)만 적용 
					AND    A.PLAN_CYCLE   = 'WEEKLY'
					AND    A.PLAN_TYPE NOT IN ('TE', 'TM')
					ORDER BY PLAN_START_YYYYMMDD DESC , PLAN_TYPE_ORDER DESC , PLAN_SEQ DESC 
				) V 
			  ON V.DIVISION_ID = P.DIVISION_ID 
			 AND V.PLAN_START_YYYYMMDD = P.PLAN_START_YYYYMMDD
			 AND V.PLAN_TYPE = P.PLAN_TYPE 
			 AND V.SEQ       = P.SEQ 
			JOIN SCM_MST_SITE S WITH(NOLOCK) 
			  ON S.DIVISION_ID = P.DIVISION_ID 
			 AND S.SCM_SITE_ID = P.SCM_SITE_ID 
			 AND S.SITE_TYPE = 'PLANT'
			 --AND S.OSP_YN = 'Y' -- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외) 
			 AND VALID_YN = 'Y'
			WHERE P.DIVISION_ID = '82' -- ESS(82)만 적용 
			AND   S.COMPANY_ID  = @p_company_id
			AND   P.MEASURE = 'PROD_PLAN_AMEND'
			AND   P.QTY > 0  
			AND   P.YYYYMMDD >= @v_from_yyyymmdd
			AND   P.YYYYMMDD <= @v_to_yyyymmdd

		) T0
		INNER JOIN scm_mst_site T1	WITH(NOLOCK)	
				ON T1.COMPANY_ID = @p_company_id
				AND T0.DIVISION_ID = T1.DIVISION_ID
				AND T0.FROM_SITE = T1.scm_site_id
				AND T1.site_type  = 'PLANT'  
				AND T1.valid_yn   = 'Y'
				AND T1.SHIP_FROZEN > 0
		WHERE 1 = 1
		GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.TO_SITE, T0.PROJECT_CODE, T0.ITEM_ID, T0.YYYYMMDD, T0.MEASURE, T0.SEQ, T1.SHIP_FROZEN, T0.REQUESTOR
		ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD, T0.SEQ
		;
	
		--//TEST-00
		--SELECT * FROM #Tmp_RowData
		--ORDER BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, SEQ;
		--RETURN;
		--////////////////////////////////////////////////////////////////////////////////--
		--//3. 해당 ITEM별 MEASURE 및 날짜 생성											//--
		--////////////////////////////////////////////////////////////////////////////////--
		INSERT INTO #Tmp_Raw_Result_Table
		(
			DIVISION_ID,		FROM_SITE,		TO_SITE,		PROJECT_CODE,	ITEM_ID,		MEASURE,		MEASURE_NAME,	SEQ,
			CONFIRM_DAY,		YYYYMMDD,		QTY,			REQUESTOR
		)
		SELECT
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T1.TO_SITE
			, T1.PROJECT_CODE
			, T0.ITEM_ID
			, T0.MEASURE
			, T0.MEASURE_NAME
			, T0.SEQ
			, T0.CONFIRM_DAY
			, T0.YYYYMMDD
			, ISNULL(T1.QTY, 0) AS QTY
			, T1.REQUESTOR
		FROM 
		(
			SELECT
				tt0.DIVISION_ID
				, tt0.FROM_SITE
				, tt0.ITEM_ID
				, tt0.CONFIRM_DAY
				, tt1.COLUMN_NAME AS MEASURE
				, tt1.COLUMN_LABEL_NAME AS MEASURE_NAME
				, CASE WHEN tt1.COLUMN_NAME = 'PROD_PLAN' THEN 4 ELSE tt1.SORT_ORDER_NO END AS SEQ
				, tt2.YYYYMMDD
			FROM #Tmp_RowData tt0
			LEFT JOIN SCM_MST_SHEET_MEASURE tt1 WITH(NOLOCK)
				ON tt1.PROGRAM_ID = @v_program_id
				AND tt1.SHEET_NAME = @v_sheet_name
				--AND tt0.MEASURE = tt1.COLUMN_NAME
			LEFT OUTER JOIN 
			(
				SELECT
					BASIS_YYYYMMDD AS YYYYMMDD,
					ISO_WEEK
				FROM scm_sys_calendar_m WITH(NOLOCK)
				WHERE BASIS_YYYYMMDD >= @v_from_yyyymmdd	AND BASIS_YYYYMMDD <= @v_to_yyyymmdd
			) tt2
				ON  tt2.YYYYMMDD >= @v_from_yyyymmdd	AND tt2.YYYYMMDD <= @v_to_yyyymmdd
			GROUP BY tt0.DIVISION_ID, tt0.FROM_SITE, tt0.ITEM_ID, tt1.COLUMN_NAME, tt1.COLUMN_LABEL_NAME, tt1.SORT_ORDER_NO, tt2.YYYYMMDD,tt0.CONFIRM_DAY
		) T0
		LEFT OUTER JOIN #Tmp_RowData T1 WITH(NOLOCK)
			ON T0.DIVISION_ID = T1.DIVISION_ID		AND T0.FROM_SITE = T1.FROM_SITE
			AND T0.ITEM_ID = T1.ITEM_ID				AND T0.MEASURE = T1.MEASURE
			AND T0.YYYYMMDD = T1.YYYYMMDD
		LEFT OUTER JOIN #Tmp_BOHData T2
			ON T0.DIVISION_ID = T2.DIVISION_ID		AND T0.FROM_SITE = T2.FROM_SITE
			AND T0.ITEM_ID = T2.ITEM_ID				AND T0.SEQ = T2.SEQ
		WHERE 1 = 1
		AND T0.MEASURE IN ('SHIP_REQ', 'SHIP_PLAN', 'PROD_PLAN')
		ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD, T0.SEQ
		;
		--//TEST
		--SELECT * FROM #Tmp_Raw_Result_Table
		--ORDER BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, SEQ
		;
		--RETURN;

		--//INTN_MOVEMENT//===================================================================
		--////////////////////////////////////////////////////////////////////////////////--
		--//2-3. INTN_MOVEMENT								//--
		--////////////////////////////////////////////////////////////////////////////////--
		INSERT INTO #Tmp_Raw_Result_Table
		(
			DIVISION_ID,		FROM_SITE,		ITEM_ID,		MEASURE,		MEASURE_NAME,		SEQ,		CONFIRM_DAY,		YYYYMMDD,		QTY
		)
		SELECT
			T0.DIVISION_ID,		T0.FROM_SITE,	T0.ITEM_ID,		T0.MEASURE,		T0.MEASURE_NAME,		T0.SEQ,		T0.CONFIRM_DAY,		T0.YYYYMMDD,	SUM(T0.QTY) AS QTY
		FROM
		(
			SELECT 
				T0.DIVISION_ID
				, T0.FROM_SITE
				, T0.ITEM_ID
				, 'INTN_MOVEMENT' AS MEASURE
				, 'Internal movement' AS MEASURE_NAME
				, 3 AS SEQ
				, T0.CONFIRM_DAY
				, T0.YYYYMMDD
				, sum(isnull(T1.QTY, 0)) as QTY
			FROM #Tmp_Raw_Result_Table T0 WITH(NOLOCK)
			LEFT OUTER JOIN 
			(
				SELECT
					p.DIVISION_ID
					, fs.scm_site_id	AS FROM_SITE
					, p.ITEM_ID
					, CONVERT(VARCHAR(8), p.plan_date, 112) AS yyyymmdd
					, ISNULL(p.qty, 0) AS QTY
				FROM scm_dnm_cell_inhouse_plan_sn p WITH(NOLOCK)
				INNER JOIN scm_mst_site fs WITH(NOLOCK)
					ON  p.division_id      = fs.division_id
					AND p.plant_id         = fs.plant_id
					AND fs.COMPANY_ID       = @p_company_id
					AND fs.site_type       = 'PLANT'
					--AND fs.osp_yn          = 'N' -- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외) 
					AND fs.valid_yn        = 'Y'
				WHERE  1=1
				AND	   p.COMPANY_ID       = @p_company_id
				AND    p.category         = 'MOVING'
				AND    p.plan_date       >= @v_from_yyyymmdd
				AND    p.plan_date       <= @v_to_yyyymmdd
				AND    p.qty  >  0
			) T1
				ON T0.DIVISION_ID = T1.DIVISION_ID		AND T0.FROM_SITE = T1.FROM_SITE 
				AND T0.ITEM_ID = T1.ITEM_ID				AND T0.YYYYMMDD = T1.yyyymmdd
				AND T0.MEASURE = 'SHIP_PLAN'
			GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD, T0.MEASURE, T0.SEQ, T0.CONFIRM_DAY
		) T0
		GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.MEASURE, T0.MEASURE_NAME, T0.SEQ, T0.CONFIRM_DAY, T0.YYYYMMDD
		;
	
		--////////////////////////////////////////////////////////////////////////////////--
		--//4. WH_STOCK, BALANCE 생성													//--
		--////////////////////////////////////////////////////////////////////////////////--
		--//4-1. WH_STOCK DATA INSERT
		WITH WH_STOCK AS
		(
			SELECT
				DIVISION_ID
				, FROM_SITE
				, ITEM_ID
				, CONVERT(CHAR(8), DATEADD(DD, +1, CONVERT(VARCHAR, YYYYMMDD, 121)), 112) AS YYYYMMDD
				, BOH_QTY AS BOH_QTY
			FROM #Tmp_BOHData WITH(NOLOCK)
			WHERE 1 = 1
			AND BOH_TYPE = 'BOH'
			AND YYYYMMDD = @v_boh_yyyymmdd
		),
		Deduplication AS
		(
			SELECT
				DIVISION_ID
				, FROM_SITE
				, ITEM_ID
				, YYYYMMDD
				, CONFIRM_DAY
			FROM #Tmp_Raw_Result_Table WITH(NOLOCK)
			GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, CONFIRM_DAY
		)
		INSERT INTO #Tmp_Raw_Result_Table
		(
			DIVISION_ID,		FROM_SITE,		ITEM_ID,		MEASURE,		MEASURE_NAME,		SEQ,		CONFIRM_DAY,		YYYYMMDD,		QTY
		)
		SELECT 
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.ITEM_ID 
			, 'WH_STOCK' AS MEASURE
			, 'Warehouse Stock' AS MEASURE_NAME
			, 5 AS SEQ
			, T0.CONFIRM_DAY
			, T0.YYYYMMDD
			, (
				SELECT
					ISNULL( 
						SUM( 
							CASE	
								WHEN tt0.MEASURE = 'SHIP_PLAN' THEN -1 * ISNULL(tt0.QTY, 0)
								WHEN tt0.MEASURE = 'INTN_MOVEMENT' THEN -1 * ISNULL(tt0.QTY, 0)
								WHEN tt0.MEASURE = 'PROD_PLAN' THEN ISNULL(tt0.QTY, 0)
							ELSE 0.0
							END), 
						0)
				FROM #Tmp_Raw_Result_Table tt0
				WHERE 1 = 1
				AND tt0.DIVISION_ID = T0.DIVISION_ID
				AND tt0.FROM_SITE = T0.FROM_SITE
				AND tt0.ITEM_ID = T0.ITEM_ID
				AND tt0.MEASURE IN ('SHIP_PLAN', 'PROD_PLAN', 'INTN_MOVEMENT')
				AND tt0.YYYYMMDD < T0.YYYYMMDD
				) 
				+ ISNULL(T1.BOH_QTY, 0) AS QTY
		FROM Deduplication T0 WITH(NOLOCK)
		LEFT OUTER JOIN WH_STOCK T1 WITH(NOLOCK)
			ON T0.DIVISION_ID = T1.DIVISION_ID	AND T0.FROM_SITE = T1.FROM_SITE
			AND T0.ITEM_ID = T1.ITEM_ID			--AND T0.YYYYMMDD = T1.YYYYMMDD 
		WHERE 1 = 1
		ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD
		;

		--//4-2. BALANCE DATA INSERT
		INSERT INTO #Tmp_Raw_Result_Table
		(
			DIVISION_ID,		FROM_SITE,		ITEM_ID,		MEASURE,		MEASURE_NAME,		SEQ,		CONFIRM_DAY,			YYYYMMDD,		QTY
		)
		SELECT
			DIVISION_ID,		
			FROM_SITE,
			ITEM_ID,		
			'BALANCE' AS MEASURE,
			'Balance' AS MEASURE_NAME,
			6 AS SEQ,
			CONFIRM_DAY,
			YYYYMMDD,
			ISNULL(
				SUM(
					CASE	WHEN MEASURE = 'SHIP_PLAN' THEN -1 * ISNULL(QTY, 0)
							WHEN MEASURE = 'WH_STOCK' THEN ISNULL(QTY, 0)
					ELSE 0 END
				), 0) AS QTY
		FROM #Tmp_Raw_Result_Table WITH(NOLOCK)
		WHERE 1 = 1
		AND MEASURE IN ('SHIP_PLAN', 'WH_STOCK')
		GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, CONFIRM_DAY;
		--//END WH_STOCK, BALANCE 생성///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

		--////////////////////////////////////////////////////////////////////////////////--
		--//5. PIVOT				 													//--
		--////////////////////////////////////////////////////////////////////////////////--

		SELECT
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.TO_SITE
			, T0.PROJECT_CODE
			, T0.ITEM_ID
			, T0.MEASURE
			, T0.MEASURE_NAME
			, T0.SEQ
			, CONVERT(VARCHAR(8), DATEADD(DD, isnull(T0.CONFIRM_DAY,0), CONVERT(VARCHAR, @v_from_yyyymmdd, 121)), 112) AS CONFIRM_DAY
			, T0.YYYYMMDD
			, T0.QTY
			, T0.REQUESTOR
		INTO #Tmp_Result_01
		FROM #Tmp_Raw_Result_Table T0
        INNER JOIN SCM_MST_SITE  FS WITH(NOLOCK) 
		   ON FS.DIVISION_ID = T0.DIVISION_ID
		  AND FS.SCM_SITE_ID = T0.FROM_SITE
		  AND FS.OPERATION_GROUP <> 'E'  -- 전극 제외 [PJ20199555]  공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 
		INNER JOIN scm_sys_calendar_m T1 WITH(NOLOCK)
			ON T0.yyyymmdd = T1.basis_yyyymmdd
        WHERE T0.DIVISION_ID <> '40'  -- 소형 제외 
		;
		--//TEST-01
		--SELECT * FROM #Tmp_Result_01
		--ORDER BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, SEQ
		--;
		--RETURN;
	
		WITH RESULT_DATA AS
		(
			SELECT
				DENSE_RANK() OVER(ORDER BY T0.CONFIRM_DAY) AS RN
				, T0.DIVISION_ID
				, T0.FROM_SITE
				, T0.TO_SITE
				, T0.PROJECT_CODE
				, T0.ITEM_ID
				, T0.MEASURE
				, T0.MEASURE_NAME
				, T0.SEQ
				, T0.CONFIRM_DAY
				, T0.YYYYMMDD
				, T0.QTY
				, T0.REQUESTOR
			FROM #Tmp_Result_01 T0
			WHERE 1 = 1
			AND T0.YYYYMMDD > CONFIRM_DAY
			AND T0.YYYYMMDD <= CONVERT(VARCHAR(8), DATEADD(DD, 5, CONVERT(VARCHAR, T0.CONFIRM_DAY, 121)), 112)
			AND EXISTS 
				(
					SELECT 
						*
					FROM #Tmp_Result_01 B
					WHERE 1 = 1
					AND B.MEASURE = 'BALANCE'
					AND B.YYYYMMDD > CONFIRM_DAY
					AND B.YYYYMMDD <= CONVERT(VARCHAR(8), DATEADD(DD, 5, CONVERT(VARCHAR, B.CONFIRM_DAY, 121)), 112)
					AND B.QTY < 0
					AND B.DIVISION_ID = T0.DIVISION_ID
					AND B.DIVISION_ID != '40'
					AND B.FROM_SITE = T0.FROM_SITE
					AND B.ITEM_ID = T0.ITEM_ID
				)
			AND
				EXISTS 
				(
					SELECT 
						*
					FROM #Tmp_Result_01 B
					WHERE 1 = 1
					AND B.MEASURE IN ('SHIP_PLAN' ,  'SHIP_REQ')
					AND B.YYYYMMDD > CONFIRM_DAY
					AND B.YYYYMMDD <= CONVERT(VARCHAR(8), DATEADD(DD, 5, CONVERT(VARCHAR, B.CONFIRM_DAY, 121)), 112)
					AND B.QTY > 0
					AND B.DIVISION_ID = T0.DIVISION_ID
					AND B.DIVISION_ID != '40'
					AND B.FROM_SITE = T0.FROM_SITE
					AND B.ITEM_ID = T0.ITEM_ID
				)
			AND T0.DIVISION_ID != '40'
		)
		SELECT
			MAX(TYPE) AS TYPE
			, T0.RN
			, T0.MAIL_RECEIVER
			, T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.ITEM_ID
			, T0.MEASURE
			, T0.MEASURE_NAME
			, T0.SEQ
			, T0.YYYYMMDD
			, SUM(T0.QTY) AS QTY
		INTO #Tmp_Result_02
		FROM 
		(
			
			SELECT 
			     DISTINCT 
				 XX.TYPE                  		
				,XX.RN
				,XX.MAIL_RECEIVER      
				,XX.DIVISION_ID
				,XX.FROM_SITE
				,XX.ITEM_ID
				,XX.MEASURE
				,XX.MEASURE_NAME
				,XX.SEQ
				,XX.YYYYMMDD
				,XX.QTY
            FROM (
			SELECT
				 --M.SEGMENT1				AS TYPE
				  '-'                       AS TYPE				
				, X.RN
				, M.SEGMENT2            AS MAIL_RECEIVER
				, X.DIVISION_ID
				, X.FROM_SITE
				, X.ITEM_ID
				, X.MEASURE
				, X.MEASURE_NAME
				, X.SEQ
				, X.YYYYMMDD
				, X.QTY
			FROM RESULT_DATA X WITH(NOLOCK) 
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK) 
			ON  M.LOOKUP_TYPE ='WARNING_MAIL_SEND'
			   AND  M.VALID_YN    ='Y'
			   AND  M.SEGMENT3    = CASE WHEN M.SEGMENT3 = 'ALL' THEN 'ALL' ELSE X.FROM_SITE END

			UNION ALL 
			 -- 법인간 거래 - LOOKUP_TYPE ='WARNING_MAIL_SEND' TYPE = 'SCP' 
			SELECT
				  -- M.SEGMENT1				AS TYPE
				  '-'                       AS TYPE
				, X.RN
				, M.SEGMENT2            AS MAIL_RECEIVER
				, X.DIVISION_ID
				, X.FROM_SITE
				, X.ITEM_ID
				, X.MEASURE
				, X.MEASURE_NAME
				, X.SEQ
				, X.YYYYMMDD
				, X.QTY
			FROM RESULT_DATA X WITH(NOLOCK) 
			JOIN SCM_MST_SITE S WITH(NOLOCK) 
			  ON S.DIVISION_ID = X.DIVISION_ID 
			 AND S.SCM_SITE_ID = X.TO_SITE 
			 AND S.SITE_TYPE = 'PLANT'
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK) 
			ON  M.LOOKUP_TYPE ='WARNING_MAIL_SEND'
			   AND  M.VALID_YN    ='Y'
			   AND  M.SEGMENT1    ='SCP'
			   AND  M.SEGMENT3    = CASE WHEN M.SEGMENT3 = 'ALL' THEN 'ALL' ELSE X.FROM_SITE END

			UNION ALL

			--MKT OWNER (DIVISION_ID, ITEM_ID, TO_SITE)
			SELECT 
				--'MKT' AS TYPE
				  '-'                       AS TYPE
				, X.RN
				, U.MKT_USER             AS MAIL_RECEIVER
				, X.DIVISION_ID
				, X.FROM_SITE
				, X.ITEM_ID
				, X.MEASURE
				, X.MEASURE_NAME
				, X.SEQ
				, X.YYYYMMDD
				, X.QTY
			FROM  RESULT_DATA X WITH(NOLOCK) 
			JOIN 
			(
				SELECT	
					B.MKT_USER,
					A.DIVISION_ID,
					A.FROM_SITE,
					A.ITEM_ID
				FROM 
				(
					SELECT 
						DIVISION_ID,
						FROM_SITE,
						TO_SITE,
						ITEM_ID,
						PROJECT_CODE
					FROM RESULT_DATA
					WHERE 1 = 1
					AND MEASURE IN ('SHIP_PLAN' ,  'SHIP_REQ')
				) A
				INNER JOIN SSP_MKT_USER_V B WITH(NOLOCK) 
				   ON B.DIVISION_ID   = A.DIVISION_ID  
				  AND B.TO_SITE       = A.TO_SITE 
				  AND B.ITEM_ID       = A.ITEM_ID 
				  AND B.PROJECT_CODE  = A.PROJECT_CODE
				GROUP BY B.MKT_USER, A.DIVISION_ID,	A.FROM_SITE, A.ITEM_ID
			) U
				ON U.DIVISION_ID = X.DIVISION_ID AND U.FROM_SITE = X.FROM_SITE
				AND U.ITEM_ID = X.ITEM_ID
			GROUP BY X.RN
				, U.MKT_USER
				, X.DIVISION_ID
				, X.FROM_SITE
				, X.ITEM_ID
				, X.MEASURE
				, X.MEASURE_NAME
				, X.SEQ
				, X.YYYYMMDD
				, X.QTY

			--REQUESTOR
			UNION ALL
			SELECT 
				--'REQ'                  AS TYPE
				 '-'                       AS TYPE
				, X.RN
				, P.REQUESTOR            AS MAIL_RECEIVER
				, X.DIVISION_ID          AS DIVISION_ID
				, X.FROM_SITE            AS FROM_SITE 
				, X.ITEM_ID              AS ITEM_ID
				, X.MEASURE
				, X.MEASURE_NAME
				, X.SEQ
				, X.YYYYMMDD
				, X.QTY
			FROM RESULT_DATA X WITH(NOLOCK)
			JOIN 
			(
				SELECT
					REQUESTOR,
					DIVISION_ID,
					FROM_SITE,
					ITEM_ID
				FROM RESULT_DATA A
				WHERE 1 = 1
				AND MEASURE IN ('SHIP_PLAN', 'SHIP_REQ')
				AND REQUESTOR IS NOT NULL
				GROUP BY REQUESTOR,	DIVISION_ID, FROM_SITE,	ITEM_ID
			) P
				ON P.DIVISION_ID = X.DIVISION_ID AND P.FROM_SITE = X.FROM_SITE
				AND P.ITEM_ID = X.ITEM_ID
			INNER JOIN TB_FX_User U WITH(NOLOCK)
				ON P.REQUESTOR = U.UserID AND U.UseYN = 'Y'
			WHERE 1 = 1
			) XX
		) T0
		WHERE 1 = 1
		GROUP BY T0.RN
			, T0.MAIL_RECEIVER
			, T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.ITEM_ID
			, T0.MEASURE
			, T0.MEASURE_NAME
			, T0.SEQ
			, T0.YYYYMMDD
		ORDER BY RN, T0.YYYYMMDD, SEQ
		;

		SET @v_fromsite_tmpcnt = 0;
		SELECT @v_fromsite_cnt = MAX(RN) FROM #Tmp_Result_02;

		--//TEST-02
		--SELECT * FROM #Tmp_Result_02;

		WHILE @v_fromsite_tmpcnt < @v_fromsite_cnt			--FROM_SITE LOOP
		BEGIN
		
			DELETE FROM #TMP_Tbl_SSP_MAIL_SEND_BATCH_N;
		
			SET @v_fromsite_tmpcnt = @v_fromsite_tmpcnt + 1;
		
			SET @v_site_from_yyyymmdd = '';
			SET @v_site_to_yyyymmdd = '';
			--FROM_YYYYMMDD. TO_YYYYMMDD 구하기
			SELECT 
				@v_site_from_yyyymmdd = MIN(YYYYMMDD), @v_site_to_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, 4, CONVERT(VARCHAR, MIN(YYYYMMDD), 121)), 112)
			FROM #Tmp_Result_02
			WHERE 1 = 1
			AND RN = @v_fromsite_tmpcnt
			;

			/********************************************************************************
			* PIVOIT처리
			********************************************************************************/		
			BEGIN
				DECLARE @mQuery NVARCHAR(MAX);
				DECLARE @mEXEC NVARCHAR(MAX);

					-- PIVOIT 대상 날짜문자열 생성
				SET @mQuery = '';
				SELECT @mQuery = @mQuery + '[' + yyyymmdd + '], '
				FROM (
					SELECT *
					FROM(
						SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
								,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
							FROM [dbo].[scm_sys_calendar_m] a with(nolock)
							WHERE a.basis_yyyymmdd  BETWEEN @v_site_from_yyyymmdd AND @v_site_to_yyyymmdd
						GROUP BY a.basis_yyyymm, a.month_name	
						UNION ALL
						SELECT a.basis_yyyymmdd   AS yyyymmdd      
								, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
							FROM [dbo].[scm_sys_calendar_m] a with(nolock)
							WHERE a.basis_yyyymmdd  BETWEEN @v_site_from_yyyymmdd AND @v_site_to_yyyymmdd
						GROUP BY a.basis_yyyymmdd		
					) A WHERE yyyymmdd NOT LIKE 'M_%'
				  	
				) AS A
				ORDER BY sort_order_no  ;

				IF( LEN(@mQuery)>0)
				BEGIN
					SET @mQuery = LEFT(@mQuery, LEN(@mQuery) - 1);
				END;
			
				SET @mEXEC = '';
				SET @mEXEC = @mEXEC+'      SELECT  ' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			RN AS SITE_SEQ ' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,DENSE_RANK() OVER(PARTITION BY RN ORDER BY RN, MAIL_RECEIVER) AS REC_SEQ ' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,DENSE_RANK() OVER(PARTITION BY RN, MAIL_RECEIVER ORDER BY RN, MAIL_RECEIVER, item_id) AS ITEM_SEQ ' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,MAIL_RECEIVER ' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,division_id ' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,COMPANY_ID ' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,from_site_description		' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,item_id	' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,[dbo].[FN_GET_ITEM_NICKNAME](division_id, item_id) AS NICK_NAME	' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,measure_name	' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,seq	' +CHAR(10);
				SET @mEXEC = @mEXEC+' 			,'+@mQuery	 +CHAR(10);
				SET @mEXEC = @mEXEC+'       FROM ' +CHAR(10);
				SET @mEXEC = @mEXEC+'       ( ' +CHAR(10);
				SET @mEXEC = @mEXEC+'			SELECT  ' +CHAR(10);
				SET @mEXEC = @mEXEC+'				RN, MAIL_RECEIVER, division_id, ''' + @p_company_id + ''' AS COMPANY_ID, ' +CHAR(10);
				SET @mEXEC = @mEXEC+'				isnull(dbo.fn_get_scm_site_description(division_id, from_site ),''-'') AS from_site_description,  ' +CHAR(10);
				SET @mEXEC = @mEXEC+'				item_id, measure_name, seq, yyyymmdd, qty ' +CHAR(10);
				SET @mEXEC = @mEXEC+'			FROM #Tmp_Result_02 ' +CHAR(10);
				SET @mEXEC = @mEXEC+'			WHERE 1 = 1 ' +CHAR(10);
				SET @mEXEC = @mEXEC+'			AND RN = ''' + CONVERT(NVARCHAR(MAX), @v_fromsite_tmpcnt) + ''' '+CHAR(10);
				SET @mEXEC = @mEXEC+'		) T0 ' +CHAR(10);
				SET @mEXEC = @mEXEC+'       PIVOT ( ' +CHAR(10);
				SET @mEXEC = @mEXEC+'               SUM(qty) FOR  yyyymmdd IN ('+ @mQuery +') ' +CHAR(10);
				SET @mEXEC = @mEXEC+'             ) AS A'   +CHAR(10);
				SET @mEXEC = @mEXEC+'	   ORDER BY RN, DENSE_RANK() OVER(PARTITION BY RN ORDER BY RN, MAIL_RECEIVER), item_id, DENSE_RANK() OVER(PARTITION BY RN, MAIL_RECEIVER ORDER BY RN, MAIL_RECEIVER, item_id), seq' +CHAR(10);
			END

			--//TEST-03
			--EXEC (@mEXEC);
			--SELECT @mEXEC;
			--RETURN;

			INSERT INTO #TMP_Tbl_SSP_MAIL_SEND_BATCH_N
			EXEC (@mEXEC);
		
			--//TEST-04
			--SELECT * FROM #TMP_Tbl_SSP_MAIL_SEND_BATCH_N;
			--RETURN;
			--

			SET @v_receiver_tmpcnt = 0;
			SELECT 
				@v_receiver_cnt = MAX(REC_SEQ)
			FROM #TMP_Tbl_SSP_MAIL_SEND_BATCH_N
			WHERE 1 = 1
			AND SITE_SEQ = @v_fromsite_tmpcnt;

			WHILE @v_receiver_tmpcnt < @v_receiver_cnt
			BEGIN
			
				/********************************************************************************
				* HEAD CONT 
				********************************************************************************/
				SET @v_head_cont = '';
				SET @v_head_cont = @v_head_cont+ '<tr>'

				SET @v_head_cont = @v_head_cont+ '<th>' + 'Div' + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + 'Company' + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + 'From Site' + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + 'Model' + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + 'Nick Name' + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + 'Measure' + '</th>'
	
				SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_site_from_yyyymmdd) ), 23 )   + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_site_from_yyyymmdd) + 1 ), 23 )   + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_site_from_yyyymmdd) + 2 ), 23 )   + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_site_from_yyyymmdd) + 3 ), 23 )   + '</th>'
				SET @v_head_cont = @v_head_cont+ '<th>' + CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_site_from_yyyymmdd) + 4 ), 23 )   + '</th>'
	
				SET @v_head_cont = @v_head_cont+ '</tr>'

				SET @v_mail_title = '[SSP_Early Warning] Shipping Schedule Nagative value';
				SET @v_body_contents = 'The Negative stock vlaue of shipping schedule based on the shipment request. Please refer to the table below and adjust the shipping request.										
										Thank you
										Best regards.
							
									';
				SET @v_body_cont = '';

				SET @v_receiver_tmpcnt = @v_receiver_tmpcnt + 1;
				SET @v_item_tmpcnt = 0;
				SET @v_cnt = 0;

				SELECT 
					@v_mail_receiver = MAX(MAIL_RECEIVER)
				FROM #TMP_Tbl_SSP_MAIL_SEND_BATCH_N
				WHERE 1 = 1
				AND SITE_SEQ = @v_fromsite_tmpcnt
				AND REC_SEQ = @v_receiver_tmpcnt
				; 

				SET @v_to_mail = @v_mail_receiver+'@lgensol.com';

				--//TEST
				--SET @v_mail_title = @v_to_mail + '-' + @v_mail_title;

				DECLARE CUR_SEND CURSOR FOR
				SELECT
					MAIL_RECEIVER
					, division_id
					, COMPANY_ID
					, from_site_description
					, item_id
					, nick_name
					, measure_name
					, segment1
					, segment2
					, segment3
					, segment4
					, segment5
				FROM #TMP_Tbl_SSP_MAIL_SEND_BATCH_N
				WHERE 1 = 1
				AND SITE_SEQ = @v_fromsite_tmpcnt
				AND REC_SEQ = @v_receiver_tmpcnt
				ORDER BY MAIL_RECEIVER, division_id, COMPANY_ID, from_site_description, item_id, ITEM_SEQ
				;
			
				OPEN CUR_SEND;
				FETCH NEXT FROM CUR_SEND INTO @v_mail_receiver, @v_division_id, @v_company_id, @v_from_site_description, @v_item_id, @v_nick_name, @v_measure_name
									, @v_segment1, @v_segment2, @v_segment3, @v_segment4, @v_segment5

				WHILE @@FETCH_STATUS = 0
				BEGIN
				
					--//+++++++++++++++++++++++++++++++++++++++++++++=
					IF @v_cnt = 0
					BEGIN
						SET @v_body_cont = @v_body_cont+ '<tr>';
						SET @v_body_cont = @v_body_cont+ '<td rowspan=''6''>' + REPLACE(ISNULL(@v_division_id,''), CHAR(10),' ') + '</td>';
						SET @v_body_cont = @v_body_cont+ '<td rowspan=''6''>' + REPLACE(ISNULL(@v_company_id,''), CHAR(10),' ') + '</td>';
						SET @v_body_cont = @v_body_cont+ '<td rowspan=''6''>' + REPLACE(ISNULL(@v_from_site_description,''), CHAR(10),' ') + '</td>';
						SET @v_body_cont = @v_body_cont+ '<td rowspan=''6''>' + REPLACE(ISNULL(@v_item_id,''), CHAR(10),' ') + '</td>';
						SET @v_body_cont = @v_body_cont+ '<td rowspan=''6''>' + REPLACE(ISNULL(@v_nick_name,''), CHAR(10),' ') + '</td>';
					END
					SET @v_body_cont = @v_body_cont+ '<td>' + REPLACE(ISNULL(@v_measure_name,''), CHAR(10),' ') + '</td>'
					SET @v_cnt = @v_cnt + 1;

					IF @v_cnt = 6
					BEGIN
						SET @v_cnt = 0
					END

					IF @v_measure_name = 'BALANCE' and sign(@v_segment1) = -1
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''> <font color = ''red''> ' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment1 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</font></td>' 
					END
					ELSE 
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment1 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
					END

					IF @v_measure_name = 'BALANCE' and sign(@v_segment2) = -1
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''> <font color = ''red''> ' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment2 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</font></td>' 
					END
					ELSE 
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment2 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
					END

					IF @v_measure_name = 'BALANCE' and sign(@v_segment3) = -1
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''> <font color = ''red''> ' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment3 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</font></td>' 
					END
					ELSE 
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment3 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
					END

					IF @v_measure_name = 'BALANCE' and sign(@v_segment4) = -1
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''> <font color = ''red''> ' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment4 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</font></td>' 
					END
					ELSE 
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment4 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
					END

					IF @v_measure_name = 'BALANCE' and sign(@v_segment5) = -1
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''> <font color = ''red''> ' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment5 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</font></td>' 
					END
					ELSE 
					BEGIN 
						SET @v_body_cont = @v_body_cont+ '<td align=''right''>' + REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(@v_segment5 AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') + '</td>' 
					END
					SET @v_body_cont = @v_body_cont+ '</tr>'

					FETCH NEXT FROM CUR_SEND INTO @v_mail_receiver, @v_division_id, @v_company_id, @v_from_site_description, @v_item_id, @v_nick_name, @v_measure_name
									, @v_segment1, @v_segment2, @v_segment3, @v_segment4, @v_segment5
				END

				CLOSE CUR_SEND;
				DEALLOCATE CUR_SEND;

				SET @TABLE_BODY = '';
				SET @TABLE_BODY = ' <html>
									<head>
											<title>Untitled Document</title>
											<style>
												* {margin:0;padding:0;}
												body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
												table {border-collapse:collapse;width:100%;}
												table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
												table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
												table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;font-size:12px}
												table tbody td {padding:6px 8px;font-size:12px}
												table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:12px}
												.hori-table table thead td {text-align:center;padding:3px;}  
												.hori-table table tbody td {text-align:center;padding:3px;}
												.vertical-table, .hori-table {margin-bottom:20px;}
											</style>
											</head>
											<body>' +'</br>'+
													'<b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), '<br>') + '</b>' +
													'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'    +   
												'<table style=''border-top:2px solid #c8294b; width:1000px;''>
												<thead>' + ISNULL(@v_head_cont,'') +'</thead>
												<tbody>' + ISNULL(@v_body_cont, '') + '</tbody>
												</div>
											</body>
									</html>';
				--//메일 발송
				EXEC SCM_ADM_MAIL_SEND
					--@v_to_mail					--//'kahonmalu@lgensol.com'
					'jooyong026@lgespartner.com'
					, @v_mail_title
					, @TABLE_BODY
					, 'Y'
				;
				--MAIL 발송 LOG 저장
				EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 
					'MAIL'
					, '-'
					, @v_program_name
					, @v_division_id
					, @v_company_id
					, @v_from_site_description
					, @v_item_id
					, @v_nick_name
					, ''
					, ''
					, ''
					, ''
					, '' --p_send_pgm
					, @v_to_mail
				;
				--SELECT @v_to_mail, @v_mail_title, @v_body_cont, @TABLE_BODY;
			END
		END				
	END TRY
	BEGIN CATCH
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_SEND')
		BEGIN
			CLOSE CUR_SEND;
			DEALLOCATE CUR_SEND;
		END

		BEGIN
			INSERT INTO scm_sys_log_batch 
			(
				program_name
				, log_type
				, log_count
				, log_message
				, description
				, event_date
				, creation_date
				, created_by
				, last_update_date
				, last_updated_by
			)
			VALUES 
			(
				ERROR_PROCEDURE()
				, 'ERROR'
				, NULL
				, ERROR_MESSAGE()
				, NULL
				, SYSDATETIME()
				, SYSDATETIME()
				, ERROR_PROCEDURE()
				, SYSDATETIME()
				, ERROR_PROCEDURE()
			);
				
			--IF @@TRANCOUNT > 0
			--	COMMIT WORK;
		END;
		BEGIN
			DECLARE @v_error_message NVARCHAR(1000);
			SET @v_error_message = SUBSTRING(ERROR_MESSAGE(),1,1000);

			--MAIL 발송 LOG 저장
			EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 
				'ERROR'
				, '-'
				, @v_program_name
				, 'MAIN ERROR' 
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, @v_error_message --p_send_pgm
				, ''
			;
			--IF @@TRANCOUNT > 0
			--	COMMIT WORK;
		END
		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
			
		set @p_log_messge = @v_error_message;
		return -1;

	END CATCH;

	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	--임시테이블 삭제
	IF OBJECT_ID('tempdb..#Tmp_BOHData') IS NOT NULL	
		DROP TABLE #Tmp_BOHData;

	IF OBJECT_ID('tempdb..#Tmp_RowData') IS NOT NULL	
		DROP TABLE #Tmp_RowData;
	
	IF OBJECT_ID('tempdb..#Tmp_Raw_Result_Table') IS NOT NULL	
		DROP TABLE #Tmp_Raw_Result_Table;

	IF OBJECT_ID('tempdb..#Tmp_Raw_Result_Table') IS NOT NULL	
		DROP TABLE #Tmp_Raw_Result_Table;
	
	IF OBJECT_ID('tempdb..#Tmp_Result_01') IS NOT NULL	
		DROP TABLE #TMP_Tbl_SSP_MAIL_SEND_BATCH_N;
	
	IF OBJECT_ID('tempdb..#Tmp_Result_02') IS NOT NULL	
		DROP TABLE #Tmp_Result_02;
	
	IF OBJECT_ID('tempdb..#TMP_Tbl_SSP_MAIL_SEND_BATCH_N') IS NOT NULL
		DROP TABLE #TMP_Tbl_SSP_MAIL_SEND_BATCH_N;
	
	return 1;
END
