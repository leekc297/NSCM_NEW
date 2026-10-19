
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ASSEMBLY
 * Description  : ASSIGN 테이블 구조의 데이터를 파라미터로 Speed Plan Insert/Update
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/19   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/08/03   chaan        V1.1.5                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 뷰로 대체
 * 2024/08/12   chaan        V1.1.6                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - PPM 조회 방식을 Speed Plan 저장된 값으로 대체
*/

--DROP PROCEDURE [dbo].[SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ASSEMBLY]
--CREATE PROCEDURE [dbo].[SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ASSEMBLY]
CREATE PROCEDURE [dbo].[SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ASSEMBLY]
	  @TBL_SCP_MST_CAPA_LINE_ASSIGN   dbo.SCP_MST_CAPA_LINE_ASSIGN_TYPE READONLY
	, @p_program_id				NVARCHAR(100)
	, @p_sheet_name				NVARCHAR(100)
	, @p_user_id				NVARCHAR(30)
	, @debug_mode				NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

--	DECLARE @p_program_id		NVARCHAR(100)	    	= N'SCP0105';
--	DECLARE @p_sheet_name		NVARCHAR(100)	    	= N'ASSEMBLY';
--    DECLARE @p_user_id			NVARCHAR(30)	    	= N'iamarock';
--    DECLARE @debug_mode			NVARCHAR(1)		    	= N'F';



--	DECLARE @TBL_SCP_MST_CAPA_LINE_ASSIGN   dbo.SCP_MST_CAPA_LINE_ASSIGN_TYPE;

--    INSERT INTO @TBL_SCP_MST_CAPA_LINE_ASSIGN
--    SELECT	  '202408'		AS VER_ID
--			, 7				AS VER_SEQ
--			, DIVISION_ID
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
--    FROM	SCP_MST_CAPA_LINE_ASSIGN WITH(NOLOCK)
--    WHERE   1=1
--	    AND DIVISION_ID		= N'81'
--	    AND SITE_ID			= N'A001'
--	    AND PLANT_ID  		= N'A040'
--	    AND FACTORY_ID		= N'A2'
--	    AND LINE_ID			= N'A2A10'
--	    AND OPERATION_ID	= N'A5000'
--        AND NICK_NAME		= N'LV15A'
--	    AND ELTR_LN_TP_CD	= N'Anode'
--        AND YYYYMM			= '202409'


----------TESTING : NOK
----select * from @TBL_SCP_MST_CAPA_LINE_ASSIGN;return;



 	DECLARE @test_mode          NVARCHAR(20)		= N'F';


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)	= 'SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ASSEMBLY';
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


		IF OBJECT_ID('tempdb..#tblSCP0105_NOT_VALID') IS NOT NULL
			DROP TABLE #tblSCP0105_NOT_VALID;

		SELECT    DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, NICK_NAME
		INTO	#tblSCP0105_NOT_VALID
		FROM    @TBL_SCP_MST_CAPA_LINE_ASSIGN
		WHERE   1<>1

		INSERT INTO #tblSCP0105_NOT_VALID
		SELECT    DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, NICK_NAME
		FROM    @TBL_SCP_MST_CAPA_LINE_ASSIGN
		WHERE   1=1
			AND VALID_YN <> 'Y'
		GROUP BY  DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, NICK_NAME

