CREATE PROCEDURE [dbo].[PR_LOG_PROCESS_GANTT]
@p_event_dttm		DateTime
, @p_master_id     nvarchar(1000)
, @p_plan_id       nvarchar(1000)
, @p_proc_name     nvarchar(1000)
, @p_table_name    nvarchar(1000)
, @p_log_type      nvarchar(1000)
, @p_log_count     Integer
, @p_log_code      nvarchar(1000)
, @p_message       nvarchar(1000)
, @p_descr         nvarchar(1000)
AS
/**********************************************************************************************/
/** 프로그램 ID   : PR_LOG_PROCESS_GANTT					                   						 **/
/** 프로그램 명   :											                                  **/
/** 설 명         :																               **/
/** Version       : 1.0.0                                                                    **/
/**                 			                                                             **/
/** Argument     										        							 **/
/**                 			                                                             **/
/**	[검색 조건]																				 **/
/**                 			                                                             **/
/** [Biz Logic]										        								 **/
/**                 			                                                             **/
/**------------------------------------------------------------------------------------------**/
/** 작 성 일 자		작 성 자			사	   유											 **/
/**==========================================================================================**/
/** 2016.01.01		COCHO					최초 작성											  */
/**********************************************************************************************/
/*
	DECLARE @dtDATE			DATETIME	= GETDATE()
	EXEC PR_LOG_PROCESS_GANTT @dtDATE, 'v_master_id', 'v_plan_id', 'v_proc_name', null, 'START', null, 'v_temp1', '###TEST####', null
*/
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	BEGIN TRANSACTION;
    SET NOCOUNT ON; 
	SET XACT_ABORT ON;

	/* 프로그램명 */
	DECLARE @v_proc_name			nvarchar(100) = 'PR_LOG_PROCESS_GANTT'
	/* 테이블명 */
	DECLARE @v_descr				nvarchar(250)
	DECLARE @v_count				Integer	= 0



	BEGIN TRY
		insert into th_log_history (event_dttm, master_id, plan_id, proc_name, table_name, log_type, log_count, log_code, message, descr)
		values (@p_event_dttm, @p_master_id, @p_plan_id, @p_proc_name, @p_table_name, @p_log_type, @p_log_count, @p_log_code, @p_message, @p_descr);

		COMMIT TRANSACTION;

    /*
		if @p_log_type = 'ERROR' 
		BEGIN
		BEGIN TRANSACTION;
			update th_gui_planinfo
			set
				is_legacyif			= (CASE WHEN is_legacyif='P' THEN 'N' ELSE is_legacyif END)
				, is_legacyifvalid	= (CASE WHEN is_legacyifvalid='P' THEN 'N' ELSE is_legacyifvalid END)
				, is_beforeplan		= (CASE WHEN is_beforeplan='P' THEN 'N' ELSE is_beforeplan END)
				, is_dpp			= (CASE WHEN is_dpp='P' THEN 'N' ELSE is_dpp END)
				, is_mastervalid	= (CASE WHEN is_mastervalid='P' THEN 'N' ELSE is_mastervalid END)
				, is_running		= (CASE WHEN is_running='P' THEN 'N' ELSE is_running END)
			where  1=1;

		COMMIT TRANSACTION;
		END
    */
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;

		BEGIN TRANSACTION;
		SET @v_descr = ERROR_MESSAGE()

		insert into th_log_history (event_dttm, master_id, plan_id, proc_name, table_name, log_type, log_count, log_code, message, descr)
		values (@p_event_dttm, ISNULL (@p_master_id, '-'), ISNULL (@p_plan_id, '-'), @v_proc_name, 'TH_LOG_HISTORY', 'ERROR', null, 'E9999', null, @v_descr);

		COMMIT TRANSACTION;
	END CATCH
END
