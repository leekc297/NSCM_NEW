




/*
 * Program ID   : SSP0060_GET_SHIPMENT_PLAN
 * Description  : 자동차 Shipment Plan
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/08/30   mcThej			Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
 * 2019/10/14   mcThej			Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT - ERP_QTY (ssp->scp), 속도 수정
 * 2019/10/15   juhlee          Pack 생산 창고 추가 CMA_BMA . 2019.10.15 (requested by 김광희)
 * 2019/10/15   mcThej          MES 추가
 * 2019/10/17   juhlee          Pack 생산 창고 추가 CMA_BMA BOH수량에 추가  (requested by 김광희)
 * 2019/10/28   mcThej          BOH = BOH + MES_TOTAL - (MES_OQC_NG + MES_QMS/MES_HOLD)
 * 2020/01/21   juhlee          [C20200121-000352]  ESS Packer출하 적용 
                                 - [C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V) 
								 - [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외)  
                                 - [C20200121-000352]-3 : Production Plan Measure에 Paker생산계획 추가(SCP_ANL_PRODUCTION_PLAN 의 PROD_PLAN_AMEND measure)
 * 2020/02/13   KIMYONGHO		CONTAINER Measure 수식 변경 , MAIN SHEET 조회 시 TO_SITE 구별 할수 없어 SUM -> MAX 로 변경
 * 2020/03/17   juhlee	        BOH 수량에 CMA_BMA 제외 (requested by 김광희) 
 * 2021/06/01   SSP Pjt.        AS ERP 재고 적용
 * 2021/06/14   SSP Pjt.        화면속도개선(SCM_DNM_STOCK_V -> SSP_DNM_STOCK_C)
 * 2022/02/16   SSP Pjt.        SSP_DNM_MES_STOCK_81_82 -> SSP_DNM_GMES_STOCK_81_82
 * 2022.04.23   SSP Pjt.        C20220419-000607 / SSP~oWMS 사외창고 재고 I/F개선 요청
 * 2023/09/01   jilee           반제품->제품 코드 변환 작업
 * 2024/02/19   jilee           SSP - NEW FP Ship Avaliable 신규 I/F 반영
 * 2024/05/10   hsbang          확정구간 조회 일수(CONFIRM_DAY)를 펑션 FN_GET_ANL_SHIP_FROZEN_DAY_CNT] 에서 가져오도록 반영
 * 2024/11/11   jilee           과거이력 보완 작업
 * 2026/08/13	강주용			[E20260811-000692] ESMI AZ 링크 2호기 생산계획 받아오지 못하는 현상 처리
 * ex)
	EXEC SSP0060_GET_SHIPMENT_PLAN @p_division_id = '81', @p_company_id = 'C100', @p_from_site = '', @p_plan_start_yyyymmdd = '20190909', @p_from_yyyymmdd = '20190909', @p_to_yyyymmdd = '20191102', @p_item_id = 'APVCCHORI-A1', @p_user_id = 'kahonmalu', @p_program_id = 'SSP0060', @p_sheet_name ='Shipment Plan', @p_real_flag = 'Y'
	EXEC SSP0060_GET_SHIPMENT_PLAN @p_division_id='81', @p_company_id='G480', @p_from_site='', @p_plan_start_yyyymmdd='20240514', @p_from_yyyymmdd='20240506', @p_to_yyyymmdd='20240708', @p_item_id='', @p_user_id='flystone98', @p_program_id='SSP0021', @p_sheet_name='Shipment Plan', @p_real_flag='Y'
 */
CREATE PROCEDURE [dbo].[SSP0060_GET_SHIPMENT_PLAN]
	@p_division_id			VARCHAR(10)
	,@p_company_id			NVARCHAR(100)
	,@p_from_site			NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(8)
	,@p_from_yyyymmdd		NVARCHAR(8)
	,@p_to_yyyymmdd			NVARCHAR(8)
	,@p_item_id				NVARCHAR(MAX)
	,@p_product_level1		NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_program_id			NVARCHAR(MAX) = 'SSP0060' 
	,@p_sheet_name			NVARCHAR(MAX) = 'Shipment Plan'
	,@p_real_flag			CHAR(1)
