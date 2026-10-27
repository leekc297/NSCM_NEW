CREATE PROCEDURE [dbo].[PR_SCM_MF_FINAL]  
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MF_FINAL                                                           **/
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
  EXEC PR_SCM_MF_FINAL
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  DECLARE
    @v_proc_name        nvarchar(150) = 'PR_SCM_MF_FINAL', 
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
    
      IF CHARINDEX('PACK', @v_master_id) > 0 AND 1=0  -- 실행안되게 처리
    
        BEGIN
        
          SET @v_table_name = 'TH_ENG_ITEM_ROUTE_SITE'
          
          UPDATE TH_ENG_ITEM_ROUTE_SITE
          SET    TH_ENG_ITEM_ROUTE_SITE.TRANSFER_BATCH_SIZE = ( CASE WHEN B.TRANS_BATCH_SIZE < 50 THEN 50 ELSE B.TRANS_BATCH_SIZE END )
          FROM   TH_ENG_ITEM_ROUTE_SITE A,
                 (
                  SELECT MASTER_ID, PLAN_ID, CHILD_ITEM_ID AS ITEM_ID, SITE_ID, ROUTE_ID, 
                         MAX(CEILING(CHILD_ITEM_RATE)) AS TRANS_BATCH_SIZE
                  FROM   TH_ENG_PLAN_BOM
                  WHERE  MASTER_ID = @v_master_id
                  AND    PLAN_ID = @v_plan_id
                  GROUP BY MASTER_ID,PLAN_ID,CHILD_ITEM_ID,SITE_ID,ROUTE_ID
                 ) B
          WHERE  A.MASTER_ID = @v_master_id
          AND    A.PLAN_ID = @v_plan_id
          AND    A.MASTER_ID = B.MASTER_ID
          AND    A.PLAN_ID = B.PLAN_ID
          AND    A.ITEM_ID = B.ITEM_ID
          AND    A.SITE_ID = B.SITE_ID
          AND    A.ROUTE_ID = B.ROUTE_ID

          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @v_description = 'PACK - TRANSFER_BATCH_SIZE'
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

        END
        
    END
    
    ----------------------------------------------------------------------------------------------------------------------
    -- VD 라인 증축 - A6000
    ----------------------------------------------------------------------------------------------------------------------
    BEGIN
    
      SET @v_table_name = 'TH_BUF_SCM_VD_RESOURCE'
      
      DELETE FROM TH_BUF_SCM_VD_RESOURCE
    
      INSERT INTO TH_BUF_SCM_VD_RESOURCE
      SELECT 
             A.MASTER_ID,
             A.PLAN_ID,
             A.PARENT_ITEM_ID         AS ITEM_ID, 
             A.PARENT_SITE_ID         AS SITE_ID, 
             A.PARENT_ROUTE_ID        AS ROUTE_ID, 
             A.PARENT_OPERATION_ID    AS OPERATION_ID, 
             C.RESOURCE_ID            AS RESOURCE_ID, 
             B.RESOURCE_GROUP_ID      AS RESOURCE_GROUP_ID, 
             REPLACE(E.RESOURCE_ID,       A.CHILD_OPERATION_ID, A.PARENT_OPERATION_ID) AS NEW_RESOURCE_ID,
             REPLACE(D.RESOURCE_GROUP_ID, A.CHILD_OPERATION_ID, A.PARENT_OPERATION_ID) AS NEW_RESOURCE_GROUP_ID
      FROM   (
              SELECT DISTINCT
                     A.MASTER_ID, A.PLAN_ID,
                     A.PARENT_ITEM_ID, A.SITE_ID AS PARENT_SITE_ID, A.ROUTE_ID AS PARENT_ROUTE_ID, A.OPERATION_ID AS PARENT_OPERATION_ID,
                     A.CHILD_ITEM_ID,  B.SITE_ID AS CHILD_SITE_ID,  B.ROUTE_ID AS CHILD_ROUTE_ID,  B.OPERATION_ID AS CHILD_OPERATION_ID
              FROM   TH_ENG_PLAN_BOM A,
                     TH_ENG_ITEM_ROUTE_SITE B,
                     TH_ENG_BOD C
              WHERE  A.MASTER_ID      = @v_master_id
              AND    A.PLAN_ID        = @v_plan_id
              AND    A.OPERATION_ID   = 'A6000'
              AND    A.MASTER_ID      = B.MASTER_ID
              AND    A.PLAN_ID        = B.PLAN_ID
              AND    A.CHILD_ITEM_ID  = B.ITEM_ID
              AND    A.MASTER_ID      = C.MASTER_ID
              AND    A.PLAN_ID        = C.PLAN_ID
              AND    A.SITE_ID        = C.TO_SITE_ID
              AND    B.SITE_ID        = C.FROM_SITE_ID
             ) A
             INNER JOIN TH_ENG_OP_RES_GROUP_MAP B
                   ON   A.MASTER_ID           = B.MASTER_ID
                   AND  A.PLAN_ID             = B.PLAN_ID
                   AND  A.PARENT_ITEM_ID      = B.ITEM_ID
                   AND  A.PARENT_SITE_ID      = B.SITE_ID
                   AND  A.PARENT_ROUTE_ID     = B.ROUTE_ID
                   AND  A.PARENT_OPERATION_ID = B.OPERATION_ID
             INNER JOIN TH_ENG_RESOURCE C
                   ON   A.MASTER_ID           = C.MASTER_ID
                   AND  A.PLAN_ID             = C.PLAN_ID
                   AND  B.RESOURCE_GROUP_ID   = C.RESOURCE_GROUP_ID
             INNER JOIN TH_ENG_OP_RES_GROUP_MAP D
                   ON   A.MASTER_ID           = D.MASTER_ID
                   AND  A.PLAN_ID             = D.PLAN_ID
                   AND  A.CHILD_ITEM_ID       = D.ITEM_ID
                   AND  A.CHILD_SITE_ID       = D.SITE_ID
                   AND  A.CHILD_ROUTE_ID      = D.ROUTE_ID
                   AND  A.CHILD_OPERATION_ID  = D.OPERATION_ID
             INNER JOIN TH_ENG_RESOURCE E
                   ON   A.MASTER_ID           = E.MASTER_ID
                   AND  A.PLAN_ID             = E.PLAN_ID
                   AND  D.RESOURCE_GROUP_ID   = E.RESOURCE_GROUP_ID
             INNER JOIN TH_MST_RESOURCE F
                   ON   A.MASTER_ID = F.MASTER_ID
                   AND  A.PLAN_ID = F.PLAN_ID
                   AND  C.RESOURCE_ID = F.RESOURCE_ID
             INNER JOIN TH_MST_RESOURCE G
                   ON   A.MASTER_ID = G.MASTER_ID
                   AND  A.PLAN_ID = G.PLAN_ID
                   AND  E.RESOURCE_ID = G.RESOURCE_ID
                   AND  F.RES_ATTB_20 = G.RES_ATTB_20         -- 음극 양극 맞추기
                   
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

        DELETE FROM A
        FROM   TH_BUF_SCM_VD_RESOURCE A,
               TH_ENG_RESOURCE B
        WHERE  A.MASTER_ID              = @v_master_id
        AND    A.PLAN_ID                = @v_plan_id
        AND    A.MASTER_ID              = B.MASTER_ID
        AND    A.PLAN_ID                = B.PLAN_ID
        AND    A.NEW_RESOURCE_ID        = B.RESOURCE_ID
        AND    A.NEW_RESOURCE_GROUP_ID  = B.RESOURCE_GROUP_ID
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description
    
      BEGIN

        SET @v_table_name = 'TH_ENG_RESOURCE'
        
        INSERT INTO TH_ENG_RESOURCE
              (
                MASTER_ID
              , PLAN_ID
              , RESOURCE_ID
              , RESOURCE_TYPE
              , SITE_ID
              , ROUTE_ID
              , LOCATION_ID
              , MULTI_PORT_COUNT
              , UTILIZATION
              , BATCH_TYPE
              , IS_EXCEPTION
              , IS_FINITE
              , IS_DUMMY
              , OFFTIME_SET_ID
              , ATTRIBUTE_SET_ID
              , ATTRIBUTE_CHECKER_ID
              , INLINE_GROUP_ID
              , RESOURCE_GROUP_ID
              , RESOURCE_SETUP_GROUP_ID
              , BATCH_RES_GROUP_ID
              , MAX_SETUP_COUNT
              , RAMPUP_RATE
              , RAMPUP_TERM
              , RAMPUP_UOM
              , FIXED_TERM
              , FIXED_TERM_UOM
              , NCP_TERM
              , NCP_TERM_UOM
              , DESCR              
              )
        SELECT  DISTINCT
                A.MASTER_ID
              , A.PLAN_ID
              , B.NEW_RESOURCE_ID       AS RESOURCE_ID
              , A.RESOURCE_TYPE
              , A.SITE_ID
              , A.ROUTE_ID
              , A.LOCATION_ID
              , A.MULTI_PORT_COUNT
              , A.UTILIZATION
              , A.BATCH_TYPE
              , A.IS_EXCEPTION
              , A.IS_FINITE
              , A.IS_DUMMY
              , A.OFFTIME_SET_ID
              , A.ATTRIBUTE_SET_ID
              , A.ATTRIBUTE_CHECKER_ID
              , A.INLINE_GROUP_ID
              , B.NEW_RESOURCE_GROUP_ID   AS RESOURCE_GROUP_ID
              , A.RESOURCE_SETUP_GROUP_ID
              , A.BATCH_RES_GROUP_ID
              , A.MAX_SETUP_COUNT
              , A.RAMPUP_RATE
              , A.RAMPUP_TERM
              , A.RAMPUP_UOM
              , A.FIXED_TERM
              , A.FIXED_TERM_UOM
              , A.NCP_TERM
              , A.NCP_TERM_UOM
              , A.DESCR
        FROM   TH_ENG_RESOURCE A,
               TH_BUF_SCM_VD_RESOURCE B
        WHERE  A.MASTER_ID          = @v_master_id
        AND    A.PLAN_ID            = @v_plan_id
        AND    A.MASTER_ID          = B.MASTER_ID
        AND    A.PLAN_ID            = B.PLAN_ID
        AND    A.RESOURCE_GROUP_ID  = B.RESOURCE_GROUP_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

      END
          
      BEGIN

        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP'
        
        INSERT INTO TH_ENG_OP_RES_GROUP_MAP
              (
                MASTER_ID
              , PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , ITEM_ID
              , RESOURCE_MAP_ID
              , RESOURCE_GROUP_ID
              , SUB_RESOURCE_MAP_ID
              , RESOURCE_MAP_LEVEL
              , ALT_PRIORITY
              , TACT_TIME
              , TACT_TIME_UOM
              , YIELD
              , IS_FIRST_SETUP
              , GOOD_RATE
              , BATCH_RATE
              , DESCR
              , CONSUME_RES_RATE
              , PREPARE_TIME
              , PREPARE_TIME_UOM
              )
        SELECT DISTINCT
                A.MASTER_ID
              , A.PLAN_ID
              , A.SITE_ID
              , A.ROUTE_ID
              , A.OPERATION_ID
              , A.ITEM_ID
              , A.RESOURCE_MAP_ID
              , B.NEW_RESOURCE_GROUP_ID   AS RESOURCE_GROUP_ID
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
               TH_BUF_SCM_VD_RESOURCE B
        WHERE  A.MASTER_ID          = @v_master_id
        AND    A.PLAN_ID            = @v_plan_id
        AND    A.MASTER_ID          = B.MASTER_ID
        AND    A.PLAN_ID            = B.PLAN_ID
        AND    A.ITEM_ID            = B.ITEM_ID
        AND    A.SITE_ID            = B.SITE_ID
        AND    A.ROUTE_ID           = B.ROUTE_ID
        AND    A.OPERATION_ID       = B.OPERATION_iD
        AND    A.RESOURCE_GROUP_ID  = B.RESOURCE_GROUP_ID        
    
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description


        DELETE FROM A
        FROM   TH_ENG_OP_RES_GROUP_MAP A,
               TH_BUF_SCM_VD_RESOURCE B
        WHERE  A.MASTER_ID          = @v_master_id
        AND    A.PLAN_ID            = @v_plan_id
        AND    A.MASTER_ID          = B.MASTER_ID
        AND    A.PLAN_ID            = B.PLAN_ID
        AND    A.ITEM_ID            = B.ITEM_ID
        AND    A.SITE_ID            = B.SITE_ID
        AND    A.ROUTE_ID           = B.ROUTE_ID
        AND    A.OPERATION_ID       = B.OPERATION_iD
        AND    A.RESOURCE_GROUP_ID  = B.RESOURCE_GROUP_ID        

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description

      END
      
      BEGIN

        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP_CAL'
        
        INSERT INTO TH_ENG_OP_RES_GROUP_MAP_CAL
              (
                MASTER_ID
              , PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , ITEM_ID
              , RESOURCE_MAP_ID
              , RESOURCE_GROUP_ID
              , START_DTTM
              , END_DTTM
              , SUB_RESOURCE_MAP_ID
              , RESOURCE_MAP_LEVEL
              , ALT_PRIORITY
              , TACT_TIME
              , TACT_TIME_UOM
              , YIELD
              , GOOD_RATE
              , BATCH_RATE
              , IS_USE
              , DESCR
              , CONSUME_RES_RATE
              , PREPARE_TIME
              , PREPARE_TIME_UOM
              )
        SELECT DISTINCT
                A.MASTER_ID
              , A.PLAN_ID
              , A.SITE_ID
              , A.ROUTE_ID
              , A.OPERATION_ID
              , A.ITEM_ID
              , A.RESOURCE_MAP_ID
              , B.NEW_RESOURCE_GROUP_ID   AS RESOURCE_GROUP_ID
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
               TH_BUF_SCM_VD_RESOURCE B
        WHERE  A.MASTER_ID          = @v_master_id
        AND    A.PLAN_ID            = @v_plan_id
        AND    A.MASTER_ID          = B.MASTER_ID
        AND    A.PLAN_ID            = B.PLAN_ID
        AND    A.ITEM_ID            = B.ITEM_ID
        AND    A.SITE_ID            = B.SITE_ID
        AND    A.ROUTE_ID           = B.ROUTE_ID
        AND    A.OPERATION_ID       = B.OPERATION_iD
        AND    A.RESOURCE_GROUP_ID  = B.RESOURCE_GROUP_ID        
    
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description


        DELETE FROM A
        FROM   TH_ENG_OP_RES_GROUP_MAP_CAL A,
               TH_BUF_SCM_VD_RESOURCE B
        WHERE  A.MASTER_ID          = @v_master_id
        AND    A.PLAN_ID            = @v_plan_id
        AND    A.MASTER_ID          = B.MASTER_ID
        AND    A.PLAN_ID            = B.PLAN_ID
        AND    A.ITEM_ID            = B.ITEM_ID
        AND    A.SITE_ID            = B.SITE_ID
        AND    A.ROUTE_ID           = B.ROUTE_ID
        AND    A.OPERATION_ID       = B.OPERATION_iD
        AND    A.RESOURCE_GROUP_ID  = B.RESOURCE_GROUP_ID        

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description

      END

      BEGIN

        SET @v_table_name = 'TH_ENG_FIXED_PLAN'

        UPDATE TH_ENG_FIXED_PLAN
        SET    TH_ENG_FIXED_PLAN.RESOURCE_ID = B.NEW_RESOURCE_ID
        FROM   TH_ENG_FIXED_PLAN A,
               TH_BUF_SCM_VD_RESOURCE B
        WHERE  A.MASTER_ID    = @v_master_id
        AND    A.PLAN_ID      = @v_plan_id
        AND    A.MASTER_ID    = B.MASTER_ID
        AND    A.PLAN_ID      = B.PLAN_ID
        AND    A.ITEM_ID      = B.ITEM_ID
        AND    A.SITE_ID      = B.SITE_ID
        AND    A.ROUTE_ID     = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_iD
        AND    A.RESOURCE_ID  = B.RESOURCE_ID        
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

      END
      
      BEGIN

        SET @v_table_name = 'TH_ENG_ITEM'

        UPDATE TH_ENG_ITEM
        SET    TH_ENG_ITEM.SETUP_GROUP_ID = CASE WHEN C.LANE_QTY < 10 THEN '0' ELSE '' END + CONVERT(nvarchar, CEILING(c.LANE_QTY)) + '_' + CONVERT(nvarchar, (ROUND(ISNULL(C.SLIT_WIDTH,0),3)))
        FROM   TH_ENG_ITEM A,
          	 (SELECT PARENT_ITEM_ID AS ITEM_ID--, LEFT(PARENT_ITEM_ID, CHARINDEX('_', PARENT_ITEM_ID)-1) AS ITEM_ID
              FROM   TH_ENG_PLAN_BOM
            	WHERE  MASTER_ID    = @v_master_id
            	AND    PLAN_ID = @v_plan_id
            	AND    OPERATION_ID = 'E4000'
            	AND    PARENT_ITEM_ID LIKE '%LANE%') B,
          	 (SELECT DISTINCT A.SITE_ID, A.ITEM_ID, A.LANE_QTY, A.SLIT_WIDTH,
                     A.ITEM_ID  + '_LANE' + CASE WHEN A.LANE_QTY < 10 THEN '0' ELSE '' END + CONVERT(nvarchar, CEILING(A.LANE_QTY)) + '_E4000'  AS NEW_ITEM_ID
              FROM (
              		SELECT DISTINCT SITE_ID, PLANT_ID, ITEM_ID, MAIN_LANE_QTY AS LANE_QTY, SLIT_WIDTH
              		FROM SY_SCM_ITEM_LANE_M
              		WHERE 1=1
              		AND ITEM_ID LIKE 'APC%'
              		AND MAIN_LANE_QTY > 0
              		UNION ALL
              		SELECT DISTINCT SITE_ID, PLANT_ID, ITEM_ID, SUB_LANE_QTY AS LANE_QTY, SLIT_WIDTH
              		FROM SY_SCM_ITEM_LANE_M
              		WHERE 1=1
              		AND ITEM_ID LIKE 'APC%'
              		AND SUB_LANE_QTY > 0) A ) C
        WHERE  A.MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'E2')
        AND    A.PLAN_ID = @v_plan_id
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.ITEM_ID = C.NEW_ITEM_ID 
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

      END      

      BEGIN

        SET @v_table_name = 'TH_ENG_SETUP_MATRIX'

        DELETE  TH_ENG_SETUP_MATRIX
        WHERE   MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'E2')
        AND     PLAN_ID    = @v_plan_id
        AND     RESOURCE_SETUP_GROUP_ID LIKE '%E4000%'
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_description
      
      END
      
      BEGIN

        SET @v_table_name = 'TH_ENG_SETUP_MATRIX'

        INSERT  INTO TH_ENG_SETUP_MATRIX
        SELECT  DISTINCT 
                @v_master_id AS MASTER_ID,
                @v_plan_id AS PLAN_ID,
                A.PLANT_ID + '_E4000' AS RESOURCE_SETUP_GROUP_ID,
                'ALL' AS FROM_SETUP_GROUP_ID,
                B.SETUP_GROUP_ID AS TO_SETUP_GROUP_ID,
                A.SETUP_TIME AS SETUP_TIME,
                'MINUTE' AS SETUP_TIME_UOM,
                0 AS FIRST_SETUP_TIME, 
                'MINUTE' AS FIRST_SETUP_TIME_UOM,
                NULL AS DESCR
        FROM   (SELECT SEGMENT1 AS SITE_ID,
          		         SEGMENT2 AS PLANT_ID,
          		         CASE WHEN CONVERT(INT, SEGMENT3) < 10 THEN '0' ELSE '' END + CONVERT(nvarchar, CONVERT(INT, SEGMENT3)) AS LANE_QTY,
          		         ATTRIBUTE1 AS SETUP_TIME
            		FROM SY_SCM_SYS_LOOKUP_VALUE
            		WHERE 1=1
            		AND LOOKUP_TYPE_CODE = 'LANE_SETUP_MATRIX') A,
               (SELECT DISTINCT SETUP_GROUP_ID
                FROM TH_ENG_ITEM
                WHERE MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'E2')
                AND PLAN_ID = @v_plan_id
                AND ITEM_ID LIKE '%E4000'
                AND ITEM_ID LIKE '%LANE%') B,
            	 (SELECT DISTINCT A.INSTANCE_ID, B.PLANT_ID
            		FROM  SY_FP_INSTANCE_FACTORY_M A,
            		      SY_SCM_FACTORY_M B
            		WHERE 1=1
            		AND   A.INSTANCE_ID = @v_master_id
            		AND   A.FACTORY_ID = B.FACTORY_ID) C
        WHERE   1=1
        AND     A.LANE_QTY = LEFT(B.SETUP_GROUP_ID, 2)
        AND     A.PLANT_ID = C.PLANT_ID
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_description

      END            

      BEGIN

        SET @v_table_name = 'TH_ENG_ITEM_ROUTE_SITE - MIN BATCH SIZE UPDATE'

        UPDATE TH_ENG_ITEM_ROUTE_SITE
        SET    TH_ENG_ITEM_ROUTE_SITE.MIN_LOT_SIZE = CEILING(B.MAX_BATCH_QTY * B.MIN_BATCH_SIZE)
        FROM   TH_ENG_ITEM_ROUTE_SITE A,
               (                
                SELECT A.*, B.OPERATION_ID, B.MIN_BATCH_SIZE
                FROM   (
                        SELECT DISTINCT PLAN_ID, DESCR AS FACTORY_ID, A.ITEM_ID, MAX_BATCH_QTY
                        FROM   TH_ENG_BATCH_INFO A
                        WHERE  A.MASTER_ID  = @v_master_id
                        AND    A.PLAN_ID    = @v_plan_id
                       ) A,
                       (
                        SELECT SEGMENT1 AS SITE_ID,
                               SEGMENT2 AS FACTORY_ID,
                               SEGMENT3 AS OPERATION_ID,
                               ATTRIBUTE1 AS MIN_BATCH_SIZE
                        FROM SY_SCM_SYS_LOOKUP_VALUE
                        WHERE 1=1
                        AND LOOKUP_TYPE_CODE = 'MIN_BATCH_SIZE'
                       ) B
                WHERE  A.FACTORY_ID = B.FACTORY_ID
               ) B
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    A.ITEM_ID    = B.ITEM_ID
        AND    A.SITE_ID    LIKE B.FACTORY_ID + '%'
        AND    A.OPERATION_ID = B.OPERATION_ID
        /*
        UPDATE TH_ENG_ITEM_ROUTE_SITE
        SET    TH_ENG_ITEM_ROUTE_SITE.MIN_LOT_SIZE = CEILING(B.MAX_BATCH_QTY * C.MIN_BATCH_SIZE)
        FROM   TH_ENG_ITEM_ROUTE_SITE A,
             	 (SELECT DISTINCT PLAN_ID, LEFT(BATCH_GROUP_ID,2) AS FACTORY_ID, DESCR AS BUILDING_ID, A.ITEM_ID, MAX_BATCH_QTY
            		FROM TH_ENG_BATCH_INFO A
            		WHERE A.MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'E1')
            		AND A.PLAN_ID = @v_plan_id) B,
               (SELECT SEGMENT1 AS SITE_ID,
                       SEGMENT2 AS FACTORY_ID,
                       SEGMENT3 AS OPERATION_ID,
                       ATTRIBUTE1 AS MIN_BATCH_SIZE
                FROM SY_SCM_SYS_LOOKUP_VALUE
               	WHERE 1=1
               	AND LOOKUP_TYPE_CODE = 'MIN_BATCH_SIZE')C		
        WHERE A.MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'E1')
        AND A.PLAN_ID = @v_plan_id
        AND A.PLAN_ID = B.PLAN_ID
        AND A.OPERATION_ID = 'E1000'
        AND A.ITEM_ID = B.ITEM_ID
        AND LEFT(A.SITE_ID,2) = B.FACTORY_ID
        AND LEFT(A.SITE_ID,2) = C.FACTORY_ID
        AND A.OPERATION_ID = C.OPERATION_ID
        */
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

      END         
      
      BEGIN
      
          SET @v_table_name = 'TH_ENG_ITEM_ROUTE_SITE - EARLY_PRODUCING_TERM UPDATE'
          -- 1차 실행 시 선행 공정 3일 선행 
          UPDATE TH_ENG_ITEM_ROUTE_SITE
          SET    TH_ENG_ITEM_ROUTE_SITE.EARLY_PRODUCING_TERM = CASE WHEN EARLY_PRODUCING_TERM_UOM = 'DAY' 
                                                            			  THEN A.EARLY_PRODUCING_TERM * 24 * 60
                                                            			  WHEN EARLY_PRODUCING_TERM_UOM = 'HOUR' 
                                                            			  THEN A.EARLY_PRODUCING_TERM * 60
                                                            			  WHEN EARLY_PRODUCING_TERM_UOM = 'MINUTE' 
                                                            			  THEN A.EARLY_PRODUCING_TERM
                                                            			  ELSE A.EARLY_PRODUCING_TERM END + 10080,
                 TH_ENG_ITEM_ROUTE_SITE.EARLY_PRODUCING_TERM_UOM = 'MINUTE'                                                                  
          FROM   TH_ENG_ITEM_ROUTE_SITE A,
              	(SELECT 	A.PLAN_ID
              	 FROM TH_MST_PLAN A,
              	      TH_MST_ENG_PLAN_FLAG B
              	 WHERE 1=1
              	 AND A.MASTER_ID = B.MASTER_ID
              	 AND A.PLAN_ID = B.PLAN_ID
              	 AND A.PLAN_ID = @v_plan_id
              	 AND A.PLAN_TYPE = 'PRE'
              	 AND B.DESCR != 'RUN-02') B
          WHERE A.MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE IN ('A','P'))
          --WHERE A.MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'A')
          AND A.PLAN_ID = @v_plan_id
          AND A.PLAN_ID = B.PLAN_ID
          AND A.OPERATION_ID NOT IN ('A5000', 'A9000', 'P5500','P9500')

          --LOG 생성
          SET @v_message = @@ROWCOUNT
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_ITEM_ROUTE_SITE', 'UPDATE', @n_log_count, null, @v_message, null
      
      END
      
      /*
      BEGIN

        SET @v_table_name = 'TH_ENG_ITEM_ROUTE_SITE - EARLY_PRODUCING_TERM CELL UPDATE'

        UPDATE TH_ENG_ITEM_ROUTE_SITE
        SET    TH_ENG_ITEM_ROUTE_SITE.EARLY_PRODUCING_TERM = CASE WHEN EARLY_PRODUCING_TERM_UOM = 'DAY' 
                                                          			  THEN A.EARLY_PRODUCING_TERM * 24 * 60
                                                          			  WHEN EARLY_PRODUCING_TERM_UOM = 'HOUR' 
                                                          			  THEN A.EARLY_PRODUCING_TERM * 60
                                                          			  WHEN EARLY_PRODUCING_TERM_UOM = 'MINUTE' 
                                                          			  THEN A.EARLY_PRODUCING_TERM
                                                          			  ELSE A.EARLY_PRODUCING_TERM END +
                                                             CASE WHEN A.TRANSFER_BATCH_SIZE IS NOT NULL OR A.TRANSFER_BATCH_SIZE != 0 
                                                    		     THEN ISNULL(CEILING((ISNULL(A.TRANSFER_BATCH_SIZE / B.YIELD * B.TACT_TIME, 0)/B.UTILIZATION - ISNULL(A.TRANSFER_BATCH_SIZE / B.YIELD * B.TACT_TIME, 0)) /60),0)
                                                    		     ELSE ISNULL(CEILING((((D.APPLY_LOT_SIZE * C.ACCUMULATED_CHILD_QTY / ISNULL(B.YIELD,1) * B.TACT_TIME) /B.UTILIZATION) - ( (D.APPLY_LOT_SIZE * C.ACCUMULATED_CHILD_QTY / ISNULL(B.YIELD,1) * B.TACT_TIME))) / 60 ), 0)
                                                    		     END,
               TH_ENG_ITEM_ROUTE_SITE.EARLY_PRODUCING_TERM_UOM = 'MINUTE'
        FROM   TH_ENG_ITEM_ROUTE_SITE A
               LEFT OUTER JOIN LGCE_FPDEV_TR.DBO.FP_ITEM_CELL_EXCHANGE_M C
               ON A.ITEM_ID = C.ITEM_ID
               LEFT OUTER JOIN(SELECT DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, APPLY_LOT_SIZE
                        			 FROM   TH_MST_SCM_DEMAND_LOT
                        			 WHERE  1=1
                        			 AND    DPP_PLAN_ID = @v_plan_id) D
               ON LEFT(A.SITE_ID,2) = D.FACTORY_ID
               AND C.MODEL_ID = D.ITEM_ID
               LEFT OUTER JOIN (SELECT A.ITEM_ID, A.SITE_ID, A.ROUTE_ID, 
                            			     A.RESOURCE_MAP_ID, A.RESOURCE_GROUP_ID AS RESOURCE_ID, A.TACT_TIME, A.TACT_TIME_UOM, A.YIELD, B.UTILIZATION, OPERATION_ID
                            		FROM   TH_ENG_OP_RES_GROUP_MAP A,
                            		       TH_ENG_RESOURCE B
                            		WHERE  1=1
                            		AND    A.PLAN_ID = @v_plan_id
                            		AND    A.PLAN_ID = B.PLAN_ID
                            		AND    A.RESOURCE_GROUP_ID = B.RESOURCE_ID) B
              	ON A.ITEM_ID = B.ITEM_ID
                AND A.SITE_ID =B.SITE_ID
                AND A.ROUTE_ID = B.ROUTE_ID
        WHERE A.MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'A')
        AND   A.PLAN_ID = @v_plan_id
        AND   A.OPERATION_ID NOT IN ('A9000', 'A5000')
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

      END         
      */
      /*
      BEGIN

        SET @v_table_name = 'TH_ENG_ITEM_ROUTE_SITE - EARLY_PRODUCING_TERM NO CELL UPDATE'

        UPDATE TH_ENG_ITEM_ROUTE_SITE
        SET    TH_ENG_ITEM_ROUTE_SITE.EARLY_PRODUCING_TERM = CASE WHEN EARLY_PRODUCING_TERM_UOM = 'DAY' 
                                                          			  THEN A.EARLY_PRODUCING_TERM * 24 * 60
                                                          			  WHEN EARLY_PRODUCING_TERM_UOM = 'HOUR' 
                                                          			  THEN A.EARLY_PRODUCING_TERM * 60
                                                          			  WHEN EARLY_PRODUCING_TERM_UOM = 'MINUTE' 
                                                          			  THEN A.EARLY_PRODUCING_TERM
                                                          			  ELSE A.EARLY_PRODUCING_TERM END +
                                                          	 CASE WHEN A.TRANSFER_BATCH_SIZE IS NOT NULL OR A.TRANSFER_BATCH_SIZE != 0 
                                                          	      THEN ISNULL(CEILING((ISNULL(A.TRANSFER_BATCH_SIZE / B.YIELD * B.TACT_TIME, 0)/B.UTILIZATION - ISNULL(A.TRANSFER_BATCH_SIZE / B.YIELD * B.TACT_TIME, 0)) /60),0)
                                                          		    ELSE ISNULL(CEILING((ISNULL((60 * 60 * 24 /B.TACT_TIME) / B.YIELD * B.TACT_TIME, 0)/B.UTILIZATION - ISNULL((60 * 60 * 24 /B.TACT_TIME) / B.YIELD * B.TACT_TIME, 0))/60), 0)
                                                          		    END,
               TH_ENG_ITEM_ROUTE_SITE.EARLY_PRODUCING_TERM_UOM = 'MINUTE'                                                                  
        FROM   TH_ENG_ITEM_ROUTE_SITE A
               LEFT OUTER JOIN (SELECT A.ITEM_ID, A.SITE_ID, A.ROUTE_ID, 
                            			   A.RESOURCE_MAP_ID, A.RESOURCE_GROUP_ID AS RESOURCE_ID, A.TACT_TIME, A.TACT_TIME_UOM, A.YIELD, B.UTILIZATION, OPERATION_ID
                            		FROM TH_ENG_OP_RES_GROUP_MAP A,
                            		     TH_ENG_RESOURCE B
                            		WHERE 1=1
                            		AND A.PLAN_ID = @v_plan_id
                            		AND A.PLAN_ID = B.PLAN_ID
                            		AND A.RESOURCE_GROUP_ID = B.RESOURCE_ID) B
                ON A.ITEM_ID = B.ITEM_ID
                AND A.SITE_ID =B.SITE_ID
                AND A.ROUTE_ID = B.ROUTE_ID
        WHERE A.MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'A')
        AND   A.PLAN_ID = @v_plan_id
        AND   A.OPERATION_ID NOT IN ('E0500', 'E2000', 'E4000', 'S4000', 'P9500')
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @v_description = NULL
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_description

      END   
      */
      
      BEGIN
        -- OFFTIME 감안한 DEMAND 선행 처리 - SYNC
        UPDATE TH_ENG_NET_DEMAND
        SET    TH_ENG_NET_DEMAND.EARLY_PRODUCING_TERM = A.EARLY_PRODUCING_TERM + B.OFFTIME_TERM/24/60                                                  
        FROM   TH_ENG_NET_DEMAND A,
               (		
            		SELECT MASTER_ID, PLAN_ID, DEMAND_ID, DUE_DATE, EARLY_PRODUCING_TERM, SITE_ID, ROUTE_ID, SUM(OFFTIME_TERM) AS OFFTIME_TERM
                FROM (
                  		SELECT DISTINCT MASTER_ID, PLAN_ID, DEMAND_ID, DUE_DATE, EARLY_PRODUCING_TERM, EARLY_PRODUCING_TERM_UOM,
                  				   SITE_ID, ROUTE_ID, START_DTTM, END_DTTM, OFFTIME_TERM, OFFTIME_TERM_UOM
                  		FROM (		
                    				SELECT 	A.MASTER_ID, A.PLAN_ID, A.DEMAND_GROUP_ID,
                    						D.DEMAND_ID, D.DUE_DATE, D.EARLY_PRODUCING_TERM, D.EARLY_PRODUCING_TERM_UOM,
                    						A.PREFERENCE_SITE_ID, A.PREFERENCE_ROUTE_ID,
                    						B.SITE_ID, B.ROUTE_ID, B.RESOURCE_ID, B.OFFTIME_SET_ID, 
                    						C.OFFTIME_SET_ID AS A, C.START_DTTM, C.END_DTTM, C.OFFTIME_TERM, C.OFFTIME_TERM_UOM
                    				FROM TH_ENG_DEMAND_ATTRIBUTE A,
                    					   TH_ENG_RESOURCE B,
                    					   TH_ENG_OFFTIME C,
                    					   TH_ENG_NET_DEMAND D,
                              	(SELECT 	A.PLAN_ID
                              	 FROM TH_MST_PLAN A,
                              	      TH_MST_ENG_PLAN_FLAG B
                              	 WHERE 1=1
                              	 AND A.MASTER_ID = B.MASTER_ID
                              	 AND A.PLAN_ID = B.PLAN_ID
                              	 AND A.PLAN_ID = @v_plan_id
                              	 AND A.PLAN_TYPE = 'SYNC') E                                 
                    				WHERE 1=1
                            AND A.MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE != 'P')
                    				AND A.PLAN_ID = @v_plan_id
                    				AND A.PLAN_ID = B.PLAN_ID
                    				AND A.PLAN_ID = C.PLAN_ID
                    				AND A.PLAN_ID = D.PLAN_ID
                            AND A.PLAN_ID = E.PLAN_ID
                    				AND A.PREFERENCE_SITE_ID = B.SITE_ID
                    				AND A.PREFERENCE_ROUTE_ID = B.ROUTE_ID
                    				AND B.OFFTIME_SET_ID = C.OFFTIME_SET_ID
                    				AND A.DEMAND_GROUP_ID = D.DEMAND_ID
                    				AND D.DUE_DATE >= C.END_DTTM
                    				AND D.DUE_DATE < C.END_DTTM + 2
                    				AND D.EARLY_PRODUCING_TERM = 0) A 
                				) A
                GROUP BY MASTER_ID, PLAN_ID, DEMAND_ID, DUE_DATE, EARLY_PRODUCING_TERM, SITE_ID, ROUTE_ID) B
        WHERE   1=1
        AND     A.PLAN_ID = @v_plan_id
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.DEMAND_ID = B.DEMAND_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_NET_DEMAND - OFFTIME', 'UPDATE', @n_log_count, null, @v_message, null
      
      END
        
      BEGIN
        
        -- MAX TACT UPDATE EPST 계산 시 실제 작업 시간 반영
        UPDATE TH_ENG_OP_RES_GROUP
        SET    TH_ENG_OP_RES_GROUP.MAX_TACT_TIME = A.MAX_TACT_TIME / B.UTILIZATION                                                  
        FROM 	 TH_ENG_OP_RES_GROUP A,
               TH_ENG_RESOURCE B,
            	 TH_ENG_OP_RES_GROUP_MAP C             	 
        WHERE 1=1
        AND   A.MASTER_ID = @v_master_id
        AND   A.PLAN_ID = @v_plan_id
        AND   A.PLAN_ID = B.PLAN_ID
        AND   A.PLAN_ID = C.PLAN_ID
        AND   A.SITE_ID = B.SITE_ID
        AND   A.ROUTE_ID = B.ROUTE_ID
        AND   A.RESOURCE_MAP_ID = C.RESOURCE_MAP_ID
        AND   B.RESOURCE_GROUP_ID = C.RESOURCE_GROUP_ID
        AND   A.OPERATION_ID != 'A6000'
        AND   B.BATCH_TYPE = 'N'

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_OP_RES_GROUP - MAX_TACT', 'UPDATE', @n_log_count, null, @v_message, null        
      
      END
      
      BEGIN
              -- 선분산 ITEM 전극 전 공정에서 자재 처리
        UPDATE TH_ENG_ITEM
        SET    TH_ENG_ITEM.ITEM_TYPE = 'R'                                                           	 
        WHERE 1=1
        AND   MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'E1')
        AND   PLAN_ID = @v_plan_id
        AND   ITEM_ID LIKE 'ASLPD%'

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_ITEM - PMIX ITEM TYPE UPDATE', 'UPDATE', @n_log_count, null, @v_message, null  
      
      END
        
      BEGIN
              -- half sitting tact time 0.0001처리
        UPDATE TH_ENG_OP_RES_GROUP_MAP
        SET    TH_ENG_OP_RES_GROUP_MAP.TACT_TIME = 0.0000000001                                                          	 
        WHERE 1=1
        AND   MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'E1')
        AND   PLAN_ID = @v_plan_id
        AND   OPERATION_ID = 'E2500'
        

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_OP_RES_GROUP_MAP - E2500 CAPA X', 'UPDATE', @n_log_count, null, @v_message, null  
      
      END       
      
      BEGIN
              -- half sitting tact time 0.0001처리
        UPDATE TH_ENG_OP_RES_GROUP
        SET    MIN_TACT_TIME = 0.0000000001,
               AVG_TACT_TIME = 0.0000000001,
               MAX_TACT_TIME = 0.0000000001 
        WHERE 1=1
        AND   MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'E1')
        AND   PLAN_ID = @v_plan_id
        AND   OPERATION_ID = 'E2500'
        

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_OP_RES_GROUP - E2500 CAPA X', 'UPDATE', @n_log_count, null, @v_message, null  
      
      END       
      
      
      BEGIN
        -- 조립 ITEM 제약 해제
        UPDATE TH_ENG_ITEM
        SET    TH_ENG_ITEM.IS_FINITE = 'N'
        FROM   TH_ENG_ITEM A,
               TH_ENG_PLAN_BOM B             
        WHERE   A.MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'A')
        AND     A.PLAN_ID = @v_plan_id
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.CHILD_ITEM_ID
        AND     B.OPERATION_ID = 'A5000'
        

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_OP_RES_GROUP - E2500 CAPA X', 'UPDATE', @n_log_count, null, @v_message, null  
      
      END          
      
      BEGIN
        -- IN MOVING LOT SIZE 삭제 
        UPDATE TH_ENG_ITEM_ROUTE_SITE
        SET    TH_ENG_ITEM_ROUTE_SITE.IN_MOVING_LOT_SIZE = NULL         
        WHERE   MASTER_ID  = @v_master_id
        AND     PLAN_ID = @v_plan_id

        

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_OP_RES_GROUP - E2500 CAPA X', 'UPDATE', @n_log_count, null, @v_message, null  
      
      END    
      
      BEGIN
        -- PACK
        UPDATE TH_ENG_NET_DEMAND
        SET    TH_ENG_NET_DEMAND.PRIORITY_GROUP_CODE = '3::' + PRIORITY_GROUP_CODE,
               TH_ENG_NET_DEMAND.EARLY_PRODUCING_TERM = 7,
               TH_ENG_NET_DEMAND.EARLY_PRODUCING_TERM_UOM = 'DAY'
        FROM TH_ENG_NET_DEMAND A,
        	 TH_ENG_PLAN_BOM B,
        	 TH_ENG_SALES_PRODUCT_MAP C,
           (SELECT 	A.PLAN_ID
              	 FROM TH_MST_PLAN A,
              	      TH_MST_ENG_PLAN_FLAG B
              	 WHERE 1=1
              	 AND A.MASTER_ID = B.MASTER_ID
              	 AND A.PLAN_ID = B.PLAN_ID
              	 AND A.PLAN_ID = @v_plan_id
              	 AND A.PLAN_TYPE = 'SYNC'
              	 AND B.DESCR != 'RUN-02') D
        WHERE A.MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'P')
        AND A.PLAN_ID = @v_plan_id
        AND A.PLAN_ID = B.PLAN_ID
        AND A.PLAN_ID = C.PLAN_ID
        AND B.OPERATION_ID = 'P5500'
        AND A.SALES_MODEL_ID = C.SALES_MODEL_ID
        AND B.PARENT_ITEM_ID = C.PRODUCT_ITEM_ID

        

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_OP_RES_GROUP - E2500 CAPA X', 'UPDATE', @n_log_count, null, @v_message, null  
      
      END          
      /*
      BEGIN
        -- CELL ESS BOD INSERT
        INSERT INTO TH_ENG_BOD
        SELECT @v_master_id AS MASTER_ID,
          	   @v_plan_id AS PLAN_ID,
          	   A.BOD_ID + '^' + B.BOD_ID AS BOD_ID,
          	   A.SITE_ID AS FROM_SITE_ID,
          	   B.SITE_ID AS TO_SITE_ID,
          	   '-' AS TRANSPORT_MODE,
          	   0 AS TRANSPORT_TIME,
          	   'DAY' AS TRANSPORT_TIME_UOM,
          	   C.PLAN_START_DTTM AS BOD_START_TIME,
          	   'DX' AS BOD_PATTERN_ID,
          	   NULL AS FROM_OFFTIME_SET_ID,
          	   NULL AS TO_OFFTIME_SET_ID,
          	   0 AS FIXED_TERM,
          	   'DAY' AS FIXED_TERM_UOM,
          	   NULL AS ATTRIBUTE_SET_ID,
          	   NULL AS ATTRIBUTE_CHECKER_ID,
          	   NULL AS IS_PREV_EPST,
          	   'IST' AS DESCR 
          FROM 
          (SELECT DISTINCT PLAN_ID, SITE_ID + '^' + OPERATION_ID AS BOD_ID, SITE_ID 
          FROM TH_ENG_ITEM_ROUTE_SITE
          WHERE MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'A')
          AND PLAN_ID = @v_plan_id
          AND SITE_ID LIKE 'S2%'
          AND OPERATION_ID = 'A7000') A,
          (SELECT DISTINCT PLAN_ID, SITE_ID + '^' + OPERATION_ID AS BOD_ID, SITE_ID
          FROM TH_ENG_ITEM_ROUTE_SITE
          WHERE MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'A')
          AND PLAN_ID = @v_plan_id
          AND SITE_ID LIKE 'S2%'
          AND OPERATION_ID = 'A8000') B,
          TH_MST_PLAN C
          WHERE 1=1
          AND A.PLAN_ID = B.PLAN_ID
          AND A.PLAN_ID = C.PLAN_ID

        

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_BOD - BOD', 'INSERT', @n_log_count, null, @v_message, null  
      
      END  
      
      BEGIN
        -- CELL ESS BOD INSERT
        INSERT INTO TH_ENG_ITEM_BOD
        SELECT  @v_master_id AS MASTER_ID,
            		@v_plan_id AS PLAN_ID,
            		A.BOD_ID + '^' + B.BOD_ID AS BOD_ID,
            		A.ITEM_ID,
            		1 AS ALT_PRIORITY,
            		1 AS ALT_RATE,
            		-1 AS TRANSFER_LOT_SIZE,
            		NULL AS IS_PREVE_LOT_SIZE,
            		NULL AS IS_PULL,		
            		0 AS PRE_BUFFER_TIME,
            		0 AS POST_BUFFER_TIME,
             		'DAY' AS BUFFER_TIME_UOM,
            		NULL AS	ROUTE_SELECTOR_ID,
            		NULL AS	ATTRIBUTE_SET_ID,
            		0 AS MIN_LOT_SIZE,
            		0 AS MAX_LOT_SIZE,
            		0 AS INCREMENT_LOT_SIZE,
            		0 AS SAFETY_STOCK_TERM,
            		'DAY' AS SAFETY_STOCK_TERM_UOM,
            		0 AS SAFETY_STOCK_QTY,
            		'IST' AS DESCR,
            		NULL AS	FROM_OFFTIME_SET_ID,
            		NULL AS	TO_OFFTIME_SET_ID,
            		NULL AS	EARLY_PRODUCING_TERM,
            		0	EARLY_PRODUCING_TERM_UOM,
            		1 AS PROD_PRIORITY
            FROM 
            (SELECT DISTINCT PLAN_ID, SITE_ID + '^' + OPERATION_ID AS BOD_ID, SITE_ID, ITEM_ID 
            FROM TH_ENG_ITEM_ROUTE_SITE
            WHERE MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'A')
            AND PLAN_ID = @v_plan_id
            AND SITE_ID LIKE 'S2%'
            AND OPERATION_ID = 'A7000') A,
            (SELECT DISTINCT PLAN_ID, SITE_ID + '^' + OPERATION_ID AS BOD_ID, SITE_ID
            FROM TH_ENG_ITEM_ROUTE_SITE
            WHERE MASTER_ID  IN (SELECT DISTINCT INSTANCE_ID FROM SY_FP_INSTANCE_FACTORY_M WHERE INSTANCE_TYPE = 'A')
            AND PLAN_ID = @v_plan_id
            AND SITE_ID LIKE 'S2%'
            AND OPERATION_ID = 'A8000') B
            WHERE 1=1
            AND A.PLAN_ID = B.PLAN_ID       

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_ITEM_BOD - ITEM_BOD', 'INSERT', @n_log_count, null, @v_message, null  
      
      END
      */
      
      BEGIN
        -- OFFTIME 반영  
        UPDATE TH_ENG_OFFTIME
        SET    TH_ENG_OFFTIME.IS_WO_OVERLAP = 'N'
        WHERE   MASTER_ID  = @v_master_id
        AND     PLAN_ID = @v_plan_id
        AND    OFFTIME_TERM >= 1440

        

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_OP_RES_GROUP - E2500 CAPA X', 'UPDATE', @n_log_count, null, @v_message, null  
      
      END      
      /*
      BEGIN
        -- 자재 제약 풀어줄 것
        
        UPDATE TH_ENG_ITEM
        SET    TH_ENG_ITEM.IS_FINITE = 'N'
        WHERE   MASTER_ID  = @v_master_id
        AND     PLAN_ID = @v_plan_id
        AND     ITEM_ID NOT LIKE '%STOCK%'
        
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_OP_RES_GROUP - E2500 CAPA X', 'UPDATE', @n_log_count, null, @v_message, null  
      
      END
      */
      /*
      BEGIN
        -- 자재 제약 풀어줄 것
        
        UPDATE TH_ENG_ITEM
        SET    TH_ENG_ITEM.IS_FINITE = 'N'
        WHERE   MASTER_ID  = @v_master_id
        AND     PLAN_ID = @v_plan_id
        AND     ITEM_ID LIKE '%_R'
        --AND     ITEM_ID NOT LIKE '%STOCK%'
        
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_OP_RES_GROUP - E2500 CAPA X', 'UPDATE', @n_log_count, null, @v_message, null  
      
      END
      */
      BEGIN
        -- 자재 제약 풀어줄 것
        
        DELETE TH_ENG_STOCK_PLAN
        WHERE   MASTER_ID  = @v_master_id
        AND     PLAN_ID = @v_plan_id
        AND     ITEM_ID LIKE 'E%'
        --AND     ITEM_ID NOT LIKE '%STOCK%'
        
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_OP_RES_GROUP - E2500 CAPA X', 'UPDATE', @n_log_count, null, @v_message, null  
      
      END      
      
      /*
        BEGIN
        -- ITEM 
        
        INSERT INTO TH_ENG_ITEM
        SELECT  DISTINCT 
                A.MASTER_ID,
            		A.PLAN_ID,
            		A.CHILD_ITEM_ID,
            		'H' AS ITEM_TYPE,
            		'EA' AS ITEM_UOM,
            		NULL AS FLOW_ID,
            		NULL AS ITEM_GROUP_ID,
            		NULL AS SETUP_GROUP_ID,
            		'N' AS IS_FINITE,
            		0 AS FINITE_TERM,
            		'DAY' AS FINITE_TERM_UOM,
            		0 AS SAFETY_STOCK_QTY,
            		0 AS MAX_STOCK_QTY,
            		0 AS MIN_SAFETY_TERM,
            		'DAY' AS MIN_SAFETY_TERM_UOM,
            		0 AS BEFFER_TIME,
            		'MINUTE' AS BUFFER_TIME_UOM,
            		0 AS MIN_LOT_SIZE,
            		0 AS MAX_LOT_SIZE,
            		0 AS INCREMENT_LOT_SIZE,
            		NULL AS ATTRIBUTE_SET_ID,
            		NULL AS DESCR,
            		1 AS ITEM_UOM_RATE
            FROM TH_ENG_PLAN_BOM A
            WHERE 1=1
            AND A.PLAN_ID =  @v_plan_id
            AND A.CHILD_ITEM_ID LIKE '%_E2500'
                      AND    NOT EXISTS (
                              SELECT 1
                              FROM   TH_ENG_ITEM X
                              WHERE  A.PLAN_ID = X.PLAN_ID
                              AND    A.CHILD_ITEM_ID = X.ITEM_ID
                            )
        
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_OP_RES_GROUP - E2500 CAPA X', 'UPDATE', @n_log_count, null, @v_message, null  
      
      END
      */
      /*
      BEGIN
        -- ITEM 
        
        UPDATE TH_ENG_PLAN_BOM
        SET    TH_ENG_PLAN_BOM.CHILD_ITEM_ID = LEFT(CHILD_ITEM_ID, 17) + '_E4_E2500_R'
        WHERE 1=1
            AND PLAN_ID =  @v_plan_id
            AND CHILD_ITEM_ID LIKE '%_E2500'
        
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_PLAN_BOM - E2500 CAPA X', 'UPDATE', @n_log_count, null, @v_message, null  
      
      END

      BEGIN
        -- ITEM 
        
        DELETE TH_ENG_ITEM_ROUTE_SITE
        WHERE 1=1
            AND PLAN_ID =  @v_plan_id
            AND ITEM_ID LIKE '%_E2500_R_E2500'
        
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_PLAN_BOM - E2500 CAPA X', 'UPDATE', @n_log_count, null, @v_message, null  
      
      END
      
      BEGIN
        -- ITEM 
        
        DELETE TH_ENG_ITEM
        WHERE 1=1
            AND PLAN_ID =  @v_plan_id
            AND ITEM_ID LIKE '%_E2500_R_E2500'
        
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_PLAN_BOM - E2500 CAPA X', 'UPDATE', @n_log_count, null, @v_message, null  
      
      END      
       
     
      BEGIN
        -- ITEM 
        
        DELETE TH_ENG_SALES_PRODUCT_MAP
        WHERE 1=1
            AND PLAN_ID =  @v_plan_id
            --AND OPERATION_ID = N'E3000'
            AND SITE_ID LIKE 'E2%'
            AND SALES_MODEL_ID IN (SELECT DISTINCT A.SALES_MODEL_ID 
                                   FROM TH_ENG_NET_DEMAND A,
                                        TH_OUT_PROBLEM_REPORT B
                                   WHERE A.MASTER_ID = B.MASTER_ID AND A.PLAN_ID = B.PLAN_ID AND A.DEMAND_ID = B.DEMAND_ID
                                   AND   A.MASTER_ID      = @v_master_id AND A.PLAN_ID =  'KR_E_POST-20170402-16' AND B.NODE_ID LIKE '%##E2^%'
                                   AND B.PROBLEM_TYPE = 'UNPLAN')
                                   
        DELETE TH_ENG_SALES_PRODUCT_MAP
        WHERE 1=1
            AND PLAN_ID =  @v_plan_id
            --AND OPERATION_ID = N'E3000'
            AND SITE_ID LIKE 'E4%'
            AND SALES_MODEL_ID IN (SELECT DISTINCT A.SALES_MODEL_ID 
                                   FROM TH_ENG_NET_DEMAND A,
                                        TH_OUT_PROBLEM_REPORT B
                                   WHERE A.MASTER_ID = B.MASTER_ID AND A.PLAN_ID = B.PLAN_ID AND A.DEMAND_ID = B.DEMAND_ID
                                   AND   A.MASTER_ID      = @v_master_id AND A.PLAN_ID =  'KR_E_POST-20170402-16' AND B.NODE_ID LIKE '%##E4^%'
                                   AND B.PROBLEM_TYPE = 'UNPLAN')                                   
        
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_SALES_PRODUCT_MAP - E2', 'DELETE', @n_log_count, null, @v_message, null  
      
      END  
      */
      
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
      
      ----------------------------------------------------------------------------------------
      -- TEST TARGET : 전,후공정 전용 - START
      ----------------------------------------------------------------------------------------
      IF    CHARINDEX('E_PRE' , @v_master_id ) > 0 
        OR  CHARINDEX('E_POST', @v_master_id ) > 0
      BEGIN
      
        INSERT INTO TH_ENG_SALES_PRODUCT_MAP
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.ITEM_ID AS SALES_MODEL_ID
             , A.ITEM_ID AS PRODUCT_ITEM_ID
             , SITE_ID
             , 1 ALT_PRIORITY
             , 1 ALT_RATE
             , NULL DESCR
        FROM   (
                SELECT *
                FROM   TH_ENG_ITEM_ROUTE_SITE A
                WHERE  A.MASTER_ID = @v_master_id
                AND    A.PLAN_ID   = @v_plan_id
               ) A,
               (
                SELECT DISTINCT
                       ITEM_ID, TO_FACTORY_ID, LINE_ID, OPERATION_ID
                FROM   TH_MST_SCM_DEMAND A
                WHERE  A.INSTANCE_ID = @v_master_id
                AND    A.DPP_PLAN_ID = @v_plan_id
                AND    A.OPERATION_ID IS NOT NULL             -- OPERATION 이 지정된  타겟에 해당됨
                AND    NOT EXISTS (
                                    SELECT 1
                                    FROM   (
                                            SELECT ITEM_ID, FACTORY_ID
                                                 , MAX(OPERATION_ID) AS OPERATION_ID
                                            FROM   TH_MST_INSTANCE_FLOW 
                                            WHERE  MASTER_ID    = @v_master_id
                                            AND    PLAN_ID      = @v_plan_id
                                            GROUP  BY ITEM_ID, FACTORY_ID
                                           ) X
                                    WHERE  X.ITEM_ID      = A.ITEM_ID
                                    AND    X.FACTORY_ID   = A.TO_FACTORY_ID
                                    AND    X.OPERATION_ID = A.OPERATION_ID
                                  )
               ) B
        WHERE  A.ITEM_ID      LIKE B.ITEM_ID +'%'
        AND    A.SITE_ID      LIKE B.TO_FACTORY_ID +'%'
        AND    A.ROUTE_ID     LIKE B.LINE_ID +'%'
        AND    A.OPERATION_ID LIKE B.OPERATION_ID +'%'
        AND    NOT EXISTS (
                            SELECT 1
                            FROM   TH_ENG_SALES_PRODUCT_MAP X
                            WHERE  X.MASTER_ID        = A.MASTER_ID
                            AND    X.PLAN_ID          = A.PLAN_ID
                            AND    X.SALES_MODEL_ID   = A.ITEM_ID
                            AND    X.PRODUCT_ITEM_ID  = A.ITEM_ID
                            AND    X.SITE_ID          = A.SITE_ID
                          )
      
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_SALES_PRODUCT_MAP - TEST', 'INSERT', @n_log_count, null, @v_message, null  

        INSERT INTO TH_ENG_SALES_MODEL
        SELECT DISTINCT
               A.MASTER_ID
             , A.PLAN_ID
             , A.ITEM_ID AS SALES_MODEL_ID
             , NULL DESCR
             , NULL PRIORITY
        FROM   (
                SELECT *
                FROM   TH_ENG_ITEM_ROUTE_SITE A
                WHERE  A.MASTER_ID = @v_master_id
                AND    A.PLAN_ID   = @v_plan_id
               ) A,
               (
                SELECT DISTINCT
                       ITEM_ID, TO_FACTORY_ID, LINE_ID, OPERATION_ID
                FROM   TH_MST_SCM_DEMAND A
                WHERE  A.INSTANCE_ID = @v_master_id
                AND    A.DPP_PLAN_ID = @v_plan_id
                AND    A.OPERATION_ID IS NOT NULL             -- OPERATION 이 지정된  타겟에 해당됨
                AND    NOT EXISTS (
                                    SELECT 1
                                    FROM   (
                                            SELECT ITEM_ID, FACTORY_ID
                                                 , MAX(OPERATION_ID) AS OPERATION_ID
                                            FROM   TH_MST_INSTANCE_FLOW 
                                            WHERE  MASTER_ID    = @v_master_id
                                            AND    PLAN_ID      = @v_plan_id
                                            GROUP  BY ITEM_ID, FACTORY_ID
                                           ) X
                                    WHERE  X.ITEM_ID      = A.ITEM_ID
                                    AND    X.FACTORY_ID   = A.TO_FACTORY_ID
                                    AND    X.OPERATION_ID = A.OPERATION_ID
                                  )
               ) B
        WHERE  A.ITEM_ID      LIKE B.ITEM_ID +'%'
        AND    A.SITE_ID      LIKE B.TO_FACTORY_ID +'%'
        AND    A.ROUTE_ID     LIKE B.LINE_ID +'%'
        AND    A.OPERATION_ID LIKE B.OPERATION_ID +'%'
        AND    NOT EXISTS (
                            SELECT 1
                            FROM   TH_ENG_SALES_MODEL X
                            WHERE  X.MASTER_ID        = A.MASTER_ID
                            AND    X.PLAN_ID          = A.PLAN_ID
                            AND    X.SALES_MODEL_ID   = A.ITEM_ID
                          )

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_SALES_MODEL - TEST', 'INSERT', @n_log_count, null, @v_message, null  

      
        UPDATE TH_ENG_NET_DEMAND
        SET    TH_ENG_NET_DEMAND.SALES_MODEL_ID = B.SALES_MODEL_ID
        FROM   TH_ENG_NET_DEMAND A,
               (
                SELECT A.MASTER_ID
                     , A.PLAN_ID
                     , A.ITEM_ID AS SALES_MODEL_ID
                     , B.SCP_TARGET_ID
                FROM   (
                        SELECT *
                        FROM   TH_ENG_ITEM_ROUTE_SITE A
                        WHERE  A.MASTER_ID = @v_master_id
                        AND    A.PLAN_ID   = @v_plan_id
                       ) A,
                       (
                        SELECT DISTINCT
                               SCP_TARGET_ID, ITEM_ID, TO_FACTORY_ID, LINE_ID, OPERATION_ID
                        FROM   TH_MST_SCM_DEMAND A
                        WHERE  A.INSTANCE_ID = @v_master_id
                        AND    A.DPP_PLAN_ID = @v_plan_id
                        AND    A.OPERATION_ID IS NOT NULL             -- OPERATION 이 지정된  타겟에 해당됨
                        AND    NOT EXISTS (
                                            SELECT 1
                                            FROM   (
                                                    SELECT ITEM_ID, FACTORY_ID
                                                         , MAX(OPERATION_ID) AS OPERATION_ID
                                                    FROM   TH_MST_INSTANCE_FLOW 
                                                    WHERE  MASTER_ID    = @v_master_id
                                                    AND    PLAN_ID      = @v_plan_id
                                                    GROUP  BY ITEM_ID, FACTORY_ID
                                                   ) X
                                            WHERE  X.ITEM_ID      = A.ITEM_ID
                                            AND    X.FACTORY_ID   = A.TO_FACTORY_ID
                                            AND    X.OPERATION_ID = A.OPERATION_ID
                                          )
                       ) B
                WHERE  A.ITEM_ID      LIKE B.ITEM_ID +'%'
                AND    A.SITE_ID      LIKE B.TO_FACTORY_ID +'%'
                AND    A.ROUTE_ID     LIKE B.LINE_ID +'%'
                AND    A.OPERATION_ID LIKE B.OPERATION_ID +'%'
               ) B
        WHERE  A.MASTER_ID  = @v_master_id
        AND    A.PLAN_ID    = @v_plan_id
        AND    A.DEMAND_ID  LIKE B.SCP_TARGET_ID +'%'

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_NET_DEMAND - TEST', 'UPDATE', @n_log_count, null, @v_message, null  


        INSERT INTO TH_ENG_DEMAND_ATTRIBUTE
             (
               MASTER_ID
             , PLAN_ID
             , DEMAND_GROUP_ID
             , PREFERENCE_SITE_ID
             , PREFERENCE_PRODUCT_ID
             , IS_HARD_PREFERENCE
             )
        SELECT A.MASTER_ID
             , A.PLAN_ID
             , B.DEMAND_ID    AS DEMAND_GROUP_ID
             , MAX(A.SITE_ID) AS PREFERENCE_SITE_ID
             , MAX(A.ITEM_ID) AS PREFERENCE_PRODUCT_ID
             , 'Y'            AS IS_HARD_PREFERENCE
        FROM   (
                SELECT *
                FROM   TH_ENG_ITEM_ROUTE_SITE A
                WHERE  A.MASTER_ID = @v_master_id
                AND    A.PLAN_ID   = @v_plan_id
               ) A,
               (
                SELECT B.MASTER_ID
                     , B.PLAN_ID
                     , B.DEMAND_ID
                     , A.ITEM_ID
                     , A.TO_FACTORY_ID 
                     , A.LINE_ID
                     , A.OPERATION_ID
                FROM   TH_MST_SCM_DEMAND A,
                       TH_ENG_NET_DEMAND B
                WHERE  A.INSTANCE_ID  = @v_master_id
                AND    A.DPP_PLAN_ID  = @v_plan_id
                AND    A.OPERATION_ID IS NOT NULL             -- OPERATION 이 지정된  타겟에 해당됨
                AND    A.INSTANCE_ID  = B.MASTER_ID
                AND    A.DPP_PLAN_ID  = B.PLAN_ID
                AND    B.DEMAND_ID    LIKE A.SCP_TARGET_ID +'%'
                AND    NOT EXISTS (
                                    SELECT 1
                                    FROM   (
                                            SELECT ITEM_ID, FACTORY_ID
                                                 , MAX(OPERATION_ID) AS OPERATION_ID
                                            FROM   TH_MST_INSTANCE_FLOW 
                                            WHERE  MASTER_ID    = @v_master_id
                                            AND    PLAN_ID      = @v_plan_id
                                            GROUP  BY ITEM_ID, FACTORY_ID
                                           ) X
                                    WHERE  X.ITEM_ID      = A.ITEM_ID
                                    AND    X.FACTORY_ID   = A.TO_FACTORY_ID
                                    AND    X.OPERATION_ID = A.OPERATION_ID
                                  )
               ) B
        WHERE  A.ITEM_ID      LIKE B.ITEM_ID +'%'
        AND    A.SITE_ID      LIKE B.TO_FACTORY_ID +'%'
        AND    A.ROUTE_ID     LIKE B.LINE_ID +'%'
        AND    A.OPERATION_ID LIKE B.OPERATION_ID +'%'
        AND    NOT EXISTS ( -- 중복 제거
                            SELECT 1
                            FROM   TH_ENG_DEMAND_ATTRIBUTE X
                            WHERE  X.MASTER_ID        = A.MASTER_ID
                            AND    X.PLAN_ID          = A.PLAN_ID
                            AND    X.DEMAND_GROUP_ID  = B.DEMAND_ID
                          )
        GROUP  BY 
               A.MASTER_ID
             , A.PLAN_ID
             , B.DEMAND_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_DEMAND_ATTRIBUTE - TEST', 'UPDATE', @n_log_count, null, @v_message, null  


        DECLARE @N_STOCK_SEQ        INTEGER
              , @V_PLAN_START_DTTM  DATETIME
        
        SELECT  @N_STOCK_SEQ = MAX(STOCK_SEQ)
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
             , ROUTE_ID
             , OPERATION_ID
             , RECEIVING_DTTM
             , QTY
             , LOT_ID
             , DEMAND_ID
             , STOCK_STATUS
             , DESCR
             )
        SELECT A.MASTER_ID
             , A.PLAN_ID
             , @n_stock_seq + ROW_NUMBER() OVER (ORDER BY B.DEMAND_ID
                                                        , A.PARENT_ITEM_ID
                                                        , A.CHILD_ITEM_ID
                                                        , A.SITE_ID
                                                        , A.ROUTE_ID
                                                        , A.OPERATION_ID
                                                        , A.ALT_ID
                                                        , A.ALT_PRIORITY)
               AS STOCK_SEQ
             , A.CHILD_ITEM_ID        AS ITEM_ID
             , A.SITE_ID              AS SITE_ID
             , A.ROUTE_ID             AS ROUTE_ID
             , A.OPERATION_ID         AS OPERATION_ID
             , @v_plan_start_dttm     AS RECEIVING_DTTM
             , B.MFG_QTY * A.CHILD_ITEM_RATE * 2  QTY
             , 'LOT'+'_'+TARGET_TYPE  AS LOT_ID
             , B.DEMAND_ID      
             , 'WIP'                  AS STOCK_STATUS
             , TARGET_TYPE + '_TARGET_TYPE' AS DESCR
        FROM   (
                SELECT *
                FROM   TH_ENG_PLAN_BOM A
                WHERE  A.MASTER_ID = @v_master_id
                AND    A.PLAN_ID   = @v_plan_id
               ) A,
               (
                SELECT B.DEMAND_ID, A.*
                FROM   TH_MST_SCM_DEMAND A,
                       TH_ENG_NET_DEMAND B
                WHERE  A.INSTANCE_ID  = @v_master_id
                AND    A.DPP_PLAN_ID  = @v_plan_id
                AND    A.OPERATION_ID IS NOT NULL             -- OPERATION 이 지정된  타겟에 해당됨
                AND    A.INSTANCE_ID  = B.MASTER_ID
                AND    A.DPP_PLAN_ID  = B.PLAN_ID
                AND    B.DEMAND_ID    LIKE A.SCP_TARGET_ID +'%'
                AND    NOT EXISTS (
                                    SELECT 1
                                    FROM   (
                                            SELECT ITEM_ID, FACTORY_ID
                                                 , MAX(OPERATION_ID) AS OPERATION_ID
                                            FROM   TH_MST_INSTANCE_FLOW 
                                            WHERE  MASTER_ID    = @v_master_id
                                            AND    PLAN_ID      = @v_plan_id
                                            GROUP  BY ITEM_ID, FACTORY_ID
                                           ) X
                                    WHERE  X.ITEM_ID      = A.ITEM_ID
                                    AND    X.FACTORY_ID   = A.TO_FACTORY_ID
                                    AND    X.OPERATION_ID = A.OPERATION_ID
                                  )
               ) B
        WHERE  A.PARENT_ITEM_ID LIKE B.ITEM_ID +'%'
        AND    A.SITE_ID        LIKE B.TO_FACTORY_ID +'%'
        AND    A.ROUTE_ID       LIKE B.LINE_ID +'%'
        AND    A.OPERATION_ID   LIKE B.OPERATION_ID +'%'

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_ENG_STOCK_PLAN - TEST', 'INSERT', @n_log_count, null, @v_message, null  

      END
      ----------------------------------------------------------------------------------------
      -- TEST TARGET : 전,후공정 전용 - END
      ----------------------------------------------------------------------------------------
      
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
