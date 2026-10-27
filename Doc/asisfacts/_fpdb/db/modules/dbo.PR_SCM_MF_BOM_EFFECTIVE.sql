CREATE PROCEDURE [dbo].[PR_SCM_MF_BOM_EFFECTIVE]  
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MF_BOM_EFFECTIVE                                                   **/
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
  EXEC PR_SCM_MF_BOM_EFFECTIVE
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  DECLARE
    @v_proc_name        nvarchar(150) = 'PR_SCM_MF_BOM_EFFECTIVE', 
    @v_table_name       nvarchar(150) = NULL, 
    @v_master_id        nvarchar(150) = @p_master_id, 
    @v_plan_id          nvarchar(150) = @p_plan_id,
    @v_plan_type        nvarchar(30)
    
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
    
        SET @v_table_name = 'TH_ENG_PLAN_BOM'
        
        UPDATE TH_ENG_PLAN_BOM
        SET    TH_ENG_PLAN_BOM.ROUTE_ID = B.NEW_ROUTE_ID
             , TH_ENG_PLAN_BOM.DESCR    = B.NEW_ROUTE_ID
        FROM   TH_ENG_PLAN_BOM A,
               (
                SELECT PARENT_ITEM_ID, CHILD_ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, BOM_VERSION_ID,
                       ROUTE_ID + '^^' + CONVERT(NVARCHAR, SEQ) AS NEW_ROUTE_ID
                FROM   (
                        SELECT PARENT_ITEM_ID, CHILD_ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, BOM_VERSION_ID
                             , DENSE_RANK() OVER (PARTITION BY PARENT_ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID 
                                                  ORDER     BY BOM_VERSION_ID DESC) AS SEQ 
                        FROM   TH_ENG_PLAN_BOM A
                        WHERE  MASTER_ID  = @v_master_id
                        AND    PLAN_ID    = @v_plan_id
                       ) A
                WHERE  SEQ > 1
               ) B
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
        AND    A.CHILD_ITEM_ID  = B.CHILD_ITEM_ID
        AND    A.SITE_ID        = B.SITE_ID
        AND    A.ROUTE_ID       = B.ROUTE_ID
        AND    A.BOM_VERSION_ID = B.BOM_VERSION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description



        SET @v_table_name = 'TH_ENG_ITEM_ROUTE_SITE'

        INSERT INTO TH_ENG_ITEM_ROUTE_SITE
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.ITEM_ID
             , A.SITE_ID
             , B.ROUTE_ID       AS ROUTE_ID
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
               TH_ENG_PLAN_BOM B
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    A.MASTER_ID  = B.MASTER_ID
        AND    A.PLAN_ID    = B.PLAN_ID
        AND    A.ITEM_ID    = B.PARENT_ITEM_ID
        AND    A.SITE_ID    = B.SITE_ID
        AND    A.ROUTE_ID   = SUBSTRING(B.ROUTE_ID, 1, CHARINDEX('^^', B.ROUTE_ID)-1)
        AND    B.ROUTE_ID   = B.DESCR

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description


        SET @v_table_name = 'TH_ENG_OP_RES_GROUP'

        INSERT INTO TH_ENG_OP_RES_GROUP
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.SITE_ID
             , B.ROUTE_ID       AS ROUTE_ID
             , A.OPERATION_ID
             , A.ITEM_ID
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
               TH_ENG_PLAN_BOM B
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    A.MASTER_ID  = B.MASTER_ID
        AND    A.PLAN_ID    = B.PLAN_ID
        AND    A.ITEM_ID    = B.PARENT_ITEM_ID
        AND    A.SITE_ID    = B.SITE_ID
        AND    A.ROUTE_ID   = SUBSTRING(B.ROUTE_ID, 1, CHARINDEX('^^', B.ROUTE_ID)-1)
        AND    B.ROUTE_ID   = B.DESCR

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

        
        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_CAL'

        INSERT INTO TH_ENG_OP_RES_GROUP_CAL
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.SITE_ID
             , B.ROUTE_ID       AS ROUTE_ID
             , A.OPERATION_ID
             , A.ITEM_ID
             , A.RESOURCE_MAP_ID
             , A.START_DTTM
             , A.END_DTTM
             , A.YIELD
             , A.RESOURCE_SELECTOR_ID
             , A.IS_USE
             , A.DESCR
        FROM   TH_ENG_OP_RES_GROUP_CAL A,
               TH_ENG_PLAN_BOM B
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    A.MASTER_ID  = B.MASTER_ID
        AND    A.PLAN_ID    = B.PLAN_ID
        AND    A.ITEM_ID    = B.PARENT_ITEM_ID
        AND    A.SITE_ID    = B.SITE_ID
        AND    A.ROUTE_ID   = SUBSTRING(B.ROUTE_ID, 1, CHARINDEX('^^', B.ROUTE_ID)-1)
        AND    B.ROUTE_ID   = B.DESCR

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description


        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP'

        INSERT INTO TH_ENG_OP_RES_GROUP_MAP
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.SITE_ID
             , B.ROUTE_ID       AS ROUTE_ID
             , A.OPERATION_ID
             , A.ITEM_ID
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
               TH_ENG_PLAN_BOM B
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    A.MASTER_ID  = B.MASTER_ID
        AND    A.PLAN_ID    = B.PLAN_ID
        AND    A.ITEM_ID    = B.PARENT_ITEM_ID
        AND    A.SITE_ID    = B.SITE_ID
        AND    A.ROUTE_ID   = SUBSTRING(B.ROUTE_ID, 1, CHARINDEX('^^', B.ROUTE_ID)-1)
        AND    B.ROUTE_ID   = B.DESCR

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description



        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP_CAL'

        INSERT INTO TH_ENG_OP_RES_GROUP_MAP_CAL
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.SITE_ID
             , B.ROUTE_ID         AS ROUTE_ID
             , A.OPERATION_ID
             , A.ITEM_ID
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
               TH_ENG_PLAN_BOM B
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    A.MASTER_ID  = B.MASTER_ID
        AND    A.PLAN_ID    = B.PLAN_ID
        AND    A.ITEM_ID    = B.PARENT_ITEM_ID
        AND    A.SITE_ID    = B.SITE_ID
        AND    A.ROUTE_ID   = SUBSTRING(B.ROUTE_ID, 1, CHARINDEX('^^', B.ROUTE_ID)-1)
        AND    B.ROUTE_ID   = B.DESCR

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description


        SET @v_table_name = 'TH_ENG_ROUTE'

        INSERT INTO TH_ENG_ROUTE
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , B.ROUTE_ID     AS ROUTE_ID
             , A.ROUTE_LEVEL
             , A.MIN_TAT
             , A.AVG_TAT
             , A.MAX_TAT
             , A.TAT_UOM
             , A.IS_EARLY_PRODUCING_BUCKET
             , A.IS_PREV_EPST
             , A.IS_FORWARD_BUCKET
             , A.DESCR
        FROM   TH_ENG_ROUTE A,
               TH_ENG_PLAN_BOM B
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    A.MASTER_ID  = B.MASTER_ID
        AND    A.PLAN_ID    = B.PLAN_ID
        AND    A.ROUTE_ID   = SUBSTRING(B.ROUTE_ID, 1, CHARINDEX('^^', B.ROUTE_ID)-1)
        AND    B.ROUTE_ID   = B.DESCR


        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

        
        SET @v_table_name = 'TH_ENG_PLAN_BOM'
        
        UPDATE TH_ENG_PLAN_BOM
        SET    BOM_VERSION_ID = '1'
        WHERE  MASTER_ID  = @v_master_id
        AND    PLAN_ID    = @v_plan_id

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description


        SET @v_table_name = 'TH_ENG_PLAN_BOM_CAL'

        -- BOM 자체 제약 설정
        INSERT INTO TH_ENG_PLAN_BOM_CAL
        SELECT 
               A.MASTER_ID
             , A.PLAN_ID
             , A.PARENT_ITEM_ID
             , A.CHILD_ITEM_ID
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
        FROM   (
                SELECT 
                       A.MASTER_ID
                     , A.PLAN_ID
                     , A.PARENT_ITEM_ID
                     , A.CHILD_ITEM_ID
                     , A.SITE_ID
                     , A.ROUTE_ID
                     , A.OPERATION_ID
                     , A.BINNING_ID
                     , A.PRODUCTION_FLAG
                     , CASE WHEN A.IS_USE = 'Y' THEN A.START_DTTM_Y ELSE A.START_DTTM END START_DTTM
                     , CASE WHEN A.IS_USE = 'Y' THEN A.END_DTTM_Y   ELSE A.END_DTTM END END_DTTM
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
                FROM   (
                        SELECT DISTINCT
                               A.MASTER_ID
                             , A.PLAN_ID
                             , A.PARENT_ITEM_ID
                             , A.CHILD_ITEM_ID
                             , A.SITE_ID
                             , A.ROUTE_ID
                             , A.OPERATION_ID
                             , A.BINNING_ID
                             , A.PRODUCTION_FLAG
                             , A.START_DTTM
                             , A.END_DTTM
                             , A.START_DTTM_Y
                             , A.END_DTTM_Y
                             , A.BOM_VERSION_ID
                             , A.PARENT_ITEM_RATE
                             , A.CHILD_ITEM_RATE
                             , A.ALT_ID
                             , A.ALT_PRIORITY
                             , A.ALT_RATE
                             , A.IN_MOVE_TIME
                             , A.OUT_MOVE_TIME
                             , A.MOVE_TIME_UOM
                             , CASE WHEN MIN_TIME = PST AND MAX_TIME = PET  THEN 'Y' 
                                                                            ELSE 'N' 
                               END  AS IS_USE
                             , A.DESCR
                        FROM   (
                                SELECT A.*
                                     , MIN(START_DTTM) OVER (PARTITION BY PARENT_ITEM_ID,CHILD_ITEM_ID,SITE_ID, ROUTE_ID) AS MIN_TIME
                                     , MAX(END_DTTM)   OVER (PARTITION BY PARENT_ITEM_ID,CHILD_ITEM_ID,SITE_ID, ROUTE_ID) AS MAX_TIME
                                FROM   (
                                        SELECT DISTINCT
                                               A.MASTER_ID
                                             , A.PLAN_ID
                                             , A.PARENT_ITEM_ID
                                             , A.CHILD_ITEM_ID
                                             , A.SITE_ID
                                             , A.ROUTE_ID
                                             , A.OPERATION_ID
                                             , A.BINNING_ID
                                             , A.PRODUCTION_FLAG
                                             , CASE WHEN B.EFF_START_DATE > PST THEN PST ELSE B.EFF_END_DATE   END AS START_DTTM
                                             , CASE WHEN B.EFF_START_DATE > PST THEN B.EFF_START_DATE ELSE PET END AS END_DTTM
                                             , CASE WHEN B.EFF_START_DATE < PST THEN PST ELSE B.EFF_START_DATE END AS START_DTTM_Y
                                             , CASE WHEN B.EFF_END_DATE   > PET THEN PET ELSE B.EFF_END_DATE   END AS END_DTTM_Y
                                             , B.EFF_START_DATE
                                             , B.EFF_END_DATE
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
                                             , C.PST
                                             , C.PET
                                        FROM   TH_ENG_PLAN_BOM A,
                                               TH_MST_PLAN_BOM B,
                                               (SELECT PLAN_START_DTTM AS PST,
                                                       PLAN_START_DTTM + PLAN_HORIZON AS PET
                                                FROM   TH_ENG_PLAN_INFO A
                                                WHERE  A.MASTER_ID  = @v_master_id
                                                AND    A.PLAN_ID    = @v_plan_id
                                               ) C
                                        WHERE  A.MASTER_ID      = @v_master_id
                                        AND    A.PLAN_ID        = @v_plan_id
                                        AND    A.MASTER_ID      = B.MASTER_ID
                                        AND    A.PLAN_ID        = B.PLAN_ID
                                        AND    A.PARENT_ITEM_ID LIKE B.PARENT_ITEM_ID + '%' 
                                        AND    A.CHILD_ITEM_ID  LIKE B.CHILD_ITEM_ID + '%'
                                        AND    A.SITE_ID        LIKE B.SITE_ID + '%'
                                        AND    A.ROUTE_ID       LIKE B.ROUTE_ID + '%'
                                        AND    A.OPERATION_ID   = B.OPERATION_ID
                                       ) A
                               ) A
                       ) A
               ) A
        WHERE  START_DTTM < END_DTTM 
               
        /*        
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.PARENT_ITEM_ID
             , A.CHILD_ITEM_ID
             , A.SITE_ID
             , A.ROUTE_ID
             , A.OPERATION_ID
             , A.BINNING_ID
             , A.PRODUCTION_FLAG
             , CASE WHEN B.EFF_START_DATE > PST THEN PST ELSE EFF_END_DATE END AS START_DTTM
             , CASE WHEN B.EFF_START_DATE > PST THEN EFF_START_DATE ELSE PET END AS END_DTTM
             , A.BOM_VERSION_ID
             , A.PARENT_ITEM_RATE
             , A.CHILD_ITEM_RATE
             , A.ALT_ID
             , A.ALT_PRIORITY
             , A.ALT_RATE
             , A.IN_MOVE_TIME
             , A.OUT_MOVE_TIME
             , A.MOVE_TIME_UOM
             , 'N' AS IS_USE
             , A.DESCR
        FROM   TH_ENG_PLAN_BOM A,
               TH_MST_PLAN_BOM B,
               (SELECT PLAN_START_DTTM AS PST,
                       PLAN_START_DTTM + PLAN_HORIZON AS PET
                FROM   TH_ENG_PLAN_INFO A
                WHERE  A.MASTER_ID  = @v_master_id
                AND    A.PLAN_ID    = @v_plan_id     
               ) C
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.PARENT_ITEM_ID LIKE B.PARENT_ITEM_ID + '%' 
        AND    A.CHILD_ITEM_ID  LIKE B.CHILD_ITEM_ID + '%'
        AND    A.SITE_ID        LIKE B.SITE_ID + '%'
        AND    A.ROUTE_ID       LIKE B.ROUTE_ID + '%'
        AND    A.OPERATION_ID   = B.OPERATION_ID
        */
        
        /*
        -- BOM CHILD 를 제약설정한 부분 
        INSERT INTO TH_ENG_PLAN_BOM_CAL
        SELECT *
        FROM   (
                SELECT DISTINCT
                       A.MASTER_ID
                     , A.PLAN_ID
                     , A.PARENT_ITEM_ID
                     , A.CHILD_ITEM_ID
                     , A.SITE_ID
                     , A.ROUTE_ID
                     , A.OPERATION_ID
                     , A.BINNING_ID
                     , A.PRODUCTION_FLAG
                     , CASE WHEN B.EFF_START_DATE > PST THEN C.PST ELSE B.EFF_END_DATE END AS START_DTTM
                     , CASE WHEN B.EFF_START_DATE > PST THEN B.EFF_START_DATE ELSE C.PET END AS END_DTTM
                     , A.BOM_VERSION_ID
                     , A.PARENT_ITEM_RATE
                     , A.CHILD_ITEM_RATE
                     , A.ALT_ID
                     , A.ALT_PRIORITY
                     , A.ALT_RATE
                     , A.IN_MOVE_TIME
                     , A.OUT_MOVE_TIME
                     , A.MOVE_TIME_UOM
                     , 'N' AS IS_USE
                     , A.DESCR
                FROM   TH_ENG_PLAN_BOM A,
                       TH_MST_PLAN_BOM B,
                       (SELECT PLAN_START_DTTM AS PST,
                               PLAN_START_DTTM + PLAN_HORIZON AS PET
                        FROM   TH_ENG_PLAN_INFO A
                        WHERE  A.MASTER_ID  = @v_master_id
                        AND    A.PLAN_ID    = @v_plan_id   
                       ) C
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    A.MASTER_ID      = B.MASTER_ID
                AND    A.PLAN_ID        = B.PLAN_ID
                AND    A.PARENT_ITEM_ID LIKE B.PARENT_ITEM_ID + '%' 
                AND    A.SITE_ID        LIKE B.SITE_ID + '%'
                AND    B.EFF_END_DATE IS NOT NULL
               ) A
        WHERE  START_DTTM < END_DTTM 
        */


        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
        
        SET @v_table_name = 'TH_ENG_ITEM_CAL'

        INSERT INTO TH_ENG_ITEM_CAL
        SELECT A.MASTER_ID
             , A.PLAN_ID
             , A.ITEM_ID
             , A.START_DTTM
             , A.END_DTTM
             , 'N' AS IS_USE
             , NULL DESCR
        FROM   (
                SELECT A.*
                     , MIN(START_DTTM) OVER (PARTITION BY ITEM_ID) AS MIN_TIME
                     , MAX(END_DTTM) OVER (PARTITION BY ITEM_ID) AS MAX_TIME
                FROM   (
                        SELECT DISTINCT 
                               A.MASTER_ID
                             , A.PLAN_ID
                             , A.ITEM_ID
                             , CASE WHEN B.EFF_START_DATE > C.PST THEN C.PST ELSE B.EFF_END_DATE END AS START_DTTM
                             , CASE WHEN B.EFF_START_DATE > C.PST THEN B.EFF_START_DATE ELSE PET END AS END_DTTM
                             , C.PST
                             , C.PET
                        FROM   TH_ENG_ITEM A,
                               TH_MST_PLAN_BOM B,
                               (SELECT PLAN_START_DTTM AS PST,
                                       PLAN_START_DTTM + PLAN_HORIZON AS PET
                                FROM   TH_ENG_PLAN_INFO A
                                WHERE  A.MASTER_ID = @v_master_id
                                AND    A.PLAN_ID = @v_plan_id     
                               ) C
                        WHERE  A.MASTER_ID  = @v_master_id
                        AND    A.PLAN_ID    = @v_plan_id
                        AND    A.MASTER_ID  = B.MASTER_ID
                        AND    A.PLAN_ID    = B.PLAN_ID
                        AND    A.ITEM_ID    LIKE B.CHILD_ITEM_ID + '%' 
                        AND    B.EFF_END_DATE IS NOT NULL
                       ) A
                WHERE  START_DTTM < END_DTTM 
               ) A
        WHERE  NOT (MIN_TIME = PST AND MAX_TIME = PET)

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
        
        ---------------------------------------------------------------------------------------------------
        ---------------------------------------------------------------------------------------------------
        ---------------------------------------------------------------------------------------------------
        ---------------------------------------------------------------------------------------------------

        IF CHARINDEX('E_POST', @v_master_id) > 0    -- 후공정만.... E2300 때문..
          BEGIN
          
            UPDATE TH_ENG_BOD
            SET    BOD_PATTERN_ID = 'DX'
            WHERE  MASTER_ID      = @v_master_id
            AND    PLAN_ID        = @v_plan_id
            AND    BOD_PATTERN_ID NOT IN (
                                          SELECT BOD_PATTERN_ID
                                          FROM   TH_ENG_BOD_PATTERN
                                          WHERE  MASTER_ID      = @v_master_id
                                          AND    PLAN_ID        = @v_plan_id
                                         )
            
            DELETE FROM TH_ENG_BOD
            WHERE  MASTER_ID      = @v_master_id
            AND    PLAN_ID        = @v_plan_id
            AND    FROM_SITE_ID = TO_SITE_ID

            DELETE A 
            FROM   TH_ENG_BOD A,
                   TH_ENG_BOD B
            WHERE  A.MASTER_ID      = @v_master_id
            AND    A.PLAN_ID        = @v_plan_id
            AND    A.MASTER_ID      = B.MASTER_ID
            AND    A.PLAN_ID        = B.PLAN_ID
            AND    A.FROM_SITE_ID   = B.TO_SITE_ID
            AND    A.TO_SITE_ID     = B.FROM_SITE_ID        
           
          
            UPDATE TH_ENG_BOD
            SET    BOD_START_DTTM = B.PLAN_START_DTTM
            FROM   TH_ENG_BOD A,
                   TH_ENG_PLAN_INFO B
            WHERE  A.MASTER_ID      = @V_MASTER_ID
            AND    A.PLAN_ID        = @V_PLAN_ID
            AND    A.MASTER_ID      = B.MASTER_ID
            AND    A.PLAN_ID        = B.PLAN_ID
            
          END
          
        select @v_plan_type = plan_type
        from   th_mst_plan
        where  plan_id = @v_plan_id
        
        if @v_plan_type = 'SYNC'
          BEGIN
          
            DELETE FROM TH_ENG_DEMAND_ATTRIBUTE
            WHERE  MASTER_ID = @v_master_id
            AND    PLAN_ID = @v_plan_id
            
            INSERT INTO dbo.TH_ENG_DEMAND_ATTRIBUTE
                 (
                  MASTER_ID, 
                  PLAN_ID, 
                  DEMAND_GROUP_ID,
                  PREFERENCE_SITE_ID,
                  PREFERENCE_ROUTE_ID,
                  PREFERENCE_OPERATION_ID,
                  PREFERENCE_RESOURCE_ID,
                  PREFERENCE_PRODUCT_ID,
                  MIX_FLOW_ID,
                  MIX_LOAD_ID,
                  KITTING_ID,
                  INPUT_START_DTTM,
                  IS_HARD_PREFERENCE,
                  DESCR,
                  PREFERENCE_ROUTE_RESOURCE_ID
                 )
            SELECT
                  MASTER_ID,
                  PLAN_ID,
                  DEMAND_ID,
                  PREFERENCE_SITE_ID,
                  PREFERENCE_ROUTE_ID,
                  PREFERENCE_OPERATION_ID,
                  PREFERENCE_RESOURCE_ID,
                  PREFERENCE_PRODUCT_ID,
                  MIX_FLOW_ID,
                  MIX_LOAD_ID,
                  KITTING_ID,
                  INPUT_START_DTTM,
                  IS_HARD_PREFERENCE,
                  DESCR,
                  PREFERENCE_ROUTE_RESOURCE_ID
            FROM  TH_DPP_DEMAND_ATTRIBUTE a
            WHERE a.MASTER_ID = @v_master_id 
            AND   a.PLAN_ID = @v_plan_id 
            

            BEGIN

              SET @v_table_name = 'TH_ENG_DEMAND_ATTRIBUTE'

              UPDATE TH_ENG_DEMAND_ATTRIBUTE
              SET    TH_ENG_DEMAND_ATTRIBUTE.PREFERENCE_PRODUCT_ID    = A.ITEM_ID
                   , TH_ENG_DEMAND_ATTRIBUTE.PREFERENCE_SITE_ID       = A.SITE_ID
                   , TH_ENG_DEMAND_ATTRIBUTE.PREFERENCE_ROUTE_ID      = A.ROUTE_ID
                   , TH_ENG_DEMAND_ATTRIBUTE.PREFERENCE_OPERATION_ID  = A.OPERATION_ID
              FROM   TH_ENG_ITEM_ROUTE_SITE A,
                     TH_ENG_DEMAND_ATTRIBUTE B
              WHERE  A.MASTER_ID    = @v_master_id
              AND    A.PLAN_ID      = @v_plan_id
              AND    A.MASTER_ID    = B.MASTER_ID
              AND    A.PLAN_ID      = B.PLAN_ID
              AND    A.ITEM_ID      LIKE B.PREFERENCE_PRODUCT_ID +'%'
              AND    A.SITE_ID      LIKE B.PREFERENCE_SITE_ID +'%'
              AND    A.ROUTE_ID     LIKE B.PREFERENCE_ROUTE_ID +'%'
              AND    A.OPERATION_ID LIKE B.PREFERENCE_OPERATION_ID +'%'

              --LOG 생성
              SET @v_message = @@ROWCOUNT
              SET @n_log_count = @n_log_count + 1
              SET @sysdate = GETDATE()
              EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

            END
          
          END

        -- Half Slitting 보정          
        UPDATE TH_ENG_DEMAND_ATTRIBUTE
        SET    TH_ENG_DEMAND_ATTRIBUTE.PREFERENCE_SITE_ID       += '##'+B.SITE_ID
             , TH_ENG_DEMAND_ATTRIBUTE.PREFERENCE_PRODUCT_ID    += '##'+B.PARENT_ITEM_ID
             , TH_ENG_DEMAND_ATTRIBUTE.PREFERENCE_OPERATION_ID  += '##'+B.OPERATION_ID
        FROM TH_ENG_DEMAND_ATTRIBUTE A,
             (
              SELECT DISTINCT
                     CHILD_ITEM_ID, SITE_ID, PARENT_ITEM_ID, OPERATION_ID, 
                     SUBSTRING(SITE_ID,1,CHARINDEX('^',SITE_ID)-1) AS ORG_SITE_ID
              FROM   TH_ENG_PLAN_BOM
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id
              AND    OPERATION_ID = 'E2500' --Half Slitting
              ) B                     
        WHERE A.MASTER_ID = @v_master_id
        AND   A.PLAN_ID = @v_plan_id
        AND   A.PREFERENCE_PRODUCT_ID = B.CHILD_ITEM_ID
        AND   SUBSTRING(A.PREFERENCE_SITE_ID,1,CHARINDEX('^',A.PREFERENCE_SITE_ID)-1) = B.ORG_SITE_ID
        AND   A.PREFERENCE_SITE_ID LIKE '%^%'
      
      
        -- 위에서 ROUTE_ID 를 BOMVERSION 으로 통합하므로, 지운다
        SET @v_table_name = 'TH_ENG_DEMAND_ATTRIBUTE'

        UPDATE TH_ENG_DEMAND_ATTRIBUTE
        SET    PREFERENCE_ROUTE_ID = NULL
        WHERE  MASTER_ID  = @v_master_id
        AND    PLAN_ID    = @v_plan_id
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

        if   CHARINDEX('E_PRE',  @v_master_id) > 0 
          OR CHARINDEX('E_POST', @v_master_id) > 0
          OR CHARINDEX('E_PMIX', @v_master_id) > 0
          OR CHARINDEX('SRS',    @v_master_id) > 0
          OR CHARINDEX('PACK',   @v_master_id) > 0
          OR CHARINDEX('CELL',   @v_master_id) > 0
        BEGIN
        
          DELETE FROM TH_ENG_FIXED_PLAN
          WHERE  MASTER_ID  = @v_master_id
          AND    PLAN_ID    = @v_plan_id
            
        END       

