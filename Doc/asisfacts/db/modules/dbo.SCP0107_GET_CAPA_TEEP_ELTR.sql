

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0107_GET_CAPA_TEEP_ELTR
 * Description  :
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/19   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/02/19   chaan        V1.1.2                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 집게로직 수정
 * 2024/07/11   chaan        V1.1.3                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 3차 Update
 * 2024/07/12   chaan        V1.1.4                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 로직 검증
 *                                                                                                           - FACTROY_NAME 시노님 참조로 변경
 * 2024/09/25   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 소스 버전 싱크
 * 2024/09/25   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - SOP 적용
 * 2024.11.01	chaan        V1.1.9                PJ20239037 LGES CPS VOE 반영 및 고도화                     - DIVISION 합산로직 수정
 *                                                                                                           - Total - Final Production Plan - Result, Base 0 처리
 * 2024.12.12	chaan        V1.1.10               PJ20239037 LGES CPS VOE 반영 및 고도화                     - 날짜 컬럼 함수 오류 수정 적용
 */


--CREATE PROCEDURE [dbo].[SCP0107_GET_CAPA_TEEP_ELTR]
CREATE PROCEDURE [dbo].[SCP0107_GET_CAPA_TEEP_ELTR]
	  @p_version			NVARCHAR(10)
	, @p_version_seq		TINYINT
	, @p_division_id		NVARCHAR(MAX)
	, @p_site_id			NVARCHAR(MAX)
	, @p_plant_id  			NVARCHAR(MAX)
	, @p_factory_id			NVARCHAR(MAX)
	, @p_line_id			NVARCHAR(MAX)
	, @p_operation_id		NVARCHAR(MAX)
    , @p_electrode_type		NVARCHAR(MAX)
	, @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
	, @p_user_id			NVARCHAR(30)
	, @debug_mode			NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

 --   DECLARE @p_version			NVARCHAR(10)		= N'202412';
	--DECLARE @p_version_seq		TINYINT             = 1;
	--DECLARE @p_division_id		NVARCHAR(MAX)		= N'81';
	--DECLARE @p_site_id			NVARCHAR(MAX)		= N'';
	--DECLARE @p_plant_id  		NVARCHAR(MAX)		= N'';
	--DECLARE @p_factory_id		NVARCHAR(MAX)		= N'';
	--DECLARE @p_line_id			NVARCHAR(MAX)		= N'';
	--DECLARE @p_operation_id		NVARCHAR(MAX)		= N'';
	--DECLARE @p_electrode_type	NVARCHAR(MAX)		= N'';
	--DECLARE @p_program_id		NVARCHAR(100)		= N'SCP0107';
	--DECLARE @p_sheet_name		NVARCHAR(100)		= N'ELTR';
 --   DECLARE @p_user_id			NVARCHAR(30)		= N'iamarock';
 --   DECLARE @debug_mode			NVARCHAR(1)			= N'F';


 	DECLARE @V_ELAPSED_TIME_BEG     DATETIME                = CURRENT_TIMESTAMP;

    DECLARE     @v_from_yyyymm          NVARCHAR(6)     = CONVERT(NVARCHAR(6), DATEADD(MM, 1, CONVERT(DATETIME, @p_version + '01')), 112);

	IF OBJECT_ID('tempdb..#tblSCP0107_DATE_COLS') IS NOT NULL
		DROP TABLE #tblSCP0107_DATE_COLS;

    --빈테이블 생성
    SELECT	  COLUMN_NAME
			, COLUMN_LABEL_NAME
			, SMALL_CLASS_LABEL_NAME
			, LARGE_CLASS_LABEL_NAME
			, DAY_CODE
			, SORT_ORDER_NO
    INTO    #tblSCP0107_DATE_COLS
	FROM	dbo.FN_SCP0104_GET_SPREAD_TITLE(@v_from_yyyymm, @p_program_id, @p_sheet_name) A
    WHERE   1<>1;

    INSERT INTO	#tblSCP0107_DATE_COLS
    SELECT	  COLUMN_NAME
			, COLUMN_LABEL_NAME
			, SMALL_CLASS_LABEL_NAME
			, LARGE_CLASS_LABEL_NAME
			, DAY_CODE
			, SORT_ORDER_NO
	FROM	dbo.FN_SCP0104_GET_SPREAD_TITLE(@v_from_yyyymm, @p_program_id, @p_sheet_name) A;

--TESTING : NOK
--select * FROM	#tblSCP0107_DATE_COLS;return;

	IF OBJECT_ID('tempdb..#tblSCP0107_PLAN_TP') IS NOT NULL
		DROP TABLE #tblSCP0107_PLAN_TP;

    --빈테이블 생성
    SELECT	LARGE_CLASS_LABEL_NAME  AS PLAN_TP
    INTO    #tblSCP0107_PLAN_TP
	FROM	#tblSCP0107_DATE_COLS
    WHERE   1<>1;

    INSERT INTO	#tblSCP0107_PLAN_TP
    SELECT	LARGE_CLASS_LABEL_NAME AS PLAN_TP
	FROM	#tblSCP0107_DATE_COLS
    GROUP BY LARGE_CLASS_LABEL_NAME

--TESTING : NOK
--select * FROM	#tblSCP0107_PLAN_TP;return;

	DECLARE @v_to_yyyy			NVARCHAR(4)			= '';

    SELECT  @v_to_yyyy  = MAX(SMALL_CLASS_LABEL_NAME)
    FROM    #tblSCP0107_DATE_COLS;

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


	    IF OBJECT_ID('tempdb..#tblSCP0107_EQP') IS NOT NULL
			DROP TABLE #tblSCP0107_EQP;

        SELECT    A.SEGMENT3        AS ELTR_TP_CD
                , A.SEGMENT4        AS ELTR_TP_NM_EN
                , A.SEGMENT5        AS ELTR_TP_NM_KO
                , A.DISPLAY_SEQ
        INTO    #tblSCP0107_EQP
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1=1
            AND A.LOOKUP_TYPE  = 'SCP_CAPA_ELTR_TP'
            AND A.VALID_YN  = 'Y';

--TESTING : NOK
--select * from #tblSCP0107_EQP;return;


	    IF OBJECT_ID('tempdb..#tblSCP0107_MEASURE_ALL') IS NOT NULL
			DROP TABLE #tblSCP0107_MEASURE_ALL;

        --빈테이블 생성
        SELECT    A.ATTRIBUTE3        AS LOSS_GR_CD
                , A.SEGMENT1          AS LOSS_CD
                , A.ATTRIBUTE6        AS LOSS_GR_NM_KO
                , A.ATTRIBUTE7        AS LOSS_GR_NM_EN
                , A.ATTRIBUTE4        AS LOSS_NM_KO
                , A.ATTRIBUTE5        AS LOSS_NM_EN
                , A.ATTRIBUTE8        AS TARGET_YN
                , A.DISPLAY_SEQ
        INTO    #tblSCP0107_MEASURE_ALL
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1<>1;

        INSERT INTO	#tblSCP0107_MEASURE_ALL
        SELECT    A.ATTRIBUTE3        AS LOSS_GR_CD
                , A.SEGMENT1          AS LOSS_CD
                , A.ATTRIBUTE6        AS LOSS_GR_NM_EN
                , A.ATTRIBUTE7        AS LOSS_GR_NM_EN
                , A.ATTRIBUTE4        AS LOSS_NM_KO
                , A.ATTRIBUTE5        AS LOSS_NM_EN
                --, CASE
                --    WHEN @p_sheet_name = 'CUTOFF_MODEL_ELTR'     THEN A.ATTRIBUTE8   --MODEL_TARGET_YN
                --    WHEN @p_sheet_name = '1ST_CUTOFF_LINE_ELTR'  THEN A.ATTRIBUTE14  --1ST_LINE_TARGET_YN
                --    WHEN @p_sheet_name = '2ND_CUTOFF_LINE_ELTR'  THEN A.ATTRIBUTE9   --2ND_LINE_TARGET_YN
                --    ELSE A.ATTRIBUTE13                                               --CURRENT_TARGET_YN
                --  END AS TARGET_YN
                , A.ATTRIBUTE9   --2ND_LINE_TARGET_YN
                , A.DISPLAY_SEQ
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1=1
            AND A.LOOKUP_TYPE  = 'SCP_CAPA_ELTR_LOSS_MEASURE'
            --AND A.VALID_YN  = 'Y';

--TESTING : NOK
--select * FROM	#tblSCP0107_MEASURE_ALL;return;


	    IF OBJECT_ID('tempdb..#tblSCP0107_MEASURE_VISIBLE') IS NOT NULL
			DROP TABLE #tblSCP0107_MEASURE_VISIBLE;

        SELECT    COLUMN_NAME AS MEASURE
                , SORT_ORDER_NO
        INTO    #tblSCP0107_MEASURE_VISIBLE
        FROM    SCM_MST_SHEET_MEASURE WITH(NOLOCK)
        WHERE   1=1
            AND PROGRAM_ID    = @p_program_id
            AND SHEET_NAME    = @p_sheet_name
            AND VALID_YN      = 'Y'

--TESTING : NOK
--select * from SCM_MST_SHEET_MEASURE;return;
--select * FROM	#tblSCP0107_MEASURE_VISIBLE ORDER BY SORT_ORDER_NO;return;


	    IF OBJECT_ID('tempdb..#tblSCP0107_MEASURE') IS NOT NULL
			DROP TABLE #tblSCP0107_MEASURE;

        --빈테이블 생성
        SELECT    A.LOSS_GR_CD
                , A.LOSS_CD
                , A.LOSS_GR_NM_KO
                , A.LOSS_GR_NM_EN
                , A.LOSS_NM_KO
                , A.LOSS_NM_EN
                , A.DISPLAY_SEQ
        INTO    #tblSCP0107_MEASURE
        FROM    #tblSCP0107_MEASURE_ALL A
        WHERE   1<>1;

--TESTING : NOK
--select * FROM	#tblSCP0107_MEASURE;return;

        INSERT INTO	#tblSCP0107_MEASURE
        SELECT    A.LOSS_GR_CD
                , A.LOSS_CD
                , A.LOSS_GR_NM_EN
                , A.LOSS_GR_NM_EN
                , A.LOSS_NM_KO
                , A.LOSS_NM_EN
                , B.SORT_ORDER_NO   AS DISPLAY_SEQ
        FROM    #tblSCP0107_MEASURE_ALL A
                JOIN #tblSCP0107_MEASURE_VISIBLE B ON
                        A.LOSS_CD = B.MEASURE
        WHERE   1=1
            --AND A.TARGET_YN = 'Y';

--TESTING : NOK
--select * FROM	#tblSCP0107_MEASURE;return;


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



	IF OBJECT_ID('tempdb..#tblSCP0107_BIZ_PLAN') IS NOT NULL
		DROP TABLE #tblSCP0107_BIZ_PLAN;

	DECLARE @v_biz_plan_version			NVARCHAR(10)		= N''
	DECLARE @v_biz_plan_version_seq		TINYINT             = 1;

    SELECT    @v_biz_plan_version       = MAX(A.VER_ID)
            , @v_biz_plan_version_seq   = MAX(A.VER_SEQ)
    FROM    SCP_MST_CAPA_VERSION A
	INNER JOIN (SELECT TOKEN AS DIVISION_ID FROM dbo.STRING_SPLIT(@p_division_id, ',')) DI ON A.DIVISION_ID = DI.DIVISION_ID
    WHERE   1=1
        AND A.VER_ID             < @p_version
        AND A.VER_SEQ            < @p_version_seq
        --AND A.DIVISION_ID        = @p_division_id
        AND A.BIZ_PLAN_USE_YN    = 'Y'
    GROUP BY  A.VER_ID
            , A.VER_SEQ

	DECLARE @v_pre_yyyymm               NVARCHAR(6)     = '';
	DECLARE @v_result_from_yyyymm       NVARCHAR(6)     = '';
	DECLARE @v_result_to_yyyymm         NVARCHAR(6)     = '';


    SET @v_pre_yyyymm           = LEFT(CONVERT(NVARCHAR, DATEADD(MONTH, -1, CONVERT(DATE, @p_version + '01')), 112), 6);
    SET @v_result_from_yyyymm   = CONVERT(CHAR(8), DATEADD(MM, -3, CONVERT(DATETIME, @p_version + '01')), 112);
    SET @v_result_to_yyyymm     = CONVERT(CHAR(8), DATEADD(MM, -1, CONVERT(DATETIME, @p_version + '01')), 112);


    PRINT CONCAT('@v_biz_plan_version : ', @v_biz_plan_version);
    PRINT CONCAT('@v_biz_plan_version_seq : ', @v_biz_plan_version_seq);
    PRINT CONCAT('@v_pre_yyyymm : ', @v_pre_yyyymm);
    PRINT CONCAT('@v_result_from_yyyymm : ', @v_result_from_yyyymm);
    PRINT CONCAT('@v_result_to_yyyymm : ', @v_result_to_yyyymm);


	IF OBJECT_ID('tempdb..#tblSCP0107_DAY_CNT') IS NOT NULL
		DROP TABLE #tblSCP0107_DAY_CNT;

    SELECT    CONVERT(FLOAT,
                CASE
                    WHEN @v_biz_plan_version IS NULL OR @v_biz_plan_version = '' THEN 0
                    ELSE CONVERT(FLOAT, DAY(EOMONTH(CONVERT(DATETIME, @v_biz_plan_version + '01'))))
                END)                                                                                                                                                    AS BIZ_DAY_CNT
            , CONVERT(FLOAT, DAY(EOMONTH(CONVERT(DATETIME, @v_pre_yyyymm + '01'))))                                                                           AS PRE_DAY_CNT
            , CONVERT(FLOAT, DATEDIFF(d, CONVERT(DATETIME, @v_result_from_yyyymm + '01'), EOMONTH(CONVERT(DATETIME, @v_result_to_yyyymm + '01'))) / 3.0)      AS PFRSLT_DAY_CNT
            , CONVERT(FLOAT, DATEDIFF(d, CONVERT(DATETIME, @v_result_from_yyyymm + '01'), EOMONTH(CONVERT(DATETIME, @v_result_to_yyyymm + '01'))) / 3.0)      AS BASE_DAY_CNT
    INTO    #tblSCP0107_DAY_CNT;

