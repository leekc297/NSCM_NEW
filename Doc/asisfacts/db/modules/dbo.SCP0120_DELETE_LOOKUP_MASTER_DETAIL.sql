
/*
 * Program ID   : SCP0120_DELETE_LOOKUP_MASTER_DETAIL
 * Description  : Constraint Mgmt Lookup Type 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/04/17   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/06/11   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Detail 삭제시 이력정보 저장하지 않도록 수정
 *
 */
CREATE PROCEDURE [dbo].[SCP0120_DELETE_LOOKUP_MASTER_DETAIL]

	-- Add the parameters for the stored procedure here
	@Action				NVARCHAR(1),
	@LOOKUP_TYPE		NVARCHAR(200), 
	@DESCRIPTION		NVARCHAR(MAX),
	@DISPLAY_SEQ		INT, 
	@VALID_YN			NVARCHAR(1),
	@SEGMENT1			NVARCHAR(100),
	@SEGMENT2			NVARCHAR(100),
	@SEGMENT3			NVARCHAR(100),
	@SEGMENT4			NVARCHAR(100),
	@SEGMENT5			NVARCHAR(100),
	@SEGMENT6			NVARCHAR(100),
	@SEGMENT7			NVARCHAR(100),
	@SEGMENT8			NVARCHAR(100),
	@SEGMENT9			NVARCHAR(100),
	@SEGMENT10			NVARCHAR(100),
	@SEGMENT1_KEY		NVARCHAR(100),
	@SEGMENT2_KEY		NVARCHAR(100),
	@SEGMENT3_KEY		NVARCHAR(100),
	@SEGMENT4_KEY		NVARCHAR(100),
	@SEGMENT5_KEY		NVARCHAR(100),
	@SEGMENT6_KEY		NVARCHAR(100),
	@SEGMENT7_KEY		NVARCHAR(100),
	@SEGMENT8_KEY		NVARCHAR(100),
	@SEGMENT9_KEY		NVARCHAR(100),
	@SEGMENT10_KEY		NVARCHAR(100),
	@ATTRIBUTE1			NVARCHAR(100),
	@ATTRIBUTE2			NVARCHAR(100),
	@ATTRIBUTE3			NVARCHAR(100),
	@ATTRIBUTE4			NVARCHAR(100),
	@ATTRIBUTE5			NVARCHAR(100),
	@ATTRIBUTE6			NVARCHAR(100),
	@ATTRIBUTE7			NVARCHAR(100),
	@ATTRIBUTE8			NVARCHAR(100),
	@ATTRIBUTE9			NVARCHAR(100),
	@ATTRIBUTE10		NVARCHAR(100),
	@ATTRIBUTE11		NVARCHAR(100),
	@ATTRIBUTE12		NVARCHAR(100),
	@ATTRIBUTE13		NVARCHAR(100),
	@ATTRIBUTE14		NVARCHAR(100),
	@ATTRIBUTE15		NVARCHAR(100),
	@CREATED_BY			NVARCHAR(300),
	@CREATION_DATE		DATETIME,
	@LAST_UPDATED_BY	NVARCHAR(300)
AS

