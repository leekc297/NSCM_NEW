

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0104_GET_CAPA_LINE_ASSIGN_ASSEMBLY
 * Description  : CAPA LINE ASSING
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/07   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/07/11   chaan        V1.1.3                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 3차 Update
 * 2024/07/11   chaan        V1.1.4                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - FACTROY_NAME 시노님 참조로 변경
 * 2024/08/05   chaan        V1.1.5                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - FLOAT 로 변형
 * 2024/08/19   chaan        V1.1.6                PJ20216994  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - SEQ 확장
 * 2024/08/26   chaan        V1.1.8                PJ20216994  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - SOP 추가
 *                                                                                                           - Code, Name 분리
                                                                                                             - Formation 적용
 * 2024.10.28	chaan        V1.1.9                PJ20239037 LGES CPS VOE 반영 및 고도화                     - 컬럼순서 변경 : 공정, 모델 -> 모델, 공정
 * 2024.12.09	chaan        V1.1.10               PJ20239037 LGES CPS VOE 반영 및 고도화                     - Pre 예외 처리
*/

--CREATE PROCEDURE [dbo].[SCP0104_GET_CAPA_LINE_ASSIGN_ASSEMBLY]
CREATE PROCEDURE [dbo].[SCP0104_GET_CAPA_LINE_ASSIGN_ASSEMBLY]
	  @p_version			NVARCHAR(30)
	, @p_version_seq		TINYINT
	, @p_division_id		NVARCHAR(30)
	, @p_site_id			NVARCHAR(MAX)
	, @p_plant_id  			NVARCHAR(MAX)
	, @p_factory_id			NVARCHAR(MAX)
	, @p_line_id			NVARCHAR(MAX)
	, @p_operation_id		NVARCHAR(MAX)
	, @p_item_id		    NVARCHAR(MAX)
    , @p_electrode_type		NVARCHAR(MAX)
	, @p_valid_flag			NVARCHAR(1)
	, @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
	, @p_user_id			NVARCHAR(30)
	, @debug_mode			NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_version			    NVARCHAR(30)        = N'202412';
	--DECLARE @p_version_seq		    TINYINT             = 1;
	--DECLARE @p_division_id		    NVARCHAR(30)		= N'81';
	--DECLARE @p_site_id			    NVARCHAR(MAX)		= N'';
	--DECLARE @p_plant_id  		    NVARCHAR(MAX)		= N'';
	--DECLARE @p_factory_id		    NVARCHAR(MAX)		= N'';
	--DECLARE @p_line_id			    NVARCHAR(MAX)		= N'A4A06';
	--DECLARE @p_operation_id		    NVARCHAR(MAX)		= N'';
 --   DECLARE @p_item_id		        NVARCHAR(MAX)		= N'';
	--DECLARE @p_electrode_type	    NVARCHAR(MAX)		= N'';
	--DECLARE @p_valid_flag		    NVARCHAR(1)			= N'';
	--DECLARE @p_program_id		    NVARCHAR(100)		= N'SCP0104';
	--DECLARE @p_sheet_name		    NVARCHAR(100)		= N'ASSEMBLY';
 --   DECLARE @p_user_id			    NVARCHAR(30)		= N'iamarock';
 --   DECLARE @debug_mode			    NVARCHAR(1)			= N'F';



    DECLARE     @v_from_yyyy            NVARCHAR(4)     = SUBSTRING(@p_version, 1, 4);
    DECLARE     @v_from_yyyymm          NVARCHAR(6)     = CONVERT(NVARCHAR(6), DATEADD(MM, 1, CONVERT(DATETIME, @p_version + '01')), 112);

	IF OBJECT_ID('tempdb..#tblSCP0104_DATE_COLS') IS NOT NULL
		DROP TABLE #tblSCP0104_DATE_COLS;

    SELECT	  COLUMN_NAME
			, COLUMN_LABEL_NAME
			, SMALL_CLASS_LABEL_NAME
			, LARGE_CLASS_LABEL_NAME
			, DAY_CODE
			, SORT_ORDER_NO
    INTO    #tblSCP0104_DATE_COLS
	FROM	dbo.FN_SCP0104_GET_SPREAD_TITLE(@v_from_yyyymm, @p_program_id, @p_sheet_name) A;

