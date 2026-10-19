
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0106_CHECK_CAPA_LOSS_PLAN_BY_ASSIGN_ELTR
 * Description  : ASSIGN 테이블 구조의 데이터를 파라미터로 Speed Plan Insert/Update
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/19   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/07/11   chaan        V1.1.3                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 3차 Update
 * 2024/07/11   chaan        V1.1.4                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Speed Plan 실적 수정
 * 2024/08/05   chaan        V1.1.5                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - FLOAT 로 변형
 * 2024/08/20   chaan        V1.1.6                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - PF_RT => 100%
 * 2024/08/29   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - DAY_CNT 로직 수정 - SOP 적용 => 실적은 UI 에서 보이지 않으므로 굳이 기존 로직 수정 안하고 BASE 만 적용
 * 2024.10.28	chaan        V1.1.9                PJ20239037 LGES CPS VOE 반영 및 고도화                     - I/G 로직 수정
 * 2024.10.28	chaan        V1.1.10               PJ20239037 LGES CPS VOE 반영 및 고도화                     - I/G 로직 오류 수정
 * 2024.12.01	chaan        V1.1.11               PJ20239037 LGES CPS VOE 반영 및 고도화                     - PF_RT 로직 수정
 * 2024.12.07	chaan        V1.1.12               PJ20239037 LGES CPS VOE 반영 및 고도화                     - test
 * 2025/02/10   mrchois      V1.1.14               PJ20249346  LGES SCP 개선과제 이행	 - Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정
 * 2025/04/08   hrkim		 V1.1.15               PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - CPS 소형 확산
*/

--DROP PROCEDURE [dbo].[SCP0106_CHECK_CAPA_LOSS_PLAN_BY_ASSIGN_ELTR]
--CREATE PROCEDURE [dbo].[SCP0106_CHECK_CAPA_LOSS_PLAN_BY_ASSIGN_ELTR]
CREATE PROCEDURE [dbo].[SCP0106_CHECK_CAPA_LOSS_PLAN_BY_ASSIGN_ELTR]
	  @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN   dbo.SCP_MST_CAPA_LINE_ASSIGN_TYPE READONLY

	, @p_program_id				NVARCHAR(100)
	, @p_sheet_name				NVARCHAR(100)
	, @p_user_id				NVARCHAR(30)
	, @debug_mode				NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

--	DECLARE @p_program_id		NVARCHAR(100)	    	= N'SCP0106';
--	DECLARE @p_sheet_name		NVARCHAR(100)	    	= N'CURRENT_ELTR';
--    DECLARE @p_user_id			NVARCHAR(30)	    	= N'iamarock';
--    DECLARE @debug_mode			NVARCHAR(1)		    	= N'F';



--	DECLARE @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN   dbo.SCP_MST_CAPA_LINE_ASSIGN_TYPE;

--    INSERT INTO @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
--    SELECT	  '202411'		AS VER_ID
--			, 1				AS VER_SEQ
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
--    FROM	SCP_MST_CAPA_ELTR_LINE_ASSIGN WITH(NOLOCK)
--    WHERE   1=1
--        AND DIVISION_ID			= N'81'
--        AND LINE_ID				= N'FP_EJM10_C'
--        AND YYYYMM              = N'202412'
--        AND ITEM_ID				= N'APCCA2812A'

--        --AND DIVISION_ID			= N'81'
--        --AND COMPANY_ID			= N'G480'
--        --AND SITE_ID				= N'A004'
--        --AND PLANT_ID			= N'G482'
--        --AND FACTORY_ID			= N'EB'
--        --AND LINE_ID				= N'FP_E6M02_C'
--        --AND LINE_ID = 'FP_ESM01_A'
--        --AND OPERATION_ID		= N'E2000'
--        --AND ELTR_LN_TP_CD		= N''
--        --AND ITEM_ID				= N'APCCA2745A'
--        --AND YYYYMM              = '202601'

----------TESTING : NOK
----select * from @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN;return;



	IF OBJECT_ID('tempdb..#tblSCP0106_LINE_ASSIGN_LN') IS NOT NULL
		DROP TABLE #tblSCP0106_LINE_ASSIGN_LN;
    
    --빈테이블 생성
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
			, YYYYMM
			, ASSIGN_PRIORITY
    INTO    #tblSCP0106_LINE_ASSIGN_LN
    FROM	@TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
    WHERE   1<>1

    INSERT INTO #tblSCP0106_LINE_ASSIGN_LN
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
			, YYYYMM
			, SUM(ASSIGN_PRIORITY)      AS ASSIGN_PRIORITY
    FROM	@TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
    WHERE   1=1
    GROUP BY  VER_ID
			, VER_SEQ
			, DIVISION_ID
			, COMPANY_ID
			, SITE_ID
			, PLANT_ID
			, FACTORY_ID
			, LINE_ID
			, OPERATION_ID
			, ELTR_LN_TP_CD
			, YYYYMM;
--TESTING : NOK
--select * from #tblSCP0106_LINE_ASSIGN_LN;return;


	IF OBJECT_ID('tempdb..#tblSCP0106_NOT_VALID_MDL') IS NOT NULL
		DROP TABLE #tblSCP0106_NOT_VALID_MDL;
    
    --빈테이블 생성
    SELECT    DIVISION_ID
	        , COMPANY_ID
	        , SITE_ID
	        , PLANT_ID
	        , FACTORY_ID
	        , LINE_ID
	        , OPERATION_ID
			, ITEM_ID
    INTO    #tblSCP0106_NOT_VALID_MDL
    FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_NOT_VALID_MDL
    SELECT    DIVISION_ID
	        , COMPANY_ID
	        , SITE_ID
	        , PLANT_ID
	        , FACTORY_ID
	        , LINE_ID
	        , OPERATION_ID
			, ITEM_ID
    FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN
    WHERE   1=1
        AND VALID_YN <> 'Y'
    GROUP BY  DIVISION_ID
	        , COMPANY_ID
	        , SITE_ID
	        , PLANT_ID
	        , FACTORY_ID
	        , LINE_ID
	        , OPERATION_ID
			, ITEM_ID

--TESTING : NOK
--select * from #tblSCP0106_NOT_VALID_MDL;return;

	IF OBJECT_ID('tempdb..#tblSCP0106_NOT_VALID_LN') IS NOT NULL
		DROP TABLE #tblSCP0106_NOT_VALID_LN;
    
    --빈테이블 생성
    SELECT    DIVISION_ID
	        , COMPANY_ID
	        , SITE_ID
	        , PLANT_ID
	        , FACTORY_ID
	        , LINE_ID
	        , OPERATION_ID
    INTO    #tblSCP0106_NOT_VALID_LN
    FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_NOT_VALID_LN
    SELECT    DIVISION_ID
	        , COMPANY_ID
	        , SITE_ID
	        , PLANT_ID
	        , FACTORY_ID
	        , LINE_ID
	        , OPERATION_ID
    FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN
    WHERE   1=1
        AND VALID_YN <> 'Y'
    GROUP BY  DIVISION_ID
	        , COMPANY_ID
	        , SITE_ID
	        , PLANT_ID
	        , FACTORY_ID
	        , LINE_ID
	        , OPERATION_ID

--TESTING : NOK
--select * from #tblSCP0106_NOT_VALID_LN;return;


	IF OBJECT_ID('tempdb..#tblSCP0106_VALID_MDL') IS NOT NULL
		DROP TABLE #tblSCP0106_VALID_MDL;
    
    --빈테이블 생성
    SELECT    DIVISION_ID
	        , COMPANY_ID
	        , SITE_ID
	        , PLANT_ID
	        , FACTORY_ID
	        , LINE_ID
	        , OPERATION_ID
			, ITEM_ID
	        , NICK_NAME
            , ASSIGN_PRIORITY
    INTO    #tblSCP0106_VALID_MDL
    FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_VALID_MDL
    SELECT    DIVISION_ID
	        , COMPANY_ID
	        , SITE_ID
	        , PLANT_ID
	        , FACTORY_ID
	        , LINE_ID
	        , OPERATION_ID
			, ITEM_ID
	        , NICK_NAME
            , SUM(ASSIGN_PRIORITY)        AS ASSIGN_PRIORITY
    FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
    WHERE   1=1
        AND VALID_YN <> 'N'
    GROUP BY  DIVISION_ID
	        , COMPANY_ID
	        , SITE_ID
	        , PLANT_ID
	        , FACTORY_ID
	        , LINE_ID
	        , OPERATION_ID
			, ITEM_ID
	        , NICK_NAME

--TESTING : NOK
--select * from @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
--select * from #tblSCP0106_VALID_MDL;return;

--select  A.*
--FROM    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
--        INNER JOIN #tblSCP0106_VALID_MDL B ON
--                A.DIVISION_ID		= B.DIVISION_ID
--            AND A.COMPANY_ID		= B.COMPANY_ID
--            AND A.SITE_ID			= B.SITE_ID
--            AND A.PLANT_ID			= B.PLANT_ID
--            AND A.FACTORY_ID		= B.FACTORY_ID
--            AND A.LINE_ID			= B.LINE_ID
--            AND A.OPERATION_ID		= B.OPERATION_ID
--            --AND A.ELTR_LN_TP_CD		= B.ELTR_LN_TP_CD
--            AND A.MDL_NM			= B.ITEM_ID
--WHERE   1=1
--    AND B.ASSIGN_PRIORITY = 0;return;

	IF OBJECT_ID('tempdb..#tblSCP0106_VALID_LN') IS NOT NULL
		DROP TABLE #tblSCP0106_VALID_LN;
    
    --빈테이블 생성
    SELECT    DIVISION_ID
	        , COMPANY_ID
	        , SITE_ID
	        , PLANT_ID
	        , FACTORY_ID
	        , LINE_ID
	        , OPERATION_ID
			, ITEM_ID
	        , NICK_NAME
            , ASSIGN_PRIORITY
    INTO    #tblSCP0106_VALID_LN
    FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_VALID_LN
    SELECT    DIVISION_ID
	        , COMPANY_ID
	        , SITE_ID
	        , PLANT_ID
	        , FACTORY_ID
	        , LINE_ID
	        , OPERATION_ID
			, '-' AS ITEM_ID
	        , '-' AS NICK_NAME
            , SUM(ASSIGN_PRIORITY)        AS ASSIGN_PRIORITY
    FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
    WHERE   1=1
        AND VALID_YN <> 'N'
    GROUP BY  DIVISION_ID
	        , COMPANY_ID
	        , SITE_ID
	        , PLANT_ID
	        , FACTORY_ID
	        , LINE_ID
	        , OPERATION_ID

--TESTING : NOK
--select * from @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
--select * from #tblSCP0106_VALID_LN;return;



	DECLARE @v_division_id		NVARCHAR(MAX)		    = N'';

 	DECLARE @test_mode                          NVARCHAR(20)		= N'F';


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150)	= 'SCP0106_CHECK_CAPA_LOSS_PLAN_BY_ASSIGN_ELTR';
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


	    DECLARE @p_version			NVARCHAR(30)        = '';
        DECLARE @p_version_seq		TINYINT             = 0;
        DECLARE @v_from_yyyy        NVARCHAR(8)			= N'';

        SET @v_from_yyyy        = SUBSTRING(@p_version, 1, 4);
	    DECLARE @v_to_yyyy			NVARCHAR(4)			= '';

        SELECT    @p_version        = MAX(VER_ID)
                , @p_version_seq    = MAX(VER_SEQ)
                , @v_from_yyyy      = MIN(SUBSTRING(YYYYMM, 1, 4))
                , @v_to_yyyy        = MAX(SUBSTRING(YYYYMM, 1, 4))
        FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN;

        PRINT CONCAT('@p_version : ', @p_version);
        PRINT CONCAT('@p_version_seq : ', @p_version_seq);
        PRINT CONCAT('@v_from_yyyy : ', @v_from_yyyy);
        PRINT CONCAT('@v_to_yyyy : ', @v_to_yyyy);
        --return;


	    IF OBJECT_ID('tempdb..#tblSCP0106_CHECK_MEASURE') IS NOT NULL
			DROP TABLE #tblSCP0106_CHECK_MEASURE;

        --빈테이블 생성

        SELECT    A.ATTRIBUTE3        AS LOSS_GR_CD
                , A.SEGMENT1          AS LOSS_CD
                , A.ATTRIBUTE6        AS LOSS_GR_NM_KO
                , A.ATTRIBUTE7        AS LOSS_GR_NM_EN
                , A.ATTRIBUTE4        AS LOSS_NM_KO
                , A.ATTRIBUTE5        AS LOSS_NM_EN
                , CASE
                    WHEN @p_sheet_name = '1ST_CUTOFF_MODEL'         THEN A.ATTRIBUTE8   --1ST_MODEL_TARGET_YN
                    WHEN @p_sheet_name = '1ST_CUTOFF_MODEL_ELTR'    THEN A.ATTRIBUTE8   --1ST_MODEL_TARGET_YN
                    WHEN @p_sheet_name = '1ST_CUTOFF_LINE'          THEN A.ATTRIBUTE14  --1ST_LINE_TARGET_YN
                    WHEN @p_sheet_name = '1ST_CUTOFF_LINE_ELTR'     THEN A.ATTRIBUTE14  --1ST_LINE_TARGET_YN
                    WHEN @p_sheet_name = '2ND_CUTOFF'               THEN A.ATTRIBUTE9   --2ND_TARGET_YN
                    WHEN @p_sheet_name = '2ND_CUTOFF_ELTR'          THEN A.ATTRIBUTE9   --2ND_TARGET_YN
                    ELSE A.ATTRIBUTE13                                                  --CURRENT_TARGET_YN
                  END AS TARGET_YN
                --, A.ATTRIBUTE10      AS IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                , A.DISPLAY_SEQ
        INTO    #tblSCP0106_CHECK_MEASURE
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_CHECK_MEASURE
        SELECT    A.ATTRIBUTE3        AS LOSS_GR_CD
                , A.SEGMENT1          AS LOSS_CD
                , A.ATTRIBUTE6        AS LOSS_GR_NM_KO
                , A.ATTRIBUTE7        AS LOSS_GR_NM_EN
                , A.ATTRIBUTE4        AS LOSS_NM_KO
                , A.ATTRIBUTE5        AS LOSS_NM_EN
                , CASE
                    WHEN @p_sheet_name = '1ST_CUTOFF_MODEL'         THEN A.ATTRIBUTE8   --1ST_MODEL_TARGET_YN
                    WHEN @p_sheet_name = '1ST_CUTOFF_MODEL_ELTR'    THEN A.ATTRIBUTE8   --1ST_MODEL_TARGET_YN
                    WHEN @p_sheet_name = '1ST_CUTOFF_LINE'          THEN A.ATTRIBUTE14  --1ST_LINE_TARGET_YN
                    WHEN @p_sheet_name = '1ST_CUTOFF_LINE_ELTR'     THEN A.ATTRIBUTE14  --1ST_LINE_TARGET_YN
                    WHEN @p_sheet_name = '2ND_CUTOFF'               THEN A.ATTRIBUTE9   --2ND_TARGET_YN
                    WHEN @p_sheet_name = '2ND_CUTOFF_ELTR'          THEN A.ATTRIBUTE9   --2ND_TARGET_YN
                    ELSE A.ATTRIBUTE13                                                  --CURRENT_TARGET_YN
                  END AS TARGET_YN
                --, A.ATTRIBUTE10      AS IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                , A.DISPLAY_SEQ
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
                --JOIN ( 
                --        SELECT  COLUMN_NAME AS MEASURE
                --        FROM    SCM_MST_SHEET_MEASURE WITH(NOLOCK)
                --        WHERE   1=1
                --            AND PROGRAM_ID    = @p_program_id
                --            AND SHEET_NAME    = @p_sheet_name
                --            AND VALID_YN      = 'Y'
                --     ) B ON
                --        A.SEGMENT1 = B.MEASURE
        WHERE   1=1
            AND A.LOOKUP_TYPE  = 'SCP_CAPA_ELTR_LOSS_MEASURE'
            AND A.VALID_YN  = 'Y'
            AND A.SEGMENT1 NOT IN (   'EQP_NBU'
                                    , 'TACT_TIME'
                                    , 'PPM'
                                    , 'SCP_PROD_PLAN_DDN')

--TESTING : NOK
--select * from #tblSCP0106_CHECK_MEASURE ORDER BY DISPLAY_SEQ;rollback tran;return;


	    IF OBJECT_ID('tempdb..#tblSCP0106_CHECK_MEASURE_CURRENT') IS NOT NULL
			DROP TABLE #tblSCP0106_CHECK_MEASURE_CURRENT;

        --빈테이블 생성
        SELECT    A.LOSS_GR_CD        AS MSR_GR_CD
                , A.LOSS_CD           AS MSR_TP_CD
                , A.LOSS_GR_NM_KO
                , A.LOSS_GR_NM_EN
                , A.LOSS_NM_KO
                , A.LOSS_NM_EN
                --, A.IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                , A.DISPLAY_SEQ
        INTO    #tblSCP0106_CHECK_MEASURE_CURRENT
        FROM    #tblSCP0106_CHECK_MEASURE A
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_CHECK_MEASURE_CURRENT
        SELECT    A.LOSS_GR_CD        AS MSR_GR_CD
                , A.LOSS_CD           AS MSR_TP_CD
                , A.LOSS_GR_NM_KO
                , A.LOSS_GR_NM_EN
                , A.LOSS_NM_KO
                , A.LOSS_NM_EN
                --, A.IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                , A.DISPLAY_SEQ
        FROM    #tblSCP0106_CHECK_MEASURE A
        WHERE   1=1
            --AND A.TARGET_YN = 'Y'
            --AND LOSS_CD <> 'SCP_PROD_PLAN_DDN';

--TESTING : NOK
--select * from #tblSCP0106_CHECK_MEASURE_CURRENT ORDER BY DISPLAY_SEQ;rollback tran;return;


	    IF OBJECT_ID('tempdb..#tblSCP0106_CHECK_PLAN_TP') IS NOT NULL
			DROP TABLE #tblSCP0106_CHECK_PLAN_TP;

        SELECT    A.PLAN_TP
                , A.PLAN_TP_NM
        INTO    #tblSCP0106_CHECK_PLAN_TP
        FROM    (
                    SELECT    SEGMENT3        AS PLAN_TP
                            , SEGMENT4        AS PLAN_TP_NM
                    FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
                    WHERE   1=1
                        AND A.LOOKUP_TYPE   = 'SCP_CAPA_RPT_CODE'
                        AND SEGMENT1        = 'SCP0106'
                        AND SEGMENT2        = 'CURRENT'
                        AND A.VALID_YN      = 'Y'

                ) A;

--TESTING : NOK
--select * from #tblSCP0106_CHECK_PLAN_TP;rollback tran;return;

        DECLARE @p_prog_stat      NVARCHAR(2)     = '0'; -- Current 만 생성 가능하므로 고정

        PRINT CONCAT('@p_prog_stat : ', @p_prog_stat);
        --return;rollback tran;return;



	DECLARE @v_site_id			NVARCHAR(MAX)		= N'';
	DECLARE @v_plant_id  		NVARCHAR(MAX)		= N'';
	DECLARE @v_factory_id		NVARCHAR(MAX)		= N'';
	DECLARE @v_line_id			NVARCHAR(MAX)		= N'';
	DECLARE @v_operation_id		NVARCHAR(MAX)		= N'';
	DECLARE @v_item_id  		NVARCHAR(MAX)		= N'';
	DECLARE @v_nick_name		NVARCHAR(MAX)		= N'';
	DECLARE @v_electrode_type	NVARCHAR(MAX)		= N'';

    SELECT	   @v_division_id		= @v_division_id	+ DIVISION_ID + ','
			,  @v_site_id			= @v_site_id		+ SITE_ID + ','
			,  @v_plant_id  		= @v_plant_id  		+ PLANT_ID + ','
			,  @v_factory_id		= @v_factory_id		+ FACTORY_ID + ','
			,  @v_line_id			= @v_line_id		+ LINE_ID + ','
			,  @v_operation_id		= @v_operation_id	+ OPERATION_ID + ','
			,  @v_item_id			= @v_item_id		+ ITEM_ID + ','
			,  @v_nick_name			= @v_nick_name		+ NICK_NAME + ','
			,  @v_electrode_type	= @v_electrode_type	+ ELTR_LN_TP_CD + ','
    FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN
    GROUP BY  DIVISION_ID
			, SITE_ID
			, PLANT_ID
			, FACTORY_ID
			, LINE_ID
			, OPERATION_ID
            , ITEM_ID
			, NICK_NAME
			, ELTR_LN_TP_CD;

        PRINT CONCAT('@v_division_id : ', @v_division_id);
        PRINT CONCAT('@v_site_id : ', @v_site_id);
        PRINT CONCAT('@v_plant_id : ', @v_plant_id);
        PRINT CONCAT('@v_factory_id : ', @v_factory_id);
        PRINT CONCAT('@v_line_id : ', @v_line_id);
        PRINT CONCAT('@v_operation_id : ', @v_operation_id);
        PRINT CONCAT('@@v_item_id : ', @v_item_id);
        PRINT CONCAT('@v_nick_name : ', @v_nick_name);
        PRINT CONCAT('@v_electrode_type : ', @v_electrode_type);

