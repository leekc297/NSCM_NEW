

/*
 * Program ID   : SSP0021_GET_SHIPMENT_PLAN
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
 * 2024/10/01   KHJ             NERP_SSP
 * 2026/07/13	강주용			[E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정
 * 2026/08/13	강주용			[E20260811-000692] ESMI AZ 링크 2호기 생산계획 받아오지 못하는 현상 처리
 * ex)
	EXEC SSP0021_GET_SHIPMENT_PLAN @p_division_id = '81', @p_company_id = 'C100', @p_from_site = '', @p_plan_start_yyyymmdd = '20190909', @p_from_yyyymmdd = '20190909', @p_to_yyyymmdd = '20191102', @p_item_id = 'APVCCHORI-A1', @p_user_id = 'kahonmalu', @p_program_id = 'SSP0021', @p_sheet_name ='Shipment Plan', @p_real_flag = 'Y'
 */
CREATE PROCEDURE [dbo].[SSP0021_GET_SHIPMENT_PLAN]
	@p_division_id			VARCHAR(10)
	,@p_company_id			NVARCHAR(100)
	,@p_from_site			NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(8)
	,@p_from_yyyymmdd		NVARCHAR(8)
	,@p_to_yyyymmdd			NVARCHAR(8)
	,@p_item_id				NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_program_id			NVARCHAR(MAX) = 'SSP0021' 
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

	-- SHIPMENT ROW DATA
	IF OBJECT_ID('tempdb..#Tmp_RowData') IS NOT NULL	
		DROP TABLE #Tmp_RowData;

	IF OBJECT_ID('tempdb..#Tmp_Result_PIVOT_Table') IS NOT NULL	
		DROP TABLE #Tmp_Result_PIVOT_Table;

	IF OBJECT_ID('tempdb..#Tmp_Result_PIVOT_Table_Old') IS NOT NULL	
		DROP TABLE #Tmp_Result_PIVOT_Table_Old;

	IF OBJECT_ID('tempdb..#Tmp_Result_Table') IS NOT NULL	
		DROP TABLE #Tmp_Result_Table;

	IF OBJECT_ID('tempdb..#TblDynamicTitlest_SSP0021') IS NOT NULL	
		DROP TABLE #TblDynamicTitlest_SSP0021;


	SELECT * INTO #TblDynamicTitlest_SSP0021 
	FROM SCM_MST_TITLESET_USER WITH(NOLOCK)
	WHERE PROGRAM_ID  = @p_program_id
		AND SHEET_NAME  = @p_sheet_name
		AND USER_ID     = @p_user_id;

	CREATE TABLE #Tmp_Result_Table
	(
		DIVISION_ID		NVARCHAR(30)
		, FROM_SITE		NVARCHAR(30)
		, ITEM_ID		NVARCHAR(50)
		, MEASURE		NVARCHAR(50)
		, SEQ			INT
		, CONFIRM_DAY   INT
		, YYYYMMDD		NVARCHAR(8)
		, QTY			NUMERIC(20, 10)
		, LOT_YN		CHAR(1)
	);
	/********************************************************************************/

	--////////////////////////////////////////////////////////////////////////////////--
	--//1. BOH																		//--
	--////////////////////////////////////////////////////////////////////////////////--

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
		FROM [dbo].[SSP_DNM_STOCK_C] WITH(NOLOCK) --SCM_DNM_STOCK_V WITH(NOLOCK) 
		WHERE 1 = 1
		AND division_id = @p_division_id
		AND company_id = @p_company_id
		AND cutoff_date >  @p_stock_yyyymmdd -- 현재일 - 3
		AND cutoff_date = @v_boh_yyyymmdd	
		AND ((@p_from_site IS NULL OR @p_from_site ='') OR scm_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
		AND ((@p_item_id IS NULL OR @p_item_id ='')	OR item_id IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
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
	--jilee 230901
	SELECT
		TMP_BOH.DIVISION_ID,		TMP_BOH.FROM_SITE,		ISNULL(IM.APPLIED_MODEL, TMP_BOH.ITEM_ID) AS ITEM_ID,	CONVERT(NVARCHAR(8), TMP_BOH.YYYYMMDD, 112) AS YYYYMMDD,		TMP_BOH.BOH_TYPE AS BOH_TYPE,		SUM(TMP_BOH.BOH_QTY) AS BOH_QTY,	TMP_BOH.SEQ--,	STORAGE_ID
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
			--SELECT
			--	T0.division_id			AS DIVISION_ID
			--	, T0.scm_site_id		AS FROM_SITE
			--	, T0.item_id			AS ITEM_ID
			--	, 'BOH'					AS BOH_TYPE
			--	, cutoff_date			AS YYYYMMDD
			--	, ISNULL(T0.ssp_qty, 0) 
			--	  --+ ISNULL(T2.MES_QTY, 0)
			--	  AS BOH_QTY
			--	, 4						AS SEQ				--MEASURE 위치와 동일하게
			--	--, T0.storage_id			AS STORAGE_ID
			--FROM MST_STOCK T0 WITH(NOLOCK)
			--INNER JOIN MST_LOCATION T1
			--	ON T0.division_id = T1.DIVISION_ID			AND T0.storage_id = T1.STORAGE_ID
			--	AND T0.PLANT_ID = T1.PLANT_ID				AND T0.COMPANY_ID = T1.COMPANY_ID
			--	AND T0.scm_site_id = T1.SCM_SITE_ID
			--	AND T1.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'AS') -- ,'CMA_BMA')		-- 특성완료 이후 창고
			--WHERE 1 = 1
			
			--UNION ALL
			--MES TOTAL - (OQC_NG + QMS/MES_HOLD)
			SELECT
				T0.DIVISION_ID
				, T0.FROM_SITE
				, T0.ITEM_ID
				, 'BOH'					AS BOH_TYPE
				, T0.YYYYMMDD
				, ISNULL(SUM(TOTAL) - (SUM(OQC_NG) + SUM(QMS_MES_Hold)), 0) AS BOH_QTY
				, 5						AS SEQ
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
				, 5			AS SEQ				--MEASURE 위치와 동일하게
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
			 , cutoff_date			AS YYYYMMDD
			 , T0.scm_qty           AS BOH_QTY
			 , 6					AS SEQ				--MEASURE 위치와 동일하게
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
			 , SUM(W.STOCK_QTY)			AS BOH_QTY
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
				, 5						AS SEQ				--MEASURE 위치와 동일하게
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
				, 6						AS SEQ				--MEASURE 위치와 동일하게
			FROM PACKER_STOCK T0 WITH(NOLOCK)
			WHERE 1 = 1
			AND T0.DIVISION_ID = @p_division_id
			AND T0.COMPANY_ID = @p_company_id
			AND ((@p_from_site IS NULL OR @p_from_site ='') OR T0.SCM_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
			AND ((@p_item_id IS NULL OR @p_item_id ='')	OR T0.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))

		/*
		UNION ALL
		--//HOLD : 3S==================================================================================================================================
		SELECT 
			A.DIVISION_ID
			, A.FROM_SITE
			, A.ITEM_ID
			, 'HOLD'				AS BOH_TYPE
			, A.PLAN_START_YYYYMMDD			AS YYYYYMMDD
			, SUM(A.HOLD_QTY)		AS BOH_QTY
			, 7			AS SEQ				--MEASURE 위치와 동일하게
			, '-'					AS STORAGE_ID
		FROM SSP_ANL_HOLD_STOCK A
		LEFT OUTER JOIN SCM_MST_SITE B
			ON A.DIVISION_ID = B.DIVISION_ID AND A.FROM_SITE = B.SCM_SITE_ID
			AND B.COMPANY_ID = @p_company_id AND B.VALID_YN ='Y'
			AND B.site_type = 'PLANT'
		WHERE 1 = 1
		AND A.DIVISION_ID = @p_division_id
		AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd	
		AND ((A.HOLD_YYYYMMDD BETWEEN @v_from_yyyymmdd AND  @v_to_yyyymmdd) OR (A.RELEASE_YYYYMMDD BETWEEN @v_from_yyyymmdd AND  @v_to_yyyymmdd))
		AND ((@p_from_site IS NULL OR @p_from_site ='') OR A.FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
		AND ((@p_item_id IS NULL OR @p_item_id ='')	OR A.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
		GROUP BY A.DIVISION_ID, A.FROM_SITE, A.ITEM_ID, A.PLAN_START_YYYYMMDD
		*/
	) AS TMP_BOH
	 --jilee 230901
	JOIN SCM_MST_SITE S WITH(NOLOCK) 
	ON S.DIVISION_ID = TMP_BOH.DIVISION_ID 
	AND S.SCM_SITE_ID = TMP_BOH.FROM_SITE 			
    LEFT OUTER JOIN SCM_MST_ITEM_SN IM WITH(NOLOCK) 
	ON   IM.DIVISION_ID = TMP_BOH.DIVISION_ID							   
	AND  IM.COMPANY_ID = @p_company_id
	AND  IM.SITE_ID = S.SITE_ID
	AND  IM.ITEM_ID = TMP_BOH.ITEM_ID
	AND  IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')	
	GROUP BY TMP_BOH.DIVISION_ID, TMP_BOH.FROM_SITE, IM.APPLIED_MODEL, TMP_BOH.ITEM_ID,  TMP_BOH.YYYYMMDD, TMP_BOH.BOH_TYPE, TMP_BOH.SEQ--, STORAGE_ID
	;

	SELECT
		DIVISION_ID,		FROM_SITE,		ITEM_ID,		CONVERT(NVARCHAR(8), YYYYMMDD, 112) AS YYYYMMDD,		BOH_TYPE AS BOH_TYPE,		SUM(BOH_QTY) AS BOH_QTY,	SEQ
	INTO #Tmp_BOHData
	FROM #Tmp_BOHData_STORAGE WITH(NOLOCK)
	GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID,  YYYYMMDD, BOH_TYPE, SEQ;
	--//END BOH : 5S////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
	
	--select * from #Tmp_BOHData;
	--return;

	IF @p_real_flag = 'Y'
	BEGIN
		--////////////////////////////////////////////////////////////////////////////////--
		--//2. DATA ROW DATE															//--
		--////////////////////////////////////////////////////////////////////////////////--

		SELECT
			T0.DIVISION_ID
			-- jilee 230901
			,ISNULL(M.APPLIED_MODEL, T0.ITEM_ID) AS ITEM_ID
			--, T0.ITEM_ID
			, T0.FROM_SITE
			, T0.MEASURE
			, T0.SEQ
			, T0.YYYYMMDD
			, SUM(T0.QTY) AS QTY
			/*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
			--, CASE WHEN (T1.SHIP_FROZEN - 1) > 0 THEN (T1.SHIP_FROZEN - 1) ELSE 0 END AS CONFIRM_DAY
			, CASE WHEN [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, T0.DIVISION_ID,T0.FROM_SITE, @v_from_yyyymmdd) - 1 > 0  THEN [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, T0.DIVISION_ID,T0.FROM_SITE, @v_from_yyyymmdd) - 1
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
				, T0.yyyymmdd				AS YYYYMMDD
				, T0.qty					AS QTY
				, 1							AS SEQ
			FROM   dm_pln_shipment_req T0 WITH(NOLOCK)
			INNER JOIN scm_mst_site T1 WITH(NOLOCK)
				ON T0.DIVISION_ID = @p_division_id		AND	T0.PLANT_SITE_ID = T1.SCM_SITE_ID
				AND T1.COMPANY_ID = @p_company_id
				AND T1.site_type = 'PLANT'				AND T1.VALID_YN = 'Y'
				-- AND T1.osp_yn = 'N'    -- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외)
			WHERE  1=1
			AND T0.division_id = @p_division_id -- 변수
			AND T1.COMPANY_ID = @p_company_id
			AND T0.measure = 'SHIP_REQ' -- 확정 후 수정할 것
			AND T0.yyyymmdd >= @v_from_yyyymmdd	
			AND T0.yyyymmdd <= @v_to_yyyymmdd	
			AND T0.qty > 0
			AND (( @p_from_site IS NULL OR @p_from_site ='') OR T0.plant_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site , ',')))
			AND (( @p_item_id IS NULL OR @p_item_id ='') OR T0.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id , ',')))
			-- START [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP PROD 자동생성 항목 제외
			AND NOT EXISTS ( 
				SELECT 1 
				FROM  SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
				WHERE L.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
				AND L.VALID_YN = 'Y'
				AND L.SEGMENT1 = T0.DIVISION_ID
				AND L.SEGMENT2 = T0.PLANT_SITE_ID
				AND L.SEGMENT4 = T0.ITEM_ID
			)
			-- END [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP PROD 자동생성 항목 제외
			
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
				, T0.measure			AS MEASURE
				, T0.yyyymmdd			AS YYYYMMDD
				, ISNULL(SUM(T0.qty), 0)			AS QTY
				, T0.seq				AS SEQ
			FROM
			(
				--//2) Ship Plan : SSP(Daily) Plant향 Shipment Plan====================================================================================================
				--//===================================================================================================================================================
				SELECT 
					T0.division_id
					, T0.item_id
					, T0.from_site
					, 'SHIP_PLAN'         AS measure
					, T0.yyyymmdd
					, T0.qty
					, 2                     AS seq
				FROM ssp_anl_ship_confirm T0 WITH (NOLOCK)
				WHERE 1 = 1
				AND T0.change_type  = 'C'
				AND T0.BIZ_TYPE  <> 'E'
				AND T0.qty >  0
				AND T0.division_id  = @p_division_id  
				AND T0.FROM_SITE_COMPANY_ID = @p_company_id
				--AND T0.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd 
				AND T0.yyyymmdd >= @v_from_yyyymmdd
				AND T0.yyyymmdd <= @v_to_yyyymmdd
				AND ((@p_from_site IS NULL OR @p_from_site ='' ) OR T0.from_site IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
				AND ((@p_item_id IS NULL OR @p_item_id ='' ) OR T0.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id, ','))) 

				UNION ALL
				--확정구간 이후 Ship Req 수량 합
				SELECT
					DIVISION_ID,
					ITEM_ID,
					FROM_SITE,
					MEASURE,
					YYYYMMDD,
					QTY,
					SEQ
				FROM
				(
					SELECT 
						T0.division_id				AS DIVISION_ID
						, T0.item_id				AS ITEM_ID
						, T0.plant_site_id			AS FROM_SITE
						, 'SHIP_PLAN'				AS MEASURE
						, T0.yyyymmdd				AS YYYYMMDD
						, T0.qty					AS QTY
						, 2							AS SEQ
						/*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
						--, CASE WHEN isnull(fs.ship_frozen,0) > 0 THEN CONVERT(CHAR(8), DATEADD(DD, isnull(fs.ship_frozen,0), CONVERT(VARCHAR, @p_from_yyyymmdd, 121)), 112) ELSE @p_from_yyyymmdd END AS frozen_yyyymmdd -- Ship Frozen구간 다음일자
						, CASE WHEN isnull(fs.ship_frozen,0) > 0 THEN CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, FS.DIVISION_ID ,FS.SCM_SITE_ID, @p_from_yyyymmdd) , CONVERT(DATETIME, @p_from_yyyymmdd ,112)) ,112) 
																 ELSE @p_from_yyyymmdd 
						  END AS frozen_yyyymmdd -- Ship Frozen구간 다음일자
					FROM dm_pln_shipment_req T0 WITH(NOLOCK)
					INNER JOIN scm_mst_site fs WITH(NOLOCK)	
						ON  fs.division_id		= @p_division_id
						AND T0.plant_site_id    = fs.scm_site_id
						AND fs.COMPANY_ID = @p_company_id
						AND fs.site_type		= 'PLANT'  
						-- AND fs.osp_yn			= 'N' -- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외) 
						AND fs.valid_yn			= 'Y'
					WHERE  1=1
					AND T0.division_id = @p_division_id -- 변수
					AND fs.COMPANY_ID = @p_company_id
					AND T0.measure = 'SHIP_REQ' -- 확정 후 수정할 것
					AND T0.yyyymmdd >= @v_from_yyyymmdd	
					AND T0.yyyymmdd <= @v_to_yyyymmdd	
					AND T0.qty > 0
					AND (( @p_from_site IS NULL OR @p_from_site ='') OR T0.plant_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site , ',')))
					AND (( @p_item_id IS NULL OR @p_item_id ='') OR T0.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id , ',')))
					-- START [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP PROD 자동생성 항목 제외
					AND NOT EXISTS ( 
						SELECT 1 
						FROM  SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
						WHERE L.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
						AND L.VALID_YN = 'Y'
						AND L.SEGMENT1 = T0.DIVISION_ID
						AND L.SEGMENT2 = T0.PLANT_SITE_ID
						AND L.SEGMENT4 = T0.ITEM_ID
					)
					-- END [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP PROD 자동생성 항목 제외
				) T1
				WHERE 1 = 1
				AND YYYYMMDD >= frozen_yyyymmdd 
			) T0
			GROUP BY T0.division_id, T0.item_id, T0.from_site, /*T0.tr_mode, T0.incoterms,*/ T0.measure, T0.yyyymmdd, T0.seq
			
			--//PROD_PLAN//===================================================================
			--////////////////////////////////////////////////////////////////////////////////--
			--//2-4. PROD_PLAN : 생산 계획													//--
			--//	SCM_DNM_PLAN_FROZEN_V / MEASURE = 'PROD_PLAN'							//--
			--//	Pack : 'P5500', 'P9500' / Cell : 'F5300', 'F5500', 'F5600', 'F6000'		//--
			--//	Link : 'PL500'															//--
			--////////////////////////////////////////////////////////////////////////////////--
			UNION ALL
			SELECT
				T0.DIVISION_ID
				, T0.ITEM_ID
				, T0.SCM_SITE_ID AS FROM_SITE
				, 'PROD_PLAN' AS MEASURE
				, CONVERT(NVARCHAR(8), T0.plan_date, 112) AS YYYYMMDDD
				--, SUM(T0.plan_qty) AS QTY
				, T0.plan_qty AS QTY
				, 7 AS SEQ
			FROM [dbo].[SSP_DNM_FP_PLAN_FROZEN] T0 WITH(NOLOCK) -- SCM_DNM_PLAN_FROZEN_V T0 WITH(NOLOCK) 
			WHERE 1 = 1
			-- START [E20260811-000692] ESMI AZ 링크 2호기 생산계획 받아오지 못하는 현상 처리
			-- 원본 AND T0.operation_id IN ('P5500', 'P9500', 'F5300', 'F5500', 'F5600', 'F6000')
			AND T0.operation_id IN ('P5500', 'P9500', 'F5300', 'F5500', 'F5600', 'F6000', 'PL500')
			-- END [E20260811-000692] ESMI AZ 링크 2호기 생산계획 받아오지 못하는 현상 처리
			AND T0.plan_qty > 0 
			--AND T0.plan_in_qty > 0 
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
									--AND osp_yn  = 'N'  -- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN = 'N' 조건제외) 
									AND valid_yn = 'Y'
								)
			AND ((@p_from_site IS NULL OR @p_from_site ='') OR T0.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site    ,',')))
			AND ((@p_item_id IS NULL OR @p_item_id ='')	OR T0.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')))
			--GROUP BY T0.DIVISION_ID, T0.ITEM_ID, T0.SCM_SITE_ID, CONVERT(NVARCHAR(8), T0.plan_date, 112)
			
			UNION ALL		
            -- [C20200121-000352]-3 : Production Plan Measure에 Paker생산계획 추가(SCP_ANL_PRODUCTION_PLAN 의 PROD_PLAN_AMEND measure) 		
			SELECT P.DIVISION_ID 
			,      P.ITEM_ID 
			,      P.SCM_SITE_ID  AS FROM_SITE
			,      'PROD_PLAN'    AS MEASURE  
			,      P.YYYYMMDD     AS YYYYMMDDD   
			,      P.QTY          AS QTY
			,      7              AS SEQ
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
			-- START [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP PROD 자동생성 항목 제외
			AND NOT EXISTS ( 
				SELECT 1 
				FROM  SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
				WHERE L.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
				AND L.VALID_YN = 'Y'
				AND L.SEGMENT1 = P.DIVISION_ID
				AND L.SEGMENT2 = P.SCM_SITE_ID
				AND L.SEGMENT4 = P.ITEM_ID
			)
			-- END [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP PROD 자동생성 항목 제외
			UNION ALL
			-- A/S PLANT ETA 기준 
			--SELECT C.DIVISION_ID              AS DIVISION_ID
			--		,C.ITEM_ID                AS ITEM_ID
			--		,C.TO_SITE                AS FROM_SITE
			--		,'PROD_PLAN'			  AS MEASURE  
			--		,C.ETA_DATE               AS YYYYMMDD
			--		,C.QTY                    AS QTY
			--		, 4						  AS SEQ
			--	FROM SSP_ANL_SHIP_CONFIRM AS C WITH(NOLOCK)
			--		JOIN SCM_MST_SITE AS TS WITH(NOLOCK)
			--	ON C.DIVISION_ID = TS.DIVISION_ID
			--	AND C.TO_SITE = TS.SCM_SITE_ID
			--	AND TS.OPERATION_GROUP = 'W'
			--	AND TS.SITE_TYPE = 'PLANT'
			--	AND TS.VALID_YN = 'Y'
			--WHERE  C.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@p_division_id,',')) 
			--	AND C.TO_SITE_COMPANY_ID = @p_company_id   
			--	AND C.QTY		> 0
			--	AND C.ETA_DATE >= @v_from_yyyymmdd
			--	AND C.ETA_DATE <  @v_to_yyyymmdd
			--	AND ((@p_from_site IS NULL OR @p_from_site ='') OR C.TO_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site    ,',')))
			--	AND ((@p_item_id IS NULL OR @p_item_id ='')	OR C.ITEM_ID  IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')))

			SELECT DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY, SEQ
			  FROM (
			       SELECT C.DIVISION_ID					AS DIVISION_ID
					    , C.ITEM_ID						AS ITEM_ID
					    , C.SCM_SITE_ID					AS FROM_SITE
					    , 'PROD_PLAN'					AS MEASURE  
					    , [dbo].[FN_GET_SSP_ETA_DATE](C.DIVISION_ID, C.BOD_ID, C.YYYYMMDD)               AS YYYYMMDD
					    , C.QTY							AS QTY
					    , 7							AS SEQ
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
				-- START [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP PROD 자동생성 항목 제외
				AND NOT EXISTS ( 
					SELECT 1 
					FROM  SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
					WHERE L.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
					AND L.VALID_YN = 'Y'
					AND L.SEGMENT1 = X.DIVISION_ID
					AND L.SEGMENT2 = X.FROM_SITE
					AND L.SEGMENT4 = X.ITEM_ID
				)
				-- END [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP PROD 자동생성 항목 제외

			UNION ALL
			SELECT
				 T0.DIVISION_ID
				, T0.MODEL_ID     AS ITEM_ID
				, T0.FROM_SITE_ID AS FROM_SITE
				, 'SHIP_AVAL' AS MEASURE
				, CONVERT(NVARCHAR(8), T0.plan_date, 112) AS YYYYMMDDD
				--, SUM(T0.plan_qty) AS QTY
				, T0.out_qty AS QTY
				, 3 AS SEQ
			FROM [dbo].SSP_DNM_FP_AMEND_SHIPAVAL T0 WITH(NOLOCK) 
			WHERE 1 = 1
			--AND T0.operation_id IN ('P5500', 'P9500', 'F5300', 'F5500', 'F5600', 'F6000')
			AND T0.out_qty >= 0 
			--AND T0.plan_in_qty > 0 
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
		WHERE 1 = 1
		-- jilee 230901
		GROUP BY T0.DIVISION_ID, T0.FROM_SITE, M.APPLIED_MODEL, T0.ITEM_ID, T0.YYYYMMDD, T0.MEASURE, T0.SEQ, T1.SHIP_FROZEN
		ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD, T0.SEQ
		;
		
		--//END DATA ROW DATE : 16s//////////////////////////////////////8/////////////////////////////////////////////////////////////////////////////////--

		--////////////////////////////////////////////////////////////////////////////////--
		--//3. 해당 ITEM별 MEASURE 및 날짜 생성											//--
		--////////////////////////////////////////////////////////////////////////////////--
		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID,		FROM_SITE,		ITEM_ID,		MEASURE,		SEQ,		CONFIRM_DAY,		YYYYMMDD,		QTY
		)
		SELECT
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.ITEM_ID
			, T0.MEASURE
			, T0.SEQ
			, T0.CONFIRM_DAY
			, T0.YYYYMMDD
			, ISNULL(T1.QTY, 0) AS QTY
		FROM 
		(
			SELECT
				tt0.DIVISION_ID
				, tt0.FROM_SITE
				, tt0.ITEM_ID
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
		AND T0.MEASURE IN ('SHIP_REQ', 'SHIP_PLAN', 'PROD_PLAN','SHIP_AVAL') -- jilee
		ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD, T0.SEQ
		;
		--//END 해당 ITEM별 MEASURE 및 날짜 생성///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

		--//INTN_MOVEMENT//===================================================================
		--////////////////////////////////////////////////////////////////////////////////--
		--//2-3. INTN_MOVEMENT								//--
		--////////////////////////////////////////////////////////////////////////////////--
		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID,		FROM_SITE,		ITEM_ID,		MEASURE,		SEQ,		CONFIRM_DAY,		YYYYMMDD,		QTY,		LOT_YN
		)
		SELECT
			T0.DIVISION_ID,		T0.FROM_SITE,	T0.ITEM_ID,		T0.MEASURE,		T0.SEQ,		T0.CONFIRM_DAY,		T0.YYYYMMDD,	T0.QTY,		T0.LOT_YN
		FROM
		(
			SELECT 
				T0.DIVISION_ID
				, T0.FROM_SITE
				, T0.ITEM_ID
				, 'INTN_MOVEMENT' AS MEASURE
				, 5 AS SEQ
				, T0.CONFIRM_DAY
				, T0.YYYYMMDD
				, sum(isnull(T1.QTY, 0)) as QTY
				, NULL AS LOT_YN
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
				AND ( ( @p_from_site IS NULL OR         @p_from_site         ='' ) OR fs.scm_site_id         IN (SELECT token FROM dbo.String_Split(@p_from_site    ,',')) )
				AND ( ( @p_item_id IS NULL OR         @p_item_id         ='' )	OR p.item_id         IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
				AND    p.qty  >  0
			) T1
				ON T0.DIVISION_ID = T1.DIVISION_ID		AND T0.FROM_SITE = T1.FROM_SITE 
				AND T0.ITEM_ID = T1.ITEM_ID				AND T0.YYYYMMDD = T1.yyyymmdd
				AND T0.MEASURE = 'SHIP_PLAN'
			GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD, T0.MEASURE, T0.SEQ, T0.CONFIRM_DAY
			--//CONTAINER
			/* 소스 위치 변경 맨 밑으로
			UNION ALL
			SELECT
				A.DIVISION_ID,		
				A.FROM_SITE,		
				A.ITEM_ID,		
				'CONTAINER' AS MEASURE,		
				6 AS SEQ,
				A.CONFIRM_DAY,
				A.YYYYMMDD,
				CASE WHEN ISNULL(MAX(B.LOT_SIZE), 0) = 0 THEN 0 ELSE CEILING(MAX(ISNULL(A.QTY, 0)) /ISNULL(MAX(B.LOT_SIZE), 0)) END AS QTY,
				CASE WHEN B.LOT_SIZE IS NULL THEN 'N' ELSE 'Y' END AS LOT_YN
			FROM #Tmp_Result_Table A WITH(NOLOCK)
			LEFT OUTER JOIN scp_mst_shipment_lot_size B WITH(NOLOCK)
				ON B.DIVISION_ID = @p_division_id
				AND B.ITEM_ID = A.ITEM_ID
				AND B.FROM_SITE = A.FROM_SITE
				AND B.VALID_YN = 'Y'
				--AND B.TRANSPORT_MODE = 'SEA'
--				AND B.TRANSPORT_MODE = CASE WHEN B.FROM_SITE IN ('G382-A','G382-P') THEN 'TRK' ELSE 'SEA' END
				AND B.TRANSPORT_MODE = CASE WHEN B.FROM_SITE IN (select CODE from dbo.FN_LIST_LOOKUP_VALUE('SSP0021_GET_SHIPMENT_PLAN'  ,'G382_Transport')) THEN 'TRK' ELSE 'SEA' END
			WHERE 1 = 1
			AND A.MEASURE = 'SHIP_PLAN'
			GROUP BY A.DIVISION_ID, A.FROM_SITE, A.ITEM_ID, A.YYYYMMDD, A.CONFIRM_DAY, B.LOT_SIZE
			*/
		) T0
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
			FROM #Tmp_Result_Table WITH(NOLOCK)
			GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, CONFIRM_DAY
		)
		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID,		FROM_SITE,		ITEM_ID,		MEASURE,		SEQ,		CONFIRM_DAY,		YYYYMMDD,		QTY
		)
		SELECT 
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.ITEM_ID 
			, 'WH_STOCK' AS MEASURE
			, 8 AS SEQ
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
				FROM #Tmp_Result_Table tt0 WITH(NOLOCK)
				WHERE 1 = 1
				AND tt0.DIVISION_ID = T0.DIVISION_ID
				AND tt0.FROM_SITE = T0.FROM_SITE
				AND tt0.ITEM_ID = T0.ITEM_ID
				AND tt0.MEASURE IN ('SHIP_PLAN', 'PROD_PLAN', 'INTN_MOVEMENT')
				AND tt0.YYYYMMDD < T0.YYYYMMDD
				) 
