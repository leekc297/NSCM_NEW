
/*
 * Program ID   : SCP0095_GET_GLOBAL_PSI_ELEC
 * Description  : Global Psi Elec 조회
 * Program History
 *===================================================================================================
 * Date         In Charge		Description
 *===================================================================================================
 * 2022.11.22	jahn1501                  Initial Release
 * 2023.03.23   chaan           V1.1.2    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Original Division 추가
 * 2023.04.04   chaan           V1.1.3    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Original Division 제거(V1.1.2로 원복)
 * 2023.04.04   chaan           V1.1.4    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 속도개선
 * 2023.04.11   chaan           V1.1.5    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Sum 오류 수정
 * 2023.04.19   chaan           V1.1.6    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - COATE_REQ, SHIP_PLAN 조회 오류 수정
 * 2023.04.21   chaan           V1.1.7    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - EOH 조회 오류 수정
 *                                                                                                       - 속도개선
 *                                                                                                       - Measure 추가 : PKG Plan
 * 2023.05.04   chaan           V1.1.8    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - EOH 조회 오류 수정
 *                                                                                                       - 선행수치 오류 수정
 *                                                                                                       - Measure -> PKG_PLAN 추가
 *                                                                                                       - COAT_REQ ROW_NUM, NUM 기준에 MEASURE 추가!!!
 * 2023.05.16   chaan           V1.1.9    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 선행수치 로직 적용
 * 2023.05.24   chaan           V1.1.10   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 조회시 중복 로직 제거로 속도개선
 * 2023.06.01   chaan           V1.1.11   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - EOH 로직 수정
 * 2023.07.14   chaan           V1.1.12   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 예외처리
 *                                                                                                      - plan_type 적용
 * 2023.08.01   chaan           V1.1.13   PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2           - EOH 로직 오류 수정
 * 2024-01-08   chaan           V1.1.14   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선
 */
 CREATE PROCEDURE [dbo].[SCP0095_GET_GLOBAL_PSI_ELEC]
--CREATE PROCEDURE [dbo].[SCP0095_GET_GLOBAL_PSI_ELEC]
	@p_division_id			NVARCHAR(50),
	@p_company				NVARCHAR(50),
	@p_item_id				NVARCHAR(MAX)		= '',
	@p_yyyymmdd				NVARCHAR(10),
	@p_from_yyyymmdd		NVARCHAR(8),
	@p_to_yyyymmdd			NVARCHAR(8),
	@p_plan_type			NVARCHAR(50)        = '',-- 'MA' : 수요일 09시 기준 생성, 'FN' : 금요일 09시 기준 생성, 금요일은 'FN' 기준, 수요일은 사업부, 계획/재고에 따라 다름
	@p_program_id			NVARCHAR(300)		= 'SCP0095',
	@p_sheet_name			NVARCHAR(150)		= 'Global PSI Elec',
	@p_user_id				NVARCHAR(300)		= '',
	@debug_mode				NVARCHAR(1)			= 'F'
AS
BEGIN
	SET NOCOUNT OFF;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--DECLARE @p_division_id			NVARCHAR(50)        = 'EE';
	--DECLARE @p_company				NVARCHAR(50)        = '';
	--DECLARE @p_item_id				NVARCHAR(MAX)       = 'APCCA2481A';
	--DECLARE @p_yyyymmdd				NVARCHAR(10)        = '20230724';
	--DECLARE @p_from_yyyymmdd		NVARCHAR(8)         = '20230724';
	--DECLARE @p_to_yyyymmdd			NVARCHAR(8)         = '20230725';
	--DECLARE @p_plan_type			NVARCHAR(50)        = 'FN';
	--DECLARE @p_program_id			NVARCHAR(300)       = 'SCP0095';
	--DECLARE @p_sheet_name			NVARCHAR(150)       = 'Global PSI Elec';
	--DECLARE @p_user_id				NVARCHAR(300)       = 'iamarock';
	--DECLARE @debug_mode				NVARCHAR(1)         = 'F'


    DECLARE @v_log_type     NVARCHAR(30);
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

    
    DECLARE @V_ELAPSED_TIME             DATETIME            = CURRENT_TIMESTAMP;
    DECLARE @V_TOTAL_ELAPSED_TIME       DATETIME            = @V_ELAPSED_TIME;
     
    DECLARE @v_plan_cycle               NVARCHAR(30)        = N'WEEKLY';
    DECLARE @v_plan_to_yyyymmdd_limit   VARCHAR(8)          = '';


    -- 1년뒤 데이터에 누적된 데이터 있어서 1년 초과 기간은 집계 대상에서 제외
    SELECT  @v_plan_to_yyyymmdd_limit = MAX(HORIZON_END_DATE)
    FROM    dbo.SCM_MST_PLAN WITH(NOLOCK)
    WHERE   1=1
        AND PLAN_NAME   = @p_yyyymmdd
        AND PLAN_CYCLE  = @v_plan_cycle

    PRINT CONCAT('@v_plan_to_yyyymmdd_limit : ', @v_plan_to_yyyymmdd_limit)


	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type			= 'START';
		SET @v_log_message		= '########## Start of procedure ##########';
		SET @v_description		= '';
		SET @d_event_date		= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @p_program_id, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	    /********************************************************************************
	    * 임시테이블만들기
	    ********************************************************************************/
	    IF OBJECT_ID('tempdb..#T_SCP0095_MEASURE') IS NOT NULL
		    DROP TABLE #T_SCP0095_MEASURE;
    
        SELECT  A.*
        INTO    #T_SCP0095_MEASURE
        FROM    (
                    SELECT	  B.PROGRAM_ID
		                    , B.SHEET_NAME
		                    , B.COLUMN_NAME
		                    , B.COLUMN_LABEL_NAME
		                    , B.SMALL_CLASS_LABEL_NAME
		                    , B.LARGE_CLASS_LABEL_NAME
		                    , U.DATA_SORT_METHOD_CODE
		                    , B.SORT_ORDER_NO
		                    , NULL                                      AS SUB_TOTAL_FLAG
		                    , NULL                                      AS USER_SORT_METHOD_CODE
		                    , U.SORT_ORDER_NO                           AS USER_SORT_ORDER_NO
		                    , B.USER_SELECTABLE_FLAG
		                    , CASE ISNULL(U.COLUMN_NAME,'@@')
			                    WHEN '@@' THEN 'N'
			                    ELSE 'Y'
		                      END										AS USER_FLAG
		                    , dbo.FN_SCM_SYS_NVL(B.DEFAULT_FLAG, 'N')	AS DEFAULT_FLAG
		                    , 'N'										AS TOTAL_USE_FLAG
                    FROM	dbo.SCM_MST_SHEET_MEASURE B WITH(NOLOCK)
		                    LEFT OUTER JOIN dbo.SCM_MST_TITLESET_USER U  WITH(NOLOCK) ON
				                    U.PROGRAM_ID	= B.PROGRAM_ID
			                    AND U.SHEET_NAME	= B.SHEET_NAME
			                    AND U.COLUMN_NAME	= B.COLUMN_NAME
			                    AND U.USER_ID		= @p_user_id
                    WHERE	1=1
	                    AND B.PROGRAM_ID	= @p_program_id
	                    AND B.SHEET_NAME    = @p_sheet_name
	                    AND B.VALID_YN		= 'Y'
                ) A
        WHERE   A.USER_FLAG = 'Y'
    
--2023.12.10 인덱스 검토필요
        CREATE CLUSTERED INDEX IDX_T_SCP0095_MEASURE ON #T_SCP0095_MEASURE (COLUMN_NAME);


        --SUM measure 는 사용자 지정 Measure 에 없으므로 강제로 넣어줌
        INSERT INTO #T_SCP0095_MEASURE
        (
		    PROGRAM_ID,
		    SHEET_NAME,
		    COLUMN_NAME,
		    COLUMN_LABEL_NAME,
		    SMALL_CLASS_LABEL_NAME,
		    LARGE_CLASS_LABEL_NAME,
		    DATA_SORT_METHOD_CODE,
		    SORT_ORDER_NO,
		    SUB_TOTAL_FLAG,
		    USER_SORT_METHOD_CODE,
		    USER_SORT_ORDER_NO,
		    USER_SELECTABLE_FLAG,
		    USER_FLAG,
		    DEFAULT_FLAG,
		    TOTAL_USE_FLAG
        )
        VALUES
        (
            'SCP0095',
		    'Global PSI Elec',
		    'SUM',
		    'SUM',
		    '',
		    '',
		    '',
		    '2',
		    NULL,
		    NULL,
		    '10',
		    'Y',
		    'Y',
		    'Y',
		    'N'
        )

    --TESTING : OK
    --select * from #T_SCP0095_MEASURE;return;

	    IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_PIVOT') IS NOT NULL
		    DROP TABLE #T_SCP0095_ELEC_PIVOT;

	    CREATE TABLE #T_SCP0095_ELEC_PIVOT
	    (
		      DIVISION_ID		NVARCHAR(30)
		    , COMPANY_ID		NVARCHAR(30)
		    , PLANT_ID  		NVARCHAR(150)
		    , PSI				NVARCHAR(1)
		    , ELEC_MODEL		NVARCHAR(150)
		    , CELL_MODEL		NVARCHAR(150)
		    , ELECTRODE_TYPE	NVARCHAR(30)
		    , FROM_SITE			NVARCHAR(150)
		    , TO_SITE			NVARCHAR(150)
		    , UNIT				NVARCHAR(50)
		    , YYYYMMDD			NVARCHAR(20)
		    , MEASURE			NVARCHAR(150)
		    , MEASURE_NAME		NVARCHAR(150)
		    , SORT_ORDER_NO		NVARCHAR(10)
		    , VALUE1			NUMERIC(20,2)
		    , VALUE2			NUMERIC(20,2)
		    , QTY				NUMERIC(20,2)
		    , W_QTY				NUMERIC(20,2)
		    , M_QTY				NUMERIC(20,2)
		    , YYYYMM			NVARCHAR(6)
		    , ISO_WEEK		    NVARCHAR(8)
    	    , GROUP_NUM		    INT
	        , NUM			    INT
	    )

-- 2023.12.10 천승호
        --CREATE CLUSTERED INDEX IDX_T_SCP0095_ELEC_PIVOT ON #T_SCP0095_ELEC_PIVOT (DIVISION_ID, COMPANY_ID, ELEC_MODEL, CELL_MODEL, YYYYMMDD);
--        CREATE CLUSTERED INDEX IDX_T_SCP0095_ELEC_PIVOT ON #T_SCP0095_ELEC_PIVOT (MEASURE_NAME, PSI);

