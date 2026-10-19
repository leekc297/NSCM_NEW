
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0105_CHECK_NEW_CAPA_SPEED_PLAN
 * Description  : CAPA LINE ASSING
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/19   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 */

--CREATE PROCEDURE [dbo].[SCP0105_CHECK_NEW_CAPA_SPEED_PLAN]
CREATE PROCEDURE [dbo].[SCP0105_CHECK_NEW_CAPA_SPEED_PLAN]
	  @p_version				NVARCHAR(10)
	, @p_version_seq		    INT             NULL
	, @p_division_id			NVARCHAR(30)
	, @p_program_id				NVARCHAR(100)
	, @p_sheet_name				NVARCHAR(100)
	, @p_user_id				NVARCHAR(30)
	, @debug_mode				NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_version			NVARCHAR(30)            = N'202403';
 --   DECLARE @p_version_seq		INT                     = 1;
	--DECLARE @p_division_id		NVARCHAR(MAX)		    = N'81';
	--DECLARE @p_program_id		NVARCHAR(100)	    	= N'SCP0105';
	--DECLARE @p_sheet_name		NVARCHAR(100)	    	= N'MAIN';
 --   DECLARE @p_user_id			NVARCHAR(30)	    	= N'iamarock';
 --   DECLARE @debug_mode			NVARCHAR(1)		    	= N'F';


 	DECLARE @test_mode                          NVARCHAR(20)		= N'F';


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)	= 'SCP0006_SAVE_PROJECT_ROUTE_PLANT';
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

        DECLARE @v_from_yyyy        NVARCHAR(8)			= N'';

        SET @v_from_yyyy        = SUBSTRING(@p_version, 1, 4);


	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_DATE_COLS') IS NOT NULL
		    DROP TABLE #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_DATE_COLS;

        SELECT	  COLUMN_NAME
			    , COLUMN_LABEL_NAME
			    , SMALL_CLASS_LABEL_NAME
			    , LARGE_CLASS_LABEL_NAME
			    , DAY_CODE
			    , SORT_ORDER_NO
        INTO    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_DATE_COLS
	    FROM	dbo.FN_SCP0104_GET_SPREAD_TITLE(@v_from_yyyy, @p_program_id, @p_sheet_name) A;

--TESTING : NOK
--select * from #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_DATE_COLS;rollback tran;return;

	    DECLARE @v_to_yyyy			NVARCHAR(4)			= '';

        SELECT  @v_to_yyyy  = MAX(SMALL_CLASS_LABEL_NAME)
        FROM    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_DATE_COLS;

    PRINT CONCAT('@v_to_yyyy : ', @v_to_yyyy);
    --return;

    
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_MEASURE') IS NOT NULL
		    DROP TABLE #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_MEASURE;

        --빈테이블 생성
        SELECT    COLUMN_NAME           AS MEASURE	
                , COLUMN_LABEL_NAME     AS MEASURE_NAME
                , SORT_ORDER_NO
        INTO    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_MEASURE
        FROM    [SCM_MST_SHEET_MEASURE]
        WHERE   1<>1;

--TESTING : NOK
--select * from #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_MEASURE;rollback tran;return;

        INSERT INTO #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_MEASURE
        SELECT    MEASURE	
                , MEASURE_NAME
                , SORT_ORDER_NO
        FROM     [dbo].[FN_SCP0105_GET_CAPA_MEASURE](@p_program_Id, @p_sheet_name);

