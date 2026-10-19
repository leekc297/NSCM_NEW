/*
 * Program ID   : PR_DM_MST_BUCKET_CONVERSION_HIST
 * Description  : PR_DM_MST_BUCKET_CONVERSION_HIST History 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.25   okaniel      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 
 */
CREATE PROCEDURE [dbo].[PR_DM_MST_BUCKET_CONVERSION_HIST]
	@p_division_id			NVARCHAR(MAX),
	@p_scm_site_id			NVARCHAR(MAX),
	@p_Incoterms            NVARCHAR(MAX),
	@p_yyyymmdd				NVARCHAR(MAX),
	@p_bucket_per			NVARCHAR(MAX),
	@p_conversion_type		NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX)
	-- 자식 프로시저 성공/에러 셋팅
	--@p_OK_description		NVARCHAR(1200) OUTPUT		

AS

BEGIN

	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_BUCKET_CONVERSION_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @n_history_seq	INTEGER;
	
	--[C20200909-000203] LOG 표준화 적용
		-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 트랜잭션 (START)
		BEGIN TRANSACTION BUCKET_CONVERSION_HIST;

		BEGIN TRY

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				   
				
			BEGIN    
				SET @n_history_seq = NEXT VALUE FOR SEQ1_DM_MST_BUCKET_CONVERSION_H
				
				   BEGIN

					INSERT	INTO  DM_MST_BUCKET_CONVERSION_H
					(									   
								 DIVISION_ID,
								 HISTORY_SEQ,
								 SCM_SITE_ID,
								 PROJECT_CODE,
								 INCOTERMS,
								 ITEM_ID,
								 YYYYMMDD,
								 BUCKET_PER,
								 CONVERSION_TYPE,
								 VALID_YN,
								 created_by,creation_date,last_updated_by,last_update_date
					)
					VALUES  
					(
								 @p_division_id,
								 @n_history_seq, 
								 @p_scm_site_id, 
								 '***', 
								 @p_Incoterms,
								 '***',
								 @p_yyyymmdd,
								 @p_bucket_per,
								 @p_conversion_type,
								 'Y',
								 @p_created_by,SYSDATETIME(),@p_created_by,SYSDATETIME()
				   );
				  
				   END

			END

				--SET @v_log_type = 'END';
				--SET @v_log_message = '########## END of procedure ##########';
				--SET @v_description = '';
				--SET @d_event_date = SYSDATETIME();
				----EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

				--SET @p_OK_description = 'OK';		-- 정상적인 로그처리 됐을때 'OK'를 셋팅한다

				--RETURN;

          COMMIT WORK;

		END TRY

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	--[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION  BUCKET_CONVERSION_HIST;

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
