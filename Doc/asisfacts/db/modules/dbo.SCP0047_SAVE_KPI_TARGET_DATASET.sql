





/*
 * Program ID   : SCP0047_SAVE_KPI_TARGET_DATASET
 * Description  : KPI Target 일괄저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/12/20	YHW				Initial Release [] 전지 GSCM(SCP) 운영
 */
CREATE PROCEDURE [dbo].[SCP0047_SAVE_KPI_TARGET_DATASET]
	 @SCP0047			AS DBO.SCP0047       READONLY
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @v_creation_date    datetime =SYSDATETIME(); 
	DECLARE @v_last_updated_by  NVARCHAR(MAX)='hwwoonins';
	
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0047_SAVE_KPI_TARGET_DATASET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	DECLARE @v_data_dup_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	-- 트렌젝션 시작
	BEGIN TRAN;


          -- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';    


	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamic_SCP0047_SET') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0047_SET
	;

	CREATE TABLE #TblDynamic_SCP0047_SET (
		p_active_flag			nvarchar(1),
		p_kpi_id				nvarchar(100),
		p_division_id			nvarchar(30),
		p_dept_id				nvarchar(50),
		p_yyyymm				nvarchar(6),
		p_kpi_target			nvarchar(200),
		p_user_id				nvarchar(150)
	);

	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		INSERT INTO #TblDynamic_SCP0047_SET
		SELECT p_active_flag,
				p_kpi_id,
				p_division_id,
				p_dept_id,
				p_yyyymm,
				p_kpi_target,
				p_user_id
		FROM @SCP0047
		;


		-- 수정 저장
		UPDATE A
		SET A.KPI_TARGET = B.p_kpi_target
			, a.LAST_UPDATE_DATE = @v_creation_date
			, a.LAST_UPDATED_BY = B.p_user_id
		FROM SCM_KPI_TARGET A, @SCP0047 B
		WHERE A.KPI_ID          = B.p_kpi_id          
		AND A.DIVISION_ID		= B.p_division_id
		AND A.DEPT_ID           = B.p_dept_id
		AND A.YYYYMM            = B.p_yyyymm
		AND B.p_active_flag		= 'M'
		AND EXISTS(
					SELECT 'X' FROM SCM_KPI_TARGET C
					WHERE C.KPI_ID          = B.p_kpi_id          
						AND C.DIVISION_ID		= B.p_division_id
						AND C.DEPT_ID           = B.p_dept_id
						AND C.YYYYMM            = B.p_yyyymm
						AND B.p_active_flag		= 'M'
		          )
		;

		-- 신규저장
		INSERT INTO SCM_KPI_TARGET
		(KPI_ID, DIVISION_ID, DEPT_ID, YYYYMM, KPI_TARGET, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1)
		SELECT B.p_kpi_id
				, B.p_division_id
				, B.p_dept_id
				, B.p_yyyymm
				, B.p_kpi_target
				, B.p_user_id
				, @v_creation_date
				, B.p_user_id
				, @v_creation_date
				, B.p_active_flag
		FROM @SCP0047 B
		WHERE 1=1
		AND B.p_active_flag		= 'M'
		AND NOT EXISTS(
					SELECT 'X' FROM SCM_KPI_TARGET C
					WHERE C.KPI_ID          = B.p_kpi_id          
						AND C.DIVISION_ID		= B.p_division_id
						AND C.DEPT_ID           = B.p_dept_id
						AND C.YYYYMM            = B.p_yyyymm
						AND B.p_active_flag		= 'M'
		          )
		;


		--이력저장(수정건)
		INSERT	INTO  SCM_KPI_TARGET_H(									   
					HISTORY_SEQ
					, KPI_ID
					, DIVISION_ID
					, DEPT_ID
					, YYYYMM
					, KPI_TARGET
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
					, ATTRIBUTE1
					, HISTORY_CREATION_DATE)
		SELECT (NEXT VALUE FOR SEQ1_SCM_KPI_TARGET_H)
					, p_kpi_id
					, p_division_id
					, p_dept_id
					, p_yyyymm
					, p_kpi_target
					, p_user_id
					, @v_creation_date
					, p_user_id
					, @v_creation_date
					, p_active_flag
					, @v_creation_date
		FROM @SCP0047
		WHERE p_active_flag = 'M'
		;

		--이력저장(삭제건)
		INSERT	INTO  SCM_KPI_TARGET_H(									   
					HISTORY_SEQ
					, KPI_ID
					, DIVISION_ID
					, DEPT_ID
					, YYYYMM
					, KPI_TARGET
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
					, ATTRIBUTE1
					, HISTORY_CREATION_DATE)
		SELECT (NEXT VALUE FOR SEQ1_SCM_KPI_TARGET_H) AS history_seq
					, B.p_kpi_id
					, B.p_division_id
					, B.p_dept_id
					, B.p_yyyymm
					, A.KPI_TARGET
					, B.p_user_id
					, @v_creation_date
					, B.p_user_id
					, @v_creation_date
					, B.p_active_flag
					, @v_creation_date
		FROM @SCP0047 B, SCM_KPI_TARGET A
		WHERE A.KPI_ID=B.p_kpi_id
		AND A.DIVISION_ID=B.p_division_id
		AND A.DEPT_ID=B.p_dept_id
		AND A.YYYYMM=B.p_yyyymm
		AND B.p_active_flag = 'D'
		;
		

		-- 삭제
		DELETE FROM A
		FROM SCM_KPI_TARGET A, @SCP0047 B
		WHERE A.KPI_ID          = B.p_kpi_id          
		AND A.DIVISION_ID		= B.p_division_id
		AND A.DEPT_ID           = B.p_dept_id
		AND A.YYYYMM            = B.p_yyyymm
		AND B.p_active_flag		= 'D'
		;

		-- 임시 운영반영시에 주석처리 할것.    
		SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
							 REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))    

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description  = N'[' + @v_exec_time + ']';   
		SET @d_event_date = SYSDATETIME();
		
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;			
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  1 AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			--if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
					  

			-- error코드, errror 메시지 반환
			--SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT 'F' AS result_code
				   ,@v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				     
			; 
		END;
	END CATCH;
END






