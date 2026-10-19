
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0104_SAVE_CAPA_LINE_ASSIGN_ELTR
 * Description  : CAPA LINE ASSING
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/16   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/07/01   chaan        V1.1.2                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - DUMMY_YN 수정
 * 2024/07/11   chaan        V1.1.3                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 3차 Update
 * 2024/08/05   chaan        V1.1.5                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - FLOAT 로 변형
 * 2024/12/06   chaan        V1.1.6                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 월별 Partial 저장 로직 적용
 * 2025/04/08   hrkim		 V1.1.7                PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - CPS 소형 확산 및 S/W 오류 수정
*/

--CREATE PROCEDURE [dbo].[SCP0104_SAVE_CAPA_LINE_ASSIGN_ELTR]
CREATE PROCEDURE [dbo].[SCP0104_SAVE_CAPA_LINE_ASSIGN_ELTR]
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
	, @p_site_name			    NVARCHAR(MAX)
	, @p_company_name		    NVARCHAR(MAX)
	, @p_plant_name			    NVARCHAR(MAX)
	, @p_factory_name		    NVARCHAR(MAX)
	, @p_line_name			    NVARCHAR(MAX)
	, @p_lane_qty			    NVARCHAR(MAX)
	, @p_valid_yn			    NVARCHAR(MAX)
	, @p_item_id			    NVARCHAR(MAX)
	, @p_nick_name			    NVARCHAR(MAX)
	, @p_date_column_names      NVARCHAR(MAX)
	, @p_date_column_values     NVARCHAR(MAX)
	, @p_program_id			    NVARCHAR(100)
	, @p_sheet_name			    NVARCHAR(100)
	, @p_user_id			    NVARCHAR(30)
	, @debug_mode			    NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_version				    NVARCHAR(30)			= N'202411';
 --   DECLARE @p_version_seq			    TINYINT			        = 1;
 --   DECLARE @p_prog_stat  		        NVARCHAR(2)             = N'0';
 --   DECLARE @p_division_id			    NVARCHAR(MAX)			= N'81^';
 --   DECLARE @p_company_id			    NVARCHAR(MAX)			= N'G480^';
 --   DECLARE @p_site_id				    NVARCHAR(MAX)			= N'A004^';
 --   DECLARE @p_plant_id				    NVARCHAR(MAX)			= N'G482^';
 --   DECLARE @p_factory_id			    NVARCHAR(MAX)			= N'EJ^';
 --   DECLARE @p_line_id				    NVARCHAR(MAX)			= N'FP_EJM10_C^';
 --   DECLARE @p_operation_id			    NVARCHAR(MAX)			= N'E2000^';
 --   DECLARE @p_electrode_type		    NVARCHAR(MAX)			= N'W^';
 --   DECLARE @p_site_name			    NVARCHAR(MAX)			= N'LGES Poland^';
 --   DECLARE @p_company_name			    NVARCHAR(MAX)			= N'LG ES Wroclaw Sp. z o.o.^';
 --   DECLARE @p_plant_name			    NVARCHAR(MAX)			= N'WA Auto Elec^';
 --   DECLARE @p_factory_name			    NVARCHAR(MAX)			= N'WA8_E^';
 --   DECLARE @p_line_name			    NVARCHAR(MAX)			= N'Line 10(+)^';
 --   DECLARE @p_lane_qty				    NVARCHAR(MAX)			= N'2.0000000000^';
 --   DECLARE @p_valid_yn				    NVARCHAR(MAX)			= N'Y^';
 --   DECLARE @p_item_id				    NVARCHAR(MAX)			= N'APCCA2812A^';
 --   DECLARE @p_nick_name			    NVARCHAR(MAX)			= N'-^';
 --   DECLARE @p_date_column_names		NVARCHAR(MAX)			= N'M_01202412;M_01202501;M_01202502;M_01202503;M_01202504;M_01202505;M_01202506;M_01202507;M_01202508;M_01202509;M_01202510;M_01202511;M_01202512;M_01202601;M_01202602;M_01202603;M_01202604;M_01202605;M_01202606;M_01202607;M_01202608;M_01202609;M_01202610;M_01202611;M_01202612;Y_2027;Y_2028;Y_2029;^';
 --   DECLARE @p_date_column_values		NVARCHAR(MAX)			= N';1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;^';
 --   DECLARE @p_program_id				NVARCHAR(100)		    = N'SCP0104';
 --   DECLARE @p_sheet_name				NVARCHAR(100)		    = N'ELTR';
 --   DECLARE @p_user_id					NVARCHAR(30)		    = N'iamarock';
 --   DECLARE @debug_mode					NVARCHAR(1)			    = N'F';


	DECLARE @test_mode                          NVARCHAR(20)		= N'F';
  --DECLARE @test_mode                          NVARCHAR(20)	= N'T';

  	DECLARE @V_ELAPSED_TIME_BEG     DATETIME                = CURRENT_TIMESTAMP;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)	= 'SCP0104_SAVE_CAPA_LINE_ASSIGN_ELTR';
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


		IF OBJECT_ID('tempdb..#T_SCP0104_COMPANY') IS NOT NULL
			DROP TABLE #T_SCP0104_COMPANY;

        SELECT    A.DIVISION_ID
                , A.COMPANY_ID
                , A.COMPANY_NAME
        INTO    #T_SCP0104_COMPANY
        FROM    SCM_SITE_HIERARCHY_CPS_V_SN A WITH(NOLOCK)
	    WHERE	1=1
        GROUP BY   A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.COMPANY_NAME;

--TESTING : NOK
--select * from #T_SCP0104_COMPANY;rollback tran;return;
        
		IF OBJECT_ID('tempdb..#T_SCP0104_PLANT') IS NOT NULL
			DROP TABLE #T_SCP0104_PLANT;

        SELECT    A.DIVISION_ID
                , A.PLANT_ID
                , A.PLANT_NAME
        INTO    #T_SCP0104_PLANT
        FROM    SCM_SITE_HIERARCHY_CPS_V_SN A WITH(NOLOCK)
	    WHERE	1=1
        GROUP BY   A.DIVISION_ID
                 , A.PLANT_ID
                 , A.PLANT_NAME;

--TESTING : NOK
--select * from #T_SCP0104_PLANT;rollback tran;return;
        
		IF OBJECT_ID('tempdb..#T_SCP0104_FACTORY') IS NOT NULL
			DROP TABLE #T_SCP0104_FACTORY;

        SELECT    A.DIVISION_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
                , A.FACTORY_NAME
        INTO    #T_SCP0104_FACTORY
        FROM    [dbo].[SCM_MST_FACTORY_SN] A WITH(NOLOCK)
        WHERE   1=1
            AND ISNULL(A.ACTIVE_FLAG,'N') <> 'N'
        GROUP BY   A.DIVISION_ID
                 , A.PLANT_ID
			     , A.FACTORY_ID
                 , A.FACTORY_NAME;

--TESTING : NOK
--select * from #T_SCP0104_FACTORY;rollback tran;return;
        

		IF OBJECT_ID('tempdb..#T_SCP0104_LINE') IS NOT NULL
			DROP TABLE #T_SCP0104_LINE;

        SELECT    A.DIVISION_ID
                , A.PLANT_ID
                , A.FACTORY_ID
			    , A.LINE_ID
                , A.LINE_NAME
        INTO    #T_SCP0104_LINE
        FROM    SCM_LINE_HIERARCHY_CPS_V_SN A WITH(NOLOCK)
        WHERE   1=1
            AND NOT EXISTS (
                                SELECT  1
                                FROM    SCM_SYS_LOOKUP_VALUE_SN B WITH(NOLOCK)
                                WHERE   1=1
                                    AND B.LOOKUP_TYPE_CODE  = 'CAPA_UI_EXCEPT_LINE'
                                    AND B.ACTIVE_FLAG		= 'Y'
                                    AND A.DIVISION_ID		= B.SEGMENT1
                                    AND A.PLANT_ID		    = B.SEGMENT2
                                    AND A.LINE_ID			= B.SEGMENT4
                                    AND A.OPERATION_ID	    = B.SEGMENT3
                                    AND A.ELECTRODE_TYPE    = B.SEGMENT5
                           )
        GROUP BY      A.DIVISION_ID
                    , A.PLANT_ID
                    , A.FACTORY_ID
				    , A.LINE_ID
                    , A.LINE_NAME;

