CREATE PROCEDURE [dbo].[PR_SCM_UF_ITEM_SETUP_DELETE]
   @p_company	      nvarchar(max) = '-',
   @p_division	    nvarchar(max) = '-',
   @p_site	        nvarchar(max) = '-',
   @p_operation		  nvarchar(max) = '-',
   @p_category	    nvarchar(max) = '-',
   @p_key           nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_DEMAND					             					                          **/
/** 프로그램 명   :											                                                     **/
/** 설 명         :											                                                      **/
/** Version       : 1.0.0                                                                     **/
/**                 			                                                                    **/
/** Argument     										        							                                    **/
/**                 			                                                                    **/
/**	[검색 조건]																				                                        **/
/**                 			                                                                    **/
/** [Biz Logic]										        								                                    **/
/**                 			                                                                    **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자		작 성 자			사	   유											                                 **/
/**===========================================================================================**/
/** 2016.08.22		LJH					최초 작성											                                  **/
/***********************************************************************************************/
/*
	EXEC PR_SCM_IF_DEMAND
*/
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
	SET XACT_ABORT ON;

  -- 필수 칼럼
	DECLARE @v_company			  nvarchar(30)   
	DECLARE @v_division			  nvarchar(30)
	DECLARE @v_corporation    nvarchar(30)
	DECLARE @v_plant   			  nvarchar(30)
	DECLARE @v_master_id			nvarchar(30)
	DECLARE @v_plan_id				nvarchar(30)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime

  DECLARE  @company 	    nvarchar(max) = @p_company,
           @division	    nvarchar(max) = @p_division,
           @site	        nvarchar(max) = @p_site,
           @operation		  nvarchar(max) = @p_operation,
           @category	    nvarchar(max) = @p_category,
           @key           nvarchar(max) = @p_key
  

  -- LOG 용 변수 설정
	DECLARE @v_proc_name			nvarchar(100) = 'PR_SCM_UF_ITEM_SETUP_DELETE'
	DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
	DECLARE @v_descr				  nvarchar(250)
	DECLARE @n_row_count			Integer	= 0
	DECLARE @n_log_count  		Integer	= 0
	DECLARE @v_log_code			  nvarchar(10)
	
	DECLARE @sysdate				  DATETIME2 = GETDATE()

	DECLARE @v_temp1				  nvarchar(1000)
	DECLARE @v_temp2				  nvarchar(1000)
  
  SET @v_master_id  = 'UI_INTERFACE'
  SET @v_plan_id    = 'UI_INTERFACE'
	
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
	SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  SET @v_table_name = 'INPUT-DATA'
  --LOG 생성
  SET @v_message = '@company : ' + @company
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

  --LOG 생성
  SET @v_message = '@division : ' + @division
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

  --LOG 생성
  SET @v_message = '@site : ' + @site
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

  --LOG 생성
  SET @v_message = '@operation : ' + @operation
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

  --LOG 생성
  SET @v_message = '@category : ' + @category
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

  --LOG 생성
  SET @v_message = '@key : ' + @key
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
  
  
  BEGIN TRY
    
    BEGIN
    
      SET @v_table_name = 'SCM_ITEM_SETUP_GROUP_M'

      delete from   SCM_ITEM_SETUP_GROUP_M
      where  company_id         = @company
      and    DIVISION_ID        = @division
      and    SITE_ID            = @site
      and    OPERATION_ID       = @operation
      and    SETUP_CATEGORY_ID  = @category
      and    SETUP_KEY_ID       = @key

        
      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
      
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
