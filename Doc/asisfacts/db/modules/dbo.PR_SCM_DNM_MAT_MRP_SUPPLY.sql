

/*
 * Program ID   : PR_SCM_DNM_MAT_MRP_SUPPLY
 * Description  : 자재 가시화 I/F MRP RAW 데이터 취합 => SCM_DNM_MAT_MRP_SUPPLY 에 저장
 * Program History
 *================================================================================================================================================
 *   Date       In Charge                           Description
 *================================================================================================================================================
 * 2023/11/07	chaan					V1.1.9		PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2	- Initial release
 * 2023/11/09	chaan					V1.1.10		PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2	- ITEM_CATEGORY, UOM 개선
 * 2023/11/10	chaan					V1.1.11		PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2	- ORIGIN_DIVISION_ID 추적 로직 수정
 *
 */


--CREATE PROCEDURE [dbo].[PR_SCM_DNM_MAT_MRP_SUPPLY]
CREATE PROCEDURE [dbo].[PR_SCM_DNM_MAT_MRP_SUPPLY]
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    --특정 날짜의 데이터를 가져올 때는 여기서 @v_accum_yyyymmd 를 특정 날짜로 설정, 빈값이면 현재 날짜의 데이터를 취합한다
    DECLARE @v_accum_yyyymmdd			NVARCHAR(8) = '';



    DECLARE @v_test_mode        NVARCHAR(1)     = 'F';
    --DECLARE @v_test_mode        NVARCHAR(1)     = 'T';


	-- LOG 용 변수 설정
    DECLARE @v_program_name     NVARCHAR(150)   = 'PR_SCM_DNM_MAT_MRP_SUPPLY';
    DECLARE @v_log_type         NVARCHAR(30);     -- START/END/ERROR/...
    DECLARE @n_log_count        INTEGER         = 0
    DECLARE @v_log_message      NVARCHAR(1000);
    DECLARE @v_description      NVARCHAR(500);
    DECLARE @d_event_date       DATETIME    = SYSDATETIME();

	BEGIN TRAN

    BEGIN TRY
		SET @v_log_type         = 'START'
		SET @v_log_message      = '########## Start of procedure ##########'
		SET @v_description      = ''

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        PRINT @v_log_message;

	    DECLARE		@v_curr_date	        DATETIME	= GETDATE();
        PRINT CONCAT('@v_curr_date : ', @v_curr_date);


        IF @v_accum_yyyymmdd = ''
        BEGIN
            SET @v_accum_yyyymmdd   = FORMAT(@v_curr_date, 'yyyyMMdd');
        END


        PRINT CONCAT('@v_accum_yyyymmdd : ', @v_accum_yyyymmdd);

--rollback tran;return;

        -- ITEM_CATEGORY, UOM 빈값을 채우기 위해 i/f 테이블에서 검색
		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE - BEGIN';
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE;

        SELECT    A.PLANT_ID
                , A.ITEM_ID
                , A.ATTR_07 AS UOM
                , A.ATTR_08 AS ITEM_CATEGORY
        INTO    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE
        FROM    dbo.XIF_MRP_CUTOFF_SUPPLY_R_SN A WITH(NOLOCK)
        WHERE   1=1
            AND SUBSTRING(A.ACCUM_DATE, 1, 8) = '20231106'
            AND (A.IF_TYPE   = 'I' OR A.IF_TYPE   = 'U')
            AND A.DATA_TYPE = 'M'
        GROUP BY  A.PLANT_ID
                , ITEM_ID
                , ATTR_08
                , ATTR_07;
		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE - END';

		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_UOM - BEGIN';
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_UOM') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_UOM;

        SELECT    A.PLANT_ID
                , A.ITEM_ID
                , A.UOM
        INTO    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_UOM
        FROM    dbo.#TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE A WITH(NOLOCK)
        WHERE   1=1
            AND A.UOM IS NOT NULL
        GROUP BY  A.PLANT_ID
                , ITEM_ID
                , A.UOM;
		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_UOM - END';
