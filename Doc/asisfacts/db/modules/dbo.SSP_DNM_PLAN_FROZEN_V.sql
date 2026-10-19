




CREATE VIEW [dbo].[SSP_DNM_PLAN_FROZEN_V]
/*
 * Program ID   : SSP_DNM_PLAN_FROZEN_V
 * Description  : FP 8 주 확정 계획 정보(SSP전용,소형은 FP계획만 변경된 부분적용) 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.10.23   juhlee    Initial Release [PJ20189106] 전지.GSCM 고도화 이행

 */
AS

SELECT DBO.FN_GET_SCM_SITE_ID_PLANT(r.plant_id
                                  , DBO.FN_GET_ITEM_OPERATION_GROUP(r.division_id, r.item_id)
                                   ) AS scm_site_id
     , r.company_id  
     , r.division_id 
     , r.site_id     
     , r.plant_id
     , r.factory_id  
     , r.operation_id
     , r.location    
     , r.top_item_id 
     , ISNULL(fi.packer_plan_item_id,r.item_id) item_id --2018.06.29
	 , r.item_id origin_item_id --2018.06.29  
     , r.fp_production_type
     , r.market      
     , r.line_id     
     , r.electrode_type
     , r.plan_date   
     , r.plan_qty          -- OUT 수량
	  -- IN 수량
     , CASE WHEN r.plan_in_qty <= 0 THEN r.plan_qty
            ELSE r.plan_in_qty
       END plan_in_qty
     , r.equipment_id
FROM   dbo.ssp_dnm_fp_release_plan_v_sn r WITH(NOLOCK)
LEFT JOIN scp_mst_final_item fi --2018.06.29
ON   r.division_id = fi.division_id
AND  r.item_id = fi.item_id 
WHERE ISNULL(r.fp_production_type, '-') NOT IN ('TEST', 'REWORK', 'M/C') -- 2018.05.14, 2018.06.18  Kim Jihye
 -- TEST : 공장 내부 Test  'M/C' : 형교환계획



