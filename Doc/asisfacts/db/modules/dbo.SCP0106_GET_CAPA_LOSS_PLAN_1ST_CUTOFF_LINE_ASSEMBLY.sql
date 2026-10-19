
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0106_GET_CAPA_LOSS_PLAN_1ST_CUTOFF_LINE_ASSEMBLY
 * Description  :
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/19   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/07/11   chaan        V1.1.4                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 라인별 설비정보 조인시 Operation 추가
 *                                                                                                           - FACTROY_NAME 시노님 참조로 변경
 * 2024/08/05   chaan        V1.1.5                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - FLOAT 로 변형
 * 2024/08/29   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - DAY_CNT 로직 수정 - SOP 적용
 * 2024.11.04	chaan        V1.1.9                PJ20239037 LGES CPS VOE 반영 및 고도화                     - 컬럼순서 변경 : 공정, 모델 -> 모델, 공정
 * 2024.12.09	chaan        V1.1.10               PJ20239037 LGES CPS VOE 반영 및 고도화                     - Pre 예외 처리
 * 2025/02/10   mrchois      V1.1.11               PJ20249346  LGES SCP 개선과제 이행	 - Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정
*/


--CREATE PROCEDURE [dbo].[SCP0106_GET_CAPA_LOSS_PLAN_1ST_CUTOFF_LINE_ASSEMBLY]
CREATE PROCEDURE [dbo].[SCP0106_GET_CAPA_LOSS_PLAN_1ST_CUTOFF_LINE_ASSEMBLY]
	  @p_version			NVARCHAR(10)
	, @p_version_seq		TINYINT
	, @p_prog_stat			NVARCHAR(1)
	, @p_division_id		NVARCHAR(30)
	, @p_site_id			NVARCHAR(MAX)
	, @p_plant_id  			NVARCHAR(MAX)
	, @p_factory_id			NVARCHAR(MAX)
	, @p_line_id			NVARCHAR(MAX)
	, @p_operation_id		NVARCHAR(MAX)
    , @p_electrode_type		NVARCHAR(MAX)
	, @p_nick_name			NVARCHAR(MAX)
	, @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
	, @p_user_id			NVARCHAR(30)
	, @debug_mode			NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_version			NVARCHAR(10)		= N'202410';
	--DECLARE @p_version_seq		TINYINT             = 10;
	--DECLARE @p_prog_stat		NVARCHAR(1)         = N'1';
	--DECLARE @p_division_id		NVARCHAR(30)		= N'81';
	--DECLARE @p_site_id			NVARCHAR(MAX)		= N'';
	--DECLARE @p_plant_id  		NVARCHAR(MAX)		= N'';
	--DECLARE @p_factory_id		NVARCHAR(MAX)		= N'';
	--DECLARE @p_line_id			NVARCHAR(MAX)		= N'';
	--DECLARE @p_operation_id		NVARCHAR(MAX)		= N'';
 --   DECLARE @p_nick_name	    NVARCHAR(MAX)		= N'';
	--DECLARE @p_electrode_type	NVARCHAR(MAX)		= N'';
	--DECLARE @p_program_id		NVARCHAR(100)		= N'SCP0106';
	--DECLARE @p_sheet_name		NVARCHAR(100)		= N'1ST_CUTOFF_LINE_ASSEMBLY';
 --   DECLARE @p_user_id			NVARCHAR(30)		= N'iamarock';
 --   DECLARE @debug_mode			NVARCHAR(1)			= N'F';



    DECLARE @v_from_yyyy                NVARCHAR(8)			= N'';
    DECLARE @v_from_yyyymm				NVARCHAR(6)			= CONVERT(NVARCHAR(6), DATEADD(MM, 1, CONVERT(DATETIME, @p_version + '01')), 112);
	DECLARE @v_result_from_yyyymm		NVARCHAR(6)         = N'';
	DECLARE @v_result_to_yyyymm			NVARCHAR(6)         = N'';

    SET @v_from_yyyy            = SUBSTRING(@p_version, 1, 4);
    SET @v_result_from_yyyymm   = CONVERT(CHAR(8), DATEADD(MM, -3, CONVERT(DATETIME, @p_version + '01')), 112);
    SET @v_result_to_yyyymm     = CONVERT(CHAR(8), DATEADD(MM, -1, CONVERT(DATETIME, @p_version + '01')), 112);

    PRINT CONCAT('@p_version : ', @p_version);
    PRINT CONCAT('@p_version_seq : ', @p_version_seq);
    PRINT CONCAT('@v_result_from_yyyymm : ', @v_result_from_yyyymm);
    PRINT CONCAT('@v_result_to_yyyymm : ', @v_result_to_yyyymm);
    --return;

    
    --생산게획 확정구간 수정 방지용 - begin
	IF OBJECT_ID('tempdb..#tblSCP0106_VERSION') IS NOT NULL
		DROP TABLE #tblSCP0106_VERSION;

    SELECT  *
    INTO    #tblSCP0106_VERSION
    FROM    SCP_MST_CAPA_VERSION A
    WHERE   1=1
        AND A.VER_ID             = @p_version
        AND A.VER_SEQ            = @p_version_seq
        AND A.DIVISION_ID        = @p_division_id
    --생산게획 확정구간 수정 방지용 - end


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


		IF OBJECT_ID('tempdb..#tbl_DAY_CNT') IS NOT NULL
			DROP TABLE #tbl_DAY_CNT;

		SELECT    DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, SOP_DT
				, SOP_YM			        AS YYYYMM
				, SOP_DDN			        AS DAY_CNT
        INTO    #tbl_DAY_CNT
		FROM    SCP_MST_CAPA_LINE_SOP WITH(NOLOCK)
		WHERE   1<>1

        INSERT INTO #tbl_DAY_CNT
		SELECT    DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, SOP_DT
				, SOP_YM			        AS YYYYMM
				, SOP_DDN			        AS DAY_CNT
		FROM    SCP_MST_CAPA_LINE_SOP WITH(NOLOCK)
		WHERE   1=1
			AND VALID_YN        = 'Y'

--TESTING : NOK
--select * from #tbl_DAY_CNT;return;


		IF OBJECT_ID('tempdb..#tbl_DAY_CNT_YEAR') IS NOT NULL
			DROP TABLE #tbl_DAY_CNT_YEAR;

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
				, DAY_CNT
        INTO    #tbl_DAY_CNT_YEAR
		FROM    #tbl_DAY_CNT
		WHERE   1<>1


        INSERT INTO #tbl_DAY_CNT_YEAR
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
		FROM    #tbl_DAY_CNT
		WHERE   1=1

--TESTING : NOK
--select * from #tbl_DAY_CNT_YEAR;return;



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
        SELECT    A.ATTRIBUTE3        AS LOSS_GR_CD
                , A.SEGMENT1          AS LOSS_CD
                , A.ATTRIBUTE6        AS LOSS_GR_NM_KO
                , A.ATTRIBUTE7        AS LOSS_GR_NM_EN
                , A.ATTRIBUTE4        AS LOSS_NM_KO
                , A.ATTRIBUTE5        AS LOSS_NM_EN
                , A.ATTRIBUTE8        AS TARGET_YN
                , A.DISPLAY_SEQ
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
                    WHEN @p_sheet_name LIKE 'CUTOFF_MODEL%'     THEN A.ATTRIBUTE8   --MODEL_TARGET_YN
                    WHEN @p_sheet_name LIKE '1ST_CUTOFF_LINE%'  THEN A.ATTRIBUTE14  --1ST_LINE_TARGET_YN
                    WHEN @p_sheet_name LIKE '2ND_CUTOFF_LINE%'  THEN A.ATTRIBUTE9   --2ND_LINE_TARGET_YN
                    ELSE A.ATTRIBUTE13                                              --CURRENT_TARGET_YN
                  END AS TARGET_YN
                , A.DISPLAY_SEQ
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1=1
            AND A.LOOKUP_TYPE  = 'SCP_CAPA_LOSS_MEASURE'
            AND A.VALID_YN  = 'Y';

