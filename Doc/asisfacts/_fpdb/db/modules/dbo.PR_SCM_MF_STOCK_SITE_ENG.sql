CREATE PROCEDURE [dbo].[PR_SCM_MF_STOCK_SITE_ENG]  
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MF_STOCK_SITE_ENG                                                  **/
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
  EXEC PR_SCM_MF_STOCK_SITE_ENG
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  DECLARE
    @v_proc_name        nvarchar(150) = 'PR_SCM_MF_STOCK_SITE_ENG', 
    @v_table_name       nvarchar(150) = NULL, 
    @v_master_id        nvarchar(150) = @p_master_id, 
    @v_plan_id          nvarchar(150) = @p_plan_id
    
  DECLARE
    @n_count            Integer  = 0,
    @n_log_count        Integer  = 0,
    @sysdate            DATETIME2 = GETDATE(),
    @v_message          nvarchar(200),
    @v_description      nvarchar(200)

  DECLARE
    @v_check            Integer  = 0,
    @v_ref_instance_id  nvarchar(150) = NULL

    
  BEGIN TRY
    --LOG 생성
    SET @n_log_count = @n_log_count + 1
    SET @sysdate = GETDATE()
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, '###############', 'START', @n_log_count, null, '############### Start of procedure ###############', null


    BEGIN

      SET @v_table_name = 'TH_ENG_ITEM'

      BEGIN
      
        DELETE FROM TH_ENG_ITEM
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id
        AND    ITEM_ID LIKE '%STOCK%'

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description

        INSERT INTO TH_ENG_ITEM
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.ITEM_ID +'_'+ B.STOCK_SITE_ID +'_'+ 'STOCK' AS ITEM_ID
             , A.ITEM_TYPE
             , A.ITEM_UOM
             , A.FLOW_ID
             , NULL   AS ITEM_GROUP_ID
             , NULL   AS SETUP_GROUP_ID
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
        FROM   TH_ENG_ITEM A,
               (
                SELECT A.*,
                       CASE WHEN R = 1 THEN A.SITE_ID
                            WHEN R = 2 THEN (CASE WHEN CHARINDEX('^', A.SITE_ID) = 0 THEN A.SITE_ID
                                                  ELSE SUBSTRING(A.SITE_ID, 1, CHARINDEX('^', A.SITE_ID)-1)
                                             END )
                            WHEN R = 3 THEN 'ALL'
                       END  AS STOCK_SITE_ID,
                       R AS STOCK_PRIORITY
                FROM   TH_ENG_PLAN_BOM A,
                       ( SELECT 1 R UNION ALL     -- FACTORY, LINE 이 존재할때
                         SELECT 2 R UNION ALL     -- FACTORY 만 존재할때
                         SELECT 3 R               -- 아무것도 존재하지 않을 때
                       ) B
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    EXISTS (
                                SELECT 1
                                FROM   TH_ENG_STOCK_PLAN B
                                WHERE  A.MASTER_ID      = B.MASTER_ID
                                AND    A.PLAN_ID        = B.PLAN_ID
                                AND    A.CHILD_ITEM_ID  = B.ITEM_ID
                              )
                /*
                -- 동, 라인 정보 다 있는 경우
                SELECT A.*, B.SITE_ID AS STOCK_SITE_ID, 1 AS STOCK_PRIORITY
                FROM   TH_ENG_PLAN_BOM    A,
                       TH_ENG_STOCK_PLAN  B
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    A.MASTER_ID      = B.MASTER_ID
                AND    A.PLAN_ID        = B.PLAN_ID
                AND    A.CHILD_ITEM_ID  = B.ITEM_ID
                AND    A.SITE_ID        = B.SITE_ID
                AND    A.ROUTE_ID       = B.ROUTE_ID
                AND    ISNULL(B.SITE_ID, '-')      != '-'
                AND    ISNULL(B.ROUTE_ID, '-')     != '-'
                AND    ISNULL(B.OPERATION_ID, '-') != '-'
                UNION  ALL
                -- 동 정보만 있는 경우
                SELECT A.*, B.SITE_ID AS STOCK_SITE_ID, 2 AS STOCK_PRIORITY
                FROM   TH_ENG_PLAN_BOM    A,
                       TH_ENG_STOCK_PLAN  B
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    A.MASTER_ID      = B.MASTER_ID
                AND    A.PLAN_ID        = B.PLAN_ID
                AND    A.CHILD_ITEM_ID  = B.ITEM_ID
                AND    A.SITE_ID        LIKE B.SITE_ID +'%'
                AND    ISNULL(B.SITE_ID, '-')      != '-'
                AND    ISNULL(B.ROUTE_ID, '-')      = '-'
                AND    ISNULL(B.OPERATION_ID, '-') != '-'
                UNION  ALL
                -- 라인, 동 정보가 없는 경우
                SELECT A.*, 'ALL' AS STOCK_SITE_ID, 3 AS STOCK_PRIORITY
                FROM   TH_ENG_PLAN_BOM    A,
                       TH_ENG_STOCK_PLAN  B
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    A.MASTER_ID      = B.MASTER_ID
                AND    A.PLAN_ID        = B.PLAN_ID
                AND    A.CHILD_ITEM_ID  = B.ITEM_ID
                AND    ISNULL(B.SITE_ID, '-')       = '-'
                AND    ISNULL(B.ROUTE_ID, '-')      = '-'
                AND    ISNULL(B.OPERATION_ID, '-') != '-'
                */
               ) B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.ITEM_ID        = B.CHILD_ITEM_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
      
      END
      
      SET @v_table_name = 'TH_ENG_PLAN_BOM'

      BEGIN

        DELETE FROM TH_ENG_PLAN_BOM
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id
        AND    CHILD_ITEM_ID LIKE '%STOCK%'
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description

        UPDATE TH_ENG_PLAN_BOM
        SET    TH_ENG_PLAN_BOM.ALT_ID       = (CASE WHEN A.ALT_ID IS NULL THEN A.PARENT_ITEM_ID + '_' + A.CHILD_ITEM_ID +'_ALT_STOCK' ELSE A.ALT_ID END)
             , TH_ENG_PLAN_BOM.ALT_PRIORITY = (CASE WHEN A.ALT_PRIORITY IS NULL THEN 4 ELSE A.ALT_PRIORITY + 3 END)
             , TH_ENG_PLAN_BOM.ALT_RATE     = (CASE WHEN A.ALT_RATE IS NULL THEN 1 ELSE A.ALT_RATE END)
        FROM   TH_ENG_PLAN_BOM    A
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    EXISTS (
                        SELECT 1
                        FROM   (
                                SELECT A.MASTER_ID, A.PLAN_ID, A.PARENT_ITEM_ID, 
                                       ISNULL(A.ALT_ID, 'NULL') AS ALT_ID
                                FROM   TH_ENG_PLAN_BOM    A,
                                       TH_ENG_STOCK_PLAN  B
                                WHERE  A.MASTER_ID      = @v_master_id
                                AND    A.PLAN_ID        = @v_plan_id
                                AND    A.MASTER_ID      = B.MASTER_ID
                                AND    A.PLAN_ID        = B.PLAN_ID
                                AND    A.CHILD_ITEM_ID  = B.ITEM_ID
                                AND    ISNULL(B.OPERATION_ID, '-') != '-'
                               ) X
                        WHERE  X.MASTER_ID      = A.MASTER_ID
                        AND    X.PLAN_ID        = A.PLAN_ID
                        AND    X.PARENT_ITEM_ID = A.PARENT_ITEM_ID
                        AND    X.ALT_ID         = ISNULL(A.ALT_ID, 'NULL')
                      )

        /*
        UPDATE TH_ENG_PLAN_BOM
        SET    TH_ENG_PLAN_BOM.ALT_ID       = (CASE WHEN A.ALT_ID IS NULL THEN A.PARENT_ITEM_ID + '_' + A.CHILD_ITEM_ID + '_' + A.SITE_ID +'_ALT_STOCK' ELSE A.ALT_ID END)
             , TH_ENG_PLAN_BOM.ALT_PRIORITY = (CASE WHEN A.ALT_PRIORITY IS NULL THEN 4 ELSE A.ALT_PRIORITY + 3 END)
             , TH_ENG_PLAN_BOM.ALT_RATE     = (CASE WHEN A.ALT_RATE IS NULL THEN 1 ELSE A.ALT_RATE END)
        FROM   TH_ENG_PLAN_BOM    A,
               TH_ENG_STOCK_PLAN  B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.CHILD_ITEM_ID  = B.ITEM_ID
        --AND    A.SITE_ID        LIKE B.SITE_ID +'%'
        --AND    ISNULL(B.ROUTE_ID, '-') = '-'
        AND    ISNULL(B.OPERATION_ID, '-') != '-'
        */

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

        INSERT INTO TH_ENG_PLAN_BOM
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.PARENT_ITEM_ID
             , A.CHILD_ITEM_ID +'_'+ A.STOCK_SITE_ID +'_'+ 'STOCK' AS CHILD_ITEM_ID
             , A.SITE_ID
             , A.ROUTE_ID
             , A.OPERATION_ID
             , A.BINNING_ID
             , A.PRODUCTION_FLAG
             , A.BOM_VERSION_ID
             , A.PARENT_ITEM_RATE
             , A.CHILD_ITEM_RATE
             , A.ALT_ID
             , STOCK_PRIORITY AS ALT_PRIORITY
             , A.ALT_RATE
             , A.IN_MOVE_TIME
             , A.OUT_MOVE_TIME
             , A.MOVE_TIME_UOM
             , A.DESCR
        FROM   (
                SELECT A.*,
                       CASE WHEN R = 1 THEN A.SITE_ID
                            WHEN R = 2 THEN (CASE WHEN CHARINDEX('^', A.SITE_ID) = 0 THEN A.SITE_ID
                                                  ELSE SUBSTRING(A.SITE_ID, 1, CHARINDEX('^', A.SITE_ID)-1)
                                             END )
                            WHEN R = 3 THEN 'ALL'
                       END  AS STOCK_SITE_ID,
                       R AS STOCK_PRIORITY
                FROM   TH_ENG_PLAN_BOM A,
                       ( SELECT 1 R UNION ALL     -- FACTORY, LINE 이 존재할때
                         SELECT 2 R UNION ALL     -- FACTORY 만 존재할때
                         SELECT 3 R               -- 아무것도 존재하지 않을 때
                       ) B
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    EXISTS (
                                SELECT 1
                                FROM   TH_ENG_STOCK_PLAN B
                                WHERE  A.MASTER_ID      = B.MASTER_ID
                                AND    A.PLAN_ID        = B.PLAN_ID
                                AND    A.CHILD_ITEM_ID  = B.ITEM_ID
                              )
                /*
                -- 동, 라인 정보 다 있는 경우
                SELECT A.*, B.SITE_ID AS STOCK_SITE_ID, 1 AS STOCK_PRIORITY
                FROM   TH_ENG_PLAN_BOM    A,
                       TH_ENG_STOCK_PLAN  B
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    A.MASTER_ID      = B.MASTER_ID
                AND    A.PLAN_ID        = B.PLAN_ID
                AND    A.CHILD_ITEM_ID  = B.ITEM_ID
                AND    A.SITE_ID        = B.SITE_ID
                AND    A.ROUTE_ID       = B.ROUTE_ID
                AND    ISNULL(B.SITE_ID, '-')      != '-'
                AND    ISNULL(B.ROUTE_ID, '-')     != '-'
                AND    ISNULL(B.OPERATION_ID, '-') != '-'
                UNION  ALL
                -- 동 정보만 있는 경우
                SELECT A.*, B.SITE_ID AS STOCK_SITE_ID, 2 AS STOCK_PRIORITY
                FROM   TH_ENG_PLAN_BOM    A,
                       TH_ENG_STOCK_PLAN  B
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    A.MASTER_ID      = B.MASTER_ID
                AND    A.PLAN_ID        = B.PLAN_ID
                AND    A.CHILD_ITEM_ID  = B.ITEM_ID
                AND    A.SITE_ID        LIKE B.SITE_ID +'%'
                AND    ISNULL(B.SITE_ID, '-')      != '-'
                AND    ISNULL(B.ROUTE_ID, '-')      = '-'
                AND    ISNULL(B.OPERATION_ID, '-') != '-'
                UNION  ALL
                -- 라인, 동 정보가 없는 경우
                SELECT A.*, 'ALL' AS STOCK_SITE_ID, 3 AS STOCK_PRIORITY
                FROM   TH_ENG_PLAN_BOM    A,
                       TH_ENG_STOCK_PLAN  B
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    A.MASTER_ID      = B.MASTER_ID
                AND    A.PLAN_ID        = B.PLAN_ID
                AND    A.CHILD_ITEM_ID  = B.ITEM_ID
                AND    ISNULL(B.SITE_ID, '-')       = '-'
                AND    ISNULL(B.ROUTE_ID, '-')      = '-'
                AND    ISNULL(B.OPERATION_ID, '-') != '-'
                */
               ) A

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
      
      END
    
      SET @v_table_name = 'TH_ENG_STOCK_PLAN'

      BEGIN

        -- 1. SITE_ID 가 없는것 먼저 처리
        UPDATE TH_ENG_STOCK_PLAN
        SET    TH_ENG_STOCK_PLAN.ITEM_ID = A.ITEM_ID +'_'+ 'ALL' +'_'+ 'STOCK'
             , TH_ENG_STOCK_PLAN.SITE_ID = NULL
             , TH_ENG_STOCK_PLAN.ROUTE_ID = NULL
        FROM   TH_ENG_STOCK_PLAN A
        WHERE  A.MASTER_ID                  = @v_master_id
        AND    A.PLAN_ID                    = @v_plan_id
        AND    ISNULL(A.SITE_ID, '-')       = '-'
        AND    ISNULL(A.OPERATION_ID, '-') != '-'

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

        
        -- 2. SITE_ID, ROUTE_ID 가 동일한 것
        UPDATE TH_ENG_STOCK_PLAN
        SET    TH_ENG_STOCK_PLAN.ITEM_ID = A.ITEM_ID +'_'+ B.STOCK_SITE_ID +'_'+ 'STOCK'
             , TH_ENG_STOCK_PLAN.SITE_ID = NULL
             , TH_ENG_STOCK_PLAN.ROUTE_ID = NULL
        FROM   TH_ENG_STOCK_PLAN A,
               (
                SELECT A.*,
                       CASE WHEN R = 1 THEN A.SITE_ID
                            WHEN R = 2 THEN (CASE WHEN CHARINDEX('^', A.SITE_ID) = 0 THEN A.SITE_ID
                                                  ELSE SUBSTRING(A.SITE_ID, 1, CHARINDEX('^', A.SITE_ID)-1)
                                             END )
                            WHEN R = 3 THEN 'ALL'
                       END  AS STOCK_SITE_ID,
                       R AS STOCK_PRIORITY
                FROM   TH_ENG_PLAN_BOM A,
                       ( SELECT 1 R UNION ALL
                         SELECT 2 R UNION ALL
                         SELECT 3 R 
                       ) B
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
               ) B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.CHILD_ITEM_ID
        AND    A.SITE_ID        = B.STOCK_SITE_ID
      
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description


        -- 3. SITE_ID 는 같으나 ROUTE_ID 가 존재하지 않는 것
        UPDATE TH_ENG_STOCK_PLAN
        SET    TH_ENG_STOCK_PLAN.ITEM_ID = A.ITEM_ID +'_'+ B.STOCK_SITE_ID +'_'+ 'STOCK'
             , TH_ENG_STOCK_PLAN.SITE_ID = NULL
             , TH_ENG_STOCK_PLAN.ROUTE_ID = NULL
        FROM   TH_ENG_STOCK_PLAN A,
               (
                SELECT A.*,
                       CASE WHEN R = 1 THEN A.SITE_ID
                            WHEN R = 2 THEN (CASE WHEN CHARINDEX('^', A.SITE_ID) = 0 THEN A.SITE_ID
                                                  ELSE SUBSTRING(A.SITE_ID, 1, CHARINDEX('^', A.SITE_ID)-1)
                                             END )
                            WHEN R = 3 THEN 'ALL'
                       END  AS STOCK_SITE_ID,
                       R AS STOCK_PRIORITY
                FROM   TH_ENG_PLAN_BOM A,
                       ( SELECT 1 R UNION ALL
                         SELECT 2 R UNION ALL
                         SELECT 3 R 
                       ) B
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
               ) B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.CHILD_ITEM_ID
        AND    B.STOCK_SITE_ID  = (
                                    CASE WHEN CHARINDEX('^', A.SITE_ID) = 0 THEN A.SITE_ID
                                         ELSE SUBSTRING(A.SITE_ID, 1, CHARINDEX('^', A.SITE_ID)-1)
                                    END
                                  )
      
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

        /*
        UPDATE TH_ENG_STOCK_PLAN
        SET    TH_ENG_STOCK_PLAN.ITEM_ID = B.ITEM_ID +'_'+ 'ALL' +'_'+ 'STOCK'
             , TH_ENG_STOCK_PLAN.SITE_ID = NULL
             , TH_ENG_STOCK_PLAN.ROUTE_ID = NULL
        FROM   TH_ENG_PLAN_BOM    A,
               TH_ENG_STOCK_PLAN  B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.CHILD_ITEM_ID  = B.ITEM_ID
        AND    ISNULL(B.SITE_ID, '-')       = '-'
        AND    ISNULL(B.ROUTE_ID, '-')      = '-'
        AND    ISNULL(B.OPERATION_ID, '-') != '-'

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

        UPDATE TH_ENG_STOCK_PLAN
        SET    TH_ENG_STOCK_PLAN.ITEM_ID = B.ITEM_ID +'_'+ B.SITE_ID +'_'+ 'STOCK'
             , TH_ENG_STOCK_PLAN.SITE_ID = NULL
             , TH_ENG_STOCK_PLAN.ROUTE_ID = NULL
        FROM   TH_ENG_PLAN_BOM    A,
               TH_ENG_STOCK_PLAN  B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.CHILD_ITEM_ID  = B.ITEM_ID
        AND    A.SITE_ID        LIKE B.SITE_ID +'%'
        AND    ISNULL(B.SITE_ID, '-')      != '-'
        --AND    ISNULL(B.ROUTE_ID, '-')      = '-'
        AND    ISNULL(B.OPERATION_ID, '-') != '-'

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description
        */
        
      END
      
    END

    ----------------------------------------------------------------------------------------------------------------------
    
    BEGIN

      SET @v_table_name = 'TH_ENG_STOCK_PLAN'

      INSERT INTO TH_ENG_STOCK_PLAN
      SELECT DISTINCT
             A.MASTER_ID, A.PLAN_ID, A.STOCK_SEQ, 
             A.ITEM_ID 
                + '_' + 'LANE' + CASE WHEN B.CHILD_LANE_QTY < 10 THEN '0' ELSE '' END 
                               + CONVERT(NVARCHAR, CEILING(B.CHILD_LANE_QTY))
                + '_' + A.SITE_ID
                + '_' + A.OPERATION_ID
                + '_R'
               AS ITEM_ID,
             'VIRTUAL_LANE^VIRTUAL_LANE'  AS SITE_ID,
             'VIRTUAL_LANE'               AS ROUTE_ID,
             'VIRTUAL_LANE'               AS OPERATION_ID,
             A.RECEIVING_DTTM,
             A.QTY,
             A.LOT_ID,
             A.WORK_ORDER_ID,
             NULL DEMAND_ID,
             A.STOCK_STATUS,
             NULL AS ATTRIBUTE_SET_ID,
             A.DESCR
      FROM   TH_MST_STOCK_PLAN A,
             TH_BUF_SCM_LANE_BOM B
      WHERE  A.MASTER_ID    = @v_master_id
      AND    A.PLAN_ID      = @v_plan_id
      AND    A.MASTER_ID    = B.MASTER_ID
      AND    A.PLAN_ID      = B.PLAN_ID
      AND    A.ITEM_ID      = B.CHILD_ITEM_ID
      AND    A.SITE_ID      = B.CHILD_SITE_ID
      AND    A.OPERATION_ID = B.CHILD_OPERATION_ID
      AND    A.STOCK_ATTB_2 = CONVERT(NVARCHAR, CEILING(B.CHILD_LANE_QTY))
      AND    A.STOCK_ATTB_4 = B.MASTER_ID   -- 후공정일때,,,

      --LOG 생성
      SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)  + ' - LANE STOCK ( E_POST )'
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
      
                  
      -- 3/9 전극 후 공정 자재 제약이 안먹도록 조치 
      -- 테스트 이후 삭제할 것
      /*
      SET @v_table_name = 'TH_ENG_STOCK_PLAN'
      
      DELETE TH_ENG_STOCK_PLAN
      WHERE  MASTER_ID = 'KR_E_POST'
      AND    PLAN_ID = @v_plan_id
      AND    ITEM_ID LIKE '%_R'

      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
      */
    END
    
    -----------------------------------------------------------------------------------------------------------------
    -- INSTANCE 간 BOD 연결
    -- 후공정 계획 수립시 전공정 STOCK 정보 투입하기 위함.
    
    DELETE FROM TH_BUF_SCM_INSTANCE_BOD_A WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id
    DELETE FROM TH_BUF_SCM_INSTANCE_BOD_B WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id
    DELETE FROM TH_BUF_SCM_INSTANCE_BOD_C WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id
    
    DELETE FROM TH_BUF_SCM_INSTANCE_BOD_A WHERE INSERT_TIME < DATEADD(DAY, -7, GETDATE())
    DELETE FROM TH_BUF_SCM_INSTANCE_BOD_B WHERE INSERT_TIME < DATEADD(DAY, -7, GETDATE())
    DELETE FROM TH_BUF_SCM_INSTANCE_BOD_C WHERE INSERT_TIME < DATEADD(DAY, -7, GETDATE())

    BEGIN
    
      SELECT @v_check = count(1)
           , @v_ref_instance_id = MAX(INSTANCE_ID)
      FROM   SY_FP_INSTANCE_CONFIG_M
      WHERE  1=1
      AND    CATEGORY_ID = 'RESULT_TRANSFER'
      AND    KEY_ID = 'PRODUCT_TO_STOCK'
      AND    KEY_VALUE = @v_master_id
      
      IF @v_check > 0 AND @v_plan_id = 'KR_E_POST-20170111-00'
        BEGIN

          SET @v_table_name = 'SY_FP_INSTANCE_CONFIG_M'
          
          --LOG 생성
          SET @v_message = 'PRODUCT_TO_STOCK - REF INSTANCE_ID : ' + @v_ref_instance_id
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, @v_description
        
          BEGIN
        
            SET @v_table_name = 'TH_BUF_SCM_INSTANCE_BOD_A'

            INSERT INTO TH_BUF_SCM_INSTANCE_BOD_A
            SELECT A.MASTER_ID, 
                   A.PLAN_ID, 
                   A.ITEM_ID      AS FROM_ITEM_ID, 
                   A.SITE_ID      AS FROM_SITE_ID, 
                   A.OPERATION_ID AS FROM_OPERATION_ID, 
                   B.ITEM_ID,
                   A.LANE_QTY,
                   GETDATE()      AS INSERT_TIME
            FROM   (
                     SELECT MASTER_ID, PLAN_ID, ITEM_ID, SITE_ID, OPERATION_ID, STOCK_ATTB_3, CONVERT(NUMERIC, STOCK_ATTB_2) AS LANE_QTY
                     FROM   TH_MST_STOCK_PLAN
                     WHERE  MASTER_ID = @v_master_id
                     AND    PLAN_ID = @v_plan_id
                     AND    STOCK_STATUS = 'STOCK'
                     GROUP  BY MASTER_ID, PLAN_ID, ITEM_ID, SITE_ID, OPERATION_ID, STOCK_ATTB_3, CONVERT(NUMERIC, STOCK_ATTB_2) 
                   ) A,
                   TH_MST_INSTANCE_FLOW B       
            WHERE  A.STOCK_ATTB_3 = B.PLAN_ID
            AND    A.ITEM_ID = B.ITEM_ID + '_' + B.ERP_OPERATION_ID
            AND    A.SITE_ID =  B.FACTORY_ID
            AND    A.OPERATION_ID = B.OPERATION_ID        

            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

            
            SET @v_table_name = 'TH_BUF_SCM_INSTANCE_BOD_B'

            INSERT INTO TH_BUF_SCM_INSTANCE_BOD_B
            SELECT A.MASTER_ID, 
                   A.PLAN_ID, 
                   A.ITEM_ID      AS TO_ITEM_ID,
                   A.FACTORY_ID   AS TO_SITE_ID,
                   A.OPERATION_ID AS TO_OPERATION_ID,
                   GETDATE()      AS INSERT_TIME
            FROM   (
                    SELECT A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.FACTORY_ID, A.OPERATION_ID, 
                           RANK() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID
                                        ORDER     BY OPERATION_SEQ, OPERATION_ID) SEQ
                    FROM   TH_MST_INSTANCE_FLOW A
                    WHERE  MASTER_ID = @v_master_id
                    AND    PLAN_ID = @v_plan_id
                   ) A
            WHERE  SEQ = 1       
            
            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

          
            SET @v_table_name = 'TH_BUF_SCM_INSTANCE_BOD_C'

            INSERT INTO TH_BUF_SCM_INSTANCE_BOD_C
            SELECT DISTINCT
                   A.*,
                   B.ITEM_ID AS NEW_TO_ITEM_ID,
                   A.FROM_SITE_ID + '^STOCKSITE' AS NEW_FROM_SITE_ID, 
                   B.SITE_ID AS NEW_TO_SITE_ID,
                   A.FROM_SITE_ID +'#'+ A.FROM_OPERATION_ID + '^' + B.SITE_ID + '^STOCKSITE' AS NEW_BOD_ID,
                   GETDATE() AS INSERT_TIME
            FROM   (
                    SELECT DISTINCT
                           A.MASTER_ID,
                           A.PLAN_ID,
                           A.FROM_ITEM_ID,
                           A.FROM_SITE_ID,
                           A.FROM_OPERATION_ID,
                           B.TO_ITEM_ID,
                           B.TO_SITE_ID,
                           B.TO_OPERATION_ID,
                           A.LANE_QTY,
                           C.TRANSPORT_MODE,
                           C.TRANSPORT_TIME,
                           C.TRANSPORT_TIME_UOM,
                           C.BOD_START_DTTM
                    FROM   TH_BUF_SCM_INSTANCE_BOD_A A,
                           TH_BUF_SCM_INSTANCE_BOD_B B,
                           TH_MST_BOD C
                    WHERE  A.MASTER_ID  = @v_master_id
                    AND    A.PLAN_ID    = @v_plan_id
                    AND    A.MASTER_ID  = B.MASTER_ID
                    AND    A.PLAN_ID    = B.PLAN_ID
                    AND    A.ITEM_ID    = B.TO_ITEM_ID
                    AND    C.MASTER_ID    = A.MASTER_ID
                    AND    C.PLAN_ID      = A.PLAN_ID
                    AND    C.FROM_SITE_ID = A.FROM_SITE_ID
                    AND    C.TO_SITE_ID   = B.TO_SITE_ID
                    AND    C.TRANSPORT_MODE = A.FROM_OPERATION_ID + '#' + B.TO_OPERATION_ID
                   ) A,
                   (
                    SELECT DISTINCT
                           A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.SITE_ID, A.OPERATION_ID, B.ITEM_ID AS ORG_ITEM_ID, A.ORG_SITE_ID, B.LANE_QTY
                    FROM   (
                            SELECT A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID,
                                   CASE WHEN CHARINDEX('^', A.SITE_ID) > 0 THEN SUBSTRING(A.SITE_ID, 1, CHARINDEX('^', A.SITE_ID) - 1)
                                        ELSE A.SITE_ID
                                   END  AS ORG_SITE_ID
                            FROM   TH_ENG_ITEM_ROUTE_SITE A
                            WHERE  A.MASTER_ID  = @v_master_id
                            AND    A.PLAN_ID    = @v_plan_id
                           ) A,
                           SY_FP_BUF_SCM_LANE_SITE B
                    WHERE  1=1
                    AND    A.MASTER_ID = B.MASTER_ID
                    AND    A.PLAN_ID = B.PLAN_ID
                    AND    A.ITEM_ID = B.NEW_ITEM_ID
                    AND    A.ORG_SITE_ID = B.SITE_ID
                    AND    A.ROUTE_ID = B.ROUTE_ID
                    AND    A.OPERATION_ID = B.OPERATION_ID                    
                   ) B
            WHERE  A.TO_ITEM_ID = B.ORG_ITEM_ID
            AND    A.TO_SITE_ID = B.ORG_SITE_ID
            AND    A.TO_OPERATION_ID = B.OPERATION_ID

            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

          END

          BEGIN
          
            SET @v_table_name = 'TH_ENG_BOD'
            
            DELETE FROM TH_ENG_BOD
            WHERE  MASTER_ID = @v_master_id
            AND    PLAN_ID = @v_plan_id
            AND    BOD_ID LIKE '%STOCKSITE%'
            
            INSERT INTO TH_ENG_BOD
                 (
                    MASTER_ID
                  , PLAN_ID
                  , BOD_ID
                  , FROM_SITE_ID
                  , TO_SITE_ID
                  , TRANSPORT_MODE
                  , TRANSPORT_TIME
                  , TRANSPORT_TIME_UOM
                  , BOD_START_DTTM
                  , BOD_PATTERN_ID
                 )
            SELECT  DISTINCT
                    MASTER_ID
                  , PLAN_ID
                  , NEW_BOD_ID
                  , NEW_FROM_SITE_ID
                  , NEW_TO_SITE_ID
                  , TRANSPORT_MODE
                  , TRANSPORT_TIME
                  , TRANSPORT_TIME_UOM
                  , BOD_START_DTTM
                  , 'DX' BOD_PATTERN_ID
            FROM   TH_BUF_SCM_INSTANCE_BOD_C
            WHERE  MASTER_ID = @v_master_id
            AND    PLAN_ID = @v_plan_id
            
            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

          
            SET @v_table_name = 'TH_ENG_ITEM_BOD'
            
            DELETE FROM TH_ENG_ITEM_BOD
            WHERE  MASTER_ID = @v_master_id
            AND    PLAN_ID = @v_plan_id
            AND    BOD_ID LIKE '%STOCKSITE%'

            INSERT INTO TH_ENG_ITEM_BOD
                 (
                    MASTER_ID
                  , PLAN_ID
                  , BOD_ID
                  , ITEM_ID
                 )
            SELECT DISTINCT
                   MASTER_ID,
                   PLAN_ID,
                   NEW_BOD_ID   AS BOD_ID,
                   FROM_ITEM_ID AS ITEM_ID
            FROM   TH_BUF_SCM_INSTANCE_BOD_C
            WHERE  MASTER_ID = @v_master_id
            AND    PLAN_ID = @v_plan_id

            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

            SET @v_table_name = 'TH_ENG_ITEM'
          
            DELETE FROM A
            FROM   TH_ENG_ITEM A,
                   TH_BUF_SCM_INSTANCE_BOD_C B
            WHERE  A.MASTER_ID  = @v_master_id
            AND    A.PLAN_ID    = @v_plan_id
            AND    A.MASTER_ID  = B.MASTER_ID
            AND    A.PLAN_ID    = B.PLAN_ID
            AND    A.ITEM_ID    = B.FROM_ITEM_ID

            INSERT INTO TH_ENG_ITEM
                  (
                   MASTER_ID
                  ,PLAN_ID
                  ,ITEM_ID
                  ,ITEM_TYPE
                  --,IS_FINITE
                  ,FINITE_TERM
                  ,FINITE_TERM_UOM
                  )
            SELECT DISTINCT 
                   A.MASTER_ID
                  ,A.PLAN_ID
                  ,A.FROM_ITEM_ID AS ITEM_ID
                  ,'H'            AS ITEM_TYPE
                  --,'N'            AS IS_FINITE
                  ,0              AS FINITE_TERM
                  ,'DAY'          AS FINITE_TERM_UOM
            FROM   TH_BUF_SCM_INSTANCE_BOD_C A
            WHERE  A.MASTER_ID  = @v_master_id
            AND    A.PLAN_ID    = @v_plan_id
            UNION  ALL
            SELECT @v_master_id   AS MASTER_ID
                  ,@v_plan_id     AS PLAN_ID
                  ,'DUMMY_STOCK'  AS ITEM_ID
                  ,'R'            AS ITEM_TYPE
                  --,'N'            AS IS_FINITE
                  ,0              AS FINITE_TERM          -- 나중에 자재 제약 설정하기 - 14일로
                  ,'DAY'          AS FINITE_TERM_UOM 

            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description


            SET @v_table_name = 'TH_ENG_ROUTE'
          
            DELETE FROM A
            FROM   TH_ENG_ROUTE A,
                   TH_BUF_SCM_INSTANCE_BOD_C B
            WHERE  A.MASTER_ID  = @v_master_id
            AND    A.PLAN_ID    = @v_plan_id
            AND    A.MASTER_ID  = B.MASTER_ID
            AND    A.PLAN_ID    = B.PLAN_ID
            AND    A.ROUTE_ID   = B.NEW_FROM_SITE_ID

            INSERT INTO TH_ENG_ROUTE
                  (
                   MASTER_ID
                  ,PLAN_ID
                  ,ROUTE_ID
                  ,ROUTE_LEVEL
                  )                
            SELECT DISTINCT
                   MASTER_ID
                  ,PLAN_ID
                  ,NEW_FROM_SITE_ID AS ROUTE_ID
                  ,1                AS ROUTE_LEVEL
            FROM   TH_BUF_SCM_INSTANCE_BOD_C A
            WHERE  A.MASTER_ID  = @v_master_id
            AND    A.PLAN_ID    = @v_plan_id

            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description


            SET @v_table_name = 'TH_ENG_RESOURCE'

            INSERT INTO TH_ENG_RESOURCE
                  (
                   MASTER_ID
                  ,PLAN_ID
                  ,RESOURCE_ID
                  ,RESOURCE_TYPE
                  ,SITE_ID
                  ,ROUTE_ID
                  ,MULTI_PORT_COUNT
                  ,RESOURCE_GROUP_ID
                  )                
            SELECT DISTINCT
                   A.MASTER_ID        AS MASTER_ID
                  ,A.PLAN_ID          AS PLAN_ID
                  ,A.NEW_FROM_SITE_ID AS RESOURCE_ID
                  ,'MAIN'             AS RESOURCE_TYPE
                  ,A.NEW_FROM_SITE_ID AS SITE_ID
                  ,A.NEW_FROM_SITE_ID AS ROUTE_ID
                  ,1                  AS MULTI_PORT_COUNT
                  ,A.NEW_FROM_SITE_ID AS RESOURCE_GROUP_ID
            FROM   TH_BUF_SCM_INSTANCE_BOD_C A

            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


            SET @v_table_name = 'TH_ENG_ITEM_ROUTE_SITE'

            DELETE FROM A
            FROM   TH_ENG_ITEM_ROUTE_SITE A,
                   TH_BUF_SCM_INSTANCE_BOD_C B
            WHERE  A.MASTER_ID    = @v_master_id
            AND    A.PLAN_ID      = @v_plan_id
            AND    A.MASTER_ID    = B.MASTER_ID
            AND    A.PLAN_ID      = B.PLAN_ID
            AND    A.ITEM_ID      = B.FROM_ITEM_ID
            AND    A.SITE_ID      = B.NEW_FROM_SITE_ID
            AND    A.ROUTE_ID     = B.NEW_FROM_SITE_ID
            AND    A.OPERATION_ID = B.FROM_OPERATION_ID
            
            INSERT INTO TH_ENG_ITEM_ROUTE_SITE
                  (
                   MASTER_ID
                  ,PLAN_ID
                  ,ITEM_ID
                  ,SITE_ID
                  ,ROUTE_ID
                  ,ROUTE_LEVEL
                  ,OPERATION_ID
                  ,OPERATION_SEQ
                  ,YIELD
                  )                
            SELECT DISTINCT
                   A.MASTER_ID
                  ,A.PLAN_ID
                  ,A.FROM_ITEM_ID      AS ITEM_ID
                  ,A.NEW_FROM_SITE_ID  AS SITE_ID
                  ,A.NEW_FROM_SITE_ID  AS ROUTE_ID
                  ,1                   AS ROUTE_LEVEL
                  ,A.FROM_OPERATION_ID AS OPERATION_ID
                  ,1                   AS OPERATION_SEQ
                  ,1                   AS YIELD
            FROM   TH_BUF_SCM_INSTANCE_BOD_C A
            WHERE  A.MASTER_ID = @v_master_id
            AND    A.PLAN_ID = @v_plan_id
          
            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description


            SET @v_table_name = 'TH_ENG_OP_RES_GROUP'

            INSERT INTO TH_ENG_OP_RES_GROUP
                  (
                   MASTER_ID
                  ,PLAN_ID
                  ,SITE_ID
                  ,ROUTE_ID
                  ,OPERATION_ID
                  ,ITEM_ID
                  ,RESOURCE_MAP_ID
                  ,RESOURCE_MAP_LEVEL
                  ,MIN_TACT_TIME
                  ,AVG_TACT_TIME
                  ,MAX_TACT_TIME
                  ,TACT_TIME_UOM
                  ,YIELD
                  )
                  
            SELECT DISTINCT
                   A.MASTER_ID
                  ,A.PLAN_ID
                  ,A.NEW_FROM_SITE_ID AS SITE_ID
                  ,A.NEW_FROM_SITE_ID AS ROUTE_ID
                  ,A.FROM_OPERATION_ID AS OPERATION_ID
                  ,A.FROM_ITEM_ID AS ITEM_ID
                  ,A.FROM_ITEM_ID +'_'+ A.NEW_FROM_SITE_ID AS RESOURCE_MAP_ID
                  ,1 RESOURCE_MAP_LEVEL
                  ,1 AS MIN_TACT_TIME
                  ,1 AS AVG_TACT_TIME
                  ,1 AS MAX_TACT_TIME
                  ,'SECOND'  AS TACT_TIME_UOM
                  ,1         AS YIELD
            FROM   TH_BUF_SCM_INSTANCE_BOD_C A
            WHERE  A.MASTER_ID = @v_master_id
            AND    A.PLAN_ID = @v_plan_id
            
            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          

            SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP'

            INSERT INTO TH_ENG_OP_RES_GROUP_MAP
                  (
                   MASTER_ID
                  ,PLAN_ID
                  ,SITE_ID
                  ,ROUTE_ID
                  ,OPERATION_ID
                  ,ITEM_ID
                  ,RESOURCE_MAP_ID
                  ,RESOURCE_GROUP_ID
                  ,TACT_TIME
                  ,TACT_TIME_UOM
                  ,YIELD
                  ,ALT_PRIORITY
                  ,PREPARE_TIME
                  )
                  
            SELECT DISTINCT
                   A.MASTER_ID
                  ,A.PLAN_ID
                  ,A.NEW_FROM_SITE_ID AS SITE_ID
                  ,A.NEW_FROM_SITE_ID AS ROUTE_ID
                  ,A.FROM_OPERATION_ID AS OPERATION_ID
                  ,A.FROM_ITEM_ID AS ITEM_ID
                  ,A.FROM_ITEM_ID +'_'+ A.NEW_FROM_SITE_ID AS RESOURCE_MAP_ID
                  ,A.NEW_FROM_SITE_ID AS RESOURCE_GROUP_ID
                  ,0.0000001 AS TACT_TIME
                  ,'SECOND'  AS TACT_TIME_UOM
                  ,1         AS YIELD
                  ,1         AS ALT_PRIORITY
                  ,NULL      AS PREPARE_TIME
            FROM   TH_BUF_SCM_INSTANCE_BOD_C A
            WHERE  A.MASTER_ID = @v_master_id
            AND    A.PLAN_ID = @v_plan_id
            
            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


            SET @v_table_name = 'TH_ENG_PLAN_BOM'

            INSERT INTO TH_ENG_PLAN_BOM
            SELECT  DISTINCT
                      A.MASTER_ID
                    , A.PLAN_ID
                    , A.PARENT_ITEM_ID
                    , B.FROM_ITEM_ID  AS CHILD_ITEM_ID
                    , A.SITE_ID
                    , A.ROUTE_ID
                    , A.OPERATION_ID
                    , A.BINNING_ID
                    , 'Y'             AS PRODUCTION_FLAG
                    , A.BOM_VERSION_ID
                    , 1               AS PARENT_ITEM_RATE
                    , 1               AS CHILD_ITEM_RATE
                    , B.FROM_ITEM_ID  AS ALT_ID
                    , 1               AS ALT_PRIORITY
                    , 1               AS ALT_RATE
                    , 0               AS IN_MOVE_TIME
                    , 0               AS OUT_MOVE_TIME
                    , 'MINUTE' MOVE_TIME_UOM
                    , A.DESCR
            FROM    TH_ENG_PLAN_BOM A,
                    TH_BUF_SCM_INSTANCE_BOD_C B
            WHERE   A.MASTER_ID = @v_master_id
            AND     A.PLAN_ID   = @v_plan_id
            AND     A.MASTER_ID = B.MASTER_ID
            AND     A.PLAN_ID = B.PLAN_ID
            AND     A.PARENT_ITEM_ID = B.NEW_TO_ITEM_ID
            UNION   ALL
            SELECT  DISTINCT
                      A.MASTER_ID
                    , A.PLAN_ID
                    , B.FROM_ITEM_ID AS PARENT_ITEM_ID
                    , 'DUMMY_STOCK'  AS CHILD_ITEM_ID
                    , B.NEW_FROM_SITE_ID AS SITE_ID
                    , B.NEW_FROM_SITE_ID AS ROUTE_ID
                    , B.FROM_OPERATION_ID AS OPERATION_ID
                    , '-' BINNING_ID
                    , 'Y' PRODUCTION_FLAG
                    , NULL BOM_VERSION_ID
                    , 1 PARENT_ITEM_RATE
                    , 1 CHILD_ITEM_RATE
                    , NULL ALT_ID
                    , NULL ALT_PRIORITY
                    , NULL ALT_RATE
                    , 0 IN_MOVE_TIME
                    , 0 OUT_MOVE_TIME
                    , 'MINUTE' MOVE_TIME_UOM
                    , A.DESCR
            FROM    TH_ENG_PLAN_BOM A,
                    TH_BUF_SCM_INSTANCE_BOD_C B
            WHERE   A.MASTER_ID = @v_master_id
            AND     A.PLAN_ID   = @v_plan_id
            AND     A.MASTER_ID = B.MASTER_ID
            AND     A.PLAN_ID = B.PLAN_ID
            AND     A.PARENT_ITEM_ID = B.NEW_TO_ITEM_ID
  
            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


            DELETE  FROM A
            FROM    TH_ENG_PLAN_BOM A,
                    TH_BUF_SCM_INSTANCE_BOD_C B
            WHERE   A.MASTER_ID = @v_master_id
            AND     A.PLAN_ID   = @v_plan_id
            AND     A.MASTER_ID = B.MASTER_ID
            AND     A.PLAN_ID = B.PLAN_ID
            AND     A.PARENT_ITEM_ID = B.NEW_TO_ITEM_ID    
            AND     A.CHILD_ITEM_ID != B.FROM_ITEM_ID

            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null


            SET @v_table_name = 'TH_ENG_STOCK_PLAN'

            UPDATE TH_ENG_STOCK_PLAN
            SET    TH_ENG_STOCK_PLAN.SITE_ID = A.NEW_FROM_SITE_ID
            FROM   (
                    SELECT  MASTER_ID, PLAN_ID,
                            FROM_ITEM_ID, FROM_SITE_ID, FROM_OPERATION_ID, NEW_FROM_SITE_ID
                    FROM    TH_BUF_SCM_INSTANCE_BOD_C A
                    WHERE   A.MASTER_ID = @v_master_id
                    AND     A.PLAN_ID   = @v_plan_id
                    GROUP  BY MASTER_ID, PLAN_ID,
                              FROM_ITEM_ID, FROM_SITE_ID, FROM_OPERATION_ID, NEW_FROM_SITE_ID
                   ) A,
                   TH_ENG_STOCK_PLAN B
            WHERE  A.MASTER_ID = B.MASTER_ID
            AND    A.PLAN_ID = B.PLAN_ID
            AND    A.FROM_ITEM_ID = B.ITEM_ID
            AND    A.FROM_SITE_ID = ( CASE WHEN CHARINDEX('^', B.SITE_ID) > 0 
                                              THEN SUBSTRING(B.SITE_ID, 1, CHARINDEX('^', B.SITE_ID)-1)
                                              ELSE B.SITE_ID 
                                      END )
            AND    A.FROM_OPERATION_ID = B.OPERATION_ID
            AND    B.STOCK_STATUS = 'STOCK' 

            --LOG 생성
            SET @v_message = @@ROWCOUNT
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          END

        END
    
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
