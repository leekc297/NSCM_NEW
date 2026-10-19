/* =============================================================================
프로그램ID	: SCP0093_SAVE_DIO_TREND_DATA
프로그램명	: Packer 보류 재고 > 기타충담금 저장
*===================================================================================================      
*   Date       In Charge	Description      
*===================================================================================================      
* 2022.02.09   vadabi3		Create   
============================================================================= */
/*

 EXEC SCP0093_SAVE_DIO_TREND_DATA 
 @p_active_flag='M'
 , @p_plan_start_yyyymmdd='20221107^20221107'
 , @p_division_id='81^81'
 , @p_aggr_dv='ET^ET'
 , @p_item_id='??????????^??????????'
 , @p_cell_convert_yn='^'
 , @p_operation_group='^'
 , @p_category_dv='P^P'
 , @p_measure='INV^INV'
 , @p_yyyymm='202201^202202'
 , @p_yyyymmValue='11^22'
 , @p_request_user_id='vadabi3'
*/


--CREATE PROCEDURE dbo.SCP0093_SAVE_DIO_TREND_DATA
CREATE PROCEDURE [dbo].[SCP0093_SAVE_DIO_TREND_DATA]
 @p_active_flag                NVARCHAR(MAX) ,
 @p_plan_start_yyyymmdd  	   NVARCHAR(MAX) ,  
 @p_division_id           	   NVARCHAR(MAX) ,  
 @p_aggr_dv               	   NVARCHAR(MAX) , 	
 @p_item_id               	   NVARCHAR(MAX) , 	
 @p_cell_convert_yn       	   NVARCHAR(MAX) ,	
 @p_operation_group       	   NVARCHAR(MAX) ,	
 @p_category_dv       	       NVARCHAR(MAX) ,	
 @p_measure               	   NVARCHAR(MAX) ,	
 @p_yyyymm                	   NVARCHAR(MAX) ,	
 @p_yyyymmValue                NVARCHAR(max) ,	
 @p_request_user_id      	   NVARCHAR(MAX) 	


AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	SET @v_active_flag = NULL;

	DECLARE @v_plan_start_yyyymmdd    	   NVARCHAR(MAX) ;      
	DECLARE @v_division_id             	   NVARCHAR(MAX) ;   
	DECLARE @v_aggr_dv                 	   NVARCHAR(MAX) ; 
	DECLARE @v_item_id                 	   NVARCHAR(MAX) ; 
	DECLARE @v_cell_convert_yn         	   NVARCHAR(MAX) ;
	DECLARE @v_operation_group         	   NVARCHAR(MAX) ;
	DECLARE @v_category_dv         	       NVARCHAR(MAX) ;
	DECLARE @v_measure                 	   NVARCHAR(MAX) ;
	DECLARE @v_yyyymm                  	   NVARCHAR(MAX) ;
	DECLARE @v_yyyymmValue                 NVARCHAR(max) ;	

	SET @v_plan_start_yyyymmdd     	 = NULL;
	SET @v_division_id               = NULL;
	SET @v_aggr_dv                   = NULL;
	SET @v_item_id                   = NULL;
	SET @v_cell_convert_yn           = NULL;
	SET @v_operation_group           = NULL;
	SET @v_category_dv				 = NULL;
	SET @v_measure                   = NULL;
	SET @v_yyyymm                    = NULL;
	SET @v_yyyymmValue               = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0093_SAVE_DIO_TREND_DATA';
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

		--PRINT '2';
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_yyyymm, @v_delimiter);   

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN   
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;	



			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_active_flag				= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag			    , @v_delimiter , @mst_loop_cnt) ;    
				SET @v_plan_start_yyyymmdd  	= [dbo].[SCM_ARR_SPL_VAL](@p_plan_start_yyyymmdd        , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_division_id          	= [dbo].[SCM_ARR_SPL_VAL](@p_division_id             	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_aggr_dv              	= [dbo].[SCM_ARR_SPL_VAL](@p_aggr_dv                 	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_item_id              	= [dbo].[SCM_ARR_SPL_VAL](@p_item_id                 	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_cell_convert_yn      	= [dbo].[SCM_ARR_SPL_VAL](@p_cell_convert_yn         	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_operation_group      	= [dbo].[SCM_ARR_SPL_VAL](@p_operation_group         	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_category_dv      	    = [dbo].[SCM_ARR_SPL_VAL](@p_category_dv        	    , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_measure              	= [dbo].[SCM_ARR_SPL_VAL](@p_measure                 	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_yyyymm               	= [dbo].[SCM_ARR_SPL_VAL](@p_yyyymm                  	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_yyyymmValue          	= [dbo].[SCM_ARR_SPL_VAL](@p_yyyymmValue             	, @v_delimiter , @mst_loop_cnt) ; 
			END

			IF @mst_loop_cnt > 0 			
				BEGIN		

					IF( @p_active_flag ='M') 
						BEGIN
							


							/********************************************************************************
							-- UPDATE
							********************************************************************************/
							UPDATE SCP_RPT_DIO_TREND_MM
							SET AMOUNT			=	@v_yyyymmValue,
							   --QUANTITY		=	@v_yyyymmValue,
							   -- DIO			=	@v_yyyymmValue,
								LAST_UPDATED_BY =   @p_request_user_id,
								LAST_UPDATE_DATE= getdate()
							WHERE PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
							  AND DIVISION_ID = @v_division_id 
							  AND AGGR_DV = @v_aggr_dv 
							  AND YYYYMM = @v_yyyymm 
							  AND CATEGORY_DV = @v_category_dv
							  AND MEASURE = @v_measure 
							  AND ITEM_ID = N'기타충당금'
							  --AND ITEM_ID = @v_item_id 
							;
							

							/********************************************************************************
							-- CHECK
							
							SELECT @v_plan_start_yyyymmdd 
							+ ',' + @v_division_id 
							+ ',' + @v_aggr_dv 
							+ ',' + @v_yyyymm
							+ ',' + @v_category_dv
							+ ',' + @v_measure
							+ ',' + @v_yyyymmValue
							+ ',' + @p_request_user_id

							SELECT AMOUNT, LAST_UPDATE_DATE
							FROM SCP_RPT_DIO_TREND_MM
							WHERE PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
							  AND DIVISION_ID = @v_division_id 
							  AND AGGR_DV = @v_aggr_dv 
							  AND YYYYMM = @v_yyyymm 
							  AND CATEGORY_DV = @v_category_dv
							  AND MEASURE = @v_measure 
							  AND ITEM_ID = N'기타충당금'
							  --AND ITEM_ID = @v_item_id 
							;
							********************************************************************************/

							

						END
				END 		
			
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
