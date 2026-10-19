


/*
 * Program ID   : FN_DQ_STOCK                                                              
 * Description  : DQ 용 Stock
 * 실행 예제    : SELECT * FROM dbo.FN_DQ_STOCK('20230731', '40', 'A010-A')
 * Program History  
 *===================================================================================================  
 *   Date       In Charge		Description  
 *===================================================================================================  
 * 2023.08.31	KSG			[PJ20230692] LGES SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : DQ 용 Prod Plan 정보
 */
 
CREATE FUNCTION [dbo].[FN_DQ_STOCK]
(	
      @p_cutoff_date         NVARCHAR(8)
    , @p_division_id         NVARCHAR(1000)
	, @p_plant_site_id       NVARCHAR(1000)
)
RETURNS TABLE 
AS
RETURN 
(	
-------------------------------------------------
-- 1.0 재고
-------------------------------------------------
SELECT a.cutoff_date, a.division_id, a.scm_site_id, item.nick_name, s.operation_group
     , a.item_id
	 , a.factory_id
	 , a.operation_id, o.operation_name
	 , a.wiphold_yn
	 , item.item_uom
	 , a.scm_qty
     , CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), cf.cell_cf)
            WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), fi.cell_cf)
            WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
            ELSE 1.0
       END cell_conversion
     ,(CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), cf.cell_cf)
            WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), fi.cell_cf)
            WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
            ELSE 1.0
       END * a.scm_qty ) / 1000.0 AS kcell -- K Cell 단위
FROM scm_dnm_stock a WITH(NOLOCK)
	
	LEFT OUTER JOIN SCM_MST_SITE     S WITH(NOLOCK) ON S.DIVISION_ID = a.DIVISION_ID AND S.scm_site_id = a.scm_site_id
	--LEFT OUTER JOIN SCM_MST_PLANT_SN P WITH(NOLOCK) ON S.COMPANY_ID = P.COMPANY_ID AND S.DIVISION_ID = P.DIVISION_ID AND S.PLANT_ID = P.PLANT_ID
	--LEFT OUTER JOIN SCM_MST_VENDOR   V WITH(NOLOCK) ON V.VENDOR_CODE = S.PLANT_ID AND S.COMPANY_ID = V.COMPANY_ID
	
	--LEFT OUTER JOIN SCM_MST_OPERATION_SN  O WITH(NOLOCK) ON O.DIVISION_ID = a.DIVISION_ID AND O.COMPANY_ID = a.COMPANY_ID AND O.OPERATION_ID = a.OPERATION_ID
	LEFT OUTER JOIN (SELECT DIVISION_ID, OPERATION_ID, MAX(OPERATION_NAME) AS OPERATION_NAME
                     FROM   SCM_MST_OPERATION_SN  O WITH(NOLOCK) 
					 WHERE  ACTIVE_FLAG = 'Y'
					 GROUP BY DIVISION_ID, OPERATION_ID
					) O
	ON  O.DIVISION_ID  = a.DIVISION_ID 
	AND O.OPERATION_ID = a.OPERATION_ID
	
	LEFT OUTER JOIN (SELECT distinct DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME, MAX(ITEM_UOM) AS ITEM_UOM
							FROM SCM_MST_ITEM_SN WITH(NOLOCK) 
							WHERE 1=1
							AND NICK_NAME IS NOT NULL
							AND   ACTIVE_FLAG = 'Y'
							GROUP BY DIVISION_ID, ITEM_ID
					) item
	ON  a.division_id = item.division_id
	AND a.item_id     = item.item_id
	
	LEFT OUTER JOIN (SELECT distinct DIVISION_ID, ITEM_ID, MAX(CELL_ITEM_ID) AS CELL_ITEM_ID, MAX(CONVERT_QTY_CELL) AS CONVERT_QTY_CELL, MAX(CELL_CF) AS CELL_CF
							FROM SCP_MST_FINAL_ITEM WITH(NOLOCK) 
							WHERE 1=1
							GROUP BY DIVISION_ID, ITEM_ID
					) fi
	ON  a.division_id = fi.division_id
	AND a.item_id     = fi.item_id
	
	LEFT OUTER JOIN (SELECT distinct ITEM_ID, MAX(TARGET_CELL) AS TARGET_CELL, MAX(CELL_CF) AS CELL_CF
							FROM scp_mst_item_cell_cf WITH(NOLOCK) 
							WHERE 1=1
							GROUP BY ITEM_ID
					) cf
	ON  a.item_id     = cf.item_id
	
