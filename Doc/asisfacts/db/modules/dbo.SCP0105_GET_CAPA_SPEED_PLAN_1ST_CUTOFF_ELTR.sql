
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0105_GET_CAPA_SPEED_PLAN_1ST_CUTOFF_ELTR
 * Description  : CAPA LINE ASSING
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/19   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/07/11   chaan        V1.1.4                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Speed Plan 실적 수정
 *                                                                                                           - FACTROY_NAME 시노님 참조로 변경
 * 2024/08/05   chaan        V1.1.5                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - FLOAT 로 변형
 * 2024/09/05   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 전극 Nickname 추가
                                                                                                             - Formation 적용
 * 2024.10.28	chaan        V1.1.9                PJ20239037 LGES CPS VOE 반영 및 고도화                     - 컬럼순서 변경 : 공정, 모델 -> 모델, 공정
 * 2024.12.09	chaan        V1.1.10               PJ20239037 LGES CPS VOE 반영 및 고도화                     - Pre 예외 처리
 * 2025/04/08   hrkim		 V1.1.11               PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - CPS 소형 확산
*/

--CREATE PROCEDURE [dbo].[SCP0105_GET_CAPA_SPEED_PLAN_1ST_CUTOFF_ELTR]
CREATE PROCEDURE [dbo].[SCP0105_GET_CAPA_SPEED_PLAN_1ST_CUTOFF_ELTR]
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

	--DECLARE @p_version			NVARCHAR(10)		= N'202408'
	--DECLARE @p_version_seq		TINYINT             = 12;
	--DECLARE @p_prog_stat		NVARCHAR(1)         = N'1'; -- '0' : Current, '1' : 1st Cutoff, '2' : 2nd Cutoff
	--DECLARE @p_division_id		NVARCHAR(30)		= N'81';
	--DECLARE @p_site_id			NVARCHAR(MAX)		= N'';
	--DECLARE @p_plant_id  		NVARCHAR(MAX)		= N'';
	--DECLARE @p_factory_id		NVARCHAR(MAX)		= N'';
	--DECLARE @p_line_id			NVARCHAR(MAX)		= N'';
	--DECLARE @p_operation_id		NVARCHAR(MAX)		= N'';
 --   DECLARE @p_item_id		    NVARCHAR(MAX)		= N'';
	--DECLARE @p_electrode_type	NVARCHAR(MAX)		= N'';
	--DECLARE @p_program_id		NVARCHAR(100)		= N'SCP0105';
	--DECLARE @p_sheet_name		NVARCHAR(100)		= N'ELTR';
 --   DECLARE @p_user_id			NVARCHAR(30)		= N'iamarock';
 --   DECLARE @debug_mode			NVARCHAR(1)			= N'F';


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

--TESTING : NOK
--select * from #tblSCP0105_DATE_COLS;return;

	DECLARE @v_to_yyyy			NVARCHAR(4)			= '';

    SELECT  @v_to_yyyy  = MAX(SMALL_CLASS_LABEL_NAME)
    FROM    #tblSCP0105_DATE_COLS;

PRINT CONCAT('@v_to_yyyy : ', @v_to_yyyy);

   -- --SCP_MST_CAPA_ELTR_SPEED_PLAN_CUTF 테이블에 @p_division_id, @p_plan_start_yyyymmdd 에 해당하는 데이터가 하나도 없으면 SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF 테이블의 목록을 기준으로 데이터 자동 생성
   -- EXEC SCP0105_CHECK_NEW_CAPA_SPEED_PLAN
			--  @p_version
			--, @p_version_seq
	  --      , @p_division_id
	  --      , @p_program_id
	  --      , @p_sheet_name
	  --      , @p_user_id
	  --      , 'F';


	    IF OBJECT_ID('tempdb..#tblSCP0105_EQP') IS NOT NULL
			DROP TABLE #tblSCP0105_EQP;

        SELECT    A.SEGMENT3        AS ELTR_TP_CD
                , A.SEGMENT4        AS ELTR_TP_NM_EN
                , A.SEGMENT5        AS ELTR_TP_NM_KO
                , A.DISPLAY_SEQ
        INTO    #tblSCP0105_EQP
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1=1
            AND A.LOOKUP_TYPE  = 'SCP_CAPA_ELTR_TP'
            AND A.VALID_YN  = 'Y';

