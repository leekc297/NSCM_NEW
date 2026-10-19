
/*
 * Program ID   : [SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET]
 * Description  : 장기진부화 재고 MEMO 수정본 저장(Type Table 저장방식)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/11/26   KMJ			    [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - initial release
 */
CREATE PROCEDURE [dbo].[SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET]
	 @SCP0084_MEMO			AS DBO.SCP0084_MEMO       READONLY
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	-- 트렌젝션 시작
	BEGIN TRAN;

    -- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';    

	-- UPDATE 시간 확인
	DECLARE @v_update_date		NVARCHAR(8) = '';
	DECLARE @v_update_time		NVARCHAR(6) = '';

	-- YYYYMM 확인
	DECLARE @v_yyyymm		NVARCHAR(6) = '';

	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- UPDATE INFO
		SELECT
			@v_update_date = CONVERT(VARCHAR(8), GETDATE(), 112)
			, @v_update_time = REPLACE(CONVERT(VARCHAR(8), GETDATE(), 114), ':', '')
			--, @v_yyyymm = REPLACE(REPLACE((SELECT TOP 1 YYYYMM FROM @SCP0084_MEMO), '‘', ''), '.', '')
		;

		--수정
		UPDATE A SET

			A.MEMO = N''+B.MEMO+''
			, A.UPDATE_DATE = @v_update_date
			, A.UPDATE_TIME = @v_update_time
			, A.UPDATE_USER_ID = B.USER_ID

		FROM SCP_ANL_LONG_TERM_STOCK A, @SCP0084_MEMO B
		WHERE A.YYYYMM			= B.YYYYMM
		AND A.PLANT_ID			= B.PLANT_ID
		AND A.DIVISION_ID		= B.DIVISION_ID
		AND A.ITEM_ID			= B.ITEM_ID
		AND A.CHARG				= B.CHARG
		AND A.DEVALUATION_AGE	= B.DEVALUATION_AGE
		;

		
		-- 임시 운영반영시에 주석처리 할것.    
		SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
							 REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))    

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
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				     
			; 
		END;
	END CATCH;
END