--TESTING : NOK
--select * from #T_SCP0104_LINE;rollback tran;return;


		IF OBJECT_ID('tempdb..#T_SCP0104_ITEM') IS NOT NULL
			DROP TABLE #T_SCP0104_ITEM;


    SELECT    DIVISION_ID
            , OPERATION_GROUP
            , OPERATION_ID
            , ITEM_ID
            , ITEM_NAME
            , NICK_NAME
    INTO    #T_SCP0104_ITEM
    FROM    FN_SCM0002_GET_CAPA_ITEM_POPUP('', '');

--TESTING : NOK
--select * from #T_SCP0104_ITEM;rollback tran;return;

	IF OBJECT_ID('tempdb..#tblSCP0104_EQPUIPMENT') IS NOT NULL
		DROP TABLE #tblSCP0104_EQPUIPMENT;

        --빈테이블 생성
        SELECT	  A.COMPANY_ID
		        , A.DIVISION_ID
		        , A.SITE_ID
		        , A.PLANT_ID
		        , A.FACTORY_ID
		        , A.LINE_ID
		        , A.OPERATION_ID
                , A.EQUIPMENT_ID
                , A.EQUIPMENT_NAME
		        , A.WIDE_ROLL_ENABLE_FLAG
                , IIF(A.WIDE_ROLL_ENABLE_FLAG = 'Y', 'W', 'S')      AS ELTR_LN_TP_CD
        INTO	#tblSCP0104_EQPUIPMENT
        FROM	SCM_MST_EQUIPMENT_SN A WITH(NOLOCK)
	    WHERE	1<>1

        INSERT INTO #tblSCP0104_EQPUIPMENT
        SELECT	  A.COMPANY_ID
		        , A.DIVISION_ID
		        , A.SITE_ID
		        , A.PLANT_ID
		        , A.FACTORY_ID
		        , A.LINE_ID
		        , A.OPERATION_ID
                , MAX(A.EQUIPMENT_ID) 									 AS EQUIPMENT_ID			-- 2025.04.08 Coating은 라인:설비=1:1 , 1:N 아닌 경우 대비 group by/max 처리 
                , MAX(A.EQUIPMENT_NAME)									 AS EQUIPMENT_NAME			-- 2025.04.08 Coating은 라인:설비=1:1 , 1:N 아닌 경우 대비 group by/max 처리 
		        , MAX(A.WIDE_ROLL_ENABLE_FLAG)							 AS WIDE_ROLL_ENABLE_FLAG	-- 2025.04.08 Coating은 라인:설비=1:1 , 1:N 아닌 경우 대비 group by/max 처리 
                , IIF(MAX(A.WIDE_ROLL_ENABLE_FLAG) = 'Y', 'W', 'S')      AS ELTR_LN_TP_CD			-- 2025.04.08 Coating은 라인:설비=1:1 , 1:N 아닌 경우 대비 group by/max 처리 
        FROM	SCM_MST_EQUIPMENT_SN A WITH(NOLOCK)
        WHERE	1=1
	        -- 2025.04.08 소형확산 AND A.DIVISION_ID      != '40'		-- 소형제외
	        AND A.OPERATION_ID LIKE 'E2000%'	-- 전극 Coating 공정 (현재는 E2000 공정 하나만 대상)  
	        AND A.EQUIPMENT_TYPE   = 'M'		-- Main 설비
	        AND A.ACTIVE_FLAG      = 'Y'
		GROUP BY  A.COMPANY_ID
		        , A.DIVISION_ID
		        , A.SITE_ID
		        , A.PLANT_ID
		        , A.FACTORY_ID
		        , A.LINE_ID
		        , A.OPERATION_ID

