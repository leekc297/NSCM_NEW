CREATE PROCEDURE [dbo].[PR_SCM_NETJOB_RUN_KR_CELL]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
  SET XACT_ABORT ON

   -- LOG 용 변수 설정
  DECLARE @v_proc_name nvarchar(100) = 'PR_SCM_NETJOB_RUN_KR_CELL'
  DECLARE @v_table_name     nvarchar(100)
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
  DECLARE @v_instance_id  nvarchar(1000)  
  DECLARE @v_plan_id      nvarchar(1000)
  
  DECLARE @sqltext          nvarchar(1000)
        , @v_lgc_site       nvarchar(10)
        , @n_synm_count     INTEGER       = 0
        , @v_plan_run_flag  nvarchar(10)  = 'SKIP'   
		, @v_scp_plan_id     nvarchar(30)

	DECLARE @v_job_seq int
	DECLARE @v_instance_date	nvarchar(10)
	DECLARE @v_queue_proc_name nvarchar(150)
	DECLARE @v_parameter1	nvarchar(150)
	DECLARE @v_parameter2	nvarchar(150)
	DECLARE @v_parameter3	nvarchar(150)
	DECLARE @v_parameter4	nvarchar(150)
	DECLARE @v_parameter5	nvarchar(150)


  -- ================================================
    -- Declare end
  -- ================================================
  SET @v_instance_id  = @p_instance_id
  SET @v_plan_id    = @p_plan_id
  
  SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

  -- Start 로그는 무조건 남김
  SET @n_log_count = @n_log_count + 1
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', @n_log_count, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate
  
  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null
  
  BEGIN TRY        

		-- ================================================
		-- 로직 추가 start
		-- ================================================    
		
		BEGIN
			
			
			-- 시업시간 가져온다.
			SELECT	@v_instance_date = CONVERT(VARCHAR,DBO.FN_SITE_TIME(SITE_ID) ,112)
			FROM	(
						SELECT	DISTINCT SEGMENT4 AS SITE_ID
						FROM	SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
						WHERE	LOOKUP_TYPE_CODE = 'INSTANCE_INFO'
						AND		SEGMENT1 = @v_instance_id
					) A
			
			SET @v_table_name = 'FP_NETJOB_QUEUE'

			-- JOB_TYPE : R / P / C /E  : READY / PROCEEDING / COMPLETE / ERROR
			SELECT	@v_plan_run_flag = CASE WHEN ISNULL(CNT,0) > 0 THEN 'SKIP' ELSE 'RUN' END 
			FROM	(
						SELECT	COUNT(JOB_TYPE) AS CNT
						FROM	FP_NETJOB_QUEUE  A WITH(NOLOCK)
						WHERE	1=1
						AND		A.INSTANCE_DATE	= @v_instance_date
						AND		A.INSTANCE_ID	= @v_instance_id
						AND		A.ACTIVE_FLAG	= 'Y'
						AND		A.JOB_TYPE		= 'P'
					) A
			WHERE	1=1
    
			SET @n_log_count = @n_log_count + 1
			SET @v_descr = 'QUEUE RUN FLAG : ' + @v_plan_run_flag
			EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, NULL, @v_descr, null

	
			-- 프로시져 수행 여부 check
			IF @v_plan_run_flag = 'RUN'
			BEGIN
				
				SET @v_table_name = 'FP_NETJOB_QUEUE'
				SET @v_job_seq = 0
			
				-- 대기중인 job 중에서 이전 순번 가져온다.
				SELECT	@v_job_seq = MIN(JOB_SEQ)
				FROM	FP_NETJOB_QUEUE A WITH(NOLOCK)
				WHERE	1=1
				AND		A.INSTANCE_DATE	= @v_instance_date
				AND		A.INSTANCE_ID   = @v_instance_id
				AND		A.ACTIVE_FLAG	= 'Y'
				AND		A.JOB_TYPE		= 'R'

				-- 진행
				UPDATE	FP_NETJOB_QUEUE
				SET		JOB_TYPE = 'P'
						, UPDATE_DTTM = GETDATE()
				WHERE	INSTANCE_ID    = @v_instance_id
				AND		JOB_TYPE    = 'R'
				AND		ACTIVE_FLAG	= 'Y'
				AND		JOB_SEQ		= @v_job_seq


				SELECT	 @v_plan_id    = FP_PLAN_ID
						,@v_parameter1 = PARAMETER1 
						,@v_parameter2 = PARAMETER2
						,@v_parameter3 = PARAMETER3
						,@v_parameter4 = PARAMETER4
						,@v_parameter5 = PARAMETER5
				FROM	FP_NETJOB_QUEUE A WITH(NOLOCK)
				WHERE	1=1
				AND		A.INSTANCE_DATE	= @v_instance_date
				AND		A.INSTANCE_ID   = @v_instance_id
				AND		A.JOB_SEQ		= @v_job_seq
				AND		A.ACTIVE_FLAG	= 'Y'


				SET @v_descr = 'FP_PLAN_ID : ' + @v_plan_id +' / JOB_SEQ : ' + CONVERT(NVARCHAR,@v_job_seq)
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, NULL, @v_descr, null 

				IF @v_job_seq > 0 OR  @v_plan_id != '-'   --
				BEGIN

					SET @n_log_count = @n_log_count + 1
					SET @v_descr = @v_instance_id + ' PR_SCM_DEMAND_PEGGING_ Start'
					EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_descr, null
          
					EXEC(@v_instance_id+'_SY_PR_SCM_OF_DEMAND_ORDER_TRACKING '''+@v_instance_id+''','''+@v_plan_id+'''')

					SET @n_log_count = @n_log_count + 1
					SET @v_descr = @v_instance_id + ' PR_SCM_DEMAND_PEGGING End'
					EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_descr, null
		
	          
					UPDATE	FP_NETJOB_QUEUE
					SET		JOB_TYPE = 'C'
							, UPDATE_DTTM = GETDATE()
					WHERE	1=1
					AND		INSTANCE_ID	= @v_instance_id
					AND		JOB_SEQ		= @v_job_seq

					--END
				--ELSE 
			
				--	UPDATE	FP_NETJOB_QUEUE
				--	SET		JOB_TYPE = 'E'
				--			, UPDATE_DTTM = GETDATE()
				--	WHERE	INSTANCE_ID = @v_instance_id
				--	AND		JOB_TYPE	= 'R'
				--	AND		ACTIVE_FLAG	= 'Y'
				--	AND		JOB_SEQ		= @v_job_seq

				END -- @v_job_seq <= 0 OR  @v_plan_id = ''

			END -- @v_plan_run_flag = 'RUN'

		END
     -- ================================================
    -- 로직 추가 end
    -- ================================================
   

  END TRY

  BEGIN CATCH

       UPDATE	FP_NETJOB_QUEUE
		SET		JOB_TYPE = 'E'
				, UPDATE_DTTM = GETDATE()
		WHERE	INSTANCE_ID    = @v_instance_id
		AND		JOB_TYPE    = 'R'
		AND		ACTIVE_FLAG	= 'Y'
		AND		JOB_SEQ		= @v_job_seq

    -- 에러나도 로그는 인서트
    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()
    EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
    
    EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr

      IF @@TRANCOUNT > 0
         COMMIT WORK 
  END CATCH
  
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   999999, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
  
  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
