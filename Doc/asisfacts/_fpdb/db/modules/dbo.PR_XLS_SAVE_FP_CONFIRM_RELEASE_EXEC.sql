
/*
 * Program ID   : PR_XLS_SAVE_FP_CONFIRM_RELEASE_EXEC
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.09.23   FP Pjt.         Create.
 * 
 * 
 ex) 
  exec PR_XLS_SAVE_FP_CONFIRM_RELEASE_EXEC 'crjung', 'UC1-20240904-08'
 */

CREATE PROCEDURE [dbo].[PR_XLS_SAVE_FP_CONFIRM_RELEASE_EXEC]
	@p_user_id					NVARCHAR(MAX)    
,	@p_intg_plan_id				NVARCHAR(MAX)  

AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- LOG 용 변수 설정
	DECLARE @v_proc_name		NVARCHAR(100) = 'PR_XLS_SAVE_FP_CONFIRM_RELEASE_EXEC'
	DECLARE @v_table_name		NVARCHAR(100)
	DECLARE @v_log_type			NVARCHAR(100)
	DECLARE @v_log_count		INTEGER	  = 0
	DECLARE @v_log_code			NVARCHAR(1000)
	DECLARE @v_message			NVARCHAR(1000)
	DECLARE @v_descr			NVARCHAR(250)
	DECLARE @v_event_dttm		DATETIME     = GETDATE()

	DECLARE @v_user_id				nvarchar(max)
	DECLARE @v_intg_plan_id			nvarchar(max)
	DECLARE @v_return				nvarchar(max)
	declare @v_no_recalc_count	int

	DECLARE @INX				INT				= 0;
    DECLARE @MAX_NUM			INT				= 0;

	set @v_user_id				= @p_user_id
	set @v_intg_plan_id			= @p_intg_plan_id

	DECLARE @v_instance_id		nvarchar(max)
	DECLARE @v_fp_plan_id		nvarchar(max)
	declare @v_apl_code         nvarchar(10)

	declare @INVALID_COUNT      int
	declare @INVALID_MSG        nvarchar(max)

	if object_id('tempdb..#SCM_FP_PLAN') is not null
		drop table #SCM_FP_PLAN

	CREATE TABLE #SCM_FP_PLAN (
	       TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
		 , INSTANCE_ID              NVARCHAR(50)
		 , FP_PLAN_ID               NVARCHAR(50) 
 		 )

    SET @v_table_name	= null	
    SET @v_log_type		= 'START'
    SET @v_log_count	= null
    SET @v_log_code		= null
    SET @v_message		= '############### Start of procedure ###############'
    SET @v_descr		= null
    SET @v_event_dttm	= getdate()
	EXEC PR_XIF_LOG @v_proc_name, @v_table_name, @v_log_type, @v_log_count, @v_log_code, @v_message, @v_descr, @v_event_dttm

	BEGIN TRY		

		--BEGIN TRAN

		-- 재계산 미수행일 경우 릴리즈 제한
		select @v_no_recalc_count = count(*)
		  from scm_fp_plan_h as x with(nolock)
		 where intg_plan_id = @v_intg_plan_id
		   and ISNULL(intg_recalc_flag, 'N') = 'A'

		IF @v_no_recalc_count > 0
		BEGIN
			SET @INVALID_MSG = 'No recalculation plan exists. Please Wait for finishing recalculation in a few minutes : ' + @v_intg_plan_id
			RAISERROR  ( @INVALID_MSG, 16, 1 ); 
		END

        insert into #SCM_FP_PLAN (instance_id, fp_plan_id)
		select x.instance_id
		     , x.plan_id
		  from (
				select instance_id
					 , plan_id
					 , case when instance_id like '%_E_PRE_%'	then 1
							when instance_id like '%_CELL_%'	then 2
							when instance_id like '%_FORM_%'	then 3
							when instance_id like '%_PACK_%'	then 4
							else 5 end exec_ordered
				 from scm_fp_plan_h as x with(nolock)
			    where intg_plan_id = @v_intg_plan_id
			   ) x
		 --where x.exec_ordered = 3
		 order by x.exec_ordered

		SET @v_apl_code		= LEFT(@v_intg_plan_id, 3);



		SELECT @INX			= 1
			 , @MAX_NUM		= COUNT(*)
		  FROM #SCM_FP_PLAN

		IF @MAX_NUM = 0
		BEGIN
			RAISERROR  ( 'No plan to release.', 16, 1 ); 
		END


		WHILE @INX <= @MAX_NUM
		BEGIN

			SET @v_instance_id			= null
			SET @v_fp_plan_id			= null

			SELECT @v_instance_id		= instance_id
			     , @v_fp_plan_id        = fp_plan_id
			   FROM #SCM_FP_PLAN 
			  WHERE TID					= @INX

			SET @v_log_code		= 'STEP XLS CONFIRM_RELEASE : ' + @v_fp_plan_id

			EXEC PR_XLS_SAVE_FP_CONFIRM_RELEASE @v_user_id, @v_instance_id, @v_fp_plan_id, @v_apl_code, @v_return OUTPUT

			if @v_return != 'OK' 
			begin
				RAISERROR  ( @v_return, 16, 1 ); 
			end

			SET @INX = @INX + 1
		END

		--COMMIT TRAN
		SET @v_table_name	= null	
		SET @v_log_type		= 'END'
		SET @v_log_count	= null
		SET @v_log_code		= 'STEP END PROCEDURE'
		SET @v_message		= '############### End of procedure ###############'
		SET @v_descr		= null
		SET @v_event_dttm	= getdate()
		EXEC PR_XIF_LOG @v_proc_name, @v_table_name, @v_log_type, @v_log_count, @v_log_code, @v_message, @v_descr, @v_event_dttm
		
        SELECT 'OK' as ret, '' as msg   
		PRINT 'OK'
		--SET @p_return = 'OK' 

	END TRY

	BEGIN CATCH

		--IF @@TRANCOUNT > 0
		--	ROLLBACK TRAN
		SET @v_table_name	= null	
		SET @v_log_type		= 'ERROR'
		SET @v_log_count	= null
		--SET @v_log_code		= null
		SET @v_message		= null
		SET @v_descr		= ERROR_MESSAGE()
		SET @v_event_dttm	= getdate()
		EXEC PR_XIF_LOG @v_proc_name, @v_table_name, @v_log_type, @v_log_count, @v_log_code, @v_message, @v_descr, @v_event_dttm

		SELECT 'NG' as ret, ERROR_MESSAGE() as msg
		PRINT 'NG|' + ERROR_MESSAGE()
		--SET @p_return = 'NG|' + ERROR_MESSAGE()

	END CATCH

	if object_id('tempdb..#SCM_FP_PLAN') is not null
		drop table #SCM_FP_PLAN


END



