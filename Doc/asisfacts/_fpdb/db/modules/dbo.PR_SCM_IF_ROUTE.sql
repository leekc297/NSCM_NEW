CREATE PROCEDURE [dbo].[PR_SCM_IF_ROUTE]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_ROUTE                                                           **/
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
/** 2016.08.18    LJH          최초 작성                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_IF_ROUTE
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

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_ROUTE'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
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
              @key_date = PLAN_DATE
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM,
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
      
      
    END;
    
    BEGIN
    
      SET @v_table_name = 'TH_MST_SITE'
      
      DELETE FROM TH_MST_SITE
      WHERE   MASTER_ID   = @v_master_id
      AND     PLAN_ID     = @p_plan_id
      
      INSERT INTO TH_MST_SITE
              (MASTER_ID
              ,PLAN_ID
              ,SITE_ID
              ,SITE_NAME
              ,KEY_DATE
              ,INSERT_ID
              ,INSERT_DTTM
              ,UPDATE_ID
              ,UPDATE_DTTM )
      SELECT   @v_master_id
              ,@v_plan_id
              ,C.FACTORY_ID
              ,C.FACTORY_NAME
              ,@key_date  AS KEY_DATE
              ,@v_proc_name as INSERT_ID
              ,GETDATE() as INSERT_DTTM
              ,@v_proc_name as UPDATE_ID
              ,getdate() as UPDATE_DTTM
      FROM (        
              SELECT   DISTINCT A.FACTORY_ID
                      ,A.FACTORY_NAME
              FROM     SY_SCM_FACTORY_M     A
                      ,TH_MST_INSTANCE_FLOW B
              WHERE    A.COMPANY_ID   = B.COMPANY_ID
              AND      A.DIVISION_ID  = B.DIVISION_ID
              AND      A.SITE_ID      = B.SITE_ID
              AND      A.PLANT_ID     = B.PLANT_ID
              AND      A.FACTORY_ID   = B.FACTORY_ID
              AND      B.MASTER_ID    = @v_master_id
              AND      B.PLAN_ID      = @v_plan_id
            ) C
      
      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
    
    END
    
    BEGIN
    
      SET @v_table_name = 'TH_MST_ROUTE'
      
      DELETE FROM TH_MST_ROUTE
      WHERE   MASTER_ID   = @v_master_id
      AND     PLAN_ID     = @p_plan_id
      
      INSERT INTO TH_MST_ROUTE
              (MASTER_ID
              ,PLAN_ID
              ,ROUTE_ID
              ,ROUTE_NAME
              ,ROUTE_LEVEL
              ,KEY_DATE
              ,INSERT_ID
              ,INSERT_DTTM
              ,UPDATE_ID
              ,UPDATE_DTTM )
      SELECT   @v_master_id
              ,@v_plan_id
              ,C.ROUTE_ID
              ,C.ROUTE_NAME
              ,C.ROUTE_LEVEL
              ,@key_date AS KEY_DATE
              ,@v_proc_name as INSERT_ID
              ,GETDATE() as INSERT_DTTM
              ,@v_proc_name as UPDATE_ID
              ,getdate() as UPDATE_DTTM
      FROM (        
              SELECT   A.LINE_ID AS ROUTE_ID
                      ,MAX(A.LINE_NAME) AS ROUTE_NAME
                      ,100 AS ROUTE_LEVEL
              FROM     SY_SCM_LINE_M        A
                      ,TH_MST_INSTANCE_FLOW B
              WHERE    A.COMPANY_ID   = B.COMPANY_ID
              AND      A.DIVISION_ID  = B.DIVISION_ID
              AND      A.SITE_ID      = B.SITE_ID
              AND      A.PLANT_ID     = B.PLANT_ID
              AND      A.FACTORY_ID   = B.FACTORY_ID
              AND      B.MASTER_ID    = @v_master_id
              AND      B.PLAN_ID      = @v_plan_id
              GROUP BY A.LINE_ID
            ) C
      
      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
    
    END
    
    BEGIN
    
      SET @v_table_name = 'TH_MST_OPERATION'
      
      DELETE FROM TH_MST_OPERATION
      WHERE   MASTER_ID   = @v_master_id
      AND     PLAN_ID     = @p_plan_id
      
      INSERT INTO TH_MST_OPERATION
              (MASTER_ID
              ,PLAN_ID
              ,OPERATION_ID
              ,OPERATION_NAME
              ,OPERATION_TYPE
              ,KEY_DATE
              ,INSERT_ID
              ,INSERT_DTTM
              ,UPDATE_ID
              ,UPDATE_DTTM )
      SELECT   @v_master_id
              ,@v_plan_id
              ,C.OPERATION_ID
              ,C.OPERATION_NAME
              ,C.OPERATION_TYPE
              ,@key_date AS KEY_DATE
              ,@v_proc_name as INSERT_ID
              ,GETDATE() as INSERT_DTTM
              ,@v_proc_name as UPDATE_ID
              ,getdate() as UPDATE_DTTM
      FROM (        
              SELECT   DISTINCT A.OPERATION_ID
                      ,A.OPERATION_NAME
                      ,'PULL' AS OPERATION_TYPE
              FROM     SY_SCM_OPERATION_M   A
                      ,TH_MST_INSTANCE_FLOW B
              WHERE    A.COMPANY_ID   = B.COMPANY_ID
              AND      A.DIVISION_ID  = B.DIVISION_ID
              AND      A.SITE_ID      = B.SITE_ID
             -- AND      A.PLANT_ID     = B.PLANT_ID
              AND      A.OPERATION_ID = B.OPERATION_ID
              AND      B.MASTER_ID    = @v_master_id
              AND      B.PLAN_ID      = @v_plan_id
            ) C
      
      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
    
    END
    
    BEGIN
    
      SET @v_table_name = 'TH_MST_OPERATION_FLOW'
      
      DELETE FROM TH_MST_OPERATION_FLOW
      WHERE   MASTER_ID   = @v_master_id
      AND     PLAN_ID     = @p_plan_id
      
      INSERT INTO TH_MST_OPERATION_FLOW
              (MASTER_ID
              ,PLAN_ID
              ,SITE_ID
              ,ROUTE_ID
              ,OPERATION_ID
              ,OPERATION_SEQ
              ,FLOW_ID
              ,KEY_DATE
              ,INSERT_ID
              ,INSERT_DTTM
              ,UPDATE_ID
              ,UPDATE_DTTM )
      SELECT   @v_master_id
              ,@v_plan_id
              ,E.SITE_ID
              ,E.ROUTE_ID
              ,E.OPERATION_ID
              ,E.OPERATION_SEQ
              ,E.FLOW_ID
              ,@key_date AS KEY_DATE
              ,@v_proc_name as INSERT_ID
              ,GETDATE() as INSERT_DTTM
              ,@v_proc_name as UPDATE_ID
              ,getdate() as UPDATE_DTTM
      FROM (        
              SELECT   DISTINCT A.FACTORY_ID AS SITE_ID
                      ,B.LINE_ID AS ROUTE_ID
                      ,C.OPERATION_ID
                      ,C.OPERATION_SEQ
                      ,C.FLOW_ID
              FROM     SY_SCM_FACTORY_M         A
                      ,SY_SCM_LINE_M            B
                      ,SY_SCM_OPERATION_FLOW_M  C
                      ,TH_MST_INSTANCE_FLOW     D
              WHERE    A.COMPANY_ID   = B.COMPANY_ID
              AND      A.DIVISION_ID  = B.DIVISION_ID
              AND      A.FACTORY_ID   = B.FACTORY_ID
              AND      A.SITE_ID      = B.SITE_ID
              AND      A.PLANT_ID     = B.PLANT_ID
              AND      A.COMPANY_ID   = C.COMPANY_ID
              AND      A.DIVISION_ID  = C.DIVISION_ID
              AND      A.SITE_ID      = C.SITE_ID
              --AND      A.PLANT_ID     = C.PLANT_ID
              AND      A.COMPANY_ID   = D.COMPANY_ID
              AND      A.DIVISION_ID  = D.DIVISION_ID
              AND      A.SITE_ID      = D.SITE_ID
              AND      A.PLANT_ID     = D.PLANT_ID  
              AND      A.FACTORY_ID   = D.FACTORY_ID
              AND      C.OPERATION_ID = D.OPERATION_ID
              AND      D.MASTER_ID    = @v_master_id
              AND      D.PLAN_ID      = @v_plan_id
            ) E
            
      
      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
    
    END

    BEGIN
    
      SET @v_table_name = 'TH_MST_ITEM_ROUTE_SITE'
      
      DELETE FROM TH_MST_ITEM_ROUTE_SITE
      WHERE   MASTER_ID   = @v_master_id
      AND     PLAN_ID     = @p_plan_id
      
      INSERT INTO TH_MST_ITEM_ROUTE_SITE
               (MASTER_ID
               ,PLAN_ID
               ,ITEM_ID
               ,SITE_ID
               ,ROUTE_ID
               ,ROUTE_LEVEL
               ,OPERATION_ID
               ,OPERATION_SEQ
               ,FLOW_ID
               ,YIELD
               ,IN_MOVING_LOT_SIZE
               ,OUT_MOVING_LOT_SIZE
               ,MIN_LOT_SIZE
               ,EARLY_PRODUCING_TERM
               ,EARLY_PRODUCING_TERM_UOM
               ,OPERATION_TYPE
               ,TAT    
               ,TAT_UOM
               ,TAT_TYPE        -- TAT_CAPA, TAT_MOVE
               ,IN_MOVE_TIME
               ,OUT_MOVE_TIME 
               ,MOVE_TIME_UOM
               ,TRANSFER_BATCH_SIZE
               ,IRS_ATTB_1    -- ERP_OPERATION_ID
               ,IRS_ATTB_11   -- COMPANY_ID
               ,IRS_ATTB_12   -- DIVISION_ID
               ,IRS_ATTB_13   -- SITE_ID
               ,IRS_ATTB_14   -- PLANT_ID
               ,IRS_ATTB_15   -- FACTORY_ID
               ,KEY_DATE
               ,INSERT_ID
               ,INSERT_DTTM
               ,UPDATE_ID
               ,UPDATE_DTTM)
      SELECT    D.master_id
               ,D.plan_id
               ,D.ITEM_ID
               ,D.SITE_ID
               ,D.ROUTE_ID
               ,D.ROUTE_LEVEL
               ,D.OPERATION_ID
               ,D.OPERATION_SEQ
               ,D.FLOW_ID
               ,1
--               ,D.OPERATION_LOT_SIZE  AS IN_MOVING_LOT_SIZE
               ,0                     AS IN_MOVING_LOT_SIZE
               ,0                     AS OUT_MOVING_LOT_SIZE
               ,D.MIN_LOT_SIZE
               ,D.EARLY_PRODUCING_TERM
               ,D.EARLY_PRODUCING_TERM_UOM
               ,'PULL' OPERATION_TYPE
               ,D.TAT
               ,D.TAT_UOM
               ,D.TAT_TYPE
               ,0                          AS IN_MOVE_TIME 
               ,ISNULL(D.BUFFER_TIME, 0)   AS OUT_MOVE_TIME 
               ,ISNULL(D.BUFFER_TIME_UOM,'MINUTE') AS MOVE_TIME_UOM
               ,D.TRANSFER_BATCH_SIZE
               ,D.IRS_ATTB_1
               ,D.IRS_ATTB_11
               ,D.IRS_ATTB_12
               ,D.IRS_ATTB_13
               ,D.IRS_ATTB_14
               ,D.IRS_ATTB_15
               ,@key_date AS KEY_DATE
               ,@v_proc_name as INSERT_ID
               ,GETDATE() as INSERT_DTTM
               ,@v_proc_name as UPDATE_ID
               ,getdate() as UPDATE_DTTM
      FROM    (
                SELECT   DISTINCT 
                         A.MASTER_ID
                        ,A.PLAN_ID
                        ,A.ITEM_ID
                        ,A.FACTORY_ID AS SITE_ID
                        ,B.LINE_ID AS ROUTE_ID
                        ,100 AS ROUTE_LEVEL
                        ,A.OPERATION_ID
                        ,A.OPERATION_SEQ
                        ,'A.' FLOW_ID
                        ,CASE WHEN X.OPERATION_LOT_SIZE IS NULL THEN C.OPERATION_LOT_SIZE
                              WHEN X.OPERATION_LOT_SIZE <= 0    THEN C.OPERATION_LOT_SIZE
                              ELSE X.OPERATION_LOT_SIZE
                         END  AS OPERATION_LOT_SIZE
                        ,CASE WHEN X.MIN_LOT_SIZE IS NULL THEN C.MIN_LOT_SIZE
                              WHEN X.MIN_LOT_SIZE <= 0    THEN C.MIN_LOT_SIZE
                              ELSE X.MIN_LOT_SIZE
                         END  AS MIN_LOT_SIZE
                        ,CASE WHEN X.PRECEDE_PRODUCING_TERM IS NULL THEN ISNULL(C.PRECEDE_PRODUCING_TERM, 0)
                              WHEN X.PRECEDE_PRODUCING_TERM <= 0    THEN ISNULL(C.PRECEDE_PRODUCING_TERM, 0)
                              ELSE X.PRECEDE_PRODUCING_TERM
                         END  AS EARLY_PRODUCING_TERM
                        ,CASE WHEN X.PRECEDE_PRODUCING_TERM IS NULL THEN UPPER(ISNULL(C.PRECEDE_PRODUCING_TERM_UOM, 'DAY'))
                              WHEN X.PRECEDE_PRODUCING_TERM <= 0    THEN UPPER(ISNULL(C.PRECEDE_PRODUCING_TERM_UOM, 'DAY'))
                              ELSE UPPER(ISNULL(X.PRECEDE_PRODUCING_TERM_UOM, 'DAY'))
                         END  AS EARLY_PRODUCING_TERM_UOM
                        --,CASE WHEN A.TAT_FLAG = 'Y' AND A.TAT_TYPE = 'BATCH' THEN 'BATCH' ELSE 'PULL' END OPERATION_TYPE
                        ,CASE WHEN A.CAPA_TYPE IN ('TAT', 'TAT_CAPA','TAT_MOVE','BATCH') AND ISNULL(X.TAT, 0) > 0 THEN X.TAT
                              WHEN A.CAPA_TYPE IN ('TAT', 'TAT_CAPA','TAT_MOVE','BATCH') AND ISNULL(C.TAT, 0) > 0 THEN C.TAT 
                              ELSE NULL 
                         END  AS TAT
                        ,CASE WHEN A.CAPA_TYPE IN ('TAT', 'TAT_CAPA','TAT_MOVE','BATCH') AND ISNULL(X.TAT, 0) > 0 THEN X.TAT_UOM
                              WHEN A.CAPA_TYPE IN ('TAT', 'TAT_CAPA','TAT_MOVE','BATCH') AND ISNULL(C.TAT, 0) > 0 THEN C.TAT_UOM 
                              ELSE C.TAT_UOM 
                         END  AS TAT_UOM
                        ,A.CAPA_TYPE AS TAT_TYPE
                        ,CASE WHEN X.BUFFER_TIME IS NULL THEN C.BUFFER_TIME
                              WHEN X.BUFFER_TIME <= 0    THEN C.BUFFER_TIME
                              ELSE X.BUFFER_TIME
                         END  AS BUFFER_TIME
                        ,CASE WHEN X.BUFFER_TIME IS NULL THEN C.BUFFER_TIME_UOM
                              WHEN X.BUFFER_TIME <= 0    THEN C.BUFFER_TIME_UOM
                              ELSE X.BUFFER_TIME_UOM
                         END  AS BUFFER_TIME_UOM
                        ,CASE WHEN X.TRANSFER_LOT_SIZE IS NULL THEN C.TRANSFER_LOT_SIZE  
                              WHEN X.TRANSFER_LOT_SIZE <= 0    THEN C.TRANSFER_LOT_SIZE  
                              ELSE X.TRANSFER_LOT_SIZE
                         END  AS TRANSFER_BATCH_SIZE
                        ,A.ERP_OPERATION_ID   AS IRS_ATTB_1
                        ,A.COMPANY_ID         AS IRS_ATTB_11
                        ,A.DIVISION_ID        AS IRS_ATTB_12
                        ,A.SITE_ID            AS IRS_ATTB_13
                        ,A.PLANT_ID           AS IRS_ATTB_14
                        ,A.FACTORY_ID         AS IRS_ATTB_15
                FROM     TH_MST_INSTANCE_FLOW A
                         INNER JOIN SY_SCM_LINE_M        B
                                ON       A.COMPANY_ID   = B.COMPANY_ID
                                AND      A.DIVISION_ID  = B.DIVISION_ID
                                AND      A.SITE_ID      = B.SITE_ID
                                AND      A.PLANT_ID     = B.PLANT_ID
                                AND      A.FACTORY_ID   = B.FACTORY_ID
                                AND      A.OPERATION_ID = B.OPERATION_ID
                         LEFT OUTER JOIN SY_SCM_OPERATION_MOVE_M C(NOLOCK)
                                ON     A.COMPANY_ID = C.COMPANY_ID
                                AND    A.DIVISION_ID = C.DIVISION_ID
                                AND    A.SITE_ID = C.SITE_ID
                                AND    A.PLANT_ID = C.PLANT_ID
                                AND    A.FACTORY_ID = C.FACTORY_ID
                                AND    A.OPERATION_ID = C.OPERATION_ID
                                AND    C.ACTIVE_FLAG = 'Y'
                         LEFT OUTER JOIN SY_SCM_ITEM_FLOW_EXCEPT_M X(NOLOCK)
                                ON     A.COMPANY_ID = X.COMPANY_ID
                                AND    A.DIVISION_ID = X.DIVISION_ID
                                AND    A.SITE_ID = X.SITE_ID
                                AND    A.PLANT_ID = X.PLANT_ID
                                AND    A.FACTORY_ID = X.FACTORY_ID
                                AND    A.OPERATION_ID = X.OPERATION_ID
                                AND    A.ITEM_ID = X.ITEM_ID                                
                WHERE    A.MASTER_ID    = @v_master_id
                AND      A.PLAN_ID      = @v_plan_id
               ) D
      
      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      
      UPDATE TH_MST_ITEM_ROUTE_SITE
      SET    TH_MST_ITEM_ROUTE_SITE.FLOW_ID = B.FLOW_ID
      FROM   TH_MST_ITEM_ROUTE_SITE A,
             (
              SELECT ITEM_ID, SITE_ID,
                     MAX(OP01)+MAX(OP02)+MAX(OP03)+MAX(OP04)+MAX(OP05)+MAX(OP06)+MAX(OP07)+MAX(OP08)+MAX(OP09)+MAX(OP10) AS FLOW_ID
              FROM   (
                      SELECT A.ITEM_ID, A.SITE_ID,
                             CASE SEQ WHEN  1 THEN A.OPERATION_ID ELSE '' END OP01,
                             CASE SEQ WHEN  2 THEN A.OPERATION_ID ELSE '' END OP02,
                             CASE SEQ WHEN  3 THEN A.OPERATION_ID ELSE '' END OP03,
                             CASE SEQ WHEN  4 THEN A.OPERATION_ID ELSE '' END OP04,
                             CASE SEQ WHEN  5 THEN A.OPERATION_ID ELSE '' END OP05,
                             CASE SEQ WHEN  6 THEN A.OPERATION_ID ELSE '' END OP06,
                             CASE SEQ WHEN  7 THEN A.OPERATION_ID ELSE '' END OP07,
                             CASE SEQ WHEN  8 THEN A.OPERATION_ID ELSE '' END OP08,
                             CASE SEQ WHEN  9 THEN A.OPERATION_ID ELSE '' END OP09,
                             CASE SEQ WHEN 10 THEN A.OPERATION_ID ELSE '' END OP10 
                      FROM   (
                              SELECT A.ITEM_ID, A.SITE_ID, A.OPERATION_ID, 
                                     DENSE_RANK() OVER (PARTITION BY A.ITEM_ID, A.SITE_ID 
                                                        ORDER     BY MIN(OPERATION_SEQ), A.OPERATION_ID) AS SEQ
                              FROM   TH_MST_ITEM_ROUTE_SITE A
                              WHERE    A.MASTER_ID    = @v_master_id
                              AND      A.PLAN_ID      = @v_plan_id
                              GROUP  BY A.ITEM_ID, A.SITE_ID, A.OPERATION_ID
                             ) A
                     ) A
              GROUP  BY ITEM_ID, SITE_ID
              ) B
      WHERE  A.MASTER_ID  = @v_master_id
      AND    A.PLAN_ID    = @v_plan_id
      AND    A.ITEM_ID    = B.ITEM_ID
      AND    A.SITE_ID    = B.SITE_ID

      SET @n_row_count = @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
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
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', '999999', null, '############### End of procedure ###############', null

END
