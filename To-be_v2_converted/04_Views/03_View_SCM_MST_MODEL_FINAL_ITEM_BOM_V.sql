/*=============================================================================================
 * File         : 03_View_SCM_MST_MODEL_FINAL_ITEM_BOM_V.sql
 * Description  : View — SCM_MST_MODEL_FINAL_ITEM_BOM_V
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

-- SCM_MGR.SCM_MST_MODEL_FINAL_ITEM_BOM_V source

CREATE OR REPLACE FORCE EDITIONABLE VIEW "SCM_MGR"."SCM_MST_MODEL_FINAL_ITEM_BOM_V" ("DIVISION_ID", "PLANT_ID", "MODEL_ID", "CHILD_ITEM_ID", "OPERATION_GROUP_ID", "OPERATION_SORT_NO", "ELECTRODE_TYPE", "EFF_START_DATE", "EFF_END_DATE", "TCO_CELL_YN", "ACCUMULATED_CHILD_QTY", "CELL_TYPE") AS 
  SELECT b.division_id,
       b.plant_id,
       b.model_id,
       b.child_item_id,
       v.operation_group_id,
       CASE v.operation_group_id WHEN 'P' THEN 1  --팩공정 순
                                 WHEN 'A' THEN 2  --셀공정 순
                                 WHEN 'E' THEN 3  --전극공정 순
                   ELSE 9
       END AS operation_sort_no,
       v.electrode_type,
       TO_DATE('20000101', 'YYYYMMDD') AS eff_start_date,
       TO_DATE('99991231', 'YYYYMMDD') AS eff_end_date,
       v.tco_cell_yn,
       SUM(b.accumulated_child_qty)    AS accumulated_child_qty,
       v.cell_type  -- 20230602 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
  FROM ( SELECT x.*
           --FROM scm_mst_bom_sn x
		   FROM scm_mst_bom_sn_V x	--2021-03-09	SCP 배치 BOM 적용
                INNER JOIN scm_mst_item_sn i
                ON  x.child_division_id = i.division_id
                AND x.child_item_id     = i.item_id
                AND x.child_company_id  = i.company_id -- A002 등 추가 법인 조건 추가
                AND x.child_site_id     = i.site_id
                AND i.active_flag       = 'Y'
          WHERE 1=1
       ) b
     , scm_mst_final_item_v v
     , scm_mst_item_sn mi   -- 20210219 C20210219-000229  Company 별로 유효한 Model만 사용
 WHERE 1=1
   AND b.division_id   = v.division_id
   AND b.child_item_id = v.item_id
   AND b.alt_priority  = 'Y'  -- => FP에서 MODEL기반 계획시 대체이블에 사용.
   --AND ( b.alt_id IS NULL OR NVL(b.alt_priority,'') ='Y')

   -- 20210219 C20210219-000229  Company 별로 유효한 Model만 사용
   AND b.division_id   = mi.division_id
   AND b.model_id      = mi.item_id
   AND b.company_id    = mi.company_id  -- A002 등 추가 법인 조건 추가
   AND b.site_id       = mi.site_id
   AND mi.active_flag  = 'Y'

 GROUP BY b.division_id, b.plant_id, b.model_id, b.child_item_id, v.operation_group_id, v.electrode_type, v.tco_cell_yn, v.cell_type
;

GRANT SELECT ON "SCM_MGR"."SCM_MST_MODEL_FINAL_ITEM_BOM_V" TO "SCMD_APP";


-- SCM_MGR.SCM_MST_SITE_DETP_V source
