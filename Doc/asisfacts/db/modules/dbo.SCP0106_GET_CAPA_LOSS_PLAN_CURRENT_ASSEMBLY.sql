
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0106_GET_CAPA_LOSS_PLAN_CURRENT_ASSEMBLY
 * Description  :
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/19   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/07/11   chaan        V1.1.3                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 3차 Update
 * 2024/07/11   chaan        V1.1.4                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Speed Plan 실적 수정
                                                                                                             - FACTROY_NAME 시노님 참조로 변경
 * 2024/08/03   chaan        V1.1.5                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 뷰로 대체
 * 2024/08/12   chaan        V1.1.6                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - PPM 조회 방식을 Speed Plan 저장된 값으로 대체
 * 2024/08/26   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Loss Plan 뷰 적용
                                                                                                             - Formation 적용
 * 2024.10.28	chaan        V1.1.9                PJ20239037 LGES CPS VOE 반영 및 고도화                     - 컬럼순서 변경 : 공정, 모델 -> 모델, 공정
 * 2024.12.09	chaan        V1.1.10               PJ20239037 LGES CPS VOE 반영 및 고도화                     - Pre 예외 처리
                                                                                                             _ SPEED_BASE_PPM 수정
 * 2025/02/06   mrchois      V1.1.11               PJ20249346  LGES SCP 개선과제 이행	 - Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정
*/


--CREATE PROCEDURE [dbo].[SCP0106_GET_CAPA_LOSS_PLAN_CURRENT_ASSEMBLY]
CREATE PROCEDURE [dbo].[SCP0106_GET_CAPA_LOSS_PLAN_CURRENT_ASSEMBLY]
	  @p_version			NVARCHAR(10)
	, @p_version_seq		TINYINT
	, @p_prog_stat			NVARCHAR(1)
	, @p_division_id		NVARCHAR(30)
	, @p_site_id			NVARCHAR(MAX)
	, @p_plant_id  			NVARCHAR(MAX)
	, @p_factory_id			NVARCHAR(MAX)
	, @p_line_id			NVARCHAR(MAX)
	, @p_operation_id		NVARCHAR(MAX)
	, @p_nick_name			NVARCHAR(MAX)
    , @p_electrode_type		NVARCHAR(MAX)
	, @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
	, @p_user_id			NVARCHAR(30)
	, @debug_mode			NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_version			NVARCHAR(10)		= N'202412'
	--DECLARE @p_version_seq		TINYINT             = 1;
	--DECLARE @p_prog_stat		NVARCHAR(1)         = N'-'; -- '0' : Current, '1' : 1st Cutoff, '2' : 2nd Cutoff
	--DECLARE @p_division_id		NVARCHAR(30)		= N'81';
	--DECLARE @p_site_id			NVARCHAR(MAX)		= N'';
	--DECLARE @p_plant_id  		NVARCHAR(MAX)		= N'';
	--DECLARE @p_factory_id		NVARCHAR(MAX)		= N'';
	--DECLARE @p_line_id			NVARCHAR(MAX)		= N'A4A06';
	--DECLARE @p_operation_id		NVARCHAR(MAX)		= N'';
 --   DECLARE @p_nick_name	    NVARCHAR(MAX)		= N'';
	--DECLARE @p_electrode_type	NVARCHAR(MAX)		= N'';
	--DECLARE @p_program_id		NVARCHAR(100)		= N'SCP0106';
	--DECLARE @p_sheet_name		NVARCHAR(100)		= N'CURRENT_ASSEMBLY';
 --   DECLARE @p_user_id			NVARCHAR(30)		= N'iamarock';
 --   DECLARE @debug_mode			NVARCHAR(1)			= N'F';



	DECLARE @V_ELAPSED_TIME_BEG     DATETIME                = CURRENT_TIMESTAMP;


    DECLARE @v_from_yyyy                NVARCHAR(8)			= N'';
    DECLARE @v_from_yyyymm				NVARCHAR(6)			= CONVERT(NVARCHAR(6), DATEADD(MM, 1, CONVERT(DATETIME, @p_version + '01')), 112);
    DECLARE @v_auto_calc_end_yyyy       NVARCHAR(8)			= N'';
	DECLARE @v_result_from_yyyymm		NVARCHAR(6)         = N'';
	DECLARE @v_result_to_yyyymm			NVARCHAR(6)         = N'';

    SET @v_from_yyyy            = SUBSTRING(@p_version, 1, 4);

    SET @v_auto_calc_end_yyyy   = SUBSTRING(CONVERT(CHAR(8), DATEADD(YEAR, 1, CONVERT(DATETIME, @p_version + '01')), 112), 1, 4);

    PRINT CONCAT('@v_auto_calc_end_yyyy : ' ,@v_auto_calc_end_yyyy);

    SET @v_result_from_yyyymm   = CONVERT(CHAR(8), DATEADD(MM, -3, CONVERT(DATETIME, @p_version + '01')), 112);
    SET @v_result_to_yyyymm     = CONVERT(CHAR(8), DATEADD(MM, -1, CONVERT(DATETIME, @p_version + '01')), 112);

    PRINT CONCAT('@p_version : ', @p_version);
    PRINT CONCAT('@v_result_from_yyyymm : ', @v_result_from_yyyymm);
    PRINT CONCAT('@v_result_to_yyyymm : ', @v_result_to_yyyymm);
    --return;



	IF OBJECT_ID('tempdb..#tblSCP0106_DATE_COLS') IS NOT NULL
		DROP TABLE #tblSCP0106_DATE_COLS;

    --빈테이블 생성
    SELECT	  COLUMN_NAME
			, COLUMN_LABEL_NAME
			, SMALL_CLASS_LABEL_NAME
			, LARGE_CLASS_LABEL_NAME
			, DAY_CODE
			, SORT_ORDER_NO
    INTO    #tblSCP0106_DATE_COLS
	FROM	dbo.FN_SCP0104_GET_SPREAD_TITLE(@v_from_yyyymm, @p_program_id, @p_sheet_name) A
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_DATE_COLS
    SELECT	  COLUMN_NAME
			, COLUMN_LABEL_NAME
			, SMALL_CLASS_LABEL_NAME
			, LARGE_CLASS_LABEL_NAME
			, DAY_CODE
			, SORT_ORDER_NO
	FROM	dbo.FN_SCP0104_GET_SPREAD_TITLE(@v_from_yyyymm, @p_program_id, @p_sheet_name) A
    WHERE   1=1
        AND SUBSTRING(SORT_ORDER_NO, 1, 2) <> '99' 