--TESTING : OK
--select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_UOM;rollback tran;return;

		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_ITEM_CATEGORY - BEGIN';
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_ITEM_CATEGORY') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_ITEM_CATEGORY;

        SELECT    A.PLANT_ID
                , A.ITEM_ID
                , A.ITEM_CATEGORY
        INTO    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_ITEM_CATEGORY
        FROM    dbo.#TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE A WITH(NOLOCK)
        WHERE   1=1
            AND A.ITEM_CATEGORY IS NOT NULL
        GROUP BY  A.PLANT_ID
                , ITEM_ID
                , A.ITEM_CATEGORY;
		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_ITEM_CATEGORY - END';

--TESTING : NOK
--select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_UOM;
--select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_ITEM_CATEGORY;rollback tran;return;

		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW - BEGIN';
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW;

        SELECT    A.*
                , LEFT(A.ACCUM_DATE, 8)     AS ACCUM_YYYYMMDD
                , LEFT(A.ACCUM_DATE, 8)     AS CUTOFF_DATE
        INTO    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW
        FROM    dbo.XIF_MRP_CUTOFF_SUPPLY_R_SN A WITH(NOLOCK)
        WHERE   1=1
            AND SUBSTRING(A.ACCUM_DATE, 1, 8) = @v_accum_yyyymmdd        -- ACCUM_DATE 로 필터링
            AND (A.IF_TYPE          = 'I' OR A.IF_TYPE   = 'U')          -- 인터페이스처리유형(I:Insert,U:Update,D:Delete)
            AND (A.DATA_TYPE        = 'M' OR A.DATA_TYPE = 'S')
            AND A.TRANSFER_FLAG     = 'N';
		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW - END';


--TESTING : OK
--select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW;rollback tran;return;
--select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW where item_id = 'RET00649AA';rollback tran;return;

        IF @v_test_mode <> 'T' -- 테스트모드에서는 실제 DB 갱신없음
        BEGIN
            UPDATE A
            SET
                TRANSFER_FLAG   = 'P'
            FROM    dbo.XIF_MRP_CUTOFF_SUPPLY_R_SN A
                    JOIN #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW B ON
                            A.IF_SEQ = B.IF_SEQ;
        END


		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M - BEGIN';
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M;

        SELECT  A.*
        INTO    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M
        FROM    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW A
        WHERE   1=1
            AND A.DATA_TYPE     = 'M' 
            AND A.ATTR_09       = 'Y';
		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M - END';

--TESTING : OK
--select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M;rollback tran;return;
--select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M where item_id = 'RET00649AA';rollback tran;return;


		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M_ITEMS - BEGIN';
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M_ITEMS') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M_ITEMS;
        
        SELECT    A.PLANT_ID
                , A.ITEM_ID
        INTO    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M_ITEMS
        FROM    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M A
        GROUP BY  A.PLANT_ID
                , A.ITEM_ID;

		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M_ITEMS - END';

		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S_TEMP - BEGIN';
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S_TEMP') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S_TEMP;

        SELECT  A.*
        INTO    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S_TEMP
        FROM    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW A
        WHERE   1=1
            AND A.DATA_TYPE     = 'S'
            AND A.ATTR_03       = 'Y';
		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S_TEMP - END';

--TESTING : OK
--select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S_TEMP;rollback tran;return;
--select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S_TEMP where item_id = 'RET00649AA';rollback tran;return;

		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S - BEGIN';
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S;

        -- S는 M & Y 인 plant_id, item_id 에 해당하는 것들중 ATTR_03 = 'Y'
        SELECT  A.*
        INTO    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S
        FROM    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S_TEMP A
                JOIN #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M_ITEMS B ON
                        A.PLANT_ID       = B.PLANT_ID
                    AND A.ITEM_ID        = B.ITEM_ID;
		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S - END';


--TESTING : OK
--select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S;rollback tran;return;