/* -- 포장창고 다음날 재고 반영 로직 (향후 의사결정이후 반영여부 결정)-- cutoff 생성시 해당 로직 반영 필요 ( PR_SSP_ANL_SHIP_PLAN_CUTOFF 프로시져) -- 20190924
				+ (
					SELECT 
						ISNULL(SUM(BOH_QTY), 0)
					FROM #Tmp_BOHData_STORAGE
					WHERE 1 = 1
					AND BOH_TYPE = 'ERP' AND STORAGE_ID IN ('310T')			--//ERP의 특정STORAGE_ID는 시작일 뒷날부터 더해진다.
					AND DIVISION_ID = T0.DIVISION_ID
					AND FROM_SITE = T0.FROM_SITE
					AND ITEM_ID = T0.ITEM_ID
					AND CONVERT(CHAR(8), DATEADD(DD, +1, CONVERT(VARCHAR, YYYYMMDD, 121)), 112) < T0.YYYYMMDD
				)
*/
				+ ISNULL(T1.BOH_QTY, 0)
--20191010 : RNR 확정 후 수정
/*				+ (
					SELECT 
						-1 * ISNULL(SUM(HOLD_QTY), 0) 
					FROM SSP_ANL_HOLD_STOCK
					WHERE 1 = 1
					AND DIVISION_ID = T0.DIVISION_ID
					AND FROM_SITE = T0.FROM_SITE
					AND ITEM_ID= T0.ITEM_ID
					AND T0.YYYYMMDD BETWEEN HOLD_YYYYMMDD AND RELEASE_YYYYMMDD
					AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					)
*/
				 AS QTY
		FROM Deduplication T0 WITH(NOLOCK)
		LEFT OUTER JOIN WH_STOCK T1 WITH(NOLOCK)
			ON T0.DIVISION_ID = T1.DIVISION_ID	AND T0.FROM_SITE = T1.FROM_SITE
			AND T0.ITEM_ID = T1.ITEM_ID			--AND T0.YYYYMMDD = T1.YYYYMMDD 
		WHERE 1 = 1
		-- START [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP PROD 자동생성 항목 제외
		AND NOT EXISTS ( 
			SELECT 1 
			FROM  SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
			WHERE L.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
			AND L.VALID_YN = 'Y'
			AND L.SEGMENT1 = T0.DIVISION_ID
			AND L.SEGMENT2 = T0.FROM_SITE
			AND L.SEGMENT4 = T0.ITEM_ID
		)
		-- END [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP PROD 자동생성 항목 제외
		ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD
		;

		--//4-2. BALANCE DATA INSERT
		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID,		FROM_SITE,		ITEM_ID,		MEASURE,		SEQ,		CONFIRM_DAY,			YYYYMMDD,		QTY
		)
		SELECT
			DIVISION_ID,		
			FROM_SITE,		
			ITEM_ID,		
			'BALANCE' AS MEASURE,		
			9 AS SEQ,
			CONFIRM_DAY,
			YYYYMMDD,
			ISNULL(
				SUM(
					CASE	WHEN MEASURE = 'SHIP_PLAN' THEN -1 * ISNULL(QTY, 0)
							WHEN MEASURE = 'WH_STOCK' THEN ISNULL(QTY, 0)
					ELSE 0 END
				), 0) AS QTY
		FROM #Tmp_Result_Table B WITH(NOLOCK)
		WHERE 1 = 1
		AND MEASURE IN ('SHIP_PLAN', 'WH_STOCK')
		-- START [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP PROD 자동생성 항목 제외
		AND NOT EXISTS ( 
			SELECT 1 
			FROM  SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
			WHERE L.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
			AND L.VALID_YN = 'Y'
			AND L.SEGMENT1 = B.DIVISION_ID
			AND L.SEGMENT2 = B.FROM_SITE
			AND L.SEGMENT4 = B.ITEM_ID
		)
		-- END [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP PROD 자동생성 항목 제외
		GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, CONFIRM_DAY;

		--select * from #Tmp_Result_Table where measure in ('SHIP_PLAN', 'CONTAINER') ORDER BY YYYYMMDD, measure;
		--//END WH_STOCK, BALANCE 생성///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

		--//4-3. SHIP AVALIABLE GAP DATA INSERT		
					
		--WITH WH_STOCK AS
		--(
		--	SELECT
		--		DIVISION_ID
		--		, FROM_SITE
		--		, ITEM_ID
		--		, CONVERT(CHAR(8), DATEADD(DD, +1, CONVERT(VARCHAR, YYYYMMDD, 121)), 112) AS YYYYMMDD
		--		, BOH_QTY AS BOH_QTY
		--	FROM #Tmp_BOHData WITH(NOLOCK)
		--	WHERE 1 = 1
		--	AND BOH_TYPE = 'BOH'
		--	AND YYYYMMDD = @v_boh_yyyymmdd
		--),
		WITH Deduplication2 AS
		(
			SELECT
				DIVISION_ID
				, FROM_SITE
				, ITEM_ID
				, YYYYMMDD
				, CONFIRM_DAY
			FROM #Tmp_Result_Table WITH(NOLOCK)
			GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, CONFIRM_DAY
		)
		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID,		FROM_SITE,		ITEM_ID,		MEASURE,		SEQ,		CONFIRM_DAY,		YYYYMMDD,		QTY
		)
		SELECT 
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.ITEM_ID 
			, 'SHIP_AVAL_GAP' AS MEASURE
			, 4 AS SEQ
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
				AND tt0.YYYYMMDD <= T0.YYYYMMDD
				) 
				--+ ISNULL(T1.BOH_QTY, 0)
				 AS QTY
		FROM Deduplication2 T0 WITH(NOLOCK)
		--LEFT OUTER JOIN WH_STOCK T1 WITH(NOLOCK)
		--	ON T0.DIVISION_ID = T1.DIVISION_ID	AND T0.FROM_SITE = T1.FROM_SITE
		--	AND T0.ITEM_ID = T1.ITEM_ID			--AND T0.YYYYMMDD = T1.YYYYMMDD 
		WHERE 1 = 1
		-- START [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP PROD 자동생성 항목 제외
		AND NOT EXISTS ( 
			SELECT 1 
			FROM  SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
			WHERE L.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
			AND L.VALID_YN = 'Y'
			AND L.SEGMENT1 = T0.DIVISION_ID
			AND L.SEGMENT2 = T0.FROM_SITE
			AND L.SEGMENT4 = T0.ITEM_ID
		)
		-- END [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP PROD 자동생성 항목 제외
		ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD
		;

		-- START [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP AUTO 항목 데이터 등록
		-------------------------------------------------------------------------------------------------------------------
				
		--CURSOR 선언 
		DECLARE @DIVISION_ID  				nvarchar(030)
				,@ITEM_ID					nvarchar(050)
				,@FROM_SITE					nvarchar(030)
				,@MEASURE					nvarchar(050)
				,@YYYYMMDD					nvarchar(008)
				,@QTY						numeric(20,10)
				,@CF_QTY					numeric(20,10)
				,@PP_QTY					numeric(20,10)
				,@MV_QTY					numeric(20,10)
				,@LOT_SIZE					INT
				,@RATE						INT
				,@CONFIRM_DAY				nvarchar(008)
				;
		DECLARE @idx INT = 0;
		DECLARE @tmpBALANCE INT;
		DECLARE @tmpWH_STOCK INT;
		DECLARE @tmpCFM_QTY INT;
		DECLARE @tmpSP_QTY INT;
		DECLARE @tmpFP_QTY INT;

		DECLARE CUR_PLAN_P CURSOR FOR  

			SELECT SP.DIVISION_ID
				 , SP.FROM_SITE
				 , SP.ITEM_ID
				 , SP.YYYYMMDD
				 , ISNULL(SP.QTY, 0)     AS CF_QTY -- CONFIRM QTY
				 , ISNULL(PP.QTY, 0)     AS PP_QTY -- PRDN PLAN QTY
				 , ISNULL(MV.QTY, 0)	 AS MV_QTY -- INTN_MOVEMENT QTY
				 , ISNULL(L.LOT_SIZE, 0) AS LOT_SIZE
				 , T.ATTRIBUTE1 AS RATE 
				 , SP.CONFIRM_DAY
			FROM #Tmp_Result_Table SP -- CONFIRM
			LEFT OUTER JOIN #Tmp_Result_Table PP -- PROD PLAN
			ON SP.DIVISION_ID  = PP.DIVISION_ID
			AND SP.ITEM_ID	   = PP.ITEM_ID
			AND SP.FROM_SITE   = PP.FROM_SITE
			AND SP.YYYYMMDD	   = PP.YYYYMMDD
			AND PP.MEASURE	   = 'PROD_PLAN'

			LEFT OUTER JOIN #Tmp_Result_Table MV -- INTN_MOVEMENT
			ON SP.DIVISION_ID  = MV.DIVISION_ID
			AND SP.ITEM_ID	   = MV.ITEM_ID
			AND SP.FROM_SITE   = MV.FROM_SITE
			AND SP.YYYYMMDD	   = MV.YYYYMMDD
			AND PP.MEASURE	   = 'INTN_MOVEMENT'
			

			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T WITH(NOLOCK)  -- FP 자동생성 대상
			ON T.LOOKUP_TYPE  = 'FP_AUTO_SHIP_FROM_TO'
			AND T.VALID_YN	  = 'Y'
			AND T.SEGMENT1    = SP.DIVISION_ID
			AND T.SEGMENT2    = SP.FROM_SITE
			AND T.SEGMENT4    = SP.ITEM_ID  

			LEFT OUTER JOIN SCP_MST_BOD_N_V  B WITH(NOLOCK) 
			ON  B.DIVISION_ID = T.SEGMENT1 --DIVISION_ID
			AND B.BOD_ID      = T.SEGMENT5 --BOD_ID

			LEFT OUTER JOIN SCP_MST_SHIPMENT_LOT_SIZE L WITH(NOLOCK)
			ON L.DIVISION_ID     = SP.DIVISION_ID 
			AND L.FROM_SITE      = SP.FROM_SITE
			AND L.TO_SITE        = T.SEGMENT3 --TO_SITE
			AND L.ITEM_ID        = SP.ITEM_ID   
			AND L.TRANSPORT_MODE = B.TRANSPORT_MODE
			AND L.VALID_YN       = 'Y'
			WHERE SP.MEASURE = 'SHIP_PLAN'

			ORDER BY SP.DIVISION_ID
				,SP.FROM_SITE
				,SP.ITEM_ID
				,SP.YYYYMMDD;

		OPEN CUR_PLAN_P; 

		FETCH NEXT FROM CUR_PLAN_P INTO @DIVISION_ID  				
										,@FROM_SITE					
										,@ITEM_ID		
										,@YYYYMMDD					
										,@CF_QTY
										,@PP_QTY
										,@MV_QTY
										,@LOT_SIZE
										,@RATE
										,@CONFIRM_DAY
										;

		WHILE(@@FETCH_STATUS = 0) 
																																																																																																																																																												BEGIN; 
		--Idx 1씩 증가 
		SET @idx = @idx + 1 
		SET @tmpCFM_QTY = 0;
		SET @tmpBALANCE = 0;
		SET @tmpWH_STOCK = 0;
		SET @tmpSP_QTY = 0;
		SET @tmpFP_QTY = 0;

		-- 전일자 재고 조회
		IF @v_from_yyyymmdd = @YYYYMMDD
			BEGIN

			SELECT @tmpWH_STOCK = ISNULL(BOH_QTY, 0)
			FROM #Tmp_BOHData WITH(NOLOCK)
			WHERE 1 = 1
			AND BOH_TYPE = 'BOH'
			AND YYYYMMDD = @v_boh_yyyymmdd
			AND DIVISION_ID	= @DIVISION_ID		
			AND FROM_SITE	= @FROM_SITE
			AND ITEM_ID		= @ITEM_ID
			;
			END
		ELSE 
			BEGIN
				SELECT @tmpWH_STOCK = ISNULL(SUM(QTY), 0)
				FROM #Tmp_Result_Table C WITH(NOLOCK) 
				WHERE C.DIVISION_ID = @DIVISION_ID
				AND C.YYYYMMDD		= CONVERT(VARCHAR(8), CONVERT(DATETIME, @YYYYMMDD)-1, 112)		
				AND C.ITEM_ID		= @ITEM_ID
				AND C.FROM_SITE		= @FROM_SITE
				AND C.MEASURE		= 'WH_STOCK'
			END
			
			SELECT @tmpSP_QTY = CASE WHEN CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, @DIVISION_ID, @FROM_SITE, @p_plan_start_yyyymmdd)-1 , CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)) ,112) >= @YYYYMMDD THEN IIF(@CF_QTY <> 0, @CF_QTY, 0) -- 컴펌
								--전일자재고 + (FP생산수량 * 재고비율) / LOT SIZE
								WHEN ISNULL(@LOT_SIZE, 0) = 0 THEN CONVERT(INT,(@tmpWH_STOCK+(@PP_QTY*((100-@RATE)/100.0)))) -- LOT SIZE가 없는경우 전부 계획으로 잡는다.
								WHEN CONVERT(INT,(@tmpWH_STOCK+(@PP_QTY*((100-@RATE)/100.0)))/@LOT_SIZE)*@LOT_SIZE < @LOT_SIZE THEN 0 -- LOT SIZE보다 작은경우
								ELSE CONVERT(INT,(@tmpWH_STOCK+(@PP_QTY*((100-@RATE)/100.0)))/@LOT_SIZE)*@LOT_SIZE
							END
					, @tmpFP_QTY = ISNULL(@PP_QTY, 0)
					--, @tmpBALANCE = CASE WHEN ISNULL(C.CONFIRM_ID, '-') != '-' THEN ISNULL(PP.QTY, 0) - ISNULL(C.QTY, 0) 
					--				  WHEN ISNULL(PP.QTY, 0) < ISNULL(@LOT_SIZE, 0) THEN ISNULL(PP.QTY, 0)
					--				  ELSE ISNULL(PP.QTY, 0) % ISNULL(@LOT_SIZE, 1)
					--			 END
					, @tmpCFM_QTY = IIF(ISNULL(@CF_QTY, 0) <> 0, @CF_QTY, 0) --컴펌 수량

			UPDATE C
				SET C.QTY = @tmpSP_QTY
				FROM #Tmp_Result_Table C WITH(NOLOCK)
				WHERE C.DIVISION_ID  	 = @DIVISION_ID  				
				AND C.ITEM_ID			 = @ITEM_ID					
				AND C.FROM_SITE			 = @FROM_SITE									
				AND C.YYYYMMDD			 = @YYYYMMDD					
				AND C.MEASURE			 = 'SHIP_PLAN'

			--WH_STOCK 등록
			MERGE INTO #Tmp_Result_Table C
			USING (
					SELECT @DIVISION_ID			  AS DIVISION_ID
							,@ITEM_ID             AS ITEM_ID
							,@FROM_SITE			  AS FROM_SITE
							,'WH_STOCK'			  AS MEASURE
							,@YYYYMMDD			  AS YYYYMMDD
							,@tmpWH_STOCK +	@tmpFP_QTY - IIF(@tmpCFM_QTY <> 0, @tmpCFM_QTY, @tmpSP_QTY) - @MV_QTY
													AS QTY				   
					) N
					ON C.DIVISION_ID	= N.DIVISION_ID
				AND C.ITEM_ID		= N.ITEM_ID
				AND C.FROM_SITE		= N.FROM_SITE
				AND C.MEASURE		= N.MEASURE
				AND C.YYYYMMDD		= N.YYYYMMDD
			WHEN MATCHED THEN
			UPDATE 
			SET QTY = C.QTY - @tmpCFM_QTY

			WHEN NOT MATCHED THEN
			INSERT 
			(
				DIVISION_ID
				,ITEM_ID	         
				,FROM_SITE	         
				,MEASURE	         
				,YYYYMMDD	     
				,SEQ
				,QTY	
				,CONFIRM_DAY
				)
			VALUES (   
				N.DIVISION_ID
   
				,N.ITEM_ID            
				,N.FROM_SITE    
				,'WH_STOCK' -- MEASURE
				,N.YYYYMMDD  
				,8
				,N.QTY		-- QTY	
				,@CONFIRM_DAY
			);
				
				