--TESTING : NOK
--select * from #tblSCP0104_EQPUIPMENT_TEMP;
--select * from #tblSCP0104_EQPUIPMENT;return;



		DECLARE @v_delimiter				NVARCHAR(1) = '^'

		DECLARE @v_all_cnt		        INTEGER		= 0;
		DECLARE @v_cnt					INTEGER		= 0;

		SET @v_all_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_division_id, @v_delimiter);

        PRINT CONCAT('@v_all_cnt : ', @v_all_cnt);

        PRINT N'속도 이슈로 Unpivot 을 UI 에서 DB 로 이전 BEGIN *******************************************************************************************************'
        BEGIN
			IF OBJECT_ID('tempdb..#T_SCP0104_DATE_COLUMNS') IS NOT NULL
				DROP TABLE #T_SCP0104_DATE_COLUMNS;

			SELECT    NR
					, COLUMN_NAME
					, COLUMN_VALUE
			INTO    #T_SCP0104_DATE_COLUMNS
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

			PRINT CONCAT('ELAPSED_TIME-#T_SCP0104_DATE_COLUMNS : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from #T_SCP0104_DATE_COLUMNS;rollback tran;return;


			IF OBJECT_ID('tempdb..#T_SCP0104_DATE_VALUES_TEMP') IS NOT NULL
				DROP TABLE #T_SCP0104_DATE_VALUES_TEMP;

			SELECT    CONVERT(INT, NULL)            AS ROW_NR
					, CONVERT(INT, NULL)            AS COL_NR
					, CONVERT(NVARCHAR(30),  NULL)  AS COL_NAME
					, CONVERT(NVARCHAR(100), NULL)  AS COL_VALUE
			INTO    #T_SCP0104_DATE_VALUES_TEMP
			WHERE   1<>1;

			IF CURSOR_STATUS('global','CUR_SCP0104_DATE_COLUMNS') >= -1
			BEGIN
				IF CURSOR_STATUS('global','CUR_SCP0104_DATE_COLUMNS') > -1
				BEGIN
					CLOSE CUR_SCP0104_DATE_COLUMNS
				END

				DEALLOCATE CUR_SCP0104_DATE_COLUMNS
			END

			DECLARE @v_nr                       INT                 = 0;
			DECLARE @v_column_names          	NVARCHAR(MAX)		= N'';
			DECLARE @v_column_values          	NVARCHAR(MAX)		= N'';

			DECLARE CUR_SCP0104_DATE_COLUMNS CURSOR FOR
			SELECT    NR
					, COLUMN_NAME
					, COLUMN_VALUE
			FROM    #T_SCP0104_DATE_COLUMNS;

			OPEN CUR_SCP0104_DATE_COLUMNS;
			FETCH NEXT FROM CUR_SCP0104_DATE_COLUMNS INTO @v_nr, @v_column_names, @v_column_values

			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO #T_SCP0104_DATE_VALUES_TEMP
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

				FETCH NEXT FROM CUR_SCP0104_DATE_COLUMNS INTO @v_nr, @v_column_names, @v_column_values
			END

			CLOSE CUR_SCP0104_DATE_COLUMNS;
			DEALLOCATE CUR_SCP0104_DATE_COLUMNS;

			PRINT CONCAT('ELAPSED_TIME-#T_SCP0104_DATE_VALUES_TEMP : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from #T_SCP0104_DATE_VALUES_TEMP;rollback tran;return;


			IF OBJECT_ID('tempdb..#T_SCP0104_DATE_VALUES') IS NOT NULL
				DROP TABLE #T_SCP0104_DATE_VALUES;

			SELECT    A.ROW_NR
					, A.YYYYMM
					, A.COL_VALUE AS QTY
			INTO    #T_SCP0104_DATE_VALUES
			FROM    (
						SELECT    ROW_NR
                                , COL_NR
								, COL_NAME
								, COL_VALUE
								, REPLACE(REPLACE(REPLACE(COL_NAME, 'M_00', ''), 'M_01', ''), 'Y_', '') AS YYYYMM
						FROM    #T_SCP0104_DATE_VALUES_TEMP
						WHERE   1=1
							AND (SUBSTRING(COL_NAME, 3, 2) = '01' OR SUBSTRING(COL_NAME, 1, 2) = 'Y_')
					) A

		PRINT CONCAT('ELAPSED_TIME-#T_SCP0104_DATE_VALUES : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from #T_SCP0104_DATE_VALUES;rollback tran;return;


        BEGIN --String_Split 함수 속도이슈로 임시 테이블로 저장함 -------------------------------------------------------------------
			IF OBJECT_ID('tempdb..#T_SCP0104_P1') IS NOT NULL
				DROP TABLE #T_SCP0104_P1;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P1
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P1
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_division_id,			'^')
            WHERE   1=1


			IF OBJECT_ID('tempdb..#T_SCP0104_P2') IS NOT NULL
				DROP TABLE #T_SCP0104_P2;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P2
			FROM	dbo.String_Split(@p_company_id,				'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P2
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_company_id,				'^')


			IF OBJECT_ID('tempdb..#T_SCP0104_P3') IS NOT NULL
				DROP TABLE #T_SCP0104_P3;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P3
			FROM	dbo.String_Split(@p_site_id,				'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P3
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_site_id,				'^')


			IF OBJECT_ID('tempdb..#T_SCP0104_P4') IS NOT NULL
				DROP TABLE #T_SCP0104_P4;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P4
			FROM	dbo.String_Split(@p_plant_id,				'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P4
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_plant_id,				'^')


			IF OBJECT_ID('tempdb..#T_SCP0104_P5') IS NOT NULL
				DROP TABLE #T_SCP0104_P5;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P5
			FROM	dbo.String_Split(@p_factory_id,				'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P5
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_factory_id,				'^')


			IF OBJECT_ID('tempdb..#T_SCP0104_P6') IS NOT NULL
				DROP TABLE #T_SCP0104_P6;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P6
			FROM	dbo.String_Split(@p_line_id,				'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P6
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_line_id,				'^')


			IF OBJECT_ID('tempdb..#T_SCP0104_P7') IS NOT NULL
				DROP TABLE #T_SCP0104_P7;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P7
			FROM	dbo.String_Split(@p_operation_id,			'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P7
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_operation_id,			'^')


			IF OBJECT_ID('tempdb..#T_SCP0104_P8') IS NOT NULL
				DROP TABLE #T_SCP0104_P8;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P8
			FROM	dbo.String_Split(@p_electrode_type,			'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P8
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_electrode_type,			'^')


			IF OBJECT_ID('tempdb..#T_SCP0104_P9') IS NOT NULL
				DROP TABLE #T_SCP0104_P9;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P9
			FROM	dbo.String_Split(@p_site_name,				'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P9
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_site_name,				'^')


			IF OBJECT_ID('tempdb..#T_SCP0104_P10') IS NOT NULL
				DROP TABLE #T_SCP0104_P10;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P10
			FROM	dbo.String_Split(@p_company_name,			'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P10
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_company_name,			'^')


			IF OBJECT_ID('tempdb..#T_SCP0104_P11') IS NOT NULL
				DROP TABLE #T_SCP0104_P11;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P11
			FROM	dbo.String_Split(@p_plant_name,				'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P11
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_plant_name,				'^')


			IF OBJECT_ID('tempdb..#T_SCP0104_P12') IS NOT NULL
				DROP TABLE #T_SCP0104_P12;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P12
			FROM	dbo.String_Split(@p_factory_name,			'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P12
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_factory_name,			'^')


			IF OBJECT_ID('tempdb..#T_SCP0104_P13') IS NOT NULL
				DROP TABLE #T_SCP0104_P13;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P13
			FROM	dbo.String_Split(@p_line_name,				'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P13
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_line_name,				'^')


			IF OBJECT_ID('tempdb..#T_SCP0104_P14') IS NOT NULL
				DROP TABLE #T_SCP0104_P14;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P14
			FROM	dbo.String_Split(@p_item_id,				'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P14
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_item_id,				'^')


			IF OBJECT_ID('tempdb..#T_SCP0104_P15') IS NOT NULL
				DROP TABLE #T_SCP0104_P15;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P15
			FROM	dbo.String_Split(@p_nick_name,				'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P15
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_nick_name,				'^')


			IF OBJECT_ID('tempdb..#T_SCP0104_P16') IS NOT NULL
				DROP TABLE #T_SCP0104_P16;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P16
			FROM	dbo.String_Split(@p_lane_qty,				'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P16
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_lane_qty,				'^')

			IF OBJECT_ID('tempdb..#T_SCP0104_P17') IS NOT NULL
				DROP TABLE #T_SCP0104_P17;

			SELECT	  CONVERT(INTEGER, NULL)        AS NR
					, CONVERT(NVARCHAR(300), NULL)  AS TOKEN
			INTO	#T_SCP0104_P17
			FROM	dbo.String_Split(@p_valid_yn,				'^')
			WHERE	1<>1

			INSERT INTO #T_SCP0104_P17
			SELECT	  NR
					, TOKEN 
			FROM	dbo.String_Split(@p_valid_yn,				'^')

--TESTING : NOK
--select * from #T_SCP0104_P1;rollback tran;return;
--select * from #T_SCP0104_P2;rollback tran;return;
--select * from #T_SCP0104_P3;rollback tran;return;
--select * from #T_SCP0104_P4;rollback tran;return;
--select * from #T_SCP0104_P5;rollback tran;return;
--select * from #T_SCP0104_P6;rollback tran;return;
--select * from #T_SCP0104_P7;rollback tran;return;
--select * from #T_SCP0104_P8;rollback tran;return;
--select * from #T_SCP0104_P9;rollback tran;return;
--select * from #T_SCP0104_P10;rollback tran;return;
--select * from #T_SCP0104_P11;rollback tran;return;
--select * from #T_SCP0104_P12;rollback tran;return;
--select * from #T_SCP0104_P13;rollback tran;return;
--select * from #T_SCP0104_P14;rollback tran;return;
--select * from #T_SCP0104_P15;rollback tran;return;
--select * from #T_SCP0104_P16;rollback tran;return;
--select * from #T_SCP0104_P17;rollback tran;return;


		    IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_TEMP') IS NOT NULL
			    DROP TABLE #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_TEMP;

			--빈테이블 만들기
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
                    , P9.TOKEN                                          AS SITE_NAME            
                    , P10.TOKEN                                         AS COMPANY_NAME         
                    , P11.TOKEN                                         AS PLANT_NAME           
                    , P12.TOKEN                                         AS FACTORY_NAME         
                    , P13.TOKEN                                         AS LINE_NAME            
                    , P14.TOKEN                                         AS ITEM_ID
                    ------전극조회에 Nickname 추가되서 저장시에는 '-' 로 저장, P15.TOKEN                                         AS NICK_NAME
                    , CONVERT(NVARCHAR(100), '-')                       AS NICK_NAME
					, A.YYYYMM                                          AS YYYYMM
                    , A.QTY                                             AS ASSIGN_PRIORITY
                    , CONVERT(NVARCHAR(1),   'N')						AS DUMMY_YN
                    , P16.TOKEN                                         AS LANE_QTY
                    , P17.TOKEN                                         AS VALID_YN
					, @p_user_id                                        AS CREATED_BY
					, SYSDATETIME()                                     AS CREATION_DATE
                    , @p_user_id                                        AS LAST_UPDATED_BY
                    , SYSDATETIME()                                     AS LAST_UPDATE_DATE
			INTO    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_TEMP
			FROM    #T_SCP0104_DATE_VALUES A
                    JOIN #T_SCP0104_P1  P1  ON A.ROW_NR = P1.NR
                    JOIN #T_SCP0104_P2  P2  ON A.ROW_NR = P2.NR
                    JOIN #T_SCP0104_P3  P3  ON A.ROW_NR = P3.NR
                    JOIN #T_SCP0104_P4  P4  ON A.ROW_NR = P4.NR
                    JOIN #T_SCP0104_P5  P5  ON A.ROW_NR = P5.NR
                    JOIN #T_SCP0104_P6  P6  ON A.ROW_NR = P6.NR
                    JOIN #T_SCP0104_P7  P7  ON A.ROW_NR = P7.NR
                    JOIN #T_SCP0104_P8  P8  ON A.ROW_NR = P8.NR
                    JOIN #T_SCP0104_P9  P9  ON A.ROW_NR = P9.NR
                    JOIN #T_SCP0104_P10 P10 ON A.ROW_NR = P10.NR
                    JOIN #T_SCP0104_P11 P11 ON A.ROW_NR = P11.NR
                    JOIN #T_SCP0104_P12 P12 ON A.ROW_NR = P12.NR
                    JOIN #T_SCP0104_P13 P13 ON A.ROW_NR = P13.NR
                    JOIN #T_SCP0104_P14 P14 ON A.ROW_NR = P14.NR
                    JOIN #T_SCP0104_P15 P15 ON A.ROW_NR = P15.NR
                    JOIN #T_SCP0104_P16 P16 ON A.ROW_NR = P16.NR
                    JOIN #T_SCP0104_P17 P17 ON A.ROW_NR = P17.NR
            WHERE   1<>1;

			INSERT INTO #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_TEMP
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
                    , P9.TOKEN                                          AS SITE_NAME            
                    , P10.TOKEN                                         AS COMPANY_NAME         
                    , P11.TOKEN                                         AS PLANT_NAME           
                    , P12.TOKEN                                         AS FACTORY_NAME         
                    , P13.TOKEN                                         AS LINE_NAME            
                    , P14.TOKEN                                         AS ITEM_ID
                    ------전극조회에 Nickname 추가되서 저장시에는 '-' 로 저장, P15.TOKEN                                         AS NICK_NAME
                    , CONVERT(NVARCHAR(100), '-')                       AS NICK_NAME
					, A.YYYYMM                                          AS YYYYMM
                    , A.QTY                                             AS ASSIGN_PRIORITY
                    , CONVERT(NVARCHAR(1),   'N')						AS DUMMY_YN
                    , P16.TOKEN                                         AS LANE_QTY
                    , P17.TOKEN                                         AS VALID_YN
					, @p_user_id                                        AS CREATED_BY
					, SYSDATETIME()                                     AS CREATION_DATE
                    , @p_user_id                                        AS LAST_UPDATED_BY
                    , SYSDATETIME()                                     AS LAST_UPDATE_DATE
			FROM    #T_SCP0104_DATE_VALUES A
                    JOIN #T_SCP0104_P1  P1  ON A.ROW_NR = P1.NR
                    JOIN #T_SCP0104_P2  P2  ON A.ROW_NR = P2.NR
                    JOIN #T_SCP0104_P3  P3  ON A.ROW_NR = P3.NR
                    JOIN #T_SCP0104_P4  P4  ON A.ROW_NR = P4.NR
                    JOIN #T_SCP0104_P5  P5  ON A.ROW_NR = P5.NR
                    JOIN #T_SCP0104_P6  P6  ON A.ROW_NR = P6.NR
                    JOIN #T_SCP0104_P7  P7  ON A.ROW_NR = P7.NR
                    JOIN #T_SCP0104_P8  P8  ON A.ROW_NR = P8.NR
                    JOIN #T_SCP0104_P9  P9  ON A.ROW_NR = P9.NR
                    JOIN #T_SCP0104_P10 P10 ON A.ROW_NR = P10.NR
                    JOIN #T_SCP0104_P11 P11 ON A.ROW_NR = P11.NR
                    JOIN #T_SCP0104_P12 P12 ON A.ROW_NR = P12.NR
                    JOIN #T_SCP0104_P13 P13 ON A.ROW_NR = P13.NR
                    JOIN #T_SCP0104_P14 P14 ON A.ROW_NR = P14.NR
                    JOIN #T_SCP0104_P15 P15 ON A.ROW_NR = P15.NR
                    JOIN #T_SCP0104_P16 P16 ON A.ROW_NR = P16.NR
                    JOIN #T_SCP0104_P17 P17 ON A.ROW_NR = P17.NR

			PRINT CONCAT('ELAPSED_TIME-#T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_TEMP : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_TEMP;rollback tran;return;
--select * from #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_TEMP where YYYYMM = '202409';rollback tran;return;
        END --String_Split 함수 속도이슈로 임시 테이블로 저장함 -------------------------------------------------------------------


		    IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN1') IS NOT NULL
			    DROP TABLE #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN1;

			--빈테이블 만들기
			SELECT	  CONVERT(NVARCHAR(10), NULL)		AS VER_ID
					, CONVERT(TINYINT,		NULL)		AS VER_SEQ
					, DIVISION_ID
					, COMPANY_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, LINE_ID
					, OPERATION_ID
					, ELTR_LN_TP_CD
					, CONVERT(NVARCHAR(100), NULL)     AS SITE_NAME
					, CONVERT(NVARCHAR(100), NULL)     AS COMPANY_NAME
					, CONVERT(NVARCHAR(100), NULL)     AS PLANT_NAME
					, CONVERT(NVARCHAR(100), NULL)     AS FACTORY_NAME
					, CONVERT(NVARCHAR(100), NULL)     AS LINE_NAME
					, LANE_QTY
					, ITEM_ID
					, NICK_NAME
					, YYYYMM
					, ASSIGN_PRIORITY
					, DUMMY_YN
					, VALID_YN
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
			INTO	#T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN1
			FROM	SCP_MST_CAPA_ELTR_LINE_ASSIGN WITH(NOLOCK)
			WHERE	1<>1;

			INSERT INTO #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN1
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
					, LTRIM(RTRIM(REPLACE(SITE_NAME,	 SITE_ID,		'')))	--명칭에 id 가 포함된 경우 제거
					, LTRIM(RTRIM(REPLACE(COMPANY_NAME,	 COMPANY_ID,	'')))	--명칭에 id 가 포함된 경우 제거
					, LTRIM(RTRIM(REPLACE(PLANT_NAME,	 PLANT_ID,		'')))	--명칭에 id 가 포함된 경우 제거
					, LTRIM(RTRIM(REPLACE(FACTORY_NAME,	 FACTORY_ID,	'')))	--명칭에 id 가 포함된 경우 제거
					, LTRIM(RTRIM(REPLACE(LINE_NAME,	 LINE_ID,		'')))	--명칭에 id 가 포함된 경우 제거
					, CONVERT(FLOAT,   IIF(ISNULL(LANE_QTY, '') = '', '0', LANE_QTY))
					, ITEM_ID
					, NICK_NAME
					, YYYYMM
					, CONVERT(FLOAT,   IIF(ISNULL(ASSIGN_PRIORITY, '') = '', '0', ASSIGN_PRIORITY))
					, DUMMY_YN
					, VALID_YN
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
			FROM	#T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_TEMP


			PRINT CONCAT('ELAPSED_TIME#T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN1 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN1 WHERE YYYYMM = '202601';rollback tran; return;
        END
        PRINT N'속도 이슈로 Unpivot 을 UI 에서 DB 로 이전 - END *******************************************************************************************************'


		--빈라인이 추가되어 삭제
		DELETE FROM #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN1
		WHERE  ISNULL(DIVISION_ID, '') = ''
			OR ISNULL(COMPANY_ID, '') = ''
			OR ISNULL(SITE_ID, '') = ''
			OR ISNULL(PLANT_ID, '') = ''
			OR ISNULL(FACTORY_ID, '') = ''
			OR ISNULL(LINE_ID, '') = ''
			OR ISNULL(OPERATION_ID, '') = ''
			------OR ISNULL(ELTR_LN_TP_CD, '') = ''
			OR ISNULL(ITEM_ID, '') = ''
			OR ISNULL(YYYYMM, '') = '';


        --DUMMY_YN 로직 수정
        UPDATE A
            SET
                A.DUMMY_YN = 'Y'
        FROM    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN1 A
                LEFT JOIN (
                                SELECT  DISTINCT 
                                        ITEM_ID
                                FROM    FN_SCM0002_GET_CAPA_ITEM_POPUP('', '')
                                WHERE   1=1
                           ) B ON
                A.ITEM_ID = B.ITEM_ID
        WHERE   1=1
            AND (
                       A.SITE_ID LIKE 'DMY_%'
                    OR A.COMPANY_ID LIKE 'DMY_%'
                    OR A.PLANT_ID LIKE 'DMY_%'
                    OR A.FACTORY_ID LIKE 'DMY_%'
                    OR A.LINE_ID LIKE 'DMY_%'
                    OR B.ITEM_ID IS NULL
                )


	IF OBJECT_ID('tempdb..#tblSCP0104_EQUIP_TYPE_ASSIGN') IS NOT NULL --기존 Line Assign 에 존재하는 동일 라인의 설비유형
		DROP TABLE #tblSCP0104_EQUIP_TYPE_ASSIGN;

        --빈테이블 생성
        SELECT	  A.COMPANY_ID
		        , A.DIVISION_ID
		        , A.SITE_ID
		        , A.PLANT_ID
		        , A.FACTORY_ID
		        , A.LINE_ID
		        , A.OPERATION_ID
                , A.ELTR_LN_TP_CD
        INTO	#tblSCP0104_EQUIP_TYPE_ASSIGN
        FROM	#T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN1 A
	    WHERE	1<>1

        INSERT INTO #tblSCP0104_EQUIP_TYPE_ASSIGN
        SELECT	  A.COMPANY_ID
		        , A.DIVISION_ID
		        , A.SITE_ID
		        , A.PLANT_ID
		        , A.FACTORY_ID
		        , A.LINE_ID
		        , A.OPERATION_ID
                , MAX(A.ELTR_LN_TP_CD) AS ELTR_LN_TP_CD
        FROM	SCP_MST_CAPA_ELTR_LINE_ASSIGN A
                INNER JOIN #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN1 B ON
                        A.COMPANY_ID        = B.COMPANY_ID
		            AND A.DIVISION_ID       = B.DIVISION_ID
		            AND A.SITE_ID           = B.SITE_ID
		            AND A.PLANT_ID          = B.PLANT_ID
		            AND A.FACTORY_ID        = B.FACTORY_ID
		            AND A.LINE_ID           = B.LINE_ID
        WHERE	1=1
            --AND A.VALID_YN = 'Y'
        GROUP BY  A.COMPANY_ID
		        , A.DIVISION_ID
		        , A.SITE_ID
		        , A.PLANT_ID
		        , A.FACTORY_ID
		        , A.LINE_ID
		        , A.OPERATION_ID

--TESTING : NOK
--select * from #tblSCP0104_EQUIP_TYPE_ASSIGN;rollback tran;return;


		IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_ALL') IS NOT NULL
			DROP TABLE #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_ALL;

		SELECT	  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.SITE_NAME
				, A.COMPANY_NAME
				, A.PLANT_NAME
				, A.FACTORY_NAME
				, A.LINE_NAME
				, A.LANE_QTY
				, A.ITEM_ID
				, A.NICK_NAME
				, A.YYYYMM
				, A.ASSIGN_PRIORITY
				, A.DUMMY_YN
				, A.VALID_YN
				, A.CREATED_BY
				, A.CREATION_DATE
				, A.LAST_UPDATED_BY
				, A.LAST_UPDATE_DATE
        INTO    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_ALL
		FROM    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN1 A
        WHERE   1<>1

        INSERT INTO #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_ALL
		SELECT	  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, CASE
                    WHEN ISNULL(E.ELTR_LN_TP_CD, '') <> '' THEN E.ELTR_LN_TP_CD  -- 2025.04.08 case 추가 : : W/S 데이터 오류 건 수정
                    WHEN ISNULL(B.ELTR_LN_TP_CD, '') <> '' THEN B.ELTR_LN_TP_CD
                   ELSE 'S'
                    END AS ELTR_LN_TP_CD
				, A.SITE_NAME
				, A.COMPANY_NAME
				, A.PLANT_NAME
				, A.FACTORY_NAME
				, A.LINE_NAME
				, A.LANE_QTY
				, A.ITEM_ID
				, A.NICK_NAME
				, A.YYYYMM
				, A.ASSIGN_PRIORITY
				, A.DUMMY_YN
				, A.VALID_YN
				, A.CREATED_BY
				, A.CREATION_DATE
				, A.LAST_UPDATED_BY
				, A.LAST_UPDATE_DATE
		FROM    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN1 A
                LEFT JOIN #tblSCP0104_EQUIP_TYPE_ASSIGN B ON 
                        A.COMPANY_ID        = B.COMPANY_ID
		            AND A.DIVISION_ID       = B.DIVISION_ID
		            AND A.SITE_ID           = B.SITE_ID
		            AND A.PLANT_ID          = B.PLANT_ID
		            AND A.FACTORY_ID        = B.FACTORY_ID
		            AND A.LINE_ID           = B.LINE_ID
		            AND A.OPERATION_ID      = B.OPERATION_ID
                LEFT JOIN #tblSCP0104_EQPUIPMENT E ON	--- 2025.04.08 조인 추가 : W/S 데이터 오류 건 수정
                        A.COMPANY_ID        = E.COMPANY_ID
		            AND A.DIVISION_ID       = E.DIVISION_ID
		            AND A.SITE_ID           = E.SITE_ID
		            AND A.PLANT_ID          = E.PLANT_ID
		            AND A.FACTORY_ID        = E.FACTORY_ID
		            AND A.LINE_ID           = E.LINE_ID
		            AND A.OPERATION_ID      = E.OPERATION_ID
        WHERE   1=1


--TESTING : NOK
--select * from #tblSCP0104_EQUIP_TYPE_ASSIGN;
--select * from #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN1 WHERE YYYYMM = '202411';
--select * from #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_ALL;rollback tran;return;


        --변경된 데이터만 해당 BEGIN--------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN') IS NOT NULL
			DROP TABLE #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN;

        ;WITH tblChanged AS
        (
            SELECT    A.*
                    , B.DIVISION_ID     AS OLD_DIVISION_ID
                    , B.VALID_YN        AS OLD_VALID_YN
                    , B.ASSIGN_PRIORITY AS OLD_ASSIGN_PRIORITY
                    , B.DUMMY_YN        AS OLD_DUMMY_YN
                    , B.LANE_QTY        AS OLD_LANE_QTY
            FROM    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_ALL A
                    LEFT JOIN SCP_MST_CAPA_ELTR_LINE_ASSIGN B ON
					        A.DIVISION_ID		= B.DIVISION_ID
				        AND A.COMPANY_ID		= B.COMPANY_ID
				        AND A.SITE_ID			= B.SITE_ID
				        AND A.PLANT_ID			= B.PLANT_ID
				        AND A.FACTORY_ID		= B.FACTORY_ID
				        AND A.LINE_ID			= B.LINE_ID
				        AND A.OPERATION_ID		= B.OPERATION_ID
				        AND A.ITEM_ID	        = B.ITEM_ID
				        AND A.YYYYMM	        = B.YYYYMM
        )
            SELECT  *
            INTO    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN
            FROM    tblChanged A
            WHERE   1=1
                AND (OLD_DIVISION_ID IS NULL OR (VALID_YN <> OLD_VALID_YN OR ISNULL(ASSIGN_PRIORITY, 0) <> ISNULL(OLD_ASSIGN_PRIORITY, 0) OR DUMMY_YN <> OLD_DUMMY_YN OR ISNULL(LANE_QTY, 0) <> ISNULL(OLD_LANE_QTY, 0))) 
        --변경된 데이터만 해당 END--------------------------------------------------------------------------------------------------------

--TESTING : NOK
----select * from #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN;rollback tran;return;



        BEGIN --데이터 저장 - 마스터
    		IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_ELTR_LINE_MDL') IS NOT NULL
	    		DROP TABLE #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_MDL;

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
					, SITE_NAME
					, COMPANY_NAME
					, PLANT_NAME
					, FACTORY_NAME
					, LINE_NAME
                    , DUMMY_YN
            INTO    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_MDL
            FROM    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN
            WHERE   1<>1;
            
            INSERT INTO #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_MDL
            SELECT    DIVISION_ID
					, COMPANY_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, LINE_ID
					, OPERATION_ID
					, MAX(ELTR_LN_TP_CD)    AS ELTR_LN_TP_CD
					, ITEM_ID
					, NICK_NAME
			        , MAX(SITE_NAME)		AS SITE_NAME
			        , MAX(COMPANY_NAME)		AS COMPANY_NAME
			        , MAX(PLANT_NAME)		AS PLANT_NAME
			        , MAX(FACTORY_NAME)		AS FACTORY_NAME
			        , MAX(LINE_NAME)		AS LINE_NAME
                    , MAX(DUMMY_YN)         AS DUMMY_YN
            FROM    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN
            WHERE   1=1
            GROUP BY  DIVISION_ID
					, COMPANY_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, LINE_ID
					, OPERATION_ID
					------, ELTR_LN_TP_CD
					, ITEM_ID
					, NICK_NAME;
--TESTING : NOK
--select * from #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_MDL;rollback tran;return;


    		PRINT 'SAVE - SCP_MST_CAPA_ELTR_LINE_MDL - BEGIN';
			MERGE INTO SCP_MST_CAPA_ELTR_LINE_MDL A
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
						, DUMMY_YN
						, @p_user_id				            AS CREATED_BY
						, SYSDATETIME()				            AS CREATION_DATE
						, @p_user_id				            AS LAST_UPDATED_BY
						, SYSDATETIME()				            AS LAST_UPDATE_DATE
                FROM    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_MDL A
			) B ON
			(
					A.DIVISION_ID		= B.DIVISION_ID
				AND A.COMPANY_ID		= B.COMPANY_ID
				AND A.SITE_ID			= B.SITE_ID
				AND A.PLANT_ID			= B.PLANT_ID
				AND A.FACTORY_ID		= B.FACTORY_ID
				AND A.LINE_ID			= B.LINE_ID
				AND A.OPERATION_ID		= B.OPERATION_ID
				----AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
				AND A.ITEM_ID	        = B.ITEM_ID
				AND A.NICK_NAME	        = B.NICK_NAME
			)
			WHEN MATCHED THEN
			UPDATE
			SET
				  DUMMY_YN				= B.DUMMY_YN
				, ELTR_LN_TP_CD	        = B.ELTR_LN_TP_CD
				, LAST_UPDATED_BY		= B.LAST_UPDATED_BY
				, LAST_UPDATE_DATE		= B.LAST_UPDATE_DATE
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
                , DUMMY_YN
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
                , B.DUMMY_YN
				, B.CREATED_BY
				, B.CREATION_DATE
				, B.LAST_UPDATED_BY
				, B.LAST_UPDATE_DATE
			);
    		PRINT 'SAVE - SCP0104_SCP_MST_CAPA_ELTR_LINE_MDL - END';

--TESTING : NOK
--select * from SCP_MST_CAPA_ELTR_LINE_MDL;rollback tran;return;

    	------	IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_ELTR_LINE') IS NOT NULL
	    ------		DROP TABLE #T_SCP0104_SCP_MST_CAPA_ELTR_LINE;

     ------       SELECT    DIVISION_ID
					------, COMPANY_ID
					------, SITE_ID
					------, PLANT_ID
					------, FACTORY_ID
					------, LINE_ID
					------, OPERATION_ID
					------, ELTR_LN_TP_CD
					------, SITE_NAME
					------, COMPANY_NAME
					------, PLANT_NAME
					------, FACTORY_NAME
					------, LINE_NAME
     ------               , VALID_YN
     ------       INTO    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE
     ------       FROM    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN
     ------       WHERE   1<>1;

     ------       INSERT INTO #T_SCP0104_SCP_MST_CAPA_ELTR_LINE
     ------       SELECT    DIVISION_ID
					------, COMPANY_ID
					------, SITE_ID
					------, PLANT_ID
					------, FACTORY_ID
					------, LINE_ID
					------, OPERATION_ID
					------, ELTR_LN_TP_CD
					------, SITE_NAME
					------, COMPANY_NAME
					------, PLANT_NAME
					------, FACTORY_NAME
					------, LINE_NAME
     ------               , MAX(VALID_YN)     AS VALID_YN
     ------       FROM    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN
     ------       GROUP BY  DIVISION_ID
					------, COMPANY_ID
					------, SITE_ID
					------, PLANT_ID
					------, FACTORY_ID
					------, LINE_ID
					------, OPERATION_ID
					------, ELTR_LN_TP_CD
					------, SITE_NAME
					------, COMPANY_NAME
					------, PLANT_NAME
					------, FACTORY_NAME
					------, LINE_NAME

--TESTING : NOK
--PRINT 'XXXXXXXXX'
--select * from #T_SCP0104_SCP_MST_CAPA_ELTR_LINE;rollback tran;return;
            
			------MERGE INTO SCP_MST_CAPA_ELTR_LINE A
			------USING
			------(
			------	SELECT	  A.*
			------			, @p_user_id				            AS CREATED_BY
			------			, SYSDATETIME()				            AS CREATION_DATE
			------			, @p_user_id				            AS LAST_UPDATED_BY
			------			, SYSDATETIME()				            AS LAST_UPDATE_DATE
   ------             FROM    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE A
			------) B ON
			------(
			------		A.DIVISION_ID		= B.DIVISION_ID
			------	AND A.COMPANY_ID		= B.COMPANY_ID
			------	AND A.SITE_ID			= B.SITE_ID
			------	AND A.PLANT_ID			= B.PLANT_ID
			------	AND A.FACTORY_ID		= B.FACTORY_ID
			------	AND A.LINE_ID			= B.LINE_ID
			------	AND A.OPERATION_ID		= B.OPERATION_ID
			------	--AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
			------)
			------WHEN MATCHED THEN
			------UPDATE
			------SET
			------	  SITE_NAME				= B.SITE_NAME
			------	, COMPANY_NAME			= B.COMPANY_NAME
			------	, PLANT_NAME			= B.PLANT_NAME
			------	, FACTORY_NAME			= B.FACTORY_NAME
			------	, LINE_NAME				= B.LINE_NAME
			------	, VALID_YN				= B.VALID_YN
			------	----, ELTR_LN_TP_CD	        = B.ELTR_LN_TP_CD
			------	, LAST_UPDATED_BY		= B.LAST_UPDATED_BY
			------	, LAST_UPDATE_DATE		= B.LAST_UPDATE_DATE
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
			------	, SITE_NAME
			------	, COMPANY_NAME
			------	, PLANT_NAME
			------	, FACTORY_NAME
			------	, LINE_NAME
			------	, VALID_YN
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
			------	, B.SITE_NAME
			------	, B.COMPANY_NAME
			------	, B.PLANT_NAME
			------	, B.FACTORY_NAME
			------	, B.LINE_NAME
			------	, B.VALID_YN
			------	, B.CREATED_BY
			------	, B.CREATION_DATE
			------	, B.LAST_UPDATED_BY
			------	, B.LAST_UPDATE_DATE
			------);

    		------PRINT 'SAVE - SCP0104_SCP_MST_CAPA_ELTR_LINE - END';
        END --데이터 저장 - 마스터
--TESTING : NOK
--SELECT  A.* 
--FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN A
--        JOIN #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN B ON
--			    A.DIVISION_ID		= B.DIVISION_ID
--		    AND A.COMPANY_ID		= B.COMPANY_ID
--		    AND A.SITE_ID			= B.SITE_ID
--		    AND A.PLANT_ID			= B.PLANT_ID
--		    AND A.FACTORY_ID		= B.FACTORY_ID
--		    AND A.LINE_ID			= B.LINE_ID
--		    AND A.OPERATION_ID		= B.OPERATION_ID
--		    ----AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
--		    AND A.ITEM_ID			= B.ITEM_ID
--		    AND A.NICK_NAME			= B.NICK_NAME
--		    AND A.YYYYMM			= B.YYYYMM
--WHERE   1=1
--    AND A.YYYYMM = '202601'
--    AND ((A.LANE_QTY <> B.LANE_QTY) OR
--        (A.ASSIGN_PRIORITY <> B.ASSIGN_PRIORITY) OR  
--        (A.VALID_YN <> B.VALID_YN))
--rollback tran;return;


        BEGIN --데이터 저장 - 본테이블
        	PRINT 'SAVE - SCP_MST_CAPA_ELTR_LINE_ASSIGN - BEGIN';

			MERGE INTO SCP_MST_CAPA_ELTR_LINE_ASSIGN A
			USING
			(
				SELECT	*
                FROM    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN
                WHERE   1=1
                    AND ISNULL(DIVISION_ID, '') <> ''
                    AND ISNULL(COMPANY_ID, '') <> ''
                    AND ISNULL(SITE_ID, '') <> ''
                    AND ISNULL(PLANT_ID, '') <> ''
                    AND ISNULL(FACTORY_ID, '') <> ''
                    AND ISNULL(LINE_ID, '') <> ''
                    AND ISNULL(OPERATION_ID, '') <> ''
                    ------AND ISNULL(ELTR_LN_TP_CD, '') <> ''
            		AND ISNULL(ITEM_ID, '') <> ''
                    AND ISNULL(YYYYMM, '') <> ''
			) B ON
			(
					A.DIVISION_ID		= B.DIVISION_ID
				AND A.COMPANY_ID		= B.COMPANY_ID
				AND A.SITE_ID			= B.SITE_ID
				AND A.PLANT_ID			= B.PLANT_ID
				AND A.FACTORY_ID		= B.FACTORY_ID
				AND A.LINE_ID			= B.LINE_ID
				AND A.OPERATION_ID		= B.OPERATION_ID
				--AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
				AND A.ITEM_ID			= B.ITEM_ID
				--AND A.NICK_NAME			= B.NICK_NAME
				AND A.YYYYMM			= B.YYYYMM
			)
			--WHEN MATCHED AND ((A.LANE_QTY <> B.LANE_QTY) OR
   --                           (A.ASSIGN_PRIORITY <> B.ASSIGN_PRIORITY) OR  
   --                           (A.VALID_YN <> B.VALID_YN))THEN
			WHEN MATCHED THEN
			UPDATE
			SET
    			  LANE_QTY		        = B.LANE_QTY
				, ASSIGN_PRIORITY		= B.ASSIGN_PRIORITY
				, DUMMY_YN		        = B.DUMMY_YN
				, VALID_YN		        = B.VALID_YN
				, ELTR_LN_TP_CD	        = B.ELTR_LN_TP_CD
				, LAST_UPDATED_BY		= B.LAST_UPDATED_BY
				, LAST_UPDATE_DATE		= B.LAST_UPDATE_DATE
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
				, YYYYMM
                , LANE_QTY
				, ASSIGN_PRIORITY
                , DUMMY_YN
                , VALID_YN
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
				, B.YYYYMM
                , B.LANE_QTY
				, B.ASSIGN_PRIORITY
                , B.DUMMY_YN
                , B.VALID_YN
				, B.CREATED_BY
				, B.CREATION_DATE
				, B.LAST_UPDATED_BY
				, B.LAST_UPDATE_DATE
			);

        	PRINT 'SAVE - SCP_MST_CAPA_ELTR_LINE_ASSIGN - END';

