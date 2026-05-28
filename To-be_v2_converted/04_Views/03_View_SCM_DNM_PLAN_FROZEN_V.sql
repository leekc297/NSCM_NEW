/*=============================================================================================
 * File         : 03_View_SCM_DNM_PLAN_FROZEN_V.sql
 * Description  : View — SCM_DNM_PLAN_FROZEN_V
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

-- SCM_MGR.SCM_DNM_PLAN_FROZEN_V source

CREATE OR REPLACE FORCE EDITIONABLE VIEW "SCM_MGR"."SCM_DNM_PLAN_FROZEN_V" ("SCM_SITE_ID", "COMPANY_ID", "DIVISION_ID", "SITE_ID", "PLANT_ID", "FACTORY_ID", "OPERATION_ID", "LOCATION", "TOP_ITEM_ID", "ITEM_ID", "ORIGIN_ITEM_ID", "FP_PRODUCTION_TYPE", "MARKET", "LINE_ID", "ELECTRODE_TYPE", "PLAN_DATE", "PLAN_QTY", "PLAN_IN_QTY", "EQUIPMENT_ID") AS 
  SELECT SCM_MGR.FN_GET_SCM_SITE_ID_PLANT(r.plant_id,
                                   (SELECT NVL(I.SCP_OPERATION_GROUP, '')
                                    FROM   SCM_MGR.SCM_MST_ITEM_SN              I
                                    WHERE  1=1
                                    AND    I.ITEM_ID              = NVL(fi.packer_plan_item_id, r.item_id)
                                    AND    I.DIVISION_ID          = r.division_id
                                    FETCH FIRST 1 ROWS ONLY -- Oracle에서는 TOP 대신 FETCH FIRST를 사용합니다.
                                   )
                                  ) AS scm_site_id

     , r.company_id
     , r.division_id
     , r.site_id
     , r.plant_id
     , r.factory_id
     , r.operation_id
     , r.location
     , r.top_item_id
     , NVL(fi.packer_plan_item_id, r.item_id) item_id --2018.06.29
     , r.item_id origin_item_id --2018.06.29
     , r.fp_production_type
     , r.market
     , r.line_id
     , r.electrode_type
     , r.plan_date
     , r.plan_qty          -- OUT 수량
     , CASE WHEN r.plan_in_qty <= 0 THEN r.plan_qty
            ELSE r.plan_in_qty
       END plan_in_qty
     , r.equipment_id
FROM   SCM_MGR.scm_dnm_fp_release_plan_v_sn r
LEFT JOIN SCM_MGR.scp_mst_final_item fi --2018.06.29
ON   r.division_id = fi.division_id
AND  r.item_id = fi.item_id
WHERE NVL(r.fp_production_type, '-') NOT IN ('TEST', 'REWORK', 'M/C') -- 2018.05.14, 2018.06.18  Kim Jihye
 -- TEST : 공장 내부 Test  'M/C' : 형교환계획
;

GRANT SELECT ON "SCM_MGR"."SCM_DNM_PLAN_FROZEN_V" TO "SCMD_APP";


-- SCM_MGR.SCM_DNM_PRODUCT_RESULT_V source