--TESTING : NOK
--select * from #tblSCP0105_EQP;return;



	    IF OBJECT_ID('tempdb..#tblSCP0105_MEASURE') IS NOT NULL
			DROP TABLE #tblSCP0105_MEASURE;

        --빈테이블 생성
        SELECT    COLUMN_NAME           AS MEASURE	
                , COLUMN_LABEL_NAME     AS MEASURE_NAME
                , SORT_ORDER_NO
        INTO    #tblSCP0105_MEASURE
        FROM    [SCM_MST_SHEET_MEASURE]
        WHERE   1<>1;

        INSERT INTO #tblSCP0105_MEASURE
        SELECT    MEASURE
                , MEASURE_NAME
                , SORT_ORDER_NO
        FROM     [dbo].[FN_SCP0105_GET_CAPA_MEASURE](@p_program_Id, @p_sheet_name);

--TESTING : NOK
--select * from #tblSCP0105_MEASURE;return;


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


	IF OBJECT_ID('tempdb..#tblSCP0104_CODE_ALL') IS NOT NULL
		DROP TABLE #tblSCP0104_CODE_ALL;

    SELECT  *
    INTO    #tblSCP0104_CODE_ALL
    FROM    SCP_MST_CAPA_ELTR_LINE WITH(NOLOCK)
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
        FROM    SCP_MST_CAPA_ELTR_LINE_MDL A WITH(NOLOCK)
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
        FROM    SCP_MST_CAPA_ELTR_LINE_MDL A WITH(NOLOCK)
            LEFT JOIN (
                        SELECT    DIVISION_ID
                                , SITE_ID
                                , PLANT_ID
                                , SHOP_GROUP_ID
                                , OPERATION_GROUP   AS SHOP_GROUP_NAME
                        FROM    SCM_SITE_HIERARCHY_V_SN WITH(NOLOCK)
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
					    SELECT    OPERATION_ID 
							    , OPERATION_NAME
					    FROM	[dbo].SCM_MST_OPERATION_SN WITH(NOLOCK)
                        GROUP BY  OPERATION_ID 
							    , OPERATION_NAME
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


	IF OBJECT_ID('tempdb..#tblSCP_NICKNAME_ELTR') IS NOT NULL
		DROP TABLE #tblSCP_NICKNAME_ELTR;

        --빈테이블 생성
        SELECT    DIVISION_ID
                , ITEM_ID
                , NICK_NAME
        INTO    #tblSCP_NICKNAME_ELTR
        FROM    FN_SCM0002_GET_CAPA_ITEM_POPUP('', '')
        WHERE   1<>1

        INSERT INTO #tblSCP_NICKNAME_ELTR
        SELECT    DIVISION_ID
                , ITEM_ID
                , NICK_NAME
        FROM    FN_SCM0002_GET_CAPA_ITEM_POPUP('', '')
        WHERE   1=1

--TESTING : NOK
--select * from #tblSCP_NICKNAME_ELTR;return;


	IF OBJECT_ID('tempdb..#tblSCP0105_DUMMY_CODE_ITEM_ID') IS NOT NULL
		DROP TABLE #tblSCP0105_DUMMY_CODE_ITEM_ID;
    
    --빈테이블 생성
    SELECT    CODE
            , NAME
    INTO    #tblSCP0105_DUMMY_CODE_ITEM_ID
    FROM    SCP_MST_CAPA_DUMMY_CODE WITH(NOLOCK)
    WHERE   1<>1;
    
    INSERT INTO #tblSCP0105_DUMMY_CODE_ITEM_ID
    SELECT    MAX(CODE) AS CODE
            , NAME
    FROM    SCP_MST_CAPA_DUMMY_CODE WITH(NOLOCK)
    WHERE   1=1
        AND CODE_TP = 'I'
    GROUP BY NAME

--TESTING : NOK
--select * from #tblSCP0105_DUMMY_CODE_ITEM_ID;return;


PRINT CONCAT('@p_prog_stat : ', @p_prog_stat);
--return;


    BEGIN --**************************************************************************************************************************************************************************************************
    --PRINT N'GET - RESULT - BEGIN';
	IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_RESULT') IS NOT NULL
		DROP TABLE #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_RESULT;

	--빈테이블 생성
    SELECT    A.DIVISION_ID                 AS DIVISION_ID
            , A.COMPANY_ID                  AS COMPANY_ID
            , A.SITE_ID                     AS SITE_ID
            , A.PLANT_ID                    AS PLANT_ID
            , A.FACTORY_ID                  AS FACTORY_ID
            , A.LINE_ID                     AS LINE_ID
            , A.OPERATION_ID                AS OPERATION_ID
            , A.ELTR_LN_TP_CD               AS ELTR_LN_TP_CD
            , A.MDL_NM                      AS ITEM_ID
            , '-'                           AS NICK_NAME
            , CONVERT(NVARCHAR(30), NULL)   AS SPEED_UNIT_GROUP
            , UPPER(A.EQP_SPED_UNIT_CD)     AS EQP_SPED_UNIT_CD
            , A.EQP_NBU
            , A.EQP_SPED

    INTO	#tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_RESULT
    FROM    SCM_DNM_ELTR_EQP_SPED_MMLY A WITH(NOLOCK)
	WHERE	1<>1

    INSERT INTO #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_RESULT
    SELECT    A.DIVISION_ID                 AS DIVISION_ID
            , A.COMPANY_ID                  AS COMPANY_ID
            , A.SITE_ID                     AS SITE_ID
            , A.PLANT_ID                    AS PLANT_ID
            , A.FACTORY_ID                  AS FACTORY_ID
            , A.LINE_ID                     AS LINE_ID
            , A.OPERATION_ID                AS OPERATION_ID
            , A.ELTR_LN_TP_CD               AS ELTR_LN_TP_CD
            , A.MDL_NM                      AS ITEM_ID
            , '-'                           AS NICK_NAME
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
        AND A.PERD_DIVS_CD		= '3'
        AND A.PFRSLT_YM			= @v_result_to_yyyymm
    GROUP BY  A.DIVISION_ID
            , A.COMPANY_ID
            , A.SITE_ID
            , A.PLANT_ID
            , A.FACTORY_ID
            , A.LINE_ID
            , A.OPERATION_ID
            , A.ELTR_LN_TP_CD
            , A.MDL_NM
            , B.UNIT_GROUP
            , A.EQP_SPED_UNIT_CD;
    --PRINT N'GET - RESULT - END';

--TESTING : NOK
--select * from #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_RESULT;return;


    --PRINT N'GET - BASE - BEGIN';
    BEGIN --BASE 테이블을 SCP_MST_MDL_EQP_SPED => EQUIPMENT 로 대체-------------------------------------------------------------------------------------------------

		IF OBJECT_ID('tempdb..#tblSCP0104_EQPUIPMENT_TEMP') IS NOT NULL
			DROP TABLE #tblSCP0104_EQPUIPMENT_TEMP;

			--빈테이블 생성
			SELECT	  A.COMPANY_ID
					, A.DIVISION_ID
					, A.SITE_ID
					, A.PLANT_ID
					, A.FACTORY_ID
					, A.LINE_ID
					, A.OPERATION_ID
					, B.BOM_ITEM_ID
					, A.EQUIPMENT_ID
					, A.EQUIPMENT_NAME
					, A.WIDE_ROLL_ENABLE_FLAG
					, CONVERT(NVARCHAR(30), IIF(A.WIDE_ROLL_ENABLE_FLAG = 'Y', 'W', 'S'))      AS ELTR_LN_TP_CD
					, B.EQP_SPED
					, B.UPDATE_TIME				AS SPEED_UPDATE_TIME
					, A.UPDATE_TIME				AS EQPT_UPDATE_TIME
					, CONVERT(BIGINT, NULL)     AS RN
			INTO	#tblSCP0104_EQPUIPMENT_TEMP
			FROM	SCM_MST_EQUIPMENT_SN A WITH(NOLOCK)
					INNER JOIN SCM_MMD_EQPT_PRDT_SPEED_SN B WITH(NOLOCK) ON 
							B.EQP_ID = A.EQUIPMENT_ID
			WHERE	1<>1

			INSERT INTO #tblSCP0104_EQPUIPMENT_TEMP
			SELECT	  A.COMPANY_ID
					, A.DIVISION_ID
					, A.SITE_ID
					, A.PLANT_ID
					, A.FACTORY_ID
					, A.LINE_ID
					, A.OPERATION_ID
					, B.BOM_ITEM_ID
					, A.EQUIPMENT_ID
					, A.EQUIPMENT_NAME
					, A.WIDE_ROLL_ENABLE_FLAG
					, CONVERT(NVARCHAR(30), IIF(A.WIDE_ROLL_ENABLE_FLAG = 'Y', 'W', 'S'))      AS ELTR_LN_TP_CD
					, B.EQP_SPED
					, B.UPDATE_TIME				AS SPEED_UPDATE_TIME
					, A.UPDATE_TIME				AS EQPT_UPDATE_TIME
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

--TESTING : NOK
--select * from #tblSCP0104_EQPUIPMENT_TEMP;


		IF OBJECT_ID('tempdb..#tblSCP0104_EQPUIPMENT') IS NOT NULL
			DROP TABLE #tblSCP0104_EQPUIPMENT;

		SELECT    A.COMPANY_ID
				, A.DIVISION_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.EQUIPMENT_ID
				, A.EQUIPMENT_NAME
				, A.ELTR_LN_TP_CD
                , A.BOM_ITEM_ID                     AS ITEM_ID
                , CONVERT(FLOAT, NULL)    AS EQP_NBU
				, A.EQP_SPED
		INTO    #tblSCP0104_EQPUIPMENT
		FROM    #tblSCP0104_EQPUIPMENT_TEMP A
		WHERE   1<>1;

		INSERT INTO #tblSCP0104_EQPUIPMENT
		SELECT    A.COMPANY_ID
				, A.DIVISION_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.EQUIPMENT_ID
				, A.EQUIPMENT_NAME
				, A.ELTR_LN_TP_CD
                , A.BOM_ITEM_ID                     AS ITEM_ID
                , CONVERT(FLOAT, NULL)    AS EQP_NBU
				, AVG(A.EQP_SPED)
		FROM    #tblSCP0104_EQPUIPMENT_TEMP A
		WHERE   1=1
			AND A.RN = 1
		GROUP BY  A.COMPANY_ID
				, A.DIVISION_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.EQUIPMENT_ID
				, A.EQUIPMENT_NAME
				, A.ELTR_LN_TP_CD
                , A.BOM_ITEM_ID

	--TESTING : NOK
	--select * from #tblSCP0104_EQPUIPMENT_TEMP;
	--select * from #tblSCP0104_EQPUIPMENT;return;


		IF OBJECT_ID('tempdb..#tblSCP0104_EQPUIPMENT_LINE') IS NOT NULL
			DROP TABLE #tblSCP0104_EQPUIPMENT_LINE;

		SELECT    A.COMPANY_ID
				, A.DIVISION_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
                , A.OPERATION_ID
				, A.EQUIPMENT_ID
				, A.EQUIPMENT_NAME
		INTO    #tblSCP0104_EQPUIPMENT_LINE
		FROM    #tblSCP0104_EQPUIPMENT A
		WHERE   1<>1;

		INSERT INTO #tblSCP0104_EQPUIPMENT_LINE
		SELECT    A.COMPANY_ID
				, A.DIVISION_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
                , A.OPERATION_ID
				, A.EQUIPMENT_ID
				, A.EQUIPMENT_NAME
		FROM    #tblSCP0104_EQPUIPMENT A
		WHERE   1=1
		GROUP BY  A.COMPANY_ID
				, A.DIVISION_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
                , A.OPERATION_ID
				, A.EQUIPMENT_ID
				, A.EQUIPMENT_NAME

--TESTING : NOK
--select * from #tblSCP0104_EQPUIPMEN;
--select * from #tblSCP0104_EQPUIPMENT_LINE;return;



	    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE') IS NOT NULL
		    DROP TABLE #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE;

	    --빈테이블 생성
        SELECT    A.DIVISION_ID                 AS DIVISION_ID
                , A.COMPANY_ID                  AS COMPANY_ID
                , A.SITE_ID                     AS SITE_ID
                , A.PLANT_ID                    AS PLANT_ID
                , A.FACTORY_ID                  AS FACTORY_ID
                , A.LINE_ID                     AS LINE_ID
                , A.OPERATION_ID                AS OPERATION_ID
                , A.ITEM_ID                     AS ITEM_ID
                , '-'                           AS NICK_NAME
                , A.ELTR_LN_TP_CD               AS ELTR_LN_TP_CD
                , CONVERT(NVARCHAR(30), NULL)	AS SPEED_UNIT_GROUP
                , 'EQP_SPED'                    AS MSR_TP_CD
                , A.EQP_SPED                    AS EQP_SPED
                , 'N'                           AS UI_UPD_YN
        INTO	#tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE
        FROM    #tblSCP0104_EQPUIPMENT A
	    WHERE	1<>1

    --select * from #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE;return;

        INSERT INTO #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE
        SELECT    A.DIVISION_ID                 AS DIVISION_ID
                , A.COMPANY_ID                  AS COMPANY_ID
                , A.SITE_ID                     AS SITE_ID
                , A.PLANT_ID                    AS PLANT_ID
                , A.FACTORY_ID                  AS FACTORY_ID
                , A.LINE_ID                     AS LINE_ID
                , A.OPERATION_ID                AS OPERATION_ID
                , A.ITEM_ID                     AS ITEM_ID
                , '-'                           AS NICK_NAME
                , A.ELTR_LN_TP_CD               AS ELTR_LN_TP_CD
                , 'EQP_SPED'                    AS SPEED_UNIT_GROUP
                , 'EQP_SPED'                    AS MSR_TP_CD
                , A.EQP_SPED                    AS EQP_SPED
			    , 'N'                           AS UI_UPD_YN
        FROM    #tblSCP0104_EQPUIPMENT A WITH(NOLOCK)
        WHERE   1=1
		    AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		    AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		    AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		    AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		    AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		    AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		    AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD  IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		    --AND ((@p_item_id	    IS NULL OR @p_item_id   		= '') OR (A.ITEM_ID LIKE '%' + @p_item_id + '%') OR (A.NICK_NAME LIKE '%' + @p_item_id + '%'))
		    AND ((@p_item_id	    IS NULL OR @p_item_id	        = '') OR A.ITEM_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_item_id, ',')))
    END   --BASE 테이블을 SCP_MST_MDL_EQP_SPED => EQUIPMENT 로 대체-------------------------------------------------------------------------------------------------