--TESTING : NOK
--select * from #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_MEASURE;rollback tran;return;


        --빈테이블이면 해당 사업부에 데이터 없으면 마스터(SCP_MST_CAPA_LINE_ASSIGN) 기준으로 생성
        DECLARE @v_progress_status      NVARCHAR(2)     = dbo.FN_GET_CAPA_PROGRESS_STATUS(@p_version, @p_version_seq, @p_division_id);

        DECLARE @v_cnt                  INT             = 0;
        DECLARE @v_all_cnt              INT             = 0;

	    SELECT	@v_cnt = COUNT(*)
	    FROM	SCP_MST_CAPA_SPEED_PLAN A WITH(NOLOCK)
	    WHERE	1=1
		    AND	A.VER		= @p_version
		    AND	A.VER_SEQ	= @p_version_seq
		    AND ((@p_division_id	    IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))

        PRINT CONCAT('@v_cnt : ', @v_cnt);
        --rollback tran;return;

        IF @v_cnt = 0
        BEGIN
    	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW_TEMP') IS NOT NULL
	    	    DROP TABLE #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW_TEMP;

            --빈테이블 생성
            SELECT  *
            INTO    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW_TEMP
            FROM    SCP_MST_CAPA_SPEED_PLAN WITH(NOLOCK)
            WHERE   1<>1;

            INSERT INTO #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW_TEMP
		    SELECT	  @p_version							AS VER
				    , @p_version_seq                        AS VER_SEQ
				    , @p_division_id                        AS DIVISION_ID
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.PLANT_ID
				    , A.FACTORY_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELECTRODE_TYPE
				    , A.ITEM_ID
				    , A.NICK_NAME
				    , M.MEASURE                             AS CAPA_SPEED_MEASURE
				    , A.YYYYMM
                    , CONVERT(NUMERIC(20, 4), NULL)         AS BASE_QTY
                    , CONVERT(NUMERIC(20, 4), NULL)         AS PFRSLT_QTY
                    , CONVERT(NUMERIC(20, 4), NULL)         AS QTY
                    , CONVERT(NVARCHAR(3000), NULL)         AS REMARK
				    , @p_user_id		                    AS CREATED_BY
				    , SYSDATETIME()		                    AS CREATION_DATE
				    , @p_user_id		                    AS LAST_UPDATED_BY
				    , SYSDATETIME()		                    AS LAST_UPDATE_DATE
            FROM    SCP_MST_CAPA_LINE_ASSIGN_CUR A WITH(NOLOCK)
				    LEFT JOIN SCP_MST_CAPA_LINE B WITH(NOLOCK) ON
					        A.DIVISION_ID		= B.DIVISION_ID
					    AND A.COMPANY_ID		= B.COMPANY_ID
					    AND A.SITE_ID			= B.SITE_ID
					    AND A.PLANT_ID			= B.PLANT_ID
					    AND A.FACTORY_ID		= B.FACTORY_ID
					    AND A.LINE_ID			= B.LINE_ID
					    AND A.OPERATION_ID		= B.OPERATION_ID
					    AND A.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
                    JOIN #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_MEASURE M ON
                        1=1
            WHERE   1=1;

--TESTING : NOK
--select * from #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW_TEMP;rollback tran;return;

            
    	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RESULT_TEMP') IS NOT NULL
	    	    DROP TABLE #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RESULT_TEMP;
            
            --빈테이블 생성
            SELECT    A.DIVISION_ID       AS DIVISION_ID
                    , A.COMPANY_ID        AS COMPANY_ID
                    , A.SITE_ID           AS SITE_ID
                    , A.PLANT_ID          AS PLANT_ID
                    , A.FACTORY_ID        AS FACTORY_ID
                    , A.LINE_ID           AS LINE_ID
                    , A.OPERATION_ID      AS OPERATION_ID
                    , A.ELTR_LN_TP_CD     AS ELECTRODE_TYPE
                    , A.EQP_SPED_UNIT_CD
                    , A.EQP_NBU
                    , A.EQP_SPED
            INTO    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RESULT_TEMP
            FROM    SCM_DNM_EQP_SPED_MMLY A WITH(NOLOCK)
            WHERE   1<>1


            INSERT INTO #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RESULT_TEMP
            SELECT    A.DIVISION_ID       AS DIVISION_ID
                    , A.COMPANY_ID        AS COMPANY_ID
                    , A.SITE_ID           AS SITE_ID
                    , A.PLANT_ID          AS PLANT_ID
                    , A.FACTORY_ID        AS FACTORY_ID
                    , A.LINE_ID           AS LINE_ID
                    , A.OPERATION_ID      AS OPERATION_ID
                    , A.ELTR_LN_TP_CD     AS ELECTRODE_TYPE
                    , A.EQP_SPED_UNIT_CD
                    , A.EQP_NBU
                    , A.EQP_SPED
            FROM    SCM_DNM_EQP_SPED_MMLY A WITH(NOLOCK)
            WHERE   1=1
                AND SUBSTRING(PFRSLT_YM, 1, 4) >= @v_from_yyyy
                AND SUBSTRING(PFRSLT_YM, 1, 4) <= @v_to_yyyy;

