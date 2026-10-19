
/*
 * Program ID   : PR_DM_MST_SITE_HRCY_HIST
 * Description  : SCM_MST_SITE_HRCYLEVEL HISTORY INSERT
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 11. 24    DWOK/DWPARK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_MST_SITE_HRCY_HIST]

	--@p_active_flag			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_site_hrcy_id			NVARCHAR(MAX),
	@p_site_type			NVARCHAR(MAX),
	@p_parent_id			NVARCHAR(MAX),
	@p_hrcy_level			NVARCHAR(MAX),
	@p_hrcy_description		NVARCHAR(MAX),
	@p_valid_yn				NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX)
AS

BEGIN

	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_site_hrcy_id			NVARCHAR(MAX);
	DECLARE @v_site_type			NVARCHAR(MAX);
	DECLARE @v_hrcy_level			NVARCHAR(MAX);
	DECLARE @v_hrcy_description		NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	DECLARE @n_history_seq			INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_SITE_HRCY_HIST';
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
		BEGIN TRANSACTION PR_DM_MST_SITE_HRCY_HIST;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

			BEGIN    
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_MST_SITE_HRCYLEVEL_H
				   BEGIN
						
						--[2018-03-19][수정]
						--MERGE INTO [dbo].[SCM_MST_SITE_HRCYLEVEL_H] A
						--USING (
						--		SELECT
						--			 @p_division_id			AS DIVISION_ID
						--			,@p_site_hrcy_id		AS SITE_HRCY_ID
						--			,@p_site_type			AS SITE_TYPE
						--			,@p_parent_id			AS PARENT_ID
						--			,@p_hrcy_level			AS HRCY_LEVEL
						--			,@p_hrcy_description	AS HRCY_DESCRIPTION
						--			,@p_valid_yn			AS VALID_YN
						--	  ) B
						--ON (
						--			A.DIVISION_ID		= B.DIVISION_ID
						--		AND A.SITE_HRCY_ID		= B.SITE_HRCY_ID
						--		AND A.SITE_TYPE			= B.SITE_TYPE
						--		AND A.PARENT_ID			= B.PARENT_ID
						--		AND A.HRCY_LEVEL		= B.HRCY_LEVEL
						--		AND A.SITE_HRCY_ID		= B.SITE_HRCY_ID
						--		AND A.HRCY_DESCRIPTION  = B.HRCY_DESCRIPTION
						--   )
						----WHEN MATCHED THEN
						--	--UPDATE SET
						--	--			 last_updated_by = @p_created_by
						--	--			,last_update_date = sysdatetime()
						--WHEN NOT MATCHED THEN
						--	INSERT	  (
						--			   [DIVISION_ID] ,[HISTORY_SEQ] ,[SITE_HRCY_ID] 
						--			  ,SITE_TYPE ,[PARENT_ID]
						--			  ,[HRCY_LEVEL] ,[HRCY_DESCRIPTION] ,[VALID_YN] ,[CREATED_BY]
						--			  ,[CREATION_DATE] ,[LAST_UPDATED_BY] ,[LAST_UPDATE_DATE])
						--	VALUES  
						--			  (
						--			   @p_division_id , @n_history_seq, @p_site_hrcy_id 
						--			  ,@p_site_type ,@p_parent_id
						--			  ,@p_hrcy_level ,@p_hrcy_description ,@p_valid_yn ,@p_created_by
						--			  ,SYSDATETIME() ,@p_created_by ,SYSDATETIME()
						--			  );

							INSERT	INTO  [dbo].[SCM_MST_SITE_HRCYLEVEL_H]
							(									   
									   [DIVISION_ID] ,[HISTORY_SEQ] ,[SITE_HRCY_ID] 
									  ,SITE_TYPE ,[PARENT_ID]
									  ,[HRCY_LEVEL] ,[HRCY_DESCRIPTION] ,[VALID_YN] ,[CREATED_BY]
									  ,[CREATION_DATE] ,[LAST_UPDATED_BY] ,[LAST_UPDATE_DATE]
							)
							VALUES  
							(
									   @p_division_id , @n_history_seq, @p_site_hrcy_id 
									  ,@p_site_type ,@p_parent_id
									  ,@p_hrcy_level ,@p_hrcy_description ,@p_valid_yn ,@p_created_by
									  ,SYSDATETIME() ,@p_created_by ,SYSDATETIME()
						   );



				   END
						
			END

		COMMIT WORK;

		END TRY

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	--[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION  PR_DM_MST_SITE_HRCY_HIST;

      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
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






