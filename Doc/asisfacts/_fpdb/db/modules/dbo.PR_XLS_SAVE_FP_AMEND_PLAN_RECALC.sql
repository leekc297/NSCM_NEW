
/*
 * Program ID   : PR_XLS_SAVE_FP_AMEND_PLAN_RECALC
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.10.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec PR_XLS_SAVE_FP_AMEND_PLAN_RECALC 

 */

CREATE PROCEDURE [dbo].[PR_XLS_SAVE_FP_AMEND_PLAN_RECALC]
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- LOG 용 변수 설정
	DECLARE @v_proc_name		NVARCHAR(100) = 'PR_XLS_SAVE_FP_AMEND_PLAN_RECALC'
	DECLARE @v_table_name		NVARCHAR(100)
	DECLARE @v_log_type			NVARCHAR(100)
	DECLARE @v_log_count		INTEGER	  = 0
	DECLARE @v_log_code			NVARCHAR(1000)
	DECLARE @v_message			NVARCHAR(1000)
	DECLARE @v_descr			NVARCHAR(250)
	DECLARE @v_event_dttm		DATETIME     = GETDATE()


	DECLARE @v_instance_id		nvarchar(max)
	DECLARE @v_fp_plan_id		nvarchar(max)
	declare @v_instance_type    nvarchar(50)

	if object_id('tempdb..#PLANS') is not null
		drop table #PLANS

	CREATE TABLE #PLANS (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			, INSTANCE_ID               nvarchar(50)             
			, FP_PLAN_ID 				nvarchar(50)
			, INSTANCE_TYPE             nvarchar(50)
			)
			;

	DECLARE @INX				INT				= 0;
    DECLARE @MAX_NUM			INT				= 0;

	--set @v_intg_plan_id			= @p_intg_plan_id

	declare @INVALID_COUNT              int
	declare @INVALID_MSG                nvarchar(max)

    SET @v_table_name	= null	
    SET @v_log_type		= 'START'
    SET @v_log_count	= null
    SET @v_log_code		= null
    SET @v_message		= '############### Start of procedure ###############'
    SET @v_descr		= null
    SET @v_event_dttm	= getdate()
	EXEC PR_XIF_LOG @v_proc_name, @v_table_name, @v_log_type, @v_log_count, @v_log_code, @v_message, @v_descr, @v_event_dttm


	BEGIN TRY	

		
		insert into #PLANS (instance_id, fp_plan_id, instance_type)
		select instance_id
			 , plan_id
			 , (select top 1 instance_type from [dbo].[FP_INSTANCE_INFO_V] where instance_id = x.instance_id) as instance_type
		  from scm_fp_plan_h as x with(nolock)
		 where intg_plan_id is not null 
		   and intg_recalc_flag = 'A'
		 order by intg_plan_id, plan_id 

	
		SELECT @INX			= 1
			 , @MAX_NUM		= COUNT(*)
		  FROM #PLANS


		WHILE @INX <= @MAX_NUM
		BEGIN
			
			SELECT @v_instance_id		= INSTANCE_ID	
				 , @v_fp_plan_id 		= FP_PLAN_ID 	
				 , @v_instance_type     = INSTANCE_TYPE
			  FROM #PLANS 
			 WHERE TID					= @INX

			IF @v_INSTANCE_TYPE = 'E'
			BEGIN

				SET @v_log_code		= 'STEP XLS ELECTRODE PLAN RECALCULATION : ' + @v_fp_plan_id


				--update scm_fp_plan_h
				--   set intg_recalc_flag = 'P'
				-- where 1 = 1
				--   and instance_id = @v_instance_id
				--   and plan_id = @v_fp_plan_id

				EXEC PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI @v_instance_id, @v_fp_plan_id

				update scm_fp_plan_h
				   set intg_recalc_flag = 'Y'
				 where 1 = 1
				   and instance_id = @v_instance_id
				   and plan_id = @v_fp_plan_id

			END
			ELSE IF @v_INSTANCE_TYPE = 'A'
			BEGIN

				SET @v_log_code		= 'STEP XLS CELL PLAN RECALCULATION : ' + @v_fp_plan_id

				--update scm_fp_plan_h
				--   set intg_recalc_flag = 'P'
				-- where 1 = 1
				--   and instance_id = @v_instance_id
				--   and plan_id = @v_fp_plan_id

				EXEC PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_A @v_instance_id, @v_fp_plan_id
				EXEC PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_B @v_instance_id, @v_fp_plan_id

				update scm_fp_plan_h
				   set intg_recalc_flag = 'Y'
				 where 1 = 1
				   and instance_id = @v_instance_id
				   and plan_id = @v_fp_plan_id

			END
			ELSE IF @v_INSTANCE_TYPE = 'F'
			BEGIN

				SET @v_log_code		= 'STEP XLS FORMATION PLAN RECALCULATION : ' + @v_fp_plan_id

				--update scm_fp_plan_h
				--   set intg_recalc_flag = 'P'
				-- where 1 = 1
				--   and instance_id = @v_instance_id
				--   and plan_id = @v_fp_plan_id

				EXEC PR_SCM_OF_PSI_SHORTER_LT_SIM_CALL @v_instance_id, @v_fp_plan_id, 'Y'
				EXEC PR_SCM_OF_PSI_AMEND_UI_CALCULATION_FORM @v_instance_id, @v_fp_plan_id, '-'

				update scm_fp_plan_h
				   set intg_recalc_flag = 'Y'
				 where 1 = 1
				   and instance_id = @v_instance_id
				   and plan_id = @v_fp_plan_id

			END

			PRINT @v_instance_id + '/ ' +  @v_fp_plan_id + '/ ' + @v_INSTANCE_TYPE

			SET @INX = @INX + 1
		END


		SET @v_table_name	= null	
		SET @v_log_type		= 'END'
		SET @v_log_count	= null
		SET @v_log_code		= 'STEP END PROCEDURE'
		SET @v_message		= '############### End of procedure ###############'
		SET @v_descr		= null
		SET @v_event_dttm	= getdate()
		EXEC PR_XIF_LOG @v_proc_name, @v_table_name, @v_log_type, @v_log_count, @v_log_code, @v_message, @v_descr, @v_event_dttm

		PRINT 'OK'
		SELECT 'OK' as ret, '' as msg   

	END TRY

	BEGIN CATCH

		--IF @@TRANCOUNT > 0
		--	ROLLBACK TRAN

		--update scm_fp_plan_h
		--   set intg_recalc_flag = 'A'
		-- where 1 = 1
		--   and instance_id = @v_instance_id
		--   and plan_id = @v_fp_plan_id

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


	if object_id('tempdb..#PLANS') is not null
		drop table #PLANS

END



