CREATE PROCEDURE [dbo].[PR_SCM_IF_STOCK]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_STOCK                                                           **/
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
  EXEC PR_SCM_IF_STOCK
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_ship_elec_plan_id  nvarchar(30)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime
  
  DECLARE @v_cutoff_date    date
  DECLARE @v_stock_seq      int 

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_STOCK'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)

  DECLARE @v_instance_type  nvarchar(10)      -- 후공정 PLAN 시 사용하기 위해..

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)

  -- ksjeon add  20170823
  -- FP_APPLY_WIPQTY or CAL_QTY ( 이론재고 사용여부 옵션 )
  DECLARE @STOCK_OPTION_VALUE       nvarchar(50)
  
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
    
      --LOG 생성
      SET @v_table_name = 'TH_MST_PLAN'
      SELECT  @plan_start_time = PLAN_START_DTTM,
              @plan_end_time   = PLAN_END_DTTM,
              @v_ship_elec_plan_id  = SCP_SHIP_ELEC_PLAN_ID,
              @key_date = PLAN_DATE
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM,
                     SCP_SHIP_ELEC_PLAN_ID,
                     PLAN_DATE
              FROM   TH_MST_PLAN
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id
             ) A
             
             
      --LOG 생성
      SET @v_message = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      SET @v_table_name = 'TH_MST_PLAN'
      SELECT @v_cutoff_date = max(cutoff_date)
      FROM   SY_SCM_STOCK_H
      --WHERE  CUTOFF_DATE <= DATEADD(DD, 0, CONVERT(DATE, @key_date))   -- 하루전부터 탐색
      WHERE  CUTOFF_DATE = DATEADD(DD, 0, CONVERT(DATE, @key_date))   -- 오늘꺼만
      
      --LOG 생성
      SET @v_message = '@v_cutoff_date : ' + CONVERT(nvarchar, @v_cutoff_date, 112)
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

      -- ksjeon add 20170823
      -- 이론재고 사용여부 구하기
      SELECT @STOCK_OPTION_VALUE = isnull(min(A.KEY_VALUE), 'FP_APPLY_WIPQTY') -- FP_APPLY_WIPQTY OR CAL_QTY
      FROM   SY_FP_INSTANCE_CONFIG_M A
      WHERE  1=1
      and    instance_id = @v_master_id
      and    category_id = 'STOCK_OPTION_VALUE'
      
      --LOG 생성
      SET @v_message  = '@STOCK_OPTION_VALUE : ' + @STOCK_OPTION_VALUE
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

    END;
    
    BEGIN
      
      SET @v_table_name = 'TH_MST_STOCK_PLAN'
      
      DELETE FROM TH_MST_STOCK_PLAN
      WHERE   MASTER_ID   = @v_master_id
      AND     PLAN_ID     = @v_plan_id
      
      /*
      -- 전공정의 경우 확정 1번째 계획은 하위 풀리지 않도록 STOCK 처리함.
      IF CHARINDEX('E_PRE', @v_master_id) > 0
      BEGIN

        SELECT  @v_stock_seq = ISNULL(MAX(STOCK_SEQ),0)
        FROM    TH_MST_STOCK_PLAN
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_plan_id

        INSERT INTO TH_MST_STOCK_PLAN
             (
               MASTER_ID
             , PLAN_ID
             , STOCK_SEQ
             , LOT_ID
             , ITEM_ID
             , QTY
             , RECEIVING_DTTM
             , STOCK_STATUS
             , SITE_ID
             , ROUTE_ID
             , OPERATION_ID
             , STOCK_ATTB_1
             , STOCK_ATTB_2
             , STOCK_ATTB_3
             , STOCK_ATTB_4
             , STOCK_ATTB_5
             , KEY_DATE
             , INSERT_ID
             , INSERT_DTTM
             , UPDATE_ID
             , UPDATE_DTTM
             )     
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , @v_stock_seq + CNT AS STOCK_SEQ
             , 'LOT_FIX_'+CONVERT(NVARCHAR, 100000+CNT) AS LOT_ID
             , A.CHILD_ITEM_ID    AS ITEM_ID
             , CEILING(A.COMPLETE_QTY / A.PRODUCTION_RATE * A.CONSUME_RATE * 2)  AS QTY  -- 잉여 생산을 막는다.
             , @plan_start_time   AS RECEIVING_DTTM
             , 'FIX'              AS STOCK_STATUS
             , A.SITE_ID
             , '-'                AS ROUTE_ID
             , A.OPERATION_ID
             , 'MASS'             AS STOCK_ATTB_1
             , '0'                AS STOCK_ATTB_2
             , '-'                AS STOCK_ATTB_3
             , '-'                AS STOCK_ATTB_4
             , A.DEMAND_ID        AS STOCK_ATTB_5
             , @key_date          AS KEY_DATE
             , @v_proc_name       AS INSERT_ID
             , GETDATE()          AS INSERT_DTTM
             , @v_proc_name       AS UPDATE_ID
             , getdate()          AS UPDATE_DTTM
       FROM   ( 
                SELECT A.*, B.DEMAND_ID, B.COMPLETE_QTY,
                       COUNT(1) OVER(ORDER BY B.SEQ, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID) CNT
                FROM   TH_MST_PLAN_BOM A,
                       (
                        SELECT A.*
                        FROM   (
                                SELECT A.*,
                                       DENSE_RANK() OVER (PARTITION BY SITE_ID, ROUTE_ID, OPERATION_ID, RESOURCE_ID ORDER BY WORK_ORDER_SEQ) AS SEQ
                                FROM   TH_MST_FIXED_PLAN A
                                WHERE  A.MASTER_ID  = @v_master_id
                                AND    A.PLAN_ID    = @v_plan_id
                               ) A
                        WHERE  SEQ <= 1     -- 최초 투입 ITEM 에 대해서만       
                       ) B
                WHERE  A.MASTER_ID = B.MASTER_ID
                AND    A.PLAN_ID = B.PLAN_ID
                AND    A.PARENT_ITEM_ID = B.ITEM_ID
                AND    A.SITE_ID = B.SITE_ID
                AND    A.ROUTE_ID = B.ROUTE_ID
                AND    A.OPERATION_ID = B.OPERATION_ID
               ) A

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END
      */

-----------------------------------------------------------------------------      
-----------------------------------------------------------------------------      
-- Stock UI 에 MODIFY_FP_APPLY_WIPQTY 컬럼 추가로 인한 로직 변경 반영 START
-- 아래를 두개의 블록으로 나누어 생성 함
-- 1.MODIFY_FP_APPLY_WIPQTY 의 데이터가 있는경우 line id를 보지않고 factory까지의 item을 생성
-- 2.MODIFY_FP_APPLY_WIPQTY의 수량이 없는것은 기존처럼 stock detail의 내용을 이용해 stock을 생성 ( line id 가 들어간 item생성 )

--====> 20170823 변경

-- Stock UI 에 MODIFY_FP_APPLY_WIPQTY, CAL_QTY 컬럼 추가로 인한 로직 변경 반영 START
-- 아래를 세개의 블록으로 나누어 생성 함
-- 1.MODIFY_FP_APPLY_WIPQTY 의 데이터가 있는경우 line id를 보지않고 factory까지의 item을 생성
-- 2.OPTION FP QTY 인 경우
--   MODIFY_FP_APPLY_WIPQTY의 수량이 없는것은 
--   기존처럼 stock detail의 내용을 이용해 stock을 생성 ( line id 가 들어간 item생성 )
-- 3.OPTION CAL_QTY 인 경우
--   MODIFY_FP_APPLY_WIPQTY의 수량이 없는것은 
--   CAL_QTY 의 내용을 이용해 stock을 생성 ( line id 가 들어간 item생성 )


