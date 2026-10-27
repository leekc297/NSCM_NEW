CREATE PROCEDURE [dbo].[PR_SCM_MF_LANE_ROUTE_OUT_ADJUST]  
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-',
   @p_out_version_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MF_LANE_ROUTE_OUT_ADJUST                                           **/
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
  EXEC PR_SCM_MF_LANE_ROUTE_OUT_ADJUST
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  DECLARE
    @v_proc_name        nvarchar(150) = 'PR_SCM_MF_LANE_ROUTE_OUT_ADJUST', 
    @v_table_name       nvarchar(150) = NULL, 
    @v_master_id        nvarchar(150) = @p_master_id, 
    @v_plan_id          nvarchar(150) = @p_plan_id, 
    @v_out_version_id   nvarchar(150) = @p_out_version_id
    
  DECLARE
    @n_count            Integer  = 0,
    @n_log_count        Integer  = 0,
    @sysdate            DATETIME2 = GETDATE(),
    @v_message          nvarchar(200)
    
  DECLARE @v_seq        Integer  = 0

    
  BEGIN TRY
    --LOG 생성
    SET @n_log_count = @n_log_count + 1
    SET @sysdate = GETDATE()
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, '###############', 'START', @n_log_count, null, '############### Start of procedure ###############', null

    SELECT @n_count = count(*)
    FROM   TH_EXP_LANEORDER
    WHERE  MASTER_ID = @v_master_id
    AND    PLAN_ID = @v_plan_id
    AND    SUB_ORDER_ID IS NOT NULL
    
    IF @n_count > 0
    
      BEGIN

        SET @v_table_name = 'TH_BUF_OUT_WORK_ORDER'
        BEGIN
        
          INSERT INTO TH_BUF_OUT_WORK_ORDER 
          SELECT 
                  A.MASTER_ID
                , A.PLAN_ID
                , A.OUT_VERSION_ID
                , B.SUB_ORDER_ID AS WORK_ORDER_ID
                , A.RESOURCE_ID
                , A.ITEM_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , A.START_TIME
                , A.END_TIME
                , A.OPERATION_TIME
                , A.TOTAL_WORKING_TIME
                , A.OPERATION_QTY * (B.SUB_LANE_QTY  / B.LANE_QTY) AS OPERATION_QTY
                , A.COMPLETE_QTY  * (B.SUB_LANE_QTY  / B.LANE_QTY) AS COMPLETE_QTY
                , A.BATCH_QTY
          FROM    TH_BUF_OUT_WORK_ORDER A,
                  TH_EXP_LANEORDER B
          WHERE   A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID = @v_plan_id
          AND     A.OUT_VERSION_ID = @v_out_version_id
          AND     A.MASTER_ID = B.MASTER_ID
          AND     A.PLAN_ID = B.PLAN_ID
          AND     A.WORK_ORDER_ID = B.ORDER_ID
          AND     B.SUB_ORDER_ID IS NOT NULL

          --LOG 생성
          SET @v_message = 'SUB LANE ORDER INSERT : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          UPDATE  TH_BUF_OUT_WORK_ORDER
          SET     TH_BUF_OUT_WORK_ORDER.OPERATION_QTY = A.OPERATION_QTY * (B.MAIN_LANE_QTY  / B.LANE_QTY)
                , TH_BUF_OUT_WORK_ORDER.COMPLETE_QTY  = A.COMPLETE_QTY  * (B.MAIN_LANE_QTY  / B.LANE_QTY)
          FROM    TH_BUF_OUT_WORK_ORDER A,
                  TH_EXP_LANEORDER B
          WHERE   A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID = @v_plan_id
          AND     A.OUT_VERSION_ID = @v_out_version_id
          AND     A.MASTER_ID = B.MASTER_ID
          AND     A.PLAN_ID = B.PLAN_ID
          AND     A.WORK_ORDER_ID = B.ORDER_ID
          AND     B.SUB_ORDER_ID IS NOT NULL

          --LOG 생성
          SET @v_message = 'MAIN LANE ORDER UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END

        SET @v_table_name = 'TH_BUF_OUT_WORK_ORDER_SPL'
        BEGIN
        
          INSERT INTO TH_BUF_OUT_WORK_ORDER_SPL
          SELECT 
                  A.MASTER_ID
                , A.PLAN_ID
                , A.OUT_VERSION_ID
                , REPLACE(A.WORK_ORDER_ID, A.ORG_WORK_ORDER_ID, B.SUB_ORDER_ID)  AS WORK_ORDER_ID
                , A.RESOURCE_ID
                , A.ITEM_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , A.START_TIME
                , A.END_TIME
                , A.OPERATION_TIME
                , A.TOTAL_WORKING_TIME
                , A.OPERATION_QTY * (B.SUB_LANE_QTY  / B.LANE_QTY) AS OPERATION_QTY
                , A.COMPLETE_QTY  * (B.SUB_LANE_QTY  / B.LANE_QTY) AS COMPLETE_QTY
                , A.BATCH_QTY
                , B.SUB_ORDER_ID  AS ORG_WORK_ORDER_ID
          FROM    TH_BUF_OUT_WORK_ORDER_SPL A,
                  TH_EXP_LANEORDER B
          WHERE   A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID = @v_plan_id
          AND     A.OUT_VERSION_ID = @v_out_version_id
          AND     A.MASTER_ID = B.MASTER_ID
          AND     A.PLAN_ID = B.PLAN_ID
          AND     A.ORG_WORK_ORDER_ID = B.ORDER_ID
          AND     B.SUB_ORDER_ID IS NOT NULL

          --LOG 생성
          SET @v_message = 'SUB LANE ORDER INSERT : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          UPDATE  TH_BUF_OUT_WORK_ORDER_SPL
          SET     TH_BUF_OUT_WORK_ORDER_SPL.OPERATION_QTY = A.OPERATION_QTY * (B.MAIN_LANE_QTY  / B.LANE_QTY)
                , TH_BUF_OUT_WORK_ORDER_SPL.COMPLETE_QTY  = A.COMPLETE_QTY  * (B.MAIN_LANE_QTY  / B.LANE_QTY)
          FROM    TH_BUF_OUT_WORK_ORDER_SPL A,
                  TH_EXP_LANEORDER B
          WHERE   A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID = @v_plan_id
          AND     A.OUT_VERSION_ID = @v_out_version_id
          AND     A.MASTER_ID = B.MASTER_ID
          AND     A.PLAN_ID = B.PLAN_ID
          AND     A.ORG_WORK_ORDER_ID = B.ORDER_ID
          AND     B.SUB_ORDER_ID IS NOT NULL

          --LOG 생성
          SET @v_message = 'MAIN LANE ORDER UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
        END
        
        SET @v_table_name = 'TH_BUF_OUT_RESOURCE_USAGE'
        BEGIN
          
          SET @v_seq = 0
          
          SELECT  @v_seq = ISNULL(MAX(USAGE_SEQ), 0)
          FROM    TH_BUF_OUT_RESOURCE_USAGE A
          WHERE   A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID = @v_plan_id
          AND     A.OUT_VERSION_ID = @v_out_version_id

          INSERT INTO TH_BUF_OUT_RESOURCE_USAGE
          SELECT  A.MASTER_ID
                , A.PLAN_ID
                , A.OUT_VERSION_ID
                , @v_seq + ROW_NUMBER() OVER (ORDER BY WORK_ORDER_ID, RESOURCE_ID, START_TIME) AS USAGE_SEQ
                , A.RESOURCE_ID
                , A.START_TIME
                , A.END_TIME
                , A.CATEGORY
                , A.COMPLETE_QTY * (B.SUB_LANE_QTY  / B.LANE_QTY) AS COMPLETE_QTY
                , A.RESOURCE_GROUP_ID
                , A.ITEM_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , B.SUB_ORDER_ID AS WORK_ORDER_ID
                , A.SETUP_FLAG
          FROM    TH_BUF_OUT_RESOURCE_USAGE A,
                  TH_EXP_LANEORDER B
          WHERE   A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID = @v_plan_id
          AND     A.OUT_VERSION_ID = @v_out_version_id
          AND     A.MASTER_ID = B.MASTER_ID
          AND     A.PLAN_ID = B.PLAN_ID
          AND     A.WORK_ORDER_ID = B.ORDER_ID
          AND     B.SUB_ORDER_ID IS NOT NULL
          
          --LOG 생성
          SET @v_message = 'SUB LANE ORDER INSERT : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          UPDATE  TH_BUF_OUT_RESOURCE_USAGE
          SET     TH_BUF_OUT_RESOURCE_USAGE.COMPLETE_QTY  = A.COMPLETE_QTY  * (B.MAIN_LANE_QTY  / B.LANE_QTY)
          FROM    TH_BUF_OUT_RESOURCE_USAGE A,
                  TH_EXP_LANEORDER B
          WHERE   A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID = @v_plan_id
          AND     A.OUT_VERSION_ID = @v_out_version_id
          AND     A.MASTER_ID = B.MASTER_ID
          AND     A.PLAN_ID = B.PLAN_ID
          AND     A.WORK_ORDER_ID = B.ORDER_ID
          AND     B.SUB_ORDER_ID IS NOT NULL

          --LOG 생성
          SET @v_message = 'MAIN LANE ORDER UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
                  
        END        

        SET @v_table_name = 'TH_BUF_OUT_ORDER_TRACKING'
        BEGIN
          
          SET @v_seq = 0
          
          SELECT  @v_seq = ISNULL(MAX(TRACK_SEQ), 0)
          FROM    TH_BUF_OUT_ORDER_TRACKING A
          WHERE   A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID = @v_plan_id
          AND     A.OUT_VERSION_ID = @v_out_version_id

          INSERT  INTO TH_BUF_OUT_ORDER_TRACKING
          SELECT  A.MASTER_ID
                , A.PLAN_ID
                , A.OUT_VERSION_ID
                , A.DEMAND_ID
                , @v_seq + ROW_NUMBER() OVER (ORDER BY A.ORDER_ID, A.RESOURCE_ID, A.START_TIME, A.TRACK_SEQ) AS TRACK_SEQ
                , A.OPERATION_SEQ
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , A.RESOURCE_ID
                , A.OUT_ITEM_ID
                , A.COMPLETE_QTY  * (B.SUB_LANE_QTY  / B.LANE_QTY) AS COMPLETE_QTY
                , A.OUT_ITEM_PEGGING_ID
                , A.IN_ITEM_ID
                , A.OPERATION_QTY * (B.SUB_LANE_QTY  / B.LANE_QTY) AS OPERATION_QTY
                , A.IN_ITEM_PEGGING_ID
                , B.SUB_ORDER_ID            AS ORDER_ID
                , A.ORDER_ID_TYPE
                , A.START_TIME
                , A.END_TIME
                , A.LPST
                , A.EPST
                , A.AVAILABLE_TIME
                , A.FROM_SITE_ID
                , A.FROM_ROUTE_ID
                , A.FROM_OPERATION_ID
                , A.TO_SITE_ID
                , A.TO_ROUTE_ID
                , A.TO_OPERATION_ID
                , A.PLAN_DESCR
                , A.SUB_RESOURCE_ID
                , A.LOT_ID          
          FROM    TH_BUF_OUT_ORDER_TRACKING A,
                  TH_EXP_LANEORDER B
          WHERE   A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID = @v_plan_id
          AND     A.OUT_VERSION_ID = @v_out_version_id
          AND     A.MASTER_ID = B.MASTER_ID
          AND     A.PLAN_ID = B.PLAN_ID
          AND     A.ORDER_ID = B.ORDER_ID
          AND     B.SUB_ORDER_ID IS NOT NULL
          
          --LOG 생성
          SET @v_message = 'SUB LANE ORDER INSERT : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          UPDATE  TH_BUF_OUT_ORDER_TRACKING
          SET     TH_BUF_OUT_ORDER_TRACKING.OPERATION_QTY = A.OPERATION_QTY * (B.MAIN_LANE_QTY  / B.LANE_QTY)
                , TH_BUF_OUT_ORDER_TRACKING.COMPLETE_QTY  = A.COMPLETE_QTY  * (B.MAIN_LANE_QTY  / B.LANE_QTY)
          FROM    TH_BUF_OUT_ORDER_TRACKING A,
                  TH_EXP_LANEORDER B
          WHERE   A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID = @v_plan_id
          AND     A.OUT_VERSION_ID = @v_out_version_id
          AND     A.MASTER_ID = B.MASTER_ID
          AND     A.PLAN_ID = B.PLAN_ID
          AND     A.ORDER_ID = B.ORDER_ID
          AND     B.SUB_ORDER_ID IS NOT NULL

          --LOG 생성
          SET @v_message = 'MAIN LANE ORDER UPDATE : ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END
