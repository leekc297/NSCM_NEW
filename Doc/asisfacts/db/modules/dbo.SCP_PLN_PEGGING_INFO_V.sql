

CREATE VIEW [dbo].[SCP_PLN_PEGGING_INFO_V] 
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SCP_PLN_PEGGING_INFO_V
  * DESCRIPTION   : 
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018.02.02   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
  /*
  PLAN_ID,MODELING_ID,SEQ,PLAN_NAME,MASTER_ID,OUT_VERSION_ID
  */
  * 2018.03.23   YYDOK       PEGGING INFO에는 동일 WORK ORDER에 대해서 여러건의 자재투입수량이되어있어서
  *                          별도의 뷰를 구성하여 WORK ORDER별 DEMAND ID별 SUPPLY QTY를 조회할수있도록 변경
  *                          ( SCP_ENG_PEGGING_INFO_WO_V 신규적용)
  * 2018.04.05   YYDOK       통합테스트 오류수정(PEGGING 출하정보누락..PEGGING_TYPE조건제거)
  * 2018-04-06   LTW         scp_eng_pegging_info_wo_v.demand_id 값이 '-'인항목 제거 조건 추가
  * 2018-06-08   YYDOK       scp_eng_pegging_info_o_temp_sn 적용
  * 2018.07.09   LTW         전극 SCP 작업(ORIGIN_DIVISION_ID ,ELECTRODE_TYPE) 추가
  * 2018.09.07   LTW         TCO CELL 구분관련 로직 변경
  *                          SCP_ENG_PEGGING_INFO_WO_V.FROM_TCO_CELL_YN
  *                          SCP_ENG_PEGGING_INFO_O_TEMP_SN.ATTRIBUTE7(FROM TCO_CELL_YN)
  * 2018.09.18   LTW         SCP_ANL_PROBLEM_REPORT_PEGGING.PLANNED_QTY 의 수량을 완료 기준 수량(FROM_SITE 기준) 으로 변경
  *
  ****************************************************************************/

--생산계획(scp_pln_production_plan)
SELECT 
     pi.plan_id
    ,pi.modeling_id
    ,pi.seq                                   AS plan_seq
    ,pi.plan_name
    ,pi.master_id
    ,pi.out_version_id
    ,pi.plan_type
    ,pi.division_id
    ,pi.origin_from_division_id                                       --전극 작업 추가
    ,pi.origin_to_division_id                                         --전극 작업 추가
    
    ,pi.demand_priority
    ,pi.due_date
    
    ,pi.supply_qty as planned_qty --ANL작업을위해
    
    ,ISNULL(CONVERT(NVARCHAR(1000) ,pi.delivery_order_id),'')  AS delivery_order_id
    ,ISNULL(CONVERT(NVARCHAR(1000) ,pi.work_order_id)    ,'')  AS work_order_id
    ,NULL                                                      AS to_delivery_order_id
    ,NULL                                                      AS to_work_order_id
    
    ,pi.start_dttm
    ,pi.end_dttm
    ,dbo.fn_scm_split(site_id,1,'~')          AS from_site_id         --work order는 from site=to site
    ,dbo.fn_scm_split(site_id,1,'~')          AS to_site_id
    ,pi.item_id                               AS from_item_id
  
    --,fi.operation_group_id
    --,fi.electrode_type 
    ,pi.operation_group
    ,pi.electrode_type 

    ,pi.start_dttm                            AS plan_start_date      --ANL작업을위해
    ,pi.end_dttm                              AS plan_end_date        --ANL작업을위해
    
    /* SCP_ENG_PEGGING_INFO_WO_V
      FROM_OSP_YN
        TO_OSP_YN
      FROM_TCO_CELL_YN
        TO_TCO_CELL_YN
    */
    ,(CASE  WHEN pi.operation_group = 'E' THEN (CASE WHEN pi.work_order_id IS NOT NULL THEN 'ELEC' WHEN pi.delivery_order_id IS NOT NULL THEN 'ESHIP' END) 
            WHEN pi.operation_group = 'P' THEN (CASE WHEN pi.work_order_id IS NOT NULL THEN 'PACK' WHEN pi.delivery_order_id IS NOT NULL THEN 'PSHIP' END) 
            WHEN pi.operation_group = 'A' THEN (CASE WHEN PI.FROM_TCO_CELL_YN = 'Y'                                                      THEN 'TCELL'
                                                     WHEN SUBSTRING(pi.site_id,CHARINDEX('~', pi.site_id)-1 ,6) IN ('A~001')             THEN 'FORM'
                                                     WHEN SUBSTRING(pi.site_id,CHARINDEX('~', pi.site_id)-1 ,6) IN ('A~002')             THEN 'CHAR'
                                                     WHEN pi.work_order_id IS NOT NULL THEN 'CELL' WHEN pi.delivery_order_id IS NOT NULL THEN 'CSHIP' END) 
            ELSE '' 
      END)                                    AS pegging_operation_code -- 

    ,pi.demand_id                             AS eng_demand_id
    ,dbo.fn_scm_split(pi.demand_id,1,'##')    AS demand_id --##제거한 FCST기준 DEMAND

    ,dbo.fn_scm_split(pi.demand_id,1,'::')    AS demand_item_id  
    ,dbo.fn_scm_split(pi.demand_id,2,'::')    AS project_code
    ,dbo.fn_scm_split(pi.demand_id,3,'::')    AS eng_site_id  
    ,dbo.fn_scm_split(dbo.fn_scm_split(pi.demand_id,3,'::'),1,'~') AS sales_site_id
    ,dbo.fn_scm_split(dbo.fn_scm_split(pi.demand_id,3,'::'),2,'~') AS incoterms  
    ,dbo.fn_scm_split(pi.demand_id,4,'::')    AS dom_exp
    ,dbo.fn_scm_split(pi.demand_id,5,'::')    AS fcst_type
    ,dbo.fn_scm_split(pi.demand_id,6,'::')    AS demand_type 
    ,dbo.fn_scm_split(pi.demand_id,7,'::')    AS yyyymmdd             
    ,(CASE dbo.fn_scm_split(dbo.fn_scm_split(dbo.fn_scm_split(pi.demand_id,8,'::'),1,'^'),1,'##')
              WHEN 'NOPLANT' THEN '-'
              ELSE dbo.fn_scm_split(dbo.fn_scm_split(dbo.fn_scm_split(pi.demand_id,8,'::'),1,'^'),1,'##')
      END )                                   AS plant_site_id
     ,'WO'                                    AS descr
     ,NULL                                    AS stock_plan_lot_id
     ,PI.LPST

