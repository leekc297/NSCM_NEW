


CREATE VIEW [dbo].[SCM_MST_SITE_ITEM_PRIORITY_V] AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SCM_MST_SITE_ITEM_PRIORITY_V
  * DESCRIPTION   : 선호 사이트 정보를 조회 ( valid_yn = 'Y'이면서 priority가 가장 작은값이 조회됨 )
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE        IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018.03.23   KSW                 INITIAL
  * 2020.03.24   KSG                 Warranty Plant Site 제외
  ****************************************************************************/
SELECT a.division_id, a.project_code, a.plant_site_id, a.sales_site_id, a.item_id, a.from_yyyymmdd, a.to_yyyymmdd
FROM   scm_mst_site_item_priority a WITH (NOLOCK)

INNER JOIN (SELECT division_id, project_code, sales_site_id, item_id, from_yyyymmdd, to_yyyymmdd
                    , MIN(priority) AS min_priority 
            FROM   scm_mst_site_item_priority WITH (NOLOCK)
            WHERE  valid_yn = 'Y'            
            GROUP BY division_id, project_code, sales_site_id, item_id, from_yyyymmdd, to_yyyymmdd
            ) b
ON  a.division_id   = b.division_id
AND a.project_code  = b.project_code
AND a.sales_site_id = b.sales_site_id
AND a.item_id       = b.item_id
AND a.from_yyyymmdd = b.from_yyyymmdd
AND a.to_yyyymmdd   = b.to_yyyymmdd
AND a.priority      = b.min_priority          
AND a.valid_YN      = 'Y'

INNER JOIN (SELECT division_id, scm_site_id
            FROM   scm_mst_site WITH (NOLOCK)
            WHERE  valid_yn  = 'Y'
            AND    site_type = 'PLANT'
            AND    operation_group <> 'W' -- 20200324 AS Site 제외
           ) c
ON  a.division_id   = c.division_id
AND a.plant_site_id = c.scm_site_id