CREATE    CLUSTERED INDEX IDX01_T_SCP0095_ELEC_PIVOT ON [dbo].[#T_SCP0095_ELEC_PIVOT] ([PSI],[MEASURE],[DIVISION_ID],[COMPANY_ID],[ELEC_MODEL],[YYYYMMDD],[SORT_ORDER_NO],[QTY],[YYYYMM],[ISO_WEEK]);
--CREATE NONCLUSTERED INDEX IDX01_T_SCP0095_ELEC_PIVOT ON [dbo].[#T_SCP0095_ELEC_PIVOT] ([PSI],[MEASURE]) INCLUDE ([DIVISION_ID],[COMPANY_ID],[ELEC_MODEL],[YYYYMMDD],[SORT_ORDER_NO],[QTY],[YYYYMM],[ISO_WEEK]);

--CREATE NONCLUSTERED INDEX IDX02_T_SCP0095_ELEC_PIVOT ON [dbo].[#T_SCP0095_ELEC_PIVOT] ([PSI],[MEASURE]) INCLUDE ([DIVISION_ID],[COMPANY_ID],[ELEC_MODEL],[CELL_MODEL],[YYYYMMDD],[MEASURE_NAME]);
--CREATE NONCLUSTERED INDEX IDX03_T_SCP0095_ELEC_PIVOT ON [dbo].[#T_SCP0095_ELEC_PIVOT] ([MEASURE]) INCLUDE ([DIVISION_ID],[COMPANY_ID],[PSI],[ELEC_MODEL],[CELL_MODEL],[YYYYMMDD],[MEASURE_NAME],[QTY]);
--CREATE NONCLUSTERED INDEX IDX04_T_SCP0095_ELEC_PIVOT ON [dbo].[#T_SCP0095_ELEC_PIVOT] ([PSI],[MEASURE]) INCLUDE ([DIVISION_ID],[COMPANY_ID],[PLANT_ID],[ELEC_MODEL],[CELL_MODEL],[ELECTRODE_TYPE],[FROM_SITE],[TO_SITE],[UNIT],[YYYYMMDD],[MEASURE_NAME],[SORT_ORDER_NO],[VALUE1],[VALUE2],[QTY],[W_QTY],[M_QTY],[YYYYMM],[ISO_WEEK]);

--CREATE NONCLUSTERED INDEX IDX06_T_SCP0095_ELEC_PIVOT ON [dbo].[#T_SCP0095_ELEC_PIVOT] ([MEASURE_NAME]) INCLUDE ([DIVISION_ID],[COMPANY_ID],[PSI],[ELEC_MODEL],[YYYYMMDD],[VALUE1],[VALUE2],[QTY],[YYYYMM]);
--CREATE NONCLUSTERED INDEX IDX07_T_SCP0095_ELEC_PIVOT ON [dbo].[#T_SCP0095_ELEC_PIVOT] ([MEASURE_NAME]) INCLUDE ([DIVISION_ID],[COMPANY_ID],[ELEC_MODEL],[CELL_MODEL],[YYYYMMDD],[QTY],[W_QTY],[M_QTY]);
--CREATE NONCLUSTERED INDEX IDX08_T_SCP0095_ELEC_PIVOT ON [dbo].[#T_SCP0095_ELEC_PIVOT] ([MEASURE]) INCLUDE ([DIVISION_ID],[COMPANY_ID],[PSI],[ELEC_MODEL],[CELL_MODEL],[YYYYMMDD],[QTY],[W_QTY]);
--CREATE NONCLUSTERED INDEX IDX09_T_SCP0095_ELEC_PIVOT ON [dbo].[#T_SCP0095_ELEC_PIVOT] ([MEASURE_NAME]) INCLUDE ([ELEC_MODEL],[CELL_MODEL]);

--CREATE NONCLUSTERED INDEX IDX10_T_SCP0095_ELEC_PIVOT ON [dbo].[#T_SCP0095_ELEC_PIVOT] ([MEASURE_NAME]) INCLUDE ([DIVISION_ID],[COMPANY_ID],[ELEC_MODEL],[CELL_MODEL],[YYYYMMDD],[YYYYMM],[ISO_WEEK]);
--CREATE NONCLUSTERED INDEX IDX11_T_SCP0095_ELEC_PIVOT ON [dbo].[#T_SCP0095_ELEC_PIVOT] ([MEASURE]) INCLUDE ([DIVISION_ID],[COMPANY_ID],[PSI],[ELEC_MODEL],[CELL_MODEL],[YYYYMMDD],[QTY],[M_QTY]);


	    --최신 시퀀스 조회
	    DECLARE @v_creation_seq	INT = 0

        SELECT  @v_creation_seq     = MAX(CREATION_SEQ)
        FROM    dbo.SCP_RPT_ELEC_PSI WITH(NOLOCK)
        WHERE  1=1
            AND DIVISION_ID         = @p_division_id
            AND PLAN_START_YYYYMMDD = @p_yyyymmdd

	    DECLARE @v_day	INT = (SELECT DATEDIFF(DD,CONVERT(DATETIME, @p_from_yyyymmdd),CONVERT(DATETIME, @p_to_yyyymmdd)))

        print CONCAT('@v_creation_seq : ', @v_creation_seq);
        print CONCAT('@v_day : ', @v_day);
        --return;

    --TESTING : OK
    --select * from SCP_RPT_ELEC_PSI;return;
        PRINT CONCAT('ELAPSED_TIME0-1 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;
    
        -- @p_to_yyyymmdd 로 제한하기 전 데이터가 있어야 LT_DAY 를 적용할 수 있음!!!!
	    IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_RAW_ALL') IS NOT NULL
		    DROP TABLE #T_SCP0095_ELEC_RAW_ALL;

        SELECT    A.*
                , 0 AS W_QTY
                , 0 AS M_QTY
                , O.BASIS_YYYYMM AS YYYYMM
                , RIGHT(O.BASIS_YYYYMM, 4) + O.ISO_WEEK AS ISO_WEEK
        INTO    #T_SCP0095_ELEC_RAW_ALL
        FROM    dbo.SCP_RPT_ELEC_PSI A WITH(NOLOCK)
                JOIN dbo.SCM_SYS_CALENDAR_M O ON
                        A.YYYYMMDD = O.BASIS_YYYYMMDD
                WHERE   1=1
                    AND A.DIVISION_ID           = @p_division_id
                    AND ((@p_item_id IS NULL OR @p_item_id = '') OR A.ELEC_MODEL IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id, ',')))
                    AND ((@p_company IS NULL OR @p_company = '') OR A.COMPANY_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_company, ',')))
                    AND A.PLAN_START_YYYYMMDD   = @p_yyyymmdd
                    AND A.CREATION_SEQ          = @v_creation_seq
                    AND A.YYYYMMDD              >= @p_from_yyyymmdd
                    AND A.YYYYMMDD              <= @v_plan_to_yyyymmdd_limit
                    AND A.PLAN_TYPE             = @p_plan_type

--2023.12.10 인덱스 검토필요
	    CREATE CLUSTERED INDEX IDX_T_SCP0095_ELEC_RAW_ALL ON #T_SCP0095_ELEC_RAW_ALL (MEASURE);

    
        PRINT CONCAT('ELAPSED_TIME0-2 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;

	    IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_RAW') IS NOT NULL
		    DROP TABLE #T_SCP0095_ELEC_RAW;

        SELECT  A.*
        INTO    #T_SCP0095_ELEC_RAW
        FROM    #T_SCP0095_ELEC_RAW_ALL A
        WHERE   1=1
            AND A.YYYYMMDD              <= @p_to_yyyymmdd

--2023.12.10 인덱스 검토필요
	    CREATE CLUSTERED INDEX IDX_T_SCP0095_ELEC_RAW ON #T_SCP0095_ELEC_RAW (MEASURE);


	    IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_DATA') IS NOT NULL
		    DROP TABLE #T_SCP0095_ELEC_DATA;

        SELECT    A.DIVISION_ID
                , A.COMPANY_ID
                , A.PLANT_ID
                , A.PSI
                , A.ELEC_MODEL
                , A.CELL_MODEL
                , A.ELECTRODE_TYPE
                , A.FROM_SITE
                , A.TO_SITE
                , A.UNIT
                , 'D_'+ A.YYYYMMDD      AS YYYYMMDD
                , A.MEASURE
                , B.COLUMN_LABEL_NAME   AS MEASURE_NAME
                , B.SORT_ORDER_NO
                , A.VALUE1
                , A.VALUE2
                , A.QTY
                , A.W_QTY
                , A.M_QTY
                , A.YYYYMM
                , A.ISO_WEEK
			    , DENSE_RANK() OVER (ORDER BY A.DIVISION_ID, A.COMPANY_ID, A.ELEC_MODEL, A.MEASURE)                                    AS GROUP_NUM
			    , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.COMPANY_ID, A.ELEC_MODEL, A.MEASURE ORDER BY A.YYYYMMDD )           AS NUM
        INTO    #T_SCP0095_ELEC_DATA
        FROM    #T_SCP0095_ELEC_RAW A
                JOIN SCM_MST_SHEET_MEASURE B ON
                        A.MEASURE       = B.COLUMN_NAME
                    AND B.PROGRAM_ID    = @p_program_id
                    AND B.SHEET_NAME    = @p_sheet_name
        WHERE   1=1
            AND A.MEASURE <> 'EOH' --밑에 EOH 로 추가하므로 SUM 추가 제외.

--2023.12.10 인덱스 검토필요
	    CREATE CLUSTERED INDEX IDX_T_SCP0095_ELEC_DATA ON #T_SCP0095_ELEC_DATA (MEASURE);

        PRINT CONCAT('ELAPSED_TIME0-3 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;

	    IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_DATA_ALL') IS NOT NULL
		    DROP TABLE #T_SCP0095_ELEC_DATA_ALL;

        SELECT    A.DIVISION_ID
                , A.COMPANY_ID
                , A.PLANT_ID
                , A.PSI
                , A.ELEC_MODEL
                , A.CELL_MODEL
                , A.ELECTRODE_TYPE
                , A.FROM_SITE
                , A.TO_SITE
                , A.UNIT
                , 'D_'+ A.YYYYMMDD      AS YYYYMMDD
                , A.MEASURE
                , B.COLUMN_LABEL_NAME   AS MEASURE_NAME
                , B.SORT_ORDER_NO
                , A.VALUE1
                , A.VALUE2
                , A.QTY
                , A.W_QTY
                , A.M_QTY
                , A.YYYYMM
                , A.ISO_WEEK
			    , DENSE_RANK() OVER (ORDER BY A.DIVISION_ID, A.COMPANY_ID, A.ELEC_MODEL, A.MEASURE)                                    AS GROUP_NUM
			    , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.COMPANY_ID, A.ELEC_MODEL, A.MEASURE ORDER BY A.YYYYMMDD )           AS NUM
        INTO    #T_SCP0095_ELEC_DATA_ALL
        FROM    #T_SCP0095_ELEC_RAW_ALL A
                JOIN SCM_MST_SHEET_MEASURE B ON
                        A.MEASURE       = B.COLUMN_NAME
                    AND B.PROGRAM_ID    = @p_program_id
                    AND B.SHEET_NAME    = @p_sheet_name
        WHERE   1=1
            AND A.MEASURE <> 'EOH' --밑에 EOH 로 추가하므로 SUM 추가 제외.

--2023.12.10 인덱스 검토필요
	    CREATE CLUSTERED INDEX IDX_T_SCP0095_ELEC_DATA_ALL ON #T_SCP0095_ELEC_DATA_ALL (MEASURE, PSI);

        PRINT CONCAT('ELAPSED_TIME0-4 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;
    --TESTING : OK
    --select * from #T_SCP0095_ELEC_RAW_ALL;
    --select * from #T_SCP0095_ELEC_DATA_ALL;return;

	    INSERT INTO #T_SCP0095_ELEC_PIVOT
	    SELECT	*
	    FROM	#T_SCP0095_ELEC_DATA
        WHERE   1=1
            --AND MEASURE <> 'PKG_PLAN' --밑에 PKG_PLAN 로 추가하므로 제외.


	    /********************************************************************************
	    * PKG_PLAN
	    ********************************************************************************/
	    --IF OBJECT_ID('tempdb..#T_SCP0095_PKG_PLAN') IS NOT NULL
	    --	DROP TABLE #T_SCP0095_PKG_PLAN;

     --   DECLARE @V_MEASURE_NAME		NVARCHAR(150)   = '';
     --   DECLARE @V_SORT_ORDER_NO	NVARCHAR(10)    = '';

     --   SELECT    @V_MEASURE_NAME   = COLUMN_LABEL_NAME
     --           , @V_SORT_ORDER_NO  = SORT_ORDER_NO
     --   FROM    SCM_MST_SHEET_MEASURE
     --   WHERE   1=1
     --       AND COLUMN_NAME     = 'PKG_PLAN'
     --       AND PROGRAM_ID    = @p_program_id
     --       AND SHEET_NAME    = @p_sheet_name
    
     --   SELECT    A.DIVISION_ID
	    --	    , A.COMPANY_ID
     --           , A.PLANT_ID
	    --	    , A.PSI
	    --	    , A.ELEC_MODEL
	    --	    , A.CELL_MODEL
	    --	    , A.ELECTRODE_TYPE
	    --	    , A.FROM_SITE
	    --	    , A.TO_SITE
	    --	    , A.UNIT
	    --	    , A.YYYYMMDD
	    --	    , A.MEASURE
	    --	    , @V_MEASURE_NAME       AS MEASURE_NAME
	    --	    , @V_SORT_ORDER_NO      AS SORT_ORDER_NO
	    --	    , A.VALUE1
	    --	    , A.VALUE2
	    --	    , A.QTY
	    --	    , A.W_QTY
	    --	    , A.M_QTY
	    --	    , A.YYYYMM
	    --	    , A.ISO_WEEK
	    --		, DENSE_RANK() OVER (ORDER BY A.COMPANY_ID, A.ELEC_MODEL)                                                   AS GROUP_NUM
	    --		, ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.COMPANY_ID, A.ELEC_MODEL ORDER BY A.YYYYMMDD )           AS NUM
     --   INTO    #T_SCP0095_PKG_PLAN
     --   FROM    #T_SCP0095_ELEC_DATA A
     --   WHERE   MEASURE = 'PKG_PLAN'

    --TESTING : OK
    --select * from #T_SCP0095_PKG_PLAN;return;
    --select * from #T_SCP0095_ELEC_PIVOT;return;

	    --INSERT INTO #T_SCP0095_ELEC_PIVOT
	    --SELECT	*
	    --FROM	#T_SCP0095_PKG_PLAN

    --select * from #T_SCP0095_ELEC_PIVOT;return;

        PRINT CONCAT('ELAPSED_TIME0 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;

        BEGIN /* LT_DAY 만큼 선행값 적용 begin ****************************************************************************************************************************************/
            -- 1. 각 날짜에 해당하는 선행시작일자, 종료일자 구한다(SUM용)
	        IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_LT_RAW') IS NOT NULL
		        DROP TABLE #T_SCP0095_ELEC_LT_RAW;
    
	        SELECT	  A.DIVISION_ID
				    , A.COMPANY_ID
				    , A.PLANT_ID
				    , A.PSI
				    , A.ELEC_MODEL
				    , A.CELL_MODEL
				    , A.ELECTRODE_TYPE
				    , A.FROM_SITE
				    , A.TO_SITE
				    , A.UNIT
				    , A.YYYYMMDD
				    , A.MEASURE
				    , A.MEASURE_NAME
				    , A.SORT_ORDER_NO
				    , A.VALUE1
				    , A.VALUE2
				    , A.QTY
				    , A.W_QTY
				    , A.M_QTY
				    , A.YYYYMM
				    , A.ISO_WEEK
			        , ISNULL(B.LT_DAY, 1)                                                                                           AS LT_DAY
                    , SUBSTRING(A.YYYYMMDD,3, 8)                                                                                    AS CURR_YYYYMMDD
                    , CONVERT(VARCHAR(8), DATEADD(DAY, ISNULL(B.LT_DAY, 1)-1, CONVERT(DATE, SUBSTRING(A.YYYYMMDD,3, 8))), 112)      AS LT_END_YYYYMMDD
			        , DENSE_RANK() OVER (ORDER BY A.DIVISION_ID, A.COMPANY_ID, A.ELEC_MODEL, A.CELL_MODEL)                          AS GROUP_NUM
			        , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.COMPANY_ID, A.ELEC_MODEL, A.CELL_MODEL ORDER BY A.YYYYMMDD)  AS NUM
            INTO    #T_SCP0095_ELEC_LT_RAW
	        FROM	(
                        SELECT  *
                        FROM    #T_SCP0095_ELEC_PIVOT A
                        WHERE   1=1
                            AND A.MEASURE = 'COAT_REQ'
                            AND A.PSI     = 'S'
                            --AND A.QTY     <> 0
                    ) A
			        LEFT JOIN	(
						            SELECT    A.ITEM_ID
								            , A.LT_DAY
                                            , B.COMPANY_ID
                                            , B.PLANT_ID
						            FROM	dbo.SCP_MST_OPERATION_LT A WITH(NOLOCK)
                                            JOIN SCM_MST_SITE B ON
                                                    A.DIVISION_ID = B.DIVISION_ID
                                                AND A.SCM_SITE_ID = B.SCM_SITE_ID
						            WHERE	A.LT_OPERATION = 'CTP_LT'
					           ) B ON
					                A.CELL_MODEL = B.ITEM_ID
			                    AND A.COMPANY_ID = B.COMPANY_ID
			                    AND A.PLANT_ID   = B.PLANT_ID

--2023.12.10 인덱스 검토필요
            CREATE CLUSTERED INDEX IDX_T_SCP0095_ELEC_LT_RAW ON #T_SCP0095_ELEC_LT_RAW (NUM);


	        IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_LT_RAW_ALL') IS NOT NULL
		        DROP TABLE #T_SCP0095_ELEC_LT_RAW_ALL;
    
	        SELECT	  A.DIVISION_ID
				    , A.COMPANY_ID
				    , A.PLANT_ID
				    , A.PSI
				    , A.ELEC_MODEL
				    , A.CELL_MODEL
				    , A.ELECTRODE_TYPE
				    , A.FROM_SITE
				    , A.TO_SITE
				    , A.UNIT
				    , A.YYYYMMDD
				    , A.MEASURE
				    , A.MEASURE_NAME
				    , A.SORT_ORDER_NO
				    , A.VALUE1
				    , A.VALUE2
				    , A.QTY
				    , A.W_QTY
				    , A.M_QTY
				    , A.YYYYMM
				    , A.ISO_WEEK
			        , ISNULL(B.LT_DAY, 1)                                                                                           AS LT_DAY
                    , SUBSTRING(A.YYYYMMDD,3, 8)                                                                                    AS CURR_YYYYMMDD
                    , CONVERT(VARCHAR(8), DATEADD(DAY, ISNULL(B.LT_DAY, 1)-1, CONVERT(DATE, SUBSTRING(A.YYYYMMDD,3, 8))), 112)      AS LT_END_YYYYMMDD
			        , DENSE_RANK() OVER (ORDER BY A.DIVISION_ID, A.COMPANY_ID, A.ELEC_MODEL, A.CELL_MODEL)                          AS GROUP_NUM
			        , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.COMPANY_ID, A.ELEC_MODEL, A.CELL_MODEL ORDER BY A.YYYYMMDD) AS NUM
            INTO    #T_SCP0095_ELEC_LT_RAW_ALL
	        FROM	(
                        SELECT  *
                        FROM    #T_SCP0095_ELEC_DATA_ALL A
                        WHERE   1=1
                            AND A.MEASURE = 'COAT_REQ'
                            AND A.PSI     = 'S'
                            --AND A.QTY     <> 0
                    ) A
			        LEFT JOIN	(
						            SELECT    A.ITEM_ID
								            , A.LT_DAY
                                            , B.COMPANY_ID
                                            , B.PLANT_ID
						            FROM	dbo.SCP_MST_OPERATION_LT A WITH(NOLOCK)
                                            JOIN SCM_MST_SITE B ON
                                                    A.DIVISION_ID = B.DIVISION_ID
                                                AND A.SCM_SITE_ID = B.SCM_SITE_ID
						            WHERE	A.LT_OPERATION = 'CTP_LT'
					           ) B ON
					                A.CELL_MODEL = B.ITEM_ID
			                    AND A.COMPANY_ID = B.COMPANY_ID
			                    AND A.PLANT_ID   = B.PLANT_ID


-- 2023.12.10 천승호
--            CREATE CLUSTERED INDEX IDX_T_SCP0095_ELEC_LT_RAW_ALL ON #T_SCP0095_ELEC_LT_RAW_ALL (NUM);

CREATE CLUSTERED INDEX IDX01_T_SCP0095_ELEC_LT_RAW_ALL ON [dbo].[#T_SCP0095_ELEC_LT_RAW_ALL] ([DIVISION_ID],[COMPANY_ID],[ELEC_MODEL],[CELL_MODEL],[CURR_YYYYMMDD],[QTY]);
CREATE NONCLUSTERED INDEX IDX02_T_SCP0095_ELEC_LT_RAW_ALL ON [dbo].[#T_SCP0095_ELEC_LT_RAW_ALL] ([QTY],[DIVISION_ID],[COMPANY_ID],[ELEC_MODEL],[CELL_MODEL],[CURR_YYYYMMDD]);


    --TESTING : OK
    --select * from #T_SCP0095_ELEC_LT_RAW;return;
    --select * from #T_SCP0095_ELEC_LT_RAW WHERE NUM = 1;--return;

            -- 2. 첫째날 LT 데이터 산출
	        IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_LT_FIRST') IS NOT NULL
		        DROP TABLE #T_SCP0095_ELEC_LT_FIRST;
        
	        SELECT	  A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.ELEC_MODEL
			        , A.CELL_MODEL
                    , A.CURR_YYYYMMDD
                    , B.QTY
            INTO    #T_SCP0095_ELEC_LT_FIRST
            FROM    (
	                    SELECT	  A.DIVISION_ID
			                    , A.COMPANY_ID
			                    , A.ELEC_MODEL
            			        , A.CELL_MODEL
                                , A.CURR_YYYYMMDD
                        FROM    #T_SCP0095_ELEC_LT_RAW A
                        WHERE   1=1
                            AND A.NUM = 1
                    ) A
                    JOIN
                    (
                        SELECT	  A.DIVISION_ID
		                        , A.COMPANY_ID
		                        , A.ELEC_MODEL
                                , A.CELL_MODEL
                                , SUM(B.QTY)  AS QTY
                        FROM    (
                                    SELECT	  A.DIVISION_ID
		                                    , A.COMPANY_ID
		                                    , A.ELEC_MODEL
                                            , A.CELL_MODEL
                                            , A.CURR_YYYYMMDD
                                            , LT_END_YYYYMMDD
                                    FROM    #T_SCP0095_ELEC_LT_RAW_ALL A
                                    WHERE   1=1
                                        AND NUM = 1
                                ) A
                                LEFT JOIN #T_SCP0095_ELEC_LT_RAW_ALL B ON
				                        A.DIVISION_ID	  = B.DIVISION_ID
			                        AND A.COMPANY_ID	  = B.COMPANY_ID
			                        AND A.ELEC_MODEL	  = B.ELEC_MODEL
			                        AND A.CELL_MODEL	  = B.CELL_MODEL
	                                AND B.CURR_YYYYMMDD   >= A.CURR_YYYYMMDD
	                                AND B.CURR_YYYYMMDD   <= A.LT_END_YYYYMMDD
                        GROUP BY  A.DIVISION_ID
		                        , A.COMPANY_ID
		                        , A.ELEC_MODEL
                                , A.CELL_MODEL
                    ) B ON
                            A.DIVISION_ID = B.DIVISION_ID
			            AND A.COMPANY_ID  = B.COMPANY_ID
			            AND A.ELEC_MODEL  = B.ELEC_MODEL
				        AND A.CELL_MODEL  = B.CELL_MODEL

    --TESTING : NOK
    --select * from #T_SCP0095_ELEC_LT_RAW;
    --select * from #T_SCP0095_ELEC_LT_FIRST;return;
    --        SELECT  A.*
    --	    FROM	#T_SCP0095_ELEC_PIVOT A
    --			    JOIN #T_SCP0095_ELEC_LT_FIRST B ON
    --					    A.DIVISION_ID	    = B.DIVISION_ID
    --				    AND A.COMPANY_ID	    = B.COMPANY_ID
    --				    AND A.ELEC_MODEL	    = B.ELEC_MODEL
    --	    WHERE	1=1
    --            AND A.MEASURE = 'COAT_REQ'
    --		    AND A.PSI     = 'S'
    --            AND A.NUM     = 1 -- ELEC_MODEL별 첫째날 찾는 로직
    --RETURN;
    --select * from #T_SCP0095_ELEC_LT_RAW;return;

            -- 3. 둘째날부터 LT 데이터 산출
	        IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_LT_ETC') IS NOT NULL
		        DROP TABLE #T_SCP0095_ELEC_LT_ETC;

	        SELECT	  A.DIVISION_ID
			        , A.COMPANY_ID
			        , A.ELEC_MODEL
            	    , A.CELL_MODEL
                    , A.CURR_YYYYMMDD
                    , A.LT_END_YYYYMMDD
                    , B.QTY
            INTO    #T_SCP0095_ELEC_LT_ETC
            FROM    (
	                    SELECT DISTINCT
                                  A.DIVISION_ID
			                    , A.COMPANY_ID
			                    , A.ELEC_MODEL
            			        , A.CELL_MODEL
                                , A.CURR_YYYYMMDD
                                , A.LT_END_YYYYMMDD
                        FROM    #T_SCP0095_ELEC_LT_RAW A
                        WHERE   1=1
                            AND A.NUM > 1
                    ) A
                    LEFT JOIN #T_SCP0095_ELEC_LT_RAW_ALL B ON
					        A.DIVISION_ID	    = B.DIVISION_ID
				        AND A.COMPANY_ID	    = B.COMPANY_ID
				        AND A.ELEC_MODEL	    = B.ELEC_MODEL
				        AND A.CELL_MODEL	    = B.CELL_MODEL
				        AND A.LT_END_YYYYMMDD   = B.CURR_YYYYMMDD
            WHERE   1=1
                AND B.QTY IS NOT NULL

    --TESTING : NOK
    --select * from #T_SCP0095_ELEC_LT_RAW;
    --select * from #T_SCP0095_ELEC_LT_FIRST;
    --select * from #T_SCP0095_ELEC_LT_ETC;return;

            ----------------------------LT 데이터 적용-------------------------------------------
             --4. 오리지널 데이터의 첫째날 QTY 를 SUM_LT_QTY 로 변경(첫째날포함 + 선행일수까지의 QTY 누적 => ex)선행일수가 4일떄, 10, 20, 30, 40 이면 10+20+30+40)
	        UPDATE A
	        SET
		        A.QTY = B.QTY
	        FROM	#T_SCP0095_ELEC_PIVOT A
			        JOIN #T_SCP0095_ELEC_LT_FIRST B ON
					        A.DIVISION_ID	            = B.DIVISION_ID
				        AND A.COMPANY_ID	            = B.COMPANY_ID
				        AND A.ELEC_MODEL	            = B.ELEC_MODEL
				        AND A.CELL_MODEL	            = B.CELL_MODEL
				        AND SUBSTRING(A.YYYYMMDD,3, 8)	= B.CURR_YYYYMMDD
	        WHERE	1=1
                AND A.MEASURE = 'COAT_REQ'
		        AND A.PSI     = 'S'

    --        SELECT    SUBSTRING(A.YYYYMMDD,3, 8) AS YYYYMMDD
    --                , B.CURR_YYYYMMDD
    --	    FROM	#T_SCP0095_ELEC_PIVOT A
    --			    JOIN #T_SCP0095_ELEC_LT_FIRST B ON
    --					    A.DIVISION_ID	    = B.DIVISION_ID
    --				    AND A.COMPANY_ID	    = B.COMPANY_ID
    --				    AND A.ELEC_MODEL	    = B.ELEC_MODEL
    --				    AND SUBSTRING(A.YYYYMMDD,3, 8)	= B.CURR_YYYYMMDD
    --	    WHERE	1=1
    --            AND A.MEASURE = 'COAT_REQ'
    --		    AND A.PSI     = 'S'
    --RETURN;
            -- 5. 오리지널 데이터의 둘째날부터는 선행일수 후의 QTY 를 적용(ex)선행일수가 4일때, 10, 20, 30, 40 이면 40)
	        UPDATE A
	        SET
		        A.QTY = B.QTY
	        FROM	#T_SCP0095_ELEC_PIVOT A
			        JOIN #T_SCP0095_ELEC_LT_ETC B ON
					        A.DIVISION_ID	            = B.DIVISION_ID
				        AND A.COMPANY_ID	            = B.COMPANY_ID
				        AND A.ELEC_MODEL	            = B.ELEC_MODEL
				        AND A.CELL_MODEL	            = B.CELL_MODEL
				        AND SUBSTRING(A.YYYYMMDD,3, 8)	= B.CURR_YYYYMMDD
	        WHERE	1=1
                AND A.MEASURE = 'COAT_REQ'
		        AND A.PSI     = 'S'

    --        SELECT    A.*
    --                , B.LT_END_YYYYMMDD
    --                , B.QTY AS END_QTY
    --	    FROM	#T_SCP0095_ELEC_PIVOT A
    --			    JOIN #T_SCP0095_ELEC_LT_ETC B ON
    --					    A.DIVISION_ID	            = B.DIVISION_ID
    --				    AND A.COMPANY_ID	            = B.COMPANY_ID
    --				    AND A.ELEC_MODEL	            = B.ELEC_MODEL
    --				    AND A.CELL_MODEL	            = B.CELL_MODEL
    --				    AND SUBSTRING(A.YYYYMMDD,3, 8)	= B.CURR_YYYYMMDD
    --	    WHERE	1=1
    --            AND A.MEASURE = 'COAT_REQ'
    --		    AND A.PSI     = 'S'
    --        ORDER BY NUM
    --RETURN;
    --select  * 
    --from    #T_SCP0095_ELEC_PIVOT
    --WHERE   1=1
    --    AND MEASURE = 'COAT_REQ'
    --	AND PSI   = 'S'
    --return;
    --select  * 
    --from    #T_SCP0095_ELEC_PIVOT
    --WHERE   1=1
    --    AND MEASURE_NAME = 'SUM'
    --return;

            PRINT CONCAT('ELAPSED_TIME1 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;
        END /* LT_DAY 만큼 선행값 적용 end ****************************************************************************************************************************************/


	    IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_DATA_SUM') IS NOT NULL
		    DROP TABLE #T_SCP0095_ELEC_DATA_SUM;

	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
                , ''                                                    AS PLANT_ID
			    , A.PSI
			    , A.ELEC_MODEL
			    , ''                                                    AS CELL_MODEL
			    , ''                                                    AS ELECTRODE_TYPE
			    , ''                                                    AS FROM_SITE
			    , ''                                                    AS TO_SITE
			    , ''                                                    AS UNIT
			    , A.YYYYMMDD
			    , ''                                                    AS MEASURE
			    , 'SUM'                                                 AS MEASURE_NAME
			    , CASE
                    WHEN A.PSI = 'S' THEN 0 
                    WHEN A.PSI = 'P' THEN 2 
                    ELSE A.SORT_ORDER_NO 
                  END                                                   AS SORT_ORDER_NO
			    , 0                                                     AS VALUE1
			    , 0                                                     AS VALUE2
		     , SUM(A.QTY)                                               AS QTY
			    --, CASE
       --             WHEN A.PSI IN ('S', 'P') THEN ROUND(SUM(A.QTY),0)
       --             ELSE 0                                          --I 는 밑에 EOH 로 추가하므로 SUM 추가 제외.
       --           END                                                   AS QTY
			    , 0                                                     AS W_QTY
			    , 0                                                     AS M_QTY
			    , A.YYYYMM
			    , A.ISO_WEEK
			    , DENSE_RANK() OVER (ORDER BY A.COMPANY_ID, A.ELEC_MODEL)                                                   AS GROUP_NUM
			    , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.COMPANY_ID, A.ELEC_MODEL ORDER BY A.YYYYMMDD )           AS NUM
        INTO    #T_SCP0095_ELEC_DATA_SUM
	    FROM	#T_SCP0095_ELEC_PIVOT A
        WHERE   1=1
            AND A.PSI <> 'I' --SUM에서 제외
            AND A.MEASURE <> 'PKG_PLAN'
	    GROUP BY  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.PSI
			    , A.ELEC_MODEL
			    , A.YYYYMMDD
			    , CASE
                    WHEN PSI = 'S' THEN 0 
                    WHEN PSI = 'P' THEN 2 
                    ELSE A.SORT_ORDER_NO 
                  END
			    , A.YYYYMM
			    , A.ISO_WEEK

    --TESTING : OK
    --select * from #T_SCP0095_ELEC_DATA_SUM;return;
    --select * from #T_SCP0095_ELEC_RAW ;return;

	    IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_RAW_EOH') IS NOT NULL
		    DROP TABLE #T_SCP0095_ELEC_RAW_EOH;
    
	    SELECT DISTINCT
                  DIVISION_ID
			    , COMPANY_ID
			    , ELEC_MODEL
			    , CELL_MODEL
			    , YYYYMMDD
			    , VALUE1
			    , VALUE2
			    , YYYYMM
			    , ISO_WEEK
                , QTY
        INTO    #T_SCP0095_ELEC_RAW_EOH
	    --FROM	#T_SCP0095_ELEC_PIVOT
	    FROM	#T_SCP0095_ELEC_RAW --#T_SCP0095_ELEC_PIVOT 에는 'EHO' 제외되어 있음
        WHERE	1=1
            --AND MEASURE_NAME = 'EOH'
            AND MEASURE = 'EOH'
            --AND (VALUE1 <> 0 OR VALUE2 <> 0 OR QTY <> 0)

    --TESTING : OK
    --select * from #T_SCP0095_ELEC_RAW where MEASURE = 'EOH';
    --select * from #T_SCP0095_ELEC_RAW_EOH;return;

	    IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_DATA_EOH_SUB') IS NOT NULL
		    DROP TABLE #T_SCP0095_ELEC_DATA_EOH_SUB;
    
        --PLANT 제외한 키로 가져옴
        SELECT    A.*
                , ROW_NUMBER() OVER (PARTITION BY A.COMPANY_ID, A.ELEC_MODEL ORDER BY A.VALUE1 DESC) AS ELEC_CNT
        INTO    #T_SCP0095_ELEC_DATA_EOH_SUB
        FROM    (
	                SELECT DISTINCT	  
                              A.COMPANY_ID
			                , A.ELEC_MODEL
			                , A.CELL_MODEL
			                , A.VALUE1
			                , A.VALUE2
			                , A.QTY
	                FROM	#T_SCP0095_ELEC_RAW_EOH A
                ) A


--2023.12.10 인덱스 검토필요
	    CREATE CLUSTERED INDEX IDX_T_SCP0095_ELEC_DATA_EOH_SUB ON #T_SCP0095_ELEC_DATA_EOH_SUB (ELEC_CNT);

    --TESTING : OK
    --select * from #T_SCP0095_ELEC_DATA_EOH_SUB;return;

	    IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_DATA_EOH') IS NOT NULL
		    DROP TABLE #T_SCP0095_ELEC_DATA_EOH;

	    SELECT	  @p_division_id                            AS DIVISION_ID
			    , A.COMPANY_ID
                , ''                                        AS PLANT_ID
			    , 'I'                                       AS PSI
			    , A.ELEC_MODEL
			    , A.CELL_MODEL
			    , ''                                        AS ELECTRODE_TYPE
			    , ''                                        AS FROM_SITE
			    , ''                                        AS TO_SITE
			    , ''                                        AS UNIT
			    , 'D_'+ O.BASIS_YYYYMMDD                    AS YYYYMMDD
			    , ''                                        AS MEASURE
			    , 'EOH'                                     AS MEASURE_NAME
			    , '5'                                       AS SORT_ORDER_NO
			    , A.VALUE1
			    , A.VALUE2
			    , A.QTY
			    , 0                                         AS W_QTY
			    , 0                                         AS M_QTY
			    , O.BASIS_YYYYMM                            AS YYYYMM
			    , RIGHT(O.BASIS_YYYYMM, 4) + O.ISO_WEEK     AS ISO_WEEK
			    , 0                                         AS GROUP_NUM
			    , 0                                         AS NUM
        INTO    #T_SCP0095_ELEC_DATA_EOH
	    FROM	(
				    SELECT	  BASIS_YYYYMMDD
						    , BASIS_YYYYMM
						    , ISO_WEEK
				    FROM	SCM_SYS_CALENDAR_M
				    WHERE	1=1
					    AND BASIS_YYYYMMDD >= @p_from_yyyymmdd
					    AND BASIS_YYYYMMDD <= @p_to_yyyymmdd
			    ) O
			    LEFT JOIN
					    (
						    SELECT	*
						    FROM	#T_SCP0095_ELEC_DATA_EOH_SUB A
						    WHERE	ELEC_CNT = 1
                                ) A ON 1=1
	    WHERE	1=1
		    AND COMPANY_ID IS NOT NULL

    --TESTING : OK
    --select * from #T_SCP0095_ELEC_DATA_EOH;return;
    --select * from #T_SCP0095_ELEC_DATA;return;

	    INSERT INTO #T_SCP0095_ELEC_PIVOT
        SELECT  *
        FROM    #T_SCP0095_ELEC_DATA_SUM
	    UNION ALL
        SELECT  *
        FROM    #T_SCP0095_ELEC_DATA_EOH

    --TESTING : OK
    --select * from #T_SCP0095_ELEC_PIVOT;return;
    --select  * 
    --from    #T_SCP0095_ELEC_PIVOT
    --WHERE   1=1
    --    AND MEASURE = 'COAT_REQ'
    --return;


    PRINT CONCAT('ELAPSED_TIME2 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;
    --select  * from    #T_SCP0095_ELEC_PIVOT WHERE	MEASURE = 'COAT_REQ';return;


    --TESTING : OK
    --select * from #T_SCP0095_ELEC_PIVOT;return;
    --select * 
    --from #T_SCP0095_ELEC_PIVOT
    --where   MEASURE_NAME = 'EOH'
    --return;

	    /********************************************************************************
	    * EOH 수량값 계산
	    ********************************************************************************/
	    IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_PIVOT_SUM') IS NOT NULL
		    DROP TABLE #T_SCP0095_ELEC_PIVOT_SUM;

	    SELECT	  DIVISION_ID
			    , COMPANY_ID
                , PSI
			    , ELEC_MODEL
			    , YYYYMMDD
			    , VALUE1
			    , VALUE2
			    , YYYYMM
			    , QTY
        INTO    #T_SCP0095_ELEC_PIVOT_SUM
	    FROM	#T_SCP0095_ELEC_PIVOT A
	    WHERE	MEASURE_NAME = 'SUM'

    --TESTING : OK
    --select  * from #T_SCP0095_ELEC_PIVOT_SUM;return;
    --select  * from #T_SCP0095_ELEC_PIVOT where MEASURE_NAME = 'SUM'
    --select  * from #T_SCP0095_ELEC_RAW_EOH;return;

    PRINT CONCAT('ELAPSED_TIME3-1 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;


	    IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW_EOH') IS NOT NULL
		    DROP TABLE #T_SCP0095_EOH_RAW_EOH;

	    SELECT    KEYS.DIVISION_ID
			    , KEYS.COMPANY_ID
			    , 'I'							    AS PSI
			    , KEYS.ELEC_MODEL
			    , KEYS.CELL_MODEL
			    , ''							    AS ELECTRODE_TYPE
			    , ''							    AS FROM_SITE
			    , ''							    AS TO_SITE
			    , ''							    AS UNIT
			    , KEYS.YYYYMMDD
			    , ''							    AS MEASURE
			    , 'EOH'							    AS MEASURE_NAME
			    , '10'							    AS SORT_ORDER_NO
			    , ISNULL(SUM(EOH.VALUE1), 0)        AS VALUE1
			    , ISNULL(SUM(EOH.VALUE2), 0)        AS VALUE2
			    , 0								    AS QTY
			    --, ISNULL(SUM(PSUM.QTY), 0)	        AS P_QTY
			    --, ISNULL(SUM(SSUM.QTY), 0)	        AS S_QTY
			    , KEYS.YYYYMM
			    , KEYS.ISO_WEEK					    AS ISO_WEEK
	    INTO	#T_SCP0095_EOH_RAW_EOH
	    FROM	(
				    SELECT DISTINCT
                              DIVISION_ID
						    , COMPANY_ID
						    , ELEC_MODEL
						    , CELL_MODEL
					        , SUBSTRING(YYYYMMDD, 3,8) AS YYYYMMDD
						    , YYYYMM
						    , ISO_WEEK
				    FROM	#T_SCP0095_ELEC_PIVOT
                    WHERE   1=1
                        --AND (CELL_MODEL <> '' AND CELL_MODEL IS NOT NULL) --키에서 SUM Measure 제외 by chaan
                        AND MEASURE_NAME <> 'SUM'
			    ) KEYS
	            LEFT JOIN #T_SCP0095_ELEC_RAW_EOH EOH ON
					    KEYS.DIVISION_ID	= EOH.DIVISION_ID
				    AND KEYS.COMPANY_ID	    = EOH.COMPANY_ID
				    AND KEYS.ELEC_MODEL	    = EOH.ELEC_MODEL
				    --AND KEYS.CELL_MODEL	    = EOH.CELL_MODEL
				    --AND KEYS.YYYYMMDD		= EOH.YYYYMMDD
			    --LEFT JOIN	(
							--    SELECT	  DIVISION_ID
							--		    , COMPANY_ID
							--		    , ELEC_MODEL
							--		    , SUBSTRING(YYYYMMDD, 3,8) AS YYYYMMDD
							--		    , VALUE1
							--		    , VALUE2
							--		    , YYYYMM
							--		    , QTY
							--    FROM	#T_SCP0095_ELEC_PIVOT_SUM
							--    WHERE	1=1
							--	    AND PSI = 'P'
						 --   ) PSUM ON
					  --  KEYS.DIVISION_ID	= PSUM.DIVISION_ID
				   -- AND KEYS.COMPANY_ID	    = PSUM.COMPANY_ID
				   -- AND KEYS.ELEC_MODEL	    = PSUM.ELEC_MODEL
				   -- --AND KEYS.CELL_MODEL	    = EOH.CELL_MODEL
				   -- AND KEYS.YYYYMMDD		= PSUM.YYYYMMDD
			    --LEFT JOIN	(
							--    SELECT	  DIVISION_ID
							--		    , COMPANY_ID
							--		    , ELEC_MODEL
							--		    , SUBSTRING(YYYYMMDD, 3,8) AS YYYYMMDD
							--		    , VALUE1
							--		    , VALUE2
							--		    , YYYYMM
							--		    , QTY
							--    FROM	#T_SCP0095_ELEC_PIVOT_SUM
							--    WHERE	1=1
							--	    AND PSI = 'S'
						 --   ) SSUM ON
					  --  KEYS.DIVISION_ID      = SSUM.DIVISION_ID
				   -- AND KEYS.COMPANY_ID       = SSUM.COMPANY_ID
				   -- AND KEYS.ELEC_MODEL       = SSUM.ELEC_MODEL
				   -- --AND KEYS.CELL_MODEL	      = EOH.CELL_MODEL
				   -- AND KEYS.YYYYMMDD         = SSUM.YYYYMMDD
	    GROUP BY      KEYS.DIVISION_ID
			        , KEYS.COMPANY_ID
			        , KEYS.ELEC_MODEL
			        , KEYS.CELL_MODEL
    			    , KEYS.YYYYMMDD
			        , KEYS.YYYYMM
			        , KEYS.ISO_WEEK


    --TESTING : OK
    --select  * from #T_SCP0095_EOH_RAW_EOH;return;


	    IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW') IS NOT NULL
		    DROP TABLE #T_SCP0095_EOH_RAW;

	    SELECT    EOH.DIVISION_ID
			    , EOH.COMPANY_ID
			    , EOH.PSI
			    , EOH.ELEC_MODEL
			    , EOH.CELL_MODEL
			    , EOH.ELECTRODE_TYPE
			    , EOH.FROM_SITE
			    , EOH.TO_SITE
			    , EOH.UNIT
			    , EOH.YYYYMMDD
			    , EOH.MEASURE
			    , EOH.MEASURE_NAME
			    , EOH.SORT_ORDER_NO
			    , EOH.VALUE1
			    , EOH.VALUE2
                , EOH.QTY
			    , ISNULL(PSUM.QTY, 0)	            AS P_QTY
			    , ISNULL(SSUM.QTY, 0)	            AS S_QTY
			    , EOH.YYYYMM
			    , EOH.ISO_WEEK					    AS ISO_WEEK
	    INTO	#T_SCP0095_EOH_RAW
	    FROM	#T_SCP0095_EOH_RAW_EOH EOH
			    LEFT JOIN	(
							    SELECT	  DIVISION_ID
									    , COMPANY_ID
									    , ELEC_MODEL
									    , SUBSTRING(YYYYMMDD, 3,8) AS YYYYMMDD
									    , VALUE1
									    , VALUE2
									    , YYYYMM
									    , QTY
							    FROM	#T_SCP0095_ELEC_PIVOT_SUM
							    WHERE	1=1
								    AND PSI = 'P'
						    ) PSUM ON
					    EOH.DIVISION_ID	= PSUM.DIVISION_ID
				    AND EOH.COMPANY_ID	    = PSUM.COMPANY_ID
				    AND EOH.ELEC_MODEL	    = PSUM.ELEC_MODEL
				    --AND EOH.CELL_MODEL	= PSUM.CELL_MODEL
				    AND EOH.YYYYMMDD		= PSUM.YYYYMMDD
			    LEFT JOIN	(
							    SELECT	  DIVISION_ID
									    , COMPANY_ID
									    , ELEC_MODEL
									    , SUBSTRING(YYYYMMDD, 3,8) AS YYYYMMDD
									    , VALUE1
									    , VALUE2
									    , YYYYMM
									    , QTY
							    FROM	#T_SCP0095_ELEC_PIVOT_SUM
							    WHERE	1=1
								    AND PSI = 'S'
						    ) SSUM ON
					    EOH.DIVISION_ID      = SSUM.DIVISION_ID
				    AND EOH.COMPANY_ID       = SSUM.COMPANY_ID
				    AND EOH.ELEC_MODEL       = SSUM.ELEC_MODEL
				    --AND EOH.CELL_MODEL	 = SSUM.CELL_MODEL
				    AND EOH.YYYYMMDD         = SSUM.YYYYMMDD

    --TESTING : NOK
    --select  * from #T_SCP0095_EOH_RAW;return;

    PRINT CONCAT('ELAPSED_TIME3-2 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;

	    IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW_SUB') IS NOT NULL
		    DROP TABLE #T_SCP0095_EOH_RAW_SUB;

	    SELECT	  DIVISION_ID
			    , COMPANY_ID
			    , PSI
			    , ELEC_MODEL
			    , CELL_MODEL
			    , YYYYMMDD
			    , ISNULL(VALUE1, 0) AS VALUE1
			    , ISNULL(VALUE2, 0) AS VALUE2
			    , ISNULL(QTY, 0)    AS QTY
			    , ISNULL(P_QTY, 0)  AS P_QTY
			    , ISNULL(S_QTY, 0)  AS S_QTY
			    , YYYYMM
			    , ISO_WEEK
			    , ROW_NUMBER() OVER (PARTITION BY   COMPANY_ID, ELEC_MODEL, CELL_MODEL ORDER BY YYYYMMDD )    AS COMPANY_NUM
			    , DENSE_RANK() OVER (ORDER BY       COMPANY_ID, ELEC_MODEL)                                   AS GROUP_NUM
			    , DENSE_RANK() OVER (ORDER BY       COMPANY_ID, ELEC_MODEL, CELL_MODEL)                       AS CELL_NUM
	    INTO    #T_SCP0095_EOH_RAW_SUB
	    FROM	#T_SCP0095_EOH_RAW
        WHERE   1=1

        PRINT CONCAT('ELAPSED_TIME3-3 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;
    --TESTING : OK
    --select  * from #T_SCP0095_EOH_RAW
    --select  * from #T_SCP0095_EOH_RAW_SUB;return;

	    IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW_DATE_SUB1') IS NOT NULL
		    DROP TABLE #T_SCP0095_EOH_RAW_DATE_SUB1;

	    SELECT DISTINCT
                  DIVISION_ID
			    , COMPANY_ID
			    , ELEC_MODEL
			    , CELL_MODEL
			    , YYYYMMDD
                , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, COMPANY_ID, ELEC_MODEL, CELL_MODEL ORDER BY YYYYMMDD)     AS NUM
                , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, COMPANY_ID, ELEC_MODEL, CELL_MODEL ORDER BY YYYYMMDD) - 1 AS PRE_NUM
        INTO    #T_SCP0095_EOH_RAW_DATE_SUB1
        FROM    #T_SCP0095_EOH_RAW_SUB


--2023.12.10 인덱스 검토필요
	    CREATE CLUSTERED INDEX IDX_T_SCP0095_EOH_RAW_DATE_SUB1 ON #T_SCP0095_EOH_RAW_DATE_SUB1 (DIVISION_ID, COMPANY_ID, ELEC_MODEL, CELL_MODEL, PRE_NUM, NUM);

        PRINT CONCAT('ELAPSED_TIME3-4 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;

    --TESTING : OK
    --select * from #T_SCP0095_EOH_RAW_DATE_SUB1;return;

	    IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW_DATE_SUB2') IS NOT NULL
		    DROP TABLE #T_SCP0095_EOH_RAW_DATE_SUB2;

	    SELECT    A.*
                , B.YYYYMMDD AS PRE_YYYYMMDD
        INTO    #T_SCP0095_EOH_RAW_DATE_SUB2
        FROM    #T_SCP0095_EOH_RAW_DATE_SUB1 A
                LEFT JOIN #T_SCP0095_EOH_RAW_DATE_SUB1 B ON
                        A.DIVISION_ID   = B.DIVISION_ID
                    AND A.COMPANY_ID    = B.COMPANY_ID
                    AND A.ELEC_MODEL    = B.ELEC_MODEL
                    AND A.CELL_MODEL    = B.CELL_MODEL
                    AND A.PRE_NUM       = B.NUM

--2023.12.10 인덱스 검토필요
	    --CREATE CLUSTERED INDEX IDX_T_SCP0095_EOH_RAW_DATE_SUB2 ON #T_SCP0095_EOH_RAW_DATE_SUB2 (DIVISION_ID, COMPANY_ID, ELEC_MODEL, CELL_MODEL, YYYYMMDD);

        PRINT CONCAT('ELAPSED_TIME3-5 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;
    --TESTING : OK
    --select * from #T_SCP0095_EOH_RAW_DATE_SUB2;return;

	    IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW_DATE_SUB3') IS NOT NULL
		    DROP TABLE #T_SCP0095_EOH_RAW_DATE_SUB3;

        SELECT    A.*
                , B.PRE_YYYYMMDD
        INTO    #T_SCP0095_EOH_RAW_DATE_SUB3
        FROM    #T_SCP0095_EOH_RAW_SUB A
                JOIN #T_SCP0095_EOH_RAW_DATE_SUB2 B ON 
                            A.DIVISION_ID   = B.DIVISION_ID
                        AND A.COMPANY_ID    = B.COMPANY_ID
                        AND A.ELEC_MODEL    = B.ELEC_MODEL
                        AND A.CELL_MODEL    = B.CELL_MODEL
                        AND A.YYYYMMDD      = B.YYYYMMDD
    
--2023.12.10 인덱스 검토필요
	    --CREATE CLUSTERED INDEX IDX_T_SCP0095_EOH_RAW_DATE_SUB3 ON #T_SCP0095_EOH_RAW_DATE_SUB3 (DIVISION_ID, COMPANY_ID, ELEC_MODEL, CELL_MODEL, PRE_YYYYMMDD, YYYYMMDD);

        PRINT CONCAT('ELAPSED_TIME3-6 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;
    --TESTING : OK
    --select * from #T_SCP0095_EOH_RAW_DATE_SUB3;return;


        DECLARE @V_CUR_DIVISION_ID		NVARCHAR(30)
        DECLARE @V_CUR_COMPANY_ID		NVARCHAR(30)
        DECLARE @V_CUR_PSI				NVARCHAR(01)
        DECLARE @V_CUR_ELEC_MODEL		NVARCHAR(150)
        DECLARE @V_CUR_CELL_MODEL		NVARCHAR(150)
        DECLARE @V_CUR_YYYYMMDD			NVARCHAR(20)
        DECLARE @V_CUR_PRE_YYYYMMDD		NVARCHAR(20)
        DECLARE @V_CUR_VALUE1			NUMERIC(38,2)
        DECLARE @V_CUR_VALUE2			NUMERIC(38,2)
        DECLARE @V_CUR_EOH_QTY			NUMERIC(38,2)
        DECLARE @V_CUR_QTY  			NUMERIC(38,2)
        DECLARE @V_CUR_P_QTY  			NUMERIC(38,2)
        DECLARE @V_CUR_S_QTY  			NUMERIC(38,2)
        DECLARE @V_CUR_YYYYMM			NVARCHAR(6)
        DECLARE @V_CUR_ISO_WEEK		    NVARCHAR(8)
	    DECLARE @V_CUR_COMPANY_NUM      INT
	    DECLARE @V_CUR_GROUP_NUM        INT
	    DECLARE @V_CUR_CELL_NUM         INT

        DECLARE @V_CURR_QTY		NUMERIC(38,2)


	    IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW_DATE_SUB4') IS NOT NULL
		    DROP TABLE #T_SCP0095_EOH_RAW_DATE_SUB4;

	    SELECT	  CURR.DIVISION_ID
			    , CURR.COMPANY_ID
			    , CURR.PSI
			    , CURR.ELEC_MODEL
			    , CURR.CELL_MODEL
			    , CURR.YYYYMMDD
                , CURR.PRE_YYYYMMDD
			    , ISNULL(CURR.VALUE1, 0) AS VALUE1
			    , ISNULL(CURR.VALUE2, 0) AS VALUE2
                , CASE
                    WHEN CURR.PRE_YYYYMMDD IS NULL THEN CURR.VALUE1 + CURR.VALUE2 + CURR.P_QTY - CURR.S_QTY -- 키별(DIVISION_ID, COMPANY_ID, ELEC_MODEL, CELL_MODEL) 첫번째 날짜에 해당하면 현재 VALUE1+VALUE2+P_QTY+S_QTY
                    ELSE CURR.VALUE1 + CURR.VALUE2 + PRE.P_QTY + PRE.S_QTY + CURR.P_QTY - CURR.S_QTY        -- 그다음날부터는 전날(P_QTY+S_QTY) + 현재(P_QTY+S_QTY)
                  END AS EOH_QTY
                , CONVERT(NUMERIC(38, 2), 0)   AS QTY
			    , ISNULL(CURR.P_QTY, 0) AS P_QTY
			    , ISNULL(CURR.S_QTY, 0) AS S_QTY
			    , CURR.YYYYMM
			    , CURR.ISO_WEEK
			    , CURR.COMPANY_NUM
			    , CURR.GROUP_NUM
			    , CURR.CELL_NUM
        INTO    #T_SCP0095_EOH_RAW_DATE_SUB4
	    FROM	#T_SCP0095_EOH_RAW_DATE_SUB3 CURR
                LEFT OUTER JOIN #T_SCP0095_EOH_RAW_DATE_SUB3 PRE ON
                        CURR.DIVISION_ID    = PRE.DIVISION_ID
                    AND CURR.COMPANY_ID     = PRE.COMPANY_ID
                    AND CURR.ELEC_MODEL     = PRE.ELEC_MODEL
                    AND CURR.CELL_MODEL     = PRE.CELL_MODEL
                    AND CURR.PRE_YYYYMMDD   = PRE.YYYYMMDD
        ORDER BY  CURR.DIVISION_ID
			    , CURR.COMPANY_ID
			    , CURR.PSI
			    , CURR.ELEC_MODEL
			    , CURR.CELL_MODEL
			    , CURR.YYYYMMDD

--2023.12.10 천승호
	    --CREATE CLUSTERED INDEX IDX_T_SCP0095_EOH_RAW_DATE_SUB4 ON #T_SCP0095_EOH_RAW_DATE_SUB4 (PRE_YYYYMMDD);

CREATE NONCLUSTERED INDEX IDX01_T_SCP0095_EOH_RAW_DATE_SUB4 ON [dbo].[#T_SCP0095_EOH_RAW_DATE_SUB4] ([PRE_YYYYMMDD]) INCLUDE ([DIVISION_ID],[COMPANY_ID],[ELEC_MODEL],[CELL_MODEL],[QTY]);
CREATE NONCLUSTERED INDEX IDX02_T_SCP0095_EOH_RAW_DATE_SUB4 ON [dbo].[#T_SCP0095_EOH_RAW_DATE_SUB4] ([PRE_YYYYMMDD]) INCLUDE ([EOH_QTY]);
CREATE NONCLUSTERED INDEX IDX03_T_SCP0095_EOH_RAW_DATE_SUB4 ON [dbo].[#T_SCP0095_EOH_RAW_DATE_SUB4] ([PRE_YYYYMMDD]) INCLUDE ([DIVISION_ID],[COMPANY_ID],[PSI],[ELEC_MODEL],[CELL_MODEL],[YYYYMMDD],[VALUE1],[VALUE2],[EOH_QTY],[QTY],[P_QTY],[S_QTY],[YYYYMM],[ISO_WEEK],[COMPANY_NUM],[GROUP_NUM],[CELL_NUM]);


        PRINT CONCAT('ELAPSED_TIME3-7 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;
    --TESTING : OK
    --select * from #T_SCP0095_EOH_RAW_DATE_SUB4;return;
        -- 첫번째 날짜는 EOH 산출되어 있음
        UPDATE #T_SCP0095_EOH_RAW_DATE_SUB4
        SET
            QTY = EOH_QTY
        WHERE   PRE_YYYYMMDD IS NULL

        PRINT CONCAT('ELAPSED_TIME3-8 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;
    --TESTING : OK
    --select * from #T_SCP0095_EOH_RAW_DATE_SUB4;return;
    
	    --재고 누적합산 begin-------------------------------------------------------------------------------------------
        UPDATE #T_SCP0095_EOH_RAW_DATE_SUB4
        SET
            QTY = P_QTY - S_QTY
        WHERE   PRE_YYYYMMDD IS NOT NULL

        PRINT CONCAT('ELAPSED_TIME3-9 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;
    --TESTING : OK
    --select * from #T_SCP0095_EOH_RAW_DATE_SUB4;return;

        --UPDATE #T_SCP0095_EOH_RAW_DATE_SUB4
        --SET
        --      VALUE1	= ISNULL(VALUE1, 0)
        --    , VALUE2	= ISNULL(VALUE2, 0)
        --    , QTY		= ISNULL(QTY, 0)
        --    , P_QTY		= ISNULL(P_QTY, 0)
        --    , S_QTY		= ISNULL(S_QTY, 0)

        --DELETE FROM #T_SCP0095_EOH_RAW_DATE_SUB4
        --WHERE   1=1
        --    AND VALUE1	= 0
        --    AND VALUE2	= 0
        --    AND QTY		= 0
        --    AND P_QTY	= 0
        --    AND S_QTY	= 0


	    IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW_DATE_SUB5') IS NOT NULL
		    DROP TABLE #T_SCP0095_EOH_RAW_DATE_SUB5;

	    SELECT	  DIVISION_ID
			    , COMPANY_ID
			    , PSI
			    , ELEC_MODEL
			    , CELL_MODEL
			    , YYYYMMDD
                , PRE_YYYYMMDD
			    , VALUE1
			    , VALUE2
                , EOH_QTY
                --RANGE 창 프레임의 전체 ORDER BY 목록 크기가 8000바이트입니다. 지원되는 최대 크기는 900바이트입니다. 에러로 옵션 수정
                  --, SUM(QTY) OVER(PARTITION BY DIVISION_ID, COMPANY_ID, PSI, ELEC_MODEL, CELL_MODEL ORDER BY YYYYMMDD) AS QTY
                  , SUM(QTY) OVER(PARTITION BY DIVISION_ID, COMPANY_ID, PSI, ELEC_MODEL, CELL_MODEL ORDER BY YYYYMMDD ROWS UNBOUNDED PRECEDING) AS QTY
			    , P_QTY
			    , S_QTY
			    , YYYYMM
			    , ISO_WEEK
			    , COMPANY_NUM
			    , GROUP_NUM
			    , CELL_NUM
        INTO    #T_SCP0095_EOH_RAW_DATE_SUB5
	    FROM	#T_SCP0095_EOH_RAW_DATE_SUB4
        WHERE   PRE_YYYYMMDD IS NOT NULL

--2023.12.10 인덱스 검토필요
	    CREATE CLUSTERED INDEX IDX_T_SCP0095_EOH_RAW_DATE_SUB5 ON #T_SCP0095_EOH_RAW_DATE_SUB5 (DIVISION_ID, COMPANY_ID, ELEC_MODEL, CELL_MODEL)

        PRINT CONCAT('ELAPSED_TIME3-10 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;
    --select * from #T_SCP0095_EOH_RAW_DATE_SUB4;
    --select * from #T_SCP0095_EOH_RAW_DATE_SUB5;return;

        -- 둘째날부터 첫째날 재고를 합산
    --select   A.*
    --       , B.QTY AS PRE_EOH
    --       , A.QTY + B.QTY CURR_EOH
    --from    #T_SCP0095_EOH_RAW_DATE_SUB5 A
    --        LEFT JOIN (
    --                SELECT  *
    --                FROM    #T_SCP0095_EOH_RAW_DATE_SUB4
    --                WHERE   1=1
    --                    AND PRE_YYYYMMDD IS NULL
    --            ) B ON
    --                    A.DIVISION_ID   = B.DIVISION_ID 
    --                AND A.COMPANY_ID    = B.COMPANY_ID  
    --                AND A.ELEC_MODEL    = B.ELEC_MODEL  
    --                AND A.CELL_MODEL    = B.CELL_MODEL  

    --return;

        UPDATE A
        SET
            A.QTY = A.QTY + B.QTY 
        FROM    #T_SCP0095_EOH_RAW_DATE_SUB5 A
                JOIN (
                        SELECT  *
                        FROM    #T_SCP0095_EOH_RAW_DATE_SUB4
                        WHERE   1=1
                            AND PRE_YYYYMMDD IS NULL
                    ) B ON
                            A.DIVISION_ID   = B.DIVISION_ID 
                        AND A.COMPANY_ID    = B.COMPANY_ID  
                        AND A.ELEC_MODEL    = B.ELEC_MODEL  
                        AND A.CELL_MODEL    = B.CELL_MODEL  

        PRINT CONCAT('ELAPSED_TIME3-11 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;
    --TESTING : OK            
    --select * from #T_SCP0095_EOH_RAW_DATE_SUB4;
    --select * from #T_SCP0095_EOH_RAW_DATE_SUB5;return;
    
        -- 둘째날이후 데이터 삭제
        DELETE FROM #T_SCP0095_EOH_RAW_DATE_SUB4
        WHERE   PRE_YYYYMMDD IS NOT NULL

        -- 둘째날이후 재고 산출된 데이터 추가
        INSERT INTO #T_SCP0095_EOH_RAW_DATE_SUB4
        SELECT  *
        FROM    #T_SCP0095_EOH_RAW_DATE_SUB5

	    --재고 누적합산 end-------------------------------------------------------------------------------------------
        PRINT CONCAT('ELAPSED_TIME3-12 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;

    --TESTING : OK
    --select * from #T_SCP0095_EOH_RAW_DATE_SUB4;return;


	    IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW_SUM') IS NOT NULL
		    DROP TABLE #T_SCP0095_EOH_RAW_SUM;

	    SELECT	*
        INTO    #T_SCP0095_EOH_RAW_SUM
	    FROM	#T_SCP0095_EOH_RAW_DATE_SUB4

    --TESTING : OK
    --select * from #T_SCP0095_EOH_RAW_DATE_SUB3;
    --select * from #T_SCP0095_EOH_RAW_DATE_SUB4;
    --select * from #T_SCP0095_EOH_RAW_SUM;return;

    --							SELECT DISTINCT
    --									  DIVISION_ID
    --									, COMPANY_ID
    --									, ELEC_MODEL
    --									, CELL_MODEL
    --									, 'D_'+ YYYYMMDD AS YYYYMMDD
    --									, ISNULL(QTY, 0) AS QTY
    --							FROM	#T_SCP0095_EOH_RAW_SUM
    --RETURN;
    PRINT CONCAT('ELAPSED_TIME13 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;

    --TESTING : OK
    --select * from #T_SCP0095_ELEC_PIVOT;return;
    --select * 
    --from #T_SCP0095_ELEC_PIVOT
    --where   MEASURE_NAME = 'EOH'
    --return;


	    IF OBJECT_ID('tempdb..#T_SCP0095_EOH_FINAL') IS NOT NULL
		    DROP TABLE #T_SCP0095_EOH_FINAL;

	    SELECT	  'EE' DIVISION_ID
			    , EOH.COMPANY_ID
			    , 'I'                   AS PSI
			    , EOH.ELEC_MODEL
			    , EOH.CELL_MODEL
			    , ''                    AS ELECTRODE_TYPE
			    , ''                    AS FROM_SITE
			    , ''                    AS TO_SITE
			    , ''                    AS UNIT
			    , 'D_' + EOH.YYYYMMDD   AS YYYYMMDD
			    , ''                    AS MEASURE
			    , 'EOH'                 AS MEASURE_NAME
			    , '10'                  AS SORT_ORDER_NO
			    , EOH.VALUE1
			    , EOH.VALUE2
			    , DD.QTY
			    , ISNULL(WW.QTY,0)      AS W_QTY
			    , ISNULL(MM.QTY,0)      AS M_QTY
			    , EOH.YYYYMM
			    , EOH.ISO_WEEK      AS ISO_WEEK
        INTO    #T_SCP0095_EOH_FINAL
	    --FROM	#T_SCP0095_ELEC_RAW_EOH EOH
        FROM	#T_SCP0095_EOH_RAW EOH
			    LEFT JOIN	(
							    SELECT DISTINCT
									      DIVISION_ID
									    , COMPANY_ID
									    , ELEC_MODEL
									    , CELL_MODEL
									    , YYYYMMDD
									    , ISNULL(QTY, 0) AS QTY
							    FROM	#T_SCP0095_EOH_RAW_SUM
						    ) DD ON
					    EOH.DIVISION_ID      = DD.DIVISION_ID
				    AND EOH.COMPANY_ID       = DD.COMPANY_ID
				    AND EOH.ELEC_MODEL       = DD.ELEC_MODEL
				    AND EOH.CELL_MODEL       = DD.CELL_MODEL
				    AND EOH.YYYYMMDD         = DD.YYYYMMDD
			    LEFT JOIN	(
							    SELECT	*
							    FROM	(
										    SELECT	  DIVISION_ID
												    , COMPANY_ID
												    , ELEC_MODEL
												    , CELL_MODEL
												    , YYYYMMDD
												    , QTY
												    , YYYYMM
												    , ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, COMPANY_ID, ELEC_MODEL,CELL_MODEL, YYYYMM ORDER BY YYYYMMDD DESC) AS IDX
										    FROM	#T_SCP0095_EOH_RAW_SUM
									    ) A
							    WHERE	1=1
								    AND IDX = 1
						    ) MM ON
					    EOH.DIVISION_ID      = MM.DIVISION_ID
				    AND EOH.COMPANY_ID       = MM.COMPANY_ID
				    AND EOH.ELEC_MODEL       = MM.ELEC_MODEL
				    AND EOH.CELL_MODEL       = MM.CELL_MODEL
				    AND EOH.YYYYMMDD         = MM.YYYYMMDD
			    LEFT JOIN	(
							    SELECT	*
							    FROM	(
										    SELECT	  DIVISION_ID
												    , COMPANY_ID
												    , ELEC_MODEL
												    , CELL_MODEL
												    , YYYYMMDD
												    , QTY
												    , ISO_WEEK
												    , ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, COMPANY_ID, ELEC_MODEL, CELL_MODEL, ISO_WEEK ORDER BY YYYYMMDD DESC) AS IDX
										    FROM	#T_SCP0095_EOH_RAW_SUM
									    ) A
							    WHERE	1=1
								    AND IDX = 1
						    ) WW ON
					    EOH.DIVISION_ID      = WW.DIVISION_ID
				    AND EOH.COMPANY_ID       = WW.COMPANY_ID
				    AND EOH.ELEC_MODEL       = WW.ELEC_MODEL
				    AND EOH.CELL_MODEL       = WW.CELL_MODEL
				    AND EOH.YYYYMMDD         = WW.YYYYMMDD
	    GROUP BY	  EOH.COMPANY_ID
				    , EOH.ELEC_MODEL
				    , EOH.CELL_MODEL
				    , EOH.YYYYMMDD
				    , EOH.VALUE1
				    , EOH.VALUE2
				    , DD.QTY
				    , WW.QTY
				    , MM.QTY
				    , EOH.YYYYMM
				    , EOH.ISO_WEEK

    --TESTING : OK
    --select * from #T_SCP0095_EOH_FINAL;return;
    --select * from #T_SCP0095_EOH_RAW_SUM;
    --select * from #T_SCP0095_ELEC_PIVOT;return;

	    --EOH 계산 수량 업데이트
	    UPDATE A
	    SET
		      A.QTY		= B.QTY
		    , A.W_QTY	= B.W_QTY
		    , A.M_QTY	= B.M_QTY
	    FROM	#T_SCP0095_ELEC_PIVOT A
			    JOIN #T_SCP0095_EOH_FINAL B ON 
                        A.DIVISION_ID       = B.DIVISION_ID
				    AND A.COMPANY_ID        = B.COMPANY_ID
				    AND A.ELEC_MODEL        = B.ELEC_MODEL
				    AND A.CELL_MODEL        = B.CELL_MODEL
				    AND A.YYYYMMDD          = B.YYYYMMDD
	     WHERE	1=1
		    AND A.MEASURE_NAME = 'EOH'

    --TESTING : OK
    --select * from #T_SCP0095_EOH_FINAL;
    --select * from #T_SCP0095_ELEC_PIVOT;return;
    --select * from #T_SCP0095_ELEC_PIVOT WHERE MEASURE_NAME = 'EOH';return;

	    IF OBJECT_ID('tempdb..#T_SCP0095_FETCH_DATA_LAST_WEEK_DAY') IS NOT NULL
		    DROP TABLE #T_SCP0095_FETCH_DATA_LAST_WEEK_DAY;

	    SELECT	*
        INTO    #T_SCP0095_FETCH_DATA_LAST_WEEK_DAY
	    FROM	(
				    SELECT	  DIVISION_ID
						    , COMPANY_ID
						    , PSI
						    , ELEC_MODEL
						    , CELL_MODEL
						    , 'D_' + YYYYMMDD AS YYYYMMDD
						    , QTY
						    , ISO_WEEK
						    , ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, COMPANY_ID, ELEC_MODEL, CELL_MODEL, ISO_WEEK ORDER BY YYYYMMDD DESC) AS IDX
				    FROM	#T_SCP0095_EOH_RAW_SUM
			    ) A
	    WHERE   1=1
		    AND IDX = 1

--2023.12.10 인덱스 검토필요
	    --CREATE CLUSTERED INDEX IDX_T_SCP0095_FETCH_DATA_LAST_WEEK_DAY ON #T_SCP0095_FETCH_DATA_LAST_WEEK_DAY (DIVISION_ID, COMPANY_ID, PSI, ELEC_MODEL, CELL_MODEL, YYYYMMDD);

    --TESTING : OK
    --select  * from #T_SCP0095_FETCH_DATA_LAST_WEEK_DAY;return;

	    --Yield Weekly 수량 업데이트
	    UPDATE A
	    SET
		    A.W_QTY = A.QTY
	    FROM	#T_SCP0095_ELEC_PIVOT A
			    JOIN #T_SCP0095_FETCH_DATA_LAST_WEEK_DAY B ON
					    A.DIVISION_ID       = B.DIVISION_ID
				    AND A.COMPANY_ID        = B.COMPANY_ID
				    AND A.PSI               = B.PSI
				    AND A.ELEC_MODEL        = B.ELEC_MODEL
				    AND A.CELL_MODEL        = B.CELL_MODEL
				    AND A.YYYYMMDD          = B.YYYYMMDD
	    WHERE	A.MEASURE IN ('YIELD_E','YIELD_A')

	    --Yield Monthly 수량 업데이트
	    IF OBJECT_ID('tempdb..#T_SCP0095_FETCH_DATA_LAST_MONTH_DAY') IS NOT NULL
		    DROP TABLE #T_SCP0095_FETCH_DATA_LAST_MONTH_DAY;

	    SELECT	*
        INTO    #T_SCP0095_FETCH_DATA_LAST_MONTH_DAY
	    FROM	(
				    SELECT	  DIVISION_ID
						    , COMPANY_ID
						    , PSI
						    , ELEC_MODEL
						    , CELL_MODEL
						    , 'D_' + YYYYMMDD AS YYYYMMDD
						    , QTY
						    , YYYYMM
						    , ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, COMPANY_ID, ELEC_MODEL,CELL_MODEL, YYYYMM ORDER BY YYYYMMDD DESC) AS IDX
				    FROM	#T_SCP0095_EOH_RAW_SUM
			    ) A
	    WHERE	1=1
		    AND IDX = 1

--2023.12.10 인덱스 검토필요
	    --CREATE CLUSTERED INDEX IDX_T_SCP0095_FETCH_DATA_LAST_MONTH_DAY ON #T_SCP0095_FETCH_DATA_LAST_MONTH_DAY (DIVISION_ID, COMPANY_ID, PSI, ELEC_MODEL, CELL_MODEL, YYYYMMDD);


    --TESTING : OK
    --select * from #T_SCP0095_ELEC_PIVOT;return;

	    UPDATE A
	    SET
		    A.M_QTY = A.QTY
	    FROM	#T_SCP0095_ELEC_PIVOT A
			    JOIN #T_SCP0095_FETCH_DATA_LAST_MONTH_DAY B ON
					    A.DIVISION_ID       = B.DIVISION_ID
				    AND A.COMPANY_ID        = B.COMPANY_ID
				    AND A.PSI               = B.PSI
				    AND A.ELEC_MODEL        = B.ELEC_MODEL
				    AND A.CELL_MODEL        = B.CELL_MODEL
				    AND A.YYYYMMDD          = B.YYYYMMDD
	    WHERE	A.MEASURE IN ('YIELD_E','YIELD_A')

	    --SUM 컬럼정보 업데이트
	    IF OBJECT_ID('tempdb..#T_SCP0095_CELLMODEL_DATA') IS NOT NULL
		    DROP TABLE #T_SCP0095_CELLMODEL_DATA ;

	    SELECT	L.*
	    INTO	#T_SCP0095_CELLMODEL_DATA
	    FROM	(
				    SELECT	  *
						    , ROW_NUMBER() OVER(PARTITION BY ELEC_MODEL ORDER BY CELL_MODEL DESC) AS IDX
				    FROM	(
							    SELECT DISTINCT
									      ELEC_MODEL
									    , CELL_MODEL
							    FROM	#T_SCP0095_ELEC_PIVOT
							    WHERE	1=1
								    AND MEASURE_NAME <> 'SUM'
						    ) M
			    ) L
	    WHERE	IDX = 1

--2023.12.10 인덱스 검토필요
        CREATE CLUSTERED INDEX IDX_T_SCP0095_CELLMODEL_DATA ON #T_SCP0095_CELLMODEL_DATA (ELEC_MODEL);

    --TESTING : OK
    --select * from #T_SCP0095_CELLMODEL_DATA;return;

	    UPDATE A
	    SET
		    A.CELL_MODEL = B.CELL_MODEL
	    FROM	#T_SCP0095_ELEC_PIVOT A
			    LEFT JOIN #T_SCP0095_CELLMODEL_DATA B ON
					    A.ELEC_MODEL = B.ELEC_MODEL
	    WHERE	A.MEASURE_NAME = 'SUM'

    --TESTING : OK
    --select * from #T_SCP0095_ELEC_PIVOT;return;
    --select * from #T_SCP0095_ELEC_PIVOT WHERE MEASURE_NAME = 'EOH';return;

    --TESTING : OK
    --select  * 
    --from    #T_SCP0095_ELEC_PIVOT
    --where   1=1
    --    AND VALUE1 = 0
    --    AND VALUE2 = 0
    --    AND QTY    = 0
    --    AND W_QTY    = 0
    --    AND M_QTY    = 0
    --return;

    --DELETE FROM #T_SCP0095_ELEC_PIVOT
    --WHERE   1=1
    --    AND VALUE1 = 0
    --    AND VALUE2 = 0
    --    AND QTY    = 0
    --    AND W_QTY    = 0
    --    AND M_QTY    = 0

    --select * from #T_SCP0095_ELEC_PIVOT where MEASURE_NAME = 'EOH' order by YYYYMMDD;return;

    PRINT CONCAT('ELAPSED_TIME4 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;

	    PRINT '-------------PIVOT TABLE : ' +  CONVERT(CHAR(23), getdate(), 21);

	    /********************************************************************************
	    * PIVOIT처리
	    ********************************************************************************/
    PRINT CONCAT('@p_from_yyyymmdd : ', @p_from_yyyymmdd);
    PRINT CONCAT('@p_to_yyyymmdd : ', @p_to_yyyymmdd);

	    BEGIN
		    DECLARE @mQry_sum  NVARCHAR(MAX);
		    DECLARE @mEXEC     NVARCHAR(MAX);
		    DECLARE @mDAY_QTY  NVARCHAR(MAX);

		    SET @mDAY_QTY	= '';
		    SET @mDAY_QTY	= @mDAY_QTY + 'QTY ' ;

		    -- PIVOIT 대상 날짜문자열 생성
		    SET @mQry_sum	= '';

            SELECT  @mQry_sum = @mQry_sum + '									, ' +
				    CASE
					    WHEN CHARINDEX('M_', YYYYMMDD) = 1 THEN  'ISNULL(SUM(CASE WHEN yyyymm   = RIGHT('''+YYYYMMDD+''',6) THEN CASE WHEN MEASURE_NAME = ''EOH'' OR MEASURE_NAME = ''YIELD_E'' OR MEASURE_NAME = ''YIELD_A'' THEN M_QTY ELSE '+@mDAY_QTY+'  END  END), 0) AS ' + YYYYMMDD
					    --Weekly, Monthly 는 Qty,W_QTY 수량 : 마지막 일을 보여줌
					    WHEN CHARINDEX('W_', YYYYMMDD) = 1 THEN  'ISNULL(SUM(CASE WHEN ISO_WEEK = RIGHT('''+YYYYMMDD+''',6) THEN CASE WHEN MEASURE_NAME = ''EOH'' OR MEASURE_NAME = ''YIELD_E'' OR MEASURE_NAME = ''YIELD_A'' THEN W_QTY ELSE '+@mDAY_QTY+'  END  END), 0) AS ' + YYYYMMDD
					    WHEN CHARINDEX('D_', YYYYMMDD) = 1 THEN  'ISNULL(SUM(CASE WHEN YYYYMMDD = '''+YYYYMMDD+''' THEN '+@mDAY_QTY+' END), 0) AS ' + YYYYMMDD
				    END + '' + CHAR(10)
            FROM	(
					    SELECT	  'W_' + A.BASIS_YYYYMM + A.ISO_WEEK AS YYYYMMDD
							    , A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
					    FROM	[DBO].[SCM_SYS_CALENDAR_M] A
					    WHERE	A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
					    GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
					    UNION ALL
					    SELECT	  'M_' + A.BASIS_YYYYMM  AS YYYYMMDD
							    , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
					    FROM	[DBO].[SCM_SYS_CALENDAR_M] A
					    WHERE	A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
					    GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
					    UNION ALL
					    SELECT	  'D_' + A.BASIS_YYYYMMDD   AS YYYYMMDD
							    , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
					    FROM	[DBO].[SCM_SYS_CALENDAR_M] A
					    WHERE	A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
					    GROUP BY A.BASIS_YYYYMMDD
				    ) AS A
		    ORDER BY SORT_ORDER_NO;

		    SET @mEXEC = N'
						    SELECT	  P.DIVISION_ID
								    , P.COMPANY_ID
								    , P.ELEC_MODEL
								    , P.PSI
								    , P.CELL_MODEL
								    , (
                                        SELECT TOP 1 
                                                ISNULL(NULLIF(X.NICK_NAME,''''), ''-'') 
                                        FROM    dbo.SCM_MST_ITEM_SN X WITH(NOLOCK)
                                        WHERE   1=1 
                                            AND X.ITEM_ID = P.CELL_MODEL
                                        ) AS NICK_NAME
								    , P.ELECTRODE_TYPE
								    , P.FROM_SITE
								    , P.TO_SITE
								    , P.UNIT
								    , P.MEASURE
								    , P.MEASURE_NAME
								    , P.SORT_ORDER_NO
								    , P.VALUE1
								    , P.VALUE2
                                    ' + @mQry_sum + '
						    FROM	  #T_SCP0095_ELEC_PIVOT P
                            WHERE   1=1
                                AND (
                                        (P.MEASURE_NAME = ''SUM'') OR
                                        (P.MEASURE_NAME = ''EOH'') OR
                                        (P.MEASURE IN (SELECT COLUMN_NAME FROM #T_SCP0095_MEASURE))
                                    )
						    GROUP BY	  P.DIVISION_ID
									    , P.COMPANY_ID
									    , P.PSI
									    , P.ELEC_MODEL
									    , P.CELL_MODEL
									    , P.ELECTRODE_TYPE
									    , P.FROM_SITE
									    , P.TO_SITE
									    , P.UNIT
									    , P.MEASURE
									    , P.MEASURE_NAME
									    , P.SORT_ORDER_NO
									    , P.VALUE1
									    , P.VALUE2
						    ORDER BY	  P.COMPANY_ID
									    , P.ELEC_MODEL
									    , CASE PSI
										    WHEN ''''    THEN 0
										    WHEN ''S''   THEN 1
										    WHEN ''P''   THEN 2
										    WHEN ''I''   THEN 3
										    ELSE 5
										    END
									    , CONVERT(INT, P.SORT_ORDER_NO)
                                        '

			    --TESTING : OK
			    --exec debug_log @mEXEC, 'T';return;
    --TESTING : OK
    --select * from #T_SCP0095_ELEC_PIVOT;return;

                DELETE FROM #T_SCP0095_ELEC_PIVOT 
                WHERE   VALUE1  = 0
                    AND VALUE2  = 0
                    AND QTY     = 0
                    AND W_QTY   = 0
                    AND M_QTY   = 0

			    EXEC (@mEXEC);
	    END;
		SET @v_log_type		= 'END';
		SET @v_log_message	= '########## END of procedure ##########';
		SET @v_description	= '';
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @p_program_id, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        PRINT CONCAT('ELAPSED_TIME5 : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_ELAPSED_TIME, 114));SET @V_ELAPSED_TIME = CURRENT_TIMESTAMP;
        PRINT CONCAT('TOTAL_ELAPSED_TIME : ', CONVERT(VARCHAR, CURRENT_TIMESTAMP - @V_TOTAL_ELAPSED_TIME, 114));
    END TRY
	BEGIN CATCH
		BEGIN
			INSERT INTO scm_sys_log_batch (  program_name
											,log_type
											,log_count
											,log_message
											,description
											,event_date
											,creation_date
											,created_by
											,last_update_date
											,last_updated_by)
			VALUES (ERROR_PROCEDURE()
					,'ERROR'
					,NULL
					,ERROR_MESSAGE()
					,NULL
					,SYSDATETIME()
					,SYSDATETIME()
					,ERROR_PROCEDURE()
					,SYSDATETIME()
					,ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
				COMMIT WORK;
		END;
	END CATCH;


	IF OBJECT_ID('tempdb..#T_SCP0095_CELLMODEL_DATA') IS NOT NULL
		DROP TABLE #T_SCP0095_CELLMODEL_DATA;
	IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_DATA') IS NOT NULL
		DROP TABLE #T_SCP0095_ELEC_DATA;
	IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_DATA_ALL') IS NOT NULL
		DROP TABLE #T_SCP0095_ELEC_DATA_ALL;
	IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_DATA_EOH') IS NOT NULL
		DROP TABLE #T_SCP0095_ELEC_DATA_EOH;
	IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_DATA_EOH_SUB') IS NOT NULL
		DROP TABLE #T_SCP0095_ELEC_DATA_EOH_SUB;
	IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_DATA_SUM') IS NOT NULL
		DROP TABLE #T_SCP0095_ELEC_DATA_SUM;
	IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_LT_ETC') IS NOT NULL
		DROP TABLE #T_SCP0095_ELEC_LT_ETC;
	IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_LT_FIRST') IS NOT NULL
		DROP TABLE #T_SCP0095_ELEC_LT_FIRST;
	IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_LT_RAW') IS NOT NULL
		DROP TABLE #T_SCP0095_ELEC_LT_RAW;
	IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_PIVOT') IS NOT NULL
		DROP TABLE #T_SCP0095_ELEC_PIVOT;
	IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_PIVOT_SUM') IS NOT NULL
		DROP TABLE #T_SCP0095_ELEC_PIVOT_SUM;
	IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_RAW_EOH') IS NOT NULL
		DROP TABLE #T_SCP0095_ELEC_RAW_EOH;
	IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_RAW') IS NOT NULL
		DROP TABLE #T_SCP0095_ELEC_RAW;
	IF OBJECT_ID('tempdb..#T_SCP0095_ELEC_RAW_ALL') IS NOT NULL
		DROP TABLE #T_SCP0095_ELEC_RAW_ALL;
	IF OBJECT_ID('tempdb..#T_SCP0095_EOH_FINAL') IS NOT NULL
		DROP TABLE #T_SCP0095_EOH_FINAL;
	IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW') IS NOT NULL
		DROP TABLE #T_SCP0095_EOH_RAW;
	IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW_DATE_SUB1') IS NOT NULL
		DROP TABLE #T_SCP0095_EOH_RAW_DATE_SUB1;
	IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW_DATE_SUB2') IS NOT NULL
		DROP TABLE #T_SCP0095_EOH_RAW_DATE_SUB2;
	IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW_DATE_SUB3') IS NOT NULL
		DROP TABLE #T_SCP0095_EOH_RAW_DATE_SUB3;
	IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW_DATE_SUB4') IS NOT NULL
		DROP TABLE #T_SCP0095_EOH_RAW_DATE_SUB4;
	IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW_DATE_SUB5') IS NOT NULL
		DROP TABLE #T_SCP0095_EOH_RAW_DATE_SUB5;
	IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW_SUB') IS NOT NULL
		DROP TABLE #T_SCP0095_EOH_RAW_SUB;
	IF OBJECT_ID('tempdb..#T_SCP0095_EOH_RAW_SUM') IS NOT NULL
		DROP TABLE #T_SCP0095_EOH_RAW_SUM;
	IF OBJECT_ID('tempdb..#T_SCP0095_FETCH_DATA_LAST_MONTH_DAY') IS NOT NULL
		DROP TABLE #T_SCP0095_FETCH_DATA_LAST_MONTH_DAY;
	IF OBJECT_ID('tempdb..#T_SCP0095_FETCH_DATA_LAST_WEEK_DAY') IS NOT NULL
		DROP TABLE #T_SCP0095_FETCH_DATA_LAST_WEEK_DAY;
	IF OBJECT_ID('tempdb..#T_SCP0095_MEASURE') IS NOT NULL
		DROP TABLE #T_SCP0095_MEASURE;
	--IF OBJECT_ID('tempdb..#T_SCP0095_PKG_PLAN') IS NOT NULL
	--	DROP TABLE #T_SCP0095_PKG_PLAN;
END
