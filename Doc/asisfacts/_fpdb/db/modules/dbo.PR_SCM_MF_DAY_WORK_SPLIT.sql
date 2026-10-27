CREATE PROCEDURE [dbo].[PR_SCM_MF_DAY_WORK_SPLIT]  
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MF_DAY_WORK_SPLIT                                                  **/
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
/** 2016.09.29    HJH          최초 작성                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_MF_DAY_WORK_SPLIT
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  DECLARE
    @v_proc_name        nvarchar(150) = 'PR_SCM_MF_DAY_WORK_SPLIT', 
    @v_table_name       nvarchar(150) = NULL, 
    @v_master_id        nvarchar(150) = @p_master_id, 
    @v_plan_id          nvarchar(150) = @p_plan_id
    
  DECLARE
    @n_count            Integer  = 0,
    @n_log_count        Integer  = 0,
    @sysdate            DATETIME2 = GETDATE(),
    @v_message          nvarchar(200),
    @v_description      nvarchar(200)

    
  BEGIN TRY
    --LOG 생성
    SET @n_log_count = @n_log_count + 1
    SET @sysdate = GETDATE()
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, '###############', 'START', @n_log_count, null, '############### Start of procedure ###############', null

    BEGIN
    
      BEGIN
    
        SET @v_table_name = 'TH_BUF_SCM_WORK_MERGE'
        
        DELETE FROM TH_BUF_SCM_WORK_MERGE
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID   = @v_plan_id
      
        INSERT INTO TH_BUF_SCM_WORK_MERGE
             (
               MASTER_ID
             , PLAN_ID
             , WORK_ORDER_ID
             , ORG_WORK_ORDER_ID
             , DEMAND_ID
             , ORG_DEMAND_ID
             , RESOURCE_ID
             , ITEM_ID
             , SITE_ID
             , ROUTE_ID
             , OPERATION_ID
             , START_TIME
             , END_TIME
             , TOTAL_WORKING_TIME
             , COMPLETE_QTY
             , START_DATE
             , END_DATE
             , SEQ
             , ORDER_SEQ
             , INSERT_TIME
             )
        SELECT A.MASTER_ID
             , A.PLAN_ID
             , A.WORK_ORDER_ID
             , A.ORG_WORK_ORDER_ID
             , A.DEMAND_ID
             , C.DEMAND_ID AS ORG_DEMAND_ID
             , A.RESOURCE_ID
             , A.ITEM_ID
             , A.SITE_ID
             , A.ROUTE_ID
             , A.OPERATION_ID
             , A.START_TIME
             , A.END_TIME
             , A.TOTAL_WORKING_TIME
             , A.COMPLETE_QTY AS COMPLETE_QTY
             , B.START_DATE
             , B.END_DATE
             , DENSE_RANK() OVER (PARTITION BY C.DEMAND_ID ORDER BY SITE_ID, ROUTE_ID, OPERATION_ID, START_DATE) AS SEQ
             , DENSE_RANK() OVER (ORDER BY SITE_ID, ROUTE_ID, OPERATION_ID, START_DATE, START_TIME, WORK_ORDER_ID) AS ORDER_SEQ
             , GETDATE()
        FROM   (
                SELECT *
                FROM   TH_OUT_WORK_ORDER_SPL A,
                       (
                        SELECT DEMAND_ID, ORDER_ID
                        FROM   TH_OUT_ORDER_TRACKING A
                        WHERE  MASTER_ID      = @v_master_id
                        AND    PLAN_ID        = @v_plan_id
                        AND    OUT_VERSION_ID = @v_plan_id
                        AND    OPERATION_ID IN (
                                                'A9000', 'A3000'    -- CELL
                                               ,'P5500', 'P9500'    -- PACK
                                               )
                        GROUP  BY DEMAND_ID, ORDER_ID
                       ) B
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    A.OUT_VERSION_ID = @v_plan_id
                AND    A.ORG_WORK_ORDER_ID = B.ORDER_ID
               ) A,
               (
                SELECT DATEADD(DAY, INT-1, PLAN_START_DTTM) AS START_DATE,
                       DATEADD(DAY, INT-0, PLAN_START_DTTM) AS END_DATE
                FROM   TH_ENG_PLAN_INFO A,
                       COPYT B
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    A.PLAN_HORIZON  >= INT
               ) B,
               TH_DPP_NET_DEMAND C
        WHERE  A.START_TIME  >= B.START_DATE
        AND    A.END_TIME    <= B.END_DATE
        AND    A.MASTER_ID    = C.MASTER_ID
        AND    A.PLAN_ID      = C.PLAN_ID
        AND    A.DEMAND_ID    = C.NET_DEMAND_ID
        AND    C.PO_TYPE     != 'FIX'

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
          
        UPDATE TH_BUF_SCM_WORK_MERGE
        SET    TH_BUF_SCM_WORK_MERGE.PLAN_QTY = B.COMPLETE_QTY
        FROM   TH_BUF_SCM_WORK_MERGE A,
               TH_OUT_WORK_ORDER     B
        WHERE  A.MASTER_ID          = @v_master_id
        AND    A.PLAN_ID            = @v_plan_id
        AND    A.MASTER_ID          = B.MASTER_ID
        AND    A.PLAN_ID            = B.PLAN_ID
        AND    A.PLAN_ID            = B.OUT_VERSION_ID
        AND    A.ORG_WORK_ORDER_ID  = B.WORK_ORDER_ID
        
          
        --LOG 생성
        SET @v_message = 'PLAN_QTY : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

        -- 소수점 몰아주기
        UPDATE TH_BUF_SCM_WORK_MERGE
        SET    TH_BUF_SCM_WORK_MERGE.NEW_COMPLETE_QTY = ( B.NEXT_SUM_COMPLETE_QTY - B.PRE_SUM_COMPLETE_QTY)
        FROM   TH_BUF_SCM_WORK_MERGE A,
               (
                SELECT A.*,
                       LAG(CEILING(SUM_COMPLETE_QTY), 1, 0) OVER ( PARTITION BY A.ORG_WORK_ORDER_ID
                                                                   ORDER     BY A.SEQ )  PRE_SUM_COMPLETE_QTY,
                       CEILING(SUM_COMPLETE_QTY) AS NEXT_SUM_COMPLETE_QTY
                FROM   (        
                        SELECT A.*,
                               CASE WHEN TEMP_COMPLETE_QTY > PLAN_QTY THEN PLAN_QTY 
                                                                      ELSE TEMP_COMPLETE_QTY 
                               END  AS SUM_COMPLETE_QTY
                        FROM   (
                                SELECT A.*
                                     , SUM(A.COMPLETE_QTY) OVER ( PARTITION BY A.ORG_WORK_ORDER_ID
                                                                  ORDER     BY A.SEQ ) AS TEMP_COMPLETE_QTY
                                FROM   TH_BUF_SCM_WORK_MERGE A
                                WHERE  A.MASTER_ID = @v_master_id
                                AND    A.PLAN_ID   = @v_plan_id
                               ) A
                       ) A
               ) B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.WORK_ORDER_ID  = B.WORK_ORDER_ID         
        
        --LOG 생성
        SET @v_message = 'CEILING : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

        
        -- TOLERANCE 설정하는 부분임.
        UPDATE TH_BUF_SCM_WORK_MERGE
        SET    TH_BUF_SCM_WORK_MERGE.NEW_COMPLETE_QTY = B.NEW_QTY
        FROM   TH_BUF_SCM_WORK_MERGE A,
               (
                SELECT A.*,
                       CASE WHEN CHK_QTY = 0        THEN 0
                            WHEN ACC_QTY = TOT_QTY  THEN PLAN_QTY - TOT_QTY
                            ELSE 0
                       END  + CHK_QTY AS NEW_QTY
                FROM   (
                        SELECT A.*
                             , SUM(CHK_QTY) OVER ( PARTITION BY A.ORG_WORK_ORDER_ID
                                                   ORDER     BY A.SEQ ) AS ACC_QTY
                             , SUM(CHK_QTY) OVER ( PARTITION BY A.ORG_WORK_ORDER_ID
                                                                      ) AS TOT_QTY       
                        FROM   (
                                SELECT A.*,
                                       CASE WHEN WO_SEQ = 1 THEN NEW_COMPLETE_QTY
                                            WHEN WO_SEQ > 1 AND  NEW_COMPLETE_QTY <= TOLERANCE THEN 0
                                            ELSE NEW_COMPLETE_QTY
                                       END  CHK_QTY
                                FROM   (
                                        SELECT A.*, B.TOLERANCE
                                        FROM   (
                                                SELECT A.*
                                                     , DENSE_RANK() OVER ( PARTITION BY A.ORG_WORK_ORDER_ID
                                                                           ORDER     BY A.SEQ ) AS WO_SEQ
                                                FROM   TH_BUF_SCM_WORK_MERGE A
                                                WHERE  A.MASTER_ID    = @v_master_id
                                                AND    A.PLAN_ID      = @v_plan_id
                                                AND    A.COMPLETE_QTY > 0
                                               ) A,
                                               (--  TOLERANCE 정보 설정 부분
                                                SELECT 1 TOLERANCE
                                               ) B
                                        WHERE  TOLERANCE > 0
                                       ) A
                               ) A
                       ) A
               ) B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.WORK_ORDER_ID  = B.WORK_ORDER_ID         

        --LOG 생성
        SET @v_message = 'TOLERANCE : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description
        
      END
      
      
      SET @v_table_name = 'TH_ENG_NET_DEMAND'
      
      INSERT INTO TH_ENG_NET_DEMAND
      SELECT 
             A.MASTER_ID
           , A.PLAN_ID
           , B.ORG_DEMAND_ID + '::FP' + CONVERT(NVARCHAR, C.PLAN_START_DTTM, 12)
                             + '##'
                             + CASE WHEN B.SEQ < 10 THEN '00'
                                    WHEN B.SEQ < 100 THEN '0'
                                                      ELSE ''
                               END
                             + CONVERT(NVARCHAR, B.SEQ) 
               AS DEMAND_ID
           , A.SALES_MODEL_ID
           , MIN(A.SHIPPING_DATE)             AS SHIPPING_DATE
           , MIN(B.START_TIME)                  AS DUE_DATE
           , MIN(A.DUE_FENCE_DATE)            AS DUE_FENCE_DATE
           , 0                                AS EARLY_PRODUCING_TERM
           , 'DAY'                            AS EARLY_PRODUCING_TERM_UOM
           , SUM(B.NEW_COMPLETE_QTY)          AS QTY
           , SUM(B.NEW_COMPLETE_QTY)          AS SPLIT_QTY
           , MIN(A.ORDER_TYPE)                AS ORDER_TYPE
           , MIN(A.DEMAND_TYPE)               AS DEMAND_TYPE
           , MIN(A.PRODUCING_TYPE)            AS PRODUCING_TYPE
           , MIN(A.PRIORITY_GROUP_CODE)       AS PRIORITY_GROUP_CODE
           , MIN(A.PRIORITY)                  AS PRIORITY
           , MIN(A.ATTRIBUTE_CHECKER_ID)      AS ATTRIBUTE_CHECKER_ID
           , MIN(A.DEMAND_GROUP_ID)           AS DEMAND_GROUP_ID
           , MIN(A.LATE_TYPE)                 AS LATE_TYPE
           , MIN(A.DESCR)                     AS DESCR
           , MIN(A.MOVE_TIME_RATE)            AS MOVE_TIME_RATE
           , MIN(A.BUFFER_TIME_RATE)          AS BUFFER_TIME_RATE
           , MIN(A.IS_EXCEPTION)              AS IS_EXCEPTION
           , MIN(A.IS_CONSUME)                AS IS_CONSUME
      FROM   TH_ENG_NET_DEMAND A,
             TH_BUF_SCM_WORK_MERGE B,
             TH_ENG_PLAN_INFO C
      WHERE  A.MASTER_ID        = @v_master_id
      AND    A.PLAN_ID          = @v_plan_id
      AND    A.MASTER_ID        = B.MASTER_ID
      AND    A.PLAN_ID          = B.PLAN_ID
      AND    A.DEMAND_ID        = B.DEMAND_ID
      AND    B.NEW_COMPLETE_QTY > 0
      AND    A.MASTER_ID        = C.MASTER_ID
      AND    A.PLAN_ID          = C.PLAN_ID
      GROUP  BY A.MASTER_ID
              , A.PLAN_ID
              , A.SALES_MODEL_ID
              , B.ORG_DEMAND_ID
              , B.SEQ
              , CONVERT(NVARCHAR, C.PLAN_START_DTTM, 12)

      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

        
      DELETE FROM A        
      FROM   TH_ENG_NET_DEMAND A,
             TH_BUF_SCM_WORK_MERGE B
      WHERE  A.MASTER_ID  = @v_master_id
      AND    A.PLAN_ID    = @v_plan_id
      AND    A.MASTER_ID  = B.MASTER_ID
      AND    A.PLAN_ID    = B.PLAN_ID
      AND    A.DEMAND_ID  = B.DEMAND_ID
        
      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description


      SET @v_table_name = 'TH_DPP_NET_DEMAND'
      
      INSERT INTO TH_DPP_NET_DEMAND
      SELECT 
             A.MASTER_ID
           , A.PLAN_ID
           , B.ORG_DEMAND_ID + '::FP' + CONVERT(NVARCHAR, C.PLAN_START_DTTM, 12)
                             + '##'
                             + CASE WHEN B.SEQ < 10 THEN '00'
                                    WHEN B.SEQ < 100 THEN '0'
                                                      ELSE ''
                               END
                             + CONVERT(NVARCHAR, B.SEQ) 
               AS NET_DEMAND_ID
           , B.ORG_DEMAND_ID                  AS DEMAND_ID
           , MIN(A.SALES_ORDER_ID)            AS SALES_ORDER_ID
           , A.SALES_MODEL
           , MIN(A.PRODUCTION_ORDER_ID)       AS PRODUCTION_ORDER_ID
           , MIN(A.PO_TYPE)                   AS PO_TYPE
           , MIN(A.ITEM_ID)                   AS ITEM_ID
           , SUM(B.NEW_COMPLETE_QTY)          AS QTY
           , SUM(B.NEW_COMPLETE_QTY)          AS ORG_QTY
           , MIN(A.DUE_DATE)                  AS DUE_DATE
           , MIN(A.SHIPPING_DATE)             AS SHIPPING_DATE
           , MIN(A.DUE_FENCE_DATE)            AS DUE_FENCE_DATE
           , MIN(A.MFG_WEEK)                  AS MFG_WEEK
           , MIN(A.SOP_WEEK)                  AS SOP_WEEK
           , MIN(A.SPLIT_DATE)                AS SPLIT_DATE
           , MIN(A.ORDER_TYPE)                AS ORDER_TYPE
           , MIN(A.DEMAND_TYPE)               AS DEMAND_TYPE
           , MIN(A.PRODUCING_TYPE)            AS PRODUCING_TYPE
           , MIN(A.FROM_SITE_ID)              AS TO_SITE_ID
           , MIN(A.TO_SITE_ID)                AS TO_SITE_ID
           , MIN(A.CUSTOMER_ID)               AS CUSTOMER_ID
           , MIN(A.MARKET)                    AS MARKET
           , MIN(A.DEMAND_GROUP_PRIORITY)     AS DEMAND_GROUP_PRIORITY
           , MIN(A.DEMAND_PRIORITY)           AS DEMAND_PRIORITY
           , MIN(A.EARLY_PRODUCING_TERM)      AS EARLY_PRODUCING_TERM
           , MIN(A.EARLY_PRODUCING_TERM_UOM)  AS EARLY_PRODUCING_TERM_UOM
           , MIN(A.ATTRIBUTE_CHECKER_ID)      AS ATTRIBUTE_CHECKER_ID
           , SUM(B.NEW_COMPLETE_QTY)          AS SPLIT_QTY
           , MIN(A.IS_SCHEDULE)               AS IS_SCHEDULE
           , MIN(A.IS_EXCEPTION)              AS IS_EXCEPTION
           , MAX(A.IS_CONSUME)                AS IS_CONSUME
           , MIN(A.DESCR)                     AS DESCR
           , MIN(A.KEY_DATE)                  AS KEY_DATE
           , MIN(A.INSERT_ID)                 AS INSERT_ID
           , MIN(A.INSERT_DTTM)               AS INSERT_DTTM
           , MIN(A.UPDATE_ID)                 AS UPDATE_ID
           , MIN(A.UPDATE_DTTM)               AS UPDATE_DTTM
      FROM   TH_DPP_NET_DEMAND A,
             TH_BUF_SCM_WORK_MERGE B,
             TH_ENG_PLAN_INFO C
      WHERE  A.MASTER_ID        = @v_master_id
      AND    A.PLAN_ID          = @v_plan_id
      AND    A.MASTER_ID        = B.MASTER_ID
      AND    A.PLAN_ID          = B.PLAN_ID
      AND    A.NET_DEMAND_ID    = B.DEMAND_ID
      AND    B.NEW_COMPLETE_QTY > 0
      AND    A.MASTER_ID        = C.MASTER_ID
      AND    A.PLAN_ID          = C.PLAN_ID
      GROUP  BY A.MASTER_ID
              , A.PLAN_ID
              , A.SALES_MODEL
              , B.ORG_DEMAND_ID
              , B.SEQ
              , CONVERT(NVARCHAR, C.PLAN_START_DTTM, 12)

      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

      DELETE FROM A
      FROM   TH_DPP_NET_DEMAND A,
             TH_BUF_SCM_WORK_MERGE B
      WHERE  A.MASTER_ID      = @v_master_id
      AND    A.PLAN_ID        = @v_plan_id
      AND    A.MASTER_ID      = B.MASTER_ID
      AND    A.PLAN_ID        = B.PLAN_ID
      AND    A.NET_DEMAND_ID  = B.DEMAND_ID

      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description

      
      SET @v_table_name = 'SY_FP_DAILY_NET_DEMAND_H'
     
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
           , IS_PREV_SCHEDULE -- ( 20171012 ksjeon )TEST Target 하위 공정 계획 수립 여부
           , INSERT_ID
           , INSERT_TIME
           , UPDATE_ID
           , UPDATE_TIME
           )
      SELECT
             MIN(A.COMPANY_ID)                  AS COMPANY_ID
           , MIN(A.DIVISION_ID)                 AS DIVISION_ID
           , MIN(A.SITE_ID)                     AS SITE_ID
           , MIN(A.PLANT_ID)                    AS PLANT_ID
           , MIN(A.SHOP_GROUP_ID)               AS SHOP_GROUP_ID
           , A.INSTANCE_ID
           , A.DPP_PLAN_ID
           , B.ORG_DEMAND_ID + '::FP' + CONVERT(NVARCHAR, C.PLAN_START_DTTM, 12)
                             + '##'
                             + CASE WHEN B.SEQ < 10 THEN '00'
                                    WHEN B.SEQ < 100 THEN '0'
                                                      ELSE ''
                               END
                             + CONVERT(NVARCHAR, B.SEQ) 
               AS FP_DEMAND_ID
           , MIN(A.SCP_PLAN_ID)                 AS SCP_PLAN_ID
           , B.ORG_DEMAND_ID                    AS SCP_TARGET_ID
           , A.ITEM_ID
           , MIN(A.MFG_WEEK)                    AS MFG_WEEK
           , SUM(B.NEW_COMPLETE_QTY)            AS MFG_QTY
           , MIN(A.SCP_QTY)                     AS SCP_QTY
           , MIN(A.WORK_ORDER_ID)               AS WORK_ORDER_ID
           , MIN(A.DUE_DATE)                    AS DUE_DATE
           , MIN(A.DUE_FENCE_DATE)              AS DUE_FENCE_DATE
           , MIN(A.PRECEDE_PRODUCING_TERM)      AS PRECEDE_PRODUCING_TERM
           , MIN(A.PRECEDE_PRODUCING_TERM_UOM)  AS PRECEDE_PRODUCING_TERM_UOM
           , MIN(A.PRODUCTION_TYPE)             AS PRODUCTION_TYPE
           , MIN(A.TO_SITE_ID)                  AS TO_SITE_ID
           , MIN(A.TO_PLANT_ID)                 AS TO_PLANT_ID
           , MIN(A.LINE_ID)                     AS LINE_ID
           , MIN(A.MARKET)                      AS MARKET
           , MIN(A.PRIORITY)                    AS PRIORITY
           , MIN(A.OFFSET_QTY)                  AS OFFSET_QTY
           , MIN(A.CONFIRM_TYPE)                AS CONFIRM_TYPE
           , MIN(A.DEMAND_TYPE)                 AS DEMAND_TYPE
           , MAX(A.IS_CONSUME)                  AS IS_CONSUME
           , MIN(A.IS_PREV_SCHEDULE)            AS IS_PREV_SCHEDULE -- ( 20171012 ksjeon )TEST Target 하위 공정 계획 수립 여부
           , MIN(A.INSERT_ID)                   AS INSERT_ID
           , MIN(A.INSERT_TIME)                 AS INSERT_TIME
           , MIN(A.UPDATE_ID)                   AS UPDATE_ID
           , MIN(A.UPDATE_TIME)                 AS UPDATE_TIME
      FROM   SY_FP_DAILY_NET_DEMAND_H A,
             TH_BUF_SCM_WORK_MERGE B,
             TH_ENG_PLAN_INFO C
      WHERE  A.INSTANCE_ID      = @v_master_id
      AND    A.DPP_PLAN_ID      = @v_plan_id
      AND    A.INSTANCE_ID      = B.MASTER_ID
      AND    A.DPP_PLAN_ID      = B.PLAN_ID
      AND    A.FP_DEMAND_ID     = B.DEMAND_ID
      AND    B.NEW_COMPLETE_QTY > 0
      AND    A.INSTANCE_ID      = C.MASTER_ID
      AND    A.DPP_PLAN_ID      = C.PLAN_ID
      GROUP  BY A.INSTANCE_ID
              , A.DPP_PLAN_ID
              , A.ITEM_ID
              , B.ORG_DEMAND_ID
              , B.SEQ
              , CONVERT(NVARCHAR, C.PLAN_START_DTTM, 12)
      
      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

      DELETE FROM A
      FROM   SY_FP_DAILY_NET_DEMAND_H A,
             TH_BUF_SCM_WORK_MERGE B
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.DPP_PLAN_ID  = @v_plan_id
      AND    A.INSTANCE_ID  = B.MASTER_ID
      AND    A.DPP_PLAN_ID  = B.PLAN_ID
      AND    A.FP_DEMAND_ID = B.DEMAND_ID

      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description

      /*
      SET @v_table_name = 'TH_ENG_FIXED_PLAN'

      INSERT INTO TH_ENG_FIXED_PLAN
      SELECT MASTER_ID
           , PLAN_ID
           , 'WO##' + CONVERT(NVARCHAR, START_DATE, 112)
                    +'::'
                    + CASE WHEN MIN(ORDER_SEQ) < 10 THEN '000'
                           WHEN MIN(ORDER_SEQ) < 100 THEN '00'
                           WHEN MIN(ORDER_SEQ) < 1000 THEN '0'
                                                       ELSE ''
                      END
                    + CONVERT(NVARCHAR, MIN(ORDER_SEQ)) 
                    WORK_ORDER_ID
           , CONVERT(NVARCHAR, START_DATE, 112)
                    + CASE WHEN MIN(ORDER_SEQ) < 10 THEN '000'
                           WHEN MIN(ORDER_SEQ) < 100 THEN '00'
                           WHEN MIN(ORDER_SEQ) < 1000 THEN '0'
                                                       ELSE ''
                      END
                    + CONVERT(NVARCHAR, MIN(ORDER_SEQ))  
                AS WORK_ORDER_SEQ
           , MIN(SITE_ID)         AS SITE_ID
           , MIN(ROUTE_ID)        AS ROUTE_ID
           , MIN(OPERATION_ID)    AS OPERATION_ID
           , ITEM_ID
           , MIN(RESOURCE_ID)     AS RESOURCE_ID
           , '' SUB_RESOURCE_D
           , MIN(START_TIME)      AS START_DATE
           , MAX(END_DATE)        AS END_DATE
           , SUM(COMPLETE_QTY)    AS OPERATION_QTY
           , SUM(COMPLETE_QTY)    AS COMPLETE_QTY
           , '' LOT_ID
           , 'N'                  AS IS_FIXED
           , 'Y'                  AS IS_PREV_SCHEDULE
           , 'NO_FIX'             AS KEEP_WORK_TIME_TYPE
           , 'COM_QTY_FIX'        AS KEEP_QTY_TYPE
           , NULL                 AS SALES_MODEL_ID
           , NULL                 AS ATTRIBUTE_SET_ID
           , ORG_DEMAND_ID + '##'
                           + CASE WHEN SEQ < 10 THEN '00'
                                  WHEN SEQ < 100 THEN '0'
                                                  ELSE ''
                             END
                           + CONVERT(NVARCHAR, SEQ) 
               AS DEMAND_ID
           , ''                   AS DESCR
           , 'N'                  AS IS_NOH_CONSUME
      FROM   TH_BUF_SCM_WORK_MERGE
      WHERE  MASTER_ID  = @v_master_id
      AND    PLAN_ID    = @v_plan_id
      GROUP  BY MASTER_ID
              , PLAN_ID
              , ITEM_ID
              , ORG_DEMAND_ID
              , SEQ
              , START_DATE
              , END_DATE
              
      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
    
      DELETE FROM A
      FROM   TH_ENG_FIXED_PLAN A,
             TH_BUF_SCM_WORK_MERGE B
      WHERE  A.MASTER_ID    = @v_master_id
      AND    A.PLAN_ID      = @v_plan_id
      AND    A.MASTER_ID    = B.MASTER_ID
      AND    A.PLAN_ID      = B.PLAN_ID
      AND    A.DEMAND_ID    = B.DEMAND_ID
      AND    A.ITEM_ID      = B.ITEM_ID
      AND    A.OPERATION_ID = B.OPERATION_ID
      
      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description


      -- 확정 WORK 은 다시 TH_ENG_FIXED_PLAN 에 설정한다.. 시간 고정해서..
      INSERT INTO TH_ENG_FIXED_PLAN
      SELECT A.MASTER_ID
           , A.PLAN_ID
           , C.PRODUCTION_ORDER_ID AS     WORK_ORDER_ID
           , CONVERT(
                      NVARCHAR , 10000000 
                                  + DENSE_RANK() OVER (ORDER BY A.START_TIME, A.END_TIME, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID,
                                                                A.RESOURCE_ID, C.PRODUCTION_ORDER_ID)
                    )
              AS WORK_ORDER_SEQ
           , A.SITE_ID              AS SITE_ID
           , A.ROUTE_ID             AS ROUTE_ID
           , A.OPERATION_ID         AS OPERATION_ID
           , A.ITEM_ID
           , A.RESOURCE_ID          AS RESOURCE_ID
           , ''                     AS SUB_RESOURCE_ID
           , A.START_TIME
           , A.END_TIME
           , A.COMPLETE_QTY         AS OPERATION_QTY
           , A.COMPLETE_QTY         AS COMPLETE_QTY
           , '' LOT_ID
           , 'N'                  AS IS_FIXED
           , 'Y'                  AS IS_PREV_SCHEDULE
           , 'NO_FIX'             AS KEEP_WORK_TIME_TYPE
           , 'COM_QTY_FIX'        AS KEEP_QTY_TYPE
           , NULL                 AS SALES_MODEL_ID
           , NULL                 AS ATTRIBUTE_SET_ID
           , A.DEMAND_ID
           , @v_proc_name         AS DESCR
           , 'N'                  AS IS_NOH_CONSUME
      FROM   (
              SELECT *
              FROM   TH_OUT_WORK_ORDER A,
                     (
                      SELECT DEMAND_ID, ORDER_ID
                      FROM   TH_OUT_ORDER_TRACKING A
                      WHERE  MASTER_ID      = @v_master_id
                      AND    PLAN_ID        = @v_plan_id
                      AND    OUT_VERSION_ID = @v_plan_id
                      AND    OPERATION_ID IN (
                                              'A9000',            -- CELL
                                              'P5500', 'P9500'    -- PACK
                                             )
                      GROUP  BY DEMAND_ID, ORDER_ID
                     ) B
              WHERE  A.MASTER_ID      = @v_master_id
              AND    A.PLAN_ID        = @v_plan_id
              AND    A.OUT_VERSION_ID = @v_plan_id
              AND    A.WORK_ORDER_ID = B.ORDER_ID
             ) A,
             TH_DPP_NET_DEMAND C
      WHERE  A.MASTER_ID    = C.MASTER_ID
      AND    A.PLAN_ID      = C.PLAN_ID
      AND    A.DEMAND_ID    = C.NET_DEMAND_ID
      AND    C.PO_TYPE      = 'FIX'

      --LOG 생성
      SET @v_message = 'FIX_WORK INSERT : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
      */
    END
    
    -----------------------------------------------------------------------------------------------------------------------------------

    
    --LOG 생성
    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, '===============', 'END', 999999, null, '=============== End of procedure ===============', null

    IF @@TRANCOUNT > 0
       COMMIT WORK 

  END TRY

  BEGIN CATCH
    BEGIN

      DECLARE 
        @v_error_message nvarchar(max),
        @v_error_procedure nvarchar(max),
        @v_error_line nvarchar(max)

      SET @v_error_message = ERROR_MESSAGE()

      SET @v_error_procedure = ERROR_PROCEDURE()

      SET @v_error_line = convert(nvarchar,ERROR_LINE())


      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_error_procedure, null, 'ERROR', null, @v_error_line, null, @v_error_message

      IF @@TRANCOUNT > 0
         COMMIT WORK 
    END
  END CATCH
END
