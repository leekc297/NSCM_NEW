
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0104_ADD_CAPA_NEW_VERSION
 * Description  : CAPA LINE ASSING
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/16   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/08/05   chaan        V1.1.5                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - FLOAT 로 변형
*/

--CREATE PROCEDURE [dbo].[SCP0104_ADD_CAPA_NEW_VERSION]
CREATE PROCEDURE [dbo].[SCP0104_ADD_CAPA_NEW_VERSION]
	  @p_division_id		NVARCHAR(30)
	, @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
	, @p_user_id			NVARCHAR(30)
	, @debug_mode			NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_division_id		    NVARCHAR(30)		    = N'81';
 --   DECLARE @p_program_id			NVARCHAR(100)			= N'SCP0104';
 --   DECLARE @p_sheet_name			NVARCHAR(100)			= N'MAIN';
 --   DECLARE @p_user_id			    NVARCHAR(30)		    = N'iamarock';
 --   DECLARE @debug_mode			    NVARCHAR(1)			    = N'F';


	DECLARE @test_mode                          NVARCHAR(20)		= N'F';
	--DECLARE @test_mode                          NVARCHAR(20)	= N'T';


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)	= 'SCP0104_ADD_CAPA_NEW_VERSION';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER			= 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type						= 'START';
		SET @v_log_message					= '########## Start of procedure ##########';
		SET @v_description					= '';
		SET @d_event_date					= SYSDATETIME();

        IF @test_mode <> 'T'
        BEGIN
		    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        DECLARE     @v_last_version     NVARCHAR(6)         = N'';

		IF OBJECT_ID('tempdb..#T_SCP0104_VERSION') IS NOT NULL
			DROP TABLE #T_SCP0104_VERSION;

	    SELECT	@v_last_version = MAX(A.VER_ID)
	    FROM	SCP_MST_CAPA_VERSION A
                JOIN (
	                    SELECT	  B.SEGMENT1 AS CODE
			                    , B.SEGMENT2 AS NAME
                        FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
                                        A.LOOKUP_TYPE = B.LOOKUP_TYPE
	                    WHERE	1=1
		                    AND A.LOOKUP_GROUP  = 'SCP'
		                    AND A.LOOKUP_TYPE   = 'CAPA_PROG_STAT'
		                    AND B.VALID_YN      = 'Y'
                     ) B ON
                        A.PROG_STAT = B.CODE
        WHERE   1=1
            AND A.DIVISION_ID = @p_division_id;

        PRINT CONCAT('@v_last_version : ', @v_last_version);

        DECLARE     @v_new_version     NVARCHAR(6)         = N'';

        SELECT  @v_new_version  = MIN(BASIS_YYYYMM)
        FROM    SCM_SYS_CALENDAR_M B WITH(NOLOCK)
        WHERE   1=1
            AND BASIS_YYYYMM > @v_last_version;

        PRINT CONCAT('@v_new_version : ', @v_new_version);

    	PRINT 'SAVE - SCP_MST_CAPA_VERSION - BEGIN';
		MERGE INTO SCP_MST_CAPA_VERSION A
		USING
		(
            SELECT	  @p_division_id        AS DIVISION_ID
	                , @v_new_version        AS VER_ID
	                , 1                     AS VER_SEQ
	                , '0'                   AS PROG_STAT
				    , @p_user_id            AS CREATED_BY
				    , SYSDATETIME()         AS CREATION_DATE
                    , @p_user_id            AS LAST_UPDATED_BY
                    , SYSDATETIME()         AS LAST_UPDATE_DATE
        ) B ON
		(
				A.DIVISION_ID		= B.DIVISION_ID
			AND A.VER_ID		    = B.VER_ID
			AND A.VER_SEQ			= B.VER_SEQ
		)
		WHEN MATCHED THEN
		UPDATE
		SET
				  PROG_STAT				= B.PROG_STAT
				, LAST_UPDATED_BY		= B.LAST_UPDATED_BY
				, LAST_UPDATE_DATE		= B.LAST_UPDATE_DATE
		WHEN NOT MATCHED THEN
		INSERT
		(
                  DIVISION_ID
				, VER_ID
				, VER_SEQ
				, PROG_STAT
				, CREATED_BY
				, CREATION_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
			)
			VALUES
			(
				  B.DIVISION_ID
				, B.VER_ID
				, B.VER_SEQ
				, B.PROG_STAT
				, B.CREATED_BY
				, B.CREATION_DATE
				, B.LAST_UPDATED_BY
				, B.LAST_UPDATE_DATE
			);
    		PRINT 'SAVE - SCP_MST_CAPA_VERSION - END';

--TESTING : NOK
--select * from SCP_MST_CAPA_VERSION;rollback tran;return;

        -- LOG end
		SET @v_log_type     = 'END'
		SET @v_log_message  = '########## END of procedure ##########'
		SET @v_description  = ''
		SET @d_event_date   = SYSDATETIME()

        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date


		COMMIT TRAN;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  1 AS result_cnt;
	END TRY
	BEGIN CATCH
		  IF (XACT_STATE() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
		  BEGIN
			INSERT INTO SCM_SYS_LOG_BATCH
			(
				  PROGRAM_NAME
				, LOG_TYPE
				, LOG_COUNT
				, LOG_MESSAGE
				, DESCRIPTION
				, EVENT_DATE
				, CREATION_DATE
				, CREATED_BY
				, LAST_UPDATE_DATE
				, LAST_UPDATED_BY
			)
			VALUES
			(
				  ISNULL(ERROR_PROCEDURE(), 'SCP0006_SAVE_PROJECT_ROUTE_PLANT')
	 			, 'ERROR'
	 			, NULL
	 			, ERROR_MESSAGE()
	 			, NULL
	 			, SYSDATETIME()
	 			, SYSDATETIME()
	 			, ERROR_PROCEDURE()
	 			, SYSDATETIME()
				, ERROR_PROCEDURE()
			)

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		  END;


		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;

		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;

	IF OBJECT_ID('tempdb..#T_SCP0104_VERSION') IS NOT NULL
		DROP TABLE #T_SCP0104_VERSION;
END

