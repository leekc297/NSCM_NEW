CREATE PROCEDURE [dbo].[PR_SCM_INSTANCE_PROC_CALL]
@p_param_1 nvarchar(MAX) = '-', @p_param_2 nvarchar(MAX) = '-', @p_param_3 nvarchar(MAX) = '-', @p_param_4 nvarchar(MAX) = '-', @p_param_5 nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name nvarchar(100) = 'PR_SCM_INSTANCE_PROC_CALL'
	DECLARE @v_descr     nvarchar(250)
	DECLARE @v_flag  nvarchar(1) = 'N'
	DECLARE @v_run_flag  nvarchar(1) = 'N'
	DECLARE @v_run_step  nvarchar(1) = '0'
	DECLARE @v_plan_flag  nvarchar(1) = 'C'
	DECLARE @v_run_step2  nvarchar(1) = '0'
	DECLARE @n_loop_date nvarchar(250)
	DECLARE @n_loop_count INTEGER    = 0
  
	DECLARE @n_log_count INTEGER    = 0
	DECLARE @sysdate     DATETIME     = GETDATE()
	DECLARE @v_log_code   nvarchar(10)
	DECLARE @v_isfinished nvarchar(20)
  
	-- ERROR_LINE
	DECLARE @v_temp1     nvarchar(1000)
	DECLARE @v_temp2     nvarchar(1000)

	-- ================================================
	-- Declare start
	-- ================================================
	DECLARE @v_param_1	nvarchar(100)	-- PROC NAME
	DECLARE @v_param_2	nvarchar(100)	-- INSTANCE ID
	DECLARE @v_param_3	nvarchar(100)	-- PLAN	ID
	DECLARE @v_param_4	nvarchar(100)	-- TEMP
	DECLARE @v_param_5	nvarchar(100)	-- TEMP
  
	DECLARE @v_dbname		nvarchar(100)

	DECLARE @sqltext    nvarchar(1000)
	-- ================================================
	-- Declare end
	-- ================================================
 
	SET @v_param_1  = @p_param_1
	SET @v_param_2  = @p_param_2
	SET @v_param_3  = @p_param_3
	SET @v_param_4  = @p_param_4
	SET @v_param_5  = @p_param_5


  
	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

	-- Start 로그는 무조건 남김
	SET @n_log_count = @n_log_count + 1
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', @n_log_count, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate
  
	--EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null
  
	BEGIN TRY        

		BEGIN

			SELECT @v_dbname = DB_NAME()
			;

			SET @v_descr = 'DBNAME :'+CONVERT(nvarchar,@v_dbname)
			SET @n_log_count = @n_log_count + 1
			EXEC PR_LOG_PROCESS @sysdate, @v_param_2, @v_param_3, @v_proc_name, null, 'INSERT', @n_log_count, NULL, @v_descr, null
			
			IF CHARINDEX('DEV', @v_dbname ) > 0	--개발서버
			BEGIN
			
				IF @v_param_1 = 'PR_SCM_DPP_FIX_LINE_PEGGING_SUB' 
				BEGIN	
				
					SET @v_descr = 'PROC :'+CONVERT(nvarchar,@v_param_1)
					SET @n_log_count = @n_log_count + 1
					EXEC PR_LOG_PROCESS @sysdate, @v_param_2, @v_param_3, @v_proc_name, null, 'INSERT', @n_log_count, NULL, @v_descr, null

					EXEC KR_CELL_DEV.dbo.PR_SCM_DPP_FIX_LINE_PEGGING_SUB @v_param_2, @v_param_3
					-- call PR_SCM_DPP_FIX_LINE_PEGGING_SUB end
				END 
				--ELSE BEGIN

				--END

			END -- DEV end
			--ELSE BEGIN
		
					SET @v_descr = 'PROC :'+CONVERT(nvarchar,@v_param_1)
					SET @n_log_count = @n_log_count + 1
					EXEC PR_LOG_PROCESS @sysdate, @v_param_2, @v_param_3, @v_proc_name, null, 'INSERT', @n_log_count, NULL, @v_descr, null
			--END


			--SET @v_descr = 'SCM_LOSS_CALENDAR_M INSERT :'+CONVERT(nvarchar,@@ROWCOUNT)
			--SET @n_log_count = @n_log_count + 1
			--EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'INSERT', @n_log_count, NULL, @v_descr, null
		  END

    -- ================================================
    -- 로직 추가 end
    -- ================================================
 
	END TRY

	BEGIN CATCH
       

		-- 에러나도 로그는 인서트
		SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
    
		--EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr

			IF @@TRANCOUNT > 0
				COMMIT WORK 
	END CATCH
  
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   999999, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
  
	--EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
