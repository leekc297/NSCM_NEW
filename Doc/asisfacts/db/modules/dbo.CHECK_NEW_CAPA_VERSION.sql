
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : CHECK_NEW_CAPA_VERSION
 * Description  : CAPA_VERSION 하나도 없으면 추가
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/19   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 */

--CREATE PROCEDURE [dbo].[CHECK_NEW_CAPA_VERSION]
CREATE PROCEDURE [dbo].[CHECK_NEW_CAPA_VERSION]
	  @p_division_id		NVARCHAR(30)
	, @p_yyyymm				NVARCHAR(10)
    , @p_return_result_code NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_division_id			NVARCHAR(30)		= '81';
	--DECLARE @p_yyyymm				NVARCHAR(10)		= '202405';
	--DECLARE @p_return_result_code	NVARCHAR(1)		    = 'F';


 	DECLARE @test_mode                          NVARCHAR(20)		= N'F';


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)	= 'CHECK_NEW_CAPA_VERSION';
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

		DECLARE		@v_version_cnt				INT				= 0;
		DECLARE		@v_last_version				NVARCHAR(10)	= '';
		DECLARE		@v_last_version_seq			INT				= NULL;
		DECLARE		@v_last_version_prog_stat	NVARCHAR(2)		= '';

		SELECT	@v_version_cnt	= COUNT(*)
		FROM	dbo.FN_SCP0104_GET_CAPA_VERSION(@p_division_id, @p_yyyymm);
		
        PRINT CONCAT('@v_version_cnt : ', @v_version_cnt);
        --rollback tran;return;

		--사업부/연월에 해당하는 버전이 하나도 없으면 버전 마스터(SCP_MST_CAPA_VERSION) 추가
		IF @v_version_cnt = 0
		BEGIN
			SET @v_version_cnt				= 1;
            --DIVISION_ID	
            --VER_ID	
            --VER_SEQ	
            --PROG_STAT	
            --SCP_FIN_PLAN_ID	
            --SCP_PRDN_PLAN_REF_ST_YM	
            --SCP_PRDN_PLAN_REF_END_YM	
            --BIZ_PLAN_USE_YN	
            --ATTRIBUTE1	ATTRIBUTE2	ATTRIBUTE3	ATTRIBUTE4	ATTRIBUTE5	ATTRIBUTE6	ATTRIBUTE7	ATTRIBUTE8	ATTRIBUTE9	ATTRIBUTE10	CREATED_BY	CREATION_DATE	LAST_UPDATED_BY	LAST_UPDATE_DATE
			INSERT INTO SCP_MST_CAPA_VERSION
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
			SELECT	  @p_division_id
					, @p_yyyymm
					, 1
					, 0
				    , 'iamarock'
				    , SYSDATETIME()
				    , 'iamarock'
                    , SYSDATETIME()
		END


        -- LOG end
		SET @v_log_type     = 'END'
		SET @v_log_message  = '########## END of procedure ##########'
		SET @v_description  = ''
		SET @d_event_date   = SYSDATETIME()

        IF @test_mode <> 'T'
        BEGIN
            PRINT @v_log_message;

		    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

		COMMIT TRAN;

		-- 결과코드, 결과 카운트 반환 => UI 에서 체크할 경우만 @p_return_result_code = 'T' 로 줘서 에러 체크 가능하도록 한다
        IF @p_return_result_code = 'T'
        BEGIN
		    SELECT  'S' AS result_code,  1 AS result_cnt;
        END
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


		-- 결과코드, 결과 카운트 반환 => UI 에서 체크할 경우만 @p_return_result_code = 'T' 로 줘서 에러 체크 가능하도록 한다
        IF @p_return_result_code = 'T'
        BEGIN
            -- error코드, errror 메시지 반환
            SELECT 'F' AS result_code;

            SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
        END
	END CATCH;
END

