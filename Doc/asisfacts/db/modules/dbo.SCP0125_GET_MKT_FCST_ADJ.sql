


/*
 * Program ID   : SCP0125_GET_MKT_FCST_ADJ
 * Description  : Workbench - MKT FCST 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/06/24   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/07/14   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - 소형(40)의 Project Code ==> End Customer 적용, Nick Name 추가
 * 2025/08/06   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - YYYYMMDD --> ATTRIBUTE1 으로 Deu Date 변경
 *
 */

CREATE PROCEDURE [dbo].[SCP0125_GET_MKT_FCST_ADJ]
	@p_division_id				NVARCHAR(50)
	, @p_plan_start_yyyymmdd	NVARCHAR(8)
	, @p_version_no				NVARCHAR(50)
	, @p_nick_name				NVARCHAR(200)
	, @p_item_id				NVARCHAR(200)

AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	SELECT *, CHG_QTY AS PRE_CHG_QTY, CHG_RSN AS PRE_CHG_RSN
	FROM (
		SELECT a.DIVISION_ID
			  , a.VERSION_NO
			  , a.CUTOFF_YYYYMMDD
			  , a.PROJECT_CODE
			  , a.PROJECT_CODE	AS PROJECT_CODE_40	--소형(40)의 Project Code ==> End Customer 적용 (2025-07-14)
			  , a.SCM_SITE_ID
			  , a.NICK_NAME		--Nick Name 추가 (2025-07-14)
			  , a.ITEM_ID
			  , a.FCST_TYPE
			  , d.SEGMENT2 AS FCST_TYPE_NAME
			  , a.INCOTERMS
			  , a.PLANT_SITE_ID
			  , a.CELL_PROD_SITE_ID
			  , CONVERT(date, a.YYYYMMDD, 112) AS DUE_DATE		-- 기준일자
			  , a.QTY
			  , b.CHG_QTY
			  , b.CHG_RSN
			  , b.CHG_TYPE
			  , ISNULL(b.LAST_UPDATED_BY, '') AS LAST_UPDATED_BY
			  , ISNULL(b.LAST_UPDATE_DATE, NULL) AS LAST_UPDATE_DATE

		FROM (
				SELECT x.DIVISION_ID
					  , VERSION_NO
					  , CUTOFF_YYYYMMDD
					  , PROJECT_CODE
					  , SCM_SITE_ID
					  , c.NICK_NAME		--Nick Name 추가 (2025-07-14)
					  , x.ITEM_ID
					  , FCST_TYPE
					  , INCOTERMS
					  , PLANT_SITE_ID
					  , CELL_PROD_SITE_ID
					  --, YYYYMMDD						-- 기준일자	
					  , x.ATTRIBUTE1 AS YYYYMMDD		-- 기준일자	, DUE DATE 변경 (2025-08-06 요청)
					  , SUM(x.QTY) AS QTY
				FROM DM_PLN_NET_DEMAND x WITH(NOLOCK)
				LEFT JOIN (
					SELECT DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME
					FROM SCM_MST_ITEM_SN WITH(NOLOCK)
					GROUP BY  DIVISION_ID, ITEM_ID
					) c
					ON c.DIVISION_ID = x.DIVISION_ID AND c.ITEM_ID = x.ITEM_ID
				WHERE 1=1
				AND x.DIVISION_ID = @p_division_id
				AND x.VERSION_NO = @p_version_no
				AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR x.ITEM_ID LIKE '%' + @p_item_id + '%' ) 
				AND ( ( @p_nick_name IS NULL OR  @p_nick_name = '' ) OR c.NICK_NAME LIKE '%' + @p_nick_name + '%' ) 
				GROUP BY x.DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, c.NICK_NAME, x.ITEM_ID, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, x.ATTRIBUTE1 --YYYYMMDD

			) A
		LEFT JOIN SCP_OPMZ_DMD_ADJ b WITH(NOLOCK)
			ON a.DIVISION_ID = b.DIVISION_ID AND a.VERSION_NO = b.VERSION_NO AND a.CUTOFF_YYYYMMDD = b.CUTOFF_YYYYMMDD AND a.PROJECT_CODE = b.PROJECT_CODE AND a.SCM_SITE_ID = b.SCM_SITE_ID AND a.ITEM_ID = b.ITEM_ID 
			AND a.FCST_TYPE = b.FCST_TYPE AND a.INCOTERMS = b.INCOTERMS AND a.PLANT_SITE_ID = b.PLANT_SITE_ID AND a.CELL_PROD_SITE_ID = b.CELL_PROD_SITE_ID AND a.YYYYMMDD = b.DUE_DATE
		
		LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL d WITH(NOLOCK) ON LOOKUP_TYPE = 'SALES_TYPE_CODE' AND d.SEGMENT1 = a.FCST_TYPE
		WHERE 1=1

		--Insert 된 정보
		UNION ALL
		SELECT a.DIVISION_ID
			, a.VERSION_NO
			, a.CUTOFF_YYYYMMDD
			, a.PROJECT_CODE
			, a.PROJECT_CODE	AS PROJECT_CODE_40	--소형(40)의 Project Code ==> End Customer 적용 (2025-07-14)
			, a.SCM_SITE_ID
			, c.NICK_NAME		--Nick Name 추가 (2025-07-14)
			, a.ITEM_ID
			, a.FCST_TYPE
			, d.SEGMENT2 AS FCST_TYPE_NAME
			, a.INCOTERMS
			, a.PLANT_SITE_ID
			, a.CELL_PROD_SITE_ID
			, CONVERT(date, a.DUE_DATE, 112) AS DUE_DATE		-- 기준일자
			, a.QTY
			, a.CHG_QTY
			, a.CHG_RSN
			, a.CHG_TYPE
			, ISNULL(a.LAST_UPDATED_BY, '') AS LAST_UPDATED_BY
			, ISNULL(a.LAST_UPDATE_DATE, NULL) AS LAST_UPDATE_DATE
		FROM SCP_OPMZ_DMD_ADJ a WITH(NOLOCK)
		LEFT JOIN (
					SELECT DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME
					FROM SCM_MST_ITEM_SN WITH(NOLOCK)
					GROUP BY  DIVISION_ID, ITEM_ID
			) c
			ON c.DIVISION_ID = a.DIVISION_ID AND c.ITEM_ID = a.ITEM_ID
		LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL d WITH(NOLOCK) ON LOOKUP_TYPE = 'SALES_TYPE_CODE' AND d.SEGMENT1 = a.FCST_TYPE
		WHERE 1=1
		AND a.CHG_TYPE = 'New'
		AND a.DIVISION_ID = @p_division_id
		--AND a.CUTOFF_YYYYMMDD = @p_plan_start_yyyymmdd
		AND a.VERSION_NO = @p_version_no
		AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR a.ITEM_ID LIKE '%' + @p_item_id + '%' ) 
		AND ( ( @p_nick_name IS NULL OR  @p_nick_name = '' ) OR c.NICK_NAME LIKE '%' + @p_nick_name + '%' ) 
	) DMD
	ORDER BY DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, NICK_NAME, ITEM_ID, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, DUE_DATE

  
END

