
/*
 * Program ID   : PR_SCM_ADM_LOOKUP_MASTER_DETAIL_HIST
 * Description  : Lookup Values History 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.15   byunghunjung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCM_ADM_LOOKUP_MASTER_DETAIL_HIST]

	@p_lookup_type		NVARCHAR(200), 
	@p_description		NVARCHAR(MAX),
	@p_display_seq		INT, 
	@p_valid_yn			NVARCHAR(2),
	@p_segment1			NVARCHAR(100),
	@p_segment2			NVARCHAR(100),
	@p_segment3			NVARCHAR(100),
	@p_segment4			NVARCHAR(100),
	@p_segment5			NVARCHAR(100),
	@p_attribute1		NVARCHAR(100),
	@p_attribute2		NVARCHAR(100),
	@p_attribute3		NVARCHAR(100),
	@p_attribute4		NVARCHAR(100),
	@p_attribute5		NVARCHAR(100),
	@p_attribute6		NVARCHAR(100),
	@p_attribute7		NVARCHAR(100),
	@p_attribute8		NVARCHAR(100),
	@p_attribute9		NVARCHAR(100),
	@p_attribute10		NVARCHAR(100),
	@p_attribute11		NVARCHAR(100),
	@p_attribute12		NVARCHAR(100),
	@p_attribute13		NVARCHAR(100),
	@p_attribute14		NVARCHAR(100),
	@p_attribute15		NVARCHAR(100),
	@p_created_by		NVARCHAR(300),
	@p_creation_date	DATETIME,
	@p_last_updated_by	NVARCHAR(300)

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_ADM_LOOKUP_MASTER_DETAIL_HIST';
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
				SET @n_history_seq = NEXT VALUE FOR [dbo].[SEQ1_SCM_ADM_LOOKUP_MASTER_DETAIL_H]
				
				   BEGIN
					INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL_H
					    (
							history_seq, lookup_type, description, display_seq, valid_yn, segment1, segment2, segment3, segment4, segment5, created_by, creation_date,
							last_updated_by, last_update_date, attribute1,attribute2,attribute3,attribute4,attribute5,attribute6,attribute7,attribute8,attribute9,
							attribute10,attribute11,attribute12,attribute13,attribute14,attribute15, history_creation_date
						)
					VALUES(
							@n_history_seq, @p_lookup_type, @p_description, @p_display_seq, @p_valid_yn, @p_segment1, @p_segment2, @p_segment3, @p_segment4, @p_segment5, @p_created_by, @p_creation_date,
							@p_last_updated_by, sysdatetime(), @p_attribute1, @p_attribute2, @p_attribute3, @p_attribute4, @p_attribute5, @p_attribute6, @p_attribute7, @p_attribute8, @p_attribute9,
							@p_attribute10, @p_attribute11, @p_attribute12, @p_attribute13, @p_attribute14, @p_attribute15, @d_event_date
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