--RETURN;
    	IF OBJECT_ID('tempdb..#tblSCP0106_SPEED_PLAN_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0106_SPEED_PLAN_TEMP;
        
        --빈테이블 생성
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
	            , MSR_TP_CD		                AS SPEED_UNIT_GROUP
	            , MSR_TP_CD
	            , YYYYMM
	            , QTY			                AS PFRSLT_QTY
	            , QTY			                AS BASE_QTY
	            , QTY
	            , CONVERT(NVARCHAR(1), NULL)	AS UI_UPD_YN
	            , CONVERT(NVARCHAR(2), NULL)	AS PROG_STAT
        INTO    #tblSCP0106_SPEED_PLAN_TEMP
        FROM    SCP_MST_CAPA_ELTR_SPEED_PLAN_CUTF
        WHERE   1<>1;

        IF @p_version <> '' AND @p_version IS NOT NULL
        BEGIN
            --PRINT 'FN_SCP0105_GET_CAPA_ELTR_SPEED_PLAN_CURRENT - BEGIN';

            --INSERT INTO #tblSCP0106_SPEED_PLAN_TEMP
            --SELECT  *
            --FROM    dbo.FN_SCP0105_GET_CAPA_ELTR_SPEED_PLAN_CURRENT
            --        (
            --              @p_version
	           --         , @p_version_seq
	           --         , @p_prog_stat
	           --         , @v_division_id
	           --         , @v_site_id
	           --         , @v_plant_id
	           --         , @v_factory_id
	           --         , @v_line_id
	           --         , @v_operation_id
	           --         , @v_item_id
	           --         , @v_nick_name
            --            , @v_electrode_type
            --            , N'SCP0106'
            --            , N'CURRENT'
            --            , N'iamarock'
            --            , N'F'
            --        );

            --PRINT 'FN_SCP0105_GET_CAPA_ELTR_SPEED_PLAN_CURRENT - BEGIN';

            BEGIN --**************************************************************************************************************************************************************************************************
            --PRINT N'GET - RESULT - BEGIN';

	        IF OBJECT_ID('tempdb..#tblSCP0105_SPEED_UNIT_ALL') IS NOT NULL
			    DROP TABLE #tblSCP0105_SPEED_UNIT_ALL;

            SELECT    A.SEGMENT1        AS UNIT_GROUP
                    , A.SEGMENT2        AS OPERATION_ID
                    , A.SEGMENT3        AS MSR_TP_CD
                    , A.SEGMENT4        AS LINE_TYPE
                    , A.SEGMENT5        AS UNIT_GROUP_SEQ
                    , A.DISPLAY_SEQ
            INTO    #tblSCP0105_SPEED_UNIT_ALL
            FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
            WHERE   1=1
			    --AND SEGMENT1 = 'SCP'
                AND A.LOOKUP_TYPE  = 'OPERATION_SPEED_ELTR_UNIT'
                AND A.VALID_YN  = 'Y';

    --TESTING : NOK
    --select * from #tblSCP0105_SPEED_UNIT_ALL;return;


	    IF OBJECT_ID('tempdb..#tblSCP0105_SPEED_UNIT_GROUP') IS NOT NULL
			DROP TABLE #tblSCP0105_SPEED_UNIT_GROUP;

        SELECT    A.UNIT_GROUP
                , MIN(A.DISPLAY_SEQ)    AS DISPLAY_SEQ
                , MAX(UNIT_GROUP_SEQ)   AS UNIT_GROUP_SEQ
        INTO    #tblSCP0105_SPEED_UNIT_GROUP
        FROM    #tblSCP0105_SPEED_UNIT_ALL A
        GROUP BY A.UNIT_GROUP
        ORDER BY MIN(A.DISPLAY_SEQ);

--TESTING : NOK
--select * from #tblSCP0105_SPEED_UNIT_GROUP;return;


	        IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_RESULT') IS NOT NULL
		        DROP TABLE #tblSCP0105_CHECK_RESULT;

	        --빈테이블 생성
            SELECT    A.DIVISION_ID                 AS DIVISION_ID
                    , A.COMPANY_ID                  AS COMPANY_ID
                    , A.SITE_ID                     AS SITE_ID
                    , A.PLANT_ID                    AS PLANT_ID
                    , A.FACTORY_ID                  AS FACTORY_ID
                    , A.LINE_ID                     AS LINE_ID
                    , A.OPERATION_ID                AS OPERATION_ID
                    , A.ELTR_LN_TP_CD               AS ELTR_LN_TP_CD
--라인별로 변경                    , A.MDL_NM                      AS ITEM_ID
--라인별로 변경                    , '-'                           AS NICK_NAME
                    , CONVERT(NVARCHAR(30), NULL)   AS SPEED_UNIT_GROUP
                    , UPPER(A.EQP_SPED_UNIT_CD)     AS EQP_SPED_UNIT_CD
                    , A.EQP_NBU
                    , A.EQP_SPED
            INTO	#tblSCP0105_CHECK_RESULT
            FROM    SCM_DNM_ELTR_EQP_SPED_MMLY A WITH(NOLOCK)
	        WHERE	1<>1

               CREATE CLUSTERED INDEX IDX_tblSCP0105_CHECK_RESULT1       ON #tblSCP0105_CHECK_RESULT  (
		                                                              DIVISION_ID
		                                                            , COMPANY_ID
		                                                            , SITE_ID
		                                                            , PLANT_ID
		                                                            , FACTORY_ID
		                                                            , LINE_ID
		                                                            , OPERATION_ID
		                                                            --, ITEM_ID
		                                                            --, NICK_NAME
		                                                            , ELTR_LN_TP_CD)

            INSERT INTO #tblSCP0105_CHECK_RESULT
            SELECT    A.DIVISION_ID                 AS DIVISION_ID
                    , A.COMPANY_ID                  AS COMPANY_ID
                    , A.SITE_ID                     AS SITE_ID
                    , A.PLANT_ID                    AS PLANT_ID
                    , A.FACTORY_ID                  AS FACTORY_ID
                    , A.LINE_ID                     AS LINE_ID
                    , A.OPERATION_ID                AS OPERATION_ID
                    , A.ELTR_LN_TP_CD               AS ELTR_LN_TP_CD
--라인별로 변경                    , A.MDL_NM                      AS ITEM_ID
--라인별로 변경                    , '-'                           AS NICK_NAME
                    , B.UNIT_GROUP                  AS SPEED_UNIT_GROUP
                    , UPPER(A.EQP_SPED_UNIT_CD)     AS EQP_SPED_UNIT_CD
                    , AVG(A.EQP_NBU)                AS EQP_NBU
                    , AVG(A.EQP_SPED)               AS EQP_SPED
                    --, A.PFRSLT_YM                   AS YYYYMM
            FROM    SCM_DNM_ELTR_EQP_SPED_MMLY A WITH(NOLOCK)
                    LEFT JOIN (
                                    SELECT    UNIT_GROUP
                                            , MSR_TP_CD
                                    FROM    #tblSCP0105_SPEED_UNIT_ALL
                                    WHERE   1=1
                                    GROUP BY UNIT_GROUP
                                            , MSR_TP_CD
                                ) B ON
                            A.EQP_SPED_UNIT_CD  = MSR_TP_CD
            WHERE   1=1
                AND SUBSTRING(PFRSLT_YM, 1, 4) >= @v_from_yyyy
                AND SUBSTRING(PFRSLT_YM, 1, 4) <= @v_to_yyyy
		        AND ((@v_division_id	IS NULL OR @v_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_division_id, ',')))
		        AND ((@v_site_id  		IS NULL OR @v_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_site_id, ',')))
		        AND ((@v_plant_id		IS NULL OR @v_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_plant_id, ',')))
		        AND ((@v_factory_id		IS NULL OR @v_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_factory_id, ',')))
		        AND ((@v_line_id		IS NULL OR @v_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_line_id, ',')))
		        AND ((@v_operation_id	IS NULL OR @v_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_operation_id, ',')))
		        AND ((@v_electrode_type	IS NULL OR @v_electrode_type	= '') OR A.ELTR_LN_TP_CD  IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_electrode_type, ',')))
		        --AND ((@v_item_id	    IS NULL OR @v_item_id	        = '') OR A.MDL_NM         IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_item_id, ',')))
            GROUP BY  A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.SITE_ID
                    , A.PLANT_ID
                    , A.FACTORY_ID
                    , A.LINE_ID
                    , A.OPERATION_ID
                    , A.ELTR_LN_TP_CD
--라인별로 변경                    , A.MDL_NM
                    , B.UNIT_GROUP
                    , A.EQP_SPED_UNIT_CD;
            --PRINT N'GET - RESULT - END';

        PRINT CONCAT('ELAPSED_TIME-#tblSCP0105_CHECK_RESULT : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from #tblSCP0105_CHECK_RESULT;return;


            --PRINT N'GET - BASE - BEGIN';
	IF OBJECT_ID('tempdb..#tblSCP0106_EQPUIPMENT_TEMP') IS NOT NULL
		DROP TABLE #tblSCP0106_EQPUIPMENT_TEMP;

        --빈테이블 생성
        SELECT	  A.COMPANY_ID
		        , A.DIVISION_ID
		        , A.SITE_ID
		        , A.PLANT_ID
		        , A.FACTORY_ID
		        , A.LINE_ID
		        , A.OPERATION_ID
		        , B.BOM_ITEM_ID                                     AS ITEM_ID
                , A.EQUIPMENT_ID
                , A.EQUIPMENT_NAME
		        , A.WIDE_ROLL_ENABLE_FLAG
                , IIF(A.WIDE_ROLL_ENABLE_FLAG = 'Y', 'W', 'S')      AS ELTR_LN_TP_CD
		        , B.EQP_SPED
		        , B.UPDATE_TIME				                        AS SPEED_UPDATE_TIME
		        , A.UPDATE_TIME				                        AS EQPT_UPDATE_TIME
                , CONVERT(NVARCHAR(30), NULL)                       AS EQP_SPED_UNIT_CD
		        , CONVERT(BIGINT, NULL)                             AS RN
        INTO	#tblSCP0106_EQPUIPMENT_TEMP
        FROM	SCM_MST_EQUIPMENT_SN A WITH(NOLOCK)
		        INNER JOIN SCM_MMD_EQPT_PRDT_SPEED_SN B WITH(NOLOCK) ON 
				        B.EQP_ID = A.EQUIPMENT_ID
	    WHERE	1<>1

        INSERT INTO #tblSCP0106_EQPUIPMENT_TEMP
        SELECT	  A.COMPANY_ID
		        , A.DIVISION_ID
		        , A.SITE_ID
		        , A.PLANT_ID
		        , A.FACTORY_ID
		        , A.LINE_ID
		        , A.OPERATION_ID
		        , B.BOM_ITEM_ID                                     AS ITEM_ID
                , A.EQUIPMENT_ID
                , A.EQUIPMENT_NAME
		        , A.WIDE_ROLL_ENABLE_FLAG
                , IIF(A.WIDE_ROLL_ENABLE_FLAG = 'Y', 'W', 'S')      AS ELTR_LN_TP_CD
		        , B.EQP_SPED
		        , B.UPDATE_TIME				AS SPEED_UPDATE_TIME
		        , A.UPDATE_TIME				AS EQPT_UPDATE_TIME
                , CONVERT(NVARCHAR(30), 'EQP_SPED')                 AS EQP_SPED_UNIT_CD
		        , ROW_NUMBER() OVER (PARTITION BY 
									          A.DIVISION_ID
									        , A.SITE_ID
									        , A.COMPANY_ID
									        , A.PLANT_ID
									        , A.LINE_ID
									        , A.OPERATION_ID
									        , B.BOM_ITEM_ID
							          ORDER BY 
									          B.UPDATE_TIME DESC
									        , A.UPDATE_TIME DESC) AS RN 
        FROM	SCM_MST_EQUIPMENT_SN A WITH(NOLOCK)
		        INNER JOIN SCM_MMD_EQPT_PRDT_SPEED_SN B WITH(NOLOCK) ON 
				        B.EQP_ID = A.EQUIPMENT_ID
        WHERE	1=1
	        -- 2025.04.08 소형확산 AND A.DIVISION_ID      != '40'		-- 소형제외
	        AND A.OPERATION_ID LIKE 'E2000%'	-- 전극 Coating 공정 (현재는 E2000 공정 하나만 대상)  
	        AND A.EQUIPMENT_TYPE   = 'M'		-- Main 설비
	        AND A.ACTIVE_FLAG      = 'Y'
		    ----AND (A.OPERATION_ID	LIKE 'E%')
		        --AND ((@v_division_id	IS NULL OR @v_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_division_id, ',')))
		        --AND ((@v_site_id  		IS NULL OR @v_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_site_id, ',')))
		        --AND ((@v_plant_id		IS NULL OR @v_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_plant_id, ',')))
		        --AND ((@v_factory_id		IS NULL OR @v_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_factory_id, ',')))
		        --AND ((@v_line_id		IS NULL OR @v_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_line_id, ',')))
		        --AND ((@v_operation_id	IS NULL OR @v_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_operation_id, ',')))
		        --AND ((@v_item_id	    IS NULL OR @v_item_id	        = '') OR B.BOM_ITEM_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_item_id, ',')))