--TESTING : NOK
--select * from #tblSCP0104_DATE_COLS;return;


	IF OBJECT_ID('tempdb..#tblSCP0104_OPERATION') IS NOT NULL
		DROP TABLE #tblSCP0104_OPERATION;

	SELECT    A.CODE
			, A.NAME
    INTO    #tblSCP0104_OPERATION
    FROM    (
	            SELECT    A.OPERATION_ID        AS CODE
			            , MAX(A.OPERATION_NAME) AS NAME
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
	--SELECT	  A.OPERATION_ID							AS CODE
	--		--, A.OPERATION_ID + ' ' + B.OPERATION_NAME	AS NAME
	--		, B.OPERATION_NAME	                        AS NAME
	--		, A.DIVISION_ID								AS DIVISION_ID
	--		--, A.OPERATION_GROUP_ID						AS SHOP_GROUP_ID
	--		, A.PLANT_ID								AS PLANT_ID
	--		, A.FACTORY_ID								AS FACTORY_ID
	--		, A.LINE_ID									AS LINE_ID
 --   INTO    #tblSCP0104_OPERATION
	--FROM	[dbo].SCM_LINE_HIERARCHY_CPS_V_SN A  WITH(NOLOCK)
	--		JOIN (
	--				SELECT DISTINCT 
	--						  OPERATION_ID 
	--						, OPERATION_NAME
	--				FROM	[dbo].SCM_MST_OPERATION_SN B WITH(NOLOCK)
	--			) B ON  
	--				A.OPERATION_ID = B.OPERATION_ID
 --           JOIN (
	--                SELECT	  B.SEGMENT1 AS DIVISION_ID
	--		                , B.SEGMENT2 AS OPERATION_ID
 --                   FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
 --                           INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
 --                                   A.LOOKUP_TYPE = B.LOOKUP_TYPE
	--                WHERE	1=1
	--	                AND A.LOOKUP_GROUP  = 'SCP'
	--	                AND A.LOOKUP_TYPE   = 'OPERATION_ELECTRODE_TYPE'
	--	                AND B.VALID_YN      = 'Y'
 --                   GROUP BY  B.SEGMENT1
 --                           , B.SEGMENT2
 --                 ) E ON
 --               A.DIVISION_ID   = E.DIVISION_ID
	--		AND A.OPERATION_ID  = E.OPERATION_ID
	--GROUP BY  A.OPERATION_ID
	--		, B.OPERATION_NAME
	--		, A.DIVISION_ID
	--		--, A.OPERATION_GROUP_ID
	--		, A.PLANT_ID
	--		, A.FACTORY_ID
	--		, A.LINE_ID
 --   ORDER BY  A.OPERATION_ID;
    

--TESTING : NOK
--select * from #tblSCP0104_OPERATION;return;

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


	DECLARE @v_to_yyyy			NVARCHAR(4)			= '';

    SELECT  @v_to_yyyy  = MAX(SMALL_CLASS_LABEL_NAME)
    FROM    #tblSCP0104_DATE_COLS;

    PRINT CONCAT('@v_to_yyyy : ', @v_to_yyyy);
    --return;
	
----	DECLARE		@v_curr_date				DATETIME		= GETDATE();
------	DECLARE		@v_curr_yyyymm				NVARCHAR(8)		= FORMAT(@v_curr_date,'yyyyMM');
----	DECLARE		@v_curr_yyyymm				NVARCHAR(8)		= @p_version;

----	DECLARE		@v_version_cnt				INT				= 0;
----	DECLARE		@v_last_version				NVARCHAR(10)	= '';
----	DECLARE		@v_last_version_seq			INT				= NULL;
----	DECLARE		@v_last_version_prog_stat	NVARCHAR(2)		= '';

----	SELECT	  @v_version_cnt			= COUNT(*)
----	FROM	dbo.FN_SCP0104_GET_CAPA_VERSION(@p_division_id, @v_curr_yyyymm);

----    PRINT CONCAT('@v_version_cnt : ', @v_version_cnt);
----    --return;
	
----	--사업부/연월에 해당하는 버전이 하나도 없으면 버전 마스터(SCP_MST_CAPA_VERSION) 추가
----	IF @v_version_cnt = 0
----	BEGIN
----		EXEC CHECK_NEW_CAPA_VERSION @p_division_id, @v_curr_yyyymm, 'F';
----	END

----	SELECT	  @v_last_version			= VER_ID
----			, @v_last_version_seq		= VER_SEQ
----			, @v_last_version_prog_stat	= PROG_STAT
----	FROM	dbo.FN_SCP0104_GET_CAPA_VERSION(@p_division_id, @v_curr_yyyymm);

----    PRINT CONCAT('@v_last_version : ', @v_last_version);
----    PRINT CONCAT('@v_last_version_seq : ', @v_last_version_seq);
----    PRINT CONCAT('@v_last_version_prog_stat : ', @v_last_version_prog_stat);
    --return;


	DECLARE		@v_last_version_prog_stat	NVARCHAR(2)		= '';

	SELECT	@v_last_version_prog_stat	= PROG_STAT
	FROM    SCP_MST_CAPA_VERSION WITH(NOLOCK)
    WHERE   1=1
        AND DIVISION_ID = @p_division_id
        AND VER_ID      = @p_version
        AND VER_SEQ     = @p_version_seq   -- 2025.01.03 추가 (선택된 버전 상태에 따라 cutoff 또는 current 데이터 조회 필요)

    PRINT CONCAT('@v_last_version_prog_stat : ', @v_last_version_prog_stat);


	IF OBJECT_ID('tempdb..#tblSCP0104_RAW') IS NOT NULL
		DROP TABLE #tblSCP0104_RAW;

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
			, A.YYYYMM
			, IIF(A.ASSIGN_PRIORITY = 0, NULL, A.ASSIGN_PRIORITY)   AS ASSIGN_PRIORITY--우선순위가 없으면 클리어)A.ASSIGN_PRIORITY
			, dbo.FN_GET_DIVISION_NAME (A.DIVISION_ID)              AS DIVISION_NAME
			, S.SITE_NAME						                    AS SITE_NAME
			, C.COMPANY_NAME					                    AS COMPANY_NAME
			, P.PLANT_NAME						                    AS PLANT_NAME
			, F.FACTORY_NAME					                    AS FACTORY_NAME
			, L.LINE_NAME						                    AS LINE_NAME
			, A.DUMMY_YN
			, B.VALID_YN
			, V.PROG_STAT
            , O.NAME                                                AS OPERATION_NAME
	INTO    #tblSCP0104_RAW
	FROM	SCP_MST_CAPA_LINE_ASSIGN_CUTF A WITH(NOLOCK)
			LEFT JOIN SCP_MST_CAPA_VERSION V WITH(NOLOCK) ON
					A.DIVISION_ID		= V.DIVISION_ID
				AND A.VER_ID			= V.VER_ID
				AND A.VER_SEQ			= V.VER_SEQ
			LEFT JOIN SCP_MST_CAPA_LINE B WITH(NOLOCK) ON
					A.DIVISION_ID		= B.DIVISION_ID
				AND A.COMPANY_ID		= B.COMPANY_ID
				AND A.SITE_ID			= B.SITE_ID
				AND A.PLANT_ID			= B.PLANT_ID
				AND A.FACTORY_ID		= B.FACTORY_ID
				AND A.LINE_ID			= B.LINE_ID
				AND A.OPERATION_ID		= B.OPERATION_ID
				AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
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
				--	A.DIVISION_ID		= O.DIVISION_ID
				--AND A.PLANT_ID			= O.PLANT_ID
				--AND A.FACTORY_ID		= O.FACTORY_ID
				--AND A.LINE_ID			= O.LINE_ID
				    A.OPERATION_ID		= O.CODE
	WHERE	1<>1;

