CREATE PROCEDURE [dbo].[PR_SCM_DPP_FIX]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_DPP_FIX                                                            **/
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
  EXEC PR_SCM_DPP_FIX
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id        nvarchar(30)
  DECLARE @v_plan_id          nvarchar(30)
  DECLARE @v_plan_type        nvarchar(30)
  DECLARE @plan_start_time    datetime
  DECLARE @plan_end_time      datetime
  DECLARE @plan_date          nvarchar(10)
  DECLARE @v_daydiff          Integer

  -- LOG 용 변수 설정
  DECLARE @v_proc_name        nvarchar(100) = 'PR_SCM_DPP_FIX'
  DECLARE @v_table_name       nvarchar(100)
  DECLARE @v_message          nvarchar(250)
  DECLARE @v_descr            nvarchar(250)
  DECLARE @n_row_count        Integer  = 0
  DECLARE @n_log_count        Integer  = 0
  DECLARE @v_log_code         nvarchar(10)
  
  DECLARE @sysdate            DATETIME2 = GETDATE()

  DECLARE @v_temp1            nvarchar(1000)
  DECLARE @v_temp2            nvarchar(1000)
  
  DECLARE @v_release_plan_id  nvarchar(30)
  DECLARE @v_fix_pegging_type nvarchar(30)

  -------------------------------------------------------------------------------------------
  -- LINE 인지 EQUIPMENT 인지 설정하는 변수... 아주 중요
  -------------------------------------------------------------------------------------------
   DECLARE @res_category      nvarchar(10)
  -------------------------------------------------------------------------------------------

  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id
  
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
              @plan_date = PLAN_DATE,
              @v_plan_type = PLAN_TYPE,
              @v_daydiff = DAYDIFF
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM,
                     PLAN_DATE,
                     PLAN_TYPE,
                     DATEDIFF(MINUTE,CONVERT(DATE,PLAN_START_DTTM), PLAN_START_DTTM) AS DAYDIFF
              FROM   TH_MST_PLAN
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id
             ) A
             
      --LOG 생성
      SET @v_message  = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      --LOG 생성
      SET @v_message  = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @v_message  = ' @plan_date : ' + @plan_date
      SET @v_message += ' / day minute : ' + CONVERT(nvarchar, @v_daydiff)
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

      
      SET @v_table_name = 'SCM_FP_PLAN_H'

      SELECT @v_release_plan_id = MIN(PLAN_ID)
      FROM   (
              SELECT MAX(CONVERT(NVARCHAR, PLAN_START_TIME, 112)) AS PLAN_DATE
              FROM   SY_SCM_FP_PLAN_H
              WHERE  INSTANCE_ID = @v_master_id
              AND    PLAN_TYPE = 'RELEASE'
              AND    PLAN_START_TIME < @plan_start_time     -- 오늘 일자 이전의 최종 확정 PLAN 정보 설정..
             ) A,
             SY_SCM_FP_PLAN_H B
      WHERE  B.INSTANCE_ID = @v_master_id
      AND    B.PLAN_TYPE = 'RELEASE'
      AND    A.PLAN_DATE = CONVERT(NVARCHAR, B.PLAN_START_TIME, 112)

      --LOG 생성
      SET @v_message = '@v_release_plan_id : ' + @v_release_plan_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      

      SELECT @v_fix_pegging_type = CASE WHEN ISNULL(MAX(VALUE_TYPE), 'H') = 'H' THEN 'HARD' 
                                        ELSE 'SOFT' 
                                   END
      FROM   SY_FP_INSTANCE_CONFIG_M a,
             SY_SCM_SYS_CALENDAR_M B
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.CATEGORY_ID  = 'DPP_CONFIG'
      AND    A.KEY_ID       = 'FIX_OFFSET'
      AND    A.KEY_VALUE    = B.DAY
      AND    B.DATE_ID      = CONVERT(DATE, @plan_date)
      
      --LOG 생성
      SET @v_message = '@v_fix_pegging_type : ' + @v_fix_pegging_type
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

    END;
    
    -- top item 기준 fix pegging
    BEGIN
    
      DELETE FROM TH_MST_SCM_DEMAND_FIX_MAP
      WHERE  DPP_PLAN_ID = @v_plan_id
      
      UPDATE TH_MST_SCM_ORDER_STATUS
      SET    REMAIN_QTY = ORG_QTY
      WHERE  INSTANCE_ID = @v_master_id
      AND    FP_PLAN_ID  = @v_plan_id
      
      SET @v_table_name = 'C_FIX'
      SET @n_row_count = 0
      
      DECLARE
        @c_fix$company_id         nvarchar(30), 
        @c_fix$division_id        nvarchar(30), 
        @c_fix$site_id            nvarchar(30), 
        @c_fix$plant_id           nvarchar(30), 
        @c_fix$wo_status          nvarchar(30), 
        @c_fix$work_order_id      nvarchar(30), 
        @c_fix$production_type    nvarchar(30), 
        @c_fix$item_id            nvarchar(150), 
        @c_fix$market             nvarchar(10), 
        @c_fix$factory_id         nvarchar(30), 
        @c_fix$operation_id       nvarchar(30), 
        @c_fix$line_id            nvarchar(30), 
        @c_fix$plan_date          nvarchar(10), 
        @c_fix$qty                numeric(20,10),
        @c_fix$remain_qty         numeric(20,10)
        
      DECLARE
        @c_demand$scp_target_id   nvarchar(150),     
        @c_demand$top_target_id   nvarchar(150),     
        @c_demand$minus_qty       numeric(20,10)

      DECLARE
        @c_assign$scp_target_id   nvarchar(150) = 'NULL',       -- 이전 할당한 target 정보
        @c_assign$cnt             int           = 0             -- 할당 count
      
      DECLARE
        C_FIX CURSOR LOCAL FOR
          SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, WO_STATUS,
                 WORK_ORDER_ID, PRODUCTION_TYPE, ITEM_ID, MARKET,
                 FACTORY_ID, OPERATION_ID, LINE_ID,
                 CONVERT(DATE, DATEADD(MINUTE, @v_daydiff * (-1), PLAN_START_TIME))PLAN_DATE,
                 REMAIN_QTY AS FIX_QTY
          FROM   (
                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, WO_STATUS,
                         WORK_ORDER_ID, PRODUCTION_TYPE, ITEM_ID, MARKET,
                         FACTORY_ID, OPERATION_ID, LINE_ID,
                         ACTUAL_QTY, ACTUAL_START_TIME,
                         PLAN_START_TIME, REMAIN_QTY
                  FROM   TH_MST_SCM_ORDER_STATUS A
                  WHERE  INSTANCE_ID = @v_master_id
                  AND    FP_PLAN_ID  = @v_plan_id
                  AND    WO_STATUS IN ('RUN', 'OPEN', 'AMEND')
                  AND    TOP_OPERATION_ITEM_ID = 'TOP'    -- 최종 공정만 DEMAND 랑 PEGGING
                  AND    REMAIN_QTY > 0
                  AND    ISNULL(PRODUCTION_TYPE, 'MASS') != 'TEST'
                  UNION  ALL
                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, WO_STATUS,
                         WORK_ORDER_ID, PRODUCTION_TYPE, ITEM_ID, MARKET,
                         FACTORY_ID, OPERATION_ID, LINE_ID,
                         ACTUAL_QTY, ACTUAL_START_TIME,
                         PLAN_START_TIME, REMAIN_QTY
                  FROM   TH_MST_SCM_ORDER_STATUS A
                  WHERE  INSTANCE_ID = @v_master_id
                  AND    FP_PLAN_ID  = @v_plan_id
                  AND    WO_STATUS IN ('RUN', 'OPEN', 'AMEND')
                  --AND    TOP_OPERATION_ITEM_ID = 'TOP'    -- 최종 공정만 DEMAND 랑 PEGGING
                  AND    REMAIN_QTY > 0
                  AND    ISNULL(PRODUCTION_TYPE, 'MASS')  = 'TEST'
                 ) A
          ORDER  BY CASE WO_STATUS  WHEN 'RUN'    THEN 1 
                                    WHEN 'OPEN'   THEN 2 
                                    WHEN 'AMEND'  THEN 3
                                                  ELSE 9
                    END -- OPEN WORK, AMEND WORK 우선순위 부여
                  , ITEM_ID
                  , CASE WHEN ISNULL(ACTUAL_QTY, 0) > 0     THEN 1 ELSE 2 END
                  , CASE WHEN ACTUAL_START_TIME IS NOT NULL THEN 1 ELSE 2 END
                  , PLAN_START_TIME, WORK_ORDER_ID

      OPEN C_FIX
      
      WHILE 1 = 1
      BEGIN
        

        FETCH C_FIX INTO  @c_fix$company_id
                        , @c_fix$division_id
                        , @c_fix$site_id
                        , @c_fix$plant_id
                        , @c_fix$wo_status
                        , @c_fix$work_order_id
                        , @c_fix$production_type
                        , @c_fix$item_id
                        , @c_fix$market
                        , @c_fix$factory_id
                        , @c_fix$operation_id
                        , @c_fix$line_id
                        , @c_fix$plan_date
                        , @c_fix$qty

        IF @@FETCH_STATUS <> 0
          BREAK

        SET @c_fix$remain_qty = @c_fix$qty
        SET @c_demand$top_target_id = 'NULL'

        WHILE 1=1
        BEGIN

          SET @c_demand$scp_target_id = 'NULL'
          
          SELECT TOP 1
                 @c_demand$scp_target_id = SCP_TARGET_ID
                ,@c_demand$minus_qty     = ( CASE WHEN QTY > @c_fix$remain_qty THEN @c_fix$remain_qty ELSE QTY END )
          FROM   (
                  SELECT A.*,
                         MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY ) AS QTY
                  FROM   TH_BUF_SCM_DEMAND A
                  WHERE  COMPANY_ID               = @c_fix$company_id
                  AND    DIVISION_ID              = @c_fix$division_id
                  AND    SITE_ID                  = @c_fix$site_id
                  --AND    PLANT_ID                 = @c_fix$plant_id
                  AND    DPP_PLAN_ID              = @v_plan_id
                  AND    ITEM_ID                  = @c_fix$item_id
                  AND    PRODUCTION_TYPE          = 'TEST'
                  AND    @c_fix$production_type   = 'TEST' 
                  AND    TO_FACTORY_ID            = @c_fix$factory_id
                  --AND    OPERATION_ID             = @c_fix$operation_id
                  AND    LINE_ID                  = @c_fix$line_id
                  --AND    MARKET                   = @c_fix$market
                  AND    MFG_QTY > ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                  AND    ISNULL(WORK_ORDER_ID, '*NULL*') = '*NULL*'
                  UNION  ALL
                  SELECT A.*,
                         MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY ) AS QTY
                  FROM   TH_BUF_SCM_DEMAND A
                  WHERE  COMPANY_ID               = @c_fix$company_id
                  AND    DIVISION_ID              = @c_fix$division_id
                  AND    SITE_ID                  = @c_fix$site_id
                  --AND    PLANT_ID                 = @c_fix$plant_id
                  AND    DPP_PLAN_ID              = @v_plan_id
                  AND    ITEM_ID                  = @c_fix$item_id
                  AND    PRODUCTION_TYPE         != 'TEST'
                  AND    @c_fix$production_type  != 'TEST' 
                  --AND    MARKET                   = @c_fix$market
                  AND    MFG_QTY > ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                  AND    ISNULL(WORK_ORDER_ID, '*NULL*') = '*NULL*'                  
                 ) A
          ORDER  BY  MFG_WEEK, 
                    ( CASE WHEN QTY = @c_fix$remain_qty THEN 1
                           WHEN QTY > @c_fix$remain_qty THEN 2
                                                        ELSE 9 END ),
                    DUE_DATE, DUE_FENCE_DATE, SCP_TARGET_ID
        
          IF @c_demand$scp_target_id = 'NULL'     -- 위 SELECT 문에서 대상을 못찾으면 나가기
            BEGIN
              -- 확정 수량이 남아 있고, 차감대상이 없을 경우
              -- 타겟 수량을 강제 증량시킨다.
              /*
              UPDATE TH_BUF_SCM_DEMAND
              SET    OFFSET_FIX_QTY  += @c_fix$remain_qty
              WHERE  DPP_PLAN_ID      = @v_plan_id
              AND    FP_DEMAND_ID     = @c_demand$top_target_id
              
              UPDATE TH_MST_SCM_ORDER_STATUS
              SET    REMAIN_QTY      -= @c_demand$minus_qty
              WHERE  INSTANCE_ID      = @v_master_id
              AND    FP_PLAN_ID       = @v_plan_id
              AND    WORK_ORDER_ID    = @c_fix$work_order_id
              */
              
              BREAK
            END
            
          SELECT @c_assign$cnt = COUNT(1)
          FROM   TH_BUF_SCM_DEMAND A
          WHERE  DPP_PLAN_ID = @v_plan_id
          AND    SCP_TARGET_ID = @c_demand$scp_target_id
          
          SELECT @c_demand$top_target_id =
                      A.FP_DEMAND_ID +'::'+ 'FIX' + SUBSTRING(CONVERT(nvarchar, 1000+@c_assign$cnt), 2, 3)  
          FROM   TH_BUF_SCM_DEMAND A
          WHERE  DPP_PLAN_ID = @v_plan_id
          AND    SCP_TARGET_ID = @c_demand$scp_target_id
          AND    ISNULL(WORK_ORDER_ID, '*NULL*') = '*NULL*'  

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
               , INSERT_ID
               , INSERT_TIME
               , UPDATE_ID
               , UPDATE_TIME                        
              )
          SELECT @c_fix$company_id        AS COMPANY_ID
               , @c_fix$division_id       AS DIVISION_ID
               , @c_fix$site_id           AS SITE_ID
               , @c_fix$plant_id          AS PLANT_ID
               , SHOP_GROUP_ID
               , @v_plan_id               AS DPP_PLAN_ID
               , @c_demand$top_target_id  AS FP_DEMAND_ID
               , SCP_PLAN_ID
               , @c_demand$scp_target_id  AS SCP_TARGET_ID
               , @c_fix$item_id           AS ITEM_ID
               , SCP_QTY
               , MFG_WEEK
               , MFG_QTY
               , @c_fix$work_order_id     AS WORK_ORDER_ID
               , CASE WHEN CONVERT(DATE, @c_fix$plan_date) < CONVERT(DATE, @plan_date)  THEN CONVERT(DATE, @plan_date)
                      ELSE CONVERT(DATE, @c_fix$plan_date) 
                 END  AS DUE_DATE
               , DUE_FENCE_DATE
               , 1                        AS PRECEDE_PRODUCING_TERM
               , 'DAY'                    AS PRECEDE_PRODUCING_TERM_UOM
               , @c_fix$production_type   AS PRODUCTION_TYPE
               , TO_SITE_ID
               , TO_PLANT_ID
               , LINE_ID
               , CASE WHEN @c_fix$market IS NULL THEN A.MARKET
                      WHEN @c_fix$market =  ''   THEN A.MARKET
                      ELSE @c_fix$market
                 END  AS MARKET
               , PRIORITY
               , 0                        AS OFFSET_INVENTORY_QTY
               , 0                        AS OFFSET_GI_QTY
               , @c_demand$minus_qty      AS OFFSET_FIX_QTY
               , CONFIRM_TYPE
               , 'FIX'                    AS DEMAND_TYPE
               , TARGET_TYPE
               , ''                       AS FIX_PEGGING_DEMAND_ID
               , @v_proc_name             AS INSERT_ID
               , GETDATE()                AS INSERT_TIME
               , @v_proc_name             AS UPDATE_ID
               , GETDATE()                AS UPDATE_TIME                     
          FROM   TH_BUF_SCM_DEMAND A
          WHERE  DPP_PLAN_ID = @v_plan_id
          AND    SCP_TARGET_ID = @c_demand$scp_target_id
          AND    ISNULL(WORK_ORDER_ID, '*NULL*') = '*NULL*'

          SET @n_row_count += @@ROWCOUNT

          -- 차감대상인 애들에게 넣어줘야 NET DEMAND 를 안만든다
          UPDATE TH_BUF_SCM_DEMAND
          SET    OFFSET_FIX_QTY  += @c_demand$minus_qty
          WHERE  DPP_PLAN_ID      = @v_plan_id
          AND    SCP_TARGET_ID    = @c_demand$scp_target_id
          AND    ISNULL(WORK_ORDER_ID, '*NULL*') = '*NULL*'
          
          UPDATE TH_MST_SCM_ORDER_STATUS
          SET    REMAIN_QTY      -= @c_demand$minus_qty
          WHERE  INSTANCE_ID      = @v_master_id
          AND    FP_PLAN_ID       = @v_plan_id
          AND    WORK_ORDER_ID    = @c_fix$work_order_id

          
          INSERT  INTO TH_MST_SCM_DEMAND_FIX_MAP
          SELECT  @c_fix$company_id       AS COMPANY_ID
                , @c_fix$division_id      AS DIVISION_ID
                , @c_fix$site_id          AS SITE_ID
                , @c_fix$plant_id         AS PLANT_ID
                , @v_plan_id              AS DPP_PLAN_ID
                , @c_fix$work_order_id    AS WORK_ORDER_ID
                , @c_fix$item_id          AS ITEM_ID
                , @c_fix$qty              AS PLAN_QTY
                , @c_demand$top_target_id AS FP_DEMAND_ID
                , @c_demand$scp_target_id AS SCP_TARGET_ID
                , @c_demand$minus_qty     AS SCP_QTY
                , @plan_date              AS KEY_DATE
                , @v_proc_name            AS INSERT_ID
                , GETDATE()               AS INSERT_DATE
                , @v_proc_name            AS UPDATE_ID
                , GETDATE()               AS UPDATE_DATE

          SET @c_fix$remain_qty -= @c_demand$minus_qty

          IF @c_fix$remain_qty <= 0               -- fix 를 전부 pegging 하면 나가기
            BREAK

        END
      
      END
      CLOSE C_FIX

      DEALLOCATE C_FIX
      

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

    END

    -- WORK ORDER 가 TARGET 에 의해 SPLIT 된 경우 한쪽으로 몰아버린다..
    BEGIN
    
      SET @v_table_name = 'TH_BUF_SCM_DEMAND - FIX SPLIT MERGE'
      
      UPDATE TH_BUF_SCM_DEMAND
      SET    TH_BUF_SCM_DEMAND.OFFSET_FIX_QTY = B.NEW_OFFSET_FIX_QTY
      FROM   TH_BUF_SCM_DEMAND A,
             (
              SELECT DPP_PLAN_ID, FP_DEMAND_ID,
                     OFFSET_FIX_QTY, SEQ, 
                     CASE WHEN SEQ = 1 THEN SUM_QTY ELSE 0 END NEW_OFFSET_FIX_QTY
              FROM   (
                      SELECT A.*,
                             DENSE_RANK() OVER (PARTITION BY WORK_ORDER_ID ORDER BY DUE_DATE, DUE_FENCE_DATE, MFG_WEEK, FP_DEMAND_ID) SEQ,
                             SUM(OFFSET_FIX_QTY) OVER (PARTITION BY WORK_ORDER_ID) AS SUM_QTY
                      FROM   TH_BUF_SCM_DEMAND A
                      WHERE  DPP_PLAN_ID = @v_plan_id
                      AND    DEMAND_TYPE = 'FIX'
                      AND    WORK_ORDER_ID IN (
                                                SELECT WORK_ORDER_ID
                                                FROM   TH_BUF_SCM_DEMAND
                                                WHERE  DPP_PLAN_ID = @v_plan_id
                                                AND    WORK_ORDER_ID IS NOT NULL
                                                GROUP  BY WORK_ORDER_ID
                                                HAVING  COUNT(1) > 1
                                              )
                     ) A
             ) B
      WHERE  A.DPP_PLAN_ID  = B.DPP_PLAN_ID
      AND    A.FP_DEMAND_ID = B.FP_DEMAND_ID
      AND    A.DEMAND_TYPE  = 'FIX'

      --LOG 생성
      SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      DELETE FROM TH_BUF_SCM_DEMAND
      WHERE  DPP_PLAN_ID    = @v_plan_id
      AND    DEMAND_TYPE    = 'FIX'
      AND    OFFSET_FIX_QTY = 0

      --LOG 생성
      SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
    
    END
    
    -- 특정 요일 ( 목 ) 을 제외하곤 pegging 되지 않는 WORK 은 강제 설정하기
    -- @v_fix_pegging_type = 'HARD' 일 경우 부분 PEGGING 한 애들을 PEGGING 된 애들로 넣어버린다.
    IF @v_fix_pegging_type = 'HARD'
      BEGIN
      
        SET @v_table_name = 'TH_BUF_SCM_DEMAND'

        UPDATE TH_BUF_SCM_DEMAND
        SET    TH_BUF_SCM_DEMAND.OFFSET_FIX_QTY += B.REMAIN_QTY
        FROM   TH_BUF_SCM_DEMAND A,
               TH_MST_SCM_ORDER_STATUS B
        WHERE  A.DPP_PLAN_ID = B.FP_PLAN_ID
        AND    A.WORK_ORDER_ID = B.WORK_ORDER_ID
        AND    B.REMAIN_QTY > 0        

        --LOG 생성
        SET @v_message = 'HARD PEGGING - QTY SUM : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        SET @v_table_name = 'TH_MST_SCM_ORDER_STATUS'

        UPDATE TH_MST_SCM_ORDER_STATUS
        SET    TH_MST_SCM_ORDER_STATUS.REMAIN_QTY = 0
        FROM   TH_BUF_SCM_DEMAND A,
               TH_MST_SCM_ORDER_STATUS B
        WHERE  A.DPP_PLAN_ID = B.FP_PLAN_ID
        AND    A.WORK_ORDER_ID = B.WORK_ORDER_ID
        AND    B.REMAIN_QTY > 0        
      
        --LOG 생성
        SET @v_message = 'HARD PEGGING - QTY 0 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END


    SET @v_table_name = 'TH_MST_FIXED_PLAN' + ' : ' + @res_category
    SET @n_row_count = 0

    DELETE FROM TH_MST_FIXED_PLAN
    WHERE  MASTER_ID = @v_master_id
    AND    PLAN_ID = @v_plan_id
    AND    PO_TYPE = 'REPLAN'
    
    IF @res_category = 'LINE'
      BEGIN
     
        INSERT INTO TH_MST_FIXED_PLAN
              (
                MASTER_ID
              , PLAN_ID
              , WORK_ORDER_ID
              , WORK_ORDER_SEQ
              , TOP_WORK_ORDER_ID
              , DEMAND_ID
              , PRODUCTION_ORDER_ID
              , PO_TYPE
              , ORDER_TYPE
              , LOT_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , RESOURCE_ID
              , SUB_RESOURCE_ID
              , ITEM_ID
              , OPERATION_QTY
              , COMPLETE_QTY
              , START_DATE
              , END_DATE
              , KEEP_WORK_TIME_TYPE
              , KEEP_QTY_TYPE
              , IS_FIXED
              , IS_PREV_SCHEDULE
              , IS_NOH_CONSUME
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM            
              )

        SELECT 
                @v_master_id    AS MASTER_ID
              , @v_plan_id      AS PLAN_ID
              , WORK_ORDER_ID
              , 500000 +
                          ROW_NUMBER() OVER (ORDER BY 
                                                      CASE WO_STATUS  WHEN 'RUN'    THEN 1
                                                                      WHEN 'OPEN'   THEN 2
                                                                      WHEN 'AMEND'  THEN 3
                                                                                    ELSE 9
                                                      END
                                                    , OPERATION_ID, FACTORY_ID, LINE_ID
                                                    --, ACTUAL_SEQ
                                                    --, ACTUAL_TIME_SEQ
                                                    , PLAN_START_TIME, WORK_ORDER_ID )WORK_ORDER_SEQ
              , TOP_WORK_ORDER_ID
              , DEMAND_ID
              , TOP_WORK_ORDER_ID AS PRODUCTION_ORDER_ID
              , CASE WHEN WO_STATUS IN ('OPEN','RUN') THEN 'REPLAN' 
                     ELSE 'AMEND'
                END  PO_TYPE
              , ORDER_TYPE
              , '' LOT_ID
              , FACTORY_ID AS SITE_ID
              , LINE_ID AS ROUTE_ID
              , OPERATION_ID
              , LINE_ID +'_'+ OPERATION_ID
                        + ( CASE ELECTRODE_TYPE WHEN '-' THEN '' WHEN '' THEN '' ELSE '_'+ELECTRODE_TYPE END ) AS RESOURCE_ID
              , '' SUB_RESOURCE_ID
              , ITEM_ID
              , PLAN_QTY AS OPERATION_QTY
              , PLAN_QTY AS COMPLETE_QTY
              , START_TIME       AS START_DATE
              , END_TIME         AS END_DATE
              , 'NO_FIX' AS KEEP_WORK_TIME_TYPE     -- DURATION_FIX, START_FIX, END_FIX, NO_FIX
              , 'COM_QTY_FIX' AS KEEP_QTY_TYPE     -- ALL_QTY_FIX, OP_QTY_FIX, COM_QTY_FIX, NO_FIX
              , 'N' IS_FIXED
              , 'N' IS_PREV_SCHEDULE
              --, ( CASE WHEN RUNNING_FLAG = 'Y' THEN 'N' ELSE 'Y' END ) IS_PREV_SCHEDULE -- 진행중인 공정은 하위를 풀지 않는다.
              , 'Y' IS_NOH_CONSUME
              , @v_proc_name          AS INSERT_ID
              , CONVERT(DATE, GETDATE()) AS INSERT_DTTM
              , @v_proc_name          AS UPDATE_ID
              , GETDATE()             AS UPDATE_DTTM           
        FROM   (
                SELECT 
                          B.COMPANY_ID
                        , B.DIVISION_ID
                        , B.SITE_ID
                        , B.PLANT_ID
                        , B.FACTORY_ID
                        , B.WORK_ORDER_ID
                        , A.WORK_ORDER_ID AS TOP_WORK_ORDER_ID
                        , A.FP_DEMAND_ID AS DEMAND_ID
                        , B.PRODUCTION_TYPE
                        , 'W' AS ORDER_TYPE
                        , B.ITEM_ID
                        , B.OPERATION_ID
                        , B.LINE_ID
                        , B.ELECTRODE_TYPE
                        , CONVERT(DATE, MIN(A.DUE_DATE)) AS PLAN_DATE       -- 이 시간은 위에서 PEGGING 한 시간
                        , DATEADD(MINUTE, @v_daydiff, CONVERT(DATETIME, MIN(A.DUE_DATE))) AS START_TIME
                        , @plan_end_time AS END_TIME
                        , SUM(ISNULL(A.OFFSET_FIX_QTY,0)) AS PLAN_QTY
                        , CASE WHEN SUM(ISNULL(ACTUAL_QTY, 0)) > 0     THEN 1 ELSE 2 END AS ACTUAL_SEQ
                        , CASE WHEN MAX(ACTUAL_START_TIME) IS NOT NULL THEN 1 ELSE 2 END AS ACTUAL_TIME_SEQ
                        , MIN(PLAN_START_TIME) AS PLAN_START_TIME
                        , MIN(B.WO_STATUS) AS WO_STATUS
                FROM   TH_BUF_SCM_DEMAND A,
                       TH_MST_SCM_ORDER_STATUS B
                WHERE  A.DPP_PLAN_ID = B.FP_PLAN_ID
                AND    A.WORK_ORDER_ID = B.WORK_ORDER_ID
                AND    B.TOP_OPERATION_ITEM_ID = 'TOP'
                --AND    B.WO_STATUS = 'OPEN'
                GROUP  BY 
                          B.COMPANY_ID
                        , B.DIVISION_ID
                        , B.SITE_ID
                        , B.PLANT_ID
                        , B.FACTORY_ID
                        , B.WORK_ORDER_ID
                        , A.WORK_ORDER_ID
                        , A.FP_DEMAND_ID
                        , B.PRODUCTION_TYPE
                        , B.ITEM_ID
                        , B.OPERATION_ID
                        , B.LINE_ID
                        , B.ELECTRODE_TYPE
               ) A       
        ORDER  BY START_TIME
        
        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END
    ELSE
      BEGIN
      
        INSERT INTO TH_MST_FIXED_PLAN
              (
                MASTER_ID
              , PLAN_ID
              , WORK_ORDER_ID
              , WORK_ORDER_SEQ
              , TOP_WORK_ORDER_ID
              , DEMAND_ID
              , PRODUCTION_ORDER_ID
              , PO_TYPE
              , ORDER_TYPE
              , LOT_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , RESOURCE_ID
              , SUB_RESOURCE_ID
              , ITEM_ID
              , OPERATION_QTY
              , COMPLETE_QTY
              , START_DATE
              , END_DATE
              , KEEP_WORK_TIME_TYPE
              , KEEP_QTY_TYPE
              , IS_FIXED
              , IS_PREV_SCHEDULE
              , IS_NOH_CONSUME
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM            
              )

        SELECT 
                @v_master_id    AS MASTER_ID
              , @v_plan_id      AS PLAN_ID
              , WORK_ORDER_ID
              , 500000 +
                          ROW_NUMBER() OVER (ORDER BY 
                                                      CASE WO_STATUS  WHEN 'RUN'    THEN 1
                                                                      WHEN 'OPEN'   THEN 2
                                                                      WHEN 'AMEND'  THEN 3
                                                                                    ELSE 9
                                                      END
                                                    , OPERATION_ID, FACTORY_ID, LINE_ID
                                                    --, CASE WHEN ISNULL(ACTUAL_QTY, 0) > 0     THEN 1 ELSE 2 END
                                                    --, CASE WHEN ACTUAL_START_TIME IS NOT NULL THEN 1 ELSE 2 END
                                                    , PLAN_START_TIME, WORK_ORDER_ID )WORK_ORDER_SEQ
              , TOP_WORK_ORDER_ID
              , DEMAND_ID
              , TOP_WORK_ORDER_ID AS PRODUCTION_ORDER_ID
              , CASE WHEN WO_STATUS IN ('OPEN','RUN') THEN 'REPLAN' 
                     ELSE 'AMEND'
                END  PO_TYPE
              , ORDER_TYPE
              , '' LOT_ID
              , FACTORY_ID AS SITE_ID
              , LINE_ID AS ROUTE_ID
              , OPERATION_ID
              , EQUIPMENT_ID AS RESOURCE_ID
              , '' SUB_RESOURCE_ID
              , ITEM_ID
              , PLAN_QTY AS OPERATION_QTY
              , PLAN_QTY AS COMPLETE_QTY
              , START_TIME AS START_DATE
              , END_TIME   AS END_DATE
              , 'NO_FIX' AS KEEP_WORK_TIME_TYPE     -- DURATION_FIX, START_FIX, END_FIX, NO_FIX
              , 'COM_QTY_FIX' AS KEEP_QTY_TYPE     -- ALL_QTY_FIX, OP_QTY_FIX, COM_QTY_FIX, NO_FIX
              , 'N' IS_FIXED
              , 'N' IS_PREV_SCHEDULE
              , 'Y' IS_NOH_CONSUME
              , @v_proc_name          AS INSERT_ID
              , CONVERT(DATE, GETDATE()) AS INSERT_DTTM
              , @v_proc_name          AS UPDATE_ID
              , GETDATE()             AS UPDATE_DTTM           
        FROM   (
                SELECT 
                          B.COMPANY_ID
                        , B.DIVISION_ID
                        , B.SITE_ID
                        , B.PLANT_ID
                        , B.FACTORY_ID
                        , B.WORK_ORDER_ID
                        , A.WORK_ORDER_ID AS TOP_WORK_ORDER_ID
                        , A.FP_DEMAND_ID AS DEMAND_ID
                        , B.PRODUCTION_TYPE
                        , 'W' AS ORDER_TYPE
                        , B.ITEM_ID
                        , B.OPERATION_ID
                        , B.LINE_ID
                        , B.ELECTRODE_TYPE
                        , B.EQUIPMENT_ID
                        , CONVERT(DATE, A.DUE_DATE) AS PLAN_DATE       -- 이 시간은 위에서 PEGGING 한 시간
                        , DATEADD(MINUTE, @v_daydiff, CONVERT(DATETIME, A.DUE_DATE)) AS START_TIME
                        , @plan_end_time AS END_TIME
                        , ISNULL(A.OFFSET_FIX_QTY,0) AS PLAN_QTY
                        , B.ACTUAL_START_TIME
                        , B.ACTUAL_QTY
                        , B.PLAN_START_TIME
                        , B.WO_STATUS
                FROM   TH_BUF_SCM_DEMAND A,
                       TH_MST_SCM_ORDER_STATUS B
                --WHERE  A.FIX_PEGGING_DEMAND_ID = B.DEMAND_ID
                WHERE  A.DPP_PLAN_ID = B.FP_PLAN_ID
                AND    A.WORK_ORDER_ID = B.WORK_ORDER_ID
                AND    B.TOP_OPERATION_ITEM_ID = 'TOP'
               ) A       
        ORDER  BY START_TIME

        
        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END

      -- 그 이외의 ORDER 에 대해서 FIXED PLAN 에 설정한다.
      IF CHARINDEX('E_POST', @v_master_id) = 0
      BEGIN

        SET @v_table_name = 'TH_MST_FIXED_PLAN : ETC'

        INSERT INTO TH_MST_FIXED_PLAN
              (
                MASTER_ID
              , PLAN_ID
              , WORK_ORDER_ID
              , WORK_ORDER_SEQ
              , TOP_WORK_ORDER_ID
              , DEMAND_ID
              , PRODUCTION_ORDER_ID
              , PO_TYPE
              , ORDER_TYPE
              , LOT_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , RESOURCE_ID
              , SUB_RESOURCE_ID
              , ITEM_ID
              , OPERATION_QTY
              , COMPLETE_QTY
              , START_DATE
              , END_DATE
              , KEEP_WORK_TIME_TYPE
              , KEEP_QTY_TYPE
              , IS_FIXED
              , IS_PREV_SCHEDULE
              , IS_NOH_CONSUME
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM            
              )

        SELECT 
                @v_master_id    AS MASTER_ID
              , @v_plan_id      AS PLAN_ID
              , WORK_ORDER_ID
              , 100000 +
                          ROW_NUMBER() OVER (ORDER BY 
                                                      CASE WO_STATUS  WHEN 'RUN'    THEN 1
                                                                      WHEN 'OPEN'   THEN 2
                                                                      WHEN 'AMEND'  THEN 3
                                                                                    ELSE 9
                                                      END
                                                    , OPERATION_ID, FACTORY_ID, LINE_ID
                                                    --, CASE WHEN ISNULL(ACTUAL_QTY, 0) > 0     THEN 1 ELSE 2 END
                                                    --, CASE WHEN ACTUAL_START_TIME IS NOT NULL THEN 1 ELSE 2 END
                                                    , PLAN_START_TIME, WORK_ORDER_ID )WORK_ORDER_SEQ
              , TOP_WORK_ORDER_ID
              , NULL              AS DEMAND_ID
              , TOP_WORK_ORDER_ID AS PRODUCTION_ORDER_ID
              , CASE WHEN WO_STATUS IN ('OPEN','RUN') THEN 'REPLAN' 
                     ELSE 'AMEND'
                END  PO_TYPE
              , 'W'       ORDER_TYPE
              , '' LOT_ID
              , FACTORY_ID AS SITE_ID
              , LINE_ID AS ROUTE_ID
              , OPERATION_ID
              , EQUIPMENT_ID AS RESOURCE_ID
              , '' SUB_RESOURCE_ID
              , ITEM_ID
              , PLAN_QTY AS OPERATION_QTY
              , PLAN_QTY AS COMPLETE_QTY
              , CASE WHEN CONVERT(DATE, PLAN_DATE) < CONVERT(DATE, @plan_date)  THEN DATEADD(MINUTE, @v_daydiff, CONVERT(DATETIME, @plan_date))
                     ELSE DATEADD(MINUTE, @v_daydiff, CONVERT(DATETIME, PLAN_DATE))
                END  AS START_TIME
              , @plan_end_time   AS END_DATE
              , 'NO_FIX' AS KEEP_WORK_TIME_TYPE     -- DURATION_FIX, START_FIX, END_FIX, NO_FIX
              , 'COM_QTY_FIX' AS KEEP_QTY_TYPE     -- ALL_QTY_FIX, OP_QTY_FIX, COM_QTY_FIX, NO_FIX
              , 'N' IS_FIXED
              , 'N' IS_PREV_SCHEDULE
              , 'Y' IS_NOH_CONSUME
              , @v_proc_name + '_ETC'     AS INSERT_ID
              , GETDATE()                 AS INSERT_DTTM
              , @v_proc_name              AS UPDATE_ID
              , GETDATE()                 AS UPDATE_DTTM           
        FROM   (
                SELECT 
                          B.COMPANY_ID
                        , B.DIVISION_ID
                        , B.SITE_ID
                        , B.PLANT_ID
                        , B.FACTORY_ID
                        , B.WORK_ORDER_ID
                        , B.WORK_ORDER_ID AS TOP_WORK_ORDER_ID
                        , B.WORK_ORDER_ID AS DEMAND_ID
                        , B.PRODUCTION_TYPE
                        , B.ITEM_ID
                        , B.OPERATION_ID
                        , B.LINE_ID
                        , B.ELECTRODE_TYPE
                        , B.EQUIPMENT_ID
                        , CONVERT(DATE, DATEADD(SECOND, @v_daydiff * (-1), B.PLAN_START_TIME)) AS PLAN_DATE
                        , B.PLAN_QTY - ISNULL(ACTUAL_QTY,0) AS PLAN_QTY
                        , ACTUAL_QTY
                        , ACTUAL_START_TIME
                        , PLAN_START_TIME
                        , WO_STATUS
                FROM   TH_MST_SCM_ORDER_STATUS B
                WHERE  INSTANCE_ID   = @v_master_id
                AND    FP_PLAN_ID    = @v_plan_id
                AND    REMAIN_QTY > 0
                AND    NOT EXISTS (
                                    SELECT 1
                                    FROM   TH_MST_FIXED_PLAN X
                                    WHERE  X.MASTER_ID = @v_master_id
                                    AND    X.PLAN_ID = @v_plan_id
                                    AND    X.WORK_ORDER_ID = B.WORK_ORDER_ID
                                  )
                AND    B.OPERATION_ID NOT IN (-- 완성 공정은 제외함.  (실제 PEGGING 대상이 없는 WORK 은 사용하지 않는다. )
                                              SELECT ISNULL(MAX(OPERATION_ID), 'ZZZZZ')  AS MAX_OPERATION_ID
                                              FROM   TH_MST_INSTANCE_FLOW
                                              WHERE  MASTER_ID  = @v_master_id
                                              AND    PLAN_ID    = @v_plan_id
                                              AND    @v_fix_pegging_type = 'SOFT'             -- SOFT 일 경우 PEGGING 되지 않는 애들은 버린다.
                                              UNION  ALL
                                              SELECT 'E2000'            AS MAX_OPERATION_ID   
                                              WHERE  1=1
                                              AND    @v_fix_pegging_type = 'SOFT'             -- SOFT 일 경우 PEGGING 되지 않는 애들은 버린다.
                                             )
                --AND    B.WO_STATUS = 'OPEN'
               ) A       
        ORDER  BY START_TIME

        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
            
      END

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