--TESTING : NOK
--select * from #tblSCP0106_MEASURE_ALL;return;


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
--select * from #tblSCP0106_MEASURE_VISIBLE;


	    IF OBJECT_ID('tempdb..#tblSCP0106_MEASURE') IS NOT NULL
			DROP TABLE #tblSCP0106_MEASURE;

        --빈테이블 생성
        SELECT    A.LOSS_GR_CD
                , A.LOSS_CD
                , A.LOSS_GR_NM_KO
                , A.LOSS_GR_NM_EN
                , A.LOSS_NM_KO
                , A.LOSS_NM_EN
                , A.DISPLAY_SEQ
        INTO    #tblSCP0106_MEASURE
        FROM    #tblSCP0106_MEASURE_ALL A
        WHERE   1<>1;

        INSERT INTO #tblSCP0106_MEASURE
        SELECT    A.LOSS_GR_CD
                , A.LOSS_CD
                , A.LOSS_GR_NM_KO
                , A.LOSS_GR_NM_EN
                , A.LOSS_NM_KO
                , A.LOSS_NM_EN
                , A.DISPLAY_SEQ
        FROM    #tblSCP0106_MEASURE_ALL A
                JOIN #tblSCP0106_MEASURE_VISIBLE B ON
                        A.LOSS_CD = B.MEASURE
        WHERE   1=1
            --AND A.TARGET_YN = 'Y';

--TESTING : NOK
--select * from #tblSCP0106_MEASURE;return;


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


    PRINT N'GET - #tblSCP0106_LINE_RAW_TEMP - BEGIN';
	IF OBJECT_ID('tempdb..#tblSCP0106_LINE_RAW_TEMP') IS NOT NULL
		DROP TABLE #tblSCP0106_LINE_RAW_TEMP;

    --빈테이블 생성
    SELECT    @p_version            AS VER_ID
            , @p_version_seq        AS VER_SEQ
            , A.DIVISION_ID
			, '-'                   AS MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
			, A.MSR_DDN
            , CONVERT(INT, NULL)  AS DAY_CNT
    INTO    #tblSCP0106_LINE_RAW_TEMP
    FROM	SCP_MST_CAPA_LOSS_PLAN_LN A WITH(NOLOCK)
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_LINE_RAW_TEMP
    SELECT    @p_version            AS VER_ID
            , @p_version_seq        AS VER_SEQ
            , A.DIVISION_ID
			, '-'                   AS MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
			, A.MSR_DDN
			, CASE
                WHEN LEN(A.YYYYMM) = 4 THEN
                    CASE
                        WHEN A.YYYYMM IN ('RSLT', 'PRVS', 'BASE') THEN DAY(EOMONTH(CONVERT(DATE, @p_version + '01')))     -- 버전 월별 총일수
                        ELSE 
					        CASE
						        --WHEN ISNULL(DY.DAY_CNT, 0) = 0 THEN DATEDIFF(DAY, SUBSTRING(A.YYYYMM, 1, 4) + '0101', SUBSTRING(A.YYYYMM, 1, 4) + '1231') + 1   -- 연도별 & SOP 없을때
						        WHEN DY.DAY_CNT IS NULL THEN DATEDIFF(DAY, SUBSTRING(A.YYYYMM, 1, 4) + '0101', SUBSTRING(A.YYYYMM, 1, 4) + '1231') + 1   -- 연도별 & SOP 없을때
						        ELSE DY.DAY_CNT                                                                                                                 -- 연도별 & SOP 존재
					        END
                    END
                ELSE 
					CASE
						WHEN ISNULL(DC.DAY_CNT, 0) = 0 THEN DAY(EOMONTH(CONVERT(DATE, A.YYYYMM + '01')))                                -- 월별 & SOP 없을때
						ELSE DC.DAY_CNT                                                                                                 -- 월별 & SOP 존재
					END
            END AS DAY_CNT
    FROM	SCP_MST_CAPA_LOSS_PLAN_LN A WITH(NOLOCK)
			LEFT JOIN #tbl_DAY_CNT DC ON
					A.DIVISION_ID		= DC.DIVISION_ID
				AND A.COMPANY_ID		= DC.COMPANY_ID
				AND A.SITE_ID			= DC.SITE_ID
				AND A.PLANT_ID			= DC.PLANT_ID
				AND A.FACTORY_ID		= DC.FACTORY_ID
				AND A.LINE_ID			= DC.LINE_ID
				AND A.OPERATION_ID		= DC.OPERATION_ID
				AND A.ELTR_LN_TP_CD		= DC.ELTR_LN_TP_CD
				AND A.YYYYMM			= DC.YYYYMM
			LEFT JOIN #tbl_DAY_CNT_YEAR DY ON
					A.DIVISION_ID		= DY.DIVISION_ID
				AND A.COMPANY_ID		= DY.COMPANY_ID
				AND A.SITE_ID			= DY.SITE_ID
				AND A.PLANT_ID			= DY.PLANT_ID
				AND A.FACTORY_ID		= DY.FACTORY_ID
				AND A.LINE_ID			= DY.LINE_ID
				AND A.OPERATION_ID		= DY.OPERATION_ID
				AND A.ELTR_LN_TP_CD		= DY.ELTR_LN_TP_CD
				AND A.YYYYMM			= DY.YYYY
    WHERE   1=1
		    AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		    AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		    AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		    AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		    AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		    AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		    ------AND A.OPERATION_ID IN ('A9000') --PKG 만 조회
		    --AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
            AND SUBSTRING(A.YYYYMM, 1, 4) >= @v_from_yyyy
            AND SUBSTRING(A.YYYYMM, 1, 4) <= @v_to_yyyy
    PRINT N'GET - #tblSCP0106_LINE_RAW_TEMP - END';

--TESTING : NOK
--select * from #tblSCP0106_LINE_RAW_TEMP;return;
--select * from #tbl_DAY_CNT_YEAR;
--select * from #tblSCP0106_LINE_RAW_TEMP WHERE YYYYMM = '2027';return;


    BEGIN -- Formation 은 Capa 이외 Meausre 배제
    DELETE #tblSCP0106_LINE_RAW_TEMP
    WHERE   1=1
        AND OPERATION_ID = 'AFFFF'
        AND MSR_TP_CD NOT IN ('PROD_CAPA_D');
    END -- Formation 은 Capa 이외 Meausre 배제

--TESTING:NOK
--select * from #tblSCP0106_RAW WHERE OPERATION_ID = 'AFFFF';return;


	IF OBJECT_ID('tempdb..#tblSCP0106_LINE_RAW_SD_RT') IS NOT NULL
		DROP TABLE #tblSCP0106_LINE_RAW_SD_RT;

    --빈테이블 생성
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
			, A.MSR_DDN
    INTO    #tblSCP0106_LINE_RAW_SD_RT
    FROM	#tblSCP0106_LINE_RAW_TEMP A WITH(NOLOCK)
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_LINE_RAW_SD_RT
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
			, A.MSR_DDN
    FROM	#tblSCP0106_LINE_RAW_TEMP A WITH(NOLOCK)
    WHERE   1=1
        AND A.MSR_TP_CD = 'SD_RT';