--TESTING : NOK
--select * FROM	#tblSCP0107_DAY_CNT;return;


	IF OBJECT_ID('tempdb..#tblSCP0107_RAW_TEMP_ALL') IS NOT NULL
		DROP TABLE #tblSCP0107_RAW_TEMP_ALL;

    --빈테이블 생성
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
            ------, A.ELTR_LN_TP_CD
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, CONVERT(FLOAT, A.MSR_NVL)         AS MSR_NVL
			, CONVERT(FLOAT, A.MSR_DDN)         AS MSR_DDN
		    --, ATTRIBUTE1		AS ATTRIBUTE1_
		    --, ATTRIBUTE2		AS ATTRIBUTE2_
		    --, ATTRIBUTE3		AS ATTRIBUTE3_
		    --, ATTRIBUTE4		AS ATTRIBUTE4_
		    --, ATTRIBUTE5		AS ATTRIBUTE5_
		    --, ATTRIBUTE6		AS ATTRIBUTE6_
		    --, ATTRIBUTE7		AS ATTRIBUTE7_

		    , CONVERT(FLOAT, ATTRIBUTE1)		AS ATTRIBUTE1
		    , CONVERT(FLOAT, ATTRIBUTE2)		AS ATTRIBUTE2
		    , CONVERT(FLOAT, ATTRIBUTE3)		AS ATTRIBUTE3
		    , CONVERT(FLOAT, ATTRIBUTE4)		AS ATTRIBUTE4
		    , CONVERT(FLOAT, ATTRIBUTE5)		AS ATTRIBUTE5
		    , CONVERT(FLOAT, ATTRIBUTE6)		AS ATTRIBUTE6
		    , CONVERT(FLOAT, ATTRIBUTE7)		AS ATTRIBUTE7
		    , CONVERT(FLOAT, ATTRIBUTE8)		AS ATTRIBUTE8
			, CONVERT(TINYINT, 0)				AS DIV
			, CONVERT(INTEGER, 0)				AS OP_ALTER_KEY
			, CONVERT(INTEGER, 0)				AS DV_ALTER_KEY
    INTO    #tblSCP0107_RAW_TEMP_ALL
    FROM	SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_CUTF A WITH(NOLOCK)
    WHERE   1<>1;

    INSERT INTO	#tblSCP0107_RAW_TEMP_ALL
    SELECT    A.VER_ID
            , A.VER_SEQ
            , A.DIVISION_ID
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
            ----, A.ELTR_LN_TP_CD
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.MSR_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
			, A.MSR_NVL
			, A.MSR_DDN
		    --, ATTRIBUTE1		AS ATTRIBUTE1_
		    --, ATTRIBUTE2		AS ATTRIBUTE2_
		    --, ATTRIBUTE3		AS ATTRIBUTE3_
		    --, ATTRIBUTE4		AS ATTRIBUTE4_
		    --, ATTRIBUTE5		AS ATTRIBUTE5_
		    --, ATTRIBUTE6		AS ATTRIBUTE6_
		    --, ATTRIBUTE7		AS ATTRIBUTE7_

		    , CONVERT(FLOAT, ATTRIBUTE1)		        AS ATTRIBUTE1
		    , CONVERT(FLOAT, ATTRIBUTE2)		        AS ATTRIBUTE2
		    , CONVERT(FLOAT, ATTRIBUTE3)		        AS ATTRIBUTE3
		    , CONVERT(FLOAT, ATTRIBUTE4)		        AS ATTRIBUTE4
		    , CONVERT(FLOAT, ATTRIBUTE5)		        AS ATTRIBUTE5
		    , CONVERT(FLOAT, ATTRIBUTE6)		        AS ATTRIBUTE6
		    , CONVERT(FLOAT, ATTRIBUTE7)		        AS ATTRIBUTE7
		    , CONVERT(FLOAT, ATTRIBUTE8)		        AS ATTRIBUTE8
			, CONVERT(TINYINT, 1)						AS DIV			--- 1 : RAW, 2 : TOTAL
			, DENSE_RANK()	OVER (PARTITION BY 'ALL' ORDER BY 	  A.VER_ID
                                                                , A.VER_SEQ
                                                                , A.DIVISION_ID)    AS OP_ALTER_KEY
			, DENSE_RANK()	OVER (PARTITION BY 'ALL' ORDER BY 	  A.VER_ID
                                                                , A.VER_SEQ)        AS DV_ALTER_KEY
    FROM	SCP_MST_CAPA_ELTR_LOSS_PLAN_LN_CUTF A WITH(NOLOCK)
    WHERE   1=1
            AND VER_ID  = @p_version
            AND VER_SEQ = @p_version_seq
		    AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		    AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		    AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		    AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		    AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		    AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		    AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))

--TESTING : NOK
--select * FROM	#tblSCP0107_RAW_TEMP_ALL where YYYYMM = '202408';return;


	BEGIN --설비 타입별 합계 추가
		IF OBJECT_ID('tempdb..#tblSCP0107_YYYYMM_DDN') IS NOT NULL
			DROP TABLE #tblSCP0107_YYYYMM_DDN;

		SELECT    A.OP_ALTER_KEY
				------, A.ELTR_LN_TP_CD -- 0927 HRK TEST 
				, A.YYYYMM
				, CONVERT(FLOAT,
				  CASE
                    WHEN SUM(A.ATTRIBUTE3) = 0 THEN 0
                    ELSE CONVERT(FLOAT, SUM(A.ATTRIBUTE2 * A.ATTRIBUTE3)) / CONVERT(FLOAT, SUM(A.ATTRIBUTE3))   --- 0927 hrk test  attribute8 -> attribute2 
                  END )          AS YYYYMM_DDN	-- 월/년 조업일수
	    INTO	#tblSCP0107_YYYYMM_DDN
		FROM	#tblSCP0107_RAW_TEMP_ALL A
		WHERE	1=1
			AND MSR_TP_CD = 'AV_RT'
		GROUP BY  A.OP_ALTER_KEY
				, A.YYYYMM
				------, A.eltr_ln_tp_cd -- 0927 hrk test 
		ORDER BY 1

--TESTING : NOK
--select * FROM	#tblSCP0107_RAW_TEMP_ALL where MSR_TP_CD = 'AV_RT';
--select * FROM	#tblSCP0107_YYYYMM_DDN where YYYYMM = '202408';return;


		IF OBJECT_ID('tempdb..#tblSCP0107_TOTAL_KEY') IS NOT NULL
			DROP TABLE #tblSCP0107_TOTAL_KEY;

		SELECT DISTINCT
                  OP_ALTER_KEY
				  , DIVISION_ID
                ------, ELTR_LN_TP_CD
		INTO	#tblSCP0107_TOTAL_KEY
		FROM	#tblSCP0107_RAW_TEMP_ALL WITH(NOLOCK)

--TESTING : NOK
--select * FROM #tblSCP0107_TOTAL_KEY;return;

		IF OBJECT_ID('tempdb..#tblSCP0107_OPERATION_TOTAL') IS NOT NULL
			DROP TABLE #tblSCP0107_OPERATION_TOTAL;

        --빈테이블 생성
		SELECT    OP_ALTER_KEY
			    ------, ELTR_LN_TP_CD
			    , MSR_GR_CD
			    , MSR_TP_CD
    			, YYYYMM
			    , CONVERT(FLOAT, NULL)          AS NUMERATOR
			    , CONVERT(FLOAT, NULL)          AS DENOMINATOR
			    , CONVERT(FLOAT, NULL)          AS MSR_NVL
			    , CONVERT(FLOAT, NULL)          AS MSR_DDN
		INTO	#tblSCP0107_OPERATION_TOTAL    --- SELECT * FROM	#tblSCP0107_OPERATION_TOTAL
		FROM	#tblSCP0107_RAW_TEMP_ALL WITH(NOLOCK)
        WHERE   1<>1


		BEGIN -- 비조업
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL
			SELECT    OP_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
				    , MSR_GR_CD
				    , MSR_TP_CD
				    , YYYYMM
				    , CONVERT(FLOAT, SUM(MSR_NVL * ATTRIBUTE3))				AS NUMERATOR   -- 0-0비조업_M_설비대수	-- SUM(비조업*설비대수) - NUMERATOR		분자
				    , CONVERT(FLOAT, SUM(ATTRIBUTE3))						AS DENOMINATOR -- 설비대수				-- SUM(설비대수)	    - DENOMINATOR	분모
				    , CASE WHEN SUM(ATTRIBUTE3) = 0
					   THEN 0
					   ELSE CONVERT(FLOAT, SUM(MSR_NVL * ATTRIBUTE3)) / CONVERT(FLOAT, SUM(ATTRIBUTE3))
				      END													AS MSR_NVL	  -- 비조업(일수)  공정합계_비조업		-- SUM(비조업*설비대수) / SUM(설비대수)
				    , CASE WHEN SUM(ATTRIBUTE3) = 0
					       THEN 0
					       ELSE CONVERT(FLOAT, SUM(MSR_NVL * ATTRIBUTE3)) / (SUM(ATTRIBUTE3))
				      END													AS MSR_DDN
			FROM	#tblSCP0107_RAW_TEMP_ALL WITH(NOLOCK)
			WHERE	1=1
				AND MSR_GR_CD = 'NAV'		--- 비조업
			GROUP BY  OP_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
					, MSR_GR_CD
					, MSR_TP_CD
					, YYYYMM
			ORDER BY 1,2,3,4,5,6

--TESTING : NOK
--select * from #tblSCP0107_RAW_TEMP_ALL where MSR_GR_CD = 'NAV' AND YYYYMM = '202408';
--select * from #tblSCP0107_OPERATION_TOTAL where MSR_GR_CD = 'NAV' AND YYYYMM = '202408';return;
		END -- 비조업


		BEGIN --조업율
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL
			SELECT	  OT.OP_ALTER_KEY
    			     ------, OT.ELTR_LN_TP_CD
 					 , '-'		                                                                                                                    AS MSR_GR_CD
					 , 'AV_RT'	                                                                                                                    AS MSR_TP_CD
					 , OT.YYYYMM
					 , CONVERT(FLOAT, YM.YYYYMM_DDN) - CONVERT(FLOAT, SUM(OT.MSR_NVL))						                                        AS NUMERATOR
					 , CONVERT(FLOAT, YM.YYYYMM_DDN)																                                AS DENOMINATOR
					 , CONVERT(FLOAT, (CONVERT(FLOAT, YM.YYYYMM_DDN) - CONVERT(FLOAT, SUM(OT.MSR_NVL)))  / CONVERT(FLOAT, YM.YYYYMM_DDN))	AS MSR_NVL	-- 조업률
					 , CONVERT(FLOAT, YM.YYYYMM_DDN) - CONVERT(FLOAT, SUM(OT.MSR_NVL))						                                        AS MSR_DDN	-- 조업일수
			 FROM	#tblSCP0107_OPERATION_TOTAL OT
				  INNER JOIN #tblSCP0107_YYYYMM_DDN YM
						  ON YM.YYYYMM  = OT.YYYYMM
						 AND YM.OP_ALTER_KEY = OT.OP_ALTER_KEY -- 0927 HRK TEST 
						 ------AND YM.ELTR_LN_TP_CD  = OT.ELTR_LN_TP_CD  -- 0927 HRK TEST 
			WHERE	1=1
				AND OT.MSR_GR_CD = 'NAV'
			GROUP BY  OT.OP_ALTER_KEY
    			    ------, OT.ELTR_LN_TP_CD
					, OT.YYYYMM
					, YM.YYYYMM_DDN

--return;