--TESTING : NOK
--select * from #tblSCP0106_EQPUIPMENT_TEMP;return;

	        IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_BASE') IS NOT NULL
		        DROP TABLE #tblSCP0105_CHECK_BASE;

	        --빈테이블 생성
            SELECT    A.DIVISION_ID                     AS DIVISION_ID
                    , A.COMPANY_ID                      AS COMPANY_ID
                    , A.SITE_ID                         AS SITE_ID
                    , A.PLANT_ID                        AS PLANT_ID
                    , A.FACTORY_ID                      AS FACTORY_ID
                    , A.LINE_ID                         AS LINE_ID
                    , A.OPERATION_ID                    AS OPERATION_ID
                    , A.ITEM_ID                         AS ITEM_ID
                    , A.ITEM_ID                         AS NICK_NAME
                    , A.ELTR_LN_TP_CD                   AS ELTR_LN_TP_CD
                    , CONVERT(NVARCHAR(30), NULL)	    AS SPEED_UNIT_GROUP
                    , CONVERT(NVARCHAR(30), NULL)       AS MSR_TP_CD
                    , CONVERT(FLOAT, NULL)    AS EQP_NBU
                    , A.EQP_SPED
                    , 'N'                               AS UI_UPD_YN
            INTO	#tblSCP0105_CHECK_BASE
            FROM    #tblSCP0106_EQPUIPMENT_TEMP A WITH(NOLOCK)
	        WHERE	1<>1

               CREATE CLUSTERED INDEX IDX_tblSCP0105_CHECK_BASE1       ON #tblSCP0105_CHECK_BASE  (
		                                                              DIVISION_ID
		                                                            , COMPANY_ID
		                                                            , SITE_ID
		                                                            , PLANT_ID
		                                                            , FACTORY_ID
		                                                            , LINE_ID
		                                                            , OPERATION_ID
		                                                            , ITEM_ID
		                                                            , NICK_NAME
		                                                            , ELTR_LN_TP_CD)

            INSERT INTO #tblSCP0105_CHECK_BASE
            SELECT    A.DIVISION_ID                     AS DIVISION_ID
                    , A.COMPANY_ID                      AS COMPANY_ID
                    , A.SITE_ID                         AS SITE_ID
                    , A.PLANT_ID                        AS PLANT_ID
                    , A.FACTORY_ID                      AS FACTORY_ID
                    , A.LINE_ID                         AS LINE_ID
                    , A.OPERATION_ID                    AS OPERATION_ID
                    , A.ITEM_ID                         AS ITEM_ID
                    , '-'                               AS NICK_NAME
                    , A.ELTR_LN_TP_CD                   AS ELTR_LN_TP_CD
                    , B.UNIT_GROUP                      AS SPEED_UNIT_GROUP
                    , 'EQP_SPED'                        AS MSR_TP_CD
                    , CONVERT(FLOAT, 1.0)     AS EQP_NBU
                    , A.EQP_SPED
                    , 'N'                               AS UI_UPD_YN
            FROM    #tblSCP0106_EQPUIPMENT_TEMP A WITH(NOLOCK)
                    LEFT JOIN (
                                    SELECT    UNIT_GROUP
                                            , MSR_TP_CD
                                    FROM    #tblSCP0105_SPEED_UNIT_ALL
                                    WHERE   1=1
                                    GROUP BY UNIT_GROUP
                                            , MSR_TP_CD
                                ) B ON
                            A.EQP_SPED_UNIT_CD  = MSR_TP_CD
            WHERE   1=1
		        AND ((@v_division_id	IS NULL OR @v_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_division_id, ',')))
		        AND ((@v_site_id  		IS NULL OR @v_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_site_id, ',')))
		        AND ((@v_plant_id		IS NULL OR @v_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_plant_id, ',')))
		        AND ((@v_factory_id		IS NULL OR @v_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_factory_id, ',')))
		        AND ((@v_line_id		IS NULL OR @v_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_line_id, ',')))
		        AND ((@v_operation_id	IS NULL OR @v_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_operation_id, ',')))
		        AND ((@v_electrode_type	IS NULL OR @v_electrode_type	= '') OR A.ELTR_LN_TP_CD  IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_electrode_type, ',')))
		        AND ((@v_item_id	    IS NULL OR @v_item_id	        = '') OR A.ITEM_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_item_id, ',')))

        PRINT CONCAT('ELAPSED_TIME-#tblSCP0105_CHECK_BASE : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

        --TESTING : NOK
        --select * from #tblSCP0106_EQPUIPMENT_TEMP;return;
        --select * from #tblSCP0105_CHECK_RESULT;--return;
        --select * from #tblSCP0105_CHECK_BASE;return;


	        IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_BASE_UI_UPD_YN') IS NOT NULL
		        DROP TABLE #tblSCP0105_CHECK_BASE_UI_UPD_YN;

	        --빈테이블 생성
            SELECT    A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.SITE_ID
                    , A.PLANT_ID
                    , A.FACTORY_ID
                    , A.LINE_ID
                    , A.OPERATION_ID
                    , A.ELTR_LN_TP_CD
                    , A.ITEM_ID
                    , A.NICK_NAME
                    , A.UI_UPD_YN    AS UI_UPD_YN
            INTO	#tblSCP0105_CHECK_BASE_UI_UPD_YN
            FROM    #tblSCP0105_CHECK_BASE A
	        WHERE	1<>1

               CREATE CLUSTERED INDEX IDX_tblSCP0105_CHECK_BASE_UI_UPD_YN1       ON #tblSCP0105_CHECK_BASE_UI_UPD_YN (
		                                                              DIVISION_ID
		                                                            , COMPANY_ID
		                                                            , SITE_ID
		                                                            , PLANT_ID
		                                                            , FACTORY_ID
		                                                            , LINE_ID
		                                                            , OPERATION_ID
		                                                            , ELTR_LN_TP_CD
                                                                    , ITEM_ID
		                                                            , NICK_NAME)

            INSERT INTO #tblSCP0105_CHECK_BASE_UI_UPD_YN
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
                    , MAX(UI_UPD_YN)    AS UI_UPD_YN
            FROM    #tblSCP0105_CHECK_BASE
            WHERE   1=1
            GROUP BY  DIVISION_ID
                    , COMPANY_ID
                    , SITE_ID
                    , PLANT_ID
                    , FACTORY_ID
                    , LINE_ID
                    , OPERATION_ID
                    , ELTR_LN_TP_CD
                    , ITEM_ID
                    , NICK_NAME

        PRINT CONCAT('ELAPSED_TIME-#tblSCP0105_CHECK_BASE_UI_UPD_YN : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

        --TESTING : NOK
        --select * from #tblSCP0105_CHECK_BASE_UI_UPD_YN;return;
            --PRINT N'GET - BASE - END';


	        IF OBJECT_ID('tempdb..#tblSCP0105_CHECK') IS NOT NULL
		        DROP TABLE #tblSCP0105_CHECK;

	        --빈테이블 생성
	        SELECT	  @p_version        AS VER_ID
			        , @p_version_seq    AS VER_SEQ
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
            INTO	#tblSCP0105_CHECK
            FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN A WITH(NOLOCK)
	        WHERE	1<>1

            INSERT INTO #tblSCP0105_CHECK
	        SELECT	  @p_version        AS VER_ID
			        , @p_version_seq    AS VER_SEQ
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
            FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN A WITH(NOLOCK)
            WHERE   1=1
                AND VALID_YN = 'Y'
            GROUP BY  A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
			        , A.ELTR_LN_TP_CD
			        , A.ITEM_ID
			        , A.NICK_NAME;

        PRINT CONCAT('ELAPSED_TIME-#tblSCP0105_CHECK : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

        --TESTING : NOK
        --select * from #tblSCP0105_CHECK;return;



	        IF OBJECT_ID('tempdb..#tblSCP0105_RAW_ALL_TEMP') IS NOT NULL
		        DROP TABLE #tblSCP0105_RAW_ALL_TEMP;

	        --빈테이블 생성
	        SELECT	  @p_version        AS VER_ID
			        , @p_version_seq    AS VER_SEQ
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
                    , NULL                                AS PFRSLT_QTY
                    , A.BASE_QTY
                    , A.QTY
	        INTO	#tblSCP0105_RAW_ALL_TEMP
	        FROM	SCP_MST_CAPA_ELTR_SPEED_PLAN A WITH(NOLOCK)
	        WHERE	1<>1

               --CREATE CLUSTERED INDEX IDX_tblSCP0105_RAW_ALL_TEMP1       ON #tblSCP0105_RAW_ALL_TEMP (
		             --                                                 VER_ID
		             --                                               , VER_SEQ
		             --                                               , DIVISION_ID
		             --                                               , COMPANY_ID
		             --                                               , SITE_ID
		             --                                               , PLANT_ID
		             --                                               , FACTORY_ID
		             --                                               , LINE_ID
		             --                                               , OPERATION_ID
		             --                                               , ELTR_LN_TP_CD
		             --                                               , ITEM_ID
		             --                                               , NICK_NAME
		             --                                               , MSR_TP_CD
		             --                                               , YYYYMM)

            INSERT INTO #tblSCP0105_RAW_ALL_TEMP
	        SELECT	  @p_version        AS VER_ID
			        , @p_version_seq    AS VER_SEQ
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
                    , NULL                                AS PFRSLT_QTY
                    , A.BASE_QTY
                    , A.QTY
	        FROM	SCP_MST_CAPA_ELTR_SPEED_PLAN A WITH(NOLOCK)
                    JOIN #tblSCP0105_CHECK B ON
					            A.DIVISION_ID		= B.DIVISION_ID
				            AND A.COMPANY_ID		= B.COMPANY_ID
				            AND A.SITE_ID			= B.SITE_ID
				            AND A.PLANT_ID			= B.PLANT_ID
				            AND A.FACTORY_ID		= B.FACTORY_ID
				            AND A.LINE_ID			= B.LINE_ID
				            AND A.OPERATION_ID		= B.OPERATION_ID
				            AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
                            AND A.ITEM_ID           = B.ITEM_ID
                            AND A.NICK_NAME         = B.NICK_NAME
	        WHERE	1=1
		        AND ((@v_division_id	IS NULL OR @v_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_division_id, ',')))
		        AND ((@v_site_id  		IS NULL OR @v_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_site_id, ',')))
		        AND ((@v_plant_id		IS NULL OR @v_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_plant_id, ',')))
		        AND ((@v_factory_id		IS NULL OR @v_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_factory_id, ',')))
		        AND ((@v_line_id		IS NULL OR @v_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_line_id, ',')))
		        AND ((@v_operation_id	IS NULL OR @v_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_operation_id, ',')))
		        AND ((@v_electrode_type	IS NULL OR @v_electrode_type	= '') OR A.ELTR_LN_TP_CD  IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_electrode_type, ',')))
		        AND ((@v_item_id	    IS NULL OR @v_item_id	        = '') OR A.ITEM_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@v_item_id, ',')))

        PRINT CONCAT('ELAPSED_TIME-#tblSCP0105_RAW_ALL_TEMP : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from SCP_MST_CAPA_ELTR_SPEED_PLAN;
--select * from #tblSCP0105_CHECK;
--select * from #tblSCP0105_RAW_ALL_TEMP;rollback tran;return;


	        IF OBJECT_ID('tempdb..#tblSCP0105_RAW_ALL') IS NOT NULL
		        DROP TABLE #tblSCP0105_RAW_ALL;

	        --빈테이블 생성
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
			        , A.ITEM_ID
			        , A.NICK_NAME
                    , CONVERT(NVARCHAR(30), NULL)		AS SPEED_UNIT_GROUP
	                , A.MSR_TP_CD
			        , A.YYYYMM
                    , A.PFRSLT_QTY
                    , A.BASE_QTY
                    , A.QTY
	        INTO	#tblSCP0105_RAW_ALL
	        FROM	#tblSCP0105_RAW_ALL_TEMP A
	        WHERE	1<>1

            INSERT INTO #tblSCP0105_RAW_ALL
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
			        , A.ITEM_ID
			        , A.NICK_NAME
                    , G.UNIT_GROUP                              AS SPEED_UNIT_GROUP
			        , A.MSR_TP_CD
			        , A.YYYYMM
                    , A.PFRSLT_QTY
                    , A.BASE_QTY
                    , A.QTY
	        FROM	#tblSCP0105_RAW_ALL_TEMP A
                    JOIN #tblSCP0105_SPEED_UNIT_GROUP G ON
                            1=1

        PRINT CONCAT('ELAPSED_TIME-#tblSCP0105_RAW_ALL : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

        --TESTING : NOK
        --select * from SCP_MST_CAPA_ELTR_SPEED_PLAN;
        --select * from #tblSCP0105_RAW_ALL;return;
        --select * from #tblSCP0105_SPEED_UNIT_GROUP;return;
        --select * from #tblSCP0105_RAW_ALL_TEMP WHERE YYYYMM = '202404' AND ELTR_LN_TP_CD = 'Anode';--return;
        --select * from #tblSCP0105_RAW_ALL;return;


	        IF OBJECT_ID('tempdb..#tblSCP0105_RAW_KEYS') IS NOT NULL
		        DROP TABLE #tblSCP0105_RAW_KEYS;

	        --빈테이블 생성
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
			        , A.ITEM_ID
			        , A.NICK_NAME
			        , A.SPEED_UNIT_GROUP
			        , A.MSR_TP_CD
			        , A.YYYYMM
            INTO	#tblSCP0105_RAW_KEYS
	        FROM	#tblSCP0105_RAW_ALL A
	        WHERE	1<>1

                   CREATE CLUSTERED INDEX IDX_tblSCP0105_RAW_KEYS1        ON #tblSCP0105_RAW_KEYS (
		                                                                  VER_ID
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
		                                                                , YYYYMM)

	        INSERT INTO #tblSCP0105_RAW_KEYS
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
			        , A.ITEM_ID
			        , A.NICK_NAME
			        , A.SPEED_UNIT_GROUP
			        , A.MSR_TP_CD
			        , A.YYYYMM
	        FROM	#tblSCP0105_RAW_ALL A
	        WHERE   1=1
				AND A.SPEED_UNIT_GROUP  = 'EQP_SPED'   AND A.MSR_TP_CD = 'EQP_SPED'
	        GROUP BY  A.VER_ID
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
			        , A.SPEED_UNIT_GROUP
			        , A.MSR_TP_CD
			        , A.YYYYMM

        PRINT CONCAT('ELAPSED_TIME-#tblSCP0105_RAW_KEYS : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

        --TESTING : NOK
        --select * from #tblSCP0105_RAW_ALL;
        --select * from #tblSCP0105_RAW_KEYS;return;


	        IF OBJECT_ID('tempdb..#tblSCP0105_RAW_TEMP') IS NOT NULL
		        DROP TABLE #tblSCP0105_RAW_TEMP;

	        --빈테이블 생성
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
			        , A.ITEM_ID
			        , A.NICK_NAME
                    , A.SPEED_UNIT_GROUP
	                , A.MSR_TP_CD
			        , A.YYYYMM
                    , CONVERT(FLOAT, NULL)			AS PFRSLT_QTY
                    , CONVERT(FLOAT, NULL)			AS BASE_QTY
                    , CONVERT(FLOAT, NULL)			AS QTY
                    , CONVERT(NVARCHAR(1), NULL)				AS UI_UPD_YN
            INTO	#tblSCP0105_RAW_TEMP
	        FROM	#tblSCP0105_RAW_KEYS A
	        WHERE	1<>1

                   CREATE CLUSTERED INDEX IDX_tblSCP0105_RAW_TEMP1        ON #tblSCP0105_RAW_TEMP (
		                                                                  VER_ID
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
		                                                                , YYYYMM)

            INSERT INTO #tblSCP0105_RAW_TEMP
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
			        , A.ITEM_ID
			        , A.NICK_NAME
                    , A.SPEED_UNIT_GROUP
	                , A.MSR_TP_CD
			        , A.YYYYMM
                    , R.EQP_SPED                                        AS PFRSLT_QTY
                    , IIF(X.BASE_QTY IS NULL, B.EQP_SPED, X.BASE_QTY)   AS BASE_QTY
                    , X.QTY                                             AS QTY
			        , ISNULL(BU.UI_UPD_YN, 'Y')                         AS UI_UPD_YN
	        FROM	#tblSCP0105_RAW_KEYS A
                    LEFT JOIN #tblSCP0105_RAW_ALL_TEMP X ON
				            A.VER_ID				= X.VER_ID
                        AND A.VER_SEQ				= X.VER_SEQ
                        AND A.DIVISION_ID			= X.DIVISION_ID
                        AND A.COMPANY_ID			= X.COMPANY_ID
                        AND A.SITE_ID				= X.SITE_ID
                        AND A.PLANT_ID				= X.PLANT_ID
                        AND A.FACTORY_ID			= X.FACTORY_ID
                        AND A.LINE_ID				= X.LINE_ID
                        AND A.OPERATION_ID			= X.OPERATION_ID
                        AND A.ELTR_LN_TP_CD			= X.ELTR_LN_TP_CD
                        AND A.ITEM_ID				= X.ITEM_ID
                        AND A.NICK_NAME				= X.NICK_NAME
                        AND A.MSR_TP_CD				= X.MSR_TP_CD
                        AND A.YYYYMM				= X.YYYYMM
			        LEFT JOIN #tblSCP0105_CHECK_RESULT R ON
					        A.DIVISION_ID		                            = R.DIVISION_ID
				        AND A.COMPANY_ID		                            = R.COMPANY_ID
				        AND A.SITE_ID			                            = R.SITE_ID
				        AND A.PLANT_ID			                            = R.PLANT_ID
				        AND A.FACTORY_ID		                            = R.FACTORY_ID
				        AND A.LINE_ID			                            = R.LINE_ID
				        AND A.OPERATION_ID		                            = R.OPERATION_ID
--라인별로 변경				        AND A.ITEM_ID                                       = R.ITEM_ID
--라인별로 변경				        AND A.NICK_NAME                                     = R.NICK_NAME
				        AND A.ELTR_LN_TP_CD	                                = R.ELTR_LN_TP_CD
                        --AND A.SPEED_UNIT_GROUP                              = R.SPEED_UNIT_GROUP
                        --AND A.MSR_TP_CD                                     = R.MSR_TP_CD
			        LEFT JOIN #tblSCP0105_CHECK_BASE B ON
					        A.DIVISION_ID		                            = B.DIVISION_ID
				        AND A.COMPANY_ID		                            = B.COMPANY_ID
				        AND A.SITE_ID			                            = B.SITE_ID
				        AND A.PLANT_ID			                            = B.PLANT_ID
				        AND A.FACTORY_ID		                            = B.FACTORY_ID
				        AND A.LINE_ID			                            = B.LINE_ID
				        AND A.OPERATION_ID		                            = B.OPERATION_ID
				        AND A.ITEM_ID                                       = B.ITEM_ID
				        AND A.NICK_NAME                                     = B.NICK_NAME
				        AND A.ELTR_LN_TP_CD	                                = B.ELTR_LN_TP_CD
                        --AND A.SPEED_UNIT_GROUP                              = B.SPEED_UNIT_GROUP
                        --AND A.MSR_TP_CD                                     = B.MSR_TP_CD
			        LEFT JOIN #tblSCP0105_CHECK_BASE_UI_UPD_YN BU ON
					        A.DIVISION_ID		                            = BU.DIVISION_ID
				        AND A.COMPANY_ID		                            = BU.COMPANY_ID
				        AND A.SITE_ID			                            = BU.SITE_ID
				        AND A.PLANT_ID			                            = BU.PLANT_ID
				        AND A.FACTORY_ID		                            = BU.FACTORY_ID
				        AND A.LINE_ID			                            = BU.LINE_ID
				        AND A.OPERATION_ID		                            = BU.OPERATION_ID
				        AND A.ITEM_ID                                       = BU.ITEM_ID
				        AND A.NICK_NAME                                     = BU.NICK_NAME
				        AND A.ELTR_LN_TP_CD	                                = BU.ELTR_LN_TP_CD

        PRINT CONCAT('ELAPSED_TIME-#tblSCP0105_RAW_TEMP : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from #tblSCP0105_CHECK_RESULT;return;
--select * from #tblSCP0105_CHECK_BASE;return;
--select * from #tblSCP0105_RAW_TEMP;return;


	        IF OBJECT_ID('tempdb..#tblSCP0105_RAW') IS NOT NULL
		        DROP TABLE #tblSCP0105_RAW;

	        --빈테이블 생성
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
			        , A.ITEM_ID
			        , A.NICK_NAME
			        , A.SPEED_UNIT_GROUP
			        , A.MSR_TP_CD
			        , A.YYYYMM
			        , A.UI_UPD_YN
			        , A.PFRSLT_QTY
			        , A.BASE_QTY
			        , A.QTY
			        , CONVERT(NVARCHAR(2), @p_prog_stat)    AS PROG_STAT
	        INTO	#tblSCP0105_RAW
	        FROM    #tblSCP0105_RAW_TEMP A
            WHERE   1<>1;

	        INSERT INTO #tblSCP0105_RAW
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
			        , A.ITEM_ID
			        , A.NICK_NAME
			        , A.SPEED_UNIT_GROUP
			        , A.MSR_TP_CD
			        , A.YYYYMM
			        , A.UI_UPD_YN
			        , AVG(ISNULL(A.PFRSLT_QTY, 0.0))        AS PFRSLT_QTY
			        , AVG(ISNULL(A.BASE_QTY, 0.0))          AS BASE_QTY
			        , AVG(ISNULL(A.QTY, 0.0))               AS QTY
			        , CONVERT(NVARCHAR(2), @p_prog_stat)    AS PROG_STAT
	        FROM    #tblSCP0105_RAW_TEMP A
	        GROUP BY  A.VER_ID
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
			        , A.SPEED_UNIT_GROUP
			        , A.MSR_TP_CD
			        , A.YYYYMM
			        , A.UI_UPD_YN

        PRINT CONCAT('ELAPSED_TIME-#tblSCP0105_RAW : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from #tblSCP0105_RAW WHERE YYYYMM = '202409';return;

            END --****************************************************************************************************************************************************************************************************
        END


        INSERT INTO #tblSCP0106_SPEED_PLAN_TEMP
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
	            , SPEED_UNIT_GROUP
	            , MSR_TP_CD
	            , YYYYMM
	            , PFRSLT_QTY
	            , BASE_QTY
	            , QTY
	            , UI_UPD_YN
	            , PROG_STAT
        FROM    #tblSCP0105_RAW;


--TESTING : NOK
--select * from #tblSCP0106_SPEED_PLAN_TEMP;rollback tran; return;


	    IF OBJECT_ID('tempdb..#tblSCP0106_SPEED_PLAN') IS NOT NULL
			DROP TABLE #tblSCP0106_SPEED_PLAN;

        SELECT    A.DIVISION_ID	
                , A.COMPANY_ID	
                , A.SITE_ID	
                , A.PLANT_ID	
                , A.FACTORY_ID	
                , A.LINE_ID	
                , A.OPERATION_ID	
                , A.ELTR_LN_TP_CD	
                , A.ITEM_ID
                , A.NICK_NAME
                --, A.QTY                 AS PPM
                , A.BASE_QTY            AS BASE_PPM
                , A.PFRSLT_QTY          AS PFRSLT_PPM
        INTO    #tblSCP0106_SPEED_PLAN
        FROM    #tblSCP0106_SPEED_PLAN_TEMP A
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_SPEED_PLAN
        SELECT    A.DIVISION_ID	
                , A.COMPANY_ID	
                , A.SITE_ID	
                , A.PLANT_ID	
                , A.FACTORY_ID	
                , A.LINE_ID	
                , A.OPERATION_ID	
                , A.ELTR_LN_TP_CD	
                , A.ITEM_ID
                , A.NICK_NAME
                --, AVG(A.QTY)            AS PPM
                , AVG(A.BASE_QTY)       AS BASE_PPM
                , AVG(A.PFRSLT_QTY)     AS PFRSLT_PPM
        FROM    #tblSCP0106_SPEED_PLAN_TEMP A WITH(NOLOCK)
        WHERE   1=1
            ----AND MSR_TP_CD = 'PPM'
        GROUP BY  A.DIVISION_ID	
                , A.COMPANY_ID	
                , A.SITE_ID	
                , A.PLANT_ID	
                , A.FACTORY_ID	
                , A.LINE_ID	
                , A.OPERATION_ID	
                , A.ELTR_LN_TP_CD	
                , A.ITEM_ID
                , A.NICK_NAME

--TESTING : NOK
--select * from  #tblSCP0106_SPEED_PLAN;return;


	    IF OBJECT_ID('tempdb..#tblSCP0106_SPEED_PLAN_LN') IS NOT NULL
			DROP TABLE #tblSCP0106_SPEED_PLAN_LN;

        SELECT    A.DIVISION_ID	
                , A.COMPANY_ID	
                , A.SITE_ID	
                , A.PLANT_ID	
                , A.FACTORY_ID	
                , A.LINE_ID	
                , A.OPERATION_ID	
                , A.ELTR_LN_TP_CD	
                , A.BASE_PPM
                , A.PFRSLT_PPM
        INTO    #tblSCP0106_SPEED_PLAN_LN
        FROM    #tblSCP0106_SPEED_PLAN A
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_SPEED_PLAN_LN
        SELECT    A.DIVISION_ID	
                , A.COMPANY_ID	
                , A.SITE_ID	
                , A.PLANT_ID	
                , A.FACTORY_ID	
                , A.LINE_ID	
                , A.OPERATION_ID	
                , A.ELTR_LN_TP_CD	
                , AVG(A.BASE_PPM)
                , AVG(A.PFRSLT_PPM)
        FROM    #tblSCP0106_SPEED_PLAN A
        GROUP BY  A.DIVISION_ID	
                , A.COMPANY_ID	
                , A.SITE_ID	
                , A.PLANT_ID	
                , A.FACTORY_ID	
                , A.LINE_ID	
                , A.OPERATION_ID	
                , A.ELTR_LN_TP_CD	

--TESTING : NOK
--select * from  #tblSCP0106_SPEED_PLAN_LN;return;


    PRINT N'GET - RESULT - BEGIN';--최근 3개월치 평균
    BEGIN
	    DECLARE @v_result_from_yyyymm		NVARCHAR(6)         = N'';
	    DECLARE @v_result_to_yyyymm			NVARCHAR(6)         = N'';

        SET @v_result_from_yyyymm   = CONVERT(CHAR(8), DATEADD(MM, -3, CONVERT(DATETIME, @p_version + '01')), 112);
        SET @v_result_to_yyyymm     = CONVERT(CHAR(8), DATEADD(MM, -1, CONVERT(DATETIME, @p_version + '01')), 112);

        PRINT CONCAT('@v_result_from_yyyymm', @v_result_from_yyyymm);
        PRINT CONCAT('@v_result_to_yyyymm', @v_result_to_yyyymm);
--rollback tran;return;

        DECLARE @v_result_day_cnt   FLOAT     =  1.0;

        --실적 작업일수
        SELECT  @v_result_day_cnt   = AVG(DAY_CNT)
        FROM    (
                    SELECT    BASIS_YYYYMM      AS YYYYMM
                            , CONVERT(FLOAT, COUNT(*))    AS DAY_CNT
                    FROM    SCM_SYS_CALENDAR_M
                    WHERE   1=1
                        AND BASIS_YYYYMMDD >= @v_result_from_yyyymm
                        AND BASIS_YYYYMMDD < @p_version
                    GROUP BY BASIS_YYYYMM
                ) A

        PRINT CONCAT('@v_result_day_cnt : ', @v_result_day_cnt);
        --return;

        DECLARE @v_base_day_cnt   FLOAT     =  1.0;

        --Base 작업일수
	    IF OBJECT_ID('tempdb..#tbl_DAY_CNT_BASE') IS NOT NULL
			DROP TABLE #tbl_DAY_CNT_BASE;

		SELECT    DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, SOP_DT
				, SOP_YM			AS YYYYMM
				, SOP_DDN			AS DAY_CNT
        INTO    #tbl_DAY_CNT_BASE
		FROM    SCP_MST_CAPA_ELTR_LINE_SOP WITH(NOLOCK)
		WHERE   1<>1

        INSERT INTO #tbl_DAY_CNT_BASE
		SELECT    DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, SOP_DT
				, SOP_YM			AS YYYYMM
				, SOP_DDN			AS DAY_CNT
		FROM    SCP_MST_CAPA_ELTR_LINE_SOP WITH(NOLOCK)
		WHERE   1=1
			AND VALID_YN        = 'Y'
            AND SOP_YM          = @p_version --버전으로 월 고정


        --운영계획 월별 작업일수
	    IF OBJECT_ID('tempdb..#tbl_DAY_CNT_YYYYMM') IS NOT NULL
			DROP TABLE #tbl_DAY_CNT_YYYYMM;

		SELECT    DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, SOP_DT
				, SOP_YM			AS YYYYMM
				, SOP_DDN			AS DAY_CNT
        INTO    #tbl_DAY_CNT_YYYYMM
		FROM    SCP_MST_CAPA_ELTR_LINE_SOP WITH(NOLOCK)
		WHERE   1<>1

        INSERT INTO #tbl_DAY_CNT_YYYYMM
		SELECT    DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, SOP_DT
				, SOP_YM			AS YYYYMM
				, SOP_DDN			AS DAY_CNT
		FROM    SCP_MST_CAPA_ELTR_LINE_SOP WITH(NOLOCK)
		WHERE   1=1
			AND VALID_YN        = 'Y'

--TESTING : NOK;
--select * from #tbl_DAY_CNT_YYYYMM WHERE YYYYMM = '202409';rollback tran;return;


        --운영계획 연도별 작업일수
	    IF OBJECT_ID('tempdb..#tbl_DAY_CNT_YYYYMM_YEAR') IS NOT NULL
			DROP TABLE #tbl_DAY_CNT_YYYYMM_YEAR;

		SELECT    DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, SOP_DT
				, SUBSTRING(YYYYMM, 1, 4)			AS YYYY
				, CASE
                    WHEN ISNULL(YYYYMM, '') <> '' THEN  DATEDIFF(DAY, SOP_DT,                           SUBSTRING(YYYYMM, 1, 4) + '1231') + 1 -- SOP 적용 일수
                    ELSE                                DATEDIFF(DAY, SUBSTRING(YYYYMM, 1, 4) + '0101', SUBSTRING(YYYYMM, 1, 4) + '1231') + 1 -- 연간총일수
                  END               AS DAY_CNT
        INTO    #tbl_DAY_CNT_YYYYMM_YEAR
		FROM    #tbl_DAY_CNT_YYYYMM
		WHERE   1<>1
        
        INSERT INTO #tbl_DAY_CNT_YYYYMM_YEAR
		SELECT    DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, SOP_DT
				, SUBSTRING(YYYYMM, 1, 4)			AS YYYY
				, CASE
                    WHEN ISNULL(YYYYMM, '') <> '' THEN  DATEDIFF(DAY, SOP_DT,                           SUBSTRING(YYYYMM, 1, 4) + '1231') + 1 -- SOP 적용 일수
                    ELSE                                DATEDIFF(DAY, SUBSTRING(YYYYMM, 1, 4) + '0101', SUBSTRING(YYYYMM, 1, 4) + '1231') + 1 -- 연간총일수
                  END               AS DAY_CNT
		FROM    #tbl_DAY_CNT_YYYYMM
		WHERE   1=1

    	IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_RAW') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_RAW;

        --빈테이블 생성
		SELECT	  A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.LOSS_CD
				, A.LOSS_RT
                --, M.IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
        INTO    #tblSCP0106_RESULT_LN_RAW
		FROM	SCM_DNM_ELTR_LOSS_LN_MMLY A WITH(NOLOCK)
                LEFT JOIN #tblSCP0106_CHECK_MEASURE M ON
                        A.LOSS_CD   = M.LOSS_CD
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_RESULT_LN_RAW
		SELECT	  A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.LOSS_CD
				, AVG(A.LOSS_RT)                    AS LOSS_RT
                --, MAX(M.IPRV_GOL_DIVS_CD)           AS IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
		FROM	SCM_DNM_ELTR_LOSS_LN_MMLY A WITH(NOLOCK)
                LEFT JOIN #tblSCP0106_CHECK_MEASURE M ON
                        A.LOSS_CD   = M.LOSS_CD
        WHERE   1=1
            --AND A.LOSS_YM BETWEEN @v_result_from_yyyymm AND @v_result_to_yyyymm
            AND A.PERD_DIVS_CD		= '3'
            AND A.LOSS_YM			= @v_result_to_yyyymm
        GROUP BY  A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.LOSS_CD;

--TESTING : NOK;
--select * from #tblSCP0106_RESULT_LN_RAW;rollback tran;return;


        IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN') IS NOT NULL
		    DROP TABLE #tblSCP0106_RESULT_LN;

        --빈테이블 생성
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , '-'                               AS MDL_NM
			    , A.LOSS_CD
			    , AVG(A.LOSS_RT)                    AS LOSS_RT
                --, MAX(M.IPRV_GOL_DIVS_CD)           AS IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
        INTO    #tblSCP0106_RESULT_LN
		FROM	SCM_DNM_ELTR_LOSS_LN_MMLY A WITH(NOLOCK)
                LEFT JOIN #tblSCP0106_CHECK_MEASURE M ON
                        A.LOSS_CD   = M.LOSS_CD
        WHERE   1<>1
        GROUP BY  A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.LOSS_CD;

        INSERT INTO #tblSCP0106_RESULT_LN
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , '-'                               AS MDL_NM
			    , A.LOSS_CD
			    , AVG(A.LOSS_RT)                    AS LOSS_RT
                --, MAX(M.IPRV_GOL_DIVS_CD)           AS IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
	    FROM	SCM_DNM_ELTR_LOSS_LN_MMLY A WITH(NOLOCK)
                LEFT JOIN #tblSCP0106_CHECK_MEASURE M ON
                        A.LOSS_CD   = M.LOSS_CD
        WHERE   1=1
            AND A.PERD_DIVS_CD      = '3'
            AND A.LOSS_YM           = @v_result_to_yyyymm
            ----AND A.LOSS_YM BETWEEN @v_result_from_yyyymm AND @v_result_to_yyyymm
		    --AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		    --AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		    --AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		    --AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		    --AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		    --AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		    --AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
        GROUP BY  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.LOSS_CD;
        PRINT CONCAT('ELAPSED_TIME-#tblSCP0106_RESULT_LN : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK;
--select * from #tblSCP0106_RESULT_LN;return;



--운영계획용 begin ###############################################################################################################################################################
    	IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_RAW') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_RAW;

        --빈테이블 생성
		SELECT	  A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.LOSS_CD
				, A.LOSS_RT
                --, A.IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
        INTO    #tblSCP0106_RESULT_LN_YYYYMM_RAW
		FROM	#tblSCP0106_RESULT_LN_RAW A
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_RAW
		SELECT	  A.DIVISION_ID 
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.LOSS_CD
				------TEST, IIF(A.IPRV_GOL_DIVS_CD = 'G', 0.0, A.LOSS_RT)     AS LOSS_RT
				, A.LOSS_RT
                --, A.IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
		FROM	#tblSCP0106_RESULT_LN_RAW A
        WHERE   1=1

--TESTING : NOK;
--select * from #tblSCP0106_RESULT_LN_YYYYMM_RAW;rollback tran;return;


        IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM') IS NOT NULL
		    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM;

        --빈테이블 생성
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.MDL_NM
			    , A.LOSS_CD
			    , A.LOSS_RT
                --, A.IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
        INTO    #tblSCP0106_RESULT_LN_YYYYMM
	    FROM	#tblSCP0106_RESULT_LN A
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.MDL_NM
			    , A.LOSS_CD
				------TEST, IIF(A.IPRV_GOL_DIVS_CD = 'G', 0.0, A.LOSS_RT)     AS LOSS_RT
				, A.LOSS_RT
                --, A.IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
	    FROM	#tblSCP0106_RESULT_LN A
        WHERE   1=1
        PRINT CONCAT('ELAPSED_TIME-#tblSCP0106_RESULT_LN_YYYYMM : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK;
--select * from #tblSCP0106_RESULT_LN_YYYYMM;return;
--운영계획용 end ###############################################################################################################################################################



    	IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_KEYS_MDL') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_KEYS_MDL;

        --빈테이블 생성
		SELECT	  A.DIVISION_ID
                , A.ITEM_ID         AS MDL_NM
				--, A.NICK_NAME       AS MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
        INTO    #tblSCP0106_RESULT_KEYS_MDL
        FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN A
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_RESULT_KEYS_MDL
		SELECT	  A.DIVISION_ID
                , A.ITEM_ID         AS MDL_NM
				--, A.NICK_NAME       AS MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
        FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN A
        GROUP BY  A.DIVISION_ID
				, A.ITEM_ID
				--, A.NICK_NAME
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID;

--TESTING : NOK
--select * from #tblSCP0106_RESULT_KEYS_MDL;rollback tran;return;


    	IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_KEYS_LN') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_KEYS_LN;

        --빈테이블 생성
		SELECT	  A.DIVISION_ID
                --, A.ITEM_ID         AS MDL_NM
				--, A.NICK_NAME       AS MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
        INTO    #tblSCP0106_RESULT_KEYS_LN
        FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN A
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_RESULT_KEYS_LN
		SELECT	  A.DIVISION_ID
                --, A.ITEM_ID         AS MDL_NM
				--, A.NICK_NAME       AS MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
        FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN A
        GROUP BY  A.DIVISION_ID
				--, A.ITEM_ID
				--, A.NICK_NAME
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID;

--TESTING : NOK
--select * from #tblSCP0106_RESULT_KEYS_LN;rollback tran;return;


    	IF OBJECT_ID('tempdb..#tblSCP0106_YYYYMM_KEYS_MDL') IS NOT NULL
			DROP TABLE #tblSCP0106_YYYYMM_KEYS_MDL;

        --빈테이블 생성
		SELECT	  A.DIVISION_ID
                , A.ITEM_ID         AS MDL_NM
				--, A.NICK_NAME       AS MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.YYYYMM
        INTO    #tblSCP0106_YYYYMM_KEYS_MDL
        FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN A
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_YYYYMM_KEYS_MDL
		SELECT	  A.DIVISION_ID
                , A.ITEM_ID         AS MDL_NM
				--, A.NICK_NAME       AS MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.YYYYMM
        FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN A
        GROUP BY  A.DIVISION_ID
				, A.ITEM_ID
				--, A.NICK_NAME
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.YYYYMM

--TESTING : NOK
--select * from #tblSCP0106_YYYYMM_KEYS_MDL;rollback tran;return;


    	IF OBJECT_ID('tempdb..#tblSCP0106_YYYYMM_KEYS_LN') IS NOT NULL
			DROP TABLE #tblSCP0106_YYYYMM_KEYS_LN;

        --빈테이블 생성
		SELECT	  A.DIVISION_ID
                --, A.ITEM_ID         AS MDL_NM
				--, A.NICK_NAME       AS MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.YYYYMM
        INTO    #tblSCP0106_YYYYMM_KEYS_LN
        FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN A
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_YYYYMM_KEYS_LN
		SELECT	  A.DIVISION_ID
                --, A.ITEM_ID         AS MDL_NM
				--, A.NICK_NAME       AS MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.YYYYMM
        FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN A
        GROUP BY  A.DIVISION_ID
				--, A.ITEM_ID
				--, A.NICK_NAME
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.YYYYMM

--TESTING : NOK
--select * from #tblSCP0106_YYYYMM_KEYS_LN;rollback tran;return;




        PRINT N'계산용 서브쿼리 - Result, Base용 - BEGIN';
        BEGIN
		    --조업율
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_AV_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_AV_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_AV_RT
		    FROM    #tblSCP0106_RESULT_LN_RAW
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_AV_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN_RAW
		    WHERE   1=1
			    AND LOSS_CD = 'AV_RT';

--TESTING : NOK
--select * from #tblSCP0106_RESULT_LN_AV_RT;return;

		    --양품가동률만 모델별 ----------------------------------------------------------------------
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_QL_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_QL_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_QL_RT
		    FROM    #tblSCP0106_RESULT_LN_RAW
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_QL_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN_RAW
		    WHERE   1=1
			    AND LOSS_CD = 'QL_RT';

--TESTING : NOK
--select * from #tblSCP0106_RESULT_LN_QL_RT;return;

		    --나머지는 모두 라인별 ----------------------------------------------------------------------
		    --BM
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_BM_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_BM_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_BM_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_BM_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'BM_RT';

		    --CM
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_CM_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_CM_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_CM_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_CM_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'CM_RT';

		    --Idle_LOB 설비대기
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_ID_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_ID_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_ID_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_ID_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'ID_RT';

		    --재료교체
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_MR_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_MR_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_MR_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_MR_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'MR_RT';

		    --원자재 품절
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_NM_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_NM_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_NM_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_NM_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'NM_RT';

		    --PD
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_PD_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_PD_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_PD_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_PD_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'PD_RT';

		    --성능가동률
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_PF_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_PF_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_PF_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_PF_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'PF_RT';

    --TESTING : NOK
    --select * from #tblSCP0106_RESULT_LN;return;
    --select * from #tblSCP0106_RESULT_LN_PF_RT WHERE YYYYMM = '202404';return;

		    --PM
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_PM_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_PM_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_PM_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_PM_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'PM_RT';

		    --생산준비
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_PP_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_PP_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_PP_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_PP_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'PP_RT';

		    --UT Down
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_UD_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_UD_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_UD_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_UD_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'UD_RT';
        END
        PRINT N'계산용 서브쿼리 - Result, Base용 - END';


--TESTING:NOK
--select * from #tblSCP0106_RESULT_LN_AV_RT;rollback tran;return;
--select * from #tblSCP0106_RESULT_LN_BM_RT;
--select * from #tblSCP0106_RESULT_LN_CM_RT;
--select * from #tblSCP0106_RESULT_LN_ID_RT;
--select * from #tblSCP0106_RESULT_LN_MR_RT;rollback tran;return
--select * from #tblSCP0106_RESULT_LN_NM_RT;
--select * from #tblSCP0106_RESULT_LN_PD_RT;
--select * from #tblSCP0106_RESULT_LN_PF_RT;
--select * from #tblSCP0106_RESULT_LN_PM_RT;
--select * from #tblSCP0106_RESULT_LN_PP_RT;
--select * from #tblSCP0106_RESULT_LN_QL_RT;rollback tran;return;
--select * from #tblSCP0106_RESULT_LN_UD_RT;
--return;


        PRINT N'계산용 서브쿼리 - 운영계획용 - BEGIN';
        BEGIN
		    --조업율
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_AV_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_AV_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_YYYYMM_AV_RT
		    FROM    #tblSCP0106_RESULT_LN_YYYYMM_RAW
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_AV_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN_YYYYMM_RAW
		    WHERE   1=1
			    AND LOSS_CD = 'AV_RT';

--TESTING : NOK
--select * from #tblSCP0106_RESULT_LN_YYYYMM_AV_RT;return;

		    --양품가동률만 모델별 ----------------------------------------------------------------------
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_QL_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_QL_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_YYYYMM_QL_RT
		    FROM    #tblSCP0106_RESULT_LN_YYYYMM_RAW
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_QL_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN_YYYYMM_RAW
		    WHERE   1=1
			    AND LOSS_CD = 'QL_RT';

--TESTING : NOK
--select * from #tblSCP0106_RESULT_LN_YYYYMM_QL_RT;return;

		    --나머지는 모두 라인별 ----------------------------------------------------------------------
		    --BM
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_BM_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_BM_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_YYYYMM_BM_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_BM_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'BM_RT';

		    --CM
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_CM_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_CM_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_YYYYMM_CM_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_CM_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'CM_RT';

		    --Idle_LOB 설비대기
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_ID_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_ID_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_YYYYMM_ID_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_ID_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'ID_RT';

		    --재료교체
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_MR_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_MR_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_YYYYMM_MR_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_MR_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'MR_RT';

		    --원자재 품절
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_NM_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_NM_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_YYYYMM_NM_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_NM_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'NM_RT';

		    --PD
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_PD_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_PD_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_YYYYMM_PD_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_PD_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'PD_RT';

		    --성능가동률
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_PF_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_PF_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_YYYYMM_PF_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_PF_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'PF_RT';

    --TESTING : NOK
    --select * from #tblSCP0106_RESULT_LN;return;
    --select * from #tblSCP0106_RESULT_LN_YYYYMM_PF_RT WHERE YYYYMM = '202404';return;

		    --PM
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_PM_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_PM_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_YYYYMM_PM_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_PM_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'PM_RT';

		    --생산준비
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_PP_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_PP_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_YYYYMM_PP_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_PP_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'PP_RT';

		    --UT Down
		    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_UD_RT') IS NOT NULL
			    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_UD_RT;

		    SELECT  *
		    INTO    #tblSCP0106_RESULT_LN_YYYYMM_UD_RT
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1<>1;

		    INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_UD_RT
		    SELECT  *
		    FROM    #tblSCP0106_RESULT_LN
		    WHERE   1=1
			    AND LOSS_CD = 'UD_RT';
        END
        PRINT N'계산용 서브쿼리 - 운영계획용 - END';


--TESTING:NOK
--select * from #tblSCP0106_RESULT_LN_YYYYMM_AV_RT;rollback tran;return;
--select * from #tblSCP0106_RESULT_LN_YYYYMM_BM_RT;
--select * from #tblSCP0106_RESULT_LN_YYYYMM_CM_RT;
--select * from #tblSCP0106_RESULT_LN_YYYYMM_ID_RT;
--select * from #tblSCP0106_RESULT_LN_YYYYMM_MR_RT;rollback tran;return
--select * from #tblSCP0106_RESULT_LN_YYYYMM_NM_RT;
--select * from #tblSCP0106_RESULT_LN_YYYYMM_PD_RT;
--select * from #tblSCP0106_RESULT_LN_YYYYMM_PF_RT;
--select * from #tblSCP0106_RESULT_LN_YYYYMM_PM_RT;
--select * from #tblSCP0106_RESULT_LN_YYYYMM_PP_RT;
--select * from #tblSCP0106_RESULT_LN_YYYYMM_QL_RT;rollback tran;return;
--select * from #tblSCP0106_RESULT_LN_YYYYMM_UD_RT;
--return;



        PRINT N'#tblSCP0106_RESULT_LN_TEMP - Result, Base용 - BEGIN';
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_TEMP') IS NOT NULL
		    DROP TABLE #tblSCP0106_RESULT_LN_TEMP;

        --빈테이블 생성
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , CONVERT(FLOAT, NULL)				AS BM_RT
			    , CONVERT(FLOAT, NULL)				AS CM_RT
			    , CONVERT(FLOAT, NULL)				AS ID_RT
			    , CONVERT(FLOAT, NULL)				AS MR_RT
			    , CONVERT(FLOAT, NULL)				AS NM_RT
			    , CONVERT(FLOAT, NULL)				AS PD_RT
			    , CONVERT(FLOAT, NULL)				AS PM_RT
			    , CONVERT(FLOAT, NULL)				AS PP_RT
			    , CONVERT(FLOAT, NULL)				AS UD_RT

                , CONVERT(FLOAT, NULL)				AS OP_RT
			    , CONVERT(FLOAT, NULL)				AS LD_RT
			    , CONVERT(FLOAT, NULL)              AS AV_RT
			    , CONVERT(FLOAT, NULL)				AS PF_RT
			    , CONVERT(FLOAT, NULL)				AS QL_RT
        INTO    #tblSCP0106_RESULT_LN_TEMP
        FROM    #tblSCP0106_RESULT_KEYS_LN A
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_RESULT_LN_TEMP
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , ISNULL(BM_RT.LOSS_RT, 0)						AS BM_RT
			    , CM_RT.LOSS_RT						            AS CM_RT
			    , ID_RT.LOSS_RT						            AS ID_RT
			    , MR_RT.LOSS_RT						            AS MR_RT
			    , NM_RT.LOSS_RT						            AS NM_RT
			    , PD_RT.LOSS_RT						            AS PD_RT
			    , PM_RT.LOSS_RT						            AS PM_RT
			    , PP_RT.LOSS_RT						            AS PP_RT
			    , UD_RT.LOSS_RT						            AS UD_RT

                , CONVERT(FLOAT, (1.0 - (IIF(BM_RT.LOSS_RT IS NULL, 0.0, BM_RT.LOSS_RT) + IIF(CM_RT.LOSS_RT IS NULL, 0.0, CM_RT.LOSS_RT) + IIF(PD_RT.LOSS_RT IS NULL, 0.0, PD_RT.LOSS_RT) + IIF(PM_RT.LOSS_RT IS NULL, 0.0, PM_RT.LOSS_RT) + IIF(UD_RT.LOSS_RT IS NULL, 0.0, UD_RT.LOSS_RT) + IIF(PP_RT.LOSS_RT IS NULL, 0.0, PP_RT.LOSS_RT) + IIF(MR_RT.LOSS_RT IS NULL, 0.0, MR_RT.LOSS_RT))))	AS OP_RT
			    , CONVERT(FLOAT, (1.0 - (IIF(ID_RT.LOSS_RT IS NULL, 0.0, ID_RT.LOSS_RT) + IIF(NM_RT.LOSS_RT IS NULL, 0.0, NM_RT.LOSS_RT))))		                                                                                                                                                                                                                                                    AS LD_RT
			    , AV_RT.LOSS_RT                     AS AV_RT--Current 조업율 100
			    , CONVERT(FLOAT, PF_RT.LOSS_RT)		AS PF_RT
			    , CONVERT(FLOAT, QL_RT.LOSS_RT)		AS QL_RT
        FROM    #tblSCP0106_RESULT_KEYS_LN A
                    LEFT JOIN #tblSCP0106_RESULT_LN_BM_RT BM_RT ON --BM
					        A.DIVISION_ID			= BM_RT.DIVISION_ID
				        AND A.COMPANY_ID			= BM_RT.COMPANY_ID
				        AND A.SITE_ID				= BM_RT.SITE_ID
				        AND A.PLANT_ID				= BM_RT.PLANT_ID
				        AND A.FACTORY_ID			= BM_RT.FACTORY_ID
				        AND A.LINE_ID				= BM_RT.LINE_ID
				        AND A.OPERATION_ID			= BM_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= BM_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= BM_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_CM_RT CM_RT ON --CM
					        A.DIVISION_ID			= CM_RT.DIVISION_ID
				        AND A.COMPANY_ID			= CM_RT.COMPANY_ID
				        AND A.SITE_ID				= CM_RT.SITE_ID
				        AND A.PLANT_ID				= CM_RT.PLANT_ID
				        AND A.FACTORY_ID			= CM_RT.FACTORY_ID
				        AND A.LINE_ID				= CM_RT.LINE_ID
				        AND A.OPERATION_ID			= CM_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= CM_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= CM_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_ID_RT ID_RT ON --Idle_LOB 설비대기
					        A.DIVISION_ID			= ID_RT.DIVISION_ID
				        AND A.COMPANY_ID			= ID_RT.COMPANY_ID
				        AND A.SITE_ID				= ID_RT.SITE_ID
				        AND A.PLANT_ID				= ID_RT.PLANT_ID
				        AND A.FACTORY_ID			= ID_RT.FACTORY_ID
				        AND A.LINE_ID				= ID_RT.LINE_ID
				        AND A.OPERATION_ID			= ID_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= ID_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= ID_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_MR_RT MR_RT ON --재료교체
					        A.DIVISION_ID			= MR_RT.DIVISION_ID
				        AND A.COMPANY_ID			= MR_RT.COMPANY_ID
				        AND A.SITE_ID				= MR_RT.SITE_ID
				        AND A.PLANT_ID				= MR_RT.PLANT_ID
				        AND A.FACTORY_ID			= MR_RT.FACTORY_ID
				        AND A.LINE_ID				= MR_RT.LINE_ID
				        AND A.OPERATION_ID			= MR_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= MR_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= MR_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_NM_RT NM_RT ON --원자재 품절
					        A.DIVISION_ID			= NM_RT.DIVISION_ID
				        AND A.COMPANY_ID			= NM_RT.COMPANY_ID
				        AND A.SITE_ID				= NM_RT.SITE_ID
				        AND A.PLANT_ID				= NM_RT.PLANT_ID
				        AND A.FACTORY_ID			= NM_RT.FACTORY_ID
				        AND A.LINE_ID				= NM_RT.LINE_ID
				        AND A.OPERATION_ID			= NM_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= NM_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= NM_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_PD_RT PD_RT ON --PD
					        A.DIVISION_ID			= PD_RT.DIVISION_ID
				        AND A.COMPANY_ID			= PD_RT.COMPANY_ID
				        AND A.SITE_ID				= PD_RT.SITE_ID
				        AND A.PLANT_ID				= PD_RT.PLANT_ID
				        AND A.FACTORY_ID			= PD_RT.FACTORY_ID
				        AND A.LINE_ID				= PD_RT.LINE_ID
				        AND A.OPERATION_ID			= PD_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= PD_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= PD_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_PF_RT PF_RT ON --성능가동률
					        A.DIVISION_ID			= PF_RT.DIVISION_ID
				        AND A.COMPANY_ID			= PF_RT.COMPANY_ID
				        AND A.SITE_ID				= PF_RT.SITE_ID
				        AND A.PLANT_ID				= PF_RT.PLANT_ID
				        AND A.FACTORY_ID			= PF_RT.FACTORY_ID
				        AND A.LINE_ID				= PF_RT.LINE_ID
				        AND A.OPERATION_ID			= PF_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= PF_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= PF_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_PM_RT PM_RT ON --PM
					        A.DIVISION_ID			= PM_RT.DIVISION_ID
				        AND A.COMPANY_ID			= PM_RT.COMPANY_ID
				        AND A.SITE_ID				= PM_RT.SITE_ID
				        AND A.PLANT_ID				= PM_RT.PLANT_ID
				        AND A.FACTORY_ID			= PM_RT.FACTORY_ID
				        AND A.LINE_ID				= PM_RT.LINE_ID
				        AND A.OPERATION_ID			= PM_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= PM_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= PM_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_PP_RT PP_RT ON --생산준비
					        A.DIVISION_ID			= PP_RT.DIVISION_ID
				        AND A.COMPANY_ID			= PP_RT.COMPANY_ID
				        AND A.SITE_ID				= PP_RT.SITE_ID
				        AND A.PLANT_ID				= PP_RT.PLANT_ID
				        AND A.FACTORY_ID			= PP_RT.FACTORY_ID
				        AND A.LINE_ID				= PP_RT.LINE_ID
				        AND A.OPERATION_ID			= PP_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= PP_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= PP_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_AV_RT AV_RT ON --AV
					        A.DIVISION_ID			= AV_RT.DIVISION_ID
				        AND A.COMPANY_ID			= AV_RT.COMPANY_ID
				        AND A.SITE_ID				= AV_RT.SITE_ID
				        AND A.PLANT_ID				= AV_RT.PLANT_ID
				        AND A.FACTORY_ID			= AV_RT.FACTORY_ID
				        AND A.LINE_ID				= AV_RT.LINE_ID
				        AND A.OPERATION_ID			= AV_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= AV_RT.ELTR_LN_TP_CD
                    LEFT JOIN #tblSCP0106_RESULT_LN_QL_RT QL_RT ON --양품가동률
					        A.DIVISION_ID			= QL_RT.DIVISION_ID
				        AND A.COMPANY_ID			= QL_RT.COMPANY_ID
				        AND A.SITE_ID				= QL_RT.SITE_ID
				        AND A.PLANT_ID				= QL_RT.PLANT_ID
				        AND A.FACTORY_ID			= QL_RT.FACTORY_ID
				        AND A.LINE_ID				= QL_RT.LINE_ID
				        AND A.OPERATION_ID			= QL_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= QL_RT.ELTR_LN_TP_CD
				        ----AND A.MDL_NM				= QL_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_UD_RT UD_RT ON --UT Down
					        A.DIVISION_ID			= UD_RT.DIVISION_ID
				        AND A.COMPANY_ID			= UD_RT.COMPANY_ID
				        AND A.SITE_ID				= UD_RT.SITE_ID
				        AND A.PLANT_ID				= UD_RT.PLANT_ID
				        AND A.FACTORY_ID			= UD_RT.FACTORY_ID
				        AND A.LINE_ID				= UD_RT.LINE_ID
				        AND A.OPERATION_ID			= UD_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= UD_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= UD_RT.MDL_NM

        PRINT N'#tblSCP0106_RESULT_LN_TEMP - Result, Base용 - END';

--TESTING:NOK
--select * from #tblSCP0106_RESULT_KEYS_MDL;
----select * from #tblSCP0106_RESULT_LN_QL_RT;
--select * from #tblSCP0106_RESULT_LN_MR_RT;
--select * from #tblSCP0106_RESULT_LN_TEMP;return;


        PRINT N'#tblSCP0106_RESULT_MDL_FINAL - Result, Base용 - BEGIN';
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_MDL_FINAL') IS NOT NULL
		    DROP TABLE #tblSCP0106_RESULT_MDL_FINAL;

        --빈테이블 생성
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.MDL_NM
			    , CONVERT(FLOAT, NULL)			AS BM_RT
			    , CONVERT(FLOAT, NULL)			AS CM_RT
			    , CONVERT(FLOAT, NULL)			AS ID_RT
			    , CONVERT(FLOAT, NULL)			AS MR_RT
			    , CONVERT(FLOAT, NULL)			AS NM_RT
			    , CONVERT(FLOAT, NULL)			AS PD_RT
			    , CONVERT(FLOAT, NULL)			AS PM_RT
			    , CONVERT(FLOAT, NULL)			AS PP_RT
			    , CONVERT(FLOAT, NULL)			AS UD_RT

			    , CONVERT(FLOAT, NULL)			AS OP_RT
			    , CONVERT(FLOAT, NULL)			AS LD_RT
			    , CONVERT(FLOAT, NULL)			AS QL_RT

			    , CONVERT(FLOAT, NULL)			AS PFRSLT_AV_RT
			    , CONVERT(FLOAT, NULL)			AS PFRSLT_PF_RT
			    , CONVERT(FLOAT, NULL)			AS PFRSLT_TEEP
			    , CONVERT(FLOAT, NULL)			AS PFRSLT_PROD_OP_RT
			    , CONVERT(FLOAT, NULL)			AS PFRSLT_THRY_CAPA_D
                , CONVERT(FLOAT, NULL)			AS PFRSLT_PROD_CAPA_D
                , CONVERT(FLOAT, NULL)			AS PFRSLT_PROD_CAPA_M
                , CONVERT(FLOAT, NULL)			AS PFRSLT_PPM

			    , CONVERT(FLOAT, NULL)			AS BASE_AV_RT
			    , CONVERT(FLOAT, NULL)			AS BASE_PF_RT
			    , CONVERT(FLOAT, NULL)			AS BASE_TEEP
			    , CONVERT(FLOAT, NULL)			AS BASE_PROD_OP_RT
			    , CONVERT(FLOAT, NULL)			AS BASE_THRY_CAPA_D
                , CONVERT(FLOAT, NULL)			AS BASE_PROD_CAPA_D
				, CONVERT(FLOAT, NULL)			AS BASE_PROD_CAPA_M
                , CONVERT(FLOAT, NULL)			AS BASE_PPM
	    INTO	#tblSCP0106_RESULT_MDL_FINAL
        FROM    #tblSCP0106_RESULT_KEYS_MDL A
	    WHERE	1<>1;

	    INSERT INTO #tblSCP0106_RESULT_MDL_FINAL
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.MDL_NM
			    , B.BM_RT
			    , B.CM_RT
			    , B.ID_RT
			    , B.MR_RT
			    , B.NM_RT
			    , B.PD_RT
			    , B.PM_RT
			    , B.PP_RT
			    , B.UD_RT

			    , B.OP_RT
			    , B.LD_RT
			    , B.QL_RT

			    , B.AV_RT                                                                                                                                   AS PFRSLT_AV_RT
			    , B.PF_RT                                                                                                                                   AS PFRSLT_PF_RT
			    , (B.AV_RT * B.LD_RT * B.OP_RT * B.PF_RT * B.QL_RT)	                                                                                        AS PFRSLT_TEEP
			    , (B.LD_RT * B.OP_RT * B.PF_RT * B.QL_RT)							                                                                        AS PFRSLT_PROD_OP_RT
			    , IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.PFRSLT_PPM * 1440.0)														                    AS PFRSLT_THRY_CAPA_D
                , IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.PFRSLT_PPM * 1440.0) * (B.LD_RT * B.OP_RT  * B.PF_RT  * B.QL_RT)						        AS PFRSLT_PROD_CAPA_D
                ------, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.PFRSLT_PPM * 1440.0) * (B.LD_RT * B.OP_RT  * B.PF_RT  * B.QL_RT) * @v_result_day_cnt * B.AV_RT	AS PFRSLT_PROD_CAPA_M
                , IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.PFRSLT_PPM * 1440.0) * (B.LD_RT * B.OP_RT  * B.PF_RT  * B.QL_RT) * @v_result_day_cnt        	AS PFRSLT_PROD_CAPA_M
                , S.PFRSLT_PPM

			    , CONVERT(FLOAT, 1.0)                                                                                                                       AS BASE_AV_RT
			    , CONVERT(FLOAT, 1.0)                                                                                                                       AS BASE_PF_RT
			    , (1.0 * B.LD_RT * B.OP_RT * 1.0 * B.QL_RT)	                                                                                                AS BASE_TEEP
			    , (B.LD_RT * B.OP_RT * 1.0 * B.QL_RT)							                                                                            AS BASE_PROD_OP_RT
			    , IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.BASE_PPM * 1440.0)														                        AS BASE_THRY_CAPA_D
                , IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.BASE_PPM * 1440.0) * (B.LD_RT * B.OP_RT  * 1.0 * B.QL_RT)						                AS BASE_PROD_CAPA_D
                , IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.BASE_PPM * 1440.0) * (B.LD_RT * B.OP_RT  * 1.0 * B.QL_RT) * 
					CASE
						WHEN DC.DIVISION_ID IS NULL THEN DAY(EOMONTH(CONVERT(DATE, @p_version + '01')))                              -- 월별 & SOP 없을때
						ELSE DC.DAY_CNT                                                                                              -- 월별 & SOP 존재
					END
                   ------* B.AV_RT
                                                                                                                                                            AS BASE_PROD_CAPA_M
                , S.BASE_PPM
        FROM    #tblSCP0106_RESULT_KEYS_MDL A
                LEFT JOIN #tblSCP0106_RESULT_LN_TEMP B ON
					    A.DIVISION_ID			= B.DIVISION_ID
				    AND A.COMPANY_ID			= B.COMPANY_ID
				    AND A.SITE_ID				= B.SITE_ID
				    AND A.PLANT_ID				= B.PLANT_ID
				    AND A.FACTORY_ID			= B.FACTORY_ID
				    AND A.LINE_ID				= B.LINE_ID
				    AND A.OPERATION_ID			= B.OPERATION_ID
				    AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
				    --AND A.MDL_NM				= B.MDL_NM
                LEFT JOIN #tblSCP0106_SPEED_PLAN S ON
                        A.DIVISION_ID			= S.DIVISION_ID
				    AND A.COMPANY_ID			= S.COMPANY_ID
				    AND A.SITE_ID				= S.SITE_ID
				    AND A.PLANT_ID				= S.PLANT_ID
				    AND A.FACTORY_ID			= S.FACTORY_ID
				    AND A.LINE_ID				= S.LINE_ID
				    AND A.OPERATION_ID			= S.OPERATION_ID
				    AND A.ELTR_LN_TP_CD			= S.ELTR_LN_TP_CD
				    --AND A.MDL_NM				= S.NICK_NAME;
				    AND A.MDL_NM				= S.ITEM_ID
				LEFT JOIN #tbl_DAY_CNT_BASE DC ON
						A.DIVISION_ID		= DC.DIVISION_ID
					AND A.COMPANY_ID		= DC.COMPANY_ID
					AND A.SITE_ID			= DC.SITE_ID
					AND A.PLANT_ID			= DC.PLANT_ID
					AND A.FACTORY_ID		= DC.FACTORY_ID
					AND A.LINE_ID			= DC.LINE_ID
					AND A.OPERATION_ID		= DC.OPERATION_ID
					----AND A.ELTR_LN_TP_CD		= DC.ELTR_LN_TP_CD
					---AND A.YYYYMM			= DC.YYYYMM
        PRINT N'#tblSCP0106_RESULT_MDL_FINAL - Result, Base용 - END';