--TESTING : NOK
--SELECT  A.* 
--FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN A
--        JOIN #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN B ON
--			    A.DIVISION_ID		= B.DIVISION_ID
--		    AND A.COMPANY_ID		= B.COMPANY_ID
--		    AND A.SITE_ID			= B.SITE_ID
--		    AND A.PLANT_ID			= B.PLANT_ID
--		    AND A.FACTORY_ID		= B.FACTORY_ID
--		    AND A.LINE_ID			= B.LINE_ID
--		    AND A.OPERATION_ID		= B.OPERATION_ID
--		    ----AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
--		    AND A.ITEM_ID			= B.ITEM_ID
--		    AND A.NICK_NAME			= B.NICK_NAME
--		    AND A.YYYYMM			= B.YYYYMM
--WHERE   1=1
--    --AND A.YYYYMM = '202601'
--;rollback tran;return;
        END--데이터 저장 - 본테이블

        BEGIN -- 더미 데이터 정리
            PRINT '더미 데이터 정리 - BEGIN';
			DELETE	A
			FROM    SCP_MST_CAPA_DUMMY_CODE A
					LEFT JOIN (
								SELECT DISTINCT
										  CODE_TP
										, CODE
								FROM    (
											SELECT DISTINCT 
													  'S'       AS CODE_TP
													, SITE_ID   AS CODE
											FROM    SCP_MST_CAPA_LINE_ASSIGN
											UNION ALL
											SELECT DISTINCT 
													  'S'       AS CODE_TP
													, SITE_ID   AS CODE
											FROM    SCP_MST_CAPA_LINE_ASSIGN_CUTF
											UNION ALL
											SELECT DISTINCT 
													  'C'       AS CODE_TP
													, COMPANY_ID   AS CODE
											FROM    SCP_MST_CAPA_LINE_ASSIGN
											UNION ALL
											SELECT DISTINCT 
													  'P'       AS CODE_TP
													, PLANT_ID
											FROM    SCP_MST_CAPA_LINE_ASSIGN
											UNION ALL
											SELECT DISTINCT 
													  'P'       AS CODE_TP
													, PLANT_ID
											FROM    SCP_MST_CAPA_LINE_ASSIGN_CUTF
											UNION ALL
											SELECT DISTINCT 
													  'F'       AS CODE_TP
													, FACTORY_ID
											FROM    SCP_MST_CAPA_LINE_ASSIGN
											UNION ALL
											SELECT DISTINCT 
													  'F'       AS CODE_TP
													, FACTORY_ID
											FROM    SCP_MST_CAPA_LINE_ASSIGN_CUTF
											UNION ALL
											SELECT DISTINCT 
													  'L'       AS CODE_TP
													, LINE_ID
											FROM    SCP_MST_CAPA_LINE_ASSIGN
											UNION ALL
											SELECT DISTINCT 
													  'L'       AS CODE_TP
													, LINE_ID
											FROM    SCP_MST_CAPA_LINE_ASSIGN_CUTF
										) A
							) B ON
						A.CODE_TP = B.CODE_TP
					AND A.CODE    = B.CODE
					LEFT JOIN (
								SELECT DISTINCT
										  CODE_TP
										, CODE
								FROM    (
											SELECT DISTINCT 
													  'S'       AS CODE_TP
													, SITE_ID   AS CODE
											FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN
											UNION ALL
											SELECT DISTINCT 
													  'S'       AS CODE_TP
													, SITE_ID   AS CODE
											FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF
											UNION ALL
											SELECT DISTINCT 
													  'C'       AS CODE_TP
													, COMPANY_ID   AS CODE
											FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN
											UNION ALL
											SELECT DISTINCT 
													  'P'       AS CODE_TP
													, PLANT_ID
											FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN
											UNION ALL
											SELECT DISTINCT 
													  'P'       AS CODE_TP
													, PLANT_ID
											FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF
											UNION ALL
											SELECT DISTINCT 
													  'F'       AS CODE_TP
													, FACTORY_ID
											FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN
											UNION ALL
											SELECT DISTINCT 
													  'F'       AS CODE_TP
													, FACTORY_ID
											FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF
											UNION ALL
											SELECT DISTINCT 
													  'L'       AS CODE_TP
													, LINE_ID
											FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN
											UNION ALL
											SELECT DISTINCT 
													  'L'       AS CODE_TP
													, LINE_ID
											FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF
										) A
							) C ON
						A.CODE_TP = C.CODE_TP
					AND A.CODE    = C.CODE
					LEFT JOIN (
								SELECT DISTINCT
										  CODE_TP
										, NAME
								FROM    (
											SELECT    'N'       AS CODE_TP
													, NICK_NAME AS NAME
											FROM    SCP_MST_CAPA_LINE_ASSIGN
											UNION ALL
											SELECT    'N'       AS CODE_TP
													, NICK_NAME AS NAME
											FROM    SCP_MST_CAPA_LINE_ASSIGN_CUTF
											UNION ALL
											SELECT DISTINCT 
													  'I'       AS CODE_TP
													, ITEM_ID
											FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN
											UNION ALL
											SELECT DISTINCT 
													  'I'       AS CODE_TP
													, ITEM_ID
											FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF
										) A
							  ) D ON 
						A.CODE_TP = D.CODE_TP
					AND A.NAME    = D.NAME
			WHERE   1=1
				AND RTRIM(LTRIM(ISNULL(B.CODE, ''))) = ''
				AND RTRIM(LTRIM(ISNULL(C.CODE, ''))) = ''
				AND RTRIM(LTRIM(ISNULL(D.NAME, ''))) = ''

            PRINT '더미 데이터 정리 - END';
        END --더미 데이터 정리



    	IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS') IS NOT NULL
	    	DROP TABLE #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS;
            
        --빈테이블 생성
        SELECT    CONVERT(NVARCHAR(10), NULL)		AS VER_ID 
                , CONVERT(TINYINT, NULL)			AS VER_SEQ 
                , CONVERT(NVARCHAR(30), NULL)		AS DIVISION_ID 
                , CONVERT(NVARCHAR(30), NULL)		AS COMPANY_ID 
                , CONVERT(NVARCHAR(30), NULL)		AS SITE_ID 
                , CONVERT(NVARCHAR(30), NULL)		AS PLANT_ID 
                , CONVERT(NVARCHAR(30), NULL)		AS FACTORY_ID 
                , CONVERT(NVARCHAR(30), NULL)		AS LINE_ID 
                , CONVERT(NVARCHAR(30), NULL)		AS OPERATION_ID 
                , CONVERT(NVARCHAR(30), NULL)		AS ELTR_LN_TP_CD 
                , CONVERT(NVARCHAR(100), NULL)		AS ITEM_ID 
                , CONVERT(NVARCHAR(100), NULL)		AS NICK_NAME 
                , CONVERT(NVARCHAR(6), NULL)		AS YYYYMM 
                , CONVERT(FLOAT, NULL)	AS LANE_QTY
                , CONVERT(NUMERIC(4, 0), NULL)		AS ASSIGN_PRIORITY 
                , CONVERT(NVARCHAR(1), NULL)		AS DUMMY_YN 
                , CONVERT(NVARCHAR(1), NULL)		AS VALID_YN 
                , CONVERT(NVARCHAR(200), NULL)		AS CREATED_BY 
                , CONVERT(DATETIME, NULL)			AS CREATION_DATE 
                , CONVERT(NVARCHAR(200), NULL)		AS LAST_UPDATED_BY 
                , CONVERT(DATETIME, NULL)			AS LAST_UPDATE_DATE 
        INTO    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS
        FROM    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN
        WHERE   1<>1;

        INSERT INTO #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS
        SELECT    VER_ID
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
                , YYYYMM
                , LANE_QTY
                , ASSIGN_PRIORITY
                , DUMMY_YN
                , VALID_YN
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE
        FROM    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN;