--TESTING : NOK
--select * from #tblSCP0107_RAW_TEMP_ALL where YYYYMM = '202408' AND MSR_TP_CD = 'AV_RT';
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408' AND MSR_TP_CD = 'AV_RT';return;
		END --조업율


		BEGIN -- 비부하
			INSERT INTO #tblSCP0107_OPERATION_TOTAL
			SELECT	  A.OP_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
					, A.MSR_GR_CD
					, A.MSR_TP_CD
					, A.YYYYMM
					, A.NUMERATOR
					, A.DENOMINATOR
					, CONVERT(FLOAT, IIF(A.DENOMINATOR = 0, 0, A.NUMERATOR / A.DENOMINATOR)) AS MSR_NVL		--- 비부하
					, A.MSR_DDN
			FROM    (
						SELECT	  A.OP_ALTER_KEY
                			    ------, ELTR_LN_TP_CD
								, A.MSR_GR_CD
								, A.MSR_TP_CD
								, A.YYYYMM
								, CONVERT(FLOAT, SUM(A.MSR_DDN))        AS NUMERATOR
								, CONVERT(FLOAT, SUM(A.ATTRIBUTE1))     AS DENOMINATOR
								, NULL		AS MSR_DDN
                        FROM	#tblSCP0107_RAW_TEMP_ALL A
						WHERE	1=1
							AND MSR_GR_CD = 'NLD'		--- 비부하
						GROUP BY  OP_ALTER_KEY
    			                ------, ELTR_LN_TP_CD
								, MSR_GR_CD
								, MSR_TP_CD
								, YYYYMM
					) A

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408';return;
		END -- 비부하


		BEGIN -- 부하율
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL
			SELECT	  OT.OP_ALTER_KEY
    			    ------, OT.ELTR_LN_TP_CD
					, '-'		AS MSR_GR_CD
					, 'LD_RT'	AS MSR_TP_CD
					, OT.YYYYMM
					, AV.MSR_DDN																			AS NUMERATOR  -- 조업일수
					, NULL																					AS DENOMINATOR
					, (CONVERT(FLOAT, 1) - CONVERT(FLOAT, SUM(OT.MSR_NVL))) 				                AS MSR_NVL	-- 부하율
					, (CONVERT(FLOAT, 1) - CONVERT(FLOAT, SUM(OT.MSR_NVL))) * CONVERT(FLOAT, AV.MSR_DDN)	AS MSR_DDN	-- 부하일수
			 FROM	#tblSCP0107_OPERATION_TOTAL OT
					INNER JOIN #tblSCP0107_OPERATION_TOTAL AV ON
							AV.OP_ALTER_KEY   = OT.OP_ALTER_KEY
						------AND AV.ELTR_LN_TP_CD  = OT.ELTR_LN_TP_CD
						AND AV.MSR_TP_CD	  = 'AV_RT' -- 조업률/조업일수
						AND AV.YYYYMM	      = OT.YYYYMM
			WHERE	1=1
				AND OT.MSR_GR_CD = 'NLD' -- 비부하
			GROUP BY  OT.OP_ALTER_KEY
    			    ------, OT.ELTR_LN_TP_CD
					, OT.YYYYMM
					, AV.MSR_DDN

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408' AND MSR_TP_CD = 'LD_RT';RETURN
		END -- 부하율


		BEGIN -- 비가동
			INSERT INTO #tblSCP0107_OPERATION_TOTAL
			SELECT	  A.OP_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
					, A.MSR_GR_CD
					, A.MSR_TP_CD
					, A.YYYYMM
					, A.NUMERATOR	-- 분자
					, A.DENOMINATOR	-- 분모
					, CONVERT(FLOAT,
                        CASE
							WHEN A.DENOMINATOR = 0 THEN CONVERT(FLOAT, 0)
							ELSE A.NUMERATOR / A.DENOMINATOR
						END
					  ) AS MSR_NVL		-- 비가동
				    , NULL AS MSR_DDN
			 FROM	(
						SELECT	  OP_ALTER_KEY
                			    ------, ELTR_LN_TP_CD
								, MSR_GR_CD
								, MSR_TP_CD
								, YYYYMM
								, CONVERT(FLOAT, SUM(A.MSR_DDN))        AS NUMERATOR
								, CONVERT(FLOAT, SUM(A.ATTRIBUTE1))     AS DENOMINATOR
						FROM	#tblSCP0107_RAW_TEMP_ALL A
						WHERE	1=1
							AND MSR_GR_CD = 'NOP'		--- 비가동
                        GROUP BY  OP_ALTER_KEY
                			    ------, ELTR_LN_TP_CD
								, MSR_GR_CD
								, MSR_TP_CD
								, YYYYMM
					) A

--TESTING : NOK
--select * from #tblSCP0107_RAW_TEMP_ALL where YYYYMM = '202408' AND MSR_TP_CD = 'BM_RT';
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408' AND MSR_TP_CD = 'BM_RT';return;
		END -- 비가동


		BEGIN -- 시간가동률(OP_RT)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL
			SELECT	  OT.OP_ALTER_KEY
    			    ------, OT.ELTR_LN_TP_CD
					, '-'																							AS MSR_GR_CD
					, 'OP_RT'																						AS MSR_TP_CD
					, OT.YYYYMM
					, LD.MSR_DDN																					AS NUMERATOR	-- 부하일수
					, NULL																							AS DENOMINATOR
					, CONVERT(FLOAT, (CONVERT(FLOAT, 1) - CONVERT(FLOAT, SUM(OT.MSR_NVL)))) 				AS MSR_NVL	-- 시간가동률
					, CONVERT(FLOAT, (CONVERT(FLOAT, 1) - CONVERT(FLOAT, SUM(OT.MSR_NVL))) * LD.MSR_DDN)	AS MSR_DDN	-- 시간가동일수
				 --- SELECT *
			 FROM	#tblSCP0107_OPERATION_TOTAL OT
					INNER JOIN #tblSCP0107_OPERATION_TOTAL LD ON
							LD.OP_ALTER_KEY   = OT.OP_ALTER_KEY
						------AND LD.ELTR_LN_TP_CD  = OT.ELTR_LN_TP_CD
						AND LD.MSR_TP_CD	  = 'LD_RT' -- 부하율/부하일수
						AND LD.YYYYMM	      = OT.YYYYMM
			WHERE	1=1
				AND OT.MSR_GR_CD = 'NOP' -- 비가동
			GROUP BY  OT.OP_ALTER_KEY
    			    ------, OT.ELTR_LN_TP_CD
					, OT.YYYYMM
					, LD.MSR_DDN

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408' AND MSR_TP_CD = 'OP_RT';return;
		END -- 시간가동률(OP_RT)


		BEGIN -- 성능가동률(PF_RT)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL
			SELECT	  A.OP_ALTER_KEY
    			    ------, A.ELTR_LN_TP_CD
					, A.MSR_GR_CD
					, A.MSR_TP_CD
					, A.YYYYMM
					, A.NUMERATOR
					, A.DENOMINATOR
					, CONVERT(FLOAT,
						CASE
							WHEN A.DENOMINATOR = 0 THEN CONVERT(FLOAT, 0)
							ELSE A.NUMERATOR / A.DENOMINATOR
						END
					  )										    AS PF_RT	-- 성능가동률
				    , CONVERT(FLOAT, A.NUMERATOR)     AS PF_DDN	-- 성능가동률 * 시간가동일수 = 성능가동일수
			 FROM	(
						SELECT	  OP_ALTER_KEY
    			                ------, ELTR_LN_TP_CD
								, MSR_GR_CD
								, MSR_TP_CD
								, YYYYMM
								, CONVERT(FLOAT, SUM(A.MSR_DDN))        AS NUMERATOR
								, CONVERT(FLOAT, SUM(A.ATTRIBUTE1))     AS DENOMINATOR
						FROM	#tblSCP0107_RAW_TEMP_ALL A
						WHERE	1=1
							AND MSR_TP_CD = 'PF_RT'		--- 성능가동률
                        GROUP BY  OP_ALTER_KEY
                			    ------, ELTR_LN_TP_CD
								, MSR_GR_CD
								, MSR_TP_CD
								, YYYYMM
					) A
					INNER JOIN #tblSCP0107_OPERATION_TOTAL OP ON
							OP.OP_ALTER_KEY   = A.OP_ALTER_KEY
						------AND OP.ELTR_LN_TP_CD  = A.ELTR_LN_TP_CD
						AND OP.MSR_TP_CD	  = 'OP_RT' -- 시간가동률/시간가동일수
						AND OP.YYYYMM	      = A.YYYYMM

--TESTING : NOK
--select * from #tblSCP0107_RAW_TEMP_ALL where MSR_TP_CD = 'PF_RT';
--select * from #tblSCP0107_OPERATION_TOTAL where MSR_TP_CD = 'PF_RT' AND YYYYMM = '202408';return;
		END -- 성능가동률(PF_RT)


		BEGIN -- 양품가동률(QL_RT)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL
			SELECT	  A.OP_ALTER_KEY
    			    ------, A.ELTR_LN_TP_CD
					, A.MSR_GR_CD
					, A.MSR_TP_CD
					, A.YYYYMM
					, A.NUMERATOR
					, A.DENOMINATOR
					, CONVERT(FLOAT,
                        CASE
							WHEN A.DENOMINATOR = 0 THEN CONVERT(FLOAT, 0)
							ELSE A.NUMERATOR / A.DENOMINATOR
						END
					  ) AS MSR_NVL              -- 양품가동률
                    , A.NUMERATOR  AS QL_DDN	-- 양품가동일수 
			 FROM	(
						SELECT	  OP_ALTER_KEY
                			    ------, ELTR_LN_TP_CD
								, MSR_GR_CD
								, MSR_TP_CD
								, YYYYMM
								, CONVERT(FLOAT, SUM(A.MSR_DDN))        AS NUMERATOR
								, CONVERT(FLOAT, SUM(A.ATTRIBUTE1))     AS DENOMINATOR
						FROM	#tblSCP0107_RAW_TEMP_ALL A
						WHERE	1=1
						  AND MSR_TP_CD = 'QL_RT'		--- 양품가동률
			            GROUP BY  OP_ALTER_KEY
                			    ------, ELTR_LN_TP_CD
					            , MSR_GR_CD
					            , MSR_TP_CD
					            , YYYYMM
					) A

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = 'RSLT' AND MSR_TP_CD = 'QL_RT';return;
		END -- 양품가동률(QL_RT)


		BEGIN -- 생산가동률(PROD_OP_RT)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL
			SELECT    OP_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
					, '-'											                                                        AS MSR_GR_CD
					, 'PROD_OP_RT'									                                                        AS MSR_TP_CD
					, YYYYMM
					, CONVERT(FLOAT, NULL)											                                        AS NUMERATOR
					, CONVERT(FLOAT, NULL)							                                                        AS DENOMINATOR
					, CONVERT(FLOAT, 
						  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'LD_RT'	THEN CONVERT(FLOAT, MSR_NVL) ELSE NULL END))
						* CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'OP_RT'  THEN CONVERT(FLOAT, MSR_NVL) ELSE NULL END))
						* CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PF_RT'  THEN CONVERT(FLOAT, MSR_NVL) ELSE NULL END))
						* CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'QL_RT'  THEN CONVERT(FLOAT, MSR_NVL) ELSE NULL END))
					  )																										AS MSR_NVL
					, NULL																                                    AS MSR_DDN
				  -- SELECT *
			FROM	#tblSCP0107_OPERATION_TOTAL
			WHERE	1=1
				AND MSR_TP_CD IN ('LD_RT', 'OP_RT', 'PF_RT', 'QL_RT')
			GROUP BY OP_ALTER_KEY
    			   ------, ELTR_LN_TP_CD
				   , YYYYMM

