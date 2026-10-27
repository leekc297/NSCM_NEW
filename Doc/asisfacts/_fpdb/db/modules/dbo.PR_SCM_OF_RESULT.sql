CREATE PROCEDURE [dbo].[PR_SCM_OF_RESULT]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_RESULT                                                          **/
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
/** 2016.01.01    COCHO          최초 작성                                                    **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_OF_RESULT
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id        nvarchar(30)
  DECLARE @v_plan_id          nvarchar(30)
  DECLARE @v_plan_type        nvarchar(30)
  DECLARE @v_plan_date        DATE

  -- LOG 용 변수 설정
  DECLARE @v_proc_name        nvarchar(100) = 'PR_SCM_OF_RESULT'
  DECLARE @v_table_name       nvarchar(100)
  DECLARE @v_message          nvarchar(250)
  DECLARE @v_descr            nvarchar(250)
  DECLARE @n_row_count        Integer  = 0
  DECLARE @n_log_count        Integer  = 0
  DECLARE @v_log_code          nvarchar(10)
  
  DECLARE @v_to_instance_id   nvarchar(30)
  DECLARE @v_to_instance_key  nvarchar(30)
  
  DECLARE @v_config_set_id  nvarchar(30)
  DECLARE @v_late_type      nvarchar(30)

  DECLARE @sysdate            DATETIME2 = GETDATE()

  DECLARE @v_temp1            nvarchar(1000)
  DECLARE @v_temp2            nvarchar(1000)

  DECLARE @v_chk_run_seq      nvarchar(20)
  DECLARE @v_chk_eng_flag     nvarchar(20)
  DECLARE @n_run_count        Integer  = 0
  DECLARE @n_loop_max_cnt     Integer  = 60
  
  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    -- 필수 DATA 쿼리.. 반듯이 있어야 함.
    BEGIN

      --LOG 생성
      SET @v_table_name = 'TH_MST_PLAN'
      SELECT  @v_plan_type = plan_type
            , @v_plan_date = CONVERT(DATE, PLAN_DATE)
            , @v_config_set_id = CONFIG_SET_ID
      FROM    TH_MST_PLAN
      WHERE   MASTER_ID = @v_master_id
      AND     PLAN_ID = @v_plan_id             
             
      --LOG 생성
      SET @v_message = 'PLAN_TYPE : ' + @v_plan_type
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

    END;

    -- PLAN DELAY 2 초 부과
    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
    BEGIN

        --LOG 생성
        SET @v_message = 'DELAY START'
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CHECK', @n_log_count, null, @v_message, null

      WAITFOR DELAY '00:00:05'    
    
        SET @v_message = 'DELAY END'
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CHECK', @n_log_count, null, @v_message, null

    END
    
    -- ## JIT Layered Planning 실행 여부 확인..!!
    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
    BEGIN
    
      SET @v_chk_run_seq = 'NULL'
    
      SELECT @v_chk_run_seq = isnull(descr,'NULL')
      FROM   TH_MST_ENG_PLAN_FLAG
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
      AND    OUT_VERSION_ID = @v_plan_id

      WAITFOR DELAY '00:00:02'

      EXECUTE PR_SCM_MF_ENG_COPY @v_master_id, @v_plan_id, @v_chk_run_seq

    END
          
    -- ## JIT Layered Planning 실행의 첫번째 Planning일 경우 처리..!!
    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
      IF @v_chk_run_seq = 'RUN-01'

        BEGIN
        
          -- ## 첫번째 결과를 기준으로 Demand 선행 조정..!!
          update th_eng_net_demand
          set    
                 --th_eng_net_demand.due_date = b.start_time,     -- fence 치고 나가는 경우 발생으로 아래쿼리로 수정
                 th_eng_net_demand.due_date = case when b.start_time <= a.due_fence_date
                                                        then b.start_time
                                                        else a.due_fence_date
                                              end , -- ## Start 기준 선행임..!!
                 th_eng_net_demand.priority = b.new_priority, -- ## Start 기준 우선순위 조정
                 --th_eng_net_demand.priority_group_code = b.new_priority, -- ## Start 기준 우선순위 조정
                 th_eng_net_demand.early_producing_term = 0,
                 th_eng_net_demand.descr = @v_chk_run_seq
          from   th_eng_net_demand a,
                 (
                  select a.demand_id, 
                         max(a.start_time) as start_time, max(a.end_time) as end_time,
                         convert(nvarchar, max(a.start_time), 112) 
                                           + convert(nvarchar, 100000  
                                                               + dense_rank() over (order by max(a.start_time)
                                                                                           , max(a.end_time)
                                                                                           , a.demand_id)) new_priority
                  from   th_out_order_tracking a,
                         th_dpp_net_demand b
                  where  a.master_id = b.master_id
                  and    a.plan_id = b.plan_id
                  and    a.demand_id = b.net_demand_id
                  and    a.out_item_id like b.item_id+'%'
                  and    a.master_id = @v_master_id
                  and    a.plan_id = @v_plan_id
                  and    a.out_version_id = @v_plan_id
                  and    a.end_time is not null
                  and    a.operation_id in ( 
                                              select 'E2000' as operation_id        -- E_PRE
                                              where  charindex('E_PRE', @v_master_id ) > 0
                                              union  all
                                              select 'A9000' as operation_id        -- CELL
                                              where  charindex('CELL', @v_master_id ) > 0
                                              union  all
                                              select 'A4000' as operation_id        -- CELL
                                              where  charindex('CELL', @v_master_id ) > 0
                                              union  all
                                              select 'P9500' as operation_id        -- PACK
                                              where  charindex('PACK', @v_master_id ) > 0
                                              union  all
                                              select 'P5500' as operation_id        -- PACK
                                              where  charindex('PACK', @v_master_id ) > 0
                                              union  all
                                              select 'S2000' as operation_id        -- SRS
                                              where  charindex('SRS', @v_master_id ) > 0
                                           )
                  group by a.demand_id
                 ) b
          where  a.demand_id = b.demand_id
          and    a.master_id = @v_master_id
          and    a.plan_id = @v_plan_id

          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'th_eng_net_demand', 'UPDATE', @n_log_count, null, @v_message, null
          

          -- batch 가 존재할 경우 batch size 만큼 선행함..
          update th_eng_net_demand
          set    th_eng_net_demand.early_producing_term     = b.batch_time
               , th_eng_net_demand.early_producing_term_uom = b.batch_time_uom
               , th_eng_net_demand.descr                    = 'BATCH'
          from   th_eng_net_demand a,
                 (
                  select a.demand_id, 
                         max(c.batch_time) as batch_time,
                         max(c.batch_time_uom) as batch_time_uom
                  from   th_out_order_tracking a,
                         th_dpp_net_demand b,
                         th_eng_batch_info c
                  where  a.master_id      = b.master_id
                  and    a.plan_id        = b.plan_id
                  and    a.demand_id      = b.net_demand_id
                  and    a.master_id      = c.master_id
                  and    a.plan_id        = c.plan_id
                  and    a.out_item_id    = c.item_id
                  and    a.resource_id    = c.batch_res_group_id
                  and    a.master_id      = @v_master_id
                  and    a.plan_id        = @v_plan_id
                  and    a.out_version_id = @v_plan_id
                  and    a.end_time is not null
                  group by a.demand_id
                 ) b
          where  a.demand_id = b.demand_id
          and    a.master_id = @v_master_id
          and    a.plan_id = @v_plan_id

          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'th_eng_net_demand', 'UPDATE', @n_log_count, null, @v_message, null


          -- 위에서 UPDATE 한 애들은 여기서 , BATCH 선행은 제외..
          UPDATE TH_ENG_NET_DEMAND
          SET    DUE_DATE                   = DATEADD(DAY, 0, DUE_DATE)
               , EARLY_PRODUCING_TERM       = 0
               , EARLY_PRODUCING_TERM_UOM   = 'DAY'
          WHERE  MASTER_ID = @V_MASTER_ID
          AND    PLAN_ID = @V_PLAN_ID
          AND    DESCR = @v_chk_run_seq

          -- 1차 실행 시 선행 공정 3일 선행 부분 원복 처리
          UPDATE TH_ENG_ITEM_ROUTE_SITE
          SET    TH_ENG_ITEM_ROUTE_SITE.EARLY_PRODUCING_TERM = CASE WHEN EARLY_PRODUCING_TERM_UOM = 'DAY' 
                                                            			  THEN A.EARLY_PRODUCING_TERM * 24 * 60
                                                            			  WHEN EARLY_PRODUCING_TERM_UOM = 'HOUR' 
                                                            			  THEN A.EARLY_PRODUCING_TERM * 60
                                                            			  WHEN EARLY_PRODUCING_TERM_UOM = 'MINUTE' 
                                                            			  THEN A.EARLY_PRODUCING_TERM
                                                            			  ELSE A.EARLY_PRODUCING_TERM END - 10080,
                 TH_ENG_ITEM_ROUTE_SITE.EARLY_PRODUCING_TERM_UOM = 'MINUTE'                                                                  
          FROM   TH_ENG_ITEM_ROUTE_SITE A,
              	(SELECT 	A.PLAN_ID
              	 FROM TH_MST_PLAN A,
              	      TH_MST_ENG_PLAN_FLAG B
              	 WHERE 1=1
              	 AND A.MASTER_ID = B.MASTER_ID
              	 AND A.PLAN_ID = B.PLAN_ID
              	 AND A.PLAN_ID = @v_plan_id
              	 AND A.PLAN_TYPE = 'PRE'
              	 AND B.DESCR = 'RUN-01') B
          --WHERE A.MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE IN ('A', 'P'))
          WHERE A.MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'A')
          AND A.PLAN_ID = @v_plan_id
          AND A.PLAN_ID = B.PLAN_ID
          AND A.OPERATION_ID NOT IN ('A5000', 'A9000','P5500' ,'P9500')

          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_ITEM_ROUTE_SITE', 'UPDATE', @n_log_count, null, @v_message, null
          
          -- OFFTIME 감안한 DEMAND 선행 처리 
          UPDATE TH_ENG_NET_DEMAND
          SET    TH_ENG_NET_DEMAND.EARLY_PRODUCING_TERM = A.EARLY_PRODUCING_TERM + B.OFFTIME_TERM/24/60                                                  
          FROM   TH_ENG_NET_DEMAND A,
                 (		
              		SELECT MASTER_ID, PLAN_ID, DEMAND_ID, DUE_DATE, EARLY_PRODUCING_TERM, SITE_ID, ROUTE_ID, SUM(OFFTIME_TERM) AS OFFTIME_TERM
                  FROM (
                    		SELECT DISTINCT MASTER_ID, PLAN_ID, DEMAND_ID, DUE_DATE, EARLY_PRODUCING_TERM, EARLY_PRODUCING_TERM_UOM,
                    				   SITE_ID, ROUTE_ID, START_DTTM, END_DTTM, OFFTIME_TERM, OFFTIME_TERM_UOM
                    		FROM (		
                      				SELECT 	A.MASTER_ID, A.PLAN_ID, A.DEMAND_GROUP_ID,
                      						D.DEMAND_ID, D.DUE_DATE, D.EARLY_PRODUCING_TERM, D.EARLY_PRODUCING_TERM_UOM,
                      						A.PREFERENCE_SITE_ID, A.PREFERENCE_ROUTE_ID,
                      						B.SITE_ID, B.ROUTE_ID, B.RESOURCE_ID, B.OFFTIME_SET_ID, 
                      						C.OFFTIME_SET_ID AS A, C.START_DTTM, C.END_DTTM, C.OFFTIME_TERM, C.OFFTIME_TERM_UOM
                      				FROM TH_ENG_DEMAND_ATTRIBUTE A,
                      					 TH_ENG_RESOURCE B,
                      					 TH_ENG_OFFTIME C,
                      					 TH_ENG_NET_DEMAND D
                      				WHERE 1=1
                              AND A.MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE != 'P')
                      				AND A.PLAN_ID = @v_plan_id
                      				AND A.PLAN_ID = B.PLAN_ID
                      				AND A.PLAN_ID = C.PLAN_ID
                      				AND A.PLAN_ID = D.PLAN_ID
                      				AND A.PREFERENCE_SITE_ID = B.SITE_ID
                      				AND A.PREFERENCE_ROUTE_ID = B.ROUTE_ID
                      				AND B.OFFTIME_SET_ID = C.OFFTIME_SET_ID
                      				AND A.DEMAND_GROUP_ID = D.DEMAND_ID
                      				AND D.DUE_DATE >= C.END_DTTM
                      				AND D.DUE_DATE < C.END_DTTM + 2
                      				AND D.EARLY_PRODUCING_TERM = 0) A 
                  				) A
                  GROUP BY MASTER_ID, PLAN_ID, DEMAND_ID, DUE_DATE, EARLY_PRODUCING_TERM, SITE_ID, ROUTE_ID) B
          WHERE   1=1
          AND     A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID = @v_plan_id
          AND     A.PLAN_ID = B.PLAN_ID
          AND     A.DEMAND_ID = B.DEMAND_ID

          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_NET_DEMAND - OFFTIME', 'UPDATE', @n_log_count, null, @v_message, null
          
          
          /*
          -- PET 벗어날 경우 보정처리
          UPDATE TH_ENG_NET_DEMAND
          SET    TH_ENG_NET_DEMAND.DUE_DATE = DATEADD(DAY, PLAN_HORIZON, PLAN_START_DTTM)
               , TH_ENG_NET_DEMAND.EARLY_PRODUCING_TERM = DATEDIFF(DAY, DATEADD(DAY, A.EARLY_PRODUCING_TERM * -1, A.DUE_DATE), DATEADD(DAY, B.PLAN_HORIZON, B.PLAN_START_DTTM))
          FROM   TH_ENG_NET_DEMAND A,
                 TH_ENG_PLAN_INFO B
          WHERE  A.MASTER_ID = @V_MASTER_ID
          AND    A.PLAN_ID = @V_PLAN_ID
          AND    A.MASTER_ID = B.MASTER_ID
          AND    A.PLAN_ID = B.PLAN_ID
          AND    A.DUE_DATE > DATEADD(DAY, PLAN_HORIZON, PLAN_START_DTTM)
          */
          

          /*
          -- lot size 만큼 due 선행 추가 -- lot tact 이 맞지 않아서리..
          update th_eng_net_demand
          set    th_eng_net_demand.due_date = b.adj_due_date
          from   th_eng_net_demand a,
                 (
                  select a.*,
                         case when lot_add_due < plan_start_dttm then plan_start_dttm
                              else lot_add_due
                         end  adj_due_date
                  from   (
                          select a.*, b.tact_time * b.lot_size as lot_run_second,
                                 dateadd(minute, -1 * b.batch_time_minute, a.due_date)  as lot_add_due,
                                 /*
                                 -- batch 시간이 존재하면 그 시간만큼 선행
                                 -- 아닐 경우 lot size 만큼 선행
                                 case when b.batch_time_minute > 0 
                                            then dateadd(minute, -1 * b.batch_time_minute, a.due_date) 
                                            else dateadd(second, -1 * b.tact_time * b.lot_size, a.due_date)
                                 end  as lot_add_due,
                                 */
                                 c.plan_start_dttm
                          from   (
                                  select a.master_id, a.plan_id, a.item_id, a.qty, b.demand_id, b.due_date, c.preference_site_id
                                  from   th_dpp_net_demand a,
                                         th_eng_net_demand b,
                                         th_eng_demand_attribute c
                                  where  a.master_id = @v_master_id
                                  and    a.plan_id = @v_plan_id
                                  and    a.master_id = b.master_id
                                  and    a.plan_id = b.plan_id
                                  and    a.master_id = c.master_id
                                  and    a.plan_id = c.plan_id
                                  and    a.net_demand_id = b.demand_id
                                  and    b.demand_group_id = c.demand_group_id
                                  and    exists (
                                                  select 1
                                                  from   ( -- resource 의 첫 투입 demand 만 추가 선행반영
                                                          select a.demand_id
                                                          from   (
                                                                  select a.demand_id, a.resource_id, operation_id, 
                                                                         max(a.start_time) as max_start_time,
                                                                         dense_rank() over (partition by a.demand_id order by a.operation_id desc) op_seq,
                                                                         dense_rank() over (partition by a.resource_id order by max(a.start_time)) as res_seq
                                                                  from   th_out_order_tracking a,
                                                                         th_dpp_net_demand b
                                                                  where  a.master_id = b.master_id
                                                                  and    a.plan_id = b.plan_id
                                                                  and    a.demand_id = b.net_demand_id
                                                                  and    a.out_item_id like b.item_id+'%'
                                                                  and    a.master_id = @v_master_id
                                                                  and    a.plan_id = @v_plan_id
                                                                  and    a.out_version_id = @v_plan_id
                                                                  and    a.end_time is not null
                                                                  and    a.order_id_type = 'W'
                                                                  group by a.demand_id, a.resource_id, operation_id
                                                                 ) a
                                                          where  a.op_seq = 1   -- demand_id 의 최종 공정
                                                          and    a.res_seq = 1  -- resource_id 의 첫 투입 demand
                                                         ) x
                                                  where  x.demand_id = a.net_demand_id
                                                )
                                 ) a,
                                 th_buf_scm_prefer_item_arrange b,
                                 th_eng_plan_info c
                          where  a.master_id = b.master_id
                          and    a.plan_id = b.plan_id
                          and    a.item_id = b.item_id
                          and    a.preference_site_id = b.site_id +'^' + b.route_id
                          and    a.master_id = c.master_id
                          and    a.plan_id = c.plan_id
                          and    b.batch_time_minute > 0
                          --and    b.batch_time_minute > ( b.tact_time * b.lot_size / 60 )
                          and    b.batch_time_minute > ( b.tact_time * a.qty / 60 )
                         ) a
                 ) b
          where  a.master_id = @v_master_id
          and    a.plan_id = @v_plan_id
          and    a.master_id = b.master_id
          and    a.plan_id = b.plan_id
          and    a.demand_id = b.demand_id

          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'th_eng_net_demand', 'UPDATE', @n_log_count, null, @v_message, null
          */

          -- batch 설비가 off 에 포함될 경우 off 만큼 선행해야한다.
          
          -- WORK ORDER SPL 기준으로 DEMAND 를 구성하고, DEMAND 를 SPLIT 한다.
          IF @v_master_id = 'KR_PACK' 
              --OR @v_master_id = 'KR_CELL'
            EXEC PR_SCM_MF_DAY_WORK_SPLIT @v_master_id, @v_plan_id
          
          
          -- ## 첫번째 결과 백업 - Order Tracking..!!
          delete from th_out_order_tracking
          where  master_id = @v_master_id
          and    plan_id = @v_plan_id
          and    out_version_id = @v_plan_id+'BACK'
          
          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'th_out_order_tracking', 'DELETE', @n_log_count, null, @v_message, null

          update th_out_order_tracking
          set    out_version_id = out_version_id+'BACK'
          where  master_id = @v_master_id
          and    plan_id = @v_plan_id
          and    out_version_id = @v_plan_id

          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'th_out_order_tracking', 'UPDATE', @n_log_count, null, @v_message, null

          -- PREFER 에서 BATCH 시간 변동한 부분에 대해 다시 원복 처리함.
          UPDATE TH_ENG_BATCH_INFO
          SET    TH_ENG_BATCH_INFO.BATCH_TIME = B.BATCH_TIME
          FROM   TH_ENG_BATCH_INFO A,
                 TH_ENG_BATCH_INFO_CAL B
          WHERE  A.MASTER_ID = B.MASTER_ID
          AND    A.PLAN_ID = B.PLAN_ID
          AND    A.BATCH_RES_GROUP_ID = B.BATCH_RES_GROUP_ID
          AND    A.BATCH_GROUP_ID = B.BATCH_GROUP_ID
          AND    A.ITEM_ID = B.ITEM_ID
          AND    B.DESCR = 'PREFER'
          AND    A.BATCH_TIME <> B.BATCH_TIME
          AND    A.MASTER_ID = @v_master_id 
          AND    A.PLAN_ID = @v_plan_id 

          ----------------------------------------------------------------------------
          -- out 결과 삭제
          EXECUTE dbo.PR_SCM_MF_OUT_DELETE  @v_master_id, @v_plan_id
          ----------------------------------------------------------------------------


          -- ## 두번째 실행 조건으로 변경..!!
          UPDATE dbo.TH_MST_ENG_PLAN_FLAG
          SET    DESCR = 'RUN-02',
                 ENGINE_FLAG = 'R',
                 OUTBOUND_FLAG = 'R',
                 DB_TRANS_FLAG = 'R'
          WHERE  MASTER_ID = @v_master_id 
          AND    PLAN_ID = @v_plan_id 
          AND    OUT_VERSION_ID = @v_plan_id
          
          WAITFOR DELAY '00:00:02'
          
          EXECUTE PR_SCM_MF_ENG_COPY @v_master_id, @v_plan_id, 'RUN-02'
          
          -- ## 두번째 실행 완료 여부 확인..!!
          SET @n_run_count = 0
          SET @v_chk_eng_flag = 'R'
          
          WHILE 1=1
          BEGIN
          
            WAITFOR DELAY '00:00:05'
            
            SET @n_run_count = @n_run_count + 1

            SELECT @v_chk_eng_flag = ISNULL(MAX(PLAN_STATUS),'CHECKING') 
            FROM   TH_ENG_PLAN_STATUS 
            WHERE  MASTER_ID = @v_master_id 
            AND    PLAN_ID = @v_plan_id 
            AND    OUT_VERSION_ID = @v_plan_id
            AND    PLAN_STATUS = 'DONE'          
            
            -- 5초, 120번 = 10분 동안 대기 하도록 셋팅함.
            IF @v_chk_eng_flag = 'DONE' OR @n_run_count >= 120
              BREAK
            /*

            SELECT @v_chk_eng_flag = engine_flag
            FROM   TH_MST_ENG_PLAN_FLAG
            WHERE  MASTER_ID = @v_master_id 
            AND    PLAN_ID = @v_plan_id 
            AND    OUT_VERSION_ID = @v_plan_id
            
            IF @v_chk_eng_flag = 'C' OR @n_run_count >= 100
              BREAK
            */
          
          END

          --LOG 생성
          SET @v_message = 'CHK_RUN_CNT : ' + convert(nvarchar, @n_run_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CHECK', @n_log_count, null, @v_message, null
        
        
          -- ## Loop Count가 제한치 이상일 경우는 실행 취소..!!
          IF @n_run_count < @n_loop_max_cnt
          
            BEGIN
              
              ----------------------------------------------------------------------------
              -- Export 실행..!!
              EXECUTE dbo.PR_SCM_OF_RESULT_RUN  @v_master_id, @v_plan_id
              ----------------------------------------------------------------------------
            
            END

        END
      
      ELSE
      
        BEGIN
    
          ----------------------------------------------------------------------------
          -- Export 실행..!!
          EXECUTE dbo.PR_SCM_OF_RESULT_RUN  @v_master_id, @v_plan_id
          ----------------------------------------------------------------------------

        END

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, '#######   END   #######', 'END', 999999, null, '############### End of procedure ###############', null
            
  END TRY

  BEGIN CATCH
    --ROLLBACK
    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr

    IF @@TRANCOUNT > 0
      COMMIT WORK 

  END CATCH

END
