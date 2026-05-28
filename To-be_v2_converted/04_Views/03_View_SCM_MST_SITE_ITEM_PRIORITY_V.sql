/*=============================================================================================
 * File         : 03_View_SCM_MST_SITE_ITEM_PRIORITY_V.sql
 * Description  : View — SCM_MST_SITE_ITEM_PRIORITY_V
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : ANSI OUTER JOIN → (+) 변환은 자동변환 위험으로 수동 검토 필요.
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 04_Views 단계 (Tables 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN ... ON → WHERE A.x = B.x(+) 변환 (사내 표준 §7.1.6)
 *===========================================================================================*/

-- SCM_MGR.SCM_MST_SITE_ITEM_PRIORITY_V source

CREATE OR REPLACE FORCE EDITIONABLE VIEW "SCM_MGR"."SCM_MST_SITE_ITEM_PRIORITY_V" ("DIVISION_ID", "PROJECT_CODE", "PLANT_SITE_ID", "SALES_SITE_ID", "ITEM_ID", "FROM_YYYYMMDD", "TO_YYYYMMDD") AS 
  SELECT a.division_id, a.project_code, a.plant_site_id, a.sales_site_id, a.item_id, a.from_yyyymmdd, a.to_yyyymmdd
FROM   scm_mst_site_item_priority a

INNER JOIN (SELECT division_id, project_code, sales_site_id, item_id, from_yyyymmdd, to_yyyymmdd
                    , MIN(priority) min_priority
            FROM   scm_mst_site_item_priority
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
            FROM   scm_mst_site
            WHERE  valid_yn  = 'Y'
            AND    site_type = 'PLANT'
            AND    operation_group <> 'W' -- 20200324 AS Site 제외
           ) c
ON  a.division_id   = c.division_id
AND a.plant_site_id = c.scm_site_id;

GRANT SELECT ON "SCM_MGR"."SCM_MST_SITE_ITEM_PRIORITY_V" TO "RL_SCM_DML";
  GRANT SELECT ON "SCM_MGR"."SCM_MST_SITE_ITEM_PRIORITY_V" TO "RL_SCM_SEL";
  GRANT SELECT ON "SCM_MGR"."SCM_MST_SITE_ITEM_PRIORITY_V" TO "SCMD_APP";


-- SCM_MGR.SCP_ANL_PSI_GLOBAL_V source