--TESTING : NOK
--select * from #tblSCP0106_LINE_RAW_SD_RT;return;
    

	IF OBJECT_ID('tempdb..#tblSCP0106_LINE_RAW_TD_RT') IS NOT NULL
		DROP TABLE #tblSCP0106_LINE_RAW_TD_RT;

    --빈테이블 생성
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
			, A.MSR_DDN
    INTO    #tblSCP0106_LINE_RAW_TD_RT
    FROM	#tblSCP0106_LINE_RAW_TEMP A WITH(NOLOCK)
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_LINE_RAW_TD_RT
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
			, A.MSR_DDN
    FROM	#tblSCP0106_LINE_RAW_TEMP A WITH(NOLOCK)
    WHERE   1=1
        AND A.MSR_TP_CD = 'TD_RT';

--TESTING : NOK
--select * from #tblSCP0106_LINE_RAW_TD_RT;return;
    

	IF OBJECT_ID('tempdb..#tblSCP0106_LINE_RAW_MC_RT') IS NOT NULL
		DROP TABLE #tblSCP0106_LINE_RAW_MC_RT;

    --빈테이블 생성
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
			, A.MSR_DDN
    INTO    #tblSCP0106_LINE_RAW_MC_RT
    FROM	#tblSCP0106_LINE_RAW_TEMP A WITH(NOLOCK)
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_LINE_RAW_MC_RT
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
			, A.MSR_DDN
    FROM	#tblSCP0106_LINE_RAW_TEMP A WITH(NOLOCK)
    WHERE   1=1
        AND A.MSR_TP_CD = 'MC_RT';

--TESTING : NOK
--select * from #tblSCP0106_LINE_RAW_MC_RT;return;


    PRINT N'GET - RAW TEMP - BEGIN';
	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_TEMP_ALL') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_TEMP_ALL;

    --빈테이블 생성
    SELECT    @p_version            AS VER_ID
            , @p_version_seq        AS VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
			, A.MSR_DDN
    INTO    #tblSCP0106_RAW_TEMP_ALL
    FROM	SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF A WITH(NOLOCK)
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_RAW_TEMP_ALL
    SELECT    A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, AVG(A.MSR_NVL)        AS MSR_NVL
			, AVG(A.MSR_DDN)        AS MSR_DDN
    FROM	SCP_MST_CAPA_LOSS_PLAN_MDL_CUTF A WITH(NOLOCK)
    WHERE   1=1
            AND VER_ID  = @p_version
            AND VER_SEQ = @p_version_seq
		    AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		    AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		    AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		    AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		    AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		    AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		    ------AND A.OPERATION_ID = 'A9000' --PKG 만 조회
		    --AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		    AND ((@p_nick_name	    IS NULL OR @p_nick_name   		= '') OR (A.MDL_NM LIKE '%' + @p_nick_name + '%'))
            --AND SUBSTRING(A.YYYYMM, 1, 4) >= @v_from_yyyy
            --AND SUBSTRING(A.YYYYMM, 1, 4) <= @v_to_yyyy
    GROUP BY  A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD;

--TESTGING : NOK
--select * from #tblSCP0106_RAW_TEMP_ALL WHERE YYYYMM = '202408' AND MSR_TP_CD = 'AV_RT';return;
--select * from #tblSCP0106_RAW_TEMP_ALL WHERE YYYYMM = '202408' AND MSR_TP_CD = 'WT_RT';return;


	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_PROD_CAPA_D_MDL') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_PROD_CAPA_D_MDL;

    SELECT    A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
    INTO    #tblSCP0106_RAW_PROD_CAPA_D_MDL
    FROM	#tblSCP0106_RAW_TEMP_ALL A
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_RAW_PROD_CAPA_D_MDL
    SELECT    A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
    FROM	#tblSCP0106_RAW_TEMP_ALL A
    WHERE   1=1
        AND A.MSR_TP_CD = 'PROD_CAPA_D';

--TESTGING : NOK
--select * from #tblSCP0106_RAW_TEMP_ALL;
--select * from #tblSCP0106_RAW_PROD_CAPA_D_MDL WHERE YYYYMM = '202408';return;


	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_TEMP_SCP_PROD_PLAN_KEY_LN') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_TEMP_SCP_PROD_PLAN_KEY_LN;

    --빈테이블 생성
    SELECT    A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.YYYYMM
    INTO    #tblSCP0106_RAW_TEMP_SCP_PROD_PLAN_KEY_LN
    FROM	#tblSCP0106_RAW_TEMP_ALL A
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_RAW_TEMP_SCP_PROD_PLAN_KEY_LN
    SELECT    A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.YYYYMM
    FROM	#tblSCP0106_RAW_TEMP_ALL A
    WHERE   1=1
        AND A.MSR_TP_CD = 'SCP_PROD_PLAN'
    GROUP BY  A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.YYYYMM;

--TESTGING : NOK
--select * from #tblSCP0106_RAW_TEMP_ALL
--    WHERE   1=1
--        AND MSR_TP_CD = 'SCP_PROD_PLAN'

--select * from #tblSCP0106_RAW_TEMP_SCP_PROD_PLAN_KEY_LN;return;

	IF OBJECT_ID('tempdb..#tblSCP0106_LINE_ASSIGN_MDL') IS NOT NULL
		DROP TABLE #tblSCP0106_LINE_ASSIGN_MDL;

    SELECT    @p_version            AS VER_ID
            , @p_version_seq        AS VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			----, A.ELTR_LN_TP_CD
			, A.ITEM_ID
			, A.NICK_NAME
			, A.YYYYMM
			, A.ASSIGN_PRIORITY
    INTO    #tblSCP0106_LINE_ASSIGN_MDL
	FROM    SCP_MST_CAPA_LINE_ASSIGN A WITH(NOLOCK)
	WHERE   1<>1

    INSERT INTO #tblSCP0106_LINE_ASSIGN_MDL
    SELECT    @p_version            AS VER_ID
            , @p_version_seq        AS VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ITEM_ID
			, A.NICK_NAME
			, A.YYYYMM
			, MAX(A.ASSIGN_PRIORITY)    AS ASSIGN_PRIORITY
	FROM    SCP_MST_CAPA_LINE_ASSIGN A WITH(NOLOCK)
	WHERE   1=1
		AND VALID_YN = 'Y'
		AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		------AND A.OPERATION_ID = 'A9000' --PKG 만 조회
    GROUP BY  A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ITEM_ID
			, A.NICK_NAME
			, A.YYYYMM
--TESTING : NOK
--select * from #tblSCP0106_LINE_ASSIGN_MDL;return;


	IF OBJECT_ID('tempdb..#tblSCP0106_LINE_ASSIGN_LN') IS NOT NULL
		DROP TABLE #tblSCP0106_LINE_ASSIGN_LN;

    SELECT    A.VER_ID
            , A.VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.YYYYMM
			, A.ASSIGN_PRIORITY
    INTO    #tblSCP0106_LINE_ASSIGN_LN
	FROM    #tblSCP0106_LINE_ASSIGN_MDL A
	WHERE   1<>1

    INSERT INTO #tblSCP0106_LINE_ASSIGN_LN
    SELECT    A.VER_ID
            , A.VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.YYYYMM
			, MAX(A.ASSIGN_PRIORITY)    AS ASSIGN_PRIORITY
	FROM    #tblSCP0106_LINE_ASSIGN_MDL A
	WHERE   1=1
    GROUP BY  A.VER_ID
            , A.VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.YYYYMM
