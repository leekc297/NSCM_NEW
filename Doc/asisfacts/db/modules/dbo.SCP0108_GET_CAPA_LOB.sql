
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0108_GET_CAPA_LOB_1ST_CUTOFF
 * Description  :
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/19   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2      - Initial Release
 * 2024.10.28	chaan        V1.1.9                PJ20239037 LGES CPS VOE 반영 및 고도화                     - 컬럼순서 변경 : 공정, 모델 -> 모델, 공정
 * 2024.12.12	chaan        V1.1.10               PJ20239037 LGES CPS VOE 반영 및 고도화                     - 날짜 컬럼 함수 오류 수정 적용
 */


--CREATE PROCEDURE [dbo].[SCP0108_GET_CAPA_LOB]
CREATE PROCEDURE [dbo].[SCP0108_GET_CAPA_LOB]
	  @p_version			NVARCHAR(10)
	, @p_version_seq		TINYINT
	, @p_division_id		NVARCHAR(30)
	, @p_site_id			NVARCHAR(MAX)
	, @p_plant_id  			NVARCHAR(MAX)
	, @p_factory_id			NVARCHAR(MAX)
	, @p_line_id			NVARCHAR(MAX)
	, @p_operation_id		NVARCHAR(MAX)
	, @p_nick_name			NVARCHAR(MAX)
    , @p_electrode_type		NVARCHAR(MAX)
    , @p_bottleneck_flag    NVARCHAR(MAX)
	, @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
	, @p_user_id			NVARCHAR(30)
	, @debug_mode			NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

 --   DECLARE @p_version			NVARCHAR(10)		= N'202412';
	--DECLARE @p_version_seq		TINYINT             = 1;
	--DECLARE @p_division_id		NVARCHAR(30)		= N'81';
	--DECLARE @p_site_id			NVARCHAR(MAX)		= N'';
	--DECLARE @p_plant_id  		NVARCHAR(MAX)		= N'';
	--DECLARE @p_factory_id		NVARCHAR(MAX)		= N'';
	--DECLARE @p_line_id			NVARCHAR(MAX)		= N'';
	--DECLARE @p_operation_id		NVARCHAR(MAX)		= N'';
	--DECLARE @p_nick_name		NVARCHAR(MAX)		= N'';
	--DECLARE @p_electrode_type	NVARCHAR(MAX)		= N'-';
	--DECLARE @p_bottleneck_flag	NVARCHAR(MAX)		= N'';
	--DECLARE @p_program_id		NVARCHAR(100)		= N'SCP0108';
	--DECLARE @p_sheet_name		NVARCHAR(100)		= N'CUTOFF';
 --   DECLARE @p_user_id			NVARCHAR(30)		= N'iamarock';
 --   DECLARE @debug_mode			NVARCHAR(1)			= N'F';


	DECLARE @V_ELAPSED_TIME_BEG     DATETIME                = CURRENT_TIMESTAMP;


    DECLARE @v_from_yyyy                NVARCHAR(8)			= N'';
    DECLARE @v_from_yyyymm              NVARCHAR(6)         = CONVERT(NVARCHAR(6), DATEADD(MM, 1, CONVERT(DATETIME, @p_version + '01')), 112);
	DECLARE @v_result_from_yyyymm		NVARCHAR(6)         = N'';
	DECLARE @v_result_to_yyyymm			NVARCHAR(6)         = N'';

    SET @v_from_yyyy            = SUBSTRING(@p_version, 1, 4);
    SET @v_result_from_yyyymm   = CONVERT(CHAR(8), DATEADD(MM, -3, CONVERT(DATETIME, @p_version + '01')), 112);
    SET @v_result_to_yyyymm     = CONVERT(CHAR(8), DATEADD(MM, -1, CONVERT(DATETIME, @p_version + '01')), 112);

    PRINT CONCAT('@p_version : ', @p_version);
    PRINT CONCAT('@v_result_from_yyyymm : ', @v_result_from_yyyymm);
    PRINT CONCAT('@v_result_to_yyyymm : ', @v_result_to_yyyymm);
    --return;



	IF OBJECT_ID('tempdb..#tblSCP0108_DATE_COLS') IS NOT NULL
		DROP TABLE #tblSCP0108_DATE_COLS;

    --빈테이블 생성
    SELECT	  COLUMN_NAME
			, COLUMN_LABEL_NAME
			, SMALL_CLASS_LABEL_NAME
			, LARGE_CLASS_LABEL_NAME
			, DAY_CODE
			, SORT_ORDER_NO
    INTO    #tblSCP0108_DATE_COLS
	FROM	dbo.FN_SCP0104_GET_SPREAD_TITLE(@v_from_yyyymm, @p_program_id, @p_sheet_name) A
    WHERE   1<>1;

    INSERT INTO #tblSCP0108_DATE_COLS
    SELECT	  COLUMN_NAME
			, COLUMN_LABEL_NAME
			, SMALL_CLASS_LABEL_NAME
			, LARGE_CLASS_LABEL_NAME
			, DAY_CODE
			, SORT_ORDER_NO
	FROM	dbo.FN_SCP0104_GET_SPREAD_TITLE(@v_from_yyyymm, @p_program_id, @p_sheet_name) A;