--TESTING:NOK
--select * from #tblSCP0106_RESULT_KEYS_MDL;
--select * from #tblSCP0106_RESULT_LN_TEMP;
--select * from #tblSCP0106_SPEED_PLAN_LN;
--select * from #tblSCP0106_RESULT_MDL_FINAL;rollback tran;return;



	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_FINAL') IS NOT NULL
		    DROP TABLE #tblSCP0106_RESULT_LN_FINAL;

        --빈테이블 생성
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.MDL_NM
			    , A.BM_RT
			    , A.CM_RT
			    , A.ID_RT
			    , A.MR_RT
			    , A.NM_RT
			    , A.PD_RT
			    , A.PM_RT
			    , A.PP_RT
			    , A.UD_RT
			    , A.OP_RT
			    , A.LD_RT
			    , A.QL_RT
			    , A.PFRSLT_AV_RT
			    , A.PFRSLT_PF_RT
			    , A.PFRSLT_TEEP
			    , A.PFRSLT_PROD_OP_RT
			    , A.BASE_AV_RT
			    , A.BASE_PF_RT
			    , A.BASE_TEEP
			    , A.BASE_PROD_OP_RT
        INTO    #tblSCP0106_RESULT_LN_FINAL
		FROM    #tblSCP0106_RESULT_MDL_FINAL A
        WHERE   1<>1

        INSERT INTO #tblSCP0106_RESULT_LN_FINAL
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , '-'                AS MDL_NM
			    , AVG(B.BM_RT)
			    , AVG(B.CM_RT)
			    , AVG(B.ID_RT)
			    , AVG(B.MR_RT)
			    , AVG(B.NM_RT)
			    , AVG(B.PD_RT)
			    , AVG(B.PM_RT)
			    , AVG(B.PP_RT)
			    , AVG(B.UD_RT)
			    , AVG(B.OP_RT)
			    , AVG(B.LD_RT)
			    , AVG(B.QL_RT)
			    , AVG(B.PFRSLT_AV_RT)
			    , AVG(B.PFRSLT_PF_RT)
			    , AVG(B.PFRSLT_TEEP)
			    , AVG(B.PFRSLT_PROD_OP_RT)
			    , AVG(B.BASE_AV_RT)
			    , AVG(B.BASE_PF_RT)
			    , AVG(B.BASE_TEEP)
			    , AVG(B.BASE_PROD_OP_RT)
		FROM    #tblSCP0106_RESULT_KEYS_LN A
                LEFT JOIN #tblSCP0106_RESULT_MDL_FINAL B ON
                        A.DIVISION_ID	= B.DIVISION_ID
                    AND A.COMPANY_ID	= B.COMPANY_ID	
                    AND A.SITE_ID	    = B.SITE_ID	  
                    AND A.PLANT_ID	    = B.PLANT_ID	  
                    AND A.FACTORY_ID	= B.FACTORY_ID	
                    AND A.LINE_ID       = B.LINE_ID     
        WHERE   1=1
        GROUP BY  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD

