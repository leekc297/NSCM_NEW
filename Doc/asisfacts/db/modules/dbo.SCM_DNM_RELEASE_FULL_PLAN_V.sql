








CREATE VIEW [dbo].[SCM_DNM_RELEASE_FULL_PLAN_V]
/*
 * Program ID   : SCM_DNM_RELEASE_FULL_PLAN_V
 * Description  : FP 확정 계획 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 1. 26  Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018. 5. 14  Kim Jihye      fp_production_type TEST, REWORK 제외
 * 2018. 07.19  Kim jaejung    소형 대표 ITEM_ID 로 실적 생성 로직 추가 (소형)
 *
 */
AS

SELECT  B.SCM_SITE_ID,B.SITE_ID
	   ,A.INSTANCE_ID
       ,A.INSTANCE_DATE
       ,A.RELEASE_PLAN_ID
       ,A.AMEND_PLAN_ID
       ,A.DIVISION_ID
       ,A.FACTORY_ID
       ,A.PLAN_GROUP_ID
       ,A.WORK_ORDER_ID
       ,ISNULL(fi.packer_plan_item_id,A.item_id) ITEM_ID --2018.07.19
	   ,A.item_id ORIGIN_ITEM_ID --2018.07.19
       ,A.LINE_ID
       ,A.OPERATION_ID
       ,A.ELECTRODE_TYPE
       ,A.EQUIPMENT_ID
       ,A.FIX_TYPE
       ,A.PLAN_DATE
       ,A.START_TIME
       ,A.END_TIME
       ,A.PLAN_QTY
       ,A.PLAN_IN_QTY
       ,A.PRODUCTION_TYPE
       ,A.MARKET
       ,A.BATCH_ORDER_ID
       ,A.LANE_QTY
       ,A.ACTUAL_FLAG
       ,A.CLOSE_FLAG
       ,A.INSERT_ID
       ,A.INSERT_TIME
       ,A.MIN_ACTUAL_DATE
       ,A.RESULT_QTY
       ,A.RESULT_ERP_QTY
       ,A.PEGGING_RESULT_QTY
       ,A.ADJUST_PLAN_IN_QTY
       ,A.ADJUST_START_TIME
       ,A.IS_PREV_SCHEDULE
       ,A.TARGET_PRODUCTION_TYPE
       ,A.TARGET_CATEGORY
       ,A.TOP_ITEM_ID
       ,A.FP_PRODUCTION_TYPE
FROM   SCM_DNM_RELEASE_FULL_PLAN_H_SN A WITH(NOLOCK)
INNER JOIN 
      (SELECT  ZZ.PLAN_ID
              ,ZZ.FACTORY_ID
              ,ZZ.SITE_ID
              ,ZZ.PLAN_GROUP_ID
	          ,ZZ.SCM_SITE_ID
              ,ZZ.NUMS
       FROM ( SELECT  B.SITE_ID
                     ,A.INSTANCE_ID
                     ,INSTANCE_DATE
                     ,DIVISION_ID
                     ,B.FACTORY_ID
	                 --,dbo.FN_GET_SCM_SITE_ID_PLANT(B.PLANT_ID,dbo.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID,A.ITEM_ID)) AS SCM_SITE_ID
	                 ,dbo.FN_GET_SCM_SITE_ID_PLANT(B.PLANT_ID
					                             ,(SELECT TOP 1 ISNULL(I.SCP_OPERATION_GROUP,'')
                                                   FROM   DBO.SCM_MST_ITEM_SN              I WITH(NOLOCK)
                                                   WHERE  1=1
                                                   AND    I.DIVISION_ID          = A.DIVISION_ID
                                                   AND    I.ITEM_ID              = A.ITEM_ID
                                                  )
									             ) AS SCM_SITE_ID

                     ,A.PLAN_GROUP_ID
                     ,A.RELEASE_PLAN_ID AS PLAN_ID
                     ,ROW_NUMBER() OVER ( PARTITION BY  DIVISION_ID, INSTANCE_TYPE, B.FACTORY_ID, A.FACTORY_ID, A.PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) NUMS -- 마지막 RELEASE VERSION
              FROM   [DBO].SCM_DNM_RELEASE_FULL_PLAN_H_SN  A        
                    ,(SELECT  A.[INSTANCE_ID]
                             ,INSTANCE_TYPE
                             ,B.SITE_ID
                             ,B.FACTORY_ID
		                     ,B.PLANT_ID
                             ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
                             ,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
                      FROM   DBO.[SCM_MST_INSTANCE_FACTORY_SN] A WITH(NOLOCK)     
                            ,DBO.SCM_MST_FACTORY_SN B WITH(NOLOCK)
                            ,SCM_ADM_LOOKUP_VALUE_FP_SN SLV WITH(NOLOCK)
                      LEFT OUTER JOIN SCM_ADM_LOOKUP_VALUE_FP_SN MP WITH(NOLOCK)
                      ON     MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
                      AND    MP.SEGMENT1 = SLV.SEGMENT1
                      AND    SLV.ATTRIBUTE1 = 'PLAN GROUP'
                      WHERE  A.FACTORY_ID = B.FACTORY_ID     
                      AND    A.ACTIVE_FLAG = 'Y'     
                      AND    A.ACTIVE_FLAG = B.ACTIVE_FLAG     
                      AND    A.INSTANCE_ID != 'KR_CELL_M_P' -- 오창 소형 조립 테스트용 계획 SCM과 무관함
                      AND    SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
                      AND    SLV.SEGMENT1 = A.INSTANCE_ID) B      
              WHERE  A.INSTANCE_ID = B.INSTANCE_ID
              AND    A.FACTORY_ID = B.LINK_FACTORY_ID
              AND    A.PLAN_GROUP_ID = B.PLAN_GROUP_ID) ZZ       
       WHERE  ZZ.NUMS = 1) B
ON     A.RELEASE_PLAN_ID = B.PLAN_ID
AND    A.FACTORY_ID      = B.FACTORY_ID
AND    ISNULL(A.FP_PRODUCTION_TYPE, '-') NOT IN ('TEST', 'REWORK') -- 2018. 5. 14  Kim Jihye
LEFT JOIN scp_mst_final_item fi --2018.07.19
ON   A.division_id = fi.division_id
AND  A.item_id = fi.item_id 