--PRINT CONCAT('@v_last_version_prog_stat : ', @v_last_version_prog_stat);RETURN;

    IF @v_last_version_prog_stat = '0' OR @v_last_version_prog_stat = '-'--CURRENT, Pre
    BEGIN
        INSERT INTO #tblSCP0104_RAW
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
			    , IIF(A.ASSIGN_PRIORITY = 0, NULL, A.ASSIGN_PRIORITY)   AS ASSIGN_PRIORITY--우선순위가 없으면 클리어)A.ASSIGN_PRIORITY
			    , dbo.FN_GET_DIVISION_NAME (A.DIVISION_ID)              AS DIVISION_NAME
			    , S.SITE_NAME						                    AS SITE_NAME
			    , C.COMPANY_NAME					                    AS COMPANY_NAME
			    , P.PLANT_NAME						                    AS PLANT_NAME
			    , F.FACTORY_NAME					                    AS FACTORY_NAME
			    , L.LINE_NAME						                    AS LINE_NAME
			    , A.DUMMY_YN
			    , A.VALID_YN
                , CONVERT(NVARCHAR(2), '0')                             AS PROG_STAT
                , ISNULL(O.NAME, '-')                                   AS OPERATION_NAME
	    FROM	SCP_MST_CAPA_LINE_ASSIGN A WITH(NOLOCK)
			    LEFT JOIN SCP_MST_CAPA_LINE B WITH(NOLOCK) ON
					    A.DIVISION_ID		= B.DIVISION_ID
				    AND A.COMPANY_ID		= B.COMPANY_ID
				    AND A.SITE_ID			= B.SITE_ID
				    AND A.PLANT_ID			= B.PLANT_ID
				    AND A.FACTORY_ID		= B.FACTORY_ID
				    AND A.LINE_ID			= B.LINE_ID
				    AND A.OPERATION_ID		= B.OPERATION_ID
				    AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
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
					   -- A.DIVISION_ID		= O.DIVISION_ID
				    --AND A.PLANT_ID			= O.PLANT_ID
				    --AND A.FACTORY_ID		= O.FACTORY_ID
				    --AND A.LINE_ID			= O.LINE_ID
				        A.OPERATION_ID		= O.CODE
	    WHERE	1=1
		    AND	A.YYYYMM BETWEEN @v_from_yyyy AND @v_to_yyyy
		    AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		    AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		    AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		    AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		    AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		    AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		    AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		    ------AND ((@p_item_id	    IS NULL OR @p_item_id   		= '') OR (A.ITEM_ID LIKE '%' + @p_item_id + '%') OR (A.NICK_NAME LIKE '%' + @p_item_id + '%'))
		    AND ((@p_item_id	        IS NULL OR @p_item_id   		= '') OR A.NICK_NAME IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_item_id, ',')))
		    AND (@p_valid_flag	    IS NULL OR @p_valid_flag   		= '' OR @p_valid_flag = 'ALL' OR A.VALID_YN = @p_valid_flag);
    END
    ELSE
    BEGIN
        INSERT INTO #tblSCP0104_RAW
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
			    , A.YYYYMM
			    , IIF(A.ASSIGN_PRIORITY = 0, NULL, A.ASSIGN_PRIORITY)   AS ASSIGN_PRIORITY--우선순위가 없으면 클리어)A.ASSIGN_PRIORITY
			    , dbo.FN_GET_DIVISION_NAME (A.DIVISION_ID)              AS DIVISION_NAME
			    , S.SITE_NAME						                    AS SITE_NAME
			    , C.COMPANY_NAME					                    AS COMPANY_NAME
			    , P.PLANT_NAME						                    AS PLANT_NAME
			    , F.FACTORY_NAME					                    AS FACTORY_NAME
			    , L.LINE_NAME						                    AS LINE_NAME
			    , A.DUMMY_YN
			    , A.VALID_YN
			    , V.PROG_STAT
                , ISNULL(O.NAME, '-')                                   AS OPERATION_NAME
	    FROM	SCP_MST_CAPA_LINE_ASSIGN_CUTF A WITH(NOLOCK)
			    LEFT JOIN SCP_MST_CAPA_VERSION V WITH(NOLOCK) ON
					    A.DIVISION_ID		= V.DIVISION_ID
				    AND A.VER_ID			= V.VER_ID
				    AND A.VER_SEQ			= V.VER_SEQ
			    LEFT JOIN SCP_MST_CAPA_LINE B WITH(NOLOCK) ON
					    A.DIVISION_ID		= B.DIVISION_ID
				    AND A.COMPANY_ID		= B.COMPANY_ID
				    AND A.SITE_ID			= B.SITE_ID
				    AND A.PLANT_ID			= B.PLANT_ID
				    AND A.FACTORY_ID		= B.FACTORY_ID
				    AND A.LINE_ID			= B.LINE_ID
				    AND A.OPERATION_ID		= B.OPERATION_ID
				    AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
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
					   -- A.DIVISION_ID		= O.DIVISION_ID
				    --AND A.PLANT_ID			= O.PLANT_ID
				    --AND A.FACTORY_ID		= O.FACTORY_ID
				    --AND A.LINE_ID			= O.LINE_ID
				        A.OPERATION_ID		= O.CODE
	    WHERE	1=1
		    AND A.VER_ID		= @p_version
		    AND A.VER_SEQ		= @p_version_seq
		    AND	A.YYYYMM BETWEEN @v_from_yyyy AND @v_to_yyyy
		    AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		    AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		    AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		    AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		    AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		    AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		    AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		    ------AND ((@p_item_id	    IS NULL OR @p_item_id   		= '') OR (A.ITEM_ID LIKE '%' + @p_item_id + '%') OR (A.NICK_NAME LIKE '%' + @p_item_id + '%'))
		    AND ((@p_item_id	        IS NULL OR @p_item_id   		= '') OR A.NICK_NAME IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_item_id, ',')))
		    AND (@p_valid_flag	    IS NULL OR @p_valid_flag   		= '' OR @p_valid_flag = 'ALL' OR A.VALID_YN = @p_valid_flag);
    END