--TESTING : NOK
--select * from #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS;rollback tran;return;


        BEGIN -- 데이터 저장 - Speed Paln
            DECLARE @v_updated_cnt  INT = 0;

            SELECT  @v_updated_cnt  = COUNT(*)
            FROM    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS;

            PRINT CONCAT('@v_updated_cnt : ', @v_updated_cnt);

            IF @v_updated_cnt > 0
            BEGIN
                DECLARE @T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS       SCP_MST_CAPA_LINE_ASSIGN_TYPE

                INSERT INTO @T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS
                SELECT	  CONVERT(NVARCHAR(10),		VER_ID)
			            , CONVERT(TINYINT,			VER_SEQ)
			            , CONVERT(NVARCHAR(30),		DIVISION_ID)
			            , CONVERT(NVARCHAR(30),		COMPANY_ID)
			            , CONVERT(NVARCHAR(30),		SITE_ID)
			            , CONVERT(NVARCHAR(30),		PLANT_ID)
			            , CONVERT(NVARCHAR(30),		FACTORY_ID)
			            , CONVERT(NVARCHAR(30),		LINE_ID)
			            , CONVERT(NVARCHAR(30),		OPERATION_ID)
			            , CONVERT(NVARCHAR(30),		ELTR_LN_TP_CD)
			            , CONVERT(NVARCHAR(100),	ITEM_ID)
			            , CONVERT(NVARCHAR(100),	NICK_NAME)
			            , CONVERT(NVARCHAR(6),		YYYYMM)
			            ------, CONVERT(FLOAT,	LANE_QTY)
			            , CONVERT(NUMERIC(4, 0),	ASSIGN_PRIORITY)
			            , CONVERT(NVARCHAR(1),		DUMMY_YN)
			            , CONVERT(NVARCHAR(1),		VALID_YN)
			            , CONVERT(NVARCHAR(200),	CREATED_BY)
			            , CONVERT(DATETIME,			CREATION_DATE)
			            , CONVERT(NVARCHAR(200),	LAST_UPDATED_BY)
			            , CONVERT(DATETIME,			LAST_UPDATE_DATE)
                FROM    #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS;

