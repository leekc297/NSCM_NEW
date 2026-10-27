CREATE PROCEDURE [dbo].[PR_SCM_IF_PLAN_SYNC]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_PLAN_SYNC                                                       **/
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
  EXEC PR_SCM_IF_PLAN_SYNC
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_top_plan_id    nvarchar(30)
  DECLARE @n_count          integer = 0
  DECLARE @v_plan_date      nvarchar(10)

  DECLARE @v_prod_plan_id   nvarchar(30)
  DECLARE @v_ship_plan_id   nvarchar(30)
  
  DECLARE @v_basis_plan_id  nvarchar(30)
  
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_PLAN_SYNC'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)

  DECLARE @v_temp1        nvarchar(1000)
  DECLARE @v_temp2        nvarchar(1000)
  
  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    
    -- 필수 DATA 쿼리.. 반듯이 있어야 함.
    BEGIN

      SET @v_table_name = 'SCM_FP_PLAN_H'
      SET @v_basis_plan_id = NULL

      SELECT @v_basis_plan_id = BASIS_PLAN_ID
           , @plan_start_time = PLAN_START_TIME
           , @plan_end_time = (
                                CASE  WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_TIME)
                                      WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_TIME)
                                      WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_TIME)
                                                                      ELSE DATEADD(DD, PLAN_HORIZON,     PLAN_START_TIME)
                                END  
                              )
      FROM   SY_SCM_FP_PLAN_H
      WHERE  INSTANCE_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
      
      --LOG 생성
      SET @v_message = '@v_basis_plan_id : ' + @v_basis_plan_id
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null

    END;
    
    IF @v_basis_plan_id IS NOT NULL
    BEGIN

      SELECT @n_count = COUNT(1)
      FROM   TH_MST_PLAN
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id

      IF @n_count = 0 
        BEGIN

          SET @v_table_name = 'TH_MST_PLAN'

          INSERT INTO TH_MST_PLAN
                  (
                    MASTER_ID,
                    PLAN_ID,
                    PLAN_SEQ,
                    PLAN_TYPE,
                    PLAN_NAME,
                    PLAN_START_DTTM,
                    PLAN_DATE,
                    BASIS_START_TIME,
                    PLAN_HORIZON,
                    PLAN_HORIZON_UOM,
                    DEMAND_HORIZON,
                    DEMAND_HORIZON_UOM,
                    WEEK,
                    MONTH,
                    IS_RUNNING,
                    IS_FINISHED,
                    IS_CONFIRMED,
                    IS_AMEND_POSSIBLE,
                    IS_PLANDATE_START,
                    BASIS_PLAN_ID,
                    CONFIG_SET_ID,
                    DPP_CONFIG_SET_ID,
                    AMEND_MASTER_ID,
                    AMEND_PLAN_ID,
                    ORDER_START_SEQ,
                    TOP_PLAN_ID,
                    TOP_ROUTE_ID,
                    SCP_PRODUCT_PLAN_ID,
                    SCP_SHIPMENT_PLAN_ID,
                    SCP_SHIP_ELEC_PLAN_ID,
                    SCP_SRS_PLAN_ID,
                    SCP_PROD_TEST_PLAN_ID,
                    DESCR,
                    KEY_DATE,
                    INSERT_ID,
                    INSERT_DTTM,
                    UPDATE_ID,
                    UPDATE_DTTM
                  )
          SELECT 
                  @v_master_id                AS MASTER_ID,         
                  @v_plan_id                  AS PLAN_ID,           
                  1                           AS PLAN_SEQ,          
                  A.PLAN_TYPE,         
                  A.PLAN_TYPE + ' PLAN'       AS PLAN_NAME,         
                  A.PLAN_START_TIME           AS PLAN_START_DTTM,   
                  B.PLAN_DATE,         
                  B.BASIS_START_TIME,  
                  A.PLAN_HORIZON,      
                  A.PLAN_HORIZON_UOM,  
                  A.DEMAND_HORIZON,    
                  A.DEMAND_HORIZON_UOM,
                  B.WEEK,              
                  B.MONTH,             
                  B.IS_RUNNING,        
                  B.IS_FINISHED,       
                  B.IS_CONFIRMED,      
                  B.IS_AMEND_POSSIBLE, 
                  B.IS_PLANDATE_START, 
                  A.BASIS_PLAN_ID,     
                  A.CONFIG_SET_ID,     
                  B.DPP_CONFIG_SET_ID, 
                  A.INSTANCE_ID               AS AMEND_MASTER_ID,   
                  A.BASIS_PLAN_ID             AS AMEND_PLAN_ID,     
                  B.ORDER_START_SEQ,   
                  B.TOP_PLAN_ID,       
                  B.TOP_ROUTE_ID, 
                  B.SCP_PRODUCT_PLAN_ID,
                  B.SCP_SHIPMENT_PLAN_ID,
                  B.SCP_SHIP_ELEC_PLAN_ID,
                  B.SCP_SRS_PLAN_ID,
                  B.SCP_PROD_TEST_PLAN_ID,
                  ''                          AS DESCR,     
                  B.KEY_DATE,
                  @v_proc_name                AS INSERT_ID,         
                  GETDATE()                   AS INSERT_DTTM,       
                  @v_proc_name                AS UPDATE_ID,         
                  GETDATE()                   AS UPDATE_DTTM        
          FROM    SY_SCM_FP_PLAN_H  A,
                  TH_MST_PLAN       B
          WHERE   A.INSTANCE_ID = @v_master_id
          AND     A.PLAN_ID = @v_plan_id
          AND     B.MASTER_ID = @v_master_id
          AND     B.PLAN_ID = @v_basis_plan_id
        
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
        END
    
    END

    ---------------------------------------------------------------------------------------------
    -- MST COPY
    ---------------------------------------------------------------------------------------------    
    BEGIN
    
      BEGIN
      
        SET @v_table_name = 'TH_MST_INSTANCE_FLOW'

        DELETE  FROM TH_MST_INSTANCE_FLOW
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_plan_id
        
        INSERT INTO TH_MST_INSTANCE_FLOW
              (
                MASTER_ID
              , PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , ITEM_ID
              , OPERATION_ID
              , OPERATION_SEQ
              , ERP_OPERATION_ID
              , ORDER_TYPE
              , BATCH_TYPE
              , CAPA_TYPE
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM
              )
        SELECT
                MASTER_ID
              , @v_plan_id AS PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , ITEM_ID
              , OPERATION_ID
              , OPERATION_SEQ
              , ERP_OPERATION_ID
              , ORDER_TYPE
              , BATCH_TYPE
              , CAPA_TYPE
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM
        FROM    TH_MST_INSTANCE_FLOW
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_basis_plan_id
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      BEGIN
        
        SET @v_table_name = 'TH_MST_SCM_SALES_PRODUCT'

        DELETE  FROM TH_MST_SCM_SALES_PRODUCT
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_plan_id
        
        INSERT INTO TH_MST_SCM_SALES_PRODUCT
              (
                MASTER_ID
              , PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , SALES_MODEL_ID
              , PRODUCT_ITEM_ID
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM              
              )
        SELECT
                MASTER_ID
              , @v_plan_id AS PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , SALES_MODEL_ID
              , PRODUCT_ITEM_ID
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM         
        FROM    TH_MST_SCM_SALES_PRODUCT
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_basis_plan_id

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      BEGIN
        
        SET @v_table_name = 'TH_MST_SCM_DEMAND'

        DELETE  FROM TH_MST_SCM_DEMAND
        WHERE   INSTANCE_ID   = @v_master_id
        AND     DPP_PLAN_ID   = @v_plan_id
        
        INSERT INTO TH_MST_SCM_DEMAND
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
              , SCP_WEEK
              , MFG_WEEK
              , MFG_QTY
              , WORK_ORDER_ID
              , DUE_DATE
              , DUE_FENCE_DATE
              , PRECEDE_PRODUCING_TERM
              , PRECEDE_PRODUCING_TERM_UOM
              , PRODUCTION_TYPE
              , TO_SITE_ID
              , TO_PLANT_ID
              , TO_FACTORY_ID
              , OPERATION_ID
              , LINE_ID
              , MARKET
              , PRIORITY
              , OFFSET_INVENTORY_QTY
              , OFFSET_GI_QTY
              , OFFSET_FIX_QTY
              , CONFIRM_TYPE
              , DEMAND_TYPE
              , TARGET_TYPE
              , FIX_PEGGING_DEMAND_ID
              , KEY_DATE
              , INSERT_ID
              , INSERT_TIME
              , UPDATE_ID
              , UPDATE_TIME    
              )
        SELECT
                COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , SHOP_GROUP_ID
              , INSTANCE_ID
              , @v_plan_id AS DPP_PLAN_ID
              , FP_DEMAND_ID
              , SCP_PLAN_ID
              , SCP_TARGET_ID
              , ITEM_ID
              , SCP_WEEK
              , MFG_WEEK
              , MFG_QTY
              , WORK_ORDER_ID
              , DUE_DATE
              , DUE_FENCE_DATE
              , PRECEDE_PRODUCING_TERM
              , PRECEDE_PRODUCING_TERM_UOM
              , PRODUCTION_TYPE
              , TO_SITE_ID
              , TO_PLANT_ID
              , TO_FACTORY_ID
              , OPERATION_ID
              , LINE_ID
              , MARKET
              , PRIORITY
              , OFFSET_INVENTORY_QTY
              , OFFSET_GI_QTY
              , OFFSET_FIX_QTY
              , CONFIRM_TYPE
              , DEMAND_TYPE
              , TARGET_TYPE
              , FIX_PEGGING_DEMAND_ID
              , KEY_DATE
              , INSERT_ID
              , INSERT_TIME
              , UPDATE_ID
              , UPDATE_TIME    
        FROM    TH_MST_SCM_DEMAND
        WHERE   INSTANCE_ID   = @v_master_id
        AND     DPP_PLAN_ID   = @v_basis_plan_id

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END

      BEGIN
  
      SET @v_table_name = 'TH_CFG_CONFIG_SELECTOR'
          
          DELETE FROM TH_CFG_CONFIG_SELECTOR
          WHERE  1=1
          
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

          
          INSERT INTO TH_CFG_CONFIG_SELECTOR
          SELECT 'LGC' AS COMPANY,
                 'LGC' AS DIVISION,
                 'LGC' AS CORPORATION,
                 'LGC' AS PLANT,
                 'ENGINE' AS PLAN_TYPE,
                 CATEGORY_ID AS KEY_ID,
                 KEY_ID AS SELECTOR_ID,
                 KEY_VALUE AS COMPARATOR_ID,
                 KEY_VALUE AS COMPARATOR_NAME,
                 NULL AS TRUE_KEY_ID,
                 NULL AS FALSE_KEY_ID,
                 KEY_PRIORITY AS APPLY_ORDER,
                 1 AS VIEW_LEVEL,
                 TOLERANCE,
                 TOLERANCE_UOM,
                 DESCRIPTION AS DESCR,
                 @v_proc_name+'_'+@v_master_id AS INSERT_ID,
                 GETDATE() AS INSERT_DTTM,
                 @v_proc_name+'_'+@v_master_id AS UPDATE_ID,
                 GETDATE() AS UPDATE_DTTM,
                 'Y' AS IS_USE
          FROM   SY_FP_INSTANCE_CONFIG_M A
          WHERE  1=1
          AND    INSTANCE_ID = @v_master_id
          AND    CATEGORY_ID LIKE '%SELECTOR%'
          AND    PART_ID = 'SYNC'
          AND    NOT EXISTS (
                              SELECT 1
                              FROM   TH_CFG_CONFIG_SELECTOR X
                              WHERE  X.COMPANY        = 'LGC'
                              AND    X.DIVISION       = 'LGC'
                              AND    X.CORPORATION    = 'LGC'
                              AND    X.PLANT          = 'LGC'
                              AND    X.PLAN_TYPE      = 'ENGINE'
                              AND    X.KEY_ID         = A.CATEGORY_ID
                              AND    X.SELECTOR_ID    = A.KEY_ID
                              AND    X.COMPARATOR_ID  = A.KEY_VALUE
                            )
        
          set @n_row_count = @@ROWCOUNT


          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END
      /*
      BEGIN
  
      SET @v_table_name = 'TH_CFG_CONFIG_SELECTOR'
          
          UPDATE TH_CFG_CONFIG_VALUE
          SET VALUE = 'N'
          WHERE  1=1
          AND KEY_ID = 'PRIORITY_GROUP_FENCE'
          
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END
      */
    END


    -- PROC 수행
    
    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
      EXECUTE dbo.PR_SCM_IF_PRECALENDAR @v_master_id,@v_plan_id ;

    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
      EXECUTE dbo.PR_SCM_IF_ITEM        @v_master_id,@v_plan_id ;

    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
      EXECUTE dbo.PR_SCM_IF_LANE        @v_master_id,@v_plan_id ;

    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
      EXECUTE dbo.PR_SCM_IF_BOR         @v_master_id,@v_plan_id ;

    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
      EXECUTE dbo.PR_SCM_IF_ROUTE       @v_master_id,@v_plan_id ;

    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
      EXECUTE dbo.PR_SCM_IF_BOM         @v_master_id,@v_plan_id ;

    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
      EXECUTE dbo.PR_SCM_IF_BOD         @v_master_id,@v_plan_id ;

    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
      EXECUTE dbo.PR_SCM_IF_SETUP       @v_master_id,@v_plan_id ;

    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
      EXECUTE dbo.PR_SCM_IF_CALENDAR    @v_master_id,@v_plan_id ;   -- BOR 이 먼저 실행되어야 한다.

    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
      EXECUTE dbo.PR_SCM_IF_SALES       @v_master_id,@v_plan_id ;

    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
      EXECUTE dbo.PR_SCM_IF_BATCH       @v_master_id,@v_plan_id ;   -- ITEM GROUP ID 추가, PRIORITY 룰 지정

 
  BEGIN
      IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
        EXECUTE dbo.PR_SCM_DPP_SYNC_RUN       @v_master_id, @v_plan_id
  END


    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) = 0
      EXECUTE dbo.PR_SCM_IF_STOCK       @v_master_id,@v_plan_id ;
    
    IF dbo.fn_plan_status(@v_master_id, @v_plan_id) > 0
       UPDATE SY_FP_PLAN_STATUS_H
          SET 
             ACTIVE_FLAG = 0,
             INBOUND_FLAG = 'S',
             INBOUND_END = sysdatetime(), 
             UPDATE_ID = @v_proc_name, 
             UPDATE_TIME = sysdatetime()
       FROM SY_FP_PLAN_STATUS_H  AS a
       WHERE 
          a.INSTANCE_ID = @v_master_id AND 
          a.PLAN_ID = @v_plan_id            

    IF @@TRANCOUNT > 0
      COMMIT WORK 
    
  END TRY

  BEGIN CATCH
    --ROLLBACK
    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr
    commit;
  END CATCH

  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
