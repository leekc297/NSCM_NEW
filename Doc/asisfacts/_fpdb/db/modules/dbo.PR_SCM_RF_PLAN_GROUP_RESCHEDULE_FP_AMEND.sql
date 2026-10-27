CREATE PROCEDURE [dbo].[PR_SCM_RF_PLAN_GROUP_RESCHEDULE_FP_AMEND]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-', @p_plan_group_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_RF_PLAN_GROUP_RESCHEDULE_FP_AMEND                                  **/
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
/** 2016.01.01    COCHO          최초 작성                                                    **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_RF_PLAN_GROUP_RESCHEDULE_FP_AMEND
  

*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_top_plan_id    nvarchar(30)
  DECLARE @n_count          integer = 0
  DECLARE @v_plan_date      nvarchar(10)
  DECLARE @plan_type        nvarchar(30)
  DECLARE @v_plan_group_id  nvarchar(30)

  DECLARE @v_prod_plan_id   nvarchar(30)
  DECLARE @v_ship_plan_id   nvarchar(30)
  
  DECLARE @v_basis_plan_id  nvarchar(30)
  
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_RF_PLAN_GROUP_RESCHEDULE_FP_AMEND'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @v_assign_cnt     Integer  = 1
  
  DECLARE @n_loop           int
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)

  DECLARE @v_temp1        nvarchar(1000)
  DECLARE @v_temp2        nvarchar(1000)
  
  DECLARE @v_daydiff        Integer

  DECLARE @v_is_wo_merge        nvarchar(5)
  
  -------------------------------------------------------------------------------------------
  -- LINE 인지 EQUIPMENT 인지 설정하는 변수... 아주 중요
  -------------------------------------------------------------------------------------------
   DECLARE @res_category      nvarchar(10)
  -------------------------------------------------------------------------------------------

  SET @v_master_id      = @p_master_id
  SET @v_plan_id        = @p_plan_id
  SET @v_plan_group_id  = @p_plan_group_id

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    
    -- 필수 DATA 쿼리.. 반듯이 있어야 함.
    BEGIN

      SET @v_table_name = 'SCM_FP_PLAN_H'
      SET @v_basis_plan_id = NULL

      SELECT @plan_type = PLAN_TYPE
           , @plan_start_time = PLAN_START_TIME
           , @plan_end_time = (
                                CASE  WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_TIME)
                                      WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_TIME)
                                      WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_TIME)
                                                                      ELSE DATEADD(DD, PLAN_HORIZON,     PLAN_START_TIME)
                                END  
                              )
           , @key_date = CONVERT(NVARCHAR, PLAN_START_TIME, 112)
           , @v_daydiff = DATEDIFF(MINUTE,CONVERT(DATE,PLAN_START_TIME), PLAN_START_TIME)
      FROM   SCM_FP_PLAN_H WITH(NOLOCK)
      WHERE  INSTANCE_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
      
      --LOG 생성
      SET @v_message = 'PLAN_GROUP_ID : ' + @v_plan_group_id
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null

      --LOG 생성
      SET @v_message = '@v_basis_plan_id : ' + @v_basis_plan_id
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null

      SET @v_table_name = 'FP_INSTANCE_CONFIG_M'

      SELECT  @res_category = isnull(max(key_value), 'LINE')
      FROM    FP_INSTANCE_CONFIG_M WITH(NOLOCK)
      WHERE   instance_id = @v_master_id
      AND     category_id = 'RESOURCE_CATEGORY'
      AND     KEY_ID = @plan_type

      --LOG 생성
      SET @v_message = '@res_category : ' + @res_category
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      --LOG 생성
      SET @v_table_name = 'FP_INSTANCE_CONFIG_M'
      SET @v_is_wo_merge = 'N'

      SELECT 
             @v_is_wo_merge = MAX(ISNULL(KEY_VALUE,'N'))
      FROM   FP_INSTANCE_CONFIG_M WITH(NOLOCK)
      WHERE  INSTANCE_ID = @v_master_id
      AND    CATEGORY_ID = 'WO_MERGE'
      AND    KEY_ID = 'WO_MERGE'            
             
      --LOG 생성
      SET @v_message = 'IS_WO_MERGE : ' + @v_is_wo_merge
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

    END;
    
    BEGIN

      SET @v_table_name = 'FP_AMEND_PRODUCTION_PLAN_R'

      DECLARE @n_amend_count  Integer  = 0
      
      SELECT @n_amend_count = COUNT(*)
      FROM   FP_AMEND_PRODUCTION_PLAN_R A WITH(NOLOCK)
           , SCM_LINE_M                 B WITH(NOLOCK)
      WHERE  A.MASTER_ID          = @v_master_id
      AND    A.PLAN_ID            = @v_plan_id
      AND    A.UI_EDIT_YN         = 'Y'
      AND    A.AFTER_SITE_ID      = B.FACTORY_ID
      AND    A.AFTER_ROUTE_ID     = B.LINE_ID
      AND    A.AFTER_OPERATION_ID = B.OPERATION_ID
      AND    B.MODEL_TYPE         = @v_plan_group_id
      
      --LOG 생성
      SET @v_message = '@n_amend_count : ' + CONVERT(NVARCHAR, @n_amend_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

    END
    
      IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'C_PLAN')
      BEGIN
          CLOSE C_PLAN
          DEALLOCATE C_PLAN
      END
      
      IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'C_BATCH')
      BEGIN
          CLOSE C_BATCH
          DEALLOCATE C_BATCH
      END


    -----------------------------------------------
    -- PLAN_IN_QTY 소수점 처리 부분    
    -----------------------------------------------
    BEGIN

      SET @v_table_name = 'FP_AMEND_PRODUCTION_PLAN_R'

      -- AFTER_IN_QTY 올림처리
      UPDATE FP_AMEND_PRODUCTION_PLAN_R
      SET    FP_AMEND_PRODUCTION_PLAN_R.AFTER_IN_QTY = CEILING(A.AFTER_IN_QTY)
      FROM   FP_AMEND_PRODUCTION_PLAN_R A,
             SCM_LINE_M                 B WITH(NOLOCK)
      WHERE  A.MASTER_ID          = @v_master_id
      AND    A.PLAN_ID            = @v_plan_id
      AND    A.AFTER_SITE_ID      = B.FACTORY_ID
      AND    A.AFTER_ROUTE_ID     = B.LINE_ID
      AND    A.AFTER_OPERATION_ID = B.OPERATION_ID
      AND    A.UI_EDIT_YN         = 'Y'
      AND    EXISTS (
                      SELECT 1
                      FROM   FP_AMEND_ITEM X WITH(NOLOCK)
                      WHERE  X.MASTER_ID  = A.MASTER_ID
                      AND    X.PLAN_ID    = A.PLAN_ID
                      AND    X.ITEM_ID    = A.ITEM_ID
                      AND    X.ITEM_UOM   = 'EA'
                    )
    
      --LOG 생성
      SET @v_message = 'CEILING(A.AFTER_IN_QTY) : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

    END

    -----------------------------------------------
    -- BUFFER TABLE 7일 전 데이터 삭제
    -----------------------------------------------
    BEGIN

      SET @v_table_name = 'TH_BUF_SCM_RESCHEDULE_APG - ALL TABLE'
      
      DELETE FROM TH_BUF_SCM_RESCHEDULE_APG_PLAN          WHERE INSERT_TIME < DATEADD(DAY, -7, GETDATE())
      DELETE FROM TH_BUF_SCM_RESCHEDULE_APG_INFO          WHERE INSERT_TIME < DATEADD(DAY, -7, GETDATE())
      DELETE FROM TH_BUF_SCM_RESCHEDULE_APG_RESULT        WHERE INSERT_TIME < DATEADD(DAY, -7, GETDATE())
      DELETE FROM TH_BUF_SCM_RESCHEDULE_APG_CALENDAR      WHERE INSERT_TIME < DATEADD(DAY, -7, GETDATE())
      DELETE FROM TH_BUF_SCM_RESCHEDULE_APG_BOR           WHERE INSERT_TIME < DATEADD(DAY, -7, GETDATE())
      DELETE FROM TH_BUF_SCM_RESCHEDULE_APG_SETUP_MATRIX  WHERE INSERT_TIME < DATEADD(DAY, -7, GETDATE())

      SET @n_row_count = @@ROWCOUNT

      --LOG 생성
      SET @v_message = CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      WAITFOR DELAY '0:0:1'

    END
    
    IF @n_amend_count > 0 -- 조정했으면,,, 시간 재계산, 안했으면 리스케쥴 하지 않는다.
    BEGIN
    
      BEGIN

        DELETE FROM TH_BUF_SCM_RESCHEDULE_APG_INFO WHERE  MASTER_ID = @v_master_id and plan_id = @v_plan_id and plan_group_id = @v_plan_group_id
        
        DELETE FROM TH_BUF_SCM_RESCHEDULE_APG_PLAN WHERE  MASTER_ID = @v_master_id and plan_id = @v_plan_id and plan_group_id = @v_plan_group_id
      
        ------------------------------------------------
        -- 대상 WORK 집계전의 WORK ORDER MAPPING 정보
        ------------------------------------------------
        SET @v_table_name = 'TH_BUF_SCM_RESCHEDULE_APG_INFO'
        
        INSERT INTO TH_BUF_SCM_RESCHEDULE_APG_INFO
        SELECT A.MASTER_ID, A.PLAN_ID, 
               @v_plan_group_id AS PLAN_GROUP_ID,
               A.AFTER_SITE_ID, A.AFTER_ROUTE_ID, A.AFTER_OPERATION_ID, A.AFTER_RESOURCE_ID, A.GROUP_SEQ, A.ITEM_ID,
               MIN(A.WORK_ORDER_ID)       OVER (PARTITION BY A.MASTER_ID
                                                           , A.PLAN_ID
                                                           , A.AFTER_SITE_ID
                                                           , A.AFTER_ROUTE_ID
                                                           , A.AFTER_OPERATION_ID
                                                           , A.AFTER_RESOURCE_ID
                                                           , A.GROUP_SEQ
                                                           , A.ITEM_ID
                                                           , A.CAPA_TYPE
                                                           , A.ERP_OPERATION_ID
                                                           , A.WORK_ORDER_ID) AS GROUP_WORK_ORDER_ID,
               A.LANE_TACT_QTY            AS LANE_TACT_QTY,
               A.LANE_QTY                 AS LANE_QTY,
               A.SETUP_GROUP_ID           AS SETUP_GROUP_ID,
               A.WORK_ORDER_ID            AS WORK_ORDER_ID,
               A.ORG_WORK_ORDER_ID        AS ORG_WORK_ORDER_ID,
               A.AFTER_PLAN_DATE          AS PLAN_DATE,
               CASE WHEN CHARINDEX('PACK', @v_master_id) > 0 THEN FLOOR(A.AFTER_QTY)
                                                             ELSE CEILING(A.AFTER_QTY)
               END  AS PLAN_QTY,
               A.AFTER_IN_QTY             AS PLAN_IN_QTY,
               A.RESOURCE_SETUP_GROUP_ID  AS RESOURCE_SETUP_GROUP_ID,
               CAPA_TYPE                  AS CAPA_TYPE,
               ERP_OPERATION_ID           AS ERP_OPERATION_ID,
               FIXED_YN                   AS FIXED_YN,
               @v_proc_name               AS INSERT_ID,
               GETDATE()                  AS INSERT_TIME
        FROM   (
                SELECT A.*,
                       SUM(CHK) OVER (PARTITION BY AFTER_SITE_ID, AFTER_ROUTE_ID, AFTER_OPERATION_ID, AFTER_RESOURCE_ID
                                      ORDER     BY AFTER_PLAN_DATE, AFTER_SEQ) GROUP_SEQ
                FROM   (
                        SELECT A.*,
                               CASE WHEN ORG_WORK_ORDER_ID = PRE_ORG_WORK_ORDER_ID THEN 1
                                    ELSE 1
                               END  CHK
                        FROM   (
                                SELECT A.*
                                     , DENSE_RANK() OVER (PARTITION BY AFTER_SITE_ID, AFTER_ROUTE_ID, AFTER_OPERATION_ID, AFTER_RESOURCE_ID
                                                          ORDER     BY AFTER_PLAN_DATE, AFTER_SEQ) SEQ
                                     , LAG(ORG_WORK_ORDER_ID, 1, '-') OVER (PARTITION BY AFTER_SITE_ID, AFTER_ROUTE_ID, AFTER_OPERATION_ID, AFTER_RESOURCE_ID
                                                                            ORDER     BY AFTER_PLAN_DATE, AFTER_SEQ) PRE_ORG_WORK_ORDER_ID
                                FROM   (
                                        SELECT A.*, B.SETUP_GROUP_ID, C.RESOURCE_SETUP_GROUP_ID, D.CAPA_TYPE, D.ERP_OPERATION_ID
                                        FROM   FP_AMEND_PRODUCTION_PLAN_R  A,
                                               FP_AMEND_ITEM_OPERATION     B WITH(NOLOCK),
                                               FP_AMEND_RESOURCE           C WITH(NOLOCK),
                                               (
                                                SELECT A.FACTORY_ID, B.OPERATION_ID, 
                                                       MIN(B.CAPA_TYPE) AS CAPA_TYPE, MIN(B.ERP_OPERATION_ID) AS ERP_OPERATION_ID
                                                FROM   SCM_FACTORY_M A WITH(NOLOCK),
                                                       SCM_OPERATION_M B WITH(NOLOCK)
                                                WHERE  A.ACTIVE_FLAG        = 'Y'
                                                AND    A.COMPANY_ID         = B.COMPANY_ID
                                                AND    A.DIVISION_ID        = B.DIVISION_ID
                                                AND    A.SITE_ID            = B.SITE_ID
                                                AND    B.ACTIVE_FLAG        = 'Y'
                                                AND    B.CAPA_TYPE          = 'TACT'        -- TACT 으로 계산되는 공정
                                                --AND    B.ERP_OPERATION_ID  != 'HS'
                                                GROUP  BY A.FACTORY_ID, B.OPERATION_ID
                                               ) D
                                        WHERE  A.MASTER_ID          = @v_master_id
                                        AND    A.PLAN_ID            = @v_plan_id
                                        AND    A.AFTER_QTY          > 0
                                        AND    A.MASTER_ID          = B.MASTER_ID
                                        AND    A.PLAN_ID            = B.PLAN_ID
                                        AND    A.ITEM_ID            = B.ITEM_ID
                                        AND    A.AFTER_OPERATION_ID = B.OPERATION_ID
                                        AND    A.MASTER_ID          = C.MASTER_ID
                                        AND    A.PLAN_ID            = C.PLAN_ID
                                        AND    A.AFTER_RESOURCE_ID  = C.RESOURCE_ID
                                        AND    A.AFTER_SITE_ID      = D.FACTORY_ID
                                        AND    A.AFTER_OPERATION_ID = D.OPERATION_ID
                                        AND    EXISTS (
                                                        SELECT 1
                                                        FROM   SCM_LINE_M X
                                                        WHERE  X.ACTIVE_FLAG  = 'Y'
                                                        AND    X.FACTORY_ID   = A.AFTER_SITE_ID
                                                        AND    X.LINE_ID      = A.AFTER_ROUTE_ID
                                                        AND    X.OPERATION_ID = A.AFTER_OPERATION_ID
                                                        AND    X.MODEL_TYPE   = @v_plan_group_id
                                                      )
                                       ) A
                               ) A
                       ) A      
                ) A

        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = ' - TACT OPERATION : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        ------------------------------------------------
        -- TACT 기반의 OPERATION 기준
        ------------------------------------------------
        SET @v_table_name = 'TH_BUF_SCM_RESCHEDULE_APG_PLAN'
        
        INSERT INTO TH_BUF_SCM_RESCHEDULE_APG_PLAN
        SELECT A.MASTER_ID, A.PLAN_ID, A.PLAN_GROUP_ID,
               A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.RESOURCE_ID, A.GROUP_SEQ, A.ITEM_ID,  
               MAX(A.LANE_TACT_QTY)           AS LANE_TACT_QTY,
               MAX(A.LANE_QTY)                AS LANE_QTY,
               MAX(A.SETUP_GROUP_ID)          AS SETUP_GROUP_ID,
               GROUP_WORK_ORDER_ID            AS WORK_ORDER_ID,
               MIN(A.PLAN_DATE)               AS PLAN_DATE,
               SUM(A.PLAN_QTY)                AS PLAN_QTY,
               SUM(A.PLAN_IN_QTY)             AS PLAN_IN_QTY,
               MIN(A.RESOURCE_SETUP_GROUP_ID) AS RESOURCE_SETUP_GROUP_ID,
               CAPA_TYPE                      AS CAPA_TYPE,
               ERP_OPERATION_ID               AS ERP_OPERATION_ID,
               FIXED_YN                       AS FIXED_YN,
               @v_proc_name                   AS INSERT_ID,
               GETDATE()                      AS INSERT_TIME
        FROM   TH_BUF_SCM_RESCHEDULE_APG_INFO A
        WHERE  A.MASTER_ID          = @v_master_id
        AND    A.PLAN_ID            = @v_plan_id
        AND    A.PLAN_GROUP_ID      = @v_plan_group_id
        AND    A.CAPA_TYPE          = 'TACT'
        GROUP  BY  A.MASTER_ID, A.PLAN_ID, A.PLAN_GROUP_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.RESOURCE_ID, A.GROUP_SEQ, A.ITEM_ID, A.CAPA_TYPE, A.ERP_OPERATION_ID, A.FIXED_YN, A.GROUP_WORK_ORDER_ID
        ORDER  BY  A.MASTER_ID, A.PLAN_ID, A.PLAN_GROUP_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.RESOURCE_ID, A.GROUP_SEQ, A.ITEM_ID, A.CAPA_TYPE, A.ERP_OPERATION_ID
        
        
        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = ' - TACT OPERATION : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
        
        ------------------------------------------------
        -- 대상 WORK 집계전의 WORK ORDER MAPPING 정보
        ------------------------------------------------
        SET @v_table_name = 'TH_BUF_SCM_RESCHEDULE_APG_INFO'

        INSERT INTO TH_BUF_SCM_RESCHEDULE_APG_INFO
        SELECT A.MASTER_ID, A.PLAN_ID,
               @v_plan_group_id AS PLAN_GROUP_ID,
               A.AFTER_SITE_ID, A.AFTER_ROUTE_ID, A.AFTER_OPERATION_ID, A.AFTER_RESOURCE_ID, A.GROUP_SEQ, A.ITEM_ID,
               MIN(A.WORK_ORDER_ID)       OVER (PARTITION BY A.MASTER_ID
                                                           , A.PLAN_ID
                                                           , A.AFTER_SITE_ID
                                                           , A.AFTER_ROUTE_ID
                                                           , A.AFTER_OPERATION_ID
                                                           , A.AFTER_RESOURCE_ID
                                                           , A.GROUP_SEQ
                                                           , A.ITEM_ID
                                                           , A.CAPA_TYPE
                                                           , A.ERP_OPERATION_ID
                                                           , A.WORK_ORDER_ID) AS GROUP_WORK_ORDER_ID,
               A.LANE_TACT_QTY            AS LANE_TACT_QTY,
               A.LANE_QTY                 AS LANE_QTY,
               A.SETUP_GROUP_ID           AS SETUP_GROUP_ID,
               A.WORK_ORDER_ID            AS WORK_ORDER_ID,
               A.ORG_WORK_ORDER_ID        AS ORG_WORK_ORDER_ID,
               A.AFTER_PLAN_DATE          AS PLAN_DATE,
               A.AFTER_QTY                AS PLAN_QTY,
               A.AFTER_IN_QTY             AS PLAN_IN_QTY,
               A.RESOURCE_SETUP_GROUP_ID  AS RESOURCE_SETUP_GROUP_ID,
               CAPA_TYPE                  AS CAPA_TYPE,
               ERP_OPERATION_ID           AS ERP_OPERATION_ID,
               FIXED_YN                   AS FIXED_YN,
               @v_proc_name               AS INSERT_ID,
               GETDATE()                  AS INSERT_TIME
        FROM   (
                SELECT A.*,
                       SUM(CHK) OVER (PARTITION BY AFTER_SITE_ID, AFTER_ROUTE_ID, AFTER_OPERATION_ID, AFTER_RESOURCE_ID
                                      ORDER     BY AFTER_PLAN_DATE, AFTER_SEQ) GROUP_SEQ
                FROM   (
                        SELECT A.*,
                               CASE WHEN ORG_WORK_ORDER_ID = PRE_ORG_WORK_ORDER_ID THEN 1
                                    ELSE 1
                               END  CHK
                        FROM   (
                                SELECT A.*
                                     , DENSE_RANK() OVER (PARTITION BY AFTER_SITE_ID, AFTER_ROUTE_ID, AFTER_OPERATION_ID, AFTER_RESOURCE_ID
                                                          ORDER     BY AFTER_PLAN_DATE, AFTER_SEQ) SEQ
                                     , LAG(ORG_WORK_ORDER_ID, 1, '-') OVER (PARTITION BY AFTER_SITE_ID, AFTER_ROUTE_ID, AFTER_OPERATION_ID, AFTER_RESOURCE_ID
                                                                            ORDER     BY AFTER_PLAN_DATE, AFTER_SEQ) PRE_ORG_WORK_ORDER_ID
                                FROM   (
                                        SELECT A.*, B.SETUP_GROUP_ID, C.RESOURCE_SETUP_GROUP_ID, D.CAPA_TYPE, D.ERP_OPERATION_ID
                                        FROM   FP_AMEND_PRODUCTION_PLAN_R  A,
                                               FP_AMEND_ITEM_OPERATION     B,
                                               FP_AMEND_RESOURCE           C,
                                               (
                                                SELECT A.FACTORY_ID, B.OPERATION_ID, 
                                                       MIN(B.CAPA_TYPE) AS CAPA_TYPE, MIN(B.ERP_OPERATION_ID) AS ERP_OPERATION_ID
                                                FROM   SCM_FACTORY_M A WITH(NOLOCK),
                                                       SCM_OPERATION_M B WITH(NOLOCK)
                                                WHERE  A.ACTIVE_FLAG        = 'Y'
                                                AND    A.COMPANY_ID         = B.COMPANY_ID
                                                AND    A.DIVISION_ID        = B.DIVISION_ID
                                                AND    A.SITE_ID            = B.SITE_ID
                                                AND    B.ACTIVE_FLAG        = 'Y'
                                                AND    B.CAPA_TYPE          = 'BATCH'        -- TACT 으로 계산되는 공정
                                                --AND    B.ERP_OPERATION_ID  != 'HS'
                                                GROUP  BY A.FACTORY_ID, B.OPERATION_ID
                                               ) D
                                        WHERE  A.MASTER_ID          = @v_master_id
                                        AND    A.PLAN_ID            = @v_plan_id
                                        AND    A.AFTER_QTY          > 0
                                        AND    A.MASTER_ID          = B.MASTER_ID
                                        AND    A.PLAN_ID            = B.PLAN_ID
                                        AND    A.ITEM_ID            = B.ITEM_ID
                                        AND    A.AFTER_OPERATION_ID = B.OPERATION_ID
                                        AND    A.MASTER_ID          = C.MASTER_ID
                                        AND    A.PLAN_ID            = C.PLAN_ID
                                        AND    A.AFTER_RESOURCE_ID  = C.RESOURCE_ID
                                        AND    A.AFTER_SITE_ID      = D.FACTORY_ID
                                        AND    A.AFTER_OPERATION_ID = D.OPERATION_ID
                                        AND    EXISTS (
                                                        SELECT 1
                                                        FROM   SCM_LINE_M X WITH(NOLOCK)
                                                        WHERE  X.ACTIVE_FLAG  = 'Y'
                                                        AND    X.FACTORY_ID   = A.AFTER_SITE_ID
                                                        AND    X.LINE_ID      = A.AFTER_ROUTE_ID
                                                        AND    X.OPERATION_ID = A.AFTER_OPERATION_ID
                                                        AND    X.MODEL_TYPE   = @v_plan_group_id
                                                      )
                                       ) A
                               ) A
                       ) A
               ) A
        
        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = ' - BATCH OPERATION : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        ------------------------------------------------
        -- BATCH 기반의 OPERATION 기준
        ------------------------------------------------

        SET @v_table_name = 'TH_BUF_SCM_RESCHEDULE_APG_PLAN'
        
        INSERT INTO TH_BUF_SCM_RESCHEDULE_APG_PLAN
        SELECT A.MASTER_ID, A.PLAN_ID, A.PLAN_GROUP_ID,
               A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.RESOURCE_ID, A.GROUP_SEQ, A.ITEM_ID,  
               MAX(A.LANE_TACT_QTY)           AS LANE_TACT_QTY,
               MAX(A.LANE_QTY)                AS LANE_QTY,
               MAX(A.SETUP_GROUP_ID)          AS SETUP_GROUP_ID,
               GROUP_WORK_ORDER_ID            AS WORK_ORDER_ID,
               MIN(A.PLAN_DATE)               AS PLAN_DATE,
               SUM(A.PLAN_QTY)                AS PLAN_QTY,
               SUM(A.PLAN_IN_QTY)             AS PLAN_IN_QTY,
               MIN(A.RESOURCE_SETUP_GROUP_ID) AS RESOURCE_SETUP_GROUP_ID,
               CAPA_TYPE                      AS CAPA_TYPE,
               ERP_OPERATION_ID               AS ERP_OPERATION_ID,
               FIXED_YN                       AS FIXED_YN,
               @v_proc_name                   AS INSERT_ID,
               GETDATE()                      AS INSERT_TIME
        FROM   TH_BUF_SCM_RESCHEDULE_APG_INFO A
        WHERE  A.MASTER_ID          = @v_master_id
        AND    A.PLAN_ID            = @v_plan_id
        AND    A.PLAN_GROUP_ID      = @v_plan_group_id
        AND    A.CAPA_TYPE          = 'BATCH'
        GROUP  BY  A.MASTER_ID, A.PLAN_ID, A.PLAN_GROUP_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.RESOURCE_ID, A.GROUP_SEQ, A.ITEM_ID, A.CAPA_TYPE, A.ERP_OPERATION_ID, A.FIXED_YN, A.GROUP_WORK_ORDER_ID
        ORDER  BY  A.MASTER_ID, A.PLAN_ID, A.PLAN_GROUP_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.RESOURCE_ID, A.GROUP_SEQ, A.ITEM_ID, A.CAPA_TYPE, A.ERP_OPERATION_ID
        
        
        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = ' - BATCH OPERATION : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END
      
      BEGIN
      
        SET @v_table_name = 'TH_BUF_SCM_RESCHEDULE_APG_SETUP_MATRIX'
        
        DELETE FROM TH_BUF_SCM_RESCHEDULE_APG_SETUP_MATRIX WHERE  MASTER_ID = @v_master_id  and plan_id = @v_plan_id and PLAN_GROUP_ID = @v_plan_group_id

        INSERT INTO TH_BUF_SCM_RESCHEDULE_APG_SETUP_MATRIX
        SELECT MASTER_ID, 
               PLAN_ID, 
               @v_plan_group_id,
               RESOURCE_SETUP_GROUP_ID, 
               FROM_SETUP_GROUP_ID, 
               TO_SETUP_GROUP_ID, 
               SETUP_TIME, 
               SETUP_TIME_UOM,
               @v_proc_name           AS INSERT_ID,
               GETDATE()              AS INSERT_TIME
        FROM   FP_AMEND_SETUP_MATRIX
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id


        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END

      BEGIN
      
        SET @v_table_name = 'TH_BUF_SCM_RESCHEDULE_APG_BOR'
        
        DELETE FROM TH_BUF_SCM_RESCHEDULE_APG_BOR WHERE  MASTER_ID = @v_master_id  and plan_id = @v_plan_id and plan_group_id = @v_plan_group_id

        INSERT INTO TH_BUF_SCM_RESCHEDULE_APG_BOR
        SELECT A.MASTER_ID, 
               A.PLAN_ID, 
               @v_plan_group_id AS PLAN_GROUP_ID,
               A.SITE_ID, 
               A.ROUTE_ID, 
               A.OPERATION_ID, 
               A.ITEM_ID, 
               A.LANE_TACT_QTY, 
               A.RESOURCE_ID, 
               A.START_TIME, 
               A.END_TIME,
               A.UTILIZATION, 
               A.TACT_TIME, 
               A.TACT_TIME_UOM, 
               CASE WHEN A.YIELD IS NULL OR A.YIELD = 0 THEN 1
                    ELSE A.YIELD
               END  AS YIELD, 
               B.RESOURCE_SETUP_GROUP_ID,
               @v_proc_name         AS INSERT_ID,
               GETDATE()            AS INSERT_TIME
        FROM   FP_AMEND_TIMEPHASED_LANE_BOR A,
               FP_AMEND_RESOURCE B
        WHERE  A.MASTER_ID    = @v_master_id
        AND    A.PLAN_ID      = @v_plan_id
        AND    A.MASTER_ID    = B.MASTER_ID
        AND    A.PLAN_ID      = B.PLAN_ID
        AND    A.RESOURCE_ID  = B.RESOURCE_ID

        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END
      
      BEGIN
      
        SET @v_table_name = 'TH_BUF_SCM_RESCHEDULE_APG_CALENDAR'
        
        DELETE FROM TH_BUF_SCM_RESCHEDULE_APG_CALENDAR WHERE  MASTER_ID = @v_master_id and plan_id = @v_plan_id and plan_group_id = @v_plan_group_id

        ;WITH W_WORK AS (
                          SELECT A.MASTER_ID, A.PLAN_ID, B.RESOURCE_ID AS OFFTIME_SET_ID,
                                 A.PLAN_DATE, A.START_TIME, A.END_TIME
                          FROM   (
                                  SELECT A.INSTANCE_ID MASTER_ID, A.PLAN_ID,
                                         CONVERT(NVARCHAR, DATEADD(DAY, INT-1, PLAN_START_TIME), 112) AS PLAN_DATE,
                                         DATEADD(DAY, INT-1, PLAN_START_TIME) AS START_TIME,
                                         DATEADD(DAY, INT  , PLAN_START_TIME) AS END_TIME
                                  FROM   SCM_FP_PLAN_H A WITH(NOLOCK),
                                         COPYT B
                                  WHERE  A.INSTANCE_ID  = @v_master_id
                                  AND    A.PLAN_ID      = @v_plan_id
                                  AND    INT           <= A.PLAN_HORIZON
                                 ) A,
                                 FP_AMEND_RESOURCE B
                          WHERE  A.MASTER_ID = B.MASTER_ID
                          AND    A.PLAN_ID   = B.PLAN_ID
                        ),
              W_OFF AS  (
                          SELECT A.*,B.OFFTIME_SET_ID,B.START_DTTM,B.END_DTTM,--A.MASTER_ID, A.PLAN_ID, A.PLAN_DATE,
                                 CASE WHEN B.START_DTTM > A.START_TIME THEN B.START_DTTM
                                      ELSE A.START_TIME
                                 END  OFF_START_TIME,
                                 CASE WHEN B.END_DTTM > A.END_TIME THEN A.END_TIME
                                      ELSE B.END_DTTM
                                 END  OFF_END_TIME
                          FROM   (
                                  SELECT A.INSTANCE_ID MASTER_ID, A.PLAN_ID,
                                         CONVERT(NVARCHAR, DATEADD(DAY, INT-1, PLAN_START_TIME), 112) AS PLAN_DATE,
                                         DATEADD(DAY, INT-1, PLAN_START_TIME) AS START_TIME,
                                         DATEADD(DAY, INT  , PLAN_START_TIME) AS END_TIME
                                  FROM   SCM_FP_PLAN_H A WITH(NOLOCK),
                                         COPYT B
                                  WHERE  A.INSTANCE_ID  = @v_master_id
                                  AND    A.PLAN_ID      = @v_plan_id
                                  AND    INT           <= A.PLAN_HORIZON
                                 ) A,
                                 FP_AMEND_OFFTIME B
                          WHERE  A.MASTER_ID  = B.MASTER_ID
                          AND    A.PLAN_ID    = B.PLAN_ID
                          AND    B.START_DTTM < A.END_TIME
                          AND    B.END_DTTM   > A.START_TIME 
                        )
        INSERT INTO TH_BUF_SCM_RESCHEDULE_APG_CALENDAR
        SELECT A.MASTER_ID, 
               A.PLAN_ID, 
               @v_plan_group_id     AS PLAN_GROUP_ID,
               A.OFFTIME_SET_ID, 
               A.PLAN_DATE, 
               A.START_TIME, 
               A.END_TIME, 
               A.TOTAL_CAPA, 
               0                    AS ASSIGN_CAPA,
               0                    AS SETUP_CAPA,
               A.TOTAL_CAPA         AS REMAIN_CAPA,
               @v_proc_name         AS INSERT_ID,
               GETDATE()            AS INSERT_TIME
        FROM   (
                SELECT A.*, 
                       CASE WHEN B.OFFTIME_SET_ID IS NOT NULL THEN 0
                            ELSE DATEDIFF(SECOND, A.START_TIME, A.END_TIME)
                       END  TOTAL_CAPA
                FROM   (
                        SELECT A.*,
                               LEAD(START_TIME,1,NULL) OVER (PARTITION BY OFFTIME_SET_ID ORDER BY START_TIME) AS END_TIME
                        FROM   (
                                SELECT DISTINCT MASTER_ID, PLAN_ID, OFFTIME_SET_ID, PLAN_DATE, START_TIME
                                FROM   (
                                        SELECT MASTER_ID, PLAN_ID, OFFTIME_SET_ID, PLAN_DATE, START_TIME FROM W_WORK
                                        UNION  ALL
                                        SELECT MASTER_ID, PLAN_ID, OFFTIME_SET_ID, PLAN_DATE, OFF_START_TIME FROM W_OFF
                                       ) A
                               ) A
                       ) A
                       LEFT OUTER JOIN W_OFF B
                            ON    A.MASTER_ID = B.MASTER_ID
                            AND   A.PLAN_ID = B.PLAN_ID
                            AND   A.OFFTIME_SET_ID = B.OFFTIME_SET_ID
                            AND   A.PLAN_DATE = B.PLAN_DATE
                            AND   A.START_TIME = B.OFF_START_TIME
                            AND   A.END_TIME = B.OFF_END_TIME
                WHERE  A.END_TIME IS NOT NULL
               ) A

               
        SET @n_row_count = @@ROWCOUNT
        
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END

      ----------------------------------------------------------------------------------------------------------------------------
      -- 계획 수립 부분
      ----------------------------------------------------------------------------------------------------------------------------

      SET @v_table_name = 'TH_BUF_SCM_RESCHEDULE_APG_RESULT'

      DELETE FROM TH_BUF_SCM_RESCHEDULE_APG_RESULT WHERE  MASTER_ID = @v_master_id and plan_id = @v_plan_id and plan_group_id = @v_plan_group_id

      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      ----------------------------------------------------------------------------------------------------------------------------
      -- TACT 이 반영된 OPERATION 만 진행..
      ----------------------------------------------------------------------------------------------------------------------------

      DECLARE C_PLAN CURSOR FOR 
        SELECT A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.RESOURCE_ID, A.GROUP_SEQ, A.ITEM_ID, A.CAPA_TYPE, A.LANE_QTY, A.LANE_TACT_QTY, 
               A.WORK_ORDER_ID, A.PLAN_DATE, A.PLAN_QTY, A.PLAN_IN_QTY, A.FIXED_YN, --B.SETUP_TIME, B.SETUP_TIME_UOM,
               A.SEQ_DESC,    -- 이놈은 CAPA 부족할때 START 를 잡아줄 분단위로 설정한다.
               ISNULL(B.SETUP_TIME, 0.0) 
                  * CASE B.SETUP_TIME_UOM WHEN 'SECOND' THEN 1
                                          WHEN 'MINUTE' THEN 60
                                          WHEN 'HOUR'   THEN 3600
                                          WHEN 'DAY'    THEN 86400
                                                        ELSE 60     END AS SETUP_TIME_SECOND
        FROM   (
                SELECT A.*,
                       LAG(SETUP_GROUP_ID, 1, NULL) OVER (PARTITION BY SITE_ID, ROUTE_ID, OPERATION_ID, RESOURCE_ID, PLAN_DATE ORDER BY GROUP_SEQ) AS PRE_SETUP_GROUP_ID,
                       DENSE_RANK() OVER (PARTITION BY SITE_ID, ROUTE_ID, OPERATION_ID, RESOURCE_ID, PLAN_DATE ORDER BY GROUP_SEQ DESC) AS SEQ_DESC
                FROM   TH_BUF_SCM_RESCHEDULE_APG_PLAN A
                WHERE  MASTER_ID      = @v_master_id
                AND    PLAN_ID        = @v_plan_id
                AND    PLAN_GROUP_ID  = @v_plan_group_id
                AND    CAPA_TYPE      = 'TACT'
                AND    PLAN_QTY       > 0
               ) A
               LEFT OUTER JOIN TH_BUF_SCM_RESCHEDULE_APG_SETUP_MATRIX B
                    ON    A.MASTER_ID = B.MASTER_ID
                    AND   A.PLAN_ID = B.PLAN_ID
                    AND   A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
                    AND   A.RESOURCE_SETUP_GROUP_ID = B.RESOURCE_SETUP_GROUP_ID
                    AND   A.PRE_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
                    AND   A.SETUP_GROUP_ID     = B.TO_SETUP_GROUP_ID
        ORDER  BY SITE_ID, ROUTE_ID, OPERATION_ID, RESOURCE_ID, GROUP_SEQ
      
      DECLARE 
        @C_PLAN$SITE_ID         nvarchar(150),
        @C_PLAN$ROUTE_ID        nvarchar(150),
        @C_PLAN$OPERATION_ID    nvarchar(150),
        @C_PLAN$RESOURCE_ID     nvarchar(150),
        @C_PLAN$GROUP_SEQ       int,
        @C_PLAN$ITEM_ID         nvarchar(150),
        @C_PLAN$CAPA_TYPE       nvarchar(50),
        @C_PLAN$LANE_QTY        numeric(20,10),
        @C_PLAN$LANE_TACT_QTY   numeric(20,10),
        @C_PLAN$WORK_ORDER_ID   nvarchar(150),
        @C_PLAN$PLAN_DATE       nvarchar(8),
        @C_PLAN$PLAN_QTY        numeric(20,10),
        @C_PLAN$PLAN_IN_QTY     numeric(20,10),
        @C_PLAN$FIXED_YN        nvarchar(8),
        @C_PLAN$SEQ_DESC        int,
        @C_PLAN$SETUP_TIME      numeric(20,10)

      DECLARE 
        @C_CAL$PLAN_DATE        nvarchar(8),
        @C_CAL$START_TIME       datetime,
        @C_CAL$END_TIME         datetime,
        @C_CAL$PLAN_START_TIME  datetime,
        @C_CAL$REMAIN_CAPA      numeric(20,10),
        @C_CAL$NO_ASSIGN_FLAG   int,
        @C_CAL$CHECK_FLAG       nvarchar(8)
      
      DECLARE 
        @C_BOR$UTILIZATION      numeric(20,10),
        @C_BOR$TACT_TIME        numeric(20,10),
        @C_BOR$YIELD            numeric(20,10)

      DECLARE 
        @C_RESULT$START_TIME    DATETIME,
        @C_RESULT$END_TIME      DATETIME,
        @C_RESULT$ASSIGN_CAPA   numeric(20,10),
        @C_RESULT$PLAN_QTY      numeric(20,10),
        @C_RESULT$REMAIN_QTY    numeric(20,10),
        @C_RESULT$ABLE_QTY      numeric(20,10)      -- CAPA 내 생산가능 수량

      DECLARE
        @C_CHECK$MOD_TIME       numeric(20,10),
        @C_CHECK$WORK_ORDER_ID  nvarchar(150)


      OPEN C_PLAN    
      WHILE 1 = 1

      BEGIN

        -- 시간 조정할 WORK 을 차례대로 조회한다.
        FETCH C_PLAN
         INTO @C_PLAN$SITE_ID,
              @C_PLAN$ROUTE_ID,
              @C_PLAN$OPERATION_ID,
              @C_PLAN$RESOURCE_ID,
              @C_PLAN$GROUP_SEQ,
              @C_PLAN$ITEM_ID,
              @C_PLAN$CAPA_TYPE,
              @C_PLAN$LANE_QTY,
              @C_PLAN$LANE_TACT_QTY,
              @C_PLAN$WORK_ORDER_ID,
              @C_PLAN$PLAN_DATE,
              @C_PLAN$PLAN_QTY,
              @C_PLAN$PLAN_IN_QTY,
              @C_PLAN$FIXED_YN,
              @C_PLAN$SEQ_DESC,
              @C_PLAN$SETUP_TIME

          IF @@FETCH_STATUS <> 0 --OR @C_PLAN$WORK_ORDER_ID = 'WK117227CM032'
            BREAK
            
          SET @C_RESULT$REMAIN_QTY = @C_PLAN$PLAN_QTY
          
          SET @n_loop = 0
          
          SET @C_CHECK$WORK_ORDER_ID = 'NULL'
            
          WHILE 1=1
          BEGIN
            
            SET @n_loop = @n_loop + 1

            -- SETUP 시간 고려
            IF @C_PLAN$SETUP_TIME > 0
              BEGIN

                SET @C_CAL$NO_ASSIGN_FLAG = 0
                
                -- 1. 오늘 일자에 할당된 계획이 있는지 찾음 ( 이유, 전날에 SETUP 을 넣을 수 있으니까
                SELECT @C_CAL$NO_ASSIGN_FLAG = (CASE WHEN SUM(TOTAL_CAPA) = SUM(REMAIN_CAPA) THEN 1
                                                    ELSE 0
                                                END)
                FROM   TH_BUF_SCM_RESCHEDULE_APG_CALENDAR A
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                AND    A.PLAN_DATE     >= @C_PLAN$PLAN_DATE
                AND    A.OFFTIME_SET_ID = @C_PLAN$RESOURCE_ID
                
                IF @C_CAL$NO_ASSIGN_FLAG = 1
                  BEGIN

                    SELECT TOP 1
                           @C_CAL$PLAN_DATE       = A.PLAN_DATE,
                           @C_CAL$START_TIME      = A.START_TIME,
                           @C_CAL$END_TIME        = A.END_TIME,
                           @C_CAL$PLAN_START_TIME = DATEADD(SECOND, A.REMAIN_CAPA * -1, A.END_TIME),
                           @C_CAL$REMAIN_CAPA     = A.REMAIN_CAPA,
                           @C_CAL$CHECK_FLAG      = A.CAPA_CHECK
                    FROM   (
                            SELECT A.PLAN_DATE, A.START_TIME, A.END_TIME, A.REMAIN_CAPA, 
                                   A.CAPA_CHECK, A.SEQ
                            FROM   (-- 전일 시간 역순으로 REMAIN CAPA 를 산정,,,,  저 앞에 SETUP 발생할 수 있어서리...
                                    SELECT A.*,
                                           SUM(CHECK_CAPA) OVER (ORDER BY START_TIME DESC) CHECK_SUM
                                    FROM   (
                                            SELECT A.*, '1' CAPA_CHECK,
                                                   DENSE_RANK() OVER (ORDER BY START_TIME DESC) SEQ,
                                                   LAG(ASSIGN_CAPA,1,0) OVER (ORDER BY START_TIME DESC) CHECK_CAPA
                                            FROM   TH_BUF_SCM_RESCHEDULE_APG_CALENDAR A
                                            WHERE  A.MASTER_ID      = @v_master_id
                                            AND    A.PLAN_ID        = @v_plan_id
                                            AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                                            AND    A.OFFTIME_SET_ID = @C_PLAN$RESOURCE_ID
                                            AND    A.PLAN_DATE      < @C_PLAN$PLAN_DATE
                                           ) A
                                   ) A
                            WHERE  CHECK_SUM = 0
                            AND    REMAIN_CAPA > 1
                            UNION  ALL
                            SELECT A.PLAN_DATE, A.START_TIME, A.END_TIME, A.REMAIN_CAPA,
                                   '2' CAPA_CHECK,
                                   DENSE_RANK() OVER (ORDER BY START_TIME)       SEQ 
                            FROM   TH_BUF_SCM_RESCHEDULE_APG_CALENDAR A
                            WHERE  A.MASTER_ID      = @v_master_id
                            AND    A.PLAN_ID        = @v_plan_id
                            AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                            AND    A.OFFTIME_SET_ID = @C_PLAN$RESOURCE_ID
                            --AND    A.PLAN_DATE     >= @C_PLAN$PLAN_DATE
                            AND    A.PLAN_DATE      = @C_PLAN$PLAN_DATE   -- 당일만 본다.
                            AND    A.REMAIN_CAPA    > 1                       -- 1초                           
                           ) A
                    ORDER  BY CAPA_CHECK, SEQ
                  
                  END
                ELSE
                  BEGIN

                    SELECT TOP 1
                           @C_CAL$PLAN_DATE       = A.PLAN_DATE,
                           @C_CAL$START_TIME      = A.START_TIME,
                           @C_CAL$END_TIME        = A.END_TIME,
                           @C_CAL$PLAN_START_TIME = DATEADD(SECOND, A.REMAIN_CAPA * -1, A.END_TIME),
                           @C_CAL$REMAIN_CAPA     = A.REMAIN_CAPA,
                           @C_CAL$CHECK_FLAG      = '2'
                    FROM   (
                            SELECT *
                            FROM   TH_BUF_SCM_RESCHEDULE_APG_CALENDAR A
                            WHERE  A.MASTER_ID      = @v_master_id
                            AND    A.PLAN_ID        = @v_plan_id
                            AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                            AND    A.OFFTIME_SET_ID = @C_PLAN$RESOURCE_ID
                            AND    A.PLAN_DATE      = @C_PLAN$PLAN_DATE
                            --AND    A.PLAN_DATE     >= @C_PLAN$PLAN_DATE
                            AND    A.REMAIN_CAPA    > 1                       -- 1초 
                           ) A
                    ORDER  BY PLAN_DATE, START_TIME
                  
                  END
                
              
                SET @C_RESULT$ASSIGN_CAPA = 0
                
                SELECT @C_RESULT$ASSIGN_CAPA
                       = (CASE WHEN @C_PLAN$SETUP_TIME > @C_CAL$REMAIN_CAPA THEN @C_CAL$REMAIN_CAPA
                               ELSE @C_PLAN$SETUP_TIME
                          END)
              
                -- SETUP 시간만큼 CAPA 점유할 것
                
                UPDATE TH_BUF_SCM_RESCHEDULE_APG_CALENDAR
                SET    REMAIN_CAPA = REMAIN_CAPA - @C_RESULT$ASSIGN_CAPA
                      ,SETUP_CAPA  = SETUP_CAPA  + @C_RESULT$ASSIGN_CAPA
                WHERE  MASTER_ID      = @v_master_id
                AND    PLAN_ID        = @v_plan_id
                AND    PLAN_GROUP_ID  = @v_plan_group_id
                AND    OFFTIME_SET_ID = @C_PLAN$RESOURCE_ID
                AND    PLAN_DATE      = @C_CAL$PLAN_DATE
                AND    START_TIME     = @C_CAL$START_TIME
                AND    END_TIME       = @C_CAL$END_TIME

                INSERT INTO TH_BUF_SCM_RESCHEDULE_APG_RESULT
                       (
                        MASTER_ID
                      , PLAN_ID
                      , PLAN_GROUP_ID
                      , SITE_ID
                      , ROUTE_ID
                      , OPERATION_ID
                      , RESOURCE_ID
                      , ITEM_ID
                      , LANE_QTY
                      , WORK_ORDER_ID
                      , PLAN_DATE
                      , START_TIME
                      , END_TIME
                      , PLAN_QTY
                      , PLAN_IN_QTY
                      , CAPA_TYPE
                      , FIXED_YN
                      , ASSIGN_SEQ
                      , DEMAND_ID
                      , NEW_WORK_ORDER_ID
                      , INSERT_ID
                      , INSERT_TIME
                       )
                SELECT  @v_master_id,
                        @v_plan_id,
                        @v_plan_group_id,
                        @C_PLAN$SITE_ID,
                        @C_PLAN$ROUTE_ID,
                        @C_PLAN$OPERATION_ID,
                        @C_PLAN$RESOURCE_ID,
                        @C_PLAN$ITEM_ID,
                        @C_PLAN$LANE_QTY,
                        @C_PLAN$WORK_ORDER_ID,
                        @C_CAL$PLAN_DATE,
                        CASE WHEN @C_CAL$CHECK_FLAG = '1' THEN DATEADD(SECOND, @C_RESULT$ASSIGN_CAPA * -1, @C_CAL$END_TIME) 
                             ELSE @C_CAL$PLAN_START_TIME
                        END                               AS START_TIME,
                        CASE WHEN @C_CAL$CHECK_FLAG = '1' THEN @C_CAL$END_TIME
                             ELSE (
                                      CASE WHEN DATEADD(SECOND, @C_RESULT$ASSIGN_CAPA, @C_CAL$PLAN_START_TIME) > @C_CAL$END_TIME  THEN @C_CAL$END_TIME
                                           ELSE DATEADD(SECOND, @C_RESULT$ASSIGN_CAPA, @C_CAL$PLAN_START_TIME) 
                                      END
                                   )
                        END
                                                          AS END_TIME,
                        0                                 AS PLAN_QTY,
                        0                                 AS PLAN_IN_QTY,
                        'SETUP'                           AS CAPA_TYPE,
                        @C_PLAN$FIXED_YN                  AS FIXED_YN,
                        @v_assign_cnt                     AS ASSGIN_CNT,
                        NULL                              AS DEMAND_ID,
                        NULL                              AS NEW_WORK_ORDER_ID,
                        @v_proc_name                      AS INSERT_ID,
                        GETDATE()                         AS INSERT_TIME
              
                SET @C_PLAN$SETUP_TIME = @C_PLAN$SETUP_TIME - @C_RESULT$ASSIGN_CAPA
                
                SET @C_PLAN$SETUP_TIME = 0
                
                SET @v_assign_cnt = @v_assign_cnt + 1
              
              END
            
            ELSE
            
              BEGIN

                -- 2. PLAN_DATE 에 시간이 있는지 확인한다.
                SET @C_CAL$REMAIN_CAPA = 0
                
                SELECT TOP 1
                       @C_CAL$PLAN_DATE       = A.PLAN_DATE,
                       @C_CAL$START_TIME      = A.START_TIME,
                       @C_CAL$END_TIME        = A.END_TIME,
                       @C_CAL$PLAN_START_TIME = DATEADD(SECOND, A.REMAIN_CAPA * -1, A.END_TIME),
                       @C_CAL$REMAIN_CAPA     = A.REMAIN_CAPA
                FROM   (
                        SELECT *
                        FROM   TH_BUF_SCM_RESCHEDULE_APG_CALENDAR A
                        WHERE  A.MASTER_ID      = @v_master_id
                        AND    A.PLAN_ID        = @v_plan_id
                        AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                        --AND    A.PLAN_DATE     >= @C_PLAN$PLAN_DATE
                        AND    A.PLAN_DATE      = @C_PLAN$PLAN_DATE   -- 당일만 본다.
                        AND    A.OFFTIME_SET_ID = @C_PLAN$RESOURCE_ID
                        AND    A.REMAIN_CAPA    > 1                       -- 1초 
                       ) A
                ORDER  BY PLAN_DATE, START_TIME
                
                IF @C_CAL$REMAIN_CAPA > 0  
                  BEGIN
                    -- 3. BOR 정보를 기준으로 TACT 을 설정한다.
                    SELECT TOP 1
                           @C_BOR$UTILIZATION = UTILIZATION, 
                           @C_BOR$TACT_TIME   = TACT_TIME, 
                           @C_BOR$YIELD       = YIELD          
                    FROM   TH_BUF_SCM_RESCHEDULE_APG_BOR A
                    WHERE  A.MASTER_ID      = @v_master_id
                    AND    A.PLAN_ID        = @v_plan_id
                    AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                    AND    A.ITEM_ID        = @C_PLAN$ITEM_ID
                    AND    A.LANE_TACT_QTY  = @C_PLAN$LANE_TACT_QTY
                    AND    A.SITE_ID        = ( CASE WHEN @C_PLAN$SITE_ID IN ('E7','E8') THEN A.SITE_ID ELSE @C_PLAN$SITE_ID END )
                    AND    A.ROUTE_ID       = @C_PLAN$ROUTE_ID
                    AND    A.OPERATION_ID   = @C_PLAN$OPERATION_ID
                    AND    A.RESOURCE_ID    = @C_PLAN$RESOURCE_ID
                    AND    A.START_TIME    <= @C_CAL$PLAN_START_TIME
                    AND    A.END_TIME      >= @C_CAL$PLAN_START_TIME
                    ORDER  BY START_TIME
                  
                    IF @C_BOR$TACT_TIME * @C_BOR$UTILIZATION * @C_BOR$YIELD > 0
                      BEGIN
                    
                        SET @C_RESULT$ABLE_QTY = CEILING(@C_CAL$REMAIN_CAPA / @C_BOR$TACT_TIME * @C_BOR$UTILIZATION * @C_BOR$YIELD)
                        
                        SELECT @C_RESULT$PLAN_QTY
                                = CASE WHEN @C_RESULT$ABLE_QTY > @C_RESULT$REMAIN_QTY THEN @C_RESULT$REMAIN_QTY
                                       ELSE @C_RESULT$ABLE_QTY
                                  END
                      
                        SET @C_RESULT$ASSIGN_CAPA = CEILING(@C_RESULT$PLAN_QTY * @C_BOR$TACT_TIME / @C_BOR$UTILIZATION / @C_BOR$YIELD)
                        
                        -- 위에 차감하고 남는 잔여시간을 확인하여 10분 미만일 경우 그냥 포함 시킨다.
                        BEGIN
                        
                          SET @C_CHECK$MOD_TIME = (@C_RESULT$REMAIN_QTY - @C_RESULT$PLAN_QTY) * @C_BOR$TACT_TIME / @C_BOR$UTILIZATION / @C_BOR$YIELD
                          
                          -- 여기서 조건을 조정하여 당일에 다 넣을 것인지. 아님 다음날로 밀것인지를 결정한다.
                          -- 당일 다 넣을 경우 잔여 CAPA 가 적을 경우 역으로 START 시간을 잡는다.
                          -- 당일에 집어넣음
                          IF @C_RESULT$ABLE_QTY > @C_RESULT$REMAIN_QTY
                            SET @C_RESULT$PLAN_QTY = @C_RESULT$REMAIN_QTY
                          -- 다음날로 밀 경우에 사용함.
                          --IF @C_CHECK$MOD_TIME > 0 AND @C_CHECK$MOD_TIME <= 600  -- 초단위
                          --  SET @C_RESULT$PLAN_QTY = @C_RESULT$REMAIN_QTY
                            
                        END
                        
                      END
                    ELSE    -- @C_BOR$TACT_TIME * @C_BOR$UTILIZATION * @C_BOR$YIELD = 0 일 때
                      BEGIN
                        -- # 1분 CAPA 를 주어 SET 는 유지하도록 한다.
                        SET @C_RESULT$ASSIGN_CAPA = 60
                        SET @C_RESULT$PLAN_QTY    = @C_RESULT$REMAIN_QTY
                        
                      END
                  
                    UPDATE TH_BUF_SCM_RESCHEDULE_APG_CALENDAR
                    SET    REMAIN_CAPA = REMAIN_CAPA - @C_RESULT$ASSIGN_CAPA
                          ,ASSIGN_CAPA = ASSIGN_CAPA + @C_RESULT$ASSIGN_CAPA
                    WHERE  MASTER_ID      = @v_master_id
                    AND    PLAN_ID        = @v_plan_id
                    AND    PLAN_GROUP_ID  = @v_plan_group_id
                    AND    OFFTIME_SET_ID = @C_PLAN$RESOURCE_ID
                    AND    PLAN_DATE      = @C_CAL$PLAN_DATE
                    AND    START_TIME     = @C_CAL$START_TIME
                    AND    END_TIME       = @C_CAL$END_TIME
                    
                    IF @C_CHECK$WORK_ORDER_ID != @C_PLAN$WORK_ORDER_ID
                      INSERT INTO TH_BUF_SCM_RESCHEDULE_APG_RESULT
                             (
                              MASTER_ID
                            , PLAN_ID
                            , PLAN_GROUP_ID
                            , SITE_ID
                            , ROUTE_ID
                            , OPERATION_ID
                            , RESOURCE_ID
                            , ITEM_ID
                            , LANE_QTY
                            , WORK_ORDER_ID
                            , PLAN_DATE
                            , START_TIME
                            , END_TIME
                            , PLAN_QTY
                            , PLAN_IN_QTY
                            , CAPA_TYPE
                            , FIXED_YN
                            , ASSIGN_SEQ
                            , DEMAND_ID
                            , NEW_WORK_ORDER_ID
                            , INSERT_ID
                            , INSERT_TIME
                             )
                      SELECT  @v_master_id,
                              @v_plan_id,
                              @v_plan_group_id,
                              @C_PLAN$SITE_ID,
                              @C_PLAN$ROUTE_ID,
                              @C_PLAN$OPERATION_ID,
                              @C_PLAN$RESOURCE_ID,
                              @C_PLAN$ITEM_ID,
                              @C_PLAN$LANE_QTY,
                              @C_PLAN$WORK_ORDER_ID,
                              @C_CAL$PLAN_DATE,
                              @C_CAL$PLAN_START_TIME            AS START_TIME,
                              CASE WHEN DATEADD(SECOND, @C_RESULT$ASSIGN_CAPA, @C_CAL$PLAN_START_TIME) > @C_CAL$END_TIME THEN @C_CAL$END_TIME
                                   ELSE DATEADD(SECOND, @C_RESULT$ASSIGN_CAPA, @C_CAL$PLAN_START_TIME)
                              END  AS END_TIME,
                              @C_RESULT$PLAN_QTY                AS PLAN_QTY,
                              @C_PLAN$PLAN_IN_QTY               AS PLAN_IN_QTY,
                              @C_PLAN$CAPA_TYPE                 AS CAPA_TYPE,
                              @C_PLAN$FIXED_YN                  AS FIXED_YN,
                              @v_assign_cnt                     AS ASSGIN_CNT,
                              NULL                              AS DEMAND_ID,
                              NULL                              AS NEW_WORK_ORDER_ID,
                              '3333'							AS INSERT_ID,
                              GETDATE()                         AS INSERT_TIME
                    
                    ELSE
                      UPDATE TH_BUF_SCM_RESCHEDULE_APG_RESULT
                      SET    PLAN_QTY      += @C_RESULT$PLAN_QTY
                           , PLAN_IN_QTY   += 0
                           , END_TIME       = (
                                                CASE WHEN DATEADD(SECOND, @C_RESULT$ASSIGN_CAPA, @C_CAL$PLAN_START_TIME) > @C_CAL$END_TIME THEN @C_CAL$END_TIME
                                                     ELSE DATEADD(SECOND, @C_RESULT$ASSIGN_CAPA, @C_CAL$PLAN_START_TIME)
                                                END                             
                                              )
                      WHERE  MASTER_ID      = @v_master_id
                      AND    PLAN_ID        = @v_plan_id
                      AND    PLAN_GROUP_ID  = @v_plan_group_id
                      AND    WORK_ORDER_ID  = @C_PLAN$WORK_ORDER_ID
                      AND    CAPA_TYPE     != 'SETUP'

                    
                    SET @C_RESULT$REMAIN_QTY = @C_RESULT$REMAIN_QTY - @C_RESULT$PLAN_QTY
                    
                    SET @v_assign_cnt = @v_assign_cnt + 1

                    SET @C_CHECK$WORK_ORDER_ID = @C_PLAN$WORK_ORDER_ID

                  END
                ELSE
                  BEGIN

                    SELECT @C_RESULT$START_TIME = 
                              ( CASE WHEN MIN(START_TIME) > DATEADD(MINUTE, @C_PLAN$SEQ_DESC * (-1),  MAX(END_TIME)) THEN MIN(START_TIME)
                                     ELSE DATEADD(MINUTE, @C_PLAN$SEQ_DESC * (-1),  MAX(END_TIME))
                                END )
                         , @C_RESULT$END_TIME = MAX(END_TIME)
                    FROM   TH_BUF_SCM_RESCHEDULE_APG_CALENDAR A
                    WHERE  A.MASTER_ID      = @v_master_id
                    AND    A.PLAN_ID        = @v_plan_id
                    AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                    --AND    A.PLAN_DATE     >= @C_PLAN$PLAN_DATE
                    AND    A.PLAN_DATE      = @C_PLAN$PLAN_DATE   -- 당일만 본다.
                    AND    A.OFFTIME_SET_ID = @C_PLAN$RESOURCE_ID
                    GROUP  BY A.OFFTIME_SET_ID, A.PLAN_DATE
                    
                    IF @C_RESULT$START_TIME IS NULL
                      BEGIN
                        SET @C_RESULT$START_TIME = DATEADD(MINUTE, @v_daydiff + 1440 - @C_PLAN$SEQ_DESC, CONVERT(DATETIME, CONVERT(DATE, @C_PLAN$PLAN_DATE)))
                        SET @C_RESULT$END_TIME   = DATEADD(MINUTE, @v_daydiff + 1440, CONVERT(DATETIME, CONVERT(DATE, @C_PLAN$PLAN_DATE)))                        
                      END
                  
                    IF @C_CHECK$WORK_ORDER_ID != @C_PLAN$WORK_ORDER_ID
                      INSERT INTO TH_BUF_SCM_RESCHEDULE_APG_RESULT
                             (
                              MASTER_ID
                            , PLAN_ID
                            , PLAN_GROUP_ID
                            , SITE_ID
                            , ROUTE_ID
                            , OPERATION_ID
                            , RESOURCE_ID
                            , ITEM_ID
                            , LANE_QTY
                            , WORK_ORDER_ID
                            , PLAN_DATE
                            , START_TIME
                            , END_TIME
                            , PLAN_QTY
                            , PLAN_IN_QTY
                            , CAPA_TYPE
                            , FIXED_YN
                            , ASSIGN_SEQ
                            , DEMAND_ID
                            , NEW_WORK_ORDER_ID
                            , INSERT_ID
                            , INSERT_TIME
                             )
                      SELECT  @v_master_id,
                              @v_plan_id,
                              @v_plan_group_id,
                              @C_PLAN$SITE_ID,
                              @C_PLAN$ROUTE_ID,
                              @C_PLAN$OPERATION_ID,
                              @C_PLAN$RESOURCE_ID,
                              @C_PLAN$ITEM_ID,
                              @C_PLAN$LANE_QTY,
                              @C_PLAN$WORK_ORDER_ID,
                              @C_PLAN$PLAN_DATE,
                              @C_RESULT$START_TIME    AS START_TIME,
                              @C_RESULT$END_TIME      AS END_TIME,
                              @C_RESULT$REMAIN_QTY    AS PLAN_QTY,
                              @C_PLAN$PLAN_IN_QTY     AS PLAN_IN_QTY,
                              @C_PLAN$CAPA_TYPE       AS CAPA_TYPE,
                              @C_PLAN$FIXED_YN        AS FIXED_YN,
                              @v_assign_cnt           AS ASSGIN_CNT,
                              NULL                    AS DEMAND_ID,
                              NULL                    AS NEW_WORK_ORDER_ID,
                              '4444'                  AS INSERT_ID,
                              GETDATE()               AS INSERT_TIME

                      ELSE
                        UPDATE TH_BUF_SCM_RESCHEDULE_APG_RESULT
                        SET    PLAN_QTY      += @C_RESULT$REMAIN_QTY
                             , PLAN_IN_QTY   += 0
                             , END_TIME       = @C_RESULT$END_TIME
                        WHERE  MASTER_ID      = @v_master_id
                        AND    PLAN_ID        = @v_plan_id
                        AND    PLAN_GROUP_ID  = @v_plan_group_id
                        AND    WORK_ORDER_ID  = @C_PLAN$WORK_ORDER_ID
                        AND    CAPA_TYPE     != 'SETUP'

                      
                    SET @C_RESULT$REMAIN_QTY = 0

                    SET @v_assign_cnt = @v_assign_cnt + 1
                    
                    SET @C_CHECK$WORK_ORDER_ID = @C_PLAN$WORK_ORDER_ID

                  END                
              
              END

              
            IF    @n_loop > 20    -- 무한 LOOP 방지
               OR @C_RESULT$REMAIN_QTY <= 0
               BREAK

          END


      END

      CLOSE C_PLAN

      DEALLOCATE C_PLAN

      --LOG 생성
      SET @v_message = ' C_PLAN : COMPLETE'
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
  
      ----------------------------------------------------------------------------------------------------------------------------
      -- BATCH 이 반영된 OPERATION 만 진행..
      ----------------------------------------------------------------------------------------------------------------------------

      DECLARE C_BATCH CURSOR FOR 
        SELECT A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.RESOURCE_ID, A.GROUP_SEQ, A.ITEM_ID, A.CAPA_TYPE, A.LANE_QTY, A.LANE_TACT_QTY, 
               A.WORK_ORDER_ID, A.PLAN_DATE, A.PLAN_QTY, A.PLAN_IN_QTY, A.FIXED_YN, --B.SETUP_TIME, B.SETUP_TIME_UOM,
               A.SEQ_DESC,    -- 이놈은 CAPA 부족할때 START 를 잡아줄 분단위로 설정한다.
               ISNULL(C.TAT, 1) 
                  * CASE C.TAT_UOM        WHEN 'SECOND' THEN 1
                                          WHEN 'MINUTE' THEN 60
                                          WHEN 'HOUR'   THEN 3600
                                          WHEN 'DAY'    THEN 86400
                                                        ELSE 60     END AS BATCH_TIME_SECOND,
               ISNULL(B.SETUP_TIME, 0.0) 
                  * CASE B.SETUP_TIME_UOM WHEN 'SECOND' THEN 1
                                          WHEN 'MINUTE' THEN 60
                                          WHEN 'HOUR'   THEN 3600
                                          WHEN 'DAY'    THEN 86400
                                                        ELSE 60     END AS SETUP_TIME_SECOND
        FROM   (
                SELECT A.*,
                       LAG(SETUP_GROUP_ID, 1, NULL) OVER (PARTITION BY SITE_ID, ROUTE_ID, OPERATION_ID, RESOURCE_ID ORDER BY GROUP_SEQ) AS PRE_SETUP_GROUP_ID,
                       DENSE_RANK() OVER (PARTITION BY SITE_ID, ROUTE_ID, OPERATION_ID, RESOURCE_ID, PLAN_DATE ORDER BY GROUP_SEQ DESC) AS SEQ_DESC
                FROM   TH_BUF_SCM_RESCHEDULE_APG_PLAN A
                WHERE  MASTER_ID      = @v_master_id
                AND    PLAN_ID        = @v_plan_id
                AND    PLAN_GROUP_ID  = @v_plan_group_id
                AND    CAPA_TYPE      = 'BATCH'
               ) A
               LEFT OUTER JOIN TH_BUF_SCM_RESCHEDULE_APG_SETUP_MATRIX B
                    ON    A.MASTER_ID = B.MASTER_ID
                    AND   A.PLAN_ID = B.PLAN_ID
                    AND   A.PLAN_GROUP_ID  = B.PLAN_GROUP_ID
                    AND   A.RESOURCE_SETUP_GROUP_ID = B.RESOURCE_SETUP_GROUP_ID
                    AND   A.PRE_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
                    AND   A.SETUP_GROUP_ID     = B.TO_SETUP_GROUP_ID
               LEFT OUTER JOIN SCM_ITEM_EQUIP_RATE_BATCH_M C
                    ON    A.SITE_ID       = C.FACTORY_ID
                    AND   A.OPERATION_ID  = C.OPERATION_ID
                    AND   A.ITEM_ID       = C.ITEM_ID
        ORDER  BY SITE_ID, ROUTE_ID, OPERATION_ID, RESOURCE_ID, GROUP_SEQ

      ----------------------------------------------------------------------------------------------------------------------------
      DECLARE 
        @C_BATCH$SITE_ID         nvarchar(150),
        @C_BATCH$ROUTE_ID        nvarchar(150),
        @C_BATCH$OPERATION_ID    nvarchar(150),
        @C_BATCH$RESOURCE_ID     nvarchar(150),
        @C_BATCH$GROUP_SEQ       int,
        @C_BATCH$ITEM_ID         nvarchar(150),
        @C_BATCH$CAPA_TYPE       nvarchar(50),
        @C_BATCH$LANE_QTY        numeric(20,10),
        @C_BATCH$LANE_TACT_QTY   numeric(20,10),
        @C_BATCH$WORK_ORDER_ID   nvarchar(150),
        @C_BATCH$PLAN_DATE       nvarchar(8),
        @C_BATCH$PLAN_QTY        numeric(20,10),
        @C_BATCH$PLAN_IN_QTY     numeric(20,10),
        @C_BATCH$FIXED_YN        nvarchar(8),
        @C_BATCH$SEQ_DESC        int,
        @C_BATCH$BATCH_TIME      numeric(20,10),
        @C_BATCH$SETUP_TIME      numeric(20,10)
      
      DECLARE
        @C_BT_RES$RESOURCE_ID         nvarchar(150) = 'NULL',
        @C_BT_RES$PLAN_DATE           nvarchar(8)   = 'NULL',
        @C_BT_RES$DAY_START_TIME      DATETIME,
        @C_BT_RES$DAY_END_TIME        DATETIME,
        @C_BT_RES$ASSIGN_START_TIME   DATETIME,
        @C_BT_RES$ASSIGN_END_TIME     DATETIME
        
        
      OPEN C_BATCH    
      WHILE 1 = 1

      BEGIN

        -- 시간 조정할 WORK 을 차례대로 조회한다.
        FETCH C_BATCH
         INTO @C_BATCH$SITE_ID,
              @C_BATCH$ROUTE_ID,
              @C_BATCH$OPERATION_ID,
              @C_BATCH$RESOURCE_ID,
              @C_BATCH$GROUP_SEQ,
              @C_BATCH$ITEM_ID,
              @C_BATCH$CAPA_TYPE,
              @C_BATCH$LANE_QTY,
              @C_BATCH$LANE_TACT_QTY,
              @C_BATCH$WORK_ORDER_ID,
              @C_BATCH$PLAN_DATE,
              @C_BATCH$PLAN_QTY,
              @C_BATCH$PLAN_IN_QTY,
              @C_BATCH$FIXED_YN,
              @C_BATCH$SEQ_DESC,
              @C_BATCH$BATCH_TIME,
              @C_BATCH$SETUP_TIME

          IF @@FETCH_STATUS <> 0
            BREAK
          
          IF     @C_BT_RES$RESOURCE_ID != @C_BATCH$RESOURCE_ID
              OR @C_BT_RES$PLAN_DATE   != @C_BATCH$PLAN_DATE
            BEGIN
            
              SET @C_BT_RES$RESOURCE_ID = @C_BATCH$RESOURCE_ID
              SET @C_BT_RES$PLAN_DATE    = @C_BATCH$PLAN_DATE
              
              SET @C_BT_RES$DAY_START_TIME = DATEADD(MINUTE,  DATEDIFF(MINUTE, CONVERT(DATE, @plan_start_time), @plan_start_time),
                                                              CONVERT(DATETIME, @C_BATCH$PLAN_DATE)
                                                     )
                                                     
              SET @C_BT_RES$ASSIGN_START_TIME = @C_BT_RES$DAY_START_TIME
              SET @C_BT_RES$DAY_END_TIME = DATEADD(DAY, 1, @C_BT_RES$DAY_START_TIME)
            END
          
          SET @C_BT_RES$ASSIGN_END_TIME = DATEADD(SECOND, @C_BATCH$BATCH_TIME, @C_BT_RES$ASSIGN_START_TIME)
          
          IF @C_BT_RES$ASSIGN_END_TIME > @C_BT_RES$DAY_END_TIME
            BEGIN
            
              SET @C_BT_RES$ASSIGN_END_TIME = @C_BT_RES$DAY_END_TIME
              SET @C_BT_RES$ASSIGN_START_TIME = DATEADD(MINUTE, @C_BATCH$SEQ_DESC * (-1), @C_BT_RES$ASSIGN_END_TIME)
            
            END
          
          INSERT INTO TH_BUF_SCM_RESCHEDULE_APG_RESULT
                 (
                  MASTER_ID
                , PLAN_ID
                , PLAN_GROUP_ID
                , SITE_ID
                , ROUTE_ID
                , OPERATION_ID
                , RESOURCE_ID
                , ITEM_ID
                , LANE_QTY
                , WORK_ORDER_ID
                , PLAN_DATE
                , START_TIME
                , END_TIME
                , PLAN_QTY
                , PLAN_IN_QTY
                , CAPA_TYPE
                , FIXED_YN
                , ASSIGN_SEQ
                , DEMAND_ID
                , NEW_WORK_ORDER_ID
                , INSERT_ID
                , INSERT_TIME
                 )
          SELECT  @v_master_id,
                  @v_plan_id,
                  @v_plan_group_id,
                  @C_BATCH$SITE_ID,
                  @C_BATCH$ROUTE_ID,
                  @C_BATCH$OPERATION_ID,
                  @C_BATCH$RESOURCE_ID,
                  @C_BATCH$ITEM_ID,
                  @C_BATCH$LANE_QTY,
                  @C_BATCH$WORK_ORDER_ID,
                  @C_BATCH$PLAN_DATE                            AS PLAN_DATE,
                  @C_BT_RES$ASSIGN_START_TIME                   AS START_TIME,
                  --@C_BT_RES$ASSIGN_END_TIME                     AS END_TIME,
                  DATEADD(SECOND, -1, @C_BT_RES$DAY_END_TIME )  AS END_TIME,
                  @C_BATCH$PLAN_QTY                             AS PLAN_QTY,
                  @C_BATCH$PLAN_IN_QTY                          AS PLAN_IN_QTY,
                  @C_BATCH$CAPA_TYPE                            AS CAPA_TYPE,
                  @C_BATCH$FIXED_YN                             AS FIXED_YN,
                  @v_assign_cnt                                 AS ASSGIN_CNT,
                  NULL                                          AS DEMAND_ID,
                  NULL                                          AS NEW_WORK_ORDER_ID,
                  @v_proc_name                                  AS INSERT_ID,
                  GETDATE()                                     AS INSERT_TIME

          SET @v_assign_cnt = @v_assign_cnt + 1

          SET @C_BT_RES$ASSIGN_START_TIME = @C_BT_RES$ASSIGN_END_TIME
          
      END

      CLOSE C_BATCH

      DEALLOCATE C_BATCH

      --LOG 생성
      SET @v_message = ' C_BATCH : COMPLETE'
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


      BEGIN
        -- QTY 0 제거
        
        DELETE FROM TH_BUF_SCM_RESCHEDULE_APG_RESULT
        WHERE  MASTER_ID      = @v_master_id
        AND    PLAN_ID        = @v_plan_id
        AND    PLAN_GROUP_ID  = @v_plan_group_id
        AND    PLAN_QTY       = 0  
      
        -- 중복 제거
        UPDATE TH_BUF_SCM_RESCHEDULE_APG_RESULT
        SET    TH_BUF_SCM_RESCHEDULE_APG_RESULT.NEW_WORK_ORDER_ID = B.WORK_ORDER_ID +
                                                                                      CASE WHEN SEQ = 1 THEN ''
                                                                                           ELSE + '_'+ CONVERT(NVARCHAR, SEQ)
                                                                                      END
        FROM   TH_BUF_SCM_RESCHEDULE_APG_RESULT A,
               (
                SELECT A.*
                FROM   (
                        SELECT A.*,
                               COUNT(1) OVER (PARTITION BY WORK_ORDER_ID ) AS CNT,
                               DENSE_RANK() OVER (PARTITION BY WORK_ORDER_ID ORDER BY ASSIGN_SEQ) AS SEQ
                        FROM   TH_BUF_SCM_RESCHEDULE_APG_RESULT A
                        WHERE  A.MASTER_iD      = @v_master_id
                        AND    A.PLAN_ID        = @v_plan_id
                        AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                        AND    A.FIXED_YN       = 'N'
                       ) A
               ) B
        WHERE  A.MASTER_iD      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.PLAN_GROUP_ID  = @v_plan_group_id
        AND    A.WORK_ORDER_ID  = B.WORK_ORDER_ID
        AND    A.ASSIGN_SEQ     = B.ASSIGN_SEQ
        
        
        INSERT INTO TH_BUF_SCM_RESCHEDULE_APG_RESULT
               (
                MASTER_ID, PLAN_ID, PLAN_GROUP_ID, 
                SITE_ID, ROUTE_ID, OPERATION_ID, RESOURCE_ID, ITEM_ID, LANE_QTY, WORK_ORDER_ID, PLAN_DATE,
                START_TIME, END_TIME, PLAN_QTY, PLAN_IN_QTY, CAPA_TYPE, FIXED_YN, ASSIGN_SEQ, DEMAND_ID, NEW_WORK_ORDER_ID,
                INSERT_ID, INSERT_TIME       
               )
        SELECT MASTER_ID, PLAN_ID, @v_plan_group_id AS PLAN_GROUP_ID,
               SITE_ID, ROUTE_ID, OPERATION_ID, RESOURCE_ID, ITEM_ID, LANE_QTY, WORK_ORDER_ID,
               AFTER_PLAN_DATE, ADJUST_START_TIME, ADJUST_END_TIME, PLAN_QTY, PLAN_IN_QTY, 'TACT' AS CAPA_TYPE,
               FIXED_YN, 999999 ASSIGN_SEQ, DEMAND_ID, WORK_ORDER_ID AS NEW_WORK_ORDER_ID,
               'A6000' AS INSERT_ID, GETDATE() AS INSERT_TIME
        FROM   (
                SELECT A.*,
                       CASE WHEN NEW_END_TIME > PLAN_DATE_END THEN DATEADD(MINUTE, SEQ_DESC *(-1), PLAN_DATE_END)
                            ELSE NEW_START_TIME
                       END  AS ADJUST_START_TIME,
                       CASE WHEN NEW_END_TIME > PLAN_DATE_END THEN PLAN_DATE_END
                            ELSE NEW_END_TIME
                       END  AS ADJUST_END_TIME
                FROM   (
                        SELECT A.*,
                               DATEADD(SECOND, SUM_DIFF_SECOND - DIFF_SECOND, PLAN_DATE_START) AS NEW_START_TIME,
                               DATEADD(SECOND, SUM_DIFF_SECOND, PLAN_DATE_START) AS NEW_END_TIME
                        FROM   (
                                SELECT A.*,
                                       SUM(DIFF_SECOND) OVER (PARTITION BY SITE_ID, ROUTE_ID, OPERATION_ID, RESOURCE_ID, AFTER_PLAN_DATE
                                                              ORDER  BY AFTER_SEQ) AS SUM_DIFF_SECOND,
                                       DENSE_RANK() OVER (PARTITION BY SITE_ID, ROUTE_ID, OPERATION_ID, RESOURCE_ID, AFTER_PLAN_DATE
                                                              ORDER  BY AFTER_SEQ DESC) AS SEQ_DESC
                                FROM   (
                                        SELECT A.*,
                                               DATEDIFF(SECOND, AFTER_START_TIME, AFTER_END_TIME) AS DIFF_SECOND
                                        FROM   (
                                                SELECT MASTER_ID, 
                                                       PLAN_ID, 
                                                       AFTER_SITE_ID      SITE_ID, 
                                                       AFTER_ROUTE_ID     ROUTE_ID, 
                                                       AFTER_OPERATION_ID OPERATION_ID, 
                                                       AFTER_RESOURCE_ID  RESOURCE_ID, 
                                                       ITEM_ID, 
                                                       LANE_QTY, 
                                                       WORK_ORDER_ID,
                                                       AFTER_PLAN_DATE, 
                                                       AFTER_SEQ,
                                                       DATEADD(MINUTE, @v_daydiff, CONVERT(DATETIME, AFTER_PLAN_DATE)) AS PLAN_DATE_START,
                                                       DATEADD(MINUTE, @v_daydiff+1440, CONVERT(DATETIME, AFTER_PLAN_DATE)) AS PLAN_DATE_END,
                                                       CONVERT(DATETIME, AFTER_PLAN_DATE) AS DD,
                                                       CONVERT(DATETIME, SUBSTRING(AFTER_START_TIME, 1, 4) 
                                                                         + '-' + SUBSTRING(AFTER_START_TIME, 5, 2)
                                                                         + '-' + SUBSTRING(AFTER_START_TIME, 7, 2)
                                                                         + ' ' + SUBSTRING(AFTER_START_TIME, 9, 2)
                                                                         + ':' + SUBSTRING(AFTER_START_TIME, 11, 2)
                                                                         + ':' + SUBSTRING(AFTER_START_TIME, 13, 2)) AS AFTER_START_TIME,
                                                       CONVERT(DATETIME, SUBSTRING(AFTER_END_TIME, 1, 4) 
                                                                         + '-' + SUBSTRING(AFTER_END_TIME, 5, 2)
                                                                         + '-' + SUBSTRING(AFTER_END_TIME, 7, 2)
                                                                         + ' ' + SUBSTRING(AFTER_END_TIME, 9, 2)
                                                                         + ':' + SUBSTRING(AFTER_END_TIME, 11, 2)
                                                                         + ':' + SUBSTRING(AFTER_END_TIME, 13, 2)) AS AFTER_END_TIME,
                                                       AFTER_QTY AS PLAN_QTY,
                                                       AFTER_IN_QTY AS PLAN_IN_QTY,
                                                       'TAT' AS CAPA_TYPE,
                                                       CASE WHEN FIXED_YN IS NULL THEN 'N'
                                                            WHEN FIXED_YN = ''    THEN 'N'
                                                            ELSE FIXED_YN
                                                       END  AS FIXED_YN,
                                                       9999 AS ASSIGN_SEQ,
                                                       DEMAND_ID
                                                FROM   FP_AMEND_PRODUCTION_PLAN_R A
                                                WHERE  MASTER_ID          = @v_master_id
                                                AND    PLAN_ID            = @v_plan_id
                                                AND    AFTER_OPERATION_ID = 'A6000'
                                                AND    EXISTS (
                                                                SELECT 1
                                                                FROM   SCM_LINE_M X WITH(NOLOCK)
                                                                WHERE  X.ACTIVE_FLAG  = 'Y'
                                                                AND    X.FACTORY_ID   = A.AFTER_SITE_ID
                                                                AND    X.LINE_ID      = A.AFTER_ROUTE_ID
                                                                AND    X.OPERATION_ID = A.AFTER_OPERATION_ID
                                                                AND    X.MODEL_TYPE   = @v_plan_group_id
                                                              )
                                               ) A
                                       ) A
                               ) A
                       ) A
               ) A
            
        --LOG 생성
        SET @v_message = ' VD : COMPLETE'
        SET @n_log_count = @n_log_count + 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        

        -- DEMAND ID 채번
        UPDATE TH_BUF_SCM_RESCHEDULE_APG_RESULT
        SET    TH_BUF_SCM_RESCHEDULE_APG_RESULT.DEMAND_ID = B.DEMAND_ID
        FROM   TH_BUF_SCM_RESCHEDULE_APG_RESULT A,
               FP_AMEND_PRODUCTION_PLAN_R B
        WHERE  A.MASTER_ID      = B.MASTER_ID
        AND    A.PLAN_ID        = B.PLAN_ID
        AND    A.WORK_ORDER_ID  = B.WORK_ORDER_ID
        AND    A.MASTER_ID      = @v_master_id
        AND    A.PLAN_ID        = @v_plan_id
        AND    A.PLAN_GROUP_ID  = @v_plan_group_id
                  
      END
      
    END
    
    ELSE
    
    BEGIN

      SET @v_message = 'NOT EXCUTE RE-SCHEDULE'
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, null, 'SELECT', @n_log_count, null, @v_message, null 
      

      SET @v_table_name = 'TH_BUF_SCM_RESCHEDULE_APG_RESULT'

      DELETE FROM TH_BUF_SCM_RESCHEDULE_APG_RESULT
      WHERE  MASTER_ID = @v_master_id and plan_id = @v_plan_id and plan_group_id = @v_plan_group_id
      
      INSERT INTO TH_BUF_SCM_RESCHEDULE_APG_RESULT
           (
             MASTER_ID
           , PLAN_ID
           , PLAN_GROUP_ID
           , SITE_ID
           , ROUTE_ID
           , OPERATION_ID
           , RESOURCE_ID
           , ITEM_ID
           , LANE_QTY
           , WORK_ORDER_ID
           , PLAN_DATE
           , START_TIME
           , END_TIME
           , PLAN_QTY
           , PLAN_IN_QTY
           , CAPA_TYPE
           , FIXED_YN
           , ASSIGN_SEQ
           , DEMAND_ID
           , NEW_WORK_ORDER_ID
           , INSERT_ID
           , INSERT_TIME           
           )
      SELECT A.MASTER_ID
           , A.PLAN_ID
           , @v_plan_group_id AS PLAN_GROUP_ID
           , A.AFTER_SITE_ID
           , A.AFTER_ROUTE_ID
           , A.AFTER_OPERATION_ID
           , A.AFTER_RESOURCE_ID
           , A.ITEM_ID
           , A.LANE_QTY
           , A.WORK_ORDER_ID
           , A.AFTER_PLAN_DATE
           , CONVERT(DATETIME, SUBSTRING(AFTER_START_TIME, 1, 4) 
                               + '-' + SUBSTRING(AFTER_START_TIME, 5, 2)
                               + '-' + SUBSTRING(AFTER_START_TIME, 7, 2)
                               + ' ' + SUBSTRING(AFTER_START_TIME, 9, 2)
                               + ':' + SUBSTRING(AFTER_START_TIME, 11, 2)
                               + ':' + SUBSTRING(AFTER_START_TIME, 13, 2)) AS AFTER_START_TIME
           , CONVERT(DATETIME, SUBSTRING(AFTER_END_TIME, 1, 4) 
                               + '-' + SUBSTRING(AFTER_END_TIME, 5, 2)
                               + '-' + SUBSTRING(AFTER_END_TIME, 7, 2)
                               + ' ' + SUBSTRING(AFTER_END_TIME, 9, 2)
                               + ':' + SUBSTRING(AFTER_END_TIME, 11, 2)
                               + ':' + SUBSTRING(AFTER_END_TIME, 13, 2)) AS AFTER_END_TIME
           , A.AFTER_QTY AS PLAN_QTY
           , A.AFTER_IN_QTY AS PLAN_IN_QTY
           , 'TACT' AS CAPA_TYPE
           , CASE WHEN A.FIXED_YN IS NULL THEN 'N'
                  WHEN A.FIXED_YN = ''    THEN 'N'
                  ELSE A.FIXED_YN
             END  AS FIXED_YN
           , DENSE_RANK() OVER (PARTITION BY AFTER_RESOURCE_ID ORDER BY A.AFTER_PLAN_DATE, A.AFTER_SEQ) AS ASSIGN_SEQ
           , A.DEMAND_ID
           , A.WORK_ORDER_ID AS NEW_WORK_ORDER_ID
           , 'NOT-AMEND' AS INSERT_ID
           , GETDATE() AS INSERT_TIME
      FROM   FP_AMEND_PRODUCTION_PLAN_R A
      WHERE  A.MASTER_ID      = @v_master_id
      AND    A.PLAN_ID        = @v_plan_id
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X WITH(NOLOCK)
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.AFTER_SITE_ID
                      AND    X.LINE_ID      = A.AFTER_ROUTE_ID
                      AND    X.OPERATION_ID = A.AFTER_OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )

    END
      --------------------------------------------------------------------------------------------------------------------------
      -- RESCHEDULE 부분 : END
      --------------------------------------------------------------------------------------------------------------------------

    BEGIN

      BEGIN

        SET @v_table_name = 'TH_BUF_SCM_RESCHEDULE_APG_RESULT'
        
        UPDATE TH_BUF_SCM_RESCHEDULE_APG_RESULT
        SET    REMAIN_PLAN_QTY    = PLAN_QTY,
               REMAIN_PLAN_IN_QTY = PLAN_IN_QTY
        WHERE  MASTER_ID      = @v_master_id
        AND    PLAN_ID        = @v_plan_id
        AND    PLAN_GROUP_ID  = @v_plan_group_id

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END

      BEGIN

        UPDATE TH_BUF_SCM_RESCHEDULE_APG_RESULT
        SET    TH_BUF_SCM_RESCHEDULE_APG_RESULT.ELECTRODE_TYPE = B.ELECTRODE_TYPE
             , TH_BUF_SCM_RESCHEDULE_APG_RESULT.WORK_CENTER_ID = B.WORK_CENTER_ID
        FROM   TH_BUF_SCM_RESCHEDULE_APG_RESULT A,
               (
                SELECT DISTINCT
                       COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, 
                       MIN(WORK_CENTER_ID) AS WORK_CENTER_ID,
                       LINE_ID +'_'+OPERATION_ID
                                 +CASE ELECTRODE_TYPE 
                                      WHEN NULL   THEN '' 
                                      WHEN ''     THEN '' 
                                      WHEN '-'    THEN '' 
                                      ELSE '_'+ELECTRODE_TYPE 
                                  END  AS RESOURCE_ID
                FROM   SCM_EQUIPMENT_M WITH(NOLOCK)
                WHERE  EQUIPMENT_TYPE = 'M'
                GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE
               ) B
        WHERE  A.MASTER_ID        = @v_master_id
        AND    A.PLAN_ID          = @v_plan_id
        AND    A.PLAN_GROUP_ID    = @v_plan_group_id
        AND    A.RESOURCE_ID      = B.RESOURCE_ID
        
        UPDATE TH_BUF_SCM_RESCHEDULE_APG_RESULT
        SET    TH_BUF_SCM_RESCHEDULE_APG_RESULT.ELECTRODE_TYPE = B.ELECTRODE_TYPE
             , TH_BUF_SCM_RESCHEDULE_APG_RESULT.WORK_CENTER_ID = B.WORK_CENTER_ID
        FROM   TH_BUF_SCM_RESCHEDULE_APG_RESULT A,
               (
                SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, 
                       WORK_CENTER_ID, 
                       EQUIPMENT_ID AS RESOURCE_ID
                FROM   SCM_EQUIPMENT_M WITH(NOLOCK)
                WHERE  EQUIPMENT_TYPE = 'M'
               ) B
        WHERE  A.MASTER_ID        = @v_master_id
        AND    A.PLAN_ID          = @v_plan_id
        AND    A.PLAN_GROUP_ID    = @v_plan_group_id
        AND    A.RESOURCE_ID      = B.RESOURCE_ID

      END


      --------------------------------------------------
      --------------------------------------------------
      --------------------------------------------------*/

      ---------------------------------------------------------------------------------------
      -- FP_DAILY_PRODUCTION_PLAN_R 
      ---------------------------------------------------------------------------------------
      SET @v_table_name = 'FP_DAILY_PRODUCTION_PLAN_R'
      
      -- DAILY_PRODUCTION_PLAN_R
      DELETE FROM A
      FROM   FP_DAILY_PRODUCTION_PLAN_R A
      WHERE  INSTANCE_ID  = @v_master_id
      AND    FP_PLAN_ID   = @v_plan_id +'_BACK'
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X WITH(NOLOCK)
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.FACTORY_ID
                      AND    X.LINE_ID      = A.LINE_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )

      UPDATE FP_DAILY_PRODUCTION_PLAN_R
      SET    FP_DAILY_PRODUCTION_PLAN_R.FP_PLAN_ID = @v_plan_id +'_BACK'
      FROM   FP_DAILY_PRODUCTION_PLAN_R A
      WHERE  A.INSTANCE_ID     = @v_master_id
      AND    A.FP_PLAN_ID      = @v_plan_id
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X WITH(NOLOCK)
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.FACTORY_ID
                      AND    X.LINE_ID      = A.LINE_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )

      SET @v_message = @@ROWCOUNT
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_DAILY_PRODUCTION_PLAN_R', 'DELETE', @n_log_count, null, @v_message, null 

      INSERT INTO FP_DAILY_PRODUCTION_PLAN_R
            (
              INSTANCE_ID
            , FP_PLAN_ID
            , COMPANY_ID
            , DIVISION_ID
            , SITE_ID
            , PLANT_ID
            , FACTORY_ID
            , WORK_ORDER_SPL_ID
            , WORK_ORDER_ID
            , ORG_DEMAND_ID
            , DEMAND_ID
            , ITEM_ID
            , TOP_ITEM_ID
            , OPERATION_ID
            , LINE_ID
            , ELECTRODE_TYPE
            , EQUIPMENT_ID
            , PLAN_DATE
            , START_TIME
            , END_TIME
            , PLAN_QTY
            , PLAN_IN_QTY
            , ITEM_UOM
            , FIX_TYPE
            , PRODUCTION_TYPE
            , TOTAL_WORKING_TIME
            , LINE_ITEM_SEQ
            , OPERATION_ITEM_SEQ
            , LANE_QTY
            , LANE_TACT_QTY
            , BATCH_ORDER_ID
            , BIN_ORDER_ID
            , MFG_WEEK
            , INSERT_ID
            , INSERT_DTTM            
            )          
              SELECT 
                     A.MASTER_ID
                   , A.PLAN_ID
                   , B.COMPANY_ID
                   , B.DIVISION_ID
                   , B.SITE_ID
                   , B.PLANT_ID
                   , A.SITE_ID                  AS FACTORY_ID
                   , A.NEW_WORK_ORDER_ID        AS WORK_ORDER_SPL_ID
                   , A.NEW_WORK_ORDER_ID
                   , B.SCP_TARGET_ID
                   , A.DEMAND_ID
                   , A.ITEM_ID
                   , B.ITEM_ID                  AS TOP_ITEM_ID
                   , A.OPERATION_ID             AS OPERATION_ID
                   , A.ROUTE_ID                 AS LINE_ID
                   , A.ELECTRODE_TYPE
                   , A.RESOURCE_ID              AS EQUIPMENT_ID
                   , A.PLAN_DATE
                   , A.START_TIME
                   , A.END_TIME
                   , A.REMAIN_PLAN_QTY
                   , A.REMAIN_PLAN_IN_QTY
                   , ''                         AS ITEM_UOM
                   , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
                   , B.PRODUCTION_TYPE
                   , 0 TOTAL_WORKING_TIME
                   , 1 LINE_ITEM_SEQ
                   , 1 OPERATION_ITEM_SEQ
                   , A.LANE_QTY
                   , 0 LANE_TACT_QTY
                   , '' BATCH_ORDER_ID
                   , '' BIN_ORDER_ID
                   , B.MFG_WEEK
                   , @v_proc_name   AS INSERT_ID
                   , GETDATE()      AS INSERT_DATE
              FROM   TH_BUF_SCM_RESCHEDULE_APG_RESULT A,
                     FP_DAILY_NET_DEMAND_H B WITH(NOLOCK)
              WHERE  A.MASTER_ID      = @v_master_id
              AND    A.PLAN_ID        = @v_plan_id
              AND    A.PLAN_GROUP_ID  = @v_plan_group_id
              AND    A.MASTER_ID      = B.INSTANCE_ID
              AND    A.PLAN_ID        = B.DPP_PLAN_ID
              AND    A.DEMAND_ID      = B.FP_DEMAND_ID
              AND    A.CAPA_TYPE     != 'SETUP'
              AND    A.FIXED_YN       = 'N'
              AND    A.REMAIN_PLAN_QTY > 0
              UNION  ALL
              SELECT 
                     A.MASTER_ID
                   , A.PLAN_ID
                   , B.COMPANY_ID
                   , B.DIVISION_ID
                   , B.SITE_ID
                   , B.PLANT_ID
                   , A.SITE_ID                  AS FACTORY_ID
                   , A.WORK_ORDER_ID            AS WORK_ORDER_SPL_ID
                   , A.WORK_ORDER_ID
                   , B.SCP_TARGET_ID
                   , A.DEMAND_ID
                   , A.ITEM_ID
                   , B.ITEM_ID                  AS TOP_ITEM_ID
                   , A.OPERATION_ID             AS OPERATION_ID
                   , A.ROUTE_ID                 AS LINE_ID
                   , A.ELECTRODE_TYPE
                   , A.RESOURCE_ID              AS EQUIPMENT_ID
                   , MIN(A.PLAN_DATE)           AS PLAN_DATE
                   , MIN(A.START_TIME)          AS START_TIME
                   , MAX(A.END_TIME)            AS END_TIME
                   , SUM(A.REMAIN_PLAN_QTY)     AS PLAN_QTY
                   , SUM(A.REMAIN_PLAN_IN_QTY)  AS PLAN_IN_QTY
                   , ''                         AS ITEM_UOM
                   , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
                   , B.PRODUCTION_TYPE
                   , 0 TOTAL_WORKING_TIME
                   , 1 LINE_ITEM_SEQ
                   , 1 OPERATION_ITEM_SEQ
                   , A.LANE_QTY
                   , 0 LANE_TACT_QTY
                   , '-' BATCH_ORDER_ID
                   , '-' BIN_ORDER_ID
                   , B.MFG_WEEK
                   , @v_proc_name   AS INSERT_ID
                   , GETDATE()      AS INSERT_DATE
              FROM   TH_BUF_SCM_RESCHEDULE_APG_RESULT A,
                     FP_DAILY_NET_DEMAND_H B WITH(NOLOCK)
              WHERE  A.MASTER_ID      = @v_master_id
              AND    A.PLAN_ID        = @v_plan_id
              AND    A.PLAN_GROUP_ID  = @v_plan_group_id
              AND    A.MASTER_ID      = B.INSTANCE_ID
              AND    A.PLAN_ID        = B.DPP_PLAN_ID
              AND    A.DEMAND_ID      = B.FP_DEMAND_ID
              AND    A.CAPA_TYPE     != 'SETUP'
              AND    A.FIXED_YN       = 'Y'
              AND    A.REMAIN_PLAN_QTY > 0
              GROUP  BY 
                     A.MASTER_ID
                   , A.PLAN_ID
                   , B.COMPANY_ID
                   , B.DIVISION_ID
                   , B.SITE_ID
                   , B.PLANT_ID
                   , A.SITE_ID
                   , A.WORK_ORDER_ID
                   , B.SCP_TARGET_ID
                   , A.DEMAND_ID
                   , A.ITEM_ID
                   , B.ITEM_ID
                   , A.OPERATION_ID
                   , A.ROUTE_ID
                   , A.ELECTRODE_TYPE
                   , A.RESOURCE_ID
                   , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END
                   , B.PRODUCTION_TYPE
                   , A.LANE_QTY
                   , B.MFG_WEEK
               
      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      INSERT INTO FP_DAILY_PRODUCTION_PLAN_R
            (
              INSTANCE_ID
            , FP_PLAN_ID
            , COMPANY_ID
            , DIVISION_ID
            , SITE_ID
            , PLANT_ID
            , FACTORY_ID
            , WORK_ORDER_SPL_ID
            , WORK_ORDER_ID
            , ORG_DEMAND_ID
            , DEMAND_ID
            , ITEM_ID
            , TOP_ITEM_ID
            , OPERATION_ID
            , LINE_ID
            , ELECTRODE_TYPE
            , EQUIPMENT_ID
            , PLAN_DATE
            , START_TIME
            , END_TIME
            , PLAN_QTY
            , PLAN_IN_QTY
            , ITEM_UOM
            , FIX_TYPE
            , PRODUCTION_TYPE
            , TOTAL_WORKING_TIME
            , LINE_ITEM_SEQ
            , OPERATION_ITEM_SEQ
            , LANE_QTY
            , LANE_TACT_QTY
            , BATCH_ORDER_ID
            , BIN_ORDER_ID
            , MFG_WEEK
            , INSERT_ID
            , INSERT_DTTM            
            )          
      SELECT 
             A.MASTER_ID
           , A.PLAN_ID
           , B.COMPANY_ID
           , B.DIVISION_ID
           , B.SITE_ID
           , B.PLANT_ID
           , A.SITE_ID FACTORY_ID
           , A.NEW_WORK_ORDER_ID AS WORK_ORDER_SPL_ID
           , A.NEW_WORK_ORDER_ID
           , SUBSTRING(A.DEMAND_ID, 1, CHARINDEX('::STOCK', A.DEMAND_ID)-1) AS SCP_TARGET_ID
           , A.DEMAND_ID
           , A.ITEM_ID
           , A.ITEM_ID AS TOP_ITEM_ID
           , A.OPERATION_ID     AS OPERATION_ID
           , A.ROUTE_ID         AS LINE_ID
           , A.ELECTRODE_TYPE
           , A.RESOURCE_ID      AS EQUIPMENT_ID
           , A.PLAN_DATE
           , A.START_TIME
           , A.END_TIME
           , A.REMAIN_PLAN_QTY
           , A.REMAIN_PLAN_IN_QTY
           , '' ITEM_UOM
           , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
           , CASE WHEN CHARINDEX('MASS', A.DEMAND_ID) > 0    THEN 'MASS'
                  WHEN CHARINDEX('DEVELOP', A.DEMAND_ID) > 0 THEN 'DEVELOP'
                  ELSE 'MASS'
             END  AS PRODUCTION_TYPE
           , 0 TOTAL_WORKING_TIME
           , 1 LINE_ITEM_SEQ
           , 1 OPERATION_ITEM_SEQ
           , A.LANE_QTY
           , 0 LANE_TACT_QTY
           , '' BATCH_ORDER_ID
           , '' BIN_ORDER_ID
           , C.WEEK AS MFG_WEEK
           , @v_proc_name   AS INSERT_ID
           , GETDATE()      AS INSERT_DATE
      FROM   TH_BUF_SCM_RESCHEDULE_APG_RESULT A,
             SCM_FACTORY_M B WITH(NOLOCK),
             SCM_SYS_CALENDAR_M C
      WHERE  A.MASTER_ID      = @v_master_id
      AND    A.PLAN_ID        = @v_plan_id
      AND    A.PLAN_GROUP_ID  = @v_plan_group_id
      AND    A.DEMAND_ID      LIKE '%STOCK%'        -- ## STOCK DEMAND
      --AND    A.OPERATION_ID IN ('E2500', 'S4000')
      AND    A.SITE_ID        = B.FACTORY_ID
      AND    A.PLAN_DATE      = C.DATE_ID
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.SITE_ID
                      AND    X.LINE_ID      = A.ROUTE_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )

      SET @n_row_count = @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      UPDATE FP_DAILY_PRODUCTION_PLAN_R
      SET    FP_DAILY_PRODUCTION_PLAN_R.PLAN_QTY        = B.AFTER_QTY
           , FP_DAILY_PRODUCTION_PLAN_R.PLAN_IN_QTY     = B.AFTER_IN_QTY
           , FP_DAILY_PRODUCTION_PLAN_R.PRODUCTION_TYPE = B.DEMAND_TYPE
      FROM   FP_DAILY_PRODUCTION_PLAN_R A,
             FP_AMEND_PRODUCTION_PLAN_R B
      WHERE  A.INSTANCE_ID        = @v_master_id
      AND    A.FP_PLAN_ID         = @v_plan_id
      AND    A.INSTANCE_ID        = B.MASTER_ID
      AND    A.FP_PLAN_ID         = B.PLAN_ID
      AND    A.WORK_ORDER_SPL_ID  = B.WORK_ORDER_ID
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X WITH(NOLOCK)
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.FACTORY_ID
                      AND    X.LINE_ID      = A.LINE_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )

      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      ---------------------------------------------------------------------------------------
      -- FP_PRODUCTION_PLAN_R 
      ---------------------------------------------------------------------------------------

      SET @v_table_name = 'FP_PRODUCTION_PLAN_R'

      -- FP_PRODUCTION_PLAN_R
      DELETE FROM A
      FROM   FP_PRODUCTION_PLAN_R A
      WHERE  INSTANCE_ID = @v_master_id
      AND    FP_PLAN_ID = @v_plan_id +'_BACK'
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X WITH(NOLOCK)
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.FACTORY_ID
                      AND    X.LINE_ID      = A.LINE_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )

      UPDATE FP_PRODUCTION_PLAN_R
      SET    FP_PRODUCTION_PLAN_R.FP_PLAN_ID = @v_plan_id +'_BACK'
      FROM   FP_PRODUCTION_PLAN_R A
      WHERE  A.INSTANCE_ID     = @v_master_id
      AND    A.FP_PLAN_ID      = @v_plan_id
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X WITH(NOLOCK)
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.FACTORY_ID
                      AND    X.LINE_ID      = A.LINE_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )

      SET @v_message = @@ROWCOUNT
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_R', 'DELETE', @n_log_count, null, @v_message, null 

      INSERT INTO FP_PRODUCTION_PLAN_R
            (
              INSTANCE_ID
            , FP_PLAN_ID
            , COMPANY_ID
            , DIVISION_ID
            , SITE_ID
            , PLANT_ID
            , FACTORY_ID
            --, WORK_ORDER_SPL_ID
            , WORK_ORDER_ID
            , BATCH_ORDER_ID
            , BIN_ORDER_ID
            , ORDER_TYPE
            , SCP_TARGET_ID
            , DEMAND_ID
            , ITEM_ID
            , LANE_QTY
            , TOP_ITEM_ID
            , LINE_ID
            , OPERATION_ID
            , ELECTRODE_TYPE
            , WORK_CENTER_ID
            --, EQUIPMENT_ID
            , PLAN_DATE
            , START_TIME
            , END_TIME
            , PLAN_QTY
            , PLAN_IN_QTY
            , FIX_TYPE
            , PRODUCTION_TYPE
            , MARKET
            , LANE_TACT_QTY
            , MFG_WEEK
            , INSERT_ID
            , INSERT_TIME
            )
      SELECT       
              A.MASTER_ID
            , A.PLAN_ID
            , B.COMPANY_ID
            , B.DIVISION_ID
            , B.SITE_ID
            , B.PLANT_ID
            , A.SITE_ID         AS FACTORY_ID
            , A.NEW_WORK_ORDER_ID
            , '-' BATCH_ORDER_ID
            , '-' BIN_ORDER_ID
            , '' ORDER_TYPE
            , B.SCP_TARGET_ID AS SCP_TARGET_ID
            , A.DEMAND_ID
            , A.ITEM_ID
            , A.LANE_QTY
            , B.ITEM_ID         AS TOP_ITEM_ID
            , A.ROUTE_ID        AS LINE_ID
            , A.OPERATION_ID
            , A.ELECTRODE_TYPE
            , A.WORK_CENTER_ID
            , PLAN_DATE
            , START_TIME
            , END_TIME
            , REMAIN_PLAN_QTY
            , REMAIN_PLAN_IN_QTY
            , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
            , B.PRODUCTION_TYPE
            , B.MARKET
            , 0 LANE_TACT_QTY
            , B.MFG_WEEK
            , @v_proc_name    AS INSERT_ID
            , GETDATE()       AS INSERT_TIME
      FROM    TH_BUF_SCM_RESCHEDULE_APG_RESULT A WITH(NOLOCK),
              FP_DAILY_NET_DEMAND_H B WITH(NOLOCK)
      WHERE  A.MASTER_ID      = @v_master_id
      AND    A.PLAN_ID        = @v_plan_id
      AND    A.PLAN_GROUP_ID  = @v_plan_group_id
      AND    A.MASTER_ID      = B.INSTANCE_ID
      AND    A.PLAN_ID        = B.DPP_PLAN_ID
      AND    A.DEMAND_ID      = B.FP_DEMAND_ID
      AND    A.CAPA_TYPE     != 'SETUP'
      AND    A.FIXED_YN      != 'Y'
      AND    A.REMAIN_PLAN_QTY > 0
      UNION  ALL
      SELECT       
              A.MASTER_ID
            , A.PLAN_ID
            , B.COMPANY_ID
            , B.DIVISION_ID
            , B.SITE_ID
            , B.PLANT_ID
            , A.SITE_ID         AS FACTORY_ID
            , A.WORK_ORDER_ID
            , '-' BATCH_ORDER_ID
            , '-' BIN_ORDER_ID
            , ''  ORDER_TYPE
            , B.SCP_TARGET_ID AS SCP_TARGET_ID
            , A.DEMAND_ID
            , A.ITEM_ID
            , A.LANE_QTY
            , B.ITEM_ID         AS TOP_ITEM_ID
            , A.ROUTE_ID        AS LINE_ID
            , A.OPERATION_ID
            , A.ELECTRODE_TYPE
            , A.WORK_CENTER_ID
            , MIN(PLAN_DATE) AS PLAN_DATE
            , MIN(START_TIME)     START_TIME
            , MAX(END_TIME)       END_TIME
            , SUM(REMAIN_PLAN_QTY)       PLAN_QTY 
            , SUM(REMAIN_PLAN_IN_QTY)    AS PLAN_IN_QTY
            , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
            , B.PRODUCTION_TYPE
            , B.MARKET
            , 0 LANE_TACT_QTY
            , B.MFG_WEEK
            , @v_proc_name    AS INSERT_ID
            , GETDATE()       AS INSERT_TIME
      FROM    TH_BUF_SCM_RESCHEDULE_APG_RESULT A WITH(NOLOCK),
              FP_DAILY_NET_DEMAND_H B 
      WHERE  A.MASTER_ID     = @v_master_id
      AND    A.PLAN_ID       = @v_plan_id
      AND    A.PLAN_GROUP_ID = @v_plan_group_id
      AND    A.MASTER_ID     = B.INSTANCE_ID
      AND    A.PLAN_ID       = B.DPP_PLAN_ID
      AND    A.DEMAND_ID     = B.FP_DEMAND_ID
      AND    A.CAPA_TYPE     != 'SETUP'
      AND    A.FIXED_YN       = 'Y'
      AND    A.REMAIN_PLAN_QTY > 0
      GROUP  BY
              A.MASTER_ID
            , A.PLAN_ID
            , B.COMPANY_ID
            , B.DIVISION_ID
            , B.SITE_ID
            , B.PLANT_ID
            , A.SITE_ID
            , A.WORK_ORDER_ID
            , B.SCP_TARGET_ID
            , A.DEMAND_ID
            , A.ITEM_ID
            , A.LANE_QTY
            , B.ITEM_ID
            , A.ROUTE_ID
            , A.OPERATION_ID
            , A.ELECTRODE_TYPE
            , A.WORK_CENTER_ID
            , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END
            , B.PRODUCTION_TYPE
            , B.MARKET
            , B.MFG_WEEK

      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      INSERT INTO FP_PRODUCTION_PLAN_R
            (
              INSTANCE_ID
            , FP_PLAN_ID
            , COMPANY_ID
            , DIVISION_ID
            , SITE_ID
            , PLANT_ID
            , FACTORY_ID
            --, WORK_ORDER_SPL_ID
            , WORK_ORDER_ID
            , BATCH_ORDER_ID
            , BIN_ORDER_ID
            , ORDER_TYPE
            , SCP_TARGET_ID
            , DEMAND_ID
            , ITEM_ID
            , LANE_QTY
            , TOP_ITEM_ID
            , LINE_ID
            , OPERATION_ID
            , ELECTRODE_TYPE
            , WORK_CENTER_ID
            --, EQUIPMENT_ID
            , PLAN_DATE
            , START_TIME
            , END_TIME
            , PLAN_QTY
            , PLAN_IN_QTY
            , FIX_TYPE
            , PRODUCTION_TYPE
            , MARKET
            , LANE_TACT_QTY
            , MFG_WEEK
            , INSERT_ID
            , INSERT_TIME
            )
      SELECT       
              A.MASTER_ID
            , A.PLAN_ID
            , B.COMPANY_ID
            , B.DIVISION_ID
            , B.SITE_ID
            , B.PLANT_ID
            , A.SITE_ID         AS FACTORY_ID
            , A.NEW_WORK_ORDER_ID
            , '-' BATCH_ORDER_ID
            , '-' BIN_ORDER_ID
            , '' ORDER_TYPE
            , SUBSTRING(A.DEMAND_ID, 1, CHARINDEX('::STOCK', A.DEMAND_ID)-1) AS SCP_TARGET_ID
            , A.DEMAND_ID
            , A.ITEM_ID
            , A.LANE_QTY
            , A.ITEM_ID         AS TOP_ITEM_ID
            , A.ROUTE_ID        AS LINE_ID
            , A.OPERATION_ID
            , A.ELECTRODE_TYPE
            , A.WORK_CENTER_ID
            , PLAN_DATE
            , START_TIME
            , END_TIME
            , REMAIN_PLAN_QTY
            , REMAIN_PLAN_IN_QTY
            , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
            , CASE WHEN CHARINDEX('MASS', A.DEMAND_ID) > 0    THEN 'MASS'
                   WHEN CHARINDEX('DEVELOP', A.DEMAND_ID) > 0 THEN 'DEVELOP'
                   ELSE 'MASS'
              END  AS PRODUCTION_TYPE
            , NULL AS MARKET
            , 0 LANE_TACT_QTY
            , C.WEEK AS MFG_WEEK
            , @v_proc_name    AS INSERT_ID
            , GETDATE()       AS INSERT_TIME
      FROM   TH_BUF_SCM_RESCHEDULE_APG_RESULT A,
             SCM_FACTORY_M B WITH(NOLOCK),
             SCM_SYS_CALENDAR_M C WITH(NOLOCK)
      WHERE  A.MASTER_ID      = @v_master_id
      AND    A.PLAN_ID        = @v_plan_id
      AND    A.PLAN_GROUP_ID  = @v_plan_group_id
      AND    A.DEMAND_ID      LIKE '%STOCK%'
      AND    A.SITE_ID        = B.FACTORY_ID
      AND    A.PLAN_DATE      = C.DATE_ID

      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      UPDATE FP_PRODUCTION_PLAN_R
      SET    FP_PRODUCTION_PLAN_R.PLAN_QTY        = B.AFTER_QTY
           , FP_PRODUCTION_PLAN_R.PLAN_IN_QTY     = B.AFTER_IN_QTY
           , FP_PRODUCTION_PLAN_R.PRODUCTION_TYPE = B.DEMAND_TYPE
           , FP_PRODUCTION_PLAN_R.MARKET          = B.MARKET
      FROM   FP_PRODUCTION_PLAN_R A,
             FP_AMEND_PRODUCTION_PLAN_R B
      WHERE  A.INSTANCE_ID    = @v_master_id
      AND    A.FP_PLAN_ID     = @v_plan_id
      AND    A.INSTANCE_ID    = B.MASTER_ID
      AND    A.FP_PLAN_ID     = B.PLAN_ID
      AND    A.WORK_ORDER_ID  = B.WORK_ORDER_ID
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X WITH(NOLOCK)
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.FACTORY_ID
                      AND    X.LINE_ID      = A.LINE_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )

      SET @n_row_count = @@ROWCOUNT
      
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      ---------------------------------------------------------------------------------------
      -- FP_PRODUCTION_PLAN_EQUIPMENT_R 
      ---------------------------------------------------------------------------------------
      BEGIN
        ------------------------------
          
        SET @v_table_name = 'FP_PRODUCTION_PLAN_EQUIPMENT_R'

        -- FP_PRODUCTION_PLAN_R
        DELETE FROM A
        FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A
        WHERE  INSTANCE_ID  = @v_master_id
        AND    FP_PLAN_ID   = @v_plan_id +'_BACK'
        AND    EXISTS (
                        SELECT 1
                        FROM   SCM_LINE_M X WITH(NOLOCK)
                        WHERE  X.ACTIVE_FLAG  = 'Y'
                        AND    X.FACTORY_ID   = A.FACTORY_ID
                        AND    X.LINE_ID      = A.LINE_ID
                        AND    X.OPERATION_ID = A.OPERATION_ID
                        AND    X.MODEL_TYPE   = @v_plan_group_id
                      )
        

        UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
        SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.FP_PLAN_ID = @v_plan_id +'_BACK'
        FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A
        WHERE  A.INSTANCE_ID     = @v_master_id
        AND    A.FP_PLAN_ID      = @v_plan_id
        AND    EXISTS (
                        SELECT 1
                        FROM   SCM_LINE_M X WITH(NOLOCK)
                        WHERE  X.ACTIVE_FLAG  = 'Y'
                        AND    X.FACTORY_ID   = A.FACTORY_ID
                        AND    X.LINE_ID      = A.LINE_ID
                        AND    X.OPERATION_ID = A.OPERATION_ID
                        AND    X.MODEL_TYPE   = @v_plan_group_id
                      )

        SET @v_message = @@ROWCOUNT
        SET @n_log_count += 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null 

