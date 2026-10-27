CREATE PROCEDURE [dbo].[PR_SCM_MF_EPOST_BOM]  
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MF_EPOST_BOM                                                       **/
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
  EXEC PR_SCM_MF_EPOST_BOM
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  DECLARE
    @v_proc_name        nvarchar(150) = 'PR_SCM_MF_EPOST_BOM', 
    @v_table_name       nvarchar(150) = NULL, 
    @v_master_id        nvarchar(150) = @p_master_id, 
    @v_plan_id          nvarchar(150) = @p_plan_id,
    @v_plan_start_time  datetime
    
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
    
        
    
        DELETE FROM TH_BUF_SCM_POST_ITEM_INFO
        DELETE FROM TH_BUF_SCM_POST_BOM_INFO
    
        SET @v_table_name = 'TH_BUF_SCM_POST_ITEM_INFO'
        
        INSERT INTO TH_BUF_SCM_POST_ITEM_INFO
              (
               MASTER_ID
              ,PLAN_ID
              ,PARENT_ITEM_ID
              ,CHILD_ITEM_ID
              ,SITE_ID
              ,ROUTE_ID
              ,OPERATION_ID
              ,LANE_ITEM_ID
              ,LANE
              ,OP_SEQ
              )
        SELECT DISTINCT 
               A.MASTER_ID, A.PLAN_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.SITE_ID, B.ROUTE_ID, B.OPERATION_ID,
               SUBSTRING(A.PARENT_ITEM_ID, 1, 17) AS LANEITEM_ID,
               SUBSTRING(A.PARENT_ITEM_ID,12,6) AS LANE,
               DENSE_RANK() OVER (PARTITION BY SUBSTRING(A.PARENT_ITEM_ID,1,10) 
                                  ORDER BY CASE WHEN B.OPERATION_ID = 'E2500' THEN 'E2000' ELSE B.OPERATION_ID END) AS OP_SEQ 
        FROM   TH_ENG_PLAN_BOM A
               INNER JOIN TH_ENG_ITEM_ROUTE_SITE B
                     ON    A.MASTER_ID = B.MASTER_ID
                     AND   A.PLAN_ID = B.PLAN_ID
                     AND   A.PARENT_ITEM_ID = B.ITEM_ID
                     AND   A.SITE_ID = B.SITE_ID
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
              
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

        
        SET @v_table_name = 'TH_BUF_SCM_POST_BOM_INFO'

        INSERT INTO TH_BUF_SCM_POST_BOM_INFO
              (
               MASTER_ID
              ,PLAN_ID
              ,PARENT_ITEM_ID
              ,CHILD_ITEM_ID
              ,SITE_ID
              ,ROUTE_ID
              ,OPERATION_ID
              ,LANE
              ,LANE_ITEM_ID
              ,OP_SEQ
              ,CHILD_OPERATION_ID
              ,CHILD_SITE_ID
              ,NEW_PARENT_ITEM_ID
              ,NEW_CHILD_ITEM_ID
              )
        SELECT DISTINCT 
               A.MASTER_ID, A.PLAN_ID,
               A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, 
               A.LANE, A.LANE_ITEM_ID,A.OP_SEQ, B.OPERATION_ID AS PREV_OP_CODE,
               B.SITE_ID AS CHILD_SITE_ID,
               A.PARENT_ITEM_ID + '_' + A.OPERATION_ID AS P_CODE, 
               CASE WHEN A.OP_SEQ <= 2 THEN A.CHILD_ITEM_ID 
                                       ELSE A.PARENT_ITEM_ID + '_' + B.OPERATION_ID 
               END  AS C_CODE
        FROM   TH_BUF_SCM_POST_ITEM_INFO A
               INNER JOIN TH_BUF_SCM_POST_ITEM_INFO B
                     ON    A.MASTER_ID = B.MASTER_ID
                     AND   A.PLAN_ID = B.PLAN_ID
                     AND   A.LANE_ITEM_ID = B.LANE_ITEM_ID
                     AND   A.OP_SEQ = B.OP_SEQ + 1
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    EXISTS (
                        SELECT 1
                        FROM   (
                                SELECT PARENT_ITEM_ID, CHILD_ITEM_ID
                                FROM   (
                                        SELECT DISTINCT
                                               PARENT_ITEM_ID, CHILD_ITEM_ID
                                             , MAX(OP_SEQ) OVER (PARTITION BY SUBSTRING(A.PARENT_ITEM_ID,1,10)) AS MAX_SEQ 
                                        FROM   TH_BUF_SCM_POST_ITEM_INFO A
                                        WHERE  A.MASTER_ID  = @v_master_id
                                        AND    A.PLAN_ID    = @v_plan_id
                                       ) A
                                WHERE  MAX_SEQ >= 3       -- OPERATION 이 3개 이상인 애들
                               ) X
                        WHERE  X.PARENT_ITEM_ID = A.PARENT_ITEM_ID
                        AND    X.CHILD_ITEM_ID = A.CHILD_ITEM_ID
                      )
        
        --LOG 생성 
        SET @v_message = 'MAX_OP >= 3 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description


        INSERT INTO TH_BUF_SCM_POST_BOM_INFO
              (
               MASTER_ID
              ,PLAN_ID
              ,PARENT_ITEM_ID
              ,CHILD_ITEM_ID
              ,SITE_ID
              ,ROUTE_ID
              ,OPERATION_ID
              ,LANE
              ,LANE_ITEM_ID
              ,OP_SEQ
              ,CHILD_OPERATION_ID
              ,CHILD_SITE_ID
              ,NEW_PARENT_ITEM_ID
              ,NEW_CHILD_ITEM_ID
              )
        SELECT DISTINCT 
               A.MASTER_ID, A.PLAN_ID,
               A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, 
               A.LANE, A.LANE_ITEM_ID,A.OP_SEQ, B.OPERATION_ID AS PREV_OP_CODE,
               B.SITE_ID AS CHILD_SITE_ID,
               CASE WHEN A.OPERATION_ID = 'E2000'   THEN A.PARENT_ITEM_ID
                                                    ELSE A.PARENT_ITEM_ID + '_' + A.OPERATION_ID 
               END  AS P_CODE, 
               CASE WHEN A.OP_SEQ  = 1              THEN A.CHILD_ITEM_ID 
                    WHEN B.OPERATION_ID = 'E2000'   THEN A.CHILD_ITEM_ID 
                                                    ELSE A.PARENT_ITEM_ID + '_' + B.OPERATION_ID 
               END AS C_CODE
        FROM   TH_BUF_SCM_POST_ITEM_INFO A
               LEFT OUTER JOIN TH_BUF_SCM_POST_ITEM_INFO B
                     ON    A.MASTER_ID = B.MASTER_ID
                     AND   A.PLAN_ID = B.PLAN_ID
                     AND   A.LANE_ITEM_ID = B.LANE_ITEM_ID
                     AND   A.OP_SEQ = B.OP_SEQ + 1
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    EXISTS (
                        SELECT 1
                        FROM   (
                                SELECT PARENT_ITEM_ID, CHILD_ITEM_ID
                                FROM   (
                                        SELECT DISTINCT
                                               PARENT_ITEM_ID, CHILD_ITEM_ID
                                             , MAX(OP_SEQ) OVER (PARTITION BY SUBSTRING(A.PARENT_ITEM_ID,1,10)) AS MAX_SEQ 
                                        FROM   TH_BUF_SCM_POST_ITEM_INFO A
                                        WHERE  A.MASTER_ID  = @v_master_id
                                        AND    A.PLAN_ID    = @v_plan_id
                                       ) A
                                WHERE  MAX_SEQ = 2
                               ) X
                        WHERE  X.PARENT_ITEM_ID = A.PARENT_ITEM_ID
                        AND    X.CHILD_ITEM_ID = A.CHILD_ITEM_ID
                      )

        --LOG 생성
        SET @v_message = 'MAX_OP  = 2 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
        
        INSERT INTO TH_BUF_SCM_POST_BOM_INFO
              (
               MASTER_ID
              ,PLAN_ID
              ,PARENT_ITEM_ID
              ,CHILD_ITEM_ID
              ,SITE_ID
              ,ROUTE_ID
              ,OPERATION_ID
              ,LANE
              ,LANE_ITEM_ID
              ,OP_SEQ
              ,CHILD_OPERATION_ID
              ,CHILD_SITE_ID
              ,NEW_PARENT_ITEM_ID
              ,NEW_CHILD_ITEM_ID
              )
        SELECT DISTINCT 
               A.MASTER_ID, A.PLAN_ID,
               A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, 
               A.LANE, A.LANE_ITEM_ID,B.OP_SEQ, NULL AS PREV_OP_CODE,
               A.SITE_ID AS CHILD_SITE_ID,
               A.PARENT_ITEM_ID + '_' + B.OP2 AS P_CODE, 
               CASE WHEN B.OP_SEQ = 2 THEN A.CHILD_ITEM_ID 
                                      ELSE A.PARENT_ITEM_ID + '_' + B.OP1 
                    END  AS C_CODE
        FROM   TH_BUF_SCM_POST_ITEM_INFO A,
               (SELECT 1 OP_SEQ, 'E3000' OP1, 'E4000' OP2 UNION
                SELECT 2 OP_SEQ, 'E2000' OP1, 'E3000' OP2 ) B
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    EXISTS (
                        SELECT 1
                        FROM   (
                                SELECT PARENT_ITEM_ID, CHILD_ITEM_ID
                                FROM   (
                                        SELECT DISTINCT
                                               PARENT_ITEM_ID, CHILD_ITEM_ID
                                             , MAX(OP_SEQ) OVER (PARTITION BY SUBSTRING(A.PARENT_ITEM_ID,1,10)) AS MAX_SEQ 
                                        FROM   TH_BUF_SCM_POST_ITEM_INFO A
                                        WHERE  A.MASTER_ID  = @v_master_id
                                        AND    A.PLAN_ID    = @v_plan_id
                                       ) A
                                WHERE  MAX_SEQ = 1
                               ) X
                        WHERE  X.PARENT_ITEM_ID = A.PARENT_ITEM_ID
                        AND    X.CHILD_ITEM_ID = A.CHILD_ITEM_ID
                      )
        
        --LOG 생성
        SET @v_message = 'MAX_OP  = 1 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
        
        
        DELETE FROM TH_BUF_SCM_POST_BOM_INFO
        WHERE  MASTER_ID      = @v_master_id
        AND    PLAN_ID        = @v_plan_id
        AND    PARENT_ITEM_ID = NEW_PARENT_ITEM_ID
        AND    CHILD_ITEM_ID  = NEW_CHILD_ITEM_ID
        
        ----------------------------------------------------------------------------------------------------------------------------
        ----------------------------------------------------------------------------------------------------------------------------
        ----------------------------------------------------------------------------------------------------------------------------

        SET @v_table_name = 'TH_ENG_PLAN_BOM'

        INSERT INTO TH_ENG_PLAN_BOM
              (
               MASTER_ID
             , PLAN_ID
             , PARENT_ITEM_ID
             , CHILD_ITEM_ID
             , SITE_ID
             , ROUTE_ID
             , OPERATION_ID
             , BINNING_ID
             , PRODUCTION_FLAG
             , BOM_VERSION_ID
             , PARENT_ITEM_RATE
             , CHILD_ITEM_RATE
             , ALT_ID
             , ALT_PRIORITY
             , ALT_RATE
             , IN_MOVE_TIME
             , OUT_MOVE_TIME
             , MOVE_TIME_UOM
             , DESCR      
              )
        SELECT 
               A.MASTER_ID
             , A.PLAN_ID
             , B.NEW_PARENT_ITEM_ID   AS PARENT_ITEM_ID
             , B.NEW_CHILD_ITEM_ID    AS CHILD_ITEM_ID
             , B.SITE_ID
             , B.ROUTE_ID
             , B.OPERATION_ID
             , '-'                    AS BINNING_ID
             , 'Y'                    AS PRODUCTION_FLAG
             , '1'                    AS BOM_VERSION_ID
             , 1                      AS PARENT_ITEM_RATE
             , 1                      AS CHILD_ITEM_RATE
             , B.NEW_PARENT_ITEM_ID   AS ALT_ID
             , 1                      AS ALT_PRIORITY
             , 1                      AS ALT_RATE
             , 0                      AS IN_MOVE_TIME
             , 0                      AS OUT_MOVE_TIME
             , 'MINUTE'               AS MOVE_TIME_UOM
             , NULL                   AS DESCR
        FROM   TH_ENG_PLAN_BOM A,
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
        AND    A.CHILD_ITEM_ID  = B.CHILD_ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID
        GROUP  BY
               A.MASTER_ID
             , A.PLAN_ID
             , B.NEW_PARENT_ITEM_ID
             , B.NEW_CHILD_ITEM_ID
             , B.SITE_ID
             , B.ROUTE_ID
             , B.OPERATION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

        DELETE FROM A
        FROM   TH_ENG_PLAN_BOM A,
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
        AND    A.CHILD_ITEM_ID  = B.CHILD_ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description

        SET @v_table_name = 'TH_ENG_ITEM_ROUTE_SITE'
        
        INSERT INTO TH_ENG_ITEM_ROUTE_SITE
        SELECT DISTINCT 
               A.MASTER_ID
             , A.PLAN_ID
             , B.NEW_PARENT_ITEM_ID AS ITEM_ID
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
             , A.MIN_LOT_SIZE
             , A.MAX_LOT_SIZE
             , A.INCREMENT_LOT_SIZE
             , A.IN_MOVING_LOT_SIZE
             , A.OUT_MOVING_LOT_SIZE
             , A.IN_MOVE_TIME
             , A.OUT_MOVE_TIME
             , A.MOVE_TIME_UOM
             , A.EARLY_PRODUCING_TERM
             , A.EARLY_PRODUCING_TERM_UOM
             , A.OPERATION_TYPE
             , A.BUFFER_TIME
             , A.BUFFER_TIME_UOM
             , A.DESCR
             , A.TRANSFER_BATCH_SIZE     
        FROM   TH_ENG_ITEM_ROUTE_SITE A,
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.PARENT_ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID
        AND    A.ROUTE_ID       = B.ROUTE_ID
        AND    A.OPERATION_ID   = B.OPERATION_ID
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description


        DELETE FROM A
        FROM   TH_ENG_ITEM_ROUTE_SITE A,
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.PARENT_ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID
        AND    A.ROUTE_ID       = B.ROUTE_ID
        AND    A.OPERATION_ID   = B.OPERATION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description

        SET @v_table_name = 'TH_ENG_OP_RES_GROUP'

        INSERT INTO TH_ENG_OP_RES_GROUP
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.SITE_ID
             , A.ROUTE_ID
             , A.OPERATION_ID
             , B.NEW_PARENT_ITEM_ID   AS ITEM_ID
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
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.PARENT_ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID
        AND    A.ROUTE_ID       = B.ROUTE_ID
        AND    A.OPERATION_ID   = B.OPERATION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

        DELETE FROM A
        FROM   TH_ENG_OP_RES_GROUP A,
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.PARENT_ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID
        AND    A.ROUTE_ID       = B.ROUTE_ID
        AND    A.OPERATION_ID   = B.OPERATION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description

        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_CAL'

        INSERT INTO TH_ENG_OP_RES_GROUP_CAL
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.SITE_ID
             , A.ROUTE_ID
             , A.OPERATION_ID
             , B.NEW_PARENT_ITEM_ID   AS ITEM_ID
             , A.RESOURCE_MAP_ID
             , A.START_DTTM
             , A.END_DTTM
             , A.YIELD
             , A.RESOURCE_SELECTOR_ID
             , A.IS_USE
             , A.DESCR
        FROM   TH_ENG_OP_RES_GROUP_CAL A,
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.PARENT_ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID
        AND    A.ROUTE_ID       = B.ROUTE_ID
        AND    A.OPERATION_ID   = B.OPERATION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

        DELETE FROM A
        FROM   TH_ENG_OP_RES_GROUP_CAL A,
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.PARENT_ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID
        AND    A.ROUTE_ID       = B.ROUTE_ID
        AND    A.OPERATION_ID   = B.OPERATION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description

        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP'

        INSERT INTO TH_ENG_OP_RES_GROUP_MAP
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.SITE_ID
             , A.ROUTE_ID
             , A.OPERATION_ID
             , B.NEW_PARENT_ITEM_ID   AS ITEM_ID
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
             , A.BATCH_RATE
             , A.DESCR
             , A.CONSUME_RES_RATE
             , A.PREPARE_TIME
             , A.PREPARE_TIME_UOM
        FROM   TH_ENG_OP_RES_GROUP_MAP A,
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.PARENT_ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID
        AND    A.ROUTE_ID       = B.ROUTE_ID
        AND    A.OPERATION_ID   = B.OPERATION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

        DELETE FROM A
        FROM   TH_ENG_OP_RES_GROUP_MAP A,
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.PARENT_ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID
        AND    A.ROUTE_ID       = B.ROUTE_ID
        AND    A.OPERATION_ID   = B.OPERATION_ID
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description

        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP_CAL'

        INSERT INTO TH_ENG_OP_RES_GROUP_MAP_CAL
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.SITE_ID
             , A.ROUTE_ID
             , A.OPERATION_ID
             , B.NEW_PARENT_ITEM_ID   AS ITEM_ID
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
             , A.BATCH_RATE
             , A.IS_USE
             , A.DESCR
             , A.CONSUME_RES_RATE
             , A.PREPARE_TIME
             , A.PREPARE_TIME_UOM
        FROM   TH_ENG_OP_RES_GROUP_MAP_CAL A,
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.PARENT_ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID
        AND    A.ROUTE_ID       = B.ROUTE_ID
        AND    A.OPERATION_ID   = B.OPERATION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

        DELETE FROM A
        FROM   TH_ENG_OP_RES_GROUP_MAP_CAL A,
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.PARENT_ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID
        AND    A.ROUTE_ID       = B.ROUTE_ID
        AND    A.OPERATION_ID   = B.OPERATION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description

        SET @v_table_name = 'TH_ENG_SALES_PRODUCT_MAP'

        INSERT INTO TH_ENG_SALES_PRODUCT_MAP
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.SALES_MODEL_ID
             , B.NEW_PARENT_ITEM_ID AS PRODUCT_ITEM_ID
             , A.SITE_ID
             , A.ALT_PRIORITY
             , A.ALT_RATE
             , A.DESCR        
        FROM   TH_ENG_SALES_PRODUCT_MAP A,
               (
                SELECT MASTER_ID, PLAN_ID, PARENT_ITEM_ID, SITE_ID, NEW_PARENT_ITEM_ID
                FROM   (
                        SELECT A.*,
                               MAX(OP_SEQ) over (PARTITION BY LANE_ITEM_ID) AS MAX_SEQ
                        FROM   TH_BUF_SCM_POST_BOM_INFO A
                        WHERE  A.MASTER_ID       = @v_master_id
                        AND    A.PLAN_ID         = @v_plan_id
                       ) A
                WHERE  A.OP_SEQ = A.MAX_SEQ
                GROUP  BY MASTER_ID, PLAN_ID, PARENT_ITEM_ID, SITE_ID, NEW_PARENT_ITEM_ID
               ) B
        WHERE  A.MASTER_ID       = @v_master_id
        AND    A.PLAN_ID         = @v_plan_id
        AND    A.MASTER_ID       = B.MASTER_ID
        AND    A.PLAN_ID         = B.PLAN_ID
        AND    A.PRODUCT_ITEM_ID = B.PARENT_ITEM_ID
        AND    A.SITE_ID         = B.SITE_ID


        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description


        DELETE FROM A
        FROM   TH_ENG_SALES_PRODUCT_MAP A,
               (
                SELECT MASTER_ID, PLAN_ID, PARENT_ITEM_ID, SITE_ID, NEW_PARENT_ITEM_ID
                FROM   (
                        SELECT A.*,
                               MAX(OP_SEQ) OVER (PARTITION BY LANE_ITEM_ID) AS MAX_SEQ
                        FROM   TH_BUF_SCM_POST_BOM_INFO A
                        WHERE  A.MASTER_ID       = @v_master_id
                        AND    A.PLAN_ID         = @v_plan_id
                       ) A
                GROUP  BY MASTER_ID, PLAN_ID, PARENT_ITEM_ID, SITE_ID, NEW_PARENT_ITEM_ID
               ) B
        WHERE  A.MASTER_ID       = @v_master_id
        AND    A.PLAN_ID         = @v_plan_id
        AND    A.MASTER_ID       = B.MASTER_ID
        AND    A.PLAN_ID         = B.PLAN_ID
        AND    A.PRODUCT_ITEM_ID = B.PARENT_ITEM_ID
        AND    A.SITE_ID         = B.SITE_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

        
        SET @v_table_name = 'TH_ENG_ITEM'
        
        INSERT INTO TH_ENG_ITEM
        SELECT  DISTINCT
                A.MASTER_ID
              , A.PLAN_ID
              , B.NEW_PARENT_ITEM_ID AS ITEM_ID
              , A.ITEM_TYPE
              , A.ITEM_UOM
              , A.FLOW_ID
              , A.ITEM_GROUP_ID
              , A.SETUP_GROUP_ID
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
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.PARENT_ITEM_ID
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description


        SET @v_table_name = 'TH_ENG_ITEM_BOD'

        INSERT INTO TH_ENG_ITEM_BOD
              (
               MASTER_ID
             , PLAN_ID
             , BOD_ID
             , ITEM_ID
              )
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.BOD_ID
             , B.NEW_CHILD_ITEM_ID AS ITEM_ID
        FROM   TH_ENG_BOD A,
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.FROM_SITE_ID   = B.CHILD_SITE_ID
        AND    A.TO_SITE_ID     = B.SITE_ID
        AND    A.FROM_SITE_ID  != A.TO_SITE_ID
        AND    A.TRANSPORT_MODE = CHILD_OPERATION_ID +'#'+OPERATION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description


        SET @v_table_name = 'TH_ENG_FIXED_PLAN'

        UPDATE TH_ENG_FIXED_PLAN
        SET    TH_ENG_FIXED_PLAN.ITEM_ID = B.NEW_PARENT_ITEM_ID
        FROM   TH_ENG_FIXED_PLAN A,
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.PARENT_ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID
        AND    A.ROUTE_ID       = B.ROUTE_ID
        AND    A.OPERATION_ID   = B.OPERATION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description
        
        SET @v_table_name = 'TH_ENG_STOCK_PLAN'

        UPDATE TH_ENG_STOCK_PLAN
        SET    TH_ENG_STOCK_PLAN.ITEM_ID = B.NEW_PARENT_ITEM_ID
        FROM   TH_ENG_STOCK_PLAN A,
               TH_BUF_SCM_POST_BOM_INFO B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.PARENT_ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID
        AND    A.OPERATION_ID   = B.OPERATION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

    END
    
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