--TESTING : NOK
--select * from #tblSCP0106_LINE_ASSIGN_LN;return;


    INSERT INTO #tblSCP0106_RAW_TEMP_ALL
    SELECT    @p_version            AS VER_ID
            , @p_version_seq        AS VER_SEQ
            , A.DIVISION_ID
			, '-'                   AS MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, AVG(A.MSR_NVL)        AS MSR_NVL
			, AVG(A.MSR_DDN)        AS MSR_DDN
    FROM	#tblSCP0106_LINE_RAW_TEMP A
    WHERE   1=1
		    AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		    AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		    AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		    AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		    AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		    AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		    ------AND A.OPERATION_ID = 'A9000' --PKG 만 조회
		    --AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
            --AND SUBSTRING(A.YYYYMM, 1, 4) >= @v_from_yyyy
            --AND SUBSTRING(A.YYYYMM, 1, 4) <= @v_to_yyyy
    GROUP BY  A.DIVISION_ID
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD;
--TESTGING : NOK
--select * from #tblSCP0106_RAW_TEMP_ALL;return;


	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_TEMP') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_TEMP;

    --빈테이블 생성
    SELECT    A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
			, A.MSR_DDN
    INTO    #tblSCP0106_RAW_TEMP
    FROM	#tblSCP0106_RAW_TEMP_ALL A
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_RAW_TEMP
    SELECT    A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, AVG(A.MSR_NVL)        AS MSR_NVL
			, AVG(A.MSR_DDN)        AS MSR_DDN
    FROM	#tblSCP0106_RAW_TEMP_ALL A
    WHERE   1=1
    GROUP BY  A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD;

    PRINT N'GET - RAW TEMP - END';


--TESTING : NOK
--select * from #tblSCP0106_RAW_TEMP where YYYYMM = '202405';return;


    PRINT N'GET - RAW - SUM - BEGIN';
	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_SUM_LN') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_SUM_LN;

    --빈테이블 생성

    --빈테이블 생성
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, '-'                       AS MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
    INTO    #tblSCP0106_RAW_SUM_LN
    FROM	#tblSCP0106_RAW_TEMP A
    WHERE   1<>1

    INSERT INTO #tblSCP0106_RAW_SUM_LN
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, '-'                       AS MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, 'SCP_PROD_PLAN_DDN'       AS MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, SUM(A.MSR_DDN)            AS MSR_NVL
    FROM	#tblSCP0106_RAW_TEMP A
    WHERE   1=1
        AND A.MSR_TP_CD = 'AV_RT'
        AND A.MDL_NM <> '-'
    GROUP BY  A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD;
    PRINT N'GET - RAW - SUM - END';

--TESTING : NOK
--select * from #tblSCP0106_RAW_TEMP WHERE YYYYMM = '202504';
--select * from #tblSCP0106_RAW_SUM_LN WHERE YYYYMM = '202504';return;


	IF OBJECT_ID('tempdb..#tblSCP0106_LINE_RAW') IS NOT NULL
		DROP TABLE #tblSCP0106_LINE_RAW;

    --빈테이블 생성
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
			, A.MSR_DDN
			, A.DAY_CNT
			, A.MSR_NVL AS SD_RT
			, A.MSR_NVL AS TD_RT
			, A.MSR_NVL AS MC_RT
			, A.MSR_NVL AS LN_SUM
    INTO    #tblSCP0106_LINE_RAW
    FROM	#tblSCP0106_LINE_RAW_TEMP A WITH(NOLOCK)
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_LINE_RAW
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
            , CASE
                WHEN A.MSR_TP_CD = 'WT_RT' THEN (A.DAY_CNT - (S.MSR_NVL + T.MSR_NVL + M.MSR_NVL + D.MSR_NVL))
                ELSE A.MSR_NVL
              END AS MSR_NVL
			, A.MSR_DDN
			, A.DAY_CNT
			, S.MSR_NVL AS SD_RT
			, T.MSR_NVL AS TD_RT
			, M.MSR_NVL AS MC_RT
			, D.MSR_NVL AS LN_SUM
    FROM	#tblSCP0106_LINE_RAW_TEMP A
            LEFT JOIN #tblSCP0106_LINE_RAW_SD_RT S ON
                    A.VER_ID			= S.VER_ID
                AND A.VER_SEQ			= S.VER_SEQ
                AND A.DIVISION_ID		= S.DIVISION_ID
                AND A.PLANT_ID			= S.PLANT_ID
                AND A.LINE_ID			= S.LINE_ID
                AND A.OPERATION_ID		= S.OPERATION_ID
                AND A.COMPANY_ID		= S.COMPANY_ID
                AND A.SITE_ID			= S.SITE_ID
                AND A.FACTORY_ID		= S.FACTORY_ID
                AND A.YYYYMM			= S.YYYYMM
            LEFT JOIN #tblSCP0106_LINE_RAW_TD_RT T ON
                    A.VER_ID			= T.VER_ID
                AND A.VER_SEQ			= T.VER_SEQ
                AND A.DIVISION_ID		= T.DIVISION_ID
                AND A.PLANT_ID			= T.PLANT_ID
                AND A.LINE_ID			= T.LINE_ID
                AND A.OPERATION_ID		= T.OPERATION_ID
                AND A.COMPANY_ID		= T.COMPANY_ID
                AND A.SITE_ID			= T.SITE_ID
                AND A.FACTORY_ID		= T.FACTORY_ID
                AND A.YYYYMM			= T.YYYYMM
            LEFT JOIN #tblSCP0106_LINE_RAW_MC_RT M ON
                    A.VER_ID			= M.VER_ID
                AND A.VER_SEQ			= M.VER_SEQ
                AND A.DIVISION_ID		= M.DIVISION_ID
                AND A.PLANT_ID			= M.PLANT_ID
                AND A.LINE_ID			= M.LINE_ID
                AND A.OPERATION_ID		= M.OPERATION_ID
                AND A.COMPANY_ID		= M.COMPANY_ID
                AND A.SITE_ID			= M.SITE_ID
                AND A.FACTORY_ID		= M.FACTORY_ID
                AND A.YYYYMM			= M.YYYYMM
            LEFT JOIN #tblSCP0106_RAW_SUM_LN D ON
                    A.VER_ID			= D.VER_ID
                AND A.VER_SEQ			= D.VER_SEQ
                AND A.DIVISION_ID		= D.DIVISION_ID
                AND A.PLANT_ID			= D.PLANT_ID
                AND A.LINE_ID			= D.LINE_ID
                AND A.OPERATION_ID		= D.OPERATION_ID
                AND A.COMPANY_ID		= D.COMPANY_ID
                AND A.SITE_ID			= D.SITE_ID
                AND A.FACTORY_ID		= D.FACTORY_ID
                AND A.YYYYMM			= D.YYYYMM
        WHERE   1=1