--TESTING : NOK;
--select * from @T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS;rollback tran;return;



------            	PRINT 'SAVE - SOP_BY_ASSIGN - BEGIN';
------                EXEC SCP0104_CHECK_CAPA_LINE_SOP_BY_ASSIGN_ELTR          @T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS
------                                                                        , N'SCP0104'
------                                                                        , N'ASSEMBLY'
------	                                                                    , @p_user_id
------	                                                                    , @debug_mode;
--------TESTING : NOK;
--------select * from SCP_MST_CAPA_LINE_SOP;rollback tran;return;
------            	PRINT 'SAVE - SOP_BY_ASSIGN - END';



            	--PRINT 'SAVE - SPEED_PLAN_BY_ASSIGN - BEGIN';
                EXEC SCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_ELTR     @T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS
                                                                    , N'SCP0105'
                                                                    , N'ELTR'
	                                                                , @p_user_id
	                                                                , @debug_mode;
--TESTING : NOK;
--select  * 
--from    SCP_MST_CAPA_ELTR_SPEED_PLAN A WITH(NOLOCK)
--        JOIN #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN B ON
--			    A.DIVISION_ID		= B.DIVISION_ID
--		    AND A.COMPANY_ID		= B.COMPANY_ID
--		    AND A.SITE_ID			= B.SITE_ID
--		    AND A.PLANT_ID			= B.PLANT_ID
--		    AND A.FACTORY_ID		= B.FACTORY_ID
--		    AND A.LINE_ID			= B.LINE_ID
--		    AND A.OPERATION_ID		= B.OPERATION_ID
--		    ----AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
--		    AND A.ITEM_ID			= B.ITEM_ID
--		    AND A.YYYYMM			= B.YYYYMM
--WHERE   1=1
--;rollback tran;return;
            	PRINT 'SAVE - SPEED_PLAN_BY_ASSIGN - END';
            END
        END

        BEGIN -- 데이터 저장 - Loss Plan
            PRINT 'SAVE - LOSS_PLAN_BY_ASSIGN - BEGIN';