--TESTING : NOK
----select * from #tblSCP0107_RAW_TEMP_ALL where YYYYMM = '202408' and MSR_TP_CD = 'PROD_OP_RT';return;
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = 'RSLT' and MSR_TP_CD = 'LD_RT';
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = 'RSLT' and MSR_TP_CD = 'OP_RT';
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = 'RSLT' and MSR_TP_CD = 'PF_RT';
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = 'RSLT' and MSR_TP_CD = 'QL_RT';
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = 'RSLT' and MSR_TP_CD = 'PROD_OP_RT';return;
		END -- 생산가동률(PROD_OP_RT)


		BEGIN -- TEEP
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL
			SELECT    OP_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
					, '-'																	AS MSR_GR_CD
					, 'TEEP'																AS MSR_TP_CD
					, YYYYMM
					, NULL																	AS NUMERATOR
					, NULL																	AS DENOMINATOR
                    , CONVERT(NUMERIC(20,10),
                          CONVERT(FLOAT, CONVERT(NUMERIC(20,10), MAX(CASE WHEN MSR_TP_CD = 'AV_RT'		THEN MSR_NVL ELSE NULL END)))
                        * CONVERT(FLOAT, CONVERT(NUMERIC(20,10), MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT' THEN MSR_NVL ELSE NULL END)))
                    )                                                                       AS MSR_NVL
                    ,NULL																	AS MSR_DDN
			FROM	#tblSCP0107_OPERATION_TOTAL
			WHERE	1=1
			  AND MSR_TP_CD IN ('AV_RT', 'PROD_OP_RT')
			GROUP BY  OP_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
					, YYYYMM

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408' AND MSR_TP_CD = 'AV_RT';
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408' AND MSR_TP_CD = 'PROD_OP_RT';
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408' AND MSR_TP_CD = 'TEEP';return;
		END -- TEEP


		BEGIN -- 설비대수(EQP_NBU)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL
			SELECT	  OP_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
					, MSR_GR_CD
					, MSR_TP_CD
					, YYYYMM
					, NULL								AS NUMERATOR
					, NULL								AS DENOMINATOR
					, CONVERT(FLOAT, SUM(MSR_NVL))		AS MSR_NVL -- 설비대수
					, NULL								AS MSR_DDN
			FROM	#tblSCP0107_RAW_TEMP_ALL WITH(NOLOCK)
			WHERE	1=1
				AND MSR_TP_CD = 'EQP_NBU'
			GROUP BY  OP_ALTER_KEY
                    ------, ELTR_LN_TP_CD
					, MSR_GR_CD
					, MSR_TP_CD
					, YYYYMM
		END -- 설비대수(EQP_NBU)

--TESTING : NOK
--select * from #tblSCP0107_RAW_TEMP_ALL where MSR_TP_CD = 'EQP_NBU' and yyyymm = '202408';return;
--select * from #tblSCP0107_OPERATION_TOTAL where MSR_TP_CD = 'EQP_NBU' and yyyymm = '202408';return;


		BEGIN -- PPM
			INSERT INTO	#TBLSCP0107_OPERATION_TOTAL
            SELECT    A.OP_ALTER_KEY
    			    ------, A.ELTR_LN_TP_CD
                    , A.MSR_GR_CD
                    , A.MSR_TP_CD
                    , A.YYYYMM
                    , NULL
                    , NULL
                    , CASE 
                        WHEN A.SPEED_PPM = 0 THEN 0.0
                        ELSE A.PROD_PLAN / A.SPEED_PPM
                      END	 					            AS MSR_NVL	-- PPM
                    , NULL								    AS MSR_DDN
			FROM	(
                        SELECT    OP_ALTER_KEY
                            	----, ELTR_LN_TP_CD
                                , MSR_GR_CD
                                , MSR_TP_CD
                                , YYYYMM    
                                , SUM(CONVERT(FLOAT, MSR_DDN))                      AS PROD_PLAN
                                , SUM(CONVERT(FLOAT, ISNULL(ATTRIBUTE1, '0.0')))    AS SPEED_PPM
                        FROM    #TBLSCP0107_RAW_TEMP_ALL
                        WHERE   1=1
                            AND MSR_TP_CD = 'PPM'
                        GROUP BY  OP_ALTER_KEY
                            	------, ELTR_LN_TP_CD
                                , MSR_GR_CD
                                , MSR_TP_CD
                                , YYYYMM
					) A

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408' AND MSR_TP_CD = 'PPM';return;
		END -- PPM


		BEGIN -- 표준폭환산자(SW_CNV_RT)
			INSERT INTO	#TBLSCP0107_OPERATION_TOTAL
            SELECT    A.OP_ALTER_KEY
    			    ------, A.ELTR_LN_TP_CD
                    , A.MSR_GR_CD
                    , A.MSR_TP_CD
                    , A.YYYYMM
                    , NULL
                    , NULL
                    , CASE 
                        WHEN A.ST2 = 0 THEN 0.0
                        ELSE A.ST1 / A.ST2
                      END	 					            AS MSR_NVL	-- PPM
                    , NULL								    AS MSR_DDN
			FROM	(
                        SELECT    OP_ALTER_KEY
                            	------, ELTR_LN_TP_CD
                                , MSR_GR_CD
                                , MSR_TP_CD
                                , YYYYMM    
                                , SUM(CONVERT(FLOAT, MSR_NVL) * CONVERT(FLOAT, MSR_DDN) * CONVERT(FLOAT, ISNULL(ATTRIBUTE1, '0.0')))  AS ST1
                                , SUM(CONVERT(FLOAT, MSR_DDN) * CONVERT(FLOAT, ISNULL(ATTRIBUTE1, '0.0')))                            AS ST2
                        FROM    #TBLSCP0107_RAW_TEMP_ALL
                        WHERE   1=1
                            AND MSR_TP_CD = 'SW_CNV_RT'
                        GROUP BY  OP_ALTER_KEY
                            	------, ELTR_LN_TP_CD
                                , MSR_GR_CD
                                , MSR_TP_CD
                                , YYYYMM
					) A
		END -- 표준폭환산자(SW_CNV_RT)

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL where MSR_TP_CD = 'SW_CNV_RT' AND YYYYMM = '202408';return;


        BEGIN -- 이론 CAPA(THRY_CAPA_D)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL
			SELECT	  E.OP_ALTER_KEY
                    ------, E.ELTR_LN_TP_CD
					, '-'															AS MSR_GR_CD
					, 'THRY_CAPA_D'													AS MSR_TP_CD
					, E.YYYYMM
					, CONVERT(FLOAT, NULL)											AS NUMERATOR
					, CONVERT(FLOAT, NULL)											AS DENOMINATOR
					, CONVERT(FLOAT,  ISNULL(E.MSR_NVL, 0.0) 
                                    * ISNULL(P.MSR_NVL, 0.0) 
                                    * ISNULL(S.MSR_NVL, 0.0)
                                    * 1440.0) AS MSR_NVL -- TACT TIME
					, NULL															AS MSR_DDN
			FROM	(
                        SELECT	  OP_ALTER_KEY
                                ------, ELTR_LN_TP_CD
					            , YYYYMM
					            , CONVERT(FLOAT, MAX(MSR_NVL))  AS MSR_NVL
			            FROM	#tblSCP0107_OPERATION_TOTAL
			            WHERE	1=1
				            AND MSR_TP_CD = 'EQP_NBU'
			            GROUP BY  OP_ALTER_KEY
                                ------, ELTR_LN_TP_CD
					            , YYYYMM
                    ) E
                    LEFT JOIN (
                                    SELECT	  OP_ALTER_KEY
                                            ------, ELTR_LN_TP_CD
					                        , YYYYMM
					                        , CONVERT(FLOAT, MAX(MSR_NVL))  AS MSR_NVL
			                        FROM	#tblSCP0107_OPERATION_TOTAL
			                        WHERE	1=1
				                        AND MSR_TP_CD = 'PPM'
			                        GROUP BY  OP_ALTER_KEY
                                            ------, ELTR_LN_TP_CD
					                        , YYYYMM
                              ) P ON
                            E.OP_ALTER_KEY      = P.OP_ALTER_KEY
                        ------AND E.ELTR_LN_TP_CD     = P.ELTR_LN_TP_CD
                        AND E.YYYYMM            = P.YYYYMM
                    LEFT JOIN (
                                    SELECT	  OP_ALTER_KEY
                                            ------, ELTR_LN_TP_CD
					                        , YYYYMM
					                        , CONVERT(FLOAT, MAX(MSR_NVL))  AS MSR_NVL
			                        FROM	#tblSCP0107_OPERATION_TOTAL
			                        WHERE	1=1
				                        AND MSR_TP_CD = 'SW_CNV_RT'
			                        GROUP BY  OP_ALTER_KEY
                                            ------, ELTR_LN_TP_CD
					                        , YYYYMM
                              ) S ON
                            E.OP_ALTER_KEY      = S.OP_ALTER_KEY
                        ------AND E.ELTR_LN_TP_CD     = S.ELTR_LN_TP_CD
                        AND E.YYYYMM            = S.YYYYMM
			WHERE	1=1

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408' and MSR_TP_CD = 'PPM';
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408' and MSR_TP_CD = 'EQP_NBU';
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408' and MSR_TP_CD = 'SW_CNV_RT';
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408' and MSR_TP_CD = 'THRY_CAPA_D';return;
		END -- 이론 CAPA(THRY_CAPA_D)


		BEGIN -- 생산 Capa(일)(PROD_CAPA_D)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL
			SELECT    OP_ALTER_KEY
                    ------, ELTR_LN_TP_CD
					, '-'																	AS MSR_GR_CD
					, 'PROD_CAPA_D'															AS MSR_TP_CD
					, YYYYMM
					, NULL																	AS NUMERATOR
					, NULL																	AS DENOMINATOR
					, CONVERT(FLOAT,  
						  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'THRY_CAPA_D'	        THEN MSR_NVL ELSE NULL END))
						* CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT'	            THEN MSR_NVL ELSE NULL END))
					  )																		AS MSR_NVL
					, NULL																	AS MSR_DDN
			FROM	#tblSCP0107_OPERATION_TOTAL
			WHERE	1=1
			  AND MSR_TP_CD IN ('THRY_CAPA_D', 'PROD_OP_RT')
			GROUP BY  OP_ALTER_KEY
                    ------, ELTR_LN_TP_CD
					, YYYYMM

--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408' AND MSR_TP_CD = 'PROD_CAPA_D';return;
		END -- 생산 Capa(일)(PROD_CAPA_D)


		BEGIN -- 생산 Capa(월)(PROD_CAPA_M)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL
			SELECT    OT.OP_ALTER_KEY
                    ------, OT.ELTR_LN_TP_CD
					, '-'																	AS MSR_GR_CD
					, 'PROD_CAPA_M'															AS MSR_TP_CD
					, OT.YYYYMM
					, NULL																	AS NUMERATOR
					, NULL																	AS DENOMINATOR
					, CONVERT(FLOAT,  
						CONVERT(FLOAT, OT.MSR_NVL) * CONVERT(FLOAT, YM.YYYYMM_DDN)
					  )																		AS MSR_NVL
					, NULL																	AS MSR_DDN
			FROM	#tblSCP0107_OPERATION_TOTAL OT
				 INNER JOIN #tblSCP0107_YYYYMM_DDN YM
						 ON YM.YYYYMM = OT.YYYYMM
						 AND YM.OP_ALTER_KEY = OT.OP_ALTER_KEY -- 0927 HRK TEST 
						 ------AND YM.ELTR_LN_TP_CD  = OT.ELTR_LN_TP_CD  -- 0927 HRK TEST 
			WHERE	1=1
			  AND MSR_TP_CD = 'PROD_CAPA_D'

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408' AND MSR_TP_CD = 'PROD_CAPA_M';return;
		END -- 생산 Capa(월)(PROD_CAPA_M)


		BEGIN -- SCP 생산 계획(SCP_PROD_PLAN)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL
			SELECT    OP_ALTER_KEY
                    ------, ELTR_LN_TP_CD
					, '-'								AS MSR_GR_CD
					, MSR_TP_CD
					, YYYYMM
					, NULL								AS NUMERATOR
					, NULL								AS DENOMINATOR
                    , SUM(CONVERT(FLOAT, MSR_NVL))      AS MSR_NVL
					, NULL								AS MSR_DDN
			 FROM	#TBLSCP0107_RAW_TEMP_ALL
			WHERE	1=1
				AND MSR_TP_CD = 'SCP_PROD_PLAN'
			GROUP BY  OP_ALTER_KEY
                    ------, ELTR_LN_TP_CD
					, MSR_TP_CD
					, YYYYMM

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408' AND MSR_TP_CD = 'SCP_PROD_PLAN' AND ELTR_LN_TP_CD = 'S';return;
		END -- SCP 생산 계획(SCP_PROD_PLAN)

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL where YYYYMM = '202408';return;
--select * from #tblSCP0107_OPERATION_TOTAL where MSR_TP_CD = 'SW_CNV_RT' AND YYYYMM = '202408' AND ELTR_LN_TP_CD = 'W';return;
--select * from #tblSCP0107_OPERATION_TOTAL where MSR_TP_CD = 'SW_CNV_RT' AND YYYYMM = '202408' AND ELTR_LN_TP_CD = 'W';
--select * from #tblSCP0107_RAW_TEMP_ALL where MSR_TP_CD = 'SW_CNV_RT' AND YYYYMM = '202408' AND ELTR_LN_TP_CD = 'W';return;

		INSERT INTO	#tblSCP0107_RAW_TEMP_ALL
        SELECT    @p_version	         AS VER_ID
                , @p_version_seq         AS VER_SEQ
                , DI.DIVISION_ID         AS DIVISION_ID
			    , '*'                    AS PLANT_ID
			    , '*'                    AS LINE_ID
			    , '*'                    AS OPERATION_ID
                ------, OK.ELTR_LN_TP_CD
			    , '*'                    AS COMPANY_ID
			    , '*'                    AS SITE_ID
			    , '*'                    AS FACTORY_ID
			    , OT.MSR_TP_CD
			    , OT.YYYYMM
			    , OT.MSR_GR_CD
			    , OT.MSR_NVL
			    , OT.MSR_DDN
				, NULL		            AS ATTRIBUTE1
				, NULL		            AS ATTRIBUTE2
				, NULL		            AS ATTRIBUTE3
				, NULL		            AS ATTRIBUTE4
				, NULL		            AS ATTRIBUTE5
				, NULL		            AS ATTRIBUTE6
				, NULL		            AS ATTRIBUTE7
				, NULL		            AS ATTRIBUTE8
				, 2			            AS DIV			--- 1 / RAW 2:공정 TOTAL
				, OT.OP_ALTER_KEY
				, NULL                  AS DV_ALTER_KEY
		FROM	#tblSCP0107_OPERATION_TOTAL OT
			    INNER JOIN #tblSCP0107_TOTAL_KEY OK ON 
                    OK.OP_ALTER_KEY     = OT.OP_ALTER_KEY
			    INNER JOIN (SELECT TOKEN AS DIVISION_ID FROM dbo.STRING_SPLIT(@P_DIVISION_ID, ',')) DI ON OK.DIVISION_ID = DI.DIVISION_ID
                ------AND OK.ELTR_LN_TP_CD    = OT.ELTR_LN_TP_CD
		WHERE	1=1
	END --설비 타입별 합계 추가

--TESTING : NOK
--select * from #tblSCP0107_RAW_TEMP_ALL;return
--select * from #tblSCP0107_RAW_TEMP_ALL where YYYYMM = '202408';return;
--select * from #tblSCP0107_RAW_TEMP_ALL where MSR_TP_CD = 'SCP_PROD_PLAN' AND YYYYMM = '202408' AND ELTR_LN_TP_CD = 'W';return;


	BEGIN --DIVISION_ID별 합계 추가
		IF OBJECT_ID('tempdb..#tblSCP0107_YYYYMM_DDN_DV') IS NOT NULL
			DROP TABLE #tblSCP0107_YYYYMM_DDN_DV;

		SELECT    A.DV_ALTER_KEY
				------, A.ELTR_LN_TP_CD -- 0927 HRK TEST 
				, A.YYYYMM
				, CONVERT(FLOAT,
				  CASE
                    WHEN SUM(A.ATTRIBUTE3) = 0 THEN 0
                    ELSE CONVERT(FLOAT, SUM(A.ATTRIBUTE2 * A.ATTRIBUTE3)) / CONVERT(FLOAT, SUM(A.ATTRIBUTE3))   --- 0927 hrk test  attribute8 -> attribute2 
                  END )          AS YYYYMM_DDN	-- 월/년 조업일수
	    INTO	#tblSCP0107_YYYYMM_DDN_DV
		FROM	#tblSCP0107_RAW_TEMP_ALL A
		WHERE	1=1
            AND OPERATION_ID <> '*'
			AND MSR_TP_CD = 'AV_RT'
		GROUP BY  A.DV_ALTER_KEY
				, A.YYYYMM
				------, A.eltr_ln_tp_cd -- 0927 hrk test 
		ORDER BY 1

--TESTING : NOK
--select * FROM	#tblSCP0107_RAW_TEMP_ALL where MSR_TP_CD = 'AV_RT';
--select * FROM	#tblSCP0107_YYYYMM_DDN_DV where YYYYMM = '202408';return;


		IF OBJECT_ID('tempdb..#tblSCP0107_TOTAL_KEY_DV') IS NOT NULL
			DROP TABLE #tblSCP0107_TOTAL_KEY_DV;

		SELECT DISTINCT
                    DV_ALTER_KEY
                ------, ELTR_LN_TP_CD
		INTO	#tblSCP0107_TOTAL_KEY_DV
		FROM	#tblSCP0107_RAW_TEMP_ALL WITH(NOLOCK)
		WHERE	1=1
            AND OPERATION_ID <> '*'

