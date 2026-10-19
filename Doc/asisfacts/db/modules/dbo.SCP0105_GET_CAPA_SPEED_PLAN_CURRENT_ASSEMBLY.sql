
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0105_GET_CAPA_SPEED_PLAN_CURRENT_ASSEMBLY
 * Description  : CAPA LINE ASSING
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/19   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/07/11   chaan        V1.1.3                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 3차 Update
 * 2024/07/11   chaan        V1.1.4                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - EDITABLE 수정
 *                                                                                                           - FACTROY_NAME 시노님 참조로 변경
 * 2024/08/03   chaan        V1.1.5                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 뷰로 대체
 * 2024/08/12   chaan        V1.1.6                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - PPM 조회 방식을 Speed Plan 저장된 값으로 대체
                                                                                                             - EDITABLE_YN, BASE_EDITABLE_YN - 설비대수, 속도, PPM 무조건 수정가능으로 변경
 * 2024/08/12   chaan        V1.1.7                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 모든 Measure 수정 가능하도록 Editable 변경
 * 2024/08/30   chaan        V1.1.8                PJ20239037 LGES CPS VOE 반영 및 고도화     - 모든 Measure 수정 가능하도록 Editable 변경 - 월별 속도 수정 가능
                                                                                                             - CPS 전용뷰로 대체
                                                                                                             - Formation 적용
 * 2024/10/14   jahn1502						   															 - Measure Color 적용
 * 2024.10.28	chaan        V1.1.9                PJ20239037 LGES CPS VOE 반영 및 고도화                     - 컬럼순서 변경 : 공정, 모델 -> 모델, 공정
 * 2024.12.09	chaan        V1.1.10               PJ20239037 LGES CPS VOE 반영 및 고도화                     - Pre 예외 처리
*/

--CREATE PROCEDURE [dbo].[SCP0105_GET_CAPA_SPEED_PLAN_CURRENT_ASSEMBLY]
CREATE PROCEDURE [dbo].[SCP0105_GET_CAPA_SPEED_PLAN_CURRENT_ASSEMBLY]
	  @p_version			NVARCHAR(10)
	, @p_version_seq		TINYINT
	, @p_prog_stat			NVARCHAR(1)
	, @p_division_id		NVARCHAR(30)
	, @p_site_id			NVARCHAR(MAX)
	, @p_plant_id  			NVARCHAR(MAX)
	, @p_factory_id			NVARCHAR(MAX)
	, @p_line_id			NVARCHAR(MAX)
	, @p_operation_id		NVARCHAR(MAX)
	, @p_item_id		    NVARCHAR(MAX)
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
 --   DECLARE @p_item_id		    NVARCHAR(MAX)		= N'';
	--DECLARE @p_electrode_type	NVARCHAR(MAX)		= N'';
	--DECLARE @p_program_id		NVARCHAR(100)		= N'SCP0105';
	--DECLARE @p_sheet_name		NVARCHAR(100)		= N'ASSEMBLY';
 --   DECLARE @p_user_id			NVARCHAR(30)		= N'iamarock';
 --   DECLARE @debug_mode			NVARCHAR(1)			= N'F';


	DECLARE @V_ELAPSED_TIME_BEG     DATETIME                = CURRENT_TIMESTAMP;

    DECLARE     @v_from_yyyy            NVARCHAR(4)     = SUBSTRING(@p_version, 1, 4);
    DECLARE     @v_from_yyyymm          NVARCHAR(6)     = CONVERT(NVARCHAR(6), DATEADD(MM, 1, CONVERT(DATETIME, @p_version + '01')), 112);

	DECLARE @v_result_to_yyyymm			NVARCHAR(6)         = N'';

    SET @v_result_to_yyyymm     = CONVERT(CHAR(8), DATEADD(MM, -1, CONVERT(DATETIME, @p_version + '01')), 112);

    PRINT CONCAT('@v_result_to_yyyymm : ', @v_result_to_yyyymm);
    --return;


	IF OBJECT_ID('tempdb..#tblSCP0105_DATE_COLS') IS NOT NULL
		DROP TABLE #tblSCP0105_DATE_COLS;
    
    --빈테이블 생성
    SELECT	  COLUMN_NAME
			, COLUMN_LABEL_NAME
			, SMALL_CLASS_LABEL_NAME
			, LARGE_CLASS_LABEL_NAME
			, DAY_CODE
			, SORT_ORDER_NO
    INTO    #tblSCP0105_DATE_COLS
	FROM	dbo.FN_SCP0104_GET_SPREAD_TITLE(@v_from_yyyymm, @p_program_id, @p_sheet_name) A
    WHERE   1<>1;
    
    INSERT INTO #tblSCP0105_DATE_COLS
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
--select * from #tblSCP0105_DATE_COLS;return;

	DECLARE @v_to_yyyy			NVARCHAR(4)			= '';

    SELECT  @v_to_yyyy  = MAX(SMALL_CLASS_LABEL_NAME)
    FROM    #tblSCP0105_DATE_COLS;

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

	    IF OBJECT_ID('tempdb..#tblSCP0105_MEASURE') IS NOT NULL
			DROP TABLE #tblSCP0105_MEASURE;

        --빈테이블 생성