--TESTING : NOK
--select * from #tblSCP0106_LINE_RAW WHERE YYYYMM = '202408';return;
--select * from #tblSCP0106_LINE_RAW_TEMP WHERE YYYYMM = '202408';
--select * from #tblSCP0106_LINE_RAW_SD_RT WHERE YYYYMM = '202408';
--select * from #tblSCP0106_LINE_RAW_TD_RT WHERE YYYYMM = '202408';
--select * from #tblSCP0106_LINE_RAW_MC_RT WHERE YYYYMM = '202408';
--select * from #tblSCP0106_RAW_SUM_LN WHERE YYYYMM = '202408';
--select * from #tblSCP0106_LINE_RAW WHERE YYYYMM = '202408';return;

	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_SUM_MDL') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_SUM_MDL;

    --빈테이블 생성

    --빈테이블 생성
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
    INTO    #tblSCP0106_RAW_SUM_MDL
    FROM	#tblSCP0106_RAW_TEMP A
    WHERE   1<>1

    INSERT INTO #tblSCP0106_RAW_SUM_MDL
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, 'SCP_PROD_PLAN_DDN'       AS MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, AVG(A.MSR_DDN)            AS MSR_NVL
    FROM	#tblSCP0106_RAW_TEMP A
    WHERE   1=1
        AND A.MSR_TP_CD = 'AV_RT'
        --AND A.MDL_NM <> '-'
    GROUP BY  A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD;
    PRINT N'GET - RAW - SUM - END';

--TESTING : NOK
--select * from #tblSCP0106_RAW_TEMP;return;
--select * from #tblSCP0106_RAW_TEMP WHERE YYYYMM = '202504';
--select * from #tblSCP0106_RAW_SUM_MDL WHERE YYYYMM = '202504';return;

	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_KEYS') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_KEYS;

    --빈테이블 생성
    SELECT    A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.YYYYMM
    INTO    #tblSCP0106_RAW_KEYS
    FROM	#tblSCP0106_RAW_TEMP A WITH(NOLOCK)
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_RAW_KEYS
    SELECT    A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			--, A.ELTR_LN_TP_CD
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.YYYYMM
    FROM	#tblSCP0106_RAW_TEMP A WITH(NOLOCK)
    GROUP BY  A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			--, A.ELTR_LN_TP_CD
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.YYYYMM;

--TESTING : NOK
--select * from #tblSCP0106_RAW_KEYS;return;
--select * from #tblSCP0106_RAW_TEMP where MDL_NM = 'TEST DUMMY!!' and YYYYMM = '202403';--return;
--select * from #tblSCP0106_RAW_KEYS where MDL_NM = 'TEST DUMMY!!' and YYYYMM = '202403';return;

	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_FULL_MEASURE') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_FULL_MEASURE;

    --빈테이블 생성
    SELECT    A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.YYYYMM
			, M.LOSS_GR_CD                              AS MSR_GR_CD
            , M.LOSS_CD                                 AS MSR_TP_CD
		    , M.LOSS_NM_EN
		    , M.LOSS_GR_NM_EN
		    , M.DISPLAY_SEQ                             AS SORT_ORDER_NO
    INTO    #tblSCP0106_RAW_FULL_MEASURE
    FROM    #tblSCP0106_RAW_KEYS A
            JOIN #tblSCP0106_MEASURE M ON
                    1=1
    WHERE   1<>1;


    INSERT INTO #tblSCP0106_RAW_FULL_MEASURE
    SELECT    A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, CASE
                WHEN M.LOSS_GR_CD = 'NAV' THEN '-'
                ELSE A.MDL_NM
              END AS MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.YYYYMM
			, M.LOSS_GR_CD                              AS MSR_GR_CD
            , M.LOSS_CD                                 AS MSR_TP_CD
		    , M.LOSS_NM_EN
		    , M.LOSS_GR_NM_EN
		    , M.DISPLAY_SEQ                             AS SORT_ORDER_NO
    FROM    #tblSCP0106_RAW_KEYS A
            JOIN #tblSCP0106_MEASURE M ON
                    1=1;