WHERE  1=1
AND    a.division_id    IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ',')) -- = @p_division_id
AND    a.cutoff_date    = @p_cutoff_date
AND    a.scm_site_id    IN (SELECT token FROM [dbo].[String_Split](@p_plant_site_id, ',')) -- = @p_plant_site_id
AND    a.qty           <> 0
-- 전극재고/조립재공 Item 만 : 처음 3자리('APC','ABC','AFC','AHC','AMC','ANP','ASC','AZC')인 코드만 조회
AND    SUBSTRING(a.item_id, 1, 3) IN ('APC','ABC','AFC','AHC','AMC','ANP','ASC','AZC')

-------------------------------------------------
-- 2.0 해상재고
-------------------------------------------------
UNION ALL
SELECT a.result_date AS cutoff_date, a.division_id, a.to_scm_site_id AS scm_site_id, item.nick_name, fi.operation_group
     , a.item_id
	 , '-' AS factory_id
	 , 'Intransit' AS operation_id, 'Intransit' AS operation_name
	 , 'N' AS wiphold_yn
	 , item.item_uom
	 , a.delivery_qty AS scm_qty
     , CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), cf.cell_cf)
            WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), fi.cell_cf)
            WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
            ELSE 1.0
       END cell_conversion
     ,(CASE WHEN ISNULL(CONVERT(NUMERIC(30,10), cf.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), cf.cell_cf)
            WHEN ISNULL(CONVERT(NUMERIC(30,10), fi.cell_cf), 0.0) <> 0 THEN CONVERT(NUMERIC(30,10), fi.cell_cf)
            WHEN ISNULL(fi.convert_qty_cell, 0.0) <> 0 THEN fi.convert_qty_cell
            ELSE 1.0
       END * a.delivery_qty ) / 1000.0 AS kcell -- K Cell 단위
FROM scm_dnm_intransit_c a WITH(NOLOCK)
	
	LEFT OUTER JOIN SCM_MST_SITE     S WITH(NOLOCK) ON S.DIVISION_ID = a.DIVISION_ID AND S.scm_site_id = a.to_scm_site_id
	
	LEFT OUTER JOIN (SELECT distinct DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME, MAX(ITEM_UOM) AS ITEM_UOM
							FROM SCM_MST_ITEM_SN WITH(NOLOCK) 
							WHERE 1=1
							AND NICK_NAME IS NOT NULL
							AND   ACTIVE_FLAG = 'Y'
							GROUP BY DIVISION_ID, ITEM_ID
					) item
	ON  a.division_id = item.division_id
	AND a.item_id     = item.item_id
	
	LEFT OUTER JOIN (SELECT distinct DIVISION_ID, ITEM_ID
                                   , MAX(CELL_ITEM_ID) AS CELL_ITEM_ID, MAX(CONVERT_QTY_CELL) AS CONVERT_QTY_CELL, MAX(CELL_CF) AS CELL_CF
                                   , MAX(OPERATION_GROUP) AS OPERATION_GROUP
							FROM SCP_MST_FINAL_ITEM WITH(NOLOCK) 
							WHERE 1=1
							GROUP BY DIVISION_ID, ITEM_ID
					) fi
	ON  a.division_id = fi.division_id
	AND a.item_id     = fi.item_id
	
	LEFT OUTER JOIN (SELECT distinct ITEM_ID, MAX(TARGET_CELL) AS TARGET_CELL, MAX(CELL_CF) AS CELL_CF
							FROM scp_mst_item_cell_cf WITH(NOLOCK) 
							WHERE 1=1
							GROUP BY ITEM_ID
					) cf
	ON  a.item_id     = cf.item_id
	
WHERE  1=1
AND    a.division_id    IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ',')) -- = @p_division_id
AND    a.result_date    = @p_cutoff_date
AND    a.to_scm_site_id IN (SELECT token FROM [dbo].[String_Split](@p_plant_site_id, ',')) -- = @p_plant_site_id
AND    a.delivery_qty   <> 0
AND    a.result_type in ('C', 'I')
-- 전극재고/조립재공 Item 만 : 처음 3자리('APC','ABC','AFC','AHC','AMC','ANP','ASC','AZC')인 코드만 조회
AND    SUBSTRING(a.item_id, 1, 3) IN ('APC','ABC','AFC','AHC','AMC','ANP','ASC','AZC')
)