--TESTING : NOK
--select * from #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RESULT_TEMP;rollback tran;return;


    	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RESULT') IS NOT NULL
	    	    DROP TABLE #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RESULT;

            --빈테이블 생성
            SELECT    DIVISION_ID
                    , COMPANY_ID
                    , SITE_ID
                    , PLANT_ID
                    , FACTORY_ID
                    , LINE_ID
                    , OPERATION_ID
                    , ELECTRODE_TYPE
                    , CONVERT(NVARCHAR(50), 'EQP_QTY')      AS CAPA_SPEED_MEASURE
                    , CONVERT(NUMERIC(20, 4), EQP_NBU)      AS QTY
            INTO    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RESULT
            FROM    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RESULT_TEMP
            WHERE   1<>1;

            INSERT INTO #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RESULT
            SELECT    DIVISION_ID
                    , COMPANY_ID
                    , SITE_ID
                    , PLANT_ID
                    , FACTORY_ID
                    , LINE_ID
                    , OPERATION_ID
                    , ELECTRODE_TYPE
                    , CONVERT(NVARCHAR(50), 'EQP_QTY')      AS CAPA_SPEED_MEASURE
                    , CONVERT(NUMERIC(20, 4), QTY)          AS QTY
            FROM    (
                        SELECT    DIVISION_ID
                                , COMPANY_ID
                                , SITE_ID
                                , PLANT_ID
                                , FACTORY_ID
                                , LINE_ID
                                , OPERATION_ID
                                , ELECTRODE_TYPE
                                , CONVERT(NVARCHAR(50), 'EQP_QTY')      AS CAPA_SPEED_MEASURE
                                , MAX(EQP_NBU)                          AS QTY
                        FROM    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RESULT_TEMP
                        WHERE   1=1
                        GROUP BY  DIVISION_ID
                                , COMPANY_ID
                                , SITE_ID
                                , PLANT_ID
                                , FACTORY_ID
                                , LINE_ID
                                , OPERATION_ID
                                , ELECTRODE_TYPE
                        UNION ALL
                        SELECT    DIVISION_ID
                                , COMPANY_ID
                                , SITE_ID
                                , PLANT_ID
                                , FACTORY_ID
                                , LINE_ID
                                , OPERATION_ID
                                , ELECTRODE_TYPE
                                , EQP_SPED_UNIT_CD                      AS CAPA_SPEED_MEASURE
                                , MAX(EQP_SPED)                         AS QTY
                        FROM    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RESULT_TEMP
                        WHERE   1=1
                        GROUP BY  DIVISION_ID
                                , COMPANY_ID
                                , SITE_ID
                                , PLANT_ID
                                , FACTORY_ID
                                , LINE_ID
                                , OPERATION_ID
                                , ELECTRODE_TYPE
                                , EQP_SPED_UNIT_CD
                    ) A;

--TESTING : NOK
--select * from #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RESULT;rollback tran;return;


    	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_BASE_TEMP') IS NOT NULL
	    	    DROP TABLE #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_BASE_TEMP;
            
            --빈테이블 생성
            SELECT    A.DIVISION_ID       AS DIVISION_ID
                    , A.COMPANY_ID        AS COMPANY_ID
                    , A.SITE_ID           AS SITE_ID
                    , A.PLANT_ID          AS PLANT_ID
                    , A.FACTORY_ID        AS FACTORY_ID
                    , A.LINE_ID           AS LINE_ID
                    , A.OPERATION_ID      AS OPERATION_ID
                    , A.ELTR_LN_TP_CD     AS ELECTRODE_TYPE
                    , A.EQP_SPED_UNIT_CD
                    , A.EQP_NBU
                    , A.EQP_SPED
            INTO    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_BASE_TEMP
            FROM    SCP_MST_MDL_EQP_SPED A WITH(NOLOCK)
            WHERE   1<>1;

            INSERT INTO #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_BASE_TEMP
            SELECT    A.DIVISION_ID       AS DIVISION_ID
                    , A.COMPANY_ID        AS COMPANY_ID
                    , A.SITE_ID           AS SITE_ID
                    , A.PLANT_ID          AS PLANT_ID
                    , A.FACTORY_ID        AS FACTORY_ID
                    , A.LINE_ID           AS LINE_ID
                    , A.OPERATION_ID      AS OPERATION_ID
                    , A.ELTR_LN_TP_CD     AS ELECTRODE_TYPE
                    , A.EQP_SPED_UNIT_CD
                    , A.EQP_NBU
                    , A.EQP_SPED
            FROM    SCP_MST_MDL_EQP_SPED A WITH(NOLOCK)
            WHERE   1=1
                AND USE_YN = 'Y';

