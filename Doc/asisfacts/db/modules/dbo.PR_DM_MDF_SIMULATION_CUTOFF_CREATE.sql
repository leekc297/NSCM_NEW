
/*
 * Program ID   : PR_DM_MDF_SIMULATION_CUTOFF_CREATE
 * Description  : MDF SIMULATOR CUTOFF CREATE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20180806    JSYOUN        INIT C20190314_48991 [CSR ID:3948991] GSCM MDF 시뮬레이터 개발 요청의 건
 */

create PROCEDURE [dbo].[PR_DM_MDF_SIMULATION_CUTOFF_CREATE]
	@p_division_id			NVARCHAR(MAX),
	@p_ver_description		NVARCHAR(MAX),
	@p_ver_type				NVARCHAR(MAX),
	@p_old_version_no		NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX)

AS

BEGIN


	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	/*
		-----------------------------------------------------------------------------------------
		000
			: VARIABLE DECLARATION
		-----------------------------------------------------------------------------------------
	*/
	
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_ver_description		NVARCHAR(MAX);
	DECLARE @v_ver_type				NVARCHAR(MAX);
	DECLARE @v_old_version_no   	NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);

	DECLARE	@v_ver_return_no		NVARCHAR(100);	-- cut off Generated Number	
	DECLARE @n_history_seq			INTEGER;
	DECLARE @v_plan_week			NVARCHAR(MAX);
	DECLARE	@v_OK_description		NVARCHAR(1200);	-- cut off Generated Number	

	SET @v_division_id		 = NULL;	
	SET @v_ver_description	 = NULL;	
	SET @v_ver_type			 = NULL;	
	SET @v_old_version_no    = NULL;	
	SET @v_created_by		 = NULL;	

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	---- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	/*
		-----------------------------------------------------------------------------------------
		100
			: START LOG
		-----------------------------------------------------------------------------------------
	*/
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRAN 

	/*
		-----------------------------------------------------------------------------------------
		200
			: MAIN LOGIC
		-----------------------------------------------------------------------------------------
	*/
	BEGIN TRY
		BEGIN
			SET @v_division_id = @p_division_id;
			SELECT @v_division_id
			BEGIN
				SET @v_plan_week = 
				(
					SELECT a.ISO_YYYYWW   
					FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
					WHERE  a.BASIS_YYYYMMDD = CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				)
			END
			SELECT @v_plan_week;

			SET @v_ver_description = @p_ver_description;
			SELECT @v_ver_description

			SET @v_ver_type = @p_ver_type;
			SELECT @v_ver_type

			SET @v_old_version_no = @p_old_version_no;
			SELECT @v_old_version_no

			SET @v_created_by = @p_created_by;
			SELECT @v_created_by

		END

		BEGIN
			EXEC	[dbo].[PR_DM_PLN_VERSION_CREATE]	--@return_value = [dbo].[PR_DM_PLN_VERSION_CREATE]
			@v_division_id,
			@v_ver_description,
			@v_ver_type,
			@v_created_by,
			@v_ver_return_no  OUTPUT,
			@v_OK_description OUTPUT
					
			SELECT @v_ver_return_no; --Output;
			SELECT @v_OK_description;



		select '1'

			BEGIN
				INSERT [dbo].[DM_PLN_MDF_SIMULATOR_DATA]
				(
					[MDF_VERSION_NO]
					,[DIVISION_ID]
					,[DEPARTMENT_ID]
					,[DMS_CUSTOMER]
					,[DMS_SALES]
					,[APPLICATION]
					,[BIZ_TYPE]
					,[ITEM_TYPE]
					,[MEASURE]
					,[UNIT_CURRENCY]
					,[YYYYMM]
					,[QTY]
					,[CREATED_BY]
					,[CREATION_DATE]
					,[LAST_UPDATED_BY]
					,[LAST_UPDATE_DATE]
					,[ATTRIBUTE1]
					,[ATTRIBUTE2]
					,[ATTRIBUTE3]
					,[ATTRIBUTE4]
					,[ATTRIBUTE5]
					,[ATTRIBUTE6]
					,[ATTRIBUTE7]
					,[ATTRIBUTE8]
					,[ATTRIBUTE9]
					,[ATTRIBUTE10]						
				)
				SELECT 
					@v_ver_return_no AS [MDF_VERSION_NO]
					,[DIVISION_ID]
					,[DEPARTMENT_ID]
					,[DMS_CUSTOMER]
					,[DMS_SALES]
					,[APPLICATION]
					,[BIZ_TYPE]
					,[ITEM_TYPE]
					,[MEASURE]
					,[UNIT_CURRENCY]
					,[YYYYMM]
					,[QTY]
					,@v_created_by AS [CREATED_BY]
					,getdate() AS [CREATION_DATE]
					,@v_created_by AS [LAST_UPDATED_BY]
					,getdate() AS [LAST_UPDATE_DATE]
					,[ATTRIBUTE1]
					,[ATTRIBUTE2]
					,[ATTRIBUTE3]
					,[ATTRIBUTE4]
					,[ATTRIBUTE5]
					,[ATTRIBUTE6]
					,[ATTRIBUTE7]
					,[ATTRIBUTE8]
					,[ATTRIBUTE9]
					,[ATTRIBUTE10]					
				FROM [dbo].[DM_PLN_MDF_SIMULATOR_DATA]
			   WHERE [DIVISION_ID]    = @v_division_id
				 AND [MDF_VERSION_NO] = @v_old_version_no 
			  ;
			END

		END;
						
		--------------------------------------------------------------------------- 20180528 KHSONG DW I/F 테이블 생성 Procedure 호출 추가
		--EXEC [dbo].PR_DM_TO_XIF_DM_PLN_MKT_FCST_C @p_division_id, @v_ver_return_no
		---------------------------------------------------------------------------

		COMMIT TRAN ;	
 
	END TRY

	/*
		-----------------------------------------------------------------------------------------
		300
			: ERROR TRAP
		-----------------------------------------------------------------------------------------
	*/
    BEGIN CATCH
	    select 'error1'

			ROLLBACK TRAN  ;	

			SET @v_log_type = 'ERROR';
			SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
			SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
			SET @d_event_date = SYSDATETIME();

		select 'error2'

			SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']_O' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

		select 'error3'

			SELECT @@TRANCOUNT AS trancnt2;SELECT @@error ;

		select 'error4'

			IF @v_OK_description <> 'OK'
			SET @v_log_message = CAST(@v_OK_description AS NVARCHAR(1000));

		select XACT_STATE()	as 'XACT_STATE';
  
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH

	SET NOCOUNT OFF;

    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
  END;  