--TESTING : NOK;
--select * from @T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS;rollback tran;return;

            EXEC SCP0106_CHECK_CAPA_LOSS_PLAN_BY_ASSIGN_ELTR      @T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS
                                                                , N'SCP0106'
                                                                , N'CURRENT_ELTR'
	                                                            , @p_user_id
	                                                            , @debug_mode;
            PRINT 'SAVE - LOSS_PLAN_BY_ASSIGN - END';

--TESTING : NOK;
--select  * 
--from    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
--        JOIN @T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS B ON
--				A.DIVISION_ID		    = B.DIVISION_ID
--			----AND A.MDL_NM				= B.ITEM_ID
--			AND A.PLANT_ID				= B.PLANT_ID
--			AND A.LINE_ID				= B.LINE_ID
--			AND A.OPERATION_ID			= B.OPERATION_ID
--			----AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
--			AND A.COMPANY_ID			= B.COMPANY_ID
--			AND A.SITE_ID				= B.SITE_ID
--			AND A.FACTORY_ID			= B.FACTORY_ID
--			AND A.YYYYMM				= B.YYYYMM
--;rollback tran;return;

        END -- 데이터 저장 - Loss Plan


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

		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + CONCAT('[ERROR LINE : ', ERROR_PROCEDURE(), ' - ', ERROR_LINE(), ']') + ERROR_MESSAGE();
	END CATCH;


    BEGIN -- 커서 해제 & 임시테이블 삭제------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#T_SCP0104_FACTORY') IS NOT NULL
			DROP TABLE #T_SCP0104_FACTORY;
		IF OBJECT_ID('tempdb..#T_SCP0104_ITEM') IS NOT NULL
			DROP TABLE #T_SCP0104_ITEM;
		IF OBJECT_ID('tempdb..#T_SCP0104_LINE') IS NOT NULL
			DROP TABLE #T_SCP0104_LINE;
		IF OBJECT_ID('tempdb..#T_SCP0104_PLANT') IS NOT NULL
			DROP TABLE #T_SCP0104_PLANT;
		IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_ELTR_LINE') IS NOT NULL
			DROP TABLE #T_SCP0104_SCP_MST_CAPA_ELTR_LINE;
		IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN') IS NOT NULL
			DROP TABLE #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN;
		IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS') IS NOT NULL
			DROP TABLE #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_ASSIGN_KEYS;
		IF OBJECT_ID('tempdb..#T_SCP0104_SCP_MST_CAPA_ELTR_LINE_MDL') IS NOT NULL
			DROP TABLE #T_SCP0104_SCP_MST_CAPA_ELTR_LINE_MDL;
		IF OBJECT_ID('tempdb..#tblSCP0104_EQPUIPMENT') IS NOT NULL
			DROP TABLE #tblSCP0104_EQPUIPMENT;
		IF OBJECT_ID('tempdb..#tblSCP0104_EQPUIPMENT_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0104_EQPUIPMENT_TEMP;
	END
END