--TESTING : NOK
--select * from #tblSCP0105_NOT_VALID;rollback tran;return;


		IF OBJECT_ID('tempdb..#tblSCP0105_RAW') IS NOT NULL
			DROP TABLE #tblSCP0105_RAW;

		SELECT	  S.VER_ID
				, S.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.ITEM_ID
				, A.NICK_NAME
				, A.MSR_TP_CD
				, A.YYYYMM
				, A.BASE_QTY
				, A.QTY									AS PFRSLT_QTY
				, A.QTY
				, A.UI_UPD_YN
				, A.REMARK
				, A.CREATED_BY
				, A.CREATION_DATE
				, A.LAST_UPDATED_BY
				, A.LAST_UPDATE_DATE
		INTO    #tblSCP0105_RAW
		FROM	SCP_MST_CAPA_SPEED_PLAN A WITH(NOLOCK)
                LEFT JOIN @TBL_SCP_MST_CAPA_LINE_ASSIGN S ON
						A.DIVISION_ID		= S.DIVISION_ID
					AND A.COMPANY_ID		= S.COMPANY_ID
					AND A.SITE_ID			= S.SITE_ID
					AND A.PLANT_ID			= S.PLANT_ID
					AND A.FACTORY_ID		= S.FACTORY_ID
					AND A.LINE_ID			= S.LINE_ID
					AND A.OPERATION_ID		= S.OPERATION_ID
					AND A.ELTR_LN_TP_CD	    = S.ELTR_LN_TP_CD
					AND A.NICK_NAME         = S.NICK_NAME
					AND A.YYYYMM            = S.YYYYMM
        WHERE   1<>1
--TESTING : NOK
--select * from #tblSCP0105_RAW;rollback tran;return;


		;WITH tblVersion AS
		(
			SELECT    MAX(VER_ID)                                                                       AS VER_ID
					, MAX(VER_SEQ)                                                                      AS VER_SEQ
					, DIVISION_ID
					, MIN(SUBSTRING(YYYYMM, 1, 4))                                                      AS FROM_YYYY
					, MAX(SUBSTRING(YYYYMM, 1, 4))                                                      AS TO_YYYY
					, CONVERT(CHAR(8), DATEADD(MM, -1, CONVERT(DATETIME, (MAX(VER_ID)) + '01')), 112)   AS RESULT_TO_YYYYMM
			FROM    @TBL_SCP_MST_CAPA_LINE_ASSIGN
            GROUP BY DIVISION_ID
		)
			INSERT INTO #tblSCP0105_RAW
			SELECT    A.VER_ID
					, A.VER_SEQ
					, A.DIVISION_ID
					, A.COMPANY_ID
					, A.SITE_ID
					, A.PLANT_ID
				    , A.FACTORY_ID
					, A.LINE_ID
					, A.OPERATION_ID
					, A.ELTR_LN_TP_CD
					, A.ITEM_ID
					, A.NICK_NAME
					, A.MSR_TP_CD
					, A.YYYYMM
					, A.BASE_QTY
					, A.PFRSLT_QTY
					, CASE
						WHEN ISNULL(B.ASSIGN_PRIORITY, 0) = 0 THEN NULL
						ELSE A.QTY
					  END AS QTY
					, A.UI_UPD_YN
					, A.REMARK
					, B.CREATED_BY
					, B.CREATION_DATE
					, B.LAST_UPDATED_BY
					, B.LAST_UPDATE_DATE
			FROM    SCP_MST_CAPA_SPEED_PLAN_NEW_V A
					JOIN @TBL_SCP_MST_CAPA_LINE_ASSIGN B ON
							A.DIVISION_ID		= B.DIVISION_ID
						AND A.COMPANY_ID		= B.COMPANY_ID
						AND A.SITE_ID			= B.SITE_ID
						AND A.PLANT_ID			= B.PLANT_ID
						AND A.FACTORY_ID		= B.FACTORY_ID
						AND A.LINE_ID			= B.LINE_ID
						AND A.OPERATION_ID		= B.OPERATION_ID
						AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
						AND A.NICK_NAME         = B.NICK_NAME
						AND A.YYYYMM            = B.YYYYMM;

