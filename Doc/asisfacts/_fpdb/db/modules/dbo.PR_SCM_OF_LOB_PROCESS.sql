CREATE PROCEDURE [dbo].[PR_SCM_OF_LOB_PROCESS]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-', @p_flag nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_LOB_PROCESS                                                     **/
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
/** 2016.10.19    LJH          최초 작성                                                      **/
/***********************************************************************************************/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_company          nvarchar(30)   
  DECLARE @v_division          nvarchar(30)
  DECLARE @v_corporation      nvarchar(30)
  DECLARE @v_plant             nvarchar(30)
  DECLARE @v_master_id        nvarchar(30)  = @p_instance_id
  DECLARE @v_plan_id          nvarchar(30)  = @p_plan_id
  DECLARE @v_flag             nvarchar(30)  = @p_flag


  -- LOG 용 변수 설정
  DECLARE @v_proc_name        nvarchar(100) = 'PR_SCM_OF_LOB_PROCESS'
  DECLARE @v_table_name       nvarchar(100)
  DECLARE @v_message          nvarchar(250)
  DECLARE @v_descr            nvarchar(250)
  DECLARE @n_row_count        Integer  = 0
  DECLARE @n_log_count        Integer  = 0
  DECLARE @v_log_code          nvarchar(10)
  
  DECLARE @sysdate            DATETIME2 = GETDATE()

  DECLARE @v_temp1            nvarchar(1000)
  DECLARE @v_temp2            nvarchar(1000)
  
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    BEGIN

      BEGIN

        SET @v_table_name = 'TH_BUF_SCM_AMEND_LOB_PLAN'

        DELETE FROM   TH_BUF_SCM_AMEND_LOB_PLAN
        WHERE  INSERT_TIME < DATEADD(DAY, -3, GETDATE())    -- 3일 이전꺼는 삭제처리
        
        
        DELETE FROM TH_BUF_SCM_AMEND_LOB_PLAN
        WHERE  INSTANCE_ID  = @v_master_id
        AND    FP_PLAN_ID   = @v_plan_id
        AND    RESULT_TYPE  = 'N'       -- PLAN 계획
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        INSERT INTO TH_BUF_SCM_AMEND_LOB_PLAN
             (
               INSTANCE_ID
             , FP_PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , ITEM_ID
             , TOP_ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , ELECTRODE_TYPE
             , PLAN_DATE
             , RUN_TIME
             , RUN_TIME_UOM
             , SETUP_TIME
             , SETUP_TIME_UOM
             , PLAN_QTY
             , PLAN_IN_QTY
             , ITEM_UOM
             , PRODUCTION_TYPE
             , RESULT_TYPE
             , LINE_ITEM_SEQ
             , OPERATION_ITEM_SEQ
             , LANE_QTY
             , INSERT_ID
             , INSERT_TIME
             )
        SELECT 
               A.INSTANCE_ID
             , A.FP_PLAN_ID
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.ITEM_ID
             , A.TOP_ITEM_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , '-' AS ELECTRODE_TYPE
             , CONVERT(DATE, A.PLAN_DATE)         AS PLAN_DATE
             , SUM(ISNULL(A.RUN_TIME, 0.0))       AS RUN_TIME
             , 'SECOND'                           AS RUN_TIME_UOM
             , SUM(ISNULL(A.SETUP_TIME, 0.0))     AS SETUP_TIME
             , 'SECOND'                           AS SETUP_TIME_UOM
             , SUM(ISNULL(A.PLAN_QTY, 0.0))       AS PLAN_QTY
             , SUM(ISNULL(A.PLAN_IN_QTY, 0.0))    AS PLAN_IN_QTY
             , A.ITEM_UOM
             , A.PRODUCTION_TYPE
             , 'N'                                AS RESULT_TYPE    -- PLAN 계획
             , MIN(LINE_ITEM_SEQ)                 AS LINE_ITEM_SEQ
             , MIN(OPERATION_ITEM_SEQ)            AS OPERATION_ITEM_SEQ
             , CASE WHEN A.LANE_QTY IS NULL THEN 0
                    ELSE A.LANE_QTY
               END  AS LANE_QTY
             , @v_proc_name                       AS INSERT_ID
             , GETDATE()                          AS INSERT_TIME
        FROM   (
                SELECT A.*
                     , DENSE_RANK() OVER (PARTITION BY A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID
                                          ORDER     BY MIN_LINE_SEQ) AS LINE_ITEM_SEQ
                     , DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
                                          ORDER     BY A.MIN_OP_SEQ, A.ITEM_ID) AS OPERATION_ITEM_SEQ
                FROM   (
                        SELECT A.*,
                               MIN(LINE_SEQ)      OVER (PARTITION BY A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ITEM_ID) AS MIN_LINE_SEQ,
                               MIN(OPERATION_SEQ) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.ITEM_ID) MIN_OP_SEQ
                        FROM   (
                                SELECT
                                       A.MASTER_ID        AS INSTANCE_ID
                                     , A.PLAN_ID          AS FP_PLAN_ID
                                     , B.COMPANY_ID
                                     , B.DIVISION_ID
                                     , B.SITE_ID
                                     , B.PLANT_ID
                                     , A.AFTER_SITE_ID      AS FACTORY_ID
                                     , A.ITEM_ID
                                     , B.ITEM_ID            AS TOP_ITEM_ID
                                     , A.AFTER_OPERATION_ID AS OPERATION_ID
                                     , A.AFTER_ROUTE_ID     AS LINE_ID
                                     --, C.ELECTRODE_TYPE
                                     , A.AFTER_PLAN_DATE    AS PLAN_DATE
                                     , ISNULL(A.WORKING_TIME, 0.0) AS RUN_TIME
                                     , ISNULL(A.SETUP_TIME, 0.0)   AS SETUP_TIME
                                     , ISNULL(A.AFTER_QTY, 0.0)    AS PLAN_QTY
                                     , ISNULL(A.AFTER_IN_QTY, 0.0) AS PLAN_IN_QTY
                                     , A.ITEM_UOM
                                     , CASE WHEN A.DEMAND_TYPE IS NULL THEN 'MASS'
                                            WHEN A.DEMAND_TYPE = ''    THEN 'MASS'
                                            ELSE A.DEMAND_TYPE
                                       END  AS PRODUCTION_TYPE
                                     , DENSE_RANK() OVER (PARTITION BY A.AFTER_SITE_ID, A.BEFORE_ROUTE_ID, A.AFTER_OPERATION_ID
                                                          ORDER     BY A.AFTER_PLAN_DATE, A.AFTER_SEQ) AS LINE_SEQ
                                     , DENSE_RANK() OVER (PARTITION BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, A.AFTER_OPERATION_ID
                                                          ORDER     BY A.AFTER_PLAN_DATE, A.AFTER_SEQ) AS OPERATION_SEQ
                                     , A.LANE_QTY
                                FROM   SY_FP_AMEND_PRODUCTION_PLAN_R A,
                                       SY_FP_DAILY_NET_DEMAND_H B
                                WHERE  A.MASTER_ID          = @v_master_id
                                AND    A.PLAN_ID            = @v_plan_id
                                AND    A.MASTER_ID          = B.INSTANCE_ID
                                AND    A.PLAN_ID            = B.DPP_PLAN_ID
                                AND    A.DEMAND_ID          = B.FP_DEMAND_ID
                               ) A
                       ) A
               ) A
        GROUP  BY
               A.INSTANCE_ID
             , A.FP_PLAN_ID
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.ITEM_ID
             , A.TOP_ITEM_ID
             , A.OPERATION_ID
             , A.LINE_ID
             --, A.ELECTRODE_TYPE
             , A.PLAN_DATE
             , A.ITEM_UOM
             , A.PRODUCTION_TYPE
             , A.LANE_QTY


        --LOG 생성
        SET @v_message = @@ROWCOUNT
        --SET @v_message = @p_resource_map
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        UPDATE TH_BUF_SCM_AMEND_LOB_PLAN
        SET    TH_BUF_SCM_AMEND_LOB_PLAN.ROLL_IN_QTY = CEILING(CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                     THEN A.PLAN_IN_QTY -- Pancake
                                                                     WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                     THEN A.PLAN_IN_QTY -- Pancake
                                                                          / (CASE WHEN D.PATTERN_QTY IS NULL  THEN 1
                                                                                  WHEN D.PATTERN_QTY = 0      THEN 1
                                                                                  ELSE D.PATTERN_QTY
                                                                             END)
                                                                          * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                  ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) 
                                                                                          / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                                      WHEN 'CM' THEN 100
                                                                                                                      WHEN 'MM' THEN 1000
                                                                                                                                ELSE 1 END)
                                                                            END )                                                                                                                                
                                                                ELSE NULL END),
               TH_BUF_SCM_AMEND_LOB_PLAN.ROLL_OUT_QTY = CEILING(CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                      THEN A.PLAN_QTY -- Pancake
                                                                      WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                      THEN A.PLAN_QTY -- Pancake
                                                                          / (CASE WHEN D.PATTERN_QTY IS NULL  THEN 1
                                                                                  WHEN D.PATTERN_QTY = 0      THEN 1
                                                                                  ELSE D.PATTERN_QTY
                                                                             END)
                                                                          * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                  ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) 
                                                                                          / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                                      WHEN 'CM' THEN 100
                                                                                                                      WHEN 'MM' THEN 1000
                                                                                                                                ELSE 1 END)
                                                                            END )                                                                                                                                
                                                                 ELSE NULL END),
               TH_BUF_SCM_AMEND_LOB_PLAN.JR_IN_QTY = CEILING(CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                     THEN A.PLAN_IN_QTY /  ( CASE WHEN A.LANE_QTY IS NULL THEN 1
                                                                                                  WHEN A.LANE_QTY = 0     THEN 1
                                                                                                  ELSE A.LANE_QTY
                                                                                             END ) -- Roll 
                                                                     WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                     THEN A.PLAN_IN_QTY /  ( CASE WHEN A.LANE_QTY IS NULL THEN 1
                                                                                                  WHEN A.LANE_QTY = 0     THEN 1
                                                                                                  ELSE A.LANE_QTY
                                                                                             END ) -- Roll 
                                                                          / (CASE WHEN D.PATTERN_QTY IS NULL  THEN 1
                                                                                  WHEN D.PATTERN_QTY = 0      THEN 1
                                                                                  ELSE D.PATTERN_QTY
                                                                             END)
                                                                          * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                  ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) 
                                                                                          / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                                      WHEN 'CM' THEN 100
                                                                                                                      WHEN 'MM' THEN 1000
                                                                                                                                ELSE 1 END)
                                                                            END )                                                                                                                                
                                                                ELSE NULL END),
               TH_BUF_SCM_AMEND_LOB_PLAN.JR_OUT_QTY = CEILING(CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                      THEN A.PLAN_QTY /  ( CASE WHEN A.LANE_QTY IS NULL THEN 1
                                                                                                WHEN A.LANE_QTY = 0     THEN 1
                                                                                                ELSE A.LANE_QTY
                                                                                           END ) -- Roll 
                                                                      WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                      THEN A.PLAN_QTY /  ( CASE WHEN A.LANE_QTY IS NULL THEN 1
                                                                                                WHEN A.LANE_QTY = 0     THEN 1
                                                                                                ELSE A.LANE_QTY
                                                                                           END ) -- Roll 
                                                                          / (CASE WHEN D.PATTERN_QTY IS NULL  THEN 1
                                                                                  WHEN D.PATTERN_QTY = 0      THEN 1
                                                                                  ELSE D.PATTERN_QTY
                                                                             END)
                                                                          * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                  ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) 
                                                                                          / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                                      WHEN 'CM' THEN 100
                                                                                                                      WHEN 'MM' THEN 1000
                                                                                                                                ELSE 1 END)
                                                                            END )                                                                                                                                
                                                                 ELSE NULL END)
        FROM  TH_BUF_SCM_AMEND_LOB_PLAN A
              LEFT OUTER JOIN (
                                SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LANE_QTY, PATTERN_QTY
                                FROM   (
                                        SELECT A.*,
                                               DENSE_RANK() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
                                                                  ORDER     BY CASE WHEN ACTIVE_FLAG = 'Y'    THEN 1
                                                                                    WHEN ACTIVE_FLAG IS NULL  THEN 2
                                                                                    ELSE 3
                                                                               END,
                                                                               LANE_QTY DESC
                                                                             , FACTORY_ID
                                                                             , MAIN_LANE_QTY DESC
                                                                             , SUB_LANE_QTY
                                                                             , PATTERN_QTY) AS SEQ
                                        FROM   SY_SCM_ITEM_LANE_M A
                                       ) A
                                WHERE  SEQ = 1       
                              ) D
                  ON    A.COMPANY_ID    = D.COMPANY_ID
                  AND   A.DIVISION_ID   = D.DIVISION_ID
                  AND   A.SITE_ID       = D.SITE_ID
                  AND   A.PLANT_ID      = D.PLANT_ID
                  AND   A.FACTORY_ID    = D.FACTORY_ID
                  AND   A.ITEM_ID       = D.ITEM_ID
            , SY_SCM_ITEM_M B
            , SY_SCM_ITEM_CLASS_M C
        WHERE 1=1
        AND   A.INSTANCE_ID   = @v_master_id
        AND   A.FP_PLAN_ID    = @v_plan_id
        AND   A.COMPANY_ID    = B.COMPANY_ID
        AND   A.DIVISION_ID   = B.DIVISION_ID
        AND   A.SITE_ID       = B.SITE_ID
        AND   A.ITEM_ID       = B.ITEM_ID
        AND   B.ITEM_CLASS    = C.CLASS_ID
        AND   C.LEVEL_2_CODE  = 'APC'
        
        --LOG 생성
        SET @v_message = 'ROLL /JR_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
        --SET @v_message = @p_resource_map
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
        UPDATE TH_BUF_SCM_AMEND_LOB_PLAN
        SET    TH_BUF_SCM_AMEND_LOB_PLAN.BATCH_QTY = A.PLAN_IN_QTY / B.BATCH_LOT_SIZE
        FROM   TH_BUF_SCM_AMEND_LOB_PLAN A,
               SY_SCM_ITEM_EQUIP_RATE_BATCH_M B
        WHERE  1=1
        AND    A.INSTANCE_ID = @v_master_id
        AND    A.FP_PLAN_ID = @v_plan_id
        AND    A.DIVISION_ID = B.DIVISION_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.PLANT_ID = B.PLANT_ID
        AND    A.FACTORY_ID = B.FACTORY_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    B.ACTIVE_FLAG = 'Y'
        AND    B.BATCH_LOT_SIZE > 0
        
        SET @v_message = 'BATCH_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
        SET @n_log_count += 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null    
        
        UPDATE TH_BUF_SCM_AMEND_LOB_PLAN
        SET    TH_BUF_SCM_AMEND_LOB_PLAN.CELL_IN_QTY  = (CASE WHEN @v_master_id LIKE '%PMIX' THEN NULL
                                                         WHEN B.ACCUMULATED_CHILD_QTY IS NULL THEN NULL 
                                                         ELSE  A.PLAN_IN_QTY / (CASE WHEN B.ACCUMULATED_CHILD_QTY = 0 THEN 1 
                                                                                 ELSE B.ACCUMULATED_CHILD_QTY END)
                                                         END),
               TH_BUF_SCM_AMEND_LOB_PLAN.CELL_OUT_QTY = (CASE WHEN @v_master_id LIKE '%PMIX' THEN NULL
                                                         WHEN B.ACCUMULATED_CHILD_QTY IS NULL 
                                                         THEN NULL 
                                                         ELSE  A.PLAN_QTY / (CASE WHEN B.ACCUMULATED_CHILD_QTY = 0 THEN 1 
                                                                                 ELSE B.ACCUMULATED_CHILD_QTY END)
                                                         END)
        FROM   TH_BUF_SCM_AMEND_LOB_PLAN A
               LEFT OUTER JOIN SY_FP_ITEM_CELL_EXCHANGE_M B
              ON      A.ITEM_ID = B.ITEM_ID
              AND     A.DIVISION_ID = B.DIVISION_ID
        WHERE 1=1
        AND   A.INSTANCE_ID  = @v_master_id
        AND   A.FP_PLAN_ID   = @v_plan_id
        
        SET @v_message = 'CELL_QTY - UPDATE 1 : ' + CONVERT(nvarchar, @@ROWCOUNT)
        SET @n_log_count += 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null     
        
        UPDATE TH_BUF_SCM_AMEND_LOB_PLAN
        SET    TH_BUF_SCM_AMEND_LOB_PLAN.CELL_IN_QTY  = (CASE WHEN @v_master_id LIKE '%PMIX' THEN NULL
                                                         WHEN B.ACCUMULATED_CHILD_QTY IS NULL 
                                                         THEN NULL 
                                                         ELSE  A.PLAN_IN_QTY / (CASE WHEN B.ACCUMULATED_CHILD_QTY = 0 THEN 1 
                                                                                 ELSE B.ACCUMULATED_CHILD_QTY END)
                                                         END),
               TH_BUF_SCM_AMEND_LOB_PLAN.CELL_OUT_QTY = (CASE WHEN @v_master_id LIKE '%PMIX' THEN NULL
                                                         WHEN B.ACCUMULATED_CHILD_QTY IS NULL 
                                                         THEN NULL 
                                                         ELSE  A.PLAN_QTY / (CASE WHEN B.ACCUMULATED_CHILD_QTY = 0 THEN 1 
                                                                                 ELSE B.ACCUMULATED_CHILD_QTY END)
                                                         END)
        FROM   TH_BUF_SCM_AMEND_LOB_PLAN A
               LEFT OUTER JOIN SY_FP_ITEM_CELL_EXCHANGE_M B
              ON      A.ITEM_ID = B.ITEM_ID
              AND     A.DIVISION_ID = (CASE WHEN B.DIVISION_ID = '82' THEN '81' ELSE B.DIVISION_ID END)
        WHERE 1=1
        AND   A.INSTANCE_ID  = @v_master_id
        AND   A.FP_PLAN_ID   = @v_plan_id
        AND   A.CELL_IN_QTY IS NULL
        
        SET @v_message = 'CELL_QTY - UPDATE 2 : ' + CONVERT(nvarchar, @@ROWCOUNT)
        SET @n_log_count += 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null          
        
        SET @v_table_name = 'FP_AMEND_LOB_PLAN_R'
        
        DELETE FROM SY_FP_AMEND_LOB_PLAN_R
        WHERE  INSTANCE_ID  = @v_master_id
        AND    FP_PLAN_ID   = @v_plan_id
        AND    RESULT_TYPE  = 'N'       -- PLAN 계획
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        INSERT INTO SY_FP_AMEND_LOB_PLAN_R
             (
               INSTANCE_ID
             , FP_PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , ITEM_ID
             , TOP_ITEM_ID
             , OPERATION_ID
             , LINE_ID
             , ELECTRODE_TYPE
             , PLAN_DATE
             , RUN_TIME
             , RUN_TIME_UOM
             , SETUP_TIME
             , SETUP_TIME_UOM
             , PLAN_QTY
             , PLAN_IN_QTY
             , ROLL_IN_QTY
             , ROLL_OUT_QTY
             , JR_IN_QTY
             , JR_OUT_QTY
             , CELL_IN_QTY
             , CELL_OUT_QTY
             , BATCH_QTY
             , ITEM_UOM
             , PRODUCTION_TYPE
             , RESULT_TYPE
             , LINE_ITEM_SEQ
             , OPERATION_ITEM_SEQ
             , INSERT_ID
             , INSERT_TIME
             )
        SELECT 
               A.INSTANCE_ID
             , A.FP_PLAN_ID
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.ITEM_ID
             , A.TOP_ITEM_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , '-' AS ELECTRODE_TYPE
             , A.PLAN_DATE
             , SUM(ISNULL(A.RUN_TIME, 0.0))                  AS RUN_TIME
             , 'SECOND'                                      AS RUN_TIME_UOM
             , SUM(ISNULL(A.SETUP_TIME, 0.0))                AS SETUP_TIME
             , 'SECOND'                                      AS SETUP_TIME_UOM
             , CEILING(SUM(ISNULL(A.PLAN_QTY, 0.0)))         AS PLAN_QTY
             , CEILING(SUM(ISNULL(A.PLAN_IN_QTY, 0.0)))      AS PLAN_IN_QTY
             , CEILING(SUM(ISNULL(A.ROLL_IN_QTY, 0.0)))      AS ROLL_IN_QTY
             , CEILING(SUM(ISNULL(A.ROLL_OUT_QTY, 0.0)))     AS ROLL_OUT_QTY
             , CEILING(SUM(ISNULL(A.JR_IN_QTY, 0.0)))        AS JR_IN_QTY
             , CEILING(SUM(ISNULL(A.JR_OUT_QTY, 0.0)))       AS JR_OUT_QTY
             , CEILING(SUM(ISNULL(A.CELL_IN_QTY, 0.0)))      AS CELL_IN_QTY
             , CEILING(SUM(ISNULL(A.CELL_OUT_QTY, 0.0)))     AS CELL_OUT_QTY
             , CEILING(SUM(ISNULL(A.BATCH_QTY, 0.0)))        AS BATCH_QTY
             , A.ITEM_UOM
             , A.PRODUCTION_TYPE
             , 'N'                                AS RESULT_TYPE    -- PLAN 계획
             , MIN(A.LINE_ITEM_SEQ)                 AS LINE_ITEM_SEQ
             , MIN(A.OPERATION_ITEM_SEQ)            AS OPERATION_ITEM_SEQ
             , @v_proc_name                       AS INSERT_ID
             , GETDATE()                          AS INSERT_TIME
        FROM   TH_BUF_SCM_AMEND_LOB_PLAN A
        WHERE  INSTANCE_ID  = @v_master_id
        AND    FP_PLAN_ID   = @v_plan_id
        GROUP  BY
               A.INSTANCE_ID
             , A.FP_PLAN_ID
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.ITEM_ID
             , A.TOP_ITEM_ID
             , A.OPERATION_ID
             , A.LINE_ID
             --, A.ELECTRODE_TYPE
             , A.PLAN_DATE
             , A.ITEM_UOM
             , A.PRODUCTION_TYPE


        --LOG 생성
        SET @v_message = @@ROWCOUNT
        --SET @v_message = @p_resource_map
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null        

      END
      
      BEGIN

        SET @v_table_name = 'TH_BUF_SCM_LOB_DATA'

        DELETE FROM TH_BUF_SCM_LOB_DATA
        WHERE  INSERT_TIME < DATEADD(DAY, -7, GETDATE())    -- 7일 이전꺼는 삭제처리

        DELETE FROM TH_BUF_SCM_LOB_DATA
        
        -----------------------------------------------------------------------
        -- 생산계획 : INVENTORY
        -----------------------------------------------------------------------
        INSERT INTO TH_BUF_SCM_LOB_DATA
             (
               INSTANCE_ID
             , FP_PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , ITEM_ID
             , OPERATION_ID
             , CATEGORY_ID
             , WORK_ORDER_ID
             , PRODUCTION_TYPE
             , PLAN_DATE
             , PLAN_QTY
             , LANE_QTY
             , INSERT_TIME
             )
        SELECT DISTINCT
               A.MASTER_ID            AS INSTANCE_ID
             , A.PLAN_ID              AS FP_PLAN_ID
             , B.COMPANY_ID
             , B.DIVISION_ID
             , B.SITE_ID
             , B.PLANT_ID
             , A.AFTER_SITE_ID        AS FACTORY_ID
             , A.ITEM_ID
             , A.AFTER_OPERATION_ID   AS OPERATION_ID
             , 'INVENTORY'  AS CATEGORY_ID        -- 생산계획
             , A.WORK_ORDER_ID
             , CASE WHEN A.DEMAND_TYPE IS NULL THEN 'MASS'
                    WHEN A.DEMAND_TYPE = ''    THEN 'MASS'
                    ELSE A.DEMAND_TYPE
               END  AS PRODUCTION_TYPE
             , A.AFTER_PLAN_DATE    AS PLAN_DATE
             , A.AFTER_QTY          AS PLAN_QTY
             , ISNULL(A.LANE_QTY,0) AS LANE_QTY
             , GETDATE()            AS INSERT_TIME
        FROM   SY_FP_AMEND_PRODUCTION_PLAN_R A,
               SY_FP_ORDER_PEGGING_R B
        WHERE  A.MASTER_ID          = @v_master_id
        AND    A.PLAN_ID            = @v_plan_id
        AND    A.MASTER_ID          = B.INSTANCE_ID
        AND    A.PLAN_ID            = B.FP_PLAN_ID
        AND    A.ORG_WORK_ORDER_ID  = B.FROM_WORK_ORDER_ID

        --LOG 생성
        SET @v_message = 'CATEGORY_ID - INVENTORY : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        -----------------------------------------------------------------------
        -- 생산계획 투입 : WORK - WORK
        -----------------------------------------------------------------------
        INSERT INTO TH_BUF_SCM_LOB_DATA
             (
               INSTANCE_ID
             , FP_PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , ITEM_ID
             , OPERATION_ID
             , CATEGORY_ID
             , WORK_ORDER_ID
             , PRODUCTION_TYPE
             , PLAN_DATE
             , PLAN_QTY
             , LANE_QTY
             , INSERT_TIME
             )
        -- 20170329 SALES 조정
        SELECT DISTINCT        A.INSTANCE_ID
             , A.FP_PLAN_ID
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID AS FACTORY_ID
             , B.ITEM_ID             
             , B.OPERATION_ID AS OPERATION_ID
             , 'DEMAND' AS CATEGORY_ID
             , NULL AS WORK_ORDER_ID
             --, CASE WHEN A.DEMAND_TYPE IS NULL THEN 'MASS'
             --       WHEN A.DEMAND_TYPE = ''    THEN 'MASS'
             --       ELSE A.DEMAND_TYPE
             --  END  AS PRODUCTION_TYPE
             , NULL AS PRODUCTION_TYPE
             , A.PLAN_DATE    AS PLAN_DATE
             --, CASE WHEN SEQ = 1 THEN PLAN_QTY - SUM_QTY + RATE_QTY
             --                    ELSE RATE_QTY
             --, B.PLAN_QTY * C.CHILD_QTY/C.PARENT_QTY AS NEW_PLAN_QTY
             --, A.PLAN_QTY
             , A.PLAN_QTY * C.CHILD_QTY/C.PARENT_QTY  AS NEW_PLAN_QTY
             , NULL AS LANE_QTY
             , GETDATE()            AS INSERT_TIME
        FROM 
              (SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.PLAN_DATE, A.TO_ITEM_ID, SUM(A.PLAN_QTY) AS PLAN_QTY
              FROM (
                    SELECT DISTINCT
                                   A.MASTER_ID            AS INSTANCE_ID
                                 , A.PLAN_ID              AS FP_PLAN_ID
                                 , B.COMPANY_ID
                                 , B.DIVISION_ID
                                 , B.SITE_ID
                                 , B.PLANT_ID
                                 , A.AFTER_SITE_ID        AS FACTORY_ID
                                 , A.ITEM_ID
                                 , A.AFTER_OPERATION_ID   AS OPERATION_ID
                                 , 'INVENTORY'  AS CATEGORY_ID        -- 생산계획
                                 , A.WORK_ORDER_ID
                                 , CASE WHEN A.DEMAND_TYPE IS NULL THEN 'MASS'
                                        WHEN A.DEMAND_TYPE = ''    THEN 'MASS'
                                        ELSE A.DEMAND_TYPE
                                   END  AS PRODUCTION_TYPE
                                 , A.AFTER_PLAN_DATE  AS PLAN_DATE
                                 , A.AFTER_IN_QTY        AS PLAN_QTY
                                 , ISNULL(A.LANE_QTY,0)         AS LANE_QTY
                                 , B.TO_ITEM_ID
                            FROM   SY_FP_AMEND_PRODUCTION_PLAN_R A,
                                   SY_FP_ORDER_PEGGING_R B
                            WHERE  A.MASTER_ID          = @v_master_id
                            AND    A.PLAN_ID            = @v_plan_id
                            AND    A.MASTER_ID          = B.INSTANCE_ID
                            AND    A.PLAN_ID            = B.FP_PLAN_ID
                            AND    A.ORG_WORK_ORDER_ID  = B.FROM_WORK_ORDER_ID
                        ) A
              GROUP BY A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.PLAN_DATE, A.TO_ITEM_ID) A
                LEFT OUTER JOIN
                (SELECT DISTINCT
                     A.MASTER_ID            AS INSTANCE_ID
                   , A.PLAN_ID              AS FP_PLAN_ID
                   , B.COMPANY_ID
                   , B.DIVISION_ID
                   , B.SITE_ID
                   , B.PLANT_ID
                   , A.AFTER_SITE_ID        AS FACTORY_ID
                   , A.ITEM_ID
                   , A.AFTER_PLAN_DATE  AS PLAN_DATE
                   , ISNULL(A.LANE_QTY,0)         AS LANE_QTY
                   , B.TO_ITEM_ID
                   , A.AFTER_OPERATION_ID AS OPERATION_ID
              FROM   SY_FP_AMEND_PRODUCTION_PLAN_R A,
                     SY_FP_ORDER_PEGGING_R B
              WHERE  A.MASTER_ID          = @v_master_id
              AND    A.PLAN_ID            = @v_plan_id
              AND    A.MASTER_ID          = B.INSTANCE_ID
              AND    A.PLAN_ID            = B.FP_PLAN_ID
              AND    A.ORG_WORK_ORDER_ID  = B.FROM_WORK_ORDER_ID
              --AND    A.ITEM_ID      = 'AMDAU0004C'
                  ) B
                  ON A.ITEM_ID = B.TO_ITEM_ID,
                  SY_SCM_BOM_M  C                 
               WHERE 1=1
               AND A.ITEM_ID = C.PARENT_ITEM_ID
               AND B.ITEM_ID = C.CHILD_ITEM_ID

        --LOG 생성
        SET @v_message = 'CATEGORY_ID - DEMAND : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        -----------------------------------------------------------------------
        -- DEMAND 수요에 대한 투입 : WORK - DEMAND
        -----------------------------------------------------------------------
        INSERT INTO TH_BUF_SCM_LOB_DATA
             (
               INSTANCE_ID
             , FP_PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , ITEM_ID
             , OPERATION_ID
             , CATEGORY_ID
             , WORK_ORDER_ID
             , PRODUCTION_TYPE
             , PLAN_DATE
             , PLAN_QTY
             , LANE_QTY
             , INSERT_TIME
             )
        SELECT A.INSTANCE_ID
             , A.DPP_PLAN_ID
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , B.AFTER_SITE_ID      AS FACTORY_ID
             , B.ITEM_ID            AS ITEM_ID
             , B.AFTER_OPERATION_ID AS OPERATION_ID
             , 'DEMAND'             AS CATEGORY_ID
             , A.SCP_TARGET_ID      AS KEY_VALUE
             , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                    WHEN A.PRODUCTION_TYPE = ''    THEN 'MASS'
                    ELSE A.PRODUCTION_TYPE
               END  AS PRODUCTION_TYPE
             , A.DUE_DATE AS PLAN_DATE
             --, B.PLAN_QTY               --CELLING 된 생산완료수량
             , A.MFG_QTY                -- 생산 TARGET 수량
             , B.LANE_QTY
             , GETDATE()            AS INSERT_TIME
        FROM   SY_FP_DAILY_NET_DEMAND_H A,
               (
                SELECT A.DEMAND_ID, A.ITEM_ID, A.AFTER_SITE_ID, A.AFTER_OPERATION_ID
                     , SUM(AFTER_QTY) AS PLAN_QTY
                     , MAX(LANE_QTY)  AS LANE_QTY
                FROM   SY_FP_AMEND_PRODUCTION_PLAN_R A,
                       SY_FP_ORDER_PEGGING_R B
                WHERE  A.MASTER_ID          = @v_master_id
                AND    A.PLAN_ID            = @v_plan_id
                AND    A.MASTER_ID          = B.INSTANCE_ID
                AND    A.PLAN_ID            = B.FP_PLAN_ID
                AND    A.ORG_WORK_ORDER_ID  = B.FROM_WORK_ORDER_ID
                AND    B.DEMAND_ID         != '-'
                GROUP  BY A.DEMAND_ID, A.ITEM_ID, A.AFTER_SITE_ID, A.AFTER_OPERATION_ID
                HAVING SUM(AFTER_QTY) > 0
               ) B
        WHERE  A.INSTANCE_ID = @v_master_id
        AND    A.DPP_PLAN_ID = @v_plan_id
        AND    A.FP_DEMAND_ID = B.DEMAND_ID

        --LOG 생성
        SET @v_message = 'CATEGORY_ID - DEMAND : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        -----------------------------------------------------------------------
        -- DEMAND 수요에 대한 투입 : DEMAND  >> E2500 을 제외한 나머지만 해당함.
        -----------------------------------------------------------------------
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


        -----------------------------------------------------------------------
        -- 환산자 UPDATE 처리
        -----------------------------------------------------------------------
        
        UPDATE TH_BUF_SCM_LOB_DATA
        SET    TH_BUF_SCM_LOB_DATA.ROLL_QTY =
                     (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                           THEN (CASE WHEN A.LANE_QTY IS NULL THEN NULL
                                      WHEN A.LANE_QTY = 0     THEN NULL 
                                      ELSE A.PLAN_QTY END) -- Pancake
                           WHEN UPPER(B.ITEM_UOM) != 'M'
                           THEN (CASE WHEN A.LANE_QTY IS NULL THEN NULL
                                      WHEN A.LANE_QTY = 0     THEN NULL 
                                      ELSE A.PLAN_QTY -- Pancake
                                          / (CASE WHEN D.PATTERN_QTY IS NULL  THEN 1
                                                  WHEN D.PATTERN_QTY = 0      THEN 1
                                                  ELSE D.PATTERN_QTY
                                             END)
                                          * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                  ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) 
                                          / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                      WHEN 'CM' THEN 100
                                                                      WHEN 'MM' THEN 1000
                                                                                ELSE 1 END)
                                              END ) END)
                            ELSE NULL END)
             ,  TH_BUF_SCM_LOB_DATA.JR_QTY = 
                      (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                            THEN (CASE WHEN A.LANE_QTY IS NULL THEN NULL
                                       WHEN A.LANE_QTY = 0     THEN NULL 
                                       ELSE A.PLAN_QTY / A.LANE_QTY END)-- Roll 
                            WHEN UPPER(B.ITEM_UOM) != 'M'
                            THEN (CASE WHEN A.LANE_QTY IS NULL THEN NULL
                                       WHEN A.LANE_QTY = 0     THEN NULL 
                                       ELSE A.PLAN_QTY / A.LANE_QTY  -- Roll
                                            / (CASE WHEN D.PATTERN_QTY IS NULL  THEN 1
                                                    WHEN D.PATTERN_QTY = 0      THEN 1
                                                    ELSE D.PATTERN_QTY
                                               END)
                                            * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                    ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) 
                                                            / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                        WHEN 'CM' THEN 100
                                                                                        WHEN 'MM' THEN 1000
                                                                                                  ELSE 1 END) END)
                                    END )
                            ELSE NULL END)
             ,  TH_BUF_SCM_LOB_DATA.CELL_QTY = 
                      (CASE WHEN  @v_master_id LIKE '%PMIX' THEN NULL
                            WHEN  E.ACCUMULATED_CHILD_QTY IS NULL THEN NULL 
                            ELSE  A.PLAN_QTY / (CASE WHEN E.ACCUMULATED_CHILD_QTY = 0 THEN 1 
                                                     ELSE E.ACCUMULATED_CHILD_QTY END)
                            END)
             , TH_BUF_SCM_LOB_DATA.ITEM_UOM = B.ITEM_UOM
        FROM   TH_BUF_SCM_LOB_DATA A
               INNER JOIN SY_SCM_ITEM_M B
                     ON   A.COMPANY_ID = B.COMPANY_ID
                     AND  A.DIVISION_ID = B.DIVISION_ID
                     AND  A.SITE_ID = B.SITE_ID
                     AND  A.ITEM_ID = B.ITEM_ID
               LEFT OUTER JOIN SY_SCM_ITEM_CLASS_M C
                    ON    B.ITEM_CLASS = C.CLASS_ID
                    AND   C.LEVEL_2_CODE = 'APC'
               LEFT OUTER JOIN (
                                SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LANE_QTY, PATTERN_QTY
                                FROM   (
                                        SELECT A.*,
                                               DENSE_RANK() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
                                                                  ORDER     BY CASE WHEN ACTIVE_FLAG = 'Y'    THEN 1
                                                                                    WHEN ACTIVE_FLAG IS NULL  THEN 2
                                                                                    ELSE 3
                                                                               END,
                                                                               LANE_QTY DESC
                                                                             , FACTORY_ID
                                                                             , MAIN_LANE_QTY DESC
                                                                             , SUB_LANE_QTY
                                                                             , PATTERN_QTY) AS SEQ
                                        FROM   SY_SCM_ITEM_LANE_M A
                                       ) A
                                WHERE  SEQ = 1       
                               ) D
                    ON    A.COMPANY_ID = D.COMPANY_ID
                    AND   A.DIVISION_ID = D.DIVISION_ID
                    AND   A.SITE_ID = D.SITE_ID
                    AND   A.PLANT_ID = D.PLANT_ID
                    AND   A.FACTORY_ID = D.FACTORY_ID
                    AND   A.ITEM_ID = D.ITEM_ID
               LEFT OUTER JOIN SY_FP_ITEM_CELL_EXCHANGE_M E
                    ON      A.ITEM_ID = E.ITEM_ID
                    AND     A.DIVISION_ID = E.DIVISION_ID 
        WHERE  INSTANCE_ID = @v_master_id
        AND    FP_PLAN_ID  = @v_plan_id
      
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        
        -----------------------------------------------------------------------
        -- FP_AMEND_LOB_PSI_CATEGORY_R 생성
        -----------------------------------------------------------------------

        SET @v_table_name = 'FP_AMEND_LOB_PSI_CATEGORY_R'
        
        DELETE FROM SY_FP_AMEND_LOB_PSI_CATEGORY_R
        WHERE  INSTANCE_ID = @v_master_id
        AND    FP_PLAN_ID  = @v_plan_id
        AND    CATEGORY_ID IN ('INVENTORY', 'DEMAND')

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        INSERT INTO SY_FP_AMEND_LOB_PSI_CATEGORY_R
             (
               INSTANCE_ID
             , FP_PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , ITEM_ID
             , OPERATION_ID
             , PRODUCTION_TYPE
             , CATEGORY_ID        
             , PLAN_DATE
             , QTY
             , ROLL_QTY
             , JR_QTY
             , CELL_QTY
             , ITEM_UOM
             , OPERATION_ITEM_SEQ
             , INSERT_ID
             , INSERT_TIME
             )
        SELECT 
               A.INSTANCE_ID
             , A.FP_PLAN_ID
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.ITEM_ID
             , A.OPERATION_ID
             , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                    WHEN A.PRODUCTION_TYPE = ''    THEN 'MASS'
                    ELSE A.PRODUCTION_TYPE
               END  AS PRODUCTION_TYPE
             , A.CATEGORY_ID
             , A.PLAN_DATE
             , CEILING(SUM(CEILING(A.PLAN_QTY)))  AS QTY
             , CEILING(SUM(A.ROLL_QTY))           AS ROLL_QTY
             , CEILING(SUM(A.JR_QTY))             AS JR_QTY
             , CEILING(SUM(A.CELL_QTY))           AS CELL_QTY
             , MAX(A.ITEM_UOM)                    AS ITEM_UOM
             , 999                                AS OPERATION_ITEM_SEQ
             , @v_proc_name                       AS INSERT_ID
             , GETDATE()                          AS INSERT_TIME
        FROM   TH_BUF_SCM_LOB_DATA A
        WHERE  A.INSTANCE_ID = @v_master_id
        AND    A.FP_PLAN_ID  = @v_plan_id
        GROUP  BY 
               A.INSTANCE_ID
             , A.FP_PLAN_ID
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.ITEM_ID
             , A.OPERATION_ID
             , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                    WHEN A.PRODUCTION_TYPE = ''    THEN 'MASS'
                    ELSE A.PRODUCTION_TYPE
               END
             , A.CATEGORY_ID
             , A.PLAN_DATE
             
        SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        -- 생산계획
        /*
        SELECT 
               A.INSTANCE_ID
             , A.FP_PLAN_ID
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.ITEM_ID
             , A.OPERATION_ID
             , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                    WHEN A.PRODUCTION_TYPE = ''    THEN 'MASS'
                    ELSE A.PRODUCTION_TYPE
               END  PRODUCTION_TYPE
             , A.CATEGORY_ID        -- 생산계획
             , A.PLAN_DATE
             , CEILING(SUM(CEILING(A.PLAN_QTY))) AS QTY
             , CEILING(SUM(A.ROLL_QTY)) AS ROLL_QTY
             , CEILING(SUM(A.JR_QTY))   AS JR_QTY
             , CEILING(SUM(A.CELL_QTY)) AS CELL_QTY
             , A.ITEM_UOM
             , 999          AS OPERATION_ITEM_SEQ
             , @v_proc_name AS INSERT_ID
             , GETDATE()    AS INSERT_TIME
        FROM   (
                SELECT A.INSTANCE_ID
                     , A.FP_PLAN_ID
                     , A.COMPANY_ID
                     , A.DIVISION_ID
                     , A.SITE_ID
                     , A.PLANT_ID
                     , A.FACTORY_ID
                     , A.ITEM_ID
                     , A.OPERATION_ID
                     , A.CATEGORY_ID
                     , A.WORK_ORDER_ID
                     , A.PRODUCTION_TYPE
                     , A.PLAN_DATE
                     , A.PLAN_QTY
                     , A.LANE_QTY
                     , B.ITEM_UOM
                     , B.ITEM_CLASS
                     , B.COATED_LENGTH
                     , B.UNCOATED_LENGTH
                     , B.LENGTH_UOM
                     --, D.LANE_QTY
                     , D.PATTERN_QTY
                     , (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                             THEN (CASE WHEN A.LANE_QTY IS NULL THEN NULL
                                        WHEN A.LANE_QTY = 0     THEN NULL 
                                        ELSE A.PLAN_QTY END) -- Pancake
                             WHEN UPPER(B.ITEM_UOM) != 'M'
                             THEN (CASE WHEN A.LANE_QTY IS NULL THEN NULL
                                        WHEN A.LANE_QTY = 0     THEN NULL 
                                        ELSE A.PLAN_QTY -- Pancake
                                            / (CASE WHEN D.PATTERN_QTY IS NULL  THEN 1
                                                    WHEN D.PATTERN_QTY = 0      THEN 1
                                                    ELSE D.PATTERN_QTY
                                               END)
                                            * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                    ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) 
                                            / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                        WHEN 'CM' THEN 100
                                                                        WHEN 'MM' THEN 1000
                                                                                  ELSE 1 END)
                                                END ) END)
                              ELSE NULL END) AS ROLL_QTY
                     ,  (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                              THEN (CASE WHEN A.LANE_QTY IS NULL THEN NULL
                                         WHEN A.LANE_QTY = 0     THEN NULL 
                                         ELSE A.PLAN_QTY / A.LANE_QTY END)-- Roll 
                              WHEN UPPER(B.ITEM_UOM) != 'M'
                              THEN (CASE WHEN A.LANE_QTY IS NULL THEN NULL
                                         WHEN A.LANE_QTY = 0     THEN NULL 
                                         ELSE A.PLAN_QTY / A.LANE_QTY  -- Roll
                                              / (CASE WHEN D.PATTERN_QTY IS NULL  THEN 1
                                                      WHEN D.PATTERN_QTY = 0      THEN 1
                                                      ELSE D.PATTERN_QTY
                                                 END)
                                              * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                      ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) 
                                                              / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                          WHEN 'CM' THEN 100
                                                                                          WHEN 'MM' THEN 1000
                                                                                                    ELSE 1 END) END)
                                      END )
                              ELSE NULL END) JR_QTY
                     ,  (CASE WHEN @v_master_id LIKE '%PMIX' THEN NULL
                              WHEN  E.ACCUMULATED_CHILD_QTY IS NULL THEN NULL 
                              ELSE  A.PLAN_QTY / (CASE WHEN E.ACCUMULATED_CHILD_QTY = 0 THEN 1 
                                                       ELSE E.ACCUMULATED_CHILD_QTY END)
                              END) AS CELL_QTY
                FROM   TH_BUF_SCM_LOB_DATA A
                       INNER JOIN SY_SCM_ITEM_M B
                             ON   A.COMPANY_ID = B.COMPANY_ID
                             AND  A.DIVISION_ID = B.DIVISION_ID
                             AND  A.SITE_ID = B.SITE_ID
                             AND  A.ITEM_ID = B.ITEM_ID
                       LEFT OUTER JOIN SY_SCM_ITEM_CLASS_M C
                            ON    B.ITEM_CLASS = C.CLASS_ID
                            AND   C.LEVEL_2_CODE = 'APC'
                       LEFT OUTER JOIN (
                                        SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LANE_QTY, PATTERN_QTY
                                        FROM   (
                                                SELECT A.*,
                                                       DENSE_RANK() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
                                                                          ORDER     BY CASE WHEN ACTIVE_FLAG = 'Y'    THEN 1
                                                                                            WHEN ACTIVE_FLAG IS NULL  THEN 2
                                                                                            ELSE 3
                                                                                       END,
                                                                                       LANE_QTY DESC
                                                                                     , FACTORY_ID
                                                                                     , MAIN_LANE_QTY DESC
                                                                                     , SUB_LANE_QTY
                                                                                     , PATTERN_QTY) AS SEQ
                                                FROM   SY_SCM_ITEM_LANE_M A
                                               ) A
                                        WHERE  SEQ = 1       
                                       ) D
                            ON    A.COMPANY_ID = D.COMPANY_ID
                            AND   A.DIVISION_ID = D.DIVISION_ID
                            AND   A.SITE_ID = D.SITE_ID
                            AND   A.PLANT_ID = D.PLANT_ID
                            AND   A.FACTORY_ID = D.FACTORY_ID
                            AND   A.ITEM_ID = D.ITEM_ID
                       LEFT OUTER JOIN SY_FP_ITEM_CELL_EXCHANGE_M E
                            ON      A.ITEM_ID = E.ITEM_ID
                            AND     A.DIVISION_ID = E.DIVISION_ID                          
               ) A
        GROUP  BY 
               A.INSTANCE_ID
             , A.FP_PLAN_ID
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.ITEM_ID
             , A.OPERATION_ID
             , CASE WHEN A.PRODUCTION_TYPE IS NULL THEN 'MASS'
                    WHEN A.PRODUCTION_TYPE = ''    THEN 'MASS'
                    ELSE A.PRODUCTION_TYPE
               END
             , A.CATEGORY_ID        -- 생산계획
             , A.PLAN_DATE  
             , A.ITEM_UOM
             
        SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        */

      END

      /*** FP_AMEND_LOB_PLAN_R 생성 ***/
      BEGIN
        
        SET @v_table_name = 'FP_AMEND_LOB_PSI_R'
        
        DECLARE @n_cnt    int

        SELECT @n_cnt = COUNT(1) 
        FROM   (
                SELECT TOP 1 FP_PLAN_ID
                FROM   SY_FP_AMEND_LOB_PSI_R
                WHERE  INSTANCE_ID = @v_master_id
                AND    FP_PLAN_ID  = @v_plan_id
               ) A
        
        IF @n_cnt > 0 
          BEGIN
          
            DELETE FROM SY_FP_AMEND_LOB_PSI_R
            WHERE  INSTANCE_ID = @v_master_id
            AND    FP_PLAN_ID  = @v_plan_id

          END
          
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        BEGIN
        
          SET @v_table_name = 'TH_BUF_SCM_LOB_PSI_CATEGORY'
          
          DELETE FROM TH_BUF_SCM_LOB_PSI_CATEGORY
          
          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

          INSERT INTO TH_BUF_SCM_LOB_PSI_CATEGORY
               (
                 INSTANCE_ID
               , FP_PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , ITEM_ID
               , OPERATION_ID
               , PRODUCTION_TYPE
               , CATEGORY_ID
               , PLAN_DATE
               , QTY
               , ROLL_QTY
               , JR_QTY
               , CELL_QTY
               , ITEM_UOM
               , OPERATION_ITEM_SEQ
               , INSERT_ID
               , INSERT_TIME
               )
          SELECT
                 INSTANCE_ID
               , FP_PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , ITEM_ID
               , OPERATION_ID
               , PRODUCTION_TYPE
               , CATEGORY_ID
               , PLAN_DATE
               , QTY
               , ROLL_QTY
               , JR_QTY
               , CELL_QTY
               , ITEM_UOM
               , OPERATION_ITEM_SEQ
               , INSERT_ID
               , INSERT_TIME
          FROM   SY_FP_AMEND_LOB_PSI_CATEGORY_R
          WHERE  INSTANCE_ID = @v_master_id
          AND    FP_PLAN_ID  = @v_plan_id

          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          ----------------------------------------------------------------------------------------
          
          SET @v_table_name = 'TH_BUF_SCM_LOB_PSI'

          DELETE FROM TH_BUF_SCM_LOB_PSI

          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

          INSERT INTO TH_BUF_SCM_LOB_PSI
                (
                 INSTANCE_ID, FP_PLAN_ID,
                 COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, OPERATION_ID, PRODUCTION_TYPE, PLAN_DATE, 
                 BOH_QTY,       IN_QTY,       OUT_QTY,        EOH_QTY,
                 ROLL_BOH_QTY,  ROLL_IN_QTY,  ROLL_OUT_QTY,   ROLL_EOH_QTY,
                 JR_BOH_QTY,    JR_IN_QTY,    JR_OUT_QTY,     JR_EOH_QTY,
                 CELL_BOH_QTY,  CELL_IN_QTY,  CELL_OUT_QTY,   CELL_EOH_QTY,
                 DATE_SEQ, OPERATION_ITEM_SEQ,
                 INSERT_ID, INSERT_TIME
                )
          SELECT A.INSTANCE_ID
               , A.FP_PLAN_ID
               , A.COMPANY_ID
               , A.DIVISION_ID
               , A.SITE_ID
               , A.ITEM_ID
               , A.OPERATION_ID
               , A.PRODUCTION_TYPE
               , A.PLAN_DATE
               , CEILING(EOH_QTY) - (CEILING(IN_QTY) - CEILING(OUT_QTY)) AS BOH_QTY
               , CEILING(IN_QTY) AS IN_QTY
               , CEILING(OUT_QTY) AS OUT_QTY
               , CEILING(EOH_QTY) AS EOH_QTY
               , CEILING(ROLL_EOH_QTY) - (CEILING(ROLL_IN_QTY) - CEILING(ROLL_OUT_QTY)) AS ROLL_BOH_QTY
               , CEILING(ROLL_IN_QTY) AS ROLL_IN_QTY
               , CEILING(ROLL_OUT_QTY) AS ROLL_OUT_QTY
               , CEILING(ROLL_EOH_QTY) AS ROLL_EOH_QTY
               , CEILING(JR_EOH_QTY) - (CEILING(JR_IN_QTY) - CEILING(JR_OUT_QTY)) AS JR_BOH_QTY
               , CEILING(JR_IN_QTY) AS JR_IN_QTY
               , CEILING(JR_OUT_QTY) AS JR_OUT_QTY
               , CEILING(JR_EOH_QTY) AS JR_EOH_QTY
               , CEILING(CELL_EOH_QTY) - (CEILING(CELL_IN_QTY) - CEILING(CELL_OUT_QTY)) AS CELL_BOH_QTY
               , CEILING(CELL_IN_QTY) AS CELL_IN_QTY
               , CEILING(CELL_OUT_QTY) AS CELL_OUT_QTY
               , CEILING(CELL_EOH_QTY) AS CELL_EOH_QTY             
               , A.DATE_SEQ
               , A.OPERATION_ITEM_SEQ
               , @v_proc_name AS INSERT_ID
               , GETDATE()    AS INSERT_TIME
          FROM   (
                  SELECT A.INSTANCE_ID
                       , A.FP_PLAN_ID
                       , A.COMPANY_ID
                       , A.DIVISION_ID
                       , A.SITE_ID
                       , A.ITEM_ID
                       , A.OPERATION_ID
                       , A.PRODUCTION_TYPE
                       , A.PLAN_DATE
                       , A.DATE_SEQ
                       , A.OPERATION_ITEM_SEQ
                       , ISNULL(B.QTY, 0) AS BOH_QTY
                       , ISNULL(C.QTY, 0) AS IN_QTY     -- 생산계획 + 실적
                       , ISNULL(D.QTY, 0) AS OUT_QTY    -- TARGET 수량 20170920 BOH 계산오류 수정 (E.QTY 제외)
                       --, SUM(ISNULL(B.QTY, 0) + ISNULL(C.QTY, 0) - ( ISNULL(D.QTY, 0) + ISNULL(E.QTY, 0) ) )
                       , SUM(ISNULL(B.QTY, 0) + ISNULL(C.QTY, 0) - ( ISNULL(D.QTY, 0) ) )
                              OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.PRODUCTION_TYPE
                                    ORDER     BY A.PLAN_DATE ) AS EOH_QTY
                       , ISNULL(B.ROLL_QTY, 0) AS ROLL_BOH_QTY
                       , ISNULL(C.ROLL_QTY, 0) AS ROLL_IN_QTY     -- 생산계획 + 실적
                       --, ( ISNULL(D.ROLL_QTY, 0) + ISNULL(E.ROLL_QTY, 0) ) AS ROLL_OUT_QTY    -- TARGET 수량
                       , ( ISNULL(D.ROLL_QTY, 0) ) AS ROLL_OUT_QTY    -- TARGET 수량
                       --, SUM(ISNULL(B.ROLL_QTY, 0) + ISNULL(C.ROLL_QTY, 0) - ( ISNULL(D.ROLL_QTY, 0) + ISNULL(E.ROLL_QTY, 0) ) )
                       , SUM(ISNULL(B.ROLL_QTY, 0) + ISNULL(C.ROLL_QTY, 0) - ( ISNULL(D.ROLL_QTY, 0)) )
                              OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.PRODUCTION_TYPE
                                    ORDER     BY A.PLAN_DATE ) AS ROLL_EOH_QTY
                       , ISNULL(B.JR_QTY, 0) AS JR_BOH_QTY
                       , ISNULL(C.JR_QTY, 0) AS JR_IN_QTY     -- 생산계획 + 실적
                       --, ( ISNULL(D.JR_QTY, 0) + ISNULL(E.JR_QTY, 0) ) AS JR_OUT_QTY    -- TARGET 수량
                       , ( ISNULL(D.JR_QTY, 0)) AS JR_OUT_QTY    -- TARGET 수량
                       --, SUM(ISNULL(B.JR_QTY, 0) + ISNULL(C.JR_QTY, 0) - ( ISNULL(D.JR_QTY, 0) + ISNULL(E.JR_QTY, 0) ) )
                       , SUM(ISNULL(B.JR_QTY, 0) + ISNULL(C.JR_QTY, 0) - ( ISNULL(D.JR_QTY, 0) ) )
                              OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.PRODUCTION_TYPE
                                    ORDER     BY A.PLAN_DATE ) AS JR_EOH_QTY
                       , ISNULL(B.CELL_QTY, 0) AS CELL_BOH_QTY
                       , ISNULL(C.CELL_QTY, 0) AS CELL_IN_QTY     -- 생산계획 + 실적
                       --, ( ISNULL(D.CELL_QTY, 0) + ISNULL(E.CELL_QTY, 0) ) AS CELL_OUT_QTY    -- TARGET 수량
                       , ( ISNULL(D.CELL_QTY, 0) ) AS CELL_OUT_QTY    -- TARGET 수량
                       --, SUM(ISNULL(B.CELL_QTY, 0) + ISNULL(C.CELL_QTY, 0) - ( ISNULL(D.CELL_QTY, 0) + ISNULL(E.CELL_QTY, 0) ) )
                       , SUM(ISNULL(B.CELL_QTY, 0) + ISNULL(C.CELL_QTY, 0) - ( ISNULL(D.CELL_QTY, 0) ) )
                              OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.PRODUCTION_TYPE
                                    ORDER     BY A.PLAN_DATE ) AS CELL_EOH_QTY                                  
                  FROM   (
                          SELECT INSTANCE_ID, FP_PLAN_ID,
                                 COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, OPERATION_ID, PRODUCTION_TYPE, PLAN_DATE, 
                                 DATE_SEQ, OPERATION_ITEM_SEQ
                          FROM   (
                                  SELECT INSTANCE_ID, FP_PLAN_ID,
                                         COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, OPERATION_ID, PRODUCTION_TYPE,
                                         MIN(OPERATION_ITEM_SEQ) AS OPERATION_ITEM_SEQ                                       
                                  FROM   TH_BUF_SCM_LOB_PSI_CATEGORY A
                                  WHERE  INSTANCE_ID = @v_master_id
                                  AND    FP_PLAN_ID  = @v_plan_id
                                  AND    EXISTS ( -- 생산과 판매가 존재하는 ITEM 에 대해서만 만든다.
                                                  SELECT 1
                                                  FROM   (
                                                          SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, OPERATION_ID, PRODUCTION_TYPE
                                                          FROM   TH_BUF_SCM_LOB_PSI_CATEGORY A
                                                          WHERE  A.INSTANCE_ID  = @v_master_id
                                                          AND    A.FP_PLAN_ID   = @v_plan_id
                                                          AND    A.CATEGORY_ID IN ('INVENTORY','DEMAND','STOCK_DEMAND')
                                                         ) B
                                                  WHERE  A.COMPANY_ID       = B.COMPANY_ID
                                                  AND    A.DIVISION_ID      = B.DIVISION_ID
                                                  AND    A.SITE_ID          = B.SITE_ID
                                                  AND    A.ITEM_ID          = B.ITEM_ID
                                                  AND    A.OPERATION_ID     = B.OPERATION_ID
                                                  AND    A.PRODUCTION_TYPE  = B.PRODUCTION_TYPE
                                                )
                                  GROUP  BY INSTANCE_ID, FP_PLAN_ID,
                                            COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, OPERATION_ID, PRODUCTION_TYPE
                                 ) A,
                                 (
                                  SELECT DATEADD(DAY, INT-1, START_DATE) AS PLAN_DATE, INT AS DATE_SEQ
                                  FROM   (
                                          SELECT CONVERT(DATE, START_DATE) AS START_DATE
                                               , DATEDIFF(DAY, CONVERT(DATE, START_DATE), END_DATE) AS DAY_DIFF 
                                          FROM   (
                                                  SELECT MIN(B.DATE_ID) AS START_DATE
                                                  FROM   SY_SCM_FP_PLAN_H A,
                                                         SY_SCM_SYS_CALENDAR_M B
                                                  WHERE  A.INSTANCE_ID = @v_master_id
                                                  AND    A.PLAN_ID     = @v_plan_id
                                                  AND    A.PLAN_WEEK   = B.WEEK                                        
                                                 ) A,
                                                 (
                                                  SELECT MAX(PLAN_DATE) END_DATE
                                                  FROM   TH_BUF_SCM_LOB_PSI_CATEGORY
                                                  WHERE  INSTANCE_ID = @v_master_id
                                                  AND    FP_PLAN_ID  = @v_plan_id
                                                 ) B
                                          WHERE  1=1
                                         ) A,
                                         COPYT B
                                  WHERE  INT <= DAY_DIFF + 1
                                 ) B
                          WHERE  1=1
                         ) A
                         LEFT OUTER JOIN TH_BUF_SCM_LOB_PSI_CATEGORY B
                              ON    A.INSTANCE_ID     = B.INSTANCE_ID
                              AND   A.FP_PLAN_ID      = B.FP_PLAN_ID
                              AND   A.COMPANY_ID      = B.COMPANY_ID
                              AND   A.DIVISION_ID     = B.DIVISION_ID
                              AND   A.SITE_ID         = B.SITE_ID
                              AND   A.ITEM_ID         = B.ITEM_ID
                              AND   A.OPERATION_ID    = B.OPERATION_ID
                              AND   A.PRODUCTION_TYPE = B.PRODUCTION_TYPE
                              AND   A.PLAN_DATE       = B.PLAN_DATE
                              AND   B.CATEGORY_ID     = 'STOCK'            -- BOH_QTY  -- STOCK 정보
                         LEFT OUTER JOIN TH_BUF_SCM_LOB_PSI_CATEGORY C
                              ON    A.INSTANCE_ID     = C.INSTANCE_ID
                              AND   A.FP_PLAN_ID      = C.FP_PLAN_ID
                              AND   A.COMPANY_ID      = C.COMPANY_ID
                              AND   A.DIVISION_ID     = C.DIVISION_ID
                              AND   A.SITE_ID         = C.SITE_ID
                              AND   A.ITEM_ID         = C.ITEM_ID
                              AND   A.OPERATION_ID    = C.OPERATION_ID
                              AND   A.PRODUCTION_TYPE = C.PRODUCTION_TYPE
                              AND   A.PLAN_DATE       = C.PLAN_DATE
                              AND   C.CATEGORY_ID     = 'INVENTORY'         -- IN_QTY   -- 생산계획
                         LEFT OUTER JOIN TH_BUF_SCM_LOB_PSI_CATEGORY D
                              ON    A.INSTANCE_ID     = D.INSTANCE_ID
                              AND   A.FP_PLAN_ID      = D.FP_PLAN_ID
                              AND   A.COMPANY_ID      = D.COMPANY_ID
                              AND   A.DIVISION_ID     = D.DIVISION_ID
                              AND   A.SITE_ID         = D.SITE_ID
                              AND   A.ITEM_ID         = D.ITEM_ID
                              AND   A.OPERATION_ID    = D.OPERATION_ID
                              AND   A.PRODUCTION_TYPE = D.PRODUCTION_TYPE
                              AND   A.PLAN_DATE       = D.PLAN_DATE
                              AND   D.CATEGORY_ID     = 'DEMAND'            -- OUT_QTY  -- TARGET DEMAND
                         LEFT OUTER JOIN TH_BUF_SCM_LOB_PSI_CATEGORY E
                              ON    A.INSTANCE_ID     = E.INSTANCE_ID
                              AND   A.FP_PLAN_ID      = E.FP_PLAN_ID
                              AND   A.COMPANY_ID      = E.COMPANY_ID
                              AND   A.DIVISION_ID     = E.DIVISION_ID
                              AND   A.SITE_ID         = E.SITE_ID
                              AND   A.ITEM_ID         = E.ITEM_ID
                              AND   A.OPERATION_ID    = E.OPERATION_ID
                              AND   A.PRODUCTION_TYPE = E.PRODUCTION_TYPE
                              AND   A.PLAN_DATE       = E.PLAN_DATE
                              AND   E.CATEGORY_ID     = 'STOCK_DEMAND'      -- OUT_QTY  -- STOCK-DEMAND 차감된 애들
                 ) A
                 
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          -- 실적은 따로 처리
          UPDATE TH_BUF_SCM_LOB_PSI
          SET    TH_BUF_SCM_LOB_PSI.IN_QTY = CEILING(B.QTY)
          FROM   TH_BUF_SCM_LOB_PSI A,
                 TH_BUF_SCM_LOB_PSI_CATEGORY B
          WHERE  A.INSTANCE_ID     = @v_master_id
          AND    A.FP_PLAN_ID      = @v_plan_id
          AND    A.INSTANCE_ID     = B.INSTANCE_ID
          AND    A.FP_PLAN_ID      = B.FP_PLAN_ID
          AND    A.COMPANY_ID      = B.COMPANY_ID
          AND    A.DIVISION_ID     = B.DIVISION_ID
          AND    A.SITE_ID         = B.SITE_ID
          AND    A.ITEM_ID         = B.ITEM_ID
          AND    A.OPERATION_ID    = B.OPERATION_ID
          AND    A.PRODUCTION_TYPE = B.PRODUCTION_TYPE
          AND    A.PLAN_DATE       = B.PLAN_DATE
          AND    B.CATEGORY_ID     = 'RESULT'            
          AND    B.QTY             > 0

          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          UPDATE TH_BUF_SCM_LOB_PSI
          SET    TH_BUF_SCM_LOB_PSI.EOH_QTY = CEILING(B.QTY)
          FROM   TH_BUF_SCM_LOB_PSI A,
                 TH_BUF_SCM_LOB_PSI_CATEGORY B
          WHERE  A.INSTANCE_ID     = @v_master_id
          AND    A.FP_PLAN_ID      = @v_plan_id
          AND    A.INSTANCE_ID     = B.INSTANCE_ID
          AND    A.FP_PLAN_ID      = B.FP_PLAN_ID
          AND    A.COMPANY_ID      = B.COMPANY_ID
          AND    A.DIVISION_ID     = B.DIVISION_ID
          AND    A.SITE_ID         = B.SITE_ID
          AND    A.ITEM_ID         = B.ITEM_ID
          AND    A.OPERATION_ID    = B.OPERATION_ID
          AND    A.PRODUCTION_TYPE = B.PRODUCTION_TYPE
          AND    A.PLAN_DATE       = DATEADD(DAY, -1, B.PLAN_DATE)
          AND    B.CATEGORY_ID     = 'STOCK'            
          AND    B.QTY             > 0

          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
          
          UPDATE TH_BUF_SCM_LOB_PSI
          SET    TH_BUF_SCM_LOB_PSI.BOH_QTY       = B.NEW_BOH_QTY,
                 TH_BUF_SCM_LOB_PSI.IN_QTY        = B.NEW_IN_QTY,
                 TH_BUF_SCM_LOB_PSI.OUT_QTY       = B.NEW_OUT_QTY,
                 TH_BUF_SCM_LOB_PSI.EOH_QTY       = B.NEW_EOH_QTY,
                 TH_BUF_SCM_LOB_PSI.ROLL_BOH_QTY  = B.NEW_ROLL_BOH_QTY,
                 TH_BUF_SCM_LOB_PSI.ROLL_IN_QTY   = B.NEW_ROLL_IN_QTY,
                 TH_BUF_SCM_LOB_PSI.ROLL_OUT_QTY  = B.NEW_ROLL_OUT_QTY,
                 TH_BUF_SCM_LOB_PSI.ROLL_EOH_QTY  = B.NEW_ROLL_EOH_QTY,
                 TH_BUF_SCM_LOB_PSI.JR_BOH_QTY    = B.NEW_JR_BOH_QTY,
                 TH_BUF_SCM_LOB_PSI.JR_IN_QTY     = B.NEW_JR_IN_QTY,
                 TH_BUF_SCM_LOB_PSI.JR_OUT_QTY    = B.NEW_JR_OUT_QTY,
                 TH_BUF_SCM_LOB_PSI.JR_EOH_QTY    = B.NEW_JR_EOH_QTY,
                 TH_BUF_SCM_LOB_PSI.CELL_BOH_QTY  = B.NEW_CELL_BOH_QTY,
                 TH_BUF_SCM_LOB_PSI.CELL_IN_QTY   = B.NEW_CELL_IN_QTY,
                 TH_BUF_SCM_LOB_PSI.CELL_OUT_QTY  = B.NEW_CELL_OUT_QTY,
                 TH_BUF_SCM_LOB_PSI.CELL_EOH_QTY  = B.NEW_CELL_EOH_QTY
          FROM   TH_BUF_SCM_LOB_PSI A,
                 (
                  SELECT A.*, 
                         A.BOH_QTY + B.BOH_QTY AS NEW_BOH_QTY, A.IN_QTY AS NEW_IN_QTY, B.OUT_QTY AS NEW_OUT_QTY, A.EOH_QTY + B.EOH_QTY AS NEW_EOH_QTY,
                         A.ROLL_BOH_QTY + B.ROLL_BOH_QTY AS NEW_ROLL_BOH_QTY, A.ROLL_IN_QTY AS NEW_ROLL_IN_QTY, B.ROLL_OUT_QTY AS NEW_ROLL_OUT_QTY, A.ROLL_EOH_QTY + B.ROLL_EOH_QTY AS NEW_ROLL_EOH_QTY,
                         A.JR_BOH_QTY + B.JR_BOH_QTY AS NEW_JR_BOH_QTY, A.JR_IN_QTY AS NEW_JR_IN_QTY, B.JR_OUT_QTY AS NEW_JR_OUT_QTY, A.JR_EOH_QTY + B.JR_EOH_QTY AS NEW_JR_EOH_QTY,
                         A.CELL_BOH_QTY + B.CELL_BOH_QTY AS NEW_CELL_BOH_QTY, A.CELL_IN_QTY AS NEW_CELL_IN_QTY, B.CELL_OUT_QTY AS NEW_CELL_OUT_QTY, A.CELL_EOH_QTY + B.CELL_EOH_QTY AS NEW_CELL_EOH_QTY
                  FROM   TH_BUF_SCM_LOB_PSI A,
                         TH_BUF_SCM_LOB_PSI B
                  WHERE  1=1
                  AND    A.INSTANCE_ID  = @v_master_id
                  AND    A.FP_PLAN_ID   = @v_plan_id
                  AND    A.INSTANCE_ID  = B.INSTANCE_ID
                  AND    A.FP_PLAN_ID   = B.FP_PLAN_ID
                  AND    A.ITEM_ID      = B.ITEM_ID
                  AND    A.PLAN_DATE    = B.PLAN_DATE
                  AND    A.OPERATION_ID = 'E2000'
                  AND    B.OPERATION_ID = 'E2500'
                  AND    A.COMPANY_ID   = B.COMPANY_ID
                  AND    A.DIVISION_ID  = B.DIVISION_ID
                  AND    A.SITE_ID      = B.SITE_ID
                 ) B
          WHERE  1=1
          AND    A.INSTANCE_ID  = @v_master_id
          AND    A.FP_PLAN_ID   = @v_plan_id
          AND    A.INSTANCE_ID  = B.INSTANCE_ID
          AND    A.FP_PLAN_ID   = B.FP_PLAN_ID
          AND    A.COMPANY_ID   = B.COMPANY_ID
          AND    A.DIVISION_ID  = B.DIVISION_ID
          AND    A.SITE_ID      = B.SITE_ID
          AND    A.ITEM_ID      = B.ITEM_ID
          AND    A.PLAN_DATE    = B.PLAN_DATE
          
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
          
          DELETE TH_BUF_SCM_LOB_PSI
          WHERE 1=1
          AND INSTANCE_ID = @v_master_id
          AND FP_PLAN_ID =  @v_plan_id
          AND OPERATION_ID = 'E2500'

          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null        
          
        END
        
        SET @v_table_name = 'FP_AMEND_LOB_PSI_R'

        INSERT INTO SY_FP_AMEND_LOB_PSI_R
             (
               INSTANCE_ID
             , FP_PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , ITEM_ID
             , OPERATION_ID
             , PRODUCTION_TYPE
             , PLAN_DATE
             , BOH_QTY
             , IN_QTY
             , OUT_QTY
             , EOH_QTY
             , DATE_SEQ
             , ROLL_BOH_QTY
             , ROLL_IN_QTY
             , ROLL_OUT_QTY
             , ROLL_EOH_QTY
             , JR_BOH_QTY
             , JR_IN_QTY
             , JR_OUT_QTY
             , JR_EOH_QTY
             , CELL_BOH_QTY
             , CELL_IN_QTY
             , CELL_OUT_QTY
             , CELL_EOH_QTY
             , OPERATION_ITEM_SEQ
             , INSERT_ID
             , INSERT_TIME
             )
        SELECT
               INSTANCE_ID
             , FP_PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , ITEM_ID
             , OPERATION_ID
             , PRODUCTION_TYPE
             , PLAN_DATE
             , BOH_QTY
             , IN_QTY
             , OUT_QTY
             , EOH_QTY
             , DATE_SEQ
             , ROLL_BOH_QTY
             , ROLL_IN_QTY
             , ROLL_OUT_QTY
             , ROLL_EOH_QTY
             , JR_BOH_QTY
             , JR_IN_QTY
             , JR_OUT_QTY
             , JR_EOH_QTY
             , CELL_BOH_QTY
             , CELL_IN_QTY
             , CELL_OUT_QTY
             , CELL_EOH_QTY
             , OPERATION_ITEM_SEQ
             , INSERT_ID
             , INSERT_TIME
        FROM   TH_BUF_SCM_LOB_PSI
        WHERE  1=1
        AND    INSTANCE_ID = @v_master_id
        AND    FP_PLAN_ID =  @v_plan_id
        
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null        
        
      END
      
      
      IF @p_flag = 'PSI'
        BEGIN
        
          SET @v_table_name = 'FP_PSI_R'

          DELETE FROM SY_FP_PSI_R
          WHERE  INSTANCE_ID     = @v_master_id
          AND    FP_PLAN_ID      = @v_plan_id

          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null        

          INSERT INTO SY_FP_PSI_R
               (
                 INSTANCE_ID
               , FP_PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , ITEM_ID
               , OPERATION_ID
               , PRODUCTION_TYPE
               , PLAN_DATE
               , BOH_QTY
               , IN_QTY
               , OUT_QTY
               , EOH_QTY
               , DATE_SEQ
               , ROLL_BOH_QTY
               , ROLL_IN_QTY
               , ROLL_OUT_QTY
               , ROLL_EOH_QTY
               , JR_BOH_QTY
               , JR_IN_QTY
               , JR_OUT_QTY
               , JR_EOH_QTY
               , CELL_BOH_QTY
               , CELL_IN_QTY
               , CELL_OUT_QTY
               , CELL_EOH_QTY
               , OPERATION_ITEM_SEQ
               , INSERT_ID
               , INSERT_TIME
               )
          SELECT
                 INSTANCE_ID
               , FP_PLAN_ID
               , COMPANY_ID
               , DIVISION_ID
               , SITE_ID
               , ITEM_ID
               , OPERATION_ID
               , PRODUCTION_TYPE
               , PLAN_DATE
               , BOH_QTY
               , IN_QTY
               , OUT_QTY
               , EOH_QTY
               , DATE_SEQ
               , ROLL_BOH_QTY
               , ROLL_IN_QTY
               , ROLL_OUT_QTY
               , ROLL_EOH_QTY
               , JR_BOH_QTY
               , JR_IN_QTY
               , JR_OUT_QTY
               , JR_EOH_QTY
               , CELL_BOH_QTY
               , CELL_IN_QTY
               , CELL_OUT_QTY
               , CELL_EOH_QTY               
               , OPERATION_ITEM_SEQ
               , INSERT_ID
               , INSERT_TIME          
          FROM   SY_FP_AMEND_LOB_PSI_R
          WHERE  INSTANCE_ID     = @v_master_id
          AND    FP_PLAN_ID      = @v_plan_id
        
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null        
          
        END
      
      IF @@TRANCOUNT > 0
        COMMIT WORK 
    END
    
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