/*        SELECT    COLUMN_NAME           AS MEASURE	
                , COLUMN_LABEL_NAME     AS MEASURE_NAME
                , SORT_ORDER_NO
        INTO    #tblSCP0105_MEASURE
        FROM    [SCM_MST_SHEET_MEASURE]
        WHERE   1<>1;

        INSERT INTO #tblSCP0105_MEASURE
        SELECT    MEASURE
                , MEASURE_NAME
                , SORT_ORDER_NO
        FROM     [dbo].[FN_SCP0105_GET_CAPA_MEASURE](@p_program_Id, @p_sheet_name);*/
        SELECT A.COLUMN_NAME           AS MEASURE	
             , A.COLUMN_LABEL_NAME     AS MEASURE_NAME
             , A.SORT_ORDER_NO
		     , A.ATTRIBUTE3			--RGB 색상코드
          INTO    #tblSCP0105_MEASURE
          FROM SCM_MST_SHEET_MEASURE A WITH(NOLOCK)
         WHERE 1=1
		   AND PROGRAM_ID = 'SCP0105'
		   AND SHEET_NAME = 'ASSEMBLY'
		   AND VALID_YN='Y'

--TESTING : NOK
--select * from #tblSCP0105_MEASURE;return;


	    IF OBJECT_ID('tempdb..#tblSCP0105_OPERATION_ELECTRODE_TYPE') IS NOT NULL
			DROP TABLE #tblSCP0105_OPERATION_ELECTRODE_TYPE;

        SELECT    A.SEGMENT1		AS DIVISION_ID
                , A.SEGMENT2		AS OPERATION_ID
                , A.SEGMENT3		AS ELTR_LN_TP_CD
                , A.ATTRIBUTE1		AS EQP_SPED_UNIT_CD
        INTO    #tblSCP0105_OPERATION_ELECTRODE_TYPE
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1=1
			--AND SEGMENT1 = 'SCP'
            AND A.LOOKUP_TYPE  = 'OPERATION_ELECTRODE_TYPE'
            AND A.VALID_YN  = 'Y';

--TESTING : NOK
--select * from #tblSCP0105_OPERATION_ELECTRODE_TYPE;return;


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
            AND A.LOOKUP_TYPE  = 'OPERATION_SPEED_UNIT'
            AND A.VALID_YN  = 'Y';