-----------------------------------------------------------------------------      

      -- @STOCK_OPTION_VALUE = 'FP_APPLY_WIPQTY'
      IF @STOCK_OPTION_VALUE = 'FP_APPLY_WIPQTY'
      BEGIN


        BEGIN
        
          SELECT  @v_stock_seq = ISNULL(MAX(STOCK_SEQ),0)
          FROM    TH_MST_STOCK_PLAN
          WHERE   MASTER_ID   = @v_master_id
          AND     PLAN_ID     = @v_plan_id

          -- 일반 STOCK
          INSERT INTO TH_MST_STOCK_PLAN
                  ( MASTER_ID
                  , PLAN_ID
                  , STOCK_SEQ
                  , LOT_ID
                  , ITEM_ID
                  , QTY
                  , RECEIVING_DTTM
                  , STOCK_STATUS
                  , SITE_ID
                  , ROUTE_ID
                  , OPERATION_ID
                  , STOCK_ATTB_1
                  , STOCK_ATTB_2
                  , STOCK_ATTB_3
                  , STOCK_ATTB_4
                  , DESCR
                  , KEY_DATE
                  , INSERT_ID
                  , INSERT_DTTM
                  , UPDATE_ID
                  , UPDATE_DTTM )
          SELECT  DISTINCT  
                    @v_master_id
                  , @v_plan_id
                  , @v_stock_seq + A.STOCK_SEQ AS STOCK_SEQ
                  , 'LOT_' + @key_date
                           + CONVERT(nvarchar, CONVERT(INT, A.STOCK_SEQ) + 1000000) AS LOT_ID
                  , A.ITEM_ID
                  , A.QTY
                  , CASE WHEN A.AVAILABLE_DATE < @plan_start_time THEN @plan_start_time ELSE A.AVAILABLE_DATE END  AS RECEIVING_DTTM
                  , A.STOCK_TYPE     AS STOCK_STATUS
                  , A.FACTORY_ID     AS SITTE_ID
                  , A.LINE_ID        AS ROUTE_ID
                  , A.OPERATION_ID   AS OPERATION_ID
                  , CASE WHEN ISNULL(A.PRODUCTION_TYPE, '') = ''  THEN 'MASS' ELSE A.PRODUCTION_TYPE END AS STOCK_ATTB_1
                  , CASE WHEN ISNULL(A.LANE, 0) = 0      THEN '0' ELSE CONVERT(NVARCHAR, CEILING(A.LANE))     END AS STOCK_ATTB_2
                  , STOCK_ATTB_3
                  , STOCK_ATTB_3    AS STOCK_ATTB_4
                  , CASE WHEN ISNULL(A.LANE, 0) = 0      THEN '0' ELSE CONVERT(NVARCHAR, CEILING(A.LANE))     END AS DESCR
                  , @key_date AS KEY_DATE
                  , @v_proc_name as INSERT_ID
                  , GETDATE() as INSERT_DTTM
                  , @v_proc_name as UPDATE_ID
                  , getdate() as UPDATE_DTTM
          FROM   (
                  SELECT  A.SEQ
                        , ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)           AS ITEM_ID
                        -- ksjeon
                        , A.MODIFY_FP_APPLY_WIPQTY                        AS QTY
                        --, ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.FP_APPLY_WIPQTY, 0)) AS QTY
                        , A.AVAILABLE_DATE
                        , A.STOCK_TYPE
                        , A.FACTORY_ID
                        -- ksjeon line을 보지 않는다
                        , '-'  AS LINE_ID
  --                      , CASE WHEN A.LINE_ID IS NULL THEN '-'
  --                             WHEN A.LINE_ID = ''    THEN '-'
  --                             ELSE A.LINE_ID
  --                        END  AS LINE_ID
                        , ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) AS OPERATION_ID      -- 완성 기준 OPERATION_ID
                        , A.PRODUCTION_TYPE
                        , A.LANE
                        , A.QTY_UOM
                        , STOCK_ATTB_3
                        , DENSE_RANK()OVER (ORDER BY A.SEQ, A.FACTORY_ID, A.AVAILABLE_DATE, A.ITEM_ID, A.QTY) AS STOCK_SEQ
                  FROM   (-- 자재에 대해 STOCK 처리
                          SELECT  A.*, '-' AS STOCK_ATTB_3
                          FROM    SY_SCM_STOCK_H A
                          WHERE   A.CUTOFF_DATE = @v_cutoff_date
                          AND     A.STOCK_TYPE  = 'INVENTORY'
                          AND     A.STORAGE_ID  BETWEEN '1000' AND '1999'
                          AND     A.MODIFY_FP_APPLY_WIPQTY is not null
                          AND     A.AVAILABLE_DATE >= A.HOLDING_DATE
                          AND     A.AVAILABLE_DATE <= @plan_start_time
                          AND     NOT EXISTS  (
                                                SELECT 1
                                                FROM   TH_MST_INSTANCE_FLOW X
                                                WHERE  X.MASTER_ID = @v_master_id
                                                AND    X.PLAN_ID = @v_plan_id
                                                AND    X.COMPANY_ID = A.COMPANY_ID
                                                AND    X.DIVISION_ID = A.DIVISION_ID
                                                AND    X.SITE_ID = A.SITE_ID
                                                AND    X.ITEM_ID = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                              )
                          UNION   ALL
                          -- INSTANCE 내에 있는 재고 : CELL, PACK, SRS
                          SELECT  A.*, '-' AS STOCK_ATTB_3
                          FROM    SY_SCM_STOCK_H A
                          WHERE   A.CUTOFF_DATE  = @v_cutoff_date
                          AND     A.STOCK_TYPE = 'WIP'
                          AND     A.AVAILABLE_DATE >= A.HOLDING_DATE
                          AND     A.AVAILABLE_DATE <= @plan_start_time
                          AND     A.MODIFY_FP_APPLY_WIPQTY is not null
                          AND     @v_instance_type IN ('A','S','P')             -- 후공정 아닌애들
                          AND     ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) NOT IN ('A9000', 'A4000')        -- CELL
                          AND     ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) NOT IN ('P9500', 'P5500')        -- PACK
                          AND     ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) NOT IN ('S2000', 'S4000')        -- SRS
                          --AND     A.QTY > 0
                          AND     EXISTS  (
                                            SELECT 1
                                            FROM   TH_MST_INSTANCE_FLOW X
                                            WHERE  X.MASTER_ID = @v_master_id
                                            AND    X.PLAN_ID = @v_plan_id
                                            AND    X.COMPANY_ID = A.COMPANY_ID
                                            AND    X.DIVISION_ID = A.DIVISION_ID
                                            AND    X.SITE_ID = A.SITE_ID
                                            AND    X.ITEM_ID = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                            AND    X.OPERATION_ID = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                          )
                          UNION   ALL
                          -- INSTANCE 내에 있는 재고 : 전공정
                          SELECT  A.*, '-' AS STOCK_ATTB_3
                          FROM    SY_SCM_STOCK_H A
                          WHERE   A.CUTOFF_DATE  = @v_cutoff_date
                          AND     A.STOCK_TYPE = 'WIP'
                          AND     @v_instance_type = 'E1'                    -- 전 공정
                          AND     A.MODIFY_FP_APPLY_WIPQTY is not null
                          AND     A.AVAILABLE_DATE >= A.HOLDING_DATE
                          AND     A.AVAILABLE_DATE <= @plan_start_time
                          AND     EXISTS  (
                                            SELECT 1
                                            FROM   TH_MST_INSTANCE_FLOW X
                                            WHERE  X.MASTER_ID    = @v_master_id
                                            AND    X.PLAN_ID      = @v_plan_id
                                            AND    X.COMPANY_ID   = A.COMPANY_ID
                                            AND    X.DIVISION_ID  = A.DIVISION_ID
                                            AND    X.SITE_ID      = A.SITE_ID
                                            AND    X.FACTORY_ID   = A.FACTORY_ID
                                            AND    X.ITEM_ID      = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                            AND    X.OPERATION_ID = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                          )
                          AND     NOT EXISTS (
                                              SELECT 1
                                              FROM   (
                                                      SELECT ITEM_ID, FACTORY_ID
                                                           , MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                                      FROM   TH_MST_INSTANCE_FLOW A
                                                      WHERE  MASTER_ID  = @v_master_id
                                                      AND    PLAN_ID    = @v_plan_id
                                                      AND    OPERATION_ID IN ('E2500')
                                                      GROUP  BY 
                                                             ITEM_ID, FACTORY_ID                                        
                                                      UNION  ALL
                                                      -- DPP 에서 COAT 차감했으므로, 대상에서 제외함.
                                                      SELECT ITEM_ID, FACTORY_ID
                                                           , MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                                      FROM   TH_MST_INSTANCE_FLOW A
                                                      WHERE  MASTER_ID  = @v_master_id
                                                      AND    PLAN_ID    = @v_plan_id
                                                      AND    OPERATION_ID IN ('E2000')
                                                      GROUP  BY 
                                                             ITEM_ID, FACTORY_ID                                        
                                                     ) Y
                                              WHERE  Y.ITEM_ID            = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                              AND    Y.FACTORY_ID         = A.FACTORY_ID
                                              AND    Y.MAX_OPERATION_ID   = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                             )
                          UNION   ALL
                          -- INSTANCE 내에 있는 재고 : 후공정 대상
                          SELECT  A.*, '-' AS STOCK_ATTB_3
                          FROM    SY_SCM_STOCK_H A
                          WHERE   A.CUTOFF_DATE  = @v_cutoff_date
                          AND     A.STOCK_TYPE = 'WIP'
                          AND     @v_instance_type = 'E2'    -- 후공정
                          AND     A.MODIFY_FP_APPLY_WIPQTY is not null
                          AND     A.AVAILABLE_DATE >= A.HOLDING_DATE
                          AND     A.AVAILABLE_DATE <= @plan_start_time
                          AND    EXISTS (
                                          SELECT 1
                                          FROM   TH_DPP_NET_DEMAND XA
                                          WHERE  XA.MASTER_ID = @v_master_id
                                          AND    XA.PLAN_ID   = @v_plan_id
                                          AND    XA.ITEM_ID   = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                         )
                          AND     EXISTS  (
                                            SELECT 1
                                            FROM   TH_MST_INSTANCE_FLOW X
                                            WHERE  X.MASTER_ID = @v_master_id
                                            AND    X.PLAN_ID = @v_plan_id
                                            AND    X.COMPANY_ID = A.COMPANY_ID
                                            AND    X.DIVISION_ID = A.DIVISION_ID
                                            AND    X.SITE_ID = A.SITE_ID
                                            AND    X.ITEM_ID = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                            AND    X.OPERATION_ID = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                          )
                          AND     EXISTS  (
                                            SELECT 1
                                            FROM   (SELECT ITEM_ID, MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                                    FROM   TH_MST_INSTANCE_FLOW
                                                    WHERE  MASTER_ID = @v_master_id
                                                    AND    PLAN_ID = @v_plan_id
                                                    GROUP  BY ITEM_ID
                                                   ) X
                                            WHERE  X.ITEM_ID = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                            AND    X.MAX_OPERATION_ID != ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                          )
                          UNION   ALL
                          -- INSTANCE 외에 있는 재고 : 후공정에 투입되는 대상 ITEM
                          SELECT  A.*, @v_master_id AS STOCK_ATTB_3
                          FROM    SY_SCM_STOCK_H A
                          WHERE   A.CUTOFF_DATE  = @v_cutoff_date
                          AND     A.STOCK_TYPE = 'WIP'
                          AND     @v_instance_type = 'E2'    -- 후공정 아닌애들
                          AND     A.MODIFY_FP_APPLY_WIPQTY is not null
                          AND     A.AVAILABLE_DATE >= A.HOLDING_DATE
                          AND     A.AVAILABLE_DATE <= @plan_start_time
                          AND    EXISTS (
                                          SELECT 1
                                          FROM   TH_DPP_NET_DEMAND XA
                                          WHERE  XA.MASTER_ID = @v_master_id
                                          AND    XA.PLAN_ID   = @v_plan_id
                                          AND    XA.ITEM_ID   = A.ITEM_ID
                                         )
                          AND     EXISTS (
                                          SELECT 1
                                          FROM   (
                                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
                                                       , MAX(OPERATION_ID) AS OPERATION_ID
                                                  FROM   (
                                                          SELECT A.COMPANY_ID
                                                               , A.DIVISION_ID
                                                               , A.SITE_ID
                                                               , B.PLANT_ID
                                                               , B.FACTORY_ID
                                                               , A.OPERATION_ID
                                                          FROM   SY_SCM_OPERATION_M A,
                                                                 (
                                                                  SELECT B.*, 'E1' AS INSTANCE_TYPE
                                                                  FROM   SY_FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
                                                                         SY_SCM_FACTORY_M         B    -- FACTORY 별 SITE ID
                                                                  WHERE  A.INSTANCE_ID = @v_master_id
                                                                  AND    A.FACTORY_ID = B.FACTORY_ID
                                                                  AND    B.ACTIVE_FLAG = 'Y'
                                                                  AND    @v_instance_type = 'E2'
                                                                 ) B       
                                                          WHERE  A.COMPANY_ID    = B.COMPANY_ID
                                                          AND    A.DIVISION_ID   = B.DIVISION_ID
                                                          AND    A.SITE_ID       = B.SITE_ID
                                                          AND    A.INSTANCE_TYPE = B.INSTANCE_TYPE
                                                          AND    (
                                                                    (B.FACTORY_ID  <> 'E4' AND OPERATION_ID != 'E2500')
                                                                    OR
                                                                    (B.FACTORY_ID   = 'E4')
                                                                 )                   
                                                         ) A
                                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID                        
                                                 ) XB
                                          WHERE  XB.COMPANY_ID  = A.COMPANY_ID
                                          AND    XB.DIVISION_ID = A.DIVISION_ID
                                          AND    XB.SITE_ID     = A.SITE_ID
                                          AND    XB.PLANT_ID    = A.PLANT_ID
                                          AND    XB.FACTORY_ID  = A.FACTORY_ID
                                          AND    XB.OPERATION_ID = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                         )
                         ) A
                 -- ksjeon add -> MODIFY_FP_APPLY_WIPQTY 가 있는건을 우선 생성 함        
                 where   A.MODIFY_FP_APPLY_WIPQTY is not null
                 ) A
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
        END
        

        BEGIN
        
          SELECT  @v_stock_seq = ISNULL(MAX(STOCK_SEQ),0)
          FROM    TH_MST_STOCK_PLAN
          WHERE   MASTER_ID   = @v_master_id
          AND     PLAN_ID     = @v_plan_id

          -- 일반 STOCK
          INSERT INTO TH_MST_STOCK_PLAN
                  ( MASTER_ID
                  , PLAN_ID
                  , STOCK_SEQ
                  , LOT_ID
                  , ITEM_ID
                  , QTY
                  , RECEIVING_DTTM
                  , STOCK_STATUS
                  , SITE_ID
                  , ROUTE_ID
                  , OPERATION_ID
                  , STOCK_ATTB_1
                  , STOCK_ATTB_2
                  , STOCK_ATTB_3
                  , STOCK_ATTB_4
                  , DESCR
                  , KEY_DATE
                  , INSERT_ID
                  , INSERT_DTTM
                  , UPDATE_ID
                  , UPDATE_DTTM )
          SELECT  DISTINCT  
                    @v_master_id
                  , @v_plan_id
                  , @v_stock_seq + A.STOCK_SEQ AS STOCK_SEQ
                  -- ksjeon 
                  --, 'LOT_' + @key_date
                  , 'LOT2_' + @key_date
                           + CONVERT(nvarchar, CONVERT(INT, A.STOCK_SEQ) + 1000000) AS LOT_ID
                  , A.ITEM_ID
                  , A.QTY
                  , CASE WHEN A.AVAILABLE_DATE < @plan_start_time THEN @plan_start_time ELSE A.AVAILABLE_DATE END  AS RECEIVING_DTTM
                  , A.STOCK_TYPE     AS STOCK_STATUS
                  , A.FACTORY_ID     AS SITTE_ID
                  , A.LINE_ID        AS ROUTE_ID
                  , A.OPERATION_ID   AS OPERATION_ID
                  , CASE WHEN ISNULL(A.PRODUCTION_TYPE, '') = ''  THEN 'MASS' ELSE A.PRODUCTION_TYPE END AS STOCK_ATTB_1
                  , CASE WHEN ISNULL(A.LANE, 0) = 0      THEN '0' ELSE CONVERT(NVARCHAR, CEILING(A.LANE))     END AS STOCK_ATTB_2
                  , STOCK_ATTB_3
                  , STOCK_ATTB_3    AS STOCK_ATTB_4
                  , CASE WHEN ISNULL(A.LANE, 0) = 0      THEN '0' ELSE CONVERT(NVARCHAR, CEILING(A.LANE))     END AS DESCR
                  , @key_date AS KEY_DATE
                  , @v_proc_name as INSERT_ID
                  , GETDATE() as INSERT_DTTM
                  , @v_proc_name as UPDATE_ID
                  , getdate() as UPDATE_DTTM
          FROM   (
                  SELECT  A.SEQ
                        , ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)           AS ITEM_ID
                        -- ksjeon
                        , ISNULL(A.FP_APPLY_WIPQTY, 0)                    AS QTY
                        --, ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.FP_APPLY_WIPQTY, 0)) AS QTY
                        , A.AVAILABLE_DATE
                        , A.STOCK_TYPE
                        , A.FACTORY_ID
                        , CASE WHEN A.LINE_ID IS NULL THEN '-'
                               WHEN A.LINE_ID = ''    THEN '-'
                               ELSE A.LINE_ID
                          END  AS LINE_ID
                        , ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) AS OPERATION_ID      -- 완성 기준 OPERATION_ID
                        , A.PRODUCTION_TYPE
                        , A.LANE
                        , A.QTY_UOM
                        , STOCK_ATTB_3
                        , DENSE_RANK()OVER (ORDER BY A.SEQ, A.FACTORY_ID, A.AVAILABLE_DATE, A.ITEM_ID, A.QTY) AS STOCK_SEQ
                  FROM   (-- 자재에 대해 STOCK 처리
                          SELECT  A.*, '-' AS STOCK_ATTB_3
                          FROM    SY_SCM_STOCK_H A
                          WHERE   A.CUTOFF_DATE = @v_cutoff_date
                          AND     A.STOCK_TYPE  = 'INVENTORY'
                          AND     A.STORAGE_ID  BETWEEN '1000' AND '1999'
                          AND     ISNULL(A.FP_APPLY_WIPQTY, 0) > 0
                          AND     A.AVAILABLE_DATE >= A.HOLDING_DATE
                          AND     A.AVAILABLE_DATE <= @plan_start_time
                          AND     NOT EXISTS  (
                                                SELECT 1
                                                FROM   TH_MST_INSTANCE_FLOW X
                                                WHERE  X.MASTER_ID = @v_master_id
                                                AND    X.PLAN_ID = @v_plan_id
                                                AND    X.COMPANY_ID = A.COMPANY_ID
                                                AND    X.DIVISION_ID = A.DIVISION_ID
                                                AND    X.SITE_ID = A.SITE_ID
                                                AND    X.ITEM_ID = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                              )
                          UNION   ALL
                          -- INSTANCE 내에 있는 재고 : CELL, PACK, SRS
                          SELECT  A.*, '-' AS STOCK_ATTB_3
                          FROM    SY_SCM_STOCK_H A
                          WHERE   A.CUTOFF_DATE  = @v_cutoff_date
                          AND     A.STOCK_TYPE = 'WIP'
                          AND     A.AVAILABLE_DATE >= A.HOLDING_DATE
                          AND     A.AVAILABLE_DATE <= @plan_start_time
                          AND     ISNULL(A.FP_APPLY_WIPQTY, 0) > 0
                          AND     @v_instance_type IN ('A','S','P')             -- 후공정 아닌애들
                          AND     ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) NOT IN ('A9000', 'A4000')        -- CELL
                          AND     ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) NOT IN ('P9500', 'P5500')        -- PACK
                          AND     ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) NOT IN ('S2000', 'S4000')        -- SRS
                          --AND     A.QTY > 0
                          AND     EXISTS  (
                                            SELECT 1
                                            FROM   TH_MST_INSTANCE_FLOW X
                                            WHERE  X.MASTER_ID = @v_master_id
                                            AND    X.PLAN_ID = @v_plan_id
                                            AND    X.COMPANY_ID = A.COMPANY_ID
                                            AND    X.DIVISION_ID = A.DIVISION_ID
                                            AND    X.SITE_ID = A.SITE_ID
                                            AND    X.ITEM_ID = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                            AND    X.OPERATION_ID = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                          )
                          UNION   ALL
                          -- INSTANCE 내에 있는 재고 : 전공정
                          SELECT  A.*, '-' AS STOCK_ATTB_3
                          FROM    SY_SCM_STOCK_H A
                          WHERE   A.CUTOFF_DATE  = @v_cutoff_date
                          AND     A.STOCK_TYPE = 'WIP'
                          AND     @v_instance_type = 'E1'                    -- 전 공정
                          AND     ISNULL(A.FP_APPLY_WIPQTY, 0) > 0
                          AND     A.AVAILABLE_DATE >= A.HOLDING_DATE
                          AND     A.AVAILABLE_DATE <= @plan_start_time
                          AND     EXISTS  (
                                            SELECT 1
                                            FROM   TH_MST_INSTANCE_FLOW X
                                            WHERE  X.MASTER_ID    = @v_master_id
                                            AND    X.PLAN_ID      = @v_plan_id
                                            AND    X.COMPANY_ID   = A.COMPANY_ID
                                            AND    X.DIVISION_ID  = A.DIVISION_ID
                                            AND    X.SITE_ID      = A.SITE_ID
                                            AND    X.FACTORY_ID   = A.FACTORY_ID
                                            AND    X.ITEM_ID      = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                            AND    X.OPERATION_ID = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                          )
                          AND     NOT EXISTS (
                                              SELECT 1
                                              FROM   (
                                                      SELECT ITEM_ID, FACTORY_ID
                                                           , MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                                      FROM   TH_MST_INSTANCE_FLOW A
                                                      WHERE  MASTER_ID  = @v_master_id
                                                      AND    PLAN_ID    = @v_plan_id
                                                      AND    OPERATION_ID IN ('E2500')
                                                      GROUP  BY 
                                                             ITEM_ID, FACTORY_ID                                        
                                                      UNION  ALL
                                                      -- DPP 에서 COAT 차감했으므로, 대상에서 제외함.
                                                      SELECT ITEM_ID, FACTORY_ID
                                                           , MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                                      FROM   TH_MST_INSTANCE_FLOW A
                                                      WHERE  MASTER_ID  = @v_master_id
                                                      AND    PLAN_ID    = @v_plan_id
                                                      AND    OPERATION_ID IN ('E2000')
                                                      GROUP  BY 
                                                             ITEM_ID, FACTORY_ID                                        
                                                     ) Y
                                              WHERE  Y.ITEM_ID            = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                              AND    Y.FACTORY_ID         = A.FACTORY_ID
                                              AND    Y.MAX_OPERATION_ID   = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                             )
                          UNION   ALL
                          -- INSTANCE 내에 있는 재고 : 후공정 대상
                          SELECT  A.*, '-' AS STOCK_ATTB_3
                          FROM    SY_SCM_STOCK_H A
                          WHERE   A.CUTOFF_DATE  = @v_cutoff_date
                          AND     A.STOCK_TYPE = 'WIP'
                          AND     @v_instance_type = 'E2'    -- 후공정
                          AND     ISNULL(A.FP_APPLY_WIPQTY, 0) > 0
                          AND     A.AVAILABLE_DATE >= A.HOLDING_DATE
                          AND     A.AVAILABLE_DATE <= @plan_start_time
                          AND    EXISTS (
                                          SELECT 1
                                          FROM   TH_DPP_NET_DEMAND XA
                                          WHERE  XA.MASTER_ID = @v_master_id
                                          AND    XA.PLAN_ID   = @v_plan_id
                                          AND    XA.ITEM_ID   = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                         )
                          AND     EXISTS  (
                                            SELECT 1
                                            FROM   TH_MST_INSTANCE_FLOW X
                                            WHERE  X.MASTER_ID = @v_master_id
                                            AND    X.PLAN_ID = @v_plan_id
                                            AND    X.COMPANY_ID = A.COMPANY_ID
                                            AND    X.DIVISION_ID = A.DIVISION_ID
                                            AND    X.SITE_ID = A.SITE_ID
                                            AND    X.ITEM_ID = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                            AND    X.OPERATION_ID = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                          )
                          AND     EXISTS  (
                                            SELECT 1
                                            FROM   (SELECT ITEM_ID, MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                                    FROM   TH_MST_INSTANCE_FLOW
                                                    WHERE  MASTER_ID = @v_master_id
                                                    AND    PLAN_ID = @v_plan_id
                                                    GROUP  BY ITEM_ID
                                                   ) X
                                            WHERE  X.ITEM_ID = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                            AND    X.MAX_OPERATION_ID != ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                          )
                          UNION   ALL
                          -- INSTANCE 외에 있는 재고 : 후공정에 투입되는 대상 ITEM
                          SELECT  A.*, @v_master_id AS STOCK_ATTB_3
                          FROM    SY_SCM_STOCK_H A
                          WHERE   A.CUTOFF_DATE  = @v_cutoff_date
                          AND     A.STOCK_TYPE = 'WIP'
                          AND     @v_instance_type = 'E2'    -- 후공정 아닌애들
                          AND     ISNULL(A.FP_APPLY_WIPQTY, 0) > 0
                          AND     A.AVAILABLE_DATE >= A.HOLDING_DATE
                          AND     A.AVAILABLE_DATE <= @plan_start_time
                          AND    EXISTS (
                                          SELECT 1
                                          FROM   TH_DPP_NET_DEMAND XA
                                          WHERE  XA.MASTER_ID = @v_master_id
                                          AND    XA.PLAN_ID   = @v_plan_id
                                          AND    XA.ITEM_ID   = A.ITEM_ID
                                         )
                          AND     EXISTS (
                                          SELECT 1
                                          FROM   (
                                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
                                                       , MAX(OPERATION_ID) AS OPERATION_ID
                                                  FROM   (
                                                          SELECT A.COMPANY_ID
                                                               , A.DIVISION_ID
                                                               , A.SITE_ID
                                                               , B.PLANT_ID
                                                               , B.FACTORY_ID
                                                               , A.OPERATION_ID
                                                          FROM   SY_SCM_OPERATION_M A,
                                                                 (
                                                                  SELECT B.*, 'E1' AS INSTANCE_TYPE
                                                                  FROM   SY_FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
                                                                         SY_SCM_FACTORY_M         B    -- FACTORY 별 SITE ID
                                                                  WHERE  A.INSTANCE_ID = @v_master_id
                                                                  AND    A.FACTORY_ID = B.FACTORY_ID
                                                                  AND    B.ACTIVE_FLAG = 'Y'
                                                                  AND    @v_instance_type = 'E2'
                                                                 ) B       
                                                          WHERE  A.COMPANY_ID    = B.COMPANY_ID
                                                          AND    A.DIVISION_ID   = B.DIVISION_ID
                                                          AND    A.SITE_ID       = B.SITE_ID
                                                          AND    A.INSTANCE_TYPE = B.INSTANCE_TYPE
                                                          AND    (
                                                                    (B.FACTORY_ID  <> 'E4' AND OPERATION_ID != 'E2500')
                                                                    OR
                                                                    (B.FACTORY_ID   = 'E4')
                                                                 )                   
                                                         ) A
                                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID                        
                                                 ) XB
                                          WHERE  XB.COMPANY_ID  = A.COMPANY_ID
                                          AND    XB.DIVISION_ID = A.DIVISION_ID
                                          AND    XB.SITE_ID     = A.SITE_ID
                                          AND    XB.PLANT_ID    = A.PLANT_ID
                                          AND    XB.FACTORY_ID  = A.FACTORY_ID
                                          AND    XB.OPERATION_ID = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                         )
                         ) A
                 -- ksjeon add ->  MODIFY_FP_APPLY_WIPQTY 수량이 없는건 처리
                 where   a.modify_fp_apply_wipqty is null
                 --->  MODIFY_FP_APPLY_WIPQTY 수량이 있는건을 위에서 처리한것을 제외하고 처리
                  AND    not EXISTS  (
                                      SELECT 1
                                      FROM   TH_MST_STOCK_PLAN X
                                      WHERE  X.MASTER_ID    = @v_master_id
                                      AND    X.PLAN_ID      = @v_plan_id
                                      AND    X.SITE_ID      = A.FACTORY_ID
                                      AND    X.OPERATION_ID = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                      AND    X.ITEM_ID      = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                    )
                 ) A
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
        END      

      END
      ELSE        -- @STOCK_OPTION_VALUE = 'CAL_QTY'
                  -- L 269 IF 문 else
      BEGIN

        BEGIN
        
          SELECT  @v_stock_seq = ISNULL(MAX(STOCK_SEQ),0)
          FROM    TH_MST_STOCK_PLAN
          WHERE   MASTER_ID   = @v_master_id
          AND     PLAN_ID     = @v_plan_id

          -- 일반 STOCK
          INSERT INTO TH_MST_STOCK_PLAN
                  ( MASTER_ID
                  , PLAN_ID
                  , STOCK_SEQ
                  , LOT_ID
                  , ITEM_ID
                  , QTY
                  , RECEIVING_DTTM
                  , STOCK_STATUS
                  , SITE_ID
                  , ROUTE_ID
                  , OPERATION_ID
                  , STOCK_ATTB_1
                  , STOCK_ATTB_2
                  , STOCK_ATTB_3
                  , STOCK_ATTB_4
                  , DESCR
                  , KEY_DATE
                  , INSERT_ID
                  , INSERT_DTTM
                  , UPDATE_ID
                  , UPDATE_DTTM )
          SELECT  DISTINCT  
                    @v_master_id
                  , @v_plan_id
                  , @v_stock_seq + A.STOCK_SEQ AS STOCK_SEQ
                  , 'LOT3_' + @key_date
                           + CONVERT(nvarchar, CONVERT(INT, A.STOCK_SEQ) + 1000000) AS LOT_ID
                  , A.ITEM_ID
                  , A.QTY
                  , CASE WHEN A.AVAILABLE_DATE < @plan_start_time THEN @plan_start_time ELSE A.AVAILABLE_DATE END  AS RECEIVING_DTTM
                  , A.STOCK_TYPE     AS STOCK_STATUS
                  , A.FACTORY_ID     AS SITTE_ID
                  , A.LINE_ID        AS ROUTE_ID
                  , A.OPERATION_ID   AS OPERATION_ID
                  , CASE WHEN ISNULL(A.PRODUCTION_TYPE, '') = ''  THEN 'MASS' ELSE A.PRODUCTION_TYPE END AS STOCK_ATTB_1
                  , CASE WHEN ISNULL(A.LANE, 0) = 0      THEN '0' ELSE CONVERT(NVARCHAR, CEILING(A.LANE))     END AS STOCK_ATTB_2
                  , STOCK_ATTB_3
                  , STOCK_ATTB_3    AS STOCK_ATTB_4
                  , CASE WHEN ISNULL(A.LANE, 0) = 0      THEN '0' ELSE CONVERT(NVARCHAR, CEILING(A.LANE))     END AS DESCR
                  , @key_date AS KEY_DATE
                  , @v_proc_name as INSERT_ID
                  , GETDATE() as INSERT_DTTM
                  , @v_proc_name as UPDATE_ID
                  , getdate() as UPDATE_DTTM
          FROM   (
                  SELECT  A.SEQ
                        , ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)           AS ITEM_ID
                        -- ksjeon
                        , ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.CAL_QTY, 0)) AS QTY
                        --, ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.FP_APPLY_WIPQTY, 0)) AS QTY
                        , A.AVAILABLE_DATE
                        , A.STOCK_TYPE
                        , A.FACTORY_ID
                        -- ksjeon line을 보지 않는다
                        , '-'  AS LINE_ID
  --                      , CASE WHEN A.LINE_ID IS NULL THEN '-'
  --                             WHEN A.LINE_ID = ''    THEN '-'
  --                             ELSE A.LINE_ID
  --                        END  AS LINE_ID
                        , ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) AS OPERATION_ID      -- 완성 기준 OPERATION_ID
                        , A.PRODUCTION_TYPE
                        , A.LANE
                        , A.QTY_UOM
                        , STOCK_ATTB_3
                        , DENSE_RANK()OVER (ORDER BY A.SEQ, A.FACTORY_ID, A.AVAILABLE_DATE, A.ITEM_ID, A.QTY) AS STOCK_SEQ
                  FROM   (-- 자재에 대해 STOCK 처리
                          SELECT  A.*, '-' AS STOCK_ATTB_3
                          FROM    SY_SCM_STOCK_H A
                          WHERE   A.CUTOFF_DATE = @v_cutoff_date
                          AND     A.STOCK_TYPE  = 'INVENTORY'
                          AND     A.STORAGE_ID  BETWEEN '1000' AND '1999'
                          AND     ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.CAL_QTY, 0)) >= 0
                          AND     A.AVAILABLE_DATE >= A.HOLDING_DATE
                          AND     A.AVAILABLE_DATE <= @plan_start_time
                          AND     NOT EXISTS  (
                                                SELECT 1
                                                FROM   TH_MST_INSTANCE_FLOW X
                                                WHERE  X.MASTER_ID = @v_master_id
                                                AND    X.PLAN_ID = @v_plan_id
                                                AND    X.COMPANY_ID = A.COMPANY_ID
                                                AND    X.DIVISION_ID = A.DIVISION_ID
                                                AND    X.SITE_ID = A.SITE_ID
                                                AND    X.ITEM_ID = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                              )
                          UNION   ALL
                          -- INSTANCE 내에 있는 재고 : CELL, PACK, SRS
                          SELECT  A.*, '-' AS STOCK_ATTB_3
                          FROM    SY_SCM_STOCK_H A
                          WHERE   A.CUTOFF_DATE  = @v_cutoff_date
                          AND     A.STOCK_TYPE = 'WIP'
                          AND     A.AVAILABLE_DATE >= A.HOLDING_DATE
                          AND     A.AVAILABLE_DATE <= @plan_start_time
                          AND     ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.CAL_QTY, 0)) >= 0
                          AND     @v_instance_type IN ('A','S','P')             -- 후공정 아닌애들
                          AND     ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) NOT IN ('A9000', 'A4000')        -- CELL
                          AND     ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) NOT IN ('P9500', 'P5500')        -- PACK
                          AND     ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) NOT IN ('S2000')                 -- SRS
                          --AND     A.QTY > 0
                          AND     EXISTS  (
                                            SELECT 1
                                            FROM   TH_MST_INSTANCE_FLOW X
                                            WHERE  X.MASTER_ID = @v_master_id
                                            AND    X.PLAN_ID = @v_plan_id
                                            AND    X.COMPANY_ID = A.COMPANY_ID
                                            AND    X.DIVISION_ID = A.DIVISION_ID
                                            AND    X.SITE_ID = A.SITE_ID
                                            AND    X.ITEM_ID = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                            AND    X.OPERATION_ID = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                          )
                          UNION   ALL
                          -- INSTANCE 내에 있는 재고 : 전공정
                          SELECT  A.*, '-' AS STOCK_ATTB_3
                          FROM    SY_SCM_STOCK_H A
                          WHERE   A.CUTOFF_DATE  = @v_cutoff_date
                          AND     A.STOCK_TYPE = 'WIP'
                          AND     @v_instance_type = 'E1'                    -- 전 공정
                          AND     ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.CAL_QTY, 0)) >= 0
                          AND     A.AVAILABLE_DATE >= A.HOLDING_DATE
                          AND     A.AVAILABLE_DATE <= @plan_start_time
                          AND     EXISTS  (
                                            SELECT 1
                                            FROM   TH_MST_INSTANCE_FLOW X
                                            WHERE  X.MASTER_ID    = @v_master_id
                                            AND    X.PLAN_ID      = @v_plan_id
                                            AND    X.COMPANY_ID   = A.COMPANY_ID
                                            AND    X.DIVISION_ID  = A.DIVISION_ID
                                            AND    X.SITE_ID      = A.SITE_ID
                                            AND    X.FACTORY_ID   = A.FACTORY_ID
                                            AND    X.ITEM_ID      = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                            AND    X.OPERATION_ID = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                          )
                          AND     NOT EXISTS (
                                              SELECT 1
                                              FROM   (
                                                      SELECT ITEM_ID, FACTORY_ID
                                                           , MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                                      FROM   TH_MST_INSTANCE_FLOW A
                                                      WHERE  MASTER_ID  = @v_master_id
                                                      AND    PLAN_ID    = @v_plan_id
                                                      AND    OPERATION_ID IN ('E2500')
                                                      GROUP  BY 
                                                             ITEM_ID, FACTORY_ID                                        
                                                      UNION  ALL
                                                      -- DPP 에서 COAT 차감했으므로, 대상에서 제외함.
                                                      SELECT ITEM_ID, FACTORY_ID
                                                           , MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                                      FROM   TH_MST_INSTANCE_FLOW A
                                                      WHERE  MASTER_ID  = @v_master_id
                                                      AND    PLAN_ID    = @v_plan_id
                                                      AND    OPERATION_ID IN ('E2000')
                                                      GROUP  BY 
                                                             ITEM_ID, FACTORY_ID                                        
                                                     ) Y
                                              WHERE  Y.ITEM_ID            = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                              AND    Y.FACTORY_ID         = A.FACTORY_ID
                                              AND    Y.MAX_OPERATION_ID   = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                             )
                          UNION   ALL
                          -- INSTANCE 내에 있는 재고 : 후공정 대상
                          SELECT  A.*, '-' AS STOCK_ATTB_3
                          FROM    SY_SCM_STOCK_H A
                          WHERE   A.CUTOFF_DATE  = @v_cutoff_date
                          AND     A.STOCK_TYPE = 'WIP'
                          AND     @v_instance_type = 'E2'    -- 후공정
                          AND     ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.CAL_QTY, 0)) >= 0
                          AND     A.AVAILABLE_DATE >= A.HOLDING_DATE
                          AND     A.AVAILABLE_DATE <= @plan_start_time
                          AND    EXISTS (
                                          SELECT 1
                                          FROM   TH_DPP_NET_DEMAND XA
                                          WHERE  XA.MASTER_ID = @v_master_id
                                          AND    XA.PLAN_ID   = @v_plan_id
                                          AND    XA.ITEM_ID   = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                         )
                          AND     EXISTS  (
                                            SELECT 1
                                            FROM   TH_MST_INSTANCE_FLOW X
                                            WHERE  X.MASTER_ID = @v_master_id
                                            AND    X.PLAN_ID = @v_plan_id
                                            AND    X.COMPANY_ID = A.COMPANY_ID
                                            AND    X.DIVISION_ID = A.DIVISION_ID
                                            AND    X.SITE_ID = A.SITE_ID
                                            AND    X.ITEM_ID = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                            AND    X.OPERATION_ID = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                          )
                          AND     EXISTS  (
                                            SELECT 1
                                            FROM   (SELECT ITEM_ID, MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                                    FROM   TH_MST_INSTANCE_FLOW
                                                    WHERE  MASTER_ID = @v_master_id
                                                    AND    PLAN_ID = @v_plan_id
                                                    GROUP  BY ITEM_ID
                                                   ) X
                                            WHERE  X.ITEM_ID = ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)
                                            AND    X.MAX_OPERATION_ID != ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                          )
                          UNION   ALL
                          -- INSTANCE 외에 있는 재고 : 후공정에 투입되는 대상 ITEM
                          SELECT  A.*, @v_master_id AS STOCK_ATTB_3
                          FROM    SY_SCM_STOCK_H A
                          WHERE   A.CUTOFF_DATE  = @v_cutoff_date
                          AND     A.STOCK_TYPE = 'WIP'
                          AND     @v_instance_type = 'E2'    -- 후공정 아닌애들
                          AND     ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.CAL_QTY, 0)) >= 0
                          AND     A.AVAILABLE_DATE >= A.HOLDING_DATE
                          AND     A.AVAILABLE_DATE <= @plan_start_time
                          AND    EXISTS (
                                          SELECT 1
                                          FROM   TH_DPP_NET_DEMAND XA
                                          WHERE  XA.MASTER_ID = @v_master_id
                                          AND    XA.PLAN_ID   = @v_plan_id
                                          AND    XA.ITEM_ID   = A.ITEM_ID
                                         )
                          AND     EXISTS (
                                          SELECT 1
                                          FROM   (
                                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
                                                       , MAX(OPERATION_ID) AS OPERATION_ID
                                                  FROM   (
                                                          SELECT A.COMPANY_ID
                                                               , A.DIVISION_ID
                                                               , A.SITE_ID
                                                               , B.PLANT_ID
                                                               , B.FACTORY_ID
                                                               , A.OPERATION_ID
                                                          FROM   SY_SCM_OPERATION_M A,
                                                                 (
                                                                  SELECT B.*, 'E1' AS INSTANCE_TYPE
                                                                  FROM   SY_FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
                                                                         SY_SCM_FACTORY_M         B    -- FACTORY 별 SITE ID
                                                                  WHERE  A.INSTANCE_ID = @v_master_id
                                                                  AND    A.FACTORY_ID = B.FACTORY_ID
                                                                  AND    B.ACTIVE_FLAG = 'Y'
                                                                  AND    @v_instance_type = 'E2'
                                                                 ) B       
                                                          WHERE  A.COMPANY_ID    = B.COMPANY_ID
                                                          AND    A.DIVISION_ID   = B.DIVISION_ID
                                                          AND    A.SITE_ID       = B.SITE_ID
                                                          AND    A.INSTANCE_TYPE = B.INSTANCE_TYPE
                                                          AND    (
                                                                    (B.FACTORY_ID  <> 'E4' AND OPERATION_ID != 'E2500')
                                                                    OR
                                                                    (B.FACTORY_ID   = 'E4')
                                                                 )                   
                                                         ) A
                                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID                        
                                                 ) XB
                                          WHERE  XB.COMPANY_ID  = A.COMPANY_ID
                                          AND    XB.DIVISION_ID = A.DIVISION_ID
                                          AND    XB.SITE_ID     = A.SITE_ID
                                          AND    XB.PLANT_ID    = A.PLANT_ID
                                          AND    XB.FACTORY_ID  = A.FACTORY_ID
                                          AND    XB.OPERATION_ID = ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)
                                         )
                         ) A
                 -- ksjeon add -> option이 cal_qty 인경우 아래 조건이 대상임 
                 where ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.CAL_QTY, 0)) >= 0          
                 ) A
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
        END

      END
      -- L 269 IF 문 end