--select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M where item_id = 'RET00649AA' AND PLANT_ID = 'A040';
----select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S;rollback tran;return;
--select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S_TEMP where item_id = 'RET00649AA' AND PLANT_ID = 'A040';
----select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M where item_id = 'RET00649AA';
--select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S where item_id = 'RET00649AA' AND PLANT_ID = 'A040';rollback tran;return;

		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL_TEMP - BEGIN';
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL_TEMP') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL_TEMP;

        SELECT    A.DATA_TYPE
                , A.CUTOFF_DATE
                , A.RTA
                , A.PLANT_ID
                , A.ITEM_ID
                , A.FACTORY_ID
                , A.SOC
                , A.QTY
                , A.ATTR_01
                , A.ATTR_02
                , A.ATTR_03
                , A.ATTR_04
                , A.ATTR_05
                , A.ATTR_06
                , A.ATTR_07
                , A.ATTR_08
                , A.ATTR_09
                , A.ATTR_10
        INTO    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL_TEMP
        FROM    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M A;

        -- S는 SCO 별로 여러개 존재하므로 SUM
        INSERT INTO #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL_TEMP
        SELECT    A.DATA_TYPE
                , A.CUTOFF_DATE
                , A.RTA
                , A.PLANT_ID
                , A.ITEM_ID
                , CONVERT(NVARCHAR(50),		NULL)		        AS FACTORY_ID
                , CONVERT(NVARCHAR(50),		NULL)		        AS SOC
                , SUM(A.QTY)							        AS QTY
                , CONVERT(NVARCHAR(200),	NULL)		        AS ATTR_01
                , CONVERT(NVARCHAR(200),	NULL)		        AS ATTR_02
                , CONVERT(NVARCHAR(200),	NULL)		        AS ATTR_03
                , CONVERT(NVARCHAR(200),	NULL)		        AS ATTR_04
                , CONVERT(NVARCHAR(200),	NULL)		        AS ATTR_05
                , CONVERT(NVARCHAR(1000),	NULL)		        AS ATTR_06
                , CONVERT(NVARCHAR(1000),	NULL)		        AS ATTR_07
                , CONVERT(NVARCHAR(1000),	NULL)		        AS ATTR_08
                , CONVERT(NVARCHAR(1000),	NULL)		        AS ATTR_09
                , CONVERT(NVARCHAR(1000),	NULL)		        AS ATTR_10
        FROM    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S A
        GROUP BY  A.DATA_TYPE
                , A.CUTOFF_DATE
                , A.RTA
                , A.PLANT_ID
                , A.ITEM_ID;
		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL_TEMP - END';
--TESTING : OK
--select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL_TEMP;rollback tran;return;


		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL - BEGIN';
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL;

        SELECT    A.DATA_TYPE
                , A.CUTOFF_DATE
                , A.RTA
                , A.PLANT_ID
                , A.ITEM_ID
                , A.FACTORY_ID
                , A.SOC
                , A.QTY
                , A.ATTR_01
                , A.ATTR_02
                , A.ATTR_03
                , A.ATTR_04
                , A.ATTR_05
                , A.ATTR_06
                , IIF(A.ATTR_07 IS NULL, CONVERT(NVARCHAR(1000),	B.UOM), A.ATTR_07)              AS ATTR_07
                , IIF(A.ATTR_08 IS NULL, CONVERT(NVARCHAR(1000),	C.ITEM_CATEGORY), A.ATTR_08)    AS ATTR_08
                , A.ATTR_09
                , A.ATTR_10
        INTO    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL
        FROM    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL_TEMP A
                LEFT JOIN #TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_UOM B ON
                    A.PLANT_ID = B.PLANT_ID
                AND A.ITEM_ID  = B.ITEM_ID
                LEFT JOIN #TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_ITEM_CATEGORY C ON
                    A.PLANT_ID = C.PLANT_ID
                AND A.ITEM_ID  = C.ITEM_ID
		PRINT N'#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL - END';

--TESTING : OK
--select * from #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL;rollback tran;return;

        IF @v_test_mode <> 'T' -- 테스트모드에서는 실제 DB 갱신없음
        BEGIN
            PRINT 'DELETE dbo.SCM_DNM_MAT_MRP_SUPPLY - BEGIN';
            DELETE A
            FROM    dbo.SCM_DNM_MAT_MRP_SUPPLY A
                    JOIN #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL B ON
            			    A.DATA_TYPE	    = B.DATA_TYPE
                        AND A.CUTOFF_DATE   = B.CUTOFF_DATE
            			AND A.RTA			= B.RTA
                        AND A.PLANT_ID      = B.PLANT_ID
                        AND A.ITEM_ID       = B.ITEM_ID;
            PRINT 'DELETE dbo.SCM_DNM_MAT_MRP_SUPPLY - DONE';