--TESTING : NOK
--select * from SCP_MST_MDL_EQP_SPED where MDL_NM = 'TEST DUMMY!!';
--select * from #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_RESULT;--return;
--select * from #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE;return;


    IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE_UI_UPD_YN') IS NOT NULL
		DROP TABLE #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE_UI_UPD_YN;

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
    INTO	#tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE_UI_UPD_YN
    FROM    #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE A
	WHERE	1<>1

    INSERT INTO #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE_UI_UPD_YN
    SELECT    DIVISION_ID
            , COMPANY_ID
            , SITE_ID
            , PLANT_ID
            , FACTORY_ID
            , LINE_ID
            , OPERATION_ID
            , ELTR_LN_TP_CD
            , ITEM_ID
            , '-'                           AS NICK_NAME
            , MAX(UI_UPD_YN)    AS UI_UPD_YN
    FROM    #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE
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


--TESTING : NOK
--select * from #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE_UI_UPD_YN;return;
    --PRINT N'GET - BASE - END';


	IF OBJECT_ID('tempdb..#tblSCP0105_SCP_MST_CAPA_ELTR_LINE_ASSIGN') IS NOT NULL
		DROP TABLE #tblSCP0105_SCP_MST_CAPA_ELTR_LINE_ASSIGN;

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
    INTO	#tblSCP0105_SCP_MST_CAPA_ELTR_LINE_ASSIGN
    FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF A WITH(NOLOCK)
	WHERE	1<>1

    INSERT INTO #tblSCP0105_SCP_MST_CAPA_ELTR_LINE_ASSIGN
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
    FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN_CUTF A WITH(NOLOCK)
    WHERE   1=1
        AND VALID_YN = 'Y'