AS  
  
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	
	
	DECLARE @v_from_yyyymmdd	NVARCHAR(8);
	DECLARE @v_to_yyyymmdd		NVARCHAR(8);
	DECLARE @v_boh_yyyymmdd		NVARCHAR(8);

	DECLARE @mQry_sum NVARCHAR(MAX);
	DECLARE @mEXEC NVARCHAR(MAX);
	DECLARE @mDAY_QTY NVARCHAR(MAX);

	DECLARE @p_stock_yyyymmdd NVARCHAR(8);

	DECLARE @v_seq				INT;

	SET @p_stock_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -3, CONVERT(VARCHAR, @p_from_yyyymmdd, 121)), 112); --FROM -3일

	SET @v_from_yyyymmdd = @p_from_yyyymmdd;
	SET @v_to_yyyymmdd = @p_to_yyyymmdd;
	SET @v_boh_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(VARCHAR, @p_from_yyyymmdd, 121)), 112); --FROM -1일

	DECLARE @v_cnt_usr_measure	INT =0;

	SET @v_cnt_usr_measure = (
								SELECT COUNT(*) 
								FROM scm_mst_titleset_user   with(nolock)
								WHERE 1=1
								 AND program_id  =  @p_program_id
								 AND sheet_name  =  @p_sheet_name 
								 AND user_id     =  @p_user_id
							  )
	DECLARE @v_app_type    NVARCHAR(8) = 'SSP';
	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/

	-- SHIPMENT BOH
	IF OBJECT_ID('tempdb..#Tmp_BOHData_STORAGE') IS NOT NULL	
		DROP TABLE #Tmp_BOHData_STORAGE;
		
	IF OBJECT_ID('tempdb..#Tmp_BOHData') IS NOT NULL	
		DROP TABLE #Tmp_BOHData;

	-- SHIPMENT RESUlT
	IF OBJECT_ID('tempdb..#Tmp_SHIPMENT_RESULT') IS NOT NULL	
		DROP TABLE #Tmp_SHIPMENT_RESULT;

	-- SHIPMENT ROW DATA
	IF OBJECT_ID('tempdb..#Tmp_RowData') IS NOT NULL	
		DROP TABLE #Tmp_RowData;

	IF OBJECT_ID('tempdb..#Tmp_Result_PIVOT_Table') IS NOT NULL	
		DROP TABLE #Tmp_Result_PIVOT_Table;

	IF OBJECT_ID('tempdb..#Tmp_Result_PIVOT_Table_Old') IS NOT NULL	
		DROP TABLE #Tmp_Result_PIVOT_Table_Old;

	IF OBJECT_ID('tempdb..#Tmp_Result_Table') IS NOT NULL	
		DROP TABLE #Tmp_Result_Table;

	IF OBJECT_ID('tempdb..#Tmp_Result_Detail_Table') IS NOT NULL	
		DROP TABLE #Tmp_Result_Detail_Table;

	IF OBJECT_ID('tempdb..#TblDynamicTitlest_SSP0060') IS NOT NULL	
		DROP TABLE #TblDynamicTitlest_SSP0060;


	SELECT * INTO #TblDynamicTitlest_SSP0060 
	FROM SCM_MST_TITLESET_USER WITH(NOLOCK)
	WHERE PROGRAM_ID  = @p_program_id
		AND SHEET_NAME  = @p_sheet_name
		AND USER_ID     = @p_user_id;

	CREATE TABLE #Tmp_Result_Table
	(
		DIVISION_ID			NVARCHAR(30)
		, FROM_SITE			NVARCHAR(30)
		, ITEM_ID			NVARCHAR(50)
		, PRODUCT_LEVEL1	NVARCHAR(50)
		, MEASURE			NVARCHAR(50)
		, TO_SITE			NVARCHAR(50)
		, TRANSPORT_MODE	NVARCHAR(50)
		, INCOTERMS			NVARCHAR(50)
		, FCST_TYPE			NVARCHAR(50)
		, SEQ			INT
		, CONFIRM_DAY   INT
		, YYYYMMDD		NVARCHAR(8)
		, QTY			NUMERIC(20, 10)
		, LOT_YN		NVARCHAR(100)
		, EDIT_YN		NVARCHAR(100)
	);

	CREATE TABLE #Tmp_Result_Detail_Table
	(
		DIVISION_ID			NVARCHAR(30)
		, FROM_SITE			NVARCHAR(30)
		, ITEM_ID			NVARCHAR(50)
		, PRODUCT_LEVEL1	NVARCHAR(50)
		, MEASURE			NVARCHAR(50)
		, TO_SITE			NVARCHAR(50)
		, TRANSPORT_MODE	NVARCHAR(50)
		, INCOTERMS			NVARCHAR(50)
		, FCST_TYPE			NVARCHAR(50)
		, SEQ			INT
		, CONFIRM_DAY   INT
		, YYYYMMDD		NVARCHAR(8)
		, QTY			NUMERIC(20, 10)
		, LOT_YN		NVARCHAR(100)
		, EDIT_YN		NVARCHAR(100)
	);
	/********************************************************************************/

	--////////////////////////////////////////////////////////////////////////////////--
	--//1. BOH																		//--
	--////////////////////////////////////////////////////////////////////////////////--

	WITH MST_STOCK AS
	(

		SELECT
			S.division_id
			, S.company_id
			, S.scm_site_id
			, S.item_id
			, S.ssp_qty
			, S.scm_qty
			, S.cutoff_date
			, S.site_id
			, S.storage_id
			, S.PLANT_ID
			, S.OPERATION_ID
			, S.stock_type
		FROM [dbo].[SSP_DNM_STOCK_C] AS S WITH(NOLOCK) --SCM_DNM_STOCK_V WITH(NOLOCK) 
		WHERE 1 = 1
		AND S.division_id = @p_division_id
		AND S.company_id = @p_company_id
		AND S.cutoff_date >  @p_stock_yyyymmdd -- 현재일 - 3
		AND S.cutoff_date = @v_boh_yyyymmdd	
		AND ((@p_from_site IS NULL OR @p_from_site ='') OR S.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
		AND ((@p_item_id IS NULL OR @p_item_id ='')	OR S.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
	),
	------------------------------------------------------------------------------------------------------------------------------------
    --[C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V) 
	PACKER_STOCK AS -- SSP_DNM_ESS_PACKER_STOCK_V  ESS(82) PACKER STOCK,  STORAGE_ID : 6000(구미 People works), E400(남경 People works) 
	(
		SELECT
			   P.division_id
			 , P.company_id
			 , P.scm_site_id
			 , P.item_id
			 , P.ssp_qty
			 , P.cutoff_date
		 FROM [dbo].[SSP_DNM_ESS_PACKER_STOCK_V] AS P WITH(NOLOCK) 
		WHERE 1 = 1
		  AND P.division_id = @p_division_id
		  AND P.company_id =  @p_company_id
		  AND P.cutoff_date > @p_stock_yyyymmdd -- 현재일 - 3
		  AND P.cutoff_date = @v_boh_yyyymmdd	
		  AND ((@p_from_site IS NULL OR @p_from_site ='') OR P.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
		  AND ((@p_item_id IS NULL OR @p_item_id ='')	    OR P.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))

	),
    ------------------------------------------------------------------------------------------------------------------------------------
	MST_LOCATION AS
	(
		SELECT
			   tt0.DIVISION_ID, tt0.STORAGE_ID, tt0.SCM_SITE_ID, tt0.LOCATION_CODE, tt0.PLANT_ID, tt1.COMPANY_ID, tt0.VALID_YN
		  FROM SSP_MST_LOCATION_V tt0 WITH(NOLOCK)
		       INNER JOIN SCM_MST_SITE tt1 WITH(NOLOCK)
			ON tt0.DIVISION_ID	= tt1.DIVISION_ID	
		   AND tt0.SCM_SITE_ID	= tt1.SCM_SITE_ID
		   AND tt0.PLANT_ID		= tt1.PLANT_ID
		   AND tt1.DIVISION_ID	= @p_division_id	
		   AND tt1.COMPANY_ID	= @p_company_id
		   AND tt1.VALID_YN		='Y'					
		   AND tt1.site_type	= 'PLANT' 
		WHERE 1 = 1
		AND tt0.VALID_YN ='Y'
		AND tt0.DIVISION_ID = @p_division_id
		AND tt1.company_id = @p_company_id
		AND tt0.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING','CMA_BMA')
		AND ((@p_from_site IS NULL OR @p_from_site ='') OR tt0.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
		GROUP BY tt0.DIVISION_ID, tt0.STORAGE_ID, tt0.SCM_SITE_ID, tt0.LOCATION_CODE, tt0.PLANT_ID, tt1.COMPANY_ID,	tt0.VALID_YN

		UNION ALL
		SELECT DISTINCT
			   tt0.SEGMENT1 AS DIVISION_ID
			  ,tt0.SEGMENT4 AS STORAGE_ID
			  ,tt0.SEGMENT2 AS SCM_SITE_ID
			  ,'AS' AS LOCATION_CODE
			  ,tt0.SEGMENT3 AS PLANT_ID
			  ,tt1.COMPANY_ID
			  ,tt0.VALID_YN
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL tt0 WITH(NOLOCK)
		       INNER JOIN SCM_MST_SITE tt1 WITH(NOLOCK)
		    ON tt0.SEGMENT1 = tt1.DIVISION_ID	
		   AND tt0.SEGMENT2 = tt1.SCM_SITE_ID
		   AND tt0.SEGMENT3 = tt1.PLANT_ID
		   and tt0.LOOKUP_TYPE = 'SSP_AS_DIV_SLOC'
		   and tt0.valid_yn = 'Y'
		   AND tt1.DIVISION_ID = @p_division_id	
		   AND tt1.COMPANY_ID  = @p_company_id
		   AND tt1.VALID_YN ='Y'					
		   AND tt1.site_type = 'PLANT' 
	     WHERE 1 = 1
		   AND tt0.VALID_YN ='Y'
		   AND tt0.SEGMENT1   = @p_division_id
		   AND tt1.company_id = @p_company_id
		   AND ((@p_from_site IS NULL OR @p_from_site ='') OR tt0.SEGMENT2 IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
	)
	
	SELECT
			TMP_BOH.DIVISION_ID
		,	TMP_BOH.FROM_SITE
		,	ISNULL(IM.APPLIED_MODEL, TMP_BOH.ITEM_ID) AS ITEM_ID
		,	CASE WHEN FI.GROUP_CODE1 = '' THEN '-' ELSE ISNULL(FI.GROUP_CODE1,'-') END AS PRODUCT_LEVEL1
		,	'' AS TO_SITE
		,	'' AS TRANSPORT_MODE
		,	'' AS INCOTERMS
		,	'' AS FCST_TYPE
		,	CONVERT(NVARCHAR(8), TMP_BOH.YYYYMMDD, 112) AS YYYYMMDD
		,	TMP_BOH.BOH_TYPE AS BOH_TYPE
		,	SUM(TMP_BOH.BOH_QTY) AS BOH_QTY
		,	TMP_BOH.SEQ--,	STORAGE_ID
	INTO #Tmp_BOHData_STORAGE
	FROM
	(
		--//BOH : 5s==================================================================================================================================
		SELECT
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.ITEM_ID
			, T0.BOH_TYPE
			, T0.YYYYMMDD
			, SUM(T0.BOH_QTY) AS BOH_QTY
			, T0.SEQ
		FROM
		(
			--MES TOTAL - (OQC_NG + QMS/MES_HOLD)
			SELECT
				T0.DIVISION_ID
				, T0.FROM_SITE
				, T0.ITEM_ID
				, 'BOH'					AS BOH_TYPE
				, T0.YYYYMMDD
				, ISNULL(SUM(TOTAL) - (SUM(OQC_NG) + SUM(QMS_MES_Hold)), 0) AS BOH_QTY
				, 11						AS SEQ
			FROM
			(
				SELECT
					DIVISION_ID,
					FROM_SITE,
					ITEM_ID,
					@v_boh_yyyymmdd AS YYYYMMDD,
					CASE WHEN AVAILABLE_YN = 'N' AND OQC_INSP_RESULT = 'N' THEN SUM(ISNULL(LOT_QTY, 0)) ELSE 0  END AS OQC_NG,
					CASE WHEN AVAILABLE_YN = 'N' AND (QMS_HOLD_YN = 'Y' OR MES_HOLD_YN = 'Y') THEN SUM(ISNULL(LOT_QTY, 0)) ELSE 0  END AS QMS_MES_Hold,
					SUM(ISNULL(LOT_QTY, 0)) AS TOTAL
				FROM SSP_DNM_GMES_STOCK_81_82 with(nolock)
				WHERE 1 = 1
				AND DIVISION_ID = @p_division_id
				AND COMPANY_ID = @p_company_id
				AND YYYYMMDD = @p_plan_start_yyyymmdd
				AND ((@p_from_site IS NULL OR @p_from_site ='') OR FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
				AND ((@p_item_id IS NULL OR @p_item_id ='')	OR ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
				GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, AVAILABLE_YN, OQC_INSP_RESULT, MES_HOLD_YN, QMS_HOLD_YN
			) AS T0
			GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD

			UNION ALL
			--OWMS
			SELECT 
				  W.DIVISION_ID
				, W.FROM_SITE
				, W.ITEM_ID
				, 'BOH'						AS BOH_TYPE
				, W.CUTOFF_DATE				AS YYYYYMMDD
				, SUM(W.AVAILABLE_QTY)		AS BOH_QTY
				, 11			AS SEQ				--MEASURE 위치와 동일하게
			 FROM SSP_ANL_OWMS_STOCK_C2 AS W WITH(NOLOCK)
				  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
			   ON L.LOOKUP_TYPE = 'OWMS_STOCK_STATUS'				--C20220419-000607
			  AND L.VALID_YN = 'Y'
			  AND L.ATTRIBUTE1 = 'Y'
			  AND L.SEGMENT1    = W.STOCK_STATUS

			WHERE 1 = 1
			AND W.DIVISION_ID = @p_division_id
			AND W.COMPANY_ID = @p_company_id
			AND W.CUTOFF_DATE = @v_boh_yyyymmdd	
			AND ((@p_from_site IS NULL OR @p_from_site ='') OR W.FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
			AND ((@p_item_id IS NULL OR @p_item_id ='')	OR W.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
			GROUP BY W.DIVISION_ID, W.FROM_SITE, ITEM_ID, W.CUTOFF_DATE

		) AS T0
		GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.BOH_TYPE, T0.YYYYMMDD, T0.SEQ

		UNION ALL
		--//ERP : 3S==================================================================================================================================
		SELECT
			   T0.division_id		AS DIVISION_ID
			 , T0.scm_site_id		AS FROM_SITE
			 , T0.item_id			AS ITEM_ID
			 , 'ERP'				AS BOH_TYPE
			 , T0.CUTOFF_DATE			AS YYYYMMDD
			 , T0.SCM_QTY           AS BOH_QTY
			 , 9					AS SEQ				--MEASURE 위치와 동일하게
			 --, T0.storage_id			AS STORAGE_ID
		  FROM MST_STOCK T0 WITH(NOLOCK)
		       INNER JOIN MST_LOCATION T1
			ON T0.division_id = T1.DIVISION_ID			
		   AND T0.storage_id = T1.STORAGE_ID
		 --AND T0.storage_id IN (SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(T1.STORAGE_ID,','))
		   AND T0.PLANT_ID = T1.PLANT_ID				
		   AND T0.COMPANY_ID = T1.COMPANY_ID
		   AND T0.scm_site_id = T1.SCM_SITE_ID
		   AND T1.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING','CMA_BMA', 'AS')
		 WHERE 1 = 1
		   AND T0.stock_type = 'INVENTORY'
		   AND ((@p_from_site IS NULL OR @p_from_site ='') OR T0.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
		   AND ((@p_item_id IS NULL OR @p_item_id ='')	OR T0.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
	
		UNION ALL
		--//oWMS : ==================================================================================================================================
		SELECT 
			   W.DIVISION_ID
			 , W.FROM_SITE
			 , W.ITEM_ID
			 , 'oWMS'					AS BOH_TYPE
			 , W.CUTOFF_DATE			AS YYYYYMMDD
			 --, SUM(W.STOCK_QTY)			AS BOH_QTY
			 , SUM(W.AVAILABLE_QTY)			AS BOH_QTY
			 , 7						AS SEQ				--MEASURE 위치와 동일하게
			 --, '-'					AS STORAGE_ID
		  FROM SSP_ANL_OWMS_STOCK_C2 AS W WITH(NOLOCK)
			   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
		    ON L.LOOKUP_TYPE = 'OWMS_STOCK_STATUS'				--C20220419-000607
		   AND L.VALID_YN = 'Y'
		   AND L.ATTRIBUTE1 = 'Y'
		   AND L.SEGMENT1    = W.STOCK_STATUS	

		WHERE 1 = 1
		AND W.DIVISION_ID = @p_division_id
		AND W.COMPANY_ID = @p_company_id
		AND W.CUTOFF_DATE = @v_boh_yyyymmdd	
		AND ((@p_from_site IS NULL OR @p_from_site ='') OR W.FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
		AND ((@p_item_id IS NULL OR @p_item_id ='')	OR W.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
		GROUP BY W.DIVISION_ID, W.FROM_SITE, W.ITEM_ID, W.CUTOFF_DATE
	
		UNION ALL
		
		--//MES : 0S==================================================================================================================================
		SELECT
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.ITEM_ID
			, 'MES'					AS BOH_TYPE
			, T0.YYYYMMDD
			, ISNULL(SUM(TOTAL) - (SUM(OQC_NG) + SUM(QMS_MES_Hold)), 0) AS BOH_QTY
			, 8						AS SEQ
		FROM
		(
			SELECT
				DIVISION_ID,
				FROM_SITE,
				ITEM_ID,
				@v_boh_yyyymmdd AS YYYYMMDD,
				CASE WHEN AVAILABLE_YN = 'N' AND OQC_INSP_RESULT = 'N' THEN SUM(ISNULL(LOT_QTY, 0)) ELSE 0  END AS OQC_NG,
				CASE WHEN AVAILABLE_YN = 'N' AND (QMS_HOLD_YN = 'Y' OR MES_HOLD_YN = 'Y') THEN SUM(ISNULL(LOT_QTY, 0)) ELSE 0  END AS QMS_MES_Hold,
				SUM(ISNULL(LOT_QTY, 0)) AS TOTAL
			FROM SSP_DNM_GMES_STOCK_81_82 with(nolock)
			WHERE 1 = 1
			AND DIVISION_ID = @p_division_id
			AND COMPANY_ID = @p_company_id
			AND YYYYMMDD = @p_plan_start_yyyymmdd
			AND ((@p_from_site IS NULL OR @p_from_site ='') OR FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
			AND ((@p_item_id IS NULL OR @p_item_id ='')	OR ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
			GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, AVAILABLE_YN, OQC_INSP_RESULT, MES_HOLD_YN, QMS_HOLD_YN
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
				, 11						AS SEQ				--MEASURE 위치와 동일하게
			FROM PACKER_STOCK T0 WITH(NOLOCK)
			WHERE 1 = 1
			AND T0.DIVISION_ID = @p_division_id
			AND T0.COMPANY_ID = @p_company_id
			AND ((@p_from_site IS NULL OR @p_from_site ='') OR T0.SCM_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
			AND ((@p_item_id IS NULL OR @p_item_id ='')	OR T0.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))

		UNION ALL --  -- ESS PACKER 재고 -ERP MEASURE
			SELECT
				 T0.division_id			AS DIVISION_ID
				, T0.scm_site_id		AS FROM_SITE
				, T0.item_id			AS ITEM_ID
				, 'ERP'					AS BOH_TYPE
				, cutoff_date			AS YYYYMMDD
				, ISNULL(T0.ssp_qty, 0)     AS BOH_QTY
				, 9						AS SEQ				--MEASURE 위치와 동일하게
			FROM PACKER_STOCK T0 WITH(NOLOCK)
			WHERE 1 = 1
			AND T0.DIVISION_ID = @p_division_id
			AND T0.COMPANY_ID = @p_company_id
			AND ((@p_from_site IS NULL OR @p_from_site ='') OR T0.SCM_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
			AND ((@p_item_id IS NULL OR @p_item_id ='')	OR T0.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
	) AS TMP_BOH
	JOIN SCM_MST_SITE S WITH(NOLOCK) 
	ON S.DIVISION_ID = TMP_BOH.DIVISION_ID 
	AND S.SCM_SITE_ID = TMP_BOH.FROM_SITE 			
    LEFT OUTER JOIN SCM_MST_ITEM_SN IM WITH(NOLOCK) 
	ON   IM.DIVISION_ID = TMP_BOH.DIVISION_ID							   
	AND  IM.COMPANY_ID = @p_company_id
	AND  IM.SITE_ID = S.SITE_ID
	AND  IM.ITEM_ID = TMP_BOH.ITEM_ID
	AND  IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')	
	LEFT OUTER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
	ON   FI.DIVISION_ID = TMP_BOH.DIVISION_ID							   
	AND  FI.ITEM_ID = TMP_BOH.ITEM_ID
	WHERE ((@p_product_level1 IS NULL OR @p_product_level1 ='')	OR FI.GROUP_CODE1 IN (SELECT token FROM dbo.String_Split(@p_product_level1, ',')))
	GROUP BY TMP_BOH.DIVISION_ID, TMP_BOH.FROM_SITE, IM.APPLIED_MODEL, TMP_BOH.ITEM_ID, FI.GROUP_CODE1
		  ,  TMP_BOH.YYYYMMDD, TMP_BOH.BOH_TYPE, TMP_BOH.SEQ--, STORAGE_ID
	;

	SELECT
		DIVISION_ID
		,		FROM_SITE
		,		ITEM_ID
		, 		PRODUCT_LEVEL1
		,	'' AS TO_SITE
		,	'' AS TRANSPORT_MODE
		,	'' AS INCOTERMS
		,	'' AS FCST_TYPE
		,		CONVERT(NVARCHAR(8), YYYYMMDD, 112) AS YYYYMMDD
		,		BOH_TYPE AS BOH_TYPE
		,		SUM(BOH_QTY) AS BOH_QTY
		,	SEQ
	INTO #Tmp_BOHData
	FROM #Tmp_BOHData_STORAGE WITH(NOLOCK)
	GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID,  PRODUCT_LEVEL1, YYYYMMDD, BOH_TYPE, SEQ;
	--//END BOH : 5S////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
	
	--select * from #Tmp_BOHData;
	--return;

	IF @p_real_flag = 'Y'
	BEGIN
		--////////////////////////////////////////////////////////////////////////////////--
		--//2. DATA ROW DATE															//--
		--////////////////////////////////////////////////////////////////////////////////--
		-- ERP 출하실적
		SELECT T0.*
		INTO #Tmp_SHIPMENT_RESULT
		FROM (-- ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상 
				SELECT  E.DIVISION_ID             AS DIVISION_ID
				,       E.CONFIRM_ID              AS CONFIRM_ID
				,       E.ORDER_NO				  AS ERP_SO_NO 
				,       E.EXFACTORY_DATE          AS YYYYMMDD
				,       E.TRANSPORT_MODE		  AS TRANSPORT_MODE
				,       E.INCOTERMS				  AS INCOTERMS
				,		E.ETA_DATE				  AS ETA_DATE
				,		E.ETD_DATE				  AS ETD_DATE
				,		E.FROM_SCM_SITE_ID		  AS FROM_SITE
				,		E.TO_SCM_SITE_ID		  AS TO_SITE
				,		E.ITEM_ID				  AS ITEM_ID
				,       SUM(E.EXFACTORY_QTY )     AS RESULT_QTY 
				FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
					JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
						ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
					AND L.VALID_YN = 'Y'
					AND L.SEGMENT1    = E.SSP_TYPE
				JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
					ON E.FROM_SCM_SITE_ID	= S.SCM_SITE_ID				 
				   AND E.DIVISION_ID	= S.DIVISION_ID				 
				   AND S.SITE_TYPE		= 'PLANT'					 				 
				JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 
					ON E.ITEM_ID		= T.ITEM_ID					 
				   AND E.DIVISION_ID	= T.DIVISION_ID				 
				   AND S.COMPANY_ID		= T.COMPANY_ID				 
				   AND T.ITEM_TYPE		NOT IN ('Q','R')
				WHERE 1=1
				AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
				AND   E.CONFIRM_ID LIKE 'C%'		
				AND   E.DIVISION_ID  = @p_division_id  
				AND   E.COMPANY_ID = @p_company_id
				AND ( ( @p_from_site   IS NULL OR @p_from_site ='')  OR E.FROM_SCM_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
				AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR E.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
				--AND   (E.EXFACTORY_DATE >= @p_plan_start_yyyymmdd  AND E.EXFACTORY_DATE < @v_to_yyyymmdd)
				AND   (E.EXFACTORY_DATE >= @v_from_yyyymmdd  AND E.EXFACTORY_DATE < @p_plan_start_yyyymmdd)
				AND   E.ATTRIBUTE2 != 'E'
				GROUP BY E.DIVISION_ID 
				,        E.CONFIRM_ID
				,        E.ORDER_NO
				,        E.EXFACTORY_DATE
				,        E.TRANSPORT_MODE
				,        E.INCOTERMS		
				,		 E.ETA_DATE		
				,		 E.ETD_DATE
				,		 E.FROM_SCM_SITE_ID	
				,		 E.TO_SCM_SITE_ID	
				,		 E.ITEM_ID
				UNION ALL
				-- ERP 출하실적에서 CONFIRM_ID 없는 실적 
				SELECT  E.DIVISION_ID             AS DIVISION_ID
				,       '-'                       AS CONFIRM_ID
				,       E.ORDER_NO				  AS ERP_SO_NO 
				,       E.FROM_SCM_SITE_ID        AS FROM_SITE                                                                    
				,       ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID)     AS TO_SITE   
				,       E.ITEM_ID                 AS ITEM_ID
				,       E.EXFACTORY_DATE          AS YYYYMMDD
				,       E.TRANSPORT_MODE		  AS TRANSPORT_MODE
				,       E.INCOTERMS				  AS INCOTERMS
				,		E.ETA_DATE				  AS ETA_DATE
				,		E.ETD_DATE				  AS ETD_DATE
				,       SUM(E.EXFACTORY_QTY )     AS QTY  
				FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
				JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
					ON E.FROM_SCM_SITE_ID	= S.SCM_SITE_ID				 
				   AND E.DIVISION_ID	= S.DIVISION_ID				 
				   AND S.SITE_TYPE		= 'PLANT'
				JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 
					ON E.ITEM_ID		= T.ITEM_ID					 
				   AND E.DIVISION_ID	= T.DIVISION_ID				 
				   AND S.COMPANY_ID		= T.COMPANY_ID				 
				   AND T.ITEM_TYPE		NOT IN ('Q','R')
				JOIN  SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만 
					ON F.ITEM_ID = E.ITEM_ID 
					AND F.DIVISION_ID = E.DIVISION_ID
				JOIN   SCM_MST_SITE FS WITH(NOLOCK)
					ON FS.SCM_SITE_ID = E.FROM_SCM_SITE_ID 
					AND FS.DIVISION_ID = E.DIVISION_ID 
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
					ON L.LOOKUP_TYPE = 'ERP_ORDER_TYPE'
				AND L.VALID_YN = 'Y'
				AND L.SEGMENT1    = E.ORDER_TYPE_CODE 	
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK)
						ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE 
					AND L3.SEGMENT1    = E.DIVISION_ID 
					AND L3.SEGMENT2    = E.SOLDTO_CODE
					AND L3.SEGMENT3    = E.SHIPTO_CODE					    
				WHERE 1=1
				AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
				AND   ISNULL(E.CONFIRM_ID,'') NOT LIKE  'C%'
				AND   (E.EXFACTORY_DATE >= @v_from_yyyymmdd  AND E.EXFACTORY_DATE < @p_plan_start_yyyymmdd)
				AND   E.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외 
				AND   E.STORAGE_ID NOT IN (SELECT SEGMENT1 
										FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
										WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
											AND VALID_YN = 'Y'
										)	-- 사외 창고 제외 LOOKUP 관리
				AND   E.DIVISION_ID  = @p_division_id  
				AND   E.COMPANY_ID = @p_company_id
				AND ( ( @p_from_site IS NULL OR @p_from_site ='')  OR E.FROM_SCM_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
				AND ( ( @p_item_id   IS NULL OR @p_item_id   ='')  OR E.ITEM_ID          IN (SELECT token FROM dbo.String_Split(@p_item_id  ,',')) )
				AND   E.ATTRIBUTE2 != 'E'
				GROUP BY E.DIVISION_ID
				,        E.ORDER_NO
				,        E.FROM_SCM_SITE_ID                                                                           
				,        ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID) 
				,        E.ITEM_ID
				,        E.EXFACTORY_DATE
				,        E.TRANSPORT_MODE
				,        E.INCOTERMS		
				,		 E.ETA_DATE		
				,		 E.ETD_DATE
				,		 E.FROM_SCM_SITE_ID	
				,		 E.TO_SCM_SITE_ID
			) T0
			/*
		WITH RESULT_ERP_C AS 
		(
			-- ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상 
			SELECT  E.DIVISION_ID             AS DIVISION_ID
			,       E.CONFIRM_ID              AS CONFIRM_ID
			,       E.ORDER_NO				  AS ERP_SO_NO 
			,       E.EXFACTORY_DATE          AS YYYYMMDD
			,       E.TRANSPORT_MODE		  AS TRANSPORT_MODE
			,       E.INCOTERMS				  AS INCOTERMS
			,		E.ETA_DATE				  AS ETA_DATE
			,		E.ETD_DATE				  AS ETD_DATE
			,		E.FROM_SCM_SITE_ID		  AS FROM_SITE
			,		E.TO_SCM_SITE_ID		  AS TO_SITE
			,		E.ITEM_ID				  AS ITEM_ID
			,       SUM(E.EXFACTORY_QTY )     AS RESULT_QTY 
			FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
					ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
				AND L.VALID_YN = 'Y'
				AND L.SEGMENT1    = E.SSP_TYPE
			JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
				ON E.FROM_SCM_SITE_ID	= S.SCM_SITE_ID				 
			   AND E.DIVISION_ID	= S.DIVISION_ID				 
			   AND S.SITE_TYPE		= 'PLANT'					 				 
			JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 
				ON E.ITEM_ID		= T.ITEM_ID					 
			   AND E.DIVISION_ID	= T.DIVISION_ID				 
			   AND S.COMPANY_ID		= T.COMPANY_ID				 
			   AND T.ITEM_TYPE		NOT IN ('Q','R')
			WHERE 1=1
			AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
			AND   E.CONFIRM_ID LIKE 'C%'		
			AND   E.DIVISION_ID  = @p_division_id  
			AND   E.COMPANY_ID = @p_company_id
			AND ( ( @p_from_site   IS NULL OR @p_from_site ='')  OR E.FROM_SCM_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
			AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR E.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
			--AND   (E.EXFACTORY_DATE >= @p_plan_start_yyyymmdd  AND E.EXFACTORY_DATE < @v_to_yyyymmdd)
			AND   (E.EXFACTORY_DATE >= @v_from_yyyymmdd  AND E.EXFACTORY_DATE < @p_plan_start_yyyymmdd)
			GROUP BY E.DIVISION_ID 
			,        E.CONFIRM_ID
			,        E.ORDER_NO
			,        E.EXFACTORY_DATE
			,        E.TRANSPORT_MODE
			,        E.INCOTERMS		
			,		 E.ETA_DATE		
			,		 E.ETD_DATE
			,		 E.FROM_SCM_SITE_ID	
			,		 E.TO_SCM_SITE_ID	
			,		 E.ITEM_ID
			UNION ALL
			-- ERP 출하실적에서 CONFIRM_ID 없는 실적 
			SELECT  E.DIVISION_ID             AS DIVISION_ID
			,       '-'                       AS CONFIRM_ID
			,       E.ORDER_NO				  AS ERP_SO_NO 
			,       E.FROM_SCM_SITE_ID        AS FROM_SITE                                                                    
			,       ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID)     AS TO_SITE   
			,       E.ITEM_ID                 AS ITEM_ID
			,       E.EXFACTORY_DATE          AS YYYYMMDD
			,       E.TRANSPORT_MODE		  AS TRANSPORT_MODE
			,       E.INCOTERMS				  AS INCOTERMS
			,		E.ETA_DATE				  AS ETA_DATE
			,		E.ETD_DATE				  AS ETD_DATE
			,       SUM(E.EXFACTORY_QTY )     AS QTY  
			FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
			JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
				ON E.FROM_SCM_SITE_ID	= S.SCM_SITE_ID				 
			   AND E.DIVISION_ID	= S.DIVISION_ID				 
			   AND S.SITE_TYPE		= 'PLANT'
			JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 
				ON E.ITEM_ID		= T.ITEM_ID					 
			   AND E.DIVISION_ID	= T.DIVISION_ID				 
			   AND S.COMPANY_ID		= T.COMPANY_ID				 
			   AND T.ITEM_TYPE		NOT IN ('Q','R')
			JOIN  SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만 
				ON F.ITEM_ID = E.ITEM_ID 
				AND F.DIVISION_ID = E.DIVISION_ID
			JOIN   SCM_MST_SITE FS WITH(NOLOCK)
				ON FS.SCM_SITE_ID = E.FROM_SCM_SITE_ID 
				AND FS.DIVISION_ID = E.DIVISION_ID 
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
				ON L.LOOKUP_TYPE = 'ERP_ORDER_TYPE'
			AND L.VALID_YN = 'Y'
			AND L.SEGMENT1    = E.ORDER_TYPE_CODE 	
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK)
					ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE 
				AND L3.SEGMENT1    = E.DIVISION_ID 
				AND L3.SEGMENT2    = E.SOLDTO_CODE
				AND L3.SEGMENT3    = E.SHIPTO_CODE					    
			WHERE 1=1
			AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
			AND   ISNULL(E.CONFIRM_ID,'') NOT LIKE  'C%'
			AND   (E.EXFACTORY_DATE >= @v_from_yyyymmdd  AND E.EXFACTORY_DATE < @p_plan_start_yyyymmdd)
			AND   E.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외 
			AND   E.STORAGE_ID NOT IN (SELECT SEGMENT1 
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
									WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
										AND VALID_YN = 'Y'
									)	-- 사외 창고 제외 LOOKUP 관리
			AND   E.DIVISION_ID  = @p_division_id  
			AND   E.COMPANY_ID = @p_company_id
			AND ( ( @p_from_site IS NULL OR @p_from_site ='')  OR E.FROM_SCM_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
			AND ( ( @p_item_id   IS NULL OR @p_item_id   ='')  OR E.ITEM_ID          IN (SELECT token FROM dbo.String_Split(@p_item_id  ,',')) )
			GROUP BY E.DIVISION_ID
			,        E.ORDER_NO
			,        E.FROM_SCM_SITE_ID                                                                           
			,        ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID) 
			,        E.ITEM_ID
			,        E.EXFACTORY_DATE
			,        E.TRANSPORT_MODE
			,        E.INCOTERMS		
			,		 E.ETA_DATE		
			,		 E.ETD_DATE
			,		 E.FROM_SCM_SITE_ID	
			,		 E.TO_SCM_SITE_ID
		)
		*/
		SELECT
			T0.DIVISION_ID
			,ISNULL(M.APPLIED_MODEL, T0.ITEM_ID) AS ITEM_ID
			, T0.FROM_SITE
			, CASE WHEN FI.GROUP_CODE1 = '' THEN '-' ELSE ISNULL(FI.GROUP_CODE1,'-') END AS PRODUCT_LEVEL1
			, T0.MEASURE
			, T0.TO_SITE
			, T0.TRANSPORT_MODE
			, T0.INCOTERMS
			, T0.FCST_TYPE
			, T0.SEQ
			, T0.YYYYMMDD
			, SUM(T0.QTY) AS QTY
			/*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
			--, CASE WHEN (T1.SHIP_FROZEN - 1) > 0 THEN (T1.SHIP_FROZEN - 1) ELSE 0 END AS CONFIRM_DAY
			, CASE WHEN [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, T0.DIVISION_ID,T0.FROM_SITE, @p_plan_start_yyyymmdd) - 1 > 0  THEN [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, T0.DIVISION_ID,T0.FROM_SITE, @p_plan_start_yyyymmdd) - 1
			                                                                                                                            ELSE 0
			  END AS CONFIRM_DAY
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
				, 'SHIP_REQ'				AS MEASURE
				, ''					 AS TO_SITE
				, ''                      AS TRANSPORT_MODE
				, ''                      AS INCOTERMS
				, ''                      AS FCST_TYPE
				, T0.yyyymmdd				AS YYYYMMDD
				, CASE WHEN T0.yyyymmdd < @p_plan_start_yyyymmdd THEN (CASE WHEN T0.QTY = 0 THEN NULL ELSE ISNULL(T0.QTY, 0) END)
															      ELSE ISNULL(T0.QTY, 0)
			      END AS QTY
				, 1							AS SEQ
			FROM   DM_PLN_SHIPMENT_REQ T0 WITH(NOLOCK)
			INNER JOIN SCM_MST_SITE T1 WITH(NOLOCK)
				ON T0.DIVISION_ID = @p_division_id		
				AND	T0.PLANT_SITE_ID = T1.SCM_SITE_ID
				AND T1.COMPANY_ID = @p_company_id
				AND T1.site_type = 'PLANT'				
				AND T1.VALID_YN = 'Y'
			WHERE  1=1
			AND T0.division_id = @p_division_id -- 변수
			AND T1.COMPANY_ID = @p_company_id
			AND T0.measure = 'SHIP_REQ' -- 확정 후 수정할 것
			AND T0.yyyymmdd >= @v_from_yyyymmdd	
			AND T0.yyyymmdd <= @v_to_yyyymmdd	
			AND T0.qty > 0
			AND (( @p_from_site IS NULL OR @p_from_site ='') OR T0.plant_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site , ',')))
			AND (( @p_item_id	IS NULL OR @p_item_id ='') OR T0.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id , ',')))
			
			--//SHIPMENT PLAN//===================================================================
			--////////////////////////////////////////////////////////////////////////////////--
			--//2-2. Ship Plan : 출하 계획(Plant향 Ship Req)									//--
			--//	scp_anl_shipment_plan_semi / MEASURE = 'SHIP_PLAN'					//--
			--//	ssp_anl_ship_confirm	   / MEASURE = 'SHIP_PLAN'					//--
			--////////////////////////////////////////////////////////////////////////////////--
			UNION ALL
			SELECT
				T0.division_id				AS DIVISION_ID
				, T0.item_id				AS ITEM_ID
				, T0.from_site				AS FROM_SITE
				, T0.measure				AS MEASURE
				, T0.TO_SITE				AS TO_SITE
				, T0.TRANSPORT_MODE			AS TRANSPORT_MODE
				, T0.INCOTERMS				AS INCOTERMS				
				, T0.FCST_TYPE				AS FCST_TYPE
				, T0.yyyymmdd				AS YYYYMMDD
				, ISNULL(SUM(T0.qty), 0)	AS QTY
				, T0.seq					AS SEQ
			FROM
			(
				--//2) Ship Plan : SSP(Daily) Plant향 Shipment Plan====================================================================================================
				--//===================================================================================================================================================
				SELECT 
					T0.DIVISION_ID
					, T0.ITEM_ID
					, T0.FROM_SITE
					, 'SHIP_PLAN'         AS MEASURE
					, T0.TO_SITE          AS TO_SITE
					, T0.TRANSPORT_MODE   AS TRANSPORT_MODE
					, T0.INCOTERMS        AS INCOTERMS
					, T0.FCST_TYPE        AS FCST_TYPE
					, T0.YYYYMMDD
					, T0.QTY
					, 2                   AS SEQ
				FROM SSP_ANL_SHIP_CONFIRM T0 WITH (NOLOCK)
				WHERE 1 = 1
				AND T0.change_type  = 'C'
				AND T0.BIZ_TYPE  <> 'E'
				AND T0.qty >  0
				AND T0.division_id  = @p_division_id  
				AND T0.FROM_SITE_COMPANY_ID = @p_company_id
				--AND T0.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd 
				AND T0.yyyymmdd >= @p_plan_start_yyyymmdd
				AND T0.yyyymmdd <= @v_to_yyyymmdd
				AND ((@p_from_site IS NULL OR @p_from_site ='' ) OR T0.from_site IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
				AND ((@p_item_id IS NULL OR @p_item_id ='' ) OR T0.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id, ','))) 
				UNION ALL
				--ERP 실적 
				SELECT R.DIVISION_ID     AS DIVISION_ID
				,      R.ITEM_ID         AS ITEM_ID 
				,      R.FROM_SITE       AS FROM_SITE 
				,	  'SHIP_PLAN'        AS MEASURE
				/*, R.TO_SITE          AS TO_SITE
				, R.TRANSPORT_MODE   AS TRANSPORT_MODE
				, R.INCOTERMS        AS INCOTERMS*/
				, ''					AS TO_SITE
				, ''					AS TRANSPORT_MODE
				, ''					AS INCOTERMS
				, ''					AS FCST_TYPE
				,      R.YYYYMMDD        AS YYYYMMDD
				,      R.RESULT_QTY		 AS QTY 
				,	   2                 AS SEQ
				FROM  #Tmp_SHIPMENT_RESULT R 
				UNION ALL
				--확정구간 이후 Ship Req 수량 합
				SELECT
					DIVISION_ID
					, ITEM_ID
					, FROM_SITE
					, MEASURE
					, ''				AS TO_SITE
					, ''				AS TRANSPORT_MODE
					, ''				AS INCOTERMS
					, ''				AS FCST_TYPE
					, YYYYMMDD
					, QTY
					, SEQ
				FROM
				(
					SELECT 
						T0.division_id		  AS DIVISION_ID
						, T0.item_id		  AS ITEM_ID
						, T0.plant_site_id	  AS FROM_SITE
						, 'SHIP_PLAN'		  AS MEASURE
						, T0.yyyymmdd		  AS YYYYMMDD
						, T0.qty			  AS QTY
						, 2					  AS SEQ
						/*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
						--, CASE WHEN isnull(fs.ship_frozen,0) > 0 THEN CONVERT(CHAR(8), DATEADD(DD, isnull(fs.ship_frozen,0), CONVERT(VARCHAR, @p_from_yyyymmdd, 121)), 112) ELSE @p_from_yyyymmdd END AS frozen_yyyymmdd -- Ship Frozen구간 다음일자
						, CASE WHEN isnull(fs.ship_frozen,0) > 0 THEN CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, FS.DIVISION_ID ,FS.SCM_SITE_ID, @p_plan_start_yyyymmdd) , CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)) ,112) 
																 ELSE @p_plan_start_yyyymmdd 
						  END AS frozen_yyyymmdd -- Ship Frozen구간 다음일자
					FROM DM_PLN_SHIPMENT_REQ T0 WITH(NOLOCK)
					INNER JOIN SCM_MST_SITE fs WITH(NOLOCK)	
						ON  fs.division_id		= @p_division_id
						AND T0.plant_site_id    = fs.scm_site_id
						AND fs.COMPANY_ID = @p_company_id
						AND fs.site_type		= 'PLANT'  
						AND fs.valid_yn			= 'Y'
					WHERE  1=1
					AND T0.division_id = @p_division_id -- 변수
					AND fs.COMPANY_ID = @p_company_id
					AND T0.measure = 'SHIP_REQ' -- 확정 후 수정할 것
					AND T0.yyyymmdd >= @v_from_yyyymmdd
					AND T0.yyyymmdd <= @v_to_yyyymmdd	
					AND T0.qty > 0
					AND (( @p_from_site IS NULL OR @p_from_site ='') OR T0.plant_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site , ',')))
					AND (( @p_item_id   IS NULL OR @p_item_id ='') OR T0.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id , ',')))
				) T1
				WHERE 1 = 1
				AND YYYYMMDD >= frozen_yyyymmdd 
			) T0
			GROUP BY T0.DIVISION_ID, T0.ITEM_ID, T0.FROM_SITE
				,	T0.TO_SITE,	T0.TRANSPORT_MODE,	T0.INCOTERMS,	T0.FCST_TYPE
				 ,	T0.MEASURE, T0.YYYYMMDD, T0.SEQ
			--//PROD_PLAN//===================================================================
			--////////////////////////////////////////////////////////////////////////////////--
			--//2-4. PROD_PLAN : 생산 계획													//--
			--//	SCM_DNM_PLAN_FROZEN_V / MEASURE = 'PROD_PLAN'							//--
			--//	Pack : 'P5500', 'P9500' / Cell : 'F5300', 'F5500', 'F5600', 'F6000'		//--
			--////////////////////////////////////////////////////////////////////////////////--
			UNION ALL
			SELECT
				T0.DIVISION_ID
				, T0.ITEM_ID
				, T0.SCM_SITE_ID AS FROM_SITE
				, 'PROD_PLAN' AS MEASURE
				, ''                AS TO_SITE
				, ''                AS TRANSPORT_MODE
				, ''                AS INCOTERMS
				, ''                AS FCST_TYPE
				, CONVERT(NVARCHAR(8), T0.plan_date, 112) AS YYYYMMDDD
				, T0.plan_qty AS QTY
				, 9 AS SEQ
			FROM [dbo].[SSP_DNM_FP_PLAN_FROZEN] T0 WITH(NOLOCK) -- SCM_DNM_PLAN_FROZEN_V T0 WITH(NOLOCK) 
			WHERE 1 = 1
			-- START [E20260811-000692] ESMI AZ 링크 2호기 생산계획 받아오지 못하는 현상 처리
			-- 원본 AND T0.OPERATION_ID IN ('P5500', 'P9500', 'F5300', 'F5500', 'F5600', 'F6000')
			AND T0.OPERATION_ID IN ('P5500', 'P9500', 'F5300', 'F5500', 'F5600', 'F6000', 'PL500')
			-- END [E20260811-000692] ESMI AZ 링크 2호기 생산계획 받아오지 못하는 현상 처리
			AND T0.PLAN_QTY > 0 
			--AND T0.plan_in_qty > 0 
			AND T0.DIVISION_ID = @p_division_id
			AND T0.COMPANY_ID  = @p_company_id
			AND T0.PLAN_DATE   >= @v_from_yyyymmdd
			AND T0.PLAN_DATE   <= @v_to_yyyymmdd
			AND T0.SITE_ID IN 	(SELECT DISTINCT SITE_ID 
									FROM dbo.SCM_MST_SITE WITH(NOLOCK)
									WHERE 1 = 1
									AND DIVISION_ID = @p_division_id
									AND COMPANY_ID = @p_company_id
									AND SITE_TYPE = 'PLANT'
									AND VALID_YN = 'Y'
								)
			AND ((@p_from_site IS NULL OR @p_from_site ='') OR T0.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
			AND ((@p_item_id   IS NULL OR @p_item_id   ='')	OR T0.item_id     IN (SELECT token FROM dbo.String_Split(@p_item_id  , ',')))
			
			UNION ALL		
            -- [C20200121-000352]-3 : Production Plan Measure에 Paker생산계획 추가(SCP_ANL_PRODUCTION_PLAN 의 PROD_PLAN_AMEND measure) 		
			SELECT P.DIVISION_ID 
			,      P.ITEM_ID 
			,      P.SCM_SITE_ID  AS FROM_SITE
			,      'PROD_PLAN'    AS MEASURE  
			, ''                AS TO_SITE
			, ''                AS TRANSPORT_MODE
			, ''                AS INCOTERMS
			, ''                AS FCST_TYPE
			,      P.YYYYMMDD     AS YYYYMMDDD   
			,      P.QTY          AS QTY
			,      9              AS SEQ
			FROM [dbo].[SCP_ANL_PRODUCTION_PLAN] P WITH(NOLOCK) --  SCP_ANL_PRODUCTION_PLAN P WITH(NOLOCK) 
			JOIN (
                    SELECT TOP 1 
					       A.DIVISION_ID 
					,      A.PLAN_START_YYYYMMDD 
					,      A.PLAN_TYPE 
					,      A.PLAN_SEQ   AS SEQ 
					FROM   [dbo].[SCP_PLAN_VERSION_V] A WITH(NOLOCK) --   SCP_PLAN_VERSION_V A WITH(NOLOCK) 
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
			 AND S.OSP_YN = 'Y' AND VALID_YN = 'Y'
			WHERE P.DIVISION_ID = '82' -- ESS(82)만 적용 
			AND   S.COMPANY_ID  = @p_company_id
			AND   P.MEASURE = 'PROD_PLAN_AMEND'
			AND   P.QTY > 0  
			AND   P.YYYYMMDD >= @v_from_yyyymmdd
			AND   P.YYYYMMDD <= @v_to_yyyymmdd
			AND ((@p_from_site IS NULL OR @p_from_site ='') OR P.SCM_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_from_site    ,',')))
			AND ((@p_item_id IS NULL OR @p_item_id ='')	OR P.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')))

			UNION ALL

			SELECT DIVISION_ID
				, ITEM_ID
				, FROM_SITE
				, MEASURE
				, ''                AS TO_SITE
				, ''                AS TRANSPORT_MODE
				, ''                AS INCOTERMS
				, ''                AS FCST_TYPE
				, YYYYMMDD
				, QTY
				, SEQ
			  FROM (
			       SELECT C.DIVISION_ID					AS DIVISION_ID
					    , C.ITEM_ID						AS ITEM_ID
					    , C.SCM_SITE_ID					AS FROM_SITE
					    , 'PROD_PLAN'					AS MEASURE  
					    , [dbo].[FN_GET_SSP_ETA_DATE](C.DIVISION_ID, C.BOD_ID, C.YYYYMMDD)               AS YYYYMMDD
					    , C.QTY							AS QTY
					    , 9							AS SEQ
				     FROM DM_PLN_SHIPMENT_REQ AS C WITH(NOLOCK)
					      JOIN SCM_MST_SITE AS TS WITH(NOLOCK)
				       ON C.DIVISION_ID = TS.DIVISION_ID
				      AND C.SCM_SITE_ID = TS.SCM_SITE_ID
				      AND TS.OPERATION_GROUP = 'W'
				      AND TS.SITE_TYPE = 'PLANT'
				      AND TS.VALID_YN = 'Y'
			        WHERE C.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@p_division_id,',')) 
				      AND TS.COMPANY_ID = @p_company_id 
				      AND C.QTY		> 0
				      AND ((@p_from_site IS NULL OR @p_from_site ='') OR C.SCM_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_from_site    ,',')))
				      AND ((@p_item_id IS NULL OR @p_item_id ='')	OR C.ITEM_ID  IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')))
			       ) AS X
			 WHERE X.YYYYMMDD >= @v_from_yyyymmdd
			   AND X.YYYYMMDD <  @v_to_yyyymmdd
			
			UNION ALL
			SELECT
				 T0.DIVISION_ID
				, T0.MODEL_ID		  AS ITEM_ID
				, T0.FROM_SITE_ID	  AS FROM_SITE
				, 'SHIP_AVAL'		  AS MEASURE
				, ''                AS TO_SITE
				, ''                AS TRANSPORT_MODE
				, ''                AS INCOTERMS
				, ''                AS FCST_TYPE
				, CONVERT(NVARCHAR(8), T0.plan_date, 112) AS YYYYMMDDD
				, T0.out_qty AS QTY
				, 5 AS SEQ
			FROM [dbo].SSP_DNM_FP_AMEND_SHIPAVAL T0 WITH(NOLOCK) 
			WHERE 1 = 1
			AND T0.out_qty >= 0 
			AND T0.DIVISION_ID = @p_division_id
			AND T0.COMPANY_ID  = @p_company_id
			AND T0.plan_date   >= @v_from_yyyymmdd
			AND T0.plan_date   <= @v_to_yyyymmdd
			AND T0.site_id IN 	(SELECT DISTINCT SITE_ID 
									FROM scm_mst_site
									where 1 = 1
									AND division_id = @p_division_id
									AND COMPANY_ID = @p_company_id
									AND site_type = 'PLANT'									
									AND valid_yn = 'Y'
								)
			AND ((@p_from_site IS NULL OR @p_from_site ='') OR T0.FROM_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_from_site    ,',')))
			AND ((@p_item_id IS NULL OR @p_item_id ='')	OR T0.MODEL_ID IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')))
		) T0
		INNER JOIN scm_mst_site T1	WITH(NOLOCK)	
				ON T1.division_id = @p_division_id
				AND T1.COMPANY_ID = @p_company_id
				AND T0.FROM_SITE = T1.scm_site_id
				AND T1.site_type  = 'PLANT'  
				AND T1.valid_yn   = 'Y'
		 JOIN dbo.SCM_MST_ITEM_SN AS M WITH(NOLOCK)
		    ON T1.COMPANY_ID = M.COMPANY_ID
		   AND T0.DIVISION_ID = M.DIVISION_ID
		   AND T1.SITE_ID = M.SITE_ID
		   AND T0.ITEM_ID = M.ITEM_ID
		   AND M.ITEM_TYPE IN ('P', 'H')
		LEFT OUTER JOIN dbo.SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
			ON FI.DIVISION_ID = T0.DIVISION_ID
		   AND FI.ITEM_ID = T0.ITEM_ID
		WHERE 1 = 1
		AND ((@p_product_level1 IS NULL OR @p_product_level1 ='')	OR FI.GROUP_CODE1 IN (SELECT token FROM dbo.String_Split(@p_product_level1, ',')))
		-- jilee 230901
		GROUP BY T0.DIVISION_ID, T0.FROM_SITE, FI.GROUP_CODE1, M.APPLIED_MODEL, T0.ITEM_ID
				, T0.TO_SITE, T0.TRANSPORT_MODE, T0.INCOTERMS, T0.FCST_TYPE
				, T0.YYYYMMDD, T0.MEASURE, T0.SEQ, T1.SHIP_FROZEN
		;
		
		UPDATE #Tmp_RowData SET PRODUCT_LEVEL1 = '-' WHERE (PRODUCT_LEVEL1 IS NULL OR PRODUCT_LEVEL1 = '')

		--//END DATA ROW DATE : 16s//////////////////////////////////////8/////////////////////////////////////////////////////////////////////////////////--

		--////////////////////////////////////////////////////////////////////////////////--
		--//3. 해당 ITEM별 MEASURE 및 날짜 생성											//--
		--////////////////////////////////////////////////////////////////////////////////--
		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID
			,		FROM_SITE
			,		ITEM_ID
			,		PRODUCT_LEVEL1
			,		MEASURE
			,		TO_SITE
			,		TRANSPORT_MODE
			,		INCOTERMS
			,		FCST_TYPE
			,		SEQ
			,		CONFIRM_DAY
			,		YYYYMMDD
			,		QTY
			,		EDIT_YN
		)
		SELECT
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.ITEM_ID
			, T0.PRODUCT_LEVEL1
			, T0.MEASURE
			, T0.TO_SITE
			, T0.TRANSPORT_MODE
			, T0.INCOTERMS
			, T0.FCST_TYPE
			, T0.SEQ
			, T0.CONFIRM_DAY
			, T0.YYYYMMDD
			, ISNULL(T1.QTY, 0) AS QTY
			, NULL AS EDIT_YN
		FROM 
		(
			SELECT DISTINCT
				tt0.DIVISION_ID
				, tt0.FROM_SITE
				, tt0.ITEM_ID
				, tt0.PRODUCT_LEVEL1
				, '' AS TO_SITE
				, '' AS TRANSPORT_MODE
				, '' AS INCOTERMS
				, '' AS FCST_TYPE
				, tt0.CONFIRM_DAY
				, tt1.COLUMN_NAME AS MEASURE
				, tt1.SORT_ORDER_NO AS SEQ
				, tt2.YYYYMMDD
			FROM #Tmp_RowData tt0 WITH(NOLOCK)
			LEFT JOIN SCM_MST_SHEET_MEASURE tt1 WITH(NOLOCK)
				ON tt1.PROGRAM_ID = @p_program_id
				AND tt1.SHEET_NAME = @p_sheet_name
			LEFT OUTER JOIN 
			(
				SELECT
					BASIS_YYYYMMDD AS YYYYMMDD,
					ISO_WEEK
				FROM scm_sys_calendar_m WITH(NOLOCK)
				WHERE BASIS_YYYYMMDD >= @v_from_yyyymmdd	AND BASIS_YYYYMMDD <= @v_to_yyyymmdd
			) tt2
				ON  tt2.YYYYMMDD >= @v_from_yyyymmdd	AND tt2.YYYYMMDD <= @v_to_yyyymmdd
			--GROUP BY tt0.DIVISION_ID, tt0.FROM_SITE, tt0.ITEM_ID, tt1.COLUMN_NAME, tt1.COLUMN_LABEL_NAME, tt1.SORT_ORDER_NO, tt2.YYYYMMDD,tt0.CONFIRM_DAY
		) T0
		LEFT OUTER JOIN #Tmp_RowData T1 WITH(NOLOCK)
			ON T0.DIVISION_ID = T1.DIVISION_ID		
			AND T0.FROM_SITE = T1.FROM_SITE
			AND T0.ITEM_ID = T1.ITEM_ID				
			AND T0.MEASURE = T1.MEASURE
			AND T0.YYYYMMDD = T1.YYYYMMDD
			/*
		LEFT OUTER JOIN #Tmp_BOHData T2
			ON T0.DIVISION_ID = T2.DIVISION_ID		
			AND T0.FROM_SITE = T2.FROM_SITE
			AND T0.ITEM_ID = T2.ITEM_ID				
			AND T0.SEQ = T2.SEQ
			*/
		WHERE 1 = 1
		AND T0.MEASURE IN ('SHIP_REQ', 'SHIP_PLAN', 'PROD_PLAN','SHIP_AVAL') -- jilee
		ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.PRODUCT_LEVEL1, T0.ITEM_ID
			, T0.TO_SITE, T0.TRANSPORT_MODE, T0.INCOTERMS, T0.FCST_TYPE
			, T0.YYYYMMDD, T0.SEQ
		;

		--SELECT * FROM #Tmp_RowData ORDER BY FROM_SITE, ITEM_ID, SEQ, YYYYMMDD;
		--SELECT * FROM #Tmp_Result_Table ORDER BY FROM_SITE, ITEM_ID, SEQ, YYYYMMDD;
		--//END 해당 ITEM별 MEASURE 및 날짜 생성///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

		--////////////////////////////////////////////////////////////////////////////////--
		--//2-3. Shipment PLAN Detail DATA INSERT(-> #Tmp_Result_Detail_Table)
		--////////////////////////////////////////////////////////////////////////////////--
		INSERT INTO #Tmp_Result_Detail_Table
		(
			DIVISION_ID,	FROM_SITE,		PRODUCT_LEVEL1,	ITEM_ID,	MEASURE	
		,	TO_SITE	,		TRANSPORT_MODE,	INCOTERMS,		FCST_TYPE
		,	SEQ,			CONFIRM_DAY,	YYYYMMDD,		QTY		,	LOT_YN
		,	EDIT_YN
		)
		SELECT M.DIVISION_ID
			, M.FROM_SITE
			, CASE WHEN FI.GROUP_CODE1 = '' THEN '-' ELSE ISNULL(FI.GROUP_CODE1,'-') END AS PRODUCT_LEVEL1
			, M.ITEM_ID
			, M.MEASURE
			, M.TO_SITE
			, M.TRANSPORT_MODE
			, M.INCOTERMS
			, M.FCST_TYPE
			, M.SEQ
			, CASE WHEN [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, M.DIVISION_ID,M.FROM_SITE, @p_plan_start_yyyymmdd) - 1 > 0  THEN [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, M.DIVISION_ID,M.FROM_SITE, @p_plan_start_yyyymmdd) - 1
																																		 ELSE 0
			  END AS CONFIRM_DAY
			, M.YYYYMMDD
			, SUM(M.QTY) AS QTY
			, MAX(M.LOT_SIZE) AS LOT_YN
			, CASE WHEN SUM(M.EDIT_CNT) > 0 AND SUM(M.EDIT_CNT) = SUM(M.TOT_CNT) THEN 'Y'
				   --WHEN M.EDIT_CNT > 0 AND M.EDIT_CNT != M.TOT_CNT THEN CAST(NOEDIT_QTY AS VARCHAR)
				   WHEN SUM(M.NOEDIT_QTY) > 0 THEN CAST(SUM(NOEDIT_QTY) AS VARCHAR)
				   ELSE 'N'
			  END AS EDIT_YN
		FROM (
				SELECT T0.DIVISION_ID
					, T0.FROM_SITE
					, T0.ITEM_ID
					, 'SHIP_PLAN_DETAIL' AS MEASURE
					, T0.TO_SITE
					, T0.TRANSPORT_MODE
					, T0.INCOTERMS
					, T0.FCST_TYPE
					, 3 AS SEQ
					, T0.YYYYMMDD
					, SUM(CASE WHEN ISNULL(T0.SHIPMENT_STATUS, '') = 'C' AND ISNULL(T0.ERP_STATUS, '') != 'C' THEN 1 ELSE 0 END) AS EDIT_CNT
					, COUNT(*) AS TOT_CNT
					, SUM(T0.QTY) AS QTY
					, SUM(CASE WHEN ISNULL(T0.SHIPMENT_STATUS, '') != 'C' OR ISNULL(T0.ERP_STATUS, '') = 'C' THEN T0.QTY ELSE 0 END) AS NOEDIT_QTY
					, MAX(B.LOT_SIZE) AS LOT_SIZE
				FROM SSP_ANL_SHIP_CONFIRM T0 WITH (NOLOCK)
				LEFT OUTER JOIN SCM_MST_SITE fs WITH(NOLOCK)	
				ON  fs.division_id		= @p_division_id
				AND T0.FROM_SITE    = fs.scm_site_id
				AND fs.COMPANY_ID = @p_company_id
				AND fs.site_type		= 'PLANT'  
				AND fs.valid_yn			= 'Y'
				LEFT OUTER JOIN dbo.SCP_MST_SHIPMENT_LOT_SIZE B WITH(NOLOCK)
				ON B.DIVISION_ID	= @p_division_id
				AND B.ITEM_ID		= T0.ITEM_ID
				AND B.FROM_SITE		= T0.FROM_SITE
				AND B.TO_SITE		= T0.TO_SITE
				AND B.TRANSPORT_MODE = T0.TRANSPORT_MODE
				AND B.VALID_YN		= 'Y'
				AND B.SPLIT_YN = 'Y'
				WHERE 1 = 1
				AND T0.change_type  = 'C'
				AND T0.BIZ_TYPE  <> 'E'
				AND T0.qty >  0
				AND T0.division_id  = @p_division_id  
				AND T0.FROM_SITE_COMPANY_ID = @p_company_id
				--AND T0.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd 
				AND T0.yyyymmdd >= @p_plan_start_yyyymmdd
				AND T0.yyyymmdd <= @v_to_yyyymmdd
				AND ((@p_from_site IS NULL OR @p_from_site ='' ) OR T0.from_site IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
				AND ((@p_item_id   IS NULL OR @p_item_id   ='' ) OR T0.item_id   IN (SELECT token FROM dbo.String_Split(@p_item_id  , ','))) 
				GROUP BY T0.DIVISION_ID
					, T0.FROM_SITE
					, T0.ITEM_ID
					, T0.TO_SITE
					, T0.TRANSPORT_MODE
					, T0.INCOTERMS
					, T0.FCST_TYPE
					, T0.YYYYMMDD
				UNION ALL
				-- 과거구간 조회
				SELECT T0.DIVISION_ID
					, T0.FROM_SITE
					, T0.ITEM_ID
					, 'SHIP_PLAN_DETAIL' AS MEASURE
					, T0.TO_SITE
					, T0.TRANSPORT_MODE
					, T0.INCOTERMS
					, T0.FCST_TYPE
					, 3 AS SEQ
					, T0.YYYYMMDD
					, 0 AS EDIT_CNT
					, COUNT(*) AS TOT_CNT
					, SUM(T0.QTY) AS QTY
					, 0 AS NOEDIT_QTY
					, MAX(B.LOT_SIZE) AS LOT_SIZE
				FROM SSP_ANL_SHIP_PLAN_C T0 WITH (NOLOCK)
				LEFT OUTER JOIN SCM_MST_SITE fs WITH(NOLOCK)	
				ON  fs.division_id		= @p_division_id
				AND T0.FROM_SITE    = fs.scm_site_id
				AND fs.COMPANY_ID = @p_company_id
				AND fs.site_type		= 'PLANT'  
				AND fs.valid_yn			= 'Y'
				LEFT OUTER JOIN dbo.SCP_MST_SHIPMENT_LOT_SIZE B WITH(NOLOCK)
				ON B.DIVISION_ID	= @p_division_id
				AND B.ITEM_ID		= T0.ITEM_ID
				AND B.FROM_SITE		= T0.FROM_SITE
				AND B.TO_SITE		= T0.TO_SITE
				AND B.TRANSPORT_MODE = T0.TRANSPORT_MODE
				AND B.VALID_YN		= 'Y'
				AND B.SPLIT_YN = 'Y'
				WHERE 1 = 1
				AND T0.BIZ_TYPE  <> 'E'
				AND T0.QTY >  0
				AND T0.DIVISION_ID  = @p_division_id  
				AND T0.COMPANY_ID = @p_company_id
				AND T0.MEASURE = 'SHIP_PLAN'
				AND T0.PLAN_START_YYYYMMDD = T0.YYYYMMDD
				AND T0.YYYYMMDD >= @v_from_yyyymmdd
				AND T0.YYYYMMDD < @p_plan_start_yyyymmdd
				AND ((@p_from_site IS NULL OR @p_from_site ='' ) OR T0.from_site IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
				AND ((@p_item_id   IS NULL OR @p_item_id   ='' ) OR T0.item_id   IN (SELECT token FROM dbo.String_Split(@p_item_id  , ','))) 
				GROUP BY T0.DIVISION_ID
					, T0.FROM_SITE
					, T0.ITEM_ID
					, T0.TO_SITE
					, T0.TRANSPORT_MODE
					, T0.INCOTERMS
					, T0.FCST_TYPE
					, T0.YYYYMMDD
					/*
				UNION ALL
				SELECT
					T1.DIVISION_ID
						, T1.FROM_SITE
						, T1.ITEM_ID
						, 'SHIP_PLAN_DETAIL' AS MEASURE
						, NULL AS TO_SITE
						, T1.TRANSPORT_MODE
						, T1.INCOTERMS
						, T1.FCST_TYPE
						, 3 AS SEQ
						, T1.YYYYMMDD
						, 0 AS EDIT_CNT
						, COUNT(*) AS TOT_CNT
						, SUM(T1.QTY) AS QTY
						, 0 AS NOEDIT_QTY
				FROM
				(
					SELECT 
						T0.DIVISION_ID		  AS DIVISION_ID
						, T0.ITEM_ID		  AS ITEM_ID
						, T0.PLANT_SITE_ID	  AS FROM_SITE
						, T0.TRANSPORT_MODE
						, T0.INCOTERMS
						, T0.FCST_TYPE
						, T0.YYYYMMDD
						, T0.QTY
						/*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
						--, CASE WHEN isnull(fs.ship_frozen,0) > 0 THEN CONVERT(CHAR(8), DATEADD(DD, isnull(fs.ship_frozen,0), CONVERT(VARCHAR, @p_from_yyyymmdd, 121)), 112) ELSE @p_from_yyyymmdd END AS frozen_yyyymmdd -- Ship Frozen구간 다음일자
						, CASE WHEN isnull(fs.ship_frozen,0) > 0 THEN CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, FS.DIVISION_ID ,FS.SCM_SITE_ID, @p_plan_start_yyyymmdd) , CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)) ,112) 
																 ELSE @p_plan_start_yyyymmdd 
						  END AS frozen_yyyymmdd -- Ship Frozen구간 다음일자
					FROM dbo.DM_PLN_SHIPMENT_REQ T0 WITH(NOLOCK)
					INNER JOIN SCM_MST_SITE fs WITH(NOLOCK)	
						ON  fs.division_id		= @p_division_id
						AND T0.PLANT_SITE_ID    = fs.scm_site_id
						AND fs.COMPANY_ID		= @p_company_id
						AND fs.SITE_TYPE		= 'PLANT'  
						AND fs.VALID_YN			= 'Y'
					WHERE  1=1
					AND T0.division_id = @p_division_id -- 변수
					AND fs.COMPANY_ID = @p_company_id
					AND T0.MEASURE = 'SHIP_REQ' -- 확정 후 수정할 것
					AND T0.YYYYMMDD >= @v_from_yyyymmdd
					AND T0.YYYYMMDD <= @v_to_yyyymmdd	
					AND T0.qty > 0
					AND (( @p_from_site IS NULL OR @p_from_site ='') OR T0.plant_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site , ',')))
					AND (( @p_item_id   IS NULL OR @p_item_id ='') OR T0.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id , ',')))
					
				) T1
				WHERE 1 = 1
				AND YYYYMMDD >= frozen_yyyymmdd 
				GROUP BY T1.DIVISION_ID
					, T1.FROM_SITE
					, T1.ITEM_ID
					, T1.TRANSPORT_MODE
					, T1.INCOTERMS
					, T1.FCST_TYPE
					, T1.YYYYMMDD
					*/
				UNION ALL
				SELECT T0.DIVISION_ID
					, T0.FROM_SITE
					, T0.ITEM_ID
					, 'SHIP_RESULT' AS MEASURE
					, T0.TO_SITE
					, T0.TRANSPORT_MODE
					, T0.INCOTERMS
					, NULL AS FCST_TYPE
					, 4 AS SEQ
					, T0.YYYYMMDD
					, 0 AS EDIT_CNT
					, COUNT(*) AS TOT_CNT
					, SUM(T0.RESULT_QTY) AS QTY
					, 0 AS NOEDIT_QTY
					, 0 AS LOT_SIZE
				FROM #Tmp_SHIPMENT_RESULT AS T0
				GROUP BY T0.DIVISION_ID
					, T0.FROM_SITE
					, T0.ITEM_ID
					, T0.TO_SITE
					, T0.TRANSPORT_MODE
					, T0.INCOTERMS
					, T0.YYYYMMDD
			) M
			LEFT OUTER JOIN dbo.SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
			ON FI.DIVISION_ID = M.DIVISION_ID
			AND FI.ITEM_ID = M.ITEM_ID
		WHERE 1=1
		AND ((@p_product_level1 IS NULL OR @p_product_level1 ='')	OR FI.GROUP_CODE1 IN (SELECT token FROM dbo.String_Split(@p_product_level1, ',')))
		GROUP BY M.DIVISION_ID
			, M.FROM_SITE
			, FI.GROUP_CODE1
			, M.ITEM_ID
			, M.MEASURE
			, M.TO_SITE
			, M.TRANSPORT_MODE
			, M.INCOTERMS
			, M.FCST_TYPE
			, M.SEQ
			, M.YYYYMMDD
		;
		--SELECT * FROM #Tmp_Result_Detail_Table;
		--//INTN_MOVEMENT//===================================================================
		--////////////////////////////////////////////////////////////////////////////////--
		--//2-4. INTN_MOVEMENT								//--
		--////////////////////////////////////////////////////////////////////////////////--
		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID,	FROM_SITE,		PRODUCT_LEVEL1,	ITEM_ID,	MEASURE	
		,	TO_SITE	,		TRANSPORT_MODE,	INCOTERMS,		FCST_TYPE
		,	SEQ,			CONFIRM_DAY,	YYYYMMDD,		QTY,		LOT_YN
		,   EDIT_YN
		)
		SELECT
			T0.DIVISION_ID,		T0.FROM_SITE,		T0.PRODUCT_LEVEL1,	T0.ITEM_ID ,	T0.MEASURE	
		,	T0.TO_SITE	,		T0.TRANSPORT_MODE,	T0.INCOTERMS,		T0.FCST_TYPE
		,	T0.SEQ,				T0.CONFIRM_DAY,		T0.YYYYMMDD,		T0.QTY,		    T0.LOT_YN
		,	T0.EDIT_YN
		FROM
		(
			SELECT 
				T0.DIVISION_ID
				, T0.FROM_SITE
				, T0.PRODUCT_LEVEL1
				, T0.ITEM_ID
				, 'INTN_MOVEMENT' AS MEASURE
				, T0.TO_SITE
				, T0.TRANSPORT_MODE
				, T0.INCOTERMS
				, T0.FCST_TYPE
				, 7 AS SEQ
				, T0.CONFIRM_DAY
				, T0.YYYYMMDD
				, sum(isnull(T1.QTY, 0)) as QTY
				, NULL AS LOT_YN
				, NULL AS EDIT_YN
			FROM #Tmp_Result_Table T0 WITH(NOLOCK)
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
					-- AND fs.osp_yn          = 'N'  -- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외)
					AND fs.valid_yn        = 'Y'
				WHERE  1=1
				AND    p.division_id      = @p_division_id
				AND	   p.COMPANY_ID       = @p_company_id
				AND    p.category         = 'MOVING'
				AND    p.plan_date       >= @p_from_yyyymmdd
				AND    p.plan_date       <= @p_to_yyyymmdd
				AND ( ( @p_from_site IS NULL OR @p_from_site ='' ) OR fs.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
				AND ( ( @p_item_id   IS NULL OR @p_item_id   ='' ) OR p.item_id      IN (SELECT token FROM dbo.String_Split(@p_item_id  ,',')) )
				AND    p.qty  >  0
			) T1
				ON T0.DIVISION_ID = T1.DIVISION_ID		AND T0.FROM_SITE = T1.FROM_SITE 
				AND T0.ITEM_ID = T1.ITEM_ID				AND T0.YYYYMMDD = T1.yyyymmdd
				AND T0.MEASURE = 'SHIP_PLAN'
			GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.PRODUCT_LEVEL1, T0.ITEM_ID
				, T0.TO_SITE, T0.TRANSPORT_MODE, T0.INCOTERMS, T0.FCST_TYPE
				, T0.YYYYMMDD, T0.MEASURE, T0.SEQ, T0.CONFIRM_DAY
			--//CONTAINER
			UNION ALL
			SELECT
				A.DIVISION_ID		
				, A.FROM_SITE		
				, A.PRODUCT_LEVEL1
				, A.ITEM_ID
				, 'CONTAINER' AS MEASURE
				, '' AS TO_SITE
				, '' AS TRANSPORT_MODE
				, '' AS INCOTERMS
				, '' AS FCST_TYPE
				, 8 AS SEQ
				, A.CONFIRM_DAY
				, A.YYYYMMDD
				, CASE WHEN ISNULL(MAX(B.LOT_SIZE), 0) = 0 THEN 0 ELSE CEILING(MAX(ISNULL(A.QTY, 0)) /ISNULL(MAX(B.LOT_SIZE), 0)) END AS QTY				
				--, CEILING(SUM(CASE WHEN ISNULL(B.LOT_SIZE, 0) = 0 THEN 0 ELSE A.QTY / B.LOT_SIZE END)) AS QTY
				--, CASE WHEN B.LOT_SIZE IS NULL THEN 'N' ELSE CAST(MAX(B.LOT_SIZE) AS NVARCHAR) END AS LOT_YN
				--, CASE WHEN MAX(B.LOT_SIZE) IS NULL THEN 'N' ELSE 'Y' END AS LOT_YN
				, NULL AS LOT_YN
				, NULL AS EDIT_YN
			FROM #Tmp_Result_Detail_Table A WITH(NOLOCK)
			LEFT OUTER JOIN dbo.SCP_MST_SHIPMENT_LOT_SIZE B WITH(NOLOCK)
				ON B.DIVISION_ID	= @p_division_id
				AND B.ITEM_ID		= A.ITEM_ID
				AND B.FROM_SITE		= A.FROM_SITE
				--AND B.TO_SITE		= A.TO_SITE
				--AND B.TRANSPORT_MODE = A.TRANSPORT_MODE
				AND B.VALID_YN		= 'Y'
				AND B.SPLIT_YN = 'Y'
			WHERE 1 = 1
			AND A.MEASURE = 'SHIP_PLAN_DETAIL'
			GROUP BY A.DIVISION_ID, A.FROM_SITE, A.PRODUCT_LEVEL1, A.ITEM_ID
				--, A.TO_SITE, A.TRANSPORT_MODE, A.INCOTERMS, A.FCST_TYPE
				, A.YYYYMMDD, A.CONFIRM_DAY
		) T0
		;

		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID
			,		FROM_SITE
			,		ITEM_ID
			,		PRODUCT_LEVEL1
			,		MEASURE
			,		TO_SITE
			,		TRANSPORT_MODE
			,		INCOTERMS
			,		FCST_TYPE
			,		SEQ
			,		CONFIRM_DAY
			,		YYYYMMDD
			,		QTY
			,       LOT_YN
			,		EDIT_YN
		)
		SELECT
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.ITEM_ID
			, T0.PRODUCT_LEVEL1
			, T0.MEASURE
			, T0.TO_SITE
			, T0.TRANSPORT_MODE
			, T0.INCOTERMS
			, T0.FCST_TYPE
			, T0.SEQ
			, T0.CONFIRM_DAY
			, T0.YYYYMMDD
			, ISNULL(T1.QTY, 0) AS QTY
			, NULL AS LOT_YN
			, NULL AS EDIT_YN
		FROM 
		(
			SELECT DISTINCT
				tt0.DIVISION_ID
				, tt0.FROM_SITE
				, tt0.ITEM_ID
				, tt0.PRODUCT_LEVEL1
				, '' AS TO_SITE
				, '' AS TRANSPORT_MODE
				, '' AS INCOTERMS
				, '' AS FCST_TYPE
				, tt0.CONFIRM_DAY
				, tt1.COLUMN_NAME AS MEASURE
				, tt1.SORT_ORDER_NO AS SEQ
				, tt2.YYYYMMDD
			FROM #Tmp_RowData tt0 WITH(NOLOCK)
			LEFT JOIN SCM_MST_SHEET_MEASURE tt1 WITH(NOLOCK)
				ON tt1.PROGRAM_ID = @p_program_id
				AND tt1.SHEET_NAME = @p_sheet_name
			LEFT OUTER JOIN 
			(
				SELECT
					BASIS_YYYYMMDD AS YYYYMMDD,
					ISO_WEEK
				FROM scm_sys_calendar_m WITH(NOLOCK)
				WHERE BASIS_YYYYMMDD >= @v_from_yyyymmdd	AND BASIS_YYYYMMDD <= @v_to_yyyymmdd
			) tt2
				ON  tt2.YYYYMMDD >= @v_from_yyyymmdd	AND tt2.YYYYMMDD <= @v_to_yyyymmdd
			--GROUP BY tt0.DIVISION_ID, tt0.FROM_SITE, tt0.ITEM_ID, tt1.COLUMN_NAME, tt1.COLUMN_LABEL_NAME, tt1.SORT_ORDER_NO, tt2.YYYYMMDD,tt0.CONFIRM_DAY
		) T0
		LEFT OUTER JOIN #Tmp_RowData T1 WITH(NOLOCK)
			ON T0.DIVISION_ID = T1.DIVISION_ID		
			AND T0.FROM_SITE = T1.FROM_SITE
			AND T0.ITEM_ID = T1.ITEM_ID				
			AND T0.MEASURE = T1.MEASURE
			AND T0.YYYYMMDD = T1.YYYYMMDD
			/*
		LEFT OUTER JOIN #Tmp_BOHData T2
			ON T0.DIVISION_ID = T2.DIVISION_ID		
			AND T0.FROM_SITE = T2.FROM_SITE
			AND T0.ITEM_ID = T2.ITEM_ID				
			AND T0.SEQ = T2.SEQ
			*/
		LEFT OUTER JOIN	#Tmp_Result_Table TD WITH(NOLOCK)
		    ON T0.DIVISION_ID = TD.DIVISION_ID		
			AND T0.FROM_SITE = TD.FROM_SITE
			AND T0.ITEM_ID = TD.ITEM_ID				
			AND T0.MEASURE = TD.MEASURE
			AND T0.YYYYMMDD = TD.YYYYMMDD
		WHERE 1 = 1
		AND T0.MEASURE IN ('CONTAINER')
		AND ISNULL(TD.QTY,0) = 0 
		ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.PRODUCT_LEVEL1, T0.ITEM_ID
			, T0.TO_SITE, T0.TRANSPORT_MODE, T0.INCOTERMS, T0.FCST_TYPE
			, T0.YYYYMMDD, T0.SEQ
			;
		--SELECT * FROM #Tmp_Result_Table with(nolock) where ITEM_ID = 'ACEH1131I-B1-100' and measure = 'CONTAINER' order by yyyymmdd;
		--return;
		/*
		SELECT
				A.DIVISION_ID		
				, A.FROM_SITE		
				, A.PRODUCT_LEVEL1
				, A.ITEM_ID
				, 'CONTAINER' AS MEASURE
				, '' AS TO_SITE
				, '' AS TRANSPORT_MODE
				, '' AS INCOTERMS
				, '' AS FCST_TYPE
				, 8 AS SEQ
				, A.CONFIRM_DAY
				, A.YYYYMMDD
				--, CASE WHEN ISNULL(MAX(B.LOT_SIZE), 0) = 0 THEN 0 ELSE CEILING(MAX(ISNULL(A.QTY, 0)) /ISNULL(MAX(B.LOT_SIZE), 0)) END AS QTY				
				, CEILING(SUM(CASE WHEN ISNULL(B.LOT_SIZE, 0) = 0 THEN 0 ELSE A.QTY / B.LOT_SIZE END)) AS QTY
				--, CASE WHEN B.LOT_SIZE IS NULL THEN 'N' ELSE CAST(MAX(B.LOT_SIZE) AS NVARCHAR) END AS LOT_YN
				, CASE WHEN MAX(B.LOT_SIZE) IS NULL THEN 'N' ELSE 'Y' END AS LOT_YN
				, NULL AS EDIT_YN
			FROM #Tmp_Result_Detail_Table A WITH(NOLOCK)
			LEFT OUTER JOIN dbo.SCP_MST_SHIPMENT_LOT_SIZE B WITH(NOLOCK)
				ON B.DIVISION_ID	= @p_division_id
				AND B.ITEM_ID		= A.ITEM_ID
				AND B.FROM_SITE		= A.FROM_SITE
				AND B.TO_SITE		= A.TO_SITE
				AND B.TRANSPORT_MODE = A.TRANSPORT_MODE
				AND B.VALID_YN		= 'Y'
				AND B.SPLIT_YN = 'Y'
			WHERE 1 = 1
			AND A.MEASURE = 'SHIP_PLAN_DETAIL'
			GROUP BY A.DIVISION_ID, A.FROM_SITE, A.PRODUCT_LEVEL1, A.ITEM_ID
				--, A.TO_SITE, A.TRANSPORT_MODE, A.INCOTERMS, A.FCST_TYPE
				, A.YYYYMMDD, A.CONFIRM_DAY
				;
				*/
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
				, PRODUCT_LEVEL1
				, ITEM_ID
				, YYYYMMDD
				, CONFIRM_DAY
			FROM #Tmp_Result_Table WITH(NOLOCK)
			GROUP BY DIVISION_ID, FROM_SITE, PRODUCT_LEVEL1, ITEM_ID, YYYYMMDD, CONFIRM_DAY
		)

		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID,	FROM_SITE,		PRODUCT_LEVEL1,	ITEM_ID,	MEASURE	
		,	TO_SITE	,		TRANSPORT_MODE,	INCOTERMS,		FCST_TYPE
		,	SEQ,			CONFIRM_DAY,	YYYYMMDD,		QTY		,	EDIT_YN
		)
		SELECT 
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.PRODUCT_LEVEL1
			, T0.ITEM_ID 
			, 'WH_STOCK' AS MEASURE
			, '' AS TO_SITE
			, '' AS TRANSPORT_MODE
			, '' AS INCOTERMS
			, '' AS FCST_TYPE
			, 10 AS SEQ
			, T0.CONFIRM_DAY
			, T0.YYYYMMDD
			, (
					SELECT
						ISNULL( 
							SUM( 
								CASE	
									WHEN tt0.MEASURE = 'SHIP_PLAN'	   THEN -1 * ISNULL(tt0.QTY, 0)
									WHEN tt0.MEASURE = 'INTN_MOVEMENT' THEN -1 * ISNULL(tt0.QTY, 0)
									WHEN tt0.MEASURE = 'PROD_PLAN'	   THEN ISNULL(tt0.QTY, 0)
								ELSE 0.0
								END), 
							0)
					FROM #Tmp_Result_Table tt0 WITH(NOLOCK)
					WHERE 1 = 1
					AND tt0.DIVISION_ID = T0.DIVISION_ID
					AND tt0.FROM_SITE	= T0.FROM_SITE
					AND tt0.ITEM_ID		= T0.ITEM_ID
					AND tt0.MEASURE		IN ('SHIP_PLAN', 'PROD_PLAN', 'INTN_MOVEMENT')
					AND tt0.YYYYMMDD	>= @p_plan_start_yyyymmdd
					AND tt0.YYYYMMDD	< T0.YYYYMMDD
				) + ISNULL(T1.BOH_QTY, 0) AS QTY
			, NULL AS EDIT_YN
		FROM Deduplication T0 WITH(NOLOCK)
		LEFT OUTER JOIN WH_STOCK T1 WITH(NOLOCK)
			ON T0.DIVISION_ID = T1.DIVISION_ID	AND T0.FROM_SITE = T1.FROM_SITE
			AND T0.ITEM_ID = T1.ITEM_ID			--AND T0.YYYYMMDD = T1.YYYYMMDD 
		WHERE 1 = 1
		ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD
		;

		--//4-2. BALANCE DATA INSERT
		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID,	FROM_SITE,		PRODUCT_LEVEL1,	ITEM_ID,	MEASURE	
		,	TO_SITE	,		TRANSPORT_MODE,	INCOTERMS,		FCST_TYPE
		,	SEQ,			CONFIRM_DAY,	YYYYMMDD,		QTY		,	EDIT_YN
		)
		SELECT
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.PRODUCT_LEVEL1
			, T0.ITEM_ID
			, 'BALANCE' AS MEASURE
			, T0.TO_SITE	
			, T0.TRANSPORT_MODE
			, T0.INCOTERMS
			, T0.FCST_TYPE
			, 11 AS SEQ
			, T0.CONFIRM_DAY
			, T0.YYYYMMDD
			/*
			, -- 당일 Balance = (Balace) + (당일 Production) - (당일 Internal moverment) - (당일 Shipment Plan)
			  (
					SELECT ISNULL(SUM(A.QTY), 0) AS QTY
					FROM (
							SELECT SUM(tt0.QTY) AS QTY
							FROM #Tmp_Result_Table tt0 WITH(NOLOCK)
							WHERE 1 = 1
							AND tt0.DIVISION_ID = T0.DIVISION_ID
							AND tt0.FROM_SITE	= T0.FROM_SITE
							AND tt0.ITEM_ID		= T0.ITEM_ID
							AND tt0.MEASURE		IN ('BALANCE')
							AND tt0.YYYYMMDD	= CONVERT(VARCHAR, CAST(T0.YYYYMMDD AS DATETIME) - 1, 112)
							AND CONVERT(VARCHAR, CAST(T0.YYYYMMDD AS DATETIME) - 1, 112) >= @v_from_yyyymmdd --전날이 시작일 보다 큰 경우
							UNION ALL
							SELECT SUM(tt0.BOH_QTY) AS QTY
							FROM #Tmp_BOHData AS tt0
							WHERE 1 = 1
							AND tt0.DIVISION_ID = T0.DIVISION_ID
							AND tt0.FROM_SITE	= T0.FROM_SITE
							AND tt0.ITEM_ID		= T0.ITEM_ID
							AND tt0.BOH_TYPE    = 'BOH'
							AND CONVERT(VARCHAR, CAST(T0.YYYYMMDD AS DATETIME) - 1, 112) < @v_from_yyyymmdd --전날이 시작일 보다 작은 경우
						) A

				) +
				(
					SELECT
						ISNULL( 
							SUM( 
								CASE	
									WHEN tt0.MEASURE = 'SHIP_PLAN'	   THEN -1 * ISNULL(tt0.QTY, 0)
									WHEN tt0.MEASURE = 'INTN_MOVEMENT' THEN -1 * ISNULL(tt0.QTY, 0)
									WHEN tt0.MEASURE = 'PROD_PLAN'	   THEN ISNULL(tt0.QTY, 0)
								ELSE 0.0
								END), 
							0)
					FROM #Tmp_Result_Table tt0 WITH(NOLOCK)
					WHERE 1 = 1
					AND tt0.DIVISION_ID = T0.DIVISION_ID
					AND tt0.FROM_SITE	= T0.FROM_SITE
					AND tt0.ITEM_ID		= T0.ITEM_ID
					AND tt0.MEASURE		IN ('SHIP_PLAN', 'PROD_PLAN', 'INTN_MOVEMENT')
					AND tt0.YYYYMMDD	= T0.YYYYMMDD
				)
				*/
				-- 당일 Balance = (당일 Warehouse Stock) - (당일 Shipment Plan)
			, ISNULL(
				SUM(
					CASE	WHEN MEASURE = 'SHIP_PLAN' THEN -1 * ISNULL(QTY, 0)
							WHEN MEASURE = 'WH_STOCK' THEN ISNULL(QTY, 0)
					ELSE 0 END
				), 0) AS QTY
			, NULL AS EDIT_YN
		FROM #Tmp_Result_Table AS T0 WITH(NOLOCK)
		WHERE 1 = 1
		AND T0.MEASURE IN ('SHIP_PLAN', 'WH_STOCK')
		GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.PRODUCT_LEVEL1, T0.ITEM_ID
			, T0.TO_SITE, T0.TRANSPORT_MODE, T0.INCOTERMS, T0.FCST_TYPE
			, T0.YYYYMMDD, T0.CONFIRM_DAY;

		--select * from #Tmp_Result_Table where measure in ('SHIP_PLAN', 'CONTAINER') ORDER BY YYYYMMDD, measure;
		--//END WH_STOCK, BALANCE 생성///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

		--//4-3. SHIP AVALIABLE GAP DATA INSERT		
		WITH Deduplication2 AS
		(
			SELECT
				DIVISION_ID
				, FROM_SITE
				, PRODUCT_LEVEL1
				, ITEM_ID
				, TO_SITE
				, TRANSPORT_MODE
				, INCOTERMS
				, FCST_TYPE
				, YYYYMMDD
				, CONFIRM_DAY
			FROM #Tmp_Result_Table WITH(NOLOCK)
			GROUP BY DIVISION_ID, FROM_SITE, PRODUCT_LEVEL1, ITEM_ID
				, TO_SITE, TRANSPORT_MODE, INCOTERMS, FCST_TYPE
				, YYYYMMDD, CONFIRM_DAY
		)
		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID,	FROM_SITE,		PRODUCT_LEVEL1,	ITEM_ID,	MEASURE	
		,	TO_SITE	,		TRANSPORT_MODE,	INCOTERMS,		FCST_TYPE
		,	SEQ,			CONFIRM_DAY,	YYYYMMDD,		QTY		,	EDIT_YN
		)
		SELECT 
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.PRODUCT_LEVEL1
			, T0.ITEM_ID 
			, 'SHIP_AVAL_GAP' AS MEASURE
			, T0.TO_SITE
			, T0.TRANSPORT_MODE
			, T0.INCOTERMS
			, T0.FCST_TYPE
			, 6 AS SEQ
			, T0.CONFIRM_DAY
			, T0.YYYYMMDD
			, (
				SELECT
					ISNULL( 
						SUM( 
							CASE	
								WHEN tt0.MEASURE = 'SHIP_PLAN' THEN -1 * ISNULL(tt0.QTY, 0)
								WHEN tt0.MEASURE = 'SHIP_AVAL' THEN ISNULL(tt0.QTY, 0)
								--WHEN tt0.MEASURE = 'PROD_PLAN' THEN ISNULL(tt0.QTY, 0)
								--WHEN tt0.MEASURE = 'SHIP_AVAL' THEN ISNULL(tt0.QTY, 0) -- NEW jilee
							ELSE 0.0
							END), 
						0)
				FROM #Tmp_Result_Table tt0 WITH(NOLOCK)
				WHERE 1 = 1
				AND tt0.DIVISION_ID = T0.DIVISION_ID
				AND tt0.FROM_SITE = T0.FROM_SITE
				AND tt0.ITEM_ID = T0.ITEM_ID
				AND tt0.MEASURE IN ('SHIP_PLAN', 'SHIP_AVAL')
				AND tt0.YYYYMMDD >= @p_plan_start_yyyymmdd
				AND tt0.YYYYMMDD <= T0.YYYYMMDD
				) AS QTY
			, NULL AS EDIT_YN
		FROM Deduplication2 T0 WITH(NOLOCK)
		WHERE 1 = 1
		ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.PRODUCT_LEVEL1, T0.ITEM_ID
				, T0.TO_SITE, T0.TRANSPORT_MODE, T0.INCOTERMS, T0.FCST_TYPE
				, T0.YYYYMMDD
		;

		--//4-4. Total PSI DATA INSERT		
		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID,	FROM_SITE,		PRODUCT_LEVEL1,	ITEM_ID,	MEASURE	
		,	TO_SITE	,		TRANSPORT_MODE,	INCOTERMS,		FCST_TYPE
		,	SEQ,			CONFIRM_DAY,	YYYYMMDD,		QTY		,	EDIT_YN
		)
		SELECT 
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.PRODUCT_LEVEL1
			, NULL AS ITEM_ID 
			, CASE T0.MEASURE WHEN 'SHIP_REQ'		THEN 'TOT_SHIP_REQ'		
                              WHEN 'SHIP_PLAN'		THEN 'TOT_SHIP_PLAN'
                              WHEN 'SHIP_AVAL'		THEN 'TOT_SHIP_AVAL'
                              WHEN 'SHIP_AVAL_GAP'	THEN 'TOT_SHIP_AVAL_GAP'
                              WHEN 'INTN_MOVEMENT'	THEN 'TOT_INTN_MOVEMENT'
                              WHEN 'CONTAINER'		THEN 'TOT_CONTAINER'
                              WHEN 'PROD_PLAN'		THEN 'TOT_PROD_PLAN'
                              WHEN 'WH_STOCK'		THEN 'TOT_WH_STOCK'
                              WHEN 'BALANCE'		THEN 'TOT_BALANCE' 
			  END AS MEASURE
			, NULL AS TO_SITE
			, NULL AS TRANSPORT_MODE
			, NULL AS INCOTERMS
			, NULL AS FCST_TYPE
			, CASE T0.MEASURE WHEN 'SHIP_REQ'		THEN 12
                              WHEN 'SHIP_PLAN'		THEN 13
                              WHEN 'SHIP_AVAL'		THEN 14
                              WHEN 'SHIP_AVAL_GAP'	THEN 15
                              WHEN 'INTN_MOVEMENT'	THEN 16
                              WHEN 'CONTAINER'		THEN 17
                              WHEN 'PROD_PLAN'		THEN 18
                              WHEN 'WH_STOCK'		THEN 19
                              WHEN 'BALANCE'		THEN 20
			  END AS SEQ
			, NULL AS CONFIRM_DAY
			, T0.YYYYMMDD
			, SUM(T0.QTY) AS QTY
			, NULL AS EDIT_YN
		FROM #Tmp_Result_Table T0
		where YYYYMMDD >= @p_plan_start_yyyymmdd
		GROUP BY T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.PRODUCT_LEVEL1
			, T0.MEASURE
			, T0.YYYYMMDD
		;
		
		--////////////////////////////////////////////////////////////////////////////////--
		--//4-4. Shipment PLAN Detail DATA INSERT(#Tmp_Result_Table <- #Tmp_Result_Detail_Table)	
		--////////////////////////////////////////////////////////////////////////////////--
		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID,	FROM_SITE,		PRODUCT_LEVEL1,	ITEM_ID,	MEASURE	
		,	TO_SITE	,		TRANSPORT_MODE,	INCOTERMS,		FCST_TYPE
		,	SEQ,			CONFIRM_DAY,	YYYYMMDD,		QTY		,	LOT_YN
		,	EDIT_YN
		)
		SELECT DIVISION_ID,	FROM_SITE,		PRODUCT_LEVEL1,	ITEM_ID,	MEASURE	
		,	TO_SITE	,		TRANSPORT_MODE,	INCOTERMS,		FCST_TYPE
		,	SEQ,			CONFIRM_DAY,	YYYYMMDD,		QTY		,	LOT_YN
		,	EDIT_YN
		FROM #Tmp_Result_Detail_Table
		;
		--////////////////////////////////////////////////////////////////////////////////--
		--//5. PIVOT				 													//--
		--////////////////////////////////////////////////////////////////////////////////--
		SELECT
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.PRODUCT_LEVEL1
			, T0.ITEM_ID
			, T0.MEASURE
			, T0.TO_SITE
			, T0.TRANSPORT_MODE
			, T0.INCOTERMS
			, T0.FCST_TYPE
			, T0.SEQ
			, T0.CONFIRM_DAY
			, 'D_' + T0.YYYYMMDD AS YYYYMMDD
			, T1.basis_yyyymm AS yyyymm
			, RIGHT(T1.basis_yyyymm,4) + T1.iso_week AS iso_week
			, T0.QTY
			, T0.LOT_YN
			, T0.EDIT_YN
		INTO #Tmp_Result_PIVOT_Table
		FROM #Tmp_Result_Table T0 WITH(NOLOCK)
		INNER JOIN scm_sys_calendar_m T1 
		ON T0.yyyymmdd = T1.basis_yyyymmdd
		;

		/*PIVOIT처리*******************************************************************************/
		BEGIN
		
			-- PIVOIT 대상 날짜문자열 생성
			SET @mQry_sum = '';
			
			SELECT  @mQry_sum = @mQry_sum+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN CONVERT(numeric(20, 10),ISNULL(T0.QTY, 0)) ELSE 0 END ) AS ' + yyyymmdd
													WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.iso_week = RIGHT('''+yyyymmdd+''',6) THEN CONVERT(numeric(20, 10),ISNULL(T0.QTY, 0)) ELSE 0 END ) AS ' + yyyymmdd
													WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.yyyymmdd = '''+yyyymmdd+'''          THEN CONVERT(numeric(20, 10),ISNULL(T0.QTY, 0)) ELSE 0 END ) AS ' + yyyymmdd + ', ' 
													                                      + 'MAX(CASE WHEN T0.yyyymmdd = '''+yyyymmdd+'''          THEN ISNULL(T0.EDIT_YN,''-'') ELSE ''-''            END) AS EDIT_YN_' + SUBSTRING(yyyymmdd, 3, LEN(yyyymmdd) - 2)
												END +''+CHAR(10)
			FROM ( 
					SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd        
						, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a 
					WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date

					UNION ALL

					SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
							,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a 
						WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY a.basis_yyyymm, a.month_name		

					UNION ALL

					SELECT 'D_'+a.basis_yyyymmdd   AS yyyymmdd      
							, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a 
						WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY a.basis_yyyymmdd	
								
					) AS A
			ORDER BY sort_order_no  ;
		END;
		--//END PIVOT///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

		--////////////////////////////////////////////////////////////////////////////////--
		--//6. RESULT				 													//--
		--////////////////////////////////////////////////////////////////////////////////--
		SET @mEXEC = '';
		SET @mEXEC = @mEXEC+'		SELECT																													' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	 T0.DIVISION_ID																										' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T0.FROM_SITE																										' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, isnull(dbo.fn_get_scm_site_description(T0.DIVISION_ID, T0.FROM_SITE ),''-'') AS from_site_description				' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T0.PRODUCT_LEVEL1																									' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T0.ITEM_ID																										' + CHAR(10);
		SET @mEXEC = @mEXEC+'			, (SELECT TOP 1 isnull(NULLIF(NICK_NAME,''''),''-'') FROM DBO.SCM_MST_ITEM_SN x WITH(NOLOCK) WHERE 1=1 AND x.ITEM_ID = T0.item_id) as nick_name            ' + char(10) ;
		SET @mEXEC = @mEXEC+'			, CASE WHEN T1.BOH_TYPE IS NULL THEN																				' + CHAR(10);
		SET @mEXEC = @mEXEC+'				CASE T0.SEQ WHEN 11 THEN ''BOH''																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'							WHEN 9 THEN ''ERP''																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'							WHEN 7 THEN ''oWMS''																				' + CHAR(10);
		SET @mEXEC = @mEXEC+'							WHEN 8 THEN ''MES''																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'				ELSE NULL END																									' + CHAR(10);
		SET @mEXEC = @mEXEC+'			  ELSE T1.BOH_TYPE END AS BOH_TYPE																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'			, CASE WHEN (T0.SEQ IN (7,8,9,11)) THEN ISNULL(T1.BOH_QTY, 0)																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'			  ELSE NULL END AS BOH_QTY																			' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, CASE T0.MEASURE	WHEN ''SHIP_REQ'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''SHIP_PLAN'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''SHIP_PLAN_DETAIL'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''SHIP_RESULT'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''SHIP_AVAL'' THEN ''S''																	' + CHAR(10); --NEW jilee
		SET @mEXEC = @mEXEC+'       						WHEN ''SHIP_AVAL_GAP'' THEN ''S''																' + CHAR(10); --NEW jilee
		SET @mEXEC = @mEXEC+'       						WHEN ''INTN_MOVEMENT'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''CONTAINER'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''PROD_PLAN'' THEN ''P''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''WH_STOCK'' THEN ''I''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''BALANCE'' THEN ''I''																		' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_SHIP_REQ'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_SHIP_PLAN'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_SHIP_AVAL'' THEN ''S''																	' + CHAR(10); --NEW jilee
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_SHIP_AVAL_GAP'' THEN ''S''																' + CHAR(10); --NEW jilee
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_INTN_MOVEMENT'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_CONTAINER'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_PROD_PLAN'' THEN ''P''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_WH_STOCK'' THEN ''I''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_BALANCE'' THEN ''I''	END PSI																' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T0.MEASURE																										' + CHAR(10);
		--SET @mEXEC = @mEXEC+'       	, CASE WHEN ISNULL(T0.TO_SITE, '''') = '''' THEN T2.COLUMN_LABEL_NAME ELSE NULL END  AS MEASURE_NAME				' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T2.COLUMN_LABEL_NAME  AS MEASURE_NAME				' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T0.TO_SITE																										' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T0.TRANSPORT_MODE																									' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T0.INCOTERMS																										' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T0.FCST_TYPE																										' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, CASE WHEN T0.SEQ < 12 THEN 1 ELSE 2 END AS ORD_SEQ																' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T0.SEQ																											' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, CONVERT(CHAR(8), DATEADD(DD, isnull(T0.CONFIRM_DAY,0), CONVERT(VARCHAR, '''+ @p_plan_start_yyyymmdd + ''', 121)), 112) AS CONFIRM_DAY ' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T2.ATTRIBUTE3 AS BACK_COLOR																									' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T0.LOT_YN ' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	' + @mQry_sum + CHAR(10);
		SET @mEXEC = @mEXEC+'       FROM #Tmp_Result_PIVOT_Table T0 WITH(NOLOCK)																			' + CHAR(10);
		SET @mEXEC = @mEXEC+'		LEFT OUTER JOIN	#Tmp_BOHData T1	WITH(NOLOCK)																						' + CHAR(10);
		SET @mEXEC = @mEXEC+'			ON T0.DIVISION_ID = T1.DIVISION_ID		AND T0.FROM_SITE = T1.FROM_SITE												' + CHAR(10);
		SET @mEXEC = @mEXEC+'			AND T0.ITEM_ID = T1.ITEM_ID				AND T0.SEQ = T1.SEQ															' + CHAR(10);
		SET @mEXEC = @mEXEC+'		INNER JOIN SCM_MST_SHEET_MEASURE T2 WITH(NOLOCK)																						' + CHAR(10);
		SET @mEXEC = @mEXEC+'			ON T0.MEASURE = T2.COLUMN_NAME																						' + CHAR(10);
		SET @mEXEC = @mEXEC+'			AND T2.PROGRAM_ID = ''' + @p_program_id + '''																		' + CHAR(10);
		SET @mEXEC = @mEXEC+'			AND T2.SHEET_NAME = ''' + @p_sheet_name + '''																		' + CHAR(10);
		SET @mEXEC = @mEXEC+'		LEFT OUTER JOIN SCM_MST_TITLESET_USER T3 WITH(NOLOCK)                                                                                                           ' + char(10) ;
		SET @mEXEC = @mEXEC+'			ON T3.PROGRAM_ID = T2.PROGRAM_ID                                                                                                                            ' + char(10) ;
		SET @mEXEC = @mEXEC+'			AND T3.SHEET_NAME = T2.SHEET_NAME                                                                                                                           ' + char(10) ;
		SET @mEXEC = @mEXEC+'			AND T3.COLUMN_NAME = T2.COLUMN_NAME                                                                                                                         ' + char(10) ;
		SET @mEXEC = @mEXEC+'			AND T3.USER_ID = ''' + @p_user_id + '''                                                                                                                     ' + char(10) ;
		SET @mEXEC = @mEXEC+'		WHERE 1 = 1 ' + char(10);
/*
		SET @mEXEC = @mEXEC+'		AND T2.PROGRAM_ID = ''' + @p_program_id + '''                                                                                                                                   ' + char(10) ;
		SET @mEXEC = @mEXEC+'		AND T2.SHEET_NAME = ''' + @p_sheet_name + '''                                                                                                                       ' + char(10) ;
		SET @mEXEC = @mEXEC+'		AND T2.COLUMN_NAME = T0.MEASURE																																	  ' + char(10) ;
*/
		SET @mEXEC = @mEXEC+'		AND T2.VALID_YN = ''Y''                                                                                                                                           ' + char(10) ;
		SET @mEXEC = @mEXEC+' 		AND ('+convert(varchar,@v_cnt_usr_measure)+' = 0                                      ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 						OR EXISTS (SELECT 1                                    ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 									 FROM #TblDynamicTitlest_SSP0060			   ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 									 WHERE COLUMN_NAME = T2.COLUMN_NAME)         ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 				                  )                                            ' + char(10) ; 	
		SET @mEXEC = @mEXEC+' 			  AND ( ( '+convert(varchar,@v_cnt_usr_measure)+' = 0 AND T2.DEFAULT_FLAG=''Y'' )                                      ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 						OR  ('+convert(varchar,@v_cnt_usr_measure)+' != 0 )       ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 				                  )                                            ' + char(10) ; 			
		SET @mEXEC = @mEXEC+'		GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.PRODUCT_LEVEL1, T0.ITEM_ID, T1.BOH_TYPE, T1.BOH_QTY	' + CHAR(10);
		SET @mEXEC = @mEXEC+'		, T0.MEASURE, T2.COLUMN_LABEL_NAME, T0.TO_SITE, T0.TRANSPORT_MODE, T0.INCOTERMS, T0.FCST_TYPE, T0.SEQ, T0.CONFIRM_DAY, T2.ATTRIBUTE3, T0.LOT_YN	' + CHAR(10);
		SET @mEXEC = @mEXEC+'		ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.PRODUCT_LEVEL1, (CASE WHEN T0.SEQ < 12 THEN 1 ELSE 2 END), T0.ITEM_ID, T0.SEQ, T0.MEASURE, T0.TO_SITE, T0.TRANSPORT_MODE, T0.INCOTERMS, T0.FCST_TYPE	' + CHAR(10);
	
		--PRINT @mQry_sum;
		EXEC(@mEXEC);
		--//END RESULT///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

	END
	ELSE
	BEGIN
		/*PIVOIT처리*******************************************************************************/
		BEGIN
			-- PIVOIT 대상 날짜문자열 생성
			SET @mQry_sum = '';
			
			SELECT  @mQry_sum = @mQry_sum+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN T0.QTY ELSE 0 END ) AS ' + yyyymmdd
													WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.iso_week = RIGHT('''+yyyymmdd+''',6) THEN T0.QTY ELSE 0 END ) AS ' + yyyymmdd
													WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.yyyymmdd = '''+yyyymmdd+''' THEN T0.QTY ELSE 0 END ) AS ' + yyyymmdd
												END +''+CHAR(10)
			FROM ( 
					SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd        
						, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a 
					WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date

					UNION ALL

					SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
							,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a 
						WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY a.basis_yyyymm, a.month_name		

					UNION ALL

					SELECT 'D_'+a.basis_yyyymmdd   AS yyyymmdd      
							, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a 
						WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY a.basis_yyyymmdd	
								
					) AS A
			ORDER BY sort_order_no  ;
		END;
		--//END PIVOT///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

		SELECT
			T0.DIVISION_ID
			, T0.FROM_SITE
			, CASE WHEN FI.GROUP_CODE1 = '' THEN '-' ELSE ISNULL(FI.GROUP_CODE1,'-') END AS PRODUCT_LEVEL1
			, T0.ITEM_ID
			, T0.MEASURE
			, T0.TO_SITE
			, T0.TRANSPORT_MODE
			, T0.INCOTERMS
			, T0.FCST_TYPE
			, T0.YYYYMMDD
			, T0.YYYYMM
			, T0.ISO_WEEK
			, CASE WHEN T0.MEASURE IN ('SHIP_PLAN','SHIP_PLAN_DETAIL','SHIP_RESULT') THEN ISNULL(T0.QTY, 0)
					                                                                 ELSE (CASE WHEN T0.QTY = 0 THEN NULL ELSE T0.QTY END)
			  END AS QTY
			, T0.LOT_YN
			--, T0.SEQ
		INTO #Tmp_Result_PIVOT_Table_Old
		FROM
		(
			SELECT
				T0.DIVISION_ID
				, T0.FROM_SITE
				,ISNULL(IM.APPLIED_MODEL, T0.ITEM_ID) AS ITEM_ID
				, T0.MEASURE
				, CASE WHEN T0.MEASURE = 'SHIP_PLAN' AND T0.TO_SITE != '-' THEN T0.TO_SITE ELSE '' END AS TO_SITE
				, CASE WHEN T0.MEASURE = 'SHIP_PLAN' AND T0.TRANSPORT_MODE != '-' THEN T0.TRANSPORT_MODE ELSE '' END AS TRANSPORT_MODE
				, CASE WHEN T0.MEASURE = 'SHIP_PLAN' AND T0.INCOTERMS != '-' THEN T0.INCOTERMS ELSE '' END AS INCOTERMS
				, CASE WHEN T0.MEASURE = 'SHIP_PLAN' AND T0.FCST_TYPE != '-' THEN T0.FCST_TYPE ELSE '' END AS FCST_TYPE
				, sum(convert(int, T0.QTY)) AS QTY
				, NULL AS LOT_YN
				, 'D_' + T0.YYYYMMDD AS YYYYMMDD
				, T1.basis_yyyymm AS yyyymm
				, RIGHT(T1.basis_yyyymm,4) + T1.iso_week AS iso_week				
			FROM SSP_ANL_SHIP_PLAN_C T0 WITH(NOLOCK)
			INNER JOIN scm_sys_calendar_m T1 WITH(NOLOCK)
				ON T0.yyyymmdd = T1.basis_yyyymmdd
			JOIN SCM_MST_SITE S WITH(NOLOCK) 
			ON S.DIVISION_ID = T0.DIVISION_ID 
			AND S.SCM_SITE_ID = T0.FROM_SITE 			
			LEFT OUTER JOIN SCM_MST_ITEM_SN IM WITH(NOLOCK) 
			ON   IM.DIVISION_ID = T0.DIVISION_ID							   
			AND  IM.COMPANY_ID = @p_company_id
			AND  IM.SITE_ID = S.SITE_ID
			AND  IM.ITEM_ID = T0.ITEM_ID
			AND  IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')	
			LEFT OUTER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
			ON   FI.DIVISION_ID = T0.DIVISION_ID
			AND  FI.ITEM_ID     = T0.ITEM_ID
			WHERE 1= 1
			AND T0.DIVISION_ID = @p_division_id
			AND T0.COMPANY_ID = @p_company_id
			AND T0.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND T0.yyyymmdd >= @p_from_yyyymmdd
			AND T0.yyyymmdd <= @p_to_yyyymmdd
			AND ((@p_from_site IS NULL OR @p_from_site ='') OR T0.FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site    ,',')))
			AND ((@p_item_id IS NULL OR @p_item_id ='')	OR T0.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')))				
			-- jilee 230901
			GROUP BY T0.DIVISION_ID, T0.FROM_SITE, IM.APPLIED_MODEL, T0.ITEM_ID, T0.MEASURE, T0.TO_SITE, T0.TRANSPORT_MODE, T0.INCOTERMS, T0.FCST_TYPE, T0.YYYYMMDD, T1.basis_yyyymm, T1.iso_week--, T2.LOT_SIZE
			
			--UNION ALL

			--SELECT
			--	 T0.DIVISION_ID
			--	, T0.FROM_SITE_ID AS FROM_SITE
			--	, T0.MODEL_ID     AS ITEM_ID				
			--	, 'SHIP_AVAL' AS MEASURE
			--	, T0.out_qty AS QTY
			--	, NULL AS LOT_YN
			--	, 'D_' + CONVERT(NVARCHAR(8), T0.plan_date, 112) AS YYYYMMDD
			--	, T1.basis_yyyymm AS yyyymm
			--	, RIGHT(T1.basis_yyyymm,4) + T1.iso_week AS iso_week				
			--FROM [dbo].SSP_DNM_FP_AMEND_SHIPAVAL T0 WITH(NOLOCK)
			--INNER JOIN [dbo].scm_sys_calendar_m T1 WITH(NOLOCK)
			--	ON T0.PLAN_DATE = T1.basis_yyyymmdd
			--WHERE 1 = 1
			----AND T0.operation_id IN ('P5500', 'P9500', 'F5300', 'F5500', 'F5600', 'F6000')
			--AND T0.out_qty >= 0 
			----AND T0.plan_in_qty > 0 
			--AND T0.DIVISION_ID = @p_division_id
			--AND T0.COMPANY_ID  = @p_company_id
			--AND T0.plan_date   >= @v_from_yyyymmdd
			--AND T0.plan_date   <= @v_to_yyyymmdd
			--AND T0.site_id IN 	(SELECT DISTINCT SITE_ID 
			--						FROM scm_mst_site
			--						where 1 = 1
			--						AND division_id = @p_division_id
			--						AND COMPANY_ID = @p_company_id
			--						AND site_type = 'PLANT'									
			--						AND valid_yn = 'Y'
			--					)
			--AND ((@p_from_site IS NULL OR @p_from_site ='') OR T0.FROM_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_from_site    ,',')))
			--AND ((@p_item_id IS NULL OR @p_item_id ='')	OR T0.MODEL_ID IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')))
		) T0
		LEFT OUTER JOIN dbo.SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
		ON FI.DIVISION_ID = T0.DIVISION_ID
		AND FI.ITEM_ID = T0.ITEM_ID
		WHERE 1=1
		AND ((@p_product_level1 IS NULL OR @p_product_level1 ='')	OR FI.GROUP_CODE1 IN (SELECT token FROM dbo.String_Split(@p_product_level1, ',')))
				
		-- 중복되는 특정 아이템 지우기
		DELETE FROM #Tmp_Result_PIVOT_Table_Old
		WHERE ITEM_ID IN (SELECT ITEM_ID FROM #Tmp_Result_PIVOT_Table_Old WITH(NOLOCK) WHERE 1=1		
						  AND  MEASURE = 'SHIP_PLAN'
						  AND TO_SITE != ''
						  GROUP BY ITEM_ID HAVING COUNT(ITEM_ID) > 1
						 )		
		AND MEASURE = 'SHIP_PLAN' AND QTY = 0 AND TO_SITE = '' -- AND TRANSPORT_MODE = '' AND INCOTERMS = '' AND FCST_TYPE = ''

		--2024/11/11 jilee 과거이력 보완 작업		
		DELETE FROM #Tmp_Result_PIVOT_Table_Old
		WHERE ITEM_ID IN (	SELECT AA.ITEM_ID FROM 
							(
							SELECT T0.ITEM_ID
							FROM #TMP_RESULT_PIVOT_TABLE_OLD T0 WITH(NOLOCK) WHERE 1=1
							AND MEASURE = 'SHIP_PLAN'
							GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.PRODUCT_LEVEL1, T0.ITEM_ID, T0.MEASURE
							, T0.TO_SITE, T0.TRANSPORT_MODE, T0.INCOTERMS, T0.FCST_TYPE,  T0.LOT_YN	 --HAVING COUNT(ITEM_ID) > 1
							) AS AA	 		
							WHERE 1=1
							GROUP BY AA.ITEM_ID HAVING COUNT(ITEM_ID) > 1
						 )		
		AND MEASURE = 'SHIP_PLAN' AND QTY = 0 AND  TRANSPORT_MODE = '' AND INCOTERMS = '' AND FCST_TYPE = ''	

		SET @mEXEC = '';
		SET @mEXEC = @mEXEC + '	SELECT																													' + CHAR(10);
		SET @mEXEC = @mEXEC + '		T0.DIVISION_ID																											' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T0.FROM_SITE																											' + CHAR(10);
		SET @mEXEC = @mEXEC + '       	, isnull(dbo.fn_get_scm_site_description(T0.DIVISION_ID, T0.FROM_SITE ),''-'') AS from_site_description ' + CHAR(10)
		SET @mEXEC = @mEXEC + '       	, T0.PRODUCT_LEVEL1																									' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, (SELECT TOP 1 isnull(NULLIF(NICK_NAME,''''),''-'') FROM DBO.SCM_MST_ITEM_SN x WITH(NOLOCK) WHERE 1=1 AND x.ITEM_ID = T0.item_id) as nick_name            ' + char(10) ;		
		SET @mEXEC = @mEXEC + '		, T0.ITEM_ID																											' + CHAR(10);		
		SET @mEXEC = @mEXEC+'		, CASE WHEN T2.BOH_TYPE IS NULL THEN																				' + CHAR(10);
		SET @mEXEC = @mEXEC+'			CASE T1.SORT_ORDER_NO	WHEN 11 THEN ''BOH''																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'									WHEN 9 THEN ''ERP''																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'									WHEN 7 THEN ''oWMS''																				' + CHAR(10);
		SET @mEXEC = @mEXEC+'									WHEN 8 THEN ''MES''																					' + CHAR(10);
		--SET @mEXEC = @mEXEC+'									WHEN 7 THEN ''HOLD''																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'			ELSE NULL END																									' + CHAR(10);
		SET @mEXEC = @mEXEC+'		  ELSE T2.BOH_TYPE END AS BOH_TYPE																					' + CHAR(10);
		--SET @mEXEC = @mEXEC+'		, CASE WHEN (T1.SORT_ORDER_NO = 1 OR T1.SORT_ORDER_NO = 2 OR T1.SORT_ORDER_NO = 3 OR T1.SORT_ORDER_NO = 4 OR T1.SORT_ORDER_NO = 9) THEN NULL																					' + CHAR(10);		
		SET @mEXEC = @mEXEC+'		, CASE WHEN (T1.SORT_ORDER_NO = 1 OR T1.SORT_ORDER_NO = 2 OR T1.SORT_ORDER_NO = 3 OR T1.SORT_ORDER_NO = 4) THEN NULL																					' + CHAR(10);		
		SET @mEXEC = @mEXEC+'		  ELSE ISNULL(T2.BOH_QTY, 0) END AS BOH_QTY																			' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, CASE T0.MEASURE	WHEN ''SHIP_REQ'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''SHIP_PLAN'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''SHIP_PLAN_DETAIL'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''SHIP_RESULT'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''SHIP_AVAL'' THEN ''S''																	' + CHAR(10); --NEW jilee
		--SET @mEXEC = @mEXEC+'       						WHEN ''SHIP_AVAL_GAP'' THEN ''S''																' + CHAR(10); --NEW jilee
		SET @mEXEC = @mEXEC+'       						WHEN ''INTN_MOVEMENT'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''CONTAINER'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''PROD_PLAN'' THEN ''P''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''WH_STOCK'' THEN ''I''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''BALANCE'' THEN ''I''																		' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_SHIP_REQ'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_SHIP_PLAN'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_SHIP_AVAL'' THEN ''S''																	' + CHAR(10); --NEW jilee
		--SET @mEXEC = @mEXEC+'       						WHEN ''TOT_SHIP_AVAL_GAP'' THEN ''S''																' + CHAR(10); --NEW jilee
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_INTN_MOVEMENT'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_CONTAINER'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_PROD_PLAN'' THEN ''P''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_WH_STOCK'' THEN ''I''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''TOT_BALANCE'' THEN ''I''	END PSI																' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T0.MEASURE																										' + CHAR(10);
		--SET @mEXEC = @mEXEC+'       , CASE WHEN ISNULL(T0.TO_SITE, '''') = '''' THEN T1.COLUMN_LABEL_NAME ELSE NULL END  AS MEASURE_NAME				' + CHAR(10);
		SET @mEXEC = @mEXEC+'       , T1.COLUMN_LABEL_NAME  AS MEASURE_NAME				' + CHAR(10);
		SET @mEXEC = @mEXEC+'       , T0.TO_SITE																										' + CHAR(10);
		SET @mEXEC = @mEXEC+'       , T0.TRANSPORT_MODE																									' + CHAR(10);
		SET @mEXEC = @mEXEC+'       , T0.INCOTERMS																										' + CHAR(10);
		SET @mEXEC = @mEXEC+'       , T0.FCST_TYPE																										' + CHAR(10);
		--SET @mEXEC = @mEXEC+'      	, CASE WHEN T0.SEQ < 12 THEN 1 ELSE 2 END AS ORD_SEQ																' + CHAR(10);
		SET @mEXEC = @mEXEC+'      	, 1 AS ORD_SEQ																' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T1.SORT_ORDER_NO	AS SEQ 																										' + CHAR(10);
		--SET @mEXEC = @mEXEC+'       	, isnull(dbo.fn_get_scm_site_description(T0.DIVISION_ID, T0.FROM_SITE ),''-'') AS from_site_description ' + CHAR(10)
		SET @mEXEC = @mEXEC+'       	, CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](''' + @v_app_type + ''', T0.DIVISION_ID,T0.FROM_SITE, ''' + @p_plan_start_yyyymmdd + ''') , CONVERT(DATETIME, '''+ @p_plan_start_yyyymmdd + ''' ,112) - 1) ,112) AS CONFIRM_DAY							' + CHAR(10);
--		SET @mEXEC = @mEXEC + '		, CONVERT(CHAR(8), DATEADD(DD, CASE WHEN (T3.SHIP_FROZEN - 1) > 0 THEN (T3.SHIP_FROZEN - 1) ELSE 0 END, CONVERT(VARCHAR, '''+ @p_from_yyyymmdd + ''', 121)), 112) AS CONFIRM_DAY							' + CHAR(10);
		SET @mEXEC = @mEXEC+'       , T1.ATTRIBUTE3 AS BACK_COLOR																									' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T0.LOT_YN ' + CHAR(10);
		SET @mEXEC = @mEXEC + '		' + @mQry_sum + '																									' + CHAR(10);
		SET @mEXEC = @mEXEC + '	FROM #Tmp_Result_PIVOT_Table_Old T0	WITH(NOLOCK)																						' + CHAR(10);
		SET @mEXEC = @mEXEC+'	INNER JOIN SCM_MST_SHEET_MEASURE T1	WITH(NOLOCK)																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'		ON T0.MEASURE = T1.COLUMN_NAME																						' + CHAR(10);
		SET @mEXEC = @mEXEC+'		AND T1.PROGRAM_ID = ''' + @p_program_id + '''																		' + CHAR(10);
		SET @mEXEC = @mEXEC+'		AND T1.SHEET_NAME = ''' + @p_sheet_name + '''																		' + CHAR(10);
		SET @mEXEC = @mEXEC+'	LEFT OUTER JOIN	#Tmp_BOHData T2	WITH(NOLOCK)																						' + CHAR(10);
		SET @mEXEC = @mEXEC+'			ON T0.DIVISION_ID = T2.DIVISION_ID		AND T0.FROM_SITE = T2.FROM_SITE												' + CHAR(10);
		SET @mEXEC = @mEXEC+'			AND T0.ITEM_ID = T2.ITEM_ID				AND T1.SORT_ORDER_NO = T2.SEQ															' + CHAR(10);
		SET @mEXEC = @mEXEC+'	INNER JOIN scm_mst_site T3 WITH(NOLOCK)																							' + CHAR(10);	
		SET @mEXEC = @mEXEC+'		ON T0.DIVISION_ID = ''' + @p_division_id + '''																					' + CHAR(10);	
		SET @mEXEC = @mEXEC+'		AND T3.COMPANY_ID = ''' + @p_company_id + '''																					' + CHAR(10);	
		SET @mEXEC = @mEXEC+'		AND T0.FROM_SITE = T3.scm_site_id																					' + CHAR(10);	
		SET @mEXEC = @mEXEC+'		AND T3.site_type  = ''PLANT''																						' + CHAR(10);	
		SET @mEXEC = @mEXEC+'		AND T3.valid_yn   = ''Y''																							' + CHAR(10);	
		SET @mEXEC = @mEXEC+'		LEFT OUTER JOIN SCM_MST_TITLESET_USER T4 WITH(NOLOCK)                                                                                                           ' + char(10) ;
		SET @mEXEC = @mEXEC+'			ON T4.PROGRAM_ID = T1.PROGRAM_ID                                                                                                                            ' + char(10) ;
		SET @mEXEC = @mEXEC+'			AND T4.SHEET_NAME = T1.SHEET_NAME                                                                                                                           ' + char(10) ;
		SET @mEXEC = @mEXEC+'			AND T4.COLUMN_NAME = T1.COLUMN_NAME                                                                                                                         ' + char(10) ;
		SET @mEXEC = @mEXEC+'			AND T4.USER_ID = ''' + @p_user_id + '''                                                                                                                     ' + char(10) ;
		SET @mEXEC = @mEXEC+'	WHERE 1 = 1' + CHAR(10);
/*
		SET @mEXEC = @mEXEC+'		AND T1.PROGRAM_ID = ''' + @p_program_id + '''                                                                                                                                   ' + char(10) ;
		SET @mEXEC = @mEXEC+'		AND T1.SHEET_NAME = ''' + @p_sheet_name + '''                                                                                                                       ' + char(10) ;
		SET @mEXEC = @mEXEC+'	AND T1.COLUMN_NAME = T0.MEASURE																																	  ' + char(10) ;
*/
		SET @mEXEC = @mEXEC+'		AND T1.VALID_YN = ''Y''                                                                                                                                           ' + char(10) ;
		SET @mEXEC = @mEXEC+' 		AND ('+convert(varchar,@v_cnt_usr_measure)+' = 0                                      ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 						OR EXISTS (SELECT 1                                    ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 									 FROM #TblDynamicTitlest_SSP0060			   ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 									 WHERE COLUMN_NAME = T1.COLUMN_NAME)         ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 				                  )                                            ' + char(10) ; 	
		SET @mEXEC = @mEXEC+' 			  AND ( ( '+convert(varchar,@v_cnt_usr_measure)+' = 0 AND T1.DEFAULT_FLAG=''Y'' )                                      ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 						OR  ('+convert(varchar,@v_cnt_usr_measure)+' != 0 )       ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 				                  )                                            ' + char(10) ; 	
		
		if(@p_Item_id != '' AND @p_Item_id IS NOT NULL ) SET @mEXEC = @mEXEC + '	AND T0.ITEM_ID = ''' + @p_Item_id + '''																						' + CHAR(10);		
		SET @mEXEC = @mEXEC + '	GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.PRODUCT_LEVEL1, T0.ITEM_ID, T0.MEASURE, T1.COLUMN_LABEL_NAME	' + CHAR(10);
		SET @mEXEC = @mEXEC + '	, T0.TO_SITE, T0.TRANSPORT_MODE, T0.INCOTERMS, T0.FCST_TYPE, T1.SORT_ORDER_NO, T2.BOH_TYPE, T2.BOH_QTY, T3.SHIP_FROZEN, T1.ATTRIBUTE3, T0.LOT_YN	' + CHAR(10);
		--SET @mEXEC = @mEXEC + '	ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.PRODUCT_LEVEL1, (CASE WHEN T0.SEQ < 12 THEN 1 ELSE 2 END), T0.ITEM_ID, T0.TO_SITE, T0.TRANSPORT_MODE, T0.INCOTERMS, T0.FCST_TYPE, T1.SORT_ORDER_NO	' + CHAR(10);
		SET @mEXEC = @mEXEC + '	ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.PRODUCT_LEVEL1, T0.ITEM_ID, T0.TO_SITE, T0.TRANSPORT_MODE, T0.INCOTERMS, T0.FCST_TYPE, T1.SORT_ORDER_NO	' + CHAR(10);
		--print @mEXEC;
		EXEC(@mEXEC);

	END;

	--NOTE Load
	EXEC [dbo].[SSP0060_GET_SHIPMENT_PSI_COMMENTS] @p_division_id, @p_company_id, @p_plan_start_yyyymmdd, @p_from_site, @p_item_id, @p_from_yyyymmdd, @p_to_yyyymmdd;

	IF OBJECT_ID('tempdb..#Tmp_BOHData_STORAGE') IS NOT NULL	
		DROP TABLE #Tmp_BOHData_STORAGE;

	IF OBJECT_ID('tempdb..#Tmp_BOHData') IS NOT NULL	
		DROP TABLE #Tmp_BOHData;

	-- SHIPMENT RESULT
	IF OBJECT_ID('tempdb..#Tmp_SHIPMENT_RESULT') IS NOT NULL	
		DROP TABLE #Tmp_SHIPMENT_RESULT;

	-- SHIPMENT ROW DATA
	IF OBJECT_ID('tempdb..#Tmp_RowData') IS NOT NULL	
		DROP TABLE #Tmp_RowData;

	IF OBJECT_ID('tempdb..#Tmp_Result_PIVOT_Table') IS NOT NULL	
		DROP TABLE #Tmp_Result_PIVOT_Table;

	IF OBJECT_ID('tempdb..#Tmp_Result_PIVOT_Table_Old') IS NOT NULL	
		DROP TABLE #Tmp_Result_PIVOT_Table_Old;

	IF OBJECT_ID('tempdb..#Tmp_Result_Table') IS NOT NULL	
		DROP TABLE #Tmp_Result_Table;

	IF OBJECT_ID('tempdb..#Tmp_Result_Detail_Table') IS NOT NULL	
		DROP TABLE #Tmp_Result_Detail_Table;

	IF OBJECT_ID('tempdb..#TblDynamicTitlest_SSP0060') IS NOT NULL	
		DROP TABLE #TblDynamicTitlest_SSP0060;

END
