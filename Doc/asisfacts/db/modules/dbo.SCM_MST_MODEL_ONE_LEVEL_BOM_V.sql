

CREATE VIEW [dbo].[SCM_MST_MODEL_ONE_LEVEL_BOM_V] AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SCM_MST_MODEL_ONE_LEVEL_BOM_V
  * DESCRIPTION   : MODEL별 ONE LEVEL BOM(원자재제외)
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-02-21   YYDOK        INITIAL
  * 2018-10-09   YYDOK        MODEL의 CHILD ITEM의 PARENT도 모두 유효한 BOM인지 CHECK반영  
  * 2018-10-15   YYDOK        ACTIVE_FLAG='N'인 CHILD_ITEM_ID 제외  
  * 2018-12-07   YYDOK        C.ALT_PRIORITY='Y' 조건추가
  * 2018-12-26   yydok        X.CONCATENATE_ITEM LIKE C.CONCATENATE_ITEM + '^%'  ^추가
  * 2019-02-25   yydok        SCM_MST_BOM_EFFECTIVE_SN => scm_mst_bom_sn  
  * 2021-02-19   ksg          C20210219-000229 SCP BOM Logic 변경 건 : Company 별로 유효한 Model만 적용
  * 2021-03-09   SEO          PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선: SCP 대치 BOM 적용
  ****************************************************************************/
SELECT b.division_id,
       b.plant_id,
       b.model_id,
       b.child_item_id,
       MAX(i.item_type) AS item_type,
       MAX(i.item_name) AS item_name,
       MAX(i.item_uom)  AS item_uom,
       dbo.FN_GET_ITEM_OPERATION_GROUP(b.division_id, b.child_item_id)    AS operation_group,
       dbo.FN_GET_ITEM_OPERATION_GROUP_ID(b.division_id, b.child_item_id) AS operation_group_id,
       SUM(b.accumulated_child_qty)                                       AS accumulated_child_qty
  FROM ( SELECT X.*
           --FROM dbo.scm_mst_bom_sn x WITH(NOLOCK)
		   FROM dbo.scm_mst_bom_sn_V x WITH(NOLOCK)		--2021-03-09 SCP 대치 BOM 적용
                INNER JOIN dbo.scm_mst_item_sn i WITH(NOLOCK)
                ON  x.child_division_id = i.division_id
                AND x.child_item_id     = i.item_id
                AND x.child_company_id  = i.company_id -- A002 빈강 추가 따른 조건 추가
                AND x.child_site_id     = i.site_id
                AND i.active_flag       = 'Y'
          WHERE 1=1
         ) b
     , scm_mst_item_sn i WITH(NOLOCK)
	 , scm_mst_item_sn mi WITH(NOLOCK)   -- 20210219 C20210219-000229  Company 별로 유효한 Model만 적용
 WHERE 1=1
   --and ( b.alt_id IS NULL OR ( b.alt_id IS NOT NULL AND b.alt_priority = 1 ) --=> BOM 원본테이블에 적용.
   AND b.alt_priority  = 'Y'  -- => FP에서 MODEL별로 전개한 테이블에 적용.
   AND b.division_id   = i.division_id
   AND b.child_item_id = i.item_id
   AND b.company_id    = i.company_id  -- A002 빈강 추가 따른 조건 추가
   AND b.site_id       = i.site_id
   AND i.item_type    IN ('P','H')
   AND I.active_flag   = 'Y'

   -- 20210219 C20210219-000229  Company 별로 유효한 Model만 적용
   AND b.division_id   = mi.division_id
   AND b.model_id      = mi.item_id
   AND b.company_id    = mi.company_id  -- A002 빈강 추가 따른 조건 추가
   AND b.site_id       = mi.site_id
   AND mI.active_flag  = 'Y'

GROUP BY b.division_id, b.plant_id, b.model_id, b.child_item_id
;

