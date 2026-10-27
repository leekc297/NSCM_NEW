

/*
- 테이블 입력 : FP_NETJOB_QUEUE
- 참조 프로시저 : PR_SCM_NETJOB_RUN_CN_CELL

*/

CREATE PROCEDURE [dbo].[PR_SCM_OF_PACK_TO_CELL_AUTO]
  @p_site_id nvarchar(MAX) = '-'

WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_PACK_TO_CELL_AUTO                                               **/
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
/** 2021.10.22    LJS          최초 작성                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_OF_PACK_TO_CELL_AUTO
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  --DECLARE @v_plan_date      nvarchar(30)
  DECLARE @v_release_id     nvarchar(50)
  DECLARE @v_unit_id        nvarchar(50)
  --DECLARE @v_factory_id     nvarchar(50)
  --DECLARE @v_plan_group_id  nvarchar(50)
  
  --DECLARE @v_division_id    nvarchar(50)
  --DECLARE @v_site_id        nvarchar(50)
  DECLARE @v_description    nvarchar(50)
  DECLARE @v_user_id        nvarchar(50)
  DECLARE @v_release_plan_id nvarchar(50)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_OF_PACK_TO_CELL_AUTO'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)

  DECLARE @n_order_seq      Integer  = 0
        , @v_amend_type     nvarchar(30)      -- amend 유형 정보
        , @v_confirm_area   nvarchar(30)      -- factory, plan group 
		, @v_instance_type  nvarchar(30)
		, @v_rowCount       Integer  = 0
        
  DECLARE @v_run_master_id      nvarchar(30)
        , @v_run_event_time     datetime
        
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @v_insert_dttm    date

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  -- try-catch 용 변수
  DECLARE @v_catch_count    Integer  = 0
  DECLARE @v_catch_mesTrans nvarchar(30)
  DECLARE @v_catch_release  nvarchar(30)

  DECLARE @v_plan_run_flag  nvarchar(10)  = 'SKIP'

  DECLARE @v_job_seq int
  
  -------------------------------------------------------------------------------------------
  --SET @v_site_id   = @p_site_id
  SET @v_master_id = '-'
  SET @v_plan_id   = '-'

  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

  -- 배포 프로세스 시작
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  SET @v_descr = '############### Start of procedure ###############'
  SET @v_proc_name = 'PR_SCM_OF_PACK_TO_CELL_AUTO'

  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, @v_descr, null

  EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', @n_log_count, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

  BEGIN TRY

	-- * 진행중인 프로세스가 있으면 skip, 없으면 진행
	-- JOB_TYPE : R / P / C /E  : READY / PROCEEDING / COMPLETE / ERROR
	SELECT	@v_plan_run_flag = CASE WHEN ISNULL(CNT,0) > 0 THEN 'SKIP' ELSE 'RUN' END
	FROM	(
			SELECT COUNT(JOB_TYPE) AS CNT
			FROM   FP_NETJOB_QUEUE A WITH(NOLOCK)
			WHERE  1=1
			AND    A.PROC_NAME     = @v_proc_name
			AND	   A.ACTIVE_FLAG   = 'Y'
			AND	   A.JOB_TYPE      = 'P'
  	) A
	WHERE	1=1
     
	SET @n_log_count = @n_log_count + 1
	SET @v_descr = 'QUEUE RUN FLAG : ' + @v_plan_run_flag
	EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, 'FP_NETJOB_QUEUE', 'SELECT', @n_log_count, NULL, @v_descr, null


    -- 필수 DATA 쿼리
	-- 프로시져 수행 여부 check
	IF @v_plan_run_flag = 'RUN'
    BEGIN
	  
	  SET @v_table_name = 'FP_NETJOB_QUEUE'
	  SET @v_job_seq = 0
	  
	  -- 대기중인 job 중에서 이전 순번 가져온다.
	  SELECT @v_job_seq = MIN(JOB_SEQ)
	  FROM	 FP_NETJOB_QUEUE A WITH(NOLOCK)
	  WHERE	 1=1
	  AND    A.PROC_NAME     = @v_proc_name
	  AND	 A.ACTIVE_FLAG	 = 'Y'
	  AND	 A.JOB_TYPE		 = 'R'
	  

	  -- 진행
	  UPDATE FP_NETJOB_QUEUE
	  SET	 JOB_TYPE      = 'P'
	  	   , UPDATE_DTTM   = GETDATE()
	  WHERE	 1=1
	  AND    PROC_NAME     = @v_proc_name
	  AND	 ACTIVE_FLAG   = 'Y'
	  AND	 JOB_TYPE      = 'R'
	  AND	 JOB_SEQ	   = @v_job_seq
	  
	  
	  SELECT  @v_master_id    = INSTANCE_ID
	        , @v_plan_id      = FP_PLAN_ID
	  		--, @v_description  = A.ATTRIBUTE1
	  		, @v_user_id      = A.ATTRIBUTE2
	  FROM	  FP_NETJOB_QUEUE A WITH(NOLOCK)
	  WHERE	  1=1
	  AND     A.PROC_NAME     = @v_proc_name
	  AND	  A.ACTIVE_FLAG	  = 'Y'
	  AND	  A.JOB_SEQ		  = @v_job_seq
	  

	  SET @v_descr = 'INSTANCE_ID : ' + @v_master_id
	               + ' / FP_PLAN_ID : ' + @v_plan_id
				   + ' / USER_ID : ' + @v_user_id
				   + ' / JOB_SEQ : ' + CONVERT(NVARCHAR,@v_job_seq)
	  
	  SET @n_log_count = @n_log_count + 1
	  SET @sysdate = GETDATE()
	  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, NULL, @v_descr, null


	  IF @v_job_seq > 0 OR  @v_plan_id != '-' 
	  BEGIN

			----------------------------------- 13. pack 한정 실행 시작 -----------------------------------
			IF CHARINDEX('PACK', @v_master_id) > 0
			BEGIN
				EXEC PR_SCM_OF_PACK_REQUIRE_CEL @v_master_id, '', 'Y', '', '', 'N', @v_user_id, NULL

				EXEC PR_SCM_OF_PACK_TO_CELL @v_master_id , @v_plan_id

				--LOG 생성
				SET @v_message = ''
				SET @n_log_count = @n_log_count + 1
				EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, 'PR_SCM_OF_PACK_TO_CELL', @v_table_name, 'CALL', @n_log_count, @v_log_code, @v_message, null

			END

			----------------------------------- 13. pack 한정 실행 종료 -----------------------------------

			UPDATE FP_NETJOB_QUEUE
			SET	   JOB_TYPE       = 'C'
			     , UPDATE_DTTM    = GETDATE()
			WHERE  1=1
			AND    PROC_NAME      = @v_proc_name
			AND	   ACTIVE_FLAG    = 'Y'
			AND	   JOB_SEQ	      = @v_job_seq

			--LOG 생성
			SET @n_log_count = @n_log_count + 1
			SET @v_descr = 'UPDATE JOB_TYPE = C'
			EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, 'FP_NETJOB_QUEUE', 'UPDATE', @n_log_count, NULL, @v_descr, null


		END -- @v_job_seq > 0 OR  @v_plan_id != '-' 

    END -- @v_plan_run_flag = 'RUN'

  END TRY

  BEGIN CATCH
    -- ROLLBACK 처리

	-- 1. netjob 에러 처리
	UPDATE FP_NETJOB_QUEUE
	SET	   JOB_TYPE       = 'E'
		 , UPDATE_DTTM    = GETDATE()
	WHERE  1=1
	AND    PROC_NAME      = @v_proc_name
	AND	   ACTIVE_FLAG    = 'Y'
	AND	   JOB_SEQ	      = @v_job_seq


    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    
	commit;

  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

  EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   999999, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

END