--TESTING:NOK
--select * from #tblSCP0106_RESULT_MDL_FINAL;
--select * from #tblSCP0106_RESULT_LN_FINAL;rollback tran;return;

--운영계획용 begin ###############################################################################################################################################################
        PRINT N'#tblSCP0106_RESULT_LN_YYYYMM_TEMP - 운영계획용 - BEGIN';
	    DECLARE @V_IG_BM_RT		NVARCHAR(1)		    = N'';
	    DECLARE @V_IG_CM_RT		NVARCHAR(1)		    = N'';
	    DECLARE @V_IG_ID_RT		NVARCHAR(1)		    = N'';
	    DECLARE @V_IG_MR_RT		NVARCHAR(1)		    = N'';
	    DECLARE @V_IG_NM_RT		NVARCHAR(1)		    = N'';
	    DECLARE @V_IG_PD_RT		NVARCHAR(1)		    = N'';
	    DECLARE @V_IG_PM_RT		NVARCHAR(1)		    = N'';
	    DECLARE @V_IG_PP_RT		NVARCHAR(1)		    = N'';
	    DECLARE @V_IG_UD_RT		NVARCHAR(1)		    = N'';
	    DECLARE @V_IG_QL_RT		NVARCHAR(1)		    = N'';

		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) START
        --SELECT @V_IG_BM_RT = IPRV_GOL_DIVS_CD FROM #tblSCP0106_CHECK_MEASURE WHERE LOSS_CD = 'BM_RT';
        --SELECT @V_IG_CM_RT = IPRV_GOL_DIVS_CD FROM #tblSCP0106_CHECK_MEASURE WHERE LOSS_CD = 'CM_RT';
        --SELECT @V_IG_ID_RT = IPRV_GOL_DIVS_CD FROM #tblSCP0106_CHECK_MEASURE WHERE LOSS_CD = 'ID_RT';
        --SELECT @V_IG_MR_RT = IPRV_GOL_DIVS_CD FROM #tblSCP0106_CHECK_MEASURE WHERE LOSS_CD = 'MR_RT';
        --SELECT @V_IG_NM_RT = IPRV_GOL_DIVS_CD FROM #tblSCP0106_CHECK_MEASURE WHERE LOSS_CD = 'NM_RT';
        --SELECT @V_IG_PD_RT = IPRV_GOL_DIVS_CD FROM #tblSCP0106_CHECK_MEASURE WHERE LOSS_CD = 'PD_RT';
        --SELECT @V_IG_PM_RT = IPRV_GOL_DIVS_CD FROM #tblSCP0106_CHECK_MEASURE WHERE LOSS_CD = 'PM_RT';
        --SELECT @V_IG_PP_RT = IPRV_GOL_DIVS_CD FROM #tblSCP0106_CHECK_MEASURE WHERE LOSS_CD = 'PP_RT';
        --SELECT @V_IG_UD_RT = IPRV_GOL_DIVS_CD FROM #tblSCP0106_CHECK_MEASURE WHERE LOSS_CD = 'UD_RT';
        --SELECT @V_IG_QL_RT = IPRV_GOL_DIVS_CD FROM #tblSCP0106_CHECK_MEASURE WHERE LOSS_CD = 'QL_RT';
		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) END



	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_TEMP1') IS NOT NULL
		    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_TEMP1;

        --빈테이블 생성
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , CONVERT(FLOAT, NULL)				AS BM_RT
			    , CONVERT(FLOAT, NULL)				AS CM_RT
			    , CONVERT(FLOAT, NULL)				AS ID_RT
			    , CONVERT(FLOAT, NULL)				AS MR_RT
			    , CONVERT(FLOAT, NULL)				AS NM_RT
			    , CONVERT(FLOAT, NULL)				AS PD_RT
			    , CONVERT(FLOAT, NULL)				AS PM_RT
			    , CONVERT(FLOAT, NULL)				AS PP_RT
			    , CONVERT(FLOAT, NULL)				AS UD_RT

			    , CONVERT(FLOAT, NULL)              AS AV_RT
			    , CONVERT(FLOAT, NULL)				AS PF_RT
			    , CONVERT(FLOAT, NULL)				AS QL_RT
        INTO    #tblSCP0106_RESULT_LN_YYYYMM_TEMP1
        FROM    #tblSCP0106_RESULT_KEYS_LN A
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_TEMP1
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD

				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) START
			    --, CONVERT(FLOAT, IIF(@V_IG_BM_RT = 'G', 0, ISNULL(BM_RT.LOSS_RT, 0)))	AS BM_RT
			    --, CONVERT(FLOAT, IIF(@V_IG_CM_RT = 'G', 0, ISNULL(CM_RT.LOSS_RT, 0)))	AS CM_RT
			    --, CONVERT(FLOAT, IIF(@V_IG_ID_RT = 'G', 0, ISNULL(ID_RT.LOSS_RT, 0)))	AS ID_RT
			    --, CONVERT(FLOAT, IIF(@V_IG_MR_RT = 'G', 0, ISNULL(MR_RT.LOSS_RT, 0)))	AS MR_RT
			    --, CONVERT(FLOAT, IIF(@V_IG_NM_RT = 'G', 0, ISNULL(NM_RT.LOSS_RT, 0)))	AS NM_RT
			    --, CONVERT(FLOAT, IIF(@V_IG_PD_RT = 'G', 0, ISNULL(PD_RT.LOSS_RT, 0)))	AS PD_RT
			    --, CONVERT(FLOAT, IIF(@V_IG_PM_RT = 'G', 0, ISNULL(PM_RT.LOSS_RT, 0)))	AS PM_RT
			    --, CONVERT(FLOAT, IIF(@V_IG_PP_RT = 'G', 0, ISNULL(PP_RT.LOSS_RT, 0)))	AS PP_RT
			    --, CONVERT(FLOAT, IIF(@V_IG_UD_RT = 'G', 0, ISNULL(UD_RT.LOSS_RT, 0)))	AS UD_RT
			    --, CONVERT(FLOAT, 1.0)                                                   AS AV_RT--Current 조업율 100
			    --, CONVERT(FLOAT, 1.0)										            AS PF_RT
			    --, CONVERT(FLOAT, IIF(@V_IG_QL_RT = 'G', 0, ISNULL(QL_RT.LOSS_RT, 0)))	AS QL_RT
				, CONVERT(FLOAT, 0)		AS BM_RT
			    , CONVERT(FLOAT, 0)		AS CM_RT
			    , CONVERT(FLOAT, 0)		AS ID_RT
			    , CONVERT(FLOAT, 0)		AS MR_RT
			    , CONVERT(FLOAT, 0)		AS NM_RT
			    , CONVERT(FLOAT, 0)		AS PD_RT
			    , CONVERT(FLOAT, 0)		AS PM_RT
			    , CONVERT(FLOAT, 0)		AS PP_RT
			    , CONVERT(FLOAT, 0)		AS UD_RT
			    , CONVERT(FLOAT, 1.0)	AS AV_RT--Current 조업율 100
			    , CONVERT(FLOAT, 1.0)	AS PF_RT
				, CONVERT(FLOAT, 0)		AS QL_RT
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) END
        FROM    #tblSCP0106_RESULT_KEYS_LN A
                    LEFT JOIN #tblSCP0106_RESULT_LN_YYYYMM_BM_RT BM_RT ON --BM
					        A.DIVISION_ID			= BM_RT.DIVISION_ID
				        AND A.COMPANY_ID			= BM_RT.COMPANY_ID
				        AND A.SITE_ID				= BM_RT.SITE_ID
				        AND A.PLANT_ID				= BM_RT.PLANT_ID
				        AND A.FACTORY_ID			= BM_RT.FACTORY_ID
				        AND A.LINE_ID				= BM_RT.LINE_ID
				        AND A.OPERATION_ID			= BM_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= BM_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= BM_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_YYYYMM_CM_RT CM_RT ON --CM
					        A.DIVISION_ID			= CM_RT.DIVISION_ID
				        AND A.COMPANY_ID			= CM_RT.COMPANY_ID
				        AND A.SITE_ID				= CM_RT.SITE_ID
				        AND A.PLANT_ID				= CM_RT.PLANT_ID
				        AND A.FACTORY_ID			= CM_RT.FACTORY_ID
				        AND A.LINE_ID				= CM_RT.LINE_ID
				        AND A.OPERATION_ID			= CM_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= CM_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= CM_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_YYYYMM_ID_RT ID_RT ON --Idle_LOB 설비대기
					        A.DIVISION_ID			= ID_RT.DIVISION_ID
				        AND A.COMPANY_ID			= ID_RT.COMPANY_ID
				        AND A.SITE_ID				= ID_RT.SITE_ID
				        AND A.PLANT_ID				= ID_RT.PLANT_ID
				        AND A.FACTORY_ID			= ID_RT.FACTORY_ID
				        AND A.LINE_ID				= ID_RT.LINE_ID
				        AND A.OPERATION_ID			= ID_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= ID_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= ID_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_YYYYMM_MR_RT MR_RT ON --재료교체
					        A.DIVISION_ID			= MR_RT.DIVISION_ID
				        AND A.COMPANY_ID			= MR_RT.COMPANY_ID
				        AND A.SITE_ID				= MR_RT.SITE_ID
				        AND A.PLANT_ID				= MR_RT.PLANT_ID
				        AND A.FACTORY_ID			= MR_RT.FACTORY_ID
				        AND A.LINE_ID				= MR_RT.LINE_ID
				        AND A.OPERATION_ID			= MR_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= MR_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= MR_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_YYYYMM_NM_RT NM_RT ON --원자재 품절
					        A.DIVISION_ID			= NM_RT.DIVISION_ID
				        AND A.COMPANY_ID			= NM_RT.COMPANY_ID
				        AND A.SITE_ID				= NM_RT.SITE_ID
				        AND A.PLANT_ID				= NM_RT.PLANT_ID
				        AND A.FACTORY_ID			= NM_RT.FACTORY_ID
				        AND A.LINE_ID				= NM_RT.LINE_ID
				        AND A.OPERATION_ID			= NM_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= NM_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= NM_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_YYYYMM_PD_RT PD_RT ON --PD
					        A.DIVISION_ID			= PD_RT.DIVISION_ID
				        AND A.COMPANY_ID			= PD_RT.COMPANY_ID
				        AND A.SITE_ID				= PD_RT.SITE_ID
				        AND A.PLANT_ID				= PD_RT.PLANT_ID
				        AND A.FACTORY_ID			= PD_RT.FACTORY_ID
				        AND A.LINE_ID				= PD_RT.LINE_ID
				        AND A.OPERATION_ID			= PD_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= PD_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= PD_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_YYYYMM_PF_RT PF_RT ON --성능가동률
					        A.DIVISION_ID			= PF_RT.DIVISION_ID
				        AND A.COMPANY_ID			= PF_RT.COMPANY_ID
				        AND A.SITE_ID				= PF_RT.SITE_ID
				        AND A.PLANT_ID				= PF_RT.PLANT_ID
				        AND A.FACTORY_ID			= PF_RT.FACTORY_ID
				        AND A.LINE_ID				= PF_RT.LINE_ID
				        AND A.OPERATION_ID			= PF_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= PF_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= PF_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_YYYYMM_PM_RT PM_RT ON --PM
					        A.DIVISION_ID			= PM_RT.DIVISION_ID
				        AND A.COMPANY_ID			= PM_RT.COMPANY_ID
				        AND A.SITE_ID				= PM_RT.SITE_ID
				        AND A.PLANT_ID				= PM_RT.PLANT_ID
				        AND A.FACTORY_ID			= PM_RT.FACTORY_ID
				        AND A.LINE_ID				= PM_RT.LINE_ID
				        AND A.OPERATION_ID			= PM_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= PM_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= PM_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_YYYYMM_PP_RT PP_RT ON --생산준비
					        A.DIVISION_ID			= PP_RT.DIVISION_ID
				        AND A.COMPANY_ID			= PP_RT.COMPANY_ID
				        AND A.SITE_ID				= PP_RT.SITE_ID
				        AND A.PLANT_ID				= PP_RT.PLANT_ID
				        AND A.FACTORY_ID			= PP_RT.FACTORY_ID
				        AND A.LINE_ID				= PP_RT.LINE_ID
				        AND A.OPERATION_ID			= PP_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= PP_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= PP_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_YYYYMM_AV_RT AV_RT ON --AV
					        A.DIVISION_ID			= AV_RT.DIVISION_ID
				        AND A.COMPANY_ID			= AV_RT.COMPANY_ID
				        AND A.SITE_ID				= AV_RT.SITE_ID
				        AND A.PLANT_ID				= AV_RT.PLANT_ID
				        AND A.FACTORY_ID			= AV_RT.FACTORY_ID
				        AND A.LINE_ID				= AV_RT.LINE_ID
				        AND A.OPERATION_ID			= AV_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= AV_RT.ELTR_LN_TP_CD
                    LEFT JOIN #tblSCP0106_RESULT_LN_YYYYMM_QL_RT QL_RT ON --양품가동률
					        A.DIVISION_ID			= QL_RT.DIVISION_ID
				        AND A.COMPANY_ID			= QL_RT.COMPANY_ID
				        AND A.SITE_ID				= QL_RT.SITE_ID
				        AND A.PLANT_ID				= QL_RT.PLANT_ID
				        AND A.FACTORY_ID			= QL_RT.FACTORY_ID
				        AND A.LINE_ID				= QL_RT.LINE_ID
				        AND A.OPERATION_ID			= QL_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= QL_RT.ELTR_LN_TP_CD
				        ----AND A.MDL_NM				= QL_RT.MDL_NM
                    LEFT JOIN #tblSCP0106_RESULT_LN_YYYYMM_UD_RT UD_RT ON --UT Down
					        A.DIVISION_ID			= UD_RT.DIVISION_ID
				        AND A.COMPANY_ID			= UD_RT.COMPANY_ID
				        AND A.SITE_ID				= UD_RT.SITE_ID
				        AND A.PLANT_ID				= UD_RT.PLANT_ID
				        AND A.FACTORY_ID			= UD_RT.FACTORY_ID
				        AND A.LINE_ID				= UD_RT.LINE_ID
				        AND A.OPERATION_ID			= UD_RT.OPERATION_ID
				        AND A.ELTR_LN_TP_CD			= UD_RT.ELTR_LN_TP_CD
				        --AND A.MDL_NM				= UD_RT.MDL_NM


	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_TEMP') IS NOT NULL
		    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_TEMP;

        --빈테이블 생성
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , CONVERT(FLOAT, NULL)				AS BM_RT
			    , CONVERT(FLOAT, NULL)				AS CM_RT
			    , CONVERT(FLOAT, NULL)				AS ID_RT
			    , CONVERT(FLOAT, NULL)				AS MR_RT
			    , CONVERT(FLOAT, NULL)				AS NM_RT
			    , CONVERT(FLOAT, NULL)				AS PD_RT
			    , CONVERT(FLOAT, NULL)				AS PM_RT
			    , CONVERT(FLOAT, NULL)				AS PP_RT
			    , CONVERT(FLOAT, NULL)				AS UD_RT

                , CONVERT(FLOAT, NULL)				AS OP_RT
			    , CONVERT(FLOAT, NULL)				AS LD_RT
			    , CONVERT(FLOAT, NULL)              AS AV_RT
			    , CONVERT(FLOAT, NULL)				AS PF_RT
			    , CONVERT(FLOAT, NULL)				AS QL_RT
        INTO    #tblSCP0106_RESULT_LN_YYYYMM_TEMP
        FROM    #tblSCP0106_RESULT_KEYS_LN A
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_TEMP
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.BM_RT
			    , A.CM_RT
			    , A.ID_RT
			    , A.MR_RT
			    , A.NM_RT
			    , A.PD_RT
			    , A.PM_RT
			    , A.PP_RT
			    , A.UD_RT

                , CONVERT(FLOAT, (1.0 - (A.BM_RT + A.CM_RT + A.PD_RT + A.PM_RT + A.UD_RT + A.PP_RT + A.MR_RT)))	AS OP_RT
			    , CONVERT(FLOAT, (1.0 - (A.ID_RT + A.NM_RT)))		                                            AS LD_RT
			    , CONVERT(FLOAT, 1.0)                                                                           AS AV_RT--Current 조업율 100
			    , CONVERT(FLOAT, 1.0)																			AS PF_RT
			    , CONVERT(FLOAT, A.QL_RT)																	    AS QL_RT
        FROM    #tblSCP0106_RESULT_LN_YYYYMM_TEMP1 A

        PRINT N'#tblSCP0106_RESULT_LN_YYYYMM_TEMP - 운영계획용 - END';