--TESTING : NOK
--select * FROM #tblSCP0107_TOTAL_KEY_DV;return;

		IF OBJECT_ID('tempdb..#tblSCP0107_OPERATION_TOTAL_DV') IS NOT NULL
			DROP TABLE #tblSCP0107_OPERATION_TOTAL_DV;

        --빈테이블 생성
		SELECT    DV_ALTER_KEY
			    ------, ELTR_LN_TP_CD
			    , MSR_GR_CD
			    , MSR_TP_CD
    			, YYYYMM
			    , CONVERT(FLOAT, NULL)          AS NUMERATOR
			    , CONVERT(FLOAT, NULL)          AS DENOMINATOR
			    , CONVERT(FLOAT, NULL)          AS MSR_NVL
			    , CONVERT(FLOAT, NULL)          AS MSR_DDN
		INTO	#tblSCP0107_OPERATION_TOTAL_DV    --- SELECT * FROM	#tblSCP0107_OPERATION_TOTAL_DV
		FROM	#tblSCP0107_RAW_TEMP_ALL WITH(NOLOCK)
        WHERE   1<>1


		BEGIN -- 비조업
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL_DV
			SELECT    DV_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
				    , MSR_GR_CD
				    , MSR_TP_CD
				    , YYYYMM
				    , CONVERT(FLOAT, SUM(MSR_NVL * ATTRIBUTE3))				AS NUMERATOR   -- 0-0비조업_M_설비대수	-- SUM(비조업*설비대수) - NUMERATOR		분자
				    , CONVERT(FLOAT, SUM(ATTRIBUTE3))						AS DENOMINATOR -- 설비대수				-- SUM(설비대수)	    - DENOMINATOR	분모
				    , CASE WHEN SUM(ATTRIBUTE3) = 0
					   THEN 0
					   ELSE CONVERT(FLOAT, SUM(MSR_NVL * ATTRIBUTE3)) / CONVERT(FLOAT, SUM(ATTRIBUTE3))
				      END													AS MSR_NVL	  -- 비조업(일수)  공정합계_비조업		-- SUM(비조업*설비대수) / SUM(설비대수)
				    , CASE WHEN SUM(ATTRIBUTE3) = 0
					       THEN 0
					       ELSE CONVERT(FLOAT, SUM(MSR_NVL * ATTRIBUTE3)) / (SUM(ATTRIBUTE3))
				      END													AS MSR_DDN
			FROM	#tblSCP0107_RAW_TEMP_ALL WITH(NOLOCK)
		    WHERE	1=1
                AND OPERATION_ID <> '*'
				AND MSR_GR_CD = 'NAV'		--- 비조업
			GROUP BY  DV_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
					, MSR_GR_CD
					, MSR_TP_CD
					, YYYYMM
			ORDER BY 1,2,3,4,5,6

--TESTING : NOK
--select * from #tblSCP0107_RAW_TEMP_ALL where MSR_GR_CD = 'NAV' AND YYYYMM = '202408';
--select * from #tblSCP0107_OPERATION_TOTAL_DV where MSR_GR_CD = 'NAV' AND YYYYMM = '202408';return;
		END -- 비조업


		BEGIN --조업율
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL_DV
			SELECT	  OT.DV_ALTER_KEY
    			     ------, OT.ELTR_LN_TP_CD
 					 , '-'		                                                                                                                    AS MSR_GR_CD
					 , 'AV_RT'	                                                                                                                    AS MSR_TP_CD
					 , OT.YYYYMM
					 , CONVERT(FLOAT, YM.YYYYMM_DDN) - CONVERT(FLOAT, SUM(OT.MSR_NVL))						                                        AS NUMERATOR
					 , CONVERT(FLOAT, YM.YYYYMM_DDN)																                                AS DENOMINATOR
					 , CONVERT(FLOAT, (CONVERT(FLOAT, YM.YYYYMM_DDN) - CONVERT(FLOAT, SUM(OT.MSR_NVL)))  / CONVERT(FLOAT, YM.YYYYMM_DDN))	AS MSR_NVL	-- 조업률
					 , CONVERT(FLOAT, YM.YYYYMM_DDN) - CONVERT(FLOAT, SUM(OT.MSR_NVL))						                                        AS MSR_DDN	-- 조업일수
			 FROM	#tblSCP0107_OPERATION_TOTAL_DV OT
				  INNER JOIN #tblSCP0107_YYYYMM_DDN_DV YM
						  ON YM.YYYYMM  = OT.YYYYMM
						 AND YM.DV_ALTER_KEY = OT.DV_ALTER_KEY -- 0927 HRK TEST 
						 ------AND YM.ELTR_LN_TP_CD  = OT.ELTR_LN_TP_CD  -- 0927 HRK TEST 
		    WHERE	1=1
				AND OT.MSR_GR_CD = 'NAV'
			GROUP BY  OT.DV_ALTER_KEY
    			    ------, OT.ELTR_LN_TP_CD
					, OT.YYYYMM
					, YM.YYYYMM_DDN

--return;

--TESTING : NOK
--select * from #tblSCP0107_RAW_TEMP_ALL where YYYYMM = '202408' AND MSR_TP_CD = 'AV_RT';
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408' AND MSR_TP_CD = 'AV_RT';return;
		END --조업율


		BEGIN -- 비부하
			INSERT INTO #tblSCP0107_OPERATION_TOTAL_DV
			SELECT	  A.DV_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
					, A.MSR_GR_CD
					, A.MSR_TP_CD
					, A.YYYYMM
					, A.NUMERATOR
					, A.DENOMINATOR
					, CONVERT(FLOAT, IIF(A.DENOMINATOR = 0, 0, A.NUMERATOR / A.DENOMINATOR)) AS MSR_NVL		--- 비부하
					, A.MSR_DDN
			FROM    (
						SELECT	  A.DV_ALTER_KEY
                			    ------, ELTR_LN_TP_CD
								, A.MSR_GR_CD
								, A.MSR_TP_CD
								, A.YYYYMM
								, CONVERT(FLOAT, SUM(A.MSR_DDN))        AS NUMERATOR
								, CONVERT(FLOAT, SUM(A.ATTRIBUTE1))     AS DENOMINATOR
								, NULL		AS MSR_DDN
                        FROM	#tblSCP0107_RAW_TEMP_ALL A
		                WHERE	1=1
                            AND OPERATION_ID <> '*'
							AND MSR_GR_CD = 'NLD'		--- 비부하
						GROUP BY  DV_ALTER_KEY
    			                ------, ELTR_LN_TP_CD
								, MSR_GR_CD
								, MSR_TP_CD
								, YYYYMM
					) A

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408';return;
		END -- 비부하


		BEGIN -- 부하율
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL_DV
			SELECT	  OT.DV_ALTER_KEY
    			    ------, OT.ELTR_LN_TP_CD
					, '-'		AS MSR_GR_CD
					, 'LD_RT'	AS MSR_TP_CD
					, OT.YYYYMM
					, AV.MSR_DDN																			AS NUMERATOR  -- 조업일수
					, NULL																					AS DENOMINATOR
					, (CONVERT(FLOAT, 1) - CONVERT(FLOAT, SUM(OT.MSR_NVL))) 				                AS MSR_NVL	-- 부하율
					, (CONVERT(FLOAT, 1) - CONVERT(FLOAT, SUM(OT.MSR_NVL))) * CONVERT(FLOAT, AV.MSR_DDN)	AS MSR_DDN	-- 부하일수
			 FROM	#tblSCP0107_OPERATION_TOTAL_DV OT
					INNER JOIN #tblSCP0107_OPERATION_TOTAL_DV AV ON
							AV.DV_ALTER_KEY   = OT.DV_ALTER_KEY
						------AND AV.ELTR_LN_TP_CD  = OT.ELTR_LN_TP_CD
						AND AV.MSR_TP_CD	  = 'AV_RT' -- 조업률/조업일수
						AND AV.YYYYMM	      = OT.YYYYMM
			WHERE	1=1
				AND OT.MSR_GR_CD = 'NLD' -- 비부하
			GROUP BY  OT.DV_ALTER_KEY
    			    ------, OT.ELTR_LN_TP_CD
					, OT.YYYYMM
					, AV.MSR_DDN

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408' AND MSR_TP_CD = 'LD_RT';RETURN
		END -- 부하율


		BEGIN -- 비가동
			INSERT INTO #tblSCP0107_OPERATION_TOTAL_DV
			SELECT	  A.DV_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
					, A.MSR_GR_CD
					, A.MSR_TP_CD
					, A.YYYYMM
					, A.NUMERATOR	-- 분자
					, A.DENOMINATOR	-- 분모
					, CONVERT(FLOAT,
                        CASE
							WHEN A.DENOMINATOR = 0 THEN CONVERT(FLOAT, 0)
							ELSE A.NUMERATOR / A.DENOMINATOR
						END
					  ) AS MSR_NVL		-- 비가동
				    , NULL AS MSR_DDN
			 FROM	(
						SELECT	  DV_ALTER_KEY
                			    ------, ELTR_LN_TP_CD
								, MSR_GR_CD
								, MSR_TP_CD
								, YYYYMM
								, CONVERT(FLOAT, SUM(A.MSR_DDN))        AS NUMERATOR
								, CONVERT(FLOAT, SUM(A.ATTRIBUTE1))     AS DENOMINATOR
						FROM	#tblSCP0107_RAW_TEMP_ALL A
		                WHERE	1=1
                            AND OPERATION_ID <> '*'
							AND MSR_GR_CD = 'NOP'		--- 비가동
                        GROUP BY  DV_ALTER_KEY
                			    ------, ELTR_LN_TP_CD
								, MSR_GR_CD
								, MSR_TP_CD
								, YYYYMM
					) A

--TESTING : NOK
--select * from #tblSCP0107_RAW_TEMP_ALL where YYYYMM = '202408' AND MSR_TP_CD = 'BM_RT';
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408' AND MSR_TP_CD = 'BM_RT';return;
		END -- 비가동


		BEGIN -- 시간가동률(OP_RT)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL_DV
			SELECT	  OT.DV_ALTER_KEY
    			    ------, OT.ELTR_LN_TP_CD
					, '-'																							AS MSR_GR_CD
					, 'OP_RT'																						AS MSR_TP_CD
					, OT.YYYYMM
					, LD.MSR_DDN																					AS NUMERATOR	-- 부하일수
					, NULL																							AS DENOMINATOR
					, CONVERT(FLOAT, (CONVERT(FLOAT, 1) - CONVERT(FLOAT, SUM(OT.MSR_NVL)))) 				AS MSR_NVL	-- 시간가동률
					, CONVERT(FLOAT, (CONVERT(FLOAT, 1) - CONVERT(FLOAT, SUM(OT.MSR_NVL))) * LD.MSR_DDN)	AS MSR_DDN	-- 시간가동일수
				 --- SELECT *
			 FROM	#tblSCP0107_OPERATION_TOTAL_DV OT
					INNER JOIN #tblSCP0107_OPERATION_TOTAL_DV LD ON
							LD.DV_ALTER_KEY   = OT.DV_ALTER_KEY
						------AND LD.ELTR_LN_TP_CD  = OT.ELTR_LN_TP_CD
						AND LD.MSR_TP_CD	  = 'LD_RT' -- 부하율/부하일수
						AND LD.YYYYMM	      = OT.YYYYMM
			WHERE	1=1
				AND OT.MSR_GR_CD = 'NOP' -- 비가동
			GROUP BY  OT.DV_ALTER_KEY
    			    ------, OT.ELTR_LN_TP_CD
					, OT.YYYYMM
					, LD.MSR_DDN

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408' AND MSR_TP_CD = 'OP_RT';return;
		END -- 시간가동률(OP_RT)


		BEGIN -- 성능가동률(PF_RT)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL_DV
			SELECT	  A.DV_ALTER_KEY
    			    ------, A.ELTR_LN_TP_CD
					, A.MSR_GR_CD
					, A.MSR_TP_CD
					, A.YYYYMM
					, A.NUMERATOR
					, A.DENOMINATOR
					, CONVERT(FLOAT,
						CASE
							WHEN A.DENOMINATOR = 0 THEN CONVERT(FLOAT, 0)
							ELSE A.NUMERATOR / A.DENOMINATOR
						END
					  )										    AS PF_RT	-- 성능가동률
				    , CONVERT(FLOAT, A.NUMERATOR)     AS PF_DDN	-- 성능가동률 * 시간가동일수 = 성능가동일수
			 FROM	(
						SELECT	  DV_ALTER_KEY
    			                ------, ELTR_LN_TP_CD
								, MSR_GR_CD
								, MSR_TP_CD
								, YYYYMM
								, CONVERT(FLOAT, SUM(A.MSR_DDN))        AS NUMERATOR
								, CONVERT(FLOAT, SUM(A.ATTRIBUTE1))     AS DENOMINATOR
						FROM	#tblSCP0107_RAW_TEMP_ALL A
		                WHERE	1=1
                            AND OPERATION_ID <> '*'
							AND MSR_TP_CD = 'PF_RT'		--- 성능가동률
                        GROUP BY  DV_ALTER_KEY
                			    ------, ELTR_LN_TP_CD
								, MSR_GR_CD
								, MSR_TP_CD
								, YYYYMM
					) A
					INNER JOIN #tblSCP0107_OPERATION_TOTAL_DV OP ON
							OP.DV_ALTER_KEY   = A.DV_ALTER_KEY
						------AND OP.ELTR_LN_TP_CD  = A.ELTR_LN_TP_CD
						AND OP.MSR_TP_CD	  = 'OP_RT' -- 시간가동률/시간가동일수
						AND OP.YYYYMM	      = A.YYYYMM