-------------------------------------------------------------
-- Modeling 변경 테스트 - ksjeon
-- mixer -> coater 계획 수립에서
-- coater 계획 수립 -> mixer 수동 생성으로 변경
-------------------------------------------------------------
        if   CHARINDEX('E_PRE',  @v_master_id) > 0
          OR CHARINDEX('SRS',    @v_master_id) > 0
        BEGIN
        
          update TH_ENG_ITEM
          set    ITEM_TYPE  = 'R'
          WHERE  MASTER_ID  = @v_master_id
          AND    PLAN_ID    = @v_plan_id
          and    item_id    like '%BATCH%'          
            
        END       
-------------------------------------------------------------

    END
    
    -- 특화
    BEGIN
    
      SET @v_table_name = 'TH_ENG_PLAN_BOM'

      UPDATE TH_ENG_PLAN_BOM
      SET    TH_ENG_PLAN_BOM.ALT_ID = NULL
      FROM   TH_ENG_PLAN_BOM A,
             (
                SELECT A.*
                FROM   TH_MST_PLAN_BOM A,
                       (
                        SELECT * 
                        FROM   TH_MST_PLAN_BOM A
                        WHERE  MASTER_ID = @v_master_id
                        AND    PLAN_ID =   @v_plan_id
                        AND    EXISTS (
                                        SELECT 1
                                        FROM   TH_MST_ITEM X
                                        WHERE  X.MASTER_ID  = A.MASTER_ID
                                        AND    X.PLAN_ID    = A.PLAN_ID
                                        AND    X.ITEM_ID    = A.CHILD_ITEM_ID
                                        AND    X.ITEM_TYPE  = 'R'
                                      )
                        AND    ALT_ID IS NOT NULL
                       ) B
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
                AND    A.CHILD_ITEM_ID  = B.CHILD_ITEM_ID
                AND    A.ALT_ID         IS NULL
               ) B
      WHERE  A.MASTER_ID  = @v_master_id
      AND    A.PLAN_ID    = @v_plan_id
      AND    A.PARENT_ITEM_ID LIKE B.PARENT_ITEM_ID +'%'
      AND    EXISTS (
                      SELECT 1
                      FROM   TH_ENG_ITEM X
                      WHERE  X.MASTER_ID  = A.MASTER_ID
                      AND    X.PLAN_ID    = A.PLAN_ID
                      AND    X.ITEM_ID    = A.CHILD_ITEM_ID
                      AND    X.ITEM_TYPE  = 'R'
                    )
    
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

    END
    
    --------------------------------------------------------------
    -- 지정된 공정만 나올수 있도록 하위 ITEM 에 대해 STOCK 처리함
    -- 대상 : E_POST, PACK, CELL
    --------------------------------------------------------------
    IF    CHARINDEX('E_POST', @V_MASTER_ID) > 0
       OR CHARINDEX('CELL'  , @V_MASTER_ID) > 0
       OR CHARINDEX('PACK'  , @V_MASTER_ID) > 0
    BEGIN
    
      DECLARE @N_STOCK_SEQ        INTEGER   = 0
            , @V_PLAN_START_DTTM  DATETIME
      
      SELECT  @N_STOCK_SEQ = ISNULL(MAX(STOCK_SEQ),0)
      FROM    TH_ENG_STOCK_PLAN
      WHERE   MASTER_ID = @V_MASTER_ID
      AND     PLAN_ID   = @V_PLAN_ID
      
      SELECT  @V_PLAN_START_DTTM = PLAN_START_DTTM
      FROM    TH_ENG_PLAN_INFO
      WHERE   MASTER_ID = @V_MASTER_ID
      AND     PLAN_ID   = @V_PLAN_ID

      INSERT INTO TH_ENG_STOCK_PLAN
           (
             MASTER_ID
           , PLAN_ID
           , STOCK_SEQ
           , ITEM_ID
           , SITE_ID
           , RECEIVING_DTTM
           , QTY
           , LOT_ID
           , DEMAND_ID
           , STOCK_STATUS
           )
      SELECT DISTINCT
             A.MASTER_ID
           , A.PLAN_ID
           , ISNULL(@N_STOCK_SEQ,0) 
                    + ROW_NUMBER() OVER ( ORDER BY A.DEMAND_ID
                                                 , C.PARENT_ITEM_ID
                                                 , C.CHILD_ITEM_ID
                                                 , C.SITE_ID
                                                 , C.ROUTE_ID
                                                 , C.OPERATION_ID) STOCK_SEQ
           , C.CHILD_ITEM_ID
           , C.SITE_ID
           , @V_PLAN_START_DTTM RECEIVING_DTTM
           , CEILING(A.QTY * C.CHILD_ITEM_RATE * 2) AS QTY
           , 'LOT_TEST' AS LOT_ID
           , A.DEMAND_ID
           , 'STOCK'    AS STOCK_STATUS
      FROM   TH_ENG_NET_DEMAND A,
             TH_ENG_SALES_PRODUCT_MAP B,
             TH_ENG_PLAN_BOM C,
             TH_ENG_ITEM D
      WHERE  A.MASTER_ID        = @v_master_id
      AND    A.PLAN_ID          = @v_plan_id
      AND    A.ORDER_TYPE       = 'TEST'
      AND    A.MASTER_ID        = B.MASTER_ID
      AND    A.PLAN_ID          = B.PLAN_ID
      AND    A.SALES_MODEL_ID   = B.SALES_MODEL_ID
      AND    A.MASTER_ID        = C.MASTER_ID
      AND    A.PLAN_ID          = C.PLAN_ID
      AND    B.PRODUCT_ITEM_ID  = C.PARENT_ITEM_ID
      AND    B.SITE_ID          = C.SITE_ID
      AND    C.MASTER_ID        = D.MASTER_ID
      AND    C.PLAN_ID          = D.PLAN_ID
      AND    C.CHILD_ITEM_ID    = D.ITEM_ID
      AND    D.ITEM_TYPE        = 'H'

      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @v_description = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description
    
    END
    
    BEGIN

      IF CHARINDEX('KR_PACK', @v_master_id) > 0    -- 자재제약 제거
      BEGIN
      
        SET @v_table_name = 'TH_ENG_STOCK_PLAN'
        
        DELETE FROM A
        FROM   TH_ENG_STOCK_PLAN A,
               TH_ENG_ITEM B
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    A.MASTER_ID  = B.MASTER_ID
        AND    A.PLAN_ID    = B.PLAN_ID
        AND    A.ITEM_ID    = B.ITEM_ID
        AND    B.ITEM_TYPE  = 'R'        
      
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description

        SET @v_table_name = 'TH_ENG_ITEM'
        
        UPDATE TH_ENG_ITEM
        SET    FINITE_TERM = 0
             , IS_FINITE = 'N'
        WHERE  MASTER_ID  = @v_master_id
        AND    PLAN_ID    = @v_plan_id
        AND    ITEM_TYPE  = 'R'        
      
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description
        
      END

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