--TESTING : NOK
    PRINT CONCAT('@p_valid_flag : ', @p_valid_flag);

--TESTING : NOK
--select * from #tblSCP0104_RAW;return;
--select * from #tblSCP0104_RAW WHERE VER_ID = '202408';return;


	DECLARE @v_date_cols           NVARCHAR(MAX) = N'';
	DECLARE @v_final_cols          NVARCHAR(MAX) = N'';

	SELECT      @v_date_cols       = @v_date_cols + '
			  , ' +
				CASE
					WHEN CHARINDEX('M_', COLUMN_NAME) = 1   THEN 'CONVERT(NUMERIC(4), CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 5, 6) THEN ASSIGN_PRIORITY END) AS ' + COLUMN_NAME
					WHEN CHARINDEX('Y_', COLUMN_NAME) = 1   THEN 'CONVERT(NUMERIC(4), CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 3, 4) THEN ASSIGN_PRIORITY END) AS ' + COLUMN_NAME
				END
              , @v_final_cols      = @v_final_cols + '
			  , SUM(' + COLUMN_NAME + ') AS ' + COLUMN_NAME
	FROM    #tblSCP0104_DATE_COLS A
	ORDER BY SORT_ORDER_NO;

    --TESTING : OK
    --exec debug_log @v_date_cols, 'T';return;
    --exec debug_log @v_final_cols, 'T';return;


    DECLARE     @v_sql  NVARCHAR(MAX)       = N'';

    SET @v_sql  = N'
    	IF OBJECT_ID(''tempdb..#tblSCP0104_FINAL'') IS NOT NULL
	    	DROP TABLE #tblSCP0104_FINAL;
        
	    SELECT    A.VER_ID
			    , A.VER_SEQ
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
			    , DIVISION_NAME
			    , SITE_NAME
			    , COMPANY_NAME
			    , PLANT_NAME
			    , FACTORY_NAME
			    , LINE_NAME
			    , OPERATION_NAME
			    , DUMMY_YN
			    , VALID_YN
                ' + @v_date_cols + N'
        INTO    #tblSCP0104_FINAL
		FROM    #tblSCP0104_RAW A;

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
			    , MAX(DIVISION_NAME)			AS DIVISION_NAME
			    , MAX(SITE_NAME)				AS SITE_NAME
			    , MAX(COMPANY_NAME)				AS COMPANY_NAME
			    , MAX(PLANT_NAME)				AS PLANT_NAME
			    , MAX(FACTORY_NAME)				AS FACTORY_NAME
			    , MAX(LINE_NAME)				AS LINE_NAME
			    , MAX(OPERATION_NAME)			AS OPERATION_NAME
			    , MAX(DUMMY_YN)                 AS DUMMY_YN
			    , MAX(VALID_YN)                 AS VALID_YN' + N'
                ' +  + @v_final_cols + N'
        FROM    #tblSCP0104_FINAL
	    GROUP BY  VER_ID
			    , VER_SEQ
                , DIVISION_ID
			    , COMPANY_ID
			    , SITE_ID
			    , PLANT_ID
			    , FACTORY_ID
			    , LINE_ID
			    , ITEM_ID
			    , NICK_NAME
			    , OPERATION_ID
			    , ELTR_LN_TP_CD
	    ORDER BY  VER_ID
			    , VER_SEQ
                , DIVISION_ID
			    , COMPANY_ID
			    , SITE_ID
			    , SITE_NAME
			    , COMPANY_NAME
			    , PLANT_ID
			    , PLANT_NAME
			    , FACTORY_ID
			    , FACTORY_NAME
			    , LINE_ID
			    , LINE_NAME
			    , ITEM_ID
			    , NICK_NAME
			    , OPERATION_ID
			    , OPERATION_NAME
			    , ELTR_LN_TP_CD
			    , DIVISION_NAME
                ';

    --TESTING : OK
    --exec debug_log @v_sql, 'T';return;

    EXEC(@v_sql);


	IF OBJECT_ID('tempdb..#tblSCP0104_DATE_COLS') IS NOT NULL
		DROP TABLE #tblSCP0104_DATE_COLS;
	IF OBJECT_ID('tempdb..#tblSCP0104_FINAL') IS NOT NULL
		DROP TABLE #tblSCP0104_FINAL;
	IF OBJECT_ID('tempdb..#tblSCP0104_RAW') IS NOT NULL
		DROP TABLE #tblSCP0104_RAW;
	IF OBJECT_ID('tempdb..#tblSCP0104_OPERATION') IS NOT NULL
		DROP TABLE #tblSCP0104_OPERATION;
END