--TESTING : NOK
--select distinct
--  A.DIVISION_ID	
--, A.COMPANY_ID	
--, A.SITE_ID		
--, A.PLANT_ID		
--, A.FACTORY_ID	
--, A.LINE_ID		
--, A.OPERATION_ID	
--, A.ELTR_LN_TP_CD	
--, A.NICK_NAME     
--, A.YYYYMM        
--from @TBL_SCP_MST_CAPA_LINE_ASSIGN A;
--select * from #tblSCP0105_RAW;rollback tran;return;


		--Valid = N 이면 추가나 수정 대상에서 삭제
		DELETE  A 
		FROM    #tblSCP0105_RAW A
				INNER JOIN #tblSCP0105_NOT_VALID B ON
						A.DIVISION_ID		= B.DIVISION_ID
					AND A.COMPANY_ID		= B.COMPANY_ID
					AND A.SITE_ID			= B.SITE_ID
					AND A.PLANT_ID			= B.PLANT_ID
					AND A.FACTORY_ID		= B.FACTORY_ID
					AND A.LINE_ID			= B.LINE_ID
					AND A.OPERATION_ID		= B.OPERATION_ID
					AND A.ELTR_LN_TP_CD		= B.ELTR_LN_TP_CD
					AND A.NICK_NAME			= B.NICK_NAME;
                
--TESTING : NOK
----select * from #tblSCP0105_NOT_VALID;
--select * from #tblSCP0105_RAW;rollback tran;return;

--SELECT  A.*
--FROM    SCP_MST_CAPA_SPEED_PLAN A
--        JOIN #tblSCP0105_RAW B ON
--				A.DIVISION_ID		    = B.DIVISION_ID
--			AND A.COMPANY_ID		    = B.COMPANY_ID
--			AND A.SITE_ID			    = B.SITE_ID
--			AND A.PLANT_ID			    = B.PLANT_ID
--			AND A.FACTORY_ID		    = B.FACTORY_ID
--			AND A.LINE_ID			    = B.LINE_ID
--			AND A.OPERATION_ID		    = B.OPERATION_ID
--			AND A.ELTR_LN_TP_CD	        = B.ELTR_LN_TP_CD
--			AND A.ITEM_ID			    = B.ITEM_ID
--			AND A.NICK_NAME			    = B.NICK_NAME
--			AND A.MSR_TP_CD	            = B.MSR_TP_CD
--			AND A.YYYYMM			    = B.YYYYMM
--rollback tran;return;

        PRINT N'INSERT - SCP_MST_CAPA_SPEED_PLAN - BEGIN'
        BEGIN
			MERGE INTO SCP_MST_CAPA_SPEED_PLAN A
			USING
			(
				SELECT    DIVISION_ID
				        , COMPANY_ID
				        , SITE_ID
				        , PLANT_ID
				        , FACTORY_ID
				        , LINE_ID
				        , OPERATION_ID
				        , ELTR_LN_TP_CD
				        , ITEM_ID
				        , NICK_NAME
				        , MSR_TP_CD
				        , YYYYMM
                        , BASE_QTY
                        , QTY
                        , UI_UPD_YN
                        , REMARK
				        , CREATED_BY
				        , CREATION_DATE
				        , LAST_UPDATED_BY
				        , LAST_UPDATE_DATE
                FROM    #tblSCP0105_RAW
                WHERE   1=1
                    AND ISNULL(DIVISION_ID, '') <> ''
                    AND ISNULL(COMPANY_ID, '') <> ''
                    AND ISNULL(SITE_ID, '') <> ''
                    AND ISNULL(PLANT_ID, '') <> ''
                    AND ISNULL(FACTORY_ID, '') <> ''
                    AND ISNULL(LINE_ID, '') <> ''
                    AND ISNULL(OPERATION_ID, '') <> ''
                    AND ISNULL(ELTR_LN_TP_CD, '') <> ''
                    AND ISNULL(ITEM_ID, '') <> ''
                    AND ISNULL(NICK_NAME, '') <> ''
				    AND ISNULL(MSR_TP_CD, '') <> ''
                    AND ISNULL(YYYYMM, '') <> ''
			) B ON
			(
					A.DIVISION_ID		    = B.DIVISION_ID
				AND A.COMPANY_ID		    = B.COMPANY_ID
				AND A.SITE_ID			    = B.SITE_ID
				AND A.PLANT_ID			    = B.PLANT_ID
				AND A.FACTORY_ID		    = B.FACTORY_ID
				AND A.LINE_ID			    = B.LINE_ID
				AND A.OPERATION_ID		    = B.OPERATION_ID
				AND A.ELTR_LN_TP_CD	        = B.ELTR_LN_TP_CD
				AND A.ITEM_ID			    = B.ITEM_ID
				AND A.NICK_NAME			    = B.NICK_NAME
				AND A.MSR_TP_CD	            = B.MSR_TP_CD
				AND A.YYYYMM			    = B.YYYYMM
			)
			WHEN MATCHED THEN
			UPDATE
			SET
				  ----BASE_QTY		        = B.BASE_QTY
				----, QTY		            = B.QTY
				  UI_UPD_YN             = B.UI_UPD_YN
				, LAST_UPDATED_BY		= CONCAT(@v_program_name, '-', @p_user_id)
				, LAST_UPDATE_DATE		= SYSDATETIME()
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
				, ITEM_ID
				, NICK_NAME
				, MSR_TP_CD
				, YYYYMM
				, BASE_QTY
				, QTY
				, UI_UPD_YN
				, REMARK
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE
			)
			VALUES
			(
				  B.DIVISION_ID
				, B.COMPANY_ID
				, B.SITE_ID
				, B.PLANT_ID
				, B.FACTORY_ID
				, B.LINE_ID
				, B.OPERATION_ID
				, B.ELTR_LN_TP_CD
				, B.ITEM_ID
				, B.NICK_NAME
				, B.MSR_TP_CD
				, B.YYYYMM
				, B.BASE_QTY
				, B.QTY
				, B.UI_UPD_YN
				, B.REMARK
				, CONCAT(@v_program_name, '-', @p_user_id)
				, SYSDATETIME()
				, CONCAT(@v_program_name, '-', @p_user_id)
				, SYSDATETIME()
			);

