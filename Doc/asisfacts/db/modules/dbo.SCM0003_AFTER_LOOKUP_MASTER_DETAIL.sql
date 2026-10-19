
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCM0003_AFTER_LOOKUP_MASTER_DETAIL
 * Description  : Lookup 저장후 공통(SCM) 과 별도로 추가로 후처리할 내용이 있으면 이곳에 추가
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/10/10   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2025/02/10   mrchois      V1.1.2                PJ20249346  LGES SCP 개선과제 이행	 - Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정
*/


--CREATE PROCEDURE [dbo].[SCM0003_AFTER_LOOKUP_MASTER_DETAIL]
CREATE PROCEDURE [dbo].[SCM0003_AFTER_LOOKUP_MASTER_DETAIL]
	  @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
	, @p_user_id			NVARCHAR(30)
	, @debug_mode			NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_program_id		NVARCHAR(100)		= N'SCM0003';
	--DECLARE @p_sheet_name		NVARCHAR(100)		= N'SCP_CAPA_LOSS_MEASURE';
 --   DECLARE @p_user_id			NVARCHAR(30)		= N'iamarock';
 --   DECLARE @debug_mode			NVARCHAR(1)			= N'F';

 
 DECLARE @test_mode                          NVARCHAR(20)		= N'F';
	--DECLARE @test_mode                          NVARCHAR(20)	= N'T';


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)	= 'SCM0003_AFTER_LOOKUP_MASTER_DETAIL';
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

		DECLARE @v_all_cnt		        INTEGER		= 0;

		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) START
        --BEGIN-- 시스템별 추가 작업할 내용들을 별도의 프로시저로 만들어 여기서 호출
        --    IF @p_sheet_name = N'SCP_CAPA_LOSS_MEASURE'
        --    BEGIN-- SCP Capa I/G 변경
        --        PRINT 'EXEC dbo.PR_SCP_MST_CAPA_LOSS_MEASURE_IG_CHNG_AP';
        --        EXEC dbo.PR_SCP_MST_CAPA_LOSS_MEASURE_IG_CHNG_AP @p_user_id;
        --    END
        --    ELSE IF @p_sheet_name = N'SCP_CAPA_ELTR_LOSS_MEASURE'
        --    BEGIN
        --        PRINT 'EXEC dbo.PR_SCP_MST_CAPA_LOSS_MEASURE_IG_CHNG_ELTR';
        --        EXEC dbo.PR_SCP_MST_CAPA_LOSS_MEASURE_IG_CHNG_ELTR @p_user_id;
        --    END-- SCP Capa I/G 변경
        --END-- 시스템별 추가 작업할 내용들을 별도의 프로시저로 만들어 여기서 호출
		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) END


        -- LOG end
		SET @v_log_type     = 'END'
		SET @v_log_message  = '########## END of procedure ##########'
		SET @v_description  = ''
		SET @d_event_date   = SYSDATETIME()

        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date

		COMMIT TRAN;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @v_all_cnt AS result_cnt;
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
				  ISNULL(ERROR_PROCEDURE(), 'SCM0003_AFTER_LOOKUP_MASTER_DETAIL')
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

		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + CONCAT('[ERROR LINE : ', ERROR_PROCEDURE(), ' - ', ERROR_LINE(), ']') + ERROR_MESSAGE();
	END CATCH;
END

