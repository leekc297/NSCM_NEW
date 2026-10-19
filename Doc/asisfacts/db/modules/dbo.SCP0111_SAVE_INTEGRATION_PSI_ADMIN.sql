
/*
 * Program ID   : [SCP0111_SAVE_INTEGRATION_PSI_ADMIN]
 * Description  : 통합PSI Admin 사용자 수정/저장 프로시저
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/08/05   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 - 통합PSI Admin 사용자 수정/저장
 * 2025/03/14	mrchois	   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - PLAN_TYPE컬럼 추가
 
 */

 CREATE PROCEDURE [dbo].[SCP0111_SAVE_INTEGRATION_PSI_ADMIN]
 
	@p_active_flag			NVARCHAR(MAX)
	,@p_plan_type			NVARCHAR(MAX)	--PLAN_TYPE컬럼 추가 2025-03-14
	,@p_division_id			NVARCHAR(MAX)
	,@p_company_id			NVARCHAR(MAX)
	,@p_plant_id			NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(8)
	,@p_operation_group		NVARCHAR(MAX)
	,@p_cellitem_id			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_measure				NVARCHAR(MAX)
	,@p_valuation_type		NVARCHAR(MAX)
	,@p_to_product			NVARCHAR(MAX)
	,@p_line_id				NVARCHAR(MAX)
	,@p_to_site				NVARCHAR(MAX)
	,@p_incoterms			NVARCHAR(MAX)
	,@p_boh_qty				NVARCHAR(MAX)
	,@p_seq_flag			NVARCHAR(MAX)	
	,@p_yyyymm				NVARCHAR(MAX)
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
	DECLARE @v_plan_type			NVARCHAR(MAX);	--PLAN_TYPE컬럼 추가 2025-03-14
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_company_id			NVARCHAR(MAX);
	DECLARE @v_plant_id				NVARCHAR(MAX);
	DECLARE @v_operation_group		NVARCHAR(MAX);
	DECLARE @v_cellitem_id			NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_measure				NVARCHAR(MAX);
	DECLARE @v_valuation_type		NVARCHAR(MAX);
	DECLARE @v_to_product			NVARCHAR(MAX);
	DECLARE @v_line_id				NVARCHAR(MAX);
	DECLARE @v_to_site				NVARCHAR(MAX);
	DECLARE @v_incoterms			NVARCHAR(MAX);	
	DECLARE @v_boh_qty				NVARCHAR(MAX);
	DECLARE @v_seq_flag				NVARCHAR(MAX);
	DECLARE @v_yyyymm				NVARCHAR(MAX);
	DECLARE @v_modiQty				NVARCHAR(MAX);

	DECLARE @v_last_updated_by		NVARCHAR(MAX);

	SET @v_active_flag		= NULL;
	SET @v_plan_type		= NULL;		--PLAN_TYPE컬럼 추가 2025-03-14
	SET @v_division_id		= NULL;
	SET @v_company_id		= NULL;
	SET @v_plant_id			= NULL;
	SET @v_operation_group	= NULL;
	SET @v_cellitem_id		= NULL;
	SET @v_item_id			= NULL;
	SET @v_measure			= NULL;
	SET @v_valuation_type	= NULL;
	SET @v_to_product		= NULL;
	SET @v_line_id			= NULL;
	SET @v_to_site			= NULL;
	SET @v_incoterms		= NULL;
	SET @v_boh_qty			= NULL;
	SET @v_seq_flag			= NULL;		
	SET @v_yyyymm			= NULL;
	SET @v_modiQty			= NULL;
	SET @v_last_updated_by	= NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0111_SAVE_INTEGRATION_PSI_ADMIN';
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
					SET @v_plan_type = [dbo].[SCM_ARR_SPL_VAL](@p_plan_type, @v_delimiter , @mst_loop_cnt) ;		--PLAN_TYPE컬럼 추가 2025-03-14  
					SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ;  
					SET @v_company_id = [dbo].[SCM_ARR_SPL_VAL](@p_company_id, @v_delimiter , @mst_loop_cnt) ;
					SET @v_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id, @v_delimiter , @mst_loop_cnt) ;   
					SET @v_operation_group = [dbo].[SCM_ARR_SPL_VAL](@p_operation_group, @v_delimiter , @mst_loop_cnt) ;   
					SET @v_cellitem_id = [dbo].[SCM_ARR_SPL_VAL](@p_cellitem_id, @v_delimiter , @mst_loop_cnt) ;
					SET @v_item_id = [dbo].[SCM_ARR_SPL_VAL](@p_item_id, @v_delimiter , @mst_loop_cnt) ; 
					SET @v_measure = [dbo].[SCM_ARR_SPL_VAL](@p_measure, @v_delimiter , @mst_loop_cnt) ;
					SET @v_valuation_type = [dbo].[SCM_ARR_SPL_VAL](@p_valuation_type, @v_delimiter , @mst_loop_cnt) ;
					SET @v_to_product = [dbo].[SCM_ARR_SPL_VAL](@p_to_product, @v_delimiter , @mst_loop_cnt) ;
					SET @v_line_id = [dbo].[SCM_ARR_SPL_VAL](@p_line_id, @v_delimiter , @mst_loop_cnt) ;
					SET @v_to_site = [dbo].[SCM_ARR_SPL_VAL](@p_to_site, @v_delimiter , @mst_loop_cnt) ;
					SET @v_incoterms = [dbo].[SCM_ARR_SPL_VAL](@p_incoterms, @v_delimiter , @mst_loop_cnt) ;   
					SET @v_boh_qty = [dbo].[SCM_ARR_SPL_VAL](@p_boh_qty, @v_delimiter , @mst_loop_cnt) ;  
					SET @v_seq_flag = [dbo].[SCM_ARR_SPL_VAL](@p_seq_flag, @v_delimiter , @mst_loop_cnt) ;  	
					SET @v_yyyymm = [dbo].[SCM_ARR_SPL_VAL](@p_yyyymm, @v_delimiter , @mst_loop_cnt) ;
					SET @v_modiQty = [dbo].[SCM_ARR_SPL_VAL](@p_modiQty, @v_delimiter , @mst_loop_cnt) ;

				END

				--중복체크
				IF(@v_active_flag = 'I')
				BEGIN
					
					SELECT @v_data_dup_cnt = COUNT(*) 			
					  FROM SCP_ANL_PSI_INTEGRATION WITH(NOLOCK)
					 WHERE DIVISION_ID			= @v_division_id
					   AND COMPANY_ID			= @v_company_id
					   AND PLANT_ID				= @v_plant_id
					   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
					   AND OPERATION_GROUP		= @v_operation_group
					   AND CELL_ITEM_ID			= @v_cellitem_id
					   AND ITEM_ID				= @v_item_id
					   AND MEASURE				= @v_measure
					   AND VALUE_TYPE			= @v_valuation_type
					   AND TO_PRODUCT			= @v_to_product
					   AND LINE_ID				= @v_line_id
					   AND TO_SITE				= @v_to_site
					   AND INCOTERMS			= @v_incoterms
					   AND YYYYMM				= @v_yyyymm
					   AND ATTRIBUTE2			= @v_plan_type		--PLAN_TYPE컬럼 추가 2025-03-14 
					 ;

					IF(@v_data_dup_cnt > 0) 
					BEGIN
						SET @v_err_code    = 99010 ; 
						SET @v_err_message = N'동일한 데이터가 존재합니다.';
						THROW  @v_err_code, @v_err_message , 1; --예외발생
					END;
					
				END

				--데이터 저장
				IF @mst_loop_cnt > 0
				BEGIN
					
					-- 데이터 수정
					IF(@v_active_flag ='M') 
					BEGIN
						
						--변경된 수량으로 BOH_QTY, QTY를 수정
						UPDATE SCP_ANL_PSI_INTEGRATION
						   SET BOH_QTY				= ROUND(@v_boh_qty, 0)
							 , QTY					= ROUND(@v_modiQty, 0)	
							 , LAST_UPDATED_BY		= @v_last_updated_by 
							 , LAST_UPDATE_DATE		= SYSDATETIME()
						 WHERE DIVISION_ID			= @v_division_id
						   AND COMPANY_ID			= @v_company_id
						   AND PLANT_ID				= @v_plant_id
						   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
						   AND OPERATION_GROUP		= @v_operation_group
						   AND CELL_ITEM_ID			= @v_cellitem_id
						   AND ITEM_ID				= @v_item_id
						   AND MEASURE				= @v_measure
						   AND VALUE_TYPE			= @v_valuation_type
						   AND TO_PRODUCT			= @v_to_product
						   AND LINE_ID				= @v_line_id
						   AND TO_SITE				= @v_to_site
						   AND INCOTERMS			= @v_incoterms
						   AND YYYYMM				= @v_yyyymm
						   AND ATTRIBUTE2			= @v_plan_type		--PLAN_TYPE컬럼 추가 2025-03-14 
						;

					END
					ELSE IF( @v_active_flag ='I' )
					BEGIN

						--통합 PSI 신규데이터 입력
						INSERT INTO SCP_ANL_PSI_INTEGRATION
						(
							DIVISION_ID
							, COMPANY_ID
							, PLANT_ID
							, PLAN_START_YYYYMMDD
							, SEQ
							, OPERATION_GROUP
							, FROM_SITE
							, CELL_ITEM_ID
							, ITEM_ID
							, MEASURE   --10
							, value_type
							, TO_PRODUCT
							, LINE_ID
							, BOH_QTY
							, TO_SITE
							, INCOTERMS
							, SEQ_FLAG
							, YYYYMM
							, QTY
							, ATTRIBUTE2		--PLAN_TYPE컬럼 추가 2025-03-14
							, CREATED_BY
							, CREATION_DATE
							, LAST_UPDATED_BY     --10
							, LAST_UPDATE_DATE
						)
						VALUES
						(
							@v_division_id
							, @v_company_id
							, @v_plant_id
							, @p_plan_start_yyyymmdd
							, 1
							, @v_operation_group
							, '-'
							, @v_cellitem_id
							, @v_item_id
							, @v_measure
							, @v_valuation_type
							, @v_to_product
							, @v_line_id
							, @v_boh_qty
							, @v_to_site
							, @v_incoterms
							, @v_seq_flag
							, @v_yyyymm
							, @v_modiQty
							, @v_plan_type			--PLAN_TYPE컬럼 추가 2025-03-14
							, @v_last_updated_by
							, SYSDATETIME()
							, @v_last_updated_by
							, SYSDATETIME()
						);


					END

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