--TESTING : NOK
--SELECT  A.*
--FROM    SCP_MST_CAPA_SPEED_PLAN A
--        JOIN #tblSCP0105_RAW B ON
--                A.DIVISION_ID		= B.DIVISION_ID
--            AND A.COMPANY_ID		= B.COMPANY_ID
--            AND A.SITE_ID			= B.SITE_ID
--            AND A.PLANT_ID			= B.PLANT_ID
--            AND A.FACTORY_ID		= B.FACTORY_ID
--            AND A.LINE_ID			= B.LINE_ID
--            AND A.OPERATION_ID		= B.OPERATION_ID
--            AND A.ELTR_LN_TP_CD		= B.ELTR_LN_TP_CD
--		    AND A.NICK_NAME			= B.NICK_NAME
--		    AND A.MSR_TP_CD			= B.MSR_TP_CD
--		    AND A.YYYYMM			= B.YYYYMM
--rollback tran;return;

            --VALID = N 실제 테이블에서도 삭제
			DELETE  A 
			FROM    SCP_MST_CAPA_SPEED_PLAN A
					INNER JOIN #tblSCP0105_NOT_VALID B ON
							A.DIVISION_ID		= B.DIVISION_ID
						AND A.COMPANY_ID		= B.COMPANY_ID
						AND A.SITE_ID			= B.SITE_ID
						AND A.PLANT_ID			= B.PLANT_ID
						AND A.FACTORY_ID		= B.FACTORY_ID
						AND A.LINE_ID			= B.LINE_ID
						AND A.OPERATION_ID		= B.OPERATION_ID
						AND A.ELTR_LN_TP_CD		= B.ELTR_LN_TP_CD
						AND A.NICK_NAME			= B.NICK_NAME;
            

            --우선순위가 없으면 사용자가 입력한 SPEED, PPM 월별 데이터도 클리어(삭제 영향도 판단하여 삭제 고려!!!)
            UPDATE A
            SET
                A.QTY = NULL
            FROM    SCP_MST_CAPA_SPEED_PLAN A
                    INNER JOIN @TBL_SCP_MST_CAPA_LINE_ASSIGN B ON
					        A.DIVISION_ID		= B.DIVISION_ID
				        AND A.COMPANY_ID		= B.COMPANY_ID
				        AND A.SITE_ID			= B.SITE_ID
				        AND A.PLANT_ID			= B.PLANT_ID
				        AND A.FACTORY_ID		= B.FACTORY_ID
				        AND A.LINE_ID			= B.LINE_ID
				        AND A.OPERATION_ID		= B.OPERATION_ID
				        AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
				        AND A.NICK_NAME         = B.NICK_NAME
				        AND A.YYYYMM            = B.YYYYMM
            WHERE   1=1
                AND ISNULL(B.ASSIGN_PRIORITY, 0) = 0;
        END
        PRINT N'INSERT - SCP_MST_CAPA_SPEED_PLAN - END'

        BEGIN
            DELETE A -- 아예 삭제함
            FROM    SCP_MST_CAPA_SPEED_PLAN A
                    INNER JOIN (
                                    SELECT  *
                                    FROM    SCP_MST_CAPA_LINE_ASSIGN
                                    WHERE   1=1
                                        AND (ASSIGN_PRIORITY = 0 OR VALID_YN <> 'Y')
                                ) B ON
                            A.DIVISION_ID		= B.DIVISION_ID
                        AND A.COMPANY_ID		= B.COMPANY_ID
                        AND A.SITE_ID			= B.SITE_ID
                        AND A.PLANT_ID			= B.PLANT_ID
                        AND A.FACTORY_ID		= B.FACTORY_ID
                        AND A.LINE_ID			= B.LINE_ID
                        AND A.OPERATION_ID		= B.OPERATION_ID
                        AND A.ELTR_LN_TP_CD		= B.ELTR_LN_TP_CD
                        AND A.NICK_NAME			= B.NICK_NAME
                        AND A.YYYYMM			= B.YYYYMM
        END


        --SCP_MST_CAPA_SPEED_PLAN_NEW_V 로 대체!!!!!!
        ------PRINT N'INSERT - SCP_MST_CAPA_SPEED_PLAN - 모든 measure 세트를 맞추서 누락된 measure 추가 BEGIN'
        ------BEGIN
        ------    EXEC SCP0105_CHECK_CAPA_SPEED_PLAN_NOT_EXISTS_ASSEMBLY @p_program_id , @p_sheet_name, @p_user_id, @debug_mode;
        ------END            
        ------PRINT N'INSERT - SCP_MST_CAPA_SPEED_PLAN - 모든 measure 세트를 맞추서 누락된 measure 추가 END'