--TESTING : NOK
--select * from #tblSCP0106_DATE_COLS;return;

	IF OBJECT_ID('tempdb..#tblSCP0106_PLAN_TP') IS NOT NULL
		DROP TABLE #tblSCP0106_PLAN_TP;

    --빈테이블 생성
    SELECT	LARGE_CLASS_LABEL_NAME  AS PLAN_TP
    INTO    #tblSCP0106_PLAN_TP
	FROM	#tblSCP0106_DATE_COLS
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_PLAN_TP
    SELECT	LARGE_CLASS_LABEL_NAME AS PLAN_TP
	FROM	#tblSCP0106_DATE_COLS
    GROUP BY LARGE_CLASS_LABEL_NAME

--TESTING : NOK
--select * from #tblSCP0106_PLAN_TP;return;

	DECLARE @v_to_yyyy			NVARCHAR(4)			= '';

    SELECT  @v_to_yyyy  = MAX(SMALL_CLASS_LABEL_NAME)
    FROM    #tblSCP0106_DATE_COLS;

PRINT CONCAT('@v_to_yyyy : ', @v_to_yyyy);


   -- --SCP_MST_CAPA_SPEED_PLAN_CUTF 테이블에 @p_division_id, @p_plan_start_yyyymmdd 에 해당하는 데이터가 하나도 없으면 SCP_MST_CAPA_LINE_ASSIGN_CUTF 테이블의 목록을 기준으로 데이터 자동 생성
   -- EXEC SCP0105_CHECK_NEW_CAPA_SPEED_PLAN
			--  @p_version
			--, @p_version_seq
	  --      , @p_division_id
	  --      , @p_program_id
	  --      , @p_sheet_name
	  --      , @p_user_id
	  --      , 'F';

	    IF OBJECT_ID('tempdb..#tblSCP0106_MEASURE_ALL') IS NOT NULL
			DROP TABLE #tblSCP0106_MEASURE_ALL;

        --빈테이블 생성
        SELECT    A.ATTRIBUTE3			AS LOSS_GR_CD
                , A.SEGMENT1			AS LOSS_CD
                , A.ATTRIBUTE6			AS LOSS_GR_NM_KO
                , A.ATTRIBUTE7			AS LOSS_GR_NM_EN
                , A.ATTRIBUTE4			AS LOSS_NM_KO
                , A.ATTRIBUTE5			AS LOSS_NM_EN
                , A.ATTRIBUTE8			AS TARGET_YN
                , A.DISPLAY_SEQ

				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) START
                --, A.ATTRIBUTE10			AS IPRV_GOL_TP
                --, A.ATTRIBUTE11			AS IPRV_GOL_TP_NM_EN
                --, A.ATTRIBUTE12			AS IPRV_GOL_TP_NM_KO
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) END

        INTO    #tblSCP0106_MEASURE_ALL
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_MEASURE_ALL
        SELECT    A.ATTRIBUTE3        AS LOSS_GR_CD
                , A.SEGMENT1          AS LOSS_CD
                , A.ATTRIBUTE6        AS LOSS_GR_NM_KO
                , A.ATTRIBUTE7        AS LOSS_GR_NM_EN
                , A.ATTRIBUTE4        AS LOSS_NM_KO
                , A.ATTRIBUTE5        AS LOSS_NM_EN
                , CASE
                    WHEN @p_sheet_name = 'CUTOFF_MODEL'     THEN A.ATTRIBUTE8   --MODEL_TARGET_YN
                    WHEN @p_sheet_name = '1ST_CUTOFF_LINE'  THEN A.ATTRIBUTE14  --1ST_LINE_TARGET_YN
                    WHEN @p_sheet_name = '2ND_CUTOFF_LINE'  THEN A.ATTRIBUTE9   --2ND_LINE_TARGET_YN
                    ELSE A.ATTRIBUTE13                                          --CURRENT_TARGET_YN
                  END AS TARGET_YN
                , A.DISPLAY_SEQ

				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) START
                --, A.ATTRIBUTE10			AS IPRV_GOL_TP
                --, A.ATTRIBUTE11			AS IPRV_GOL_TP_NM_EN
                --, A.ATTRIBUTE12			AS IPRV_GOL_TP_NM_KO
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) END

        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1=1
            AND A.LOOKUP_TYPE  = 'SCP_CAPA_LOSS_MEASURE'
            AND A.VALID_YN  = 'Y';

