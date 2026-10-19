/*
 * Program ID   : PR_SCP_MST_LOSS_TIME_HIST
 * Description  : Loss TIme Master History 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.13   byunghunjung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_LOSS_TIME_HIST]
	 @p_division_id				NVARCHAR(MAX)
	, @p_plant_site_id			NVARCHAR(MAX)
	, @p_factory_id				NVARCHAR(MAX)
	, @p_operation_id			NVARCHAR(MAX)
	, @p_line_id				NVARCHAR(MAX)
	, @p_loss_time_min			NVARCHAR(MAX)
	, @p_setup_loss_time_min	NVARCHAR(MAX)
	, @p_created_by				NVARCHAR(MAX)
	, @p_last_updated_by		NVARCHAR(MAX)
	, @p_creation_date			DATETIME

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_LOSS_TIME_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

			declare
				@v_loss_time_min int = convert(int , @p_loss_time_min) ,
				@v_setup_loss_time_min int = convert(int , @p_setup_loss_time_min)

			BEGIN    
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_LOSS_TIME_H

				BEGIN
				INSERT	INTO  SCP_MST_LOSS_TIME_H (
					history_seq, 
					division_id, 
					plant_site_id, 
					factory_id, 
					operation_id, 
					line_id,
					LOSS_TIME_MIN , 
					SETUP_LOSS_TIME_MIN ,
					created_by, 
					creation_date,
					last_updated_by, 
					last_update_date, 
					HISTORY_CREATION_DATE)
				VALUES  (
					@n_history_seq,
					@p_division_id, 
					@p_plant_site_id, 
					@p_factory_id, 
					@p_operation_id,
					@p_line_id,
					@v_loss_time_min , 
					@v_setup_loss_time_min ,
					@p_created_by , 
					@p_creation_date, 
					@p_last_updated_by,	
					SYSDATETIME() ,
					SYSDATETIME() 
				);
				END
			END

	END;