--TESTING : NOK
--SELECT  A.*
--FROM    SCP_MST_CAPA_SPEED_PLAN A
--        JOIN #tblSCP0105_RAW B ON
--                A.DIVISION_ID		= B.DIVISION_ID
--            AND A.COMPANY_ID		= B.COMPANY_ID
--            AND A.SITE_ID			= B.SITE_ID
--            AND A.PLANT_ID			= B.PLANT_ID
--            AND A.FACTORY_ID		= B.FACTORY_ID
--            AND A.LINE_ID			= B.LINE_ID
--            AND A.OPERATION_ID		= B.OPERATION_ID
--            AND A.ELTR_LN_TP_CD		= B.ELTR_LN_TP_CD
--		    AND A.NICK_NAME			= B.NICK_NAME
--		    AND A.MSR_TP_CD			= B.MSR_TP_CD
--		    AND A.YYYYMM			= B.YYYYMM
--rollback tran;return;


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
				  ISNULL(ERROR_PROCEDURE(), 'SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ASSEMBLY')
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


    BEGIN -- 커서 해제 & 임시테이블 삭제------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#tblSCP0105_NOT_VALID') IS NOT NULL
			DROP TABLE #tblSCP0105_NOT_VALID;
		IF OBJECT_ID('tempdb..#tblSCP0105_RAW') IS NOT NULL
			DROP TABLE #tblSCP0105_RAW;
    END

END