--TESTING : NOK
--select * from #tblSCP0105_SPEED_UNIT_ALL;return;

	    IF OBJECT_ID('tempdb..#tblSCP0105_SPEED_UNIT_GROUP_MSR') IS NOT NULL
			DROP TABLE #tblSCP0105_SPEED_UNIT_GROUP_MSR;

            SELECT    A.UNIT_GROUP
                    , A.MSR_TP_CD
                    , MIN(A.DISPLAY_SEQ)      AS DISPLAY_SEQ
                    , MAX(A.UNIT_GROUP_SEQ)   AS UNIT_GROUP_SEQ
            INTO    #tblSCP0105_SPEED_UNIT_GROUP_MSR
            FROM    #tblSCP0105_SPEED_UNIT_ALL A
            WHERE   1=1
                AND MSR_TP_CD <> 'M'
            GROUP BY  A.UNIT_GROUP
                    , A.MSR_TP_CD

	    IF OBJECT_ID('tempdb..#tblSCP0105_SPEED_UNIT_GROUP') IS NOT NULL
			DROP TABLE #tblSCP0105_SPEED_UNIT_GROUP;

        SELECT    A.UNIT_GROUP
                , MAX(A.UNIT_GROUP_SEQ)   AS UNIT_GROUP_SEQ
        INTO    #tblSCP0105_SPEED_UNIT_GROUP
        FROM    #tblSCP0105_SPEED_UNIT_ALL A
        GROUP BY A.UNIT_GROUP

--TESTING : NOK
--select * from #tblSCP0105_SPEED_UNIT_GROUP_MSR;return;


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


	IF OBJECT_ID('tempdb..#tblSCP0105_OERATION_LN_TP') IS NOT NULL
		DROP TABLE #tblSCP0105_OERATION_LN_TP;

        SELECT    A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
                , CONVERT(NVARCHAR(100), NULL)                                  AS SHOP_GROUP_ID
                , CONVERT(NVARCHAR(100), NULL)                                  AS OPERATION_NAME
                , CONVERT(NVARCHAR(100), NULL)                                  AS ELTR_LN_TP_NM
        INTO    #tblSCP0105_OERATION_LN_TP
        FROM    SCP_MST_CAPA_LINE_MDL A WITH(NOLOCK)
        WHERE   1<>1

        INSERT INTO #tblSCP0105_OERATION_LN_TP
        SELECT    A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
                , S.SHOP_GROUP_ID
                , (A.OPERATION_ID	+ ' ' + O.OPERATION_NAME)					AS OPERATION_NAME
                , (A.ELTR_LN_TP_CD	+ ' ' + E.ELTR_LN_TP_NM)					AS ELTR_LN_TP_NM
        FROM    SCP_MST_CAPA_LINE_MDL A WITH(NOLOCK)
            LEFT JOIN (
                        SELECT    DIVISION_ID
                                , SITE_ID
                                , PLANT_ID
                                , SHOP_GROUP_ID
                                , OPERATION_GROUP   AS SHOP_GROUP_NAME
                        FROM    SCM_SITE_HIERARCHY_CPS_V_SN WITH(NOLOCK)
                        WHERE   1=1
                            --AND SHOP_GROUP_ID <> 'F'
                        GROUP BY  DIVISION_ID
                                , SITE_ID
                                , PLANT_ID
                                , SHOP_GROUP_ID
                                , OPERATION_GROUP
                        ) S ON
                    A.DIVISION_ID   = S.DIVISION_ID
			    AND A.SITE_ID		= S.SITE_ID
			    AND A.PLANT_ID		= S.PLANT_ID
            LEFT JOIN (
	                    SELECT	  B.SEGMENT1 AS DIVISION_ID
			                    , B.SEGMENT2 AS OPERATION_ID
			                    , B.SEGMENT3 AS ELTR_LN_TP_CD
			                    , B.SEGMENT3 AS ELTR_LN_TP_NM
                        FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
                                        A.LOOKUP_TYPE = B.LOOKUP_TYPE
	                    WHERE	1=1
		                    AND A.LOOKUP_GROUP  = 'SCP'
		                    AND A.LOOKUP_TYPE   = 'OPERATION_ELECTRODE_TYPE'
		                    AND B.VALID_YN      = 'Y'
                        ) E ON
                    A.DIVISION_ID   = E.DIVISION_ID
			    AND A.OPERATION_ID  = E.OPERATION_ID
			    AND A.ELTR_LN_TP_CD	= E.ELTR_LN_TP_CD
            LEFT JOIN (
						SELECT    A.CODE    AS OPERATION_ID
								, A.NAME    AS OPERATION_NAME
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
                        ) O ON
                    A.OPERATION_ID = O.OPERATION_ID
        GROUP BY    A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
                , S.SHOP_GROUP_ID
                , O.OPERATION_NAME
                , E.ELTR_LN_TP_NM

