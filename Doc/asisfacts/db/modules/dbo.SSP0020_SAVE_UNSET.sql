


/*
 * Program ID   : [SSP0020_SAVE_UNSET]
 * Description  : Delegate 설정해제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/07/09   mcTheJ		   [CSR ID:4044806] Model PIC 담당자 위임 기능 추가	
 * 2019/08/14   mcTheJ		   Delegator, Delegatee 변경
 */
CREATE PROCEDURE [dbo].[SSP0020_SAVE_UNSET]
	 @p_division_id          NVARCHAR(MAX)
	,@p_from_date            NVARCHAR(MAX)
	,@p_to_date				 NVARCHAR(MAX)
	,@p_sheet_name	         NVARCHAR(MAX)
	,@p_delegate	         NVARCHAR(MAX)
	,@p_last_update_by		 NVARCHAR(MAX)
	,@p_last_update_date	 NVARCHAR(MAX)
	,@p_user_id              NVARCHAR(MAX)
	,@p_language			 NVARCHAR(MAX) = 'KO'
AS

BEGIN

	SET NOCOUNT ON;
	
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_from_date			NVARCHAR(MAX);
	DECLARE @v_to_date				NVARCHAR(MAX);
	DECLARE @v_delegate				NVARCHAR(MAX);
	DECLARE @v_last_update_by		NVARCHAR(MAX);
	DECLARE @v_last_update_date		NVARCHAR(MAX);

	SET @v_division_id			= NULL;
	SET @v_from_date	        = NULL;
	SET @v_to_date				= NULL;
	SET @v_delegate				= NULL;
	SET @v_last_update_by       = NULL;
	SET @v_last_update_date     = NULL;
	
	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0020_SAVE_UNSET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_mail_divisionid	NVARCHAR(MAX);

	DECLARE @v_data_dup_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	-- 트렌젝션 시작
	--BEGIN TRAN;

	BEGIN TRY

		--PRINT '1';
		SET @d_event_date	= GETDATE();
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--PRINT '2';
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_division_id, @v_delimiter);    

		WHILE LEN(@p_division_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
				
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN			
				SET @v_division_id			= dbo.SCM_ARR_SPL_VAL(@p_division_id        , @v_delimiter, @mst_loop_cnt );
				
			END;

			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		
					IF @p_sheet_name = 'Delegate'
					BEGIN
						UPDATE	SSP_MST_DELEGATE
						SET VALID_YN = 'N'
							, LAST_UPDATED_BY = @p_user_id
							, LAST_UPDATE_DATE = @d_event_date
						WHERE 1 = 1
						AND DIVISION_ID = @v_division_id
						AND FROM_DATE = @p_from_date
						AND TO_DATE = @p_to_date
						AND DELEGATEE_ID = @p_delegate
						AND LAST_UPDATED_BY = @p_last_update_by;
					END
					ELSE
					BEGIN
						UPDATE	SSP_MST_DELEGATE
						SET VALID_YN = 'N'
							, LAST_UPDATED_BY = @p_user_id
							, LAST_UPDATE_DATE = @d_event_date
						WHERE 1 = 1
						AND DIVISION_ID = @v_division_id
						AND FROM_DATE = @p_from_date
						AND TO_DATE = @p_to_date
						AND DELEGATEE_ID = @p_user_id
						AND LAST_UPDATED_BY = @p_last_update_by;
					END

				END;
			
		END;
		SET @v_mail_divisionid = replace(@p_division_id, @v_delimiter, ', ');
		--MAIL SEND
		-- 개발이라서 메일전송 소스 막아둠
		--EXEC PR_SSP_MAIL_SEND_DELEGATE 'U',  @v_mail_divisionid,  @p_user_id, @p_delegate, @p_from_date, @p_to_date, @p_language, 'Y';

		-- 결과코드 리턴
		SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	END TRY

	BEGIN CATCH 
		BEGIN
			--if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
					  

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;

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