--TESTING : NOK
--select * from #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_BASE_TEMP;rollback tran;return;


    	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_BASE') IS NOT NULL
	    	    DROP TABLE #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_BASE;

            --빈테이블 생성
            SELECT    DIVISION_ID
                    , COMPANY_ID
                    , SITE_ID
                    , PLANT_ID
                    , FACTORY_ID
                    , LINE_ID
                    , OPERATION_ID
                    , ELECTRODE_TYPE
                    , CONVERT(NVARCHAR(50), 'EQP_QTY')      AS CAPA_SPEED_MEASURE
                    , CONVERT(NUMERIC(20, 4), EQP_NBU)      AS QTY
            INTO    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_BASE
            FROM    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_BASE_TEMP
            WHERE   1<>1;

            INSERT INTO #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_BASE
            SELECT    DIVISION_ID
                    , COMPANY_ID
                    , SITE_ID
                    , PLANT_ID
                    , FACTORY_ID
                    , LINE_ID
                    , OPERATION_ID
                    , ELECTRODE_TYPE
                    , CAPA_SPEED_MEASURE
                    , CONVERT(NUMERIC(20, 4), QTY)          AS QTY
            FROM    (
                        SELECT    DIVISION_ID
                                , COMPANY_ID
                                , SITE_ID
                                , PLANT_ID
                                , FACTORY_ID
                                , LINE_ID
                                , OPERATION_ID
                                , ELECTRODE_TYPE
                                , CONVERT(NVARCHAR(50), 'EQP_QTY')      AS CAPA_SPEED_MEASURE
                                , MAX(EQP_NBU)                          AS QTY
                        FROM    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_BASE_TEMP
                        WHERE   1=1
                        GROUP BY  DIVISION_ID
                                , COMPANY_ID
                                , SITE_ID
                                , PLANT_ID
                                , FACTORY_ID
                                , LINE_ID
                                , OPERATION_ID
                                , ELECTRODE_TYPE
                        UNION ALL
                        SELECT    DIVISION_ID
                                , COMPANY_ID
                                , SITE_ID
                                , PLANT_ID
                                , FACTORY_ID
                                , LINE_ID
                                , OPERATION_ID
                                , ELECTRODE_TYPE
                                , EQP_SPED_UNIT_CD                      AS CAPA_SPEED_MEASURE
                                , MAX(EQP_SPED)                         AS QTY
                        FROM    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_BASE_TEMP
                        WHERE   1=1
                        GROUP BY  DIVISION_ID
                                , COMPANY_ID
                                , SITE_ID
                                , PLANT_ID
                                , FACTORY_ID
                                , LINE_ID
                                , OPERATION_ID
                                , ELECTRODE_TYPE
                                , EQP_SPED_UNIT_CD
                    ) A;

--TESTING : NOK
--select * from #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_BASE;rollback tran;return;


    	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW') IS NOT NULL
	    	    DROP TABLE #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW;

            --빈테이블 생성
            SELECT    @p_version							AS VER
				    , @p_version_seq                        AS VER_SEQ
                    , DIVISION_ID
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.PLANT_ID
				    , A.FACTORY_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELECTRODE_TYPE
				    , A.ITEM_ID
				    , A.NICK_NAME
				    , A.CAPA_SPEED_MEASURE
				    , A.YYYYMM
                    , A.BASE_QTY
                    , A.PFRSLT_QTY
                    , A.QTY
                    , A.REMARK
				    , A.CREATED_BY
				    , A.CREATION_DATE
				    , A.LAST_UPDATED_BY
				    , A.LAST_UPDATE_DATE
            INTO    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW
            FROM    SCP_MST_CAPA_SPEED_PLAN_CUR A
            WHERE   1<>1;

            INSERT INTO #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW
		    SELECT	  @p_version							AS VER
				    , @p_version_seq                        AS VER_SEQ
				    , @p_division_id                        AS DIVISION_ID
				    , A.COMPANY_ID
				    , A.SITE_ID
				    , A.PLANT_ID
				    , A.FACTORY_ID
				    , A.LINE_ID
				    , A.OPERATION_ID
				    , A.ELECTRODE_TYPE
				    , A.ITEM_ID
				    , A.NICK_NAME
				    , A.CAPA_SPEED_MEASURE
				    , A.YYYYMM
                    , B.QTY                                 AS BASE_QTY
                    , R.QTY                                 AS PFRSLT_QTY
                    , A.QTY
                    , A.REMARK
				    , A.CREATED_BY
				    , A.CREATION_DATE
				    , A.LAST_UPDATED_BY
				    , A.LAST_UPDATE_DATE
            FROM    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW_TEMP A
				    LEFT JOIN #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RESULT R ON
					        A.DIVISION_ID		    = R.DIVISION_ID
					    AND A.COMPANY_ID		    = R.COMPANY_ID
					    AND A.SITE_ID			    = R.SITE_ID
					    AND A.PLANT_ID			    = R.PLANT_ID
					    AND A.FACTORY_ID		    = R.FACTORY_ID
					    AND A.LINE_ID			    = R.LINE_ID
					    AND A.OPERATION_ID		    = R.OPERATION_ID
					    AND A.ELECTRODE_TYPE	    = R.ELECTRODE_TYPE
					    AND A.CAPA_SPEED_MEASURE	= R.CAPA_SPEED_MEASURE
				    LEFT JOIN #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_BASE B WITH(NOLOCK) ON
					        A.DIVISION_ID		    = B.DIVISION_ID
					    AND A.COMPANY_ID		    = B.COMPANY_ID
					    AND A.SITE_ID			    = B.SITE_ID
					    AND A.PLANT_ID			    = B.PLANT_ID
					    AND A.FACTORY_ID		    = B.FACTORY_ID
					    AND A.LINE_ID			    = B.LINE_ID
					    AND A.OPERATION_ID		    = B.OPERATION_ID
					    AND A.ELECTRODE_TYPE	    = B.ELECTRODE_TYPE
					    AND A.CAPA_SPEED_MEASURE	= B.CAPA_SPEED_MEASURE
            WHERE   1=1;