--TESTING : NOK
--select * from #tblSCP0107_RAW_TEMP_ALL where MSR_TP_CD = 'PF_RT';
--select * from #tblSCP0107_OPERATION_TOTAL_DV where MSR_TP_CD = 'PF_RT' AND YYYYMM = '202408';return;
		END -- 성능가동률(PF_RT)


		BEGIN -- 양품가동률(QL_RT)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL_DV
			SELECT	  A.DV_ALTER_KEY
    			    ------, A.ELTR_LN_TP_CD
					, A.MSR_GR_CD
					, A.MSR_TP_CD
					, A.YYYYMM
					, A.NUMERATOR
					, A.DENOMINATOR
					, CONVERT(FLOAT,
                        CASE
							WHEN A.DENOMINATOR = 0 THEN CONVERT(FLOAT, 0)
							ELSE A.NUMERATOR / A.DENOMINATOR
						END
					  ) AS MSR_NVL              -- 양품가동률
                    , A.NUMERATOR  AS QL_DDN	-- 양품가동일수 
			 FROM	(
						SELECT	  DV_ALTER_KEY
                			    ------, ELTR_LN_TP_CD
								, MSR_GR_CD
								, MSR_TP_CD
								, YYYYMM
								, CONVERT(FLOAT, SUM(A.MSR_DDN))        AS NUMERATOR
								, CONVERT(FLOAT, SUM(A.ATTRIBUTE1))     AS DENOMINATOR
						FROM	#tblSCP0107_RAW_TEMP_ALL A
		                WHERE	1=1
                                AND OPERATION_ID <> '*'
                                AND MSR_TP_CD = 'QL_RT'		--- 양품가동률
			            GROUP BY  DV_ALTER_KEY
                			    ------, ELTR_LN_TP_CD
					            , MSR_GR_CD
					            , MSR_TP_CD
					            , YYYYMM
					) A

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = 'RSLT' AND MSR_TP_CD = 'QL_RT';return;
		END -- 양품가동률(QL_RT)


		BEGIN -- 생산가동률(PROD_OP_RT)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL_DV
			SELECT    DV_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
					, '-'											                                                        AS MSR_GR_CD
					, 'PROD_OP_RT'									                                                        AS MSR_TP_CD
					, YYYYMM
					, CONVERT(FLOAT, NULL)											                                        AS NUMERATOR
					, CONVERT(FLOAT, NULL)							                                                        AS DENOMINATOR
					, CONVERT(FLOAT, 
						  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'LD_RT'	THEN CONVERT(FLOAT, MSR_NVL) ELSE NULL END))
						* CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'OP_RT'  THEN CONVERT(FLOAT, MSR_NVL) ELSE NULL END))
						* CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PF_RT'  THEN CONVERT(FLOAT, MSR_NVL) ELSE NULL END))
						* CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'QL_RT'  THEN CONVERT(FLOAT, MSR_NVL) ELSE NULL END))
					  )																										AS MSR_NVL
					, NULL																                                    AS MSR_DDN
				  -- SELECT *
			FROM	#tblSCP0107_OPERATION_TOTAL_DV
			WHERE	1=1
				AND MSR_TP_CD IN ('LD_RT', 'OP_RT', 'PF_RT', 'QL_RT')
			GROUP BY DV_ALTER_KEY
    			   ------, ELTR_LN_TP_CD
				   , YYYYMM

--TESTING : NOK
----select * from #tblSCP0107_RAW_TEMP_ALL where YYYYMM = '202408' and MSR_TP_CD = 'PROD_OP_RT';return;
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = 'RSLT' and MSR_TP_CD = 'LD_RT';
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = 'RSLT' and MSR_TP_CD = 'OP_RT';
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = 'RSLT' and MSR_TP_CD = 'PF_RT';
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = 'RSLT' and MSR_TP_CD = 'QL_RT';
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = 'RSLT' and MSR_TP_CD = 'PROD_OP_RT';return;
		END -- 생산가동률(PROD_OP_RT)


		BEGIN -- TEEP
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL_DV
			SELECT    DV_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
					, '-'																	AS MSR_GR_CD
					, 'TEEP'																AS MSR_TP_CD
					, YYYYMM
					, NULL																	AS NUMERATOR
					, NULL																	AS DENOMINATOR
                    , CONVERT(NUMERIC(20,10),
                          CONVERT(FLOAT, CONVERT(NUMERIC(20,10), MAX(CASE WHEN MSR_TP_CD = 'AV_RT'		THEN MSR_NVL ELSE NULL END)))
                        * CONVERT(FLOAT, CONVERT(NUMERIC(20,10), MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT' THEN MSR_NVL ELSE NULL END)))
                    )                                                                       AS MSR_NVL
                    ,NULL																	AS MSR_DDN
			FROM	#tblSCP0107_OPERATION_TOTAL_DV
			WHERE	1=1
			  AND MSR_TP_CD IN ('AV_RT', 'PROD_OP_RT')
			GROUP BY  DV_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
					, YYYYMM

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408' AND MSR_TP_CD = 'AV_RT';
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408' AND MSR_TP_CD = 'PROD_OP_RT';
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408' AND MSR_TP_CD = 'TEEP';return;
		END -- TEEP


		BEGIN -- 설비대수(EQP_NBU)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL_DV
			SELECT	  DV_ALTER_KEY
    			    ------, ELTR_LN_TP_CD
					, MSR_GR_CD
					, MSR_TP_CD
					, YYYYMM
					, NULL								AS NUMERATOR
					, NULL								AS DENOMINATOR
					, CONVERT(FLOAT, SUM(MSR_NVL))		AS MSR_NVL -- 설비대수
					, NULL								AS MSR_DDN
			FROM	#tblSCP0107_RAW_TEMP_ALL WITH(NOLOCK)
		    WHERE	1=1
                AND OPERATION_ID <> '*'
				AND MSR_TP_CD = 'EQP_NBU'
			GROUP BY  DV_ALTER_KEY
                    ------, ELTR_LN_TP_CD
					, MSR_GR_CD
					, MSR_TP_CD
					, YYYYMM
		END -- 설비대수(EQP_NBU)

--TESTING : NOK
--select * from #tblSCP0107_RAW_TEMP_ALL where MSR_TP_CD = 'EQP_NBU' and yyyymm = '202408';return;
--select * from #tblSCP0107_OPERATION_TOTAL_DV where MSR_TP_CD = 'EQP_NBU' and yyyymm = '202408';return;


		BEGIN -- PPM
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL_DV
            SELECT    A.DV_ALTER_KEY
    			    ------, A.ELTR_LN_TP_CD
                    , A.MSR_GR_CD
                    , A.MSR_TP_CD
                    , A.YYYYMM
                    , NULL
                    , NULL
                    , CASE 
                        WHEN A.SPEED_PPM = 0 THEN 0.0
                        ELSE A.PROD_PLAN / A.SPEED_PPM
                      END	 					            AS MSR_NVL	-- PPM
                    , NULL								    AS MSR_DDN
			FROM	(
                        SELECT    DV_ALTER_KEY
                            	----, ELTR_LN_TP_CD
                                , MSR_GR_CD
                                , MSR_TP_CD
                                , YYYYMM    
                                , SUM(CONVERT(FLOAT, MSR_DDN))                      AS PROD_PLAN
                                , SUM(CONVERT(FLOAT, ISNULL(ATTRIBUTE1, '0.0')))    AS SPEED_PPM
                        FROM    #TBLSCP0107_RAW_TEMP_ALL
		                WHERE	1=1
                            AND OPERATION_ID <> '*'
                            AND MSR_TP_CD = 'PPM'
                        GROUP BY  DV_ALTER_KEY
                            	------, ELTR_LN_TP_CD
                                , MSR_GR_CD
                                , MSR_TP_CD
                                , YYYYMM
					) A

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408' AND MSR_TP_CD = 'PPM';return;
		END -- PPM


		BEGIN -- 표준폭환산자(SW_CNV_RT)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL_DV
            SELECT    A.DV_ALTER_KEY
    			    ------, A.ELTR_LN_TP_CD
                    , A.MSR_GR_CD
                    , A.MSR_TP_CD
                    , A.YYYYMM
                    , NULL
                    , NULL
                    , CASE 
                        WHEN A.ST2 = 0 THEN 0.0
                        ELSE A.ST1 / A.ST2
                      END	 					            AS MSR_NVL	-- PPM
                    , NULL								    AS MSR_DDN
			FROM	(
                        SELECT    DV_ALTER_KEY
                            	------, ELTR_LN_TP_CD
                                , MSR_GR_CD
                                , MSR_TP_CD
                                , YYYYMM    
                                , SUM(CONVERT(FLOAT, MSR_NVL) * CONVERT(FLOAT, MSR_DDN) * CONVERT(FLOAT, ISNULL(ATTRIBUTE1, '0.0')))  AS ST1
                                , SUM(CONVERT(FLOAT, MSR_DDN) * CONVERT(FLOAT, ISNULL(ATTRIBUTE1, '0.0')))                            AS ST2
                        FROM    #TBLSCP0107_RAW_TEMP_ALL
		                WHERE	1=1
                            AND OPERATION_ID <> '*'
                            AND MSR_TP_CD = 'SW_CNV_RT'
                        GROUP BY  DV_ALTER_KEY
                            	------, ELTR_LN_TP_CD
                                , MSR_GR_CD
                                , MSR_TP_CD
                                , YYYYMM
					) A
		END -- 표준폭환산자(SW_CNV_RT)

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL_DV where MSR_TP_CD = 'SW_CNV_RT' AND YYYYMM = '202408';return;


        BEGIN -- 이론 CAPA(THRY_CAPA_D)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL_DV
			SELECT	  E.DV_ALTER_KEY
                    ------, E.ELTR_LN_TP_CD
					, '-'															AS MSR_GR_CD
					, 'THRY_CAPA_D'													AS MSR_TP_CD
					, E.YYYYMM
					, CONVERT(FLOAT, NULL)											AS NUMERATOR
					, CONVERT(FLOAT, NULL)											AS DENOMINATOR
					, CONVERT(FLOAT,  ISNULL(E.MSR_NVL, 0.0) 
                                    * ISNULL(P.MSR_NVL, 0.0) 
                                    * ISNULL(S.MSR_NVL, 0.0)
                                    * 1440.0) AS MSR_NVL -- TACT TIME
					, NULL															AS MSR_DDN
			FROM	(
                        SELECT	  DV_ALTER_KEY
                                ------, ELTR_LN_TP_CD
					            , YYYYMM
					            , CONVERT(FLOAT, MAX(MSR_NVL))  AS MSR_NVL
			            FROM	#tblSCP0107_OPERATION_TOTAL_DV
			            WHERE	1=1
				            AND MSR_TP_CD = 'EQP_NBU'
			            GROUP BY  DV_ALTER_KEY
                                ------, ELTR_LN_TP_CD
					            , YYYYMM
                    ) E
                    LEFT JOIN (
                                    SELECT	  DV_ALTER_KEY
                                            ------, ELTR_LN_TP_CD
					                        , YYYYMM
					                        , CONVERT(FLOAT, MAX(MSR_NVL))  AS MSR_NVL
			                        FROM	#tblSCP0107_OPERATION_TOTAL_DV
			                        WHERE	1=1
				                        AND MSR_TP_CD = 'PPM'
			                        GROUP BY  DV_ALTER_KEY
                                            ------, ELTR_LN_TP_CD
					                        , YYYYMM
                              ) P ON
                            E.DV_ALTER_KEY      = P.DV_ALTER_KEY
                        ------AND E.ELTR_LN_TP_CD     = P.ELTR_LN_TP_CD
                        AND E.YYYYMM            = P.YYYYMM
                    LEFT JOIN (
                                    SELECT	  DV_ALTER_KEY
                                            ------, ELTR_LN_TP_CD
					                        , YYYYMM
					                        , CONVERT(FLOAT, MAX(MSR_NVL))  AS MSR_NVL
			                        FROM	#tblSCP0107_OPERATION_TOTAL_DV
			                        WHERE	1=1
				                        AND MSR_TP_CD = 'SW_CNV_RT'
			                        GROUP BY  DV_ALTER_KEY
                                            ------, ELTR_LN_TP_CD
					                        , YYYYMM
                              ) S ON
                            E.DV_ALTER_KEY      = S.DV_ALTER_KEY
                        ------AND E.ELTR_LN_TP_CD     = S.ELTR_LN_TP_CD
                        AND E.YYYYMM            = S.YYYYMM
			WHERE	1=1

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408' and MSR_TP_CD = 'PPM';
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408' and MSR_TP_CD = 'EQP_NBU';
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408' and MSR_TP_CD = 'SW_CNV_RT';
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408' and MSR_TP_CD = 'THRY_CAPA_D';return;
		END -- 이론 CAPA(THRY_CAPA_D)


		BEGIN -- 생산 Capa(일)(PROD_CAPA_D)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL_DV
			SELECT    DV_ALTER_KEY
                    ------, ELTR_LN_TP_CD
					, '-'																	AS MSR_GR_CD
					, 'PROD_CAPA_D'															AS MSR_TP_CD
					, YYYYMM
					, NULL																	AS NUMERATOR
					, NULL																	AS DENOMINATOR
					, CONVERT(FLOAT,  
						  CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'THRY_CAPA_D'	        THEN MSR_NVL ELSE NULL END))
						* CONVERT(FLOAT, MAX(CASE WHEN MSR_TP_CD = 'PROD_OP_RT'	            THEN MSR_NVL ELSE NULL END))
					  )																		AS MSR_NVL
					, NULL																	AS MSR_DDN
			FROM	#tblSCP0107_OPERATION_TOTAL_DV
			WHERE	1=1
			  AND MSR_TP_CD IN ('THRY_CAPA_D', 'PROD_OP_RT')
			GROUP BY  DV_ALTER_KEY
                    ------, ELTR_LN_TP_CD
					, YYYYMM