--SELECT * 
  FROM SCP_ENG_PEGGING_INFO_WO_V AS pi WITH(NOLOCK)
    --INNER JOIN SCM_MST_FINAL_ITEM_V AS fi 
    --   ON pi.division_id = fi.division_id 
    --  AND pi.item_id = fi.item_id
  WHERE 1=1 
    AND pi.demand_id <> 'UNPEGGING'
    AND pi.demand_id <> '-' 

UNION ALL 
--출하계획(scp_pln_shipment_plan)
SELECT 
     pi.plan_id
    ,pi.modeling_id
    ,pi.seq                                   AS plan_seq
    ,pi.plan_name
    ,pi.master_id
    ,pi.out_version_id
    ,pi.plan_type
    ,pi.division_id
    ,pi.origin_from_division_id                                     --전극 작업 추가
    ,pi.origin_to_division_id                                       --전극 작업 추가
    
    ,pi.demand_priority
    ,pi.due_date
    
    ,convert(NUMERIC(20,10) ,pi.qty)          AS planned_qty
    
    ,ISNULL(CONVERT(NVARCHAR(1000) ,pi.delivery_order_id)    ,'') AS delivery_order_id
    ,ISNULL(CONVERT(NVARCHAR(1000) ,pi.work_order_id)        ,'') AS work_order_id
    ,ISNULL(CONVERT(NVARCHAR(1000) ,pi.to_delivery_order_id) ,'') AS to_delivery_order_id
    ,ISNULL(CONVERT(NVARCHAR(1000) ,pi.to_work_order_id)     ,'') AS to_work_order_id
    
    ,pi.start_dttm
    ,pi.end_dttm
    ,dbo.fn_scm_split(pi.from_site_id,1,'~')  AS from_site_id
    ,dbo.fn_scm_split(pi.to_site_id,1,'~')    AS to_site_id
    
    ,pi.from_item_id
  
    --,fi.operation_group_id
    --,fi.electrode_type 
    ,pi.operation_group
    ,pi.electrode_type 

    ,pi.start_dttm                            AS plan_start_date    --ANL작업을위해
    ,pi.end_dttm                              AS plan_end_date      --ANL작업을위해
    
    /* ENG_PEGGING_INFO_O_TEMP_SN 속성정보
      ATTRIBUTE1 :   TO SITE_TYPE
      ATTRIBUTE2 :   TO OSP_YN
      ATTRIBUTE3 :   TO SITE_ID
      ATTRIBUTE4 : FROM SITE_ID
      ATTRIBUTE5 : FROM OSP_YN
      ATTRIBUTE6 :   TO OSP_YN
      ATTRIBUTE7 : FROM TCO_CELL_YN
      ATTRIBUTE8 :   TO TCO_CELL_YN
    */
    ,(CASE  WHEN pi.pegging_type = 'ALLOCATION' THEN 'ALLOC'                                            
            WHEN pi.operation_group = 'E' THEN (CASE WHEN pi.to_delivery_order_id IS NOT NULL THEN 'ESHIP' END) 
            WHEN pi.operation_group = 'P' THEN (CASE WHEN pi.to_delivery_order_id IS NOT NULL THEN 'PSHIP' END) 
            WHEN pi.operation_group = 'A' THEN (CASE WHEN SUBSTRING(pi.TO_SITE_ID,CHARINDEX('~', pi.TO_SITE_ID)-1 ,6) IN ('A~001') THEN 'FORM'
                                                     WHEN SUBSTRING(pi.TO_SITE_ID,CHARINDEX('~', pi.TO_SITE_ID)-1 ,6) IN ('A~002') THEN 'CHAR'
                                                     WHEN PI.ATTRIBUTE7 = 'Y'                                                      THEN 'TCSHIP'
                                                     WHEN pi.to_delivery_order_id IS NOT NULL                                      THEN 'CSHIP'   END) 
            ELSE '' 
      END)                                    AS pegging_operation_code -- 

    ,pi.demand_id                             AS eng_demand_id
    ,dbo.fn_scm_split(pi.demand_id,1,'##')    as demand_id --##제거한 FCST기준 DEMAND

    ,dbo.fn_scm_split(pi.demand_id,1,'::')    AS demand_item_id  
    ,dbo.fn_scm_split(pi.demand_id,2,'::')    AS project_code
    ,dbo.fn_scm_split(pi.demand_id,3,'::')    AS eng_site_id  
    ,dbo.fn_scm_split(dbo.fn_scm_split(pi.demand_id,3,'::'),1,'~') AS sales_site_id
    ,dbo.fn_scm_split(dbo.fn_scm_split(pi.demand_id,3,'::'),2,'~') AS incoterms  
    ,dbo.fn_scm_split(pi.demand_id,4,'::')    AS dom_exp
    ,dbo.fn_scm_split(pi.demand_id,5,'::')    AS fcst_type
    ,dbo.fn_scm_split(pi.demand_id,6,'::')    AS demand_type 
    ,dbo.fn_scm_split(pi.demand_id,7,'::')    AS yyyymmdd             
    ,(CASE dbo.fn_scm_split(dbo.fn_scm_split(dbo.fn_scm_split(pi.demand_id,8,'::'),1,'^'),1,'##')
              WHEN 'NOPLANT' THEN '-'
              ELSE dbo.fn_scm_split(dbo.fn_scm_split(dbo.fn_scm_split(pi.demand_id,8,'::'),1,'^'),1,'##')
         END )                                AS plant_site_id
     ,'DO'                                    AS descr 
     ,ISNULL(STOCK_PLAN_LOT_ID,'')            AS STOCK_PLAN_LOT_ID
  /*  --속도이슈존재
      , ( SELECT TOP 1 d.LPST
           FROM SCP_PLN_SHIPMENT_PLAN_PEGGING D WITH (NOLOCK) 
          WHERE D.DIVISION_ID =PI.DIVISION_ID
            AND D.PLAN_START_YYYYMMDD   = PI.PLAN_NAME
            AND D.PLAN_TYPE   = PI.PLAN_TYPE
            AND D.SEQ         = PI.SEQ
            AND D.ORDER_ID    = PI.DELIVERY_ORDER_ID )  AS LPST 
            */
     ,NULL AS LPST     

--SELECT * 
  FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN AS pi WITH(NOLOCK)
 WHERE 1=1 
	 AND ( 
	       ( pi.to_delivery_order_id IS NOT NULL 	AND pi.bod_id is not null AND pi.from_site_id <> pi.to_site_id ) --DELIVERY ORDER
	        OR
	       ( pi.pegging_type = 'ALLOCATION' )                                  --ALLOCATION
	     )   
   AND pi.from_site_id IS NOT NULL -- 있으면 않되는 케이스  
   AND pi.demand_id <> 'UNPEGGING'
   ;