--TESTING : NOK
--select * from #tblSCP0105_OERATION_LN_TP;return;


	IF OBJECT_ID('tempdb..#tblSCP0105_OERATION') IS NOT NULL
		DROP TABLE #tblSCP0105_OERATION;

    SELECT    A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
            , A.OPERATION_NAME
    INTO    #tblSCP0105_OERATION
    FROM    #tblSCP0105_OERATION_LN_TP A
    WHERE   1<>1;

    INSERT INTO #tblSCP0105_OERATION
    SELECT    A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
            , A.OPERATION_NAME
    FROM    #tblSCP0105_OERATION_LN_TP A
    GROUP BY  A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
            , A.OPERATION_NAME;

--TESTING : NOK
--select * from #tblSCP0105_OERATION;return;


	IF OBJECT_ID('tempdb..#tblSCP0105_LN_TP') IS NOT NULL
		DROP TABLE #tblSCP0105_LN_TP;

    SELECT    A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
            , A.ELTR_LN_TP_NM
    INTO    #tblSCP0105_LN_TP
    FROM    #tblSCP0105_OERATION_LN_TP A
    WHERE   1<>1;

    INSERT INTO #tblSCP0105_LN_TP
    SELECT    A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
            , A.ELTR_LN_TP_NM
    FROM    #tblSCP0105_OERATION_LN_TP A
    GROUP BY  A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
			, A.ELTR_LN_TP_CD
            , A.ELTR_LN_TP_NM

--TESTING : NOK
--select * from #tblSCP0105_LN_TP;return;



--    --NICKNAME 은 ID 가 따로 없어서 ID 로 구분할 수 없으므로 더미 테이블을 찾아서 더미 NICKNAME 인지 확인 필요
--	IF OBJECT_ID('tempdb..#tblSCP0105_DUMMY_CODE_NICK_NAME') IS NOT NULL
--		DROP TABLE #tblSCP0105_DUMMY_CODE_NICK_NAME;
    
--    --빈테이블 생성
--    SELECT    CODE
--            , NAME
--    INTO    #tblSCP0105_DUMMY_CODE_NICK_NAME
--    FROM    SCP_MST_CAPA_DUMMY_CODE WITH(NOLOCK)
--    WHERE   1<>1;
    
--    INSERT INTO #tblSCP0105_DUMMY_CODE_NICK_NAME
--    SELECT    CODE
--            , NAME
--    FROM    SCP_MST_CAPA_DUMMY_CODE WITH(NOLOCK)
--    WHERE   1=1
--        AND CODE_TP = 'N';

----TESTING : NOK
----select * from #tblSCP0105_DUMMY_CODE_NICK_NAME;return;


	IF OBJECT_ID('tempdb..#tblSCP0105_DUMMY_CODE_NICK_NAME') IS NOT NULL
		DROP TABLE #tblSCP0105_DUMMY_CODE_NICK_NAME;

    SELECT  DISTINCT 
            NICK_NAME
    INTO    #tblSCP0105_DUMMY_CODE_NICK_NAME
    FROM    FN_SCM0002_GET_CAPA_ITEM_POPUP('', '')
    WHERE   1<>1
        AND ISNULL(NICK_NAME, '') <> ''
    
    INSERT INTO #tblSCP0105_DUMMY_CODE_NICK_NAME
    SELECT  DISTINCT 
            NICK_NAME
    FROM    FN_SCM0002_GET_CAPA_ITEM_POPUP('', '')
    WHERE   1=1
        AND ISNULL(NICK_NAME, '') <> ''