--TESTING : NOK
--select * from #tblSCP0108_DATE_COLS;return;

	IF OBJECT_ID('tempdb..#tblSCP0108_PLAN_TP') IS NOT NULL
		DROP TABLE #tblSCP0108_PLAN_TP;

    --빈테이블 생성
    SELECT	LARGE_CLASS_LABEL_NAME  AS PLAN_TP
    INTO    #tblSCP0108_PLAN_TP
	FROM	#tblSCP0108_DATE_COLS
    WHERE   1<>1;

    INSERT INTO #tblSCP0108_PLAN_TP
    SELECT	LARGE_CLASS_LABEL_NAME AS PLAN_TP
	FROM	#tblSCP0108_DATE_COLS
    GROUP BY LARGE_CLASS_LABEL_NAME

--TESTING : NOK
--select * from #tblSCP0108_PLAN_TP;return;

	DECLARE @v_to_yyyy			NVARCHAR(4)			= '';

    SELECT  @v_to_yyyy  = MAX(SMALL_CLASS_LABEL_NAME)
    FROM    #tblSCP0108_DATE_COLS;

PRINT CONCAT('@v_to_yyyy : ', @v_to_yyyy);

   

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



PRINT CONCAT('ELAPSED_TIME-Temp Codes : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;


    PRINT N'GET - RAW TEMP - BEGIN';
	IF OBJECT_ID('tempdb..#tblSCP0108_RAW_TEMP') IS NOT NULL
		DROP TABLE #tblSCP0108_RAW_TEMP;

    --빈테이블 생성
    SELECT    A.VER_ID
			, A.VER_SEQ
			, A.DIVISION_ID
			, A.YYYYMM
			, A.MDL_NM
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.THRY_CAPA
			, A.PRDN_CAPA
			, A.PRDN_OPRT
			, A.LD_RT
			, A.ADJ_PRDN_CAPA
			, A.ADJ_PRDN_OPRT
			, A.ADJ_LD_RT
			, A.ADJ_ULD_RT
            , A.ATTRIBUTE1          AS BOTTLENECK_FLAG
    INTO    #tblSCP0108_RAW_TEMP
    FROM	SCP_RPT_CAPA_LOB A WITH(NOLOCK)
    WHERE   1<>1;

    INSERT INTO #tblSCP0108_RAW_TEMP
    SELECT    A.VER_ID
			, A.VER_SEQ
			, A.DIVISION_ID
			, A.YYYYMM
			, A.MDL_NM
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.THRY_CAPA
			, A.PRDN_CAPA
			, A.PRDN_OPRT
			, A.LD_RT
			, A.ADJ_PRDN_CAPA
			, A.ADJ_PRDN_OPRT
			, A.ADJ_LD_RT
			, A.ADJ_ULD_RT
            , A.ATTRIBUTE1          AS BOTTLENECK_FLAG
    FROM	SCP_RPT_CAPA_LOB A WITH(NOLOCK)
    WHERE   1=1
		    AND A.VER_ID    = @p_version
			AND A.VER_SEQ   = @p_version_seq
		    AND ((@p_division_id	    IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		    AND ((@p_site_id  		    IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		    AND ((@p_plant_id		    IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		    AND ((@p_factory_id		    IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		    AND ((@p_line_id		    IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		    AND ((@p_operation_id	    IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		    AND ((@p_electrode_type	    IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		    --AND ((@p_nick_name	        IS NULL OR @p_nick_name   		= '') OR (A.MDL_NM LIKE '%' + @p_nick_name + '%'))
		    AND ((@p_nick_name	        IS NULL OR @p_nick_name   		= '') OR A.MDL_NM IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_nick_name, ',')))
		    AND ((@p_bottleneck_flag	IS NULL OR @p_bottleneck_flag	= '' OR @p_bottleneck_flag	= 'ALL') OR A.ATTRIBUTE1 = @p_bottleneck_flag)
    PRINT N'GET - RAW TEMP - END';

PRINT CONCAT('ELAPSED_TIME-#tblSCP0108_RAW_TEMP : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from #tblSCP0108_RAW_TEMP;return;
--select * from #tblSCP0108_RAW_TEMP WHERE YYYYMM = '202409';return;


	    IF OBJECT_ID('tempdb..#tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN') IS NOT NULL
		    DROP TABLE #tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN;

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
                , A.YYYYMM
                , A.ASSIGN_PRIORITY
        INTO	#tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN
        FROM    SCP_MST_CAPA_LINE_ASSIGN A WITH(NOLOCK)
	    WHERE	1<>1

        INSERT INTO #tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN
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
                , A.YYYYMM
                , A.ASSIGN_PRIORITY
        FROM    SCP_MST_CAPA_LINE_ASSIGN_CUTF A WITH(NOLOCK)
        WHERE   1=1
		    AND A.VER_ID    = @p_version
			AND A.VER_SEQ   = @p_version_seq
            AND A.VALID_YN = 'Y'
		    AND ((@p_division_id	    IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		    AND ((@p_site_id  		    IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		    AND ((@p_plant_id		    IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		    AND ((@p_factory_id		    IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		    AND ((@p_line_id		    IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		    AND ((@p_operation_id	    IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		    AND ((@p_electrode_type	    IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		    --AND ((@p_nick_name	        IS NULL OR @p_nick_name   		= '') OR (A.MDL_NM LIKE '%' + @p_nick_name + '%'))
		    AND ((@p_nick_name	        IS NULL OR @p_nick_name   		= '') OR A.NICK_NAME IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_nick_name, ',')))

    PRINT CONCAT('ELAPSED_TIME-#tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

--TESTING : NOK
--select * from #tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN;return;
--select * from #tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN WHERE YYYYMM = '202406';
--select * from SCP_MST_CAPA_LINE_ASSIGN_CUTF WHERE YYYYMM = '202406';return;

	IF OBJECT_ID('tempdb..#tblSCP0108_RAW1') IS NOT NULL
		DROP TABLE #tblSCP0108_RAW1;

    --빈테이블 생성
    SELECT    A.VER_ID
			, A.VER_SEQ
			, A.DIVISION_ID
			, A.YYYYMM
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.LINE_ID
			, A.MDL_NM
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.THRY_CAPA
			, A.PRDN_CAPA
			, A.PRDN_OPRT
			, A.LD_RT
			, A.ADJ_PRDN_CAPA
			, A.ADJ_PRDN_OPRT
			, A.ADJ_LD_RT
			, A.ADJ_ULD_RT
            , A.ATTRIBUTE1                AS BOTTLENECK_FLAG
            , CONVERT(FLOAT, NULL)        AS ASSIGN_PRIORITY
    INTO    #tblSCP0108_RAW1
    FROM	SCP_RPT_CAPA_LOB A WITH(NOLOCK)
    WHERE   1<>1;

    INSERT INTO #tblSCP0108_RAW1
    SELECT    A.VER_ID
			, A.VER_SEQ
			, A.DIVISION_ID
			, A.YYYYMM
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.LINE_ID
			, A.MDL_NM
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.THRY_CAPA			        AS THRY_CAPA
			, A.PRDN_CAPA			        AS PRDN_CAPA
			, A.PRDN_OPRT			        AS PRDN_OPRT
			, A.LD_RT				        AS LD_RT
			, A.ADJ_PRDN_CAPA		        AS ADJ_PRDN_CAPA
			, A.ADJ_PRDN_OPRT		        AS ADJ_PRDN_OPRT
			, A.ADJ_LD_RT			        AS ADJ_LD_RT
			, A.ADJ_ULD_RT			        AS ADJ_ULD_RT
            , A.BOTTLENECK_FLAG
            , ISNULL(B.ASSIGN_PRIORITY, 0)  AS ASSIGN_PRIORITY
    FROM	#tblSCP0108_RAW_TEMP A WITH(NOLOCK)
            INNER JOIN #tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN B ON
			        A.DIVISION_ID		= B.DIVISION_ID
			    AND A.COMPANY_ID		= B.COMPANY_ID
			    AND A.SITE_ID			= B.SITE_ID
			    AND A.PLANT_ID			= B.PLANT_ID
			    AND A.FACTORY_ID		= B.FACTORY_ID
			    AND A.LINE_ID			= B.LINE_ID
			    AND A.OPERATION_ID		= B.OPERATION_ID
			    AND A.ELTR_LN_TP_CD		= B.ELTR_LN_TP_CD
			    AND A.MDL_NM			= B.NICK_NAME
			    AND A.YYYYMM			= B.YYYYMM
    WHERE   1=1
        AND ISNULL(B.ASSIGN_PRIORITY, 0) <> 0

--TESTING : NOK
--select * from #tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN WHERE YYYYMM = '202404';
--select * from #tblSCP0108_RAW1 WHERE YYYYMM = '202409';return;


	IF OBJECT_ID('tempdb..#tblSCP0108_RAW') IS NOT NULL
		DROP TABLE #tblSCP0108_RAW;

    --빈테이블 생성
    SELECT    '1'           AS DV
            , A.VER_ID
			, A.VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.LINE_ID
			, A.MDL_NM
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.YYYYMM
			, A.THRY_CAPA
			, A.PRDN_CAPA
			, A.PRDN_OPRT
			, A.LD_RT
			, A.ADJ_PRDN_CAPA
			, A.ADJ_PRDN_OPRT
			, A.ADJ_LD_RT
			, A.ADJ_ULD_RT
            , A.BOTTLENECK_FLAG
    INTO    #tblSCP0108_RAW
    FROM	#tblSCP0108_RAW1 A
    WHERE   1<>1;

    INSERT INTO #tblSCP0108_RAW
    SELECT   '2'                        AS DV
            , A.VER_ID
			, A.VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.LINE_ID
			, A.MDL_NM
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.YYYYMM
			, SUM(A.THRY_CAPA)			AS THRY_CAPA
			, SUM(A.PRDN_CAPA)			AS PRDN_CAPA
			, AVG(A.PRDN_OPRT)			AS PRDN_OPRT
			, AVG(A.LD_RT)				AS LD_RT
			, SUM(A.ADJ_PRDN_CAPA)		AS ADJ_PRDN_CAPA
			, SUM(A.ADJ_PRDN_OPRT)		AS ADJ_PRDN_OPRT
			, AVG(A.ADJ_LD_RT)			AS ADJ_LD_RT
			, AVG(A.ADJ_ULD_RT)			AS ADJ_ULD_RT
            , A.BOTTLENECK_FLAG
    FROM	#tblSCP0108_RAW1 A
    WHERE   1=1
        AND A.ASSIGN_PRIORITY <> 0
    GROUP BY  A.VER_ID
			, A.VER_SEQ
			, A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.LINE_ID
			, A.MDL_NM
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
			, A.YYYYMM
            , A.BOTTLENECK_FLAG;

--TESTING : NOK
--select * from #tblSCP0108_RAW1 where yyyymm = '202406';
--select * from #tblSCP0108_RAW where yyyymm = '202409';return;
    
    IF ISNULL(@p_nick_name, '') <> ''
    BEGIN
        INSERT INTO #tblSCP0108_RAW
        SELECT    '1'                       AS DV	-- NickName 합계
                , A.VER_ID
			    , A.VER_SEQ
                , '*'					    AS DIVISION_ID
                , '*'					    AS COMPANY_ID
                , '*'					    AS SITE_ID
                , '*'					    AS PLANT_ID
                , '*'					    AS LINE_ID
                , A.MDL_NM				    AS NICK_NAME 
                , A.OPERATION_ID
                , A.ELTR_LN_TP_CD
                , A.YYYYMM
			    , SUM(A.THRY_CAPA)			AS THRY_CAPA
			    , SUM(A.PRDN_CAPA)			AS PRDN_CAPA
			    , AVG(A.PRDN_OPRT)			AS PRDN_OPRT
			    , AVG(A.LD_RT)				AS LD_RT
			    , SUM(A.ADJ_PRDN_CAPA)		AS ADJ_PRDN_CAPA
			    , SUM(A.ADJ_PRDN_OPRT)		AS ADJ_PRDN_OPRT
			    , AVG(A.ADJ_LD_RT)			AS ADJ_LD_RT
			    , AVG(A.ADJ_ULD_RT)			AS ADJ_ULD_RT
                --, A.BOTTLENECK_FLAG
                , 'N'                       AS BOTTLENECK_FLAG
        FROM    #tblSCP0108_RAW A WITH(NOLOCK)
        WHERE   1=1
            AND ISNULL(@p_nick_name, '') <> ''
        GROUP BY  A.VER_ID
			    , A.VER_SEQ
                , A.MDL_NM
                , A.OPERATION_ID
                , A.ELTR_LN_TP_CD
                , A.YYYYMM
    END
--TESTING : NOK
--select * from #tblSCP0108_RAW where yyyymm = '202409';return;



	DECLARE @v_date_cols                        NVARCHAR(MAX) = N'';
	DECLARE @v_bottleneck_cols                  NVARCHAR(MAX) = N'';
	DECLARE @v_final_sum_cols                   NVARCHAR(MAX) = N'';
	DECLARE @v_final_sum_bottleneck_cols        NVARCHAR(MAX) = N'';
	DECLARE @v_final_cols                       NVARCHAR(MAX) = N'';
	DECLARE @v_final_bottleneck_cols            NVARCHAR(MAX) = N'';

	SELECT      @v_date_cols        = @v_date_cols + '
			  , ' +
				CASE
                    WHEN CHARINDEX('M_01', COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 5, 6) THEN PRDN_CAPA END AS ' + COLUMN_NAME
					WHEN CHARINDEX('Y_',   COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 3, 4) THEN PRDN_CAPA END AS ' + COLUMN_NAME
				END
              , @v_bottleneck_cols  = @v_bottleneck_cols + '
			  , ' +
				CASE
                    WHEN CHARINDEX('M_01', COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 5, 6) THEN BOTTLENECK_FLAG END AS BOTTLENECK_FLAG_' + COLUMN_NAME
					WHEN CHARINDEX('Y_',   COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 3, 4) THEN BOTTLENECK_FLAG END AS BOTTLENECK_FLAG_' + COLUMN_NAME
				END
              , @v_final_sum_cols   = @v_final_sum_cols + '
			  , AVG(' + COLUMN_NAME + ') AS ' + COLUMN_NAME
              , @v_final_sum_bottleneck_cols   = @v_final_sum_bottleneck_cols + '
			  , MAX(BOTTLENECK_FLAG_' + COLUMN_NAME + ') AS BOTTLENECK_FLAG_' + COLUMN_NAME
              , @v_final_cols   = @v_final_cols + '
			  , ' + COLUMN_NAME
              , @v_final_bottleneck_cols   = @v_final_bottleneck_cols + '
			  , BOTTLENECK_FLAG_' + COLUMN_NAME + ' AS ' + COLUMN_NAME
	FROM    #tblSCP0108_DATE_COLS A
	ORDER BY SORT_ORDER_NO;

    --TESTING : OK
    --exec debug_log @v_date_cols, 'T';return;
    --exec debug_log @v_final_sum_cols, 'T';return;


    DECLARE     @v_sql  NVARCHAR(MAX)       = N'';

    SET @v_sql  = N'
    	IF OBJECT_ID(''tempdb..#tblSCP0108_FINAL_TEMP'') IS NOT NULL
			DROP TABLE #tblSCP0108_FINAL_TEMP;

        --빈테이블 생성
        SELECT	  A.DV
                , A.VER_ID
			    , A.VER_SEQ
			    , A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.LINE_ID
			    , A.MDL_NM
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
                ' + @v_date_cols + N'
                ' + @v_bottleneck_cols + N'
        INTO    #tblSCP0108_FINAL_TEMP
		FROM    #tblSCP0108_RAW A
        WHERE   1<>1;

        INSERT INTO #tblSCP0108_FINAL_TEMP
        SELECT	  A.DV
                , A.VER_ID
			    , A.VER_SEQ
			    , A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.LINE_ID
			    , A.MDL_NM
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
                ' + @v_date_cols + N'
                ' + @v_bottleneck_cols + N'
		FROM    #tblSCP0108_RAW A
        WHERE   1=1;

        --TESTING : NOK
        --select * from #tblSCP0108_FINAL_TEMP;return;


    	IF OBJECT_ID(''tempdb..#tblSCP0108_FINAL'') IS NOT NULL
			DROP TABLE #tblSCP0108_FINAL;

        SELECT	  A.DV
                , A.VER_ID
			    , A.VER_SEQ
			    , A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.LINE_ID
			    , A.MDL_NM              AS NICK_NAME
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
                ' + @v_final_sum_cols + N'
                ' + @v_final_sum_bottleneck_cols + N'
        INTO    #tblSCP0108_FINAL
		FROM    #tblSCP0108_FINAL_TEMP A
        GROUP BY  A.DV
                , A.VER_ID
				, A.VER_SEQ
                , A.DIVISION_ID
		        , A.COMPANY_ID
		        , A.SITE_ID
		        , A.PLANT_ID
		        , A.LINE_ID
		        , A.OPERATION_ID
		        , A.ELTR_LN_TP_CD
		        , A.MDL_NM;

        SELECT	  A.DV
                , A.VER_ID
			    , A.VER_SEQ
			    , A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.LINE_ID
			    , A.NICK_NAME
			    , A.OPERATION_ID
			    , O.OPERATION_NAME
			    , A.ELTR_LN_TP_CD
                ' + @v_final_cols + N'
			    , IIF(A.DIVISION_ID = ''*'', ''*'', dbo.FN_GET_DIVISION_NAME(A.DIVISION_ID))   AS DIVISION_NAME
			    , IIF(A.SITE_ID = ''*'', ''*'',  S.SITE_NAME)				AS SITE_NAME
			    , IIF(A.PLANT_ID = ''*'', ''*'', P.PLANT_NAME)			    AS PLANT_NAME
			    , IIF(A.LINE_ID = ''*'', ''*'',  L.LINE_NAME)				AS LINE_NAME
		FROM    #tblSCP0108_FINAL A
				LEFT JOIN #tblSCP0104_SITE S WITH(NOLOCK) ON
					    A.SITE_ID		    = S.SITE_ID
			    LEFT JOIN #tblSCP0104_COMPANY C WITH(NOLOCK) ON
					    A.COMPANY_ID		= C.COMPANY_ID
			    LEFT JOIN #tblSCP0104_PLANT P WITH(NOLOCK) ON
					    A.PLANT_ID          = P.PLANT_ID
			    LEFT JOIN #tblSCP0104_LINE L WITH(NOLOCK) ON
					    A.LINE_ID		    = L.LINE_ID
			    LEFT JOIN #tblSCP0104_OPERATION O ON
					    A.OPERATION_ID		= O.OPERATION_ID
        ORDER BY  A.DV
                , A.VER_ID
				, A.VER_SEQ
                , A.DIVISION_ID
		        , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.LINE_ID
		        , A.NICK_NAME
		        , A.OPERATION_ID
		        , A.ELTR_LN_TP_CD;
        
        --bottleneck 상태표시용
        SELECT	  A.DV
                , A.VER_ID
			    , A.VER_SEQ
			    , A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.LINE_ID
			    , A.NICK_NAME
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
                ' + @v_final_bottleneck_cols + N'
		FROM    #tblSCP0108_FINAL A
        ORDER BY  A.DV
                , A.VER_ID
				, A.VER_SEQ
                , A.DIVISION_ID
		        , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.LINE_ID
		        , A.NICK_NAME
		        , A.OPERATION_ID
		        , A.ELTR_LN_TP_CD';

    --TESTING : OK
    --exec debug_log @v_sql, 'T';return;

PRINT CONCAT('ELAPSED_TIME-Final : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME_BEG, 114));SET @V_ELAPSED_TIME_BEG = CURRENT_TIMESTAMP;

    EXEC(@v_sql);


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
	IF OBJECT_ID('tempdb..#tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN') IS NOT NULL
		DROP TABLE #tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN;
	IF OBJECT_ID('tempdb..#tblSCP0108_DATE_COLS') IS NOT NULL
		DROP TABLE #tblSCP0108_DATE_COLS;
	IF OBJECT_ID('tempdb..#tblSCP0108_FINAL') IS NOT NULL
		DROP TABLE #tblSCP0108_FINAL;
	IF OBJECT_ID('tempdb..#tblSCP0108_FINAL_TEMP') IS NOT NULL
		DROP TABLE #tblSCP0108_FINAL_TEMP;
	IF OBJECT_ID('tempdb..#tblSCP0108_PLAN_TP') IS NOT NULL
		DROP TABLE #tblSCP0108_PLAN_TP;
	IF OBJECT_ID('tempdb..#tblSCP0108_RAW1') IS NOT NULL
		DROP TABLE #tblSCP0108_RAW1;
	IF OBJECT_ID('tempdb..#tblSCP0108_RAW') IS NOT NULL
		DROP TABLE #tblSCP0108_RAW;
	IF OBJECT_ID('tempdb..#tblSCP0108_RAW_TEMP') IS NOT NULL
		DROP TABLE #tblSCP0108_RAW_TEMP;
	IF OBJECT_ID('tempdb..#tblSCP0104_OPERATION') IS NOT NULL
		DROP TABLE #tblSCP0104_OPERATION;
END

