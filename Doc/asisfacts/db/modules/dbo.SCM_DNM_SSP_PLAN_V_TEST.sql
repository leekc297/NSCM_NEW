



CREATE VIEW [dbo].[SCM_DNM_SSP_PLAN_V_TEST] AS
/*
 * Program ID   : SCM_DNM_SSP_PLAN_V
 * Description  : 재고 : DW용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024.10.02   KSG            Initial Release : PJ20249346 LGES SCP 개선과제 이행 : SSP Confirm + SSP Request 정보 : SCP Plan Input용
 * 
 */
-- 1. SSP Confirm 정보
SELECT 'CFM' AS SSP_TYPE                                                                                                                                                                                                                                                                                      
 	, sc.division_id, sc.confirm_id, sc.from_site, sc.bod_id AS bod_id, sc.to_site AS to_site
    , sc.incoterms, sc.transport_mode
	, sc.change_type, sc.biz_type
    , sc.project_code, sc.fcst_type
    , sc.item_id
    , sc.yyyymmdd
    , IIF(ISNULL(sc.eta_date, '') = '', CONVERT(DATETIME, sc.yyyymmdd), sc.eta_date) AS eta_date
    , sc.qty
FROM  ssp_anl_ship_confirm sc WITH (NOLOCK)
WHERE  sc.division_id         = sc.division_id
AND    sc.qty                 > 0
AND    sc.yyyymmdd            >= CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 전주 월요일
AND    sc.change_type         = 'C'  --  20180716 추가
-- 2. SSP Request 정보
UNION 
SELECT 'REQ' AS SSP_TYPE                                                                                                                                                                                                                                                                                      
 	, tt0.DIVISION_ID,'-' AS CONFIRM_ID, tt0.PLANT_SITE_ID AS FROM_SITE, tt0.BOD_ID, tt0.SCM_SITE_ID AS TO_SITE
	
	, ISNULL(tt1.SSP_INCOTERMS, tt0.INCOTERMS)   AS INCOTERMS, tt0.TRANSPORT_MODE
	, '-' AS CHANGE_TYPE, FI.OPERATION_GROUP AS BIZ_TYPE
	, tt0.PROJECT_CODE, tt0.FCST_TYPE

 	, tt0.ITEM_ID
	, tt0.YYYYMMDD                                                                                                                                                               
 	, CONVERT(VARCHAR(8),CONVERT(DATETIME,[dbo].[FN_GET_SSP_ETA_DATE](tt0.DIVISION_ID, tt0.BOD_ID, tt0.YYYYMMDD) ,112), 112) AS ETA_DATE 
	, tt0.QTY 
FROM DM_PLN_SHIPMENT_REQ tt0 WITH(NOLOCK)                                                                                                                                                                                                                                                               
 	INNER JOIN  scp_mst_bod_n_v tt1 WITH(NOLOCK) ON tt0.DIVISION_ID = tt1.division_id  AND tt0.bod_id = tt1.bod_id                                                                                                                                                                                                                  
 	INNER JOIN SCM_MST_SITE tt2 WITH(NOLOCK)                                                                                                                                                                                                                  
 		ON tt0.DIVISION_ID = tt2.DIVISION_ID 
 		AND tt0.PLANT_SITE_ID = tt2.SCM_SITE_ID 
 		AND tt2.site_type		= 'PLANT' 
 		AND tt2.valid_yn		= 'Y' 
	LEFT OUTER JOIN SCM_MST_SITE FS  WITH(NOLOCK)
		ON  tt0.DIVISION_ID = FS.DIVISION_ID 
		AND tt0.PLANT_SITE_ID = FS.SCM_SITE_ID 
		AND FS.VALID_YN    = 'Y' 
	LEFT OUTER JOIN SCP_MST_FINAL_ITEM AS FI WITH(NOLOCK)				 
		ON FI.DIVISION_ID = tt0.DIVISION_ID					 
		AND FI.ITEM_ID	  = tt0.ITEM_ID	
	LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
		ON  tt0.DIVISION_ID = (CASE WHEN FI.OPERATION_GROUP = 'E' THEN E.DIVISION_ID ELSE  E.ASSY_DIVISION_ID END)
        AND tt0.PLANT_SITE_ID = (CASE WHEN FI.OPERATION_GROUP = 'E' THEN E.SCM_SITE_ID ELSE  E.ASSY_SCM_SITE_ID END)
		AND tt0.ITEM_ID       = E.ITEM_ID		
WHERE 1 = 1                                                                                                                                                                                                                                                                                 
AND  tt0.DIVISION_ID     = tt0.DIVISION_ID
AND  tt0.QTY            > 0
AND  tt0.yyyymmdd       >= CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 전주 월요일
;