--TESTING : NOK
--select * from #tblSCP0105_SCP_MST_CAPA_ELTR_LINE_ASSIGN;


	IF OBJECT_ID('tempdb..#tblSCP0105_RAW_ALL_TEMP') IS NOT NULL
		DROP TABLE #tblSCP0105_RAW_ALL_TEMP;

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
            , A.MSR_TP_CD
			, A.YYYYMM
            , A.BASE_QTY                                AS PFRSLT_QTY
            , A.BASE_QTY
            , A.QTY
    INTO    #tblSCP0105_RAW_ALL_TEMP
	FROM	SCP_MST_CAPA_ELTR_SPEED_PLAN_CUTF A WITH(NOLOCK)
	WHERE	1<>1

    INSERT INTO #tblSCP0105_RAW_ALL_TEMP
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
            , A.MSR_TP_CD
			, A.YYYYMM
            , A.BASE_QTY                                AS PFRSLT_QTY
            , A.BASE_QTY
            , A.QTY
	FROM	SCP_MST_CAPA_ELTR_SPEED_PLAN_CUTF A WITH(NOLOCK)
            JOIN #tblSCP0105_SCP_MST_CAPA_ELTR_LINE_ASSIGN B ON
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
                    AND A.YYYYMM            = B.YYYYMM
	WHERE	1=1
		AND A.OPERATION_ID <> 'AFFFF'
        AND ISNULL(B.ASSIGN_PRIORITY, 0) <> 0
		AND	A.VER_ID				= @p_version
		AND	A.VER_SEQ				= @p_version_seq
		AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD  IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		--AND ((@p_item_id	    IS NULL OR @p_item_id   		= '') OR (A.ITEM_ID LIKE '%' + @p_item_id + '%') OR (A.NICK_NAME LIKE '%' + @p_item_id + '%'))
		AND (((@p_item_id	    IS NULL OR @p_item_id	        = '') OR A.ITEM_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_item_id, ','))))

