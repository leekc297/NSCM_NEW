
/*
 * Program ID   : SCP0041_SAVE_PACKER_HOLD_STOCK
 * Description  : 
 * Program History
 *===========================================================================================================
 *   Date       In Charge		Description
 *===========================================================================================================
 * 2011.11.28	vadabi3			Create
 ------------------------------------------------------------------------------------------------------------
 EXEC SCP0041_SAVE_PACKER_HOLD_STOCK 
 @p_active_flag='M^M'
 , @p_inspection_id='EC-2022-G0154^EC-2022-G0154'
 , @p_dir='HOLD^HOLD'
 , @p_plant_id='KR005304^KR005304'
 , @p_prod_id='APCAN1805A^APCAN1805A'
 , @p_cutoff_date='20221128^20221129'
 , @p_qty='333^444'
 , @p_date_forecast_start='20221125^20221125'
 , @p_date_forecast_finish='20221130^20221130'
 , @p_user_id = 'vadabi3'
 */

 CREATE PROCEDURE [dbo].[SCP0041_SAVE_PACKER_HOLD_STOCK]
	@p_active_flag  		NVARCHAR(MAX) ,   
	@p_inspection_id   		NVARCHAR(MAX) , 	   
	@p_dir   				NVARCHAR(MAX) ,   
	@p_plant_id   			NVARCHAR(MAX) , 
	@p_prod_id   			NVARCHAR(MAX) , 
	@p_cutoff_date  		NVARCHAR(MAX) , 
	@p_qty   				NVARCHAR(MAX) ,
	@p_date_forecast_start  NVARCHAR(MAX) ,
	@p_date_forecast_finish NVARCHAR(MAX) ,
	@p_user_id              NVARCHAR(MAX)
AS

BEGIN
    SET NOCOUNT ON;

    DECLARE @v_program_id     AS NVARCHAR(40) = 'SCP0041_SAVE_PACKER_HOLD_STOCK';
    DECLARE @v_sheet_name     AS NVARCHAR(40) = 'Packer Hold Stock';	
	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_creation_date  AS NVARCHAR(40);
	DECLARE @v_count          AS INT;
	DECLARE @v_start_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_end_yyyymmdd AS NVARCHAR(8);
	
	DECLARE @v_delimiter NVARCHAR(1)
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	DECLARE @v_active_flag  		    NVARCHAR(MAX) ;
	DECLARE @v_inspection_id   			NVARCHAR(MAX) ;
	DECLARE @v_dir   				    NVARCHAR(MAX) ;
	DECLARE @v_plant_id   			    NVARCHAR(MAX) ;
	DECLARE @v_prod_id   			    NVARCHAR(MAX) ;
	DECLARE @v_cutoff_date   			NVARCHAR(MAX) ;
	DECLARE @v_qty   				    NVARCHAR(MAX) ;
	DECLARE @v_date_forecast_start      NVARCHAR(MAX) ;
	DECLARE @v_date_forecast_finish     NVARCHAR(MAX) ;
	SET @v_active_flag  		    = NULL;
	SET @v_inspection_id  		    = NULL;
	SET @v_dir   				    = NULL;
	SET @v_plant_id   			    = NULL;
	SET @v_prod_id   			    = NULL;
	SET @v_cutoff_date   			= NULL;
	SET @v_qty   				    = NULL;
	SET @v_date_forecast_start      = NULL;
	SET @v_date_forecast_finish     = NULL;

	DECLARE @update_count bigint;
	set @update_count = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0041_STOCK_OSP_EXCEL_UPLOAD';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	    BEGIN TRY
		BEGIN TRANSACTION
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);   
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN   
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;	

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_active_flag					= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag			, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_dir   						= [dbo].[SCM_ARR_SPL_VAL](@p_dir   					, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_plant_id   					= [dbo].[SCM_ARR_SPL_VAL](@p_plant_id   			, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_prod_id   					= [dbo].[SCM_ARR_SPL_VAL](@p_prod_id   				, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_cutoff_date		            = [dbo].[SCM_ARR_SPL_VAL](@p_cutoff_date 			, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_qty   						= [dbo].[SCM_ARR_SPL_VAL](@p_qty   					, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_date_forecast_start  		= [dbo].[SCM_ARR_SPL_VAL](@p_date_forecast_start  	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_date_forecast_finish 		= [dbo].[SCM_ARR_SPL_VAL](@p_date_forecast_finish 	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_inspection_id 		        = [dbo].[SCM_ARR_SPL_VAL](@p_inspection_id 			, @v_delimiter , @mst_loop_cnt) ; 
	

				
				--데이터 저장
				IF @mst_loop_cnt > 0 			
				BEGIN		
					IF( @v_active_flag ='M') 
						BEGIN
					
						--##################################
						-- Update SCM_DNM_STOCK_LOT_CONTROL
						--##################################
						UPDATE SCM_DNM_STOCK_LOT_CONTROL 
						   SET QTY				= @v_qty 
						     , HOLD_START_DATE	= @v_date_forecast_start
							 , HOLD_END_DATE	= @v_date_forecast_finish
							 , LAST_UPDATED_BY  = @p_user_id 
							 , LAST_UPDATE_DATE = GETDATE()
					     WHERE INSP_MCLASS_CODE =  'ECMM003'
						   AND INSPECTION_ID	= @v_inspection_id
						   AND DIR = @v_dir
						   AND PLANT_ID = @v_plant_id
						   AND ITEM_ID = @v_prod_id
						   AND CUTOFF_DATE = @v_cutoff_date
						
						SET @update_count += @@ROWCOUNT;


						/*
						--##################################
						-- 검증
						--##################################
						SELECT @v_inspection_id 
						+','+ @v_dir 
						+','+ @v_plant_id 
						+','+ @v_prod_id 
						+','+ @v_cutoff_date 
						+','+ @v_qty;

						select * 
						from SCM_DNM_STOCK_LOT_CONTROL
						  WHERE INSPECTION_ID	= @v_inspection_id
						   AND DIR				= @v_dir
						   AND PLANT_ID			= @v_plant_id
						   AND ITEM_ID			= @v_prod_id
						   AND INSP_MCLASS_CODE = 'ECMM003'
						   AND CUTOFF_DATE		= @v_cutoff_date
						*/

						END;
				END
			END;

			
		END;
		

         IF(@@error <> 0)
				BEGIN
	            ROLLBACK TRAN
				SELECT 'R', CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
				END
	     ELSE 
				BEGIN
	            COMMIT TRAN 
				SELECT 'S', @update_count;
			    END 
		 
		 
		END TRY

		BEGIN CATCH
			SELECT 'F', CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		END CATCH
	  
END;	
