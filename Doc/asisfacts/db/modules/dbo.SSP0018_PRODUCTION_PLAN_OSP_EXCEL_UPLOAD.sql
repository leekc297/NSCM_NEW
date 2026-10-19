
/*
 * Program ID   : SSP0018_PRODUCTION_PLAN_OSP_EXCEL_UPLOAD
 * Description  : SSP0018_PRODUCTION_PLAN_OSP_EXCEL_UPLOAD
 * Program History
 *EXEC SSP0018_PRODUCTION_PLAN_OSP_EXCEL_UPLOAD @p_cnt = '1', @p_division_id = '40', @p_plant_site = '600184_40-P', @p_model = 'ACEF1047I-A1', @p_dates = '20190424^20190425^20190426^20190427^20190428^20190429^20190430^20190501^20190502^20190503^20190504^20190505^20190506^20190507^20190508^20190509^20190510^20190511^20190512^20190513^20190514^20190515^20190516^20190517^20190518^20190519^20190520^20190521^20190522^20190523^20190524^20190525^20190526^20190527^20190528^20190529^20190530^20190531^20190601^20190602^20190603^20190604^20190605^20190606^20190607^20190608^20190609^20190610^20190611^20190612^20190613^20190614^20190615^20190616^20190617^20190618', @p_qtys = '1^2^3^4^5^6^7^8^9^10^11^12^13^14^15^16^17^18^19^20^21^22^23^24^25^26^27^28^29^30^31^32^33^34^35^36^37^38^39^40^41^42^43^44^45^46^47^48^49^50^51^52^53^54^55^56', @p_user_id = 'kahonmalu'
 *===========================================================================================================
 *   Date       In Charge		Description
 *===========================================================================================================
 * 2019/04/19	MCTHEJ			[PJ20189106] 전지.GSCM 고도화 이행- PRODUCTION PLAN OSP UPLOAD
 */
                        
 CREATE PROCEDURE [dbo].[SSP0018_PRODUCTION_PLAN_OSP_EXCEL_UPLOAD]
	@p_cnt					NVARCHAR(100),
	@p_division_id			NVARCHAR(60),
	@p_plant_site			NVARCHAR(60),
	@p_model				NVARCHAR(100),
	@p_dates				NVARCHAR(MAX),
	@p_qtys					NVARCHAR(MAX),
	@p_user_id				NVARCHAR(150)

AS

