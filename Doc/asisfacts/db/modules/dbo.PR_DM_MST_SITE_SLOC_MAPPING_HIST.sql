
/*
 * Program ID   : PR_DM_MST_SITE_SLOC_MAPPING_HIST
 * Description  : SCM MST SITE LOCATION H HISTORYT 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 11. 29    DWOK/DWPARK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */
 
CREATE PROCEDURE [dbo].[PR_DM_MST_SITE_SLOC_MAPPING_HIST]
	@p_location_seq				NVARCHAR(MAX),
	@p_division_id				NVARCHAR(MAX),
	@p_location_code			NVARCHAR(MAX),
	@p_location_description		NVARCHAR(MAX),
	@p_scm_site_id				NVARCHAR(MAX),
	@p_plant_id					NVARCHAR(MAX),
	@p_factory_id				NVARCHAR(MAX),
	@p_operation_id				NVARCHAR(MAX),
	@p_storage_id				NVARCHAR(MAX),
	@p_electrode_type			NVARCHAR(MAX),
	@p_valid_yn					NVARCHAR(MAX),
	@p_created_by				NVARCHAR(MAX)	

AS


BEGIN

	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


	DECLARE @v_division_id		NVARCHAR(MAX);
	DECLARE @v_scm_site_id		NVARCHAR(MAX);
	DECLARE @v_location_code	NVARCHAR(MAX);
	DECLARE @v_valid_yn			NVARCHAR(MAX);
	DECLARE @v_created_by		NVARCHAR(MAX);
	DECLARE @n_history_seq		INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_SITE_SLOC_MAPPING_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	--[C20200909-000203] LOG 표준화 적용
		-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 트랜잭션 (START)
		BEGIN TRANSACTION SITE_SLOC_MAPPING_HIST;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

			BEGIN    
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_MST_LOCATION_H

				   BEGIN

						BEGIN
							INSERT	INTO  [dbo].[SCM_MST_LOCATION_H]
							(									   
										 history_seq, 
										 location_seq, 
										 division_id, 
										 location_code,
										 location_description, 
										 scm_site_id ,
										 plant_id, 
										 factory_id,
										 operation_id, 
										 storage_id, 
										 electrode_type, 
										 valid_yn ,
										 created_by,creation_date,last_updated_by,last_update_date, 
										 history_creation_date
							)
							VALUES  
										(
										 @n_history_seq, 
										 @p_location_seq, 
										 @p_division_id, 
										 @p_location_code,
										 @p_location_description, 
										 @p_scm_site_id ,
										 @p_plant_id, 
										 @p_factory_id,
										 @p_operation_id, 
										 @p_storage_id, 
										 @p_electrode_type, 
										 @p_valid_yn,
										 @p_created_by,SYSDATETIME(),@p_created_by,SYSDATETIME(),
										 SYSDATETIME()
										);
					   END
						
				   END
						
			END

		COMMIT WORK;

		END TRY

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	--[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION  SITE_SLOC_MAPPING_HIST;

	-- ERROR LOG
	SET @v_log_type = 'ERROR';
	SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
	SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
	SET @d_event_date = SYSDATETIME();
	SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	  
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END;