--TESTING : NOK
--select * from #tblSCP0105_RAW_ALL_TEMP;return;


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
            , CONVERT(NVARCHAR(50), NULL)               AS SPEED_UNIT_GROUP
            , A.MSR_TP_CD
			, A.YYYYMM
            , A.BASE_QTY                                AS PFRSLT_QTY
            , A.BASE_QTY
            , A.QTY
    INTO    #tblSCP0105_RAW_ALL
	FROM	#tblSCP0105_RAW_ALL_TEMP A WITH(NOLOCK)
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
            , A.BASE_QTY                                AS PFRSLT_QTY
            , A.BASE_QTY
            , A.QTY
	FROM	#tblSCP0105_RAW_ALL_TEMP A WITH(NOLOCK)
            JOIN #tblSCP0105_SPEED_UNIT_GROUP G ON
                    1=1

--TESTING : NOK
--select * from SCP_MST_CAPA_ELTR_SPEED_PLAN;
--select * from #tblSCP0105_RAW_ALL;return;
--select * from #tblSCP0105_SPEED_UNIT_GROUP;return;

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
        INTO    #tblSCP0105_RAW_KEYS
	    FROM	#tblSCP0105_RAW_ALL A
        WHERE   1<>1

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

--TESTING : NOK
--select * from #tblSCP0105_RAW_KEYS;return; --WHERE YYYYMM = '202404';
--select * from #tblSCP0105_RAW_KEYS WHERE NICK_NAME = 'TEST DUMMY!!' and YYYYMM = '202403';
--select * from #tblSCP0105_RAW_KEYS WHERE NICK_NAME = 'E129A' and YYYYMM = '202403' AND ELTR_LN_TP_CD = 'Anode';


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
    INTO    #tblSCP0105_RAW_TEMP
	FROM	#tblSCP0105_RAW_ALL A WITH(NOLOCK)
    WHERE   1<>1

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
            , R.EQP_SPED                                            AS PFRSLT_QTY
            , IIF(X.BASE_QTY IS NULL, B.EQP_SPED, X.BASE_QTY)       AS BASE_QTY
            , X.QTY                                                 AS QTY
			, ISNULL(BU.UI_UPD_YN, 'Y')                 AS UI_UPD_YN
	FROM	#tblSCP0105_RAW_KEYS A WITH(NOLOCK)
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
			LEFT JOIN #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_RESULT R ON
					A.DIVISION_ID		                            = R.DIVISION_ID
				AND A.COMPANY_ID		                            = R.COMPANY_ID
				AND A.SITE_ID			                            = R.SITE_ID
				AND A.PLANT_ID			                            = R.PLANT_ID
				AND A.FACTORY_ID		                            = R.FACTORY_ID
				AND A.LINE_ID			                            = R.LINE_ID
				AND A.OPERATION_ID		                            = R.OPERATION_ID
				AND A.ELTR_LN_TP_CD	                                = R.ELTR_LN_TP_CD
			LEFT JOIN #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE B ON
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
			LEFT JOIN #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE_UI_UPD_YN BU ON
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
--TESTING : NOK
--select * from #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE_UI_UPD_YN WHERE NICK_NAME = 'E129A' AND ELTR_LN_TP_CD = 'Anode';
--select * from #tblSCP0105_RAW_TEMP WHERE NICK_NAME = 'E129A' and YYYYMM = '202403' AND ELTR_LN_TP_CD = 'Anode';
--select * from #tblSCP0105_RAW_TEMP WHERE YYYYMM = '202404' AND ELTR_LN_TP_CD = 'Anode';return;



    	IF OBJECT_ID('tempdb..#tblSCP0105_RAW_TEMP2') IS NOT NULL
			DROP TABLE #tblSCP0105_RAW_TEMP2;
        
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
        INTO    #tblSCP0105_RAW_TEMP2
        FROM    #tblSCP0105_RAW_TEMP A
    WHERE   1<>1;

	INSERT INTO #tblSCP0105_RAW_TEMP2
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
			, AVG(ISNULL(A.PFRSLT_QTY, 0.0)) AS PFRSLT_QTY
			, AVG(ISNULL(A.BASE_QTY, 0.0))   AS BASE_QTY
			, AVG(ISNULL(A.QTY, 0.0))        AS QTY
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

