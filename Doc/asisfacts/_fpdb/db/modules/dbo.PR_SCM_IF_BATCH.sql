CREATE PROCEDURE [dbo].[PR_SCM_IF_BATCH]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_BATCH                                                           **/
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
  EXEC PR_SCM_IF_BATCH
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_BATCH'
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
      
      BEGIN
      
        SET @v_table_name = 'TH_MST_BATCH_INFO'
        
        DELETE FROM TH_MST_BATCH_INFO
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id
        
        INSERT INTO TH_MST_BATCH_INFO
        SELECT DISTINCT
               C.MASTER_ID
             , C.PLAN_ID
             , C.RESOURCE_ID AS BATCH_RES_GROUP_ID
             , B.BATCH_ID AS BATCH_GROUP_ID
             , A.ITEM_ID
             , A.FACTORY_ID AS SITE_ID
             , FLOOR(
                        A.BATCH_LOT_SIZE
                        --* ( CASE WHEN ISNULL(C.YIELD, 0.0) = 0   THEN 1
                        --         WHEN ISNULL(C.YIELD, 0.0) > 1.0 THEN 1
                        --         ELSE ISNULL(C.YIELD, 0.0)
                        --    END )
                      ) AS MAX_BATCH_QTY 
             --, TAT AS BATCH_TIME
             , CASE UPPER(TAT_UOM) WHEN 'MIN' THEN TAT
                                   WHEN 'MINUTE' THEN TAT
                                   WHEN 'SEC' THEN TAT
                                   WHEN 'SECOND' THEN TAT
                                   WHEN 'HOUR' THEN TAT
                                   ELSE TAT 
               END AS BATCH_TIME
             , CASE UPPER(TAT_UOM) WHEN 'MIN' THEN 'MINUTE'
                                   WHEN 'SEC' THEN 'SECOND'
                                   ELSE UPPER(TAT_UOM)
               END  AS BATCH_TIME_UOM
             , 1 PREFER_RATIO
             , A.WAIT_TOLERANCE_TIME
             , A.WAIT_TOLERANCE_TIME_UOM
             , NULL          AS DESCR
             , @key_date     AS KEY_DATE
             , @v_proc_name  AS INSERT_ID
             , sysdatetime() AS INSERT_DATE
             , @v_proc_name  AS UPDATE_ID
             , sysdatetime() AS UPDATE_DATE             
        FROM   SY_SCM_ITEM_EQUIP_RATE_BATCH_M A,
               SY_SCM_BATCH_M                 B,
               TH_MST_OP_RESOURCE             C
        WHERE  1=1
        AND    A.ACTIVE_FLAG = 'Y'
        AND    A.COMPANY_ID = B.COMPANY_ID
        AND    A.DIVISION_ID = B.DIVISION_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.PLANT_ID = B.PLANT_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.FACTORY_ID = C.SITE_ID
        AND    A.ITEM_ID = C.ITEM_ID
        AND    C.MASTER_ID   = @v_master_id
        AND    C.PLAN_ID     = @v_plan_id
        AND    EXISTS ( 
                        SELECT 1
                        FROM   SY_SCM_OPERATION_M X
                        WHERE  X.COMPANY_ID = A.COMPANY_ID
                        AND    X.DIVISION_ID = A.DIVISION_ID
                        AND    X.SITE_ID = A.SITE_ID
                        AND    X.OPERATION_ID = A.OPERATION_ID
                        AND    X.CAPA_TYPE = 'BATCH'              -- BATCH OPERATION 만 대상
                      )
        UNION  ALL
        SELECT DISTINCT
               C.MASTER_ID
             , C.PLAN_ID
             , C.RESOURCE_ID AS BATCH_RES_GROUP_ID
             , A.ITEM_ID AS BATCH_GROUP_ID
             , A.ITEM_ID
             , A.FACTORY_ID AS SITE_ID
             , FLOOR(
                        A.BATCH_LOT_SIZE
                        --* ( CASE WHEN ISNULL(C.YIELD, 0.0) = 0   THEN 1
                        --         WHEN ISNULL(C.YIELD, 0.0) > 1.0 THEN 1
                        --         ELSE ISNULL(C.YIELD, 0.0)
                        --    END )
                      ) AS MAX_BATCH_QTY 
             --, TAT AS BATCH_TIME
             , CASE UPPER(TAT_UOM) WHEN 'MIN' THEN TAT
                                   WHEN 'MINUTE' THEN TAT
                                   WHEN 'SEC' THEN TAT
                                   WHEN 'SECOND' THEN TAT
                                   WHEN 'HOUR' THEN TAT
                                   ELSE TAT 
               END AS BATCH_TIME
             , CASE UPPER(TAT_UOM) WHEN 'MIN' THEN 'MINUTE'
                                   WHEN 'SEC' THEN 'SECOND'
                                   ELSE UPPER(TAT_UOM)
               END  AS BATCH_TIME_UOM
             , 1 PREFER_RATIO
             , A.WAIT_TOLERANCE_TIME
             , A.WAIT_TOLERANCE_TIME_UOM
             , NULL          AS DESCR
             , @key_date     AS KEY_DATE
             , @v_proc_name  AS INSERT_ID
             , sysdatetime() AS INSERT_DATE
             , @v_proc_name  AS UPDATE_ID
             , sysdatetime() AS UPDATE_DATE             
        FROM   SY_SCM_ITEM_EQUIP_RATE_BATCH_M A,
               TH_MST_OP_RESOURCE             C
        WHERE  1=1
        AND    A.ACTIVE_FLAG = 'Y'
        AND    A.FACTORY_ID = C.SITE_ID
        AND    A.ITEM_ID = C.ITEM_ID
        AND    C.MASTER_ID   = @v_master_id
        AND    C.PLAN_ID     = @v_plan_id
        AND    EXISTS ( 
                        SELECT 1
                        FROM   SY_SCM_OPERATION_M X
                        WHERE  X.COMPANY_ID = A.COMPANY_ID
                        AND    X.DIVISION_ID = A.DIVISION_ID
                        AND    X.SITE_ID = A.SITE_ID
                        AND    X.OPERATION_ID = A.OPERATION_ID
                        AND    X.CAPA_TYPE = 'BATCH'              -- BATCH OPERATION 만 대상
                      )
        AND    NOT EXISTS  (
                            SELECT 1
                            FROM   SY_SCM_BATCH_M B
                            WHERE  1=1
                            AND    A.COMPANY_ID = B.COMPANY_ID
                            AND    A.DIVISION_ID = B.DIVISION_ID
                            AND    A.SITE_ID = B.SITE_ID
                            AND    A.PLANT_ID = B.PLANT_ID
                            AND    A.ITEM_ID = B.ITEM_ID
                           )
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        /*
        SET @v_table_name = 'TH_MST_BATCH_INFO_CAL'

        DELETE  FROM TH_MST_BATCH_INFO_CAL
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id

        INSERT INTO TH_MST_BATCH_INFO_CAL
              (
                MASTER_ID
              , PLAN_ID
              , BATCH_RES_GROUP_ID
              , BATCH_GROUP_ID
              , ITEM_ID
              , SITE_ID
              , START_DTTM
              , END_DTTM
              , MAX_BATCH_QTY
              , BATCH_TIME
              , BATCH_TIME_UOM
              , PREFER_RATIO
              , WAIT_TOLERANCE_TIME
              , WAIT_TOLERANCE_TIME_UOM
              , DESCR
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM
              )
        SELECT  DISTINCT
                A.MASTER_ID
              , A.PLAN_ID
              , A.BATCH_RES_GROUP_ID
              , A.BATCH_GROUP_ID
              , A.ITEM_ID
              , A.SITE_ID
              , C.START_DATE
              , C.END_DATE
              , 0 AS MAX_BATCH_QTY
              , A.BATCH_TIME
              , A.BATCH_TIME_UOM
              , A.PREFER_RATIO
              , A.WAIT_TOLERANCE_TIME
              , A.WAIT_TOLERANCE_TIME_UOM
              , '' DESCR
              , A.KEY_DATE
              , @v_proc_name      AS INSERT_ID
              , GETDATE()         AS INSERT_DTTM
              , @v_proc_name      AS UPDATE_ID
              , GETDATE()         AS UPDATE_DTTM
        FROM    TH_MST_BATCH_INFO       A,
                TH_MST_RESOURCE         B,
                TH_MST_OP_RESOURCE_CAL  C
        WHERE   A.MASTER_ID           = @v_master_id
        AND     A.PLAN_ID             = @v_plan_id
        AND     A.MASTER_ID           = B.MASTER_ID
        AND     A.PLAN_ID             = B.PLAN_ID
        AND     A.BATCH_RES_GROUP_ID  = B.BATCH_RES_GROUP_ID
        AND     A.MASTER_ID           = C.MASTER_ID
        AND     A.PLAN_ID             = C.PLAN_ID
        AND     A.ITEM_ID             = C.ITEM_ID
        AND     B.RESOURCE_ID         = C.RESOURCE_ID
        AND     C.ALT_PRIORITY NOT IN (1,2,3,4,5,6,7,8)
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        */

      END
      
      -- ITEM GROUP ID 설정 - SULLY 기반 정보 설정 ( BATCH )
      BEGIN

        SET @v_table_name = 'TH_MST_ITEM - ITEM_GROUP_ID'

        UPDATE TH_MST_ITEM
        SET    TH_MST_ITEM.ITEM_GROUP_ID = C.BATCH_GROUP_ID
        FROM   TH_MST_ITEM A,
               TH_MST_PLAN_BOM B,
               TH_MST_BATCH_INFO C
        WHERE  A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.ITEM_ID        = B.PARENT_ITEM_ID
        AND    A.MASTER_ID      = C.MASTER_ID
        AND    A.PLAN_ID        = C.PLAN_ID
        AND    B.CHILD_ITEM_ID  = C.ITEM_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
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
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
