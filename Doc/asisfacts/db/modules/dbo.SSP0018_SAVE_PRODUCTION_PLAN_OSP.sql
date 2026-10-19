
/*
 * Program ID   : SSP0018_PRODUCTION_PLAN_OSP
 * Description  : SSP0018_GET_PRODUCTION_PLAN_OSP
 * Program History
 *===========================================================================================================
 *   Date       In Charge		Description
 *===========================================================================================================
 * 2019/04/30	MCTHEJ			[PJ20189106] 전지.GSCM 고도화 이행- GET PRODUCTION PLAN OSP UPLOAD
 */

CREATE PROCEDURE [dbo].[SSP0018_SAVE_PRODUCTION_PLAN_OSP]
	@p_active_flag			NVARCHAR(2),
	@p_division_id			NVARCHAR(60),
	@p_plant_site			NVARCHAR(60),
	@p_model				NVARCHAR(100),
	@p_yyyymmdd				NVARCHAR(MAX),
	@p_qtys					NVARCHAR(MAX),
	@p_now_date				NVARCHAR(100),
	@p_user_id				NVARCHAR(150)
AS

BEGIN
	
	DECLARE	@v_delimiter			CHAR(1) = '^';
	DECLARE @v_data_cnt				INT;
	DECLARE @v_loop_cnt				INT;
	
	SET @v_data_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_yyyymmdd, @v_delimiter);		--//DATA LOOP COUNT
	
	SET @v_loop_cnt = 0;

	DECLARE @v_date					NVARCHAR(8);
	DECLARE @v_qty					NVARCHAR(MAX);
	DECLARE @v_convert_qty			NUMERIC(20, 10);
	
	DECLARE @v_working_time       datetime =sysdatetime();     
	DECLARE @v_create_date			NVARCHAR(30);
	DECLARE @v_create_by			NVARCHAR(30);
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0018_Production_Plan_OSP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	BEGIN TRY

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	WHILE @v_loop_cnt < @v_data_cnt
	BEGIN
		SET @v_loop_cnt = @v_loop_cnt + 1;

		SET @v_date	= dbo.SCM_ARR_SPL_VAL(@p_yyyymmdd, @v_delimiter, @v_loop_cnt);
		SET @v_qty	= dbo.SCM_ARR_SPL_VAL(@p_qtys, @v_delimiter, @v_loop_cnt);
		SET @v_convert_qty = CONVERT(NUMERIC(20, 10), @v_qty);

		INSERT INTO SSP_ANL_PROD_PLAN_OSP_H
		(
			HISTORY_SEQ,
			DIVISION_ID,					SCM_SITE_ID,					ITEM_ID,					YYYYMMDD,
			QTY,							CREATED_BY,						CREATION_DATE,				LAST_UPDATED_BY,
			LAST_UPDATE_DATE,				HISTORY_CREATION_DATE,			ATTRIBUTE1
		)
		VALUES
		(
			NEXT VALUE FOR SEQ1_PROD_PLAN_OSP_H,
			@p_division_id,					@p_plant_site,					@p_model,					@v_date,
			@v_convert_qty,					@p_user_id,						@v_working_time,				@p_user_id,				
			@v_working_time,				@v_working_time,				@p_active_flag
		);

		SET @v_create_date = '';
		SET @v_create_by = '';
		SELECT 
			@v_create_date = CREATION_DATE,
			@v_create_by = CREATED_BY
		FROM SSP_ANL_PROD_PLAN_OSP WITH(NOLOCK)
		WHERE 1 = 1
		AND DIVISION_ID = @p_division_id
		  AND SCM_SITE_ID = @p_plant_site
		  AND ITEM_ID = @p_model
		  AND YYYYMMDD = @v_date;

		DELETE FROM SSP_ANL_PROD_PLAN_OSP
		WHERE 1= 1
		  AND DIVISION_ID = @p_division_id
		  AND SCM_SITE_ID = @p_plant_site
		  AND ITEM_ID = @p_model
		  AND YYYYMMDD = @v_date;

		IF(@p_active_flag <> 'D')
		BEGIN
			IF(@p_active_flag = 'I')
			BEGIN
				INSERT INTO SSP_ANL_PROD_PLAN_OSP
				(
					DIVISION_ID,			SCM_SITE_ID,			ITEM_ID,			YYYYMMDD,
					QTY,					CREATED_BY,				CREATION_DATE,		LAST_UPDATED_BY,		LAST_UPDATE_DATE
				)
				VALUES
				(
					@p_division_id,			@p_plant_site,			@p_model,			@v_date,
					@v_convert_qty,			@p_user_id,				@v_working_time,	@p_user_id,				@v_working_time
				);
			END;
			ELSE
			BEGIN
				INSERT INTO SSP_ANL_PROD_PLAN_OSP
				(
					DIVISION_ID,			SCM_SITE_ID,			ITEM_ID,			YYYYMMDD,
					QTY,					CREATED_BY,				CREATION_DATE,		LAST_UPDATED_BY,		LAST_UPDATE_DATE
				)
				VALUES
				(
					@p_division_id,			@p_plant_site,			@p_model,			@v_date,
					@v_convert_qty,			@v_create_by,			@v_create_date,		@p_user_id,				@v_working_time
				);
			END
		END;
		
	END;
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SELECT  'S' AS result_code,  @v_loop_cnt AS result_cnt ;
	
	END TRY
	
	BEGIN CATCH 
		BEGIN
			--if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());
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
