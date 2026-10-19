
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0104_CHECK_NAME_ON_DUMMY_CODE
 * Description  : name 으로 검색후 없으면 dummy code 마스터 테이블에 추가후 code 를 포함한 데이터셋 리턴
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/04/03   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/07/18   chaan        V1.1.4                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 키값 상관없이 중복성을 CODE_TP 제외한 CODE 만으로 체크 => 시퀀스 추가함
 * 2024/08/05   chaan        V1.1.5                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - FLOAT 로 변형
*/

--CREATE PROCEDURE [dbo].[SCP0104_CHECK_NAME_ON_DUMMY_CODE]
CREATE PROCEDURE [dbo].[SCP0104_CHECK_NAME_ON_DUMMY_CODE]
	  @p_code_tp				NVARCHAR(1)
	, @p_name				    NVARCHAR(100)
	, @p_program_id				NVARCHAR(100)
	, @p_sheet_name				NVARCHAR(100)
	, @p_user_id				NVARCHAR(30)
	, @debug_mode				NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_code_tp			NVARCHAR(1)             = N'P';
	--DECLARE @p_name				NVARCHAR(100)           = N'DUMMY_TEST_X_01';
	--DECLARE @p_program_id		NVARCHAR(100)	    	= N'SCP0104';
	--DECLARE @p_sheet_name		NVARCHAR(100)	    	= N'MAIN';
 --   DECLARE @p_user_id			NVARCHAR(30)	    	= N'iamarock';
 --   DECLARE @debug_mode			NVARCHAR(1)		    	= N'F';



 	DECLARE @test_mode                          NVARCHAR(20)		= N'F';


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)	= 'SCP0104_CHECK_NAME_ON_DUMMY_CODE';
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


        DECLARE @v_max_seq      NVARCHAR(30)    = N'';
        DECLARE @v_new_code     NVARCHAR(30)    = N'';

--TESTING : NOK
--SELECT    MAX(CODE)
--        , LEN(MAX(CODE))
--        , SUBSTRING(MAX(CODE), 7, LEN(MAX(CODE))-6)
--FROM    SCP_MST_CAPA_DUMMY_CODE WITH(NOLOCK)
--GROUP BY CODE;
        
--rollback tran;return;

        --SELECT  @v_max_seq  = ISNULL(MAX(CONVERT(BIGINT, CODE)), 0)
        --FROM    (
        --            SELECT  CASE
        --                        WHEN CHARINDEX('DMY_', CODE) = 1 THEN SUBSTRING(CODE, 5, LEN(CODE) - 4)
        --                        ELSE '0'
        --                    END AS CODE
        --            FROM    SCP_MST_CAPA_DUMMY_CODE WITH(NOLOCK)
        --            WHERE   1=1
        --                -- 코드구분없이 배번 AND CODE_TP = @p_code_tp
        --        ) A;

        --SET @v_new_code = CONCAT('DMY_', CONVERT(INT, @v_max_seq) + 1);
        SET @v_new_code = CONCAT('DMY_', NEXT VALUE FOR SEQ1_SCP_MST_CAPA_DUMMY_CODE);
        

        PRINT CONCAT('@@v_max_seq : ', @v_max_seq);
        PRINT CONCAT('@v_new_code : ', @v_new_code);
--rollback tran;return;

		MERGE INTO SCP_MST_CAPA_DUMMY_CODE A
		USING
		(
			SELECT    @p_code_tp        AS CODE_TP
                    , @v_new_code       AS CODE
				    , @p_name           AS NAME
                    , 'Y'               AS VALID_YN
				    , @p_user_id        AS CREATED_BY
				    , SYSDATETIME()     AS CREATION_DATE
				    , @p_user_id        AS LAST_UPDATED_BY
				    , SYSDATETIME()     AS LAST_UPDATE_DATE
		) B ON
		(
				A.CODE_TP	    = B.CODE_TP
			AND A.NAME		    = B.NAME
		)
		WHEN NOT MATCHED THEN
		INSERT
		(
			  CODE_TP
			, CODE
			, NAME
            , VALID_YN
            , CREATED_BY
            , CREATION_DATE
            , LAST_UPDATED_BY
            , LAST_UPDATE_DATE
		)
		VALUES
		(
			  B.CODE_TP
			, B.CODE
			, B.NAME
            , B.VALID_YN
            , B.CREATED_BY
            , B.CREATION_DATE
            , B.LAST_UPDATED_BY
            , B.LAST_UPDATE_DATE
		);

--TESTING : NOK
--select * from SCP_MST_CAPA_DUMMY_CODE;rollback tran;return;
        
        DECLARE @v_cnt INT = 0;

        SELECT  @v_cnt = COUNT(*)
        FROM    SCP_MST_CAPA_DUMMY_CODE
        WHERE   1=1
            AND CODE = @v_new_code;


        IF @v_cnt = 0 -- 기존에 동일한 명칭이 존재하는 경우
        BEGIN
            SELECT  *
            FROM    SCP_MST_CAPA_DUMMY_CODE
            WHERE   1=1
                AND NAME = @p_name;
        END
        ELSE
        BEGIN
            SELECT  *
            FROM    SCP_MST_CAPA_DUMMY_CODE
            WHERE   1=1
                AND CODE = @v_new_code;
        END


        -- LOG end
		SET @v_log_type     = 'END'
		SET @v_log_message  = '########## END of procedure ##########'
		SET @v_description  = ''
		SET @d_event_date   = SYSDATETIME()

        IF @test_mode <> 'T'
        BEGIN
		    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

		COMMIT TRAN;

		-- 결과코드, 결과 카운트 반환
		--SELECT  'S' AS result_code,  @v_all_cnt AS result_cnt;
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
END

