




CREATE VIEW [dbo].[SCM_MST_MODEL_FINAL_ITEM_BOM_V] AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SCM_MST_MODEL_FINAL_ITEM_BOM_V
  * DESCRIPTION   : MODEL별 전극,셀,팩공정그룹의 최종공정의 ITEM으로 구성된 ONE LEVEL BOM 
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-02-20   YYDOK        INITIAL
  * 2018-06-15   YYDOK        scm_mst_bom_sn -> SCM_MST_BOM_EFFECTIVE_SN 유효일자반영
  * 2018-10-09   YYDOK        MODEL의 CHILD ITEM의 PARENT도 모두 유효한 BOM인지 CHECK반영
  * 2018-10-15   YYDOK        ACTIVE_FLAG='N'인 CHILD_ITEM_ID 제외
  * 2018-11-26   YYDOK        TCO_CELL_YN 추가
  * 2018-12-06   YYDOK        C.ALT_PRIORITY='Y' 조건추가
  * 2018-12-26   yydok        X.CONCATENATE_ITEM LIKE C.CONCATENATE_ITEM + '^%'  ^추가
  * 2019-02-25   yydok        SCM_MST_BOM_EFFECTIVE_SN => scm_mst_bom_sn
  * 2021-02-19   ksg          C20210219-000229 SCP BOM Logic 변경 건 : Company 별로 유효한 Model만 적용
  * 2021-03-09   SEO          PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : SCP 대치 BOM 적용
  * 2023-06-02   KSG          PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 대응 Cell Prod/Assy 구분자 추가
  ****************************************************************************/
SELECT b.division_id,
       b.plant_id,
       b.model_id,
       b.child_item_id,
       v.operation_group_id, 
       CASE v.operation_group_id WHEN 'P' THEN 1  --전지 팩
                                 WHEN 'A' THEN 2  --전지 셀
                                 WHEN 'E' THEN 3  --전지 전극
                   ELSE 9
       END AS operation_sort_no,
       v.electrode_type,
       CONVERT(DATETIME, '20000101',112) AS eff_start_date,
       CONVERT(DATETIME, '99991231',112) AS eff_end_date,
       v.tco_cell_yn,
       SUM(b.accumulated_child_qty)      AS accumulated_child_qty,
	   v.cell_type  -- 20230602 PJ20230691 활성화 대응 Cell Prod/Assy 구분자 추가
  FROM ( SELECT x.* 
           --FROM dbo.scm_mst_bom_sn x WITH(NOLOCK)	
		   FROM dbo.scm_mst_bom_sn_V x WITH(NOLOCK)	--2021-03-09	SCP 대치 BOM 적용
                INNER JOIN dbo.scm_mst_item_sn i WITH(NOLOCK)
                ON  x.child_division_id = i.division_id
                AND x.child_item_id     = i.item_id
                AND x.child_company_id  = i.company_id -- A002 빈강 추가 따른 조건 추가
                AND x.child_site_id     = i.site_id
                AND i.active_flag       = 'Y'           
          WHERE 1=1
       ) b
     , scm_mst_final_item_v v WITH(NOLOCK)
	 , scm_mst_item_sn mi WITH(NOLOCK)   -- 20210219 C20210219-000229  Company 별로 유효한 Model만 적용
 WHERE 1=1
   AND b.division_id   = v.division_id
   AND b.child_item_id = v.item_id
   AND b.alt_priority  = 'Y'  -- => FP에서 MODEL별로 전개한 테이블에 적용.
   --AND ( b.alt_id IS NULL OR ISNULL(b.alt_priority,'') ='Y')

   -- 20210219 C20210219-000229  Company 별로 유효한 Model만 적용
   AND b.division_id   = mi.division_id
   AND b.model_id      = mi.item_id
   AND b.company_id    = mi.company_id  -- A002 빈강 추가 따른 조건 추가
   AND b.site_id       = mi.site_id
   AND mI.active_flag  = 'Y'

GROUP BY b.division_id, b.plant_id, b.model_id, b.child_item_id, v.operation_group_id, v.electrode_type, v.tco_cell_yn, v.cell_type
;