--TESTING : NOK
--select * from #tblSCP0105_RAW_TEMP1 WHERE NICK_NAME = 'TEST DUMMY!!' AND YYYYMM = '202403';
--select * from #tblSCP0105_RAW_TEMP2 WHERE NICK_NAME = 'TEST DUMMY!!' AND YYYYMM = '202403';
--select * from #tblSCP0105_RAW_TEMP2 WHERE NICK_NAME = 'TEST DUMMY!!' and YYYYMM = '202403';
--select * from #tblSCP0105_RAW_TEMP2 WHERE NICK_NAME = 'E129A' and YYYYMM = '202403' AND ELTR_LN_TP_CD = 'Anode';


    	IF OBJECT_ID('tempdb..#tblSCP0105_RAW') IS NOT NULL
			DROP TABLE #tblSCP0105_RAW;
        
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
                , A.PFRSLT_QTY
                , A.BASE_QTY
                , A.QTY
                , A.UI_UPD_YN
			    , CONVERT(NVARCHAR(2), @p_prog_stat) AS PROG_STAT
			    , CONVERT(NUMERIC(4), NULL)          AS ASSIGN_PRIORITY
        INTO    #tblSCP0105_RAW
        FROM    #tblSCP0105_RAW_TEMP2 A
        WHERE   1<>1

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
                , A.PFRSLT_QTY
                , A.BASE_QTY
                , A.QTY
                , A.UI_UPD_YN
			    , CONVERT(NVARCHAR(2), @p_prog_stat) AS PROG_STAT
                , ISNULL(C.ASSIGN_PRIORITY, 0)       AS ASSIGN_PRIORITY
        FROM    #tblSCP0105_RAW_TEMP2 A
				LEFT JOIN #tblSCP0105_SCP_MST_CAPA_ELTR_LINE_ASSIGN C ON
					    A.DIVISION_ID		= C.DIVISION_ID
					AND A.COMPANY_ID		= C.COMPANY_ID
					AND A.SITE_ID			= C.SITE_ID
					AND A.PLANT_ID			= C.PLANT_ID
					AND A.FACTORY_ID		= C.FACTORY_ID
					AND A.LINE_ID			= C.LINE_ID
					AND A.OPERATION_ID		= C.OPERATION_ID
					AND A.ELTR_LN_TP_CD	    = C.ELTR_LN_TP_CD
					AND A.ITEM_ID           = C.ITEM_ID
					AND A.NICK_NAME         = C.NICK_NAME
					AND A.YYYYMM            = C.YYYYMM
        WHERE   1=1
    END --****************************************************************************************************************************************************************************************************

