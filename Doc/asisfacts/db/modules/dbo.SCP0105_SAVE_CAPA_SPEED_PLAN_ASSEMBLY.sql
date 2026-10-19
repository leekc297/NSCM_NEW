
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0105_SAVE_CAPA_SPEED_PLAN_ASSEMBLY
 * Description  : CAPA LINE ASSING
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/16   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/07/11   chaan        V1.1.3                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 3차 Update
                                                                                                             - 피봇로직 이관
 * 2024/08/05   chaan        V1.1.5                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - FLOAT 로 변형
 * 2024/10/19   chaan        V1.1.8                PJ20239037 LGES CPS VOE 반영 및 고도화                     - 불필요 로직 제거
 * 2025/02/10   mrchois      V1.1.11               PJ20249346  LGES SCP 개선과제 이행	 - Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정
*/

--DROP PROCEDURE [dbo].[SCP0105_SAVE_CAPA_SPEED_PLAN_ASSEMBLY]
--CREATE PROCEDURE [dbo].[SCP0105_SAVE_CAPA_SPEED_PLAN_ASSEMBLY]
CREATE PROCEDURE [dbo].[SCP0105_SAVE_CAPA_SPEED_PLAN_ASSEMBLY]
	  @p_version			    NVARCHAR(10)
	, @p_version_seq		    TINYINT
	, @p_prog_stat  		    NVARCHAR(1)
	, @p_division_id		    NVARCHAR(MAX)
	, @p_company_id			    NVARCHAR(MAX)
	, @p_site_id			    NVARCHAR(MAX)
	, @p_plant_id			    NVARCHAR(MAX)
	, @p_factory_id			    NVARCHAR(MAX)
	, @p_line_id			    NVARCHAR(MAX)
	, @p_operation_id		    NVARCHAR(MAX)
	, @p_electrode_type		    NVARCHAR(MAX)
	, @p_item_id			    NVARCHAR(MAX)
	, @p_nick_name			    NVARCHAR(MAX)
	, @p_capa_speed_measure		NVARCHAR(MAX)
	, @p_base_qty               NVARCHAR(MAX)
	, @p_ui_upd_yn      	    NVARCHAR(MAX)
	, @p_date_column_names      NVARCHAR(MAX)
	, @p_date_column_values     NVARCHAR(MAX)
	, @p_program_id			    NVARCHAR(100)
	, @p_sheet_name			    NVARCHAR(100)
	, @p_user_id			    NVARCHAR(30)
	, @debug_mode			    NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_version					NVARCHAR(10)		= N'202412';
	--DECLARE @p_version_seq				TINYINT				= 1;
	--DECLARE @p_prog_stat  				NVARCHAR(1)			= N'0';
	--DECLARE @p_division_id				NVARCHAR(MAX)		= N'81^81^';
	--DECLARE @p_company_id				NVARCHAR(MAX)		= N'G630^G630^';
	--DECLARE @p_site_id					NVARCHAR(MAX)		= N'A002^A002^';
	--DECLARE @p_plant_id					NVARCHAR(MAX)		= N'G631^G631^';
	--DECLARE @p_factory_id				NVARCHAR(MAX)		= N'A8^A8^';
	--DECLARE @p_line_id					NVARCHAR(MAX)		= N'A8AF1^A8AF1^';
	--DECLARE @p_operation_id				NVARCHAR(MAX)		= N'A5000^A5000^';
	--DECLARE @p_electrode_type			NVARCHAR(MAX)		= N'Anode^Anode^';
	--DECLARE @p_item_id					NVARCHAR(MAX)		= N'-^-^';
	--DECLARE @p_nick_name				NVARCHAR(MAX)		= N'E62B^E62B^';
	--DECLARE @p_capa_speed_measure		NVARCHAR(MAX)		= N'EQP_NBU^PPM^';
	--DECLARE @p_base_qty					NVARCHAR(MAX)		= N'0.0000000000^0.0000000000^';
	--DECLARE @p_ui_upd_yn      			NVARCHAR(MAX)		= N'Y^Y^';
	--DECLARE @p_date_column_names		NVARCHAR(MAX)		= N'M_01202501;M_01202502;M_01202503;M_01202504;M_01202505;M_01202506;M_01202507;M_01202508;M_01202509;M_01202510;M_01202511;M_01202512;M_01202601;M_01202602;M_01202603;M_01202604;M_01202605;M_01202606;M_01202607;M_01202608;M_01202609;M_01202610;M_01202611;M_01202612;M_01202701;M_01202702;M_01202703;M_01202704;M_01202705;M_01202706;M_01202707;M_01202708;M_01202709;M_01202710;M_01202711;M_01202712;Y_2028;Y_2029;Y_2030;^M_01202501;M_01202502;M_01202503;M_01202504;M_01202505;M_01202506;M_01202507;M_01202508;M_01202509;M_01202510;M_01202511;M_01202512;M_01202601;M_01202602;M_01202603;M_01202604;M_01202605;M_01202606;M_01202607;M_01202608;M_01202609;M_01202610;M_01202611;M_01202612;M_01202701;M_01202702;M_01202703;M_01202704;M_01202705;M_01202706;M_01202707;M_01202708;M_01202709;M_01202710;M_01202711;M_01202712;Y_2028;Y_2029;Y_2030;^';
	--DECLARE @p_date_column_values		NVARCHAR(MAX)		= N';;2;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;;^;;32.4947862356621;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;16.2473931178;;^';
	--DECLARE @p_program_id				NVARCHAR(100)		= N'SCP0105';
	--DECLARE @p_sheet_name				NVARCHAR(100)		= N'ASSEMBLY';
	--DECLARE @p_user_id					NVARCHAR(30)		= N'iamarock';
	--DECLARE @debug_mode					NVARCHAR(1)			= N'F';



	--DECLARE @test_mode                          NVARCHAR(20)		= N'F';
	DECLARE @test_mode                          NVARCHAR(20)	= N'T';

	DECLARE @V_ELAPSED_TIME_BEG     DATETIME                = CURRENT_TIMESTAMP;


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


		DECLARE @v_delimiter				NVARCHAR(1) = '^'

		DECLARE @v_all_cnt		        INTEGER		= 0;
		DECLARE @v_cnt					INTEGER		= 0;

		SET @v_all_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_division_id, @v_delimiter);

        PRINT CONCAT('@v_all_cnt : ', @v_all_cnt);

 

        PRINT N'속도 이슈로 Unpivot 을 UI 에서 DB 로 이전 BEGIN *******************************************************************************************************'
        BEGIN
			IF OBJECT_ID('tempdb..#T_SCP0105_DATE_COLUMNS') IS NOT NULL
				DROP TABLE #T_SCP0105_DATE_COLUMNS;

			SELECT    NR
					, COLUMN_NAME
					, COLUMN_VALUE
			INTO    #T_SCP0105_DATE_COLUMNS
			FROM    (
						SELECT    A.TOKEN AS COLUMN_NAME
								, B.TOKEN AS COLUMN_VALUE
								, A.NR
						FROM   dbo.String_Split(@p_date_column_names, '^') A
							JOIN (SELECT TOKEN, NR FROM dbo.String_Split(@p_date_column_values, '^')) B ON
									A.NR = B.NR
					) A
			WHERE   1=1
				AND A.COLUMN_NAME <> '';

			PRINT CONCAT('ELAPSED_TIME-#T_SCP0105_DATE_COLUMNS : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

			--TESTING : NOK
			--select * from #T_SCP0105_DATE_COLUMNS;return;


			IF OBJECT_ID('tempdb..#T_SCP0105_DATE_VALUES_TEMP') IS NOT NULL
				DROP TABLE #T_SCP0105_DATE_VALUES_TEMP;

			SELECT    CONVERT(INT, NULL)            AS ROW_NR
					, CONVERT(INT, NULL)            AS COL_NR
					, CONVERT(NVARCHAR(30),  NULL)  AS COL_NAME
					, CONVERT(NVARCHAR(100), NULL)  AS COL_VALUE
			INTO    #T_SCP0105_DATE_VALUES_TEMP
			WHERE   1<>1;

			IF CURSOR_STATUS('global','CUR_SCP0105_DATE_COLUMNS') >= -1
			BEGIN
				IF CURSOR_STATUS('global','CUR_SCP0105_DATE_COLUMNS') > -1
				BEGIN
					CLOSE CUR_SCP0105_DATE_COLUMNS
				END

				DEALLOCATE CUR_SCP0105_DATE_COLUMNS
			END

			DECLARE @v_nr                       INT                 = 0;
			DECLARE @v_column_names          	NVARCHAR(MAX)		= N'';
			DECLARE @v_column_values          	NVARCHAR(MAX)		= N'';

			DECLARE CUR_SCP0105_DATE_COLUMNS CURSOR FOR
			SELECT    NR
					, COLUMN_NAME
					, COLUMN_VALUE
			FROM    #T_SCP0105_DATE_COLUMNS;

			OPEN CUR_SCP0105_DATE_COLUMNS;
			FETCH NEXT FROM CUR_SCP0105_DATE_COLUMNS INTO @v_nr, @v_column_names, @v_column_values

			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO #T_SCP0105_DATE_VALUES_TEMP
				SELECT    A.ROW_NR
						, A.COL_NR
						, A.COL_NAME
						, B.COL_VALUE
				FROM    (
							SELECT    @v_nr             AS ROW_NR
									, NR                AS COL_NR
									, TOKEN             AS COL_NAME
							FROM    dbo.String_Split(@v_column_names, ';')
						) A
						JOIN
						(
							SELECT    @v_nr             AS ROW_NR
									, NR                AS COL_NR
									, TOKEN             AS COL_VALUE
							FROM    dbo.String_Split(@v_column_values, ';')
						) B ON
								A.ROW_NR = B.ROW_NR
							AND A.COL_NR = B.COL_NR
				WHERE   1=1
					AND COL_NAME IS NOT NULL AND COL_NAME <> ''

				FETCH NEXT FROM CUR_SCP0105_DATE_COLUMNS INTO @v_nr, @v_column_names, @v_column_values
			END

			CLOSE CUR_SCP0105_DATE_COLUMNS;
			DEALLOCATE CUR_SCP0105_DATE_COLUMNS;

			PRINT CONCAT('ELAPSED_TIME-#T_SCP0105_DATE_VALUES_TEMP : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

			--TESTING : NOK
			--select * from #T_SCP0105_DATE_VALUES_TEMP;return;


			IF OBJECT_ID('tempdb..#T_SCP0105_DATE_VALUES') IS NOT NULL
				DROP TABLE #T_SCP0105_DATE_VALUES;

			SELECT    A.ROW_NR
					, A.YYYYMM
					, A.COL_VALUE AS QTY
					--, B.COL_VALUE AS IPRV_GOL_RT	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois)
			INTO    #T_SCP0105_DATE_VALUES
			FROM    (
						SELECT    ROW_NR
                                , COL_NR
								, COL_NAME
								, COL_VALUE
								, REPLACE(REPLACE(REPLACE(COL_NAME, 'M_00', ''), 'M_01', ''), 'Y_', '') AS YYYYMM
						FROM    #T_SCP0105_DATE_VALUES_TEMP
						WHERE   1=1
							AND (SUBSTRING(COL_NAME, 3, 2) = '01' OR SUBSTRING(COL_NAME, 1, 2) = 'Y_')
					) A
					-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) START
					--LEFT JOIN (
					--		        SELECT   ROW_NR
					--				        , COL_NR
					--				        , COL_NAME
					--				        , COL_VALUE
					--				        , REPLACE(REPLACE(REPLACE(COL_NAME, 'M_00', ''), 'M_01', ''), 'Y_', '') AS YYYYMM
					--		        FROM    #T_SCP0105_DATE_VALUES_TEMP
					--		        WHERE   1=1
					--			        AND SUBSTRING(COL_NAME, 3, 2) = '00'
					--) B ON
					--		A.ROW_NR = B.ROW_NR
					--	AND A.YYYYMM = B.YYYYMM;
					-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) END

		PRINT CONCAT('ELAPSED_TIME-#T_SCP0105_DATE_VALUES : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from #T_SCP0105_DATE_VALUES;return;

		    IF OBJECT_ID('tempdb..#T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_TEMP') IS NOT NULL
			    DROP TABLE #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_TEMP;

            SELECT    @p_version                                        AS VER_ID
                    , @p_version_seq                                    AS VER_SEQ
					, P1.TOKEN                                          AS DIVISION_ID
                    , P2.TOKEN                                          AS COMPANY_ID
                    , P3.TOKEN                                          AS SITE_ID
                    , P4.TOKEN                                          AS PLANT_ID
                    , P5.TOKEN                                          AS FACTORY_ID
                    , P6.TOKEN                                          AS LINE_ID
                    , P7.TOKEN                                          AS OPERATION_ID
                    , P8.TOKEN                                          AS ELTR_LN_TP_CD
                    , P9.TOKEN                                          AS ITEM_ID
                    , P10.TOKEN                                         AS NICK_NAME
                    , P11.TOKEN                                         AS MSR_TP_CD
                    , P12.TOKEN                                         AS BASE_QTY
                    , P13.TOKEN                                         AS UI_UPD_YN
					, A.YYYYMM                                          AS YYYYMM
                    , A.QTY                                             AS QTY
					, @p_user_id                                        AS CREATED_BY
					, SYSDATETIME()                                     AS CREATION_DATE
                    , @p_user_id                                        AS LAST_UPDATED_BY
                    , SYSDATETIME()                                     AS LAST_UPDATE_DATE
			INTO    #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_TEMP
			FROM    #T_SCP0105_DATE_VALUES A
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_division_id,			'^')) P1  ON A.ROW_NR = P1.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_company_id,				'^')) P2  ON A.ROW_NR = P2.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_site_id,				'^')) P3  ON A.ROW_NR = P3.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_plant_id,				'^')) P4  ON A.ROW_NR = P4.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_factory_id,				'^')) P5  ON A.ROW_NR = P5.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_line_id,				'^')) P6  ON A.ROW_NR = P6.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_operation_id,			'^')) P7  ON A.ROW_NR = P7.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_electrode_type,			'^')) P8  ON A.ROW_NR = P8.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_item_id,				'^')) P9  ON A.ROW_NR = P9.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_nick_name,				'^')) P10 ON A.ROW_NR = P10.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_capa_speed_measure,		'^')) P11 ON A.ROW_NR = P11.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_base_qty,				'^')) P12 ON A.ROW_NR = P12.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_ui_upd_yn,				'^')) P13 ON A.ROW_NR = P13.NR
            WHERE   1<>1;

			INSERT INTO #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_TEMP
            SELECT    @p_version                                        AS VER_ID
                    , @p_version_seq                                    AS VER_SEQ
					, P1.TOKEN                                          AS DIVISION_ID
                    , P2.TOKEN                                          AS COMPANY_ID
                    , P3.TOKEN                                          AS SITE_ID
                    , P4.TOKEN                                          AS PLANT_ID
                    , P5.TOKEN                                          AS FACTORY_ID
                    , P6.TOKEN                                          AS LINE_ID
                    , P7.TOKEN                                          AS OPERATION_ID
                    , P8.TOKEN                                          AS ELTR_LN_TP_CD
                    , P9.TOKEN                                          AS ITEM_ID
                    , P10.TOKEN                                         AS NICK_NAME
                    , P11.TOKEN                                         AS MSR_TP_CD
                    , P12.TOKEN                                         AS BASE_QTY
                    , P13.TOKEN                                         AS UI_UPD_YN
					, A.YYYYMM                                          AS YYYYMM
                    , A.QTY                                             AS QTY
					, @p_user_id                                        AS CREATED_BY
					, SYSDATETIME()                                     AS CREATION_DATE
                    , @p_user_id                                        AS LAST_UPDATED_BY
                    , SYSDATETIME()                                     AS LAST_UPDATE_DATE
			FROM    #T_SCP0105_DATE_VALUES A
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_division_id,			'^')) P1  ON A.ROW_NR = P1.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_company_id,				'^')) P2  ON A.ROW_NR = P2.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_site_id,				'^')) P3  ON A.ROW_NR = P3.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_plant_id,				'^')) P4  ON A.ROW_NR = P4.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_factory_id,				'^')) P5  ON A.ROW_NR = P5.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_line_id,				'^')) P6  ON A.ROW_NR = P6.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_operation_id,			'^')) P7  ON A.ROW_NR = P7.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_electrode_type,			'^')) P8  ON A.ROW_NR = P8.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_item_id,				'^')) P9  ON A.ROW_NR = P9.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_nick_name,				'^')) P10 ON A.ROW_NR = P10.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_capa_speed_measure,		'^')) P11 ON A.ROW_NR = P11.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_base_qty,				'^')) P12 ON A.ROW_NR = P12.NR
                    JOIN (SELECT NR, TOKEN FROM dbo.String_Split(@p_ui_upd_yn,				'^')) P13 ON A.ROW_NR = P13.NR


			PRINT CONCAT('ELAPSED_TIME-#T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_TEMP : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_TEMP where YYYYMM = '202408';return;


		    IF OBJECT_ID('tempdb..#T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_ALL') IS NOT NULL
			    DROP TABLE #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_ALL;

            --빈테이블 만들기
		    SELECT	  VER_ID
                    , VER_SEQ
					, DIVISION_ID
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
                    , CONVERT(FLOAT, NULL)                AS BASE_QTY
                    , UI_UPD_YN
					, YYYYMM
                    , CONVERT(FLOAT, NULL)                AS QTY
                    , CREATED_BY
                    , CREATION_DATE
                    , LAST_UPDATED_BY
                    , LAST_UPDATE_DATE
		    INTO	#T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_ALL
		    FROM	#T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_TEMP
		    WHERE	1<>1;

			INSERT INTO #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_ALL
		    SELECT	  VER_ID
                    , VER_SEQ
					, DIVISION_ID
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
                    , CASE
                        WHEN BASE_QTY IS NULL OR (RTRIM(LTRIM(BASE_QTY))  = '') THEN 0.0
                        ELSE CONVERT(FLOAT, BASE_QTY)
                        END AS BASE_QTY
                    , UI_UPD_YN
					, YYYYMM
                    , CASE
                        WHEN QTY IS NULL OR (RTRIM(LTRIM(QTY))  = '') THEN 0.0
                        ELSE CONVERT(FLOAT, QTY)
                        END AS QTY
                    , CREATED_BY
                    , CREATION_DATE
                    , LAST_UPDATED_BY
                    , LAST_UPDATE_DATE
			FROM    #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_TEMP A;

			PRINT CONCAT('ELAPSED_TIME#T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_ALL : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_ALL where YYYYMM = '202505';rollback tran; return;
        END
        PRINT N'속도 이슈로 Unpivot 을 UI 에서 DB 로 이전 - END *******************************************************************************************************'

--TESTING : NOK
--select * from #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_ALL WHERE YYYYMM = '202408';rollback tran; return;



		--빈라인이 추가되어 삭제
		DELETE FROM #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_ALL
		WHERE	ISNULL(DIVISION_ID, '') = ''
			OR ISNULL(COMPANY_ID, '') = ''
			OR ISNULL(SITE_ID, '') = ''
			OR ISNULL(PLANT_ID, '') = ''
			OR ISNULL(FACTORY_ID, '') = ''
			OR ISNULL(LINE_ID, '') = ''
			OR ISNULL(OPERATION_ID, '') = ''
			OR ISNULL(ELTR_LN_TP_CD, '') = ''
			OR ISNULL(ITEM_ID, '') = ''
			OR ISNULL(NICK_NAME, '') = ''
			OR ISNULL(MSR_TP_CD, '') = ''
			OR ISNULL(YYYYMM, '') = '';

--TESTING : NOK
--select * from #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_ALL;rollback tran;return;
--select * from #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_ALL WHERE YYYYMM = '202408';rollback tran; return;


        --변경된 데이터만 해당 BEGIN--------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#T_SCP0105_SCP_MST_CAPA_SPEED_PLAN') IS NOT NULL
			DROP TABLE #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN;

        ;WITH tblChanged AS
        (
            SELECT    A.*
                    , B.DIVISION_ID     AS OLD_DIVISION_ID
                    , B.BASE_QTY        AS OLD_BASE_QTY
                    , B.QTY             AS OLD_QTY
            FROM    #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_ALL A
                    LEFT JOIN SCP_MST_CAPA_SPEED_PLAN B ON
					        A.DIVISION_ID		= B.DIVISION_ID
				        AND A.COMPANY_ID		= B.COMPANY_ID
				        AND A.SITE_ID			= B.SITE_ID
				        AND A.PLANT_ID			= B.PLANT_ID
				        AND A.FACTORY_ID		= B.FACTORY_ID
				        AND A.LINE_ID			= B.LINE_ID
				        AND A.OPERATION_ID		= B.OPERATION_ID
				        AND A.ELTR_LN_TP_CD		= B.ELTR_LN_TP_CD
				        AND A.NICK_NAME	        = B.NICK_NAME
				        AND A.MSR_TP_CD	        = B.MSR_TP_CD
				        AND A.YYYYMM	        = B.YYYYMM
        )
            SELECT  *
            INTO    #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN
            FROM    tblChanged A
            WHERE   1=1
                AND (OLD_DIVISION_ID IS NULL OR (ISNULL(BASE_QTY, 0) <> ISNULL(OLD_BASE_QTY, 0) OR ISNULL(QTY, 0) <> ISNULL(OLD_QTY, 0))) 
        --변경된 데이터만 해당 END--------------------------------------------------------------------------------------------------------

--TESTING : NOK
--select * from #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN_ALL;
--select * from #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN;rollback tran;return;


        IF @p_prog_stat = '0' -- 0 : Current
        BEGIN
            BEGIN --데이터 저장 - 본테이블
			    MERGE INTO SCP_MST_CAPA_SPEED_PLAN A
			    USING
			    (
				    SELECT	*
                    FROM    #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN
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
				      BASE_QTY		        = B.BASE_QTY
				    , UI_UPD_YN		        = B.UI_UPD_YN
				    , QTY		            = B.QTY
				    , LAST_UPDATED_BY		= B.LAST_UPDATED_BY
				    , LAST_UPDATE_DATE		= B.LAST_UPDATE_DATE
                    ;
			    ------WHEN NOT MATCHED THEN
			    ------INSERT
			    ------(
			    ------	  DIVISION_ID
			    ------	, COMPANY_ID
			    ------	, SITE_ID
			    ------	, PLANT_ID
			    ------	, FACTORY_ID
			    ------	, LINE_ID
			    ------	, OPERATION_ID
			    ------	, ELTR_LN_TP_CD
			    ------	, ITEM_ID
			    ------	, NICK_NAME
			    ------	, MSR_TP_CD
			    ------	, YYYYMM
			    ------	, BASE_QTY
			    ------	, UI_UPD_YN
			    ------	, QTY
			    ------	, CREATED_BY
			    ------	, CREATION_DATE
			    ------	, LAST_UPDATED_BY
			    ------	, LAST_UPDATE_DATE
			    ------)
			    ------VALUES
			    ------(
			    ------	  B.DIVISION_ID
			    ------	, B.COMPANY_ID
			    ------	, B.SITE_ID
			    ------	, B.PLANT_ID
			    ------	, B.FACTORY_ID
			    ------	, B.LINE_ID
			    ------	, B.OPERATION_ID
			    ------	, B.ELTR_LN_TP_CD
			    ------	, B.ITEM_ID
			    ------	, B.NICK_NAME
			    ------	, B.MSR_TP_CD
			    ------	, B.YYYYMM
			    ------	, B.BASE_QTY
			    ------	, B.UI_UPD_YN
			    ------	, B.QTY
			    ------	, B.CREATED_BY
			    ------	, B.CREATION_DATE
			    ------	, B.LAST_UPDATED_BY
			    ------	, B.LAST_UPDATE_DATE
			    ------);
		    END --데이터 저장 - 본테이블

--TESTING : NOK
--select  A.* 
--from    SCP_MST_CAPA_SPEED_PLAN A
--        JOIN #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN B ON
--		    A.DIVISION_ID		    = B.DIVISION_ID     
--	    AND A.COMPANY_ID		    = B.COMPANY_ID
--	    AND A.SITE_ID			    = B.SITE_ID
--	    AND A.PLANT_ID			    = B.PLANT_ID
--	    AND A.FACTORY_ID		    = B.FACTORY_ID
--	    AND A.LINE_ID			    = B.LINE_ID
--	    AND A.OPERATION_ID		    = B.OPERATION_ID
--	    AND A.ELTR_LN_TP_CD	        = B.ELTR_LN_TP_CD
--	    AND A.NICK_NAME 		    = B.NICK_NAME
--	    AND A.MSR_TP_CD 		    = B.MSR_TP_CD
--	    AND A.YYYYMM     		    = B.YYYYMM
--WHERE   1=1
--    AND A.YYYYMM = '202409'
--rollback tran;return;;

            DECLARE @TBL_SCP_MST_CAPA_SPEED_PLAN        SCP_MST_CAPA_SPEED_PLAN_TYPE;

            INSERT INTO @TBL_SCP_MST_CAPA_SPEED_PLAN
            SELECT    @p_version                AS VER_ID
                    , @p_version_seq            AS VER_SEQ
	                , DIVISION_ID
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
	                , CONVERT(NVARCHAR(3000), NULL)     AS REMARK
	                , CREATED_BY
	                , CREATION_DATE
	                , LAST_UPDATED_BY
	                , LAST_UPDATE_DATE
            FROM    #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN
            WHERE   1=1
                AND MSR_TP_CD = 'PPM'; --PPM 만 있으면 Loss Plan 계산 가능하므로 설비대수, Speed는 제외!!!

--TESTING : NOK
--select  * from @TBL_SCP_MST_CAPA_SPEED_PLAN;rollback tran;return;

--select  A.* 
--from    SCP_MST_CAPA_LOSS_PLAN_MDL A
--        JOIN @TBL_SCP_MST_CAPA_SPEED_PLAN B ON
--		    A.DIVISION_ID		    = B.DIVISION_ID     
--	    AND A.COMPANY_ID		    = B.COMPANY_ID
--	    AND A.SITE_ID			    = B.SITE_ID
--	    AND A.PLANT_ID			    = B.PLANT_ID
--	    AND A.FACTORY_ID		    = B.FACTORY_ID
--	    AND A.LINE_ID			    = B.LINE_ID
--	    AND A.OPERATION_ID		    = B.OPERATION_ID
--	    AND A.ELTR_LN_TP_CD	        = B.ELTR_LN_TP_CD
--	    AND A.MDL_NM     		    = B.NICK_NAME
--	    AND A.YYYYMM     		    = B.YYYYMM
--WHERE   1=1
--    AND A.YYYYMM = '202503'
--rollback tran;return;;

--select * from @TBL_SCP_MST_CAPA_SPEED_PLAN rollback tran;return;;

            PRINT 'SAVE - LOSS_PLAN_BY_SPEED_PALN - BEGIN';
            EXEC SCP0106_CHECK_CAPA_LOSS_PLAN_BY_SPEED_ASSEMBLY   @TBL_SCP_MST_CAPA_SPEED_PLAN
                                                                , N'SCP0106'
                                                                , N'CURRENT'
	                                                            , @p_user_id
	                                                            , 'F';
            PRINT 'SAVE - LOSS_PLAN_BY_SPEED_PALN - END';

--TESTING : NOK
--select  A.* 
--from    SCP_MST_CAPA_LOSS_PLAN_MDL A
--        JOIN @TBL_SCP_MST_CAPA_SPEED_PLAN B ON
--		    A.DIVISION_ID		    = B.DIVISION_ID     
--	    AND A.COMPANY_ID		    = B.COMPANY_ID
--	    AND A.SITE_ID			    = B.SITE_ID
--	    AND A.PLANT_ID			    = B.PLANT_ID
--	    AND A.FACTORY_ID		    = B.FACTORY_ID
--	    AND A.LINE_ID			    = B.LINE_ID
--	    AND A.OPERATION_ID		    = B.OPERATION_ID
--	    AND A.ELTR_LN_TP_CD	        = B.ELTR_LN_TP_CD
--	    AND A.MDL_NM     		    = B.NICK_NAME
--	    AND A.YYYYMM     		    = B.YYYYMM
--WHERE   1=1
--    AND A.YYYYMM = '202410'
--rollback tran;return;;
        END

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
		IF OBJECT_ID('tempdb..#T_SCP0105_SCP_MST_CAPA_SPEED_PLAN') IS NOT NULL
			DROP TABLE #T_SCP0105_SCP_MST_CAPA_SPEED_PLAN;
	END
END

