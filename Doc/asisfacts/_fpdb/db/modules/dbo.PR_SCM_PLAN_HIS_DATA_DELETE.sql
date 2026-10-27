CREATE PROCEDURE [dbo].[PR_SCM_PLAN_HIS_DATA_DELETE]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_PLAN_HIS_DATA_DELETE                                               **/
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
/** 2017.04.24     KIMCD         최초 작성                                                    **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_IF_DATA_DELETE
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_PLAN_HIS_DATA_DELETE'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)
  DECLARE @period           int = 7        -- 보관 기간 설정
  DECLARE @v_seq            nvarchar(1000)

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
    
    SET @key_date = CONVERT(NVARCHAR, DATEADD(DAY, -1 * @period, GETDATE()), 112)
    
    DECLARE
      @c_t$table_name   nvarchar(max),
      @c_t$column_name  nvarchar(max)
        
    DECLARE
      C_TABLE CURSOR LOCAL FOR 
        SELECT DISTINCT TABLE_NAME, COLUMN_NAME
        FROM   INFORMATION_SCHEMA.COLUMNS WHERE 1=1
        AND    COLUMN_NAME LIKE '%PLAN_ID'
        AND    TABLE_NAME IN ('BUF_AMEND_LOB_PLAN_R'
,'FP_AMEND_ITEM'
,'FP_AMEND_ITEM_OPERATION'
,'FP_AMEND_LOB_PLAN_R'
,'FP_AMEND_LOB_PSI_CATEGORY_R'
,'FP_AMEND_LOB_PSI_R'
,'FP_AMEND_NET_DEMAND'
,'FP_AMEND_OFFTIME'
,'FP_AMEND_ORDER_TRACKING'
,'FP_AMEND_PRODUCTION_PLAN_R'
,'FP_AMEND_PSI'
,'FP_AMEND_REPLAN_OFF_CALENDAR'
,'FP_AMEND_REPLAN_RESOURCE'
,'FP_AMEND_RESOURCE'
,'FP_AMEND_RESOURCE_USAGE'
,'FP_AMEND_SETUP_MATRIX'
,'FP_AMEND_TIMEPHASED_BOR'
,'FP_AMEND_TIMEPHASED_LANE_BOR'
,'FP_AMEND_UTILIZATION'
,'FP_AMEND_WORK_ORDER_SPL'
,'FP_BUF_SCM_LANE_SITE'
,'FP_DAILY_DEMAND_OFFSET_H'
,'FP_DAILY_INSTANCE_ORDER_STATUS'
,'FP_DAILY_NET_DEMAND_H'
,'FP_DAILY_PLAN_ORDER_R'
,'FP_DAILY_PRODUCTION_PLAN_R'
,'FP_DEMAND_FULFILLMENT_R'
,'FP_MES_PRODUCTION_PLAN_M'
,'FP_MOVE_PLAN_R'
,'FP_ORDER_PEGGING_R'
,'FP_ORDER_TRACKING_R'
,'FP_PLAN_STATUS_H'
,'FP_PLAN_UTILIZATION_R'
,'FP_PROBLEM_REPORT_R'
,'FP_PRODUCTION_PLAN_CHANGE_R'
,'FP_PRODUCTION_PLAN_EQUIPMENT_R'
,'FP_PRODUCTION_PLAN_R'
,'FP_PSI_R'
,'FP_WOW_HIST'
,'HIS_AMEND_PRODUCTION_PLAN_R'
,'HIS_PLAN_STATUS_H'
,'th_buf_A6000_plan_target'
,'TH_BUF_SCM_LOB_DATA'
,'TH_BUF_SCM_RESCHEDULE_BOR'
,'TH_BUF_SCM_RESCHEDULE_CALENDAR'
,'TH_BUF_SCM_RESCHEDULE_INFO'
,'TH_BUF_SCM_RESCHEDULE_PLAN'
,'TH_BUF_SCM_RESCHEDULE_RESULT'
,'TH_LOG_HISTORY'
)
        ORDER  BY 1        
    BEGIN

      OPEN C_TABLE

      WHILE 1 = 1
     
        BEGIN
        
          SET @n_row_count = 0

          FETCH C_TABLE
           INTO @c_t$table_name, @c_t$column_name

          IF @@FETCH_STATUS <> 0
            BREAK
    
          IF CHARINDEX('TH_ENG', @c_t$table_name) > 0 OR @c_t$table_name = 'TH_MST_OFF_CALENDAR'
            SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                           + ' A, SCM_FP_PLAN_H C '
                           + ' WHERE  A.'+@c_t$column_name+' LIKE C.PLAN_ID + ''%'' '
                           + ' AND    C.PLAN_START_TIME <= '''+@key_date+''''
          else
            SET @v_seq = 'DELETE FROM A FROM ' + @c_t$table_name + ' '
                           + ' A, .SCM_FP_PLAN_H C '
                           + ' WHERE  A.'+@c_t$column_name+' = C.PLAN_ID '
                           + ' AND    C.PLAN_START_TIME <= '''+@key_date+''''
          
          exec ( @v_seq )
    
          SET @n_row_count = @@ROWCOUNT
          
          SET @v_table_name = @c_t$table_name
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_seq

        END
        
      CLOSE C_TABLE

      DEALLOCATE C_TABLE

    END
    
    IF @@TRANCOUNT > 0
      COMMIT WORK 
      
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