/*
---------------------------------------------------------------------------------------------------------
-- LINE 계획일 경우 설비 수 만큼 N 빵하는 로직 주석처리함.
---------------------------------------------------------------------------------------------------------
        INSERT INTO FP_PRODUCTION_PLAN_EQUIPMENT_R
                  (
                     INSTANCE_ID        
                    ,FP_PLAN_ID       
                    ,COMPANY_ID       
                    ,DIVISION_ID      
                    ,SITE_ID          
                    ,PLANT_ID         
                    ,FACTORY_ID       
                    ,WORK_ORDER_SPL_ID
                    ,WORK_ORDER_ID  
                    ,BATCH_ORDER_ID
                    ,BIN_ORDER_ID
                    ,ORDER_TYPE
                    ,SCP_TARGET_ID    
                    ,DEMAND_ID        
                    ,ITEM_ID  
                    ,LANE_QTY
                    ,TOP_ITEM_ID      
                    ,TOP_WORK_ORDER_ID
                    ,LINE_ID          
                    ,OPERATION_ID   
                    ,ELECTRODE_TYPE
                    ,WORK_CENTER_ID   
                    ,EQUIPMENT_ID     
                    ,PLAN_DATE        
                    ,START_TIME       
                    ,END_TIME         
                    ,PLAN_QTY         
                    ,PLAN_IN_QTY      
                    ,FIX_TYPE         
                    ,PRODUCTION_TYPE  
                    ,BOM_VERSION_ID   
                    ,MARKET
                    , MFG_WEEK
                    ,INSERT_ID        
                    ,INSERT_TIME   
                  )                      
           SELECT  A.MASTER_ID
                , A.PLAN_ID
                , B.COMPANY_ID
                , B.DIVISION_ID
                , B.SITE_ID
                , B.PLANT_ID
                , A.SITE_ID AS FACTORY_ID
                , A.NEW_WORK_ORDER_ID  + CASE WHEN SEQ IS NULL OR SEQ = 0 THEN ''
                                              ELSE '#' + CONVERT(nvarchar, ISNULL(SEQ,1)) 
                                         END AS WORK_ORDER_SPL_ID
                , A.NEW_WORK_ORDER_ID
                , '-' BATCH_ORDER_ID
                , '-' BIN_ORDER_ID
                , ''  ORDER_TYPE
                , B.SCP_TARGET_ID
                , A.DEMAND_ID
                , A.ITEM_ID
                , A.LANE_QTY
                , B.ITEM_ID             AS TOP_ITEM_ID
                , A.WORK_ORDER_ID       AS TOP_WORK_ORDER_ID
                , A.ROUTE_ID            AS LINE_ID
                , A.OPERATION_ID
                , ISNULL(D.ELECTRODE_TYPE, A.ELECTRODE_TYPE) ELECTRODE_TYPE
                , ISNULL(D.WORK_CENTER_ID, A.WORK_CENTER_ID) WORK_CENTER_ID
                , ISNULL(D.EQUIPMENT_ID, A.RESOURCE_ID) AS EQUIPMENT_ID
                , PLAN_DATE
                , START_TIME
                , END_TIME
                , CASE WHEN CNT IS NULL THEN REMAIN_PLAN_QTY
                       WHEN CNT = 0     THEN REMAIN_PLAN_QTY
                       WHEN A.MASTER_ID = 'KR_CELL' AND A.OPERATION_ID = 'A6000' THEN REMAIN_PLAN_QTY
                       WHEN A.MASTER_ID = 'CN_CELL' AND A.OPERATION_ID = 'A6000' THEN REMAIN_PLAN_QTY
                       WHEN A.MASTER_ID = 'US_CELL' AND A.OPERATION_ID = 'A6000' THEN REMAIN_PLAN_QTY
                       ELSE FLOOR( REMAIN_PLAN_QTY / CNT ) 
                  END  PLAN_QTY
                , CASE WHEN CNT IS NULL THEN REMAIN_PLAN_IN_QTY
                       WHEN CNT = 0     THEN REMAIN_PLAN_IN_QTY
                       WHEN A.MASTER_ID = 'KR_CELL' AND A.OPERATION_ID = 'A6000' THEN REMAIN_PLAN_IN_QTY
                       WHEN A.MASTER_ID = 'CN_CELL' AND A.OPERATION_ID = 'A6000' THEN REMAIN_PLAN_IN_QTY
                       WHEN A.MASTER_ID = 'US_CELL' AND A.OPERATION_ID = 'A6000' THEN REMAIN_PLAN_IN_QTY
                       ELSE FLOOR( REMAIN_PLAN_IN_QTY / CNT ) 
                  END  PLAN_IN_QTY
                , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
                , B.PRODUCTION_TYPE
                , NULL AS BOM_VERSION_ID
                , B.MARKET
                , B.MFG_WEEK
                , @v_proc_name    AS INSERT_ID
                , GETDATE()       AS INSERT_TIME
          FROM    TH_BUF_SCM_RESCHEDULE_APG_RESULT A WITH(NOLOCK)
                   LEFT OUTER JOIN (
                                    SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, WORK_CENTER_ID,
                                           LINE_ID +'_'+OPERATION_ID
                                                     +CASE CHECK_TYPE 
                                                          WHEN NULL   THEN '' 
                                                          WHEN ''     THEN '' 
                                                          WHEN '-'    THEN '' 
                                                          ELSE '_'+CHECK_TYPE 
                                                      END  AS RESOURCE_ID,
                                           EQUIPMENT_ID, COUNT(1) OVER (PARTITION BY LINE_ID, OPERATION_ID, CHECK_TYPE) AS CNT,
                                           DENSE_RANK() OVER (PARTITION BY LINE_ID, OPERATION_ID, CHECK_TYPE ORDER BY EQUIPMENT_ID) - 1 AS SEQ
                                    FROM   (
                                            SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, WORK_CENTER_ID,
                                                   CASE WHEN @v_master_id = 'KR_CELL' AND OPERATION_ID   = 'A6000' THEN ''
                                                        WHEN @v_master_id = 'CN_CELL' AND OPERATION_ID   = 'A6000' THEN ''
                                                        WHEN @v_master_id = 'US_CELL' AND OPERATION_ID   = 'A6000' THEN ''
                                                        ELSE ISNULL(ELECTRODE_TYPE,'-')
                                                   END  AS CHECK_TYPE, 
                                                   EQUIPMENT_ID
                                            FROM   SCM_EQUIPMENT_M
                                            WHERE  EQUIPMENT_TYPE = 'M'
                                           ) A
                                   ) D
                        ON   A.RESOURCE_ID LIKE D.RESOURCE_ID +'%'
              , FP_DAILY_NET_DEMAND_H B WITH(NOLOCK)
          WHERE  A.MASTER_ID     = @v_master_id
          AND    A.PLAN_ID       = @v_plan_id
          AND    A.PLAN_GROUP_ID = @v_plan_group_id
          AND    A.MASTER_ID     = B.INSTANCE_ID
          AND    A.PLAN_ID       = B.DPP_PLAN_ID
          AND    A.DEMAND_ID     = B.FP_DEMAND_ID
          AND    A.CAPA_TYPE     != 'SETUP'
          AND    A.FIXED_YN      != 'Y'
          AND    A.REMAIN_PLAN_QTY > 0
          UNION  ALL
          SELECT  A.MASTER_ID
                , A.PLAN_ID
                , B.COMPANY_ID
                , B.DIVISION_ID
                , B.SITE_ID
                , B.PLANT_ID
                , A.SITE_ID AS FACTORY_ID
                , A.WORK_ORDER_ID  + CASE WHEN SEQ IS NULL OR SEQ = 0 THEN ''
                                          ELSE '#' + CONVERT(nvarchar, ISNULL(SEQ,1)) 
                                     END  AS WORK_ORDER_SPL_ID
                , A.WORK_ORDER_ID
                , '-' BATCH_ORDER_ID
                , '-' BIN_ORDER_ID
                , ''  ORDER_TYPE
                , B.SCP_TARGET_ID
                , A.DEMAND_ID
                , A.ITEM_ID
                , A.LANE_QTY
                , B.ITEM_ID             AS TOP_ITEM_ID
                , A.WORK_ORDER_ID       AS TOP_WORK_ORDER_ID
                , A.ROUTE_ID            AS LINE_ID
                , A.OPERATION_ID
                , ISNULL(D.ELECTRODE_TYPE, A.ELECTRODE_TYPE) ELECTRODE_TYPE
                , ISNULL(D.WORK_CENTER_ID, A.WORK_CENTER_ID) WORK_CENTER_ID
                , ISNULL(D.EQUIPMENT_ID, A.RESOURCE_ID) AS EQUIPMENT_ID
                , plan_date
                , START_TIME
                , END_TIME
                , CASE WHEN CNT IS NULL THEN PLAN_QTY
                       WHEN CNT = 0     THEN PLAN_QTY
                       WHEN A.MASTER_ID = 'KR_CELL' AND A.OPERATION_ID = 'A6000' THEN PLAN_QTY
                       WHEN A.MASTER_ID = 'CN_CELL' AND A.OPERATION_ID = 'A6000' THEN PLAN_QTY
                       WHEN A.MASTER_ID = 'US_CELL' AND A.OPERATION_ID = 'A6000' THEN PLAN_QTY
                       ELSE FLOOR( PLAN_QTY / CNT ) 
                  END  PLAN_QTY
                , CASE WHEN CNT IS NULL THEN PLAN_IN_QTY
                       WHEN CNT = 0     THEN PLAN_IN_QTY
                       WHEN A.MASTER_ID = 'KR_CELL' AND A.OPERATION_ID = 'A6000' THEN PLAN_IN_QTY
                       WHEN A.MASTER_ID = 'CN_CELL' AND A.OPERATION_ID = 'A6000' THEN PLAN_IN_QTY
                       WHEN A.MASTER_ID = 'US_CELL' AND A.OPERATION_ID = 'A6000' THEN PLAN_IN_QTY
                       ELSE FLOOR( PLAN_IN_QTY / CNT ) 
                  END  PLAN_IN_QTY
                , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
                , B.PRODUCTION_TYPE
                , NULL AS BOM_VERSION_ID
                , B.MARKET
                , B.MFG_WEEK
                , @v_proc_name    AS INSERT_ID
                , GETDATE()       AS INSERT_TIME
          FROM  (
                  SELECT  A.MASTER_ID, A.PLAN_ID, A.WORK_ORDER_ID,
                          A.ITEM_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.RESOURCE_ID, A.ELECTRODE_TYPE, A.WORK_CENTER_ID,
                          A.DEMAND_ID, A.FIXED_YN, A.LANE_QTY,
                          MIN(PLAN_DATE) AS PLAN_DATE,
                          MIN(START_TIME) AS START_TIME,
                          MAX(END_TIME)   AS END_TIME,
                          SUM(REMAIN_PLAN_QTY)   AS PLAN_QTY,
                          SUM(REMAIN_PLAN_IN_QTY) AS PLAN_IN_QTY
                  FROM    TH_BUF_SCM_RESCHEDULE_APG_RESULT A
                  WHERE   A.MASTER_ID     = @v_master_id
                  AND     A.PLAN_ID       = @v_plan_id
                  AND     A.PLAN_GROUP_ID = @v_plan_group_id
                  AND     A.CAPA_TYPE     != 'SETUP'
                  AND     A.FIXED_YN       = 'Y'
                  AND     A.REMAIN_PLAN_QTY > 0
                  GROUP  BY
                          A.MASTER_ID, A.PLAN_ID, A.WORK_ORDER_ID,
                          A.ITEM_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.RESOURCE_ID, A.ELECTRODE_TYPE, A.WORK_CENTER_ID,
                          A.DEMAND_ID, A.FIXED_YN, A.LANE_QTY
                ) A
                   LEFT OUTER JOIN (
                                    SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, WORK_CENTER_ID,
                                           LINE_ID +'_'+OPERATION_ID
                                                     +CASE CHECK_TYPE 
                                                          WHEN NULL   THEN '' 
                                                          WHEN ''     THEN '' 
                                                          WHEN '-'    THEN '' 
                                                          ELSE '_'+CHECK_TYPE 
                                                      END  AS RESOURCE_ID,
                                           EQUIPMENT_ID, COUNT(1) OVER (PARTITION BY LINE_ID, OPERATION_ID, CHECK_TYPE) AS CNT,
                                           DENSE_RANK() OVER (PARTITION BY LINE_ID, OPERATION_ID, CHECK_TYPE ORDER BY EQUIPMENT_ID) - 1 AS SEQ
                                    FROM   (
                                            SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, WORK_CENTER_ID,
                                                   CASE WHEN @v_master_id = 'KR_CELL' AND OPERATION_ID   = 'A6000' THEN ''
                                                        WHEN @v_master_id = 'CN_CELL' AND OPERATION_ID   = 'A6000' THEN ''
                                                        WHEN @v_master_id = 'US_CELL' AND OPERATION_ID   = 'A6000' THEN ''
                                                        ELSE ISNULL(ELECTRODE_TYPE,'-')
                                                   END  AS CHECK_TYPE, 
                                                   EQUIPMENT_ID
                                            FROM   SCM_EQUIPMENT_M
                                            WHERE  EQUIPMENT_TYPE = 'M'
                                           ) A
                                   ) D
                        ON   A.RESOURCE_ID LIKE D.RESOURCE_ID +'%'
              , FP_DAILY_NET_DEMAND_H B WITH(NOLOCK)
          WHERE  A.MASTER_ID     = @v_master_id
          AND    A.PLAN_ID       = @v_plan_id
          AND    A.MASTER_ID     = B.INSTANCE_ID
          AND    A.PLAN_ID       = B.DPP_PLAN_ID
          AND    A.DEMAND_ID     = B.FP_DEMAND_ID
          AND    A.PLAN_QTY > 0


          SET @n_row_count = @@ROWCOUNT
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

---------------------------------------------------------------------------------------------------------
-- LINE 계획일 경우 설비 수 만큼 N 빵하는 로직 주석처리함.
---------------------------------------------------------------------------------------------------------
*/
        
        ---------------------------------------------------------------------------------------
        -- LINE 계획이면 대표설비 1개로, 설정하여 계획 수립
        ---------------------------------------------------------------------------------------
        INSERT INTO FP_PRODUCTION_PLAN_EQUIPMENT_R
                  (
                     INSTANCE_ID        
                    ,FP_PLAN_ID       
                    ,COMPANY_ID       
                    ,DIVISION_ID      
                    ,SITE_ID          
                    ,PLANT_ID         
                    ,FACTORY_ID       
                    ,WORK_ORDER_SPL_ID
                    ,WORK_ORDER_ID  
                    ,BATCH_ORDER_ID
                    ,BIN_ORDER_ID
                    ,ORDER_TYPE
                    ,SCP_TARGET_ID    
                    ,DEMAND_ID        
                    ,ITEM_ID  
                    ,LANE_QTY
                    ,TOP_ITEM_ID      
                    ,TOP_WORK_ORDER_ID
                    ,LINE_ID          
                    ,OPERATION_ID   
                    ,ELECTRODE_TYPE
                    ,WORK_CENTER_ID   
                    ,EQUIPMENT_ID     
                    ,PLAN_DATE        
                    ,START_TIME       
                    ,END_TIME         
                    ,PLAN_QTY         
                    ,PLAN_IN_QTY      
                    ,FIX_TYPE         
                    ,PRODUCTION_TYPE  
                    ,BOM_VERSION_ID   
                    ,MARKET
                    , MFG_WEEK
                    ,INSERT_ID        
                    ,INSERT_TIME   
                  )
           SELECT  
                  A.MASTER_ID
                , A.PLAN_ID
                , B.COMPANY_ID
                , B.DIVISION_ID
                , B.SITE_ID
                , B.PLANT_ID
                , A.SITE_ID AS FACTORY_ID
                , A.NEW_WORK_ORDER_ID AS WORK_ORDER_SPL_ID
                , A.NEW_WORK_ORDER_ID
                , '-' BATCH_ORDER_ID
                , '-' BIN_ORDER_ID
                , ''  ORDER_TYPE
                , B.SCP_TARGET_ID
                , A.DEMAND_ID
                , A.ITEM_ID
                , A.LANE_QTY
                , B.ITEM_ID             AS TOP_ITEM_ID
                , A.WORK_ORDER_ID       AS TOP_WORK_ORDER_ID
                , A.ROUTE_ID            AS LINE_ID
                , A.OPERATION_ID
                , ISNULL(D.ELECTRODE_TYPE, A.ELECTRODE_TYPE) ELECTRODE_TYPE
                , ISNULL(D.WORK_CENTER_ID, A.WORK_CENTER_ID) WORK_CENTER_ID
                , ISNULL(D.EQUIPMENT_ID, A.RESOURCE_ID) AS EQUIPMENT_ID
                , PLAN_DATE
                , START_TIME
                , END_TIME
                , REMAIN_PLAN_QTY     AS PLAN_QTY
                , REMAIN_PLAN_IN_QTY  AS PLAN_IN_QTY
                , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
                , B.PRODUCTION_TYPE
                , NULL AS BOM_VERSION_ID
                , B.MARKET
                , B.MFG_WEEK
                , @v_proc_name    AS INSERT_ID
                , GETDATE()       AS INSERT_TIME
          FROM    TH_BUF_SCM_RESCHEDULE_APG_RESULT A WITH(NOLOCK)
                  LEFT OUTER JOIN (
                                    SELECT A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.WORK_CENTER_ID
                                         , A.RESOURCE_ID, A.EQUIPMENT_ID
                                    FROM   (
                                            SELECT FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, WORK_CENTER_ID, EQUIPMENT_ID
                                                 , LINE_ID + '_' + OPERATION_ID
                                                                 + CASE WHEN ELECTRODE_TYPE = '-'   THEN ''
                                                                        WHEN ELECTRODE_TYPE = ''    THEN ''
                                                                        WHEN ELECTRODE_TYPE IS NULL THEN ''
                                                                        ELSE '_' + ELECTRODE_TYPE
                                                                   END
                                                   AS RESOURCE_ID
                                                 , DENSE_RANK() OVER (PARTITION BY FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE
                                                                      ORDER     BY FACTORY_ID
                                                                                 , CASE WHEN LINE_ID = 'A1A08' AND MES_LINE_ID = 'A1A08' THEN 1 ELSE 9 END
                                                                                 , EQUIPMENT_ID) AS SEQ
                                            FROM   SCM_EQUIPMENT_M
                                            WHERE  ACTIVE_FLAG = 'Y'
                                            AND    EQUIPMENT_TYPE = 'M'
                                           ) A
                                    WHERE  SEQ = 1    -- ## 대표설비만...                      
                                   ) D
                        ON   A.RESOURCE_ID = D.RESOURCE_ID
               , FP_DAILY_NET_DEMAND_H B WITH(NOLOCK)
          WHERE  A.MASTER_ID     = @v_master_id
          AND    A.PLAN_ID       = @v_plan_id
          AND    A.PLAN_GROUP_ID = @v_plan_group_id
          AND    A.MASTER_ID     = B.INSTANCE_ID
          AND    A.PLAN_ID       = B.DPP_PLAN_ID
          AND    A.DEMAND_ID     = B.FP_DEMAND_ID
          AND    A.CAPA_TYPE     != 'SETUP'
          AND    A.FIXED_YN      != 'Y'
          AND    A.REMAIN_PLAN_QTY > 0
          UNION  ALL
          SELECT  A.MASTER_ID
                , A.PLAN_ID
                , B.COMPANY_ID
                , B.DIVISION_ID
                , B.SITE_ID
                , B.PLANT_ID
                , A.SITE_ID AS FACTORY_ID
                , A.WORK_ORDER_ID AS WORK_ORDER_SPL_ID
                , A.WORK_ORDER_ID
                , '-' BATCH_ORDER_ID
                , '-' BIN_ORDER_ID
                , ''  ORDER_TYPE
                , B.SCP_TARGET_ID
                , A.DEMAND_ID
                , A.ITEM_ID
                , A.LANE_QTY
                , B.ITEM_ID             AS TOP_ITEM_ID
                , A.WORK_ORDER_ID       AS TOP_WORK_ORDER_ID
                , A.ROUTE_ID            AS LINE_ID
                , A.OPERATION_ID
                , ISNULL(D.ELECTRODE_TYPE, A.ELECTRODE_TYPE) ELECTRODE_TYPE
                , ISNULL(D.WORK_CENTER_ID, A.WORK_CENTER_ID) WORK_CENTER_ID
                , ISNULL(D.EQUIPMENT_ID, A.RESOURCE_ID) AS EQUIPMENT_ID
                , A.PLAN_DATE
                , A.START_TIME
                , A.END_TIME
                , A.PLAN_QTY
                , A.PLAN_IN_QTY
                , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
                , B.PRODUCTION_TYPE
                , NULL AS BOM_VERSION_ID
                , B.MARKET
                , B.MFG_WEEK
                , @v_proc_name    AS INSERT_ID
                , GETDATE()       AS INSERT_TIME
          FROM  (
                  SELECT  A.MASTER_ID, A.PLAN_ID, A.WORK_ORDER_ID,
                          A.ITEM_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.RESOURCE_ID, A.ELECTRODE_TYPE, A.WORK_CENTER_ID,
                          A.DEMAND_ID, A.FIXED_YN, A.LANE_QTY,
                          MIN(PLAN_DATE) AS PLAN_DATE,
                          MIN(START_TIME) AS START_TIME,
                          MAX(END_TIME)   AS END_TIME,
                          SUM(REMAIN_PLAN_QTY)   AS PLAN_QTY,
                          SUM(REMAIN_PLAN_IN_QTY) AS PLAN_IN_QTY
                  FROM    TH_BUF_SCM_RESCHEDULE_APG_RESULT A
                  WHERE   A.MASTER_ID     = @v_master_id
                  AND     A.PLAN_ID       = @v_plan_id
                  AND     A.PLAN_GROUP_ID = @v_plan_group_id
                  AND     A.CAPA_TYPE     != 'SETUP'
                  AND     A.FIXED_YN       = 'Y'
                  AND     A.REMAIN_PLAN_QTY > 0
                  GROUP  BY
                          A.MASTER_ID, A.PLAN_ID, A.WORK_ORDER_ID,
                          A.ITEM_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID, A.RESOURCE_ID, A.ELECTRODE_TYPE, A.WORK_CENTER_ID,
                          A.DEMAND_ID, A.FIXED_YN, A.LANE_QTY
                ) A
                   LEFT OUTER JOIN (
                                    SELECT A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.WORK_CENTER_ID
                                         , A.RESOURCE_ID, A.EQUIPMENT_ID
                                    FROM   (
                                            SELECT FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, WORK_CENTER_ID, EQUIPMENT_ID
                                                 , LINE_ID + '_' + OPERATION_ID
                                                                 + CASE WHEN ELECTRODE_TYPE = '-'   THEN ''
                                                                        WHEN ELECTRODE_TYPE = ''    THEN ''
                                                                        WHEN ELECTRODE_TYPE IS NULL THEN ''
                                                                        ELSE '_' + ELECTRODE_TYPE
                                                                   END
                                                   AS RESOURCE_ID
                                                 , DENSE_RANK() OVER (PARTITION BY FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE
                                                                      ORDER     BY EQUIPMENT_ID) AS SEQ
                                            FROM   SCM_EQUIPMENT_M WITH(NOLOCK)
                                            WHERE  ACTIVE_FLAG = 'Y'
                                            AND    EQUIPMENT_TYPE = 'M'
                                           ) A
                                    WHERE  SEQ = 1    -- ## 대표설비만...                      
                                   ) D
                        ON   A.RESOURCE_ID = D.RESOURCE_ID
              , FP_DAILY_NET_DEMAND_H B WITH(NOLOCK)
          WHERE  A.MASTER_ID     = @v_master_id
          AND    A.PLAN_ID       = @v_plan_id
          AND    A.MASTER_ID     = B.INSTANCE_ID
          AND    A.PLAN_ID       = B.DPP_PLAN_ID
          AND    A.DEMAND_ID     = B.FP_DEMAND_ID
          AND    A.PLAN_QTY > 0

          SET @n_row_count = @@ROWCOUNT
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
        
        INSERT INTO FP_PRODUCTION_PLAN_EQUIPMENT_R
                  (
                     INSTANCE_ID        
                    ,FP_PLAN_ID       
                    ,COMPANY_ID       
                    ,DIVISION_ID      
                    ,SITE_ID          
                    ,PLANT_ID         
                    ,FACTORY_ID       
                    ,WORK_ORDER_SPL_ID
                    ,WORK_ORDER_ID  
                    ,BATCH_ORDER_ID
                    ,BIN_ORDER_ID
                    ,ORDER_TYPE
                    ,SCP_TARGET_ID    
                    ,DEMAND_ID        
                    ,ITEM_ID  
                    ,LANE_QTY
                    ,TOP_ITEM_ID      
                    ,TOP_WORK_ORDER_ID
                    ,LINE_ID          
                    ,OPERATION_ID   
                    ,ELECTRODE_TYPE
                    ,WORK_CENTER_ID   
                    ,EQUIPMENT_ID     
                    ,PLAN_DATE        
                    ,START_TIME       
                    ,END_TIME         
                    ,PLAN_QTY         
                    ,PLAN_IN_QTY      
                    ,FIX_TYPE         
                    ,PRODUCTION_TYPE  
                    ,BOM_VERSION_ID   
                    ,MARKET
                    , MFG_WEEK
                    ,INSERT_ID        
                    ,INSERT_TIME   
                  )                      
          SELECT  A.MASTER_ID
                , A.PLAN_ID
                , B.COMPANY_ID
                , B.DIVISION_ID
                , B.SITE_ID
                , B.PLANT_ID
                , A.SITE_ID AS FACTORY_ID
                , A.WORK_ORDER_ID AS WORK_ORDER_SPL_ID
                , A.WORK_ORDER_ID
                , '-' BATCH_ORDER_ID
                , '-' BIN_ORDER_ID
                , ''  ORDER_TYPE
                , SUBSTRING(A.DEMAND_ID, 1, CHARINDEX('::STOCK', A.DEMAND_ID)-1) AS SCP_TARGET_ID
                , A.DEMAND_ID
                , A.ITEM_ID
                , A.LANE_QTY
                , A.ITEM_ID             AS TOP_ITEM_ID
                , A.WORK_ORDER_ID       AS TOP_WORK_ORDER_ID
                , A.ROUTE_ID            AS LINE_ID
                , A.OPERATION_ID
                , D.ELECTRODE_TYPE
                , D.WORK_CENTER_ID
                , A.RESOURCE_ID AS EQUIPMENT_ID
                , plan_date
                , START_TIME
                , END_TIME
                , REMAIN_PLAN_QTY    AS PLAN_QTY
                , REMAIN_PLAN_IN_QTY AS PLAN_IN_QTY
                , CASE WHEN A.FIXED_YN = 'Y' THEN 'F' ELSE 'P' END AS FIX_TYPE
                , CASE WHEN CHARINDEX('MASS', A.DEMAND_ID) > 0    THEN 'MASS'
                       WHEN CHARINDEX('DEVELOP', A.DEMAND_ID) > 0 THEN 'DEVELOP'
                       ELSE 'MASS'
                  END  AS PRODUCTION_TYPE
                , NULL AS BOM_VERSION_ID
                , NULL AS MARKET
                , C.WEEK AS MFG_WEEK
                , @v_proc_name    AS INSERT_ID
                , GETDATE()       AS INSERT_TIME
          FROM   TH_BUF_SCM_RESCHEDULE_APG_RESULT A,
                 SCM_FACTORY_M B WITH(NOLOCK),
                 SCM_SYS_CALENDAR_M C,
                 SCM_EQUIPMENT_M D WITH(NOLOCK)
          WHERE  A.MASTER_ID      = @v_master_id
          AND    A.PLAN_ID        = @v_plan_id
          AND    A.PLAN_GROUP_ID  = @v_plan_group_id
          AND    A.DEMAND_ID      LIKE '%STOCK%'
          AND    A.SITE_ID        = B.FACTORY_ID
          AND    A.PLAN_DATE      = C.DATE_ID
          AND    A.SITE_ID        = D.FACTORY_ID
          AND    A.RESOURCE_ID    = D.EQUIPMENT_ID

          SET @n_row_count = @@ROWCOUNT
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          
          UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
          SET    
               --  FP_PRODUCTION_PLAN_EQUIPMENT_R.PLAN_QTY        = B.NEW_PLAN_QTY
               --, FP_PRODUCTION_PLAN_EQUIPMENT_R.PLAN_IN_QTY     = B.NEW_PLAN_IN_QTY
                 FP_PRODUCTION_PLAN_EQUIPMENT_R.PLAN_QTY        = CASE WHEN A.INSTANCE_ID = 'KR_CELL' AND A.OPERATION_ID = 'A6000' THEN A.PLAN_QTY
                                                                       WHEN A.INSTANCE_ID = 'CN_CELL' AND A.OPERATION_ID = 'A6000' THEN A.PLAN_QTY
                                                                       WHEN A.INSTANCE_ID = 'US_CELL' AND A.OPERATION_ID = 'A6000' THEN A.PLAN_QTY
                                                                       ELSE B.NEW_PLAN_QTY
                                                                  END
               , FP_PRODUCTION_PLAN_EQUIPMENT_R.PLAN_IN_QTY     = CASE WHEN A.INSTANCE_ID = 'KR_CELL' AND A.OPERATION_ID = 'A6000' THEN A.PLAN_IN_QTY
                                                                       WHEN A.INSTANCE_ID = 'CN_CELL' AND A.OPERATION_ID = 'A6000' THEN A.PLAN_IN_QTY
                                                                       WHEN A.INSTANCE_ID = 'US_CELL' AND A.OPERATION_ID = 'A6000' THEN A.PLAN_IN_QTY
                                                                       ELSE B.NEW_PLAN_IN_QTY
                                                                  END
               , FP_PRODUCTION_PLAN_EQUIPMENT_R.PRODUCTION_TYPE = B.DEMAND_TYPE
               , FP_PRODUCTION_PLAN_EQUIPMENT_R.MARKET          = B.MARKET
          FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A,
                 (
                  SELECT A.*
                       , CASE WHEN SEQ = CNT THEN PLAN_QTY + ORG_PLAN_QTY - SUM_PLAN_QTY
                              ELSE PLAN_QTY
                         END  NEW_PLAN_QTY
                       , CASE WHEN SEQ = CNT THEN PLAN_IN_QTY + ORG_PLAN_IN_QTY - SUM_PLAN_IN_QTY
                              ELSE PLAN_IN_QTY
                         END  NEW_PLAN_IN_QTY
                  FROM   (
                          SELECT A.*,
                                 B.AFTER_QTY ORG_PLAN_QTY, B.AFTER_IN_QTY ORG_PLAN_IN_QTY,
                                 B.DEMAND_TYPE, B.MARKET
                          FROM   (
                                  SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.FACTORY_ID
                                       , A.WORK_ORDER_SPL_ID
                                       , A.WORK_ORDER_ID
                                       , PLAN_QTY AS PLAN_QTY
                                       , PLAN_IN_QTY AS PLAN_IN_QTY
                                       , SUM(PLAN_QTY)     OVER (PARTITION BY WORK_ORDER_ID) SUM_PLAN_QTY
                                       , SUM(PLAN_IN_QTY)  OVER (PARTITION BY WORK_ORDER_ID) SUM_PLAN_IN_QTY
                                       , DENSE_RANK() OVER (PARTITION BY WORK_ORDER_ID ORDER BY WORK_ORDER_SPL_ID) SEQ
                                       , COUNT(1) OVER (PARTITION BY WORK_ORDER_ID) CNT
                                  FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A
                                  WHERE  A.INSTANCE_ID    = @v_master_id
                                  AND    A.FP_PLAN_ID     = @v_plan_id
                                  AND    EXISTS (
                                                  SELECT 1
                                                  FROM   SCM_LINE_M X WITH(NOLOCK)
                                                  WHERE  X.ACTIVE_FLAG  = 'Y'
                                                  AND    X.FACTORY_ID   = A.FACTORY_ID
                                                  AND    X.LINE_ID      = A.LINE_ID
                                                  AND    X.OPERATION_ID = A.OPERATION_ID
                                                  AND    X.MODEL_TYPE   = @v_plan_group_id
                                                )
                                 ) A,
                                 FP_AMEND_PRODUCTION_PLAN_R B
                          WHERE  A.INSTANCE_ID    = B.MASTER_ID
                          AND    A.FP_PLAN_ID     = B.PLAN_ID
                          AND    A.FACTORY_ID     = B.AFTER_SITE_ID
                          AND    A.WORK_ORDER_ID  = B.WORK_ORDER_ID
                         ) A
                 ) B
          WHERE  A.INSTANCE_ID        = @v_master_id
          AND    A.FP_PLAN_ID         = @v_plan_id
          AND    A.INSTANCE_ID        = B.INSTANCE_ID
          AND    A.FP_PLAN_ID         = B.FP_PLAN_ID
          AND    A.FACTORY_ID         = B.FACTORY_ID
          AND    A.WORK_ORDER_SPL_ID  = B.WORK_ORDER_SPL_ID

          SET @n_row_count = @@ROWCOUNT
          
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END
      


      UPDATE FP_PRODUCTION_PLAN_R
      SET    FP_PRODUCTION_PLAN_R.ORDER_TYPE = CASE WHEN B.WO_FLAG = 'Y' THEN 'W' ELSE 'M' END
      FROM   FP_PRODUCTION_PLAN_R A,
             SCM_OPERATION_M B
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FP_PLAN_ID   = @v_plan_id
      AND    A.COMPANY_ID   = B.COMPANY_ID
      AND    A.DIVISION_ID  = B.DIVISION_ID
      AND    A.SITE_ID      = B.SITE_ID
      AND    A.OPERATION_ID = B.OPERATION_ID
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X WITH(NOLOCK)
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.FACTORY_ID
                      AND    X.LINE_ID      = A.LINE_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )

      SET @v_message = 'ORDER_TYPE - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 


      UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
      SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.ORDER_TYPE = CASE WHEN B.WO_FLAG = 'Y' THEN 'W' ELSE 'M' END
      FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A,
             SCM_OPERATION_M B
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FP_PLAN_ID   = @v_plan_id
      AND    A.COMPANY_ID   = B.COMPANY_ID
      AND    A.DIVISION_ID  = B.DIVISION_ID
      AND    A.SITE_ID      = B.SITE_ID
      AND    A.OPERATION_ID = B.OPERATION_ID
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X WITH(NOLOCK)
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.FACTORY_ID
                      AND    X.LINE_ID      = A.LINE_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )
      
      SET @v_message = 'ORDER_TYPE - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_EQUIPMENT_R', 'UPDATE', @n_log_count, null, @v_message, null 

      
      UPDATE FP_DAILY_PRODUCTION_PLAN_R
      SET    FP_DAILY_PRODUCTION_PLAN_R.ITEM_UOM = B.ITEM_UOM
      FROM   FP_DAILY_PRODUCTION_PLAN_R A,
             SCM_ITEM_M B WITH(NOLOCK)
      WHERE  A.INSTANCE_ID      = @v_master_id
      AND    A.FP_PLAN_ID       = @v_plan_id
      AND    A.ITEM_ID          = B.ITEM_ID    
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X WITH(NOLOCK)
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.FACTORY_ID
                      AND    X.LINE_ID      = A.LINE_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )

      SET @v_message = 'ITEM_UOM - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_DAILY_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 

      UPDATE FP_PRODUCTION_PLAN_R
      SET    FP_PRODUCTION_PLAN_R.ITEM_UOM = B.ITEM_UOM
      FROM   FP_PRODUCTION_PLAN_R A,
             SCM_ITEM_M B WITH(NOLOCK)
      WHERE  A.INSTANCE_ID      = @v_master_id
      AND    A.FP_PLAN_ID       = @v_plan_id
      AND    A.ITEM_ID          = B.ITEM_ID    
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.FACTORY_ID
                      AND    X.LINE_ID      = A.LINE_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )

      SET @v_message = 'ITEM_UOM - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 


      UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
      SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.ITEM_UOM = B.ITEM_UOM
      FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A,
             SCM_ITEM_M B WITH(NOLOCK)
      WHERE  A.INSTANCE_ID      = @v_master_id
      AND    A.FP_PLAN_ID       = @v_plan_id
      AND    A.ITEM_ID          = B.ITEM_ID    
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X WITH(NOLOCK)
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.FACTORY_ID
                      AND    X.LINE_ID      = A.LINE_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )
      
      SET @v_message = 'ITEM_UOM - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_EQUIPMENT_R', 'UPDATE', @n_log_count, null, @v_message, null 


      -- MERGE 했다면 BATCH 도 MERGE 되어 AMEND 에 재 채번되었으므로, AMEND 테이블의 BATCH ORDER ID 를 사용한다.
      IF ISNULL(@v_is_wo_merge,'N') = 'Y'
        BEGIN

          UPDATE FP_PRODUCTION_PLAN_R
          SET    FP_PRODUCTION_PLAN_R.BATCH_ORDER_ID = B.BATCH_ORDER_ID
          FROM   FP_PRODUCTION_PLAN_R A,
                 FP_AMEND_PRODUCTION_PLAN_R B
          WHERE  A.INSTANCE_ID        = @v_master_id
          AND    A.FP_PLAN_ID         = @v_plan_id
          AND    A.INSTANCE_ID        = B.MASTER_ID
          AND    A.FP_PLAN_ID         = B.PLAN_ID
          AND    A.FACTORY_ID         = B.AFTER_SITE_ID
          AND    A.WORK_ORDER_ID      = B.WORK_ORDER_ID
          AND    EXISTS (
                          SELECT 1
                          FROM   SCM_LINE_M X WITH(NOLOCK)
                          WHERE  X.ACTIVE_FLAG  = 'Y'
                          AND    X.FACTORY_ID   = A.FACTORY_ID
                          AND    X.LINE_ID      = A.LINE_ID
                          AND    X.OPERATION_ID = A.OPERATION_ID
                          AND    X.MODEL_TYPE   = @v_plan_group_id
                        )

          SET @v_message = 'BATCH_ORDER_ID - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 

          UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
          SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.BATCH_ORDER_ID = B.BATCH_ORDER_ID
          FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A,
                 FP_AMEND_PRODUCTION_PLAN_R B
          WHERE  A.INSTANCE_ID        = @v_master_id
          AND    A.FP_PLAN_ID         = @v_plan_id
          AND    A.INSTANCE_ID        = B.MASTER_ID
          AND    A.FP_PLAN_ID         = B.PLAN_ID
          AND    A.FACTORY_ID         = B.AFTER_SITE_ID
          AND    A.WORK_ORDER_SPL_ID  = B.WORK_ORDER_ID
          AND    EXISTS (
                          SELECT 1
                          FROM   SCM_LINE_M X WITH(NOLOCK)
                          WHERE  X.ACTIVE_FLAG  = 'Y'
                          AND    X.FACTORY_ID   = A.FACTORY_ID
                          AND    X.LINE_ID      = A.LINE_ID
                          AND    X.OPERATION_ID = A.OPERATION_ID
                          AND    X.MODEL_TYPE   = @v_plan_group_id
                        )

          SET @v_message = 'BATCH_ORDER_ID - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_EQUIPMENT_R', 'UPDATE', @n_log_count, null, @v_message, null 

          UPDATE FP_DAILY_PRODUCTION_PLAN_R
          SET    FP_DAILY_PRODUCTION_PLAN_R.BATCH_ORDER_ID = B.BATCH_ORDER_ID
          FROM   FP_DAILY_PRODUCTION_PLAN_R A,
                 FP_AMEND_PRODUCTION_PLAN_R B
          WHERE  A.INSTANCE_ID        = @v_master_id
          AND    A.FP_PLAN_ID         = @v_plan_id
          AND    A.INSTANCE_ID        = B.MASTER_ID
          AND    A.FP_PLAN_ID         = B.PLAN_ID
          AND    A.FACTORY_ID         = B.AFTER_SITE_ID
          AND    A.WORK_ORDER_SPL_ID  = B.WORK_ORDER_ID
          AND    EXISTS (
                          SELECT 1
                          FROM   SCM_LINE_M X WITH(NOLOCK)
                          WHERE  X.ACTIVE_FLAG  = 'Y'
                          AND    X.FACTORY_ID   = A.FACTORY_ID
                          AND    X.LINE_ID      = A.LINE_ID
                          AND    X.OPERATION_ID = A.OPERATION_ID
                          AND    X.MODEL_TYPE   = @v_plan_group_id
                        )

          SET @v_message = 'BATCH_ORDER_ID - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_DAILY_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 

        END
      ELSE
        BEGIN
        
          UPDATE FP_PRODUCTION_PLAN_R
          SET    FP_PRODUCTION_PLAN_R.BATCH_ORDER_ID = A.WORK_ORDER_ID
          FROM   FP_PRODUCTION_PLAN_R A,
                 SCM_OPERATION_M B WITH(NOLOCK)
          WHERE  A.INSTANCE_ID      = @v_master_id
          AND    A.FP_PLAN_ID       = @v_plan_id
          AND    A.COMPANY_ID       = B.COMPANY_ID
          AND    A.DIVISION_ID      = B.DIVISION_ID
          AND    A.SITE_ID          = B.SITE_ID
          AND    A.OPERATION_ID     = B.OPERATION_ID
          AND    B.CAPA_TYPE        = 'BATCH'
          AND    EXISTS (
                          SELECT 1
                          FROM   SCM_LINE_M X WITH(NOLOCK)
                          WHERE  X.ACTIVE_FLAG  = 'Y'
                          AND    X.FACTORY_ID   = A.FACTORY_ID
                          AND    X.LINE_ID      = A.LINE_ID
                          AND    X.OPERATION_ID = A.OPERATION_ID
                          AND    X.MODEL_TYPE   = @v_plan_group_id
                        )

          SET @v_message = 'BATCH_ORDER_ID - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 

          UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
          SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.BATCH_ORDER_ID = A.WORK_ORDER_ID
          FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A,
                 SCM_OPERATION_M B WITH(NOLOCK)
          WHERE  A.INSTANCE_ID      = @v_master_id
          AND    A.FP_PLAN_ID       = @v_plan_id
          AND    A.COMPANY_ID       = B.COMPANY_ID
          AND    A.DIVISION_ID      = B.DIVISION_ID
          AND    A.SITE_ID          = B.SITE_ID
          AND    A.OPERATION_ID     = B.OPERATION_ID
          AND    B.CAPA_TYPE        = 'BATCH'
          AND    EXISTS (
                          SELECT 1
                          FROM   SCM_LINE_M X WITH(NOLOCK)
                          WHERE  X.ACTIVE_FLAG  = 'Y'
                          AND    X.FACTORY_ID   = A.FACTORY_ID
                          AND    X.LINE_ID      = A.LINE_ID
                          AND    X.OPERATION_ID = A.OPERATION_ID
                          AND    X.MODEL_TYPE   = @v_plan_group_id
                        )

          SET @v_message = 'BATCH_ORDER_ID - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_EQUIPMENT_R', 'UPDATE', @n_log_count, null, @v_message, null 

          UPDATE FP_DAILY_PRODUCTION_PLAN_R
          SET    FP_DAILY_PRODUCTION_PLAN_R.BATCH_ORDER_ID = A.WORK_ORDER_ID
          FROM   FP_DAILY_PRODUCTION_PLAN_R A,
                 SCM_OPERATION_M B WITH(NOLOCK)
          WHERE  A.INSTANCE_ID      = @v_master_id
          AND    A.FP_PLAN_ID       = @v_plan_id
          AND    A.COMPANY_ID       = B.COMPANY_ID
          AND    A.DIVISION_ID      = B.DIVISION_ID
          AND    A.SITE_ID          = B.SITE_ID
          AND    A.OPERATION_ID     = B.OPERATION_ID
          AND    B.CAPA_TYPE        = 'BATCH'
          AND    EXISTS (
                          SELECT 1
                          FROM   SCM_LINE_M X WITH(NOLOCK)
                          WHERE  X.ACTIVE_FLAG  = 'Y'
                          AND    X.FACTORY_ID   = A.FACTORY_ID
                          AND    X.LINE_ID      = A.LINE_ID
                          AND    X.OPERATION_ID = A.OPERATION_ID
                          AND    X.MODEL_TYPE   = @v_plan_group_id
                        )
          
          SET @v_message = 'BATCH_ORDER_ID - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_DAILY_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 

        END



      -- 동 변경시 DIVISION_ID, PLANT_ID 를 해당 동에 맞게 변경
      UPDATE FP_DAILY_PRODUCTION_PLAN_R
      SET    FP_DAILY_PRODUCTION_PLAN_R.DIVISION_ID = B.DIVISION_ID
           , FP_DAILY_PRODUCTION_PLAN_R.PLANT_ID    = B.PLANT_ID
      FROM   FP_DAILY_PRODUCTION_PLAN_R A,
             SCM_FACTORY_M B WITH(NOLOCK)
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FP_PLAN_ID   = @v_plan_id
      AND    A.FACTORY_ID   = B.FACTORY_ID
      AND    A.PLANT_ID    != B.PLANT_ID
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X WITH(NOLOCK)
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.FACTORY_ID
                      AND    X.LINE_ID      = A.LINE_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )

      SET @v_message = 'DIVISION_ID,PLANT_ID - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_DAILY_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 


      UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
      SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.DIVISION_ID = B.DIVISION_ID
           , FP_PRODUCTION_PLAN_EQUIPMENT_R.PLANT_ID    = B.PLANT_ID
      FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A,
             SCM_FACTORY_M B WITH(NOLOCK)
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FP_PLAN_ID   = @v_plan_id
      AND    A.FACTORY_ID   = B.FACTORY_ID
      AND    A.PLANT_ID    != B.PLANT_ID
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X WITH(NOLOCK)
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.FACTORY_ID
                      AND    X.LINE_ID      = A.LINE_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )

      SET @v_message = 'DIVISION_ID,PLANT_ID - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_EQUIPMENT_R', 'UPDATE', @n_log_count, null, @v_message, null 


      UPDATE FP_PRODUCTION_PLAN_R
      SET    FP_PRODUCTION_PLAN_R.DIVISION_ID = B.DIVISION_ID
           , FP_PRODUCTION_PLAN_R.PLANT_ID    = B.PLANT_ID
      FROM   FP_PRODUCTION_PLAN_R A,
             SCM_FACTORY_M B WITH(NOLOCK)
      WHERE  A.INSTANCE_ID  = @v_master_id
      AND    A.FP_PLAN_ID   = @v_plan_id
      AND    A.FACTORY_ID   = B.FACTORY_ID
      AND    A.PLANT_ID    != B.PLANT_ID
      AND    EXISTS (
                      SELECT 1
                      FROM   SCM_LINE_M X WITH(NOLOCK)
                      WHERE  X.ACTIVE_FLAG  = 'Y'
                      AND    X.FACTORY_ID   = A.FACTORY_ID
                      AND    X.LINE_ID      = A.LINE_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.MODEL_TYPE   = @v_plan_group_id
                    )

      SET @v_message = 'DIVISION_ID,PLANT_ID - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 

      ------------------------------------------------------------------------------------------------------------------------------
      -- 환산자 적용부분    
      ------------------------------------------------------------------------------------------------------------------------------
      BEGIN
      
        -- JR/PANCAKE_QTY UPDATE
        BEGIN
        
          UPDATE FP_PRODUCTION_PLAN_R
          SET    FP_PRODUCTION_PLAN_R.ROLL_IN_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                             THEN A.PLAN_IN_QTY -- Pancake
                                                             WHEN UPPER(B.ITEM_UOM) != 'M'
                                                             THEN A.PLAN_IN_QTY -- Pancake
                                                                  / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                    ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END )
                                                                  / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                              WHEN 'CM' THEN 100
                                                                                              WHEN 'MM' THEN 1000
                                                                                                        ELSE 1 END)
                                                        ELSE NULL END),
                 FP_PRODUCTION_PLAN_R.ROLL_OUT_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M' 
                                                              THEN A.PLAN_QTY -- Pancake
                                                              WHEN UPPER(B.ITEM_UOM) != 'M'
                                                              THEN A.PLAN_QTY -- Pancake
                                                                  / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                    ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END)
                                                                  / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                              WHEN 'CM' THEN 100
                                                                                              WHEN 'MM' THEN 1000
                                                                                                        ELSE 1 END)
                                                         ELSE NULL END),
                 FP_PRODUCTION_PLAN_R.JR_IN_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                             THEN A.PLAN_IN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
                                                                                       WHEN A.LANE_QTY = 0      THEN 1
                                                                                       ELSE A.LANE_QTY
                                                                                  END  -- Roll
                                                             WHEN UPPER(B.ITEM_UOM) != 'M'
                                                             THEN A.PLAN_IN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
                                                                                       WHEN A.LANE_QTY = 0      THEN 1
                                                                                       ELSE A.LANE_QTY
                                                                                  END  -- Roll
                                                                  / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                    ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END )
                                                                  / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                              WHEN 'CM' THEN 100
                                                                                              WHEN 'MM' THEN 1000
                                                                                                        ELSE 1 END)
                                                        ELSE NULL END),
                 FP_PRODUCTION_PLAN_R.JR_OUT_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                             THEN A.PLAN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
                                                                                       WHEN A.LANE_QTY = 0      THEN 1
                                                                                       ELSE A.LANE_QTY
                                                                                  END  -- Roll
                                                             WHEN UPPER(B.ITEM_UOM) != 'M'
                                                             THEN A.PLAN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
                                                                                       WHEN A.LANE_QTY = 0      THEN 1
                                                                                       ELSE A.LANE_QTY
                                                                                  END  -- Roll
                                                                  / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                    ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END)
                                                                  / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                              WHEN 'CM' THEN 100
                                                                                              WHEN 'MM' THEN 1000
                                                                                                        ELSE 1 END)
                                                         ELSE NULL END)                                                       
          FROM FP_PRODUCTION_PLAN_R A,
               SCM_ITEM_M B WITH(NOLOCK),
               SCM_ITEM_CLASS_M C WITH(NOLOCK),
               SCM_ITEM_LANE_M D WITH(NOLOCK)
          WHERE 1=1
          AND   A.INSTANCE_ID = @v_master_id
          AND   A.FP_PLAN_ID = @v_plan_id
          AND   A.ITEM_ID = B.ITEM_ID
          AND   A.DIVISION_ID = B.DIVISION_ID
          AND   A.SITE_ID = B.SITE_ID
          AND   B.ITEM_CLASS = C.CLASS_ID
          AND   C.LEVEL_2_CODE = 'APC'
          AND   A.DIVISION_ID = D.DIVISION_ID
          AND   A.SITE_ID = D.SITE_ID
          AND   A.PLANT_ID = D.PLANT_ID
          AND   A.FACTORY_ID = D.FACTORY_ID
          AND   A.ITEM_ID = D.ITEM_ID
          AND    EXISTS (
                          SELECT 1
                          FROM   SCM_LINE_M X WITH(NOLOCK)
                          WHERE  X.ACTIVE_FLAG  = 'Y'
                          AND    X.FACTORY_ID   = A.FACTORY_ID
                          AND    X.LINE_ID      = A.LINE_ID
                          AND    X.OPERATION_ID = A.OPERATION_ID
                          AND    X.MODEL_TYPE   = @v_plan_group_id
                        )
          
          SET @v_message = 'ROLL_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 
          
        END   
        
        BEGIN
        
          UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
          SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.ROLL_IN_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                       THEN A.PLAN_IN_QTY -- Pancake
                                                                       WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                       THEN A.PLAN_IN_QTY -- Pancake
                                                                            / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                              ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END )
                                                                            / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                        WHEN 'CM' THEN 100
                                                                                                        WHEN 'MM' THEN 1000
                                                                                                                  ELSE 1 END)
                                                                  ELSE NULL END),
                 FP_PRODUCTION_PLAN_EQUIPMENT_R.ROLL_OUT_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                        THEN A.PLAN_QTY -- Pancake
                                                                        WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                        THEN A.PLAN_QTY -- Pancake
                                                                            / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                              ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END)
                                                                            / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                        WHEN 'CM' THEN 100
                                                                                                        WHEN 'MM' THEN 1000
                                                                                                                  ELSE 1 END)
                                                                   ELSE NULL END),
                 FP_PRODUCTION_PLAN_EQUIPMENT_R.JR_IN_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                       THEN A.PLAN_IN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
                                                                                                 WHEN A.LANE_QTY = 0      THEN 1
                                                                                                 ELSE A.LANE_QTY
                                                                                            END  -- Roll
                                                                       WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                       THEN A.PLAN_IN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
                                                                                                 WHEN A.LANE_QTY = 0      THEN 1
                                                                                                 ELSE A.LANE_QTY
                                                                                            END  -- Roll
                                                                            / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                              ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END )
                                                                            / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                        WHEN 'CM' THEN 100
                                                                                                        WHEN 'MM' THEN 1000
                                                                                                                  ELSE 1 END)
                                                                  ELSE NULL END),
                 FP_PRODUCTION_PLAN_EQUIPMENT_R.JR_OUT_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                        THEN A.PLAN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
                                                                                               WHEN A.LANE_QTY = 0      THEN 1
                                                                                               ELSE A.LANE_QTY
                                                                                          END  -- Roll
                                                                        WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                        THEN A.PLAN_QTY / CASE WHEN A.LANE_QTY IS NULL  THEN 1
                                                                                               WHEN A.LANE_QTY = 0      THEN 1
                                                                                               ELSE A.LANE_QTY
                                                                                          END  -- Roll
                                                                            / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                              ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END)
                                                                            / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                        WHEN 'CM' THEN 100
                                                                                                        WHEN 'MM' THEN 1000
                                                                                                                  ELSE 1 END)
                                                                   ELSE NULL END)                                                                                              
          FROM FP_PRODUCTION_PLAN_EQUIPMENT_R A,
               SCM_ITEM_M B WITH(NOLOCK),
               SCM_ITEM_CLASS_M C WITH(NOLOCK),
               SCM_ITEM_LANE_M D WITH(NOLOCK)
          WHERE 1=1
          AND   A.INSTANCE_ID = @v_master_id
          AND   A.FP_PLAN_ID = @v_plan_id
          AND   A.ITEM_ID = B.ITEM_ID
          AND   A.DIVISION_ID = B.DIVISION_ID
          AND   A.SITE_ID = B.SITE_ID
          AND   B.ITEM_CLASS = C.CLASS_ID
          AND   C.LEVEL_2_CODE = 'APC'
          AND   A.DIVISION_ID = D.DIVISION_ID
          AND   A.SITE_ID = D.SITE_ID
          AND   A.PLANT_ID = D.PLANT_ID
          AND   A.FACTORY_ID = D.FACTORY_ID
          AND   A.ITEM_ID = D.ITEM_ID
          AND    EXISTS (
                          SELECT 1
                          FROM   SCM_LINE_M X WITH(NOLOCK)
                          WHERE  X.ACTIVE_FLAG  = 'Y'
                          AND    X.FACTORY_ID   = A.FACTORY_ID
                          AND    X.LINE_ID      = A.LINE_ID
                          AND    X.OPERATION_ID = A.OPERATION_ID
                          AND    X.MODEL_TYPE   = @v_plan_group_id
                        )
          
          SET @v_message = 'ROLL_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_EQUIPMENT_R', 'UPDATE', @n_log_count, null, @v_message, null 
          
        END         
        
        BEGIN
        
          UPDATE FP_DAILY_PRODUCTION_PLAN_R
          SET    FP_DAILY_PRODUCTION_PLAN_R.ROLL_IN_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                   --THEN A.PLAN_IN_QTY / A.LANE_QTY -- Roll 
                                                                   THEN A.PLAN_IN_QTY -- Pancake
                                                                   WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                   --THEN A.PLAN_QTY / A.LANE_QTY -- Roll
                                                                   THEN A.PLAN_IN_QTY -- Pancake
                                                                        / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                          ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END )
                                                                        / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                    WHEN 'CM' THEN 100
                                                                                                    WHEN 'MM' THEN 1000
                                                                                                              ELSE 1 END)
                                                              ELSE NULL END),
                 FP_DAILY_PRODUCTION_PLAN_R.ROLL_OUT_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                    THEN A.PLAN_QTY -- Pancake
                                                                    WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                    THEN A.PLAN_QTY -- Pancake
                                                                        / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                          ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END)
                                                                        / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                    WHEN 'CM' THEN 100
                                                                                                    WHEN 'MM' THEN 1000
                                                                                                              ELSE 1 END)
                                                               ELSE NULL END),
                 FP_DAILY_PRODUCTION_PLAN_R.JR_IN_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                 THEN A.PLAN_IN_QTY / CASE WHEN D.LANE_QTY IS NULL  THEN 1
                                                                                           WHEN D.LANE_QTY = 0      THEN 1
                                                                                           ELSE D.LANE_QTY
                                                                                      END  -- RollD.LANE_QTY -- Roll 
                                                                 WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                 THEN A.PLAN_IN_QTY / CASE WHEN E.LANE_QTY IS NULL  THEN 1
                                                                                           WHEN E.LANE_QTY = 0      THEN 1
                                                                                           ELSE E.LANE_QTY
                                                                                      END  -- Roll
                                                                        / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                          ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END )
                                                                        / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                    WHEN 'CM' THEN 100
                                                                                                    WHEN 'MM' THEN 1000
                                                                                                              ELSE 1 END)
                                                              ELSE NULL END),
                 FP_DAILY_PRODUCTION_PLAN_R.JR_OUT_QTY = (CASE WHEN UPPER(B.ITEM_UOM) = 'M'
                                                                  THEN A.PLAN_QTY / CASE WHEN E.LANE_QTY IS NULL  THEN 1
                                                                                         WHEN E.LANE_QTY = 0      THEN 1
                                                                                         ELSE E.LANE_QTY
                                                                                      END  -- Roll
                                                                  WHEN UPPER(B.ITEM_UOM) != 'M'
                                                                  THEN A.PLAN_QTY / CASE WHEN D.LANE_QTY IS NULL  THEN 1
                                                                                         WHEN D.LANE_QTY = 0      THEN 1
                                                                                         ELSE D.LANE_QTY
                                                                                    END  -- Roll
                                                                        / ISNULL(D.PATTERN_QTY,1) * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                                                                                          ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) END)
                                                                        / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                                    WHEN 'CM' THEN 100
                                                                                                    WHEN 'MM' THEN 1000
                                                                                                              ELSE 1 END)
                                                               ELSE NULL END)
          FROM FP_DAILY_PRODUCTION_PLAN_R A,
               SCM_ITEM_M B WITH(NOLOCK),
               SCM_ITEM_CLASS_M C WITH(NOLOCK),
               SCM_ITEM_LANE_M D WITH(NOLOCK),
               FP_PRODUCTION_PLAN_R E
          WHERE 1=1
          AND   A.INSTANCE_ID = @v_master_id
          AND   A.FP_PLAN_ID = @v_plan_id
          AND   A.ITEM_ID = B.ITEM_ID
          AND   A.DIVISION_ID = B.DIVISION_ID
          AND   A.SITE_ID = B.SITE_ID
          AND   B.ITEM_CLASS = C.CLASS_ID
          AND   C.LEVEL_2_CODE = 'APC'
          AND   A.DIVISION_ID = D.DIVISION_ID
          AND   A.SITE_ID = D.SITE_ID
          AND   A.PLANT_ID = D.PLANT_ID
          AND   A.FACTORY_ID = D.FACTORY_ID
          AND   A.ITEM_ID = D.ITEM_ID
          AND   A.INSTANCE_ID = E.INSTANCE_ID
          AND   A.FP_PLAN_ID = E.FP_PLAN_ID
          AND   A.WORK_ORDER_ID = E.WORK_ORDER_ID
          AND   A.PLAN_QTY > 0
          AND    EXISTS (
                          SELECT 1
                          FROM   SCM_LINE_M X WITH(NOLOCK)
                          WHERE  X.ACTIVE_FLAG  = 'Y'
                          AND    X.FACTORY_ID   = A.FACTORY_ID
                          AND    X.LINE_ID      = A.LINE_ID
                          AND    X.OPERATION_ID = A.OPERATION_ID
                          AND    X.MODEL_TYPE   = @v_plan_group_id
                        )
          
          SET @v_message = 'ROLL_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count += 1
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_DAILY_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 
          
        END               

        -- BATCH_QTY UPDATE
        BEGIN

          BEGIN
          
            UPDATE FP_PRODUCTION_PLAN_R
            SET    FP_PRODUCTION_PLAN_R.BATCH_QTY = A.PLAN_IN_QTY / FLOOR(B.BATCH_LOT_SIZE) 
            FROM   FP_PRODUCTION_PLAN_R A,
                   SCM_ITEM_EQUIP_RATE_BATCH_M B WITH(NOLOCK)
            WHERE  1=1
            AND    A.INSTANCE_ID    = @v_master_id
            AND    A.FP_PLAN_ID     = @v_plan_id
            AND    A.COMPANY_ID     = B.COMPANY_ID
            AND    A.DIVISION_ID    = B.DIVISION_ID
            AND    A.SITE_ID        = B.SITE_ID
            AND    A.PLANT_ID       = B.PLANT_ID
            AND    A.FACTORY_ID     = B.FACTORY_ID
            AND    A.OPERATION_ID   = B.OPERATION_ID
            AND    A.ITEM_ID        = B.ITEM_ID
            AND    B.ACTIVE_FLAG    = 'Y'
            AND    FLOOR(B.BATCH_LOT_SIZE) > 0
            AND    EXISTS (
                            SELECT 1
                            FROM   SCM_LINE_M X WITH(NOLOCK)
                            WHERE  X.ACTIVE_FLAG  = 'Y'
                            AND    X.FACTORY_ID   = A.FACTORY_ID
                            AND    X.LINE_ID      = A.LINE_ID
                            AND    X.OPERATION_ID = A.OPERATION_ID
                            AND    X.MODEL_TYPE   = @v_plan_group_id
                          )
            
            SET @v_message = 'BATCH_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
            SET @n_log_count += 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 
            
          END   
          
          BEGIN
          
            UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
            SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.BATCH_QTY = A.PLAN_IN_QTY / FLOOR(B.BATCH_LOT_SIZE)
            FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A,
                   SCM_ITEM_EQUIP_RATE_BATCH_M B
            WHERE  1=1
            AND    A.INSTANCE_ID    = @v_master_id
            AND    A.FP_PLAN_ID     = @v_plan_id
            AND    A.COMPANY_ID     = B.COMPANY_ID
            AND    A.DIVISION_ID    = B.DIVISION_ID
            AND    A.SITE_ID        = B.SITE_ID
            AND    A.PLANT_ID       = B.PLANT_ID
            AND    A.FACTORY_ID     = B.FACTORY_ID
            AND    A.OPERATION_ID   = B.OPERATION_ID
            AND    A.ITEM_ID        = B.ITEM_ID
            AND    B.ACTIVE_FLAG    = 'Y'
            AND    FLOOR(B.BATCH_LOT_SIZE) > 0
            AND    EXISTS (
                            SELECT 1
                            FROM   SCM_LINE_M X WITH(NOLOCK)
                            WHERE  X.ACTIVE_FLAG  = 'Y'
                            AND    X.FACTORY_ID   = A.FACTORY_ID
                            AND    X.LINE_ID      = A.LINE_ID
                            AND    X.OPERATION_ID = A.OPERATION_ID
                            AND    X.MODEL_TYPE   = @v_plan_group_id
                          )
            
            SET @v_message = 'BATCH_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
            SET @n_log_count += 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_EQUIPMENT_R', 'UPDATE', @n_log_count, null, @v_message, null 
            
          END         
          
          BEGIN
          
            UPDATE FP_DAILY_PRODUCTION_PLAN_R
            SET    FP_DAILY_PRODUCTION_PLAN_R.BATCH_IN_QTY = A.PLAN_IN_QTY / FLOOR(B.BATCH_LOT_SIZE) 
                 , FP_DAILY_PRODUCTION_PLAN_R.BATCH_OUT_QTY = A.PLAN_QTY   / FLOOR(B.BATCH_LOT_SIZE) 
            FROM   FP_DAILY_PRODUCTION_PLAN_R A,
                   SCM_ITEM_EQUIP_RATE_BATCH_M B
            WHERE  1=1
            AND    A.INSTANCE_ID    = @v_master_id
            AND    A.FP_PLAN_ID     = @v_plan_id
            AND    A.COMPANY_ID     = B.COMPANY_ID
            AND    A.DIVISION_ID    = B.DIVISION_ID
            AND    A.SITE_ID        = B.SITE_ID
            AND    A.PLANT_ID       = B.PLANT_ID
            AND    A.FACTORY_ID     = B.FACTORY_ID
            AND    A.OPERATION_ID   = B.OPERATION_ID
            AND    A.ITEM_ID        = B.ITEM_ID
            AND    B.ACTIVE_FLAG    = 'Y'
            AND    FLOOR(B.BATCH_LOT_SIZE) > 0
            AND    EXISTS (
                            SELECT 1
                            FROM   SCM_LINE_M X
                            WHERE  X.ACTIVE_FLAG  = 'Y'
                            AND    X.FACTORY_ID   = A.FACTORY_ID
                            AND    X.LINE_ID      = A.LINE_ID
                            AND    X.OPERATION_ID = A.OPERATION_ID
                            AND    X.MODEL_TYPE   = @v_plan_group_id
                          )
            
            SET @v_message = 'BATCH_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
            SET @n_log_count += 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_DAILY_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 
            
          END            
          
          
          -- BATCH_SUM_QTY UPDATE
          BEGIN
          
            UPDATE FP_PRODUCTION_PLAN_R
            SET    FP_PRODUCTION_PLAN_R.BATCH_SUM_QTY = B.BATCH_SUM_QTY
            FROM   FP_PRODUCTION_PLAN_R A,
                   (SELECT BATCH_ORDER_ID, SUM(BATCH_QTY) AS BATCH_SUM_QTY
                    FROM   FP_PRODUCTION_PLAN_R
                    WHERE  1=1
                    AND    INSTANCE_ID     = @v_master_id
                    AND    FP_PLAN_ID      = @v_plan_id
                    AND    BATCH_ORDER_ID != '-'
                    GROUP BY BATCH_ORDER_ID) B
            WHERE  1=1
            AND    A.INSTANCE_ID    = @v_master_id
            AND    A.FP_PLAN_ID     = @v_plan_id
            AND    A.BATCH_ORDER_ID = B.BATCH_ORDER_ID
            AND    EXISTS (
                            SELECT 1
                            FROM   SCM_LINE_M X
                            WHERE  X.ACTIVE_FLAG  = 'Y'
                            AND    X.FACTORY_ID   = A.FACTORY_ID
                            AND    X.LINE_ID      = A.LINE_ID
                            AND    X.OPERATION_ID = A.OPERATION_ID
                            AND    X.MODEL_TYPE   = @v_plan_group_id
                          )
            
            SET @v_message = 'BATCH_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
            SET @n_log_count += 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 
            
          END   
          
          BEGIN
          
            UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
            SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.BATCH_SUM_QTY = B.BATCH_SUM_QTY
            FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A,
                   (SELECT BATCH_ORDER_ID, SUM(BATCH_QTY) AS BATCH_SUM_QTY
                    FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R
                    WHERE  1=1
                    AND    INSTANCE_ID     = @v_master_id
                    AND    FP_PLAN_ID      = @v_plan_id
                    AND    BATCH_ORDER_ID != '-'
                    GROUP BY BATCH_ORDER_ID) B
            WHERE  1=1
            AND    A.INSTANCE_ID    = @v_master_id
            AND    A.FP_PLAN_ID     = @v_plan_id
            AND    A.BATCH_ORDER_ID = B.BATCH_ORDER_ID
            AND    EXISTS (
                            SELECT 1
                            FROM   SCM_LINE_M X
                            WHERE  X.ACTIVE_FLAG  = 'Y'
                            AND    X.FACTORY_ID   = A.FACTORY_ID
                            AND    X.LINE_ID      = A.LINE_ID
                            AND    X.OPERATION_ID = A.OPERATION_ID
                            AND    X.MODEL_TYPE   = @v_plan_group_id
                          )
            
            SET @v_message = 'BATCH_QTY - UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
            SET @n_log_count += 1
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_EQUIPMENT_R', 'UPDATE', @n_log_count, null, @v_message, null 
            
          END         
        
        END
        
      END


      -- 2017.06.26 DEMAND_DIVISION_ID 정보 추가
      BEGIN
      
        UPDATE FP_DAILY_PRODUCTION_PLAN_R
        SET    FP_DAILY_PRODUCTION_PLAN_R.DEMAND_DIVISION_ID = A.DIVISION_ID       -- 2017.06.26 : DEMAND_DIVISION 추가 ( STOCK DEMAND )
        FROM   FP_DAILY_PRODUCTION_PLAN_R A
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_plan_id
        AND    EXISTS (
                        SELECT 1
                        FROM   SCM_LINE_M X
                        WHERE  X.ACTIVE_FLAG  = 'Y'
                        AND    X.FACTORY_ID   = A.FACTORY_ID
                        AND    X.LINE_ID      = A.LINE_ID
                        AND    X.OPERATION_ID = A.OPERATION_ID
                        AND    X.MODEL_TYPE   = @v_plan_group_id
                      )

        UPDATE FP_DAILY_PRODUCTION_PLAN_R
        SET    FP_DAILY_PRODUCTION_PLAN_R.DEMAND_DIVISION_ID = B.DIVISION_ID       -- 2017.06.26 : DEMAND_DIVISION 추가
        FROM   FP_DAILY_PRODUCTION_PLAN_R A,
               FP_DAILY_NET_DEMAND_H B
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_plan_id
        AND    A.INSTANCE_ID  = B.INSTANCE_ID
        AND    A.FP_PLAN_ID   = B.DPP_PLAN_ID 
        AND    A.DEMAND_ID    = B.FP_DEMAND_ID
        AND    EXISTS (
                        SELECT 1
                        FROM   SCM_LINE_M X
                        WHERE  X.ACTIVE_FLAG  = 'Y'
                        AND    X.FACTORY_ID   = A.FACTORY_ID
                        AND    X.LINE_ID      = A.LINE_ID
                        AND    X.OPERATION_ID = A.OPERATION_ID
                        AND    X.MODEL_TYPE   = @v_plan_group_id
                      )
        
        SET @v_message = 'DEMAND_DIVISION_ID : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count += 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_DAILY_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 
      
        UPDATE FP_PRODUCTION_PLAN_R
        SET    FP_PRODUCTION_PLAN_R.DEMAND_DIVISION_ID = A.DIVISION_ID             -- 2017.06.26 : DEMAND_DIVISION 추가 ( STOCK DEMAND )
        FROM   FP_PRODUCTION_PLAN_R A
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_plan_id
        AND    EXISTS (
                        SELECT 1
                        FROM   SCM_LINE_M X
                        WHERE  X.ACTIVE_FLAG  = 'Y'
                        AND    X.FACTORY_ID   = A.FACTORY_ID
                        AND    X.LINE_ID      = A.LINE_ID
                        AND    X.OPERATION_ID = A.OPERATION_ID
                        AND    X.MODEL_TYPE   = @v_plan_group_id
                      )

        UPDATE FP_PRODUCTION_PLAN_R
        SET    FP_PRODUCTION_PLAN_R.DEMAND_DIVISION_ID = B.DIVISION_ID             -- 2017.06.26 : DEMAND_DIVISION 추가
        FROM   FP_PRODUCTION_PLAN_R A,
               FP_DAILY_NET_DEMAND_H B
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_plan_id
        AND    A.INSTANCE_ID  = B.INSTANCE_ID
        AND    A.FP_PLAN_ID   = B.DPP_PLAN_ID 
        AND    A.DEMAND_ID    = B.FP_DEMAND_ID
        AND    EXISTS (
                        SELECT 1
                        FROM   SCM_LINE_M X
                        WHERE  X.ACTIVE_FLAG  = 'Y'
                        AND    X.FACTORY_ID   = A.FACTORY_ID
                        AND    X.LINE_ID      = A.LINE_ID
                        AND    X.OPERATION_ID = A.OPERATION_ID
                        AND    X.MODEL_TYPE   = @v_plan_group_id
                      )
        
        SET @v_message = 'DEMAND_DIVISION_ID : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count += 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_R', 'UPDATE', @n_log_count, null, @v_message, null 

        UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
        SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.DEMAND_DIVISION_ID = A.DIVISION_ID   -- 2017.06.26 : DEMAND_DIVISION 추가 ( STOCK DEMAND )
        FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_plan_id
        AND    EXISTS (
                        SELECT 1
                        FROM   SCM_LINE_M X
                        WHERE  X.ACTIVE_FLAG  = 'Y'
                        AND    X.FACTORY_ID   = A.FACTORY_ID
                        AND    X.LINE_ID      = A.LINE_ID
                        AND    X.OPERATION_ID = A.OPERATION_ID
                        AND    X.MODEL_TYPE   = @v_plan_group_id
                      )

        UPDATE FP_PRODUCTION_PLAN_EQUIPMENT_R
        SET    FP_PRODUCTION_PLAN_EQUIPMENT_R.DEMAND_DIVISION_ID = B.DIVISION_ID   -- 2017.06.26 : DEMAND_DIVISION 추가
        FROM   FP_PRODUCTION_PLAN_EQUIPMENT_R A,
               FP_DAILY_NET_DEMAND_H B
        WHERE  A.INSTANCE_ID  = @v_master_id
        AND    A.FP_PLAN_ID   = @v_plan_id
        AND    A.INSTANCE_ID  = B.INSTANCE_ID
        AND    A.FP_PLAN_ID   = B.DPP_PLAN_ID 
        AND    A.DEMAND_ID    = B.FP_DEMAND_ID
        AND    EXISTS (
                        SELECT 1
                        FROM   SCM_LINE_M X
                        WHERE  X.ACTIVE_FLAG  = 'Y'
                        AND    X.FACTORY_ID   = A.FACTORY_ID
                        AND    X.LINE_ID      = A.LINE_ID
                        AND    X.OPERATION_ID = A.OPERATION_ID
                        AND    X.MODEL_TYPE   = @v_plan_group_id
                      )
        
        SET @v_message = 'DEMAND_DIVISION_ID : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count += 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_PRODUCTION_PLAN_EQUIPMENT_R', 'UPDATE', @n_log_count, null, @v_message, null 
      
      END
      
      -- 미세조정에 의해 SPLIT 된 WORK 에 대해 ORDER PEGGING 연결
      IF CHARINDEX('KR_CELL', @v_master_id) > 0
      BEGIN
      
        INSERT INTO FP_ORDER_PEGGING_R
            (
              INSTANCE_ID
            , FP_PLAN_ID
            , COMPANY_ID
            , DIVISION_ID
            , SITE_ID
            , PLANT_ID
            , FROM_WORK_ORDER_ID
            , FROM_STOCK_SET_ID
            , TO_WORK_ORDER_ID
            , FROM_FACTORY_ID
            , TO_FACTORY_ID
            , FROM_LINE_ID
            , TO_LINE_ID
            , FROM_OPERATION_ID
            , TO_OPERATION_ID
            , FROM_QTY
            , TO_QTY
            , FROM_ITEM_ID
            , TO_ITEM_ID
            , DEMAND_ID
            , INSERT_ID
            , INSERT_TIME
            )
        SELECT DISTINCT
              A.INSTANCE_ID
            , A.FP_PLAN_ID
            , A.COMPANY_ID
            , A.DIVISION_ID
            , A.SITE_ID
            , A.PLANT_ID
            , B.WORK_ORDER_ID         AS FROM_WORK_ORDER_ID
            , A.FROM_STOCK_SET_ID
            , A.TO_WORK_ORDER_ID
            , B.AFTER_SITE_ID         AS FROM_FACTORY_ID
            , A.TO_FACTORY_ID
            , B.AFTER_ROUTE_ID        AS FROM_LINE_ID
            , A.TO_LINE_ID
            , A.FROM_OPERATION_ID
            , A.TO_OPERATION_ID
            , A.FROM_QTY
            , A.TO_QTY
            , A.FROM_ITEM_ID
            , A.TO_ITEM_ID
            , A.DEMAND_ID
            , @v_proc_name            AS INSERT_ID
            , GETDATE()               AS INSERT_TIME
        FROM  FP_ORDER_PEGGING_R A,
              (
                SELECT A.MASTER_ID, A.PLAN_ID, A.WORK_ORDER_ID, A.ORG_WORK_ORDER_ID, A.AFTER_SITE_ID, A.AFTER_ROUTE_ID, A.AFTER_QTY
                FROM   FP_AMEND_PRODUCTION_PLAN_R A
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    EXISTS (
                                SELECT 1
                                FROM   SCM_LINE_M X
                                WHERE  X.ACTIVE_FLAG  = 'Y'
                                AND    X.FACTORY_ID   = A.AFTER_SITE_ID
                                AND    X.LINE_ID      = A.AFTER_ROUTE_ID
                                AND    X.OPERATION_ID = A.AFTER_OPERATION_ID
                                AND    X.MODEL_TYPE   = @v_plan_group_id
                              )
                AND    NOT EXISTS (
                                   SELECT 1
                                   FROM   FP_ORDER_PEGGING_R X
                                   WHERE  X.INSTANCE_ID         = A.MASTER_ID
                                   AND    X.FP_PLAN_ID          = A.PLAN_ID
                                   AND    X.FROM_WORK_ORDER_ID  = A.WORK_ORDER_ID
                                  )
              ) B
        WHERE A.INSTANCE_ID         = @v_master_id
        AND   A.FP_PLAN_ID          = @v_plan_id
        AND   A.INSTANCE_ID         = B.MASTER_ID
        AND   A.FP_PLAN_ID          = B.PLAN_ID
        AND   A.FROM_WORK_ORDER_ID  = B.ORG_WORK_ORDER_ID
      
        SET @v_message = 'FROM_WORK_ORDER_ID : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count += 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_ORDER_PEGGING_R', 'INSERT', @n_log_count, null, @v_message, null 
      

        INSERT INTO FP_ORDER_PEGGING_R
            (
              INSTANCE_ID
            , FP_PLAN_ID
            , COMPANY_ID
            , DIVISION_ID
            , SITE_ID
            , PLANT_ID
            , FROM_WORK_ORDER_ID
            , FROM_STOCK_SET_ID
            , TO_WORK_ORDER_ID
            , FROM_FACTORY_ID
            , TO_FACTORY_ID
            , FROM_LINE_ID
            , TO_LINE_ID
            , FROM_OPERATION_ID
            , TO_OPERATION_ID
            , FROM_QTY
            , TO_QTY
            , FROM_ITEM_ID
            , TO_ITEM_ID
            , DEMAND_ID
            , INSERT_ID
            , INSERT_TIME
            )
        SELECT DISTINCT
              A.INSTANCE_ID
            , A.FP_PLAN_ID
            , A.COMPANY_ID
            , A.DIVISION_ID
            , A.SITE_ID
            , A.PLANT_ID
            , A.FROM_WORK_ORDER_ID
            , A.FROM_STOCK_SET_ID
            , B.WORK_ORDER_ID         AS TO_WORK_ORDER_ID
            , A.FROM_FACTORY_ID
            , B.AFTER_SITE_ID         AS TO_FACTORY_ID
            , A.FROM_LINE_ID
            , B.AFTER_ROUTE_ID        AS TO_LINE_ID
            , A.FROM_OPERATION_ID
            , A.TO_OPERATION_ID
            , A.FROM_QTY
            , A.TO_QTY
            , A.FROM_ITEM_ID
            , A.TO_ITEM_ID
            , A.DEMAND_ID
            , @v_proc_name            AS INSERT_ID
            , GETDATE()               AS INSERT_TIME
        FROM  FP_ORDER_PEGGING_R A,
              (
                SELECT A.MASTER_ID, A.PLAN_ID, A.WORK_ORDER_ID, A.ORG_WORK_ORDER_ID, A.AFTER_SITE_ID, A.AFTER_ROUTE_ID, A.AFTER_QTY
                FROM   FP_AMEND_PRODUCTION_PLAN_R A
                WHERE  A.MASTER_ID      = @v_master_id
                AND    A.PLAN_ID        = @v_plan_id
                AND    EXISTS (
                                SELECT 1
                                FROM   SCM_LINE_M X
                                WHERE  X.ACTIVE_FLAG  = 'Y'
                                AND    X.FACTORY_ID   = A.AFTER_SITE_ID
                                AND    X.LINE_ID      = A.AFTER_ROUTE_ID
                                AND    X.OPERATION_ID = A.AFTER_OPERATION_ID
                                AND    X.MODEL_TYPE   = @v_plan_group_id
                              )
                AND    NOT EXISTS (
                                   SELECT 1
                                   FROM   FP_ORDER_PEGGING_R X
                                   WHERE  X.INSTANCE_ID         = A.MASTER_ID
                                   AND    X.FP_PLAN_ID          = A.PLAN_ID
                                   AND    X.TO_WORK_ORDER_ID    = A.WORK_ORDER_ID
                                  )
              ) B
        WHERE A.INSTANCE_ID       = @v_master_id
        AND   A.FP_PLAN_ID        = @v_plan_id
        AND   A.INSTANCE_ID       = B.MASTER_ID
        AND   A.FP_PLAN_ID        = B.PLAN_ID
        AND   A.TO_WORK_ORDER_ID  = B.ORG_WORK_ORDER_ID

        SET @v_message = 'TO_WORK_ORDER_ID : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count += 1
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'FP_ORDER_PEGGING_R', 'INSERT', @n_log_count, null, @v_message, null 

      END

    END
    
    IF @@TRANCOUNT > 0
      COMMIT WORK 
    
  END TRY

  BEGIN CATCH
    --ROLLBACK
      IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'C_PLAN')
      BEGIN
          CLOSE C_PLAN
          DEALLOCATE C_PLAN
      END
      
      IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'C_BATCH')
      BEGIN
          CLOSE C_BATCH
          DEALLOCATE C_BATCH
      END

    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr
    commit;
  END CATCH

  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
