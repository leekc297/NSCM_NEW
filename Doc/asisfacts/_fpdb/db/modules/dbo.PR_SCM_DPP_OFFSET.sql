CREATE PROCEDURE [dbo].[PR_SCM_DPP_OFFSET]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_DPP_OFFSET                                                         **/
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
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
/***********************************************************************************************/
/*
  EXEC PR_SCM_DPP_OFFSET
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime
  DECLARE @plan_week        nvarchar(10)
  DECLARE @v_daydiff        Integer

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_DPP_OFFSET'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)
  
  DECLARE @v_demand_target  nvarchar(30)
  DECLARE @v_cutoff_date    date
  DECLARE @v_prod_plan_id   nvarchar(30)
  DECLARE @v_ship_plan_id   nvarchar(30)
  DECLARE @v_srs_plan_id    nvarchar(30)

  -- ksjeon add  20170823
  -- FP_APPLY_WIPQTY or CAL_QTY ( 이론재고 사용여부 옵션 )
  DECLARE @STOCK_OPTION_VALUE nvarchar(50)
  
  DECLARE @v_week_first_date    date
  
  DECLARE @v_stock_demand_seq int = 0

  DECLARE @n_loop           Integer
  
  DECLARE @sysdate          DATETIME2 = GETDATE()

  DECLARE @v_temp1        nvarchar(1000)
  DECLARE @v_temp2        nvarchar(1000)
  
  -- TEMP TABLE Variable Define
  DECLARE @T_OFFSET TABLE   (
                                  COMPANY_ID          nvarchar(30)
                                , DIVISION_ID         nvarchar(30)
                                , SITE_ID             nvarchar(30)
                                , PLANT_ID            nvarchar(30)
                                , INSTANCE_ID         nvarchar(30)
                                , DPP_PLAN_ID         nvarchar(30)
                                , SCP_PLAN_ID         nvarchar(30)
                                , SCP_TARGET_ID       nvarchar(150)
                                , ITEM_ID             nvarchar(150)
                                , PRODUCTION_TYPE     nvarchar(10)
                                , MFG_WEEK            nvarchar(10)
                                , MFG_QTY             numeric(20,10)
                                , OFFSET_SEQ          Integer
                                , OFFSET_TYPE         nvarchar(30)
                                , INIT_QTY            numeric(20,10)
                                , OFFSET_QTY          numeric(20,10)
                                , REMAIN_QTY          numeric(20,10)
                                , WORK_ORDER_SPL_ID   nvarchar(150)
                                , WORK_ORDER_ID       nvarchar(150)
                                --, FACTORY_ID          nvarchar(30)
                                , STORAGE_ID          nvarchar(30)
                                --, INVOICE_ID          nvarchar(30)
                                , TARGET_TYPE         nvarchar(30)
                                )

  DECLARE
    @offset$scp_target_id       nvarchar(150), 
    @offset$qty                 numeric(20,10),
    @offset$minus_qty           numeric(20,10),
    @offset$mfg_qty             numeric(20,10)
    
  DECLARE @v_offset_seq integer

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
              @v_daydiff = DAYDIFF,
              @v_cutoff_date = PLAN_DATE,
              @plan_week = WEEK,
              @v_prod_plan_id = SCP_PRODUCT_PLAN_ID,
              @v_ship_plan_id = SCP_SHIPMENT_PLAN_ID,
              @v_srs_plan_id  = SCP_SRS_PLAN_ID              
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM,
                     DATEDIFF(MINUTE,CONVERT(DATE,PLAN_START_DTTM), PLAN_START_DTTM) AS DAYDIFF,
                     PLAN_DATE,
                     WEEK,
                     SCP_PRODUCT_PLAN_ID,
                     SCP_SHIPMENT_PLAN_ID,
                     SCP_SRS_PLAN_ID                     
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

      -- 주초 일자 구하기
      SELECT @v_week_first_date = MIN(B.DATE_ID)          -- 당주 첫날
      FROM   SY_SCM_SYS_CALENDAR_M A,
             SY_SCM_SYS_CALENDAR_M B
      WHERE  A.DATE_ID = CONVERT(DATE, @v_cutoff_date)    -- 당일
      AND    A.WEEK = B.WEEK                              -- 당주
      
      --LOG 생성
      SET @v_message  = '@v_week_first_date : ' + CONVERT(nvarchar, @v_week_first_date, 112)
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

    -- OFFSET DATA DELETE
    BEGIN

      DELETE FROM TH_BUF_SCM_OFFSET_GR        WHERE CUTOFF_DATE <= DATEADD(DAY, -14, @v_cutoff_date)
      
      DELETE FROM TH_BUF_SCM_OFFSET_GI        WHERE CUTOFF_DATE <= DATEADD(DAY, -14, @v_cutoff_date)
    
      DELETE FROM TH_BUF_SCM_OFFSET_INV       WHERE CUTOFF_DATE <= DATEADD(DAY, -14, @v_cutoff_date)
      
      DELETE FROM TH_BUF_SCM_OFFSET_AGING     WHERE CUTOFF_DATE <= DATEADD(DAY, -14, @v_cutoff_date)
      
      DELETE FROM TH_BUF_SCM_OFFSET_WIP_GR    WHERE CUTOFF_DATE <= DATEADD(DAY, -14, @v_cutoff_date)
      
      DELETE FROM TH_BUF_SCM_OFFSET_WIP       WHERE CUTOFF_DATE <= DATEADD(DAY, -14, @v_cutoff_date)
      
      DELETE FROM TH_BUF_SCM_OFFSET_STOCK_GR  WHERE CUTOFF_DATE <= DATEADD(DAY, -14, @v_cutoff_date)

      DELETE FROM TH_BUF_SCM_OFFSET_STOCK     WHERE CUTOFF_DATE <= DATEADD(DAY, -14, @v_cutoff_date)

      DELETE FROM TH_BUF_SCM_OFFSET_HIS       WHERE CUTOFF_DATE <= DATEADD(DAY, -14, @v_cutoff_date)
    
    
      DELETE FROM TH_BUF_SCM_OFFSET_GR        WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id
      
      DELETE FROM TH_BUF_SCM_OFFSET_GI        WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id
    
      DELETE FROM TH_BUF_SCM_OFFSET_INV       WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id
      
      DELETE FROM TH_BUF_SCM_OFFSET_AGING     WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id
      
      DELETE FROM TH_BUF_SCM_OFFSET_WIP_GR    WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id

      DELETE FROM TH_BUF_SCM_OFFSET_WIP       WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id

      DELETE FROM TH_BUF_SCM_OFFSET_STOCK_GR  WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id

      DELETE FROM TH_BUF_SCM_OFFSET_STOCK     WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id

      DELETE FROM TH_BUF_SCM_OFFSET_HIS       WHERE INSTANCE_ID = @v_master_id AND DPP_PLAN_ID = @v_plan_id

    END
    
    BEGIN
    
      SET @v_table_name = 'TH_BUF_SCM_DEMAND'
      SET @n_row_count = 0

      UPDATE TH_BUF_SCM_DEMAND
      SET    OFFSET_INVENTORY_QTY = 0,
             OFFSET_GI_QTY = 0    
      WHERE  DPP_PLAN_ID = @v_plan_id

      SET @n_row_count += @@ROWCOUNT
      
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      SET @v_table_name = 'TH_BUF_SCM_OFFSET_HIS'
      SET @n_row_count = 0

      INSERT INTO TH_BUF_SCM_OFFSET_HIS
            (
              COMPANY_ID
            , DIVISION_ID
            , SITE_ID
            , PLANT_ID
            , INSTANCE_ID
            , DPP_PLAN_ID
            , SCP_PLAN_ID
            , SCP_TARGET_ID
            , ITEM_ID
            , PRODUCTION_TYPE
            , TARGET_TYPE
            , MFG_WEEK
            , MFG_QTY
            , OFFSET_SEQ
            , OFFSET_TYPE
            , INIT_QTY
            , OFFSET_QTY
            , REMAIN_QTY
            , CUTOFF_DATE
            )
      SELECT      
              COMPANY_ID
            , DIVISION_ID
            , SITE_ID
            , PLANT_ID
            , @v_master_id AS INSTANCE_ID
            , DPP_PLAN_ID
            , SCP_PLAN_ID
            , SCP_TARGET_ID
            , ITEM_ID
            , PRODUCTION_TYPE
            , TARGET_TYPE
            , MFG_WEEK
            , MFG_QTY
            , 0 OFFSET_SEQ
            , 'INIT' OFFSET_TYPE
            , MFG_QTY AS INIT_QTY
            , 0       AS OFFSET_QTY
            , MFG_QTY AS REMAIN_QTY
            , @v_cutoff_date AS CUTOFF_DATE
      FROM    DBO.TH_BUF_SCM_DEMAND A

      SET @n_row_count += @@ROWCOUNT
      
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
    END
    
    
    -- 생산 실적 처리
    BEGIN   -- IF BEGIN

      BEGIN
      
        BEGIN

          SET @v_table_name = 'TH_BUF_SCM_OFFSET_GR'
          
          INSERT INTO TH_BUF_SCM_OFFSET_GR
          SELECT B.MASTER_ID   AS MASTER_ID
               , B.PLAN_ID     AS PLAN_ID
               , A.COMPANY_ID
               , A.DIVISION_ID
               , A.SITE_ID
               , A.PLANT_ID
               , DENSE_RANK() OVER (ORDER BY A.SEQ
                                           , A.COMPANY_ID
                                           , A.DIVISION_ID
                                           , A.SITE_ID
                                           , A.PLANT_ID
                                           , A.FACTORY_ID
                                           , A.ITEM_ID
                                           , A.OPERATION_ID
                                           , A.LINE_ID
                                           , A.QTY
                                           , A.PRODUCT_DATE
                                           , A.PRODUCTION_TYPE) AS SEQ
               , A.ITEM_ID
               , A.OPERATION_ID
               , A.PRODUCT_DATE
               , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                      WHEN A.PRODUCTION_TYPE = ''    THEN 'MASS'
                      ELSE A.PRODUCTION_TYPE
                 END  PRODUCTION_TYPE
               --, (CASE WHEN ISNULL(QTY_LANE,0) = 0 THEN QTY ELSE QTY_LANE END) AS QTY
               --, (CASE WHEN ISNULL(QTY_LANE,0) = 0 THEN QTY ELSE QTY_LANE END) AS ORG_QTY
               , ISNULL(A.WIPQTY2_ENGINE,0) AS QTY
               , ISNULL(A.WIPQTY2_ENGINE,0) AS ORG_QTY
               , A.CUTOFF_DATE
                 --SUM(QTY) AS QTY
          FROM   SY_SCM_PRODUCT_RESULT_H A,
                 (
                  SELECT A.MASTER_ID, A.PLAN_ID, B.DATE_ID
                  FROM   --TH_MST_PLAN A,
                         (-- TARGET 에 들어있는 ITEM 기준, 주차 기준의 모든 생산 실적을 가지고 온다..
                          SELECT 
                                  INSTANCE_ID     AS MASTER_ID
                                , DPP_PLAN_ID     AS PLAN_ID
                                , MFG_WEEK        AS WEEK
                          FROM   TH_MST_SCM_DEMAND
                          WHERE  INSTANCE_ID = @v_master_id
                          AND    DPP_PLAN_ID = @v_plan_id
                          AND    TARGET_TYPE IN ('PRODUCT','SRS','SHIPMENT_ELEC','SHIPMENT_AUTO','SHIPMENT') -- ## TARGET 설정해야 함..
                          GROUP  BY
                                  INSTANCE_ID
                                , DPP_PLAN_ID
                                , MFG_WEEK                          
                         ) A,
                         SY_SCM_SYS_CALENDAR_M B
                  WHERE  A.MASTER_ID = @v_master_id
                  AND    A.PLAN_ID = @v_plan_id
                  AND    A.WEEK = B.WEEK
                 ) B
          WHERE  A.CUTOFF_DATE  = CONVERT(DATE, @v_cutoff_date)    -- 당일 기준
          AND    A.PRODUCT_DATE = CONVERT(DATETIME, B.DATE_ID)    -- 당주 실적
          AND    EXISTS ( 
                          SELECT 1
                          FROM   ( -- 중간공정 실적도 올라오므로,,, MAX OPERATION 기준 차감.
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID
                                       , MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                  FROM   TH_MST_INSTANCE_FLOW A
                                  WHERE  MASTER_ID = @v_master_id
                                  AND    PLAN_ID = @v_plan_id
                                  AND    OPERATION_ID NOT IN ('E2500', 'S4000')      -- 실적은 E2500, S4000 제외하기
                                  AND    EXISTS (
                                                  SELECT 1
                                                  FROM   TH_BUF_SCM_DEMAND Z
                                                  WHERE  Z.COMPANY_ID = A.COMPANY_ID
                                                  AND    Z.DIVISION_ID = A.DIVISION_ID
                                                  AND    Z.SITE_ID = A.SITE_ID
                                                  AND    Z.ITEM_ID = A.ITEM_ID
                                                )
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID
                                 ) X
                          WHERE  1=1
                          AND    A.COMPANY_ID = X.COMPANY_ID
                          AND    A.DIVISION_ID = X.DIVISION_ID
                          AND    A.SITE_ID = X.SITE_ID
                          AND    A.PLANT_ID = X.PLANT_ID
                          AND    A.FACTORY_ID = X.FACTORY_ID
                          AND    A.ITEM_ID = X.ITEM_ID
                          AND    A.OPERATION_ID = X.MAX_OPERATION_ID
                        )

          SET @n_row_count = @@ROWCOUNT
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END
      
        SET @v_table_name = 'C_PRODUCT_RESULT'
        SET @n_row_count = 0

                        
        DECLARE
          @c_product_result$company_id        nvarchar(30), 
          @c_product_result$division_id       nvarchar(30), 
          @c_product_result$site_id           nvarchar(30), 
          @c_product_result$item_id           nvarchar(150),
          @c_product_result$production_type   nvarchar(30), 
          @c_product_result$qty               numeric(20,10), 
          @c_product_result$seq               numeric(20,10)


        DECLARE
          C_PRODUCT_RESULT CURSOR LOCAL FOR
            SELECT COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, PRODUCTION_TYPE, SEQ,
                   QTY
                   --SUM(QTY) AS QTY
            FROM   TH_BUF_SCM_OFFSET_GR A
            WHERE  A.MASTER_ID = @v_master_id
            AND    A.PLAN_ID = @v_plan_id
            AND    A.QTY > 0
            ORDER  BY A.SEQ
            --GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, PRODUCTION_TYPE

        OPEN C_PRODUCT_RESULT

          WHILE 1 = 1
           
            BEGIN

              FETCH C_PRODUCT_RESULT
               INTO @c_product_result$company_id, @c_product_result$division_id,     @c_product_result$site_id,
                    @c_product_result$item_id,    @c_product_result$production_type, @c_product_result$seq,
                    @c_product_result$qty

                IF @@FETCH_STATUS <> 0
                  BREAK

                SET @offset$qty = @c_product_result$qty
                
                WHILE 1 = 1
                  
                  BEGIN

                    IF @offset$qty <= 0.0
                      BREAK

                    SET @offset$scp_target_id = NULL
                      
                    SELECT @offset$scp_target_id  = SCP_TARGET_ID,
                           @offset$minus_qty      = MINUS_QTY,
                           @offset$mfg_qty        = MFG_QTY
                    FROM   (
                            SELECT A.*,
                                   CASE WHEN (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > @offset$qty THEN @offset$qty
                                        ELSE MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                                   END  AS MINUS_QTY,
                                   ROW_NUMBER() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
                                                      ORDER     BY MFG_WEEK, SCP_TARGET_ID ) SEQ
                            FROM   DBO.TH_BUF_SCM_DEMAND A
                            WHERE  COMPANY_ID   = @c_product_result$company_id
                            AND    DIVISION_ID  = @c_product_result$division_id
                            AND    SITE_ID      = @c_product_result$site_id
                            AND    ITEM_ID      = @c_product_result$item_id
                            AND    DEMAND_TYPE <> 'FIX'                       -- 확정 PEGGING 된 애들은 대상에서 제외
                            AND    PRODUCTION_TYPE  =  ( CASE WHEN @c_product_result$production_type = 'TEST' 
                                                              THEN @c_product_result$production_type 
                                                              ELSE PRODUCTION_TYPE 
                                                         END )                -- TEST 만 구별한다
                            AND    TARGET_TYPE IN ('PRODUCT','SRS','SHIPMENT_ELEC','SHIPMENT_AUTO','SHIPMENT')
                            AND    MFG_QTY > ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                           ) A
                    WHERE  SEQ = 1

                    IF ISNULL(@offset$scp_target_id, '*NULL*') = '*NULL*'
                      BREAK;
                    
                    UPDATE TH_BUF_SCM_OFFSET_GR
                    SET    QTY         -= @offset$minus_qty
                    WHERE  MASTER_ID    = @v_master_id
                    AND    PLAN_ID      = @v_plan_id
                    AND    COMPANY_ID   = @c_product_result$company_id
                    AND    DIVISION_ID  = @c_product_result$division_id
                    AND    SITE_ID      = @c_product_result$site_id
                    --AND    PLANT_ID     = @c_product_result$plant_id
                    AND    ITEM_ID      = @c_product_result$item_id
                    AND    SEQ          = @c_product_result$seq
                    
                    UPDATE dbo.TH_BUF_SCM_DEMAND
                    SET    OFFSET_INVENTORY_QTY += @offset$minus_qty
                    WHERE  COMPANY_ID     = @c_product_result$company_id
                    AND    DIVISION_ID    = @c_product_result$division_id
                    AND    SITE_ID        = @c_product_result$site_id
                    AND    ITEM_ID        = @c_product_result$item_id
                    AND    SCP_TARGET_ID  = @offset$scp_target_id

                    SET @n_row_count += @@ROWCOUNT

                    SET @offset$qty -= @offset$minus_qty
                    
                    SELECT @v_offset_seq = ISNULL(MAX(OFFSET_SEQ), 0)
                    FROM   TH_BUF_SCM_OFFSET_HIS
                    WHERE  INSTANCE_ID   = @v_master_id
                    AND    DPP_PLAN_ID   = @v_plan_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id
                    
                    INSERT INTO TH_BUF_SCM_OFFSET_HIS
                          (
                            COMPANY_ID
                          , DIVISION_ID
                          , SITE_ID
                          , PLANT_ID
                          , INSTANCE_ID
                          , DPP_PLAN_ID
                          , SCP_PLAN_ID
                          , SCP_TARGET_ID
                          , ITEM_ID
                          , PRODUCTION_TYPE
                          , MFG_WEEK
                          , MFG_QTY
                          , OFFSET_SEQ
                          , OFFSET_TYPE
                          , INIT_QTY
                          , OFFSET_QTY
                          , REMAIN_QTY
                          --, FACTORY_ID
                          , STORAGE_ID
                          , CUTOFF_DATE
                          )
                    SELECT
                            COMPANY_ID
                          , DIVISION_ID
                          , SITE_ID
                          , PLANT_ID
                          , INSTANCE_ID
                          , DPP_PLAN_ID
                          , SCP_PLAN_ID
                          , SCP_TARGET_ID
                          , ITEM_ID
                          , PRODUCTION_TYPE
                          , MFG_WEEK
                          , MFG_QTY
                          , OFFSET_SEQ + 1
                          , 'GR'                            AS OFFSET_TYPE
                          , REMAIN_QTY                      AS INIT_QTY
                          , @offset$minus_qty               AS OFFSET_QTY
                          , REMAIN_QTY - @offset$minus_qty  AS REMAIN_QTY
                          --, @c_inv_offset$factory_id
                          , null
                          , @v_cutoff_date AS CUTOFF_DATE
                    FROM    TH_BUF_SCM_OFFSET_HIS
                    WHERE  INSTANCE_ID   = @v_master_id
                    AND    DPP_PLAN_ID   = @v_plan_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id
                    AND    OFFSET_SEQ    = @v_offset_seq
                    
                  END;
                  
            END

        CLOSE C_PRODUCT_RESULT

        DEALLOCATE C_PRODUCT_RESULT

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
    END -- IF END


    -- 출하 실적 처리
    BEGIN   -- IF BEGIN
    
      BEGIN
      
        BEGIN

          SET @v_table_name = 'TH_BUF_SCM_OFFSET_GI'

          INSERT INTO TH_BUF_SCM_OFFSET_GI
          SELECT @v_master_id AS MASTER_ID
               , @v_plan_id   AS PLAN_ID
               , A.COMPANY_ID
               , A.DIVISION_ID
               , A.SITE_ID
               , A.PLANT_ID
               , DENSE_RANK() OVER (ORDER BY A.SEQ
                                           , A.COMPANY_ID
                                           , A.DIVISION_ID
                                           , A.SITE_ID
                                           , A.PLANT_ID
                                           , A.ITEM_ID
                                           , A.SHIP_DATE
                                           , A.TO_SITE_ID
                                           , A.TO_PLANT_ID
                                           , A.CUSTOMER_ID
                                           , A.QTY
                                           , A.PRODUCTION_TYPE) AS SEQ
               , A.SHOP_GROUP_ID
               , A.ITEM_ID
               , A.SHIP_DATE
               , A.TO_SITE_ID
               , A.TO_PLANT_ID
               , A.CUSTOMER_ID
               , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                      WHEN A.PRODUCTION_TYPE  = ''   THEN 'MASS'
                      ELSE A.PRODUCTION_TYPE
                 END  PRODUCTION_TYPE
               , A.QTY
               , A.QTY AS ORG_QTY
               , A.CUTOFF_DATE
          FROM   SY_SCM_SHIPPING_RESULT_H A
          WHERE  1=0                                            -- ######## 대상 없음 ########
          AND    CUTOFF_DATE =  CONVERT(DATE, @v_cutoff_date)   -- 당일 기준
          AND    EXISTS ( SELECT 1
                          FROM   TH_MST_INSTANCE_FLOW X
                          WHERE  X.MASTER_ID    = @v_master_id
                          AND    X.PLAN_ID      = @v_plan_id
                          AND    A.COMPANY_ID   = X.COMPANY_ID
                          AND    A.DIVISION_ID  = X.DIVISION_ID
                          AND    A.SITE_ID      = X.SITE_ID
                          --AND    A.PLANT_ID = X.PLANT_ID
                          AND    A.ITEM_ID      = X.ITEM_ID )

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
        END
      
        SET @v_table_name = 'C_SHIPPING_RESULT'
        SET @n_loop = 0       

                        
        DECLARE
          @c_shipping_result$company_id       nvarchar(30), 
          @c_shipping_result$division_id      nvarchar(30), 
          @c_shipping_result$site_id          nvarchar(30), 
          @c_shipping_result$plant_id         nvarchar(30), 
          @c_shipping_result$item_id          nvarchar(150), 
          @c_shipping_result$to_site_id       nvarchar(150), 
          @c_shipping_result$qty              numeric(20,10),
          @c_shipping_result$seq              numeric(20,10),
          @c_shipping_result$production_type  nvarchar(30)

        WHILE 1=1
        BEGIN

          IF @n_loop >= 2
            BREAK
        
          SET @n_loop = @n_loop + 1        -- 1 : ITEM, TOSITE,  2: ITEM 차감
          SET @n_row_count = 0
        
          DECLARE
            C_SHIPPING_RESULT CURSOR LOCAL FOR
              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TO_SITE_ID,
                     CASE PRODUCTION_TYPE WHEN NULL THEN 'MASS'
                                          WHEN ''   THEN 'MASS'
                                          ELSE PRODUCTION_TYPE
                     END  PRODUCTION_TYPE,
                     SEQ,
                     --INVOICE_ID,
                     QTY AS GI_QTY
              FROM   TH_BUF_SCM_OFFSET_GI A
              WHERE  A.MASTER_ID = @v_master_id
              AND    A.PLAN_ID = @v_plan_id
              AND    A.QTY > 0
              ORDER  BY A.SEQ

          OPEN C_SHIPPING_RESULT

            WHILE 1 = 1
             
              BEGIN

                FETCH C_SHIPPING_RESULT
                 INTO @c_shipping_result$company_id,      @c_shipping_result$division_id, @c_shipping_result$site_id,
                      @c_shipping_result$plant_id,        @c_shipping_result$item_id,     @c_shipping_result$to_site_id, 
                      @c_shipping_result$production_type, @c_shipping_result$seq,         @c_shipping_result$qty

                  IF @@FETCH_STATUS <> 0
                    BREAK

                  SET @offset$qty = @c_shipping_result$qty
                  
                  WHILE 1 = 1
                    
                    BEGIN

                      IF @offset$qty <= 0.0
                        BREAK

                      SET @offset$scp_target_id = NULL
                        
                      SELECT @offset$scp_target_id = SCP_TARGET_ID,
                             @offset$minus_qty =  MINUS_QTY
                      FROM   (
                              SELECT A.*,
                                     CASE WHEN (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > @offset$qty THEN @offset$qty
                                          ELSE MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                                     END  AS MINUS_QTY,
                                     ROW_NUMBER() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
                                                        ORDER     BY MFG_WEEK, SCP_TARGET_ID ) SEQ
                              FROM   DBO.TH_BUF_SCM_DEMAND A
                              WHERE  COMPANY_ID     = @c_shipping_result$company_id
                              AND    DIVISION_ID    = @c_shipping_result$division_id
                              AND    SITE_ID        = @c_shipping_result$site_id
                              --AND    PLANT_ID     = @c_shipping_result$plant_id
                              AND    ITEM_ID        = @c_shipping_result$item_id
                              AND    PRODUCTION_TYPE  =  ( CASE WHEN @c_shipping_result$production_type = 'TEST' 
                                                                THEN @c_shipping_result$production_type 
                                                                ELSE PRODUCTION_TYPE 
                                                           END )                -- TEST 만 구별한다
                              AND    DEMAND_TYPE <> 'FIX'                       -- 확정 PEGGING 된 애들은 대상에서 제외
                              AND    TARGET_TYPE IN ('','')                     -- SHIPMENT, SHIPMENT_ELEC 만 대상
                              AND    (
                                        ( @n_loop = 1 AND TO_SITE_ID = @c_shipping_result$to_site_id )
                                      or 
                                        ( @n_loop = 2 )
                                     )
                              AND    MFG_QTY > ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                             ) A
                      WHERE  SEQ = 1

                      IF ISNULL(@offset$scp_target_id, '*NULL*') = '*NULL*'
                        BREAK;
                      
                      UPDATE TH_BUF_SCM_OFFSET_GI
                      SET    QTY         -= @offset$minus_qty
                      WHERE  MASTER_ID    = @v_master_id
                      AND    PLAN_ID      = @v_plan_id
                      AND    COMPANY_ID   = @c_shipping_result$company_id
                      AND    DIVISION_ID  = @c_shipping_result$division_id
                      AND    SITE_ID      = @c_shipping_result$site_id
                      AND    PLANT_ID     = @c_shipping_result$plant_id
                      AND    ITEM_ID      = @c_shipping_result$item_id
                      AND    SEQ          = @c_shipping_result$seq
                      
                      UPDATE dbo.TH_BUF_SCM_DEMAND
                      SET    OFFSET_GI_QTY   += @offset$minus_qty
                      WHERE  COMPANY_ID       = @c_shipping_result$company_id
                      AND    DIVISION_ID      = @c_shipping_result$division_id
                      AND    SITE_ID          = @c_shipping_result$site_id
                      --AND    PLANT_ID         = @c_shipping_result$plant_id
                      AND    ITEM_ID          = @c_shipping_result$item_id
                      AND    PRODUCTION_TYPE  = @c_shipping_result$production_type
                      AND    SCP_TARGET_ID    = @offset$scp_target_id

                      SET @n_row_count += @@ROWCOUNT

                      SET @offset$qty -= @offset$minus_qty

                      SELECT @v_offset_seq = ISNULL(MAX(OFFSET_SEQ), 0)
                      FROM   TH_BUF_SCM_OFFSET_HIS
                      WHERE  INSTANCE_ID   = @v_master_id
                      AND    DPP_PLAN_ID   = @v_plan_id
                      AND    SCP_TARGET_ID = @offset$scp_target_id
                      
                      INSERT INTO TH_BUF_SCM_OFFSET_HIS
                            (
                              COMPANY_ID
                            , DIVISION_ID
                            , SITE_ID
                            , PLANT_ID
                            , INSTANCE_ID
                            , DPP_PLAN_ID
                            , SCP_PLAN_ID
                            , SCP_TARGET_ID
                            , ITEM_ID
                            , PRODUCTION_TYPE
                            , MFG_WEEK
                            , MFG_QTY
                            , OFFSET_SEQ
                            , OFFSET_TYPE
                            , INIT_QTY
                            , OFFSET_QTY
                            , REMAIN_QTY
                            --, INVOICE_ID
                            , CUTOFF_DATE
                            )
                      SELECT
                              COMPANY_ID
                            , DIVISION_ID
                            , SITE_ID
                            , PLANT_ID
                            , INSTANCE_ID
                            , DPP_PLAN_ID
                            , SCP_PLAN_ID
                            , SCP_TARGET_ID
                            , ITEM_ID
                            , PRODUCTION_TYPE
                            , MFG_WEEK
                            , MFG_QTY
                            , OFFSET_SEQ + 1
                            , 'GI'                            AS OFFSET_TYPE
                            , REMAIN_QTY                      AS INIT_QTY
                            , @offset$minus_qty               AS OFFSET_QTY
                            , REMAIN_QTY - @offset$minus_qty  AS REMAIN_QTY
                            --, @c_gi_offset$invoice_id
                            , CUTOFF_DATE
                      FROM    TH_BUF_SCM_OFFSET_HIS
                      WHERE  INSTANCE_ID   = @v_master_id
                      AND    DPP_PLAN_ID   = @v_plan_id
                      AND    SCP_TARGET_ID = @offset$scp_target_id
                      AND    OFFSET_SEQ    = @v_offset_seq

                    END;
                    
              END

          CLOSE C_SHIPPING_RESULT

          DEALLOCATE C_SHIPPING_RESULT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
        END   -- WHILE END
        
      END

      BEGIN
      
        BEGIN
        
          SET @v_table_name = 'TH_BUF_SCM_OFFSET_INV'

          INSERT INTO TH_BUF_SCM_OFFSET_INV
          SELECT @v_master_id   AS MASTER_ID
               , @v_plan_id     AS PLAN_ID
               , A.COMPANY_ID
               , A.DIVISION_ID
               , A.SITE_ID
               , A.PLANT_ID
               , DENSE_RANK() OVER (ORDER BY A.SEQ
                                           , A.STOCK_TYPE
                                           , A.COMPANY_ID
                                           , A.DIVISION_ID
                                           , A.SITE_ID
                                           , A.PLANT_ID
                                           , A.FACTORY_ID
                                           , A.STORAGE_ID
                                           , A.ITEM_ID
                                           , A.QTY) AS SEQ
               , ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)  AS ITEM_ID
               , ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) AS OPERATION_ID         -- 완성 공정 기준 OPERATION_ID
               , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                      WHEN A.PRODUCTION_TYPE  = ''   THEN 'MASS'
                      ELSE A.PRODUCTION_TYPE
                 END  PRODUCTION_TYPE
               --, FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.FP_APPLY_WIPQTY, 0)))  AS QTY
               --, FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.FP_APPLY_WIPQTY, 0)))  AS ORG_QTY
                 , FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY, case when @STOCK_OPTION_VALUE = 'FP_APPLY_WIPQTY' then ISNULL(A.FP_APPLY_WIPQTY, 0)
                                                               when @STOCK_OPTION_VALUE = 'CAL_QTY'         then ISNULL(A.CAL_QTY, 0)
                                                               else 0
                                                          end     
                               )
                        )  AS QTY
                 , FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY, case when @STOCK_OPTION_VALUE = 'FP_APPLY_WIPQTY' then ISNULL(A.FP_APPLY_WIPQTY, 0)
                                                               when @STOCK_OPTION_VALUE = 'CAL_QTY'         then ISNULL(A.CAL_QTY, 0)
                                                               else 0
                                                          end     
                               )
                        )  AS ORG_QTY
               , A.QTY_UOM
               , A.CUTOFF_DATE
          --FROM   SY_SCM_STOCK_H A  -- ksjeon 20170821
          FROM   (
                  -- modify_fp_apply_wipqty  
                  select *
                  from sy_scm_stock_h a
                  where  1=1
                  and    isnull(a.wiphold_yn, 'N') = 'N'
                  and    a.modify_fp_apply_wipqty is not null
                  union all
                  -- fp_apply_wipqty
                  select *
                  from   sy_scm_stock_h a
                  where  'FP_APPLY_WIPQTY'= @STOCK_OPTION_VALUE
                  and    isnull(a.wiphold_yn, 'N') = 'N'
                  and    a.modify_fp_apply_wipqty is null
                  and    not exists  (
                                      select 1
                                      from   sy_scm_stock_h x
                                      where  x.modify_fp_apply_wipqty is not null
                                      and    x.company_id            = a.company_id
                                      and    x.division_id           = a.division_id
                                      and    x.site_id               = a.site_id
                                      and    x.plant_id              = a.plant_id
                                      and    x.factory_id            = a.factory_id
                                      and    x.storage_id            = a.storage_id
                                      and    x.cutoff_date           = a.cutoff_date
                                      and    x.stock_type            = a.stock_type
                                      and    x.fp_apply_item_id      = a.fp_apply_item_id
                                      and    isnull(x.lane, 0 )      = isnull(a.lane, 0 )
                                      and    x.fp_apply_operation_id = a.fp_apply_operation_id
                                     )
                  union all
                  -- cal_qty
                  select *
                  from   sy_scm_stock_h a
                  where  'CAL_QTY'=@STOCK_OPTION_VALUE
                  and    isnull(a.wiphold_yn, 'N') = 'N'
                  and    a.cal_qty is not null
                  and    a.modify_fp_apply_wipqty is null
                 ) A
          WHERE  1=1
          AND    A.CUTOFF_DATE =  CONVERT(DATE, @v_cutoff_date)   -- 당일 기준.
          AND    A.STOCK_TYPE = 'INVENTORY'
          --AND   (A.STORAGE_ID >= '5000' AND A.STORAGE_ID < '6000') 
  				-- 하드코딩 전환
          AND		(A.STORAGE_ID >= (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='FP_SIMULATION_PACK_V' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y' AND ATTRIBUTE3='MIN') 
					AND A.STORAGE_ID < (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='FP_SIMULATION_PACK_V' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y' AND ATTRIBUTE3='MAX') )

          AND    A.AVAILABLE_DATE >= A.HOLDING_DATE
          --AND    FLOOR(ISNULL(A.FP_APPLY_WIPQTY, 0)) > 0 
          AND    EXISTS ( SELECT 1
                          FROM   TH_MST_INSTANCE_FLOW X
                          WHERE  X.MASTER_ID    = @v_master_id
                          AND    X.PLAN_ID      = @v_plan_id
                          AND    A.COMPANY_ID   = X.COMPANY_ID
                          AND    A.DIVISION_ID  = X.DIVISION_ID
                          AND    A.SITE_ID      = X.SITE_ID
                          --AND    A.PLANT_ID   = X.PLANT_ID
                          --AND    A.FACTORY_ID = X.FACTORY_ID
                          AND    A.ITEM_ID      = X.ITEM_ID )
        
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END
        
        SET @v_table_name = 'C_INV'
        SET @n_row_count = 0

                        
        DECLARE
          @c_inv$company_id        nvarchar(30), 
          @c_inv$division_id       nvarchar(30), 
          @c_inv$site_id           nvarchar(30), 
          @c_inv$plant_id          nvarchar(30), 
          @c_inv$item_id           nvarchar(150), 
          @c_inv$qty               numeric(20,10),
          @c_inv$seq               numeric(20,10),
          @c_inv$production_type   nvarchar(30)


        DECLARE
          C_INV CURSOR LOCAL FOR
            SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, 
                   CASE PRODUCTION_TYPE WHEN NULL THEN 'MASS'
                                        WHEN ''   THEN 'MASS'
                                        ELSE PRODUCTION_TYPE
                   END  PRODUCTION_TYPE,
                   SEQ,
                   QTY
            FROM   TH_BUF_SCM_OFFSET_INV A
            WHERE  A.MASTER_ID = @v_master_id
            AND    A.PLAN_ID = @v_plan_id
            AND    A.QTY > 0

        OPEN C_INV

          WHILE 1 = 1
           
            BEGIN

              FETCH C_INV
               INTO @c_inv$company_id,  @c_inv$division_id,     @c_inv$site_id, @c_inv$plant_id,    
                    @c_inv$item_id,     @c_inv$production_type, @c_inv$seq,     @c_inv$qty

                IF @@FETCH_STATUS <> 0
                  BREAK

                SET @offset$qty = @c_inv$qty
                
                WHILE 1 = 1
                  
                  BEGIN

                    IF @offset$qty <= 0.0
                      BREAK

                    SET @offset$scp_target_id = NULL
                      
                    SELECT @offset$scp_target_id  = SCP_TARGET_ID,
                           @offset$minus_qty      = MINUS_QTY,
                           @offset$mfg_qty        = MFG_QTY
                    FROM   (
                            SELECT A.*,
                                   CASE WHEN (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > @offset$qty THEN @offset$qty
                                        ELSE MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                                   END  AS MINUS_QTY,
                                   ROW_NUMBER() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
                                                      ORDER     BY MFG_WEEK, SCP_TARGET_ID ) SEQ
                            FROM   DBO.TH_BUF_SCM_DEMAND A
                            WHERE  COMPANY_ID     = @c_inv$company_id
                            AND    DIVISION_ID    = @c_inv$division_id
                            AND    SITE_ID        = @c_inv$site_id
                            --AND    PLANT_ID     = @c_inv$plant_id
                            AND    ITEM_ID        = @c_inv$item_id
                            AND    PRODUCTION_TYPE  =  ( CASE WHEN @c_inv$production_type = 'TEST' 
                                                              THEN @c_inv$production_type 
                                                              ELSE PRODUCTION_TYPE 
                                                         END )                -- TEST 만 구별한다
                            AND    DEMAND_TYPE <> 'FIX'                       -- 확정 PEGGING 된 애들은 대상에서 제외
                            AND    TARGET_TYPE IN ('SHIPMENT')                    -- SHIPMENT 만 대상
                            AND    MFG_QTY > ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                           ) A
                    WHERE  SEQ = 1

                    IF ISNULL(@offset$scp_target_id, '*NULL*') = '*NULL*'
                      BREAK;
                    
                    UPDATE TH_BUF_SCM_OFFSET_INV
                    SET    QTY         -= @offset$minus_qty
                    WHERE  MASTER_ID    = @v_master_id
                    AND    PLAN_ID      = @v_plan_id
                    AND    COMPANY_ID   = @c_inv$company_id
                    AND    DIVISION_ID  = @c_inv$division_id
                    AND    SITE_ID      = @c_inv$site_id
                    AND    PLANT_ID     = @c_inv$plant_id
                    AND    ITEM_ID      = @c_inv$item_id
                    AND    SEQ          = @c_inv$seq
                    
                    UPDATE dbo.TH_BUF_SCM_DEMAND
                    SET    OFFSET_INVENTORY_QTY += @offset$minus_qty
                    WHERE  COMPANY_ID     = @c_inv$company_id
                    AND    DIVISION_ID    = @c_inv$division_id
                    AND    SITE_ID        = @c_inv$site_id
                    --AND    PLANT_ID     = @c_inv$plant_id
                    AND    ITEM_ID        = @c_inv$item_id
                    AND    SCP_TARGET_ID  = @offset$scp_target_id

                    SET @n_row_count += @@ROWCOUNT

                    SET @offset$qty -= @offset$minus_qty
                    
                    SELECT @v_offset_seq = ISNULL(MAX(OFFSET_SEQ), 0)
                    FROM   TH_BUF_SCM_OFFSET_HIS
                    WHERE  INSTANCE_ID   = @v_master_id
                    AND    DPP_PLAN_ID   = @v_plan_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id
                    
                    INSERT INTO TH_BUF_SCM_OFFSET_HIS
                          (
                            COMPANY_ID
                          , DIVISION_ID
                          , SITE_ID
                          , PLANT_ID
                          , INSTANCE_ID
                          , DPP_PLAN_ID
                          , SCP_PLAN_ID
                          , SCP_TARGET_ID
                          , ITEM_ID
                          , PRODUCTION_TYPE
                          , MFG_WEEK
                          , MFG_QTY
                          , OFFSET_SEQ
                          , OFFSET_TYPE
                          , INIT_QTY
                          , OFFSET_QTY
                          , REMAIN_QTY
                          , CUTOFF_DATE
                          )
                    SELECT
                            COMPANY_ID
                          , DIVISION_ID
                          , SITE_ID
                          , PLANT_ID
                          , INSTANCE_ID
                          , DPP_PLAN_ID
                          , SCP_PLAN_ID
                          , SCP_TARGET_ID
                          , ITEM_ID
                          , PRODUCTION_TYPE
                          , MFG_WEEK
                          , MFG_QTY
                          , OFFSET_SEQ + 1
                          , 'INV'                           AS OFFSET_TYPE
                          , REMAIN_QTY                      AS INIT_QTY
                          , @offset$minus_qty               AS OFFSET_QTY
                          , REMAIN_QTY - @offset$minus_qty  AS REMAIN_QTY
                          , CUTOFF_DATE
                    FROM    TH_BUF_SCM_OFFSET_HIS
                    WHERE  INSTANCE_ID   = @v_master_id
                    AND    DPP_PLAN_ID   = @v_plan_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id
                    AND    OFFSET_SEQ    = @v_offset_seq
                    
                  END;
                  
            END

        CLOSE C_INV

        DEALLOCATE C_INV

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


      END

    END   -- IF END

    -- PACK 만 해당됨
    IF CHARINDEX('PACK', @v_master_id) > 0
    BEGIN

      SET @v_table_name = 'TH_BUF_SCM_OFFSET_AGING'

      INSERT INTO TH_BUF_SCM_OFFSET_AGING
      SELECT 
              @v_master_id  AS MASTER_ID
            , @v_plan_id    AS PLAN_ID
            , COMPANY_ID
            , DIVISION_ID
            , SITE_ID
            , PLANT_ID
            , DENSE_RANK() OVER (ORDER BY A.SEQ
                                        , A.COMPANY_ID
                                        , A.DIVISION_ID
                                        , A.SITE_ID
                                        , A.PLANT_ID
                                        , A.FACTORY_ID
                                        , A.ROUTE_ID
                                        , A.LINE_ID
                                        , A.OPERATION_SEQ
                                        , A.ITEM_ID
                                        , A.QTY) AS SEQ
            , ITEM_ID
            , AVAILABLE_DATE
            , CASE WHEN PRODUCTION_TYPE IS NULL THEN 'MASS'
                   WHEN PRODUCTION_TYPE  = ''   THEN 'MASS'
                   ELSE PRODUCTION_TYPE
              END  PRODUCTION_TYPE
            , QTY
            , QTY AS ORG_QTY 
            , A.CUTOFF_DATE
      FROM    SY_SCM_AGING_STOCK_H A
      WHERE   CUTOFF_DATE = CONVERT(DATE, @v_cutoff_date)       -- 당일 기준
      AND    EXISTS ( SELECT 1
                      FROM   (
                              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, MAX(OPERATION_ID) AS MAX_OPERATION_ID
                              FROM   TH_MST_INSTANCE_FLOW A
                              WHERE  MASTER_ID = @v_master_id
                              AND    PLAN_ID = @v_plan_id
                              AND    EXISTS (
                                              SELECT 1
                                              FROM   TH_BUF_SCM_DEMAND Z
                                              WHERE  Z.COMPANY_ID = A.COMPANY_ID
                                              AND    Z.DIVISION_ID = A.DIVISION_ID
                                              AND    Z.SITE_ID = A.SITE_ID
                                              AND    Z.ITEM_ID = A.ITEM_ID
                                            )
                              GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID
                             ) X
                      WHERE  1=1
                      AND    A.COMPANY_ID   = X.COMPANY_ID
                      AND    A.DIVISION_ID  = X.DIVISION_ID
                      AND    A.SITE_ID      = X.SITE_ID
                      --AND    A.PLANT_ID   = X.PLANT_ID
                      --AND    A.FACTORY_ID = X.FACTORY_ID
                      AND    A.ITEM_ID      = X.ITEM_ID
                      AND    A.OPERATION_ID = X.MAX_OPERATION_ID)
        
        SET @n_row_count = @@ROWCOUNT

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        SET @v_table_name = 'C_AGING'
        SET @n_row_count = 0

                        
        DECLARE
          @c_aging$company_id        nvarchar(30), 
          @c_aging$division_id       nvarchar(30), 
          @c_aging$site_id           nvarchar(30), 
          @c_aging$plant_id          nvarchar(30), 
          @c_aging$item_id           nvarchar(150), 
          @c_aging$qty               numeric(20,10),
          @c_aging$seq               numeric(20,10),
          @c_aging$production_type   nvarchar(30)


        DECLARE
          C_AGING CURSOR LOCAL FOR
            SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, 
                   CASE PRODUCTION_TYPE WHEN NULL THEN 'MASS'
                                        WHEN ''   THEN 'MASS'
                                        ELSE PRODUCTION_TYPE
                   END  PRODUCTION_TYPE,
                   SEQ,
                   QTY 
            FROM   TH_BUF_SCM_OFFSET_AGING A
            WHERE  A.MASTER_ID = @v_master_id
            AND    A.PLAN_ID = @v_plan_id
            AND    A.QTY > 0

        OPEN C_AGING

          WHILE 1 = 1
           
            BEGIN

              FETCH C_AGING
               INTO @c_aging$company_id,  @c_aging$division_id,     @c_aging$site_id, @c_aging$plant_id, 
                    @c_aging$item_id,     @c_aging$production_type, @c_aging$seq,     @c_aging$qty

                IF @@FETCH_STATUS <> 0
                  BREAK

                SET @offset$qty = @c_aging$qty
                
                WHILE 1 = 1
                  
                  BEGIN

                    IF @offset$qty <= 0.0
                      BREAK

                    SET @offset$scp_target_id = NULL
                      
                    SELECT @offset$scp_target_id  = SCP_TARGET_ID,
                           @offset$minus_qty      = MINUS_QTY,
                           @offset$mfg_qty        = MFG_QTY
                    FROM   (
                            SELECT A.*,
                                   CASE WHEN (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > @offset$qty THEN @offset$qty
                                        ELSE MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                                   END  AS MINUS_QTY,
                                   ROW_NUMBER() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
                                                      ORDER     BY MFG_WEEK, SCP_TARGET_ID ) SEQ
                            FROM   DBO.TH_BUF_SCM_DEMAND A
                            WHERE  COMPANY_ID     = @c_aging$company_id
                            AND    DIVISION_ID    = @c_aging$division_id
                            AND    SITE_ID        = @c_aging$site_id
                            --AND    PLANT_ID     = @c_aging$plant_id
                            AND    ITEM_ID        = @c_aging$item_id
                            AND    PRODUCTION_TYPE  =  ( CASE WHEN @c_aging$production_type = 'TEST' 
                                                              THEN @c_aging$production_type 
                                                              ELSE PRODUCTION_TYPE 
                                                         END )                -- TEST 만 구별한다
                            AND    DEMAND_TYPE <> 'FIX'                       -- 확정 PEGGING 된 애들은 대상에서 제외
                            --AND    TARGET_TYPE IN ('PRODUCT', 'SHIPMENT')                    -- PRODUCT, SHIPMENT 만 대상
                            AND    TARGET_TYPE IN ('SHIPMENT')                    -- SHIPMENT 만 대상
                            AND    MFG_QTY > ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                           ) A
                    WHERE  SEQ = 1

                    IF ISNULL(@offset$scp_target_id, '*NULL*') = '*NULL*'
                      BREAK;
                    
                    UPDATE TH_BUF_SCM_OFFSET_INV
                    SET    QTY         -= @offset$minus_qty
                    WHERE  MASTER_ID    = @v_master_id
                    AND    PLAN_ID      = @v_plan_id
                    AND    COMPANY_ID   = @c_aging$company_id
                    AND    DIVISION_ID  = @c_aging$division_id
                    AND    SITE_ID      = @c_aging$site_id
                    AND    PLANT_ID     = @c_aging$plant_id
                    AND    ITEM_ID      = @c_aging$item_id
                    AND    SEQ          = @c_aging$seq
                    
                    UPDATE dbo.TH_BUF_SCM_DEMAND
                    SET    OFFSET_INVENTORY_QTY += @offset$minus_qty
                    WHERE  COMPANY_ID   = @c_aging$company_id
                    AND    DIVISION_ID  = @c_aging$division_id
                    AND    SITE_ID      = @c_aging$site_id
                    --AND    PLANT_ID   = @c_aging$plant_id
                    AND    ITEM_ID      = @c_aging$item_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id

                    SET @n_row_count += @@ROWCOUNT

                    SET @offset$qty -= @offset$minus_qty
                    
                    SELECT @v_offset_seq = ISNULL(MAX(OFFSET_SEQ), 0)
                    FROM   TH_BUF_SCM_OFFSET_HIS
                    WHERE  INSTANCE_ID   = @v_master_id
                    AND    DPP_PLAN_ID   = @v_plan_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id
                    
                    INSERT INTO TH_BUF_SCM_OFFSET_HIS
                          (
                            COMPANY_ID
                          , DIVISION_ID
                          , SITE_ID
                          , PLANT_ID
                          , INSTANCE_ID
                          , DPP_PLAN_ID
                          , SCP_PLAN_ID
                          , SCP_TARGET_ID
                          , ITEM_ID
                          , PRODUCTION_TYPE
                          , MFG_WEEK
                          , MFG_QTY
                          , OFFSET_SEQ
                          , OFFSET_TYPE
                          , INIT_QTY
                          , OFFSET_QTY
                          , REMAIN_QTY
                          , CUTOFF_DATE
                          )
                    SELECT
                            COMPANY_ID
                          , DIVISION_ID
                          , SITE_ID
                          , PLANT_ID
                          , INSTANCE_ID
                          , DPP_PLAN_ID
                          , SCP_PLAN_ID
                          , SCP_TARGET_ID
                          , ITEM_ID
                          , PRODUCTION_TYPE
                          , MFG_WEEK
                          , MFG_QTY
                          , OFFSET_SEQ + 1
                          , 'AGING'                         AS OFFSET_TYPE
                          , REMAIN_QTY                      AS INIT_QTY
                          , @offset$minus_qty               AS OFFSET_QTY
                          , REMAIN_QTY - @offset$minus_qty  AS REMAIN_QTY
                          , CUTOFF_DATE
                    FROM    TH_BUF_SCM_OFFSET_HIS
                    WHERE  INSTANCE_ID   = @v_master_id
                    AND    DPP_PLAN_ID   = @v_plan_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id
                    AND    OFFSET_SEQ    = @v_offset_seq
                    
                  END;
                  
            END

        CLOSE C_AGING

        DEALLOCATE C_AGING

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

    END
    
    -- 전극만 해당됨
    IF CHARINDEX('PRE', @v_master_id) > 0 OR CHARINDEX('POST', @v_master_id) > 0
    BEGIN

      ----------------------------------------------------------------------
      -- 주초 재고 차감 부분 : 대상 - SHIPMENT_ELEC , SHIPMENT
      ----------------------------------------------------------------------
      BEGIN
      
        BEGIN
        
          SET @v_table_name = 'TH_BUF_SCM_OFFSET_WIP_GR'

          INSERT INTO TH_BUF_SCM_OFFSET_WIP_GR
          SELECT @v_master_id   AS MASTER_ID
               , @v_plan_id     AS PLAN_ID
               , A.COMPANY_ID
               , A.DIVISION_ID
               , A.SITE_ID
               , A.PLANT_ID
               , DENSE_RANK() OVER (ORDER BY A.SEQ
                                           , A.STOCK_TYPE
                                           , A.COMPANY_ID
                                           , A.DIVISION_ID
                                           , A.SITE_ID
                                           , A.PLANT_ID
                                           , A.FACTORY_ID
                                           , A.STORAGE_ID
                                           , A.ITEM_ID
                                           , A.QTY) AS SEQ
               , ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)  AS ITEM_ID
               , ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)  AS OPERATION_ID         -- 완성 공정 기준 OPERATION_ID
               , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                      WHEN A.PRODUCTION_TYPE =  ''   THEN 'MASS'
                      ELSE A.PRODUCTION_TYPE
                 END  PRODUCTION_TYPE
               --, FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.FP_APPLY_WIPQTY, 0)))  AS QTY
               --, FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.FP_APPLY_WIPQTY, 0)))  AS ORG_QTY
                 , FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY, case when @STOCK_OPTION_VALUE = 'FP_APPLY_WIPQTY' then ISNULL(A.FP_APPLY_WIPQTY, 0)
                                                               when @STOCK_OPTION_VALUE = 'CAL_QTY'         then ISNULL(A.CAL_QTY, 0)
                                                               else 0
                                                          end     
                               )
                        )  AS QTY
                 , FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY, case when @STOCK_OPTION_VALUE = 'FP_APPLY_WIPQTY' then ISNULL(A.FP_APPLY_WIPQTY, 0)
                                                               when @STOCK_OPTION_VALUE = 'CAL_QTY'         then ISNULL(A.CAL_QTY, 0)
                                                               else 0
                                                          end     
                               )
                        )  AS ORG_QTY
               , A.QTY_UOM
               , A.CUTOFF_DATE
          -- FROM   SY_SCM_STOCK_H A, -- ksjeon  20170821
          FROM   (
                  -- modify_fp_apply_wipqty  
                  select *
                  from sy_scm_stock_h a
                  where  1=1
                  and    isnull(a.wiphold_yn, 'N') = 'N'
                  and    a.modify_fp_apply_wipqty is not null
                  union all
                  -- fp_apply_wipqty
                  select *
                  from   sy_scm_stock_h a
                  where  'FP_APPLY_WIPQTY'= @STOCK_OPTION_VALUE
                  and    isnull(a.wiphold_yn, 'N') = 'N'
                  and    a.modify_fp_apply_wipqty is null
                  and    not exists  (
                                      select 1
                                      from   sy_scm_stock_h x
                                      where  x.modify_fp_apply_wipqty is not null
                                      and    x.company_id            = a.company_id
                                      and    x.division_id           = a.division_id
                                      and    x.site_id               = a.site_id
                                      and    x.plant_id              = a.plant_id
                                      and    x.factory_id            = a.factory_id
                                      and    x.storage_id            = a.storage_id
                                      and    x.cutoff_date           = a.cutoff_date
                                      and    x.stock_type            = a.stock_type
                                      and    x.fp_apply_item_id      = a.fp_apply_item_id
                                      and    isnull(x.lane, 0 )      = isnull(a.lane, 0 )
                                      and    x.fp_apply_operation_id = a.fp_apply_operation_id
                                     )
                  union all
                  -- cal_qty
                  select *
                  from   sy_scm_stock_h a
                  where  'CAL_QTY'=@STOCK_OPTION_VALUE
                  and    isnull(a.wiphold_yn, 'N') = 'N'
                  and    a.cal_qty is not null
                  and    a.modify_fp_apply_wipqty is null
                 ) A,
                 (
                  SELECT A.MASTER_ID, A.PLAN_ID, B.DATE_ID
                  FROM   --TH_MST_PLAN A,
                         (-- TARGET 에 들어있는 ITEM 기준, 주차 기준의 모든 생산 실적을 가지고 온다..
                          SELECT 
                                  INSTANCE_ID     AS MASTER_ID
                                , DPP_PLAN_ID     AS PLAN_ID
                                , MFG_WEEK        AS WEEK
                          FROM   TH_MST_SCM_DEMAND
                          WHERE  INSTANCE_ID = @v_master_id
                          AND    DPP_PLAN_ID = @v_plan_id
                          GROUP  BY
                                  INSTANCE_ID
                                , DPP_PLAN_ID
                                , MFG_WEEK                          
                         ) A,
                         SY_SCM_SYS_CALENDAR_M B
                  WHERE  A.MASTER_ID = @v_master_id
                  AND    A.PLAN_ID = @v_plan_id
                  AND    A.WEEK = B.WEEK
                  AND    B.DAY = 'MON'            -- 매주 월요일
                 ) B
          WHERE  1=1
          --AND    A.CUTOFF_DATE =  CONVERT(DATE, @v_week_first_date)       -- #### 주초 기준 ####
          AND    A.CUTOFF_DATE = B.DATE_ID        -- 매주 월요일 재고 ( 주초 재고 )
          AND    A.STOCK_TYPE = 'WIP'
          AND    A.AVAILABLE_DATE >= A.HOLDING_DATE
          AND    A.AVAILABLE_DATE <= @plan_start_time
          --AND    FLOOR(ISNULL(A.FP_APPLY_WIPQTY, 0)) > 0 
          AND    EXISTS ( SELECT 1
                          FROM   (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                  FROM   TH_MST_INSTANCE_FLOW A
                                  WHERE  MASTER_ID = @v_master_id
                                  AND    PLAN_ID = @v_plan_id
                                  AND    EXISTS (
                                                  SELECT 1
                                                  FROM   TH_BUF_SCM_DEMAND Z
                                                  WHERE  Z.COMPANY_ID = A.COMPANY_ID
                                                  AND    Z.DIVISION_ID = A.DIVISION_ID
                                                  AND    Z.SITE_ID = A.SITE_ID
                                                  AND    Z.ITEM_ID = A.ITEM_ID
                                                )
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID
                                 ) X
                          WHERE  1=1
                          AND    A.COMPANY_ID   = X.COMPANY_ID
                          AND    A.DIVISION_ID  = X.DIVISION_ID
                          AND    A.SITE_ID      = X.SITE_ID
                          --AND    A.PLANT_ID   = X.PLANT_ID
                          --AND    A.FACTORY_ID = X.FACTORY_ID
                          AND    A.ITEM_ID      = X.ITEM_ID
                          --AND    A.OPERATION_ID > X.MAX_OPERATION_ID)    -- 조건변경 : 전공정일 경우 후공정 WIP의 실적처리하기 위함.
                          AND    ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) > X.MAX_OPERATION_ID)    -- 조건변경 : 전공정일 경우 후공정 WIP의 실적처리하기 위함.
        
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END

        SET @v_table_name = 'C_WIP_GR'
        SET @n_row_count = 0

                        
        DECLARE
          @c_wip_gr$company_id        nvarchar(30), 
          @c_wip_gr$division_id       nvarchar(30), 
          @c_wip_gr$site_id           nvarchar(30), 
          @c_wip_gr$plant_id          nvarchar(30), 
          @c_wip_gr$item_id           nvarchar(150), 
          @c_wip_gr$qty               numeric(20,10),
          @c_wip_gr$seq               numeric(20,10),
          @c_wip_gr$production_type   nvarchar(30)


        DECLARE
          C_WIP_GR CURSOR LOCAL FOR
            SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, 
                   CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                        WHEN A.PRODUCTION_TYPE = ''   THEN 'MASS'
                        ELSE A.PRODUCTION_TYPE
                   END  PRODUCTION_TYPE,
                   SEQ,
                   QTY
            FROM   TH_BUF_SCM_OFFSET_WIP_GR A
            WHERE  A.MASTER_ID = @v_master_id
            AND    A.PLAN_ID = @v_plan_id
            AND    A.QTY > 0

        OPEN C_WIP_GR

          WHILE 1 = 1
           
            BEGIN

              FETCH C_WIP_GR
               INTO @c_wip_gr$company_id, @c_wip_gr$division_id, @c_wip_gr$site_id,
                    @c_wip_gr$plant_id,   @c_wip_gr$item_id,     @c_wip_gr$production_type, @c_wip_gr$seq,
                    @c_wip_gr$qty

                IF @@FETCH_STATUS <> 0
                  BREAK

                SET @offset$qty = @c_wip_gr$qty
                
                WHILE 1 = 1
                  
                  BEGIN

                    IF @offset$qty <= 0.0
                      BREAK

                    SET @offset$scp_target_id = NULL
                      
                    SELECT @offset$scp_target_id  = SCP_TARGET_ID,
                           @offset$minus_qty      = MINUS_QTY,
                           @offset$mfg_qty        = MFG_QTY
                    FROM   (
                            SELECT A.*,
                                   CASE WHEN (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > @offset$qty THEN @offset$qty
                                        ELSE MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                                   END  AS MINUS_QTY,
                                   ROW_NUMBER() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
                                                      ORDER     BY MFG_WEEK, SCP_TARGET_ID ) SEQ
                            FROM   DBO.TH_BUF_SCM_DEMAND A
                            WHERE  COMPANY_ID   = @c_wip_gr$company_id
                            AND    DIVISION_ID  = @c_wip_gr$division_id
                            AND    SITE_ID      = @c_wip_gr$site_id
                            --AND    PLANT_ID   = @c_wip_gr$plant_id
                            AND    ITEM_ID      = @c_wip_gr$item_id
                            AND    PRODUCTION_TYPE  =  ( CASE WHEN @c_wip_gr$production_type = 'TEST' 
                                                              THEN @c_wip_gr$production_type 
                                                              ELSE PRODUCTION_TYPE 
                                                         END )                -- TEST 만 구별한다
                            AND    DEMAND_TYPE <> 'FIX'                       -- 확정 PEGGING 된 애들은 대상에서 제외
                            AND    TARGET_TYPE IN ('SHIPMENT', 'SHIPMENT_ELEC', 'SHIPMENT_AUTO')
                            AND    MFG_QTY > ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                           ) A
                    WHERE  SEQ = 1

                    IF ISNULL(@offset$scp_target_id, '*NULL*') = '*NULL*'
                      BREAK;
                    
                    UPDATE TH_BUF_SCM_OFFSET_WIP_GR
                    SET    QTY         -= @offset$minus_qty
                    WHERE  MASTER_ID    = @v_master_id
                    AND    PLAN_ID      = @v_plan_id
                    AND    COMPANY_ID   = @c_wip_gr$company_id
                    AND    DIVISION_ID  = @c_wip_gr$division_id
                    AND    SITE_ID      = @c_wip_gr$site_id
                    AND    PLANT_ID     = @c_wip_gr$plant_id
                    AND    ITEM_ID      = @c_wip_gr$item_id
                    AND    SEQ          = @c_wip_gr$seq
                    
                    UPDATE dbo.TH_BUF_SCM_DEMAND
                    SET    OFFSET_INVENTORY_QTY += @offset$minus_qty
                    WHERE  COMPANY_ID     = @c_wip_gr$company_id
                    AND    DIVISION_ID    = @c_wip_gr$division_id
                    AND    SITE_ID        = @c_wip_gr$site_id
                    --AND    PLANT_ID     = @c_wip_gr$plant_id
                    AND    ITEM_ID        = @c_wip_gr$item_id
                    AND    SCP_TARGET_ID  = @offset$scp_target_id

                    SET @n_row_count += @@ROWCOUNT

                    SET @offset$qty -= @offset$minus_qty
                    
                    SELECT @v_offset_seq = ISNULL(MAX(OFFSET_SEQ), 0)
                    FROM   TH_BUF_SCM_OFFSET_HIS
                    WHERE  INSTANCE_ID   = @v_master_id
                    AND    DPP_PLAN_ID   = @v_plan_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id
                    
                    INSERT INTO TH_BUF_SCM_OFFSET_HIS
                          (
                            COMPANY_ID
                          , DIVISION_ID
                          , SITE_ID
                          , PLANT_ID
                          , INSTANCE_ID
                          , DPP_PLAN_ID
                          , SCP_PLAN_ID
                          , SCP_TARGET_ID
                          , ITEM_ID
                          , PRODUCTION_TYPE
                          , MFG_WEEK
                          , MFG_QTY
                          , OFFSET_SEQ
                          , OFFSET_TYPE
                          , INIT_QTY
                          , OFFSET_QTY
                          , REMAIN_QTY
                          , CUTOFF_DATE
                          )
                    SELECT
                            COMPANY_ID
                          , DIVISION_ID
                          , SITE_ID
                          , PLANT_ID
                          , INSTANCE_ID
                          , DPP_PLAN_ID
                          , SCP_PLAN_ID
                          , SCP_TARGET_ID
                          , ITEM_ID
                          , PRODUCTION_TYPE
                          , MFG_WEEK
                          , MFG_QTY
                          , OFFSET_SEQ + 1
                          , 'WIP_GR'                        AS OFFSET_TYPE
                          , REMAIN_QTY                      AS INIT_QTY
                          , @offset$minus_qty               AS OFFSET_QTY
                          , REMAIN_QTY - @offset$minus_qty  AS REMAIN_QTY
                          , CUTOFF_DATE
                    FROM    TH_BUF_SCM_OFFSET_HIS
                    WHERE  INSTANCE_ID   = @v_master_id
                    AND    DPP_PLAN_ID   = @v_plan_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id
                    AND    OFFSET_SEQ    = @v_offset_seq
                    
                  END;
                  
            END

        CLOSE C_WIP_GR

        DEALLOCATE C_WIP_GR

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      ----------------------------------------------------------------------
      -- 당일 재고 차감 부분 : 대상 - DAILY_PLAN 
      ----------------------------------------------------------------------
      BEGIN
      
        -- 주초가 당일이면 이중차감을 방지하기 위해 위에서 차감한 수량을 승계받는다.
        IF CONVERT(DATE, @v_cutoff_date) = CONVERT(DATE, @v_week_first_date)
        BEGIN

          SET @v_table_name = 'TH_BUF_SCM_OFFSET_WIP'

          INSERT INTO TH_BUF_SCM_OFFSET_WIP
              (
                 MASTER_ID
               , PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , SEQ
               , ITEM_ID
               , OPERATION_ID
               , PRODUCTION_TYPE
               , QTY
               , ORG_QTY
               , QTY_UOM
               , CUTOFF_DATE              
              )
          SELECT 
                 MASTER_ID
               , PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , SEQ
               , ITEM_ID
               , OPERATION_ID
               , PRODUCTION_TYPE
               , QTY
               , ORG_QTY
               , QTY_UOM
               , CUTOFF_DATE              
          FROM   TH_BUF_SCM_OFFSET_WIP_GR
          WHERE  MASTER_ID = @v_master_id
          AND    PLAN_ID = @v_plan_id
          AND    CUTOFF_DATE = CONVERT(DATE, @v_cutoff_date)
          
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END
        ELSE      
        BEGIN
        
          SET @v_table_name = 'TH_BUF_SCM_OFFSET_WIP'

          INSERT INTO TH_BUF_SCM_OFFSET_WIP
          SELECT @v_master_id   AS MASTER_ID
               , @v_plan_id     AS PLAN_ID
               , A.COMPANY_ID
               , A.DIVISION_ID
               , A.SITE_ID
               , A.PLANT_ID
               , DENSE_RANK() OVER (ORDER BY A.SEQ
                                           , A.STOCK_TYPE
                                           , A.COMPANY_ID
                                           , A.DIVISION_ID
                                           , A.SITE_ID
                                           , A.PLANT_ID
                                           , A.FACTORY_ID
                                           , A.STORAGE_ID
                                           , A.ITEM_ID
                                           , A.QTY) AS SEQ
               , ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)  AS ITEM_ID
               , ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)  AS OPERATION_ID         -- 완성 공정 기준 OPERATION_ID
               , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                      WHEN A.PRODUCTION_TYPE =  ''   THEN 'MASS'
                      ELSE A.PRODUCTION_TYPE
                 END  PRODUCTION_TYPE
               --, FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.FP_APPLY_WIPQTY, 0)))  AS QTY
               --, FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.FP_APPLY_WIPQTY, 0)))  AS ORG_QTY
                 , FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY, case when @STOCK_OPTION_VALUE = 'FP_APPLY_WIPQTY' then ISNULL(A.FP_APPLY_WIPQTY, 0)
                                                               when @STOCK_OPTION_VALUE = 'CAL_QTY'         then ISNULL(A.CAL_QTY, 0)
                                                               else 0
                                                          end     
                               )
                        )  AS QTY
                 , FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY, case when @STOCK_OPTION_VALUE = 'FP_APPLY_WIPQTY' then ISNULL(A.FP_APPLY_WIPQTY, 0)
                                                               when @STOCK_OPTION_VALUE = 'CAL_QTY'         then ISNULL(A.CAL_QTY, 0)
                                                               else 0
                                                          end     
                               )
                        )  AS ORG_QTY
               , A.QTY_UOM
               , A.CUTOFF_DATE
          --FROM   SY_SCM_STOCK_H A -- ksjeon 20170821
          FROM   (
                  -- modify_fp_apply_wipqty  
                  select *
                  from sy_scm_stock_h a
                  where  1=1
                  and    isnull(a.wiphold_yn, 'N') = 'N'
                  and    a.modify_fp_apply_wipqty is not null
                  union all
                  -- fp_apply_wipqty
                  select *
                  from   sy_scm_stock_h a
                  where  'FP_APPLY_WIPQTY'= @STOCK_OPTION_VALUE
                  and    isnull(a.wiphold_yn, 'N') = 'N'
                  and    a.modify_fp_apply_wipqty is null
                  and    not exists  (
                                      select 1
                                      from   sy_scm_stock_h x
                                      where  x.modify_fp_apply_wipqty is not null
                                      and    x.company_id            = a.company_id
                                      and    x.division_id           = a.division_id
                                      and    x.site_id               = a.site_id
                                      and    x.plant_id              = a.plant_id
                                      and    x.factory_id            = a.factory_id
                                      and    x.storage_id            = a.storage_id
                                      and    x.cutoff_date           = a.cutoff_date
                                      and    x.stock_type            = a.stock_type
                                      and    x.fp_apply_item_id      = a.fp_apply_item_id
                                      and    isnull(x.lane, 0 )      = isnull(a.lane, 0 )
                                      and    x.fp_apply_operation_id = a.fp_apply_operation_id
                                     )
                  union all
                  -- cal_qty
                  select *
                  from   sy_scm_stock_h a
                  where  'CAL_QTY'=@STOCK_OPTION_VALUE
                  and    isnull(a.wiphold_yn, 'N') = 'N'
                  and    a.cal_qty is not null
                  and    a.modify_fp_apply_wipqty is null
                 ) A
          WHERE  1=1
          AND    A.CUTOFF_DATE =  CONVERT(DATE, @v_cutoff_date)       -- #### 당일 기준 ####
          AND    A.STOCK_TYPE = 'WIP'
          AND    A.AVAILABLE_DATE >= A.HOLDING_DATE
          AND    A.AVAILABLE_DATE <= @plan_start_time
          --AND    FLOOR(ISNULL(A.FP_APPLY_WIPQTY, 0)) > 0
          AND    EXISTS ( SELECT 1
                          FROM   (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                  FROM   TH_MST_INSTANCE_FLOW A
                                  WHERE  MASTER_ID = @v_master_id
                                  AND    PLAN_ID = @v_plan_id
                                  AND    EXISTS (
                                                  SELECT 1
                                                  FROM   TH_BUF_SCM_DEMAND Z
                                                  WHERE  Z.COMPANY_ID = A.COMPANY_ID
                                                  AND    Z.DIVISION_ID = A.DIVISION_ID
                                                  AND    Z.SITE_ID = A.SITE_ID
                                                  AND    Z.ITEM_ID = A.ITEM_ID
                                                )
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID
                                 ) X
                          WHERE  1=1
                          AND    A.COMPANY_ID = X.COMPANY_ID
                          AND    A.DIVISION_ID = X.DIVISION_ID
                          AND    A.SITE_ID = X.SITE_ID
                          --AND    A.PLANT_ID = X.PLANT_ID
                          --AND    A.FACTORY_ID = X.FACTORY_ID
                          AND    A.ITEM_ID = X.ITEM_ID
                          --AND    A.OPERATION_ID > X.MAX_OPERATION_ID)    -- 조건변경 : 전공정일 경우 후공정 WIP의 실적처리하기 위함.
                          AND    ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) > X.MAX_OPERATION_ID)    -- 조건변경 : 전공정일 경우 후공정 WIP의 실적처리하기 위함.
        
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END

        SET @v_table_name = 'C_WIP'
        SET @n_row_count = 0

                        
        DECLARE
          @c_wip$company_id        nvarchar(30), 
          @c_wip$division_id       nvarchar(30), 
          @c_wip$site_id           nvarchar(30), 
          @c_wip$plant_id          nvarchar(30), 
          @c_wip$item_id           nvarchar(150), 
          @c_wip$qty               numeric(20,10),
          @c_wip$seq               numeric(20,10),
          @c_wip$production_type   nvarchar(30)


        DECLARE
          C_WIP CURSOR LOCAL FOR
            SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, 
                   CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                        WHEN A.PRODUCTION_TYPE = ''   THEN 'MASS'
                        ELSE A.PRODUCTION_TYPE
                   END  PRODUCTION_TYPE,
                   SEQ,
                   QTY
            FROM   TH_BUF_SCM_OFFSET_WIP A
            WHERE  A.MASTER_ID = @v_master_id
            AND    A.PLAN_ID = @v_plan_id
            AND    A.QTY > 0

        OPEN C_WIP

          WHILE 1 = 1
           
            BEGIN

              FETCH C_WIP
               INTO @c_wip$company_id, @c_wip$division_id,     @c_wip$site_id,  @c_wip$plant_id,   
                    @c_wip$item_id,    @c_wip$production_type, @c_wip$seq,
                    @c_wip$qty

                IF @@FETCH_STATUS <> 0
                  BREAK

                SET @offset$qty = @c_wip$qty
                
                WHILE 1 = 1
                  
                  BEGIN

                    IF @offset$qty <= 0.0
                      BREAK

                    SET @offset$scp_target_id = NULL
                      
                    SELECT @offset$scp_target_id  = SCP_TARGET_ID,
                           @offset$minus_qty      = MINUS_QTY,
                           @offset$mfg_qty        = MFG_QTY
                    FROM   (
                            SELECT A.*,
                                   CASE WHEN (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > @offset$qty THEN @offset$qty
                                        ELSE MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                                   END  AS MINUS_QTY,
                                   ROW_NUMBER() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
                                                      ORDER     BY MFG_WEEK, SCP_TARGET_ID ) SEQ
                            FROM   DBO.TH_BUF_SCM_DEMAND A
                            WHERE  COMPANY_ID     = @c_wip$company_id
                            AND    DIVISION_ID    = @c_wip$division_id
                            AND    SITE_ID        = @c_wip$site_id
                            --AND    PLANT_ID     = @c_wip$plant_id
                            AND    ITEM_ID        = @c_wip$item_id
                            AND    PRODUCTION_TYPE  =  ( CASE WHEN @c_wip$production_type = 'TEST' 
                                                              THEN @c_wip$production_type 
                                                              ELSE PRODUCTION_TYPE 
                                                         END )                -- TEST 만 구별한다
                            AND    DEMAND_TYPE <> 'FIX'                       -- 확정 PEGGING 된 애들은 대상에서 제외
                            AND    TARGET_TYPE IN ('DAILY_PLAN')                    -- 모든 대상임
                            AND    MFG_QTY > ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                           ) A
                    WHERE  SEQ = 1

                    IF ISNULL(@offset$scp_target_id, '*NULL*') = '*NULL*'
                      BREAK;
                    
                    UPDATE TH_BUF_SCM_OFFSET_WIP
                    SET    QTY         -= @offset$minus_qty
                    WHERE  MASTER_ID    = @v_master_id
                    AND    PLAN_ID      = @v_plan_id
                    AND    COMPANY_ID   = @c_wip$company_id
                    AND    DIVISION_ID  = @c_wip$division_id
                    AND    SITE_ID      = @c_wip$site_id
                    AND    PLANT_ID     = @c_wip$plant_id
                    AND    ITEM_ID      = @c_wip$item_id
                    AND    SEQ          = @c_wip$seq
                    
                    UPDATE dbo.TH_BUF_SCM_DEMAND
                    SET    OFFSET_INVENTORY_QTY += @offset$minus_qty
                    WHERE  COMPANY_ID   = @c_wip$company_id
                    AND    DIVISION_ID  = @c_wip$division_id
                    AND    SITE_ID      = @c_wip$site_id
                    --AND    PLANT_ID   = @c_wip$plant_id
                    AND    ITEM_ID      = @c_wip$item_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id

                    SET @n_row_count += @@ROWCOUNT

                    SET @offset$qty -= @offset$minus_qty
                    
                    SELECT @v_offset_seq = ISNULL(MAX(OFFSET_SEQ), 0)
                    FROM   TH_BUF_SCM_OFFSET_HIS
                    WHERE  INSTANCE_ID   = @v_master_id
                    AND    DPP_PLAN_ID   = @v_plan_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id
                    
                    INSERT INTO TH_BUF_SCM_OFFSET_HIS
                          (
                            COMPANY_ID
                          , DIVISION_ID
                          , SITE_ID
                          , PLANT_ID
                          , INSTANCE_ID
                          , DPP_PLAN_ID
                          , SCP_PLAN_ID
                          , SCP_TARGET_ID
                          , ITEM_ID
                          , PRODUCTION_TYPE
                          , MFG_WEEK
                          , MFG_QTY
                          , OFFSET_SEQ
                          , OFFSET_TYPE
                          , INIT_QTY
                          , OFFSET_QTY
                          , REMAIN_QTY
                          , CUTOFF_DATE
                          )
                    SELECT
                            COMPANY_ID
                          , DIVISION_ID
                          , SITE_ID
                          , PLANT_ID
                          , INSTANCE_ID
                          , DPP_PLAN_ID
                          , SCP_PLAN_ID
                          , SCP_TARGET_ID
                          , ITEM_ID
                          , PRODUCTION_TYPE
                          , MFG_WEEK
                          , MFG_QTY
                          , OFFSET_SEQ + 1
                          , 'WIP' OFFSET_TYPE
                          , REMAIN_QTY AS INIT_QTY
                          , @offset$minus_qty AS OFFSET_QTY
                          , REMAIN_QTY - @offset$minus_qty AS REMAIN_QTY
                          , CUTOFF_DATE
                    FROM    TH_BUF_SCM_OFFSET_HIS
                    WHERE  INSTANCE_ID   = @v_master_id
                    AND    DPP_PLAN_ID   = @v_plan_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id
                    AND    OFFSET_SEQ    = @v_offset_seq
                    
                  END;
                  
            END

        CLOSE C_WIP

        DEALLOCATE C_WIP

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

    END

    -- 전극만 해당됨
    IF CHARINDEX('PRE', @v_master_id) > 0 OR CHARINDEX('POST', @v_master_id) > 0 OR CHARINDEX('PMIX', @v_master_id) > 0
    BEGIN

      ----------------------------------------------------------------------
      -- 주초 재고 차감 부분 : 대상 - SHIPMENT_ELEC , SHIPMENT
      ----------------------------------------------------------------------
      BEGIN
      
        DELETE FROM TH_MST_SCM_STOCK_DEMAND
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id
        
        SET @v_stock_demand_seq = 0
      
        BEGIN
        
          SET @v_table_name = 'TH_BUF_SCM_OFFSET_STOCK_GR'

          INSERT INTO TH_BUF_SCM_OFFSET_STOCK_GR
          SELECT @v_master_id   AS MASTER_ID
               , @v_plan_id     AS PLAN_ID
               , A.COMPANY_ID
               , A.DIVISION_ID
               , A.SITE_ID
               , A.PLANT_ID
               , DENSE_RANK() OVER (ORDER BY A.SEQ
                                           , A.STOCK_TYPE
                                           , A.COMPANY_ID
                                           , A.DIVISION_ID
                                           , A.SITE_ID
                                           , A.PLANT_ID
                                           , A.FACTORY_ID
                                           , A.STORAGE_ID
                                           , A.ITEM_ID
                                           , A.QTY) AS SEQ
               , ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)  AS ITEM_ID
               , ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)  AS OPERATION_ID         -- 완성 공정 기준 OPERATION_ID
               , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                      WHEN A.PRODUCTION_TYPE =  ''   THEN 'MASS'
                      ELSE A.PRODUCTION_TYPE
                 END  PRODUCTION_TYPE
               --, FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.FP_APPLY_WIPQTY, 0)))  AS QTY
                 , FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY, case when @STOCK_OPTION_VALUE = 'FP_APPLY_WIPQTY' then ISNULL(A.FP_APPLY_WIPQTY, 0)
                                                               when @STOCK_OPTION_VALUE = 'CAL_QTY'         then ISNULL(A.CAL_QTY, 0)
                                                               else 0
                                                          end     
                               )
                        )  AS QTY
               , ISNULL(LANE, 0)  AS ORG_QTY
               , A.FACTORY_ID   AS QTY_UOM            -- LANE 수량을 여기에 넣는다. 근데 안쓴다.
               , A.CUTOFF_DATE
          --FROM   SY_SCM_STOCK_H A, -- ksjeon 20170821
          FROM   (
                  -- modify_fp_apply_wipqty  
                  select *
                  from sy_scm_stock_h a
                  where  1=1
                  and    isnull(a.wiphold_yn, 'N') = 'N'
                  and    a.modify_fp_apply_wipqty is not null
                  union all
                  -- fp_apply_wipqty
                  select *
                  from   sy_scm_stock_h a
                  where  'FP_APPLY_WIPQTY'= @STOCK_OPTION_VALUE
                  and    isnull(a.wiphold_yn, 'N') = 'N'
                  and    a.modify_fp_apply_wipqty is null
                  and    not exists  (
                                      select 1
                                      from   sy_scm_stock_h x
                                      where  x.modify_fp_apply_wipqty is not null
                                      and    x.company_id            = a.company_id
                                      and    x.division_id           = a.division_id
                                      and    x.site_id               = a.site_id
                                      and    x.plant_id              = a.plant_id
                                      and    x.factory_id            = a.factory_id
                                      and    x.storage_id            = a.storage_id
                                      and    x.cutoff_date           = a.cutoff_date
                                      and    x.stock_type            = a.stock_type
                                      and    x.fp_apply_item_id      = a.fp_apply_item_id
                                      and    isnull(x.lane, 0 )      = isnull(a.lane, 0 )
                                      and    x.fp_apply_operation_id = a.fp_apply_operation_id
                                     )
                  union all
                  -- cal_qty
                  select *
                  from   sy_scm_stock_h a
                  where  'CAL_QTY'=@STOCK_OPTION_VALUE
                  and    isnull(a.wiphold_yn, 'N') = 'N'
                  and    a.cal_qty is not null
                  and    a.modify_fp_apply_wipqty is null
                 ) A,
                 (
                  SELECT A.MASTER_ID, A.PLAN_ID, B.DATE_ID
                  FROM   --TH_MST_PLAN A,
                         (-- TARGET 에 들어있는 ITEM 기준, 주차 기준의 모든 생산 실적을 가지고 온다..
                          SELECT 
                                  INSTANCE_ID     AS MASTER_ID
                                , DPP_PLAN_ID     AS PLAN_ID
                                , MFG_WEEK        AS WEEK
                          FROM   TH_MST_SCM_DEMAND
                          WHERE  INSTANCE_ID = @v_master_id
                          AND    DPP_PLAN_ID = @v_plan_id
                          GROUP  BY
                                  INSTANCE_ID
                                , DPP_PLAN_ID
                                , MFG_WEEK                          
                         ) A,
                         SY_SCM_SYS_CALENDAR_M B
                  WHERE  A.MASTER_ID = @v_master_id
                  AND    A.PLAN_ID = @v_plan_id
                  AND    A.WEEK = B.WEEK
                  AND    B.DAY = 'MON'            -- 매주 월요일
                 ) B
          WHERE  1=1
          --AND    A.CUTOFF_DATE =  CONVERT(DATE, @v_week_first_date)       -- #### 주초 기준 ####
          AND    A.CUTOFF_DATE = B.DATE_ID        -- 매주 월요일 재고 ( 주초 재고 )
          AND    A.STOCK_TYPE = 'WIP'
          AND    A.AVAILABLE_DATE >= A.HOLDING_DATE
          AND    A.AVAILABLE_DATE <= @plan_start_time
          --AND    FLOOR(ISNULL(A.FP_APPLY_WIPQTY, 0)) > 0
          AND    EXISTS ( SELECT 1
                          FROM   (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, FACTORY_ID, ITEM_ID, MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                  FROM   TH_MST_INSTANCE_FLOW A
                                  WHERE  MASTER_ID = @v_master_id
                                  AND    PLAN_ID = @v_plan_id
                                  AND    OPERATION_ID NOT IN ('E2500', 'S4000')    -- E2500 은 제외함.
                                  AND    EXISTS (
                                                  SELECT 1
                                                  FROM   TH_BUF_SCM_DEMAND Z
                                                  WHERE  Z.COMPANY_ID = A.COMPANY_ID
                                                  AND    Z.DIVISION_ID = A.DIVISION_ID
                                                  AND    Z.SITE_ID = A.SITE_ID
                                                  AND    Z.ITEM_ID = A.ITEM_ID
                                                )
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, FACTORY_ID, ITEM_ID--, OPERATION_ID
                                  UNION  ALL
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, FACTORY_ID, ITEM_ID, MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                  FROM   TH_MST_INSTANCE_FLOW A
                                  WHERE  MASTER_ID = @v_master_id
                                  AND    PLAN_ID = @v_plan_id
                                  AND    OPERATION_ID IN ('E2000', 'S2000')   -- 이놈도 최종일 경우가 있다.
                                  AND    EXISTS (
                                                  SELECT 1
                                                  FROM   TH_BUF_SCM_DEMAND Z
                                                  WHERE  Z.COMPANY_ID = A.COMPANY_ID
                                                  AND    Z.DIVISION_ID = A.DIVISION_ID
                                                  AND    Z.SITE_ID = A.SITE_ID
                                                  AND    Z.ITEM_ID = A.ITEM_ID
                                                )
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, FACTORY_ID, ITEM_ID--, OPERATION_ID        
                                 ) X
                          WHERE  1=1
                          AND    A.COMPANY_ID = X.COMPANY_ID
                          AND    A.DIVISION_ID = X.DIVISION_ID
                          AND    A.SITE_ID = X.SITE_ID
                          --AND    A.PLANT_ID = X.PLANT_ID
                          --AND    A.FACTORY_ID = X.FACTORY_ID
                          AND    A.ITEM_ID = X.ITEM_ID
                          AND    A.FACTORY_ID = X.FACTORY_ID
                          --AND    A.OPERATION_ID = X.MAX_OPERATION_ID)    -- 조건변경 : 자기 자신..
                          AND    ( 
                                    (
                                      ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) = X.MAX_OPERATION_ID)        -- 완성 공정 기준 OPERATION_ID
                                    )
                                    OR
                                    ( -- 투입 대기 재공
                                      CHARINDEX('E_PMIX', @v_master_id) > 0 AND 
                                      ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) = 'E1000'
                                    )
                                    OR
                                    ( -- 투입 대기 재공
                                      CHARINDEX('E_PRE', @v_master_id) > 0 AND 
                                      ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) = 'A5000'
                                    )
                                    OR
                                    ( -- 투입 대기 재공
                                      CHARINDEX('E_POST', @v_master_id) > 0 AND 
                                      ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) = 'A5000'
                                    )
                                 )
                          
        
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END

        SET @v_table_name = 'C_STOCK_GR'
        SET @n_row_count = 0

                        
        DECLARE
          @c_stock_gr$company_id        nvarchar(30), 
          @c_stock_gr$division_id       nvarchar(30), 
          @c_stock_gr$site_id           nvarchar(30), 
          @c_stock_gr$plant_id          nvarchar(30), 
          @c_stock_gr$factory_id        nvarchar(30), 
          @c_stock_gr$item_id           nvarchar(150), 
          @c_stock_gr$operation_id      nvarchar(30), 
          @c_stock_gr$qty               numeric(20,10),
          @c_stock_gr$seq               numeric(20,10),
          @c_stock_gr$production_type   nvarchar(30),
          @c_stock_gr$lane              numeric(20,10)
          
        DECLARE 
          @c_stock_gr$demand_id   nvarchar(150),
          @c_stock_gr$check       int,
          @c_stock_gr$demand_seq  int = 0
        

        DECLARE
          C_STOCK_GR CURSOR LOCAL FOR
            SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, 
                   QTY_UOM AS FACTORY_ID, ITEM_ID, OPERATION_ID, 
                   CASE A.PRODUCTION_TYPE WHEN NULL THEN 'MASS'
                                          WHEN ''   THEN 'MASS'
                                          ELSE A.PRODUCTION_TYPE
                   END  PRODUCTION_TYPE,
                   SEQ,
                   QTY,
                   ORG_QTY AS LANE
            FROM   TH_BUF_SCM_OFFSET_STOCK_GR A
            WHERE  A.MASTER_ID = @v_master_id
            AND    A.PLAN_ID = @v_plan_id
            AND    A.QTY > 0
            ORDER  BY OPERATION_ID DESC
            

        OPEN C_STOCK_GR

          WHILE 1 = 1
           
            BEGIN

              FETCH C_STOCK_GR
               INTO @c_stock_gr$company_id,    @c_stock_gr$division_id,     @c_stock_gr$site_id,
                    @c_stock_gr$plant_id,      @c_stock_gr$factory_id,      @c_stock_gr$item_id, 
                    @c_stock_gr$operation_id,  @c_stock_gr$production_type, @c_stock_gr$seq,
                    @c_stock_gr$qty,           @c_stock_gr$lane

                IF @@FETCH_STATUS <> 0
                  BREAK

                SET @offset$qty = @c_stock_gr$qty
                
                WHILE 1 = 1
                  
                  BEGIN

                    IF @offset$qty <= 0.0
                      BREAK

                    SET @offset$scp_target_id = NULL
                      
                    SELECT @offset$scp_target_id  = SCP_TARGET_ID,
                           @offset$minus_qty      = MINUS_QTY,
                           @offset$mfg_qty        = MFG_QTY
                    FROM   (
                            SELECT A.*,
                                   CASE WHEN (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > @offset$qty THEN @offset$qty
                                        ELSE MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                                   END  AS MINUS_QTY,
                                   ROW_NUMBER() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
                                                      ORDER     BY MFG_WEEK, SCP_TARGET_ID ) SEQ
                            FROM   DBO.TH_BUF_SCM_DEMAND A
                            WHERE  COMPANY_ID     = @c_stock_gr$company_id
                            AND    DIVISION_ID    = @c_stock_gr$division_id
                            AND    SITE_ID        = @c_stock_gr$site_id
                            --AND    PLANT_ID     = @c_stock_gr$plant_id
                            AND    ITEM_ID        = @c_stock_gr$item_id
                            AND    PRODUCTION_TYPE  =  ( CASE WHEN @c_stock_gr$production_type = 'TEST' 
                                                              THEN @c_stock_gr$production_type 
                                                              ELSE PRODUCTION_TYPE 
                                                         END )                -- TEST 만 구별한다
                            AND    (  -- PMIX 는 FACTORY 별 차감이 들어가야 한다.
                                      CHARINDEX('E_PMIX', @v_master_id ) = 0 
                                      OR
                                      ( 
                                        CHARINDEX('E_PMIX', @v_master_id ) > 0 
                                        AND @c_stock_gr$operation_id = 'E1000'
                                        AND @c_stock_gr$factory_id   = TO_FACTORY_ID
                                      ) 
                                      OR
                                      ( 
                                        CHARINDEX('E_PMIX', @v_master_id ) > 0 
                                        AND @c_stock_gr$operation_id != 'E1000'
                                      ) 
                                   )
                            AND    DEMAND_TYPE <> 'FIX'                           -- 확정 PEGGING 된 애들은 대상에서 제외
                            AND    TARGET_TYPE IN ('SHIPMENT', 'SHIPMENT_ELEC', 'SHIPMENT_AUTO')   -- SHIPMENT_ELEC 대상임
                            AND    MFG_QTY > ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                           ) A
                    WHERE  SEQ = 1

                    IF ISNULL(@offset$scp_target_id, '*NULL*') = '*NULL*'
                      BREAK;
                    
                    UPDATE TH_BUF_SCM_OFFSET_STOCK_GR
                    SET    QTY         -= @offset$minus_qty
                    WHERE  MASTER_ID    = @v_master_id
                    AND    PLAN_ID      = @v_plan_id
                    AND    COMPANY_ID   = @c_stock_gr$company_id
                    AND    DIVISION_ID  = @c_stock_gr$division_id
                    AND    SITE_ID      = @c_stock_gr$site_id
                    AND    PLANT_ID     = @c_stock_gr$plant_id
                    AND    ITEM_ID      = @c_stock_gr$item_id
                    AND    SEQ          = @c_stock_gr$seq
                    
                    UPDATE dbo.TH_BUF_SCM_DEMAND
                    SET    OFFSET_INVENTORY_QTY += @offset$minus_qty
                    WHERE  COMPANY_ID       = @c_stock_gr$company_id
                    AND    DIVISION_ID      = @c_stock_gr$division_id
                    AND    SITE_ID          = @c_stock_gr$site_id
                    --AND    PLANT_ID       = @c_stock_gr$plant_id
                    AND    ITEM_ID          = @c_stock_gr$item_id
                    AND    SCP_TARGET_ID    = @offset$scp_target_id

                    SET @n_row_count += @@ROWCOUNT

                    SET @offset$qty -= @offset$minus_qty
                    
                    SELECT @v_offset_seq = ISNULL(MAX(OFFSET_SEQ), 0)
                    FROM   TH_BUF_SCM_OFFSET_HIS
                    WHERE  INSTANCE_ID   = @v_master_id
                    AND    DPP_PLAN_ID   = @v_plan_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id
                    
                    INSERT INTO TH_BUF_SCM_OFFSET_HIS
                          (
                            COMPANY_ID
                          , DIVISION_ID
                          , SITE_ID
                          , PLANT_ID
                          , INSTANCE_ID
                          , DPP_PLAN_ID
                          , SCP_PLAN_ID
                          , SCP_TARGET_ID
                          , ITEM_ID
                          , PRODUCTION_TYPE
                          , MFG_WEEK
                          , MFG_QTY
                          , OFFSET_SEQ
                          , OFFSET_TYPE
                          , INIT_QTY
                          , OFFSET_QTY
                          , REMAIN_QTY
                          , CUTOFF_DATE
                          )
                    SELECT
                            COMPANY_ID
                          , DIVISION_ID
                          , SITE_ID
                          , PLANT_ID
                          , INSTANCE_ID
                          , DPP_PLAN_ID
                          , SCP_PLAN_ID
                          , SCP_TARGET_ID
                          , ITEM_ID
                          , PRODUCTION_TYPE
                          , MFG_WEEK
                          , MFG_QTY
                          , OFFSET_SEQ + 1
                          , 'STOCK_GR'                      AS OFFSET_TYPE
                          , REMAIN_QTY                      AS INIT_QTY
                          , @offset$minus_qty               AS OFFSET_QTY
                          , REMAIN_QTY - @offset$minus_qty  AS REMAIN_QTY
                          , CUTOFF_DATE
                    FROM    TH_BUF_SCM_OFFSET_HIS
                    WHERE  INSTANCE_ID   = @v_master_id
                    AND    DPP_PLAN_ID   = @v_plan_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id
                    AND    OFFSET_SEQ    = @v_offset_seq
                    
                    IF @c_stock_gr$operation_id IN ('E2000','S2000')
                      BEGIN
                      
                        SELECT @c_stock_gr$check = COUNT(1)
                        FROM   TH_MST_INSTANCE_FLOW A
                        WHERE  MASTER_ID    = @v_master_id
                        AND    PLAN_ID      = @v_plan_id
                        AND    COMPANY_ID   = @c_stock_gr$company_id
                        AND    DIVISION_ID  = @c_stock_gr$division_id
                        AND    SITE_ID      = @c_stock_gr$site_id
                        AND    FACTORY_ID   = @c_stock_gr$factory_id
                        AND    OPERATION_ID IN ('E2500', 'S4000')
                        AND    ITEM_ID      = @c_stock_gr$item_id

                        if @c_stock_gr$check > 0
                          BEGIN
                            SET @v_stock_demand_seq += 1
                            
                            INSERT INTO TH_MST_SCM_STOCK_DEMAND
                                  (
                                    MASTER_ID
                                  , PLAN_ID
                                  , SCP_TARGET_ID
                                  , STOCK_SEQ
                                  , FACTORY_ID
                                  , OPERATION_ID
                                  , ITEM_ID
                                  , LANE
                                  , QTY
                                  , INSERT_ID
                                  , INSERT_TIME
                                  )
                            SELECT @v_master_id
                                 , @v_plan_id
                                 , @offset$scp_target_id
                                 , @v_stock_demand_seq
                                 , @c_stock_gr$factory_id
                                 , @c_stock_gr$operation_id
                                 , @c_stock_gr$item_id
                                 , @c_stock_gr$lane
                                 , @offset$minus_qty
                                 , @v_proc_name
                                 , GETDATE()
                            
                          END

                      END
                    
                  END;
                  
                  
                  
            END

        CLOSE C_STOCK_GR

        DEALLOCATE C_STOCK_GR

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      ----------------------------------------------------------------------
      -- 당일 재고 차감 부분 : 대상 - DAILY_PLAN 
      ----------------------------------------------------------------------
      BEGIN
      
        -- 주초가 당일이면 이중차감을 방지하기 위해 위에서 차감한 수량을 승계받는다.
        IF CONVERT(DATE, @v_cutoff_date) = CONVERT(DATE, @v_week_first_date)
        BEGIN

          SET @v_table_name = 'TH_BUF_SCM_OFFSET_STOCK'

          INSERT INTO TH_BUF_SCM_OFFSET_STOCK
              (
                 MASTER_ID
               , PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , SEQ
               , ITEM_ID
               , OPERATION_ID
               , PRODUCTION_TYPE
               , QTY
               , ORG_QTY
               , QTY_UOM
               , CUTOFF_DATE
              )
          SELECT 
                 MASTER_ID
               , PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , PLANT_ID
               , SEQ
               , ITEM_ID
               , OPERATION_ID
               , PRODUCTION_TYPE
               , QTY
               , ORG_QTY
               , QTY_UOM
               , CUTOFF_DATE
          FROM   TH_BUF_SCM_OFFSET_STOCK_GR
          WHERE  MASTER_ID = @v_master_id
          AND    PLAN_ID = @v_plan_id
          AND    CUTOFF_DATE = CONVERT(DATE, @v_cutoff_date)
          
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END
        ELSE
        BEGIN
        
          SET @v_table_name = 'TH_BUF_SCM_OFFSET_STOCK'

          INSERT INTO TH_BUF_SCM_OFFSET_STOCK
          SELECT @v_master_id   AS MASTER_ID
               , @v_plan_id     AS PLAN_ID
               , A.COMPANY_ID
               , A.DIVISION_ID
               , A.SITE_ID
               , A.PLANT_ID
               , DENSE_RANK() OVER (ORDER BY A.SEQ
                                           , A.STOCK_TYPE
                                           , A.COMPANY_ID
                                           , A.DIVISION_ID
                                           , A.SITE_ID
                                           , A.PLANT_ID
                                           , A.FACTORY_ID
                                           , A.STORAGE_ID
                                           , A.ITEM_ID
                                           , A.QTY) AS SEQ
               , ISNULL(A.FP_APPLY_ITEM_ID, A.ITEM_ID)  AS ITEM_ID
               , ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID)  AS OPERATION_ID         -- 완성 공정 기준 OPERATION_ID
               , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                      WHEN A.PRODUCTION_TYPE =  ''   THEN 'MASS'
                      ELSE A.PRODUCTION_TYPE
                 END  PRODUCTION_TYPE
               --, FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY,ISNULL(A.FP_APPLY_WIPQTY, 0)))  AS QTY
                 , FLOOR(ISNULL(A.MODIFY_FP_APPLY_WIPQTY, case when @STOCK_OPTION_VALUE = 'FP_APPLY_WIPQTY' then ISNULL(A.FP_APPLY_WIPQTY, 0)
                                                               when @STOCK_OPTION_VALUE = 'CAL_QTY'         then ISNULL(A.CAL_QTY, 0)
                                                               else 0
                                                          end     
                               )
                        )  AS QTY
               , ISNULL(LANE, 0)  AS ORG_QTY
               , A.FACTORY_ID   AS QTY_UOM
               , A.CUTOFF_DATE
          --FROM   SY_SCM_STOCK_H A -- ksjeon 20170821
          FROM   (
                  -- modify_fp_apply_wipqty  
                  select *
                  from sy_scm_stock_h a
                  where  1=1
                  and    isnull(a.wiphold_yn, 'N') = 'N'
                  and    a.modify_fp_apply_wipqty is not null
                  union all
                  -- fp_apply_wipqty
                  select *
                  from   sy_scm_stock_h a
                  where  'FP_APPLY_WIPQTY'= @STOCK_OPTION_VALUE
                  and    isnull(a.wiphold_yn, 'N') = 'N'
                  and    a.modify_fp_apply_wipqty is null
                  and    not exists  (
                                      select 1
                                      from   sy_scm_stock_h x
                                      where  x.modify_fp_apply_wipqty is not null
                                      and    x.company_id            = a.company_id
                                      and    x.division_id           = a.division_id
                                      and    x.site_id               = a.site_id
                                      and    x.plant_id              = a.plant_id
                                      and    x.factory_id            = a.factory_id
                                      and    x.storage_id            = a.storage_id
                                      and    x.cutoff_date           = a.cutoff_date
                                      and    x.stock_type            = a.stock_type
                                      and    x.fp_apply_item_id      = a.fp_apply_item_id
                                      and    isnull(x.lane, 0 )      = isnull(a.lane, 0 )
                                      and    x.fp_apply_operation_id = a.fp_apply_operation_id
                                     )
                  union all
                  -- cal_qty
                  select *
                  from   sy_scm_stock_h a
                  where  'CAL_QTY'=@STOCK_OPTION_VALUE
                  and    isnull(a.wiphold_yn, 'N') = 'N'
                  and    a.cal_qty is not null
                  and    a.modify_fp_apply_wipqty is null
                 ) A
          WHERE  1=1
          AND    A.CUTOFF_DATE =  CONVERT(DATE, @v_cutoff_date)       -- #### 당일 기준 ####
          AND    A.STOCK_TYPE = 'WIP'
          AND    A.AVAILABLE_DATE >= A.HOLDING_DATE
          AND    A.AVAILABLE_DATE <= @plan_start_time
          --AND    FLOOR(ISNULL(A.FP_APPLY_WIPQTY, 0)) > 0
          AND    EXISTS ( SELECT 1
                          FROM   (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, FACTORY_ID, ITEM_ID, MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                  FROM   TH_MST_INSTANCE_FLOW A
                                  WHERE  MASTER_ID = @v_master_id
                                  AND    PLAN_ID = @v_plan_id
                                  AND    OPERATION_ID NOT IN ('E2500', 'S4000')    -- E2500, S4000 은 제외함.
                                  AND    EXISTS (
                                                  SELECT 1
                                                  FROM   TH_BUF_SCM_DEMAND Z
                                                  WHERE  Z.COMPANY_ID = A.COMPANY_ID
                                                  AND    Z.DIVISION_ID = A.DIVISION_ID
                                                  AND    Z.SITE_ID = A.SITE_ID
                                                  AND    Z.ITEM_ID = A.ITEM_ID
                                                )
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, FACTORY_ID, ITEM_ID--, OPERATION_ID
                                  UNION  ALL
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, FACTORY_ID, ITEM_ID, MAX(OPERATION_ID) AS MAX_OPERATION_ID
                                  FROM   TH_MST_INSTANCE_FLOW A
                                  WHERE  MASTER_ID = @v_master_id
                                  AND    PLAN_ID = @v_plan_id
                                  AND    OPERATION_ID IN ('E2000', 'S2000')   -- 이놈도 최종일 경우가 있다.
                                  AND    EXISTS (
                                                  SELECT 1
                                                  FROM   TH_BUF_SCM_DEMAND Z
                                                  WHERE  Z.COMPANY_ID = A.COMPANY_ID
                                                  AND    Z.DIVISION_ID = A.DIVISION_ID
                                                  AND    Z.SITE_ID = A.SITE_ID
                                                  AND    Z.ITEM_ID = A.ITEM_ID
                                                )
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, FACTORY_ID, ITEM_ID--, OPERATION_ID        
                                 ) X
                          WHERE  1=1
                          AND    A.COMPANY_ID = X.COMPANY_ID
                          AND    A.DIVISION_ID = X.DIVISION_ID
                          AND    A.SITE_ID = X.SITE_ID
                          --AND    A.PLANT_ID = X.PLANT_ID
                          --AND    A.FACTORY_ID = X.FACTORY_ID
                          AND    A.ITEM_ID = X.ITEM_ID
                          AND    A.FACTORY_ID = X.FACTORY_ID
                          --AND    A.OPERATION_ID = X.MAX_OPERATION_ID)    -- 조건변경 : 자기 자신..
                          AND    ( 
                                    (
                                      ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) = X.MAX_OPERATION_ID)        -- 완성 공정 기준 OPERATION_ID
                                    )
                                    OR
                                    ( -- 투입 대기 재공
                                      CHARINDEX('E_PMIX', @v_master_id) > 0 AND 
                                      ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) = 'E1000'
                                    )
                                    OR
                                    ( -- 투입 대기 재공
                                      CHARINDEX('E_PRE', @v_master_id) > 0 AND 
                                      ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) = 'A5000'
                                    )
                                    OR
                                    ( -- 투입 대기 재공
                                      CHARINDEX('E_POST', @v_master_id) > 0 AND 
                                      ISNULL(A.FP_APPLY_OPERATION_ID, A.OPERATION_ID) = 'A5000'
                                    )
                                 )
                          
        
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END

        SET @v_table_name = 'C_STOCK'
        SET @n_row_count = 0

                        
        DECLARE
          @c_stock$company_id        nvarchar(30), 
          @c_stock$division_id       nvarchar(30), 
          @c_stock$site_id           nvarchar(30), 
          @c_stock$plant_id          nvarchar(30), 
          @c_stock$factory_id        nvarchar(30), 
          @c_stock$item_id           nvarchar(150), 
          @c_stock$operation_id      nvarchar(30), 
          @c_stock$qty               numeric(20,10),
          @c_stock$seq               numeric(20,10),
          @c_stock$production_type   nvarchar(30),
          @c_stock$lane              numeric(20,10)
          
        DECLARE 
          @c_stock$demand_id   nvarchar(150),
          @c_stock$check       int,
          @c_stock$demand_seq  int = 0
        
        DECLARE
          C_STOCK CURSOR LOCAL FOR
            SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, 
                   QTY_UOM AS FACTORY_ID, ITEM_ID, OPERATION_ID, 
                   CASE A.PRODUCTION_TYPE WHEN NULL THEN 'MASS'
                                          WHEN ''   THEN 'MASS'
                                          ELSE A.PRODUCTION_TYPE
                   END  PRODUCTION_TYPE,
                   SEQ,
                   QTY,
                   ORG_QTY AS LANE
            FROM   TH_BUF_SCM_OFFSET_STOCK A
            WHERE  A.MASTER_ID = @v_master_id
            AND    A.PLAN_ID = @v_plan_id
            AND    A.QTY > 0
            ORDER  BY OPERATION_ID DESC
            

        OPEN C_STOCK

          WHILE 1 = 1
           
            BEGIN

              FETCH C_STOCK
               INTO @c_stock$company_id,  @c_stock$division_id, @c_stock$site_id,       @c_stock$plant_id, 
                    @c_stock$factory_id,  @c_stock$item_id,     @c_stock$operation_id,  @c_stock$production_type, 
                    @c_stock$seq,         @c_stock$qty,         @c_stock$lane

                IF @@FETCH_STATUS <> 0
                  BREAK

                SET @offset$qty = @c_stock$qty
                
                WHILE 1 = 1
                  
                  BEGIN

                    IF @offset$qty <= 0.0
                      BREAK

                    SET @offset$scp_target_id = NULL
                      
                    SELECT @offset$scp_target_id  = SCP_TARGET_ID,
                           @offset$minus_qty      = MINUS_QTY,
                           @offset$mfg_qty        = MFG_QTY
                    FROM   (
                            SELECT A.*,
                                   CASE WHEN (MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) > @offset$qty THEN @offset$qty
                                        ELSE MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                                   END  AS MINUS_QTY,
                                   ROW_NUMBER() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
                                                      ORDER     BY MFG_WEEK, SCP_TARGET_ID ) SEQ
                            FROM   DBO.TH_BUF_SCM_DEMAND A
                            WHERE  COMPANY_ID   = @c_stock$company_id
                            AND    DIVISION_ID  = @c_stock$division_id
                            AND    SITE_ID      = @c_stock$site_id
                            --AND    PLANT_ID   = @c_stock$plant_id
                            AND    ITEM_ID      = @c_stock$item_id
                            AND    PRODUCTION_TYPE  =  ( CASE WHEN @c_stock$production_type = 'TEST' 
                                                              THEN @c_stock$production_type 
                                                              ELSE PRODUCTION_TYPE 
                                                         END )                -- TEST 만 구별한다
                            AND    (  -- PMIX 는 FACTORY 별 차감이 들어가야 한다.
                                      CHARINDEX('E_PMIX', @v_master_id ) = 0 
                                      OR
                                      ( 
                                        CHARINDEX('E_PMIX', @v_master_id ) > 0 
                                        AND @c_stock$operation_id = 'E1000'
                                        AND @c_stock$factory_id   = TO_FACTORY_ID
                                      ) 
                                      OR
                                      ( 
                                        CHARINDEX('E_PMIX', @v_master_id ) > 0 
                                        AND @c_stock$operation_id != 'E1000'
                                      ) 
                                   )
                            AND    DEMAND_TYPE <> 'FIX'                       -- 확정 PEGGING 된 애들은 대상에서 제외
                            AND    TARGET_TYPE IN ('DAILY_PLAN')              -- DAILY_PLAN 대상임
                            AND    MFG_QTY > ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )
                           ) A
                    WHERE  SEQ = 1

                    IF ISNULL(@offset$scp_target_id, '*NULL*') = '*NULL*'
                      BREAK;
                    
                    UPDATE TH_BUF_SCM_OFFSET_STOCK
                    SET    QTY         -= @offset$minus_qty
                    WHERE  MASTER_ID    = @v_master_id
                    AND    PLAN_ID      = @v_plan_id
                    AND    COMPANY_ID   = @c_stock$company_id
                    AND    DIVISION_ID  = @c_stock$division_id
                    AND    SITE_ID      = @c_stock$site_id
                    AND    PLANT_ID     = @c_stock$plant_id
                    AND    ITEM_ID      = @c_stock$item_id
                    AND    SEQ          = @c_stock$seq
                    
                    UPDATE dbo.TH_BUF_SCM_DEMAND
                    SET    OFFSET_INVENTORY_QTY += @offset$minus_qty
                    WHERE  COMPANY_ID   = @c_stock$company_id
                    AND    DIVISION_ID  = @c_stock$division_id
                    AND    SITE_ID      = @c_stock$site_id
                    --AND    PLANT_ID   = @c_stock$plant_id
                    AND    ITEM_ID      = @c_stock$item_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id

                    SET @n_row_count += @@ROWCOUNT

                    SET @offset$qty -= @offset$minus_qty
                    
                    SELECT @v_offset_seq = ISNULL(MAX(OFFSET_SEQ), 0)
                    FROM   TH_BUF_SCM_OFFSET_HIS
                    WHERE  INSTANCE_ID   = @v_master_id
                    AND    DPP_PLAN_ID   = @v_plan_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id
                    
                    INSERT INTO TH_BUF_SCM_OFFSET_HIS
                          (
                            COMPANY_ID
                          , DIVISION_ID
                          , SITE_ID
                          , PLANT_ID
                          , INSTANCE_ID
                          , DPP_PLAN_ID
                          , SCP_PLAN_ID
                          , SCP_TARGET_ID
                          , ITEM_ID
                          , PRODUCTION_TYPE
                          , MFG_WEEK
                          , MFG_QTY
                          , OFFSET_SEQ
                          , OFFSET_TYPE
                          , INIT_QTY
                          , OFFSET_QTY
                          , REMAIN_QTY
                          , CUTOFF_DATE
                          )
                    SELECT
                            COMPANY_ID
                          , DIVISION_ID
                          , SITE_ID
                          , PLANT_ID
                          , INSTANCE_ID
                          , DPP_PLAN_ID
                          , SCP_PLAN_ID
                          , SCP_TARGET_ID
                          , ITEM_ID
                          , PRODUCTION_TYPE
                          , MFG_WEEK
                          , MFG_QTY
                          , OFFSET_SEQ + 1
                          , 'STOCK'                         AS OFFSET_TYPE
                          , REMAIN_QTY                      AS INIT_QTY
                          , @offset$minus_qty               AS OFFSET_QTY
                          , REMAIN_QTY - @offset$minus_qty  AS REMAIN_QTY
                          , CUTOFF_DATE
                    FROM    TH_BUF_SCM_OFFSET_HIS
                    WHERE  INSTANCE_ID   = @v_master_id
                    AND    DPP_PLAN_ID   = @v_plan_id
                    AND    SCP_TARGET_ID = @offset$scp_target_id
                    AND    OFFSET_SEQ    = @v_offset_seq
                    
                    IF @c_stock$operation_id IN ('E2000','S2000')
                      BEGIN
                      
                        SELECT @c_stock$check = COUNT(1)
                        FROM   TH_MST_INSTANCE_FLOW A
                        WHERE  MASTER_ID    = @v_master_id
                        AND    PLAN_ID      = @v_plan_id
                        AND    COMPANY_ID   = @c_stock$company_id
                        AND    DIVISION_ID  = @c_stock$division_id
                        AND    SITE_ID      = @c_stock$site_id
                        AND    FACTORY_ID   = @c_stock$factory_id
                        AND    OPERATION_ID IN ('E2500', 'S4000')
                        AND    ITEM_ID      = @c_stock$item_id

                        if @c_stock$check > 0
                          BEGIN
                            SET @v_stock_demand_seq += 1
                            
                            INSERT INTO TH_MST_SCM_STOCK_DEMAND
                                  (
                                    MASTER_ID
                                  , PLAN_ID
                                  , SCP_TARGET_ID
                                  , STOCK_SEQ
                                  , FACTORY_ID
                                  , OPERATION_ID
                                  , ITEM_ID
                                  , LANE
                                  , QTY
                                  , INSERT_ID
                                  , INSERT_TIME
                                  )
                            SELECT @v_master_id
                                 , @v_plan_id
                                 , @offset$scp_target_id
                                 , @v_stock_demand_seq
                                 , @c_stock$factory_id
                                 , @c_stock$operation_id
                                 , @c_stock$item_id
                                 , @c_stock$lane
                                 , @offset$minus_qty
                                 , @v_proc_name
                                 , GETDATE()
                            
                          END

                      END
                    
                  END;
                  
                  
                  
            END

        CLOSE C_STOCK

        DEALLOCATE C_STOCK

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

    END
    
    BEGIN

      SET @v_table_name = 'SY_FP_DAILY_DEMAND_OFFSET_H'
      SET @n_row_count = 0

      DELETE FROM SY_FP_DAILY_DEMAND_OFFSET_H
      WHERE  INSTANCE_ID = @v_master_id
      AND    DPP_PLAN_ID = @v_plan_id
      
      INSERT INTO SY_FP_DAILY_DEMAND_OFFSET_H
          (
          COMPANY_ID
          , DIVISION_ID
          , SITE_ID
          , PLANT_ID
          , INSTANCE_ID
          , DPP_PLAN_ID
          , SCP_PLAN_ID
          , SCP_TARGET_ID
          , ITEM_ID
          , PRODUCTION_TYPE
          , MFG_WEEK
          , MFG_QTY
          , OFFSET_SEQ
          , OFFSET_TYPE
          , INIT_QTY
          , OFFSET_QTY
          , REMAIN_QTY
          , WORK_ORDER_SPL_ID
          , WORK_ORDER_ID
          , STORAGE_ID
          )
      SELECT 
            COMPANY_ID
          , DIVISION_ID
          , SITE_ID
          , PLANT_ID
          , INSTANCE_ID
          , DPP_PLAN_ID
          , SCP_PLAN_ID
          , SCP_TARGET_ID
          , ITEM_ID
          , PRODUCTION_TYPE
          , MFG_WEEK
          , MFG_QTY
          , OFFSET_SEQ
          , OFFSET_TYPE
          , INIT_QTY
          , OFFSET_QTY
          , REMAIN_QTY
          , WORK_ORDER_SPL_ID
          , WORK_ORDER_ID
          , STORAGE_ID
      FROM   TH_BUF_SCM_OFFSET_HIS
      WHERE  INSTANCE_ID = @v_master_id
      AND    DPP_PLAN_ID = @v_plan_id
      
      SET @n_row_count += @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

    END
    
    BEGIN

      SET @v_table_name = 'TH_MST_OFFSET'
      SET @n_row_count = 0

      DELETE FROM TH_MST_OFFSET
      WHERE  MASTER_ID  = @v_master_id
      AND    PLAN_ID    = @v_plan_id
      
      
      INSERT INTO TH_MST_OFFSET
      SELECT MASTER_ID
           , PLAN_ID
           , COMPANY_ID
           , DIVISION_ID
           , SITE_ID
           , PLANT_ID
           , 'GR' AS OFFSET_TYPE
           , SEQ
           , ITEM_ID
           , OPERATION_ID
           , PRODUCTION_TYPE
           , ORG_QTY    AS QTY
           , QTY        AS OFFSET_QTY
           , @v_cutoff_date AS KEY_DATE
      FROM   TH_BUF_SCM_OFFSET_GR
      WHERE  MASTER_ID  = @v_master_id
      AND    PLAN_ID    = @v_plan_id
      AND    OPERATION_ID IS NOT NULL
      UNION  ALL
      SELECT MASTER_ID
           , PLAN_ID
           , COMPANY_ID
           , DIVISION_ID
           , SITE_ID
           , PLANT_ID
           , 'GI' AS OFFSET_TYPE
           , SEQ
           , ITEM_ID
           , '' OPERATION_ID
           , PRODUCTION_TYPE
           , ORG_QTY    AS QTY
           , QTY        AS OFFSET_QTY
           , @v_cutoff_date AS KEY_DATE
      FROM   TH_BUF_SCM_OFFSET_GI    
      WHERE  MASTER_ID  = @v_master_id
      AND    PLAN_ID    = @v_plan_id
      UNION  ALL
      SELECT MASTER_ID
           , PLAN_ID
           , COMPANY_ID
           , DIVISION_ID
           , SITE_ID
           , PLANT_ID
           , 'INV' AS OFFSET_TYPE
           , SEQ
           , ITEM_ID
           , '' OPERATION_ID
           , PRODUCTION_TYPE
           , ORG_QTY    AS QTY
           , QTY        AS OFFSET_QTY
           , @v_cutoff_date AS KEY_DATE
      FROM   TH_BUF_SCM_OFFSET_INV
      WHERE  MASTER_ID  = @v_master_id
      AND    PLAN_ID    = @v_plan_id
      UNION  ALL
      SELECT MASTER_ID
           , PLAN_ID
           , COMPANY_ID
           , DIVISION_ID
           , SITE_ID
           , PLANT_ID
           , 'AGING' AS OFFSET_TYPE
           , SEQ
           , ITEM_ID
           , '' OPERATION_ID
           , PRODUCTION_TYPE
           , ORG_QTY    AS QTY
           , QTY        AS OFFSET_QTY
           , @v_cutoff_date AS KEY_DATE
      FROM   TH_BUF_SCM_OFFSET_AGING    
      WHERE  MASTER_ID  = @v_master_id
      AND    PLAN_ID    = @v_plan_id
      UNION  ALL
      SELECT MASTER_ID
           , PLAN_ID
           , COMPANY_ID
           , DIVISION_ID
           , SITE_ID
           , PLANT_ID
           , 'STOCK' AS OFFSET_TYPE
           , SEQ
           , ITEM_ID
           , OPERATION_ID
           , PRODUCTION_TYPE
           , ORG_QTY    AS QTY
           , QTY        AS OFFSET_QTY
           , @v_cutoff_date AS KEY_DATE
      FROM   TH_BUF_SCM_OFFSET_STOCK    
      WHERE  MASTER_ID  = @v_master_id
      AND    PLAN_ID    = @v_plan_id

      SET @n_row_count += @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
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