--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408' AND MSR_TP_CD = 'PROD_CAPA_D';return;
		END -- 생산 Capa(일)(PROD_CAPA_D)


		BEGIN -- 생산 Capa(월)(PROD_CAPA_M)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL_DV
			SELECT    OT.DV_ALTER_KEY
                    ------, OT.ELTR_LN_TP_CD
					, '-'																	AS MSR_GR_CD
					, 'PROD_CAPA_M'															AS MSR_TP_CD
					, OT.YYYYMM
					, NULL																	AS NUMERATOR
					, NULL																	AS DENOMINATOR
					, CONVERT(FLOAT,  
						CONVERT(FLOAT, OT.MSR_NVL) * CONVERT(FLOAT, YM.YYYYMM_DDN)
					  )																		AS MSR_NVL
					, NULL																	AS MSR_DDN
			FROM	#tblSCP0107_OPERATION_TOTAL_DV OT
				 INNER JOIN #tblSCP0107_YYYYMM_DDN_DV YM
						 ON YM.YYYYMM = OT.YYYYMM
						 AND YM.DV_ALTER_KEY = OT.DV_ALTER_KEY -- 0927 HRK TEST 
						 ------AND YM.ELTR_LN_TP_CD  = OT.ELTR_LN_TP_CD  -- 0927 HRK TEST 
			WHERE	1=1
			  AND MSR_TP_CD = 'PROD_CAPA_D'

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408' AND MSR_TP_CD = 'PROD_CAPA_M';return;
		END -- 생산 Capa(월)(PROD_CAPA_M)


		BEGIN -- SCP 생산 계획(SCP_PROD_PLAN)
			INSERT INTO	#tblSCP0107_OPERATION_TOTAL_DV
			SELECT    DV_ALTER_KEY
                    ------, ELTR_LN_TP_CD
					, '-'								AS MSR_GR_CD
					, MSR_TP_CD
					, YYYYMM
					, NULL								AS NUMERATOR
					, NULL								AS DENOMINATOR
                    , SUM(CONVERT(FLOAT, MSR_NVL))      AS MSR_NVL
					, NULL								AS MSR_DDN
			 FROM	#TBLSCP0107_RAW_TEMP_ALL
		     WHERE	1=1
                    AND OPERATION_ID <> '*'
				    AND MSR_TP_CD = 'SCP_PROD_PLAN'
			GROUP BY  DV_ALTER_KEY
                    ------, ELTR_LN_TP_CD
					, MSR_TP_CD
					, YYYYMM

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408' AND MSR_TP_CD = 'SCP_PROD_PLAN' AND ELTR_LN_TP_CD = 'S';return;
		END -- SCP 생산 계획(SCP_PROD_PLAN)

--TESTING : NOK
--select * from #tblSCP0107_OPERATION_TOTAL_DV where YYYYMM = '202408';return;
--select * from #tblSCP0107_OPERATION_TOTAL_DV where MSR_TP_CD = 'SW_CNV_RT' AND YYYYMM = '202408' AND ELTR_LN_TP_CD = 'W';return;
--select * from #tblSCP0107_OPERATION_TOTAL_DV where MSR_TP_CD = 'SW_CNV_RT' AND YYYYMM = '202408' AND ELTR_LN_TP_CD = 'W';
--select * from #tblSCP0107_RAW_TEMP_ALL where MSR_TP_CD = 'SW_CNV_RT' AND YYYYMM = '202408' AND ELTR_LN_TP_CD = 'W';return;
--select * from #tblSCP0107_RAW_TEMP_ALL WHERE DIV = 3 AND YYYYMM = '202411' AND MSR_TP_CD = 'QL_RT';return;

		INSERT INTO	#tblSCP0107_RAW_TEMP_ALL
        SELECT    @p_version	         AS VER_ID
                , @p_version_seq         AS VER_SEQ
                , '*'			         AS DIVISION_ID
			    , '*'                    AS PLANT_ID
			    , '*'                    AS LINE_ID
			    , '*'                    AS OPERATION_ID
                ------, OK.ELTR_LN_TP_CD
			    , '*'                    AS COMPANY_ID
			    , '*'                    AS SITE_ID
			    , '*'                    AS FACTORY_ID
			    , OT.MSR_TP_CD
			    , OT.YYYYMM
			    , OT.MSR_GR_CD
			    , OT.MSR_NVL
			    , OT.MSR_DDN
				, NULL		            AS ATTRIBUTE1
				, NULL		            AS ATTRIBUTE2
				, NULL		            AS ATTRIBUTE3
				, NULL		            AS ATTRIBUTE4
				, NULL		            AS ATTRIBUTE5
				, NULL		            AS ATTRIBUTE6
				, NULL		            AS ATTRIBUTE7
				, NULL		            AS ATTRIBUTE8
				, 3			            AS DIV			--- 1 / RAW 2:공정 TOTAL
				, NULL                  AS OP_ALTER_KEY
				, OT.DV_ALTER_KEY
		FROM	#tblSCP0107_OPERATION_TOTAL_DV OT
			    INNER JOIN #tblSCP0107_TOTAL_KEY_DV OK ON 
                    OK.DV_ALTER_KEY     = OT.DV_ALTER_KEY
--test			    INNER JOIN (SELECT TOKEN AS DIVISION_ID FROM dbo.STRING_SPLIT(@P_DIVISION_ID, ',')) DI ON OK.DIVISION_ID = DI.DIVISION_ID
                ------AND OK.ELTR_LN_TP_CD    = OT.ELTR_LN_TP_CD
		WHERE	1=1
	END --DIVISION_ID별 합계 추가

--TESTING : NOK
--select * from #tblSCP0107_RAW_TEMP_ALL WHERE DIV = 3 AND YYYYMM = '202411' AND MSR_TP_CD = 'QL_RT';return;


	IF OBJECT_ID('tempdb..#tblSCP0107_RAW_ALL') IS NOT NULL
    	DROP TABLE #tblSCP0107_RAW_ALL;

    --빈테이블 생성
    SELECT    A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
            ------, A.ELTR_LN_TP_CD
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.YYYYMM
			, A.MSR_GR_CD
            , A.MSR_TP_CD
		    , CONVERT(NVARCHAR(100), NULL)              AS LOSS_NM_EN
		    , CONVERT(NVARCHAR(100), NULL)              AS LOSS_GR_NM_EN
		    , CONVERT(INTEGER, NULL)                    AS SORT_ORDER_NO
            , CONVERT(INTEGER, NULL)                    AS SORT_ORDER_NO_GR
			, A.MSR_NVL
			, A.MSR_DDN
		    , A.ATTRIBUTE1
		    , A.ATTRIBUTE2
		    , A.ATTRIBUTE3
		    , A.ATTRIBUTE4
		    , A.ATTRIBUTE5
		    , A.ATTRIBUTE6
		    , A.ATTRIBUTE7
		    , A.ATTRIBUTE8
    INTO    #tblSCP0107_RAW_ALL
    FROM    #tblSCP0107_RAW_TEMP_ALL A
    WHERE   1<>1;


    INSERT INTO #tblSCP0107_RAW_ALL
    SELECT    A.VER_ID              
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.PLANT_ID
			, A.LINE_ID
			, A.OPERATION_ID
            ------, A.ELTR_LN_TP_CD
			, A.COMPANY_ID
			, A.SITE_ID
			, A.FACTORY_ID
			, A.YYYYMM
			, A.MSR_GR_CD
            , A.MSR_TP_CD
		    , M.LOSS_NM_EN
		    , M.LOSS_GR_NM_EN
		    , CONVERT(INTEGER, M.DISPLAY_SEQ)    AS SORT_ORDER_NO
            , CONVERT(INTEGER, A.DIV)            AS SORT_ORDER_NO_GR
			, CASE
                WHEN A.MSR_TP_CD IN ( 'PPM'
                                    , 'SW_CNV_RT'
                                    , 'TACT_TIME'
                                    , 'EQP_NBU'
                                    , 'SCP_PROD_PLAN'
                                    , 'PROD_CAPA_M'
                                    , 'PROD_CAPA_D'
                                    , 'SCP_PROD_PLAN_DDN'
                                    , 'THRY_CAPA_D'
                                    , 'SD_RT'
                                    , 'WT_RT'
                                    , 'TD_RT'
                                    , 'MC_RT') THEN A.MSR_NVL --일수 or EA
                ELSE A.MSR_NVL * 100.0 --비율로 표시
              END AS MSR_NVL
			, A.MSR_DDN
		    , A.ATTRIBUTE1
		    , A.ATTRIBUTE2
		    , A.ATTRIBUTE3
		    , A.ATTRIBUTE4
		    , A.ATTRIBUTE5
		    , A.ATTRIBUTE6
		    , A.ATTRIBUTE7
		    , A.ATTRIBUTE8
    FROM    #tblSCP0107_RAW_TEMP_ALL A
            JOIN #tblSCP0107_MEASURE M ON
                    A.MSR_TP_CD = M.LOSS_CD;

--TESTING : NOK
--select * from #tblSCP0107_RAW_ALL;return;
--select * from #tblSCP0107_RAW_ALL where YYYYMM = '202408';return;


	IF OBJECT_ID('tempdb..#tblSCP0107_RAW') IS NOT NULL

			DROP TABLE #tblSCP0107_RAW;

    --빈테이블 생성
    SELECT    A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
            ------, A.ELTR_LN_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
            , A.MSR_TP_CD
		    , A.LOSS_NM_EN
		    , A.LOSS_GR_NM_EN
		    , A.SORT_ORDER_NO
            , A.SORT_ORDER_NO_GR

			, A.MSR_NVL
			, A.MSR_DDN

			, A.MSR_NVL                 AS Z_MSR_NVL
			, A.MSR_DDN                 AS Z_MSR_DDN

			, A.MSR_NVL                 AS R_MSR_NVL
			, A.MSR_DDN                 AS R_MSR_DDN

			, A.MSR_NVL                 AS B_MSR_NVL
			, A.MSR_DDN                 AS B_MSR_DDN

			, A.MSR_NVL                 AS P_MSR_NVL
			, A.MSR_DDN                 AS P_MSR_DDN
    INTO    #tblSCP0107_RAW
    FROM    #tblSCP0107_RAW_ALL A
    WHERE   1<>1

    INSERT INTO #tblSCP0107_RAW
    SELECT    A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
            ------, A.ELTR_LN_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
            , A.MSR_TP_CD
		    , A.LOSS_NM_EN
		    , A.LOSS_GR_NM_EN
		    , A.SORT_ORDER_NO
            , A.SORT_ORDER_NO_GR

			, CASE
				WHEN A.YYYYMM NOT IN ('BIZP', 'RSLT', 'BASE', 'PRVS') THEN SUM(A.MSR_NVL)
                ELSE NULL
              END AS MSR_NVL
			, CASE
				WHEN A.YYYYMM NOT IN ('BIZP', 'RSLT', 'BASE', 'PRVS') THEN SUM(A.MSR_DDN)
                ELSE NULL
              END AS MSR_DDN

			, CASE
				WHEN A.YYYYMM = 'BIZP' THEN SUM(A.MSR_NVL)
                ELSE NULL
              END AS Z_MSR_NVL
			, CASE
				WHEN A.YYYYMM = 'BIZP' THEN SUM(A.MSR_DDN)
                ELSE NULL
              END AS Z_MSR_DDN

			, CASE
				WHEN A.YYYYMM = 'RSLT' THEN SUM(A.MSR_NVL)
                ELSE NULL
              END AS R_MSR_NVL
			, CASE
				WHEN A.YYYYMM = 'RSLT' THEN SUM(A.MSR_DDN)
                ELSE NULL
              END AS R_MSR_DDN

			, CASE
				WHEN A.YYYYMM = 'BASE' THEN SUM(A.MSR_NVL)
                ELSE NULL
              END AS B_MSR_NVL
			, CASE
				WHEN A.YYYYMM = 'BASE' THEN SUM(A.MSR_DDN)
                ELSE NULL
              END AS B_MSR_NVL

			, CASE
				WHEN A.YYYYMM = 'PRVS' THEN SUM(A.MSR_NVL)
                ELSE NULL
              END AS P_MSR_NVL
			, CASE
				WHEN A.YYYYMM = 'PRVS' THEN SUM(A.MSR_DDN)
                ELSE NULL
              END AS P_MSR_NVL
    FROM    #tblSCP0107_RAW_ALL A
    GROUP BY  A.VER_ID
			, A.VER_SEQ
            , A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, A.OPERATION_ID
            ------, A.ELTR_LN_TP_CD
			, A.YYYYMM
			, A.MSR_GR_CD
            , A.MSR_TP_CD
		    , A.LOSS_NM_EN
		    , A.LOSS_GR_NM_EN
		    , A.SORT_ORDER_NO
            , A.SORT_ORDER_NO_GR

