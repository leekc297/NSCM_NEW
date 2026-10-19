/*
 * Program ID   : PR_SCP_MST_LOSS_TIME_EXCEPT_HIST
 * Description  : LOSS TIME EXCEPT History 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.05.09   byunghunjung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_LOSS_TIME_EXCEPT_HIST]
	 @p_division_id				NVARCHAR(MAX)
	, @p_plant_site_id			NVARCHAR(MAX)
	, @p_factory_id				NVARCHAR(MAX)
	, @p_operation_id			NVARCHAR(MAX)
	, @p_line_id				NVARCHAR(MAX)
	, @p_loss_start_date		NVARCHAR(MAX)
	, @p_loss_end_date			NVARCHAR(MAX)
	, @p_loss_time_min			NVARCHAR(MAX)
	, @p_setup_loss_time_min	NVARCHAR(MAX)
	, @p_except_comment			NVARCHAR(MAX)
	, @p_created_by				NVARCHAR(MAX)
	, @p_last_updated_by		NVARCHAR(MAX)
	, @p_creation_date			DATETIME

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
		BEGIN    
			SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_LOSS_TIME_EXCEPT_H

			DECLARE
			@v_loss_time_min int = convert(int , @p_loss_time_min) ,
			@v_setup_loss_time_min int = convert(int , @p_setup_loss_time_min)

			BEGIN
			INSERT	INTO  SCP_MST_LOSS_TIME_EXCEPT_H (
				history_seq,
				division_id,
			    plant_site_id,
			    factory_id,
			    operation_id,
			    line_id,
			    loss_start_date,
			    loss_end_date,
			    loss_time_min,
			    setup_loss_time_min,
				except_comment,
				created_by,
				creation_date,
				last_updated_by,
				last_update_date,
				history_creation_date)
			VALUES  (
				@n_history_seq,
				@p_division_id, 
				@p_plant_site_id, 
				@p_factory_id, 
				@p_operation_id,
				@p_line_id,
				@p_loss_start_date,
				@p_loss_end_date,
				@v_loss_time_min , 
				@v_setup_loss_time_min ,
				@p_except_comment,
				@p_created_by , 
				@p_creation_date, 
				@p_last_updated_by,	
				SYSDATETIME() ,
				SYSDATETIME() 
			);

			END
		END

	END;