--TESTING : NOK
--select * from #tblSCP0106_MEASURE_ALL;return;


	    IF OBJECT_ID('tempdb..#tblSCP0106_MEASURE_EDITABLE') IS NOT NULL
			DROP TABLE #tblSCP0106_MEASURE_EDITABLE;

        --빈테이블 생성
        SELECT    A.LOSS_GR_CD
                , A.LOSS_CD
                , A.LOSS_GR_NM_KO
                , A.LOSS_GR_NM_EN
                , A.LOSS_NM_KO
                , A.LOSS_NM_EN
                , A.DISPLAY_SEQ
        INTO    #tblSCP0106_MEASURE_EDITABLE
        FROM    #tblSCP0106_MEASURE_ALL A
        WHERE   1<>1;

--TESTING : NOK
--select * from #tblSCP0106_MEASURE_EDITABLE;return;

        INSERT INTO #tblSCP0106_MEASURE_EDITABLE
        SELECT    A.LOSS_GR_CD
                , A.LOSS_CD
                , A.LOSS_GR_NM_KO
                , A.LOSS_GR_NM_EN
                , A.LOSS_NM_KO
                , A.LOSS_NM_EN
                , A.DISPLAY_SEQ
        FROM    #tblSCP0106_MEASURE_ALL A
        WHERE   1=1
            AND A.TARGET_YN = 'Y';

--TESTING : NOK
--select * from #tblSCP0106_MEASURE_EDITABLE;return;

	    IF OBJECT_ID('tempdb..#tblSCP0106_MEASURE_VISIBLE') IS NOT NULL
			DROP TABLE #tblSCP0106_MEASURE_VISIBLE;

        SELECT  COLUMN_NAME AS MEASURE
        INTO    #tblSCP0106_MEASURE_VISIBLE
        FROM    SCM_MST_SHEET_MEASURE WITH(NOLOCK)
        WHERE   1=1
            AND PROGRAM_ID    = @p_program_id
            AND SHEET_NAME    = @p_sheet_name
            AND VALID_YN      = 'Y'

--TESTING : NOK
--select * from #tblSCP0106_MEASURE_VISIBLE;return;

		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) START
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
		*/
		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) END


--TESTING : NOK
--select * from #tblSCP0106_IPRV;return;


	IF OBJECT_ID('tempdb..#tblSCP0104_CODE_ALL') IS NOT NULL
		DROP TABLE #tblSCP0104_CODE_ALL;

    SELECT  *
    INTO    #tblSCP0104_CODE_ALL
    FROM    SCP_MST_CAPA_LINE WITH(NOLOCK)
    WHERE   VALID_YN = 'Y'


	IF OBJECT_ID('tempdb..#tblSCP0104_SITE') IS NOT NULL
		DROP TABLE #tblSCP0104_SITE;

    SELECT    SITE_ID
            , SITE_NAME
    INTO    #tblSCP0104_SITE
    FROM    #tblSCP0104_CODE_ALL
    GROUP BY  SITE_ID
            , SITE_NAME

