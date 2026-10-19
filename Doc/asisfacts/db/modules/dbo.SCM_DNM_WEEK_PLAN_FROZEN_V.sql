




CREATE VIEW [dbo].[SCM_DNM_WEEK_PLAN_FROZEN_V]
/*
 * Program ID   : SCM_DNM_WEEK_PLAN_FROZEN_V
 * Description  : FP 당주 확정 계획 정보 : 월 실적 + 화~일 계획
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.03.13   KSG            Initial Release : PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행
 * 
 */
AS
								   
SELECT DBO.FN_GET_SCM_SITE_ID_PLANT(r.plant_id
                                   ,(SELECT TOP 1 ISNULL(I.SCP_OPERATION_GROUP,'')
                                     FROM   DBO.SCM_MST_ITEM_SN              I WITH(NOLOCK)
                                     WHERE  1=1
                                     AND    I.DIVISION_ID          = r.division_id
                                     AND    I.ITEM_ID              = ISNULL(fi.packer_plan_item_id,r.item_id)
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
     , ISNULL(fi.packer_plan_item_id,r.item_id) item_id 
	 , r.item_id origin_item_id 
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
FROM   DBO.SCM_DNM_FP_WEEK_RELEASE_PLAN_V_SN r WITH(NOLOCK)
LEFT JOIN scp_mst_final_item fi 
ON   r.division_id = fi.division_id
AND  r.item_id = fi.item_id 
WHERE ISNULL(r.fp_production_type, '-') NOT IN ('TEST', 'REWORK', 'M/C') 
 -- TEST : 공장 내부 Test  'M/C' : 형교환계획


