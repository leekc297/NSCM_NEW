CREATE PROCEDURE [dbo].[PR_SCM_MF_PREFER_TACT_SETUP_WEEK]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-', @p_operation_01 nvarchar(MAX) = '-', @p_operation_02 nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MF_PREFER_TACT_SETUP                                               **/
/** 프로그램 명   :                                                                           **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/**  [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2016.08.18    LJH          최초 작성                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_MF_PREFER_TACT_SETUP
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_plan_type      nvarchar(30)
  DECLARE @v_operation_01    nvarchar(30)
  DECLARE @v_operation_02    nvarchar(30)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_MF_PREFER_TACT_SETUP_WEEK'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)
  DECLARE @v_daydiff        Integer
  DECLARE @v_config_set_id  nvarchar(30)
  DECLARE @v_late_type      nvarchar(30)

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)

  DECLARE @v_chk_run_seq      nvarchar(20)    -- JIT Layered Planning 실행 여부 확인
  DECLARE @v_chk_batch_cnt    int             -- BATCH ITEM 존재유무 확인

  DECLARE @v_prefer_res_cum   nvarchar(3000)
  DECLARE @v_prefer_item_cum  nvarchar(3000)
  DECLARE @n_capa_effi        Float  = 1.0  -- ## 라인 버퍼효율 설정 : 110% 수준
  DECLARE @n_adj_rate         Float  = 0.07  -- ## 할당 보정비율 설정 : 7% 수준
  DECLARE @n_dmd_remain_qty   Float  = 0.0
  
  -------------------------------------------------------------------------------------------
  -- LINE 인지 EQUIPMENT 인지 설정하는 변수... 아주 중요
  -------------------------------------------------------------------------------------------
   DECLARE @res_category      nvarchar(10)
  -------------------------------------------------------------------------------------------

  SET @v_master_id    = @p_master_id
  SET @v_plan_id      = @p_plan_id
  SET @v_operation_01 = @p_operation_01
  SET @v_operation_02 = @p_operation_02
  SET @v_plan_type    = NULL
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    -- 필수 DATA 쿼리.. 반듯이 있어야 함.
    BEGIN

      --LOG 생성
      SET @v_table_name = 'TH_MST_PLAN'
      SELECT  @plan_start_time = PLAN_START_DTTM,
              @plan_end_time   = PLAN_END_DTTM,
              @key_date = PLAN_DATE,
              @v_plan_type = PLAN_TYPE,
              @v_config_set_id = CONFIG_SET_ID,
              @v_daydiff = DAYDIFF
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM,
                     PLAN_DATE, PLAN_TYPE,
                     CONFIG_SET_ID,
                     DATEDIFF(MINUTE,CONVERT(DATE,PLAN_START_DTTM), PLAN_START_DTTM) AS DAYDIFF
              FROM   TH_MST_PLAN
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id
             ) A
             
             
      --LOG 생성
      SET @v_message = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112) + ' / PlanType : ' + @v_plan_type
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null


      SET @v_table_name = 'FP_INSTANCE_CONFIG_M'

      SELECT  @res_category = isnull(max(key_value), 'LINE')
      FROM    SY_FP_INSTANCE_CONFIG_M
      WHERE   instance_id = @v_master_id
      AND     category_id = 'RESOURCE_CATEGORY'
      AND     KEY_ID = @v_plan_type

      --LOG 생성
      SET @v_message = '@res_category : ' + @res_category
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null


    END;

    -- ## JIT Layered Planning 실행 여부 확인..!!
    BEGIN
    
      SET @v_table_name = 'TH_MST_ENG_PLAN_FLAG'
      SET @v_chk_run_seq = 'NULL'
    
      SELECT @v_chk_run_seq = isnull(descr,'NULL')
      FROM   TH_MST_ENG_PLAN_FLAG
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
      AND    OUT_VERSION_ID = @v_plan_id
    
      --LOG 생성
      SET @v_message = '@v_chk_run_seq : ' + @v_chk_run_seq
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

    END

    BEGIN
    
      -- ## 데이터 삭제
      delete from th_buf_scm_prefer_alloc_rate          
      
      delete from th_buf_scm_prefer_item_arrange
      delete from th_buf_scm_prefer_demand
      delete from th_buf_scm_prefer_demand_result
      delete from th_buf_scm_prefer_resource
      delete from th_buf_scm_prefer_demand_assign
      delete from th_buf_scm_prefer_demand_split
      
      delete from th_buf_scm_prefer_timeline
      delete from th_buf_scm_prefer_item_bor

      -- ## 과거 백업 데이터 삭제
      delete from th_buf_scm_prefer_alloc_rate_his      where master_id   = @v_master_id and insert_dttm < dateadd(day, -7, getdate())
      delete from th_buf_scm_prefer_item_arrange_his    where master_id   = @v_master_id and insert_dttm < dateadd(day, -7, getdate())
      delete from th_buf_scm_prefer_demand_his          where master_id   = @v_master_id and insert_dttm < dateadd(day, -7, getdate())
      delete from th_buf_scm_prefer_demand_result_his   where master_id   = @v_master_id and insert_dttm < dateadd(day, -7, getdate())
      delete from th_buf_scm_prefer_resource_his        where master_id   = @v_master_id and insert_dttm < dateadd(day, -7, getdate())
      delete from th_buf_scm_prefer_demand_assign_his   where master_id   = @v_master_id and insert_dttm < dateadd(day, -7, getdate())
      delete from th_buf_scm_prefer_demand_split_his    where instance_id = @v_master_id and key_date    < dateadd(day, -7, getdate())

      -- ## 해당 백업 데이터 삭제
      delete from th_buf_scm_prefer_alloc_rate_his      where master_id   = @v_master_id and plan_id      = @v_plan_id
      delete from th_buf_scm_prefer_item_arrange_his    where master_id   = @v_master_id and plan_id      = @v_plan_id
      delete from th_buf_scm_prefer_demand_his          where master_id   = @v_master_id and plan_id      = @v_plan_id
      delete from th_buf_scm_prefer_demand_result_his   where master_id   = @v_master_id and plan_id      = @v_plan_id
      delete from th_buf_scm_prefer_resource_his        where master_id   = @v_master_id and plan_id      = @v_plan_id
      delete from th_buf_scm_prefer_demand_assign_his   where master_id   = @v_master_id and plan_id      = @v_plan_id
      delete from th_buf_scm_prefer_demand_split_his    where instance_id = @v_master_id and dpp_plan_id  = @v_plan_id

    END


    -----------------------------------------------------------------
    -- ## PRE / SYNC에 따라 Prefer Process 구분 처리..!!
    -----------------------------------------------------------------
    
    IF @v_plan_type = 'PRE'
            
      BEGIN
        
        /*
          th_buf_scm_prefer_demand 데이터 생성
        */
        
        BEGIN
        
          SET @v_table_name = 'th_buf_scm_prefer_demand'

          insert into th_buf_scm_prefer_demand
               ( master_id, plan_id, division_id, mfg_week, item_id, target_demand_id, market, early_week, fence_week, assign_cnt, mfg_qty, 
                 req_qty, alloc_qty, remain_qty, prefer_resource, setup_group_id, lot_size,insert_dttm )   
          select a.master_id, a.plan_id, a.division_id, a.mfg_week, a.item_id, a.target_demand_id, market, early_week, fence_week,
                 b.assign_cnt, a.mfg_qty, 
                 a.mfg_qty as req_qty, 0 as alloc_qty, 
                 a.mfg_qty as remain_qty, '' as prefer_resource, 
                 c.setup_group_id, a.mfg_qty as lot_size, getdate() as insert_dttm
          from   (select a.master_id, a.plan_id, b.division_id, a.mfg_week, a.item_id, a.demand_id as target_demand_id, a.market,
                  c.week as  early_week, d.week as fence_week, 
                  sum(a.qty) as mfg_qty
                  from   th_dpp_net_demand a,
                         (select fp_demand_id as demand_id, 
                                 max(division_id) as division_id
                          from   sy_fp_daily_net_demand_h 
                          where  instance_id = @v_master_id
                          and    dpp_plan_id = @v_plan_id
                          group by fp_demand_id) b,
                         sy_scm_sys_calendar_m c,
                         sy_scm_sys_calendar_m d
                  where  a.net_demand_id = b.demand_id
                  and    a.master_id = @v_master_id
                  and    a.plan_id = @v_plan_id
                  and    isnull(a.po_type,'NULL') <> 'FIX'      -- ## 확정  Demand는 제외..!!
                  and    isnull(a.po_type,'NULL') <> 'STOCK'    -- ## STOCK Demand는 제외..!!
                  and    isnull(a.order_type,'NULL') <> 'TEST'  -- ## TEST  Demand는 제외..!!
                  and    a.due_date - a.early_producing_term + 1 = c.date_id            -- 할당 가능 주차 ( 시작주차 )
                  and    a.due_fence_date = d.date_id                                   -- 할당 가능 주차 ( 종료주차 )
                  and    a.qty > 0
                  group by a.master_id,a.plan_id,b.division_id,a.mfg_week,a.item_id,a.demand_id,a.market,c.week, d.week) a,
                 (select item_id, count(route_id) as assign_cnt
                  from   th_mst_op_resource
                  where  master_id = @v_master_id
                  and    plan_id = @v_plan_id
                  and    operation_id in ( @v_operation_01, @v_operation_02 )
                  and    alt_priority in (1,2,3,4,5,6,7,8)    -- 0, 9 번은 대상에서 제외되므로 조건처리
                  group by item_id) b,
                 (select item_id, isnull(max(irs_attb_2),'-') as setup_group_id   -- operation 별 setup 이 다름
                  from   th_mst_item_route_site
                  where  master_id = @v_master_id
                  and    plan_id = @v_plan_id
                  and    operation_id in ( @v_operation_01, @v_operation_02 )
                  group by item_id) c
          where  a.item_id = b.item_id
          and    a.item_id = c.item_id

          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          -- 위에서 1차 생산수량 넣고, 실제 LOT 이 있는 것만 UPDATE 한다.
          UPDATE TH_BUF_SCM_PREFER_DEMAND
          SET    TH_BUF_SCM_PREFER_DEMAND.LOT_SIZE = B.PLANT_LOT_SIZE
          FROM   TH_BUF_SCM_PREFER_DEMAND A,
                 (
                  SELECT DIVISION_ID, ITEM_ID, MAX(PLANT_LOT_SIZE) AS PLANT_LOT_SIZE 
                  FROM   TH_MST_SCM_DEMAND_LOT
                  WHERE  DPP_PLAN_ID = @v_plan_id
                  AND    PLANT_LOT_SIZE IS NOT NULL
                  AND    PLANT_LOT_SIZE > 0
                  GROUP  BY DIVISION_ID, ITEM_ID
                 ) B
          WHERE  A.MASTER_ID = @v_master_id
          AND    A.PLAN_ID = @v_plan_id
          AND    A.DIVISION_ID = B.DIVISION_ID
          AND    A.ITEM_ID = B.ITEM_ID

          
        END


        /*
          th_buf_scm_prefer_item_arrange 데이터 생성
        */
        
        BEGIN
        
          -- 구간별 tact 정보를 설정하기 위함
          SET @v_table_name = 'th_buf_scm_prefer_timeline'
          
          insert into th_buf_scm_prefer_timeline
                (master_id, plan_id, site_id, route_id, operation_id, resource_id, mfg_week, time_line, insert_time)
          select master_id, plan_id, site_id, route_id, operation_id, resource_id, b.week as mfg_week, time_line
               , getdate() as insert_time
          from   (
                  select master_id, plan_id, site_id, route_id, operation_id, resource_id, time_line
                  from   (
                          select master_id, plan_id, site_id, route_id, operation_id, resource_id, time_line
                          from   (
                                  select master_id, plan_id, site_id, route_id, operation_id, resource_id, start_date as time_line
                                  from   th_mst_op_resource_cal
                                  where  master_id    = @v_master_id
                                  and    plan_id      = @v_plan_id
                                  and    operation_id in ( @v_operation_01, @v_operation_02 )
                                  union  all
                                  select master_id, plan_id, site_id, route_id, operation_id, resource_id, end_date   as time_line
                                  from   th_mst_op_resource_cal
                                  where  master_id    = @v_master_id
                                  and    plan_id      = @v_plan_id
                                  and    operation_id in ( @v_operation_01, @v_operation_02 )
                                 ) a
                          union  all
                          select master_id, plan_id, site_id, route_id, operation_id, resource_id, time_line
                          from   (
                                  select master_id, plan_id, site_id, route_id, operation_id, resource_id 
                                  from   th_mst_op_resource
                                  where  master_id    = @v_master_id
                                  and    plan_id      = @v_plan_id
                                  and    operation_id in ( @v_operation_01, @v_operation_02 )
                                 ) a,
                                 (
                                  select dateadd(minute, diff, convert(datetime, week_date)) as time_line
                                  from   (
                                          select week, min(date_id) as week_date,
                                                 datediff(minute, convert(date, @plan_start_time), convert(datetime, @plan_start_time)) diff
                                          from   sy_scm_sys_calendar_m a
                                          where  date_id between convert(date, @plan_start_time)
                                                             and dateadd(day, 7, convert(date, @plan_end_time))
                                          group  by week
                                         ) a
                                 ) b
                          where  1=1
                         ) a
                  group  by master_id, plan_id, site_id, route_id, operation_id, resource_id, time_line
                 ) A,
                 sy_scm_sys_calendar_m b
          where  convert(date, time_line) = b.date_id       
                  
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


          SET @v_table_name = 'th_buf_scm_prefer_item_bor'
                  
          insert into th_buf_scm_prefer_item_bor
               (
                 master_id, plan_id, division_id, item_id, site_id, route_id, operation_id, mfg_week
               , week_days, week_run_days, tact_time, alt_priority
               )
          select a.master_id, a.plan_id, a.division_id, a.item_id, a.site_id, a.route_id, a.operation_id
               , a.mfg_week
               , sum(day_diff) as week_days
               , sum(day_diff_run) as week_run_days
               , case when sum(day_diff_run)  = 0 then 0.0          -- 작업일수가 0 인것
                      else sum(day_diff_tact) / sum(day_diff_run)
                 end  yield_tact
               , max(run_priority) as alt_priority
          from   (
                  select a.*
                       , day_diff * tact_time / (case when yield = 0 then 1 else yield end) as day_diff_tact
                       , case when is_use = 'N'               then 0
                              when alt_priority in ('0','9')  then 0
                              else day_diff
                         end  day_diff_run
                       , case when alt_priority in ('0','9') then 1
                              else alt_priority
                         end  run_priority
                  from   (
                          select 
                                 a.master_id, a.plan_id, a.division_id, a.item_id, a.site_id, a.route_id, a.operation_id
                               , a.resource_id, a.mfg_week, a.start_time, a.end_time
                               , isnull(d.alt_priority, a.alt_priority)   as alt_priority
                               , isnull(d.tact_time, a.tact_time)         as tact_time
                               , isnull(d.yield, a.yield)                 as yield
                               , isnull(d.is_use, a.is_use)               as is_use
                               , datediff(day, a.start_time, a.end_time)  as day_diff
                          from   (
                                  select a.master_id, a.plan_id, c.res_attb_12 as division_id, b.item_id, a.site_id, a.route_id, a.operation_id
                                       , a.resource_id, a.mfg_week, a.time_line as start_time
                                       , lead(a.time_line, 1, null) over (partition by a.master_id, a.plan_id, b.item_id, a.site_id
                                                                                     , a.route_id, a.operation_id, a.resource_id 
                                                                          order     by a.time_line) as end_time
                                       , b.alt_priority, b.tact_time, b.yield, 'Y' as is_use
                                  from   th_buf_scm_prefer_timeline a
                                       , th_mst_op_resource b
                                       , th_mst_resource c
                                  where  a.master_id    = @v_master_id
                                  and    a.plan_id      = @v_plan_id
                                  and    a.master_id    = b.master_id
                                  and    a.plan_id      = b.plan_id
                                  and    a.site_id      = b.site_id
                                  and    a.route_id     = b.route_id
                                  and    a.operation_id = b.operation_id
                                  and    a.resource_id  = b.resource_id
                                  and    a.master_id    = c.master_id
                                  and    a.plan_id      = c.plan_id
                                  and    a.resource_id  = c.resource_id
                                 ) a
                                 left outer join th_mst_op_resource_cal d
                                      on     a.master_id    = d.master_id
                                      and    a.plan_id      = d.plan_id
                                      and    a.item_id      = d.item_id
                                      and    a.site_id      = d.site_id
                                      and    a.route_id     = d.route_id
                                      and    a.operation_id = d.operation_id
                                      and    a.resource_id  = d.resource_id
                                      and    a.start_time  >= d.start_date
                                      and    a.end_time    <= d.end_date
                          where  end_time is not null
                         ) a
                 ) a
          group  by
                 a.master_id, a.plan_id, a.division_id, a.item_id, a.site_id, a.route_id, a.operation_id
               , a.mfg_week
          /*
          select a.master_id, a.plan_id, a.division_id, a.item_id, a.site_id, a.route_id, a.operation_id
               , a.mfg_week
               , sum(day_diff) as week_days
               , sum(day_diff_run) as week_run_days
               , case when sum(day_diff_run)  = 0 then 0.0          -- 작업일수가 0 인것
                      else sum(day_diff_tact) / sum(day_diff_run)
                 end  yield_tact
               , max(run_priority) as alt_priority
          from   (
                  select a.*
                       , day_diff * tact_time / (case when yield = 0 then 1 else yield end) as day_diff_tact
                       , case when is_use = 'N'               then 0
                              when alt_priority in ('0','9')  then 0
                              else day_diff
                         end  day_diff_run
                       , case when alt_priority in ('0','9') then 1
                              else alt_priority
                         end  run_priority
                  from   (
                          select 
                                 a.master_id, a.plan_id, a.division_id, a.item_id, a.site_id, a.route_id, a.operation_id
                               , a.resource_id, a.mfg_week, a.start_time, a.end_time
                               , a.alt_priority, a.tact_time, a.yield, a.is_use
                               , datediff(day, a.start_time, a.end_time) as day_diff
                          from   (
                                  select a.master_id, a.plan_id, c.res_attb_12 as division_id, b.item_id, a.site_id, a.route_id, a.operation_id
                                       , a.resource_id, a.mfg_week, a.time_line as start_time
                                       , lead(time_line, 1, null) over (partition by a.master_id, a.plan_id, b.item_id, a.site_id
                                                                                   , a.route_id, a.operation_id, a.resource_id 
                                                                        order     by time_line) as end_time
                                       , b.alt_priority, b.tact_time, b.yield, b.is_use
                                  from   th_buf_scm_prefer_timeline a,
                                         th_mst_op_resource_cal b,
                                         th_mst_resource c
                                  where  a.master_id    = @v_master_id
                                  and    a.plan_id      = @v_plan_id
                                  and    a.master_id    = b.master_id
                                  and    a.plan_id      = b.plan_id
                                  and    a.site_id      = b.site_id
                                  and    a.route_id     = b.route_id
                                  and    a.operation_id = b.operation_id
                                  and    a.resource_id  = b.resource_id
                                  and    a.time_line   >= b.start_date
                                  and    a.time_line    <  b.end_date
                                  and    a.master_id    = c.master_id
                                  and    a.plan_id      = c.plan_id
                                  and    a.resource_id  = c.resource_id
                                 ) a
                          where  end_time is not null
                         ) a
                 ) a
          group  by
                 a.master_id, a.plan_id, a.division_id, a.item_id, a.site_id, a.route_id, a.operation_id
               , a.mfg_week
          */
          
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
               
          update th_buf_scm_prefer_item_bor
          set    th_buf_scm_prefer_item_bor.lot_size = b.apply_lot_size
          from   th_buf_scm_prefer_item_bor a
                 left outer join th_mst_scm_demand_lot b
                      on     a.division_id = b.division_id
                      and    a.site_id = b.factory_id
                      and    a.item_id = b.item_id
                      and    a.plan_id = b.dpp_plan_id
          where  a.master_id = @v_master_id
          and    a.plan_id   = @v_plan_id
               
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          -- 하위 tact 이 크면 그걸 기준으로 처리한다.
          update th_buf_scm_prefer_item_bor
          set    th_buf_scm_prefer_item_bor.batch_item_id       = b.batch_item_id
                ,th_buf_scm_prefer_item_bor.batch_time_minute   = b.batch_time_minute
                ,th_buf_scm_prefer_item_bor.batch_res_count     = b.batch_res_count
                ,th_buf_scm_prefer_item_bor.batch_res_tact_time = b.batch_time_second
          from   th_buf_scm_prefer_item_bor a,
                 (
                  select master_id, plan_id, division_id, item_id, site_id, route_id, operation_id, mfg_week, 
                         case when max(batch_time) > 0 then max(child_item_id) end as batch_item_id,
                         max(batch_time) as batch_time_minute,
                         max(batch_res_count) as batch_res_count,
                         max(batch_time_second) as batch_time_second
                  from   (
                          select a.*, 
                                 isnull(b.tact_time, 0.0) as child_tact_time, 
                                 isnull(c.max_batch_qty, 0) as batch_qty, 
                                 isnull(c.batch_res_count, 1.0) as batch_res_count,
                                 isnull(c.batch_time, 0) * (case c.batch_time_uom when 'MINUTE' then 60.0
                                                                                  when 'MIN'    then 60.0
                                                                                  when 'HOUR'   then 1440.0
                                                                                                else 1.0
                                                            end) 
                                                         /  isnull(c.batch_res_count, 1.0)
                                                         /  isnull(a.lot_size, 1.0) 
                                                         * (case when week_run_days = 0 then 0
                                                                 else week_days / week_run_days
                                                            end )
                                                         as batch_time_second,
                                 isnull(c.batch_time, 0) * (case c.batch_time_uom when 'SECOND' then 1/60.0
                                                                                  when 'SEC'    then 1/60.0
                                                                                  when 'HOUR'   then 24.0
                                                                                                else 1.0
                                                            end) as batch_time
                          from   (
                                  select a.master_id, a.plan_id, a.division_id, 
                                         a.item_id, a.site_id, a.route_id, a.operation_id, a.mfg_week,
                                         a.tact_time, a.lot_size, a.week_days, a.week_run_days,
                                         b.child_item_id
                                  from   th_buf_scm_prefer_item_bor a,
                                         th_mst_plan_bom b
                                  where  a.master_id = @v_master_id
                                  and    a.plan_id = @v_plan_id
                                  and    a.master_id = b.master_id
                                  and    a.plan_id = b.plan_id
                                  and    a.item_id = b.parent_item_id
                                  and    a.site_id = b.site_id
                                  and    a.route_id = b.route_id
                                 ) a
                                 left outer join th_mst_op_resource b
                                      on  a.master_id = b.master_id
                                      and a.plan_id = b.plan_id
                                      and a.child_item_id = b.item_id
                                      and a.site_id = b.site_id
                                      and a.route_id = b.route_id
                                 left outer join (
                                                  select a.item_id, a.site_id, a.max_batch_qty, a.batch_time, 
                                                         a.batch_time_uom, b.res_attb_17 as route_id,
                                                         count(1) as batch_res_count
                                                  from   th_mst_batch_info a,
                                                         th_mst_resource b
                                                  where  a.master_id = @v_master_id
                                                  and    a.plan_id = @v_plan_id
                                                  and    a.plan_id = b.plan_id
                                                  and    a.batch_res_group_id = b.resource_id
                                                  group  by a.item_id, a.site_id, a.max_batch_qty, a.batch_time, 
                                                            a.batch_time_uom, b.res_attb_17
                                                 ) c
                                      on  a.child_item_id = c.item_id
                                      and a.site_id = c.site_id
                                      and a.route_id = c.route_id
                         ) a
                  group  by master_id, plan_id, division_id, item_id, site_id, route_id, operation_id, mfg_week
                 ) b
          where  a.master_id    = @v_master_id
          and    a.plan_id      = @v_plan_id
          and    a.master_id    = b.master_id
          and    a.plan_id      = b.plan_id
          and    a.division_id  = b.division_id
          and    a.item_id      = b.item_id
          and    a.site_id      = b.site_id
          and    a.route_id     = b.route_id
          and    a.operation_id = b.operation_id
          and    a.mfg_week     = b.mfg_week

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
               
          -----------------------------------------------------------------------------------------------------------
          -----------------------------------------------------------------------------------------------------------
          -----------------------------------------------------------------------------------------------------------
        
          SET @v_table_name = 'th_buf_scm_prefer_item_arrange'

          insert into th_buf_scm_prefer_item_arrange
               ( master_id, plan_id, division_id, item_id, site_id, route_id, operation_id, tact_time, alt_priority,
                 batch_res_tact_time, insert_dttm )   
          select distinct
                 a.master_id, a.plan_id, a.division_id, a.item_id, b.site_id, b.route_id, b.operation_id, b.tact_time, b.alt_priority,
                 0 as batch_res_tact_time, getdate() as insert_dttm
          from   th_buf_scm_prefer_demand a,
                 (
                  select division_id, item_id, route_id, site_id, operation_id, tact_time, alt_priority
                  from   (
                          select a.*, sum(cnt) over (partition by item_id) as sum_cnt
                          from   (
                                  select a.*, case when b.product_item_id is null then 0 else 1 end cnt
                                  from   (
                                          select a.master_id, a.plan_id, b.res_attb_12 as division_id,
                                                 a.item_id, a.route_id, a.site_id, a.operation_id, 
                                                 min(a.alt_priority) as alt_priority,
                                                 max(a.tact_time) as tact_time
                                          from   th_mst_op_resource a,
                                                 th_mst_resource b
                                          where  a.master_id = @v_master_id
                                          and    a.plan_id = @v_plan_id
                                          and    a.operation_id in ( @v_operation_01, @v_operation_02 )
                                          and    a.alt_priority in (1,2,3,4,5,6,7,8)    -- 0, 9 번은 대상에서 제외되므로 조건처리
                                          and    a.master_id = b.master_id
                                          and    a.plan_id = b.plan_id
                                          and    a.resource_id = b.resource_id
                                          group by a.master_id, a.plan_id, b.res_attb_12, a.item_id,a.route_id,a.site_id, a.operation_id
                                         ) a
                                         left outer join th_eng_sales_product_map b
                                              on    a.master_id = b.master_id
                                              and   a.plan_id = b.plan_id
                                              and   a.item_id = b.sales_model_id
                                              and   a.site_id +'^'+a.route_id = b.site_id
                                              and   exists (-- bom 에 등록된 것만.
                                                            select 1
                                                            from   th_eng_plan_bom x
                                                            where  x.master_id = b.master_id
                                                            and    x.plan_id = b.plan_id
                                                            and    x.parent_item_id = b.product_item_id
                                                            and    x.site_id = b.site_id
                                                           )
                                 ) a
                         ) a
                  where  sum_cnt = 0              -- sales model 이 아니거나
                  or    (sum_cnt > 0 and cnt > 0) -- sales model 이면 등록된 애들만..                
                 ) b
          where  a.division_id = b.division_id
          and    a.item_id = b.item_id
          and    a.master_id = @v_master_id
          and    a.plan_id   = @v_plan_id

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


          update th_buf_scm_prefer_item_arrange
          --set    th_buf_scm_prefer_item_arrange.lot_size = isnull(b.factory_lot_size, b.plant_lot_size)
          set    th_buf_scm_prefer_item_arrange.lot_size = b.apply_lot_size
          from   th_buf_scm_prefer_item_arrange a
                 left outer join th_mst_scm_demand_lot b
                      on     a.division_id = b.division_id
                      and    a.site_id = b.factory_id
                      and    a.item_id = b.item_id
                      and    a.plan_id = b.dpp_plan_id
          where  a.master_id = @v_master_id
          and    a.plan_id   = @v_plan_id
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          -- 하위 tact 이 크면 그걸 기준으로 처리한다.
          update th_buf_scm_prefer_item_arrange
          set    th_buf_scm_prefer_item_arrange.batch_item_id       = b.batch_item_id
                ,th_buf_scm_prefer_item_arrange.batch_time_minute   = b.batch_time_minute
                ,th_buf_scm_prefer_item_arrange.batch_res_count     = b.batch_res_count
                ,th_buf_scm_prefer_item_arrange.batch_res_tact_time = b.batch_time_second
          from   th_buf_scm_prefer_item_arrange a,
                 (
                  select master_id, plan_id, division_id, item_id, site_id, route_id, operation_id, tact_time,
                         case when max(batch_time) > 0 then max(child_item_id) end as batch_item_id,
                         max(batch_time) as batch_time_minute,
                         max(batch_res_count) as batch_res_count,
                         max(batch_time_second) as batch_time_second
                  from   (
                          select a.*, 
                                 isnull(b.tact_time, 0.0) as child_tact_time, 
                                 isnull(c.max_batch_qty, 0) as batch_qty, 
                                 isnull(c.batch_res_count, 1.0) as batch_res_count,
                                 isnull(c.batch_time, 0) * (case c.batch_time_uom when 'MINUTE' then 60.0
                                                                                  when 'MIN'    then 60.0
                                                                                  when 'HOUR'   then 1440.0
                                                                                                else 1.0
                                                            end) 
                                                         /  isnull(c.batch_res_count, 1.0)
                                                         /  isnull(a.lot_size, 1.0) as batch_time_second,
                                 isnull(c.batch_time, 0) * (case c.batch_time_uom when 'SECOND' then 1/60.0
                                                                                  when 'SEC'    then 1/60.0
                                                                                  when 'HOUR'   then 24.0
                                                                                                else 1.0
                                                            end) as batch_time
                          from   (
                                  select a.master_id, a.plan_id, a.division_id, 
                                         a.item_id, a.site_id, a.route_id, a.operation_id, 
                                         a.tact_time, a.lot_size,
                                         b.child_item_id
                                  from   th_buf_scm_prefer_item_arrange a,
                                         th_mst_plan_bom b
                                  where  a.master_id = @v_master_id
                                  and    a.plan_id = @v_plan_id
                                  and    a.master_id = b.master_id
                                  and    a.plan_id = b.plan_id
                                  and    a.item_id = b.parent_item_id
                                  and    a.site_id = b.site_id
                                  and    a.route_id = b.route_id
                                 ) a
                                 left outer join th_mst_op_resource b
                                      on  a.master_id = b.master_id
                                      and a.plan_id = b.plan_id
                                      and a.child_item_id = b.item_id
                                      and a.site_id = b.site_id
                                      and a.route_id = b.route_id
                                 left outer join (
                                                  select a.item_id, a.site_id, a.max_batch_qty, a.batch_time, 
                                                         a.batch_time_uom, b.res_attb_17 as route_id,
                                                         count(1) as batch_res_count
                                                  from   th_mst_batch_info a,
                                                         th_mst_resource b
                                                  where  a.master_id = @v_master_id
                                                  and    a.plan_id = @v_plan_id
                                                  and    a.plan_id = b.plan_id
                                                  and    a.batch_res_group_id = b.resource_id
                                                  group  by a.item_id, a.site_id, a.max_batch_qty, a.batch_time, 
                                                            a.batch_time_uom, b.res_attb_17
                                                 ) c
                                      on  a.child_item_id = c.item_id
                                      and a.site_id = c.site_id
                                      and a.route_id = c.route_id
                         ) a
                  group  by master_id, plan_id, division_id, item_id, site_id, route_id, operation_id, tact_time
                 ) b
          where  a.master_id    = @v_master_id
          and    a.plan_id      = @v_plan_id
          and    a.master_id    = b.master_id
          and    a.plan_id      = b.plan_id
          and    a.division_id  = b.division_id
          and    a.item_id      = b.item_id
          and    a.site_id      = b.site_id
          and    a.route_id     = b.route_id
          and    a.operation_id = b.operation_id

        END

        
        /*
          th_buf_scm_prefer_resource 데이터 생성
        */
        
        BEGIN
        
          SET @v_table_name = 'th_buf_scm_prefer_resource'

          insert into th_buf_scm_prefer_resource
               ( master_id, plan_id, division_id, operation_id, mfg_week, route_id, resource_setup_group_id,
                 item_cnt, equip_cnt, total_capa, off_capa, fix_capa, avail_capa, alloc_capa, setup_capa, remain_capa,
                 last_alloc_item, last_alloc_setup_group, prefer_item, insert_dttm )   
          select a.master_id, a.plan_id, a.division_id, a.operation_id, a.mfg_week, a.route_id, a.resource_setup_group_id,
                 a.item_cnt, a.equip_cnt, a.total_capa, a.off_capa, isnull(b.fix_capa,0) as fix_capa,
                 (a.avail_capa  - isnull(b.fix_capa,0) - isnull(c.test_capa,0)) as avail_capa, 
                 isnull(c.test_capa, 0) as alloc_capa, 0 as setup_capa, 
                 (a.remain_capa - isnull(b.fix_capa,0) - isnull(c.test_capa,0)) as remain_capa,
                 b.item_id as last_alloc_item, b.setup_group_id as last_alloc_setup_group, null as prefer_item, getdate() as insert_dttm
          from   (select a.master_id, a.plan_id, a.division_id, a.operation_id, a.mfg_week, a.route_id, a.resource_setup_group_id,
                         a.item_cnt, a.equip_cnt, a.total_capa, isnull(b.off_capa,0) as off_capa, 
                         (a.total_capa - isnull(b.off_capa,0)) as avail_capa, 0 as alloc_capa, 
                         (a.total_capa - isnull(b.off_capa,0)) as remain_capa
                  from   (select a.master_id, a.plan_id, d.division_id, a.operation_id, c.mfg_week, a.route_id, 
                                 max(e.resource_setup_group_id) as resource_setup_group_id,
                                 count(distinct a.item_id) as item_cnt, count(distinct a.resource_id) as equip_cnt,
                                 --round(1440*7*@n_capa_effi*count(distinct a.resource_id),0) as total_capa
                                 round(1440*max(c.week_day_cnt)*@n_capa_effi*count(distinct a.resource_id),0) as total_capa
                          from   th_mst_op_resource a,
                                 (select distinct plan_id, item_id
                                  from   th_dpp_net_demand
                                  where  master_id = @v_master_id
                                  and    plan_id = @v_plan_id) b,
                                 (
                                  select plan_id, week as mfg_week, count(1) as week_day_cnt
                                  from   (
                                          select plan_id, plan_start,
                                                 case when demand_end > plan_end then demand_end
                                                      else plan_end
                                                 end  as plan_end
                                          from   (
                                                  select plan_id,
                                                         convert(date, plan_start_dttm) as plan_start,
                                                         convert(date, plan_start_dttm + demand_horizon - 1) as demand_end ,
                                                         convert(date, plan_start_dttm + plan_horizon - 1) as plan_end
                                                  from   th_mst_plan 
                                                  where  master_id = @v_master_id
                                                  and    plan_id = @v_plan_id
                                                 ) a
                                         ) a,
                                         sy_scm_sys_calendar_m b
                                  where  b.date_id between plan_start and plan_end
                                  group  by plan_id, week
                                 ) c,
                                 /*
                                 (select distinct plan_id, mfg_week
                                  from   th_dpp_net_demand
                                  where  master_id = @v_master_id
                                  and    plan_id = @v_plan_id) c,
                                 */
                                 (select factory_id as site_id, line_id as route_id, 
                                         max(division_id) as division_id
                                  from   sy_scm_tact_time_m
                                  where  tact_time > 0
                                  group by factory_id,line_id) d,
                                 th_mst_resource e
                          where  a.plan_id = b.plan_id
                          and    a.plan_id = c.plan_id
                          and    a.item_id = b.item_id
                          and    a.site_id = d.site_id
                          and    a.route_id = d.route_id
                          and    a.master_id = e.master_id
                          and    a.plan_id = e.plan_id
                          and    a.resource_id = e.resource_id
                          and    a.master_id = @v_master_id
                          and    a.plan_id = @v_plan_id
                          and    a.operation_id in ( @v_operation_01, @v_operation_02 )
                          and    alt_priority in (1,2,3,4,5,6,7,8)    -- 0, 9 번은 대상에서 제외되므로 조건처리
                          group by a.master_id,a.plan_id,d.division_id,a.operation_id,c.mfg_week,a.route_id) a
                         left outer join (select c.operation_id, c.route_id, b.week as mfg_week, 
                                                 sum(b.offtime_term) as off_capa
                                          from   th_mst_resource a,
                                                 th_mst_off_calendar b,
                                                 (select resource_id, operation_id, route_id
                                                  from   th_mst_op_resource
                                                  where  master_id = @v_master_id
                                                  and    plan_id = @v_plan_id
                                                  and    operation_id in ( @v_operation_01, @v_operation_02 )
                                                  and    alt_priority in (1,2,3,4,5,6,7,8)    -- 0, 9 번은 대상에서 제외되므로 조건처리
                                                  group by resource_id,operation_id,route_id) c
                                          where  a.master_id = b.master_id
                                          and    a.plan_id = b.plan_id
                                          and    a.resource_group_id = b.resource_group_id
                                          and    a.resource_id = c.resource_id
                                          and    a.master_id = @v_master_id
                                          and    a.plan_id = @v_plan_id
                                          group by c.operation_id,c.route_id,b.week) b
                      on  a.operation_id = b.operation_id
                      and a.route_id = b.route_id
                      and a.mfg_week = b.mfg_week) a
                 left outer join (select operation_id, route_id, mfg_week, item_id, setup_group_id, fix_capa
                                  from   (select b.operation_id, a.mfg_week, b.route_id, a.item_id, c.setup_group_id, b.end_date, b.work_order_id, 
                                                 sum(a.qty * d.tact_time / 60.0) over (partition by b.operation_id,a.mfg_week,b.route_id) as fix_capa,
                                                 dense_rank() over (partition by b.operation_id,a.mfg_week,b.route_id order by b.end_date desc,b.work_order_id) as fix_rank
                                          from   th_dpp_net_demand a,
                                                 th_mst_fixed_plan b,
                                                 th_mst_item c,
                                                 (select item_id, operation_id, route_id, 
                                                         avg(tact_time) as tact_time
                                                  from   th_mst_op_resource
                                                  where  master_id = @v_master_id
                                                  and    plan_id = @v_plan_id
                                                  and    operation_id in ( @v_operation_01, @v_operation_02 )
                                                  and    alt_priority in (1,2,3,4,5,6,7,8)    -- 0, 9 번은 대상에서 제외되므로 조건처리
                                                  and    tact_time > 0
                                                  group by item_id,operation_id,route_id) d
                                          where  a.master_id = b.master_id
                                          and    a.master_id = c.master_id
                                          and    a.plan_id = b.plan_id
                                          and    a.plan_id = c.plan_id
                                          and    a.net_demand_id = b.demand_id
                                          and    a.production_order_id = b.work_order_id
                                          and    a.item_id = c.item_id
                                          and    b.item_id = d.item_id
                                          and    b.operation_id = d.operation_id
                                          and    b.route_id = d.route_id
                                          and    a.master_id = @v_master_id
                                          and    a.plan_id = @v_plan_id
                                          and    a.po_type = 'FIX') a -- ## Fix Demand..!!
                                  where  fix_rank = 1) b
                      on  a.operation_id = b.operation_id
                      and a.route_id = b.route_id
                      and a.mfg_week = b.mfg_week             
                 left outer join (select operation_id, route_id, mfg_week, item_id, setup_group_id, test_capa
                                  from   (select A.NET_DEMAND_ID, b.operation_id, a.mfg_week, b.line_id as route_id, a.item_id, c.setup_group_id, b.work_order_id, 
                                                 sum(a.qty * d.tact_time / 60.0) over (partition by a.demand_id) as test_capa,
                                                 dense_rank() over (partition by a.demand_id order by a.net_demand_id) as test_rank
                                          from   th_dpp_net_demand a,
                                                 th_mst_scm_demand b,
                                                 th_mst_item c,
                                                 (select item_id, operation_id, route_id, 
                                                         avg(tact_time) as tact_time
                                                  from   th_mst_op_resource
                                                  where  master_id = @v_master_id
                                                  and    plan_id = @v_plan_id
                                                  and    operation_id in ( @v_operation_01, @v_operation_02 )
                                                  and    alt_priority in (1,2,3,4,5,6,7,8)    -- 0, 9 번은 대상에서 제외되므로 조건처리
                                                  and    tact_time > 0
                                                  group by item_id,operation_id,route_id) d
                                          where  a.master_id = b.instance_id
                                          and    a.master_id = c.master_id
                                          and    a.plan_id = b.dpp_plan_id
                                          and    a.plan_id = c.plan_id
                                          and    a.demand_id = b.scp_target_id
                                          and    a.item_id = c.item_id
                                          and    b.item_id = d.item_id
                                          and    b.operation_id = d.operation_id
                                          and    b.line_id = d.route_id
                                          and    a.master_id = @v_plan_id
                                          and    a.plan_id = @v_plan_id
                                          and    isnull(a.order_type,'NULL') = 'TEST') a -- ## TEST Demand..!!
                                  where  test_rank = 1) c
                      on  a.operation_id = c.operation_id
                      and a.route_id = c.route_id
                      and a.mfg_week = c.mfg_week             
                                  
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          
          
        END
        
        
        ----------------------------------------------------------------------------------------------------------
        --  Prefer Capa 할당 : START
        ----------------------------------------------------------------------------------------------------------
        
        BEGIN

          SET @v_table_name = '@PREFER_ALLOC'
          SET @n_row_count = 0

          DECLARE @V_PF_DIVISION_ID       nvarchar(50),
                  @V_PF_MFG_WEEK          nvarchar(10),
                  @V_PF_ITEM_ID           nvarchar(50),
                  @V_PF_TARGET_DEMAND_ID  nvarchar(100),
                  @V_PF_SETUP_GROUP_ID    nvarchar(50),
                  @V_PF_SITE_ID           nvarchar(50),
                  @V_PF_ROUTE_ID          nvarchar(50),
                  @V_PF_OPERATION_ID      nvarchar(50),
                  @V_PF_PREFER_RES        nvarchar(3000),
                  @V_PF_PREFER_ITEM       nvarchar(3000),
                  @N_PF_REMAIN_TACT       float,
                  @N_PF_REMAIN_LOT        float,
                  @N_PF_REMAIN_QTY        float,
                  @N_PF_REMAIN_CAPA_R     float,
                  @N_PF_ALLOC_QTY         float,
                  @N_PF_ALLOC_SETUP       float,
                  @N_PF_ALLOC_RATE        float,
                  @N_PF_ALLOC_ADJ_RATE    float,
                  @V_PF_EARLY_WEEK        nvarchar(10),
                  @V_PF_FENCE_WEEK        nvarchar(10)

          DECLARE @V_DEMAND_WEEK        nvarchar(10),
                  @V_RES_WEEK           nvarchar(10),
                  @N_ASSIGN_SEQ         int = 0

          -- 대상 TARGET 의 생산주차
          DECLARE PREFER_DEMAND_WEEK CURSOR FOR 
            select mfg_week
            from   (
                    select mfg_week, rank() over (order by mfg_week) week_seq
                    from   th_buf_scm_prefer_demand
                    where  master_id = @v_master_id
                    and    plan_id = @v_plan_id
                    group  by mfg_week
                   ) a
            --where  week_seq = 1
            order  by week_seq

        
          OPEN PREFER_DEMAND_WEEK
          
          WHILE 1 = 1

          BEGIN

            FETCH PREFER_DEMAND_WEEK
             INTO @V_DEMAND_WEEK

              IF @@FETCH_STATUS <> 0
                BREAK
        
              DECLARE PREFER_DEMAND CURSOR FOR 
              
                select division_id, mfg_week, item_id, setup_group_id,
                       remain_qty, isnull(prefer_resource,'##') as prefer_resource,
                       target_demand_id, EARLY_WEEK, FENCE_WEEK
                from   (select a.*,
                               dense_rank() over (partition by a.master_id,a.plan_id 
                                                  order by 
                                                           -- 설비 2개 미만일 경우에는 setup 보단 설비를 먼저 할당한다.
                                                           case when a.assign_cnt = 1 then 1 
                                                                when a.assign_cnt = 2 then 2
                                                                else 9 end,
                                                           case when market = 'E' then 1 else 2 end,    -- 수출 E, 내수 D 로 수출이 최우선순위다.
                                                           isnull(b.setup_item_seq,9),isnull(c.setup_group_seq,9),
                                                           --case when a.assign_cnt = 1 then 1 else 9 end,
                                                           a.assign_cnt,
                                                           a.total_setup_qty desc,a.total_item_qty desc,
                                                           a.item_id,a.mfg_week,a.target_demand_id) as dmd_rank
                        from   (select a.*,
                                       sum(case when isnull(a.setup_group_id,'-') = '-' then 0 else a.remain_qty end) 
                                           over (partition by a.master_id,a.plan_id,a.setup_group_id) as total_setup_qty,
                                       sum(a.remain_qty) over (partition by a.master_id,a.plan_id,a.item_id) as total_item_qty
                                from   th_buf_scm_prefer_demand a
                                where  a.master_id = @v_master_id
                                and    a.plan_id = @v_plan_id
                                and    a.mfg_week = @V_DEMAND_WEEK
                                and    a.remain_qty > 0) a
                       left outer join (select distinct last_alloc_item, 1 as setup_item_seq
                                        from   th_buf_scm_prefer_resource
                                        where  master_id = @v_master_id
                                        and    plan_id = @v_plan_id) b
                        on  a.item_id = b.last_alloc_item
                       left outer join (select distinct last_alloc_setup_group, 1 as setup_group_seq
                                        from   th_buf_scm_prefer_resource
                                        where  master_id = @v_master_id
                                        and    plan_id = @v_plan_id) c
                        on  a.setup_group_id = c.last_alloc_setup_group
                        ) a
                order by dmd_rank

              SET @V_PF_DIVISION_ID    = 'NULL'
              SET @V_PF_MFG_WEEK       = 'NULL'
              SET @V_PF_ITEM_ID        = 'NULL'
              SET @V_PF_SETUP_GROUP_ID = 'NULL'
              SET @V_PF_ROUTE_ID       = 'NULL'
              SET @V_PF_OPERATION_ID   = 'NULL'
              SET @V_PF_PREFER_RES     = 'NULL'
              SET @V_PF_PREFER_ITEM    = 'NULL'
              SET @N_PF_REMAIN_TACT    = 0.0
              SET @N_PF_REMAIN_QTY     = 0.0
              SET @N_PF_REMAIN_CAPA_R  = 0.0
              SET @N_PF_ALLOC_QTY      = 0.0
              SET @N_PF_ALLOC_RATE     = 0.0
              SET @N_PF_ALLOC_ADJ_RATE = 0.0
              
              SET @v_prefer_res_cum  = 'NULL'
              SET @v_prefer_item_cum = 'NULL'
              SET @n_dmd_remain_qty = 0.0

              OPEN PREFER_DEMAND
              
              WHILE 1 = 1
              
              BEGIN

                FETCH PREFER_DEMAND
                 INTO @V_PF_DIVISION_ID, @V_PF_MFG_WEEK, @V_PF_ITEM_ID, @V_PF_SETUP_GROUP_ID, @N_PF_REMAIN_QTY, @V_PF_PREFER_RES,
                      @V_PF_TARGET_DEMAND_ID, @V_PF_EARLY_WEEK, @V_PF_FENCE_WEEK
                  
                  IF @@FETCH_STATUS <> 0
                    --OR @N_ASSIGN_SEQ >= 83
                    BREAK
                 
                  SET @n_dmd_remain_qty = @N_PF_REMAIN_QTY
                  SET @v_prefer_res_cum = @V_PF_PREFER_RES

                  BEGIN

                    -- 대상 TARGET 의 선행주차부터 FENCE 주차까지 검색
                    -- 당주만 할당할 경우 조건식 변경할 것
                    DECLARE PREFER_RES_WEEK CURSOR FOR 
                      SELECT WEEK
                      FROM   SY_SCM_SYS_CALENDAR_M
                      WHERE  WEEK BETWEEN @V_PF_EARLY_WEEK AND @V_PF_FENCE_WEEK     -- 대상 TARGET 의 선행주차부터 FENCE 주차까지 검색
                      --WHERE  WEEK = @V_PF_MFG_WEEK                                -- 당주만 할당
                      GROUP  BY WEEK
                      ORDER  BY WEEK

                    OPEN PREFER_RES_WEEK
                    
                    WHILE 1 = 1

                    BEGIN

                      FETCH PREFER_RES_WEEK
                       INTO @V_RES_WEEK

                        IF @@FETCH_STATUS <> 0
                          BREAK
                          

                        DECLARE PREFER_RESOURCE CURSOR FOR 
                          -- target 별로 선행, fence 주차 전체를 탐색하여, 주차에 걸친 line 으로 할당하도록 로직 변경한다.
                          -- 주차별로 안보기 때문에 걍 주차경계없이 capa 를 없앤다
                          select site_id, route_id, operation_id,
                                 remain_capa as remain_capa_r, isnull(prefer_item,'##') as prefer_item, tact_time, lot_size, setup_time
                          from   (
                                  select a.*,
                                         dense_rank() over (partition by a.master_id,a.plan_id
                                                            order by capa_check
                                                                   , case a.master_id when 'KR_CELL_M' then alt_priority
                                                                                      else 1
                                                                     end
                                                                   , week_check           -- 주차 선행일때는 주차 우선할당
                                                                   , item_check
                                                                   , setup_check
                                                                   , setup_time            -- setup 시간 작은 순으로
                                                                   , prev_item_check
                                                                   , prev_setup_check
                                                                   , remain_check
                                                                   , item_cnt_check
                                                                   , alt_priority          -- line 우선순위
                                                                   , remain_capa      desc
                                                                   , route_id
                                                           ) as res_rank 
                                  from   (
                                          select a.*,
                                                 isnull(d.setup_time, 0) * (case d.setup_time_uom when 'SECOND' then 1/60
                                                                                                  when 'MINUTE' then 1
                                                                                                  when 'HOUR'   then 60
                                                                                                  when 'DAY'    then 1440
                                                                                                                else 1
                                                                            end )
                                                 as setup_time,
                                                 case when a.remain_capa > 0.0 then 1 else 9 end  as capa_check,
                                                 case when a.last_alloc_item = @v_pf_item_id then 1 else 9 end  as item_check,
                                                 case when a.last_alloc_setup_group = @v_pf_setup_group_id then 1 else 9 end setup_check,
                                                 case when isnull(b.last_alloc_item,'NULL') = @v_pf_item_id then 1 else 9 end prev_item_check,
                                                 case when isnull(c.last_alloc_setup_group,'NULL') = @v_pf_setup_group_id then 1 else 9 end prev_setup_check,
                                                 case when a.remain_capa >= (@n_pf_remain_qty * a.tact_time / 60 ) then 1 else 9 end remain_check,
                                                 case when a.item_cnt = 1 then 1 else 9 end item_cnt_check,
                                                 case when a.mfg_week < @V_PF_MFG_WEEK then 1
                                                      when a.mfg_week = @V_PF_MFG_WEEK then 2 else 3 end  week_check   -- target 주차보다 resource 주차가 빠르면 1, 동일하면 2, 늦으면 3 으로 설정
                                          from   (
                                                  select a.master_id, a.plan_id, a.mfg_week,
                                                         a.route_id, a.operation_id, a.resource_setup_group_id, a.remain_capa,
                                                         a.last_alloc_item, a.last_alloc_setup_group, a.prefer_item, a.item_cnt,
                                                         b.site_id, b.lot_size,
                                                         case when b.batch_res_tact_time is null        then b.tact_time
                                                              when b.tact_time > b.batch_res_tact_time  then b.tact_time
                                                              else b.batch_res_tact_time
                                                         end  as tact_time,
                                                         b.alt_priority
                                                  from   th_buf_scm_prefer_resource a,
                                                         th_buf_scm_prefer_item_bor b
                                                  where  a.master_id = b.master_id
                                                  and    a.plan_id = b.plan_id
                                                  and    a.division_id = b.division_id
                                                  --and    a.mfg_week = b.mfg_week
                                                  and    a.route_id = b.route_id
                                                  and    a.operation_id = b.operation_id
                                                  and    a.mfg_week = b.mfg_week
                                                  and    a.master_id = @v_master_id
                                                  and    a.plan_id = @v_plan_id
                                                  and    a.operation_id in ( @v_operation_01, @v_operation_02 )
                                                  and    a.division_id = @v_pf_division_id
                                                  --and    a.mfg_week = @v_pf_mfg_week
                                                  and    a.mfg_week = @V_RES_WEEK
                                                  and    b.item_id = @v_pf_item_id
                                                  and    a.remain_capa > 0
                                                 ) a
                                         left outer join (select route_id, operation_id, last_alloc_item 
                                                          from   (select route_id, operation_id, mfg_week, last_alloc_item,
                                                                         dense_rank() over (partition by route_id order by mfg_week desc) as prev_rank
                                                                  from   th_buf_scm_prefer_resource
                                                                  where  master_id = @v_master_id
                                                                  and    plan_id = @v_plan_id
                                                                  and    operation_id in ( @v_operation_01, @v_operation_02 )
                                                                  --and    mfg_week < @v_pf_mfg_week
                                                                  and    mfg_week < @V_RES_WEEK
                                                                  and    last_alloc_item is not null) v
                                                          where prev_rank = 1) b
                                              on  a.route_id = b.route_id
                                              and a.operation_id = b.operation_id
                                         left outer join (select route_id, operation_id, last_alloc_setup_group
                                                          from   (select route_id, operation_id, mfg_week, last_alloc_setup_group,
                                                                         dense_rank() over (partition by route_id order by mfg_week desc) as prev_rank
                                                                  from   th_buf_scm_prefer_resource
                                                                  where  master_id = @v_master_id
                                                                  and    plan_id = @v_plan_id
                                                                  and    operation_id in ( @v_operation_01, @v_operation_02 )
                                                                  --and    mfg_week < @v_pf_mfg_week
                                                                  and    mfg_week < @V_RES_WEEK
                                                                  and    last_alloc_setup_group is not null) v
                                                          where prev_rank = 1) c
                                              on  a.route_id = c.route_id
                                              and a.operation_id = c.operation_id
                                         left outer join th_eng_setup_matrix d
                                              on  a.master_id = d.master_id
                                              and a.plan_id = d.plan_id
                                              and a.resource_setup_group_id = d.resource_setup_group_id
                                              and a.last_alloc_setup_group = d.from_setup_group_id
                                              and d.to_setup_group_id = @V_PF_SETUP_GROUP_ID
                                          where tact_time > 0 
                                         ) a
                                  ) a
                          where   remain_capa > setup_time    -- 잔여 시간보다 setup 시간이 크면 할당불가능하므로,
                          order   by res_rank

                        OPEN PREFER_RESOURCE
                        
                        WHILE 1 = 1

                        BEGIN

                          FETCH PREFER_RESOURCE
                           INTO @V_PF_SITE_ID, @V_PF_ROUTE_ID, @V_PF_OPERATION_ID, 
                                @N_PF_REMAIN_CAPA_R, @V_PF_PREFER_ITEM, 
                                @N_PF_REMAIN_TACT, @N_PF_REMAIN_LOT, @N_PF_ALLOC_SETUP

                            IF @@FETCH_STATUS <> 0 OR @n_dmd_remain_qty <= 0.0
                              --OR @N_ASSIGN_SEQ >= 83
                              BREAK

                            SET @v_prefer_item_cum = @V_PF_PREFER_ITEM
                            SET @n_pf_alloc_qty = 0.0
                            
                            IF @n_pf_remain_capa_r < @N_PF_ALLOC_SETUP
                              BEGIN
                                SET @n_pf_alloc_qty = 0.0
                              END
                            ELSE IF @n_pf_remain_capa_r >= ( (@n_dmd_remain_qty * @n_pf_remain_tact) / 60 + @N_PF_ALLOC_SETUP)
                              BEGIN
                                SET @n_pf_alloc_qty = @n_dmd_remain_qty
                              END
                            ELSE
                              BEGIN
                                SET @n_pf_alloc_qty = ( @n_pf_remain_capa_r - @N_PF_ALLOC_SETUP ) / ( @n_pf_remain_tact / 60 )
                                
                                IF @N_PF_REMAIN_LOT IS NOT NULL 
                                  SET @n_pf_alloc_qty = floor( @n_pf_alloc_qty / @N_PF_REMAIN_LOT ) * @N_PF_REMAIN_LOT
                              END
                              
                            IF @n_pf_alloc_qty > 0  -- 할당할 애들이 있으면 할당, 없으면 다음 설비 찾기
                            BEGIN
                            
                              SET @v_prefer_res_cum = @v_prefer_res_cum + @v_pf_route_id + '##'
                            
                              update th_buf_scm_prefer_demand
                              set    alloc_qty = alloc_qty + @n_pf_alloc_qty,
                                     remain_qty = remain_qty - @n_pf_alloc_qty,
                                     prefer_resource = @v_prefer_res_cum
                              where  master_id = @v_master_id
                              and    plan_id = @v_plan_id
                              and    division_id = @v_pf_division_id
                              and    mfg_week = @v_pf_mfg_week
                              and    item_id = @v_pf_item_id
                              and    target_demand_id = @V_PF_TARGET_DEMAND_ID


                              SET @v_prefer_item_cum = @v_prefer_item_cum + @v_pf_item_id + '##'
                            
                              update th_buf_scm_prefer_resource
                              set    alloc_capa = alloc_capa + ceiling( @n_pf_alloc_qty * ( @n_pf_remain_tact / 60) ),
                                     setup_capa = setup_capa + ceiling( @n_pf_alloc_setup ),
                                     remain_capa = remain_capa - ceiling( @n_pf_alloc_qty * ( @n_pf_remain_tact / 60) + @n_pf_alloc_setup),
                                     last_alloc_item = @v_pf_item_id,
                                     last_alloc_setup_group = @v_pf_setup_group_id,
                                     prefer_item = @v_prefer_item_cum
                              where  master_id = @v_master_id
                              and    plan_id = @v_plan_id
                              and    division_id = @v_pf_division_id
                              and    operation_id = @v_pf_operation_id
                              --and    mfg_week = @v_pf_mfg_week
                              and    mfg_week = @V_RES_WEEK
                              and    route_id = @v_pf_route_id 