--TESTING:NOK
--select * from #tblSCP0106_RESULT_KEYS_MDL;
----select * from #tblSCP0106_RESULT_LN_YYYYMM_QL_RT;
--select * from #tblSCP0106_RESULT_LN_YYYYMM_MR_RT;
--select * from #tblSCP0106_RESULT_LN_YYYYMM_TEMP;return;


        PRINT N'#tblSCP0106_RESULT_MDL_YYYYMM_FINAL - 운영계획용 - BEGIN';
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_MDL_YYYYMM_FINAL') IS NOT NULL
		    DROP TABLE #tblSCP0106_RESULT_MDL_YYYYMM_FINAL;

        --빈테이블 생성
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.MDL_NM
                , A.YYYYMM
                , CONVERT(FLOAT, NULL)			AS DAY_CNT

			    , CONVERT(FLOAT, NULL)			AS BM_RT
			    , CONVERT(FLOAT, NULL)			AS CM_RT
			    , CONVERT(FLOAT, NULL)			AS ID_RT
			    , CONVERT(FLOAT, NULL)			AS MR_RT
			    , CONVERT(FLOAT, NULL)			AS NM_RT
			    , CONVERT(FLOAT, NULL)			AS PD_RT
			    , CONVERT(FLOAT, NULL)			AS PM_RT
			    , CONVERT(FLOAT, NULL)			AS PP_RT
			    , CONVERT(FLOAT, NULL)			AS UD_RT

			    , CONVERT(FLOAT, NULL)			AS OP_RT
			    , CONVERT(FLOAT, NULL)			AS LD_RT
			    , CONVERT(FLOAT, NULL)			AS QL_RT

			    , CONVERT(FLOAT, NULL)			AS PFRSLT_AV_RT
			    , CONVERT(FLOAT, NULL)			AS PFRSLT_PF_RT
			    , CONVERT(FLOAT, NULL)			AS PFRSLT_TEEP
			    , CONVERT(FLOAT, NULL)			AS PFRSLT_PROD_OP_RT
			    , CONVERT(FLOAT, NULL)			AS PFRSLT_THRY_CAPA_D
                , CONVERT(FLOAT, NULL)			AS PFRSLT_PROD_CAPA_D
                , CONVERT(FLOAT, NULL)			AS PFRSLT_PROD_CAPA_M
                , CONVERT(FLOAT, NULL)			AS PFRSLT_PPM

			    , CONVERT(FLOAT, NULL)			AS BASE_AV_RT
			    , CONVERT(FLOAT, NULL)			AS BASE_PF_RT
			    , CONVERT(FLOAT, NULL)			AS BASE_TEEP
			    , CONVERT(FLOAT, NULL)			AS BASE_PROD_OP_RT
			    , CONVERT(FLOAT, NULL)			AS BASE_THRY_CAPA_D
                , CONVERT(FLOAT, NULL)			AS BASE_PROD_CAPA_D
				, CONVERT(FLOAT, NULL)			AS BASE_PROD_CAPA_M
                , CONVERT(FLOAT, NULL)			AS BASE_PPM
	    INTO	#tblSCP0106_RESULT_MDL_YYYYMM_FINAL
        FROM    #tblSCP0106_YYYYMM_KEYS_MDL A
	    WHERE	1<>1;

	    INSERT INTO #tblSCP0106_RESULT_MDL_YYYYMM_FINAL
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.MDL_NM
                , A.YYYYMM
			    , CASE
					WHEN ISNULL(DC.DAY_CNT, 0) = 0 THEN                                                                     -- 월별 & SOP 없을때
                        CASE
                            WHEN LEN(A.YYYYMM) = 6 THEN DAY(EOMONTH(CONVERT(DATE, A.YYYYMM + '01')))                        --YYYYMM 이 월별
                            ELSE DATEDIFF(DAY, CAST(A.YYYYMM AS VARCHAR) + '0101', CAST(A.YYYYMM AS VARCHAR) + '1231') + 1  --YYYYMM 이 연도별
                        END 
					ELSE DC.DAY_CNT                                                                                         -- 월별 & SOP 존재
                  END AS DAY_CNT

			    , B.BM_RT
			    , B.CM_RT
			    , B.ID_RT
			    , B.MR_RT
			    , B.NM_RT
			    , B.PD_RT
			    , B.PM_RT
			    , B.PP_RT
			    , B.UD_RT

			    , B.OP_RT
			    , B.LD_RT
			    , B.QL_RT

			    , B.AV_RT                                                                                                                                   AS PFRSLT_AV_RT
			    , B.PF_RT                                                                                                                                   AS PFRSLT_PF_RT
			    , (B.AV_RT * B.LD_RT * B.OP_RT * B.PF_RT * B.QL_RT)	                                                                                        AS PFRSLT_TEEP
			    , (B.LD_RT * B.OP_RT * B.PF_RT * B.QL_RT)							                                                                        AS PFRSLT_PROD_OP_RT
			    , IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.PFRSLT_PPM * 1440.0)														                    AS PFRSLT_THRY_CAPA_D
                , IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.PFRSLT_PPM * 1440.0) * (B.LD_RT * B.OP_RT  * B.PF_RT  * B.QL_RT)						        AS PFRSLT_PROD_CAPA_D
                ------, IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.PFRSLT_PPM * 1440.0) * (B.LD_RT * B.OP_RT  * B.PF_RT  * B.QL_RT) * @v_result_day_cnt * B.AV_RT	AS PFRSLT_PROD_CAPA_M
                , IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.PFRSLT_PPM * 1440.0) * (B.LD_RT * B.OP_RT  * B.PF_RT  * B.QL_RT) * @v_result_day_cnt        	AS PFRSLT_PROD_CAPA_M
                , S.PFRSLT_PPM

			    , CONVERT(FLOAT, 1.0)                                                                                                                       AS BASE_AV_RT
			    , CONVERT(FLOAT, 1.0)                                                                                                                       AS BASE_PF_RT
			    , (1.0 * B.LD_RT * B.OP_RT * 1.0 * B.QL_RT)	                                                                                                AS BASE_TEEP
			    , (B.LD_RT * B.OP_RT * 1.0 * B.QL_RT)							                                                                            AS BASE_PROD_OP_RT
			    , IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.BASE_PPM * 1440.0)														                        AS BASE_THRY_CAPA_D
                , IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.BASE_PPM * 1440.0) * (B.LD_RT * B.OP_RT  * 1.0 * B.QL_RT)						                AS BASE_PROD_CAPA_D
                , IIF(A.ELTR_LN_TP_CD = 'W', 2.0, 1.0) * (S.BASE_PPM * 1440.0) * (B.LD_RT * B.OP_RT  * 1.0 * B.QL_RT) * 
					CASE
						------운영계획은 자기 월에 해당하는 날수 적용!!! WHEN DC.DIVISION_ID IS NULL THEN DAY(EOMONTH(CONVERT(DATE, @p_version + '01')))                              -- 월별 & SOP 없을때
                        WHEN LEN(A.YYYYMM) = 4 THEN
					        CASE
						        WHEN DY.DIVISION_ID IS NULL THEN DATEDIFF(DAY, SUBSTRING(A.YYYYMM, 1, 4) + '0101', SUBSTRING(A.YYYYMM, 1, 4) + '1231') + 1   -- 연도별 & SOP 없을때
						        ELSE DY.DAY_CNT                                                                                                                 -- 연도별 & SOP 존재
					        END
                        ELSE 
					        CASE
						        WHEN DC.DIVISION_ID IS NULL THEN DAY(EOMONTH(CONVERT(DATE, A.YYYYMM + '01')))                                -- 월별 & SOP 없을때
						        ELSE DC.DAY_CNT                                                                                                 -- 월별 & SOP 존재
					        END
					END
                   ------* B.AV_RT
                                                                                                                                                            AS BASE_PROD_CAPA_M
                , S.BASE_PPM
        FROM    #tblSCP0106_YYYYMM_KEYS_MDL A
                LEFT JOIN #tblSCP0106_RESULT_LN_YYYYMM_TEMP B ON
					    A.DIVISION_ID			= B.DIVISION_ID
				    AND A.COMPANY_ID			= B.COMPANY_ID
				    AND A.SITE_ID				= B.SITE_ID
				    AND A.PLANT_ID				= B.PLANT_ID
				    AND A.FACTORY_ID			= B.FACTORY_ID
				    AND A.LINE_ID				= B.LINE_ID
				    AND A.OPERATION_ID			= B.OPERATION_ID
				    AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
				    --AND A.MDL_NM				= B.MDL_NM
                LEFT JOIN #tblSCP0106_SPEED_PLAN S ON
                        A.DIVISION_ID			= S.DIVISION_ID
				    AND A.COMPANY_ID			= S.COMPANY_ID
				    AND A.SITE_ID				= S.SITE_ID
				    AND A.PLANT_ID				= S.PLANT_ID
				    AND A.FACTORY_ID			= S.FACTORY_ID
				    AND A.LINE_ID				= S.LINE_ID
				    AND A.OPERATION_ID			= S.OPERATION_ID
				    AND A.ELTR_LN_TP_CD			= S.ELTR_LN_TP_CD
				    --AND A.MDL_NM				= S.NICK_NAME;
				    AND A.MDL_NM				= S.ITEM_ID
				LEFT JOIN #tbl_DAY_CNT_YYYYMM DC ON
						A.DIVISION_ID		    = DC.DIVISION_ID
					AND A.COMPANY_ID		    = DC.COMPANY_ID
					AND A.SITE_ID			    = DC.SITE_ID
					AND A.PLANT_ID			    = DC.PLANT_ID
					AND A.FACTORY_ID		    = DC.FACTORY_ID
					AND A.LINE_ID			    = DC.LINE_ID
					AND A.OPERATION_ID		    = DC.OPERATION_ID
					----AND A.ELTR_LN_TP_CD	    	= DC.ELTR_LN_TP_CD
					AND A.YYYYMM		    	= DC.YYYYMM
				LEFT JOIN #tbl_DAY_CNT_YYYYMM_YEAR DY ON
						A.DIVISION_ID		= DY.DIVISION_ID
					AND A.COMPANY_ID		= DY.COMPANY_ID
					AND A.SITE_ID			= DY.SITE_ID
					AND A.PLANT_ID			= DY.PLANT_ID
					AND A.FACTORY_ID		= DY.FACTORY_ID
					AND A.LINE_ID			= DY.LINE_ID
					AND A.OPERATION_ID		= DY.OPERATION_ID
					AND A.ELTR_LN_TP_CD		= DY.ELTR_LN_TP_CD
					AND A.YYYYMM			= DY.YYYY
        PRINT N'#tblSCP0106_RESULT_MDL_YYYYMM_FINAL - 운영계획용 - END';

--TESTING:NOK
--select * from #tblSCP0106_RESULT_KEYS_MDL;
--select * from #tblSCP0106_RESULT_LN_YYYYMM_TEMP;
--select * from #tblSCP0106_SPEED_PLAN_LN;rollback tran;return;
--select * from #tblSCP0106_RESULT_MDL_YYYYMM_FINAL;rollback tran;return;


	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_FINAL') IS NOT NULL
		    DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_FINAL;

        --빈테이블 생성
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.MDL_NM
			    , A.BM_RT
			    , A.CM_RT
			    , A.ID_RT
			    , A.MR_RT
			    , A.NM_RT
			    , A.PD_RT
			    , A.PM_RT
			    , A.PP_RT
			    , A.UD_RT
			    , A.OP_RT
			    , A.LD_RT
			    , A.QL_RT
			    , A.PFRSLT_AV_RT
			    , A.PFRSLT_PF_RT
			    , A.PFRSLT_TEEP
			    , A.PFRSLT_PROD_OP_RT
			    , A.BASE_AV_RT
			    , A.BASE_PF_RT
			    , A.BASE_TEEP
			    , A.BASE_PROD_OP_RT
        INTO    #tblSCP0106_RESULT_LN_YYYYMM_FINAL
		FROM    #tblSCP0106_RESULT_MDL_YYYYMM_FINAL A
        WHERE   1<>1

        INSERT INTO #tblSCP0106_RESULT_LN_YYYYMM_FINAL
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , '-'                AS MDL_NM
			    , AVG(B.BM_RT)
			    , AVG(B.CM_RT)
			    , AVG(B.ID_RT)
			    , AVG(B.MR_RT)
			    , AVG(B.NM_RT)
			    , AVG(B.PD_RT)
			    , AVG(B.PM_RT)
			    , AVG(B.PP_RT)
			    , AVG(B.UD_RT)
			    , AVG(B.OP_RT)
			    , AVG(B.LD_RT)
			    , AVG(B.QL_RT)
			    , AVG(B.PFRSLT_AV_RT)
			    , AVG(B.PFRSLT_PF_RT)
			    , AVG(B.PFRSLT_TEEP)
			    , AVG(B.PFRSLT_PROD_OP_RT)
			    , AVG(B.BASE_AV_RT)
			    , AVG(B.BASE_PF_RT)
			    , AVG(B.BASE_TEEP)
			    , AVG(B.BASE_PROD_OP_RT)
		FROM    #tblSCP0106_RESULT_KEYS_LN A
                LEFT JOIN #tblSCP0106_RESULT_MDL_YYYYMM_FINAL B ON
                        A.DIVISION_ID	= B.DIVISION_ID
                    AND A.COMPANY_ID	= B.COMPANY_ID	
                    AND A.SITE_ID	    = B.SITE_ID	  
                    AND A.PLANT_ID	    = B.PLANT_ID	  
                    AND A.FACTORY_ID	= B.FACTORY_ID	
                    AND A.LINE_ID       = B.LINE_ID     
        WHERE   1=1
        GROUP BY  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD

--TESTING:NOK
--select * from #tblSCP0106_RESULT_MDL_YYYYMM_FINAL;
--select * from #tblSCP0106_RESULT_LN_YYYYMM_FINAL;rollback tran;return;

--운영계획용 end ###############################################################################################################################################################



    END
    PRINT N'GET - RESULT - END';


    BEGIN
        PRINT N'GET - KEYS - BEGIN';
	    IF OBJECT_ID('tempdb..#tblSCP0106_MEASURE_ALL') IS NOT NULL
			DROP TABLE #tblSCP0106_MEASURE_ALL;

        --빈테이블 생성
        SELECT    A.ATTRIBUTE3        AS LOSS_GR_CD
                , A.SEGMENT1          AS LOSS_CD
                , A.ATTRIBUTE6        AS LOSS_GR_NM_KO
                , A.ATTRIBUTE7        AS LOSS_GR_NM_EN
                , A.ATTRIBUTE4        AS LOSS_NM_KO
                , A.ATTRIBUTE5        AS LOSS_NM_EN
                , A.ATTRIBUTE8        AS TARGET_YN
                , A.DISPLAY_SEQ

				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) START
                --, A.ATTRIBUTE10			AS IPRV_GOL_TP
                --, A.ATTRIBUTE11			AS IPRV_GOL_TP_NM_EN
                --, A.ATTRIBUTE12			AS IPRV_GOL_TP_NM_KO
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) END

        INTO    #tblSCP0106_MEASURE_ALL
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1<>1;

--TESTING : NOK
--select * from #tblSCP0106_MEASURE_ALL;return;

        INSERT INTO #tblSCP0106_MEASURE_ALL
        SELECT    A.ATTRIBUTE3        AS LOSS_GR_CD
                , A.SEGMENT1          AS LOSS_CD
                , A.ATTRIBUTE6        AS LOSS_GR_NM_KO
                , A.ATTRIBUTE7        AS LOSS_GR_NM_EN
                , A.ATTRIBUTE4        AS LOSS_NM_KO
                , A.ATTRIBUTE5        AS LOSS_NM_EN
                , CASE
                    WHEN @p_sheet_name = 'CUTOFF_MODEL'             THEN A.ATTRIBUTE8   --MODEL_TARGET_YN
                    WHEN @p_sheet_name = 'CUTOFF_MODEL_ELTR'        THEN A.ATTRIBUTE8   --MODEL_TARGET_YN
                    WHEN @p_sheet_name = '1ST_CUTOFF_LINE'          THEN A.ATTRIBUTE14  --1ST_LINE_TARGET_YN
                    WHEN @p_sheet_name = '1ST_CUTOFF_LINE_ELTR'     THEN A.ATTRIBUTE14  --1ST_LINE_TARGET_YN
                    WHEN @p_sheet_name = '2ND_CUTOFF_LINE'          THEN A.ATTRIBUTE9   --2ND_LINE_TARGET_YN
                    WHEN @p_sheet_name = '2ND_CUTOFF_LINE_ELTR'     THEN A.ATTRIBUTE9   --2ND_LINE_TARGET_YN
                    ELSE A.ATTRIBUTE13                                                  --CURRENT_TARGET_YN
                  END AS TARGET_YN
                , A.DISPLAY_SEQ

				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) START
                --, A.ATTRIBUTE10			AS IPRV_GOL_TP
                --, A.ATTRIBUTE11			AS IPRV_GOL_TP_NM_EN
                --, A.ATTRIBUTE12			AS IPRV_GOL_TP_NM_KO
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) END

        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1=1
            AND A.LOOKUP_TYPE  = 'SCP_CAPA_ELTR_LOSS_MEASURE'
            AND A.VALID_YN  = 'Y';

