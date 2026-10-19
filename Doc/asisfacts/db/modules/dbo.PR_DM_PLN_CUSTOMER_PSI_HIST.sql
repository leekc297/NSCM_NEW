
/*
 * Program ID   : PR_DM_PLN_CUSTOMER_PSI_HIST
 * Description  : Dynamic Query Register Batch ('SCM_ADM_DQ_PARAMETER' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 03. 13    JHBAEK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_CUSTOMER_PSI_HIST]

	-- Add the parameters for the stored procedure here
	@p_DIVISION_ID					NVARCHAR(MAX),     
	@p_CUSTOMER_PROJECT_CODE		NVARCHAR(MAX),
	@p_CUSTOMER_MODEL				NVARCHAR(MAX),
	@p_SCM_SITE_ID					NVARCHAR(MAX),	
	@p_DOM_EXP						NVARCHAR(MAX),			
	@p_FCST_TYPE					NVARCHAR(MAX),			
	@p_MEASURE_GROUP				NVARCHAR(MAX),		
	@p_MEASURE						NVARCHAR(MAX),	
	@p_YYYYMMDD						NVARCHAR(MAX),			
	@p_INCOTERMS					NVARCHAR(MAX),			
	@p_PLANT_SITE_ID				NVARCHAR(MAX),		
	@p_PROJECT_CODE					NVARCHAR(MAX),		
	@p_ITEM_ID						NVARCHAR(MAX),		
	@p_QTY							NVARCHAR(MAX),		
	@p_UPLOAD_UOM					NVARCHAR(MAX),	
	@p_CREATED_BY					NVARCHAR(MAX),
	@p_LAST_UPDATED_BY				NVARCHAR(MAX)

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @n_history_seq		INTEGER;
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_CUSTOMER_PSI_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_trancount    INT;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		--EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  -- TRANSACTION 충돌되므로 주석처리
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		BEGIN TRANSACTION PR_DM_PLN_CUSTOMER_PSI_HIST;
		
	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

			-- (1) 	 
            /* HISTIRY INSERT */
			BEGIN
        	SET @n_history_seq = NEXT VALUE FOR SEQ1_DM_PLN_CUSTOMER_PSI_H
            INSERT INTO dbo.DM_PLN_CUSTOMER_PSI_H 
				   (DIVISION_ID					,  
					HISTORY_SEQ					,
					CUSTOMER_PROJECT_CODE		,
					CUSTOMER_MODEL				,
					SCM_SITE_ID					,
					DOM_EXP						,
					FCST_TYPE					,
					MEASURE_GROUP				,
					MEASURE						,
					YYYYMMDD					,
					INCOTERMS					,
					PLANT_SITE_ID				,
					PROJECT_CODE				,
					ITEM_ID						,
					QTY							,
					UPLOAD_UOM					,
					CREATED_BY					,
					CREATION_DATE				,
					LAST_UPDATED_BY				,
					LAST_UPDATE_DATE			,
					ATTRIBUTE1					,
					ATTRIBUTE2					,
					ATTRIBUTE3					,
					ATTRIBUTE4					,
					ATTRIBUTE5					,
					ATTRIBUTE6					,
					ATTRIBUTE7					,
					ATTRIBUTE8					,
					ATTRIBUTE9					,
					ATTRIBUTE10
					)
         VALUES
               (
				 @p_DIVISION_ID         
				,@n_HISTORY_SEQ
				,@p_CUSTOMER_PROJECT_CODE		
				,@p_CUSTOMER_MODEL				
				,@p_SCM_SITE_ID					
				,@p_DOM_EXP						
				,@p_FCST_TYPE					
				,@p_MEASURE_GROUP				
				,@p_MEASURE						
				,@p_YYYYMMDD					
				,@p_INCOTERMS					
				,@p_PLANT_SITE_ID				
				,@p_PROJECT_CODE				
				,@p_ITEM_ID						
				,CONVERT(NUMERIC(20, 10), @p_QTY)
				--,'ABC'
				,@p_UPLOAD_UOM					
				,@p_CREATED_BY      
				,sysdatetime()
				,@p_LAST_UPDATED_BY 
				,sysdatetime()
				,null,null,null,null,null,null,null,null,null,null
    	         )
			END
			-- (1) 

			IF @@TRANCOUNT > 0 
				COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
		BEGIN CATCH
	--------------------------------------------------------------	
			--[C20200909-000203] LOG 표준화 적용
			-- 트랜잭션 (END)
			ROLLBACK TRANSACTION PR_DM_PLN_CUSTOMER_PSI_HIST;

			-- ROLLBACK
			-- ERROR LOG VALUE SAVE
			SET @v_log_type = 'ERROR';
			SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
			SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
			SET @d_event_date = SYSDATETIME();

			SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

			-- TO TEST
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	--------------------------------------------------------------	
		END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
 --    IF @v_log_message IS NULL
	--  SELECT 'success'
	--;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    --EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  -- TRANSACTION 충돌되므로 주석처리

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
