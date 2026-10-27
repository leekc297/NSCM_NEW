CREATE PROCEDURE [dbo].[PR_SCM_MF_BATCH_ROUTE_ENG]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MF_BATCH_ROUTE_ENG                                                 **/
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
  EXEC PR_SCM_MF_BATCH_ROUTE_ENG
  
  ITEM_ID 가 들어 있는 부분에 대해 변경작업 처리한다.

  TH_ENG_ITEM                     -- INSERT 
  TH_ENG_ITEM_CAL                 -- INSERT 
  TH_ENG_PLAN_BOM                 -- INSERT 
  TH_ENG_PLAN_BOM                             -- UPDATE 
  TH_ENG_PLAN_BOM_CAL                         -- UPDATE 
  TH_ENG_ITEM_ROUTE_SITE                      -- UPDATE 
  TH_ENG_OP_RES_GROUP                         -- UPDATE 
  TH_ENG_OP_RES_GROUP_CAL                     -- UPDATE 
  TH_ENG_OP_RES_GROUP_MAP                     -- UPDATE 
  TH_ENG_OP_RES_GROUP_MAP_CAL                 -- UPDATE 
  TH_ENG_PRODUCT_MIX_MAP                      -- UPDATE   
  TH_ENG_SALES_PRODUCT_MAP                    -- UPDATE   
  TH_ENG_SALES_PRODUCT_MAP_CAL                -- UPDATE   
  TH_ENG_FIXED_PLAN                           -- UPDATE 
  TH_ENG_STOCK_PLAN                           -- UPDATE
  TH_ENG_WIP                                  -- UPDATE
  
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_MF_BATCH_ROUTE_ENG'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()

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
              @plan_end_time   = PLAN_END_DTTM
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM
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
      
      BEGIN
      
        SET @v_table_name = 'TH_BUF_SCM_BATCH_SITE'
        
        DELETE FROM TH_BUF_SCM_BATCH_SITE
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id

        INSERT INTO TH_BUF_SCM_BATCH_SITE
        SELECT DISTINCT
               A.MASTER_ID, A.PLAN_ID,
               A.PARENT_ITEM_ID, A.SITE_ID, A.CHILD_ITEM_ID,
               B.DESCR AS PARENT_BATCH_SITE,
               CASE WHEN B.DESCR IS NULL THEN NULL 
                    ELSE B.BATCH_GROUP_ID        -- SITE 마다 배치가 다르다.
               END  AS PARENT_BATCH_GROUP,
               D.SITE_ID AS CHILD_BATCH_SITE,
               CASE WHEN D.SITE_ID IS NULL THEN NULL 
                    ELSE C.BATCH_GROUP_ID        -- SITE 마다 배치가 다르다.
               END  AS CHILD_BATCH_GROUP,
               CASE WHEN B.DESCR IS NULL THEN A.PARENT_ITEM_ID
                    ELSE A.PARENT_ITEM_ID + '_BATCH:' + B.DESCR
               END  NEW_PARENT_ITEM_ID,
               CASE WHEN D.SITE_ID IS NULL THEN A.CHILD_ITEM_ID
                    ELSE A.CHILD_ITEM_ID + '_BATCH:' + D.SITE_ID
               END  NEW_CHILD_ITEM_ID       
        FROM   TH_ENG_PLAN_BOM A
               LEFT OUTER JOIN TH_ENG_BATCH_INFO B
                    ON     1=1
                    AND    A.MASTER_ID = B.MASTER_ID
                    AND    A.PLAN_ID = B.PLAN_ID
                    AND    A.PARENT_ITEM_ID = B.ITEM_ID
                    AND    A.SITE_ID = B.DESCR
               LEFT OUTER JOIN TH_ENG_BATCH_INFO C
                    ON     1=1
                    AND    A.MASTER_ID = C.MASTER_ID
                    AND    A.PLAN_ID = C.PLAN_ID
                    AND    A.CHILD_ITEM_ID = C.ITEM_ID
               LEFT OUTER JOIN TH_ENG_OP_RES_GROUP D     -- CHILD 가 BATCH 이면 TACT 이 있는 SITE 만 선택
                    ON     1=1
                    AND    A.MASTER_ID = D.MASTER_ID
                    AND    A.PLAN_ID = D.PLAN_ID
                    AND    A.CHILD_ITEM_ID = D.ITEM_ID
                    AND    C.DESCR = D.SITE_ID
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.SITE_ID = ISNULL(B.DESCR, D.SITE_ID)
        AND    (    B.DESCR IS NOT NULL 
                 OR D.SITE_ID IS NOT NULL )

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null



        SET @v_table_name = 'TH_BUF_SCM_BATCH_SETUP'
        
        DELETE FROM TH_BUF_SCM_BATCH_SETUP
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id
                
        INSERT INTO TH_BUF_SCM_BATCH_SETUP
        SELECT  A.MASTER_ID, A.PLAN_ID, A.SETUP_GROUP_ID, B.BATCH_GROUP
        FROM    TH_ENG_ITEM A,
                (
                  SELECT ITEM_ID, BATCH_GROUP
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, BATCH_GROUP
                ) B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.ITEM_ID = B.ITEM_ID
        AND     A.SETUP_GROUP_ID IS NOT NULL
        GROUP   BY A.MASTER_ID, A.PLAN_ID, A.SETUP_GROUP_ID, B.BATCH_GROUP

      END

      ------------------------------------------------------------------------------------------------------
      -- BATCH SETUP 설정 부분이 들어가야 한다...
      ------------------------------------------------------------------------------------------------------

      BEGIN

        SET @v_table_name = 'TH_ENG_RESOURCE'

        UPDATE TH_ENG_RESOURCE
        SET    TH_ENG_RESOURCE.BATCH_TYPE = 'BATCH'
             , TH_ENG_RESOURCE.BATCH_RES_GROUP_ID = A.RESOURCE_ID
        FROM   TH_ENG_RESOURCE A,
               TH_MST_BATCH_INFO B
        WHERE  A.MASTER_ID    = @v_master_id
        AND    A.PLAN_ID      = @v_plan_id
        AND    A.MASTER_ID    = B.MASTER_ID
        AND    A.PLAN_ID      = B.PLAN_ID
        AND    A.RESOURCE_ID  = B.BATCH_RES_GROUP_ID
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END
      
      BEGIN

        SET @v_table_name = 'TH_ENG_BATCH_INFO'

        INSERT INTO TH_ENG_BATCH_INFO
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.BATCH_RES_GROUP_ID
             , B.BATCH_GROUP AS BATCH_GROUP_ID
             , B.NEW_ITEM_ID AS ITEM_ID
             , MAX(MAX_BATCH_QTY) OVER (PARTITION BY B.BATCH_GROUP) AS MAX_BATCH_QTY
             , A.BATCH_TIME
             , A.BATCH_TIME_UOM
             , A.PREFER_RATIO
             , A.WAIT_TOLERANCE_TIME
             , A.WAIT_TOLERANCE_TIME_UOM
             , A.SITE_ID AS DESCR
        FROM    TH_MST_BATCH_INFO A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID                  
                ) B,
                TH_ENG_RESOURCE C
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.ITEM_ID = B.ITEM_ID
        AND     A.SITE_ID = B.SITE_ID     -- DESCR 에 SITE_ID 정보 추가함.
        AND     B.SITE_ID +'::'+ A.BATCH_GROUP_ID = B.BATCH_GROUP
        AND     A.MAX_BATCH_QTY > 0
        AND     A.MASTER_ID = C.MASTER_ID
        AND     A.PLAN_ID = C.PLAN_ID
        AND     A.BATCH_RES_GROUP_ID = C.BATCH_RES_GROUP_ID
        --AND     B.SITE_ID = C.SITE_ID

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE  FROM A
        FROM    TH_ENG_BATCH_INFO A,
                (
                  SELECT ITEM_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, BATCH_GROUP, NEW_ITEM_ID                  
                ) B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.ITEM_ID = B.ITEM_ID
      
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_SETUP_MATRIX'

        INSERT INTO TH_ENG_SETUP_MATRIX
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.RESOURCE_SETUP_GROUP_ID
             , B.BATCH_GROUP_ID AS FROM_SETUP_GROUP_ID
             , C.BATCH_GROUP_ID AS TO_SETUP_GROUP_ID
             , MAX(A.SETUP_TIME) AS SETUP_TIME
             , A.SETUP_TIME_UOM
             , MAX(A.FIRST_SETUP_TIME) AS FIRST_SETUP_TIME
             , A.FIRST_SETUP_TIME_UOM
             , MAX(A.DESCR) AS DESCR
        FROM   TH_ENG_SETUP_MATRIX A,
               TH_BUF_SCM_BATCH_SETUP B,
               TH_BUF_SCM_BATCH_SETUP C
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.FROM_SETUP_GROUP_ID = B.SETUP_GROUP_ID
        AND    A.MASTER_ID = C.MASTER_ID
        AND    A.PLAN_ID = C.PLAN_ID
        AND    A.TO_SETUP_GROUP_ID = C.SETUP_GROUP_ID
        GROUP  BY 
               A.MASTER_ID
             , A.PLAN_ID
             , A.RESOURCE_SETUP_GROUP_ID
             , B.BATCH_GROUP_ID 
             , C.BATCH_GROUP_ID 
             , A.SETUP_TIME_UOM
             , A.FIRST_SETUP_TIME_UOM
        
      
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        /*
        INSERT INTO TH_ENG_SETUP_MATRIX
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.RESOURCE_SETUP_GROUP_ID
             , 'ALL'      AS FROM_SETUP_GROUP_ID
             , 'ALL'      AS TO_SETUP_GROUP_ID
             , 30         AS SETUP_TIME
             , 'MINUTE'   AS SETUP_TIME_UOM
             , NULL       AS FIRST_SETUP_TIME
             , 'MINUTE'   AS FIRST_SETUP_TIME_UOM
             , 'TEST'     AS DESCR        
        FROM   TH_ENG_SETUP_MATRIX A,
               TH_BUF_SCM_BATCH_SETUP B,
               TH_BUF_SCM_BATCH_SETUP C
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.FROM_SETUP_GROUP_ID = B.SETUP_GROUP_ID
        AND    A.MASTER_ID = C.MASTER_ID
        AND    A.PLAN_ID = C.PLAN_ID
        AND    A.TO_SETUP_GROUP_ID = C.SETUP_GROUP_ID


        DELETE FROM A
        FROM   TH_ENG_SETUP_MATRIX A,
               TH_BUF_SCM_BATCH_SETUP B,
               TH_BUF_SCM_BATCH_SETUP C
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.FROM_SETUP_GROUP_ID = B.SETUP_GROUP_ID
        AND    A.MASTER_ID = C.MASTER_ID
        AND    A.PLAN_ID = C.PLAN_ID
        AND    A.TO_SETUP_GROUP_ID = C.SETUP_GROUP_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
        */



      END

      ------------------------------------------------------------------------------------------------------
      -- BATCH 설정 부분이 들어가야 한다...
      ------------------------------------------------------------------------------------------------------

      BEGIN
      
        SET @v_table_name = 'TH_ENG_ITEM'

        INSERT INTO TH_ENG_ITEM
                (
                  MASTER_ID
                , PLAN_ID
                , ITEM_ID
                , ITEM_TYPE
                , ITEM_UOM
                , FLOW_ID
                , ITEM_GROUP_ID
                , SETUP_GROUP_ID
                , IS_FINITE
                , FINITE_TERM
                , FINITE_TERM_UOM
                , SAFETY_STOCK_QTY
                , MAX_STOCK_QTY
                , MIN_SAFETY_TERM
                , MIN_SAFETY_TERM_UOM
                , BUFFER_TIME
                , BUFFER_TIME_UOM
                , MIN_LOT_SIZE
                , MAX_LOT_SIZE
                , INCREMENT_LOT_SIZE
                , ATTRIBUTE_SET_ID
                , DESCR
                , ITEM_UOM_RATE
                )
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.ITEM_TYPE
                , A.ITEM_UOM
                , A.FLOW_ID
                , A.ITEM_GROUP_ID
                , B.BATCH_GROUP AS SETUP_GROUP_ID
                , A.IS_FINITE
                , A.FINITE_TERM
                , A.FINITE_TERM_UOM
                , A.SAFETY_STOCK_QTY
                , A.MAX_STOCK_QTY
                , A.MIN_SAFETY_TERM
                , A.MIN_SAFETY_TERM_UOM
                , A.BUFFER_TIME
                , A.BUFFER_TIME_UOM
                , A.MIN_LOT_SIZE
                , A.MAX_LOT_SIZE
                , A.INCREMENT_LOT_SIZE
                , A.ATTRIBUTE_SET_ID
                , A.DESCR
                , A.ITEM_UOM_RATE
        FROM    TH_ENG_ITEM A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.ITEM_ID = B.ITEM_ID
   
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        DELETE  FROM A
        FROM    TH_ENG_ITEM A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.ITEM_ID = B.ITEM_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_ITEM_CAL'

        INSERT INTO TH_ENG_ITEM_CAL
                (
                  MASTER_ID
                , PLAN_ID
                , ITEM_ID
                , START_DTTM
                , END_DTTM
                , IS_USE
                , DESCR
                )
        SELECT    
                  A.MASTER_ID
                , A.PLAN_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.START_DTTM
                , A.END_DTTM
                , A.IS_USE
                , A.DESCR
        FROM    TH_ENG_ITEM_CAL A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.ITEM_ID = B.ITEM_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        DELETE  FROM A
        FROM    TH_ENG_ITEM_CAL A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.ITEM_ID = B.ITEM_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END
      
      BEGIN
      
        SET @v_table_name = 'TH_ENG_PLAN_BOM'

        INSERT INTO TH_ENG_PLAN_BOM
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , B.NEW_PARENT_ITEM_ID AS PARENT_ITEM_ID
                , B.NEW_CHILD_ITEM_ID  AS CHILD_ITEM_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , A.BINNING_ID
                , 'Y' PRODUCTION_FLAG
                , A.BOM_VERSION_ID
                , A.PARENT_ITEM_RATE
                , A.CHILD_ITEM_RATE
                , A.ALT_ID
                , A.ALT_PRIORITY
                , A.ALT_RATE
                , A.IN_MOVE_TIME
                , A.OUT_MOVE_TIME
                , A.MOVE_TIME_UOM
                , A.DESCR
        FROM   TH_ENG_PLAN_BOM A,
               TH_BUF_SCM_BATCH_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
        AND    A.CHILD_ITEM_ID = B.CHILD_ITEM_ID
        AND    A.SITE_ID = B.SITE_ID


        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        DELETE FROM A        
        FROM   TH_ENG_PLAN_BOM A,
               TH_BUF_SCM_BATCH_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
        AND    A.CHILD_ITEM_ID = B.CHILD_ITEM_ID
        --AND    A.SITE_ID = B.SITE_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
      
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_PLAN_BOM_CAL'

        INSERT INTO TH_ENG_PLAN_BOM_CAL
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , B.NEW_PARENT_ITEM_ID AS PARENT_ITEM_ID
                , B.NEW_CHILD_ITEM_ID  AS CHILD_ITEM_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , A.BINNING_ID
                , A.PRODUCTION_FLAG
                , A.START_DTTM
                , A.END_DTTM
                , A.BOM_VERSION_ID
                , A.PARENT_ITEM_RATE
                , A.CHILD_ITEM_RATE
                , A.ALT_ID
                , A.ALT_PRIORITY
                , A.ALT_RATE
                , A.IN_MOVE_TIME
                , A.OUT_MOVE_TIME
                , A.MOVE_TIME_UOM
                , A.IS_USE
                , A.DESCR        
        FROM   TH_ENG_PLAN_BOM_CAL A,
               TH_BUF_SCM_BATCH_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
        AND    A.CHILD_ITEM_ID = B.CHILD_ITEM_ID
        --AND    A.SITE_ID = B.SITE_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        DELETE FROM A        
        FROM   TH_ENG_PLAN_BOM_CAL A,
               TH_BUF_SCM_BATCH_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
        AND    A.CHILD_ITEM_ID = B.CHILD_ITEM_ID
        --AND    A.SITE_ID = B.SITE_ID
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
      
      END

      BEGIN
        
        SET @v_table_name = 'TH_ENG_ITEM_ROUTE_SITE'

        INSERT INTO TH_ENG_ITEM_ROUTE_SITE        
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.ROUTE_LEVEL
                , A.OPERATION_ID
                , A.OPERATION_SEQ
                , A.FLOW_ID
                , A.MIN_TAT
                , A.AVG_TAT
                , A.MAX_TAT
                , A.TAT_UOM
                , A.YIELD
                , CASE WHEN A.OPERATION_ID = 'E0500' THEN CEILING(C.MAX_BATCH_QTY) ELSE MIN_LOT_SIZE END MIN_LOT_SIZE
                , A.MAX_LOT_SIZE
                , CASE WHEN A.OPERATION_ID = 'E0500' THEN CEILING(C.MAX_BATCH_QTY) ELSE INCREMENT_LOT_SIZE END INCREMENT_LOT_SIZE
                , A.IN_MOVING_LOT_SIZE
                , A.OUT_MOVING_LOT_SIZE
                , A.IN_MOVE_TIME
                , A.OUT_MOVE_TIME
                , A.MOVE_TIME_UOM
                , A.EARLY_PRODUCING_TERM
                , A.EARLY_PRODUCING_TERM_UOM
                , 'BATCH' AS OPERATION_TYPE
                , A.BUFFER_TIME
                , A.BUFFER_TIME_UOM
                , A.DESCR
                , NULL AS TRANSFER_BATCH_SIZE        
        FROM   TH_ENG_ITEM_ROUTE_SITE A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B,
                TH_MST_BATCH_INFO C
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.MASTER_ID = C.MASTER_ID
        AND    A.PLAN_ID = C.PLAN_ID
        AND    A.ITEM_ID = C.ITEM_ID
        AND    A.SITE_ID = C.SITE_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
        DELETE FROM A        
        FROM   TH_ENG_ITEM_ROUTE_SITE A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        --AND    A.SITE_ID = B.SITE_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_OP_RES_GROUP'

        INSERT INTO TH_ENG_OP_RES_GROUP
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.RESOURCE_MAP_ID
                , A.RESOURCE_MAP_LEVEL
                , A.MIN_TACT_TIME
                , A.AVG_TACT_TIME
                , A.MAX_TACT_TIME
                , A.TACT_TIME_UOM
                , A.YIELD
                , A.RESOURCE_SELECTOR_ID
                , A.DESCR        
        FROM   TH_ENG_OP_RES_GROUP A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_OP_RES_GROUP A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        --AND    A.SITE_ID = B.SITE_ID

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END

      ------------------------------------------ 여기서 부터 작업 시작 ------------------------------------
      
      BEGIN
      
        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP'

        INSERT INTO TH_ENG_OP_RES_GROUP_MAP
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.RESOURCE_MAP_ID
                , A.RESOURCE_GROUP_ID
                , A.SUB_RESOURCE_MAP_ID
                , A.RESOURCE_MAP_LEVEL
                , A.ALT_PRIORITY
                , A.TACT_TIME
                , A.TACT_TIME_UOM
                , A.YIELD
                , A.IS_FIRST_SETUP
                , A.GOOD_RATE
                , 1 AS BATCH_RATE
                , A.DESCR
                , A.CONSUME_RES_RATE
                , A.PREPARE_TIME
                , A.PREPARE_TIME_UOM        
        FROM   TH_ENG_OP_RES_GROUP_MAP A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_OP_RES_GROUP_MAP A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        --AND    A.SITE_ID = B.SITE_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_CAL'

        INSERT INTO TH_ENG_OP_RES_GROUP_CAL        
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.RESOURCE_MAP_ID
                , A.START_DTTM
                , A.END_DTTM
                , A.YIELD
                , A.RESOURCE_SELECTOR_ID
                , A.IS_USE
                , A.DESCR
        FROM   TH_ENG_OP_RES_GROUP_CAL A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_OP_RES_GROUP_CAL A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        --AND    A.SITE_ID = B.SITE_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END

      -- BATCH 설비는 CAL 이 들어가면 안됨.
      BEGIN

        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP_CAL'

        DELETE FROM A
        FROM   TH_ENG_OP_RES_GROUP_MAP_CAL A,
               TH_ENG_RESOURCE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.RESOURCE_GROUP_ID = B.RESOURCE_GROUP_ID
        AND    B.BATCH_TYPE = 'BATCH'

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END
      /*
      BEGIN
      
        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP_CAL'

        INSERT INTO TH_ENG_OP_RES_GROUP_MAP_CAL  
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.RESOURCE_MAP_ID
                , A.RESOURCE_GROUP_ID
                , A.START_DTTM
                , A.END_DTTM
                , A.SUB_RESOURCE_MAP_ID
                , A.RESOURCE_MAP_LEVEL
                , A.ALT_PRIORITY
                , A.TACT_TIME
                , A.TACT_TIME_UOM
                , A.YIELD
                , A.GOOD_RATE
                , 1 AS BATCH_RATE
                , A.IS_USE
                , A.DESCR
                , A.CONSUME_RES_RATE
                , A.PREPARE_TIME
                , A.PREPARE_TIME_UOM        
        FROM   TH_ENG_OP_RES_GROUP_MAP_CAL A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_OP_RES_GROUP_MAP_CAL A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        --AND    A.SITE_ID = B.SITE_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END
      */

      BEGIN
      
        SET @v_table_name = 'TH_ENG_PRODUCT_MIX_MAP'

        INSERT INTO TH_ENG_PRODUCT_MIX_MAP
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , A.PRODUCT_MIX_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.DESCR
        FROM   TH_ENG_PRODUCT_MIX_MAP A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_PRODUCT_MIX_MAP A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_SALES_PRODUCT_MAP'

        INSERT INTO TH_ENG_SALES_PRODUCT_MAP          
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.SALES_MODEL_ID
                , B.NEW_ITEM_ID AS PRODUCT_ITEM_ID
                , A.SITE_ID
                , A.ALT_PRIORITY
                , A.ALT_RATE
                , A.DESCR        
        FROM   TH_ENG_SALES_PRODUCT_MAP A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.PRODUCT_ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_SALES_PRODUCT_MAP A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.PRODUCT_ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_SALES_PRODUCT_MAP_CAL'

        INSERT INTO TH_ENG_SALES_PRODUCT_MAP_CAL  
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.SALES_MODEL_ID
                , B.NEW_ITEM_ID AS PRODUCT_ITEM_ID
                , A.SITE_ID
                , A.START_DTTM
                , A.END_DTTM
                , A.ALT_PRIORITY
                , A.ALT_RATE
                , A.IS_USE
                , A.DESCR        
        FROM   TH_ENG_SALES_PRODUCT_MAP_CAL A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.PRODUCT_ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_SALES_PRODUCT_MAP_CAL A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.PRODUCT_ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END
      
      BEGIN

        SET @v_table_name = 'TH_ENG_ITEM_BOD'

        INSERT INTO TH_ENG_ITEM_BOD
        SELECT DISTINCT
               A.MASTER_ID
              ,A.PLAN_ID
              ,A.BOD_ID
              ,C.NEW_CHILD_ITEM_ID
              ,A.ALT_PRIORITY
              ,A.ALT_RATE
              ,A.TRANSFER_LOT_SIZE
              ,A.IS_PREV_LOT_SIZE
              ,A.IS_PULL
              ,A.PRE_BUFFER_TIME
              ,A.POST_BUFFER_TIME
              ,A.BUFFER_TIME_UOM
              ,A.ROUTE_SELECTOR_ID
              ,A.ATTRIBUTE_SET_ID
              ,A.MIN_LOT_SIZE
              ,A.MAX_LOT_SIZE
              ,A.INCREMENT_LOT_SIZE
              ,A.SAFETY_STOCK_TERM
              ,A.SAFETY_STOCK_TERM_UOM
              ,A.SAFETY_STOCK_QTY
              ,A.DESCR
              ,A.FROM_OFFTIME_SET_ID
              ,A.TO_OFFTIME_SET_ID
              ,A.EARLY_PRODUCING_TERM
              ,A.EARLY_PRODUCING_TERM_UOM
              ,A.PROD_PRIORITY
        FROM   TH_ENG_ITEM_BOD A,
               TH_ENG_BOD B,
               TH_BUF_SCM_BATCH_SITE C
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.BOD_ID = B.BOD_ID
        AND    A.MASTER_ID = C.MASTER_ID
        AND    A.PLAN_ID = C.PLAN_ID
        AND    A.ITEM_ID = C.CHILD_ITEM_ID
        AND    B.FROM_SITE_ID = C.CHILD_BATCH_SITE
        AND    B.TO_SITE_ID = C.PARENT_BATCH_SITE
        

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        DELETE FROM A
        FROM   TH_ENG_ITEM_BOD A,
               TH_ENG_BOD B,
               TH_BUF_SCM_BATCH_SITE C
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.BOD_ID = B.BOD_ID
        AND    A.MASTER_ID = C.MASTER_ID
        AND    A.PLAN_ID = C.PLAN_ID
        AND    A.ITEM_ID = C.CHILD_ITEM_ID
        AND    B.FROM_SITE_ID = C.CHILD_BATCH_SITE
        AND    B.TO_SITE_ID = C.PARENT_BATCH_SITE

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null


      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_FIXED_PLAN'
        
        UPDATE TH_ENG_FIXED_PLAN
        SET    TH_ENG_FIXED_PLAN.ITEM_ID = B.NEW_ITEM_ID
        FROM   TH_ENG_FIXED_PLAN A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        /*
        DELETE FROM A        
        FROM   TH_ENG_FIXED_PLAN A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
        */
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_STOCK_PLAN'

        INSERT INTO TH_ENG_STOCK_PLAN  
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , 1000000 + A.STOCK_SEQ AS STOCK_SEQ
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , A.RECEIVING_DTTM
                , A.QTY
                , A.LOT_ID
                , A.WORK_ORDER_ID
                , A.DEMAND_ID
                , A.STOCK_STATUS
                , A.ATTRIBUTE_SET_ID
                , A.DESCR
        FROM   TH_ENG_STOCK_PLAN A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_STOCK_PLAN A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_WIP'

        INSERT INTO TH_ENG_WIP  
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , 1000000 + A.WIP_SEQ AS WIP_SEQ
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.ROUTE_ID
                , A.SITE_ID
                , A.OPERATION_ID
                , A.RESOURCE_ID
                , A.SUB_RESOURCE_ID
                , A.START_DTTM
                , A.END_DTTM
                , A.QTY
                , A.WORK_ORDER_ID
                , A.DEMAND_ID
                , A.LOT_ID
                , A.ATTRIBUTE_SET_ID
                , A.WIP_STATUS
                , A.RELEASE_DTTM
                , A.DESCR                                
        FROM   TH_ENG_WIP A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_WIP A,
                (
                  SELECT ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                  FROM   (
                          SELECT PARENT_ITEM_ID AS ITEM_ID
                               , PARENT_BATCH_SITE AS SITE_ID
                               , PARENT_BATCH_GROUP AS BATCH_GROUP
                               , NEW_PARENT_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    PARENT_BATCH_SITE IS NOT NULL
                          UNION  ALL
                          SELECT CHILD_ITEM_ID AS ITEM_ID
                               , CHILD_BATCH_SITE AS SITE_ID
                               , CHILD_BATCH_GROUP AS BATCH_GROUP
                               , NEW_CHILD_ITEM_ID AS NEW_ITEM_ID
                          FROM   TH_BUF_SCM_BATCH_SITE
                          WHERE  MASTER_ID = @v_master_id
                          AND    PLAN_ID = @v_plan_id
                          AND    CHILD_BATCH_SITE IS NOT NULL
                         ) A
                  GROUP  BY ITEM_ID, SITE_ID, BATCH_GROUP, NEW_ITEM_ID
                ) B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END

      /*
      -- BOD 가 BOM 보다 먼저 실행되어야 한다. BOM 은 등록 후 기존 데이터를 삭제하기 때문에      
      BEGIN
      
        SET @v_table_name = 'TH_ENG_BOD'

        INSERT INTO TH_ENG_BOD
              (
               MASTER_ID
              ,PLAN_ID
              ,BOD_ID
              ,FROM_SITE_ID
              ,TO_SITE_ID
              ,TRANSPORT_TIME
              ,TRANSPORT_TIME_UOM
              ,TRANSPORT_MODE
              ,BOD_START_DTTM
              ,BOD_PATTERN_ID
              ,FIXED_TERM
              ,FIXED_TERM_UOM
              )              
        SELECT DISTINCT
               A.MASTER_ID
              ,A.PLAN_ID
              ,B.SITE_ID +'_'+ B.NEW_SITE_ID AS BOD_ID
              ,B.SITE_ID    AS FROM_SITE_ID
              ,B.NEW_SITE_ID AS TO_SITE_ID
              ,0 AS TRANSPORT_TIME
              ,'MINUTE' AS TRANSPORT_TIME_UOM
              ,'-' AS TRANSPORT_MODE
              ,@plan_start_time AS BOD_START_DTTM
              ,'DX' AS BOD_PATTERN_ID
              ,0 AS FIXED_TERM
              ,'DAY' AS FIXED_TERM_UOM
        FROM   TH_ENG_PLAN_BOM A,
               SY_FP_BUF_SCM_LANE_SITE B,
               TH_ENG_ITEM C
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PARENT_ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        AND    A.MASTER_ID = C.MASTER_ID
        AND    A.PLAN_ID = C.PLAN_ID
        AND    A.CHILD_ITEM_ID = C.ITEM_ID
        AND    C.ITEM_TYPE = 'H'
        UNION  ALL
        SELECT DISTINCT   -- 전극 후 공정 관련 부분
               A.MASTER_ID
              ,A.PLAN_ID
              ,C.NEW_SITE_ID +'_'+ B.SITE_ID AS BOD_ID
              ,C.NEW_SITE_ID AS FROM_SITE_ID
              ,B.SITE_ID AS TO_SITE_ID
              ,0 AS TRANSPORT_TIME
              ,'MINUTE' AS TRANSPORT_TIME_UOM
              ,'-' AS TRANSPORT_MODE
              ,@plan_start_time AS BOD_START_DTTM
              ,'DX' AS BOD_PATTERN_ID
              ,0 AS FIXED_TERM
              ,'DAY' AS FIXED_TERM_UOM
        FROM   TH_ENG_PLAN_BOM A,
               TH_ENG_PLAN_BOM B,
               SY_FP_BUF_SCM_LANE_SITE C
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.CHILD_ITEM_ID = B.PARENT_ITEM_ID
        AND    1=1
        AND    B.MASTER_ID = C.MASTER_ID
        AND    B.PLAN_ID = C.PLAN_ID
        AND    B.PARENT_ITEM_ID = C.ITEM_ID
        AND    B.SITE_ID = C.SITE_ID
        AND    B.ROUTE_ID = C.ROUTE_ID
        AND    B.OPERATION_ID = C.OPERATION_ID


        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END
      
      BEGIN
      
        SET @v_table_name = 'TH_ENG_ITEM_BOD'

        INSERT INTO TH_ENG_ITEM_BOD
              (
               MASTER_ID
              ,PLAN_ID
              ,BOD_ID
              ,ITEM_ID
              )              
        SELECT DISTINCT     -- 전극 전 공정 관련 부분
               A.MASTER_ID
              ,A.PLAN_ID
              ,B.SITE_ID +'_'+ B.NEW_SITE_ID AS BOD_ID
              ,A.CHILD_ITEM_ID AS ITEM_ID 
        FROM   TH_ENG_PLAN_BOM A,
               SY_FP_BUF_SCM_LANE_SITE B,
               TH_ENG_ITEM C
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PARENT_ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        AND    A.MASTER_ID = C.MASTER_ID
        AND    A.PLAN_ID = C.PLAN_ID
        AND    A.CHILD_ITEM_ID = C.ITEM_ID
        AND    C.ITEM_TYPE = 'H'
        UNION  ALL
        SELECT DISTINCT   -- 전극 후 공정 관련 부분
               A.MASTER_ID
              ,A.PLAN_ID
              ,C.NEW_SITE_ID +'_'+ B.SITE_ID AS BOD_ID
              ,A.CHILD_ITEM_ID
        FROM   TH_ENG_PLAN_BOM A,
               TH_ENG_PLAN_BOM B,
               SY_FP_BUF_SCM_LANE_SITE C
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.CHILD_ITEM_ID = B.PARENT_ITEM_ID
        AND    1=1
        AND    B.MASTER_ID = C.MASTER_ID
        AND    B.PLAN_ID = C.PLAN_ID
        AND    B.PARENT_ITEM_ID = C.ITEM_ID
        AND    B.SITE_ID = C.SITE_ID
        AND    B.ROUTE_ID = C.ROUTE_ID
        AND    B.OPERATION_ID = C.OPERATION_ID
        

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      */
      
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