--TESTING : NOK
--select * from #tblSCP0106_MEASURE_ALL;return;

		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) START
		/*
	    IF OBJECT_ID('tempdb..#tblSCP0106_IPRV') IS NOT NULL
			DROP TABLE #tblSCP0106_IPRV;

        --빈테이블 생성
        SELECT    A.IPRV_GOL_TP
                , A.IPRV_GOL_TP_NM_EN
                , A.IPRV_GOL_TP_NM_KO
        INTO    #tblSCP0106_IPRV
        FROM    #tblSCP0106_MEASURE_ALL A
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_IPRV
        SELECT DISTINCT
				  A.IPRV_GOL_TP
                , A.IPRV_GOL_TP_NM_EN
                , A.IPRV_GOL_TP_NM_KO
        FROM    #tblSCP0106_MEASURE_ALL A
        WHERE   1=1
			AND ISNULL(A.IPRV_GOL_TP, '') <> ''


--TESTING : NOK
--select * from #tblSCP0106_IPRV;rollback tran;return;


		DECLARE @v_iprv_gol_tp_g_name		NVARCHAR(100) = '';
		DECLARE @v_iprv_gol_tp_i_name		NVARCHAR(100) = '';

        SELECT    @v_iprv_gol_tp_g_name = A.IPRV_GOL_TP_NM_EN
        FROM    #tblSCP0106_IPRV A
        WHERE   1=1
			AND A.IPRV_GOL_TP = 'G'

        SELECT    @v_iprv_gol_tp_i_name = A.IPRV_GOL_TP_NM_EN
        FROM    #tblSCP0106_IPRV A
        WHERE   1=1
			AND A.IPRV_GOL_TP = 'I'

        PRINT CONCAT('@v_iprv_gol_tp_g_name : ', @v_iprv_gol_tp_g_name);
        PRINT CONCAT('@v_iprv_gol_tp_i_name : ', @v_iprv_gol_tp_i_name);
        --rollback tran;return;
		*/
		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) END


    	IF OBJECT_ID('tempdb..#tblSCP0106_CHECK_RAW_KEYS') IS NOT NULL
			DROP TABLE #tblSCP0106_CHECK_RAW_KEYS;

        --빈테이블 생성
		SELECT	  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.MSR_GR_CD
				, A.MSR_TP_CD
                --, A.IPRV_GOL_DIVS_CD
                --, CONVERT(NVARCHAR(30), NULL)        AS IPRV_GOL_DIVS_NM	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                --, P.PLAN_TP
                --, P.PLAN_TP_NM
				, A.YYYYMM
        INTO    #tblSCP0106_CHECK_RAW_KEYS
        FROM    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF A WITH(NOLOCK)
                JOIN #tblSCP0106_CHECK_PLAN_TP P ON
                    1=1
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_CHECK_RAW_KEYS
		SELECT	  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.MSR_GR_CD
				, A.MSR_TP_CD
                --, MAX(A.IPRV_GOL_DIVS_CD)
                --, MAX(A.IPRV_GOL_DIVS_NM)	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				, A.YYYYMM
         FROM   (
		            SELECT	  @p_version							        AS VER_ID
				            , @p_version_seq                                AS VER_SEQ
				            , A.DIVISION_ID                                 AS DIVISION_ID
				            , CASE
                                WHEN M.MSR_TP_CD NOT IN (
                                                            'PROD_CAPA_D'
                                                          , 'PROD_CAPA_M'
                                                          , 'THRY_CAPA_D'
                                                        ) THEN '-'
                                ELSE A.ITEM_ID
                              END                                           AS MDL_NM
				            , A.PLANT_ID
				            , A.LINE_ID
				            , A.OPERATION_ID
				            , A.ELTR_LN_TP_CD
				            , A.COMPANY_ID
				            , A.SITE_ID
				            , A.FACTORY_ID
				            , M.MSR_GR_CD
				            , M.MSR_TP_CD
                            --, M.IPRV_GOL_DIVS_CD                           AS IPRV_GOL_DIVS_CD
                            --, I.IPRV_GOL_TP_NM_EN                          AS IPRV_GOL_DIVS_NM	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                            --, P.PLAN_TP
                            --, P.PLAN_TP_NM
				            , A.YYYYMM
                    FROM    @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN A
                            JOIN #tblSCP0106_CHECK_MEASURE_CURRENT M ON 1=1
                        --LEFT JOIN #tblSCP0106_IPRV I ON
                        --            M.IPRV_GOL_DIVS_CD  = I.IPRV_GOL_TP	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                    WHERE   1=1
                ) A
        GROUP BY  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.MSR_GR_CD
				, A.MSR_TP_CD
                --, A.IPRV_GOL_DIVS_CD
                --, A.IPRV_GOL_DIVS_NM
				, A.YYYYMM
                 

--TESTING : NOK
--select * from #tblSCP0106_CHECK_RAW_KEYS WHERE YYYYMM = '202409';rollback tran;return;
--select * from #tblSCP0106_CHECK_RAW_KEYS WHERE MSR_TP_CD = 'BM_RT' AND YYYYMM = '202409';rollback tran;return;
--select * from #tblSCP0106_CHECK_RAW_KEYS;rollback tran;return;
        PRINT N'GET - KEYS - END';


        PRINT N'GET - RAW - BEGIN';
    	IF OBJECT_ID('tempdb..#tblSCP0106_CHECK_RAW_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0106_CHECK_RAW_TEMP;

        --빈테이블 생성
        SELECT    A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.MSR_TP_CD
				, A.YYYYMM
				, A.PFRSLT_NVL
				, A.BASE_NVL
				--, A.IPRV_GOL_DIVS_CD
				--, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				, A.MSR_GR_CD
				, A.MSR_NVL
				, A.MSR_DDN
        INTO    #tblSCP0106_CHECK_RAW_TEMP
        FROM    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL_CUTF A WITH(NOLOCK)
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_CHECK_RAW_TEMP
        SELECT    A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.MSR_TP_CD
				, A.YYYYMM
                , CASE
                    WHEN A.MSR_TP_CD = 'BM_RT'				THEN RL.BM_RT
                    WHEN A.MSR_TP_CD = 'CM_RT'				THEN RL.CM_RT
                    WHEN A.MSR_TP_CD = 'ID_RT'				THEN RL.ID_RT
                    WHEN A.MSR_TP_CD = 'MR_RT'				THEN RL.MR_RT
                    WHEN A.MSR_TP_CD = 'NM_RT'				THEN RL.NM_RT
                    WHEN A.MSR_TP_CD = 'PD_RT'				THEN RL.PD_RT
                    WHEN A.MSR_TP_CD = 'PM_RT'				THEN RL.PM_RT
                    WHEN A.MSR_TP_CD = 'PP_RT'				THEN RL.PP_RT
                    WHEN A.MSR_TP_CD = 'UD_RT'				THEN RL.UD_RT

                    WHEN A.MSR_TP_CD = 'OP_RT'				THEN RL.OP_RT
                    WHEN A.MSR_TP_CD = 'LD_RT'				THEN RL.LD_RT
                    WHEN A.MSR_TP_CD = 'AV_RT'				THEN RL.PFRSLT_AV_RT
                    WHEN A.MSR_TP_CD = 'PF_RT'				THEN RL.PFRSLT_PF_RT
                    WHEN A.MSR_TP_CD = 'QL_RT'				THEN RL.QL_RT

                    WHEN A.MSR_TP_CD = 'TEEP'				THEN RL.PFRSLT_TEEP
                    WHEN A.MSR_TP_CD = 'PROD_OP_RT'			THEN RL.PFRSLT_PROD_OP_RT

                    WHEN A.MSR_TP_CD = 'THRY_CAPA_D'	    THEN RM.PFRSLT_THRY_CAPA_D
                    WHEN A.MSR_TP_CD = 'PROD_CAPA_D'		THEN RM.PFRSLT_PROD_CAPA_D
                    WHEN A.MSR_TP_CD = 'PROD_CAPA_M'		THEN RM.PFRSLT_PROD_CAPA_M
                    ELSE
                        CONVERT(FLOAT, NULL)
                    END                                   AS PFRSLT_NVL
                , CASE
                    WHEN A.MSR_TP_CD = 'BM_RT'				THEN RL.BM_RT
                    WHEN A.MSR_TP_CD = 'CM_RT'				THEN RL.CM_RT
                    WHEN A.MSR_TP_CD = 'ID_RT'				THEN RL.ID_RT
                    WHEN A.MSR_TP_CD = 'MR_RT'				THEN RL.MR_RT
                    WHEN A.MSR_TP_CD = 'NM_RT'				THEN RL.NM_RT
                    WHEN A.MSR_TP_CD = 'PD_RT'				THEN RL.PD_RT
                    WHEN A.MSR_TP_CD = 'PM_RT'				THEN RL.PM_RT
                    WHEN A.MSR_TP_CD = 'PP_RT'				THEN RL.PP_RT
                    WHEN A.MSR_TP_CD = 'UD_RT'				THEN RL.UD_RT

                    WHEN A.MSR_TP_CD = 'OP_RT'				THEN RL.OP_RT
                    WHEN A.MSR_TP_CD = 'LD_RT'				THEN RL.LD_RT
                    WHEN A.MSR_TP_CD = 'AV_RT'				THEN RL.BASE_AV_RT
                    WHEN A.MSR_TP_CD = 'PF_RT'				THEN RL.BASE_PF_RT
                    WHEN A.MSR_TP_CD = 'QL_RT'				THEN RL.QL_RT

                    WHEN A.MSR_TP_CD = 'TEEP'				THEN RL.BASE_TEEP
                    WHEN A.MSR_TP_CD = 'PROD_OP_RT'			THEN RL.BASE_PROD_OP_RT

                    WHEN A.MSR_TP_CD = 'THRY_CAPA_D'	    THEN RM.BASE_THRY_CAPA_D
                    WHEN A.MSR_TP_CD = 'PROD_CAPA_D'		THEN RM.BASE_PROD_CAPA_D
                    WHEN A.MSR_TP_CD = 'PROD_CAPA_M'		THEN RM.BASE_PROD_CAPA_M
                    ELSE
                        CONVERT(FLOAT, NULL)
                 END AS BASE_NVL
				--, A.IPRV_GOL_DIVS_CD
				--, L.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				, A.MSR_GR_CD
--?????				, L.MSR_NVL
                , CASE
                    WHEN A.MSR_TP_CD = 'BM_RT'				THEN OL.BM_RT
                    WHEN A.MSR_TP_CD = 'CM_RT'				THEN OL.CM_RT
                    WHEN A.MSR_TP_CD = 'ID_RT'				THEN OL.ID_RT
                    WHEN A.MSR_TP_CD = 'MR_RT'				THEN OL.MR_RT
                    WHEN A.MSR_TP_CD = 'NM_RT'				THEN OL.NM_RT
                    WHEN A.MSR_TP_CD = 'PD_RT'				THEN OL.PD_RT
                    WHEN A.MSR_TP_CD = 'PM_RT'				THEN OL.PM_RT
                    WHEN A.MSR_TP_CD = 'PP_RT'				THEN OL.PP_RT
                    WHEN A.MSR_TP_CD = 'UD_RT'				THEN OL.UD_RT

                    WHEN A.MSR_TP_CD = 'OP_RT'				THEN OL.OP_RT
                    WHEN A.MSR_TP_CD = 'LD_RT'				THEN OL.LD_RT
                    WHEN A.MSR_TP_CD = 'AV_RT'				THEN RL.BASE_AV_RT
                    WHEN A.MSR_TP_CD = 'PF_RT'				THEN RL.BASE_PF_RT
                    WHEN A.MSR_TP_CD = 'QL_RT'				THEN OL.QL_RT

                    WHEN A.MSR_TP_CD = 'TEEP'				THEN OL.BASE_TEEP
                    WHEN A.MSR_TP_CD = 'PROD_OP_RT'			THEN OL.BASE_PROD_OP_RT
                    
                    WHEN A.MSR_TP_CD = 'THRY_CAPA_D'	    THEN OM.BASE_THRY_CAPA_D --운영계획 CAPA 는 BASE
                    WHEN A.MSR_TP_CD = 'PROD_CAPA_D'		THEN OM.BASE_PROD_CAPA_D --운영계획 CAPA 는 BASE
                    WHEN A.MSR_TP_CD = 'PROD_CAPA_M'		THEN OM.BASE_PROD_CAPA_M --운영계획 CAPA 는 BASE
                    ELSE
                        CONVERT(FLOAT, NULL)
                  END  AS MSR_NVL
				--, CASE
    --                WHEN LEN(A.YYYYMM) = 6 THEN DAY(EOMONTH(CONVERT(DATE, A.YYYYMM + '01')))  -- 월별 조업일
    --                ELSE 365.0 / 12.0                                                         -- 연별 조업일은 12개월로 나눈 평균 조업일
    --                END                                   AS MSR_DDN
                  , OM.DAY_CNT AS MSR_DDN
        FROM    #tblSCP0106_CHECK_RAW_KEYS A
                LEFT JOIN #tblSCP0106_RESULT_MDL_FINAL RM ON
                        A.DIVISION_ID			= RM.DIVISION_ID
                    AND A.COMPANY_ID			= RM.COMPANY_ID
                    AND A.SITE_ID				= RM.SITE_ID
                    AND A.PLANT_ID				= RM.PLANT_ID
                    AND A.FACTORY_ID			= RM.FACTORY_ID
                    AND A.LINE_ID				= RM.LINE_ID
                    AND A.OPERATION_ID			= RM.OPERATION_ID
                    AND A.ELTR_LN_TP_CD			= RM.ELTR_LN_TP_CD
                    AND A.MDL_NM				= RM.MDL_NM
                LEFT JOIN #tblSCP0106_RESULT_LN_FINAL RL ON
                        A.DIVISION_ID			= RL.DIVISION_ID
                    AND A.COMPANY_ID			= RL.COMPANY_ID
                    AND A.SITE_ID				= RL.SITE_ID
                    AND A.PLANT_ID				= RL.PLANT_ID
                    AND A.FACTORY_ID			= RL.FACTORY_ID
                    AND A.LINE_ID				= RL.LINE_ID
                    AND A.OPERATION_ID			= RL.OPERATION_ID
                    AND A.ELTR_LN_TP_CD			= RL.ELTR_LN_TP_CD
                    AND A.MDL_NM				= RL.MDL_NM
                LEFT JOIN #tblSCP0106_RESULT_MDL_YYYYMM_FINAL OM ON --운영계획용
                        A.DIVISION_ID			= OM.DIVISION_ID
                    AND A.COMPANY_ID			= OM.COMPANY_ID
                    AND A.SITE_ID				= OM.SITE_ID
                    AND A.PLANT_ID				= OM.PLANT_ID
                    AND A.FACTORY_ID			= OM.FACTORY_ID
                    AND A.LINE_ID				= OM.LINE_ID
                    AND A.OPERATION_ID			= OM.OPERATION_ID
                    AND A.ELTR_LN_TP_CD			= OM.ELTR_LN_TP_CD
                    AND A.MDL_NM				= OM.MDL_NM
				    AND A.YYYYMM				= OM.YYYYMM
                LEFT JOIN #tblSCP0106_RESULT_LN_YYYYMM_FINAL OL ON --운영계획용
                        A.DIVISION_ID			= OL.DIVISION_ID
                    AND A.COMPANY_ID			= OL.COMPANY_ID
                    AND A.SITE_ID				= OL.SITE_ID
                    AND A.PLANT_ID				= OL.PLANT_ID
                    AND A.FACTORY_ID			= OL.FACTORY_ID
                    AND A.LINE_ID				= OL.LINE_ID
                    AND A.OPERATION_ID			= OL.OPERATION_ID
                    AND A.ELTR_LN_TP_CD			= OL.ELTR_LN_TP_CD
                    AND A.MDL_NM				= OL.MDL_NM
                LEFT JOIN SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL L ON
				        A.DIVISION_ID		    = L.DIVISION_ID
				    AND A.MDL_NM				= L.MDL_NM
				    AND A.PLANT_ID				= L.PLANT_ID
				    AND A.LINE_ID				= L.LINE_ID
				    AND A.OPERATION_ID			= L.OPERATION_ID
				    AND A.ELTR_LN_TP_CD			= L.ELTR_LN_TP_CD
				    AND A.COMPANY_ID			= L.COMPANY_ID
				    AND A.SITE_ID				= L.SITE_ID
				    AND A.FACTORY_ID			= L.FACTORY_ID
				    AND A.MSR_TP_CD				= L.MSR_TP_CD
				    AND A.YYYYMM				= L.YYYYMM
				    AND A.MSR_GR_CD				= L.MSR_GR_CD
                    AND A.ELTR_LN_TP_CD			= L.ELTR_LN_TP_CD
                    


--TESTING : NOK
--select * from #tblSCP0106_CHECK_RAW_TEMP;rollback tran;return;


    	IF OBJECT_ID('tempdb..#tblSCP0106_CHECK_RAW1') IS NOT NULL
			DROP TABLE #tblSCP0106_CHECK_RAW1;

        --빈테이블 생성
        SELECT    A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.MSR_TP_CD
				, A.YYYYMM
				, A.PFRSLT_NVL
				, A.BASE_NVL
				--, A.IPRV_GOL_DIVS_CD
				--, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				, A.MSR_GR_CD
				, A.MSR_NVL
				, A.MSR_DDN
				, CONCAT(@v_program_name, '-', @p_user_id)  AS CREATED_BY
				, SYSDATETIME()		                        AS CREATION_DATE
				, CONCAT(@v_program_name, '-', @p_user_id)	AS LAST_UPDATED_BY
				, SYSDATETIME()		                        AS LAST_UPDATE_DATE
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE1
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE2
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE3
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE4
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE5
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE6
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE7
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE8
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE9
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE10
        INTO    #tblSCP0106_CHECK_RAW1
        FROM    #tblSCP0106_CHECK_RAW_TEMP A WITH(NOLOCK)
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_CHECK_RAW1
        SELECT    A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.MSR_TP_CD
				, A.YYYYMM
				, A.PFRSLT_NVL
				, A.BASE_NVL
				--, A.IPRV_GOL_DIVS_CD
				--, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
                ----TEST, IIF(A.IPRV_GOL_RT IS NULL AND A.IPRV_GOL_DIVS_CD = 'G', A.BASE_NVL, A.IPRV_GOL_RT)                     AS IPRV_GOL_RT --Goal 이면 Base 값을 Default 로 
				, A.MSR_GR_CD
				--, IIF(A.IPRV_GOL_RT IS NULL AND A.MSR_NVL IS NULL, A.BASE_NVL, A.MSR_NVL)   AS MSR_NVL	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				, IIF(A.MSR_NVL IS NULL, A.BASE_NVL, A.MSR_NVL)   AS MSR_NVL
				, A.MSR_DDN
				, CONCAT(@v_program_name, '-', @p_user_id)  AS CREATED_BY
				, SYSDATETIME()		                        AS CREATION_DATE
				, CONCAT(@v_program_name, '-', @p_user_id)	AS LAST_UPDATED_BY
				, SYSDATETIME()		                        AS LAST_UPDATE_DATE
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE1
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE2
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE3
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE4
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE5
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE6
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE7
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE8
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE9
                , CONVERT(NVARCHAR(150), NULL)          AS ATTRIBUTE10
        FROM    #tblSCP0106_CHECK_RAW_TEMP A WITH(NOLOCK)
--TESTING : NOK
--select * from #tblSCP0106_CHECK_RAW1;rollback tran;return;


    	IF OBJECT_ID('tempdb..#tblSCP0106_CHECK_RAW') IS NOT NULL
			DROP TABLE #tblSCP0106_CHECK_RAW;

        --빈테이블 생성
        SELECT    A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.MSR_TP_CD
				, A.YYYYMM
				, A.PFRSLT_NVL
				, A.BASE_NVL
				--, A.IPRV_GOL_DIVS_CD
				--, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				, A.MSR_GR_CD
				, A.MSR_NVL
				, A.MSR_DDN
				, A.CREATED_BY
				, A.CREATION_DATE
				, A.LAST_UPDATED_BY
				, A.LAST_UPDATE_DATE
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
                , BM.ASSIGN_PRIORITY
        INTO    #tblSCP0106_CHECK_RAW
        FROM    #tblSCP0106_CHECK_RAW1 A
                LEFT JOIN @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN BM ON
					    A.DIVISION_ID		= BM.DIVISION_ID
					AND A.COMPANY_ID		= BM.COMPANY_ID
					AND A.SITE_ID			= BM.SITE_ID
					AND A.PLANT_ID			= BM.PLANT_ID
					AND A.FACTORY_ID		= BM.FACTORY_ID
					AND A.LINE_ID			= BM.LINE_ID
					AND A.OPERATION_ID		= BM.OPERATION_ID
					------AND A.ELTR_LN_TP_CD	    = BM.ELTR_LN_TP_CD
					AND A.MDL_NM            = BM.ITEM_ID
					AND A.YYYYMM            = BM.YYYYMM
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_CHECK_RAW
        SELECT    A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.MSR_TP_CD
				, A.YYYYMM
				, A.PFRSLT_NVL
				, A.BASE_NVL
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) START
				--, A.IPRV_GOL_DIVS_CD
    --            , CASE
    --                WHEN ISNULL(BM.ASSIGN_PRIORITY, 0) = 0 AND A.MSR_TP_CD IN ('THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M') THEN NULL --Assign Priority 값이 없으면 기존 Loss Plan 값 삭제
    --                ELSE A.IPRV_GOL_RT
    --              END AS IPRV_GOL_RT
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) END
				, A.MSR_GR_CD
                --, CASE
                --    WHEN MSR_TP_CD IN ('PF_RT') THEN A.MSR_NVL
                --    ELSE
                --        CASE
                --            WHEN A.MDL_NM <> '-' THEN
                --                CASE
                --                    WHEN ISNULL(BM.ASSIGN_PRIORITY, 0) = 0 THEN NULL --모델별 Assign Priority 값이 없으면 기존 Loss Plan 값 삭제
                --                    ELSE A.MSR_NVL
                --                END
                --            ELSE
                --                CASE
                --                    WHEN ISNULL(BL.ASSIGN_PRIORITY, 0) = 0 THEN NULL --라인별 Assign Priority 값이 없으면 기존 Loss Plan 값 삭제
                --                    ELSE A.MSR_NVL
                --                END
                --        END
                --  END AS MSR_NVL
                , CASE
                    WHEN A.MDL_NM <> '-' THEN
                        CASE
                            WHEN ISNULL(BM.ASSIGN_PRIORITY, 0) = 0 THEN NULL --모델별 Assign Priority 값이 없으면 기존 Loss Plan 값 삭제
                            ELSE A.MSR_NVL
                        END
                    ELSE----Assign Priority 가 Model 별 존재하므로 Line 별은 기존값
                        ------CASE
                        ------    WHEN ISNULL(BL.ASSIGN_PRIORITY, 0) = 0 THEN NULL --라인별 Assign Priority 값이 없으면 기존 Loss Plan 값 삭제
                        ------    ELSE A.MSR_NVL
                        ------END
                        A.MSR_NVL
                  END AS MSR_NVL
				, A.MSR_DDN
				, A.CREATED_BY
				, A.CREATION_DATE
				, A.LAST_UPDATED_BY
				, A.LAST_UPDATE_DATE
                , A.ATTRIBUTE1
                , A.ATTRIBUTE2
                , A.ATTRIBUTE3
                , A.ATTRIBUTE4
                , A.ATTRIBUTE5
                , A.ATTRIBUTE6
                , A.ATTRIBUTE7
                , A.ATTRIBUTE8
                , A.ATTRIBUTE9
                , A.ATTRIBUTE10
                , BM.ASSIGN_PRIORITY
        FROM    #tblSCP0106_CHECK_RAW1 A
                LEFT JOIN @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN BM ON
					    A.DIVISION_ID		= BM.DIVISION_ID
					AND A.COMPANY_ID		= BM.COMPANY_ID
					AND A.SITE_ID			= BM.SITE_ID
					AND A.PLANT_ID			= BM.PLANT_ID
					AND A.FACTORY_ID		= BM.FACTORY_ID
					AND A.LINE_ID			= BM.LINE_ID
					AND A.OPERATION_ID		= BM.OPERATION_ID
					------AND A.ELTR_LN_TP_CD	    = BM.ELTR_LN_TP_CD
					AND A.MDL_NM            = BM.ITEM_ID
					AND A.YYYYMM            = BM.YYYYMM
     ------           LEFT JOIN #tblSCP0106_LINE_ASSIGN_LN BL ON
					------    A.DIVISION_ID		= BL.DIVISION_ID
					------AND A.COMPANY_ID		= BL.COMPANY_ID
					------AND A.SITE_ID			= BL.SITE_ID
					------AND A.PLANT_ID			= BL.PLANT_ID
					------AND A.FACTORY_ID		= BL.FACTORY_ID
					------AND A.LINE_ID			= BL.LINE_ID
					------AND A.OPERATION_ID		= BL.OPERATION_ID
					------------AND A.ELTR_LN_TP_CD	    = BL.ELTR_LN_TP_CD
					------AND A.YYYYMM            = BL.YYYYMM
                    

        PRINT N'GET - RAW - END';