--TESTING : NOK
--select * from #tblSCP0106_RAW_FULL_MEASURE where MDL_NM = 'TEST DUMMY!!' and YYYYMM = '202403';return;
--select * from #tblSCP0106_RAW_KEYS;return;
--select * from #tblSCP0106_RAW_FULL_MEASURE WHERE YYYYMM = '202405';return;


	IF OBJECT_ID('tempdb..#tblSCP0106_RAW1') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW1;

    --빈테이블 생성
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, B.MSR_NVL
		    , A.LOSS_NM_EN
		    , A.LOSS_GR_NM_EN
		    , A.SORT_ORDER_NO
    INTO    #tblSCP0106_RAW1
    FROM	#tblSCP0106_RAW_FULL_MEASURE A WITH(NOLOCK)
		    LEFT JOIN #tblSCP0106_RAW_TEMP B WITH(NOLOCK) ON
				    A.VER_ID				= B.VER_ID
				AND A.VER_SEQ				= B.VER_SEQ
				AND A.DIVISION_ID			= B.DIVISION_ID
				AND A.MDL_NM				= B.MDL_NM
				AND A.PLANT_ID				= B.PLANT_ID
				AND A.LINE_ID				= B.LINE_ID
				AND A.OPERATION_ID			= B.OPERATION_ID
				AND A.COMPANY_ID			= B.COMPANY_ID
				AND A.SITE_ID				= B.SITE_ID
				AND A.FACTORY_ID			= B.FACTORY_ID
				AND A.YYYYMM				= B.YYYYMM
				AND A.MSR_TP_CD				= B.MSR_TP_CD
				AND A.MSR_GR_CD				= B.MSR_GR_CD
		    LEFT JOIN #tblSCP0106_LINE_RAW_TEMP L WITH(NOLOCK) ON
				    A.VER_ID				= L.VER_ID
				AND A.VER_SEQ				= L.VER_SEQ
				AND A.DIVISION_ID			= L.DIVISION_ID
				AND A.PLANT_ID				= L.PLANT_ID
				AND A.LINE_ID				= L.LINE_ID
				AND A.OPERATION_ID			= L.OPERATION_ID
				AND A.COMPANY_ID			= L.COMPANY_ID
				AND A.SITE_ID				= L.SITE_ID
				AND A.FACTORY_ID			= L.FACTORY_ID
				AND A.YYYYMM				= L.YYYYMM
				AND A.MSR_TP_CD				= L.MSR_TP_CD
				AND A.MSR_GR_CD				= L.MSR_GR_CD
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_RAW1
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, AVG(CASE
                    WHEN A.MSR_GR_CD = 'NAV' THEN L.MSR_NVL --비조업이면 라인별 집계조회
                    ELSE
                        CASE
                            --WHEN A.MSR_TP_CD = 'SCP_PROD_PLAN_DDN' THEN (SL.MSR_NVL / IIF(SM.MSR_NVL IS NULL OR SM.MSR_NVL = 0, 1.0, SM.MSR_NVL)) --조업일은 집계테이블에 없어서 계산후 추가
                            WHEN A.MSR_TP_CD = 'SCP_PROD_PLAN_DDN' THEN SM.MSR_NVL
                            ELSE B.MSR_NVL
                        END
              END) AS MSR_NVL
		    , A.LOSS_NM_EN
		    , A.LOSS_GR_NM_EN
		    , A.SORT_ORDER_NO
    FROM	#tblSCP0106_RAW_FULL_MEASURE A WITH(NOLOCK)
            --JOIN #tblSCP0106_RAW_TEMP_SCP_PROD_PLAN_KEY_LN P ON
            LEFT JOIN #tblSCP0106_RAW_TEMP_SCP_PROD_PLAN_KEY_LN P ON
				    A.VER_ID				= P.VER_ID
				AND A.VER_SEQ				= P.VER_SEQ
				AND A.DIVISION_ID			= P.DIVISION_ID
				AND A.PLANT_ID				= P.PLANT_ID
				AND A.LINE_ID				= P.LINE_ID
				AND A.OPERATION_ID			= P.OPERATION_ID
				AND A.COMPANY_ID			= P.COMPANY_ID
				AND A.SITE_ID				= P.SITE_ID
				AND A.FACTORY_ID			= P.FACTORY_ID
				AND A.YYYYMM				= P.YYYYMM
		    LEFT JOIN #tblSCP0106_RAW_TEMP B WITH(NOLOCK) ON
				    A.VER_ID				= B.VER_ID
				AND A.VER_SEQ				= B.VER_SEQ
				AND A.DIVISION_ID			= B.DIVISION_ID
				AND A.MDL_NM				= B.MDL_NM
				AND A.PLANT_ID				= B.PLANT_ID
				AND A.LINE_ID				= B.LINE_ID
				AND A.OPERATION_ID			= B.OPERATION_ID
				AND A.COMPANY_ID			= B.COMPANY_ID
				AND A.SITE_ID				= B.SITE_ID
				AND A.FACTORY_ID			= B.FACTORY_ID
				AND A.YYYYMM				= B.YYYYMM
				AND A.MSR_TP_CD				= B.MSR_TP_CD
				AND A.MSR_GR_CD				= B.MSR_GR_CD
		    LEFT JOIN #tblSCP0106_LINE_RAW L WITH(NOLOCK) ON
				    A.VER_ID				= L.VER_ID
				AND A.VER_SEQ				= L.VER_SEQ
				AND A.DIVISION_ID			= L.DIVISION_ID
				AND A.MDL_NM				= L.MDL_NM
				AND A.PLANT_ID				= L.PLANT_ID
				AND A.LINE_ID				= L.LINE_ID
				AND A.OPERATION_ID			= L.OPERATION_ID
				AND A.COMPANY_ID			= L.COMPANY_ID
				AND A.SITE_ID				= L.SITE_ID
				AND A.FACTORY_ID			= L.FACTORY_ID
				AND A.YYYYMM				= L.YYYYMM
				AND A.MSR_TP_CD				= L.MSR_TP_CD
				AND A.MSR_GR_CD				= L.MSR_GR_CD
		  --  LEFT JOIN #tblSCP0106_RAW_SUM_LN SL WITH(NOLOCK) ON -- WT_RT 계산을 위해 Line/Operation 별 집계 
				--    A.VER_ID				= SL.VER_ID
				--AND A.VER_SEQ				= SL.VER_SEQ
				--AND A.DIVISION_ID			= SL.DIVISION_ID
				--AND A.MDL_NM				= SL.MDL_NM
				--AND A.PLANT_ID				= SL.PLANT_ID
				--AND A.LINE_ID				= SL.LINE_ID
				--AND A.OPERATION_ID			= SL.OPERATION_ID
				--AND A.COMPANY_ID			= SL.COMPANY_ID
				--AND A.SITE_ID				= SL.SITE_ID
				--AND A.FACTORY_ID			= SL.FACTORY_ID
				--AND A.YYYYMM				= SL.YYYYMM
				--AND A.MSR_TP_CD				= SL.MSR_TP_CD
				--AND A.MSR_GR_CD				= SL.MSR_GR_CD
		    LEFT JOIN #tblSCP0106_RAW_SUM_MDL SM WITH(NOLOCK) ON
				    A.VER_ID				= SM.VER_ID
				AND A.VER_SEQ				= SM.VER_SEQ
				AND A.DIVISION_ID			= SM.DIVISION_ID
				AND A.MDL_NM				= SM.MDL_NM
				AND A.PLANT_ID				= SM.PLANT_ID
				AND A.LINE_ID				= SM.LINE_ID
				AND A.OPERATION_ID			= SM.OPERATION_ID
				AND A.COMPANY_ID			= SM.COMPANY_ID
				AND A.SITE_ID				= SM.SITE_ID
				AND A.FACTORY_ID			= SM.FACTORY_ID
				AND A.YYYYMM				= SM.YYYYMM
				AND A.MSR_TP_CD				= SM.MSR_TP_CD
				AND A.MSR_GR_CD				= SM.MSR_GR_CD
    GROUP BY  A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
		    , A.LOSS_NM_EN
		    , A.LOSS_GR_NM_EN
		    , A.SORT_ORDER_NO

--TESTING : NOK
--select * from #tblSCP0106_RAW_TEMP WHERE YYYYMM = '202504';
--select * from #tblSCP0106_LINE_RAW WHERE YYYYMM = '202504';
--select * from #tblSCP0106_RAW_SUM_MDL WHERE YYYYMM = '202504';return;
--select * from #tblSCP0106_RAW_TEMP WHERE MSR_TP_CD = 'SCP_PROD_PLAN_DDN' AND YYYYMM = '202503';
--select * from #tblSCP0106_LINE_RAW WHERE MSR_TP_CD = 'SCP_PROD_PLAN_DDN' AND YYYYMM = '202503';
--select * from #tblSCP0106_RAW_SUM_MDL WHERE MSR_TP_CD = 'SCP_PROD_PLAN_DDN' AND YYYYMM = '202503';return;
--select * from #tblSCP0106_RAW1 WHERE MSR_TP_CD = 'SCP_PROD_PLAN_DDN' AND YYYYMM = '202503';return;


	IF OBJECT_ID('tempdb..#tblSCP0106_RAW') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW;

    --빈테이블 생성
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
		    , A.LOSS_NM_EN
		    , A.LOSS_GR_NM_EN
		    , A.SORT_ORDER_NO
            , IIF(A.MDL_NM <> '-', B.ASSIGN_PRIORITY, C.ASSIGN_PRIORITY) AS ASSIGN_PRIORITY
    INTO    #tblSCP0106_RAW
    FROM	#tblSCP0106_RAW1 A WITH(NOLOCK)
			LEFT JOIN #tblSCP0106_LINE_ASSIGN_MDL B ON
						A.DIVISION_ID		= B.DIVISION_ID
					AND A.COMPANY_ID		= B.COMPANY_ID
					AND A.SITE_ID			= B.SITE_ID
					AND A.PLANT_ID			= B.PLANT_ID
					AND A.FACTORY_ID		= B.FACTORY_ID
					AND A.LINE_ID			= B.LINE_ID
					AND A.OPERATION_ID		= B.OPERATION_ID
					AND A.MDL_NM            = B.NICK_NAME
					AND A.YYYYMM            = B.YYYYMM
			LEFT JOIN #tblSCP0106_LINE_ASSIGN_LN C ON
						A.DIVISION_ID		= B.DIVISION_ID
					AND A.COMPANY_ID		= B.COMPANY_ID
					AND A.SITE_ID			= B.SITE_ID
					AND A.PLANT_ID			= B.PLANT_ID
					AND A.FACTORY_ID		= B.FACTORY_ID
					AND A.LINE_ID			= B.LINE_ID
					AND A.OPERATION_ID		= B.OPERATION_ID
					AND A.YYYYMM            = B.YYYYMM
    WHERE   1<>1;

    INSERT INTO #tblSCP0106_RAW
    SELECT    A.VER_ID                  
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.MDL_NM
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
            , CASE
                WHEN MSR_TP_CD IN (   'SCP_PROD_PLAN'
                                    , 'PROD_CAPA_M'
                                    , 'PROD_CAPA_D'
                                    , 'SCP_PROD_PLAN_DDN'
                                    , 'THRY_CAPA_D'
                                    , 'SD_RT'
                                    , 'WT_RT'
                                    , 'TD_RT'
                                    , 'MC_RT') THEN MSR_NVL --일수 or EA
                ELSE MSR_NVL * 100.0 --비율로 표시
              END AS MSR_NVL
		    , A.LOSS_NM_EN
		    , A.LOSS_GR_NM_EN
		    , A.SORT_ORDER_NO
            , IIF(A.MDL_NM <> '-', B.ASSIGN_PRIORITY, C.ASSIGN_PRIORITY) AS ASSIGN_PRIORITY
    FROM	#tblSCP0106_RAW1 A
			LEFT JOIN #tblSCP0106_LINE_ASSIGN_MDL B ON
						A.DIVISION_ID		= B.DIVISION_ID
					AND A.COMPANY_ID		= B.COMPANY_ID
					AND A.SITE_ID			= B.SITE_ID
					AND A.PLANT_ID			= B.PLANT_ID
					AND A.FACTORY_ID		= B.FACTORY_ID
					AND A.LINE_ID			= B.LINE_ID
					AND A.OPERATION_ID		= B.OPERATION_ID
					AND A.MDL_NM            = B.NICK_NAME
					AND A.YYYYMM            = B.YYYYMM
			LEFT JOIN #tblSCP0106_LINE_ASSIGN_LN C ON
						A.DIVISION_ID		= C.DIVISION_ID
					AND A.COMPANY_ID		= C.COMPANY_ID
					AND A.SITE_ID			= C.SITE_ID
					AND A.PLANT_ID			= C.PLANT_ID
					AND A.FACTORY_ID		= C.FACTORY_ID
					AND A.LINE_ID			= C.LINE_ID
					AND A.OPERATION_ID		= C.OPERATION_ID
					AND A.YYYYMM            = C.YYYYMM


    PRINT N'#tblSCP0106_RAW - END';

