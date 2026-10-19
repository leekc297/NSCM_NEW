
/*
 * Program ID   : SCP0051_SAVE_PRODUCTION_PLAN_TARGET
 * Description  : PRODUCTION PLAN TARTGET 등록,수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020-10-05   khj79          [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성
 * 2024.03.25	vadabi5	       NERP) 특정 Plant 별도 처리
 * 2024.06.09	vadabi5	       NERP) QA, 개발 DB 적용
 ---------------------------------------------------------------------------------------------------- 
 EXEC NERP_SCP0051_SAVE_PRODUCTION_PLAN_TARGET
  @p_active_flag		= ''
 ,@p_target_id			= ''
 ,@p_prod_date			= ''
 ,@p_division_id		= ''
 ,@p_origin_division_id	= ''
 ,@p_item_id 			= ''
 ,@p_plant_scm_site_id 	= ''
 ,@p_line_id 			= ''
 ,@p_operation_id 		= ''
 ,@p_order_type 		= ''
 ,@p_market 			= ''
 ,@p_plant_qty			= ''
 ,@p_reason				= ''
 ,@p_reason_detail		= ''
 ,@p_request_user_id	= ''
 ,@p_charge_user_id		= ''
 ,@debug_mode			= ''

 EXEC SCP0051_SAVE_PRODUCTION_PLAN_TARGET
  @p_active_flag		= ''
 ,@p_target_id			= ''
 ,@p_prod_date			= ''
 ,@p_division_id		= ''
 ,@p_origin_division_id	= ''
 ,@p_item_id 			= ''
 ,@p_plant_scm_site_id 	= ''
 ,@p_line_id 			= ''
 ,@p_operation_id 		= ''
 ,@p_order_type 		= ''
 ,@p_market 			= ''
 ,@p_plant_qty			= ''
 ,@p_reason				= ''
 ,@p_reason_detail		= ''
 ,@p_request_user_id	= ''
 ,@p_charge_user_id		= ''
 ,@debug_mode			= ''


 */