----			-- BALANCE 당일 등록
----			--MERGE INTO #tmp_SSP_ANL_SHIP_PLAN_C C
----			--USING
----			--(
----			--	SELECT @DIVISION_ID  	AS DIVISION_ID			
----			--		, @COMPANY_ID       AS COMPANY_ID         
----			--		, @PLAN_START_YYYYMMDD	AS PLAN_START_YYYYMMDD
----			--		, @ITEM_ID			AS ITEM_ID
----			--		, @FROM_SITE		AS FROM_SITE
----			--		, '-'				AS TO_SITE
----			--		, @YYYYMMDD			AS YYYYMMDD
----			--		, '-'				AS BOD_ID
----			--		, '-'				AS INCOTERMS	
----			--		, '-'				AS TRANSPORT_MODE
----			--		, '-'				AS PROJECT_CODE	
----			--		, '-'				AS FCST_TYPE	
----			--		, 'BALANCE'			AS MEASURE
----			--) N
----			-- ON C.DIVISION_ID  			= N.DIVISION_ID  				
----			--AND C.COMPANY_ID			= N.COMPANY_ID                
----			--AND C.PLAN_START_YYYYMMDD	= N.PLAN_START_YYYYMMDD		
----			--AND C.ITEM_ID				= N.ITEM_ID					
----			--AND C.FROM_SITE				= N.FROM_SITE					
----			--AND C.TO_SITE				= N.TO_SITE					
----			--AND C.MEASURE				= N.MEASURE					
----			--AND C.YYYYMMDD				= N.YYYYMMDD					
----			--AND C.BOD_ID				= N.BOD_ID
----			--AND C.INCOTERMS				= N.INCOTERMS					
----			--AND C.TRANSPORT_MODE		= N.TRANSPORT_MODE	
----			--AND C.PROJECT_CODE			= N.PROJECT_CODE				
----			--AND C.FCST_TYPE				= N.FCST_TYPE		
----			--AND C.MEASURE				= N.MEASURE

