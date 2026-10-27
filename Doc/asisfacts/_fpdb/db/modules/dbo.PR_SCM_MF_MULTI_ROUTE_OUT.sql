CREATE PROCEDURE [dbo].[PR_SCM_MF_MULTI_ROUTE_OUT]  
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-',
   @p_out_version_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MF_MULTI_ROUTE_OUT                                                 **/
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
  EXEC PR_SCM_MF_MULTI_ROUTE_OUT
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  DECLARE
    @v_proc_name        nvarchar(150) = 'PR_SCM_MF_MULTI_ROUTE_OUT', 
    @v_table_name       nvarchar(150) = NULL, 
    @v_master_id        nvarchar(150) = @p_master_id, 
    @v_plan_id          nvarchar(150) = @p_plan_id, 
    @v_out_version_id   nvarchar(150) = @p_out_version_id
    
  DECLARE
    @n_count            Integer  = 0,
    @n_log_count        Integer  = 0,
    @sysdate            DATETIME2 = GETDATE(),
    @v_message          nvarchar(200)

    
  BEGIN TRY
    --LOG 생성
    SET @n_log_count = @n_log_count + 1
    SET @sysdate = GETDATE()
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, '###############', 'START', @n_log_count, null, '############### Start of procedure ###############', null

    SELECT @n_count = count(*)
    FROM   TH_BUF_SCM_MULTI_ROUTING
    WHERE  MASTER_ID = @v_master_id
    AND    PLAN_ID = @v_plan_id
    
    IF @n_count > 0

      BEGIN

        SET @v_table_name = 'TH_BUF_OUT_WORK_ORDER'

        UPDATE TH_BUF_OUT_WORK_ORDER
        SET    TH_BUF_OUT_WORK_ORDER.ITEM_ID = B.ITEM_ID
        FROM   TH_BUF_OUT_WORK_ORDER A,
               TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.OUT_VERSION_ID = @v_out_version_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.NEW_ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     A.ROUTE_ID = B.ROUTE_ID
        AND     A.OPERATION_ID = B.OPERATION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        -----------------------------------------------------------------------------------------------------------------------------------
        
        SET @v_table_name = 'TH_BUF_OUT_WORK_ORDER_SPL'

        UPDATE TH_BUF_OUT_WORK_ORDER_SPL
        SET    TH_BUF_OUT_WORK_ORDER_SPL.ITEM_ID = B.ITEM_ID
        FROM   TH_BUF_OUT_WORK_ORDER_SPL A,
               TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.OUT_VERSION_ID = @v_out_version_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.NEW_ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     A.ROUTE_ID = B.ROUTE_ID
        AND     A.OPERATION_ID = B.OPERATION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        -----------------------------------------------------------------------------------------------------------------------------------
        
        SET @v_table_name = 'TH_BUF_OUT_RESOURCE_USAGE'

        UPDATE  TH_BUF_OUT_RESOURCE_USAGE
        SET     TH_BUF_OUT_RESOURCE_USAGE.ITEM_ID = B.ITEM_ID
        FROM    TH_BUF_OUT_RESOURCE_USAGE A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.OUT_VERSION_ID = @v_out_version_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.NEW_ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     A.ROUTE_ID = B.ROUTE_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        -----------------------------------------------------------------------------------------------------------------------------------
        
        SET @v_table_name = 'TH_BUF_OUT_ORDER_TRACKING'

        UPDATE  TH_BUF_OUT_ORDER_TRACKING
        SET     TH_BUF_OUT_ORDER_TRACKING.IN_ITEM_ID = B.ITEM_ID
        FROM    TH_BUF_OUT_ORDER_TRACKING A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.OUT_VERSION_ID = @v_out_version_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.IN_ITEM_ID = B.NEW_ITEM_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


        UPDATE  TH_BUF_OUT_ORDER_TRACKING
        SET     TH_BUF_OUT_ORDER_TRACKING.OUT_ITEM_ID = B.ITEM_ID
        FROM    TH_BUF_OUT_ORDER_TRACKING A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.OUT_VERSION_ID = @v_out_version_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.OUT_ITEM_ID = B.NEW_ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     A.ROUTE_ID = B.ROUTE_ID
        AND     A.OPERATION_ID = B.OPERATION_ID
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        -----------------------------------------------------------------------------------------------------------------------------------
        
        SET @v_table_name = 'TH_BUF_OUT_ORDER_TRACKING_DETAIL'

        UPDATE  TH_BUF_OUT_ORDER_TRACKING_DETAIL
        SET     TH_BUF_OUT_ORDER_TRACKING_DETAIL.IN_ITEM_ID = B.ITEM_ID
        FROM    TH_BUF_OUT_ORDER_TRACKING_DETAIL A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.OUT_VERSION_ID = @v_out_version_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.IN_ITEM_ID = B.NEW_ITEM_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


        UPDATE  TH_BUF_OUT_ORDER_TRACKING_DETAIL
        SET     TH_BUF_OUT_ORDER_TRACKING_DETAIL.OUT_ITEM_ID = B.ITEM_ID
        FROM    TH_BUF_OUT_ORDER_TRACKING_DETAIL A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.OUT_VERSION_ID = @v_out_version_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.OUT_ITEM_ID = B.NEW_ITEM_ID
        AND     A.SITE_ID = B.SITE_ID
        AND     A.ROUTE_ID = B.ROUTE_ID
        AND     A.OPERATION_ID = B.OPERATION_ID
        
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        -----------------------------------------------------------------------------------------------------------------------------------
        
        SET @v_table_name = 'TH_BUF_OUT_ITEM_PLAN'

        UPDATE  TH_BUF_OUT_ITEM_PLAN
        SET     TH_BUF_OUT_ITEM_PLAN.ITEM_ID = B.ITEM_ID
        FROM    TH_BUF_OUT_ITEM_PLAN A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.OUT_VERSION_ID = @v_out_version_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.NEW_ITEM_ID
        AND     A.SITE_ID = B.SITE_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        -----------------------------------------------------------------------------------------------------------------------------------
        
        SET @v_table_name = 'TH_BUF_OUT_ITEM_PLAN_SPL'

        UPDATE  TH_BUF_OUT_ITEM_PLAN_SPL
        SET     TH_BUF_OUT_ITEM_PLAN_SPL.ITEM_ID = B.ITEM_ID
        FROM    TH_BUF_OUT_ITEM_PLAN_SPL A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.OUT_VERSION_ID = @v_out_version_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.NEW_ITEM_ID
        AND     A.SITE_ID = B.SITE_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        -----------------------------------------------------------------------------------------------------------------------------------
        
        SET @v_table_name = 'TH_BUF_OUT_DELIVERY_ORDER'

        UPDATE  TH_BUF_OUT_DELIVERY_ORDER
        SET     TH_BUF_OUT_DELIVERY_ORDER.ITEM_ID = B.ITEM_ID
        FROM    TH_BUF_OUT_DELIVERY_ORDER A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.OUT_VERSION_ID = @v_out_version_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.NEW_ITEM_ID
        AND     A.FROM_SITE_ID = B.SITE_ID
        AND     A.FROM_ROUTE_ID = B.ROUTE_ID
        AND     A.FROM_OPERATION_ID = B.OPERATION_ID

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


        -----------------------------------------------------------------------------------------------------------------------------------

        SET @v_table_name = 'TH_BUF_OUT_PROBLEM_REPORT'

        UPDATE  TH_BUF_OUT_PROBLEM_REPORT
        SET     TH_BUF_OUT_PROBLEM_REPORT.NODE_ID = REPLACE(A.NODE_ID, B.NEW_ITEM_ID, B.ITEM_ID)
        FROM    TH_BUF_OUT_PROBLEM_REPORT A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.OUT_VERSION_ID = @v_out_version_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     CHARINDEX(B.NEW_ITEM_ID, A.NODE_ID) > 0

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        -----------------------------------------------------------------------------------------------------------------------------------

        SET @v_table_name = 'TH_BUF_OUT_PROBLEM_DATA'

        UPDATE  TH_BUF_OUT_PROBLEM_DATA
        SET     TH_BUF_OUT_PROBLEM_DATA.COLUMN_VALUE = REPLACE(A.COLUMN_VALUE, B.NEW_ITEM_ID, B.ITEM_ID)
        FROM    TH_BUF_OUT_PROBLEM_DATA A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.OUT_VERSION_ID = @v_out_version_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     CHARINDEX(B.NEW_ITEM_ID, A.COLUMN_VALUE) > 0

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        UPDATE  TH_BUF_OUT_PROBLEM_DATA
        SET     TH_BUF_OUT_PROBLEM_DATA.PROBLEM_DESCR = REPLACE(A.PROBLEM_DESCR, B.NEW_ITEM_ID, B.ITEM_ID)
        FROM    TH_BUF_OUT_PROBLEM_DATA A,
                TH_BUF_SCM_MULTI_ROUTING B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.OUT_VERSION_ID = @v_out_version_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     CHARINDEX(B.NEW_ITEM_ID, A.PROBLEM_DESCR) > 0

        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        -----------------------------------------------------------------------------------------------------------------------------------

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
