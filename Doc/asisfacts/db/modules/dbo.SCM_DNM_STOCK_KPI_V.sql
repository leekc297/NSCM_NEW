






CREATE VIEW [dbo].[SCM_DNM_STOCK_KPI_V] AS
/*
 * Program ID   : SCM_DNM_STOCK_KPI_V
 * Description  : 재고 정보 (KPI 용) - 일요일 기준 재고 + 운송중 재고
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.09.13   Kim Jihye      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

SELECT  stock.division_id
       ,stock.item_id
	   ,cm.week_name
	   ,cm.basis_yyyymmdd
	   ,SUM(stock.stock_qty) stock_qty
FROM   (SELECT sv.division_id
			  ,item_id
			  ,sv.scm_qty stock_qty
			  ,sv.cutoff_date
		FROM   scm_dnm_stock_v sv WITH(NOLOCK)
		WHERE  sv.scm_site_id IS NOT NULL
		AND    sv.scm_qty > 0
		UNION 
		SELECT ic.division_id
			  ,ic.item_id
			  ,ic.delivery_qty stock_qty
			  ,ic.result_date cutoff_date
		FROM   scm_dnm_intransit_c ic WITH(NOLOCK)
		WHERE  ic.result_type IN ('I', 'S', 'C')
		AND    ic.to_scm_site_id IS NOT NULL) stock
JOIN    scm_sys_calendar_m cm WITH(NOLOCK)
ON      stock.cutoff_date = DATEADD(DAY, -1, cm.basis_date)
WHERE   cm.dayofweek = 'MON'
GROUP BY stock.division_id
        ,stock.item_id
		,cm.week_name
		,cm.basis_yyyymmdd



