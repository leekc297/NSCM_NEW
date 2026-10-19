


/*
 * Program ID   : [SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM]
 * Description  : SSP ERP 에러 반환시 정보 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024/04/15   jilee		   SSP ERP 에러 반환시 정보 저장
 */
CREATE PROCEDURE [dbo].[SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM]
     @p_change_request_no   NVARCHAR(MAX)
	,@p_confirm_id          NVARCHAR(MAX)
	,@p_e_type              NVARCHAR(MAX)
	,@p_e_message           NVARCHAR(MAX)
	,@p_last_updated_by		NVARCHAR(150)
AS

BEGIN

	SET NOCOUNT ON;
	
	DECLARE @v_confirm_id          NVARCHAR(MAX);
	DECLARE @v_e_type              NVARCHAR(MAX);
	DECLARE @v_e_message           NVARCHAR(MAX);
	DECLARE @v_request_no          NVARCHAR(MAX);

	SET @v_confirm_id          = NULL;
	SET @v_e_type    		   = NULL;
	SET @v_e_message   		   = NULL;
	SET @v_request_no  		   = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	DECLARE @v_data_dup_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	DECLARE @v_infseqno	nvarchar(14);
	DECLARE @v_erp_error_chk	INTEGER = 0;
	DECLARE @v_erp_normal_chk	INTEGER = 0;
	DECLARE @v_status	        NVARCHAR(10) = '';

	-- 트렌젝션 시작
	--BEGIN TRAN;

	BEGIN TRY
		
		SET @d_event_date	= GETDATE();

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--PRINT '2';
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_confirm_id, @v_delimiter);    

		SELECT @v_infseqno = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '000000'+ CONVERT(nvarchar,NEXT VALUE FOR DBO.SEQ1_SSP_ANL_SHIP_ERP_ERROR_CONFIRM) ,6);
		
		WHILE LEN(@p_confirm_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
				
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN			
				SET @v_confirm_id        = dbo.SCM_ARR_SPL_VAL(@p_confirm_id        , @v_delimiter, @mst_loop_cnt );
				--SET @v_e_type            = dbo.SCM_ARR_SPL_VAL(@p_e_type            , @v_delimiter, @mst_loop_cnt );
				SET @v_e_message         = dbo.SCM_ARR_SPL_VAL(@p_e_message         , @v_delimiter, @mst_loop_cnt );
				SET @v_request_no        = dbo.SCM_ARR_SPL_VAL(@p_change_request_no , @v_delimiter, @mst_loop_cnt );
			END;

			--데이터 저장
			IF @mst_loop_cnt > 0 			
			BEGIN		
				--Insert
				Insert Into SSP_ANL_SHIP_ERP_ERROR_CONFIRM
				(
					IFSEQNO,			    CONFIRM_ID,				E_TYPE,				        E_MESSAGE,
					CREATED_BY,				CREATION_DATE,          LAST_UPDATED_BY,		    LAST_UPDATE_DATE,
					ATTRIBUTE1
					
				)
				VALUES
				(
					@v_infseqno,			@v_confirm_id,			@p_e_type,			        @v_e_message,
					@p_last_updated_by,		@d_event_date,			@p_last_updated_by,		    @d_event_date,
					@v_request_no
				);

				IF LEN(@v_e_message) > 0
				BEGIN
					UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
					SET REJECT_REASON = @v_e_message
					WHERE CHANGE_REQ_NO = @v_request_no;
				END				
				
				UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE 
				SET ATTRIBUTE2 = @p_e_type
				,ATTRIBUTE3 = @v_e_message
                WHERE CHANGE_REQ_NO = @v_request_no
				AND CONFIRM_ID = @v_confirm_id;

				-- ERP Reject 포함한 경우 부분 승인 업데이트 -------------------------------------------------------				
				SELECT @v_erp_error_chk = COUNT(*) FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WITH(NOLOCK) 
				WHERE CHANGE_REQ_NO = @v_request_no
				AND ATTRIBUTE2 = 'E'

				SELECT @v_erp_normal_chk = COUNT(*) FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WITH(NOLOCK) 
				WHERE CHANGE_REQ_NO = @v_request_no				

				IF @v_erp_error_chk > 0
					BEGIN
						IF @v_erp_error_chk = @v_erp_normal_chk 
							BEGIN
								SET @v_status = 'E';
							END
						ELSE
							BEGIN
								SET @v_status = 'P';
							END
													
						UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
						SET CHANGE_REQ_STATUS = ISNULL(@v_status,'A')	
						WHERE CHANGE_REQ_NO = @v_request_no;
					END				
				-----------------------------------------------------------------------------------------------------
			END;
		END

		

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



