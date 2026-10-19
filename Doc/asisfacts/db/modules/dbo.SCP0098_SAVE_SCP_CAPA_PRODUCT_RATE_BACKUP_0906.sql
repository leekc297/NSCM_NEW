
/*
 * Program ID   : SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE 20230906 Backup
 * Description  : SCP CAPA SAVE
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023/08/25   vadabi3      최초작성
 ----------------------------------------------------------------------------------------------------
   EXEC SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE
								@p_active_flag		 = 'U^U'
							  , @p_division_id		 = '40^40'
							  , @p_plant_id			 = 'A010^A010'
							  , @p_factory_id		 = 'M1^M1'
							  , @p_operation_id		 = 'A3000^A3000'
							  , @p_line_id			 = 'M1C02^M2C02^M3C02'
							  , @p_yyyymmdd			 = '20230701^20230701^20230701'
							  , @p_product_rate		  = '82.12^93.22^94.23'
							  , @p_user_id		     = 'vadabi'

*/

CREATE PROCEDURE [dbo].[SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE_BACKUP_0906]
        @p_active_flag      NVARCHAR(MAX)
	  , @p_division_id		NVARCHAR(MAX)
	  , @p_plant_id			NVARCHAR(MAX)
	  , @p_factory_id		NVARCHAR(MAX)
	  , @p_operation_id		NVARCHAR(MAX)
	  , @p_line_id			NVARCHAR(MAX)
	  , @p_yyyymmdd			NVARCHAR(MAX)
	  , @p_product_rate		NVARCHAR(MAX)
	  , @p_user_id		    NVARCHAR(100)
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

    ----------------------------------------------------------------------------------------------------
	-- 변수 선언
	----------------------------------------------------------------------------------------------------
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	DECLARE @v_delimiter		NVARCHAR(1)
	SET @v_delimiter = '^'

	--  변수 설정
	DECLARE @v_active_flag		NVARCHAR(MAX);
	DECLARE @v_division_id		NVARCHAR(MAX);
	DECLARE @v_plant_id			NVARCHAR(MAX);
	DECLARE @v_factory_id		NVARCHAR(MAX);
	DECLARE @v_operation_id		NVARCHAR(MAX);
	DECLARE @v_line_id			NVARCHAR(MAX);
	DECLARE @v_yyyymmdd			NVARCHAR(MAX);
	DECLARE @v_product_rate	    NVARCHAR(MAX);
	SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);  

    ----------------------------------------------------------------------------------------------------
	-- Start Log
	----------------------------------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = concat(@p_user_id, ' : ' , @p_line_id);
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @max_loop_cnt, @v_log_message, @v_description, @d_event_date;

	BEGIN TRY

			  
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN    

					SET @mst_loop_cnt = @mst_loop_cnt + 1;
					SET @v_division_id	 = [dbo].[SCM_ARR_SPL_VAL](@p_division_id	 , @v_delimiter , @mst_loop_cnt) ;
					SET @v_plant_id		 = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id		 , @v_delimiter , @mst_loop_cnt) ;
					SET @v_factory_id	 = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id	 , @v_delimiter , @mst_loop_cnt) ;
					SET @v_operation_id	 = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id	 , @v_delimiter , @mst_loop_cnt) ;
					SET @v_line_id		 = [dbo].[SCM_ARR_SPL_VAL](@p_line_id		 , @v_delimiter , @mst_loop_cnt) ;
					SET @v_yyyymmdd		 = [dbo].[SCM_ARR_SPL_VAL](@p_yyyymmdd	     , @v_delimiter , @mst_loop_cnt) ;	
					SET @v_product_rate	 = [dbo].[SCM_ARR_SPL_VAL](@p_product_rate	 , @v_delimiter , @mst_loop_cnt) ;

					--SELECT @v_division_id, @v_plant_id, @v_factory_id, @v_operation_id, @v_line_id, @v_item_id, @v_value, @p_user_id
					-----------------------------------------------------------------------------------------------

						MERGE INTO dbo.SCP_MST_CAPA_WORK A
						USING (
								 SELECT @v_division_id	AS division_id	
									   ,@v_plant_id		AS plant_id		
									   ,@v_factory_id	AS factory_id	
									   ,@v_operation_id	AS operation_id	
									   ,@v_line_id		AS line_id			
									   ,@v_yyyymmdd		AS yyyymmdd		
									   ,@v_product_rate	AS prod_ready_rate		
									   ,@p_user_id		AS USR_ID		
								  ) B
						ON(
									 A.division_id  = B.division_id	
								AND  A.plant_id		= B.plant_id		
								AND  A.factory_id	= B.factory_id		
								AND  A.operation_id	= B.operation_id	
								AND  A.line_id		= B.line_id					
								AND  A.yyyymmdd		= B.yyyymmdd		
						  )
						WHEN MATCHED THEN
							UPDATE  SET   A.prod_ready_rate	  = B.prod_ready_rate
							            , A.LAST_UPDATED_BY   = B.USR_ID
										, A.LAST_UPDATE_DATE  = GETDATE()

						WHEN NOT MATCHED THEN
						    INSERT
							(
							    division_id	
								,plant_id		
								,factory_id	
								,operation_id	
								,line_id			
								,measure	
								,yyyymmdd	
								,prod_ready_rate	
								,created_by
								,CREATION_DATE
								,LAST_UPDATED_BY
								,LAST_UPDATE_DATE
							)
							values
							(
								 B.division_id	
								,B.plant_id		
								,B.factory_id	
								,B.operation_id	
								,B.line_id		
								,'NO_WORK'	
								,B.yyyymmdd		
								,B.prod_ready_rate	
								,B.USR_ID
								,getdate()
								,B.USR_ID
								,getdate()
							);

			END


		-- 결과 코드 반환
		SELECT  'S' AS result_code, @@rowcount as update_row

		----------------------------------------------------------------------------------------------------
		-- Finish Log 
		----------------------------------------------------------------------------------------------------
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END TRY

	BEGIN CATCH
		BEGIN

		 BEGIN
			select ERROR_MESSAGE()
		    ----------------------------------------------------------------------------------------------------
			-- Error Log 
			----------------------------------------------------------------------------------------------------
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

		 END;

		IF @@TRANCOUNT > 0
			COMMIT WORK;
		END;
	END CATCH;
END
