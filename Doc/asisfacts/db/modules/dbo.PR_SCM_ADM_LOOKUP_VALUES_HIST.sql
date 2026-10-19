/*
 * Program ID   : PR_SCM_ADM_LOOKUP_VALUES_HIST
 * Description  : Lookup Values History 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.15   byunghunjung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCM_ADM_LOOKUP_VALUES_HIST]

@p_lookup_type			NVARCHAR(MAX), 
@p_division_id			NVARCHAR(MAX), 
@p_lookup_code			NVARCHAR(MAX), 
@p_l_description		NVARCHAR(MAX),
@p_display_seq			NVARCHAR(MAX), 
@p_default_value_flag	NVARCHAR(MAX), 
@p_valid_yn				NVARCHAR(MAX),
@p_created_by			NVARCHAR(MAX),
@p_creation_date		NVARCHAR(MAX),
@p_last_updated_by      NVARCHAR(MAX), 
@p_segment1				NVARCHAR(MAX), 
@p_segment2				NVARCHAR(MAX), 
@p_segment3				NVARCHAR(MAX), 
@p_attribute1			NVARCHAR(MAX), 
@p_attribute2			NVARCHAR(MAX), 
@p_attribute3			NVARCHAR(MAX), 
@p_attribute4			NVARCHAR(MAX), 
@p_attribute5			NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_ADM_LOOKUP_VALUES_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


		BEGIN TRY

				-- 시작 LOG
			SET @v_log_type = 'START';
			SET @v_log_message = '########## Start of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
			BEGIN    
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_ADM_LOOKUP_VALUES_H
				
				   BEGIN
					INSERT	INTO  SCM_ADM_LOOKUP_VALUES_H(									   
								 history_seq,division_id,lookup_type,lookup_code
								,description,valid_yn,display_seq,default_value_flag
								,created_by,creation_date,last_updated_by,last_update_date
								,segment1,segment2,segment3
								,attribute1,attribute2,attribute3,attribute4,attribute5
								,history_creation_date)
					VALUES  
								(
								 @n_history_seq,@p_division_id,@p_lookup_type,@p_lookup_code
								,@p_l_description,@p_valid_yn,@p_display_seq,@p_default_value_flag
								,@p_created_by,@p_creation_date,@p_last_updated_by,SYSDATETIME()
								,@p_segment1,@p_segment2,@p_segment3
								,@p_attribute1,@p_attribute2,@p_attribute3,@p_attribute4,@p_attribute5
								,SYSDATETIME()
								);
				   END
			END

			SET @v_log_type = 'END';
				SET @v_log_message = '########## END of procedure ##########';
				SET @v_description = '';
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		END TRY

		BEGIN CATCH
		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name
										  ,log_type
										  ,log_count
										  ,log_message
										  ,description
										  ,event_date
										  ,creation_date
										  ,created_by
										  ,last_update_date
										  ,last_updated_by)
			VALUES (ERROR_PROCEDURE()
				   ,'ERROR'
				   ,NULL
				   ,ERROR_MESSAGE()
				   ,NULL
				   ,SYSDATETIME()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
		  END;
		END CATCH;
	END;






