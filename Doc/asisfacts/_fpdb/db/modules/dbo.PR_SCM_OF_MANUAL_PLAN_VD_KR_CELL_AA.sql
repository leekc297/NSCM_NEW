CREATE PROCEDURE [dbo].[PR_SCM_OF_MANUAL_PLAN_VD_KR_CELL_AA]
   @p_master_id  nvarchar(max)  = '-',
   @p_plan_id    nvarchar(max)  = '-',
   @p_factory_id nvarchar(max)  = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_MANUAL_PLAN_VD_KR_CELL                                          **/
/** 프로그램 명   :                                                                           **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                               **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/** 20170420       ksjeon        KR_CELL A6000 공정계획 수동생성                              **/
/**===========================================================================================**/
/*
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_factory_id     nvarchar(30)
  DECLARE @confirm_plan_id  nvarchar(30)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_OF_MANUAL_PLAN_VD_KR_CELL'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
  DECLARE @v_operation_A6000 nvarchar(10)
  DECLARE @v_operation_A7000 nvarchar(10)
  DECLARE @v_cutoff_date     date
  
  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id
  SET @v_factory_id = @p_factory_id

  
  SET @v_operation_A6000 = 'A6000'
  SET @v_operation_A7000 = 'A7000'
 
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    -- 필수 DATA 쿼리.. 
    BEGIN
    
      --LOG 생성
      SET @v_table_name = 'SCM_FP_PLAN_H'
             
      SELECT 
             @plan_start_time = PLAN_START_TIME
           , @plan_end_time = (
                                CASE  WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_TIME)
                                      WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_TIME)
                                      WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_TIME)
                                                                      ELSE DATEADD(DD, PLAN_HORIZON,     PLAN_START_TIME)
                                END  
                              )
           , @key_date = CONVERT(NVARCHAR, PLAN_START_TIME, 112)
      FROM   SCM_FP_PLAN_H WITH(NOLOCK)
      WHERE  INSTANCE_ID = @v_master_id
      AND    PLAN_ID     = @v_plan_id             
             
             
      --LOG 생성
      SET @v_message = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

             
             
      SET @v_table_name = 'SCM_STOCK_H'
      SELECT @v_cutoff_date = max(cutoff_date)
      FROM   SCM_STOCK_H
      --WHERE  CUTOFF_DATE <= DATEADD(DD, 0, CONVERT(DATE, @key_date))   -- 하루전부터 탐색
      WHERE  CUTOFF_DATE = DATEADD(DD, 0, CONVERT(DATE, @key_date))   -- 오늘꺼만             
             
             
      --LOG 생성
      SET @v_message = 'CUTOFF_DATE : ' + CONVERT(nvarchar, @v_cutoff_date, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

    END;
        
    
---------------------------
-- KR_CELL A6000 계획 생성용 buf table 생성
-- fp_amend_production_plan_r -> TH_BUF_FP_AMEND_PROD_PLAN_R_A6K
---------------------------
    BEGIN
    
      SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_A6K'
      
      DELETE FROM TH_BUF_FP_AMEND_PROD_PLAN_R_A6K
      WHERE   MASTER_ID     = @v_master_id
      AND     PLAN_ID       = @v_plan_id
      and     AFTER_SITE_ID = @v_factory_id

      SET @v_message = @@ROWCOUNT
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_FP_AMEND_PROD_PLAN_R_A6K', 'DELETE', @n_log_count, null, @v_message, null 


      insert into th_buf_fp_amend_prod_plan_r_a6k
             (
              master_id,plan_id,work_order_id,before_site_id,after_site_id,before_route_id,after_route_id,before_operation_id
              ,after_operation_id,before_resource_id,after_resource_id,before_plan_date,after_plan_date,before_start_time
              ,after_start_time,before_end_time,after_end_time,working_time,before_seq,after_seq,before_qty,after_qty,before_in_qty
              ,after_in_qty,item_id,fixed_yn,split_yn,demand_id,demand_type,order_id,order_type,po_id,mfg_week,sop_week,org_work_order_id
              ,demand_due_date,batch_order_id,date_fix_flag,date_fix_date,operation_epst,operation_lpst,lane_qty,lane_tact_qty,item_uom
              ,wo_day_split_yn,setup_time,setup_time_uom,batch_qty,ui_edit_yn,description,insert_id,insert_time,update_id,update_time
              )
      select 
              master_id,plan_id,work_order_id,before_site_id,after_site_id,before_route_id,after_route_id,before_operation_id
              ,after_operation_id,before_resource_id,after_resource_id,before_plan_date,after_plan_date,before_start_time
              ,after_start_time,before_end_time,after_end_time,working_time,before_seq,after_seq,before_qty,after_qty,before_in_qty
              ,after_in_qty,item_id,fixed_yn,split_yn,demand_id,demand_type,order_id,order_type,po_id,mfg_week,sop_week,org_work_order_id
              ,demand_due_date,batch_order_id,date_fix_flag,date_fix_date,operation_epst,operation_lpst,lane_qty,lane_tact_qty,item_uom
              ,wo_day_split_yn,setup_time,setup_time_uom,batch_qty,ui_edit_yn,description,insert_id,insert_time,update_id,update_time
      from   fp_amend_production_plan_r
      where  master_id      = @v_master_id
      and    plan_id        = @v_plan_id
      and    after_site_id  = @v_factory_id
      
      SET @v_message = @@ROWCOUNT
      SET @v_table_name = 'TH_BUF_FP_AMEND_PROD_PLAN_R_A6K'
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
    END           


---------------------------
-- KR_CELL A6000 계획 생성용 buf table 생성
-- th_buf_A6000_plan_target (  site, route, item, plan_date 별 계획 대상 물량 구하기 )
---------------------------
    BEGIN
    
      SET @v_table_name = 'th_buf_A6000_plan_target'
      
      DELETE FROM th_buf_A6000_plan_target
      WHERE  MASTER_ID     = @v_master_id
      AND    PLAN_ID       = @v_plan_id
      AND    AFTER_SITE_ID = @v_factory_id

      SET @v_message = @@ROWCOUNT
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'th_buf_A6000_plan_target', 'DELETE', @n_log_count, null, @v_message, null 


      
      -- site, route, item, plan_date 별 계획 대상 물량 구하기     
      -- plan_qty > 0 인건이 PLAN 대상건
      insert into th_buf_a6000_plan_target
              (
              master_id,plan_id,after_site_id,after_route_id,after_operation_id,a7000_item_id, item_id,demand_type,a7000_plan_date,org_qty,r
              ,acu_org_qty,stock_qty,remain_qty,plan_qty,demand_id, insert_id,insert_time
              )

      select a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.a7000_item_id, a.item_id, a.demand_type, a.a7000_plan_date, a.org_qty
             , a.r
             , a.acu_org_qty
             , a.stock_qty
             , a.acu_org_qty - a.stock_qty as remain_qty
             -- 재고 차감후 생산 계획 수량
             , case when ( a.acu_org_qty - a.stock_qty ) <= 0 
                    then 0                                                             -- 전량 차감건
                    else ( case when ( a.org_qty - (a.acu_org_qty - a.stock_qty) ) > 0  
                                then ( (a.acu_org_qty - a.stock_qty) )                 -- 일부차감 -> 잔량 있는건 ( 원수량 - 차감잔량 )
                                else a.org_qty                                         -- 차감되지 않은건 ( 원수량유지 )
                            end  )
               end  
               as plan_qty
             , a.demand_id  
             ,  @v_proc_name AS INSERT_ID
             ,  GETDATE()    AS INSERT_TIME
      from   (
              select a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.A7000_item_id, a.item_id, a.demand_type, a.A7000_PLAN_DATE, a.org_qty
                     , dense_rank() over( partition by a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.item_id, a.demand_type
                                              order by a.A7000_item_id, a.A7000_PLAN_DATE ) 
                       as r
                     , sum(a.org_qty) over( partition by a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.item_id, a.demand_type
                                                order by a.A7000_item_id, a.A7000_PLAN_DATE ) 
                       as acu_org_qty
                     , b.stock_qty , b.fp_apply_item_id  
                     , a7000_org_qty
                     , a.demand_id
              from   (
                      select a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id
                             , a.A7000_item_id
                             -- Item에서 '_A6000' 제거 
                             , REPLACE(b.child_item_id, '_A6000', '') as item_id
                             , a.demand_type
                             , a.A7000_PLAN_DATE
                             , a.org_qty as a7000_org_qty -- ( A7000의 수량 )
                             , a.org_qty * b.child_item_rate as org_qty -- consume rate 적용 ( A6000의 필요량 )
                             , b.alt_priority 
                             , b.parent_item_rate, b.child_item_rate
                             , a.demand_id
                     from    (        
                             select a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id
                                     , a.item_id as A7000_item_id
                                     , a.demand_type
                                     , a.A7000_PLAN_DATE
                                     --, a.after_resource_id, a.after_plan_date, a.after_start_time
                                     , sum(a.after_qty) as org_qty
                                     --, a.after_in_qty
                                     , max(a.demand_id) as demand_id
                              from   (
                                      select  a.master_id
                                             , a.plan_id
                                             , a.after_site_id
                                             -------------------------------------------------
                                             -------------------------------------------------
                                             -- Hard coding된 아래 부분을 항상 확인할것 ksjeon
                                             , case when a.after_site_id = 'A1' then 'A1AV1'
                                                    when a.after_site_id = 'A2' then 'A2AV1'
                                                    when a.after_site_id = 'S2' then 'S2E01'
                                                    when a.after_site_id = 'A3' then 'A3AV1'
                                                    else a.after_route_id
                                               end as after_route_id     
                                             -------------------------------------------------
                                             , @v_operation_A6000 as after_operation_id
                                             , null as after_resource_id
                                             , null as after_plan_date
                                             , null as after_start_time
                                             , a.after_start_time as after_end_time
                                             , a.after_plan_date as A7000_PLAN_DATE
                                             --, CONVERT (VARCHAR(8), a.after_start_time, 112) as A7000_PLAN_DATE
                                             , a.after_in_qty as after_qty
                                             , null as after_in_qty
                                             , a.item_id
                                             , a.demand_type
                                             , a.demand_id
                                      from    (        
                                              select 
                                                      master_id,plan_id,work_order_id,before_site_id,after_site_id,before_route_id,after_route_id,before_operation_id
                                                      ,after_operation_id,before_resource_id,after_resource_id,before_plan_date,after_plan_date,before_start_time
                                                      ,after_start_time,before_end_time,after_end_time,working_time,before_seq,after_seq,before_qty,after_qty,before_in_qty
                                                      ,after_in_qty,item_id,fixed_yn,split_yn,demand_id,demand_type,order_id,order_type,po_id,mfg_week,sop_week,org_work_order_id
                                                      ,demand_due_date,batch_order_id,date_fix_flag,date_fix_date,operation_epst,operation_lpst,lane_qty,lane_tact_qty,item_uom
                                                      ,wo_day_split_yn,setup_time,setup_time_uom,batch_qty,ui_edit_yn,description,insert_id,insert_time,update_id,update_time
                                              from   fp_amend_production_plan_r
                                              where  master_id      = @v_master_id
                                              and    plan_id        = @v_plan_id
                                              and    after_site_id  = @v_factory_id
                                              --and    demand_id = N'A^A^20170424^ACEN1058I-A1^오창공장조립셀13호::PFD01000001'
                                              and    after_operation_id = @v_operation_A7000 --'A7000'
                                              ) a  
                                      ) a
                              --where  a.item_id = 'ABCAT0437A'        
                              group by a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.item_id, a.demand_type, a.A7000_PLAN_DATE
                              ) a          
                              inner join
                                  (
                                      -- A7000 공정에서 A6000의 Parent 기종 정보를 찾는다
                                      -- KR_CELL
                                      select distinct a.parent_item_id, a.child_item_id, a.alt_priority, a.parent_item_rate, a.child_item_rate
                                      from   lgce_fpdev.dbo.th_eng_plan_bom a
                                      where  a.master_id = @v_master_id
                                      and    a.plan_id   = @v_plan_id
                                      and    a.operation_id = @v_operation_A7000 --'A7000'
                                      and    exists  (
                                                      select 1 -- 자재 코드가 아닌것
                                                      from   lgce_fpdev.dbo.th_eng_item b
                                                      where  b.master_id = a.master_id
                                                      and    b.plan_id = a.plan_id
                                                      and    b.item_id = a.child_item_id
                                                      and    b.item_type != 'R'
                                                     )  
                                      and    charindex('STOCK', a.child_item_id) = 0                                      
                                      -- 운영용
--                                      select distinct a.parent_item_id, a.child_item_id, a.alt_priority, a.parent_item_rate, a.child_item_rate
--                                      from   kr_cell.dbo.th_eng_plan_bom a
--                                      where  a.master_id = @v_master_id
--                                      and    a.plan_id   = @v_plan_id
--                                      and    a.operation_id = @v_operation_A7000 --'A7000'
--                                      and    exists  (
--                                                      select 1 -- 자재 코드가 아닌것
--                                                      from   kr_cell.dbo.th_eng_item b
--                                                      where  b.master_id = a.master_id
--                                                      and    b.plan_id = a.plan_id
--                                                      and    b.item_id = a.child_item_id
--                                                      and    b.item_type != 'R'
--                                                      union all
--                                                      select 1 -- 자재 코드가 아닌것
--                                                      from   cn_cell.dbo.th_eng_item b
--                                                      where  b.master_id = a.master_id
--                                                      and    b.plan_id = a.plan_id
--                                                      and    b.item_id = a.child_item_id
--                                                      and    b.item_type != 'R'
--                                                      union all
--                                                      select 1 -- 자재 코드가 아닌것
--                                                      from   us_cell.dbo.th_eng_item b
--                                                      where  b.master_id = a.master_id
--                                                      and    b.plan_id = a.plan_id
--                                                      and    b.item_id = a.child_item_id
--                                                      and    b.item_type != 'R'
--                                                     )  
--                                      and    charindex('STOCK', a.child_item_id) = 0
--                                      union all
--                                       CN_CELL
--                                      select distinct a.parent_item_id, a.child_item_id, a.alt_priority, a.parent_item_rate, a.child_item_rate
--                                      from   cn_cell.dbo.th_eng_plan_bom a
--                                      where  a.master_id = @v_master_id
--                                      and    a.plan_id   = @v_plan_id
--                                      and    a.operation_id = @v_operation_A7000 --'A7000'
--                                      and    exists  (
--                                                      select 1 -- 자재 코드가 아닌것
--                                                      from   kr_cell.dbo.th_eng_item b
--                                                      where  b.master_id = a.master_id
--                                                      and    b.plan_id = a.plan_id
--                                                      and    b.item_id = a.child_item_id
--                                                      and    b.item_type != 'R'
--                                                      union all
--                                                      select 1 -- 자재 코드가 아닌것
--                                                      from   cn_cell.dbo.th_eng_item b
--                                                      where  b.master_id = a.master_id
--                                                      and    b.plan_id = a.plan_id
--                                                      and    b.item_id = a.child_item_id
--                                                      and    b.item_type != 'R'
--                                                      union all
--                                                      select 1 -- 자재 코드가 아닌것
--                                                      from   us_cell.dbo.th_eng_item b
--                                                      where  b.master_id = a.master_id
--                                                      and    b.plan_id = a.plan_id
--                                                      and    b.item_id = a.child_item_id
--                                                      and    b.item_type != 'R'
--                                                     )  
--                                      and    charindex('STOCK', a.child_item_id) = 0
--                                      union all
--                                       US_CELL
--                                      select distinct a.parent_item_id, a.child_item_id, a.alt_priority, a.parent_item_rate, a.child_item_rate
--                                      from   us_cell.dbo.th_eng_plan_bom a
--                                      where  a.master_id = @v_master_id
--                                      and    a.plan_id   = @v_plan_id
--                                      and    a.operation_id = @v_operation_A7000 --'A7000'
--                                      and    exists  (
--                                                      select 1 -- 자재 코드가 아닌것
--                                                      from   kr_cell.dbo.th_eng_item b
--                                                      where  b.master_id = a.master_id
--                                                      and    b.plan_id = a.plan_id
--                                                      and    b.item_id = a.child_item_id
--                                                      and    b.item_type != 'R'
--                                                      union all
--                                                      select 1 -- 자재 코드가 아닌것
--                                                      from   cn_cell.dbo.th_eng_item b
--                                                      where  b.master_id = a.master_id
--                                                      and    b.plan_id = a.plan_id
--                                                      and    b.item_id = a.child_item_id
--                                                      and    b.item_type != 'R'
--                                                      union all
--                                                      select 1 -- 자재 코드가 아닌것
--                                                      from   us_cell.dbo.th_eng_item b
--                                                      where  b.master_id = a.master_id
--                                                      and    b.plan_id = a.plan_id
--                                                      and    b.item_id = a.child_item_id
--                                                      and    b.item_type != 'R'
--                                                     )  
--                                      and    charindex('STOCK', a.child_item_id) = 0
                              ) b
                              on   a.A7000_item_id = b.parent_item_id
                     ) a 
                     left outer join
                         ( 
                          select factory_id
                                 ,fp_apply_item_id
                  --               , fp_apply_item_id
                                 , sum(qty) as stock_qty
                          --select company_id, division_id, site_id, plant_id, factory_id, item_id, available_date, sum(qty) as qty
                          from   scm_stock_h
                          where  cutoff_date = @v_cutoff_date --'2017-04-17'
                          and    stock_type  = 'WIP'
                          and    fp_apply_operation_id = @v_operation_A6000 --'A6000'
                          and    fp_apply_wipqty > 0
                          --and    fp_apply_item_id = 'ANPAN0474A'
                          and    available_date <= ( 
                                                      select max(a.plan_start_dttm)
                                                      from   (
                                                              select  -- PST
                                                                      a.plan_start_dttm
                                                              from   lgce_fpdev.dbo.th_mst_plan a
                                                              where  a.master_id = @v_master_id
                                                              and    a.plan_id   = @v_plan_id
                                                             
                                                              -- 운영용
--                                                              select  -- PST
--                                                                      a.plan_start_dttm
--                                                              from   kr_cell.dbo.th_mst_plan a
--                                                              where  a.master_id = @v_master_id
--                                                              and    a.plan_id   = @v_plan_id
--                                                              union all
--                                                              select  -- PST
--                                                                      a.plan_start_dttm
--                                                              from   cn_cell.dbo.th_mst_plan a
--                                                              where  a.master_id = @v_master_id
--                                                              and    a.plan_id   = @v_plan_id
--                                                              union all
--                                                              select  -- PST
--                                                                      a.plan_start_dttm
--                                                              from   us_cell.dbo.th_mst_plan a
--                                                              where  a.master_id = @v_master_id
--                                                              and    a.plan_id   = @v_plan_id
                                                             ) a 
                                                   )   
                          group by factory_id, fp_apply_item_id
                      ) b
                      on a.after_site_id = b.factory_id
                      and a.item_id      = b.fp_apply_item_id
              ) a
      order by a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.item_id, a.demand_type, a.A7000_item_id, a.A7000_PLAN_DATE
       


      SET @v_message = @@ROWCOUNT
      SET @v_table_name = 'th_buf_A6000_plan_target'
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
    END           

---------------------------
-- th_buf_a6000_plan_target -> S2의 Routr가 'A2AV1', 'S2E01'
--                             A2의 Routr가 'A2AV1', 'S2E01' 모두 가능하도록 변경
-- th_buf_A6000_plan_target_final 생성
---------------------------
    if @v_factory_id = 'A2'   or  
       @v_factory_id = 'S2'

      BEGIN
      
        SET @v_table_name = 'th_buf_A6000_plan_target_final'
        
        DELETE FROM th_buf_A6000_plan_target_final
        WHERE  MASTER_ID     = @v_master_id
        AND    PLAN_ID       = @v_plan_id
        AND    AFTER_SITE_ID = @v_factory_id

        SET @v_message = @@ROWCOUNT
        SET @n_log_count += 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'th_buf_A6000_plan_target_final', 'DELETE', @n_log_count, null, @v_message, null 


        insert into th_buf_A6000_plan_target_final
            (
             MASTER_ID,PLAN_ID,AFTER_SITE_ID,AFTER_ROUTE_ID,AFTER_OPERATION_ID,A7000_item_id
             ,ITEM_ID,DEMAND_TYPE,A7000_PLAN_DATE,ORG_QTY,R,ACU_ORG_QTY,STOCK_QTY,REMAIN_QTY
             ,PLAN_QTY,DEMAND_ID,INSERT_ID,INSERT_TIME,attb_1,attb_2,attb_3        
            ) 
        
        select a.master_id,a.plan_id,a.after_site_id
                ,b.route_id as after_route_id
                ,a.after_operation_id,a.a7000_item_id,a.item_id,a.demand_type,a.a7000_plan_date
                ,a.org_qty,a.r,a.acu_org_qty,a.stock_qty,a.remain_qty,a.plan_qty
                ,a.demand_id
                , @v_proc_name as insert_id, getdate() as insert_time
                ,a.after_route_id as attb_1
                , null as attb_2
                , null as attb_3        
        from ( 
                select a.master_id,a.plan_id,a.after_site_id
                        ,a.after_route_id
                        ,a.after_operation_id,a.a7000_item_id,a.item_id,a.demand_type,a.a7000_plan_date
                        ,a.org_qty,a.r,a.acu_org_qty,a.stock_qty,a.remain_qty,a.plan_qty
                        ,a.demand_id
                from   th_buf_a6000_plan_target a
                where  a.master_id    = @v_master_id
                and    a.plan_id      = @v_plan_id
                and    a.after_operation_id = @v_operation_A6000
                and    after_site_id = @v_factory_id
                ) a,
               (
                 -- 설비 할당 ( 개발 )
                  select a.master_id, a.plan_id, item_id, a.site_id, a.route_id, a.operation_id,  min(a.resource_id) as resource_group_id
                  from   lgce_fpdev.dbo.th_mst_op_resource a
                  where  a.master_id    = @v_master_id
                  and    a.plan_id      = @v_plan_id
                  and    a.operation_id = @v_operation_A6000 --'A6000'
                  group by a.master_id, a.plan_id, item_id, a.site_id, a.route_id, a.operation_id
                  ----------------
                  union all  -- 수동 생성
                  ----------------
                  select a.master_id, a.plan_id, a.item_id, a.site_id
                         , case when a.site_id = 'A2' then 'S2E01'
                                when a.site_id = 'S2' then 'A2AV1' else 'NA'
                           end  as route_id
                         , a.operation_id,  a.resource_id as resource_group_id
                  from   lgce_fpdev.dbo.th_mst_op_resource a
                  where  a.master_id    = @v_master_id
                  and    a.plan_id      = @v_plan_id
                  and    a.operation_id = @v_operation_A6000
                  and item_id in (                   
                                  select a.item_id 
                                  from   (
                                          select a.master_id, a.plan_id, a.item_id, count(*) as cnt
                                          from   (
                                                  select distinct a.master_id, a.plan_id, a.item_id, a.site_id
                                                  from   lgce_fpdev.dbo.th_mst_op_resource a
                                                  where  a.master_id    = @v_master_id
                                                  and    a.plan_id      = @v_plan_id
                                                  and    a.operation_id = @v_operation_A6000
                                                  and    a.site_id      in (  'A2', 'S2' ) 
                                                 ) a 
                                          group by a.master_id, a.plan_id, a.item_id
                                          having count(*) > 1
                                         ) a
                                 )                    
                  
                  -- 설비 할당 ( 운영 )
--                  select a.master_id, a.plan_id, a.item_id, a.site_id, a.route_id, a.operation_id,  min(a.resource_id) as resource_group_id
--                  from   kr_cell.dbo.th_mst_op_resource a
--                  where  a.master_id    = @v_master_id
--                  and    a.plan_id      = @v_plan_id
--                  and    a.operation_id = @v_operation_A6000 --'A6000'
--                  group by a.master_id, a.plan_id, item_id, a.site_id, a.route_id, a.operation_id
--                  ----------------
--                  union all  -- 수동 생성
--                  ----------------
--                  select a.master_id, a.plan_id, a.item_id, a.site_id
--                         , case when a.site_id = 'A2' then 'S2E01'
--                                when a.site_id = 'S2' then 'A2AV1' else 'NA'
--                           end  as route_id
--                         , a.operation_id,  a.resource_id as resource_group_id
--                  from   kr_cell.dbo.th_mst_op_resource a
--                  where  a.master_id    = @v_master_id
--                  and    a.plan_id      = @v_plan_id
--                  and    a.operation_id = @v_operation_A6000
--                  and item_id in (                   
--                                  select a.item_id 
--                                  from   (
--                                          select a.master_id, a.plan_id, a.item_id, count(*) as cnt
--                                          from   (
--                                                  select distinct a.master_id, a.plan_id, a.item_id, a.site_id
--                                                  from   kr_cell.dbo.th_mst_op_resource a
--                                                  where  a.master_id    = @v_master_id
--                                                  and    a.plan_id      = @v_plan_id
--                                                  and    a.operation_id = @v_operation_A6000
--                                                  and    a.site_id      in (  'A2', 'S2' ) 
--                                                 ) a 
--                                          group by a.master_id, a.plan_id, a.item_id
--                                          having count(*) > 1
--                                         ) a
--                                 )         
--                  union all
--                  select a.master_id, a.plan_id, a.item_id, a.site_id, a.route_id, a.operation_id,  min(a.resource_id) as resource_group_id
--                  from   cn_cell.dbo.th_mst_op_resource a
--                  where  a.master_id    = @v_master_id
--                  and    a.plan_id      = @v_plan_id
--                  and    a.operation_id = @v_operation_A6000 --'A6000'
--                  group by a.master_id, a.plan_id, item_id, a.site_id, a.route_id, a.operation_id
--                  union all
--                  select a.master_id, a.plan_id, a.item_id, a.site_id, a.route_id, a.operation_id,  min(a.resource_id) as resource_group_id
--                  from   us_cell.dbo.th_mst_op_resource a
--                  where  a.master_id    = @v_master_id
--                  and    a.plan_id      = @v_plan_id
--                  and    a.operation_id = @v_operation_A6000 --'A6000'
--                  group by a.master_id, a.plan_id, item_id, a.site_id, a.route_id, a.operation_id
              ) B
        where a.master_id = b.master_id
        and   a.plan_id = b.plan_id
        and   a.after_site_id = b.site_id
        and   a.after_operation_id = b.operation_id
        and   a.item_id = b.item_id

        SET @v_message = @@ROWCOUNT
        SET @v_table_name = 'th_buf_A6000_plan_target_final'
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END           


---------------------------
-- KR_CELL A6000 계획 생성
-- th_buf_A6000_plan_target_final -> fp_amend_production_plan_r 
-- WO 생성
---------------------------
    BEGIN
    
      SET @v_table_name = 'fp_amend_production_plan_r'
      
      delete from fp_amend_production_plan_r
      where   master_id     = @v_master_id
      and     plan_id       = @v_plan_id
      and     after_site_id = @v_factory_id
      and     after_operation_id = @v_operation_A6000 --'A6000'

      SET @v_message = @@ROWCOUNT
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'fp_amend_production_plan_r', 'DELETE', @n_log_count, null, @v_message, null 
      
    

      insert into fp_amend_production_plan_r
      (
              master_id,plan_id,work_order_id,before_site_id,after_site_id,before_route_id,after_route_id,before_operation_id
              ,after_operation_id,before_resource_id,after_resource_id,before_plan_date,after_plan_date,before_start_time
              ,after_start_time,before_end_time,after_end_time,working_time,before_seq,after_seq,before_qty,after_qty,before_in_qty
              ,after_in_qty,item_id,fixed_yn,split_yn,demand_id,demand_type,order_id,order_type,po_id,mfg_week,sop_week,org_work_order_id
              ,demand_due_date,batch_order_id,date_fix_flag,date_fix_date,operation_epst,operation_lpst,lane_qty,lane_tact_qty,item_uom
              ,wo_day_split_yn,setup_time,setup_time_uom,batch_qty,ui_edit_yn,description,insert_id,insert_time,update_id,update_time
             ) 

      select     
              a.master_id, a.plan_id 
              ----------------------------------------------------------------------------------------------------------------
      --        , a.wo_header
      --        , a.nation_cd
      --        , a.mass_sample
      --        , a.yymmdd_code
      --        , a.erp_operation_id  
      --        , a.after_site_id  ( Work order 번호가 factory 별로 돌릴때 중복될수 있어 보정코드로 넣음 ) 
      --        , b.order_id as SEQ                        
              , a.wo_header + a.nation_cd + a.mass_sample + a.yymmdd_code + a.erp_operation_id + a.after_site_id + b.order_id as work_order_id
              ----------------------------------------------------------------------------------------------------------------
              , a.before_site_id,      a.after_site_id
              , a.before_route_id,     a.after_route_id
              , a.before_operation_id, a.after_operation_id
              , a.before_resource_id,  a.after_resource_id
              , a.before_plan_date,    a.after_plan_date
              , a.before_start_time,   a.after_start_time
              , a.before_end_time,     a.after_end_time
              , a.working_time
              , a.before_seq,          a.after_seq
              , ceiling(a.before_qty)    as before_qty,          ceiling(a.after_qty)    as after_qty
              , ceiling(a.before_in_qty) as before_in_qty,       ceiling(a.after_in_qty) as after_in_qty
              , a.item_id
              , a.fixed_yn, a.split_yn, a.demand_id, a.demand_type, a.order_id, a.order_type, a.po_id, a.mfg_week, a.sop_week
              , a.org_work_order_id
              , a.demand_due_date
              , a.batch_order_id
              , a.date_fix_flag, a.date_fix_date, a.operation_epst,  a.operation_lpst, a.lane_qty
              , a.lane_tact_qty, a.item_uom,      a.wo_day_split_yn, a.setup_time,     a.setup_time_uom
              , a.batch_qty,     a.ui_edit_yn,    a.description
              , @v_proc_name as insert_id, getdate() as insert_time
              , @v_proc_name as update_id, getdate() as update_time
      from    (        
              select 
                      a.master_id, a.plan_id 
                      ----------------------------------------------------------------------------------------------------------------
                      , isnull(b.wo_header, 'M') as wo_header
                      , isnull(c.key_value, 'K') as nation_cd
                      , isnull(d.key_value, '1') as mass_sample
                      , SUBSTRING(a.fp_plan_date, 3, 2)
                        + CASE SUBSTRING(a.fp_plan_date, 5, 2)
                               WHEN '10' THEN 'A'
                               WHEN '11' THEN 'B'
                               WHEN '12' THEN 'C'
                               ELSE SUBSTRING(a.fp_plan_date, 6, 1)
                          END
                        + SUBSTRING(a.fp_plan_date, 7, 2)
                        as yymmdd_code
                      , isnull(erp_operation_id, 'VD') as erp_operation_id  
                      , row_number() over( partition by a.master_id, a.plan_id, a.after_operation_id
                                               order by a.after_plan_date, a.after_site_id, a.after_route_id, a.after_resource_id, a.item_id, a.after_seq )
                       as SEQ                        
                      , a.work_order_id
                      ----------------------------------------------------------------------------------------------------------------
                      , a.before_site_id,      a.after_site_id
                      , a.before_route_id,     a.after_route_id
                      , a.before_operation_id, a.after_operation_id
                      , a.before_resource_id,  a.after_resource_id
                      , a.before_plan_date,    a.after_plan_date
                      , a.before_start_time,   a.after_start_time
                      , a.before_end_time,     a.after_end_time
                      , a.working_time
                      , a.before_seq,          a.after_seq
                      , a.before_qty,          a.after_qty
                      , a.before_in_qty,       a.after_in_qty
                      , a.item_id
                      , a.fixed_yn, a.split_yn, a.demand_id, a.demand_type, a.order_id, a.order_type, a.po_id, a.mfg_week, a.sop_week
                      , a.org_work_order_id
                      , a.demand_due_date
                      , a.batch_order_id
                      , a.date_fix_flag, a.date_fix_date, a.operation_epst,  a.operation_lpst, a.lane_qty
                      , a.lane_tact_qty, a.item_uom,      a.wo_day_split_yn, a.setup_time,     a.setup_time_uom
                      , a.batch_qty,     a.ui_edit_yn,    a.description
              from    (
                      select 
                              a.master_id, a.plan_id, substring ( a.plan_id, charindex( '-', a.plan_id )+1, 8 ) as fp_plan_date
                              , null as work_order_id
                              , a.after_site_id as before_site_id, a.after_site_id
                              , a.after_route_id as before_route_id, a.after_route_id
                              , a.after_operation_id as before_operation_id, a.after_operation_id
                              , b.resource_group_id as before_resource_id, b.resource_group_id as after_resource_id
                              , convert( varchar, (convert(datetime, a.a7000_plan_date) - 1  ), 112) as before_plan_date, convert( varchar, (convert(datetime, a.a7000_plan_date) - 1  ), 112) as after_plan_date
                              , CONVERT(varchar,convert(datetime, a.a7000_plan_date) - 1, 112) + replace(CONVERT(varchar,convert(datetime, a.a7000_plan_date) - 1, 108), ':', '') as before_start_time
                              , CONVERT(varchar,convert(datetime, a.a7000_plan_date) - 1, 112) + replace(CONVERT(varchar,convert(datetime, a.a7000_plan_date) - 1, 108), ':', '') as after_start_time
                              , CONVERT(varchar,convert(datetime, a.a7000_plan_date) - 1, 112) + replace(CONVERT(varchar,convert(datetime, a.a7000_plan_date) - 1, 108), ':', '') as before_end_time
                              , CONVERT(varchar,convert(datetime, a.a7000_plan_date) - 1, 112) + replace(CONVERT(varchar,convert(datetime, a.a7000_plan_date) - 1, 108), ':', '') as after_end_time
--                              , convert(datetime, a.a7000_plan_date) - 1  as before_start_time
--                              , convert(datetime, a.a7000_plan_date) - 1  as after_start_time
--                              , convert(datetime, a.a7000_plan_date) - 1  as before_end_time
--                              , convert(datetime, a.a7000_plan_date) - 1  as after_end_time
                              , 0 as working_time
                              , dense_rank() over( partition by a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.item_id, a.demand_type
                                                       order by a.a7000_item_id, a.a7000_plan_date ) 
                                as before_seq
                              , dense_rank() over( partition by a.master_id, a.plan_id, a.after_site_id, a.after_route_id, a.after_operation_id, a.item_id, a.demand_type
                                                       order by a.a7000_item_id, a.a7000_plan_date ) 
                                as after_seq
                              , a.plan_qty as before_qty, a.plan_qty as after_qty, a.plan_qty as before_in_qty, a.plan_qty as after_in_qty
                              , a.item_id
                              , null as fixed_yn, null as split_yn
                              , a.demand_id
                              , a.demand_type, null as order_id, null as order_type, null as po_id, null as mfg_week, null as sop_week
                              , null as org_work_order_id
                              , null as demand_due_date, '-' as batch_order_id, null as date_fix_flag, null as date_fix_date, null as operation_epst, null as operation_lpst, null as lane_qty, null as lane_tact_qty, 'EA' as item_uom
                              , null as wo_day_split_yn, 0 as setup_time, 'SECOND' as setup_time_uom, null as batch_qty, null as ui_edit_yn, null as description
                      --select b.resource_group_id, a.*        
                      from   th_buf_A6000_plan_target_final a
                             inner join
                                 (
                                  -- 설비 할당 ( 개발 )
                                  select a.master_id, a.plan_id, a.item_id, a.site_id, a.route_id, a.operation_id,  min(a.resource_id) as resource_group_id
                                  from   lgce_fpdev.dbo.th_mst_op_resource a
                                  where  a.master_id    = @v_master_id
                                  and    a.plan_id      = @v_plan_id
                                  and    a.operation_id = @v_operation_A6000 --'A6000'
                                  group by a.master_id, a.plan_id, item_id, a.site_id, a.route_id, a.operation_id
                                  ----------------
                                  union all  -- 수동 생성
                                  ----------------
                                  select a.master_id, a.plan_id, a.item_id, a.site_id
                                         , case when a.site_id = 'A2' then 'S2E01'
                                                when a.site_id = 'S2' then 'A2AV1' else 'NA'
                                           end  as route_id
                                         , a.operation_id,  a.resource_id as resource_group_id
                                  from   lgce_fpdev.dbo.th_mst_op_resource a
                                  where  a.master_id    = @v_master_id
                                  and    a.plan_id      = @v_plan_id
                                  and    a.operation_id = @v_operation_A6000
                                  and item_id in (                   
                                                  select a.item_id 
                                                  from   (
                                                          select a.master_id, a.plan_id, a.item_id, count(*) as cnt
                                                          from   (
                                                                  select distinct a.master_id, a.plan_id, a.item_id, a.site_id
                                                                  from   lgce_fpdev.dbo.th_mst_op_resource a
                                                                  where  a.master_id    = @v_master_id
                                                                  and    a.plan_id      = @v_plan_id
                                                                  and    a.operation_id = @v_operation_A6000
                                                                  and    a.site_id      in (  'A2', 'S2' ) 
                                                                 ) a 
                                                          group by a.master_id, a.plan_id, a.item_id
                                                          having count(*) > 1
                                                         ) a
                                                 )                                   
                                 
                                  -- 설비 할당 ( 운영 )
--                                  select a.master_id, a.plan_id, a.item_id, a.site_id, a.route_id, a.operation_id,  min(a.resource_id) as resource_group_id
--                                  from   kr_cell.dbo.th_mst_op_resource a
--                                  where  a.master_id    = @v_master_id
--                                  and    a.plan_id      = @v_plan_id
--                                  and    a.operation_id = @v_operation_A6000 --'A6000'
--                                  group by a.master_id, a.plan_id, item_id, a.site_id, a.route_id, a.operation_id
--                                  ----------------
--                                  union all  -- 수동 생성
--                                  ----------------
--                                  select a.master_id, a.plan_id, a.item_id, a.site_id
--                                         , case when a.site_id = 'A2' then 'S2E01'
--                                                when a.site_id = 'S2' then 'A2AV1' else 'NA'
--                                           end  as route_id
--                                         , a.operation_id,  a.resource_id as resource_group_id
--                                  from   kr_cell.dbo.th_mst_op_resource a
--                                  where  a.master_id    = @v_master_id
--                                  and    a.plan_id      = @v_plan_id
--                                  and    a.operation_id = @v_operation_A6000
--                                  and item_id in (                   
--                                                  select a.item_id 
--                                                  from   (
--                                                          select a.master_id, a.plan_id, a.item_id, count(*) as cnt
--                                                          from   (
--                                                                  select distinct a.master_id, a.plan_id, a.item_id, a.site_id
--                                                                  from   kr_cell.dbo.th_mst_op_resource a
--                                                                  where  a.master_id    = @v_master_id
--                                                                  and    a.plan_id      = @v_plan_id
--                                                                  and    a.operation_id = @v_operation_A6000
--                                                                  and    a.site_id      in (  'A2', 'S2' ) 
--                                                                 ) a 
--                                                          group by a.master_id, a.plan_id, a.item_id
--                                                          having count(*) > 1
--                                                         ) a
--                                                 )         
--                                  union all
--                                  select a.master_id, a.plan_id, a.item_id, a.site_id, a.route_id, a.operation_id,  min(a.resource_id) as resource_group_id
--                                  from   cn_cell.dbo.th_mst_op_resource a
--                                  where  a.master_id    = @v_master_id
--                                  and    a.plan_id      = @v_plan_id
--                                  and    a.operation_id = @v_operation_A6000 --'A6000'
--                                  group by a.master_id, a.plan_id, item_id, a.site_id, a.route_id, a.operation_id
--                                  union all
--                                  select a.master_id, a.plan_id, a.item_id, a.site_id, a.route_id, a.operation_id,  min(a.resource_id) as resource_group_id
--                                  from   us_cell.dbo.th_mst_op_resource a
--                                  where  a.master_id    = @v_master_id
--                                  and    a.plan_id      = @v_plan_id
--                                  and    a.operation_id = @v_operation_A6000 --'A6000'
--                                  group by a.master_id, a.plan_id, item_id, a.site_id, a.route_id, a.operation_id
                             ) b
                             on   a.master_id = b.master_id
                             and  a.plan_id   = b.plan_id
                             and  a.after_operation_id = b.operation_id
                             and  a.after_site_id      = b.site_id
                             and  a.after_route_id     = b.route_id
                             and  a.item_id            = b.item_id  
                      where  a.master_id     = @v_master_id
                      and    a.plan_id       = @v_plan_id
                      and    a.after_site_id = @v_factory_id
                      and    a.plan_qty      > 0 
                     ) a 
                     left outer join
                         (
                          -- M ( 기확정은 사용안함 )WO_Header
                          select distinct operation_id,
                                 --company_id, division_id, site_id, operation_id, operation_name, erp_operation_id, capa_type,
                                 case when wo_flag = 'Y' 
                                      then 'W' 
                                      else 'M' 
                                 end  as WO_header 
                          from   SCM_OPERATION_M
                          where  operation_id = @v_operation_A6000 --'A6000'
                     ) b
                         on   a.after_operation_id = b.operation_id
                     left outer join
                         (
                          -- 국가코드
                          select instance_id, key_value  
                          from   fp_instance_config_m
                          where  1=1
                          and    INSTANCE_ID = @v_master_id
                          AND    CATEGORY_ID = 'EXPORT'
                          AND    KEY_ID      = 'INSTANCE_CODE'
                     ) c
                         on   a.master_id = c.instance_id
                     left outer join
                         (
                          -- 샘플양산 구분
                          select KEY_ID, key_value 
                          from   FP_INSTANCE_CONFIG_M
                          where  1=1
                          and    INSTANCE_ID = 'COMMON'
                          AND    KEY_ID      = 'MASS'
                     ) d
                         on   a.demand_type = d.KEY_ID
                     left outer join
                         (
                          -- erp_operation_id
                          select distinct operation_id,
                                 --company_id, division_id, site_id, operation_id, operation_name, erp_operation_id, capa_type,
                                 erp_operation_id
                          from   SCM_OPERATION_M
                          where  operation_id = @v_operation_A6000 --'A6000'
                     ) e
                         on   a.after_operation_id = b.operation_id
             ) a
             inner join
                 -- seq로 WO seq 를 찾는다 
                 ( select order_no, order_id from FP_ORDER_SEQ
             ) b
             on a.seq = b.order_no
      order by a.wo_header, a.nation_cd, a.mass_sample, a.yymmdd_code, a.erp_operation_id, b.order_id


      SET @v_message = @@ROWCOUNT
      SET @v_table_name = 'fp_amend_production_plan_r'
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
    END           

  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
