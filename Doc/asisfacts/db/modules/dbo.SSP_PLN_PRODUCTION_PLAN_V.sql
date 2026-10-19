










CREATE VIEW [dbo].[SSP_PLN_PRODUCTION_PLAN_V] 
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SSP_PLN_WORK_ORDER_V
  * DESCRIPTION   : 생산계획(PLN-> ANL)
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018.06.12   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
  * 2018.06.29   LTW         전극 SSP 작업(ORIGIN_DIVISION_ID ,ELECTRODE_TYPE) 추가
  * 2018.06.29   LTW         SCM_MST_SITE.valid_yn = 'Y' 조건 추가
  * 2018.07.16   LTW         전극 SSP 작업(ORIGIN_DIVISION_ID ,ELECTRODE_TYPE) 추가
  * 2018.07.24   YYDOK        소형 특성후공정셀관련 공정코드추가(F6200,F7000,F7100,F7200,F7300)
  *                           left(WO.operation_id,1) <> 'F' --'F'로 시작하는 공정 제외=> left(WO.operation_id,5) NOT IN ( 'F1000','F6000') --활성화,특성제외 
  ****************************************************************************/


  SELECT 
        wo.master_id
       ,wo.out_version_id
       ,wo.plan_id
       ,wo.plan_type
       ,wo.plan_start_yyyymmdd
       ,wo.seq
       
       ,wo.division_id
       ,wo.operation_group
       ,wo.site_id
       ,wo.item_id
       ,wo.resource_id     
       ,wo.operation_id 
       ,(CASE wo.pegging_type WHEN 'WORK_ORDER' THEN CONVERT(NVARCHAR ,wo.start_time ,112) 
                              ELSE CONVERT(NVARCHAR ,wo.end_time ,112) 
          END)             AS yyyymmdd --생산계획:start_time ,출하계획:end_time
       ,(CASE wo.pegging_type WHEN 'WORK_ORDER' THEN wo.complete_qty 
                              ELSE wo.operation_qty 
          END)             AS qty --생산계획:complete_qty ,출하계획:operation_qty

       ,wo.origin_division_id       --전극 작업 추가
       ,wo.electrode_type           --전극 작업 추가

  FROM SSP_PLN_PRODUCTION_PLAN AS wo WITH(NOLOCK) 
 WHERE 1=1
   AND (LEFT(wo.operation_id,5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
                                    SELECT segment1 AS operation_id
                                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)   
                                     WHERE lookup_type = 'SCP_PLAN_OPERATION' )
         OR
         wo.operation_id        IN (--외주PACKER의 업체코드
                                    SELECT plant_id  AS operation_id
                                      FROM SCM_MST_SITE WITH(NOLOCK)      
                                     WHERE 1=1
                                       AND division_id = (CASE WHEN wo.division_id = 'EE' THEN wo.origin_division_id 
                                                               ELSE wo.division_id 
                                                          END)
                                       AND site_type   = 'PLANT'
                                       AND osp_yn      = 'Y'  
                                       AND valid_yn    = 'Y'
                                   ) 
       )
   AND LEFT(wo.operation_id,5) NOT IN ( 'F1000','F6000') --활성화,특성제외 
;