BEGIN
    SET NOCOUNT ON;
	DECLARE @v_program_id			NVARCHAR(40) = 'SSP0018';
	DECLARE @v_sheet_name			NVARCHAR(40) = 'Production Plan(OSP)';
	DECLARE @v_working_time			datetime =sysdatetime();
	
	DECLARE	@v_delimiter			CHAR(1) = '^';
	DECLARE @v_data_cnt				INT;
	DECLARE @v_loop_cnt				INT;
	SET @v_data_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_dates, @v_delimiter);		--//DATA LOOP COUNT
	SET @v_loop_cnt = 0;

	DECLARE @v_date					NVARCHAR(8);
	DECLARE @v_qty					NVARCHAR(MAX);
	DECLARE @v_convert_qty			NUMERIC(20, 10);
	
	DECLARE @v_row_cnt				INT;
	DECLARE @v_col_cnt				INT;
	SET @v_row_cnt = 0;
	SET @v_col_cnt = 0;

	DECLARE @v_chk					INT;
	SET @v_chk = 0;
	DECLARE @v_cnt					INT;
	SET @v_cnt = convert(int, @p_cnt);

	DECLARE @Query					NVARCHAR(MAX);
	DECLARE @Column_Query			NVARCHAR(MAX);
	DECLARE @Title_Query				NVARCHAR(MAX);
	DECLARE @Qty_Query				NVARCHAR(MAX);
	SET @Query = '';
	SET @Column_Query = '';
	SET @Title_Query = '';
	SET @Qty_Query = '';

	--LOG 변수
	DECLARE @v_program_name NVARCHAR(150) = 'SSP0018_PRODUCTION_PLAN_OSP_EXCEL_UPLOAD';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	BEGIN TRAN;
	BEGIN TRY
		--DATA SAVE

		--//LOG START///////////////////////////////////////////////--
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		--//////////////////////////////////////////////////////////--

		WHILE @v_loop_cnt < @v_data_cnt
		BEGIN
			SET @v_loop_cnt = @v_loop_cnt + 1;
			
			SET @v_date	= dbo.SCM_ARR_SPL_VAL(@p_dates, @v_delimiter, @v_loop_cnt);
			SET @v_qty	= dbo.SCM_ARR_SPL_VAL(@p_qtys, @v_delimiter, @v_loop_cnt);
			SET @v_convert_qty = CONVERT(NUMERIC(20, 10), @v_qty);

			SELECT @v_chk = COUNT(*) 
			FROM SSP_ANL_PROD_PLAN_OSP WITH(NOLOCK)
			WHERE 1 = 1
			  AND DIVISION_ID = @p_division_id
			  AND SCM_SITE_ID = @p_plant_site
			  AND ITEM_ID = @p_model
			  AND YYYYMMDD = @v_date;

			IF(@v_chk > 0)
			BEGIN
				UPDATE SSP_ANL_PROD_PLAN_OSP
				SET
					QTY = @v_convert_qty,
					LAST_UPDATED_BY = @p_user_id,
					LAST_UPDATE_DATE = @v_working_time
				WHERE 1 = 1
				  AND DIVISION_ID = @p_division_id
				  AND SCM_SITE_ID = @p_plant_site
				  AND ITEM_ID = @p_model
				  AND YYYYMMDD = @v_date;
			END
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
					@v_convert_qty,			@p_user_id,				@v_working_time,	@p_user_id,				@v_working_time
				);
			END

			SET @Column_Query = @Column_Query + ', ATTRIBUTE' + CONVERT(NVARCHAR(MAX), @v_loop_cnt + 3);
			SET @Qty_Query = @Qty_Query + ', ''' + CONVERT(NVARCHAR(MAX), @v_qty) + '''';
			
			--TITLE INSERT
			IF @v_cnt = 1
			BEGIN
				SET @Title_Query = @Title_Query + ', ''' + @v_date + '''';
			END;		--TITLE INSERT END
		END;			--DATA LOOP END
		COMMIT TRAN;
		
		IF @v_cnt = 1
		BEGIN
			SET @Query = '';
			SET @Query = @Query + ' INSERT INTO SCM_ADM_EXCEL_UPLOAD ' + CHAR(10);
			SET @Query = @Query + ' ( ' + CHAR(10);
			SET @Query = @Query + '		UPLOAD_ID, ' + CHAR(10);
			SET @Query = @Query + '		PROGRAM_ID,			SHEET_NAME,				UPLOAD_STATUS_CODE, ' + CHAR(10);
			SET @Query = @Query + '		CREATED_BY,			CREATION_DATE,			LAST_UPDATED_BY,			LAST_UPDATE_DATE, ' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE1,			ATTRIBUTE2,				ATTRIBUTE3' + CHAR(10);
			SET @Query = @Query + @Column_Query + CHAR(10);
			SET @Query = @Query + ' ) ' + CHAR(10);
			SET @Query = @Query + ' VALUES ' + CHAR(10);
			SET @Query = @Query + ' ( ' + CHAR(10);
			SET @Query = @Query + '		' + CONVERT(NVARCHAR(100), NEXT VALUE FOR SEQ1_SCM_ADM_EXCEL_UPLOAD) + ', ' + CHAR(10);
			SET @Query = @Query + '		''' + @v_program_id + ''', ''' + @v_sheet_name + ''', ''@TITLE'', ' + CHAR(10);
			SET @Query = @Query + '		''' + @p_user_id + ''', ''' + CONVERT(NVARCHAR(50), @v_working_time) + ''', ''' + @p_user_id + ''', ''' + CONVERT(NVARCHAR(50), @v_working_time) + ''',' + CHAR(10);
			SET @Query = @Query + '		''Div'', ''Plant Site'', ''Model''' + CHAR(10);
			SET @Query = @Query + @Title_Query + CHAR(10);
			SET @Query = @Query + ' ) ' + CHAR(10);

			--SELECT @Query;
			EXEC(@Query);
		END
		
		SET @Query = '';
		SET @Query = @Query + ' INSERT INTO SCM_ADM_EXCEL_UPLOAD ' + CHAR(10);
		SET @Query = @Query + ' ( ' + CHAR(10);
		SET @Query = @Query + '		UPLOAD_ID, ' + CHAR(10);
		SET @Query = @Query + '		PROGRAM_ID,			SHEET_NAME,				UPLOAD_STATUS_CODE, ' + CHAR(10);
		SET @Query = @Query + '		CREATED_BY,			CREATION_DATE,			LAST_UPDATED_BY,			LAST_UPDATE_DATE, ' + CHAR(10);
		SET @Query = @Query + '		ATTRIBUTE1,			ATTRIBUTE2,				ATTRIBUTE3' + CHAR(10);
		SET @Query = @Query + @Column_Query + CHAR(10);
		SET @Query = @Query + ' ) ' + CHAR(10);
		SET @Query = @Query + ' VALUES ' + CHAR(10);
		SET @Query = @Query + ' ( ' + CHAR(10);
		SET @Query = @Query + '		' + CONVERT(NVARCHAR(100), NEXT VALUE FOR SEQ1_SCM_ADM_EXCEL_UPLOAD) + ', ' + CHAR(10);
		SET @Query = @Query + '		''' + @v_program_id + ''', ''' + @v_sheet_name + ''', ''SUCCESS'', ' + CHAR(10);
		SET @Query = @Query + '		''' + @p_user_id + ''', CONVERT(DATETIME, ''' + CONVERT(NVARCHAR(50), @v_working_time) + '''), ''' + @p_user_id + ''', ''' + CONVERT(NVARCHAR(50), @v_working_time) + ''', ' + CHAR(10);
		SET @Query = @Query + '		''' + @p_division_id + ''', ''' + @p_plant_site + ''', ''' + @p_model + '''' + CHAR(10);
		SET @Query = @Query + @Qty_Query + CHAR(10);
		SET @Query = @Query + ' ) ' + CHAR(10);

		--SELECT @Query;
		EXEC(@Query);
		
		SELECT  'S' AS result_code,  @v_loop_cnt AS result_cnt ;

		--//LOG END///////////////////////////////////////////////--
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	
		--/////////////////////////////////////////////////////////--

	END TRY
	BEGIN CATCH
		BEGIN
			IF @Column_Query =''
			BEGIN
				ROLLBACK TRAN; --입력 데이타 롤백 처리
			END
			ELSE
			BEGIN
				SET @Query = '';
				SET @Query = @Query + ' INSERT INTO SCM_ADM_EXCEL_UPLOAD ' + CHAR(10);
				SET @Query = @Query + ' ( ' + CHAR(10);
				SET @Query = @Query + '		UPLOAD_ID, ' + CHAR(10);
				SET @Query = @Query + '		PROGRAM_ID,			SHEET_NAME,				UPLOAD_STATUS_CODE, ' + CHAR(10);
				SET @Query = @Query + '		CREATED_BY,			CREATION_DATE,			LAST_UPDATED_BY,			LAST_UPDATE_DATE ' + CHAR(10);
				SET @Query = @Query + @Column_Query + CHAR(10);
				SET @Query = @Query + ' ) ' + CHAR(10);
				SET @Query = @Query + ' VALUES ' + CHAR(10);
				SET @Query = @Query + ' ( ' + CHAR(10);
				SET @Query = @Query + '		' + CONVERT(NVARCHAR(100), NEXT VALUE FOR SEQ1_SCM_ADM_EXCEL_UPLOAD) + ', ' + CHAR(10);
				SET @Query = @Query + '		''' + @v_program_id + ''', ''' + @v_sheet_name + ''', ''ERROR'', ' + CHAR(10);
				SET @Query = @Query + '		''' + @p_user_id + ''', CONVERT(DATETIME, ''' + CONVERT(NVARCHAR(50), @v_working_time) + '''), ''' + @p_user_id + ''', ''' + CONVERT(NVARCHAR(50), @v_working_time) + ''', ' + CHAR(10);
				SET @Query = @Query + '		''' + @p_division_id + ''', ''' + @p_plant_site + ''', ''' + @p_model + '''' + CHAR(10);
				SET @Query = @Query + @Qty_Query + CHAR(10);
				SET @Query = @Query + ' ) ' + CHAR(10);

				EXEC(@Query);
			END
			
			SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
			   						
			-- error코드, errror 메시지 반환
			SELECT  @v_err_code			AS err_code
					,@v_err_message		AS err_message
			; 
		END
	END CATCH;
	
	--select * from SCM_ADM_EXCEL_UPLOAD;
	--SELECT * FROM SCM_ADM_EXCEL_COLUMNS

	--SSP_ANL_PROD_PLAN_OSP
END;	