BEGIN

	SET NOCOUNT ON;
	DECLARE @v_cnt INT;

	DECLARE @p_active_flag		NVARCHAR(1);
	DECLARE @p_lookup_type		NVARCHAR(200); 
	DECLARE @p_description		NVARCHAR(MAX);
	DECLARE @p_display_seq		NVARCHAR(200); 
	DECLARE @p_valid_yn			NVARCHAR(2);
	DECLARE @p_segment1			NVARCHAR(100);
	DECLARE @p_segment2			NVARCHAR(100);
	DECLARE @p_segment3			NVARCHAR(100);
	DECLARE @p_segment4			NVARCHAR(100);
	DECLARE @p_segment5			NVARCHAR(100);;
	DECLARE @p_segment6			NVARCHAR(100);
	DECLARE @p_segment7			NVARCHAR(100);
	DECLARE @p_segment8			NVARCHAR(100);
	DECLARE @p_segment9			NVARCHAR(100);
	DECLARE @p_segment10		NVARCHAR(100);
	DECLARE @p_segment1_key		NVARCHAR(100);
	DECLARE @p_segment2_key		NVARCHAR(100);
	DECLARE @p_segment3_key		NVARCHAR(100);
	DECLARE @p_segment4_key		NVARCHAR(100);
	DECLARE @p_segment5_key		NVARCHAR(100);
	DECLARE @p_segment6_key		NVARCHAR(100);
	DECLARE @p_segment7_key		NVARCHAR(100);
	DECLARE @p_segment8_key		NVARCHAR(100);
	DECLARE @p_segment9_key		NVARCHAR(100);
	DECLARE @p_segment10_key	NVARCHAR(100);
	DECLARE @p_attribute1		NVARCHAR(100);
	DECLARE @p_attribute2		NVARCHAR(100);
	DECLARE @p_attribute3		NVARCHAR(100);
	DECLARE @p_attribute4		NVARCHAR(100);
	DECLARE @p_attribute5		NVARCHAR(100);
	DECLARE @p_attribute6		NVARCHAR(100);
	DECLARE @p_attribute7		NVARCHAR(100);
	DECLARE @p_attribute8		NVARCHAR(100);
	DECLARE @p_attribute9		NVARCHAR(100);
	DECLARE @p_attribute10		NVARCHAR(100);
	DECLARE @p_attribute11		NVARCHAR(100);
	DECLARE @p_attribute12		NVARCHAR(100);
	DECLARE @p_attribute13		NVARCHAR(100);
	DECLARE @p_attribute14		NVARCHAR(100);
	DECLARE @p_attribute15		NVARCHAR(100);
	DECLARE @p_created_by		NVARCHAR(300);
	DECLARE @p_creation_date	DATETIME;
	DECLARE @p_last_updated_by	NVARCHAR(300);

	SET @p_active_flag		= @Action;
	SET @p_lookup_type		= @LOOKUP_TYPE;
	SET @p_description		= @DESCRIPTION;
	SET @p_display_seq		= @DISPLAY_SEQ;
	SET @p_valid_yn			= @VALID_YN;
	SET @p_segment1			= @SEGMENT1;
	SET @p_segment2			= @SEGMENT2;
	SET @p_segment3			= @SEGMENT3;
	SET @p_segment4			= @SEGMENT4;
	SET @p_segment5			= @SEGMENT5;
	SET @p_segment6			= @SEGMENT6;
	SET @p_segment7			= @SEGMENT7;
	SET @p_segment8			= @SEGMENT8;
	SET @p_segment9			= @SEGMENT9;
	SET @p_segment10		= @SEGMENT10;
	SET @p_segment1_key		= @SEGMENT1_KEY;
	SET @p_segment2_key		= @SEGMENT2_KEY;
	SET @p_segment3_key		= @SEGMENT3_KEY;
	SET @p_segment4_key		= @SEGMENT4_KEY;
	SET @p_segment5_key		= @SEGMENT5_KEY;
	SET @p_segment6_key		= @SEGMENT6_KEY;
	SET @p_segment7_key		= @SEGMENT7_KEY;
	SET @p_segment8_key		= @SEGMENT8_KEY;
	SET @p_segment9_key		= @SEGMENT9_KEY;
	SET @p_segment10_key	= @SEGMENT10_KEY;
	SET @p_attribute1		= @ATTRIBUTE1;
	SET @p_attribute2		= @ATTRIBUTE2;
	SET @p_attribute3		= @ATTRIBUTE3;
	SET @p_attribute4		= @ATTRIBUTE4;
	SET @p_attribute5		= @ATTRIBUTE5;
	SET @p_attribute6		= @ATTRIBUTE6;
	SET @p_attribute7		= @ATTRIBUTE7;
	SET @p_attribute8		= @ATTRIBUTE8;
	SET @p_attribute9		= @ATTRIBUTE9;
	SET @p_attribute10		= @ATTRIBUTE10;
	SET @p_attribute11		= @ATTRIBUTE11;
	SET @p_attribute12		= @ATTRIBUTE12;
	SET @p_attribute13		= @ATTRIBUTE13;
	SET @p_attribute14		= @ATTRIBUTE14;
	SET @p_attribute15		= @ATTRIBUTE15;
	SET @p_created_by		= @CREATED_BY;
	SET @p_creation_date	= @CREATION_DATE;
	SET @p_last_updated_by	= @LAST_UPDATED_BY;


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM0003_DELETE_LOOKUP_MASTER_DETAIL';
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


		----HISTORY INSERT	-- Detail 삭제시 이력정보 저장하지 않도록 수정(2025-06-11 요청)
		--EXEC [SCP0120_SCP_OPT_LOOKUP_MASTER_DETAIL_HIST]
		--								@p_lookup_type			
		--								,@p_description		
		--								,@p_display_seq			
		--								,@p_valid_yn											 	
		--								,@p_segment1				
		--								,@p_segment2			
		--								,@p_segment3		
		--								,@p_segment4      
		--								,@p_segment5
		--								,@p_segment6
		--								,@p_segment7
		--								,@p_segment8
		--								,@p_segment9
		--								,@p_segment10
		--								,@p_attribute1
		--								,@p_attribute2
		--								,@p_attribute3
		--								,@p_attribute4
		--								,@p_attribute5
		--								,@p_attribute6
		--								,@p_attribute7
		--								,@p_attribute8
		--								,@p_attribute9
		--								,@p_attribute10
		--								,@p_attribute11
		--								,@p_attribute12
		--								,@p_attribute13
		--								,@p_attribute14
		--								,@p_attribute15
		--								,@p_created_by			
		--								,@p_creation_date		
		--								,@p_last_updated_by     ;


		BEGIN
			DELETE FROM [SCP_OPMZ_LOOKUP_MASTER_DETAIL] 
			WHERE LOOKUP_TYPE = @LOOKUP_TYPE
			  AND SEGMENT1 = @SEGMENT1_KEY
			  AND SEGMENT2 = @SEGMENT2_KEY
			  AND SEGMENT3 = @SEGMENT3_KEY
			  AND SEGMENT4 = @SEGMENT4_KEY
			  AND SEGMENT5 = @SEGMENT5_KEY
			  AND SEGMENT6 = @SEGMENT6_KEY
			  AND SEGMENT7 = @SEGMENT7_KEY
			  AND SEGMENT8 = @SEGMENT8_KEY
			  AND SEGMENT9 = @SEGMENT9_KEY
			  AND SEGMENT10 = @SEGMENT10_KEY;
		END		

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 결과코드, 결과 카운트 반환
			SELECT  'S' AS result_code ;

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

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
	END






