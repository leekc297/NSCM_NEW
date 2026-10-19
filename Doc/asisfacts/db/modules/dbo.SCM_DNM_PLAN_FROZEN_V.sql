






CREATE VIEW [dbo].[SCM_DNM_PLAN_FROZEN_V]
/*
 * Program ID   : SCM_DNM_PLAN_FROZEN_V
 * Description  : FP 8 주 확정 계획 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.26   Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.04.20   KSG            대상 테이블 변경  
 * 2018.05.14   Kim Jihye      fp_production_type TEST, REWORK 제외
 * 2018.06.18   Kim Jihye      fp_production_type M/C(형교환) 제외
 * 2018. 06.29  Kim jaejung    소형 대표 ITEM_ID 로 실적 생성 로직 추가 (소형)
 */
AS

--SELECT DBO.FN_GET_SCM_SITE_ID_PLANT(r.plant_id
--                                  , DBO.FN_GET_ITEM_OPERATION_GROUP(r.division_id, r.item_id)
--                                   ) AS scm_site_id
								   
SELECT DBO.FN_GET_SCM_SITE_ID_PLANT(r.plant_id
                                   ,(SELECT TOP 1 ISNULL(I.SCP_OPERATION_GROUP,'')
                                     FROM   DBO.SCM_MST_ITEM_SN              I WITH(NOLOCK)
                                     WHERE  1=1
                                     AND    I.ITEM_ID              = ISNULL(fi.packer_plan_item_id,r.item_id)
                                     AND    I.DIVISION_ID          = r.division_id
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
FROM   dbo.scm_dnm_fp_release_plan_v_sn r WITH(NOLOCK)
LEFT JOIN scp_mst_final_item fi --2018.06.29
ON   r.division_id = fi.division_id
AND  r.item_id = fi.item_id 
WHERE ISNULL(r.fp_production_type, '-') NOT IN ('TEST', 'REWORK', 'M/C') -- 2018.05.14, 2018.06.18  Kim Jihye
 -- TEST : 공장 내부 Test  'M/C' : 형교환계획