--TESTING : NOK
--select * from #tblSCP0104_SITE;return;


	IF OBJECT_ID('tempdb..#tblSCP0104_COMPANY') IS NOT NULL
		DROP TABLE #tblSCP0104_COMPANY;

    SELECT    COMPANY_ID
            , COMPANY_NAME
    INTO    #tblSCP0104_COMPANY
    FROM    #tblSCP0104_CODE_ALL
    GROUP BY  COMPANY_ID
            , COMPANY_NAME

--TESTING : NOK
--select * from #tblSCP0104_COMPANY;return;


	IF OBJECT_ID('tempdb..#tblSCP0104_PLANT') IS NOT NULL
		DROP TABLE #tblSCP0104_PLANT;

    SELECT    PLANT_ID
            , PLANT_NAME
    INTO    #tblSCP0104_PLANT
    FROM    #tblSCP0104_CODE_ALL
    GROUP BY  PLANT_ID
            , PLANT_NAME

--TESTING : NOK
--select * from #tblSCP0104_PLANT;return;


	IF OBJECT_ID('tempdb..#tblSCP0104_FACTORY') IS NOT NULL
		DROP TABLE #tblSCP0104_FACTORY;

    SELECT    FACTORY_ID
            , FACTORY_NAME
    INTO    #tblSCP0104_FACTORY
    FROM    #tblSCP0104_CODE_ALL
    GROUP BY  FACTORY_ID
            , FACTORY_NAME

--TESTING : NOK
--select * from #tblSCP0104_FACTORY;return;


	IF OBJECT_ID('tempdb..#tblSCP0104_LINE') IS NOT NULL
		DROP TABLE #tblSCP0104_LINE;

    SELECT    LINE_ID
            , LINE_NAME
    INTO    #tblSCP0104_LINE
    FROM    #tblSCP0104_CODE_ALL
    GROUP BY  LINE_ID
            , LINE_NAME

--TESTING : NOK
--select * from #tblSCP0104_LINE WHERE LINE_ID = 'A3A08';return;


	IF OBJECT_ID('tempdb..#tblSCP0104_OPERATION') IS NOT NULL
		DROP TABLE #tblSCP0104_OPERATION;

    SELECT    A.OPERATION_ID
            , A.OPERATION_NAME
    INTO    #tblSCP0104_OPERATION
    FROM    (
                SELECT    A.OPERATION_ID
		                , MAX(A.OPERATION_NAME) AS OPERATION_NAME
                FROM	[dbo].SCM_MST_OPERATION_SN A WITH(NOLOCK)
                GROUP BY  A.OPERATION_ID
                UNION ALL
                SELECT	  B.SEGMENT1   AS CODE
		                , B.ATTRIBUTE1 AS NAME
                FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
		                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
				                A.LOOKUP_TYPE = B.LOOKUP_TYPE
                WHERE	1=1
	                AND A.LOOKUP_GROUP  = 'SCP'
	                AND A.LOOKUP_TYPE   = 'CPS_FORMATION_OPERATION'
	                AND B.VALID_YN      = 'Y'
                GROUP BY  B.SEGMENT1
		                , B.ATTRIBUTE1
            ) A

--TESTING : NOK
--select * from #tblSCP0104_OPERATION WHERE;return;


PRINT CONCAT('@p_prog_stat : ', @p_prog_stat);
--return;
PRINT CONCAT('ELAPSED_TIME-Temp Codes : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;


    PRINT N'GET - RAW - BEGIN';
	IF OBJECT_ID('tempdb..#tblSCP0106_RAW') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW;

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
			-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) START
			--, A.IPRV_GOL_DIVS_CD
            --, A.IPRV_GOL_RT
			-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) END
			, A.MSR_GR_CD
            , A.MSR_NVL
		    , A.LOSS_NM_EN
		    , A.LOSS_GR_NM_EN
		    , A.SORT_ORDER_NO
            , A.DAY_CNT
            , A.DAY_CNT_BASE
            , A.SPEED_PPM
            , A.SPEED_BASE_PPM
            , A.ASSIGN_PRIORITY
	INTO    #tblSCP0106_RAW
    FROM    SCP_MST_CAPA_LOSS_PLAN_MDL_V A
    WHERE   1<>1

	INSERT INTO #tblSCP0106_RAW
    --SELECT    A.VER_ID
    --        , A.VER_SEQ
    SELECT    @p_version        AS VER_ID
            , @p_version_seq    AS VER_SEQ
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
			-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) START
			--, A.IPRV_GOL_DIVS_CD
            --, A.IPRV_GOL_RT
			-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) END
			, A.MSR_GR_CD
            , A.MSR_NVL
		    , A.LOSS_NM_EN
		    , A.LOSS_GR_NM_EN
		    , A.SORT_ORDER_NO
            , A.DAY_CNT
            , A.DAY_CNT_BASE
            , A.SPEED_PPM
            , A.SPEED_BASE_PPM
            , A.ASSIGN_PRIORITY
    FROM    SCP_MST_CAPA_LOSS_PLAN_MDL_V A
    WHERE   1=1
            AND A.MEASURE_VISIBLE = 'Y'
		    AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		    AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		    AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		    AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		    AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		    AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		    AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		    AND ((@p_nick_name	    IS NULL OR @p_nick_name	        = '') OR A.MDL_NM         IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_nick_name, ',')))
            AND SUBSTRING(A.YYYYMM, 1, 4) >= @v_from_yyyy
            AND SUBSTRING(A.YYYYMM, 1, 4) <= @v_to_yyyy;
    PRINT N'#tblSCP0106_RAW - END';

