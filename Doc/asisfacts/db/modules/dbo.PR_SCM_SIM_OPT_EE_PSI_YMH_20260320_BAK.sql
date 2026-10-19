


-- ==========================================================================================
-- Program:      PR_SCM_SIM_OPT_EE_PSI
-- Author:       김준규
-- Create date:  2025-11-19
-- Description:  SCM_SIM_DYN_COLS 테이블의 데이터를 조회하여 RETURN한다.
-- How to Execute: EXEC PR_SCM_SIM_OPT_EE_PSI @P_SNAP_YYYYMMDD='20251117',@P_REPORT_TITLE='PSI_DETAIL',@P_MAX_COLS_NUM='190';
--    EXEC PR_SCM_SIM_OPT_EE_PSI @P_SNAP_YYYYMMDD='20251117',@P_REPORT_TITLE='PSI_RECENT_PLAN',@P_MAX_COLS_NUM='10';
/*

DECLARE @V_RETVAL INT ;
DECLARE @V_STATUS INT ;
DECLARE @V_MSG    NVARCHAR(MAX);    
EXEC @V_RETVAL = [PR_SCM_SIM_OPT_EE_PSI] 
     @P_USER_ID='TEST_simulator'
    ,@P_SNAP_YYYYMMDD='20251201'
    ,@P_REPORT_TITLE='PR_SCM_SIM_OPT_EE_PSI_PSI_DETAL'
    ,@P_PLANT_ID='NB01'--NA00 NB01
    ,@P_PLAN_GROUP='ESNB'
    ,@P_DIVISION_ID = 'EE'
    ,@P_PLAN_TYPE = 'PR'
    ,@P_PLAN_SEQ = '1'
    ,@P_ITEM_ID_PLANT_IDS='APCAN2829A,APCCA2947A,APCAN1310A'
    ,@P_UseProd='N'
    ,@X_STATUS=@V_STATUS OUTPUT 
    ,@X_MSG=@V_MSG OUTPUT 
PRINT '@V_RETVAL:'+TRY_CONVERT(NVARCHAR(MAX),@V_RETVAL);
PRINT '@V_STATUS:'+TRY_CONVERT(NVARCHAR(MAX),@V_STATUS);
PRINT '@V_MSG:'+TRY_CONVERT(NVARCHAR(MAX),@V_MSG);

*/
-- ==========================================================================================
-- 2025-11-19       김준규       최초 릴리즈 후보
-- 2025-11-30       김준규       우측추가 (CASE WHEN DB_NAME()='LGCE_SCMPROD' THEN '[LGCE_FP_TR].[DBO].' ELSE '[LGCE_FPDEV_TR].[DBO].' END)
-- 2025-11-30       김준규       Coating Speed에 PROD_PLAN_AMEND의 FACTORY와 PROD LINE을 동일한 이름 갯수 만큼 추가
-- 2025-11-30       김준규       RESOURCE LABEL 2라인 PSI DETAIL과 유사 2개 라인 추가
-- 2025-12-04       김준규       HOLD RELEASE 추가
-- 2025-12-04       김준규       ITEM별 BOH 추가
-- 2025-12-05       김준규       PKG_PLAN 숫자 재 확인
-- 2025-12-08       김준규       PROD_PLAN_AMEND 숫자를 cell 환산 숫자로 표시한다.
-- 2025-12-09       김준규       LINE_ID를 못가져와서 문제발생 PROD_PLAN_AMEND의 ELECTRODE_TYPE과 LINE_M의 ELECTRODE_TYPE이 다름
-- 2025-12-11       김준규       BOH 항목 출력 Elec Site,Assy Site,Intransit,HD,TTL 추가;
-- 2025-12-12       김준규       저장을 위해 저장에 필요한 값 추가 적재()
-- 2025-12-16       김준규       RESOURCE의 LINE별 CHANGE TIME 추가
-- 2025-12-19       김준규       Elec Yield등 날짜와 MEASURE WHERE 조건에 누락된 것 추가
-- 2025-12-20       김준규       실시간 작업이라서 ERROR를 OUTPUT으로 전달하고 BATCH JOB LOG에는 에러로 하지않고 END 로 처리
-- 2025-12-22       김준규       PROD_PLAN_AMEND,Tact Time, Coating Speed의 반복 숫자를 10->30->10으로 수정(과거이력 확인 item,line 카운트시 Max 5개)
-- 2025-12-23       김준규       BOH5(TTL) 처리
-- 2026-01-07       김준규       1개의 PLANT_ID에 두사람 사용으로 파라메터 추가, TABLE_KEY 변경 및 입력,삭제 변경
-- 2026-01-10       김준규       ITEM_ID를 PLANT와 두개로 입력, 파라메터를 COMPANY_ID를 PLAN_GROUP으로 변경
-- 2026-01-11       김준규       LINE_ID를 PLAN_GROUP에 설정된 모든 것을 ITEM마다 추가
-- 2026-01-11       김준규       PROD_PLAN_AMEND,Tact Time, Coating Speed의 반복 숫자를 10->30->10->30으로 수정(과거이력 확인 item,line 카운트시 Max 5개)->LINE_ID를 PLAN_GROUP에 설정된 모든 것을 ITEM마다 추가
-- 2026-01-19       김준규       쿼리 속도 문제로 JOIN을 ITEM_ID,PLANT_ID 두개로 하다가 ITEM_ID 1개로 하고 마지막 부분에 PLANT_ID 만 별로도 JOIN 되는 것만 쿼리
-- 2026-01-21       김준규       APCAN2735A 최적화 not in 되어 있는 것 포함으로 변경
-- 2026-01-21       김준규       튜닝
-- 2026-01-24       김준규       PKG_PLAN에 타 사이트 숫자 포함 방지
-- 2026-02-02       김준규       TACT TIME, YIELD의 시작일자를 GETDATE() --> @QUERY_START_YYYYMMDD로 변경
-- 2026-02-03       김준규       PKG_PLAN 구할때 SCP_OPT_ENG_DEMAND_ORIGIN의 PLANT_ID 조건 걸면 안됨 EE 생산된게 타 PLANT로도 나가기 때문에
-- 2026-02-03       김준규       PLAN_ID를 가장최신 IF 한 것 선택하도록 변경
-- 2026-02-09       김준규       전주 4주 실적 추가, 생산실적만 존재, 생산가능 라인없는 것 ^X 부여하고 입력불가 처리
-- 2026-02-10       김준규       최적화 개별 ITEM 사용하는 로직 추가, 전체 튜닝 TEMP 테이블 사용
-- 2026-03-02       김준규       데이터 생성시점에 LINE_ID 추가시 ITEM동일한 경우 모두가 아니라 ITEM 및 PLANT가 동일할 경우 추가
-- 2026-03-18       박원채       [E20260316-000148] Coating Yield 메져 추가

---------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[PR_SCM_SIM_OPT_EE_PSI_YMH_20260320_BAK]
    @P_USER_ID       nvarchar(30) = ''
   ,@P_SNAP_YYYYMMDD nvarchar(8) = ''
   ,@P_REPORT_TITLE  nvarchar(254) = ''
   ,@P_MAX_COLS_NUM  INT = 800
   ,@P_PLANT_ID      nvarchar(30) = ''
   ,@P_PLAN_GROUP    nvarchar(100) = ''
   ,@P_DIVISION_ID   nvarchar(30) = ''
   --,@P_PLAN_START_YYYYMMDD   nvarchar(8) = ''
   ,@P_PLAN_TYPE     nvarchar(30) = ''
   ,@P_PLAN_SEQ      INT
   ,@P_OPT_PLAN_ID   nvarchar(MAX) = '' --'A,B,C'
   --,@P_ITEM_IDS      nvarchar(MAX) = ''
   ,@P_ITEM_ID_PLANT_IDS nvarchar(MAX) = ''
   ,@X_STATUS        INT OUTPUT           -- OUTPUT
   ,@X_MSG           NVARCHAR(200) OUTPUT -- OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    --SET XACT_ABORT ON;
--################################################################################################################
--DECLARE
--################################################################################################################
    DECLARE @CNT BIGINT;
    DECLARE @WORK_SECOND BIGINT;
    DECLARE @MAPPING_RESULT NVARCHAR(2);
    DECLARE @BATCH_RUN_TIME BIGINT;
    DECLARE @BATCH_START_TIME DATETIME;
    DECLARE @BATCH_END_TIME DATETIME;
    DECLARE @RUN_TIME BIGINT;
    DECLARE @START_TIME DATETIME;
    DECLARE @END_TIME DATETIME;
    DECLARE @YYYYMM nvarchar(10) = '';
    DECLARE @DUMMY NVARCHAR(MAX);
    DECLARE @crlf  CHAR(2) = CHAR(13) + CHAR(10);
    DECLARE @pos   INT;
    DECLARE @DBPrefix NVARCHAR(254);
    DECLARE @DBOPTPrefix NVARCHAR(254);
    DECLARE @DBFPPrefix NVARCHAR(254);
    SET @DBPrefix = CASE WHEN 1=2 THEN '' ELSE '[DBO].' END; 
    SET @DBOPTPrefix = CASE WHEN 1=2 THEN '' ELSE '[OPTENG_SCP].[DBO].' END;
--	SET @DBFPPrefix = CASE WHEN 1=2 THEN '' ELSE '[LGCE_FPDEV_TR].[DBO].'  END;
    SET @DBFPPrefix = CASE 
						WHEN (OBJECT_ID('[LGCE_FP_TR].[DBO].SCM_YIELD_M', 'U') IS NOT NULL) 
							THEN '[LGCE_FP_TR].[DBO].' 
							ELSE '[LGCE_FPDEV_TR].[DBO].' 
					  END;
    SET @CNT = 0;
    SET @RUN_TIME = 0;

    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_online_user NVARCHAR(150) = IIF(ISNULL(@P_USER_ID,'')='','simulator',@P_USER_ID);
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_SIM_OPT_EE_PSI';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '@P_USER_ID:'+@P_USER_ID+',@P_SNAP_YYYYMMDD:'+@P_SNAP_YYYYMMDD+',@P_PLAN_TYPE:'+@P_PLAN_TYPE+',@P_PLAN_SEQ:'+CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ)+',@P_OPT_PLAN_ID:'+CONVERT(NVARCHAR(MAX),@P_OPT_PLAN_ID)+',@P_REPORT_TITLE:'+@P_REPORT_TITLE+',@P_MAX_COLS_NUM:'+CONVERT(NVARCHAR(MAX),@P_MAX_COLS_NUM)+',@P_PLANT_ID:'+@P_PLANT_ID+',@P_PLAN_GROUP:'+@P_PLAN_GROUP+',@P_DIVISION_ID:'+@P_DIVISION_ID+',@P_ITEM_ID_PLANT_IDS:'+ @P_ITEM_ID_PLANT_IDS;
    SET @d_event_date = SYSDATETIME();
    SET @BATCH_START_TIME = SYSDATETIME();
    SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, '0',@v_description, @START_TIME;

BEGIN TRY

