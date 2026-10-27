CREATE PROCEDURE [dbo].[PR_SCM_OF_RESULT_RUN]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_RESULT_RUN                                                      **/
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
  EXEC PR_SCM_OF_RESULT_RUN
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
  DECLARE @v_proc_name        nvarchar(100) = 'PR_SCM_OF_RESULT_RUN'
  DECLARE @v_table_name       nvarchar(100)
  DECLARE @v_message          nvarchar(250)
  DECLARE @v_descr            nvarchar(250)
  DECLARE @n_row_count        Integer  = 0
  DECLARE @n_log_count        Integer  = 0
  DECLARE @v_log_code          nvarchar(10)
  
  DECLARE @v_to_instance_id   nvarchar(30)
  DECLARE @v_to_instance_key  nvarchar(30)
  DECLARE @v_transfer_instance_id   nvarchar(30)
  
  DECLARE @sysdate            DATETIME2 = GETDATE()

  DECLARE @v_temp1            nvarchar(1000)
  DECLARE @v_temp2            nvarchar(1000)

  DECLARE @v_chk_run_seq      nvarchar(20)
  
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
      FROM    TH_MST_PLAN
      WHERE   MASTER_ID = @v_master_id
      AND     PLAN_ID = @v_plan_id             
             
      --LOG 생성
      SET @v_message = 'PLAN_TYPE : ' + @v_plan_type
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
    END;

    
    BEGIN
    
      BEGIN
      
        UPDATE TH_MST_ENG_PLAN_FLAG
        SET    TH_MST_ENG_PLAN_FLAG.OUTBOUND_END = B.EVENT_TIME
              ,TH_MST_ENG_PLAN_FLAG.OUTBOUND_FLAG = 'C'
        FROM   TH_MST_ENG_PLAN_FLAG A,
               TH_ENG_PLAN_STATUS B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.OUT_VERSION_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.OUT_VERSION_ID = B.OUT_VERSION_ID
        AND    B.PLAN_STATUS = 'DONE'
      
      END
  
      BEGIN
      
       UPDATE SY_FP_PLAN_STATUS_H
          SET 
             OUTBOUND_START = B.EVENT_TIME, 
             UPDATE_ID = @v_proc_name, 
             UPDATE_TIME = sysdatetime()
       FROM SY_FP_PLAN_STATUS_H  A,
               TH_ENG_PLAN_STATUS B
       WHERE A.INSTANCE_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PLAN_ID = B.OUT_VERSION_ID
        AND    B.PLAN_STATUS = 'SAVING'
        AND    a.INSTANCE_ID = @v_master_id  
        AND    a.PLAN_ID = @v_plan_id
        
       UPDATE SY_FP_PLAN_STATUS_H
          SET 
             OUTBOUND_FLAG = 'C',
             OUTBOUND_STEP = '4',
             OUTBOUND_END = B.EVENT_TIME, 
             UPDATE_ID = @v_proc_name, 
             UPDATE_TIME = sysdatetime()
       FROM SY_FP_PLAN_STATUS_H  A,
               TH_ENG_PLAN_STATUS B
       WHERE A.INSTANCE_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PLAN_ID = B.OUT_VERSION_ID
        AND    B.PLAN_STATUS = 'DONE'
        AND    a.INSTANCE_ID = @v_master_id  
        AND    a.PLAN_ID = @v_plan_id
          
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_MST_ENG_PLAN_FLAG', 'UPDATE', @@ROWCOUNT, null, 'OUTBOUND_FLAG = C', null

        UPDATE dbo.TH_MST_ENG_PLAN_FLAG
        SET    DB_TRANS_FLAG = 'P'
             , DB_TRANS_START = sysdatetime()
             , UPDATE_ID = @v_proc_name
             , UPDATE_DATE = sysdatetime()
        WHERE  MASTER_ID = @v_master_id 
        AND    PLAN_ID = @v_plan_id 
        AND    OUT_VERSION_ID = @v_plan_id
        
       UPDATE SY_FP_PLAN_STATUS_H
          SET 
             DB_TRANS_FLAG = 'P',
             DB_TRANS_STEP = '1',
             DB_TRANS_START = sysdatetime(), 
             UPDATE_ID = @v_proc_name, 
             UPDATE_TIME = sysdatetime()
       FROM SY_FP_PLAN_STATUS_H  AS a
       WHERE 
          a.INSTANCE_ID = @v_master_id AND 
          a.PLAN_ID = @v_plan_id

        --LOG 생성
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_MST_ENG_PLAN_FLAG', 'UPDATE', @@ROWCOUNT, null, 'DB_TRANS_FLAG = P', null
      
      END


    
    -- ## JIT Layered Planning 실행 여부 확인..!!
    BEGIN
    
      SET @v_chk_run_seq = 'NULL'
    
      SELECT @v_chk_run_seq = isnull(descr,'NULL')
      FROM   TH_MST_ENG_PLAN_FLAG
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
      AND    OUT_VERSION_ID = @v_plan_id
    
    END

    
    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
      IF @v_chk_run_seq = 'RUN-02'

        BEGIN

          update th_eng_net_demand
          set    due_date = shipping_date,
                 descr = replace(replace(replace(convert(nvarchar, due_date, 120), ' ',''), '-', ''), ':', '')
          where  master_id = @v_master_id
          and    plan_id = @v_plan_id

          
          delete from th_out_problem_report
          where  master_id = @v_master_id
          and    plan_id = @v_plan_id
          and    out_version_id = @v_plan_id
          and    demand_id in (select a.demand_id
                               from   (select demand_id, response_time
                                       from   th_out_problem_report 
                                       where  master_id = @v_master_id
                                       and    plan_id = @v_plan_id
                                       and    out_version_id = @v_plan_id
                                       and    problem_type = 'LATE') a,
                                      (select demand_id, due_date
                                       from   th_eng_net_demand
                                       where  master_id = @v_master_id
                                       and    plan_id = @v_plan_id) b
                               where  a.demand_id = b.demand_id
                               and    a.response_time <= b.due_date)


          -- ## 백업된 Order Tracking의 EPST,LPST 값 기준으로 변환 처리..!!
          BEGIN

            SET @v_table_name = '@OT_EPST_LPST'

            /*
            DECLARE @V_PF_DEMAND_ID       nvarchar(100),
                    @V_PF_SITE_ID         nvarchar(100),
                    @V_PF_ROUTE_ID        nvarchar(100),
                    @V_PF_OPERATION_ID    nvarchar(100),
                    @V_PF_OUT_ITEM_ID     nvarchar(100),
                    @D_PF_EPST            datetime,
                    @D_PF_LPST            datetime

            
            DECLARE OT_EPST_LPST CURSOR FOR 
            
            select demand_id, site_id, route_id, operation_id, out_item_id, epst, lpst
            from   th_out_order_tracking
            where  master_id = @v_master_id
            and    plan_id = @v_plan_id
            and    out_version_id = @v_plan_id+'BACK' -- ## 백업 기준..!!
            and    epst is not null
            group by demand_id,site_id,route_id,operation_id,out_item_id,epst,lpst


            SET @V_PF_DEMAND_ID    = NULL
            SET @V_PF_SITE_ID      = NULL
            SET @V_PF_ROUTE_ID     = NULL
            SET @V_PF_OPERATION_ID = NULL
            SET @V_PF_OUT_ITEM_ID  = NULL
            SET @D_PF_EPST         = NULL
            SET @D_PF_LPST         = NULL


            OPEN OT_EPST_LPST
            
            WHILE 1 = 1
            
            BEGIN

              FETCH OT_EPST_LPST
               INTO @V_PF_DEMAND_ID, @V_PF_SITE_ID, @V_PF_ROUTE_ID, @V_PF_OPERATION_ID, @V_PF_OUT_ITEM_ID, @D_PF_EPST, @D_PF_LPST
                
                IF @@FETCH_STATUS <> 0
                  BREAK

                BEGIN

                  update th_out_order_tracking
                  set    epst = @D_PF_EPST,
                         lpst = @D_PF_LPST
                  where  master_id = @v_master_id
                  and    plan_id = @v_plan_id
                  and    out_version_id = @v_plan_id
                  and    demand_id = @v_pf_demand_id
                  and    site_id = @v_pf_site_id
                  and    route_id = @v_pf_route_id
                  and    operation_id = @v_pf_operation_id
                  and    out_item_id = @v_pf_out_item_id

                END
                  
            END

            CLOSE OT_EPST_LPST

            DEALLOCATE OT_EPST_LPST
            */
            /* -- PR_SCM_MF_PREPROCESS_OUT 으로 이관
            UPDATE TH_OUT_ORDER_TRACKING
            SET    TH_OUT_ORDER_TRACKING.EPST = B.EPST
                 , TH_OUT_ORDER_TRACKING.LPST = B.LPST
            FROM   TH_OUT_ORDER_TRACKING A,
                   (
                      SELECT DEMAND_ID, SITE_ID, ROUTE_ID, OPERATION_ID, OUT_ITEM_ID, EPST, LPST
                      FROM   TH_OUT_ORDER_TRACKING
                      WHERE  MASTER_ID      = @v_master_id
                      AND    PLAN_ID        = @v_plan_id
                      AND    OUT_VERSION_ID = @v_plan_id+'BACK' -- ## 백업 기준..!!
                      AND    EPST           IS NOT NULL
                      GROUP BY DEMAND_ID,SITE_ID,ROUTE_ID,OPERATION_ID,OUT_ITEM_ID,EPST,LPST        
                   ) B
            WHERE  A.MASTER_ID      = @v_master_id
            AND    A.PLAN_ID        = @v_plan_id
            AND    A.OUT_VERSION_ID = @v_plan_id
            AND    A.DEMAND_ID      = B.DEMAND_ID
            AND    A.SITE_ID        = B.SITE_ID
            AND    A.ROUTE_ID       = B.ROUTE_ID
            AND    A.OPERATION_ID   = B.OPERATION_ID
            AND    A.OUT_ITEM_ID    = B.OUT_ITEM_ID          
            
            delete from th_out_order_tracking_back
            where  master_id = @v_master_id
            and    plan_id = @v_plan_id

            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'th_out_order_tracking_back', 'DELETE', @n_log_count, null, @v_message, null

            insert into th_out_order_tracking_back
            select *
            from   th_out_order_tracking
            where  master_id = @v_master_id
            and    plan_id = @v_plan_id
            and    out_version_id = @v_plan_id+'BACK'   
            
            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'th_out_order_tracking_back', 'INSERT', @n_log_count, null, @v_message, null

            -- ## 첫번째 결과 백업 삭제 - Order Tracking..!!
            delete from th_out_order_tracking
            where  master_id = @v_master_id
            and    plan_id = @v_plan_id
            and    out_version_id = @v_plan_id+'BACK'   
            
            */
          END
        
        END      

    IF @v_plan_type = 'SYNC'
      BEGIN

          -- SYNC PLAN 시 LATE 는 TARGET DEMAND 의 DUE_DATE 를 보고 선택함
          delete from th_out_problem_report
          where  master_id = @v_master_id
          and    plan_id = @v_plan_id
          and    out_version_id = @v_plan_id
          and    demand_id in (select a.demand_id
                               from   (select demand_id, response_time
                                       from   th_out_problem_report 
                                       where  master_id = @v_master_id
                                       and    plan_id = @v_plan_id
                                       and    out_version_id = @v_plan_id
                                       and    problem_type = 'LATE') a,
                                      (select fp_demand_id, due_date
                                       from   sy_fp_daily_net_demand_h
                                       where  instance_id = @v_master_id
                                       and    dpp_plan_id = @v_plan_id) b
                               where  a.demand_id = b.fp_demand_id
                               and    a.response_time <= b.due_date)
      
      END
      
    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
      BEGIN

        IF @v_master_id <> '-'
          BEGIN
          
            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
              EXECUTE PR_SCM_MF_PREPROCESS_OUT      @v_master_id,@v_plan_id,@v_plan_id ;
          
            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
              EXECUTE dbo.PR_SCM_MF_SITE_ROUTE_OUT  @v_master_id,@v_plan_id,@v_plan_id ;

            -- 실행순서 바꾸지 말것....
            ------------------------------------------------------------------------------------
            -- 1. 특화 기능 처리
            IF CHARINDEX('E_POST', @v_master_id) > 0
              BEGIN

                IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
                  EXECUTE dbo.PR_SCM_MF_EPOST_BOM_OUT       @v_master_id,@v_plan_id,@v_plan_id ;

              END
            ELSE
              BEGIN
                IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
                  EXECUTE dbo.PR_SCM_MF_MULTI_OPERATION_OUT @v_master_id,@v_plan_id,@v_plan_id ;

                IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
                  EXECUTE dbo.PR_SCM_MF_MULTI_ROUTE_OUT @v_master_id,@v_plan_id,@v_plan_id ;
              END
              
            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
              EXECUTE dbo.PR_SCM_MF_BATCH_ROUTE_OUT @v_master_id,@v_plan_id,@v_plan_id ;
            
            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
              EXECUTE dbo.PR_SCM_MF_LANE_ROUTE_OUT  @v_master_id,@v_plan_id,@v_plan_id ;

            ------------------------------------------------------------------------------------
            -- 2.특화 기능 반영전 엔진 데이터로 복구              

            -- 3. 엔진 데이터 복구한 정보를 기준으로 AMEMD 1차 데이터 생성 - 2016.10.31
            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
              EXECUTE dbo.PR_SCM_OF_AMEND           @v_master_id,@v_plan_id,@v_plan_id ;

            
            -- HALF SLITING 계획 삽입하기 위한 처리 작업 진행
            -- 주의 : 미세조정 후, PR_SCM_OF_PREPROCESS 실행 전, 사이에 진행해야 한다.
            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
              EXECUTE dbo.PR_SCM_MF_LANE_ROUTE_OUT_ADJUST  @v_master_id,@v_plan_id,@v_plan_id ;
            

          UPDATE  SY_FP_PLAN_STATUS_H
          SET     DB_TRANS_STEP = '2',
                  UPDATE_ID = @v_proc_name, 
                  UPDATE_TIME = sysdatetime()
          WHERE   INSTANCE_ID = @v_master_id 
          AND     PLAN_ID = @v_plan_id;

            -- 실행순서 바꾸지 말것....
            ------------------------------------------------------------------------------------
            -- 3.결과 SDB 로 전송
            
            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
              EXECUTE dbo.PR_SCM_OF_PREPROCESS      @v_master_id,@v_plan_id,@v_plan_id ;

            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
              EXECUTE dbo.PR_SCM_OF_PRODUCTION      @v_master_id,@v_plan_id,@v_plan_id ;

            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
              EXECUTE dbo.PR_SCM_OF_ORDERTRACKING   @v_master_id,@v_plan_id,@v_plan_id ;
            
            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
              EXECUTE dbo.PR_SCM_OF_MOVE            @v_master_id,@v_plan_id,@v_plan_id ;

            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
              EXECUTE dbo.PR_SCM_OF_RESOURCE        @v_master_id,@v_plan_id,@v_plan_id ;
            
          UPDATE  SY_FP_PLAN_STATUS_H
          SET     DB_TRANS_STEP = '3',
                  UPDATE_ID = @v_proc_name, 
                  UPDATE_TIME = sysdatetime()
          WHERE   INSTANCE_ID = @v_master_id 
          AND     PLAN_ID = @v_plan_id;

            
            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
              EXECUTE dbo.PR_SCM_OF_ORDERPEGGING    @v_master_id,@v_plan_id,@v_plan_id ;

            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
              EXECUTE dbo.PR_SCM_OF_PROBLEMREPORT   @v_master_id,@v_plan_id,@v_plan_id ;

            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
              EXECUTE dbo.PR_SCM_OF_FULFILLMENT     @v_master_id,@v_plan_id,@v_plan_id ;

            -- 엔진 WORK_ORDER_ID 를 FP WORK_ORDER_ID 로 UPDATE 처리  
            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
              EXECUTE dbo.PR_SCM_OF_AMEND_ADJUST     @v_master_id,@v_plan_id,@v_plan_id ;

            /*** FP_AMEND_LOB_PLAN_R 생성 ***/
            EXECUTE PR_SCM_OF_LOB_PROCESS @v_master_id, @v_plan_id, 'PSI'
                      
            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            BEGIN

              SET @v_table_name = 'SCM_FP_PLAN_H'
              SET @n_row_count = 0
              
              SELECT @n_row_count = COUNT(1)
              FROM   SY_SCM_FP_PLAN_H
              WHERE  INSTANCE_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id

              IF @n_row_count = 0
              BEGIN
                INSERT  INTO SY_SCM_FP_PLAN_H
                      (
                        INSTANCE_ID
                      , PLAN_ID
                      , PLAN_TYPE
                      , SITE_ID
                      , PLAN_START_TIME
                      , PLAN_HORIZON
                      , PLAN_HORIZON_UOM
                      , DEMAND_HORIZON
                      , DEMAND_HORIZON_UOM
                      , CONFIG_SET_ID
                      , BASIS_PLAN_ID
                      , DEMAND_PLAN_ID
                      , SCP_PLAN_ID
                      , PLAN_WEEK
                      , CONFIRM_FLAG
                      , DESCRIPTION
                      , INSERT_ID
                      , INSERT_TIME
                      , UPDATE_ID
                      , UPDATE_TIME
                      )
                SELECT  A.MASTER_ID AS INSTANCE_ID
                      , A.PLAN_ID AS PLAN_ID
                      , A.PLAN_TYPE
                      , B.SITE_ID
                      , A.PLAN_START_DTTM AS PLAN_START_TIME
                      , A.PLAN_HORIZON
                      , A.PLAN_HORIZON_UOM
                      , A.DEMAND_HORIZON
                      , A.DEMAND_HORIZON_UOM
                      , A.CONFIG_SET_ID
                      , A.BASIS_PLAN_ID
                      , A.SCP_PRODUCT_PLAN_ID AS DEMAND_PLAN_ID
                      , A.SCP_PRODUCT_PLAN_ID AS SCP_PLAN_ID
                      , A.WEEK AS PLAN_WEEK
                      , A.IS_CONFIRMED AS CONFIRM_FLAG
                      , A.DESCR AS DESCRIPTION
                      , @v_proc_name AS INSERT_ID
                      , GETDATE()    AS INSERT_DTTM
                      , @v_proc_name AS UPDATE_ID
                      , GETDATE()    AS UPDATE_DTTM
                FROM    TH_MST_PLAN A,
                        (
                          SELECT MAX(SITE_ID) AS SITE_ID
                          FROM   SY_FP_INSTANCE_FACTORY_M A,
                                 SY_SCM_FACTORY_M B
                          WHERE  A.FACTORY_ID = B.FACTORY_ID
                          AND    A.INSTANCE_ID = @v_master_id                   
                        ) B
                WHERE   MASTER_ID = @v_master_id
                AND     PLAN_ID = @v_plan_id
              
              END
              
            END

            
            ---------------------------------------------------------------------
            -- PRE, POST - INSTANCE DEMAND 생성
            --      POST - PRE 완성 투입 STOCK 생성
            ---------------------------------------------------------------------
            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            BEGIN
            
              SET @v_to_instance_id = NULL
              SET @v_to_instance_key = NULL
                  
              SELECT @v_to_instance_key = KEY_ID, 
                     @v_to_instance_id = KEY_VALUE
              FROM   SY_FP_INSTANCE_CONFIG_M
              WHERE  1=1
              AND    INSTANCE_ID = @v_master_id
              AND    CATEGORY_ID = 'RESULT_TRANSFER' 
              AND    KEY_PRIORITY = 1
              
              --LOG 생성
              IF @v_to_instance_key IS NOT NULL
                EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_INSTANCE_CONFIG_M', 'SELECT', @@ROWCOUNT, null, 'RESULT_TRANSFER', null

              IF @v_to_instance_key = 'CONSUME_DEMAND' 
                BEGIN
                
                  -----------------------------------------------------------------
                  -- 전극 후공정
                  -----------------------------------------------------------------
                  DELETE FROM SY_FP_DAILY_INSTANCE_DEMAND_H
                  WHERE  INSTANCE_ID = @v_to_instance_id
                  AND    INSTANCE_DATE = @v_plan_date
                  AND    SCP_PLAN_ID = @v_plan_id

                  INSERT INTO SY_FP_DAILY_INSTANCE_DEMAND_H
                      (
                        INSTANCE_ID
                      , INSTANCE_DATE
                      , COMPANY_ID
                      , DIVISION_ID
                      , SITE_ID
                      , PLANT_ID
                      , SHOP_GROUP_ID
                      , SCP_PLAN_ID
                      , SCP_TARGET_ID
                      , FP_TARGET_ID
                      , ITEM_ID
                      , TO_SITE_ID
                      , TO_PLANT_ID
                      , CUSTOMER_ID
                      , MARKET
                      , DUE_DATE
                      , DUE_FENCE_DATE
                      , DEMAND_QTY
                      , ROLL_QTY
                      , JR_QTY
                      , CELL_QTY
                      , PRODUCTION_TYPE
                      , INSERT_ID
                      , INSERT_TIME
                      , UPDATE_ID
                      , UPDATE_TIME
                      )
                  SELECT
                        @v_to_instance_id AS INSTANCE_ID
                      , @v_plan_date AS INSTANCE_DATE
                      , A.COMPANY_ID
                      --, DIVISION_ID
                      , CASE WHEN A.DIVISION_ID = '82' THEN '81' ELSE A.DIVISION_ID END AS DIVISION_ID  -- ESS는 전극에 구분이 없음. 자동차로 진행함
                      , A.SITE_ID
                      , A.PLANT_ID
                      , ISNULL(B.SHOP_GROUP_ID, 'E') AS SHOP_GROUP_ID
                      , A.SCP_PLAN_ID
                      , A.SCP_TARGET_ID
                      , A.FP_TARGET_ID
                      , MIN(ITEM_ID) AS ITEM_ID
                      , MIN(TO_SITE_ID) AS TO_SITE_ID
                      , MIN(TO_PLANT_ID) AS TO_PLANT_ID
                      , MIN(CUSTOMER_ID) AS CUSTOMER_ID
                      , MIN(MARKET)      AS MARKET
                      --, MIN(DUE_DATE)    AS DUE_DATE
                      , CASE WHEN @v_to_instance_id = 'US_E_POST' THEN  -- 미국은 2일 더 선행한다.
                                                                        CASE WHEN DATEADD(DAY, -2, MIN(DUE_FENCE_DATE)) < @v_plan_date THEN @v_plan_date
                                                                             ELSE DATEADD(DAY, -2, MIN(DUE_FENCE_DATE))
                                                                        END
                             ELSE MIN(DUE_FENCE_DATE)
                        END  AS DUE_DATE
                      , CASE WHEN @v_to_instance_id = 'US_E_POST' THEN  -- 미국은 2일 더 선행한다.
                                                                        CASE WHEN DATEADD(DAY, -2, MIN(DUE_FENCE_DATE)) < @v_plan_date THEN @v_plan_date
                                                                             ELSE DATEADD(DAY, -2, MIN(DUE_FENCE_DATE))
                                                                        END
                             ELSE MIN(DUE_FENCE_DATE)
                        END  AS DUE_FENCE_DATE
                      , SUM(DEMAND_QTY) AS DEMAND_QTY
                      , NULL AS ROLL_QTY
                      , NULL AS JR_QTY
                      , NULL AS CELL_QTY
                      , MIN(PRODUCTION_TYPE) AS PRODUCTION_TYPE
                      , @v_proc_name AS INSERT_ID
                      , GETDATE()    AS INSERT_DTTM
                      , @v_proc_name AS UPDATE_ID
                      , GETDATE()    AS UPDATE_DTTM
                  FROM (SELECT DISTINCT
                              C.COMPANY_ID
                            , C.DIVISION_ID
                            , C.SITE_ID
                            , MAX(ISNULL(D.PLANT_ID,C.PLANT_ID)) OVER (PARTITION BY B.PLAN_ORDER_ID) AS PLANT_ID -- ## NULL 임시 예외 처리..!! - 2016.12.15
                            , A.PLAN_ID AS SCP_PLAN_ID
                            , B.PLAN_ORDER_ID AS SCP_TARGET_ID
                            , B.PLAN_ORDER_ID AS FP_TARGET_ID
                            , A.ITEM_ID
                            , C.SITE_ID AS TO_SITE_ID
                            , C.PLANT_ID AS TO_PLANT_ID
                            , C.FACTORY_ID AS CUSTOMER_ID
                            , A.EVENT_TIME AS DUE_DATE
                            --, A.EVENT_TIME AS DUE_FENCE_DATE
                            --, C.PLAN_DATE AS DUE_DATE
                            , C.PLAN_DATE AS DUE_FENCE_DATE
                            , CEILING(A.EVENT_QTY*(-1)) AS DEMAND_QTY
                            , C.PRODUCTION_TYPE
                            , C.MARKET
                        FROM  TH_BUF_OUT_ITEM_PLAN A
                              INNER JOIN TH_EXP_PLANORDER B
                                    ON    1=1 
                                    AND   A.MASTER_ID = B.MASTER_ID
                                    AND   A.PLAN_ID = B.PLAN_ID
                                    AND   A.WORK_ORDER_ID = B.ORDER_ID
                              INNER JOIN SY_FP_PRODUCTION_PLAN_R C
                                    ON    1=1 
                                    AND   A.MASTER_ID = B.MASTER_ID
                                    AND   A.PLAN_ID = C.FP_PLAN_ID
                                    AND   B.PLAN_ORDER_ID = C.WORK_ORDER_ID      
                               LEFT OUTER JOIN (
                                                SELECT AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID, 
                                                       AA.PARENT_ITEM_ID, AA.CHILD_ITEM_ID
                                                FROM   SY_SCM_BOM_M AA,
                                                       (
                                                        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID,
                                                               MAX(KEY_DATE) AS KEY_DATE
                                                        FROM   SY_SCM_BOM_M         A,
                                                               SY_SCM_ITEM_M        B,
                                                               SY_SCM_ITEM_CLASS_M  C
                                                        WHERE  1=1
                                                        AND    A.ACTIVE_FLAG    = 'Y'
                                                        AND    A.COMPANY_ID     = B.COMPANY_ID
                                                        AND    A.DIVISION_ID    = B.DIVISION_ID
                                                        AND    A.SITE_ID        = B.SITE_ID
                                                        AND    A.CHILD_ITEM_ID  = B.ITEM_ID  
                                                        AND    B.ACTIVE_FLAG    = 'Y'
                                                        AND    B.ITEM_CLASS     = C.CLASS_ID  
                                                        AND    C.USE_FLAG       = 'Y'                                
                                                        AND    A.EFF_END_DATE  >= CONVERT(DATE, GETDATE())
                                                        GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                                                       ) BB,
                                                       SY_SCM_ITEM_M        CC,
                                                       SY_SCM_ITEM_CLASS_M  DD
                                                WHERE  AA.COMPANY_ID      = BB.COMPANY_ID
                                                AND    AA.DIVISION_ID     = BB.DIVISION_ID
                                                AND    AA.SITE_ID         = BB.SITE_ID
                                                AND    AA.PLANT_ID        = BB.PLANT_ID
                                                AND    AA.PARENT_ITEM_ID  = BB.PARENT_ITEM_ID
                                                AND    AA.CHILD_ITEM_ID   = BB.CHILD_ITEM_ID
                                                AND    AA.KEY_DATE        = BB.KEY_DATE
                                                AND    AA.COMPANY_ID     = CC.COMPANY_ID
                                                AND    AA.DIVISION_ID    = CC.DIVISION_ID
                                                AND    AA.SITE_ID        = CC.SITE_ID
                                                AND    AA.CHILD_ITEM_ID  = CC.ITEM_ID  
                                                AND    CC.ACTIVE_FLAG    = 'Y'
                                                AND    CC.ITEM_CLASS     = DD.CLASS_ID  
                                                AND    DD.USE_FLAG       = 'Y'                    
                                                AND    AA.ACTIVE_FLAG     = 'Y'
                                                AND    AA.BOM_VERSION_ID  = '1'
                                                AND    AA.EFF_END_DATE  >= CONVERT(DATE, GETDATE())
                                                GROUP  BY 
                                                       AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID, 
                                                       AA.PARENT_ITEM_ID, AA.CHILD_ITEM_ID
                                               ) D
                                    ON    1=1
                                    AND   C.COMPANY_ID = D.COMPANY_ID
                                    AND   C.DIVISION_ID = D.DIVISION_ID
                                    AND   C.SITE_ID = D.SITE_ID
                                    AND   A.ITEM_ID = D.PARENT_ITEM_ID
                                    AND   D.PLANT_ID IS NOT NULL
                                    AND   C.PLANT_ID <> D.PLANT_ID
                        WHERE 1=1
                        AND   A.MASTER_ID = @v_master_id
                        AND   A.PLAN_ID = @v_plan_id
                        AND   A.OUT_VERSION_ID = @v_plan_id
                        AND   A.ITEM_ID IN (
                                            SELECT  ITEM_ID 
                                            FROM    SY_SCM_ITEM_M       A
                                                  , SY_SCM_ITEM_CLASS_M B
                                            WHERE   A.ITEM_CLASS = B.CLASS_ID
                                            AND     A.ACTIVE_FLAG = 'Y'
                                            AND     B.USE_FLAG = 'Y'
                                            AND     B.LEVEL_2_CODE = 'APC'
                                            AND     B.LEVEL_3_NAME NOT LIKE '%SRS%'   -- SRS 는 대상에서 제외
                                           )
                        ) A
                        LEFT OUTER JOIN SY_SCM_FACTORY_M B
                             ON    A.CUSTOMER_ID = B.FACTORY_ID
                  GROUP BY A.COMPANY_ID
                         , A.DIVISION_ID
                         , A.SITE_ID
                         , A.PLANT_ID
                         , ISNULL(B.SHOP_GROUP_ID, 'E')
                         , A.SCP_PLAN_ID
                         , A.SCP_TARGET_ID
                         , A.FP_TARGET_ID
                         --, ITEM_ID
                
                  --LOG 생성
                  EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_DAILY_INSTANCE_DEMAND_H', 'INSERT', @@ROWCOUNT, null, @v_to_instance_id, null
                  
                  -----------------------------------------------------------------
                  -- 전극 전공정
                  -----------------------------------------------------------------
                  BEGIN
                  
                    -- 전극 전공정의 경우 DAILY 말고 SHIP TARGET 들이 전부 후공정 타겟이라
                    -- 수율 관련된 부분에 대한 것은 전부 반영해야 하므로 PR_SCM_DPP_DEMAND 에서 처리한다.
                    SELECT @v_transfer_instance_id = KEY_VALUE
                    FROM   SY_FP_INSTANCE_CONFIG_M
                    WHERE  1=1
                    AND    INSTANCE_ID  = @v_to_instance_id
                    AND    KEY_ID       = @v_to_instance_key
                    AND    CATEGORY_ID  = 'RESULT_TRANSFER' 
                    AND    KEY_PRIORITY = 2
                  
                    IF @v_transfer_instance_id IS NOT NULL                
                      BEGIN

                        DELETE FROM SY_FP_DAILY_INSTANCE_DEMAND_H
                        WHERE  INSTANCE_ID = @v_transfer_instance_id
                        AND    INSTANCE_DATE = @v_plan_date
                        AND    SCP_PLAN_ID = @v_plan_id
                      
                        INSERT INTO SY_FP_DAILY_INSTANCE_DEMAND_H
                              (
                                INSTANCE_ID
                              , INSTANCE_DATE
                              , COMPANY_ID
                              , DIVISION_ID
                              , SITE_ID
                              , PLANT_ID
                              , SHOP_GROUP_ID
                              , SCP_PLAN_ID
                              , SCP_TARGET_ID
                              , FP_TARGET_ID
                              , ITEM_ID
                              , TO_SITE_ID
                              , TO_PLANT_ID
                              , CUSTOMER_ID
                              , MARKET
                              , DUE_DATE
                              , DUE_FENCE_DATE
                              , DEMAND_QTY
                              , ROLL_QTY
                              , JR_QTY
                              , CELL_QTY
                              , PRODUCTION_TYPE
                              , INSERT_ID
                              , INSERT_TIME
                              , UPDATE_ID
                              , UPDATE_TIME
                              )
                        SELECT
                              @v_transfer_instance_id AS INSTANCE_ID
                            , @v_plan_date AS INSTANCE_DATE
                            , A.COMPANY_ID
                            --, DIVISION_ID
                            , CASE WHEN A.DIVISION_ID = '82' THEN '81' ELSE A.DIVISION_ID END AS DIVISION_ID  -- ESS는 전극에 구분이 없음. 자동차로 진행함
                            , A.SITE_ID
                            , A.PLANT_ID
                            , ISNULL(B.SHOP_GROUP_ID, 'E') AS SHOP_GROUP_ID
                            , A.SCP_PLAN_ID
                            , A.SCP_TARGET_ID
                            , A.FP_TARGET_ID
                            , MIN(ITEM_ID) AS ITEM_ID
                            , MIN(TO_SITE_ID) AS TO_SITE_ID
                            , MIN(TO_PLANT_ID) AS TO_PLANT_ID
                            , MIN(CUSTOMER_ID) AS CUSTOMER_ID
                            , MIN(MARKET)      AS MARKET
                            --, MIN(DUE_DATE)    AS DUE_DATE
                            , MIN(DUE_FENCE_DATE) AS DUE_DATE
                            , MIN(DUE_FENCE_DATE) AS DUE_FENCE_DATE
                            , SUM(DEMAND_QTY) AS DEMAND_QTY
                            , NULL AS ROLL_QTY
                            , NULL AS JR_QTY
                            , NULL AS CELL_QTY
                            , MIN(PRODUCTION_TYPE) AS PRODUCTION_TYPE
                            , @v_proc_name AS INSERT_ID
                            , GETDATE()    AS INSERT_DTTM
                            , @v_proc_name AS UPDATE_ID
                            , GETDATE()    AS UPDATE_DTTM
                        FROM (SELECT DISTINCT
                                    C.COMPANY_ID
                                  , C.DIVISION_ID
                                  , C.SITE_ID
                                  , MAX(ISNULL(D.PLANT_ID,C.PLANT_ID)) OVER (PARTITION BY B.PLAN_ORDER_ID) AS PLANT_ID -- ## NULL 임시 예외 처리..!! - 2016.12.15
                                  , A.PLAN_ID AS SCP_PLAN_ID
                                  , B.PLAN_ORDER_ID AS SCP_TARGET_ID
                                  , B.PLAN_ORDER_ID AS FP_TARGET_ID
                                  , A.ITEM_ID
                                  , C.SITE_ID AS TO_SITE_ID
                                  , C.PLANT_ID AS TO_PLANT_ID
                                  , C.FACTORY_ID AS CUSTOMER_ID
                                  , A.EVENT_TIME AS DUE_DATE
                                  --, A.EVENT_TIME AS DUE_FENCE_DATE
                                  --, C.PLAN_DATE AS DUE_DATE
                                  , C.PLAN_DATE AS DUE_FENCE_DATE
                                  , CEILING(A.EVENT_QTY*(-1)) AS DEMAND_QTY
                                  , C.PRODUCTION_TYPE
                                  , C.MARKET
                              FROM  TH_BUF_OUT_ITEM_PLAN A
                                    INNER JOIN TH_EXP_PLANORDER B
                                          ON    1=1 
                                          AND   A.MASTER_ID = B.MASTER_ID
                                          AND   A.PLAN_ID = B.PLAN_ID
                                          AND   A.WORK_ORDER_ID = B.ORDER_ID
                                    INNER JOIN SY_FP_PRODUCTION_PLAN_R C
                                          ON    1=1 
                                          AND   A.MASTER_ID = B.MASTER_ID
                                          AND   A.PLAN_ID = C.FP_PLAN_ID
                                          AND   B.PLAN_ORDER_ID = C.WORK_ORDER_ID      
                                     LEFT OUTER JOIN (
                                                      SELECT AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID, 
                                                             AA.PARENT_ITEM_ID, AA.CHILD_ITEM_ID
                                                      FROM   SY_SCM_BOM_M AA,
                                                             (
                                                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID,
                                                                     MAX(KEY_DATE) AS KEY_DATE
                                                              FROM   SY_SCM_BOM_M         A,
                                                                     SY_SCM_ITEM_M        B,
                                                                     SY_SCM_ITEM_CLASS_M  C
                                                              WHERE  1=1
                                                              AND    A.ACTIVE_FLAG    = 'Y'
                                                              AND    A.COMPANY_ID     = B.COMPANY_ID
                                                              AND    A.DIVISION_ID    = B.DIVISION_ID
                                                              AND    A.SITE_ID        = B.SITE_ID
                                                              AND    A.CHILD_ITEM_ID  = B.ITEM_ID  
                                                              AND    B.ACTIVE_FLAG    = 'Y'
                                                              AND    B.ITEM_CLASS     = C.CLASS_ID  
                                                              AND    C.USE_FLAG       = 'Y'                                
                                                              AND    A.EFF_END_DATE  >= CONVERT(DATE, GETDATE())
                                                              GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                                                             ) BB,
                                                             SY_SCM_ITEM_M        CC,
                                                             SY_SCM_ITEM_CLASS_M  DD
                                                      WHERE  AA.COMPANY_ID      = BB.COMPANY_ID
                                                      AND    AA.DIVISION_ID     = BB.DIVISION_ID
                                                      AND    AA.SITE_ID         = BB.SITE_ID
                                                      AND    AA.PLANT_ID        = BB.PLANT_ID
                                                      AND    AA.PARENT_ITEM_ID  = BB.PARENT_ITEM_ID
                                                      AND    AA.CHILD_ITEM_ID   = BB.CHILD_ITEM_ID
                                                      AND    AA.KEY_DATE        = BB.KEY_DATE
                                                      AND    AA.COMPANY_ID     = CC.COMPANY_ID
                                                      AND    AA.DIVISION_ID    = CC.DIVISION_ID
                                                      AND    AA.SITE_ID        = CC.SITE_ID
                                                      AND    AA.CHILD_ITEM_ID  = CC.ITEM_ID  
                                                      AND    CC.ACTIVE_FLAG    = 'Y'
                                                      AND    CC.ITEM_CLASS     = DD.CLASS_ID  
                                                      AND    DD.USE_FLAG       = 'Y'                    
                                                      AND    AA.ACTIVE_FLAG     = 'Y'
                                                      AND    AA.BOM_VERSION_ID  = '1'
                                                      AND    AA.EFF_END_DATE  >= GETDATE()
                                                      GROUP  BY 
                                                             AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID, 
                                                             AA.PARENT_ITEM_ID, AA.CHILD_ITEM_ID
                                                     ) D
                                          ON    1=1
                                          AND   C.COMPANY_ID = D.COMPANY_ID
                                          AND   C.DIVISION_ID = D.DIVISION_ID
                                          AND   C.SITE_ID = D.SITE_ID
                                          AND   A.ITEM_ID = D.PARENT_ITEM_ID
                                          AND   D.PLANT_ID IS NOT NULL
                                          AND   C.PLANT_ID <> D.PLANT_ID
                              WHERE 1=1
                              AND   A.MASTER_ID = @v_master_id
                              AND   A.PLAN_ID = @v_plan_id
                              AND   A.OUT_VERSION_ID = @v_plan_id
                              AND   A.ITEM_ID IN (
                                                  SELECT  ITEM_ID 
                                                  FROM    SY_SCM_ITEM_M       A
                                                        , SY_SCM_ITEM_CLASS_M B
                                                  WHERE   A.ITEM_CLASS = B.CLASS_ID
                                                  AND     A.ACTIVE_FLAG = 'Y'
                                                  AND     B.USE_FLAG = 'Y'
                                                  AND     B.LEVEL_2_CODE = 'APC'
                                                  AND     B.LEVEL_3_NAME NOT LIKE '%SRS%'   -- SRS 는 대상에서 제외
                                                 )
                              ) A
                              LEFT OUTER JOIN SY_SCM_FACTORY_M B
                                   ON    A.CUSTOMER_ID = B.FACTORY_ID
                        GROUP BY A.COMPANY_ID
                               , A.DIVISION_ID
                               , A.SITE_ID
                               , A.PLANT_ID
                               , ISNULL(B.SHOP_GROUP_ID, 'E')
                               , A.SCP_PLAN_ID
                               , A.SCP_TARGET_ID
                               , A.FP_TARGET_ID
                               --, ITEM_ID
                      
                        --LOG 생성
                        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_DAILY_INSTANCE_DEMAND_H', 'INSERT', @@ROWCOUNT, null, @v_transfer_instance_id, null
                        
                      END
                    
                  END
                  
                END
                
              ELSE IF @v_to_instance_key = 'PRODUCT_TO_STOCK'
                BEGIN

                  DELETE FROM SY_FP_DAILY_INSTANCE_STOCK_H
                  WHERE  INSTANCE_ID = @v_to_instance_id
                  AND    INSTANCE_DATE = @v_plan_date
                  AND    SCP_PLAN_ID = @v_plan_id

                  INSERT INTO SY_FP_DAILY_INSTANCE_STOCK_H
                  SELECT DISTINCT
                        @v_to_instance_id     AS INSTANCE_ID
                      , @v_plan_date          AS INSTANCE_DATE
                      , C.IRS_ATTB_11         AS COMPANY_ID
                      , C.IRS_ATTB_12         AS DIVISION_ID
                      , C.IRS_ATTB_13         AS SITE_ID
                      , C.IRS_ATTB_14         AS PLANT_ID
                      , A.PLAN_ID             AS SCP_PLAN_ID
                      , D.PLAN_ORDER_ID       AS SCP_TARGET_ID
                      , B.SITE_ID             AS FACTORY_ID
                      , B.ROUTE_ID            AS LINE_ID
                      , B.OPERATION_ID        AS OPERATION_ID
                      , ISNULL(F.LANE_QTY, 0) AS LANE_QTY
                      , B.OUT_ITEM_ID         AS ITEM_ID
                      , B.END_TIME                    AS RECEIVING_TIME
                      , ROUND(ABS(B.COMPLETE_QTY),0)  AS PLAN_QTY
                      , ISNULL(E.ORDER_TYPE, 'MASS')  AS PRODUCTION_TYPE
                      , @v_proc_name          AS INSERT_ID
                      , GETDATE()             AS INSERT_DTTM
                      , @v_proc_name          AS UPDATE_ID
                      , GETDATE()             AS UPDATE_DTTM
                  FROM  TH_BUF_OUT_ITEM_PEGGING A
                        INNER JOIN TH_BUF_OUT_ORDER_TRACKING B
                              ON     1=1
                              AND    A.MASTER_ID = B.MASTER_ID
                              AND    A.PLAN_ID = B.PLAN_ID
                              AND    A.OUT_VERSION_ID = B.OUT_VERSION_ID
                              AND    A.IN_ITEM_PEGGING_ID = B.OUT_ITEM_PEGGING_ID
                        INNER JOIN TH_MST_ITEM_ROUTE_SITE C
                              ON     1=1
                              AND    A.MASTER_ID = C.MASTER_ID
                              AND    A.PLAN_ID = C.PLAN_ID
                              AND    B.OUT_ITEM_ID = C.ITEM_ID
                              AND    B.SITE_ID = C.SITE_ID
                              AND    B.ROUTE_ID = C.ROUTE_ID
                              AND    B.OPERATION_ID = C.OPERATION_ID
                        INNER JOIN TH_EXP_PLANORDER D
                              ON     1=1
                              AND    A.MASTER_ID = D.MASTER_ID
                              AND    A.PLAN_ID = D.PLAN_ID
                              AND    B.ORDER_ID = D.ORDER_ID
                        INNER JOIN TH_DPP_NET_DEMAND E
                              ON     1=1
                              AND    A.MASTER_ID = E.MASTER_ID
                              AND    A.PLAN_ID = E.PLAN_ID
                              AND    A.DEMAND_ID = E.NET_DEMAND_iD
                        LEFT OUTER JOIN (
                                          SELECT ORDER_ID, ISNULL(MAIN_LANE_QTY, LANE_QTY) AS LANE_QTY 
                                          FROM   TH_EXP_LANEORDER
                                          WHERE  MASTER_ID = @v_master_id
                                          AND    PLAN_ID = @v_plan_id
                                          UNION  ALL
                                          SELECT SUB_ORDER_ID AS ORDER_ID, SUB_LANE_QTY AS LANE_QTY 
                                          FROM   TH_EXP_LANEORDER
                                          WHERE  MASTER_ID = @v_master_id
                                          AND    PLAN_ID = @v_plan_id
                                          AND    SUB_ORDER_ID IS NOT NULL
                                        ) F
                              ON     1=1
                              AND    D.ORDER_ID = F.ORDER_ID
                  WHERE A.MASTER_ID = @v_master_id
                  AND   A.PLAN_ID = @v_plan_id
                  AND   A.OUT_VERSION_ID = @v_plan_id
                  AND   A.DEMAND_ID IS NOT NULL
                  
                  --LOG 생성
                  EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_DAILY_INSTANCE_STOCK_H', 'INSERT', @@ROWCOUNT, null, null, null

                END
            END

            ---------------------------------------------------------------------
            -- PRE MIX - INSTANCE DEMAND 생성
            ---------------------------------------------------------------------
            IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
            BEGIN
            
              SET @v_to_instance_id = NULL
              SET @v_to_instance_key = NULL
                  
              SELECT @v_to_instance_key = KEY_ID, 
                     @v_to_instance_id = KEY_VALUE
              FROM   SY_FP_INSTANCE_CONFIG_M
              WHERE  1=1
              AND    INSTANCE_ID = @v_master_id
              AND    CATEGORY_ID = 'RESULT_TRANSFER' 
              AND    KEY_PRIORITY = 3
              
              --LOG 생성
              IF @v_to_instance_key IS NOT NULL
                EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_INSTANCE_CONFIG_M', 'SELECT', @@ROWCOUNT, null, 'RESULT_TRANSFER', null

              IF @v_to_instance_key = 'CONSUME_DEMAND' 
                BEGIN
                
                  DELETE FROM SY_FP_DAILY_INSTANCE_DEMAND_H
                  WHERE  INSTANCE_ID = @v_to_instance_id
                  AND    INSTANCE_DATE = @v_plan_date
                  AND    SCP_PLAN_ID = @v_plan_id


                  INSERT INTO SY_FP_DAILY_INSTANCE_DEMAND_H
                      (
                        INSTANCE_ID
                      , INSTANCE_DATE
                      , COMPANY_ID
                      , DIVISION_ID
                      , SITE_ID
                      , PLANT_ID
                      , SHOP_GROUP_ID
                      , SCP_PLAN_ID
                      , SCP_TARGET_ID
                      , FP_TARGET_ID
                      , ITEM_ID
                      , TO_SITE_ID
                      , TO_PLANT_ID
                      , CUSTOMER_ID
                      , MARKET
                      , DUE_DATE
                      , DUE_FENCE_DATE
                      , DEMAND_QTY
                      , ROLL_QTY
                      , JR_QTY
                      , CELL_QTY
                      , PRODUCTION_TYPE
                      , INSERT_ID
                      , INSERT_TIME
                      , UPDATE_ID
                      , UPDATE_TIME
                      )
                  SELECT
                        @v_to_instance_id AS INSTANCE_ID
                      , @v_plan_date AS INSTANCE_DATE
                      , A.COMPANY_ID
                      --, DIVISION_ID
                      , CASE WHEN A.DIVISION_ID = '82' THEN '81' ELSE A.DIVISION_ID END AS DIVISION_ID  -- ESS는 전극에 구분이 없음. 자동차로 진행함
                      , A.SITE_ID
                      , A.PLANT_ID
                      , ISNULL(B.SHOP_GROUP_ID, 'E')
                      , A.SCP_PLAN_ID
                      , A.SCP_TARGET_ID
                      , A.FP_TARGET_ID
                      , ITEM_ID
                      , MIN(TO_SITE_ID) AS TO_SITE_ID
                      , MIN(TO_PLANT_ID) AS TO_PLANT_ID
                      , MIN(CUSTOMER_ID) AS CUSTOMER_ID
                      , MIN(MARKET)      AS MARKET
                      , MIN(DUE_DATE) AS DUE_DATE
                      , MIN(DUE_FENCE_DATE) AS DUE_FENCE_DATE
                      , SUM(DEMAND_QTY) AS DEMAND_QTY
                      , NULL AS ROLL_QTY
                      , NULL AS JR_QTY
                      , NULL AS CELL_QTY
                      , MIN(PRODUCTION_TYPE) AS PRODUCTION_TYPE
                      , @v_proc_name AS INSERT_ID
                      , GETDATE()    AS INSERT_DTTM
                      , @v_proc_name AS UPDATE_ID
                      , GETDATE()    AS UPDATE_DTTM
                  FROM (
                        SELECT DISTINCT
                              C.COMPANY_ID
                            , C.DIVISION_ID
                            , C.SITE_ID
                            , MAX(ISNULL(D.PLANT_ID,C.PLANT_ID)) OVER (PARTITION BY B.PLAN_ORDER_ID) AS PLANT_ID -- ## NULL 임시 예외 처리..!! - 2016.12.15
                            , A.PLAN_ID AS SCP_PLAN_ID
                            , B.PLAN_ORDER_ID + '_' + A.ITEM_ID AS SCP_TARGET_ID
                            , B.PLAN_ORDER_ID + '_' + A.ITEM_ID AS FP_TARGET_ID
                            , A.ITEM_ID
                            , C.SITE_ID AS TO_SITE_ID
                            , C.PLANT_ID AS TO_PLANT_ID
                            , C.FACTORY_ID AS CUSTOMER_ID
                            , A.EVENT_TIME AS DUE_DATE
                            --, A.EVENT_TIME AS DUE_FENCE_DATE
                            --, C.PLAN_DATE AS DUE_DATE
                            , C.PLAN_DATE AS DUE_FENCE_DATE
                            , CEILING(A.EVENT_QTY*(-1)) AS DEMAND_QTY
                            , C.PRODUCTION_TYPE
                            , C.MARKET
                        FROM  TH_BUF_OUT_ITEM_PLAN A
                              INNER JOIN TH_EXP_PLANORDER B
                                    ON    1=1 
                                    AND   A.MASTER_ID = B.MASTER_ID
                                    AND   A.PLAN_ID = B.PLAN_ID
                                    AND   A.WORK_ORDER_ID = B.ORDER_ID
                              INNER JOIN SY_FP_PRODUCTION_PLAN_R C
                                    ON    1=1 
                                    AND   A.MASTER_ID = B.MASTER_ID
                                    AND   A.PLAN_ID = C.FP_PLAN_ID
                                    AND   B.PLAN_ORDER_ID = C.WORK_ORDER_ID      
                               LEFT OUTER JOIN (
                                                SELECT AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID, 
                                                       AA.PARENT_ITEM_ID, AA.CHILD_ITEM_ID
                                                FROM   SY_SCM_BOM_M AA,
                                                       (
                                                        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID,
                                                               MAX(KEY_DATE) AS KEY_DATE
                                                        FROM   SY_SCM_BOM_M         A,
                                                               SY_SCM_ITEM_M        B,
                                                               SY_SCM_ITEM_CLASS_M  C
                                                        WHERE  1=1
                                                        AND    A.ACTIVE_FLAG    = 'Y'
                                                        AND    A.COMPANY_ID     = B.COMPANY_ID
                                                        AND    A.DIVISION_ID    = B.DIVISION_ID
                                                        AND    A.SITE_ID        = B.SITE_ID
                                                        AND    A.CHILD_ITEM_ID  = B.ITEM_ID  
                                                        AND    B.ACTIVE_FLAG    = 'Y'
                                                        AND    B.ITEM_CLASS     = C.CLASS_ID  
                                                        AND    C.USE_FLAG       = 'Y'                                
                                                        AND    A.EFF_END_DATE  >= CONVERT(DATE, GETDATE())
                                                        GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                                                       ) BB,
                                                       SY_SCM_ITEM_M        CC,
                                                       SY_SCM_ITEM_CLASS_M  DD
                                                WHERE  AA.COMPANY_ID      = BB.COMPANY_ID
                                                AND    AA.DIVISION_ID     = BB.DIVISION_ID
                                                AND    AA.SITE_ID         = BB.SITE_ID
                                                AND    AA.PLANT_ID        = BB.PLANT_ID
                                                AND    AA.PARENT_ITEM_ID  = BB.PARENT_ITEM_ID
                                                AND    AA.CHILD_ITEM_ID   = BB.CHILD_ITEM_ID
                                                AND    AA.KEY_DATE        = BB.KEY_DATE
                                                AND    AA.COMPANY_ID     = CC.COMPANY_ID
                                                AND    AA.DIVISION_ID    = CC.DIVISION_ID
                                                AND    AA.SITE_ID        = CC.SITE_ID
                                                AND    AA.CHILD_ITEM_ID  = CC.ITEM_ID  
                                                AND    CC.ACTIVE_FLAG    = 'Y'
                                                AND    CC.ITEM_CLASS     = DD.CLASS_ID  
                                                AND    DD.USE_FLAG       = 'Y'                    
                                                AND    AA.ACTIVE_FLAG     = 'Y'
                                                AND    AA.BOM_VERSION_ID  = '1'
                                                AND    AA.EFF_END_DATE  >= GETDATE()
                                                GROUP  BY 
                                                       AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID, 
                                                       AA.PARENT_ITEM_ID, AA.CHILD_ITEM_ID
                                               ) D
                                    ON    1=1
                                    AND   C.COMPANY_ID = D.COMPANY_ID
                                    AND   C.DIVISION_ID = D.DIVISION_ID
                                    AND   C.SITE_ID = D.SITE_ID
                                    AND   A.ITEM_ID = D.PARENT_ITEM_ID
                                    AND   D.PLANT_ID IS NOT NULL
                                    AND   C.PLANT_ID <> D.PLANT_ID
                        WHERE 1=1
                        AND   A.MASTER_ID       = @v_master_id
                        AND   A.PLAN_ID         = @v_plan_id
                        AND   A.OUT_VERSION_ID  = @v_plan_id
                        AND   A.ITEM_ID IN (
                                            SELECT  ITEM_ID 
                                            FROM    SY_SCM_ITEM_M       A
                                                  , SY_SCM_ITEM_CLASS_M B
                                            WHERE   A.ITEM_CLASS = B.CLASS_ID
                                            AND     A.ACTIVE_FLAG   = 'Y'
                                            AND     B.USE_FLAG      = 'Y'
                                            AND     B.LEVEL_2_CODE  = 'ASL'
                                            AND     B.LEVEL_3_CODE  = 'ASLPD'      -- PRE MIX 만 대상                                            
                                           )
                        ) A
                        LEFT OUTER JOIN SY_SCM_FACTORY_M B
                             ON    A.CUSTOMER_ID = B.FACTORY_ID
                  GROUP BY A.COMPANY_ID
                         , A.DIVISION_ID
                         , A.SITE_ID
                         , A.PLANT_ID
                         , ISNULL(B.SHOP_GROUP_ID, 'E')
                         , A.SCP_PLAN_ID
                         , A.SCP_TARGET_ID
                         , A.FP_TARGET_ID
                         , ITEM_ID
                  
                  --LOG 생성
                  EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_DAILY_INSTANCE_DEMAND_H', 'INSERT', @@ROWCOUNT, null, @v_to_instance_id, null

                END            
                
            END
            
            
          END
          
      END;

      BEGIN
      
        UPDATE dbo.TH_MST_ENG_PLAN_FLAG
        SET    DB_TRANS_FLAG = 'C'
             , DB_TRANS_END = sysdatetime()
             , UPDATE_ID = @v_proc_name
             , UPDATE_DATE = sysdatetime()
        WHERE  MASTER_ID = @v_master_id 
        AND    PLAN_ID = @v_plan_id 
        AND    OUT_VERSION_ID = @v_plan_id
        
        UPDATE SY_FP_PLAN_STATUS_H
        SET    ACTIVE_FLAG = '0',
               DB_TRANS_FLAG = 'C',
               DB_TRANS_STEP = '4',
               DB_TRANS_END = sysdatetime(), 
               UPDATE_ID = @v_proc_name, 
               UPDATE_TIME = sysdatetime()
        WHERE  INSTANCE_ID = @v_master_id 
        AND    PLAN_ID = @v_plan_id
          
        --LOG 생성
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_MST_ENG_PLAN_FLAG', 'UPDATE', @@ROWCOUNT, null, 'DB_TRANS_FLAG = C', null
      
      END

      WAITFOR DELAY '0:0:1'

      IF dbo.fn_plan_status(@v_master_id, @v_plan_id) > 0
      BEGIN
      
        UPDATE dbo.TH_MST_ENG_PLAN_FLAG
        SET    DB_TRANS_FLAG = 'S'
             , DB_TRANS_END = sysdatetime()
             , UPDATE_ID = @v_proc_name
             , UPDATE_DATE = sysdatetime()
        WHERE  MASTER_ID = @v_master_id 
        AND    PLAN_ID = @v_plan_id 
        AND    OUT_VERSION_ID = @v_plan_id
        
        UPDATE SY_FP_PLAN_STATUS_H
        SET    ACTIVE_FLAG = '0',
               DB_TRANS_FLAG = 'S',
               DB_TRANS_STEP = '4',
               DB_TRANS_END = sysdatetime(), 
               UPDATE_ID = @v_proc_name, 
               UPDATE_TIME = sysdatetime()
        WHERE  INSTANCE_ID = @v_master_id 
        AND    PLAN_ID = @v_plan_id
          
        --LOG 생성
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_MST_ENG_PLAN_FLAG', 'UPDATE', @@ROWCOUNT, null, 'DB_TRANS_FLAG = C', null
      
      END
    
    END
    
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, '#######   PLAN END   #######', 'END', 999999, null, '############### End of procedure ###############', null
            
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