CREATE PROCEDURE [dbo].[SCP0051_SAVE_PRODUCTION_PLAN_TARGET]
	 @p_active_flag			NVARCHAR(MAX)
	,@p_target_id			NVARCHAR(MAX)
	,@p_prod_date			NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_origin_division_id	NVARCHAR(MAX)
	,@p_item_id 			NVARCHAR(MAX)
	,@p_plant_scm_site_id 	NVARCHAR(MAX)
	,@p_line_id 			NVARCHAR(MAX)
	,@p_operation_id 		NVARCHAR(MAX)
	,@p_order_type 			NVARCHAR(MAX)
	,@p_market 				NVARCHAR(MAX)
	,@p_plant_qty			NVARCHAR(MAX)
	,@p_reason				NVARCHAR(MAX)
	,@p_reason_detail		NVARCHAR(MAX)
	,@p_request_user_id		NVARCHAR(MAX)
	,@p_charge_user_id		NVARCHAR(MAX)
	,@debug_mode			NVARCHAR(20) ='F'
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX) = NULL;
	DECLARE @v_target_id			NVARCHAR(MAX) = NULL;
	DECLARE @v_prod_date			NVARCHAR(MAX) = NULL;
	DECLARE @v_division_id			NVARCHAR(MAX) = NULL;
	DECLARE @v_origin_division_id	NVARCHAR(MAX) = NULL;
	DECLARE @v_item_id 				NVARCHAR(MAX) = NULL;
	DECLARE @v_plant_scm_site_id 	NVARCHAR(MAX) = NULL;
	DECLARE @v_line_id 				NVARCHAR(MAX) = NULL;
	DECLARE @v_operation_id 		NVARCHAR(MAX) = NULL;
	DECLARE @v_order_type 			NVARCHAR(MAX) = NULL;
	DECLARE @v_market 				NVARCHAR(MAX) = NULL;
	DECLARE @v_plant_qty			NVARCHAR(MAX) = NULL;
	DECLARE @v_reason				NVARCHAR(MAX) = NULL;
	DECLARE @v_reason_detail		NVARCHAR(MAX) = NULL;
	DECLARE @v_request_user_id		NVARCHAR(MAX) = NULL;
	DECLARE @v_charge_user_id		NVARCHAR(MAX) = NULL;
	DECLARE @v_id_delimiter			NVARCHAR(10) = '::';


	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0;
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0051_SAVE_PRODUCTION_PLAN_TARGET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

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
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_active_flag			= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag		, @v_delimiter, @mst_loop_cnt) ;
				SET @v_target_id			= [dbo].[SCM_ARR_SPL_VAL](@p_target_id			, @v_delimiter, @mst_loop_cnt) ;
				SET @v_prod_date			= [dbo].[SCM_ARR_SPL_VAL](@p_prod_date			, @v_delimiter, @mst_loop_cnt) ;
				SET @v_division_id			= [dbo].[SCM_ARR_SPL_VAL](@p_division_id		, @v_delimiter, @mst_loop_cnt) ;
				SET @v_origin_division_id	= [dbo].[SCM_ARR_SPL_VAL](@p_origin_division_id	, @v_delimiter, @mst_loop_cnt) ;
				SET @v_item_id				= UPPER([dbo].[SCM_ARR_SPL_VAL](@p_item_id		, @v_delimiter, @mst_loop_cnt)) ;
				SET @v_plant_scm_site_id	= [dbo].[SCM_ARR_SPL_VAL](@p_plant_scm_site_id	, @v_delimiter, @mst_loop_cnt) ;
				SET @v_line_id				= [dbo].[SCM_ARR_SPL_VAL](@p_line_id			, @v_delimiter, @mst_loop_cnt) ;
				SET @v_operation_id			= [dbo].[SCM_ARR_SPL_VAL](@p_operation_id		, @v_delimiter, @mst_loop_cnt) ;
				SET @v_order_type			= [dbo].[SCM_ARR_SPL_VAL](@p_order_type			, @v_delimiter, @mst_loop_cnt) ;
				SET @v_market				= [dbo].[SCM_ARR_SPL_VAL](@p_market				, @v_delimiter, @mst_loop_cnt) ;
				SET @v_plant_qty			= [dbo].[SCM_ARR_SPL_VAL](@p_plant_qty			, @v_delimiter, @mst_loop_cnt) ;
				SET @v_reason				= [dbo].[SCM_ARR_SPL_VAL](@p_reason				, @v_delimiter, @mst_loop_cnt) ;
				SET @v_reason_detail		= [dbo].[SCM_ARR_SPL_VAL](@p_reason_detail		, @v_delimiter, @mst_loop_cnt) ;
				SET @v_request_user_id		= [dbo].[SCM_ARR_SPL_VAL](@p_request_user_id	, @v_delimiter, @mst_loop_cnt) ;
				SET @v_charge_user_id		= [dbo].[SCM_ARR_SPL_VAL](@p_charge_user_id		, @v_delimiter, @mst_loop_cnt) ;
			END

			-- LOOP 파라미터 출력 DEBUG용
			IF (@debug_mode ='T')
			BEGIN		
				PRINT '===============================================';
				PRINT '@v_active_flag			= ''' +@v_active_flag			+'''';
				PRINT '@v_target_id				= ''' +@v_target_id				+'''';
				PRINT '@v_prod_date				= ''' +@v_prod_date				+'''';
				PRINT '@v_division_id			= ''' +@v_division_id			+'''';
				PRINT '@v_origin_division_id	= ''' +@v_origin_division_id	+'''';
				PRINT '@v_item_id				= ''' +@v_item_id				+'''';
				PRINT '@v_plant_scm_site_id		= ''' +@v_plant_scm_site_id		+'''';
				PRINT '@v_line_id				= ''' +@v_line_id				+'''';
				PRINT '@v_operation_id			= ''' +@v_operation_id			+'''';
				PRINT '@v_order_type			= ''' +@v_order_type			+'''';
				PRINT '@v_market				= ''' +@v_market				+'''';
				PRINT '@v_plant_qty				= ''' +@v_plant_qty				+'''';
				PRINT '@v_reason				= ''' +@v_reason				+'''';
				PRINT '@v_reason_detail			= ''' +@v_reason_detail			+'''';
				PRINT '@v_request_user_id		= ''' +@v_request_user_id		+'''';
				PRINT '@v_charge_user_id		= ''' +@v_charge_user_id		+'''';
				PRINT '@mst_loop_cnt			= ''' +CONVERT(VARCHAR(10), @mst_loop_cnt) +'''';
			END;

			--데이터 저장
			IF @mst_loop_cnt > 0
				BEGIN

				IF @v_active_flag = 'D'
				BEGIN
					DELETE FROM SCP_ANL_PRODUCTION_PLAN_TARGET WHERE TARGET_ID = @v_target_id;
				END
				ELSE IF @v_active_flag = 'I'
				BEGIN
					DECLARE @v_temp_dom_exp NVARCHAR(10);
					DECLARE @v_temp_target_num NVARCHAR(500);
					DECLARE @v_temp_target_id NVARCHAR(500)

					----------------------------------------------------------------
					-- @v_WarrantyPlant
					----------------------------------------------------------------
					DECLARE @v_WarrantyPlant NVARCHAR(500)
					SELECT @v_WarrantyPlant  = SEGMENT2
					FROM SCM_CODE_LOOKUP_VALUE 
					WHERE LOOKUP_TYPE_CODE = 'SCP0051_SAVE_PRODUCTION_PLAN_TARGET'
					AND SEGMENT1 = 'WarrantyPlant'
					----------------------------------------------------------------

					IF @v_plant_scm_site_id = @v_WarrantyPlant
						SET @v_temp_dom_exp =  SUBSTRING(@v_market,1,1);
					ELSE
						SET @v_temp_dom_exp =  'D'

					-- target id 생성
					SELECT @v_temp_target_num = MAX(RIGHT(TARGET_ID,3))
					  FROM SCP_ANL_PRODUCTION_PLAN_TARGET
					 WHERE DIVISION_ID			= @v_division_id
					   AND PLANT_SCM_SITE_ID	= @v_plant_scm_site_id
					   AND PROD_DATE			= @v_prod_date
					   AND ITEM_ID				= @v_item_id
					   AND LINE_ID				= @v_line_id
					   AND OPERATION_ID			= @v_operation_id
					   AND ORDER_TYPE			= @v_order_type
					   AND MARKET				= @v_market
						;

					IF @v_temp_target_num IS NULL
					BEGIN
						SET @v_target_id =  @v_division_id + @v_id_delimiter + @v_plant_scm_site_id + @v_id_delimiter + @v_prod_date + @v_id_delimiter + @v_item_id + @v_id_delimiter + @v_line_id+ @v_id_delimiter + @v_operation_id + @v_id_delimiter +  @v_order_type+ @v_id_delimiter	
							+  @v_temp_dom_exp  + @v_id_delimiter + '001';
					END
					ELSE
					BEGIN
						SET @v_temp_target_num = REPLICATE('0',3 - LEN(CONVERT(VARCHAR(3),CONVERT(INT,@v_temp_target_num) + 1))) + CONVERT(VARCHAR(3),CONVERT(INT,@v_temp_target_num) + 1);
						SET @v_target_id = @v_division_id + @v_id_delimiter + @v_plant_scm_site_id + @v_id_delimiter + @v_prod_date + @v_id_delimiter + @v_item_id + @v_id_delimiter + @v_line_id+ @v_id_delimiter + @v_operation_id + @v_id_delimiter +  @v_order_type+ @v_id_delimiter	
							+  @v_temp_dom_exp  + @v_id_delimiter + @v_temp_target_num;
					END
				
						INSERT INTO SCP_ANL_PRODUCTION_PLAN_TARGET
						(
									  TARGET_ID
									, DIVISION_ID
									, ORIGIN_DIVISION_ID
									, ITEM_ID
									, PLANT_SCM_SITE_ID
									, LINE_ID
									, OPERATION_ID
									, ORDER_TYPE
									, MARKET
									, PROD_DATE
									, QTY
									, REASON		
									, REASON_DETAIL
									, REQUEST_USER_ID
									, CHARGE_USER_ID
									, CONFIRM_YN
									, TARGET_YN
									, INPUT_DATE
								)
						VALUES  (
					 				  @v_target_id
									, @v_division_id
									, @v_origin_division_id
									, @v_item_id
									, @v_plant_scm_site_id
									, @v_line_id
									, @v_operation_id
									, @v_order_type
									, @v_market
									, @v_prod_date
									, @v_plant_qty
									, @v_reason
									, @v_reason_detail
									, @v_request_user_id
									, @v_charge_user_id
									, 'N'    -- CONFIRM_YN
									, 'N'    -- TARGET_YN
									, SYSDATETIME()  -- INPUT_DATE
								);
					END
				END  -- END OF STMT. IF( @mst_loop_cnt > 0 )			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

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

		  if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리

		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
	END