PRINT '--A@X#001--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'140');

    DECLARE @V_ITEM_ID_PLANT_IDS NVARCHAR(MAX) = @P_ITEM_ID_PLANT_IDS;

    SET @p_division_id = CASE WHEN ISNULL(@p_division_id,'')='' THEN 'EE' ELSE @p_division_id END;

    --시작일 구한다.
    DECLARE @QUERY_START_YYYYMMDD NVARCHAR(8);
    SELECT  @QUERY_START_YYYYMMDD = BASIS_YYYYMMDD FROM   dbo.SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
    WHERE  1=1
    AND    CM.DAYOFWEEK = 'MON'
    AND    @P_SNAP_YYYYMMDD BETWEEN CM.BASIS_START_DATE AND CM.BASIS_END_DATE;

    PRINT '@QUERY_START_YYYYMMDD:'+@QUERY_START_YYYYMMDD;
    --종료일에 7일을 더해서 구한다. 
    --2025-12-18 마지막 주차 변경용 입력시 에러나기에 종료일 그대로 사용
    DECLARE @QUERY_END_YYYYMMDD NVARCHAR(8);

    SET @QUERY_END_YYYYMMDD = 
       (SELECT CONVERT(NVARCHAR(8),DATEADD(DAY, 0, p.horizon_end_date),112) AS QUERY_END_YYYYMMDD
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id
        AND    p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK) WHERE division_id = @p_division_id and plan_id < 9999)
        AND    p.plan_cycle  = 'WEEKLY');

    DECLARE @V_REPORT_TITLE_PSI_DETAIL NVARCHAR(256)=@P_REPORT_TITLE;
    DECLARE @V_REPORT_TITLE_RESOURCE NVARCHAR(256)=@P_REPORT_TITLE+N'_RESOURCE';
    DECLARE @CNT_DEL_REPORT_TITLE INT = 2;
    DECLARE @i INT = 1;
    DECLARE @DEL_REPORT_TITLE NVARCHAR(300);

    WHILE @i <= @CNT_DEL_REPORT_TITLE BEGIN
        IF @i = 1 BEGIN SET @DEL_REPORT_TITLE = @V_REPORT_TITLE_PSI_DETAIL; END; 
        IF @i = 2 BEGIN SET @DEL_REPORT_TITLE = @V_REPORT_TITLE_RESOURCE; END; 
        PRINT '@DEL_REPORT_TITLE:'+CONVERT(NVARCHAR(MAX),@i)+ISNULL(@DEL_REPORT_TITLE,'NULL');
        DELETE SCM_SIM_DYN_COLS
        WHERE  SNAP_YYYYMMDD  = @P_SNAP_YYYYMMDD
        AND    REPORT_TITLE   = @DEL_REPORT_TITLE
        AND    ISNULL(PLANT_ID   ,'') = ISNULL(@P_PLANT_ID   ,'')
        AND    ISNULL(PLAN_GROUP ,'') = ISNULL(@P_PLAN_GROUP ,'')
        AND    ISNULL(DIVISION_ID,'') = ISNULL(@P_DIVISION_ID,'')
        AND    CREATED_BY = @v_online_user
        ;
        SET @i = @i + 1;
    END;

    PRINT '@P_SNAP_YYYYMMDD:'+ISNULL(@P_SNAP_YYYYMMDD,'NULL');
    PRINT '@P_REPORT_TITLE:'+ISNULL(@P_REPORT_TITLE,'NULL');
    PRINT '@P_PLANT_ID:'+ISNULL(@P_PLANT_ID,'NULL');
    PRINT '@P_PLAN_GROUP:'+ISNULL(@P_PLAN_GROUP,'NULL');
    PRINT '@P_DIVISION_ID:'+ISNULL(@P_DIVISION_ID,'NULL');
    PRINT '@P_PLAN_TYPE:'+ISNULL(@P_PLAN_TYPE,'NULL');
    PRINT '@P_PLAN_SEQ:'+ISNULL(CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ),'NULL');
    PRINT '@P_ITEM_ID_PLANT_IDS:'+ISNULL(@P_ITEM_ID_PLANT_IDS,'NULL');
    
    PRINT CONCAT('@P_SNAP_YYYYMMDD:',ISNULL(@P_SNAP_YYYYMMDD,'NULL')
                ,',@P_REPORT_TITLE:',ISNULL(@P_REPORT_TITLE,'NULL')
                ,',@P_PLANT_ID:',ISNULL(@P_PLANT_ID,'NULL')
                ,',@P_PLAN_GROUP:',ISNULL(@P_PLAN_GROUP,'NULL')
                ,',@P_DIVISION_ID:',ISNULL(@P_DIVISION_ID,'NULL')
                ,',@P_PLAN_TYPE:',ISNULL(@P_PLAN_TYPE,'NULL')
                ,',@P_PLAN_SEQ:',ISNULL(CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ),'NULL')
                ,',@P_ITEM_ID_PLANT_IDS:',ISNULL(@P_ITEM_ID_PLANT_IDS,'NULL'));
    --------------------------------------------------------
    -- 1. 고정 컬럼 정의 (@ColumnCount 값에 따라)
    --------------------------------------------------------
    DECLARE @SELECT_COLS INT = 800;
    SET @SELECT_COLS = (CASE WHEN (ISNULL(@P_MAX_COLS_NUM,'') = '' OR @P_MAX_COLS_NUM >= 800) THEN 800 ELSE @P_MAX_COLS_NUM END)

    DECLARE @CountOutput INT;
    DECLARE @SELCOL NVARCHAR(MAX) = '';
    DECLARE @INSCOL NVARCHAR(MAX) = '';
    DECLARE @SQL NVARCHAR(MAX) = '';
    SET @i = 1;
    
    -- WEEK 표시 구간
    DECLARE @PIVOT_COLS NVARCHAR(MAX) = '';
    DECLARE @PIVOT_COLS_WITH_ALIAS NVARCHAR(MAX) = '';
    DECLARE @INSERT_SELECT_COLS NVARCHAR(MAX) = '';
    DECLARE @INSERT_NULL_SELECT_COLS NVARCHAR(MAX) = '';

    DROP TABLE IF EXISTS #TMP_CALENDAR; 
    IF OBJECT_ID('tempdb..#TMP_CALENDAR') IS NOT NULL BEGIN DROP TABLE #TMP_CALENDAR; END;

    SELECT --TOP 17 
           CM.BASIS_YYYYMMDD
          ,CM.BASIS_YYYYMM
          ,CM.ISO_YYYYWW
          ,CM.WEEK_NAME
          ,CM.PARTIAL_WEEK_NAME
          ,CM.PARTIAL_YN
          ,CM.BASIS_START_DATE
          ,CM.BASIS_END_DATE
          ,DAY_PER_WEEK=COUNT(*)OVER(PARTITION BY CM.BASIS_START_DATE)
    INTO   #TMP_CALENDAR
    FROM   dbo.SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
    WHERE  1=1
    --AND    CM.DAYOFWEEK = 'MON' CONVERT(VARCHAR(8),DATEADD(WEEK, -4, '20260202'),112)
    --AND    CM.BASIS_START_DATE>=@QUERY_START_YYYYMMDD --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
    AND    CM.BASIS_START_DATE>= CONVERT(VARCHAR(8),DATEADD(WEEK, -4, @QUERY_START_YYYYMMDD ),112) --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
    AND    CM.BASIS_YYYYMMDD <= @QUERY_END_YYYYMMDD--CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112) --2년 후 + 7일

    --SELECT * FROM #TMP_CALENDAR ORDER BY BASIS_START_DATE;
    SET @SQL = N'
    SELECT --TOP 17 
           CM.BASIS_YYYYMMDD
          ,CM.BASIS_YYYYMM
          ,CM.ISO_YYYYWW
          ,CM.WEEK_NAME
          ,CM.PARTIAL_WEEK_NAME
          ,CM.PARTIAL_YN
          ,CM.BASIS_START_DATE
          ,CM.BASIS_END_DATE
          ,DAY_PER_WEEK=COUNT(*)OVER(PARTITION BY CM.BASIS_START_DATE)
    INTO   #TMP_CALENDAR
    FROM   dbo.SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
    WHERE  1=1
    --AND    CM.DAYOFWEEK = ''MON'' CONVERT(VARCHAR(8),DATEADD(WEEK, -4, ''20260202''),112)
    --AND    CM.BASIS_START_DATE>=@QUERY_START_YYYYMMDD --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
    AND    CM.BASIS_START_DATE>= CONVERT(VARCHAR(8),DATEADD(WEEK, -4, '''+@QUERY_START_YYYYMMDD+''' ),112) --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
    AND    CM.BASIS_YYYYMMDD <= '''+@QUERY_END_YYYYMMDD+'''--CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112) --2년 후 + 7일 ';

    --프린트만한다
    PRINT @SQL;


    DROP TABLE IF EXISTS #TMP_PLAN_CALENDAR; 
    IF OBJECT_ID('tempdb..#TMP_PLAN_CALENDAR') IS NOT NULL BEGIN DROP TABLE #TMP_PLAN_CALENDAR; END;

    SELECT --TOP 17 
           CM.BASIS_YYYYMMDD
          ,CM.BASIS_YYYYMM
          ,CM.ISO_YYYYWW
          ,CM.WEEK_NAME
          ,CM.PARTIAL_WEEK_NAME
          ,CM.PARTIAL_YN
          ,CM.BASIS_START_DATE
          ,CM.BASIS_END_DATE
          ,DAY_PER_WEEK=COUNT(*)OVER(PARTITION BY CM.BASIS_START_DATE)
    INTO   #TMP_PLAN_CALENDAR
    FROM   dbo.SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
    WHERE  1=1
    --AND    CM.DAYOFWEEK = 'MON' CONVERT(VARCHAR(8),DATEADD(WEEK, -4, '20260202'),112)
    --AND    CM.BASIS_START_DATE>=@QUERY_START_YYYYMMDD --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
    AND    CM.BASIS_START_DATE>= @QUERY_START_YYYYMMDD --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
    AND    CM.BASIS_YYYYMMDD <= @QUERY_END_YYYYMMDD--CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112) --2년 후 + 7일

    --SELECT * FROM #TMP_PLAN_CALENDAR ORDER BY BASIS_START_DATE;

    SET @SQL = N'
    SELECT --TOP 17 
           CM.BASIS_YYYYMMDD
          ,CM.BASIS_YYYYMM
          ,CM.ISO_YYYYWW
          ,CM.WEEK_NAME
          ,CM.PARTIAL_WEEK_NAME
          ,CM.PARTIAL_YN
          ,CM.BASIS_START_DATE
          ,CM.BASIS_END_DATE
          ,DAY_PER_WEEK=COUNT(*)OVER(PARTITION BY CM.BASIS_START_DATE)
    INTO   #TMP_PLAN_CALENDAR
    FROM   dbo.SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
    WHERE  1=1
    --AND    CM.DAYOFWEEK = ''MON'' CONVERT(VARCHAR(8),DATEADD(WEEK, -4, ''20260202''),112)
    --AND    CM.BASIS_START_DATE>='''+@QUERY_START_YYYYMMDD+''' --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
    AND    CM.BASIS_START_DATE>= '''+@QUERY_START_YYYYMMDD+''' --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
    AND    CM.BASIS_YYYYMMDD <= '''+@QUERY_END_YYYYMMDD+'''--CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112) --2년 후 + 7일 ';

    --프린트만한다
    PRINT @SQL;

    -- PIVOT IN 절에 사용할 컬럼 리스트 생성
    SELECT @PIVOT_COLS = STRING_AGG(QUOTENAME(CONVERT(VARCHAR(8), BASIS_START_DATE, 112)), ',')
    FROM   ( SELECT DISTINCT BASIS_START_DATE FROM #TMP_CALENDAR ) TC
    --GROUP BY BASIS_START_DATE
    --ORDER BY BASIS_START_DATE;

    -- PIVOT SELECT 절에 사용할 컬럼 생성
    SELECT @PIVOT_COLS_WITH_ALIAS = STRING_AGG(
        QUOTENAME(CONVERT(VARCHAR(8), BASIS_START_DATE, 112)) +
        N' AS [' + N'P'+CONVERT(VARCHAR(8), BASIS_START_DATE, 112) + N']',
        N', ')
    FROM   ( SELECT DISTINCT BASIS_START_DATE FROM #TMP_CALENDAR ) TC

    --  SCM_SIM_DYN_COLS 테이블에 PIVOT INSERT 할 컬럼 생성
    SELECT @INSERT_SELECT_COLS = STRING_AGG(
        N'CONVERT(VARCHAR(MAX),'+QUOTENAME(N'P'+CONVERT(VARCHAR(8), BASIS_START_DATE, 112))+N')' +
        N' AS [' + N'P'+CONVERT(VARCHAR(8), BASIS_START_DATE, 112) + N']',
        N', ')
    FROM   ( SELECT DISTINCT BASIS_START_DATE FROM #TMP_CALENDAR ) TC

    
    --  4 BOH에 ZERO INSERT 할 컬럼 생성
    SELECT @INSERT_NULL_SELECT_COLS = STRING_AGG(
        N'CONVERT(VARCHAR(MAX), NULL )' +
        N' AS [' + N'P'+CONVERT(VARCHAR(8), BASIS_START_DATE, 112) + N']',
        N', ')
    FROM   ( SELECT DISTINCT BASIS_START_DATE FROM #TMP_CALENDAR ) TC

    --PRINT '@PIVOT_COLS:'+@PIVOT_COLS;
    --PRINT '@PIVOT_COLS_WITH_ALIAS:'+@PIVOT_COLS;

    --########################################################
    --선두에 값이 아닌 것 입력되어야 하는 컬럼 갯수
    -------------------------------------------
    DECLARE @INS_COL_NUM INT = 20;--WEEK WQTY1~이런 형태 앞에 DIVISION C1,C2 이런형태 입력되는 것.
    DECLARE @INS_POSTFIX_COL_NUM INT = 0; --WEEK WQTY1~이런 형태 입력되는 것 이후에 입력되는 것
    --########################################################
    --
    SELECT @SELECT_COLS = COUNT(*) FROM ( SELECT DISTINCT BASIS_START_DATE FROM #TMP_CALENDAR ) X;
    --PRINT '@SELECT_COLS:'+CONVERT(NVARCHAR(MAX),@SELECT_COLS);
    -- C1 부터 C(@SELECT_COLS) 까지 컬럼명 동적 생성
    SET @i = 1;
    WHILE @i <= @SELECT_COLS+@INS_COL_NUM
    BEGIN
        IF @i = 1
            SET @INSCOL = N'C' + CAST(@i AS NVARCHAR(10));
        ELSE
            SET @INSCOL = @INSCOL + N', C' + CAST(@i AS NVARCHAR(10));

        SET @i = @i + 1;
    END
    --PRINT '@INSCOL:'+@INSCOL;

    --######################################################
    --LABEL1 LABEL1 LABEL2 LABEL2 동시에 사용
    --######################################################
    DROP TABLE IF EXISTS #TMP_WEEK_NAME_LABEL;
    IF OBJECT_ID('tempdb..#TMP_WEEK_NAME_LABEL') IS NOT NULL BEGIN DROP TABLE #TMP_WEEK_NAME_LABEL; END;
    WITH W_CAL AS(
        SELECT BASIS_START_DATE_GR =BASIS_START_DATE
              ,WEEK_NAME = MAX(WEEK_NAME)
              ,PARTIAL_WEEK_NAME = MAX(PARTIAL_WEEK_NAME)
              ,ISO_YYYYWW = MAX(ISO_YYYYWW)
              ,BASIS_START_DATE =MIN(BASIS_START_DATE)
              ,BASIS_END_DATE =MAX(BASIS_END_DATE)
              ,BASIS_START_END_DATE = MIN(BASIS_START_DATE)+'~'+MAX(BASIS_END_DATE)
              ,DAY_PER_WEEK=MAX(DAY_PER_WEEK)
        FROM (
            SELECT --TOP 17
                   DISTINCT CM.WEEK_NAME
                  ,CM.PARTIAL_WEEK_NAME
                  ,CM.ISO_YYYYWW
                  ,CM.BASIS_START_DATE
                  ,CM.BASIS_END_DATE
                  ,DAY_PER_WEEK=COUNT(*)OVER(PARTITION BY CM.BASIS_START_DATE)
            --INTO   #TMP_CALENDAR
            FROM   dbo.SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
            WHERE  1=1
            --AND    CM.DAYOFWEEK = 'MON'
            AND    CM.BASIS_START_DATE>= CONVERT(VARCHAR(8),DATEADD(WEEK, -4, @QUERY_START_YYYYMMDD ),112)  --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
            AND    CM.BASIS_YYYYMMDD <= @QUERY_END_YYYYMMDD--CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112) --2년 후 + 7일
        ) X
        GROUP BY BASIS_START_DATE
    )
    , W_CAL_RST AS (
        SELECT BASIS_START_DATE_GR,WEEK_NAME,PARTIAL_WEEK_NAME,ISO_YYYYWW,BASIS_START_DATE,BASIS_END_DATE,BASIS_START_END_DATE,DAY_PER_WEEK
        FROM   W_CAL
    )
    --SELECT *FROM W_CAL_RST;
    SELECT RNUM = ROW_NUMBER() OVER (ORDER BY BASIS_START_DATE)
          ,BASIS_WQTY_WEEK='WQTY'+CONVERT(NVARCHAR(MAX),DENSE_RANK() OVER (ORDER BY ISO_YYYYWW))+CASE WHEN ISNULL(SUBSTRING(PARTIAL_WEEK_NAME,4,1),'') <> '' THEN '_'+SUBSTRING(PARTIAL_WEEK_NAME,4,1) ELSE '' END
          ,BASIS_START_END_DATE=SUBSTRING(BASIS_START_DATE,5,2)+'.'+SUBSTRING(BASIS_START_DATE,7,2)+'~'+SUBSTRING(BASIS_END_DATE,5,2)+'.'+SUBSTRING(BASIS_END_DATE,7,2)
          ,PARTIAL_WEEK_NAME
          ,DAY_PER_WEEK
          ,BASIS_START_DATE
          ,FILL_VAL_BLANK=''
    INTO   #TMP_WEEK_NAME_LABEL
    FROM   W_CAL_RST
    ORDER BY RNUM;

    --SELECT *FROM #TMP_WEEK_NAME_LABEL;
    -- @TotalRows --WEEK WQTY1~이런 형태 입력되는 것
    DECLARE @TotalRows INT = (SELECT COUNT(*) FROM #TMP_WEEK_NAME_LABEL); ----WEEK WQTY1~이런 형태 입력되는 것
    PRINT '@TotalRows LABEL2:'+CONVERT(NVARCHAR(MAX),@TotalRows);
    DECLARE @INSERT_SELECT_LABEL1 NVARCHAR(MAX) = '';

    SELECT @INSERT_SELECT_LABEL1 = STRING_AGG(QUOTENAME(BASIS_WQTY_WEEK,''''), ',') WITHIN GROUP (ORDER BY RNUM)
    FROM   #TMP_WEEK_NAME_LABEL;


    --######################################################
    --LABEL1 LABEL1
    --######################################################
    DECLARE @INS_LABEL1 NVARCHAR(MAX) = '';
    SET @i =1;
    WHILE @i <= (@INS_COL_NUM+@TotalRows) --@TotalRows --WEEK WQTY1~이런 형태 입력되는 것
    BEGIN
        IF @i = 1
            SET @INS_LABEL1 = 'C' + CAST(@i AS NVARCHAR(10));
        ELSE
            SET @INS_LABEL1 = @INS_LABEL1 + ', C' + CAST(@i AS NVARCHAR(10));

        SET @i = @i + 1;
    END
    --PRINT '@INS_LABEL1:'+@INS_LABEL1;

    --######################################################
    --LABEL1 POSTIFIX LABEL1
    --######################################################
    IF @INS_POSTFIX_COL_NUM <> 0 BEGIN
        DECLARE @INS_POSTFIX_LABEL1 NVARCHAR(MAX) = '';
        SET @i =(@INS_COL_NUM+@TotalRows+1);
        WHILE @i <= (@INS_COL_NUM+@TotalRows+@INS_POSTFIX_COL_NUM)
        BEGIN
            IF @i = (@INS_COL_NUM+@TotalRows+1)
                SET @INS_POSTFIX_LABEL1 = 'C' + CAST(@i AS NVARCHAR(10));
            ELSE
                SET @INS_POSTFIX_LABEL1 = @INS_POSTFIX_LABEL1 + ', C' + CAST(@i AS NVARCHAR(10));
        
            SET @i = @i + 1;
        END
    --PRINT '@INS_POSTFIX_LABEL1:'+@INS_POSTFIX_LABEL1;
    END;

    DECLARE @SQL_LABEL1 NVARCHAR(MAX) = '';
    SET @SQL_LABEL1 = N'
    INSERT INTO SCM_SIM_DYN_COLS(
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,PLAN_GROUP
       ,DIVISION_ID
       ,'+@INS_LABEL1 +'';
    IF @INS_POSTFIX_COL_NUM <> 0 BEGIN
    SET @SQL_LABEL1 += N'
       ,'+@INS_POSTFIX_LABEL1+'';
    END;
    SET @SQL_LABEL1 += N'
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT '''+@P_SNAP_YYYYMMDD+N'''
       ,'''+@V_REPORT_TITLE_PSI_DETAIL+N'''
       ,'''+@P_PLANT_ID+'''
       ,'''+@P_PLAN_GROUP+'''
       ,'''+@P_DIVISION_ID+N'''
       ,''DIVISION'' AS C1,''PLAN START YYYYMMDD'' AS C2,''PLAN TYPE'' AS C3,''SEQ'' AS C4,''SUPPLY SITE'' AS C5,''SUPPLY SITE DESC'' AS C6,''NICK NAME'' AS C7,''ITEM ID'' AS C8,''ELECTRODE TYPE'' AS C9,''CONVERT QTY CELL'' AS C10,''FACTORY'' AS C11,''PROD LINE'' AS C12,''PSI TYPE'' AS C13,''MEASURE'' AS C14,''BOH'' AS C15,''BOH'' AS C16,''BOH'' AS C17,''BOH'' AS C18,''BOH'' AS C19,''UNIT'' AS C20
       ,'+@INSERT_SELECT_LABEL1+'
       , 10 AS SORT_SEQ1
       ,'''+@v_online_user+N'''
       ,'''+@v_online_user+N''' ';

    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @SQL_LABEL1;
    --WHILE LEN(@DUMMY) > 0
    --BEGIN
    --    SET @pos = CHARINDEX(@crlf, @DUMMY);
    --    IF @pos > 0
    --    BEGIN
    --        PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
    --        SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
    --    END
    --    ELSE
    --    BEGIN
    --        PRINT @DUMMY;
    --        SET @DUMMY = '';
    --    END;
    --END;
    EXEC sp_executesql @SQL_LABEL1;

    --#########################################
    --LABEL2 LABEL2
    --######################################################
    --DECLARE @TotalRows INT = (SELECT COUNT(*) FROM #TMP_WEEK_NAME_LABEL);
    PRINT '@TotalRows LABEL2:'+CONVERT(NVARCHAR(MAX),@TotalRows); --@TotalRows --WEEK WQTY1~이런 형태 입력되는 것
    DECLARE @INSERT_SELECT_LABEL2_PREFIX NVARCHAR(MAX) = 'Elec Site,Assy Site,Intransit,HD,TTL,';
    DECLARE @INSERT_SELECT_LABEL2 NVARCHAR(MAX) = '';

    SELECT @INSERT_SELECT_LABEL2 = dbo.FN_GET_NERP_IN_VALUES(@INSERT_SELECT_LABEL2_PREFIX)+','+STRING_AGG(QUOTENAME(BASIS_START_END_DATE,''''), ',') WITHIN GROUP (ORDER BY RNUM)
    FROM   #TMP_WEEK_NAME_LABEL;

    DECLARE @INS_LABEL2 NVARCHAR(MAX) = '';
    --C21부터 184개 넣어야 한다. 
    --2025-12-11 6개의 특정한 값을 이전에 추가로 넣어야 한다.
    SET @i =(21-6);--시작을 -6부터 토탈에 6개 추가해서 작은 곳에서 추가함 
    WHILE @i <= (@TotalRows-1+21 ) --한개가 남아서 -1처리 --> C31때문에 +1을 함 2025-12-11 6개를 특정한 값을 넣어야 한다.
    BEGIN
        IF @i = (21-6)
            SET @INS_LABEL2 = 'C' + CAST(@i AS NVARCHAR(10));
        ELSE
            SET @INS_LABEL2 = @INS_LABEL2 + ', C' + CAST(@i AS NVARCHAR(10));

        SET @i = @i + 1;
    END
    --PRINT '@INS_LABEL2:'+@INS_LABEL2;


    DECLARE @SQL_LABEL2 NVARCHAR(MAX) = '';
    SET @SQL_LABEL2 = N'
    INSERT INTO SCM_SIM_DYN_COLS(
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,PLAN_GROUP
       ,DIVISION_ID
       ,'+@INS_LABEL2 +'
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT '''+@P_SNAP_YYYYMMDD+N'''
       ,'''+@V_REPORT_TITLE_PSI_DETAIL+N'''
       ,'''+@P_PLANT_ID+'''
       ,'''+@P_PLAN_GROUP+'''
       ,'''+@P_DIVISION_ID+N'''
       ,'+@INSERT_SELECT_LABEL2+'
       , 20 AS SORT_SEQ1
       ,'''+@v_online_user+N'''
       ,'''+@v_online_user+N''' ';

    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @SQL_LABEL2;
    --WHILE LEN(@DUMMY) > 0
    --BEGIN
    --    SET @pos = CHARINDEX(@crlf, @DUMMY);
    --    IF @pos > 0
    --    BEGIN
    --        PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
    --        SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
    --    END
    --    ELSE
    --    BEGIN
    --        PRINT @DUMMY;
    --        SET @DUMMY = '';
    --    END;
    --END;
    EXEC sp_executesql @SQL_LABEL2;

    --#########################################
    --LABEL3 LABEL3
    --######################################################
    --DECLARE @TotalRows INT = (SELECT COUNT(*) FROM #TMP_WEEK_NAME_LABEL3);
    PRINT '@TotalRows LABEL3:'+CONVERT(NVARCHAR(MAX),@TotalRows);
    DECLARE @INSERT_SELECT_LABEL3 NVARCHAR(MAX) = '';

    SELECT @INSERT_SELECT_LABEL3 = STRING_AGG(QUOTENAME(PARTIAL_WEEK_NAME,''''), ',') WITHIN GROUP (ORDER BY RNUM)
    FROM   #TMP_WEEK_NAME_LABEL;

    DECLARE @INS_LABEL3 NVARCHAR(MAX) = '';
    --C21부터 184개 넣어야 한다.
    SET @i =21;
    WHILE @i <= (@TotalRows-1+21) --한개가 남아서 -1처리 
    BEGIN
        IF @i = 21
            SET @INS_LABEL3 = 'C' + CAST(@i AS NVARCHAR(10));
        ELSE
            SET @INS_LABEL3 = @INS_LABEL3 + ', C' + CAST(@i AS NVARCHAR(10));

        SET @i = @i + 1;
    END
    --PRINT '@INS_LABEL3:'+@INS_LABEL3;


    DECLARE @SQL_LABEL3 NVARCHAR(MAX) = '';
    SET @SQL_LABEL3 = N'
    INSERT INTO SCM_SIM_DYN_COLS(
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,PLAN_GROUP
       ,DIVISION_ID
       ,'+@INS_LABEL3 +'
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT '''+@P_SNAP_YYYYMMDD+N'''
       ,'''+@V_REPORT_TITLE_PSI_DETAIL+N'''
       ,'''+@P_PLANT_ID+'''
       ,'''+@P_PLAN_GROUP+'''
       ,'''+@P_DIVISION_ID+N'''
       ,'+@INSERT_SELECT_LABEL3+'
       ,30 SORT_SEQ1
       ,'''+@v_online_user+N'''
       ,'''+@v_online_user+N''' ';

    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @SQL_LABEL3;
    --WHILE LEN(@DUMMY) > 0
    --BEGIN
    --    SET @pos = CHARINDEX(@crlf, @DUMMY);
    --    IF @pos > 0
    --    BEGIN
    --        PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
    --        SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
    --    END
    --    ELSE
    --    BEGIN
    --        PRINT @DUMMY;
    --        SET @DUMMY = '';
    --    END;
    --END;
    EXEC sp_executesql @SQL_LABEL3;

    --#########################################
    --LABEL4 LABEL4
    --######################################################
    --DECLARE @TotalRows INT = (SELECT COUNT(*) FROM #TMP_WEEK_NAME_LABEL4);
    PRINT '@TotalRows LABEL4:'+CONVERT(NVARCHAR(MAX),@TotalRows);
    DECLARE @INSERT_SELECT_LABEL4 NVARCHAR(MAX) = '';

    SELECT @INSERT_SELECT_LABEL4 = STRING_AGG(QUOTENAME(DAY_PER_WEEK,''''), ',') WITHIN GROUP (ORDER BY RNUM)
    FROM   #TMP_WEEK_NAME_LABEL;

    DECLARE @INS_LABEL4 NVARCHAR(MAX) = '';
    --C21부터 184개 넣어야 한다.
    SET @i =21;
    WHILE @i <= (@TotalRows-1+21) --한개가 남아서 -1처리 
    BEGIN
        IF @i = 21
            SET @INS_LABEL4 = 'C' + CAST(@i AS NVARCHAR(10));
        ELSE
            SET @INS_LABEL4 = @INS_LABEL4 + ', C' + CAST(@i AS NVARCHAR(10));

        SET @i = @i + 1;
    END
    --PRINT '@INS_LABEL4:'+@INS_LABEL4;


    DECLARE @SQL_LABEL4 NVARCHAR(MAX) = '';
    SET @SQL_LABEL4 = N'
    INSERT INTO SCM_SIM_DYN_COLS(
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,PLAN_GROUP
       ,DIVISION_ID
       ,'+@INS_LABEL4 +'
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT '''+@P_SNAP_YYYYMMDD+N'''
       ,'''+@V_REPORT_TITLE_PSI_DETAIL+N'''
       ,'''+@P_PLANT_ID+'''
       ,'''+@P_PLAN_GROUP+'''
       ,'''+@P_DIVISION_ID+N'''
       ,'+@INSERT_SELECT_LABEL4+'
       ,40 SORT_SEQ1
       ,'''+@v_online_user+N'''
       ,'''+@v_online_user+N''' ';

    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @SQL_LABEL4;
    --WHILE LEN(@DUMMY) > 0
    --BEGIN
    --    SET @pos = CHARINDEX(@crlf, @DUMMY);
    --    IF @pos > 0
    --    BEGIN
    --        PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
    --        SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
    --    END
    --    ELSE
    --    BEGIN
    --        PRINT @DUMMY;
    --        SET @DUMMY = '';
    --    END;
    --END;
    EXEC sp_executesql @SQL_LABEL4;

    
    --#########################################
    --LABEL5 LABEL5
    --######################################################
    --DECLARE @TotalRows INT = (SELECT COUNT(*) FROM #TMP_WEEK_NAME_LABEL4);
    PRINT '@TotalRows LABEL5:'+CONVERT(NVARCHAR(MAX),@TotalRows);
    DECLARE @INSERT_SELECT_LABEL5 NVARCHAR(MAX) = '';

    SELECT @INSERT_SELECT_LABEL5 = STRING_AGG(QUOTENAME(BASIS_START_DATE,''''), ',') WITHIN GROUP (ORDER BY RNUM)
    FROM   #TMP_WEEK_NAME_LABEL;

    DECLARE @INS_LABEL5 NVARCHAR(MAX) = '';
    --C21부터 184개 넣어야 한다.
    SET @i =21;
    WHILE @i <= (@TotalRows-1+21) --한개가 남아서 -1처리 
    BEGIN
        IF @i = 21
            SET @INS_LABEL5 = 'C' + CAST(@i AS NVARCHAR(10));
        ELSE
            SET @INS_LABEL5 = @INS_LABEL5 + ', C' + CAST(@i AS NVARCHAR(10));

        SET @i = @i + 1;
    END
    --PRINT '@INS_LABEL5:'+@INS_LABEL5;


    DECLARE @SQL_LABEL5 NVARCHAR(MAX) = '';
    SET @SQL_LABEL5 = N'
    INSERT INTO SCM_SIM_DYN_COLS(
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,PLAN_GROUP
       ,DIVISION_ID
       ,'+@INS_LABEL5 +'
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT '''+@P_SNAP_YYYYMMDD+N'''
       ,'''+@V_REPORT_TITLE_PSI_DETAIL+N'''
       ,'''+@P_PLANT_ID+'''
       ,'''+@P_PLAN_GROUP+'''
       ,'''+@P_DIVISION_ID+N'''
       ,'+@INSERT_SELECT_LABEL5+'
       ,50 SORT_SEQ1
       ,'''+@v_online_user+N'''
       ,'''+@v_online_user+N''' ';

    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @SQL_LABEL5;
    --WHILE LEN(@DUMMY) > 0
    --BEGIN
    --    SET @pos = CHARINDEX(@crlf, @DUMMY);
    --    IF @pos > 0
    --    BEGIN
    --        PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
    --        SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
    --    END
    --    ELSE
    --    BEGIN
    --        PRINT @DUMMY;
    --        SET @DUMMY = '';
    --    END;
    --END;
    EXEC sp_executesql @SQL_LABEL5;

    --#########################################
    --PSI DETAIL 작업
    --######################################################
    DROP TABLE IF EXISTS #TMP_W_PIV_RST_WEEK_RESULT;
    IF OBJECT_ID('tempdb..#TMP_W_PIV_RST_WEEK_RESULT') IS NOT NULL BEGIN DROP TABLE #TMP_W_PIV_RST_WEEK_RESULT; END;

PRINT '--A@X#002--' + CONVERT(NVARCHAR(30), GETDATE(), 121);


    DROP TABLE IF EXISTS #TMP_W_DAILY_SUM;
    IF OBJECT_ID('tempdb..#TMP_W_DAILY_SUM') IS NOT NULL BEGIN DROP TABLE #TMP_W_DAILY_SUM; END;

    CREATE TABLE #TMP_W_DAILY_SUM(
        DIVISION_ID         NVARCHAR(300)
       ,ORIGIN_DIVISION_ID  NVARCHAR(300)
       ,PLAN_START_YYYYMMDD NVARCHAR(300)
       ,PLAN_TYPE           NVARCHAR(300)
       ,SEQ                 INT
       ,OPERATION_GROUP     NVARCHAR(300)
       ,SCM_SITE_ID         NVARCHAR(50)
       ,SITE_DESCRIPTION    NVARCHAR(300)
       ,NICK_NAME           NVARCHAR(300)
       ,ITEM_ID             NVARCHAR(50)
       ,PSI_TYPE            NVARCHAR(300)
       ,ELECTRODE_TYPE      NVARCHAR(300)
       ,CELL_CF             NVARCHAR(300)
       ,FACTORY_ID          NVARCHAR(300)
       ,LINE_ID             NVARCHAR(50)
       ,OPERATION_ID        NVARCHAR(300)
       ,MEASURE             NVARCHAR(300)
       ,YYYYMMDD            NVARCHAR(300)
       ,QTY                 numeric(20,10)
       ,PROD_RST_ONLY_YN    NVARCHAR(5)
    );
    CREATE CLUSTERED INDEX IX01_W_DAILY_SUM ON #TMP_W_DAILY_SUM(SCM_SITE_ID, LINE_ID, ITEM_ID)
    CREATE NONCLUSTERED INDEX IX02_W_DAILY_SUM ON #TMP_W_DAILY_SUM(SCM_SITE_ID, ITEM_ID)
    CREATE NONCLUSTERED INDEX IX03_W_DAILY_SUM ON #TMP_W_DAILY_SUM(ITEM_ID)

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_W_DAILY_SUM;
    IF OBJECT_ID(''tempdb..#TMP_W_DAILY_SUM'') IS NOT NULL BEGIN DROP TABLE #TMP_W_DAILY_SUM; END;

    CREATE TABLE #TMP_W_DAILY_SUM(
        DIVISION_ID         NVARCHAR(300)
       ,ORIGIN_DIVISION_ID  NVARCHAR(300)
       ,PLAN_START_YYYYMMDD NVARCHAR(300)
       ,PLAN_TYPE           NVARCHAR(300)
       ,SEQ                 INT
       ,OPERATION_GROUP     NVARCHAR(300)
       ,SCM_SITE_ID         NVARCHAR(300)
       ,SITE_DESCRIPTION    NVARCHAR(300)
       ,NICK_NAME           NVARCHAR(300)
       ,ITEM_ID             NVARCHAR(300)
       ,PSI_TYPE            NVARCHAR(300)
       ,ELECTRODE_TYPE      NVARCHAR(300)
       ,CELL_CF             NVARCHAR(300)
       ,FACTORY_ID          NVARCHAR(300)
       ,LINE_ID             NVARCHAR(300)
       ,OPERATION_ID        NVARCHAR(300)
       ,MEASURE             NVARCHAR(300)
       ,YYYYMMDD            NVARCHAR(300)
       ,QTY                 numeric(20,10)
       ,PROD_RST_ONLY_YN    NVARCHAR(1)
    ); 
    CREATE CLUSTERED INDEX IX01_W_DAILY_SUM ON #TMP_W_DAILY_SUM(SCM_SITE_ID, LINE_ID, ITEM_ID);
    CREATE CLUSTERED INDEX IX02_W_DAILY_SUM ON #TMP_W_DAILY_SUM(SCM_SITE_ID, ITEM_ID); ';

    --PRINT @sql;
    --  프린트만
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;

    --TACT TIME 용 테이블 생성한다.
    DROP TABLE IF EXISTS #TMP_W_TACT_DEFAULT;
    IF OBJECT_ID('tempdb..#TMP_W_TACT_DEFAULT') IS NOT NULL BEGIN DROP TABLE #TMP_W_TACT_DEFAULT; END;

    CREATE TABLE #TMP_W_TACT_DEFAULT(
        DIVISION_ID         NVARCHAR(300)
       ,ORIGIN_DIVISION_ID  NVARCHAR(300)
       ,PLAN_START_YYYYMMDD NVARCHAR(300)
       ,PLAN_TYPE           NVARCHAR(300)
       ,SEQ                 INT
       ,OPERATION_GROUP     NVARCHAR(300)
       ,SCM_SITE_ID         NVARCHAR(300)
       ,SITE_DESCRIPTION    NVARCHAR(300)
       ,NICK_NAME           NVARCHAR(300)
       ,ITEM_ID             NVARCHAR(300)
       ,ELECTRODE_TYPE      NVARCHAR(300)
       ,CELL_CF             NVARCHAR(300)
       ,FACTORY_ID          NVARCHAR(300)
       ,LINE_ID             NVARCHAR(300)
       ,OPERATION_ID        NVARCHAR(300)
    );
    CREATE CLUSTERED INDEX IX01_W_TACT_DEFAULT ON #TMP_W_TACT_DEFAULT(SCM_SITE_ID, LINE_ID, ITEM_ID)

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_W_TACT_DEFAULT;
    IF OBJECT_ID(''tempdb..#TMP_W_TACT_DEFAULT'') IS NOT NULL BEGIN DROP TABLE #TMP_W_TACT_DEFAULT; END;
    CREATE TABLE #TMP_W_TACT_DEFAULT(
        DIVISION_ID         NVARCHAR(300)
       ,ORIGIN_DIVISION_ID  NVARCHAR(300)
       ,PLAN_START_YYYYMMDD NVARCHAR(300)
       ,PLAN_TYPE           NVARCHAR(300)
       ,SEQ                 INT
       ,OPERATION_GROUP     NVARCHAR(300)
       ,SCM_SITE_ID         NVARCHAR(300)
       ,SITE_DESCRIPTION    NVARCHAR(300)
       ,NICK_NAME           NVARCHAR(300)
       ,ITEM_ID             NVARCHAR(300)
       ,ELECTRODE_TYPE      NVARCHAR(300)
       ,CELL_CF             NVARCHAR(300)
       ,FACTORY_ID          NVARCHAR(300)
       ,LINE_ID             NVARCHAR(300)
       ,OPERATION_ID        NVARCHAR(300)
    ); 
    CREATE CLUSTERED INDEX IX01_W_TACT_DEFAULT ON #TMP_W_TACT_DEFAULT(SCM_SITE_ID, LINE_ID, ITEM_ID);';

    --프린트만한다
    PRINT @SQL;


-----===============================================

    --COAT YIELD 용 테이블 생성한다.
    DROP TABLE IF EXISTS #TMP_W_COAT_YIELD_DEFAULT;
    IF OBJECT_ID('tempdb..##TMP_W_COAT_YIELD_DEFAULT') IS NOT NULL BEGIN DROP TABLE #TMP_W_COAT_YIELD_DEFAULT; END;

    CREATE TABLE #TMP_W_COAT_YIELD_DEFAULT(
        DIVISION_ID         NVARCHAR(300)
       ,ORIGIN_DIVISION_ID  NVARCHAR(300)
       ,PLAN_START_YYYYMMDD NVARCHAR(300)
       ,PLAN_TYPE           NVARCHAR(300)
       ,SEQ                 INT
       ,OPERATION_GROUP     NVARCHAR(300)
       ,SCM_SITE_ID         NVARCHAR(300)
       ,SITE_DESCRIPTION    NVARCHAR(300)
       ,NICK_NAME           NVARCHAR(300)
       ,ITEM_ID             NVARCHAR(300)
       ,ELECTRODE_TYPE      NVARCHAR(300)
       ,CELL_CF             NVARCHAR(300)
       ,FACTORY_ID          NVARCHAR(300)
       ,LINE_ID             NVARCHAR(300)
       ,OPERATION_ID        NVARCHAR(300)
    );
    CREATE CLUSTERED INDEX IX01_W_COAT_YIELD_DEFAULT ON #TMP_W_COAT_YIELD_DEFAULT(SCM_SITE_ID, LINE_ID, ITEM_ID)

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_W_COAT_YIELD_DEFAULT;
    IF OBJECT_ID(''tempdb..#TMP_W_COAT_YIELD_DEFAULT'') IS NOT NULL BEGIN DROP TABLE #TMP_W_COAT_YIELD_DEFAULT; END;
    CREATE TABLE #TMP_W_COAT_YIELD_DEFAULT(
        DIVISION_ID         NVARCHAR(300)
       ,ORIGIN_DIVISION_ID  NVARCHAR(300)
       ,PLAN_START_YYYYMMDD NVARCHAR(300)
       ,PLAN_TYPE           NVARCHAR(300)
       ,SEQ                 INT
       ,OPERATION_GROUP     NVARCHAR(300)
       ,SCM_SITE_ID         NVARCHAR(300)
       ,SITE_DESCRIPTION    NVARCHAR(300)
       ,NICK_NAME           NVARCHAR(300)
       ,ITEM_ID             NVARCHAR(300)
       ,ELECTRODE_TYPE      NVARCHAR(300)
       ,CELL_CF             NVARCHAR(300)
       ,FACTORY_ID          NVARCHAR(300)
       ,LINE_ID             NVARCHAR(300)
       ,OPERATION_ID        NVARCHAR(300)
    ); 
    CREATE CLUSTERED INDEX IX01_W_COAT_YIELD_DEFAULT ON #TMP_W_COAT_YIELD_DEFAULT(SCM_SITE_ID, LINE_ID, ITEM_ID);';

    --프린트만한다
    PRINT @SQL;

-------====================================================
    --yield 및 BOH용 테이블 만든다
    DROP TABLE IF EXISTS #TMP_W_YIELD_DEFAULT;
    IF OBJECT_ID('tempdb..#TMP_W_YIELD_DEFAULT') IS NOT NULL BEGIN DROP TABLE #TMP_W_YIELD_DEFAULT; END;

    CREATE TABLE #TMP_W_YIELD_DEFAULT(
        DIVISION_ID         NVARCHAR(300)
       ,ORIGIN_DIVISION_ID  NVARCHAR(300)
       ,PLAN_START_YYYYMMDD NVARCHAR(300)
       ,OPERATION_GROUP     NVARCHAR(300)
       ,SCM_SITE_ID         NVARCHAR(300)
       ,SITE_DESCRIPTION    NVARCHAR(300)
       ,NICK_NAME           NVARCHAR(300)
       ,ITEM_ID             NVARCHAR(300)
       ,ELECTRODE_TYPE      NVARCHAR(300)
       ,CELL_CF             NVARCHAR(300)
       ,OPERATION_ID        NVARCHAR(300)
    );
    CREATE CLUSTERED INDEX IX01_W_YIELD_DEFAULT ON #TMP_W_YIELD_DEFAULT(SCM_SITE_ID, ITEM_ID)

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_W_YIELD_DEFAULT;
    IF OBJECT_ID(''tempdb..#TMP_W_YIELD_DEFAULT'') IS NOT NULL BEGIN DROP TABLE #TMP_W_YIELD_DEFAULT; END;

    CREATE TABLE #TMP_W_YIELD_DEFAULT(
        DIVISION_ID         NVARCHAR(300)
       ,ORIGIN_DIVISION_ID  NVARCHAR(300)
       ,PLAN_START_YYYYMMDD NVARCHAR(300)
       ,OPERATION_GROUP     NVARCHAR(300)
       ,SCM_SITE_ID         NVARCHAR(300)
       ,SITE_DESCRIPTION    NVARCHAR(300)
       ,NICK_NAME           NVARCHAR(300)
       ,ITEM_ID             NVARCHAR(300)
       ,ELECTRODE_TYPE      NVARCHAR(300)
       ,CELL_CF             NVARCHAR(300)
       ,OPERATION_ID        NVARCHAR(300)
    ); 
    CREATE CLUSTERED INDEX IX01_W_YIELD_DEFAULT ON #TMP_W_YIELD_DEFAULT(SCM_SITE_ID, ITEM_ID);';
    --인쇄만 한다.
    PRINT @sql;

    --BOH_PIVOT W_BOH_PIVOT
    --BOH_PIVOT용 테이블 만든다
    DROP TABLE IF EXISTS #TMP_W_BOH_PIVOT;
    IF OBJECT_ID('tempdb..#TMP_W_BOH_PIVOT') IS NOT NULL BEGIN DROP TABLE #TMP_W_BOH_PIVOT; END;

    CREATE TABLE #TMP_W_BOH_PIVOT(
        DIVISION_ID         NVARCHAR(300)
       ,ORIGIN_DIVISION_ID  NVARCHAR(300)
       ,PLAN_START_YYYYMMDD NVARCHAR(300)
       ,OPERATION_GROUP     NVARCHAR(300)
       ,SCM_SITE_ID         NVARCHAR(300)
       ,SITE_DESCRIPTION    NVARCHAR(300)
       ,NICK_NAME           NVARCHAR(300)
       ,ITEM_ID             NVARCHAR(300)
       ,ELECTRODE_TYPE      NVARCHAR(300)
       ,CELL_CF             NVARCHAR(300)
       ,OPERATION_ID        NVARCHAR(300)
    );
    CREATE CLUSTERED INDEX IX01_W_BOH_PIVOT ON #TMP_W_BOH_PIVOT(ITEM_ID)

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_W_BOH_PIVOT;
    IF OBJECT_ID(''tempdb..#TMP_W_BOH_PIVOT'') IS NOT NULL BEGIN DROP TABLE #TMP_W_BOH_PIVOT; END;

    CREATE TABLE #TMP_W_BOH_PIVOT(
        DIVISION_ID         NVARCHAR(300)
       ,ORIGIN_DIVISION_ID  NVARCHAR(300)
       ,PLAN_START_YYYYMMDD NVARCHAR(300)
       ,OPERATION_GROUP     NVARCHAR(300)
       ,SCM_SITE_ID         NVARCHAR(300)
       ,SITE_DESCRIPTION    NVARCHAR(300)
       ,NICK_NAME           NVARCHAR(300)
       ,ITEM_ID             NVARCHAR(300)
       ,ELECTRODE_TYPE      NVARCHAR(300)
       ,CELL_CF             NVARCHAR(300)
       ,OPERATION_ID        NVARCHAR(300)
    ); 
    CREATE CLUSTERED INDEX IX01_W_YIELD_DEFAULT ON #TMP_W_YIELD_DEFAULT(SCM_SITE_ID, ITEM_ID);';
    --인쇄만 한다.
    PRINT @sql;


    DROP TABLE IF EXISTS #TMP_ITEM_ID_PLANT_IDS;
    IF OBJECT_ID('tempdb..#TMP_ITEM_ID_PLANT_IDS') IS NOT NULL BEGIN DROP TABLE #TMP_ITEM_ID_PLANT_IDS; END;
    CREATE TABLE #TMP_ITEM_ID_PLANT_IDS(
        ITEM_ID    NVARCHAR(50)
       ,PLANT_ID   NVARCHAR(30)
    );

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_ITEM_ID_PLANT_IDS;
    IF OBJECT_ID(''tempdb..#TMP_ITEM_ID_PLANT_IDS'') IS NOT NULL BEGIN DROP TABLE #TMP_ITEM_ID_PLANT_IDS; END;

    CREATE TABLE #TMP_ITEM_ID_PLANT_IDS(
        ITEM_ID    NVARCHAR(50)
       ,PLANT_ID   NVARCHAR(30)
    ); ';

    PRINT @sql;  
    --아래는 실행하면 안된다...TEMP를 sp_executesql로 하면 다른 세션에 만든다.
    --아래 실행 불가, 상기 인쇄는 디버깅용
    --EXEC sp_executesql @SQL;

    SET @SQL = N'
    INSERT INTO #TMP_ITEM_ID_PLANT_IDS ( ITEM_ID,PLANT_ID )
    SELECT
        ITEM_ID  = LEFT(S.token, CHARINDEX(''^'', S.token) - 1),
        PLANT_ID = LEFT(SUBSTRING(
                                  S.token,
                                  CHARINDEX(''^'', S.token) + 1,
                                  LEN(S.token)
                                  ),4)
    FROM STRING_SPLIT('''+@V_ITEM_ID_PLANT_IDS+''', '','') S
    ORDER BY 1, 2 ;';
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql @SQL;
    PRINT 'SELECT * FROM #TMP_ITEM_ID_PLANT_IDS';

    IF NOT EXISTS (SELECT 1 FROM #TMP_ITEM_ID_PLANT_IDS )
    BEGIN
        RETURN;
    END


    ------------------------------------------------
    -- 입력받은 전극아이템에 대하여 어셈블리 관점에서 아이템 생성
    ------------------------------------------------
    DROP TABLE IF EXISTS #TMP_ITEM_ASSY;
    IF OBJECT_ID('tempdb..#TMP_ITEM_ASSY') IS NOT NULL BEGIN DROP TABLE #TMP_ITEM_ASSY; END;
    CREATE TABLE #TMP_ITEM_ASSY
    (
        DIVISION_ID NVARCHAR(30)
       ,FROM_DIVISION_ID NVARCHAR(30)
       ,FROM_SITE NVARCHAR(30)
       ,ITEM_ID NVARCHAR(50)
       ,LINE NVARCHAR(50)
       ,ITEM_ID_ASSY NVARCHAR(50)
       ,PRIMARY KEY(DIVISION_ID,FROM_DIVISION_ID,FROM_SITE,ITEM_ID,LINE,ITEM_ID_ASSY)
    );
    CREATE NONCLUSTERED INDEX IX01_TMP_ITEM_ASSY ON #TMP_ITEM_ASSY(FROM_SITE,ITEM_ID_ASSY)

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_ITEM_ASSY;
    IF OBJECT_ID(''tempdb..#TMP_ITEM_ASSY'') IS NOT NULL BEGIN DROP TABLE #TMP_ITEM_ASSY; END;
    CREATE TABLE #TMP_ITEM_ASSY
    (
        DIVISION_ID NVARCHAR(30)
       ,FROM_DIVISION_ID NVARCHAR(30)
       ,FROM_SITE NVARCHAR(30)
       ,ITEM_ID NVARCHAR(50)
       ,LINE NVARCHAR(50)
       ,ITEM_ID_ASSY NVARCHAR(50)
       ,PRIMARY KEY(DIVISION_ID,FROM_DIVISION_ID,FROM_SITE,ITEM_ID,LINE,ITEM_ID_ASSY)
    ); ';
    PRINT @sql;  
    --아래는 실행하면 안된다...TEMP를 sp_executesql로 하면 다른 세션에 만든다.
    --아래 실행 불가, 상기 인쇄는 디버깅용
    --EXEC sp_executesql @SQL;

     ------------------------------------------------
    -- 입력받은 전극아이템에 대하여 전극관점(어셈블리 관점 아님)에서 아이템 생성
    ------------------------------------------------
    DROP TABLE IF EXISTS #TMP_ELEC_ITEM_ASSY;
    IF OBJECT_ID('tempdb..#TMP_ELEC_ITEM_ASSY') IS NOT NULL BEGIN DROP TABLE #TMP_ELEC_ITEM_ASSY; END;
    CREATE TABLE #TMP_ELEC_ITEM_ASSY
    (
        DIVISION_ID NVARCHAR(30)
       ,FROM_DIVISION_ID NVARCHAR(30)
       ,FROM_SITE NVARCHAR(30)
       ,ITEM_ID NVARCHAR(50)
       ,LINE NVARCHAR(50)
       ,ITEM_ID_ASSY NVARCHAR(50)
       ,PRIMARY KEY(DIVISION_ID,FROM_DIVISION_ID,FROM_SITE,ITEM_ID,LINE,ITEM_ID_ASSY)
    );
    CREATE NONCLUSTERED INDEX IX01_TMP_ELEC_ITEM_ASSY ON #TMP_ELEC_ITEM_ASSY(FROM_SITE,ITEM_ID_ASSY)

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_ELEC_ITEM_ASSY;
    IF OBJECT_ID(''tempdb..#TMP_ELEC_ITEM_ASSY'') IS NOT NULL BEGIN DROP TABLE #TMP_ELEC_ITEM_ASSY; END;
    CREATE TABLE #TMP_ELEC_ITEM_ASSY
    (
        DIVISION_ID NVARCHAR(30)
       ,FROM_DIVISION_ID NVARCHAR(30)
       ,FROM_SITE NVARCHAR(30)
       ,ITEM_ID NVARCHAR(50)
       ,LINE NVARCHAR(50)
       ,ITEM_ID_ASSY NVARCHAR(50)
       ,PRIMARY KEY(DIVISION_ID,FROM_DIVISION_ID,FROM_SITE,ITEM_ID,LINE,ITEM_ID_ASSY)
    ); ';
    PRINT @sql;  
    --아래는 실행하면 안된다...TEMP를 sp_executesql로 하면 다른 세션에 만든다.
    --아래 실행 불가, 상기 인쇄는 디버깅용
    --EXEC sp_executesql @SQL;

    SET @SQL = N'
    --어셈브리 관점에서 생성
    ;WITH W_ASSY_ITEM AS (
        SELECT DISTINCT '''+@P_DIVISION_ID+N''' AS DIVISION_ID
              ,SMS.DIVISION_ID AS FROM_DIVISION_ID
              ,SMS.SCM_SITE_ID AS FROM_SITE
              ,IPI.ITEM_ID
        FROM   #TMP_ITEM_ID_PLANT_IDS IPI
        JOIN   SCM_MST_SITE SMS WITH(NOLOCK) ON SMS.SCM_SITE_ID = IPI.PLANT_ID+''-E''
    )
    INSERT INTO #TMP_ITEM_ASSY(DIVISION_ID,FROM_DIVISION_ID,FROM_SITE,ITEM_ID,LINE,ITEM_ID_ASSY)
    -- 어셈브리에서 생성 필요.
    SELECT DISTINCT A.DIVISION_ID,A.FROM_DIVISION_ID,LEFT(A.FROM_SITE,4)+''-A'' AS FROM_SITE,A.ITEM_ID,'''' AS LINE,C.ITEM_ID_ASSY
    FROM   W_ASSY_ITEM AS A
    JOIN   [DBO].SCP_MST_BOM_ELEC AS B WITH(NOLOCK)
    ON     A.FROM_DIVISION_ID      = B.DIVISION_ID
    AND    A.ITEM_ID               = B.CHILD_ITEM_ID
    JOIN    [DBO].SCP_MST_CELL_PROD_ASSY_MAP AS C WITH(NOLOCK)
    ON     A.FROM_DIVISION_ID      = C.DIVISION_ID
    AND    A.FROM_SITE             = C.PLANT_ID + ''-E''
    AND    B.PARENT_ITEM_ID        = C.ITEM_ID_ASSY
    ORDER BY 1, 2, 3, 4 ;';
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql @SQL;
    PRINT 'SELECT * FROM #TMP_ITEM_ASSY';

    --SELECT '#TMP_ITEM_ASSY',* FROM #TMP_ITEM_ASSY ORDER BY 1,2,3,4,5;

    SET @SQL = N'
    --전극관점(어셈브리 관점 아님)에서 생성
    ;WITH W_ASSY_ITEM AS (
        SELECT DISTINCT '''+@P_DIVISION_ID+N''' AS DIVISION_ID
              ,SMS.DIVISION_ID AS FROM_DIVISION_ID
              ,SMS.SCM_SITE_ID AS FROM_SITE
              ,IPI.ITEM_ID
        FROM   #TMP_ITEM_ID_PLANT_IDS IPI
        JOIN   SCM_MST_SITE SMS WITH(NOLOCK) ON SMS.SCM_SITE_ID = IPI.PLANT_ID+''-E''
    )
    INSERT INTO #TMP_ELEC_ITEM_ASSY(DIVISION_ID,FROM_DIVISION_ID,FROM_SITE,ITEM_ID,LINE,ITEM_ID_ASSY)
    -- 여기는 전극관점 필요.
    SELECT DISTINCT A.DIVISION_ID,A.FROM_DIVISION_ID,A.FROM_SITE,A.ITEM_ID,'''' AS LINE,C.ITEM_ID_ASSY
    FROM   W_ASSY_ITEM AS A
    JOIN   [DBO].SCP_MST_BOM_ELEC AS B WITH(NOLOCK)
    ON     A.FROM_DIVISION_ID      = B.DIVISION_ID
    AND    A.ITEM_ID               = B.CHILD_ITEM_ID
    JOIN    [DBO].SCP_MST_CELL_PROD_ASSY_MAP AS C WITH(NOLOCK)
    ON     A.FROM_DIVISION_ID      = C.DIVISION_ID
    AND    A.FROM_SITE             = C.PLANT_ID + ''-E''
    AND    B.PARENT_ITEM_ID        = C.ITEM_ID_ASSY
    ORDER BY 1, 2, 3, 4 ;';
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql @SQL;
    PRINT 'SELECT * FROM #TMP_ELEC_ITEM_ASSY';

    --SELECT '#TMP_ELEC_ITEM_ASSY',* FROM #TMP_ELEC_ITEM_ASSY ORDER BY 1,2,3,4,5;

    --#TMP_ELEC_ITEM_ASSY

    --###########################################
    --최적화 PLAN_ID 가져오기
    --###########################################
    DROP TABLE IF EXISTS #TMP_OPT_PLAN_ID;
    IF OBJECT_ID('tempdb..#TMP_OPT_PLAN_ID') IS NOT NULL BEGIN DROP TABLE #TMP_OPT_PLAN_ID; END;
    
    CREATE TABLE #TMP_OPT_PLAN_ID(
        OPT_PLAN_ID NVARCHAR(256)
    );

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_OPT_PLAN_ID;
    IF OBJECT_ID(''tempdb..#TMP_OPT_PLAN_ID'') IS NOT NULL BEGIN DROP TABLE #TMP_OPT_PLAN_ID; END;

    CREATE TABLE #TMP_OPT_PLAN_ID(
        OPT_PLAN_ID NVARCHAR(256)
    );';

    PRINT @sql;  
    --아래는 실행하면 안된다...TEMP를 sp_executesql로 하면 다른 세션에 만든다.
    --아래 실행 불가, 상기 인쇄는 디버깅용
    --EXEC sp_executesql @SQL;

    SET @SQL = N'
    INSERT INTO #TMP_OPT_PLAN_ID(OPT_PLAN_ID)
    -- PLAN GROUP 별 IF시간이 최신이 Plan ID가 조회되어야 함
    --SELECT PLAN_ID AS OPT_PLAN_ID
    --     --, ATTRIBUTE2
    --FROM (SELECT 
    --          PLAN_ID
    --        , ATTRIBUTE2
    --        , ROW_NUMBER() OVER (PARTITION BY ATTRIBUTE2 ORDER BY ATTRIBUTE14 DESC) AS RN
    --        -- ATTRIBUTE2 PLAN GROUP
    --        -- ATTRIBUTE14 IF시간
    --      FROM  '+@DBOPTPrefix+N'SCP_OPT_ENG_PLAN_MASTER M
    --      WHERE ATTRIBUTE2 = ISNULL('''+@P_PLAN_GROUP+N''' ,'''') -- Find items 에 선택한 값을 파라미터로 받음
    --      AND   M.PLAN_START_DATE >= CONVERT(VARCHAR(8),DATEADD(WEEK, -4, '''+@QUERY_START_YYYYMMDD+N'''),112)
    --) XX
    --WHERE 1=1
    --AND RN = 1
    SELECT
        OPT_PLAN_ID  = LEFT(S.token, CHARINDEX(''^'', S.token) - 1)
    FROM STRING_SPLIT('''+@P_OPT_PLAN_ID+N''', '','') S
    ORDER BY 1 ;
    ';

    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    INSERT INTO #TMP_OPT_PLAN_ID(OPT_PLAN_ID)
    EXEC sp_executesql @SQL;
    PRINT 'SELECT * FROM #TMP_OPT_PLAN_ID';

    --###########################################
    --PARENT ITEM 가져오기
    --###########################################
    DROP TABLE IF EXISTS #TMP_PARENT_ITEM;
    IF OBJECT_ID('tempdb..#TMP_PARENT_ITEM') IS NOT NULL BEGIN DROP TABLE #TMP_PARENT_ITEM; END;
    
    CREATE TABLE #TMP_PARENT_ITEM(
        child_item_id NVARCHAR(256),
        accumulated_child_qty FLOAT
    );

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_PARENT_ITEM;
    IF OBJECT_ID(''tempdb..#TMP_PARENT_ITEM'') IS NOT NULL BEGIN DROP TABLE #TMP_PARENT_ITEM; END;

    CREATE TABLE #TMP_PARENT_ITEM(
        child_item_id NVARCHAR(256),
        accumulated_child_qty FLOAT
    );';

    PRINT @sql;  
    --아래는 실행하면 안된다...TEMP를 sp_executesql로 하면 다른 세션에 만든다.
    --아래 실행 불가, 상기 인쇄는 디버깅용
    --EXEC sp_executesql @SQL;

    SET @SQL = N'
    INSERT INTO #TMP_PARENT_ITEM(CHILD_ITEM_ID,accumulated_child_qty)
    SELECT child_item_id
          ,MAX(convert(FLOAT, usage)) AS accumulated_child_qty
    FROM   scp_opt_eng_bom_elec_sn n WITH(nolock)
    --JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
    --ON   N.child_item_id                  = WI.ITEM_ID
    JOIN   #TMP_OPT_PLAN_ID TPI ON TPI.OPT_PLAN_ID = N.PLAN_ID 
    WHERE  1=1
    --AND    plan_id = @plan_id
    AND    scp_yn = ''Y''
    AND    child_item_id IN
           (SELECT DISTINCT A.item_id
             FROM   dbo.scp_opt_eng_model_list_n_sn A WITH(nolock)
             --JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
             --ON   A.item_id                  = WI.ITEM_ID
             JOIN   #TMP_OPT_PLAN_ID TPI ON TPI.OPT_PLAN_ID = A.PLAN_ID 
             WHERE  1=1
             --AND    plan_id = @plan_id
             AND    (A.item_id LIKE ''APCC%'' OR
                   A.item_id LIKE ''APCA%''))
    AND    parent_item_id IN
           (SELECT DISTINCT A.item_id a
             FROM   dbo.scp_opt_eng_model_list_n_sn A WITH(nolock)
             --JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
             --ON   A.item_id                  = WI.ITEM_ID
             JOIN   #TMP_OPT_PLAN_ID TPI ON TPI.OPT_PLAN_ID = A.PLAN_ID 
             WHERE  1=1
             --AND    plan_id = @plan_id
             AND    (A.item_id LIKE ''EA%'' OR
                   A.item_id LIKE ''AA%'' OR
                   A.item_id LIKE ''MA%''))
    GROUP  BY child_item_id;';
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    INSERT INTO #TMP_PARENT_ITEM(CHILD_ITEM_ID,accumulated_child_qty)
    EXEC sp_executesql @SQL;
    PRINT 'SELECT * FROM #TMP_PARENT_ITEM';

    --입력 item 기준 생산가능 라인 발췌
    DROP TABLE IF EXISTS #TMP_PLAN_LINE_ITEM;
    IF OBJECT_ID('tempdb..#TMP_PLAN_LINE_ITEM') IS NOT NULL BEGIN DROP TABLE #TMP_PLAN_LINE_ITEM; END;
    
    CREATE TABLE #TMP_PLAN_LINE_ITEM(
        PLAN_GROUP NVARCHAR(100),
        FACTORY_ID NVARCHAR(30),
        LINE_ID    NVARCHAR(30),
        PLANT_ID   NVARCHAR(30),
        ITEM_ID    NVARCHAR(150),
        CNT_REC    INT
    );
    CREATE CLUSTERED INDEX IX01_PLAN_LINE_ITEM ON #TMP_PLAN_LINE_ITEM(PLAN_GROUP, LINE_ID, PLANT_ID, ITEM_ID);

        SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_PLAN_LINE_ITEM;
    IF OBJECT_ID(''tempdb..#TMP_PLAN_LINE_ITEM'') IS NOT NULL BEGIN DROP TABLE #TMP_PLAN_LINE_ITEM; END;
    
    CREATE TABLE #TMP_PLAN_LINE_ITEM(
        PLAN_GROUP NVARCHAR(100),
        FACTORY_ID NVARCHAR(30),
        LINE_ID    NVARCHAR(30),
        PLANT_ID   NVARCHAR(30),
        ITEM_ID    NVARCHAR(150),
        CNT_REC    INT
    );
    CREATE CLUSTERED INDEX IX01_PLAN_LINE_ITEM ON #TMP_PLAN_LINE_ITEM(PLAN_GROUP, LINE_ID, PLANT_ID, ITEM_ID);    
    ';

    PRINT @sql;  
    --아래는 실행하면 안된다...TEMP를 sp_executesql로 하면 다른 세션에 만든다.
    --아래 실행 불가, 상기 인쇄는 디버깅용
    --EXEC sp_executesql @SQL;

    SET @SQL = N'
    ;WITH W_ITEM AS (
        SELECT
            nr AS rnum, 
            ITEM_ID  = LEFT(S.token, CHARINDEX(''^'', S.token) - 1),
            PLANT_ID = SUBSTRING(SUBSTRING(
                                 S.token,
                                 CHARINDEX(''^'', S.token) + 1,
                                 LEN(S.token)
                                 ),1,4)
        FROM STRING_SPLIT('''+@P_ITEM_ID_PLANT_IDS+N''',N'',N'') S
    )
    --SELECT * FROM W_ITEM;
    , W_P_OPT_PLAN_ID AS (
        SELECT
            OPT_PLAN_ID  = LEFT(S.token, CHARINDEX(''^'', S.token) - 1)
        FROM STRING_SPLIT('''+@P_OPT_PLAN_ID+N''', '','') S
    )
    --SELECT * FROM W_P_OPT_PLAN_ID;
    , W_PLANT_ID AS (
        SELECT DISTINCT SUBSTRING(PLANT_ID,1,4) AS PLANT_ID
        FROM W_ITEM
    )
    --SELECT * FROM W_PLANT_ID;
    , W_LINE AS (
        SELECT LINE_ID
              ,FACTORY_ID
        FROM (
             SELECT COMPANY_ID
                   ,DIVISION_ID
                   ,SITE_ID
                   ,MLV.PLANT_ID
                   ,FACTORY_ID
                   ,OPERATION_ID
                   ,LINE_ID
                   ,ELECTRODE_TYPE
                   ,LINE_NAME
                   ,VALID_YN
                   ,RNUM = ROW_NUMBER()OVER(PARTITION BY LINE_ID ORDER BY FACTORY_ID)
             from   [DBO].SCM_MST_LINE_V MLV WITH(NOLOCK) --LINE_ID
 
             JOIN W_PLANT_ID AS WP
             ON  WP.PLANT_ID = MLV.PLANT_ID
             
             WHERE  1=1
             AND    VALID_YN = ''Y''
             -- EE 가 아니고 81 등에 있음, 아래 DIVISION_ID 막아야됨
             /* AND    DIVISION_ID = ''EE'' */
             /* AND    PLANT_ID = ''NJ01'' */
             AND    OPERATION_ID = ''E2000'' --E20251106-001431 ???? ?? ??
        ) X
        WHERE RNUM = 1
    )
    --SELECT * FROM W_LINE; ';
    SET @SQL += N'
    , W_ITEM_LINE_RAW AS (
        SELECT DISTINCT PLANT_ID, LINE_ID, ITEM_ID--,MONTH AS YYYYMM 
        FROM   DBO.SCM_MST_ITEM_LINE_ASSIGN_SN LA WITH(NOLOCK)
        WHERE  1=1
        AND    ACTIVE_FLAG = ''Y''
        -- 미래구간에 Assign 된 Item 만 조회 (GETDATE()의 주차 일요일)
        --AND MONTH >= SUBSTRING(CONVERT(VARCHAR(8), DATEADD(DAY,1-DATEPART(WEEKDAY, GETDATE()), GETDATE()), 112), 1, 8)
        AND MONTH >= SUBSTRING(CONVERT(VARCHAR(8),DATEADD(WEEK, -0, '''+@QUERY_START_YYYYMMDD+N''')-1,112), 1, 6)
        AND    OPERATION_ID = ''E2000'' 
    )
    , W_LINE_ITEM_RAW AS (
        SELECT PLAN_GROUP,FACTORY_ID,X.LINE_ID,PLANT_ID,ITEM_ID,CNT_REC=COUNT(*)
        FROM (
        SELECT  attribute1, attribute2,max(plan_id) AS MAX_PLAN_ID,PLAN_GROUP,LINE_ID,PLANT_ID,ITEM_ID,YYYYMM
        FROM    [OPTENG_SCP].[dbo].SCP_OPT_ENG_PLAN_MASTER  M WITH(NOLOCK)
        INNER  JOIN ( SELECT DISTINCT CONCAT(GM.PLANT_ID, ''-E'') AS SCM_SITE_ID, GR_NM AS PLAN_GROUP,GM.LINE_ID,GM.PLANT_ID,ITEM_ID,YYYYMM
                        FROM (
                            --SELECT GM.DIVISION_ID, GL.OPMZ_PLAN_GR_ID AS GR_ID,GM.OPMZ_PLAN_GR_NAME GR_NM,GL.LINE_ID ,GL.PLANT_ID
                            --  FROM DBO.SCP_OPMZ_PLAN_GR_M GM WITH(NOLOCK)
                            --     , DBO.SCP_OPMZ_PLAN_GR_LINE_M GL WITH(NOLOCK)
                            --WHERE GM.OPMZ_PLAN_GR_ID = GL.OPMZ_PLAN_GR_ID
                            --  AND GM.VALID_YN = ''Y''
                            --  AND GL.VALID_YN = ''Y''
                            --  AND GL.ITEM_ID = ''-''
                            --  AND GM.DIVISION_ID = ''EE''
                            --  AND GM.OPMZ_PLAN_GR_NAME = ISNULL('''+@P_PLAN_GROUP+N''' ,'''')
                            --  --AND GL.PLANT_ID = ''NJ01''--@PLANT
                            -- 2026-02-10 ITEM별 사용 나오도록 변경
                            SELECT DISTINCT GM.DIVISION_ID, GL.OPMZ_PLAN_GR_ID AS GR_ID,GM.OPMZ_PLAN_GR_NAME GR_NM,GL.LINE_ID ,GL.PLANT_ID
                              FROM DBO.SCP_OPMZ_PLAN_GR_M GM WITH(NOLOCK)
                              JOIN DBO.SCP_OPMZ_PLAN_GR_LINE_M GL WITH(NOLOCK) ON GM.OPMZ_PLAN_GR_ID = GL.OPMZ_PLAN_GR_ID
                              JOIN W_ITEM_LINE_RAW WLR ON GL.PLANT_ID = WLR.PLANT_ID AND GL.LINE_ID = WLR.LINE_ID AND GL.ITEM_ID = WLR.ITEM_ID
                            WHERE 1=1
                              AND GM.VALID_YN = ''Y''
                              AND GL.VALID_YN = ''Y''
                              AND GL.ITEM_ID <> ''-''
                              AND GM.DIVISION_ID = ''EE''
                              AND GM.OPMZ_PLAN_GR_NAME = ISNULL('''+@P_PLAN_GROUP+N''' ,'''')
                            --모든_ITEM_연결
                            UNION
                            SELECT DISTINCT GM.DIVISION_ID, GL.OPMZ_PLAN_GR_ID AS GR_ID,GM.OPMZ_PLAN_GR_NAME GR_NM,GL.LINE_ID ,GL.PLANT_ID
                              FROM DBO.SCP_OPMZ_PLAN_GR_M GM WITH(NOLOCK)
                              JOIN DBO.SCP_OPMZ_PLAN_GR_LINE_M GL WITH(NOLOCK) ON GM.OPMZ_PLAN_GR_ID = GL.OPMZ_PLAN_GR_ID
                              JOIN W_ITEM_LINE_RAW WLR ON GL.PLANT_ID = WLR.PLANT_ID AND GL.LINE_ID = WLR.LINE_ID 
                            WHERE 1=1
                              AND GM.VALID_YN = ''Y''
                              AND GL.VALID_YN = ''Y''
                              AND GL.ITEM_ID = ''-''
                              AND GM.DIVISION_ID = ''EE''
                              AND GM.OPMZ_PLAN_GR_NAME = ISNULL('''+@P_PLAN_GROUP+N''' ,'''')
                              --AND GL.PLANT_ID = ''NJ01''--@PLANT
                            ) GM ';
    SET @SQL += N'
                            ,(
                            SELECT DISTINCT PLANT_ID, LINE_ID, ITEM_ID,MONTH AS YYYYMM FROM DBO.SCM_MST_ITEM_LINE_ASSIGN_SN LA WITH(NOLOCK)
                             WHERE 1=1
                               AND ACTIVE_FLAG = ''Y''
                               -- 미래구간에 Assign 된 Item 만 조회 (GETDATE()의 주차 일요일)
                               --AND MONTH >= SUBSTRING(CONVERT(VARCHAR(8), DATEADD(DAY,1-DATEPART(WEEKDAY, GETDATE()), GETDATE()), 112), 1, 8)
                               AND MONTH >= SUBSTRING(CONVERT(VARCHAR(8),DATEADD(WEEK, -0, '''+@QUERY_START_YYYYMMDD+N''')-1,112), 1, 6)
                               AND OPERATION_ID = ''E2000'' 
                            ) LM
                        WHERE GM.LINE_ID = LM.LINE_ID
                         AND  GM.PLANT_ID = LM.PLANT_ID
                     ) B ';
    SET @SQL += N'
        ON 1=1
        and M.attribute2=b.plan_group
        WHERE   M.ATTRIBUTE1 = ''EE'' ';
    SET @SQL += N'
        and (m.plan_id not like ''%C'' and m.plan_id not like ''%A'' and m.plan_id  like ''20%'') 
        group by attribute1, attribute2,PLAN_GROUP,LINE_ID,PLANT_ID,ITEM_ID,YYYYMM ';
    SET @SQL += N'
        ) X
        LEFT JOIN W_LINE WL ON WL.LINE_ID = X.LINE_ID
        GROUP BY PLAN_GROUP,FACTORY_ID,X.LINE_ID,PLANT_ID,ITEM_ID
    )
    SELECT * FROM W_LINE_ITEM_RAW;';
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    INSERT INTO #TMP_PLAN_LINE_ITEM(PLAN_GROUP, FACTORY_ID, LINE_ID, PLANT_ID, ITEM_ID, CNT_REC)
    EXEC sp_executesql @SQL;
    PRINT 'SELECT * FROM #TMP_PLAN_LINE_ITEM';

--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'1470');


    --########################################################
    --반복행수 
    --2026-01-15 고정값 10 변경
    DECLARE @DUPLECATE_REC_NUM INT = 10;
    --PLAN_GROUP에 따라 라인을 추가한다.
    --SELECT @DUPLECATE_REC_NUM = COUNT(*)
    --FROM (
    --    SELECT DISTINCT APP.LINE_ID
    --    FROM   SCP_ANL_PRODUCTION_PLAN APP WITH(NOLOCK)
    --    WHERE  1=1
    --    AND    APP.DIVISION_ID = @P_DIVISION_ID
    --    AND    APP.PLAN_START_YYYYMMDD = @QUERY_START_YYYYMMDD
    --    AND    APP.PLAN_TYPE = @P_PLAN_TYPE
    --    AND    APP.SEQ = @P_PLAN_SEQ
    --    AND    LEN(APP.LINE_ID)>4
    --    AND    APP.SCM_SITE_ID IN (SELECT DISTINCT PLANT_ID+'-E' FROM #TMP_ITEM_ID_PLANT_IDS)
    --    UNION 
    --    SELECT DISTINCT LINE_ID
    --    FROM (
    --        SELECT DISTINCT GM.DIVISION_ID, GL.OPMZ_PLAN_GR_ID AS GR_ID,GM.OPMZ_PLAN_GR_NAME GR_NM,GL.FACTORY_ID ,GL.LINE_ID ,GL.PLANT_ID
    --        FROM   DBO.SCP_OPMZ_PLAN_GR_M GM WITH(NOLOCK)
    --             , DBO.SCP_OPMZ_PLAN_GR_LINE_M GL WITH(NOLOCK)
    --        WHERE  GM.OPMZ_PLAN_GR_ID = GL.OPMZ_PLAN_GR_ID
    --        AND    GM.VALID_YN = 'Y'
    --        AND    GL.VALID_YN = 'Y'
    --        AND    GL.ITEM_ID = '-'
    --        AND    GM.DIVISION_ID = @P_DIVISION_ID
    --        AND    GM.OPMZ_PLAN_GR_NAME = ISNULL(@P_PLAN_GROUP ,'')
    --    ) X
    --) X;

PRINT '--A@X#003--' + CONVERT(NVARCHAR(30), GETDATE(), 121);


    ------------------------------------------------
    -- W_PKG_PLAN
    ------------------------------------------------
    DROP TABLE IF EXISTS #TMP_W_PKG_PLAN;
    IF OBJECT_ID('tempdb..#TMP_W_PKG_PLAN') IS NOT NULL BEGIN DROP TABLE #TMP_W_PKG_PLAN; END;
    CREATE TABLE #TMP_W_PKG_PLAN
    (
        ITEM_ID NVARCHAR(50)
       ,YYYYMMDD NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,QTY NUMERIC(30,10)
       ,PRIMARY KEY(ITEM_ID,YYYYMMDD)
    );
    CREATE NONCLUSTERED INDEX IX01_TMP_W_PKG_PLAN ON #TMP_W_PKG_PLAN(ITEM_ID)

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_W_PKG_PLAN;
    IF OBJECT_ID(''tempdb..#TMP_W_PKG_PLAN'') IS NOT NULL BEGIN DROP TABLE #TMP_W_PKG_PLAN; END;
    CREATE TABLE #TMP_W_PKG_PLAN
    (
        ITEM_ID NVARCHAR(50)
       ,YYYYMMDD NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,QTY NUMERIC(30,10)
       ,PRIMARY KEY(ITEM_ID,YYYYMMDD)
    ); 
    CREATE NONCLUSTERED INDEX IX01_TMP_W_PKG_PLAN ON #TMP_W_PKG_PLAN(ITEM_ID);';
    PRINT @sql;  
    --아래는 실행하면 안된다...TEMP를 sp_executesql로 하면 다른 세션에 만든다.
    --아래 실행 불가, 상기 인쇄는 디버깅용
    --EXEC sp_executesql @SQL;

    SET @SQL = N'
    WITH W_PKG_PLAN AS (
        SELECT ITEM_ID,YYYYMMDD,PSI_TYPE,MEASURE,SUM(QTY) AS QTY
        FROM (
            SELECT A.ITEM_ID, A.DUE_DATE AS YYYYMMDD, ''Sales'' AS PSI_TYPE, ''PKG_PLAN'' AS MEASURE --,SCM_SITE_ID
                 , A.QUANTITY*ISNULL((  SELECT TOP 1 B.ASSY AS YIELD
                                        FROM   SCP_OPMZ_YLD_ELEC B WITH (NOLOCK)
                                        LEFT OUTER JOIN SCM_PLANT_M_SN  PM WITH(NOLOCK) 
                                        ON B.PLANT_ID = PM.PLANT_ID
                                        WHERE  B.VALID_YN = ''Y''
                                        AND    B.ITEM_ID  = A.ITEM_ID
                                        AND     B.ASSY < > ''''
                                        AND    B.YYYYMM    = SUBSTRING(A.DUE_DATE, 1, 6)
                                        ORDER  BY CASE WHEN A.COMPANY_ID = PM.COMPANY_ID THEN 1 ELSE 2 END, B.ASSY), 1) AS QTY
            FROM ( 
                SELECT DO.PLAN_ID,  DO.ATTRIBUTE1 AS SCM_SITE_ID, DO.ATTRIBUTE2 AS ITEM_ID, DO.DUE_DATE, DO.QUANTITY
                    , ( SELECT TOP 1  PM.COMPANY_ID
                        FROM   SCM_MST_SITE MS WITH(NOLOCK)
                        INNER JOIN SCM_PLANT_M_SN  PM WITH(NOLOCK) 
                        ON MS.PLANT_ID = PM.PLANT_ID
                        WHERE  MS.SCM_SITE_ID = DO.ATTRIBUTE1) AS COMPANY_ID
                FROM  OPTENG_SCP.DBO.SCP_OPT_ENG_DEMAND_ORIGIN DO WITH (NOLOCK)
                JOIN   #TMP_OPT_PLAN_ID TPI ON TPI.OPT_PLAN_ID = DO.PLAN_ID 
                WHERE 1 =1
                --AND PLAN_ID =  '''+@P_OPT_PLAN_ID+'''
                --AND DO.PLAN_ID LIKE ''%EE%''
                --AND DO.ATTRIBUTE2 IN (SELECT TOKEN FROM STRING_SPLIT(@ITEM_LIST, '',''))
                AND DO.DUE_DATE >= '''+@QUERY_START_YYYYMMDD+''' 
                AND EXISTS ( SELECT 1
                             FROM   #TMP_ITEM_ID_PLANT_IDS AS WI
                             WHERE  DO.ATTRIBUTE2              = WI.ITEM_ID
                             --2026-02-03 아래 PLANT_ID 조건 걸면 안됨 EE 생산된게 타 PLANT로도 나가기 때문에
                             --AND    DO.ATTRIBUTE1              = WI.PLANT_ID+''-A''
                            )
            ) A
            --INNER JOIN AT ON AT.APLANT = A.SCM_SITE_ID AND AT.child_item_id = A.ITEM_ID
            --ORDER BY SCM_SITE_ID, ITEM_ID, DUE_DATE, QTY
        ) X
        GROUP BY ITEM_ID,YYYYMMDD,PSI_TYPE,MEASURE
    )
    SELECT * fROM W_PKG_PLAN; ';
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    INSERT INTO #TMP_W_PKG_PLAN(ITEM_ID, YYYYMMDD, PSI_TYPE, MEASURE, QTY)
    EXEC sp_executesql @SQL;
    PRINT 'SELECT * FROM #W_PKG_PLAN';

--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'1590');

    ------------------------------------------------
    -- W_TACT_TIME
    ------------------------------------------------
    DROP TABLE IF EXISTS #TMP_W_TACT_TIME;
    IF OBJECT_ID('tempdb..#TMP_W_TACT_TIME') IS NOT NULL BEGIN DROP TABLE #TMP_W_TACT_TIME; END;
    CREATE TABLE #TMP_W_TACT_TIME
    (
        SCM_SITE_ID NVARCHAR(30)
       ,LINE NVARCHAR(30)
       ,ITEM_ID NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,YYYYMMDD NVARCHAR(50)
       ,TACT_TIME NUMERIC(30,10)
       ,PRIMARY KEY(SCM_SITE_ID,LINE,ITEM_ID,YYYYMMDD)
    );
    CREATE NONCLUSTERED INDEX IX01_TMP_W_TACT_TIME ON #TMP_W_TACT_TIME(SCM_SITE_ID,LINE,ITEM_ID)

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_W_TACT_TIME;
    IF OBJECT_ID(''tempdb..#TMP_W_TACT_TIME'') IS NOT NULL BEGIN DROP TABLE #TMP_W_TACT_TIME; END;
    CREATE TABLE #TMP_W_TACT_TIME
    (
        SCM_SITE_ID NVARCHAR(30)
       ,LINE NVARCHAR(30)
       ,ITEM_ID NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,YYYYMMDD NVARCHAR(50)
       ,TACT_TIME NUMERIC(30,10)
       ,PRIMARY KEY(SCM_SITE_ID,LINE,ITEM_ID,YYYYMMDD)
    );
    CREATE NONCLUSTERED INDEX IX01_TMP_W_TACT_TIME ON #TMP_W_TACT_TIME(SCM_SITE_ID,LINE,ITEM_ID) ';
    PRINT @sql;  
    --아래는 실행하면 안된다...TEMP를 sp_executesql로 하면 다른 세션에 만든다.
    --아래 실행 불가, 상기 인쇄는 디버깅용
    --EXEC sp_executesql @SQL;

    SET @SQL = N'
    WITH W_END_D AS (
        SELECT CONVERT(NVARCHAR(8),DATEADD(DAY, 7, p.horizon_end_date),112) AS horizon_end_date
        FROM   '+@DBPrefix+N'scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = '''+@p_division_id+N'''
        AND    p.plan_id     = (SELECT max(plan_id) FROM '+@DBPrefix+N'scm_mst_plan p WITH(NOLOCK) WHERE division_id = '''+@p_division_id+N''' and plan_id < 9999)
        AND    p.plan_cycle  = ''WEEKLY''
    )
    , W_TACT_TIME_RAW AS (
        SELECT DISTINCT ATTRIBUTE1 AS SCM_SITE_ID,ATTRIBUTE15 AS LINE, ATTRIBUTE2 AS ITEM_ID, ''Production'' AS PSI_TYPE , ''Tact Time'' AS MEASURE
             , ATTRIBUTE14 AS YYYYMM, LOAD_PER AS TACT_TIME --1미터당 초
        FROM   '+@DBOPTPrefix+N'SCP_OPT_ENG_ROUTING_RESOURCE ERR WITH(nolock)
        --JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = ERR.PLAN_ID 
        JOIN   #TMP_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = ERR.PLAN_ID

             JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
             ON  ERR.ATTRIBUTE2                  = WI.ITEM_ID
             --AND LEFT(ERR.ATTRIBUTE1,4)          = WI.PLANT_ID
 
             JOIN W_END_D WED ON ERR.ATTRIBUTE14 BETWEEN '''+SUBSTRING(@QUERY_START_YYYYMMDD,1,6)+''' AND SUBSTRING(WED.horizon_end_date,1,6)

        WHERE  1=1  '
        IF ISNULL(@P_PLANT_ID,N'') <> N'' BEGIN
        SET @SQL += N'
        AND LEFT(ERR.ATTRIBUTE1,4) = '''+@P_PLANT_ID+''' N' ; END;
        SET @SQL += N'
        --AND    PLAN_ID = @PLAN_ID
        AND    RESOURCE_CLASS_ID=''LINE''
        AND    ATTRIBUTE3=''COATING''
        --AND    ATTRIBUTE1 = @FROM_SITE
        --AND    ATTRIBUTE2 IN (SELECT TOKEN FROM STRING_SPLIT(@ITEM_LIST, '',''))
    )
    --SELECT * FROM W_TACT_TIME_RAW;
    , W_TACT_TIME AS (
        SELECT SCM_SITE_ID,LINE, ITEM_ID, PSI_TYPE, MEASURE, WC.BASIS_YYYYMMDD AS YYYYMMDD
             , TACT_TIME --1미터당 초 --YYYYMM, 
        FROM   W_TACT_TIME_RAW WTR
        JOIN   #TMP_PLAN_CALENDAR AS WC ON WC.BASIS_YYYYMM = WTR.YYYYMM
    )
    SELECT * FROM W_TACT_TIME; ';
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    INSERT INTO #TMP_W_TACT_TIME(SCM_SITE_ID, LINE, ITEM_ID, PSI_TYPE, MEASURE, YYYYMMDD, TACT_TIME)
    EXEC sp_executesql @SQL;
    PRINT 'SELECT * FROM #TMP_W_TACT_TIME';

--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'1680');



    ------------------------------------------------
    -- W_COATING_SPEED
    ------------------------------------------------
    DROP TABLE IF EXISTS #TMP_W_COATING_SPEED;
    IF OBJECT_ID('tempdb..#TMP_W_COATING_SPEED') IS NOT NULL BEGIN DROP TABLE #TMP_W_COATING_SPEED; END;
    CREATE TABLE #TMP_W_COATING_SPEED
    (
        SCM_SITE_ID NVARCHAR(30)
       ,LINE NVARCHAR(30)
       ,ITEM_ID NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,YYYYMMDD NVARCHAR(50)
       ,COATING_SPEED NUMERIC(30,10)
       ,PRIMARY KEY(SCM_SITE_ID,LINE,ITEM_ID,YYYYMMDD)
    );
    CREATE NONCLUSTERED INDEX IX01_TMP_W_COATING_SPEED ON #TMP_W_COATING_SPEED(SCM_SITE_ID,LINE,ITEM_ID)

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_W_COATING_SPEED;
    IF OBJECT_ID(''tempdb..#TMP_W_COATING_SPEED'') IS NOT NULL BEGIN DROP TABLE #TMP_W_COATING_SPEED; END;
    CREATE TABLE #TMP_W_COATING_SPEED
    (
        SCM_SITE_ID NVARCHAR(30)
       ,LINE NVARCHAR(30)
       ,ITEM_ID NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,YYYYMMDD NVARCHAR(50)
       ,COATING_SPEED NUMERIC(30,10)
       ,PRIMARY KEY(SCM_SITE_ID,LINE,ITEM_ID,YYYYMMDD)
    );
    CREATE NONCLUSTERED INDEX IX01_TMP_W_COATING_SPEED ON #TMP_W_COATING_SPEED(SCM_SITE_ID,LINE,ITEM_ID) ';
    PRINT @sql;  
    --아래는 실행하면 안된다...TEMP를 sp_executesql로 하면 다른 세션에 만든다.
    --아래 실행 불가, 상기 인쇄는 디버깅용
    --EXEC sp_executesql @SQL;


    SET @SQL = N'
    WITH W_COATING_SPEED_RAW AS (
        SELECT DISTINCT ODC.PLANT_ID+''-E'' AS SCM_SITE_ID,LINE_ID AS LINE, ODC.ITEM_ID, ''Production'' AS PSI_TYPE , ''Coating Speed'' AS MEASURE
             , YYYYMM AS YYYYMM, M_MIN AS COATING_SPEED --M/Min
        FROM   '+@DBPrefix+N'SCP_OPMZ_DDLY_CAPA ODC WITH(nolock)

             JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
             ON  ODC.ITEM_ID       = WI.ITEM_ID
             AND ODC.PLANT_ID      = WI.PLANT_ID

        WHERE  1=1  
        AND    OPERATION_ID = ''E2000''
        AND    VALID_YN = ''Y''
        AND    YYYYMM >= '''+SUBSTRING(@QUERY_START_YYYYMMDD,1,6)+'''
        AND    YYYYMM <= '''+SUBSTRING(@QUERY_END_YYYYMMDD,1,6)+'''

    )
    --SELECT * FROM W_COATING_SPEED_RAW;
    , W_COATING_SPEED AS (
        SELECT SCM_SITE_ID,LINE, ITEM_ID, PSI_TYPE, MEASURE, WC.BASIS_YYYYMMDD AS YYYYMMDD
             , COATING_SPEED --M/Min --YYYYMM, 
        FROM   W_COATING_SPEED_RAW WTR
        JOIN   #TMP_PLAN_CALENDAR AS WC ON WC.BASIS_YYYYMM = WTR.YYYYMM
    )
    SELECT * FROM W_COATING_SPEED; ';
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    INSERT INTO #TMP_W_COATING_SPEED(SCM_SITE_ID, LINE, ITEM_ID, PSI_TYPE, MEASURE, YYYYMMDD, COATING_SPEED)
    EXEC sp_executesql @SQL;
    PRINT 'SELECT * FROM #TMP_W_COATING_SPEED';

--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'1780');

    ------------------------------------------------
    -- W_ASSY_YIELD
    ------------------------------------------------
    DROP TABLE IF EXISTS #TMP_W_ASSY_YIELD;
    IF OBJECT_ID('tempdb..#TMP_W_ASSY_YIELD') IS NOT NULL BEGIN DROP TABLE #TMP_W_ASSY_YIELD; END;
    CREATE TABLE #TMP_W_ASSY_YIELD
    (
        SCM_SITE_ID NVARCHAR(30)
       ,ITEM_ID NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,YYYYMMDD NVARCHAR(50)
       ,YIELD NUMERIC(30,10)
       ,PRIMARY KEY(SCM_SITE_ID,ITEM_ID,YYYYMMDD)
    );
    CREATE NONCLUSTERED INDEX IX01_TMP_ITEM_ASSY ON #TMP_W_ASSY_YIELD(SCM_SITE_ID,ITEM_ID)

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_W_ASSY_YIELD;
    IF OBJECT_ID(''tempdb..#TMP_W_ASSY_YIELD'') IS NOT NULL BEGIN DROP TABLE #TMP_W_ASSY_YIELD; END;
    CREATE TABLE #TMP_W_ASSY_YIELD
    (
        SCM_SITE_ID NVARCHAR(30)
       ,ITEM_ID NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,YYYYMMDD NVARCHAR(50)
       ,YIELD NUMERIC(30,10)
       ,PRIMARY KEY(SCM_SITE_ID,ITEM_ID,YYYYMMDD)
    );
    CREATE NONCLUSTERED INDEX IX01_TMP_ITEM_ASSY ON #TMP_W_ASSY_YIELD(SCM_SITE_ID,ITEM_ID) ';
    PRINT @sql;  
    --아래는 실행하면 안된다...TEMP를 sp_executesql로 하면 다른 세션에 만든다.
    --아래 실행 불가, 상기 인쇄는 디버깅용
    --EXEC sp_executesql @SQL;


    SET @SQL = N'
    WITH W_END_D AS (
        SELECT CONVERT(NVARCHAR(8),DATEADD(DAY, 7, p.horizon_end_date),112) AS horizon_end_date
        FROM   '+@DBPrefix+N'scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = '''+@p_division_id+N'''
        AND    p.plan_id     = (SELECT max(plan_id) FROM '+@DBPrefix+N'scm_mst_plan p WITH(NOLOCK) WHERE division_id = '''+@p_division_id+N''' and plan_id < 9999)
        AND    p.plan_cycle  = ''WEEKLY''
    )
    , W_ASSY_YIELD AS (
        SELECT PLANT_ID+''-E'' AS SCM_SITE_ID, ITEM_ID, ''Yield'' AS PSI_TYPE , ''Assy Yield'' AS MEASURE
             , WC.BASIS_YYYYMMDD AS YYYYMMDD, CONVERT(NUMERIC(20,10),YIELD) AS YIELD  --, PLANT_ID
        FROM (
            SELECT A.PLANT_ID,A.ITEM_ID, A.YYYYMM, AVG(CONVERT(NUMERIC(20,10), A.ASSY)) AS YIELD 
            FROM   '+@DBPrefix+N'SCP_OPMZ_YLD_ELEC A WITH(NOLOCK)
            
                    JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
                    ON  A.ITEM_ID                  = WI.ITEM_ID
                    --AND A.PLANT_ID                 = WI.PLANT_ID
                    JOIN W_END_D WED ON A.YYYYMM BETWEEN '''+SUBSTRING(@QUERY_START_YYYYMMDD,1,6)+'''  AND SUBSTRING(WED.horizon_end_date,1,6)
            
              LEFT OUTER JOIN '+@DBPrefix+N'SCP_MST_BOM_ELEC  B WITH(NOLOCK)
                       ON   A.ITEM_ID = B.CHILD_ITEM_ID
                       AND  B.SCP_YN = ''Y''
            WHERE 1=1  '
            IF ISNULL(@P_PLANT_ID,N'') <> N'' BEGIN
            SET @SQL += N'
            AND A.PLANT_ID = '''+@P_PLANT_ID+N''' N' ; END;
            SET @SQL += N'
            AND VALID_YN=''Y''
            and A.ASSY <>''''
            GROUP BY A.PLANT_ID,A.ITEM_ID, YYYYMM
        ) AY            
                JOIN #TMP_PLAN_CALENDAR AS WC
                ON  AY.YYYYMM                  = WC.BASIS_YYYYMM
    )
    SELECT * FROM W_ASSY_YIELD; ';
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    INSERT INTO #TMP_W_ASSY_YIELD(SCM_SITE_ID, ITEM_ID, PSI_TYPE, MEASURE, YYYYMMDD, YIELD)
    EXEC sp_executesql @SQL;
    PRINT 'SELECT * FROM #TMP_W_ASSY_YIELD';

--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'1870');


    ------------------------------------------------
    -- W_ELEC_YIELD
    ------------------------------------------------
    DROP TABLE IF EXISTS #TMP_W_ELEC_YIELD;
    IF OBJECT_ID('tempdb..#TMP_W_ELEC_YIELD') IS NOT NULL BEGIN DROP TABLE #TMP_W_ELEC_YIELD; END;
    CREATE TABLE #TMP_W_ELEC_YIELD
    (
        SCM_SITE_ID NVARCHAR(30)
       ,ITEM_ID NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,YYYYMMDD NVARCHAR(50)
       ,YIELD NUMERIC(30,10)
       ,PRIMARY KEY(SCM_SITE_ID,ITEM_ID,YYYYMMDD)
    );
    CREATE NONCLUSTERED INDEX IX01_TMP_W_ELEC_YIELD ON #TMP_W_ELEC_YIELD(SCM_SITE_ID,ITEM_ID)

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_W_ELEC_YIELD;
    IF OBJECT_ID(''tempdb..#TMP_W_ELEC_YIELD'') IS NOT NULL BEGIN DROP TABLE #TMP_W_ELEC_YIELD; END;
    CREATE TABLE #TMP_W_ELEC_YIELD
    (
        SCM_SITE_ID NVARCHAR(30)
       ,ITEM_ID NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,YYYYMMDD NVARCHAR(50)
       ,YIELD NUMERIC(30,10)
       ,PRIMARY KEY(SCM_SITE_ID,ITEM_ID,YYYYMMDD)
    ); ';
    PRINT @sql;  
    --아래는 실행하면 안된다...TEMP를 sp_executesql로 하면 다른 세션에 만든다.
    --아래 실행 불가, 상기 인쇄는 디버깅용
    --EXEC sp_executesql @SQL;


    SET @SQL = N'
    WITH W_END_D AS (
        SELECT CONVERT(NVARCHAR(8),DATEADD(DAY, 7, p.horizon_end_date),112) AS horizon_end_date
        FROM   '+@DBPrefix+N'scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = '''+@p_division_id+N'''
        AND    p.plan_id     = (SELECT max(plan_id) FROM '+@DBPrefix+N'scm_mst_plan p WITH(NOLOCK) WHERE division_id = '''+@p_division_id+N''' and plan_id < 9999)
        AND    p.plan_cycle  = ''WEEKLY''
    )
    , W_ELEC_YIELD AS (
        SELECT PLANT_ID+''-E'' AS SCM_SITE_ID, ITEM_ID, ''Yield'' AS PSI_TYPE , ''Elec Yield'' AS MEASURE
             , WC.BASIS_YYYYMMDD AS YYYYMMDD, CONVERT(NUMERIC(20,10),YIELD) AS YIELD --, PLANT_ID
        FROM (
            SELECT OYE.PLANT_ID, OYE.ITEM_ID, YYYYMM, AVG(CONVERT(NUMERIC(20,10), ELEC_POST)) AS YIELD 
            FROM   '+@DBPrefix+N'SCP_OPMZ_YLD_ELEC OYE WITH(NOLOCK)
            
                    JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
                    ON  OYE.ITEM_ID                  = WI.ITEM_ID
                    --AND OYE.PLANT_ID                 = WI.PLANT_ID
                    JOIN W_END_D WED ON OYE.YYYYMM BETWEEN '''+SUBSTRING(@QUERY_START_YYYYMMDD,1,6)+'''  AND SUBSTRING(WED.horizon_end_date,1,6)
            
            WHERE  1=1  '
            IF ISNULL(@P_PLANT_ID,N'') <> N'' BEGIN
            SET @SQL += N'
            AND OYE.PLANT_ID = '''+@P_PLANT_ID+N''' N' ; END;
            SET @SQL += N'
            AND    VALID_YN=''Y''
            GROUP BY OYE.PLANT_ID,OYE.ITEM_ID, YYYYMM
        ) EY            
                JOIN #TMP_PLAN_CALENDAR AS WC
                ON  EY.YYYYMM                  = WC.BASIS_YYYYMM
    )
    SELECT * FROM W_ELEC_YIELD; ';
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    INSERT INTO #TMP_W_ELEC_YIELD(SCM_SITE_ID, ITEM_ID, PSI_TYPE, MEASURE, YYYYMMDD, YIELD)
    EXEC sp_executesql @SQL;
    PRINT 'SELECT * FROM #TMP_W_ELEC_YIELD';



    ------------------------------------------------
    -- W_COATING_YIELD
    ------------------------------------------------
    DROP TABLE IF EXISTS #TMP_W_COATING_YIELD;
    IF OBJECT_ID('tempdb..#TMP_W_COATING_YIELD') IS NOT NULL BEGIN DROP TABLE #TMP_W_COATING_YIELD; END;
    CREATE TABLE #TMP_W_COATING_YIELD
    (
        SCM_SITE_ID NVARCHAR(30)
       ,ITEM_ID NVARCHAR(50)
	   ,LINE_ID NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,YYYYMMDD NVARCHAR(50)
       ,YIELD NUMERIC(30,10)
       ,PRIMARY KEY(SCM_SITE_ID,ITEM_ID,YYYYMMDD)
    );
    CREATE NONCLUSTERED INDEX IX01_TMP_W_COATING_YIELD ON #TMP_W_COATING_YIELD(SCM_SITE_ID,ITEM_ID)

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_W_COATING_YIELD;
    IF OBJECT_ID(''tempdb..#TMP_W_COATING_YIELD'') IS NOT NULL BEGIN DROP TABLE #TMP_W_COATING_YIELD; END;
    CREATE TABLE #TMP_W_COATING_YIELD
    (
        SCM_SITE_ID NVARCHAR(30)
       ,ITEM_ID NVARCHAR(50)
	   ,LINE_ID NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,YYYYMMDD NVARCHAR(50)
       ,YIELD NUMERIC(30,10)
       ,PRIMARY KEY(SCM_SITE_ID,ITEM_ID,YYYYMMDD)
    ); ';
    PRINT @sql;  
    --아래는 실행하면 안된다...TEMP를 sp_executesql로 하면 다른 세션에 만든다.
    --아래 실행 불가, 상기 인쇄는 디버깅용
    --EXEC sp_executesql @SQL;


    SET @SQL = N'
    WITH W_END_D AS (
        SELECT CONVERT(NVARCHAR(8),DATEADD(DAY, 7, p.horizon_end_date),112) AS horizon_end_date
        FROM   '+@DBPrefix+N'scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = '''+@p_division_id+N'''
        AND    p.plan_id     = (SELECT max(plan_id) FROM '+@DBPrefix+N'scm_mst_plan p WITH(NOLOCK) WHERE division_id = '''+@p_division_id+N''' and plan_id < 9999)
        AND    p.plan_cycle  = ''WEEKLY''
    )
    , W_COATING_YIELD AS (
        SELECT PLANT_ID+''-E'' AS SCM_SITE_ID, ITEM_ID, ''TEST'' AS LINE_ID, ''Yield'' AS PSI_TYPE , ''Coating Yield'' AS MEASURE
             , WC.BASIS_YYYYMMDD AS YYYYMMDD, CONVERT(NUMERIC(20,10),YIELD) AS YIELD 
        FROM (
            SELECT OYE.PLANT_ID, OYE.ITEM_ID, OYE.LINE_ID, MONTH, AVG(CONVERT(NUMERIC(20,10), YIELD)) AS YIELD 
            FROM   '+@DBFPPrefix+N'SCM_YIELD_M OYE WITH(NOLOCK)            
                    JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
                    ON  OYE.ITEM_ID                  = WI.ITEM_ID
                    AND OYE.PLANT_ID                 = WI.PLANT_ID
                    JOIN W_END_D WED ON OYE.MONTH BETWEEN '''+SUBSTRING(@QUERY_START_YYYYMMDD,1,6)+'''  AND SUBSTRING(WED.horizon_end_date,1,6)
            WHERE  OYE.OPERATION_ID=''E2000''  '
            IF ISNULL(@P_PLANT_ID,N'') <> N'' BEGIN
            SET @SQL += N'
            AND OYE.PLANT_ID = '''+@P_PLANT_ID+N''' N' ; END;
            SET @SQL += N'
        --    AND    VALID_YN=''Y''
            GROUP BY OYE.PLANT_ID, OYE.ITEM_ID, OYE.LINE_ID, MONTH
        ) EY            
                JOIN #TMP_PLAN_CALENDAR AS WC
                ON  EY.MONTH                  = WC.BASIS_YYYYMM
    )
    SELECT * FROM W_COATING_YIELD; ';
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    INSERT INTO #TMP_W_COATING_YIELD(SCM_SITE_ID, ITEM_ID, LINE_ID, PSI_TYPE, MEASURE, YYYYMMDD, YIELD)
    EXEC sp_executesql @SQL;
    PRINT 'SELECT * FROM #TMP_W_COATING_YIELD';





--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'1960');

    ------------------------------------------------
    -- W_HOLD_REL_RAW
    ------------------------------------------------
    DROP TABLE IF EXISTS #TMP_W_HOLD_REL_RAW;
    IF OBJECT_ID('tempdb..#TMP_W_HOLD_REL_RAW') IS NOT NULL BEGIN DROP TABLE #TMP_W_HOLD_REL_RAW; END;
    CREATE TABLE #TMP_W_HOLD_REL_RAW
    (
        ITEM_ID NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,YYYYMMDD NVARCHAR(50)
       ,Hold_Release_QTY NUMERIC(30,10)
       ,PRIMARY KEY(ITEM_ID,YYYYMMDD)
    );
    CREATE NONCLUSTERED INDEX IX01_TMP_W_HOLD_REL_RAW ON #TMP_W_HOLD_REL_RAW(ITEM_ID)

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_W_HOLD_REL_RAW;
    IF OBJECT_ID(''tempdb..#TMP_W_HOLD_REL_RAW'') IS NOT NULL BEGIN DROP TABLE #TMP_W_HOLD_REL_RAW; END;
    CREATE TABLE #TMP_W_HOLD_REL_RAW
    (
        ITEM_ID NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,YYYYMMDD NVARCHAR(50)
       ,Hold_Release_QTY NUMERIC(30,10)
       ,PRIMARY KEY(SCM_SITE_ID,LINE,ITEM_ID,YYYYMMDD)
    ); ';
    PRINT @sql;  
    --아래는 실행하면 안된다...TEMP를 sp_executesql로 하면 다른 세션에 만든다.
    --아래 실행 불가, 상기 인쇄는 디버깅용
    --EXEC sp_executesql @SQL;


    SET @SQL = N'
    WITH W_HOLD_REL_SITE_ITEM AS (
        SELECT DISTINCT a.scm_site_id AS aplant
                       ,p.plant_id
                        --,SEGMENT3 AS ITEM_ID
                       ,child_item_id
        FROM   '+@DBOPTPrefix+N'scp_opt_eng_model_list_n a WITH(nolock)
        INNER  JOIN '+@DBFPPrefix+N'scm_plant_m p WITH(nolock)
        ON     (p.plant_id + ''-A'' = a.scm_site_id OR
               p.plant_id + ''-E'' = a.scm_site_id)
        INNER  JOIN '+@DBPrefix+N'scm_mst_model_final_item_bom_v bom WITH(nolock)
        ON     bom.operation_group_id = ''E''
        AND    (bom.model_id = a.item_id OR bom.child_item_id = a.item_id)
        AND    (bom.model_id LIKE ''AA%'' OR bom.model_id LIKE ''EA%'' OR
              bom.model_id LIKE ''MA%'')

        JOIN   #TMP_OPT_PLAN_ID TPI ON TPI.OPT_PLAN_ID = A.PLAN_ID

        JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
        ON   bom.child_item_id                  = WI.ITEM_ID
        --AND  BOM.PLANT_ID                       = WI.PLANT_ID
        --AND    bom.child_item_id IN
        --       (SELECT token
        --         FROM   string_split(@item_list, '',''))


        WHERE  1 = 1
        --AND    a.plan_id = @plan_id
    )
    --SELECT * FROM W_HOLD_REL_SITE_ITEM;
    , W_HOLD_REL_RAW AS (
        SELECT attribute2 AS ITEM_ID, ''Inventory'' AS PSI_TYPE , ''Hold Release'' AS MEASURE
             , effective_date AS YYYYMMDD, SUM(quantity) AS Hold_Release_QTY --WSI.aplant AS SCM_SITE_ID, WSI.PLANT_ID, 
        FROM   '+@DBOPTPrefix+N'scp_opt_eng_incoming_stock a WITH(nolock)
        INNER  JOIN W_HOLD_REL_SITE_ITEM AS WSI
        ON     WSI.child_item_id = a.attribute2 -- 전극 ITEM
        AND    WSI.aplant = a.attribute1

             JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
             ON  A.ATTRIBUTE2                  = WI.ITEM_ID
             --AND LEFT(A.ATTRIBUTE1,4)          = WI.PLANT_ID

        JOIN   #TMP_OPT_PLAN_ID TPI ON TPI.OPT_PLAN_ID = A.PLAN_ID ';

        IF ISNULL(@P_PLANT_ID,N'') <> N'' BEGIN
        SET @SQL += N'
        AND WSI.PLANT_ID = '''+@P_PLANT_ID+N''' N' ; END;
        SET @SQL += N'
        WHERE  1 = 1
        --AND    plan_id = @plan_id
        --AND    effective_date >= LEFT(@plan_id, 8) 
        AND    effective_date >= LEFT(TPI.OPT_PLAN_ID, 8) 
        --AND attribute2 IN (SELECT token
        --                   FROM   string_split(@item_list, '','')) 
        AND    TYPE = ''WH_HOLD''
        GROUP  BY attribute2
             , effective_date --WSI.aplant, WSI.PLANT_ID, 
        --ORDER  BY 1, 2
    )
    SELECT * FROM W_HOLD_REL_RAW; ';
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    INSERT INTO #TMP_W_HOLD_REL_RAW(ITEM_ID, PSI_TYPE, MEASURE, YYYYMMDD, Hold_Release_QTY)
    EXEC sp_executesql @SQL;
    PRINT 'SELECT * FROM #TMP_W_HOLD_REL_RAW';

--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'2080');


    ------------------------------------------------
    -- W_BOH_PIVOT W_BOH_PIVOT_RAW
    ------------------------------------------------
    DROP TABLE IF EXISTS #TMP_W_BOH_PIVOT_RAW;
    IF OBJECT_ID('tempdb..#TMP_W_BOH_PIVOT_RAW') IS NOT NULL BEGIN DROP TABLE #TMP_W_BOH_PIVOT_RAW; END;
    CREATE TABLE #TMP_W_BOH_PIVOT_RAW
    (
        ITEM_ID NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,Elec_Site_QTY NUMERIC(30,10)
       ,Assy_Site_QTY NUMERIC(30,10)
       ,Intransit_QTY NUMERIC(30,10)
       ,HD_QTY        NUMERIC(30,10)
       ,PRIMARY KEY(ITEM_ID)
    );

    SET @SQL = N'
    DROP TABLE IF EXISTS #TMP_W_BOH_PIVOT_RAW;
    IF OBJECT_ID(''tempdb..#TMP_W_BOH_PIVOT_RAW'') IS NOT NULL BEGIN DROP TABLE #TMP_W_BOH_PIVOT_RAW; END;
    CREATE TABLE #TMP_W_BOH_PIVOT_RAW
    (
        ITEM_ID NVARCHAR(50)
       ,PSI_TYPE NVARCHAR(30)
       ,MEASURE NVARCHAR(30)
       ,Elec_Site_QTY NUMERIC(30,10)
       ,Assy_Site_QTY NUMERIC(30,10)
       ,Intransit_QTY NUMERIC(30,10)
       ,HD_QTY        NUMERIC(30,10)
       ,PRIMARY KEY(ITEM_ID)
    ); ';
    PRINT @sql;  
    --아래는 실행하면 안된다...TEMP를 sp_executesql로 하면 다른 세션에 만든다.
    --아래 실행 불가, 상기 인쇄는 디버깅용
    --EXEC sp_executesql @SQL;


    SET @SQL = N'
    WITH W_PLANT_ID AS (
        SELECT DISTINCT SUBSTRING(PLANT_ID,1,4) AS PLANT_ID
        FROM #TMP_ITEM_ID_PLANT_IDS
    )
    , W_BOH_RAW AS (
        SELECT inv.type
              ,inv.scm_site_id
              ,inv.item_id
              ,inv.qty AS qty
              ,inv.qty / accumulated_child_qty AS cell_qty
        FROM   (SELECT ''Elec_Site'' AS TYPE
                      ,attribute1 AS ''scm_site_id''
                      ,attribute2 AS ''item_id''
                      ,SUM(quantity) AS qty
                FROM   '+@DBOPTPrefix+N'scp_opt_eng_incoming_stock A WITH(nolock)

                JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
                ON   A.attribute2                  = WI.ITEM_ID
                --AND LEFT(A.ATTRIBUTE1,4)           = WI.PLANT_ID

                JOIN   #TMP_OPT_PLAN_ID TPI ON TPI.OPT_PLAN_ID = A.PLAN_ID 
                WHERE  1=1
                --AND    plan_id = @plan_id
                AND    effective_date = LEFT(TPI.OPT_PLAN_ID, 8) --@effective_date
                AND    attribute1 LIKE ''%E''
                AND    TYPE = ''WH''
                GROUP  BY attribute1, attribute2
                UNION ALL
                SELECT ''Assy_Site'', attribute1, attribute2, SUM(quantity)
                FROM   '+@DBOPTPrefix+N'scp_opt_eng_incoming_stock A WITH(nolock)
                JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
                ON   A.attribute2                  = WI.ITEM_ID
                --AND LEFT(A.ATTRIBUTE1,4)           = WI.PLANT_ID
                JOIN   #TMP_OPT_PLAN_ID TPI ON TPI.OPT_PLAN_ID = A.PLAN_ID 
                WHERE  1=1
                --AND    plan_id = @plan_id
                AND    effective_date = LEFT(TPI.OPT_PLAN_ID, 8) --@effective_date
                AND    attribute1 LIKE ''%A''
                AND    attribute1 LIKE LEFT  ('''+@P_PLANT_ID+N''', 2) + ''%'' 
                AND    TYPE = ''WH''
                GROUP  BY attribute1, attribute2
                UNION ALL
                SELECT ''Intransit'', attribute1, attribute2, SUM(quantity)
                FROM   '+@DBOPTPrefix+N'scp_opt_eng_incoming_stock A WITH(nolock)
                JOIN W_PLANT_ID AS WP
                ON   attribute1 LIKE LEFT (WP.PLANT_ID, 2) + ''%''
                JOIN   #TMP_OPT_PLAN_ID TPI ON TPI.OPT_PLAN_ID = A.PLAN_ID 
                WHERE  1=1
                --AND    plan_id = @plan_id
                AND    effective_date = LEFT(TPI.OPT_PLAN_ID, 8) --@effective_date
                /*AND    attribute1 LIKE LEFT  ('''+@P_PLANT_ID+N''', 2) + ''%''  */
                AND    TYPE = ''INT''
                GROUP  BY attribute1, attribute2
                UNION ALL
                SELECT ''HD'', attribute1, attribute2, SUM(quantity)
                FROM   '+@DBOPTPrefix+N'scp_opt_eng_incoming_stock A WITH(nolock)
                JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
                ON   A.attribute2                  = WI.ITEM_ID
                --AND LEFT(A.ATTRIBUTE1,4)           = WI.PLANT_ID
                JOIN   #TMP_OPT_PLAN_ID TPI ON TPI.OPT_PLAN_ID = A.PLAN_ID 
                WHERE  1=1
                --AND    plan_id = @plan_id
                AND    effective_date = LEFT(TPI.OPT_PLAN_ID, 8) --@effective_date
                AND    TYPE = ''WH_HOLD''
                GROUP  BY attribute1, attribute2) inv  ';
    SET @SQL += N'
        LEFT   OUTER JOIN #TMP_PARENT_ITEM CV
        ON     inv.item_id = cv.child_item_id
    )  
    --SELECT * FROM W_BOH_RAW; ';
    SET @SQL += N'
    , W_BOH_PIVOT_RAW AS (
        
        SELECT ITEM_ID AS ITEM_ID, ''Inventory'' AS PSI_TYPE , ''INVENTORY_TOTAL'' AS MEASURE
             , Elec_Site AS Elec_Site_QTY, Assy_Site AS Assy_Site_QTY , Intransit AS Intransit_QTY , HD AS HD_QTY  
             /*scm_site_id AS SCM_SITE_ID, LEFT(scm_site_id,4) AS PLANT_ID,*/ 
        --SELECT *
        FROM (
            SELECT TYPE/*, scm_site_id*/, item_id/*, SUM(qty) AS qty*/, SUM(cell_qty) AS cell_qty
            FROM   W_BOH_RAW WBR
            WHERE  1 = 1
            GROUP  BY TYPE/*, scm_site_id*/, item_id
        ) PIV_BOH
        PIVOT
            (
                SUM(cell_qty)
                FOR TYPE IN ([Elec_Site],[Assy_Site],[Intransit],[HD])

            ) AS PIV_BOH
    )
    SELECT * FROM W_BOH_PIVOT_RAW; ';
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    INSERT INTO #TMP_W_BOH_PIVOT_RAW(ITEM_ID, PSI_TYPE, MEASURE, Elec_Site_QTY, Assy_Site_QTY, Intransit_QTY, HD_QTY)
    EXEC sp_executesql @SQL;
    PRINT 'SELECT * FROM #TMP_W_BOH_PIVOT_RAW';

--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'2230');


    PRINT '-------------------------------------------'
    PRINT '--@DUPLECATE_REC_NUM COUNT: '+CONVERT(NVARCHAR(MAX),@DUPLECATE_REC_NUM);

    SET @SQL = N'
    ;WITH W_ITEM AS (
        SELECT
            nr AS rnum, 
            ITEM_ID  = LEFT(S.token, CHARINDEX(''^'', S.token) - 1),
            PLANT_ID = SUBSTRING(SUBSTRING(
                                 S.token,
                                 CHARINDEX(''^'', S.token) + 1,
                                 LEN(S.token)
                                 ),1,4)
        FROM STRING_SPLIT('''+@P_ITEM_ID_PLANT_IDS+N''',N'',N'') S
    )
    --SELECT * FROM W_ITEM;
    , W_P_OPT_PLAN_ID AS (
        SELECT
            OPT_PLAN_ID  = LEFT(S.token, CHARINDEX(''^'', S.token) - 1)
        FROM STRING_SPLIT('''+@P_OPT_PLAN_ID+N''', '','') S
    )
    --SELECT * FROM W_P_OPT_PLAN_ID;
    , W_PLANT_ID AS (
        SELECT DISTINCT SUBSTRING(PLANT_ID,1,4) AS PLANT_ID
        FROM W_ITEM
    )
    --SELECT * FROM W_PLANT_ID;
    , W_LINE AS (
        SELECT LINE_ID
              ,FACTORY_ID
        FROM (
             SELECT COMPANY_ID
                   ,DIVISION_ID
                   ,SITE_ID
                   ,MLV.PLANT_ID
                   ,FACTORY_ID
                   ,OPERATION_ID
                   ,LINE_ID
                   ,ELECTRODE_TYPE
                   ,LINE_NAME
                   ,VALID_YN
                   ,RNUM = ROW_NUMBER()OVER(PARTITION BY LINE_ID ORDER BY FACTORY_ID)
             from   '+@DBPrefix+N'SCM_MST_LINE_V MLV WITH(NOLOCK) --LINE_ID

             JOIN W_PLANT_ID AS WP
             ON  WP.PLANT_ID = MLV.PLANT_ID
             
             WHERE  1=1
             AND    VALID_YN = ''Y''
             -- EE 가 아니고 81 등에 있음, 아래 DIVISION_ID 막아야됨
             /* AND    DIVISION_ID = '''+@P_DIVISION_ID+''' */
             /* AND    PLANT_ID = '''+@P_PLANT_ID+''' */
             AND    OPERATION_ID = ''E2000'' --E20251106-001431 공정코드 추가 참조
        ) X
        WHERE RNUM = 1
    )
    --SELECT * FROM W_LINE;
    , W_PLAN_INFO AS
    (
        SELECT
              DIVISION_ID
            , PLAN_NAME
            , PLAN_START_YYYYMMDD = PLAN_NAME
            , PLAN_TYPE
            , PLAN_SEQ
        FROM
        (
            SELECT
                  PLM.DIVISION_ID
                , PLM.PLAN_NAME
                , PLD.PLAN_TYPE
                , PLD.PLAN_SEQ
                , ROW_NUMBER() OVER(PARTITION BY PLM.DIVISION_ID ORDER BY PLM.DIVISION_ID , CASE WHEN PLAN_TYPE = ''FN'' THEN ''1'' WHEN PLAN_TYPE = ''SE'' THEN ''2'' WHEN PLAN_TYPE = ''MA'' THEN ''3'' WHEN PLAN_TYPE = ''PR'' THEN ''4'' END , PLAN_SEQ DESC) AS ROW_NUM
            FROM    '+@DBPrefix+N'SCM_MST_PLAN PLM WITH(NOLOCK)
            INNER JOIN '+@DBPrefix+N'SCM_MST_PLAN_DETAIL PLD WITH(NOLOCK)
                ON  PLM.DIVISION_ID = PLD.DIVISION_ID
                AND PLM.PLAN_ID     = PLD.PLAN_ID
            WHERE   1=1
            AND     PLM.PLAN_NAME       = '''+@QUERY_START_YYYYMMDD+''' --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)--CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), ''MON'')), 112) -- 당주월요일
            AND     PLM.PLAN_CYCLE      = ''WEEKLY''
            AND     PLD.PLAN_STATUS     = ''1''
            AND     PLM.DIVISION_ID     = '''+@P_DIVISION_ID+'''
            AND     PLD.PLAN_TYPE       = '''+@P_PLAN_TYPE+'''
            AND     PLD.PLAN_SEQ        = '''+CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ)+'''
        ) AS PLAN_LIST
        WHERE ROW_NUM = 1
    )
    --SELECT * FROM W_PLAN_INFO  '
    SET @SQL += N'
    ------------------
    , W_OPT_PLAN_ID AS (
        SELECT PLAN_ID AS OPT_PLAN_ID
         --, ATTRIBUTE2
        FROM (SELECT 
                  PLAN_ID
                , ATTRIBUTE2
                , ROW_NUMBER() OVER (PARTITION BY ATTRIBUTE2 ORDER BY ATTRIBUTE14 DESC) AS RN
                -- ATTRIBUTE2 PLAN GROUP
                -- ATTRIBUTE14 IF시간
              FROM '+@DBOPTPrefix+N'SCP_OPT_ENG_PLAN_MASTER M
              WHERE ATTRIBUTE2 = ISNULL('''+@P_PLAN_GROUP+N''' ,'''') -- Find items 에 선택한 값을 파라미터로 받음
              AND   M.PLAN_START_DATE >= CONVERT(VARCHAR(8),DATEADD(WEEK, -4, '''+@QUERY_START_YYYYMMDD+N'''),112)
        ) XX
        WHERE 1=1
        AND RN = 1
    )
    --SELECT * FROM W_OPT_PLAN_ID;
    , W_SEMI_PLAN AS
    (
        SELECT
              SP.ORIGIN_FROM_DIVISION_ID    AS FROM_DIVISION_ID
            , SP.ORIGIN_TO_DIVISION_ID      AS TO_DIVISION_ID
            , SP.DIVISION_ID                AS DIVISION_ID
            , SP.FROM_SITE
            , SP.TO_SITE
            , SP.ITEM_ID
            , '''' AS LINE
            , ''SHIP_PLAN_TOTAL''         AS MEASURE
            , WPI.PLAN_NAME
            , WPI.PLAN_START_YYYYMMDD
            , WPI.PLAN_TYPE
            , WPI.PLAN_SEQ
            --, WC.PARTIAL_WEEK_NAME
            --, WC.BASIS_START_DATE
            --, WC.BASIS_END_DATE
            , SP.YYYYMMDD
            , SP.QTY
        FROM '+@DBPrefix+N'[SCP_ANL_SHIPMENT_PLAN_SEMI] AS SP WITH(NOLOCK)
        JOIN '+@DBPrefix+N'SCM_MST_SITE MSA WITH(NOLOCK) ON MSA.SCM_SITE_ID = SP.FROM_SITE
        JOIN '+@DBPrefix+N'SCM_MST_SITE MSB WITH(NOLOCK) ON MSB.SCM_SITE_ID = SP.TO_SITE

                JOIN W_PLAN_INFO AS WPI
                ON  SP.DIVISION_ID              = WPI.DIVISION_ID
                AND SP.PLAN_START_YYYYMMDD      = WPI.PLAN_NAME
                AND SP.PLAN_TYPE                = WPI.PLAN_TYPE
                AND SP.SEQ                      = WPI.PLAN_SEQ
                --AND SP.YYYYMMDD                   = WPI.PLAN_NAME

                JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
                ON  SP.ITEM_ID                  = WI.ITEM_ID
                AND SP.FROM_SITE                = WI.PLANT_ID+''-E''

                --LEFT JOIN W_PLAN_CALENDAR AS WC
                --ON  SP.YYYYMMDD                 = WC.BASIS_YYYYMMDD

        WHERE   SP.DIVISION_ID          = ''EE''
        AND     SP.OPERATION_GROUP      = ''E''
        AND     SP.MEASURE              IN (''SHIP_PLAN_AMEND'')
        --2026-02-10 권순지책임님 요청으로 변경
        AND     MSA.COMPANY_ID          <> MSB.COMPANY_ID -- FROM SITE랑 TO SITE의 COMPANY 코드가 다른것만 나오도록 변경
        AND     SP.QTY                  <> 0  '
        IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
        SET @SQL += N'
        AND LEFT(SP.FROM_SITE,4) = '''+@P_PLANT_ID+''' ' ; END;
        SET @SQL += N'

    )
    --SELECT * FROM W_SEMI_PLAN;
    , W_ITEM_ASSY AS (
        --SELECT DISTINCT A.* ,B.CHILD_ITEM_ID, C.ITEM_ID_ASSY--(셀)
        SELECT DISTINCT A.DIVISION_ID,A.FROM_DIVISION_ID,A.ITEM_ID,A.LINE,A.FROM_SITE,C.ITEM_ID_ASSY--(셀)
        FROM W_SEMI_PLAN AS A
            JOIN '+@DBPrefix+N'SCP_MST_BOM_ELEC AS B
            ON  A.FROM_DIVISION_ID      = B.DIVISION_ID
            AND A.ITEM_ID               = B.CHILD_ITEM_ID
            JOIN '+@DBPrefix+N'SCP_MST_CELL_PROD_ASSY_MAP AS C
            ON  A.FROM_DIVISION_ID      = C.DIVISION_ID
            AND A.FROM_SITE             = C.PLANT_ID + ''-E''
            AND B.PARENT_ITEM_ID        = C.ITEM_ID_ASSY
    )
    --SELECT * FROM W_ITEM_ASSY; '
    SET @SQL += N'
    , W_PROD_RST AS
    (
        SELECT  
               ''EE'' AS DIVISION_ID 
              ,PRH.DIVISION_ID AS FROM_DIVISION_ID
              ,LEFT(PRH.OPERATION_ID,1) AS OPERATION_GROUP
              ,PRH.ITEM_ID
              ,PRH.LINE_ID
              ,PRH.OPERATION_ID
              ,''PROD_PLAN_AMEND''     AS MEASURE
              ,PRH.PLANT_ID+''-E''  AS SCM_SITE_ID
              ,UPPER(PRH.ELECTRODE_TYPE) AS ELECTRODE_TYPE
              ,WPI.PLAN_NAME
              ,WPI.PLAN_START_YYYYMMDD
              ,WPI.PLAN_TYPE
              ,WPI.PLAN_SEQ
              ,CONVERT(VARCHAR(8),PRH.PLAN_DATE,112) AS YYYYMMDD
              ,CASE WHEN PRH.DIVISION_ID = ''40'' AND PRH.PRODUCTION_TYPE IN (''MASS'',''C-MASS'',''M-SAMPLE'') THEN ISNULL(ACTUAL_GOOD_QTY,0.00)
                   WHEN PRH.DIVISION_ID = ''40'' AND PRH.PRODUCTION_TYPE NOT IN (''MASS'',''C-MASS'',''M-SAMPLE'') THEN 0
                   ELSE ISNULL(PRH.ACTUAL_GOOD_QTY,0.00) END
                 * ( SELECT ISNULL( MIN(Y.CONVERT_QTY_CELL),1)
                       FROM SCP_MST_FINAL_ITEM Y WITH (NOLOCK)
                      WHERE Y.ITEM_ID    = PRH.ITEM_ID
                        AND Y.CONVERT_QTY_CELL IS NOT NULL ) AS qty
               --,*
        FROM   '+@DBFPPrefix+N'SCM_DAILY_PRODUCT_RESULT_H PRH WITH(NOLOCK)

                JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
                ON  PRH.ITEM_ID               = WI.ITEM_ID
                AND PRH.PLANT_ID              = WI.PLANT_ID

                LEFT JOIN W_PLAN_INFO WPI ON 1=1

        WHERE  PRH.OPERATION_ID = ''E2000''
        AND    PRH.PLAN_DATE >= DATEADD(WEEK, -4, '''+@QUERY_START_YYYYMMDD+N''')
        AND    PRH.PLAN_DATE < CONVERT(DATE, '''+@QUERY_START_YYYYMMDD+N''')
        --Production type
        --자동차/ESS (81/82) : 4M-VALID,MASS,C-MASS,D-SAMPLE,M-SAMPLE,D-TEST,TEST,
        --소형 (40) : MASS,C-MASS,M-SAMPLE
        AND    PRH.PRODUCTION_TYPE IN (''4M-VALID'',''MASS'',''C-MASS'',''D-SAMPLE'',''M-SAMPLE'',''D-TEST'',''TEST'')
        AND    PRH.ACTUAL_GOOD_QTY <> 0  '
        IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
        SET @SQL += N'
        AND PRH.PLANT_ID = '''+@P_PLANT_ID+''' ' ; END;
        SET @SQL += N'
    )
    --SELECT * FROM W_PROD_RST;'
    SET @SQL += N'
    , W_PROD_PLAN AS
    (
        SELECT
              PP.DIVISION_ID
            , PP.ORIGIN_DIVISION_ID        AS FROM_DIVISION_ID
            , PP.OPERATION_GROUP
            , PP.ITEM_ID
            , PP.LINE_ID
            , PP.OPERATION_ID
            , ''PROD_PLAN_AMEND''     AS MEASURE
            , PP.SCM_SITE_ID
            , PP.ELECTRODE_TYPE
            , WPI.PLAN_NAME
            , WPI.PLAN_START_YYYYMMDD
            , WPI.PLAN_TYPE
            , WPI.PLAN_SEQ
            --, WC.PARTIAL_WEEK_NAME
            --, WC.BASIS_START_DATE
            --, WC.BASIS_END_DATE
            , PP.YYYYMMDD
            --2025-12-08 김준규 수량을 CELL로 표기
            , ISNULL(PP.qty,0.00)
                  * ( SELECT ISNULL( MIN(Y.CONVERT_QTY_CELL),1)
                        FROM SCP_MST_FINAL_ITEM Y WITH (NOLOCK)
                       WHERE Y.ITEM_ID    = PP.ITEM_ID
                         AND Y.CONVERT_QTY_CELL IS NOT NULL ) AS qty
        FROM '+@DBPrefix+N'SCP_ANL_PRODUCTION_PLAN AS PP WITH(NOLOCK)
                JOIN W_PLAN_INFO AS WPI
                ON  PP.DIVISION_ID              = WPI.DIVISION_ID
                AND PP.PLAN_START_YYYYMMDD      = WPI.PLAN_NAME
                AND PP.PLAN_TYPE                = WPI.PLAN_TYPE
                AND PP.SEQ                      = WPI.PLAN_SEQ
                --AND PP.YYYYMMDD                   = WPI.PLAN_NAME

                JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
                ON  PP.ITEM_ID                  = WI.ITEM_ID
                AND PP.SCM_SITE_ID              = WI.PLANT_ID+''-E''

                --LEFT JOIN W_PLAN_CALENDAR AS WC
                --ON  PP.YYYYMMDD                 = WC.BASIS_YYYYMMDD

        WHERE   1                       = 1
        AND     PP.DIVISION_ID          = '''+@p_division_id+N'''
        AND     PP.OPERATION_GROUP      = ''E''
        AND     PP.MEASURE              IN (''PROD_PLAN_AMEND'')
        AND     PP.QTY                  <> 0  '
        IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
        SET @SQL += N'
        AND LEFT(PP.SCM_SITE_ID,4) = '''+@P_PLANT_ID+''' ' ; END;
        SET @SQL += N'
    )
    --SELECT * FROM W_PROD_PLAN;
    , W_ZERO_PROD_PLAN AS
    (
        SELECT 
              PP.DIVISION_ID
            , PP.ORIGIN_DIVISION_ID        AS FROM_DIVISION_ID
            , PP.OPERATION_GROUP
            , PP.ITEM_ID
            , PP.LINE_ID
            , PP.OPERATION_ID
            , ''PROD_PLAN_AMEND''     AS MEASURE
            , PP.SCM_SITE_ID
            , PP.ELECTRODE_TYPE
            , WPI.PLAN_NAME
            , WPI.PLAN_START_YYYYMMDD
            , WPI.PLAN_TYPE
            , WPI.PLAN_SEQ
            --, WC.PARTIAL_WEEK_NAME
            --, WC.BASIS_START_DATE
            --, WC.BASIS_END_DATE
            , PP.YYYYMMDD
            --2025-12-08 김준규 수량을 CELL로 표기
            , CONVERT(NUMERIC(20,10),NULL) AS qty
            ,ROW_NUMBER()OVER(PARTITION BY PP.SCM_SITE_ID, PP.ITEM_ID ORDER BY PP.LINE_ID) RNUM
        FROM '+@DBPrefix+N'SCP_ANL_PRODUCTION_PLAN AS PP WITH(NOLOCK)
                JOIN W_PLAN_INFO AS WPI
                ON  PP.DIVISION_ID              = WPI.DIVISION_ID
                AND PP.PLAN_START_YYYYMMDD      = WPI.PLAN_NAME
                AND PP.PLAN_TYPE                = WPI.PLAN_TYPE
                AND PP.SEQ                      = WPI.PLAN_SEQ
                --AND PP.YYYYMMDD                   = WPI.PLAN_NAME
 
                JOIN #TMP_ITEM_ID_PLANT_IDS AS WI
                ON  PP.ITEM_ID                  = WI.ITEM_ID
                AND PP.SCM_SITE_ID              = WI.PLANT_ID+''-E''
 
                --LEFT JOIN W_PLAN_CALENDAR AS WC
                --ON  PP.YYYYMMDD                 = WC.BASIS_YYYYMMDD
 
        WHERE   1                       = 1
        AND     PP.DIVISION_ID          = '''+@p_division_id+N'''
        AND     PP.OPERATION_GROUP      = ''E''   '
        IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
        SET @SQL += N'
        AND LEFT(PP.SCM_SITE_ID,4) = '''+@P_PLANT_ID+''' ' ; END;
        SET @SQL += N'
        AND     PP.MEASURE              IN (''PROD_PLAN_AMEND'')
        AND     PP.YYYYMMDD             = '''+@QUERY_START_YYYYMMDD+'''  
        AND     EXISTS ( SELECT 1
                         FROM   #TMP_ITEM_ID_PLANT_IDS IPI
                         WHERE  1=1
                         AND    IPI.PLANT_ID+''-E'' = PP.SCM_SITE_ID
                         AND    IPI.ITEM_ID       = PP.ITEM_ID
                         AND    NOT EXISTS (SELECT 1
                                            FROM   W_PROD_PLAN WPP
                                            WHERE  WPP.SCM_SITE_ID = IPI.PLANT_ID+''-E''
                                            AND    WPP.ITEM_ID     = IPI.ITEM_ID
                                            )
                        )
    )
    --SELECT * FROM W_ZERO_PROD_PLAN;
    -- SELECT * FROM W_SEMI_PLAN
    -- SELECT * FROM W_PROD_PLAN WHERE ITEM_ID = ''APCAN2829A'' '
    SET @SQL += N'
    , W_PKG_PLAN AS (
        SELECT SCM_SITE_ID, A.ITEM_ID, A.DUE_DATE AS YYYYMMDD
             , A.QUANTITY*ISNULL((  SELECT TOP 1 B.ASSY AS YIELD
                                    FROM   SCP_OPMZ_YLD_ELEC B WITH (NOLOCK)
                                    LEFT OUTER JOIN SCM_PLANT_M_SN  PM WITH(NOLOCK) 
                                    ON B.PLANT_ID = PM.PLANT_ID
                                    WHERE  B.VALID_YN = ''Y''
                                    AND    B.ITEM_ID  = A.ITEM_ID
                                    AND     B.ASSY < > ''''
                                    AND    B.YYYYMM    = SUBSTRING(A.DUE_DATE, 1, 6)
                                    ORDER  BY CASE WHEN A.COMPANY_ID = PM.COMPANY_ID THEN 1 ELSE 2 END, B.ASSY), 1) AS QTY
        FROM ( 
            SELECT DO.PLAN_ID,  DO.ATTRIBUTE1 AS SCM_SITE_ID, DO.ATTRIBUTE2 AS ITEM_ID, DO.DUE_DATE, DO.QUANTITY
                , ( SELECT TOP 1  PM.COMPANY_ID
                    FROM   SCM_MST_SITE MS WITH(NOLOCK)
                    INNER JOIN SCM_PLANT_M_SN  PM WITH(NOLOCK) 
                    ON MS.PLANT_ID = PM.PLANT_ID
                    WHERE  MS.SCM_SITE_ID = DO.ATTRIBUTE1) AS COMPANY_ID
            FROM  OPTENG_SCP.DBO.SCP_OPT_ENG_DEMAND_ORIGIN DO WITH (NOLOCK)
            JOIN   #TMP_OPT_PLAN_ID TPI ON TPI.OPT_PLAN_ID = DO.PLAN_ID 
            WHERE 1 =1
            --AND PLAN_ID =  @PLAN_ID
            --AND DO.PLAN_ID LIKE ''%EE%''
            --AND DO.ATTRIBUTE2 IN (SELECT TOKEN FROM STRING_SPLIT(@ITEM_LIST, '',''))
            AND DO.DUE_DATE >= '''+@QUERY_START_YYYYMMDD+'''  
            AND EXISTS ( SELECT 1
                         FROM   #TMP_ITEM_ID_PLANT_IDS AS WI
                         WHERE  DO.ATTRIBUTE2              = WI.ITEM_ID
                         --2026-02-03 아래 PLANT_ID 조건 걸면 안됨 EE 생산된게 타 PLANT로도 나가기 때문에
                         --AND    DO.ATTRIBUTE1              = WI.PLANT_ID+''-A''
                        )
        ) A
        --INNER JOIN AT ON AT.APLANT = A.SCM_SITE_ID AND AT.child_item_id = A.ITEM_ID
        --ORDER BY SCM_SITE_ID, ITEM_ID, DUE_DATE, QTY
    )
    --SELECT * fROM W_PKG_PLAN; '
    SET @SQL += N'
    , W_DAILY_SUM AS (
        SELECT
              LIST.DIVISION_ID
            , LIST.ORIGIN_FROM_DIVISION_ID AS ORIGIN_DIVISION_ID
            , LIST.PLAN_START_YYYYMMDD
            , LIST.PLAN_TYPE
            , LIST.PLAN_SEQ AS SEQ
            , LIST.OPERATION_GROUP
            , MST_SITE.SCM_SITE_ID
            , MST_SITE.SITE_DESCRIPTION
            , FI.NICK_NAME
            , LIST.ITEM_ID
            , LIST.PSI_TYPE
            , FI.ELECTRODE_TYPE
            , FI.CELL_CF
            , LIST.FACTORY_ID
            , LIST.LINE_ID
            , LIST.OPERATION_ID
            , LIST.MEASURE
            --, LIST.PARTIAL_WEEK_NAME
            --, LIST.BASIS_START_DATE
            --, LIST.BASIS_END_DATE
            , LIST.YYYYMMDD
            , LIST.QTY
        FROM
        (
            SELECT
                  DIVISION_ID               AS DIVISION_ID
                , FROM_DIVISION_ID          AS ORIGIN_FROM_DIVISION_ID
                , ''-'' AS OPERATION_GROUP
                , FROM_SITE                 AS FROM_SITE_ID
                , ''-'' AS LINE_ID
                , ''-'' AS OPERATION_ID
                , ''-'' AS FACTORY_ID
                , ITEM_ID
                , ''Sale'' AS PSI_TYPE
                , MEASURE
                , PLAN_NAME
                , PLAN_START_YYYYMMDD
                , PLAN_TYPE
                , PLAN_SEQ
                --, PARTIAL_WEEK_NAME
                --, BASIS_START_DATE
                --, BASIS_END_DATE
                , YYYYMMDD
                , QTY
            FROM W_SEMI_PLAN AS A '
    SET @SQL += N'
            UNION ALL
            --PROD RESULT
            SELECT
                  A.DIVISION_ID
                , A.FROM_DIVISION_ID          AS ORIGIN_FROM_DIVISION_ID -- MST_SITE.SITE_DESCRIPTION
                , A.OPERATION_GROUP
                , A.SCM_SITE_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , LN.FACTORY_ID
                , A.ITEM_ID
                , ''Production'' AS PSI_TYPE
                , A.MEASURE
                , A.PLAN_NAME
                , A.PLAN_START_YYYYMMDD
                , A.PLAN_TYPE
                , A.PLAN_SEQ
                --, PARTIAL_WEEK_NAME
                --, BASIS_START_DATE
                --, BASIS_END_DATE
                , A.YYYYMMDD
                , A.QTY
            FROM W_PROD_RST AS A
                --2025-12-09 라인정보 가져오는 로직 문제
                JOIN W_LINE LN 
                ON  1=1
                --AND A.SCM_SITE_ID                   = LN.PLANT_ID + ''-E''
                AND A.LINE_ID                       = LN.LINE_ID ' 
                IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
                SET @SQL += N'
                --AND LN.PLANT_ID = '''+@P_PLANT_ID+'''
                AND 1=1 ' ; END;
    SET @SQL += N'
            UNION ALL
            SELECT
                  A.DIVISION_ID
                , A.FROM_DIVISION_ID          AS ORIGIN_FROM_DIVISION_ID -- MST_SITE.SITE_DESCRIPTION
                , A.OPERATION_GROUP
                , A.SCM_SITE_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , LN.FACTORY_ID
                , A.ITEM_ID
                , ''Production'' AS PSI_TYPE
                , A.MEASURE
                , A.PLAN_NAME
                , A.PLAN_START_YYYYMMDD
                , A.PLAN_TYPE
                , A.PLAN_SEQ
                --, PARTIAL_WEEK_NAME
                --, BASIS_START_DATE
                --, BASIS_END_DATE
                , A.YYYYMMDD
                , A.QTY
            FROM W_PROD_PLAN AS A
                --2025-12-09 라인정보 가져오는 로직 문제
                JOIN W_LINE LN 
                ON  1=1
                --AND A.SCM_SITE_ID                   = LN.PLANT_ID + ''-E''
                AND A.LINE_ID                       = LN.LINE_ID
                -- ELECTRODE_TYPE 실제 PROD_PLAN_AMEND의 라인과 SCM_LINE_M의 라인의 ELECTRODE_TYPE가 다름
                --AND A.ELECTRODE_TYPE                = LN.ELECTRODE_TYPE
                --AND LN.OPERATION_ID                 = ''E2000'' --E20251106-001431 공정코드 추가  
                --기존 것 막음
                --JOIN '+@DBFPPrefix+N'SCM_LINE_M LN WITH (NOLOCK)
                --ON  A.SCM_SITE_ID                   = LN.PLANT_ID + ''-E''
                --AND A.LINE_ID                       = LN.LINE_ID
                --AND A.ELECTRODE_TYPE                = LN.ELECTRODE_TYPE
                --AND LN.OPERATION_ID                 = ''E2000'' --E20251106-001431 공정코드 추가  '
                IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
                SET @SQL += N'
                --AND LN.PLANT_ID = '''+@P_PLANT_ID+'''
                AND 1=1 ' ; END;
                SET @SQL += N'
            UNION
            SELECT
                  A.DIVISION_ID
                , A.FROM_DIVISION_ID          AS ORIGIN_FROM_DIVISION_ID -- MST_SITE.SITE_DESCRIPTION
                , A.OPERATION_GROUP
                , A.SCM_SITE_ID
                , A.LINE_ID
                , A.OPERATION_ID
                , LN.FACTORY_ID
                , A.ITEM_ID
                , ''Production'' AS PSI_TYPE
                , A.MEASURE
                , A.PLAN_NAME
                , A.PLAN_START_YYYYMMDD
                , A.PLAN_TYPE
                , A.PLAN_SEQ
                --, PARTIAL_WEEK_NAME
                --, BASIS_START_DATE
                --, BASIS_END_DATE
                , A.YYYYMMDD
                , A.QTY
            FROM W_ZERO_PROD_PLAN AS A
                --2025-12-09 라인정보 가져오는 로직 문제
                JOIN W_LINE LN 
                ON  1=1
                --AND A.SCM_SITE_ID                   = LN.PLANT_ID + ''-E''
                AND A.LINE_ID                       = LN.LINE_ID
            WHERE A.RNUM = 1
        ) AS LIST

            JOIN '+@DBPrefix+N'SCM_MST_SITE AS MST_SITE WITH(NOLOCK)
            ON  LIST.ORIGIN_FROM_DIVISION_ID    = MST_SITE.DIVISION_ID
            AND LIST.FROM_SITE_ID               = MST_SITE.SCM_SITE_ID
            AND MST_SITE.SITE_TYPE              = ''PLANT''

            JOIN '+@DBPrefix+N'[SCP_MST_FINAL_ITEM] AS FI WITH(NOLOCK)
            ON  LIST.ORIGIN_FROM_DIVISION_ID    = FI.DIVISION_ID
            AND LIST.ITEM_ID                    = FI.ITEM_ID
    )
    --INSERT INTO #TMP_W_DAILY_SUM(DIVISION_ID, ORIGIN_DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, SITE_DESCRIPTION, NICK_NAME, ITEM_ID, PSI_TYPE, ELECTRODE_TYPE, CELL_CF, FACTORY_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD, QTY )
    SELECT DIVISION_ID, ORIGIN_DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, SITE_DESCRIPTION, NICK_NAME, ITEM_ID, PSI_TYPE, ELECTRODE_TYPE, CELL_CF, FACTORY_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD, QTY 
    FROM   W_DAILY_SUM
    WHERE  1=1
    ORDER BY ITEM_ID , MEASURE;
    --SELECT * FROM #TMP_W_DAILY_SUM; '+@crlf;
    SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @sql;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    INSERT INTO #TMP_W_DAILY_SUM(DIVISION_ID, ORIGIN_DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, SITE_DESCRIPTION, NICK_NAME, ITEM_ID, PSI_TYPE, ELECTRODE_TYPE, CELL_CF, FACTORY_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD, QTY )
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;

PRINT '--A@X#004--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'2520');

--SELECT '#TMP_W_DAILY_SUM',* FROM #TMP_W_DAILY_SUM;

    --################################
    --yield 및 BOH용 테이블에 데이터 입력한다.
    --################################
    SET @SQL = N'
    INSERT INTO #TMP_W_YIELD_DEFAULT
    SELECT DISTINCT
          WDS.DIVISION_ID
        , WDS.ORIGIN_DIVISION_ID
        , WDS.PLAN_START_YYYYMMDD
        , WDS.OPERATION_GROUP
        , WDS.SCM_SITE_ID
        , WDS.SITE_DESCRIPTION
        , WDS.NICK_NAME
        , WDS.ITEM_ID
        , WDS.ELECTRODE_TYPE
        , WDS.CELL_CF
        , WDS.OPERATION_ID
    FROM  #TMP_W_DAILY_SUM WDS
    WHERE 1=1
    AND   WDS.MEASURE = ''PROD_PLAN_AMEND''';
     --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql @sql;

PRINT '--A@X#0040--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

--SELECT '#TMP_W_YIELD_DEFAULT',* FROM #TMP_W_YIELD_DEFAULT;

    --##################
    -- 전월실적 구분 필요
    --##################
    --전월실적만 있고, 당주의계획에 LINE_ID이 없고, 생산가능 LINE_ID 없는 것 'X' 입력불가 만들것
    --
    SET @SQL = N'
    WITH W_PLAN_RAW AS (
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE--, YYYYMMDD
              ,SUM(CASE WHEN YYYYMMDD< '''+@QUERY_START_YYYYMMDD+N''' THEN QTY ELSE 0 END) AS PROD_RST_QTY
              ,SUM(CASE WHEN YYYYMMDD>= '''+@QUERY_START_YYYYMMDD+N''' THEN QTY ELSE 0 END) AS PROD_PLAN_QTY
        FROM   #TMP_W_DAILY_SUM
        WHERE  MEASURE = ''PROD_PLAN_AMEND'' --@QUERY_START_YYYYMMDD
        GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE--, YYYYMMDD
        --전월실적만 있고, 당주의계획에 LINE_ID이 없고
        HAVING SUM(CASE WHEN YYYYMMDD< '''+@QUERY_START_YYYYMMDD+N''' THEN QTY ELSE 0 END) <> 0
            AND SUM(CASE WHEN YYYYMMDD>= '''+@QUERY_START_YYYYMMDD+N''' THEN QTY ELSE 0 END) = 0
    )
    , W_NO_PLAN_NO_LINE_ID AS (
        SELECT *
        FROM   W_PLAN_RAW WPR
        WHERE  1=1
        --생산가능 라인 없는 실적
        AND    NOT EXISTS (SELECT 1        
                           FROM   #TMP_PLAN_LINE_ITEM PLI 
                           WHERE  PLI.LINE_ID = WPR.LINE_ID
                           AND    PLI.ITEM_ID = WPR.ITEM_ID
                           AND    PLI.PLANT_ID+''-E'' = WPR.SCM_SITE_ID
                           )
    )
    UPDATE WDS
    SET    WDS.PROD_RST_ONLY_YN = ISNULL(WDS.PROD_RST_ONLY_YN,'''')+''^X''
    FROM   #TMP_W_DAILY_SUM  WDS
    JOIN   W_NO_PLAN_NO_LINE_ID NLI 
    ON     NLI.DIVISION_ID = WDS.DIVISION_ID
    AND    NLI.PLAN_START_YYYYMMDD = WDS.PLAN_START_YYYYMMDD
    AND    NLI.PLAN_TYPE = WDS.PLAN_TYPE
    AND    NLI.SEQ = WDS.SEQ
    AND    NLI.OPERATION_GROUP = WDS.OPERATION_GROUP
    AND    NLI.SCM_SITE_ID = WDS.SCM_SITE_ID
    AND    NLI.ITEM_ID = WDS.ITEM_ID
    AND    NLI.LINE_ID = WDS.LINE_ID
    AND    NLI.OPERATION_ID = WDS.OPERATION_ID
    AND    NLI.MEASURE = WDS.MEASURE
    AND    WDS.MEASURE = ''PROD_PLAN_AMEND''
    WHERE  WDS.MEASURE = ''PROD_PLAN_AMEND''
    ;'
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql @SQL;
    PRINT '--SELECT * FROM #TMP_W_DAILY_SUM';    

    --###################################################################
    --전월실적만 있고, 당주의계획에 LINE_ID이 없고, 생산가능 LINE_ID 있는 것 '^' 계획이 없으면 ^ 추가
    --
    SET @SQL = N'
    WITH W_PLAN_RAW AS (
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE--, YYYYMMDD
              ,SUM(CASE WHEN YYYYMMDD< '''+@QUERY_START_YYYYMMDD+N''' THEN QTY ELSE 0 END) AS PROD_RST_QTY
              ,SUM(CASE WHEN YYYYMMDD>= '''+@QUERY_START_YYYYMMDD+N''' THEN QTY ELSE 0 END) AS PROD_PLAN_QTY
        FROM   #TMP_W_DAILY_SUM
        WHERE  MEASURE = ''PROD_PLAN_AMEND'' --@QUERY_START_YYYYMMDD
        GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE--, YYYYMMDD
        HAVING SUM(CASE WHEN YYYYMMDD< '''+@QUERY_START_YYYYMMDD+N''' THEN QTY ELSE 0 END) <> 0
            AND SUM(CASE WHEN YYYYMMDD>= '''+@QUERY_START_YYYYMMDD+N''' THEN QTY ELSE 0 END) = 0
    )
    , W_NO_PLAN_NO_LINE_ID AS (
        SELECT *
        FROM   W_PLAN_RAW WDS
        WHERE  1=1
        AND    EXISTS (SELECT 1        
                       FROM   #TMP_PLAN_LINE_ITEM PLI 
                       WHERE  PLI.LINE_ID = WDS.LINE_ID
                       AND    PLI.ITEM_ID = WDS.ITEM_ID
                       AND    PLI.PLANT_ID+''-E'' = WDS.SCM_SITE_ID
                       )
    )
    UPDATE WDS
    SET    WDS.PROD_RST_ONLY_YN = ISNULL(WDS.PROD_RST_ONLY_YN,'''')+''^A''
    FROM   #TMP_W_DAILY_SUM  WDS
    JOIN   W_NO_PLAN_NO_LINE_ID NLI 
    ON     NLI.DIVISION_ID = WDS.DIVISION_ID
    AND    NLI.PLAN_START_YYYYMMDD = WDS.PLAN_START_YYYYMMDD
    AND    NLI.PLAN_TYPE = WDS.PLAN_TYPE
    AND    NLI.SEQ = WDS.SEQ
    AND    NLI.OPERATION_GROUP = WDS.OPERATION_GROUP
    AND    NLI.SCM_SITE_ID = WDS.SCM_SITE_ID
    AND    NLI.ITEM_ID = WDS.ITEM_ID
    AND    NLI.LINE_ID = WDS.LINE_ID
    AND    NLI.OPERATION_ID = WDS.OPERATION_ID
    AND    NLI.MEASURE = WDS.MEASURE
    AND    WDS.MEASURE = ''PROD_PLAN_AMEND''
    WHERE  WDS.MEASURE = ''PROD_PLAN_AMEND''
    ;'
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql @SQL;
    PRINT '--SELECT * FROM #TMP_W_DAILY_SUM';   

    --SELECT 'PROD_RST_ONLY_YN IS NOT NULL OF #TMP_W_DAILY_SUM',*FROM #TMP_W_DAILY_SUM WHERE PROD_RST_ONLY_YN IS NOT NULL;
    --SELECT 'ALL OF #TMP_W_DAILY_SUM',*FROM #TMP_W_DAILY_SUM WHERE ITEM_ID= 'APCCA2933A'	AND LINE_ID = 'FP_E3M04_C';

    --################################
    --Tact Time용 테이터 입력한다.
    --################################
    SET @SQL = N'
    INSERT INTO #TMP_W_TACT_DEFAULT
    SELECT DISTINCT
          WDS.DIVISION_ID
        , WDS.ORIGIN_DIVISION_ID
        , WDS.PLAN_START_YYYYMMDD
        , WDS.PLAN_TYPE AS PLAN_TYPE
        , WDS.SEQ AS SEQ
        , WDS.OPERATION_GROUP
        , WDS.SCM_SITE_ID
        , WDS.SITE_DESCRIPTION
        , WDS.NICK_NAME
        , WDS.ITEM_ID
        , WDS.ELECTRODE_TYPE
        , WDS.CELL_CF
        , WDS.FACTORY_ID AS FACTORY_ID
        , WDS.LINE_ID AS LINE_ID
        , WDS.OPERATION_ID
    FROM  #TMP_W_DAILY_SUM WDS
    WHERE 1=1
    AND   WDS.MEASURE = ''PROD_PLAN_AMEND''';
    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql @sql;

PRINT '--A@X#004A--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

    --##########################################
    --BOH PIVOT용 테이블에 데이터 입력한다.
    --##########################################
    SET @SQL = N'
    INSERT INTO #TMP_W_BOH_PIVOT
    SELECT DISTINCT
          WDS.DIVISION_ID
        , WDS.ORIGIN_DIVISION_ID
        , WDS.PLAN_START_YYYYMMDD
        , WDS.OPERATION_GROUP
        , WDS.SCM_SITE_ID
        , WDS.SITE_DESCRIPTION
        , WDS.NICK_NAME
        , WDS.ITEM_ID
        , WDS.ELECTRODE_TYPE
        , WDS.CELL_CF
        , WDS.OPERATION_ID
    FROM  #TMP_W_DAILY_SUM WDS
    WHERE 1=1
    AND   WDS.MEASURE = ''PROD_PLAN_AMEND''';

    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @SQL;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql @sql;

PRINT '--A@X#004B--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'3060');


    --##########################################
    --쿼리 다시시작
    --##########################################
    SET @SQL = N'
    ;WITH W_ITEM AS (
        SELECT
            nr AS rnum, 
            ITEM_ID  = LEFT(S.token, CHARINDEX(''^'', S.token) - 1),
            PLANT_ID = SUBSTRING(SUBSTRING(
                                 S.token,
                                 CHARINDEX(''^'', S.token) + 1,
                                 LEN(S.token)
                                 ),1,4)
        FROM STRING_SPLIT('''+@P_ITEM_ID_PLANT_IDS+N''',N'',N'') S
    )
    --SELECT * FROM W_ITEM;
    , W_P_OPT_PLAN_ID AS (
        SELECT
            OPT_PLAN_ID  = LEFT(S.token, CHARINDEX(''^'', S.token) - 1)
        FROM STRING_SPLIT('''+@P_OPT_PLAN_ID+N''', '','') S
    )
    --SELECT * FROM W_P_OPT_PLAN_ID;
    , W_PLANT_ID AS (
        SELECT DISTINCT SUBSTRING(PLANT_ID,1,4) AS PLANT_ID
        FROM W_ITEM
    )
    --SELECT * FROM W_PLANT_ID;
    , W_END_D AS (
        SELECT CONVERT(NVARCHAR(8),DATEADD(DAY, 7, p.horizon_end_date),112) AS horizon_end_date
        FROM   '+@DBPrefix+N'scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = '''+@p_division_id+N'''
        AND    p.plan_id     = (SELECT max(plan_id) FROM '+@DBPrefix+N'scm_mst_plan p WITH(NOLOCK) WHERE division_id = '''+@p_division_id+N''' and plan_id < 9999)
        AND    p.plan_cycle  = ''WEEKLY''
    )
    , W_CALENDAR AS (
        SELECT --TOP 17
               CM.BASIS_YYYYMMDD
              ,CM.BASIS_YYYYMM
              ,CM.WEEK_NAME
              ,CM.PARTIAL_WEEK_NAME
              ,CM.PARTIAL_YN
              ,CM.BASIS_START_DATE
              ,CM.BASIS_END_DATE
              --,CM.*
        FROM   '+@DBPrefix+N'SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
              ,W_END_D WED
        WHERE  1=1
        --AND    CM.DAYOFWEEK = ''MON''
        AND    CM.BASIS_START_DATE>='''+CONVERT(VARCHAR(8),DATEADD(WEEK, -4, @QUERY_START_YYYYMMDD ),112)+''' --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
        AND    CM.BASIS_YYYYMMDD <= WED.HORIZON_END_DATE-- CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112)
    )
    --SELECT * FROM W_CALENDAR;
    , W_PLAN_CALENDAR AS (
        SELECT --TOP 17
               CM.BASIS_YYYYMMDD
              ,CM.BASIS_YYYYMM
              ,CM.WEEK_NAME
              ,CM.PARTIAL_WEEK_NAME
              ,CM.PARTIAL_YN
              ,CM.BASIS_START_DATE
              ,CM.BASIS_END_DATE
              --,CM.*
        FROM   '+@DBPrefix+N'SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
              ,W_END_D WED
        WHERE  1=1
        --AND    CM.DAYOFWEEK = ''MON''
        AND    CM.BASIS_START_DATE>='''+@QUERY_START_YYYYMMDD+N''' --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
        AND    CM.BASIS_YYYYMMDD <= WED.HORIZON_END_DATE-- CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112)
    )
    --SELECT * FROM W_PLAN_CALENDAR;
    , W_LINE AS (
         SELECT DISTINCT LINE_ID, LINE_NAME
         from   '+@DBPrefix+N'SCM_MST_LINE_V
    )
    , W_PLAN_INFO AS
    (
        SELECT
              DIVISION_ID
            , PLAN_NAME
            , PLAN_START_YYYYMMDD = PLAN_NAME
            , PLAN_TYPE
            , PLAN_SEQ
        FROM
        (
            SELECT
                  PLM.DIVISION_ID
                , PLM.PLAN_NAME
                , PLD.PLAN_TYPE
                , PLAN_SEQ
                , ROW_NUMBER() OVER(PARTITION BY PLM.DIVISION_ID ORDER BY PLM.DIVISION_ID , CASE WHEN PLAN_TYPE = ''FN'' THEN ''1'' WHEN PLAN_TYPE = ''SE'' THEN ''2'' WHEN PLAN_TYPE = ''MA'' THEN ''3'' WHEN PLAN_TYPE = ''PR'' THEN ''4'' END , PLAN_SEQ DESC) AS ROW_NUM
            FROM    '+@DBPrefix+N'SCM_MST_PLAN PLM WITH(NOLOCK)
            INNER JOIN '+@DBPrefix+N'SCM_MST_PLAN_DETAIL PLD WITH(NOLOCK)
                ON  PLM.DIVISION_ID = PLD.DIVISION_ID
                AND PLM.PLAN_ID     = PLD.PLAN_ID
            WHERE   1=1
            AND     PLM.PLAN_NAME       = '''+@QUERY_START_YYYYMMDD+''' --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)--CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), ''MON'')), 112) -- 당주월요일
            AND     PLM.PLAN_CYCLE      = ''WEEKLY''
            AND     PLD.PLAN_STATUS     = ''1''
        ) AS PLAN_LIST
        WHERE ROW_NUM = 1
    )
    --SELECT * FROM W_PLAN_INFO
    ------------------
    , W_OPT_PLAN_ID AS (
        SELECT PLAN_ID AS OPT_PLAN_ID
         --, ATTRIBUTE2
        FROM (SELECT 
                  PLAN_ID
                , ATTRIBUTE2
                , ROW_NUMBER() OVER (PARTITION BY ATTRIBUTE2 ORDER BY ATTRIBUTE14 DESC) AS RN
                -- ATTRIBUTE2 PLAN GROUP
                -- ATTRIBUTE14 IF시간
              FROM  '+@DBOPTPrefix+N'SCP_OPT_ENG_PLAN_MASTER M
              WHERE ATTRIBUTE2 = ISNULL('''+@P_PLAN_GROUP+N''' ,'''') -- Find items 에 선택한 값을 파라미터로 받음
              AND   M.PLAN_START_DATE >= CONVERT(VARCHAR(8),DATEADD(WEEK, -4, '''+@QUERY_START_YYYYMMDD+N'''),112)
        ) XX
        WHERE 1=1
        AND RN = 1
    )
    --SELECT * FROM W_OPT_PLAN_ID; '
    SET @SQL += N'
    , W_ALL_DSUM AS (
        SELECT
              DIVISION_ID
            , ORIGIN_DIVISION_ID
            , PLAN_START_YYYYMMDD
            , PLAN_TYPE
            , SEQ
            , OPERATION_GROUP
            , SCM_SITE_ID
            , SITE_DESCRIPTION
            , NICK_NAME
            , ITEM_ID
            , PSI_TYPE
            , ELECTRODE_TYPE
            , CELL_CF
            , FACTORY_ID
            , LINE_ID
            , OPERATION_ID
            , MEASURE
            , YYYYMMDD
            , QTY
        --FROM  W_DAILY_SUM WDS
        FROM  #TMP_W_DAILY_SUM WDS
        --ASSY YIELD
        UNION ALL
        SELECT DISTINCT
              WDS.DIVISION_ID
            , WDS.ORIGIN_DIVISION_ID
            , WDS.PLAN_START_YYYYMMDD
            , ''-'' AS PLAN_TYPE
            , ''-'' AS SEQ
            , WDS.OPERATION_GROUP
            , WDS.SCM_SITE_ID
            , WDS.SITE_DESCRIPTION
            , WDS.NICK_NAME
            , WDS.ITEM_ID
            , WPP.PSI_TYPE
            , WDS.ELECTRODE_TYPE
            , WDS.CELL_CF
            , ''-'' AS FACTORY_ID
            , ''-'' AS LINE_ID
            , WDS.OPERATION_ID
            , WPP.MEASURE
            , WPP.YYYYMMDD
            , WPP.QTY * ( SELECT ISNULL( MIN(Y.CONVERT_QTY_CELL),1)
                            FROM SCP_MST_FINAL_ITEM Y WITH (NOLOCK)
                           WHERE Y.ITEM_ID    = WPP.ITEM_ID
                             AND Y.CONVERT_QTY_CELL IS NOT NULL ) AS QTY
        --FROM  W_DAILY_SUM WDS
        FROM  #TMP_W_YIELD_DEFAULT WDS
        JOIN  #TMP_W_PKG_PLAN WPP 
        ON    WPP.ITEM_ID = WDS.ITEM_ID
        --2026-02-03 아래 PLANT_ID 조건 걸면 안됨 EE 생산된게 타 PLANT로도 나가기 때문에
        --AND   WPP.SCM_SITE_ID = SUBSTRING(WDS.SCM_SITE_ID,1,4)+''-A''
        --날짜는 ASSY YIELD 기준으로 달력전체가 나와야 한다
        /*AND   WAY.YYYYMMDD = WDS.YYYYMMDD*/
        --TACT TIME
        UNION ALL
        SELECT DISTINCT
              WDS.DIVISION_ID
            , WDS.ORIGIN_DIVISION_ID
            , WDS.PLAN_START_YYYYMMDD
            , WDS.PLAN_TYPE AS PLAN_TYPE
            , WDS.SEQ AS SEQ
            , WDS.OPERATION_GROUP
            , WDS.SCM_SITE_ID
            , WDS.SITE_DESCRIPTION
            , WDS.NICK_NAME
            , WDS.ITEM_ID
            , WTT.PSI_TYPE
            , WDS.ELECTRODE_TYPE
            , WDS.CELL_CF
            , WDS.FACTORY_ID AS FACTORY_ID
            , WDS.LINE_ID AS LINE_ID
            , WDS.OPERATION_ID
            , WTT.MEASURE
            , WTT.YYYYMMDD
            , WTT.TACT_TIME AS QTY
        --FROM  W_DAILY_SUM WDS
        FROM  #TMP_W_TACT_DEFAULT WDS
        JOIN  #TMP_W_TACT_TIME WTT 
        --JOIN  #TMP_TACT_TIME WTT 
        ON    WTT.SCM_SITE_ID = WDS.SCM_SITE_ID
        AND   WTT.LINE = WDS.LINE_ID
        AND   WTT.ITEM_ID = WDS.ITEM_ID
        --날짜는 TACT TIME 기준으로 달력전체가 나와야 한다
        /*AND   WTT.YYYYMMDD = WDS.YYYYMMDD*/
        --COATING SPEED
        UNION ALL
        SELECT DISTINCT
              WDS.DIVISION_ID
            , WDS.ORIGIN_DIVISION_ID
            , WDS.PLAN_START_YYYYMMDD
            , WDS.PLAN_TYPE AS PLAN_TYPE
            , WDS.SEQ AS SEQ
            , WDS.OPERATION_GROUP
            , WDS.SCM_SITE_ID
            , WDS.SITE_DESCRIPTION
            , WDS.NICK_NAME
            , WDS.ITEM_ID
            , WSR.PSI_TYPE
            , WDS.ELECTRODE_TYPE
            , WDS.CELL_CF
            , WDS.FACTORY_ID AS FACTORY_ID
            , WDS.LINE_ID AS LINE_ID
            , WDS.OPERATION_ID
            , WSR.MEASURE
            , WSR.YYYYMMDD
            , WSR.COATING_SPEED AS QTY
        --FROM  W_DAILY_SUM WDS
        FROM  #TMP_W_TACT_DEFAULT WDS
        JOIN  #TMP_W_COATING_SPEED WSR 
        ON    WSR.SCM_SITE_ID = WDS.SCM_SITE_ID
        AND   WSR.LINE = WDS.LINE_ID
        AND   WSR.ITEM_ID = WDS.ITEM_ID
        --날짜는 TACT TIME 기준으로 달력전체가 나와야 한다
        /*AND   WSR.YYYYMMDD = WDS.YYYYMMDD*/
        --ASSY YIELD
        UNION ALL
        SELECT DISTINCT
              WDS.DIVISION_ID
            , WDS.ORIGIN_DIVISION_ID
            , WDS.PLAN_START_YYYYMMDD
            , ''-'' AS PLAN_TYPE
            , ''-'' AS SEQ
            , WDS.OPERATION_GROUP
            , WDS.SCM_SITE_ID
            , WDS.SITE_DESCRIPTION
            , WDS.NICK_NAME
            , WDS.ITEM_ID
            , WAY.PSI_TYPE
            , WDS.ELECTRODE_TYPE
            , WDS.CELL_CF
            , ''-'' AS FACTORY_ID
            , ''-'' AS LINE_ID
            , WDS.OPERATION_ID
            , WAY.MEASURE
            , WAY.YYYYMMDD
            , WAY.YIELD AS QTY
        --FROM  W_DAILY_SUM WDS
        FROM  #TMP_W_YIELD_DEFAULT WDS
        JOIN  #TMP_W_ASSY_YIELD WAY 
        ON    WAY.SCM_SITE_ID = WDS.SCM_SITE_ID
        AND   WAY.ITEM_ID = WDS.ITEM_ID
        --날짜는 ASSY YIELD 기준으로 달력전체가 나와야 한다
        /*AND   WAY.YYYYMMDD = WDS.YYYYMMDD*/
        --ELEC YIELD '
    SET @SQL += N'
        UNION ALL
        SELECT DISTINCT
              WDS.DIVISION_ID
            , WDS.ORIGIN_DIVISION_ID
            , WDS.PLAN_START_YYYYMMDD
            , ''-'' AS PLAN_TYPE
            , ''-'' AS SEQ
            , WDS.OPERATION_GROUP
            , WDS.SCM_SITE_ID
            , WDS.SITE_DESCRIPTION
            , WDS.NICK_NAME
            , WDS.ITEM_ID
            , WEY.PSI_TYPE
            , WDS.ELECTRODE_TYPE
            , WDS.CELL_CF
            , ''-'' AS FACTORY_ID
            , ''-'' AS LINE_ID
            , WDS.OPERATION_ID
            , WEY.MEASURE
            , WEY.YYYYMMDD
            , WEY.YIELD AS QTY
        --FROM  W_DAILY_SUM WDS
        FROM  #TMP_W_YIELD_DEFAULT WDS
        JOIN  #TMP_W_ELEC_YIELD WEY 
        ON    WEY.SCM_SITE_ID = WDS.SCM_SITE_ID
        AND   WEY.ITEM_ID = WDS.ITEM_ID
        --날짜는 ELEC YIELD 기준으로 달력전체가 나와야 한다
        /*AND   WEY.YYYYMMDD = WDS.YYYYMMDD*/

        --COATING YIELD '
    SET @SQL += N'
        UNION ALL
        SELECT DISTINCT
              WDS.DIVISION_ID
            , WDS.ORIGIN_DIVISION_ID
            , WDS.PLAN_START_YYYYMMDD
            , ''-'' AS PLAN_TYPE
            , ''-'' AS SEQ
            , WDS.OPERATION_GROUP
            , WDS.SCM_SITE_ID
            , WDS.SITE_DESCRIPTION
            , WDS.NICK_NAME
            , WDS.ITEM_ID
            , WCY.PSI_TYPE
            , WDS.ELECTRODE_TYPE
            , WDS.CELL_CF
            , ''-'' AS FACTORY_ID
            , WCY.LINE_ID
            , WDS.OPERATION_ID
            , WCY.MEASURE
            , WCY.YYYYMMDD
            , WCY.YIELD AS QTY
        --FROM  W_DAILY_SUM WDS
        FROM  #TMP_W_YIELD_DEFAULT WDS
        JOIN  #TMP_W_COATING_YIELD WCY 
        ON    WCY.SCM_SITE_ID = WDS.SCM_SITE_ID
        AND   WCY.ITEM_ID = WDS.ITEM_ID
        --날짜는 ELEC YIELD 기준으로 달력전체가 나와야 한다
        /*AND   WCY.YYYYMMDD = WDS.YYYYMMDD*/


        --HOLD RELEASE '
    SET @SQL += N'
        UNION ALL
        SELECT DISTINCT
              WDS.DIVISION_ID
            , WDS.ORIGIN_DIVISION_ID
            , WDS.PLAN_START_YYYYMMDD
            , ''-'' AS PLAN_TYPE
            , ''-'' AS SEQ
            , WDS.OPERATION_GROUP
            , WDS.SCM_SITE_ID
            , WDS.SITE_DESCRIPTION
            , WDS.NICK_NAME
            , WDS.ITEM_ID
            , WHR.PSI_TYPE
            , WDS.ELECTRODE_TYPE
            , WDS.CELL_CF
            , ''-'' AS FACTORY_ID
            , ''-'' AS LINE_ID
            , WDS.OPERATION_ID
            , WHR.MEASURE
            , WHR.YYYYMMDD
            , (CASE WHEN WHR.YYYYMMDD> '''+@QUERY_START_YYYYMMDD+N''' THEN WHR.Hold_Release_QTY ELSE NULL END)
                * ( SELECT ISNULL( MIN(Y.CONVERT_QTY_CELL),1)
                       FROM SCP_MST_FINAL_ITEM Y WITH (NOLOCK)
                      WHERE Y.ITEM_ID    = WHR.ITEM_ID
                        AND Y.CONVERT_QTY_CELL IS NOT NULL ) AS QTY
        --FROM  W_DAILY_SUM WDS
        FROM  #TMP_W_YIELD_DEFAULT WDS
        JOIN  #TMP_W_HOLD_REL_RAW WHR 
        ON    WHR.ITEM_ID = WDS.ITEM_ID
        --2026-02-10 사이트를 걸면 안됨
        --AND   WHR.SCM_SITE_ID = WDS.SCM_SITE_ID
        --날짜는 HOLD Release 기준으로 가진 것 전체가 나와야 한다
        /*AND   WHR.YYYYMMDD = WDS.YYYYMMDD*/
    )

    --SELECT *
    --FROM   W_ALL_DSUM
    --WHERE  1=1
    ----AND    YYYYMMDD<=''20251229''
    --ORDER BY ITEM_ID , MEASURE;
    --
    , W_WEEKLY_SUM AS (
        SELECT
              DIVISION_ID
            , ORIGIN_DIVISION_ID
            , PLAN_START_YYYYMMDD
            , PLAN_TYPE
            , SEQ
            , OPERATION_GROUP
            , SCM_SITE_ID
            , SITE_DESCRIPTION
            , NICK_NAME
            , ITEM_ID
            , ELECTRODE_TYPE
            , CELL_CF
            , FACTORY_ID
            , LINE_ID
            , OPERATION_ID
            , PSI_TYPE
            , MEASURE
            , CASE WHEN MEASURE = ''PROD_PLAN_AMEND'' THEN WC.PARTIAL_WEEK_NAME ELSE WPC.PARTIAL_WEEK_NAME END AS PARTIAL_WEEK_NAME
            , CASE WHEN MEASURE = ''PROD_PLAN_AMEND'' THEN WC.BASIS_START_DATE  ELSE WPC.BASIS_START_DATE  END AS BASIS_START_DATE
            , CASE WHEN MEASURE = ''PROD_PLAN_AMEND'' THEN WC.BASIS_END_DATE    ELSE WPC.BASIS_END_DATE    END AS BASIS_END_DATE
            --, YYYYMMDD
            , QTY=CASE WHEN ( PSI_TYPE IN ( ''Inventory'',''Yield'' ) OR MEASURE IN (''Tact Time'',''Coating Speed'') ) THEN MAX(QTY) ELSE SUM(QTY) END
        FROM  W_CALENDAR AS WC
        LEFT JOIN  W_ALL_DSUM WDS ON WDS.YYYYMMDD = WC.BASIS_YYYYMMDD     
        LEFT JOIN  #TMP_CALENDAR WPC ON WPC.BASIS_YYYYMMDD = WC.BASIS_YYYYMMDD     
        GROUP BY DIVISION_ID
            , ORIGIN_DIVISION_ID
            , PLAN_START_YYYYMMDD
            , PLAN_TYPE
            , SEQ
            , OPERATION_GROUP
            , SCM_SITE_ID
            , SITE_DESCRIPTION
            , NICK_NAME
            , ITEM_ID
            , ELECTRODE_TYPE
            , CELL_CF
            , FACTORY_ID
            , LINE_ID
            , OPERATION_ID
            , PSI_TYPE
            , MEASURE
            , CASE WHEN MEASURE = ''PROD_PLAN_AMEND'' THEN WC.PARTIAL_WEEK_NAME ELSE WPC.PARTIAL_WEEK_NAME END
            , CASE WHEN MEASURE = ''PROD_PLAN_AMEND'' THEN WC.BASIS_START_DATE  ELSE WPC.BASIS_START_DATE  END
            , CASE WHEN MEASURE = ''PROD_PLAN_AMEND'' THEN WC.BASIS_END_DATE    ELSE WPC.BASIS_END_DATE    END

    )
    --SELECT *
    --FROM   W_WEEKLY_SUM
    ----WHERE LIST.ITEM_ID IN (''APCAN2829A'',''APCCA2947A'',''APCAN1310A'')
    --ORDER BY ITEM_ID , MEASURE'
    SET @SQL += N'
    , W_PIV_SRC AS (
        SELECT DIVISION_ID
              ,ORIGIN_DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,SITE_DESCRIPTION
              ,NICK_NAME
              ,ITEM_ID
              ,ELECTRODE_TYPE
              ,CELL_CF
              ,FACTORY_ID
              ,LINE_ID
              ,OPERATION_ID
              ,PSI_TYPE
              ,MEASURE
              ,BASIS_START_DATE
              ,QTY
        FROM   W_WEEKLY_SUM WWS
        WHERE  1 = 1
        AND    MEASURE IS NOT NULL
    )
    --SELECT *
    --FROM W_PIV_SRC
    --WHERE  1=1
    --AND    BASIS_START_DATE<=''20251229''
    --;
    , W_PIV_RST_WEEK AS (
        SELECT
            DIVISION_ID
            ,ORIGIN_DIVISION_ID
            ,PLAN_START_YYYYMMDD
            ,PLAN_TYPE
            ,SEQ
            ,OPERATION_GROUP
            ,SCM_SITE_ID
            ,SITE_DESCRIPTION, NICK_NAME, ITEM_ID, ELECTRODE_TYPE, CELL_CF, FACTORY_ID, LINE_ID
            ,OPERATION_ID
            ,PSI_TYPE
            ,MEASURE
            ,NULL AS Elec_Site_QTY
            ,NULL AS Assy_Site_QTY
            ,NULL AS Intransit_QTY
            ,NULL AS HD_QTY
            ,'+@PIVOT_COLS_WITH_ALIAS+N'
        FROM W_PIV_SRC WPS
        PIVOT
            (
                SUM(QTY)
                FOR BASIS_START_DATE IN ('+@PIVOT_COLS+N')
            ) AS W_PIV_SRC
        UNION ALL
        --4 BOH 
        SELECT DISTINCT
              WDS.DIVISION_ID
            , WDS.ORIGIN_DIVISION_ID
            , WDS.PLAN_START_YYYYMMDD
            , ''-'' AS PLAN_TYPE
            , ''-'' AS SEQ
            , WDS.OPERATION_GROUP
            , WDS.SCM_SITE_ID
            , WDS.SITE_DESCRIPTION
            , WDS.NICK_NAME
            , WDS.ITEM_ID
            , WDS.ELECTRODE_TYPE
            , WDS.CELL_CF
            , ''-'' AS FACTORY_ID
            , ''-'' AS LINE_ID
            , WDS.OPERATION_ID
            , WBP.PSI_TYPE
            , WBP.MEASURE
            , WBP.Elec_Site_QTY
            , WBP.Assy_Site_QTY
            , WBP.Intransit_QTY
            , WBP.HD_QTY
            , '+@INSERT_NULL_SELECT_COLS+N'
        --FROM  W_DAILY_SUM WDS
        FROM  #TMP_W_BOH_PIVOT WDS
        JOIN  #TMP_W_BOH_PIVOT_RAW WBP
        ON    WBP.ITEM_ID = WDS.ITEM_ID    
        --날짜는 재고가 두줄이 나와서 한줄 처리 한다
        /*AND   WTT.YYYYMMDD = WDS.YYYYMMDD*/
    )
    --SELECT * FROM W_PIV_RST_WEEK; '
    SET @SQL += N'
    , W_MEAS AS (
        SELECT TRIM(''PKG_PLAN       '') AS MEAS, TRIM(''PKG_PLAN         '') AS MALIAS, 01 SORT_SEQ UNION ALL
        SELECT TRIM(''SHIP_PLAN_TOTAL'') AS MEAS, TRIM(''SHIP_PLAN_TOTAL  '') AS MALIAS, 02 SORT_SEQ UNION ALL
        SELECT TRIM(''PROD_PLAN_TOTAL'') AS MEAS, TRIM(''PROD_PLAN_TOTAL  '') AS MALIAS, 03 SORT_SEQ UNION ALL
        SELECT TRIM(''PROD_PLAN_AMEND'') AS MEAS, TRIM(''PROD_PLAN_AMEND1 '') AS MALIAS, 04 SORT_SEQ UNION ALL
        SELECT TRIM(''Coating Speed  '') AS MEAS, TRIM(''Coating Speed1   '') AS MALIAS, 14 SORT_SEQ UNION ALL
        SELECT TRIM(''Tact Time      '') AS MEAS, TRIM(''Tact Time1       '') AS MALIAS, 24 SORT_SEQ UNION ALL
        SELECT TRIM(''INVENTORY_TOTAL'') AS MEAS, TRIM(''INVENTORY_TOTAL  '') AS MALIAS, 34 SORT_SEQ UNION ALL
        SELECT TRIM(''Assy Yield     '') AS MEAS, TRIM(''Assy Yield       '') AS MALIAS, 35 SORT_SEQ UNION ALL
        SELECT TRIM(''Elec Yield     '') AS MEAS, TRIM(''Elec Yield       '') AS MALIAS, 36 SORT_SEQ UNION ALL

		SELECT TRIM(''Coating Yield  '') AS MEAS, TRIM(''Coating Yield    '') AS MALIAS, 37 SORT_SEQ UNION ALL
        SELECT TRIM(''Hold Release   '') AS MEAS, TRIM(''Hold Release     '') AS MALIAS, 38 SORT_SEQ UNION ALL
        SELECT TRIM(''INVENTORY_DIO  '') AS MEAS, TRIM(''INVENTORY_DIO    '') AS MALIAS, 39 SORT_SEQ
    )
    INSERT INTO SCM_SIM_DYN_COLS(
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,PLAN_GROUP
       ,DIVISION_ID
       ,'+@INSCOL +N'
       ,C371 -- ORIGIN_DIVISION_ID
       ,C372 -- OPERATION_GROUP
       ,C373 -- OPERATION_ID
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT '''+@P_SNAP_YYYYMMDD+N'''
       ,'''+@V_REPORT_TITLE_PSI_DETAIL+N'''
       ,'''+@P_PLANT_ID+N'''
       ,'''+@P_PLAN_GROUP+N'''
       ,'''+@P_DIVISION_ID+N'''
       , DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SCM_SITE_ID
       , SITE_DESCRIPTION, NICK_NAME, ITEM_ID, ELECTRODE_TYPE, CELL_CF, FACTORY_ID, LINE_ID, PSI_TYPE
       , MEASURE
       , Elec_Site_QTY AS BOH1
       , Assy_Site_QTY AS BOH2
       , Intransit_QTY AS BOH3
       , HD_QTY AS BOH4
       , BOH5 = CONVERT(NUMERIC(20,10),CASE WHEN NOT ( Elec_Site_QTY IS NULL AND Assy_Site_QTY IS NULL AND Intransit_QTY IS NULL AND HD_QTY IS NULL ) 
                                           THEN 
                                               CONVERT(NUMERIC(20,10),ISNULL(Elec_Site_QTY,0.0))
                                              +CONVERT(NUMERIC(20,10),ISNULL(Assy_Site_QTY,0.0))
                                              +CONVERT(NUMERIC(20,10),ISNULL(Intransit_QTY,0.0))
                                              +CONVERT(NUMERIC(20,10),ISNULL(HD_QTY,0.0)       )
                                           END)
       , NULL AS UNIT
       ,'+@INSERT_SELECT_COLS+N'
       , ORIGIN_DIVISION_ID --C371 -- 
       , OPERATION_GROUP --C372 -- 
       , OPERATION_ID --C373 -- 
       --기본 100,000 에 일련번호 곱하기 1000해서 나중에 저장시 unique key로 사용
       -- FACTORY_ID, LINE_ID SORT 에서 제외 처리
       --, 100000+1000*ROW_NUMBER()OVER(ORDER BY SITE_DESCRIPTION, NICK_NAME, ITEM_ID, ELECTRODE_TYPE, CELL_CF, FACTORY_ID, LINE_ID, MEASURE)       
       , 100000+1000*ROW_NUMBER()OVER(ORDER BY SITE_DESCRIPTION, NICK_NAME, ITEM_ID, ELECTRODE_TYPE, CELL_CF, WM.SORT_SEQ, MEASURE)
       ,'''+@v_online_user+N''' AS CREATED_BY
       ,'''+@v_online_user+N''' AS LAST_UPDATED_BY
    --INTO   ##TMP_W_PIV_RST_WEEK_RESULT
    FROM   W_PIV_RST_WEEK WRW
    LEFT JOIN W_MEAS AS WM ON WM.MEAS = WRW.MEASURE;'+@crlf;
    SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

    --SELECT * FROM SCM_SIM_DYN_COLS

    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @sql;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;

PRINT '--A@X#005--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'3630');

    --SELECT * FROM ##TMP_W_PIV_RST_WEEK_RESULT ORDER BY 1,2,3,4;
    PRINT N'3 AFTER PIVOT :'+CONVERT(NVARCHAR(MAX),SYSDATETIME());

    --  SELECT '-2',* FROM SCM_SIM_DYN_COLS SDC WITH(NOLOCK)
    --   WHERE  1=1
    --   AND    c8='APCAN1724A' AND c12=	'FP_E7M03_A'
    --AND  SDC.SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD
    --AND    SDC.REPORT_TITLE= @V_REPORT_TITLE_PSI_DETAIL
    --AND    LEN(C12) > 4
    --AND    C14 = 'PROD_PLAN_AMEND'
    --AND    ISNULL(SDC.PLANT_ID   ,'') = ISNULL(@P_PLANT_ID   ,'')
    --AND    ISNULL(SDC.PLAN_GROUP ,'') = ISNULL(@P_PLAN_GROUP ,'')
    --AND    ISNULL(SDC.DIVISION_ID,'') = ISNULL(@P_DIVISION_ID,'')
    --AND    CREATED_BY = @v_online_user
    --AND    (SDC.SORT_SEQ1 > 100000 OR SDC.SORT_SEQ1 IS NULL);
    --SET @DUMMY = CONVERT(NVARCHAR(MAX),
    --   (SELECT COUNT(*) FROM SCM_SIM_DYN_COLS SDC
    --    WHERE  SNAP_YYYYMMDD  = @P_SNAP_YYYYMMDD
    --    AND    REPORT_TITLE   = @V_REPORT_TITLE_PSI_DETAIL
    --    AND    SDC.C8 = 'APCCA2879A'
    --    AND    SDC.C14 = 'PROD_PLAN_AMEND'
    --    AND    ISNULL(PLANT_ID   ,'') = ISNULL(@P_PLANT_ID   ,'')
    --    AND    ISNULL(PLAN_GROUP ,'') = ISNULL(@P_PLAN_GROUP ,'')
    --    AND    ISNULL(DIVISION_ID,'') = ISNULL(@P_DIVISION_ID,'')
    --    AND    CREATED_BY = @v_online_user )
    --    );
    --PRINT 'LINE+NUMBER: 2495,COUNT :' + ISNULL(@DUMMY,'NULL');


    --UPDATE DEV1
    SET @SQL = N'
    --표시해야할 ITEM, PROD_PLAN_AMEND, PROD LINE을 가져와서 UPDATE한다.
    WITH W_UPD_RAW AS (
        SELECT DIVISION_ID
              ,ORIGIN_DIVISION_ID  
              ,PLAN_START_YYYYMMDD 
              ,PLAN_TYPE           
              ,SEQ                 
              ,OPERATION_GROUP     
              ,SCM_SITE_ID         
              ,SITE_DESCRIPTION    
              ,NICK_NAME           
              ,ITEM_ID             
              ,PSI_TYPE            
              ,ELECTRODE_TYPE      
              ,CELL_CF             
              ,FACTORY_ID          
              ,LINE_ID             
              ,OPERATION_ID        
              ,MEASURE          
              ,ROW_NUMBER()OVER(PARTITION BY DIVISION_ID,ORIGIN_DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,SCM_SITE_ID
                                   ,SITE_DESCRIPTION,NICK_NAME,ITEM_ID,PSI_TYPE,ELECTRODE_TYPE,CELL_CF,FACTORY_ID,LINE_ID,OPERATION_ID,MEASURE
                               ORDER BY YYYYMMDD) AS RNUM
              --,YYYYMMDD            
              --,QTY                 
              ,PROD_RST_ONLY_YN    
        FROM   #TMP_W_DAILY_SUM WDS
        WHERE  1=1
        AND    WDS.PROD_RST_ONLY_YN IS NOT NULL
    )
    , W_RAW AS (
        SELECT SDC.SNAP_YYYYMMDD
              ,SDC.REPORT_TITLE
              ,SDC.PLANT_ID
              ,SDC.PLAN_GROUP
              ,SDC.DIVISION_ID
              ,SDC.C1
              ,SDC.C2
              ,SDC.C3
              ,SDC.C4
              ,SDC.C5
              ,SDC.C6
              ,SDC.C7
              ,SDC.C8
              ,SDC.C9
              ,SDC.C10
              ,SDC.C11
              ,SDC.C12
              ,SDC.C13
              ,SDC.C14
              ,SDC.C371
              ,SDC.C372
              ,SDC.C373
              ,SDC.SORT_SEQ1
              ,WUR.PROD_RST_ONLY_YN
        FROM   SCM_SIM_DYN_COLS SDC WITH(NOLOCK)
        JOIN   W_UPD_RAW WUR
        ON     1=1
        AND    WUR.RNUM = 1
        AND    WUR.DIVISION_ID = SDC.C1
        AND    WUR.PLAN_START_YYYYMMDD = SDC.C2
        AND    WUR.PLAN_TYPE = SDC.C3
        AND    WUR.SEQ = SDC.C4
        AND    ISNULL(WUR.SCM_SITE_ID,'''') = ISNULL(SDC.C5,'''')
        AND    ISNULL(WUR.SITE_DESCRIPTION,'''') = ISNULL(SDC.C6,'''')
        AND    ISNULL(WUR.NICK_NAME,'''') = ISNULL(SDC.C7,'''')
        AND    WUR.ITEM_ID = SDC.C8
        AND    ISNULL(WUR.ELECTRODE_TYPE,'''') = ISNULL(SDC.C9,'''')
        AND    WUR.CELL_CF = SDC.C10
        AND    ISNULL(WUR.FACTORY_ID,'''') = ISNULL(SDC.C11,'''')
        AND    ISNULL(WUR.LINE_ID,'''') = ISNULL(SDC.C12,'''')
        AND    WUR.PSI_TYPE = SDC.C13
        AND    WUR.MEASURE = SDC.C14
        AND    WUR.ORIGIN_DIVISION_ID = SDC.C371
        AND    WUR.OPERATION_GROUP = SDC.C372
        AND    WUR.OPERATION_ID = SDC.C373
        WHERE  SDC.SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N''' 
        AND    SDC.REPORT_TITLE= '''+@V_REPORT_TITLE_PSI_DETAIL+N''' 
        AND    LEN(C12) > 4
        AND    C14 = ''PROD_PLAN_AMEND''
        AND    ISNULL(SDC.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''' ,'''')
        AND    ISNULL(SDC.PLAN_GROUP ,'''') = ISNULL('''+@P_PLAN_GROUP +N''' ,'''')
        AND    ISNULL(SDC.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''' ,'''')
        AND    CREATED_BY = '''+@v_online_user+N''' 
        --찍어야 할 것 표시
        AND    (SDC.SORT_SEQ1 > 100000 OR SDC.SORT_SEQ1 IS NULL)
    ) ';
    SET @SQL += N'
    UPDATE SDC
    SET    SDC.DEV1 = WR.PROD_RST_ONLY_YN
    FROM   SCM_SIM_DYN_COLS SDC
    JOIN   W_RAW WR
    ON     1=1
    AND    WR.SNAP_YYYYMMDD = SDC.SNAP_YYYYMMDD
    AND    WR.REPORT_TITLE  = SDC.REPORT_TITLE
    AND    WR.PLANT_ID      = SDC.PLANT_ID
    AND    WR.PLAN_GROUP    = SDC.PLAN_GROUP
    AND    WR.DIVISION_ID   = SDC.DIVISION_ID
    AND    WR.C1            = SDC.C1
    AND    WR.C2            = SDC.C2
    AND    WR.C3            = SDC.C3
    AND    WR.C4            = SDC.C4
    AND    WR.C5            = SDC.C5
    AND    WR.C6            = SDC.C6
    AND    WR.C7            = SDC.C7
    AND    WR.C8            = SDC.C8
    AND    WR.C9            = SDC.C9
    AND    WR.C10           = SDC.C10
    AND    WR.C11           = SDC.C11
    AND    WR.C12           = SDC.C12
    AND    WR.C13           = SDC.C13
    AND    WR.C14           = SDC.C14
    AND    WR.C371          = SDC.C371
    AND    WR.C372          = SDC.C372
    AND    WR.C373          = SDC.C373   
    AND    WR.SORT_SEQ1     = SDC.SORT_SEQ1
    ;'+@crlf;
    SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @sql;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;
    PRINT N'생성된 ITEM에 구분자 추가 Count:'+CONVERT(NVARCHAR(MAX),@@rowcount);

--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'3800');

    --#################################################
    --Tact Time 메저 추가하기
    -- 2026-01-13 김준규 Tact Time이 ITEM에 하나도 없을 경우 PROD_PLAN_AMEND의 FACTORY와 PROD LINE을 동일한 이름 갯수 만큼 추가
    --#################################################
    --''DIVISION'' AS C1,''PLAN START YYYYMMDD'' AS C2,''PLAN TYPE'' AS C3,''SEQ'' AS C4,''SUPPLY SITE'' AS C5,
    --''SUPPLY SITE DESC'' AS C6,''NICK NAME'' AS C7,''ITEM ID'' AS C8,''ELECTRODE TYPE'' AS C9,''CONVERT QTY CELL'' AS C10,
    --''FACTORY'' AS C11,''PROD LINE'' AS C12,''PSI TYPE'' AS C13,''MEASURE'' AS C14,''BOH'' AS C15,''BOH'' AS C16,''BOH'' AS C17
    --,''BOH'' AS C18,''BOH'' AS C19,''UNIT'' AS C20
    --,C371 -- ORIGIN_DIVISION_ID
    --,C372 -- OPERATION_GROUP
    --,C373 -- OPERATION_ID
    -- 이것 이전은 Tact Time 1개 나온다.
    -----------------------------------------------------------
    SET @SQL = N'
    --Tact Time이 ITEM에 하나도 없을 경우 PROD_PLAN_AMEND의 FACTORY와 PROD LINE을 동일한 이름 갯수 만큼 추가
    INSERT INTO SCM_SIM_DYN_COLS
    (
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,PLAN_GROUP
       ,DIVISION_ID
       ,C1
       ,C2
       ,C3
       ,C4
       ,C5
       ,C6
       ,C7
       ,C8
       ,C9
       ,C10
       ,C11
       ,C12
       ,C13
       ,C14
       ,C371
       ,C372
       ,C373
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT SNAP_YYYYMMDD
          ,REPORT_TITLE
          ,PLANT_ID
          ,PLAN_GROUP
          ,DIVISION_ID
          ,C1
          ,C2
          ,C3
          ,C4
          ,C5
          ,C6
          ,C7
          ,C8
          ,C9
          ,C10
          ,C11
          ,C12
          ,C13
          ,X AS C14
          ,C371
          ,C372
          ,C373
          ,SORT_SEQ1= 100000+100*ROW_NUMBER() OVER (ORDER BY SDC.SORT_SEQ1)
          ,'''+@v_online_user+N''' AS CREATED_BY
          ,'''+@v_online_user+N''' AS LAST_UPDATED_BY
    FROM   SCM_SIM_DYN_COLS SDC WITH(NOLOCK)
    CROSS JOIN (SELECT ''Tact Time''  AS X ) X
    WHERE  SDC.SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N''' 
    AND    SDC.REPORT_TITLE= '''+@V_REPORT_TITLE_PSI_DETAIL+N''' 
    AND    LEN(C12) > 4
    AND    C14 = ''PROD_PLAN_AMEND''
    AND    ISNULL(SDC.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''' ,'''')
    AND    ISNULL(SDC.PLAN_GROUP ,'''') = ISNULL('''+@P_PLAN_GROUP +N''' ,'''')
    AND    ISNULL(SDC.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''' ,'''')
    AND    CREATED_BY = '''+@v_online_user+N''' 
    --Tact Time이 하나도 없는 경우
    AND    NOT EXISTS (SELECT 1
                       FROM   SCM_SIM_DYN_COLS DSDC WITH(NOLOCK)
                       WHERE  DSDC.SNAP_YYYYMMDD = SDC.SNAP_YYYYMMDD
                       AND    DSDC.REPORT_TITLE= SDC.REPORT_TITLE
                       AND    LEN(DSDC.C12) > 4
                       AND    DSDC.C5 = SDC.C5 --SCM_SITE_ID
                       AND    DSDC.C8 = SDC.C8 --ITEM_ID
                       --아래 풀면 2줄씩 생기기 때문에 풀지말것
                       --AND    DSDC.C14 = SDC.C14 --Measure
                       AND    DSDC.C14  = ''Tact Time''
                       AND    ISNULL(DSDC.PLANT_ID   ,'''') = ISNULL(SDC.PLANT_ID   ,'''')
                       AND    ISNULL(DSDC.PLAN_GROUP ,'''') = ISNULL(SDC.PLAN_GROUP ,'''')
                       AND    ISNULL(DSDC.DIVISION_ID,'''') = ISNULL(SDC.DIVISION_ID,'''')
                       AND    DSDC.CREATED_BY = SDC.CREATED_BY
                       AND    (DSDC.SORT_SEQ1 > 100000 OR DSDC.SORT_SEQ1 IS NULL)
                       )
    AND    (SDC.SORT_SEQ1 > 100000 OR SDC.SORT_SEQ1 IS NULL);'+@crlf;
    SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @sql;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;
    PRINT N'Insert ITEM에 Tact Time 하나도 없는 것 추가 Count:'+CONVERT(NVARCHAR(MAX),@@rowcount);

    --  SELECT '-1',* FROM SCM_SIM_DYN_COLS SDC WITH(NOLOCK)
    --   WHERE  1=1
    --   AND    c8='APCAN1724A' AND c12=	'FP_E7M03_A'
    --AND  SDC.SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD
    --AND    SDC.REPORT_TITLE= @V_REPORT_TITLE_PSI_DETAIL
    --AND    LEN(C12) > 4
    --AND    C14 = 'PROD_PLAN_AMEND'
    --AND    ISNULL(SDC.PLANT_ID   ,'') = ISNULL(@P_PLANT_ID   ,'')
    --AND    ISNULL(SDC.PLAN_GROUP ,'') = ISNULL(@P_PLAN_GROUP ,'')
    --AND    ISNULL(SDC.DIVISION_ID,'') = ISNULL(@P_DIVISION_ID,'')
    --AND    CREATED_BY = @v_online_user
    --AND    (SDC.SORT_SEQ1 > 100000 OR SDC.SORT_SEQ1 IS NULL);

    --#################################################
    --Coating Speed 메저 추가하기
    -- 2026-01-13 김준규 Coating Speed이 ITEM에 하나도 없을 경우 PROD_PLAN_AMEND의 FACTORY와 PROD LINE을 동일한 이름 갯수 만큼 추가
    --#################################################
    --''DIVISION'' AS C1,''PLAN START YYYYMMDD'' AS C2,''PLAN TYPE'' AS C3,''SEQ'' AS C4,''SUPPLY SITE'' AS C5,
    --''SUPPLY SITE DESC'' AS C6,''NICK NAME'' AS C7,''ITEM ID'' AS C8,''ELECTRODE TYPE'' AS C9,''CONVERT QTY CELL'' AS C10,
    --''FACTORY'' AS C11,''PROD LINE'' AS C12,''PSI TYPE'' AS C13,''MEASURE'' AS C14,''BOH'' AS C15,''BOH'' AS C16,''BOH'' AS C17
    --,''BOH'' AS C18,''BOH'' AS C19,''UNIT'' AS C20
    --,C371 -- ORIGIN_DIVISION_ID
    --,C372 -- OPERATION_GROUP
    --,C373 -- OPERATION_ID
    -- 이것 이전은 Coating Speed 1개 나온다.
    -----------------------------------------------------------
    SET @SQL = N'
    --Coating Speed이 ITEM에 하나도 없을 경우 PROD_PLAN_AMEND의 FACTORY와 PROD LINE을 동일한 이름 갯수 만큼 추가
    INSERT INTO SCM_SIM_DYN_COLS
    (
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,PLAN_GROUP
       ,DIVISION_ID
       ,C1
       ,C2
       ,C3
       ,C4
       ,C5
       ,C6
       ,C7
       ,C8
       ,C9
       ,C10
       ,C11
       ,C12
       ,C13
       ,C14
       ,C371
       ,C372
       ,C373
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT SNAP_YYYYMMDD
          ,REPORT_TITLE
          ,PLANT_ID
          ,PLAN_GROUP
          ,DIVISION_ID
          ,C1
          ,C2
          ,C3
          ,C4
          ,C5
          ,C6
          ,C7
          ,C8
          ,C9
          ,C10
          ,C11
          ,C12
          ,C13
          ,X AS C14
          ,C371
          ,C372
          ,C373
          ,SORT_SEQ1= 100000+100*ROW_NUMBER() OVER (ORDER BY SDC.SORT_SEQ1)
          ,'''+@v_online_user+N''' AS CREATED_BY
          ,'''+@v_online_user+N''' AS LAST_UPDATED_BY
    FROM   SCM_SIM_DYN_COLS SDC WITH(NOLOCK)
    CROSS JOIN (SELECT ''Coating Speed'' AS X ) X
    WHERE  SDC.SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N''' 
    AND    SDC.REPORT_TITLE= '''+@V_REPORT_TITLE_PSI_DETAIL+N''' 
    AND    LEN(C12) > 4
    AND    C14 = ''PROD_PLAN_AMEND''
    AND    ISNULL(SDC.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''' ,'''')
    AND    ISNULL(SDC.PLAN_GROUP ,'''') = ISNULL('''+@P_PLAN_GROUP +N''' ,'''')
    AND    ISNULL(SDC.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''' ,'''')
    AND    CREATED_BY = '''+@v_online_user+N''' 
    --Coating Speed 이 하나도 없는 경우
    AND    NOT EXISTS (SELECT 1
                       FROM   SCM_SIM_DYN_COLS DSDC WITH(NOLOCK)
                       WHERE  DSDC.SNAP_YYYYMMDD = SDC.SNAP_YYYYMMDD
                       AND    DSDC.REPORT_TITLE= SDC.REPORT_TITLE
                       AND    LEN(DSDC.C12) > 4
                       AND    DSDC.C5 = SDC.C5 --SCM_SITE_ID
                       AND    DSDC.C8 = SDC.C8 --ITEM_ID
                       --아래 풀면 2줄씩 생기기 때문에 풀지말것
                       --AND    DSDC.C14 = SDC.C14 --Measure
                       AND    DSDC.C14  = ''Coating Speed''
                       AND    ISNULL(DSDC.PLANT_ID   ,'''') = ISNULL(SDC.PLANT_ID   ,'''')
                       AND    ISNULL(DSDC.PLAN_GROUP ,'''') = ISNULL(SDC.PLAN_GROUP ,'''')
                       AND    ISNULL(DSDC.DIVISION_ID,'''') = ISNULL(SDC.DIVISION_ID,'''')
                       AND    DSDC.CREATED_BY = SDC.CREATED_BY
                       AND    (DSDC.SORT_SEQ1 > 100000 OR DSDC.SORT_SEQ1 IS NULL)
                       )
    AND    (SDC.SORT_SEQ1 > 100000 OR SDC.SORT_SEQ1 IS NULL);'+@crlf;
    SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @sql;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;
    PRINT N'Insert ITEM에 Coating Speed 하나도 없는 것 추가 Count:'+CONVERT(NVARCHAR(MAX),@@rowcount);


    --#################################################
    --ITEM에 생산가능 LINE_ID 모두 추가하기
    -- 2026-01-11 김준규 PROD_PLAN_AMEND의 FACTORY와 생산가능 PROD LINE을 추가
    -- 2026-01-15 아래 SCM_MST_ITEM_LINE_ASSIGN_SN 테이블 사용 로직으로 변경 상기 막음
    --#################################################
    --''DIVISION'' AS C1,''PLAN START YYYYMMDD'' AS C2,''PLAN TYPE'' AS C3,''SEQ'' AS C4,''SUPPLY SITE'' AS C5,
    --''SUPPLY SITE DESC'' AS C6,''NICK NAME'' AS C7,''ITEM ID'' AS C8,''ELECTRODE TYPE'' AS C9,''CONVERT QTY CELL'' AS C10,
    --''FACTORY'' AS C11,''PROD LINE'' AS C12,''PSI TYPE'' AS C13,''MEASURE'' AS C14,''BOH'' AS C15,''BOH'' AS C16,''BOH'' AS C17
    --,''BOH'' AS C18,''BOH'' AS C19,''UNIT'' AS C20
    -----------------------------------------------------------
    --
    --DECLARE @PLAN_GROUP NVARCHAR(100)='ESNJ';
    --RETURN;
    SET @SQL += N'
    INSERT INTO SCM_SIM_DYN_COLS
    (
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,PLAN_GROUP
       ,DIVISION_ID
       ,C1
       ,C2
       ,C3
       ,C4
       ,C5
       ,C6
       ,C7
       ,C8
       ,C9
       ,C10
       ,C11
       ,C12
       ,C13
       ,C14
       ,C15
       ,C16
       ,C17
       ,C18
       ,C19
       ,C20
       ,C371
       ,C372
       ,C373
       ,SORT_SEQ1
       ,DEV1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT DISTINCT
           SDC.SNAP_YYYYMMDD
          ,SDC.REPORT_TITLE
          ,SDC.PLANT_ID
          ,SDC.PLAN_GROUP
          ,SDC.DIVISION_ID
          ,SDC.C1
          ,SDC.C2
          ,SDC.C3
          ,SDC.C4
          ,SDC.C5
          ,SDC.C6
          ,SDC.C7
          ,SDC.C8
          ,SDC.C9
          ,SDC.C10
          ,X.FACTORY_ID AS C11
          ,X.LINE_ID AS C12
          ,SDC.C13
          ,SDC.C14
          ,SDC.C15
          ,SDC.C16
          ,SDC.C17
          ,SDC.C18
          ,SDC.C19
          ,SDC.C20
          ,SDC.C371
          ,SDC.C372
          ,SDC.C373
          --데이터가 이상해져서 고정값으로 입력
          ,SORT_SEQ1= 100000+100
          --,SORT_SEQ1= 100000+100*ROW_NUMBER() OVER (ORDER BY SDC.SORT_SEQ1)
          --강제 추가한 LINE_ID는 ^A를 C1 DIVISION_ID자리에 붙혀서 UPDATE 처리시 구분자로 받아서 INSERT를 해야한다.
          ,''^A''
          ,'''+@v_online_user+N''' AS CREATED_BY
          ,'''+@v_online_user+N''' AS LAST_UPDATED_BY
    FROM   (SELECT DISTINCT SNAP_YYYYMMDD,REPORT_TITLE,PLANT_ID,PLAN_GROUP,DIVISION_ID,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16,C17,C18,C19,C20,C371,C372,C373,1 AS SORT_SEQ1 FROM SCM_SIM_DYN_COLS SDC WITH(NOLOCK) 
            WHERE  SDC.SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N'''
            AND    SDC.REPORT_TITLE= '''+@V_REPORT_TITLE_PSI_DETAIL+N'''
            AND    SDC.CREATED_BY = '''+@v_online_user+N'''
            
            AND    SDC.C3 IS NOT NULL  -- C14가 PROD_PLAN_AMEND일 때는 C3(PLAN_TYPE)가 NOT NULL이어야 함
            AND    SDC.C14 IN ( ''PROD_PLAN_AMEND'',''Tact Time'',''Coating Speed'')
            AND    ISNULL(SDC.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''','''')
            AND    ISNULL(SDC.PLAN_GROUP ,'''') = ISNULL('''+@P_PLAN_GROUP +N''','''')
            AND    ISNULL(SDC.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''','''')
            AND    (SDC.SORT_SEQ1 > 100000 OR SDC.SORT_SEQ1 IS NULL)  ) SDC ';
    SET @SQL += N'
    INNER JOIN #TMP_PLAN_LINE_ITEM X ON X.ITEM_ID = SDC.C8 AND CONCAT(X.PLANT_ID, ''-E'') = SDC.C5   -- 2026-03-02   E20260304-000679   김준규       데이터 생성시점에 LINE_ID 추가시 ITEM동일한 경우 모두가 아니라 ITEM 및 PLANT가 동일할 경우 추가
    WHERE NOT EXISTS (
        SELECT 1 
        FROM   SCM_SIM_DYN_COLS DSDC WITH(NOLOCK) 
        WHERE  DSDC.C8      = SDC.C8  --''''ITEM ID'''' AS C8
        AND    DSDC.C5      = SDC.C5  --SCM_SITE_ID
        AND    DSDC.C12     = X.LINE_ID --LINE_ID
        AND    DSDC.SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N'''
        AND    DSDC.REPORT_TITLE= '''+@V_REPORT_TITLE_PSI_DETAIL+N'''
        AND    DSDC.CREATED_BY = '''+@v_online_user+N'''
        AND    DSDC.C3 IS NOT NULL  -- C14가 PROD_PLAN_AMEND일 때는 C3(PLAN_TYPE)가 NOT NULL이어야 함
        AND    DSDC.C14 = SDC.C14 --IN ( ''PROD_PLAN_AMEND'',''Tact Time'',''Coating Speed'') ''PROD_PLAN_AMEND''
        AND    ISNULL(DSDC.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''','''')
        AND    ISNULL(DSDC.PLAN_GROUP ,'''') = ISNULL('''+@P_PLAN_GROUP +N''','''')
        AND    ISNULL(DSDC.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''','''')
        AND    (DSDC.SORT_SEQ1 > 100000 OR DSDC.SORT_SEQ1 IS NULL)
    );'+@crlf;
    SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

    PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @sql;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;
    PRINT N'Insert ITEM에 생산가능 LINE_ID 모두 추가 Count:'+CONVERT(NVARCHAR(MAX),@n_log_count);

    --#################################################
    --모든 Measure 메저 추가하기
    --#################################################
    --모든 Measure 메저 추가하기
    --부족하거나 없는 카테고리 처리
    -- 각 ITEM/MEASURE그룹별 현재 개수 확인 후 부족한 만큼 채우기

    SET @SQL = N'
    -- 각 ITEM/MEASURE그룹별 현재 개수 확인 후 부족한 만큼 채우기
    ;WITH W_MEAS AS (
        SELECT TRIM(''PKG_PLAN       '') AS MEAS, TRIM(''Sale      '') AS MType, TRIM(''PKG_PLAN         '') AS MALIAS, 01 REQ_REC, 01 SORT_SEQ UNION ALL
        SELECT TRIM(''SHIP_PLAN_TOTAL'') AS MEAS, TRIM(''Sale      '') AS MType, TRIM(''SHIP_PLAN_TOTAL  '') AS MALIAS, 01 REQ_REC, 02 SORT_SEQ UNION ALL
        SELECT TRIM(''PROD_PLAN_TOTAL'') AS MEAS, TRIM(''Production'') AS MType, TRIM(''PROD_PLAN_TOTAL  '') AS MALIAS, 01 REQ_REC, 03 SORT_SEQ UNION ALL
        SELECT TRIM(''PROD_PLAN_AMEND'') AS MEAS, TRIM(''Production'') AS MType, TRIM(''PROD_PLAN_AMEND1 '') AS MALIAS, '+CONVERT(NVARCHAR(MAX),@DUPLECATE_REC_NUM)+N' REQ_REC, 04 SORT_SEQ UNION ALL
        SELECT TRIM(''Coating Speed  '') AS MEAS, TRIM(''Production'') AS MType, TRIM(''Coating Speed1   '') AS MALIAS, '+CONVERT(NVARCHAR(MAX),@DUPLECATE_REC_NUM)+N' REQ_REC, 05 SORT_SEQ UNION ALL
        SELECT TRIM(''Tact Time      '') AS MEAS, TRIM(''Production'') AS MType, TRIM(''Tact Time1       '') AS MALIAS, '+CONVERT(NVARCHAR(MAX),@DUPLECATE_REC_NUM)+N' REQ_REC, 06 SORT_SEQ UNION ALL
        SELECT TRIM(''INVENTORY_TOTAL'') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''INVENTORY_TOTAL  '') AS MALIAS, 01 REQ_REC, 07 SORT_SEQ UNION ALL
        SELECT TRIM(''Assy Yield     '') AS MEAS, TRIM(''Yield     '') AS MType, TRIM(''Assy Yield       '') AS MALIAS, 01 REQ_REC, 08 SORT_SEQ UNION ALL
        SELECT TRIM(''Elec Yield     '') AS MEAS, TRIM(''Yield     '') AS MType, TRIM(''Elec Yield       '') AS MALIAS, 01 REQ_REC, 09 SORT_SEQ UNION ALL
        SELECT TRIM(''Hold Release   '') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''Hold Release     '') AS MALIAS, 01 REQ_REC, 10 SORT_SEQ UNION ALL
        SELECT TRIM(''INVENTORY_DIO  '') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''INVENTORY_DIO    '') AS MALIAS, 01 REQ_REC, 11 SORT_SEQ UNION ALL
		SELECT TRIM(''Coating Yield  '') AS MEAS, TRIM(''Yield     '') AS MType, TRIM(''Coating Yield    '') AS MALIAS, '+CONVERT(NVARCHAR(MAX),@DUPLECATE_REC_NUM)+N' REQ_REC, 12 SORT_SEQ
    )  ';
    SET @SQL += N'
    , W_CURRENTCOUNT AS (
        -- 각 그룹별 현재 레코드 수 계산
        SELECT C5 /* SCM_SITE_ID              */
              ,C8 /* ITEM_ID              */
              ,C14 /* MEASURE              */
              ,COUNT(*) AS ExistingCount
              ,MAX(SDC.C1 ) AS C1   /* DIVISION_ID          */
              ,MAX(SDC.C2 ) AS C2   /* PLAN_START_YYYYMMDD  */
              --,MAX(SDC.C5 ) AS C5   /* SCM_SITE_ID          */
              ,MAX(SDC.C6 ) AS C6   /* SITE_DESCRIPTION     */
              ,MAX(SDC.C7 ) AS C7   /* NICK_NAME            */
              ,MAX(SDC.C9 ) AS C9   /* ELECTRODE_TYPE       */
              ,MAX(SDC.C10) AS C10  /* CELL_CF              */
        FROM   SCM_SIM_DYN_COLS SDC --WITH(NOLOCK)
        WHERE  SDC.SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N'''
        AND    SDC.REPORT_TITLE= '''+@V_REPORT_TITLE_PSI_DETAIL+N'''--@P_REPORT_TITLE
        AND    ISNULL(SDC.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''','''')
        AND    ISNULL(SDC.PLAN_GROUP ,'''') = ISNULL('''+@P_PLAN_GROUP +N''','''')
        AND    ISNULL(SDC.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''','''')
        AND    SDC.CREATED_BY = '''+@v_online_user+N'''
        AND    SDC.SORT_SEQ1 > 100000
        GROUP BY C5 /* SCM_SITE_ID */, C8 /* ITEM_ID              */, C14 /* MEASURE              */
    )   ';
    --SELECT * FROM W_CURRENTCOUNT;
    SET @SQL += N'
    , W_ALL_NEED AS (
        -- 모든 ITEM과 CATEGORY의 조합 생성
        SELECT DISTINCT
            WT.C5,
            WT.C8,
            WM.MEAS,
            WM.REQ_REC,
            WM.SORT_SEQ
        FROM W_CURRENTCOUNT WT
        CROSS JOIN W_MEAS WM
    )
    --SELECT *fROM W_ALL_NEED;
    , W_NUMBERS AS (
        SELECT number AS Num
        FROM master.dbo.spt_values 
        WHERE type = ''P'' AND number BETWEEN 1 AND '+CONVERT(NVARCHAR(MAX),@DUPLECATE_REC_NUM)+N'
    )
    , W_NEED_ITEM_MEAS AS (
        -- 없거나 부족한 것 찾기
        SELECT 
            arc.C5,
            arc.C8,
            arc.MEAS,
            arc.REQ_REC,
            arc.SORT_SEQ,
            ISNULL(cd.ExistingCount, 0) AS ExistingCount,
            arc.REQ_REC - ISNULL(cd.ExistingCount, 0) AS NeedToAdd--,
            ,CD.C1,CD.C2,CD.C6,CD.C7,CD.C9,CD.C10,CD.C14
        FROM W_ALL_NEED arc
        LEFT JOIN W_CURRENTCOUNT cd ON arc.C5 = cd.C5 AND arc.C8 = cd.C8 AND arc.MEAS = cd.C14
        WHERE arc.REQ_REC > ISNULL(cd.ExistingCount, 0)
    )
    --SELECT * FROM W_NEED_ITEM_MEAS;
   
    , W_ITEM_DEFAULT AS (
        -- 추가로 입력할 레코드에 DEFAULT로 사용할 값 추출
        SELECT C5 /* SCM_SITE_ID              */
              ,C8 /* ITEM_ID              */
              ,MAX(WR.C1 ) AS C1   /* DIVISION_ID          */
              ,MAX(WR.C2 ) AS C2   /* PLAN_START_YYYYMMDD  */
              --,MAX(WR.C5 ) AS C5   /* SCM_SITE_ID          */
              ,MAX(WR.C6 ) AS C6   /* SITE_DESCRIPTION     */
              ,MAX(WR.C7 ) AS C7   /* NICK_NAME            */
              ,MAX(WR.C9 ) AS C9   /* ELECTRODE_TYPE       */
              ,MAX(WR.C10) AS C10  /* CELL_CF              */
        FROM   W_CURRENTCOUNT WR
        GROUP BY C5,C8
    )   
    --SELECT * FROM W_ITEM_DEFAULT; '
    SET @SQL += N'
    , W_ADD_ITEM_MEAS AS (
    SELECT X.C5
          ,X.C8
          ,X.MEAS AS C14
          ,CASE WHEN X.C1  IS NULL THEN WID.C1  ELSE X.C1  END AS C1
          ,CASE WHEN X.C2  IS NULL THEN WID.C2  ELSE X.C2  END AS C2
          --,CASE WHEN X.C5  IS NULL THEN WID.C5  ELSE X.C5  END AS C5
          ,CASE WHEN X.C6  IS NULL THEN WID.C6  ELSE X.C6  END AS C6
          ,CASE WHEN X.C7  IS NULL THEN WID.C7  ELSE X.C7  END AS C7
          ,CASE WHEN X.C9  IS NULL THEN WID.C9  ELSE X.C9  END AS C9
          ,CASE WHEN X.C10 IS NULL THEN WID.C10 ELSE X.C10 END AS C10
    FROM  (
        SELECT 
            arc.C5,
            arc.C8,
            arc.MEAS
           ,ARC.C1,ARC.C2,ARC.C6,ARC.C7,ARC.C9,ARC.C10,ARC.C14
        FROM W_NEED_ITEM_MEAS arc
        CROSS JOIN W_NUMBERS n
        WHERE n.Num <= ARC.NeedToAdd
    ) X
    LEFT JOIN W_ITEM_DEFAULT WID ON WID.C5 = X.C5 AND WID.C8 = X.C8
    )
    --SELECT * FROM W_ADD_ITEM_MEAS;
    INSERT INTO SCM_SIM_DYN_COLS(
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,PLAN_GROUP
       ,DIVISION_ID
       ,C1,C2,C5,C6,C7,C8,C9,C10,C14
       --,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT '''+@P_SNAP_YYYYMMDD+N'''
          ,'''+@V_REPORT_TITLE_PSI_DETAIL+N'''
          ,'''+@P_PLANT_ID+'''
          ,'''+@P_PLAN_GROUP+'''
          ,'''+@P_DIVISION_ID+N'''
          ,T.C1  /* DIVISION_ID          */
          ,T.C2  /* PLAN_START_YYYYMMDD  */
          ,T.C5  /* SCM_SITE_ID          */
          ,T.C6  /* SITE_DESCRIPTION     */
          ,T.C7  /* NICK_NAME            */
          ,T.C8  /* ITEM_ID              */
          ,T.C9  /* ELECTRODE_TYPE       */
          ,T.C10 /* CELL_CF              */
          ,T.C14 /* MEASURE              */
          ,'''+@v_online_user+N''' AS CREATED_BY
          ,'''+@v_online_user+N''' AS LAST_UPDATED_BY
    FROM W_ADD_ITEM_MEAS T ; '+@crlf;
    SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

    --  프린트 및 실행
    SET @DUMMY = @sql;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;

    PRINT N'4 AFTER ADD REQUIRED LINE COUNT:'+CONVERT(NVARCHAR(MAX),@n_log_count)+','+CONVERT(NVARCHAR(MAX),SYSDATETIME());
--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'4370');


    --############################
    --순서 재정렬
    --############################
    --임시 테이블 생성
    DROP TABLE IF EXISTS #TMP_SCM_SIM_DYN_COLS;
    SELECT * INTO #TMP_SCM_SIM_DYN_COLS FROM SCM_SIM_DYN_COLS WITH(NOLOCK) WHERE 1=0;
    CREATE CLUSTERED INDEX IX01_TMP_SCM_SIM_DYN_COLS ON #TMP_SCM_SIM_DYN_COLS(SNAP_YYYYMMDD, REPORT_TITLE, PLANT_ID, PLAN_GROUP, DIVISION_ID);

    INSERT INTO #TMP_SCM_SIM_DYN_COLS
    SELECT *
    FROM   SCM_SIM_DYN_COLS SDC WITH(NOLOCK)
    WHERE  SDC.SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD
    AND    SDC.REPORT_TITLE= @V_REPORT_TITLE_PSI_DETAIL
    AND    ISNULL(SDC.PLANT_ID   ,'') = ISNULL(@P_PLANT_ID   ,'')
    AND    ISNULL(SDC.PLAN_GROUP ,'') = ISNULL(@P_PLAN_GROUP ,'')
    AND    ISNULL(SDC.DIVISION_ID,'') = ISNULL(@P_DIVISION_ID,'')
    AND    CREATED_BY = @v_online_user
    --###########################################################
    AND    EXISTS (SELECT 1
                   FROM   #TMP_ITEM_ID_PLANT_IDS IPI 
                   WHERE  IPI.PLANT_ID+'-E' = SDC.C5 --SCM_SITE_ID
                   AND    IPI.ITEM_ID = SDC.C8 --ITEM_ID
                   )
    --###########################################################
    AND    (SDC.SORT_SEQ1 > 100000 OR SDC.SORT_SEQ1 IS NULL);
    
    SET @DUMMY = CONVERT(NVARCHAR(MAX),@@rowcount);
    PRINT N' INSERT ROWCOUNT:'+ISNULL(@DUMMY,'NULL');

    DELETE SDC
    FROM   SCM_SIM_DYN_COLS SDC
    WHERE  SDC.SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD
    AND    SDC.REPORT_TITLE= @V_REPORT_TITLE_PSI_DETAIL
    AND    ISNULL(SDC.PLANT_ID   ,'') = ISNULL(@P_PLANT_ID   ,'')
    AND    ISNULL(SDC.PLAN_GROUP ,'') = ISNULL(@P_PLAN_GROUP ,'')
    AND    ISNULL(SDC.DIVISION_ID,'') = ISNULL(@P_DIVISION_ID,'')
    AND    CREATED_BY = @v_online_user
    AND    (SDC.SORT_SEQ1 > 100000 OR SDC.SORT_SEQ1 IS NULL);
    
    SET @DUMMY = CONVERT(NVARCHAR(MAX),@@rowcount);
    PRINT N' DELETE ROWCOUNT:'+ISNULL(@DUMMY,'NULL');


    --순서 넘버 재부여
    DECLARE @SQL_SEL NVARCHAR(MAX)=N'';
    DECLARE @COLUMN_NAME NVARCHAR(254);

    SET @SQL_SEL = N'SELECT [SNAP_YYYYMMDD]';
    
    DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
        SELECT QUOTENAME(COLUMN_NAME) --,ORDINAL_POSITION
        FROM   INFORMATION_SCHEMA.COLUMNS
        WHERE  TABLE_NAME = 'SCM_SIM_DYN_COLS'
        AND    ORDINAL_POSITION > 1
        ORDER BY ORDINAL_POSITION;
    
    OPEN cur
    
    FETCH NEXT FROM cur INTO @COLUMN_NAME
    
    WHILE @@FETCH_STATUS = 0 BEGIN
    
        SET @SQL_SEL +=N','+(CASE WHEN @COLUMN_NAME = '[SORT_SEQ1]'       THEN 'RNUM' 
                                  WHEN @COLUMN_NAME = '[C13]'             THEN 'MTypeX' 
                                  WHEN @COLUMN_NAME = '[CREATED_BY]'      THEN ''''+@v_online_user+''' AS [CREATED_BY]' 
                                  WHEN @COLUMN_NAME = '[LAST_UPDATED_BY]' THEN ''''+@v_online_user+''' AS [LAST_UPDATED_BY]' ELSE @COLUMN_NAME END) +@crlf;
    
    	FETCH NEXT FROM cur INTO @COLUMN_NAME
    
    END
    
    CLOSE cur
    DEALLOCATE cur

    SET @SQL = N'
    --2 SORT SEQ 재정리
    ;WITH W_MEAS AS (
        SELECT TRIM(''PKG_PLAN       '') AS MEAS, TRIM(''Sale      '') AS MType, TRIM(''PKG_PLAN         '') AS MALIAS, 01 REQ_REC, 01 SORT_SEQ UNION ALL
        SELECT TRIM(''SHIP_PLAN_TOTAL'') AS MEAS, TRIM(''Sale      '') AS MType, TRIM(''SHIP_PLAN_TOTAL  '') AS MALIAS, 01 REQ_REC, 02 SORT_SEQ UNION ALL
        SELECT TRIM(''PROD_PLAN_TOTAL'') AS MEAS, TRIM(''Production'') AS MType, TRIM(''PROD_PLAN_TOTAL  '') AS MALIAS, 01 REQ_REC, 03 SORT_SEQ UNION ALL
        SELECT TRIM(''PROD_PLAN_AMEND'') AS MEAS, TRIM(''Production'') AS MType, TRIM(''PROD_PLAN_AMEND1 '') AS MALIAS, '+CONVERT(NVARCHAR(MAX),@DUPLECATE_REC_NUM)+N' REQ_REC, 04 SORT_SEQ UNION ALL
        SELECT TRIM(''Coating Speed  '') AS MEAS, TRIM(''Production'') AS MType, TRIM(''Coating Speed1   '') AS MALIAS, '+CONVERT(NVARCHAR(MAX),@DUPLECATE_REC_NUM)+N' REQ_REC, 05 SORT_SEQ UNION ALL
        SELECT TRIM(''Tact Time      '') AS MEAS, TRIM(''Production'') AS MType, TRIM(''Tact Time1       '') AS MALIAS, '+CONVERT(NVARCHAR(MAX),@DUPLECATE_REC_NUM)+N' REQ_REC, 06 SORT_SEQ UNION ALL
        SELECT TRIM(''INVENTORY_TOTAL'') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''INVENTORY_TOTAL  '') AS MALIAS, 01 REQ_REC, 07 SORT_SEQ UNION ALL
        SELECT TRIM(''Hold Release   '') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''Hold Release     '') AS MALIAS, 01 REQ_REC, 08 SORT_SEQ UNION ALL
        SELECT TRIM(''INVENTORY_DIO  '') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''INVENTORY_DIO    '') AS MALIAS, 01 REQ_REC, 09 SORT_SEQ UNION ALL
        SELECT TRIM(''Assy Yield     '') AS MEAS, TRIM(''Yield     '') AS MType, TRIM(''Assy Yield       '') AS MALIAS, 01 REQ_REC, 10 SORT_SEQ UNION ALL
        SELECT TRIM(''Elec Yield     '') AS MEAS, TRIM(''Yield     '') AS MType, TRIM(''Elec Yield       '') AS MALIAS, 01 REQ_REC, 11 SORT_SEQ UNION ALL
		SELECT TRIM(''Coating Yield  '') AS MEAS, TRIM(''Yield     '') AS MType, TRIM(''Coating Yield    '') AS MALIAS, '+CONVERT(NVARCHAR(MAX),@DUPLECATE_REC_NUM)+N' REQ_REC, 12 SORT_SEQ
    )  ';
    SET @SQL += N'
    , W_RAW AS (
        SELECT 
               *
              ,WM.MType AS MTypeX
              ,RNUM = 100000+1000*ROW_NUMBER() OVER (ORDER BY C6,C7,C8,C9,C10,WM.SORT_SEQ /*C14*/,CASE WHEN C12 IS NULL THEN 1 ELSE 0 END,C12)
        FROM   #TMP_SCM_SIM_DYN_COLS SDC --WITH(NOLOCK)
        LEFT JOIN W_MEAS AS WM ON WM.MEAS = SDC.C14
        WHERE  SDC.SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N'''
        AND    SDC.REPORT_TITLE= '''+@V_REPORT_TITLE_PSI_DETAIL+N'''--@P_REPORT_TITLE
        AND    ISNULL(SDC.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''','''')
        AND    ISNULL(SDC.PLAN_GROUP ,'''') = ISNULL('''+@P_PLAN_GROUP +N''','''')
        AND    ISNULL(SDC.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''','''')
        AND    SDC.CREATED_BY = '''+@v_online_user+N'''
        AND    (SDC.SORT_SEQ1 > 100000 OR SDC.SORT_SEQ1 IS NULL)
    )';
    SET @SQL += N''+@SQL_SEL+'
    FROM   W_RAW AS WR
    ORDER BY RNUM;'+@crlf
    SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

    INSERT INTO SCM_SIM_DYN_COLS
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;

    PRINT N'5 AFTER SORT_SEQ 재정렬:'+CONVERT(NVARCHAR(MAX),@n_log_count)+','+CONVERT(NVARCHAR(MAX),SYSDATETIME());

--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'5290');


    --##############################################################
    --UNIT을 CELL로 처리
    --##############################################################
    UPDATE SDC
    SET    C20 = 'CELL'
    FROM   SCM_SIM_DYN_COLS SDC --WITH(NOLOCK)
    WHERE  SDC.SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD
    AND    SDC.REPORT_TITLE= @V_REPORT_TITLE_PSI_DETAIL
    AND    ISNULL(SDC.PLANT_ID   ,'') = ISNULL(@P_PLANT_ID   ,'')
    AND    ISNULL(SDC.PLAN_GROUP ,'') = ISNULL(@P_PLAN_GROUP ,'')
    AND    ISNULL(SDC.DIVISION_ID,'') = ISNULL(@P_DIVISION_ID,'')
    AND    CREATED_BY = @v_online_user
    AND    SDC.SORT_SEQ1 > 100000;
    
    --#####################################################################
    --PROD_PLAN_AMEND,Coating Speed,Tact Time, NULL인것 삭제한다.
    --#####################################################################
    --RETURN;
    SET @SQL = N'
    DELETE SDC
    --SELECT *
    FROM   SCM_SIM_DYN_COLS SDC WITH(NOLOCK) 
    WHERE  SDC.SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N'''
    AND    SDC.REPORT_TITLE= '''+@V_REPORT_TITLE_PSI_DETAIL+N'''
    AND    SDC.C12 IS NULL --LINE_ID 값이 없는 것  삭제
    AND    SDC.C14 IN ( ''PROD_PLAN_AMEND'', ''Tact Time'', ''Coating Speed'' )
    AND    ISNULL(SDC.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''','''')
    AND    ISNULL(SDC.PLAN_GROUP ,'''') = ISNULL('''+@P_PLAN_GROUP +N''','''')
    AND    ISNULL(SDC.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''','''')
    AND    SDC.CREATED_BY = '''+@v_online_user+N'''
    AND    (SDC.SORT_SEQ1 > 100000 OR SDC.SORT_SEQ1 IS NULL) ; '+@crlf;
    SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

    --  프린트 및 실행
    SET @DUMMY = @sql;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;

    PRINT N'Delete for no having line id Count:'+CONVERT(NVARCHAR(MAX),@n_log_count)+','+CONVERT(NVARCHAR(MAX),SYSDATETIME());
    
    --#####################################################################
    --LINE_ID 강제 추가된 라인에 대하여 ^A 를 DIVISION_ID 자리에 넣는다.
    --#####################################################################
    SET @SQL = N'
    UPDATE SDC
    SET    C6 = ISNULL(C6,'''')+DEV1
    --SELECT *
    FROM   SCM_SIM_DYN_COLS SDC WITH(NOLOCK) 
    WHERE  SDC.SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N'''
    AND    SDC.REPORT_TITLE= '''+@V_REPORT_TITLE_PSI_DETAIL+N'''
    AND    SDC.DEV1 = ''^A''
    AND    SDC.C3 IS NOT NULL -- DB 추출
    AND    SDC.C14 = ''PROD_PLAN_AMEND''
    AND    ISNULL(SDC.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''','''')
    AND    ISNULL(SDC.PLAN_GROUP ,'''') = ISNULL('''+@P_PLAN_GROUP +N''','''')
    AND    ISNULL(SDC.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''','''')
    AND    SDC.CREATED_BY = '''+@v_online_user+N'''
    AND    (SDC.SORT_SEQ1 > 100000 OR SDC.SORT_SEQ1 IS NULL) ; '+@crlf;
    SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

    --  프린트 및 실행
    SET @DUMMY = @sql;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;

    PRINT N'MAKE ADD LINE MARK Count:'+CONVERT(NVARCHAR(MAX),@n_log_count)+','+CONVERT(NVARCHAR(MAX),SYSDATETIME());
    
    --#########################
    --Resource 처리
    --#########################
    --DECLARE @TotalRows INT = (SELECT COUNT(*) FROM #TMP_WEEK_NAME_Resource);
    PRINT '@TotalRows Resource:'+CONVERT(NVARCHAR(MAX),@TotalRows);
    
    DECLARE @INSERT_SELECT_Resource_FILL_VAL_BLANK NVARCHAR(MAX) = '';
    SELECT @INSERT_SELECT_Resource_FILL_VAL_BLANK = STRING_AGG(QUOTENAME(FILL_VAL_BLANK,''''), ',') WITHIN GROUP (ORDER BY RNUM)
    FROM   #TMP_WEEK_NAME_LABEL;

    DECLARE @INSERT_SELECT_Resource1 NVARCHAR(MAX) = '';
    SELECT @INSERT_SELECT_Resource1 = STRING_AGG(QUOTENAME(BASIS_WQTY_WEEK,''''), ',') WITHIN GROUP (ORDER BY RNUM)
    FROM   #TMP_WEEK_NAME_LABEL;

    --######################################################
    --Resource1 Resource1
    --######################################################
    DECLARE @INS_Resource1 NVARCHAR(MAX) = '';
    SET @i =21;
    WHILE @i <= (@TotalRows-1+21) --한개가 남아서 -1처리   --@TotalRows --WEEK WQTY1~이런 형태 입력되는 것
    BEGIN
        IF @i = 21
            SET @INS_Resource1 = 'C' + CAST(@i AS NVARCHAR(10));
        ELSE
            SET @INS_Resource1 = @INS_Resource1 + ', C' + CAST(@i AS NVARCHAR(10));

        SET @i = @i + 1;
    END
    PRINT '@INS_Resource1:'+@INS_Resource1;

    DECLARE @SQL_Resource1 NVARCHAR(MAX) = '';
    SET @SQL_Resource1 = N'
    INSERT INTO SCM_SIM_DYN_COLS(
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,PLAN_GROUP
       ,DIVISION_ID
       ,C18,C19,C20
       ,'+@INS_Resource1 +'
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT '''+@P_SNAP_YYYYMMDD+N'''
       ,'''+@V_REPORT_TITLE_RESOURCE+N'''
       ,'''+@P_PLANT_ID+'''
       ,'''+@P_PLAN_GROUP+'''
       ,'''+@P_DIVISION_ID+N'''
       ,''Change Time'' AS C18,''Resource'' AS C19,''TYPE'' AS C20
       ,'+@INSERT_SELECT_Resource1+'
       , 10 AS SORT_SEQ1
       ,'''+@v_online_user+N'''
       ,'''+@v_online_user+N''' ';

    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @SQL_Resource1;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql @SQL_Resource1;

    --#########################################
    --Resource3 Resource3
    --######################################################
    --DECLARE @TotalRows INT = (SELECT COUNT(*) FROM #TMP_WEEK_NAME_Resource3);
    PRINT '@TotalRows Resource3:'+CONVERT(NVARCHAR(MAX),@TotalRows);
    DECLARE @INSERT_SELECT_Resource3 NVARCHAR(MAX) = '';

    SELECT @INSERT_SELECT_Resource3 = STRING_AGG(QUOTENAME(PARTIAL_WEEK_NAME,''''), ',') WITHIN GROUP (ORDER BY RNUM)
    FROM   #TMP_WEEK_NAME_LABEL;

    DECLARE @INS_Resource3 NVARCHAR(MAX) = '';
    --C21부터 184개 넣어야 한다.
    SET @i =21;
    WHILE @i <= (@TotalRows-1+21) --한개가 남아서 -1처리 
    BEGIN
        IF @i = 21
            SET @INS_Resource3 = 'C' + CAST(@i AS NVARCHAR(10));
        ELSE
            SET @INS_Resource3 = @INS_Resource3 + ', C' + CAST(@i AS NVARCHAR(10));

        SET @i = @i + 1;
    END
    --PRINT '@INS_Resource3:'+@INS_Resource3;


    DECLARE @SQL_Resource3 NVARCHAR(MAX) = '';
    SET @SQL_Resource3 = N'
    INSERT INTO SCM_SIM_DYN_COLS(
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,PLAN_GROUP
       ,DIVISION_ID
       ,C18,C19,C20
       ,'+@INS_Resource3 +'
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT '''+@P_SNAP_YYYYMMDD+N'''
       ,'''+@V_REPORT_TITLE_RESOURCE+N'''
       ,'''+@P_PLANT_ID+'''
       ,'''+@P_PLAN_GROUP+'''
       ,'''+@P_DIVISION_ID+N'''
       ,''Change Time'' AS C18,''Resource'' AS C19,''TYPE'' AS C20
       ,'+@INSERT_SELECT_Resource3+'
       ,20 SORT_SEQ1
       ,'''+@v_online_user+N'''
       ,'''+@v_online_user+N''' ';

    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @SQL_Resource3;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql @SQL_Resource3;


    SET @SQL = N'
    --Resource 처리
    ;WITH W_ITEM AS (
        SELECT
            nr AS rnum, 
            ITEM_ID  = LEFT(S.token, CHARINDEX(''^'', S.token) - 1),
            PLANT_ID = SUBSTRING(SUBSTRING(
                                 S.token,
                                 CHARINDEX(''^'', S.token) + 1,
                                 LEN(S.token)
                                 ),1,4)
        FROM STRING_SPLIT('''+@P_ITEM_ID_PLANT_IDS+N''',N'',N'') S
    )
    --SELECT * FROM W_ITEM;
    , W_PLANT_ID AS (
        SELECT DISTINCT SUBSTRING(PLANT_ID,1,4) AS PLANT_ID
        FROM W_ITEM
    )
    --SELECT * FROM W_PLANT_ID;
    , W_P_OPT_PLAN_ID AS (
        SELECT
            OPT_PLAN_ID  = LEFT(S.token, CHARINDEX(''^'', S.token) - 1)
        FROM STRING_SPLIT('''+@P_OPT_PLAN_ID+N''', '','') S
    )
    --SELECT * FROM W_P_OPT_PLAN_ID;
    , W_END_D AS (
        SELECT CONVERT(NVARCHAR(8),DATEADD(DAY, 7, p.horizon_end_date),112) AS horizon_end_date
        FROM   '+@DBPrefix+N'scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = '''+@p_division_id+N'''
        AND    p.plan_id     = (SELECT max(plan_id) FROM '+@DBPrefix+N'scm_mst_plan p WITH(NOLOCK) WHERE division_id = '''+@p_division_id+N''' and plan_id < 9999)
        AND    p.plan_cycle  = ''WEEKLY''
    )
    , W_CALENDAR AS (
        SELECT --TOP 17
               CM.BASIS_YYYYMMDD
              ,CM.BASIS_YYYYMM
              ,CM.WEEK_NAME
              ,CM.PARTIAL_WEEK_NAME
              ,CM.PARTIAL_YN
              ,CM.BASIS_START_DATE
              ,CM.BASIS_END_DATE
              --,CM.*
        FROM   '+@DBPrefix+N'SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
              ,W_END_D WED
        WHERE  1=1
        --AND    CM.DAYOFWEEK = ''MON''
        AND    CM.BASIS_START_DATE>='''+CONVERT(VARCHAR(8),DATEADD(WEEK, -4, @QUERY_START_YYYYMMDD ),112)+N''' --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
        AND    CM.BASIS_YYYYMMDD <= WED.HORIZON_END_DATE-- CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112)
    )
    --SELECT * FROM W_CALENDAR;
    , W_LINE AS (
         SELECT DISTINCT LINE_ID, LINE_NAME
         from   '+@DBPrefix+N'SCM_MST_LINE_V
    )
    , W_OPT_PLAN_ID AS (
        SELECT PLAN_ID AS OPT_PLAN_ID
         --, ATTRIBUTE2
        FROM (SELECT 
                  PLAN_ID
                , ATTRIBUTE2
                , ROW_NUMBER() OVER (PARTITION BY ATTRIBUTE2 ORDER BY ATTRIBUTE14 DESC) AS RN
                -- ATTRIBUTE2 PLAN GROUP
                -- ATTRIBUTE14 IF시간
              FROM  '+@DBOPTPrefix+N'SCP_OPT_ENG_PLAN_MASTER M
              WHERE ATTRIBUTE2 = ISNULL('''+@P_PLAN_GROUP+N''' ,'''') -- Find items 에 선택한 값을 파라미터로 받음
              AND   M.PLAN_START_DATE >= CONVERT(VARCHAR(8),DATEADD(WEEK, -4, '''+@QUERY_START_YYYYMMDD+N'''),112)
        ) XX
        WHERE 1=1
        AND RN = 1
    )
    --SELECT * FROM W_OPT_PLAN_ID;
    , W_TYPE_RAW AS (
        SELECT TRIM(''CAPA      '') AS RTYPE, ''1'' AS SEQ1 UNION
        SELECT TRIM(''LOAD      '') AS RTYPE, ''2'' AS SEQ1 UNION
        SELECT TRIM(''CHG_HOUR  '') AS RTYPE, ''3'' AS SEQ1 UNION
        SELECT TRIM(''LOAD_RATIO'') AS RTYPE, ''4'' AS SEQ1 
    )
    , W_LINE_ID AS (
        SELECT DISTINCT C5 AS SCM_SITE_ID, C12 AS LINE_ID '; --C5 SCM_SITE_ID, 12 LINE_ID,  
    SET @SQL += N'FROM   [SCM_SIM_DYN_COLS] AS SDC WITH(NOLOCK)'  + @crlf;
    SET @SQL += N'WHERE  SNAP_YYYYMMDD = '''+ (CASE WHEN ISNULL(@P_SNAP_YYYYMMDD,'')='' THEN CONVERT(NVARCHAR(8),GETDATE(),112) ELSE @P_SNAP_YYYYMMDD END) +N''''+ @crlf ;
    SET @SQL += N'--''아래 리포트 이름은 RESOURCE가 아닌 PSI DETAIL 임 주의 필요'''+ @crlf;
    SET @SQL += N'AND    REPORT_TITLE = '''+ @V_REPORT_TITLE_PSI_DETAIL +N''''+ @crlf;
    IF ISNULL(@P_PLANT_ID,'')<>'' BEGIN
    SET @SQL += N'AND    PLANT_ID = '''+ @P_PLANT_ID +N''''+ @crlf; END;
    IF ISNULL(@P_PLAN_GROUP,'')<>'' BEGIN
    SET @SQL += N'AND    PLAN_GROUP = '''+ @P_PLAN_GROUP +N''''+ @crlf; END;
    IF ISNULL(@P_DIVISION_ID,'')<>'' BEGIN
    SET @SQL += N'AND    DIVISION_ID = '''+ @P_DIVISION_ID +N''''+ @crlf; END;
    SET @SQL += N'AND    C14 = ''PROD_PLAN_AMEND'''+ @crlf;
    SET @SQL += N'AND    LEN(C12)>1'+ @crlf;
    SET @SQL += N'AND    SDC.CREATED_BY = '''+@v_online_user+N''''+ @crlf;
    SET @SQL += N'AND    SORT_SEQ1 > 100'+ @crlf;
    SET @SQL += N'
    )
    , W_CAPA_RAW AS (
        SELECT  SUBSTRING(C2, ((LEN(OPR.SITE) +2)+ 1),  LEN(C2) - (LEN(OPR.SITE) +2)) AS LINE_ID
              , DATE AS YYYYMMDD, CASE WHEN ISNUMERIC(QTY) = 1 THEN TRY_CONVERT(FLOAT,QTY) END AS QTY, CM.BASIS_START_DATE
        FROM    OPTENG_SCP.DBO.SCP_OPT_ENG_OUT_PLAN_RESULT OPR WITH(NOLOCK)
            --JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = OPR.PLAN_ID
            JOIN   #TMP_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = OPR.PLAN_ID

                 JOIN W_CALENDAR AS CM
                 ON  OPR.DATE                  = CM.BASIS_YYYYMMDD

        WHERE   1 =1 
        --AND     OPR.PLAN_ID = @PLAN_ID
        AND     OPR.C1=''upper_limit''
        AND     TYPE=''Capacity''
        AND     ITEM=''LINE''
        --AND     SITE = '''+ @P_PLANT_ID +N'''
    )
    , W_LINE_ID_RST AS (
          SELECT WLI.LINE_ID, WCR.BASIS_START_DATE, WCR.QTY --, WCR.YYYYMMDD
          FROM   W_LINE_ID WLI 
          LEFT JOIN W_CAPA_RAW WCR ON WCR.LINE_ID = WLI.LINE_ID
    )
    --SELECT * FROM W_LINE_ID_RST;
    , W_LINE_ID_CHG_TIME AS (
          SELECT SEGMENT4 AS LINE, avg(convert(float,ATTRIBUTE3)+convert(float,ATTRIBUTE4)) AS  CHG_TIME
          FROM  SCP_OPMZ_LOOKUP_MASTER_DETAIL LMD with(nolock)
          JOIN  W_PLANT_ID WP ON WP.PLANT_ID+N''-E'' = LMD.SEGMENT3
          WHERE LOOKUP_TYPE = N''SCP_OPT_ENG_CONST_SETUP''
          AND   ISNULL(SEGMENT6, ''-'')  = ''-''
          /* AND SEGMENT3 = '''+ @P_PLANT_ID +N'-E'' */
          GROUP BY  SEGMENT4
    )
    --SELECT * FROM W_LINE_ID_CHG_TIME;
    , W_LINE_ID_RST_WEEK AS (
        SELECT
            LINE_ID
            ,'+@PIVOT_COLS_WITH_ALIAS+N'
        FROM W_LINE_ID_RST WPS
        PIVOT
            (
                SUM(QTY)
                FOR BASIS_START_DATE IN ('+@PIVOT_COLS+N')
            ) AS W_LINE_ID_RST
    )
    --SELECT * FROM W_LINE_ID_RST_WEEK;
    INSERT INTO SCM_SIM_DYN_COLS(
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,PLAN_GROUP
       ,DIVISION_ID
       ,C18,C19,C20
       ,'+@INS_Resource1 +N'
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT '''+@P_SNAP_YYYYMMDD+N'''
       ,'''+@V_REPORT_TITLE_RESOURCE+N'''
       ,'''+@P_PLANT_ID+'''
       ,'''+@P_PLAN_GROUP+'''
       ,'''+@P_DIVISION_ID+N'''
       ,WCT.CHG_TIME 
       ,CASE WHEN X.RTYPE = ''CHG_HOUR'' THEN N''형교환 시간'' ELSE LINE_ID END LINE_ID
       --,LINE_ID
       ,X.RTYPE 
       ,'+@INSERT_SELECT_COLS+N'
       , SORT_SEQ1 = 1000 * ROW_NUMBER() OVER (ORDER BY X.LINE_ID,WTR.SEQ1)  
       ,'''+@v_online_user+N'''
       ,'''+@v_online_user+N''' 
    FROM (
        SELECT '''+@P_SNAP_YYYYMMDD+N''' AS SNAP_YYYYMMDD
           ,'''+@V_REPORT_TITLE_RESOURCE+N''' AS REPORT_TITLE_RESOURCE
           ,'''+@P_PLANT_ID+N''' AS PLANT_ID
           ,'''+@P_PLAN_GROUP+N''' AS PLAN_GROUP
           ,'''+@P_DIVISION_ID+N''' AS DIVISION_ID
           ,LINE_ID
           ,RTYPE = (SELECT RTYPE FROM W_TYPE_RAW WHERE SEQ1=1)
           ,'+@INSERT_SELECT_COLS+N'
           , SORT_SEQ1 = 10 + 1000 * ROW_NUMBER() OVER (ORDER BY LINE_ID)  
        FROM W_LINE_ID_RST_WEEK AS WRW
        UNION ALL
        SELECT '''+@P_SNAP_YYYYMMDD+N'''
           ,'''+@V_REPORT_TITLE_RESOURCE+N'''
           ,'''+@P_PLANT_ID+'''
           ,'''+@P_PLAN_GROUP+'''
           ,'''+@P_DIVISION_ID+N'''
           --,CASE WHEN CPT.RTYPE = ''CHG_HOUR'' THEN N''형교환 시간'' ELSE LINE_ID END LINE_ID
           ,LINE_ID
           ,RTYPE = CPT.RTYPE
           ,'+@INSERT_SELECT_Resource_FILL_VAL_BLANK+N'
           ,SORT_SEQ1 = CPT.SEQ1*10 + 1000 * ROW_NUMBER() OVER (ORDER BY LINE_ID)  
        FROM W_LINE_ID_RST_WEEK
        CROSS APPLY (
            --SELECT TRIM(''CAPA      '') AS RTYPE, ''1'' AS SEQ1 UNION
            SELECT TRIM(''LOAD      '') AS RTYPE, ''2'' AS SEQ1 UNION
            SELECT TRIM(''CHG_HOUR  '') AS RTYPE, ''3'' AS SEQ1 UNION
            SELECT TRIM(''LOAD_RATIO'') AS RTYPE, ''4'' AS SEQ1 ) AS CPT
    ) X
    LEFT JOIN W_TYPE_RAW AS WTR ON WTR.RTYPE = X.RTYPE
    LEFT JOIN W_LINE_ID_CHG_TIME AS WCT ON WCT.LINE = X.LINE_ID AND X.RTYPE = ''CHG_HOUR''; '+@crlf;
    SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

    --  프린트 및 실행
    SET @DUMMY = @sql;
    WHILE LEN(@DUMMY) > 0
    BEGIN
        SET @pos = CHARINDEX(@crlf, @DUMMY);
        IF @pos > 0
        BEGIN
            PRINT SUBSTRING(@DUMMY, 1, @pos - 1);
            SET @DUMMY = SUBSTRING(@DUMMY, @pos + 2, LEN(@DUMMY));
        END
        ELSE
        BEGIN
            PRINT @DUMMY;
            SET @DUMMY = '';
        END;
    END;
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;

PRINT '--A@X#008--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
--INSERT DROP_PLOG(PGM_NM,MSG)VALUES(@v_program_name,N'5770');

    
    -- #TEMP Table 삭제
    DROP TABLE IF EXISTS #TMP_CALENDAR; 
    DROP TABLE IF EXISTS #TMP_WEEK_NAME_LABEL;
    DROP TABLE IF EXISTS ##TMP_W_PIV_RST_WEEK_RESULT;
    DROP TABLE IF EXISTS #TMP_W_DAILY_SUM;
    DROP TABLE IF EXISTS #TMP_W_TACT_DEFAULT;
    DROP TABLE IF EXISTS #TMP_W_YIELD_DEFAULT;
    DROP TABLE IF EXISTS #TMP_W_BOH_PIVOT;
    DROP TABLE IF EXISTS #TMP_ITEM_ID_PLANT_IDS;
    DROP TABLE IF EXISTS #TMP_ITEM_ASSY;
    DROP TABLE IF EXISTS #TMP_ELEC_ITEM_ASSY;
    DROP TABLE IF EXISTS #TMP_OPT_PLAN_ID;
    DROP TABLE IF EXISTS #TMP_PARENT_ITEM;
    DROP TABLE IF EXISTS #TMP_SCM_SIM_DYN_COLS;
    DROP TABLE IF EXISTS #W_HOLD_REL_RAW;
    DROP TABLE IF EXISTS #TMP_W_ELEC_YIELD;
    DROP TABLE IF EXISTS #TMP_W_ASSY_YIELD;
	DROP TABLE IF EXISTS #TMP_W_COATING_YIELD;
    DROP TABLE IF EXISTS #TMP_W_COATING_SPEED;
    DROP TABLE IF EXISTS #TMP_W_TACT_TIME;
    DROP TABLE IF EXISTS #TMP_W_PKG_PLAN;
    DROP TABLE IF EXISTS #TMP_W_BOH_PIVOT_RAW;

    --종료 LOG (START)
    SET @v_log_type = 'END';
    SET @v_log_message = '##### END of procedure #####';
    SET @v_description = '@P_SNAP_YYYYMMDD:'+@P_SNAP_YYYYMMDD+',@P_REPORT_TITLE:'+@P_REPORT_TITLE+',@P_MAX_COLS_NUM:'+CONVERT(NVARCHAR(MAX),@P_MAX_COLS_NUM)+',@P_PLANT_ID:'+@P_PLANT_ID+',@P_PLAN_GROUP:'+@P_PLAN_GROUP+',@P_DIVISION_ID:'+@P_DIVISION_ID;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    SET @X_STATUS = 0
    SET @X_MSG = 'Create completed successfully'
    RETURN 0

END TRY
BEGIN CATCH
        SET @CNT = @@ROWCOUNT;
        SET @WORK_SECOND = ERROR_NUMBER();
        SET @v_description = ERROR_MESSAGE();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'END', @CNT, @WORK_SECOND, @v_description, @d_event_date;
        PRINT 'ERROR'
        PRINT ERROR_MESSAGE();

        -- 에러 정보 출력
        --SELECT
        --    ERROR_NUMBER() AS ErrorNumber,
        --    ERROR_SEVERITY() AS ErrorSeverity,
        --    ERROR_STATE() AS ErrorState,
        --    ERROR_PROCEDURE() AS ErrorProcedure,
        --    ERROR_LINE() AS ErrorLine, -- 에러 발생 라인
        --    ERROR_MESSAGE() AS ErrorMessage;

    SET @X_STATUS = ERROR_NUMBER()
    SET @X_MSG = ERROR_MESSAGE()
    RETURN -1

END CATCH

END

