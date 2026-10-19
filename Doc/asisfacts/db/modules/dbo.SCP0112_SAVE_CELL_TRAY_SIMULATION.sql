
/*
 * Program ID   : [SCP0112_SAVE_CELL_TRAY_SIMULATION]
 * Description  : SCP0112 Cell Tray Simulation 수정/저장 프로시저
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/09/23   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - SCP0112 Cell Tray Simulation 저장
 
 */

 CREATE PROCEDURE [dbo].[SCP0112_SAVE_CELL_TRAY_SIMULATION]
 
	@p_active_flag			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_to_site				NVARCHAR(MAX)
	,@p_measure_type		NVARCHAR(MAX)
	,@p_modiQty				NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)

AS
BEGIN

	SET NOCOUNT ON; 

	DECLARE @v_working_time			DATETIME =sysdatetime();
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_from_site			NVARCHAR(MAX);
	DECLARE @v_to_site				NVARCHAR(MAX);
	DECLARE @v_measure_type			NVARCHAR(MAX);
	DECLARE @v_modiQty				NVARCHAR(MAX);

	DECLARE @v_last_updated_by		NVARCHAR(MAX);
	DECLARE @v_lookup_type			NVARCHAR(200); 

	SET @v_active_flag		= NULL;
	SET @v_from_site		= NULL;
	SET @v_to_site			= NULL;
	SET @v_measure_type		= NULL;
	SET @v_modiQty			= NULL;
	SET @v_last_updated_by	= NULL;
	SET @v_lookup_type		= 'CELL_TRAY_SIMULATION_SITE';

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0112_SAVE_CELL_TRAY_SIMULATION';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	SET @v_last_updated_by  = @p_user_id

		-- 트렌젝션 시작
		BEGIN TRAN;

		BEGIN TRY

			-- 시작 LOG
			SET @v_log_type = 'START';
			SET @v_log_message = '########## Start of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			-- 프로시저 LOOP 길이를 판단
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);   

			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			BEGIN
		
				SET @mst_loop_cnt = @mst_loop_cnt + 1;

				-- 각 컬럼들에 대한 스플릿처리로직 스타트
				BEGIN

					SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    
					SET @v_from_site = [dbo].[SCM_ARR_SPL_VAL](@p_from_site, @v_delimiter , @mst_loop_cnt) ; 
					SET @v_to_site = [dbo].[SCM_ARR_SPL_VAL](@p_to_site, @v_delimiter , @mst_loop_cnt) ;
					SET @v_measure_type = [dbo].[SCM_ARR_SPL_VAL](@p_measure_type, @v_delimiter , @mst_loop_cnt) ;
					SET @v_modiQty = [dbo].[SCM_ARR_SPL_VAL](@p_modiQty, @v_delimiter , @mst_loop_cnt) ;

				END

				--데이터 저장
				IF @mst_loop_cnt > 0
				BEGIN
					
					-- 데이터 수정
					IF(@v_active_flag ='M') 
					BEGIN
						
						IF(@v_measure_type = 'STOCK_Packer')
						BEGIN

							--변경된 수량으로 STOCK_Packer(box)를 수정
							UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
							   SET ATTRIBUTE1			= @v_modiQty
								 , LAST_UPDATED_BY		= @v_last_updated_by 
								 , LAST_UPDATE_DATE		= SYSDATETIME()
							 WHERE lookup_type			= @v_lookup_type
							   and segment1 = @v_from_site
							   and segment2 = @v_to_site
						END
						ELSE IF(@v_measure_type = 'STOCK_WH')
						BEGIN

							--변경된 수량으로 STOCK_WH(box)를 수정
							UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
							   SET ATTRIBUTE2			= @v_modiQty
								 , LAST_UPDATED_BY		= @v_last_updated_by 
								 , LAST_UPDATE_DATE		= SYSDATETIME()
							 WHERE lookup_type			= @v_lookup_type
							   and segment1 = @v_from_site
							   and segment2 = @v_to_site
						END
						ELSE IF(@v_measure_type = 'STOCK_Intransit')
						BEGIN

							--변경된 수량으로 STOCK_Intransit(box)를 수정
							UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
							   SET ATTRIBUTE3			= @v_modiQty
								 , LAST_UPDATED_BY		= @v_last_updated_by 
								 , LAST_UPDATE_DATE		= SYSDATETIME()
							 WHERE lookup_type			= @v_lookup_type
							   and segment1 = @v_from_site
							   and segment2 = @v_to_site
						END;

					END;

				END;-- END OF STMT. IF(@mst_loop_cnt > 0)

			END;-- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
			COMMIT TRAN;

			-- 결과코드, 결과 카운트 반환
			SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

		END TRY

		BEGIN CATCH
			IF (XACT_STATE() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
			BEGIN
				INSERT INTO scm_sys_log_batch (program_name
												,log_type
												,log_count
												,log_message
												,description
												,event_date
												,creation_date
												,created_by
												,last_update_date
												,last_updated_by)
				VALUES (ERROR_PROCEDURE()
						,'ERROR'
						,NULL
						,ERROR_MESSAGE()
						,NULL
						,SYSDATETIME()
						,SYSDATETIME()
						,ERROR_PROCEDURE()
						,SYSDATETIME()
						,ERROR_PROCEDURE());

			END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
END