--TESTING : OK
--select * from dbo.SCM_DNM_MAT_MRP_SUPPLY;rollback tran;return;
--select * from SCM_DNM_MAT_MRP_SUPPLY where CUTOFF_DATE = '20231106';rollback tran;return;

            PRINT 'INSERT INTO dbo.SCM_DNM_MAT_MRP_SUPPLY - BEGIN';
            INSERT INTO dbo.SCM_DNM_MAT_MRP_SUPPLY
            SELECT    A.*
                    , CONVERT(NVARCHAR(200), NULL)	        AS ATTRIBUTE1
                    , CONVERT(NVARCHAR(200), NULL)	        AS ATTRIBUTE2
                    , CONVERT(NVARCHAR(200), NULL)	        AS ATTRIBUTE3
                    , CONVERT(NVARCHAR(200), NULL)	        AS ATTRIBUTE4
                    , CONVERT(NVARCHAR(200), NULL)	        AS ATTRIBUTE5
                    , CONVERT(NVARCHAR(200), NULL)	        AS ATTRIBUTE6
                    , CONVERT(NVARCHAR(200), NULL)	        AS ATTRIBUTE7
                    , CONVERT(NVARCHAR(200), NULL)	        AS ATTRIBUTE8
                    , CONVERT(NVARCHAR(200), NULL)	        AS ATTRIBUTE9
                    , CONVERT(NVARCHAR(200), NULL)	        AS ATTRIBUTE10
                    , CONVERT(NVARCHAR(150), 'scm_batch')   AS CREATED_BY
                    , GETDATE()                             AS CREATION_DATE
                    , CONVERT(NVARCHAR(150), 'scm_batch')   AS LAST_UPDATED_BY
                    , GETDATE()                             AS LAST_UPDATE_DATE
            FROM    #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL A;

            PRINT 'INSERT INTO dbo.SCM_DNM_MAT_MRP_SUPPLY - DONE';
        END

--TESTING : OK
--select * from SCM_DNM_MAT_MRP_SUPPLY where CUTOFF_DATE = '20231102';rollback tran;return;

        IF @v_test_mode <> 'T' -- 테스트모드에서는 실제 DB 갱신없음
        BEGIN
            UPDATE A
            SET
                TRANSFER_FLAG   = 'Y'
            FROM    dbo.XIF_MRP_CUTOFF_SUPPLY_R_SN A
                    JOIN #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW B ON
                            A.IF_SEQ = B.IF_SEQ;
        END


		SET @v_log_type     = 'END'
		SET @v_log_message  = '########## END of procedure ##########'
		SET @v_description  = ''

        IF @v_test_mode <> 'T'
        BEGIN
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END

        COMMIT TRAN

        PRINT @v_log_message;
	END TRY
	BEGIN CATCH
		BEGIN
			IF (XACT_STATE() <> 0)
				ROLLBACK TRAN;


            PRINT 'ERROR_PROCEDURE()' select ERROR_PROCEDURE();

            IF @v_test_mode <> 'T'
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
                      ISNULL(ERROR_PROCEDURE(), @v_program_name)
                    , 'ERROR'
                    , NULL
                    , ERROR_MESSAGE()
                    , NULL
                    , SYSDATETIME()
                    , SYSDATETIME()
                    , ERROR_PROCEDURE()
                    , SYSDATETIME()
                    , ERROR_PROCEDURE()
                );
            END

			-- error코드, errror 메시지 반환
			SELECT  'F' AS result_code

			SELECT    ERROR_LINE()      AS ERRO_LINE
                    , ERROR_NUMBER()    AS ERROR_NO
                    , ERROR_MESSAGE()   AS ERROR_MSG
		END
	END CATCH

	
	BEGIN -- 임시테이블 및 커서 제거
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE;
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_ITEM_CATEGORY') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_ITEM_CATEGORY;
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_UOM') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_CODE_UOM;
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW;
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL;
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL_TEMP') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_ALL_TEMP;
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M;
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M_ITEMS') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_M_ITEMS;
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S;
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S_TEMP') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_S_TEMP;
        IF OBJECT_ID('tempdb..#TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_TEMP') IS NOT NULL
            DROP TABLE #TblPR_SCM_DNM_MAT_MRP_SUPPLY_RAW_TEMP;
	END -- 임시테이블 및 커서 제거
END