--TESTING : NOK
--select * from #tblSCP0105_RAW;return;



	DECLARE @v_date_cols           NVARCHAR(MAX) = N'';
	DECLARE @v_final_cols          NVARCHAR(MAX) = N'';

	SELECT      @v_date_cols       = @v_date_cols + '
			  , ' +
				CASE
					WHEN CHARINDEX('M_', COLUMN_NAME) = 1   THEN 'CONVERT(FLOAT, CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 5, 6) THEN QTY END) AS ' + COLUMN_NAME
					WHEN CHARINDEX('Y_', COLUMN_NAME) = 1   THEN 'CONVERT(FLOAT, CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 3, 4) THEN QTY END) AS ' + COLUMN_NAME
				END
              , @v_final_cols      = @v_final_cols + '
			  , MAX(' + COLUMN_NAME + ') AS ' + COLUMN_NAME
	FROM    #tblSCP0105_DATE_COLS A
	ORDER BY SORT_ORDER_NO;

    --TESTING : OK
    --exec debug_log @v_final_cols, 'T';return;


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
                , A.UI_UPD_YN
                ' + @v_date_cols + N'
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
			    , K.NICK_NAME
                , A.SPEED_UNIT_GROUP
                , A.MSR_TP_CD
                , MAX(A.PFRSLT_QTY)       AS PFRSLT_QTY
                , MAX(A.BASE_QTY)         AS BASE_QTY
                , A.UI_UPD_YN
                ' + @v_final_cols + N'
        INTO    #tblSCP0105_FINAL1
		FROM    #tblSCP0105_FINAL A
                LEFT JOIN #tblSCP_NICKNAME_ELTR K ON
					    A.DIVISION_ID		= K.DIVISION_ID
				    AND A.ITEM_ID			= K.ITEM_ID
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
			    , K.NICK_NAME
                , A.SPEED_UNIT_GROUP
                , A.MSR_TP_CD
                , A.UI_UPD_YN;

        --TESTING : NOK
        --select * from #tblSCP0105_FINAL1 WHERE NICK_NAME = ''TEST DUMMY!!'';--return;
        --select * from #tblSCP0105_FINAL1 WHERE NICK_NAME = ''E129A'' AND ELTR_LN_TP_CD = ''Anode'';--return;

        
        SELECT    A.*
			    , M.MEASURE_NAME
                , M.SORT_ORDER_NO
                , G.UNIT_GROUP_SEQ													AS SPEED_UNIT_GROUP_SEQ
			    , CASE
				    WHEN (I.CODE IS NOT NULL) THEN ''Y''
				    ELSE ''N''
			      END																AS NICK_NAME_DUMMY_YN -- NICK_NAME 더미 여부는 Speed Plan 입력항목(Meaasrue) 을 결정하므로 따로 저장해둔다
			    , dbo.FN_GET_DIVISION_NAME (A.DIVISION_ID)							AS DIVISION_NAME
			    , S.SITE_NAME								                        AS SITE_NAME
			    , P.PLANT_NAME								                        AS PLANT_NAME
			    , F.FACTORY_NAME						                            AS FACTORY_NAME
			    , L.LINE_NAME								                        AS LINE_NAME
			    , O.OPERATION_NAME
                , Z.EQUIPMENT_ID
                , ISNULL(Z.EQUIPMENT_NAME, ''-'')                                   AS EQUIPMENT_NAME
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
                LEFT JOIN #tblSCP0105_DUMMY_CODE_ITEM_ID I WITH(NOLOCK) ON
                        A.ITEM_ID          = I.NAME
                LEFT JOIN #tblSCP0105_MEASURE M ON
                        A.MSR_TP_CD    = M.MEASURE
                LEFT JOIN #tblSCP0105_SPEED_UNIT_ALL G ON
                        A.SPEED_UNIT_GROUP = G.UNIT_GROUP
                    AND A.MSR_TP_CD = G.MSR_TP_CD
                LEFT JOIN #tblSCP0104_EQPUIPMENT_LINE Z ON
				        A.DIVISION_ID		= Z.DIVISION_ID
				    AND A.COMPANY_ID		= Z.COMPANY_ID
				    AND A.SITE_ID			= Z.SITE_ID
				    AND A.PLANT_ID			= Z.PLANT_ID
				    AND A.FACTORY_ID		= Z.FACTORY_ID
				    AND A.LINE_ID			= Z.LINE_ID
				    AND A.OPERATION_ID		= Z.OPERATION_ID
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
                , M.SORT_ORDER_NO';

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
    FROM    SCP_MST_CAPA_ELTR_SPEED_PLAN_CUTF WITH(NOLOCK)
    WHERE   1<>1;


	IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE') IS NOT NULL
		DROP TABLE #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE;
	IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE_UI_UPD_YN') IS NOT NULL
		DROP TABLE #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE_UI_UPD_YN;
	IF OBJECT_ID('tempdb..#tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_RESULT') IS NOT NULL
		DROP TABLE #tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_RESULT;
	IF OBJECT_ID('tempdb..#tblSCP0105_DATE_COLS') IS NOT NULL
		DROP TABLE #tblSCP0105_DATE_COLS;
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
	IF OBJECT_ID('tempdb..#tblSCP0105_SITE') IS NOT NULL
		DROP TABLE #tblSCP0105_SITE;
	IF OBJECT_ID('tempdb..#tblSCP0105_SPEED_UNIT_ALL') IS NOT NULL
		DROP TABLE #tblSCP0105_SPEED_UNIT_ALL;
	IF OBJECT_ID('tempdb..#tblSCP0105_SPEED_UNIT_GROUP') IS NOT NULL
		DROP TABLE #tblSCP0105_SPEED_UNIT_GROUP;
	IF OBJECT_ID('tempdb..#tblSCP0105_SCP_MST_CAPA_ELTR_LINE_ASSIGN') IS NOT NULL
		DROP TABLE #tblSCP0105_SCP_MST_CAPA_ELTR_LINE_ASSIGN;
	IF OBJECT_ID('tempdb..#tblSCP0104_OPERATION') IS NOT NULL
		DROP TABLE #tblSCP0104_OPERATION;
END