--TESTING : NOK
--select * from #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW;rollback tran;return;

            IF @v_progress_status IS NULL OR @v_progress_status = '0' --Current
            BEGIN
                BEGIN --Current 테이블 체크후 없으면 생성
                    DECLARE @v_current_cnt INT  = 0;

                    SELECT	@v_current_cnt = COUNT(*)
	                FROM	SCP_MST_CAPA_SPEED_PLAN_CUR A WITH(NOLOCK)
	                WHERE	1=1
		                AND ((@p_division_id	    IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))

                    PRINT CONCAT('@v_current_cnt : ', @v_current_cnt);
                    --rollback tran;return;

                    IF @v_current_cnt = 0
                    BEGIN
                        INSERT INTO SCP_MST_CAPA_SPEED_PLAN_CUR
		                SELECT	  A.DIVISION_ID
				                , A.COMPANY_ID
				                , A.SITE_ID
				                , A.PLANT_ID
				                , A.FACTORY_ID
				                , A.LINE_ID
				                , A.OPERATION_ID
				                , A.ELECTRODE_TYPE
				                , A.ITEM_ID
				                , A.NICK_NAME
				                , A.CAPA_SPEED_MEASURE
				                , A.YYYYMM
				                , A.BASE_QTY
                                , A.PFRSLT_QTY
				                , A.QTY
				                , A.REMARK
				                , A.CREATED_BY
				                , A.CREATION_DATE
				                , A.LAST_UPDATED_BY
				                , A.LAST_UPDATE_DATE
                        FROM    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW A;

    --TESTING : NOK
    --select * from SCP_MST_CAPA_SPEED_PLAN_CUR;rollback tran;return;
                    END
                END
            END
            ELSE
            BEGIN
                INSERT INTO SCP_MST_CAPA_SPEED_PLAN
		        SELECT	  A.VER
				        , A.VER_SEQ
				        , A.DIVISION_ID
				        , A.COMPANY_ID
				        , A.SITE_ID
				        , A.PLANT_ID
				        , A.FACTORY_ID
				        , A.LINE_ID
				        , A.OPERATION_ID
				        , A.ELECTRODE_TYPE
				        , A.ITEM_ID
				        , A.NICK_NAME
				        , A.CAPA_SPEED_MEASURE
				        , A.YYYYMM
				        , A.BASE_QTY
                        , A.PFRSLT_QTY
				        , A.QTY
				        , A.REMARK
				        , A.CREATED_BY
				        , A.CREATION_DATE
				        , A.LAST_UPDATED_BY
				        , A.LAST_UPDATE_DATE
                FROM    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW A;

--TESTING : NOK
--select * from SCP_MST_CAPA_SPEED_PLAN_CUR;rollback tran;return;
            END

    	    SELECT  @v_all_cnt = COUNT(*)
            FROM    #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW;
        END

--TESTING : NOK
--select * from SCP_MST_CAPA_SPEED_PLAN_CUR;
--select * from SCP_MST_CAPA_SPEED_PLAN;rollback tran;return;

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


    BEGIN -- 커서 해제 & 임시테이블 삭제------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_DATE_COLS') IS NOT NULL
		    DROP TABLE #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_DATE_COLS;

	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_MEASURE') IS NOT NULL
		    DROP TABLE #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_MEASURE;

	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW') IS NOT NULL
		    DROP TABLE #tblSCP0105_CHECK_NEW_CAPA_SPEED_PLAN_RAW;
    END

END

