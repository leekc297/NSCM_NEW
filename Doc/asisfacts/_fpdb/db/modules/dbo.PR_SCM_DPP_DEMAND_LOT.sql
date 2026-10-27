CREATE PROCEDURE [dbo].[PR_SCM_DPP_DEMAND_LOT]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_DPP_DEMAND_LOT                                                     **/
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
  EXEC PR_SCM_DPP_DEMAND_LOT
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_DPP_DEMAND_LOT'
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

    END;
    
    ------------------------------------------------------------------------------------------------
    -- DEMAND LOT SPLIT 설정하는 부분
    ------------------------------------------------------------------------------------------------
    BEGIN

      ------------------------------------------------------------------------------------------------------------------
      
      SET @v_table_name = 'TH_MST_SCM_DEMAND_LOT'
      
      DELETE FROM TH_MST_SCM_DEMAND_LOT
      WHERE  DPP_PLAN_ID = @v_plan_id

      INSERT INTO TH_MST_SCM_DEMAND_LOT
            (
              COMPANY_ID
            , DIVISION_ID
            , SITE_ID
            , PLANT_ID
            , FACTORY_ID
            , DPP_PLAN_ID
            , SALES_MODEL_ID
            , ITEM_ID
            , INSTANCE_TYPE
            , KEY_DATE
            , INSERT_ID
            , INSERT_TIME
            , UPDATE_ID
            , UPDATE_TIME
            )
      SELECT DISTINCT
             A.COMPANY_ID
           , A.DIVISION_ID
           , A.SITE_ID
           , C.PLANT_ID
           , C.FACTORY_ID
           , A.DPP_PLAN_ID
           , A.ITEM_ID          AS SALES_MODEL_ID
           , B.PRODUCT_ITEM_ID  AS ITEM_ID
           , @v_instance_type   AS INSTANCE_TYPE
           , CONVERT(NVARCHAR, @v_plan_date, 112) AS KEY_DATE
           , @v_proc_name AS INSERT_ID
           , GETDATE()    AS INSERT_TIME
           , @v_proc_name AS UPDATE_ID
           , GETDATE()    AS UPDATE_TIME
      FROM   TH_MST_SCM_DEMAND          A,
             TH_MST_SCM_SALES_PRODUCT   B,
             SY_SCM_ITEM_LINE_ASSIGN_M  C                 
      WHERE  A.DPP_PLAN_ID = @v_plan_id
      AND    B.MASTER_ID = @v_master_id
      AND    B.PLAN_ID = @v_plan_id
      AND    A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.ITEM_ID = B.SALES_MODEL_ID
      AND    B.COMPANY_ID = C.COMPANY_ID
      AND    B.DIVISION_ID = C.DIVISION_ID
      AND    B.SITE_ID = C.SITE_ID
      AND    B.PRODUCT_ITEM_ID = C.ITEM_ID
      AND    C.ACTIVE_FLAG = 'Y'
      AND    C.MONTH BETWEEN CONVERT(nvarchar(6), @plan_start_time, 112)
                        AND  CONVERT(nvarchar(6), @plan_end_time, 112)
      
      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      
      ---------------------------------------------------------------------
      -- PACK 공정은 아래에 유사한 쿼리가 있다. 그곳에서 수정하길 바란다.
      ---------------------------------------------------------------------
      UPDATE TH_MST_SCM_DEMAND_LOT
      SET    TH_MST_SCM_DEMAND_LOT.TACT_TIME_LOT = FLOOR(B.TACT_TIME_LOT)
      FROM   TH_MST_SCM_DEMAND_LOT A,
             (
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID,
                     @v_plan_id AS DPP_PLAN_ID,
                     A.ITEM_ID,
                     A.INSTANCE_TYPE,
                     CASE WHEN A.INSTANCE_TYPE IN ('E1','S')
                          THEN (( 3 * 60 * 60 ) / MAX(TACT_SECOND))
                          ELSE (( 24 * 60 * 60 - 60) / MAX(TACT_SECOND))    --10분 줄인다. ( DAY SPLIT 시 1분 수량 오버되는 애들이 있어서 )
                      END TACT_TIME_LOT
                     --(( 3 * 60 * 60 ) / MAX(TACT_SECOND)) AS DEMAND_LOT
              FROM   (
                      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, LINE_ID, MONTH,
                             A.TACT_TIME, A.TACT_TIME_UOM, B.INSTANCE_TYPE,
                             C.COATED_LENGTH, C.UNCOATED_LENGTH,C.COATED_LENGTH+C.UNCOATED_LENGTH AS LENGTH, C.LENGTH_UOM, C.ITEM_UOM,
                             CASE WHEN B.INSTANCE_TYPE IN ('E1','E2','S') AND UPPER(C.ITEM_UOM) != 'M'
                                  THEN A.TACT_TIME / (CASE WHEN A.LANE_QTY IS NULL OR A.LANE_QTY = 0 THEN 1.0 ELSE A.LANE_QTY END) 
                                       * CASE WHEN  (ISNULL(C.COATED_LENGTH,0) + ISNULL(C.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                              ELSE 
                                                    (ISNULL(C.COATED_LENGTH,0) + ISNULL(C.UNCOATED_LENGTH, 0))
                                                         / CASE UPPER(C.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                    WHEN 'CM' THEN 100
                                                                                    WHEN 'MM' THEN 1000
                                                                                              ELSE 1 
                                                           END
                                         END
                                       / ISNULL(A.PATTERN_QTY,1)
                                       * CASE A.TACT_TIME_UOM WHEN 'SECOND' THEN 1
                                                              WHEN 'MINUTE' THEN 60
                                                              WHEN 'HOUR'   THEN 3600
                                                                            ELSE 1 
                                          END
                                  WHEN B.INSTANCE_TYPE IN ('E1','E2','S') AND UPPER(C.ITEM_UOM) = 'M'
                                  THEN A.TACT_TIME / (CASE WHEN A.LANE_QTY IS NULL OR A.LANE_QTY = 0 THEN 1.0 ELSE A.LANE_QTY END) 
                                       * CASE A.TACT_TIME_UOM WHEN 'SECOND' THEN 1
                                                              WHEN 'MINUTE' THEN 60
                                                              WHEN 'HOUR'   THEN 3600
                                                                            ELSE 1
                                                              END                                                               
                                  ELSE A.TACT_TIME * CASE A.TACT_TIME_UOM WHEN 'SECOND' THEN 1
                                                                           WHEN 'MINUTE' THEN 60
                                                                           WHEN 'HOUR'   THEN 3600
                                                                                        ELSE 1
                                                      END                               
                              END AS TACT_SECOND
                      FROM   --SY_SCM_TACT_TIME_M A,
                             (SELECT A.*, 
                                     ISNULL(B.LANE_QTY,1) AS LANE_QTY, 
                                     ISNULL(C.PATTERN_QTY,1) AS PATTERN_QTY
                              FROM  SY_SCM_TACT_TIME_M A
                                    LEFT OUTER JOIN SY_SCM_ITEM_LANE_M C 
                                          ON    1=1
                                          AND   A.COMPANY_ID = C.COMPANY_ID
                                          AND   A.DIVISION_ID = C.DIVISION_ID
                                          AND   A.SITE_ID = C.SITE_ID
                                          AND   A.PLANT_ID = C.PLANT_ID
                                          AND   A.FACTORY_ID = C.FACTORY_ID
                                          AND   A.ITEM_ID = C.ITEM_ID
                                          AND   C.ACTIVE_FLAG = 'Y'
                                  , SY_SCM_ITEM_LINE_ASSIGN_M B
                              WHERE 1=1
                              AND   A.COMPANY_ID = B.COMPANY_ID
                              AND   A.DIVISION_ID = B.DIVISION_ID
                              AND   A.SITE_ID = B.SITE_ID
                              AND   A.PLANT_ID = B.PLANT_ID
                              AND   A.FACTORY_ID = B.FACTORY_ID
                              AND   A.MONTH = B.MONTH
                              AND   A.LINE_ID = B.LINE_ID
                              AND   A.ITEM_ID = B.ITEM_ID
                              AND   B.ACTIVE_FLAG = 'Y'
                             ) A,
                             (-- 닛산 제품때문에...
                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.INSTANCE_TYPE
                              FROM   (
                                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.INSTANCE_TYPE,
                                             DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID
                                                                ORDER     BY (CASE WHEN DEMAND_LOT_FLAG = 'Y' THEN 1 ELSE 9 END)
                                                                           , A.OPERATION_ID DESC) AS SEQ 
                                      FROM   (
                                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, 
                                                     B.INSTANCE_TYPE, B.DEMAND_LOT_FLAG
                                              FROM   SY_SCM_ITEM_LINE_ASSIGN_M A,
                                                     SY_SCM_OPERATION_M B
                                              WHERE  A.COMPANY_ID     = B.COMPANY_ID
                                              AND    A.DIVISION_ID    = B.DIVISION_ID
                                              AND    A.SITE_ID        = B.SITE_ID
                                              AND    A.OPERATION_ID   = B.OPERATION_ID
                                              AND    B.INSTANCE_TYPE  = @v_instance_type
                                              GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, 
                                                        B.INSTANCE_TYPE, B.DEMAND_LOT_FLAG
                                             ) A
                                     ) A
                              WHERE  SEQ = 1                                        
                             ) B,
                             SY_SCM_ITEM_M C
                      WHERE  1=1
                      --AND    EXISTS   (
                      --                SELECT '1'
                      --                FROM   TH_BUF_SCM_DEMAND B
                      --                WHERE  B.DPP_PLAN_ID = @v_plan_id
                      --                AND    B.COMPANY_ID = A.COMPANY_ID
                      --                AND    B.DIVISION_ID = A.DIVISION_ID
                      --                AND    B.SITE_ID = A.SITE_ID
                      --                --AND    B.PLANT_ID = A.PLANT_ID
                      --                AND    B.ITEM_ID = A.ITEM_ID
                      --                )
                      AND    MONTH BETWEEN CONVERT(nvarchar(6), @plan_start_time, 112)
                                      AND  CONVERT(nvarchar(6), @plan_end_time, 112)
                      AND    ISNULL(TACT_TIME, 0) > 0
                      AND    A.COMPANY_ID = B.COMPANY_ID
                      AND    A.DIVISION_ID = B.DIVISION_ID
                      AND    A.SITE_ID = B.SITE_ID
                      AND    A.ITEM_ID = B.ITEM_ID
                      AND    A.OPERATION_ID = B.OPERATION_ID
                      AND    A.COMPANY_ID = C.COMPANY_ID 
                      AND    A.DIVISION_ID = C.DIVISION_ID
                      AND    A.SITE_ID  = C.SITE_ID
                      AND    A.ITEM_ID = C.ITEM_ID
                     ) A
              GROUP  BY  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.FACTORY_ID, A.INSTANCE_TYPE
             ) B
      WHERE  A.DPP_PLAN_ID = @v_plan_id
      AND    A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.PLANT_ID = B.PLANT_ID
      AND    A.FACTORY_ID = B.FACTORY_ID
      AND    A.DPP_PLAN_ID = B.DPP_PLAN_ID
      AND    A.ITEM_ID = B.ITEM_ID

      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = 'TACT_TIME_LOT : ' + CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      ---------------------------------------------------------------------
      -- PACK 공정에 의해 TACT TIME LOT 재계산
      ---------------------------------------------------------------------
      UPDATE TH_MST_SCM_DEMAND_LOT
      SET    TH_MST_SCM_DEMAND_LOT.TACT_TIME_LOT = CEILING(B.TACT_TIME_LOT)
      FROM   TH_MST_SCM_DEMAND_LOT A,
             (
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID,
                     A.DPP_PLAN_ID,
                     B.PARENT_ITEM_ID AS ITEM_ID,
                     A.INSTANCE_TYPE,
                     A.TACT_TIME_LOT
              FROM   (
                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID,
                             @v_plan_id AS DPP_PLAN_ID,
                             A.ITEM_ID,
                             A.INSTANCE_TYPE,
                             CASE WHEN A.INSTANCE_TYPE IN ('E1','S')
                                  THEN (( 3 * 60 * 60 ) / MAX(TACT_SECOND))
                                  ELSE (( 24 * 60 * 60 ) / MAX(TACT_SECOND))
                              END TACT_TIME_LOT
                             --(( 3 * 60 * 60 ) / MAX(TACT_SECOND)) AS DEMAND_LOT
                      FROM   (
                              SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, LINE_ID, MONTH,
                                     A.TACT_TIME, A.TACT_TIME_UOM, B.INSTANCE_TYPE,
                                     C.COATED_LENGTH, C.UNCOATED_LENGTH,C.COATED_LENGTH+C.UNCOATED_LENGTH AS LENGTH, C.LENGTH_UOM, C.ITEM_UOM,
                                     CASE WHEN B.INSTANCE_TYPE IN ('E1','E2','S') AND UPPER(C.ITEM_UOM) != 'M'
                                          THEN A.TACT_TIME / (CASE WHEN A.LANE_QTY IS NULL OR A.LANE_QTY = 0 THEN 1.0 ELSE A.LANE_QTY END) 
                                               * CASE WHEN  (ISNULL(C.COATED_LENGTH,0) + ISNULL(C.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                      ELSE 
                                                            (ISNULL(C.COATED_LENGTH,0) + ISNULL(C.UNCOATED_LENGTH, 0))
                                                                 / CASE UPPER(C.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                            WHEN 'CM' THEN 100
                                                                                            WHEN 'MM' THEN 1000
                                                                                                      ELSE 1 
                                                                   END
                                                 END
                                               / ISNULL(A.PATTERN_QTY,1)
                                               * CASE A.TACT_TIME_UOM WHEN 'SECOND' THEN 1
                                                                      WHEN 'MINUTE' THEN 60
                                                                      WHEN 'HOUR'   THEN 3600
                                                                                    ELSE 1 
                                                  END
                                          WHEN B.INSTANCE_TYPE IN ('E1','E2','S') AND UPPER(C.ITEM_UOM) = 'M'
                                          THEN A.TACT_TIME / (CASE WHEN A.LANE_QTY IS NULL OR A.LANE_QTY = 0 THEN 1.0 ELSE A.LANE_QTY END) 
                                               * CASE A.TACT_TIME_UOM WHEN 'SECOND' THEN 1
                                                                      WHEN 'MINUTE' THEN 60
                                                                      WHEN 'HOUR'   THEN 3600
                                                                                    ELSE 1
                                                                      END                                                               
                                          ELSE A.TACT_TIME * CASE A.TACT_TIME_UOM WHEN 'SECOND' THEN 1
                                                                                   WHEN 'MINUTE' THEN 60
                                                                                   WHEN 'HOUR'   THEN 3600
                                                                                                ELSE 1
                                                              END                               
                                      END AS TACT_SECOND
                              FROM   --SY_SCM_TACT_TIME_M A,
                                     (SELECT A.*, 
                                             ISNULL(B.LANE_QTY,1) AS LANE_QTY, 
                                             ISNULL(C.PATTERN_QTY,1) AS PATTERN_QTY
                                      FROM  SY_SCM_TACT_TIME_M A
                                            LEFT OUTER JOIN SY_SCM_ITEM_LANE_M C 
                                                  ON    1=1
                                                  AND   A.COMPANY_ID = C.COMPANY_ID
                                                  AND   A.DIVISION_ID = C.DIVISION_ID
                                                  AND   A.SITE_ID = C.SITE_ID
                                                  AND   A.PLANT_ID = C.PLANT_ID
                                                  AND   A.FACTORY_ID = C.FACTORY_ID
                                                  AND   A.ITEM_ID = C.ITEM_ID
                                                  AND   C.ACTIVE_FLAG = 'Y'
                                          , SY_SCM_ITEM_LINE_ASSIGN_M B
                                      WHERE 1=1
                                      AND   A.COMPANY_ID = B.COMPANY_ID
                                      AND   A.DIVISION_ID = B.DIVISION_ID
                                      AND   A.SITE_ID = B.SITE_ID
                                      AND   A.PLANT_ID = B.PLANT_ID
                                      AND   A.FACTORY_ID = B.FACTORY_ID
                                      AND   A.MONTH = B.MONTH
                                      AND   A.LINE_ID = B.LINE_ID
                                      AND   A.ITEM_ID = B.ITEM_ID
                                      AND   B.ACTIVE_FLAG = 'Y'
                                     ) A,
                                     (-- 닛산 제품때문에...
                                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.INSTANCE_TYPE
                                      FROM   (
                                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.INSTANCE_TYPE,
                                                     DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID
                                                                        ORDER     BY (CASE WHEN DEMAND_LOT_FLAG = 'Y' THEN 1 ELSE 9 END)
                                                                                   , A.OPERATION_ID DESC) AS SEQ 
                                              FROM   (
                                                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, 
                                                             B.INSTANCE_TYPE, B.DEMAND_LOT_FLAG
                                                      FROM   SY_SCM_ITEM_LINE_ASSIGN_M A,
                                                             SY_SCM_OPERATION_M B
                                                      WHERE  A.COMPANY_ID     = B.COMPANY_ID
                                                      AND    A.DIVISION_ID    = B.DIVISION_ID
                                                      AND    A.SITE_ID        = B.SITE_ID
                                                      AND    A.OPERATION_ID   = B.OPERATION_ID
                                                      AND    B.INSTANCE_TYPE  = @v_instance_type
                                                      GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, 
                                                                B.INSTANCE_TYPE, B.DEMAND_LOT_FLAG
                                                     ) A
                                             ) A
                                      WHERE  SEQ = 1                                        
                                     ) B,
                                     SY_SCM_ITEM_M C
                              WHERE  1=1
                              --AND    EXISTS   (
                              --                SELECT '1'
                              --                FROM   TH_BUF_SCM_DEMAND B
                              --                WHERE  B.DPP_PLAN_ID = @v_plan_id
                              --                AND    B.COMPANY_ID = A.COMPANY_ID
                              --                AND    B.DIVISION_ID = A.DIVISION_ID
                              --                AND    B.SITE_ID = A.SITE_ID
                              --                --AND    B.PLANT_ID = A.PLANT_ID
                              --                AND    B.ITEM_ID = A.ITEM_ID
                              --                )
                              AND    MONTH BETWEEN CONVERT(nvarchar(6), @plan_start_time, 112)
                                              AND  CONVERT(nvarchar(6), @plan_end_time, 112)
                              AND    ISNULL(TACT_TIME, 0) > 0
                              AND    A.COMPANY_ID = B.COMPANY_ID
                              AND    A.DIVISION_ID = B.DIVISION_ID
                              AND    A.SITE_ID = B.SITE_ID
                              AND    A.ITEM_ID = B.ITEM_ID
                              AND    A.OPERATION_ID = B.OPERATION_ID
                              AND    A.COMPANY_ID = C.COMPANY_ID 
                              AND    A.DIVISION_ID = C.DIVISION_ID
                              AND    A.SITE_ID  = C.SITE_ID
                              AND    A.ITEM_ID = C.ITEM_ID
                             ) A
                      GROUP  BY  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.FACTORY_ID, A.INSTANCE_TYPE
             ) A
             INNER JOIN (
                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, D.FACTORY_ID, 
                                     A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                              FROM   SY_SCM_BOM_M         A,
                                     SY_SCM_ITEM_M        B,
                                     SY_SCM_ITEM_CLASS_M  C,
                                     (
                                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.SALES_MODEL_ID
                                      FROM   TH_MST_SCM_DEMAND_LOT A,
                                             TH_MST_INSTANCE_FLOW B
                                      WHERE  A.DPP_PLAN_ID = @v_plan_id
                                      AND    A.DPP_PLAN_ID = B.PLAN_ID
                                      AND    A.COMPANY_ID = B.COMPANY_ID
                                      AND    A.DIVISION_ID = B.DIVISION_ID
                                      AND    A.SITE_ID = B.SITE_ID
                                      AND    A.PLANT_ID = B.PLANT_ID
                                      AND    A.FACTORY_ID = B.FACTORY_ID
                                      AND    A.ITEM_ID = B.ITEM_ID
                                      AND    B.OPERATION_ID = 'P5500'           -- ### P5500 공정만....
                                     ) D
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
                              AND    A.COMPANY_ID     = D.COMPANY_ID
                              AND    A.DIVISION_ID    = D.DIVISION_ID
                              AND    A.SITE_ID        = D.SITE_ID
                              AND    A.PLANT_ID       = D.PLANT_ID
                              AND    A.PARENT_ITEM_ID = D.SALES_MODEL_ID
                              GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, D.FACTORY_ID, 
                                        A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                             ) B
                  ON    A.COMPANY_ID = B.COMPANY_ID
                  AND   A.DIVISION_ID = B.DIVISION_ID
                  AND   A.SITE_ID = B.SITE_ID
                  AND   A.PLANT_ID = B.PLANT_ID
                  AND   A.FACTORY_ID = B.FACTORY_ID
                  AND   A.ITEM_ID = B.CHILD_ITEM_ID
             ) B
      WHERE  A.DPP_PLAN_ID = @v_plan_id
      AND    A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.PLANT_ID = B.PLANT_ID
      AND    A.FACTORY_ID = B.FACTORY_ID
      AND    A.DPP_PLAN_ID = B.DPP_PLAN_ID
      AND    A.ITEM_ID = B.ITEM_ID

      --LOG 생성
      SET @v_message = 'TACT_TIME_LOT ( P5500) : ' + CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


      UPDATE TH_MST_SCM_DEMAND_LOT
      SET    TH_MST_SCM_DEMAND_LOT.COAT_LOT = CEILING(B.COAT_LOT_SIZE)
      FROM   TH_MST_SCM_DEMAND_LOT A,
             (
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, MIN(A.COAT_LOT_SIZE) AS COAT_LOT_SIZE
              FROM (
                     SELECT DISTINCT
                           A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.FACTORY_ID,
                           A.PARENT_ITEM_ID AS ITEM_ID, A.CHILD_ITEM_ID, A.PARENT_QTY, A.PARENT_UOM, A.CHILD_QTY, A.CHILD_UOM,
                           B.BATCH_LOT_SIZE,
                           FLOOR(-- BATCH_LOT_SIZE 는 투입 BATCH 크기 이므로, 투입에 대한 YIELD 도 반영되어야 한다.
                                 -- 수율을 나누어 주어 수량을 증가 시켜야 한다.
                                  FLOOR(B.BATCH_LOT_SIZE)/A.CHILD_QTY*PARENT_QTY      -- ENGINE BATCH SITE 는 FLOOR 해 주므로,, 여기도,,,
                                   * (CASE WHEN D.YIELD IS NULL OR D.YIELD = 0 THEN 1.0 ELSE D.YIELD END)
                                   * (CASE WHEN E.YIELD IS NULL OR E.YIELD = 0 THEN 1.0 ELSE E.YIELD END)
                                  /*
                                  B.BATCH_LOT_SIZE/A.CHILD_QTY*PARENT_QTY
                                   * (CASE WHEN D.YIELD IS NULL OR D.YIELD = 0 THEN 1.0 ELSE D.YIELD END)
                                   * (CASE WHEN E.YIELD IS NULL OR E.YIELD = 0 THEN 1.0 ELSE E.YIELD END)
                                  */
                                 )
                           AS  COAT_LOT_SIZE
                    FROM  (
                           SELECT *
                           FROM   SY_SCM_BOM_M A
                           WHERE  1=1
                           AND    A.EFF_END_DATE > GETDATE()
                           AND    A.ACTIVE_FLAG = 'Y'
                           AND    A.PARENT_QTY > 0
                           AND    A.CHILD_QTY > 0
                           AND    EXISTS (
                                          SELECT 1
                                          FROM   TH_MST_SCM_DEMAND_LOT X
                                          WHERE  A.PARENT_ITEM_ID = X.ITEM_ID
                                          AND    A.COMPANY_ID = X.COMPANY_ID
                                          AND    A.DIVISION_ID = X.DIVISION_ID
                                          AND    A.SITE_ID = X.SITE_ID
                                          AND    A.PLANT_ID = X.PLANT_ID
                                          AND    X.DPP_PLAN_ID = @v_plan_id
                                         )
                          ) A
                          INNER JOIN SY_SCM_ITEM_EQUIP_RATE_BATCH_M B
                                ON    A.CHILD_ITEM_ID = B.ITEM_ID
                                AND   A.DIVISION_ID = B.DIVISION_ID
                                AND   A.SITE_ID = B.SITE_ID
                                AND   A.PLANT_ID = B.PLANT_ID
                          INNER JOIN SY_SCM_ITEM_LINE_ASSIGN_M C
                                ON    A.CHILD_ITEM_ID = C.ITEM_ID
                                AND   A.DIVISION_ID = C.DIVISION_ID
                                AND   A.SITE_ID = C.SITE_ID
                                AND   A.PLANT_ID = C.PLANT_ID
                                AND   C.ACTIVE_FLAG = 'Y'
                                AND   B.FACTORY_ID = C.FACTORY_ID
                                AND   C.MONTH BETWEEN CONVERT(nvarchar(6), @plan_start_time, 112)
                                                  AND CONVERT(nvarchar(6), @plan_end_time, 112)
                          LEFT OUTER JOIN SY_SCM_YIELD_M D
                                ON A.DIVISION_ID = D.DIVISION_ID
                                AND A.SITE_ID = D.SITE_ID
                                AND A.PLANT_ID = D.PLANT_ID
                                AND A.PARENT_ITEM_ID = D.ITEM_ID
                                AND C.FACTORY_ID = D.FACTORY_ID
                                AND C.MONTH = D.MONTH
                                AND D.OPERATION_ID IN ('E2000','S2000')
                          LEFT OUTER JOIN SY_SCM_YIELD_M E
                                ON A.DIVISION_ID = E.DIVISION_ID
                                AND A.SITE_ID = E.SITE_ID
                                AND A.PLANT_ID = E.PLANT_ID
                                AND A.CHILD_ITEM_ID = E.ITEM_ID
                                AND C.FACTORY_ID = E.FACTORY_ID
                                AND C.MONTH = E.MONTH
                   ) A
              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID
              HAVING MIN(A.COAT_LOT_SIZE) IS NOT NULL
             ) B
      WHERE  A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.PLANT_ID = B.PLANT_ID
      AND    A.FACTORY_ID = B.FACTORY_ID
      AND    A.ITEM_ID = B.ITEM_ID
      AND    A.DPP_PLAN_ID = @v_plan_id

      --LOG 생성
      SET @v_message = 'COAT_LOT : ' + CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      UPDATE TH_MST_SCM_DEMAND_LOT
      SET    TH_MST_SCM_DEMAND_LOT.LANE_QTY = CEILING(B.LANE_QTY)
      FROM   TH_MST_SCM_DEMAND_LOT A,
             (
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,
                     MAX(LANE_QTY) AS LANE_QTY
              FROM   (       
                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.FACTORY_ID, A.ITEM_ID,
                             B.LANE_QTY
                      FROM   TH_MST_SCM_DEMAND A
                             INNER JOIN (
                                              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID
                                                   , MAX(LANE_QTY) LANE_QTY
                                              FROM   SY_SCM_ITEM_LANE_M
                                              GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID
                                             ) B
                                   ON     A.COMPANY_ID = B.COMPANY_ID
                                   AND    A.DIVISION_ID = B.DIVISION_ID
                                   AND    A.SITE_ID = B.SITE_ID
                                   AND    A.PLANT_ID = B.PLANT_ID
                                   AND    A.ITEM_ID = B.ITEM_ID
                             INNER JOIN SY_SCM_ITEM_M C
                                   ON     A.COMPANY_ID = C.COMPANY_ID
                                   AND    A.DIVISION_ID = C.DIVISION_ID
                                   AND    A.SITE_ID = C.SITE_ID
                                   --AND    A.PLANT_ID = C.PLANT_ID
                                   AND    A.ITEM_ID = C.ITEM_ID
                     ) A
              GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID
              HAVING MAX(LANE_QTY) IS NOT NULL
             ) B
      WHERE  A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.PLANT_ID = B.PLANT_ID
      AND    A.FACTORY_ID = B.FACTORY_ID
      AND    A.ITEM_ID = B.ITEM_ID      
      AND    A.DPP_PLAN_ID = @v_plan_id

      --LOG 생성
      SET @v_message = 'LANE_QTY : ' + CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      UPDATE TH_MST_SCM_DEMAND_LOT
      SET    TH_MST_SCM_DEMAND_LOT.DEMAND_LOT_SIZE = CEILING(B.DEMAND_LOT_SIZE)
      FROM   TH_MST_SCM_DEMAND_LOT A,
             (
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.ITEM_ID, 
                    MIN(DEMAND_LOT_SIZE) AS DEMAND_LOT_SIZE
              FROM (SELECT DISTINCT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.ITEM_ID, A.OPERATION_LOT_SIZE AS DEMAND_LOT_SIZE
                    FROM SY_SCM_ITEM_FLOW_V A,
                         SY_SCM_OPERATION_M B
                    WHERE 1=1
                    AND   A.COMPANY_ID = B.COMPANY_ID
                    AND   A.DIVISION_ID = B.DIVISION_ID
                    AND   A.SITE_ID = B.SITE_ID
                    AND   A.OPERATION_ID = B.OPERATION_ID
                    AND   B.DEMAND_LOT_FLAG = 'Y'
                    AND   B.INSTANCE_TYPE = @v_instance_type
               )  A                                           
              WHERE 1=1
              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.ITEM_ID
              HAVING MIN(DEMAND_LOT_SIZE) IS NOT NULL
             ) B
      WHERE  A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.ITEM_ID = B.ITEM_ID
      AND    A.DPP_PLAN_ID = @v_plan_id

      --LOG 생성
      SET @v_message = 'DEMAND_LOT_SIZE : ' + CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
      /*
      UPDATE TH_MST_SCM_DEMAND_LOT
      SET    SPLIT_LOT_SIZE = (
                                CASE  WHEN INSTANCE_TYPE IN ('E1','S') 
                                      THEN (CASE WHEN COAT_LOT IS NULL OR COAT_LOT = 0 THEN TACT_TIME_LOT ELSE COAT_LOT END)
                                      ELSE TACT_TIME_LOT
                                END            
                              )
      WHERE  DPP_PLAN_ID = @v_plan_id

      --LOG 생성
      SET @v_message = 'SPLIT_LOT_SIZE : ' + CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      */

      UPDATE TH_MST_SCM_DEMAND_LOT
      SET    TH_MST_SCM_DEMAND_LOT.PLANT_LOT_SIZE = B.PLANT_LOT_SIZE
            ,TH_MST_SCM_DEMAND_LOT.YIELD          = B.YIELD
            ,TH_MST_SCM_DEMAND_LOT.UTILIZATION    = B.UTILIZATION
      FROM   TH_MST_SCM_DEMAND_LOT A,
             (
              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID,
                     CASE WHEN INSTANCE_TYPE IN ('E1','S') AND ISNULL(LANE_QTY,0) > 0 
                                                             AND LANE_QTY IS NOT NULL
                                                         THEN CEILING(SPLIT_LOT_SIZE)
                          WHEN DEMAND_LOT_SIZE IS NULL THEN SPLIT_LOT_SIZE
                          WHEN DEMAND_LOT_SIZE = 0     THEN SPLIT_LOT_SIZE
                          ELSE DEMAND_LOT_SIZE
                     END  PLANT_LOT_SIZE,
                     YIELD, UTILIZATION
              FROM   (                 
                      SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, INSTANCE_TYPE,
                             LANE_QTY, DEMAND_LOT_SIZE, YIELD, UTILIZATION,
                             CASE WHEN INSTANCE_TYPE IN ('E1','S')
                                  THEN (CASE WHEN COAT_LOT IS NULL OR COAT_LOT = 0 THEN TACT_TIME_LOT ELSE  COAT_LOT END)
                                  ELSE TACT_TIME_LOT
                             END  SPLIT_LOT_SIZE
                      FROM   (
                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.INSTANCE_TYPE
                                   , CEILING(LANE_QTY        * B.YIELD * B.UTILIZATION ) AS LANE_QTY
                                 --, CEILING(COAT_LOT        * B.YIELD                 ) AS COAT_LOT
                                   , CEILING(COAT_LOT                                  ) AS COAT_LOT    -- 이미 투입 YIELD 가 선반영되어 있음
                                   , CEILING(TACT_TIME_LOT   * B.YIELD * B.UTILIZATION ) AS TACT_TIME_LOT
                                   , CEILING(DEMAND_LOT_SIZE * B.YIELD * B.UTILIZATION ) AS DEMAND_LOT_SIZE
                                   , B.YIELD, B.UTILIZATION
                              FROM   (                                  
                                      SELECT DISTINCT
                                             COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, INSTANCE_TYPE
                                           , MAX(LANE_QTY)        OVER(PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID) AS LANE_QTY
                                           , MIN(COAT_LOT)        OVER(PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID,           ITEM_ID) AS COAT_LOT       -- COAT 는 MIN
                                           , MAX(TACT_TIME_LOT)   OVER(PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID) AS TACT_TIME_LOT  -- TACT 는 MAX
                                           , MIN(DEMAND_LOT_SIZE) OVER(PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID,           ITEM_ID) AS DEMAND_LOT_SIZE
                                      FROM   TH_MST_SCM_DEMAND_LOT
                                      WHERE  DPP_PLAN_ID = @v_plan_id
                                     ) A
                                     LEFT OUTER JOIN (
                                                      SELECT A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.SITE_ID, 
                                                             CASE WHEN MAX(YIELD) IS NULL THEN 1.0
                                                                  WHEN MAX(YIELD) = 0 THEN 1.0
                                                                  ELSE MAX(YIELD) 
                                                             END  AS YIELD, 
                                                             CASE WHEN MAX(UTILIZATION) IS NULL THEN 1.0
                                                                  WHEN MAX(UTILIZATION) = 0     THEN 1.0
                                                                  ELSE MAX(UTILIZATION) 
                                                             END  AS UTILIZATION
                                                      FROM   (
                                                              SELECT A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.YIELD, B.UTILIZATION,
                                                                     DENSE_RANK() OVER (PARTITION BY A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.SITE_ID ORDER BY A.OPERATION_ID DESC) SEQ 
                                                              FROM   TH_MST_OP_RESOURCE A,
                                                                     TH_MST_RESOURCE B
                                                              WHERE  A.MASTER_ID    = @v_master_id
                                                              AND    A.PLAN_ID      = @v_plan_id
                                                              AND    A.MASTER_ID    = B.MASTER_ID
                                                              AND    A.PLAN_ID      = B.PLAN_ID
                                                              AND    A.RESOURCE_ID  = B.RESOURCE_ID
                                                             ) A       
                                                      WHERE  SEQ = 1
                                                      GROUP  BY A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.SITE_ID
                                                     ) B
                                          ON     A.FACTORY_ID   = B.SITE_ID
                                          AND    A.ITEM_ID      = B.ITEM_ID
                             ) A
                     ) A
             ) B
      WHERE  A.DPP_PLAN_ID = @v_plan_id
      AND    A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.PLANT_ID = B.PLANT_ID
      AND    A.FACTORY_ID = B.FACTORY_ID
      AND    A.ITEM_ID = B.ITEM_ID
      AND    B.PLANT_LOT_SIZE IS NOT NULL

      --LOG 생성
      SET @v_message = 'PLANT_LOT_SIZE : ' + CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      UPDATE TH_MST_SCM_DEMAND_LOT
      SET    TH_MST_SCM_DEMAND_LOT.FACTORY_LOT_SIZE = B.FACTORY_LOT_SIZE
            ,TH_MST_SCM_DEMAND_LOT.YIELD            = B.YIELD
            ,TH_MST_SCM_DEMAND_LOT.UTILIZATION      = B.UTILIZATION
      FROM   TH_MST_SCM_DEMAND_LOT A,
             (
              SELECT DIVISION_ID, FACTORY_ID, ITEM_ID,
                     CASE WHEN INSTANCE_TYPE IN ('E1','S') AND ISNULL(LANE_QTY,0) > 0 
                                                             AND LANE_QTY IS NOT NULL
                                                         THEN CEILING(SPLIT_LOT_SIZE)
                          WHEN DEMAND_LOT_SIZE IS NULL THEN SPLIT_LOT_SIZE
                          WHEN DEMAND_LOT_SIZE = 0     THEN SPLIT_LOT_SIZE
                          ELSE DEMAND_LOT_SIZE
                     END  FACTORY_LOT_SIZE
                   , YIELD, UTILIZATION
              FROM   (
                      SELECT A.DIVISION_ID, A.FACTORY_ID, A.ITEM_ID, A.INSTANCE_TYPE
                           , LANE_QTY, COAT_LOT, YIELD, UTILIZATION
                           , TACT_TIME_LOT
                           , DEMAND_LOT_SIZE
                           , CASE  WHEN INSTANCE_TYPE IN ('E1','S') 
                                   THEN (CASE WHEN COAT_LOT IS NULL OR COAT_LOT = 0 THEN TACT_TIME_LOT ELSE COAT_LOT END)
                                   ELSE TACT_TIME_LOT
                             END   AS SPLIT_LOT_SIZE
                      FROM   (
                              SELECT A.DIVISION_ID, A.FACTORY_ID, A.ITEM_ID, A.INSTANCE_TYPE
                                   , CEILING(LANE_QTY        * B.YIELD * B.UTILIZATION ) AS LANE_QTY
                                 --, CEILING(COAT_LOT        * B.YIELD                 ) AS COAT_LOT
                                   , CEILING(COAT_LOT                                  ) AS COAT_LOT        -- 이미 투입 YIELD 가 선반영되어 있음
                                   , CEILING(TACT_TIME_LOT   * B.YIELD * B.UTILIZATION ) AS TACT_TIME_LOT
                                   , CEILING(DEMAND_LOT_SIZE * B.YIELD * B.UTILIZATION ) AS DEMAND_LOT_SIZE
                                   , B.YIELD, B.UTILIZATION
                              FROM   TH_MST_SCM_DEMAND_LOT A
                                     LEFT OUTER JOIN (
                                                      SELECT A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.SITE_ID, 
                                                             CASE WHEN MAX(YIELD) IS NULL THEN 1.0
                                                                  WHEN MAX(YIELD) = 0 THEN 1.0
                                                                  ELSE MAX(YIELD) 
                                                             END  AS YIELD, 
                                                             CASE WHEN MAX(UTILIZATION) IS NULL THEN 1.0
                                                                  WHEN MAX(UTILIZATION) = 0     THEN 1.0
                                                                  ELSE MAX(UTILIZATION) 
                                                             END  AS UTILIZATION
                                                      FROM   (
                                                              SELECT A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.YIELD, B.UTILIZATION,
                                                                     DENSE_RANK() OVER (PARTITION BY A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.SITE_ID ORDER BY A.OPERATION_ID DESC) SEQ 
                                                              FROM   TH_MST_OP_RESOURCE A,
                                                                     TH_MST_RESOURCE B
                                                              WHERE  A.MASTER_ID    = @v_master_id
                                                              AND    A.PLAN_ID      = @v_plan_id
                                                              AND    A.MASTER_ID    = B.MASTER_ID
                                                              AND    A.PLAN_ID      = B.PLAN_ID
                                                              AND    A.RESOURCE_ID  = B.RESOURCE_ID
                                                             ) A       
                                                      WHERE  SEQ = 1
                                                      GROUP  BY A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.SITE_ID
                                                     ) B
                                          ON     A.FACTORY_ID   = B.SITE_ID
                                          AND    A.ITEM_ID      = B.ITEM_ID
                              WHERE  A.DPP_PLAN_ID = @v_plan_id
                             ) A
                     ) A
             ) B
      WHERE  A.DPP_PLAN_ID = @v_plan_id
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.FACTORY_ID = B.FACTORY_ID
      AND    A.ITEM_ID = B.ITEM_ID
      AND    B.FACTORY_LOT_SIZE IS NOT NULL

      --LOG 생성
      SET @v_message = 'FACTORY_LOT_SIZE : ' + CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      /*
      -- 바로 위에서 반영
      -- FACTORY 별 수율, UTILIZATION 적용
      UPDATE TH_MST_SCM_DEMAND_LOT
      SET    TH_MST_SCM_DEMAND_LOT.YIELD = B.YIELD
           , TH_MST_SCM_DEMAND_LOT.UTILIZATION = B.UTILIZATION
           , TH_MST_SCM_DEMAND_LOT.APPLY_LOT_SIZE = CEILING(ISNULL(A.FACTORY_LOT_SIZE, A.PLANT_LOT_SIZE) * B.YIELD * B.UTILIZATION) 
      FROM   TH_MST_SCM_DEMAND_LOT A,
             (
              SELECT A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.SITE_ID, 
                     CASE WHEN MAX(YIELD) IS NULL THEN 1.0
                          WHEN MAX(YIELD) = 0 THEN 1.0
                          ELSE MAX(YIELD) 
                     END  AS YIELD, 
                     CASE WHEN MAX(UTILIZATION) IS NULL THEN 1.0
                          WHEN MAX(UTILIZATION) = 0     THEN 1.0
                          ELSE MAX(UTILIZATION) 
                     END  AS UTILIZATION
              FROM   (
                      SELECT A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.YIELD, B.UTILIZATION,
                             DENSE_RANK() OVER (PARTITION BY A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.SITE_ID ORDER BY A.OPERATION_ID DESC) SEQ 
                      FROM   TH_MST_OP_RESOURCE A,
                             TH_MST_RESOURCE B
                      WHERE  A.MASTER_ID    = @v_master_id
                      AND    A.PLAN_ID      = @v_plan_id
                      AND    A.MASTER_ID    = B.MASTER_ID
                      AND    A.PLAN_ID      = B.PLAN_ID
                      AND    A.RESOURCE_ID  = B.RESOURCE_ID
                     ) A       
              WHERE  SEQ = 1
              GROUP  BY A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.SITE_ID
             ) B
      WHERE  A.DPP_PLAN_ID  = @v_plan_id
      AND    A.FACTORY_ID   = B.SITE_ID
      AND    A.ITEM_ID      = B.ITEM_ID
      */

      -- PRE MIX 는 이동 LOT SITE 인 1000 Kg 로 DEMAND 사이즈 설정
      IF CHARINDEX('E_PMIX', @v_master_id) > 0
        UPDATE TH_MST_SCM_DEMAND_LOT
        SET    APPLY_LOT_SIZE = 1000
        WHERE  DPP_PLAN_ID  = @v_plan_id

      ELSE
        UPDATE TH_MST_SCM_DEMAND_LOT
        SET    APPLY_LOT_SIZE = ISNULL(FACTORY_LOT_SIZE, PLANT_LOT_SIZE)
        WHERE  DPP_PLAN_ID  = @v_plan_id
      
      --LOG 생성
      SET @v_message = 'APPLY_LOT_SIZE : ' + CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
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