----			--WHEN MATCHED THEN
----			--	UPDATE SET QTY = QTY - @tmpCFM_QTY
----			--WHEN NOT MATCHED THEN
----			--	INSERT 
----			--	(
----			--		  DIVISION_ID  
----			--		, COMPANY_ID		     
----			--		, PLAN_START_YYYYMMDD 
----			--		, ITEM_ID	         
----			--		, FROM_SITE	         
----			--		, TO_SITE	         
----			--		, MEASURE	         
----			--		, YYYYMMDD	         
----			--		, BOD_ID	           
----			--		, QTY	             
----			--		, INCOTERMS         
----			--		, TRANSPORT_MODE    
----			--		, PROJECT_CODE	     
----			--		, FCST_TYPE	
----			--		, CONFIRM_ID      
----			--	) VALUES (
----			--		  N.DIVISION_ID 
----			--		, N.COMPANY_ID
----			--		, N.PLAN_START_YYYYMMDD 
----			--		, N.ITEM_ID	         
----			--		, N.FROM_SITE	         
----			--		, N.TO_SITE	         
----			--		, N.MEASURE  -- BALANCE	         
----			--		, N.YYYYMMDD	         
----			--		, N.BOD_ID	           	   
----			--		, @tmpBALANCE -- QTY
----			--		, N.INCOTERMS         
----			--		, N.TRANSPORT_MODE    
----			--		, N.PROJECT_CODE	     
----			--		, N.FCST_TYPE	
----			--		, '-' -- CONFIRM_ID 
----			--	)
----			--	;

			FETCH NEXT FROM CUR_PLAN_P INTO @DIVISION_ID  				
										,@FROM_SITE					
										,@ITEM_ID		
										,@YYYYMMDD					
										,@CF_QTY
										,@PP_QTY
										,@MV_QTY
										,@LOT_SIZE
										,@RATE
										,@CONFIRM_DAY
										;
	
			END; 

			CLOSE CUR_PLAN_P; 
			DEALLOCATE CUR_PLAN_P;

				
		--////////////////////////////////////////////////////////////////////////////////--
		--//4-4. CONTAINER																//--
		--////////////////////////////////////////////////////////////////////////////////--
		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID,		FROM_SITE,		ITEM_ID,		MEASURE,		SEQ,		CONFIRM_DAY,		YYYYMMDD,		QTY,		LOT_YN
		)
		SELECT
			T0.DIVISION_ID,		T0.FROM_SITE,	T0.ITEM_ID,		T0.MEASURE,		T0.SEQ,		T0.CONFIRM_DAY,		T0.YYYYMMDD,	T0.QTY,		T0.LOT_YN
		FROM
		(
			SELECT
				A.DIVISION_ID,		
				A.FROM_SITE,		
				A.ITEM_ID,		
				'CONTAINER' AS MEASURE,		
				6 AS SEQ,
				A.CONFIRM_DAY,
				A.YYYYMMDD,
				CASE WHEN ISNULL(MAX(B.LOT_SIZE), 0) = 0 THEN 0 ELSE CEILING(MAX(ISNULL(A.QTY, 0)) /ISNULL(MAX(B.LOT_SIZE), 0)) END AS QTY,
				CASE WHEN B.LOT_SIZE IS NULL THEN 'N' ELSE 'Y' END AS LOT_YN
			FROM #Tmp_Result_Table A WITH(NOLOCK)
			LEFT OUTER JOIN scp_mst_shipment_lot_size B WITH(NOLOCK)
				ON B.DIVISION_ID = @p_division_id
				AND B.ITEM_ID = A.ITEM_ID
				AND B.FROM_SITE = A.FROM_SITE
				AND B.VALID_YN = 'Y'
				--AND B.TRANSPORT_MODE = 'SEA'
--				AND B.TRANSPORT_MODE = CASE WHEN B.FROM_SITE IN ('G382-A','G382-P') THEN 'TRK' ELSE 'SEA' END
				AND B.TRANSPORT_MODE = CASE WHEN B.FROM_SITE IN (select CODE from dbo.FN_LIST_LOOKUP_VALUE('SSP0021_GET_SHIPMENT_PLAN'  ,'G382_Transport')) THEN 'TRK' ELSE 'SEA' END
			WHERE 1 = 1
			AND A.MEASURE = 'SHIP_PLAN'
			GROUP BY A.DIVISION_ID, A.FROM_SITE, A.ITEM_ID, A.YYYYMMDD, A.CONFIRM_DAY, B.LOT_SIZE
		) T0
		;

		-- END [E20260629-000020] SSP 출하 계획 변경 FP 생산기반 수행시 발생, 조회 UI 수정 - FP AUTO 항목 데이터 등록

		--////////////////////////////////////////////////////////////////////////////////--
		--//5. PIVOT				 													//--
		--////////////////////////////////////////////////////////////////////////////////--
		SELECT
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.ITEM_ID
			, T0.MEASURE
			, T0.SEQ
			, T0.CONFIRM_DAY
			, 'D_' + T0.YYYYMMDD AS YYYYMMDD
			, T1.basis_yyyymm AS yyyymm
			, RIGHT(T1.basis_yyyymm,4) + T1.iso_week AS iso_week
			, T0.QTY
			, T0.LOT_YN
		INTO #Tmp_Result_PIVOT_Table
		FROM #Tmp_Result_Table T0 WITH(NOLOCK)
		INNER JOIN scm_sys_calendar_m T1 
		ON T0.yyyymmdd = T1.basis_yyyymmdd
		;
		/*PIVOIT처리*******************************************************************************/
		BEGIN
		
			-- PIVOIT 대상 날짜문자열 생성
			SET @mQry_sum = '';
			
			SELECT  @mQry_sum = @mQry_sum+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN CONVERT(numeric(20, 10), ISNULL(T0.QTY, 0))  END ) AS ' + yyyymmdd
													WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.iso_week = RIGHT('''+yyyymmdd+''',6) THEN CONVERT(numeric(20, 10),ISNULL(T0.QTY, 0))  END ) AS ' + yyyymmdd
													WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.yyyymmdd = '''+yyyymmdd+''' THEN CONVERT(numeric(20, 10),ISNULL(T0.QTY, 0)) END ) AS ' + yyyymmdd
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
		SET @mEXEC = @mEXEC+'       	, isnull(dbo.fn_get_scm_site_description(T0.DIVISION_ID, T0.FROM_SITE ),''-'') AS from_site_description ' + CHAR(10)
		SET @mEXEC = @mEXEC+'       	, T0.ITEM_ID																										' + CHAR(10);
		SET @mEXEC = @mEXEC+'			, (SELECT TOP 1 isnull(NULLIF(NICK_NAME,''''),''-'') FROM DBO.SCM_MST_ITEM_SN x WITH(NOLOCK) WHERE 1=1 AND x.ITEM_ID = T0.item_id) as nick_name            ' + char(10) ;
		SET @mEXEC = @mEXEC+'			, CASE WHEN T1.BOH_TYPE IS NULL THEN																				' + CHAR(10);
		SET @mEXEC = @mEXEC+'				CASE T0.SEQ WHEN 5 THEN ''BOH''																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'							WHEN 6 THEN ''ERP''																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'							WHEN 7 THEN ''oWMS''																				' + CHAR(10);
		SET @mEXEC = @mEXEC+'							WHEN 8 THEN ''MES''																					' + CHAR(10);
		--SET @mEXEC = @mEXEC+'							WHEN 7 THEN ''HOLD''																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'				ELSE NULL END																									' + CHAR(10);
		SET @mEXEC = @mEXEC+'			  ELSE T1.BOH_TYPE END AS BOH_TYPE																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'			, CASE WHEN (T0.SEQ = 1 OR T0.SEQ = 2 OR T0.SEQ = 3  OR T0.SEQ = 4 OR T0.SEQ = 9) THEN NULL																	' + CHAR(10);
		--SET @mEXEC = @mEXEC+'			, CASE WHEN T0.SEQ = 1 THEN NULL																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'			  ELSE ISNULL(T1.BOH_QTY, 0) END AS BOH_QTY																			' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, CASE T0.MEASURE	WHEN ''SHIP_REQ'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''SHIP_PLAN'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''SHIP_AVAL'' THEN ''S''																	' + CHAR(10); --NEW jilee
		SET @mEXEC = @mEXEC+'       						WHEN ''SHIP_AVAL_GAP'' THEN ''S''																' + CHAR(10); --NEW jilee
		SET @mEXEC = @mEXEC+'       						WHEN ''INTN_MOVEMENT'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''CONTAINER'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''PROD_PLAN'' THEN ''P''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''WH_STOCK'' THEN ''I''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       						WHEN ''BALANCE'' THEN ''I''	END PSI																' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T0.MEASURE																										' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T2.COLUMN_LABEL_NAME AS MEASURE_NAME																				' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, T0.SEQ																											' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, CONVERT(CHAR(8), DATEADD(DD, isnull(T0.CONFIRM_DAY,0), CONVERT(VARCHAR, '''+ @p_from_yyyymmdd + ''', 121)), 112) AS CONFIRM_DAY ' + CHAR(10);
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
		SET @mEXEC = @mEXEC+'		AND T2.PROGRAM_ID = ''' + @p_program_id + '''                                                                                                                                   ' + char(10) ;
		SET @mEXEC = @mEXEC+'		AND T2.SHEET_NAME = ''' + @p_sheet_name + '''                                                                                                                       ' + char(10) ;
		SET @mEXEC = @mEXEC+'		AND T2.VALID_YN = ''Y''                                                                                                                                           ' + char(10) ;
		SET @mEXEC = @mEXEC+' 		AND ('+convert(varchar,@v_cnt_usr_measure)+' = 0                                      ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 						OR EXISTS (SELECT 1                                    ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 									 FROM #TblDynamicTitlest_SSP0021			   ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 									 WHERE COLUMN_NAME = T2.COLUMN_NAME)         ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 				                  )                                            ' + char(10) ; 	
		SET @mEXEC = @mEXEC+' 			  AND ( ( '+convert(varchar,@v_cnt_usr_measure)+' = 0 AND T2.DEFAULT_FLAG=''Y'' )                                      ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 						OR  ('+convert(varchar,@v_cnt_usr_measure)+' != 0 )       ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 				                  )                                            ' + char(10) ; 	
		SET @mEXEC = @mEXEC+'	AND T2.COLUMN_NAME = T0.MEASURE																																	  ' + char(10) ;
		SET @mEXEC = @mEXEC+'		GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T1.BOH_TYPE, T1.BOH_QTY, T0.MEASURE, T2.COLUMN_LABEL_NAME, T0.SEQ, T0.CONFIRM_DAY, T2.ATTRIBUTE3, T0.LOT_YN	' + CHAR(10);
		SET @mEXEC = @mEXEC+'		ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.SEQ, T0.MEASURE													' + CHAR(10);
	
		--SELECT @mEXEC;
		EXEC(@mEXEC);
		--//END RESULT///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
	END
	ELSE
	BEGIN
		/*PIVOIT처리*******************************************************************************/
		BEGIN
			-- PIVOIT 대상 날짜문자열 생성
			SET @mQry_sum = '';
			
			SELECT  @mQry_sum = @mQry_sum+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN T0.QTY  END ) AS ' + yyyymmdd
													WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.iso_week = RIGHT('''+yyyymmdd+''',6) THEN T0.QTY  END ) AS ' + yyyymmdd
													WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.yyyymmdd = '''+yyyymmdd+''' THEN T0.QTY END ) AS ' + yyyymmdd
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
			, T0.ITEM_ID
			, T0.MEASURE
			, T0.YYYYMMDD
			, T0.yyyymm
			, T0.iso_week
			, isnull(T0.QTY, 0) AS QTY
			, T0.LOT_YN
			--, T0.SEQ
		INTO #Tmp_Result_PIVOT_Table_Old
		FROM
		(
			SELECT
				T0.DIVISION_ID
				, T0.FROM_SITE
				-- jilee 230901
				,ISNULL(IM.APPLIED_MODEL, T0.ITEM_ID) AS ITEM_ID
				--, T0.ITEM_ID
				, T0.MEASURE
				, sum(convert(int, T0.QTY)) AS QTY
				--, CASE WHEN T2.LOT_SIZE IS NULL THEN 'N' ELSE 'Y' END AS LOT_YN
				, NULL AS LOT_YN
				, 'D_' + T0.YYYYMMDD AS YYYYMMDD
				, T1.basis_yyyymm AS yyyymm
				, RIGHT(T1.basis_yyyymm,4) + T1.iso_week AS iso_week
			FROM SSP_ANL_SHIP_PLAN_C T0 WITH(NOLOCK)
			INNER JOIN scm_sys_calendar_m T1 WITH(NOLOCK)
				ON T0.yyyymmdd = T1.basis_yyyymmdd
			/* 2020-03-23 modify by KIMYONGHO 
			과거 PLAN 조회 시 필요없음 */
			--LEFT OUTER JOIN scp_mst_shipment_lot_size T2 WITH(NOLOCK)
			--	ON T2.DIVISION_ID = @p_division_id
			--	AND T2.ITEM_ID = T0.ITEM_ID
			--	AND T2.FROM_SITE = T0.FROM_SITE
			--	AND T2.VALID_YN = 'Y'
			--	--AND T2.TRANSPORT_MODE = 'SEA'
			--	AND T2.TRANSPORT_MODE = CASE WHEN T2.FROM_SITE IN ('G382-A','G382-P') THEN 'TRK' ELSE 'SEA' END
			-- jilee 230901
			JOIN SCM_MST_SITE S WITH(NOLOCK) 
			ON S.DIVISION_ID = T0.DIVISION_ID 
			AND S.SCM_SITE_ID = T0.FROM_SITE 			
			LEFT OUTER JOIN SCM_MST_ITEM_SN IM WITH(NOLOCK) 
			ON   IM.DIVISION_ID = T0.DIVISION_ID							   
			AND  IM.COMPANY_ID = @p_company_id
			AND  IM.SITE_ID = S.SITE_ID
			AND  IM.ITEM_ID = T0.ITEM_ID
			AND  IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')	
			WHERE 1= 1
			AND T0.DIVISION_ID = @p_division_id
			AND T0.COMPANY_ID = @p_company_id
			AND T0.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND T0.yyyymmdd >= @p_from_yyyymmdd
			AND T0.yyyymmdd <= @p_to_yyyymmdd
			AND ((@p_from_site IS NULL OR @p_from_site ='') OR T0.FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site    ,',')))
			AND ((@p_item_id IS NULL OR @p_item_id ='')	OR T0.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')))
			-- jilee 230901
			GROUP BY T0.DIVISION_ID, T0.FROM_SITE, IM.APPLIED_MODEL, T0.ITEM_ID, T0.MEASURE, T0.YYYYMMDD, T1.basis_yyyymm, T1.iso_week--, T2.LOT_SIZE
			
			UNION ALL

			SELECT
				 T0.DIVISION_ID
				, T0.FROM_SITE_ID AS FROM_SITE
				, T0.MODEL_ID     AS ITEM_ID				
				, 'SHIP_AVAL' AS MEASURE
				, T0.out_qty AS QTY
				, NULL AS LOT_YN
				, 'D_' + CONVERT(NVARCHAR(8), T0.plan_date, 112) AS YYYYMMDD
				, T1.basis_yyyymm AS yyyymm
				, RIGHT(T1.basis_yyyymm,4) + T1.iso_week AS iso_week				
			FROM [dbo].SSP_DNM_FP_AMEND_SHIPAVAL T0 WITH(NOLOCK)
			INNER JOIN [dbo].scm_sys_calendar_m T1 WITH(NOLOCK)
				ON T0.PLAN_DATE = T1.basis_yyyymmdd
			WHERE 1 = 1
			--AND T0.operation_id IN ('P5500', 'P9500', 'F5300', 'F5500', 'F5600', 'F6000')
			AND T0.out_qty >= 0 
			--AND T0.plan_in_qty > 0 
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

			/*
			UNION
			SELECT
				T0.DIVISION_ID
				, T0.FROM_SITE
				, T0.ITEM_ID
				, 'CONTAINER' AS MEASURE
				, CASE WHEN ISNULL(MAX(T2.LOT_SIZE), 0) = 0 THEN 0 ELSE CEILING(SUM(ISNULL(T0.QTY, 0)) /ISNULL(MAX(T2.LOT_SIZE), 0)) END AS QTY
				, CASE WHEN T2.LOT_SIZE IS NULL THEN 'N' ELSE 'Y' END AS LOT_YN
				, 'D_' + T0.YYYYMMDD AS YYYYMMDD
				, T1.basis_yyyymm AS yyyymm
				, RIGHT(T1.basis_yyyymm,4) + T1.iso_week AS iso_week
			FROM SSP_ANL_SHIP_PLAN_C T0
			INNER JOIN scm_sys_calendar_m T1
				ON T0.yyyymmdd = T1.basis_yyyymmdd
			LEFT OUTER JOIN scp_mst_shipment_lot_size T2 WITH(NOLOCK)
				ON T2.DIVISION_ID = @p_division_id
				AND T2.ITEM_ID = T0.ITEM_ID
				AND T2.FROM_SITE = T0.FROM_SITE
				AND T2.VALID_YN = 'Y'
				AND T2.TRANSPORT_MODE = 'SEA'
			WHERE 1= 1
			AND T0.MEASURE = 'SHIP_PLAN'
			AND T0.DIVISION_ID = @p_division_id
			AND T0.COMPANY_ID = @p_company_id
			AND T0.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND T0.yyyymmdd >= @p_from_yyyymmdd
			AND T0.yyyymmdd <= @p_to_yyyymmdd
			AND ((@p_from_site IS NULL OR @p_from_site ='') OR T0.FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site    ,',')))
			AND ((@p_item_id IS NULL OR @p_item_id ='')	OR T0.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')))
			GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.MEASURE, T0.YYYYMMDD, T1.basis_yyyymm, T1.iso_week , T2.LOT_SIZE*/
		) T0

		SET @mEXEC = '';
		SET @mEXEC = @mEXEC + '	SELECT																													' + CHAR(10);
		SET @mEXEC = @mEXEC + '		T0.DIVISION_ID																											' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T0.FROM_SITE																											' + CHAR(10);
		SET @mEXEC = @mEXEC+'       	, isnull(dbo.fn_get_scm_site_description(T0.DIVISION_ID, T0.FROM_SITE ),''-'') AS from_site_description ' + CHAR(10)
		
		SET @mEXEC = @mEXEC+'			, (SELECT TOP 1 isnull(NULLIF(NICK_NAME,''''),''-'') FROM DBO.SCM_MST_ITEM_SN x WITH(NOLOCK) WHERE 1=1 AND x.ITEM_ID = T0.item_id) as nick_name            ' + char(10) ;
		SET @mEXEC = @mEXEC + '		, T0.ITEM_ID																											' + CHAR(10);
		SET @mEXEC = @mEXEC+'		, CASE WHEN T2.BOH_TYPE IS NULL THEN																				' + CHAR(10);
		SET @mEXEC = @mEXEC+'			CASE T1.SORT_ORDER_NO	WHEN 5 THEN ''BOH''																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'									WHEN 6 THEN ''ERP''																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'									WHEN 7 THEN ''oWMS''																				' + CHAR(10);
		SET @mEXEC = @mEXEC+'									WHEN 8 THEN ''MES''																					' + CHAR(10);
		--SET @mEXEC = @mEXEC+'									WHEN 7 THEN ''HOLD''																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'			ELSE NULL END																									' + CHAR(10);
		SET @mEXEC = @mEXEC+'		  ELSE T2.BOH_TYPE END AS BOH_TYPE																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'		, CASE WHEN (T1.SORT_ORDER_NO = 1 OR T1.SORT_ORDER_NO = 2 OR T1.SORT_ORDER_NO = 3 OR T1.SORT_ORDER_NO = 4 OR T1.SORT_ORDER_NO = 9) THEN NULL																					' + CHAR(10);
		--SET @mEXEC = @mEXEC+'		, CASE WHEN T1.SORT_ORDER_NO = 1 THEN NULL																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'		  ELSE ISNULL(T2.BOH_QTY, 0) END AS BOH_QTY																			' + CHAR(10);
		SET @mEXEC = @mEXEC+'       , CASE T0.MEASURE	WHEN ''SHIP_REQ'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       					WHEN ''SHIP_PLAN'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       					WHEN ''SHIP_AVAL'' THEN ''S''																	' + CHAR(10); --NEW jilee
		--SET @mEXEC = @mEXEC+'       					WHEN ''SHIP_AVAL_GAP'' THEN ''S''																' + CHAR(10); --NEW jilee
		SET @mEXEC = @mEXEC+'       					WHEN ''INTN_MOVEMENT'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       					WHEN ''CONTAINER'' THEN ''S''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       					WHEN ''PROD_PLAN'' THEN ''P''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       					WHEN ''WH_STOCK'' THEN ''I''																	' + CHAR(10);
		SET @mEXEC = @mEXEC+'       					WHEN ''BALANCE'' THEN ''I''	END PSI																' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T0.MEASURE																											' + CHAR(10);
		SET @mEXEC = @mEXEC+'       , T1.COLUMN_LABEL_NAME AS MEASURE_NAME																				' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T1.SORT_ORDER_NO																											' + CHAR(10);
		SET @mEXEC = @mEXEC+'       , CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](''' + @v_app_type + ''', T0.DIVISION_ID,T0.FROM_SITE, ''' + @p_from_yyyymmdd + ''') , CONVERT(DATETIME, '''+ @p_from_yyyymmdd + ''' ,112) - 1) ,112) AS CONFIRM_DAY							' + CHAR(10);
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
		SET @mEXEC = @mEXEC+'		AND T1.PROGRAM_ID = ''' + @p_program_id + '''                                                                                                                                   ' + char(10) ;
		SET @mEXEC = @mEXEC+'		AND T1.SHEET_NAME = ''' + @p_sheet_name + '''                                                                                                                       ' + char(10) ;
		SET @mEXEC = @mEXEC+'		AND T1.VALID_YN = ''Y''                                                                                                                                           ' + char(10) ;
		SET @mEXEC = @mEXEC+' 		AND ('+convert(varchar,@v_cnt_usr_measure)+' = 0                                      ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 						OR EXISTS (SELECT 1                                    ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 									 FROM #TblDynamicTitlest_SSP0021			   ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 									 WHERE COLUMN_NAME = T1.COLUMN_NAME)         ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 				                  )                                            ' + char(10) ; 	
		SET @mEXEC = @mEXEC+' 			  AND ( ( '+convert(varchar,@v_cnt_usr_measure)+' = 0 AND T1.DEFAULT_FLAG=''Y'' )                                      ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 						OR  ('+convert(varchar,@v_cnt_usr_measure)+' != 0 )       ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 				                  )                                            ' + char(10) ; 	
		SET @mEXEC = @mEXEC+'	AND T1.COLUMN_NAME = T0.MEASURE																																	  ' + char(10) ;
		if(@p_Item_id != '' AND @p_Item_id IS NOT NULL ) SET @mEXEC = @mEXEC + '	AND T0.ITEM_ID = ''' + @p_Item_id + '''																						' + CHAR(10);
		SET @mEXEC = @mEXEC + '	GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.MEASURE, T1.COLUMN_LABEL_NAME, T1.SORT_ORDER_NO, T2.BOH_TYPE, T2.BOH_QTY, T3.SHIP_FROZEN, T1.ATTRIBUTE3, T0.LOT_YN 																' + CHAR(10);
		SET @mEXEC = @mEXEC + '	ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T1.SORT_ORDER_NO															' + CHAR(10);

		--select @mEXEC;
		EXEC(@mEXEC);

	END;

	IF OBJECT_ID('tempdb..#Tmp_BOHData_STORAGE') IS NOT NULL	
		DROP TABLE #Tmp_BOHData_STORAGE;

	IF OBJECT_ID('tempdb..#Tmp_BOHData') IS NOT NULL	
		DROP TABLE #Tmp_BOHData;

	-- SHIPMENT ROW DATA
	IF OBJECT_ID('tempdb..#Tmp_RowData') IS NOT NULL	
		DROP TABLE #Tmp_RowData;

	IF OBJECT_ID('tempdb..#Tmp_Result_PIVOT_Table') IS NOT NULL	
		DROP TABLE #Tmp_Result_PIVOT_Table;

	IF OBJECT_ID('tempdb..#Tmp_Result_PIVOT_Table_Old') IS NOT NULL	
		DROP TABLE #Tmp_Result_PIVOT_Table_Old;

	IF OBJECT_ID('tempdb..#Tmp_Result_Table') IS NOT NULL	
		DROP TABLE #Tmp_Result_Table;

	IF OBJECT_ID('tempdb..#TblDynamicTitlest_SSP0021') IS NOT NULL	
		DROP TABLE #TblDynamicTitlest_SSP0021;

END
