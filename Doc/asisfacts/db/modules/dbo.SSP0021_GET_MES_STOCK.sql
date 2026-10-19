
/*
 * Program ID   : SSP0021_GET_MES_STOCK
 * Description  : Shipment PSI(Small)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/09/15   mcTheJ			Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
 * 2019/09/16   mcTheJ			QMS_MES_Hold Case 수정
 * 2019/09/16   mcTheJ			TOTAL의 합은 RAW DATA의 SUM() -> ROW SUM이 아님
 * 2019/10/28	AYJ				컬럼명 변경 : AVAILABLE_STOCK - > OQC_COMPLETE, 컬럼 추가 : AVAILABLE_STOCK
 * 2022/02/16   SSP Pjt.        SSP_DNM_MES_STOCK_81_82 -> SSP_DNM_GMES_STOCK_81_82
 * 2023/09/01   jilee           반제품->제품 코드 변환 작업
 *
 ex) 
 */

CREATE PROCEDURE [dbo].[SSP0021_GET_MES_STOCK]
	@p_division_id			NVARCHAR(MAX)
	,@p_company_id			NVARCHAR(100)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(8)
	,@p_dbl_flag			CHAR(1)
	,@p_language            NVARCHAR(MAX) = 'KO'
	,@p_program_id			NVARCHAR(MAX) = 'SSP0021' 
	,@p_sheet_name			NVARCHAR(MAX) = 'MES Stock'
	,@debug_mode			CHAR(1) = 'T'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE  @v_from_site		NVARCHAR(MAX)='';
	DECLARE  @v_item_id NVARCHAR(MAX)='';
	
	DECLARE @v_boh_yyyymmdd		NVARCHAR(8);
	DECLARE @v_stock_yyyymmdd	NVARCHAR(8);

	--IN 조건으로 데이터를 가져옴
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);
	
	SET @v_boh_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(VARCHAR, @p_plan_start_yyyymmdd, 121)), 112); --FROM -1일
	SET @v_stock_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -3, CONVERT(VARCHAR, @p_plan_start_yyyymmdd, 121)), 112); --FROM -3일

	--더블클릭
	--W/H Stock Detail
	IF @p_dbl_flag = 'Y'
	BEGIN
		SELECT
			T0.ITEM_ID,
			T0.NICK_NAME,
			SUM(T0.OQC_Insp_Request) AS OQC_INSP_REQUEST,
			SUM(T0.Before_OQC) AS BEFORE_OQC,
			SUM(T0.OQC_NG) AS OQC_NG,
			SUM(T0.QMS_MES_Hold) AS QMS_MES_HOLD,
			SUM(T0.Oqc_Complete) AS OQC_COMPLETE,
			--(SUM(OQC_Insp_Request) + SUM(Before_OQC) + SUM(OQC_NG) + SUM(QMS_MES_Hold) + SUM(Available_Stock)) AS TOTAL
			SUM(ISNULL(TOTAL, 0)) AS TOTAL,
			(SUM(ISNULL(TOTAL, 0)) - SUM(T0.OQC_NG) - SUM(T0.QMS_MES_Hold)) AS AVAILABLE_STOCK
		FROM
		(
			SELECT
			    -- jilee 230901
				ATTRIBUTE5 AS ITEM_ID,
				PRJT_NAME AS NICK_NAME,
				CASE WHEN AVAILABLE_YN = 'N' AND OQC_INSP_RESULT = 'Inspection Request' THEN SUM(ISNULL(LOT_QTY, 0)) ELSE 0 END AS OQC_Insp_Request,
				CASE WHEN AVAILABLE_YN = 'N' AND ISNULL(OQC_INSP_RESULT, '') ='' THEN SUM(ISNULL(LOT_QTY, 0)) ELSE 0  END AS Before_OQC,
				CASE WHEN AVAILABLE_YN = 'N' AND OQC_INSP_RESULT = 'N' THEN SUM(ISNULL(LOT_QTY, 0)) ELSE 0  END AS OQC_NG,
				CASE WHEN AVAILABLE_YN = 'N' AND (QMS_HOLD_YN = 'Y' OR MES_HOLD_YN = 'Y') THEN SUM(ISNULL(LOT_QTY, 0)) ELSE 0  END AS QMS_MES_Hold,
				CASE WHEN AVAILABLE_YN = 'Y' THEN SUM(ISNULL(LOT_QTY, 0)) ELSE 0  END AS Oqc_Complete, 
				SUM(ISNULL(LOT_QTY, 0)) AS TOTAL
            -- jilee 230901
			FROM SSP_DNM_GMES_STOCK_81_82 with(nolock)
			WHERE 1 = 1
			AND DIVISION_ID = @p_division_id
			AND COMPANY_ID = @p_company_id
			AND YYYYMMDD = @p_plan_start_yyyymmdd
			-- jilee 23091
			AND ATTRIBUTE5 = @p_item_id
			--AND ITEM_ID = @p_item_id
			AND ((@p_from_site IS NULL OR @p_from_site ='') OR FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
			GROUP BY ATTRIBUTE5, ITEM_ID, PRJT_NAME, AVAILABLE_YN, OQC_INSP_RESULT, MES_HOLD_YN, QMS_HOLD_YN
		) AS T0
		GROUP BY T0.ITEM_ID, T0.NICK_NAME
	END
	--2. btnSearch
	ELSE
	BEGIN
		SELECT
			T0.ITEM_ID,
			T0.NICK_NAME,
			SUM(T0.OQC_Insp_Request) AS OQC_INSP_REQUEST,
			SUM(T0.Before_OQC) AS BEFORE_OQC,
			SUM(T0.OQC_NG) AS OQC_NG,
			SUM(T0.QMS_MES_Hold) AS QMS_MES_HOLD,
			SUM(T0.Oqc_Complete) AS OQC_COMPLETE,
			--(SUM(OQC_Insp_Request) + SUM(Before_OQC) + SUM(OQC_NG) + SUM(QMS_MES_Hold) + SUM(Available_Stock)) AS TOTAL
			SUM(ISNULL(TOTAL, 0)) AS TOTAL,
			(SUM(ISNULL(TOTAL, 0)) - SUM(T0.OQC_NG) - SUM(T0.QMS_MES_Hold)) AS AVAILABLE_STOCK
		FROM
		(
			SELECT
			    -- jilee 230901
				ATTRIBUTE5 AS ITEM_ID,				
				PRJT_NAME AS NICK_NAME,
				CASE WHEN AVAILABLE_YN = 'N' AND OQC_INSP_RESULT = 'Inspection Request' THEN SUM(ISNULL(LOT_QTY, 0)) ELSE 0 END AS OQC_Insp_Request,
				CASE WHEN AVAILABLE_YN = 'N' AND ISNULL(OQC_INSP_RESULT, '') ='' THEN SUM(ISNULL(LOT_QTY, 0)) ELSE 0  END AS Before_OQC,
				CASE WHEN AVAILABLE_YN = 'N' AND OQC_INSP_RESULT = 'N' THEN SUM(ISNULL(LOT_QTY, 0)) ELSE 0  END AS OQC_NG,
				CASE WHEN AVAILABLE_YN = 'N' AND (QMS_HOLD_YN = 'Y' OR MES_HOLD_YN = 'Y') THEN SUM(ISNULL(LOT_QTY, 0)) ELSE 0  END AS QMS_MES_Hold,
				CASE WHEN AVAILABLE_YN = 'Y' THEN SUM(ISNULL(LOT_QTY, 0)) ELSE 0  END AS Oqc_Complete,
				SUM(ISNULL(LOT_QTY, 0)) AS TOTAL
            -- jilee 230901
			FROM SSP_DNM_GMES_STOCK_81_82 with(nolock)
			WHERE 1 = 1
			AND DIVISION_ID = @p_division_id
			AND COMPANY_ID = @p_company_id
			AND YYYYMMDD = @p_plan_start_yyyymmdd
			AND ((@p_from_site IS NULL OR @p_from_site ='') OR FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
			-- jilee 230901
			AND ((@p_item_id IS NULL OR @p_item_id ='')	OR ATTRIBUTE5 IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
			--AND ((@p_item_id IS NULL OR @p_item_id ='')	OR ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
			GROUP BY ATTRIBUTE5, ITEM_ID, PRJT_NAME, AVAILABLE_YN, OQC_INSP_RESULT, MES_HOLD_YN, QMS_HOLD_YN
		) AS T0
		GROUP BY T0.ITEM_ID, T0.NICK_NAME
	END
END



