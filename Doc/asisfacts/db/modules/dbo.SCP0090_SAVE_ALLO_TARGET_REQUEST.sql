/*
 * Program ID   : [SCP0090_SAVE_ALLO_TARGET_REQUEST]
 * Description  : ALLO_TARGET_REQUEST Request 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/12/30   LWY   Initial Release PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
 * 2022/07/28   LWY   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Allo_Target_Request 개선
 * 2022/09/28   LWY   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Allo_Target_Request 설계변경으로 개발
 */

CREATE PROCEDURE [dbo].[SCP0090_SAVE_ALLO_TARGET_REQUEST]
     
	 @p_active_flag		NVARCHAR(MAX)
	,@p_division		NVARCHAR(MAX)
	,@p_seq				NVARCHAR(MAX)
	,@p_cutoff_yyyymmdd	NVARCHAR(MAX)
	,@p_from_item_id	NVARCHAR(MAX)
	,@p_from_dept_id	NVARCHAR(MAX)
	,@p_from_dept_name	NVARCHAR(MAX)
	,@p_from_yyyymm		NVARCHAR(MAX)
	,@p_from_qty		NVARCHAR(MAX)
	,@p_to_item_id		NVARCHAR(MAX)
	,@p_to_dept_id		NVARCHAR(MAX)
	,@p_to_dept_name	NVARCHAR(MAX)
	,@p_to_yyyymm		NVARCHAR(MAX)
	,@p_to_qty			NVARCHAR(MAX)
	,@p_to_qty_tobe		NVARCHAR(MAX)
	,@p_comments		NVARCHAR(MAX)
	,@p_confirm			NVARCHAR(MAX)
	,@p_confirm_comments	NVARCHAR(MAX)
	,@p_request_user	NVARCHAR(MAX)
	,@p_request_date	NVARCHAR(MAX)
	,@p_confirm_user	NVARCHAR(MAX)
	,@p_confirm_date	NVARCHAR(MAX)
	,@p_program_id      NVARCHAR(200) ='SCP0090'
	,@debug_mode        NVARCHAR(1) ='F'
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag	  NVARCHAR(010);
	DECLARE @v_seq			  NVARCHAR(MAX);
	DECLARE @v_cutoff_yyyymmd NVARCHAR(8);
	DECLARE @v_from_item_id	  NVARCHAR(200);
	DECLARE @v_from_dept_id	  NVARCHAR(100);	
	DECLARE @v_from_dept_name NVARCHAR(100);
	DECLARE @v_from_yyyymm	  NVARCHAR(6);
	DECLARE @v_from_qty		  NVARCHAR(500);
	DECLARE @v_to_item_id	  NVARCHAR(200);
	DECLARE @v_to_dept_id	  NVARCHAR(100);
	DECLARE @v_to_dept_name	  NVARCHAR(100);
	DECLARE @v_to_yyyymm	  NVARCHAR(6);
	DECLARE @v_to_qty		  NVARCHAR(500);
	DECLARE @v_to_qty_tobe	  NVARCHAR(500);
	DECLARE @v_comments		  NVARCHAR(500);
	DECLARE @v_confirm		  NVARCHAR(1);
	DECLARE @v_confirm_comments		  NVARCHAR(MAX);
	DECLARE @v_request_user	  NVARCHAR(50);
	DECLARE @v_request_date	  NVARCHAR(100);
	DECLARE @v_confirm_user	  NVARCHAR(50);
	DECLARE @v_confirm_date	  NVARCHAR(100);
	DECLARE @v_program_id	  NVARCHAR(50);
	DECLARE @v_ebug_mode	  NVARCHAR(1);

	SET @v_active_flag	   = NULL;
	SET @v_seq			   = NULL;
	SET @v_cutoff_yyyymmd  = NULL;
	SET @v_from_item_id	   = NULL;
	SET @v_from_dept_id	   = NULL;
	SET @v_from_dept_name  = NULL;
	SET @v_from_yyyymm	   = NULL;
	SET @v_from_qty		   = NULL;
	SET @v_to_item_id	   = NULL;
	SET @v_to_dept_id	   = NULL;
	SET @v_to_dept_name	   = NULL;
	SET @v_to_yyyymm	   = NULL;
	SET @v_to_qty		   = NULL;
	SET @v_to_qty_tobe	   = NULL;
	SET @v_comments		   = NULL;
	SET @v_confirm		   = NULL;
	SET @v_confirm_comments = NULL;
	SET @v_request_user	   = NULL;
	SET @v_request_date	   = NULL;
	SET @v_confirm_user	   = NULL;
	SET @v_confirm_date	   = NULL;
	SET @v_program_id	   = NULL;	
	SET @v_ebug_mode	   = NULL;


	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0;
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SCP0090_SAVE_ALLO_TARGET_REQUEST]';
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

	BEGIN TRY

			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--PRINT '2';
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN

			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			--IF(@p_from_dept_name IS NULL OR @p_from_dept_name ='')
			--BEGIN
			--	SET @p_from_dept_name = DBO.FN_GET_TEAM_NAME(@p_division,'',@p_request_user,'','',@p_from_dept_id,'');
			--END
			
			--IF(@p_to_dept_name IS NULL OR @p_to_dept_name ='')
			--BEGIN
			--	SET @p_to_dept_name = DBO.FN_GET_TEAM_NAME(@p_division,'',@p_request_user,'','',@p_to_dept_id,'');
			--END

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag	   = dbo.SCM_ARR_SPL_VAL( @p_active_flag		   	, @v_delimiter, @mst_loop_cnt );
				SET @v_seq			   = dbo.SCM_ARR_SPL_VAL( @p_seq			 	    , @v_delimiter, @mst_loop_cnt );
				SET @v_cutoff_yyyymmd  = dbo.SCM_ARR_SPL_VAL( @p_cutoff_yyyymmdd 	    , @v_delimiter, @mst_loop_cnt );
				SET @v_from_item_id	   = dbo.SCM_ARR_SPL_VAL( @p_from_item_id	 	    , @v_delimiter, @mst_loop_cnt );
				SET @v_from_dept_id	   = dbo.SCM_ARR_SPL_VAL( @p_from_dept_id	 	    , @v_delimiter, @mst_loop_cnt );				
				SET @v_from_dept_name  = dbo.SCM_ARR_SPL_VAL( @p_from_dept_id	 	    , @v_delimiter, @mst_loop_cnt );
				SET @v_from_yyyymm	   = dbo.SCM_ARR_SPL_VAL( @p_from_yyyymm		    , @v_delimiter, @mst_loop_cnt );
				SET @v_from_qty		   = dbo.SCM_ARR_SPL_VAL( @p_from_qty		 	    , @v_delimiter, @mst_loop_cnt );				
				SET @v_to_item_id	   = dbo.SCM_ARR_SPL_VAL( @p_to_item_id		 	    , @v_delimiter, @mst_loop_cnt );
				SET @v_to_dept_id	   = dbo.SCM_ARR_SPL_VAL( @p_to_dept_id		 	    , @v_delimiter, @mst_loop_cnt );				
				SET @v_to_dept_name	   = dbo.SCM_ARR_SPL_VAL( @p_to_dept_id		 	    , @v_delimiter, @mst_loop_cnt );				
				SET @v_to_yyyymm	   = dbo.SCM_ARR_SPL_VAL( @p_to_yyyymm		 	    , @v_delimiter, @mst_loop_cnt );
				SET @v_to_qty		   = dbo.SCM_ARR_SPL_VAL( @p_to_qty			 	    , @v_delimiter, @mst_loop_cnt );
				SET @v_to_qty_tobe	   = dbo.SCM_ARR_SPL_VAL( @p_to_qty_tobe		    , @v_delimiter, @mst_loop_cnt );
				SET @v_comments		   = dbo.SCM_ARR_SPL_VAL( @p_comments	 	        , @v_delimiter, @mst_loop_cnt );
				SET @v_confirm		   = dbo.SCM_ARR_SPL_VAL( @p_confirm	 			, @v_delimiter, @mst_loop_cnt );				
				SET @v_confirm_comments	= dbo.SCM_ARR_SPL_VAL( @p_confirm_comments	 	, @v_delimiter, @mst_loop_cnt );

				SET @v_request_user	   = dbo.SCM_ARR_SPL_VAL( @p_request_user	  	    , @v_delimiter, @mst_loop_cnt );
				SET @v_request_date	   = dbo.SCM_ARR_SPL_VAL( @p_request_date	      	, @v_delimiter, @mst_loop_cnt );
				SET @v_confirm_user	   = dbo.SCM_ARR_SPL_VAL( @p_confirm_user     	    , @v_delimiter, @mst_loop_cnt );
				SET @v_confirm_date	   = dbo.SCM_ARR_SPL_VAL( @p_confirm_date       	, @v_delimiter, @mst_loop_cnt );
				SET @v_program_id	   = dbo.SCM_ARR_SPL_VAL( @p_program_id  			, @v_delimiter, @mst_loop_cnt );
				SET @v_ebug_mode	   = dbo.SCM_ARR_SPL_VAL( @debug_mode      			, @v_delimiter, @mst_loop_cnt );

			END;

			-- LOOP 파라미터 출력 DEBUG용
			IF (@debug_mode ='T')
			BEGIN
				PRINT '===============================================';
				PRINT '@v_active_flag	  = ' + ISNULL(@v_active_flag	 ,'');
				PRINT '@v_cutoff_yyyymmd  = ' + ISNULL(@v_cutoff_yyyymmd ,'');
				PRINT '@v_from_item_id	  = ' + ISNULL(@v_from_item_id	 ,'');
				PRINT '@v_from_dept_id	  = ' + ISNULL(@v_from_dept_id	 ,'');
				PRINT '@v_from_dept_name  = ' + ISNULL(@v_from_dept_name ,'');
				PRINT '@v_from_yyyymm	  = ' + ISNULL(@v_from_yyyymm	 ,'');
				PRINT '@v_from_qty		  = ' + ISNULL(@v_from_qty		 ,'');
				PRINT '@v_to_item_id	  = ' + ISNULL(@v_to_item_id	 ,'');
				PRINT '@v_to_dept_id	  = ' + ISNULL(@v_to_dept_id	 ,'');
				PRINT '@v_to_dept_name	  = ' + ISNULL(@v_to_dept_name	 ,'');
				PRINT '@v_to_yyyymm	      = ' + ISNULL(@v_to_yyyymm	     ,'');
				PRINT '@v_to_qty		  = ' + ISNULL(@v_to_qty		 ,'');
				PRINT '@v_comments		  = ' + ISNULL(@v_comments		 ,'');
				PRINT '@v_confirm		  = ' + ISNULL(@v_confirm		 ,'');
				PRINT '@v_request_user	  = ' + ISNULL(@v_request_user	 ,'');
				PRINT '@v_request_date	  = ' + ISNULL(@v_request_date	 ,'');
				PRINT '@v_confirm_user	  = ' + ISNULL(@v_confirm_user	 ,'');
				PRINT '@v_confirm_date	  = ' + ISNULL(@v_confirm_date	 ,'');
				PRINT '@v_program_id	  = ' + ISNULL(@v_program_id	 ,'');
				PRINT '@v_ebug_mode	      = ' + ISNULL(@v_ebug_mode	     ,'');

			END;


			--데이터 저장
			IF @mst_loop_cnt > 0
				BEGIN
					-- 수정
					IF( @v_active_flag ='M' OR @v_active_flag ='I')
						BEGIN
							PRINT 'MERGE START  . '+CONVERT(CHAR(23), GETDATE(), 21);

							MERGE INTO SCP_ANL_ALLO_TARGET_REQUEST A
							USING (
									SELECT
											 @v_seq             AS SEQ
											,@v_cutoff_yyyymmd  AS CUTOFF_YYYYMMD
											,@v_from_item_id	AS FROM_ITEM_ID
											,@v_from_dept_id	AS FROM_DEPT_ID
											,@v_from_dept_name  AS FROM_DEPT_NAME
											,@v_from_yyyymm		AS FROM_YYYYMM
											,@v_from_qty		AS FROM_QTY
											,@v_to_item_id		AS TO_ITEM_ID
											,@v_to_dept_id		AS TO_DEPT_ID
											,@v_to_dept_name	AS TO_DEPT_NAME
											,@v_to_yyyymm	    AS TO_YYYYMM
											,@v_to_qty			AS TO_QTY
											,@v_to_qty_tobe		AS TO_QTY_TOBE
											,@v_comments		AS COMMENTS
											,@v_confirm			AS CONFIRM
											,@v_confirm_comments AS CONFIRM_COMMENTS
											,@v_request_user	AS REQUEST_USER
											,@v_request_date	AS REQUEST_DATE
											,@v_confirm_user	AS CONFIRM_USER
											,@v_confirm_date	AS CONFIRM_DATE

									) B
							ON(
										    A.SEQ               = B.SEQ

								)
							WHEN MATCHED THEN
									UPDATE
									   SET CUTOFF_YYYYMMDD	= @v_cutoff_yyyymmd
										  ,FROM_ITEM_ID		= @v_from_item_id
										  ,FROM_DEPT_ID		= @v_from_dept_id
										  ,FROM_DEPT_NAME	= @v_from_dept_name
										  ,FROM_YYYYMM		= @v_from_yyyymm
										  ,FROM_QTY			= @v_from_qty
										  ,TO_ITEM_ID		= @v_to_item_id
										  ,TO_DEPT_ID		= @v_to_dept_id
										  ,TO_DEPT_NAME		= @v_to_dept_name
										  ,TO_YYYYMM		= @v_to_yyyymm
										  ,TO_QTY			= @v_to_qty
										  ,ATTRIBUTE1       = @v_to_qty_tobe   -- Allo Target. qty update 수량 (history 용도)
										  ,COMMENTS			= @v_comments
										  ,CONFIRM			= 'N' --@v_confirm
										  ,ATTRIBUTE10      = @v_confirm_comments
										  ,REQUEST_USER		= @v_request_user
										  ,REQUEST_DATE		= SYSDATETIME() --@v_request_date
										  ,CONFIRM_USER		= @v_confirm_user
										  ,CONFIRM_DATE		= @v_confirm_date

							WHEN NOT MATCHED THEN
								INSERT
										   (CUTOFF_YYYYMMDD
										   ,FROM_ITEM_ID
										   ,FROM_DEPT_ID
										   ,FROM_DEPT_NAME
										   ,FROM_YYYYMM
										   ,FROM_QTY
										   ,TO_ITEM_ID
										   ,TO_DEPT_ID
										   ,TO_DEPT_NAME
										   ,TO_YYYYMM
										   ,TO_QTY
										   ,ATTRIBUTE1
										   ,COMMENTS
										   ,CONFIRM
										   ,ATTRIBUTE10
										   ,REQUEST_USER
										   ,REQUEST_DATE
										   ,CONFIRM_USER
										   ,CONFIRM_DATE
										  )
									 VALUES
										   ( @v_cutoff_yyyymmd
											,@v_from_item_id
											,@v_from_dept_id
											,@v_from_dept_name
											,@v_from_yyyymm
											,@v_from_qty
											,@v_to_item_id
											,@v_to_dept_id
											,@v_to_dept_name
											,@v_to_yyyymm
											,@v_to_qty
											,@v_to_qty_tobe
											,@v_comments
											,'N' --@v_confirm
											,@v_confirm_comments
											,@v_request_user
											,SYSDATETIME()--@v_request_date
											,@v_confirm_user
											,@v_confirm_date
										)
										;


								PRINT 'MERGE END..  . '+CONVERT(CHAR(23), GETDATE(), 21);

							END ;

					ELSE IF(@v_active_flag ='D')
						BEGIN
							DELETE FROM dbo.SCP_ANL_ALLO_TARGET_REQUEST
							WHERE SEQ  = @v_seq
							;
						END;

				END  --IF( @mst_loop_cnt > 0 )

		END -- WHILE

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리

			--INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			--VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

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