--TESTING : NOK
--select * from #tblSCP0106_CHECK_RAW1;
--select * from #tblSCP0106_CHECK_RAW;rollback tran;return;
--select * from @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN WHERE YYYYMM = '202409';
--select * from #tblSCP0106_CHECK_RAW;rollback tran;return;
--select * from SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL;
--select * from #tblSCP0106_RESULT_LN_RAW;
--select * from #tblSCP0106_CHECK_RAW WHERE MSR_TP_CD = 'AV_RT';
--select * from @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN WHERE YYYYMM = '202601';
--select * from #tblSCP0106_LINE_ASSIGN_LN WHERE YYYYMM = '202601';
--select * from #tblSCP0106_CHECK_RAW WHERE MSR_TP_CD = 'PF_RT';rollback tran;return;

        --Valid = N 이면 추가나 수정 대상에서 삭제
        --DELETE  A
        --FROM    #tblSCP0106_CHECK_RAW A
        --        INNER JOIN #tblSCP0106_NOT_VALID_MDL B ON
        --                A.DIVISION_ID		= B.DIVISION_ID
        --            AND A.COMPANY_ID		= B.COMPANY_ID
        --            AND A.SITE_ID			= B.SITE_ID
        --            AND A.PLANT_ID			= B.PLANT_ID
        --            AND A.FACTORY_ID		= B.FACTORY_ID
        --            AND A.LINE_ID			= B.LINE_ID
        --            AND A.OPERATION_ID		= B.OPERATION_ID
        --            AND A.MDL_NM			= B.ITEM_ID;

--TESTING : NOK
--select  * FROM #tblSCP0106_CHECK_RAW1;
--select  * FROM #tblSCP0106_CHECK_RAW;rollback tran;return;


        ------DELETE  A
        ------FROM    #tblSCP0106_CHECK_RAW A
        ------        INNER JOIN #tblSCP0106_NOT_VALID_LN B ON
        ------                A.DIVISION_ID		= B.DIVISION_ID
        ------            AND A.COMPANY_ID		= B.COMPANY_ID
        ------            AND A.SITE_ID			= B.SITE_ID
        ------            AND A.PLANT_ID			= B.PLANT_ID
        ------            AND A.FACTORY_ID		= B.FACTORY_ID
        ------            AND A.LINE_ID			= B.LINE_ID

--TESTING : NOK
--select * from #tblSCP0106_CHECK_RAW1;
--select  * FROM #tblSCP0106_CHECK_RAW;--rollback tran;return;
----select  * FROM #tblSCP0106_CHECK_RAW WHERE MSR_TP_CD = 'PF_RT' AND (MSR_NVL IS NULL);
----select  * FROM #tblSCP0106_CHECK_RAW WHERE MSR_TP_CD = 'AV_RT' AND (MSR_NVL IS NULL) AND (BASE_NVL IS NOT NULL);rollback tran;return;
--SELECT  A.*
--FROM    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
--        JOIN #tblSCP0106_CHECK_RAW B ON
--					A.DIVISION_ID		    = B.DIVISION_ID
--				AND A.MDL_NM				= B.MDL_NM
--				AND A.PLANT_ID				= B.PLANT_ID
--				AND A.LINE_ID				= B.LINE_ID
--				AND A.OPERATION_ID			= B.OPERATION_ID
--				----AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
--				AND A.COMPANY_ID			= B.COMPANY_ID
--				AND A.SITE_ID				= B.SITE_ID
--				AND A.FACTORY_ID			= B.FACTORY_ID
--				AND A.MSR_TP_CD				= B.MSR_TP_CD
--				AND A.YYYYMM				= B.YYYYMM
--				AND A.MSR_GR_CD				= B.MSR_GR_CD
--WHERE   1=1
----    AND B.MSR_TP_CD = 'PF_RT'
--rollback tran;return;


	    BEGIN --Update Loss Plan ########################################################################################################################################################################################
        PRINT N'INSERT - SCP_MST_CAPA_ELTR_LOSS_PLAN - BEGIN'
        IF @p_prog_stat = '0' -- 0 : Current
        BEGIN
			MERGE INTO SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
			USING
			(
				SELECT    DIVISION_ID
				        , MDL_NM
				        , PLANT_ID
				        , LINE_ID
				        , OPERATION_ID
				        , ELTR_LN_TP_CD
				        , COMPANY_ID
				        , SITE_ID
				        , FACTORY_ID
				        , MSR_TP_CD
				        , YYYYMM
				        , PFRSLT_NVL
				        , BASE_NVL
				        --, IPRV_GOL_DIVS_CD
				        --, IPRV_GOL_RT			-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				        , MSR_GR_CD
				        , MSR_NVL
				        , MSR_DDN
				        , CREATED_BY
				        , CREATION_DATE
				        , LAST_UPDATED_BY
				        , LAST_UPDATE_DATE
                        , ATTRIBUTE1
                        , ATTRIBUTE2
                        , ATTRIBUTE3
                        , ATTRIBUTE4
                        , ATTRIBUTE5
                        , ATTRIBUTE6
                        , ATTRIBUTE7
                        , ATTRIBUTE8
                        , ATTRIBUTE9
                        , ATTRIBUTE10
                        , ASSIGN_PRIORITY
                FROM    #tblSCP0106_CHECK_RAW
                WHERE   1=1
                    AND ISNULL(DIVISION_ID, '') <> ''
                    AND ISNULL(MDL_NM, '') <> ''
                    AND ISNULL(PLANT_ID, '') <> ''
                    AND ISNULL(LINE_ID, '') <> ''
                    AND ISNULL(OPERATION_ID, '') <> ''
                    AND ISNULL(COMPANY_ID, '') <> ''
                    AND ISNULL(SITE_ID, '') <> ''
                    AND ISNULL(FACTORY_ID, '') <> ''
                    AND ISNULL(MSR_TP_CD, '') <> ''
                    AND ISNULL(YYYYMM, '') <> ''
                    AND ISNULL(MSR_GR_CD, '') <> ''
			) B ON
			(
					A.DIVISION_ID		    = B.DIVISION_ID
				AND A.MDL_NM				= B.MDL_NM
				AND A.PLANT_ID				= B.PLANT_ID
				AND A.LINE_ID				= B.LINE_ID
				AND A.OPERATION_ID			= B.OPERATION_ID
				AND A.COMPANY_ID			= B.COMPANY_ID
				AND A.SITE_ID				= B.SITE_ID
				AND A.FACTORY_ID			= B.FACTORY_ID
				AND A.MSR_TP_CD				= B.MSR_TP_CD
				AND A.YYYYMM				= B.YYYYMM
				AND A.MSR_GR_CD				= B.MSR_GR_CD
			)
			WHEN MATCHED THEN
			UPDATE
			SET
				--  PFRSLT_NVL			= B.PFRSLT_NVL
				--, BASE_NVL				= B.BASE_NVL
                  --IPRV_GOL_RT			= B.IPRV_GOL_RT,	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				  MSR_NVL				= IIF(ISNULL(B.ASSIGN_PRIORITY, 0) = 0 AND B.MSR_TP_CD IN ('THRY_CAPA_D', 'PROD_CAPA_D', 'PROD_CAPA_M'), B.MSR_NVL, A.MSR_NVL)
				----Line Assign 통한 Speed Plan 수정에서는 변경 불가!!!, ELTR_LN_TP_CD		    = B.ELTR_LN_TP_CD
				, LAST_UPDATED_BY		= B.LAST_UPDATED_BY
				, LAST_UPDATE_DATE		= B.LAST_UPDATE_DATE
			WHEN NOT MATCHED THEN
			INSERT
			(
				  DIVISION_ID
				, MDL_NM
				, PLANT_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, COMPANY_ID
				, SITE_ID
				, FACTORY_ID
				, MSR_TP_CD
				, YYYYMM
				, PFRSLT_NVL
				, BASE_NVL
				--, IPRV_GOL_DIVS_CD
				--, IPRV_GOL_RT			-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				, MSR_GR_CD
				, MSR_NVL
--Current에 MS_DDN 없음						, MSR_DDN
				, CREATED_BY
				, CREATION_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
				, ATTRIBUTE1
				, ATTRIBUTE2
				, ATTRIBUTE3
				, ATTRIBUTE4
				, ATTRIBUTE5
				, ATTRIBUTE6
				, ATTRIBUTE7
				, ATTRIBUTE8
				, ATTRIBUTE9
				, ATTRIBUTE10
			)
			VALUES
			(
				  B.DIVISION_ID
				, B.MDL_NM
				, B.PLANT_ID
				, B.LINE_ID
				, B.OPERATION_ID
				, B.ELTR_LN_TP_CD
				, B.COMPANY_ID
				, B.SITE_ID
				, B.FACTORY_ID
				, B.MSR_TP_CD
				, B.YYYYMM
				, B.PFRSLT_NVL
				, B.BASE_NVL
				--, B.IPRV_GOL_DIVS_CD
				--, B.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				, B.MSR_GR_CD
				, B.MSR_NVL
--Current에 MS_DDN 없음						, B.MSR_DDN
				, B.CREATED_BY
				, B.CREATION_DATE
				, B.LAST_UPDATED_BY
				, B.LAST_UPDATE_DATE
				, B.ATTRIBUTE1
				, B.ATTRIBUTE2
				, B.ATTRIBUTE3
				, B.ATTRIBUTE4
				, B.ATTRIBUTE5
				, B.ATTRIBUTE6
				, B.ATTRIBUTE7
				, B.ATTRIBUTE8
				, B.ATTRIBUTE9
				, B.ATTRIBUTE10
			);

--TESTING : NOK
--select * from #tblSCP0106_CHECK_RAW;
--select * from SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL;rollback tran;return;
--SELECT  A.*
--FROM    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
--        JOIN #tblSCP0106_CHECK_RAW B ON
--					A.DIVISION_ID		    = B.DIVISION_ID
--				AND A.MDL_NM				= B.MDL_NM
--				AND A.PLANT_ID				= B.PLANT_ID
--				AND A.LINE_ID				= B.LINE_ID
--				AND A.OPERATION_ID			= B.OPERATION_ID
--				AND A.COMPANY_ID			= B.COMPANY_ID
--				AND A.SITE_ID				= B.SITE_ID
--				AND A.FACTORY_ID			= B.FACTORY_ID
--				AND A.MSR_TP_CD				= B.MSR_TP_CD
--				AND A.YYYYMM				= B.YYYYMM
--				AND A.MSR_GR_CD				= B.MSR_GR_CD
--WHERE   1=1
--    --AND B.MSR_TP_CD = 'PF_RT'
--rollback tran;return;



            BEGIN --우선순위가 없으면 사용자가 입력한 월별 데이터도 클리어(삭제 영향도 판단하여 삭제 고려!!!)
                UPDATE A
                SET
                    --A.IPRV_GOL_RT   = NULL,	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
					A.MSR_NVL       = NULL
                FROM    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
                        INNER JOIN @TBL_SCP_MST_CAPA_ELTR_LINE_ASSIGN B ON
					    A.DIVISION_ID		= B.DIVISION_ID
				    AND A.COMPANY_ID		= B.COMPANY_ID
				    AND A.SITE_ID			= B.SITE_ID
				    AND A.PLANT_ID			= B.PLANT_ID
				    AND A.FACTORY_ID		= B.FACTORY_ID
				    AND A.LINE_ID			= B.LINE_ID
				    AND A.OPERATION_ID		= B.OPERATION_ID
				    ------AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
				    AND A.MDL_NM            = B.ITEM_ID
				    AND A.YYYYMM            = B.YYYYMM
                WHERE   1=1
                    AND ISNULL(B.ASSIGN_PRIORITY, 0) = 0;
            END --우선순위가 없으면 사용자가 입력한 월별 데이터도 클리어(삭제 영향도 판단하여 삭제 고려!!!)


            BEGIN
                DELETE A -- 아예 삭제함
                FROM    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
                        INNER JOIN (
                                        SELECT  *
                                        FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN
                                        WHERE   1=1
                                            AND (ISNULL(ASSIGN_PRIORITY, 0) = 0 OR ISNULL(VALID_YN, 'N') <> 'Y')
                                    ) B ON
                                A.DIVISION_ID		= B.DIVISION_ID
                            AND A.COMPANY_ID		= B.COMPANY_ID
                            AND A.SITE_ID			= B.SITE_ID
                            AND A.PLANT_ID			= B.PLANT_ID
                            AND A.FACTORY_ID		= B.FACTORY_ID
                            AND A.LINE_ID			= B.LINE_ID
                            AND A.OPERATION_ID		= B.OPERATION_ID
                            AND A.MDL_NM			= B.ITEM_ID
                            AND A.YYYYMM			= B.YYYYMM
            END
        END
        PRINT N'INSERT - SCP_MST_CAPA_ELTR_LOSS_PLAN - END'
	    END --Update Loss Plan ########################################################################################################################################################################################
    END

--TESTING : NOK
--select * from #tblSCP0106_CHECK_RAW;
--select * from SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL;rollback tran;return;
--SELECT  A.*
--FROM    SCP_MST_CAPA_ELTR_LOSS_PLAN_MDL A
--        JOIN #tblSCP0106_CHECK_RAW B ON
--					A.DIVISION_ID		    = B.DIVISION_ID
--				AND A.MDL_NM				= B.MDL_NM
--				AND A.PLANT_ID				= B.PLANT_ID
--				AND A.LINE_ID				= B.LINE_ID
--				AND A.OPERATION_ID			= B.OPERATION_ID
--				----AND A.ELTR_LN_TP_CD			= B.ELTR_LN_TP_CD
--				AND A.COMPANY_ID			= B.COMPANY_ID
--				AND A.SITE_ID				= B.SITE_ID
--				AND A.FACTORY_ID			= B.FACTORY_ID
--				AND A.MSR_TP_CD				= B.MSR_TP_CD
--				AND A.YYYYMM				= B.YYYYMM
--				AND A.MSR_GR_CD				= B.MSR_GR_CD
--WHERE   1=1
--    --AND B.MSR_TP_CD = 'PF_RT'
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
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK;
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_BASE') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_BASE;
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_BASE_UI_UPD_YN') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_BASE_UI_UPD_YN;
	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_RESULT') IS NOT NULL
			DROP TABLE #tblSCP0105_CHECK_RESULT;
	    IF OBJECT_ID('tempdb..#tblSCP0105_RAW') IS NOT NULL
			DROP TABLE #tblSCP0105_RAW;
	    IF OBJECT_ID('tempdb..#tblSCP0105_RAW_ALL') IS NOT NULL
			DROP TABLE #tblSCP0105_RAW_ALL;
	    IF OBJECT_ID('tempdb..#tblSCP0105_RAW_ALL_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0105_RAW_ALL_TEMP;
	    IF OBJECT_ID('tempdb..#tblSCP0105_RAW_KEYS') IS NOT NULL
			DROP TABLE #tblSCP0105_RAW_KEYS;
	    IF OBJECT_ID('tempdb..#tblSCP0105_RAW_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0105_RAW_TEMP;
	    IF OBJECT_ID('tempdb..#tblSCP0105_SPEED_UNIT_ALL') IS NOT NULL
			DROP TABLE #tblSCP0105_SPEED_UNIT_ALL;
	    IF OBJECT_ID('tempdb..#tblSCP0105_SPEED_UNIT_GROUP') IS NOT NULL
			DROP TABLE #tblSCP0105_SPEED_UNIT_GROUP;
	    IF OBJECT_ID('tempdb..#tblSCP0106_CHECK_MEASURE') IS NOT NULL
			DROP TABLE #tblSCP0106_CHECK_MEASURE;
	    IF OBJECT_ID('tempdb..#tblSCP0106_CHECK_MEASURE_CURRENT') IS NOT NULL
			DROP TABLE #tblSCP0106_CHECK_MEASURE_CURRENT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_CHECK_PLAN_TP') IS NOT NULL
			DROP TABLE #tblSCP0106_CHECK_PLAN_TP;
	    IF OBJECT_ID('tempdb..#tblSCP0106_CHECK_RAW1') IS NOT NULL
			DROP TABLE #tblSCP0106_CHECK_RAW1;
	    IF OBJECT_ID('tempdb..#tblSCP0106_CHECK_RAW') IS NOT NULL
			DROP TABLE #tblSCP0106_CHECK_RAW;
	    IF OBJECT_ID('tempdb..#tblSCP0106_CHECK_RAW_KEYS') IS NOT NULL
			DROP TABLE #tblSCP0106_CHECK_RAW_KEYS;
	    IF OBJECT_ID('tempdb..#tblSCP0106_CHECK_RAW_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0106_CHECK_RAW_TEMP;
	    IF OBJECT_ID('tempdb..#tblSCP0106_EQPUIPMENT_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0106_EQPUIPMENT_TEMP;
	    IF OBJECT_ID('tempdb..#tblSCP0106_IPRV') IS NOT NULL
			DROP TABLE #tblSCP0106_IPRV;
	    IF OBJECT_ID('tempdb..#tblSCP0106_LINE_ASSIGN_LN') IS NOT NULL
			DROP TABLE #tblSCP0106_LINE_ASSIGN_LN;
	    IF OBJECT_ID('tempdb..#tblSCP0106_MEASURE_ALL') IS NOT NULL
			DROP TABLE #tblSCP0106_MEASURE_ALL;
	    IF OBJECT_ID('tempdb..#tblSCP0106_NOT_VALID_LN') IS NOT NULL
			DROP TABLE #tblSCP0106_NOT_VALID_LN;
	    IF OBJECT_ID('tempdb..#tblSCP0106_NOT_VALID_MDL') IS NOT NULL
			DROP TABLE #tblSCP0106_NOT_VALID_MDL;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_KEYS_LN') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_KEYS_LN;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_KEYS_MDL') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_KEYS_MDL;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_AV_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_AV_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_BM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_BM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_CM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_CM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_FINAL') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_FINAL;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_ID_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_ID_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_MR_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_MR_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_NM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_NM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_PD_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_PD_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_PF_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_PF_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_PM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_PM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_PP_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_PP_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_QL_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_QL_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_RAW') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_RAW;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_TEMP;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_UD_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_UD_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_AV_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_AV_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_BM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_BM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_CM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_CM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_FINAL') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_FINAL;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_ID_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_ID_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_MR_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_MR_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_NM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_NM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_PD_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_PD_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_PF_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_PF_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_PM_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_PM_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_PP_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_PP_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_QL_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_QL_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_RAW') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_RAW;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_TEMP;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_LN_YYYYMM_UD_RT') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_LN_YYYYMM_UD_RT;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_MDL_FINAL') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_MDL_FINAL;
	    IF OBJECT_ID('tempdb..#tblSCP0106_RESULT_MDL_YYYYMM_FINAL') IS NOT NULL
			DROP TABLE #tblSCP0106_RESULT_MDL_YYYYMM_FINAL;
	    IF OBJECT_ID('tempdb..#tblSCP0106_SPEED_PLAN') IS NOT NULL
			DROP TABLE #tblSCP0106_SPEED_PLAN;
	    IF OBJECT_ID('tempdb..#tblSCP0106_SPEED_PLAN_LN') IS NOT NULL
			DROP TABLE #tblSCP0106_SPEED_PLAN_LN;
	    IF OBJECT_ID('tempdb..#tblSCP0106_SPEED_PLAN_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0106_SPEED_PLAN_TEMP;
	    IF OBJECT_ID('tempdb..#tblSCP0106_VALID_LN') IS NOT NULL
			DROP TABLE #tblSCP0106_VALID_LN;
	    IF OBJECT_ID('tempdb..#tblSCP0106_VALID_MDL') IS NOT NULL
			DROP TABLE #tblSCP0106_VALID_MDL;
	    IF OBJECT_ID('tempdb..#tblSCP0106_YYYYMM_KEYS_LN') IS NOT NULL
			DROP TABLE #tblSCP0106_YYYYMM_KEYS_LN;
	    IF OBJECT_ID('tempdb..#tblSCP0106_YYYYMM_KEYS_MDL') IS NOT NULL
			DROP TABLE #tblSCP0106_YYYYMM_KEYS_MDL;
	    IF OBJECT_ID('tempdb..#tbl_DAY_CNT_BASE') IS NOT NULL
			DROP TABLE #tbl_DAY_CNT_BASE;
	    IF OBJECT_ID('tempdb..#tbl_DAY_CNT_YYYYMM') IS NOT NULL
			DROP TABLE #tbl_DAY_CNT_YYYYMM;
	    IF OBJECT_ID('tempdb..#tbl_DAY_CNT_YYYYMM_YEAR') IS NOT NULL
			DROP TABLE #tbl_DAY_CNT_YYYYMM_YEAR;
    END

END