--TESTING : NOK
--select * from #tblSCP0107_RAW;return;
--select * from #tblSCP0107_RAW where MSR_TP_CD = 'SCP_PROD_PLAN' AND YYYYMM = '202408' AND ELTR_LN_TP_CD = 'S';return;
--select * from #tblSCP0107_RAW_TEMP_ALL WHERE DIV = 3 AND YYYYMM = '202411' AND MSR_TP_CD = 'QL_RT';return;


    BEGIN -- 동적쿼리 생성
	    DECLARE @V_DATE_COLS           NVARCHAR(MAX) = N'';
	    DECLARE @V_FINAL_SUM_COLS      NVARCHAR(MAX) = N'';
	    DECLARE @V_FINAL_AVG_COLS      NVARCHAR(MAX) = N'';
	    DECLARE @V_FINAL_COLS          NVARCHAR(MAX) = N'';

	    SELECT      @V_DATE_COLS       = @V_DATE_COLS + '
			      , ' +
				    CASE
                        WHEN CHARINDEX('M_01', COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 5, 6) THEN MSR_NVL END AS ' + COLUMN_NAME
					    WHEN CHARINDEX('Y_',   COLUMN_NAME) = 1 THEN 'CASE WHEN YYYYMM = SUBSTRING(''' + COLUMN_NAME + ''', 3, 4) THEN MSR_NVL END AS ' + COLUMN_NAME
				    END
                  , @V_FINAL_SUM_COLS      = @V_FINAL_SUM_COLS + '
			      , SUM(' + COLUMN_NAME + ') AS ' + COLUMN_NAME
                  , @V_FINAL_AVG_COLS      = @V_FINAL_AVG_COLS + '
			      , AVG(' + COLUMN_NAME + ') AS ' + COLUMN_NAME
                  , @V_FINAL_COLS      = @V_FINAL_COLS + '
			      , ' + COLUMN_NAME + ' AS ' + COLUMN_NAME
	    FROM    #tblSCP0107_DATE_COLS A
	    ORDER BY SORT_ORDER_NO;

        --TESTING : OK
        --EXEC DEBUG_LOG @V_FINAL_AVG_COLS, 'T';RETURN;
        --EXEC DEBUG_LOG @V_FINAL_COLS, 'T';RETURN;


        DECLARE     @V_SQL  NVARCHAR(MAX)       = N'';

        SET @V_SQL  = N'
    	    IF OBJECT_ID(''tempdb..#tblSCP0107_FINAL_TEMP'') IS NOT NULL

				    DROP TABLE #tblSCP0107_FINAL_TEMP;

            --빈테이블 생성
            SELECT    A.VER_ID
			        , A.VER_SEQ
                    , A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
                    ------, A.ELTR_LN_TP_CD
			        , A.MSR_GR_CD
                    , A.MSR_TP_CD
                    , A.LOSS_NM_EN
                    , A.LOSS_GR_NM_EN
                    , A.SORT_ORDER_NO
                    , A.SORT_ORDER_NO_GR
			        , A.Z_MSR_NVL               AS BIZ_QTY
			        , A.Z_MSR_DDN               AS BIZ_DDN
			        , A.R_MSR_NVL               AS PFRSLT_QTY
			        , A.R_MSR_DDN               AS PFRSLT_DDN
			        , A.B_MSR_NVL               AS BASE_QTY
			        , A.B_MSR_DDN               AS BASE_DDN
			        , A.P_MSR_NVL               AS PRE_QTY
			        , A.P_MSR_DDN               AS PRE_DDN
                    ' + @v_date_cols + N'
            INTO    #tblSCP0107_FINAL_TEMP
		    FROM    #tblSCP0107_RAW A
            WHERE   1<>1;

            INSERT INTO	#tblSCP0107_FINAL_TEMP
            SELECT    A.VER_ID
			        , A.VER_SEQ
                    , A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
                    ------, A.ELTR_LN_TP_CD
			        , A.MSR_GR_CD
                    , A.MSR_TP_CD
                    , A.LOSS_NM_EN
                    , A.LOSS_GR_NM_EN
                    , A.SORT_ORDER_NO
                    , A.SORT_ORDER_NO_GR
			        , A.Z_MSR_NVL               AS BIZ_QTY
			        , A.Z_MSR_DDN               AS BIZ_DDN
			        , A.R_MSR_NVL               AS PFRSLT_QTY
			        , A.R_MSR_DDN               AS PFRSLT_DDN
			        , A.B_MSR_NVL               AS BASE_QTY
			        , A.B_MSR_DDN               AS BASE_DDN
			        , A.P_MSR_NVL               AS PRE_QTY
			        , A.P_MSR_DDN               AS PRE_DDN
                    ' + @v_date_cols + N'
		    FROM    #tblSCP0107_RAW A;

            --TESTING : NOK
            --SELECT * FROM #tblSCP0107_FINAL_TEMP;return;

            --select * from #tblSCP0107_FINAL_TEMP WHERE PLANT_ID = ''*'' AND MSR_TP_CD = ''QL_RT'';return;

    	    IF OBJECT_ID(''tempdb..#tblSCP0107_FINAL'') IS NOT NULL
				DROP TABLE #tblSCP0107_FINAL;

            SELECT    A.VER_ID
			        , A.VER_SEQ
                    , A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
                    ------, A.ELTR_LN_TP_CD
			        , A.MSR_GR_CD
                    , A.MSR_TP_CD
                    , A.LOSS_NM_EN
                    , A.LOSS_GR_NM_EN
                    , A.SORT_ORDER_NO
                    , A.SORT_ORDER_NO_GR
			        , SUM(A.BIZ_QTY)				AS BIZ_QTY
			        , SUM(A.BIZ_DDN)				AS BIZ_DDN
			        , SUM(A.PFRSLT_QTY)				AS PFRSLT_QTY
			        , SUM(A.PFRSLT_DDN)				AS PFRSLT_DDN
			        , SUM(A.BASE_QTY)				AS BASE_QTY
			        , SUM(A.BASE_DDN)				AS BASE_DDN
			        , SUM(A.PRE_QTY)				AS PRE_QTY
			        , SUM(A.PRE_DDN)				AS PRE_DDN
                    ' + @v_final_sum_cols + N'
            INTO    #tblSCP0107_FINAL
		    FROM    #tblSCP0107_FINAL_TEMP A
            GROUP BY A.VER_ID
			        , A.VER_SEQ
                    , A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
                    ------, A.ELTR_LN_TP_CD
			        , A.MSR_GR_CD
                    , A.MSR_TP_CD
                    , A.LOSS_NM_EN
                    , A.LOSS_GR_NM_EN
                    , A.SORT_ORDER_NO
                    , A.SORT_ORDER_NO_GR

            --TESTING : NOK
            ----SELECT * FROM #tblSCP0107_FINAL;return;
            --select * from #tblSCP0107_FINAL WHERE PLANT_ID = ''*'' AND MSR_TP_CD = ''QL_RT'';return;


            SELECT    A.VER_ID
			        , A.VER_SEQ
                    , A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.SITE_ID
			        , A.PLANT_ID
			        , A.FACTORY_ID
			        , A.LINE_ID
			        , A.OPERATION_ID
					, CASE
                        WHEN A.OPERATION_ID <> ''*'' THEN ISNULL(O.OPERATION_NAME, ''*'')
                        ELSE ''*''
                      END                                                                                           AS OPERATION_NAME
     ------               , A.ELTR_LN_TP_CD
					------, A.ELTR_LN_TP_CD     + '' '' + E.ELTR_TP_NM_EN													AS ELTR_TP_NM_EN
                    , A.MSR_GR_CD																					AS MEASURE_GROUP
                    , A.LOSS_GR_NM_EN																				AS MEASURE_GROUP_NAME
                    , A.MSR_TP_CD																					AS MEASURE
                    , A.LOSS_NM_EN																					AS MEASURE_NAME
                    , A.SORT_ORDER_NO_GR
                    , A.SORT_ORDER_NO
			        , DBO.FN_GET_DIVISION_NAME (A.DIVISION_ID)  AS DIVISION_NAME
			        , CASE WHEN A.SITE_ID       = ''*'' THEN ''*'' ELSE S.SITE_NAME END								AS SITE_NAME
			        , CASE WHEN A.PLANT_ID      = ''*'' THEN ''*'' ELSE P.PLANT_NAME END							AS PLANT_NAME
			        , CASE WHEN A.FACTORY_ID    = ''*'' THEN ''*'' ELSE F.FACTORY_NAME END							AS FACTORY_NAME
			        , CASE WHEN A.LINE_ID       = ''*'' THEN ''*'' ELSE L.LINE_NAME END								AS LINE_NAME
                    , A.BIZ_QTY
                    , A.PRE_QTY
                    ----, A.PFRSLT_QTY
                    ----, A.BASE_QTY
			        , CASE
                        WHEN A.COMPANY_ID = ''*'' AND A.MSR_TP_CD = ''SCP_PROD_PLAN'' THEN 0 --COMPANY_ID = ''*'' 이면 Total 로 판단
                        ELSE A.PFRSLT_QTY
                      END AS PFRSLT_QTY
			        , CASE
                        WHEN A.COMPANY_ID = ''*'' AND A.MSR_TP_CD = ''SCP_PROD_PLAN'' THEN 0 --COMPANY_ID = ''*'' 이면 Total 로 판단
                        ELSE A.BASE_QTY
                      END AS BASE_QTY
                    ' + @V_FINAL_COLS + N'
		    FROM    #tblSCP0107_FINAL A
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
					------LEFT JOIN #tblSCP0107_EQP E ON
					------		A.ELTR_LN_TP_CD = E.ELTR_TP_CD
					LEFT JOIN #tblSCP0104_OPERATION O ON
							A.OPERATION_ID		= O.OPERATION_ID
            WHERE   1=1
            ORDER BY  (
                        CASE
                            WHEN A.DIVISION_ID = ''*''  AND A.COMPANY_ID = ''*'' THEN ''1''
                            WHEN A.DIVISION_ID <> ''*'' AND A.COMPANY_ID = ''*'' THEN ''2''
                            ELSE ''3''
                        END
                      )
			        , A.SORT_ORDER_NO_GR
		            , A.VER_ID
				    , A.VER_SEQ
                    , A.DIVISION_ID
		            , A.COMPANY_ID
		            , A.SITE_ID
		            , A.PLANT_ID
		            , A.FACTORY_ID
		            , A.LINE_ID
		            , A.OPERATION_ID
                    ------, A.ELTR_LN_TP_CD
                    , A.SORT_ORDER_NO
                    ';

        --TESTING : OK
        --EXEC DEBUG_LOG @V_SQL, 'T';RETURN;

        EXEC(@V_SQL);
    END -- 동적쿼리 생성


	IF OBJECT_ID('tempdb..#tblSCP0104_CODE_ALL') IS NOT NULL
		DROP TABLE #tblSCP0104_CODE_ALL;
	IF OBJECT_ID('tempdb..#tblSCP0104_COMPANY') IS NOT NULL
		DROP TABLE #tblSCP0104_COMPANY;
	IF OBJECT_ID('tempdb..#tblSCP0104_FACTORY') IS NOT NULL
		DROP TABLE #tblSCP0104_FACTORY;
	IF OBJECT_ID('tempdb..#tblSCP0104_LINE') IS NOT NULL
		DROP TABLE #tblSCP0104_LINE;
	IF OBJECT_ID('tempdb..#tblSCP0104_OPERATION') IS NOT NULL
		DROP TABLE #tblSCP0104_OPERATION;
	IF OBJECT_ID('tempdb..#tblSCP0104_PLANT') IS NOT NULL
		DROP TABLE #tblSCP0104_PLANT;
	IF OBJECT_ID('tempdb..#tblSCP0104_SITE') IS NOT NULL
		DROP TABLE #tblSCP0104_SITE;
	IF OBJECT_ID('tempdb..#tblSCP0107_BIZ_PLAN') IS NOT NULL
		DROP TABLE #tblSCP0107_BIZ_PLAN;
	IF OBJECT_ID('tempdb..#tblSCP0107_DATE_COLS') IS NOT NULL
		DROP TABLE #tblSCP0107_DATE_COLS;
	IF OBJECT_ID('tempdb..#tblSCP0107_DAY_CNT') IS NOT NULL
		DROP TABLE #tblSCP0107_DAY_CNT;
	IF OBJECT_ID('tempdb..#tblSCP0107_EQP') IS NOT NULL
		DROP TABLE #tblSCP0107_EQP;
	IF OBJECT_ID('tempdb..#tblSCP0107_FINAL') IS NOT NULL
		DROP TABLE #tblSCP0107_FINAL;
	IF OBJECT_ID('tempdb..#tblSCP0107_FINAL_TEMP') IS NOT NULL
		DROP TABLE #tblSCP0107_FINAL_TEMP;
	IF OBJECT_ID('tempdb..#tblSCP0107_MEASURE') IS NOT NULL
		DROP TABLE #tblSCP0107_MEASURE;
	IF OBJECT_ID('tempdb..#tblSCP0107_MEASURE_ALL') IS NOT NULL
		DROP TABLE #tblSCP0107_MEASURE_ALL;
	IF OBJECT_ID('tempdb..#tblSCP0107_MEASURE_VISIBLE') IS NOT NULL
		DROP TABLE #tblSCP0107_MEASURE_VISIBLE;
	IF OBJECT_ID('tempdb..#tblSCP0107_OPERATION_TOTAL') IS NOT NULL
		DROP TABLE #tblSCP0107_OPERATION_TOTAL;
	IF OBJECT_ID('tempdb..#tblSCP0107_OPERATION_TOTAL_DV') IS NOT NULL
		DROP TABLE #tblSCP0107_OPERATION_TOTAL_DV;
	IF OBJECT_ID('tempdb..#tblSCP0107_PLAN_TP') IS NOT NULL
		DROP TABLE #tblSCP0107_PLAN_TP;
	IF OBJECT_ID('tempdb..#tblSCP0107_RAW') IS NOT NULL
		DROP TABLE #tblSCP0107_RAW;
	IF OBJECT_ID('tempdb..#tblSCP0107_RAW_ALL') IS NOT NULL
		DROP TABLE #tblSCP0107_RAW_ALL;
	IF OBJECT_ID('tempdb..#tblSCP0107_RAW_TEMP_ALL') IS NOT NULL
		DROP TABLE #tblSCP0107_RAW_TEMP_ALL;
	IF OBJECT_ID('tempdb..#tblSCP0107_TOTAL_KEY') IS NOT NULL
		DROP TABLE #tblSCP0107_TOTAL_KEY;
	IF OBJECT_ID('tempdb..#tblSCP0107_TOTAL_KEY_DV') IS NOT NULL
		DROP TABLE #tblSCP0107_TOTAL_KEY_DV;
	IF OBJECT_ID('tempdb..#tblSCP0107_YYYYMM_DDN') IS NOT NULL
		DROP TABLE #tblSCP0107_YYYYMM_DDN;
	IF OBJECT_ID('tempdb..#tblSCP0107_YYYYMM_DDN_DV') IS NOT NULL
		DROP TABLE #tblSCP0107_YYYYMM_DDN_DV;
END

