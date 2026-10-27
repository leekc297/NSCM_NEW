CREATE PROCEDURE [dbo].[PR_SCM_MF_ENG_AMEND_COPY]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MF_ENG_AMEND_COPY                                                  **/
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
  EXEC PR_SCM_MF_ENG_AMEND_COPY
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_company        nvarchar(30)   
  DECLARE @v_division        nvarchar(30)
  DECLARE @v_corporation    nvarchar(30)
  DECLARE @v_plant           nvarchar(30)
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_MF_ENG_AMEND_COPY'
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
    
    BEGIN
    
      --LOG 생성
      SET @v_log_code = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))    
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @n_row_count, null
      
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

        SET @v_table_name = 'TH_ENG - TABLE - BACKUP'

        DELETE FROM TH_ENG_PLAN_INFO                 WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'

        DELETE FROM TH_ENG_ARRANGED_WORK             WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_ARRANGED_WORK_IN          WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_ARRANGED_WORK_OUT         WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_ARRANGED_WORK_SETUP       WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_ARRANGED_WORK_TACT        WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_ATTRIBUTE_CHECKER         WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_ATTRIBUTE_CHECKER_CAL     WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_ATTRIBUTE_VALUE           WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_BATCH_INFO                WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_BATCH_INFO_CAL            WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_BOD                       WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_BOD_CAL                   WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_BOD_PATTERN               WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_BUCKET_INFO               WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_BUCKET_RES_CAPA           WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_DEMAND_ATTRIBUTE          WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_FIXED_PLAN                WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_ITEM                      WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_ITEM_BOD                  WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_ITEM_BOD_CAL              WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_ITEM_CAL                  WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_ITEM_ROUTE_SITE           WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_LOCATION_MOVE_INFO        WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_NET_DEMAND                WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_OFFTIME                   WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_OP_RES_GROUP              WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_OP_RES_GROUP_CAL          WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_OP_RES_GROUP_MAP          WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_OP_RES_GROUP_MAP_CAL      WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_PLAN_BOM                  WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_PLAN_BOM_CAL              WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_PRODUCT_MIX               WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_PRODUCT_MIX_MAP           WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_RESOURCE                  WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_RESOURCE_CAL              WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_ROUTE                     WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_SALES_MODEL               WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_SALES_PRODUCT_MAP         WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_SALES_PRODUCT_MAP_CAL     WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_SETUP_MATRIX              WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_STOCK_PLAN                WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'
        DELETE FROM TH_ENG_WIP                       WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id + '_AMEND'

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END
      
      BEGIN

        SET @v_table_name = 'TH_ENG_PLAN_INFO'
      
        INSERT INTO TH_ENG_PLAN_INFO
              (
                MASTER_ID
              , PLAN_ID
              , PLAN_TYPE
              , PLAN_START_DTTM
              , PLAN_HORIZON
              , PLAN_HORIZON_UOM
              , DEMAND_HORIZON
              , DEMAND_HORIZON_UOM
              , CONFIG_SET_ID
              , DESCR
              , PLAN_WEEK           
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , PLAN_TYPE
              , PLAN_START_DTTM
              , PLAN_HORIZON
              , PLAN_HORIZON_UOM
              , DEMAND_HORIZON
              , DEMAND_HORIZON_UOM
              , CONFIG_SET_ID
              , DESCR
              , PLAN_WEEK           
        FROM    TH_ENG_PLAN_INFO
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      
      BEGIN
      
        SET @v_table_name = 'TH_ENG_ARRANGED_WORK'
        
        INSERT INTO TH_ENG_ARRANGED_WORK
              (
                MASTER_ID
              , PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , ITEM_ID
              , ARRANGED_WORK_ID
              , DEMAND_ID
              , QTY
              , TACT_TIME
              , TACT_TIME_UOM
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , ITEM_ID
              , ARRANGED_WORK_ID
              , DEMAND_ID
              , QTY
              , TACT_TIME
              , TACT_TIME_UOM
              , DESCR
        FROM    TH_ENG_ARRANGED_WORK
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_ARRANGED_WORK_IN'
        
        INSERT INTO TH_ENG_ARRANGED_WORK_IN
              (
                MASTER_ID
              , PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , ITEM_ID
              , ARRANGED_WORK_ID
              , IN_ITEM_ID
              , IN_SITE_ID
              , IN_ROUTE_ID
              , IN_OPERATION_ID
              , RATE
              , QTY
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , ITEM_ID
              , ARRANGED_WORK_ID
              , IN_ITEM_ID
              , IN_SITE_ID
              , IN_ROUTE_ID
              , IN_OPERATION_ID
              , RATE
              , QTY
              , DESCR
        FROM    TH_ENG_ARRANGED_WORK_IN
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_ARRANGED_WORK_OUT'
        
        INSERT INTO TH_ENG_ARRANGED_WORK_OUT
              (
                MASTER_ID
              , PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , ITEM_ID
              , ARRANGED_WORK_ID
              , OUT_ITEM_ID
              , SEQ
              , RATE
              , QTY
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , ITEM_ID
              , ARRANGED_WORK_ID
              , OUT_ITEM_ID
              , SEQ
              , RATE
              , QTY
              , DESCR
        FROM    TH_ENG_ARRANGED_WORK_OUT
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END
          
      BEGIN
      
        SET @v_table_name = 'TH_ENG_ARRANGED_WORK_SETUP'
        
        INSERT INTO TH_ENG_ARRANGED_WORK_SETUP
              (
                MASTER_ID
              , PLAN_ID
              , RESOURCE_ID
              , SETUP_TYPE
              , SETUP_TYPE_NM
              , SETUP_TIME
              , SETUP_TIME_UOM
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , RESOURCE_ID
              , SETUP_TYPE
              , SETUP_TYPE_NM
              , SETUP_TIME
              , SETUP_TIME_UOM
              , DESCR
        FROM    TH_ENG_ARRANGED_WORK_SETUP
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_ARRANGED_WORK_TACT'
        
        INSERT INTO TH_ENG_ARRANGED_WORK_TACT
              (
                MASTER_ID
              , PLAN_ID
              , SITE_ID
              , OPERATION_ID
              , ROUTE_ID
              , ITEM_ID
              , RESOURCE_ID
              , B_WGT
              , ORDER_TYPE
              , PAPER_LEN_MIN
              , PAPER_LEN_MAX
              , QTY
              , UNIT
              , UOM
              , IS_VALID
              , INITBY
              , INITDTTM
              , UPBY
              , UPDTTM
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , SITE_ID
              , OPERATION_ID
              , ROUTE_ID
              , ITEM_ID
              , RESOURCE_ID
              , B_WGT
              , ORDER_TYPE
              , PAPER_LEN_MIN
              , PAPER_LEN_MAX
              , QTY
              , UNIT
              , UOM
              , IS_VALID
              , INITBY
              , INITDTTM
              , UPBY
              , UPDTTM
        FROM    TH_ENG_ARRANGED_WORK_TACT
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_ATTRIBUTE_CHECKER'
        
        INSERT INTO TH_ENG_ATTRIBUTE_CHECKER
              (
                MASTER_ID
              , PLAN_ID
              , ATTRIBUTE_CHECKER_ID
              , ATTRIBUTE_ID
              , EXPRESSION
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , ATTRIBUTE_CHECKER_ID
              , ATTRIBUTE_ID
              , EXPRESSION
              , DESCR
        FROM    TH_ENG_ATTRIBUTE_CHECKER
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_ATTRIBUTE_CHECKER_CAL'
        
        INSERT INTO TH_ENG_ATTRIBUTE_CHECKER_CAL
              (
                MASTER_ID
              , PLAN_ID
              , ATTRIBUTE_CHECKER_ID
              , ATTRIBUTE_ID
              , START_DTTM
              , END_DTTM
              , EXPRESSION
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , ATTRIBUTE_CHECKER_ID
              , ATTRIBUTE_ID
              , START_DTTM
              , END_DTTM
              , EXPRESSION
              , DESCR
        FROM    TH_ENG_ATTRIBUTE_CHECKER_CAL
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_ATTRIBUTE_VALUE'
        
        INSERT INTO TH_ENG_ATTRIBUTE_VALUE
              (
                MASTER_ID
              , PLAN_ID
              , ATTRIBUTE_SET_ID
              , ATTRIBUTE_ID
              , VALUE_TYPE
              , VALUE
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , ATTRIBUTE_SET_ID
              , ATTRIBUTE_ID
              , VALUE_TYPE
              , VALUE
              , DESCR
        FROM    TH_ENG_ATTRIBUTE_VALUE
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_BATCH_INFO'
        
        INSERT INTO TH_ENG_BATCH_INFO
              (
                MASTER_ID
              , PLAN_ID
              , BATCH_RES_GROUP_ID
              , BATCH_GROUP_ID
              , ITEM_ID
              , MAX_BATCH_QTY
              , BATCH_TIME
              , BATCH_TIME_UOM
              , PREFER_RATIO
              , WAIT_TOLERANCE_TIME
              , WAIT_TOLERANCE_TIME_UOM
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , BATCH_RES_GROUP_ID
              , BATCH_GROUP_ID
              , ITEM_ID
              , MAX_BATCH_QTY
              , BATCH_TIME
              , BATCH_TIME_UOM
              , PREFER_RATIO
              , WAIT_TOLERANCE_TIME
              , WAIT_TOLERANCE_TIME_UOM
              , DESCR
        FROM    TH_ENG_BATCH_INFO
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_BATCH_INFO_CAL'
        
        INSERT INTO TH_ENG_BATCH_INFO_CAL
              (
                MASTER_ID
              , PLAN_ID
              , BATCH_RES_GROUP_ID
              , BATCH_GROUP_ID
              , ITEM_ID
              , START_DTTM
              , END_DTTM
              , MAX_BATCH_QTY
              , BATCH_TIME
              , BATCH_TIME_UOM
              , PREFER_RATIO
              , WAIT_TOLERANCE_TIME
              , WAIT_TOLERANCE_TIME_UOM
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , BATCH_RES_GROUP_ID
              , BATCH_GROUP_ID
              , ITEM_ID
              , START_DTTM
              , END_DTTM
              , MAX_BATCH_QTY
              , BATCH_TIME
              , BATCH_TIME_UOM
              , PREFER_RATIO
              , WAIT_TOLERANCE_TIME
              , WAIT_TOLERANCE_TIME_UOM
              , DESCR
        FROM    TH_ENG_BATCH_INFO_CAL
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_BOD'
        
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
              , FROM_OFFTIME_SET_ID
              , TO_OFFTIME_SET_ID
              , FIXED_TERM
              , FIXED_TERM_UOM
              , ATTRIBUTE_SET_ID
              , ATTRIBUTE_CHECKER_ID
              , IS_PREV_EPST
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , BOD_ID
              , FROM_SITE_ID
              , TO_SITE_ID
              , TRANSPORT_MODE
              , TRANSPORT_TIME
              , TRANSPORT_TIME_UOM
              , BOD_START_DTTM
              , BOD_PATTERN_ID
              , FROM_OFFTIME_SET_ID
              , TO_OFFTIME_SET_ID
              , FIXED_TERM
              , FIXED_TERM_UOM
              , ATTRIBUTE_SET_ID
              , ATTRIBUTE_CHECKER_ID
              , IS_PREV_EPST
              , DESCR
        FROM    TH_ENG_BOD
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_BOD_CAL'
        
        INSERT INTO TH_ENG_BOD_CAL
              (
                MASTER_ID
              , PLAN_ID
              , BOD_ID
              , START_DTTM
              , END_DTTM
              , TRANSPORT_TIME
              , TRANSPORT_TIME_UOM
              , BOD_START_DTTM
              , BOD_PATTERN_ID
              , IS_USE
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , BOD_ID
              , START_DTTM
              , END_DTTM
              , TRANSPORT_TIME
              , TRANSPORT_TIME_UOM
              , BOD_START_DTTM
              , BOD_PATTERN_ID
              , IS_USE
              , DESCR
        FROM    TH_ENG_BOD_CAL
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_BOD_PATTERN'
        
        INSERT INTO TH_ENG_BOD_PATTERN
              (
                MASTER_ID
              , PLAN_ID
              , BOD_PATTERN_ID
              , CYCLE_TIME
              , CYCLE_TIME_UOM
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , BOD_PATTERN_ID
              , CYCLE_TIME
              , CYCLE_TIME_UOM
              , DESCR
        FROM    TH_ENG_BOD_PATTERN
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_BUCKET_INFO'
        
        INSERT INTO TH_ENG_BUCKET_INFO
              (
                MASTER_ID
              , PLAN_ID
              , BUCKET_SEQ
              , START_DTTM
              , END_DTTM
              , BUCKET_TYPE
              , WORK_TIME
              , WORK_TIME_UOM
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , BUCKET_SEQ
              , START_DTTM
              , END_DTTM
              , BUCKET_TYPE
              , WORK_TIME
              , WORK_TIME_UOM
              , DESCR
        FROM    TH_ENG_BUCKET_INFO
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_BUCKET_RES_CAPA'
        
        INSERT INTO TH_ENG_BUCKET_RES_CAPA
              (
                MASTER_ID
              , PLAN_ID
              , RESOURCE_ID
              , START_DTTM
              , END_DTTM
              , BUCKET_TYPE
              , WORK_TIME
              , WORK_TIME_UOM
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , RESOURCE_ID
              , START_DTTM
              , END_DTTM
              , BUCKET_TYPE
              , WORK_TIME
              , WORK_TIME_UOM
              , DESCR
        FROM    TH_ENG_BUCKET_RES_CAPA
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_DEMAND_ATTRIBUTE'
        
        INSERT INTO TH_ENG_DEMAND_ATTRIBUTE
              (
                MASTER_ID
              , PLAN_ID
              , DEMAND_GROUP_ID
              , PREFERENCE_SITE_ID
              , PREFERENCE_ROUTE_ID
              , PREFERENCE_OPERATION_ID
              , PREFERENCE_RESOURCE_ID
              , PREFERENCE_PRODUCT_ID
              , MIX_FLOW_ID
              , MIX_LOAD_ID
              , KITTING_ID
              , INPUT_START_DTTM
              , IS_HARD_PREFERENCE
              , DESCR
              , PREFERENCE_ROUTE_RESOURCE_ID
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , DEMAND_GROUP_ID
              , PREFERENCE_SITE_ID
              , PREFERENCE_ROUTE_ID
              , PREFERENCE_OPERATION_ID
              , PREFERENCE_RESOURCE_ID
              , PREFERENCE_PRODUCT_ID
              , MIX_FLOW_ID
              , MIX_LOAD_ID
              , KITTING_ID
              , INPUT_START_DTTM
              , IS_HARD_PREFERENCE
              , DESCR
              , PREFERENCE_ROUTE_RESOURCE_ID
        FROM    TH_ENG_DEMAND_ATTRIBUTE
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_FIXED_PLAN'
        
        INSERT INTO TH_ENG_FIXED_PLAN
              (
                MASTER_ID
              , PLAN_ID
              , WORK_ORDER_ID
              , WORK_ORDER_SEQ
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , ITEM_ID
              , RESOURCE_ID
              , SUB_RESOURCE_ID
              , START_DTTM
              , END_DTTM
              , OPERATION_QTY
              , COMPLETE_QTY
              , LOT_ID
              , IS_FIXED
              , IS_PREV_SCHEDULE
              , KEEP_WORK_TIME_TYPE
              , KEEP_QTY_TYPE
              , SALES_MODEL_ID
              , ATTRIBUTE_SET_ID
              , DEMAND_ID
              , DESCR
              , IS_NOH_CONSUME
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , WORK_ORDER_ID
              , WORK_ORDER_SEQ
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , ITEM_ID
              , RESOURCE_ID
              , SUB_RESOURCE_ID
              , START_DTTM
              , END_DTTM
              , OPERATION_QTY
              , COMPLETE_QTY
              , LOT_ID
              , IS_FIXED
              , IS_PREV_SCHEDULE
              , KEEP_WORK_TIME_TYPE
              , KEEP_QTY_TYPE
              , SALES_MODEL_ID
              , ATTRIBUTE_SET_ID
              , DEMAND_ID
              , DESCR
              , IS_NOH_CONSUME
        FROM    TH_ENG_FIXED_PLAN
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

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
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
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
        FROM    TH_ENG_ITEM
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
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
              , PLAN_ID
              , BOD_ID
              , ITEM_ID
              , ALT_PRIORITY
              , ALT_RATE
              , TRANSFER_LOT_SIZE
              , IS_PREV_LOT_SIZE
              , IS_PULL
              , PRE_BUFFER_TIME
              , POST_BUFFER_TIME
              , BUFFER_TIME_UOM
              , ROUTE_SELECTOR_ID
              , ATTRIBUTE_SET_ID
              , MIN_LOT_SIZE
              , MAX_LOT_SIZE
              , INCREMENT_LOT_SIZE
              , SAFETY_STOCK_TERM
              , SAFETY_STOCK_TERM_UOM
              , SAFETY_STOCK_QTY
              , DESCR
              , FROM_OFFTIME_SET_ID
              , TO_OFFTIME_SET_ID
              , EARLY_PRODUCING_TERM
              , EARLY_PRODUCING_TERM_UOM
              , PROD_PRIORITY
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , BOD_ID
              , ITEM_ID
              , ALT_PRIORITY
              , ALT_RATE
              , TRANSFER_LOT_SIZE
              , IS_PREV_LOT_SIZE
              , IS_PULL
              , PRE_BUFFER_TIME
              , POST_BUFFER_TIME
              , BUFFER_TIME_UOM
              , ROUTE_SELECTOR_ID
              , ATTRIBUTE_SET_ID
              , MIN_LOT_SIZE
              , MAX_LOT_SIZE
              , INCREMENT_LOT_SIZE
              , SAFETY_STOCK_TERM
              , SAFETY_STOCK_TERM_UOM
              , SAFETY_STOCK_QTY
              , DESCR
              , FROM_OFFTIME_SET_ID
              , TO_OFFTIME_SET_ID
              , EARLY_PRODUCING_TERM
              , EARLY_PRODUCING_TERM_UOM
              , PROD_PRIORITY
        FROM    TH_ENG_ITEM_BOD
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_ITEM_BOD_CAL'
        
        INSERT INTO TH_ENG_ITEM_BOD_CAL
              (
                MASTER_ID
              , PLAN_ID
              , ITEM_ID
              , BOD_ID
              , ALT_PRIORITY
              , ALT_RATE
              , START_DTTM
              , END_DTTM
              , TRANSFER_LOT_SIZE
              , IS_PREV_LOT_SIZE
              , IS_PULL
              , PRE_BUFFER_TIME
              , POST_BUFFER_TIME
              , BUFFER_TIME_UOM
              , IS_USE
              , ROUTE_SELECTOR_ID
              , SAFETY_STOCK_TERM
              , SAFETY_STOCK_TERM_UOM
              , SAFETY_STOCK_QTY
              , DESCR
              , EARLY_PRODUCING_TERM
              , EARLY_PRODUCING_TERM_UOM
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , ITEM_ID
              , BOD_ID
              , ALT_PRIORITY
              , ALT_RATE
              , START_DTTM
              , END_DTTM
              , TRANSFER_LOT_SIZE
              , IS_PREV_LOT_SIZE
              , IS_PULL
              , PRE_BUFFER_TIME
              , POST_BUFFER_TIME
              , BUFFER_TIME_UOM
              , IS_USE
              , ROUTE_SELECTOR_ID
              , SAFETY_STOCK_TERM
              , SAFETY_STOCK_TERM_UOM
              , SAFETY_STOCK_QTY
              , DESCR
              , EARLY_PRODUCING_TERM
              , EARLY_PRODUCING_TERM_UOM
        FROM    TH_ENG_ITEM_BOD_CAL
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
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
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , ITEM_ID
              , START_DTTM
              , END_DTTM
              , IS_USE
              , DESCR
        FROM    TH_ENG_ITEM_CAL
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_ITEM_ROUTE_SITE'
        
        INSERT INTO TH_ENG_ITEM_ROUTE_SITE
              (
                MASTER_ID
              , PLAN_ID
              , ITEM_ID
              , SITE_ID
              , ROUTE_ID
              , ROUTE_LEVEL
              , OPERATION_ID
              , OPERATION_SEQ
              , FLOW_ID
              , MIN_TAT
              , AVG_TAT
              , MAX_TAT
              , TAT_UOM
              , YIELD
              , MIN_LOT_SIZE
              , MAX_LOT_SIZE
              , INCREMENT_LOT_SIZE
              , IN_MOVING_LOT_SIZE
              , OUT_MOVING_LOT_SIZE
              , IN_MOVE_TIME
              , OUT_MOVE_TIME
              , MOVE_TIME_UOM
              , EARLY_PRODUCING_TERM
              , EARLY_PRODUCING_TERM_UOM
              , OPERATION_TYPE
              , BUFFER_TIME
              , BUFFER_TIME_UOM
              , DESCR
              , TRANSFER_BATCH_SIZE
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , ITEM_ID
              , SITE_ID
              , ROUTE_ID
              , ROUTE_LEVEL
              , OPERATION_ID
              , OPERATION_SEQ
              , FLOW_ID
              , MIN_TAT
              , AVG_TAT
              , MAX_TAT
              , TAT_UOM
              , YIELD
              , MIN_LOT_SIZE
              , MAX_LOT_SIZE
              , INCREMENT_LOT_SIZE
              , IN_MOVING_LOT_SIZE
              , OUT_MOVING_LOT_SIZE
              , IN_MOVE_TIME
              , OUT_MOVE_TIME
              , MOVE_TIME_UOM
              , EARLY_PRODUCING_TERM
              , EARLY_PRODUCING_TERM_UOM
              , OPERATION_TYPE
              , BUFFER_TIME
              , BUFFER_TIME_UOM
              , DESCR
              , TRANSFER_BATCH_SIZE
        FROM    TH_ENG_ITEM_ROUTE_SITE
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_LOCATION_MOVE_INFO'
        
        INSERT INTO TH_ENG_LOCATION_MOVE_INFO
              (
                MASTER_ID
              , PLAN_ID
              , FROM_LOCATION_ID
              , TO_LOCATION_ID
              , ALT_PRIORITY
              , MOVE_TIME
              , MOVE_TIME_UOM
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , FROM_LOCATION_ID
              , TO_LOCATION_ID
              , ALT_PRIORITY
              , MOVE_TIME
              , MOVE_TIME_UOM
              , DESCR
        FROM    TH_ENG_LOCATION_MOVE_INFO
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_NET_DEMAND'
        
        INSERT INTO TH_ENG_NET_DEMAND
              (
                MASTER_ID
              , PLAN_ID
              , DEMAND_ID
              , SALES_MODEL_ID
              , SHIPPING_DATE
              , DUE_DATE
              , DUE_FENCE_DATE
              , EARLY_PRODUCING_TERM
              , EARLY_PRODUCING_TERM_UOM
              , QTY
              , SPLIT_QTY
              , ORDER_TYPE
              , DEMAND_TYPE
              , PRODUCING_TYPE
              , PRIORITY_GROUP_CODE
              , PRIORITY
              , ATTRIBUTE_CHECKER_ID
              , DEMAND_GROUP_ID
              , LATE_TYPE
              , DESCR
              , MOVE_TIME_RATE
              , BUFFER_TIME_RATE
              , IS_EXCEPTION
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , DEMAND_ID
              , SALES_MODEL_ID
              , SHIPPING_DATE
              , DUE_DATE
              , DUE_FENCE_DATE
              , EARLY_PRODUCING_TERM
              , EARLY_PRODUCING_TERM_UOM
              , QTY
              , SPLIT_QTY
              , ORDER_TYPE
              , DEMAND_TYPE
              , PRODUCING_TYPE
              , PRIORITY_GROUP_CODE
              , PRIORITY
              , ATTRIBUTE_CHECKER_ID
              , DEMAND_GROUP_ID
              , LATE_TYPE
              , DESCR
              , MOVE_TIME_RATE
              , BUFFER_TIME_RATE
              , IS_EXCEPTION
        FROM    TH_ENG_NET_DEMAND
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_OFFTIME'
        
        INSERT INTO TH_ENG_OFFTIME
              (
                MASTER_ID
              , PLAN_ID
              , OFFTIME_SET_ID
              , OFFTIME_ID
              , START_DTTM
              , END_DTTM
              , REPEAT_TYPE
              , OFFTIME_TERM
              , OFFTIME_TERM_UOM
              , IS_WO_OVERLAP
              , IS_DO_OVERLAP
              , IS_SETUP_OVERLAP
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , OFFTIME_SET_ID
              , OFFTIME_ID
              , START_DTTM
              , END_DTTM
              , REPEAT_TYPE
              , OFFTIME_TERM
              , OFFTIME_TERM_UOM
              , IS_WO_OVERLAP
              , IS_DO_OVERLAP
              , IS_SETUP_OVERLAP
              , DESCR
        FROM    TH_ENG_OFFTIME
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_OP_RES_GROUP'
        
        INSERT INTO TH_ENG_OP_RES_GROUP
              (
                MASTER_ID
              , PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , ITEM_ID
              , RESOURCE_MAP_ID
              , RESOURCE_MAP_LEVEL
              , MIN_TACT_TIME
              , AVG_TACT_TIME
              , MAX_TACT_TIME
              , TACT_TIME_UOM
              , YIELD
              , RESOURCE_SELECTOR_ID
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , ITEM_ID
              , RESOURCE_MAP_ID
              , RESOURCE_MAP_LEVEL
              , MIN_TACT_TIME
              , AVG_TACT_TIME
              , MAX_TACT_TIME
              , TACT_TIME_UOM
              , YIELD
              , RESOURCE_SELECTOR_ID
              , DESCR
        FROM    TH_ENG_OP_RES_GROUP
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
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
              (
                MASTER_ID
              , PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , ITEM_ID
              , RESOURCE_MAP_ID
              , START_DTTM
              , END_DTTM
              , YIELD
              , RESOURCE_SELECTOR_ID
              , IS_USE
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , ITEM_ID
              , RESOURCE_MAP_ID
              , START_DTTM
              , END_DTTM
              , YIELD
              , RESOURCE_SELECTOR_ID
              , IS_USE
              , DESCR
        FROM    TH_ENG_OP_RES_GROUP_CAL
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
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
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
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
        FROM    TH_ENG_OP_RES_GROUP_MAP
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
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
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
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
        FROM    TH_ENG_OP_RES_GROUP_MAP_CAL
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
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
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
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
        FROM    TH_ENG_PLAN_BOM
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_PLAN_BOM_CAL'
        
        INSERT INTO TH_ENG_PLAN_BOM_CAL
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
              , START_DTTM
              , END_DTTM
              , BOM_VERSION_ID
              , PARENT_ITEM_RATE
              , CHILD_ITEM_RATE
              , ALT_ID
              , ALT_PRIORITY
              , ALT_RATE
              , IN_MOVE_TIME
              , OUT_MOVE_TIME
              , MOVE_TIME_UOM
              , IS_USE
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , PARENT_ITEM_ID
              , CHILD_ITEM_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , BINNING_ID
              , PRODUCTION_FLAG
              , START_DTTM
              , END_DTTM
              , BOM_VERSION_ID
              , PARENT_ITEM_RATE
              , CHILD_ITEM_RATE
              , ALT_ID
              , ALT_PRIORITY
              , ALT_RATE
              , IN_MOVE_TIME
              , OUT_MOVE_TIME
              , MOVE_TIME_UOM
              , IS_USE
              , DESCR
        FROM    TH_ENG_PLAN_BOM_CAL
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_PRODUCT_MIX'
        
        INSERT INTO TH_ENG_PRODUCT_MIX
              (
                MASTER_ID
              , PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , PRODUCT_MIX_ID
              , START_DTTM
              , END_DTTM
              , QTY
              , BUCKET
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , PRODUCT_MIX_ID
              , START_DTTM
              , END_DTTM
              , QTY
              , BUCKET
              , DESCR
        FROM    TH_ENG_PRODUCT_MIX
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_PRODUCT_MIX_MAP'
        
        INSERT INTO TH_ENG_PRODUCT_MIX_MAP
              (
                MASTER_ID
              , PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , PRODUCT_MIX_ID
              , ITEM_ID
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , PRODUCT_MIX_ID
              , ITEM_ID
              , DESCR
        FROM    TH_ENG_PRODUCT_MIX_MAP
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

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
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
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
        FROM    TH_ENG_RESOURCE
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_RESOURCE_CAL'
        
        INSERT INTO TH_ENG_RESOURCE_CAL
              (
                MASTER_ID
              , PLAN_ID
              , RESOURCE_ID
              , START_DTTM
              , END_DTTM
              , UTILIZATION
              , MULTI_PORT_COUNT
              , MAX_SETUP_COUNT
              , IS_FINITE
              , IS_USE
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , RESOURCE_ID
              , START_DTTM
              , END_DTTM
              , UTILIZATION
              , MULTI_PORT_COUNT
              , MAX_SETUP_COUNT
              , IS_FINITE
              , IS_USE
              , DESCR
        FROM    TH_ENG_RESOURCE_CAL
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_ROUTE'
        
        INSERT INTO TH_ENG_ROUTE
              (
                MASTER_ID
              , PLAN_ID
              , ROUTE_ID
              , ROUTE_LEVEL
              , MIN_TAT
              , AVG_TAT
              , MAX_TAT
              , TAT_UOM
              , IS_EARLY_PRODUCING_BUCKET
              , IS_PREV_EPST
              , IS_FORWARD_BUCKET
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , ROUTE_ID
              , ROUTE_LEVEL
              , MIN_TAT
              , AVG_TAT
              , MAX_TAT
              , TAT_UOM
              , IS_EARLY_PRODUCING_BUCKET
              , IS_PREV_EPST
              , IS_FORWARD_BUCKET
              , DESCR
        FROM    TH_ENG_ROUTE
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_SALES_MODEL'
        
        INSERT INTO TH_ENG_SALES_MODEL
              (
                MASTER_ID
              , PLAN_ID
              , SALES_MODEL_ID
              , DESCR
              , PRIORITY
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , SALES_MODEL_ID
              , DESCR
              , PRIORITY
        FROM    TH_ENG_SALES_MODEL
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_SALES_PRODUCT_MAP'
        
        INSERT INTO TH_ENG_SALES_PRODUCT_MAP
              (
                MASTER_ID
              , PLAN_ID
              , SALES_MODEL_ID
              , PRODUCT_ITEM_ID
              , SITE_ID
              , ALT_PRIORITY
              , ALT_RATE
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , SALES_MODEL_ID
              , PRODUCT_ITEM_ID
              , SITE_ID
              , ALT_PRIORITY
              , ALT_RATE
              , DESCR
        FROM    TH_ENG_SALES_PRODUCT_MAP
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
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
              (
                MASTER_ID
              , PLAN_ID
              , SALES_MODEL_ID
              , PRODUCT_ITEM_ID
              , SITE_ID
              , START_DTTM
              , END_DTTM
              , ALT_PRIORITY
              , ALT_RATE
              , IS_USE
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , SALES_MODEL_ID
              , PRODUCT_ITEM_ID
              , SITE_ID
              , START_DTTM
              , END_DTTM
              , ALT_PRIORITY
              , ALT_RATE
              , IS_USE
              , DESCR
        FROM    TH_ENG_SALES_PRODUCT_MAP_CAL
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_SETUP_MATRIX'
        
        INSERT INTO TH_ENG_SETUP_MATRIX
              (
                MASTER_ID
              , PLAN_ID
              , RESOURCE_SETUP_GROUP_ID
              , FROM_SETUP_GROUP_ID
              , TO_SETUP_GROUP_ID
              , SETUP_TIME
              , SETUP_TIME_UOM
              , FIRST_SETUP_TIME
              , FIRST_SETUP_TIME_UOM
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , RESOURCE_SETUP_GROUP_ID
              , FROM_SETUP_GROUP_ID
              , TO_SETUP_GROUP_ID
              , SETUP_TIME
              , SETUP_TIME_UOM
              , FIRST_SETUP_TIME
              , FIRST_SETUP_TIME_UOM
              , DESCR
        FROM    TH_ENG_SETUP_MATRIX
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_STOCK_PLAN'
        
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
              , WORK_ORDER_ID
              , DEMAND_ID
              , STOCK_STATUS
              , ATTRIBUTE_SET_ID
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , STOCK_SEQ
              , ITEM_ID
              , SITE_ID
              , ROUTE_ID
              , OPERATION_ID
              , RECEIVING_DTTM
              , QTY
              , LOT_ID
              , WORK_ORDER_ID
              , DEMAND_ID
              , STOCK_STATUS
              , ATTRIBUTE_SET_ID
              , DESCR
        FROM    TH_ENG_STOCK_PLAN
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_WIP'
        
        INSERT INTO TH_ENG_WIP
              (
                MASTER_ID
              , PLAN_ID
              , WIP_SEQ
              , ITEM_ID
              , ROUTE_ID
              , SITE_ID
              , OPERATION_ID
              , RESOURCE_ID
              , SUB_RESOURCE_ID
              , START_DTTM
              , END_DTTM
              , QTY
              , WORK_ORDER_ID
              , DEMAND_ID
              , LOT_ID
              , ATTRIBUTE_SET_ID
              , WIP_STATUS
              , RELEASE_DTTM
              , DESCR
              )
        SELECT
                MASTER_ID
              , PLAN_ID + '_AMEND' AS PLAN_ID
              , WIP_SEQ
              , ITEM_ID
              , ROUTE_ID
              , SITE_ID
              , OPERATION_ID
              , RESOURCE_ID
              , SUB_RESOURCE_ID
              , START_DTTM
              , END_DTTM
              , QTY
              , WORK_ORDER_ID
              , DEMAND_ID
              , LOT_ID
              , ATTRIBUTE_SET_ID
              , WIP_STATUS
              , RELEASE_DTTM
              , DESCR
        FROM    TH_ENG_WIP
        WHERE   MASTER_ID = @v_master_id
        AND     PLAN_ID = @v_plan_id
        
        
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