--TESTING:NOK
--select * from #tblSCP0106_RAW;return;
--select * from #tblSCP0106_RAW WHERE MSR_TP_CD = 'PROD_CAPA_M' AND YYYYMM = '2027';return;

    
    BEGIN -- Formation 은 Capa 이외 Meausre 배제
    DELETE #tblSCP0106_RAW
    WHERE   1=1
        AND OPERATION_ID = 'AFFFF'
        AND MSR_TP_CD NOT IN ('PROD_CAPA_D');
    END -- Formation 은 Capa 이외 Meausre 배제

--TESTING:NOK
--select * from #tblSCP0106_RAW WHERE OPERATION_ID = 'AFFFF' AND YYYYMM = '202410';return;
--select * from #tblSCP0106_RAW WHERE MSR_TP_CD = 'THRY_CAPA_D' AND YYYYMM = '202409';return;


	DECLARE @v_date_cols                    NVARCHAR(MAX) = N'';
	DECLARE @v_priority_cols                NVARCHAR(MAX) = N'';
	DECLARE @v_final_sum_cols               NVARCHAR(MAX) = N'';
	DECLARE @v_final_sum_priority_cols      NVARCHAR(MAX) = N'';
	DECLARE @v_final_cols                   NVARCHAR(MAX) = N'';
	DECLARE @v_final_priority_cols          NVARCHAR(MAX) = N'';

	SELECT      @v_date_cols       = @v_date_cols + '
			      , ' +
				    CASE
                        --WHEN CHARINDEX('M_00', COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 5, 6) THEN IPRV_GOL_RT END AS ' + COLUMN_NAME	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) 
                        WHEN CHARINDEX('M_01', COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 5, 6) THEN MSR_NVL END AS ' + COLUMN_NAME
					    WHEN CHARINDEX('Y_',   COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 3, 4) THEN MSR_NVL END AS ' + COLUMN_NAME
				    END
              , @v_priority_cols       = @v_priority_cols + '
			      , ' +
				    CASE
                        --WHEN CHARINDEX('M_00', COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 5, 6) THEN ASSIGN_PRIORITY END AS ' + COLUMN_NAME + '_ASSIGN_PRIORITY'	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) 
                        WHEN CHARINDEX('M_01', COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 5, 6) THEN ASSIGN_PRIORITY END AS ' + COLUMN_NAME + '_ASSIGN_PRIORITY'
					    WHEN CHARINDEX('Y_',   COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 3, 4) THEN ASSIGN_PRIORITY END AS ' + COLUMN_NAME + '_ASSIGN_PRIORITY'
				    END
              , @v_final_sum_cols      = @v_final_sum_cols + '
			      , AVG(' + COLUMN_NAME + ') AS ' + COLUMN_NAME
              , @v_final_sum_priority_cols      = @v_final_sum_priority_cols + '
			      , MAX(' + COLUMN_NAME + '_ASSIGN_PRIORITY) AS ' + COLUMN_NAME + '_ASSIGN_PRIORITY'
              , @v_final_cols      = @v_final_cols + '
			      , CASE
                        WHEN ' + COLUMN_NAME + ' = 0 THEN NULL
                        ELSE ' + COLUMN_NAME + '
                    END AS ' + COLUMN_NAME
              , @v_final_priority_cols      = @v_final_priority_cols + '
			      , ' + COLUMN_NAME + '_ASSIGN_PRIORITY AS ' + COLUMN_NAME + '_ASSIGN_PRIORITY'
	FROM    #tblSCP0106_DATE_COLS A
	ORDER BY SORT_ORDER_NO;

    --TESTING : OK
    --exec debug_log @v_final_sum_cols, 'T';return;
    --exec debug_log @v_final_cols, 'T';return;
    --exec debug_log @v_final_priority_cols, 'T';return;

    DECLARE     @v_sql  NVARCHAR(MAX)       = N'';

    SET @v_sql  = N'
    	IF OBJECT_ID(''tempdb..#tblSCP0106_FINAL'') IS NOT NULL
			DROP TABLE #tblSCP0106_FINAL;

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
                , MDL_NM
                , MSR_GR_CD
                , MSR_TP_CD
                , LOSS_NM_EN
                , LOSS_GR_NM_EN
                , SORT_ORDER_NO
                ----피봇이라 월별로 만들지 않으면 의미 없음!!!, DAY_CNT
                , DAY_CNT_BASE
                , SPEED_PPM
                , SPEED_BASE_PPM
                , PFRSLT_NVL
                , BASE_NVL
                --, IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) 
                ' + @v_date_cols + N'
                ' + @v_priority_cols + N'
        INTO    #tblSCP0106_FINAL
		FROM    #tblSCP0106_RAW A
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_FINAL
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
                , MDL_NM
                , MSR_GR_CD
                , MSR_TP_CD
                , LOSS_NM_EN
                , LOSS_GR_NM_EN
                , SORT_ORDER_NO
                ----피봇이라 월별로 만들지 않으면 의미 없음!!!, DAY_CNT
                , DAY_CNT_BASE
                , SPEED_PPM
                , SPEED_BASE_PPM
                , PFRSLT_NVL
                , BASE_NVL
                --, IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) 
                ' + @v_date_cols + N'
                ' + @v_priority_cols + N'
		FROM    #tblSCP0106_RAW A;

        --TESTING : NOK
        --select * from #tblSCP0106_FINAL;return;
        --select * from #tblSCP0106_FINAL WHERE MSR_TP_CD = ''THRY_CAPA_D'';return;


    	IF OBJECT_ID(''tempdb..#tblSCP0106_FINAL1'') IS NOT NULL
			DROP TABLE #tblSCP0106_FINAL1;

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
                , MDL_NM
                , MSR_GR_CD
                , MAX(LOSS_GR_NM_EN)        AS LOSS_GR_NM_EN
                , MSR_TP_CD
                , MAX(LOSS_NM_EN)           AS LOSS_NM_EN
                , MAX(SORT_ORDER_NO)        AS SORT_ORDER_NO
                ----피봇이라 월별로 만들지 않으면 의미 없음!!!, AVG(DAY_CNT)				AS DAY_CNT
                , MAX(DAY_CNT_BASE)         AS DAY_CNT_BASE
                , AVG(SPEED_PPM)			AS SPEED_PPM
                , AVG(SPEED_BASE_PPM)		AS SPEED_BASE_PPM
                , AVG(PFRSLT_NVL)           AS PFRSLT_NVL
                , AVG(BASE_NVL)             AS BASE_NVL
                --, MAX(IPRV_GOL_DIVS_CD)     AS IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) 
                ' + @v_final_sum_cols + N'
                ' + @v_final_sum_priority_cols + N'
        INTO    #tblSCP0106_FINAL1
		FROM    #tblSCP0106_FINAL
        WHERE   1<>1
        GROUP BY  VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , MDL_NM
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , MSR_GR_CD
                , MSR_TP_CD

        INSERT INTO #tblSCP0106_FINAL1
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
                , MDL_NM
                , MSR_GR_CD
                , MAX(LOSS_GR_NM_EN)        AS LOSS_GR_NM_EN
                , MSR_TP_CD
                , MAX(LOSS_NM_EN)           AS LOSS_NM_EN
                , MAX(SORT_ORDER_NO)        AS SORT_ORDER_NO
                ----피봇이라 월별로 만들지 않으면 의미 없음!!!, AVG(DAY_CNT)				AS DAY_CNT
                , MAX(DAY_CNT_BASE)         AS DAY_CNT_BASE
                , MAX(SPEED_PPM)			AS SPEED_PPM
                , MAX(SPEED_BASE_PPM)		AS SPEED_BASE_PPM
                , MAX(PFRSLT_NVL)           AS PFRSLT_NVL
                , MAX(BASE_NVL)             AS BASE_NVL
                --, MAX(IPRV_GOL_DIVS_CD)     AS IPRV_GOL_DIVS_CD	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) 
                ' + @v_final_sum_cols + N'
                ' + @v_final_sum_priority_cols + N'
		FROM    #tblSCP0106_FINAL
        WHERE   1=1
        GROUP BY  VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , MDL_NM
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , MSR_GR_CD
                , MSR_TP_CD;

        --TESTING : NOK
        --select * from #tblSCP0106_FINAL1;return;
        --select * from #tblSCP0106_FINAL WHERE MSR_TP_CD = ''THRY_CAPA_D'';
        --select * from #tblSCP0106_FINAL1 WHERE MSR_TP_CD = ''THRY_CAPA_D'' AND YYYYMM = ''202409'';return;


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
                , A.MDL_NM															AS NICK_NAME
                , A.MSR_GR_CD														AS MEASURE_GROUP
                , A.LOSS_GR_NM_EN													AS MEASURE_GROUP_NAME
                , A.MSR_TP_CD														AS MEASURE
                , A.LOSS_NM_EN														AS MEASURE_NAME
                , A.SORT_ORDER_NO
                ----피봇이라 월별로 만들지 않으면 의미 없음!!!, A.DAY_CNT
                , A.DAY_CNT_BASE
                , A.SPEED_PPM
                , A.SPEED_BASE_PPM
			    , A.PFRSLT_NVL														AS PFRSLT_QTY
			    , A.BASE_NVL														AS BASE_QTY
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) START
          --      , A.IPRV_GOL_DIVS_CD
		        --, CASE
          --          WHEN M.LOSS_CD IS NOT NULL THEN I.IPRV_GOL_TP_NM_EN -- 수정가능한 Measure 들만 개선/목표 표시
          --          ELSE ''''
		        --  END																AS IPRV_GOL_DIVS_NM
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) END
			    , dbo.FN_GET_DIVISION_NAME (A.DIVISION_ID)							AS DIVISION_NAME
			    , S.SITE_NAME								                        AS SITE_NAME
			    , P.PLANT_NAME								                        AS PLANT_NAME
			    , F.FACTORY_NAME						                            AS FACTORY_NAME
			    , L.LINE_NAME								                        AS LINE_NAME
			    , O.OPERATION_NAME
                , ROW_NUMBER() OVER (ORDER BY (SELECT 1))							AS IDX
                ' + @v_final_cols + N'
                ' + @v_final_priority_cols + N'
		FROM    #tblSCP0106_FINAL1 A
				LEFT JOIN #tblSCP0104_SITE S WITH(NOLOCK) ON
					    A.SITE_ID		    = S.SITE_ID
			    LEFT JOIN #tblSCP0104_COMPANY C WITH(NOLOCK) ON
					    A.COMPANY_ID		= C.COMPANY_ID
			    LEFT JOIN #tblSCP0104_PLANT P WITH(NOLOCK) ON
					    A.PLANT_ID          = P.PLANT_ID
			    LEFT JOIN #tblSCP0104_FACTORY F WITH(NOLOCK) ON
					    A.FACTORY_ID	    = F.FACTORY_ID
			    LEFT JOIN #tblSCP0104_LINE L WITH(NOLOCK) ON
					    A.LINE_ID		    = L.LINE_ID
			    LEFT JOIN #tblSCP0104_OPERATION O ON
					    A.OPERATION_ID		= O.OPERATION_ID
                LEFT JOIN #tblSCP0106_MEASURE_EDITABLE M ON
				        A.MSR_TP_CD 		= M.LOSS_CD
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) START
                --LEFT JOIN #tblSCP0106_IPRV I ON
				--        A.IPRV_GOL_DIVS_CD  = I.IPRV_GOL_TP
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) END
        WHERE   1=1
            --AND A.MSR_TP_CD = ''PROD_CAPA_D''
        ORDER BY  A.VER_ID
				, A.VER_SEQ
                , A.DIVISION_ID
		        , A.COMPANY_ID
			    , S.SITE_NAME
			    , P.PLANT_NAME
			    , F.FACTORY_NAME
			    , L.LINE_NAME
		        , A.MDL_NM
		        , A.OPERATION_ID
		        , A.ELTR_LN_TP_CD
		        , A.SORT_ORDER_NO;
                ';

    --TESTING : OK
   --exec debug_log @v_sql, 'T';return;

PRINT CONCAT('ELAPSED_TIME-Final : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

    EXEC(@v_sql);

    PRINT N'Measure - UI 계산용 - BEGIN'
    BEGIN
        SELECT    A.ATTRIBUTE3                                                  AS LOSS_GR_CD
                , A.SEGMENT1                                                    AS LOSS_CD
                , A.ATTRIBUTE6                                                  AS LOSS_GR_NM_KO
                , A.ATTRIBUTE7                                                  AS LOSS_GR_NM_EN
                , A.ATTRIBUTE4                                                  AS LOSS_NM_KO
                , A.ATTRIBUTE5                                                  AS LOSS_NM_EN
                , A.ATTRIBUTE8                                                  AS FIRST_MODEL_TARGET_YN
                , A.ATTRIBUTE9                                                  AS SECOND_TARGET_YN
                --, A.ATTRIBUTE10                                                 AS IPRV_GOL_TP	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) 
                , A.ATTRIBUTE13                                                 AS CURRENT_TARGET_YN
                , A.ATTRIBUTE14                                                 AS FIRST_LINE_TARGET_YN
                , A.DISPLAY_SEQ
                , CONVERT(INT, ROW_NUMBER() OVER (ORDER BY A.DISPLAY_SEQ) - 1)  AS IDX
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
                JOIN #tblSCP0106_MEASURE_VISIBLE B ON
                        A.SEGMENT1 = B.MEASURE
        WHERE   1=1
            AND LOOKUP_TYPE = 'SCP_CAPA_LOSS_MEASURE'
            --AND ATTRIBUTE8 = 'Y'
        ORDER BY DISPLAY_SEQ;
    END
    PRINT N'Measure - UI 계산용 - END'


    PRINT N'DAY_CNT - UI 계산용 - BEGIN'
    BEGIN
        SELECT    A.VER_ID
                , A.VER_SEQ
                , A.DIVISION_ID
			    , A.MDL_NM          AS NICK_NAME
			    , A.PLANT_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.FACTORY_ID
			    , A.YYYYMM
				, MAX(A.DAY_CNT)         AS DAY_CNT
                , MAX(A.SPEED_PPM)       AS SPEED_PPM
                , MAX(A.SPEED_BASE_PPM)  AS SPEED_BASE_PPM
        FROM    #tblSCP0106_RAW A
        GROUP BY A.VER_ID
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
			    , A.YYYYMM
        UNION ALL
        SELECT    A.VER_ID
                , A.VER_SEQ
                , A.DIVISION_ID
			    , '-'               AS NICK_NAME
			    , A.PLANT_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.FACTORY_ID
			    , A.YYYYMM
				, MAX(A.DAY_CNT)         AS DAY_CNT
                , MAX(A.SPEED_PPM)       AS SPEED_PPM
                , MAX(A.SPEED_BASE_PPM)  AS SPEED_BASE_PPM
        FROM    #tblSCP0106_RAW A
        GROUP BY A.VER_ID
                , A.VER_SEQ
                , A.DIVISION_ID
			    , A.PLANT_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.FACTORY_ID
			    , A.YYYYMM
    END
    PRINT N'DAY_CNT - UI 계산용 - END'


	IF OBJECT_ID('tempdb..#tblSCP0104_COMPANY') IS NOT NULL
		DROP TABLE #tblSCP0104_COMPANY;
	IF OBJECT_ID('tempdb..#tblSCP0104_FACTORY') IS NOT NULL
		DROP TABLE #tblSCP0104_FACTORY;
	IF OBJECT_ID('tempdb..#tblSCP0104_LINE') IS NOT NULL
		DROP TABLE #tblSCP0104_LINE;
	IF OBJECT_ID('tempdb..#tblSCP0104_PLANT') IS NOT NULL
		DROP TABLE #tblSCP0104_PLANT;
	IF OBJECT_ID('tempdb..#tblSCP0104_SITE') IS NOT NULL
		DROP TABLE #tblSCP0104_SITE;
	IF OBJECT_ID('tempdb..#tblSCP0106_DATE_COLS') IS NOT NULL
		DROP TABLE #tblSCP0106_DATE_COLS;
	IF OBJECT_ID('tempdb..#tblSCP0106_FINAL1') IS NOT NULL
		DROP TABLE #tblSCP0106_FINAL1;
	IF OBJECT_ID('tempdb..#tblSCP0106_FINAL') IS NOT NULL
		DROP TABLE #tblSCP0106_FINAL;
	--IF OBJECT_ID('tempdb..#tblSCP0106_IPRV') IS NOT NULL	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) 
	--	DROP TABLE #tblSCP0106_IPRV;
	IF OBJECT_ID('tempdb..#tblSCP0106_MEASURE_ALL') IS NOT NULL
		DROP TABLE #tblSCP0106_MEASURE_ALL;
	IF OBJECT_ID('tempdb..#tblSCP0106_MEASURE_EDITABLE') IS NOT NULL
		DROP TABLE #tblSCP0106_MEASURE_EDITABLE;
	IF OBJECT_ID('tempdb..#tblSCP0106_MEASURE_VISIBLE') IS NOT NULL
		DROP TABLE #tblSCP0106_MEASURE_VISIBLE;
	IF OBJECT_ID('tempdb..#tblSCP0106_MONTH_DAY_CNT') IS NOT NULL
		DROP TABLE #tblSCP0106_MONTH_DAY_CNT;
	IF OBJECT_ID('tempdb..#tblSCP0106_PLAN_TP') IS NOT NULL
		DROP TABLE #tblSCP0106_PLAN_TP;
	IF OBJECT_ID('tempdb..#tblSCP0106_RAW') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW;
	IF OBJECT_ID('tempdb..#tblSCP0104_OPERATION') IS NOT NULL
		DROP TABLE #tblSCP0104_OPERATION;
END

