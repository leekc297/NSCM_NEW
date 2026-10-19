
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0104_CHECK_CAPA_LINE_SOP_BY_ASSIGN_ELTR
 * Description  : ASSIGN 테이블 구조의 데이터를 파라미터로 Speed Plan Insert/Update
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/08/26   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 */

--DROP PROCEDURE [dbo].[SCP0104_CHECK_CAPA_LINE_SOP_BY_ASSIGN_ELTR]
--CREATE PROCEDURE [dbo].[SCP0104_CHECK_CAPA_LINE_SOP_BY_ASSIGN_ELTR]
CREATE PROCEDURE [dbo].[SCP0104_CHECK_CAPA_LINE_SOP_BY_ASSIGN_ELTR]
	  @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN   dbo.SCP_MST_CAPA_LINE_ASSIGN_TYPE READONLY

	, @p_program_id				NVARCHAR(100)
	, @p_sheet_name				NVARCHAR(100)
	, @p_user_id				NVARCHAR(30)
	, @debug_mode				NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

--	DECLARE @p_program_id		NVARCHAR(100)	    	= N'SCP0106';
--	DECLARE @p_sheet_name		NVARCHAR(100)	    	= N'CURRENT';
--    DECLARE @p_user_id			NVARCHAR(30)	    	= N'iamarock';
--    DECLARE @debug_mode			NVARCHAR(1)		    	= N'F';



--	DECLARE @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN   dbo.SCP_MST_CAPA_LINE_ASSIGN_TYPE;

--    INSERT INTO @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
--    SELECT	  '202408'		AS VER_ID
--			, 3				AS VER_SEQ
--            , DIVISION_ID
--			, COMPANY_ID
--			, SITE_ID
--			, PLANT_ID
--			, FACTORY_ID
--			, LINE_ID
--			, OPERATION_ID
--			, ELTR_LN_TP_CD
--			, ITEM_ID
--			, NICK_NAME
--			, YYYYMM
--			, ASSIGN_PRIORITY
--			, DUMMY_YN
--			, VALID_YN
--			, CREATED_BY
--			, CREATION_DATE
--			, LAST_UPDATED_BY
--			, LAST_UPDATE_DATE
--    FROM	SCP_MST_CAPA_ELTR_LINE_ASSIGN WITH(NOLOCK)
--    WHERE   1=1
--        AND DIVISION_ID = '81'
--        AND SITE_ID     = 'A001'
--        AND PLANT_ID    = 'A040'
--        AND FACTORY_ID  = 'A2'
--        AND LINE_ID     = 'A2A10'
--        AND ELTR_LN_TP_CD IN ('Anode')
--        AND NICK_NAME   = 'F2-1'
--        AND YYYYMM      = '202503'

--------------TESTING : NOK
----select * from @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN;return;


	DECLARE @v_division_id		NVARCHAR(MAX)		    = N'';

 	DECLARE @test_mode                          NVARCHAR(20)		= N'F';


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)	= 'SCP0104_CHECK_CAPA_LINE_SOP_BY_ASSIGN_ELTR';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER			= 0;    
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @V_ELAPSED_TIME_BEG     DATETIME                = CURRENT_TIMESTAMP;


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


        ;WITH tblKeys AS
        (
            SELECT	  DIVISION_ID
			        , COMPANY_ID
			        , SITE_ID
			        , PLANT_ID
			        , FACTORY_ID
			        , LINE_ID
			        , OPERATION_ID
			        , ELTR_LN_TP_CD
			        , MAX(CREATED_BY)           AS CREATED_BY
			        , MAX(CREATION_DATE)        AS CREATION_DATE
			        , MAX(LAST_UPDATED_BY)      AS LAST_UPDATED_BY
			        , MAX(LAST_UPDATE_DATE)     AS LAST_UPDATE_DATE
            FROM	@TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
            WHERE   1=1
                AND VALID_YN = 'Y'
                AND ISNULL(ASSIGN_PRIORITY, 0) <> 0
            GROUP BY  DIVISION_ID
			        , COMPANY_ID
			        , SITE_ID
			        , PLANT_ID
			        , FACTORY_ID
			        , LINE_ID
			        , OPERATION_ID
			        , ELTR_LN_TP_CD
        )
		    MERGE INTO SCP_MST_CAPA_ELTR_LINE_SOP A
		    USING
		    (
			    SELECT	  DIVISION_ID
			            , COMPANY_ID
			            , SITE_ID
			            , PLANT_ID
			            , FACTORY_ID
			            , LINE_ID
			            , OPERATION_ID
			            , ELTR_LN_TP_CD
                        , CREATED_BY
				        , CREATION_DATE
				        , LAST_UPDATED_BY
				        , LAST_UPDATE_DATE
                FROM    tblKeys
		    ) B ON
		    (
				    A.DIVISION_ID		    = B.DIVISION_ID
			    AND A.COMPANY_ID			= B.COMPANY_ID
			    AND A.SITE_ID				= B.SITE_ID
			    AND A.PLANT_ID				= B.PLANT_ID
			    AND A.FACTORY_ID			= B.FACTORY_ID
			    AND A.LINE_ID				= B.LINE_ID
			    AND A.OPERATION_ID			= B.OPERATION_ID
			    ------AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
		    )
		    WHEN NOT MATCHED THEN
		    INSERT
		    (
	              DIVISION_ID
	            , COMPANY_ID
	            , SITE_ID
	            , PLANT_ID
	            , FACTORY_ID
	            , LINE_ID
	            , OPERATION_ID
	            , ELTR_LN_TP_CD
	            , VALID_YN
	            , SOP_DT
	            , SOP_YM
	            , SOP_DDN
			    , CREATED_BY
			    , CREATION_DATE
			    , LAST_UPDATED_BY
			    , LAST_UPDATE_DATE
		    )
		    VALUES
		    (
	              DIVISION_ID
	            , COMPANY_ID
	            , SITE_ID
	            , PLANT_ID
	            , FACTORY_ID
	            , LINE_ID
	            , OPERATION_ID
	            , ELTR_LN_TP_CD
	            , 'Y'
	            , NULL
	            , NULL
	            , NULL
				, CONCAT(@v_program_name, '-', @p_user_id)
				, SYSDATETIME()
				, CONCAT(@v_program_name, '-', @p_user_id)
				, SYSDATETIME()
		    );

--TESTING : NOK
--select * from tblKeys;rollback tran;return;
--select * from SCP_MST_CAPA_ELTR_LINE_SOP;rollback tran;return;


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

