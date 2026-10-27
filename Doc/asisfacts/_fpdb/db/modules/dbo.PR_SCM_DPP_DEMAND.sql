CREATE PROCEDURE [dbo].[PR_SCM_DPP_DEMAND]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-',
   @p_amend_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_DPP_DEMAND                                                         **/
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
/** 2016.08.17    LJH          최초 작성                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_DPP_DEMAND
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_amend_plan_id  nvarchar(30)

  DECLARE @v_top_plan_id    nvarchar(30)
  DECLARE @v_plan_type      nvarchar(30)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime
  DECLARE @v_daydiff        Integer
  DECLARE @v_plan_date      DATE
  DECLARE @v_plan_week      nvarchar(30)

  DECLARE @v_prod_plan_id   nvarchar(30)
  DECLARE @v_ship_plan_id   nvarchar(30)
  DECLARE @v_srs_plan_id    nvarchar(30)


  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_DPP_DEMAND'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)

  DECLARE @v_start_week     nvarchar(6)
  DECLARE @v_end_week       nvarchar(6)
  DECLARE @v_confirm_week   int
  DECLARE @v_config_set_id  nvarchar(30)
  DECLARE @v_late_type      nvarchar(30)
  
  DECLARE @v_instance_type  nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()

  DECLARE @v_temp1        nvarchar(1000)
  DECLARE @v_temp2        nvarchar(1000)
  
  DECLARE @n_default_demand_lot_size  Integer = 1000
  
  SET @v_master_id      = @p_master_id
  SET @v_plan_id        = @p_plan_id
  SET @v_amend_plan_id  = @p_amend_plan_id
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    -- 필수 DATA 쿼리.. 반듯이 있어야 함.
    BEGIN

      SET @v_table_name = 'TH_MST_PLAN'
      SELECT  @plan_start_time = PLAN_START_DTTM,
              @plan_end_time   = PLAN_END_DTTM,
              @v_plan_type = PLAN_TYPE,
              @v_daydiff = DAYDIFF,
              @v_top_plan_id = TOP_PLAN_ID,
              @v_prod_plan_id = SCP_PRODUCT_PLAN_ID,
              @v_ship_plan_id = SCP_SHIPMENT_PLAN_ID,
              @v_srs_plan_id  = SCP_SRS_PLAN_ID,
              @v_plan_date = PLAN_DATE,
              @v_plan_week = PLAN_WEEK,
              @v_config_set_id = CONFIG_SET_ID
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN DEMAND_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, DEMAND_HORIZON,     PLAN_START_DTTM)
                          WHEN DEMAND_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, DEMAND_HORIZON * 7, PLAN_START_DTTM)
                          WHEN DEMAND_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, DEMAND_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM,
                     PLAN_TYPE,
                     DATEDIFF(MINUTE,CONVERT(DATE,PLAN_START_DTTM), PLAN_START_DTTM) AS DAYDIFF,
                     TOP_PLAN_ID,
                     SCP_PRODUCT_PLAN_ID,
                     SCP_SHIPMENT_PLAN_ID,
                     SCP_SRS_PLAN_ID,
                     CONVERT(DATE, PLAN_DATE) AS PLAN_DATE,
                     WEEK AS PLAN_WEEK,
                     CONFIG_SET_ID
              FROM   TH_MST_PLAN
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id
             ) A
             
      --LOG 생성
      SET @v_message  = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @v_message += ' / day minute : ' + CONVERT(nvarchar, @v_daydiff)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      
      SELECT @v_start_week = WEEK
      FROM   SY_SCM_SYS_CALENDAR_M
      WHERE  DATE_ID = CONVERT(DATE, @plan_start_time)

      SELECT @v_end_week = WEEK
      FROM   SY_SCM_SYS_CALENDAR_M
      WHERE  DATE_ID = CONVERT(DATE, @plan_end_time - 1)    -- 하루 뺀다.

      SET @v_message  = '@v_start_week : ' + CONVERT(nvarchar, @v_start_week, 112) + ' / @v_end_week : ' + CONVERT(nvarchar, @v_end_week, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null


      SELECT @v_confirm_week = isnull(convert(numeric, replace(replace(key_value, 'WEEK', ''), 'W', '')), 4)
      FROM   (SELECT MAX(key_value) AS key_value
              FROM   SY_FP_INSTANCE_CONFIG_M
              WHERE  INSTANCE_ID = 'COMMON'
              AND    CATEGORY_ID = 'DPP_CONFIG'
              AND    KEY_ID = 'CONFIRM_WEEK'
             ) A

      SET @v_message  = '@v_confirm_week : ' + convert(nvarchar, @v_confirm_week)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      SELECT @v_instance_type = MAX(A.INSTANCE_TYPE) 
      FROM   SY_FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
             SY_SCM_FACTORY_M B            -- FACTORY 별 SITE ID
      WHERE  A.INSTANCE_ID = @v_master_id
      AND    A.FACTORY_ID = B.FACTORY_ID
      
      SET @v_message  = '@v_instance_type : ' + @v_instance_type
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      /*--------------------------------------------------------------------------
       INSTANCE 별 DIVISION 별 DEMAND TARGET 이 다르다.
       아래의 쿼리는 DIVISION 별 TARGET 을 설정하는 부분이다.

        INSERT INTO SY_FP_INSTANCE_CONFIG_M
        SELECT DISTINCT INSTANCE_ID, 'DEMAND_TARGET' CATEGORY_ID, DIVISION_ID KEY_ID,
               CASE WHEN CHARINDEX('CELL', INSTANCE_ID) > 0 THEN 'PRODUCT'
                    WHEN CHARINDEX('SRS',  INSTANCE_ID) > 0 THEN 'SRS'
                    WHEN CHARINDEX('PACK', INSTANCE_ID) > 0 AND R = 1 THEN 'PRODUCT'
                    WHEN CHARINDEX('PACK', INSTANCE_ID) > 0 AND R = 2 THEN 'SHIPMENT'
                    WHEN DIVISION_ID LIKE '4_' AND R = 1 THEN 'SHIPMENT'
                    WHEN DIVISION_ID LIKE '4_' AND R = 2 THEN 'SHIPMENT_ELEC'
                    WHEN DIVISION_ID LIKE '8_' AND R = 1 THEN 'SHIPMENT'
                    WHEN DIVISION_ID LIKE '8_' AND R = 2 THEN 'DAILY_PLAN'
               END  KEY_VALUE,
               NULL KEY_PRIORITY,
               'N' VIEW_FLAG,
               'KEY_ID is DIVISION_ID',
               'SYSTEM' INSERT_ID,
               GETDATE() INSERT_TIME,
               'SYSTEM' UPDATE_ID,
               GETDATE() UPDATE_TIME       
        FROM   SY_FP_INSTANCE_FACTORY_M A,
               SY_SCM_FACTORY_M B,
               (SELECT 1 R UNION SELECT 2 R) C
        WHERE  A.FACTORY_ID = B.FACTORY_ID       
       
      
      --------------------------------------------------------------------------*/
    END;
    
    IF @v_plan_type <> 'PRE'
    
      BEGIN

        SET @v_message  = 'NOT PRE PLAN - @v_plan_type : ' + @v_plan_type
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
        
      END
      
    ELSE
    
      BEGIN

        BEGIN
        
          DELETE FROM TH_MST_SCM_INSTANCE_DEMAND_MAP
          WHERE  INSTANCE_ID = @v_master_id
          AND    DPP_PLAN_ID = @v_plan_id
          
          
          -- PRE MIX 의 경우 DPP 차감 하고 난 후에 LOT SIZE 를 설정한 후 우선순위를 반영해야 한다.
          -- 미친다. ㅋㅋㅋㅋㅋ
          IF CHARINDEX('E_PMIX', @v_master_id) > 0
            BEGIN
          
              SET @v_table_name = 'TH_BUF_SCM_DEMAND'
              SET @n_row_count = 0
              
              DELETE FROM TH_BUF_SCM_DEMAND

              INSERT INTO TH_BUF_SCM_DEMAND
                  (
                     COMPANY_ID
                   , DIVISION_ID
                   , SITE_ID
                   , PLANT_ID
                   , SHOP_GROUP_ID
                   , DPP_PLAN_ID
                   , FP_DEMAND_ID
                   , SCP_PLAN_ID
                   , SCP_TARGET_ID
                   , ITEM_ID
                   , SCP_QTY
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
                   , LINE_ID
                   , MARKET
                   , PRIORITY
                   , OFFSET_INVENTORY_QTY
                   , OFFSET_GI_QTY
                   , OFFSET_FIX_QTY
                   , CONFIRM_TYPE
                   , DEMAND_TYPE
                   , TARGET_TYPE
                   , INSERT_ID
                   , INSERT_TIME
                   , UPDATE_ID
                   , UPDATE_TIME
                  )
              
              SELECT
                     A.COMPANY_ID
                   , A.DIVISION_ID
                   , A.SITE_ID
                   , CASE WHEN A.SITE_ID = 'A001' THEN 'A011'
                          ELSE ISNULL(B.PLANT_ID, A.PLANT_ID) 
                     END  AS PLANT_ID
                   , A.SHOP_GROUP_ID
                   , A.DPP_PLAN_ID
                   , A.FP_DEMAND_ID
                   , A.SCP_PLAN_ID
                   , A.SCP_TARGET_ID
                   , A.ITEM_ID
                   , A.MFG_QTY            AS SCP_QTY
                   , A.MFG_WEEK
                   , A.MFG_QTY
                   , A.WORK_ORDER_ID
                   , A.DUE_DATE
                   , A.DUE_FENCE_DATE
                   , A.PRECEDE_PRODUCING_TERM
                   , A.PRECEDE_PRODUCING_TERM_UOM
                   , A.PRODUCTION_TYPE
                   , A.TO_SITE_ID
                   , A.TO_PLANT_ID
                   , A.TO_FACTORY_ID
                   , A.LINE_ID
                   , A.MARKET
                   , A.PRIORITY
                   , 0                  AS OFFSET_INVENTORY_QTY
                   , 0                  AS OFFSET_GI_QTY
                   , 0                  AS OFFSET_FIX_QTY
                   , A.CONFIRM_TYPE
                   , A.DEMAND_TYPE
                   , A.TARGET_TYPE
                   , A.INSERT_ID
                   , A.INSERT_TIME
                   , A.UPDATE_ID
                   , A.UPDATE_TIME
              FROM   TH_MST_SCM_DEMAND A
                     LEFT OUTER JOIN SY_SCM_FACTORY_M B
                          ON  A.TO_FACTORY_ID = B.FACTORY_ID
              WHERE  DPP_PLAN_ID = @v_plan_id

              SET @n_row_count = @@ROWCOUNT
              
              --LOG 생성
              SET @v_message = @n_row_count
              SET @n_log_count = @n_log_count + 1
              SET @sysdate = GETDATE()
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          

            END
          
          ELSE
            -- PMIX 를 제외한 인스턴스는 MAP 을 먼저 만들고 DPP 수행한다.
            BEGIN
            
              SET @v_table_name = 'TH_MST_SCM_INSTANCE_DEMAND_MAP'
              SET @n_row_count = 0
              
              INSERT INTO TH_MST_SCM_INSTANCE_DEMAND_MAP
                   (
                     COMPANY_ID
                   , DIVISION_ID
                   , SITE_ID
                   , PLANT_ID
                   , SHOP_GROUP_ID
                   , INSTANCE_ID
                   , DPP_PLAN_ID
                   , SCP_PLAN_ID
                   , FP_DEMAND_ID
                   , ITEM_ID
                   , MFG_WEEK
                   , MFG_QTY
                   , SCP_TARGET_ID
                   , SPLIT_QTY
                   , DUE_DATE
                   , DUE_FENCE_DATE
                   , PRECEDE_PRODUCING_TERM
                   , PRECEDE_PRODUCING_TERM_UOM
                   , PRODUCTION_TYPE
                   , TO_SITE_ID
                   , TO_PLANT_ID
                   , TO_FACTORY_ID
                   , LINE_ID
                   , MARKET
                   , PRIORITY
                   , CONFIRM_TYPE
                   , DEMAND_TYPE
                   , TARGET_TYPE
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
                   , DPP_PLAN_ID
                   , SCP_PLAN_ID
                   , MIN(FP_DEMAND_ID)  OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID,
                                                           DPP_PLAN_ID, SCP_PLAN_ID,
                                                           ITEM_ID, MFG_WEEK, DUE_DATE, WORK_ORDER_ID, 
                                                           PRODUCTION_TYPE, MARKET, CONFIRM_TYPE, DEMAND_TYPE, TARGET_TYPE) 
                                      AS FP_DEMAND_ID
                   , ITEM_ID
                   , MFG_WEEK
                   , MFG_QTY
                   , MIN(SCP_TARGET_ID) OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID,
                                                           DPP_PLAN_ID, SCP_PLAN_ID,
                                                           ITEM_ID, MFG_WEEK, DUE_DATE, WORK_ORDER_ID, 
                                                           PRODUCTION_TYPE, MARKET, CONFIRM_TYPE, DEMAND_TYPE, TARGET_TYPE) 
                                      AS SCP_TARGET_ID
                   , MFG_QTY          AS SPLIT_QTY
                   , DUE_DATE
                   , DUE_FENCE_DATE
                   , PRECEDE_PRODUCING_TERM
                   , PRECEDE_PRODUCING_TERM_UOM
                   , PRODUCTION_TYPE
                   , TO_SITE_ID
                   , TO_PLANT_ID
                   , TO_FACTORY_ID
                   , LINE_ID
                   , MARKET
                   , PRIORITY
                   , CONFIRM_TYPE
                   , DEMAND_TYPE
                   , TARGET_TYPE
                   , KEY_DATE
                   , INSERT_ID
                   , INSERT_TIME
                   , UPDATE_ID
                   , UPDATE_TIME
              FROM   TH_MST_SCM_DEMAND
              WHERE  DPP_PLAN_ID = @v_plan_id
              AND    TARGET_TYPE != 'TEST'

              INSERT INTO TH_MST_SCM_INSTANCE_DEMAND_MAP
                   (
                     COMPANY_ID
                   , DIVISION_ID
                   , SITE_ID
                   , PLANT_ID
                   , SHOP_GROUP_ID
                   , INSTANCE_ID
                   , DPP_PLAN_ID
                   , SCP_PLAN_ID
                   , FP_DEMAND_ID
                   , ITEM_ID
                   , MFG_WEEK
                   , MFG_QTY
                   , SCP_TARGET_ID
                   , SPLIT_QTY
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
                   , CONFIRM_TYPE
                   , DEMAND_TYPE
                   , TARGET_TYPE
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
                   , DPP_PLAN_ID
                   , SCP_PLAN_ID
                   , FP_DEMAND_ID
                   , ITEM_ID
                   , MFG_WEEK
                   , MFG_QTY
                   , SCP_TARGET_ID
                   , MFG_QTY          AS SPLIT_QTY
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
                   , CONFIRM_TYPE
                   , DEMAND_TYPE
                   , TARGET_TYPE
                   , KEY_DATE
                   , INSERT_ID
                   , INSERT_TIME
                   , UPDATE_ID
                   , UPDATE_TIME
              FROM   TH_MST_SCM_DEMAND
              WHERE  DPP_PLAN_ID = @v_plan_id
              AND    TARGET_TYPE = 'TEST'

              SET @n_row_count = @@ROWCOUNT
              
              --LOG 생성
              SET @v_message = @n_row_count
              SET @n_log_count = @n_log_count + 1
              SET @sysdate = GETDATE()
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

              
              SET @n_row_count = @@ROWCOUNT
              
              --LOG 생성
              SET @v_message = @n_row_count
              SET @n_log_count = @n_log_count + 1
              SET @sysdate = GETDATE()
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

              -- TARGET 대상 추출하는 부분은 PR_SCM_IF_PREPROCESS 에서 처리하도록 이관함.
              SET @v_table_name = 'TH_BUF_SCM_DEMAND'
              SET @n_row_count = 0
              
              DELETE FROM TH_BUF_SCM_DEMAND

              INSERT INTO TH_BUF_SCM_DEMAND
                  (
                     COMPANY_ID
                   , DIVISION_ID
                   , SITE_ID
                   , PLANT_ID
                   , SHOP_GROUP_ID
                   , DPP_PLAN_ID
                   , FP_DEMAND_ID
                   , SCP_PLAN_ID
                   , SCP_TARGET_ID
                   , ITEM_ID
                   , SCP_QTY
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
                   , DPP_PLAN_ID
                   , FP_DEMAND_ID
                   , SCP_PLAN_ID
                   , SCP_TARGET_ID
                   , ITEM_ID
                   , SUM(SPLIT_QTY)                   AS SCP_QTY
                   , MIN(MFG_WEEK)                    AS MFG_WEEK
                   , SUM(SPLIT_QTY)                   AS MFG_QTY
                   , NULL                             AS WORK_ORDER_ID
                   , MIN(DUE_DATE)                    AS DUE_DATE
                   , MAX(DUE_FENCE_DATE)              AS DUE_FENCE_DATE
                   , MAX(PRECEDE_PRODUCING_TERM)      AS PRECEDE_PRODUCING_TERM
                   , MAX(PRECEDE_PRODUCING_TERM_UOM)  AS PRECEDE_PRODUCING_TERM_UOM
                   , MAX(PRODUCTION_TYPE)             AS PRODUCTION_TYPE              -- ## PRODUCTION_TYPE 유지
                   , MAX(TO_SITE_ID)                  AS TO_SITE_ID
                   , MAX(TO_PLANT_ID)                 AS TO_PLANT_ID
                   , MAX(TO_FACTORY_ID)               AS TO_FACTORY_ID
                   , MAX(OPERATION_ID)                AS OPERATION_ID
                   , MIN(LINE_ID)                     AS LINE_ID
                   , MAX(MARKET)                      AS MARKET
                   , MIN(PRIORITY)                    AS PRIORITY
                   , 0 OFFSET_INVENTORY_QTY
                   , 0 OFFSET_GI_QTY
                   , 0 OFFSET_FIX_QTY
                   , MIN(CONFIRM_TYPE)                AS DEMAND_TYPE
                   , MIN(DEMAND_TYPE)                 AS DEMAND_TYPE
                   , MIN(TARGET_TYPE)                 AS TARGET_TYPE
                   , @v_proc_name AS INSERT_ID
                   , GETDATE()    AS INSERT_TIME
                   , @v_proc_name AS UPDATE_ID
                   , GETDATE()    AS UPDATE_TIME
              FROM   TH_MST_SCM_INSTANCE_DEMAND_MAP
              WHERE  DPP_PLAN_ID = @v_plan_id
              GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID,
                        DPP_PLAN_ID, SCP_PLAN_ID, FP_DEMAND_ID, SCP_TARGET_ID,
                        ITEM_ID

              SET @n_row_count = @@ROWCOUNT
              
              --LOG 생성
              SET @v_message = @n_row_count
              SET @n_log_count = @n_log_count + 1
              SET @sysdate = GETDATE()
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

            END
        END
        
        --EXECUTE PR_SCM_DPP_OFFSET   @v_master_id,@v_plan_id ;
        
        EXECUTE PR_SCM_DPP_FIX        @v_master_id,@v_plan_id ;
          

        IF CHARINDEX('E_PMIX', @v_master_id) > 0
          BEGIN
          
            INSERT INTO TH_MST_SCM_INSTANCE_DEMAND_MAP
                 (
                   COMPANY_ID
                 , DIVISION_ID
                 , SITE_ID
                 , PLANT_ID
                 , SHOP_GROUP_ID
                 , INSTANCE_ID
                 , DPP_PLAN_ID
                 , SCP_PLAN_ID
                 , FP_DEMAND_ID
                 , ITEM_ID
                 , MFG_WEEK
                 , MFG_QTY
                 , SCP_TARGET_ID
                 , SPLIT_QTY
                 , DUE_DATE
                 , DUE_FENCE_DATE
                 , PRECEDE_PRODUCING_TERM
                 , PRECEDE_PRODUCING_TERM_UOM
                 , PRODUCTION_TYPE
                 , TO_SITE_ID
                 , TO_PLANT_ID
                 , TO_FACTORY_ID
                 , LINE_ID
                 , MARKET
                 , PRIORITY
                 , CONFIRM_TYPE
                 , DEMAND_TYPE
                 , TARGET_TYPE
                 , KEY_DATE
                 , INSERT_ID
                 , INSERT_TIME
                 , UPDATE_ID
                 , UPDATE_TIME                   
                 )
            SELECT A.IRS_ATTB_11    AS COMPANY_ID
                 , A.IRS_ATTB_12    AS DIVISION_ID
                 , A.IRS_ATTB_13    AS SITE_ID
                 , A.IRS_ATTB_14    AS PLANT_ID
                 , A.SHOP_GROUP_ID
                 , @v_master_id     AS INSTANCE_ID
                 , A.DPP_PLAN_ID
                 , A.SCP_PLAN_ID
                 , A.FP_DEMAND_ID
                 , A.ITEM_ID
                 , A.MFG_WEEK
                 , A.MFG_QTY
                 , A.MIN_SCP_TARGET_ID 
                      + '##' + A.ITEM_ID 
                      + '##' + A.TO_FACTORY_ID 
                      + '##' + CASE WHEN A.TARGET_SEQ < 10 THEN '000'
                                    WHEN A.TARGET_SEQ < 100 THEN '00'
                                    WHEN A.TARGET_SEQ < 1000 THEN '0'
                                    ELSE ''
                               END
                      + CONVERT(NVARCHAR, A.TARGET_SEQ)
                   AS SCP_TARGET_ID
                 --, A.SPLIT_QTY              -- 맨 마지막 수량을 그대로 둔다
                 , A.NEW_SPLIT_QTY          -- 맨 마지막 수량을 증가시켜 무조건 1000 단위를 맞춘다
                 , A.DUE_DATE
                 , A.DUE_FENCE_DATE
                 , A.PRECEDE_PRODUCING_TERM
                 , A.PRECEDE_PRODUCING_TERM_UOM
                 , 'MASS'           AS PRODUCTION_TYPE    -- 개발이든 샘플이든 양산이든 관계없이 수량으로 맞추어야 하므로,,,
                 , A.TO_SITE_ID
                 , A.TO_PLANT_ID
                 , A.TO_FACTORY_ID
                 , A.LINE_ID
                 , A.MARKET
                 , A.PRIORITY
                 , 'CONFIRM'        AS CONFIRM_TYPE       -- LOT 을 맞추기 위해 구분짓지 않는다
                 , A.DEMAND_TYPE
                 , A.TARGET_TYPE
                 , CONVERT(NVARCHAR, @v_plan_date, 112)     AS KEY_DATE
                 , @v_proc_name     AS INSERT_ID
                 , GETDATE()        AS INSERT_TIME
                 , @v_proc_name     AS UPDATE_ID
                 , GETDATE()        AS UPDATE_TIME
            FROM   (-- TARGET GROUP 에 MIN DUE_DATE 를 설정한다.
                    SELECT A.*,
                           -- 1000 단위 맞추고 나서, 맨 마지막 수량에 대해 1000 단위로 맞춘다.
                           CASE WHEN NEW_SEQ = NEW_CNT THEN SPLIT_QTY + ( 1000 - (SUM_SPLIT_QTY % 1000))
                                ELSE SPLIT_QTY
                           END  NEW_SPLIT_QTY,
                           MIN(SCP_TARGET_ID) OVER (PARTITION BY ITEM_ID, TO_FACTORY_ID /*, MARKET*/, TARGET_SEQ) AS MIN_SCP_TARGET_ID,
                           MIN(DUE_DATE)      OVER (PARTITION BY ITEM_ID, TO_FACTORY_ID /*, MARKET*/, TARGET_SEQ) AS MIN_DUE_DATE
                    FROM   (-- 1000 단위 GROUPPING 한 것을 TARGET GROUP 으로 사용한다.
                            SELECT A.*,
                                   CEILING( SUM_SPLIT_QTY / 1000) AS TARGET_SEQ
                            FROM   (-- 실제 1000 단위로 걸쳐져 있는 것에 대한 수량을 SPLIT 했기 때문에 1000 단위로 GROUPPING 한다
                                    SELECT A.*,
                                           SUM(SPLIT_QTY) OVER (PARTITION BY ITEM_ID, TO_FACTORY_ID /*, MARKET*/ ORDER BY SEQ, INT) AS SUM_SPLIT_QTY
                                    FROM   (--  0 < x < 3000 사이에 있다면 1000, 2000, 이 끼어 있으므로 가운데 걸린 애들을 처리한다.   
                                            SELECT A.*,
                                                   CASE WHEN SPLIT_CNT = 1 THEN REMAIN_QTY
                                                        WHEN SPLIT_CNT > 1 AND INT = 1 THEN 1000 - (START_QTY % 1000)
                                                        WHEN SPLIT_CNT > 1 AND INT = SPLIT_CNT THEN  (END_QTY % 1000)
                                                        ELSE 1000
                                                   END  SPLIT_QTY,
                                                   DENSE_RANK() OVER (PARTITION BY A.ITEM_ID, A.TO_FACTORY_ID /*, A.MARKET*/
                                                                      ORDER     BY SEQ, INT)  AS NEW_SEQ,
                                                   COUNT(1)     OVER (PARTITION BY A.ITEM_ID, A.TO_FACTORY_ID /*, A.MARKET*/) AS NEW_CNT
                                            FROM   (-- 1000 단위 사이에 끼어 있는 것에 대한 갯수를 구한다.
                                                    SELECT A.*, INT,
                                                           MAX(INT) OVER (PARTITION BY SCP_TARGET_ID) AS SPLIT_CNT
                                                    FROM   (-- 1000 단위로 구간을 설정한다. 
                                                            -- 1000 사이에 끼어 있으면 START_GROUP 과 END_GROUP 이 다르다.
                                                            SELECT A.*,
                                                                   (SUM_QTY - REMAIN_QTY) AS START_QTY,
                                                                   SUM_QTY END_QTY,
                                                                   CEILING( (SUM_QTY - REMAIN_QTY + 1) / 1000) AS START_GROUP,
                                                                   CEILING(SUM_QTY / 1000) AS END_GROUP,
                                                                   (SUM_QTY % 1000) AS MOD
                                                            FROM   (-- ITEM 별 SUM 을 구한다.
                                                                    SELECT A.*, B.IRS_ATTB_11,B.IRS_ATTB_12,B.IRS_ATTB_13,B.IRS_ATTB_14,
                                                                           DENSE_RANK() OVER (PARTITION BY A.ITEM_ID, A.TO_FACTORY_ID /*, A.MARKET*/
                                                                                              ORDER     BY A.DUE_DATE, A.SCP_TARGET_ID) AS SEQ,
                                                                           SUM(REMAIN_QTY) OVER (PARTITION BY A.ITEM_ID, A.TO_FACTORY_ID /*, A.MARKET*/
                                                                                              ORDER     BY A.DUE_DATE, A.SCP_TARGET_ID) AS SUM_QTY
                                                                    FROM   (SELECT A.*,
                                                                                   CEILING(MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) AS REMAIN_QTY
                                                                            FROM   TH_BUF_SCM_DEMAND A
                                                                            WHERE  A.DPP_PLAN_ID = @v_plan_id
                                                                            AND    A.DEMAND_TYPE != 'FIX'
                                                                            --AND    CEILING(MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > 0
                                                                           ) A,
                                                                           (
                                                                            SELECT ITEM_ID, 
                                                                                   MIN(IRS_ATTB_11) AS IRS_ATTB_11,
                                                                                   MIN(IRS_ATTB_12) AS IRS_ATTB_12,
                                                                                   MIN(IRS_ATTB_13) AS IRS_ATTB_13,
                                                                                   MIN(IRS_ATTB_14) AS IRS_ATTB_14
                                                                            FROM   TH_MST_ITEM_ROUTE_SITE
                                                                            WHERE  MASTER_ID  = @v_master_id
                                                                            AND    PLAN_ID    = @v_plan_id
                                                                            GROUP  BY ITEM_ID
                                                                           ) B
                                                                    WHERE  1=1
                                                                    AND    A.ITEM_ID = B.ITEM_ID
                                                                   ) A
                                                           ) A,
                                                           COPYT B
                                                    WHERE  B.INT <= ( END_GROUP - START_GROUP + 1)
                                                   ) A
                                           ) A
                                   ) A
                           ) A
                   ) A
            
            SET @n_row_count = @@ROWCOUNT
            
            --LOG 생성
            SET @v_message = @n_row_count
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

            -- FIX 된 계획은 수량 MERGE 에서 제외하고,, 나머지는 다시 넣는다.

            UPDATE TH_BUF_SCM_DEMAND
            SET    FP_DEMAND_ID = FP_DEMAND_ID + '::O'
                 , MFG_QTY = ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
            WHERE  DPP_PLAN_ID = @v_plan_id
            AND    DEMAND_TYPE != 'FIX'
            AND    CEILING(MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > 0   -- 다 차감되지 않고
            AND    CEILING(( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > 0

            DELETE FROM TH_BUF_SCM_DEMAND
            WHERE  DPP_PLAN_ID = @v_plan_id
            AND    DEMAND_TYPE != 'FIX'
            AND    CEILING(MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > 0
            
            INSERT INTO TH_BUF_SCM_DEMAND
                (
                   COMPANY_ID
                 , DIVISION_ID
                 , SITE_ID
                 , PLANT_ID
                 , SHOP_GROUP_ID
                 , DPP_PLAN_ID
                 , FP_DEMAND_ID
                 , SCP_PLAN_ID
                 , SCP_TARGET_ID
                 , ITEM_ID
                 , SCP_QTY
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
                 , LINE_ID
                 , MARKET
                 , PRIORITY
                 , OFFSET_INVENTORY_QTY
                 , OFFSET_GI_QTY
                 , OFFSET_FIX_QTY
                 , CONFIRM_TYPE
                 , DEMAND_TYPE
                 , TARGET_TYPE
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
                 , DPP_PLAN_ID
                 , SCP_TARGET_ID AS FP_DEMAND_ID
                 , SCP_PLAN_ID
                 , SCP_TARGET_ID AS SCP_TARGET_ID
                 , ITEM_ID
                 , SUM(SPLIT_QTY)                   AS SCP_QTY
                 , MIN(MFG_WEEK)                    AS MFG_WEEK
                 , SUM(SPLIT_QTY)                   AS MFG_QTY
                 , NULL                             AS WORK_ORDER_ID
                 , MIN(DUE_DATE)                    AS DUE_DATE
                 , MAX(DUE_FENCE_DATE)              AS DUE_FENCE_DATE
                 , MAX(PRECEDE_PRODUCING_TERM)      AS PRECEDE_PRODUCING_TERM
                 , MAX(PRECEDE_PRODUCING_TERM_UOM)  AS PRECEDE_PRODUCING_TERM_UOM
                 , 'MASS'                           AS PRODUCTION_TYPE
                 , MAX(TO_SITE_ID)                  AS TO_SITE_ID
                 , MAX(TO_PLANT_ID)                 AS TO_PLANT_ID
                 , ISNULL(TO_FACTORY_ID, '-')       AS TO_FACTORY_ID
                 , MIN(LINE_ID)                     AS LINE_ID
                 , MAX(MARKET)                      AS MARKET
                 , MIN(PRIORITY)                    AS PRIORITY
                 , 0 OFFSET_INVENTORY_QTY
                 , 0 OFFSET_GI_QTY
                 , 0 OFFSET_FIX_QTY
                 , MIN(CONFIRM_TYPE)                AS DEMAND_TYPE
                 , MIN(DEMAND_TYPE)                 AS DEMAND_TYPE
                 , MIN(TARGET_TYPE)                 AS TARGET_TYPE
                 , @v_proc_name AS INSERT_ID
                 , GETDATE()    AS INSERT_TIME
                 , @v_proc_name AS UPDATE_ID
                 , GETDATE()    AS UPDATE_TIME
            FROM   TH_MST_SCM_INSTANCE_DEMAND_MAP
            WHERE  DPP_PLAN_ID = @v_plan_id
            GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID,
                      DPP_PLAN_ID, SCP_PLAN_ID, SCP_TARGET_ID, ISNULL(TO_FACTORY_ID, '-'),
                      ITEM_ID
                      
          END

        EXECUTE PR_SCM_DPP_PRIORITY @v_master_id,@v_plan_id ;
        
          BEGIN
          
            UPDATE TH_MST_SCM_DEMAND
            SET    TH_MST_SCM_DEMAND.PRIORITY = B.PRIORITY
            FROM   TH_MST_SCM_DEMAND A,
                   TH_BUF_SCM_DEMAND B
            WHERE  A.DPP_PLAN_ID = @v_plan_id
            AND    A.DPP_PLAN_ID = B.DPP_PLAN_ID
            AND    A.SCP_TARGET_ID = B.SCP_TARGET_ID
          
          END


        -- DEMAND LOT 을 설정하는 부분
        EXECUTE PR_SCM_DPP_DEMAND_LOT @v_master_id,@v_plan_id ;

        ------------------------------------------------------------------------------------------------------------------

        BEGIN
        
          SET @v_table_name = 'TH_BUF_SCM_DEMAND_SPLIT'
          SET @n_row_count = 0

          DELETE TH_BUF_SCM_DEMAND_SPLIT
          WHERE  KEY_DATE <= DATEADD(DAY, -14, @v_plan_date)

          DELETE FROM TH_BUF_SCM_DEMAND_SPLIT
          WHERE  DPP_PLAN_ID = @v_plan_id

          SET @n_row_count = @@ROWCOUNT
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
                  

          SET @v_table_name = 'TH_BUF_SCM_DEMAND_SPLIT'

          INSERT INTO TH_BUF_SCM_DEMAND_SPLIT
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
                 , KEY_DATE
                )
          
          SELECT
                   COMPANY_ID
                 , DIVISION_ID
                 , SITE_ID
                 , PLANT_ID
                 , SHOP_GROUP_ID
                 , @v_master_id AS INSTANCE_ID
                 , DPP_PLAN_ID
                 , FP_DEMAND_ID + '::' + SET_TYPE + convert(nvarchar, split_no) AS FP_DEMAND_ID
                 , SCP_PLAN_ID
                 , SCP_TARGET_ID
                 , ITEM_ID
                 , MFG_WEEK
                 , SPLIT_QTY AS MFG_QTY
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
                 , PRIORITY + '::' + convert(nvarchar, SPLIT_NO) AS PRIORITY
                 , OFFSET_INVENTORY_QTY + OFFSET_GI_QTY AS OFFSET_QTY
                 --, OFFSET_FIX_QTY
                 , CONFIRM_TYPE
                 , DEMAND_TYPE
                 , DEMAND_LOT_SIZE
                 , @v_plan_date AS KEY_DATE
          FROM   (
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, 
                         A.DPP_PLAN_ID, 
                         /*
                         A.SHOP_GROUP_ID +'^'+A.PLANT_ID
                                         +'^'+CONVERT(NVARCHAR, A.DUE_DATE,112)
                                         +'^'+A.ITEM_ID
                                         +'^'+ISNULL(A.MARKET, 'X')
                            AS FP_DEMAND_ID, 
                         */
                         A.FP_DEMAND_ID, 
                         A.SCP_PLAN_ID, A.SCP_TARGET_ID, 
                         A.ITEM_ID, A.MFG_WEEK, A.MFG_QTY AS SCP_QTY, A.WORK_ORDER_ID, A.DUE_DATE, A.DUE_FENCE_DATE,
                         A.PRECEDE_PRODUCING_TERM, A.PRECEDE_PRODUCING_TERM_UOM, A.PRODUCTION_TYPE, 
                         A.TO_SITE_ID, A.TO_PLANT_ID, A.LINE_ID, A.MARKET, A.PRIORITY, A.CONFIRM_TYPE,
                         CASE WHEN INT = 1                                                  THEN 0
                              WHEN DEMAND_LOT_SIZE = 0                                      THEN DEMAND_LOT_SIZE
                              WHEN SPLIT_CNT = INT AND ( REMAIN_QTY % DEMAND_LOT_SIZE ) = 0 THEN DEMAND_LOT_SIZE
                              WHEN SPLIT_CNT = INT AND ( REMAIN_QTY % DEMAND_LOT_SIZE ) > 0 THEN ( REMAIN_QTY % DEMAND_LOT_SIZE )
                              ELSE DEMAND_LOT_SIZE
                         END  SPLIT_QTY,
                         CASE WHEN INT = 1 THEN 'OFFSET'             ELSE DEMAND_TYPE END SET_TYPE,
                         CASE WHEN INT = 1 THEN OFFSET_INVENTORY_QTY ELSE 0 END OFFSET_INVENTORY_QTY,
                         CASE WHEN INT = 1 THEN OFFSET_GI_QTY        ELSE 0 END OFFSET_GI_QTY,
                         DEMAND_TYPE,
                         DEMAND_LOT_SIZE,
                         --DBO.FN_LPAD_NVARCHAR(ISNULL(int-1, 9999), 6, '0') AS SPLIT_NO    -- 속도가 늦어서리....
                         CASE WHEN ISNULL(int-1, 9999) < 10 THEN '00000' + CONVERT(NVARCHAR, ISNULL(int-1, 9999))
                              WHEN ISNULL(int-1, 9999) < 100 THEN '0000' + CONVERT(NVARCHAR, ISNULL(int-1, 9999))
                              WHEN ISNULL(int-1, 9999) < 1000 THEN '000' + CONVERT(NVARCHAR, ISNULL(int-1, 9999))
                              WHEN ISNULL(int-1, 9999) < 10000 THEN '00' + CONVERT(NVARCHAR, ISNULL(int-1, 9999))
                              WHEN ISNULL(int-1, 9999) < 100000 THEN '0' + CONVERT(NVARCHAR, ISNULL(int-1, 9999))
                                                                 ELSE '' + CONVERT(NVARCHAR, ISNULL(int-1, 9999))
                         END  AS SPLIT_NO
                  FROM   (
                          SELECT A.*,
                                 CASE WHEN DEMAND_LOT_SIZE = 0 THEN 2
                                      ELSE CEILING ( REMAIN_QTY / DEMAND_LOT_SIZE ) + 1 
                                 END  AS SPLIT_CNT  
                          FROM   (
                                  SELECT A.*,
                                         CEILING(MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) AS REMAIN_QTY,
                                         CASE WHEN ISNULL(B.APPLY_LOT_SIZE,0) > 0 THEN B.APPLY_LOT_SIZE 
                                              ELSE CEILING(A.MFG_QTY)
                                         END  DEMAND_LOT_SIZE
                                  FROM   TH_BUF_SCM_DEMAND A
                                         LEFT OUTER JOIN (
                                                          SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SALES_MODEL_ID,
                                                                 MAX(APPLY_LOT_SIZE) AS APPLY_LOT_SIZE
                                                          FROM   TH_MST_SCM_DEMAND_LOT
                                                          WHERE  DPP_PLAN_ID    = @v_plan_id
                                                          GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SALES_MODEL_ID
                                                         )  B
                                               ON   A.COMPANY_ID = B.COMPANY_ID
                                               AND  A.DIVISION_ID = B.DIVISION_ID
                                               AND  A.SITE_ID = B.SITE_ID
                                               AND  A.PLANT_ID = B.PLANT_ID
                                               AND  A.ITEM_ID = B.SALES_MODEL_ID
                                  WHERE  A.DPP_PLAN_ID = @v_plan_id
                                  AND    A.DEMAND_TYPE NOT IN ('FIX','ACO','NCP')
                                  AND    ISNULL(A.WORK_ORDER_ID, '') = ''
                                 ) A
                          --WHERE  REMAIN_QTY > 0
                         ) A,
                         COPYT B
                  WHERE  SPLIT_CNT >= INT          
                 ) A
          WHERE  SPLIT_QTY + OFFSET_INVENTORY_QTY + OFFSET_GI_QTY > 0


          SET @n_row_count = @@ROWCOUNT
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        
          INSERT INTO TH_BUF_SCM_DEMAND_SPLIT
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
               , KEY_DATE
              )
          SELECT
                 COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , SHOP_GROUP_ID
               , @v_master_id AS INSTANCE_ID
               , DPP_PLAN_ID
               , FP_DEMAND_ID
               , SCP_PLAN_ID
               , SCP_TARGET_ID
               , ITEM_ID
               , MFG_WEEK
               , OFFSET_FIX_QTY AS MFG_QTY
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
               , PRIORITY + '::' + '000' AS PRIORITY
               , OFFSET_INVENTORY_QTY + OFFSET_GI_QTY AS OFFSET_QTY
               --, OFFSET_FIX_QTY
               , CONFIRM_TYPE
               , DEMAND_TYPE
               --, DEMAND_TYPE
               , @v_plan_date AS KEY_DATE
          FROM   TH_BUF_SCM_DEMAND
          WHERE  DPP_PLAN_ID = @v_plan_id
          AND    DEMAND_TYPE IN ('FIX','ACO','NCP')
        
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END

        -- DEMAND LOT MERGE 부분
        /*
        BEGIN

          SET @v_table_name = 'TH_BUF_SCM_DEMAND_SPLIT - PLAN : MEEGE'

          UPDATE TH_BUF_SCM_DEMAND_SPLIT
          SET    TH_BUF_SCM_DEMAND_SPLIT.DEMAND_QTY = B.NEW_QTY
          FROM   TH_BUF_SCM_DEMAND_SPLIT A,
                 (
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
                                  SELECT FP_DEMAND_ID, ITEM_ID, MFG_WEEK, MFG_QTY, DEMAND_LOT_SIZE,CONFIRM_TYPE,
                                         SUM(MFG_QTY) OVER (PARTITION BY ITEM_ID, CONFIRM_TYPE) TOTAL_QTY,
                                         SUM(DEMAND_LOT_SIZE) OVER (PARTITION BY ITEM_ID, CONFIRM_TYPE ORDER BY MFG_WEEK, FP_DEMAND_ID) LOT_TOTAL_QTY
                                  FROM   TH_BUF_SCM_DEMAND_SPLIT A
                                  WHERE  A.DPP_PLAN_ID = @v_plan_id
                                  AND    A.CONFIRM_TYPE IN ('CONFIRM','UNCONFIRM')
                                  AND    A.DEMAND_TYPE NOT IN ('FIX','ACO','NCP')
                                 ) A
                         ) A
                 ) B
          WHERE  A.DPP_PLAN_ID = @v_plan_id
          AND    A.FP_DEMAND_ID = B.FP_DEMAND_ID        
          
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          SET @v_table_name = 'TH_BUF_SCM_DEMAND_SPLIT - FIX, ACO : MEEGE'

          UPDATE TH_BUF_SCM_DEMAND_SPLIT
          SET    TH_BUF_SCM_DEMAND_SPLIT.DEMAND_QTY = B.NEW_QTY
          FROM   TH_BUF_SCM_DEMAND_SPLIT A,
                 (
                  SELECT A.*,
                         CASE WHEN SEQ = 1 THEN TOTAL_QTY ELSE 0 END AS NEW_QTY
                  FROM   (
                          SELECT FP_DEMAND_ID, ITEM_ID, MFG_WEEK, MFG_QTY, DEMAND_LOT_SIZE,CONFIRM_TYPE,
                                 SUM(MFG_QTY) OVER (PARTITION BY WORK_ORDER_ID) TOTAL_QTY,
                                 DENSE_RANK() OVER (PARTITION BY WORK_ORDER_ID ORDER BY MFG_WEEK, FP_DEMAND_ID) SEQ,
                                 COUNT(1)     OVER (PARTITION BY WORK_ORDER_ID) CNT
                          FROM   TH_BUF_SCM_DEMAND_SPLIT A
                          WHERE  A.DPP_PLAN_ID    = @v_plan_id
                          AND    A.CONFIRM_TYPE   IN ('CONFIRM','UNCONFIRM')
                          AND    A.DEMAND_TYPE    IN ('FIX','ACO')
                          AND    A.WORK_ORDER_ID  IS NOT NULL
                         ) A
                  WHERE  CNT > 1
                 ) B
          WHERE  A.DPP_PLAN_ID = @v_plan_id
          AND    A.FP_DEMAND_ID = B.FP_DEMAND_ID 

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          DELETE FROM A
          FROM   TH_BUF_SCM_DEMAND_SPLIT A
          WHERE  A.DPP_PLAN_ID    = @v_plan_id
          AND    A.CONFIRM_TYPE   IN ('CONFIRM','UNCONFIRM')
          AND    A.DEMAND_TYPE    IN ('FIX','ACO')
          AND    A.WORK_ORDER_ID  IS NOT NULL
          AND    A.DEMAND_QTY     = 0

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        END
        */

        -- late type 에 따른 due_fence_date 설정하기
        -- DEFAULT 는 WEEK FENCE 임..
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
            
            UPDATE TH_BUF_SCM_DEMAND_SPLIT
            SET    TH_BUF_SCM_DEMAND_SPLIT.DUE_FENCE_DATE = B.DUE_FENCE_DATE
            FROM   TH_BUF_SCM_DEMAND_SPLIT A,
                   (
                    SELECT CONFIRM_TYPE, MAX(DUE_FENCE_DATE) AS DUE_FENCE_DATE
                    FROM   TH_BUF_SCM_DEMAND_SPLIT
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

        BEGIN

          SET @v_table_name = 'FP_DAILY_NET_DEMAND_H'
          SET @n_row_count = 0

          DELETE FROM SY_FP_DAILY_NET_DEMAND_H
          WHERE  DPP_PLAN_ID = @v_plan_id

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
               , CASE WHEN DEMAND_QTY IS NULL THEN MFG_QTY ELSE DEMAND_QTY END AS MFG_QTY
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
               , @v_proc_name AS INSERT_ID
               , GETDATE()    AS INSERT_TIME
               , @v_proc_name AS UPDATE_ID
               , GETDATE()    AS UPDATE_TIME                     
          FROM   TH_BUF_SCM_DEMAND_SPLIT
          WHERE  DPP_PLAN_ID = @v_plan_id
          
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = 'TARGET DEMAND : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          /*-- SUB DEMAND 생성하는 로직임.
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
               , IS_CONSUME
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
               , B.SHOP_GROUP_ID
               , A.INSTANCE_ID
               , A.FP_PLAN_ID     AS DPP_PLAN_ID
               , A.WORK_ORDER_ID  AS FP_DEMAND_ID
               , A.INSTANCE_ID    AS SCP_PLAN_ID
               , A.WORK_ORDER_ID  AS SCP_TARGET_ID
               , A.ITEM_ID
               , @v_plan_week     AS MFG_WEEK
               , A.QTY            AS MFG_QTY
               , A.QTY            AS SCP_QTY
               , A.WORK_ORDER_ID
               , CONVERT(DATE, PLAN_DATE) AS DUE_DATE
               , CONVERT(DATE, PLAN_DATE) AS DUE_FENCE_DATE
               , 1                AS PRECEDE_PRODUCING_TERM
               , 'DAY'            AS PRECEDE_PRODUCING_TERM_UOM
               , CASE WHEN A.PRODUCTION_TYPE IS NULL  THEN 'MASS'
                      WHEN A.PRODUCTION_TYPE = ''     THEN 'MASS'
                      ELSE A.PRODUCTION_TYPE
                 END  PRODUCTION_TYPE
               , NULL         AS TO_SITE_ID
               , NULL         AS TO_PLANT_ID
               , A.LINE_ID
               , NULL         AS MARKET
               , '0' + ':' + CONVERT(NVARCHAR,   10 + DENSE_RANK() OVER (ORDER BY OPERATION_ID)) 
                     + ':' + CONVERT(NVARCHAR, 1000 + DENSE_RANK() OVER (ORDER BY PLAN_DATE, SEQ, LINE_ID, EQUIPMENT_ID, WORK_ORDER_ID))
                     AS PRIORITY
               , 0            AS OFFSET_QTY
               , 'CONFIRM'    AS CONFIRM_TYPE
               , 'FIX'        AS DEMAND_TYPE
               , 'N'          AS IS_CONSUME
               , @v_proc_name AS INSERT_ID
               , GETDATE()    AS INSERT_TIME
               , @v_proc_name AS UPDATE_ID
               , GETDATE()    AS UPDATE_TIME                     
          FROM   TH_MST_SCM_ORDER_STATUS A,
                 SY_SCM_FACTORY_M B
          WHERE  A.INSTANCE_ID  = @v_master_id
          AND    A.FP_PLAN_ID   = @v_plan_id
          AND    A.TOP_OPERATION_ITEM_ID != 'TOP'
          AND    A.FACTORY_ID = B.FACTORY_ID

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = 'SUB WORK DEMAND : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          */
        END


        BEGIN
        
          SET @v_table_name = 'TH_DPP_DEMAND_ATTRIBUTE'
          
          DELETE FROM TH_DPP_DEMAND_ATTRIBUTE
          WHERE   MASTER_ID   = @v_master_id
          AND     PLAN_ID     = @p_plan_id

          INSERT INTO TH_DPP_DEMAND_ATTRIBUTE
                (
                  MASTER_ID
                , PLAN_ID
                , DEMAND_ID
                , PREFERENCE_SITE_ID
                , PREFERENCE_ROUTE_ID
                , PREFERENCE_OPERATION_ID
                , PREFERENCE_RESOURCE_ID
                , PREFERENCE_PRODUCT_ID
                , IS_HARD_PREFERENCE
                , KEY_DATE
                , INSERT_ID
                , INSERT_DTTM
                , UPDATE_ID
                , UPDATE_DTTM
                )            
          SELECT  A.INSTANCE_ID AS NMASTER_ID
                , A.FP_PLAN_ID  AS PLAN_ID
                , CASE WHEN B.FP_DEMAND_ID IS NULL THEN A.WORK_ORDER_ID 
                       ELSE B.FP_DEMAND_ID 
                  END  AS DEMAND_ID
                , A.FACTORY_ID    AS PREFERENCE_SITE_ID
                , A.LINE_ID       AS PREFERENCE_ROUTE_ID
                , A.OPERATION_ID  AS PREFERENCE_OPERATION_ID
                , A.EQUIPMENT_ID  AS PREFERENCE_RESOURCE_ID
                , A.ITEM_ID       AS PREFERENCE_PRODUCT_ID
                , 'Y'             AS IS_HARD_PREFERENCE
                , CONVERT(NVARCHAR, @v_plan_date, 112) AS KEY_DATE
                , @v_proc_name    AS INSERT_ID
                , GETDATE()       AS INSERT_DTTM
                , @v_proc_name    AS UPDATE_ID
                , getdate()       AS UPDATE_DTTM
          FROM    TH_MST_SCM_ORDER_STATUS A
                  LEFT OUTER JOIN TH_BUF_SCM_DEMAND_SPLIT B
                       ON    A.INSTANCE_ID = B.INSTANCE_ID
                       AND   A.FP_PLAN_ID   = B.DPP_PLAN_ID
                       AND   A.WORK_ORDER_ID  = B.WORK_ORDER_ID
          WHERE   A.INSTANCE_ID  = @v_master_id
          AND     A.FP_PLAN_ID    = @v_plan_id
          
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END
        
      END

    -- END IF

  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