--TESTING:NOK
--select * from #tblSCP0106_RAW;return;



	DECLARE @v_date_cols                    NVARCHAR(MAX) = N'';
	DECLARE @v_priority_cols                NVARCHAR(MAX) = N'';
	DECLARE @v_final_sum_cols               NVARCHAR(MAX) = N'';
	DECLARE @v_final_sum_priority_cols      NVARCHAR(MAX) = N'';
	DECLARE @v_final_cols                   NVARCHAR(MAX) = N'';
	DECLARE @v_final_priority_cols          NVARCHAR(MAX) = N'';

	SELECT      @v_date_cols       = @v_date_cols + '
			      , ' +
				    CASE
                        WHEN CHARINDEX('M_01', COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 5, 6) THEN MSR_NVL END AS ' + COLUMN_NAME
					    WHEN CHARINDEX('Y_',   COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 3, 4) THEN MSR_NVL END AS ' + COLUMN_NAME
				    END
              , @v_priority_cols       = @v_priority_cols + '
			      , ' +
				    CASE
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


    DECLARE     @v_sql   NVARCHAR(MAX)       = N'';

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
                , MDL_NM
                , MSR_GR_CD
                , MSR_TP_CD
                , LOSS_NM_EN
                , LOSS_GR_NM_EN
                , SORT_ORDER_NO
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
                , MDL_NM
                , MSR_GR_CD
                , MSR_TP_CD
                , LOSS_NM_EN
                , LOSS_GR_NM_EN
                , SORT_ORDER_NO
                ' + @v_date_cols + N'
                ' + @v_priority_cols + N'
		FROM    #tblSCP0106_RAW A;

        --TESTING : NOK
        --select * from #tblSCP0106_FINAL;return;


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
                , MDL_NM
                , MSR_GR_CD
                , LOSS_GR_NM_EN
                , MSR_TP_CD
                , LOSS_NM_EN
                , IIF(MDL_NM = ''-'', ''2'', ''1'') AS SORT_ORDER_NO_GR
                , SORT_ORDER_NO
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
                , OPERATION_ID
                , MDL_NM
                , MSR_GR_CD
                , MSR_TP_CD
                , LOSS_NM_EN
                , LOSS_GR_NM_EN
                , SORT_ORDER_NO;

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
                , MDL_NM
                , MSR_GR_CD
                , LOSS_GR_NM_EN
                , MSR_TP_CD
                , LOSS_NM_EN
                , IIF(MDL_NM = ''-'', ''2'', ''1'') AS SORT_ORDER_NO_GR
                , SORT_ORDER_NO
                ' + @v_final_sum_cols + N'
                ' + @v_final_sum_priority_cols + N'
		FROM    #tblSCP0106_FINAL
        GROUP BY  VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , MDL_NM
                , MSR_GR_CD
                , MSR_TP_CD
                , LOSS_NM_EN
                , LOSS_GR_NM_EN
                , SORT_ORDER_NO;

        --TESTING : NOK
        --select * from #tblSCP0106_FINAL1;return;


    	IF OBJECT_ID(''tempdb..#tblSCP0106_FINAL_LINE'') IS NOT NULL
			DROP TABLE #tblSCP0106_FINAL_LINE;

        --빈테이블 생성
        SELECT	  VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS IDX
        INTO    #tblSCP0106_FINAL_LINE
        FROM    #tblSCP0106_FINAL1 A
        WHERE   1<>1

        INSERT INTO #tblSCP0106_FINAL_LINE
        SELECT	  VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS IDX
        FROM    #tblSCP0106_FINAL1 A
        GROUP BY  VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID;

--TESTING : NOK
--select * from #tblSCP0106_FINAL_LINE;return;


        SELECT	  A.VER_ID
                , A.VER_SEQ
                , A.DIVISION_ID
                , A.COMPANY_ID
                , A.SITE_ID
                , A.PLANT_ID
                , A.FACTORY_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , A.MDL_NM															AS NICK_NAME
                , A.MSR_GR_CD														AS MEASURE_GROUP
                , A.LOSS_GR_NM_EN													AS MEASURE_GROUP_NAME
                , A.MSR_TP_CD														AS MEASURE
                , A.LOSS_NM_EN														AS MEASURE_NAME
                , A.SORT_ORDER_NO_GR
                , A.SORT_ORDER_NO
			    , dbo.FN_GET_DIVISION_NAME (A.DIVISION_ID)							AS DIVISION_NAME
			    , S.SITE_NAME								                        AS SITE_NAME
			    , P.PLANT_NAME								                        AS PLANT_NAME
			    , F.FACTORY_NAME						                            AS FACTORY_NAME
			    , L.LINE_NAME								                        AS LINE_NAME
			    , O.OPERATION_NAME
                , V.SCP_PRDN_PLAN_REF_ST_YM
                , V.SCP_PRDN_PLAN_REF_END_YM
                , FL.IDX															AS LINE_IDX
                , ROW_NUMBER() OVER (ORDER BY (SELECT 1))							AS IDX
                ' + @v_final_cols + N'
                ' + @v_final_priority_cols + N'
		FROM    #tblSCP0106_FINAL1 A
                LEFT JOIN #tblSCP0106_VERSION V ON
                        A.VER_ID            = V.VER_ID
				    AND A.VER_SEQ           = V.VER_SEQ
				    AND A.DIVISION_ID       = V.DIVISION_ID
                LEFT JOIN #tblSCP0106_FINAL_LINE FL ON
				        A.DIVISION_ID		= FL.DIVISION_ID
				    AND A.COMPANY_ID		= FL.COMPANY_ID
				    AND A.SITE_ID			= FL.SITE_ID
				    AND A.PLANT_ID			= FL.PLANT_ID
				    AND A.FACTORY_ID		= FL.FACTORY_ID
				    AND A.LINE_ID			= FL.LINE_ID
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
        WHERE   1=1
            AND ((A.MSR_GR_CD IN (''NAV'') AND MDL_NM = ''-'') OR -- 비조업은 모델 무시
                 (A.MSR_GR_CD IN (''-'') AND MDL_NM <> ''-''))    -- 나머지는 모델 있음 (SCP 생산 계획, 조업일)
        ORDER BY  A.VER_ID
				, A.VER_SEQ
                , A.DIVISION_ID
		        , A.COMPANY_ID
			    , S.SITE_NAME
			    , P.PLANT_NAME
			    , F.FACTORY_NAME
			    , L.LINE_NAME
		        , A.OPERATION_ID
                , A.SORT_ORDER_NO_GR
		        , A.MDL_NM
		        , A.SORT_ORDER_NO
                ';

    --TESTING : OK
    --exec debug_log @v_sql, 'T';return;

    EXEC(@v_sql);
    

    PRINT N'조업일 실시간 계산용 - 모델별 - BEGIN'
    BEGIN
        SELECT    A.VER_ID
			    , A.VER_SEQ
                , A.DIVISION_ID
			    , A.MDL_NM          AS NICK_NAME
			    , A.PLANT_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.FACTORY_ID
			    , A.YYYYMM
			    , A.MSR_NVL         AS PROD_CAPA_D
        FROM    #tblSCP0106_RAW_PROD_CAPA_D_MDL A;
    END
    PRINT N'조업일 실시간 계산용 - 모델별 - END'


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
                --, A.ATTRIBUTE10                                                 AS IPRV_GOL_TP		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
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
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.FACTORY_ID
			    , A.YYYYMM
                , MAX(A.DAY_CNT)    AS DAY_CNT
        FROM    #tblSCP0106_LINE_RAW A
        GROUP BY A.VER_ID
                , A.VER_SEQ
                , A.DIVISION_ID
			    , A.MDL_NM
			    , A.PLANT_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
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
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.FACTORY_ID
			    , A.YYYYMM
                , MAX(A.DAY_CNT)    AS DAY_CNT
        FROM    #tblSCP0106_LINE_RAW A
        GROUP BY A.VER_ID
                , A.VER_SEQ
                , A.DIVISION_ID
			    , A.PLANT_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.FACTORY_ID
			    , A.YYYYMM
    END
    PRINT N'DAY_CNT - UI 계산용 - END'



	IF OBJECT_ID('tempdb..#tblSCP0106_DATE_COLS') IS NOT NULL
		DROP TABLE #tblSCP0106_DATE_COLS;
	IF OBJECT_ID('tempdb..#tblSCP0106_FACTORY') IS NOT NULL
		DROP TABLE #tblSCP0106_FACTORY;
	IF OBJECT_ID('tempdb..#tblSCP0106_FINAL1') IS NOT NULL
		DROP TABLE #tblSCP0106_FINAL1;
	IF OBJECT_ID('tempdb..#tblSCP0106_FINAL') IS NOT NULL
		DROP TABLE #tblSCP0106_FINAL;
	IF OBJECT_ID('tempdb..#tblSCP0106_FINAL_LINE') IS NOT NULL
		DROP TABLE #tblSCP0106_FINAL_LINE;
	IF OBJECT_ID('tempdb..#tblSCP0106_LINE') IS NOT NULL
		DROP TABLE #tblSCP0106_LINE;
	IF OBJECT_ID('tempdb..#tblSCP0106_LINE_RAW') IS NOT NULL
		DROP TABLE #tblSCP0106_LINE_RAW;
	IF OBJECT_ID('tempdb..#tblSCP0106_LINE_RAW_MC_RT') IS NOT NULL
		DROP TABLE #tblSCP0106_LINE_RAW_MC_RT;
	IF OBJECT_ID('tempdb..#tblSCP0106_LINE_RAW_SD_RT') IS NOT NULL
		DROP TABLE #tblSCP0106_LINE_RAW_SD_RT;
	IF OBJECT_ID('tempdb..#tblSCP0106_LINE_RAW_TD_RT') IS NOT NULL
		DROP TABLE #tblSCP0106_LINE_RAW_TD_RT;
	IF OBJECT_ID('tempdb..#tblSCP0106_LINE_RAW_TEMP') IS NOT NULL
		DROP TABLE #tblSCP0106_LINE_RAW_TEMP;
	IF OBJECT_ID('tempdb..#tblSCP0106_MEASURE') IS NOT NULL
		DROP TABLE #tblSCP0106_MEASURE;
	IF OBJECT_ID('tempdb..#tblSCP0106_MEASURE_ALL') IS NOT NULL
		DROP TABLE #tblSCP0106_MEASURE_ALL;
	IF OBJECT_ID('tempdb..#tblSCP0106_MEASURE_VISIBLE') IS NOT NULL
		DROP TABLE #tblSCP0106_MEASURE_VISIBLE;
	IF OBJECT_ID('tempdb..#tblSCP0106_MONTH_DAY_CNT') IS NOT NULL
		DROP TABLE #tblSCP0106_MONTH_DAY_CNT;
	IF OBJECT_ID('tempdb..#tblSCP0106_PLANT') IS NOT NULL
		DROP TABLE #tblSCP0106_PLANT;
	IF OBJECT_ID('tempdb..#tblSCP0106_PLAN_TP') IS NOT NULL
		DROP TABLE #tblSCP0106_PLAN_TP;
	IF OBJECT_ID('tempdb..#tblSCP0106_RAW1') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW1;
	IF OBJECT_ID('tempdb..#tblSCP0106_RAW') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW;
	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_FULL_MEASURE') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_FULL_MEASURE;
	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_KEYS') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_KEYS;
	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_PROD_CAPA_D_MDL') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_PROD_CAPA_D_MDL;
	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_SUM_LN') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_SUM_LN;
	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_SUM_MDL') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_SUM_MDL;
	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_TEMP') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_TEMP;
	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_TEMP_ALL') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_TEMP_ALL;
	IF OBJECT_ID('tempdb..#tblSCP0106_RAW_TEMP_SCP_PROD_PLAN_KEY_LN') IS NOT NULL
		DROP TABLE #tblSCP0106_RAW_TEMP_SCP_PROD_PLAN_KEY_LN;
	IF OBJECT_ID('tempdb..#tblSCP0106_SITE') IS NOT NULL
		DROP TABLE #tblSCP0106_SITE;
	IF OBJECT_ID('tempdb..#tblSCP0106_VERSION') IS NOT NULL
		DROP TABLE #tblSCP0106_VERSION;
	IF OBJECT_ID('tempdb..#tblSCP0104_OPERATION') IS NOT NULL
		DROP TABLE #tblSCP0104_OPERATION;

END