PRINT CONCAT('@p_prog_stat : ', @p_prog_stat);
--return;


    BEGIN --**************************************************************************************************************************************************************************************************

	IF OBJECT_ID('tempdb..#tblSCP0105_RAW') IS NOT NULL
		DROP TABLE #tblSCP0105_RAW;

    SELECT  A.*
    INTO    #tblSCP0105_RAW
    FROM    SCP_MST_CAPA_SPEED_PLAN_V A
    WHERE   1<>1

    INSERT INTO #tblSCP0105_RAW
    SELECT  A.*
    FROM    SCP_MST_CAPA_SPEED_PLAN_V A
    WHERE   1=1
		AND A.OPERATION_ID <> 'AFFFF'
		AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD  IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		AND (((@p_item_id	    IS NULL OR @p_item_id	        = '') OR A.ITEM_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_item_id, ',')))
                                                                      OR A.NICK_NAME      IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_item_id, ',')))

    END --****************************************************************************************************************************************************************************************************

--TESTING : NOK
--select * from #tblSCP0105_RAW WHERE YYYYMM = '202408';return;


	DECLARE @v_date_cols                    NVARCHAR(MAX) = N'';
	DECLARE @v_priority_cols                NVARCHAR(MAX) = N'';
	DECLARE @v_final_cols                   NVARCHAR(MAX) = N'';
	DECLARE @v_final_sum_cols               NVARCHAR(MAX) = N'';
	DECLARE @v_final_sum_priority_cols      NVARCHAR(MAX) = N'';
	DECLARE @v_final_priority_cols          NVARCHAR(MAX) = N'';

	SELECT      @v_date_cols       = @v_date_cols + '
			  , ' +
				CASE
					WHEN CHARINDEX('M_', COLUMN_NAME) = 1   THEN 'CONVERT(FLOAT, CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 5, 6) THEN QTY END) AS ' + COLUMN_NAME
					WHEN CHARINDEX('Y_', COLUMN_NAME) = 1   THEN 'CONVERT(FLOAT, CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 3, 4) THEN QTY END) AS ' + COLUMN_NAME
				END
              , @v_priority_cols  = @v_priority_cols + '
			  , ' +
				CASE
                    WHEN CHARINDEX('M_01', COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 5, 6) THEN ASSIGN_PRIORITY END AS ' + COLUMN_NAME + '_ASSIGN_PRIORITY'
					WHEN CHARINDEX('Y_',   COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 3, 4) THEN ASSIGN_PRIORITY END AS ' + COLUMN_NAME + '_ASSIGN_PRIORITY'
				END
              , @v_final_sum_cols      = @v_final_sum_cols + '
			  , MAX(' + COLUMN_NAME + ') AS ' + COLUMN_NAME
              , @v_final_sum_priority_cols   = @v_final_sum_priority_cols + '
			  , MAX(' + COLUMN_NAME + '_ASSIGN_PRIORITY) AS ' + COLUMN_NAME + '_ASSIGN_PRIORITY'
              , @v_final_cols   = @v_final_cols + '
			  , ' + COLUMN_NAME
              , @v_final_priority_cols   = @v_final_priority_cols + '
			  , ' + COLUMN_NAME + '_ASSIGN_PRIORITY AS ' + COLUMN_NAME + '_ASSIGN_PRIORITY'
	FROM    #tblSCP0105_DATE_COLS A
	ORDER BY SORT_ORDER_NO;

    --TESTING : OK
    --exec debug_log @v_priority_cols, 'T';return;


    DECLARE     @v_sql  NVARCHAR(MAX)       = N'';

    SET @v_sql  = N'
    	IF OBJECT_ID(''tempdb..#tblSCP0105_FINAL'') IS NOT NULL
			DROP TABLE #tblSCP0105_FINAL;
        
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
                , A.PFRSLT_QTY
                , A.BASE_QTY
                , A.ELTR_QTY
                , A.MMS_CF
                , A.UI_UPD_YN
                , A.DUMMY_YN
                ' + @v_date_cols + N'
                ' + @v_priority_cols + N'
        INTO    #tblSCP0105_FINAL
		FROM    #tblSCP0105_RAW A;

        --TESTING : NOK
        --select * from #tblSCP0105_FINAL;return;
        --select * from #tblSCP0105_FINAL WHERE NICK_NAME = ''TEST DUMMY!!'';--return;
        --select * from #tblSCP0105_FINAL WHERE NICK_NAME = ''E129A'' AND ELTR_LN_TP_CD = ''Anode'';return;
        

    	IF OBJECT_ID(''tempdb..#tblSCP0105_FINAL1'') IS NOT NULL
			DROP TABLE #tblSCP0105_FINAL1;

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
                , MAX(A.PFRSLT_QTY)       AS PFRSLT_QTY
                , MAX(A.BASE_QTY)         AS BASE_QTY
                , MAX(A.ELTR_QTY)         AS ELTR_QTY
                , MAX(A.MMS_CF)           AS MMS_CF
                , MAX(A.UI_UPD_YN)        AS UI_UPD_YN
                , MAX(A.DUMMY_YN)         AS DUMMY_YN
                ' + @v_final_sum_cols + N'
                ' + @v_final_sum_priority_cols + N'
        INTO    #tblSCP0105_FINAL1
		FROM    #tblSCP0105_FINAL A
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

        --TESTING : NOK
        --select * from #tblSCP0105_FINAL1;--return;
--return;
        
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
                , A.PFRSLT_QTY
                , A.BASE_QTY
                , A.ELTR_QTY
                , A.MMS_CF
                , A.UI_UPD_YN
                ' + @v_final_cols + N'
                ' + @v_final_priority_cols + N'
			    , M.MEASURE_NAME
                , M.SORT_ORDER_NO
                , G.UNIT_GROUP_SEQ                          AS SPEED_UNIT_GROUP_SEQ
			    ------, CASE
				   ------ WHEN (N.NICK_NAME IS NULL) THEN ''Y''
				   ------ ELSE ''N''
			    ------  END                                       AS NICK_NAME_DUMMY_YN -- NICK_NAME 더미 여부는 Speed Plan 입력항목(Meaasrue) 을 결정하므로 따로 저장해둔다
			    , ''N''                                             AS NICK_NAME_DUMMY_YN -- NICK_NAME 더미 여부는 Speed Plan 입력항목(Meaasrue) 을 결정하므로 따로 저장해둔다
                , A.DUMMY_YN
                , CASE
                    WHEN A.SPEED_UNIT_GROUP IN (''EQP_NBU'')                                                                                                    THEN ''Y'' --설비대수는 무조건 수정 가능
                    --WHEN A.SPEED_UNIT_GROUP IN (''EQP_SPED'') AND (A.DUMMY_YN = ''Y'' OR A.OPERATION_ID LIKE ''P%'' OR A.MSR_TP_CD IN (''TTT'', ''PPM_AVG'')) THEN ''Y'' --속도
                    --WHEN A.SPEED_UNIT_GROUP IN (''EQP_SPED'') AND (A.DUMMY_YN = ''Y'' OR A.OPERATION_ID LIKE ''P%'')                                            THEN ''Y'' --속도
                    WHEN A.SPEED_UNIT_GROUP IN (''EQP_SPED'')                                                                                                   THEN ''Y'' --속도
                    WHEN A.SPEED_UNIT_GROUP IN (''PPM'')      AND N.NICK_NAME IS NULL AND A.OPERATION_ID IN (''A5000'', ''A7000'', ''A7400'')                   THEN ''Y'' --PPM : Dummy 이면서 MMS(A5000), CPM(A7000, A7400) 인 경우 PPM 수기
                    ELSE ''N''
                  END AS EDITABLE_YN
                , CASE
                    --WHEN A.SPEED_UNIT_GROUP IN (''EQP_NBU'')  AND (A.DUMMY_YN = ''Y'' OR A.OPERATION_ID LIKE ''P%'')                                            THEN ''Y''
                    WHEN A.SPEED_UNIT_GROUP IN (''EQP_NBU'')                                                                                                    THEN ''Y'' --설비대수는 무조건 수정 가능
                    --WHEN A.SPEED_UNIT_GROUP IN (''EQP_SPED'') AND (A.DUMMY_YN = ''Y'' OR A.OPERATION_ID LIKE ''P%'')                                            THEN ''Y'' --속도
                    WHEN A.SPEED_UNIT_GROUP IN (''EQP_SPED'')                                                                                                   THEN ''Y'' --속도
                    WHEN A.SPEED_UNIT_GROUP IN (''PPM'')      AND N.NICK_NAME IS NULL AND A.OPERATION_ID IN (''A5000'', ''A7000'', ''A7400'')                   THEN ''Y'' --PPM : Dummy 이면서 MMS(A5000), CPM(A7000, A7400) 인 경우 PPM 수기
                    ELSE ''N''
                  END AS BASE_EDITABLE_YN
                --, ''Y'' AS EDITABLE_YN
                --, ''Y'' AS BASE_EDITABLE_YN
			    , dbo.FN_GET_DIVISION_NAME (A.DIVISION_ID)							AS DIVISION_NAME
			    , S.SITE_NAME								                        AS SITE_NAME
			    , P.PLANT_NAME								                        AS PLANT_NAME
			    , F.FACTORY_NAME						                            AS FACTORY_NAME
			    , L.LINE_NAME								                        AS LINE_NAME
			    , O.OPERATION_NAME
				, M.ATTRIBUTE3														AS MEASURE_COLOR
                , ROW_NUMBER() OVER (ORDER BY (SELECT 1))							AS IDX
        FROM    #tblSCP0105_FINAL1 A
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
                LEFT JOIN #tblSCP0105_DUMMY_CODE_NICK_NAME N WITH(NOLOCK) ON
                        A.NICK_NAME         = N.NICK_NAME
                LEFT JOIN #tblSCP0105_MEASURE M ON
                        A.MSR_TP_CD    = M.MEASURE
                --LEFT JOIN #tblSCP0105_SPEED_UNIT_GROUP_MSR G ON
                LEFT JOIN #tblSCP0105_SPEED_UNIT_ALL G ON
                        A.SPEED_UNIT_GROUP = G.UNIT_GROUP
                    AND A.MSR_TP_CD = G.MSR_TP_CD
        ORDER BY  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
			    , A.COMPANY_ID
			    , S.SITE_NAME
			    , P.PLANT_NAME
			    , F.FACTORY_NAME
			    , L.LINE_NAME
			    , A.ITEM_ID
			    , A.NICK_NAME
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
                --, G.UNIT_GROUP_SEQ
                , M.SORT_ORDER_NO;
                ';

    --TESTING : OK
    --exec debug_log @v_sql, 'T';return;

    EXEC(@v_sql);

    --Unpivot 용 오리지널 테이블 구조 저장
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
		    , MSR_TP_CD
		    , YYYYMM
		    , BASE_QTY
		    , QTY
    FROM    SCP_MST_CAPA_SPEED_PLAN_CUTF WITH(NOLOCK)
    WHERE   1<>1;


	IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_BASE') IS NOT NULL
		DROP TABLE #tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_BASE;
	IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_BASE_UI_UPD_YN') IS NOT NULL
		DROP TABLE #tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_BASE_UI_UPD_YN;
	IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_CF') IS NOT NULL
		DROP TABLE #tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_CF;
	IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_RESULT') IS NOT NULL
		DROP TABLE #tblSCP0105_CHECK_CAPA_SPEED_PLAN_BY_ASSIGN_RESULT;
	IF OBJECT_ID('tempdb..#tblSCP0105_DATE_COLS') IS NOT NULL
		DROP TABLE #tblSCP0105_DATE_COLS;
	IF OBJECT_ID('tempdb..#tblSCP0105_DUMMY_CODE_NICK_NAME') IS NOT NULL
		DROP TABLE #tblSCP0105_DUMMY_CODE_NICK_NAME;
	IF OBJECT_ID('tempdb..#tblSCP0105_FACTORY') IS NOT NULL
		DROP TABLE #tblSCP0105_FACTORY;
	IF OBJECT_ID('tempdb..#tblSCP0105_FINAL1') IS NOT NULL
		DROP TABLE #tblSCP0105_FINAL1;
	IF OBJECT_ID('tempdb..#tblSCP0105_FINAL') IS NOT NULL
		DROP TABLE #tblSCP0105_FINAL;
	IF OBJECT_ID('tempdb..#tblSCP0105_LINE') IS NOT NULL
		DROP TABLE #tblSCP0105_LINE;
	IF OBJECT_ID('tempdb..#tblSCP0105_MEASURE') IS NOT NULL
		DROP TABLE #tblSCP0105_MEASURE;
	IF OBJECT_ID('tempdb..#tblSCP0105_PLANT') IS NOT NULL
		DROP TABLE #tblSCP0105_PLANT;
	IF OBJECT_ID('tempdb..#tblSCP0105_RAW') IS NOT NULL
		DROP TABLE #tblSCP0105_RAW;
	IF OBJECT_ID('tempdb..#tblSCP0105_RAW_ALL') IS NOT NULL
		DROP TABLE #tblSCP0105_RAW_ALL;
	IF OBJECT_ID('tempdb..#tblSCP0105_RAW_ALL_TEMP') IS NOT NULL
		DROP TABLE #tblSCP0105_RAW_ALL_TEMP;
	IF OBJECT_ID('tempdb..#tblSCP0105_RAW_KEYS') IS NOT NULL
		DROP TABLE #tblSCP0105_RAW_KEYS;
	IF OBJECT_ID('tempdb..#tblSCP0105_RAW_TEMP1') IS NOT NULL
		DROP TABLE #tblSCP0105_RAW_TEMP1;
	IF OBJECT_ID('tempdb..#tblSCP0105_RAW_TEMP2') IS NOT NULL
		DROP TABLE #tblSCP0105_RAW_TEMP2;
	IF OBJECT_ID('tempdb..#tblSCP0105_RAW_TEMP') IS NOT NULL
		DROP TABLE #tblSCP0105_RAW_TEMP;
	IF OBJECT_ID('tempdb..#tblSCP0105_RAW_TEMP_QTY') IS NOT NULL
		DROP TABLE #tblSCP0105_RAW_TEMP_QTY;
	IF OBJECT_ID('tempdb..#tblSCP0105_RAW_TEMP_SPEED') IS NOT NULL
		DROP TABLE #tblSCP0105_RAW_TEMP_SPEED;
	IF OBJECT_ID('tempdb..#tblSCP0105_RAW_TEMP_SPEED_AVG') IS NOT NULL
		DROP TABLE #tblSCP0105_RAW_TEMP_SPEED_AVG;
	IF OBJECT_ID('tempdb..#tblSCP0105_RAW_TEMP_SPEED_MAX') IS NOT NULL
		DROP TABLE #tblSCP0105_RAW_TEMP_SPEED_MAX;
	IF OBJECT_ID('tempdb..#tblSCP0105_RAW_TEMP_SPEED_TEMP') IS NOT NULL
		DROP TABLE #tblSCP0105_RAW_TEMP_SPEED_TEMP;
	IF OBJECT_ID('tempdb..#tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN') IS NOT NULL
		DROP TABLE #tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN;
	IF OBJECT_ID('tempdb..#tblSCP0105_SITE') IS NOT NULL
		DROP TABLE #tblSCP0105_SITE;
	IF OBJECT_ID('tempdb..#tblSCP0105_SPEED_UNIT_ALL') IS NOT NULL
		DROP TABLE #tblSCP0105_SPEED_UNIT_ALL;
	IF OBJECT_ID('tempdb..#tblSCP0105_SPEED_UNIT_GROUP') IS NOT NULL
		DROP TABLE #tblSCP0105_SPEED_UNIT_GROUP;
	IF OBJECT_ID('tempdb..#tblSCP0104_OPERATION') IS NOT NULL
		DROP TABLE #tblSCP0104_OPERATION;
END

