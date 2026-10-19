/*
 * Program ID   : SSP0060_GET_SHIPMENT_PSI_COMMENTS
 * Description  : Shipment Plan Confrim COMMENTS LOAD
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024/06/11   hsbang		   SSP 시스템 개선 요청건(Shipment Plan)
 *
 ex) EXEC SSP0060_GET_SHIPMENT_PSI_COMMENTS '40', '20190811', '', '', '20190809', '20191031'
 */
CREATE PROCEDURE [dbo].[SSP0060_GET_SHIPMENT_PSI_COMMENTS]
	 @p_division_id				NVARCHAR(MAX)
	,@p_company_id				NVARCHAR(100)
	,@p_plan_start_yyyymmdd		NVARCHAR(8)
	,@p_from_site				NVARCHAR(MAX)
	,@p_item_id					NVARCHAR(MAX)
	,@p_from_yyyymmdd			NVARCHAR(MAX)
	,@p_to_yyyymmdd				NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT M.DIVISION_ID
		, M.FROM_SITE
		, M.ITEM_ID
		, M.TO_SITE
		, M.TRANSPORT_MODE
		, M.INCOTERMS
		, M.FCST_TYPE
		, M.YYYYMMDD
		, M.QTY
		, M.NOEDIT_QTY
		, 'Input Qty(Min) : '+ REPLACE(CONVERT(VARCHAR, CAST( M.NOEDIT_QTY AS MONEY),1),'.00','') AS NOTE
	FROM (
			SELECT T0.DIVISION_ID
				, T0.FROM_SITE
				, T0.ITEM_ID
				, T0.TO_SITE
				, T0.TRANSPORT_MODE
				, T0.INCOTERMS
				, T0.FCST_TYPE
				, T0.YYYYMMDD
				, SUM(T0.QTY) AS QTY
				, SUM(CASE WHEN ISNULL(T0.SHIPMENT_STATUS, '') != 'C' OR ISNULL(T0.ERP_STATUS, '') = 'C' THEN T0.QTY ELSE 0 END) AS NOEDIT_QTY
			FROM SSP_ANL_SHIP_CONFIRM T0 WITH (NOLOCK)
			WHERE 1 = 1
			AND T0.change_type  = 'C'
			AND T0.BIZ_TYPE  <> 'E'
			AND T0.qty >  0
			--AND (T0.SHIPMENT_STATUS != 'C' OR T0.ERP_STATUS = 'C') --입력 불가(DO 발행수량)
			AND T0.division_id  = @p_division_id  
			AND T0.FROM_SITE_COMPANY_ID = @p_company_id
			--AND T0.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd 
			AND T0.yyyymmdd >= @p_plan_start_yyyymmdd
			AND T0.yyyymmdd <= @p_to_yyyymmdd
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
			) M

END	