/*
        SET @v_table_name = 'TH_BUF_OUT_ITEM_PLAN'
        BEGIN

          INSERT  INTO TH_BUF_OUT_ITEM_PLAN
          SELECT  A.MASTER_ID
                , A.PLAN_ID
                , A.OUT_VERSION_ID
                , A.ITEM_PEGGING_ID
                , A.ITEM_ID
                , A.SITE_ID
                , B.SUB_ORDER_ID AS WORK_ORDER_ID
                , A.EVENT_TIME
                , A.EVENT_QTY  * (B.SUB_LANE_QTY  / B.LANE_QTY) AS EVENT_QTY
                , A.AVAILABLE_QTY
                , A.ATTRIBUTE_SET_ID          
          FROM    TH_BUF_OUT_ITEM_PLAN A,
                  TH_EXP_LANEORDER B
          WHERE   A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID = @v_plan_id
          AND     A.OUT_VERSION_ID = @v_out_version_id
          AND     A.MASTER_ID = B.MASTER_ID
          AND     A.PLAN_ID = B.PLAN_ID
          AND     A.WORK_ORDER_ID = B.ORDER_ID
          AND     B.SUB_ORDER_ID IS NOT NULL
          
          --LOG 생성
          SET @v_message = 'SUB LANE ORDER INSERT - ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          UPDATE  TH_BUF_OUT_ITEM_PLAN
          SET     TH_BUF_OUT_ITEM_PLAN.EVENT_QTY      = A.EVENT_QTY      * (B.MAIN_LANE_QTY  / B.LANE_QTY)
                , TH_BUF_OUT_ITEM_PLAN.AVAILABLE_QTY  = A.AVAILABLE_QTY  * (B.MAIN_LANE_QTY  / B.LANE_QTY)
          FROM    TH_BUF_OUT_ITEM_PLAN A,
                  TH_EXP_LANEORDER B
          WHERE   A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID = @v_plan_id
          AND     A.OUT_VERSION_ID = @v_out_version_id
          AND     A.MASTER_ID = B.MASTER_ID
          AND     A.PLAN_ID = B.PLAN_ID
          AND     A.WORK_ORDER_ID = B.ORDER_ID
          AND     B.SUB_ORDER_ID IS NOT NULL

          --LOG 생성
          SET @v_message = 'MAIN LANE ORDER UPDATE - ' + CONVERT(nvarchar, @@ROWCOUNT)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
        END
*/

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