-- Stock UI 에 MODIFY_FP_APPLY_WIPQTY, CAL_QTY 컬럼 추가로 인한 로직 변경 반영 END
-----------------------------------------------------------------------------      
-----------------------------------------------------------------------------      
     
      -- AGING 관련 STOCK 차감.
      IF CHARINDEX('PACK', @v_master_id) > 0
      BEGIN

        SET @v_table_name = 'TH_MST_STOCK_PLAN-STOCK_AGING'

        SELECT  @v_stock_seq = ISNULL(MAX(STOCK_SEQ),0)
        FROM    TH_MST_STOCK_PLAN
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_plan_id
      
        INSERT INTO TH_MST_STOCK_PLAN
                ( MASTER_ID
                , PLAN_ID
                , STOCK_SEQ
                , LOT_ID
                , ITEM_ID
                , QTY
                , RECEIVING_DTTM
                , STOCK_STATUS
                , SITE_ID
                , ROUTE_ID
                , OPERATION_ID
                , STOCK_ATTB_1
                , STOCK_ATTB_2
                , KEY_DATE
                , INSERT_ID
                , INSERT_DTTM
                , UPDATE_ID
                , UPDATE_DTTM )
        SELECT  DISTINCT  
                @v_master_id
              , @v_plan_id
              , @v_stock_seq + SEQ AS STOCK_SEQ
              , 'LOT_AGING_' + @key_date
                       + CONVERT(nvarchar, CONVERT(INT, SEQ) + 1000000) AS LOT_ID
              , ITEM_ID
              , QTY
              , CASE WHEN A.AVAILABLE_DATE < @plan_start_time THEN @plan_start_time ELSE AVAILABLE_DATE END  AS RECEIVING_DTTM
              , 'AGING'          AS STOCK_STATUS
              , FACTORY_ID       AS SITTE_ID
              , '-'              AS ROUTE_ID
              , 'AGING'          AS OPERATION_ID
              , CASE WHEN ISNULL(PRODUCTION_TYPE, '') = ''  THEN 'MASS' ELSE PRODUCTION_TYPE END AS STOCK_ATTB_1
              , '0'       AS STOCK_ATTB_2
              , @key_date AS KEY_DATE
              , @v_proc_name as INSERT_ID
              , GETDATE() as INSERT_DTTM
              , @v_proc_name as UPDATE_ID
              , getdate() as UPDATE_DTTM
        FROM  (
                SELECT FACTORY_ID,
                       DENSE_RANK() OVER (ORDER BY SEQ, ITEM_ID, FACTORY_ID, AVAILABLE_DATE, QTY) AS SEQ,  
                       ITEM_ID, PRODUCTION_TYPE, AVAILABLE_DATE, QTY, QTY_UOM               
                FROM   SY_SCM_AGING_STOCK_H A
                WHERE  A.CUTOFF_DATE = CONVERT(DATE, @key_date)
                AND    A.QTY > 0
                AND    EXISTS (
                                SELECT 1
                                FROM   (
                                        SELECT DISTINCT COMPANY_ID, SITE_ID
                                        FROM   SY_FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
                                               SY_SCM_FACTORY_M B            -- FACTORY 별 SITE ID
                                        WHERE  A.INSTANCE_ID = @v_master_id
                                        AND    A.FACTORY_ID = B.FACTORY_ID
                                       ) X
                                WHERE  X.COMPANY_ID = A.COMPANY_ID
                                AND    X.SITE_ID = A.SITE_ID
                              )
               ) A

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        SET @v_table_name = 'TH_MST_ITEM-FINITE=365'

        UPDATE TH_MST_ITEM
        SET    TH_MST_ITEM.IS_FINITE        = 'Y'
             , TH_MST_ITEM.FINITE_TERM      = 365
             , TH_MST_ITEM.FINITE_TERM_UOM  = 'DAY'
        FROM   TH_MST_ITEM A
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    A.ITEM_TYPE  = 'R'
        AND    EXISTS (
                        SELECT 1
                        FROM   TH_MST_STOCK_PLAN X
                        WHERE  X.MASTER_ID    = A.MASTER_ID
                        AND    X.PLAN_ID      = A.PLAN_ID
                        AND    X.ITEM_ID      = A.ITEM_ID
                        AND    X.STOCK_STATUS = 'AGING'
                      )

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
          
      -- 전극 전공정 완성을 후공정 STOCK 반영
      BEGIN

        SET @v_table_name = 'TH_MST_STOCK_PLAN'
        SET @v_stock_seq = 0
        
        SELECT  @v_stock_seq = ISNULL(MAX(STOCK_SEQ),0)
        FROM    TH_MST_STOCK_PLAN
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_plan_id

        INSERT INTO TH_MST_STOCK_PLAN
                ( MASTER_ID
                , PLAN_ID
                , STOCK_SEQ
                , LOT_ID
                , ITEM_ID
                , QTY
                , RECEIVING_DTTM
                , STOCK_STATUS
                , SITE_ID
                , ROUTE_ID
                , OPERATION_ID
                , STOCK_ATTB_1
                , STOCK_ATTB_2
                , STOCK_ATTB_3
                , STOCK_ATTB_4
                , DESCR
                , KEY_DATE
                , INSERT_ID
                , INSERT_DTTM
                , UPDATE_ID
                , UPDATE_DTTM )
        SELECT  DISTINCT  
                  @v_master_id
                , @v_plan_id
                , @v_stock_seq + (ROW_NUMBER() OVER (ORDER BY RECEIVING_TIME, SCP_TARGET_ID)) AS STOCK_SEQ
                , A.SCP_TARGET_ID +'_'+ A.ITEM_ID 
                                  +'_'+ ( CASE WHEN A.FACTORY_ID IS NULL THEN 'ZZ'
                                               WHEN A.FACTORY_ID = ''    THEN 'ZZ'
                                               ELSE A.FACTORY_ID
                                          END  ) AS LOT_ID
                , A.ITEM_ID       AS ITEM_ID
                , QTY             AS QTY
                , CASE WHEN A.RECEIVING_TIME < @plan_start_time THEN @plan_start_time ELSE A.RECEIVING_TIME END  AS RECEIVING_DTTM
                , 'STOCK'         AS STOCK_STATUS
                , A.FACTORY_ID    AS SITTE_ID
                , '-'             AS ROUTE_ID
                , A.OPERATION_ID  AS OPERATION_ID
                , CASE WHEN ISNULL(A.PRODUCTION_TYPE, '') = '' THEN 'MASS' ELSE A.PRODUCTION_TYPE END AS STOCK_ATTB_1
                , CASE WHEN ISNULL(A.LANE_QTY, 0) = 0 THEN '0' ELSE CONVERT(NVARCHAR, CEILING(CONVERT(NUMERIC, A.LANE_QTY))) END AS STOCK_ATTB_2
                , SCP_PLAN_ID     AS STOCK_ATTB_3
                , @v_master_id    AS STOCK_ATTB_4
                , CASE WHEN ISNULL(A.LANE_QTY, 0) = 0 THEN '0' ELSE CONVERT(NVARCHAR, CEILING(CONVERT(NUMERIC, A.LANE_QTY))) END AS DESCR
                , @key_date       AS KEY_DATE
                , @v_proc_name    AS INSERT_ID
                , GETDATE()       AS INSERT_DTTM
                , @v_proc_name    AS UPDATE_ID
                , getdate()       AS UPDATE_DTTM
        FROM   SY_FP_DAILY_INSTANCE_STOCK_H A,
               SY_SCM_OPERATION_M           B
        WHERE  A.INSTANCE_ID = @v_master_id
        --AND    A.INSTANCE_DATE = CONVERT(DATE, @key_date)       -- RELEASE 버전은 당일꺼가 아니기 때문에 주석처리
        AND    A.COMPANY_ID = B.COMPANY_ID
        AND    A.DIVISION_ID = B.DIVISION_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        AND    A.RECEIVING_TIME >= CONVERT(DATE, @key_date)       -- 당일 이후꺼
        -- RELEASE 된 버전을 가지고 올때,,, INSTANCE 분리 후
        AND    EXISTS (
                        SELECT 1
                        FROM   (
                                SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.DIVISION_ID, A.FACTORY_ID
                                     , MAX(AMEND_PLAN_ID) AS AMEND_PLAN_ID
                                FROM   SY_FP_RELEASE_PLAN_INFO_H A,
                                       (
                                        SELECT INSTANCE_ID
                                             , DIVISION_ID
                                             , FACTORY_ID
                                             , MAX(INSTANCE_DATE) AS INSTANCE_DATE
                                        FROM   SY_FP_RELEASE_PLAN_INFO_H A
                                        WHERE  A.INSTANCE_DATE <= @key_date      -- 당일 이전 RELEASE 꺼,, 먼저 한 동은 그걸 끌고 오기 때문
                                        GROUP  BY INSTANCE_ID, DIVISION_ID, FACTORY_ID
                                       ) B
                                WHERE  A.INSTANCE_ID    = B.INSTANCE_ID
                                AND    A.INSTANCE_DATE  = B.INSTANCE_DATE
                                AND    A.DIVISION_ID    = B.DIVISION_ID
                                AND    A.FACTORY_ID     = B.FACTORY_ID
                                GROUP  BY A.INSTANCE_ID, A.INSTANCE_DATE, A.DIVISION_ID, A.FACTORY_ID
                               ) X
                        WHERE  A.SCP_PLAN_ID  = X.AMEND_PLAN_ID
                        --AND    A.CUSTOMER_ID  = X.FACTORY_ID        -- INSTANCE DEMAND
                        AND    A.FACTORY_ID   = X.FACTORY_ID
                      )
        
        -- MAX로 가지고 올때 .. INSTANCE 분리 전
        /*
        AND    A.SCP_PLAN_ID = (
                                SELECT MAX(SCP_PLAN_ID) 
                                FROM   SY_FP_DAILY_INSTANCE_STOCK_H
                                WHERE  INSTANCE_ID = @v_master_id
                                AND    INSTANCE_DATE = CONVERT(DATE, @key_date)
                               )
        */
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      -- SHIPMENT ELEC으로 올라오는 SITE이동 정보를 CELL 투입 정보로 전환 반영 
      BEGIN

        SET @v_table_name = 'TH_MST_STOCK_PLAN'
        SET @v_stock_seq = 0
        
        SELECT  @v_stock_seq = ISNULL(MAX(STOCK_SEQ),0)
        FROM    TH_MST_STOCK_PLAN
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_plan_id

        INSERT INTO TH_MST_STOCK_PLAN
                ( MASTER_ID
                , PLAN_ID
                , STOCK_SEQ
                , LOT_ID
                , ITEM_ID
                , QTY
                , RECEIVING_DTTM
                , STOCK_STATUS
                , SITE_ID
                , ROUTE_ID
                , OPERATION_ID
                , STOCK_ATTB_1
                , STOCK_ATTB_2
                , STOCK_ATTB_3
                , STOCK_ATTB_4
                , DESCR
                , KEY_DATE
                , INSERT_ID
                , INSERT_DTTM
                , UPDATE_ID
                , UPDATE_DTTM )
        SELECT  @v_master_id
            		, @V_PLAN_ID
            		, @v_stock_seq + (ROW_NUMBER() OVER (ORDER BY DATEADD(DD, D.OUT_BUFFER_DAY + D.OUTBOUND_DAY + D.SHIP_PORT_DAY + D.VOYAGE_DAY + D.INBOUND_DAY + D.IN_BUFFER_DAY, SHIP_DATE), SCP_TARGET_ID)) AS STOCK_SEQ
            		, 'LOT_ID' AS LOT_ID
            		, ITEM_ID
            		, SHIP_QTY
            		, DATEADD(DD, D.OUT_BUFFER_DAY + D.OUTBOUND_DAY + D.SHIP_PORT_DAY + D.VOYAGE_DAY + D.INBOUND_DAY + D.IN_BUFFER_DAY, SHIP_DATE) AS RECEIVING_DTTM
            		, 'STOCK_SHIP' AS STOCK_STATUS
            		, '-' AS SITE_ID
            		, '-' AS ROUTE_ID
            		, '-' AS OPERATION_ID
            		, CASE WHEN ISNULL(A.PRODUCTION_TYPE, '') = '' THEN 'MASS' ELSE A.PRODUCTION_TYPE END AS STOCK_ATTB_1
            		, 0 AS STOCK_ATTB_2
            		, SCP_PLAN_ID AS STOCK_ATTB_3
            		, @v_master_id AS STOCK_ATTB_4
            		, 0 AS DESCR
            		, @key_date       AS KEY_DATE
                , @v_proc_name    AS INSERT_ID
                , GETDATE()       AS INSERT_DTTM
                , @v_proc_name    AS UPDATE_ID
                , getdate()       AS UPDATE_DTTM
            FROM SY_FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H A,
                 SY_SCM_PLANT_M B,
                (SELECT A.INSTANCE_ID, B.SITE_ID, B.PLANT_ID
            	   FROM SY_FP_INSTANCE_FACTORY_M A,
            		      SY_SCM_FACTORY_M B
            	   WHERE 1=1
            	   AND   A.FACTORY_ID = B.FACTORY_ID) C,
	               SY_SCM_SHIPMENT_M D
            WHERE 1=1
            AND A.SCP_PLAN_ID = @v_ship_elec_plan_id
            AND A.TO_PLANT_ID = B.PLANT_ID
            AND A.SITE_ID != B.SITE_ID
            AND @v_master_id = C.INSTANCE_ID
            AND A.SITE_ID = D.TO_SITE_ID
            AND B.SITE_ID = D.SITE_ID
            AND A.TO_PLANT_ID = D.PLANT_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END
      /*
      -- HALF SLIT STOCK 처리
      BEGIN
      
        UPDATE TH_MST_STOCK_PLAN
        SET    TH_MST_STOCK_PLAN.OPERATION_ID = 'E2500'
        FROM   TH_MST_STOCK_PLAN A,
               SY_SCM_ITEM_LANE_M B
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    A.ITEM_ID    = B.ITEM_ID
        AND    A.SITE_ID    = B.FACTORY_ID
        AND    B.HALF_SLIT_FLAG = 'Y'
      
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END
      */

      -- E2000 에서 차감된 애들은 가상 DEMAND 를 만들어서 STOCK 처리한다.
      -- E2500 생산 스케쥴 생성을 위해서
      BEGIN

        SET @v_table_name = 'TH_DPP_NET_DEMAND'

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
                 ,KEY_DATE
                 ,INSERT_ID
                 ,INSERT_DTTM
                 ,UPDATE_ID
                 ,UPDATE_DTTM)
        SELECT 
              A.INSTANCE_ID AS MASTER_ID
            , A.DPP_PLAN_ID AS PLAN_ID
             ,A.SCP_TARGET_ID + '::' + 'STOCK' + CONVERT(NVARCHAR, 10000 + STOCK_SEQ) 
                              + '::' + CONVERT(NVARCHAR, 100 + INT)       AS NET_DEMAND_ID
            , A.SCP_TARGET_ID   AS DEMAND_ID
            , NULL              AS PRODUCTION_ORDER_ID
            , A.ITEM_ID         AS SALES_MODEL
            , A.ITEM_ID
            , CASE WHEN INT = DEMAND_CNT AND B.QTY % B.APPLY_LOT_SIZE = 0 THEN  B.APPLY_LOT_SIZE
                   WHEN INT = DEMAND_CNT AND B.QTY % B.APPLY_LOT_SIZE > 0 THEN  B.QTY % B.APPLY_LOT_SIZE
                   ELSE B.APPLY_LOT_SIZE
              END  AS QTY
             ,CONVERT(DATE, @plan_start_time) AS DUE_DATE
             ,CONVERT(DATE, @plan_start_time) AS SHIPPING_DATE
             ,CONVERT(DATE, @plan_end_time)   AS DUE_FENCE_DATE
            , A.MFG_WEEK
            ,CONVERT(DATE, @plan_start_time) AS SPLIT_DATE
            , 'STOCK' PO_TYPE
            , A.PRODUCTION_TYPE   AS ORDER_TYPE
            , '' FROM_SITE_ID
            , '' TO_SITE_ID
            , A.MARKET
            , '0:0:000' DEMAND_GROUP_PRIORITY
            , '0:0:' + CONVERT(NVARCHAR, 10000 + STOCK_SEQ) DEMAND_PRIORITY
            , 1 EARLY_PRODUCING_TERM
            , 'DAY' EARLY_PRODUCING_TERM_UOM
            , A.KEY_DATE
            , A.INSERT_ID
            , A.INSERT_TIME
            , A.UPDATE_ID
            , A.UPDATE_TIME
        FROM   TH_MST_SCM_DEMAND A,
               (
                SELECT *
                FROM   (
                        SELECT A.*, B.APPLY_LOT_SIZE,
                               CEILING(QTY / B.APPLY_LOT_SIZE) AS DEMAND_CNT
                        FROM   TH_MST_SCM_STOCK_DEMAND A,
                               TH_MST_SCM_DEMAND_LOT B
                        WHERE  A.MASTER_ID = @v_master_id
                        AND    A.PLAN_ID = @v_plan_id
                        AND    A.PLAN_ID = B.DPP_PLAN_ID
                        AND    A.FACTORY_ID = B.FACTORY_ID
                        AND    A.ITEM_ID = B.ITEM_ID
                       ) A,
                       COPYT B
                WHERE  DEMAND_CNT >= INT       
               ) B
        WHERE  A.INSTANCE_ID = @v_master_id
        AND    A.DPP_PLAN_ID = @v_plan_id
        AND    A.SCP_TARGET_ID = B.SCP_TARGET_ID
                
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        SET @v_table_name = 'TH_MST_STOCK_PLAN'
      
        SELECT  @v_stock_seq = ISNULL(MAX(STOCK_SEQ),0)
        FROM    TH_MST_STOCK_PLAN
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_plan_id

        INSERT INTO TH_MST_STOCK_PLAN
                ( MASTER_ID
                , PLAN_ID
                , STOCK_SEQ
                , LOT_ID
                , ITEM_ID
                , QTY
                , RECEIVING_DTTM
                , STOCK_STATUS
                , SITE_ID
                , ROUTE_ID
                , OPERATION_ID
                , STOCK_ATTB_1
                , STOCK_ATTB_2
                , STOCK_ATTB_3
                , STOCK_ATTB_4
                , STOCK_ATTB_5
                , DESCR
                , KEY_DATE
                , INSERT_ID
                , INSERT_DTTM
                , UPDATE_ID
                , UPDATE_DTTM )
        SELECT  DISTINCT  
                  @v_master_id
                , @v_plan_id
                , @v_stock_seq + A.SEQ AS STOCK_SEQ
                , 'LOT_STD_' + @key_date
                         + CONVERT(nvarchar, CONVERT(INT, A.STOCK_SEQ) + 1000000) AS LOT_ID
                , A.ITEM_ID
                , CASE WHEN INT = DEMAND_CNT AND A.QTY % A.APPLY_LOT_SIZE = 0 THEN  A.APPLY_LOT_SIZE
                       WHEN INT = DEMAND_CNT AND A.QTY % A.APPLY_LOT_SIZE > 0 THEN  A.QTY % A.APPLY_LOT_SIZE
                       ELSE A.APPLY_LOT_SIZE
                  END  AS QTY
                , @plan_start_time AS RECEIVING_DTTM
                , 'WIP'            AS STOCK_STATUS
                , A.FACTORY_ID     AS SITTE_ID
                , '-'              AS ROUTE_ID
                , A.OPERATION_ID   AS OPERATION_ID
                , 'MASS'           AS STOCK_ATTB_1
                , CEILING(B.LANE_QTY)   AS STOCK_ATTB_2
                , '-'             AS STOCK_ATTB_3
                , '-'             AS STOCK_ATTB_4
                , A.NET_DEMAND_ID  AS STOCK_ATTB_5
                , CEILING(B.LANE_QTY)      AS  DESCR
                , @key_date AS KEY_DATE
                , @v_proc_name as INSERT_ID
                , GETDATE() as INSERT_DTTM
                , @v_proc_name as UPDATE_ID
                , getdate() as UPDATE_DTTM
        FROM   (
                SELECT A.*, 
                       A.SCP_TARGET_ID + '::' + 'STOCK' + CONVERT(NVARCHAR, 10000 + STOCK_SEQ) 
                                       + '::' + CONVERT(NVARCHAR, 100 + INT)       AS NET_DEMAND_ID,
                       B.INT, 
                       DENSE_RANK() OVER (ORDER BY A.STOCK_SEQ, INT) AS SEQ
                FROM   (
                        SELECT A.*, B.APPLY_LOT_SIZE,
                               CEILING(QTY / B.APPLY_LOT_SIZE) AS DEMAND_CNT
                        FROM   TH_MST_SCM_STOCK_DEMAND A,
                               TH_MST_SCM_DEMAND_LOT B
                        WHERE  A.MASTER_ID = @v_master_id
                        AND    A.PLAN_ID = @v_plan_id
                        AND    A.PLAN_ID = B.DPP_PLAN_ID
                        AND    A.FACTORY_ID = B.FACTORY_ID
                        AND    A.ITEM_ID = B.ITEM_ID
                       ) A,
                       COPYT B
                WHERE  DEMAND_CNT >= INT
               ) A,
               (
                SELECT FACTORY_ID, ITEM_ID, MAX(ITEM_LANE_QTY) AS LANE_QTY 
                FROM   TH_MST_ITEM_LANE
                WHERE  MASTER_ID = @v_master_id
                AND    PLAN_ID = @v_plan_id
                GROUP  BY FACTORY_ID, ITEM_ID
               ) B
        WHERE  A.ITEM_ID = B.ITEM_ID
        AND    A.FACTORY_ID = B.FACTORY_ID
                
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END

      -- 강제 LINE 제약 STOCK 설정
      -- 전 세계 공통 제약 반영
      BEGIN

        SET @v_table_name = 'TH_MST_STOCK_PLAN - ROUTE_ID = "-"'
        
        UPDATE TH_MST_STOCK_PLAN
        SET    ROUTE_ID = '-'
        WHERE  MASTER_iD = @v_master_id
        AND    PLAN_ID   = @v_plan_id
        AND    ROUTE_ID != '-'
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      END
        
          
      IF @@TRANCOUNT > 0
        COMMIT WORK 
    END;
    
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