/*
                              update th_buf_scm_prefer_alloc_rate
                              set    alloc_qty = alloc_qty + @n_pf_alloc_qty
                              where  master_id = @v_master_id
                              and    plan_id = @v_plan_id
                              and    division_id = @v_pf_division_id
                              --and    mfg_week = @v_pf_mfg_week
                              and    mfg_week = @V_RES_WEEK
                              and    item_id = @v_pf_item_id
                              and    route_id = @v_pf_route_id 
*/
                              SET @n_row_count += @@ROWCOUNT
                              
                              SET @N_ASSIGN_SEQ += 1
                              
                              insert into th_buf_scm_prefer_demand_assign
                              select master_id, plan_id, division_id, mfg_week, @V_RES_WEEK AS RES_WEEK, item_id,
                                     @n_pf_alloc_qty as qty, @V_PF_SITE_ID AS SITE_ID, @v_pf_route_id as route_id,
                                     @v_pf_operation_id as operation_id,
                                     target_demand_id, market, 
                                     CASE WHEN @N_PF_REMAIN_LOT IS NULL THEN @n_pf_alloc_qty
                                          ELSE @N_PF_REMAIN_LOT
                                     END  AS LOT_SIZE, 
                                     @N_ASSIGN_SEQ AS ASSIGN_SEQ, getdate() as insert_dttm
                              from   th_buf_scm_prefer_demand
                              where  master_id = @v_master_id
                              and    plan_id = @v_plan_id
                              and    division_id = @v_pf_division_id
                              and    mfg_week = @v_pf_mfg_week
                              and    item_id = @v_pf_item_id
                              and    target_demand_id = @V_PF_TARGET_DEMAND_ID

                              SET @n_dmd_remain_qty = @n_dmd_remain_qty - @n_pf_alloc_qty
                              
                            END                            
                              
                        END

                        CLOSE PREFER_RESOURCE

                        DEALLOCATE PREFER_RESOURCE
                      
                    END

                    CLOSE PREFER_RES_WEEK

                    DEALLOCATE PREFER_RES_WEEK
                  END
              
              END

              CLOSE PREFER_DEMAND

              DEALLOCATE PREFER_DEMAND

              --LOG 생성
              SET @v_message = @V_DEMAND_WEEK + ' WEEK PROCESS END'
              SET @n_log_count = @n_log_count + 1
              SET @sysdate = GETDATE()
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
              
          END

          CLOSE PREFER_DEMAND_WEEK

          DEALLOCATE PREFER_DEMAND_WEEK

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END

        ----------------------------------------------------------------------------------------------------------
        --  Prefer Capa 할당 : END
        ----------------------------------------------------------------------------------------------------------

        ----------------------------------------------------------------------------------------------------------
        --  BATCH 설비 존재시 TACT 조정 : START
        ----------------------------------------------------------------------------------------------------------
        /*
        BEGIN
        
          SELECT @v_chk_batch_cnt = COUNT(1) 
          FROM   TH_BUF_SCM_PREFER_ITEM_ARRANGE
          WHERE  MASTER_ID = @v_master_id
          AND    PLAN_ID   = @v_plan_id
          AND    BATCH_ITEM_ID IS NOT NULL
          
          DELETE FROM TH_ENG_BATCH_INFO_CAL
          WHERE  MASTER_ID = @v_master_id
          AND    PLAN_ID   = @v_plan_id
          AND    DESCR = 'PREFER'
          
          IF @v_chk_batch_cnt > 0 AND @v_chk_run_seq <> 'NULL' AND 1=0
              AND @v_plan_id = 'KR_E_PRE-20170123-01'
            BEGIN
            
              SET @v_table_name = 'TH_ENG_BATCH_INFO_CAL'
              SET @n_row_count = 0

              INSERT INTO TH_ENG_BATCH_INFO_CAL
              SELECT A.MASTER_ID, A.PLAN_ID, A.BATCH_RES_GROUP_ID, A.BATCH_GROUP_ID, A.ITEM_ID,
                     B.END_DTTM AS START_DTTM,
                     DATEADD(MINUTE, A.BATCH_TIME, B.END_DTTM) AS END_DTTM,
                     A.MAX_BATCH_QTY, A.BATCH_TIME, A.BATCH_TIME_UOM,
                     A.PREFER_RATIO, A.WAIT_TOLERANCE_TIME, A.WAIT_TOLERANCE_TIME_UOM,
                     'PREFER' AS DESCR
              FROM   TH_ENG_BATCH_INFO A,
                     TH_ENG_OFFTIME B
              WHERE  A.MASTER_ID = @v_master_id
              AND    A.PLAN_ID   = @v_plan_id
              AND    A.MASTER_ID = B.MASTER_ID
              AND    A.PLAN_ID   = B.PLAN_ID
              AND    A.BATCH_RES_GROUP_ID = B.OFFTIME_SET_ID
              UNION  ALL
              SELECT A.MASTER_ID, A.PLAN_ID, A.BATCH_RES_GROUP_ID, A.BATCH_GROUP_ID, A.ITEM_ID,
                     B.PLAN_START_DTTM AS START_DTTM,
                     DATEADD(MINUTE, A.BATCH_TIME, B.PLAN_START_DTTM) AS END_DTTM,
                     A.MAX_BATCH_QTY, A.BATCH_TIME, A.BATCH_TIME_UOM,
                     A.PREFER_RATIO, A.WAIT_TOLERANCE_TIME, A.WAIT_TOLERANCE_TIME_UOM,
                     'PREFER' AS DESCR
              FROM   TH_ENG_BATCH_INFO A,
                     TH_ENG_PLAN_INFO B
              WHERE  A.MASTER_ID = @v_master_id
              AND    A.PLAN_ID   = @v_plan_id
              AND    A.MASTER_ID = B.MASTER_ID
              AND    A.PLAN_ID   = B.PLAN_ID
              AND    A.PLAN_ID = B.PLAN_ID
              
              SET @n_row_count = @@ROWCOUNT

              --LOG 생성
              SET @v_message = @n_row_count
              SET @n_log_count = @n_log_count + 1
              SET @sysdate = GETDATE()
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

              UPDATE TH_ENG_BATCH_INFO
              SET    TH_ENG_BATCH_INFO.BATCH_TIME = D.NEW_BATCH_TIME
              FROM   TH_ENG_BATCH_INFO A,
                     (
                      SELECT B.*, C.ROUTE_ID
                      FROM   TH_ENG_BATCH_INFO B,
                             TH_ENG_RESOURCE C
                      WHERE  B.MASTER_ID = @v_master_id
                      AND    B.PLAN_ID   = @v_plan_id
                      AND    B.MASTER_ID = C.MASTER_ID
                      AND    B.PLAN_ID   = C.PLAN_ID
                      AND    B.BATCH_RES_GROUP_ID = C.BATCH_RES_GROUP_ID
                     ) B,
                     (
                      SELECT A.*
                      FROM   (
                              SELECT A.*, C.LOT_SIZE, C.BATCH_RES_COUNT, C.BATCH_TIME_MINUTE, C.BATCH_ITEM_ID
                                   , FLOOR(
                                            (C.LOT_SIZE * C.TACT_TIME / 60)     -- 실제 RUNTIME
                                            / CASE WHEN A.YIELD = 0 THEN 1 ELSE A.YIELD END
                                            / B.UTILIZATION
                                            / C.BATCH_RES_COUNT
                                          ) AS NEW_BATCH_TIME
                              FROM   TH_ENG_OP_RES_GROUP_MAP A,
                                     TH_ENG_RESOURCE B,
                                     TH_BUF_SCM_PREFER_ITEM_ARRANGE C
                              WHERE  A.MASTER_ID = @v_master_id
                              AND    A.PLAN_ID = @v_plan_id
                              AND    A.MASTER_ID = B.MASTER_ID
                              AND    A.PLAN_ID = B.PLAN_ID
                              AND    A.RESOURCE_GROUP_ID = B.RESOURCE_GROUP_ID
                              AND    A.PLAN_ID = C.PLAN_ID
                              AND    A.ITEM_ID LIKE C.ITEM_ID +'%'
                              AND    A.ROUTE_ID LIKE C.ROUTE_ID +'%'
                              AND    A.SITE_ID LIKE C.SITE_ID +'%'
                              AND    A.OPERATION_ID = C.OPERATION_ID
                              AND    C.BATCH_ITEM_ID IS NOT NULL
                              AND    B.UTILIZATION > 0
                              AND    B.RESOURCE_ID = 'M3ECOT101'
                              --AND    C.ITEM_ID = 'APCCA0359A'
                             ) A
                      WHERE  A.BATCH_TIME_MINUTE < A.NEW_BATCH_TIME
                     ) D
              WHERE  1=1
              AND    A.MASTER_ID = @v_master_id
              AND    A.PLAN_ID = @v_plan_id
              AND    A.BATCH_RES_GROUP_ID = B.BATCH_RES_GROUP_ID
              AND    A.BATCH_GROUP_ID = B.BATCH_GROUP_ID
              AND    A.ITEM_ID = B.ITEM_ID
              AND    B.ITEM_ID LIKE D.BATCH_ITEM_ID +'%'
              AND    B.ROUTE_ID = D.ROUTE_ID

              -- TH_ENG_RESOURCE, TH_ENG_OP_RES_GROUP, MAP, MAP_CAL 백업
              /*
              DELETE FROM TH_ENG_RESOURCE
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID   = @v_plan_id + 'PREFER'
              
              UPDATE TH_ENG_RESOURCE
              SET    TH_ENG_RESOURCE.PLAN_ID = A.PLAN_ID + 'PREFER'
              FROM   TH_ENG_RESOURCE A
              WHERE  A.MASTER_ID = @v_master_id
              AND    A.PLAN_ID   = @v_plan_id
              AND    EXISTS (
                              SELECT 1
                              FROM   TH_BUF_SCM_PREFER_ITEM_ARRANGE X
                              WHERE  A.MASTER_ID = X.MASTER_ID
                              AND    A.PLAN_ID = X.PLAN_ID
                              AND    A.ROUTE_ID LIKE X.ROUTE_ID +'%'
                              AND    A.SITE_ID LIKE X.SITE_ID +'%'
                            )
              */
              
            END
        
        END
        */
        ----------------------------------------------------------------------------------------------------------
        --  BATCH 설비 존재시 TACT 조정 : END
        ----------------------------------------------------------------------------------------------------------

        -- TEST DEMAND ASSIGN 설정 : DEMAND LOT SPLIT 하기 위헤
        BEGIN
        
          SET @v_table_name = 'TH_BUF_SCM_PREFER_DEMAND_ASSIGN - TEST TARGET'

          INSERT INTO TH_BUF_SCM_PREFER_DEMAND_ASSIGN
                (
                  MASTER_ID
                , PLAN_ID
                , DIVISION_ID
                , MFG_WEEK
                , RES_WEEK
                , ITEM_ID
                , QTY
                , SITE_ID
                , ROUTE_ID
                , OPERATION_ID
                , TARGET_DEMAND_ID
                , MARKET
                , LOT_SIZE
                , ASSIGN_SEQ
                , INSERT_DTTM
                )
          SELECT 
                  A.MASTER_ID
                , A.PLAN_ID
                , A.DIVISION_ID
                , A.MFG_WEEK
                , A.RES_WEEK
                , A.ITEM_ID
                , A.QTY
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , A.TARGET_DEMAND_ID
                , A.MARKET
                , ISNULL(B.APPLY_LOT_SIZE, A.QTY) AS LOT_SIZE
                , @N_ASSIGN_SEQ + DENSE_RANK() OVER(ORDER BY A.TARGET_DEMAND_ID) AS ASSIGN_SEQ
                , getdate() as INSERT_DTTM
          FROM   (
                  SELECT A.MASTER_ID
                       , A.PLAN_ID
                       , B.DIVISION_ID
                       , A.MFG_WEEK
                       , A.MFG_WEEK   AS RES_WEEK
                       , A.ITEM_ID
                       , SUM(QTY)     AS QTY
                       , B.TO_FACTORY_ID  AS SITE_ID
                       , B.LINE_ID        AS ROUTE_ID
                       , B.OPERATION_ID   AS OPERATION_ID
                       , B.SCP_TARGET_ID  AS TARGET_DEMAND_ID
                       , B.MARKET
                       , NULL             AS LOT_SIZE
                  FROM   TH_DPP_NET_DEMAND A,
                         TH_MST_SCM_DEMAND B,
                         TH_MST_ITEM C,
                         (SELECT ITEM_ID, OPERATION_ID, ROUTE_ID, 
                                 AVG(TACT_TIME) AS TACT_TIME
                          FROM   TH_MST_OP_RESOURCE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    OPERATION_ID in ( @v_operation_01, @v_operation_02 )
                          AND    ALT_PRIORITY IN (1,2,3,4,5,6,7,8)    -- 0, 9 번은 대상에서 제외되므로 조건처리
                          AND    TACT_TIME > 0
                          GROUP BY ITEM_ID,OPERATION_ID,ROUTE_ID) D
                  WHERE  A.MASTER_ID = B.INSTANCE_ID
                  AND    A.MASTER_ID = C.MASTER_ID
                  AND    A.PLAN_ID = B.DPP_PLAN_ID
                  AND    A.PLAN_ID = C.PLAN_ID
                  AND    A.DEMAND_ID = B.SCP_TARGET_ID
                  AND    A.ITEM_ID = C.ITEM_ID
                  AND    A.MFG_WEEK = B.MFG_WEEK
                  AND    B.ITEM_ID = D.ITEM_ID
                  AND    B.OPERATION_ID = D.OPERATION_ID
                  AND    B.LINE_ID = D.ROUTE_ID
                  AND    A.MASTER_ID = @v_master_id
                  AND    A.PLAN_ID = @v_plan_id
                  AND    ISNULL(A.PO_TYPE,'NULL') <> 'FIX'      -- ## 확정  DEMAND는 제외..!!
                  AND    ISNULL(A.PO_TYPE,'NULL') <> 'STOCK'    -- ## STOCK DEMAND는 제외..!!
                  AND    ISNULL(A.ORDER_TYPE,'NULL') = 'TEST'   -- ## TEST  DEMAND는 제외..!!
                  GROUP  BY
                         A.MASTER_ID
                       , A.PLAN_ID
                       , B.DIVISION_ID
                       , A.MFG_WEEK
                       , A.ITEM_ID
                       , B.TO_FACTORY_ID
                       , B.LINE_ID
                       , B.OPERATION_ID
                       , B.SCP_TARGET_ID
                       , B.MARKET
                 ) A
                 LEFT OUTER JOIN TH_MST_SCM_DEMAND_LOT B
                      ON     A.DIVISION_ID = B.DIVISION_ID
                      AND    A.SITE_ID = B.FACTORY_ID
                      AND    A.ITEM_ID = B.ITEM_ID
                      AND    A.PLAN_ID = B.DPP_PLAN_ID
                 
                 
                
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END

        BEGIN

          -- FACOTY 별 LOT SIZE 반영
          SET @v_table_name = 'TH_BUF_SCM_PREFER_DEMAND_SPLIT'
          SET @n_row_count = 0

          DELETE FROM TH_BUF_SCM_PREFER_DEMAND_SPLIT

          INSERT INTO TH_BUF_SCM_PREFER_DEMAND_SPLIT
                (
                   COMPANY_ID
                 , DIVISION_ID
                 , SITE_ID
                 , PLANT_ID
                 , SHOP_GROUP_ID
                 , INSTANCE_ID
                 , DPP_PLAN_ID
                 , FP_DEMAND_ID
                 , SCP_PLAN_ID
                 , SCP_TARGET_ID
                 , ITEM_ID
                 , MFG_WEEK
                 , MFG_QTY
                 , SCP_QTY
                 , WORK_ORDER_ID
                 , DUE_DATE
                 , DUE_FENCE_DATE
                 , PRECEDE_PRODUCING_TERM
                 , PRECEDE_PRODUCING_TERM_UOM
                 , PRODUCTION_TYPE
                 , TO_SITE_ID
                 , TO_PLANT_ID
                 , LINE_ID
                 , MARKET
                 , PRIORITY
                 , OFFSET_QTY
                 , CONFIRM_TYPE
                 , DEMAND_TYPE
                 , DEMAND_LOT_SIZE
                 , PREFER_SITE_ID
                 , PREFER_ROUTE_ID
                 , KEY_DATE
                )
          SELECT 
                 B.COMPANY_ID
               , B.DIVISION_ID
               , B.SITE_ID
               , B.PLANT_ID
               , B.SHOP_GROUP_ID
               , A.MASTER_ID AS INSTANCE_ID
               , B.DPP_PLAN_ID
               /*
               , B.SHOP_GROUP_ID +'^'+B.PLANT_ID
                                 +'^'+CONVERT(NVARCHAR, B.DUE_DATE,112)
                                 +'^'+B.ITEM_ID
                                 +'^'+ISNULL(B.MARKET, 'X')
               */
               , B.FP_DEMAND_ID
                                 +'::'+ DEMAND_HEAD + ASSIGN_RANK_NO + convert(nvarchar, split_no) AS FP_DEMAND_ID
               , B.SCP_PLAN_ID
               , B.SCP_TARGET_ID
               , B.ITEM_ID
               , B.MFG_WEEK
               , A.NEW_QTY AS MFG_QTY
               , B.MFG_QTY AS SCP_QTY
               , B.WORK_ORDER_ID
               , B.DUE_DATE
               , B.DUE_FENCE_DATE
               , B.PRECEDE_PRODUCING_TERM
               , B.PRECEDE_PRODUCING_TERM_UOM
               , B.PRODUCTION_TYPE
               , B.TO_SITE_ID
               , B.TO_PLANT_ID
               , B.LINE_ID
               , B.MARKET
               , B.PRIORITY + ':' + convert(nvarchar, SPLIT_NO) 
               --, CASE WHEN ASSIGN_SEQ IS NULL THEN B.PRIORITY + '::' + convert(nvarchar, SPLIT_NO) 
               --       ELSE CONVERT(NVARCHAR, 1000000 + ASSIGN_SEQ) + '::' + convert(nvarchar, SPLIT_NO)
               --  END  AS PRIORITY
               , 0 AS OFFSET_QTY
               , B.CONFIRM_TYPE
               , B.DEMAND_TYPE
               , A.LOT_SIZE AS DEMAND_LOT_SIZE
               , A.SITE_ID AS PREFER_SITE_ID
               , A.ROUTE_ID AS PREFER_ROUTE_ID
               , @key_date AS KEY_DATE
          FROM   (
                  SELECT A.*,
                         CASE WHEN SEQ < 10 THEN '00000' + CONVERT(NVARCHAR, SEQ)
                              WHEN SEQ < 100 THEN '0000' + CONVERT(NVARCHAR, SEQ)
                              WHEN SEQ < 1000 THEN '000' + CONVERT(NVARCHAR, SEQ)
                              WHEN SEQ < 10000 THEN '00' + CONVERT(NVARCHAR, SEQ)
                              WHEN SEQ < 100000 THEN '0' + CONVERT(NVARCHAR, SEQ)
                                                 ELSE '' + CONVERT(NVARCHAR, SEQ)
                         END  AS SPLIT_NO,
                         CASE WHEN ASSIGN_RANK < 10 THEN '0' + CONVERT(NVARCHAR, ASSIGN_RANK)
                              WHEN ASSIGN_RANK < 100 THEN '' + CONVERT(NVARCHAR, ASSIGN_RANK)
                         END  AS ASSIGN_RANK_NO
                  FROM   (
                          SELECT A.*,
                                 DENSE_RANK() OVER (PARTITION BY A.TARGET_DEMAND_ID ORDER BY MFG_WEEK, RES_WEEK, A.SITE_ID, A.ROUTE_ID, INT) AS SEQ
                          FROM   (
                                  SELECT A.*, INT,
                                         CASE WHEN INT = SPLIT_CNT AND QTY % LOT_SIZE = 0 THEN LOT_SIZE
                                              WHEN INT = SPLIT_CNT AND QTY % LOT_SIZE > 0 THEN QTY % LOT_SIZE
                                              ELSE LOT_SIZE
                                         END  NEW_QTY
                                  FROM   (-- 할당된 애들
                                          SELECT MASTER_ID, PLAN_ID, TARGET_DEMAND_ID, MFG_WEEK, RES_WEEK, ITEM_ID, 
                                                 SITE_ID, ROUTE_ID, QTY, LOT_SIZE, 'PFD' AS DEMAND_HEAD,
                                                 DENSE_RANK() OVER (PARTITION BY MASTER_ID, PLAN_ID, TARGET_DEMAND_ID
                                                                    ORDER     BY ASSIGN_SEQ) AS ASSIGN_RANK,
                                                 ASSIGN_SEQ, CEILING(QTY / LOT_SIZE) AS SPLIT_CNT
                                          FROM   (
                                                  SELECT A.MASTER_ID, A.PLAN_ID, 
                                                         A.TARGET_DEMAND_ID, 
                                                         A.MFG_WEEK, A.RES_WEEK, A.ITEM_ID, 
                                                         A.SITE_ID, A.ROUTE_ID, A.QTY, 
                                                         CASE WHEN B.EQUIPMENT_COUNT IS NULL THEN A.LOT_SIZE 
                                                              WHEN B.EQUIPMENT_COUNT = 0     THEN A.LOT_SIZE 
                                                              ELSE A.LOT_SIZE * B.EQUIPMENT_COUNT         -- 라인의 설비수를 LOT 에 적용한다.
                                                         END  LOT_SIZE,
                                                         A.ASSIGN_SEQ
                                                  FROM   TH_BUF_SCM_PREFER_DEMAND_ASSIGN A
                                                         LEFT OUTER JOIN (
                                                                          SELECT DIVISION_ID, FACTORY_ID, LINE_ID, OPERATION_ID,
                                                                                 COUNT(1) * 1.000  EQUIPMENT_COUNT
                                                                          FROM   SY_SCM_EQUIPMENT_M
                                                                          WHERE  OPERATION_ID in ( @v_operation_01, @v_operation_02 )
                                                                          AND    EQUIPMENT_TYPE = 'M'
                                                                          AND    ACTIVE_FLAG = 'Y'
                                                                          AND    @res_category = 'LINE'       -- 라인 계획일때만 LINE 에 포함된 설비수를 LOT 에 추가한다.
                                                                          GROUP  BY DIVISION_ID, FACTORY_ID, LINE_ID, OPERATION_ID
                                                                         ) B
                                                              ON   A.DIVISION_ID  = B.DIVISION_ID
                                                              AND  A.SITE_ID      = B.FACTORY_ID
                                                              AND  A.ROUTE_ID     = B.LINE_ID
                                                              AND  A.OPERATION_ID = B.OPERATION_ID
                                                  WHERE  MASTER_ID = @V_MASTER_ID
                                                  AND    PLAN_ID = @V_PLAN_ID
                                                 ) A
                                          UNION  ALL
                                          -- 할당된 안된 애들
                                          SELECT MASTER_ID, PLAN_ID, TARGET_DEMAND_ID, MFG_WEEK, '999999' RES_WEEK, ITEM_ID, 
                                                 NULL SITE_ID, NULL ROUTE_ID, REMAIN_QTY AS QTY, LOT_SIZE, 'NOT' AS DEMAND_HEAD,
                                                 0 ASSIGN_RANK,
                                                 NULL ASSIGN_SEQ, CEILING(REMAIN_QTY / LOT_SIZE) AS SPLIT_CNT
                                          FROM   TH_BUF_SCM_PREFER_DEMAND
                                          WHERE  MASTER_ID = @V_MASTER_ID
                                          AND    PLAN_ID = @V_PLAN_ID
                                          AND    REMAIN_QTY > 0
                                        ) A,
                                        COPYT B
                                  WHERE SPLIT_CNT >= INT                  
                                 ) A
                         ) A
                 ) A,
                 TH_MST_SCM_DEMAND B
          WHERE  A.PLAN_ID = B.DPP_PLAN_ID
          AND    A.TARGET_DEMAND_ID = B.SCP_TARGET_ID


          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END

        ---------------------------------------------------------------------------------------------------
        -- LOT MERGE 하는 부분임 : START
        ---------------------------------------------------------------------------------------------------
        IF CHARINDEX('E_PRE', @v_master_id) > 0 -- 전극 전공정만 해당.
          BEGIN

            UPDATE TH_BUF_SCM_PREFER_DEMAND_SPLIT
            SET    ORG_QTY      = MFG_QTY
            WHERE  INSTANCE_ID  = @v_master_id
            AND    DPP_PLAN_ID  = @v_plan_id
            
            
            UPDATE TH_BUF_SCM_PREFER_DEMAND_SPLIT
            SET    TH_BUF_SCM_PREFER_DEMAND_SPLIT.MFG_QTY = B.NEW_QTY
            FROM   TH_BUF_SCM_PREFER_DEMAND_SPLIT A,
                   (
                    SELECT A.*
                         , CASE WHEN LOT_COUNT  = PRE_LOT_COUNT                                       THEN 0
                                WHEN LOT_COUNT  = TOT_LOT_COUNT  AND TOTAL_QTY % DEMAND_LOT_SIZE > 0  THEN DEMAND_LOT_SIZE * (LOT_COUNT - PRE_LOT_COUNT - 1) + LOT_MOD_QTY
                                                                                                      ELSE DEMAND_LOT_SIZE * (LOT_COUNT - PRE_LOT_COUNT)
                           END  NEW_QTY
                    FROM   (
                            SELECT A.*
                                 , CASE WHEN DEMAND_QTY >= 0 THEN DEMAND_QTY
                                        ELSE 0
                                   END  ETC_QTY
                                 , LAG(LOT_COUNT, 1, 0) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
                                                                           A.ITEM_ID, A.DEMAND_LOT_SIZE
                                                              ORDER     BY A.PRIORITY) PRE_LOT_COUNT
                            FROM   (
                                    SELECT A.*
                                         , CASE WHEN TOTAL_QTY >= LOT_TOTAL_QTY THEN DEMAND_LOT_SIZE
                                                ELSE DEMAND_LOT_SIZE + TOTAL_QTY - LOT_TOTAL_QTY
                                           END  DEMAND_QTY
                                         , CEILING(SUM_QTY    / DEMAND_LOT_SIZE) AS LOT_COUNT
                                         , CEILING(TOTAL_QTY  / DEMAND_LOT_SIZE) AS TOT_LOT_COUNT
                                         , TOTAL_QTY % DEMAND_LOT_SIZE AS LOT_MOD_QTY                            
                                    FROM   (
                                            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SCP_TARGET_ID, A.PRIORITY,
                                                   A.FP_DEMAND_ID, A.ITEM_ID, A.MFG_WEEK, A.MFG_QTY, A.DEMAND_LOT_SIZE,
                                                   SUM(A.MFG_QTY) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
                                                                                     A.ITEM_ID, A.DEMAND_LOT_SIZE
                                                                        ORDER     BY A.PRIORITY)  AS SUM_QTY,
                                                   SUM(A.DEMAND_LOT_SIZE) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
                                                                                             A.ITEM_ID, A.DEMAND_LOT_SIZE
                                                                                ORDER     BY A.PRIORITY)  AS LOT_TOTAL_QTY,
                                                   SUM(A.MFG_QTY) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
                                                                                     A.ITEM_ID, A.DEMAND_LOT_SIZE) AS TOTAL_QTY
                                            FROM   TH_BUF_SCM_PREFER_DEMAND_SPLIT A,
                                                   TH_MST_SCM_DEMAND B
                                            WHERE  A.INSTANCE_ID      = @v_master_id
                                            AND    A.DPP_PLAN_ID      = @v_plan_id
                                            AND    A.INSTANCE_ID      = B.INSTANCE_ID
                                            AND    A.DPP_pLAN_ID      = B.DPP_PLAN_ID
                                            AND    A.SCP_TARGET_ID    = B.SCP_TARGET_ID
                                            AND    B.PRODUCTION_TYPE  NOT IN ('TEST')
                                           ) A
                                   ) A
                           ) A
                    /*
                    SELECT A.*,
                           CASE WHEN DEMAND_QTY >= 0 THEN DEMAND_QTY
                                ELSE 0
                           END  NEW_QTY
                    FROM   (
                            SELECT A.*,
                                   CASE WHEN TOTAL_QTY >= LOT_TOTAL_QTY THEN DEMAND_LOT_SIZE
                                        ELSE DEMAND_LOT_SIZE + TOTAL_QTY - LOT_TOTAL_QTY
                                   END  DEMAND_QTY
                            FROM   (
                                    SELECT --COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SCP_TARGET_ID, 
                                           A.FP_DEMAND_ID, A.ITEM_ID, A.MFG_WEEK, A.MFG_QTY, A.DEMAND_LOT_SIZE,
                                           SUM(A.MFG_QTY) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
                                                                             A.ITEM_ID, A.DEMAND_LOT_SIZE
                                                                ORDER     BY A.PRIORITY)  AS SUM_QTY,
                                           SUM(A.DEMAND_LOT_SIZE) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
                                                                                     A.ITEM_ID, A.DEMAND_LOT_SIZE
                                                                        ORDER     BY A.PRIORITY)  AS LOT_TOTAL_QTY,
                                           SUM(A.MFG_QTY) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
                                                                             A.ITEM_ID, A.DEMAND_LOT_SIZE) AS TOTAL_QTY
                                    FROM   TH_BUF_SCM_PREFER_DEMAND_SPLIT A,
                                           TH_MST_SCM_DEMAND B
                                    WHERE  A.INSTANCE_ID      = @v_master_id
                                    AND    A.DPP_PLAN_ID      = @v_plan_id
                                    AND    A.INSTANCE_ID      = B.INSTANCE_ID
                                    AND    A.DPP_pLAN_ID      = B.DPP_PLAN_ID
                                    AND    A.SCP_TARGET_ID    = B.SCP_TARGET_ID
                                    AND    B.PRODUCTION_TYPE  NOT IN ('TEST')
                                   ) A
                            WHERE  DEMAND_LOT_SIZE < TOTAL_QTY
                           ) A
                    */
                   ) B
            WHERE  A.INSTANCE_ID  = @v_master_id
            AND    A.DPP_PLAN_ID  = @v_plan_id
            AND    A.FP_DEMAND_ID = B.FP_DEMAND_ID                      
          
            SET @n_row_count = @@ROWCOUNT

            --LOG 생성
            SET @v_message = 'LOT MERGE : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

            UPDATE TH_BUF_SCM_PREFER_DEMAND_SPLIT
            SET    TH_BUF_SCM_PREFER_DEMAND_SPLIT.MFG_QTY = B.MIN_LOT_SIZE
            FROM   TH_BUF_SCM_PREFER_DEMAND_SPLIT A,
                   (
                    SELECT A.*
                         , CEILING(A.DEMAND_LOT_SIZE * MIN_LOT_RATE) AS MIN_LOT_SIZE
                    FROM   (
                            SELECT A.*
                            FROM   TH_BUF_SCM_PREFER_DEMAND_SPLIT A,
                                   TH_MST_SCM_DEMAND B
                            WHERE  A.INSTANCE_ID      = @v_master_id
                            AND    A.DPP_PLAN_ID      = @v_plan_id
                            AND    A.INSTANCE_ID      = B.INSTANCE_ID
                            AND    A.DPP_pLAN_ID      = B.DPP_PLAN_ID
                            AND    A.SCP_TARGET_ID    = B.SCP_TARGET_ID
                            AND    B.PRODUCTION_TYPE  NOT IN ('TEST')
                            AND    A.MFG_QTY          > 0
                            AND    A.DEMAND_LOT_SIZE  > 0
                            AND    A.DEMAND_LOT_SIZE  > A.MFG_QTY
                           ) A,
                           (
                            SELECT SEGMENT2 AS FACTORY_ID
                                  , CONVERT(NUMERIC(20,10), ATTRIBUTE1) MIN_LOT_RATE
                            FROM   SY_SCM_SYS_LOOKUP_VALUE
                            WHERE  LOOKUP_TYPE_CODE = 'MIN_BATCH_SIZE'
                            AND    SEGMENT3         IN ('E1000', 'S1000')
                            AND    CONVERT(NUMERIC(20,10), ATTRIBUTE1) > 0
                           ) C
                    WHERE  A.PREFER_SITE_ID = C.FACTORY_ID
                    AND    ( A.MFG_QTY / A.DEMAND_LOT_SIZE ) < MIN_LOT_RATE
                   ) B
            WHERE  A.INSTANCE_ID  = @v_master_id
            AND    A.DPP_PLAN_ID  = @v_plan_id
            AND    A.FP_DEMAND_ID = B.FP_DEMAND_ID
            
            SET @n_row_count = @@ROWCOUNT

            --LOG 생성
            SET @v_message = 'BATCH MIN LOT : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          END
        
        ---------------------------------------------------------------------------------------------------
        -- LOT MERGE 하는 부분임 : END
        ---------------------------------------------------------------------------------------------------

        BEGIN
        
          select @v_late_type = MAX(VALUE)
          FROM   TH_CFG_CONFIG_VALUE
          WHERE  CONFIG_SET_ID = @v_config_set_id
          AND    PLAN_TYPE = 'ENGINE' 
          AND    KEY_ID = 'LATE' 
        
          SET @v_message  = '@v_late_type : ' + @v_late_type
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

          IF @v_late_type = 'DUE_LATE'    -- DUE_LATE 는 FENCE 가 PET 임
            BEGIN
            
            UPDATE TH_BUF_SCM_PREFER_DEMAND_SPLIT
            SET    TH_BUF_SCM_PREFER_DEMAND_SPLIT.DUE_FENCE_DATE = B.DUE_FENCE_DATE
            FROM   TH_BUF_SCM_PREFER_DEMAND_SPLIT A,
                   (
                    SELECT CONFIRM_TYPE, MAX(DUE_FENCE_DATE) AS DUE_FENCE_DATE
                    FROM   TH_BUF_SCM_PREFER_DEMAND_SPLIT
                    WHERE  DPP_PLAN_ID = @v_plan_id
                    GROUP  BY CONFIRM_TYPE
                   ) B
            WHERE  A.DPP_PLAN_ID = @v_plan_id
            AND    A.CONFIRM_TYPE = B.CONFIRM_TYPE

              /*            
              SET @v_table_name = 'TH_BUF_SCM_DEMAND_SPLIT - DUE_FENCE_DATE : PET'

              UPDATE TH_BUF_SCM_DEMAND_SPLIT
              SET    DUE_FENCE_DATE = @plan_end_time
              WHERE  DPP_PLAN_ID    = @v_plan_id
              */

              SET @n_row_count = @@ROWCOUNT

              --LOG 생성
              SET @v_message = @n_row_count
              SET @n_log_count = @n_log_count + 1
              SET @sysdate = GETDATE()
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
              
            END
            
        END

        -- FP_DAILY_NET_DEMAND_H, TH_DPP_NET_DEMAND, + BACK, TH_ENG_NET_DEMAND 새로 생성
        BEGIN
        
          SET @v_table_name = 'FP_DAILY_NET_DEMAND_H'
          SET @n_row_count = 0

          DELETE FROM A
          FROM   SY_FP_DAILY_NET_DEMAND_H A
          WHERE  A.INSTANCE_ID = @v_master_id
          AND    A.DPP_PLAN_ID = @v_plan_id
          AND    EXISTS (
                          SELECT 1
                          FROM   (
                                  SELECT NET_DEMAND_ID
                                  FROM   TH_DPP_NET_DEMAND A,
                                         (SELECT FP_DEMAND_ID AS DEMAND_ID, 
                                                 MAX(DIVISION_ID) AS DIVISION_ID
                                          FROM   SY_FP_DAILY_NET_DEMAND_H 
                                          WHERE  INSTANCE_ID = @v_master_id
                                          AND    DPP_PLAN_ID = @v_plan_id
                                          GROUP BY FP_DEMAND_ID) B,
                                         (select item_id, count(route_id) as assign_cnt
                                          from   th_mst_op_resource
                                          where  master_id = @v_master_id
                                          and    plan_id = @v_plan_id
                                          and    operation_id in ( @v_operation_01, @v_operation_02 )
                                          and    alt_priority in (1,2,3,4,5,6,7,8)    -- 0, 9 번은 대상에서 제외되므로 조건처리
                                          group by item_id) C
                                  WHERE  A.NET_DEMAND_ID = B.DEMAND_ID
                                  AND    A.ITEM_ID = C.ITEM_ID
                                  AND    A.MASTER_ID = @v_master_id
                                  AND    A.PLAN_ID = @v_plan_id
                                  AND    ISNULL(A.PO_TYPE,'NULL') <> 'FIX'      -- ## 확정  DEMAND는 제외..!!
                                  AND    ISNULL(A.PO_TYPE,'NULL') <> 'STOCK'    -- ## STOCK DEMAND는 제외..!!
                                  --AND    ISNULL(A.ORDER_TYPE,'NULL') <> 'TEST'  -- ## TEST  DEMAND는 제외..!!
                                  AND    A.QTY > 0
                                 ) X
                          WHERE  X.NET_DEMAND_ID = A.FP_DEMAND_ID
                         )



          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

          INSERT INTO SY_FP_DAILY_NET_DEMAND_H
              (
                 COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , SHOP_GROUP_ID
               , INSTANCE_ID
               , DPP_PLAN_ID
               , FP_DEMAND_ID
               , SCP_PLAN_ID
               , SCP_TARGET_ID
               , ITEM_ID
               , MFG_WEEK
               , MFG_QTY
               , SCP_QTY
               , WORK_ORDER_ID
               , DUE_DATE
               , DUE_FENCE_DATE
               , PRECEDE_PRODUCING_TERM
               , PRECEDE_PRODUCING_TERM_UOM
               , PRODUCTION_TYPE
               , TO_SITE_ID
               , TO_PLANT_ID
               , LINE_ID
               , MARKET
               , PRIORITY
               , OFFSET_QTY
               , CONFIRM_TYPE
               , DEMAND_TYPE
               , INSERT_ID
               , INSERT_TIME
               , UPDATE_ID
               , UPDATE_TIME
              )
          SELECT
                 A.COMPANY_ID
               , A.DIVISION_ID
               , A.SITE_ID
               , A.PLANT_ID
               , A.SHOP_GROUP_ID
               , A.INSTANCE_ID
               , A.DPP_PLAN_ID
               , A.FP_DEMAND_ID
               , A.SCP_PLAN_ID
               , A.SCP_TARGET_ID
               , A.ITEM_ID
               , A.MFG_WEEK
               , A.MFG_QTY
               , B.MFG_QTY AS SCP_QTY
               , A.WORK_ORDER_ID
               , A.DUE_DATE
               , A.DUE_FENCE_DATE
               , A.PRECEDE_PRODUCING_TERM
               , A.PRECEDE_PRODUCING_TERM_UOM
               , A.PRODUCTION_TYPE
               , A.TO_SITE_ID
               , A.TO_PLANT_ID
               , A.LINE_ID
               , A.MARKET
               , A.PRIORITY
               , A.OFFSET_QTY
               , A.CONFIRM_TYPE
               , A.DEMAND_TYPE
               , @v_proc_name AS INSERT_ID
               , GETDATE()    AS INSERT_TIME
               , @v_proc_name AS UPDATE_ID
               , GETDATE()    AS UPDATE_TIME                     
          FROM   TH_BUF_SCM_PREFER_DEMAND_SPLIT A,
                 TH_BUF_SCM_DEMAND B
          WHERE  A.DPP_PLAN_ID    = @v_plan_id
          AND    A.DPP_PLAN_ID    = B.DPP_PLAN_ID
          AND    A.SCP_TARGET_ID  = B.SCP_TARGET_ID
          AND    B.DEMAND_TYPE   <> 'FIX'

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          INSERT INTO SY_FP_DAILY_NET_DEMAND_H
              (
                 COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , SHOP_GROUP_ID
               , INSTANCE_ID
               , DPP_PLAN_ID
               , FP_DEMAND_ID
               , SCP_PLAN_ID
               , SCP_TARGET_ID
               , ITEM_ID
               , MFG_WEEK
               , MFG_QTY
               , SCP_QTY
               , WORK_ORDER_ID
               , DUE_DATE
               , DUE_FENCE_DATE
               , PRECEDE_PRODUCING_TERM
               , PRECEDE_PRODUCING_TERM_UOM
               , PRODUCTION_TYPE
               , TO_SITE_ID
               , TO_PLANT_ID
               , LINE_ID
               , MARKET
               , PRIORITY
               , OFFSET_QTY
               , CONFIRM_TYPE
               , DEMAND_TYPE
               , INSERT_ID
               , INSERT_TIME
               , UPDATE_ID
               , UPDATE_TIME
              )
          SELECT
                 A.COMPANY_ID
               , A.DIVISION_ID
               , A.SITE_ID
               , A.PLANT_ID
               , A.SHOP_GROUP_ID
               , @v_master_id     AS INSTANCE_ID
               , A.DPP_PLAN_ID
               , A.FP_DEMAND_ID + '::PFD00000000' AS FP_DEMAND_ID
               , A.SCP_PLAN_ID
               , A.SCP_TARGET_ID
               , A.ITEM_ID
               , A.MFG_WEEK
               , 0                AS MFG_QTY
               , A.MFG_QTY        AS SCP_QTY
               , A.WORK_ORDER_ID
               , A.DUE_DATE
               , A.DUE_FENCE_DATE
               , A.PRECEDE_PRODUCING_TERM
               , A.PRECEDE_PRODUCING_TERM_UOM
               , A.PRODUCTION_TYPE
               , A.TO_SITE_ID
               , A.TO_PLANT_ID
               , A.LINE_ID
               , A.MARKET
               , A.PRIORITY
               , 0          AS OFFSET_QTY
               , A.CONFIRM_TYPE
               , A.DEMAND_TYPE
               , @v_proc_name AS INSERT_ID
               , GETDATE()    AS INSERT_TIME
               , @v_proc_name AS UPDATE_ID
               , GETDATE()    AS UPDATE_TIME                     
          FROM   TH_BUF_SCM_DEMAND A
          WHERE  A.DPP_PLAN_ID  = @v_plan_id
          AND    NOT EXISTS (
                              SELECT 1
                              FROM   SY_FP_DAILY_NET_DEMAND_H X
                              WHERE  X.INSTANCE_ID    = @v_master_id
                              AND    X.DPP_PLAN_ID    = A.DPP_PLAN_ID
                              AND    X.SCP_TARGET_ID  = A.SCP_TARGET_ID
                            )
          
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


          SET @v_table_name = 'TH_DPP_NET_DEMAND'

          DELETE FROM A
          FROM   TH_DPP_NET_DEMAND A,
                 (select item_id, count(route_id) as assign_cnt
                  from   th_mst_op_resource
                  where  master_id = @v_master_id
                  and    plan_id = @v_plan_id
                  and    operation_id in ( @v_operation_01, @v_operation_02 )
                  and    alt_priority in (1,2,3,4,5,6,7,8)    -- 0, 9 번은 대상에서 제외되므로 조건처리
                  group by item_id) C
          WHERE  A.ITEM_ID = C.ITEM_ID
          AND    A.MASTER_ID = @v_master_id
          AND    A.PLAN_ID = @v_plan_id
          AND    ISNULL(A.PO_TYPE,'NULL') <> 'FIX'      -- ## 확정 DEMAND는 제외..!!
          AND    ISNULL(A.PO_TYPE,'NULL') <> 'STOCK'    -- ## 확정 DEMAND는 제외..!!
          --AND    ISNULL(A.ORDER_TYPE,'NULL') <> 'TEST'  -- ## TEST  DEMAND는 제외..!!
          AND    A.QTY > 0

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

          INSERT INTO TH_DPP_NET_DEMAND
                   (MASTER_ID
                   ,PLAN_ID
                   ,NET_DEMAND_ID
                   ,DEMAND_ID
                   ,PRODUCTION_ORDER_ID
                   ,SALES_MODEL
                   ,ITEM_ID
                   ,QTY
                   ,DUE_DATE
                   ,SHIPPING_DATE
                   ,DUE_FENCE_DATE
                   ,MFG_WEEK
                   ,SPLIT_DATE
                   ,PO_TYPE
                   ,ORDER_TYPE
                   ,FROM_SITE_ID
                   ,TO_SITE_ID
                   ,MARKET
                   ,DEMAND_GROUP_PRIORITY
                   ,DEMAND_PRIORITY
                   ,EARLY_PRODUCING_TERM
                   ,EARLY_PRODUCING_TERM_UOM
                   ,IS_CONSUME
                   ,KEY_DATE
                   ,INSERT_ID
                   ,INSERT_DTTM
                   ,UPDATE_ID
                   ,UPDATE_DTTM)
          SELECT DISTINCT
                  A.INSTANCE_ID       AS MASTER_ID
                 ,A.DPP_PLAN_ID       AS PLAN_ID
                 ,A.FP_DEMAND_ID      AS NET_DEMAND_ID
                 ,A.SCP_TARGET_ID     AS DEMAND_ID
                 ,A.WORK_ORDER_ID     AS PRODUCTION_ORDER_ID
                 ,B.ITEM_ID           AS SALES_MODEL
                 ,A.ITEM_ID           AS ITEM_ID
                 ,A.MFG_QTY           AS QTY
                 ,A.DUE_DATE
                 ,A.DUE_DATE          AS SHIPPING_DATE
                 ,A.DUE_FENCE_DATE
                 ,A.MFG_WEEK
                 ,A.DUE_DATE          AS SPLIT_DATE
                 ,'NOR'               AS PO_TYPE
                 ,A.PRODUCTION_TYPE   AS ORDER_TYPE
                 ,NULL                AS FROM_SITE_ID
                 ,A.TO_SITE_ID
                 ,B.MARKET
                 ,CASE WHEN B.PRODUCTION_TYPE = 'TEST' THEN '1:'
                       ELSE '2:' 
                  END  + A.MFG_WEEK   AS DEMAND_GROUP_PRIORITY
                 ,A.PRIORITY
                 ,A.PRECEDE_PRODUCING_TERM  AS EARLY_PRODUCING_TERM
                 ,A.PRECEDE_PRODUCING_TERM_UOM AS EARLY_PRODUCING_TERM_UOM
                 ,'Y'                 AS IS_CONSUME
                 ,A.KEY_DATE
                 , @v_proc_name AS INSERT_ID
                 , GETDATE()    AS INSERT_TIME
                 , @v_proc_name AS UPDATE_ID
                 , GETDATE()    AS UPDATE_TIME                     
          FROM   TH_BUF_SCM_PREFER_DEMAND_SPLIT A,
                 TH_MST_SCM_DEMAND B
          WHERE  A.INSTANCE_ID    = @v_master_id
          AND    A.DPP_PLAN_ID    = @v_plan_id
          AND    A.DPP_PLAN_ID    = B.DPP_PLAN_ID
          AND    A.SCP_TARGET_ID  = B.SCP_TARGET_ID

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          SET @v_table_name = 'TH_DPP_NET_DEMAND BAK'
          
          DELETE FROM TH_DPP_NET_DEMAND
          WHERE   MASTER_ID   = @v_master_id
          AND     PLAN_ID     = RTRIM(LTRIM(ISNULL(@v_plan_id, '') + 'BAK'))
          
          INSERT INTO TH_DPP_NET_DEMAND
                   (MASTER_ID
                   ,PLAN_ID
                   ,NET_DEMAND_ID
                   ,DEMAND_ID
                   ,PRODUCTION_ORDER_ID
                   ,SALES_MODEL
                   ,ITEM_ID
                   ,QTY
                   ,DUE_DATE
                   ,SHIPPING_DATE
                   ,DUE_FENCE_DATE
                   ,MFG_WEEK
                   ,SPLIT_DATE
                   ,ORDER_TYPE
                   ,FROM_SITE_ID
                   ,TO_SITE_ID
                   ,MARKET
                   ,DEMAND_GROUP_PRIORITY
                   ,DEMAND_PRIORITY
                   ,EARLY_PRODUCING_TERM
                   ,EARLY_PRODUCING_TERM_UOM
                   ,IS_CONSUME               
                   ,KEY_DATE
                   ,INSERT_ID
                   ,INSERT_DTTM
                   ,UPDATE_ID
                   ,UPDATE_DTTM)
          SELECT    MASTER_ID
                   ,RTRIM(LTRIM(ISNULL(@v_plan_id, '') + 'BAK')) AS PLAN_ID
                   ,NET_DEMAND_ID
                   ,DEMAND_ID
                   ,PRODUCTION_ORDER_ID
                   ,SALES_MODEL
                   ,ITEM_ID
                   ,QTY
                   ,DUE_DATE
                   ,SHIPPING_DATE
                   ,DUE_FENCE_DATE
                   ,MFG_WEEK
                   ,SPLIT_DATE
                   ,ORDER_TYPE
                   ,FROM_SITE_ID
                   ,TO_SITE_ID
                   ,MARKET
                   ,DEMAND_GROUP_PRIORITY
                   ,DEMAND_PRIORITY
                   ,EARLY_PRODUCING_TERM
                   ,EARLY_PRODUCING_TERM_UOM
                   ,IS_CONSUME               
                   ,@key_date AS KEY_DATE
                   ,@v_proc_name as INSERT_ID
                   ,GETDATE() as INSERT_DTTM
                   ,@v_proc_name as UPDATE_ID
                   ,getdate() as UPDATE_DTTM
          FROM    TH_DPP_NET_DEMAND C
          WHERE   MASTER_ID   = @v_master_id
          AND     PLAN_ID     = @v_plan_id
          
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


          SET @v_table_name = 'TH_ENG_NET_DEMAND'
          SET @n_row_count = 0

          DELETE FROM TH_ENG_NET_DEMAND
          WHERE  PLAN_ID = @v_plan_id

          INSERT INTO dbo.TH_ENG_NET_DEMAND
               (
                MASTER_ID, 
                PLAN_ID, 
                DEMAND_ID, 
                SALES_MODEL_ID, 
                SHIPPING_DATE, 
                DUE_DATE, 
                DUE_FENCE_DATE, 
                EARLY_PRODUCING_TERM, 
                EARLY_PRODUCING_TERM_UOM, 
                QTY, 
                SPLIT_QTY, 
                ORDER_TYPE, 
                DEMAND_TYPE, 
                PRODUCING_TYPE, 
                PRIORITY, 
                PRIORITY_GROUP_CODE, 
                ATTRIBUTE_CHECKER_ID, 
                DEMAND_GROUP_ID, 
                LATE_TYPE,
                DESCR, 
                MOVE_TIME_RATE, 
                BUFFER_TIME_RATE, 
                IS_EXCEPTION,
                IS_CONSUME
               )
          SELECT 
                a.MASTER_ID, 
                a.PLAN_ID, 
                a.NET_DEMAND_ID, 
                a.SALES_MODEL AS sales_model_id, 
                DATEADD(MINUTE, 1440 + @v_daydiff, a.SHIPPING_DATE)   AS SHIPPING_DATE, 
                DATEADD(MINUTE, 1440 + @v_daydiff, a.DUE_DATE)        AS DUE_DATE, 
                DATEADD(MINUTE, 1440 + @v_daydiff, a.DUE_FENCE_DATE)  AS DUE_FENCE_DATE, 
                a.EARLY_PRODUCING_TERM, 
                a.EARLY_PRODUCING_TERM_UOM, 
                a.QTY, 
                a.SPLIT_QTY, 
                a.ORDER_TYPE, 
                CASE WHEN isnull(b.fix_demand_id, '-') = a.NET_DEMAND_ID  THEN 'FIX'
                     ELSE CASE c.PLAN_TYPE
                              WHEN 'PRE' THEN a.DEMAND_TYPE
                              ELSE 'SYNC'
                          END
                END  AS demand_type, 
                a.PRODUCING_TYPE, 
                a.DEMAND_PRIORITY AS priority, 
                a.DEMAND_GROUP_PRIORITY AS priority_group_code, 
                a.ATTRIBUTE_CHECKER_ID, 
                a.NET_DEMAND_ID AS demand_group_id,       -- 2016.11.15 
                --'FENCEDATE_OVERLAP' AS LATE_TYPE,
                NULL AS LATE_TYPE,
                a.DESCR, 
                1 AS move_time_rate, 
                1 AS buffer_time_rate, 
                a.IS_EXCEPTION,
                a.IS_CONSUME
          FROM  dbo.TH_DPP_NET_DEMAND  AS a 
                LEFT OUTER JOIN (
                                  SELECT DISTINCT a.DEMAND_ID AS fix_demand_id
                                  FROM  dbo.TH_MST_FIXED_PLAN  AS a
                                        INNER JOIN dbo.TH_MST_ITEM  AS b
                                              ON  a.MASTER_ID = b.MASTER_ID 
                                              AND a.PLAN_ID = b.PLAN_ID
                                              AND a.ITEM_ID = b.ITEM_ID 
                                              AND b.ITEM_TYPE = 'P' 
                                  WHERE a.MASTER_ID = @v_master_id 
                                  AND   a.PLAN_ID = @v_plan_id 
                                  AND   a.PO_TYPE = 'FIX' 
                                  AND   RTRIM(LTRIM(a.DEMAND_ID)) IS NOT NULL 
                                ) AS b 
                      ON  a.NET_DEMAND_ID = b.fix_demand_id
                INNER JOIN dbo.TH_MST_PLAN C
                      ON  a.MASTER_ID = c.MASTER_ID 
                      AND a.PLAN_ID = c.PLAN_ID
                WHERE a.MASTER_ID = @v_master_id 
                AND   a.PLAN_ID = @v_plan_id 
                AND   a.IS_SCHEDULE = 'Y'

            SET @n_row_count = @@ROWCOUNT

            --LOG 생성
            SET @v_message = @n_row_count
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          BEGIN
          
            UPDATE TH_ENG_NET_DEMAND
            SET    TH_ENG_NET_DEMAND.DUE_DATE =       CASE WHEN DUE_DATE > PLAN_START_DTTM + DEMAND_HORIZON  THEN PLAN_START_DTTM + DEMAND_HORIZON
                                                           WHEN DUE_DATE < PLAN_START_DTTM                   THEN PLAN_START_DTTM + 1
                                                           ELSE DUE_DATE
                                                      END,
                   TH_ENG_NET_DEMAND.DUE_FENCE_DATE = CASE WHEN DUE_FENCE_DATE > PLAN_START_DTTM + DEMAND_HORIZON THEN PLAN_START_DTTM + DEMAND_HORIZON
                                                           WHEN DUE_FENCE_DATE < PLAN_START_DTTM                  THEN PLAN_START_DTTM + 1
                                                      ELSE DUE_FENCE_DATE
                                                      END,
                   TH_ENG_NET_DEMAND.SHIPPING_DATE  = CASE WHEN SHIPPING_DATE > PLAN_START_DTTM + DEMAND_HORIZON THEN PLAN_START_DTTM + DEMAND_HORIZON
                                                           WHEN SHIPPING_DATE < PLAN_START_DTTM                  THEN PLAN_START_DTTM + 1
                                                      ELSE SHIPPING_DATE
                                                      END
            FROM   TH_ENG_NET_DEMAND A,
                   TH_ENG_PLAN_INFO B
            WHERE  A.MASTER_ID = B.MASTER_ID
            AND    A.PLAN_ID = B.PLAN_ID
            AND    A.MASTER_ID = @v_master_id
            AND    A.PLAN_ID = @v_plan_id

            SET @n_row_count = @@ROWCOUNT

            --LOG 생성
            SET @v_message = @n_row_count
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          END
          /*
          BEGIN
          
            SET @v_table_name = 'TH_ENG_NET_DEMAND'
            SET @n_row_count = 0

            DELETE FROM A
            FROM   TH_ENG_FIXED_PLAN A,
                   TH_DPP_NET_DEMAND B
            WHERE  A.MASTER_ID  = @v_master_id
            AND    A.PLAN_ID    = @v_plan_id
            AND    A.MASTER_ID  = B.MASTER_ID
            AND    A.PLAN_ID    = B.PLAN_ID
            AND    A.DEMAND_ID  = B.NET_DEMAND_ID
            AND    B.PO_TYPE    = 'FIX'            
            
            SET @n_row_count = @@ROWCOUNT

            --LOG 생성
            SET @v_message = @n_row_count
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
          END
          */
          
        END

      END
      
    ELSE -- ## SYNC
    
      BEGIN

        /*
          Prefer Demand 설정
        */
        
        BEGIN

          SET @v_table_name = '@PREFER_DMD_SET'
          SET @n_row_count = 0

          -- ## SYNC Prefer 생성..!!
          
          insert into th_buf_scm_prefer_demand_split
               ( instance_id, dpp_plan_id, division_id, mfg_week, item_id, prefer_site_id, prefer_route_id, 
                 fp_demand_id, mfg_qty, due_date, priority, key_date )
          select distinct
                 a.master_id, a.plan_id, '-' as division_id, a.mfg_week, a.item_id, b.site_id, b.route_id, 
                 a.net_demand_id as demand_id, a.qty, b.due_date, b.demand_priority, convert(nvarchar, getdate(), 112) as key_date
          from   th_dpp_net_demand a,
                 (select a.demand_id, a.item_id, a.site_id, a.route_id, 
                         min(a.start_date) as due_date, 
                         min(convert(nvarchar, a.start_date, 112)+':'+dbo.fn_lpad_nvarchar(setup_seq,5,'0')+':'+a.work_order_seq) as demand_priority
                  from   th_mst_fixed_plan a,
                         (select demand_id, item_id, site_id, route_id, start_date, item_qty,
                                 dense_rank() over (partition by start_date order by item_qty desc,case when item_min = item_max then 1 else 9 end,route_id) as setup_seq
                          from   (select demand_id, item_id, site_id, route_id, start_date,
                                         sum(complete_qty) over (partition by start_date,item_id) as item_qty,
                                         min(item_id) over (partition by start_date,site_id,route_id) as item_min,
                                         max(item_id) over (partition by start_date,site_id,route_id) as item_max
                                  from   th_mst_fixed_plan
                                  where  master_id = @v_master_id
                                  and    plan_id = @v_plan_id
                                  and    isnull(po_type,'NULL') <> 'FIX' -- ## 확정 Demand는 제외..!!
                                  and    isnull(po_type,'NULL') <> 'STOCK' -- ## 확정 Demand는 제외..!!
                                  and    demand_id is not null
                                  ) a
                          ) b
                  where  a.demand_id = b.demand_id
                  and    a.item_id = b.item_id
                  and    a.site_id = b.site_id
                  and    a.route_id = b.route_id
                  and    a.start_date = b.start_date
                  and    a.master_id = @v_master_id
                  and    a.plan_id = @v_plan_id
                  and    isnull(a.po_type,'NULL') <> 'FIX' -- ## 확정 Demand는 제외..!!
                  and    isnull(a.po_type,'NULL') <> 'STOCK' -- ## 확정 Demand는 제외..!!
                  and    a.demand_id is not null
                  group by a.demand_id,a.item_id,a.site_id,a.route_id) b            
          where  a.net_demand_id = b.demand_id
          and    a.master_id = @v_master_id
          and    a.plan_id = @v_plan_id
          and    isnull(a.po_type,'NULL') <> 'FIX' -- ## 확정 Demand는 제외..!!
          and    isnull(a.po_type,'NULL') <> 'STOCK' -- ## 확정 Demand는 제외..!!
          and    a.qty > 0

          /*
          insert into th_buf_scm_prefer_demand_result
               ( master_id, plan_id, division_id, mfg_week, item_id, site_id, route_id, 
                 demand_id, qty, due_date, demand_priority, insert_dttm )
          select distinct
                 a.master_id, a.plan_id, '-' as division_id, a.mfg_week, a.item_id, b.site_id, b.route_id, 
                 a.net_demand_id as demand_id, a.qty, b.due_date, b.demand_priority, getdate() as insert_dttm
          from   th_dpp_net_demand a,
                 (select a.demand_id, a.item_id, a.site_id, a.route_id, 
                         min(a.start_date) as due_date, 
                         min(convert(nvarchar, a.start_date, 112)+':'+dbo.fn_lpad_nvarchar(setup_seq,5,'0')+':'+a.work_order_seq) as demand_priority
                  from   th_mst_fixed_plan a,
                         (select demand_id, item_id, site_id, route_id, start_date, item_qty,
                                 dense_rank() over (partition by start_date order by item_qty desc,case when item_min = item_max then 1 else 9 end,route_id) as setup_seq
                          from   (select demand_id, item_id, site_id, route_id, start_date,
                                         sum(complete_qty) over (partition by start_date,item_id) as item_qty,
                                         min(item_id) over (partition by start_date,site_id,route_id) as item_min,
                                         max(item_id) over (partition by start_date,site_id,route_id) as item_max
                                  from   th_mst_fixed_plan
                                  where  master_id = @v_master_id
                                  and    plan_id = @v_plan_id
                                  and    isnull(po_type,'NULL') <> 'FIX' -- ## 확정 Demand는 제외..!!
                                  and    demand_id is not null
                                  ) a
                          ) b
                  where  a.demand_id = b.demand_id
                  and    a.item_id = b.item_id
                  and    a.site_id = b.site_id
                  and    a.route_id = b.route_id
                  and    a.start_date = b.start_date
                  and    a.master_id = @v_master_id
                  and    a.plan_id = @v_plan_id
                  and    isnull(a.po_type,'NULL') <> 'FIX' -- ## 확정 Demand는 제외..!!
                  and    a.demand_id is not null
                  group by a.demand_id,a.item_id,a.site_id,a.route_id) b            
          where  a.net_demand_id = b.demand_id
          and    a.master_id = @v_master_id
          and    a.plan_id = @v_plan_id
          and    isnull(a.po_type,'NULL') <> 'FIX' -- ## 확정 Demand는 제외..!!
          and    a.qty > 0
          */


          -- ## FIX Demand Priority Group 조정..!!
          update th_eng_net_demand
          set    priority_group_code = '0##' + priority_group_code
          where  master_id = @v_master_id
          and    plan_id = @v_plan_id
          and    demand_id in (select net_demand_id
                               from   th_dpp_net_demand
                               where  master_id = @v_master_id
                               and    plan_id = @v_plan_id
                               and    isnull(po_type,'NULL') = 'FIX' -- ## 확정 Demand..!!
                               and    isnull(po_type,'NULL') = 'STOCK' -- ## 확정 Demand..!!
                              )
                               
          -- ## SYNC Demand Priority Group 조정..!!
          update th_eng_net_demand
          set    th_eng_net_demand.priority_group_code = '1##' + b.week
          from   th_eng_net_demand a,
                 (
                  select a.instance_id, a.dpp_plan_id, a.fp_demand_id, b.week
                  from   th_buf_scm_prefer_demand_split a,
                         sy_scm_sys_calendar_m b
                  where  a.due_date  = b.date_id
                  and    instance_id = @v_master_id
                  and    dpp_plan_id = @v_plan_id
                 ) b
          where  a.demand_id = b.fp_demand_id
          and    a.master_id = @v_master_id
          and    a.plan_id   = @v_plan_id          
          
          /*
          update th_eng_net_demand
          set    priority_group_code = '1'
          where  master_id = @v_master_id
          and    plan_id = @v_plan_id
          and    demand_id in (select fp_demand_id
                               from   th_buf_scm_prefer_demand_split
                               where  instance_id = @v_master_id
                               and    dpp_plan_id = @v_plan_id) -- ## SYNC Demand..!!        
          */

          -- ## ETC Demand Priority Group 조정..!!
          update th_eng_net_demand
          set    priority_group_code = '9##' + priority_group_code
          where  master_id = @v_master_id
          and    plan_id = @v_plan_id
          and    substring(priority_group_code, 1, 3) not in ('0##','1##') -- ## ETC Demand..!!                                    

        
          -- ## SYNC Demand 납기 및 선행 조정..!!
          update th_eng_net_demand
          set    --th_eng_net_demand.due_date = DATEADD(MINUTE, 1440 + @v_daydiff + 1440, a.SHIPPING_DATE)   , -- ## 조정 일자 Start 기준 + 1일로 종료 시점..!! ( 1440 분 )
                 --th_eng_net_demand.due_date       = DATEADD(MINUTE, 1440 + @v_daydiff + 1440, b.due_date)   , -- ## 조정 일자 Start 기준 + 1일로 종료 시점..!! ( 1440 분 )
                 --th_eng_net_demand.shipping_date  = DATEADD(MINUTE, 1440 + @v_daydiff + 1440, b.due_date)   , -- ## 조정 일자 Start 기준 + 1일로 종료 시점..!! ( 1440 분 )
                 --th_eng_net_demand.early_producing_term = 1, -- ## due_date가 종료 시점이므로 1일 선행 설정..!!
                 th_eng_net_demand.priority       = b.demand_priority -- ## SYNC WorkOrderSeq 기준임..!!
          from   th_eng_net_demand a,
                 (select fp_demand_id, 
                         convert(datetime, min(due_date)) as due_date, min(priority) as demand_priority
                  from   th_buf_scm_prefer_demand_split
                  where  instance_id = @v_master_id
                  and    dpp_plan_id = @v_plan_id
                  group by fp_demand_id) b
          where  a.demand_id = b.fp_demand_id
          and    a.master_id = @v_master_id
          and    a.plan_id = @v_plan_id


          -- ## SYNC Fixed Plan 데이터 삭제..!!
          delete from th_eng_fixed_plan
          where  master_id = @v_master_id
          and    plan_id = @v_plan_id
          and    demand_id in (select fp_demand_id
                               from   th_buf_scm_prefer_demand_split -- ## SYNC Demand..!!
                               where  instance_id = @v_master_id
                               and    dpp_plan_id = @v_plan_id
                               group by fp_demand_id)
        
        END
      
      END

    -- ## Demand Attribute 설정..!!
    BEGIN
    
      SET @v_table_name = '@DEMAND_ATTRIBUTE_SET'
      SET @n_row_count = 0

      -- ## 미등록 데이터 삭제
      delete from a
      from   th_eng_demand_attribute a
      where  a.master_id = @v_master_id
      and    a.plan_id   = @v_plan_id
      and    not exists (
                          select 1
                          from   th_eng_net_demand x
                          where  x.master_id = a.master_id
                          and    x.plan_id = a.plan_id
                          and    x.demand_group_id = a.demand_group_id
                        )

      -- ## 해당 데이터 삭제
      delete from a
      from   th_eng_demand_attribute a
      where  a.master_id = @v_master_id
      and    a.plan_id   = @v_plan_id
      and    exists (
                      select 1
                      from   th_eng_net_demand x
                      where  x.master_id = a.master_id
                      and    x.plan_id = a.plan_id
                      and    x.demand_group_id = a.demand_group_id
                      and    x.is_consume = 'Y'
                    )
      

      insert into th_eng_demand_attribute
           ( master_id, plan_id, demand_group_id, preference_site_id, preference_route_id, preference_resource_id, preference_product_id, is_hard_preference )
      select distinct
             master_id, plan_id, demand_group_id, preference_site_id, preference_route_id, preference_resource_id, preference_product_id, is_hard_preference
      from   (select a.instance_id as master_id, a.dpp_plan_id as plan_id, a.fp_demand_id as demand_group_id,
                     b.site_id as preference_site_id, b.route_id as preference_route_id,
                     null as preference_resource_id, max(b.item_id) as preference_product_id, 'Y' as is_hard_preference
              from   TH_BUF_SCM_PREFER_DEMAND_SPLIT a,
                     (select route_id, item_id, site_id 
                      from   th_eng_item_route_site
                      where  master_id = @v_master_id
                      and    plan_id = @v_plan_id
                      group by route_id,item_id,site_id) b
              where  b.route_id = a.prefer_route_id
              and    b.item_id like a.item_id+'%'
              --and    b.site_id like a.site_id+'%'
              and    b.site_id like a.prefer_site_id+'%'
              --and    a.master_id = @v_master_id
              --and    a.plan_id = @v_plan_id
              and    a.instance_id = @v_master_id
              and    a.dpp_plan_id = @v_plan_id
              group  by a.instance_id, a.dpp_plan_id, a.fp_demand_id, b.site_id, b.route_id
              union all
              select distinct 
                     a.master_id, a.plan_id, a.net_demand_id as demand_group_id,
                     b.site_id as preference_site_id, a.route_id as preference_route_id,
                     min(resource_id) as preference_resource_id, max(b.item_id) as preference_product_id, 'Y' as is_hard_preference
              from   (select a.master_id, a.plan_id, a.net_demand_id, b.route_id, a.item_id, b.site_id, b.resource_id
                      from   th_dpp_net_demand a,
                             th_mst_fixed_plan b
                      where  a.master_id = b.master_id
                      and    a.plan_id = b.plan_id
                      and    a.net_demand_id = b.demand_id
                      and    a.production_order_id = b.work_order_id
                      and    a.master_id = @v_master_id
                      and    a.plan_id = @v_plan_id
                      and    a.po_type = 'FIX') a,
                     (select route_id, item_id, site_id 
                      from   th_eng_item_route_site
                      where  master_id = @v_master_id
                      and    plan_id = @v_plan_id
                      group by route_id,item_id,site_id) b
              where  b.route_id = a.route_id
              and    b.item_id like a.item_id+'%'
              and    b.site_id like a.site_id+'%'
              group  by a.master_id, a.plan_id, a.net_demand_id, b.site_id, a.route_id
              ) a
      where   not exists (
                          select 1
                          from   th_eng_demand_attribute x
                          where  x.master_id = a.master_id
                          and    x.plan_id = a.plan_id
                          and    x.demand_group_id = a.demand_group_id
                        )
      
      SET @n_row_count = @@ROWCOUNT
          
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
    END

    BEGIN
    
      delete from th_buf_scm_prefer_demand_assign_his   where master_id   = @v_master_id and plan_id      = @v_plan_id


      -- ## 해당 백업 데이터 추가
      insert into th_buf_scm_prefer_alloc_rate_his
      select * from th_buf_scm_prefer_alloc_rate    

      insert into th_buf_scm_prefer_demand_his
      select * from th_buf_scm_prefer_demand        

      insert into th_buf_scm_prefer_demand_result_his
      select * from th_buf_scm_prefer_demand_result 

      insert into th_buf_scm_prefer_resource_his
      select * from th_buf_scm_prefer_resource      
    
      insert into th_buf_scm_prefer_item_arrange_his
      select * from th_buf_scm_prefer_item_arrange
      
      insert into th_buf_scm_prefer_demand_split_his
      select * from th_buf_scm_prefer_demand_split
      
      insert into th_buf_scm_prefer_demand_assign_his
      select * from th_buf_scm_prefer_demand_assign

    END

  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    SET @n_log_count = @n_log_count + 1
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', @n_log_count, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
